Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36CBA6CAA8A
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 18:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232276AbjC0Q1W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 12:27:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbjC0Q1U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 12:27:20 -0400
Received: from 1.mo552.mail-out.ovh.net (1.mo552.mail-out.ovh.net [178.32.96.117])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79FDCFB
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 09:27:19 -0700 (PDT)
Received: from mxplan5.mail.ovh.net (unknown [10.108.4.144])
        by mo552.mail-out.ovh.net (Postfix) with ESMTPS id EA0DC2A4BD;
        Mon, 27 Mar 2023 16:09:45 +0000 (UTC)
Received: from kaod.org (37.59.142.107) by DAG4EX2.mxp5.local (172.16.2.32)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Mon, 27 Mar
 2023 18:09:45 +0200
Authentication-Results: garm.ovh; auth=pass (GARM-107S0016611bc0e-10e9-4c4c-8b6a-1ed7abc98a3d,
                    A6C3435B678E6C193C864925704A598F32E2E8B9) smtp.auth=clg@kaod.org
X-OVh-ClientIp: 82.64.250.170
Message-ID: <bdc241df-d9b8-a742-982b-21a5b4feb2a4@kaod.org>
Date:   Mon, 27 Mar 2023 18:09:44 +0200
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
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
In-Reply-To: <20230327124520.2707537-1-npiggin@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [37.59.142.107]
X-ClientProxiedBy: DAG9EX2.mxp5.local (172.16.2.82) To DAG4EX2.mxp5.local
 (172.16.2.32)
X-Ovh-Tracer-GUID: 571f510b-fa8b-44e5-8060-037cb272a2a4
X-Ovh-Tracer-Id: 13819576934494407587
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvhedrvdehvddgleekucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepkfffgggfuffvvehfhfgjtgfgihesthejredttdefjeenucfhrhhomhepveorughrihgtucfnvgcuifhorghtvghruceotghlgheskhgrohgurdhorhhgqeenucggtffrrghtthgvrhhnpeeuuddtteelgeejhfeikeegffekhfelvefgfeejveffjeeiveegfeehgfdtgfeitdenucfkphepuddvjedrtddrtddruddpfeejrdehledrudegvddruddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepihhnvghtpeduvdejrddtrddtrddupdhmrghilhhfrhhomhepoegtlhhgsehkrghougdrohhrgheqpdhnsggprhgtphhtthhopedupdhrtghpthhtohepnhhpihhgghhinhesghhmrghilhdrtghomhdpkhhvmhesvhhgvghrrdhkvghrnhgvlhdrohhrghdplhhinhhugihpphgtqdguvghvsehlihhsthhsrdhoiihlrggsshdrohhrghdplhhvihhvihgvrhesrhgvughhrghtrdgtohhmpdhthhhuthhhsehrvgguhhgrthdrtghomhdpoffvtefjohhsthepmhhoheehvddpmhhouggvpehsmhhtphhouhht
X-Spam-Status: No, score=-0.0 required=5.0 tests=NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/27/23 14:45, Nicholas Piggin wrote:
> This series is growing a bit I'm sorry. v2 series added extra interrupt
> vectors support which was actually wrong because interrupt handling
> code can only cope with 0x100-size vectors and new ones are 0x80 and
> 0x20. It managed to work because those alias to the 0x100 boundary, but
> if more than one handler were installed in the same 0x100-aligned
> block it would crash. So a couple of patches added to cope with that.
> 

I gave them a try on P9 box

$ ./run_tests.sh
PASS selftest-setup (2 tests)
PASS spapr_hcall (9 tests, 1 skipped)
PASS spapr_vpa (13 tests)
PASS rtas-get-time-of-day (10 tests)
PASS rtas-get-time-of-day-base (10 tests)
PASS rtas-set-time-of-day (5 tests)
PASS emulator (4 tests)
PASS h_cede_tm (2 tests)
FAIL sprs (75 tests, 1 unexpected failures)
FAIL sprs-migration (75 tests, 5 unexpected failures)

And with TCG:

$ ACCEL=tcg ./run_tests.sh
PASS selftest-setup (2 tests)
PASS spapr_hcall (9 tests, 1 skipped)
FAIL spapr_vpa (13 tests, 1 unexpected failures)

The dispatch count seems bogus after unregister

PASS rtas-get-time-of-day (10 tests)
PASS rtas-get-time-of-day-base (10 tests)
PASS rtas-set-time-of-day (5 tests)
PASS emulator (4 tests)
SKIP h_cede_tm (qemu-system-ppc64: TCG cannot support more than 1 thread/core on a pseries machine)
FAIL sprs (75 tests, 16 unexpected failures)
FAIL sprs-migration (75 tests, 16 unexpected failures)


Thanks,

C.
