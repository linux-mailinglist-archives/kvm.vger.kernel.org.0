Return-Path: <kvm+bounces-65475-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A8431CABE27
	for <lists+kvm@lfdr.de>; Mon, 08 Dec 2025 03:52:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2EAD73024360
	for <lists+kvm@lfdr.de>; Mon,  8 Dec 2025 02:49:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4023A2C0262;
	Mon,  8 Dec 2025 02:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="REj6IU2I"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C876D2417D1;
	Mon,  8 Dec 2025 02:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765162182; cv=fail; b=CRKqTGuO9cLJ/g3FciVmNGJv5Xyf9CRWLadLYrC4oAxNQnp7myOv4mbb6FPJB4YQWvwKg88eiFHphRB5hQJlx7ClQaPXNOnEjdY/HiRO/oYXBvyir3w7TklfyepC0L168xq4NGEbrZYbdxPnIBeQq6OvARpwpC+oXN39ANfLmNY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765162182; c=relaxed/simple;
	bh=H1HBK8PTzsBmLTaC5edZkyN8hEKmqinIboKV24mE9LA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=uIhYsjpeW5Ip5Vy+Kp9b0Y7h9cN0pWsFVEh4+yaVbLMNcN5TQh6bJXb44fyos5JNALTjENza2w0RuZ06dpOLvxCR3NTZkGzSFaQejYTpHddwAxxO36PkCyDlVekdBI+JtzHuoBeMDLvK3skyaXPm7IhpDddFRbWDhik11VPZHvc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=REj6IU2I; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765162181; x=1796698181;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=H1HBK8PTzsBmLTaC5edZkyN8hEKmqinIboKV24mE9LA=;
  b=REj6IU2IWK9kRIOZOPP4bMtOKpWA/otHsSxlFWjZVMqA22KoqN2bgmJB
   PnomI/paFtFs55HvTsDlWWDUmZCxZRNcIPjkpy2V+lLCDCWYwT4xIUVn4
   Gr6TzdqfB1wuMYshDtDZdvS1c6KZk0RQF1ZLwxsIZsEjyoewTSnOl8Tcb
   ScCoejReEpn3BgSEpuQ5mAOt9MHCNfvZwjkWjFULYiP3u6pZg2SN9BRtO
   i3MUxl4KhS0+1sOG88xTGBj/6VwXJ6FVX7OoeGPaQ92ZVDJm5fiOg7igf
   3JvDkWTnYPUJKTWccKXdYReMDAp3ta7azdjYBXnoOfWRCdL+EhWGcNVBV
   Q==;
X-CSE-ConnectionGUID: +nVBnRTgQqiGtwHujQ5+Qg==
X-CSE-MsgGUID: IaBlXFabQYywPuvEkvBOGA==
X-IronPort-AV: E=McAfee;i="6800,10657,11635"; a="67267174"
X-IronPort-AV: E=Sophos;i="6.20,258,1758610800"; 
   d="scan'208";a="67267174"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2025 18:49:40 -0800
