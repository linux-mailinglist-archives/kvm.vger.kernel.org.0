Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA4BC3FEC5D
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 12:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233799AbhIBKtj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 06:49:39 -0400
Received: from mail-eopbgr70051.outbound.protection.outlook.com ([40.107.7.51]:3042
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245693AbhIBKtg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Sep 2021 06:49:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dnvi/omBv3GrdeGf5pxi7b2TckLdqg0paRJ5hTboWl0=;
 b=hEG43A/0luDmRmrpSWrcZk2UpEK6qBwvYdGaNLGQcn/a9QtQc59FNTIVQt08Ly5qHLMFQ0ZbsJFmGhW1a6+CsnnUB9jgrj3ftxI11RUEXQb9qTVdsAF+5dLV2Ad7UCxT6P2XkoB9jcl0EJulU/W1NAZb8gi6myK+KCVEicHydms=
Received: from AM6PR10CA0030.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:209:89::43)
 by PR3PR08MB5612.eurprd08.prod.outlook.com (2603:10a6:102:8f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19; Thu, 2 Sep
 2021 10:48:32 +0000
Received: from AM5EUR03FT028.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:209:89:cafe::13) by AM6PR10CA0030.outlook.office365.com
 (2603:10a6:209:89::43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.17 via Frontend
 Transport; Thu, 2 Sep 2021 10:48:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM5EUR03FT028.mail.protection.outlook.com (10.152.16.118) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4478.19 via Frontend Transport; Thu, 2 Sep 2021 10:48:32 +0000
Received: ("Tessian outbound 32695b2df2f8:v103"); Thu, 02 Sep 2021 10:48:32 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 6a100947d794a74d
X-CR-MTA-TID: 64aa7808
Received: from da63de19165b.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 359CA352-83FB-4184-910E-7991D5E70725.1;
        Thu, 02 Sep 2021 10:48:22 +0000
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id da63de19165b.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Thu, 02 Sep 2021 10:48:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BCj0qxFTmzsDreZQPrMkhyWyHH2kcFubRrKh1fANmC4Wp9vXFk0773OrtEZ+4EnFyV2LiKsFhYYsNp8a1GHOJS8E/QkrUq8B5r9WNCqIX83C6lz1aNqWerSUlbYLHSlUyUs/ZkFMsxtO13q50ohFYze6gKfc03lu7Ohl+dmjAt5pNgbtwxSS7k93A8DiiTIor0xjKt9EdebN32dWXjfuctmWE0PQzBIeKzfisycW0oTYWAmxHeBwZZYBrTjzR8vE49SlZ6SONQm5wUtgOZYNo3xre5wCAYhLKsQIaXeJYQcpX/iq44EiGgbSVg4Xa0T9zpK1SWFJAmLgAqtcKgtyig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=dnvi/omBv3GrdeGf5pxi7b2TckLdqg0paRJ5hTboWl0=;
 b=NvbMTALknOEDhS1Pm9n9dZShgVZ2fMmeN5+eqZGqOleOgvOj8dQHq37wQPwcK4ouPZ0fx/9sRq5u0b4UdTm+IyiazTtqu9WpbZJE1JPSePepjR1cNKxrfBDMvh1ZTvQEp7yjhs13GVeubEBB1HYSkgv+EZexPoKUrZ5KcQJneRRwndt5W+jxQ4NV9V14kG7xx+jSl6kuTd8oalr5g2gKzc1NwggyKpQpyvKCwh2lTRvpykYTw5WWZUowBql41y61P4skOV+ggaY3N9/w/ZXMnBhwq8+fT2X4ToiXz6XGj4W666xXWySnpmqBziVNNyrsE1mDl+YEO4uxAIVJsgqf/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dnvi/omBv3GrdeGf5pxi7b2TckLdqg0paRJ5hTboWl0=;
 b=hEG43A/0luDmRmrpSWrcZk2UpEK6qBwvYdGaNLGQcn/a9QtQc59FNTIVQt08Ly5qHLMFQ0ZbsJFmGhW1a6+CsnnUB9jgrj3ftxI11RUEXQb9qTVdsAF+5dLV2Ad7UCxT6P2XkoB9jcl0EJulU/W1NAZb8gi6myK+KCVEicHydms=
Authentication-Results-Original: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=arm.com;
Received: from DB6PR08MB2645.eurprd08.prod.outlook.com (2603:10a6:6:24::25) by
 DB9PR08MB6713.eurprd08.prod.outlook.com (2603:10a6:10:2aa::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4478.19; Thu, 2 Sep 2021 10:48:16 +0000
Received: from DB6PR08MB2645.eurprd08.prod.outlook.com
 ([fe80::5c52:c63f:275d:59b6]) by DB6PR08MB2645.eurprd08.prod.outlook.com
 ([fe80::5c52:c63f:275d:59b6%4]) with mapi id 15.20.4478.019; Thu, 2 Sep 2021
 10:48:16 +0000
Subject: Re: [PATCH] vfio/pci: Add support for PCIe extended capabilities
To:     Alexandru Elisei <alexandru.elisei@arm.com>, will@kernel.org,
        julien.thierry.kdev@gmail.com, kvm@vger.kernel.org
Cc:     andre.przywara@arm.com, lorenzo.pieralisi@arm.com,
        jean-philippe@linaro.org, eric.auger@redhat.com
References: <20210810062514.18980-1-vivek.gautam@arm.com>
 <af1ae6fe-176b-8016-3815-faa9651b0aba@arm.com>
From:   Vivek Kumar Gautam <vivek.gautam@arm.com>
Message-ID: <51cc78f5-6841-5e83-3b28-bef7fbf68937@arm.com>
Date:   Thu, 2 Sep 2021 16:18:09 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <af1ae6fe-176b-8016-3815-faa9651b0aba@arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BM1PR0101CA0057.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:19::19) To DB6PR08MB2645.eurprd08.prod.outlook.com
 (2603:10a6:6:24::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.162.16.71] (217.140.105.56) by BM1PR0101CA0057.INDPRD01.PROD.OUTLOOK.COM (2603:1096:b00:19::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.17 via Frontend Transport; Thu, 2 Sep 2021 10:48:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2628decf-a5e8-4131-72a1-08d96dff354a
X-MS-TrafficTypeDiagnostic: DB9PR08MB6713:|PR3PR08MB5612:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PR3PR08MB5612FB119E959415A7D8186E89CE9@PR3PR08MB5612.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: cxZwg+YCDw5UxPseXcvMvQoIKwf32OwC4eT99aqM4FF9HNCbCFoH8ajLN9Zw5bTI3VTeng8q/RTd4qEKK/KF7kwFopL3Pm4ouRx8lrCTz6A76k+n9fFnp6OuEcaNMO2ohwrIby+7BAH+2z7GZEqrHaVqI6R+6EDyIJ0J2Stno09KnMhwHao9gc2uLqAFxvHLcvFLoF2acoa+cjUHTgdOAUFU4uq2J6hWYAlTwB/UEJl84BMRuiUPtUkoOEFGvK1cpuUnqwVFRiW4NY5FTm0yHHCpvIMihPbZh6WrrTWdsr1ecPWEuQcXNtNuAKzc8uLjGjq9iICadaGlzcUWBrWjJpmOKXQIAI87kFN6qmtK8KjnXI0oA+x+dMLd+Ndu1w63VB6y+92BEYXHllbCREgzaTMALJc5IzCthbI4p7oWpm4sOCacZpXOeEHbj9zqvffIO4dEmeRNoM9zoO6+90kgPVCuF4oCszR+8tl+Kj1hUTqJ9N2+L5HPHE3CkcWAgRFsQVwLiqeSpLe0uXzwYIbRRzBvikYpJWpoFQLguGAErMtafaJfGgLpaCg8KNTKnJ221FbmjzyqaIZNFrLHcWHILhJ8hfH/S19R9hRVPusN6DluWyTGi9zcwKv41ihebeHgKR6577WB1/UDNk93dx0wYGVzhGqErale1CzdNcQWHS4gIafNK5cLFTGRCRNFhnJ0o/VaWsFWQQzVzdxbcxjET+UrWW2bIjjYtKoChlVLQkQ0Rh+7xkc0RtthSGKwxIRyf+rf2XXI99xOuOR1Fz9uug==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB6PR08MB2645.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(396003)(376002)(136003)(346002)(66476007)(52116002)(186003)(4326008)(6486002)(2906002)(5660300002)(8676002)(66946007)(2616005)(956004)(31696002)(86362001)(8936002)(478600001)(66556008)(31686004)(83380400001)(316002)(36756003)(53546011)(38350700002)(26005)(38100700002)(6666004)(16576012)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB6713
Original-Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM5EUR03FT028.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: 3110dd60-b424-43d3-2c87-08d96dff2b68
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AWWQdWQXwPorC7bZ+zpLUQ66nK7eLUnTkw+FSzrgSN4NDKi0nqZOKcAbahtCCSRN2D6y/9u+OGXc2nnyaBs16uXCenaADgO+hkvIZleThKN2jrGzuguF01vJ0hbxc9elld3kmP1LaL2x6x9Y4uC6Vccac98esjG0CBM5KRY2w1v9swTVNuPg4JDYx+sVzut44qehscAhLgpkXovsZXbQvsy0XvJSFwNfz56c7oRxQMMbrU++ndyrwZoAU8i9YNn2cjOEBLuVw9lxyDEBYhaeanOCuyrLow+9Zd4MPVKT1bdp52/m5tijldL3ikn45eVL3alxqXBQIX9GqA1t+0rL/rOIPQyEKEdtsI2E4eyGQZOejvPVAhHZENf72HZKZZqyppg5hTPs5eWD0bJKtPSxz44autzA4yIq0yJyyZ/QdImgcpIsb9qe/FE8hGbgOVUb+KrSn3cVQ2K1XBgZA6ZnbEXV8LwL30WLrRqUM98XoOzE4m8aQF+I94aIBa5nZ2XvjPuT7QvWMZ3ymLkEhZSPTg8XTCaaNA/F3htm++eGc2SY9eUESO17AjtYmk/CTPclPURXeAB/q+DrCIvIl8C/Xc3+i4jGjblYrvDTD/xwVaHhPwMLdE7A7Vj94Wqsx0BytfPk07pb9Y4wHLYEfAqrLd3Js2AkUr7nTgTweskh7FfYDD38e1OT2F893w9QmpxY0hIr3pSR1oUsKN5unsqoBJTFLSELMbx5TD4TZbSmveM=
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(346002)(39860400002)(376002)(136003)(396003)(46966006)(36840700001)(83380400001)(2906002)(53546011)(2616005)(47076005)(36756003)(6666004)(107886003)(6486002)(81166007)(26005)(16576012)(186003)(82740400003)(8676002)(478600001)(356005)(316002)(336012)(36860700001)(70206006)(70586007)(4326008)(31686004)(5660300002)(86362001)(82310400003)(8936002)(31696002)(956004)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2021 10:48:32.7026
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2628decf-a5e8-4131-72a1-08d96dff354a
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: AM5EUR03FT028.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR08MB5612
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,


On 9/2/21 3:29 PM, Alexandru Elisei wrote:
> Hi Vivek,
>
> On 8/10/21 7:25 AM, Vivek Gautam wrote:
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
>
> I believe bits 19:16 are the cap version if you look at the header as a 3=
2bit
> value (next:type). If you actually want to set those bits, you need to se=
t bits
> 3:0 of the next field. I believe the comment should reflect that because =
it's
> slightly confusing (no field is larger than 16 bits, for example). Or you=
 can move
> the comment at the top of the struct and keep it as it is.

Right, bit [19:16] for u16 would be a wrong interpretation. I will move
this comment to top of the structure.

>
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
>> +    /*
>> +     * Out of the two upper bytes of extended cap header, the
>> +     * nibble [19:16] is actually cap version that should be 0x1,
>> +     * so shift back the actual 'next' value by 4 bits.
>> +     */
>> +    last->next =3D (last->next << 4) | 0x1;
>> +    memcpy(virt_hdr + pos, cap, vfio_pci_ext_cap_size(cap));
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
>
> Devices are PCI Express if they have the PCI Express Capability (this is =
also how
> Linux tells them apart). The arch_has_pci_exp() is meant to check that th=
e
> architecture kvmtool has been compiled for can emulate a PCI Express bus =
(as
> apposed to a legacy PCI bus). For example, when you compile kvmtool for x=
86, you
> will get a legacy PCI bus.
>
> I'm not saying the check is bad, because it definitely should be done, bu=
t if what
> you're trying to do is to check that the device is a PCI Express capable =
device,
> then you also need to have a look at the PCI Express Capability like Andr=
e suggested.

Yes, better to check the 'presence' of PCI express caps after reading
the extended configuration space rather than relying on a static check.
I will add as Andre suggested.

>
>> +    if (!arch_has_pci_exp())
>> +            return 0;
>> +
>> +    /* Extended caps start from 0x100 offset. */
>> +    pos =3D 0x100;
>> +
>> +    for (; pos; pos =3D next) {
>> +            ext_cap =3D PCI_CAP(&pdev->hdr, pos);
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
>> +     * Update the extended configuration space as well since we
>> +     * are now populating the extended capabilities.
>>       */
>> -    hdr_sz =3D PCI_DEV_CFG_SIZE_LEGACY;
>> +    hdr_sz =3D PCI_DEV_CFG_SIZE;
>
> In one of the earlier versions of the PCI Express patches I was doing the=
 same
> thing here - overwriting the entire PCI Express configuration space for a=
 device.
> However, that made one of the devices I was using for testing stop workin=
g when
> assigned to a VM.
>
> I'll go through my testing notes and test it again, the cause of the fail=
ure might
> have been something else entirely which was fixed since then.

Sure. Let me know your findings.

Best regards
Vivek

>
> Thanks,
>
> Alex
>
>>      if (pwrite(vdev->fd, &pdev->hdr, hdr_sz, info->offset) !=3D hdr_sz)=
 {
>>              vfio_dev_err(vdev, "failed to write %zd bytes to Config Spa=
ce",
>>                           hdr_sz);
IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
