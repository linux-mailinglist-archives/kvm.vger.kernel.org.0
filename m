Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B31269D5E7
	for <lists+kvm@lfdr.de>; Mon, 20 Feb 2023 22:40:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232442AbjBTVkq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Feb 2023 16:40:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232373AbjBTVko (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Feb 2023 16:40:44 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D8512196C;
        Mon, 20 Feb 2023 13:40:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=UTk0dveSKg3b6P6AkYblFEZidtHjEc+p03cXOJW2DpE=; b=Vx/urWg1Ywy799l6vsYA+nBe3D
        wZ0qgz96UyCfK8YWrzEOV/OOYDeO2A68c04exLVfAGLaFLHwgHYNocdRlkgdOYT22UdrwCfrKPPHE
        4h+unFshWU3Ila6ClaxPT4+n2GpfbA4mRtg7GbXNPpFiNSRYbENtTmFZ3MsU22u5nfTMMlq+SLplJ
        swtik6OyG7bgIWEWNJBTyMxKtKXmIjyKW6UjJ0Lt4Y9Q3m5xsJTd6YjqpH+bogbw35d9GIQWytVUw
        SWF/6HJEtWNNiPAAt0xWtVIwUmTcFH1pOeOvWZAksn+LRbl3/05/ZjHozdBk3xM/1xXjmfxpdGM1a
        r27bbpyA==;
Received: from [2001:8b0:10b:5:d3a1:ec0f:d323:fd4b] (helo=[IPv6:::1])
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pUDsw-00BwIR-1a;
        Mon, 20 Feb 2023 21:39:46 +0000
Date:   Mon, 20 Feb 2023 21:39:46 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Oleksandr Natalenko <oleksandr@natalenko.name>
CC:     tglx@linutronix.de, kim.phillips@amd.com,
        Usama Arif <usama.arif@bytedance.com>, arjan@linux.intel.com,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, x86@kernel.org, pbonzini@redhat.com,
        paulmck@kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, rcu@vger.kernel.org, mimoja@mimoja.de,
        hewenliang4@huawei.com, thomas.lendacky@amd.com, seanjc@google.com,
        pmenzel@molgen.mpg.de, fam.zheng@bytedance.com,
        punit.agrawal@bytedance.com, simon.evans@bytedance.com,
        liangma@liangbit.com, Piotr Gorski <lucjan.lucjanov@gmail.com>
Subject: Re: [PATCH v9 0/8] Parallel CPU bringup for x86_64
User-Agent: K-9 Mail for Android
In-Reply-To: <982e1d6140705414e8fd60b990bd259a@natalenko.name>
References: <20230215145425.420125-1-usama.arif@bytedance.com> <2668799.mvXUDI8C0e@natalenko.name> <ed8d662351cfe5793f8cc7e7e8c514d05d16c501.camel@infradead.org> <2668869.mvXUDI8C0e@natalenko.name> <2a67f6cf18dd2c1879fad9fd8a28242918d3e5d2.camel@infradead.org> <982e1d6140705414e8fd60b990bd259a@natalenko.name>
Message-ID: <715CBABF-4017-4784-8F30-5386F1524830@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 20 February 2023 21:23:38 GMT, Oleksandr Natalenko <oleksandr@natalenko=
=2Ename> wrote:
>Hello=2E
>
>On 20=2E02=2E2023 21:31, David Woodhouse wrote:
>> On Mon, 2023-02-20 at 17:40 +0100, Oleksandr Natalenko wrote:
>>> On pond=C4=9Bl=C3=AD 20=2E =C3=BAnora 2023 17:20:13 CET David Woodhous=
e wrote:
>>> > On Mon, 2023-02-20 at 17:08 +0100, Oleksandr Natalenko wrote:
>>> > >
>>> > > I've applied this to the v6=2E2 kernel, and suspend/resume broke o=
n
>>> > > my
>>> > > Ryzen 5950X desktop=2E The machine suspends just fine, but on
>>> > > resume
>>> > > the screen stays blank, and there's no visible disk I/O=2E
>>> > >
>>> > > Reverting the series brings suspend/resume back to working state=
=2E
>>> >
>>> > Hm, thanks=2E What if you add 'no_parallel_bringup' on the command
>>> > line?
>>>=20
>>> If the `no_parallel_bringup` param is added, the suspend/resume
>>> works=2E
>>=20
>> Thanks for the testing=2E Can I ask you to do one further test: apply t=
he
>> series only as far as patch 6/8 'x86/smpboot: Support parallel startup
>> of secondary CPUs'=2E
>>=20
>> That will do the new startup asm sequence where each CPU finds its own
>> per-cpu data so it *could* work in parallel, but doesn't actually do
>> the bringup in parallel yet=2E
>
>With patches 1 to 6 (including) applied and no extra cmdline params added=
 the resume doesn't work=2E

Hm=2E Kim, is there some weirdness with the way AMD CPUs get their APIC ID=
 in CPUID 0x1? Especially after resume?

Perhaps we turn it off for any AMD CPU that doesn't have X2APIC and CPUID =
0xB?

>> Does your box have a proper serial port?
>
>No, sorry=2E I know it'd help with getting logs, and I do have a serial-t=
o-USB cable that I use for another machine, but in this one the port is not=
 routed to outside=2E I think I can put a header there as the motherboard d=
oes have pins, but I'd have to buy one first=2E In theory, I can do that, b=
ut that won't happen within the next few weeks=2E
>
>P=2ES=2E Piotr Gorski (in Cc) also reported this: "My friend from CachyOS=
 can confirm bugs with smpboot patches=2E AMD FX 6300 only shows 1 core whe=
n using smp boot patchset"=2E Probably, he can reply to this thread and pro=
vide more details=2E
>
