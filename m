Return-Path: <kvm+bounces-39720-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 15525A497F8
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 11:57:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0FD8E17401B
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 10:57:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C12B260361;
	Fri, 28 Feb 2025 10:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZJoPFyfg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76BF625D1F8;
	Fri, 28 Feb 2025 10:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740740215; cv=fail; b=AsavHI4uLu/Bb5a72uYh3eLTzxGxgpRSbeoDUW9zXaq22lMLYsm3twb36vbx7jYJZQwrutRjUGbbgjZIUp5waXXE+taq+jhQjaBlaBdKTfDvK2xSQInh3ev75CFaTXSaFShFpwTL1Zy/14ZtCnKivl4B0wYlACAeMzxIXalmaYs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740740215; c=relaxed/simple;
	bh=2lhCc6ZLriTfCI9UyBJ3IQzgCcys7vIoCkeJ1lG/HPY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=BqTmqxVexOPrZHRhUh3nLm+y/TWrxfGpTHRObgblGPvPEXSgaPCPNQFbPbpUJgGY7QSQKsYy0XIV8KetP76kOups1eoMKvnFLdzIZUE31Au7uKDU0vPUU9GVBAaTj1NqvAJEluPq30umXUOhhi7ie94O3beMA63ySLqANeny6G0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZJoPFyfg; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740740214; x=1772276214;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=2lhCc6ZLriTfCI9UyBJ3IQzgCcys7vIoCkeJ1lG/HPY=;
  b=ZJoPFyfgeFwYkKXiKmpBryu8DYcVssW6+cBjXg/9zXchi0PlVaLYpp6f
   av+8v7txVn+4lu5nqglBM1aj6BIH3V8YiDSvLqKC5kR71uYKMgamAzCSk
   Nj/P9VBSv/z+X2+BV46xjF0KMqXGli/RNl19cVbpanaKLcrAKGHclUxvm
   u8ufr3Mr0lFOCS8XRRUisG5H++Pn0nMCizTJBdaUUg5+rhR+Qc0wdDMU+
   d0jkJyyE+skxkTShR0/tMBQzwlPlYS/+sJpTavGJEAnj2z4E/myufbLN2
   Qn0hpi0mXsjUv3SewplXFMJ5pJsh6di6EIgK6uA/EwT+v3K8Dv4Rr3IJE
   A==;
X-CSE-ConnectionGUID: 9tljWsgSTSG1NvS98N4YGw==
X-CSE-MsgGUID: SQmR4LnuQ/u28WwkSH9AyQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11358"; a="41692987"
X-IronPort-AV: E=Sophos;i="6.13,322,1732608000"; 
   d="scan'208";a="41692987"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2025 02:56:53 -0800
X-CSE-ConnectionGUID: TA0MIBQJTdelaWXCiub9bA==
X-CSE-MsgGUID: wXaYMN8DTS+VibL888CcTw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="121422799"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2025 02:56:53 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Fri, 28 Feb 2025 02:56:51 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Fri, 28 Feb 2025 02:56:51 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 28 Feb 2025 02:56:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=okE83Xl5OQBuJBHd0sIhzmBGZTIqXa4R/iayY8IsJIW1kebuxoAAzCiNNFcMepNxu66pwIVrZMoTBXFnBYJPA9MzrRCtm68x0DWl6jT7wp9bA1sve04L6DVjopbvRfjbdZ+uGe5ZZTNaJMNhRMGq6IzT1O3wBr+kT3FMYgXp0D4ZPe/3SOsT9ajyFgwCMetUdZruz9E5BQV0cpRQDdw4uAPN1T9ImLHfm2tzwSAqgCzakuZ5thZRR2f9OMNUfsKc0heG4LgCZIQQeCFSooDkJtUuknF/QH6oxfnm6vqKqAb2LHknXuocDy13SdvNbrJ7uzxd6BVrDDx4Ee8dbVgG1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nJnrNDkK9KFnR3Eeg4uhWOyjl7/QXvnKE3xCIArm8r8=;
 b=GucWTpHDWhEwPQdEupf/2OxiDcFMhPHncrcqhDw9DMicvNNe72J1BumclrrO+S6ggR9ZxS3AMXxhiuMLFfkrYzdnAZpxncAIR1LnQkKy9OTQvXZfi7GuLpB1ocuxDuIozJIIWN8QxkxBIHQQiCcURqUKYAKvNErWX/6R0OOmSD0ioI8aGKcO/1W7+PrEEI5i3gKmgCUm5AFfEdvnMWiqZyjrMs+fRTienrh4S9S+YhgpsKhZOIHjK5fO+hp5LdTSQqeNSnB7lo7O+1P1/Fh29I1aTmCuSvQDR3JPCTSLXNIngUPkMKJKZahuUN/z6RZRnU2erNDWW9cqCXsV3m0fLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS7PR11MB6014.namprd11.prod.outlook.com (2603:10b6:8:73::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8445.19; Fri, 28 Feb 2025 10:56:44 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%4]) with mapi id 15.20.8489.021; Fri, 28 Feb 2025
 10:56:43 +0000
