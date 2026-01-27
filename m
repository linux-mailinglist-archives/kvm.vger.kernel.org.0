Return-Path: <kvm+bounces-69214-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id DiVDMyNveGmjpwEAu9opvQ
	(envelope-from <kvm+bounces-69214-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 08:54:11 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6171090D89
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 08:54:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id ACC37300B47D
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 07:54:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C4592FD1DC;
	Tue, 27 Jan 2026 07:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EOELqWEg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F2D1E520A;
	Tue, 27 Jan 2026 07:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769500444; cv=fail; b=fDWXOCZjOMZQ3HfOd+oimagcreOKqXIqBxgY8jGat361RFObEX70UWY5FmxlXB0ZJNGykN9rZSHI/cctt404jFKFZN14PmIHmke/N0B9zZiefgbT0T8YSc+dwedErkXaCSHnclgHC9VczJXYzKGBNmkdYGLyq4ILVosALaZPVk8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769500444; c=relaxed/simple;
	bh=kGBy2KHPNpqhsqEh5orIbw+RDjuCYk8rzR4zPxwYxIQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=qeRUYfRdFR6kvDkz7mXNONpPOhMcXei++2ZlZDmlzEWMuCFL/eHqKIdA9WDALqPm/Fi7d6Sn9PdQ/JxBJvGDXPn39Fqzl4ZQQdEzxtEtp78NEzHOnXQiGum0bRC45HRJcXjlfUCv8MGoagkQ7BP/XDQr+8H4+5Nvmk5c3bkKf38=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EOELqWEg; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769500442; x=1801036442;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=kGBy2KHPNpqhsqEh5orIbw+RDjuCYk8rzR4zPxwYxIQ=;
  b=EOELqWEgSH8tVukFwLCYuFogcPW2Bzuhh0nkqXrw4nOOHka7lX35Cg8y
   NxvpqA6UOkfYU4VImgMggjSHAuddQIVmik4RkGc9AiFPVKHuN9ui9gD0n
   sGexA3Er8g1A7NedGfojjhxkaRQbec+cWIZz0eb3IAbYtQ7K/+zsc+eoF
   RSARYnOcElDtO+DpU9dXqpfC9Y0sh2925WRZYgI1CtnMM3kw+6u+doVo0
   C8/WwM7xKEmk57VdwLttW0d2kgNpfEpgh3Ia4NyVKErJm0XP2zvySczUe
   GwY7jOJ+tVu4QlNQS/HmBHK1lKMsZnU5+XIqQZRviM30j1LrSfhdIHTn9
   A==;
X-CSE-ConnectionGUID: QcCA51A1TjmR2xjbyTVmcw==
X-CSE-MsgGUID: Dc0uBil1RqmlXQUCf39iyA==
X-IronPort-AV: E=McAfee;i="6800,10657,11683"; a="70850169"
X-IronPort-AV: E=Sophos;i="6.21,256,1763452800"; 
   d="scan'208";a="70850169"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 23:54:02 -0800
X-CSE-ConnectionGUID: 6OdvizBETtqB8Hy5/cSQ3A==
X-CSE-MsgGUID: iWz7AAO4RR2BvUfsoSuz7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,256,1763452800"; 
   d="scan'208";a="207140870"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 23:54:02 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 26 Jan 2026 23:54:01 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Mon, 26 Jan 2026 23:54:01 -0800
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.40) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 26 Jan 2026 23:54:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yiggU05xIs0qpGsvHk4P9jbKCORbPMAtbKrIN/i7yDuMk5UuRvdb6QyDmuTBLwkdm4Nxd5diCoGHOYLlxmA1xnuvXDk82xXwaM5XnnQIDPLvZAqtDQmF1jWyG1Rt9JzdZvt+Ul2Pb+kO1wdjWUBMU/BKZtqV5wnnV15PPopp157pYAqcNHAREauqWaxF5OOWq8g0WDhdewfoo86ID+lM9C4cOWi7+dp/p2p5wTaz7j4S+uGf/CpmDh/Ze8oJndCr3zlzG/HOGh1BPzyz8GDHPdYBxrkb5bLVflD0h6hZaqDIwek8OlVwFNjj4XteTH1elNxFaVf5yXB5OoSBfwCUrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ns6EIjqfsZIGQWeaC8YizicwJJTTQnsqi/WnPw2E8So=;
 b=t9t8gZZz3I4b4X8kJwd6PQCTgnJoFUsaoYyPENS4iXt5tuehYtv04GFDjB8pPn7fAqgo5YnMDqTcJ9XTozjh8X1wxuW5h9lcO3HNVipfzIR95Oa2YuHoJ8SyWlw7T7P41m+hst12Q3FDmeBHBGbzRHrwbPQg5pevTMf0co3p9p5eQGKMcickDDFDAYOBshxx5K029HwX2ZD+AjjEGF6OI4fttLWtV/hRZ4+Y6dQW+uTpGWEf9UfCbAfoxS+nrNV8XLLAuslIsOp10CxFsX9RBPlOREIWgbTahLDEhng6ZmA27jzpRHcbVhzX1tUM50eamFJ1pDzEA5mHCHl4v8mUgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH3PPF9D9CDC305.namprd11.prod.outlook.com (2603:10b6:518:1::d3b) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.10; Tue, 27 Jan
 2026 07:53:59 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9542.010; Tue, 27 Jan 2026
 07:53:59 +0000
