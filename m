Return-Path: <kvm+bounces-52288-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E486B03BD8
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 12:27:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A358F17A32C
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 10:27:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C25324467E;
	Mon, 14 Jul 2025 10:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LomcdQ1z"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CA97242D9B;
	Mon, 14 Jul 2025 10:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752488820; cv=fail; b=mU5NEMxbAkjXyyv7tniLqg2HYGqFQgV3gM9yM0jotN2ZJRQJXRME40T1spBrs4rHjKzw78/dkA2JhbB0vdpRidjtmFnnmhNNdkaF0S0bvf5PXgDAV7R9ooULcwFmGS7GZpZqIYi25C6bJfY8J2zdCtMWj30kKRXb/nATZRB/CY8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752488820; c=relaxed/simple;
	bh=Xw+jgcYkEKtIq8FqIsnCh/oFA46+yekl+2QWZ/f2e98=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=GrIb0qIoXCgnhGhuIG/c9wYw0RZSMlTJ9wYe0JErFGQrw+DfCOoMRAOCuzECo95W9q1lgFDtQ5a3QfF5LZaF8C85F/+4lgxY65eJ+1xk6YQy4uA9+WE2TuMfTMKhibePSU+uxCI69+d9nfql3vf+Zhw3ZP6E8ZBcXT/DtWbeb8A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LomcdQ1z; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752488819; x=1784024819;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Xw+jgcYkEKtIq8FqIsnCh/oFA46+yekl+2QWZ/f2e98=;
  b=LomcdQ1zZGiOR+sE7fp6abnCVIGap6q+lNHpSIr/q2O9Ip+DmQ8OicoH
   g7o0tQ3mQurVOeVZlNZ/l6+6aFXoXODNUkRXr96p6fEQXLzoz3ufBZ4Tl
   rN1O0YrHnAj9n4+WPNV/tgi6mgbvOlEAv5tvKFBlkmrU8ORggl9p9nUPR
   Bo2XrbIrJZsvm38TgiWLtsbPOc6FXZkkjv2Td5lEtl3FLGTetH0Wm+Lhg
   4+kI9MzRRQ3YE+yWL+JDXQGHD6pi6oi/Hrn0KEMm+Rr+Iw9rnsv9gt+ey
   KZlvPsqMNq5Q+T2UWlQmpwt/erfvQCgaZ0aYzINmwDAgXWbEKTc3aBFy0
   w==;
X-CSE-ConnectionGUID: ScacFIfbQ5yLxeXKlFTZkQ==
X-CSE-MsgGUID: 5ERM1z/cSpmNKM7ExOBiNw==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="77213546"
X-IronPort-AV: E=Sophos;i="6.16,310,1744095600"; 
   d="scan'208";a="77213546"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2025 03:26:57 -0700
X-CSE-ConnectionGUID: Xlw01pOFQiuESHUz1f8psA==
X-CSE-MsgGUID: S0f2iylJTOS+yh/hGOL2Tw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,310,1744095600"; 
   d="scan'208";a="180589355"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2025 03:26:56 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 14 Jul 2025 03:26:55 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 14 Jul 2025 03:26:55 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (40.107.212.89)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 14 Jul 2025 03:26:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yaigZ/XLzA5BR8Dwm7O95YiJ+rIue9oCyJI/GTsJwk5isZzJiktB6ILCF/Oxr3fXL7BkVglKDkiW/prFbj43Bpowon7T/nXEoOLgmGqr/rIn55YrqGSNTWKZKVrBmb/VNg+MozOX03NQzYkveFb8ZVj9hyFlzvC0ati5E0lL7vgJxE9wjz/3eAOJyaF2UzrAsZZyduV2s1XSAtnTSXO4ZD3vlBPfaK7VG9IF8fOpQqbK84dKUq0pzJnuyYduPVKE8E3FYqWhmP8QaFQfzYURnp12NfvgUc11PnHGhzTmsO5EaOt4x2nqWQ5mZ5UfYJTHefizLJhohzJcgFzzl32g/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SfzOcua2p8+ajAaULbrMz1XPjsi1VjdIX2yRLydIS48=;
 b=AxbURZJ5DcuprtX2JxT/rd17rH1V/ega8W0X83OkJmyrOY+0DOzygCHgzB+E+RzMA/ntYuLCrti4bn820JY75uWnnJ5WNYiYAH/BRVALSANd7R8jOPMKOXu9fMKyDs2DinZCbzCKDUxOgq+8so3njSCRz/gfb/73NlJCKApn3Z8u4QxPB3efikUUYgkiKKAjgOQZlHowsUK+WvjzW1/bTBF7cy1is9QeeT9msZ98VIaUOxrql1iw1KCvCa0MC8s43X2CEdqHVxE2mKLz3vGLyC2CdlotDqHX0wQOPxfh7gX2Eh4zg9I3BG2LzQ02w/2PjVZBQ74vG+UlM/akv7X7gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by CY5PR11MB6281.namprd11.prod.outlook.com (2603:10b6:930:23::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.32; Mon, 14 Jul
 2025 10:26:39 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%6]) with mapi id 15.20.8901.033; Mon, 14 Jul 2025
 10:26:39 +0000
