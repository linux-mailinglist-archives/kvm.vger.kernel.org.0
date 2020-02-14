Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5CD15D4DC
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 10:36:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729120AbgBNJgi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 04:36:38 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:56139 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728807AbgBNJgh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Feb 2020 04:36:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581672996;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NIMAdnyHb+mpi3dHHfo24nPsqKz5IuqUCtHSkMxioCE=;
        b=iMJdPRHm2LQaBd4hrL65BwsOQmMGDwpXL3anTitAR0a4H83HOJa2b0CgcF6aAipxhp+elG
        jsioHOHFLA54hIQCRDQ8dnWLOM7NqhCL66LbZfVzXr7MGhLcKnmrzUXubUTTaQxD69om8H
        /9NVnpg12NaKAzEGp+MzbfEntshRsRg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-416-_b2i2RyQPeqTSfAojPIWww-1; Fri, 14 Feb 2020 04:36:34 -0500
X-MC-Unique: _b2i2RyQPeqTSfAojPIWww-1
Received: by mail-wm1-f72.google.com with SMTP id f207so3566814wme.6
        for <kvm@vger.kernel.org>; Fri, 14 Feb 2020 01:36:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NIMAdnyHb+mpi3dHHfo24nPsqKz5IuqUCtHSkMxioCE=;
        b=B7F6ZxQOFBEF2ow95GF5hFjPI4c7c+Vy6O7DmS0kTyNqGHR/siXoeSx40rVHfRD6dM
         geWz/E1dkD+13ujbjhvh6kDcfoTBi2um9K5iUw28zF+r8WKw7CeRnq/rewzoVzI3k+Yj
         ej19puquJZ+Uuo2++AQPDMLY2nJBMPMvFb6KpR2Y6CGk+Ab/OILhg/TovgD0LVjugDUZ
         8CPvca5PcSGhX0Cx6dglNjJ0anhmRUHrQT/61xM/bsUQcquThXN+apTJSzdj0giJfSYc
         21JxP45nsWgrTHvSYk0psKwiqI49+3ssi40m6QWiDdCxj34IcJ+wPI/NcGMRD/UKXS2x
         zmKw==
X-Gm-Message-State: APjAAAVhY06+gMmK4yzgwsSGY34se1HJaA0fCsqe6A2iwgVroCj/lMiE
        I75pZ7L3+TtLWo731g3BG7UIuJk/r+8frBJ3800WMe30BV7arY7tlzOTEqZMhT7IfWAFr7kO18P
        dvdDRNLd6A1MP
X-Received: by 2002:a7b:c084:: with SMTP id r4mr3458476wmh.99.1581672993320;
        Fri, 14 Feb 2020 01:36:33 -0800 (PST)
X-Google-Smtp-Source: APXvYqyNZcix3cHuRjYKI4UKwC2S/8vtOCGijmMjz2EO20M/zYAAUIwVsI9Wr0fsg9Fqa2L+o1gceg==
X-Received: by 2002:a7b:c084:: with SMTP id r4mr3458444wmh.99.1581672992936;
        Fri, 14 Feb 2020 01:36:32 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:59c7:c3ee:2dec:d2b4? ([2001:b07:6468:f312:59c7:c3ee:2dec:d2b4])
        by smtp.gmail.com with ESMTPSA id n3sm6677356wmc.27.2020.02.14.01.36.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Feb 2020 01:36:32 -0800 (PST)
Subject: Re: [RFC PATCH 1/3] KVM: vmx: rewrite the comment in vmx_get_mt_mask
To:     Chia-I Wu <olvaffe@gmail.com>, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, gurchetansingh@chromium.org, kraxel@redhat.com,
        dri-devel@lists.freedesktop.org
References: <20200213213036.207625-1-olvaffe@gmail.com>
 <20200213213036.207625-2-olvaffe@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0d88beeb-f960-3d1e-c669-93abe877d8ab@redhat.com>
Date:   Fri, 14 Feb 2020 10:36:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200213213036.207625-2-olvaffe@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/02/20 22:30, Chia-I Wu wrote:
> Better reflect the structure of the code and metion why we could not
> always honor the guest.
> 
> Signed-off-by: Chia-I Wu <olvaffe@gmail.com>
> Cc: Gurchetan Singh <gurchetansingh@chromium.org>
> Cc: Gerd Hoffmann <kraxel@redhat.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 27 +++++++++++++++++----------
>  1 file changed, 17 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 3be25ecae145..266ef87042da 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6854,17 +6854,24 @@ static u64 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
>  	u8 cache;
>  	u64 ipat = 0;
>  
> -	/* For VT-d and EPT combination
> -	 * 1. MMIO: always map as UC
> -	 * 2. EPT with VT-d:
> -	 *   a. VT-d without snooping control feature: can't guarantee the
> -	 *	result, try to trust guest.
> -	 *   b. VT-d with snooping control feature: snooping control feature of
> -	 *	VT-d engine can guarantee the cache correctness. Just set it
> -	 *	to WB to keep consistent with host. So the same as item 3.
> -	 * 3. EPT without VT-d: always map as WB and set IPAT=1 to keep
> -	 *    consistent with host MTRR
> +	/* We wanted to honor guest CD/MTRR/PAT, but doing so could result in
> +	 * memory aliases with conflicting memory types and sometimes MCEs.
> +	 * We have to be careful as to what are honored and when.
> +	 *
> +	 * For MMIO, guest CD/MTRR are ignored.  The EPT memory type is set to
> +	 * UC.  The effective memory type is UC or WC depending on guest PAT.
> +	 * This was historically the source of MCEs and we want to be
> +	 * conservative.
> +	 *
> +	 * When there is no need to deal with noncoherent DMA (e.g., no VT-d
> +	 * or VT-d has snoop control), guest CD/MTRR/PAT are all ignored.  The
> +	 * EPT memory type is set to WB.  The effective memory type is forced
> +	 * WB.
> +	 *
> +	 * Otherwise, we trust guest.  Guest CD/MTRR/PAT are all honored.  The
> +	 * EPT memory type is used to emulate guest CD/MTRR.
>  	 */
> +
>  	if (is_mmio) {
>  		cache = MTRR_TYPE_UNCACHABLE;
>  		goto exit;
> 

This is certainly an improvement, especially the part that points out
how guest PAT still allows MMIO to be handled as WC.

Thanks,

Paolo

