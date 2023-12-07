Return-Path: <kvm+bounces-3787-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CE4F5807D9C
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 02:09:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 29F842820C8
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 01:09:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCCAAEA9;
	Thu,  7 Dec 2023 01:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="V1ihK8kY"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2062.outbound.protection.outlook.com [40.107.94.62])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B3C5A4
	for <kvm@vger.kernel.org>; Wed,  6 Dec 2023 17:09:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Respiq18PS0TJsjn54Fno0q651+cjaLnZUduxjxXg0L2gdaxsYWHtK2obyaJiap9AoBUhTH0eYUp9RIRVCPRsJY9B+k6VHAO3jA9EJevGWl35nixcHEhPf1UwAxt5yudOecjxwJoEAMVwu1gZcgepddX7XtbI0Ub0jS3U+gd0B4oM2d2CjRj2o/JSgOX9Axp33tjebdseoymEv+OKO/NE8c6QeLQO9lDzMaJeGejffGaKPjjTa7nIWqYrlTbUtbAI51BD8FvfgoHPZagJ8ASlVZ6pT2oerFl78ES12uaGRadSuFUySvqN4nYAU4GazLOG1iXxLdTAhkaIn0UEn/93g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EeDODDc5Pjdmtih3PSF858VrFKf5j9aPqdn/DUCyT9w=;
 b=MJGnzmzgViN/j3bA+tZSkEO/MFlXObUXZBdg0X0UOFEhog3btfYHPQS+xK20On6awMI61Pvj7CkTVbbHg4y+tvYoZjvBs66pgk1Sno6IT499bqBIb0i8gWeRwbiLQP0uM1JM6m/v5F+W8Xw7Iiaoh8DBgTxzyC+OflXi0ae1E4Gd4wVUDpUBVuXReaR+mySzAAoPJkpTFQoTkQD3Ck5P8JyOE2lZ+q3VxUrcA7Pk3RwRjioW++irc04WkTpShuGuyaS7TWc4K/RuL6q9U6yZFoFmWOJfud/pUduh5GtsEcEhrUVY8CMVOGEaaJ31o02rsqVvHhdUR0zMudizAZOpRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EeDODDc5Pjdmtih3PSF858VrFKf5j9aPqdn/DUCyT9w=;
 b=V1ihK8kYsnQ5sp5aU4a5QwUanFj5oAJQBe7Yy36q2mDjQJw1Yicy22H3KbuiIKM1J6O9qczDlPV5bmv9azXN52CGaxWrauj26q3qji51u863MK617gRDfx7LzweIQCfxWx9cF8BfXktJbJlIXyRYaYfIlznIPxZwTVQklJJ4bVKR2VyVv247lA0v/7i93bQZUGk5gUzIYTWGK4vv6XHEj4CudBS2+mkk37naA+N9VkQf1bYXWT4FJ10j87SQ0w3oYAcoonxchOJGiLm/Vyz8Iqd6uK4A8qTDxKw9hyhwXgo2W1zOsObgrMae/Lvus0qJYe1z7L6Ggk5ksCZkwhaOGw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MW6PR12MB8833.namprd12.prod.outlook.com (2603:10b6:303:23f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.25; Thu, 7 Dec
 2023 01:09:40 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.034; Thu, 7 Dec 2023
 01:09:40 +0000
Date: Wed, 6 Dec 2023 21:09:39 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yishai Hadas <yishaih@nvidia.com>
Cc: alex.williamson@redhat.com, mst@redhat.com, jasowang@redhat.com,
	kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
	parav@nvidia.com, feliu@nvidia.com, jiri@nvidia.com,
	kevin.tian@intel.com, joao.m.martins@oracle.com,
	si-wei.liu@oracle.com, leonro@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V6 vfio 9/9] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20231207010939.GG2692119@nvidia.com>
References: <20231206083857.241946-1-yishaih@nvidia.com>
 <20231206083857.241946-10-yishaih@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231206083857.241946-10-yishaih@nvidia.com>
