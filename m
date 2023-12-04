Return-Path: <kvm+bounces-3405-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D7198803EC6
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 20:51:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5B0F01F211E1
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 19:51:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A8A233088;
	Mon,  4 Dec 2023 19:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Y/XmR3Vx"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2067.outbound.protection.outlook.com [40.107.244.67])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8775C1;
	Mon,  4 Dec 2023 11:51:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WsSOiMfkSsRPRH8HXF+Ml4aQi9+PPVf2TWqoQbNVu8ksy2m2B/40f2ekwwGpkVr8XR6QDdUenUyqhvcdmjU/bqc9BEOBBuylsFDArBBx5+TXfbKWZAax6TM2mDbo3u04LTgF76+rSDBSthBG7a7kejb8+HUGMVhCemeRx4MvBryJmc4h1nGjcSVwGHfRtnmmjuheimMWVUUQyaxGlqDwvHOusiiA/jqYzgUh5QrdcM9AvMtcEq3BpgBLMP1ugjsO6cixMNpIGXqb7cr6ywfNQGPYq7O68pu2jt9N/i65xoIwufEzYVnUdV1XF67ztqLLgXZupgVx1R07q3kNpP0EbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E5/QT/zxHo0jdkjV467zw+Mk37vSQm6az/baTyrUDjs=;
 b=OOexfVSy5XGdjOC47R3HqGmsT6tBioAiGK4x8RuX4KOTMGxRYGw5nJt+RWmTzw42PhsLYaomF4stNzMB0VI4ZCtT4LcmnEBtV5Mc05KrMYRrV9lkADgA54lBlak4ar5sXNiQPVf0Y4EVoB7N9jmQ72CNHgRfmONbvJ0tRScUj7MyiXP5zCKJG4RP8dhXdiw075DpKmWSzrGniJIOBIAGe51hEJuMfHcA9DCq/i6xKffe+QfCv7DENg+MC4T54gU5Fppp5voxZPs6JizY8Cb5BjFzq1D8VCjsnE9BrjltHrZSPhw89ry5G3q0iXccipFBuvwKz3cA+npOfFTlLbBUeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E5/QT/zxHo0jdkjV467zw+Mk37vSQm6az/baTyrUDjs=;
 b=Y/XmR3VxN7krSMDhfozPkJCtC/Mhm0KmHHKhR4m+RsRn2xLo792GWCjvG1XX2JdMh/tRkjqfzj7dRqOfLOr037PRT9fQEmaurjWGLUa2kpYA8bY6c0BU2J3j60T7bpm9zzzbA4jup8yG9RFQmAc3UVhIDiSGdfJptQ7MZVZ9kbOeLZ/7hVAwLgvIgMOsyQwXML1X0NI1d3/mOM5sf7HWbc0zX0kIVIM5Jf3AfBPjdMz4GpRsu9/NYHtFFArjS25rQlEBvn9t+zTBGnc7xx5OPT7mS6Q50D3g0BnVdFFt1dv6LIkrL+rsgf7MDg4dhV8OxE+7IiUQDW5MOP1DIDBbMA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA1PR12MB7409.namprd12.prod.outlook.com (2603:10b6:806:29c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7046.33; Mon, 4 Dec
 2023 19:50:56 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.033; Mon, 4 Dec 2023
 19:50:56 +0000
Date: Mon, 4 Dec 2023 15:50:55 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Yan Zhao <yan.y.zhao@intel.com>, iommu@lists.linux.dev,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	alex.williamson@redhat.com, pbonzini@redhat.com, joro@8bytes.org,
	will@kernel.org, robin.murphy@arm.com, kevin.tian@intel.com,
	baolu.lu@linux.intel.com, dwmw2@infradead.org, yi.l.liu@intel.com
Subject: Re: [RFC PATCH 00/42] Sharing KVM TDP to IOMMU
Message-ID: <20231204195055.GA2692119@nvidia.com>
References: <20231202091211.13376-1-yan.y.zhao@intel.com>
 <ZW4Fx2U80L1PJKlh@google.com>
 <20231204173028.GJ1493156@nvidia.com>
 <ZW4nCUS9VDk0DycG@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZW4nCUS9VDk0DycG@google.com>
X-ClientProxiedBy: BL1PR13CA0316.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::21) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA1PR12MB7409:EE_
X-MS-Office365-Filtering-Correlation-Id: acc1f415-2de1-424d-8b7d-08dbf50254ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	wbz56gGymX57POaRfrPHRzMByaI54Qffg/lyyvyQg2ajCt9LnX9PafJyXhuBmEmvfbA3HDyqrDBj9Jrbq1wq/g9Qn2+PUYHXTVg/WK52rmj+EUqHwit4r9ouuPq2ouAHtBu64QgSAuAo8SX2Md2xOgvTBoBlCSwrzi4tbiK86AvZRlfmjCAxkB2awfK//u2rV/rUKNLazPNghWR7ypkEM6bTevgSmp4FtyK579VDzqTROFpOMb5fKaDw/Ij/Z6OUES9Hi334+XwsZ5/ess61oPcN3PbvTdkjz+ndwFqbfLCx3wCvaotVnR9RcxsbE7VO7I1POPMnJhls3+krm9cC1odKjDnB5R4QNQ9jhWJOaSaPDyGK5nea2bltMVc7v1o+uyGUERXIoE7FdU/CSFkNMWBIm4I1dZDZOTR3xOap5mKKrKqloKqAiethZsMOGHgG5s3Q7jp/zykUWiRrNExTzOo2zMiXiKnQ2JYyma0zOqpREWQc9Al9hU6mzpqCRGJCeJobKV3RzGj+n2Khech2X9RZvvjEO2atNNCFOf9c8CTI6BJwEnOpN6Sw5THjSBgk
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(366004)(396003)(39860400002)(136003)(230922051799003)(451199024)(186009)(64100799003)(1800799012)(36756003)(41300700001)(66899024)(5660300002)(7416002)(2906002)(33656002)(38100700002)(478600001)(6486002)(6512007)(6506007)(1076003)(26005)(2616005)(8936002)(8676002)(4326008)(66556008)(66476007)(6916009)(66946007)(86362001)(316002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CIfDJwsGmk1TXcT4/fXifpVf/5cfw++hgsudWD851f5VEmXmqfS4jt+NhkJ2?=
 =?us-ascii?Q?3qyxQZa0UShOq5g8j4cG9dbGaQaJIM5sy5nyXXBc3l3SYTMtFRxmmI00Ki2f?=
 =?us-ascii?Q?ZdOGCGaVaRXVMHNHDNhhDMzMzUVF5RanpbHYclY8ycfLvGRFflASePpfl8RF?=
 =?us-ascii?Q?CKtTZqIQbAvXHUrPgOQdzBGxvd+JzaaoKZFeiNRtbKWLvX9+sMWG/Kim5xQ8?=
 =?us-ascii?Q?XVN8F0IeyHLrGSOrlggDtmW6yFkkbbUUu9BcEwzU5+bbUMN5zr6pbsp6kMzl?=
 =?us-ascii?Q?H4feV/MCRrnLb4kL95tyNn3nFnf3OxFxF1U74NahWCQJGO0CFssdKkFf7Q9E?=
 =?us-ascii?Q?gGiOCQyoiiDYlmKShnYYrxBhCSlvdx0MeuCEeKmBdkU+A95D80LWv4pIevYE?=
 =?us-ascii?Q?GBQeD+c6ecmcFzDFjt0Ugit+KMKssHL+OPJmWPothgZXHJZBX7K4PAdMC5uG?=
 =?us-ascii?Q?KQPfErpW1Jpbxs5BreVHWIjlcsaR/juVxPOu/311ysGQJoys0zu9oYbGup5L?=
 =?us-ascii?Q?/cUg67x8m5GKLqhTTreIlZRH3Mjja7P8GZKuxN6lb2k3Gj8u/D7wwMo0Qljo?=
 =?us-ascii?Q?8okTsIlXDKCc8F5sMGeOvQ5Kcjoz93VRSAofp4r3sgiRrO7+8584D2e/yjGD?=
 =?us-ascii?Q?cRDOXPcKVZJw5SgNqjW7Vn/g9/Xhr3BnaqDUh8YlYaZMTN6TCN7d7aaI14mG?=
 =?us-ascii?Q?7Ak9KQR8ZihGQZfwo/RTshdf8xy++OZ+J8U/OSUfvZyNX5PboQ2RF+nbfzhG?=
 =?us-ascii?Q?fRr3oZgC50/EecqQQ8afjQX2qzAwRYdYMgPYqFJyVgffOw+lLE6rtndjI+TS?=
 =?us-ascii?Q?yS7lFzND8p0yeec8rv04o+/8avK3PFw/BVY4dY6Sd4e3VxmLXJs7mSaKN7i3?=
 =?us-ascii?Q?QcRC83ORxOR3IYy+Q+udZVBoEpDGEOko1zwzjteKCeUdiANf1Vp0BUDdwsIu?=
 =?us-ascii?Q?+XP09P6yxM5JdVsvah4khjZnOPmSVcSeuCAaf+xl9c27tYH4/WC7JvxtorDP?=
 =?us-ascii?Q?j13qhUeGTIRf9sXGMffvdjWl0d+6SfE3wSl1pmzfp1K6sLgh2XVt42a9dR+J?=
 =?us-ascii?Q?SP3yI4NSI0IwWk3NGJSv2gezz2JBW6O0HY0h3+Rw5tROmKAeACBlRRE68Z/H?=
 =?us-ascii?Q?DxLpAkosdzWZBwAxbHT8iQXLHgHFxldXgpT4sE0tkWyAAUcHPZTwsFCitvVg?=
 =?us-ascii?Q?79lCfTxeaMHVRBX6qIpqHGSzYWuEvJuYqD961yHgHvybk1XqGVMMuGcrwwEV?=
 =?us-ascii?Q?NihQfd6GL4/3YTfiy2k1CCUIRsBV0dExYDRjVvoyVNDtzqGLLW1bX0HnQ5fW?=
 =?us-ascii?Q?itx1SG6qBBEV/TuaRaxbGDCmaD3nMHwwm/2ZNr7nQttIAAa/UDwH4PDTFTv6?=
 =?us-ascii?Q?iGFGymdSgQZqUJJIbG6RoR8E64ptXBzT1+qlv03h2E04YmTd8K5ldlphVwCT?=
 =?us-ascii?Q?9gJy7MjtdoKxoRdb2x6y4//XtcECYtfTl1s1+cwUTnUwe6MhHlLINTicPqJn?=
 =?us-ascii?Q?zHLDDUozNDc/SP0bAPEEDlhxPVr7YcjG5wpUKEcWpkH+YYl/aYcYn3AKgquK?=
 =?us-ascii?Q?UYAX0NuStSPRc8xDVLluXYCS/IDhTOrAYxWNuWge?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acc1f415-2de1-424d-8b7d-08dbf50254ba
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2023 19:50:56.4386
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jIjVdRjEAdT4RyM9stCNqSORoDD9g3E7JcLfHN02G0pJRbLEu4S8s+KuauY+U6VY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7409

On Mon, Dec 04, 2023 at 11:22:49AM -0800, Sean Christopherson wrote:
> On Mon, Dec 04, 2023, Jason Gunthorpe wrote:
> > On Mon, Dec 04, 2023 at 09:00:55AM -0800, Sean Christopherson wrote:
> > 
> > > There are more approaches beyond having IOMMUFD and KVM be
> > > completely separate entities.  E.g. extract the bulk of KVM's "TDP
> > > MMU" implementation to common code so that IOMMUFD doesn't need to
> > > reinvent the wheel.
> > 
> > We've pretty much done this already, it is called "hmm" and it is what
> > the IO world uses. Merging/splitting huge page is just something that
> > needs some coding in the page table code, that people want for other
> > reasons anyhow.
> 
> Not really.  HMM is a wildly different implementation than KVM's TDP MMU.  At a
> glance, HMM is basically a variation on the primary MMU, e.g. deals with VMAs,
> runs under mmap_lock (or per-VMA locks?), and faults memory into the primary MMU
> while walking the "secondary" HMM page tables.

hmm supports the essential idea of shadowing parts of the primary
MMU. This is a big chunk of what kvm is doing, just differently.

> KVM's TDP MMU (and all of KVM's flavors of MMUs) is much more of a pure secondary
> MMU.  The core of a KVM MMU maps GFNs to PFNs, the intermediate steps that involve
> the primary MMU are largely orthogonal.  E.g. getting a PFN from guest_memfd
> instead of the primary MMU essentially boils down to invoking kvm_gmem_get_pfn()
> instead of __gfn_to_pfn_memslot(), the MMU proper doesn't care how the PFN was
> resolved.  I.e. 99% of KVM's MMU logic has no interaction with the primary MMU.

