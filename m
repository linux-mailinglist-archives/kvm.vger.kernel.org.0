Return-Path: <kvm+bounces-18710-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DC8B38FA935
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 06:28:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4F1A6B23124
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 04:28:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87D4B13D630;
	Tue,  4 Jun 2024 04:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dLNIHFwW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C27726FC3
	for <kvm@vger.kernel.org>; Tue,  4 Jun 2024 04:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717475322; cv=fail; b=R+9AiM2tSMkTZ6XEm3cQWI1+gfgvXNng874T5qXxfZHbVR8xU0M8xYrA+a9skon6PleRXaDmHeddhk3JeJTeCvr0K/ymyEnXz8cs21oxqwHRm2ta0OgmLlM0o6t7ujfx0F2bgvQ0BpYp8pJKVL7CECbNZda9n8C7shjswVlM0NQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717475322; c=relaxed/simple;
	bh=VR1DoOuhHUWvCK4UstGM7lNAkpBJlYTEFVKgRWMEfUw=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=rRVQOA9yLO6i6fVuBNfK9M+bH1uvJhgkRKh19hBdFhSrkGwxTbuyNglXPNeY2ILQaHlNWjMy5QCZJFbtrjcqvesLjXjzMsHXdp1pnPkrr0bYWU2oSGeRmQouIoPrL0yAs3Lweoygz4DxE50vOdbq5BCZxKT1sKiwhYlcHnaYQq0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dLNIHFwW; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717475320; x=1749011320;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=VR1DoOuhHUWvCK4UstGM7lNAkpBJlYTEFVKgRWMEfUw=;
  b=dLNIHFwW2FE1Hmbp6Wvwc113sEZQBQLQopHFFTs+A2DEFu/Jfbn8KU+K
   D0yOLdw2o1ammnSjDQ/afDHvD01VBLmVMRyjeanuKS3ImIbkJF8yF/aqx
   J4vgvTd2kDU6gmQ0VfGWyic9E6ukCWQn2kGBZipEwScn+Jt6TSCksjK8Q
   U0xxw5lw6LIX6TLRXc1WhCNpdB/OH88U38xEceReRk3SJl5RhyTa1m2C/
   YPR/rwTnsXQK6n4eXi7LxnXaHz0vk3M0SMWuO8I8kwg8nxO1JIxLNQn0F
   cq8f7qkQI0AE+q57MZOfQ31Vdujppum0RT6kG91gVMZlQ50NcHKy7+d7x
   A==;
X-CSE-ConnectionGUID: K/VdNNYSTDidqbqzoxyGxw==
X-CSE-MsgGUID: n3PfmyAWRiy/dRxl99rnGA==
X-IronPort-AV: E=McAfee;i="6600,9927,11092"; a="13834156"
X-IronPort-AV: E=Sophos;i="6.08,213,1712646000"; 
   d="scan'208";a="13834156"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2024 21:28:39 -0700
