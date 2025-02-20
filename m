Return-Path: <kvm+bounces-38626-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B2DFA3CEEF
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 02:53:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 729113B8186
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2025 01:52:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0FF91C5D67;
	Thu, 20 Feb 2025 01:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GgRCrzkV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B26D328F5;
	Thu, 20 Feb 2025 01:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740016365; cv=fail; b=lzHbwo/rqWhmbF7CvCWObuLRn9+OTW4OjD5vFemhzfW3QcjXurJKWTfHhppjLZBraillbKxIo49df/TP1lCUS+iSA+g7Fp2MoMpYNjSAsgaye7LEyq57kK2I0mMKzFFyD2bx0homY2xfshuxANERxb4//mtMZIaBNsVbXCWIRvw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740016365; c=relaxed/simple;
	bh=SoODUZozToWlQZF0V9V62IJSAzAcWww4dChkIQY5Ya0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=SVeb0uiYer3wu7PmZt7HBBfKJLQ6tutbYTU4dhaUTMZhoMddET+KA2Q2cuoIJbtJm8WY4NBEufJtPAznkXgi+Gcp3EMxkHGDvVny4eIouDhs5aR9Db3VUCrqiHCMLmMIc3r0LkuYVRtV+0bAWAAHqmX16YpIA159hI3UltLdvZM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GgRCrzkV; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740016364; x=1771552364;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=SoODUZozToWlQZF0V9V62IJSAzAcWww4dChkIQY5Ya0=;
  b=GgRCrzkVdfWauvX29Wa942urfjOGJDJpoZ2ILyyt0/uU0Mhr6XWfqTEV
   64WxKxXHxyhc/Oaft0IdtBiv4AAHFWK5R7AYN4MvSpssEhdO3PjvzoRH7
   4QO0Lu4U76e+J1k102fPbz0Z1s2YeBrjTW8YbyE0YNZoaSV9ZUTfWGvDm
   ImdwhhJP8YJJiXFppfHSeb+fQa4nbgZSfWMz8dlR/VedQqYQl8vdwrvbl
   6Sl0Om68wips04OdUHc9Xrs51mLGtGXuB3zNmC1OLSEWkNAahRFKKA1WR
   AEa9+4u7hxlkkfEiKGuKr6dKZDg4ITAWN9/vgyVhDJ1fG5L4JYdLZuO2X
   A==;
X-CSE-ConnectionGUID: aDDfcQqdQLuTKqpsYRgLvg==
X-CSE-MsgGUID: QBAb3LsaTDi2BnO5l3zr1w==
X-IronPort-AV: E=McAfee;i="6700,10204,11350"; a="40011126"
X-IronPort-AV: E=Sophos;i="6.13,300,1732608000"; 
   d="scan'208";a="40011126"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2025 17:52:43 -0800
X-CSE-ConnectionGUID: 9T8fwlF1Sxi35Og3fjMQ+A==
X-CSE-MsgGUID: 667fU7wtQh6qR7ufIi8bAw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,300,1732608000"; 
   d="scan'208";a="115091785"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2025 17:52:43 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 19 Feb 2025 17:52:42 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Wed, 19 Feb 2025 17:52:42 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.49) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Wed, 19 Feb 2025 17:52:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uQxN22uS8ZLkGuXCmE72EzU4y3azSUdtkRiOt9ksiCGoebXbscv3nFwAUU9wSzPXpmChb0uIbKjOuuMYQChY3wLr8WmNRmydgvT0cjG1RekiriGk8+UkJYZCRreWvkcrgSKEdW7/iUYlnQbxmr7YpzvRphkiVWmOrgEMDlNHEk1UkXQWLliLol536heBTvKOHCgxVCsOwClSxuvD4RoPDQAvp31RDqNGWyC4t7P//5YOsBwYP2T+R6c5b+myKePwGJQB0gThl2hz/ht9OCT1rFyd3EOwv2ZV2JlY9xgAioE9KgiCOkEdFrv42qKvC/0DuqXDMe2Nb+T3FyOEEzPsRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IIGBP0gvB3pjJcdDglSuzmUNE2Um3bjVY1a6csVNQSU=;
 b=bR5eun7408La0vTEfLPB+ZCJLC9aGx5pre5Z59/dHq0hrWRrumTkqthMMCof9kARj2e/28D5zHbrPilPST+AdPNcoO54LME34cK25BWcGwB6w0jq9AVeAuE6UCjjF7GCqd0yLJJGSJP81xCao26Zs0wVmdV6gEVq6e+UpAXdmiGR5Z2W3yfDqo+x1fmGBXEIgoFOAncnK155TxzQzPZ+JuUUGkoRciWz4fRw5URFtamqR/mAEiixj55BlVtyhRjn9w5LxURWJ9YdI3No2Nclg9MH1/+Rf96+vfsB7WIp5xtSUKjHrNCy2h9zWf8qMu0Gqr3nMfBIC4lAKobnMzVzoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CO1PR11MB5044.namprd11.prod.outlook.com (2603:10b6:303:92::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8466.14; Thu, 20 Feb 2025 01:52:11 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%4]) with mapi id 15.20.8466.015; Thu, 20 Feb 2025
 01:52:11 +0000
