Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5800848EF1F
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 18:13:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243803AbiANRNJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 12:13:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235457AbiANRNJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jan 2022 12:13:09 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15947C061574
        for <kvm@vger.kernel.org>; Fri, 14 Jan 2022 09:13:09 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id x83so3253561pgx.4
        for <kvm@vger.kernel.org>; Fri, 14 Jan 2022 09:13:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=O8JciH1zrT2lq0/xMXikypIOOXFn78remSO3U7N452w=;
        b=Otj6jRHrpMqjXccoLZLn90tUuXxqMk9otAEy6+vO7h99H6yXFhY8l4VXGLgp0LC/P0
         cbSpQeEvrNLgHDwMCUbLZrsOf4BLTLl0+jF5Bbn3uWQHBYRyy/4NfSunRXubV6O7F92F
         CUHyWWLxmXxT8GOE7Cg1gvtwfXjCzV+wEg9pyG9qbCMYjUpbdcmoZHxzhr1qpEdeoMuq
         nTMqs0RB/7D6YNNAxMSyxEZT5dxmi8rwTN9iSqxalqtq3cQDL6VY/TLRqBDL1wO7Ggfq
         Jr1HX/VtZDBxki2C3vcqVDxqXD1pfoIOG7EL6bpnEfVIjBn/PVbNQMXFwFhYxtofPrx9
         hmGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=O8JciH1zrT2lq0/xMXikypIOOXFn78remSO3U7N452w=;
        b=qr3INhddHBGA2AZW2KaLWuWvZ1MOiIjIhl9AKio0VyeA8ZrPAingyjtj88XIdsvZNl
         ZGTdgSxpd8g3LgF9F3KqkDKN5IsbXwkBX5qLJxCZ6nrx+wFuX0O6dDUZUN8QrmX7odJB
         Ix80P/wI8QCXQkBJ/Qmmv+OYQWkc1mkNOXgknprbK20BZl5s0GlvJHfU3wqyFtvv9CEP
         b6fnJ7CLXuw6J8fTm83RV5qa/6GXRFquOT88f1wi+tInJK7ZaEmmVEMKI14FdjxP0+qS
         Zhk7YxWv8zwZmTNv27C8lPF8D9Eox4EIjrP2mZ08VNAINziBYUtLS+xb83MgYR1i9Pgn
         06AQ==
X-Gm-Message-State: AOAM530reE28Qy4ePQW63VIMTtedal4G+zp8BjeAm8ebeOYeSiNjnoj5
        bsGOxUGOblXhnzma8tSUW+C8vw==
X-Google-Smtp-Source: ABdhPJyWP2M3ZfcdB/0Vb0MXVcvqfNWydhvBYiRfK91I6MDU6Yz2KEZMtL04VZQHkW0q6IMi0EJeCg==
X-Received: by 2002:a63:8942:: with SMTP id v63mr5155737pgd.471.1642180388417;
        Fri, 14 Jan 2022 09:13:08 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id nl16sm13817660pjb.22.2022.01.14.09.13.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 09:13:07 -0800 (PST)
Date:   Fri, 14 Jan 2022 17:13:04 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Li RongQing <lirongqing@baidu.com>, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, tglx@linutronix.de,
        bp@alien8.de, x86@kernel.org, kvm@vger.kernel.org, joro@8bytes.org,
        peterz@infradead.org
Subject: Re: 
Message-ID: <YeGvILDCvt70CrlU@google.com>
References: <1642157664-18105-1-git-send-email-lirongqing@baidu.com>
 <ee11b876-3042-f7c4-791e-2740130b93d4@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee11b876-3042-f7c4-791e-2740130b93d4@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 14, 2022, Paolo Bonzini wrote:
> On 1/14/22 11:54, Li RongQing wrote:
> > After support paravirtualized TLB shootdowns, steal_time.preempted
> > includes not only KVM_VCPU_PREEMPTED, but also KVM_VCPU_FLUSH_TLB
> > 
> > and kvm_vcpu_is_preempted should test only with KVM_VCPU_PREEMPTED
> > 
> > Signed-off-by: Li RongQing <lirongqing@baidu.com>
> > ---
> > diff with v1:
> > clear the rest of rax, suggested by Sean and peter
> > remove Fixes tag, since no issue in practice
> > 
> >   arch/x86/kernel/kvm.c | 4 ++--
> >   1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
> > index b061d17..45c9ce8d 100644
> > --- a/arch/x86/kernel/kvm.c
> > +++ b/arch/x86/kernel/kvm.c
> > @@ -1025,8 +1025,8 @@ asm(
> >   ".type __raw_callee_save___kvm_vcpu_is_preempted, @function;"
> >   "__raw_callee_save___kvm_vcpu_is_preempted:"
> >   "movq	__per_cpu_offset(,%rdi,8), %rax;"
> > -"cmpb	$0, " __stringify(KVM_STEAL_TIME_preempted) "+steal_time(%rax);"
> > -"setne	%al;"
> > +"movb	" __stringify(KVM_STEAL_TIME_preempted) "+steal_time(%rax), %al;"
> > +"and	$" __stringify(KVM_VCPU_PREEMPTED) ", %rax;"
> 
> This assumes that KVM_VCPU_PREEMPTED is 1.

Ah, right, because technically the compiler is only required to be able to store
'1' and '0' in the boolean.  That said, KVM_VCPU_PREEMPTED is ABI and isn't going
to change, so this could be "solved" with a comment.

> It could also be %eax (slightly cheaper).

Ya.

> Overall, I prefer to leave the code as is using setne.

But that also makes dangerous assumptions: (a) that the return type is bool,
and (b) that the compiler uses a single byte for bools.

If the assumptiong about KVM_VCPU_PREEMPTED being '1' is a sticking point, what
about combining the two to make everyone happy?

	andl	$" __stringify(KVM_VCPU_PREEMPTED) ", %eax
	setnz	%al
