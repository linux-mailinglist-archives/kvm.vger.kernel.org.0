Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF1E7521DA
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 14:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234852AbjGMMuL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 08:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234839AbjGMMuB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 08:50:01 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0CC82D5B
        for <kvm@vger.kernel.org>; Thu, 13 Jul 2023 05:49:28 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id a640c23a62f3a-9741caaf9d4so94825666b.0
        for <kvm@vger.kernel.org>; Thu, 13 Jul 2023 05:49:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1689252565; x=1691844565;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YrA/e2Xt+yiDdhusSJAHLQMGqpj6TyRlVXIacek/Fro=;
        b=ciNnKzjCiYv0jh3eJrwmt8LDzo/2k6qXNKe5KY6vR7x+9Zx71QOAX2LRBEE7iDR5se
         LvDM9fpVZKYvlZAWDzYlORm+/Q/2AlSwGSNtoykaltdbMVtzvYV4QRRBLxQC4LPpdz1V
         smTy5WU7ZKoQb8JYtaoLCyTIozClZ6RPucKxWl1dUcucSG7ebZqWV5aETggrjJV4EX+x
         ODoqnFy5SRfg5x0eIwucj4n0OBsz7A1nC8mN6u8T6iTl7sfAdzp4G2ZWeBh/xLOE4zbu
         XfEcmrjL8k7mZyznIsYmnfcLFP64M/umfrE8DgmuC9shkfMQJpG6mfeEKK4XC/UAMu7Y
         /GUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689252565; x=1691844565;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YrA/e2Xt+yiDdhusSJAHLQMGqpj6TyRlVXIacek/Fro=;
        b=E/fVwrSYxw9ioiaIaiQiCd+aQMqqktVIlscKSQhf+kGJ0k7ixaEvaXYOS/zpnkjFsw
         D52TyfLMtZ7LlHlj0JHT6C0IIRP/ljJ6z7WZhnfqGQG42iiNSBIPITTxi8Xc+1OPFRiz
         7cfUgXC+08/PCIXfwMHT5MOiAt/fddt2At5kZtvWTeBjJb/6VhIxefhZqvBXoYQKxZHr
         2NUcDf+dDEehCGn42BDo9S6AMLhtEsUCSD/soSKa2UHhSb3f/5BUwL7axI3m9gY1oEy3
         vNvjjGmZCmomR9gEe0zsB5xSievYo2ZuHGuwm8yTYgV3GjQONbU9wkdrD8kB6UtbQd3X
         q4mw==
X-Gm-Message-State: ABy/qLaeEk8A7wI2borQmY+y+yChx/JtJM7hPpsTuZTNGK8gDUlSaYec
        0MLpGf1gdhGeTs9j3QEyMqsicA==
X-Google-Smtp-Source: APBJJlEZ6Jr0bgLMvUCUN1AElE230Jcv/LdQS84CgWB4o5VJnhjzvzvecIoBpLiC/Oq8h7YW4Uqy/Q==
X-Received: by 2002:a17:906:11a:b0:982:caf9:126 with SMTP id 26-20020a170906011a00b00982caf90126mr1713829eje.42.1689252564905;
        Thu, 13 Jul 2023 05:49:24 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id b14-20020a17090636ce00b0098d486d2bdfsm4026815ejc.177.2023.07.13.05.49.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jul 2023 05:49:24 -0700 (PDT)
Date:   Thu, 13 Jul 2023 14:49:23 +0200
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
Subject: Re: [PATCH 7/7] RISC-V: KVM: Allow Zvb* and Zvk* extensions for
 Guest/VM
Message-ID: <20230713-6b5fdd7fbd6e76c3d6291e8a@orel>
References: <20230712161047.1764756-1-apatel@ventanamicro.com>
 <20230712161047.1764756-8-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230712161047.1764756-8-apatel@ventanamicro.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 12, 2023 at 09:40:47PM +0530, Anup Patel wrote:
> We extend the KVM ISA extension ONE_REG interface to allow KVM
> user space to detect and enable Zvb* and Zvk* extensions for
> Guest/VM.
> 
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/include/uapi/asm/kvm.h |  9 +++++++++
>  arch/riscv/kvm/vcpu_onereg.c      | 18 ++++++++++++++++++
>  2 files changed, 27 insertions(+)
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
