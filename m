Return-Path: <kvm+bounces-51232-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E45C0AF0730
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 02:15:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2F4F74A096A
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 00:15:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4EEEC2E0;
	Wed,  2 Jul 2025 00:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fkeg4i1o"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F21E9B640;
	Wed,  2 Jul 2025 00:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751415309; cv=fail; b=RtwoBKWdeIYH7NTEPzyhJG9UyWgi994o1nmHbPfJvLGmYwFdurj8qaYyMLboE+AZwaOWvQJ1VMnVSTkMUzI7/BxQfJmGZbnlsUwuFbauGLD7UvtDJIr2RcP88VJDH/DrSyaQEYyXhOQB+MSWsoFB5urA7smX6XDGwYRguCCfANk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751415309; c=relaxed/simple;
	bh=n0kkjrLbinBgNKIjuxJOy7E1EG3gZKhKNKcKlujSprs=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=mIVOCVEnaJn/mprxlgRTHSjCaqvIzRrLYqKfbnsSD0T1q8DqpDRGdiDRq6V/BZilIEZg+rUrKwlwql159HSLk/Fyr9dI3FgSJ1i9GWbtEIp1mGEeHTVFO/fB9SndG7RqWs1lImhAx234jnOPvrI27BI2cZK+tbSW5tyBjzyOOF4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fkeg4i1o; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751415307; x=1782951307;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=n0kkjrLbinBgNKIjuxJOy7E1EG3gZKhKNKcKlujSprs=;
  b=fkeg4i1omcVugwA0eTUxKovC8EEgv891zVe4HMApWt/KyOqEWupzNBvK
   g4LEcyh/SjhLQV6iWMJOQMhUekyad3st3oBuX1xmKfRHPVWaPLM40DbQi
   Tdwgksmg5oKzj4VL+pjpbCui/ERJXaLztwuBecSgZXrOl/wBIj4zF9qla
   zHalacTjGpS54jDqDf+itgTqiljxWuJNgbR1K9Y1RouYjIfZFx/sciYKe
   CHEO4EKoeTTSA5jeRmtwVGjhCJNWheGYzlukKAAGXqcJY42d3Nz9XwHBf
   kB31RPHqb72sXS/hTplkQaeAzpV6EeUjJO0uZ/hqA1QmW5hnk4nDvqN6P
   g==;
X-CSE-ConnectionGUID: DwtwUtxPSAy0Qy4Fl1hJhg==
X-CSE-MsgGUID: AU8SQ8h8To6Fw0Lz8I0iww==
X-IronPort-AV: E=McAfee;i="6800,10657,11481"; a="41329544"
X-IronPort-AV: E=Sophos;i="6.16,280,1744095600"; 
   d="scan'208";a="41329544"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2025 17:15:06 -0700