Date: Tue, 27 Jan 2026 15:53:51 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Mathias Krause <minipli@grsecurity.net>,
	"John Allen" <john.allen@amd.com>, Rick Edgecombe
	<rick.p.edgecombe@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, Xiaoyao
 Li <xiaoyao.li@intel.com>, "Jim Mattson" <jmattson@google.com>
Subject: Re: [PATCH 3/3] KVM: VMX: Print out "bad" offsets+value on VMCS
 config mismatch
Message-ID: <aXhvD9DT4YtKAcIr@intel.com>
References: <20260123221542.2498217-1-seanjc@google.com>
 <20260123221542.2498217-4-seanjc@google.com>
 <aXeA1pTiDDtikdWD@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aXeA1pTiDDtikdWD@google.com>
X-ClientProxiedBy: TP0P295CA0033.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:4::14) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH3PPF9D9CDC305:EE_
X-MS-Office365-Filtering-Correlation-Id: 97f95492-69e8-4de8-a909-08de5d793aad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?uh+2p587n9hsjmmN3LEWIiUs69WWiycqfg8woBKMyPY2Oo7IR3k2vqPKPkws?=
 =?us-ascii?Q?Bx8B2iPvrqC4f5PaKj7p7LH8NsBJAv5NX2Mqp+YFQpgi2v9BNldZX8kp/EFr?=
 =?us-ascii?Q?yAnZprRdv+ComtKnvoTXKDHqcc1PQdbzmx5nyNtraRWPi+kNlqnHf4FJxim0?=
 =?us-ascii?Q?8jcoae8LY3Bzv6Kocl8s9f2mHRFgpxqCVKpoL4OsbafFau+OW34zbhI7l12V?=
 =?us-ascii?Q?uDGtvFXKi65yiMoUmIGMMkZofF9vRBKMbGQ5wbTH8V8azWL4j7uJ4OIu2TTZ?=
 =?us-ascii?Q?dQHiKpOoh8lVXMaHW6m1UoYFvfGZEMf+d1ox5sEI3Ld3+VKgLNj/iSoEfXSp?=
 =?us-ascii?Q?JtohWEj5ZODpeFtNaVBYvenSUp4jt8cdi+N5z+2TjfbW3x0WzaZs8pPIJq0n?=
 =?us-ascii?Q?arOHDm0Vah+IbcS44qYUMCbXUbmqO1w1HqC2FjsWCM0Pslk7Yen58T2EqzCE?=
 =?us-ascii?Q?OA7VcJRAercoYMFvDCSxRfweVCryn9OHYp/q9jgN/DrZ7ve/FUV7rLp78Ve2?=
 =?us-ascii?Q?khWzcU+hKDPOS2h0YuI913k4+BvWCsEnNpe7Bn7pngU2LoAt89PnSoKlHWXq?=
 =?us-ascii?Q?raaFOtoBojuTl4QW9SNW+sx0G5Bu7V7IJbLQLsL7W0oW+Y9ZsRc6JU7H5IfU?=
 =?us-ascii?Q?pyo1lNZ/Lrt+rK+EpnyeVobSckKgNE4J5opW9ZJVuvLzrLucIzEZdXmksT4g?=
 =?us-ascii?Q?HSXFxe23eWEuBT27JcQ32QwHa7mwfdZR4bzvoJ0EQSS02JqOyhLgtN4JygJ9?=
 =?us-ascii?Q?xLIbSkp/IxBuzEpot2U67eUkRHy4JsGZYTRaLJrb6LxokUC4bqxvWi9RQ/p9?=
 =?us-ascii?Q?uDRMGPZ/7rW1REyVcMuSSX7laxCskVlO0SokPXaHjVtf0Zc2wpRaOiLCm8tf?=
 =?us-ascii?Q?5y2RRL80LLjBZReDSRpMP09iDoRC9VGt2kvGIzvamMsUd76iwubIhqcnM51/?=
 =?us-ascii?Q?jugtEyQB0SLRaTPp8r/tArh39JSTXlDNwG16qOsKPjSnRh/eCH8oot0AFGdJ?=
 =?us-ascii?Q?BzBn9vfUGrX2aJdI9Z6Rn9Zbx3sShfYZovRJv7vVmyGd8+CwZXW+ZneTHb3l?=
 =?us-ascii?Q?iSZr648ux/JW/UyI0qxJ6vmIP+vzMZI6Q41VXBLd3TmpOgU1iecqXtnqwctC?=
 =?us-ascii?Q?r/4YehpbjikZNxDfAn0Jv7+wtu0+D1axbH5WxBsPeNNloomOjfD6rn55d8C+?=
 =?us-ascii?Q?0CV6yyPj9N1xzX7tK5mt1EzpzgRL2k1ytjVmSyEhRX1Lo+dbG5mYdtDgM5L3?=
 =?us-ascii?Q?X4Ne40OS+tJ3Sf0+SYRMi2uMsv+FZz5CPB8/TR9UG1THc8E0bANUGsdMIx/r?=
 =?us-ascii?Q?L0013yw+LAXeXxMU0rg4kqiMUp9MUWeyqr2pa04wQ1ARp7Y9QBAGWWZ1jYZ9?=
 =?us-ascii?Q?ldyQfYwdl19EMq0MDdZCdfhAa34xLGLKhc1CoLWlw/+YgQVQ8etoobr7Orza?=
 =?us-ascii?Q?dhj83WrkdW2dKWmxYfifUcRNIQ3Tq3IFNHGYR2M5Xj+8+wBZqn3yTSmq0s+8?=
 =?us-ascii?Q?sosF5PlCWWF+sWGd5tmsmkTygi9elJN8PlENIw+iS1n1Q4aztMRR6QSX18IU?=
 =?us-ascii?Q?vIe5UZxB+EaKnjeKGms=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rK3C8ByC0ZreXs60XONLB3nSSgITbft5PThTF/8YDpMdmVLpYBL8Cp5NKOuW?=
 =?us-ascii?Q?nBNLFidrRv0mvSuRswyMRF1NYvuZV6VGFTzvUFDuMGqu0w4M6DMfgtbOcPUt?=
 =?us-ascii?Q?ot6XRCbbPR8VpNYGwzH9LLjKT4cv3qSC2LG4Vc6OcKKFrzDqw2E7LOthKgRq?=
 =?us-ascii?Q?RVxJ9fzuNP/1+xFcX77AdiwToRVpn5xJL58wtaY7M4hns+mJjhjld93MLcJY?=
 =?us-ascii?Q?kj3l7OidmE4hqQ+wzb5r+52m9gR/hBMy74z4SgY1BBmTxoTPQbjrsHvbGPry?=
 =?us-ascii?Q?syc12afVaAVGmhftUa978cx2e0E/eCwtPFfQPg2UEEOaJ5jDOuVAx9KOKRHI?=
 =?us-ascii?Q?8OQtGgZUm49qD2l+xisSPtdrjM13vIGIT05GmHjTxSBN1POXROeQ2QwmELIs?=
 =?us-ascii?Q?FdaI8Q4DXwRCaxG9PzBNztvqiXQPAmc0AOtDlq9/WyY5n+Wec4nL7kDPT5So?=
 =?us-ascii?Q?iQnEJW1fKmHGh8m5rhVHDysjbYISrQ4b2xhL4W+DMHG1Xk5yUB9MzxO2iac6?=
 =?us-ascii?Q?ZoYPrXA+9zQWzg/7m8tIprkroyqz4RVUGFZtW9bpciF0K7ba3YABwf/7ouSB?=
 =?us-ascii?Q?5FEBBiupY/ISg/q1rkEMsDHRYa4Sh0BYdDsMY6NVLZTfMLrOcNppyZySZRRz?=
 =?us-ascii?Q?E8IV4o1KI+W9p5q5mZ3w/nGYKwrpckJYFHE9AOjD+dm9z2J558fDBTGZss+1?=
 =?us-ascii?Q?Utqe2L/tqZEPSRlCV46bR63VO7QGEsuN/kOEeA/kLIIpfZMmQ46JIUMG/riS?=
 =?us-ascii?Q?k996HtHhwCoUvhHFaT8/rkO2E9gy/JfbxFJCqEC5Zmi6DU3PkqSg9IueB6h5?=
 =?us-ascii?Q?p1lwlj/zBaJag24gfF4KJpwAT2qH1bLO33zrEEbV8Q/NYvjWqihBGxse6sSP?=
 =?us-ascii?Q?i3S7fCQ0/9v4KiukKzSxuIf+n9ixNDCN6WspG1VmeE1bsm5uUn1mQwhlOxos?=
 =?us-ascii?Q?yfENGdJx1laoESrw11rA35M5bo6JFuwvqTZ1EaNZvyx6tc380fVKbdpeLsgK?=
 =?us-ascii?Q?3UMR/8HlPUY6fQRh+Tjp2nrZjEfqJbtYrgSA7LXMigWhy8kMQ/LgeYksn3nJ?=
 =?us-ascii?Q?KvcGNorQBQGtWnsgezxej2hui4Zw1VYD6osTdsNhz0zGLOxNJro8C79Rx3mG?=
 =?us-ascii?Q?0RrG/oMRMWX71CFSx5Mpyk2vHB1FiVpA/+ixO67qGv2+lIVPAlFIkP6ixY+7?=
 =?us-ascii?Q?sc6QxWg2w6Ny74klLC3HmK9ZeW1mbr+6gV1rPWvJfJYq3FQXFjJ4EHIjvpGa?=
 =?us-ascii?Q?w6pMlWc+0XkXNLVDCqGCMoZUgbaJorqjHtZCboZbRUsZYsj230ZzluAwxR2h?=
 =?us-ascii?Q?d4fq0nkM1Ur9BvfJKkx9OlDoTFO2Ff6vqOEYAD4MPUte0MEuZtGXsULq3B2E?=
 =?us-ascii?Q?IjCSmF3FdV8wKM536e6N5LyBCI6kCSbYq2ZAI4SbT4VonEZialHmxIlSTC9z?=
 =?us-ascii?Q?N0s0vrQi+OStayk4tuTEVOsO3f5gLAUiJwVili+e+1ute7H5s7d9BctxeVr/?=
 =?us-ascii?Q?SHDxPv6xnHjLxCnwyl1BithfWQyxcjmV45nJ/mrQugnk+TGqGfN/18gzXo1l?=
 =?us-ascii?Q?z6VKYzpxA7YYr08p2RVH8WnPgSwbhQfMQy0AmXtmSG1Mc0TjgrlEFCMoo52v?=
 =?us-ascii?Q?vqtvRd0CGdTRRi/CzbEeeTgOzu5ZjBujlmlytVVwNMhgGld2C+hjA7NBaMDq?=
 =?us-ascii?Q?euUfeOBCHedtxlia5wstZJyUdL5cQZxJ8to5YsL21op++kz/aGlNHg+qKHBz?=
 =?us-ascii?Q?haFRnccsFQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 97f95492-69e8-4de8-a909-08de5d793aad
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2026 07:53:59.1324
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ldEWCupRNU+k45iwyxWKRY3UdTGtlSJACnUrFXcy1NQfRsPjzGPand4Lh4ZxS4LJj0n6heTdOZl7+hH75n69hg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF9D9CDC305
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69214-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,intel.com:dkim,intel.com:mid,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns];
	DKIM_TRACE(0.00)[intel.com:+];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chao.gao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 6171090D89
X-Rspamd-Action: no action

On Mon, Jan 26, 2026 at 06:57:26AM -0800, Sean Christopherson wrote:
>On Fri, Jan 23, 2026, Sean Christopherson wrote:
>> +			pr_cont("  Offset %lu REF = 0x%08x, CPU%u = 0x%08x, mismatch = 0x%08x\n",
>> +				i * sizeof(u32), gold[i], cpu, mine[i], gold[i] ^ mine[i]);
>
>As pointed out by the kernel bot, sizeof() isn't an unsigned long on 32-bit.
>Simplest fix is to force it to an int.
>
>			pr_cont("  Offset %u REF = 0x%08x, CPU%u = 0x%08x, mismatch = 0x%08x\n",
>				i * (int)sizeof(u32), gold[i], cpu, mine[i], gold[i] ^ mine[i]);

Why pr_cont()? The previous line ends with '\n'. so, a plain pr_err() should work.

Anyway, the code looks good.

Reviewed-by: Chao Gao <chao.gao@intel.com>

