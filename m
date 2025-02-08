Return-Path: <kvm+bounces-37651-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CDA58A2D31A
	for <lists+kvm@lfdr.de>; Sat,  8 Feb 2025 03:31:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0804B188E325
	for <lists+kvm@lfdr.de>; Sat,  8 Feb 2025 02:31:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66F951624C9;
	Sat,  8 Feb 2025 02:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MA/cM1+u"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB554256D;
	Sat,  8 Feb 2025 02:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738981867; cv=fail; b=H5925BItowlmv4nKSK3+fPtwKFKIahmBRgvkq/r0d1egbnLWtRoEV0+En1YhAJKnNXAb1qxQf6w+kJrFNWEpB558GkSQPQNEgHuC4HXSE094/NjK6tkp5zcWcJ1pA9H2tLExJjfGzkZ99s8XZGfW9GHl+Sg9D8U1HQ7xuRBCD+k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738981867; c=relaxed/simple;
	bh=0mwOxzJ6QkfGPwt/xrpo+nJzGCporP8H1j/W+XjyWls=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=K3WxZ72qHe/BvghSv06dQuFwEKxmT6PbVpLnOmvXrX2N59xwp3tbub27wznoOpzIoRgcHRXrzqsHItl3P5MsbW7PQghcGWnePqKcsUVieB0JUrMJEOPfahT/vsf8YADqrxVlg9qblJsFJZ7joA2NK2nApqAaS7GG8vBZMZ7653I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MA/cM1+u; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1738981866; x=1770517866;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=0mwOxzJ6QkfGPwt/xrpo+nJzGCporP8H1j/W+XjyWls=;
  b=MA/cM1+uVzeicQD3J8lw/JV75VRtUszYSRdTE+J1rCVP2uooNOmjNlOJ
   zbgHzG6zUmKAYlb6T5NUEuqHWdduV7Fr5GI60+yivFsmJIMONro1Lmv72
   kvOMalrfEbMXvAoM9U/YO/NMpd5c7+9bS+ZaC5cxLMJjuuwQ0fOdlkHBQ
   Xmm8G4dPVVuU85izxg2y/5HukkG7kVkukxUjPfdTsN0QgbtHNS0N2AgNc
   Nsx4yJqaSoNlOxzfyhRF29Mgwi+Q3lkihZxUDTLBELWDdOM1xSuazOs8B
   GFYtVl3XgXrgDqQ3rcLAjejg+sfkqG+Pe9SLpOclnBZxfZRSlD9fie6TY
   A==;
X-CSE-ConnectionGUID: l3uSxC2aTw6YClQxo60Y2w==
X-CSE-MsgGUID: FpBjzzYdQxaWyWYVtYYLsw==
X-IronPort-AV: E=McAfee;i="6700,10204,11338"; a="39788311"
X-IronPort-AV: E=Sophos;i="6.13,268,1732608000"; 
   d="scan'208";a="39788311"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2025 18:31:04 -0800
X-CSE-ConnectionGUID: aM1+zX4nTnqoCqQ+HsnjfQ==
X-CSE-MsgGUID: EnVdCxgCRbO9SwfoXBCo2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,268,1732608000"; 
   d="scan'208";a="116689556"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Feb 2025 18:31:04 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Fri, 7 Feb 2025 18:31:03 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Fri, 7 Feb 2025 18:31:03 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.172)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 7 Feb 2025 18:31:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EPl0q3WRZLniXvmziiFPm6czlV1EKuhwh3RidQAs3S2bfgspfcA2GV9Ah8vbK7lk0tIPwSgjs5kGnzQbaso5xJ9Mb3W4tqiRvwX3ChFFMx+ZRQc890dGeJxfuCX4VIMsMiNBrdFWGY3mbTlm+Wf2tBgqfGSZ984zDOK6JliGfHLlgTy6mW2Jts/RQuEsYoCokbyRlVt+IxF4s3Zf9gFs3qJd1QK6Tr9NF6ukcqcjot3j+/viDld5tt+LMhk2cvvBYSzfpVHdU2jCNK1asv5uHUeTC+blem+EqqtwT9NJ2T2a1KQ8O1hX6ANO/9OEUrWv+au7EO3q6o9lDZ2TQZulDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vjn/ERD3ivjqeVusP4tLvJhj/vd7xXWxczM+iK4pq3M=;
 b=uc/B3tFxWXOMqRkamKtbpgZ7aGxCbzA2r8LFPtNJO6c7dX0iv21PRxXMUVlE33+L0iQDPNGS0gYGUgI5W1CNpNKVDZa8EjMn/er6XRnG/i8H0Lwl/xilXARcBXehg2UmyVZ5ctJ7JZoIEr/4SXXK8s+9sPyOQqYpoEiYzIQI6vcjnJ/lMc79z632zKeVVQNvANU/rvd1uqJUOWA04vpFoAZ9KvMuWS9z0SrBMx2Pn3RQ2x3Z5E01fiQMc93qVpnk+0GQTz7MyP+CVxtrPXMDEV+d/odGU98CxHX6B3LdgCNllbUQKIV92HZUWFRGWTaEIdLNDIAKqdnZ56uRH+O0xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA3PR11MB7609.namprd11.prod.outlook.com (2603:10b6:806:319::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.25; Sat, 8 Feb
 2025 02:31:01 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%4]) with mapi id 15.20.8422.010; Sat, 8 Feb 2025
 02:31:00 +0000