Date: Thu, 20 Feb 2025 09:50:58 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: <pbonzini@redhat.com>, <rick.p.edgecombe@intel.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/2] KVM: x86/mmu: Bail out kvm_tdp_map_page() when VM
 dead
Message-ID: <Z7aKgqZVq4BvsuJ6@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250217085535.19614-1-yan.y.zhao@intel.com>
 <20250217085731.19733-1-yan.y.zhao@intel.com>
 <Z7SvbSHe74HUXvz4@google.com>
 <Z7U/IlUEcdmxSs90@yzhao56-desk.sh.intel.com>
 <Z7XoQU-kEF8osICK@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Z7XoQU-kEF8osICK@google.com>
X-ClientProxiedBy: SGBP274CA0023.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::35)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CO1PR11MB5044:EE_
X-MS-Office365-Filtering-Correlation-Id: d3cd9416-b290-4973-4c10-08dd51513127
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?7z3ZaMzChpmFZNieJb10fHcUM9dY3wfEOQmcGNK+npCcUTMXHtuvhs+Ns+ht?=
 =?us-ascii?Q?FrnEBD84rM45vbyJoutVPePjZBkVmzkicVLeWlrKMKU0kfeUL3QRZW1sDfzT?=
 =?us-ascii?Q?+tVA7Td2j4moqsJGs6G80RNoBMWOCxC2U8Dph5bsZLT4pe//ygz9kpjCvytd?=
 =?us-ascii?Q?PS3PC578h7k+d+ZqqHMqI0SrM1DrgCbypQY4ySFtV9vjDZoL6hAlgR3WBke3?=
 =?us-ascii?Q?59qxfAgoT8nPdhiucIQfqMyOHcLQzUt9AlGPKTIEw3rtRq2pghGYn7jhlEoD?=
 =?us-ascii?Q?4MFU62xiZzj4TiEm1hHyIC96CXDPIA2yxK4iBvIBTzUwQB1IcKaoD8VJsTEX?=
 =?us-ascii?Q?BcYDoVmh7NQlE2o6phKEW2WORsgeS7cBvabMpUsnCwBLCRsO8n4wJ2b00ieb?=
 =?us-ascii?Q?YhWOBfuciPt0GIpiz2CAXzEPiYlsgXUo7shsx5MiEa6Iyy8OPx+/BoHu/Nk2?=
 =?us-ascii?Q?iLkMMEcwkHPPLaPFPbrz+vEoN7l58gkswtuKBNv1/z3jNs5eAvdYRCsfFqHO?=
 =?us-ascii?Q?fi3J/CMJ0Thg77iCa45cQrlRdsEOfh90+dtZioBx7dd7gTDbVGJ0aSNPdXWG?=
 =?us-ascii?Q?NrL1kEXKS7VJB278Y8xj/L1lFdeMJrYcqRK9n0OG/pGYDfhDCJLdrqSCEtRi?=
 =?us-ascii?Q?gzSD47m36/UjNruhya2FqP75R2kmnV0SoY11SpprZDLtDCkm50iSoGUcEdn+?=
 =?us-ascii?Q?52QgxTv7hlHT5F5nuKGqkuHc3ss/lMGChLFO86FzJy6IIwY5L2XrObhTmBgZ?=
 =?us-ascii?Q?QopzxpnrKwJaZYtGZ440PgasfloIJg2LUrsEvt7ZtBg8UD+YKEPYizBj3tZH?=
 =?us-ascii?Q?NhHPJdFxb2Uffo2U4ZP2BtStxDgNHg54UY/0QTBNXYJu7DNevZC4sv5+8x2o?=
 =?us-ascii?Q?s32+e67BWWvwSRyEP06PyentGJxkv29sGt4Rn+ah3htjxXLdTxv3qKtRVplS?=
 =?us-ascii?Q?AFIl8MHqT38B3W6+4G+3DxdBmMCDdvRD3ppl+oLnBnRXxFaaJ1iYyOhYn0XC?=
 =?us-ascii?Q?LOGktDRiEBgeT9Dh5aZ5ZW7rR7htrF7i+Wl/93Ipdzy77tSKqgBKJ8UJ9HIQ?=
 =?us-ascii?Q?nkuxoF1To4IggWFL8T1WlipOgodXetJ7x5jaz8oNG9rycpDXPsd0toyoqK7o?=
 =?us-ascii?Q?HNmkxUmOmi054V4CK+p2fE/+genIRUQME1CaHBxAsVoVXzKtxh8E0h8L2fQQ?=
 =?us-ascii?Q?9wmqixb4SiK44j5mBb4efSuPRD3QSj+EqJRqlkv+f2G78Hz3OMv96MxA2uYk?=
 =?us-ascii?Q?EnlrRP7K5hCRSPK6hPLXmjXRBPc0QJ7cFMkxeXoaLAno90HatFr/Scvs2GSv?=
 =?us-ascii?Q?FkFqvFTEjH7vh6xYc7BSGB56k7d1f3MOzsnOJjsxFjYxbyFOAymw+BIEoqc+?=
 =?us-ascii?Q?o51aYh2SLTH7PmzkZdHNJWGip5V8?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xeBYjaWXB+tAzuBd/Y5htFgwBHMHpRZg6QmhimnHRCriFpAIDcwOHWhcWXhP?=
 =?us-ascii?Q?t0wkGbmDsSkUEN7CNGp/noopuPBMkzARUV7JJhZY6brhNZXwfMkb/B+IRHMS?=
 =?us-ascii?Q?t4IHkA8PuDMAiLHkMkoUA3SNhn28RKQF/5olITIxqrfyjZOPMDIffbEmMA8X?=
 =?us-ascii?Q?Rj4mEu2IaKJC6DxH5lJRG9ymRTbYfbqwPpYDACPwFLAPMLeAC4HkkIUU/IQP?=
 =?us-ascii?Q?UmlLBMAEDuzTfIwtGMnbCvRV/tKbz6/96pN2B+jKV0/vGyprWEJHm7I8GdQ6?=
 =?us-ascii?Q?vtUEMDxnoEPY5qZFGfLdTBYlZ2ml71zsWMIa6EhAW1fTqYdrwTenE7L5COm8?=
 =?us-ascii?Q?4KSt5CG4dXdiTf907+B0VLxP8L20Gu52SlSV3cnWBNpocB2FhNnXEtOOzJMs?=
 =?us-ascii?Q?w0I3EfoVQpSBIa4SGue+gEm9aTMycN22qiVUYErIBcgIj4WW8gMr1SlNrx0a?=
 =?us-ascii?Q?7Iop9vkvNPcbEqRhwtmg8Veykwc0awq4H9FrzYv+FUQW4CLoFxFkDgXrMkJ0?=
 =?us-ascii?Q?xTrqeG5RehhhkvCrgBKfffy7CQ/ZpOPoQPm8/qWz84piu3VGrV+jYqdyNTJc?=
 =?us-ascii?Q?t0iFGwglM50DEKsUNtqn1Md02MplpRg+oAjwhrqUHkfneKRuIyRb3xEcZWG1?=
 =?us-ascii?Q?6QFoQ+8ocvjHfknJoTNMQ3HerIOo4lbNg0APV2FfHX1Ukz4dh5bp9W38c9Ic?=
 =?us-ascii?Q?fqxJgQsL3lSZGEtGKRGpDraysknUXsxCs5FHtBFqJXppvi+H/i++ObwC3y//?=
 =?us-ascii?Q?toXt65gaTa60QB5ltv3jlwQIZmAjM7tO+/ZierhcpmY9ldcykWUAaJR85i5M?=
 =?us-ascii?Q?Jwe7ZA6BZuLdUUTpQ2fBVQ66Uc6lEmAyRC9+PwRZNzAu/1s+DlXEHxp2pz/2?=
 =?us-ascii?Q?o3AyksJGYnjLrj1AjhI5RiB5ZUokHB4n2Oz2oOPIRu8Pq/AD4qjqULG0fLPm?=
 =?us-ascii?Q?PKNckSFhVSvKHPVtdpA/OpvPVyINWdsB2YzQQduOXJ3/ZqlSQ+/myn7lkdtO?=
 =?us-ascii?Q?YGY8kNil9uHISl7/odGhCBwA3jYRPys9lPnlPcB34hWrY31zjDA49g7Kmdz0?=
 =?us-ascii?Q?LUTNykBBGCc5TaLdZhhXNAZ+ADH9wpdolDJ1RW0zREHwen5D6bRpmm1xlu2M?=
 =?us-ascii?Q?Hq4wJJvWxabYts3KhhKGs0Tr2CP7dJ0ezzSZB4knXra5MVmQDh0AMwEmEN/m?=
 =?us-ascii?Q?dvUJ40npDRl3WzkRjpOXRhBphPo9ufGo79F5EWAr6e5tggOtQKOkL5iTfUuN?=
 =?us-ascii?Q?r5fCXX4suVRpEv1vJfATQCyY7iNWVz1USiXNgyr9aV6ARF785Q7RxpZGPWvR?=
 =?us-ascii?Q?dRidv+t8fX39ZdDN5itrfI64bMrgSrriNEy1wgyFuZ5Q6CpBsUGtn6t9Bgam?=
 =?us-ascii?Q?KykGpFc71nOdoLDPazhX+BpfDehJCtrFUFCMN4mowpG+pGiXksbkIBTEbARK?=
 =?us-ascii?Q?bZZO0T3md4VdsmeSNcjUCuiS7RNdILX8i2AmxExtCx3IxiMwqYOM+4fMYh5R?=
 =?us-ascii?Q?kdLDx2nzjsl03DIRIfp9qTSTcVUw1KHBqVZ71LVGLfQbUbzL9QuorWCdw2ud?=
 =?us-ascii?Q?HW0EY57Xm1ZBi3l5+ND/TJQcvqnlqoCCIKeWBY0b?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d3cd9416-b290-4973-4c10-08dd51513127
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2025 01:52:11.6443
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vogWKnWVhzfpsouKYg3P2zQDF8dKfN4EoypQXqghh4R4D+cMw6xJgU/1DEVAdTtELAfyTW+H2eZfZapxqiCpow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5044
X-OriginatorOrg: intel.com

