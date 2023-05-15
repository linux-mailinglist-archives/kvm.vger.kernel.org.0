Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09DB7702BDC
	for <lists+kvm@lfdr.de>; Mon, 15 May 2023 13:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241551AbjEOLyE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 May 2023 07:54:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241528AbjEOLxf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 May 2023 07:53:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A06155B3
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 04:41:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B1EBE61ED0
        for <kvm@vger.kernel.org>; Mon, 15 May 2023 11:41:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 868ADC433EF;
        Mon, 15 May 2023 11:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684150876;
        bh=YB1agFtwGtExEUE18Rj7azPblRq+Aol6C8QN80qCQC8=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=T/j655uenxmNgU9uhRomkWr6f8MMsUCCCHRjR4dD9zKD/2XuwsDwD00lI1Ye8QKfP
         F6BiQ/hkFbbjcyN1NvVvqF4vXV66i15u/I19M2lQm2uSMyEQaBcjzkoBAmXMAaPaMH
         WvpOK5x0Bq8nY44D3SxalS8CedxkwCfhtTipiN75COMIajXnRi6jNfRjT4lF1mI/dH
         VdMp6waiCBO2vWOEg/fxJbGce1+fgiwKrirxemiHvUw9xqosHsVZNiNVm2jBAuvXjb
         c+98jb3W9FM3aAhIdnUcwk0HhtF54rDHT1A+1wWfwX28vafMrsOOfqhfgDaJNm9TUZ
         HhrLsGoDQzEhA==
From:   =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
To:     Andy Chiu <andy.chiu@sifive.com>, linux-riscv@lists.infradead.org,
        palmer@dabbelt.com, anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org
Cc:     vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Andy Chiu <andy.chiu@sifive.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>,
        Conor Dooley <conor.dooley@microchip.com>,
        Vincent Chen <vincent.chen@sifive.com>,
        Evan Green <evan@rivosinc.com>
Subject: Re: [PATCH -next v19 24/24] riscv: Add documentation for Vector
In-Reply-To: <20230509103033.11285-25-andy.chiu@sifive.com>
References: <20230509103033.11285-1-andy.chiu@sifive.com>
 <20230509103033.11285-25-andy.chiu@sifive.com>
Date:   Mon, 15 May 2023 13:41:13 +0200
Message-ID: <87r0rhhleu.fsf@all.your.base.are.belong.to.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Andy Chiu <andy.chiu@sifive.com> writes:

> This patch add a brief documentation of the userspace interface in
> regard to the RISC-V Vector extension.
>
> Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
> Reviewed-by: Greentime Hu <greentime.hu@sifive.com>
> Reviewed-by: Vincent Chen <vincent.chen@sifive.com>
> ---
>  Documentation/riscv/index.rst  |   1 +
>  Documentation/riscv/vector.rst | 128 +++++++++++++++++++++++++++++++++
>  2 files changed, 129 insertions(+)
>  create mode 100644 Documentation/riscv/vector.rst
>
> diff --git a/Documentation/riscv/index.rst b/Documentation/riscv/index.rst
> index 175a91db0200..95cf9c1e1da1 100644
> --- a/Documentation/riscv/index.rst
> +++ b/Documentation/riscv/index.rst
> @@ -10,6 +10,7 @@ RISC-V architecture
>      hwprobe
>      patch-acceptance
>      uabi
> +    vector
>=20=20
>      features
>=20=20
> diff --git a/Documentation/riscv/vector.rst b/Documentation/riscv/vector.=
rst
> new file mode 100644
> index 000000000000..d4d626721921
> --- /dev/null
> +++ b/Documentation/riscv/vector.rst
> @@ -0,0 +1,128 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +Vector Extension Support for RISC-V Linux
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +This document briefly outlines the interface provided to userspace by Li=
nux in
> +order to support the use of the RISC-V Vector Extension.
> +
> +1.  prctl() Interface
> +---------------------
> +
> +Two new prctl() calls are added to allow programs to manage the enableme=
nt
> +status for the use of Vector in userspace:
> +
> +prctl(PR_RISCV_V_SET_CONTROL, unsigned long arg)
> +
> +    Sets the Vector enablement status of the calling thread, where the c=
ontrol
> +    argument consists of two 2-bit enablement statuses and a bit for inh=
eritance
> +    model. Other threads of the calling process are unaffected.
> +
> +    Enablement status is a tri-state value each occupying 2-bit of space=
 in
