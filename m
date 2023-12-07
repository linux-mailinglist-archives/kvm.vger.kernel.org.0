Return-Path: <kvm+bounces-3834-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EDF7B8084FD
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 10:54:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7DD341F2276A
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 09:54:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D84835281;
	Thu,  7 Dec 2023 09:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="d7E5Znpa"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2073.outbound.protection.outlook.com [40.107.94.73])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87303FA
	for <kvm@vger.kernel.org>; Thu,  7 Dec 2023 01:54:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KUgaobvb3UsPO9UrF214SAOfLZPOjbwoYGKXt2yiSGYfzs83StOGe+KW74PY4TEbh8aXR/403KVYMDnvlkOERNhmtAvQ5fIVo/4FiHmrIJCbMMQUUldWE4IIw30AoXkQOLDvz50kBiO5hflZP6elgzTN+bAThVrujSwxW9MlnlFo5tziChgx3GhTEauAxXeRuKBlC7YJVxFHO9ajD3J6/Ms+ffUxUDYkcDnqTNWDvIuFnVm8HVl3rEe9fMlP9RlY1YUVsEdnQWZ28GngFhVCj6/Yut3fIYa+kCpYyD+R1xWVC1V7MnnwxChtoPmjILpJWX8UlChaki3CgDNR06/vpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=415FJ1k75/sDsfqaQ4sMuyIwmDNOaBz87uodVST11ec=;
 b=XB9GxJKUOCQlkXOXavpnd66lZty87d4uocmS222LBuYczYToV2E9b3ZotcdU6ksMQiM6bW4jjToTrTYo9I+vtAEMzvCb7qynCawWOp0m7O7G4FWqGAl9SKHD390JjvVHOlR19524rXGqjta+lljlXIXefTGt/FssB9ZfEW8XkqrIFeeKhJkSpwKiQe3aPiqOfhI25gcl9ex6/CcmPTC6X/vtKfne8n2PRoLH9eu8IBNZFzVake+ONraXGkLH59jig3xt6vk5+PrDeGseLQQbj8HDeSIy9PZKJ3VLou6i0BD7dwKwGiCqm4Lbyi5afGMCISCO98+RJMiwoWsRJ3o2oQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=415FJ1k75/sDsfqaQ4sMuyIwmDNOaBz87uodVST11ec=;
 b=d7E5ZnpauVlwm+Y2atZwyWYhSNz6igFQwPNAdcX+rlNCCyfHQvnOhLSSNWI1iTZMEGwRUPx2aoDNFdoIAk/w0OvR4Vn35dSOLCp67FcE97Hn6e+wRmeL/NZUp5ERE9jfsXAkhfGfUgoZE6cCgcYLkstYV811Fuqw5djqiWxaCbf4LKR4Arm9jJ05Md2nFXuzKaBGbUVLZAvkRdvhOmON3ZYseddUpdoJXMnZbHQpLtP9VVzZvrW2R+VpMFS9eJTl+hJZ8kKUlt0OuJyvwownsg5sNgopYusFgojpo9mK4A7/7DGiFdu7e+1YEEzLFPNo/Y+T1jGlmSO3zuKO+Qrn0Q==
