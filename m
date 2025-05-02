Return-Path: <kvm+bounces-45235-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E9599AA74D6
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 16:24:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 949D21BA3FDD
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 14:24:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD7952561D4;
	Fri,  2 May 2025 14:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gCMq349m"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1019DF9E6;
	Fri,  2 May 2025 14:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746195871; cv=fail; b=safu7qVbU/IkmGb4SmDpUZBw3WOaHv8XqSCq9XVdWVcHPtrkwdLdlamc0Mg/1ZleDxI92/WISY2bwzCfst6HhpuUn1wGtwbuO8HaTPDxu8sA7o1L1Emctd52fA84vnz1+4Gw1/q5cJrjKHKvatIabUi5rTmDGRW3R3SCk4F9V2s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746195871; c=relaxed/simple;
	bh=9Plz4/KTGeDZ1RRJV5Yj6Fj26fIliAV+W/pGFfFZLIQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=P2BtejSX0FXC+Zr6cTxdoPGGJDqLu3SsKYhPCGiyh5l7Ac9/aXNc9n6pMzWg7B38wjq8uv1yCh7Cs0T6mAFdELwoZ4YD0O/Lt7d5/4G2gB71YaqBvInPiOq/ReV7hZNfnhqdd5yYtn69HPqc3Hjl2EDhb5J5Ng8WKzYekuziuoU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gCMq349m; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746195869; x=1777731869;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=9Plz4/KTGeDZ1RRJV5Yj6Fj26fIliAV+W/pGFfFZLIQ=;
  b=gCMq349mQhAMiaxez7fO1WjoKlpVmINgdRS2W9CU3D2mvKAQ6TxBIugb
   0ijlsgj93E2uQclAACHXT4eNumIk/0l61heCxHqG90afjpBroSePyCJWV
   RxcGjESxrOgqQow8S8zhbK0A3ySxPGUcxl39Osz21UYzBMVyalJoQCp/m
   AmFmrKzh70YDiWVLrqp9gSHDsDNknywTpv9WrNmqviJIPFnwzp+WUh7Ee
   uNVb/XXjJ7f7oPDsP71Diw3oO/S6IDtzCxsmelCtTGEruRwncfTeAat8s
   c2gKQxX91xG33o+TwL4fPMPXHgCA8DIXpIUYqvitCO2HKt+H17XDyQ3Wo
   w==;
X-CSE-ConnectionGUID: UY2g3VcrR2idoh7LaHfQHw==
X-CSE-MsgGUID: k/7PUNMlRKG84CVskfwH3Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11421"; a="59261559"
X-IronPort-AV: E=Sophos;i="6.15,256,1739865600"; 
   d="scan'208";a="59261559"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2025 07:24:15 -0700
X-CSE-ConnectionGUID: kx4pYpSeQMCfL8B/TSznIA==
X-CSE-MsgGUID: 3gqsA0sLQfm0QJ6AnExEcg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,256,1739865600"; 
   d="scan'208";a="134607814"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2025 07:24:13 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 2 May 2025 07:24:12 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 2 May 2025 07:24:12 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.49) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 2 May 2025 07:24:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FMP8zJnXJ5D4wEh6qbc/rc2xcZ3qLUfIphPhN4Xhv4a8vVBbIlNcR1WYoh/LE01BWdT/nabWF3Tpf4TsS88udZVqeXEW74J0cZH2tJbl+M/O/zPfoxCPxA3AbIyf7Hn/Da7lsa/E2K6/UCByCHr+qM3URba9XWLLJWHTdAfgqZt8ynWJNxpTk14Gu/DqfD9rfucJR2vwOJCboa8M7fKA6sMtCX35invJ1Zutg9uiHRJjCJhSN+jf00JwfqKEgH7Kl2LHOI8wzmzZSVukDLol6Zb/MPA3MESBT8qaV6g8Tn88DLtrA5Sl6S5Uz2+KWg5pRt0QdYxLKMGi9XRt8nCHdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q9oPvDPvpwzkH5ojotRHEjKY7SMvIdcZwfrrJefPTtc=;
 b=PtGCGhdnLQhR1a/aW4sNNiNbgihp2U4q4Nc+F839pELyiTIhtW8ch4glaELEIvvhPic7hZdx2hGvYtIn5mu0uWuibYkmMVKY6h2o61dhOSXVo1LpBhi6CKe8eQp6qI4lT/wGcc3EeRfPJFMMgusQ5eNtwc4O4IDqVGjBHfhKK+ul4jIKLBjmOJdDMG35H6QV+TJ0ecvCTFq+pPv7QTNK6/B6e6H2AfGqT/TO7v6pwp2M/mUCpoHCzGwWZWbq2N3pJVDcmU/yht087H3RAwsEvJyXESL1raqmewLQ/Jzdncid6SZdjqtrqJgtU1euArCPC4FPTo3x+38VNDiCBPqjfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by SA0PR11MB4559.namprd11.prod.outlook.com (2603:10b6:806:9a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.24; Fri, 2 May
 2025 14:24:09 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57%6]) with mapi id 15.20.8699.022; Fri, 2 May 2025
 14:24:09 +0000