X-CSE-ConnectionGUID: 5eqE/CB5QEKEJsfiQB0CGQ==
X-CSE-MsgGUID: U/6BegKeSICZleGQ7myzWg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,280,1744095600"; 
   d="scan'208";a="191092534"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jul 2025 17:15:06 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 1 Jul 2025 17:15:05 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 1 Jul 2025 17:15:05 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (40.107.212.72)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 1 Jul 2025 17:15:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LYPsJl/tX+7Jw1c9dsTY0DpdbesOj/OvTTQhUwtHp95vncar9U6Xy/L7suMMN38YqYvt3WQbPILvrBNm/4WmnQwBJk1Dw5VRSMBxmuGYkMNIrZWcULD4Z/+2idO6UMUYPYiOBK1EwhNVhDESUORLiRmOL6BsVDSGt2uaZ/f7uWGQUNqCJfiSDfUDn2LZCjTefrq8Ehg8bLZkuXpPBmatl2vQ2VgGgCjjzEDNpEhf8bkx+eoCBF6+Vv8AabcpLEdHkqRRzzjgZyePEcE/fUHr6mn6chXY43OWtHRNPgTyS6CcwJ2dmySu5sK6xwg1n4TrP9atRn9Bl0z+RKmXYzSB7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R5bTM1y//wr1FgIU7kpT9zBpM5hnKKHw4noJIUI/n7s=;
 b=oXUcaf6HjaFeCvL2y/eRPO1Bzc2/7Nrr8xES/E3pVcVjrgE6ZV1PnvxAeUwugx4pdn99lyI84dHB1aMp3vfqvik4MT14L90ulPv7g1GKXd8H656HFDai6rzwiaCmZsANqAHWtQqmIQOPf5u00KpTkKRQk6yHAHRn/RoMhTMgwCmKNT36XCISY3yqHSdNSh4R2OMRn784ZsjPVGFxhg5jN3yD3YiFVXsgLNMtFg4wLOSUHeJpNKa6zIZA53MTtzMTT3jb2oh8xZ232QPxUwzMhj3kbmXZiDZH2aNbJuskk1+tbOY3EtPtCg7ljsPmfIJ8+gC1PAd6JXFYTBfvPTFtwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SN7PR11MB8112.namprd11.prod.outlook.com (2603:10b6:806:2ea::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.29; Wed, 2 Jul
 2025 00:14:59 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8901.018; Wed, 2 Jul 2025
 00:14:58 +0000
Date: Wed, 2 Jul 2025 08:12:21 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "Du, Fan" <fan.du@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"Huang, Kai" <kai.huang@intel.com>, "Shutemov, Kirill"
	<kirill.shutemov@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "Li, Zhiquan1"
	<zhiquan1.li@intel.com>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"seanjc@google.com" <seanjc@google.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Peng, Chao P"
	<chao.p.peng@intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Annapurve, Vishal" <vannapurve@google.com>,
	"tabba@google.com" <tabba@google.com>, "jroedel@suse.de" <jroedel@suse.de>,
	"Miao, Jun" <jun.miao@intel.com>, "pgonda@google.com" <pgonda@google.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Message-ID: <aGR5ZYpn3xyfOZhS@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <aFWM5P03NtP1FWsD@google.com>
 <7312b64e94134117f7f1ef95d4ccea7a56ef0402.camel@intel.com>
 <aFp2iPsShmw3rYYs@yzhao56-desk.sh.intel.com>
 <a6ffe23fb97e64109f512fa43e9f6405236ed40a.camel@intel.com>
 <aFvBNromdrkEtPp6@yzhao56-desk.sh.intel.com>
 <0930ae315759558c52fd6afb837e6a8b9acc1cc3.camel@intel.com>
 <aF0Kg8FcHVMvsqSo@yzhao56-desk.sh.intel.com>
 <dab82e2c91c8ad019cda835ef8d528a7101509fa.camel@intel.com>
 <aGNK2tO2W6+GWtt3@yzhao56-desk.sh.intel.com>
 <908a8abdf0544d4fba23d3667651c4cfcafa9c4f.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <908a8abdf0544d4fba23d3667651c4cfcafa9c4f.camel@intel.com>
X-ClientProxiedBy: SGBP274CA0019.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::31)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SN7PR11MB8112:EE_
X-MS-Office365-Filtering-Correlation-Id: ee9dec8b-d7f0-414c-c656-08ddb8fd7b06
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?corYjS+pvFI8oJ9ZsjqOi5d/EVdX7NCSHukXDj+Az+26AAm4HybhpKjaVN?=
 =?iso-8859-1?Q?IjeNSPp6M5rXAJ0LNZgDzVAPQ67UrBTEL1A8rpUtZlCqT/fG9peE9QzjNL?=
 =?iso-8859-1?Q?BK+yXGeITTdsZGRXdRW7mpCx+BZORXe54o87hdDRmr+eH05ENl7RjrWw+f?=
 =?iso-8859-1?Q?WutL3WmIi8R+D92TgKi9ZR7bhG197LYK7O2pwarQCUnoTX+dVfAz0fTOil?=
 =?iso-8859-1?Q?HZZSjDlfkvQ7yR9xk00AS00AqTygs/RqwYNBCNd3uGgxby5woDYHv1QiSa?=
 =?iso-8859-1?Q?ofnMtuhK0J5RNWFX7hTVFqYFJ3+J23Awp27USwEOj3i2YqYLxEG00+I58m?=
 =?iso-8859-1?Q?UIdFSgOWqLZmkohW5kE+trsQQkZs2/KRyLC7gMQqP6XM9+9H8wOYAyOgJg?=
 =?iso-8859-1?Q?FvTtL4+MUF/HC641dVi8K/oBZKVZ7H7DSYrRyHT9ocnuRsJrojX2SlWMn9?=
 =?iso-8859-1?Q?aoiaAN5wFu+ac47XolTsvLQY3Wgww5Ba2bGjsNKJnMauylojNaWN2/uPqh?=
 =?iso-8859-1?Q?n7IyiEtZSvOaViLmPN8jF2XV/K3TaVM2prVz8+owFlj1/9ObApfTVGCAdH?=
 =?iso-8859-1?Q?TUJ+nfNaKeue3GKh4GAGDFPBnAN+/oUh3oKd1QfhN3BdniHmr49g+Rj4y3?=
 =?iso-8859-1?Q?u/Hdiqjtz+wI1qZn6FAuRBGEBXwAT7QUd45Rz2ds7vCS0iM971bv9ZaBwo?=
 =?iso-8859-1?Q?swN/pNjBc2lodUqYePS2rT5XNrhpBUl8uPesGsBAxTHrnowINzJq12Vp3P?=
 =?iso-8859-1?Q?joX8i+a6rU14Zb/ARVC6/cxLcX/jO47titzPUIx/samSEXtt+UGKveh9GG?=
 =?iso-8859-1?Q?Dyh3ER6J8fCh/kr+7Rd0fCFg2bUc1FOl5ZDD0pUK960fj8iONc/YgEFCJd?=
 =?iso-8859-1?Q?I37M3SjJrY10J+aWDDj/QwPDsBNeXOL78K2IvkVdOEgfWJLUZZxjpsGsZl?=
 =?iso-8859-1?Q?xiOmzZebFBmmdDfg9eKo2DYknqKCp/XEWXsJsz/qWOfr1htZX/W5dRv5yM?=
 =?iso-8859-1?Q?qcVAWui5lDfo5v3dsZxyZ7I2dXzfkAv3UY4wz+mjQ6IQX8p6J1sU8+P2Qe?=
 =?iso-8859-1?Q?VdKfy5E58NdZxdmGTtW/tx0A97wzxatbXjT1+JcKguVetcBb51p6MI72MM?=
 =?iso-8859-1?Q?/tawJgUTY3of9SgFK8mSMVz8RvAB2JrNl40SFeTDDsAZdXOAxG39k4HE/k?=
 =?iso-8859-1?Q?LvJkVJq5W1PE6i5xBr2o7dMnVyEEdm+WdNdroAKMKSOqHFkVmnOxeitnyq?=
 =?iso-8859-1?Q?/qJbvIT3vLGaJyfpjVPwxfpoWuErbQZjcfjUCdjjeunu277b7HNNyq2WPR?=
 =?iso-8859-1?Q?XHfoTAyq0ONUVM2eLd+KYwStdxbUy3hLybtV6zAtR2xGzg/0+IKXcSwEn1?=
 =?iso-8859-1?Q?PGtn9njRHFfVpiT20OBXNm4aI9Dh9Dj3Wg4JaL06bMnVDsdjs+pB7iOP1U?=
 =?iso-8859-1?Q?2x2nFapbEg7kIjg+GcY71e2lKdnmwT/nTqyu3WsdwbtZj/pSG+NQhVS1vD?=
 =?iso-8859-1?Q?Q=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?rdE/iGfppCj1SCTzsHnB9JVoVjXFl1kZUPifQQem1Fsk08gq/JD4gxLB4x?=
 =?iso-8859-1?Q?TLFlH++BV+AXx4jKydnv48K1lWyf6H7cctgg79zvYaVliEc+gMCBHia2uA?=
 =?iso-8859-1?Q?vJ1ZwD3WDiE+DAGs+BjUYrIhzohipvq/nFJkCLCfT8QIN4FTeV02YrJpBa?=
 =?iso-8859-1?Q?53E6VobVqpJMY+yJ9dRDfSmALyg/NDAx1SocSth5cjQzQaIi4LH+Hqsdru?=
 =?iso-8859-1?Q?h6PVLmaI8R117i8jMyzz3BFzHw2wXUig4BmW8OEquMOPgZXyTNiTE0d5dI?=
 =?iso-8859-1?Q?IZIcXKj8BbsE8aNJ5mz7kr4jP4zPuPmwD1WZnid6JEgf9yU3ALcYekaJ2+?=
 =?iso-8859-1?Q?hvQ08SZBR4rDs9Rd6k9+CZuPOfrN1aEpMNvKOJCLb4Jik7xNzhLMnmNZBm?=
 =?iso-8859-1?Q?ItHpeE2Wxo6ZYMbzvtW+RXcvQHt7AEDr+pGkzQ7HhEyIVSIrPVug2WiPq2?=
 =?iso-8859-1?Q?K6/STdEk/vKSc7n43cq9Yg7VOhJJyxQ3u1C+KCfexO/ODeijDFSaWNQueD?=
 =?iso-8859-1?Q?jBK219AumNztsVDOl1BpZRiwYjmhuJRkhQw7XV9BtIWbDPj2vO9EAH2K6q?=
 =?iso-8859-1?Q?GPrcg+zYQoIfEcELgNE2JD5PWg4btEpGVhCUIV9fAIxMdrrSU4FSde9lqw?=
 =?iso-8859-1?Q?STob7bPwsUBk2jPO3nP41hJQP4LPFH6qYKDhn2cXGS/RU7AXlxK0Kfpvbm?=
 =?iso-8859-1?Q?D4HVnYmm7++PYF0AsaG0pz6ETM8SszSjS+IuwAqzWqMChXCKap0ffhMlIu?=
 =?iso-8859-1?Q?USqWIlmdK5vzbyfXMOkeSmJVB7nknI1pqVIXTft7ZUBfYEo1cUwAa8zORe?=
 =?iso-8859-1?Q?uEE+0uAlpau3Bl5Udhtq0kK71y7fXhDn2TCu6YY+W1oMj7ueG+T6gJnshg?=
 =?iso-8859-1?Q?ua5nxQL23JK0GhCANKhkqIFZ2dZfYp0I3S8jSKay8uDRDwFewlh5RHZf4c?=
 =?iso-8859-1?Q?szmqm1RSf+Uv1zgRzWYXhlWyLdS4/qCpHN3VDA55x1gzUThigSl6OJdM9m?=
 =?iso-8859-1?Q?e7WmNy+xppa4Xt/81msJaflY7EiTaBsY6yYHUVB4Bo5Hktok1Pkm1LBYXu?=
 =?iso-8859-1?Q?KKLhne73PKZeFPK87vOM504EbX28HMiFoz0k3Kg4wVjybnVNSbR8mHhGOy?=
 =?iso-8859-1?Q?4eKGbX9X+9uKSYaPGDf3I430LcYEKrWez09iUyL+cH7BOssVCwloQXDB3J?=
 =?iso-8859-1?Q?+OuY6Lb9/NwFQ8kO0TBoB48GkLmES1RMpYGKlRo96qFh0WYJyx501QYlGe?=
 =?iso-8859-1?Q?9sh6j96UY+3h0Ygt0frLh+3JwQ8f4/Kt9Ew+TTBBsCNbGRzfmXUSbTb7Wu?=
 =?iso-8859-1?Q?3qBaNJWXKwTmwLrLAlpNgjvLP1dyitbCY3YskQMI1zVeMjQM5GYcgG77sc?=
 =?iso-8859-1?Q?8+SYhqeMVNdY5+59VGMzOXxLbWV4ri9TMit9EtPlhQv62fbZJ5wg6G1hjn?=
 =?iso-8859-1?Q?MQNme3YD1wdn4DZj7SYNwah71AaRqDYIXu3yAA9WDt9uqhudjwnlFqkin3?=
 =?iso-8859-1?Q?C6NOhtyxyZWwMsN8wYj8hfziQuhhpjb/w9nlVsE162MR46xg4XGB3CRlQo?=
 =?iso-8859-1?Q?eyjJS5PAUjGonX9VZzb2kM9yvEyt5WFMDvk/gsNNqaTspk7D8eeybDblOE?=
 =?iso-8859-1?Q?afBXmrgqoNHCcYMsTMaUVSdtohuYJTRBf3?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ee9dec8b-d7f0-414c-c656-08ddb8fd7b06
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2025 00:14:58.9050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V1I9+uB/9JrvWNcImetrhgPZN+dTpyJTNBQKs7fz1rMeFJWn5DTewOXUxInGNWTfLsye4SAYHXeyZ1yuPlVmhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB8112
X-OriginatorOrg: intel.com

