Return-Path: <kvm+bounces-63490-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 9022AC67BCA
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 07:33:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 97A9F3642E3
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 06:33:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECB792EA147;
	Tue, 18 Nov 2025 06:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UlWbxd/W"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F39F2E8B8C;
	Tue, 18 Nov 2025 06:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763447600; cv=fail; b=bqd8sp9ucXP/GAg4li1ryaTbpfM8Ldsl6y1mihqMwF46WXFNITzyG/e8RbHNwUA9+vO/FhGJsSU7yoeYrMfnlS4Z0ytLWeZpkHkP5pwc0SEI8lGukuM+r0M5kj4h8TVpuRBXdP1wGE+FW1i8a2mOtQq7BhxCHg69Erb3UZ1LGvQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763447600; c=relaxed/simple;
	bh=1ZeCa37Ww4YE/pGb/SsKv1juTa85ufKeK5vk2I93rbQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=pswRv38Qk16DQvMxJbKsyDmb3AJ+cd95PaPUUjYe3je4EkEjlBzjmHeoabvPTV2F7NrtJ9MYnSEyBYSgtADSn2KbTltiWQvj/9hxTJbzZvjb8GV/Zk8OcU16cdYqFTCuZIpMV/ozm4PNOLwI6GTe04NZxYoFlVLyS52f7DsbYWo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UlWbxd/W; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763447599; x=1794983599;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=1ZeCa37Ww4YE/pGb/SsKv1juTa85ufKeK5vk2I93rbQ=;
  b=UlWbxd/W6YiD/AvGORXvZy1tT2NsVRFRUYoHrWv8Cyytlnr2JnqR+mTW
   RUaXX9KPY2drbZHoUSwNNKjp1yJBPr/wix3oUllMpvi5CpsLQdrdkK+2O
   vReKaqnt4ZTuo6fV8bL19faKYvKwOBsq3lKexqB+RmvTuZfltG7LESc1T
   ozEFdetuzrjyTbeHplo3/CRBl5t7Na3ij2mNdeD5zoi3LkgQXjNNr49PL
   6Fick3LpfK9kYEpxY5JgKqmm/89eUzF1TGD3VD9lu+8OvtiIUFgbYV70V
   feKaP8yjxp853kcsQsEOMR7tYz4ZeYSMoGxUSExxeOdO7JH9/sxqiGUjP
   w==;
X-CSE-ConnectionGUID: FcPGZyhjR/W/dOBh5UCWQQ==
X-CSE-MsgGUID: jSkiB189RGuc1f/NYiaJzA==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="69078304"
X-IronPort-AV: E=Sophos;i="6.19,314,1754982000"; 
   d="scan'208";a="69078304"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 22:33:18 -0800
