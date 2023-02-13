Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B5BE694D33
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 17:47:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbjBMQrK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 11:47:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbjBMQrJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 11:47:09 -0500
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DE4C113DA;
        Mon, 13 Feb 2023 08:47:08 -0800 (PST)
Received: by mail-il1-x136.google.com with SMTP id t7so3756156ilq.2;
        Mon, 13 Feb 2023 08:47:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gSXV3eBgQkMCCZdUZh+6ocU34hvWPvob14040D6fecE=;
        b=fhacIvVc7xfBs/S2rllDhsEA8jtgZBM1vhKpIHyfVXeCOND4D6mvHv7bf/bgZJKWS1
         /KzSQ13KoRHD3PbxfR3fLhpT9q3FMKHx1Zm87+3SAaHInpV3tqmEDOljAc84X7JjJYIg
         fSzb4vFAfmRutK7fJxGwhfUZKw8rFLWPUB3J0hUb2EpPAJJumL/1BpbN1I3yXKz/w1yf
         rhyH1YtckKn2axZnfOERkuJDmkhjOtKKAMKJTqcoVh2erSwT3u345bYpNxfZFBDb6Na0
         h+7NhAMgbjR6FnRUNzfq5kWjVGM8hkB+GFWwaAnrdz3aSwo/sCz3jQDeRpnTH1oVI7vL
         rDvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gSXV3eBgQkMCCZdUZh+6ocU34hvWPvob14040D6fecE=;
        b=iPbUHuMKKiTSBaL1AvAM0LVehnY6DvMFDmjAjor2wX0bvR2TYDqLddAMAKI983cI7H
         R3N4IM+bvGJNERP700HtEdeKp3cMfy2lmdgWXFcDgWi59zTa9Ml7jNiDgaNfd04ImMKf
         L5dtWAiZNIedJQq4XsjeWmfRKRI3XzTs3UZCpbQ7NOvFdIcknrEJiSM+/zqhwC12yTHa
         +uxvPrrzq+MLpk4bDI2mHt2liOstKNlosP65K/sWZOe4QbS4VkRZWZHmAujE0mmXL080
         MO8iHuuw44wjXgmdbcQVQmPk5Xjhb1m7ojT8iT+DpQMUFRxAz5a0XNNWZ2lox8tapT/P
         obpg==
X-Gm-Message-State: AO0yUKXmLeXTrgh+BTda3uUmMbAziZjoTRiPW+jKiSQJPQ1mSuPsLikQ
        s+05zNcbPo8MQqZDLkXcEfs=
X-Google-Smtp-Source: AK7set8BIqvM1v+cY/aL2Q6tJiBHTOHz5e48IASZEKjztVkYEWSohC1qa55WsxW1bZRA2xkb2VqUHA==
X-Received: by 2002:a05:6e02:1d84:b0:315:39ce:abd2 with SMTP id h4-20020a056e021d8400b0031539ceabd2mr4730213ila.3.1676306827378;
        Mon, 13 Feb 2023 08:47:07 -0800 (PST)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id q11-20020a056e02106b00b00313b281ecd2sm3954758ilj.70.2023.02.13.08.47.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 08:47:07 -0800 (PST)
Date:   Mon, 13 Feb 2023 18:47:01 +0200
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     Steven Price <steven.price@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        James Morse <james.morse@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Joey Gouly <joey.gouly@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev
Subject: Re: [RFC PATCH 08/28] arm64: RME: Keep a spare page delegated to
 the RMM
Message-ID: <20230213184701.00005d3b@gmail.com>
In-Reply-To: <20230127112932.38045-9-steven.price@arm.com>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
        <20230127112932.38045-1-steven.price@arm.com>
        <20230127112932.38045-9-steven.price@arm.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 27 Jan 2023 11:29:12 +0000
Steven Price <steven.price@arm.com> wrote:

> Pages can only be populated/destroyed on the RMM at the 4KB granule,
> this requires creating the full depth of RTTs. However if the pages are
> going to be combined into a 4MB huge page the last RTT is only
> temporarily needed. Similarly when freeing memory the huge page must be
> temporarily split requiring temporary usage of the full depth oF RTTs.
> 
> To avoid needing to perform a temporary allocation and delegation of a
> page for this purpose we keep a spare delegated page around. In
> particular this avoids the need for memory allocation while destroying
> the realm guest.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
>  arch/arm64/include/asm/kvm_rme.h | 3 +++
>  arch/arm64/kvm/rme.c             | 6 ++++++
>  2 files changed, 9 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
> index 055a22accc08..a6318af3ed11 100644
> --- a/arch/arm64/include/asm/kvm_rme.h
> +++ b/arch/arm64/include/asm/kvm_rme.h
> @@ -21,6 +21,9 @@ struct realm {
>  	void *rd;
>  	struct realm_params *params;
>  
> +	/* A spare already delegated page */
> +	phys_addr_t spare_page;
> +
>  	unsigned long num_aux;
>  	unsigned int vmid;
>  	unsigned int ia_bits;
> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
> index 9f8c5a91b8fc..0c9d70e4d9e6 100644
> --- a/arch/arm64/kvm/rme.c
> +++ b/arch/arm64/kvm/rme.c
> @@ -148,6 +148,7 @@ static int realm_create_rd(struct kvm *kvm)
>  	}
>  
>  	realm->rd = rd;
> +	realm->spare_page = PHYS_ADDR_MAX;
>  	realm->ia_bits = VTCR_EL2_IPA(kvm->arch.vtcr);
>  
>  	if (WARN_ON(rmi_rec_aux_count(rd_phys, &realm->num_aux))) {
> @@ -357,6 +358,11 @@ void kvm_destroy_realm(struct kvm *kvm)
>  		free_page((unsigned long)realm->rd);
>  		realm->rd = NULL;
>  	}
> +	if (realm->spare_page != PHYS_ADDR_MAX) {
> +		if (!WARN_ON(rmi_granule_undelegate(realm->spare_page)))
> +			free_page((unsigned long)phys_to_virt(realm->spare_page));

Will the page be leaked (not usable for host and realms) if the undelegate
failed? If yes, better at least put a comment.

> +		realm->spare_page = PHYS_ADDR_MAX;
> +	}
>  
>  	pgd_sz = kvm_pgd_pages(pgt->ia_bits, pgt->start_level);
>  	for (i = 0; i < pgd_sz; i++) {