Date: Fri, 2 May 2025 09:24:39 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: David Hildenbrand <david@redhat.com>, Ira Weiny <ira.weiny@intel.com>,
	Fuad Tabba <tabba@google.com>, <kvm@vger.kernel.org>,
	<linux-arm-msm@vger.kernel.org>, <linux-mm@kvack.org>
CC: <pbonzini@redhat.com>, <chenhuacai@kernel.org>, <mpe@ellerman.id.au>,
	<anup@brainfault.org>, <paul.walmsley@sifive.com>, <palmer@dabbelt.com>,
	<aou@eecs.berkeley.edu>, <seanjc@google.com>, <viro@zeniv.linux.org.uk>,
	<brauner@kernel.org>, <willy@infradead.org>, <akpm@linux-foundation.org>,
	<xiaoyao.li@intel.com>, <yilun.xu@intel.com>, <chao.p.peng@linux.intel.com>,
	<jarkko@kernel.org>, <amoorthy@google.com>, <dmatlack@google.com>,
	<isaku.yamahata@intel.com>, <mic@digikod.net>, <vbabka@suse.cz>,
	<vannapurve@google.com>, <ackerleytng@google.com>,
	<mail@maciej.szmigiero.name>, <michael.roth@amd.com>, <wei.w.wang@intel.com>,
	<liam.merwick@oracle.com>, <isaku.yamahata@gmail.com>,
	<kirill.shutemov@linux.intel.com>, <suzuki.poulose@arm.com>,
	<steven.price@arm.com>, <quic_eberman@quicinc.com>,
	<quic_mnalajal@quicinc.com>, <quic_tsoni@quicinc.com>,
	<quic_svaddagi@quicinc.com>, <quic_cvanscha@quicinc.com>,
	<quic_pderrin@quicinc.com>, <quic_pheragu@quicinc.com>,
	<catalin.marinas@arm.com>, <james.morse@arm.com>, <yuzenghui@huawei.com>,
	<oliver.upton@linux.dev>, <maz@kernel.org>, <will@kernel.org>,
	<qperret@google.com>, <keirf@google.com>, <roypat@amazon.co.uk>,
	<shuah@kernel.org>, <hch@infradead.org>, <jgg@nvidia.com>,
	<rientjes@google.com>, <jhubbard@nvidia.com>, <fvdl@google.com>,
	<hughd@google.com>, <jthoughton@google.com>, <peterx@redhat.com>,
	<pankaj.gupta@amd.com>
Subject: Re: [PATCH v8 02/13] KVM: Rename CONFIG_KVM_GENERIC_PRIVATE_MEM to
 CONFIG_KVM_GENERIC_GMEM_POPULATE
Message-ID: <6814d5a710025_28880f2948d@iweiny-mobl.notmuch>
References: <20250430165655.605595-1-tabba@google.com>
 <20250430165655.605595-3-tabba@google.com>
 <6813b9167661b_2614f12944e@iweiny-mobl.notmuch>
 <b6355951-5f9d-4ca9-850f-79e767d8caa2@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <b6355951-5f9d-4ca9-850f-79e767d8caa2@redhat.com>
