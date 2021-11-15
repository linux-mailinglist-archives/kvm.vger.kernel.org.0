Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76A274505B7
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 14:40:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231799AbhKONmv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 08:42:51 -0500
Received: from mail-mw2nam08on2049.outbound.protection.outlook.com ([40.107.101.49]:56935
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231816AbhKONlN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 08:41:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TNvjD6z8Ev3MLHAvGvh1SN6tvJEa4FOP+VV3GkDxRx9KV2s9LK89MD51tbBGWeyBe2zB+s1STpn+QDYfhwL7QQZ6WW+aHbTcgpvR8JetMdIgnOoRdqxMilHrEFe/fJ8MN2omJ3ZDOOyYclih/r/ySLlTuOBOiyEpkwJcbPjx6LYn9bYodhuW+VZSo7oJjDHK7eows7/AlatnY4qKV4muMX+dOAS5FqDpGcKpysbWstL1Pc1yRl/2dfFMxQIX6VdHv7+yL5+yvOmMPuSRbdyE5cO3BKg/gkI2O+76kebIu8i101ZmBldJkS2mb74t5paNKp1IG2vY93QVXUEh80x6bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ej0YBITiTz6MlpEdgBhnrqTxOocCUOAONS8G0UL/onw=;
 b=Jy84QSsRgbZktpEflEaSL0JxU3urb1jONKJjzdeXHZUdY+4wmhPpQnmOUa0ni4ZLMjllxglIPs/kEgGizyoEI2oqIfktA4eDPhjxwndMmoom9sFqKuFze2b+TFt/FbaL33w2ri6ymCx+itxgXGA+IOxciv/x+yacjDllS9VZknXZpYtv0KKydq1Y0ECVtvqO88cIUi9OKoGkCnAsnZewJbZgO6Dmf9oX49BlsE20Q6UkaAv7LHKFPzF2ZzaoTtJ92f40u/SZm1rGr7cYZCaZv7SEjr5Dq8D5EP3bs4V7LxhKCboxR9Sc1f/AioS9dJo1Es8F6O+5WgCfmLwNpbD7wA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ej0YBITiTz6MlpEdgBhnrqTxOocCUOAONS8G0UL/onw=;
 b=ksV76H+aZ2JaQDdTorYE73iESgiLFWwOP9zRCs1l72exSwuY0V6zxKv/uPUTvgKOhxF0OjRasrH9H1rhw5S82xxjqkxflIbJ4k5ZmYeofc+HZfa0Q1wbgiG+9CAuyg/bVgRKYA3jQTBkJiIRJPZJAi0dDNbiNhyIN1LDn2J2+RcQLf++JtdCIib7VifEhHzHt/uByGAMX/aRUwq+tFjkpT66w3GU3bh1h6DHLH7AEZWF1Fxcav5j4kOJMVW0/zknhk5R447d6L3et5Z2GDz57zxf3OitEShCp/1DDKJgiF33l3MSR1cGsH27h/pz7z2IiAb8SCapZNlisMmSwIThMg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5238.namprd12.prod.outlook.com (2603:10b6:208:31e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.16; Mon, 15 Nov
 2021 13:38:16 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909%7]) with mapi id 15.20.4690.027; Mon, 15 Nov 2021
 13:38:16 +0000
Date:   Mon, 15 Nov 2021 09:38:15 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, Will Deacon <will@kernel.org>,
        rafael@kernel.org, Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/11] driver core: Set DMA ownership during driver
 bind/unbind
Message-ID: <20211115133815.GN2105516@nvidia.com>
References: <20211115020552.2378167-1-baolu.lu@linux.intel.com>
 <20211115020552.2378167-3-baolu.lu@linux.intel.com>
 <YZIFPv7BpsTibxE/@kroah.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YZIFPv7BpsTibxE/@kroah.com>
