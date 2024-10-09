Return-Path: <kvm+bounces-28200-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 69D77996546
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 11:26:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BA7C6B287CB
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 09:26:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52EF5190685;
	Wed,  9 Oct 2024 09:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NH582tsb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31D3818E754;
	Wed,  9 Oct 2024 09:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728465859; cv=fail; b=olpGxqfuKaL6TBHqiZC4g2PXviPadsG4qZBo7FXq9zPWkkp1+hTRYzhhYI5ieNF1ShHwY4jxrfR+kvVAkXgJQRJk6fL4qGetRTOWxOIu5YlLzZWI7/kQjcRbhj2x6OI9I7/XOYOR7D3O+1VpQJKxaAuQ+50p5pfvbU4MXnN+sqY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728465859; c=relaxed/simple;
	bh=uyOw+QleugpBZpzovhwltTN6DFy8uWkSql5AhQhZ/co=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=uH3iSVy0HMBSa4UFofsu3aKr+3E8kF113TmtB4zPaJFxKCSQzDT0bLZijkqDXyZCjNJlSlSgNnE2uVpqC9kw1FpJJRnxU5zNnH6QKXWE9YvqDQ4GmbGDRXekDjvy6fD4N8hZmmouki192LBKt71yNIZiWqZVKkwJJnO88fHOCNc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NH582tsb; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728465857; x=1760001857;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=uyOw+QleugpBZpzovhwltTN6DFy8uWkSql5AhQhZ/co=;
  b=NH582tsbHwoinP3fF8b65TnCZQm2ZYwJjDjDACaI6dE8OoYwUJuoeyOa
   +Hj9FaSPr9DHiSramFwqHAz7FiJJvHJekXMDnY4MeGyBvS1VNuozXH43X
   1b4hkJUTh4a/sC9rWTtYIa+Px1mcRHHIYJjyP97qut4x/DnKV3zS8CllH
   5Pi3qtyj546+Qob3eHH2lqSe+xhl1GtU0CkexIwvwD26wne/+8BW20B4E
   ATK0c5kDZ2MdyapYxEEho+PnaoCdK5Ef2HTbkvKfvcZVibo91ZaOVVZ9R
   Xr+jlmIdDWr387yNFgULux8mutuiq4ku1klZ+IrpnjPlgOk902k6oGmJr
   Q==;
X-CSE-ConnectionGUID: 3Jm24labRnOGvgSOv1giuw==
X-CSE-MsgGUID: da2R9YxkRaKTAnarx+QaAA==
X-IronPort-AV: E=McAfee;i="6700,10204,11219"; a="27202801"
X-IronPort-AV: E=Sophos;i="6.11,189,1725346800"; 
   d="scan'208";a="27202801"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2024 02:24:17 -0700
