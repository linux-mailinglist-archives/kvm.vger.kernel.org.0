Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61EBE5882DF
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 21:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232130AbiHBT4N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 15:56:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230207AbiHBT4L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 15:56:11 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCCCC101F8
        for <kvm@vger.kernel.org>; Tue,  2 Aug 2022 12:56:10 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id f28so6264926pfk.1
        for <kvm@vger.kernel.org>; Tue, 02 Aug 2022 12:56:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=ifexnCMHYvvlc34nu1xb2qsCA6kxwpy+X5K2hbG8gi8=;
        b=PHXYjGFlIIXjhXIBuPjNt53vqsnJaXzf/SlvkNEMo+ps28jBD6Ez/yl7i4fDsL/ODz
         RGKdOQr+K3zKh7Qn+pPq6ceQ3B7cbr7+M1Qfb3odpg8oYs/KZDQ8kjFzsTRDaU3/xtfs
         IgLMDz7I/u8hact9Ohz75x2gbWl1DKRhxV2dau4ueFhopzIfAUZUGBRROy8GnjHK9RKE
         SoFluR8JyeawX0BHnCOJ1RpyE56kC0uo/W+1r9hi/HWHJYr1P19Ngr5Bh/TN5EFhAElo
         mUBDlZQRgq5TYKts03lE/vTqHac2FwQeK495/HqSD0w3oAbcc21xMFG3+AgALrmD8X1X
         By4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=ifexnCMHYvvlc34nu1xb2qsCA6kxwpy+X5K2hbG8gi8=;
        b=3sQGxSgh+wsn4kL/ladI2Qm6FePEVCkG20MrrNSJB8QXUoaTCKxhvptu/oFInBi7Gf
         Dfmen08le2v53yw5abi1G7JrkoodQhXy3sMQPvehSmB1rCqq4hn0lF+wq5LAGAuj9gfi
         TmLNhs7FmZVLTX/r4geMfKlSWMIiXsVazmC1u9xAYqlwsVbiH3HGlUTe+LQG/irkr82h
         jfgC5O1nCQrOsV3KByDr2I5J19YToYHaR1AZ5oPUWkfaEC8heGqsGtt/p6IhqjjZH/tq
         TxmgXrcY4btc2eJ8h8QyoTegKKh03DW8fIWW2OzFIzI2OlfeXtmY4yjL0WwM0eKW2koV
         gwGg==
X-Gm-Message-State: AJIora/XE0i4nJNFlu9upGSciemPG7/0BTVdn4ZA7Umt3IpN39SN6sqL
        zInXaeN1DpB9UocAGKoyQH0ypyPpCmj6VA==
X-Google-Smtp-Source: AGRyM1u6USAMGnNDWbX+/eMDa6MiHd8/m4L9+0+lgc8NQu+auOJQxzlr1CTmszwb5mlU40S2nv8NAw==
X-Received: by 2002:a05:6a00:248b:b0:52b:f07b:796c with SMTP id c11-20020a056a00248b00b0052bf07b796cmr21929332pfv.47.1659470170306;
        Tue, 02 Aug 2022 12:56:10 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id t14-20020aa7946e000000b0052d9b4bd8fasm4229798pfq.38.2022.08.02.12.56.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Aug 2022 12:56:09 -0700 (PDT)
Date:   Tue, 2 Aug 2022 19:56:05 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v7 028/102] KVM: TDX: allocate/free TDX vcpu structure
Message-ID: <YumBVb0yZ1VP1cRA@google.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
 <cfc7cfc72ea187b31e1c39df379a20545ca9b686.1656366338.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cfc7cfc72ea187b31e1c39df379a20545ca9b686.1656366338.git.isaku.yamahata@intel.com>
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

On Mon, Jun 27, 2022, isaku.yamahata@intel.com wrote:
> +int tdx_vcpu_create(struct kvm_vcpu *vcpu)
> +{
> +	struct vcpu_tdx *tdx = to_tdx(vcpu);
> +	int ret, i;
> +
> +	/* TDX only supports x2APIC, which requires an in-kernel local APIC. */
> +	if (!vcpu->arch.apic)
> +		return -EINVAL;
> +
> +	fpstate_set_confidential(&vcpu->arch.guest_fpu);
> +
> +	ret = tdx_alloc_td_page(&tdx->tdvpr);
> +	if (ret)
> +		return ret;
> +
> +	tdx->tdvpx = kcalloc(tdx_caps.tdvpx_nr_pages, sizeof(*tdx->tdvpx),
> +			GFP_KERNEL_ACCOUNT);
> +	if (!tdx->tdvpx) {
> +		ret = -ENOMEM;
> +		goto free_tdvpr;
> +	}
> +	for (i = 0; i < tdx_caps.tdvpx_nr_pages; i++) {
> +		ret = tdx_alloc_td_page(&tdx->tdvpx[i]);
> +		if (ret)
> +			goto free_tdvpx;
> +	}

Similar to HKID allocation for intrahost migration, can the TDVPX allocations be
moved to KVM_TDX_INIT_VCPU?
