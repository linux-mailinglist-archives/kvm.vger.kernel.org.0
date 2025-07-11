Return-Path: <kvm+bounces-52082-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BBF77B01127
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 04:18:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CDA577B1AD4
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 02:16:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A90117A303;
	Fri, 11 Jul 2025 02:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jOIg9oHj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26C6F4A0A;
	Fri, 11 Jul 2025 02:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752200265; cv=fail; b=NksVpuNwj/ghjI8LRUW4GwFGAOHOZPd/BQBSfdcDXden9oF5m5Aweer/dbzQYccapfrmFxuSe3cihWjWIScPlz9ZP44EFEqGXf5g+MltSSVLkwESDJGkGlDXBlTQtEguvsN9CHpN3/X+pF79uOi9w0tQIIm0//LEZVJaT7ofYi8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752200265; c=relaxed/simple;
	bh=oRxksUcwoAeKDPrRFawTFyI9Vzl5i6yIBHNn++JpOpI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=FuEsGfxnD4ObwmNcws4S22UHyQzTvJ3FuUbwsuoRP3KiQuOPir10+Ej0cIhnBlbd7qHaIATmwBejs0nQE8tjqvgahF9kJV9o6kP8iXQqYCK4OSPNTruZyPxCCdZhj0Un2M7/BTeFrr261KiRSDksuxQqBfIR1MSMiuoLDo+o9cY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jOIg9oHj; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752200264; x=1783736264;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=oRxksUcwoAeKDPrRFawTFyI9Vzl5i6yIBHNn++JpOpI=;
  b=jOIg9oHjDa4bQVXExfgMSD8gK1wHPUShhUAp+OMZs2QUr07DU6W/d89Q
   s8TIcT9ZDCkCaAKw9/Sw6U1X41LmdZttG/xOmA6V7jQw5Oe3OlbXAMqKM
   l3PsKC5ub0U1kuF6Lsb/cmHmMR4lReKpJ4NW/cdQKr5wtvBIV0jCcCQRa
   19HivhYOtaPt+gGm9TWbaSuGXF0cKRllrvVySJ5IOi8t/fe1I+KOb9ILa
   RofesVeWtaAGMABHGsDjtzQpzZQEEeymjxkIEIUVx84NePICOb+WSULOO
   LfLU8VXsigecYSzkAD6R/PyjgrTJlPyjg+J9MuvvtBaGHA26wQKS2lmSL
   A==;
X-CSE-ConnectionGUID: 9D9azsihTfejuyMs0mpplQ==
X-CSE-MsgGUID: hSqaTLYZRn2d9RVReF5qiw==
X-IronPort-AV: E=McAfee;i="6800,10657,11490"; a="58155914"
X-IronPort-AV: E=Sophos;i="6.16,302,1744095600"; 
   d="scan'208";a="58155914"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2025 19:17:42 -0700
X-CSE-ConnectionGUID: LchPlHDYSv+dXp8T6/saDQ==
X-CSE-MsgGUID: b67o1LTYSSykOxx+2fETXQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,302,1744095600"; 
   d="scan'208";a="187237752"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2025 19:17:42 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 10 Jul 2025 19:17:41 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 10 Jul 2025 19:17:41 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.82) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 10 Jul 2025 19:17:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XEtdolsSfhvT2OVXfZUwKu5Sqrsj3O5Zg9D/nIWlZQKxqvUGynbecLgY5qzB73NvGfU62MBAKduGtaD4Q4LiQpvrEIv5xnftufYh+z7ofMBzu+viijpieIoQqfpKGVjJD1ReX1RItYvpUiq6FcREHzefO8XNpbGG/OkyGt0NyVTvH9kzsudh8BJcnF1TwPotHTix/ZxaanN07pYRBOmkpSuRLtecbcSo+TROen2jl1Pny1/RR75oaRq05ts+hWcYFj2+oJ9sgC9ucrRpvkePYs2T0JDJo4HUyBEgve/BydYHfvLIwTEVKW977AJTDIfIa5G46SpvdskzNIku6DyOEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/MbX6IxQRxP4Lj6yFPqYeRiNe8dfw1PT07lEUqS9vqs=;
 b=nP3CNoze9RiESs4XQ7CrNwNipyDU6stj60pEGMLrLQhkvnETn4rud5SCjsm7zNWutPFzylreclqHTyNjq63gO4oROifwO5HJcTT3hnkNzezS6QzeWp1wPz2UF9UUvtPLKcA7krMu19MTPkE/r3nTOYKcizHhzswJbyg7AeqxNgjXY6eru9W/zuPUrDV8sEHXN+8/+16HRJmIgwoo3tabSBVVv9tIvSMZIMw+QTDYfvAcMyDZGZ25Henmpnyw9n2AqQa/ABKq5cXPC/VFtG1xYIxrtx4bhXYhLn7FgnZUJEVkXZXsLpwOspen2lwuF6UFrurL8ozE38ZNSnV7Ex1h3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH8PR11MB7965.namprd11.prod.outlook.com (2603:10b6:510:25c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.25; Fri, 11 Jul
 2025 02:17:34 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%6]) with mapi id 15.20.8901.024; Fri, 11 Jul 2025
 02:17:34 +0000
