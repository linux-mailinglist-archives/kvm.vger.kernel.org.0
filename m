Return-Path: <kvm+bounces-3863-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C89E2808AFC
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 15:48:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1BD31B21461
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 14:48:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6F0044365;
	Thu,  7 Dec 2023 14:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ViPTOjjM"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2075.outbound.protection.outlook.com [40.107.244.75])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4251C3;
	Thu,  7 Dec 2023 06:48:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mtQ+FLMoHhK3DnmFxP7BOuHS3Q0nb0waR0qPYPJ864cfhVqA6YA/eJqJYONCawVCihpeQIg0XdASLU7FqRER5b7RcJM5q0KjkfMLGN+rcWT7V7FdhjktmVAeNITm+q8C8uoXzKWedf0q6jT5Kf05ufpOjt9XFCepWnbF17Gt9y2twu1lgADI0K8uyB6aQGHWZT0P76JteDvzVP325RczrbZKN77WaKmRoC5uU/Y+HDavsX8dPYSwtK6IHy0pv/W4tDt2HqLplu4loweLgO2OR/mINwRgcFUqvGEI5Y1bjcdT0Wk4bGr01jeRTStDuyXUP32G1ia8gaEK62mtp1yKow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S2xv0u7Qte0VvrE6wh/6iY8jN3GCGS4/gAUdQu0eL/8=;
 b=dAI0V7KAhIEBO+ymMwn5mFwhz64A97nBRzrOnkYiZtUE0ibOyKpF4A8j6f14zZjsBAaT7oEapup1F4PekCyOZXxU+O+ikh3kNLcRyGO7aH/9BXSE1mj4bDFTzA8qXRdwbI+TQaFYq+GwDj0hjGj+YjJ5qyULkI9/BHzSedWsk0N5RQlzAjSnLTzhBZX81i4ebEtf/rjjsZgtwyfGChXyCCemlrlzkn42ShvG89IRuPMn2SQ2FVF4wlqjVVcf8qfyDuZ2HQUC3JX16kQZ3Ju9QzpoC0AypRcryR+dgUPWySC3YEuwNNmaIwy5xsp6O3/rBSz9z5Blq4PQP2BBfc5L3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S2xv0u7Qte0VvrE6wh/6iY8jN3GCGS4/gAUdQu0eL/8=;
 b=ViPTOjjMC1T8Ewq3Pbg5s/RYw9PeRbmFB+KT8MUeM2HVG8aBQMxpQzbgI+inuNf0HaiZSTVPIH6Pfl2gIwpE+yM6J86DMtAaJ4/jOC0rTlIs+L/ycAdr7QWQTuj6Gcoyyk7LvM9cZt12QZetC20clqwXVFtf3Mo9vW7K0zuVJr4ySpvLqbvcAYyLYeUP26PvoJmdEOz2/Lm32IFTwdvA6KpF7W331V5KWlu3JKuHZehzsVt7lcyttWVgROeMo8M5kAGi56LAyV3CcUskdaLX/jqJenaI+tK5AkmyaSXtXchfXQeWge+qCYrVdlKl4L7khWEws0ICicHe5/BWSE63nw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH2PR12MB4135.namprd12.prod.outlook.com (2603:10b6:610:7c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7068.27; Thu, 7 Dec
 2023 14:48:08 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::60d4:c1e3:e1aa:8f93%4]) with mapi id 15.20.7046.038; Thu, 7 Dec 2023
 14:48:08 +0000
Date: Thu, 7 Dec 2023 10:48:07 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: "Cao, Yahui" <yahui.cao@intel.com>,
	"intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"Liu, Lingyu" <lingyu.liu@intel.com>,
	"Chittim, Madhu" <madhu.chittim@intel.com>,
	"Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"yishaih@nvidia.com" <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com" <shameerali.kolothum.thodi@huawei.com>,
	"brett.creeley@amd.com" <brett.creeley@amd.com>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"edumazet@google.com" <edumazet@google.com>,
	"kuba@kernel.org" <kuba@kernel.org>,
	"pabeni@redhat.com" <pabeni@redhat.com>
