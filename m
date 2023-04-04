Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5612B6D68E9
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 18:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231964AbjDDQbo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 12:31:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232530AbjDDQbm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 12:31:42 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2206844B6
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 09:31:38 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id bg16-20020a05600c3c9000b003eb34e21bdfso22210886wmb.0
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 09:31:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1680625896;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OR8OPThlLXGOEBzYBzmSAN3iW0DfsF9WhugEl5eryYw=;
        b=LHZgxx0Uvqxgjrf9lhng7dAr6TPPHiTRSKrHXCTOtfOb8CYs4/EMFMoV1OzLZWpwGR
         uq1Jc8hrSzDxUZmY9iskBKhG6Gb/jRP4Ul9SoRgv/mTWBAwTA0kpBlcUwHyVMHh2XU8d
         j1BIZOEYD1hNgZfX3t+E5OEiaQjqGk76+ox4DnS/k/gsu1Jjtqpq1jCK/0uJB/7QtjTe
         ksE9+t0invgTY2bO5mrO31j0VH4o2dsGeuHSX/6YMIXa4rR5w8HXnQDkUILE/0p/jgw+
         u21UHAMDVVtuVrK75caes0MEJPONWdF3MpjpTGvyOeveu1FEpoWTk1XWupW9P4+970+h
         ByQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680625896;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OR8OPThlLXGOEBzYBzmSAN3iW0DfsF9WhugEl5eryYw=;
        b=k2pYq/3tQc0iiat4qnFxIqihgcmOuFVlsgJI9cSutXDceZUiWj8h9LArKoepam9cQa
         QFXx9j3zHNQMLgJy98Dc8C+WCGhRVMNXeNxyAY057Y/G1AToPQJdo8ix3hD6X5BHfqcA
         idSiXqlzpgn9TUlejDXPgmDrfcNaHDc6VAcJAXXm4BYrg75uenW/PLouB5glFEMi/99x
         xSJh7xbI2v9xYJnUbu1EN6K/QRx2yfF1z+LmNhJm/Q5g6EP6+WRTNbz75YqeBAba5PwI
         00lPtvkrdvghfjomXcmjeG88xI3vE0WELbQTHX5T4uy+/l2U5OOkNB9FE/qnlc1PsmB0
         YS1g==
X-Gm-Message-State: AAQBX9ejMHeCKCYQAqrelOWjzf/4ov76j3UUmqV7r54KD/hpSx6heahm
        hwCR/Yd/Fk6mQ+SSuuIpkCB7cw==
X-Google-Smtp-Source: AKy350ZseW52UBeAArx0IxGVHoPjXIdN6gGZt5kcC1a0WaT1cApA3EPSQjy49IG1EcXf52uT+yvriA==
X-Received: by 2002:a7b:c416:0:b0:3ee:6d55:8b73 with SMTP id k22-20020a7bc416000000b003ee6d558b73mr2636111wmi.29.1680625896621;
        Tue, 04 Apr 2023 09:31:36 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id p1-20020a7bcc81000000b003ef5b011b30sm15638088wma.8.2023.04.04.09.31.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 09:31:36 -0700 (PDT)
Date:   Tue, 4 Apr 2023 18:31:35 +0200
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 8/9] RISC-V: KVM: Virtualize per-HART AIA CSRs
Message-ID: <nlvhpt27vgfb5huoexrv2xs7yeq4hdd3fna4yozfb4nvi6s3ky@5srurtxs3cjy>
References: <20230404153452.2405681-1-apatel@ventanamicro.com>
 <20230404153452.2405681-9-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230404153452.2405681-9-apatel@ventanamicro.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 04, 2023 at 09:04:51PM +0530, Anup Patel wrote:
> The AIA specification introduce per-HART AIA CSRs which primarily
> support:
> * 64 local interrupts on both RV64 and RV32
> * priority for each of the 64 local interrupts
> * interrupt filtering for local interrupts
> 
> This patch virtualize above mentioned AIA CSRs and also extend
> ONE_REG interface to allow user-space save/restore Guest/VM
> view of these CSRs.
> 
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/include/asm/kvm_aia.h  |  88 ++++----
>  arch/riscv/include/uapi/asm/kvm.h |   7 +
>  arch/riscv/kvm/aia.c              | 322 ++++++++++++++++++++++++++++++
>  3 files changed, 382 insertions(+), 35 deletions(-)
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
