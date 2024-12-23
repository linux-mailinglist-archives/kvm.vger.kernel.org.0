Return-Path: <kvm+bounces-34326-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 95DCC9FAA32
	for <lists+kvm@lfdr.de>; Mon, 23 Dec 2024 07:12:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B538018863E6
	for <lists+kvm@lfdr.de>; Mon, 23 Dec 2024 06:12:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B678716F8F5;
	Mon, 23 Dec 2024 06:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E2CCzkfT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A60998172A;
	Mon, 23 Dec 2024 06:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734934335; cv=fail; b=rUp3djQ3NQTmh3uCIIuYAPWVROvIuzYJynA/zwQ/9QCKVTr0m3bl1CE9OyRIs96vRFK/rGgVoGDpic282sd+KUBoxqYJiZ08jH+XnIO7xVXmPWOFA7b5gmv80INp0mTzGcw3/e4ASpQ2yCRNvYlQTEg8Kp0ph/8ok2DTThex124=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734934335; c=relaxed/simple;
	bh=e9QmPiE73BhepKfWarqfnbUQ02R2lJ87H2srk+r1SE0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=I/xZPrzFu+pg0ZEuaxSybz0YvdLz+EekHundof43FBjBwLSe24z9eYvxhuMhWQA+3eIzLvybaqqvBD5P2MO4gx1sR65BsXCgWlv+PzhfzqyiH7USg240huMOOWSCgRtupH9RS6iyXRYZqVnTAIuWGTEmsVMSTlxmVsQA0jnsO3c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E2CCzkfT; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734934334; x=1766470334;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=e9QmPiE73BhepKfWarqfnbUQ02R2lJ87H2srk+r1SE0=;
  b=E2CCzkfTsTMbVIu60n3a1keMpmA4CI7tKoa6BVxpoR8ejNbmBoVi+mEF
   +rQaHysugxkWO2JD8qy9ZDzfmdRqk2nNzh0Q1S7gsEZTyAYx6ZjWIyCMS
   kmP4exKUTh0qNAe8sEPoz4AfeSKppSXjqPvuj0khhOR1X7vq7CDnpPp6D
   1WFfdry1n42S8QhqYiJsa69avCuihsYw+tu5Azyf91nwRpkpr8toqEI8s
   BH32aLF/pHJIJdGIYnxtM8JaMLn1W4O275Rma6XkC19dwpmp1h5q9VoTK
   gZMUx5jzzfbmnTgfjFOWDE6Vuv+Vjr+jTCva3+mfXr1JiV9HdSSYrr++I
   g==;
X-CSE-ConnectionGUID: H2UCuqzvQVyaLjplBVpb0A==
X-CSE-MsgGUID: krYJVtI2Tz671ZyEulQthg==
X-IronPort-AV: E=McAfee;i="6700,10204,11294"; a="57858495"
X-IronPort-AV: E=Sophos;i="6.12,256,1728975600"; 
   d="scan'208";a="57858495"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Dec 2024 22:12:14 -0800
X-CSE-ConnectionGUID: 1mDtMweuRX6jxJuIzNyBwQ==
X-CSE-MsgGUID: LY+P0l+QSkiDxrBiwOz5zA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="99975029"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 Dec 2024 22:12:13 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Sun, 22 Dec 2024 22:12:12 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Sun, 22 Dec 2024 22:12:12 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.49) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Sun, 22 Dec 2024 22:12:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fhQLyibc2qtzoJlVRIR192LOeun1R/HkBh/Ncz182CbhPUOUiqETgmo14Bx4eEs+rm05gdRq18QmV0v3YXoeV4+eG4xtih5BSBO2Kgwko5rFZSE3B/WYJSWn0AzugPSDOByrU4fTNiLahcEfpicnK9ee4uzOcsf7rue9oUMV23sLYmIQ7BhrbONOQX2lAqdMweirz8fOEqdTtGmJttmMetXwt2ZwswrP4uexvJ3JOFUuIUijJri7IfAUlV6WWk6xY0FeUeCWmCoASDRMaq467M5N8pUwU0Cy+ZjSCXi5CRKOHGploH3VV+AsFbwELsbW3bXwx0d2rLeuDBJAVJV9gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gH9nlk7UJITx8hOfAH8oyxh4cT1RgmnBfL1mUT2jmYU=;
 b=F4w8Z6gVK+2qfiopDPatvcZngzS8mwLYLZYccU5aAAbb/d1suIbNQjmQDc6ZgYq29Wm5UWW8tf+JSh/YCU6nmrG6wTlaNWumovOo8b9s6+29/H03pUGyBCVIL1Hj49EWMMxOa7tYSjWKAtQZXcOmVrvcR5pHJYIAUkVrSNl1LGmv5WY9jOnwzZS8p2wLtt8WEDui9k3wkkOIE6YKeQBsNS00Lq77qGWdVgc2Q4TisFFBUg8mIVax6nxkaVDKV4tZSwuAKPxZ/GsjPZdv/m72MWiPRM7p7rF+nddeT7DDakEiIHkNNd/h7wCyML3+l8baN07vkPLVdue4eAJE86+eZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 BN9PR11MB5242.namprd11.prod.outlook.com (2603:10b6:408:133::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8272.20; Mon, 23 Dec
 2024 06:11:25 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%7]) with mapi id 15.20.8272.013; Mon, 23 Dec 2024
 06:11:25 +0000
