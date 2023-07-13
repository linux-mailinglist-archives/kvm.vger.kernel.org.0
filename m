Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 956657521CD
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 14:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234908AbjGMMtW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 08:49:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234847AbjGMMtG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 08:49:06 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D0472727
        for <kvm@vger.kernel.org>; Thu, 13 Jul 2023 05:48:34 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id 4fb4d7f45d1cf-51a52a7d859so4146885a12.0
        for <kvm@vger.kernel.org>; Thu, 13 Jul 2023 05:48:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1689252511; x=1691844511;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Fp4jrD0ygkJDJFkWGuFutfJdRI3HLTanG1V2Pol42Cs=;
        b=EOfdCr6iiOuuTNeK3CwI0fjcEzCrcjSEMhZxpmDwTAsUYUGRmEbN4J3P/KWj+lbnRV
         H3H5LgYWFSq8LpQAFrnS11hWAMu3jThEZYt1uEjysR4lE8hZvuiScxPUTY1JBowIa1sH
         VftqMEF/Yo+psGZPwo2ygzyJAfyX6/YNU5gqD7PwrjpSC/q2Jj7Hh7OeyTIzz8v4Gre0
         5ayG8V3a8n93aKvEbAUwe+GRycP79O7hwW5BbRHfoWtH+/e8CbrsjG15Ty9jiOAg0ZqV
         J3cKYSb1nQMioih/tQ08tz5SmCDZQ3tEDX52Gy7VadWkcvkw+PQR74HWTkSQywXYs4u7
         WF9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689252511; x=1691844511;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fp4jrD0ygkJDJFkWGuFutfJdRI3HLTanG1V2Pol42Cs=;
        b=QFgEpi3g1jn5mcAcAX53OUzIf0pFvK9HDNUpO5f/Cng5kY/OWB7cJq3TzFykhzV5Qm
         2E9ELqrP0LDKiwMACXLvayAs3lSPtQOkTOd3ubu0KTLg6Mqqb2RpQ5mF/AYd/6UtWzdc
         +85c14AebwIpzVkofjVi80IgvPUHVAuOqzFwOiOBydezYOr7iKsA/oUWq5r57n5TwkAg
         pvowNqkZmEIWnZ0Klie7nF7Z6A1rDN+vZ6E/FapaHyiknKdLV78Ko06Y0rXcL8or4sId
         EROiFKUN2D0yctmqk0AowZ/BQSMabvWvwjXNzHsVbG9qAQfClUQPw2el/UtFCzPXed9e
         4vvw==
X-Gm-Message-State: ABy/qLbFNaSWDw0DcOnqeadNETeBdKFMxEQ0EXauD7D8uKhESYhJJ1AS
        m7bVWY0zQ3wsuYVpHjZfPt/Ymg==
X-Google-Smtp-Source: APBJJlFXhJzEW2rHuTuVDvIaDHf/V6o0OrzDtrKElPkDaTyWkk0l1GjBgS7jdgy/ld4Qg5h+QAf4TA==
X-Received: by 2002:a17:907:3fa0:b0:986:38ab:ef99 with SMTP id hr32-20020a1709073fa000b0098638abef99mr7436157ejc.9.1689252511508;
        Thu, 13 Jul 2023 05:48:31 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id a10-20020a1709066d4a00b00992eabc0ad8sm3958509ejt.42.2023.07.13.05.48.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jul 2023 05:48:31 -0700 (PDT)
Date:   Thu, 13 Jul 2023 14:48:30 +0200
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
Subject: Re: [PATCH 6/7] RISC-V: KVM: Allow Zbc, Zbk* and Zk* extensions for
 Guest/VM
Message-ID: <20230713-bf041a3bbf91d041db3bd623@orel>
References: <20230712161047.1764756-1-apatel@ventanamicro.com>
 <20230712161047.1764756-7-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230712161047.1764756-7-apatel@ventanamicro.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 12, 2023 at 09:40:46PM +0530, Anup Patel wrote:
> We extend the KVM ISA extension ONE_REG interface to allow KVM
> user space to detect and enable Zbc, Zbk* and Zk* extensions for
> Guest/VM.
> 
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/include/uapi/asm/kvm.h | 11 +++++++++++
>  arch/riscv/kvm/vcpu_onereg.c      | 22 ++++++++++++++++++++++
>  2 files changed, 33 insertions(+)
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
