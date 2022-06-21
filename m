Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B903E553821
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 18:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352519AbiFUQom (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 12:44:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234098AbiFUQol (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 12:44:41 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B51027147
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 09:44:40 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id go6so8764961pjb.0
        for <kvm@vger.kernel.org>; Tue, 21 Jun 2022 09:44:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=g2nFjV9jmT2Hpd5DehJ1ZA4omx6RqaDRPv/eusufnjc=;
        b=I+DtGM/nt2ScCQBAp8g7zwpS3M674V9WhOeU/lzRDNGrKqZBOtivc507+88+nluNne
         iw6S3vd7RY7xmZHw/zcG8hJUYjs48vbLAqfkvEW5mGJUKromfERfKjFH7gIKFoB1+v/r
         fKn4IbalSVgVuhYdEno3ksvjjCsIBP/32+FVicK600jXssgFjjuuJXioMu1ZpgMey4Oe
         pniUETRro4AGOmLoMii+VSlCbRW6WfQOUP3PaOYkBxrC1kqSVMjtBT4Q1iWiuXcVwTFu
         KJvzrJbTuY7/HwK4D841ciph+QlfqFxi1GwANu2N5VZqd851QQG1L6RwXhiGovVHVBAi
         eV1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=g2nFjV9jmT2Hpd5DehJ1ZA4omx6RqaDRPv/eusufnjc=;
        b=LwI8oRk1LLmManVpzZlQ/EL06tfTjURie+OJG9HN519dYAsH0rZYaJabrHQki49fm3
         dBTsb3L28lO5wSXX4lEbrjGcR68cNhz+MmCbis6QRsQIzwF+erTAloDEC6Kj6riygoEk
         jJfby2ZBpVnZ7gNeYMErG4n1VFF6Sb6zsgFY1AvIqu8mXulr4xJntqfRJ5f60xhXhbQi
         hzisiHIavXGuex3ne6EiVCAYdePmubdlMJIj5nDR6y6CqRugPlWnL4dB13Nyl68Po9sy
         Bd/g2KTGHL44nRblxKofTTN+sbcHED3Q1tCwbxtLQqXPZgfyzQV8OxU2rAYPu7VHiMHd
         o0Bw==
X-Gm-Message-State: AJIora+XnAx9cuzFiNR10/rKJZLiRn9G3UbqIMG/56NJAcDaUyVBJsM2
        ushUkHDgqWhF9EJxdCgIC8pVLDMvSVJzrQ==
X-Google-Smtp-Source: AGRyM1u0h5F7MQxAz1Y/Jc4Ltubq4Rb4VzotxS1fepeju85gjFVIDsCpIGo0m6ok4+M+n5KuxYdQyA==
X-Received: by 2002:a17:902:d509:b0:167:6ed8:afb5 with SMTP id b9-20020a170902d50900b001676ed8afb5mr30200688plg.137.1655829879886;
        Tue, 21 Jun 2022 09:44:39 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id b16-20020a170902d89000b001616b71e5e3sm10947409plz.171.2022.06.21.09.44.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 09:44:39 -0700 (PDT)
Date:   Tue, 21 Jun 2022 09:44:36 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, drjones@redhat.com, pbonzini@redhat.com,
        jade.alglave@arm.com, alexandru.elisei@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 15/23] arm64: Add a new type of memory
 type flag MR_F_RESERVED
Message-ID: <YrH1dJs/VnwF4bkK@google.com>
References: <20220506205605.359830-1-nikos.nikoleris@arm.com>
 <20220506205605.359830-16-nikos.nikoleris@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220506205605.359830-16-nikos.nikoleris@arm.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 06, 2022 at 09:55:57PM +0100, Nikos Nikoleris wrote:
> From: Andrew Jones <drjones@redhat.com>
> 
> This will be used by future change to add PTE entries for special EFI
> memory regions.
> 
> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> ---
>  lib/arm/asm/setup.h | 1 +
>  lib/arm/mmu.c       | 4 ++++
>  2 files changed, 5 insertions(+)
> 
> diff --git a/lib/arm/asm/setup.h b/lib/arm/asm/setup.h
> index f0e70b1..64cd379 100644
> --- a/lib/arm/asm/setup.h
> +++ b/lib/arm/asm/setup.h
> @@ -15,6 +15,7 @@ extern int nr_cpus;
>  
>  #define MR_F_IO			(1U << 0)
>  #define MR_F_CODE		(1U << 1)
> +#define MR_F_RESERVED		(1U << 2)
>  #define MR_F_UNKNOWN		(1U << 31)
>  
>  struct mem_region {
> diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
> index e1a72fe..931be98 100644
> --- a/lib/arm/mmu.c
> +++ b/lib/arm/mmu.c
> @@ -174,6 +174,10 @@ void *setup_mmu(phys_addr_t phys_end, void *unused)
>  	for (r = mem_regions; r->end; ++r) {
>  		if (r->flags & MR_F_IO) {
>  			continue;
> +		} else if (r->flags & MR_F_RESERVED) {
> +			/* Reserved pages need to be writable for whatever reserved them */
> +			mmu_set_range_ptes(mmu_idmap, r->start, r->start, r->end,
> +					   __pgprot(PTE_WBWA));
>  		} else if (r->flags & MR_F_CODE) {
>  			/* armv8 requires code shared between EL1 and EL0 to be read-only */
>  			mmu_set_range_ptes(mmu_idmap, r->start, r->start, r->end,
> -- 
> 2.25.1
>

Reviewed-by: Ricardo Koller <ricarkol@google.com>
