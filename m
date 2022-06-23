Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B931A557F19
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 17:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231656AbiFWP5y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 11:57:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230372AbiFWP5x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 11:57:53 -0400
X-Greylist: delayed 2870 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 23 Jun 2022 08:57:51 PDT
Received: from 6.mo552.mail-out.ovh.net (6.mo552.mail-out.ovh.net [188.165.49.222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C12A72E9CA
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 08:57:51 -0700 (PDT)
Received: from mxplan5.mail.ovh.net (unknown [10.108.16.163])
        by mo552.mail-out.ovh.net (Postfix) with ESMTPS id 7A40227577;
        Thu, 23 Jun 2022 15:39:28 +0000 (UTC)
Received: from kaod.org (37.59.142.99) by DAG4EX1.mxp5.local (172.16.2.31)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.9; Thu, 23 Jun
 2022 17:39:27 +0200
Authentication-Results: garm.ovh; auth=pass (GARM-99G0031f79f41d-64ae-44e7-bed5-542ac9071772,
                    1905447EDF4A6B95D61F03ED56167C5A36471571) smtp.auth=clg@kaod.org
X-OVh-ClientIp: 82.64.250.170
Message-ID: <6b7975b5-754b-c2d8-a46f-93a6f1827c66@kaod.org>
Date:   Thu, 23 Jun 2022 17:39:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 08/14] aspeed: Replace direct get_system_memory() calls
Content-Language: en-US
To:     Peter Maydell <peter.maydell@linaro.org>,
        Peter Delevoryas <pdel@fb.com>
CC:     <andrew@aj.id.au>, <joel@jms.id.au>, <pbonzini@redhat.com>,
        <berrange@redhat.com>, <eduardo@habkost.net>,
        <marcel.apfelbaum@gmail.com>, <richard.henderson@linaro.org>,
        <f4bug@amsat.org>, <ani@anisinha.ca>, <qemu-devel@nongnu.org>,
        <qemu-arm@nongnu.org>, <kvm@vger.kernel.org>
References: <20220623102617.2164175-1-pdel@fb.com>
 <20220623102617.2164175-9-pdel@fb.com>
 <CAFEAcA9GAr=Rv9GMsnUux3_PNk1gRPBOcSyPzD9MRP5UzOZO1Q@mail.gmail.com>
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
In-Reply-To: <CAFEAcA9GAr=Rv9GMsnUux3_PNk1gRPBOcSyPzD9MRP5UzOZO1Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [37.59.142.99]
X-ClientProxiedBy: DAG4EX1.mxp5.local (172.16.2.31) To DAG4EX1.mxp5.local
 (172.16.2.31)
X-Ovh-Tracer-GUID: dfb66119-dc4c-46c5-add0-9c9f6baed10d
X-Ovh-Tracer-Id: 9885401182681860926
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvfedrudefjedgleefucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepkfffgggfuffvvehfhfgjtgfgihesthejredttdefjeenucfhrhhomhepveorughrihgtpgfnvggpifhorghtvghruceotghlgheskhgrohgurdhorhhgqeenucggtffrrghtthgvrhhnpeelleeiiefgkeefiedtvdeigeetueetkeffkeelheeugfetteegvdekgfehgffgkeenucfkpheptddrtddrtddrtddpfeejrdehledrudegvddrleelnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhpohhuthdphhgvlhhopehmgihplhgrnhehrdhmrghilhdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomheptghlgheskhgrohgurdhorhhgpdhnsggprhgtphhtthhopedupdhrtghpthhtohepkhhvmhesvhhgvghrrdhkvghrnhgvlhdrohhrghdpoffvtefjohhsthepmhhoheehvd
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/23/22 14:57, Peter Maydell wrote:
> On Thu, 23 Jun 2022 at 13:37, Peter Delevoryas <pdel@fb.com> wrote:
>>
>> Note: sysbus_mmio_map(), sysbus_mmio_map_overlap(), and others are still
>> using get_system_memory indirectly.
>>
>> Signed-off-by: Peter Delevoryas <pdel@fb.com>
>> ---
>>   hw/arm/aspeed.c         | 8 ++++----
>>   hw/arm/aspeed_ast10x0.c | 5 ++---
>>   hw/arm/aspeed_ast2600.c | 2 +-
>>   hw/arm/aspeed_soc.c     | 6 +++---
>>   4 files changed, 10 insertions(+), 11 deletions(-)
>>
>> diff --git a/hw/arm/aspeed.c b/hw/arm/aspeed.c
>> index 8dae155183..3aa74e88fb 100644
>> --- a/hw/arm/aspeed.c
>> +++ b/hw/arm/aspeed.c
>> @@ -371,7 +371,7 @@ static void aspeed_machine_init(MachineState *machine)
>>                            amc->uart_default);
>>       qdev_realize(DEVICE(&bmc->soc), NULL, &error_abort);
>>
>> -    memory_region_add_subregion(get_system_memory(),
>> +    memory_region_add_subregion(bmc->soc.system_memory,
>>                                   sc->memmap[ASPEED_DEV_SDRAM],
>>                                   &bmc->ram_container);
> 
> This is board code, it shouldn't be reaching into the internals
> of the SoC object like this. The board code probably already
> has the right MemoryRegion because it was the one that passed
> it to the SoC link porperty in the first place.

It's a bit messy currently. May be I got it wrong initially. The
board allocates a ram container region in which the machine ram
region is mapped. See commit ad1a9782186d ("aspeed: add a RAM memory
region container")

There is an extra region after ram in the ram container to catch
invalid access done by FW. That's how FW determines the size of
ram. See commit ebe31c0a8ef7 ("aspeed: add a max_ram_size property
to the memory controller")

But I think I can safely move all the RAM logic under the board.
I will send a patch.

Thanks,

C.

> 
> thanks
> -- PMM

