Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21586EF0B5
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2019 23:44:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387416AbfKDWoq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Nov 2019 17:44:46 -0500
Received: from mail-il1-f193.google.com ([209.85.166.193]:34096 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387411AbfKDWop (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Nov 2019 17:44:45 -0500
Received: by mail-il1-f193.google.com with SMTP id p6so3692316ilp.1
        for <kvm@vger.kernel.org>; Mon, 04 Nov 2019 14:44:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BosSwt6Y5g2X1WdDyFlx66n82Jye2IqsZSJ+jA93WXI=;
        b=UYtedd6iAm5A0m/FpWjVgIClIY7yT+bVAbiRZtxKCrxo3kY1fW2/sCvN6Idiaz1Jgh
         uySraGfRh5TVpuh9B0QVGa1dUa0K8kbKgXCWgiVRBjZ05PIB9oz9hIWZ31H+uf9Kx0sV
         dD+Tx0u0u5oHLaVeel5mJawB8s97s2B9tE9Fbnelt175cM5gnsYQo+K2X8r10N7hBbYk
         8ICJTBRq0VzsopAxhLlpKBaTe8BA+lwJqLNAc3o5gVJJlt3a4k0B23J6keQTGEu4vmVq
         zmQH8J27PMZi1f/DhQjREAe/1MmdevcOj2Ri7nYjrT8AA5KcZ1AQbzXlQNPB90ib7i6x
         K55w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BosSwt6Y5g2X1WdDyFlx66n82Jye2IqsZSJ+jA93WXI=;
        b=X/iwUEj3E5xayN7PjvHuQfG6U+CK4vooGB1n02AvL0gjtZhUgUIQLTvtKmU5zATXqq
         yQLR7S+Z3ER0QB6qBlLXv/OEX4YCWZl55rW51GPJzSA9+fDLoK3uPQy7joK2l+wTzAfe
         8UHEjb/xrbz/ApNIdV/sQEpqexdUxnyvCGQ7BnKozUYi1e3nEyo68KfqVF0Sos9zVWC4
         M/Dy3l2HwBVb9VwEoUXNmw0yjLoafN5XY/rq4C8dS+NutDv/jBOS+kLxXQy7p9Bn6I4s
         7lgmnHPnr9856aviYkjlgnfKs8QYgEOba7cTR5NM5VqjV9VWF34VP58B1w0dzGOsqdv/
         dNUg==
X-Gm-Message-State: APjAAAUkw7MImRfWDu8FskKdN9q2+X6bhDweGcGv8ekVzbfe6wqJFvBQ
        hVOOo+RcHqfdSKZpnh1p+3OuNyoLI4y51rtLTRCU4Rr8
X-Google-Smtp-Source: APXvYqws3wBSUpn7NuiVDGh9vHKoQW1Q7jS81PxEWBIckHFUcUCryyqQoF9tMfJXVOe1gKZGmtKwyLQwfkLxggugubQ=
X-Received: by 2002:a92:8983:: with SMTP id w3mr15328918ilk.108.1572907484707;
 Mon, 04 Nov 2019 14:44:44 -0800 (PST)
MIME-Version: 1.0
References: <20191029210555.138393-1-aaronlewis@google.com> <20191029210555.138393-4-aaronlewis@google.com>
In-Reply-To: <20191029210555.138393-4-aaronlewis@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 4 Nov 2019 14:44:33 -0800
Message-ID: <CALMp9eR9E7ia6Gk6VBdC7X5c+xOp7JEsrqMXkiFErmajS_KudQ@mail.gmail.com>
Subject: Re: [PATCH 3/4] kvm: vmx: Rename function find_msr() to vmx_find_msr_index()
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 29, 2019 at 2:06 PM Aaron Lewis <aaronlewis@google.com> wrote:
>
> Rename function find_msr() to vmx_find_msr_index() to share
s/to share/and export it to share/
> implementations between vmx.c and nested.c in an upcoming change.
>
> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> Change-Id: I544afb762ceccb72e950bb62ac2e649a8b0cfec9
Drop the Change-Id.

Reviewed-by: Jim Mattson <jmattson@google.com>
