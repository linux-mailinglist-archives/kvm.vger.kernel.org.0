Return-Path: <kvm+bounces-39960-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EE6FA4D28D
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 05:24:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 240AF188932A
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 04:24:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 484401EB5E9;
	Tue,  4 Mar 2025 04:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DA+46ioD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A13137160;
	Tue,  4 Mar 2025 04:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741062225; cv=fail; b=EEGOx/Pl7uuvexco6l71Jpw2WxAQa/lvANZn0n4WryAu/5TX1J/1p3HjwoNq2Dvb/PnW3blp1Up79p3nv6uC8MwaZRcdKwARcEZ77jcIF+uj59AaA7mEGAKSZfNz5NpJdKUEjcAg3zuGnY/axqwdwn3IqXKa0LfI125Kx1iX/Hs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741062225; c=relaxed/simple;
	bh=//TOIqrj3yg2mvCOodkVOCkj4CE3cRbXyPTvAYUR36o=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=bXPsgHojaCvtPp3NzXoWhTUK2IOYtIxRUk0tY1ixyQZjrtO05rbxR9mztsz1ZTE0zyBnnO9FWQM7jdimrIETbVL9hwkGD6B0I6iqwkMa4qoVS9Y9I01wLqN1tkq58zTcM/KFIaG+cgR7rwUfhU4vvE4EL/T+X4rU1VFvR/Vrdtw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DA+46ioD; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741062223; x=1772598223;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=//TOIqrj3yg2mvCOodkVOCkj4CE3cRbXyPTvAYUR36o=;
  b=DA+46ioDaDABzpqJmBFB2da4scwWi3MFfln2hRfh7diaV5aadlk94l3f
   x1RiZcEUFCHsodkCXSsFe6S97HXgsQMoyJOjf0eiUXTpyY0pcJD0ZMtjp
   3A9nhQH/Dw/farurU61zHWaj6LPEJZ1jbTmdIL1hc/mhtXNsOrbLNHL1C
   knZshfwr3UDaHtwlYX5DvUtWXWqHlFg/qaST5aWDRQ8ux3oZnC+xXKDH9
   GAvGDNFFFsG1DuaGFb8HFFcHmE9Dlkjpsw9PhvHmQPneD0OA/NGKch2U2
   LXp6gSEikXBNh+/zOnxTvSSrgWpCSMpOjZ4EiGIGSTJheTVEZ4DuYnZYo
   A==;
X-CSE-ConnectionGUID: B89qAhF/TrOlps4e5jxEyg==
X-CSE-MsgGUID: f0JfjowHRgO74x7hL6/+Tw==
X-IronPort-AV: E=McAfee;i="6700,10204,11362"; a="45736730"
X-IronPort-AV: E=Sophos;i="6.13,331,1732608000"; 
   d="scan'208";a="45736730"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2025 20:23:43 -0800
X-CSE-ConnectionGUID: wbSpolUsSW+L9mLD+1OxwA==
X-CSE-MsgGUID: cZG1f6huQuW2U30DgLMJdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,331,1732608000"; 
   d="scan'208";a="118940220"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2025 20:23:42 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 3 Mar 2025 20:23:41 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 3 Mar 2025 20:23:41 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 3 Mar 2025 20:23:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Me5695C7j6ykfZEEttiCfOp4F13vGg/EyH7exztvOGDfzykG7Gn+2Xl1lf9M9FzybZp53AvYg+xpJrjsTOHoo7ohKjp37VvRkYyffX8y7G/ZTsjuZqoywXBvhSIDboj9hFzPv2oklnJDdPJeGW5cTFAwX8LnKYY8ImXRkiCUkt/sEzS7XNYMprc4T7cS+f/fu9ZViwYhWq6w+kceZ4VknrWDVQArc0vqH9yOZX3NEBWp4iH0hXMRgK/+FKyzdWqc7luW+ji0IINWcTYIas4D0BsCFwmOEoBvlXnimvwBGwSO1DGJq2rY53Z3Avce/a9Mmy3Gfk3jj8NLuJEK3VgmCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vw17quOZdHqg31VIWrvN9diQX19qHfSJta7gPVfmNnw=;
 b=c28y1kO0FcyuD70XRC/fRCGgJf9kDEIkSKf9fqJqr1F1ZiXI90ik1LgyHgiMT+d30AqrVFLDh3+GrbcFIm+CeBxc66zUOR2jyq2DeVfkNlvTcQFgjrlO2nMaXMj5sPMuldh/yKejWp7hCFODfDlk18QsfKYhWj43AIxmb3aH2vzbhd4SbrAAHrA0FiC+nGLEJSCLwQ5CU91o/l5m96t22tz5vJJoFNpyQU16ayjqFHH7VxUbyMU37z//YOFvm40Nfg5NwHnLtXE8KQd6tbkgAyEmlg1u0m+sJsYEY7VJIj5OR3AxoRXXktbmDj/9Z+ToqIntMVQW41OCurI5LRvIJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB7570.namprd11.prod.outlook.com (2603:10b6:510:27a::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8489.29; Tue, 4 Mar 2025 04:23:11 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%4]) with mapi id 15.20.8489.025; Tue, 4 Mar 2025
 04:23:10 +0000
