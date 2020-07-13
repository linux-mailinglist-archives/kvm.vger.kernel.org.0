Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C82B21DF90
	for <lists+kvm@lfdr.de>; Mon, 13 Jul 2020 20:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbgGMSYM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Jul 2020 14:24:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726675AbgGMSYL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Jul 2020 14:24:11 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1520C061755
        for <kvm@vger.kernel.org>; Mon, 13 Jul 2020 11:24:11 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id l17so3030988iok.7
        for <kvm@vger.kernel.org>; Mon, 13 Jul 2020 11:24:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EYkJT4IJ7durdcl3HAxzOHP9WiK8D09OCIn5mRv/ew0=;
        b=Avvogo0Ehwuuxv7pOUWUsVP9CBTo8Oy9rhoMRMfJXL8CTXWLE6ltS7rvu63OWcfL9+
         zzfMGIbqka1Wlk99wMB8UeyFkHCSEEVe5IpLjsBIyKQkCYPfXri+DgT6gUVPBaX41p4s
         7MANE/HHnaTsa0kqvCg/JRj0LTh1B3K7Zzo5dNsqJufOcP47rRj3PNns7t0E1IDu0Hnh
         X0Ex1ka6fF6hT6nFnbDv79JFqCF+5TdPNjRJ0n5tMWCSRm8dJg3rWWFuV5mZI9oxWFS/
         jrXRerEaQyvbkG0fK4JsGb2A/q/PkE22SHBkvCypKEm8HTU4m73Z2X7IlfHteV4O9yXw
         MfcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EYkJT4IJ7durdcl3HAxzOHP9WiK8D09OCIn5mRv/ew0=;
        b=KyeKpv0g6ONxtAg+XdABK3KSBTj8+QnXEeq0WgwqM4v/Hawc+nXPkAhFGqtT8Sd36H
         m0HLBhVWuN11713pw40cWNS0mOBSDOsqBnjYLKS9V058X5XdJPEQa1fbjrYMmoPDEKX1
         DG46kwVvSnvwm5D7NfwXThn+wRFe7oTLUYVXo84DqjIT7wq+3FBpH5oTQTbhhuaWl8WO
         sxzylLZM8TYB81l2Zlr+ww0RFLxc/VH/jz9ZTdGvUOsrGn96RjX+VYmTLad61yOZ/H5N
         0499GfwqFzVOS76MHA+vqqSizTmcGWj08j3QrCZw4pxhZH18mykUyWLEylmJnPIKb2GP
         0ASA==
X-Gm-Message-State: AOAM532zV04KniUkLxpHTTEVvH7IsO9n02ECHGiqxdZmHOqr768OVngu
        uDnNj1ZDLphlLff2rH8ePmNv2tjlmcoKXdSAdAgS+Q==
X-Google-Smtp-Source: ABdhPJzuW+QbYZgBiMGGDUi132YDZrEQbqRA6a7lx6xxTu6DtSbSx3+CqUb8OrQ2zu/CCblMAetN5Y/1qoWkUST/M+U=
X-Received: by 2002:a6b:c3cf:: with SMTP id t198mr1048147iof.164.1594664649992;
 Mon, 13 Jul 2020 11:24:09 -0700 (PDT)
MIME-Version: 1.0
References: <20200713162206.1930767-1-vkuznets@redhat.com>
In-Reply-To: <20200713162206.1930767-1-vkuznets@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 13 Jul 2020 11:23:59 -0700
Message-ID: <CALMp9eR+DYVH0UZvbNKUNArzPdf1mvAoxakzj++szaVCD0Fcpw@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: nVMX: fix the layout of struct kvm_vmx_nested_state_hdr
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Peter Shier <pshier@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 13, 2020 at 9:22 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> Before commit 850448f35aaf ("KVM: nVMX: Fix VMX preemption timer
> migration") struct kvm_vmx_nested_state_hdr looked like:
>
> struct kvm_vmx_nested_state_hdr {
>         __u64 vmxon_pa;
>         __u64 vmcs12_pa;
>         struct {
>                 __u16 flags;
>         } smm;
> }
>
> The ABI got broken by the above mentioned commit and an attempt
> to fix that was made in commit 83d31e5271ac ("KVM: nVMX: fixes for
> preemption timer migration") which made the structure look like:
>
> struct kvm_vmx_nested_state_hdr {
>         __u64 vmxon_pa;
>         __u64 vmcs12_pa;
>         struct {
>                 __u16 flags;
>         } smm;
>         __u32 flags;
>         __u64 preemption_timer_deadline;
> };
>
> The problem with this layout is that before both changes compilers were
> allocating 24 bytes for this and although smm.flags is padded to 8 bytes,
> it is initialized as a 2 byte value. Chances are that legacy userspaces
> using old layout will be passing uninitialized bytes which will slip into
> what is now known as 'flags'.
>
> Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Fixes: 850448f35aaf ("KVM: nVMX: Fix VMX preemption timer migration")
> Fixes: 83d31e5271ac ("KVM: nVMX: fixes for preemption timer migration")
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>

Oops!

Reviewed-by: Jim Mattson <jmattson@google.com>
