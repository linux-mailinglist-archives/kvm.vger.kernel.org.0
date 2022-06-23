Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF6B5587A2
	for <lists+kvm@lfdr.de>; Thu, 23 Jun 2022 20:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234919AbiFWSfl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jun 2022 14:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbiFWSfW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jun 2022 14:35:22 -0400
X-Greylist: delayed 4203 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 23 Jun 2022 10:36:24 PDT
Received: from 2.mo548.mail-out.ovh.net (2.mo548.mail-out.ovh.net [178.33.255.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A59C1517D8
        for <kvm@vger.kernel.org>; Thu, 23 Jun 2022 10:36:21 -0700 (PDT)
Received: from mxplan5.mail.ovh.net (unknown [10.109.146.131])
        by mo548.mail-out.ovh.net (Postfix) with ESMTPS id C76B0231E2;
        Thu, 23 Jun 2022 15:09:57 +0000 (UTC)
Received: from kaod.org (37.59.142.99) by DAG4EX1.mxp5.local (172.16.2.31)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.9; Thu, 23 Jun
 2022 17:09:56 +0200
Authentication-Results: garm.ovh; auth=pass (GARM-99G00387f07116-a976-436d-9488-f78a9ccc6e13,
                    1905447EDF4A6B95D61F03ED56167C5A36471571) smtp.auth=clg@kaod.org
X-OVh-ClientIp: 82.64.250.170
Message-ID: <e5f51f14-fe75-0d55-6588-a3ca2565f760@kaod.org>
Date:   Thu, 23 Jun 2022 17:09:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
From:   =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
Subject: Re: [PATCH 12/14] aspeed: Make aspeed_board_init_flashes public
To:     Peter Delevoryas <pdel@fb.com>
CC:     <peter.maydell@linaro.org>, <andrew@aj.id.au>, <joel@jms.id.au>,
        <pbonzini@redhat.com>, <berrange@redhat.com>,
        <eduardo@habkost.net>, <"i.mitsyanko@gmail.com.mst"@redhat.com>,
        <marcel.apfelbaum@gmail.com>, <richard.henderson@linaro.org>,
        <f4bug@amsat.org>, <ani@anisinha.ca>, <qemu-devel@nongnu.org>,
        <qemu-arm@nongnu.org>, <kvm@vger.kernel.org>
References: <20220623102617.2164175-1-pdel@fb.com>
 <20220623102617.2164175-13-pdel@fb.com>
Content-Language: en-US
In-Reply-To: <20220623102617.2164175-13-pdel@fb.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [37.59.142.99]
X-ClientProxiedBy: DAG4EX2.mxp5.local (172.16.2.32) To DAG4EX1.mxp5.local
 (172.16.2.31)
X-Ovh-Tracer-GUID: 2dbb2037-39f1-45b4-b5ec-fe71b9aca839
X-Ovh-Tracer-Id: 9386908999118261121
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvfedrudefjedgkeeiucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepkfffgggfhffuvfevfhgjtgfgihesthejredttdefjeenucfhrhhomhepveorughrihgtpgfnvggpifhorghtvghruceotghlgheskhgrohgurdhorhhgqeenucggtffrrghtthgvrhhnpeeghfeuudfftdduleetkeegffdtiefgkeejgeektdeggeegueelhfefieehjeevkeenucfkpheptddrtddrtddrtddpfeejrdehledrudegvddrleelnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhpohhuthdphhgvlhhopehmgihplhgrnhehrdhmrghilhdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomheptghlgheskhgrohgurdhorhhgpdhnsggprhgtphhtthhopedupdhrtghpthhtohepkhhvmhesvhhgvghrrdhkvghrnhgvlhdrohhrghdpoffvtefjohhsthepmhhoheegke
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/23/22 12:26, Peter Delevoryas wrote:
> Signed-off-by: Peter Delevoryas <pdel@fb.com>

Let's start simple without flash support. We should be able to
load FW blobs in each CPU address space using loader devices.

Thanks,

C.

> ---
>   hw/arm/aspeed.c             | 25 -------------------------
>   hw/arm/aspeed_soc.c         | 26 ++++++++++++++++++++++++++
>   include/hw/arm/aspeed_soc.h |  2 ++
>   3 files changed, 28 insertions(+), 25 deletions(-)
> 
> diff --git a/hw/arm/aspeed.c b/hw/arm/aspeed.c
> index 3aa74e88fb..c893ce84d7 100644
> --- a/hw/arm/aspeed.c
> +++ b/hw/arm/aspeed.c
> @@ -278,31 +278,6 @@ static void write_boot_rom(DriveInfo *dinfo, hwaddr addr, size_t rom_size,
>       rom_add_blob_fixed("aspeed.boot_rom", storage, rom_size, addr);
>   }
>   
> -static void aspeed_board_init_flashes(AspeedSMCState *s, const char *flashtype,
> -                                      unsigned int count, int unit0)
> -{
> -    int i;
> -
> -    if (!flashtype) {
> -        return;
> -    }
> -
> -    for (i = 0; i < count; ++i) {
> -        DriveInfo *dinfo = drive_get(IF_MTD, 0, unit0 + i);
> -        qemu_irq cs_line;
> -        DeviceState *dev;
> -
> -        dev = qdev_new(flashtype);
> -        if (dinfo) {
> -            qdev_prop_set_drive(dev, "drive", blk_by_legacy_dinfo(dinfo));
> -        }
> -        qdev_realize_and_unref(dev, BUS(s->spi), &error_fatal);
> -
> -        cs_line = qdev_get_gpio_in_named(dev, SSI_GPIO_CS, 0);
> -        sysbus_connect_irq(SYS_BUS_DEVICE(s), i + 1, cs_line);
> -    }
> -}
> -
>   static void sdhci_attach_drive(SDHCIState *sdhci, DriveInfo *dinfo)
>   {
>           DeviceState *card;
> diff --git a/hw/arm/aspeed_soc.c b/hw/arm/aspeed_soc.c
> index b7e8506f28..33bfc06ed8 100644
> --- a/hw/arm/aspeed_soc.c
> +++ b/hw/arm/aspeed_soc.c
> @@ -20,6 +20,7 @@
>   #include "hw/i2c/aspeed_i2c.h"
>   #include "net/net.h"
>   #include "sysemu/sysemu.h"
> +#include "sysemu/blockdev.h"
>   
>   #define ASPEED_SOC_IOMEM_SIZE       0x00200000
>   
> @@ -579,3 +580,28 @@ void aspeed_soc_uart_init(AspeedSoCState *s)
>                          serial_hd(i), DEVICE_LITTLE_ENDIAN);
>       }
>   }
> +
> +void aspeed_board_init_flashes(AspeedSMCState *s, const char *flashtype,
> +                               unsigned int count, int unit0)
> +{
> +    int i;
> +
> +    if (!flashtype) {
> +        return;
> +    }
> +
> +    for (i = 0; i < count; ++i) {
> +        DriveInfo *dinfo = drive_get(IF_MTD, 0, unit0 + i);
> +        qemu_irq cs_line;
> +        DeviceState *dev;
> +
> +        dev = qdev_new(flashtype);
> +        if (dinfo) {
> +            qdev_prop_set_drive(dev, "drive", blk_by_legacy_dinfo(dinfo));
> +        }
> +        qdev_realize_and_unref(dev, BUS(s->spi), &error_fatal);
> +
> +        cs_line = qdev_get_gpio_in_named(dev, SSI_GPIO_CS, 0);
> +        sysbus_connect_irq(SYS_BUS_DEVICE(s), i + 1, cs_line);
> +    }
> +}
> diff --git a/include/hw/arm/aspeed_soc.h b/include/hw/arm/aspeed_soc.h
> index c68395ddbb..270d85d5de 100644
> --- a/include/hw/arm/aspeed_soc.h
> +++ b/include/hw/arm/aspeed_soc.h
> @@ -166,5 +166,7 @@ enum {
>   
>   qemu_irq aspeed_soc_get_irq(AspeedSoCState *s, int dev);
>   void aspeed_soc_uart_init(AspeedSoCState *s);
> +void aspeed_board_init_flashes(AspeedSMCState *s, const char *flashtype,
> +                               unsigned int count, int unit0);
>   
>   #endif /* ASPEED_SOC_H */