On Tue, Jul 01, 2025 at 11:36:22PM +0800, Edgecombe, Rick P wrote:
> On Tue, 2025-07-01 at 10:41 +0800, Yan Zhao wrote:
> > > Can you explain what you found regarding the write lock need?
> > Here, the write lock protects 2 steps:
> > (1) update lpage_info.
> > (2) try splitting if there's any existing 2MB mapping.
> > 
> > The write mmu_lock is needed because lpage_info is read under read mmu_lock in
> > kvm_tdp_mmu_map().
> > 
> > kvm_tdp_mmu_map
> >   kvm_mmu_hugepage_adjust
> >     kvm_lpage_info_max_mapping_level
> > 
> > If we update the lpage_info with read mmu_lock, the other vCPUs may map at a
> > stale 2MB level even after lpage_info is updated by
> > hugepage_set_guest_inhibit().
> > 
> > Therefore, we must perform splitting under the write mmu_lock to ensure there
> > are no 2MB mappings after hugepage_set_guest_inhibit().
> > 
> > Otherwise, during later mapping in __vmx_handle_ept_violation(), splitting at
> > fault path could be triggered as KVM MMU finds the goal level is 4KB while an
> > existing 2MB mapping is present.
> 
> It could be?
> 1. mmu read lock
> 2. update lpage_info
> 3. mmu write lock upgrade
> 4. demote
> 5. mmu unlock
> 
> Then (3) could be skipped in the case of ability to demote under read lock?
> 
> I noticed that the other lpage_info updaters took mmu write lock, and I wasn't
> sure why. We shouldn't take a lock that we don't actually need just for safety
> margin or to copy other code.
Use write mmu_lock is of reason.

