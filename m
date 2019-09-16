Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48A36B3F81
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2019 19:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731941AbfIPRQ3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Sep 2019 13:16:29 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:44495 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729526AbfIPRQ3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Sep 2019 13:16:29 -0400
Received: by mail-io1-f66.google.com with SMTP id j4so748165iog.11
        for <kvm@vger.kernel.org>; Mon, 16 Sep 2019 10:16:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NUJero5UkE6Fljf/Pm1mxTzFIA/90cizF+WESKd6Mss=;
        b=s1+pQC3ihcD+84Cl+sriqk1pZOtccOPGfZAJyxTif7fCYa0kuMj1w/zZcHe4yTI8Jj
         MgWiKcZL5WulHOpW0A22XsOPx9WzZ4wJa6nHwdHAG1i/bFKvwZFa1bwP3QmS1CZ1VwA4
         8V9q7vRDMIu6/xUac9u15AOTO4fJ4kwS6RwGkc5hHCY/FqRLnSG6yqRFdE0EtauOHTMS
         xjUv2hrjZ0OkPyU3B0wtGbRrucKEdBQmaEcTCPegbv8C7VSL2YrgpQb4IymGxE/gmZD0
         g/kbE6AL80zoFUJa/XxGssyfy4aJ19WwdWt+ayyZpWkJ8lDx5YHgSkIhg41MBUy4AK+B
         URPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NUJero5UkE6Fljf/Pm1mxTzFIA/90cizF+WESKd6Mss=;
        b=ErKQxSlMBwkP0OWLf8fzMK413DlOjXTqbnlDoQRKwYB15kppIzMh/HLZGsg/jSB3y3
         kRqc4hU/YDIZSMu1liRkcy6/cDXY4qts7aa4NHI77+Z8HFLSKwvnC9TaNTND6hv2YqTD
         RrwyhFrMENq4j2e7sfge9xtF4a+myd96EQoUFjssXekjYpU/KAb72Yv8CaBxFcwarukx
         MLapUvxvls1GD81pVW7OfCZtRF2m5okd+kP+HQrtjwxi1ckmLbozOSGoj7tSUkKl0K3m
         UJ9OYBcnk4pkK9HLoW8oBEaE6+Ym6grmrj2TZ9lpLe9A3M7+/7sANKFp1UdZ5bk90tBH
         OFIw==
X-Gm-Message-State: APjAAAWkVIbuqtFon5A/xa7rCh0EFLXE2ng2X58XjLrfReHdARsSfNFF
        jiYvoR588gJvvh0pcXHgThhp23TuyAiDHUUrjiEDFg==
X-Google-Smtp-Source: APXvYqx3LYUfAKHGcDtvfqlYxzFFBjLjFGswJF8z3f9bdd3KJ9QJmUib4Dxrf4qVVJx1Zk8Pm6uGG3nf2LxfFtkTcaE=
X-Received: by 2002:a02:b782:: with SMTP id f2mr1135007jam.48.1568654188556;
 Mon, 16 Sep 2019 10:16:28 -0700 (PDT)
MIME-Version: 1.0
References: <20190916162258.6528-1-vkuznets@redhat.com> <20190916162258.6528-2-vkuznets@redhat.com>
In-Reply-To: <20190916162258.6528-2-vkuznets@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 16 Sep 2019 10:16:17 -0700
Message-ID: <CALMp9eQP7Dup+mMuAiShNtH754R_Wwuvf63hezygh3TGR=a9rg@mail.gmail.com>
Subject: Re: [PATCH 1/3] cpu/SMT: create and export cpu_smt_possible()
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-hyperv@vger.kernel.org,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Michael Kelley <mikelley@microsoft.com>,
        Roman Kagan <rkagan@virtuozzo.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 16, 2019 at 9:23 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> KVM needs to know if SMT is theoretically possible, this means it is
> supported and not forcefully disabled ('nosmt=force'). Create and
> export cpu_smt_possible() answering this question.

It seems to me that KVM really just wants to know if the scheduler can
be trusted to avoid violating the invariant expressed by the Hyper-V
enlightenment, NoNonArchitecturalCoreSharing. It is possible to do
that even when SMT is enabled, if the scheduler is core-aware.
Wouldn't it be better to implement a scheduler API that told you
exactly what you wanted to know, rather than trying to infer the
answer from various breadcrumbs?
