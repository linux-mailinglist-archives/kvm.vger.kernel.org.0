Return-Path: <kvm+bounces-63196-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CE2E1C5C433
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 10:28:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E52B1422C80
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 09:25:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AEDC304BC4;
	Fri, 14 Nov 2025 09:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l5YI6utO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC6328727C;
	Fri, 14 Nov 2025 09:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763112248; cv=fail; b=uMxZLvp3+Rtf0eLCEqCTLS4e/JkauJKBk81+q2lJ+8qXXZX+tKkrRZHB82AWd9ERBY6IZBxcwURrZkpOfspeLj1rf/sC3UGbKlw7NEEIR+VDlN4zchjY98KoC/5GcvnlO9rO2bBs0YgpF7cX10Axm6XO8MA5vzynTLkncbb/zCc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763112248; c=relaxed/simple;
	bh=MuE2EHnw9YKa8hV6VqFJfpX2JOHt42XsCH/3ADXFxMk=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=gX12LkFzYU29Op3tzP9UKwFPUMFp8hI0zK2Nk5GLHk9wz4sCHY8ygj31wmV7U2Z2oc33gnxZwseQhIA6uUjeobAVcFa1YhBrxqHItC+tuPjqIRfbSZNTjN9kqNBdFG9FF1GllL6Ee45jkBWq5E29x80xae1IBTPkmI2N9sQRu3g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l5YI6utO; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763112247; x=1794648247;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=MuE2EHnw9YKa8hV6VqFJfpX2JOHt42XsCH/3ADXFxMk=;
  b=l5YI6utO67+9UtfMloCh2Zg0ESJcAPxJhTxDPQ7TNfwm6AnprDut+Pks
   vClc4YnRohc0zFB2KE7RK4wpD8WDGW/5qjbpKYP7+N8X0yVli0bL+Gaq2
   JBLkdTy72wcsPBERN7a/iv4jvq9lqTdhTxy0VKXmrR6H0rGkda0c0fkNb
   5pHRI4n3HGgh8jEFjzQdd3KmvbBrryVsc059W1J7xzEDF3+zpVuQNB+ra
   xL2XQwzp4tKc5q/1vdxoDClBVL3seSrCGtr6lrJI0L5xYm9+/Zoqw1BVB
   JYGx1vVDo9GNVqkhJnnz75M0EBYcxvPkSeOMilu2Nrd1vASloMRrh5YI5
   g==;
X-CSE-ConnectionGUID: 1uZWfT/JTQOJJ9nPp7MwKg==
X-CSE-MsgGUID: d03BekKMQEKDvE9570Bdow==
X-IronPort-AV: E=McAfee;i="6800,10657,11612"; a="65108472"
X-IronPort-AV: E=Sophos;i="6.19,304,1754982000"; 
   d="scan'208";a="65108472"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2025 01:24:06 -0800
