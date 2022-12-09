Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BCAC647B2E
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 02:12:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbiLIBMo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Dec 2022 20:12:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbiLIBMk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Dec 2022 20:12:40 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3EA42DCB
        for <kvm@vger.kernel.org>; Thu,  8 Dec 2022 17:12:33 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id o12so3242409pjo.4
        for <kvm@vger.kernel.org>; Thu, 08 Dec 2022 17:12:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RzaW/Dkw5D0UiQIIqbAt82QcgNFIm3xJvGehXJmo5ys=;
        b=TocUuK0wI3vdPKDiDAaxu/PoP5sh6Xa0ifEsdIPANeYRP2eSSt0U0WQjWPaLbFpSn2
         8NdeDHH0qz1Jvq5N4Uce1Lt8v+ydsIUDGGBujIt6sLcv9SViIBwRuCEz37bsfQEAPPDg
         FY1RKsC9Xf+epJO3GqJiapkxZlIMyRKd8U54YFHDfO07l7EiNI0PB98gWWqXr9Y9teYg
         ym/WKikIgLjqCblf1m+nOEqs26bFXM9XBVR5LNQG6K6RtNVyABFC440cizGpn0JySYZa
         wdseZqXFB8rPt0xJT641DYgDSxa1GxqZQAcpGjxDq/FdtgTSSkpBJ9h14lgw2rhkhpFh
         8Y0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RzaW/Dkw5D0UiQIIqbAt82QcgNFIm3xJvGehXJmo5ys=;
        b=l6/etOCqx/nhpRQu/tQCZwQBjVXEoVyYWNwE5QUQgKCJDb5tiSFyi9mMWwXPeLfoIO
         /PT8PArgU0yGx5B+j+Pz39wIYBYJy6y/Wpu+1NIGsQipnvf/6I4vGo3nIQo4MTFxM2Aq
         6lQ9zQ0dj8YiQ+dJ914MdanLR7UQ6CZ0f0SI/L+qXDFxDFc75jN0wzi17kZUBFEykcpb
         +28KuZdPfWgJKCabl6RabFJ5mdmQ1/grlhNnyYepFDWjgIKO5AS9A1FfasSSUsHRKc0i
         TqJ3VO1eKBsFJSw8VO+VUDTtnbqaOEG+nUSKFNkXw71vjpcv2GzfCIMb894jEkOUHX9J
         qG6w==
X-Gm-Message-State: ANoB5pkO6d8xcKcZIBI9wu8h3PAbVRyHMfmpKi0FHB3gVGYm9SpAYJrR
        LsYtay7FZoC6a7K4bTDeMaO1Gw==
X-Google-Smtp-Source: AA0mqf6mENkx2c5ky8U+PLx4U66zh9KqKKkcuZ6pnkCCyANNX1FXePH2/0EHP4My3/dxme+7iFPQoA==
X-Received: by 2002:a17:902:e154:b0:189:6d32:afeb with SMTP id d20-20020a170902e15400b001896d32afebmr1628567pla.1.1670548353245;
        Thu, 08 Dec 2022 17:12:33 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id h4-20020a170902b94400b001895f7c8a71sm64632pls.97.2022.12.08.17.12.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 17:12:32 -0800 (PST)
Date:   Fri, 9 Dec 2022 01:12:29 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        coverity-bot <keescook@chromium.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: x86: hyper-v: Fix 'using uninitialized value'
 Coverity warning
Message-ID: <Y5KLfZj5+4W5ZlcT@google.com>
References: <20221208102700.959630-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221208102700.959630-1-vkuznets@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 08, 2022, Vitaly Kuznetsov wrote:
> In kvm_hv_flush_tlb(), 'data_offset' and 'consumed_xmm_halves' variables
> are used in a mutually exclusive way: in 'hc->fast' we count in 'XMM
> halves' and increase 'data_offset' otherwise. Coverity discovered, that in
> one case both variables are incremented unconditionally. This doesn't seem
> to cause any issues as the only user of 'data_offset'/'consumed_xmm_halves'
> data is kvm_hv_get_tlb_flush_entries() -> kvm_hv_get_hc_data() which also
> takes into account 'hc->fast' but is still worth fixing.
> 
> To make things explicit, put 'data_offset' and 'consumed_xmm_halves' to
> 'struct kvm_hv_hcall' as a union and use at call sites. This allows to
> remove explicit 'data_offset'/'consumed_xmm_halves' parameters from
> kvm_hv_get_hc_data()/kvm_get_sparse_vp_set()/kvm_hv_get_tlb_flush_entries()
> helpers.
> 
> Note: 'struct kvm_hv_hcall' is allocated on stack in kvm_hv_hypercall() and
> is not zeroed, consumers are supposed to initialize the appropriate field
> if needed.
> 
> Reported-by: coverity-bot <keescook+coverity-bot@chromium.org>
> Addresses-Coverity-ID: 1527764 ("Uninitialized variables")
> Fixes: 260970862c88 ("KVM: x86: hyper-v: Handle HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST{,EX} calls gently")
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>

> Changes since v1:
> - Shove 'data_offset'/'consumed_xmm_halves' into a union in 'struct
> kvm_hv_hcall' to make things more explicit. [Sean]
> ---
>  arch/x86/kvm/hyperv.c | 63 ++++++++++++++++++++++++-------------------
>  1 file changed, 36 insertions(+), 27 deletions(-)
> 
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index 2c7f2a26421e..e8296942a868 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -1769,6 +1769,7 @@ static bool hv_is_vp_in_sparse_set(u32 vp_id, u64 valid_bank_mask, u64 sparse_ba
>  }
>  
>  struct kvm_hv_hcall {
> +	/* Hypercall input data */
>  	u64 param;
>  	u64 ingpa;
>  	u64 outgpa;
> @@ -1779,12 +1780,21 @@ struct kvm_hv_hcall {
>  	bool fast;
>  	bool rep;
>  	sse128_t xmm[HV_HYPERCALL_MAX_XMM_REGISTERS];

Uber nit, might want an

	/* End hypercall input data */

or so to cleary demarcate the input vs. the scratch area.
