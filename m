Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E69B87365
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2019 09:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405904AbfHIHsM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Aug 2019 03:48:12 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43304 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405737AbfHIHsI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Aug 2019 03:48:08 -0400
Received: by mail-wr1-f68.google.com with SMTP id p13so22735531wru.10
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2019 00:48:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=aRURCPsR50XeHaMxy4aGY+5TvqUSmUNLHU5PV2hq+Sc=;
        b=pweKhfeG2M9NUGZ0wJw51iq3r7ZI3g2QhmkCG+L5qY4j1EqnnwRHx7TQ2UVcjq7dHk
         9OKpTnS7ZjVOu18SIWZJK8eDiQffA6COtD8HQJpvEosK61AyxTl0pYclX82YvbFOWt+f
         iQOdF3dOwJItKU52QITF8mm2/4HXE1CPu1Ghw3kmjCa9TzIuB69TubTVQIJ1oAyDk0+R
         rvCow1YiXr2dE3a7OAJw90T31bNpDMqcP8Y/xnKyee8M2B1kwV02g7zaISFUK7HJZcfs
         m9qYYP25CYVK7j8Ssit8HywzHDD+jaiqZAQdCwLkKg6O8M7MmDYjE6w39K6206wxWOt4
         uCUg==
X-Gm-Message-State: APjAAAU3UTqLG5XkcNjHBIrOEmUMY1dNz+GjnH38cT3I//zRJyIbNvaj
        7ry0L14zBmgT3NsYN2cSeomqRA==
X-Google-Smtp-Source: APXvYqwpqMiVUAPU8g9ahDmvVPjC05yU9bGUo5wuD9h15WS1oaYHAqTh2qJ2IidOMMi9/fG1axdPoQ==
X-Received: by 2002:adf:eb51:: with SMTP id u17mr21487207wrn.257.1565336886420;
        Fri, 09 Aug 2019 00:48:06 -0700 (PDT)
Received: from vitty.brq.redhat.com (ip-89-176-127-93.net.upcbroadband.cz. [89.176.127.93])
        by smtp.gmail.com with ESMTPSA id l8sm194121076wrg.40.2019.08.09.00.48.05
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 09 Aug 2019 00:48:05 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH] MAINTAINERS: add KVM x86 reviewers
In-Reply-To: <1565336051-31793-1-git-send-email-pbonzini@redhat.com>
References: <1565336051-31793-1-git-send-email-pbonzini@redhat.com>
Date:   Fri, 09 Aug 2019 09:48:04 +0200
Message-ID: <875zn6dbkb.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> This is probably overdone---KVM x86 has quite a few contributors that
> usually review each other's patches, which is really helpful to me.
> Formalize this by listing them as reviewers.  I am including people
> with various expertise:
>
> - Joerg for SVM (with designated reviewers, it makes more sense to have
> him in the main KVM/x86 stanza)
>
> - Sean for MMU and VMX
>

Sean is known to be a great SVM reviewer too!

> - Jim for VMX
>
> - Vitaly for Hyper-V and possibly SVM
>
> - Wanpeng for LAPIC and paravirtualization.
>
> Please ack if you are okay with this arrangement, otherwise speak up.
>
> In other news, Radim is going to leave Red Hat soon.  However, he has
> not been very much involved in upstream KVM development for some time,
> and in the immediate future he is still going to help maintain kvm/queue
> while I am on vacation.  Since not much is going to change, I will let
> him decide whether he wants to keep the maintainer role after he leaves.
>
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: Wanpeng Li <wanpengli@tencent.com>
> Cc: Jim Mattson <jmattson@google.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  MAINTAINERS | 17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 6498ebaca2f6..c569bd194d2a 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -8738,14 +8738,6 @@ F:	virt/kvm/*
>  F:	tools/kvm/
>  F:	tools/testing/selftests/kvm/
>  
> -KERNEL VIRTUAL MACHINE FOR AMD-V (KVM/amd)
> -M:	Joerg Roedel <joro@8bytes.org>
> -L:	kvm@vger.kernel.org
> -W:	http://www.linux-kvm.org/
> -S:	Maintained
> -F:	arch/x86/include/asm/svm.h
> -F:	arch/x86/kvm/svm.c
> -
>  KERNEL VIRTUAL MACHINE FOR ARM/ARM64 (KVM/arm, KVM/arm64)
>  M:	Marc Zyngier <marc.zyngier@arm.com>
>  R:	James Morse <james.morse@arm.com>
> @@ -8803,6 +8795,11 @@ F:	tools/testing/selftests/kvm/*/s390x/
>  KERNEL VIRTUAL MACHINE FOR X86 (KVM/x86)
>  M:	Paolo Bonzini <pbonzini@redhat.com>
>  M:	Radim Krčmář <rkrcmar@redhat.com>
> +R:	Sean Christopherson <sean.j.christopherson@intel.com>
> +R:	Vitaly Kuznetsov <vkuznets@redhat.com>

Acked-by: Vitaly Kuznetsov <vkuznets@redhat.com>

> +R:	Wanpeng Li <wanpengli@tencent.com>
> +R:	Jim Mattson <jmattson@google.com>
> +R:	Joerg Roedel <joro@8bytes.org>
>  L:	kvm@vger.kernel.org
>  W:	http://www.linux-kvm.org
>  T:	git git://git.kernel.org/pub/scm/virt/kvm/kvm.git
> @@ -8810,8 +8807,12 @@ S:	Supported
>  F:	arch/x86/kvm/
>  F:	arch/x86/kvm/*/
>  F:	arch/x86/include/uapi/asm/kvm*
> +F:	arch/x86/include/uapi/asm/vmx.h
> +F:	arch/x86/include/uapi/asm/svm.h
>  F:	arch/x86/include/asm/kvm*
>  F:	arch/x86/include/asm/pvclock-abi.h
> +F:	arch/x86/include/asm/svm.h
> +F:	arch/x86/include/asm/vmx.h
>  F:	arch/x86/kernel/kvm.c
>  F:	arch/x86/kernel/kvmclock.c

-- 
Vitaly