X-CSE-ConnectionGUID: YCnUwYO/Tpi8B2OFaqytEw==
X-CSE-MsgGUID: JvAnnmKfTwyPGMiY5WSBNQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,314,1754982000"; 
   d="scan'208";a="190901887"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 22:33:17 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 17 Nov 2025 22:33:15 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 17 Nov 2025 22:33:15 -0800
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.35) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 17 Nov 2025 22:32:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CxjcvUUlNu6JhvD9/ywFKJ7d89WOgDkfnMC62w7Nd2ChEX/hVzKPpVjCNHlg9DGLQUlfx+sFIJYoFpeWMBj1goFv+skJ7w7PHGCjk5fSmiRWFxnmsnLbuIm+8HXb9QeUTkCAbMckedipyzKoP5pVfq5nGYWy9kvQiB+iDNmCSop+6w/guCO9uCARfB/Z0On+/XB9wUZhxjRertjKomNkIHVRnDsno4eo0IPxPk5uNt69dLjr7cuGd6/NTpJubZV96LBxJT7VDFL9cnXPpTZig6nPDWmfn5FOL4l4V60QVXls3LjnyMrop+j8rDa/JfedBkGxNoRdKuvgUmJxUGgbpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3mEuzsczVWFy58juscaoKjk7iQOT8XGeWgh9majT304=;
 b=vKkhb2Z1bacCFplNwanmeMMlcuuVLW4bdG2hVVcheIbKz8qv4xhCgTGj7HmIm5rBGHAl0SLGM1/HE6AtvQsxS4I28QrfT4v+LE7us3f+ZVoxULkRtA3AgU8SBarv8/Zr77i/49gx4krS4CJuomEpEoob787KfiIQS6S5E414wip1MQq2ZLQAF7qoJtwmtGPl2cCODXXy+9wzZQvXlrg0u9o67MG/wi3kEIkN4CeapjvKBLzm7FV5x34V05asCVVgjGZI8+atF29tL05k6EsVxONZe+iqR+uCWzge2Cw1uxcooQP7AyVAzZKFrZgqBHXLQEyf9w/mOX81Dhz/WvG+TQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH8PR11MB7000.namprd11.prod.outlook.com (2603:10b6:510:220::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Tue, 18 Nov
 2025 06:32:50 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9320.013; Tue, 18 Nov 2025
 06:32:50 +0000
Date: Tue, 18 Nov 2025 14:30:41 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
CC: "Du, Fan" <fan.du@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "tabba@google.com" <tabba@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "kas@kernel.org" <kas@kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"Weiny, Ira" <ira.weiny@intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"Miao, Jun" <jun.miao@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"pgonda@google.com" <pgonda@google.com>
Subject: Re: [RFC PATCH v2 12/23] KVM: x86/mmu: Introduce
 kvm_split_cross_boundary_leafs()
Message-ID: <aRwSkc10XQqY8RfE@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
 <20250807094358.4607-1-yan.y.zhao@intel.com>
 <0929fe0f36d8116142155cb2c983fd4c4ae55478.camel@intel.com>
 <aRWcyf0TOQMEO77Y@yzhao56-desk.sh.intel.com>
 <31c58b990d2c838552aa92b3c0890fa5e72c53a4.camel@intel.com>
 <aRbHtnMcoqM1gmL9@yzhao56-desk.sh.intel.com>
 <f2fb7c2ed74f37fdf8ce69f593e9436acbdd93ee.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f2fb7c2ed74f37fdf8ce69f593e9436acbdd93ee.camel@intel.com>
X-ClientProxiedBy: SI2PR06CA0013.apcprd06.prod.outlook.com
 (2603:1096:4:186::18) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH8PR11MB7000:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b9d87dd-a514-471a-bb53-08de266c4bb6
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?PPR06DHnwexShKxTI2vXlH2/2py2vmk5tV3Vd5gb3JTB38CbpEraT0LfSU?=
 =?iso-8859-1?Q?90JeHekEtBGt/6TVVxknUgU9sEzuyBsbE2wtuBlRs8f9ghf28eU4Q6xeum?=
 =?iso-8859-1?Q?mO1BGSRZ0spuLBuF++Uoep9AzUXdUD60cemFnzFFi0bpqXu/nWp9kDxgKM?=
 =?iso-8859-1?Q?xEp+jXkE1HiMJeCHXwZFOtjO/erkqUn+yZAZ5/ovma6LdD85vSTYEh9LAZ?=
 =?iso-8859-1?Q?fVWKYsImwn1ZIf8o5wXXUx85VLJ+GCqaSn9IeMg2bQdB2ZEGAVllRNP3/I?=
 =?iso-8859-1?Q?HS+Qrb3VjfbtQ3JEExATVsUuZ6QTUcDPsJSCdUaqFHyz9AU7TaQOflSqjr?=
 =?iso-8859-1?Q?sfdmvHjPuuXm/OtayrfVeJ90A/lTszhCiFaqdkiZcJzTSxYt1Cq1oNVr+4?=
 =?iso-8859-1?Q?d/CuklbKIDCqQdG8CM7cfrRJ3+LkNN4fLzdBe00gSLIqNk+p1VFZMk+DdQ?=
 =?iso-8859-1?Q?6HZNhGkpID8evnSAUUuQNLO4PWHrDM4tlIfo43RKjbXbQgPSMOp/1EYzw7?=
 =?iso-8859-1?Q?4Q4yQnX7ZdbiFjeqCYlx+7vmCEwCVacFEqv6ODjvSswjET6r/RFwJAkbb8?=
 =?iso-8859-1?Q?4CzgFZ6lms49tRxKYdnyBhUBojnrAfQ750JuUZ5YRjsJYRIe6jhkwAcpg+?=
 =?iso-8859-1?Q?a8UNZwol/FIXZZu394l9I17ubWPAAOUUU4e/jRlPJNumL2gfpR+ecQ/+Gf?=
 =?iso-8859-1?Q?y+3FCli4BLz+mJGhIw7aJbakeO5/HBE2Dku3T7F1vEEHYA2of6ujNp5yMC?=
 =?iso-8859-1?Q?/O8/l6cjXrvaEdc2GBzRC1V0Xx+a4X9hIa3+BQmboW4hplUn44t0cugU43?=
 =?iso-8859-1?Q?x7OewAveEHoEZLAyX23TL+ZUM+BMtLlzUVFfy9Xa+GyFTOq+LFZyop8GeB?=
 =?iso-8859-1?Q?ZcMDd/oN0BAQAkh2sFvk7M554Nu/EwD9iHxQYfhLm35/8mWl2Xn/1uU3uz?=
 =?iso-8859-1?Q?OiXtKJxqbvoMRinoquNLYLLVLTswXvGfrFhQeJTQqlHkz6hfQVRTQaLRv5?=
 =?iso-8859-1?Q?26Qpj1QKVVA3EUtJMIixo+ponWpg7d11TwEu8MD0mWNfirBDr2D+E1xNjv?=
 =?iso-8859-1?Q?vwWa69xnCTNICYzXLLFY/KglX65nLpa9GrjMB1pM4kiHxiPCOr9S2cahWJ?=
 =?iso-8859-1?Q?iru00KLA5hDQE/nwOSzUqS7UgZ4Inm+S6f7H/VWMpGGpNOf9hS2cqONUd6?=
 =?iso-8859-1?Q?OAGMib2NATQeuECnT+g1D/xATPmVb1lAZdrxbW+XsrR4ZAtH2W0qR4gtUh?=
 =?iso-8859-1?Q?iQk5f7+xho10Mgs4kyyKchCW3R8pJMs0OpBfrsF+rphxchUUPTWjQniigf?=
 =?iso-8859-1?Q?rfRTzxtWSmoPwZIQ+cQTgRqGNT3E5fLPdBgBYhdk1xhrPwjLPAKxPKnY+k?=
 =?iso-8859-1?Q?EyTtYJukjqMMtnx2sO+z0Qw1WI5G+WhqAQLVnGp1ir2BnX7JPcGc37svNO?=
 =?iso-8859-1?Q?obHq+KokZwXpOHeyKbyQ/0oYo/Ou1f4e57RJ4rXfw2W5S9uFfYwcR5xWyB?=
 =?iso-8859-1?Q?jujJKkYgj7aJHuVqhDn3YL?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?lNVhJsfdyeL9U/j1xWTE+aYgFBVHzyImqLWydHRKq9lQgk1oAnOYp4q3DY?=
 =?iso-8859-1?Q?aDGwvwQybI5UrJPEHTGADXcGciAww2452wetqGsUPRaB9cK9Sl2gW1nU14?=
 =?iso-8859-1?Q?20i+R0cartXKRS3559Zwq3QAmQz5h/ZJ6UYfU32Wnz1aMFdnZ4645QZ6Pt?=
 =?iso-8859-1?Q?QMPwv06xVxG2ERLPzz2U/balbLZzwvcWCTlJfyA2fxg9fu6zxns9Ro/pPk?=
 =?iso-8859-1?Q?nTzHWz+g1ow23OxS1NIbZmE36MiTTRj9sqt8Viza6cWm61IoNHVe3p3sVo?=
 =?iso-8859-1?Q?C33/522feUN6qt3Gh39BVR0NIbiRGHI7yxgKU8GRaitGuIsa5YxvGciHFa?=
 =?iso-8859-1?Q?8QdQep/thEfPjDSwZ87mTNCwnvZBD5NkFryXS0V3xouC1kRt/tCnJBaCCT?=
 =?iso-8859-1?Q?srrrE2cYCSRJvC5bEYu8P31I6vn2ycaSU3LSFRW6P0rlGpWZjWAfEVuF5t?=
 =?iso-8859-1?Q?p6oNrCgOahvQi81poZbS+nkjWacjlswWgauWBYSfwt81BI/HlcvpZs7Mfw?=
 =?iso-8859-1?Q?Nz5tDg5dxBIAwS11QRuseYsbnPzZmZmt+ryPuVDLzxmLO535Pjir2bjyWT?=
 =?iso-8859-1?Q?Kdt+QJ4JP2rt1fF6xlv67S6851HIXI/53CC8ad89XihRWlasVaM4UrnM13?=
 =?iso-8859-1?Q?AmX5EGyLd0zCjI+p5ymidpTLjn30muqjEq6wi6fL9sWe7+vv4qsqZYyY0R?=
 =?iso-8859-1?Q?GYdq3bERtCmpp0HDm2g/IPncshvI2mwvjJ9nrxAerh+p9Fve8zYBvCg1lo?=
 =?iso-8859-1?Q?uvs0Db9yocoUpTuZ9uJdIWQO3zF0N9ybfdijXzmOFE5juf95BPciQs4FWE?=
 =?iso-8859-1?Q?T+VbkG4ilZfSvXBq4NL6nFbZRaUKcso8T0OsM1wzPUa5nNStC2e7bGErJU?=
 =?iso-8859-1?Q?x+qtCq5Q7G9FsebTjZyH/wuLemyDhm/wv8BNIW1gsDsAZ8CjxUj0GmVsVe?=
 =?iso-8859-1?Q?f7m7D4ReIISHCGvzPncB/hldKAbYj6gc1VRnTiFwRk6uM7lfJtyRCVa64b?=
 =?iso-8859-1?Q?kmJBqIoCq75HdJEK2TXidqUb9mZznX9n76/7XeETI1gRd8+/4s1SjuEETw?=
 =?iso-8859-1?Q?TukgAE5OkgimTe37NJx0GKAcvWTq4eQjd26/MfT0xcumBnVmWjnh+qh7EE?=
 =?iso-8859-1?Q?73872yzjLMjCq7Sa2VH0IruFjDxcuEki+ZxbgA7ZjgwGSmTkBzEXPdu/In?=
 =?iso-8859-1?Q?ClmKGoaMekQpATz1MALaKGiWa+Nd9V7UKlNUq6WaDWkphVCYVAT95uP4mw?=
 =?iso-8859-1?Q?S73F37PzOqPzl43CjzslVLKVbuLVjjYMBwWiYOaRwyaJ4fI+6gJLYyQBsd?=
 =?iso-8859-1?Q?X/PHuatdH1fgepBfE9tYBGmc33uOFPGPMRcACA1nqe7IcgM2sxo1d0ie9V?=
 =?iso-8859-1?Q?MadOltvS6OtabemANuETsgHI5ZmsaFyG1NaYkwIE6mbTOnVxS6rnjMfGaw?=
 =?iso-8859-1?Q?YyN8ijhEO56PsGF8fSwSS0e+GKEZpCpa326P9S40T56hYJ7cTZKu1Td7+d?=
 =?iso-8859-1?Q?3e8egtuIlGL6sM5/6UZp7sWyWC/yPLhLt7AX208wq22BXY79yiZONXDfdn?=
 =?iso-8859-1?Q?3+/LdsBh5U+qLr1Y2KQLP+2Iv76hZ16Pnlxj5PajXOLNfaxj5Q1C3GLj7c?=
 =?iso-8859-1?Q?NFmAHdZiEVYGsmUt7ktz6OSTSSFMDpNFRq?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b9d87dd-a514-471a-bb53-08de266c4bb6
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2025 06:32:50.4261
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k+bgfbvLqdgaLoU9ZzxCTQt68502KKaOq+S94TflMpEsPXtfgHQ45kNmj3QYUvoqkmlQc5og0T/RGtKLrVZ0OA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7000
X-OriginatorOrg: intel.com

On Tue, Nov 18, 2025 at 08:14:17AM +0800, Huang, Kai wrote:
> On Fri, 2025-11-14 at 14:09 +0800, Yan Zhao wrote:
> > On Thu, Nov 13, 2025 at 07:02:59PM +0800, Huang, Kai wrote:
> > > On Thu, 2025-11-13 at 16:54 +0800, Yan Zhao wrote:
> > > > On Tue, Nov 11, 2025 at 06:42:55PM +0800, Huang, Kai wrote:
> > > > > On Thu, 2025-08-07 at 17:43 +0800, Yan Zhao wrote:
> > > > > >  static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
> > > > > >  					 struct kvm_mmu_page *root,
> > > > > >  					 gfn_t start, gfn_t end,
> > > > > > -					 int target_level, bool shared)
> > > > > > +					 int target_level, bool shared,
> > > > > > +					 bool only_cross_bounday, bool *flush)
> > > > > >  {
> > > > > >  	struct kvm_mmu_page *sp = NULL;
> > > > > >  	struct tdp_iter iter;
> > > > > > @@ -1589,6 +1596,13 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
> > > > > >  	 * level into one lower level. For example, if we encounter a 1GB page
> > > > > >  	 * we split it into 512 2MB pages.
> > > > > >  	 *
> > > > > > +	 * When only_cross_bounday is true, just split huge pages above the
> > > > > > +	 * target level into one lower level if the huge pages cross the start
> > > > > > +	 * or end boundary.
> > > > > > +	 *
> > > > > > +	 * No need to update @flush for !only_cross_bounday cases, which rely
> > > > > > +	 * on the callers to do the TLB flush in the end.
> > > > > > +	 *
> > > > > 
> > > > > s/only_cross_bounday/only_cross_boundary
> > > > > 
> > > > > From tdp_mmu_split_huge_pages_root()'s perspective, it's quite odd to only
> > > > > update 'flush' when 'only_cross_bounday' is true, because
> > > > > 'only_cross_bounday' can only results in less splitting.
> > > > I have to say it's a reasonable point.
> > > > 
> > > > > I understand this is because splitting S-EPT mapping needs flush (at least
> > > > > before non-block DEMOTE is implemented?).  Would it better to also let the
> > > > Actually the flush is only required for !TDX cases.
> > > > 
> > > > For TDX, either the flush has been performed internally within
> > > > tdx_sept_split_private_spt() 
> > > > 
> > > 
> > > AFAICT tdx_sept_split_private_spt() only does tdh_mem_track(), so KVM should
> > > still kick all vCPUs out of guest mode so other vCPUs can actually flush the
> > > TLB?
> > tdx_sept_split_private_spt() actually invokes tdx_track(), which performs the
> > kicking off all vCPUs by invoking
> > "kvm_make_all_cpus_request(kvm, KVM_REQ_OUTSIDE_GUEST_MODE)".
> 
> Oh thanks for the reminder.
> 
> Then I am kinda confused why do you need to return @flush, especially when
> 'only_cross_boundary' is true which is for TDX case?
> So step back to where why this 'flush' is needed to be returned:
> 
> - For TDX ('only_cross_boundary == true'):
> 
> The caller doesn't need to flush TLB because it has already been done when huge
> page is actually split.
> 
> - For non-TDX case ('only_cross_boundary == false'):
> 
> AFAICT the only user of tdp_mmu_split_huge_pages_root() is "eager hugepage
> splitting" during log-dirty.  And per per the current implementation there are
> two callers of tdp_mmu_split_huge_pages_root():
> 
>   kvm_mmu_try_split_huge_pages()
>   kvm_mmu_slot_try_split_huge_pages()
> 
> But they are both void functions which neither return whether flush TLB is
> needed, nor do TLB flush internally.
Actually callers of the two void functions do the TLB flush unconditionally
in the end, i.e, in
kvm_mmu_slot_apply_flags(),
kvm_clear_dirty_log_protect(), and
kvm_get_dirty_log_protect()).