X-ClientProxiedBy: MW4PR04CA0072.namprd04.prod.outlook.com
 (2603:10b6:303:6b::17) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|SA0PR11MB4559:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c3b003d-6e72-43aa-298b-08dd8985009d
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?h/tQEC8Ma+gLswv4INvUmOJy9b7gklgdkVW4c43SHmCXRaMnLM9AnU3WbyWI?=
 =?us-ascii?Q?unHJ3uK8CS/tHqJgxzeLeRIZ+/zFulZusqbzsmVWva9+2lmfUeoPn+uvAI8C?=
 =?us-ascii?Q?g6k/hbrqMS7Vif5SwviNlWE2rIugmvoRwVcrwAZw8Rx4NNLe3qza7qT5JlF/?=
 =?us-ascii?Q?7jYdRa7499WRu9dBxWgz74/UlS12n1mU0Yr6qYP+nFDqcOpQd9AjXcElrwM6?=
 =?us-ascii?Q?MjYFUrCw39qSQqOPdsKDsJl1lVnv+kToj+VJrNK2BTjyuAS61CTljlwGkucw?=
 =?us-ascii?Q?6e2Xf0UWETpdrhLQZchFFfm67pqJxYfUh9zjACSuv4o8nhAXHPKt7rp6+Uel?=
 =?us-ascii?Q?kzxATqI/uxEmeyz35CZx+MkJmT2+1ZHsm4ERFucCjfJ2WzGUFbUzGqx4S/ZC?=
 =?us-ascii?Q?ai/ZeHsqbF4ILAXSX0Q0dtrStHIIn/2QNfPx8mGHfTAzys9eax/ufAqkAuVJ?=
 =?us-ascii?Q?7VAsejy4cmOwkgnMIkRRNtVzdSwvMHypT6XX8/4JBrhGgOAiLFtnfOhskKeX?=
 =?us-ascii?Q?aS76zez6PsWvpYa2+P2VplwqijaArkfcKEUXAW7bYlwvmyS5/lN5ozqZfdnK?=
 =?us-ascii?Q?0lCley+K2qwf6QIIpbjYP2kW84Lhag9HUFDoQrcxPxXOvyuY5bpfVitrTq1O?=
 =?us-ascii?Q?8CZuKyNoDgaJJRddxW83kplfXrQH6QeUqi4NzEOsluI2YFfCrcbQADjEpBgE?=
 =?us-ascii?Q?f8I1i5WlHKo7U7ocEKpM8kenG7MBgv+LYW4Kqlxq73AC8iS+yYLz0qjqyjgt?=
 =?us-ascii?Q?uvhEeNIOMxyioSYDUmo8A73721/jPvVGOOwoZ/ixQplK8OLZQLds/cqUrHKF?=
 =?us-ascii?Q?rAjgeCnWYqqIMyGMpnbQ/kjNZzFfTug2lJEtqM4YnZ0yHULUAj86jZMIH2y5?=
 =?us-ascii?Q?a6X7PjDDMJsJ5N3OIshGgnvejUICVuOChh/OaGRcYpKUJ/kW8ucKmQfatrXW?=
 =?us-ascii?Q?32Z5v2eESUWJQqinYHKKakhfjfM+LawupbXIF1Mv5swulM6k8opQEoag3h/K?=
 =?us-ascii?Q?w3bov6renlVS4WKrBX6j7tAWd43Pm/Llv84S9wGlkeum6X4Wh7px8iPJ93IW?=
 =?us-ascii?Q?fqvany9oLjD56XVewI1Pc6qpaPtoPrZbvchraAa7fj8yzz14X8fXreuDZVfZ?=
 =?us-ascii?Q?BcmyzIBeuiFv+wFn6s21Ll6w/90FMv4K62tZVMmawxjkl2L+a6ZUb+dSCwdk?=
 =?us-ascii?Q?CG+PLz4ow9BN1ayOFfT2XDNqpjQP1wK6yZ3X9HBBKglwk8SAlNVMMqITMum1?=
 =?us-ascii?Q?vNmnejJ5s54ws3ppqPLB0g67ujkqxqnXn3khTARQBMTOzgqUR7W6+XuALySH?=
 =?us-ascii?Q?3Q17b0DlWtiTnKGUv9HWDXaky9DKiTJUwLtfTCbY4OsB5vWGhm6KrBs80e8v?=
 =?us-ascii?Q?3Hkd/Is/Ea0rxRcOmjxEVhYwVeJrgITBliXB6TG+ijPTQx8fexMr6rfq+qqq?=
 =?us-ascii?Q?g+hEEj8/g+g=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?y5rHw8r+8eW04T1EraiiP+wPw0L/MJtqtBfhOP96NxIm8r5Z7k1wX0YHY1+X?=
 =?us-ascii?Q?aCEKuXNvaC3eIoEB0Qc/Toox5+eaDB07MKaEcYLLjK7lWSWpZRF2TQmU8+Gl?=
 =?us-ascii?Q?JGfrvWUsBWpO8lz2gjk4IURLK17d8OJZAP76DXnY7kERyzpLxtS93VNOqBn8?=
 =?us-ascii?Q?//xRt+u+p6M7+yz2Dlp1AhyCv230ThCwwv6IZ43nscid1n4p/EOTy7OfkZd2?=
 =?us-ascii?Q?QhantfehYhtlfQuaUySP/AMOjIYjo0hAkvHtBRJP9IopwA8avQV3cCuPxw10?=
 =?us-ascii?Q?utOAPpAIv1bB5uBi6YEwmY16+zffEN5qN+nyoD+YFLtua2O951pFLZNePmeD?=
 =?us-ascii?Q?e3rc1dsNgsXPVfLLHfUZrMTGC+tHTEYwlEFMoEPZSWTMNq3hb1Vp0+zW5gDF?=
 =?us-ascii?Q?Da242xUFumAQ7YpC3OBGFGg4cXo06e8EXNQIeHPYRzGBkTYyPhuN4+cTf1A8?=
 =?us-ascii?Q?4BvI6ca+wAAQvaOzlwIDJEHMEXfIA5KElUMGgg72Io2vMYkWRnAhP70ZXnHC?=
 =?us-ascii?Q?sGL3NrsZiJ70mKmWdK0TKl0A3N//D5aOFdn/pJGmzVOBteLk7pLvZcRDvkB4?=
 =?us-ascii?Q?3JlEPKWSN+UjCdrBkFXfBQRD3JFTLF+T0i2IVMBFDfrgvkczGOjeqI5VeSmj?=
 =?us-ascii?Q?Rc6RBq/LXHJzOF1n15U0bi8XnxxbZsIdnS35g5ebIBtMmrdYrNuY17nkfXjZ?=
 =?us-ascii?Q?72p82iSu/bWvbqgggIYf4ukvnoSA/PXEFLpwS5Vcq4M3ovm8g9G2Vzx/lyy/?=
 =?us-ascii?Q?EzhwsLzGUwFH0KRoB/rCrxJXw4xKFebun9984t4RuilsPkh2NWgvbioxeQId?=
 =?us-ascii?Q?aeZoEaHskZgWdffKk4gWBRPfx8VUnxs0lL+xq1oEX/VS1OW8KtSr70LAUUpu?=
 =?us-ascii?Q?6kXDnsCCHbxvtoy5Usg/AeZZHsAkwElkwO9iB3FBLS1PjVRDXLYe0xLGYkvL?=
 =?us-ascii?Q?1KxFo5DSD+wvhvVrYsG+X4kC2JayoJ42rLi1duNxr1HaYe4XGNuxt/ndZlcu?=
 =?us-ascii?Q?O0NuSAjcf88tB7g7AM9C/7ZiyADDDShXqZ7UZz5JCUMIeHIMzoYLGCuqlfh0?=
 =?us-ascii?Q?4VMqh++dqEyXHNxz+Lcj+EllNAVvExm4ucVTPg1e8prmZ3oOWo4tDUl56ajW?=
 =?us-ascii?Q?ORNinWAz5mzIU7onE2LHlLQVXVO5ucWltw6xH54tH8kQdvIwQFOIE/f1JX8A?=
 =?us-ascii?Q?Xxh6I98G9nz+feT5Zpf/85e3mnw3T7p3pCLdkNFproHTD22D7ztEf2bFmoB1?=
 =?us-ascii?Q?OELxie1mSSQj9F7KWB1B6lB+MOQuiXHPbV82nWuVSGdE2ONV/AWJInfzt4oc?=
 =?us-ascii?Q?Y+R72jucziON2XSnMdKqxhAHy2X1oL157LAGmsWH/G+WtJVzVUdX5g40g0Ns?=
 =?us-ascii?Q?7nFK33Ch+JmFogT3+qb/0i5vs7pfyhTeheRk9VugnVCdwtE+iTq1K2+3GSQU?=
 =?us-ascii?Q?jNyHa5DoaQhTx6p1k6CzCzn/xKC4zi/UmQPxd5zOTTMGfFlaNFDMnuv62uMd?=
 =?us-ascii?Q?JV6OfkFX34WIXmDoaCvJi00rtMyTmV1tRwvTy2Qfp2NrDLTR/sfX4ws5PAd4?=
 =?us-ascii?Q?PRlLlh/nsY/8JlT5i8KZw+P4vEKNl9k3ujJIeJD1?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c3b003d-6e72-43aa-298b-08dd8985009d
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 May 2025 14:24:09.2337
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ImNjgVEOI5QnkfXBFqQAFXtjdZ80rlx80nPVRPLUJ8nZp26QGvpxRuqGLO/LPpIUCFHD4biwkwG/4Esmz2CUdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4559
X-OriginatorOrg: intel.com

David Hildenbrand wrote:
> On 01.05.25 20:10, Ira Weiny wrote:
> > Fuad Tabba wrote:
> >> The option KVM_GENERIC_PRIVATE_MEM enables populating a GPA range with
> >> guest data. Rename it to KVM_GENERIC_GMEM_POPULATE to make its purpose
> >> clearer.
> > 
> > I'm curious what generic means in this name?
> 
> That an architecture wants to use the generic version and not provide 
> it's own alternative implementation.
> 
> We frequently use that term in this context, see GENERIC_IOREMAP as one 
> example.

Ah ok.  Thanks.

Ira

> 
> -- 
> Cheers,
> 
> David / dhildenb
> 



