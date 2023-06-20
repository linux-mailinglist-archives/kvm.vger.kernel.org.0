Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70F49736191
	for <lists+kvm@lfdr.de>; Tue, 20 Jun 2023 04:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbjFTCf5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 22:35:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjFTCfz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 22:35:55 -0400
Received: from 189.cn (ptr.189.cn [183.61.185.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9586619A;
        Mon, 19 Jun 2023 19:35:53 -0700 (PDT)
HMM_SOURCE_IP: 10.64.8.31:39374.762909731
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-114.242.206.180 (unknown [10.64.8.31])
        by 189.cn (HERMES) with SMTP id 890C0100300;
        Tue, 20 Jun 2023 10:35:47 +0800 (CST)
Received: from  ([114.242.206.180])
        by gateway-151646-dep-75648544bd-xp9j7 with ESMTP id f42811347ea34ea683eed42a8113599e for mario.limonciello@amd.com;
        Tue, 20 Jun 2023 10:35:51 CST
X-Transaction-ID: f42811347ea34ea683eed42a8113599e
X-Real-From: 15330273260@189.cn
X-Receive-IP: 114.242.206.180
X-MEDUSA-Status: 0
Sender: 15330273260@189.cn
Message-ID: <345c2bb9-71d8-27b9-0175-f1e55f096ed1@189.cn>
Date:   Tue, 20 Jun 2023 10:35:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v6 2/8] PCI/VGA: Deal only with VGA class devices
To:     "Limonciello, Mario" <mario.limonciello@amd.com>,
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
        Li Yi <liyi@loongson.cn>,
        Sui Jingfeng <suijingfeng@loongson.cn>,
        Jason Gunthorpe <jgg@ziepe.ca>,
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
Content-Language: en-US
From:   Sui Jingfeng <15330273260@189.cn>
In-Reply-To: <5b6fdf65-b354-94a9-f883-be820157efad@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,FROM_LOCAL_DIGITS,
        FROM_LOCAL_HEX,NICE_REPLY_A,RCVD_IN_SBL_CSS,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
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

Thanks a lot.


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
