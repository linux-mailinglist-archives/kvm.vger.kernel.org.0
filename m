Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5DE736211
	for <lists+kvm@lfdr.de>; Tue, 20 Jun 2023 05:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbjFTDNx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 23:13:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbjFTDNv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 23:13:51 -0400
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 92AFB1B0;
        Mon, 19 Jun 2023 20:13:48 -0700 (PDT)
Received: from loongson.cn (unknown [10.20.42.43])
        by gateway (Coremail) with SMTP id _____8DxDetqGZFkrwcHAA--.14552S3;
        Tue, 20 Jun 2023 11:13:46 +0800 (CST)
Received: from [10.20.42.43] (unknown [10.20.42.43])
        by localhost.localdomain (Coremail) with SMTP id AQAAf8DxbMpnGZFkax4hAA--.18888S3;
        Tue, 20 Jun 2023 11:13:43 +0800 (CST)
Message-ID: <5c3b5f2e-00c6-efba-1239-cdf96285d6a2@loongson.cn>
Date:   Tue, 20 Jun 2023 11:13:43 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v6 2/8] PCI/VGA: Deal only with VGA class devices
Content-Language: en-US
To:     "Limonciello, Mario" <mario.limonciello@amd.com>,
        Sui Jingfeng <15330273260@189.cn>,
        Alex Deucher <alexander.deucher@amd.com>,
        Christian Konig <christian.koenig@amd.com>,
        Pan Xinhui <Xinhui.Pan@amd.com>,
        David Airlie <airlied@gmail.com>,
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
        Lijo Lazar <lijo.lazar@amd.com>,
        YiPeng Chai <YiPeng.Chai@amd.com>,
        Andrey Grodzovsky <andrey.grodzovsky@amd.com>,
        Somalapuram Amaranath <Amaranath.Somalapuram@amd.com>,
        Bokun Zhang <Bokun.Zhang@amd.com>,
        Ville Syrjala <ville.syrjala@linux.intel.com>,
        Li Yi <liyi@loongson.cn>, Jason Gunthorpe <jgg@ziepe.ca>,
        Kevin Tian <kevin.tian@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Abhishek Sahu <abhsahu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Cc:     amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        nouveau@lists.freedesktop.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, loongson-kernel@lists.loongnix.cn
References: <20230612192550.197053-1-15330273260@189.cn>
 <20230612192550.197053-3-15330273260@189.cn>
 <5b6fdf65-b354-94a9-f883-be820157efad@amd.com>
From:   Sui Jingfeng <suijingfeng@loongson.cn>
Organization: Loongson
In-Reply-To: <5b6fdf65-b354-94a9-f883-be820157efad@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: AQAAf8DxbMpnGZFkax4hAA--.18888S3
X-CM-SenderInfo: xvxlyxpqjiv03j6o00pqjv00gofq/
X-Coremail-Antispam: 1Uk129KBj93XoWxGF4UCF4xWFy8AFW5CF1Dtwc_yoW5KrWDpF
        ykJFW5GryUWwn7Gw12qr1UXFy5XrWUJa4DJr409a4jkr4UAryjqFy8XryYgr1UJrWkJF1U
        Jr1Utr17Z3W7JabCm3ZEXasCq-sJn29KB7ZKAUJUUUUJ529EdanIXcx71UUUUU7KY7ZEXa
        sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
        0xBIdaVrnRJUUUPab4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
        IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
        e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
        0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
        6r4UJVWxJr1ln4kS14v26r1q6r43M2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12
        xvs2x26I8E6xACxx1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1q
        6rW5McIj6I8E87Iv67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr4
        1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWrXVW3AwCF04k20xvY0x0EwIxG
        rwCFx2IqxVCFs4IE7xkEbVWUJVW8JwCFI7km07C267AKxVWUtVW8ZwC20s026c02F40E14
        v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Wrv_Gr1UMIIY
        rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Gr0_Xr1lIxAIcVC0I7IYx2IY6xkF7I0E14
        v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWx
        JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUD1EEUU
        UUU
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 2023/6/20 02:12, Limonciello, Mario wrote:
>
> On 6/12/2023 2:25 PM, Sui Jingfeng wrote:
>> From: Sui Jingfeng <suijingfeng@loongson.cn>
>>
>> Deal only with the VGA devcie(pdev->class == 0x0300), so replace the
>> pci_get_subsys() function with pci_get_class(). Filter the non-PCI 
>> display
>> device(pdev->class != 0x0300) out. There no need to process the 
>> non-display
>> PCI device.
>>
>> Signed-off-by: Sui Jingfeng <suijingfeng@loongson.cn>
>> ---
> This also means that deleting a PCI device no longer needs
> to walk the list.
>
> Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
>
Thanks a lot,