Date: Fri, 11 Jul 2025 10:17:23 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "bp@alien8.de" <bp@alien8.de>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "nikunj@amd.com" <nikunj@amd.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] KVM: x86: Reject KVM_SET_TSC_KHZ VM ioctl when vCPU
 has been created
Message-ID: <aHB0M/aJwzuqYBG4@intel.com>
References: <cover.1752038725.git.kai.huang@intel.com>
 <1eaa9ba08d383a7db785491a9bdf667e780a76cc.1752038726.git.kai.huang@intel.com>
 <aG4ph7gNK4o3+04i@intel.com>
 <aG501qKTDjmcLEyV@google.com>
 <78614df5fad7b1deb291501c9b6db7be81b0a157.camel@intel.com>
 <2fa327b84b56c1abe00c4f713412bace722de44c.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <2fa327b84b56c1abe00c4f713412bace722de44c.camel@intel.com>
X-ClientProxiedBy: SG2PR02CA0136.apcprd02.prod.outlook.com
 (2603:1096:4:188::16) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH8PR11MB7965:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f7a61e1-0705-4a71-276a-08ddc02118ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?3ZqwYFPwtRgUSCrbkPoue5CbOnFYG7tGLxnNY4BTeFvBFcggsFa1RUkSKsqO?=
 =?us-ascii?Q?Y94zlKQWMC4jY52N9zYAN5L8zQ1UN7wdSBNtosVkiKetsJgJGoafkJLrQrnw?=
 =?us-ascii?Q?zYD0jqQv2ka50dw+q/zWhCsEYD4JJgCyQzTNzjsbMTk9wFWL2olxc8vTlZx7?=
 =?us-ascii?Q?apMiNa4y8FyIvjEoujXkY6xe04bmH5f2BdIuWuxVwYSyabfJPJHxhiyKbcEe?=
 =?us-ascii?Q?1OPzARtORftj0wx0+rV4nrYbbRbccUCCms/1DNBfMJLnvLyIBkS14Sc4blW7?=
 =?us-ascii?Q?rk+KccJzxwze4UAqQE4v2KhyPDW/wz5vJcfKzAnajwWDkfoU4b/zF+AIG0HM?=
 =?us-ascii?Q?64UgxOjnnK/PFzLEROZvizdp/mrTR1ELeZs2K2xvAbMnwSzE9A6a9cdwbvNP?=
 =?us-ascii?Q?ifOzZiVMg3bHmPP4Fl93lX3+QCQnSlxuYaLp5ARDKi5EzKJZgp3lGmm/sggV?=
 =?us-ascii?Q?iQfbRml688RNXSyXgswwjHv7B11Q37AtyF/YXjTNPsB2qQ4wGduF+uP4B60Z?=
 =?us-ascii?Q?7KsjS1RJZOaCf7gnpNvrqVHCR02fB9ObPaIV/r/mWrtXpG1CGFbN3TcGUXxU?=
 =?us-ascii?Q?2rKuqiIwXYb4OzC7lrVVS+id24dr2hWS0pnnZv09dN0qFznLeL05hqJSpjh6?=
 =?us-ascii?Q?XgzdNRi8WkC5vRNWuX+xHmAzd8TMfj9Z5frwILujxnrUyc7kplVGobZQlRyo?=
 =?us-ascii?Q?dVcAimUqVliIGWno/9o+cJ/LcU9p5wP6/IHeFXrTW/s4btpTEX0ULA4xzWg7?=
 =?us-ascii?Q?trk+TJYWOAu9sP9t/763jH9xCQ6/G40EgTJdAILu4Rlq7ER2hS1JInSSW579?=
 =?us-ascii?Q?ri3LscyKi4UoXPK+1ZE7eBBF+lFUVQpnRjXUDLocZwPRq3yYrjhL67B3BcOW?=
 =?us-ascii?Q?w4GoZ7lZqbOZ8lmsTJgP+UkJfyvSuEfgTbcP2bF1p9BoY7V0P4EMTwQDqnKA?=
 =?us-ascii?Q?skNUG97zlw1N7ZUxttWebTcnKauesH8d0WhBVCzJXNZCHUoP3LX9J7Zm1pZy?=
 =?us-ascii?Q?HGHK/jxQhWtcHSTU5KDlSXf5fqAdc8Axklt8j1eXPh6tE2n0/EgLYhjjxQ7+?=
 =?us-ascii?Q?h2dJLO+9bUTc97CZZ2DfxMHcIpKOnXuktgIDDWW02UnN0EB2WX+l+12cfil5?=
 =?us-ascii?Q?XMsRCMnbij7rT9d7albKD7WhZn1gPkLtALwNQqdXnXqBi4AKjDn2AqA+bRh8?=
 =?us-ascii?Q?CKm2tq9o1rYhQITT0Dz3Pyc8v0u7s+uJqkr5rri9MUsa8YmMsE94SmkreWPi?=
 =?us-ascii?Q?BgW+rwydxGWEXB38e9GKDgrTOg1qTvXydvElbqhIpyWLvQJ7dcDk3SeMX3qa?=
 =?us-ascii?Q?rJHn6uFInDr91OlqmuxncwQON4fbHgaCUnPrzWChuCLKfV5YX7uh6P39jXzz?=
 =?us-ascii?Q?TG+NFeCJbjOu9ZHC1Bsq3VQ56+BHGgixbkH6icItcTp+namd4VEZAuBw1yq4?=
 =?us-ascii?Q?BnN97Rv4Ggk=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KvlwZJWnhaLtr5HCoy2JiUeSFprt5P4yXz8saFg1ZIctOhxpI7kXzzp4urzg?=
 =?us-ascii?Q?N9OLW0HErNaCUdJtGLIUDXfFpO4hZGBddOuL/oqPI6TdgxsnvWg9ER7WCMMA?=
 =?us-ascii?Q?7OSvPRfYeKpKIKNQgJF2UnNWC+Cp20T6FZ0rLvKLy4YtTA8VtXAWJB03FET/?=
 =?us-ascii?Q?CL1mteT6fdH//DkuknngzofuL8gtltqgJ+uqw7GhnyN8Ip4UHoYFDL2HuJaN?=
 =?us-ascii?Q?cVJbhawTq/iZ9EE6RmqsexYJka3AdUjd35Sn+Vah7zvqkXf0wvM6RtoeBej/?=
 =?us-ascii?Q?KHJuPsySjHypGV2JfAP2Vwp+I0VCujFOeGLE9Cj8Z3dB5IDvRHHR/aTI4Ska?=
 =?us-ascii?Q?EMTeUWilSo+LzVzif36jSuEuU3ojuMaJ+FaWv3w8Q+Xt/Vhozy6E7nnAXwCb?=
 =?us-ascii?Q?vsMH1jOKQz/N9qLOIwHmQx+ywoVwLlFkmjKoOGcCj9ECo2wprvfgcIfBEa9O?=
 =?us-ascii?Q?6T0uUfSpYTWjSlPm0r6fTdv74zHBAZQKrQPNaZ9AvJ6qbjac6xl9nCI5hcwb?=
 =?us-ascii?Q?pFZ72lUK7XGkhdhS/VbTcQdN25KPkJ88Vd6DcXZc06vjT0vKetwcZ75pnv9K?=
 =?us-ascii?Q?UeEsMs9COMdDa+MiBvWb+y1j2yJFr8ddCXpYPkbADv1VDbub1oDu76FYFQzd?=
 =?us-ascii?Q?+U6GKUq8gyJVoavmR1ejGkck48pJ2HAzPpwDn99z15x5txw99yFWU3SWDEuQ?=
 =?us-ascii?Q?95O2dkaDaxTO2G6WaIPzXj2BKufe+O/I0rQILoqqHSwHcs+Zt8NMx3EYrj2s?=
 =?us-ascii?Q?coPJqMBzTKFju1ox8oDo7JOZfkZN6lsdZk9rUzRKF5AqNX8UqX7tvUPGl0HN?=
 =?us-ascii?Q?U3yHM3H8LX2oA034x/piX0wSlgFfH22hkR2Dc3jO258MrmRlVisa5b537SOO?=
 =?us-ascii?Q?TNRk2c4eATqV2q77TUb4W3ub2rj4p1GonlmhuBHNuiWfKhVjrPlwm3BRgbt3?=
 =?us-ascii?Q?56sbCUPl6oJVIWY9d0iLZTh4qEwNAjOWDS7ilPX6HYY48M/7AfJkwHBPOghz?=
 =?us-ascii?Q?Q6AVNlp0rGoNmZgBsWanGEldsHbcL/Zv76xke008pMXxcxuim1nJkUUu0kbQ?=
 =?us-ascii?Q?wM+2m1hENWx9p8psKx8Lp7bs1PRC1CmpiMNj8PcpU65h3LcVmAwShJ5yJwzY?=
 =?us-ascii?Q?dwUj8pYQJE6UcmVRqV663YRClEl1QuwTYVtTRPav/HESPSXeUYCNhVpCGMHb?=
 =?us-ascii?Q?bvqDDVdKu8r74F+dbdCz0t4KVOxnYUWCqdq2M3iHKYUri1v3dvHfTYh+59tZ?=
 =?us-ascii?Q?DnEstA0tTrff8t4kSHOFpNf7X7aq9vtJPhU5zI+Jcxy36lLNxOknxzUAbUUl?=
 =?us-ascii?Q?85TiHpWJ6wCy6sfoZeUGzXxuDfpn73ezb1yn1rWhY9ZxC+jm/HN6o/ZZ94Qi?=
 =?us-ascii?Q?ThzA3vaOd59d019RxM2JsoUQASYMvRamQuHbVFrGqmts4L5fkvaq3FZsxpbK?=
 =?us-ascii?Q?O1+9u/+7Uu7jzBvA+RE7630vSM17SgrKTIInQg7BL0sv1ozE24Bcp147h1DU?=
 =?us-ascii?Q?nS1vYdvw61/rPt8pnt1UjMA+206FkZIq4CICKElO6NO7PKf7Z05aKDlHhbVZ?=
 =?us-ascii?Q?E3XLP1buJ+aitORK6vhgKFAHeWWShY5e2+93LBkc?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f7a61e1-0705-4a71-276a-08ddc02118ac
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2025 02:17:33.9651
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /zxAjOadNQ3QHKrc1GoMOcv/rwkIhxkTCSTXqVCCIo/qt9WTQsmSMKe3VhKetYNKdt0/G2i/gPY/S8BbpHPPhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7965
X-OriginatorOrg: intel.com

