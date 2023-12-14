Return-Path: <kvm+bounces-4520-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F355813623
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 17:26:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 92BA5B21395
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 16:25:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 116745F1FD;
	Thu, 14 Dec 2023 16:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="atERYyz8"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2043.outbound.protection.outlook.com [40.107.94.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CF8511A
	for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 08:25:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xs1FtODUVsYj8dHTo2a59hQcx856Y9+Bcpmn9D6qGDxTz8qJogOGpyZlvENkQFufYTzyWcFMD/TdT2KJ3Rsw3I5NfH7hgX0T3fI+kGR/Pihd5vryOPv3nuOQiDhHk03ZForOW6EvyuY3PsD6obCaosVB4VFFo7H5YpzWQ0/6q97SwWtjH9UNWSecZ8V7opODwgex/XIr6IQZQmkpt/hNNvqWWApXrfdwrc+EHP3ywOqL0P/hH74z+LW4pXXtuRyMMw4PTP8rQ9ttsK/sObHOD/W+mk3nCKQGobGx38hGAGy+k+Ncljxs6IKljAk8rzeZKD0UE9DaqeM1bPIu1h2FBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G7xC1f4P2r4Gog+XhSiHvzjUPw1obfyciA49xfkz8Dw=;
 b=kAorJS62pojoXa3UmlrcTueE3TuHKZl9/O5OnFoo7RMPBkbaoDwZNIZhlfTonEJuZRYP/4VCSf0Uk9lAJmZAuwRnzqzPj2RNBYoneiFrZ6DuqLH9lvxDJbYKPNKCnsJy6yXmEjLDPtgGTEkAadABPIQ76Hh//QCa0wWL8r3OPxAn7UGAruEKM4/gsm42/p7ICVRu2IiUKBlHp4AVCjJqM6rJugaijr6lAjOWNFbl78DLR4XsKcdhbxihqT8rhKUpwVXwYl2FFp3piBEHvdtaevIpbGInASgEbuggVNvJkrJCgIozVc1rhlsbIgKcJFsgBOsZXiEPHfUVkP1crxzPnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G7xC1f4P2r4Gog+XhSiHvzjUPw1obfyciA49xfkz8Dw=;
 b=atERYyz8GSk90+opRwS7k22TjfNR64SYrjIX/WIJ+v6bPJKUUtRI3DJFd163hW98xVzTtMM1rP03SKIQb1Qm6hfOUmWHod++qt4a06pQIk+xKYB0B6AUJfvftoEq95EkgxaQqBwh2Knwlog7sOKkdcfeRRZ4YB/b+3g7we3miHKZXstUy79jh0RiPAoOHOaQ6tpgaALvdndyQ+ZtJ0nHXuwj+yKLmfrNZrc5m4/K/j/YhWuVL63+bbBH5fb0tZK6MsLBdzdY/1U5TQ2IU98YK5H/zh2J3t2ohAZb+cvswjVKLK6hj/CQ8C9fUMchLlQAeij3iRoUsO+FLeF3SzzYsw==
Received: from CH2PR02CA0022.namprd02.prod.outlook.com (2603:10b6:610:4e::32)
 by SN7PR12MB7322.namprd12.prod.outlook.com (2603:10b6:806:299::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.28; Thu, 14 Dec
 2023 16:25:43 +0000
Received: from DS2PEPF0000343B.namprd02.prod.outlook.com
 (2603:10b6:610:4e:cafe::62) by CH2PR02CA0022.outlook.office365.com
 (2603:10b6:610:4e::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.26 via Frontend
 Transport; Thu, 14 Dec 2023 16:25:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS2PEPF0000343B.mail.protection.outlook.com (10.167.18.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7091.26 via Frontend Transport; Thu, 14 Dec 2023 16:25:42 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 14 Dec
 2023 08:25:31 -0800
Received: from [172.27.58.65] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 14 Dec
 2023 08:25:27 -0800
Message-ID: <c838ad5a-e6ba-4b8e-a9a2-5d43da0ba5a4@nvidia.com>
Date: Thu, 14 Dec 2023 18:25:25 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V7 vfio 9/9] vfio/virtio: Introduce a vfio driver over
 virtio devices
Content-Language: en-US
To: Alex Williamson <alex.williamson@redhat.com>, "Michael S. Tsirkin"
	<mst@redhat.com>
CC: <jasowang@redhat.com>, <jgg@nvidia.com>, <kvm@vger.kernel.org>,
	<virtualization@lists.linux-foundation.org>, <parav@nvidia.com>,
	<feliu@nvidia.com>, <jiri@nvidia.com>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>, <leonro@nvidia.com>,
	<maorg@nvidia.com>
References: <20231207102820.74820-1-yishaih@nvidia.com>
 <20231207102820.74820-10-yishaih@nvidia.com>
 <20231214013642-mutt-send-email-mst@kernel.org>
 <ea0cdfc9-35f4-4cc1-b0de-aaef0bebeb51@nvidia.com>
 <20231214041515-mutt-send-email-mst@kernel.org>
 <37bcb2f0-a83d-4806-809c-ec5d004ddb20@nvidia.com>
 <20231214075905.59a4a3ba.alex.williamson@redhat.com>
 <20231214100403-mutt-send-email-mst@kernel.org>
 <5b596e34-aac9-4786-8f13-4d85986803f0@nvidia.com>
 <20231214091501.4f843335.alex.williamson@redhat.com>
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20231214091501.4f843335.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343B:EE_|SN7PR12MB7322:EE_
X-MS-Office365-Filtering-Correlation-Id: be228f11-df1b-449b-ce00-08dbfcc1519d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	V+g1rZ3on9wq8njNE46f/YNYThQooCVDbsTEBd8DbaySaBaaOWCvLrqzS0L//z1DzxNP5jThxi3ou5hauUTt7W6laKSiAsDb980WbMfYM1poEPSj3pb9RKpHTmIiCWvLePzKHrkRzrJmC9Y06WFZ7p59QXK5Gl0yTaAsq4MKKDCjdcoK5rohewoZqO2PaEoSEtFpIfz8+Rzkz29bY2Fs5h2U0x9AS8+nsbWiz4IAzf3oemjuvJNkLYD2JzpvaKCxmvNaXPlyWidigg8PECIw9jBqaPKanWgnmwERNgkEXjnMnLeslmr3GVEIN70aFHPxqst7jQAPXySkmi2bwnLaDi2buZZdJKHTjTyNIx80RJsenHVNnnleekdFkzPetaQ6LMQZ/JaTGuhnY2WKiD3ZvnPSKMRFFCBdH5714k6zeXzZx42aydXRvab0XoZh0eWi7fMLOqblls3ZHlGcuTtc9I8CVUE8CujDKtxzCdNUNL36X0TuPbB4wrLOVbbcnkDJTkS0UO2FLLYn1/v8cEX0ZHXJ3NA8PjJ7jHB3QZtBXN3ijAwXtsIj02bdZ7IKJa6/gJk50wzntAtmj/hKn5QFGeisRaMb6TVRHRsyMQ9sQ0N8SwnzvIq6KgywrqTRGkivFZQGlE9Q8/kdfaDXlM9LejBAm4DhPoEREmfoJzvzSbOJc9EPfkqLmvCaRmit6D/xid4QD7E1TZhkwoV5hI+CEPCuxEeYZ1ybw3ipammn8o1BBBeDeJbaeEE7sgxUI5suTN5pzi2ADpV6uqOydJCqOA==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(376002)(39860400002)(136003)(346002)(230922051799003)(186009)(451199024)(82310400011)(64100799003)(1800799012)(36840700001)(40470700004)(46966006)(31696002)(40480700001)(5660300002)(316002)(110136005)(40460700003)(53546011)(31686004)(2906002)(4326008)(8676002)(8936002)(86362001)(70586007)(16576012)(54906003)(7636003)(70206006)(478600001)(41300700001)(36756003)(2616005)(336012)(426003)(26005)(82740400003)(107886003)(66899024)(356005)(83380400001)(47076005)(36860700001)(16526019)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2023 16:25:42.9678
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: be228f11-df1b-449b-ce00-08dbfcc1519d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7322

On 14/12/2023 18:15, Alex Williamson wrote:
> On Thu, 14 Dec 2023 18:03:30 +0200
> Yishai Hadas <yishaih@nvidia.com> wrote:
> 
>> On 14/12/2023 17:05, Michael S. Tsirkin wrote:
>>> On Thu, Dec 14, 2023 at 07:59:05AM -0700, Alex Williamson wrote:
>>>> On Thu, 14 Dec 2023 11:37:10 +0200
>>>> Yishai Hadas <yishaih@nvidia.com> wrote:
>>>>>>> OK, if so, we can come with the below extra code.
>>>>>>> Makes sense ?
>>>>>>>
>>>>>>> I'll squash it as part of V8 to the relevant patch.
>>>>>>>
>>>>>>> diff --git a/drivers/virtio/virtio_pci_modern.c
>>>>>>> b/drivers/virtio/virtio_pci_modern.c
>>>>>>> index 37a0035f8381..b652e91b9df4 100644
>>>>>>> --- a/drivers/virtio/virtio_pci_modern.c
>>>>>>> +++ b/drivers/virtio/virtio_pci_modern.c
>>>>>>> @@ -794,6 +794,9 @@ bool virtio_pci_admin_has_legacy_io(struct pci_dev
>>>>>>> *pdev)
>>>>>>>            struct virtio_device *virtio_dev = virtio_pci_vf_get_pf_dev(pdev);
>>>>>>>            struct virtio_pci_device *vp_dev;
>>>>>>>
>>>>>>> +#ifndef CONFIG_X86
>>>>>>> +       return false;
>>>>>>> +#endif
>>>>>>>            if (!virtio_dev)
>>>>>>>                    return false;
>>>>>>>
>>>>>>> Yishai
>>>>>>
>>>>>> Isn't there going to be a bunch more dead code that compiler won't be
>>>>>> able to elide?
>>>>>>       
>>>>>
>>>>> On my setup the compiler didn't complain about dead-code (I simulated it
>>>>> by using ifdef CONFIG_X86 return false).
>>>>>
>>>>> However, if we suspect that some compiler might complain, we can come
>>>>> with the below instead.
>>>>>
>>>>> Do you prefer that ?
>>>>>
>>>>> index 37a0035f8381..53e29824d404 100644
>>>>> --- a/drivers/virtio/virtio_pci_modern.c
>>>>> +++ b/drivers/virtio/virtio_pci_modern.c
>>>>> @@ -782,6 +782,7 @@ static void vp_modern_destroy_avq(struct
>>>>> virtio_device *vdev)
>>>>>             BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_READ) | \
>>>>>             BIT_ULL(VIRTIO_ADMIN_CMD_LEGACY_NOTIFY_INFO))
>>>>>
>>>>> +#ifdef CONFIG_X86
>>>>>     /*
>>>>>      * virtio_pci_admin_has_legacy_io - Checks whether the legacy IO
>>>>>      * commands are supported
>>>>> @@ -807,6 +808,12 @@ bool virtio_pci_admin_has_legacy_io(struct pci_dev
>>>>> *pdev)
>>>>>                    return true;
>>>>>            return false;
>>>>>     }
>>>>> +#else
>>>>> +bool virtio_pci_admin_has_legacy_io(struct pci_dev *pdev)
>>>>> +{
>>>>> +       return false;
>>>>> +}
>>>>> +#endif
>>>>>     EXPORT_SYMBOL_GPL(virtio_pci_admin_has_legacy_io);
>>>>
>>>> Doesn't this also raise the question of the purpose of virtio-vfio-pci
>>>> on non-x86?  Without any other features it offers nothing over vfio-pci
>>>> and we should likely adjust the Kconfig for x86 or COMPILE_TEST.
>>>> Thanks,
>>>>
>>>> Alex
>>>
>>> Kconfig dependency is what I had in mind, yes. The X86 specific code in
>>> virtio_pci_modern.c can be moved to a separate file then use makefile
>>> tricks to skip it on other platforms.
>>>    
>>
>> The next feature for that driver will be the live migration support over
>> virtio, once the specification which is WIP those day will be accepted.
>>
>> The migration functionality is not X86 dependent and doesn't have the
>> legacy virtio driver limitations that enforced us to run only on X86.
>>
>> So, by that time we may need to enable in VFIO the loading of
>> virtio-vfio-pci driver and put back the ifdef X86 inside VIRTIO, only on
>> the legacy IO API, as I did already in V8.
>>
>> So using a KCONFIG solution in VFIO is a short term one, which will be
>> reverted just later on.
> 
> I understand the intent, but I don't think that justifies building a
> driver that serves no purpose in the interim.  IF and when migration
> support becomes a reality, it's trivial to update the depends line.
> 

OK, so I'll add a KCONFIG dependency on X86 as you suggested as part of 
V9 inside VFIO.

>> In addition, the virtio_pci_admin_has_legacy_io() API can be used in the
>> future not only by VFIO, this was one of the reasons to put it inside
>> VIRTIO.
> 
> Maybe this should be governed by a new Kconfig option which would be
> selected by drivers like this.  Thanks,
> 

We can still keep the simple ifdef X86 inside VIRTIO for future 
users/usage which is not only VFIO.

Michael,
Can that work for you ?

Yishai

> Alex
> 


