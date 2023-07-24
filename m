Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00EC075F653
	for <lists+kvm@lfdr.de>; Mon, 24 Jul 2023 14:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbjGXM27 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 08:28:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbjGXM26 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 08:28:58 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5485510C8;
        Mon, 24 Jul 2023 05:28:52 -0700 (PDT)
Received: from loongson.cn (unknown [10.20.42.43])
        by gateway (Coremail) with SMTP id _____8BxHOuDbr5k7TQJAA--.18039S3;
        Mon, 24 Jul 2023 20:28:51 +0800 (CST)
Received: from [10.20.42.43] (unknown [10.20.42.43])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8CxF82Cbr5kry05AA--.21395S3;
        Mon, 24 Jul 2023 20:28:50 +0800 (CST)
Message-ID: <42658701-fa7d-1206-abae-5a1e01c060e3@loongson.cn>
Date:   Mon, 24 Jul 2023 20:28:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v3 4/9] PCI/VGA: Improve the default VGA device selection
Content-Language: en-US
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Sui Jingfeng <sui.jingfeng@linux.dev>
Cc:     David Airlie <airlied@gmail.com>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, kvm@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>,
        Christian Konig <christian.koenig@amd.com>,
        Pan Xinhui <Xinhui.Pan@amd.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Karol Herbst <kherbst@redhat.com>,
        Lyude Paul <lyude@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Lijo Lazar <lijo.lazar@amd.com>,
        YiPeng Chai <YiPeng.Chai@amd.com>,
        Bokun Zhang <Bokun.Zhang@amd.com>,
        Likun Gao <Likun.Gao@amd.com>,
        Ville Syrjala <ville.syrjala@linux.intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Kevin Tian <kevin.tian@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Abhishek Sahu <abhsahu@nvidia.com>,
        Yi Liu <yi.l.liu@intel.com>,
        Jani Nikula <jani.nikula@intel.com>
References: <20230719193233.GA511659@bhelgaas>
From:   suijingfeng <suijingfeng@loongson.cn>
In-Reply-To: <20230719193233.GA511659@bhelgaas>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8CxF82Cbr5kry05AA--.21395S3
X-CM-SenderInfo: xvxlyxpqjiv03j6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBj93XoW7uryxJF45try5Aw48Gw4rWFX_yoW8AFWfpr
        W8JFWFk3yxWr18GF4UXF1DCa4jyr1UJw4Utr4rJa4kCayFvrn0gF93Z34agFyUGrWxJryS
        gw1UZF47Z3yUZagCm3ZEXasCq-sJn29KB7ZKAUJUUUUd529EdanIXcx71UUUUU7KY7ZEXa
        sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
        0xBIdaVrnRJUUUPmb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
        IYs7xG6rWj6s0DM7CIcVAFz4kK6r106r15M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
        e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
        0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAF
        wI0_Gr1j6F4UJwAaw2AFwI0_Jw0_GFyle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2
        xF0cIa020Ex4CE44I27wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_
        Jw0_WrylYx0Ex4A2jsIE14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwI
        xGrwCYjI0SjxkI62AI1cAE67vIY487MxkF7I0En4kS14v26r4a6rW5MxAIw28IcxkI7VAK
        I48JMxC20s026xCaFVCjc4AY6r1j6r4UMxCIbckI1I0E14v26rWY6Fy7MI8I3I0E5I8CrV
        AFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWrXVW8Jr1l
        IxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW5JVW7JwCI42IY6xIIjxv20xvEc7CjxV
        AFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8
        JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7IUe
        IeH3UUUUU==
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,


Thanks for you noticed my change.


On 2023/7/20 03:32, Bjorn Helgaas wrote:
>> @@ -1509,13 +1543,24 @@ static int pci_notify(struct notifier_block *nb, unsigned long action,
>>   	 * cases of hotplugable vga cards.
>>   	 */
>>   
>> -	if (action == BUS_NOTIFY_ADD_DEVICE)
>> +	switch (action) {
>> +	case BUS_NOTIFY_ADD_DEVICE:
>>   		notify = vga_arbiter_add_pci_device(pdev);
>> -	else if (action == BUS_NOTIFY_DEL_DEVICE)
>> +		if (notify)
>> +			vga_arbiter_notify_clients();
>> +		break;
>> +	case BUS_NOTIFY_DEL_DEVICE:
>>   		notify = vga_arbiter_del_pci_device(pdev);
>> +		if (notify)
>> +			vga_arbiter_notify_clients();
>> +		break;
>> +	case BUS_NOTIFY_BOUND_DRIVER:
>> +		vga_arbiter_do_arbitration(pdev);
>> +		break;
>> +	default:
>> +		break;
>> +	}
> Changing from if/else to switch makes the patch bigger than necessary
> for no real benefit and obscures what is really changing.

Actually, the logic become more clear after this patch applied.

```

     switch (action) {
     case BUS_NOTIFY_ADD_DEVICE:
         notify = vga_arbiter_add_pci_device(pdev);
         if (notify)
             vga_arbiter_notify_clients();
         break;
     case BUS_NOTIFY_DEL_DEVICE:
         notify = vga_arbiter_del_pci_device(pdev);
         if (notify)
             vga_arbiter_notify_clients();
         break;
     case BUS_NOTIFY_BOUND_DRIVER:
         vga_arbiter_do_arbitration(pdev);
         break;
     default:
         break;
     }

```


Because we only need call vga_arbiter_notify_clients() when action == 
BUS_NOTIFY_ADD_DEVICE or action == BUS_NOTIFY_DEL_DEVICE,

But *NOT* when the action equals to  BUS_NOTIFY_BOUND_DRIVER.