> +    the control argument:
> +
> +    * :c:macro:`PR_RISCV_V_VSTATE_CTRL_DEFAULT`: Use the system-wide def=
ault
> +      enablement status on execve(). The system-wide default setting can=
 be
> +      controlled via sysctl interface (see sysctl section below).
> +
> +    * :c:macro:`PR_RISCV_V_VSTATE_CTRL_ON`: Allow Vector to be run for t=
he
> +      thread.
> +
> +    * :c:macro:`PR_RISCV_V_VSTATE_CTRL_OFF`: Disallow Vector. Executing =
Vector
> +      instructions under such condition will trap and casuse the termina=
tion of the thread.
> +
> +    arg: The control argument is a 5-bit value consisting of 3 parts, wh=
ich can
> +    be interpreted as the following structure, and accessed by 3 masks
> +    respectively.
> +
> +    struct control_argument {
> +        // Located by PR_RISCV_V_VSTATE_CTRL_CUR_MASK
> +        int current_enablement_status : 2;
> +        // Located by PR_RISCV_V_VSTATE_CTRL_NEXT_MASK
> +        int next_enablement_status : 2;
> +        // Located by PR_RISCV_V_VSTATE_CTRL_INHERIT
> +        bool inherit_mode : 1;
> +    }

Maybe just me, but the C bitfield is just confusing here. I'd remove
that, and just keep the section below.

> +
> +    The 3 masks, PR_RISCV_V_VSTATE_CTRL_CUR_MASK,
> +    PR_RISCV_V_VSTATE_CTRL_NEXT_MASK, and PR_RISCV_V_VSTATE_CTRL_INHERIT
> +    represents bit[1:0], bit[3:2], and bit[4] respectively. bit[1:0] and
> +    accounts for the enablement status of current thread, and bit[3:2] t=
he
> +    setting for when next execve() happens. bit[4] defines the inheritan=
ce model
> +    of the setting in bit[3:2]
> +
> +        * :c:macro:`PR_RISCV_V_VSTATE_CTRL_CUR_MASK`: bit[1:0]: Account =
for the
> +          Vector enablement status for the calling thread. The calling t=
hread is
> +          not able to turn off Vector once it has been enabled. The prct=
l() call
> +          fails with EPERM if the value in this mask is PR_RISCV_V_VSTAT=
E_CTRL_OFF
> +          but the current enablement status is not off. Setting
> +          PR_RISCV_V_VSTATE_CTRL_DEFAULT here takes no effect but to set=
 back
> +          the original enablement status.
> +
> +        * :c:macro:`PR_RISCV_V_VSTATE_CTRL_NEXT_MASK`: bit[3:2]: Account=
 for the
> +          Vector enablement setting for the calling thread at the next e=
xecve()
> +          system call. If PR_RISCV_V_VSTATE_CTRL_DEFAULT is used in this=
 mask,
> +          then the enablement status will be decided by the system-wide
> +          enablement status when execve() happen.
> +
> +        * :c:macro:`PR_RISCV_V_VSTATE_CTRL_INHERIT`: bit[4]: the inherit=
ance
> +          model for the setting at PR_RISCV_V_VSTATE_CTRL_NEXT_MASK. If =
the bit
> +          is set then the following execve() will not clear the setting =
in both
> +          PR_RISCV_V_VSTATE_CTRL_NEXT_MASK and PR_RISCV_V_VSTATE_CTRL_IN=
HERIT.
> +          This setting persists across changes in the system-wide defaul=
t value.
> +
> +    Return value: return 0 on success, or a negative error value:
> +        EINVAL: Vector not supported, invalid enablement status for curr=
ent or
> +                next mask
> +        EPERM: Turning off Vector in PR_RISCV_V_VSTATE_CTRL_CUR_MASK if =
Vector
> +                was enabled for the calling thread.
> +
> +    On success:
> +        * A valid setting for PR_RISCV_V_VSTATE_CTRL_CUR_MASK takes place
> +          immediately. The enablement status specified in
> +          PR_RISCV_V_VSTATE_CTRL_NEXT_MASK happens at the next execve() =
call, or
> +          all following execve() calls if PR_RISCV_V_VSTATE_CTRL_INHERIT=
 bit is
> +          set.
> +        * Every successful call overwrites a previous setting for the ca=
lling
> +          thread.
> +
> +prctl(PR_RISCV_V_SET_CONTROL)

s/SET/GET/


Bj=C3=B6rn
