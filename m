Return-Path: <kvm+bounces-3269-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EEF2480246B
	for <lists+kvm@lfdr.de>; Sun,  3 Dec 2023 15:14:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7DD3CB20A33
	for <lists+kvm@lfdr.de>; Sun,  3 Dec 2023 14:14:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FCF414A8B;
	Sun,  3 Dec 2023 14:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="PDfnCoQf"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2078.outbound.protection.outlook.com [40.107.92.78])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 736CFFD
	for <kvm@vger.kernel.org>; Sun,  3 Dec 2023 06:14:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SKcHNk27fRRRF1v+luh2/QvUmclgx7WoXFm7WhB9AFzZg07wiguLrgPdFL9MiT9YQd4qnrh3YSICdovMurCd2Ey4t3CeFq80WqvnG4Q407HDOH3SoHXyq+A3prYELBcdVUcLaqkUqzlQska0fg9TIP+4ppVb6EFD6ezSq3TCGZ19pJgwB44IFJIs8/rfT1RFT3/AxPBrp91fvhIzxh4y5Ahyeps1uvvHh7RZlgFf5MAzGF/7sTAjmpMWxzU1zxAA1VaqErutrC/2HW0lpvVtno5aoXnonKa3Lg2I65Vhl/jFCPvqcFK96lIh4gH4bg/127gk0nWCykVLH9TTEe8sxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z57a1RPrGAXeCULu9WjXF2e1BwLscT4E3hJ4y8rwL7M=;
 b=HM8N62BQu5dVioM74MAxMykr/J2y2bejns4+YGxN4PnkLnuXgFVIbywCMejurr5Xszoys99QuutT/JjRu6tDMb7mF8RVOJwYW9fvJtcbAc96bXHxOywkWNFypOfQtDn2r374gv2a+/b+iLmwkvHR5sB1Q3SC+3mCPdgsIC5OpNgElOUp9fJ8vCPTL1xjJQ+GQdLwCSBOiTgWvtk3IB6DEDoMH5x6Nste8ieCrnSQDpUBtGh7GgBL/czU2IhmfRCFw+JAZHYnexzdnGf/ybZoAAYZhWXplxotibaWKKmZs5w2rSYe7GxeaDy0o8k9PXxp+uTmKSY3P7Uk/kCwC9Tztg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z57a1RPrGAXeCULu9WjXF2e1BwLscT4E3hJ4y8rwL7M=;
 b=PDfnCoQfzqVz9KwjO2DsbFF3i+DOXr1mbh3glkL+OxPwINPHkmOED0uZRJfFO+L/bBnuQQWLUG5U9PRrvncFcpVIWxWrHZeZVaAllRx8Uyp++AuoMiJlXOVtd41UtPBxKdeh7tHFvkw0oU4DyhRBuJ6y2ueDsNeOV2JCeJS4kn05hNCUu0Xd/HiMDtaRb0AR8aiNTiZEW/FxDRGwkB9NIB4MLuBEeukrSGNRj9keQoz9KPy+xlt/AjEiEr8cW3MsGZhkvfXCndSbwpPPMxWff+7nyAqDKFdUv7dJufTw46VpL41Ju4gqSbF4bFP3vOsJS/j1SqPCbw9EhnP1smiYRQ==
