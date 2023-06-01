Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B50417191F8
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 06:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbjFAEq2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 00:46:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjFAEq0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 00:46:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5082BD1
        for <kvm@vger.kernel.org>; Wed, 31 May 2023 21:46:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D785E64016
        for <kvm@vger.kernel.org>; Thu,  1 Jun 2023 04:46:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DC05C433EF
        for <kvm@vger.kernel.org>; Thu,  1 Jun 2023 04:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685594784;
        bh=6PWxODOB5BjJ2+hJ5LQ+k3DS3JqdXw0tvj806HzZMps=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Yg/wTLmoK7DBqYcnP3Ib0Ubd2VVoLae5benlTL7SnxKl2HyMf/Ro2UPNqMeKpxLJM
         KGlPOhY74cfdb7OPK7avVi3sBBWkiHEbUaMrGkluhprhI+xzIiE5itSxNrmzKuvmtX
         vT8RiVkoNBSKlOD9Pd8bXptM18oBCMpcGRoXPqReaYdIfwFL4aV4HtKft8hQWWEOHq
         mSXa+UI+elzU9QxhVJfL5hZxxdg48sRH2u8BR5vtOuvfJ1O7nOiNk+Sz9GY89Q04y9
         fYKHQz5VeEXwbj7VUwpgrR7US6h2XC+kE+AUftl4vM6La6fu8jsN0L6JHonvoW4F7Q
         6w0Z6pfvbddow==
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-4f3b314b1d7so327227e87.1
        for <kvm@vger.kernel.org>; Wed, 31 May 2023 21:46:24 -0700 (PDT)
X-Gm-Message-State: AC+VfDygih6CyF2QmT8qK+PsqxFot3wmXjGVVGEG+eJyuNoLntFU0pzf
        zKBYTQ8h/9rccuRVxWQAHi7vWTomS5yfy4/xeAU=
X-Google-Smtp-Source: ACHHUZ7N6vBdj6gVyW7L8xDyB9SffvV07lFwdCsIsM3G5zOmwiFyTLV/4LGBiFc+iJJEUBO/+74+cgsZzpD1eAuWtPE=
X-Received: by 2002:ac2:4c14:0:b0:4eb:42b7:8c18 with SMTP id
 t20-20020ac24c14000000b004eb42b78c18mr594264lfq.53.1685594782235; Wed, 31 May
 2023 21:46:22 -0700 (PDT)
MIME-Version: 1.0
References: <20230518161949.11203-1-andy.chiu@sifive.com> <20230518161949.11203-4-andy.chiu@sifive.com>
In-Reply-To: <20230518161949.11203-4-andy.chiu@sifive.com>
From:   Guo Ren <guoren@kernel.org>
Date:   Thu, 1 Jun 2023 12:46:10 +0800
X-Gmail-Original-Message-ID: <CAJF2gTRpTdXeDXczaVCmZdd0fNQADBPpd3+VMnYsd+XcudHSXg@mail.gmail.com>
Message-ID: <CAJF2gTRpTdXeDXczaVCmZdd0fNQADBPpd3+VMnYsd+XcudHSXg@mail.gmail.com>
Subject: Re: [PATCH -next v20 03/26] riscv: hwprobe: Add support for probing V
 in RISCV_HWPROBE_KEY_IMA_EXT_0
To:     Andy Chiu <andy.chiu@sifive.com>
Cc:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Jonathan Corbet <corbet@lwn.net>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>,
        Conor Dooley <conor.dooley@microchip.com>,
        Evan Green <evan@rivosinc.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Andrew Bresticker <abrestic@rivosinc.com>,
        Celeste Liu <coelacanthus@outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 19, 2023 at 12:20=E2=80=AFAM Andy Chiu <andy.chiu@sifive.com> w=
rote:
>
> Probing kernel support for Vector extension is available now. This only
> add detection for V only. Extenions like Zvfh, Zk are not in this scope.
>
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
Reviewed-by: Guo Ren <guoren@kernel.org>

> ---
> Changelog v20:
>  - Fix a typo in document, and remove duplicated probes (Heiko)
>  - probe V extension in RISCV_HWPROBE_KEY_IMA_EXT_0 key only (Palmer,
>    Evan)
> ---
>  Documentation/riscv/hwprobe.rst       | 3 +++
>  arch/riscv/include/uapi/asm/hwprobe.h | 1 +
>  arch/riscv/kernel/sys_riscv.c         | 4 ++++
>  3 files changed, 8 insertions(+)
>
> diff --git a/Documentation/riscv/hwprobe.rst b/Documentation/riscv/hwprob=
e.rst
> index 9f0dd62dcb5d..7431d9d01c73 100644
> --- a/Documentation/riscv/hwprobe.rst
> +++ b/Documentation/riscv/hwprobe.rst
> @@ -64,6 +64,9 @@ The following keys are defined:
>    * :c:macro:`RISCV_HWPROBE_IMA_C`: The C extension is supported, as def=
ined
>      by version 2.2 of the RISC-V ISA manual.
>
> +  * :c:macro:`RISCV_HWPROBE_IMA_V`: The V extension is supported, as def=
ined by
> +    version 1.0 of the RISC-V Vector extension manual.
> +
>  * :c:macro:`RISCV_HWPROBE_KEY_CPUPERF_0`: A bitmask that contains perfor=
mance
>    information about the selected set of processors.
>
> diff --git a/arch/riscv/include/uapi/asm/hwprobe.h b/arch/riscv/include/u=
api/asm/hwprobe.h
> index 8d745a4ad8a2..7c6fdcf7ced5 100644
> --- a/arch/riscv/include/uapi/asm/hwprobe.h
> +++ b/arch/riscv/include/uapi/asm/hwprobe.h
> @@ -25,6 +25,7 @@ struct riscv_hwprobe {
>  #define RISCV_HWPROBE_KEY_IMA_EXT_0    4
>  #define                RISCV_HWPROBE_IMA_FD            (1 << 0)
>  #define                RISCV_HWPROBE_IMA_C             (1 << 1)
> +#define                RISCV_HWPROBE_IMA_V             (1 << 2)
>  #define RISCV_HWPROBE_KEY_CPUPERF_0    5
>  #define                RISCV_HWPROBE_MISALIGNED_UNKNOWN        (0 << 0)
>  #define                RISCV_HWPROBE_MISALIGNED_EMULATED       (1 << 0)
> diff --git a/arch/riscv/kernel/sys_riscv.c b/arch/riscv/kernel/sys_riscv.=
c
> index 5db29683ebee..88357a848797 100644
> --- a/arch/riscv/kernel/sys_riscv.c
> +++ b/arch/riscv/kernel/sys_riscv.c
> @@ -10,6 +10,7 @@
>  #include <asm/cpufeature.h>
>  #include <asm/hwprobe.h>
>  #include <asm/sbi.h>
> +#include <asm/vector.h>
>  #include <asm/switch_to.h>
>  #include <asm/uaccess.h>
>  #include <asm/unistd.h>
> @@ -171,6 +172,9 @@ static void hwprobe_one_pair(struct riscv_hwprobe *pa=
ir,
>                 if (riscv_isa_extension_available(NULL, c))
>                         pair->value |=3D RISCV_HWPROBE_IMA_C;
>
> +               if (has_vector())
> +                       pair->value |=3D RISCV_HWPROBE_IMA_V;
> +
>                 break;
>
>         case RISCV_HWPROBE_KEY_CPUPERF_0:
> --
> 2.17.1
>


--=20
Best Regards
 Guo Ren
