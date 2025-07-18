Return-Path: <kvm+bounces-52854-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E0297B09B04
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 07:50:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 26C575A5B0F
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 05:50:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91FC11E5B94;
	Fri, 18 Jul 2025 05:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W8FdWXzn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB9DA930;
	Fri, 18 Jul 2025 05:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752817833; cv=fail; b=FwnNCa3I4s9IqgULxlZviqnEZSZL9f8sTonKb97FMUQDogbr14UbzB034PSNjFOTaWURjfkZV+X3IjuenLYaz5CocTiBxI7d3XtUdHcQrmaNrXUhe4vG60yDNFnIkVusCB0OGmtxmVVOnLzhmeDYfMfx/NoF0GpZ8bJUtPu2SYA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752817833; c=relaxed/simple;
	bh=VI1h2A/XnaDgQEfxGKSv7WEIoMC9taT/tmmbSFQspfA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=VV7Eeae0yit9f2wQQBSPW5NXwL9r0MS47+U5vNNZZfNrXC/shtuQOvgNzpDkM3LC+6nhFMVA5/85GdZophqKyqDpV8fg6OOMKCsy0zlsWVLnLHOEaZ9xqpytTLGcVlRAoJhtdUhGP69sOn2NNcP2C0TWtIRuszZM8qXaGUXdyAk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W8FdWXzn; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752817832; x=1784353832;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=VI1h2A/XnaDgQEfxGKSv7WEIoMC9taT/tmmbSFQspfA=;
  b=W8FdWXzn+BQijz0rdGpa5XsKcV/0Sc3QWX3gdsj4aB/M4HRYYWVu0HuZ
   IFx2toR46bIIwN1QU7ajNQaM5FPjDaa70A8U8M8FMxXnxH1lnXww4HkAN
   FepgiiZErICXfjOwhDnKRXsO9S/+AnxOlmGQpasYcTGkJJHWWUusuMi+w
   JRWhlse4c3ULT/p8AflRuv/mTTyMVsMxCS6F0VBiRhqI2YmNofJpuqIYg
   f9IU0hE4Jl4Xl0SejkMvHKBI94XJiGmFx8WbL0K0wRz06XN9+gRRU/Z/W
   0DgUMCYs5jDEBJz3JtfVX4P3MulyQbMiz9zv3H40YHERLuvjgRuaI4Id4
   w==;
X-CSE-ConnectionGUID: GnCglZv3Tr2/Md2R2z+HIw==
X-CSE-MsgGUID: Ch3Q6mrQTqma7rHdnJFRew==
X-IronPort-AV: E=McAfee;i="6800,10657,11495"; a="58918238"
X-IronPort-AV: E=Sophos;i="6.16,320,1744095600"; 
   d="scan'208";a="58918238"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2025 22:50:31 -0700