In the 3 steps, 
1. set lpage_info
2. demote if needed
3. go to fault handler

Step 2 requires holding write mmu_lock before invoking kvm_split_boundary_leafs().
The write mmu_lock is also possible to get dropped and re-acquired in
kvm_split_boundary_leafs() for purpose like memory allocation.

If 1 is with read mmu_lock, the other vCPUs is still possible to fault in at 2MB
level after the demote in step 2.
Luckily, current TDX doesn't support promotion now.
But we can avoid wading into this complex situation by holding write mmu_lock
in 1.

> > > For most accept
> > > cases, we could fault in the PTE's on the read lock. And in the future we
> > > could
> > 
> > The actual mapping at 4KB level is still with read mmu_lock in
> > __vmx_handle_ept_violation().
> > 
> > > have a demote that could work under read lock, as we talked. So
> > > kvm_split_boundary_leafs() often or could be unneeded or work under read
> > > lock
> > > when needed.
> > Could we leave the "demote under read lock" as a future optimization? 
> 
> We could add it to the list. If we have a TDX module that supports demote with a
> single SEAMCALL then we don't have the rollback problem. The optimization could
> utilize that. That said, we should focus on the optimizations that make the
> biggest difference to real TDs. Your data suggests this might not be the case
> today. 
Ok. 
 