X-CSE-ConnectionGUID: LaejMN3NSkyJW5ZMazXQ8w==
X-CSE-MsgGUID: 84x9tzQNQ+21TrkhVzo7KA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,213,1712646000"; 
   d="scan'208";a="37690113"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Jun 2024 21:28:39 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 3 Jun 2024 21:28:38 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 3 Jun 2024 21:28:38 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 3 Jun 2024 21:28:38 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.40) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 3 Jun 2024 21:28:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QsmlBnTddqTY5goirKN4gA1J3ZQLzgIS+F79vBp0h0L9CETa1Tm86yygxyKLV2Ts6+7y6JdJWuzc+9ULjvq11nKGq3GJZx23fs0LRvbLlY0AvAYYXTlvsImMHwS6Igt/4Ot3D16WkKhNI6qDQCCKqTcgxZc/yKFygy/oejafdP0Iso2KpKJtgXAH//Uh4bN8UcOjR3/jh4MlZ5P8Rz6yVPvwRc0wrsw1fUmkQIswF0KH/9UrIVW+zze1FAO7qLAZESZbuIosaKPj7NPTDoluq/2ckchl0/I8hrJrnv5BWLuCM+Bde/dzhm4MjZx4vevFM/Kv3gTVMKcWpALt+6SfgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YuSqYOrNoJ8UmInrbNFTxUsvf1bq8K0QsR+vpNdS/YI=;
 b=J3icFSflowPf7UlJNH7SGOD+CwfH120HPTqmYKXaYMES4Mf6wWINi61WFRp7F+ucZcOhHiTeleFZ0Jl5u5KEAzLzYz2cPf4QwxEYE0Vy5AzgFCTlMn8ZDtN+7JA7acnG3R3Awt2YzQBLbe4VA6SYatRaRYS7i5jeBvmsOp79c+mULQU0FOWh+BKd1C/uKsDQQl8R/wo0jhENerD3gxUuhyG0JsuyI9FpIBSxeVJk5pGYStx2QTf+h3OVWD6IVwPKztByOCo8S7CCssG6zsNAq7TmV0GjCVI+1+CmjdZJr7aiBsn3vLrXPSlu3qE5SdEXxDB3diglixKnaVw3J/v/uQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CY8PR11MB6987.namprd11.prod.outlook.com (2603:10b6:930:55::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7633.22; Tue, 4 Jun 2024 04:28:31 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.7633.021; Tue, 4 Jun 2024
 04:28:31 +0000
Date: Tue, 4 Jun 2024 12:27:35 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: <kvm@vger.kernel.org>, <ajones@ventanamicro.com>, <kevin.tian@intel.com>,
	<jgg@nvidia.com>, <peterx@redhat.com>
Subject: Re: [PATCH v2 1/2] vfio: Create vfio_fs_type with inode per device
Message-ID: <Zl6Xtzsf0RqSU1MN@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240530045236.1005864-1-alex.williamson@redhat.com>
 <20240530045236.1005864-2-alex.williamson@redhat.com>
 <ZlpgG4vA+2yScHE/@yzhao56-desk.sh.intel.com>
 <20240602210040.2c5c487a.alex.williamson@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240602210040.2c5c487a.alex.williamson@redhat.com>
X-ClientProxiedBy: SI2PR01CA0029.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::8) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CY8PR11MB6987:EE_
X-MS-Office365-Filtering-Correlation-Id: 2feb99cc-723b-40fa-bdbf-08dc844eca1d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?xATXHxsdhiRpb3IrV4C2rWZAxQds61WCtE6GBMl7h1rrkkkbrQRqbFVcKmgP?=
 =?us-ascii?Q?Wj3AMcHvX7v2lLhLkIc+FWqJAxqvJyRFbNLlQlYLrFf9u3gY/UtvzVzBRhum?=
 =?us-ascii?Q?BEnKuq17a7oi/O2n+c3ZmN7KzBM6BV/M72qHojzvNDLplqASoaL3gwmHljrz?=
 =?us-ascii?Q?5fSFFToanvrlKlp1WJsu4U2BxX2mDoC1SPxrIjAvlMyvoYaOeKJxmpOu+XOD?=
 =?us-ascii?Q?iHn21pIErC8qeV/6pq17K8jQGy0yB94OZxcPAzorhzXL1HR0lIvoiNAdtT7I?=
 =?us-ascii?Q?8jmvOkmySv8A7ncWqUVCbozoWG2qqPcAGWwXOV7fYLC0rJsDHzGQegZva81M?=
 =?us-ascii?Q?HXp6he8BzJ1OqOGpdScJUHrcllgJSe3OX4LFT0RqYOs6q5dCuC6bmINTTEM4?=
 =?us-ascii?Q?jShJrX4iZ98gSjF8penc54J3xZKB1dh/8rJRCL7/irYlBc7z+cGFtMGReiBf?=
 =?us-ascii?Q?WXGoUxzdxNyyZqt4eWWowE6HDPcR+9skBI/hUTuKncr1N4TJ4PI7D5MupTyE?=
 =?us-ascii?Q?GT5OzKnVCP091T7YX7XOKY2e8PvEa1sxRUw8agZe4eEqvjk8GfWAOZ0gKLII?=
 =?us-ascii?Q?KTmTwl/AHcNsDZEhmtmAmobhjMOaBA+VB709pqYLROgamfMvFOrvEPZKBzHv?=
 =?us-ascii?Q?EtlpD0ZTb1bn+QPpdCNAHPPOS11r0825LR5h7NGwx1SrRcZMywcYdcI+JcmX?=
 =?us-ascii?Q?NZU0zG4KNVtOHpfvdkMpNxCR2gm7Cz/eA7B0ZEYX+VOTTO2bTG8Qa6BXOxA6?=
 =?us-ascii?Q?VM4sNe/oL2TShrTBNiXhXXbMxPKsCG4l9WPY68sYYJp2ygtRLOyw3B7gyDl/?=
 =?us-ascii?Q?YD6VsaHSRXcts/OBsNc2Ny4iWvYPCgdEfiJhdwUj5bXFdWQ7Jo5avKu3Hz3F?=
 =?us-ascii?Q?v74cp8bn0n/THDTiWp8x86FgD6amgbIo4bn/DOcRen4/s0NT7YF8ITp797q1?=
 =?us-ascii?Q?cp+bBw/9qItfRUxzzZFVr4kctK45cepQVfaNzAohWJUQ3xpXPCwtXmDUdGMY?=
 =?us-ascii?Q?R96UgkdqgmNYeGKkNr8kVw1+S/Eg4l4Elpq9ZwpHOMftLhUj8O+xd8X8rnbI?=
 =?us-ascii?Q?2eIL2mQNHbkRJKubN8tF8uDB447V7AP3plzp2NgPEtltnhld49PoaRXMj8L5?=
 =?us-ascii?Q?y5q0Uur8L2mNs7du6/Ykf0leE7Iyx8HvJE7EcgAIYBOj+2H3PbsWXuKrwwuV?=
 =?us-ascii?Q?99FOL95c/hgoGf8+tLDGRT+ELSpkoJQJ4RD5R52IJ1OFPat4HSo0lAcaXUGW?=
 =?us-ascii?Q?T8/fsNuVZw/9p8gJY6UZHDYtL0cSd3s4CvWBpn9yeA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?k4htP5wLoNhPRzQqpGGCpfo+1oos1i7jZM1fcrnBVHSrED6mk3ZiuGR+hoGe?=
 =?us-ascii?Q?8/NH45GqSMcUgLXxgpYo5NH5hmmW2tr3UmBrlYR9ngW1wLzvunQduX9v2N8v?=
 =?us-ascii?Q?m1UkcVOlV+1llryYEBwvjiG05kZJqVdLdMf3I4tyg72VI7fvSxnONRMSunTy?=
 =?us-ascii?Q?ENrCOjbYAdZS0dEKIAUGDyo5Q/YF/ZJMLcmYtHYMWldFT89VU+OK30/mKOPc?=
 =?us-ascii?Q?hKD/fIDTWBt1TVcYrlWrgs+Nf33O8CCnGzZN30cXb4iJN2o0rPTucDAg19o3?=
 =?us-ascii?Q?ApRC6ra2R9JmYs4K8juO8Vg2qW6kJfIvich5RmOUZdsvjfzJx3NpHNu+A+qa?=
 =?us-ascii?Q?PiTi+R31ByobGS4OlF1FI4GXDDepuEuNWXg9yKoiBm4+8ZfD5Cz0u02etm+k?=
 =?us-ascii?Q?Q8q3CK9lC4Pfc24Ooh+yWkTcKkaDxOtJZJRXxeZaWBzzuC3349VTkmzHTwuy?=
 =?us-ascii?Q?nrlO4OdPi1kjX0Gy6RgDebdUUtI8gwjlpdarC//0OCojp3gC7JztZKbRezoo?=
 =?us-ascii?Q?gduOGq+gc5YSHlNztUAgHck9tqk6WtrE1NnQerW8NtsX1kPi/VOdZrQdPUbZ?=
 =?us-ascii?Q?2SVcjIX5j9n7Qt952lyhMn/UUwE2W1ffLLpWgtO0JJMZ9Pa45anzFcns6Rg+?=
 =?us-ascii?Q?a0G4Zz9NqXdNhwPdFSwRNmFXuICbwaU8hUhEoh3BwauIZEdG4UKDQyiKeZl7?=
 =?us-ascii?Q?SCOClyb0xbXHCIZCcPptI6TxOrzslV9snN3XLY5j0/CpQ+QhFIZsdUZKGwN7?=
 =?us-ascii?Q?1X5tFBGaADEWQkF0rO5S4cIHtxjtt2HgwezsYsIt+hlLL5EiC5d+h8qYgiGb?=
 =?us-ascii?Q?IuTLdv9VGvdNB0x3LJf86u/v0Av2lHYN6VNy8vow9TMBPHByTfjm5nwqMC08?=
 =?us-ascii?Q?p6MthvUKk1eXTCbXWrYPFgovqLAnU0TNthHkhFAemuYdVeF+UQltHzuRw/52?=
 =?us-ascii?Q?nKVxDqnxVsJMqwJikXWqOFPfTLIxM3cnViyBeyz9IpoEOYc+dfbz+xHV62pq?=
 =?us-ascii?Q?9m2zy3FXs/ubGfEmkEgBhMeQFJlENS/L34Xri2Ld7S6u4roHPEt81tuVUu9O?=
 =?us-ascii?Q?YJVVPwNeNtHjbhGqguzUo4uTz54lRkgQTKM8ppwqxlVrLv9X2YuWLFm+Yr+B?=
 =?us-ascii?Q?AzH4cc2Y3W7ab1nddVMajsKP2omVoJrrkd15XPeTTLAUk8YZKzeaTjLY0Xc9?=
 =?us-ascii?Q?KlqH4HeVTVX5T8Xcaxh1xuoDS9r49tgSanRnQXiEy4ok4IRNrFKMrwfMC5/t?=
 =?us-ascii?Q?Lu1T9BLJirq1j9kbrzYBvDkwV6JqXYvrAsyL4v7a5Hg6ZcKtm2cEMK853kjG?=
 =?us-ascii?Q?m3ET0HEbOXGUvsQa+8i3FWE0oJLBkFUw6cjwSyElxiQ1FV53zGunhbkeV3mG?=
 =?us-ascii?Q?LCANxVDFkByVIKRuctmT/7G2sGoaq5bev6Qw/+g6epVH4HNI/3EGRfrFJbl7?=
 =?us-ascii?Q?locG9Lkhwp5MBH6wSRU0Zf92Haz1q+uEbqle4ZtVfqwKY8Yu0Kw4hNIzbQ37?=
 =?us-ascii?Q?gvb5XTqnnE3tuOQ1VRrD7Sb0iid07J8h6D5FXACZdXIusvmpbNDUVLkDCc9F?=
 =?us-ascii?Q?Lb+EfPz5ooVgzV9d4D6yQvmuqCdMEb0GL7gnFgup?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2feb99cc-723b-40fa-bdbf-08dc844eca1d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2024 04:28:31.3922
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: teWraorjiCHkpjDpqa1KLhjTQs0qbkqwOOUk2ih50oMP7bRSzdXtvpZtrOXgdvzgqBB0C/V9GZBLsrPlfX3i3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6987
X-OriginatorOrg: intel.com

