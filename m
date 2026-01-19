Return-Path: <kvm+bounces-68450-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 733D6D39BF0
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 02:28:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2F205300B814
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 01:28:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80CE61EE7C6;
	Mon, 19 Jan 2026 01:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QakuAF1v"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EDC722097;
	Mon, 19 Jan 2026 01:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768786098; cv=fail; b=j++oSTDzLb53/9ektHo9//CMwmTX6fMSZtTUvL12We1WaOwcm7/kV7dRtrMahxQOZ3NDGTlB9MldmVwwHaunleoTUjDiCQvxvVb+9mOwN7HbiLK88PmWF1QfCDHPogD0Egnym7ZjUxdonYQFB1KJEtLSpWucamqL8qOb+t4r+9g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768786098; c=relaxed/simple;
	bh=UzKbl/s/S7ePNqYMcl/KSsRrM6pdhQe81Q0xMj5SO+c=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=O6wD/6k5lRVrjbD5Zo3uMjnb8VyvI8VX3oa8poIdwrl3BXn+zCeo6/BWikJZMyGr2ItJ35rKj4Nao1C0i8exgn5zrF4ZByJ+/c8thmdBP0g8LRKAmnNaIqI6crsNb1eby9GDkPGc4dSGmpOIQOqqrfS1PRSmGNq+FG4IlkMdkY8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QakuAF1v; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768786097; x=1800322097;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=UzKbl/s/S7ePNqYMcl/KSsRrM6pdhQe81Q0xMj5SO+c=;
  b=QakuAF1v+J1cs+m1/rBLHhfXpSkCJN2G1lUkAeWI16t97shAJcdGgb2H
   bfBvd54SCGMEMNaGBHOl1r6R5igzqTi2ankG9G+LsF1Z4PRoGtZ/gF5hX
   oXIWsug2N0sKeGKLfdhvQvtFozfVSN6TpI4su9RJ+8dn31LWPTZkwkNXB
   xbVRMAc1o69UC1oZnZGQ+Uqf2pk78oAIDCF1qEBVMN4QcTni1d1qBpJ/Z
   BOHHaMmj4coNiEJCLUOR5rhkpRq6euwapJD8S+PrWGM58fjQ2BmD4Wf1A
   6GEIOBU/dgqjEBh5EtHoCdOl6Srk+kk/vlrlfjzmiDKlIGKuT8lCfXdLd
   Q==;
X-CSE-ConnectionGUID: 2AOrChDPSOSNVJHyCi8hAg==
X-CSE-MsgGUID: hb3up/ItSAOX7O6F4vUypw==
X-IronPort-AV: E=McAfee;i="6800,10657,11675"; a="92667519"
X-IronPort-AV: E=Sophos;i="6.21,237,1763452800"; 
   d="scan'208";a="92667519"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2026 17:28:16 -0800
X-CSE-ConnectionGUID: +ZzjZkjmQDCf1cLI4fC/OQ==
X-CSE-MsgGUID: LGuMalLlSb+OQBeFS2cA2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,237,1763452800"; 
   d="scan'208";a="209873068"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2026 17:28:16 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Sun, 18 Jan 2026 17:28:15 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Sun, 18 Jan 2026 17:28:15 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.42) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Sun, 18 Jan 2026 17:28:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZSwwXCALouDt1b8K/hg1Ff6z03OyPVYbgt/HoHh4cHD25etFNnCTn7/5wIkGNMIDYW9CIp47HhCWfYmUM2Hhn7UohkNyWXKu4QS0/9P9/qz+0igcXAgvFtetRVmxbroO1uk+QmDHybdiD7B7fFE8sa9Lms5Rt0k/UzO3SXkpO7pWxwq41kSrvWlJJsPw+NmkVZwDkcHTuk1rlMr34Qy0XK4IECNwzcVc36CxMKvlBBilslBxaLzC543hOv9UbKff5Bt42u7fKNeB/Dk3RLTio6tuVS71bBfHceiHQjtoFH2nyiwdMHaaG5L1tZC6gUXED1JtMrw0GpdUXvVMohg8VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lal0L1LWFRFi+ekGwLQV5tNk+swqZqcaZfC2MFUorJk=;
 b=Fi4lfINKB6ccq5hrnVfsvfNoFJUqoxv86kmIsf2HqT6BIU+RwUONlNlTRnMN8gYCT4vGuUriMBuEpii3cHMDznZG9NTh8xYClwZ1hbWTkxyMXYX3GFdn6nBtN7pa5xWY/lKR780bA53tC+ES1WSVJYscD+MPdOVJGVfA61WXpzftW6WV2OF+Lrcw8wKgEgSsHOLK4OSnbzd/riDHOTXHe1+m5w+Kds9U+NraXKcSu2WN1C5ynC8sZWfz2cKuUPslt2uPasrlq1jJcPTt+3GzOvMX/gdjKNbyvpeWjZwStiL/k/pLl/fbDHDywk+i26Fz1fAEVjO6Vmzp7uo+qx1MAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SJ0PR11MB4879.namprd11.prod.outlook.com (2603:10b6:a03:2da::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.10; Mon, 19 Jan 2026 01:28:12 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2%4]) with mapi id 15.20.9520.010; Mon, 19 Jan 2026
 01:28:12 +0000
