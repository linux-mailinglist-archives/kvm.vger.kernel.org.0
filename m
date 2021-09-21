Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA451413812
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 19:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbhIURLQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 13:11:16 -0400
Received: from mail-dm6nam11on2049.outbound.protection.outlook.com ([40.107.223.49]:33249
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229893AbhIURLP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Sep 2021 13:11:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KrBL1LI86w68P6YrDjGP7ETsfnLcbWo49KpHJEJsOf2NSlLuaSz3J1zq4OJnouznIKcY5g43MWYDgKWWAozJTUrUAR4PLAZZae4AyaRxdpfHrwKExWtR3po+iPlOv3zvisuRc7TqhlAMUtyU+8MbwGXlOFK4tFDt/tmhuppDPwxd65WJFZyHxpUzAjmHBlPH6/hT+Z1WRIaezjnw0JsylO5r+x0yR2OXSjMx5bVXf3nIWDByr0Bqb0KnobReET5jnfVwXzSRqMGcNE6PhWESia1Xh/SD5lrdTl4AX4rcYyZOc2WTCEXgr83XVZ5tbKQrB4+4Y33IrU2Xx6uVgp2gMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=vTDmBdVeQ9VypY2QAqGICHy8t9skTcri2dLNPY5Mtjc=;
 b=aBuz6eMkBGAAVK0C2XnN/Nf3jitG7tP9NKovYkzefF0z+XOHqyqaQpcy9LPE9ZLRXc8+aiS7DGvZhn2xXWE2x4A1/WmT39NOPkR/EUXAnNTmQtm9Bro5J15+ISbDCmxqd7g4jUSwW+/YviSMHwx4GGzATC/grx3EWbxohhM4evMtYi2UmQ8HE3B6akmPTOS/gqZtsLnd0ERejf7NLss3hO216yroL2whwMxUEZBfYyYg4HXDybEHFCROiztNXzkAeBjXIecBW97pfY9uJUmWedKLdjh6jjSlfm5V/o9Z0YJbIVaLvotQ26gWnsXDzSV7qIPVvHTJjSiAwDYTPdHSPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vTDmBdVeQ9VypY2QAqGICHy8t9skTcri2dLNPY5Mtjc=;
 b=cXK2QkWRES+6oh3Y536/dGkVuO2ipt7FhTGrzN1Me/q0uZnw56L7smqbc+Tfche2mTaqLsHgRp5fIjoeRVr28gkfkFQv+6ZqQpVyg8fwBtJkg01045ycoZrIhkVXC6NaMwKcyZ1O2LCKYlrbKXecHjROYXgQOxRh2F42ZLpbfWPfFCSfv6mx7bPG5I+lEPMI5IoIrEVc+bPQCgrjaEBCziObzp8cn2xouxrWRAVsrubUTd2JjlffaW6UnX9efdqU7QiGFqmaefPruRUzjGGXd4/AQigSbomR4vQLIowYVMMy8JV1SBrQpjrLRBni6+Kg6DBTv0HpyDGMzGyMc7/5/Q==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5189.namprd12.prod.outlook.com (2603:10b6:208:308::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.21; Tue, 21 Sep
 2021 17:09:45 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4544.013; Tue, 21 Sep 2021
 17:09:44 +0000
Date:   Tue, 21 Sep 2021 14:09:43 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, hch@lst.de, jasowang@redhat.com,
        joro@8bytes.org, jean-philippe@linaro.org, kevin.tian@intel.com,
        parav@mellanox.com, lkml@metux.net, pbonzini@redhat.com,
        lushenming@huawei.com, eric.auger@redhat.com, corbet@lwn.net,
        ashok.raj@intel.com, yi.l.liu@linux.intel.com,
        jun.j.tian@intel.com, hao.wu@intel.com, dave.jiang@intel.com,
        jacob.jun.pan@linux.intel.com, kwankhede@nvidia.com,
        robin.murphy@arm.com, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, baolu.lu@linux.intel.com,
        david@gibson.dropbear.id.au, nicolinc@nvidia.com
Subject: Re: [RFC 06/20] iommu: Add iommu_device_init[exit]_user_dma
 interfaces
Message-ID: <20210921170943.GS327412@nvidia.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-7-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210919063848.1476776-7-yi.l.liu@intel.com>
X-ClientProxiedBy: BL1PR13CA0107.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::22) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL1PR13CA0107.namprd13.prod.outlook.com (2603:10b6:208:2b9::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.6 via Frontend Transport; Tue, 21 Sep 2021 17:09:44 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mSjH5-003WVA-3f; Tue, 21 Sep 2021 14:09:43 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a9a60acc-b28a-4912-ae75-08d97d229bc5
X-MS-TrafficTypeDiagnostic: BL1PR12MB5189:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5189FBE291F72312468F2A92C2A19@BL1PR12MB5189.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HUtkTqqpJjmh3dU/R8T0OA+AJa/3sYD/emxv9nOMXR+mvPJaJnCXd6Nt1gzcxT+J9mia22/V8dWqsZ67gVLCNrycT07fJP2ySf2NHHNA36Cmr+z3bA6WHGNK4yuXWg4aJCZN58zRJhO4SWAgk0ElJFc43rtJ1ltFZqFlCs+pqfb1LnXF0uO8UJ/hY4PRS6ZG89KBk3XIy0KtO2ZAWB6jkksTmyDGUCj5Jw0V1Cku3zsRuk8kiYxV6HAjRMfcl8BI2iNejuRT4Hf1QPv7Xkj5qijhap5UvHvuy4rqF/o/yXh2Yei4aHAtPMH3Yl3T06kiqxyIB8YManIwHelcc0naJ/i4gONwnXrkE/UmuwyS0dGsqE+W6nQkmvVoiJ2J2XxXo2UvdMWZWurQhu1rj88u5NK/dchYCyR+Uht4cS85ALXpKIfjQnRncEe4hL8Df7aFWOeAHTRRXyADBLckikDeK7SJbY81CoOyUS7VWjgGaSPnZjbaMfmSONCvn+Aqz22/FXnpdaKs9+R+nv5TPJgC789S2f0WolbhEgkB/EGrbwMy/cKZZzbY3MmXAKmwRL+JTqCyA0kaefi6YT+jUa0vI4q16xyeNkdoMkt7u5JsGwWrM9e3BnHc3b44gH9A51Bwwjjr+I0Zdi9Urloeo0Q9FIF78NGVU50HJECqcttRXNc2GFzwfWdllC4F/NQsk/C6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(83380400001)(8936002)(86362001)(9746002)(426003)(1076003)(36756003)(2616005)(5660300002)(26005)(316002)(107886003)(8676002)(66556008)(7416002)(4326008)(6916009)(508600001)(2906002)(66476007)(9786002)(38100700002)(186003)(33656002)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZG1UNX2+kyFnnj7U/gMPxYXgmoRl6XdII5OlDxvCdxbrPufKPHqfSUnGTjVq?=
 =?us-ascii?Q?xf79r9s/Ggoe2A+TBtGUswdTeaXpLuAviE/JTbRFrjd401tnVZ6kMw1kewH9?=
 =?us-ascii?Q?Q00MVyFHlqUft9HzUofFiQmLVB5Pa7sNAth72ddLTzrSvGkkahIs7IJPTUFm?=
 =?us-ascii?Q?JxJtanIiHVxZ/7q5qQfRNLv6THx3Hzkz6G7guDiqfTyrUQe20WRcnMr6Gxry?=
 =?us-ascii?Q?8QQQGVqayqESD1mQVaxB/UX01Y9XM8RVkyjJGibtoZk/IzmUdcw8F1Ao3jer?=
 =?us-ascii?Q?bnRd6ULoi4Kdi00YKo+oFVYtUeFXk7DUHYjQpAYnIUoF7UAUcv8ZtzIv+sZv?=
 =?us-ascii?Q?CzRmDk8u4OCyo/oLwIIGPEqsCCoFJT3L4esJ7N9XfnZLObCNIOCpBozfUgYP?=
 =?us-ascii?Q?+VvY10E/r/1EffXE3VqV8tYQGCUNxTBEdVctOKOx6AJL4wRoAbbft4eVcjL3?=
 =?us-ascii?Q?2GMprNH5urrmZWKLTcXwSx9lKvaDEnfNrzNITm6NoPwKAGTWdqTT/6twzrTY?=
 =?us-ascii?Q?QCV/Z4A7JMq7sbp8A+c9r19xE4jfrMaytoN9bL6xYsZVzXENvfgLUprZUqzm?=
 =?us-ascii?Q?n7N1LxOHZjIQ7WBGV4CIvfzPhl7BTY4TbOfDJW8bUtCX9Hz2IA3RfC127pbk?=
 =?us-ascii?Q?sYUyaw6RaHGUVvizzUaopowuAV2dGKefFoENSqxLDAzIfqWSoSwm87et2WXO?=
 =?us-ascii?Q?L9bN+886Qv9rJs7gf0RSWaSzYLiknwu6LUQPoFJ1dpQ0fTQ39B6sqnXGM9Zv?=
 =?us-ascii?Q?v1qR0bDyZngY5U+U+SSK/8i90CdmCmR8PY2BenAn+dbJHqGaxiwhz14oRXD7?=
 =?us-ascii?Q?BN9mG2ebvnAEz3EFXGX5TNl2xjFjIetY0FXjxX155I0dF5vWWMf4fv4a5ccN?=
 =?us-ascii?Q?InJ4QDlLrP8xq2NZtb8YOatv7D6AecCFtZ/lNvhQPx41stYkZkwUE+H3KVGM?=
 =?us-ascii?Q?B6iB6YtB/T2RVUOCubEAElffdSc+4Jq9zfH4TcE89wqx2J4hvTIb8UK3s4QV?=
 =?us-ascii?Q?zx5XLSzQKVWatZVSugHgWhUmoytceHgIfaZ4yonsJ1OQ7l5rdqf+Lz1vEyvO?=
 =?us-ascii?Q?W2vMgZgaOlbJ315J6OZKxlhaH5e5aA8T1VG9P7e2KMzn92wuko7uz/kULyru?=
 =?us-ascii?Q?OR++BZUgInLRyF1wj3khOV5+9Ymx/2/xPT6NVTLhMN/WyXngiwUf2QQX4DX8?=
 =?us-ascii?Q?bSSabecZETC+YxdV2YgePMEQK7AbBCAPGNu69hIUpFnjkUGAn1JiXUbx0lvp?=
 =?us-ascii?Q?0aqn1t6DmBEuHi1DNUp1W4peK2UaBxbSKreWAg1WMqkCUr2VMXDkZ8UCEYaZ?=
 =?us-ascii?Q?vAck4CizXoHoiAOmgMMo/PHa?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9a60acc-b28a-4912-ae75-08d97d229bc5
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2021 17:09:44.8545
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6Fwx0P3Ft+KKvSGrWJpRouHHkI/IwN1Gd5Ud0EGjuMI/lzgys1b45bAk+w7x9t/P
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5189
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Sep 19, 2021 at 02:38:34PM +0800, Liu Yi L wrote:
> From: Lu Baolu <baolu.lu@linux.intel.com>
> 
> This extends iommu core to manage security context for passthrough
> devices. Please bear a long explanation for how we reach this design
> instead of managing it solely in iommufd like what vfio does today.
> 
> Devices which cannot be isolated from each other are organized into an
> iommu group. When a device is assigned to the user space, the entire
> group must be put in a security context so that user-initiated DMAs via
> the assigned device cannot harm the rest of the system. No user access
> should be granted on a device before the security context is established
> for the group which the device belongs to.

> Managing the security context must meet below criteria:
> 
> 1)  The group is viable for user-initiated DMAs. This implies that the
>     devices in the group must be either bound to a device-passthrough

s/a/the same/

>     framework, or driver-less, or bound to a driver which is known safe
>     (not do DMA).
> 
> 2)  The security context should only allow DMA to the user's memory and
>     devices in this group;
> 
> 3)  After the security context is established for the group, the group
>     viability must be continuously monitored before the user relinquishes
>     all devices belonging to the group. The viability might be broken e.g.
>     when a driver-less device is later bound to a driver which does DMA.
> 
> 4)  The security context should not be destroyed before user access
>     permission is withdrawn.
> 
> Existing vfio introduces explicit container/group semantics in its uAPI
> to meet above requirements. A single security context (iommu domain)
> is created per container. Attaching group to container moves the entire
> group into the associated security context, and vice versa. The user can
> open the device only after group attach. A group can be detached only
> after all devices in the group are closed. Group viability is monitored
> by listening to iommu group events.
> 
> Unlike vfio, iommufd adopts a device-centric design with all group
> logistics hidden behind the fd. Binding a device to iommufd serves
> as the contract to get security context established (and vice versa
> for unbinding). One additional requirement in iommufd is to manage the
> switch between multiple security contexts due to decoupled bind/attach:

This should be a precursor series that actually does clean things up
properly. There is no reason for vfio and iommufd to differ here, if
we are implementing this logic into the iommu layer then it should be
deleted from the VFIO layer, not left duplicated like this.

IIRC in VFIO the container is the IOAS and when the group goes to
create the device fd it should simply do the
iommu_device_init_user_dma() followed immediately by a call to bind
the container IOAS as your #3.

Then delete all the group viability stuff from vfio, relying on the
iommu to do it.

It should have full symmetry with the iommufd.

> @@ -1664,6 +1671,17 @@ static int iommu_bus_notifier(struct notifier_block *nb,
>  		group_action = IOMMU_GROUP_NOTIFY_BIND_DRIVER;
>  		break;
>  	case BUS_NOTIFY_BOUND_DRIVER:
> +		/*
> +		 * FIXME: Alternatively the attached drivers could generically
> +		 * indicate to the iommu layer that they are safe for keeping
> +		 * the iommu group user viable by calling some function around
> +		 * probe(). We could eliminate this gross BUG_ON() by denying
> +		 * probe to non-iommu-safe driver.
> +		 */
> +		mutex_lock(&group->mutex);
> +		if (group->user_dma_owner_id)
> +			BUG_ON(!iommu_group_user_dma_viable(group));
> +		mutex_unlock(&group->mutex);

And the mini-series should fix this BUG_ON properly by interlocking
with the driver core to simply refuse to bind a driver under these
conditions instead of allowing userspace to crash the kernel.

That alone would be justification enough to merge this work.

> +
> +/*
> + * IOMMU core interfaces for iommufd.
> + */
> +
> +/*
> + * FIXME: We currently simply follow vifo policy to mantain the group's
> + * viability to user. Eventually, we should avoid below hard-coded list
> + * by letting drivers indicate to the iommu layer that they are safe for
> + * keeping the iommu group's user aviability.
> + */
> +static const char * const iommu_driver_allowed[] = {
> +	"vfio-pci",
> +	"pci-stub"
> +};

Yuk. This should be done with some callback in those drivers
'iomm_allow_user_dma()"

Ie the basic flow would see the driver core doing some:

 ret = iommu_doing_kernel_dma()
 if (ret) do not bind
 driver_bind
  pci_stub_probe()
     iommu_allow_user_dma()

And the various functions are manipulating some atomic.
 0 = nothing happening
 1 = kernel DMA
 2 = user DMA

No BUG_ON.

Jason