X-CSE-ConnectionGUID: rxBqHFp5Qeyn7Tm10JPIEg==
X-CSE-MsgGUID: 31wXxGc+R9+Rhm1obTsGyg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,258,1758610800"; 
   d="scan'208";a="200947573"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2025 18:49:40 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Sun, 7 Dec 2025 18:49:39 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Sun, 7 Dec 2025 18:49:39 -0800
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.28) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Sun, 7 Dec 2025 18:49:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lta7IK9hcLx7HuuaJWYFkjWfGNymvTF1ROQApceQ85TtAeR4VrrXUF3gOVXDe2nV0YFYJSUDIHJZJX71Jcz7tqTHgSNQnMVzBu3jNdr2rdAHBznCcubQIp56d9yzgHdEId8pjsbbvvYZAcoZtq4xFgBNFKXwTPqh3EziIN6Y8ToJclIt/O9mAv5oWfIQbTskg6EtaUpve0lvGl87F+JoEbL1Onb81L2LJ3h9+6BsRa2VxOAqvHR0+xvRTrgxwPrmgxQ8UzFPBuiizzhchwhKnUn8lD4zk1a55ZmSQaFVy8eS1ZNilyGVmEUTiB7ZT2LTN+NKsNhR1zQi/YvkO7CFrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k4pm7SK6v3Hr39O1J+Nt2p/xXLg+/GMLcnMMd7D+Jv4=;
 b=B/T7JiZ/EQobulRD/pVX7umvFw/lLzm6ZdaV2z3Ig61QtzxUupctyHsb/8yL2hkQQhZO0pTLn0iXKXx3ARr9NgVjbo2ebzrTu7VfnUdG/3QYp1GSvLlqts0Oo4Uz2DEYRnvEFenUIh1d55yQSK7PwX14EEtpBWABTidd4RwSXjY2g0NHiLlBJXFZIei5CWVmepFnXaSdd+pHsju5JcLsoOdpvVlHCRyRiHTtFQeyUbu9kmCMv6KPstnh0T+UvY6RY1Jh05ViFjcs8+FenCtlHDZQMCeBNIv+mznm/Ur/Zwr4ACxAxfpphYI1+oCCy/REZ0f/Og0RBuH96SkC2ojp/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by DS7PR11MB6077.namprd11.prod.outlook.com (2603:10b6:8:87::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.14; Mon, 8 Dec
 2025 02:49:36 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::fdc2:40ba:101d:40bf%6]) with mapi id 15.20.9388.013; Mon, 8 Dec 2025
 02:49:36 +0000
Date: Mon, 8 Dec 2025 10:49:26 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, Kiryl Shutsemau <kas@kernel.org>, Paolo Bonzini
	<pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>, Dan Williams
	<dan.j.williams@intel.com>
