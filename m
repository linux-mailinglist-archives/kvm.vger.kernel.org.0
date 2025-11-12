Return-Path: <kvm+bounces-62865-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id C6817C512A5
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 09:46:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id AC7444EC1DE
	for <lists+kvm@lfdr.de>; Wed, 12 Nov 2025 08:46:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6E9B2FDC3D;
	Wed, 12 Nov 2025 08:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jIhDVuxa"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39F3E2FC019;
	Wed, 12 Nov 2025 08:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762937151; cv=fail; b=OeO+zler53JRQaF28e0MtcG8HM7jO3OCAmN/AHWa7x6NU19WxNXaFpI+IUPrwlrGDgljNz3LazU5gzD/oPVijTCuaqfgUHUPCYSP25RqC2ZvTagcgbBsJ4K0S8E9SuAMy75GQ4LYxzUHo8uE+prK0hqYz3V8guY3gX/A9wfPPXQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762937151; c=relaxed/simple;
	bh=dj3W0v8UKtaoPDgpDX1HnfkiWitcv/LWcfwi3Qb1/3w=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=l36/fJLR0HitVX9H4QDKadY2KmzyWsNV7vFR0UYwfjofPtf9Br/yFWH8vh8ekZs7xxclQrvxx7YlXpv3atigoKixVBhBD3qD5hNQYAfP3hcpZQ3aawIKqrO/+so5FJmzaKT9CB5wjTwljl29nyUPFe2adCjA9mNsVI84Ap5bpU0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jIhDVuxa; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762937150; x=1794473150;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=dj3W0v8UKtaoPDgpDX1HnfkiWitcv/LWcfwi3Qb1/3w=;
  b=jIhDVuxarVpw5j1jM8p3eK9wHrQ8/ZIVZkVmwEQ10+tXSgRWoOSrigbd
   PgOaMq7usd+pBpP/oHyrjaVvn6Km896zNOBSeGVgiK9aAn0ohOndwqrSz
   76cYY2sUwruD8+5r/8MGsaeFWuAzCHp3irR90A0lsUSvnsQGMaPTARxWW
   Bfe9w0LLZgf2gnR2gCInlZdeILmI3OjUXso7w1nFuGvJFp1SR6VotG6FP
   wwmUyJf5KEIAJvhfJp2ggnPZhCj2ug9siBVTSaVpIboV4OhD8SW5DnSIC
   N1vZuERgj8p0QHDh0hlk9Cmjg5da0iRzftDgLejCz3LGkIa8NDwTQ3HUR
   g==;