Date: Fri, 28 Feb 2025 18:55:26 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: <pbonzini@redhat.com>, <rick.p.edgecombe@intel.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: selftests: Wait mprotect_ro_done before write to RO
 in mmu_stress_test
Message-ID: <Z8GWHkpSt+zPf+SQ@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250208105318.16861-1-yan.y.zhao@intel.com>
 <Z75y90KM_fE6H1cJ@google.com>
 <Z76FxYfZlhDG/J3s@yzhao56-desk.sh.intel.com>
 <Z79rx0H1aByewj5X@google.com>
 <Z7/8EOKH5Z1iShQB@yzhao56-desk.sh.intel.com>
 <Z8Dkmu_57EmWUdk5@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Z8Dkmu_57EmWUdk5@google.com>
X-ClientProxiedBy: SI2PR01CA0046.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::18) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS7PR11MB6014:EE_
X-MS-Office365-Filtering-Correlation-Id: df3d98f9-550a-48dc-1fc7-08dd57e696a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?L3qfgjiKSGlfl8XYdpMHMbuQ8SnSiaA1t52GY8mXlrIjcGTXhi8pyhmyli38?=
 =?us-ascii?Q?Sj1+Oi/IwdUKOp/TG+UszhG1x3J96tSKqgulBLZSPM5alKFoIV+kqhNFZ+DR?=
 =?us-ascii?Q?U7jXHK5dBT/s4GiGeBcGS+YsNv62+9Eqg7y3mJbjR3jUfUKtvSKE1bQ069Ei?=
 =?us-ascii?Q?CpnYI9NEw3/fXyywjATUlkFlFUJiUkrBfh93JBkhr4E7Ko1AMvINv7xIkDnX?=
 =?us-ascii?Q?8/EAR2xKs/Zv37ZCQui/2B88ThcPSv1oI+pLxEszLT4YWluJo6/+IBO6SH2a?=
 =?us-ascii?Q?KJmV9vYrv3aKB6tW1kNuSATHfggtgT9qe90pLUVl4QYNVl6uLuVmLZFj9uzg?=
 =?us-ascii?Q?yHGawwV62pGbdhtO8XfLI1e64ve0JzYI5X8mcUSWmqE1pCb6t0/sdzHreqcy?=
 =?us-ascii?Q?mi/BIfPD+vPCz0pELvAa5frx6jP9y/UrJzRHCMYe2x1IQsfBKIAFlq826sWe?=
 =?us-ascii?Q?+Q34RjMdUSkV3N7t+C+FgSNRrN8+2ijlkjJQwMytqEa8p/6OQDV5aMWkfBmc?=
 =?us-ascii?Q?ImhIkubnhFX1SqxliuIosIgJWkzdyUVgXMdEzKvjTLcc9IY+zhtxt/7K3015?=
 =?us-ascii?Q?KteEM+9tV/5fJWE0MU+rgaLbTrBQOLyKIhhziWqUy26tmW2Rz3s6CT3Gv5nG?=
 =?us-ascii?Q?7qE8gJQwZ+jjutJKoErL9FK/KkPlWkCDgN04wgxJBpRYVMmyqmM/f1Wsa1Oo?=
 =?us-ascii?Q?E+3/kOXyUbQm5wTD2MZTpKxr0neutiEXTHAW+iVjrTN+3jt30g28+5a1G0xR?=
 =?us-ascii?Q?R01ZFsQ/ECKLY+1EUv8g5XXamXHISeJxaoi2TbkWlGm6tcnBmPVFuTHtXFcU?=
 =?us-ascii?Q?s9UI5mouUTQRv9bxbGPz3aIidiM6EnNdtmqjqaOWVphkR2uHPwZFnbcBDXD9?=
 =?us-ascii?Q?Xej3VVQiNHq217NSeHrdBTtcgAHIhRBvE/DtIdJ7fLtU5YwT6tY7LTbkRYhC?=
 =?us-ascii?Q?fnG+pUPb4Oq8mx2Fkr0cWFeDUlhy5OYuwUw0L2B6f2jXOxvDHTZPuoNpTJZA?=
 =?us-ascii?Q?ZIApX/avjjPW00M3pCrol2X7Lb1rjuup5S6yFlxTFPHYTZ67QLaSfpcQ8DTv?=
 =?us-ascii?Q?oykfdhY36QpNlua+AAMqxErALlYWjgdwSgSoXVCxJqSPYoCUBmW8n7kBbqxT?=
 =?us-ascii?Q?thw3w5laEZ1kcD4CyKxgtvHAHZhDHq5lG6StAsIrJD6/2WuueUk90gqru2HX?=
 =?us-ascii?Q?uOhmvtlu9MjdOlC+sJUHkrI8/0tiv1DA/HwXwXlLum96GKM+0q2Few6D3CL2?=
 =?us-ascii?Q?IqWkwq7xOUkqGsk3fo3qwRel86xsS8y++UXAhycYEpx9FUWdQjrL0Fmyadqz?=
 =?us-ascii?Q?OkePfongiGC4UxO/D003poY9?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3pSMch9CqQzsPLHfiJ3fIKF9YoeNePgXbREeblA9QXMA22f7aUdhhO3mt2tc?=
 =?us-ascii?Q?grhzey5uKDQ6jcEEdmhXiZPuvsJE+jhSbPdy1knyJVAQF0P+b6AMnWGo5ZjF?=
 =?us-ascii?Q?HnN9RDFvVOE0ptZbmVShMMxet32hqQaJ5zpguQa/gBT56MdZru0u/lBZTR2k?=
 =?us-ascii?Q?3JB+l+b67aqTENiTfP37dscmA6WA5GkWetXca/CzaTWVf8++YfWy3G4WOe9y?=
 =?us-ascii?Q?wtaj4xlZghztRyIccMaGHTcFYFXQ+ROzyzED7l95nV5mzlyWGeMYD7zyRi4z?=
 =?us-ascii?Q?0NqDrEb6oGmc+ONk/kIRPyMUT6iRdxEhcP0joiMauWbeRCr+kQekMTeV2wyu?=
 =?us-ascii?Q?r1quTVBDGijf/YavV0URtC6jU6yCxyiEaI6HQOu+tJk0FhuoRzfJ4J7m5w4j?=
 =?us-ascii?Q?9d1TXPrMjlzdgNNkHFeJ9v1D7SMyJ8tMshaGlQKrp0nYtHNBY4bHxE/8rKsb?=
 =?us-ascii?Q?ioFYt8wZee4VnkuSFNE1LLdkq6T9a3VzZBkP6o7QiNJdsZkU0KtEdYa42qT8?=
 =?us-ascii?Q?DDsMhihYfvYrpA87odBJDbyYOqpPKvdIZiKxEOLQtBTNIcTycScOjIqGuN4t?=
 =?us-ascii?Q?mPGzeyF3JrpeZLHxEKWnryHWcNUi/0TGQsAF9ChdALAQ0M3PywgTXEGXypwn?=
 =?us-ascii?Q?KNpLeR7FeqyjsoscdAhoMuJQ3IGdimwVH8fj6EJkU/vvX4yGkjkFcLXu32qY?=
 =?us-ascii?Q?W5Zd28xXI+hW0mXdhvdQ7x/6EAos41gf9gO0cCPsYKdTfCnH8wxeSLVmUKog?=
 =?us-ascii?Q?78+B6fikUWO4jauTNnC1+ydFrTgQhjhvBmtY+nOqDkARNPj+GAVGRT9puB+K?=
 =?us-ascii?Q?UfoiLQwNdE4kGZMmbXws3PEUVlR7PTTs7rcaUr7frMiw1a08HX3kFP/Wbq2X?=
 =?us-ascii?Q?hI9qkTyzN9eQq6WKww6sdfOYqMAlQy8oLegJz2iAYMud5w/TGyACdsn7zbCH?=
 =?us-ascii?Q?gJWW79CDOZ7SURrsPHJqCDbyUTN5SKlTTo7+fqgPB6D70W+eMpQF5C2fiw3x?=
 =?us-ascii?Q?XY3vVw8hzJ4AMG4L+xKlPiR7jjSq0PSpsZF4PaYkAP2tw1ilNcHuF1ByZ7Me?=
 =?us-ascii?Q?O2FEdTZ403mdJck5V/ZIbpwn/ZG89EGF6PwbGegp0McnVoFAejCPDbHZ5lgx?=
 =?us-ascii?Q?cTfklQ+gnwuiaZCTAGsa4ooU4kEoxewCbj0L4PAJ7Ly/PecO3loG/z8B7FyV?=
 =?us-ascii?Q?DgJ+k072qV5m3559oTPmvwvnlLs3C3wIanYvn1e5Edj220uQ5LKpoJcJ93SC?=
 =?us-ascii?Q?M9nz8D9QHaMWNtVaDow5nqRa2vh/CEUJl5+67EplwvxOMUUkWmkE3DALvh48?=
 =?us-ascii?Q?d4q4nyWb9sOd5bQkEVdAT/ieFIRiyAcHdiS3iGSFxW98xu1mDy7yG+dv5XhE?=
 =?us-ascii?Q?0B68v8cu8aJhxrPn4eGf7wlFKWFvTNHm5MmhCtJVu4T3bWmHgdhPKha6ERjV?=
 =?us-ascii?Q?4b0D0RMwRKicb3zvd7huhvWCah3j71DCfjJIFqLuUa/O0xZddJmba1FpVHZb?=
 =?us-ascii?Q?WwNXcEVVqXYaMHyaemnKRzNQ1fNYhU2Ib7yU3bNyii5xRAKnAls7PUKXV5do?=
 =?us-ascii?Q?633KqkqXls5aVhxVnEOLj4ttPHeCLnUQis+W7UUj?=