X-CSE-ConnectionGUID: /xDLPZ16Rfilr6HuITPLRA==
X-CSE-MsgGUID: W0jvZSaHQ12fmC/9DGGk3w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,189,1725346800"; 
   d="scan'208";a="76148648"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Oct 2024 02:24:17 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 9 Oct 2024 02:24:16 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 9 Oct 2024 02:24:16 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 9 Oct 2024 02:24:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EMNhR37nts+FjCiXWd2JiBcLknT0/XX6z3Dbj6+O+r0VoUk2P/vwAgX2gM8K9ZFpdoJHzzbBKG4/Bslw6ZjuNz3TwD/4QdD6U44UbFxtS+iXG/a0fh4HPvT2GNoGUW20fNoDkAmlj+ME7MBoD8qbyxZHlISpoJgEOs3ZHTQ13tX38gcTnnJziOqRC6d3XpsslyGmHCPS9BLRLtL6xS1aGzzZxxpLa7dVxWdLLVqPTWYSHrGmH5MDwoIoxiyg98trfV4kEAQT393ONFvYXOsKCltXtW7W4wUccYPHlXAa0s5lJX+Ukdftotq6gt2LXkiyrfmvxGLsnRZU+7uYxpJ5BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fcFeRkW8WsA8Anl+HtYiFX/K6042mAMSa9Ma5qTlYcc=;
 b=PhjxZN/GHYR5yG8tM46CUdRJGuniixrnR362pEU5K8WJg+zNTiRIEQPk1cP3HSIEcBDju8oni7KxIxoxvoptl3Vyf5D3PcYVS8r34bGoB+EdePNjWpQqBVXRQguTlgKCj/hDTHOnDEJSvKkQIQfk8jcsIO+gBinXxUcWWiVJ4fWj8T0qPZF2XVfR9Xl2Y8C1x9vUhtfjxee5YauedFQiDBJoXbhxHqM3ipfjOthUz3Va0Mt2dX0Djc/nb8StSdGloajUYyk/3UwswTZEGfo/XegK9mrCfR6CEZPovS8jFgiy7zU2W1p+5fSQvAASN9y++GyMS0QubH9IBMdUpLYXlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS7PR11MB6295.namprd11.prod.outlook.com (2603:10b6:8:95::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8048.16; Wed, 9 Oct 2024 09:24:13 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.8048.013; Wed, 9 Oct 2024
 09:24:13 +0000
Date: Wed, 9 Oct 2024 17:21:59 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Isaku Yamahata <isaku.yamahata@intel.com>, <kvm@vger.kernel.org>,
	<sagis@google.com>, <chao.gao@intel.com>, <pbonzini@redhat.com>,
	<rick.p.edgecombe@intel.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86/tdp_mmu: Trigger the callback only when an
 interesting change
Message-ID: <ZwZLN3i3wcJ4Tv4E@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <6eecc450d0326c9bedfbb34096a0279410923c8d.1726182754.git.isaku.yamahata@intel.com>
 <ZuOCXarfAwPjYj19@google.com>
 <ZvUS+Cwg6DyA62EC@yzhao56-desk.sh.intel.com>
 <Zva4aORxE9ljlMNe@google.com>
 <ZvbB6s6MYZ2dmQxr@google.com>
 <ZvbJ7sJKmw1rWPsq@google.com>
 <ZwWEwnv1_9eayJjN@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZwWEwnv1_9eayJjN@google.com>
X-ClientProxiedBy: KL1PR01CA0126.apcprd01.prod.exchangelabs.com
 (2603:1096:820:4::18) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS7PR11MB6295:EE_
X-MS-Office365-Filtering-Correlation-Id: 6424ca9e-c5cb-45cf-0976-08dce84423a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?i74VQ7Usl8QVCJOlTvW7vSxv/w7XRJpG6nTyAB56VzwEl1dhJrKKhJoTibMY?=
 =?us-ascii?Q?yhPKhSfvXv0ahUKd/mZd7G/K2b5sJeZiq9e1MgUh6j4/1FSbJ0zq8AI8mvuQ?=
 =?us-ascii?Q?dErs8YlSoL2d+f85hIHGYG6IIdGsIjzP0Q1xUvpm+rcxe5V1+iHpqtXVtWlZ?=
 =?us-ascii?Q?Ic9cnfzd2dofp4CW+mtn53W4ruiLAPWb1gOcjUFWvXacOk79mtuVgmIiuURI?=
 =?us-ascii?Q?z5eAMx+eI3RJcu/MHuSb+xO93Y0S9jacrlYKQUPS8tmjeWbBdRtAJVQqbISJ?=
 =?us-ascii?Q?lqlneK3q3pRHipuHtX0O42/agGEWPphZfC3Rc9LiiO7G5YFzwqNb/lMCJs9D?=
 =?us-ascii?Q?xNSgwFea0NY7t7F35L8iFCInzHNWTAz+7zdp+vbeePMeoxBTRpd9E51LjHA4?=
 =?us-ascii?Q?5QRinwgngVn8gw2tSvg9WH6nZG6Dd6IHNgmsM7P78VjBu42KHOTrkz9Sqmk0?=
 =?us-ascii?Q?2FR68WKCB5dlkxCNQf4RhTlKiLTtP1tZWack3kDghxGMbZkw7gR1gq8+ECM0?=
 =?us-ascii?Q?fCB+XOY2hIBo7aEiUhC4dFdLdwbELB/Vc6AixJhMsIkH53BY5VeeAJmYAcbT?=
 =?us-ascii?Q?ArNBtIZx/61z0GcVUkO3LGRRS9GvRZFZ6zy//tNjB7g7PVsEvhO10FSJFHze?=
 =?us-ascii?Q?m9u5QDEFuCPaj3pQRa7/oBRO1Uj65DwqV5QgXGpz5EPCWNgS48TAJ5bAHBjb?=
 =?us-ascii?Q?ndq9SCgB2YfUH/eZEbQOCbBKGV8+keK//knN8uiY+u3qV3ffgH0QrpBA275l?=
 =?us-ascii?Q?7KH7uSCxSxLfCjkR3MpaZr1krKHeBMm9965B5QP0vYMQeZzLGWVNIwki26Cb?=
 =?us-ascii?Q?lJcp9aCVSHOc1yJ2BfIIOzwYw8b/G2aciQgFiBpkkoLgWr17vc782r3aaaK7?=
 =?us-ascii?Q?vSqc+sRH+5ete21q8zoA02jnXvStN7HqDmlhdAiiMf8civwMR9EdrJ7llihy?=
 =?us-ascii?Q?xfhEBhE26ZzYZyf1awLWy7LXbiQVNPCxMb62E5qzr0DXtSuDXzzIa5DdDcC2?=
 =?us-ascii?Q?UTldKXj1gg9zyoj9scCdKqnygVmiIhAdNH93p0JsGdcTqeJHN/nmiHlaVOgN?=
 =?us-ascii?Q?XKeeWFOunFNewoCGkBwsqKas/sIYIQY2ZOhqjhDwLh41iJwAY4CHQYrXjh1m?=
 =?us-ascii?Q?iSDEVis1HHpQ4BW+uLsejYIMrVjY30UZDdJNq7xoPdRZLb2GRfl4l7EyA7By?=
 =?us-ascii?Q?ky3UlsLpC0jEzmzcafxQAxhMdJjDhSdEMlq2F0AlgvqBxiOe8AxkgBfnqCSU?=
 =?us-ascii?Q?4LmbuXVN1RnCoO3gjnsxc7wIRd4rBIkSRWh8f51QDw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3RUT7vycP9cUqxRtMR5Yl/i7ulojeV42As0f2SXzZVvrHoez8l/jm/OUgSUH?=
 =?us-ascii?Q?ODj8kRvbm/LF7IqEtozMGOzfuN0rcwirGE9Ya97R0kHwbhy3NUV1+V3iq0u6?=
 =?us-ascii?Q?/YWQSWvN4ERHeaWqlOnmgAPfKxyehNkRSYPxu1l5YlDjwIJD2CIgMAwFejSJ?=
 =?us-ascii?Q?yHdJumolAAcxDUgug+aA/5LtV1CHB5U0jesCzX9th8Uxtfc50Y4o1cgm08GS?=
 =?us-ascii?Q?N1TFZSFOSgvpLRH2lwHvEO1awHFLOm/EWUz8Fpq6quNya68jKNyvbyYiG/at?=
 =?us-ascii?Q?HEJ30OfJuv12BFx9rCJMuP7Zm6k1pk/Y7P4f1suL/0jL24OtdEUfJToFrGzY?=
 =?us-ascii?Q?55WbGinLWVsfC3nEDV/Kqv70NkWG0p2S/fORj2jPP0uW1de5O0ZOCUydiTW0?=
 =?us-ascii?Q?AZYmMnaKyNBbpqBy1mrXjZ2cCE5qrQ42Oc/XibtpFN/nxnPSSkutzjeYgKXL?=
 =?us-ascii?Q?LIQUhrMP88scxeHW3kCq1DRLjRhZcZuKdL1JIveBenuEiANsSQVEQXONdqaF?=
 =?us-ascii?Q?g+TsOizGwhaH9eDKbZaMXWEC4KTNjqVAV5ogEpcYFrsy/Bt4TCaF7slNGjN3?=
 =?us-ascii?Q?LrY6H5Hf21q8jE+MTMt+xZOfSKmWxs3p+ot+R+u6IYRsoiSm5Ba9Mxl24gAv?=
 =?us-ascii?Q?jthXK6na4TbvYeATqPmrwe+Tt9A9Txe3nDfWdNibPVy9ufC0U2kBObYjXmo/?=
 =?us-ascii?Q?dEFgiln5ZLnryGPnHBEKRhixxoVpsRLoQul5Ty+XvkfDZlVPtkldQtKew/5d?=
 =?us-ascii?Q?V5S/xpJqM5vxVCCVa4/2gdsH5mhFxR+KVkWEZoE+Yv+TP6e/YZHY88gjNDVq?=
 =?us-ascii?Q?tXlNzcNrJk9vdEfjsHo+XQOdYP049rznbnXOPI8S9716h4TZozFhOoi817hS?=
 =?us-ascii?Q?BMXROaGYtT+AsSRc44/x+SxbYHEig08IEzdk4CFMGwWmwrG+3Hpa5QNz/I6f?=
 =?us-ascii?Q?gaMinqs7Uj1SgAIaygZBZf/vlMb1zZBdMrXWR9G4LPF82Aem6BylTHnMaE6/?=
 =?us-ascii?Q?Pc9xEH/egYd+pfkuFt7MMvnQJpTL7FRMN/6xNY3DSteRGAjyQzRNAXqweS93?=
 =?us-ascii?Q?dloBGP/XdpShIbROscojV+kkqRNCnesS8dP4VcanziBcPLBT7Etth2/9cDsg?=
 =?us-ascii?Q?nwMo9d8B7ltfWWNivw4a1iLhWVPNRVUVQtSCEIw3Yp8oTdaDCOW6HmKi3JUb?=
 =?us-ascii?Q?JzL53C/LfbLyAap+oM/1uYtA3pQVS2UH/tF0bNTTNbt5/w/iohLkPyosL+Bv?=
 =?us-ascii?Q?ifM7Ym4cT5RieeD7pYGvuDzGE0wBFsP6xc8T+4kXqfTxw8DnASluxCyUax+H?=
 =?us-ascii?Q?1fxj+7ZEHLCmCZv/03zB2otS1wV2pB5myOtRFbOFAai/VcgVhMBw+uRvxNxu?=
 =?us-ascii?Q?W7ePXd74R2WdqBtoyqTSPjWnGAY52l3gsQhxWbORWjAbbNGMS8wKLV+vim0o?=
 =?us-ascii?Q?sptR+3RRhLy68SuwURYDp8KDCfp/XOmN2yPK7kHYaQYD7cCTXfekrChtOBpI?=
 =?us-ascii?Q?sjlpmVO5Bpmg2eLvC+icv/z1r4PMH/lPQw8axuUioDQUd+P6osMqocNsfRzy?=
 =?us-ascii?Q?WaNr7lszMCCeyqx2aJMViofrVq+qKeCMBo1WerQG?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6424ca9e-c5cb-45cf-0976-08dce84423a3
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2024 09:24:13.4120
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ImIf6MYSUk8+u6y3IZ/m1gGltb73VMOl64zKhF0gBJD5FddP4DBK+8WYvugoR0X5jMYwnOYeD+aR+UVGkZgWbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6295
X-OriginatorOrg: intel.com

On Tue, Oct 08, 2024 at 12:15:14PM -0700, Sean Christopherson wrote:
> On Fri, Sep 27, 2024, Sean Christopherson wrote:
> > On Fri, Sep 27, 2024, Sean Christopherson wrote:
> > > On Fri, Sep 27, 2024, Sean Christopherson wrote:
> 
> ...
> 
> > > > Oh, right, I forgot about that.  I'll tweak the changelog to call that out before
> > > > posting.  Hmm, and I'll drop the Cc: stable@ too, as commit b64d740ea7dd ("kvm:
> > > > x86: mmu: Always flush TLBs when enabling dirty logging") was a bug fix, i.e. if
> > > > anything should be backported it's that commit.
> > > 
> > > Actually, a better idea.  I think it makes sense to fully commit to not flushing
> > > when overwriting SPTEs, and instead rely on the dirty logging logic to do a remote
> > > TLB flush.
> > 
> > Oooh, but there's a bug.
> 
> Nope, there's not.
> 
> > KVM can tolerate/handle stale Dirty/Writable TLB entries when dirty logging,
> > but KVM cannot tolerate stale Writable TLB entries when write- protecting for
> > shadow paging.  The TDP MMU always flushes when clearing the MMU- writable
> > flag (modulo a bug that would cause KVM to make the SPTE !MMU-writable in the
> > page fault path), but the shadow MMU does not.
> > 
> > So I'm pretty sure we need the below, and then it may or may not make sense to have
> > a common "flush needed" helper (outside of the write-protecting flows, KVM probably
> > should WARN if MMU-writable is cleared).
> > 
> > ---
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index ce8323354d2d..7bd9c296f70e 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -514,9 +514,12 @@ static u64 mmu_spte_update_no_track(u64 *sptep, u64 new_spte)
> >  /* Rules for using mmu_spte_update:
> >   * Update the state bits, it means the mapped pfn is not changed.
> >   *
> > - * Whenever an MMU-writable SPTE is overwritten with a read-only SPTE, remote
> > - * TLBs must be flushed. Otherwise rmap_write_protect will find a read-only
> > - * spte, even though the writable spte might be cached on a CPU's TLB.
> > + * If the MMU-writable flag is cleared, i.e. the SPTE is write-protected for
> > + * write-tracking, remote TLBs must be flushed, even if the SPTE was read-only,
> > + * as KVM allows stale Writable TLB entries to exist.  When dirty logging, KVM
> > + * flushes TLBs based on whether or not dirty bitmap/ring entries were reaped,
> > + * not whether or not SPTEs were modified, i.e. only the write-protected case
> > + * needs to precisely flush when modifying SPTEs.
> >   *
> >   * Returns true if the TLB needs to be flushed
> >   */
> > @@ -533,8 +536,7 @@ static bool mmu_spte_update(u64 *sptep, u64 new_spte)
> >          * we always atomically update it, see the comments in
> >          * spte_has_volatile_bits().
> >          */
> > -       if (is_mmu_writable_spte(old_spte) &&
> > -             !is_writable_pte(new_spte))
> > +       if (is_mmu_writable_spte(old_spte) && !is_mmu_writable_spte(new_spte))
> 
> It took me forever and a day to realize this, but !is_writable_pte(new_spte) is
> correct, because the logic is checking if the new SPTE is !Writable, it's *not*
> checking to see if the Writable bit is _cleared_.  I.e. KVM will flush if the
> old SPTE is read-only but MMU-writable.
For read-only, host-writable is false, so MMU-writable can't be true?

Compared to "!is_writable_pte(new_spte)", "!is_mmu_writable_spte(new_spte)" just
skips the case "MMU-writalbe=1 + !Writable", which is for dirty logging.
> 
> That said, I'm still going to include this change, albet with a drastically
> different changelog.  Checking is_mmu_writable_spte() instead of is_writable_pte()
> is still desirable, as it avoids unnecessary TLB flushes in the rare case where
> KVM "refreshes" a !Writable SPTE.  Of course, with the other change to not clobber
> SPTEs when prefetching, that scenario becomes even more rare, but it's still worth
> doing, especially since IMO it makes it more obvious when KVM _does_ need to do a
> remote TLB flush (before dropping mmu_lock).
> 

