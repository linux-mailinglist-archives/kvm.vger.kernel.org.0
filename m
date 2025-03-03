Return-Path: <kvm+bounces-39841-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 73D39A4B5DB
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 02:49:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 23EE13AEA56
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 01:49:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6754145348;
	Mon,  3 Mar 2025 01:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NxbnzQEC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E822C181;
	Mon,  3 Mar 2025 01:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740966542; cv=fail; b=pPihMEnTHSfsAdNHJ6o/RVWalhpszU+9gzeRJd21GkDVA1xXJAJE1KDcGIqsvOzp4XAMKquR0OEIVf4r5Ss38TY7E2fPoUJTxYRkp28g686FnfN6Pwe7+KKiJzTJ7mjeLMNFf6/P5DKm1611wDZt5OoyJWxoSsIYt5rrhK4zre0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740966542; c=relaxed/simple;
	bh=T+WRwqwXYLvDX7SJpd9a0HYXibghPtyTTcMEXGqmwQk=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=envLHrG4bmDF7lMGf7NjIsu0Z7VamrlWvuAZ1m3Ii34ItdCCzwJnmn5uIcLQu73+FggHATAP3ruOWIqoeAmQSGli1q/2OQFG3VIGIo3LT+gYBg2IUvEdURZhod9xstpv+TqfAonnLMzRlzeCVziMQOtwWSHGNoC+7c0RUebtloY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NxbnzQEC; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740966541; x=1772502541;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=T+WRwqwXYLvDX7SJpd9a0HYXibghPtyTTcMEXGqmwQk=;
  b=NxbnzQECnScyz8nH+N+tb7UIvA6Vqpn+0mEoed4zGhCXvLYJDUzbaz8e
   Z2ak9YRUDG7mBSuDjDiutgGQYonp/beOAoUowzVN/BezjjzLzlfvqEEwY
   jgCWA/x8KasGXf7TqtFhSJz7FOxpUpwKKS8B7mO1UmIC2I4FsIjJqAfze
   bpf2Zp9KWnYFFXv1U1IlcSTgakS2Gt/rJkCMA55YbMmhYU81BOhYuD0h0
   It8Vwx6utxIg+TITCGmLxG2RIJi+hFelOSq3oZrjlThUVd8LddKEnDhzQ
   UwplXjZJKiAmQGdD6fc0f6vLcU7RHK76hlis/eIgZ6kWZ1o4sfTUXQnn7
   A==;
X-CSE-ConnectionGUID: p1/yVMmLT+2KokwAX7QTgQ==
X-CSE-MsgGUID: aaSq+CiJSVqmIZKtJvfiKg==
X-IronPort-AV: E=McAfee;i="6700,10204,11361"; a="45756102"
X-IronPort-AV: E=Sophos;i="6.13,328,1732608000"; 
   d="scan'208";a="45756102"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2025 17:49:00 -0800
X-CSE-ConnectionGUID: 1XM39J9GRzS1Bc+FpRoI/A==
X-CSE-MsgGUID: aryC0Fe8QRSZIM8Nqjyp2Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,328,1732608000"; 
   d="scan'208";a="148670251"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2025 17:49:00 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Sun, 2 Mar 2025 17:48:59 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Sun, 2 Mar 2025 17:48:59 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.171)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 2 Mar 2025 17:48:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HN6JCf5jU4hcumtuU++xaCqAdd32eFBFKrHPdVWoPYbcAdTKa7mTkZhfggj9xlvT4NXzthOUMFZ6IEi3aoJHIuD1hYnoPpI5/jGOGik4A9300Q8++/B1AUcTtOO0n2AERLNmJ/OrANE+pDrmK6yy+panEbWyn1cerA3LxRxxOONzrF5jH9kgS6MIBEzIFGwKcuXj7+zb5hBE+pNUilAE+kLZf/4xAcB4lymEUEKp++lMt0+BQsdiSfoKOKIG7Y719ttz/AmQG9fNRWSrCZNiKHqLBzCO/pknHPnVQwkCBTXNyJIH8AVpgTbZsxSmiLz89pSNUWPiXXgQouYAC79rDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lNO6ItiRJKBTedwORBZYXJBu7oKTw7AIJqdbhelSQyA=;
 b=ch1Cr2QRn9PmaHEK5iugiXmDw6H2kZ0c00gEUzpmAT7UXyOp7myCpZROcE7GLEN2QXnVARAMK1ySaGotyNVJlyzcRs591IeR8AgcGgVMZ/dX2KN3tycSsibMv4Jzn127A5qKBghfvM1+mFjnlgFjTmJen/ZS5TlSQA891WA9cDV+O8LdszBJ/mltHetrPxwKHfLTRU/mlcl/FlKOHd0T/P8HFW3NdDqXFWxEobKWWOrog2EhaUZbNQfTJpGJYaRlPmbyhwR/WwDkEVCW2BHtH4oCvsrk7OSPBK2SLPTqj9w+CAXhpWW/wdNmBWmCraArgIH00zL/TcPoNcJ+mUZ/ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA0PR11MB8353.namprd11.prod.outlook.com (2603:10b6:208:489::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.26; Mon, 3 Mar
 2025 01:48:43 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%4]) with mapi id 15.20.8489.025; Mon, 3 Mar 2025
 01:48:43 +0000