X-ClientProxiedBy: CH0PR03CA0361.namprd03.prod.outlook.com
 (2603:10b6:610:119::27) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (206.223.160.26) by CH0PR03CA0361.namprd03.prod.outlook.com (2603:10b6:610:119::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26 via Frontend Transport; Mon, 15 Nov 2021 13:38:16 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mmcBb-009zP2-16; Mon, 15 Nov 2021 09:38:15 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 48dab027-fdce-4cab-219d-08d9a83d2dc9
X-MS-TrafficTypeDiagnostic: BL1PR12MB5238:
X-Microsoft-Antispam-PRVS: <BL1PR12MB52382CC182A5F244563A8194C2989@BL1PR12MB5238.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZpX6uR58ISmpLRy5LuZRXkVSfn/0yhHVOZZmzIvstEOcO4uVmvd/odtSpkJMVIznR423qRBBcCiI/8fGjt1sfZmf8k7TDO48HeptezDlKSrhOmgFN0vZ1cEejJtSQYytHglGpC0/BMXTf2CZHc4wQar8nMTW4P5+8aubY1pDd1ics05nZP29tv8aj8Wyay1JPKcTEWScb0DraiV78tbdL4NQVf2H60ocatNqWJisy9hiOOSPqHWO7FG3Idkw9IedeeKcPDzm0yZ6z+XEXZB+UIftl/RG+Y17cDarxLFLy/Uac2OqB9+h1f2fuIUewwXmO7ygZ07+fGyOvZB5t2NKF+eHwviUqSaY06TGhsVK5zsKKptgkg+CMq8htpONEvlBoLQQ/qnDNuOqzXWL4/ia5dziF6daGTSGu/TZIqvbTNYP9HfJV41Fb4/0hOq0YoYFK+xAQ8coPfXArm4iN7c+Ywpi4YroU2DCrXbyM178rEa/mT0HOXDVqfjTTVgk2K5bXXT/X5pQjRS/kk7jS97UrWMVpI7DSTD4homJkoicY/PlXb6NB8neVxAfosNaAH00/YWYxqgz64RvBbC1UR15J2vOPVNrRyDGvWYKhMQGHpM9leVAx321+SUCImCXf9s7XdlpganPOAHc28qbtdN0dA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(9746002)(1076003)(186003)(9786002)(8676002)(66946007)(8936002)(6916009)(36756003)(54906003)(83380400001)(508600001)(66476007)(426003)(66556008)(4326008)(7416002)(38100700002)(2906002)(316002)(86362001)(26005)(2616005)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QY9mj9+RSPzNeUWOqREWgrunhuMfe0aQKa/2E96LRClO9RT0kGgZRSkTwOvM?=
 =?us-ascii?Q?p+qWyI0y83TSaV7SJKhqf57cxFDh68OIaXsF74V6yZ0W5j4OK5SEDq8c5mPX?=
 =?us-ascii?Q?O0r9xro1UcCnyfQs5fp9J8dXuyrf+9HM5U0lUDo37gf6LCE3vG/Ocv0u+rZP?=
 =?us-ascii?Q?MzJbPW1iQSDWYEKk1OTm0IMawYJA8QhsurVHojH3d4Mdc6PwkkG9AE5sP0LQ?=
 =?us-ascii?Q?WyBJiNjNAGvZ0JYTWShpuD3JAONIx6HXBWu25Xny+8MGE7vYqUqU+hdFqzzk?=
 =?us-ascii?Q?AAmP/rqnS2pR9r+J4HMbVaQ30t6snqX68g7wM/V/MBpWpr+D4AKxzkOVSF9C?=
 =?us-ascii?Q?XRse8pv0dHLtYw4HTPKncWVSE75lKt2QIh/PSKYSGNf97oNX2nraZHbBNro8?=
 =?us-ascii?Q?DLlqvZ4POsmV/7uyrEchXZSc1VDJbtj2Z+eciwfMhsv1XCLmHCxRZ7s7DRdr?=
 =?us-ascii?Q?9I207kMMghwr0I6l4TJgvAMKGNBDDbE0hB3lBzpAb9KBvDl13wpOn6hgm8DV?=
 =?us-ascii?Q?NTUeUSIsNPcMQvk50bTXqElEtnXnJFJ3ewzxVbeREy9Xtf3OJ/HXIbz+FXpC?=
 =?us-ascii?Q?kM2nTx9ORmh/F+LFbQll5zRqx7x/tnSbD7RIwS3kIJRpWXU0bxHHMAgWedM1?=
 =?us-ascii?Q?MvCu73EJL0jrtkA8Yu3Nvv/4tFLoVOB83JBLB5cQC+xs8rXJtSVp5oX4b771?=
 =?us-ascii?Q?92TBPtWtvfB5f1fW9AkPm0C2dOncgIyOkxQshAQanf4GRMzq1I7IhlZU1Lmf?=
 =?us-ascii?Q?m1Qw7GIaR8yiBIm8IfCSlGsJn4KswI/C19j0bmDGc8T/Nwyf1eHvh/zDJJkV?=
 =?us-ascii?Q?51+ZAIZ9CP0uaGrYmC8MBCRvoLeibPsfHkSWhlIiEj+fnVkpvUc95NywhnD3?=
 =?us-ascii?Q?oM9hfcfN6bVPsEi0OtScFVArqa/xfJCiiBRYlUPBLShZyhOmi0VZxnT/E5rB?=
 =?us-ascii?Q?R3K2Bg9Ug8sdIsDdxo8oGLe//s8zFTLnQp+HeA79vxOKYXkDoXaCFsLPcYqH?=
 =?us-ascii?Q?9I1J3OcVbzh7cfTmxsdSs9yyo6KdJeq6Ex3+GUbw+aw6qj9W10EQOEMewRKQ?=
 =?us-ascii?Q?nnDgagXFqGO1woEnNKBBFOoqvGZVQxqqv2humSs+/nheSTJtMAN61SKKCUbC?=
 =?us-ascii?Q?VM+OadKhk4yeZjNFf9lrsShxnkGyDd/DGK37PxWF2Nn3q0wrLziOcUCmwUEs?=
 =?us-ascii?Q?e8qpQGfZ79itCPiFwPZQYOMwZExfwWFNBHmXOd9dNvqvugrFfhaxLm0JPDjL?=
 =?us-ascii?Q?IxzmSZYaDO0zHXUp+LPuNcVCAyDHuBP06TRTm5b4Zv9Omqt0zJUV6AVXbYXg?=
 =?us-ascii?Q?Z5EVJpxITscnsKpbRhZfk3gAzufeFN8gwldXYhU1GwEp0Plk0fkfjt+LH0YK?=
 =?us-ascii?Q?gOhWcLNkud/flQywhFcivQVcRzddDKYMQtuDvAntSAYDt1ivJCL/YAsIBEU+?=
 =?us-ascii?Q?v23dCzzDDA5HCi6tPgTBdtjvXW5yecueeeMfDC0PjMYVmHR7aslygEnGw/4r?=
 =?us-ascii?Q?gJp8HqvCivabqxOEXYEApU/mXdIL8e02Ir1Uph6U0Zkwg4GzCCSvMg6k9wkf?=
 =?us-ascii?Q?9RWlZiWwPefBtTt16g0=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48dab027-fdce-4cab-219d-08d9a83d2dc9
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2021 13:38:16.5886
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GsRe3FSFfll5c1c1eSvw/8H05+osdo5bFabGwjjdOGUnQYMZqM43Gs2Hkhe5XBGK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5238
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 15, 2021 at 07:59:10AM +0100, Greg Kroah-Hartman wrote:
> > @@ -566,6 +567,12 @@ static int really_probe(struct device *dev, struct device_driver *drv)
> >  		goto done;
> >  	}
> >  
> > +	if (!drv->suppress_auto_claim_dma_owner) {
> > +		ret = iommu_device_set_dma_owner(dev, DMA_OWNER_KERNEL, NULL);
> > +		if (ret)
> > +			return ret;
> > +	}
> > +
> 
> This feels wrong to be doing it in the driver core, why doesn't the bus
> that cares about this handle it instead?