Received: from CY5PR13CA0011.namprd13.prod.outlook.com (2603:10b6:930::16) by
 IA1PR12MB7711.namprd12.prod.outlook.com (2603:10b6:208:421::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.25; Thu, 7 Dec
 2023 09:54:42 +0000
Received: from CY4PEPF0000E9D1.namprd03.prod.outlook.com
 (2603:10b6:930:0:cafe::74) by CY5PR13CA0011.outlook.office365.com
 (2603:10b6:930::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.24 via Frontend
 Transport; Thu, 7 Dec 2023 09:54:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CY4PEPF0000E9D1.mail.protection.outlook.com (10.167.241.144) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7068.26 via Frontend Transport; Thu, 7 Dec 2023 09:54:41 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 7 Dec 2023
 01:54:32 -0800
Received: from [172.27.21.229] (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 7 Dec 2023
 01:54:27 -0800
Message-ID: <d8bffec0-80d2-4ec2-99a6-24c99748519f@nvidia.com>
Date: Thu, 7 Dec 2023 11:54:25 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V6 vfio 9/9] vfio/virtio: Introduce a vfio driver over
 virtio devices
Content-Language: en-US
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <jiri@nvidia.com>,
	<kevin.tian@intel.com>, <joao.m.martins@oracle.com>, <si-wei.liu@oracle.com>,
	<leonro@nvidia.com>, <maorg@nvidia.com>
References: <20231206083857.241946-1-yishaih@nvidia.com>
 <20231206083857.241946-10-yishaih@nvidia.com>
 <20231207010939.GG2692119@nvidia.com>
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <20231207010939.GG2692119@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D1:EE_|IA1PR12MB7711:EE_
X-MS-Office365-Filtering-Correlation-Id: 8de6c116-eb07-46de-646f-08dbf70a8893
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	eILz97LKwTKIfvJx7ZV5k/ANqmLlgEcalxeISv8Jy7GUymH4LnsCzGyznXzy1CRLbH3nakvJ16eEyQuXeloANIfECITVWJLlz73tTMT7s3asbkzNlOhaZx+qlev8Pcvtyg2kns8UNXGKTuzkydSgB0mlwpkiIsvyGiLKXzBTmhT2p67Ge03fiKeIGyxxLoy4NN68RY77rVGkdgz0wy10407EUmZLFX1Z/Azsne7W78iaFSoxfvmtmI8jmvzihg0pD/0j77tR3ayl6CpOmrVWhkkt+zEFJ9mDMTUKyq0f3Y4sn6hpWO9Op+TYMpJBFIJZd4E8RC4qCrbRDY9BIFmBaR8zYLV2/G3YjxCEdLPDPkwmSiUaSQ8fiCfLM1Ue/+seYxGkXmf0O6/MNeavsRGju6dGTgZOlhcv/eGqXbqPp5hcziuuoMqLu8uVF37lUn95InSoIa+ILCrs9IzqqYxeg2LWvv+fNsgoiSVUTMN+01fyO7kNnvWrbF0vAotlPv+Dmkrr5lQavSSqaCCW5OaGTU39XElfXv1OmW2FUZ+zojaq8ITzUOOCMuJ9YaRvTRxe+syVfZNblyy80IIkdkR9JpAy1F7Mt7Aqz+YPLMvQRqmTYJ4Urc/XAiWptw/c5h4UC0rouefKR4wcsEVIeDmvK3Bv1UlDiIt8q66Q4iyr2yOtaY1WOOb4cJU9M9mhnCbU7UJg2np0/pK+cxUb8Vj2M9x3nF6RirEvDs7HY4CPit3ocrASsmxVteeUPw3WSXyV+jbsUCpsji+vZG9E69u2aQ==
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(346002)(376002)(396003)(39860400002)(136003)(230922051799003)(451199024)(1800799012)(186009)(64100799003)(82310400011)(46966006)(40470700004)(36840700001)(7636003)(356005)(47076005)(82740400003)(36860700001)(2906002)(31686004)(31696002)(16526019)(26005)(83380400001)(426003)(336012)(40460700003)(40480700001)(86362001)(36756003)(107886003)(2616005)(4326008)(8676002)(8936002)(6862004)(5660300002)(53546011)(41300700001)(478600001)(37006003)(70586007)(70206006)(16576012)(54906003)(6636002)(316002)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2023 09:54:41.5057
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8de6c116-eb07-46de-646f-08dbf70a8893
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9D1.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7711

On 07/12/2023 3:09, Jason Gunthorpe wrote:
> On Wed, Dec 06, 2023 at 10:38:57AM +0200, Yishai Hadas wrote:
>> +static ssize_t
>> +virtiovf_pci_core_read(struct vfio_device *core_vdev, char __user *buf,
>> +		       size_t count, loff_t *ppos)
>> +{
>> +	struct virtiovf_pci_core_device *virtvdev = container_of(
>> +		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
>> +	struct pci_dev *pdev = virtvdev->core_device.pdev;
>> +	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
>> +	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
>> +	int ret;
>> +
>> +	if (!count)
>> +		return 0;
>> +
>> +	if (index == VFIO_PCI_CONFIG_REGION_INDEX)
>> +		return virtiovf_pci_read_config(core_vdev, buf, count, ppos);
>> +
>> +	if (index != VFIO_PCI_BAR0_REGION_INDEX)
>> +		return vfio_pci_core_read(core_vdev, buf, count, ppos);
>> +
>> +	ret = pm_runtime_resume_and_get(&pdev->dev);
>> +	if (ret) {
>> +		pci_info_ratelimited(pdev, "runtime resume failed %d\n",
>> +				     ret);
>> +		return -EIO;
>> +	}
>> +
>> +	ret = translate_io_bar_to_mem_bar(virtvdev, pos, buf, count, true);
>> +	pm_runtime_put(&pdev->dev);
> 
> There is two copies of this pm_runtime sequence, I'd put the
> pm_runtime stuff into translate_io_bar_to_mem_bar() and organize these
> to be more success oriented:

Yes, good idea.

> 
>   if (index == VFIO_PCI_BAR0_REGION_INDEX)
>      return translate_io_bar_to_mem_bar();
>   return vfio_pci_core_read();
> 
>> +static ssize_t
>> +virtiovf_pci_core_write(struct vfio_device *core_vdev, const char __user *buf,
>> +			size_t count, loff_t *ppos)
>> +{
>> +	struct virtiovf_pci_core_device *virtvdev = container_of(
>> +		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
>> +	struct pci_dev *pdev = virtvdev->core_device.pdev;
>> +	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
>> +	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
>> +	int ret;
>> +
>> +	if (!count)
>> +		return 0;
>> +
>> +	if (index == VFIO_PCI_CONFIG_REGION_INDEX) {
>> +		size_t register_offset;
>> +		loff_t copy_offset;
>> +		size_t copy_count;
>> +
>> +		if (range_intersect_range(pos, count, PCI_COMMAND, sizeof(virtvdev->pci_cmd),
>> +					  &copy_offset, &copy_count,
>> +					  &register_offset)) {
>> +			if (copy_from_user((void *)&virtvdev->pci_cmd + register_offset,
>> +					   buf + copy_offset,
>> +					   copy_count))
>> +				return -EFAULT;
>> +		}
>> +
>> +		if (range_intersect_range(pos, count, PCI_BASE_ADDRESS_0,
>> +					  sizeof(virtvdev->pci_base_addr_0),
>> +					  &copy_offset, &copy_count,
>> +					  &register_offset)) {
>> +			if (copy_from_user((void *)&virtvdev->pci_base_addr_0 + register_offset,
>> +					   buf + copy_offset,
>> +					   copy_count))
>> +				return -EFAULT;
>> +		}
>> +	}
>> +
>> +	if (index != VFIO_PCI_BAR0_REGION_INDEX)
>> +		return vfio_pci_core_write(core_vdev, buf, count, ppos);
>> +
>> +	ret = pm_runtime_resume_and_get(&pdev->dev);
>> +	if (ret) {
>> +		pci_info_ratelimited(pdev, "runtime resume failed %d\n", ret);
>> +		return -EIO;
>> +	}
>> +
>> +	ret = translate_io_bar_to_mem_bar(virtvdev, pos, (char __user *)buf, count, false);
>> +	pm_runtime_put(&pdev->dev);
> 
> Same
> 
>> +static const struct vfio_device_ops virtiovf_vfio_pci_tran_ops = {
>> +	.name = "virtio-vfio-pci-trans",
>> +	.init = virtiovf_pci_init_device,
>> +	.release = virtiovf_pci_core_release_dev,
>> +	.open_device = virtiovf_pci_open_device,
>> +	.close_device = vfio_pci_core_close_device,
>> +	.ioctl = virtiovf_vfio_pci_core_ioctl,
>> +	.read = virtiovf_pci_core_read,
>> +	.write = virtiovf_pci_core_write,
>> +	.mmap = vfio_pci_core_mmap,
>> +	.request = vfio_pci_core_request,
>> +	.match = vfio_pci_core_match,
>> +	.bind_iommufd = vfio_iommufd_physical_bind,
>> +	.unbind_iommufd = vfio_iommufd_physical_unbind,
>> +	.attach_ioas = vfio_iommufd_physical_attach_ioas,
> 
> Missing detach_ioas

Sure, will add also 'device_feature' for completeness.

> 
>> +static bool virtiovf_bar0_exists(struct pci_dev *pdev)
>> +{
>> +	struct resource *res = pdev->resource;
>> +
>> +	return res->flags ? true : false;
> 
> ?: isn't necessary cast to bool does this expression automatically

Right
This can just be return res->flags.

> 
> I didn't try to check the virtio parts of this, but the construction
> of the variant driver looks OK, so
> 
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Thanks Jason
I'll add as part of V7.

Yishai

> 
> Jason