Date: Tue, 4 Mar 2025 12:21:49 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <seanjc@google.com>
Subject: Re: [PATCH 2/4] KVM: x86: Introduce supported_quirks to block
 disabling quirks
Message-ID: <Z8Z/3dxtpbjpCJPI@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250301073428.2435768-1-pbonzini@redhat.com>
 <20250301073428.2435768-3-pbonzini@redhat.com>
 <Z8UEmKhnP9w1qII9@yzhao56-desk.sh.intel.com>
 <4a2d487b-aabd-4854-a8df-214423b8c390@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4a2d487b-aabd-4854-a8df-214423b8c390@redhat.com>
X-ClientProxiedBy: SG2PR01CA0187.apcprd01.prod.exchangelabs.com
 (2603:1096:4:189::12) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB7570:EE_
X-MS-Office365-Filtering-Correlation-Id: ba574766-d1b7-42b9-9e4e-08dd5ad445a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?ZqjtPVZ5e370FIBz7omEflPV8Rswm7inCXmqCRW0lNGxHkU9SgsY+CC9jmJr?=
 =?us-ascii?Q?0CQZGKs8dXQljNBdWFXS8zzm7hP7+R2haHmE7OVmuftg5Unhvloc8moVTKBy?=
 =?us-ascii?Q?hRtyLr8WJndYSHGIa4U0LPkn4Y0I0NUArZ0y/K+3c+8au8aiNQBIrEhQkW71?=
 =?us-ascii?Q?pXQTTstKJYqfB+DVer+XnmUc7vMzfEFPXbiBX7c8FDxIm6ZbJjKYnptowwzo?=
 =?us-ascii?Q?f0x/KWTkPY6Z27ofzaMaW+4+Q4mZ/9rV4Qqh++nnJgchrVSnNsRlF4M0Hsvm?=
 =?us-ascii?Q?6wxTXbT9aBgwMiwUfiUQ8f8ilinrg3q0l4Gc6sgCzmJB1tgTt+cQUPd1YNjt?=
 =?us-ascii?Q?eKE9Q0wnM5c3X91VMx0f48UbYb5GgU7GmeZU1Cp3bAJ34EPhUnQJUtnXYnPD?=
 =?us-ascii?Q?6C3nWzssRCKg3jskVEkR1odMckrTxVkwv/3n8iM2Yrskr/q6TwJrYTEbmmxm?=
 =?us-ascii?Q?HPAZDpPyuhb7eIr8d9JL3av3UQEsAk23oylv1SuvBzWO+GomWpzVkfNAbZ+j?=
 =?us-ascii?Q?/aXlMECoZkpjL94IJgMawl5liN/FM2IXottZmqmtwnt+kZrh7DUzbI55fcQy?=
 =?us-ascii?Q?MUCe253wNo4/6xnUV7bmAAK5ybOqrN6wQd9T25059TNApkzgsvjkP9VEnDrZ?=
 =?us-ascii?Q?TDnFZkFd4yNc7xUy07azobvTL7xTabVuMSQjyUl7GcbeaCFtt/0dseNG70aJ?=
 =?us-ascii?Q?0gV9rCrsAtCZegk/Gr+l7D0BQuFD73FSpSj5YaOMcMoAU4AQHs/MVtIm68TQ?=
 =?us-ascii?Q?VHbT1k3zAG6cH2inyaHcxAzu4o7mYSF5j2VpNDjDYSg0B4ciVNDysFO4pzCw?=
 =?us-ascii?Q?/Nc11w6TrAOYrahLqDKC8zH68FeWwKLaqkSzor6CDZy9vvoAl9oMr8faQ0aT?=
 =?us-ascii?Q?IElqqeW+R5njL4YqdG01UHFDHHzlbOvyiQ0sI1yqOqJh6oLFIjlOwmajQYSc?=
 =?us-ascii?Q?08Pwob7YPfgDODpZVD6iGmY+EasFZ0WecZjiObSSJCEs2ln5G4Mvb7vMJDi7?=
 =?us-ascii?Q?AuAkrKasrvKeuZSzj0R0Tj2jPYpXW3WDX2fjQ1km+qAfnCLVb+iYpy1UaHEk?=
 =?us-ascii?Q?aQzpmuHLI1k2OUvQJGNd0Wc35qh72DcoWKTl+tsIvsaifTUY/jt1zzTojziy?=
 =?us-ascii?Q?sOsZJxqA7nIhe+yWfUB8S7TForoGgr+QvuzgH1tsSf3bfppYwtPqx83BjuUz?=
 =?us-ascii?Q?/7wDWVbqYr++TrAPJ4PXcyTdmeesZPNhj8Wdb3BkUgXYMiKrhsEXM2bF6sA5?=
 =?us-ascii?Q?MD5qLiUpfPDVGZ/xG2VV6ZiL8XIkAMbAFKGXl24A6SfWv9seRof7j0PIbh4d?=
 =?us-ascii?Q?Q8xlxXy039j+Di7qy3ZOLDsBfNvyewZLLvoRWAI1dysRszr2wlu39QPv7ryd?=
 =?us-ascii?Q?GX47yybKt9sWBsLAtDiyHkxmmtIu?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XCGYp+O9pV24fmHw672TeE1r+l/vHkidXLJEyF0K0WorKe4BLnEplwFjVdcE?=
 =?us-ascii?Q?ZSQqT5n84l9XPokewA5qNKx4ZzP0y1ccsMIlr11bzB5Ax4vWYaAw7ENETrog?=
 =?us-ascii?Q?lCSYmGYhsfxP+/i7CJqTkBX8OICqNekqiNrKUrasNk+FRH3+VULtwx2HWmGW?=
 =?us-ascii?Q?q8MwJoOEUo8gL6ycRLHb4PVt3ILwlvvWr0ZRe4TYaPKsQCAJ6gIV23WesBm3?=
 =?us-ascii?Q?rcF9rJPUpnrIU+LlKUSvOaKa7izociZkE4hWWHVlvI+qMq7Cmd67gOg5MOzZ?=
 =?us-ascii?Q?Yxul2LtCWokaanwpHwr3aUVOOFJjh1OCo0r2wu3kAUjKE0kntjeF4HgtY1lA?=
 =?us-ascii?Q?QMtNEJLdY+plBiLbUQu94M09SazZMT7xRHsvTbtiDbQeDF19sIcI6m0vDP74?=
 =?us-ascii?Q?r4dKGENJCO5CYYKueqRcdLk23Lbcgcxv1OZI1klFHJArJn4TtjqlRzpv4e7K?=
 =?us-ascii?Q?ea4JFgtDQsbowfHbUA7SAblwXxs4/Ux3Ohq4um5BCUsoR+uzC9SsV5hye7gN?=
 =?us-ascii?Q?CGM7nqapdHJnPzfWBUBDalpjU0498rVIOztWDmzj8FHOEMoO2JMA29J4Fx7i?=
 =?us-ascii?Q?cfiHB9cqvzsb+Wdf6RPCHtbrNgLOSfieAAkqTp4jmezb3Lfk4OencRu+FGWZ?=
 =?us-ascii?Q?tpU1qPQsEC1nQh1SzyCGEDXqG0XOd075sjDbuqa7UZjuio4R4gbIuDjhAPr4?=
 =?us-ascii?Q?AfR0mE/KUhEcJwe9nesEPXHOA/iL3gfGFg0+Ok9g1eOHeE02AyGBy56hn2Vu?=
 =?us-ascii?Q?qTTWzGZB/Gawx5b6L9sFcCIZ6ABsvmgAJMOQsMiL8ffdR4b/nmNy4e/zabkw?=
 =?us-ascii?Q?uq71KW1CVlQvD449tbs8Dsu/4k1wlghFXr59852g5LcfcLFVU9cknUOykkjL?=
 =?us-ascii?Q?hpMDi3cNqcGxOVfOt21gM8p5rHr2bPMFi/jGdF4MyiX4k5UrlJJVrNnxbHd0?=
 =?us-ascii?Q?CzmMXNWiUWEJpcJ3NVwqyIIhIYCQIKHcE3foyXUTSr5NeG9zhMCkgGo0TJVj?=
 =?us-ascii?Q?0A5LmJHvjQfcVFPALt337Xn2IMEOL94aV11ZyNUhNIKHsq7BLAXbdhS0k/+9?=
 =?us-ascii?Q?vMgzF++PkkIvCJ+ZdHIAhn0bbWvVovb8C1VhX8Ghx4L0tBxWRG12MkMCAe9S?=
 =?us-ascii?Q?X30CREM9al4mfImpA/YuLXear5G//2+/Fz6tp/gHdLRJiNL871OdzH3tZ15q?=
 =?us-ascii?Q?jCspvbRMhWc+MSqE5eggVZFEcuXxORATRCr+LlVX4fMej6ae1UV/UyFkQPZF?=
 =?us-ascii?Q?us5Zr271ZFPOzmhqHR1oHhCa9diVgaKvlWiEp9P+Ea17I5SKOgBGP50P01rR?=
 =?us-ascii?Q?GPl/w1iY4xeKoRZZSv2rI3o7n5e1z+FH97oAlyxq5SylASoer/NkAXy+CvAV?=
 =?us-ascii?Q?jG/M5CP+EcI/H/MPe/kicT+EoibyRIF45XWWfyJqhG7eHawm/TUotdx9emI9?=
 =?us-ascii?Q?Mpe4DiNXUuGsxcMtqHPFRDrEcoru7B6OI42bzz2UYdY36tPVtxszPFRXXp/Z?=
 =?us-ascii?Q?Xm9x2/w9+HSYwufrT7Tnk9kak0hWqWUW2l5nkX9NVyNCGC0RrK+cjCjeJ6VM?=
 =?us-ascii?Q?A9Jc67X8VqxIxcx+dnlarS+HCePH/2FrnoI5y4SZ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ba574766-d1b7-42b9-9e4e-08dd5ad445a8
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2025 04:23:10.6102
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GWWe6dLdjVygbJkbzeEhPUB3S8yvKabFSrU580b/HpuXgzZhuPIvw3NFPpi9LafCZMCKzNkERBPZI13cFdzi6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7570
X-OriginatorOrg: intel.com

