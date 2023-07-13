Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2A15751FEE
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 13:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233959AbjGMLcf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 07:32:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232845AbjGMLcd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 07:32:33 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA854E5C
        for <kvm@vger.kernel.org>; Thu, 13 Jul 2023 04:32:32 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id a640c23a62f3a-98377c5d53eso102075766b.0
        for <kvm@vger.kernel.org>; Thu, 13 Jul 2023 04:32:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1689247951; x=1691839951;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eNKkvXVW1sthMJRNqYMNGRFlFZb1M91hFC/q+puE6Ik=;
        b=n+N153ZahhRtO6YJoWCv6JsN3zC7IJ7QdemzoZhSrpo0a4s7XSfHOnMy+OzsWlaQjn
         BLdgIRouGm5RgGddFnd+UBAqx6E2c58E71jmDhWxbr+NEyu/oslQ7epG6hKSSCZLA3RU
         Wp6ina2GVyU1UYQcB5tk5w8HOFEtZ9ulsmTR4sYIPxxRr/6cD8JfIvlwBkqzTTjePILj
         Zh7zlgbmdhGkCd1C0ajUvlzasqSNM8Gu9sH6izLzrkTcl50KpEoTLXhT/x2r+EIJg11k
         bP30DN68paLcfU0b8DQnwIW72HqXrqiKeRKulCKC9ukTdnlPrh5DWTQ4XUI9T8a4jKIX
         IhyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689247951; x=1691839951;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eNKkvXVW1sthMJRNqYMNGRFlFZb1M91hFC/q+puE6Ik=;
        b=DaSTS7oq6oHudq/WvSDNHzgjH6jRB+r+wU9eBVVAJifE96hHGPwco6KFfeSHVQ4aHo
         lws5VzLxvSkwMV+pW80UjmOXJyNQ/7hqfITLwChn5yPbaw781yTvMokO2x6AFW5ib9H7
         dV9s1OkShYPgdMLAN4fTcsGEJB6gbTYM3axehE+6i9zMUVkpTDqQkEITWhRK9GrXBm++
         9DJgaX7vWF04xu6oRaDoPyecKR8Q54wdg11lCblQKg6yzx6HQg76lT3kDmmgAA4USQZX
         kJjQo7uyMymy42E8VX3xFaTtPmSVsiMY6y6paGSB+MqG2aZC/JNYh6xcNLlpKYiLJcqr
         iUQg==
X-Gm-Message-State: ABy/qLaOADrLFKaAnNV7LWOR3XjwXHOPrSD7KAvA6A772u4U+xN3aKmR
        o+CsE4hKIgJtKeQAtMhfBbyboA==
X-Google-Smtp-Source: APBJJlEv0v+ZpKSZl9+bieRO2mmmwa+e/d1XEwqZ/2OSLJQFFFxirJJFUUKCqYFW75geQh2AmB9TdQ==
X-Received: by 2002:a17:906:5a45:b0:977:95f4:5cca with SMTP id my5-20020a1709065a4500b0097795f45ccamr1301033ejc.54.1689247951165;
        Thu, 13 Jul 2023 04:32:31 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id n25-20020a17090695d900b009927d4d7a6dsm3904142ejy.192.2023.07.13.04.32.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jul 2023 04:32:30 -0700 (PDT)
Date:   Thu, 13 Jul 2023 13:32:29 +0200
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
Subject: Re: [PATCH 3/7] RISC-V: KVM: Allow Zba and Zbs extensions for
 Guest/VM
Message-ID: <20230713-edec78d8a36c3c84618f159f@orel>
References: <20230712161047.1764756-1-apatel@ventanamicro.com>
 <20230712161047.1764756-4-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230712161047.1764756-4-apatel@ventanamicro.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 12, 2023 at 09:40:43PM +0530, Anup Patel wrote:
> We extend the KVM ISA extension ONE_REG interface to allow KVM
> user space to detect and enable Zba and Zbs extensions for Guest/VM.
> 
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/include/uapi/asm/kvm.h | 2 ++
>  arch/riscv/kvm/vcpu_onereg.c      | 4 ++++
>  2 files changed, 6 insertions(+)
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