Date: Mon, 19 Jan 2026 09:25:55 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: <pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <x86@kernel.org>, <rick.p.edgecombe@intel.com>,
	<dave.hansen@intel.com>, <kas@kernel.org>, <tabba@google.com>,
	<ackerleytng@google.com>, <michael.roth@amd.com>, <david@kernel.org>,
	<vannapurve@google.com>, <sagis@google.com>, <vbabka@suse.cz>,
	<thomas.lendacky@amd.com>, <nik.borisov@suse.com>, <pgonda@google.com>,
	<fan.du@intel.com>, <jun.miao@intel.com>, <francescolavra.fl@gmail.com>,
	<jgross@suse.com>, <ira.weiny@intel.com>, <isaku.yamahata@intel.com>,
	<xiaoyao.li@intel.com>, <kai.huang@intel.com>, <binbin.wu@linux.intel.com>,
	<chao.p.peng@intel.com>, <chao.gao@intel.com>
Subject: Re: [PATCH v3 00/24] KVM: TDX huge page support for private memory
Message-ID: <aW2II75JPxv7O+oG@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260106101646.24809-1-yan.y.zhao@intel.com>
 <aWmGHLVJlKCUwV1t@google.com>
 <aWogMveOU4YEpQ4q@yzhao56-desk.sh.intel.com>
 <aWpPMUT4_79QjaF8@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aWpPMUT4_79QjaF8@google.com>
X-ClientProxiedBy: SG2PR06CA0232.apcprd06.prod.outlook.com
 (2603:1096:4:ac::16) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SJ0PR11MB4879:EE_
