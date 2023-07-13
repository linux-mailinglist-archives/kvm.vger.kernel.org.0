Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD54751F53
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 12:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233391AbjGMK5N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 06:57:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbjGMK5M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 06:57:12 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5EEA210A
        for <kvm@vger.kernel.org>; Thu, 13 Jul 2023 03:57:10 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id a640c23a62f3a-992acf67388so83968666b.1
        for <kvm@vger.kernel.org>; Thu, 13 Jul 2023 03:57:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1689245829; x=1691837829;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=c9NtgBLjv1J96zLCU/pO/Q7azYyogqr/cagIRcD64aI=;
        b=gj7kW8GV0O+RnxEUvB7Rzg92T+cWgaDBZOj/LehCMJmClgK/jAbkEyOOD74xx2BxB0
         aU2wUxt3DFCdM9tzd5JjcJUPXSoZDtRPlYrKTsP3IcYQLSMBinBJV8suJ+v37y+DASZE
         VReqO0d0RaoyVVG+/RKukaeB4OzssFWjZKq1q5ZgSBTuwlof83ML2aYwvWOWYazMbx0R
         HotbzEFISAwilTgLj8Ap8pLnJta6CiLKzIKo9BRtfOM6Lk/dgcJa8rc/G0ojulEbvmyA
         52usDTRQRfBRN9kkhvEVcjDK5u34uly8pnzMqz9C1JPnVLCvaFBdbzyVy2odpJySNsrP
         ii2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689245829; x=1691837829;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c9NtgBLjv1J96zLCU/pO/Q7azYyogqr/cagIRcD64aI=;
        b=Yuz8ypP8OZeTjbtiHiBW37RGeLcih41F51PXYxz6FoJl3Gy8/wO6HFcPOh4xyVJG5f
         guPryj+7yTubaMr7PLh34zu0NTD4lZ0St+TscwZ7+IQVVhGFx02grH2AKLqFzqbGI0cR
         iWynSg6I6jx1MTP/4KJoJholiEx9Sv++suw3TPKvWniuy+aHfUCtvVtty1xNbwBpq7Tz
         dV9jnDbz5XlHL1GeBRKdqZhBQBm4QbFh3skweva6hOPuYS0b86ies1Uts4JaBAVGjhdh
         QehsaWgWs3Pg+9j80jDIDxKwkrcaLhKWC9RhduTgq5F+SjBzrUf+J7rewQtxHZmPGhJX
         02Jg==
X-Gm-Message-State: ABy/qLb3ya8ogQBLcMw3XcStffo40XIQKF4LzOP0vdC7FjaQL8PrpJGN
        //rVnKQnLGHQ+118w3K11NQozQ==
X-Google-Smtp-Source: APBJJlFU4O4KO6QzME5VoehHAND0oIP1yprw6Nl8SlJa+4axe1vxNp8uN0pFbJlOPz1ClqZEcY+osQ==
X-Received: by 2002:a17:906:30d3:b0:982:82aa:86b1 with SMTP id b19-20020a17090630d300b0098282aa86b1mr920230ejb.43.1689245829265;
        Thu, 13 Jul 2023 03:57:09 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id ay9-20020a170906d28900b00992bea2e9d2sm3835016ejb.62.2023.07.13.03.57.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jul 2023 03:57:08 -0700 (PDT)
Date:   Thu, 13 Jul 2023 12:57:07 +0200
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Samuel Ortiz <sameo@rivosinc.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] RISC-V: KVM: Factor-out ONE_REG related code to its
 own source file
Message-ID: <20230713-40f6804b248987add29f83aa@orel>
References: <20230712161047.1764756-1-apatel@ventanamicro.com>
 <20230712161047.1764756-2-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230712161047.1764756-2-apatel@ventanamicro.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 12, 2023 at 09:40:41PM +0530, Anup Patel wrote:
> The VCPU ONE_REG interface has grown over time and it will continue
> to grow with new ISA extensions and other features. Let us move all
> ONE_REG related code to its own source file so that vcpu.c only
> focuses only on high-level VCPU functions.
> 
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/include/asm/kvm_host.h |   6 +
>  arch/riscv/kvm/Makefile           |   1 +
>  arch/riscv/kvm/vcpu.c             | 529 +----------------------------
>  arch/riscv/kvm/vcpu_onereg.c      | 547 ++++++++++++++++++++++++++++++
>  4 files changed, 555 insertions(+), 528 deletions(-)
>  create mode 100644 arch/riscv/kvm/vcpu_onereg.c
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