>AFAICT the actual updating of kvm->arch.default_tsc_khz needs to be in the
>kvm->lock mutex too.

Yep.

>Please let me know if you found any issue?
>
>diff --git a/Documentation/virt/kvm/api.rst
>b/Documentation/virt/kvm/api.rst
>index 43ed57e048a8..86ea1e2b2737 100644
>--- a/Documentation/virt/kvm/api.rst
>+++ b/Documentation/virt/kvm/api.rst
>@@ -2006,7 +2006,7 @@ frequency is KHz.
>
> If the KVM_CAP_VM_TSC_CONTROL capability is advertised, this can also
> be used as a vm ioctl to set the initial tsc frequency of subsequently
>-created vCPUs.
>+created vCPUs.  It must be called before any vCPU is created.

		^^ remove one space here.

"must be" sounds like a mandatory action, but IIUC the vm ioctl is optional for
non-CC VMs. I'm not sure if this is just a problem of my interpretation.

To make the API documentation super clear, how about:

If the KVM_CAP_VM_TSC_CONTROL capability is advertised, this can also
be used as a vm ioctl to set the initial tsc frequency of vCPUs before
any vCPU is created. Attempting to call this vm ioctl after vCPU creation
will return an EINVAL error.

>
> 4.56 KVM_GET_TSC_KHZ
> --------------------
>diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>index 2806f7104295..4051c0cacb92 100644
>--- a/arch/x86/kvm/x86.c
>+++ b/arch/x86/kvm/x86.c
>@@ -7199,9 +7199,12 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned
>int ioctl, unsigned long arg)
>                if (user_tsc_khz == 0)
>                        user_tsc_khz = tsc_khz;
>
>-               WRITE_ONCE(kvm->arch.default_tsc_khz, user_tsc_khz);
>-               r = 0;
>-
>+               mutex_lock(&kvm->lock);
>+               if (!kvm->created_vcpus) {
>+                       WRITE_ONCE(kvm->arch.default_tsc_khz,
>user_tsc_khz);
>+                       r = 0;
>+               }
>+               mutex_unlock(&kvm->lock);

LGTM.

>                goto out;
>        }
>        case KVM_GET_TSC_KHZ: {