X-MS-Office365-Filtering-Correlation-Id: e5fb61de-e7e0-46d5-59f7-08de56fa0281
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?yPc/6HS9Ce8FItCj5kLNm4lwrxrEefOWEQVvoWUka+Kfjc+XAvbtYL97Essu?=
 =?us-ascii?Q?5QnziEzp4Wz0Bv5NUBidKzmWs6dtV89icBPZfitiZRBSk8euHR+ZDDO4BxvR?=
 =?us-ascii?Q?OU63nU67rTNq/M2QHVBnjA26jbuABaYGcX5Q+lIiHkThuVBqny/dMsX1iiC7?=
 =?us-ascii?Q?F1UK+vPtEOfyUETkZbrKrrq7DulvdxYE19hEzDNmX9WoqX/s4yTkiv/2v3VL?=
 =?us-ascii?Q?Tee+XeOw7sB2VdhinOh97hYdCl2uDsa8PUyGwZ91AKbfnr9bR7JhkADXYnPH?=
 =?us-ascii?Q?s7tH4VN4DehJF9BV7qId0vN1nlYzQ3GXIsSx9bQ2Twcjl9EuZZcqfiUrwHM5?=
 =?us-ascii?Q?CnHZuiWT+zi2+ciUi0GBmm4FEwj+vLGpvIcAXW39OhtLWf8McR3grQ2UFlg5?=
 =?us-ascii?Q?aGj1VAisfqQ2UIWfHYxxSluuJEXrDNqb3j7NFPxSLupeLgqAAQRviKwD/MOd?=
 =?us-ascii?Q?IL78jb2gKjVupJW8Ni85rA+QSKirXF97Lqr64OR/0/eM9ZN25u4xfDt3FM/j?=
 =?us-ascii?Q?OSGmwuuTjbTy/U7lpHcQ6ixtEc4aVC2g80MRfZ6u0uHU1ipi5ZcXD0G6kexp?=
 =?us-ascii?Q?hLCwvmJF9V2YNow5UnaqZKEN8k0Awdz+TgPmqltIY3EU6XCUmr90KEKCrs/e?=
 =?us-ascii?Q?q+yXihZVX6MaY3XiRxQz4Ni26kJiFe9ZIZMpfx7BPIyrV+EEkLtRR/K/0QZm?=
 =?us-ascii?Q?+mH5eP4S9P1SZr0t7Wt5HTev0tn8r/xnY+ItTP0VuOFDZVFCt+RAPbBx6siU?=
 =?us-ascii?Q?yQ8HCg9AN04PGhDicab93q5qZwY34dVVHV4XKRnUZaHkXeD/7uS9aRIWuulS?=
 =?us-ascii?Q?aDA1TxF6q2UMUBgmYS/sgFoQYrtCU4VWufWoPAJ3O14VgmOskOOEfAioVaPZ?=
 =?us-ascii?Q?nSF88N3Amz3fjj7cecELrAW4Trdh3ex/E+URELI0ZndwnWZkIRIOkJRCQLEW?=
 =?us-ascii?Q?XMuHBNeboCkrygK0itRJrhjbSaAqy3ZlunsxT8qze7z7i2jJDlX980whc0OF?=
 =?us-ascii?Q?tDjM3+nIptRIIm6jHq7yXHQD3dNb4OHfP3HtHM7g53GUlhllomsIqXvzNuhG?=
 =?us-ascii?Q?BaQVA2cPgd+ikUtpC8Numzc8uUzZxcppQkBumeJMj50fsgBIjodaIEH4E7bi?=
 =?us-ascii?Q?rGZJ56dIQ2C+1IlNL9SC9c3ziZT+vhmrIPgexyY5rU3S3iffRkK35xTAdvh7?=
 =?us-ascii?Q?N7kTsl9aZRvOeiorm+nhTRh9zsKochS8bn7A4/Q+AWe8mlNGS3WXsuaKi66q?=
 =?us-ascii?Q?H8u9aexjrPPvaUUjWbUL4mKx1eHnnUCBpZTRaWjDDgXqH/XnKc3At9l/1FoG?=
 =?us-ascii?Q?FzgWLw/bpqRE5PQS8gHbvpWK4Eow8sVxopSdVXfH/JmkCI4fVvBhaeH38fjd?=
 =?us-ascii?Q?QseugXhunfSlr7ICIRpPE++uwhlwIwIhh3o2DZ5DO55SdMhGpKj4Z5IDnfO7?=
 =?us-ascii?Q?qiUvVQtAVRrwTEoCN8vQO1g+JSN+x55X/AFgCdR7TCSiQOpKcexYTKFTlILt?=
 =?us-ascii?Q?MyQW/hLgYnbJSoBHAv4C2e9xBWubbjct94Itnc2DsLRXNygMvdqkYdrIb21r?=
 =?us-ascii?Q?Mshoe6cZQg7NTUvOvP0=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eewUNli1cGMaZ+zVCuQu0rrHZoQf4Osmi1BLiY4L4DwvnMIscxk7pHlCEeQZ?=
 =?us-ascii?Q?tRd0RWtI/+cN3V7OvxhckZoP6KM8NggZ/ISsFrajwKinVdbPITGSJ6AIBuVi?=
 =?us-ascii?Q?weD0ajnmMZxZlZSzcRZsjuGcHP4s7dt9QKO+YssRWpjTtqkgFue83h81XvAm?=
 =?us-ascii?Q?yW1z9Kz3BoyTPjwti7zzofj8kn9jI2x8Vivddp/NsIF9Dt88D3+wnjz/chfR?=
 =?us-ascii?Q?IU46wQUdm7g+2C1QuoofFZUENujnbBgbGVZ05dlDZmKm9xh4eq6skKIMiUfT?=
 =?us-ascii?Q?pZp++NNKVT3lkrL1uG/igC8uWtroIdhd/LM6qpoXPT5/Q24i4w27JjQx6XIH?=
 =?us-ascii?Q?PouAGpfGpnvo8bJb3UA4PSUGq6lsCERQeUhFb2Ig5hqHzQFxLOsZkxG+QIhO?=
 =?us-ascii?Q?1sXTOkBVhPkGe6m9+SY/N613ddKAhp84Evayno/6661fnXU1Kt0/12sZgKOq?=
 =?us-ascii?Q?XyqRZhUYt51hwpZsfhP90cCTGasuB+n9mSXOZ9gPBkEzm8i8l5N8iqsVyrFO?=
 =?us-ascii?Q?vGi2NZUWVM5wyUvjwuBxMlp/eebZumoHL+mRInhfdABCJUFi6wBuGYGWeeq9?=
 =?us-ascii?Q?PRTHgze6FdSx5xwb7bLqxq2vpVaXngkl5FcbiKOw4j80SOxCdDmFTfO82BoR?=
 =?us-ascii?Q?79W5KAczRZCCTdZr/G5agU6O0zQuHYrfvkno+VfeA061BnylnaUrSq+JB9IH?=
 =?us-ascii?Q?Jm7G1J/tGEx5zo8nnpXyJZpXfXjhmBMhyvxXF3EbtSfFTSDUMJo6HhStL6W1?=
 =?us-ascii?Q?vjD4wkzzrhahVMG6vybNrsJoWSWw6zrcS1pRUBjx3TbpZIryEOQvdf+w6jnv?=
 =?us-ascii?Q?4af0ec3d1iQW+89fNaUqYwq2FLx7xsNPNEm3fBjwy5wcXE/fsh+oekqnpR+n?=
 =?us-ascii?Q?1WlOzEE0GfnaR52AaXRo0smbKkj/utgbjvw5NHkIylXLx0CFSdAql2N2tyF6?=
 =?us-ascii?Q?T9217js7i6S8s9I6Z5URMChdxIaciNYLczuv6Q6ghXZpUgYydhNLACwlNVrz?=
 =?us-ascii?Q?TMYfggTBFlBjVe7Qg9hEkE1zsKUDtdT2yOFfkX9Sq3ceqm3EPvXDD6+9Wxn7?=
 =?us-ascii?Q?Ns4w39OIzhzuv/Bg+62WxYLh8+5xL0FEpqeyGwEiHOaT4EElFqiWkKGGf2Xa?=
 =?us-ascii?Q?jUW3vEP5uAmdrMW3btTlLeELsnJF1EscvyJw/OD+Q2OGhj2aW3rmzEDb3tWE?=
 =?us-ascii?Q?ekIv/GMos64EJX8kz+rXDkNHRto4XlC6F4VfpQxCy8/DCB6ciPJnlfRlWA6q?=
 =?us-ascii?Q?kPXcKJAv9mfrmgg7wMRmPxEQoCk7TpgsvCoadJU9fF+E+hIPjsdn+tilMwFB?=
 =?us-ascii?Q?Lva4SZ5sHKAKbOToTNso2cB6r0zmUeRSTyYBga2JOHW7OeVg+/xOaPPWR8fQ?=
 =?us-ascii?Q?eknBNqHnk859NpYbAPyLoHuW91UoEKyYRz0a1o5kjOR6mAvG89D9degh4uAU?=
 =?us-ascii?Q?nXMhp8YEchSqu8+czNiS3fYHWuhxD2Rn4oI8UYY3OyjIMqlF9QAG8+WC1MuL?=
 =?us-ascii?Q?Xu36TYbbpZ7pnzQG/lVWgMcE3w+mj7Y0ddPnODxj3Yk2L5KyOJkzfJzRRazi?=
 =?us-ascii?Q?wSK4EYlut9V6pITiRT1NWNQkaZ3bBV2EbYEBV0A7uvxMMdgppttc8AKAYJOt?=
 =?us-ascii?Q?+fL8fFbdp9s39TpEd/UjwIq9gKoIm40PJQqVFmF8a4SCi6N96pWF3Fo3hRB9?=
 =?us-ascii?Q?e/GvN+XwK3PeIloEAI+u6SQF8zd1Wq1C0WME+7AkB+S8IM6Ext48aZFX/7AM?=
 =?us-ascii?Q?GAq+q1zSvQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e5fb61de-e7e0-46d5-59f7-08de56fa0281
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2026 01:28:12.0186
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YQNihUB6ZAUgVx9FwGEs7bFmL7BFEpezjQ79EoLzOlicLOeshWNH8mWWHjEGhBdBmvtohnovL4Z5r0Mjh5FpcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4879
X-OriginatorOrg: intel.com

On Fri, Jan 16, 2026 at 06:46:09AM -0800, Sean Christopherson wrote:
> On Fri, Jan 16, 2026, Yan Zhao wrote:
> > On Thu, Jan 15, 2026 at 04:28:12PM -0800, Sean Christopherson wrote:
> > > On Tue, Jan 06, 2026, Yan Zhao wrote:
> > > > This is v3 of the TDX huge page series. The full stack is available at [4].
> > > 
> > > Nope, that's different code.
> > I double-checked. It's the correct code.
> > See https://github.com/intel-staging/tdx/commits/huge_page_v3.
> 
> Argh, and I even double-checked before complaining, but apparently I screwed up
> twice.  On triple-checking, I do see the same code as the patches.  *sigh*
> 
> Sorry.
No problem. Thanks for downloading the code and reviewing it!

