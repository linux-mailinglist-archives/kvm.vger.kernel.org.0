Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7EFB2F89CA
	for <lists+kvm@lfdr.de>; Sat, 16 Jan 2021 01:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728808AbhAPAJs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 19:09:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728781AbhAPAJr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 19:09:47 -0500
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA800C0613D3
        for <kvm@vger.kernel.org>; Fri, 15 Jan 2021 16:09:06 -0800 (PST)
Received: by mail-ot1-x32a.google.com with SMTP id n42so10271400ota.12
        for <kvm@vger.kernel.org>; Fri, 15 Jan 2021 16:09:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=T96/LrmrX4v1El2ImPseDYJC7X8vCHw3ch5hAsrm1bA=;
        b=JgHq9YwcfkarHPYgR2P0+n7SkGpYtgtsd6SnV9KRsUnKQ+BAcHjRdpmSiHIT6lsMOL
         7K1ltiSeekgfO/OdzsON8YHZEboJy8cswSlrGzH7qud3Iec4wRwuVRvKv1O37BWLMzr0
         9R4/24oXo3TAAyO0VhtPA3IGx5mLPbvpEGZBsoWg7bVjdezaLKC/Bq2gC4psRNvcfz+/
         pMTffgA1G7YHF1f5L4APsZlf2WpCM7Zl5Pe2yem0uoxO+kadgw49Lt7PUgIDDWHm2tlX
         rKZstY3UWdNJEvKlJ674kY3lf/JY3XQpoPMJ6pf7vVyUWAO/Du4rbJgfusxe/zv9vaGd
         3P1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=T96/LrmrX4v1El2ImPseDYJC7X8vCHw3ch5hAsrm1bA=;
        b=UDNXTYmBIBrujZA7LdP7+axyVKsOvCKzuPpH9Of26++kgu+J06NWruA93+n/KVcJwy
         8lVt3PlCqMJXWLZfPtWTkv5m/Z15pQFDJ6PWJlv00F5cYFbsANUm8OHHBo0br31i8OWS
         0HpvYPy74GF/JuvUVn5Km5bGi2GmDX81GN7/PkyBJWaRiUFSR2NFNGI9TizXYSw9umo2
         0Ufoc/O+jUfEjfskrgDgixnBzEOJPKP33uK8uBFd00/ieOakhzRwMu3UY8aeBMXlOWJ7
         I7Cvx/E9ftSBnMHvnlc4FK6/QgDgNOzx9M5zm3c84+TO14inIPow58BCN7IcjkXfbT8I
         fysQ==
X-Gm-Message-State: AOAM533UeAh8078Fnsy96IKbo3y44fGwtgyATP4IufVMcYoffepaG/+A
        XOJ8sYpqZWYXXQfP0cuZNwlexGLUPVSFxnpzFPCImQ==
X-Google-Smtp-Source: ABdhPJyX5epGpS79rxarctVemmuXjNYVy1RFTLvTcq4yLzceLtn/p5JPoe5zCaa+iDP/L3UzLB9UZZRrm4vKmT6/Ky4=
X-Received: by 2002:a9d:620d:: with SMTP id g13mr10334421otj.56.1610755745980;
 Fri, 15 Jan 2021 16:09:05 -0800 (PST)
MIME-Version: 1.0
References: <20200903141122.72908-1-mgamal@redhat.com>
In-Reply-To: <20200903141122.72908-1-mgamal@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 15 Jan 2021 16:08:54 -0800
Message-ID: <CALMp9eT7yDGncP-G9v3fC=9PP3FD=uE1SBy1EPBbqkbrWSAXSg@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: VMX: Make smaller physical guest address space
 support user-configurable
To:     Mohammed Gamal <mgamal@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Aaron Lewis <aaronlewis@google.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 3, 2020 at 7:12 AM Mohammed Gamal <mgamal@redhat.com> wrote:
>
> This patch exposes allow_smaller_maxphyaddr to the user as a module parameter.
>
> Since smaller physical address spaces are only supported on VMX, the parameter
> is only exposed in the kvm_intel module.
> Modifications to VMX page fault and EPT violation handling will depend on whether
> that parameter is enabled.
>
> Also disable support by default, and let the user decide if they want to enable
> it.
>
> Signed-off-by: Mohammed Gamal <mgamal@redhat.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 15 ++++++---------
>  arch/x86/kvm/vmx/vmx.h |  3 +++
>  arch/x86/kvm/x86.c     |  2 +-
>  3 files changed, 10 insertions(+), 10 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 819c185adf09..dc778c7b5a06 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -129,6 +129,9 @@ static bool __read_mostly enable_preemption_timer = 1;
>  module_param_named(preemption_timer, enable_preemption_timer, bool, S_IRUGO);
>  #endif
>
> +extern bool __read_mostly allow_smaller_maxphyaddr;

Since this variable is in the kvm module rather than the kvm_intel
module, its current setting is preserved across "rmmod kvm_intel;
modprobe kvm_intel." That is, if set to true, it doesn't revert to
false after "rmmod kvm_intel." Is that the intended behavior?