Date: Mon, 14 Jul 2025 18:26:26 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: <linux-coco@lists.linux.dev>, <x86@kernel.org>, <kvm@vger.kernel.org>,
	<paulmck@kernel.org>, <pbonzini@redhat.com>, <eddie.dong@intel.com>,
	<kirill.shutemov@intel.com>, <dave.hansen@intel.com>,
	<dan.j.williams@intel.com>, <kai.huang@intel.com>,
	<isaku.yamahata@intel.com>, <elena.reshetova@intel.com>,
	<rick.p.edgecombe@intel.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar
	<mingo@redhat.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	<linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 00/20] TD-Preserving updates
Message-ID: <aHTbUuF6VI+VdQKH@intel.com>
References: <20250523095322.88774-1-chao.gao@intel.com>
 <aHDFoIvB5+33blGp@intel.com>
 <aHEaXYmeolKNCqgk@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aHEaXYmeolKNCqgk@google.com>
X-ClientProxiedBy: SG2PR02CA0056.apcprd02.prod.outlook.com
 (2603:1096:4:54::20) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|CY5PR11MB6281:EE_
X-MS-Office365-Filtering-Correlation-Id: f7d761e6-a9b9-4336-ce29-08ddc2c0eb55
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?QQLZXp8LMquYJj2fGqfJuhFlWQWZ/gjNwVd3XWa3O5l/RtO1c+rJt+plFgFM?=
 =?us-ascii?Q?0/1ssSdUGvnq0sbYbPUQKKmGSM8NiCRue+ee6Xn8j//fpcExkZsj6i6xPX44?=
 =?us-ascii?Q?omrHrmkmQr6Oi/6rXKawLC/j+WqmYSNXw1nkNXiX9XpuVsXrSP11yhNk/v0P?=
 =?us-ascii?Q?SUCmx7adOLne5ia/2quo7mL5wVOxdKPDImxRNRUXawKxW8K8Q8Y0DvSX89o7?=
 =?us-ascii?Q?XT3j3p9YNPqyT9Pmyf8ISiBLYMP8wtox2q27QfCwf0qyK1+ExzEuXh1ztAzg?=
 =?us-ascii?Q?xr5g5cZtW/P68ag9Gjvv33obz4IR/T/4mXycPo6lkLX6Y5ywV75dPMAyXctL?=
 =?us-ascii?Q?KwffyzS3WRpLW0lk4YFhOPgjz3r6wefmfZocV5Stx1aljWIzDlygotkIx7KT?=
 =?us-ascii?Q?yrBf2Tyyf0MaIBN5O7zo7PZ7cm/CdD/DDq9zTl8uwwMZfveBMa2b1EQE6EOI?=
 =?us-ascii?Q?zX+S0pry35gnfcLjAHDKCu0a72/AGoCv0MnZxTyHvyxe7hqFmKc2cfSErHTD?=
 =?us-ascii?Q?4fPTWz3Uc6Ul1X+IC6eUzETDy8aJzlM2q3/Xz1ugs2Z3V3p9guocdcZXUa6L?=
 =?us-ascii?Q?Nmf4iMXImVQ0HE65vQH4vg4964XcPY3mFsaPyRyjd58Sa50HHn4J/OJN8+pr?=
 =?us-ascii?Q?/Cnur+KVcZFBAzeJ140crGB6w8BFZTC0KQU0QqsRKXDCp3jIjdSPeWBzghs5?=
 =?us-ascii?Q?30ugCtxgHb6M/vFW84HMOxqfGsanq9/Xo0v09HrAGhG+tkSZ/qYQH4h8lrct?=
 =?us-ascii?Q?FacPJfsV4ZL16e/dYHFSMpnIj9JrrpRZIbzxTao2zpL3t8PG4rbaIDYwubN3?=
 =?us-ascii?Q?YLgvd6NpAW6+trMM6S+pfpMg+JFTRZ3xuG4fqsy3S43YgRhNl+79YHiYPSoK?=
 =?us-ascii?Q?dUYnMDZZ12a1e5pawMZ99KWwXAx9NuVsWslid+qh8VptlMr8uhSEepNtDndu?=
 =?us-ascii?Q?OTt8R8RE6FS/BKBnGV9SVBlLpIPm/oG7nRegM41dl90G7nNKg/H1aTgLekde?=
 =?us-ascii?Q?sQj6nUPemQ8YRMxVY+tzSA9NLG87hcnLTKeMLaVGlFl+RIahWl3GCcGTk/ip?=
 =?us-ascii?Q?AHOyLG71DYyk1mTEkSgM+dMmvgRURm169NC0D2ZQ8MvbGIsS39/3zYGQx14I?=
 =?us-ascii?Q?zDk6KcOIPwo4C9qftmVj51KZKmt0b2+TULb+5xEm9RfZ9RuB6tBf/mK/jiKe?=
 =?us-ascii?Q?PHyMdaQo+/u6JeEBR/iDQZcb+1amEo8++MX52SpCTj8t+PYsi9Wm16DctE3/?=
 =?us-ascii?Q?oDkjH5dvdM/OM0SUwAf5Ln5IjvciFNvGccbiGRcJcMyexMrcElkGAtwlP8iJ?=
 =?us-ascii?Q?VifB1xsgAdvtQrcL7jOMAn/ObJ1imN96tIaTl4K82ifgqwFi3ByFuifu5bM7?=
 =?us-ascii?Q?SZo/gVVRE5hOpemjFfr7odGj5nVPeHI4u2nBEvhGoJFUEsVaGcfZwyNCxMQ2?=
 =?us-ascii?Q?yZ4c7NHYPFs=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?scgNpMmnpT9YlfKU3mOJ6eRGE2Kf8dji9Xy3ZZQTaqDyojdU87bDDnvYuctw?=
 =?us-ascii?Q?xELMOhF4VhChNQUIs3kvBbJcsqxGF25EEDTS52KdgbFeSqNbHHMYlwHXQtjg?=
 =?us-ascii?Q?WxLUYlEqq+E86kAB2gfeKwgXd9MAWSFAYPbHgbsokbGgJe5zAAhw9GZG9fHY?=
 =?us-ascii?Q?uqzoa0ci76IURrQonJlczcv0Oxl5APDIyQTdmRDk0KNyMGIy3AImJpu1SW/f?=
 =?us-ascii?Q?9RFtkUagM4am7RjIvf4c5ZJl2bGwQCtv8D8a7srXnqNgx9lrTQmDyn6gRNgQ?=
 =?us-ascii?Q?Gc0x87lsavYN6lWekp8yKqDUSVqPfCNXY4iXhvsBokYyL+sTmp20vop61wOQ?=
 =?us-ascii?Q?gLcLcVtLfyS3FYtmvXql5kxokPvuK2ugL3TCgf135W0Vz/50MWENnnrzPKKu?=
 =?us-ascii?Q?+eWbbwQo2cCQD2s34BIQr/oEVVbtusDML2Nh0NVVQT3q15TSzJVHFHAEw37m?=
 =?us-ascii?Q?MhiUbSJpF7KLl6B6Iflrk/+JA5EvRgpgssK8hulf1292pMDnfaBlyToc1kQc?=
 =?us-ascii?Q?h1CbDRUNtf2f9qmJKIVtjb5PKoHzTnieM8s+XvY7ntsb9p6VqG7awRFGQqEz?=
 =?us-ascii?Q?jAoXhjMNqopehapCSTFXze2yZjVOY5pe5y1dwmnp6N9e+J09BUogBpci8y2N?=
 =?us-ascii?Q?iUyT+TaV3YYd76WqVPoyNg1orc/eOlYNR6shgdzShFDCrDSJpWAvBzlebguV?=
 =?us-ascii?Q?E8xyGoEwXd29IBaCX7s+4gba8jEEe0iOPIgKuIgEqLlPqc3FOcQ03jvtpxgc?=
 =?us-ascii?Q?QFF9IEoIjwN9p9r0eAkXOkqOfFFSQr3b2088os2nfY5nDkmjCeQZnEyG8S5o?=
 =?us-ascii?Q?QizF4bRAGHcHVvg6G1YSeF2ig2ecwssXcxg5DUhqmBiyMfzYDVGt1tRAb4Xz?=
 =?us-ascii?Q?v8oZwr5ExNQXn0R1BE07PizS0lSoEbjpdjioPNByYG85WPhOs7QTd0QAgxIG?=
 =?us-ascii?Q?DXZUCQNgP3dMLYTdZXbvBbPMO4v8W30ES8slj2oRH3HckLGQuCRgPYKBEz8c?=
 =?us-ascii?Q?AprHR9xY9vriwpvMvWBJjKDc25Y0vYd5wE/QdrjVSwNUgxKrTp2GY+GydQj7?=
 =?us-ascii?Q?mK3Y3Lh1mf29UQvYLVd68MiwtifUM1yKZ2Ng3+wZ+oHTvt/lUc5aAnuaQ2yb?=
 =?us-ascii?Q?hzHuY5cvIx8dopRrnwbvIMNsMFvzFIJ+v5/oIsPjTKW6oDh4YF3mdyE1VSbo?=
 =?us-ascii?Q?NI/pRKLx9RMb7uGLBmKA12v2Vgq730zLmKm3u4aASUTZ6ZGst+6vanhkm/Sy?=
 =?us-ascii?Q?REYWaq/kkTm4YUqkDsGV0MVEWFdEEkFkAfu6yGjboCtYRiMC0FO1yIIZsr9O?=
 =?us-ascii?Q?sleZFxLaHh0zFZ5Kp50IIhZ3YznjwdOTrwjE78N9SzTCqoVSTssdfA9sVZcT?=
 =?us-ascii?Q?JfbUEbGcTWaltoT4oev7Ewgn+CR5FQBuxZtOD4BFiYgflu66Qn6KnK0ruztJ?=
 =?us-ascii?Q?FakhIyJaRx32Biw04iET6TnjQmiIhpeE3AufT8MLckYGUDaTeIhwBq2QlqcC?=
 =?us-ascii?Q?QCSAP97xbHu9z3EpKy02vTIstMZ41rjZU+VqzEsnhKDueFk9hrcDEGA21FYh?=
 =?us-ascii?Q?yvWtf1CViaTUmheqmg7kei7yXM6cPZcFLOzQLlMu?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f7d761e6-a9b9-4336-ce29-08ddc2c0eb55
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2025 10:26:39.6670
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7JQIfZRYTpqttvYDmJ2psBjKDRjyK9HzrAjeQiSL3wdgOXKxkZLHWi+8BSr6Ha6xGOAOQk7YYTPR5IRW7pmqCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6281
X-OriginatorOrg: intel.com

