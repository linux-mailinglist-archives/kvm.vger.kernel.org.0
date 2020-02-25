Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A13A616C2AB
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 14:45:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730272AbgBYNpq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 08:45:46 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:29680 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730258AbgBYNpq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 08:45:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582638345;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/T/kivFGUXg5sHRSIwBgWjiVnsUmWthpcONYfMKDGQU=;
        b=gNUQ82aGl0I+ZdEMidu87EQOC86RXyxGo6IgAFw9TWypZ6CTagJDrN8uiTcOFAFsvGBkNN
        KIZC8RMkB+zmP8XQI2bHZ6uLU22OAd/QDLBh6UXDRGF9DvqnZC0zBJxQju95ZZa3NyLWAH
        137Xq2T3p5ioujgESb22yuSA8jRW7Oc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-321-a9KDExVLPfCL_zDXJM1iiQ-1; Tue, 25 Feb 2020 08:45:39 -0500
X-MC-Unique: a9KDExVLPfCL_zDXJM1iiQ-1
Received: by mail-wr1-f71.google.com with SMTP id p8so7324226wrw.5
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2020 05:45:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=/T/kivFGUXg5sHRSIwBgWjiVnsUmWthpcONYfMKDGQU=;
        b=Ic3lFRX9HSuzMOVd5+1fn9wHhddDRZylp8Awuu6MWDuKyAqz/ImZI43xsccEwnN3Am
         lqQRBM8xsAojwFKfckXBxwAZlDypUKFI1/tkHjWUCIdtn9K4l4SLGv0kgGi47z8JLgEz
         WQ8m587shK+x2FCDOJcPw+Bnj55uRW6KLR0o9SLw7gaoZ9icqRXPQsDchWPkfJ6AfVC5
         TU5BkxJUKENxV63dMxCinAKjmzpT30lBJgaSCVf0Tr+wxwCZxg+EuNDUy6Yq4+eQFe0P
         a1aXNepn8/CzS3VS4LZFhUckx2+lfV14UAN/pMp37VebADfgnhY7Qd3nCY5oiX12YEpY
         z7bw==
X-Gm-Message-State: APjAAAU926BDlTMef3ez8anpIdH229/knfkvz659QbGZz6eEiQTIORSH
        96cqRxkaUnMv1IvOnxiTVzQ++RFnACu5Njj4xwNOQ/a/Cui19s6m0qnArRYkOPddPmEmfGmKyzV
        8WuUEPvPUA9js
X-Received: by 2002:a7b:c5da:: with SMTP id n26mr5249097wmk.138.1582638337568;
        Tue, 25 Feb 2020 05:45:37 -0800 (PST)
X-Google-Smtp-Source: APXvYqwf2ZsKE58ePK4Z2deUeaZOsUEklPqETVClcba53r8rw/fae2dyyFlESYMCG1Qyok6wzsJ9Mg==
X-Received: by 2002:a7b:c5da:: with SMTP id n26mr5249082wmk.138.1582638337293;
        Tue, 25 Feb 2020 05:45:37 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id h205sm4401348wmf.25.2020.02.25.05.45.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 05:45:36 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     rmuncrief@humanavance.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: SVM: allocate AVIC data structures based on kvm_amd moduleparameter
In-Reply-To: <1582617278-50338-1-git-send-email-pbonzini@redhat.com>
References: <1582617278-50338-1-git-send-email-pbonzini@redhat.com>
Date:   Tue, 25 Feb 2020 14:45:36 +0100
Message-ID: <874kven5kv.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> Even if APICv is disabled at startup, the backing page and ir_list need
> to be initialized in case they are needed later.  The only case in
> which this can be skipped is for userspace irqchip, and that must be
> done because avic_init_backing_page dereferences vcpu->arch.apic
> (which is NULL for userspace irqchip).
>
> Tested-by: rmuncrief@humanavance.com
> Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=206579
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/svm.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index ad3f5b178a03..bd02526300ab 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -2194,8 +2194,9 @@ static void svm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>  static int avic_init_vcpu(struct vcpu_svm *svm)
>  {
>  	int ret;
> +	struct kvm_vcpu *vcpu = &svm->vcpu;
>  
> -	if (!kvm_vcpu_apicv_active(&svm->vcpu))
> +	if (!avic || !irqchip_in_kernel(vcpu->kvm))
>  		return 0;
>  
>  	ret = avic_init_backing_page(&svm->vcpu);

Out of pure curiosity,

when irqchip_in_kernel() is false, can we still get to .update_pi_irte()
(svm_update_pi_irte()) -> get_pi_vcpu_info() -> "vcpu_info->pi_desc_addr
= __sme_set(page_to_phys((*svm)->avic_backing_page));" -> crash! or is
there anything which make this impossible?

The patch is an improvement anyway, so
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