X-CSE-ConnectionGUID: q1GuJIkeRoiAGuAP05dq7g==
X-CSE-MsgGUID: Edx+YbEZQSuqeVoteM2cMg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,304,1754982000"; 
   d="scan'208";a="193849950"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2025 01:24:06 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 14 Nov 2025 01:24:05 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 14 Nov 2025 01:24:05 -0800
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.22) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 14 Nov 2025 01:24:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DvGxl7rCD5zz+YZiVqlDVREfrBZ7TG9AjOzPtNHwX8+c2T6+rQF/UCkxc+APL5a7H0dvvcB5dHSlTmH1LMqXiJYrtkYDYoWuc68nPHYgnbOuSmQKJrBfOx+gjlCtRJaBAQvvLkgLUBvp4R0YcQjx5Efgyiziok069f6wy3vb1xTHzh6lKHnoi8XV501zHG+86rCUJMulEGLyEe8MpEWTAwd+ijDXmEYq0elUk/An6knsMNuPF4QxOtPd88S8YAWjR2hwHBeuLd3GW7DIjjVWPPoiExwi0Xh17lJbK+C/38M0YATKCDyBEo8knHcNbsE/0iblWBtHwmQS1gEx+L8KNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RQF4ddlx9WTFm5kNZiJ/JD5k5Tc7QAivD6Vjm5kOnxk=;
 b=n8rlrVMwmZTIzKh/uZo94drt/5RMtZ22hOt0QcTuU6raKJnwtbPDz10QVrqNT2UYo5eSepB+LTldfjGkuonDAl5Tk+fR2bSaHLKq7/yDe8bZbhy/J8gmPxk+QPX3iDvVSnXwRiVu7KyVpwH9d0+RkMd/Bu+c+iJHW3hbZwFVwmfwPhk1PSJO/9A74at6s/TF39d9ma94VcpZ3JugpzUVrsKgplS7XloT9vJ+HHoq3Tl6MYerB9wivhBIGWd+c5fJpZ+RSl93z+Ot2C94nZ8C2gjGXb1Z4wH2+9X6hcNYLckVYhp7NRawjRyALlArAQG7JwlOKgPvxQYCPGw3HB1Xmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA0PR11MB8379.namprd11.prod.outlook.com (2603:10b6:208:488::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.15; Fri, 14 Nov
 2025 09:24:02 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9298.012; Fri, 14 Nov 2025
 09:24:02 +0000
Date: Fri, 14 Nov 2025 17:21:55 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
CC: "Huang, Kai" <kai.huang@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Du, Fan"
	<fan.du@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"tabba@google.com" <tabba@google.com>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "seanjc@google.com" <seanjc@google.com>, "Weiny, Ira"
	<ira.weiny@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "Peng,
 Chao P" <chao.p.peng@intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "kas@kernel.org" <kas@kernel.org>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Annapurve, Vishal" <vannapurve@google.com>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "Miao, Jun"
	<jun.miao@intel.com>, "x86@kernel.org" <x86@kernel.org>, "pgonda@google.com"
	<pgonda@google.com>
Subject: Re: [RFC PATCH v2 02/23] x86/virt/tdx: Add SEAMCALL wrapper
 tdh_mem_page_demote()
Message-ID: <aRb0s2/t3NFg25FL@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
 <20250807094149.4467-1-yan.y.zhao@intel.com>
 <281ae89b-9fc3-4a9b-87f6-26d2a96cde49@linux.intel.com>
 <aLVih+zi8gW5zrJY@yzhao56-desk.sh.intel.com>
 <fbf04b09f13bc2ce004ac97ee9c1f2c965f44fdf.camel@intel.com>
 <aRRAFhw11Dwcw7RG@yzhao56-desk.sh.intel.com>
 <9bcd2857-e688-49e7-b3c9-7fa4bbf0b3e7@linux.intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9bcd2857-e688-49e7-b3c9-7fa4bbf0b3e7@linux.intel.com>
X-ClientProxiedBy: SI2PR02CA0033.apcprd02.prod.outlook.com
 (2603:1096:4:195::20) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA0PR11MB8379:EE_
X-MS-Office365-Filtering-Correlation-Id: 9649dcad-4d06-4499-d65e-08de235f8ce9
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?gc8M1oGRPk+gYfs4W+fVQvhSMFshXHB++LTyYNtuoCK2oKSXdmUHi9fa6+?=
 =?iso-8859-1?Q?l8t/nQI0ZfMThZgnlMoCDheXjcSohKYHVTQ6kYamqvNwd2MlwZqrQDIwJO?=
 =?iso-8859-1?Q?tufhEKxbiE5var3VSi1ZCHdPn0vnmOenwvjuSJvmr4RJisrZGur2Firlrb?=
 =?iso-8859-1?Q?wWC9msZvd1ztUPSfCagieGNR0g6GrqCjSpdWvnkgABnW09yfUjFpd/R+3Y?=
 =?iso-8859-1?Q?FNDL/ptzGJlXithAZc7eWJKqbhENvCeI71LrpIip0UYreiGm0dp8RhRWkv?=
 =?iso-8859-1?Q?MAiX2rqHO1CqnvgkAXdTbVjLFyAYATOI7JzebwgMcEpwwiu+v2Obs84JmL?=
 =?iso-8859-1?Q?E/ZYHbQ2wbY/Rmf1PYaCvZf54UyLbPi/DLcFm59D8WXDzjwegj1kIGffNy?=
 =?iso-8859-1?Q?ZB8H9++QxY+Y0bsGChP3jeBe0a1P2YAhVbRHyWKoRbYGJXD1NMtIsILgbx?=
 =?iso-8859-1?Q?f5877KLMDeq5jBnD6S/RPVMvWBtlFQfkkQE4VI7odTcCWzV5TLBb++NXb8?=
 =?iso-8859-1?Q?5HyKUQAoiIK67/W8XlKW42ZIqR8wiAi4t6cffJID/ch4K5JPhcnBn3NuXQ?=
 =?iso-8859-1?Q?AXnUt+qLfu16ia5ju0SyUDBEsX/+U4F78N8fxxXZpB/H8/lOen5wDykdDn?=
 =?iso-8859-1?Q?rLGHFNhmYImMoPOAGs8XNg4V9kgEAEEvPbZNxbiJQSUzls/RY6gdRhCXyp?=
 =?iso-8859-1?Q?kziCGno/OgcV18Rz6oWuwgDXzysLvqyzs5DiTyF0PHEHdJNNFMCslc1b+L?=
 =?iso-8859-1?Q?ci+Fj0yaOQfDQpVjO6mNwNK1/Y6MFClMA8hEPqQdTkgA/VwWDeX3iNgz89?=
 =?iso-8859-1?Q?dAe0NJNL/NkpYgg15Paflgid4F0SZsXcUTZe7jYZFSkSC0u8jBPhELkL9j?=
 =?iso-8859-1?Q?zrbInF+Ce6LvG6WF6KQxZIlfn34nr5UnNjaqp4jJ8iWORqGhBdDOmKErSD?=
 =?iso-8859-1?Q?Y2GRe3H5kzUBic0o+TQot4xR8DahYIk5SMCrzgflkHSR80bmbtVK7+BroA?=
 =?iso-8859-1?Q?vTHFTeRF3XvD5NSmjHFXvM23EQuIr3WCog7LEsyLGVsPpcbH60y1nYb/YB?=
 =?iso-8859-1?Q?t5alm312ggfwXcoYPvQrYpNkRYoI/giintvxSxdzM4eplCaqReifz1eBEg?=
 =?iso-8859-1?Q?OemA9Qq0veCGh1xuUVqkxMZVfGLUXaSvzBOb0/nX4jOsu0sR28knvLD+Sy?=
 =?iso-8859-1?Q?Nlf0tkmtd8sKOf+x3mhiNcAxoZEnLz02nN9tK1Us/Ly0O06LmDpFwTGokO?=
 =?iso-8859-1?Q?TBDoqkWMBwm59d2gkl/emF1BHEaVEWjowAlNhmuqB+PjS0Tw5xbmF5wSqu?=
 =?iso-8859-1?Q?0zWm46VZRRJhQm0vXxdgl6FLR9EjlWHGVu03qeuBrZMRDgzlIKo8v8kt4t?=
 =?iso-8859-1?Q?WOLdZzzos2hXa87xy6UUjGCiA6ndkHHQXnXS/oLGKQnbfRAoxHTb/7w5aq?=
 =?iso-8859-1?Q?uhE84xilwpQirho8jMwXDW7TPBmAy1phDXVO6TazPdQ3aoaj/LjCc3j6MF?=
 =?iso-8859-1?Q?2QRQ/ofKpbCy7CWmnzdOKy?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?2dV5kfQQvDmPWeosIH8yupl3LzH2RSkL2LYr5vt0bmukjWM8zf54q5FrP4?=
 =?iso-8859-1?Q?nv46wTEjuF1ppGoeAefeIcesOmx/ZO2PuMCgi7LFhuMvHxSBbxrE4UTxj4?=
 =?iso-8859-1?Q?CWOmY07pxV9dNlwv0fnzOqHHKAP5xnG4IP6LM0tgCfrsQH8Mcjk9Z5MNVy?=
 =?iso-8859-1?Q?+XSZ3uuo/tOnUdOoYcA7vRdCYy0oZm9q5sPehuMR/5fn4Xr4wVoNWK97l/?=
 =?iso-8859-1?Q?KWmFEU7LnHSbKKL1SecNg3H2knyaWheSA9/nLzOq2a2/CvHgoR5V/gzJna?=
 =?iso-8859-1?Q?opeBeEblQ8pnl2FdMq8lpEKN2PYIdE2J0+1GJSSMQtgpUd03Bwg3TFkkUm?=
 =?iso-8859-1?Q?HefOSU8TzbSjUROLso7dXeaGJd3C23VqXhm/hW/W/r9uaBRqWpMSTwhSx1?=
 =?iso-8859-1?Q?PY9DOErGK997vQaULnvoznkAHKUyO4O59diEoz5LYV70PqiLmRjIdVcjuC?=
 =?iso-8859-1?Q?ZUh7hbi9rwFhCQDimh2ZtdLRhe7h8EXTkv/bYYODZC407zriGWpCBAroKE?=
 =?iso-8859-1?Q?XW/LGZeNLf52TrKBl3OwOHN7LM2kyrG3V/vRkdicckPcWjFkuMIEDdmXyq?=
 =?iso-8859-1?Q?e8beVZ7AYeM8qPbyihlW5V5ySrumiH04ANIMq4jolrROOZJPu9p+6kSIGh?=
 =?iso-8859-1?Q?n9F6rKFBFlxsgugB/cqoTzP/dobwNBu5O73MR1P5iahULb5aqb3y1AHQSc?=
 =?iso-8859-1?Q?xQ6fZ0r+Z7vwZsWzuTCGBibzPj2N8EE9YwLa43Qn9eJyQYebmiugGXfdft?=
 =?iso-8859-1?Q?eOZP6edJjqUr/H2aWqDMBK3RNHrkoXts9wBGrbuWR5y6qvbFkbvCKsIXll?=
 =?iso-8859-1?Q?pcVOhpDXJozk1QR9JjwI7I6yAL3yTjqi8BclrBfpL0tBK/1OBqNjZElydG?=
 =?iso-8859-1?Q?wLjRtMktKmbHXhLeLR5Ag6iXdFOikfS2jkUmFh2a3yMXHL7ggKGLDF44jX?=
 =?iso-8859-1?Q?D+69G0PtgsmUKQBj2EgU+Zpp/Dq6y+m4fMS/uIpQ3uujP2m/dCtF6OZ4A/?=
 =?iso-8859-1?Q?8KplThc5Kdw9rg0qL0dRBWGX0R3zpTXm04/onXWD5KPZ7kaRUShVzQzhFY?=
 =?iso-8859-1?Q?Z1JTez5dlOSOkMkgv3xHVNdawP+YdkL34i7XEul2hwZQtBwpk1UTvH/mKZ?=
 =?iso-8859-1?Q?rShq7C70NbXSOnMt1sbkr5A4wcaR9haC8uGRbUHv3XxuymVocUPB4weHGf?=
 =?iso-8859-1?Q?AiPDredSQmD1DHiK0Q64HrG+rHX7huC9gxE5lTGXoJCIliMkmM4z7qGy0N?=
 =?iso-8859-1?Q?aDTirlWPudVXZAzUX3KIQbItIdb+IJcMe0i1g/qcY+JAbZUh4SpVIxgHtR?=
 =?iso-8859-1?Q?CKwHZZmQzHsww+wa1Kkqi7iE+E8ppcQmfTcemcz+WXwZSDwOjtol1eU3Mm?=
 =?iso-8859-1?Q?U31gyW9+sPlHvgOGYY6SBMA4GAPNWRSpVIfi/CFVAXjP12zTpfuPZfh1+o?=
 =?iso-8859-1?Q?OYZogJvJ1QGVldX/hY5aUiLznhvmEI1iuOA9SCiRsHYGrVo/8JTbpI4ytX?=
 =?iso-8859-1?Q?KMDruz1yUxCxaIoAvxXrguTUJftZYuT1Hatd7LEJBnNlDS1Xrtq7i+LvMt?=
 =?iso-8859-1?Q?AXPhrI3EzZmCSEXwH8logHlLdsaA0RYiMrV6RtBDkyN7vKaPVPY1xF4roY?=
 =?iso-8859-1?Q?opKVb6P3p4YuAI4XLACKG0qmMcNanATAo0?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9649dcad-4d06-4499-d65e-08de235f8ce9
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2025 09:24:02.8237
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wehM/NX5ZnqtOnMNSiSTVhLp9KyI9KWFk/QsnHPsG7pMgs/F9t9cQzAOB9FVC83t+jqCXCdc32r6VOpHNuT8og==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB8379
X-OriginatorOrg: intel.com

On Fri, Nov 14, 2025 at 05:14:03PM +0800, Binbin Wu wrote:
> 
> 
> On 11/12/2025 4:06 PM, Yan Zhao wrote:
> > On Tue, Nov 11, 2025 at 05:15:22PM +0800, Huang, Kai wrote:
> > > On Mon, 2025-09-01 at 17:08 +0800, Yan Zhao wrote:
> > > > > > Do not handle TDX_INTERRUPTED_RESTARTABLE because SEAMCALL
> > > > > > TDH_MEM_PAGE_DEMOTE does not check interrupts (including NMIs) for basic
> > > > > > TDX (with or without Dynamic PAMT).
> > > > > The cover letter mentions that there is a new TDX module in planning, which
> > > > > disables the interrupt checking. I guess TDX module would need to have a
> > > > > interface to report the change, KVM then decides to enable huge page support or
> > > > > not for TDs?
> > > > Yes. But I guess detecting TDX module version or if it supports certain feature
> > > > is a generic problem. e.g., certain versions of TDX module have bugs in
> > > > zero-step mitigation and may block vCPU entering.
> > > > 
> > > > So, maybe it deserves a separate series?
> > > Looking at the spec (TDX module ABI spec 348551-007US), is it enumerated via
> > > TDX_FEATURES0.ENHANCED_DEMOTE_INTERRUPTIBILITY?
> > Yes. I checked the unreleased TDX module code that enumerates this bit (starting
> > from version TDX_1.5.28.00.972). TDH.MEM.PAGE.DEMOTE will not return
> > TDX_INTERRUPTED_RESTARTABLE for L1 VMs.
> 
> According to the content pasted by Kai below, it just says there will be no
> TDX_INTERRUPTED_RESTARTABLE for TDH.MEM.PAGE.DEMOTE if no L2 VMs.
> 
> KVM doesn't support TD partition yet, just for clarification,  what if the
> demotion is for L1 VM, but there are L2 VMs configured?
Right. The description pasted by Kai is more accurate:
"There will be no TDX_INTERRUPTED_RESTARTABLE for TDH.MEM.PAGE.DEMOTE if no L2
 VMs".

From the code, DEMOTE may return TDX_INTERRUPTED_RESTARTABLE if
tdcs_ptr->management_fields.num_l2_vms is non-zero.

Thanks for flagging this.

> > >    5.4.25.3.9.
> > > 
> > >    Interruptibility
> > > 
> > >    If the TD is not partitioned (i.e., it has been configured with no L2
> > >    VMs), and the TDX Module enumerates
> > >    TDX_FEATURES0.ENHANCED_DEMOTE_INTERRUPTIBILITY as 1, TDH.MEM.PAGE.DEMOTE
> > >    is not interruptible.
> > > 
> > > So if the decision is to not use 2M page when TDH_MEM_PAGE_DEMOTE can return
> > > TDX_INTERRUPTED_RESTARTABLE, maybe we can just check this enumeration in
> > > fault handler and always make mapping level as 4K?
> > Thanks for this info! I think this is a very good idea and the right direction.
> > If no objection, I'll update the code in this way.
> > 
> > 
> > 
> 

