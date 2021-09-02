Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7807A3FEC55
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 12:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244893AbhIBKnd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 06:43:33 -0400
Received: from mail-eopbgr150070.outbound.protection.outlook.com ([40.107.15.70]:17170
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243699AbhIBKnb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Sep 2021 06:43:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yc5VkKQs8ESbums5A49tUvXHnavn4Kawwtjv4xTxi3o=;
 b=QtkeJcZMkwWtkpGBc4ZhNL9Dqt2rDuYb6kKzeP7FaAPrTqpfH5XG8KWe5t8e70o/lvZwO+Qec3mrmT8sRQsgQcl+ole4+Z2ILybvannNrdDSiZf4StCQSPGYnKuhKF/TLHu6Fvgod3BuUcQmNFYGkT7AtTAesktlUpVvYgU1ddA=
Received: from AM6P191CA0084.EURP191.PROD.OUTLOOK.COM (2603:10a6:209:8a::25)
 by VI1PR08MB2976.eurprd08.prod.outlook.com (2603:10a6:803:41::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19; Thu, 2 Sep
 2021 10:42:31 +0000
Received: from AM5EUR03FT059.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:209:8a:cafe::c6) by AM6P191CA0084.outlook.office365.com
 (2603:10a6:209:8a::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.17 via Frontend
 Transport; Thu, 2 Sep 2021 10:42:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM5EUR03FT059.mail.protection.outlook.com (10.152.17.193) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4478.19 via Frontend Transport; Thu, 2 Sep 2021 10:42:30 +0000
Received: ("Tessian outbound 32695b2df2f8:v103"); Thu, 02 Sep 2021 10:42:30 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: c7adb5c51080a5ee
X-CR-MTA-TID: 64aa7808
Received: from 33840c08f7d0.2
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 48035084-038B-4273-B36C-9AA636E0C27D.1;
        Thu, 02 Sep 2021 10:42:19 +0000
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 33840c08f7d0.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Thu, 02 Sep 2021 10:42:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kolIDakhEX5nXo1NrkNnpRxjDcs9ReiWmoszcMNEFnNkDJ9ASCRT7JJx8K/T3AxVb7Vm2tBqWxiUIGJCbeyYUJrg0t9zsmn0OHkpzm9LSmbGfHYte4oLQHhZp3jb/hqjkcGdu0HGAAyVxVDvfVeSfDw/yhHtqVYNUfvR9xyzh+rZRiw3NtONAmLFU9cntFVkviSKONo1wXfJkLJx/rLtrOWsUphqdEucNtKXB8aO7TpgNse+wYlp3QwAOyxXK3b4+CkdGYVx0xuKhove6hjsRBVrBdT6D+WCh83T9y86+P1f6khQew/JWYPAUsOUG8RGcE0cRz6RpwgZGc8v96Ym6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yc5VkKQs8ESbums5A49tUvXHnavn4Kawwtjv4xTxi3o=;
 b=DPpLCuVCmlhYww++Utc1olVRc5TfoCCQkw8LoyYb9MKSzZfC+QLRtaTlZPHNLDyevK7RO3mY1J5YHa9/t9yb65U8ADYJxsBn21lPlgpBOk+42JXBzG6jvlJQS2DVKBPWDRRUE5izdkTimcuK9UxEfCBtKdf9VrCCPfVx3WP1/NeQB2USKXOUhYSRMTIyT3TbPdeZ+dy3mJWXE/CH1ys331gPdDnRmnmD2lkPRKiIoFJRZPskiSYoGUcqMgaof2hU+FpuUjShHBrTBjqcxAiAWZubEgW9sF8wMUGXpkvOWn5PvOR3egVJ884yqivaNR29Y0SDWMnnzO59IhJ+PLZEUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yc5VkKQs8ESbums5A49tUvXHnavn4Kawwtjv4xTxi3o=;
 b=QtkeJcZMkwWtkpGBc4ZhNL9Dqt2rDuYb6kKzeP7FaAPrTqpfH5XG8KWe5t8e70o/lvZwO+Qec3mrmT8sRQsgQcl+ole4+Z2ILybvannNrdDSiZf4StCQSPGYnKuhKF/TLHu6Fvgod3BuUcQmNFYGkT7AtTAesktlUpVvYgU1ddA=
Authentication-Results-Original: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=arm.com;
Received: from DB6PR08MB2645.eurprd08.prod.outlook.com (2603:10a6:6:24::25) by
 DBBPR08MB6073.eurprd08.prod.outlook.com (2603:10a6:10:1f7::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4457.23; Thu, 2 Sep 2021 10:42:17 +0000
Received: from DB6PR08MB2645.eurprd08.prod.outlook.com
 ([fe80::5c52:c63f:275d:59b6]) by DB6PR08MB2645.eurprd08.prod.outlook.com
 ([fe80::5c52:c63f:275d:59b6%4]) with mapi id 15.20.4478.019; Thu, 2 Sep 2021
 10:42:17 +0000
Subject: Re: [PATCH] vfio/pci: Add support for PCIe extended capabilities
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        kvm@vger.kernel.org, alexandru.elisei@arm.com,
        lorenzo.pieralisi@arm.com, jean-philippe@linaro.org,
        eric.auger@redhat.com
References: <20210810062514.18980-1-vivek.gautam@arm.com>
 <20210831181458.48d2f35f@slackpad.fritz.box>
From:   Vivek Kumar Gautam <vivek.gautam@arm.com>
Message-ID: <65ca872d-94e0-89e9-34d4-5ba7bf6168c8@arm.com>
Date:   Thu, 2 Sep 2021 16:12:11 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210831181458.48d2f35f@slackpad.fritz.box>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: PN3PR01CA0044.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:98::21) To DB6PR08MB2645.eurprd08.prod.outlook.com
 (2603:10a6:6:24::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.162.16.71] (217.140.105.56) by PN3PR01CA0044.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:98::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.20 via Frontend Transport; Thu, 2 Sep 2021 10:42:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 16586e4f-6570-45c7-364b-08d96dfe5d9b
X-MS-TrafficTypeDiagnostic: DBBPR08MB6073:|VI1PR08MB2976:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR08MB297679070D41F7AA305DBF0E89CE9@VI1PR08MB2976.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: 9gqThEP/jdHqc/P73ShlKptBv2qUKv7eK5WavF9sJWPCMKeh+433hxvlF/QA14ZbOzb26VKwJ9apUafZLJ3ByVWaSx7nZjQH97CQWaT184gHB3zxHTAvXlJfa6qi7pPrp7J1SbOnHa8Jvg/Mb4L/lGwHRSm7tAMFJJh7lrG/PqvDb9GEGflgb0CVamdjCz8zbyzLGe08/HO2XhUbaIrFtXxKXFo+RdHciy0x8JumHbY8a0SJKAaSK6La6WHngTjaWVuRrMhi3gY9XeCUBEFyRVJRzEJ2dPm0c1sX6uZzSKzBELrJ+YP36QL/AH2vE7IcV8c0WD+I3t/E2AWVJraEsgYtpNue6vDF1EzaJyXXnu3PqEwB/4hlK1j15Ymbbik5SxxyAjM+EF1OGbN+rz8AUdH/pJn6Wfci5Tv2jC1hsW/8njAQ7XXZeueR9acJUm/QgwVu5AJpG/2frKA1zdcIPKeJCHHeXIgQ44Mike5gLaAzoZNfZIqyy7Fes4PujO217lqXqc7sYKBViuJHG3i4vT7mpF7rkCppdjio/zaXM9uGeeD+V1sQ3k1WKjWVcVgqDXOoBroCnr6MSE7LUKom7NgSHJCHKkRCfM2R5wnol2x/9yCHY56EnY3UdHLWM58AQ2KD7+i5W1y51FzAWGm/u8Ui190dXz6PaH1iiQeZ3WnPKQqYbGpjoul6E3cDDBtm4Pqjltn39xPqbbCA+q+AgrAbLj7Bz6hdz34lT/ZqVF+IVtErZI31ZbaCwSYjxneO0ckFesYLYj7GCvwDPJtGEQ==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB6PR08MB2645.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(376002)(346002)(39860400002)(31686004)(478600001)(38100700002)(5660300002)(31696002)(36756003)(186003)(4326008)(83380400001)(26005)(86362001)(66556008)(8936002)(6666004)(6862004)(52116002)(66476007)(53546011)(316002)(2616005)(38350700002)(66946007)(16576012)(6486002)(956004)(6636002)(2906002)(37006003)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB6073
Original-Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM5EUR03FT059.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: 22c685f8-d2f7-4c2b-b66e-08d96dfe551f
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PCy4ofNTJQV0uXWQ4CCPf4sp9y+MxOAQ0TrLUAB23Y0CPk7NJ2U6h+yXesYQiON7PEsDNaRhxvIseP5z6FpDK2iP7HOoaGv9oqNRTiRNMM5pSuCI7hc6OH/mVkw5erDkYmAt3TzVi0IH23Q2cOIYs01RNDQuHVbtETJRFKMD6VGku/LhNkGOI1RGOWwHpOlheChLiL7Fr5ETr6arqQbzf5IxC+tgmsdnJ+khRQk5CF2GpE/mIPnS5+JO9H//Lq9CSwe0cm4fuFOnL4++mOZfmI404cnINg3YO9LW5+O2Hk5AEjPLI6zLEM4mt4lNhQyT1ugXyvwWLIEJhIWb6aVpIt2MDCBsQs2kg4aYvrrGTaqnnisjnfzlJs6vWp8VaATQnrp0J/0k5YCQj7ghLd2p+s5Dio2ZJOHZ8+HgUmEYLi1AylSh8BxOdKEmQ6ZWyv5NEyWsrbFxUtTNKvxez1Bo8g1sTzX9J7ZLAnC4z5TzWcSGufa9wPw569UdW1Q+sX5KH3goVEmBHpsObtqgVMTfJ4eTyydKSgQqAI0KLE2Q975yDgCOkjvHM2oDLVl05tcGrI8c5n77LG+HnF/5wJAH+VV3z8gGy2r84w5yJfRo0MWRSsW42+1VS09yP5i5ugQYaQFraXUnt8PwUPmGA2KdMZqSCcA/C1eiGg57h0RJrrj5NtyscluiMkdMG42O8BHhJufkoNBbbkVtoZiHTb6VaaDE6ZgIOu0oBuat7VMWM+Q=
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(396003)(136003)(46966006)(36840700001)(83380400001)(2906002)(53546011)(2616005)(47076005)(36756003)(37006003)(6666004)(107886003)(6486002)(81166007)(26005)(16576012)(186003)(82740400003)(8676002)(478600001)(356005)(336012)(316002)(36860700001)(70206006)(31686004)(70586007)(4326008)(5660300002)(86362001)(6636002)(82310400003)(6862004)(8936002)(31696002)(956004)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2021 10:42:30.8370
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 16586e4f-6570-45c7-364b-08d96dfe5d9b
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: AM5EUR03FT059.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB2976
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Andre,


On 8/31/21 10:44 PM, Andre Przywara wrote:
> On Tue, 10 Aug 2021 11:55:14 +0530
> Vivek Gautam <vivek.gautam@arm.com> wrote:
>
> Hi Vivek,

Thanks a lot for the review. Please find my comments inline below.

>
>> Add support to parse extended configuration space for vfio based
>> assigned PCIe devices and add extended capabilities for the device
>> in the guest. This allows the guest to see and work on extended
>> capabilities, for example to toggle PRI extended cap to enable and
>> disable Shared virtual addressing (SVA) support.
>> PCIe extended capability header that is the first DWORD of all
>> extended caps is shown below -
>>
>>     31               20  19   16  15                 0
>>     ____________________|_______|_____________________
>>    |    Next cap off    |  1h   |     Cap ID          |
>>    |____________________|_______|_____________________|
>>
>> Out of the two upper bytes of extended cap header, the
>> lower nibble is actually cap version - 0x1.
>> 'next cap offset' if present at bits [31:20], should be
>> right shifted by 4 bits to calculate the position of next
>> capability.
>> This change supports parsing and adding ATS, PRI and PASID caps.
>>
>> Signed-off-by: Vivek Gautam <vivek.gautam@arm.com>
>> ---
>>   include/kvm/pci.h |   6 +++
>>   vfio/pci.c        | 104 ++++++++++++++++++++++++++++++++++++++++++----
>>   2 files changed, 103 insertions(+), 7 deletions(-)
>>
>> diff --git a/include/kvm/pci.h b/include/kvm/pci.h
>> index 0f2d5bb..a365337 100644
>> --- a/include/kvm/pci.h
>> +++ b/include/kvm/pci.h
>> @@ -165,6 +165,12 @@ struct pci_exp_cap {
>>      u32 root_status;
>>   };
>>
>> +struct pci_ext_cap_hdr {
>> +    u16     type;
>> +    /* bit 19:16 =3D 0x1: Cap version */
>> +    u16     next;
>> +};
>> +
>>   struct pci_device_header;
>>
>>   typedef int (*bar_activate_fn_t)(struct kvm *kvm,
>> diff --git a/vfio/pci.c b/vfio/pci.c
>> index ea33fd6..d045e0d 100644
>> --- a/vfio/pci.c
>> +++ b/vfio/pci.c
>> @@ -665,19 +665,105 @@ static int vfio_pci_add_cap(struct vfio_device *v=
dev, u8 *virt_hdr,
>>      return 0;
>>   }
>>
>> +static ssize_t vfio_pci_ext_cap_size(struct pci_ext_cap_hdr *cap_hdr)
>> +{
>> +    switch (cap_hdr->type) {
>> +    case PCI_EXT_CAP_ID_ATS:
>> +            return PCI_EXT_CAP_ATS_SIZEOF;
>> +    case PCI_EXT_CAP_ID_PRI:
>> +            return PCI_EXT_CAP_PRI_SIZEOF;
>> +    case PCI_EXT_CAP_ID_PASID:
>> +            return PCI_EXT_CAP_PASID_SIZEOF;
>> +    default:
>> +            pr_err("unknown extended PCI capability 0x%x", cap_hdr->typ=
e);
>> +            return 0;
>
> It looks somewhat weird to report an error, but then silently carry on
> anyways. Since the return value is signed, you could return something
> negative and check for that error in the caller.
> I see that is copied from the "normal" capabilities, but maybe this
> should be cleaned up there as well? It looks like ending here should be
> an internal error, when this list is not up-to-date with the switch/case
> below (which can be solved as well on the way).

Sure, will take care of the error case and fix.

>
>> +    }
>> +}
>> +
>> +static int vfio_pci_add_ext_cap(struct vfio_device *vdev, u8 *virt_hdr,
>> +                        struct pci_ext_cap_hdr *cap, off_t pos)
>> +{
>> +    struct pci_ext_cap_hdr *last;
>> +
>> +    cap->next =3D 0;
>> +    last =3D PCI_CAP(virt_hdr, 0x100);
>> +
>> +    while (last->next)
>> +            last =3D PCI_CAP(virt_hdr, last->next);
>> +
>> +    last->next =3D pos;
>
> This should be folded into the next statement, but ...
>
>> +    /*
>> +     * Out of the two upper bytes of extended cap header, the
>> +     * nibble [19:16] is actually cap version that should be 0x1,
>> +     * so shift back the actual 'next' value by 4 bits.
>> +     */
>> +    last->next =3D (last->next << 4) | 0x1;
>> +    memcpy(virt_hdr + pos, cap, vfio_pci_ext_cap_size(cap));
>
> So here you silently ignore the error when we see an unsupported
> capability. Granted, copying 0 bytes doesn't do anything, but at the
> same time we already updated the next pointer. So I guess you should
> query for the size first, and bail out if this is unsupported. Not sure
> what to do then, but I think we just ignore/filter that capability then?

Right, I got what you are saying here. As any other cap is not supported
at this point, it wouldn't be right to update the next pointer. I will
fix this.

>
>> +
>> +    return 0;
>> +
>> +}
>> +
>> +static int vfio_pci_parse_ext_caps(struct vfio_device *vdev, u8 *virt_h=
dr)
>> +{
>> +    int ret;
>> +    u16 pos, next;
>> +    struct pci_ext_cap_hdr *ext_cap;
>> +    struct vfio_pci_device *pdev =3D &vdev->pci;
>> +
>> +    /* Extended cap only for PCIe devices */
>> +    if (!arch_has_pci_exp())
>> +            return 0;
>> +
>> +    /* Extended caps start from 0x100 offset. */
>> +    pos =3D 0x100;
>
> Please move that into the for-loop statement.

Sure.

>
>> +
>> +    for (; pos; pos =3D next) {
>> +            ext_cap =3D PCI_CAP(&pdev->hdr, pos);
>
> Don't we need to check if there are extended capabilities at offset
> 0x100 first?
> "Absence of any Extended Capabilities is required to be indicated by an
> Extended Capability header with a Capability ID of 0000h, a Capability
> Version of 0h, and a Next Capability Offset of 000h."

Sure, will add a check before going into this loop to check whethere
extended caps are present or not.
I might have mistaken the 'presence' of extended cap with the
arch_has_pci_exp() check.

>
>> +            /*
>> +             * Out of the two upper bytes of extended cap header, the
>> +             * lowest nibble is actually cap version.
>> +             * 'next cap offset' if present at bits [31:20], while
>> +             * bits [19:16] are set to 1 to indicate cap version.
>> +             * So to get position of next cap right shift by 4 bits.
>> +             */
>> +            next =3D (ext_cap->next >> 4);
>> +
>> +            switch (ext_cap->type) {
>> +            case PCI_EXT_CAP_ID_ATS:
>> +                    ret =3D vfio_pci_add_ext_cap(vdev, virt_hdr, ext_ca=
p, pos);
>> +                    if (ret)
>
> That function seems to be always returning 0, but this would be fixed
> anyway, I guess. And then you could save the switch/case (which
> is somewhat redundant with the one in vfio_pci_ext_cap_size()), and just
> pass every capability to vfio_pci_add_ext_cap().

Sure, will fix here too.

>
>> +                            return ret;
>> +                    break;
>> +            case PCI_EXT_CAP_ID_PRI:
>> +                    ret =3D vfio_pci_add_ext_cap(vdev, virt_hdr, ext_ca=
p, pos);
>> +                    if (ret)
>> +                            return ret;
>> +                    break;
>> +            case PCI_EXT_CAP_ID_PASID:
>> +                    ret =3D vfio_pci_add_ext_cap(vdev, virt_hdr, ext_ca=
p, pos);
>> +                    if (ret)
>> +                            return ret;
>> +                    break;
>> +            }
>> +    }
>> +
>> +    return 0;
>> +}
>> +
>>   static int vfio_pci_parse_caps(struct vfio_device *vdev)
>>   {
>>      int ret;
>>      size_t size;
>>      u16 pos, next;
>>      struct pci_cap_hdr *cap;
>> -    u8 virt_hdr[PCI_DEV_CFG_SIZE_LEGACY];
>> +    u8 virt_hdr[PCI_DEV_CFG_SIZE];
>>      struct vfio_pci_device *pdev =3D &vdev->pci;
>>
>>      if (!(pdev->hdr.status & PCI_STATUS_CAP_LIST))
>>              return 0;
>>
>> -    memset(virt_hdr, 0, PCI_DEV_CFG_SIZE_LEGACY);
>> +    memset(virt_hdr, 0, PCI_DEV_CFG_SIZE);
>>
>>      pos =3D pdev->hdr.capabilities & ~3;
>>
>> @@ -715,9 +801,13 @@ static int vfio_pci_parse_caps(struct vfio_device *=
vdev)
>>              }
>>      }
>>
>> +    ret =3D vfio_pci_parse_ext_caps(vdev, virt_hdr);
>> +    if (ret)
>> +            return ret;
>> +
>>      /* Wipe remaining capabilities */
>>      pos =3D PCI_STD_HEADER_SIZEOF;
>> -    size =3D PCI_DEV_CFG_SIZE_LEGACY - PCI_STD_HEADER_SIZEOF;
>> +    size =3D PCI_DEV_CFG_SIZE - PCI_STD_HEADER_SIZEOF;
>>      memcpy((void *)&pdev->hdr + pos, virt_hdr + pos, size);
>>
>>      return 0;
>> @@ -725,7 +815,7 @@ static int vfio_pci_parse_caps(struct vfio_device *v=
dev)
>>
>>   static int vfio_pci_parse_cfg_space(struct vfio_device *vdev)
>>   {
>> -    ssize_t sz =3D PCI_DEV_CFG_SIZE_LEGACY;
>> +    ssize_t sz =3D PCI_DEV_CFG_SIZE;
>>      struct vfio_region_info *info;
>>      struct vfio_pci_device *pdev =3D &vdev->pci;
>>
>> @@ -831,10 +921,10 @@ static int vfio_pci_fixup_cfg_space(struct vfio_de=
vice *vdev)
>>      /* Install our fake Configuration Space */
>>      info =3D &vdev->regions[VFIO_PCI_CONFIG_REGION_INDEX].info;
>>      /*
>> -     * We don't touch the extended configuration space, let's be cautio=
us
>> -     * and not overwrite it all with zeros, or bad things might happen.
>
> It would be good to hear from Alex what those bad things are, and if
> passing on those extended caps now fixes those.

On this, I will wait for Alex's testing as he mentioned in the thread.

Best regards
Vivek

>
> Cheers,
> Andre
>
>> +     * Update the extended configuration space as well since we
>> +     * are now populating the extended capabilities.
>>       */
>> -    hdr_sz =3D PCI_DEV_CFG_SIZE_LEGACY;
>> +    hdr_sz =3D PCI_DEV_CFG_SIZE;
>>      if (pwrite(vdev->fd, &pdev->hdr, hdr_sz, info->offset) !=3D hdr_sz)=
 {
>>              vfio_dev_err(vdev, "failed to write %zd bytes to Config Spa=
ce",
>>                           hdr_sz);
>
IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
