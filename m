Return-Path: <kvm+bounces-52283-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DE96DB03AB2
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 11:22:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3E29E3AE7D4
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 09:21:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D527241122;
	Mon, 14 Jul 2025 09:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U/fwuVb7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 652B820966B;
	Mon, 14 Jul 2025 09:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752484935; cv=fail; b=eoqoD2eIsY4iqaMiMo5L/rsVSWE5sup7umVeyrzS2Lx46COK7DBsEFRHhGN/bHLewdhAtxPi0XA/b18PaD2OnRPR+LnzDDhp9v+69OUxXqMT8qoznp4PeBW+nfya4vyMLt0rTBU5Pq0sAb0eSuo44pvCGSzXgLVrXl709grdCBM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752484935; c=relaxed/simple;
	bh=Dn6haXKl0aA8b8DcEln62Cr8pPmeiocBEvev2D/u1Is=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=nA9qPhFEuvekfjiwMylsr3vmu9PsV6R5QPxlR3+vjAuV1w5IsGhVUnz+1UmuXHlu/Glk1y4anUFkSSgRv3OC35cqjueUfhdcn2oTsj3H2MuWdSwKNvN7IcqMLBckAB2O00plNxUbUHocL1e6iIDVFQmq4hp1QDmzthgx2UWQ/fg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U/fwuVb7; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752484934; x=1784020934;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Dn6haXKl0aA8b8DcEln62Cr8pPmeiocBEvev2D/u1Is=;
  b=U/fwuVb7Pny5JY8NQ7PHFL3YHXnSV0kjl4Q5lufZfOstBggRdpbp4ZtY
   YRZVfUVDvdE5kvRgrl5DvqDY8eXIeY5Cmu/gIu99Yh9skBrNLqW1wjWbI
   6AcKIyPwAW4GwL8ygsGHdc8gYUi+fB+4Kysfke0TgXeBV0kJK3fLBHjIB
   XEBnVL6keySlhYhKK3qr8x9948+tiObSpI6oxf5SJWbIYqv6r7jYY0m5h
   oyo0bOfw3eqbysE0FK9O1F6QNCmJCjvXqVBA6sQBpiPELJW2h9Ik7Lx/7
   6TUHl1yG3pHRV5ieBr/e2VZMO0wXK3xJ3yOLG01vORJ0Dbmx/J7H7LUg0
   A==;
X-CSE-ConnectionGUID: Ps1ahYDeRGyytbQYIW9s9A==
X-CSE-MsgGUID: 7G/s3oFeS7OktHAdaOCs6g==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="54798567"
X-IronPort-AV: E=Sophos;i="6.16,310,1744095600"; 
   d="scan'208";a="54798567"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2025 02:22:13 -0700
X-CSE-ConnectionGUID: lit6y9qvTaKj3iwDM3BrHA==
X-CSE-MsgGUID: LsSAE084SKO7Lu88K+nORg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,310,1744095600"; 
   d="scan'208";a="160906513"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2025 02:22:12 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 14 Jul 2025 02:22:11 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 14 Jul 2025 02:22:11 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.40)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 14 Jul 2025 02:22:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bkUFjtBUGLMfR5atY6pF95h9DJtMZA1Hw6jpFzqNcPkTPqbs5lfkmuX1VClIeu9WiyxECtvEc7IMBA5E2Lp4EWqP5ld44IfZboslfD9xw4iBp84oENzPNzPwEu/jC0t7XL7BaGd/lhvx5ybeytUSH08fj7Pic9TqK4vtpofbM42eyVXg/tqfcB9qe8954ovKYYZ9g99N+19d5w5yvJbtNKFzuFf5zfM5tzHZYqBqOwu/2/70DinHCX3lnIbBXaTX+d3EYcE3ihTSvc9orUM7HgOBaUohOZfjaNEnmfzlvgLXa+tSs2Gf2E3P6e7tmAkQEra7iI1uzUsLbcMin1jFwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rN2HaEmMZLrToZjjB3RaLkgny88M724BvQYdFMFc/V4=;
 b=FHrNnq3ueI6ze9hRCDWujD5xC7iuiXy+WZGGBI9BGdFxPDr1keMrJNzYVf/cewe3Ql52LYimqN5TVl8FLeZvMgDyov2IvUZq1pfEBSGtbJZuBY2PuibSH4ZRfG+YwVM/yzVUhQIV0RkUNj1fD8bDy8/WdpcWHh7g9cI/dKjGIT245eY4MqjAcu7mqZSVdIJHv7FdXu1nz2SF5dYINwH/7xRfqwAjkeaN/yld/+NmWWlqRsZNI4LIUlb0aMJV6AlrG0ZjZ0e3nWZKCX0TSHH70zEAU8VBvCEbk35XgXjj1IUcNy/WOgf/L0Y/vv705PBYeHfMJKLzarBqQJqIheIduQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by IA0PR11MB7259.namprd11.prod.outlook.com (2603:10b6:208:43c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.29; Mon, 14 Jul
 2025 09:22:09 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%6]) with mapi id 15.20.8901.033; Mon, 14 Jul 2025
 09:22:09 +0000