X-MS-Exchange-CrossTenant-Network-Message-Id: df3d98f9-550a-48dc-1fc7-08dd57e696a6
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2025 10:56:43.9454
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sY4prvoFgjB63gI0ECaUhWvORf2iaFPKNPPP71LO60mR7WlHhkDsMtgdIYdBuMlwdmanMHALZb6Bqe5uIjQrLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6014
X-OriginatorOrg: intel.com

On Thu, Feb 27, 2025 at 02:18:02PM -0800, Sean Christopherson wrote:
> On Thu, Feb 27, 2025, Yan Zhao wrote:
> > On Wed, Feb 26, 2025 at 11:30:15AM -0800, Sean Christopherson wrote:
> > > On Wed, Feb 26, 2025, Yan Zhao wrote:
> > > > On Tue, Feb 25, 2025 at 05:48:39PM -0800, Sean Christopherson wrote:
> > > > > On Sat, Feb 08, 2025, Yan Zhao wrote:
> > > > > > The test then fails and reports "Unhandled exception '0xe' at guest RIP
> > > > > > '0x402638'", since the next valid guest rip address is 0x402639, i.e. the
> > > > > > "(mem) = val" in vcpu_arch_put_guest() is compiled into a mov instruction
> > > > > > of length 4.
> > > > > 
> > > > > This shouldn't happen.  On x86, stage 3 is a hand-coded "mov %rax, (%rax)", not
> > > > > vcpu_arch_put_guest().  Either something else is going on, or __x86_64__ isn't
> > > > > defined?
> > > > stage 3 is hand-coded "mov %rax, (%rax)", but stage 4 is with
> > > > vcpu_arch_put_guest().
> > > > 
> > > > The original code expects that "mov %rax, (%rax)" in stage 3 can produce
> > > > -EFAULT, so that in the host thread can jump out of stage 3's 1st vcpu_run()
> > > > loop.
> > > 
> > > Ugh, I forgot that there are two loops in stage-3.  I tried to prevent this race,
> > > but violated my own rule of not using arbitrary delays to avoid races.
> > > 
> > > Completely untested, but I think this should address the problem (I'll test
> > > later today; you already did the hard work of debugging).  The only thing I'm
> > > not positive is correct is making the first _vcpu_run() a one-off instead of a
> > > loop.
> > Right, making the first _vcpu_run() a one-off could produce below error:
> > "Expected EFAULT on write to RO memory, got r = 0, errno = 4".
> 
> /facepalm
> 
> There are multiple vCPU, using a single flag isn't sufficient.  I also remembered
> (well, re-discovered) why I added the weird looping on "!":
> 
> 	do {                                                                    
> 		r = _vcpu_run(vcpu);                                            
> 	} while (!r);
> 
> On x86, with forced emulation, the vcpu_arch_put_guest() path hits an MMIO exit
> due to a longstanding (like, forever longstanding) bug in KVM's emulator.  Given
> that the vcpu_arch_put_guest() path is only reachable by disabling the x86 specific
> code (which I did for testing those paths), and that the bug only manifests on x86,
> I think it makes sense to drop that code as it's super confusing, gets in the way,
> and is unreachable unless the user is going way out of their way to hit it.
Thanks for this background.


