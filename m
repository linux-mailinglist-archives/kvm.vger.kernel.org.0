Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3070F4FA223
	for <lists+kvm@lfdr.de>; Sat,  9 Apr 2022 05:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240691AbiDIDxd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 23:53:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231783AbiDIDxb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 23:53:31 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2EA7332DCB
        for <kvm@vger.kernel.org>; Fri,  8 Apr 2022 20:51:25 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id v64-20020a1cac43000000b0038cfd1b3a6dso8821848wme.5
        for <kvm@vger.kernel.org>; Fri, 08 Apr 2022 20:51:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=hjV85bpMkNJuL8vvhI9IAAgoX1lYtvK7CB2b32NFcGE=;
        b=2WTmPakhdY7m3RR1J07Q3HKF1lUUw9xYcvbeLmdmCbGu1QsrzEF4yovjQ0w0PTqUP8
         ttUY4tWy+XJwxrc5eD98+gpJlyvafAhc5eahueerCdGExOWlMyceUC4SSm3BEAWLpoyX
         bsJdfVmNiSmv38SYHT3dlVZt/EStxBgDHN9WuZ3jj8tElkN2+eLulHgK4z+qjG6AuZEZ
         JEnEE39kL7T9irPQd/LL8aplExKzX14Ib9lV2E/eIugV2sd+u5TLYpsWJTBiU2ja4mYF
         UmQNAKfH6PykEeJvOrTXhKGFherqje+MPiA4F74VK9myrEuen1txu7tXO0Iqv2D/XgW3
         Wmcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hjV85bpMkNJuL8vvhI9IAAgoX1lYtvK7CB2b32NFcGE=;
        b=WDXllMVaBc9C3+y8YtUrOqfUdcICJZQICLMXKQLdlUUO0KSoGkO/mOskQPhJpaOZ/Y
         U/2lgsyotgpyjrh9xPbvklASg4LZPgy/d8KwPqdX4DUA2cfKlt6oRHZ7vEOBgGa8BDnF
         J9B+Fv+rzUUzgIZa5XjHsXqmaLzumhZBUEgPjTknMRNQGZXy6smOYvDTjRiL2CmzT86N
         BXgldLZViGoZ8PKYNZc/DjBTXm2CRwC593gpn1iHAogNSSE9uvewbEHdX1HWiPaXEq3I
         vwX8YebqawYaPhpUTMQtBLHRM154RQlOVE03dY2N4U294In1KuuRBiJIZ7QPqWQn936q
         SrEA==
X-Gm-Message-State: AOAM533E5uRYiyfUTxvCDZ5eaSuiFFmIUH9oH+FC/BtBAK+KbPk4J1MC
        sDiZeukFo8BQWHjNG0+VfyfZukSzV7BX3avMZCPoxA==
X-Google-Smtp-Source: ABdhPJyLzclFI9xwJ/UwHbG50eZvcrZ5NNZ72tDpou23WT/C53Yz/iLCM/pefwav/FSn5lluityAclN+tIZJY/VOdss=
X-Received: by 2002:a05:600c:1d04:b0:38c:ba2f:88ba with SMTP id
 l4-20020a05600c1d0400b0038cba2f88bamr19619710wms.137.1649476284108; Fri, 08
 Apr 2022 20:51:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220408092415.1603661-1-heiko@sntech.de>
In-Reply-To: <20220408092415.1603661-1-heiko@sntech.de>
From:   Anup Patel <anup@brainfault.org>
Date:   Sat, 9 Apr 2022 09:21:11 +0530
Message-ID: <CAAhSdy0ZPH2a9D0jDNhp5OU2oRdvC-wZcu0Zjtcq9ZhMWcrMng@mail.gmail.com>
Subject: Re: [PATCH] RISC-V: KVM: include missing hwcap.h into vcpu_fp
To:     Heiko Stuebner <heiko@sntech.de>
Cc:     Atish Patra <atishp@atishpatra.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        KVM General <kvm@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" 
        <kvm-riscv@lists.infradead.org>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 8, 2022 at 2:54 PM Heiko Stuebner <heiko@sntech.de> wrote:
>
> vcpu_fp uses the riscv_isa_extension mechanism which gets
> defined in hwcap.h but doesn't include that head file.
>
> While it seems to work in most cases, in certain conditions
> this can lead to build failures like
>
> ../arch/riscv/kvm/vcpu_fp.c: In function =E2=80=98kvm_riscv_vcpu_fp_reset=
=E2=80=99:
> ../arch/riscv/kvm/vcpu_fp.c:22:13: error: implicit declaration of functio=
n =E2=80=98riscv_isa_extension_available=E2=80=99 [-Werror=3Dimplicit-funct=
ion-declaration]
>    22 |         if (riscv_isa_extension_available(&isa, f) ||
>       |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> ../arch/riscv/kvm/vcpu_fp.c:22:49: error: =E2=80=98f=E2=80=99 undeclared =
(first use in this function)
>    22 |         if (riscv_isa_extension_available(&isa, f) ||
>
> Fix this by simply including the necessary header.
>
> Fixes: 0a86512dc113 ("RISC-V: KVM: Factor-out FP virtualization into sepa=
rate sources")
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>

I have queued this for RC fixes.

Thanks,
Anup

> ---
>  arch/riscv/kvm/vcpu_fp.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/riscv/kvm/vcpu_fp.c b/arch/riscv/kvm/vcpu_fp.c
> index 4449a976e5a6..d4308c512007 100644
> --- a/arch/riscv/kvm/vcpu_fp.c
> +++ b/arch/riscv/kvm/vcpu_fp.c
> @@ -11,6 +11,7 @@
>  #include <linux/err.h>
>  #include <linux/kvm_host.h>
>  #include <linux/uaccess.h>
> +#include <asm/hwcap.h>
>
>  #ifdef CONFIG_FPU
>  void kvm_riscv_vcpu_fp_reset(struct kvm_vcpu *vcpu)
> --
> 2.35.1
>