> So I am kinda confused.
> 
> Perhaps you mean for "shared memory of TDX guest", the caller will also pass
> 'only_cross_boundary == true' and the caller needs to perform TLB flush?
Sorry for the confusion. 

Currently 'only_cross_boundary == true' is only for TDX private memory.

Returning flush is because kvm_split_cross_boundary_leafs() is potentially
possible to be invoked for non-TDX cases as well in future (though currently
it's only invoked for TDX alone).  When that occurs, it's better to return flush
to avoid the caller having to do flush unconditionally.

Another reason is to keep consistency with tdp_mmu_zap_leafs(), which returns
flush without differentiate whether the zap is for a mirror root not not. So,
though kvm_mmu_remote_flush() on mirror root is not necessary, it's
intentionally left for future optimization.

> [...]
> 
> > > 
> > > Something like below:
> > > 
> > > @@ -1558,7 +1558,9 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct
> > > tdp_iter *iter,
> > >  static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
> > >                                          struct kvm_mmu_page *root,
> > >                                          gfn_t start, gfn_t end,
> > > -                                        int target_level, bool shared)
> > > +                                        int target_level, bool shared,
> > > +                                        bool only_cross_boundary,
> > > +                                        bool *split)
> > >  {
> > >         struct kvm_mmu_page *sp = NULL;
> > >         struct tdp_iter iter;
> > > @@ -1584,6 +1586,9 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
> > >                 if (!is_shadow_present_pte(iter.old_spte) ||
> > > !is_large_pte(iter.old_spte))
> > >                         continue;
> > >  
> > > +               if (only_cross_boundary && !iter_cross_boundary(&iter, start,
> > > end))
> > > +                       continue;
> > > +
> > >                 if (!sp) {
> > >                         rcu_read_unlock();
> > >  
> > > @@ -1618,6 +1623,7 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
> > >                         goto retry;
> > >  
> > >                 sp = NULL;
> > > +               *split = true;
> > >         }
> > >  
> > >         rcu_read_unlock();
> > This looks more reasonable for tdp_mmu_split_huge_pages_root();
> > 
> > Given that splitting only adds a new page to the paging structure (unlike page
> > merging), I currently can't think of any current use cases that would be broken
> > by the lack of TLB flush before tdp_mmu_iter_cond_resched() releases the
> > mmu_lock.
> > 
> > This is because:
> > 1) if the split is triggered in a fault path, the hardware shouldn't have cached
> >    the old huge translation.
> > 2) if the split is triggered in a zap or convert path,
> >    - there shouldn't be concurrent faults on the range due to the protection of
> >      mmu_invalidate_range*.
> >    - for concurrent splits on the same range, though the other vCPUs may
> >      temporally see stale huge TLB entries after they believe they have
> >      performed a split, they will be kicked off to flush the cache soon after
> >      tdp_mmu_split_huge_pages_root() returns in the first vCPU/host thread.
> >      This should be acceptable since I don't see any special guest needs that
> >      rely on pure splits.
> 
> Perhaps we should just go straight to the point:
> 
>   What does "hugepage split" do, and what's the consequence of not flushing TLB.
> 
> Per make_small_spte(), the new child PTEs will carry all bits of hugepage PTE
> except they clear the 'hugepage bit (obviously)', and set the 'X' bit for NX
> hugepage thing.
> 
> That means if we leave the stale hugepage TLB, the CPU is still able to find the
> correct PFN and AFAICT there shouldn't be any other problem here.  For any fault
> due to the stale hugepage TLB missing the 'X' permission, AFAICT KVM will just
> treat this as a spurious fault, which isn't nice but should have no harm.
Right, that isn't nice, though no harm.

Besides, I'm thinking of a scenario which is not currently existing though.

    CPU 0                                 CPU 1
a1. split pages
a2. write protect pages
                                       b1. split pages
                                       b2. write protect pages
                                       b3. start dirty page tracking
a3. flush TLB
a4. start dirty page tracking


If CPU 1 does not flush TLB after b2 (e.g., due to it finds the pages have been
split and write protected by a1&a2), it will miss some dirty pages.

Currently CPU 1 always flush TLB before b3 unconditionally, so there's no
problem.

> > So I tend to agree with your suggestion though the implementation in this patch
> > is safer.
> 
> I am perhaps still missing something, as I am still trying to precisely
> understand in what cases you want to flush TLB when splitting hugepage.
>
> I kinda tend to think you eventually want to flush TLB because eventually you
> want to _ZAP_.  But needing to flush due to zap and needing to flush due to
> split is kinda different I think.

Though I currently couldn't find any use cases that depend on split alone, e.g.
if there's any feature requiring the pages must be 4KB without any additional
permission changes, I just wanted to make the code safer in case I missed any
edge cases. 

We surely don't want the window for CPUs to see huge pages and small pages lasts
long.

Flushing TLB before releasing the mmu_lock allows other threads operating on the
same range to see updated translations timely.

