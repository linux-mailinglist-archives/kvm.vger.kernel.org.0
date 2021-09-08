Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 333F6403705
	for <lists+kvm@lfdr.de>; Wed,  8 Sep 2021 11:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343606AbhIHJiS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Sep 2021 05:38:18 -0400
Received: from mail-eopbgr20062.outbound.protection.outlook.com ([40.107.2.62]:57951
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234842AbhIHJiP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Sep 2021 05:38:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5faj55bpx1rWNN2MZ2lLSpiET52DfgaCJwo+3IntTzA=;
 b=bNK70haLV+UETF+SIjtTWgsDF1M6kwX/UY7uEPwrUl161pQMyQlRv0gNlotbzBNQ/U4bF4TDoE6UwqlLM86gLK1aL3c+uSGALqaJIsowOIJMvw60NVi92PhdkCH2dQDnQOlJ5QnigmjcXobN6b6FBHqJBCRBGChRWi69JQUudHw=
Received: from DB6PR0201CA0032.eurprd02.prod.outlook.com (2603:10a6:4:3f::42)
 by HE1PR0801MB1801.eurprd08.prod.outlook.com (2603:10a6:3:7f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19; Wed, 8 Sep
 2021 09:37:04 +0000
Received: from DB5EUR03FT063.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:4:3f:cafe::ca) by DB6PR0201CA0032.outlook.office365.com
 (2603:10a6:4:3f::42) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend
 Transport; Wed, 8 Sep 2021 09:37:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT063.mail.protection.outlook.com (10.152.20.209) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4478.19 via Frontend Transport; Wed, 8 Sep 2021 09:37:03 +0000
Received: ("Tessian outbound 931f733b3e5b:v105"); Wed, 08 Sep 2021 09:37:03 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 97e1e29fc7562208
X-CR-MTA-TID: 64aa7808
Received: from 238f13f9cf46.2
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id E907A576-8BA8-4BAB-802C-E2A8AFFCF678.1;
        Wed, 08 Sep 2021 09:36:53 +0000
Received: from EUR02-VE1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 238f13f9cf46.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Wed, 08 Sep 2021 09:36:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iSJo3PF/dB2k5khRLPQXMS00OAn8HY3qmAyKFQ9wjefPELrwXkEkgo/wfj4IE2YKlTPj67nrz6bXzzANIvmUnSWWJLn3MoVVcv+1DGnUpzZRP7XClS9LY0HPVo5ME3rFlJyXqNiHGp42nANH2J2zAUjB1SXSJngYWDTguLytxKpAnFhQoQVTwnwqQlQ6Z2aJ3dOIx1SVSB+3gmF9oJcTM1gDfj8g4yqrWskDmWRKvjJQLAiqcjkW7teRYE3YNg08kgXkfqh0dYY8v0dTxL5cB0jCLyriiqsECGHvR4pQPyvL30QG4qp2CQ4IRJlKSn+2oddTEjtkKa10a+BFfmOWPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=5faj55bpx1rWNN2MZ2lLSpiET52DfgaCJwo+3IntTzA=;
 b=fgp5tbLCkJV+ooue7aVQ7EsSBzzpZj6W7V4i9LNuFzUM5U0aTwSh/Q7K+iQrskA33RTuWxKSrD0FND/XWGjKQNyGTZAtkzdr+TRmMhIbVTB/1Sa6bpCqPO4XuXB08gC1huIq0OqBwzIbcPjLfJucPH9CSCvpW5VH0khYjwp2y9RzIrixQ6+F6OLfCjc4AIANW7tZMRQrMjgHzVWCJFcrZvfyCK0pnIWHRpqNMC+akzhbKyQGYl1WGkYYKqPfFtYq0VVdxuO4qmROQ0g06sI/IlRfrL1P2I8iueixynGy+N4VAF84HlAdtnkfFd40neYq8O+WRH6QeRY5vD+TgjeOsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5faj55bpx1rWNN2MZ2lLSpiET52DfgaCJwo+3IntTzA=;
 b=bNK70haLV+UETF+SIjtTWgsDF1M6kwX/UY7uEPwrUl161pQMyQlRv0gNlotbzBNQ/U4bF4TDoE6UwqlLM86gLK1aL3c+uSGALqaJIsowOIJMvw60NVi92PhdkCH2dQDnQOlJ5QnigmjcXobN6b6FBHqJBCRBGChRWi69JQUudHw=
Authentication-Results-Original: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=arm.com;
Received: from DB6PR08MB2645.eurprd08.prod.outlook.com (2603:10a6:6:24::25) by
 DB6PR0802MB2375.eurprd08.prod.outlook.com (2603:10a6:4:87::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4478.19; Wed, 8 Sep 2021 09:36:51 +0000
Received: from DB6PR08MB2645.eurprd08.prod.outlook.com
 ([fe80::5c52:c63f:275d:59b6]) by DB6PR08MB2645.eurprd08.prod.outlook.com
 ([fe80::5c52:c63f:275d:59b6%4]) with mapi id 15.20.4478.019; Wed, 8 Sep 2021
 09:36:51 +0000
Subject: Re: [PATCH] vfio/pci: Add support for PCIe extended capabilities
From:   Vivek Kumar Gautam <vivek.gautam@arm.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>, will@kernel.org,
        julien.thierry.kdev@gmail.com, kvm@vger.kernel.org
Cc:     andre.przywara@arm.com, lorenzo.pieralisi@arm.com,
        jean-philippe@linaro.org, eric.auger@redhat.com
References: <20210810062514.18980-1-vivek.gautam@arm.com>
 <af1ae6fe-176b-8016-3815-faa9651b0aba@arm.com>
 <51cc78f5-6841-5e83-3b28-bef7fbf68937@arm.com>
 <ae4bdd18-29c8-5871-5242-95d5c5d8a6a6@arm.com>
 <867e8db7-c173-5ad2-dca4-69085c89d956@arm.com>
Message-ID: <1ad57648-000d-185a-d959-7941999e7cb1@arm.com>
Date:   Wed, 8 Sep 2021 15:06:44 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <867e8db7-c173-5ad2-dca4-69085c89d956@arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BM1PR0101CA0055.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:19::17) To DB6PR08MB2645.eurprd08.prod.outlook.com
 (2603:10a6:6:24::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.162.16.71] (217.140.105.56) by BM1PR0101CA0055.INDPRD01.PROD.OUTLOOK.COM (2603:1096:b00:19::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Wed, 8 Sep 2021 09:36:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a36c10f8-94da-41ec-290a-08d972ac3739
X-MS-TrafficTypeDiagnostic: DB6PR0802MB2375:|HE1PR0801MB1801:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR0801MB180106DAF982BC0B5B379CDB89D49@HE1PR0801MB1801.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: TMT9Z1Iu9wjOXTe9IPtcqdo+j+C5ZFsoLqiLVexZZgr2W+CPftFSQZ+D2PZuqEllw4i/+TjzhXIfdQbUhT13b7fl2AfVwmFHPtnPVddn/FAjbgqlfcgd6Xz4kPHWRzskmC5aC40wulyycigTfVPHhy4KhaZpnWLblN8UBU7RReOes3a3O5YHWydtWEe9bamrtz5htN9oVgAoTDtXkBfAiJplJrW31YFEUesFWRguHmsf2FO3/WFzrAyOPAsm1Z0EWIzuviD3xMwGWF5AwaqLMbZZsRi6eqbCsmwUDRMtmJTlg989tjQl8C4NjIagOTVpBwcB9cOV/fG06Q5bcZnBzNmhExgPa163kQIJ+Ul4M8X6yFFsc3GHEa/psgjJ3LErwDEu7PJwgflH42TPOxCyyf1ndliM/VrSWc35OQ7gA7/h1GzUR65mZ6bwvPDeVgTvANtD2W7ogUKnzS058NVR+h/RQZqYnrSsePuJTG2UG11MLb973c9cRlLh3Tye8snGbJ1pFQ9CJxp73F/M7QcHgLvZPzJ6GM2H5Qe7RVWnFxNYHa5DxpyQbzR1M+CIdc8Il2ZcstYvrdAk56v351sba65mCexlu+G3Z2vYzvZyFshl+7VwMHQABjGmoit/ilHsAO13xXqFI4vSuZ+8SNSfAuCkx0KmmhhR7HgPdBegesfOz2l/NYGG95rHMtE0p/4azbV4j/LUeLY74UPSUe2RHoVgl553oF/Uvns8nyt4WuswQuIx6zCYThIlRpoRmJSJEajaQabxOsgspLPS676T0w==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB6PR08MB2645.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(136003)(396003)(366004)(346002)(36756003)(52116002)(316002)(2906002)(31696002)(6666004)(2616005)(5660300002)(8676002)(26005)(86362001)(53546011)(83380400001)(956004)(186003)(4326008)(66476007)(66556008)(8936002)(478600001)(66946007)(16576012)(38100700002)(38350700002)(31686004)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0802MB2375
Original-Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT063.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: 27dd855f-7fc1-4be1-8743-08d972ac2f9d
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zgWWxLodmlckbNrv/+6mjBMso8XY0pAoWpvw0WC7LLZHcYBiY7tq3H9mRfpj3Pofx4+y6mtz8HxKRDUvZwqvrZKmf/6zupbS4rtk39JpoOdI9JN1kKjT0aCyDG/d1U4OYp+0uB4FCZVUarIqMkKrqbRyY1UcQVdy8XICYGm1HLPljKkn16Mc9wNT0g+tR6blogE7RIPfoXgpYJbOgh9sxr1SYK8f6fgBjdE7KXoIZV00rR/GrC/gbell1vBrfKDjkAW3W7pn+HIEyhkTpet2i0wKkIz5+CmnNrp0sH94BQ0vDFxNgDh6n3O4DyfJ2gCRg9mmBtwUH+0nKPCyVJNOT399Z2bldn4lgnUg4aVRQkb2A0yKpOunwQzBsiBsI8bQ2zDHLb9whZqHBKsmm1Fkw3g52lSKQdI+R8KilniFXQRxzqn4LbOoOZeZJ0DsNcDkQZjiKtf9yd412/Oo6Wyjs2oiKfftyjy1hKWxjPUn1uKmXdv7fZwVyFXkYwv41JmpDm0wr2Rkny9aLd68zYoUX+S6RvJkU72aT9cUMq21EUW7gPqNUu5cgzwix/cH3ZX0ejxmbN8FDcdlhvw4HPWlau8ObUR59UFHVYcKLBgPietPo3y/OnGTzN2bl9Fqv61Dw3FdBb7XEuGg4EC3Eo9sjG939CEgX98r7ZVGBGQjOcmANmcT/PmKxUxCiiflB1pYHuZ3vpecpzE8e5q3DVnwZMGdosxbPfMzZZEhTlpjGXs=
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(376002)(136003)(39860400002)(346002)(396003)(36840700001)(46966006)(2906002)(8676002)(336012)(82310400003)(8936002)(16576012)(316002)(70206006)(47076005)(31686004)(956004)(2616005)(478600001)(36756003)(53546011)(26005)(186003)(82740400003)(356005)(36860700001)(70586007)(81166007)(31696002)(6666004)(86362001)(83380400001)(4326008)(5660300002)(6486002)(107886003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2021 09:37:03.5970
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a36c10f8-94da-41ec-290a-08d972ac3739
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: DB5EUR03FT063.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0801MB1801
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/8/21 3:02 PM, Vivek Kumar Gautam wrote:
> Hi Alex,
>
>
> On 9/3/21 8:45 PM, Alexandru Elisei wrote:
>> Hi Vivek,
>>
>> On 9/2/21 11:48 AM, Vivek Kumar Gautam wrote:
>>> Hi Alex,
>>>
>>>
>>> On 9/2/21 3:29 PM, Alexandru Elisei wrote:
>>>> Hi Vivek,
>>>>
>>>> On 8/10/21 7:25 AM, Vivek Gautam wrote:
>>>>> Add support to parse extended configuration space for vfio based
>>>>> assigned PCIe devices and add extended capabilities for the device
>>>>> in the guest. This allows the guest to see and work on extended
>>>>> capabilities, for example to toggle PRI extended cap to enable and
>>>>> disable Shared virtual addressing (SVA) support.
>>>>> PCIe extended capability header that is the first DWORD of all
>>>>> extended caps is shown below -
>>>>>
>>>>>      31               20  19   16  15                 0
>>>>>      ____________________|_______|_____________________
>>>>>     |=C2=A0=C2=A0=C2=A0 Next cap off    |=C2=A0 1h   |=C2=A0=C2=A0=C2=
=A0=C2=A0 Cap ID          |
>>>>>     |____________________|_______|_____________________|
>>>>>
>>>>> Out of the two upper bytes of extended cap header, the
>>>>> lower nibble is actually cap version - 0x1.
>>>>> 'next cap offset' if present at bits [31:20], should be
>>>>> right shifted by 4 bits to calculate the position of next
>>>>> capability.
>>>>> This change supports parsing and adding ATS, PRI and PASID caps.
>>>>>
>>>>> Signed-off-by: Vivek Gautam <vivek.gautam@arm.com>
>>>>> ---
>>>>>    include/kvm/pci.h |=C2=A0=C2=A0 6 +++
>>>>>    vfio/pci.c        | 104
>>>>> ++++++++++++++++++++++++++++++++++++++++++----
>>>>>    2 files changed, 103 insertions(+), 7 deletions(-)
>> [..]
>>>>> @@ -725,7 +815,7 @@ static int vfio_pci_parse_caps(struct
>>>>> vfio_device *vdev)
>>>>>      static int vfio_pci_parse_cfg_space(struct vfio_device *vdev)
>>>>>    {
>>>>> -    ssize_t sz =3D PCI_DEV_CFG_SIZE_LEGACY;
>>>>> +    ssize_t sz =3D PCI_DEV_CFG_SIZE;
>>>>>        struct vfio_region_info *info;
>>>>>        struct vfio_pci_device *pdev =3D &vdev->pci;
>>>>>    @@ -831,10 +921,10 @@ static int vfio_pci_fixup_cfg_space(struct
>>>>> vfio_device
>>>>> *vdev)
>>>>>        /* Install our fake Configuration Space */
>>>>>        info =3D &vdev->regions[VFIO_PCI_CONFIG_REGION_INDEX].info;
>>>>>        /*
>>>>> -     * We don't touch the extended configuration space, let's be
>>>>> cautious
>>>>> -     * and not overwrite it all with zeros, or bad things might
>>>>> happen.
>>>>> +     * Update the extended configuration space as well since we
>>>>> +     * are now populating the extended capabilities.
>>>>>         */
>>>>> -    hdr_sz =3D PCI_DEV_CFG_SIZE_LEGACY;
>>>>> +    hdr_sz =3D PCI_DEV_CFG_SIZE;
>>>>
>>>> In one of the earlier versions of the PCI Express patches I was
>>>> doing the same
>>>> thing here - overwriting the entire PCI Express configuration space
>>>> for a device.
>>>> However, that made one of the devices I was using for testing stop
>>>> working when
>>>> assigned to a VM.
>>>>
>>>> I'll go through my testing notes and test it again, the cause of the
>>>> failure might
>>>> have been something else entirely which was fixed since then.
>>>
>>> Sure. Let me know your findings.
>>
>> I think I found the card that doesn't work when overwriting the
>> extended device
>> configuration space. I tried device assignment with a Realtek 8168
>> Gigabit
>> Ethernet card on a Seattle machine, and the host freezes when I try to
>> start a VM.
>> Even after reset, the machine doesn't boot anymore and it gets stuck
>> during the
>> boot process at this message:
>>
>> NewPackageList status: EFI_SUCCESS
>> BDS.SignalConnectDriversEvent(feeb6d60)
>> BDS.ConnectRootBridgeHandles(feeb6db0)
>>
>> It doesn't go away no matter how many times I reset the machine, to
>> get it booting
>> again I have to pull the plug and plug it again. I tried assigning the
>> device to a
>> VM several times, and this happened every time. The card doesn't have
>> the caps
>> that you added, this is caused entirely by the config space write
>> (tried it with
>> only the config space change).
>>
>> It could be a problem kvmtool, with Linux or with the machine, but
>> this is the
>> only machine where device assignment works and I would like to keep it
>> working
>> with this NIC.
>
> Sorry for the delay in responding. I took sometime off work.
> Sure, we will try to keep your machine working :)
>
>>
>> One solution I see is to add a field to vfio_pci_device (something
>> like has_pcie),
>> and based on that, vfio_pci_fixup_cfg_space() could overwrite only the
>> first 256
>> bytes or the entire device configuration space.
>
> Does the card support PCI extended caps (as seen from the PCI spec v5.0
> section-7.5)?
> If no, then I guess the check that I am planning to add - to check if
> the device supports extended Caps - can help here. Since we would add
> extended caps based on the mentioned check, it seems only valid to have
> that check before overwriting the configuration space.
>
>>
>> It's also not clear to me what you are trying to achieve with this
>> patch. Is there
>> a particular device that you want to get working? Or an entire class
>> of devices
>> which have those features? If it's the former, you could have the size
>> of the
>> config space write depend on the vendor + device id. If it's the
>> latter, we could
>> key the size of the config space write based on the presence of those
>> particular
>> PCIE caps and try and fix other devices if they break.

Sorry, I missed adding here that I am adding support for Shared virtual
addressing that would need PCI devices' ATS and PRI extended capability
to be exposed to the guest. That's the reason I am adding this change to
write the device configuration space in kvmtool with ATS and PRI caps.

BRs
Vivek

>
> Absolutely, we can check for the presence of PCI extended capabilities
> and based on that write the configuration space. If the device has issue
> with only a specific extended capability we can try to fix that by
> keying the DevID-VendorID pair? What do you think?
>
>>
>> Will, Andre, do you see other solutions? Do you have a preference?
>
> Will, Andre, please let me know as well if you have any preferences.
>
> Best regards
> Vivek
>
>>
>> Thanks,
>>
>> Alex
>>
>>>
>>> Best regards
>>> Vivek
>>>
>>>>
>>>> Thanks,
>>>>
>>>> Alex
>>>>
>>>>>        if (pwrite(vdev->fd, &pdev->hdr, hdr_sz, info->offset) !=3D
>>>>> hdr_sz) {
>>>>>            vfio_dev_err(vdev, "failed to write %zd bytes to Config
>>>>> Space",
>>>>>                     hdr_sz);
IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
