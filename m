Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FDAB751FDF
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 13:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233126AbjGML1N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 07:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230281AbjGML1M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 07:27:12 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A33D18E
        for <kvm@vger.kernel.org>; Thu, 13 Jul 2023 04:27:11 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id 38308e7fff4ca-2b6ff1ada5dso8485291fa.2
        for <kvm@vger.kernel.org>; Thu, 13 Jul 2023 04:27:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1689247630; x=1691839630;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nWVD6bmDClvFRSgHCqYkZ5kEEDPyjY+6kQqvXpehczU=;
        b=j/blvGSuhTbKnMAFRDQrUhXSn7yLTC9w5s3t9kf5BYVoM41vuBu8nhJM1yEoiNy/s1
         JUtxwRufax24YEQIZ/laS6QLGwY3lEI2C22vqcmse5vLWB1d/TI4ZDT7mz93CQRUfhGE
         owXMNbR70I/imqd/XPLkAqateUcTQTgMvDIU7Q1JL5deufkRwQ6m15r1n0KYsVOE55MX
         AIBMvGiVrv4EE/L30kEZatMNJOm9Hszz6vHSUlc0mUOikUj+IZF8LSxGMjQm70WOMzWd
         4pdKISsaafvfgDnksoyulNqcnCxO9npdk5c9I6kukKHuY8E0cmQHV6yepjPtpmL7Tk57
         xvIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689247630; x=1691839630;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nWVD6bmDClvFRSgHCqYkZ5kEEDPyjY+6kQqvXpehczU=;
        b=PKpRB88Ie7W7qg0j+oLHFBUzm1XupyLR5YJ2Cf+0Gx/qALC97pj2+N0hNaF01PIPI7
         Vm4bp8T218cUxHSkYF6QiQb+DkJxYEAygF/EVACzKtLwspZkX/pO+QVqaSmZDHuGq+2J
         zwhckSMVOYUzg3lih6rqsTTwB9Hlr9WyHRTj2JM18Bpm9gOHaAfVAkpwtkbNEOHDtmq6
         8+k/Y/81I6zYOtKaCzpYMVdNBnLhMP5ZxZbiSnHH2x3uMBCPv+L9KGsgXLnye1ClrxXl
         /pxRhtKwTZxa+6HduPF9z8J07cijWyNpwf4ofelkHSvHp+MrkiKkfFeDzZuk5QHfcIaC
         Th1A==
X-Gm-Message-State: ABy/qLYahcFq+6K8kUWTm8H5bYPz3FerEYIpyUC3V+6XZikAcWWg9mw7
        Fjh4Mz35fxXF5YdTeDL1lxHFYw==
X-Google-Smtp-Source: APBJJlFcPWkOYad3AO0C0/TthvEo+nczdd4M++HotWO7WY0hZba3ezfYNG1fTr+XKQATieG5UOrGWA==
X-Received: by 2002:a05:6512:46d:b0:4fb:90f7:6769 with SMTP id x13-20020a056512046d00b004fb90f76769mr865262lfd.21.1689247629831;
        Thu, 13 Jul 2023 04:27:09 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id w22-20020aa7da56000000b0051e1a4454b2sm4134322eds.67.2023.07.13.04.27.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jul 2023 04:27:09 -0700 (PDT)
Date:   Thu, 13 Jul 2023 13:27:08 +0200
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
Subject: Re: [PATCH 2/7] RISC-V: KVM: Extend ONE_REG to enable/disable
 multiple ISA extensions
Message-ID: <20230713-3dd9e72ecd9f7926a2035f59@orel>
References: <20230712161047.1764756-1-apatel@ventanamicro.com>
 <20230712161047.1764756-3-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230712161047.1764756-3-apatel@ventanamicro.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 12, 2023 at 09:40:42PM +0530, Anup Patel wrote:
> Currently, the ISA extension ONE_REG interface only allows enabling or
> disabling one extension at a time. To improve this, we extend the ISA
> extension ONE_REG interface (similar to SBI extension ONE_REG interface)
> so that KVM user space can enable/disable multiple extensions in one
> ioctl.
> 
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/include/uapi/asm/kvm.h |   9 ++
>  arch/riscv/kvm/vcpu_onereg.c      | 153 ++++++++++++++++++++++++------
>  2 files changed, 133 insertions(+), 29 deletions(-)
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