Date: Sat, 8 Feb 2025 10:29:53 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: <pbonzini@redhat.com>, <rick.p.edgecombe@intel.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/4] KVM: x86/tdp_mmu: Merge the prefetch into the
 is_access_allowed() check
Message-ID: <Z6bBoZOynhI3eV+Q@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250207030640.1585-1-yan.y.zhao@intel.com>
 <20250207030810.1701-1-yan.y.zhao@intel.com>
 <Z6Yg0pORbMyC-9xA@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Z6Yg0pORbMyC-9xA@google.com>
X-ClientProxiedBy: SGAP274CA0021.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::33)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA3PR11MB7609:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a019a80-3537-4a72-b03a-08dd47e8a06d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?7vdTjjijPfVuoHbLTM4keYg2HOl4vYcFwmtchKzdGRwfsgrKTfULT8RiD35B?=
 =?us-ascii?Q?KUzuk8uC+94Kvmm1Q8/7tHo6Z3aPwLyrNCrg6l5xy6rU0TNBc9dWC6IdOF7s?=
 =?us-ascii?Q?mZbu3JzO46puLTvCNlUdy+gP5JjF5y6HeVHdViYGwUBqkba+dnC+vL8fXMDc?=
 =?us-ascii?Q?ktlyPBJFMku7QZLkwYW/ZpnkHcy4lno3hoG9nuISncYe3XBHQ232EDDCecKi?=
 =?us-ascii?Q?Hw1PKBz9hF68NUEqsoU7ahSJKSY98ddLR9crLkOYKIV9E3JD2P6RB3s8Wk0x?=
 =?us-ascii?Q?OxzIKjwQRJAh+wp5q2UH+5OynZfzNetbKTebQH6h7dkys/RtNyglm+makneU?=
 =?us-ascii?Q?ohzNfZb2yHsl0J9KNr9P5OSJVQWsPX2Emwj69K7jMpqpoQyhJRowjCTOWq+F?=
 =?us-ascii?Q?PC+bKsnMFVKNkWexdrtwXlAj2V570sUCo/zESc6uNsAdVASn9NoZyWSn3aK8?=
 =?us-ascii?Q?Ou58zS6fGqjkC0lBAc2RYtBEfMTvRnVTNTHB+K9Dx1i1yNForslUOoJ+u0jt?=
 =?us-ascii?Q?geEeSHZEuHHXyUurSkCumjiDi7B4Qjc0WyF4QceRsl4EPVvx2Ta/bPCarL+N?=
 =?us-ascii?Q?hl0aTtXykX1/mYoXdZRqmjMVe0nSa9JLvc+MirvG8Q0DjneYceFi/KCVmFz3?=
 =?us-ascii?Q?l6O8FUEfEJyWljzZaymLHqCGDbZB7MkqzXiXEyjTLqR0S4zxzyyEe9M4oXwS?=
 =?us-ascii?Q?l/mjtUo5yYuT6WVA8u/9xmOSb43eG744PSkxLcyeO8FM12eLjg4tSmKlVidY?=
 =?us-ascii?Q?lpaNDkRONnA3dMcVawEk1QDj/+mkS3g8myGQBBcLcBFrr7MjEkfCbeT9i/we?=
 =?us-ascii?Q?P454r7Tbe2k7pTzsXNc1eZeU3KUZXTqGFjiYsMLe8dprX5u8JRR1watmmZmm?=
 =?us-ascii?Q?iB0BCb2FwIZga/I7oOpbmiNXo3z24qJh+509wRVbnkIjn9LdnrMcPitLjRIe?=
 =?us-ascii?Q?ZGQjh789GOBznjmJ+ylf5E2IHN23bPdlXwUlllEZe1OUVpjTGAkLXKEIl9fx?=
 =?us-ascii?Q?8PcgQBSiz9qvnZ79kXxZ+IIl1dbHy0AZcVO0src0VZcMVyGnh/DVh0BHQtZP?=
 =?us-ascii?Q?AKjhIgqp2Y3Q6E0OSEDOzU40B2Qj/v5+MBKM04punzf3NiXX8AYv/BK9UfTr?=
 =?us-ascii?Q?QoNgCCRffPh4nB7xHcKNJbYhK57snqp6zddyxWwiWZFzE19DKAu8X/9rgb0k?=
 =?us-ascii?Q?Wcm4JjzlxHBVTQjQJRBhZorKg48/5zZjCrIn2ukKeIM0TKAaSfZEtWMAuehD?=
 =?us-ascii?Q?kDM/C/ylWkaDb7RGXCFd/ViK5T5loOG/DFYpfNCVfebqoiBXYWS2eg5EeqUm?=
 =?us-ascii?Q?p9nuWVzPASLhPDn/gJcZKjWK9DQdvhhdRZq2YQ4piKhHdtc9DZxs5AvBK61L?=
 =?us-ascii?Q?DHhXtYw5wCIPaiAeZTRWLBE33j26?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?K1d/7Y4tYoBMRfP/DvQwLAQ4xU8r9P4FdiyiBejJuJXkeugvjBzRRk5DC0ym?=
 =?us-ascii?Q?bTlhVPMODey7bB/HN9tYHrTsOjYTDfjMqoNVM16bnMXWoAJu30XGKta8rOaJ?=
 =?us-ascii?Q?x7prJ92yb+IolncJlEiV0cgO3x2DKl9yPwTqeW4Kt9yzeCTZh98z7jq0G/lZ?=
 =?us-ascii?Q?YnBrzlZYApJ60ouLl2b0cJ7hfiP3lYtZ8BKBPtRI0e6cTIzi6Ia/noS2CPyc?=
 =?us-ascii?Q?lYgCcJWDfQ/wuPrnWRl7v6r+ieR00DVcNrVBNfIpWEagcwf6s1PQxDPf4DNS?=
 =?us-ascii?Q?0JbCvSdZCkA7/1MX41DkMmfkVqezAfAOhzeSEjCGyH86cVY6vBgpsfu/9OzL?=
 =?us-ascii?Q?ox5TfeReTD9amGhE/yNLvmoKGRBa7XPgP/8DUKdV5KpRutXv3r89jNQ2CgJp?=
 =?us-ascii?Q?BapknghfQzIqzEPojm+drUusV1dFrnRrZ7gNKEQDS8uAuN8JHH0wSz59Ozav?=
 =?us-ascii?Q?z/jrPuMgZIxgz3qcrT7klvYU7K0TD8GE3mWBIl49JxS81xaZksVDKSid8uG/?=
 =?us-ascii?Q?Jx5PRBiWxNk2vwWpeIOH0XB008s2x8hPkAogDVrYNy34c8Gl7AwKyELy3PxB?=
 =?us-ascii?Q?zU//nOH71/1h/AMvvt1picTqx9KdBXCxK9sPasu4oCaCDPr88aDyvhfQqqaR?=
 =?us-ascii?Q?o0IE1y/oodGrjW5ougNHGe0qwphYVVUD08RqkietllGoL23N/lqdTWV0S3il?=
 =?us-ascii?Q?/bAGkW4DBG57BL0xjQwxk5p/68QvvUeouhgpWiba2aPpDUw+qMMnwbbytkn/?=
 =?us-ascii?Q?0XRVe2qGp5UiEpDooEaD3v4+ft1O/TCHfaS5me5Z69N6VP3SmSFiQ3yJ/lSd?=
 =?us-ascii?Q?MlwokNyYGcOLzS/Qpjax0e0T+04z0ClM/bv/+YyE94o7gViediwYNel+V1EJ?=
 =?us-ascii?Q?rriYdGmEP3ogKqhZC2gYKa+j6+Or5HugU8IzUAiQC18GF2hwVT7gn07zmZKA?=
 =?us-ascii?Q?Fy5E2pRWX0DPYoUURFlGzS5J+xtLzFapKiiNRY8QmFJkNCw19gFKBAJhgoDM?=
 =?us-ascii?Q?+esLDIdr3llnV+K2CgAv64MfmASRnK2qZrdZWZ1xqrI+QydaG6S2Ct/hd/Bn?=
 =?us-ascii?Q?h1qbO2FG/tKyXelyxo5nq67bINm5t3xXwsCyUCFaO120uQv6v/8d+519MSdq?=
 =?us-ascii?Q?0sbRfNWbN4ijOoYuF34qWNz1DaXVF4DauvVechPBzr205w2oOv3SS/WpJfr4?=
 =?us-ascii?Q?ojfN5oxRG1Gdm00BQp+9u+5YxdIn3Tvqn+kIXyeOvusLmFmNmEOfzS1YL616?=
 =?us-ascii?Q?MijWrBvLXvO7xVRSVq9V0rAHcGeby7ybEwrWTnyd83p+YAZSJOD6ilSR+AwO?=
 =?us-ascii?Q?kcsw7fW/j62ZQRWzbbT5zxyj5duK8CGtjJ3H+9Ba8McYNY7H1koCBVOr0Qij?=
 =?us-ascii?Q?1rIzqmrTuDTUNw73C6wTkta5UII0J9QyC6CSH7DHpvnfd/x6fxXrvxFsBV8H?=
 =?us-ascii?Q?rkUhIgZEpLAAkA/xrY4jyMJyM6ItHQ91gf99qkknJMNHx1eUoEjaquvcZLBH?=
 =?us-ascii?Q?0q+0lnIa+oqM1NlhYgpxrTy04k4napXQclicmgGOrs9RjXoalwDsoQmSxLup?=
 =?us-ascii?Q?KQ1JpvWuVRp7T4rIcq6FsOWZy+hAlPhnSRbB0C3z?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a019a80-3537-4a72-b03a-08dd47e8a06d
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2025 02:31:00.7408
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LnXcRFFmBvNj5m3+FyZVCb+IaOKP+PzsAn6vca3W96W2cgzYp+2p8woOetBVM/vR1csMsHW6VqAlbzSgrgrqbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7609
X-OriginatorOrg: intel.com