On Sun, Jun 02, 2024 at 09:00:40PM -0600, Alex Williamson wrote:
> On Sat, 1 Jun 2024 07:41:15 +0800
> Yan Zhao <yan.y.zhao@intel.com> wrote:
> 
> > On Wed, May 29, 2024 at 10:52:30PM -0600, Alex Williamson wrote:
> > ...
> > > diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
> > > index 610a429c6191..ded364588d29 100644
> > > --- a/drivers/vfio/group.c
> > > +++ b/drivers/vfio/group.c
> > > @@ -286,6 +286,13 @@ static struct file *vfio_device_open_file(struct vfio_device *device)
> > >  	 */
> > >  	filep->f_mode |= (FMODE_PREAD | FMODE_PWRITE);
> > >    
> > Instead of using anon_inode_getfile(), is it possible to get the filep like
> > filep = alloc_file_pseudo_noaccount(device->inode,
> > get_vfs_mount(),"[vfio-device]", O_RDWR, &vfio_device_fops);
> > 
> > > +	/*
> > > +	 * Use the pseudo fs inode on the device to link all mmaps
> > > +	 * to the same address space, allowing us to unmap all vmas
> > > +	 * associated to this device using unmap_mapping_range().
> > > +	 */
> > > +	filep->f_mapping = device->inode->i_mapping;  
> > Then this is not necessary here. 
> 
> Maybe?  The code paths are not obviously equivalent to me, so I think
> this adds risk to a series being proposed for the rc cycle.  Would you
> like to propose this as a change on top of this series for v6.11?
> Thanks,
Ok, let me have a try :)