Date: Mon, 14 Jul 2025 17:21:56 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: <linux-coco@lists.linux.dev>, <x86@kernel.org>, <kvm@vger.kernel.org>,
	<pbonzini@redhat.com>, <eddie.dong@intel.com>, <kirill.shutemov@intel.com>,
	<dave.hansen@intel.com>, <dan.j.williams@intel.com>, <kai.huang@intel.com>,
	<isaku.yamahata@intel.com>, <elena.reshetova@intel.com>,
	<rick.p.edgecombe@intel.com>, Farrah Chen <farrah.chen@intel.com>, "Thomas
 Gleixner" <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "Borislav
 Petkov" <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter
 Anvin" <hpa@zytor.com>, "Kirill A. Shutemov"
	<kirill.shutemov@linux.intel.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 03/20] x86/virt/seamldr: Introduce a wrapper for
 P-SEAMLDR SEAMCALLs
Message-ID: <aHTMNK574ZDIcgHJ@intel.com>
References: <20250523095322.88774-1-chao.gao@intel.com>
 <20250523095322.88774-4-chao.gao@intel.com>
 <aHEYtGgA3aIQ7A3y@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aHEYtGgA3aIQ7A3y@google.com>
X-ClientProxiedBy: SI2PR01CA0025.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::10) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|IA0PR11MB7259:EE_
X-MS-Office365-Filtering-Correlation-Id: e3aa0f0e-c8ae-4fd3-2122-08ddc2b7e871
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?tZYivFAgOSktbxKR8kp1n6+e2TCpBu9qwZ+U5OSYwr9kJr8AnhFnk2QXDvNF?=
 =?us-ascii?Q?9vv4i17uxt+jjSvclnaIJlpHlVg6eUmFZcWfi0fLllVbaTC3tlo62i/RaqXE?=
 =?us-ascii?Q?hmn+3J9YazZ5yE/PLMpfFaJH/5zbCg5oZgaDNhB0UPNtyeQGFNZt8jX7RMIR?=
 =?us-ascii?Q?PQfLSdRDqQ8p9yR5VtbpGTSNENBeXAKiRRH8I5LCwSC6ugt6djj4XsrG9Tfc?=
 =?us-ascii?Q?n/SBmSzQyGDRW7sQGJrTeReLzq/PH7TJ1TWtwW1mhboLuNVNBHJuJmzJVa78?=
 =?us-ascii?Q?zmALWPMsJ60Fzb7tqZXpNSiWaMXNYVB6QsQH8x7zTt91NEBclyVFN7TLI0VN?=
 =?us-ascii?Q?gXmi/JsQWu7g8ez7cLWpkIU3W7p0Xr8JEGQVrDr2p8PikJ58SkdjWLtg4A1R?=
 =?us-ascii?Q?pOrxM09/buIzs0TKUEpL+nFf08xRHjoRGBsldJeD4niozA27JFVpZ2KoWgWG?=
 =?us-ascii?Q?AHi5Xmj7RAyWaIn+/WDC7B8R8qumOz19CbgWjHq5GYxGxjQRRwOOD8h3yUk7?=
 =?us-ascii?Q?46pPtwB9VK/Sq/ih6jJZUCrLee8WjPChkVQvMyCCYja7UTnnf66NolVZawPO?=
 =?us-ascii?Q?in7c3biGOLp/k4Do26RRpG0eKtUfmZux7zRPFzjTBy+J9RvlfnhlLVi4Nnll?=
 =?us-ascii?Q?F5vOk/Ib4tt8uTERINEQuJWRoKb2cLXKVxj6uEeGDaSsDs2pvInpnNtviRPf?=
 =?us-ascii?Q?AJINQliT3IxAIDIMDvcu30KRLjAdBc7TA57u3vUgaWJ6HYjdg3JCk6pH39BP?=
 =?us-ascii?Q?w+h1unl32Po3fSi9hT3DJoa/57EtRP5xVNMwFlDiQIsYSeZ3i0g3lRHeUGay?=
 =?us-ascii?Q?JOHhORvgqw88VDCbJ2wzdU7E7VJq1/O3oVERYrCb7P8Mg5u74mLGC5wa25ig?=
 =?us-ascii?Q?eSo0yjUPD/OxR9OCi8sD0DW6twE+V9Nwe77d8oZ2vvtEix5On/I597uNzBDi?=
 =?us-ascii?Q?pApsxSYyUN/Kl/7k4K8GCplJ7g5/CSa0g1mGKgxSmrtE1NpbDRhMPTbw+Mlt?=
 =?us-ascii?Q?GtOmEFvV6+RruoUeS3uYZwRe2p1qFzaZRpPUj6AeKxyqLKUwTO3X+PFjjUd+?=
 =?us-ascii?Q?fKbQVhz09VNZjZJ9TG8H0+FVxPOSCV3xoNzcb0F8kfrPJD9ujFw050Do3hVV?=
 =?us-ascii?Q?Fokadun8gDHgFraloOLrJKRSwmcfS6T40lQDRIl0r3tyeK4o0WeUJJjdmOfe?=
 =?us-ascii?Q?A8YOQnGDKs3yBohsD8gh4NaYYRxkqg7NITIGeFKgpncz5uADaF6JspfXUXoR?=
 =?us-ascii?Q?k3SgBCsm8jiRivTBruXdriVQ6o0Lukazo1qdyqfPGTlVOo7xZ+5DpvwB0hcT?=
 =?us-ascii?Q?SHljwasRMeQAkrWEnxMt86gYPnodYR2ZZHZmIvODb6Rhbcu9PbhQ+ZZCXijS?=
 =?us-ascii?Q?EyB/71U+Vb9/Nu/scIHK9+l3ogr88SuM5TAO/sY9g05DReFfqKVJyHpdDVaN?=
 =?us-ascii?Q?R07isutBqYo=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FV1d0t8u5a2dugO+13Q1afqwSDKhrOGWKdz8LNSnbTwx0LYCafO9eTl69RCX?=
 =?us-ascii?Q?kPyY4Sdo1cbIkw2GZPfYyveyJS/YUzbWiEzSlfS0rTL1DOE6OqGNCgEoHLK1?=
 =?us-ascii?Q?G91JBVmQXFSw3/u3dJ7bvbBLyoh077v9pU83gtY6TF0XztcFvjWRPjqdb0ba?=
 =?us-ascii?Q?iObOECnSvMAGca9sciCKwsFxnryhSn78W0BZ9+FckMW5Uwo0H5zzEztSgcv0?=
 =?us-ascii?Q?11jrCFPE9WjSqRUGtaXyjzpKL4F1rNLSb0/xXvQTwDqB4UgjRPa4DaIoUisI?=
 =?us-ascii?Q?7IKh8AUZmsW96D2hsgbyHir5eEyvsqXKtjRDlo6L/rFklUvUeRsSRqBRyAPh?=
 =?us-ascii?Q?eko/JJEw3gap2w/oNLPAOGSHmSAOazw8UwJLDNra27jtSQxHIgDvswrwQadE?=
 =?us-ascii?Q?OvJ4q7BWfJXLSiHnmfoiHzfVjZ1LR/NxEZkwa5VW/N14TrcmeX4AqInW8q42?=
 =?us-ascii?Q?RSaZ9lyQDeQ9nol37ELR9VaI2sxDHXVpuff+EhJqOMaLOQsSSgAUZapQVHrm?=
 =?us-ascii?Q?ZbiFMYG1rNV+9gY8maa7sUYsLF3oFMavhLXDEZyzXZgpD5lTLLgqRJx0i90W?=
 =?us-ascii?Q?G+wUjw8dSTWImV02tcoZTYAwQfwPyqB/Ob+IpGzBerEPGXBzcF/1A87ymYQe?=
 =?us-ascii?Q?6YjrmNyXLuegFLVbjkSGwrwXiUiMdyf7vc+XZ3pIJhAyBy/aKWcy6S2z0fZ8?=
 =?us-ascii?Q?Rgj5wD13CHlBIOwLxEmTtMp0uDsYjFk8iccN+LDX9yIww5r4qGAILUgik/+t?=
 =?us-ascii?Q?l/d1RkQ0s6OgSxYir6G24vmWNgRwW8DVuE8h3XQTR2okl4XxNA7U/+PrI0f1?=
 =?us-ascii?Q?0alk8B4vFzlvNuA/U6U8bkdSPWiOPpyVHHfzsuRyEThK6wS2tgqEDpFX/Wta?=
 =?us-ascii?Q?caSxueir0U3GL3op8F9iQlrOoc5HJ8TIeVeyqgJ9q2wHSbuCRUb6514j7vG4?=
 =?us-ascii?Q?ZD/LKZO52Zaok2ZVRDcFIW03e/mO+F4ohlpfe5LHkLh6xxxTpXBOLg0OLR6+?=
 =?us-ascii?Q?oscoYf/JW6OYbGH4At8awv9gWV7ffwjG2p8f/PY2IG6sQC6GQ1EGLwmG1/Ai?=
 =?us-ascii?Q?XpiJ6uZenu9sjpOHXGCh/ckG1gDAvdwTU0xAFQSk9Bbr2XX2ue2Tr6Iobxe2?=
 =?us-ascii?Q?tG3Dx+Q37bllUtZ6IPvO73DROGopaNilAThKNtHIm9zZzz0vmjuUN9uIYTYQ?=
 =?us-ascii?Q?3QCNIGpyUMzV9KYMY+ojRrU5kn3lo+zOeicW9IR93FC1J8Ai7YAxK9Rj2aLa?=
 =?us-ascii?Q?OHTpgrdcsV98n/QgDnpvo+MrqGJfsjjNMfelQq8by4+FU35Rxso4pU0NckAZ?=
 =?us-ascii?Q?DF5CtRctF3mDYC/8+qQjG/1LpVPwLYAP31VUINVuFHBkOapp0DMpmudSQf0b?=
 =?us-ascii?Q?8RnzOMEZY3kJV80efNmA0hza1++O/oGMMSjTweo3YjN1Pxrk1xhLHJal0LGE?=
 =?us-ascii?Q?3iVTXYZLrgzxDuIy0whIAuzoQx/T+I5E7023xGf4dG0ZJGbEr9L1404y4elr?=
 =?us-ascii?Q?G7h0e0IdDY6k6Y4KRUjLH/W6gZ4UF5aahtwf2Rv6UxsvZOPJ4eBCTiaapUam?=
 =?us-ascii?Q?QAUij9NOJEsvKKudxEPC/5Co4uVQjDJElPNowNXR?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e3aa0f0e-c8ae-4fd3-2122-08ddc2b7e871
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2025 09:22:09.3119
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S1T20wK5DqKZhkE30z5YACHRH3MlnrTGWj3Pi5H/McHSjlVMMXkCMrTE41s8s1TtA/RjrcWZau2nujIbHLXpyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7259
X-OriginatorOrg: intel.com