Date: Mon, 3 Mar 2025 09:47:24 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <seanjc@google.com>
Subject: Re: [PATCH v2 0/4] KVM: x86: Introduce quirk
 KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT
Message-ID: <Z8UKLApAd/J0sWX1@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250301073428.2435768-1-pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250301073428.2435768-1-pbonzini@redhat.com>
X-ClientProxiedBy: SG2PR03CA0094.apcprd03.prod.outlook.com
 (2603:1096:4:7c::22) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA0PR11MB8353:EE_
X-MS-Office365-Filtering-Correlation-Id: f5e45290-4b22-44d6-a3d9-08dd59f587ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?aG991RIt1UBxIfht4iWR2gMwu7pKI3mlLK03cwQA9ofM5IsXNLu9d1suXVHA?=
 =?us-ascii?Q?7aOBu6uk9XLXW9T9b0cQQycen+/BcaYWvdGBRkFTTTOGogDYoiLdgCXDVJu+?=
 =?us-ascii?Q?42XGCtbwOuRJqJGMw/PKfE7qU+xoITjwF3crcKXXXT+3Ord6Bgl992Ihk7y+?=
 =?us-ascii?Q?AIh8B3Ez0E7DKaXTYe5QBX4lw8STYx9ieaLuZJAptgFYAlgEjnDQ3NzIyotr?=
 =?us-ascii?Q?a1/6197LXtiE8ED6MRu/A/9hLvHKf5O7C/A9cZN8tLj8E7hJ2pT0WBuiGLZs?=
 =?us-ascii?Q?2cQpWz4bVzrUxmEAA+htGo7ohk9Fcd60EsB8Sl4bISoOrqAChIZrPa17TtBb?=
 =?us-ascii?Q?MbCSFqffYhg68IR7DKUldI7RGGZLacOfCRrwAOWLdxKIsf0MRlX3rGpiDOv3?=
 =?us-ascii?Q?4DoIrWM6hupg50JjmvGcN7hk2Ut3nXVfC8M9Q2xA2q7ZZe8lJjZENDL4flyU?=
 =?us-ascii?Q?d184VkAUPXFRzBO4Iwaa8XYmVLx7zqIFzD2OS/PtzPzkZ3ZrjomRuRotk85q?=
 =?us-ascii?Q?3cebMdojWQOXkEcHemQymMzBkFvYAOTVaqSZ/uSvnhAZyh10MF3Crh6XZcDQ?=
 =?us-ascii?Q?y0Wti6o+5IqXHucD2EOrMLkU9RZvVBf5Ll5A+jFjWUd3EqKKpjy1Xsr059MA?=
 =?us-ascii?Q?M+UjcC+0hJYBKYhSwyK1tn+jUhAQAZBErT27+/7wuHqlTce+DH30HB1VHqw1?=
 =?us-ascii?Q?8XRypf5R/sQCHOiD6FCrM4D9h7AotwS+G2bzJUIyBp2O1+TxSt6G/dJU1Bjk?=
 =?us-ascii?Q?PrRJ22+vAf7OJVT+Xrrwr4Vy2zH0t7ZNnMnlBl/KVml9VP//4Cdy+CkyhHO9?=
 =?us-ascii?Q?8lC0DEOAMkeWMjTm4c79UW5AXZ0NSXJB6IeFWJ7zpOGLczWGoNes+oui3Gn4?=
 =?us-ascii?Q?OyHVgYH5DkT/YmiwTnt18nn3Oq1JG5Vf2GMgeaCn3fmHSmBLIlUEyu53MCHR?=
 =?us-ascii?Q?Kqnw5vvoeB/z5sIZ1WC84AJAzpw112VO7qNDG6g8AGQIxiVXjdG7+UwqnqTj?=
 =?us-ascii?Q?PBFd5myhYLeudxfwtuWzZ/vJd+EzK2tUA/s4LzA9Nx4J/LYXF/gyMq4pmz/9?=
 =?us-ascii?Q?KHINVlv+cnkTPo4vYpfcWE6Z9A8H/o6aMzGNAdS90EY68mCcSLUVp38KD/VC?=
 =?us-ascii?Q?8iuIJUJ9T6zsA2RFDJ7hmFewtIfC+ZhhNWKMUr3ptM2E8qtf9Eef1hLhuO2x?=
 =?us-ascii?Q?/yQWUVM4/CuFgBPjcb+L8FNWIbKQzUr093QjrWWn7aXsqYCpGius332BFqjE?=
 =?us-ascii?Q?b2hxn0G60GPQZPxDys4fcwPncTYQTjZCr6RB7Vxo4t3xHSkz3jHYSBfryImM?=
 =?us-ascii?Q?febIsJwbd8TB9xhySD7RKz9KHhV/j+HAMvSsgCMOHIIY3w=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?b8u1wq55it44C7higB4yFaQsyesQ05g4/kCJkIVuB5SLCowRWs1VlBFsqXjH?=
 =?us-ascii?Q?+jk/m0gEVVYX3ggPA5KFefjFSfLez6jUQyeKSfvHw1Pjmnx5EM3C3hrGRHND?=
 =?us-ascii?Q?2fWTaf8dHBtWBKU+PGGdHPLGNdc1Yb/MpQx/CXt1zP2YIM9geXFmMCByHNxq?=
 =?us-ascii?Q?+QFbYf+LcYxBRmdxu8FeK8dJEan2IqfoYNjtbQA3GwIvh56IXiA1Pehr9hNL?=
 =?us-ascii?Q?sNvKPAKLblE/7bh2G9iLrCEiWXQKucg3fZgpFXGgSsTgK25eP+jZourhy1vX?=
 =?us-ascii?Q?re07wetmkLykZQm+ivj4thICZDCdqwVfmmk73jv23vP7gx92YTFL2X8pY8TI?=
 =?us-ascii?Q?g/e/pPND3ZB6G8XSGSPKv6TJN99wGRZWtd+ycwIt5Zud9/tJWfHXnIvZppwA?=
 =?us-ascii?Q?K5C5V9OHlXUwL+yvY1aUnYi+h0Pw9u1K0j64U4f8JNCpQvALDUZNP9DiTEWc?=
 =?us-ascii?Q?DPOBGlbQCmWiCB/XExoJvmzZ1KPkO7mmaUB5rNL6WbTLYNN6xsY/i87FFRMr?=
 =?us-ascii?Q?rBlENJ5LiFN73T1BIxbR951Na1YyNtk1tvwn5KWW0T2UVzqUbFrSeLHD6++a?=
 =?us-ascii?Q?Con0Bcsq+HlOMdZgcC9ASOguPoiVX15xEv0sx5EI+gtT3f/yIpP+LmVSqm8V?=
 =?us-ascii?Q?rMBFNH7ZpjtUbBkE+0qr4gkReVWQXreyn3CfRANp6SxI7vOA9iA19h28IyRX?=
 =?us-ascii?Q?/N/JEBN13ZXDWD+JkWRDI5ZuaetokS/q7xYQ0f/dSEqUgbuLJep6PlHEYNox?=
 =?us-ascii?Q?K6Z2SPaC2MQfrVvJfRTW2ie/O8L/LQgEFVA+hagWsrIAuudwoQkavWw5D9UE?=
 =?us-ascii?Q?4X1pFEVrYT1IYaWCBHpM7UFYyQKGyVUywKyWw6aU7IKxXhs2lbR7B5pQ1VG8?=
 =?us-ascii?Q?DJJpyW0GUERA2QY7alMW/GY8w24q0RnxAXpzI2JXMHrJM5kWzcZ9mdPmtdpG?=
 =?us-ascii?Q?L+csrT6Bwck7yQDn4lrDL8Yg2G5QMPzD9a4MOOWJ2N5tNZELHr1udsR7kWNr?=
 =?us-ascii?Q?phCGUKQ7sl9Bj0PSLumGteXb26f51p8xFNTH0w7fvFOMKTzvdOVsVceh7ptx?=
 =?us-ascii?Q?l1BCrpvTmH9iM+9gHkooSeUI/Bg4Ac/B2pL+5eEsQRUEDbBcEaxzJ+N/NTyU?=
 =?us-ascii?Q?w5CaNOwoLH+Xzl1wqz+wLXZ3KXZjRjllHyNWUzFZEO8joSVXPuZZG8Ydqwaq?=
 =?us-ascii?Q?fVEZ56morl9fnhiu4CBY+7UV8B1Pz4PBxsA7ReQcn0et7Wp2ccc/dmGhrA61?=
 =?us-ascii?Q?Os56cWNe0WZIGvvpPiEfFmwRkLz36TE/XV40z8EGW91Kjn883MRgYcFbr/To?=
 =?us-ascii?Q?3ykJtLifEzTBDzZDfSrIgsKpj+YmIZQngyjvFvGFQoeZTFabERUn8QF2qcHc?=
 =?us-ascii?Q?xI8f0oQxksH1owrbKyOb7dHUKwQH8ZCQCUxePx2wWNl8WGcz6QaXd+YBofAw?=
 =?us-ascii?Q?9LzjoVZggq87MzSeWcCGJGjS7XfivzwwxsKBqraMuF+htI0WYVKTcIi2+NGh?=
 =?us-ascii?Q?/U0maa2gP4r/iLcOde8p0Im6nowzqaR9ZaYxlleL/t+9jdYlZna/0ojXx6l9?=
 =?us-ascii?Q?Lyq3YZM0cPvxVkYkQhxBxRay2zKww+uWHWwcLokb?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f5e45290-4b22-44d6-a3d9-08dd59f587ba
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2025 01:48:43.6758
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1+6qAVWwDOTRF3m7l/iwfnA246GfT8+slZ5fT4dL/i+LG0ziGy5Ok594q4xYQQcH/5xP3S5w4eQCi6zdXiQ9/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB8353
X-OriginatorOrg: intel.com

