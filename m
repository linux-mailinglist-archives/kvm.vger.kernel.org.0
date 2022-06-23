Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34528557EDD
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 17:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231796AbiFWPsb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 11:48:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiFWPsa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 11:48:30 -0400
X-Greylist: delayed 1825 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 23 Jun 2022 08:48:28 PDT
Received: from smtpout2.mo529.mail-out.ovh.net (smtpout2.mo529.mail-out.ovh.net [79.137.123.220])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D91FC31357
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 08:48:27 -0700 (PDT)
Received: from mxplan5.mail.ovh.net (unknown [10.108.20.191])
        by mo529.mail-out.ovh.net (Postfix) with ESMTPS id 4DE1611059C02;
        Thu, 23 Jun 2022 17:09:46 +0200 (CEST)
Received: from kaod.org (37.59.142.104) by DAG4EX1.mxp5.local (172.16.2.31)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.9; Thu, 23 Jun
 2022 17:09:45 +0200
Authentication-Results: garm.ovh; auth=pass (GARM-104R0059f4c54c9-d024-45c3-8745-8ed4cc28c296,
                    1905447EDF4A6B95D61F03ED56167C5A36471571) smtp.auth=clg@kaod.org
X-OVh-ClientIp: 82.64.250.170
Message-ID: <faba2fe7-0296-2e76-9f20-e41e159f359d@kaod.org>
Date:   Thu, 23 Jun 2022 17:09:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
Subject: Re: [PATCH 01/14] sysbus: Remove sysbus_mmio_unmap
To:     Peter Delevoryas <pdel@fb.com>
CC:     <peter.maydell@linaro.org>, <andrew@aj.id.au>, <joel@jms.id.au>,
        <pbonzini@redhat.com>, <berrange@redhat.com>,
        <eduardo@habkost.net>, <"i.mitsyanko@gmail.com.mst"@redhat.com>,
        <marcel.apfelbaum@gmail.com>, <richard.henderson@linaro.org>,
        <f4bug@amsat.org>, <ani@anisinha.ca>, <qemu-devel@nongnu.org>,
        <qemu-arm@nongnu.org>, <kvm@vger.kernel.org>
References: <20220623095825.2038562-1-pdel@fb.com>
 <20220623095825.2038562-2-pdel@fb.com>
Content-Language: en-US
In-Reply-To: <20220623095825.2038562-2-pdel@fb.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [37.59.142.104]
X-ClientProxiedBy: DAG2EX1.mxp5.local (172.16.2.11) To DAG4EX1.mxp5.local
 (172.16.2.31)
X-Ovh-Tracer-GUID: 808c79e5-f4c2-4436-ac52-07d2351cc492
X-Ovh-Tracer-Id: 9383812776294583169
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvfedrudefjedgkeeiucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepkfffgggfhffuvfevfhgjtgfgihesthekredttdefjeenucfhrhhomhepveorughrihgtpgfnvggpifhorghtvghruceotghlgheskhgrohgurdhorhhgqeenucggtffrrghtthgvrhhnpedvhffhvdehgfelvddtjeeuleevfeettdejgeetuedtveettedufeefueefvdetgfenucfkpheptddrtddrtddrtddpfeejrdehledrudegvddruddtgeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphhouhhtpdhhvghlohepmhigphhlrghnhedrmhgrihhlrdhovhhhrdhnvghtpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpegtlhhgsehkrghougdrohhrghdpnhgspghrtghpthhtohepuddprhgtphhtthhopehkvhhmsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdfovfetjfhoshhtpehmohehvdel
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/23/22 11:58, Peter Delevoryas wrote:
> Cedric removed usage of this function in a previous commit.
> 
> Fixes: 981b1c6266c6 ("spapr/xive: rework the mapping the KVM memory regions")
> Signed-off-by: Peter Delevoryas <pdel@fb.com>

Reviewed-by: Cédric Le Goater <clg@kaod.org>

Thanks,

C.

> ---
>   hw/core/sysbus.c    | 10 ----------
>   include/hw/sysbus.h |  1 -
>   2 files changed, 11 deletions(-)
> 
> diff --git a/hw/core/sysbus.c b/hw/core/sysbus.c
> index 05c1da3d31..637e18f247 100644
> --- a/hw/core/sysbus.c
> +++ b/hw/core/sysbus.c
> @@ -154,16 +154,6 @@ static void sysbus_mmio_map_common(SysBusDevice *dev, int n, hwaddr addr,
>       }
>   }
>   
> -void sysbus_mmio_unmap(SysBusDevice *dev, int n)
> -{
> -    assert(n >= 0 && n < dev->num_mmio);
> -
> -    if (dev->mmio[n].addr != (hwaddr)-1) {
> -        memory_region_del_subregion(get_system_memory(), dev->mmio[n].memory);
> -        dev->mmio[n].addr = (hwaddr)-1;
> -    }
> -}
> -
>   void sysbus_mmio_map(SysBusDevice *dev, int n, hwaddr addr)
>   {
>       sysbus_mmio_map_common(dev, n, addr, false, 0);
> diff --git a/include/hw/sysbus.h b/include/hw/sysbus.h
> index 3564b7b6a2..153ef20695 100644
> --- a/include/hw/sysbus.h
> +++ b/include/hw/sysbus.h
> @@ -82,7 +82,6 @@ qemu_irq sysbus_get_connected_irq(SysBusDevice *dev, int n);
>   void sysbus_mmio_map(SysBusDevice *dev, int n, hwaddr addr);
>   void sysbus_mmio_map_overlap(SysBusDevice *dev, int n, hwaddr addr,
>                                int priority);
> -void sysbus_mmio_unmap(SysBusDevice *dev, int n);
>   void sysbus_add_io(SysBusDevice *dev, hwaddr addr,
>                      MemoryRegion *mem);
>   MemoryRegion *sysbus_address_space(SysBusDevice *dev);