X-CSE-ConnectionGUID: bEJt4imsRiuuOODnPFWsGQ==
X-CSE-MsgGUID: iLRYHJfES1a5KfIJpHDj4g==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="64918674"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="64918674"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 00:45:49 -0800
X-CSE-ConnectionGUID: j+FgdXhjQQmcjjLt6AaJcw==
X-CSE-MsgGUID: apdzqQ4EQNCpdBXDkVRQ4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,299,1754982000"; 
   d="scan'208";a="188464534"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 00:45:48 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 12 Nov 2025 00:45:47 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 12 Nov 2025 00:45:47 -0800
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.45)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 12 Nov 2025 00:45:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SBq/th6+jRQMtZrXiJeRjisqhtktneq4Hq6ougW7ovl7EM8YdYs631pCx7UVa2i9QAUnlnQVstmwYbGDuhyx671NAViiWiwDxEO3zuTmYRwKhYT0qozlOI3qwZFPjHRoafDyr8RAuV+Mda5fWVBOidkKNLEar/kHFKdFAkTbCBRyw0UHZl1NiUYy0TVxwP8In2purEUwIY4b4R36D1dGs2Yaw2yt38bpiJt6jMPAe7YLUZxzfq7TW+ERPdzn8t5VSEBV5BkQqrE8sDgUZVT85rkutuyYXg0qYtpTfmhCD9xs50RgG93Yj2vS5Zoi0IS8+S1YD1yQ9weQ07Kjuh++lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r33hIQm6HSBcYq4opugFieE4bYtqb8D4kdGM85VHJlI=;
 b=aPijdvlDHDJKWzilvNCiVXqD4vLI5ZwhsQTpOGAdNwEIhZjQZ5QQEpcdOWbR/sremBompwuCgoLWOUGcNGZcm9/UHc7JXEZlmp8OA8VxLnzL7Ab7VPW/V7bbfHqu8fbqJvrGXokxmB15XCcNZLzXFEXvjebjEWemxzIlcfbGjh46QwDuPz0RzLOTVmrv+QG3aEjWYYlisyKwUA4cNG40f0hciq/z3MSE9Iqbiwk0VNmMSO0PjMAOGfNlLIa2SBIb9De8/jkKFGuIbYF6/Zi4IptVD66NlW1gbVW5s38oHiEuGzUBBn15KMV0r5nw3V3tpocdZnu2nbt7L95pOaQOjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 MW4PR11MB6763.namprd11.prod.outlook.com (2603:10b6:303:20b::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.15; Wed, 12 Nov 2025 08:45:38 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9298.012; Wed, 12 Nov 2025
 08:45:38 +0000
Date: Wed, 12 Nov 2025 16:43:32 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Du, Fan" <fan.du@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "tabba@google.com" <tabba@google.com>, "kas@kernel.org"
	<kas@kernel.org>, "michael.roth@amd.com" <michael.roth@amd.com>, "Weiny, Ira"
	<ira.weiny@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Peng, Chao P" <chao.p.peng@intel.com>, "zhiquan1.li@intel.com"
	<zhiquan1.li@intel.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "Miao, Jun"
	<jun.miao@intel.com>, "x86@kernel.org" <x86@kernel.org>, "pgonda@google.com"
	<pgonda@google.com>
Subject: Re: [RFC PATCH v2 03/23] x86/tdx: Enhance
 tdh_phymem_page_wbinvd_hkid() to invalidate huge pages
Message-ID: <aRRItGMH0ttfX63C@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
 <20250807094202.4481-1-yan.y.zhao@intel.com>
 <fe09cfdc575dcd86cf918603393859b2dc7ebe00.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fe09cfdc575dcd86cf918603393859b2dc7ebe00.camel@intel.com>
X-ClientProxiedBy: KL1P15301CA0053.APCP153.PROD.OUTLOOK.COM
 (2603:1096:820:3d::15) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|MW4PR11MB6763:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e923606-b2ed-448f-f1d5-08de21c7daa6
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?TYFFYmuWS6GA43tJJdXUd5kzPU76kcO2f01S2ouaadsK/tu7GQGKmyIn48?=
 =?iso-8859-1?Q?LD3AfP6MRu8tHT409kBmReQeuLEhrL8faBs4n48HiwW3zoo91idRm/vDOa?=
 =?iso-8859-1?Q?Pb+va+85B+fHId8r6WPTkS8nc6x/8Ke90gHM+VMFTwgh1LZdbmeZBjNEYr?=
 =?iso-8859-1?Q?Bag0Pw1pYv2fpM9PMW++W0xGZa4b3WshI2O88QVKjNaDJcF/1VJIRvCoay?=
 =?iso-8859-1?Q?kvNrkY025nrKkLlPBO11//iQVm/tprD01ROsQ+B7smw1QPxhQogKzMSR4a?=
 =?iso-8859-1?Q?wHk5+J1V6a/LH3jZTGoozwPYkcjJkSOp+dBfIwe2ZXnr6rsMn90ZEVmBao?=
 =?iso-8859-1?Q?fJt68uNtPZF1QU/vaFWGZadbHFgcx/VwuuF72k94YMFgI554y6nTOTJ9ud?=
 =?iso-8859-1?Q?6dYWDBY8npkdt6n5Wd2EZJEqDGCwe54iu6bfpWPB8OuCiMErxdEZelCPhy?=
 =?iso-8859-1?Q?fCCZBbJ6qwOq0ThGuA9Xu0mG1ZpMQOUaC+J9NRdCTEc20o1j+geTpzW0Nz?=
 =?iso-8859-1?Q?2xlgXbINVyhhJtH5OdxOMzqkiB7tECh5E5wxe+qqM9JR2akf8rsLRsS9QT?=
 =?iso-8859-1?Q?5Wwivd/dfXa7AUIoB1/TjM6JIpk6ecPBeBfOlgUyGJB3lHxjTVTIBeaxQU?=
 =?iso-8859-1?Q?eMVoRrAipbOoKC3Nl6RpbjwPXv9WMrEe1e6zZmj/QkgWlfLEeiMZt9uUyZ?=
 =?iso-8859-1?Q?u3BOLbWe3/Lmc2lpwbCRceZ6mVIiZV+9b3qdi91E3Z6FsoartXe9s2P9UU?=
 =?iso-8859-1?Q?Ys77opKC8IZlWgJKYaEjYIRqzboGpnuqawCEf+u3o/88MYzc20ZnXg2Cya?=
 =?iso-8859-1?Q?PGh9eSW5ouUhDnXNsqCOXCboNQy3TRbzpXVxeP/YwR2MZuFUBIIQs1WFOY?=
 =?iso-8859-1?Q?JELMB18HHPbOO/sgs/Q2CdgaPt6sKMZLoviYkeLT+G50cQYpC5mLvWfvRX?=
 =?iso-8859-1?Q?fFfcDJTF4RID6FQ+sdLXdq+oyRDx6fbChPSW5h2jei+VvqPSeqHx1d2sUa?=
 =?iso-8859-1?Q?1AhUxoK8lawlGz47eZScHNcVFMqxsyd0EEbyUL4slNFHeC89/YbiGcl4Jg?=
 =?iso-8859-1?Q?cpC0V0E1fu92VaGw6FaKhkwTr1ZnVQYL6RjUAFp3m0DbVVGNDNvNkZbRex?=
 =?iso-8859-1?Q?QkG1u3fL//4RxQiTAPOywSqbqC9l0+KAPGlM9QawBM5tOXYFLUgM/KZmRH?=
 =?iso-8859-1?Q?CB0aVjouNYqG60Z6eNE8iWogn8E7U8Ah0c1+Lnr6Y1bKwT9QhiuV+GDVdJ?=
 =?iso-8859-1?Q?3SS6iWgrMqfxe6T9KmP/XIoXqqm/03UYchsKHuAF+v+fp8YQpbqQtzYWXD?=
 =?iso-8859-1?Q?DnUUqz5cRMN+8vGdlvH26xkiTVdqFwyaz9d1rqK6S7MQajI/4L1Qt0fQsT?=
 =?iso-8859-1?Q?6O8SlU9ZO+qQephO1zW6TxrIMFNP1kM2kDCs/w+iqVGajxvDrktWx5YOUe?=
 =?iso-8859-1?Q?ZTns32sjZ0NV7Nxksd1NE04Wws+6Y/ywpMfl3SpzjMEmftaIjaOsOC+sA3?=
 =?iso-8859-1?Q?imqSpo5AJVmBSnJ32hzW2n?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?/iuAFDcxhBVTmyqvYuzeQtmUL6tWAdyGIh9XrEbH2yaXIhPJBT65KMIE7y?=
 =?iso-8859-1?Q?ium3FltYsomT/m2iVuKchVJf32fEY6YxShGgXZOCznrSy0S0H8MBd3PxxB?=
 =?iso-8859-1?Q?Jm+OAAUMp4LNbIZE/FifjDVGcq3xqKTquC2AsJ2eA8jqY3W72aC8V0UG4I?=
 =?iso-8859-1?Q?PyIstl8Vd1jpytLHoHr3QrDXpYqg3IFFgpkAq1rkzm7/P/iPdPj74N/IJ1?=
 =?iso-8859-1?Q?KmtB/33/e2p5CswQ7JubXPMtg4gj7ZCTp4+BrE8miCTMKHfHAo+jDFropM?=
 =?iso-8859-1?Q?beHDs5MNRQ8ULjeAx8GuMjtbGZC0acP2QK6pSjf/eDxnDfs1MQyYsNjLU6?=
 =?iso-8859-1?Q?q87VgiC5QMqgyh110AYYq84nzJPCL909959HJSSGqFe2vXfvssvtI66XGK?=
 =?iso-8859-1?Q?ZSS9ySke49Sj/nMJKFVt3+siQQpgPjAtuuCwL8Ra/+xY0Jj4EmfsaEk+zk?=
 =?iso-8859-1?Q?eN+Y+yRy15A38OYgKlX+4M2jEpavE7vUx+vVuBCWkkC6+kYBY2qgkKxvnA?=
 =?iso-8859-1?Q?Tt3QxklXpj1FOHKsPyuA48bhWC60Clp2CfCdDyjtCpKwynIVlIXZj6/hcR?=
 =?iso-8859-1?Q?FHbJhJxZcRI3hDbgcxVho77OarU8pK2H+jWV80KTATwaFyDkWY3VTcqBmv?=
 =?iso-8859-1?Q?onLuCtQOcH7OKJlE09Pxe6zkEpjMFT5vMsehxUpFqoksz3dAwr0KVYTToF?=
 =?iso-8859-1?Q?qj+gIe5WDk8Kz6bmLXS2uG9ZioyPxUXBBPDq5k6X7doe5yuHyFxQW8PjCE?=
 =?iso-8859-1?Q?3QIQcOl+HTYQZk6Sdd9xyKIggFsrmqsPIV6LDgu5rdilivP6sOJDUQXph/?=
 =?iso-8859-1?Q?5JrjaPt7Bu8pbT7sgoSWJNA9c2L2GrKjwqiX3eg3c97oOkoevIfWvoGQG9?=
 =?iso-8859-1?Q?50l0ZtwYnr+PMM1ug3YQ3A/MbtKD26VucuF1NEp5rAlV87RJnfKLZTGnxH?=
 =?iso-8859-1?Q?vZUyjWx7qzH2LxU0KBLnXInRMsr0UvXLDjv0W5MkUi2DWiIurJnhM/ZKZ4?=
 =?iso-8859-1?Q?u4+1vI8YuTd5nuiPgSgQWSG1li4sswaKmWy1UuYGwZwR7i/KC6F8PZ3nyF?=
 =?iso-8859-1?Q?smih5E+EsdjjW6eSw65HB5ERp5WyEpsO5ypE7/jQ+KqeCdbHYIk5TMZ0F8?=
 =?iso-8859-1?Q?yD4HcwgVuI2+8QpRt5/iv7lwyvtXTMPw6O+qe6ZVkYpFC3aycgGyGRM0N7?=
 =?iso-8859-1?Q?D0nvDJaKrSjjRRINb/J11VA3hgJ4Rhy1DdsTtyMkIMwqViyecfcM8/iQhf?=
 =?iso-8859-1?Q?55KlZ3ib58/P4/WLZuL+Ls3YzH1H6pmZAUoP4zXcF53Sp34b/RxpyPVpo/?=
 =?iso-8859-1?Q?Xef5kvtJhUPa1oE17IEc/F5xenICQdTDlQNoX2p12hKQP2kCQBTKao3BpY?=
 =?iso-8859-1?Q?OTLpjXM5P2aS9GjflRlYFZ/P91J4mXoNPmhzFJ7pxHXq93xmBZHjUMoi2n?=
 =?iso-8859-1?Q?rfsshepkFUj2nAVHFIbGodfInRSerEYNerBTLqKdOZMmK/wY7u6acgIKjm?=
 =?iso-8859-1?Q?XljRfWelrKXGErgmnB385InqoOHcWKOHqW89McuszeTIPc+rFhPJRxLtj5?=
 =?iso-8859-1?Q?VgPJ7eKWf2uaVmd21dlT+RtuigpTtjJUGqrVrukrzrcvQ4rGQ089+ys4XJ?=
 =?iso-8859-1?Q?RxR4mwg5pKeMikUJsVGtcHGN5X0qlooRHn?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e923606-b2ed-448f-f1d5-08de21c7daa6
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2025 08:45:38.5454
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: z96evLCC54HP696SQgNVgi0PNLhvyjpikw2Xg8glliXS2b1ltXl9A21ms7olujIYkwcEUbb556oVn4bsNQGFkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6763
X-OriginatorOrg: intel.com

On Tue, Nov 11, 2025 at 05:23:30PM +0800, Huang, Kai wrote:
> On Thu, 2025-08-07 at 17:42 +0800, Yan Zhao wrote:
> > -u64 tdh_phymem_page_wbinvd_hkid(u64 hkid, struct page *page)
> > +u64 tdh_phymem_page_wbinvd_hkid(u64 hkid, struct folio *folio,
> > +				unsigned long start_idx, unsigned long npages)
> >  {
> > +	struct page *start = folio_page(folio, start_idx);
> >  	struct tdx_module_args args = {};
> > +	u64 err;
> > +
> > +	if (start_idx + npages > folio_nr_pages(folio))
> > +		return TDX_OPERAND_INVALID;
> >  
> > -	args.rcx = mk_keyed_paddr(hkid, page);
> > +	for (unsigned long i = 0; i < npages; i++) {
> > +		args.rcx = mk_keyed_paddr(hkid, nth_page(start, i));
> >  
> 
> Just FYI: seems there's a series to remove nth_page() completely:
> 
> https://lore.kernel.org/kvm/20250901150359.867252-1-david@redhat.com/
Ah, thanks!
Then we can get rid of the "unsigned long i".

-       for (unsigned long i = 0; i < npages; i++) {
-               args.rcx = mk_keyed_paddr(hkid, nth_page(start, i));
+       while (npages--) {
+               args.rcx = mk_keyed_paddr(hkid, start++);



