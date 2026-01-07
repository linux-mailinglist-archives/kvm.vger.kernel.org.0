Return-Path: <kvm+bounces-67208-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D70EDCFCC94
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 10:15:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8060D305CCFA
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 09:15:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C193B287517;
	Wed,  7 Jan 2026 09:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FMSzC42R"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B7F1235358;
	Wed,  7 Jan 2026 09:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767777298; cv=fail; b=AJVlpy2bPE3rNEoJfhbpaEySjkomrt1Hk+HznM4MR4sDtZqfeiVuW7r++R47xaKc8dWOZtAE4i6WDEwnxsxHEgWLu7hfMeBz90Fh/4HD8S9ondfcJnqxkgAwZvicOQbTCDzDzdhV8p3XlDUOYP2AgvLCG4Xlgont05hId2xqL2I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767777298; c=relaxed/simple;
	bh=3pLtCgH2vrb9zqzD5cv183LFpQCBdFo6meX9A8lpmWM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=QI1D3/io+FPtAtODK54BdaZ0Zu1T4zwVg7Hsmp1ZgCl9cbxFceHGP+uoR3Ss+Z05mvc1wu6v++scZkL5o4S2cpR/zCYTnkx03pZv/c4TusNh0cCaYtYTp4lxBMQwcsmagaIsYLRReC8uTctbd5PGqeioSxilbshkbVxtK9o/Bpc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FMSzC42R; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767777297; x=1799313297;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=3pLtCgH2vrb9zqzD5cv183LFpQCBdFo6meX9A8lpmWM=;
  b=FMSzC42R1tg/XROEqFWkq3CRIKp440fi5mDtpc+Z+ktdd09HcMc0z7nc
   wZieq5XzZju7BsAlvybk+eUq3sapIzXE6NCu10dl9+fq4+tc+f/w0MtFZ
   KKcvMZNQS0JGXbtxKsdFmEP3W7kRSvTOD5En03E/oFGy70EMy6sRmHHtz
   /rI116yL0VM6f8rZ5ohZSPSr/JoLJruOoLcJ8t9/sA+yyaFsCPEet9IHT
   VgyKIcfn93LvZbW0rZNSg/vNU4Y0WP+7MjTLf8+RtgwOiTF3R8vc9jHBm
   d0c5uf+drmkk4ZWf0omgb5XcNFe/wSJ2GPk0Z5l0hwugVQx6YcMnEOibb
   Q==;
X-CSE-ConnectionGUID: ntUdSHIzT8C9EVYyehDh1Q==
X-CSE-MsgGUID: 1cbtBkaySn6G6ikxVmUmGQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11663"; a="71719413"
X-IronPort-AV: E=Sophos;i="6.21,207,1763452800"; 
   d="scan'208";a="71719413"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2026 01:14:56 -0800