Subject: Re: [PATCH v2 0/7] KVM: x86/tdx: Have TDX handle VMXON during bringup
Message-ID: <aTY8tkI8gEqtDtHU@intel.com>
References: <20251206011054.494190-1-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251206011054.494190-1-seanjc@google.com>
X-ClientProxiedBy: TPYP295CA0004.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:7d0:9::13) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|DS7PR11MB6077:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ffeb33d-5f1a-46cf-9a7e-08de36046caa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?wFQyB8kKnau7C7KyWzOfyVKVS69Z2pjeAyRx7OfLUNehQlMcodxxV6v02CUV?=
 =?us-ascii?Q?wy/lRmRtAvRoUl0vB5GoYn5IdbMug4hUBRlPGTtNg2nODucJoH+Hxgg2jQz1?=
 =?us-ascii?Q?KFqCIcp2vq4PEvxNJr3gHN8kwtuwTsOe+GIi17TvufLJ31LKxb4wb40VMc0s?=
 =?us-ascii?Q?FN8/msghUSWSH6HkwsAqB2Q5dh0zdhIf5E0SKJN2ZBWqszHhSORna3syo9Mc?=
 =?us-ascii?Q?6K7W8UCNwmH0N78SkCgeAPDgmtQJaY2HjfIiPFOsXItCrS9RZKk+rifLUk3Q?=
 =?us-ascii?Q?VdYXD3YLbR1RQ4GNylKveJCzFJHqWjE3OsHw1RJ8sMPg9yJv8KG6RGpHJJa4?=
 =?us-ascii?Q?4q61/Gu91kLJ3Cb3/YXMAeikmpck8md6U3scMDT+i7L31aQHRz0p2KDZt36A?=
 =?us-ascii?Q?OXNTHcaiU7mT2/QH3rkwOaDvK+HenX0NYPEJIkdbuN8XrkCxnR5YsMzNdt3k?=
 =?us-ascii?Q?6yRfS5d9ijIa1OcEvpHUqBodupskTF0rjDA2IW9C+7jdaigT1MG9m5YPZdYU?=
 =?us-ascii?Q?I9L5iCRC+n+mYL6QFiXqauuVz9swV1GjfohP86rnUleCLDvUNMlHOjFdg9A0?=
 =?us-ascii?Q?/s1CwShTNHLmSw00PhUYnOUbGtp9jMxxEnFiRAIr6j7/dnfNzDWaPZ7B5ULY?=
 =?us-ascii?Q?Ilb0dlDtb8bX3AzYCuhnAur87++6LIS2jJKsr6zX9uvEo9sXMwjGNxJttAki?=
 =?us-ascii?Q?A5AFBLSw0ohU0Z0Qcc+EM9kGDUATXNiGRpQg29wmZip9E3ZsUoUHX9+i63fK?=
 =?us-ascii?Q?62FR+n4Bgxi0vcOgnerYWVnVpXYu9Wqufxwqlq/UCmZ8VI+VZlFZJkgsgBAc?=
 =?us-ascii?Q?ACZ1eMAKV4dXNUcY3mKjk/sYXVipof9f8/sHVnWlHEVQLDlD1nlFI6Nxgg4C?=
 =?us-ascii?Q?p0ABI+O33gMiXppLVnrvKxw9nOX3HaKTj6+HK/iSONZyJXtMQC/o2L6Jephy?=
 =?us-ascii?Q?+BE1RU+3Jt0xPCQiifku60BQ5M42nPcoXhIxFr0vynEzLx0q4+LN5Xt2QfGi?=
 =?us-ascii?Q?t1I2X7E89yZJBdWAvQTRbL0JyV7IVtcxTVcDH+CvSD4xs44nx8q/0sCj7BYU?=
 =?us-ascii?Q?oXWi/WzJfEgdCA5bxWZcA0HeOlJFIpvCqAsax4gxRVjzEus0UkGnFlGMRl54?=
 =?us-ascii?Q?B3ujZNygWqCPNIhHEsIwZ5KdKPWj63yEOhkKNu6vZ9hnhBGRyFPTJq7f5g60?=
 =?us-ascii?Q?Et0PHPzI4BjKot1ekR04SDRa1Wxxp0WVdFodPD+eoHsVqNkNJA09kztCphNb?=
 =?us-ascii?Q?LFG+3OTtTsqjb5D+9ibrGrn+mxcJ1a+vU1AfLLFQ3S7z0VB7e6rKJB2ejkf6?=
 =?us-ascii?Q?X4ptwHAKYEwb6SK+33t/oOyNOCrq784/iCLWt8mzQOO+SVuhWOS5Wni7eoFK?=
 =?us-ascii?Q?zj7PlDi4BHO1FAHHERWrGlVabLEelhG6u9pyHYLIG8OL89T2Ivwx9sKYIBr2?=
 =?us-ascii?Q?lrVVjeiVUYYBVJCxudW9AkqBlRWrYJXw?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aQXMZIc63vZjKjRVbqq5ZObqEsblLdNS7l9IQ9c0BSqsUNFDKiQt3W9x3NFt?=
 =?us-ascii?Q?liZ29RDT3VEH0SWGNvJzK7HutnR5u0U4bh8CvgfMkgD6jfpQ9o3iNwm09H8n?=
 =?us-ascii?Q?abRCSLEQv9h24Vs3tbnwMPOK1Aq4YLc1Uj3zS4sleOq8BdEygWEFUie67G0z?=
 =?us-ascii?Q?35GFDGAmc6z29QxSQdhOoYPNa5esVFc2wvoRn2D6crepCVU58DKyEK6VPpeT?=
 =?us-ascii?Q?HHKR5KdLEtpIahF3wbCzYwaW0qSgf8dpHVVRmZ2L1340SS60nM6nMx/QQOhY?=
 =?us-ascii?Q?zdmHeSLToABpXXYJEmsV3V4kbK6936IDlUf4Ef6q3NGM/TbY0UHja/t0TvoU?=
 =?us-ascii?Q?7p5M9tkv0n/kjjXsG4uKzfAqo1sWcRj/9/4HNL9141K2CYrDeulgq49yVikV?=
 =?us-ascii?Q?bkMHwFzl6QNMhq3tClljxY1V5huET9wTGupMqdbzuXXFyazMcSPI933G+KOj?=
 =?us-ascii?Q?v8RXNj7r6PNn+H0gsvELEsMLGv++H49h1M+f3/2NJBI+ygI+bsClCtIUppVM?=
 =?us-ascii?Q?Dq1bRNIBXGOEphy20bzUbm6KfHnutWvsZKqgNYpoCxtiIOt7V9kztM6Mi5+Y?=
 =?us-ascii?Q?ycv83jI5nWUhPpI0SWZJIDebOY+k1N2/cKU8SGoP7o2a8ETEcQ9gXjF5mVHZ?=
 =?us-ascii?Q?WyomfiwJZwqDKF4dZhsvWlKaui4AGELxOaqTlLCeNq1zIvSbb0FoVfAQ0Lgd?=
 =?us-ascii?Q?vbnWYdr9dz5EELei7PrtV+DVI2LYWOUyC5WdQR9x3M7261daO66LpYh8olyc?=
 =?us-ascii?Q?9c85GN6TB1WHJYaZGM0/pCQV7ianbY+kL9h5qlbrwdHcOKOdW4hgxRH9rHvN?=
 =?us-ascii?Q?eg5lb7GcEbTjZ4IIvi+GNmM4btpb2+o1IgJrWy2cIZpRqAdm2jdoZPpuveP0?=
 =?us-ascii?Q?EgrWCsvq6J4i+q/buFjv8MmI0nv49cQuGifLHblpa9rXfkWCdgYY25fkxdgq?=
 =?us-ascii?Q?x6PIz5215z8ggWSkaUc6CkkjZ1s2vNQmDx3P+zi3IE5/PU/peLhBvUoqiBDh?=
 =?us-ascii?Q?iHX60E40AYXgXkgeS8JGcFSHpxK38NeZaOj05f4X/pxvShPGQkvcy7CfGEvI?=
 =?us-ascii?Q?TGePQIPJEygKCKF9n3pna2nv04oXTIhuoGSZsx8Rq7JEq+OZ21XN+E5wzvOy?=
 =?us-ascii?Q?eQIpMZSxqp6kghujSCU5J+TOeSlN5ivyFhs4R1SMokxecUHJwNSFd5GB0oOK?=
 =?us-ascii?Q?HGofLItnOtpzdsQ/08sBGcvCbSIAfzNgDMaZn69ak2p85mPYeezIG+8VBwor?=
 =?us-ascii?Q?3S+T7T5l8K5FHRi4pRIw1jjqk+r1KPemZW1JCPuGbF1e78ulgsEVUk5iXBcU?=
 =?us-ascii?Q?mbbjQ9ZVzUulhTXHn8ps1YXyK6/7HMnSc2XfFL+MGMfoZB+9WAohrOrm52Qt?=
 =?us-ascii?Q?KhaQxj98TOhbvx0gkV5bhtO7EcGP2fCgMLqHIqI+T95boQRPne0InWz0LORr?=
 =?us-ascii?Q?R2GzGf5jBE740byRpeBcN7ZbfZM7sjqHy2zoR0WMhpkWTRKUH7WFyzJBu3ZJ?=
 =?us-ascii?Q?ikNi9uXgsxobCmpeTLy4zkdmtwv+uYqs8PXQ73ZQvmok9KD5P6j/1LjfMzuV?=
 =?us-ascii?Q?OwPWE6/Qr7lA/EG9G0NHjrcIosrvrstHLIn8qExx?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ffeb33d-5f1a-46cf-9a7e-08de36046caa
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2025 02:49:36.5915
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jd43G1M57udsU6Wr4NU26Mbih82O/SrEH24Z0xeVF0blmAd58fzew19ebl/1wYfXDqrABWzDZXFUhbu4+9D7TA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6077
X-OriginatorOrg: intel.com

On Fri, Dec 05, 2025 at 05:10:47PM -0800, Sean Christopherson wrote:
>The idea here is to extract _only_ VMXON+VMXOFF and EFER.SVME toggling.  AFAIK
>there's no second user of SVM, i.e. no equivalent to TDX, but I wanted to keep
>things as symmetrical as possible.
>
>TDX isn't a hypervisor, and isn't trying to be a hypervisor. Specifically, TDX
>should _never_ have it's own VMCSes (that are visible to the host; the
>TDX-Module has it's own VMCSes to do SEAMCALL/SEAMRET), and so there is simply
>no reason to move that functionality out of KVM.
>
>With that out of the way, dealing with VMXON/VMXOFF and EFER.SVME is a fairly
>simple refcounting game.
>
>Decently tested, and it seems like the core idea is sound, so I dropped the
>RFC.  But the side of things definitely needs testing.

I ran tests on an EMR system, including performing CPU hot-{un}plug,
unloading/reloading kvm-intel.ko and launching TDs. No issue found.
So,

Tested-by: Chao Gao <chao.gao@intel.com>

