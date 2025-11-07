Return-Path: <kvm+bounces-62287-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id EC210C40079
	for <lists+kvm@lfdr.de>; Fri, 07 Nov 2025 14:07:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 912DD4EF882
	for <lists+kvm@lfdr.de>; Fri,  7 Nov 2025 13:07:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 402ED2D47FD;
	Fri,  7 Nov 2025 13:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FydJFifL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74BEC2C3258;
	Fri,  7 Nov 2025 13:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762520847; cv=fail; b=pgfD1mmT7DAUnrwsfA7WSXZyp3CzgV0c6tSkRRUmMNUzGqJ40l1CnDRJLgLkSYcS/rbrJ9wIug+Fwh6Yxh5bCDPpmG6YPiN3zkLGu7x3oHAadJd9Co+devUWysZ0VKZKoMeBz4LLhd1fyXBhEaY2Nbw+TEEWC8UAMHLuOiGbGJo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762520847; c=relaxed/simple;
	bh=+SyPE9YUc4mbhp6oHlC1Fm0VD57kw/AR7it0pX2mhrQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=uJHusLiHUjw0IlZpzWDCfmTWTR4FrGKNjgxTiUXKLpWfjKcuH53EMuuxzU/Rr0ALLSb6MmH9zsEoi2MlAdjgqHSjZTsBJ5XOn+PAuIon92LwBTqqUtF66BklIQD5TpvZIvS0JAJz8VlXPUE1O4sszbl5gn9sFL4xQKrdImKyNxI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FydJFifL; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762520846; x=1794056846;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=+SyPE9YUc4mbhp6oHlC1Fm0VD57kw/AR7it0pX2mhrQ=;
  b=FydJFifLa0Ygv7XlAyDegFMdkGYNFSL7HAOVMVJkYy9oPNc0eEQrbI1j
   bxhFfyMGwZ4HTw47bHvXIy0hfBfLznAqljv3RHUmnY/wxFfc4gdw3dPdu
   RfB8SRasuQ5ooF0lZhRWteedq9QiQhtVcSIcMHAdzb5je2dxqt/u8O6HJ
   X7OLqUUftHEAyGuP55gd6BHZ/gb10bC426qE1UetvRJGbtLgxfQqUMDA/
   HoVMaOCKqY4MmLLZ3Vu2Ze+Ix6+8+OoIfe5ZxC3172hmBrZv40mVSPgNC
   c3LD6EBisE62Ewf6g/kp8B4byToy2onXHIhCwpiOF8M1DOC+uxEHNcwEh
   Q==;
X-CSE-ConnectionGUID: C7VMqzB1S32C6QA0jixQmg==
X-CSE-MsgGUID: 2H6t0CVnRYaTT7ZmpDu6Hg==
X-IronPort-AV: E=McAfee;i="6800,10657,11605"; a="76021228"
X-IronPort-AV: E=Sophos;i="6.19,286,1754982000"; 
   d="scan'208";a="76021228"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2025 05:07:25 -0800