On Wed, Feb 19, 2025 at 06:18:41AM -0800, Sean Christopherson wrote:
> On Wed, Feb 19, 2025, Yan Zhao wrote:
> > On Tue, Feb 18, 2025 at 08:03:57AM -0800, Sean Christopherson wrote:
> > > On Mon, Feb 17, 2025, Yan Zhao wrote:
> > > > Bail out of the loop in kvm_tdp_map_page() when a VM is dead. Otherwise,
> > > > kvm_tdp_map_page() may get stuck in the kernel loop when there's only one
> > > > vCPU in the VM (or if the other vCPUs are not executing ioctls), even if
> > > > fatal errors have occurred.
> > > > 
> > > > kvm_tdp_map_page() is called by the ioctl KVM_PRE_FAULT_MEMORY or the TDX
> > > > ioctl KVM_TDX_INIT_MEM_REGION. It loops in the kernel whenever RET_PF_RETRY
> > > > is returned. In the TDP MMU, kvm_tdp_mmu_map() always returns RET_PF_RETRY,
> > > > regardless of the specific error code from tdp_mmu_set_spte_atomic(),
> > > > tdp_mmu_link_sp(), or tdp_mmu_split_huge_page(). While this is acceptable
> > > > in general cases where the only possible error code from these functions is
> > > > -EBUSY, TDX introduces an additional error code, -EIO, due to SEAMCALL
> > > > errors.
> > > > 
> > > > Since this -EIO error is also a fatal error, check for VM dead in the
> > > > kvm_tdp_map_page() to avoid unnecessary retries until a signal is pending.
> > > > 
> > > > The error -EIO is uncommon and has not been observed in real workloads.
> > > > Currently, it is only hypothetically triggered by bypassing the real
> > > > SEAMCALL and faking an error in the SEAMCALL wrapper.
> > > > 
> > > > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > > > ---
> > > >  arch/x86/kvm/mmu/mmu.c | 4 ++++
> > > >  1 file changed, 4 insertions(+)
> > > > 
> > > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > > index 08ed5092c15a..3a8d735939b5 100644
> > > > --- a/arch/x86/kvm/mmu/mmu.c
> > > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > > @@ -4700,6 +4700,10 @@ int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level
> > > >  	do {
> > > >  		if (signal_pending(current))
> > > >  			return -EINTR;
> > > > +
> > > > +		if (vcpu->kvm->vm_dead)
> > > 
> > > This needs to be READ_ONCE().  Along those lines, I think I'd prefer
> > Indeed.
> > 
> > > 
> > > 		if (kvm_check_request(KVM_REQ_VM_DEAD, vcpu))
> > > 			return -EIO;
> > > 
> > > or
> > > 
> > > 		if (kvm_check_request(KVM_REQ_VM_DEAD, vcpu)) 
> > > 			return -EIO;
> > Hmm, what's the difference between the two cases?
> > Paste error?
> 
> Hrm, yes.  I already forgot what I was thinking, but I believe the second one was
> supposed to be:
> 
> 		if (kvm_test_request(KVM_REQ_VM_DEAD, vcpu))
> 			return -EIO;
> 
> The "check" version should be fine though, i.e. clearing the request is ok,
> because kvm_vcpu_ioctl() will see vcpu->kvm->vm_dead before handling KVM_RUN or
> any other ioctl.
Got it!

