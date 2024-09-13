Return-Path: <kvm+bounces-26791-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BEFC5977BF3
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 11:11:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7FA2E285DFA
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 09:11:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C5061D6DBC;
	Fri, 13 Sep 2024 09:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=flygoat.com header.i=@flygoat.com header.b="ExTFxaOM";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="LSzpmTvK"
X-Original-To: kvm@vger.kernel.org
Received: from fout7-smtp.messagingengine.com (fout7-smtp.messagingengine.com [103.168.172.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AAB31D58B2;
	Fri, 13 Sep 2024 09:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726218653; cv=none; b=EmmIWVCqhnkDC9b0wqpTOdqrQEAqOpnyFkpkBHq2gc+eWpi5DAx8+Sqq4l1oM6ct2Z9EUPiqmIqUoIgusU6GsLK4XfxX37VN7q8oD48JUlBSBmC3efb57ue3GIjP8zS4t899sWh6uFNgiMuwd9L7NX7q1JTAYQ6Mh+cexUuBnJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726218653; c=relaxed/simple;
	bh=tt9AADMrwVNUsXHIqAOKdNpwu64ra0IXp/MHU7EzxmQ=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=uszbwTn4VLRQ0jbzcZpdq8RH5hCsQ4bUAmCIethr5JBJHKIX28ou+iPgIRmVpt8dOnav1X1d9woc/oTo+hwainIqlHUU5ZFvpBYcUN/PexUarLfH7ASyFSZZ7G8yPDLq08aCzipAA6Gow6vEQLhlxzbUIO50/cwLfyNNzykPKu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=flygoat.com; spf=pass smtp.mailfrom=flygoat.com; dkim=pass (2048-bit key) header.d=flygoat.com header.i=@flygoat.com header.b=ExTFxaOM; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=LSzpmTvK; arc=none smtp.client-ip=103.168.172.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=flygoat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flygoat.com
Received: from phl-compute-09.internal (phl-compute-09.phl.internal [10.202.2.49])
	by mailfout.phl.internal (Postfix) with ESMTP id 281CE13802B2;
	Fri, 13 Sep 2024 05:10:49 -0400 (EDT)
Received: from phl-imap-12 ([10.202.2.86])
  by phl-compute-09.internal (MEProxy); Fri, 13 Sep 2024 05:10:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1726218649;
	 x=1726305049; bh=FJ45Qglvg7DmjFxDy6maK3tnXPu/iEdwJfotzp3qoVY=; b=
	ExTFxaOM1q2QaFIn5lMTUZRkL3s3wsqh2uACtKgm2++6I8Cxbuarlx73WuTfodr+
	1BG52BjtQ2O/RbOeHY6Z5nQkez1OTWLHrw9Y0HdlwCG7Fcqffcm9ZE/Z42MUw6e7
	aJ1k6eLQeyWnQzqilmgQFjTxoRlR/as6/lCk3zH39XuljGSLdvDfM87v/n7ohRLK
	q9k4demWaxJOiy9mMFAW3aqlDjJC/OC9NwEmy69O96Fht5SMVvyfM6Anra7fPhYb
	fBJFHPwan1xmQbtth9l/LYFNR8i5qnFS4B7K6V6gTiiYoVJJlkLRbdknR0LpiI5q
	S4tQHPtdDuDOfectuh04SA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1726218649; x=
	1726305049; bh=FJ45Qglvg7DmjFxDy6maK3tnXPu/iEdwJfotzp3qoVY=; b=L
	SzpmTvKYIF5kHP5K92PZi0/P6uMjICaF3iGyvPH8pPsB2p2rAbeVJ0MrxBwZHLWS
	vwU1MB6JZCIELNgabHhzhAOZLt5M8i5ie5bkMDSppFPjNrsHxluzZpQjbRVyZglX
	9t3GYgDXiLuwU2NHU2+J1w04V03e+pH6SSyCyOiIGXsUftHsl25QN5WC+apWqqof
	+Ui9WOf9Z0UAeJr5w2RDbrq4SukapfQnvpceTr9VSvxfOCfBYwB+K0CevPj5lNSF
	awYmOZ2IF6sy/CGw1Hl0eBY9hcNrrbMeeukbxHtbFir99XQZP4q3UIZIlO9vOkN3
	5EaIK3QW/8Cd+MaNk/3kg==
X-ME-Sender: <xms:mAHkZs58ehgy0N4vhx2YdYQMhZOLsKB1XYqdEW7-rkcwoVtJwOG_hg>
    <xme:mAHkZt5TJnLA5yoStQU0eMuqwJdk-iY43LttYqwyDED4quoAtVd543NrTsfcTqpS1
    7TknnLWC_HhaaBTSXQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrudejjedgudduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhepofggfffhvfevkfgjfhfutgfgsehtqhertdertdej
    necuhfhrohhmpedflfhirgiguhhnucgjrghnghdfuceojhhirgiguhhnrdihrghnghesfh
    hlhihgohgrthdrtghomheqnecuggftrfgrthhtvghrnhepjeehfeduvddtgffgvdffkeet
    hefhlefgvdevvdekuefffeekheehgeevhfevteejnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepjhhirgiguhhnrdihrghnghesfhhlhihgohgr
    thdrtghomhdpnhgspghrtghpthhtohepuddupdhmohguvgepshhmthhpohhuthdprhgtph
    htthhopehtshgsohhgvghnugesrghlphhhrgdrfhhrrghnkhgvnhdruggvpdhrtghpthht
    oheptghhvghnhhhurggtrghisehkvghrnhgvlhdrohhrghdprhgtphhtthhopehrrghfrg
    gvlheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepvhhirhgvshhhrdhkuhhmrghrsehl
    ihhnrghrohdrohhrghdprhgtphhtthhopehtghhlgieslhhinhhuthhrohhnihigrdguvg
    dprhgtphhtthhopehlohhonhhgrghrtghhsehlihhsthhsrdhlihhnuhigrdguvghvpdhr
    tghpthhtohepkhhvmhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlih
    hnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehl
    ihhnuhigqdhmihhpshesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:mAHkZreBs9WeD2wS-4sgdFp08F2qC_tlncrS_kXiaFyZY3gZpEEJCg>
    <xmx:mAHkZhIRkM_6p6WglSJG38Xq1-yLnpz_YUilrHgTLr6Sz1l1pStRPg>
    <xmx:mAHkZgI1iWTI-sWtiM2oEdAejdsQo6QLXm5oIs-jr1b0h2qRheqEQQ>
    <xmx:mAHkZiz6yS6epgx0Hz0fHV15BuOnWeYnZMReLDTfgw37ODVKNf3k6Q>
    <xmx:mQHkZtALj-7B8j9db26vWy2uo4xeplo4CRbDzNqmchNcB2Br6nCwg1Yy>
Feedback-ID: ifd894703:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 2A1761C20065; Fri, 13 Sep 2024 05:10:48 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 13 Sep 2024 10:10:09 +0100
From: "Jiaxun Yang" <jiaxun.yang@flygoat.com>
To: "Huacai Chen" <chenhuacai@kernel.org>
Cc: "Xuerui Wang" <kernel@xen0n.name>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 "Viresh Kumar" <viresh.kumar@linaro.org>,
 "Thomas Gleixner" <tglx@linutronix.de>,
 "Thomas Bogendoerfer" <tsbogend@alpha.franken.de>, loongarch@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
 "linux-mips@vger.kernel.org" <linux-mips@vger.kernel.org>,
 kvm@vger.kernel.org
Message-Id: <84c6e819-e2b8-40b6-8de4-9f550e652acc@app.fastmail.com>
In-Reply-To: 
 <CAAhV-H74OCxnRQjHXtu-CuVaEb5bsMQ4vR4wCOvztZdV-HWEVg@mail.gmail.com>
References: <20240912-iocsr-v2-0-e88f75b37da4@flygoat.com>
 <20240912-iocsr-v2-1-e88f75b37da4@flygoat.com>
 <CAAhV-H74OCxnRQjHXtu-CuVaEb5bsMQ4vR4wCOvztZdV-HWEVg@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] LoongArch: Probe more CPU features from CPUCFG
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable



=E5=9C=A82024=E5=B9=B49=E6=9C=8813=E6=97=A5=E4=B9=9D=E6=9C=88 =E4=B8=8A=E5=
=8D=889:46=EF=BC=8CHuacai Chen=E5=86=99=E9=81=93=EF=BC=9A
> Hi, Jiaxun,
>
> On Fri, Sep 13, 2024 at 4:56=E2=80=AFAM Jiaxun Yang <jiaxun.yang@flygo=
at.com> wrote:
>>
>> Probe ISA level, TLB, IOCSR information from CPUCFG to
>> improve kernel resilience to different core implementations.
>>
>> Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
>> ---
>>  arch/loongarch/include/asm/cpu.h       |  4 +++
>>  arch/loongarch/include/asm/loongarch.h |  3 +-
>>  arch/loongarch/kernel/cpu-probe.c      | 54 ++++++++++++++++++++++++=
----------
>>  3 files changed, 44 insertions(+), 17 deletions(-)
>>
>> diff --git a/arch/loongarch/include/asm/cpu.h b/arch/loongarch/includ=
e/asm/cpu.h
>> index 843f9c4ec980..251a15439cff 100644
>> --- a/arch/loongarch/include/asm/cpu.h
>> +++ b/arch/loongarch/include/asm/cpu.h
>> @@ -100,6 +100,8 @@ enum cpu_type_enum {
>>  #define CPU_FEATURE_HYPERVISOR         25      /* CPU has hypervisor=
 (running in VM) */
>>  #define CPU_FEATURE_PTW                        26      /* CPU has ha=
rdware page table walker */
>>  #define CPU_FEATURE_AVECINT            27      /* CPU has avec inter=
rupt */
>> +#define CPU_FEATURE_IOCSR              28      /* CPU has IOCSR */
>> +#define CPU_FEATURE_LSPW               29      /* CPU has LSPW */
> I don't see LSPW being used, so just remove it now?

I=E2=80=99m going to submit a page table walker for CPU without SPW late=
r on :-)

I=E2=80=99m fine with adding that later.

Thanks
- Jiaxun

>
>>
>>  #define LOONGARCH_CPU_CPUCFG           BIT_ULL(CPU_FEATURE_CPUCFG)
>>  #define LOONGARCH_CPU_LAM              BIT_ULL(CPU_FEATURE_LAM)
>> @@ -129,5 +131,7 @@ enum cpu_type_enum {
>>  #define LOONGARCH_CPU_HYPERVISOR       BIT_ULL(CPU_FEATURE_HYPERVISO=
R)
>>  #define LOONGARCH_CPU_PTW              BIT_ULL(CPU_FEATURE_PTW)
>>  #define LOONGARCH_CPU_AVECINT          BIT_ULL(CPU_FEATURE_AVECINT)
>> +#define LOONGARCH_CPU_IOCSR            BIT_ULL(CPU_FEATURE_IOCSR)
>> +#define LOONGARCH_CPU_LSPW             BIT_ULL(CPU_FEATURE_LSPW)
>>
>>  #endif /* _ASM_CPU_H */
>> diff --git a/arch/loongarch/include/asm/loongarch.h b/arch/loongarch/=
include/asm/loongarch.h
>> index 631d249b3ef2..23af28f00c3c 100644
>> --- a/arch/loongarch/include/asm/loongarch.h
>> +++ b/arch/loongarch/include/asm/loongarch.h
>> @@ -60,8 +60,7 @@
>>  #define  CPUCFG0_PRID                  GENMASK(31, 0)
>>
>>  #define LOONGARCH_CPUCFG1              0x1
>> -#define  CPUCFG1_ISGR32                        BIT(0)
>> -#define  CPUCFG1_ISGR64                        BIT(1)
>> +#define  CPUCFG1_ISA                   GENMASK(1, 0)
>>  #define  CPUCFG1_PAGING                        BIT(2)
>>  #define  CPUCFG1_IOCSR                 BIT(3)
>>  #define  CPUCFG1_PABITS                        GENMASK(11, 4)
>> diff --git a/arch/loongarch/kernel/cpu-probe.c b/arch/loongarch/kerne=
l/cpu-probe.c
>> index 14f0449f5452..5dc8ca3c4387 100644
>> --- a/arch/loongarch/kernel/cpu-probe.c
>> +++ b/arch/loongarch/kernel/cpu-probe.c
>> @@ -92,11 +92,29 @@ static void cpu_probe_common(struct cpuinfo_loong=
arch *c)
>>         unsigned long asid_mask;
>>
>>         c->options =3D LOONGARCH_CPU_CPUCFG | LOONGARCH_CPU_CSR |
>> -                    LOONGARCH_CPU_TLB | LOONGARCH_CPU_VINT | LOONGAR=
CH_CPU_WATCH;
>> +                    LOONGARCH_CPU_VINT | LOONGARCH_CPU_WATCH;
>>
>>         elf_hwcap =3D HWCAP_LOONGARCH_CPUCFG;
>>
>>         config =3D read_cpucfg(LOONGARCH_CPUCFG1);
>> +
>> +       switch (config & CPUCFG1_ISA) {
>> +       case 0:
>> +               set_isa(c, LOONGARCH_CPU_ISA_LA32R);
>> +               break;
>> +       case 1:
>> +               set_isa(c, LOONGARCH_CPU_ISA_LA32S);
>> +               break;
>> +       case 2:
>> +               set_isa(c, LOONGARCH_CPU_ISA_LA64);
>> +               break;
>> +       default:
>> +               pr_warn("Warning: unknown ISA level\n");
>> +       }
>> +       if (config & CPUCFG1_PAGING)
>> +               c->options |=3D LOONGARCH_CPU_TLB;
>> +       if (config & CPUCFG1_IOCSR)
>> +               c->options |=3D LOONGARCH_CPU_IOCSR;
>>         if (config & CPUCFG1_UAL) {
>>                 c->options |=3D LOONGARCH_CPU_UAL;
>>                 elf_hwcap |=3D HWCAP_LOONGARCH_UAL;
>> @@ -157,6 +175,8 @@ static void cpu_probe_common(struct cpuinfo_loong=
arch *c)
>>                 elf_hwcap |=3D HWCAP_LOONGARCH_LBT_MIPS;
>>         }
>>  #endif
>> +       if (config & CPUCFG2_LSPW)
>> +               c->options |=3D LOONGARCH_CPU_LSPW;
>>
>>         config =3D read_cpucfg(LOONGARCH_CPUCFG6);
>>         if (config & CPUCFG6_PMP)
>> @@ -222,6 +242,7 @@ static inline void cpu_probe_loongson(struct cpui=
nfo_loongarch *c, unsigned int
>>  {
>>         uint64_t *vendor =3D (void *)(&cpu_full_name[VENDOR_OFFSET]);
>>         uint64_t *cpuname =3D (void *)(&cpu_full_name[CPUNAME_OFFSET]=
);
>> +       const char *core_name =3D "Unknown";
>>
>>         if (!__cpu_full_name[cpu])
>>                 __cpu_full_name[cpu] =3D cpu_full_name;
>> @@ -232,40 +253,43 @@ static inline void cpu_probe_loongson(struct cp=
uinfo_loongarch *c, unsigned int
>>         switch (c->processor_id & PRID_SERIES_MASK) {
>>         case PRID_SERIES_LA132:
>>                 c->cputype =3D CPU_LOONGSON32;
>> -               set_isa(c, LOONGARCH_CPU_ISA_LA32S);
>>                 __cpu_family[cpu] =3D "Loongson-32bit";
>> -               pr_info("32-bit Loongson Processor probed (LA132 Core=
)\n");
>> +               core_name =3D "LA132";
>>                 break;
>>         case PRID_SERIES_LA264:
>>                 c->cputype =3D CPU_LOONGSON64;
>> -               set_isa(c, LOONGARCH_CPU_ISA_LA64);
>>                 __cpu_family[cpu] =3D "Loongson-64bit";
>> -               pr_info("64-bit Loongson Processor probed (LA264 Core=
)\n");
>> +               core_name =3D "LA264";
>>                 break;
>>         case PRID_SERIES_LA364:
>>                 c->cputype =3D CPU_LOONGSON64;
>> -               set_isa(c, LOONGARCH_CPU_ISA_LA64);
>>                 __cpu_family[cpu] =3D "Loongson-64bit";
>> -               pr_info("64-bit Loongson Processor probed (LA364 Core=
)\n");
>> +               core_name =3D "LA364";
>>                 break;
>>         case PRID_SERIES_LA464:
>>                 c->cputype =3D CPU_LOONGSON64;
>> -               set_isa(c, LOONGARCH_CPU_ISA_LA64);
>>                 __cpu_family[cpu] =3D "Loongson-64bit";
>> -               pr_info("64-bit Loongson Processor probed (LA464 Core=
)\n");
>> +               core_name =3D "LA464";
>>                 break;
>>         case PRID_SERIES_LA664:
>>                 c->cputype =3D CPU_LOONGSON64;
>> -               set_isa(c, LOONGARCH_CPU_ISA_LA64);
>>                 __cpu_family[cpu] =3D "Loongson-64bit";
>> -               pr_info("64-bit Loongson Processor probed (LA664 Core=
)\n");
>> +               core_name =3D "LA664";
>>                 break;
>>         default: /* Default to 64 bit */
>> -               c->cputype =3D CPU_LOONGSON64;
>> -               set_isa(c, LOONGARCH_CPU_ISA_LA64);
>> -               __cpu_family[cpu] =3D "Loongson-64bit";
>> -               pr_info("64-bit Loongson Processor probed (Unknown Co=
re)\n");
>> +               if (c->isa_level & LOONGARCH_CPU_ISA_LA64) {
>> +                       c->cputype =3D CPU_LOONGSON64;
>> +                       __cpu_family[cpu] =3D "Loongson-64bit";
>> +               } else if (c->isa_level & LOONGARCH_CPU_ISA_LA32S) {
>> +                       c->cputype =3D CPU_LOONGSON32;
>> +                       __cpu_family[cpu] =3D "Loongson-32bit";
>> +               } else if (c->isa_level & LOONGARCH_CPU_ISA_LA32R) {
>> +                       c->cputype =3D CPU_LOONGSON32;
>> +                       __cpu_family[cpu] =3D "Loongson-32bit Reduced=
";
>> +               }
> I prefer to move this part before the switch-case of PRID (and it is
> better to convert to a switch-case too), then the switch-case of PRID
> can be only used for probing core-name.
>
> Huacai
>
>>         }
>> +
>> +       pr_info("%s Processor probed (%s Core)\n", __cpu_family[cpu],=
 core_name);
>>  }
>>
>>  #ifdef CONFIG_64BIT
>>
>> --
>> 2.46.0
>>

--=20
- Jiaxun