> I still haven't reproduced the failure without "help", but I was able to force
> failure by doing a single write and dropping the mprotect_ro_done check:
> 
> diff --git a/tools/testing/selftests/kvm/mmu_stress_test.c b/tools/testing/selftests/kvm/mmu_stress_test.c
> index a1f3f6d83134..3524dcc0dfcf 100644
> --- a/tools/testing/selftests/kvm/mmu_stress_test.c
> +++ b/tools/testing/selftests/kvm/mmu_stress_test.c
> @@ -50,15 +50,15 @@ static void guest_code(uint64_t start_gpa, uint64_t end_gpa, uint64_t stride)
>          */
>         GUEST_ASSERT(!READ_ONCE(all_vcpus_hit_ro_fault));
>         do {
> -               for (gpa = start_gpa; gpa < end_gpa; gpa += stride)
> +               // for (gpa = start_gpa; gpa < end_gpa; gpa += stride)
>  #ifdef __x86_64__
> -                       asm volatile(".byte 0x48,0x89,0x00" :: "a"(gpa) : "memory"); /* mov %rax, (%rax) */
> +                       asm volatile(".byte 0x48,0x89,0x00" :: "a"(end_gpa - stride) : "memory"); /* mov %rax, (%rax) */
>  #elif defined(__aarch64__)
>                         asm volatile("str %0, [%0]" :: "r" (gpa) : "memory");
>  #else
>                         vcpu_arch_put_guest(*((volatile uint64_t *)gpa), gpa);
>  #endif
> -       } while (!READ_ONCE(mprotect_ro_done) && !READ_ONCE(all_vcpus_hit_ro_fault));
> +       } while (!READ_ONCE(all_vcpus_hit_ro_fault));
>  
>         /*
>          * Only architectures that write the entire range can explicitly sync,
> 
> The below makes everything happy, can you verify the fix on your end?

This fix can make the issue disappear on my end. However, the issue is also not
reproducible even merely with the following change...

diff --git a/tools/testing/selftests/kvm/mmu_stress_test.c b/tools/testing/selftests/kvm/mmu_stress_test.c
index d9c76b4c0d88..e664713d2a2c 100644
--- a/tools/testing/selftests/kvm/mmu_stress_test.c
+++ b/tools/testing/selftests/kvm/mmu_stress_test.c
@@ -18,6 +18,7 @@
 #include "ucall_common.h"

 static bool mprotect_ro_done;
+static bool all_vcpus_hit_ro_fault;

 static void guest_code(uint64_t start_gpa, uint64_t end_gpa, uint64_t stride)
 {
@@ -34,6 +35,7 @@ static void guest_code(uint64_t start_gpa, uint64_t end_gpa, uint64_t stride)
                *((volatile uint64_t *)gpa);
        GUEST_SYNC(2);

+       GUEST_ASSERT(!READ_ONCE(all_vcpus_hit_ro_fault));
        /*
         * Write to the region while mprotect(PROT_READ) is underway.  Keep
         * looping until the memory is guaranteed to be read-only, otherwise


I think it's due to the extra delay (the assert) in guest, as I previously also
mentioned at
https://lore.kernel.org/kvm/Z6xGwnFR9cFg%2FTOL@yzhao56-desk.sh.intel.com .

If I apply you fix with the guest delay dropped, the issue re-appears.

diff --git a/tools/testing/selftests/kvm/mmu_stress_test.c b/tools/testing/selftests/kvm/mmu_stress_test.c
index a1f3f6d83134..f87fd40dbed3 100644
--- a/tools/testing/selftests/kvm/mmu_stress_test.c
+++ b/tools/testing/selftests/kvm/mmu_stress_test.c
@@ -48,7 +48,6 @@ static void guest_code(uint64_t start_gpa, uint64_t end_gpa, uint64_t stride)
         * is low in this case).  For x86, hand-code the exact opcode so that
         * there is no room for variability in the generated instruction.
         */