X-CSE-ConnectionGUID: 8Vwep77oRjK7IUjQDeWdIQ==
X-CSE-MsgGUID: VPAmV/XPR2OlN2sYOELjyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,320,1744095600"; 
   d="scan'208";a="188931693"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2025 22:50:30 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Thu, 17 Jul 2025 22:50:30 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Thu, 17 Jul 2025 22:50:30 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.81)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Thu, 17 Jul 2025 22:50:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zCCsRueU6tp3F4+7RJSV3gz2VqRj3xx7r5ARxLkYxc64sGCpbI1TmkJGpwHCG6hWMnLOwhLHOtfnAyUK8TD67OSv+R/fWptHPo44zcCtlZEjsoTNvNfS5WI1gzpvagarlm+Y0Xt422EPObDbucRUzPmBy9M3ofIHIVFCTShlzdrd7i9Laghxjz99AOFnuHBDL8O9KcWgxtFz/mH74EirDRbU6sEQU+RzFnKLylSNoaPXQ5RjQr2AutaQdcd39CvR0DeQLJaHh+rwQCpAmOXIDJQfQR4ada5QX9WHCxS41phJEV9ujghg25SJZs03YR3bFrIlXuNbegS3lowXozWSDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lyYGjJpkdaH/JQ9GiL/pLIv/vsRHXeoC8nh4hQ70tlk=;
 b=O5gUzxqBcIbUeBRIhRbC4aBu6jrLldQwZoRKDL7QeMHz8PGPYfUX5d+Y70WUZL8/EMxA0J1enGG2OlNv5etD5pF8adrlldCH63dYpDf7tMnpLIv8iFUzXcljCpmPvq47IlErL5XwTtUvmlLXWkiNNabnGmmFMuBlqk5ilnHwbNVevzSjl7tEKEkvLH2iX/MjyJaxFRSMEfA9lil7pu+8aesYtlg4qK8SE4b8QJOaxtaW/WOomgmoUBO8c0McOXDtf05xsEtgptPYeoL0GDZb5fHAUd0MXdxhcgWFJ2VH+iTO5QgXGkF28Rjq44FJTjvkfPrLeAf9PePrYDt1lFEvVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SJ0PR11MB4976.namprd11.prod.outlook.com (2603:10b6:a03:2d7::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8943.25; Fri, 18 Jul 2025 05:50:26 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8922.037; Fri, 18 Jul 2025
 05:50:25 +0000
Date: Fri, 18 Jul 2025 13:49:56 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Ackerley Tng <ackerleytng@google.com>
CC: <vannapurve@google.com>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<rick.p.edgecombe@intel.com>, <dave.hansen@intel.com>,
	<kirill.shutemov@intel.com>, <tabba@google.com>, <quic_eberman@quicinc.com>,
	<michael.roth@amd.com>, <david@redhat.com>, <vbabka@suse.cz>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <pgonda@google.com>,
	<zhiquan1.li@intel.com>, <fan.du@intel.com>, <jun.miao@intel.com>,
	<ira.weiny@intel.com>, <isaku.yamahata@intel.com>, <xiaoyao.li@intel.com>,
	<binbin.wu@linux.intel.com>, <chao.p.peng@intel.com>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Message-ID: <aHnghFAH5N7eiCXo@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <aCVZIuBHx51o7Pbl@yzhao56-desk.sh.intel.com>
 <diqzfrgfp95d.fsf@ackerleytng-ctop.c.googlers.com>
 <aEEFRXF+HrZVh5He@yzhao56-desk.sh.intel.com>
 <diqzecvxizp5.fsf@ackerleytng-ctop.c.googlers.com>
 <aHb/ETOMSQRm1bMO@yzhao56-desk>
 <diqzfrevhmzw.fsf@ackerleytng-ctop.c.googlers.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <diqzfrevhmzw.fsf@ackerleytng-ctop.c.googlers.com>
X-ClientProxiedBy: SG2PR04CA0152.apcprd04.prod.outlook.com (2603:1096:4::14)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SJ0PR11MB4976:EE_
X-MS-Office365-Filtering-Correlation-Id: fb460c80-972b-4402-4183-08ddc5befe42
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014|13003099007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?k+/rJrTO8U+haQoA64FiGn018JfhWyE1mP90LqosO1VLf6YQnex7UooUSVK8?=
 =?us-ascii?Q?an7NsYHSYecYBQARUH6/pOYyY9wYx7TeDwzMx11kzqmpYgt+BBK7HjSKUlzd?=
 =?us-ascii?Q?apsasjcDmKbxLMg1z5StYKDHrpWV+sA1dN4MEIl/bhzgmr6mv7Fv4ve0PMUD?=
 =?us-ascii?Q?Nmn5EmXsyN+6qR+vu3OKDNNl60i8LbDFUywi/7uodHM7SRX/1/eW9NOjuVK4?=
 =?us-ascii?Q?54N3OHkOueMtmyLaGPOmWF6GPzeba4A09Mq62GHucLsBBQqphyfHd1GBaJQR?=
 =?us-ascii?Q?W9XcLL5RDSM1DD8RdCfSRPq7Ud2Ky8pWMiYbHAQuz9N46lAm5lBPFDK7hBrb?=
 =?us-ascii?Q?c13VViHeMTezpOagPOVY7FtoQ4qlCUZtciwox7mNsaa6s5k24VMJTcUtM4oC?=
 =?us-ascii?Q?6tSkFyAAbem2UOE9UNgoTadkI2mfPZE1w5K2usEKqFeHXNtViFd4goZBlVxB?=
 =?us-ascii?Q?tqxCoDq9XUbqygP7m2RPFZ1oBcc4Nke3xtYGDwXLi4wIgYr2F8ks3x64Hqda?=
 =?us-ascii?Q?ZP1UWm9AQYQHggORYdbo3PP+X1b2nBTYuCwGN4wStrUDkNM5gy7mJF/SYLeb?=
 =?us-ascii?Q?lPk0zLpk8MoHDzpUsbWTOiLS5FdKMHE2hzvozlEf56+TrRaOcpPFKP2M674c?=
 =?us-ascii?Q?2fuCZnlswXm6Ey0gkMk+qi+bB8aieP/+VmWzDrGPeMh+4Zmg7+nVbH0BikOe?=
 =?us-ascii?Q?fvPe6irDEdkhpXqw7L1mY+dsoJSgXUyURbvF6jinovVaNNpbVrsSQDn6wTTk?=
 =?us-ascii?Q?JylgazsPJ/bLJ9lto7Om/6bB8iZAoh5msJbiRtX7x1tK9Ej1YX+2+9buqn+K?=
 =?us-ascii?Q?zpRBA4UGaPUbMnemFG9upOd631NbnIcc/aQh4xduFhy0/+EvARFPVWNYpp8B?=
 =?us-ascii?Q?zJ53hi/jqB1f9VQxiZ3GuIsDY1trsNRDoMcvnysh94Ace0ZY5GhucWkUXG+X?=
 =?us-ascii?Q?nu2yPT6QpNIfRMFP3LeIC9XCP9tIog6PjKYSy8FAwWTDXNHvDZ6PEwQmYeEZ?=
 =?us-ascii?Q?ponFGgGCuYn03VXFTJa4Xvvka6SgkwvQEiCjMYYq+6gs4FAhB8KhtzHYNvAP?=
 =?us-ascii?Q?IuN9FNsspgconm3GJkucDRG6ImfSv+0rfQgxgrzj484z4KegU+FIPrLuM0Tj?=
 =?us-ascii?Q?p8uayxhcdGpBne1w3J+xQWEOsQwYzDnnoTt9RQUjJh/59Zysj6EOv8EqcYaN?=
 =?us-ascii?Q?/MdK8Dw1x4kRfZmONeqi/fkyhtIiTmGxK4PhkeW5VjqprSRZXjiFrXHpRe7O?=
 =?us-ascii?Q?D1c7SRZsWFZcDyWt09U/+0gFtxc/OuIaCYbtMRyIcIQJuvWTtwtYCzj12TdQ?=
 =?us-ascii?Q?IY0YOAzHtNJZ4DA+EyYw1p+ypXx0o1sK13FbUpf2NI8W4QsLhhs/LuJjQC55?=
 =?us-ascii?Q?NUbj2Dw0XG7uygDrHksEKfmAJl5UMrLW32gdfRDIkqEZChxL53zY+9s0Qb7x?=
 =?us-ascii?Q?bSocvq0pK0w=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zdJ+avBolPTyqItorhnEdiUBsoySPols+sCIYTeyMpTsoIbGahG1IV3we9I4?=
 =?us-ascii?Q?xs3LX3nqOh03UvFgs07sP9hWXj2aZu/utN8Dshg7afVgNrpi9F9iPBpx3/t+?=
 =?us-ascii?Q?a4CTuxzq5lI5Irz+I72AYhkpl6NhTL+aT2hzQkLdPkCpxKMtp1frt2a46WvI?=
 =?us-ascii?Q?dCmrxH3FKMcGrPuY3x4I38ePkdLUewns+itefQYgaEk1oixQljtKF1OOzImG?=
 =?us-ascii?Q?vEJ1U/E/p4XUixfUWHLxYRssyrz9yozkttDNRpsLlzu4cTUx4taDKCDiv+M+?=
 =?us-ascii?Q?2RvYhc/1CclT/UfrSHViSBh9tKIODC87p4ICGMADq1xxIPi2ai3y7XY4McDI?=
 =?us-ascii?Q?vjOhA2TaUAe4n9F46WbqNcaJaJfSVoqt2eL9udlvRmwAMjeTxfSkxiNJT05O?=
 =?us-ascii?Q?ViJIqKHmBmDjCkjfx5uwqkBjbzNSaJH/ZXA5DgB9kAz0qU098nxloRwrT+1p?=
 =?us-ascii?Q?+0HQgJe9VDDm0i4gr2dk9TSKzXZuPXoHosvXLCDXWAMNlWHJQtgtI5rUO/Uq?=
 =?us-ascii?Q?xHHELlhaLq3DryxMU0IKk2N5AT5nifq68bBh7tf7e71NrCD9HP6tgVYbpjBP?=
 =?us-ascii?Q?5KOMFJtxjJS9nSFuH+ke+h3Sapo0BHIGdANv2/zeRsiEQd74Ujh73GGiPQoP?=
 =?us-ascii?Q?3xYfL6PndLd45D0VwOwbNuNwyOgEsv728m8zChA3OHkhsY5X1Vpdc2Qbnve3?=
 =?us-ascii?Q?XENa6JWzagoMesTrYvEcqdI8pDsJzm75pCPyw+bCggIFYpm0aVyWAeGlTjKD?=
 =?us-ascii?Q?s2fwLDfIP9C1IjpN6Sf2NGizjXlV4jBJv8tLbT/PZcOFO+UnRAfvZcgVVsOL?=
 =?us-ascii?Q?2qSsY5Thp5pbFV9zI03dU7cm4wSLyhSc1RaaP7iQHpsPpwTYfDffVu8BUehc?=
 =?us-ascii?Q?hGLf4Q7AcY1pVFl/n/WGwQnBJtaA/xvRBPaHdB0OaL/cCrvWWgZKtAyr0UeW?=
 =?us-ascii?Q?E4TA8vdxGKiO1bSijjArDie/ivo6iKO9MaR17rO8EUyZRAnT6Kc48G7AIFIG?=
 =?us-ascii?Q?IV4RdWcNFTaM0e/OtVBuzSb50vzfo9EJZXX9JVnFTDCb9j6L6pxhmX2olW0L?=
 =?us-ascii?Q?ulQocl3la7hQoLS3qUJHL3s/gNhfDBEtVPLGMb/puN0KERa9Tfd2bjmxjGkc?=
 =?us-ascii?Q?mjtlBgiERqCijNhCdy0eGUsiOV8wai+bGgNgQNxVBgk1g4vu5O+lSmWMeJl0?=
 =?us-ascii?Q?nvqMJROaF41/FdfxOvFxsIE3kdf/qb26+07IC10fFgWf2AvNPSi7Hqzk+25O?=
 =?us-ascii?Q?vMyqt5nK2E129LZaesF1WKkfbDSJWB2Au5feOeH5TJQUCMzsW1BwKcPGIjCR?=
 =?us-ascii?Q?OhANNsJ+iSf555Y9h7XSsyI6v5T8pMwZ912yna/4GVJsglOzCOL6a/oc5WNG?=
 =?us-ascii?Q?UBKcjfzWH/I8rgw+B+CE4ad24OcWoOD7R8lnZ1U0uY3JMLtKguVHhyY79nOp?=
 =?us-ascii?Q?EBwwD5yJIyj3s2GipgA7isCsDTHjGsF3G1fQbr6J0rg2/vOZ+UX8MdH00bJ/?=
 =?us-ascii?Q?+ZdvD+nWLsN5aI3qXM2Me+OX1e8nv1fwG5v7UdP9qSM9H1aHLEtls81WQOJG?=
 =?us-ascii?Q?1dsp5+oH2xv0nfzPtXML7RfjEgQ9XLrSFLc2pOOO?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fb460c80-972b-4402-4183-08ddc5befe42
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2025 05:50:25.8706
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jUcJeotcpjKHiCOeWTqJiw20kWJ5hMAqRnVtTxhiS6dqwc/Y9RhVdXCJhNigE2RGVMvkKp673YB3uVKneJy7Yw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4976
X-OriginatorOrg: intel.com

On Wed, Jul 16, 2025 at 01:57:55PM -0700, Ackerley Tng wrote:
> Yan Zhao <yan.y.zhao@intel.com> writes:
> 
> > On Thu, Jun 05, 2025 at 03:35:50PM -0700, Ackerley Tng wrote:
> >> Yan Zhao <yan.y.zhao@intel.com> writes:
> >> 
> >> > On Wed, Jun 04, 2025 at 01:02:54PM -0700, Ackerley Tng wrote:
> >> >> Hi Yan,
> >> >> 
> >> >> While working on the 1G (aka HugeTLB) page support for guest_memfd
> >> >> series [1], we took into account conversion failures too. The steps are
> >> >> in kvm_gmem_convert_range(). (It might be easier to pull the entire
> >> >> series from GitHub [2] because the steps for conversion changed in two
> >> >> separate patches.)
> >> > ...
> >> >> [2] https://github.com/googleprodkernel/linux-cc/tree/gmem-1g-page-support-rfc-v2
> >> >
> >> > Hi Ackerley,
> >> > Thanks for providing this branch.
> >> 
> >> Here's the WIP branch [1], which I initially wasn't intending to make
> >> super public since it's not even RFC standard yet and I didn't want to
> >> add to the many guest_memfd in-flight series, but since you referred to
> >> it, [2] is a v2 of the WIP branch :)
> >> 
> >> [1] https://github.com/googleprodkernel/linux-cc/commits/wip-tdx-gmem-conversions-hugetlb-2mept
> >> [2] https://github.com/googleprodkernel/linux-cc/commits/wip-tdx-gmem-conversions-hugetlb-2mept-v2
> > Hi Ackerley,
> >
> > I'm working on preparing TDX huge page v2 based on [2] from you. The current
> > decision is that the code base of TDX huge page v2 needs to include DPAMT
> > and VM shutdown optimization as well.
> >
> > So, we think kvm-x86/next is a good candidate for us.
> > (It is in repo https://github.com/kvm-x86/linux.git
> >  commit 87198fb0208a (tag: kvm-x86-next-2025.07.15, kvm-x86/next) Merge branch 'vmx',
> >  which already includes code for VM shutdown optimization).
> > I still need to port DPAMT + gmem 1G + TDX huge page v2 on top it.
> >
> > Therefore, I'm wondering if the rebase of [2] onto kvm-x86/next can be done
> > from your side. A straightforward rebase is sufficient, with no need for
> > any code modification. And it's better to be completed by the end of next
> > week.
> >
> > We thought it might be easier for you to do that (but depending on your
> > bandwidth), allowing me to work on the DPAMT part for TDX huge page v2 in
> > parallel.
> >
> 
> I'm a little tied up with some internal work, is it okay if, for the
No problem.

> next RFC, you base the changes that you need to make for TDX huge page
> v2 and DPAMT on the base of [2]?

> That will save both of us the rebasing. [2] was also based on (some
> other version of) kvm/next.
> 
> I think it's okay since the main goal is to show that it works. I'll
> let you know when I can get to a guest_memfd_HugeTLB v3 (and all the
> other patches that go into [2]).
Hmm, the upstream practice is to post code based on latest version, and
there're lots TDX relates fixes in latest kvm-x86/next.


> [2] https://github.com/googleprodkernel/linux-cc/commits/wip-tdx-gmem-conversions-hugetlb-2mept-v2
> 
> > However, if it's difficult for you, please feel free to let us know.
> >
> > Thanks
> > Yan

