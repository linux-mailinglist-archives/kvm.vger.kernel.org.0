Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2C96CB854
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 09:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232322AbjC1HjC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 03:39:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231840AbjC1Hix (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 03:38:53 -0400
X-Greylist: delayed 55730 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 28 Mar 2023 00:38:37 PDT
Received: from 5.mo552.mail-out.ovh.net (5.mo552.mail-out.ovh.net [188.165.45.220])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7218D4217
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 00:38:37 -0700 (PDT)
Received: from mxplan5.mail.ovh.net (unknown [10.108.20.173])
        by mo552.mail-out.ovh.net (Postfix) with ESMTPS id 342F329B53;
        Tue, 28 Mar 2023 07:32:28 +0000 (UTC)
Received: from kaod.org (37.59.142.107) by DAG4EX2.mxp5.local (172.16.2.32)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Tue, 28 Mar
 2023 09:32:27 +0200
Authentication-Results: garm.ovh; auth=pass (GARM-107S001163ccea0-5b8c-4126-9b2b-b8042a359525,
                    5D21C2AA46E1B9891D174392918792ED1A5C90BB) smtp.auth=clg@kaod.org
X-OVh-ClientIp: 82.64.250.170
Message-ID: <82ce336b-a821-628f-ab28-3f737d354393@kaod.org>
Date:   Tue, 28 Mar 2023 09:32:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [kvm-unit-tests v3 00/13] powerpc: updates, P10, PNV support
Content-Language: en-US
To:     Nicholas Piggin <npiggin@gmail.com>, <kvm@vger.kernel.org>
CC:     <linuxppc-dev@lists.ozlabs.org>,
        Laurent Vivier <lvivier@redhat.com>,
        Thomas Huth <thuth@redhat.com>
References: <20230327124520.2707537-1-npiggin@gmail.com>
 <bdc241df-d9b8-a742-982b-21a5b4feb2a4@kaod.org>
 <CRHTY0VSZ8LW.18YSL5NHOOO2A@bobo>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
In-Reply-To: <CRHTY0VSZ8LW.18YSL5NHOOO2A@bobo>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [37.59.142.107]
X-ClientProxiedBy: DAG9EX2.mxp5.local (172.16.2.82) To DAG4EX2.mxp5.local
 (172.16.2.32)
X-Ovh-Tracer-GUID: 2f218ef9-5add-4654-ab8e-382ab8ad3bdd
X-Ovh-Tracer-Id: 10955850519545940899
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvhedrvdehfedguddvgecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefkffggfgfuvfevfhfhjggtgfhisehtkeertddtfeejnecuhfhrohhmpeevrogurhhitgcunfgvucfiohgrthgvrhcuoegtlhhgsehkrghougdrohhrgheqnecuggftrfgrthhtvghrnhepffdufeeliedujeeffffhjeffiefghffhhfdvkeeijeehledvueffhfejtdehgeegnecukfhppeduvdejrddtrddtrddupdefjedrheelrddugedvrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehinhgvthepuddvjedrtddrtddruddpmhgrihhlfhhrohhmpeeotghlgheskhgrohgurdhorhhgqedpnhgspghrtghpthhtohepuddprhgtphhtthhopehnphhighhgihhnsehgmhgrihhlrdgtohhmpdhkvhhmsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhlihhnuhigphhptgdquggvvheslhhishhtshdrohiilhgrsghsrdhorhhgpdhlvhhivhhivghrsehrvgguhhgrthdrtghomhdpthhhuhhthhesrhgvughhrghtrdgtohhmpdfovfetjfhoshhtpehmohehhedvpdhmohguvgepshhmthhpohhuth
X-Spam-Status: No, score=-0.0 required=5.0 tests=NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/28/23 09:15, Nicholas Piggin wrote:
> On Tue Mar 28, 2023 at 2:09 AM AEST, Cédric Le Goater wrote:
>> On 3/27/23 14:45, Nicholas Piggin wrote:
>>> This series is growing a bit I'm sorry. v2 series added extra interrupt
>>> vectors support which was actually wrong because interrupt handling
>>> code can only cope with 0x100-size vectors and new ones are 0x80 and
>>> 0x20. It managed to work because those alias to the 0x100 boundary, but
>>> if more than one handler were installed in the same 0x100-aligned
>>> block it would crash. So a couple of patches added to cope with that.
>>>
>>
>> I gave them a try on P9 box
> 
> Thanks!
> 
>>
>> $ ./run_tests.sh
>> PASS selftest-setup (2 tests)
>> PASS spapr_hcall (9 tests, 1 skipped)
>> PASS spapr_vpa (13 tests)
>> PASS rtas-get-time-of-day (10 tests)
>> PASS rtas-get-time-of-day-base (10 tests)
>> PASS rtas-set-time-of-day (5 tests)
>> PASS emulator (4 tests)
>> PASS h_cede_tm (2 tests)
>> FAIL sprs (75 tests, 1 unexpected failures)
> 
> Oh you have a SPR failure too? I'll check that on a 

I think it was the WORT SPR

> 
>> FAIL sprs-migration (75 tests, 5 unexpected failures)
>>
>> And with TCG:
>>
>> $ ACCEL=tcg ./run_tests.sh
>> PASS selftest-setup (2 tests)
>> PASS spapr_hcall (9 tests, 1 skipped)
>> FAIL spapr_vpa (13 tests, 1 unexpected failures)
>>
>> The dispatch count seems bogus after unregister
> 
> Yeah, that dispatch count after unregister test may be bogus actually.
> PAPR doesn't specify what should happen in that case. It was working
> here for me though so interesting it's different for you. I'll
> investigate it and maybe just remove that test for now.

It would be nice to keep it and skip it until the emulation is fixed.
  
> 
>>
>> PASS rtas-get-time-of-day (10 tests)
>> PASS rtas-get-time-of-day-base (10 tests)
>> PASS rtas-set-time-of-day (5 tests)
>> PASS emulator (4 tests)
>> SKIP h_cede_tm (qemu-system-ppc64: TCG cannot support more than 1 thread/core on a pseries machine)
>> FAIL sprs (75 tests, 16 unexpected failures)
> 
> These should be TCG errors. I have it passing them all with patches
> posted to qemu lists. Very simple but effective way to catch a few
> classes of errors.

Ah  I didn't try with your QEMU patches. Make sense then.

Thanks,

C.