Hopefully the memfd stuff we be generalized so we can use it in
iommufd too, without relying on kvm. At least the first basic stuff
should be doable fairly soon.

> I'm not advocating mirroring/copying/shadowing page tables between KVM and the
> IOMMU.  I'm suggesting managing IOMMU page tables mostly independently, but reusing
> KVM code to do so.

I guess from my POV, if KVM has two copies of the logically same radix
tree then that is fine too.

> Yes, sharing page tables will Just Work for faulting in memory, but the downside
> is that _when_, not if, KVM modifies PTEs for whatever reason, those modifications
> will also impact the IO path.  My understanding is that IO page faults are at least
> an order of magnitude more expensive than CPU page faults.  That means that what's
> optimal for CPU page tables may not be optimal, or even _viable_, for IOMMU page
> tables.

Yes, you wouldn't want to do some of the same KVM techniques today in
a shared mode.
 
> E.g. based on our conversation at LPC, write-protecting guest memory to do dirty
> logging is not a viable option for the IOMMU because the latency of the resulting
> IOPF is too high.  Forcing KVM to use D-bit dirty logging for CPUs just because
> the VM has passthrough (mediated?) devices would be likely a
> non-starter.

Yes

> One of my biggest concerns with sharing page tables between KVM and IOMMUs is that
> we will end up having to revert/reject changes that benefit KVM's usage due to
> regressing the IOMMU usage.

It is certainly a strong argument

> I'm not suggesting full blown mirroring, all I'm suggesting is a fire-and-forget
> notifier for KVM to tell IOMMUFD "I've faulted in GFN A, you might want to do the
> same".

If we say the only thing this works with is the memfd version of KVM,
could we design the memfd stuff to not have the same challenges with
mirroring as normal VMAs? 

> It wouldn't even necessarily need to be a notifier per se, e.g. if we taught KVM
> to manage IOMMU page tables, then KVM could simply install mappings for multiple
> sets of page tables as appropriate.

This somehow feels more achievable to me since KVM already has all the
code to handle multiple TDPs, having two parallel ones is probably
much easier than trying to weld KVM to a different page table
implementation through some kind of loose coupled notifier.

Jason