-       GUEST_ASSERT(!READ_ONCE(all_vcpus_hit_ro_fault));
        do {
                for (gpa = start_gpa; gpa < end_gpa; gpa += stride)

> ---
>  tools/testing/selftests/kvm/mmu_stress_test.c | 22 ++++++++++++-------
>  1 file changed, 14 insertions(+), 8 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/mmu_stress_test.c b/tools/testing/selftests/kvm/mmu_stress_test.c
> index d9c76b4c0d88..a1f3f6d83134 100644
> --- a/tools/testing/selftests/kvm/mmu_stress_test.c
> +++ b/tools/testing/selftests/kvm/mmu_stress_test.c
> @@ -18,6 +18,7 @@
>  #include "ucall_common.h"
>  
>  static bool mprotect_ro_done;
> +static bool all_vcpus_hit_ro_fault;
>  
>  static void guest_code(uint64_t start_gpa, uint64_t end_gpa, uint64_t stride)
>  {
> @@ -36,9 +37,9 @@ static void guest_code(uint64_t start_gpa, uint64_t end_gpa, uint64_t stride)
>  
>  	/*
>  	 * Write to the region while mprotect(PROT_READ) is underway.  Keep
> -	 * looping until the memory is guaranteed to be read-only, otherwise
> -	 * vCPUs may complete their writes and advance to the next stage
> -	 * prematurely.
> +	 * looping until the memory is guaranteed to be read-only and a fault
> +	 * has occured, otherwise vCPUs may complete their writes and advance
> +	 * to the next stage prematurely.
>  	 *
>  	 * For architectures that support skipping the faulting instruction,
>  	 * generate the store via inline assembly to ensure the exact length
> @@ -47,6 +48,7 @@ static void guest_code(uint64_t start_gpa, uint64_t end_gpa, uint64_t stride)
>  	 * is low in this case).  For x86, hand-code the exact opcode so that
>  	 * there is no room for variability in the generated instruction.
>  	 */
> +	GUEST_ASSERT(!READ_ONCE(all_vcpus_hit_ro_fault));
>  	do {
>  		for (gpa = start_gpa; gpa < end_gpa; gpa += stride)
>  #ifdef __x86_64__
> @@ -56,7 +58,7 @@ static void guest_code(uint64_t start_gpa, uint64_t end_gpa, uint64_t stride)
>  #else
>  			vcpu_arch_put_guest(*((volatile uint64_t *)gpa), gpa);
>  #endif
> -	} while (!READ_ONCE(mprotect_ro_done));
> +	} while (!READ_ONCE(mprotect_ro_done) && !READ_ONCE(all_vcpus_hit_ro_fault));
This looks not correct.

The while loop stops when
mprotect_ro_done | all_vcpus_hit_ro_fault
-----------------|----------------------
   true          |      false ==>producing "Expected EFAULT on write to RO memory"
   true          |      true
   false         |      true  (invalid case)
   

So, I think the right one is:
-	} while (!READ_ONCE(mprotect_ro_done));
+	} while (!READ_ONCE(mprotect_ro_done) || !READ_ONCE(all_vcpus_hit_ro_fault));

