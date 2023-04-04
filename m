Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8234B6D68AD
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 18:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234897AbjDDQZW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 12:25:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233148AbjDDQZV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 12:25:21 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CBFD26AD
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 09:25:20 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id v6-20020a05600c470600b003f034269c96so10223546wmo.4
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 09:25:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1680625519;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vDk7Rc1+MlWExgJcsOHL4y40vJ5PAjWrSI2Xt0WKM8M=;
        b=nQmO0GuiV4QZBXRBbBMVzHtFmDIyOn0ZbA7ZCuVmg0mv0cUepkPjSrAMNOpshj4BQp
         uVIU+3z9FXhDrft53jJNC6siocV4dlmMcVjeN25d04FW33B4WtxzJG4xtxPom9gW+q0C
         EOLNRuMKERDowqBWYXxK8Ib3xiLC+1boADcxBpk5ArAczCiOCFCoW/r6j5P5fnrClZNm
         SQYupR9ilY0F2FaWhkognZ4y4Cvy5s5m31k0ojG0ZYijw9MvCLzUmz492LIINCFTk8VZ
         TyWv+j7e0tmWrM+rVzOat6C/HAPjcxc2gMv7kr1BvKzOLbfvm7aM8mSi+B4KRmnkDK66
         KQXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680625519;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vDk7Rc1+MlWExgJcsOHL4y40vJ5PAjWrSI2Xt0WKM8M=;
        b=SbbME7d5XVUpNqhVgpuMmVWBoIdOadwZk53VyugxVnRK8KcC7vRncRysiPCe1EzXuS
         xZL463ciHWXzJDAZUNBCOsUfX7OlgwkC80uV9jdsgbUEj5JmDkoBwg8LosshZOSUrj25
         Ur/NGClnayA+37Suf0V34d9Fit7CX4hjAI2fuCKD6sIPWwtyfYYJOZk36XlHYhMpcvcx
         jQwHpx44LoRuKLUgIlbCJHgkyfdssOEIjZpNTVCyfFPcl1ByUay3cP6usGdWLUlPNYJV
         Zi8CrVCc88d61oL/jpbMd12BY4z1oHpiGgDcmrecwhlX49tFfHgkSkjlxdljOdFTm9mu
         +e0A==
X-Gm-Message-State: AAQBX9egIBqkJVg8Nh13wjTFlz4SEMYDdvcnup5/e4U3kl136qSlohsY
        cVq3RHR3isC6bVZJfUwEVa8F9A==
X-Google-Smtp-Source: AKy350ZEVfY7T7MI9PiLLjjET7sb4Iy02pa7upxW8SfHLpRHBZOevNEEwY0yifqPndAiXwKpzG87Hw==
X-Received: by 2002:a7b:cd94:0:b0:3ee:5bd8:d537 with SMTP id y20-20020a7bcd94000000b003ee5bd8d537mr2409858wmj.5.1680625518762;
        Tue, 04 Apr 2023 09:25:18 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id w18-20020a1cf612000000b003ee58e8c971sm15589813wmc.14.2023.04.04.09.25.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 09:25:18 -0700 (PDT)
Date:   Tue, 4 Apr 2023 18:25:17 +0200
From:   Andrew Jones <ajones@ventanamicro.com>
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 7/9] RISC-V: KVM: Use bitmap for irqs_pending and
 irqs_pending_mask
Message-ID: <6dvutvobx754xdbbfw4ociyxuay6fqjwm3vxdp5dmsyefypvzs@ydxl65hjdwt2>
References: <20230404153452.2405681-1-apatel@ventanamicro.com>
 <20230404153452.2405681-8-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230404153452.2405681-8-apatel@ventanamicro.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 04, 2023 at 09:04:50PM +0530, Anup Patel wrote:
> To support 64 VCPU local interrupts on RV32 host, we should use
> bitmap for irqs_pending and irqs_pending_mask in struct kvm_vcpu_arch.
> 
> Signed-off-by: Anup Patel <apatel@ventanamicro.com>
> ---
>  arch/riscv/include/asm/kvm_host.h |  7 ++--
>  arch/riscv/kvm/vcpu.c             | 53 ++++++++++++++++++++-----------
>  2 files changed, 38 insertions(+), 22 deletions(-)
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