As Christoph said, it is not related to the bus. To elaborate any
bus_type that has iommu_ops != NULL needs this check, and it must be
done on an individual struct device as the result is sensitive to the
iommu_group member of each struct device.

> You just caused all drivers in the kernel today to set and release this
> ownership, as none set this flag.  Shouldn't it be the other way around?

No - the whole point is to cause every driver to do this test.

iommu_device_set_dma_owner() can fail for any device, if it does then
a kernel driver must not be probed. Probing a kernel driver when
iommu_device_set_dma_owner() fails will break kernel integrity due to
HW limitations.

The drv->suppress_auto_claim_dma_owner disables this restriction
because three drivers will deal with DMA ownership on their own.

> You only have problems with 1 driver out of thousands, this feels wrong
> to abuse the driver core this way for just that one.

I think you have it backwards. Few drivers out of thousands can take
an action that impacts the security of a thousand other drivers.

The key thing is that device A can have a driver with
suppress_auto_claim_dma_owner=1 and call
iommu_device_set_dma_owner(DMA_OWNER_USER) which will then cause
another device B to be unsable in the kernel.

Device B, with a normal driver, must be prevented from having a kernel
driver because of what the special driver on device A did.

This behavior is a IOMMU HW limitation that cannot be avoided. The
restrictions have always been in the kernel, they were just enforced
with a BUG_ON at probe via a bus_notifier instead of a clean failure.

So, I don't know how to block probing of the thousands of drivers
without adding a test during probing, do you have an different idea?

Jason