Date: Mon, 23 Dec 2024 13:37:03 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: <pbonzini@redhat.com>, <peterx@redhat.com>, <rick.p.edgecombe@intel.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/2] KVM: Do not reset dirty GFNs in a memslot not
 enabling dirty tracking
Message-ID: <Z2j2/8dEsg4jme2n@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20241220082027.15851-1-yan.y.zhao@intel.com>
 <20241220082231.15884-1-yan.y.zhao@intel.com>
 <Z2Wp9w2BUrhV2O_c@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Z2Wp9w2BUrhV2O_c@google.com>
X-ClientProxiedBy: SI2PR04CA0007.apcprd04.prod.outlook.com
 (2603:1096:4:197::19) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|BN9PR11MB5242:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d8f49d4-e843-41bd-342e-08dd2318a1bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?7nC7cVN9DdIA3dpt+GADQrQUj5ctmxdiRtbP6KAq2jbAoQWn4/9tt4WaG0Wz?=
 =?us-ascii?Q?lwO5aJRJyS0fS9iD9alULcuRkIF8+6Y7Ib6UJDE/w+SslD3RNeGoYXVlZ5+J?=
 =?us-ascii?Q?JrJ/+X7a4YyaRbhaneQpIA27pbIqf5E3nwBBXfFLL6iOjGsTNn/AwOjf/iYr?=
 =?us-ascii?Q?P5Ghpv/2L74BVsVhaB6ErmvcBCxFRd9NHEgrd4YoGUAHjwPdvspHidJZQx2A?=
 =?us-ascii?Q?oX2YYbvDlsF1hp/qGPSqjadldC5RlWOjB2KLOjyKDuEMc37Hz3ygJ8OpKoHU?=
 =?us-ascii?Q?ZpNj0no/Jlhj3edauwH7OrzsTPcWSpIMzDcuIxbuiPlkSrNB9dOSo+YEJuCn?=
 =?us-ascii?Q?gl4Jb9+O92JoAbFSToXyArh9w3e7vOIl3k3Nmsg1AQkXkh7Lmm7JaufmqryG?=
 =?us-ascii?Q?6199H/cGVlk/uJGu58XlUcBAcxfCj6roysfyeKYw/uHpELBRoVgLmMkjBwEH?=
 =?us-ascii?Q?9IPLLeOTThcb1p1Zag3y3ysx6prqdvtQJwwgUnaJJTYo523RUwnYFjWrTmO3?=
 =?us-ascii?Q?92DQUNMyxSKDGbcLIAIE0IFX2wutya1+j+6R7gQpIHrwOJ8AUg60BNjnUFWf?=
 =?us-ascii?Q?wLidH2DMfpXDy53/uf0In7loRXearKYCE4oAL+zLfi0TUI2Ncd0BYNdQdl2R?=
 =?us-ascii?Q?BwBvgcA7PQWI5dFD7/PeRCpzfXnIcK2L2ClrOL15+cA0TVfGlP+Q0mnCDzoZ?=
 =?us-ascii?Q?oZZk5eH4uUmddn2zbKsaTYoBRtMH68jsZAo+HN2og+CTKer3IAZyKWprUcCv?=
 =?us-ascii?Q?Kb4QIWTa2P8TUKKhZTNGv7YqweU13pxkfCQUVwoSvx9ytiXV+DLfqDX7R8fr?=
 =?us-ascii?Q?zR2KYycyhiE8w7cC3GjjjfI/eAZpUpTFBuBQ59cLbAAVKXDuSsLBsiRYKitZ?=
 =?us-ascii?Q?sqxgH+1HCav6gxjIbTb4J4YaIZ4sJc72dMtV09CgDqjg8eB5FYn52mGdLBd2?=
 =?us-ascii?Q?sTrMhTXSuCjCLLg9z4FVIkPnUAkAr5Azh1iaIr2UcK0gUv8xHwuxU2o5C3TR?=
 =?us-ascii?Q?7BTynfUUvtpT8bXGQWKMPoYRfvcOhXhXd0srrGLdBc1pysErStWYPAITEKIk?=
 =?us-ascii?Q?Rs4B2A16wgVMlZiECYvkZ0mKIRPY8boHJaReElYYnjhfrDtLDzWO27pU/pI3?=
 =?us-ascii?Q?TiF/TFUQX/L5aL78J7LVoUfssNqf561kS1a7rltOhWL691PMjqpwBN/Q4hN9?=
 =?us-ascii?Q?cxs8HVK8LDhVLjihMi/WvBjJUcUgNfPyZ/efkWgwXoUPHi5pRf7vBeRX5scG?=
 =?us-ascii?Q?6ItpBE9pnRCh80A7BZgpwd4ggrMfz24kjELDMVFHeY0k+GUcNHz5AFchZARR?=
 =?us-ascii?Q?R0SQfFVpskHSpXxHTiTp6DUp5mWyD4tfE6yiIkPVrzf5wM81L1OxDwTHjbFQ?=
 =?us-ascii?Q?+SoKHI2k77tDlofHxBpoXQZ1mW8j?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eV5SldYKnr389H/q4KfX8ks/cwI9WbeocFPlrkcXgLYbIrzyGdMlJLXf7jei?=
 =?us-ascii?Q?hQedzCbHjyExdnbiLgebx7su0BcUt8usZQGknmvCNurJAZ0EJ4DZIrbt3IjB?=
 =?us-ascii?Q?2Jzpy0MEZTd26TBCxnaTPk08e1LXjfG32tAf4P5uZ/V3DWA0ly0FHr4Ms+Us?=
 =?us-ascii?Q?Y+sKcjGVc5LbjMOo3mLb7zaSjzU64xKQoQPk2KRnW04f8gz6mzcLAR4P2ie4?=
 =?us-ascii?Q?ki+DShP/KDvjNNvrwv+Y/ad+5xUdDjNpOuwWOwaNOmr1iRoEuuEa8xNjKrW7?=
 =?us-ascii?Q?RgiliZFJ7a+065VAu+KB8zQDINEC1XXU5b8g3Y8qPObamWcCLyB+Onlaa6pt?=
 =?us-ascii?Q?imavYlatpxFeNQWvwPD/bKq/vXW+CSN+haGIMaq/Tfs6fDJQyG0JFX1AT94t?=
 =?us-ascii?Q?jk7XXyFSPH7zOtHsiVx/4M8FHV+q+y18mjJO6kp5yyQzSwTKbtDdtZCfq0nE?=
 =?us-ascii?Q?Ruo7x/v+Oglamk22MJWjwjDvKs9MAeTwV4HWjFmoiBxg8z4tRe99IiU0RHrC?=
 =?us-ascii?Q?y/1Lh/a4VLqeUPywaWyNxeXfzeaymHtXm9uWNML8IeNIXYPEU+qUDjRuSSwt?=
 =?us-ascii?Q?riUSUl0uX30XAdnMX34HqAdv6yMQWrbPdCkVi7O7wyFFSs8eQW2DoYvM+Rpa?=
 =?us-ascii?Q?9wKTS7BTDs68/36lpYn7GbiK6kMgYHFi7aqyapTNz7o+efwjsKbstv1fy354?=
 =?us-ascii?Q?/1i0QppfyXoSZvGFW6VxGs4jhvQWBfCT/grniFB407ZBFk85P0Fgy82vM+/m?=
 =?us-ascii?Q?lZMwougXpKg4zAj7rta3CYwKS4KnZ6PmEVzM4yqI933J9FYwOG0n8N8HLWAc?=
 =?us-ascii?Q?KStIenSlcd+UM7jovF2nfU7gDygyi3qnidRDyM4YfqHISVW8mwxfONkXiBaN?=
 =?us-ascii?Q?icuc79NdmD5xy2vBTOw+L6GU3dAhUi+Jzg0F0zXaMsyNrsrve+VhFKT6aMtB?=
 =?us-ascii?Q?lQyljckB4tM6oUJA8Wh08p2LjoKFBWmOaHZoYJhMLxPeoF/Dnawt7DD1ZRDR?=
 =?us-ascii?Q?E/0w4cfNQ8R/WzZKa5jkz64xkmgJ2ZPzkWSZIFfsGGUN5iJ2hjNtkfcnW1qT?=
 =?us-ascii?Q?i9xSR36KVB2rj70S/XL/PfqoKkz3jV7VycpZcizrR540mGv1wrPqNapQASEE?=
 =?us-ascii?Q?JqUsev7KfmFIROu5Ec2/tiOo2kKmEt+q11qYhs1+scUkxGSe06hLKbWv7YsV?=
 =?us-ascii?Q?Q5L/5BK7DueXZsDzDEnf/iswergKLuQgYpJUyPTA0tLuvjaRMwUqiq/hGo5Y?=
 =?us-ascii?Q?2rtSwEsnke7jSpxKK6t9DC5SHm1OF2vEe7iym68BexMmnCRLpWfGD6Y9lW+i?=
 =?us-ascii?Q?qWiQOI5rh6S8EkP5yyvUpcLmmbeuf9S0CmLbDcYgrAXfsj3VIYDzp2MM2+Pv?=
 =?us-ascii?Q?nSMtdwe1Wk3vDFmvlr65qWOEd/rcWTWCjwKmC8+QnYuUBkkh/JnzyRaTRozq?=
 =?us-ascii?Q?sM/xaEZIdPV25Mm15qUM614SKxvtt7VvIvm5Sobk8qtuDE2WZDy2C+jy7wRi?=
 =?us-ascii?Q?zOjWvGu/plsaH+ARj1BSShiTd8357ohvzGR9DOe7zS02uNbVAKr4hCLpeHdZ?=
 =?us-ascii?Q?77F4ENlNnmbY65f4vVJHfv4JyiJEjoiL75Hs4VQe?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d8f49d4-e843-41bd-342e-08dd2318a1bc
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2024 06:11:25.7465
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lpHkmuvctvNyh4CGsvtQ8opI8m5g9ceWQiByggw8pbnJWOz1FDqqjTBSMbKdj/c+iE2HbpqUVKXd16x6QYP22w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5242
X-OriginatorOrg: intel.com