Then the while loop stops only when
mprotect_ro_done | all_vcpus_hit_ro_fault
-----------------|----------------------
  true           |      true

>  	/*
>  	 * Only architectures that write the entire range can explicitly sync,
> @@ -81,6 +83,7 @@ struct vcpu_info {
>  
>  static int nr_vcpus;
>  static atomic_t rendezvous;
> +static atomic_t nr_ro_faults;
>  
>  static void rendezvous_with_boss(void)
>  {
> @@ -148,12 +151,16 @@ static void *vcpu_worker(void *data)
>  	 * be stuck on the faulting instruction for other architectures.  Go to
>  	 * stage 3 without a rendezvous
>  	 */
> -	do {
> -		r = _vcpu_run(vcpu);
> -	} while (!r);
> +	r = _vcpu_run(vcpu);
>  	TEST_ASSERT(r == -1 && errno == EFAULT,
>  		    "Expected EFAULT on write to RO memory, got r = %d, errno = %d", r, errno);
>  
> +	atomic_inc(&nr_ro_faults);
> +	if (atomic_read(&nr_ro_faults) == nr_vcpus) {
> +		WRITE_ONCE(all_vcpus_hit_ro_fault, true);
> +		sync_global_to_guest(vm, all_vcpus_hit_ro_fault);
> +	}
> +
>  #if defined(__x86_64__) || defined(__aarch64__)
>  	/*
>  	 * Verify *all* writes from the guest hit EFAULT due to the VMA now
> @@ -378,7 +385,6 @@ int main(int argc, char *argv[])
>  	rendezvous_with_vcpus(&time_run2, "run 2");
>  
>  	mprotect(mem, slot_size, PROT_READ);
> -	usleep(10);
>  	mprotect_ro_done = true;
>  	sync_global_to_guest(vm, mprotect_ro_done);
>  
> 
> base-commit: 557953f8b75fce49dc65f9b0f7e811c060fc7860
> -- 
So, with below change based on your fix above, the pass rate on my end is
100%. (If only with the first hunk below, the pass rate is 10%).

diff --git a/tools/testing/selftests/kvm/mmu_stress_test.c b/tools/testing/selftests/kvm/mmu_stress_test.c
index a1f3f6d83134..1c65c9c3f41f 100644
--- a/tools/testing/selftests/kvm/mmu_stress_test.c
+++ b/tools/testing/selftests/kvm/mmu_stress_test.c
@@ -48,7 +48,6 @@ static void guest_code(uint64_t start_gpa, uint64_t end_gpa, uint64_t stride)
         * is low in this case).  For x86, hand-code the exact opcode so that
         * there is no room for variability in the generated instruction.
         */
-       GUEST_ASSERT(!READ_ONCE(all_vcpus_hit_ro_fault));
        do {
                for (gpa = start_gpa; gpa < end_gpa; gpa += stride)
 #ifdef __x86_64__
@@ -58,7 +57,7 @@ static void guest_code(uint64_t start_gpa, uint64_t end_gpa, uint64_t stride)
 #else
                        vcpu_arch_put_guest(*((volatile uint64_t *)gpa), gpa);
 #endif
-       } while (!READ_ONCE(mprotect_ro_done) && !READ_ONCE(all_vcpus_hit_ro_fault));
+       } while (!READ_ONCE(mprotect_ro_done) || !READ_ONCE(all_vcpus_hit_ro_fault));

        /*
         * Only architectures that write the entire range can explicitly sync,

