Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFD4845E11A
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 20:43:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356761AbhKYTrC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Nov 2021 14:47:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242011AbhKYTpB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Nov 2021 14:45:01 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFA7DC06174A;
        Thu, 25 Nov 2021 11:41:49 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1637869308;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IkAKil+p2qnHgN23jhZL2WihzlRyKEYi5otqV5C4W3w=;
        b=2mZ2HFZgyCx1aH8Ms8patf52Az6F8sOXpBhfyFPrIuJZFYpq7WhtBwBxfoO5dmOVXCqfiv
        AmQY5sYimu+N7u+fsfo+J8ceDfNzf0b7pOpIa6t7sxB4TNrOj6BkliNexAdGlRd1oCJ3eE
        F6c+jairPPojeMv2fBJuSUmyrBf5e3MNXH+ypZG9GF5SBkrIJ0tG2JNs6GXnmYnMKxg9TB
        LS7Vkmsfxdb5HmFaM3ppA6g/fvZi7DGH4aO9sSEFiPn0WVZhiaBxqCZRK9+slfkyq0iQIu
        FzlZpTEYZuygBM/oa9mktUfdSJ4ceeBI7SsFkrJXpEwhMfZa3zvzLFo6kJ/c4g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1637869308;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IkAKil+p2qnHgN23jhZL2WihzlRyKEYi5otqV5C4W3w=;
        b=tlpQi0e5/U7qRMvAVVWrw5VcsF8UmyUQYEuEKwC0L8eTzLJzyl/E8Egy+eSH6PnrNsphFl
        7GX3PoTtQWawCJCA==
To:     isaku.yamahata@intel.com, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [RFC PATCH v3 23/59] KVM: x86: Allow host-initiated WRMSR to
 set X2APIC regardless of CPUID
In-Reply-To: <63556f13e9608cbccf97d356be46a345772d76d3.1637799475.git.isaku.yamahata@intel.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
 <63556f13e9608cbccf97d356be46a345772d76d3.1637799475.git.isaku.yamahata@intel.com>
Date:   Thu, 25 Nov 2021 20:41:48 +0100
Message-ID: <87fsrkja4j.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 24 2021 at 16:20, isaku yamahata wrote:
> Let userspace, or in the case of TDX, KVM itself, enable X2APIC even if
> X2APIC is not reported as supported in the guest's CPU model.  KVM
> generally does not force specific ordering between ioctls(), e.g. this
> forces userspace to configure CPUID before MSRs.  And for TDX, vCPUs
> will always run with X2APIC enabled, e.g. KVM will want/need to enable
> X2APIC from time zero.

This is complete crap. Fix the broken user space and do not add
horrible hacks to the kernel.

Thanks,

        tglx
