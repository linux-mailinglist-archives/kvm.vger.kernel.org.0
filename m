Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4C93686CC6
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 18:22:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232171AbjBARWS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 12:22:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231954AbjBARWJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 12:22:09 -0500
X-Greylist: delayed 1468 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 01 Feb 2023 09:21:59 PST
Received: from mail.zytor.com (unknown [IPv6:2607:7c80:54:3::138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F34E07CCB5;
        Wed,  1 Feb 2023 09:21:58 -0800 (PST)
Received: from [127.0.0.1] ([73.223.250.219])
        (authenticated bits=0)
        by mail.zytor.com (8.17.1/8.17.1) with ESMTPSA id 311Gtuar1673390
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Wed, 1 Feb 2023 08:55:56 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 311Gtuar1673390
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2023010601; t=1675270559;
        bh=23tO0MCEb93yUsul7CzC6ijVlvw5VHsg7S3VpOfZS/E=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=J+mss7dWrmbS+5PqF5sLKyQkQr4F4iUXYXJlb622rI+ZWHkGpEJthi77dwzZoVAhw
         lFiCVdBim71PfFYNkjsGMM9JIKlEkpeRSw1W2aGAi21zSrCYNYOUqaCxOvfWamwD0e
         /AnXFlOQSrp3evTL8+ZIlQLW+4sWD+8hebmzA8XeNedFnIsL3T+PcB3OLNDOURDRwh
         nsIBw8niaiy7MqU9pMgdoJsPFMhasOFFL0wBrmgv0OammDrq5HSCAwpIZ9f5P6gji7
         EkmXAC0z2wEcmvwJM4HzDJKEPHQNyS0wb0u7P82yGzGokaUJkVqT+ZX854mbndeNiv
         0NOWiu7XlU7Yw==
Date:   Wed, 01 Feb 2023 08:55:53 -0800
From:   "H. Peter Anvin" <hpa@zytor.com>
To:     Usama Arif <usama.arif@bytedance.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
CC:     Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        hushiyuan@huawei.com, luolongjun@huawei.com, hejingxian@huawei.com,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Fam Zheng <fam.zheng@bytedance.com>,
        Punit Agrawal <punit.agrawal@bytedance.com>,
        simon.evans@bytedance.com, liangma@liangbit.com
Subject: Re: [External] Re: [PATCH v4 0/9] Parallel CPU bringup for x86_64
User-Agent: K-9 Mail for Android
In-Reply-To: <7fda05c9-9d4a-6005-0ce5-91bda1bb06c1@bytedance.com>
References: <20220201205328.123066-1-dwmw2@infradead.org> <ff876008-b642-4dbc-aa41-1639905e08b6@bytedance.com> <1d0ed92ab68409b62a14cd29d0021f92c6e2568a.camel@infradead.org> <7fda05c9-9d4a-6005-0ce5-91bda1bb06c1@bytedance.com>
Message-ID: <4C7F2481-0B0B-4399-A8E1-30731EFD02D2@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On February 1, 2023 8:38:14 AM PST, Usama Arif <usama=2Earif@bytedance=2Eco=
m> wrote:
>
>
>On 01/02/2023 15:08, David Woodhouse wrote:
>> On Wed, 2023-02-01 at 14:40 +0000, Usama Arif wrote:
>>> On 01/02/2022 20:53, David Woodhouse wrote:
>>>> Doing the INIT/SIPI/SIPI in parallel for all APs and *then* waiting f=
or
>>>> them shaves about 80% off the AP bringup time on a 96-thread 2-socket
>>>> Skylake box (EC2 c5=2Emetal) =E2=80=94 from about 500ms to 100ms=2E
>>>>=20
>>>> There are more wins to be had with further parallelisation, but this =
is
>>>> the simple part=2E
>>>>=20
>>>=20
>>> Hi,
>>>=20
>>> We are interested in reducing the boot time of servers (with kexec), a=
nd
>>> smpboot takes up a significant amount of time while booting=2E When
>>> testing the patch series (rebased to v6=2E1) on a server with 128 CPUs
>>> split across 2 NUMA nodes, it brought down the smpboot time from ~700m=
s
>>> to 100ms=2E Adding another cpuhp state for do_wait_cpu_initialized to =
make
>>> sure cpu_init is reached (as done in v1 of the series + using the
>>> cpu_finishup_mask) brought it down further to ~30ms=2E
>>>=20
>>> I just wanted to check what was needed to progress the patch series
>>> further for review? There weren't any comments on v4 of the patch so I
>>> couldn't figure out what more is needed=2E I think its quite useful to
>>> have this working so would be really glad help in anything needed to
>>> restart the review=2E
>>=20
>>=20
>> I believe the only thing holding it back was the fact that it broke on
>> some AMD CPUs=2E
>>=20
>> We don't *think* there are any remaining software issues; we think it's
>> hardware=2E Either an actual hardware race in CPU or chipset, or perhap=
s
>> even something as simple as a voltage regulator which can't cope with
>> an increase in power draw from *all* the CPUs at the same time=2E
>>=20
>> We have prodded AMD a few times to investigate, but so far to no avail=
=2E
>>=20
>> Last time I actually spoke to Thomas in person, I think he agreed that
>> we should just merge it and disable the parallel mode for the affected
>> AMD CPUs=2E
>>=20
>
>From the comments in v3, it seems to affect multiple generations, would i=
t be worth proceeding with the patches by disabling it on all AMD CPUs to b=
e on the safe side, until the actual issue is found and what causes it, and=
 then follow up later if the issue is found by disabling it only on affecte=
d cpus=2E Maybe simply do something like below?
>
>diff --git a/arch/x86/kernel/smpboot=2Ec b/arch/x86/kernel/smpboot=2Ec
>index 0f144773a7fc=2E=2E6b8884592341 100644
>--- a/arch/x86/kernel/smpboot=2Ec
>+++ b/arch/x86/kernel/smpboot=2Ec
>@@ -1575,7 +1575,8 @@ void __init native_smp_prepare_cpus(unsigned int ma=
x_cpus)
>         * for SEV-ES guests because they can't use CPUID that early=2E
>         */
>        if (IS_ENABLED(CONFIG_X86_32) || boot_cpu_data=2Ecpuid_level < 0x=
0B ||
>-           cc_platform_has(CC_ATTR_GUEST_STATE_ENCRYPT))
>+           cc_platform_has(CC_ATTR_GUEST_STATE_ENCRYPT) ||
>+           boot_cpu_data=2Ex86_vendor =3D=3D X86_VENDOR_AMD)
>                do_parallel_bringup =3D false;
>
>        if (do_parallel_bringup) {
>
>
>
>
>> If you've already rebased to a newer kernel and tested it, perhaps now
>> is the time to do just that=2E
>
>If you would like me to repost the rebased patches to restart the reviews=
 (with do_parallel_bringup disabled for AMD), please let me know!
>
>Thanks,
>Usama

This should be a CPU bug flag in my option=2E