On Mon, Mar 03, 2025 at 05:11:31PM +0100, Paolo Bonzini wrote:
> On 3/3/25 02:23, Yan Zhao wrote:
> > On Sat, Mar 01, 2025 at 02:34:26AM -0500, Paolo Bonzini wrote:
> > > From: Yan Zhao <yan.y.zhao@intel.com>
> > > 
> > > Introduce supported_quirks in kvm_caps to store platform-specific force-enabled
> > > quirks.  Any quirk removed from kvm_caps.supported_quirks will never be
> > > included in kvm->arch.disabled_quirks, and will cause the ioctl to fail if
> > > passed to KVM_ENABLE_CAP(KVM_CAP_DISABLE_QUIRKS2).
> > > 
> > > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > > Message-ID: <20250224070832.31394-1-yan.y.zhao@intel.com>
> > > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > > ---
> > >   arch/x86/kvm/x86.c | 7 ++++---
> > >   arch/x86/kvm/x86.h | 2 ++
> > >   2 files changed, 6 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index fd0a44e59314..a97e58916b6a 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -4782,7 +4782,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
> > >   		r = enable_pmu ? KVM_CAP_PMU_VALID_MASK : 0;
> > >   		break;
> > >   	case KVM_CAP_DISABLE_QUIRKS2:
> > > -		r = KVM_X86_VALID_QUIRKS;
> > > +		r = kvm_caps.supported_quirks;
> > 
> > As the concern raised in [1], it's confusing for
> > KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT to be present on AMD's platforms while not
> > present on Intel's non-self-snoop platforms.
> 
> To make it less confusing, let's rename it to
> KVM_X86_QUIRK_IGNORE_GUEST_PAT.  So if userspace wants to say "I don't want
Hmm, it looks that quirk IGNORE_GUEST_PAT is effectively always enabled on Intel
platforms without enabling EPT.