On Sat, Mar 01, 2025 at 02:34:24AM -0500, Paolo Bonzini wrote:
> This series is my evolution of Yan's patches at
> https://patchew.org/linux/20250224070716.31360-1-yan.y.zhao@intel.com/.
Hi Paolo,
Thanks for helping refining the patches!

Here's a summary of my comments:
1. This is confusing for KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT to be present
   on AMD's platforms while not present on Intel's non-self-snoop platforms.
   (patch 2)

2. Could we make KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT and
   KVM_X86_QUIRK_SLOT_ZAP_ALL always-disabled for TDs? (patch 4)

3. kvm_caps.inapplicable_quirks may not be necessary. (patches 1/3)

Thanks
Yan
> 
> The implementation of the quirk is unchanged, but the concepts in kvm_caps
> are a bit different.  In particular:
> 
> - if a quirk is not applicable to some hardware, it is still included
>   in KVM_CAP_DISABLE_QUIRKS2.  This way userspace knows that KVM is
>   *aware* of a particular issue - even if disabling it has no effect
>   because the quirk is not a problem on a specific hardware, userspace
>   may want to know that it can rely on the problematic behavior not
>   being present.  Therefore, KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT is
>   simply auto-disabled on TDX machines.
>
> - if instead a quirk cannot be disabled due to limitations, for example
>   KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT if self-snoop is not present on
>   the CPU, the quirk is removed completely from kvm_caps.supported_quirks
>   and therefore from KVM_CAP_DISABLE_QUIRKS2.
> 
> This series does not introduce a way to query always-disabled quirks,
> which could be for example KVM_CAP_DISABLED_QUIRKS.  This could be
> added if we wanted for example to get rid of hypercall patching; it's
> a trivial addition.

> 
> Paolo Bonzini (1):
>   KVM: x86: Allow vendor code to disable quirks
> 
> Yan Zhao (3):
>   KVM: x86: Introduce supported_quirks to block disabling quirks
>   KVM: x86: Introduce Intel specific quirk
>     KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT
>   KVM: TDX: Always honor guest PAT on TDX enabled platforms
> 
>  Documentation/virt/kvm/api.rst  | 22 ++++++++++++++++++
>  arch/x86/include/uapi/asm/kvm.h |  1 +
>  arch/x86/kvm/mmu.h              |  2 +-
>  arch/x86/kvm/mmu/mmu.c          | 11 +++++----
>  arch/x86/kvm/svm/svm.c          |  1 +
>  arch/x86/kvm/vmx/tdx.c          |  6 +++++
>  arch/x86/kvm/vmx/vmx.c          | 40 +++++++++++++++++++++++++++------
>  arch/x86/kvm/x86.c              | 10 +++++----
>  arch/x86/kvm/x86.h              | 14 +++++++-----
>  9 files changed, 86 insertions(+), 21 deletions(-)
> 
> -- 
> 2.43.5
> 

