Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EA595FE7F1
	for <lists+kvm@lfdr.de>; Fri, 14 Oct 2022 06:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbiJNEUq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Oct 2022 00:20:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbiJNEUo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Oct 2022 00:20:44 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7324C58A0
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 21:20:41 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id bj12so7928598ejb.13
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 21:20:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OV3+a/0BT6g9pXRrmU2hqgr8aQ3sfDDJkFYLKeuZKSw=;
        b=cboXTgdXBn/Wg/ayWDkxV5ELOweKXTZUGvbDt3Cmf0EdfrB9qbaUFkZJPMTeg5QpPU
         GfjaCB0baw9rlJMW9Y244f07QcuHhHVTav9W4d+xzt0wMJNvaTVGQi2o/BRuMcAcCkGk
         FPsAeSL4KiKHcG3Vxof/E7hgArG2wAnjhYbjbQG38wUqcpGJl+fciRQv35Y4m4vk3e73
         GJJNzxPShx5BR1MgfW1RSXBXGFoduCsWS0aen8QmMfLqdUFNZzX+iZ4SlXtHAGu0j1CZ
         QMYAv1hZnG5ucr1mVb51/pORWIppRrSCJhMEum9JHcR8ZATch9YS4gMOFzyN1q4gqb0K
         qOjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OV3+a/0BT6g9pXRrmU2hqgr8aQ3sfDDJkFYLKeuZKSw=;
        b=JtFnOtux/QB7UoSClINKL/AMM9yysrNZvJG+Iy2Y76r7ZU34A8Rw0O3aqiR/w3XtlZ
         nEQrZJaCHKJHHjRVJu+PWju1YtCy7Phw7F4l0Qf+flVABdlOKD2NKEF3sdWa5eOKx8J6
         7Qf/vKBbk+DO8KuppmYouSGOxVV+Oy5Uh6F4wrSKflDBAcXbnOmVIrN5cZz0qDI4V8Q8
         USZfk3ij/d9jwVmMBLRCjxZ/ySZH5Ic5xTVtz6w9vujwUoT9GCai84KRfUC2roRjA/WG
         ixFcdU4ZCjkHDyAmFKVXFGEo+UfZPidA8qCREYS6ghbJH02b3vcMNgCSLOxYIhOFeKKo
         KXVQ==
X-Gm-Message-State: ACrzQf0euO/o4Ph0GYjaswu9Zk55MyNpaqA40rH0iaLifQZVqtSNS9Wb
        nr494EPgPMTNzeVdCOaUTaMNn5+mPUoyfYizPhFglQ==
X-Google-Smtp-Source: AMsMyM7+0eUHblw7Luuc7IqD0pCKWwi1rSFfe7iQHBNTv6SEMO9oK6RTkN53yr+znEsS/vx6MTrhy5z9iOxdtvbbdFA=
X-Received: by 2002:a17:907:a065:b0:78d:c5dd:45cf with SMTP id
 ia5-20020a170907a06500b0078dc5dd45cfmr2146288ejc.117.1665721239633; Thu, 13
 Oct 2022 21:20:39 -0700 (PDT)
MIME-Version: 1.0
References: <20221013214638.30974-1-palmer@rivosinc.com>
In-Reply-To: <20221013214638.30974-1-palmer@rivosinc.com>
From:   Anup Patel <anup@brainfault.org>
Date:   Fri, 14 Oct 2022 09:49:30 +0530
Message-ID: <CAAhSdy0sM1ENhTuakHBB7xm5nUVtKzUzPFQ-sVMyeWHDv0FPzQ@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: git://github -> https://github.com for kvm-riscv
To:     Palmer Dabbelt <palmer@rivosinc.com>
Cc:     kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        Conor Dooley <conor.dooley@microchip.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 14, 2022 at 3:19 AM Palmer Dabbelt <palmer@rivosinc.com> wrote:
>
> Github deprecated the git:// links about a year ago, so let's move to
> the https:// URLs instead.
>
> Reported-by: Conor Dooley <conor.dooley@microchip.com>
> Link: https://github.blog/2021-09-01-improving-git-protocol-security-github/
> Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>

For KVM RISC-V:
Acked-by: Anup Patel <anup@brainfault.org>

Thanks,
Anup

> ---
> I've split these up by github username so folks can take them
> independently, as some of these repos have been renamed at github and
> thus need more than just a sed to fix them.
> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 9a47bd58a330..d103b44fb40c 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -11156,7 +11156,7 @@ L:      kvm@vger.kernel.org
>  L:     kvm-riscv@lists.infradead.org
>  L:     linux-riscv@lists.infradead.org
>  S:     Maintained
> -T:     git git://github.com/kvm-riscv/linux.git
> +T:     git https://github.com/kvm-riscv/linux.git
>  F:     arch/riscv/include/asm/kvm*
>  F:     arch/riscv/include/uapi/asm/kvm*
>  F:     arch/riscv/kvm/
> --
> 2.38.0
>