On Fri, Dec 20, 2024 at 09:31:35AM -0800, Sean Christopherson wrote:
> On Fri, Dec 20, 2024, Yan Zhao wrote:
> > Do not allow resetting dirty GFNs belonging to a memslot that does not
> > enable dirty tracking.
> > 
> > vCPUs' dirty rings are shared between userspace and KVM. After KVM sets
> > dirtied entries in the dirty rings, userspace is responsible for
> > harvesting/resetting the dirtied entries and calling the ioctl
> > KVM_RESET_DIRTY_RINGS to inform KVM to advance the reset_index in the
> > dirty rings and invoke kvm_arch_mmu_enable_log_dirty_pt_masked() to clear
> > the SPTEs' dirty bits or perform write protection of GFNs.
> > 
> > Although KVM does not set dirty entries for GFNs in a memslot that does not
> > enable dirty tracking, it is still possible for userspace to specify that
> > it has harvested a GFN belonging to such a memslot. When this happens, KVM
> > will be asked to clear dirty bits or perform write protection for GFNs in a
> > memslot that does not enable dirty tracking, which is not desired.
> > 
> > For TDX, this unexpected resetting of dirty GFNs could cause inconsistency
> > between the mirror SPTE and the external SPTE in hardware (e.g., the mirror
> > SPTE has no write bit while it is writable in the external SPTE in
> > hardware). When kvm_dirty_log_manual_protect_and_init_set() is true and
> > when huge pages are enabled in TDX, this could even lead to
> > kvm_mmu_slot_gfn_write_protect() being called and the external SPTE being
> > removed.
> > 
> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > ---
> >  virt/kvm/dirty_ring.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
> > index d14ffc7513ee..1ce5352ea596 100644
> > --- a/virt/kvm/dirty_ring.c
> > +++ b/virt/kvm/dirty_ring.c
> > @@ -66,7 +66,8 @@ static void kvm_reset_dirty_gfn(struct kvm *kvm, u32 slot, u64 offset, u64 mask)
> >  
> >  	memslot = id_to_memslot(__kvm_memslots(kvm, as_id), id);
> >  
> > -	if (!memslot || (offset + __fls(mask)) >= memslot->npages)
> > +	if (!memslot || (offset + __fls(mask)) >= memslot->npages ||
> > +	    !kvm_slot_dirty_track_enabled(memslot))
> 
> Can you add a comment explaining that it's possible to try to update a memslot
> that isn't being dirty-logged if userspace is misbehaving?  And specifically that
> userspace can write arbitrary data into the ring.
Yes, will do. Thanks!

