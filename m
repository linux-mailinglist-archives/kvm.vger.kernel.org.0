Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF3B274B638
	for <lists+kvm@lfdr.de>; Fri,  7 Jul 2023 20:26:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231249AbjGGS0T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jul 2023 14:26:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230166AbjGGS0S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jul 2023 14:26:18 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4B581FEF
        for <kvm@vger.kernel.org>; Fri,  7 Jul 2023 11:26:16 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-6686ef86110so1337543b3a.2
        for <kvm@vger.kernel.org>; Fri, 07 Jul 2023 11:26:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688754376; x=1691346376;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D+D3pxEr2HbWBs9exUtNPJYchePOTeAoFh4XtMy/uv4=;
        b=Dib+basRGwU7mJHlYg7zOfr/+u0JQfbXodEWogNH6RFnMHAka8loC1Lx9siEkR/iLk
         8BXC5+YhZGKpdGR6RoJlh8wBMMuMAN3+CzOp9KoQx1srA6eu9vvf8+h6BsIoIojXfASR
         8xBPXOQZfZ2xB8qj/pGm+tuXMWCAxBuzyAmkz1fx4WOurUfe95rSy67+oA8FDZD7ge0u
         Fj5Xri1v7X2OxpvyLfMqKKcoq+u66WTUlwaiBAbqrTfuVGRNQtj1eZyid8WiC3xRwA7b
         GhTZd6A7yimQcDdZd5330bGylwvGJqJtz19cf0c8Uhs6fYHZw7pR7XPdFUXiXMWWq8RB
         dalA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688754376; x=1691346376;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D+D3pxEr2HbWBs9exUtNPJYchePOTeAoFh4XtMy/uv4=;
        b=YwkmV3O7TOHCJo3wVo5XWzi2Ezaf84WYcSpZkWcrhFyZ3LhbwvLb/OohR/J1eaY50T
         tKn59bOdf21veITQbriQj9rmTPTPg8X6nzRAovp43ndh7X+Y1lGJqbLR7aKfFRWpRLtC
         Df3EcAuFQMhnvahoNMhhZpKmZOf9fTCTtTiVJnMw0uA1Pzdao7FeV72cAgbO+c8lUyif
         rZbDCXazJdXyT3ulcGQl8R8PR/6jonhIEozu4XvuXWvaJElezjZmwbmjozEjViU5JEez
         Cb4xHyxnUuyKAOamrNDje8+dM7oShzeaBgYkZeePFnVmrJMuTom00/GrY1FcKnRvafpO
         fRRA==
X-Gm-Message-State: ABy/qLaTE4q2Tix6wPS/f+6GV2d+dtc5f/4kFGEzeO6l7FK4EFMQ24t4
        Erpzx43nzLFv+H9IfOzlRofEbBvvIIY=
X-Google-Smtp-Source: APBJJlE428zeZCwxfUuwlM7tvyI/3yYWsr2Aao/xMoC24ZG/H90HnTa7Yu0rikmofK6NP0Mtw+FnWg==
X-Received: by 2002:aa7:88ce:0:b0:668:71a1:2e68 with SMTP id k14-20020aa788ce000000b0066871a12e68mr5842936pff.11.1688754375926;
        Fri, 07 Jul 2023 11:26:15 -0700 (PDT)
Received: from smtpclient.apple ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id x53-20020a056a000bf500b006827d9dd64esm3201972pfu.8.2023.07.07.11.26.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Jul 2023 11:26:15 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.600.7\))
Subject: Re: [kvm-unit-tests PATCH 1/2] arm64: set sctlr_el1.SPAN
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20230617013138.1823-2-namit@vmware.com>
Date:   Fri, 7 Jul 2023 11:26:04 -0700
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <3AD67D4A-1081-4BB3-B98A-5E2194D2E009@gmail.com>
References: <20230617013138.1823-1-namit@vmware.com>
 <20230617013138.1823-2-namit@vmware.com>
To:     Andrew Jones <andrew.jones@linux.dev>
X-Mailer: Apple Mail (2.3731.600.7)
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> 
> On Jun 16, 2023, at 6:31 PM, Nadav Amit <nadav.amit@gmail.com> wrote:
> 
> From: Nadav Amit <namit@vmware.com>
> 
> Do not assume PAN is not supported or that sctlr_el1.SPAN is already set.
> 
> Without setting sctlr_el1.SPAN, tests crash when they access the memory
> after an exception.
> 
> Signed-off-by: Nadav Amit <namit@vmware.com>
> ---
> arm/cstart64.S         | 1 +
> lib/arm64/asm/sysreg.h | 1 +
> 2 files changed, 2 insertions(+)
> 
> diff --git a/arm/cstart64.S b/arm/cstart64.S
> index 61e27d3..d4cee6f 100644
> --- a/arm/cstart64.S
> +++ b/arm/cstart64.S
> @@ -245,6 +245,7 @@ asm_mmu_enable:
> 	orr	x1, x1, SCTLR_EL1_C
> 	orr	x1, x1, SCTLR_EL1_I
> 	orr	x1, x1, SCTLR_EL1_M
> +	orr	x1, x1, SCTLR_EL1_SPAN
> 	msr	sctlr_el1, x1
> 	isb
> 
> diff --git a/lib/arm64/asm/sysreg.h b/lib/arm64/asm/sysreg.h
> index 18c4ed3..b9868ff 100644
> --- a/lib/arm64/asm/sysreg.h
> +++ b/lib/arm64/asm/sysreg.h
> @@ -81,6 +81,7 @@ asm(
> 
> /* System Control Register (SCTLR_EL1) bits */
> #define SCTLR_EL1_EE	(1 << 25)
> +#define SCTLR_EL1_SPAN	(1 << 23)
> #define SCTLR_EL1_WXN	(1 << 19)
> #define SCTLR_EL1_I	(1 << 12)
> #define SCTLR_EL1_SA0	(1 << 4)
> -- 
> 2.34.1
> 

Ping? (this one specifically is an issue)
