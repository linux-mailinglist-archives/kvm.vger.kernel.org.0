Return-Path: <kvm+bounces-4448-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DDB1812ADF
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 09:58:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 36D241C2147E
	for <lists+kvm@lfdr.de>; Thu, 14 Dec 2023 08:58:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3DB52576C;
	Thu, 14 Dec 2023 08:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="h6Oxb8UF"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2045.outbound.protection.outlook.com [40.107.237.45])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66C09109
	for <kvm@vger.kernel.org>; Thu, 14 Dec 2023 00:58:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ke3P/norOjkdEHCc0IrNAcp5CBa29lJHwc42Zn0kpT9ftRVpXWcZpSYXgWECYNlmee7urqxKKMfkjrbsgBx+1MIdb1Szu+VTTRlGFeZ2E6Lv9P3V9U9sEYpY8vb63SRzGPrkZpsokfUzHPWO7Wv+5hlyV4YiS4edto+LDkhOECU8CCtijWl/E9IgvF3UD9SREg4e9Pe8/LQpdNJENHu99H4V5pVzGGGLsWjmpQV4E+/L6+ERcEqQ1KLU0EVHuwuY2VawO0cTDRSyx5YGGBiLHa0gZvSC+SE8iJA7H2249RhiyY91lv5Kx1gT3ONeQjiCC40NxyY+uudJg22NxzZ6ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8TYvK9H76qO81lX/isqLdl9hHNwh8DVf9qAQwlufAZ8=;
 b=F/goDu7hS6ycVFm0fgSv3fIpWnwJ3loKknu/PpFyEVUEaA5TC1QZ1l5nsxTi+geyq2fOcpUINNnDFPEbgonTNbn/0jUCk+UEYbkIBwAQk0Gn7jWzAi6mM5Gkz5GEwjQ9LEV0obv8G9LL4T2wjkqI5sWyOIaeNsg0F4kCZG5QVKf7uGFSwoIkXtKwxwDyzkAuc3fJkSSbGrdVdy5Vps0OeIM9JpIWH4uu3AI1zg+JQ/vwI4mGOSuTz75Ln93kBF7JVJEoyDSCmc4r8pT6f82qDO0SwJVspdeMKCoUCg7+3qE2nXHNhz0LXyS5Twje6tB8Mcwy6wU5PQpAEPA8azN9/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8TYvK9H76qO81lX/isqLdl9hHNwh8DVf9qAQwlufAZ8=;
 b=h6Oxb8UFRWHsx8aV/9oeZ1FousCxMS9UZfI2VfZb9VkznDmEV4aeWWoi7IQ6reKMzjszqjpLC4S0OAWCBcNPRu+gLxWGSqgTcKqXqb621mvQI28Zkr+ZGibOOnvoc6Q0lQV1HbYSQEr7cGD3k2E/uM9tSX6/jQuZIcHTMdEtQm7WsxswDhqCA2NUwc3Kh6lAkGrVX5gPbzUDyx20BMeomkR5C59+6M45/LxqdceN+l5aJfNT4p/GAT45me4Ukygkq5TF2Xl0D8aTKpGT84/q8wRm6UiNcLsusonOVr6Ptwc9f+t0bULz/gQ9GB43Hwm2q316v3jr36rWf+wnyjMunA==