X-ClientProxiedBy: BL1PR13CA0208.namprd13.prod.outlook.com
 (2603:10b6:208:2be::33) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MW6PR12MB8833:EE_
X-MS-Office365-Filtering-Correlation-Id: 628ec67f-6a60-4c67-5939-08dbf6c1306c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	P3hPeN4mn0XsG085A/nf0TICKt0vhlArO0XVXDZ5N7Paufjls7LXMzvKbAgQAtNZKe+GW/CxnFP7s0POnl5pC4vO5j5Bc4LAuNdBa8/i6PV4hDVPARCB+PiWoOll879G+Pa99KnZuGoH0zFxfHX19WDUi7Lle1x1z91O9BUvg88AsmHVf5RRkf4hGL7TqZ+kfwvW6nKSaCNbYhydDNFzjQaOLXMC3j9iRkl6LPso1Uim1hI1vO2kOegBZWXuc3S8dnVgaMmFj3asL/VaR8c2szn/J4Q0zoF7glWFahy8IjFSuTiuZuur0Vv/DQVILaZzLGQS8IeVDNKam321DRqFXByMFF/c7uXZgGrpnGZY5o6wUdbtbljNr7B9lGSTZI0nCtwi7mIXhVPEdoZ2RaXVkgdt69ffKUwHMzprBbbKzbRo0fEG9t9Y4N+lSvnC+k5GfzAvmGdmT7U3llE6VBpMDXdBGpXN0hF3Nf/6zWCv4mPrLEbSthOsGq4gURAcryROJvCVSyXQcez+dLIAh6gvc2eJtFnLOER/lGRe8ZPFC3ViUXx4yXkTHaAHXO6PzJzn
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(396003)(136003)(366004)(39860400002)(376002)(230922051799003)(186009)(1800799012)(451199024)(64100799003)(2616005)(6862004)(8676002)(8936002)(4326008)(6512007)(41300700001)(6506007)(36756003)(5660300002)(1076003)(316002)(107886003)(478600001)(86362001)(33656002)(37006003)(6486002)(38100700002)(26005)(66556008)(6636002)(66476007)(66946007)(2906002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sN2OJAurOIc6YWt2oZQ6RjK/z5bIXV6ewZZkFxYCfOROE8TEzCks7pY4nUWk?=
 =?us-ascii?Q?pKp3Q4UXbXzON4pfEdBVc0HPqFIHRxyKJ3YFNr0kkfPs13KC1u3ClSG6sRbn?=
 =?us-ascii?Q?HVbd5qaoXq7VcVsRD/x5QakNmrbcTlAaO+EsfmV7Yh2rR6AI6N2z0LCYTFvu?=
 =?us-ascii?Q?c4RZyScEFKdh5n8iLnSXPovx8q5VplF0C13ojwmk7Ht3eokZblzBDGExalw4?=
 =?us-ascii?Q?+v1UlhcGmCWEzaJKnGNr+1kr9XVBrID0aYQ58OI9qVq73aqS1Rmtel/g0S5B?=
 =?us-ascii?Q?gy85x2knfqx+SlAwKigzpJJ5aJ1lJTpvXSOcA/nXoWq7C2V4olTKDARqTV4B?=
 =?us-ascii?Q?eVTI64pAChxYgBbLW7CibKzC79nHSRo2yD4GLfKZTq2jBnjZJhbonODqse1G?=
 =?us-ascii?Q?ihjQ5ddfrbccnEFltG3K8XCWwfVE4QA6yQV+5P5u4mYVY6iBJpg8HOPjeOao?=
 =?us-ascii?Q?VJSfmi99N/1Bn3Io/h10C/Sc+RPyS/5rbRjsJ+9w/mVIkpMus5sF4mbP7qC8?=
 =?us-ascii?Q?FKsYrqhdnscRKCl1ATdFfXeEYpjZciJP2o3/KTX855BAX9klYPIeb0N/8OTF?=
 =?us-ascii?Q?7kybTf4Nit1afEYK1M47wcvKl2fJjk+TKMCy3GvXjMkTL/UnqDetLSmXMpYW?=
 =?us-ascii?Q?Qn5HMZ04cF8q9MVQlisskXpeUUdQCR2A6PUWPdSuUJsOz3NNv+s5ChyPtrSA?=
 =?us-ascii?Q?p5kSl3AokBQo7kXpDKAIMTrJguFQWsPGjzGZDQIwVtRjOE52V+bAJ7zrrsBv?=
 =?us-ascii?Q?j/59q1ZrglG4NusA2bxwYA+id7GBxFclZbB2oRbTliyJ8bOp8CilL09n10e8?=
 =?us-ascii?Q?9IAFV5k55VSRCnXaBVl+qa/GV6/Rplfffnl1JNBpZQBi2JPTADy0UJ4mgA2p?=
 =?us-ascii?Q?tfeE3sLMump43ryBTt2yE8X697NiWpgHBFCf8XKNg+KxApM1cvJQD6hguCgW?=
 =?us-ascii?Q?alXQcIhViJnmjDnv0BKj5ElLUQWah7XCAe1icKG/1ieXKGeEtulB/BqGg8sn?=
 =?us-ascii?Q?raE4EpVh7lUVJO1uik0d7liSBgmCqH5/441SD/xcf/aVSdcvK7Hmn8GuSs4S?=
 =?us-ascii?Q?/AASVylsvimTMIigxuDacPOePiREjyyfZzN2o8BrGBz5tzlDOy1TQJWip3n2?=
 =?us-ascii?Q?917biO13xzZlcZOdIzHKv5cDme8rJxtp9lI1ohnluXZPbLkslKxJ6+v+261e?=
 =?us-ascii?Q?Ln6zgtTArBpM9n/p4tV8vxMuAbnSE9gheb1U+Qft9OFra7lZEwjOrUcdjgtD?=
 =?us-ascii?Q?4NT94JAnOxZsEeQKay6llh3yRZkoH+5D+hfY1gdLFiP2+LmaFB2KM6fJtRoK?=
 =?us-ascii?Q?7m3YhwH7dcMyvjPP8QIIycZ+5maNGL3LWxHmVNgtHE3GXcyroBG0lT9SJu03?=
 =?us-ascii?Q?7eMeVHuUVgn/6c/BWy8lBN0SkoMKMK0DFCajhHIfQQvR0sEVHr+2zbgdwPyx?=
 =?us-ascii?Q?8sS2h3hxV70eL+2M3+6i1dEaD3oNRsW5TJ5YJzQb5B4GV+8dMMJ+rDkcm5d1?=
 =?us-ascii?Q?j46YxVVE/llm/xBQe3r3jc5/o56cGTIeJVtEQ/P4QBfEyA3oPPlO0lhxX6Z+?=
 =?us-ascii?Q?sMkUBmNAXczIaZpV+M/nJu5mJHHGsA9nEvnrOzhD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 628ec67f-6a60-4c67-5939-08dbf6c1306c
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2023 01:09:40.5788
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T5hz3/70dADJPjvxGDIwDrBqGGMX/Ld1bYu8qaQr8QWyDWt5GRoxVZMmr/QG4rRA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8833

On Wed, Dec 06, 2023 at 10:38:57AM +0200, Yishai Hadas wrote:
> +static ssize_t
> +virtiovf_pci_core_read(struct vfio_device *core_vdev, char __user *buf,
> +		       size_t count, loff_t *ppos)
> +{
> +	struct virtiovf_pci_core_device *virtvdev = container_of(
> +		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
> +	struct pci_dev *pdev = virtvdev->core_device.pdev;
> +	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
> +	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
> +	int ret;
> +
> +	if (!count)
> +		return 0;
> +
> +	if (index == VFIO_PCI_CONFIG_REGION_INDEX)
> +		return virtiovf_pci_read_config(core_vdev, buf, count, ppos);
> +
> +	if (index != VFIO_PCI_BAR0_REGION_INDEX)
> +		return vfio_pci_core_read(core_vdev, buf, count, ppos);
> +
> +	ret = pm_runtime_resume_and_get(&pdev->dev);
> +	if (ret) {
> +		pci_info_ratelimited(pdev, "runtime resume failed %d\n",
> +				     ret);
> +		return -EIO;
> +	}
> +
> +	ret = translate_io_bar_to_mem_bar(virtvdev, pos, buf, count, true);
> +	pm_runtime_put(&pdev->dev);

There is two copies of this pm_runtime sequence, I'd put the
pm_runtime stuff into translate_io_bar_to_mem_bar() and organize these
to be more success oriented:

 if (index == VFIO_PCI_BAR0_REGION_INDEX)
    return translate_io_bar_to_mem_bar();
 return vfio_pci_core_read();

> +static ssize_t
> +virtiovf_pci_core_write(struct vfio_device *core_vdev, const char __user *buf,
> +			size_t count, loff_t *ppos)
> +{
> +	struct virtiovf_pci_core_device *virtvdev = container_of(
> +		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
> +	struct pci_dev *pdev = virtvdev->core_device.pdev;
> +	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
> +	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
> +	int ret;
> +
> +	if (!count)
> +		return 0;
> +
> +	if (index == VFIO_PCI_CONFIG_REGION_INDEX) {
> +		size_t register_offset;
> +		loff_t copy_offset;
> +		size_t copy_count;
> +
> +		if (range_intersect_range(pos, count, PCI_COMMAND, sizeof(virtvdev->pci_cmd),
> +					  &copy_offset, &copy_count,
> +					  &register_offset)) {
> +			if (copy_from_user((void *)&virtvdev->pci_cmd + register_offset,
> +					   buf + copy_offset,
> +					   copy_count))
> +				return -EFAULT;
> +		}
> +
> +		if (range_intersect_range(pos, count, PCI_BASE_ADDRESS_0,
> +					  sizeof(virtvdev->pci_base_addr_0),
> +					  &copy_offset, &copy_count,
> +					  &register_offset)) {
> +			if (copy_from_user((void *)&virtvdev->pci_base_addr_0 + register_offset,
> +					   buf + copy_offset,
> +					   copy_count))
> +				return -EFAULT;
> +		}
> +	}
> +
> +	if (index != VFIO_PCI_BAR0_REGION_INDEX)
> +		return vfio_pci_core_write(core_vdev, buf, count, ppos);
> +
> +	ret = pm_runtime_resume_and_get(&pdev->dev);
> +	if (ret) {
> +		pci_info_ratelimited(pdev, "runtime resume failed %d\n", ret);
> +		return -EIO;
> +	}
> +
> +	ret = translate_io_bar_to_mem_bar(virtvdev, pos, (char __user *)buf, count, false);
> +	pm_runtime_put(&pdev->dev);

Same

> +static const struct vfio_device_ops virtiovf_vfio_pci_tran_ops = {
> +	.name = "virtio-vfio-pci-trans",
> +	.init = virtiovf_pci_init_device,
> +	.release = virtiovf_pci_core_release_dev,
> +	.open_device = virtiovf_pci_open_device,
> +	.close_device = vfio_pci_core_close_device,
> +	.ioctl = virtiovf_vfio_pci_core_ioctl,
> +	.read = virtiovf_pci_core_read,
> +	.write = virtiovf_pci_core_write,
> +	.mmap = vfio_pci_core_mmap,
> +	.request = vfio_pci_core_request,
> +	.match = vfio_pci_core_match,
> +	.bind_iommufd = vfio_iommufd_physical_bind,
> +	.unbind_iommufd = vfio_iommufd_physical_unbind,
> +	.attach_ioas = vfio_iommufd_physical_attach_ioas,

Missing detach_ioas

> +static bool virtiovf_bar0_exists(struct pci_dev *pdev)
> +{
> +	struct resource *res = pdev->resource;
> +
> +	return res->flags ? true : false;

?: isn't necessary cast to bool does this expression automatically

I didn't try to check the virtio parts of this, but the construction
of the variant driver looks OK, so

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