On Fri, Jul 11, 2025 at 07:06:21AM -0700, Sean Christopherson wrote:
>On Fri, Jul 11, 2025, Chao Gao wrote:
>> >2. P-SEAMLDR seamcalls (specificially SEAMRET from P-SEAMLDR) clear current
>> >   VMCS pointers, which may disrupt KVM. To prevent VMX instructions in IRQ
>> >   context from encountering NULL current-VMCS pointers, P-SEAMLDR
>> >   seamcalls are called with IRQ disabled. I'm uncertain if NMIs could
>> >   cause a problem, but I believe they won't. See more information in patch 3.
>
>NMIs shouldn't be a problem.  KVM does access the current VMCS in NMI context
>(to do VMREAD(GUEST_RIP) in response to a perf NMI), but only when KVM knows the

Yes. I also think the guest NMI handler is the only case where VMREAD/VMWRITE is
done in NMI context.

>NMI occurred in KVM's run loop.  So in effect, only in KVM_RUN context, which I
>gotta image is mutually exclusive with tdx_fw_write().

Just a heads-up: P-SEAMLDR may gain other functions and be called from other
code paths, but they won't interfere with the guest NMI handler or KVM_RUN
context.

>
>It'd be nice if we could make the P-SEAMLDR calls completely NMI safe, but
>practically speaking, if KVM (or any other hypervisor) is playing with the VMCS
>in arbitrary NMI handlers, then we've probably got bigger issues.

Agreed.

It's a little late to change the CPU behavior about SEAMRET, as several CPU
generations have already been shipped. Implementing new behavior would require
a new feature bit, which could complicate the host kernel code because the
kernel would need to perform save/restore VMCS conditionally based on this new
feature. So, let's pursue a hardware change unless it becomes a practical issue
for hypervisors.

