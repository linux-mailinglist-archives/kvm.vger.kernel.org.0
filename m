Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF84A46DADF
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 19:17:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234807AbhLHSUw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 13:20:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232923AbhLHSUv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Dec 2021 13:20:51 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D652BC0617A1
        for <kvm@vger.kernel.org>; Wed,  8 Dec 2021 10:17:19 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id p18so2043394plf.13
        for <kvm@vger.kernel.org>; Wed, 08 Dec 2021 10:17:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3f166bKRHkMHhPvddU093J8vpeto2pmeKPfGPIYP+ag=;
        b=cL99TQ6qTeqBC/mnS0Sbgi4Lra35l+QPXJL+s5eSThP7qttO8f2pRKrpp9barCiLCG
         woTu8bBio6AH+TEKw8oTCflH3u3FIdd1A6Vej3Uk7l8vJ6m30fMfJ7o7E2aBa0n+Jojo
         GLybvYrDGZtX1i8uZyKy67wN0FN41BHrCDwGpvTtzDAS89TF++Wy1LA6HxvUda+2d1Fh
         LEQLhPilkaYqLfZsQJ3J6P7Dj9ZczaHkxbk5g5I6M71Iwv2PV52pcWlBkfnPR7lS1BPh
         eIIdkw/vQCJEQzYXH0XVhJIZNAMFCOhjaTML8TQbQ6k2NwLdSEKR0tRr3KqyJg/LN1Po
         4Bpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3f166bKRHkMHhPvddU093J8vpeto2pmeKPfGPIYP+ag=;
        b=c2HmExVCSvj948TYz5O8M75oBG5BtkwO5H84Yt6PJA+rdJHDrxvrGsjJKE/4XRcph7
         XkdJqvmsBUUj8s/hpzi/NNP+K6S0j7tkGUZcF5k2nHq/O2YFLP9ytFqrMr0c0JqMI/Rl
         3zGcpSt8cA4sYm+Wf6Qje1lFyDuICMI4gjDOkGDEfHbJN/rHex9L1VP41GxUmOyi6M5L
         NXWDsj8mMA0xBiIepCO0S2epHPEpaHvNblQ6rmVy+HIG5oaw0wkQmKIxXClS8ZgMJlS/
         xJhvrPg0i1MdW0XwnwaIRhyrt5sORKBnVNX/oP0i/e1QIukVGJnMJbFOyoIDcJC9GGWI
         pEMw==
X-Gm-Message-State: AOAM5310lh2mZK1PyzgyzJjfW1E4EMh3QZtDPLXtN8PeUBJdPJBOL7i6
        /jENDIVNbQfe4o3CTF1QZ7/e8g==
X-Google-Smtp-Source: ABdhPJwmueStDqep48ij3iOz84X2oAXyKLxFMG73qqVpmizbC+ILabThfI8X1KTs/m00ikAT2XRW1w==
X-Received: by 2002:a17:90a:8049:: with SMTP id e9mr8951250pjw.229.1638987439188;
        Wed, 08 Dec 2021 10:17:19 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id j17sm4020451pfe.174.2021.12.08.10.17.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 10:17:18 -0800 (PST)
Date:   Wed, 8 Dec 2021 18:17:15 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/7] KVM: x86: Move .pmu_ops to kvm_x86_init_ops and
 tagged as __initdata
Message-ID: <YbD2q/MhBjm2OMOe@google.com>
References: <20211108111032.24457-1-likexu@tencent.com>
 <20211108111032.24457-6-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211108111032.24457-6-likexu@tencent.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

s/tagged/tag

On Mon, Nov 08, 2021, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> The pmu_ops should be moved to kvm_x86_init_ops and tagged as __initdata.

State what the patch does, not what "should" be done.

  Now that pmu_ops is copied by value during kvm_arch_hardware_setup(), move
  the pointer to kvm_x86_init_ops and tag implementations as __initdata to make
  the implementations unreachable once KVM is loaded, e.g. to make it harder to
  sneak in post-init modification bugs.

> That'll save those precious few bytes, and more importantly make
> the original ops unreachable, i.e. make it harder to sneak in post-init
> modification bugs.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 4 ++--
>  arch/x86/kvm/svm/pmu.c          | 2 +-
>  arch/x86/kvm/svm/svm.c          | 2 +-
>  arch/x86/kvm/vmx/pmu_intel.c    | 2 +-
>  arch/x86/kvm/vmx/vmx.c          | 2 +-
>  arch/x86/kvm/x86.c              | 2 +-
>  6 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index c2d4ee2973c5..00760a3ac88c 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1436,8 +1436,7 @@ struct kvm_x86_ops {
>  	int cpu_dirty_log_size;
>  	void (*update_cpu_dirty_logging)(struct kvm_vcpu *vcpu);
>  
> -	/* pmu operations of sub-arch */
> -	const struct kvm_pmu_ops *pmu_ops;
> +	/* nested operations of sub-arch */

No need for the new comment.

>  	const struct kvm_x86_nested_ops *nested_ops;
>  
>  	/*

Nits aside,

Reviewed-by: Sean Christopherson <seanjc@google.com>

I'd also be a-ok squashing this with the copy-by-value patch.
