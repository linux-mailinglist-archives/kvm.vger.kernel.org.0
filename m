Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 828D234A4D5
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 10:46:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbhCZJq2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Mar 2021 05:46:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42282 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230007AbhCZJp4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Mar 2021 05:45:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616751955;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XG6h7spL153kovHcC5yY8ljihAEwgHllcDY8/MH1Mnw=;
        b=eNNBsbcjNu/AaFkiPl7YpYBdRiEoafBoFy+D7GTo94lIjKSb14qsI1taRenyVeUIsyA0QH
        46Wzgs7uXJ6dbCoATI8zz8W+Pt7P97P19X98K5a5kT7zpE9Z4oq2ATvyr+I1KceZezLige
        sLJezCfkgORqHyU2COpbgM/3P/72jAI=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-304-8LR39xFSNs6dyP4mvT5nAw-1; Fri, 26 Mar 2021 05:45:53 -0400
X-MC-Unique: 8LR39xFSNs6dyP4mvT5nAw-1
Received: by mail-ed1-f70.google.com with SMTP id m8so4121336edv.11
        for <kvm@vger.kernel.org>; Fri, 26 Mar 2021 02:45:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=XG6h7spL153kovHcC5yY8ljihAEwgHllcDY8/MH1Mnw=;
        b=l7VlqsbFh4vFIQqnn4yD6cBwyjyXAWKX1tLD82J+RyZQdF1Jx6AUjO7CL+4lkXjrRX
         2nNmaEZGYfxGhJ+CoTzLxS1eptfkVDqIdLNsYB0IwtFRERZicfqMJ6NdEfJhrTrm1pNm
         5d7BRHGzG+ohdXhMl2R/X2LJ/DDigftMpULTcZmuUpcPE8Q9mFL/pkYONheddCK6lWdX
         zu0anC0f8DupVZt4EpDNs0PPO2iQO7HurjDVZbo2PWaE0Daz/wg5BPTLyj1Dw9QFYIV8
         1uWRSYFNqO3HJtCJi5kWkpkKP1iLy3NOo9gnXXPxGHfOYIfNS1R/cTK9hJY5A+2BbGl+
         bQ6A==
X-Gm-Message-State: AOAM532Y+qNeVFVvPQfvgVoWRYexfe23lPQ+T78+Hjt8Z9/s/Hp5iSG7
        w8j/mp5Q/8niY+5OP3S0ER9rjT6Wb8Nv97MFUAZ5sD765TLTBVuVIYEZMFwRwBV99lNvGD4G9jD
        MJuCxx2aj0VdP
X-Received: by 2002:a17:907:7651:: with SMTP id kj17mr14296317ejc.127.1616751952762;
        Fri, 26 Mar 2021 02:45:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyE0k8X5SPvpAMb7ckZxoBBS75iJ7ZWfhqplxSPtWKx+vvCBL/3M4zUeuYeVDlKoAevFSdZew==
X-Received: by 2002:a17:907:7651:: with SMTP id kj17mr14296294ejc.127.1616751952545;
        Fri, 26 Mar 2021 02:45:52 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id va9sm728410ejb.31.2021.03.26.02.45.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 02:45:51 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Dongli Zhang <dongli.zhang@oracle.com>, kvm@vger.kernel.org,
        x86@kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] KVM: x86: remove unused declaration of kvm_write_tsc()
In-Reply-To: <20210326070334.12310-1-dongli.zhang@oracle.com>
References: <20210326070334.12310-1-dongli.zhang@oracle.com>
Date:   Fri, 26 Mar 2021 10:45:50 +0100
Message-ID: <87sg4ickoh.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dongli Zhang <dongli.zhang@oracle.com> writes:

> The kvm_write_tsc() was not used since commit 0c899c25d754 ("KVM: x86: do
> not attempt TSC synchronization on guest writes"). Remove its unused
> declaration.

It's not just not used, it's not present. Let me try to rephrase the
commit message a bit:

"
Commit 0c899c25d754 ("KVM: x86: do not attempt TSC synchronization on
guest writes") renamed kvm_write_tsc() to kvm_synchronize_tsc() and made
it 'static'. Remove the leftover declaration from x86.h

Fixes: 0c899c25d754 ("KVM: x86: do not attempt TSC synchronization on
guest writes")
"

The subject line should probably also get adjusted like
"KVM: x86: remove dangling declaration of kvm_write_tsc()"

>
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> ---
>  arch/x86/kvm/x86.h | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 39eb04887141..9035e34aa156 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -250,7 +250,6 @@ static inline bool kvm_vcpu_latch_init(struct kvm_vcpu *vcpu)
>  void kvm_write_wall_clock(struct kvm *kvm, gpa_t wall_clock, int sec_hi_ofs);
>  void kvm_inject_realmode_interrupt(struct kvm_vcpu *vcpu, int irq, int inc_eip);
>  
> -void kvm_write_tsc(struct kvm_vcpu *vcpu, struct msr_data *msr);
>  u64 get_kvmclock_ns(struct kvm *kvm);
>  
>  int kvm_read_guest_virt(struct kvm_vcpu *vcpu,

-- 
Vitaly

