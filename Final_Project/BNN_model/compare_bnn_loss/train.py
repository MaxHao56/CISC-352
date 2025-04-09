import torch
import torch.optim as optim


def train_model(model, loss_fn, X, y, epochs=200, lr=0.1, beta=0.01, reg_fn=None):
    optimizer = optim.Adam(model.parameters(), lr=lr)
    losses = []
    for epoch in range(epochs):
        model.train()
        optimizer.zero_grad()
        output = model(X)
        loss = loss_fn(output, y)
        if reg_fn:
            loss += beta * reg_fn()
        loss.backward()
        optimizer.step()
        losses.append(loss.item())
    return model, losses