Received: from DM6PR05CA0065.namprd05.prod.outlook.com (2603:10b6:5:335::34)
 by DM6PR12MB4481.namprd12.prod.outlook.com (2603:10b6:5:2af::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.33; Sun, 3 Dec
 2023 14:14:26 +0000
Received: from DS2PEPF00003441.namprd04.prod.outlook.com
 (2603:10b6:5:335:cafe::f7) by DM6PR05CA0065.outlook.office365.com
 (2603:10b6:5:335::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.22 via Frontend
 Transport; Sun, 3 Dec 2023 14:14:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS2PEPF00003441.mail.protection.outlook.com (10.167.17.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7068.20 via Frontend Transport; Sun, 3 Dec 2023 14:14:26 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Sun, 3 Dec 2023
 06:14:22 -0800
Received: from [172.27.21.98] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Sun, 3 Dec 2023
 06:14:18 -0800
Message-ID: <13c56c54-50ff-4894-833a-6c75ca604399@nvidia.com>
Date: Sun, 3 Dec 2023 16:14:15 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4 vfio 8/9] vfio/pci: Expose
 vfio_pci_iowrite/read##size()
Content-Language: en-US
To: Alex Williamson <alex.williamson@redhat.com>
CC: <mst@redhat.com>, <jasowang@redhat.com>, <jgg@nvidia.com>,
	<kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
	<kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
	<leonro@nvidia.com>, <maorg@nvidia.com>
References: <20231129143746.6153-1-yishaih@nvidia.com>
 <20231129143746.6153-9-yishaih@nvidia.com>
 <20231130122010.3563bdee.alex.williamson@redhat.com>
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20231130122010.3563bdee.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF00003441:EE_|DM6PR12MB4481:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c035b65-05a9-4d59-b343-08dbf40a2863
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	2Xt1qOt33nkMlWpCsID51p0nlz2LY0tkUixkytC46Rd1pZUJTqzSKPI5KJEa5PABrywxJ7YlXHu+RPgvHxKjJ3MTnDMz9aJCsh90y6g9TUmXA1pcCSGN+Q0UErXBngZ0AOJ28K4TxAT9HeQB0OrzYDv7fAryDDiFQZnrKpIk2YnINpJtyDhsH4IjfKozc2S1QsAlnKS+4dkF4UVIMESdFPwhzqszs5aUs5K+ADAlFD09AEXjNKkMV8U+W4T4mGq49f9QiYuQV57jQl6yaBHTlSeFd14w4XcSdMYTu2gmfANnk+qdYe6bNw8SeVLJb/x0zoJjwFReJCe89vuXlRRkAJuseK6jcRRWOmV9O2hOCumx+B+eySW08Q8UuohzkXE1wxgVEHbrJqdpTWWbdIYiZsto4e68J9d8hVkiOCuYBPYTMgi0WmfBYLwx/GoOq/XoK6/YRveaR++5G61zshjqTnm7FT/klRHmy6D+d21FZyx835wsax03R9ae8wEDUSnLa+m7CxcUt7T/tnx7hq88Gevs7upgiHUy+LDtKzkFuy6BsAYcnBgU5fdDDdJuB9Ecvt3ZmlLaGV37RbX23AmfmyRKEvlcRlh+NZ/UBaKJrqaAl1yPsZG3ZOKTcj/DF0Han/AtTWsL5rRlcBJttrQhVRadnnJx9wh7HHpiNvH/ljBSx/uXGP5tGVA3Iwc3kCxWQU23nrHu2GCd8apyhp0ISXm74sIvE3vhBZEe/43yTQ3bzIJR32mMRV6yH/77h2/yUYPOpUeu3TzzymMIAz1OO29z/4vcqC4+mmENz5qE6PU=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(376002)(136003)(396003)(39860400002)(346002)(230922051799003)(451199024)(186009)(82310400011)(64100799003)(1800799012)(40470700004)(46966006)(36840700001)(107886003)(31686004)(2616005)(8936002)(8676002)(4326008)(53546011)(47076005)(40480700001)(7636003)(356005)(83380400001)(36860700001)(426003)(336012)(82740400003)(16526019)(26005)(478600001)(40460700003)(6666004)(54906003)(70206006)(70586007)(316002)(6916009)(16576012)(2906002)(41300700001)(36756003)(86362001)(31696002)(5660300002)(21314003)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2023 14:14:26.6123
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c035b65-05a9-4d59-b343-08dbf40a2863
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF00003441.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4481

On 30/11/2023 21:20, Alex Williamson wrote:
> On Wed, 29 Nov 2023 16:37:45 +0200
> Yishai Hadas <yishaih@nvidia.com> wrote:
> 
>> Expose vfio_pci_iowrite/read##size() to let it be used by drivers.
>>
>> This functionality is needed to enable direct access to some physical
>> BAR of the device with the proper locks/checks in place.
>>
>> The next patches from this series will use this functionality on a data
>> path flow when a direct access to the BAR is needed.
>>
>> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
>> ---
>>   drivers/vfio/pci/vfio_pci_rdwr.c | 10 ++++++----
>>   include/linux/vfio_pci_core.h    | 19 +++++++++++++++++++
>>   2 files changed, 25 insertions(+), 4 deletions(-)
> 
> I don't follow the inconsistency between this and the previous patch.
> Why did we move and rename the code to setup the barmap but we export
> the ioread/write functions in place?  Thanks,
> 
> Alex

The mount of code for barmap setup was quite small compared to the 
ioread/write functions.

However, I agree, we can be consistent here and export in both cases the 
functions in place as part of vfio_pci_rdwr.c which is already part of 
vfio_pci_core.ko

I may also rename in current patch vfio_pci_iowrite/read<xxx> to have 
the 'core' prefix as part of the functions names (i.e. 
vfio_pci_core_iowrite/read<xxx>) to be consistent with other exported 
core functions and adapt the callers to this name.

Makes sense ?

Yishai

> 
> 
>> diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
>> index 6f08b3ecbb89..817ec9a89123 100644
>> --- a/drivers/vfio/pci/vfio_pci_rdwr.c
>> +++ b/drivers/vfio/pci/vfio_pci_rdwr.c
>> @@ -38,7 +38,7 @@
>>   #define vfio_iowrite8	iowrite8
>>   
>>   #define VFIO_IOWRITE(size) \
>> -static int vfio_pci_iowrite##size(struct vfio_pci_core_device *vdev,		\
>> +int vfio_pci_iowrite##size(struct vfio_pci_core_device *vdev,		\
>>   			bool test_mem, u##size val, void __iomem *io)	\
>>   {									\
>>   	if (test_mem) {							\
>> @@ -55,7 +55,8 @@ static int vfio_pci_iowrite##size(struct vfio_pci_core_device *vdev,		\
>>   		up_read(&vdev->memory_lock);				\
>>   									\
>>   	return 0;							\
>> -}
>> +}									\
>> +EXPORT_SYMBOL_GPL(vfio_pci_iowrite##size);
>>   
>>   VFIO_IOWRITE(8)
>>   VFIO_IOWRITE(16)
>> @@ -65,7 +66,7 @@ VFIO_IOWRITE(64)
>>   #endif
>>   
>>   #define VFIO_IOREAD(size) \
>> -static int vfio_pci_ioread##size(struct vfio_pci_core_device *vdev,		\
>> +int vfio_pci_ioread##size(struct vfio_pci_core_device *vdev,		\
>>   			bool test_mem, u##size *val, void __iomem *io)	\
>>   {									\
>>   	if (test_mem) {							\
>> @@ -82,7 +83,8 @@ static int vfio_pci_ioread##size(struct vfio_pci_core_device *vdev,		\
>>   		up_read(&vdev->memory_lock);				\
>>   									\
>>   	return 0;							\
>> -}
>> +}									\
>> +EXPORT_SYMBOL_GPL(vfio_pci_ioread##size);
>>   
>>   VFIO_IOREAD(8)
>>   VFIO_IOREAD(16)
>> diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
>> index 67ac58e20e1d..22c915317788 100644
>> --- a/include/linux/vfio_pci_core.h
>> +++ b/include/linux/vfio_pci_core.h
>> @@ -131,4 +131,23 @@ int vfio_pci_core_setup_barmap(struct vfio_pci_core_device *vdev, int bar);
>>   pci_ers_result_t vfio_pci_core_aer_err_detected(struct pci_dev *pdev,
>>   						pci_channel_state_t state);
>>   
>> +#define VFIO_IOWRITE_DECLATION(size) \
>> +int vfio_pci_iowrite##size(struct vfio_pci_core_device *vdev,		\
>> +			bool test_mem, u##size val, void __iomem *io);
>> +
>> +VFIO_IOWRITE_DECLATION(8)
>> +VFIO_IOWRITE_DECLATION(16)
>> +VFIO_IOWRITE_DECLATION(32)
>> +#ifdef iowrite64
>> +VFIO_IOWRITE_DECLATION(64)
>> +#endif
>> +
>> +#define VFIO_IOREAD_DECLATION(size) \
>> +int vfio_pci_ioread##size(struct vfio_pci_core_device *vdev,		\
>> +			bool test_mem, u##size *val, void __iomem *io);
>> +
>> +VFIO_IOREAD_DECLATION(8)
>> +VFIO_IOREAD_DECLATION(16)
>> +VFIO_IOREAD_DECLATION(32)
>> +
>>   #endif /* VFIO_PCI_CORE_H */
> 