Subject: Re: [PATCH iwl-next v4 09/12] ice: Save and load TX Queue head
Message-ID: <20231207144807.GL2692119@nvidia.com>
References: <20231121025111.257597-1-yahui.cao@intel.com>
 <20231121025111.257597-10-yahui.cao@intel.com>
 <BN9PR11MB52766AECA2168F37AEF6995D8C8BA@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52766AECA2168F37AEF6995D8C8BA@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL6PEPF0001641E.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:22e:400:0:1004:0:e) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH2PR12MB4135:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c3776c8-f440-445d-efbb-08dbf7338700
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	HJMVh3vp8IgjnyabVePEbXstGuddkOouz/SDEC8qKfGMo0n20VyrojwX86cX7sA3Rr7ulcUeS6RpiryKgNjon16SQELhDgWCAnSV5ggR/b0d3aAdui3KoBSLMSdvqO5uLC3BrX1YRGNvztD7v1eRuSXE3HsB3t/90PRg98iX9nEMH/AnR3k9KSSKqal/3Ab2t0EuuqPbY9BN6cOLIzCh/NbtFtOVqeQz4r6JTLNQOQG0TUufAnThLYZrJb0/Hx4ihLhmKCHFTAXkI/7lZ8XEUJF/NNgJC9bRMC+nLIpBffhJZzBu9Ra/Iw3Tu0TKPa7ANxqN/YiuIsDdCOQXmn/Tr5CnFdulwamzmCL7rP5G2ZyAtjWajYG4uuJTd86TnSE2HGy/hfv3ehoYbFEQOKEfyVkGpUF2WMVGiMCX4QNOnARumWugR+hf/Ykb0XvVRjwfGBqBikwFTYQj9IWydVRVk1phiaC2lh4g2o9QhPs90ZPzoorZbz/bDMsfJvdMK/5Fteif20WCqhjRtVMCXBLl52EcfC3uxunt2NedhCc1gwqMy28JuUdLrkznfmzJUGmW
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(136003)(366004)(376002)(346002)(230922051799003)(186009)(1800799012)(451199024)(64100799003)(26005)(83380400001)(36756003)(33656002)(6512007)(1076003)(38100700002)(41300700001)(2616005)(2906002)(7416002)(478600001)(6486002)(6506007)(5660300002)(86362001)(316002)(6916009)(66476007)(54906003)(66946007)(66556008)(8676002)(8936002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?CXYq0f1nzF7EL8LVeISIm6wxOgc/Cz+aGlEArCxXcH+5qIokQhRC0qHf03xi?=
 =?us-ascii?Q?ET3H3KLVyvAYnzHDMMfEFSJ8/j4JNSBT2NBSViEKacLzZRg87PdJuBmkhC8J?=
 =?us-ascii?Q?zGPimeAtLSAGyUYqBB/QJlkABu2YJGhxtqblVZoEd2s6SLiXyRMrkxGEdkvq?=
 =?us-ascii?Q?k1+uzM1sTFEmjKrspB8YPviM+Z9sIG+HcmH0xxxHT/qGGwZL3obUwJaFZcnG?=
 =?us-ascii?Q?aul0LAhRqL3SKHJvOp2hI4Io36BRucH0fyv+Bi39qUk/0XEBhS/pKmjycfhl?=
 =?us-ascii?Q?clxEjK8jTvjNDgESYlSsFnqc+55/0kUz38DsNtIVqwKTxGl69Xd/z5jOxW+X?=
 =?us-ascii?Q?Mhw9Gqa8OvXyCQD3Pb8XJSwbg/tNoPjhGPywYKj3ezO7lbOV9GeQMVLWPIlo?=
 =?us-ascii?Q?Kty9gTHHdG6zuE0RZixv2SwDX3ILtF9Bs6A78lKlNr/aJoXYBfNFvUf1yO/o?=
 =?us-ascii?Q?BSaZCMx7AEvukPCDSi5G9z3ZghfYwo8sbllVjb+37Uf1bhquCt/5hZQGmgg1?=
 =?us-ascii?Q?vUADCwRn2OEaD0lscS8NPsaeS+zSslK8HOxMoltaATT6Xu208V6YT1MPG4XR?=
 =?us-ascii?Q?f7rtOvR+B3D/17bRPh6VdLrgmUrtWaU5qzjGJdpWXCIuNRP4rltgF3CnxlXq?=
 =?us-ascii?Q?G7b81VJeDGiCkRUpSu/2wLyCwrCl0lKsGd65y5On8Uu1WcdXrfyn9rOicjaF?=
 =?us-ascii?Q?t/q7hAw1U/ccZDCOcEKPzL6U6qwlcMsRlLOh29ePYsJKuhpBzUhPgoVV91FF?=
 =?us-ascii?Q?FPwt9Ab/96YTOoUDP92fmINdX49ZeOvAfeFSAK3V6fQFnkizZXR86s882HEG?=
 =?us-ascii?Q?3VRbAKCFyclq7N0/vyb4Gy1CNoMTN3dVtlpD8xjDqaHqv+1gAMmPLyxufl8B?=
 =?us-ascii?Q?R/RPdC+8mmE9amskPU8I3uvpkct50rAwBGyeKZiZvWDH+LA61IKddGf1a1cK?=
 =?us-ascii?Q?d53dvOJR04tzA1tTUS8LUigAVtWgDnRLpFbKAYavODkKt2kY9Y+lrLY9c5Gj?=
 =?us-ascii?Q?MqBEeEE4uYBRLiOw0+fEYjXrg5yGmy3YlVPzOq+b7y3kQUbm5AkiYCyG4Nte?=
 =?us-ascii?Q?X0dMrSxB+0j7wg17LAnt+1zkS4myLmeFF4kBWsyS96vR/bxWChqHrDY35DfL?=
 =?us-ascii?Q?5gc1sxxg59EfSwWQWK39tUEtODZPo0tbe51ECJd/d9nfVLfoBZp2qWSUB6pS?=
 =?us-ascii?Q?bLPMfqDI0CUQY9EYTigNhXXqJVMqcH0aG69xnewy/KxQAcdVWl1AA8WKZRjK?=
 =?us-ascii?Q?J5UsBT5rJe75lBtRRt3aJkrSMi5oLHMxlrxuab/9G+D+03CzBGIfA6kMheDr?=
 =?us-ascii?Q?EzkISXgIEQYcdXYqXTq25CUOkThI/+Et9D45c5K5kygTj9fPZDoPNf1xmUPK?=
 =?us-ascii?Q?8Y3Z9n36ZDKjXmM97f2dXHec4LCceBu/a7nOWqwGaRB9pCdzS9I01Qdr8jK/?=
 =?us-ascii?Q?soXKTBqEa6Knr543w3/t3KGGwc1Fc0V3cHhlZ06of3QFodZUQwq+mH5jusSi?=
 =?us-ascii?Q?W2Z1VgeeGB+UUTwBQK8rPtT+XAUReO7ue/FdylKcNPQm01vd/pTcDFjDYoRt?=
 =?us-ascii?Q?ZtvVC2/x3DXhZJF7cTywnYgzjlLiwgTixbvLAwiK?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c3776c8-f440-445d-efbb-08dbf7338700
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2023 14:48:08.4890
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6bDvAYPIUSsecHRBpmytcZy0VUGNFjdRbvY1wXvUPM/OycMJNUrJzWSR65Lq4sAg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4135

On Thu, Dec 07, 2023 at 08:22:53AM +0000, Tian, Kevin wrote:
> > In virtual channel model, VF driver only send TX queue ring base and
> > length info to PF, while rest of the TX queue context are managed by PF.
> > TX queue length must be verified by PF during virtual channel message
> > processing. When PF uses dummy descriptors to advance TX head, it will
> > configure the TX ring base as the new address managed by PF itself. As a
> > result, all of the TX queue context is taken control of by PF and this
> > method won't generate any attacking vulnerability
> 
> So basically the key points are:
> 
> 1) TX queue head cannot be directly updated via VF mmio interface;
> 2) Using dummy descriptors to update TX queue head is possible but it
>     must be done in PF's context;
> 3) FW provides a way to keep TX queue head intact when moving
>     the TX queue ownership between VF and PF;
> 4) the TX queue context affected by the ownership change is largely
>     initialized by the PF driver already, except ring base/size coming from
>     virtual channel messages. This implies that a malicious guest VF driver
>     cannot attack this small window though the tx head restore is done
>     after all the VF state are restored;
> 5) and a missing point is that the temporary owner change doesn't
>     expose the TX queue to the software stack on top of the PF driver
>     otherwise that would be a severe issue.

This matches my impression of these patches. It is convoluted but the
explanation sounds find, and if Intel has done an internal security
review then I have no issue.

Jason