X-CSE-ConnectionGUID: A1aj5UrRS4KD64lUM8JZ3A==
X-CSE-MsgGUID: UGga5qhJQjKlV6aouuLZSA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,286,1754982000"; 
   d="scan'208";a="188301866"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2025 05:07:24 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 7 Nov 2025 05:07:24 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 7 Nov 2025 05:07:24 -0800
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.5) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 7 Nov 2025 05:07:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UIaN/hw+LcMDUF502R6kebPUDv0PhxITCM0v0sWHQ9a2BPbr/s7DtSN/5eyvubdguZKjMuVrUG/ujl/XNaO84p+syat281z9o3z4YxKkFhNpRXcao0LgCeuNi0lxOrITWpsq/STCsQ/j6oP0D11OigqPWR/1JSFIE0L7VWSs0+RNtj3/AJ1q4Jqb4giMORDgo9G1rSHoUON3OkeWg3Obs8/67tWYFX3iTAspeTXVaj6dysHdp8EvKlXW4cjHDhpeezqPQZvoOX/WmKFD77n/dteeFOg71nYSxXNu6hgwHQKwjYzU+rJJ0SZHjYgcCDzf7dtqaaN35UawbE9Pd36ZOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iMhhiECwF9B8Sz5beqXDFK0rfyCQqel+mjxiTYHfBzA=;
 b=qie6Yz8QFTswAe2DhKsXfRh2Yb6Mi8Rdf9yDyF8NTzu790t2UFKmSGuH5h30yCQPsCbgmm9wBDgmylPfR1V0hyoqcDiaNpflAm6SfBiXXJv63aQepLGOg134YtWjcHL2v3jzJmU5bq7UjHDkv+pQICDsjRsTnnIssfac1nxa0G9W1lIYiwvKUuEuegeY8QzHxv4z5gNBgX/FNjBkoBhhadOPbPw7HGXeBrIiwU6nLlREIB1GfCJ3H4uIwuVouhAHHUbGY/pBlpc80g4Rkw138pR57quaIG2xKAx/yQFJrjSEF/pclWcqJ1d8w/OBRmtmpLyFkVvd33unosp0VwS8Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH0PR11MB5031.namprd11.prod.outlook.com (2603:10b6:510:33::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9298.12; Fri, 7 Nov 2025 13:07:20 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9298.012; Fri, 7 Nov 2025
 13:07:20 +0000
Date: Fri, 7 Nov 2025 21:05:19 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Michael Roth <michael.roth@amd.com>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <david@redhat.com>, <tabba@google.com>,
	<vannapurve@google.com>, <ackerleytng@google.com>, <ira.weiny@intel.com>,
	<thomas.lendacky@amd.com>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vbabka@suse.cz>, <joro@8bytes.org>, <pratikrajesh.sampat@amd.com>,
	<liam.merwick@oracle.com>, <aik@amd.com>
Subject: Re: [PATCH RFC v1 1/5] KVM: guest_memfd: Remove preparation tracking
Message-ID: <aQ3uj4BZL6uFQzrD@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250613005400.3694904-1-michael.roth@amd.com>
 <20250613005400.3694904-2-michael.roth@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250613005400.3694904-2-michael.roth@amd.com>
X-ClientProxiedBy: SG2PR04CA0168.apcprd04.prod.outlook.com (2603:1096:4::30)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH0PR11MB5031:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ff931b3-a34d-4223-4315-08de1dfe9591
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?3LdkmoWBZO+hvmxDuAbm5/ne8sZ3QIaZaaEwcdpy/j5jDzkTS7e581OrA9/B?=
 =?us-ascii?Q?V6I04oUTrTUbC3P1UGZFuWva5Dyksj0SbSFkNpAhVcpKVWpWHWqf82JBPLZi?=
 =?us-ascii?Q?pR1YOLhOQtENHG4NMExD/IqpM+tSOT01BCJhFeHVZsz6CpSLATwMlgRVW51E?=
 =?us-ascii?Q?5JEMRa8l4m2lNoudpvuofKVN84gumvpG/4oy4mckf5KAEs2RVNC7aZPVMzKC?=
 =?us-ascii?Q?WBWNrj1pbwxNoL9CpZ4D0+jqxbhXnYu0sT35jVpWo1rxoUK+yoxfSrFGEyAp?=
 =?us-ascii?Q?e3wHhtdEfkecMb9WVCdN0UOhKcLpUyWk3XIcwR7AWihdgtS+JboEGXj2GPXC?=
 =?us-ascii?Q?HRcuPtrB39SL9Jkee9RSDZNgI81he0d2xufffK73IpuJx10zTVAkQaGWpd+4?=
 =?us-ascii?Q?s0GT8ukYglcsR10cxSS7asmrA9TiyBHxB36BssyE92h/vDMG6WXY8Fl5NiPh?=
 =?us-ascii?Q?8B2VYnKXF+YybJ0RowJyP+iHKZ03K9rmn5BzL3fVmq2fcvwZXfH8QO0LHXaB?=
 =?us-ascii?Q?+WKzwrgfjIDp80m6TM/M30eQ8mjWtntSP7iN6fn84u9PkakIhdaT0ER+lQ7l?=
 =?us-ascii?Q?o2YocMVP+iJFjuAtLVL4VNvbH1KomeepA7+eyuBWYPzUm4DtyXax25DGipAW?=
 =?us-ascii?Q?LD/cLlimYAxsvZ0TtEhdYjLsjkzZ1XD61T/N0ONje15+tVDg//TTF99r0m3g?=
 =?us-ascii?Q?HhoCei0bA1Y3vRRVs2qWlfOuPgAShUN0WBEZvhBXIVG6/sxxaGWsVSnC0uHu?=
 =?us-ascii?Q?GcHOKxl3EtiTUoRezTDDO5VL66Rcv2Xj7fhdHl7DkQ8AC6oiGTq9wxKtx0BO?=
 =?us-ascii?Q?7frpfhjGhL2au31G/PVHVPOqNmYBbdKVklRVO2ISfQs/ZZKw7aXFkntYDMiI?=
 =?us-ascii?Q?dK/r/+gARblYS6WdFDWYfhCV2U/bvfbZ7MGviCNPkGt6AY56m0BvR4lUPfW1?=
 =?us-ascii?Q?B0cA5AlpCgNalc9uPLPNGlmt9T0gH2wmBg0IiNUWsDCPAg3S0MQTTUvmiBWu?=
 =?us-ascii?Q?YeJAX+ci4q3jS/4aMS5iIjgOiMEado1x594LLrM3F+2WGrhBmPdTe3neH5J7?=
 =?us-ascii?Q?lSAYEWG7jzIvPDu0w2FkIx7peeHqj2deip8rHgt8lZ4NkpwiPi7Ztyw1iff4?=
 =?us-ascii?Q?5ZdTLkNcifuyAKynq2U+yWxG9ktHOlgZip/SJKiBHoJvje7hWYJpXSJO7Tyb?=
 =?us-ascii?Q?7RRp8adYvTJ2BTNNQCvxMKI1rYMiVoH/zwgJLOFwxi+AJ0Sx22DK9z+14zqX?=
 =?us-ascii?Q?LO2Ow2u0F8quOarqQCOp/BNLq7qhBeqL30V0+LH+qjcTWdmpDvYmBfYs5gEW?=
 =?us-ascii?Q?ZzRhsrZxGJEgRAOBuxVqahTS5+/mK193DifVukej3HrIs9iZhxm3zcwkubqK?=
 =?us-ascii?Q?wDmXoRIo1qtVSJXiLVjyuVqP6l4m4AVGSpxjuqlngJEuaoaLLcuPq9ymL7yi?=
 =?us-ascii?Q?EDk7XRHNzFPivCrFpc5Z1YsCsmdmXuPx?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xpfzZD3saRpoQKRmsZlu0R3Ps07PxQRQb0zIyMPVO/PWM6kHUy25jk4QSGbu?=
 =?us-ascii?Q?PKFekcierjsOTqfK3EmPt/4oPG8JmK3+0h2zHNQVzgiE3LlN37Wkuq33j/76?=
 =?us-ascii?Q?tJeJuCn8UoJyL6drrphAkppjHOkc894kQnKl0I5VMGWT1utjPP5mgB0I5qNd?=
 =?us-ascii?Q?YNA2z4HgYcG6vg8QeaDhUZH6gIIlJNPGQB+v31PgYitp/G8BbGFul7nk4gp5?=
 =?us-ascii?Q?zz5vLtLXc5A4+ygwg9NQqd6Xy6zqAoz4pH4QvfgZ3CirUni0Iopnk6x0VXQB?=
 =?us-ascii?Q?JwKEDvHj/7AZ3wF2wx831DVIf9Y2m1b1OS/B6mc7dgime69xiRJOPKmpVJf8?=
 =?us-ascii?Q?WM7Hoz7dz/86VJJ0Anf06pGAatlV0q4lmpLviBmOW14w8mM198pBzoE6ujqm?=
 =?us-ascii?Q?fH+aW8xcOsLtwrXwWc3bamOKTns87GaeqWZ0JeWzi1E6AWj2cScBR1d92V38?=
 =?us-ascii?Q?2WKYO5z0uDD/ckFsqft7P5fW9w75BR8cTG4B//0BCPl25n+R3IaLZ8DIpWDR?=
 =?us-ascii?Q?kg0MC/fgUxpXQAwInNIJAKTHHJsxlS5riijyZ/EntbOjpr9Ce+/6yl7AUbDf?=
 =?us-ascii?Q?tdwEbml3I8S+d7BGCDl2YmlIpHL7UpikjdsxUG0ra/Db1bPMxzRyMOH4ZEks?=
 =?us-ascii?Q?ezk2P7TrmZ5eiFZ55KiOSksnlST22TeUpOpyxag6ReOKIL2qnmWt2O1usDYm?=
 =?us-ascii?Q?PbehcPwKq+5SFITe/FVIuQoE8BHE7oAOkDLQBMStTWn3nlRDoqzf38liJfUW?=
 =?us-ascii?Q?STrTkDCPLxg/V/QWq6P2xX8jC0wxs3uHur9CnRcqD6ngUNnrrASaPmyTUcOi?=
 =?us-ascii?Q?THhuohSsRKJulbLQUbJa5yspI+aWjDbcSSsWXXA1MX9uceKhW9JciEeDJSVY?=
 =?us-ascii?Q?f0MMQi1uDrI0xoj2/PvmrKQST0cYjJ/2+J64403K9xMkCQqvo6O97L59/g2u?=
 =?us-ascii?Q?GoCjcMx5Xd5crfb9My0jkw+fFKgApv8uO5XF4HhbU7fEwa5mWQz3CXdf75vm?=
 =?us-ascii?Q?3Eo69553O2Lh09n4/2orlrDGi50eNPI3tsmkZpFJjoPvAfcU7tjocGh7uirT?=
 =?us-ascii?Q?3QS75/cRmgO8yYPrbJHlipjUN6enujstf4TH2eLK33hyQfgLhF6QlIxn8hrH?=
 =?us-ascii?Q?SIIBxDI7l/GJuARW/x9IfZvARYXXJtwmMNq0/MDzMkXDaAk50DuLxojA3KKa?=
 =?us-ascii?Q?QjD0TtTMPJneGy4On/BX1VabDemzppzTdkE8WR3CSl+ld5dt4LbqmFo0OSGh?=
 =?us-ascii?Q?MAb+QXrz4QksERTuQQ2uWDWD5yd5vf342/6wX+kPxbCT5EakjbRkXQoGTLPX?=
 =?us-ascii?Q?vDVA/qxjSS2ysrUAikuTrvwkGwUhKUwOKCwifx8zB024FixZQ+jdjCIf4lOV?=
 =?us-ascii?Q?tEBAIMs7WGU5deWWpQz7OIBZ13+czRyCvgmo4MHwphy4+DjMEG1vC/+ywv/U?=
 =?us-ascii?Q?/KJnW/e/QhTA8nsx7ENRg4OogB5vcTuwNG1u96qWq0RNyHkMuVlXEhcV75aH?=
 =?us-ascii?Q?CUnwqUDywiH8+1leFrBqd0GgCs+Uo3iQFC3CfeBkY0+2B91j4N0hfjC7PfuX?=
 =?us-ascii?Q?guNg0Mde1/I62Is7/bS6J3EuZLgdYckf81dx6Jgb?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ff931b3-a34d-4223-4315-08de1dfe9591
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2025 13:07:20.5594
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +uSci4J+wi9S4ccIsmegZZ7Zq4GZPN2Uq6QIAPue5hbXX0iSjTqWqQPM+Lj7OIzQ5QopAyIfpkD2nTX6xgUnNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5031
X-OriginatorOrg: intel.com

Hi Michael,
Have you posted a newer version of this patch?

I also have a question about this patch:

Suppose there's a 2MB huge folio A, where
A1 and A2 are 4KB pages belonging to folio A.

(1) kvm_gmem_populate() invokes __kvm_gmem_get_pfn() and gets folio A.
    It adds page A1 and invokes folio_mark_uptodate() on folio A.

(2) kvm_gmem_get_pfn() later faults in page A2.
    As folio A is uptodate, clear_highpage() is not invoked on page A2.
    kvm_gmem_prepare_folio() is invoked on the whole folio A.

(2) could occur at least in TDX when only a part the 2MB page is added as guest
initial memory.

My questions:
- Would (2) occur on SEV?
- If it does, is the lack of clear_highpage() on A2 a problem ?
- Is invoking gmem_prepare on page A1 a problem?

Thanks
Yan

On Thu, Jun 12, 2025 at 07:53:56PM -0500, Michael Roth wrote:
> guest_memfd currently uses the folio uptodate flag to track:
> 
>   1) whether or not a page had been cleared before initial usage
>   2) whether or not the architecture hooks have been issued to put the
>      page in a private state as defined by the architecture
> 
> In practice, 2) is only actually being tracked for SEV-SNP VMs, and
> there do not seem to be any plans/reasons that would suggest this will
> change in the future, so this additional tracking/complexity is not
> really providing any general benefit to guest_memfd users. Future plans
> around in-place conversion and hugepage support, where the per-folio
> uptodate flag is planned to be used purely to track the initial clearing
> of folios, whereas conversion operations could trigger multiple
> transitions between 'prepared' and 'unprepared' and thus need separate
> tracking, will make the burden of tracking this information within
> guest_memfd even more complex, since preparation generally happens
> during fault time, on the "read-side" of any global locks that might
> protect state tracked by guest_memfd, and so may require more complex
> locking schemes to allow for concurrent handling of page faults for
> multiple vCPUs where the "preparedness" state tracked by guest_memfd
> might need to be updated as part of handling the fault.
> 
> Instead of keeping this current/future complexity within guest_memfd for
> what is essentially just SEV-SNP, just drop the tracking for 2) and have
> the arch-specific preparation hooks get triggered unconditionally on
> every fault so the arch-specific hooks can check the preparation state
> directly and decide whether or not a folio still needs additional
> preparation. In the case of SEV-SNP, the preparation state is already
> checked again via the preparation hooks to avoid double-preparation, so
> nothing extra needs to be done to update the handling of things there.
> 
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  virt/kvm/guest_memfd.c | 47 ++++++++++++++----------------------------
>  1 file changed, 15 insertions(+), 32 deletions(-)
> 
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 35f94a288e52..cc93c502b5d8 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -421,11 +421,6 @@ static int __kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slo
>  	return 0;
>  }
>  
> -static inline void kvm_gmem_mark_prepared(struct folio *folio)
> -{
> -	folio_mark_uptodate(folio);
> -}
> -
>  /*
>   * Process @folio, which contains @gfn, so that the guest can use it.
>   * The folio must be locked and the gfn must be contained in @slot.
> @@ -435,13 +430,7 @@ static inline void kvm_gmem_mark_prepared(struct folio *folio)
>  static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
>  				  gfn_t gfn, struct folio *folio)
>  {
> -	unsigned long nr_pages, i;
>  	pgoff_t index;
> -	int r;
> -
> -	nr_pages = folio_nr_pages(folio);
> -	for (i = 0; i < nr_pages; i++)
> -		clear_highpage(folio_page(folio, i));
>  
>  	/*
>  	 * Preparing huge folios should always be safe, since it should
> @@ -459,11 +448,8 @@ static int kvm_gmem_prepare_folio(struct kvm *kvm, struct kvm_memory_slot *slot,
>  	WARN_ON(!IS_ALIGNED(slot->gmem.pgoff, 1 << folio_order(folio)));
>  	index = gfn - slot->base_gfn + slot->gmem.pgoff;
>  	index = ALIGN_DOWN(index, 1 << folio_order(folio));
> -	r = __kvm_gmem_prepare_folio(kvm, slot, index, folio);
> -	if (!r)
> -		kvm_gmem_mark_prepared(folio);
>  
> -	return r;
> +	return __kvm_gmem_prepare_folio(kvm, slot, index, folio);
>  }
>  
>  static int __kvm_gmem_filemap_add_folio(struct address_space *mapping,
> @@ -808,7 +794,7 @@ static vm_fault_t kvm_gmem_fault_shared(struct vm_fault *vmf)
>  
>  	if (!folio_test_uptodate(folio)) {
>  		clear_highpage(folio_page(folio, 0));
> -		kvm_gmem_mark_prepared(folio);
> +		folio_mark_uptodate(folio);
>  	}
>  
>  	vmf->page = folio_file_page(folio, vmf->pgoff);
> @@ -1306,7 +1292,7 @@ void kvm_gmem_unbind(struct kvm_memory_slot *slot)
>  static struct folio *__kvm_gmem_get_pfn(struct file *file,
>  					struct kvm_memory_slot *slot,
>  					pgoff_t index, kvm_pfn_t *pfn,
> -					bool *is_prepared, int *max_order)
> +					int *max_order)
>  {
>  	struct file *gmem_file = READ_ONCE(slot->gmem.file);
>  	struct kvm_gmem *gmem = file->private_data;
> @@ -1337,7 +1323,6 @@ static struct folio *__kvm_gmem_get_pfn(struct file *file,
>  	if (max_order)
>  		*max_order = 0;
>  
> -	*is_prepared = folio_test_uptodate(folio);
>  	return folio;
>  }
>  
> @@ -1348,7 +1333,6 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>  	pgoff_t index = kvm_gmem_get_index(slot, gfn);
>  	struct file *file = kvm_gmem_get_file(slot);
>  	struct folio *folio;
> -	bool is_prepared = false;
>  	int r = 0;
>  
>  	if (!file)
> @@ -1356,14 +1340,21 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>  
>  	filemap_invalidate_lock_shared(file_inode(file)->i_mapping);
>  
> -	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, &is_prepared, max_order);
> +	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, max_order);
>  	if (IS_ERR(folio)) {
>  		r = PTR_ERR(folio);
>  		goto out;
>  	}
>  
> -	if (!is_prepared)
> -		r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
> +	if (!folio_test_uptodate(folio)) {
> +		unsigned long i, nr_pages = folio_nr_pages(folio);
> +
> +		for (i = 0; i < nr_pages; i++)
> +			clear_highpage(folio_page(folio, i));
> +		folio_mark_uptodate(folio);
> +	}
> +
> +	r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
>  	folio_unlock(folio);
>  
> @@ -1420,7 +1411,6 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
>  		struct folio *folio;
>  		gfn_t gfn = start_gfn + i;
>  		pgoff_t index = kvm_gmem_get_index(slot, gfn);
> -		bool is_prepared = false;
>  		kvm_pfn_t pfn;
>  
>  		if (signal_pending(current)) {
> @@ -1428,19 +1418,12 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
>  			break;
>  		}
>  
> -		folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, &is_prepared, &max_order);
> +		folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, &max_order);
>  		if (IS_ERR(folio)) {
>  			ret = PTR_ERR(folio);
>  			break;
>  		}
>  
> -		if (is_prepared) {
> -			folio_unlock(folio);
> -			folio_put(folio);
> -			ret = -EEXIST;
> -			break;
> -		}
> -
>  		folio_unlock(folio);
>  		WARN_ON(!IS_ALIGNED(gfn, 1 << max_order) ||
>  			(npages - i) < (1 << max_order));
> @@ -1457,7 +1440,7 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
>  		p = src ? src + i * PAGE_SIZE : NULL;
>  		ret = post_populate(kvm, gfn, pfn, p, max_order, opaque);
>  		if (!ret)
> -			kvm_gmem_mark_prepared(folio);
> +			folio_mark_uptodate(folio);
>  
>  put_folio_and_exit:
>  		folio_put(folio);
> -- 
> 2.25.1
> 