And kvm_mmu_may_ignore_guest_pat() does not care quirk IGNORE_GUEST_PAT on AMD
or on Intel when enable_ept is 0.

bool kvm_mmu_may_ignore_guest_pat(struct kvm *kvm)                               
{                                                                                
        return shadow_memtype_mask &&                                            
               kvm_check_has_quirk(kvm, KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT);     
}                                                                                

After renaming the quirk, should we also hide quirk IGNORE_GUEST_PAT from being
exposed in KVM_CAP_DISABLE_QUIRKS2 when enable_ept is 0?
However, doing so will complicate kvm_noncoherent_dma_assignment_start_or_stop().


> KVM to ignore guest's PAT!", it can do so easily:
> 
> - it can check unconditionally that the quirk is included in
> KVM_CAP_DISABLE_QUIRKS2, and it will pass on both Intel with self-snoop with
> AMD;
So, when userspace finds the quirk IGNORE_GUEST_PAT is exposed in
KVM_CAP_DISABLE_QUIRKS2, it cannot treat this as an implication that KVM is
currently ignoring guest PAT, but it only means that this is a new KVM with
quirk IGNORE_GUEST_PAT taken into account.

> - it can pass it unconditionally to KVM_X86_QUIRK_IGNORE_GUEST_PAT, knowing
> that PAT will be honored.
For AMD, since userspace does not explicitly disable quirk IGNORE_GUEST_PAT, you
introduced kvm_caps.inapplicable_quirks to allow IGNORE_GUEST_PAT to be listed
in KVM_CAP_DISABLED_QUIRKS.