X-CSE-ConnectionGUID: CuomHYwcQyiwF0oCZlr8Iw==
X-CSE-MsgGUID: 4tCdU1vWSlSYwa6HoxWSGg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,207,1763452800"; 
   d="scan'208";a="226382132"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2026 01:14:56 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 7 Jan 2026 01:14:55 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 7 Jan 2026 01:14:55 -0800
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.36) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 7 Jan 2026 01:14:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sJa/jXQlZDqxvsrkwrdHYV4GHSWmAKXSwTO0FyOiGnDC63mVCnERpzhYnm7FeTrLKfyRcQw5/WUAnQdJ+3uS5MYhE6898ns1ofa6GnQPkaVkEra0s0WcB7i+NsImfzhrwxLJMStRZFuyuIYwp1tYs/tDiUtOc1B5LXJoEyGZR+1Zo8KUnZJPlcpNfi++h6Lyy2s3UO5dBvGP1SJMW0w6QkqBu7wTmu1wtFE11I65gMpoCVdolrpgjTf+4svXgD7YEfFElEaAbFje4JrPWXrTrH1AEIHic0cWRKdKWgZiubSo/xmobAkwVvEDOVXfHo51zu0Y5mTUi6dC3Tq3nHYgog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pAkVmDDdAVwvvjOuLwI4NiDJQnlzOVo8yH9J7+Nmdrk=;
 b=QCfqw1tY8bzfqCtbESlLXhsXK/3C8CYsRIwlYeySBBE4g0JtKRL2OWSaShNXbSbQKiRvnfYZ2ayn4IyLolOXGBFqFsXPa4Wj8IHSURLO0YGuaMWWUk2lRrf2fuUaRobEGRKLbyzQRTpiDEfYgdfGmowHPKTGSbyLGAaT955W4GLpDMh5+5hHIDNAdoWrjfryeFoda+T7eCdJj7nYHQIE0uvdusTYR/kyr2Pmv7QHWJeqP35Ad5VlAtkPh9Kk9kzMHVhR3SXeZSjjcc5EQ4/1h9a/FiiHFaVebOT3GYvvhb3ElchFE4BiV8h5Q3hRHQULlYWxTSmFx4qG00VqUiSIMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 MW4PR11MB6839.namprd11.prod.outlook.com (2603:10b6:303:220::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.5; Wed, 7 Jan
 2026 09:14:53 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9478.004; Wed, 7 Jan 2026
 09:14:52 +0000
Date: Wed, 7 Jan 2026 17:12:42 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Dave Hansen <dave.hansen@intel.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<rick.p.edgecombe@intel.com>, <kas@kernel.org>, <tabba@google.com>,
	<ackerleytng@google.com>, <michael.roth@amd.com>, <david@kernel.org>,
	<vannapurve@google.com>, <sagis@google.com>, <vbabka@suse.cz>,
	<thomas.lendacky@amd.com>, <nik.borisov@suse.com>, <pgonda@google.com>,
	<fan.du@intel.com>, <jun.miao@intel.com>, <francescolavra.fl@gmail.com>,
	<jgross@suse.com>, <ira.weiny@intel.com>, <isaku.yamahata@intel.com>,
	<xiaoyao.li@intel.com>, <kai.huang@intel.com>, <binbin.wu@linux.intel.com>,
	<chao.p.peng@intel.com>, <chao.gao@intel.com>
Subject: Re: [PATCH v3 01/24] x86/tdx: Enhance tdh_mem_page_aug() to support
 huge pages
Message-ID: <aV4jihx/MHOl0+v6@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260106101646.24809-1-yan.y.zhao@intel.com>
 <20260106101826.24870-1-yan.y.zhao@intel.com>
 <c79e4667-6312-486e-9d55-0894b5e7dc68@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <c79e4667-6312-486e-9d55-0894b5e7dc68@intel.com>
X-ClientProxiedBy: SI2PR02CA0037.apcprd02.prod.outlook.com
 (2603:1096:4:196::8) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|MW4PR11MB6839:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c1b4555-474c-4d87-600a-08de4dcd3766
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?+38SEWf4i6fiSg6fSj5r40VtBASoY3xGioglxmIrAluC1z+KAtq+gDENOQ18?=
 =?us-ascii?Q?0RYHDWDtEghFFFRGM8krekP44yw92tgOjXsDsUjIqx0lE2Ar+W8S8nAowuzC?=
 =?us-ascii?Q?soGdi80F4SHmnbDegQalZJpRJCM6Y1yl17Mt6xURPBJXh5C/4gEBJSM2ERVW?=
 =?us-ascii?Q?dr50233qhgEe0sxasqS6ETuvjFqJe65SGEHfQ6/C+RHuPZDI0p4Zj8Y95L9P?=
 =?us-ascii?Q?b94ZkmklxaygjrfC5G/PbXYV7kmx40aZbho+OW5YBUWqgnOH1+780zRHjscl?=
 =?us-ascii?Q?CcJyxa5G0igvBg5WPfGRslLxJB83qCupxKTDGnjeOaqXVHt6OX/j02yWNhK5?=
 =?us-ascii?Q?7qJZBf0wr2+AVNLflNwfS1f6hhQ3kxGkOs5p8KH2DtsYdlV1oc4VCdPzWrdP?=
 =?us-ascii?Q?oDjMUKLtKboVNZ968nWJzjT9yhT8tLIuDZUmd46tBseWMQ+1InW0u0pqGtyt?=
 =?us-ascii?Q?FAoo37GY6nPIdGjHwWB6yqRPKqCzaLnVXKA2dvHuc1u2WCAgCFniCh2oIkG5?=
 =?us-ascii?Q?DvkH7/Ely6ehMn1szimHFOsuoV9w6WWj2Qea1zEQ0X11K0/O5UbkAvE2daaM?=
 =?us-ascii?Q?5xhmIRSieJjkgiyE567rjOzi22Lhv0toQyziZAYmnDHlL3MhGft5oaIJnQr4?=
 =?us-ascii?Q?AtHdvHzWaGhvmLbjl9xFsgaHFTnh/gz8Ej23dQgotyRDpt5EpmuwsFjSlIjM?=
 =?us-ascii?Q?1KlE5h0YBU+suq+1WTZR88TV1sdbzX1FzVnTJPH1ZPas5/RVMFXuGjsZIdqr?=
 =?us-ascii?Q?p1r8utRMXpETdbHCiFixUEyQ9vcOI7rUrwfJwmKL9UXowf0iPe4cZ7w016cZ?=
 =?us-ascii?Q?PMNGQJQE3PfP2xfPbvFzYhfPPfztVdzQFDkrNssA6FP9TnnVphb77F4sRqzx?=
 =?us-ascii?Q?baTJQ/Z1CChwbPLkdFshfJuK7DUuPexl+kz7mZD+B0Uvvp6qUTXl/rehew5S?=
 =?us-ascii?Q?NxG2/bl8YBQGKCDOACgLyTWMw3F39Ri1DfWehtCdvbci/k6aC/6XSS6gORgY?=
 =?us-ascii?Q?oQT92MgV79LkI3lZMf4n3xcgZqG6ry2CNS6s+XH8oQtF2vwaeMPOHRzYbOyB?=
 =?us-ascii?Q?HbV8ukhlZZvupiLoGrMthcCcZD3ZMcR7QjR3EPWCkhq0M4ZijqDUttaiOpbp?=
 =?us-ascii?Q?6Dyyv1bWZ8y8jd9RoyeUWnYNLNEbTcOsH76qi57MK9SAvvzfYfVVHSltW98d?=
 =?us-ascii?Q?g/hIGLy6EPx7JV6+Uw+fJB407sm58s/INZOJOfTBcigMCTI7l1n/D5gYDrvI?=
 =?us-ascii?Q?HAK/bt2Kinkh1aLZlm9mmDGZuNrJlJRAXuzIeIa1HMSTcaVEpxHFNmLez2w4?=
 =?us-ascii?Q?aZEQxqtF/yU+srcJi1I4zzBDRhCCkn9pmZTeX9LBrRLjbcr1DzftbGfgoMhf?=
 =?us-ascii?Q?GsxSWuHHeBDnBImvEIESudZ7panlWH1TLzt7uheLK9KVqAlg5a+I2veMH2C+?=
 =?us-ascii?Q?H55aF5I0uow6oDa0p+aeq54pddhD1LPMlCNOYtyawzOWvQcbk0mGWg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rPZ6e/l3M9+tw94xjgh3IkgyKd/UH88kWVIE8pymMORWE3ourol8iowEmVhG?=
 =?us-ascii?Q?AEllfA++82vDe8JJvkwsmgZIidJEoanrR9HocMlx8eRYEGVB5PEtcFD8Q0pZ?=
 =?us-ascii?Q?hcb83/ZG+ox4p8EstRhXiTUwVqIKIH0AgmlNKr+XMA10rvhF30plR1D1mTAk?=
 =?us-ascii?Q?a3F3XxCQtms8d+B+R0CB5nTzg8/6V2aeyFtBquJTd9Do499bWPcNfMUyBfS2?=
 =?us-ascii?Q?146NF6Vog2t4lPR0t/QHnz69G5dYFBrpBsIP6TXMsK74bPvqZBUa8HDH5IBS?=
 =?us-ascii?Q?/EmudoakvV3whDlcuJ1n4QGZetoYZDp23M0T0eFk9Ycsf+UN6I3WMz/+wYU0?=
 =?us-ascii?Q?9vZFsoJ6I991BFwLWOzX5ZFj3V+cuaVhh0k1oHFmYwpXcFoueoKYxv3Qdgjp?=
 =?us-ascii?Q?y9NOla997KEVx8ZeqC7QonDp901gUaiEWQLtfEBdu/mqqm2Dhngr02/pSclk?=
 =?us-ascii?Q?RFZlO2COsIjpdgpRtFZB5Vuwa6TvHJTEM3LzLnDgEIeWDBA8Tq2HocfrClU/?=
 =?us-ascii?Q?Loy1yhXnehOJNTxOPdf2mzHSSjP5luFr6BcRcBK090UnxTKLuTvgYuaMJWjc?=
 =?us-ascii?Q?TMxKaslNbCtaCpPoSZ59q3nTYkxAElS52pgqaX0bT4KeO18CEo/E6A22gTFd?=
 =?us-ascii?Q?yldR426Igp1gmQWAEKUe/1PYoS6y9SZ9JfKUvkyG85Y/BG/X3UC0GDpzeEK0?=
 =?us-ascii?Q?+e4PhTztPlCbFoUo8CN7SITzODiuctFGqTbOxtNnvNbOwoOfX5HgouA39nKC?=
 =?us-ascii?Q?64xqHmfyRxk6JzZk5KM+GpfqUxai8Z7k+BTuay+yUZ+2nH3WncrkDwbJkawN?=
 =?us-ascii?Q?IQfZkAk5FyeerV7+uQhkdaGqRvAfNTRmti5W/pcPa4MENejo6F1B2DfBZBRl?=
 =?us-ascii?Q?ctWRBQfKNGOXZPbzTDzqeHCSuNNFnYPfrPQhhkNEDL6puLmnBz0cAsPgA4sg?=
 =?us-ascii?Q?opAK0toDFQ0243vBElVac7X31hrn2j9PAAYOfCPbzjk57oitXPHd6q0ZIPRV?=
 =?us-ascii?Q?NuHJdusj9eAqn3z4/8OefQDXej36g1I8PAUTIZzmvPlclvbducPqln2kS3sB?=
 =?us-ascii?Q?5USd4R6VuwKbdSE4Sdy/bQXCIXsyVrGsiUm/NCf6f+Pzjc4yWP9PzOrL5LwP?=
 =?us-ascii?Q?T1WWGPsFnSCi+0d8327E0CNjUkTAYLr57ks7N3uBudk2r3Cdl33MunivNWwt?=
 =?us-ascii?Q?7OimYQMmM+Ul+6ISUg09VKBwADEba8DSQLR14UISDtVUFAw3NNUdgPXFn8Gr?=
 =?us-ascii?Q?l5ftwR9+mLRpqrB8+XkiFwJ4IzLvw+g4clneQAgeOzKWfixB3lzPXHJd5Ex8?=
 =?us-ascii?Q?vjsWejQsja5hFEhJ3oXrfYkMC0NWz+i+r7Bx7ozo5FcTBSFfGqnx0MncynxH?=
 =?us-ascii?Q?Q3QNoYOAl+Gw2IzgyIlHoldSR1uTbM6F1Du18RJ2w20r6TBoWMrbmBVAjxOE?=
 =?us-ascii?Q?GrQTz7sgJQeMjJbT3KxhfLwEv8lKJM2AmTAkIKMFWKCLuCzXy/tm+JS0ITRf?=
 =?us-ascii?Q?M7WvWvZBXr7m93S7vjrVXnwbgfMwFG6n9wy0dxkUwVZoOOgjhLomcZXHEMSN?=
 =?us-ascii?Q?l9+ND0obFZv6bH9C9VNnnMPqRrwvyRXu5ishYkAnCFxlMLg1USJ+o2Iq60dt?=
 =?us-ascii?Q?uD2liweJ3lmJSDZinCQbc/cutpIp4wd1Mfr8eR0yU6cYltprXP+cipAgvVL6?=
 =?us-ascii?Q?hbhVaqEhgXjPVTJVxKMsd3hrhajfyPOUHM5i3EEbDBJHKfX3VHnwa1PsVegC?=
 =?us-ascii?Q?3ThF2Llvsw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c1b4555-474c-4d87-600a-08de4dcd3766
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2026 09:14:52.7943
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7gVfcjVnALfvKj9nBfKqhbCdY2YZxy5k00YUOxFtV3eK5BMxDP/j80a11skGd+wO7rr7TglS1wnSWHGuuzKT8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6839
X-OriginatorOrg: intel.com

Hi Dave

Thanks for the review!

On Tue, Jan 06, 2026 at 01:08:00PM -0800, Dave Hansen wrote:
> On 1/6/26 02:18, Yan Zhao wrote:
> > Enhance the SEAMCALL wrapper tdh_mem_page_aug() to support huge pages.
> > 
> > The SEAMCALL TDH_MEM_PAGE_AUG currently supports adding physical memory to
> > the S-EPT up to 2MB in size.
> > 
> > While keeping the "level" parameter in the tdh_mem_page_aug() wrapper to
> > allow callers to specify the physical memory size, introduce the parameters
> > "folio" and "start_idx" to specify the physical memory starting from the
> > page at "start_idx" within the "folio". The specified physical memory must
> > be fully contained within a single folio.
> > 
> > Invoke tdx_clflush_page() for each 4KB segment of the physical memory being
> > added. tdx_clflush_page() performs CLFLUSH operations conservatively to
> > prevent dirty cache lines from writing back later and corrupting TD memory.
> 
> This changelog is heavy on the "what" and weak on the "why". It's not
> telling me what I need to know.
Indeed. I missed that. I'll keep it in mind. Thanks!

> > +	struct folio *folio = page_folio(page);
> >  	gpa_t gpa = gfn_to_gpa(gfn);
> >  	u64 entry, level_state;
> >  	u64 err;
> >  
> > -	err = tdh_mem_page_aug(&kvm_tdx->td, gpa, tdx_level, page, &entry, &level_state);
> > -
> > +	err = tdh_mem_page_aug(&kvm_tdx->td, gpa, tdx_level, folio,
> > +			       folio_page_idx(folio, page), &entry, &level_state);
> >  	if (unlikely(IS_TDX_OPERAND_BUSY(err)))
> >  		return -EBUSY;
> 
> For example, 'folio' is able to be trivially derived from page. Yet,
> this removes the 'page' argument and replaces it with 'folio' _and_
> another value which can be derived from 'page'.
> 
> This looks superficially like an illogical change. *Why* was this done?
Sorry for missing the "why".

I think we can alternatively derive "folio" and "start_idx" from "page" inside
the wrapper tdh_mem_page_aug() for huge pages.

However, my understanding is that it's better for functions expecting huge pages
to explicitly receive "folio" instead of "page". This way, people can tell from
a function's declaration what the function expects. Is this understanding
correct?

Passing "start_idx" along with "folio" is due to the requirement of mapping only
a sub-range of a huge folio. e.g., we allow creating a 2MB mapping starting from
the nth idx of a 1GB folio.

On the other hand, if we instead pass "page" to tdh_mem_page_aug() for huge
pages and have tdh_mem_page_aug() internally convert it to "folio" and
"start_idx", it makes me wonder if we could have previously just passed "pfn" to
tdh_mem_page_aug() and had tdh_mem_page_aug() convert it to "page".

> > diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> > index b0b33f606c11..41ce18619ffc 100644
> > --- a/arch/x86/virt/vmx/tdx/tdx.c
> > +++ b/arch/x86/virt/vmx/tdx/tdx.c
> > @@ -1743,16 +1743,23 @@ u64 tdh_vp_addcx(struct tdx_vp *vp, struct page *tdcx_page)
> >  }
> >  EXPORT_SYMBOL_GPL(tdh_vp_addcx);
> >  
> > -u64 tdh_mem_page_aug(struct tdx_td *td, u64 gpa, int level, struct page *page, u64 *ext_err1, u64 *ext_err2)
> > +u64 tdh_mem_page_aug(struct tdx_td *td, u64 gpa, int level, struct folio *folio,
> > +		     unsigned long start_idx, u64 *ext_err1, u64 *ext_err2)
> >  {
> >  	struct tdx_module_args args = {
> >  		.rcx = gpa | level,
> >  		.rdx = tdx_tdr_pa(td),
> > -		.r8 = page_to_phys(page),
> > +		.r8 = page_to_phys(folio_page(folio, start_idx)),
> >  	};
> > +	unsigned long npages = 1 << (level * PTE_SHIFT);
> >  	u64 ret;
> 
> This 'npages' calculation is not obviously correct. It's not clear what
> "level" is or what values it should have.
> 
> This is precisely the kind of place to deploy a helper that explains
> what is going on.
Will do. Thanks for pointing it out!

> > -	tdx_clflush_page(page);
> > +	if (start_idx + npages > folio_nr_pages(folio))
> > +		return TDX_OPERAND_INVALID;
> 
> Why is this necessary? Would it be a bug if this happens?
This sanity check is due to the requirement in KVM that mapping size should be
no larger than the backend folio size, which ensures the mapping pages are
physically contiguous with homogeneous page attributes. (See the discussion
about "EPT mapping size and folio size" in thread [1]).

Failure of the sanity check could only be due to bugs in the caller (KVM). I
didn't convert the sanity check to an assertion because there's already a
TDX_BUG_ON_2() on error following the invocation of tdh_mem_page_aug() in KVM.

Also, there's no alignment checking because SEAMCALL TDH_MEM_PAGE_AUG() would
fail with a misaligned base PFN.

[1] https://lore.kernel.org/all/aV2A39fXgzuM4Toa@google.com/

> > +	for (int i = 0; i < npages; i++)
> > +		tdx_clflush_page(folio_page(folio, start_idx + i));
> 
> All of the page<->folio conversions are kinda hurting my brain. I think
> we need to decide what the canonical type for these things is in TDX, do
> the conversion once, and stick with it.
Got it!

Since passing in base "page" or base "pfn" may still require the
wrappers/helpers to internally convert them to "folio" for sanity checks, could
we decide that "folio" and "start_idx" are the canonical params for functions
expecting huge pages? Or do you prefer KVM to do the sanity check by itself?