On Fri, Feb 07, 2025 at 07:03:46AM -0800, Sean Christopherson wrote:
> On Fri, Feb 07, 2025, Yan Zhao wrote:
> > Merge the prefetch check into the is_access_allowed() check to determine a
> > spurious fault.
> > 
> > In the TDP MMU, a spurious prefetch fault should also pass the
> > is_access_allowed() check.
> 
> How so? 
> 
>   1. vCPU takes a write-fault on a swapped out page and queues an async #PF
>   2. A different task installs a writable SPTE
>   3. A third task write-protects the SPTE for dirty logging
>   4. Async #PF handler faults in the SPTE, encounters a read-only SPTE for its
>      write fault.
> 
> KVM shouldn't mark the gfn as dirty in this case.
Hmm, but when we prefetch an entry, if a gfn is not write-tracked, it allows to
mark the gfn as dirty, just like when there's no existing SPTE, a prefetch fault
also marks a gfn as dirty.
If a gfn is write-tracked, make_spte() will not grant write-permission to make
the gfn dirty.

However, I admit that making the new SPTE as not-accessed again is not desired.
What about below?

@@ -983,7 +983,7 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
                return RET_PF_RETRY;

        if (is_shadow_present_pte(iter->old_spte) &&
-           is_access_allowed(fault, iter->old_spte) &&
+           (fault->prefetch || is_access_allowed(fault, iter->old_spte)) &&
            is_last_spte(iter->old_spte, iter->level))
                return RET_PF_SPURIOUS;