From KVM_CAP_DISABLED_QUIRKS, the userspace knows that honing guest PAT is
performed on AMD.

Is this understanding correct? 

> But KVM_CHECK_EXTENSION(KVM_CAP_DISABLE_QUIRKS2) will *not* include the
> quirk on Intel without self-snoop, which lets userspace detect the condition
> and raise an error.  This is better than introducing a new case in the API
> "the bit is returned by KVM_CHECK_EXTENSION, but rejected by
> KVM_ENABLE_CAP".  Such a new case would inevitably lead to
> KVM_CAP_DISABLE_QUIRKS3. :)
Agreed. Thanks for the explanation:)

> 
> > Or what about introduce kvm_caps.force_enabled_quirk?
> > 
> > if (!static_cpu_has(X86_FEATURE_SELFSNOOP))
> >          kvm_caps.force_enabled_quirks |= KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT;
> 
> That would also make it harder for userspace to understand what's going on.
Right.

> > [1] https://lore.kernel.org/all/Z8UBpC76CyxCIRiU@yzhao56-desk.sh.intel.com/
> > >   		break;
> > >   	case KVM_CAP_X86_NOTIFY_VMEXIT:
> > >   		r = kvm_caps.has_notify_vmexit;
> > > @@ -6521,11 +6521,11 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
> > >   	switch (cap->cap) {
> > >   	case KVM_CAP_DISABLE_QUIRKS2:
> > >   		r = -EINVAL;
> > > -		if (cap->args[0] & ~KVM_X86_VALID_QUIRKS)
> > > +		if (cap->args[0] & ~kvm_caps.supported_quirks)
> > >   			break;
> > >   		fallthrough;
> > >   	case KVM_CAP_DISABLE_QUIRKS:
> > > -		kvm->arch.disabled_quirks = cap->args[0];
> > > +		kvm->arch.disabled_quirks = cap->args[0] & kvm_caps.supported_quirks;
> > 
> > Will this break the uapi of KVM_CAP_DISABLE_QUIRKS?
> > My understanding is that only KVM_CAP_DISABLE_QUIRKS2 filters out invalid
> > quirks.
> 
> The difference between KVM_CAP_DISABLE_QUIRKS and KVM_CAP_DISABLE_QUIRKS2 is
> only that invalid values do not cause an error; but userspace cannot know
> what is in kvm->arch.disabled_quirks, so KVM can change the value that is
> stored there.
Ah, it makes sense.

Thanks
Yan

> 
> > >   		r = 0;
> > >   		break;
> > >   	case KVM_CAP_SPLIT_IRQCHIP: {
> > > @@ -9775,6 +9775,7 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
> > >   		kvm_host.xcr0 = xgetbv(XCR_XFEATURE_ENABLED_MASK);
> > >   		kvm_caps.supported_xcr0 = kvm_host.xcr0 & KVM_SUPPORTED_XCR0;
> > >   	}
> > > +	kvm_caps.supported_quirks = KVM_X86_VALID_QUIRKS;
> > >   	kvm_caps.inapplicable_quirks = 0;
> > >   	rdmsrl_safe(MSR_EFER, &kvm_host.efer);
> > > diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> > > index 9af199c8e5c8..f2672b14388c 100644
> > > --- a/arch/x86/kvm/x86.h
> > > +++ b/arch/x86/kvm/x86.h
> > > @@ -34,6 +34,8 @@ struct kvm_caps {
> > >   	u64 supported_xcr0;
> > >   	u64 supported_xss;
> > >   	u64 supported_perf_cap;
> > > +
> > > +	u64 supported_quirks;
> > >   	u64 inapplicable_quirks;
> > >   };
> > > -- 
> > > 2.43.5
> > > 
> > > 
> > 
> 