>Regarding question #3 from the cover letter:
>
>  3. Two helpers, cpu_vmcs_load() and cpu_vmcs_store(), are added in patch 3
>     to save and restore the current VMCS. KVM has a variant of cpu_vmcs_load(),
>     i.e., vmcs_load(). Extracting KVM's version would cause a lot of code
>     churn, and I don't think that can be justified for reducing ~16 LoC
>     duplication. Please let me know if you disagree.
>
>I'm fine with the SEAMLDR code having its own code, because I agree it's not worth
>extracting KVM's macro maze just to get at VMPTRLD.  But I'm not fine with creating
>a new, inferior framework.  So if we elect to leave KVM alone for the time being,
>I would prefer to simply open code VMPTRST and VMPTRLD in seamldr.c, e.g.

Agreed. And the code below makes perfect sense to me, so I will incorporate it
into my next version.

Thanks for your prompt feedback.

>
>static inline int seamldr_call(u64 fn, struct tdx_module_args *args)
>{
>	u64 vmcs;
>	int ret;
>
>	if (!is_seamldr_call(fn))
>		return -EINVAL;
>
>	/*
>	 * SEAMRET from P-SEAMLDR invalidates the current VMCS.  Save/restore
>	 * the VMCS across P-SEAMLDR SEAMCALLs to avoid clobbering KVM state.
>	 * Disable interrupts as KVM is allowed to do VMREAD/VMWRITE in IRQ
>	 * context (but not NMI context).
>	 */
>	guard(irqsave)();
>
>	asm goto("1: vmptrst %0\n\t"
>		 _ASM_EXTABLE(1b, %l[error])
>		 : "=m" (&vmcs) : "cc" : error);
>
>	ret = seamldr_prerr(fn, args);
>
>	/*
>	 * Restore the current VMCS pointer.  VMPTSTR "returns" all ones if the
>	 * current VMCS is invalid.
>	 */
>	if (vmcs != -1ULL) {
>		asm goto("1: vmptrld %0\n\t"
>			 "jna %l[error]\n\t"
>			 _ASM_EXTABLE(1b, %l[error])
>			 : : "m" (&vmcs) : "cc" : error);
>	}
>
>	return ret;
>
>error:
>	WARN_ONCE(1, "Failed to save/restore the current VMCS");
>	return -EIO;
>}

