Return-Path: <kvm+bounces-1128-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B3F37E4F1B
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 03:50:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A61591C20D86
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 02:50:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A440B10FE;
	Wed,  8 Nov 2023 02:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="J3sMlaYo"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E1CEEC2
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 02:49:59 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2044.outbound.protection.outlook.com [40.107.243.44])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8F8D10EC;
	Tue,  7 Nov 2023 18:49:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fu2vXQ35s/JMESXaBGvNSFFKlQ5PbhoWkmAlk5rL+Zn9tEDy+SAyNGF/BZ8anICqZq2gwmF9ay6YgppbAgznf2Oe7m32WNHZWJwIn8mCRZhGAe0YQdzZfrnvIIZBVoBZvqBUfsyaBx9KUMrTV6XXp8aWTkFlr0i57oP7/l8CyW/Ulxhq5Uqu6QfVQTu7VPIeetqhhXWcbE4z1RVw+1QUn+f6b//IPBNJiC/w7oMNtuAc6R7I3P7SOa7eAbO4lMrgUVsODXbaAUMaqkzxl0qch3jiPjU/OD66b+4uebKIbji0V//2EWbRunh77NELQCR7LvR4MV/0TGE1UniVExalIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=klElYUjkY11fNWEaqmhB0gVXXtnDl52y/H7rh+A/Vgw=;
 b=CqSjUHwzkfSWT95tNp2KaRDvJs76OVq/lChAwCi+0l+vWFM5nt7OZYtyijgkk6pTvitarkRO9nkayOAmuoMcqNC3FnVrtXoQr8k8u6kdXgCXNp9pd0b+R8Df1FtEK6B/2bTwGdEI9y5dub4ZSfR2kXl9AgWIsQSZPsk6oG6X2+Q9+0KQXipfIqClCfAElcKzRKI0dJ21DgiYVFoKvZkS9WhF6yDMHwuFTpoVvEk3iEuym3lLu6buNANc3/KZqrtuq+p/DxIoUIDFxqKD9ucAG9QC4YHUP1r1Pn4+Mp7bMJgqAtN4igGSTCsv7J8Bo6hXPN20FKD69+nsDT8WC7JpKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=klElYUjkY11fNWEaqmhB0gVXXtnDl52y/H7rh+A/Vgw=;
 b=J3sMlaYoW2iKii9e+vKAat6m5bRV7EsnWjTkAXQg4/7EjVuMXak2dGxUFMq1olEGft2JiTPSqnxzd+0idJ0nnND35kukpv/ne0gXVeka/twLTUBjj8g9RqNui7z15IqD97FbUanmG2l4BtFfOV9AcKoTAEQytkenwxfzNHojjbS/aiwqDAxp+zyP/0PK6DQSLa13LSU9uf/0fQIkcZ4LVigFI9qA5ijEcLZUMGfMXL6nJ/b/1qi8T32VSuVq9oxplnovNhTOC2HWcccD0QxV7Rgnd8r5W4W8CVTUCmAAQdSEVCnChASY5gGkXahcJdSxubSoRaY6fauabJa0fqxgAg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN0PR12MB5859.namprd12.prod.outlook.com (2603:10b6:208:37a::17)
 by DS7PR12MB5933.namprd12.prod.outlook.com (2603:10b6:8:7c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.27; Wed, 8 Nov
 2023 02:49:56 +0000
Received: from MN0PR12MB5859.namprd12.prod.outlook.com
 ([fe80::7d0e:720a:6192:2e6b]) by MN0PR12MB5859.namprd12.prod.outlook.com
 ([fe80::7d0e:720a:6192:2e6b%5]) with mapi id 15.20.6954.029; Wed, 8 Nov 2023
 02:49:56 +0000
Date: Tue, 7 Nov 2023 22:49:53 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	"Tian, Kevin" <kevin.tian@intel.com>,
	"yishaih@nvidia.com" <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com" <shameerali.kolothum.thodi@huawei.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Jiang, Dave" <dave.jiang@intel.com>,
	"Liu, Jing2" <jing2.liu@intel.com>,
	"Raj, Ashok" <ashok.raj@intel.com>,
	"Yu, Fenghua" <fenghua.yu@intel.com>,
	"tom.zanussi@linux.intel.com" <tom.zanussi@linux.intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>
Subject: Re: [RFC PATCH V3 00/26] vfio/pci: Back guest interrupts from
 Interrupt Message Store (IMS)
Message-ID: <20231108024953.GR4488@nvidia.com>
References: <cover.1698422237.git.reinette.chatre@intel.com>
 <BL1PR11MB52710EAB683507AD7FAD6A5B8CA0A@BL1PR11MB5271.namprd11.prod.outlook.com>
 <20231101120714.7763ed35.alex.williamson@redhat.com>
 <BN9PR11MB52769292F138F69D8717BE8D8CA6A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20231102151352.1731de78.alex.williamson@redhat.com>
 <BN9PR11MB5276BCEA3275EC7203E06FDA8CA5A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20231103095119.63aa796f.alex.williamson@redhat.com>
 <BN9PR11MB52765E82CB809DA7C04A3EF18CA9A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <7f8b89c7-7ae0-4f2d-9e46-e15a6db7f6d9@intel.com>
 <20231107160641.45aee2e0.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231107160641.45aee2e0.alex.williamson@redhat.com>
X-ClientProxiedBy: SN1PR12CA0073.namprd12.prod.outlook.com
 (2603:10b6:802:20::44) To MN0PR12MB5859.namprd12.prod.outlook.com
 (2603:10b6:208:37a::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB5859:EE_|DS7PR12MB5933:EE_
X-MS-Office365-Filtering-Correlation-Id: 673d5cf8-e33f-45f4-4a60-08dbe00563d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	MSlzquzc7AnPrQedGz1yubur+0vVybKEyUHokbExgEbJYo7+aOTqsiw3tyYtWH3eETY05zLi4dIKykdT4ztGSypJLL0uw5LnNTh4yEwPiFY8P1hlQMs7TB0+D+K3TQZGpt+OqGCdo/cSAEreU3UhJlTKoWaYVuWx9RUxBZMhVxgUrkYiOY16CRrz/jDt8xcUEQ306fyfDN64bdWSlApf/QQfTT8GyJtKiWE+jZcZc+0scKfzfU+zdVZFA2GXn66nKpZdlsdkYTjhw0RZhrJcyKUyJzCKP8GjS8OHpOt9ZWoST1zrCY0Lua7hkxfI56wLgtnO3dKskIRgXdXEknzStGepU0kCiYW6mbjLwAi0J2yUuskO/Lm/T11bx666+zgYohgbqoh9w6B+9ZneedExYHh5cQE44y6KqiMhpeVK3NzFdcwCB4zEV/bJUhjywR0hxP/mi+rYN2qScgn6YLnuizG8X5F0WNkJht2sVl6QOrvZ2TMcdbdzICl5VtFG7FdR5xdmq1AKQMyo6WoZf6XUbcxLy72G515NyT3S+AIVmXmJx5617PPZ3vI2BGOyywD2
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB5859.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(346002)(39860400002)(396003)(376002)(136003)(230922051799003)(64100799003)(1800799009)(451199024)(186009)(26005)(2906002)(66899024)(41300700001)(8936002)(8676002)(6666004)(4326008)(6486002)(86362001)(6506007)(478600001)(66946007)(66556008)(316002)(54906003)(66476007)(6916009)(33656002)(7416002)(2616005)(5660300002)(1076003)(6512007)(38100700002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pKNOj3HP/2TQrZuQNJQVoZLgxZTHjXHkVi8WroeGnjBoW6QXKM3AF9GrrtkB?=
 =?us-ascii?Q?epOb8J/URGyZ6A02PJL46BhPZIjaECENSGTtZK3s4mTDEt0cWheeSGUZqmCp?=
 =?us-ascii?Q?k9BpWpF1H/yIWURkvQDDtzhi/de5Pc6acvMzpVEcOYNoSSDRMthtiVQX522C?=
 =?us-ascii?Q?4F80Y1r0xeBiowhKEc74NVV06cs3LLc3viYZ3gLDIEhHYQNHVI0W8xZ+f8EO?=
 =?us-ascii?Q?51j+JKngs4EJZCPFF8d1nKMPFmjHctLpXqKuMedNutuzpffAYDLRs7lz+3kM?=
 =?us-ascii?Q?jI2idJ34FvSb69voPn7rGc7J77zjv+Xq/Vau+oIYQcOWmSinIR2icAdI4C0K?=
 =?us-ascii?Q?Lt1ggAj12Q0OuW1ZP3EcycjauHgLr81/lFc257W7SKqw53LHj1tNuPQPv4yt?=
 =?us-ascii?Q?h8EmFczwpV2IwH+IGjv+2vZlZH2qsTC87myXuAd4Px2QOC68tyUjBv7BedWy?=
 =?us-ascii?Q?BhAlaxAYkl2lai/8XXFEkO7ecKRjFv5a6cCnfJtIM1s+/QqsFNFg0dThiUlf?=
 =?us-ascii?Q?OM2DecQR/6BtL2Iq/gOqSSznI/E3FqGw3nBxTH5tXKSad8Riw82Pb42cUbrt?=
 =?us-ascii?Q?VO5byY+zX/OTGyehf4IGcDbQgTXaNH4N5Cx5AnLGRpxGZuW67Vk6NofEEKjT?=
 =?us-ascii?Q?Ciro98C3ZuWdZVHYmDTGcndmYBsAo45NRxm7IuPEWJeMWtA1aNLbuUtyVAn8?=
 =?us-ascii?Q?UFV4S6+NA8eMWJS3/Qz63NTqGZ3tmQobbFjfiOLbVJUBP7+ytep4jGIhxZkV?=
 =?us-ascii?Q?hezoxfCUVd5vZzcsWSTdnzFZZrBMmAlPDLVHhSE/mkezcKh5OAMjng+7OTfr?=
 =?us-ascii?Q?OLv/PdqQkVa5gkmICXeB2A4UNoV0m50bdYSzCV6Rf1VKwic8f38AU+3tA85z?=
 =?us-ascii?Q?hpBXDR0PTaO5vTXJc+X+rsxdkHBfB0SOyxeGTt8SYGg8BLZ08MZfy1BgRvqx?=
 =?us-ascii?Q?5JuzgVPniH7hMW3flZJZiPo8yg612HCH/dDtbCbr5D0Cc7HrMFgSI/FIfrtJ?=
 =?us-ascii?Q?+ntjbvm3VYxm2dhXyz+aB5iX/PG+/kLpfFQjqkwP2+JcIbX7DCyidxmopRk1?=
 =?us-ascii?Q?UoESqonbcVuMyi04xeqvwSrEVOaBGz4AcDhtW9L+kfLw92qsgDRiLZflYAqu?=
 =?us-ascii?Q?or1DWCStxLLhW6jJ9xB0mVG8qHmyo0Scof4+vPv5fQ0FZ/A+AOVhnLK/7O7t?=
 =?us-ascii?Q?laYvV/F2rC2DPwd/kQDJ9oJLL9pW8Q9qSLZgdYWEeJTndmQBXejJeQdm8A/0?=
 =?us-ascii?Q?RmHS41ptbaw67pwhjmMcGGvgBlU3ogEk023Z5PXaVg4pnxgLegZL9SpGgD1o?=
 =?us-ascii?Q?3DETVHRFuJnxP3fhnjJNQmBLQ1NvuDK8yxggu4QshqZ1F302bq/rKjl83xkI?=
 =?us-ascii?Q?F/VgRW/rUR1vIUXw0UtfgDbj3UfoSIOpWFtqmwQn7BDGM75AB70QPo39vivn?=
 =?us-ascii?Q?lUEqVjfqVR/YpPaJ/dwFABmtmrDfcnktr2VlhHPphiAtLNlB57YsV10lQ8g9?=
 =?us-ascii?Q?J7CQqRe0oGSRMi3FnIPKEn/eVCKBVlQdLRbjzahH68mZZczyqPDKXaFidWHE?=
 =?us-ascii?Q?XGR5UqTH4mSbBJAY7SE=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 673d5cf8-e33f-45f4-4a60-08dbe00563d3
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB5859.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2023 02:49:55.8534
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XznIaexpsxNf3efbHacc7zUHzRUD8SkKVjOK95DXNJYjtcZwNydZkyr9xdpJpDd4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5933

On Tue, Nov 07, 2023 at 04:06:41PM -0700, Alex Williamson wrote:

> A vfio-pci variant driver is specifically a driver that leverages
> portions of vfio-pci-core for implementing vfio_device_ops and binds to
> a PCI device.  It might actually be the wrong term here, but I jumped
> to that since the series tries to generalize portions of one of the
> vfio-pci-core code paths. You might very well be intending to use this
> with something more like an mdev driver, which is fine.

IDXD will be a SIOV device and we need to have a serious talk about
how SIOV device lifecycle will work..

> That also sort of illustrates the point though that this series is
> taking a pretty broad approach to slicing up vfio-pci-core's SET_IRQS
> ioctl code path, enabling support for IMS backed interrupts, but in
> effect complicating the whole thing without any actual consumer to
> justify the complication.  Meanwhile I think the goal is to reduce
> complication to a driver that doesn't exist yet.  So it currently seems
> like a poor trade-off.

I think we need to see some draft of the IDXD driver to really
understand this

> This driver that doesn't exist yet could implement its own SET_IRQS
> ioctl that backs MSI-X with IMS as a starting point.  Presumably we
> expect multiple drivers to require this behavior, so common code makes
> sense, but the rest of us in the community can't really evaluate how
> much it makes sense to slice the common code without seeing that
> implementation and how it might leverage, if not directly use, the
> existing core code.

I've been seeing a general interest in taking something that is not
MSI-X (eg "IMS" for IDXD) and converting it into MSI-X for the vPCI
function. I think this will be a durable need in this space.

Ideally it will be overtaken by simply teaching the guest, vfio and
the hypervisor interrupt logic how to directly generate interrupts
with a guest controlled addr/data pair without requiring MSI-X
trapping. That is the fundamental reason why this has to be done this
convoluted way.

Jason