can you help to resend this precious R-B to the V7 of this series [1],

This is V6.

[1] https://patchwork.freedesktop.org/series/119250/

>>   drivers/pci/vgaarb.c | 22 ++++++++++++----------
>>   1 file changed, 12 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/pci/vgaarb.c b/drivers/pci/vgaarb.c
>> index c1bc6c983932..22a505e877dc 100644
>> --- a/drivers/pci/vgaarb.c
>> +++ b/drivers/pci/vgaarb.c
>> @@ -754,10 +754,6 @@ static bool vga_arbiter_add_pci_device(struct 
>> pci_dev *pdev)
>>       struct pci_dev *bridge;
>>       u16 cmd;
>>   -    /* Only deal with VGA class devices */
>> -    if ((pdev->class >> 8) != PCI_CLASS_DISPLAY_VGA)
>> -        return false;
>> -
>>       /* Allocate structure */
>>       vgadev = kzalloc(sizeof(struct vga_device), GFP_KERNEL);
>>       if (vgadev == NULL) {
>> @@ -1500,7 +1496,9 @@ static int pci_notify(struct notifier_block 
>> *nb, unsigned long action,
>>       struct pci_dev *pdev = to_pci_dev(dev);
>>       bool notify = false;
>>   -    vgaarb_dbg(dev, "%s\n", __func__);
>> +    /* Only deal with VGA class devices */
>> +    if (pdev->class != PCI_CLASS_DISPLAY_VGA << 8)
>> +        return 0;
>>         /* For now we're only intereted in devices added and removed. 
>> I didn't
>>        * test this thing here, so someone needs to double check for the
>> @@ -1510,6 +1508,8 @@ static int pci_notify(struct notifier_block 
>> *nb, unsigned long action,
>>       else if (action == BUS_NOTIFY_DEL_DEVICE)
>>           notify = vga_arbiter_del_pci_device(pdev);
>>   +    vgaarb_dbg(dev, "%s: action = %lu\n", __func__, action);
>> +
>>       if (notify)
>>           vga_arbiter_notify_clients();
>>       return 0;
>> @@ -1534,8 +1534,8 @@ static struct miscdevice vga_arb_device = {
>>     static int __init vga_arb_device_init(void)
>>   {
>> +    struct pci_dev *pdev = NULL;
>>       int rc;
>> -    struct pci_dev *pdev;
>>         rc = misc_register(&vga_arb_device);
>>       if (rc < 0)
>> @@ -1545,11 +1545,13 @@ static int __init vga_arb_device_init(void)
>>         /* We add all PCI devices satisfying VGA class in the arbiter by
>>        * default */
>> -    pdev = NULL;
>> -    while ((pdev =
>> -        pci_get_subsys(PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
>> -                   PCI_ANY_ID, pdev)) != NULL)
>> +    while (1) {
>> +        pdev = pci_get_class(PCI_CLASS_DISPLAY_VGA << 8, pdev);
>> +        if (!pdev)
>> +            break;
>> +
>>           vga_arbiter_add_pci_device(pdev);
>> +    }
>>         pr_info("loaded\n");
>>       return rc;

-- 
Jingfeng

