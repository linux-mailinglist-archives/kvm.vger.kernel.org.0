Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB6A67F71A
	for <lists+kvm@lfdr.de>; Sat, 28 Jan 2023 11:28:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234113AbjA1K2k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 28 Jan 2023 05:28:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234039AbjA1K2g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 28 Jan 2023 05:28:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3CDF4B88D
        for <kvm@vger.kernel.org>; Sat, 28 Jan 2023 02:28:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B16860B83
        for <kvm@vger.kernel.org>; Sat, 28 Jan 2023 10:28:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EE6AC433EF;
        Sat, 28 Jan 2023 10:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674901709;
        bh=LdatDRj19NTRu/mqjPRI5md+JhOX3+rhr/gM9iD9Ufo=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=cFadJIPwcmhTLyHvg5LQ8QQvb9Cwxset2eCqHtvwsOp0s2Xse5iH8wX1l4XnLFZLA
         qwmxNSPdtfYX6NtrPHqYN3IaeJHoQDc/BLKC/OlGfQ1hhD+3L3fkyivZrGB0sLzPHt
         5Z6KsMLFvq4WMYh4g0voBaLWGoMJld5gWy2mywi1KGxIZj5fUPRqLyB9fg8gyM1+1k
         /yuewWAu/9QcShcKezSRBhQkRE9b3tlR3zX//zZ5PbXGyhUt0NcFBRYhjQJTljGm6y
         7VndGaKFLFXwKOVNFkZFMjttzp4G6T8zQeDVdhwxaBc2J6Nn14Ls0MhSsXLsl87se1
         IbAK0iNLqqZhQ==
Date:   Sat, 28 Jan 2023 10:28:26 +0000
From:   Conor Dooley <conor@kernel.org>
To:     Guo Ren <guoren@kernel.org>
CC:     Andy Chiu <andy.chiu@sifive.com>, linux-riscv@lists.infradead.org,
        palmer@dabbelt.com, anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Guo Ren <ren_guo@c-sky.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Heiko Stuebner <heiko@sntech.de>,
        Atish Patra <atishp@rivosinc.com>,
        Anup Patel <apatel@ventanamicro.com>,
        Mayuresh Chitale <mchitale@ventanamicro.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Dao Lu <daolu@rivosinc.com>,
        Jisheng Zhang <jszhang@kernel.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        Vincent Chen <vincent.chen@sifive.com>,
        Tsukasa OI <research_trasio@irq.a4lg.com>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_-next_v13_02/19=5D_riscv=3A_Exte?= =?US-ASCII?Q?nding_cpufeature=2Ec_to_detect_V-extension?=