> > > What is the problem in hugepage_set_guest_inhibit() that requires the write
> > > lock?
> > As above, to avoid the other vCPUs reading stale mapping level and splitting
> > under read mmu_lock.
> 
> We need mmu write lock for demote, but as long as the order is:
> 1. set lpage_info
> 2. demote if needed
> 3. go to fault handler
> 
> Then (3) should have what it needs even if another fault races (1).
See the above comment for why we need to hold write mmu_lock for 1.

Besides, as we need write mmu_lock anyway for 2 (i.e. hold write mmu_lock before
walking the SPTEs to check if there's any existing mapping), I don't see any
performance impact by holding write mmu_lock for 1.


> > As guest_inhibit is set one-way, we could test it using
> > hugepage_test_guest_inhibit() without holding the lock. The chance to hold
> > write
> > mmu_lock for hugepage_set_guest_inhibit() is then greatly reduced.
> > (in my testing, 11 during VM boot).
> >  
> > > But in any case, it seems like we have *a* solution here. It doesn't seem
> > > like
> > > there are any big downsides. Should we close it?
> > I think it's good, as long as Sean doesn't disagree :)
> 
> He seemed onboard. Let's close it. We can even discuss lpage_info update locking
> on v2.
Ok. I'll use write mmu_lock for updating lpage_info in v2 first.