Received: from BL0PR0102CA0016.prod.exchangelabs.com (2603:10b6:207:18::29) by
 SA1PR12MB8917.namprd12.prod.outlook.com (2603:10b6:806:386::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.28; Thu, 14 Dec
 2023 08:58:00 +0000
Received: from BL6PEPF0001AB78.namprd02.prod.outlook.com
 (2603:10b6:207:18:cafe::2c) by BL0PR0102CA0016.outlook.office365.com
 (2603:10b6:207:18::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.26 via Frontend
 Transport; Thu, 14 Dec 2023 08:58:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BL6PEPF0001AB78.mail.protection.outlook.com (10.167.242.171) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7091.26 via Frontend Transport; Thu, 14 Dec 2023 08:57:59 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 14 Dec
 2023 00:57:45 -0800
Received: from [172.27.58.65] (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Thu, 14 Dec
 2023 00:57:38 -0800
Message-ID: <310c600b-c6d7-4c17-9606-76de5ef0e41b@nvidia.com>
Date: Thu, 14 Dec 2023 10:57:32 +0200
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
To: "Tian, Kevin" <kevin.tian@intel.com>, "alex.williamson@redhat.com"
	<alex.williamson@redhat.com>, "jgg@nvidia.com" <jgg@nvidia.com>,
	"mst@redhat.com" <mst@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"virtualization@lists.linux-foundation.org"
	<virtualization@lists.linux-foundation.org>, "parav@nvidia.com"
	<parav@nvidia.com>, "feliu@nvidia.com" <feliu@nvidia.com>, "jiri@nvidia.com"
	<jiri@nvidia.com>, "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
	"si-wei.liu@oracle.com" <si-wei.liu@oracle.com>, "leonro@nvidia.com"
	<leonro@nvidia.com>, "maorg@nvidia.com" <maorg@nvidia.com>,
	"jasowang@redhat.com" <jasowang@redhat.com>
References: <20231207102820.74820-1-yishaih@nvidia.com>
 <20231207102820.74820-10-yishaih@nvidia.com>
 <BN9PR11MB5276C9276E78C66B0C5DA9088C8DA@BN9PR11MB5276.namprd11.prod.outlook.com>
 <fc4a3133-0233-4843-a4e4-ad86e5b91b3d@nvidia.com>
 <BN9PR11MB5276C5E5AF53B2DCCD654DEF8C8CA@BN9PR11MB5276.namprd11.prod.outlook.com>
From: Yishai Hadas <yishaih@nvidia.com>
In-Reply-To: <BN9PR11MB5276C5E5AF53B2DCCD654DEF8C8CA@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB78:EE_|SA1PR12MB8917:EE_
X-MS-Office365-Filtering-Correlation-Id: d18af0ba-9f58-4068-2a0b-08dbfc82c609
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	D+VnUR5+BMy3AAkzjHOT0/vbGXYE2JvQgtFXyUIInpGJVzLEKerIlg9KA6EOV5ASvgTTdCT3F5DTT3o1tqO/6O+LizI971pGycMavAvcKVEyLg+Yh/wuck8DBJJSSAAwhh/eNSmEPt9EbKNmYThxLK5h6Mza1pQeJIduzuaYIHHfjXTLa8AUXEToaRpFNW/e52VTTY/C/Tt8RHf+HA2ebEl2uaqr6Vq/0NszcDfh2Udo3TJ6Gj/xq/yZpJm4dRrY8YRALl7xZPd4NKCyWuEhHuO4RxzuSWbwf/uLmldHnsVkIAlWnJGSp95c89eX7GLPrCjsKDIGSxCtHoKRtj5tTCJ9oaPx9Vq1uY+5Q6FkpWQDAk33GZA+Q0PhgMOk1q0iE4J43SfqJEKS50n1jKGDkAEmB9CHg6D3a+v1ogX89kNSDfFuLzpwgIKKkhtV3zqTom7X6mRxP0g0Owu2VbG5nuI936LYKS1ai/UVcfjkZP6DZVwBVuxfHmdiKkPPWDyAZjuttpktIWWiXcgxskDzQVL2Kt8BONpJzn6X94mXgUvHDCblZIswW51FlMLbSrX0B+jRWm5P+Aefc3XeklCQ3ATE8M7oKglr0z0E7UMLNr2sGsuY58N/kSwzf3ovcFI/CHiXKxkM7UU9isvvicQARnLIVWqwm+v6qgILae0ExKhSSyD5aVtSg0Oc1aA/3mka/ZNkv5GdWanKGR30YmTXUemkwswDWmtLF/KErzyzzFAhRkXbGg+0VgNCjYtPWX+drkpteQAHq1WDe2/RsbKovHS4QdkxrhoiBAsuchb1OBho1q0Bja0F7LS2kaMH6vuc
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(396003)(39860400002)(376002)(136003)(346002)(230922051799003)(64100799003)(451199024)(82310400011)(1800799012)(186009)(46966006)(40470700004)(36840700001)(2906002)(40460700003)(86362001)(4326008)(8676002)(8936002)(31696002)(316002)(5660300002)(41300700001)(36756003)(966005)(31686004)(478600001)(36860700001)(426003)(16526019)(40480700001)(2616005)(26005)(336012)(6666004)(356005)(47076005)(82740400003)(53546011)(83380400001)(7636003)(110136005)(70206006)(70586007)(54906003)(16576012)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2023 08:57:59.9619
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d18af0ba-9f58-4068-2a0b-08dbfc82c609
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB78.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8917

On 14/12/2023 8:07, Tian, Kevin wrote:
>> From: Yishai Hadas <yishaih@nvidia.com>
>> Sent: Wednesday, December 13, 2023 8:25 PM
>>
>> On 13/12/2023 10:23, Tian, Kevin wrote:
>>>> From: Yishai Hadas <yishaih@nvidia.com>
>>>> Sent: Thursday, December 7, 2023 6:28 PM
>>>>
>>>> +
>>>> +static ssize_t virtiovf_pci_read_config(struct vfio_device *core_vdev,
>>>> +					char __user *buf, size_t count,
>>>> +					loff_t *ppos)
>>>> +{
>>>> +	struct virtiovf_pci_core_device *virtvdev = container_of(
>>>> +		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
>>>> +	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
>>>> +	size_t register_offset;
>>>> +	loff_t copy_offset;
>>>> +	size_t copy_count;
>>>> +	__le32 val32;
>>>> +	__le16 val16;
>>>> +	u8 val8;
>>>> +	int ret;
>>>> +
>>>> +	ret = vfio_pci_core_read(core_vdev, buf, count, ppos);
>>>> +	if (ret < 0)
>>>> +		return ret;
>>>> +
>>>> +	if (range_intersect_range(pos, count, PCI_DEVICE_ID, sizeof(val16),
>>>> +				  &copy_offset, &copy_count,
>>>> &register_offset)) {
>>>> +		val16 = cpu_to_le16(VIRTIO_TRANS_ID_NET);
>>>> +		if (copy_to_user(buf + copy_offset, (void *)&val16 +
>>>> register_offset, copy_count))
>>>> +			return -EFAULT;
>>>> +	}
>>>> +
>>>> +	if ((le16_to_cpu(virtvdev->pci_cmd) & PCI_COMMAND_IO) &&
>>>> +	    range_intersect_range(pos, count, PCI_COMMAND, sizeof(val16),
>>>> +				  &copy_offset, &copy_count,
>>>> &register_offset)) {
>>>> +		if (copy_from_user((void *)&val16 + register_offset, buf +
>>>> copy_offset,
>>>> +				   copy_count))
>>>> +			return -EFAULT;
>>>> +		val16 |= cpu_to_le16(PCI_COMMAND_IO);
>>>> +		if (copy_to_user(buf + copy_offset, (void *)&val16 +
>>>> register_offset,
>>>> +				 copy_count))
>>>> +			return -EFAULT;
>>>> +	}
>>>
>>> the write handler calls vfio_pci_core_write() for PCI_COMMAND so
>>> the core vconfig should have the latest copy of the IO bit value which
>>> is copied to the user buffer by vfio_pci_core_read(). then not necessary
>>> to update it again.
>>
>> You assume the the 'vconfig' mechanism/flow is always applicable for
>> that specific field, this should be double-checked.
>> However, as for now the driver doesn't rely / use the vconfig for other
>> fields as it doesn't match and need a big refactor, I prefer to not rely
>> on it at all and have it here.
> 
> iiuc this driver does relies on vconfig for other fields. It first calls
> vfio_pci_core_read() and then modifies selected fields which needs
> special tweak in this driver.

No, there is no dependency at all on vconfig for other fields in the driver.

vfio_pci_core_read() for most of its fields including the PCI_COMMAND 
goes directly over the PCI API/flow to the device and doesn't use the 
vconfig.

So, we must save/restore the PCI_COMMAND on the driver context to have 
it properly reported/emulated the PCI_COMMAND_IO bit.

> 
> btw what virtio-net specific tweak is applied to PCI_COMMAND? You
> basically cache the cmd value and then set PCI_COMMAND_IO if
> it's set in the cached value. But this is already covered by pci
> vconfig. If anything is broken there then we already have a big
> trouble.

As I wrote above, this field (i.e.PCI_COMMAND) is not managed at all by 
vconfig, so we need to emulate it in the driver.

> 
> The trick for bar0 makes sense as it doesn't exist physically then
> the vconfig mechanism may not give the expected result. But
> I didn't see the same rationale for PCI_COMMAND.
> 
>>>> +
>>>> +static ssize_t
>>>> +virtiovf_pci_core_write(struct vfio_device *core_vdev, const char __user
>>>> *buf,
>>>> +			size_t count, loff_t *ppos)
>>>> +{
>>>> +	struct virtiovf_pci_core_device *virtvdev = container_of(
>>>> +		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
>>>> +	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
>>>> +	loff_t pos = *ppos & VFIO_PCI_OFFSET_MASK;
>>>> +
>>>> +	if (!count)
>>>> +		return 0;
>>>> +
>>>> +	if (index == VFIO_PCI_CONFIG_REGION_INDEX) {
>>>> +		size_t register_offset;
>>>> +		loff_t copy_offset;
>>>> +		size_t copy_count;
>>>> +
>>>> +		if (range_intersect_range(pos, count, PCI_COMMAND,
>>>> sizeof(virtvdev->pci_cmd),
>>>> +					  &copy_offset, &copy_count,
>>>> +					  &register_offset)) {
>>>> +			if (copy_from_user((void *)&virtvdev->pci_cmd +
>>>> register_offset,
>>>> +					   buf + copy_offset,
>>>> +					   copy_count))
>>>> +				return -EFAULT;
>>>> +		}
>>>> +
>>>> +		if (range_intersect_range(pos, count, PCI_BASE_ADDRESS_0,
>>>> +					  sizeof(virtvdev->pci_base_addr_0),
>>>> +					  &copy_offset, &copy_count,
>>>> +					  &register_offset)) {
>>>> +			if (copy_from_user((void *)&virtvdev-
>>>>> pci_base_addr_0 + register_offset,
>>>> +					   buf + copy_offset,
>>>> +					   copy_count))
>>>> +				return -EFAULT;
>>>> +		}
>>>> +	}
>>>
>>> wrap above into virtiovf_pci_write_config() to be symmetric with
>>> the read path.
>>
>> Upon the read path, we do the full flow and return to the user. Here we
>> just save some data and continue to call the core, so I'm not sure that
>> this worth a dedicated function.
> 
> I don't see a real difference.
> 
> for the read path you first call vfio_pci_core_read() then modifies some
> fields.
> 
> for the write path you save some data then call vfio_pci_core_write().
> 
>>
>> However, this can be done, do you still suggest it for V8 ?
> 
> yes

OK, will add as part of V8.

> 
>>>> +static int virtiovf_pci_init_device(struct vfio_device *core_vdev)
>>>> +{
>>>> +	struct virtiovf_pci_core_device *virtvdev = container_of(
>>>> +		core_vdev, struct virtiovf_pci_core_device, core_device.vdev);
>>>> +	struct pci_dev *pdev;
>>>> +	int ret;
>>>> +
>>>> +	ret = vfio_pci_core_init_dev(core_vdev);
>>>> +	if (ret)
>>>> +		return ret;
>>>> +
>>>> +	pdev = virtvdev->core_device.pdev;
>>>> +	ret = virtiovf_read_notify_info(virtvdev);
>>>> +	if (ret)
>>>> +		return ret;
>>>> +
>>>> +	/* Being ready with a buffer that supports MSIX */
>>>> +	virtvdev->bar0_virtual_buf_size = VIRTIO_PCI_CONFIG_OFF(true) +
>>>> +				virtiovf_get_device_config_size(pdev-
>>>>> device);
>>>
>>> which code is relevant to MSIX?
>>
>> The buffer size must include the MSIX part to match the virtio-net
>> specification.
>>
>> As part of virtiovf_issue_legacy_rw_cmd() we may use the full buffer
>> upon read/write.
> 
> at least mention that MSIX is in the device config region otherwise
> it's not helpful to people w/o virtio background.

MSIX is not in the device configuration region, it follows the common one.
In any case, it looks like this comment doesn't give any real value, 
I'll simply drop it in V8.

> 
>>>> +
>>>> +static const struct vfio_device_ops virtiovf_vfio_pci_ops = {
>>>> +	.name = "virtio-vfio-pci",
>>>> +	.init = vfio_pci_core_init_dev,
>>>> +	.release = vfio_pci_core_release_dev,
>>>> +	.open_device = virtiovf_pci_open_device,
>>>
>>> could be vfio_pci_core_open_device(). Given virtiovf specific init func
>>> is not called  virtiovf_pci_open_device() is essentially same as the
>>> core func.
>>
>> We don't have today vfio_pci_core_open_device() as an exported function.
>>
>> The virtiovf_pci_open_device() matches both cases so I don't see a real
>> reason to export it now.
>>
>> By the way, it follows other drivers in vfio, see for example here [1].
>>
>> [1]
>> https://elixir.bootlin.com/linux/v6.7-
>> rc5/source/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c#L1383
> 
> ah, yes.
> 
>>>> +
>>>> +static int virtiovf_pci_probe(struct pci_dev *pdev,
>>>> +			      const struct pci_device_id *id)
>>>> +{
>>>> +	const struct vfio_device_ops *ops = &virtiovf_vfio_pci_ops;
>>>> +	struct virtiovf_pci_core_device *virtvdev;
>>>> +	int ret;
>>>> +
>>>> +	if (pdev->is_virtfn && virtio_pci_admin_has_legacy_io(pdev) &&
>>>> +	    !virtiovf_bar0_exists(pdev))
>>>> +		ops = &virtiovf_vfio_pci_tran_ops;
>>>
>>> I have a confusion here.
>>>
>>> why do we want to allow this driver binding to non-matching VF or
>>> even PF?
>>
>> The intention is to allow the binding of any virtio-net device (i.e. PF,
>> VF which is not transitional capable) to have a single driver over VFIO
>> for all virtio-net devices.
>>
>> This enables any user space application to bind and use any virtio-net
>> device without the need to care.
>>
>> In case the device is not transitional capable, it will simply use the
>> generic vfio functionality.
> 
> Is it useful to print a message here?

I don't think so, we usually don't print such messages.
User space will work based on caps to know what is supported, as of 
other cases.

> 
>>
>>>
>>> if that is the intention then the naming/description should be adjusted
>>> to not specific to vf throughout this patch.
>>>
>>> e.g. don't use "virtiovf_" prefix...
>>
>> The main functionality is to supply the transitional device to user
>> space for the VF, hence the prefix and the description for that driver
>> refers to VF.
>>
>> Let's stay with that.
> 
> ok
> 
>>
>>>
>>> the config option is generic:
>>>
>>> +config VIRTIO_VFIO_PCI
>>> +        tristate "VFIO support for VIRTIO NET PCI devices"
>>>
>>> but the description is specific to vf:
>>>
>>> +          This provides support for exposing VIRTIO NET VF devices which
>> support
>>> +          legacy IO access, using the VFIO framework that can work with a
>> legacy
>>> +          virtio driver in the guest.
>>>
>>> then the module description is generic again:
>>>
>>> +MODULE_DESCRIPTION(
>>> +	"VIRTIO VFIO PCI - User Level meta-driver for VIRTIO NET devices");
>>>
>>
>> Yes, as the binding allows that, it looks fine to me.
>>
> 
> what about revising the kconfig message to make it clear that it's
> for all virtio-net device with special trick to make VF as a
> transitional device?

Kconfig doesn't need to get into the details of how things were done.
We already mention that it emulates I/O BAR, this seems to be good enough.

However, I'll improve it as you already suggested in the previous mail.

Yishai