User-Agent: K-9 Mail for Android
In-Reply-To: <CAJF2gTS11DcKuSBRQfn9AkU0YP=ry-FV=cH=Au5m3Us=1gVTQQ@mail.gmail.com>
References: <20230125142056.18356-1-andy.chiu@sifive.com> <20230125142056.18356-3-andy.chiu@sifive.com> <Y9GgKiF8q2k9eRdh@spud> <CAJF2gTS11DcKuSBRQfn9AkU0YP=ry-FV=cH=Au5m3Us=1gVTQQ@mail.gmail.com>
Message-ID: <3AE48592-5756-4D49-B860-1D8C54ACFF3A@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 28 January 2023 07:09:18 GMT, Guo Ren <guoren@kernel=2Eorg> wrote:
>On Thu, Jan 26, 2023 at 5:33 AM Conor Dooley <conor@kernel=2Eorg> wrote:
>>
>> On Wed, Jan 25, 2023 at 02:20:39PM +0000, Andy Chiu wrote:
>> > From: Guo Ren <ren_guo@c-sky=2Ecom>
>> >
>> > Add V-extension into riscv_isa_ext_keys array and detect it with isa
>> > string parsing=2E
>> >
>> > Signed-off-by: Guo Ren <ren_guo@c-sky=2Ecom>
>> > Signed-off-by: Guo Ren <guoren@linux=2Ealibaba=2Ecom>
>> > Signed-off-by: Greentime Hu <greentime=2Ehu@sifive=2Ecom>
>> > Suggested-by: Vineet Gupta <vineetg@rivosinc=2Ecom>
>> > Signed-off-by: Andy Chiu <andy=2Echiu@sifive=2Ecom>
>> > ---
>> >  arch/riscv/include/asm/hwcap=2Eh      |  4 ++++
>> >  arch/riscv/include/asm/vector=2Eh     | 26 +++++++++++++++++++++++++=
+
>> >  arch/riscv/include/uapi/asm/hwcap=2Eh |  1 +
>> >  arch/riscv/kernel/cpufeature=2Ec      | 12 ++++++++++++
>> >  4 files changed, 43 insertions(+)
>> >  create mode 100644 arch/riscv/include/asm/vector=2Eh
>> >
>> > diff --git a/arch/riscv/include/asm/hwcap=2Eh b/arch/riscv/include/as=
m/hwcap=2Eh
>> > index 57439da71c77=2E=2Ef413db6118e5 100644
>> > --- a/arch/riscv/include/asm/hwcap=2Eh
>> > +++ b/arch/riscv/include/asm/hwcap=2Eh
>> > @@ -35,6 +35,7 @@ extern unsigned long elf_hwcap;
>> >  #define RISCV_ISA_EXT_m              ('m' - 'a')
>> >  #define RISCV_ISA_EXT_s              ('s' - 'a')
>> >  #define RISCV_ISA_EXT_u              ('u' - 'a')
>> > +#define RISCV_ISA_EXT_v              ('v' - 'a')
>> >
>> >  /*
>> >   * Increse this to higher value as kernel support more ISA extension=
s=2E
>> > @@ -73,6 +74,7 @@ static_assert(RISCV_ISA_EXT_ID_MAX <=3D RISCV_ISA_E=
XT_MAX);
>> >  enum riscv_isa_ext_key {
>> >       RISCV_ISA_EXT_KEY_FPU,          /* For 'F' and 'D' */
>> >       RISCV_ISA_EXT_KEY_SVINVAL,
>> > +     RISCV_ISA_EXT_KEY_VECTOR,       /* For 'V' */
>>
>> That's obvious surely, no?
>>
>> >       RISCV_ISA_EXT_KEY_ZIHINTPAUSE,
>> >       RISCV_ISA_EXT_KEY_MAX,
>> >  };
>> > @@ -95,6 +97,8 @@ static __always_inline int riscv_isa_ext2key(int nu=
m)
>>
>> You should probably check out Jisheng's series that deletes whole
>> sections of this code, including this whole function=2E
>> https://lore=2Ekernel=2Eorg/all/20230115154953=2E831-3-jszhang@kernel=
=2Eorg/T/#u
>Has that patch merged? It could be solved during the rebase for-next natu=
rally=2E

Not merged yet=2E Pretty sure Andy used for-next
as his base so that CI could test it more easily
I was just pointing out it's existence in case he
hadn't seen it=2E
Hopefully Jishengs stuff will make 6=2E3 :)

>
>>
>>
>> > @@ -256,6 +257,17 @@ void __init riscv_fill_hwcap(void)
>> >               elf_hwcap &=3D ~COMPAT_HWCAP_ISA_F;
>> >       }
>> >
>> > +     if (elf_hwcap & COMPAT_HWCAP_ISA_V) {
>> > +#ifndef CONFIG_RISCV_ISA_V
>> > +             /*
>> > +              * ISA string in device tree might have 'v' flag, but
>> > +              * CONFIG_RISCV_ISA_V is disabled in kernel=2E
>> > +              * Clear V flag in elf_hwcap if CONFIG_RISCV_ISA_V is d=
isabled=2E
>> > +              */
>> > +             elf_hwcap &=3D ~COMPAT_HWCAP_ISA_V;
>> > +#endif
>       if (elf_hwcap & COMPAT_HWCAP_ISA_V && !IS_ENABLED(CONFIG_RISCV_ISA=
_V)) {
>
>right?
>>
>> I know that a later patch in this series calls rvv_enable() here, which
>> I'll comment on there, but I'd rather see IS_ENABLED as opposed to
>> ifdefs in C files where possible=2E
>>
>> Thanks,
>> Conor=2E
>>
>
>
