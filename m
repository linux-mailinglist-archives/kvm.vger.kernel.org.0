Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F07274036F1
	for <lists+kvm@lfdr.de>; Wed,  8 Sep 2021 11:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347859AbhIHJdv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Sep 2021 05:33:51 -0400
Received: from mail-eopbgr60085.outbound.protection.outlook.com ([40.107.6.85]:27262
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233764AbhIHJdu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Sep 2021 05:33:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5/mrDOqt+EKCPyJ0WhIa1o7x8lg9gImtJJ5X74Z5FGQ=;
 b=i49TC2+MAgNkyNxQ1SxZ1AZ6KbRrseOzVxGjUo2Tp+eSn2yXU6HihswXLLAWkZbkheplZ/p4uRCdrTQLGQefqSBQ0rS1ZUHsasCDkBF1A2pyWWAZ59+bXlZ/mwVn7LWbZIPly49OcJzOac1NYrUhBkK1fNSYGF+B3/OejtZ1qWg=
Received: from AM6PR10CA0027.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:209:89::40)
 by DB7PR08MB3756.eurprd08.prod.outlook.com (2603:10a6:10:79::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.24; Wed, 8 Sep
 2021 09:32:37 +0000
Received: from VE1EUR03FT015.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:209:89:cafe::34) by AM6PR10CA0027.outlook.office365.com
 (2603:10a6:209:89::40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend
 Transport; Wed, 8 Sep 2021 09:32:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT015.mail.protection.outlook.com (10.152.18.176) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4478.19 via Frontend Transport; Wed, 8 Sep 2021 09:32:36 +0000
Received: ("Tessian outbound 620209b93b95:v105"); Wed, 08 Sep 2021 09:32:36 +0000
X-CheckRecipientChecked: true
X-CR-MTA-CID: 307fd6cf61267e0e
X-CR-MTA-TID: 64aa7808
Received: from 46f1117217be.2
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id AA0C8C7C-44E1-48B2-ADB3-10DC0EF1179A.1;
        Wed, 08 Sep 2021 09:32:29 +0000
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 46f1117217be.2
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Wed, 08 Sep 2021 09:32:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PweV8JYmSfGByCQu5cGF2imz57RI/23wMbewoAc/Y3DyPZ5ddjUcNvUk97Z9yCpajkVr42n4YfqV9uLwCRRTZVmZT9Y7SN++DUxUFZQm4aWCNfg865UQG9Ar/poNv4KI3eYzMBxXVi+3O+j0qyjMsv7PDHtUAaQa2VaV/O8mcdk0lJI9i/h2mr1AgKkHrGjAT2QzDv04dxZAWrGucbt3x7LrqFVfyc7YWh5b+OGU/TTiA+8AwOmtXwTaM50VKbUqnSuF0U4C1V/IuALPRQ2GrkH11XAiVKEd+Adcr1WvtBvYhP2B4UMRBOZUgHv1tmw+pXbPsT7ODM048vhQWXEfnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=5/mrDOqt+EKCPyJ0WhIa1o7x8lg9gImtJJ5X74Z5FGQ=;
 b=ENPHy940Mmof78uwOVX1bxNu19ynpuIx9bLxPwKGwGF92c8rZXpzQhRYDEU8CjCGRRDjMVRLpx5rML6IdruquXdsUvPT46gkOhwvcuiJbOb5HejCcpnlktpBl2twoL40Ld724r+akez03JA0h2JQAFhia0FceApMg1JasAspXg6cJnwpJhEGbPvizhjvxC3DV6hEtKLD5/8CwqbzQ1oKS/Om7+KIXYJPvK97+OA+uG9dwMyk8T8xSsOtVl8ajtL9b/vAwWKMzuOYZK8T9ovMYEN9X8NjiilWLa/EcIjBJIhiaSqC6yOhpz914f8C4iZ+uEH3atftefnjKuIQ2m9sjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5/mrDOqt+EKCPyJ0WhIa1o7x8lg9gImtJJ5X74Z5FGQ=;
 b=i49TC2+MAgNkyNxQ1SxZ1AZ6KbRrseOzVxGjUo2Tp+eSn2yXU6HihswXLLAWkZbkheplZ/p4uRCdrTQLGQefqSBQ0rS1ZUHsasCDkBF1A2pyWWAZ59+bXlZ/mwVn7LWbZIPly49OcJzOac1NYrUhBkK1fNSYGF+B3/OejtZ1qWg=
Authentication-Results-Original: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=arm.com;
Received: from DB6PR08MB2645.eurprd08.prod.outlook.com (2603:10a6:6:24::25) by
 DB6PR0802MB2422.eurprd08.prod.outlook.com (2603:10a6:4:9f::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4500.14; Wed, 8 Sep 2021 09:32:27 +0000
Received: from DB6PR08MB2645.eurprd08.prod.outlook.com
 ([fe80::5c52:c63f:275d:59b6]) by DB6PR08MB2645.eurprd08.prod.outlook.com
 ([fe80::5c52:c63f:275d:59b6%4]) with mapi id 15.20.4478.019; Wed, 8 Sep 2021
 09:32:27 +0000
Subject: Re: [PATCH] vfio/pci: Add support for PCIe extended capabilities
To:     Alexandru Elisei <alexandru.elisei@arm.com>, will@kernel.org,
        julien.thierry.kdev@gmail.com, kvm@vger.kernel.org
Cc:     andre.przywara@arm.com, lorenzo.pieralisi@arm.com,
        jean-philippe@linaro.org, eric.auger@redhat.com
References: <20210810062514.18980-1-vivek.gautam@arm.com>
 <af1ae6fe-176b-8016-3815-faa9651b0aba@arm.com>
 <51cc78f5-6841-5e83-3b28-bef7fbf68937@arm.com>
 <ae4bdd18-29c8-5871-5242-95d5c5d8a6a6@arm.com>
From:   Vivek Kumar Gautam <vivek.gautam@arm.com>
Message-ID: <867e8db7-c173-5ad2-dca4-69085c89d956@arm.com>
Date:   Wed, 8 Sep 2021 15:02:20 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <ae4bdd18-29c8-5871-5242-95d5c5d8a6a6@arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BM1PR0101CA0057.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:19::19) To DB6PR08MB2645.eurprd08.prod.outlook.com
 (2603:10a6:6:24::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.162.16.71] (217.140.105.56) by BM1PR0101CA0057.INDPRD01.PROD.OUTLOOK.COM (2603:1096:b00:19::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Wed, 8 Sep 2021 09:32:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 84cad0ad-5a34-455c-053f-08d972ab984c
X-MS-TrafficTypeDiagnostic: DB6PR0802MB2422:|DB7PR08MB3756:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR08MB3756BCCCE13B610A8B914C2489D49@DB7PR08MB3756.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: q+oWhqm7dXeLbTnNCDH3l2fd7AfLXxKIxBLjPyy6w+hKrnAFtYI8W6aW7yXl0S8kNwlSwbXOgArQgcYnTZVbtEcS4wKsLSY3zLNzGg6TTYs1FwSwx8sJrGkidRhW595UboU1nWZ7IQiK2X1OG7XiwOybW2UV42bxuxScyPccEZ6XN+9D4NdI3BXqfwoJqbT+guJDynxSia2TF7+51VKXYHYpOBv7Kg75qKOa/95jLNqP4h4IfdmqsaftJEKutQ9vJyWNoKbGtxxg8/BduP22a4T6LyKz5BJ5U3BEZMyglSqlDN9ltV/RyzcBcieJ1HSeOW57Dy+1Bn0xHbVnK2kG+ey6l/vCDXy2a1NGrF1TZSh4Z/jslntItpl/OEEe75BhCy9Yr9QUixvHNafgS5S9sv/XLPtRDPtb20ruKsCfkZL0qvfVgffP4ADerZf+hwxeo3BLGugyBhUucggwXv5gE+WpPpKNzxZdXsbT9RJ9dtxpqMvzaeVFiLUfIfHRO2qO8FvI/Cy3wD78V/MAt1WvtHq5aVliIpT1rErHNcKIZDHrl7OQfe7490qE99yesyVvc36x2gQp1dcT0DCGcR1eHRmeHFOT9vuRkJJ4zSCMepBTRdp3nvfwjNg0T9brQN510ekT5TCPSCbFNOkCGFniEZtQ0h+ZAVP9Eghoxo3Rye/UP4pyTmGH1A8gB/TcA+lKU/vL35tHMTFmW87E6CEVRVmOUIpaxao9Z5r3szc2ol9Z3B3C8XnlsYEfJ6MwUg52tRVVotYdp51CyYe4QwxwQg==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB6PR08MB2645.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(376002)(346002)(136003)(366004)(31696002)(8936002)(83380400001)(53546011)(52116002)(316002)(956004)(16576012)(5660300002)(2906002)(66476007)(6486002)(36756003)(38350700002)(66556008)(6666004)(66946007)(31686004)(2616005)(186003)(4326008)(26005)(8676002)(478600001)(38100700002)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0802MB2422
Original-Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT015.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: 65b8b3d7-96f8-49e3-db8a-08d972ab9259
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UGVzC+Id31jt50JivKYACubQIZ7anV6wQ/QwNZEhDhgdRNtuJeSeVML8rJV3UVVNMRaxSXhiyBgRmS4xZNAc3Ayf1rAsnTn8fKdIstazAcXNNL/99CHu8cLwmBiaSGqLl0uwZtTx5ZxYGrdRMsFOBprSMOUT/qR/TGSEynpsJ25aOQBhDHCDTdHyc72uMPzivyIYJKhtkn8W6eO4+IviAElmrmiDDLPCTmrGcW7vDKXwJiBWfumQTcpwjTlskz1fJ3Rti4B/ceS/bDOPnghp5IvYOZZeDEsVT18h/xeP7BMNbZjuysQkyt2HwrHN+///o434YOtNmC+NXhSmezDySzhKhOX+wVBWUwd7Uq4+Sh4KYtwjD1QZ7evWCYT+kgV/9FGBFiEOMe+4daRecM7ABmkwpnwDBOf7ab5LryoTL5AXGeIscSFisD0NyudfAt89aky6beG4zs8R8SRVWuyWwFNWTGJmjfIByOcds2sy2cqljY2KKmBFGRBQN63sX3Cs3ryNTaqSzvbIDrQFO7CVFk8xdhfX6LecCJf61MifqCXqgyZSw5DLE6hRD+TsMkEa7DJSHQXGWhggWLB1ilY32811/rG7mqxjFNVw0puHEpkq/Dgv8PBPGo9LNVt+65a2dMOhoz+TJOZDe1gNIfTDrtOvmr3aV0CAxeymJyCAcLN3GrO33Pl+FQSsvzqGZEHNd+YrJ1TqI7x0xbkySesp/Ab6H40pjWyVFSXRGljZtEw=
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(136003)(39860400002)(346002)(376002)(396003)(46966006)(36840700001)(47076005)(86362001)(2906002)(83380400001)(82310400003)(6486002)(4326008)(16576012)(316002)(31696002)(36860700001)(53546011)(8936002)(82740400003)(336012)(8676002)(36756003)(6666004)(81166007)(26005)(5660300002)(356005)(107886003)(186003)(31686004)(70586007)(70206006)(2616005)(956004)(478600001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2021 09:32:36.8119
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 84cad0ad-5a34-455c-053f-08d972ab984c
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR03FT015.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR08MB3756
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,


On 9/3/21 8:45 PM, Alexandru Elisei wrote:
> Hi Vivek,
>
> On 9/2/21 11:48 AM, Vivek Kumar Gautam wrote:
>> Hi Alex,
>>
>>
>> On 9/2/21 3:29 PM, Alexandru Elisei wrote:
>>> Hi Vivek,
>>>
>>> On 8/10/21 7:25 AM, Vivek Gautam wrote:
>>>> Add support to parse extended configuration space for vfio based
>>>> assigned PCIe devices and add extended capabilities for the device
>>>> in the guest. This allows the guest to see and work on extended
>>>> capabilities, for example to toggle PRI extended cap to enable and
>>>> disable Shared virtual addressing (SVA) support.
>>>> PCIe extended capability header that is the first DWORD of all
>>>> extended caps is shown below -
>>>>
>>>>      31               20  19   16  15                 0
>>>>      ____________________|_______|_____________________
>>>>     |=C2=A0=C2=A0=C2=A0 Next cap off    |=C2=A0 1h   |=C2=A0=C2=A0=C2=
=A0=C2=A0 Cap ID          |
>>>>     |____________________|_______|_____________________|
>>>>
>>>> Out of the two upper bytes of extended cap header, the
>>>> lower nibble is actually cap version - 0x1.
>>>> 'next cap offset' if present at bits [31:20], should be
>>>> right shifted by 4 bits to calculate the position of next
>>>> capability.
>>>> This change supports parsing and adding ATS, PRI and PASID caps.
>>>>
>>>> Signed-off-by: Vivek Gautam <vivek.gautam@arm.com>
>>>> ---
>>>>    include/kvm/pci.h |=C2=A0=C2=A0 6 +++
>>>>    vfio/pci.c        | 104 ++++++++++++++++++++++++++++++++++++++++++-=
---
>>>>    2 files changed, 103 insertions(+), 7 deletions(-)
> [..]
>>>> @@ -725,7 +815,7 @@ static int vfio_pci_parse_caps(struct vfio_device =
*vdev)
>>>>      static int vfio_pci_parse_cfg_space(struct vfio_device *vdev)
>>>>    {
>>>> -    ssize_t sz =3D PCI_DEV_CFG_SIZE_LEGACY;
>>>> +    ssize_t sz =3D PCI_DEV_CFG_SIZE;
>>>>        struct vfio_region_info *info;
>>>>        struct vfio_pci_device *pdev =3D &vdev->pci;
>>>>    @@ -831,10 +921,10 @@ static int vfio_pci_fixup_cfg_space(struct vf=
io_device
>>>> *vdev)
>>>>        /* Install our fake Configuration Space */
>>>>        info =3D &vdev->regions[VFIO_PCI_CONFIG_REGION_INDEX].info;
>>>>        /*
>>>> -     * We don't touch the extended configuration space, let's be caut=
ious
>>>> -     * and not overwrite it all with zeros, or bad things might happe=
n.
>>>> +     * Update the extended configuration space as well since we
>>>> +     * are now populating the extended capabilities.
>>>>         */
>>>> -    hdr_sz =3D PCI_DEV_CFG_SIZE_LEGACY;
>>>> +    hdr_sz =3D PCI_DEV_CFG_SIZE;
>>>
>>> In one of the earlier versions of the PCI Express patches I was doing t=
he same
>>> thing here - overwriting the entire PCI Express configuration space for=
 a device.
>>> However, that made one of the devices I was using for testing stop work=
ing when
>>> assigned to a VM.
>>>
>>> I'll go through my testing notes and test it again, the cause of the fa=
ilure might
>>> have been something else entirely which was fixed since then.
>>
>> Sure. Let me know your findings.
>
> I think I found the card that doesn't work when overwriting the extended =
device
> configuration space. I tried device assignment with a Realtek 8168 Gigabi=
t
> Ethernet card on a Seattle machine, and the host freezes when I try to st=
art a VM.
> Even after reset, the machine doesn't boot anymore and it gets stuck duri=
ng the
> boot process at this message:
>
> NewPackageList status: EFI_SUCCESS
> BDS.SignalConnectDriversEvent(feeb6d60)
> BDS.ConnectRootBridgeHandles(feeb6db0)
>
> It doesn't go away no matter how many times I reset the machine, to get i=
t booting
> again I have to pull the plug and plug it again. I tried assigning the de=
vice to a
> VM several times, and this happened every time. The card doesn't have the=
 caps
> that you added, this is caused entirely by the config space write (tried =
it with
> only the config space change).
>
> It could be a problem kvmtool, with Linux or with the machine, but this i=
s the
> only machine where device assignment works and I would like to keep it wo=
rking
> with this NIC.

Sorry for the delay in responding. I took sometime off work.
Sure, we will try to keep your machine working :)

>
> One solution I see is to add a field to vfio_pci_device (something like h=
as_pcie),
> and based on that, vfio_pci_fixup_cfg_space() could overwrite only the fi=
rst 256
> bytes or the entire device configuration space.

Does the card support PCI extended caps (as seen from the PCI spec v5.0
section-7.5)?
If no, then I guess the check that I am planning to add - to check if
the device supports extended Caps - can help here. Since we would add
extended caps based on the mentioned check, it seems only valid to have
that check before overwriting the configuration space.

>
> It's also not clear to me what you are trying to achieve with this patch.=
 Is there
> a particular device that you want to get working? Or an entire class of d=
evices
> which have those features? If it's the former, you could have the size of=
 the
> config space write depend on the vendor + device id. If it's the latter, =
we could
> key the size of the config space write based on the presence of those par=
ticular
> PCIE caps and try and fix other devices if they break.

Absolutely, we can check for the presence of PCI extended capabilities
and based on that write the configuration space. If the device has issue
with only a specific extended capability we can try to fix that by
keying the DevID-VendorID pair? What do you think?

>
> Will, Andre, do you see other solutions? Do you have a preference?

Will, Andre, please let me know as well if you have any preferences.

Best regards
Vivek

>
> Thanks,
>
> Alex
>
>>
>> Best regards
>> Vivek
>>
>>>
>>> Thanks,
>>>
>>> Alex
>>>
>>>>        if (pwrite(vdev->fd, &pdev->hdr, hdr_sz, info->offset) !=3D hdr=
_sz) {
>>>>            vfio_dev_err(vdev, "failed to write %zd bytes to Config Spa=
ce",
>>>>                     hdr_sz);
IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
