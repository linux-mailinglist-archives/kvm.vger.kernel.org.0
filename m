Return-Path: <kvm+bounces-68600-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D0B6D3C377
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 10:29:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id F1A066A2DE5
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 09:23:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC5963D3CF3;
	Tue, 20 Jan 2026 09:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="POQQCxam"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12C93D3318;
	Tue, 20 Jan 2026 09:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768900871; cv=fail; b=lD4Fzp3A2F01KbAN4ASmFf/Oe6JbqvoXLz9s9yGTSKrO//dt97Ztw9W84ZPnh1QMeXK5BsEzQjtq1BRNaRYjCcXJx5TADunmhzSu+e4tPo/EVhh9zXu4JQwL+eYZ3bl/I/LOnT1FYgrxL+TMfMzM8ZMO6xvpUXJvCzNo7zOpOlI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768900871; c=relaxed/simple;
	bh=o21mBXLZkdjiivg90Q2gdQM6TKsNOOzXueXUU/uC8T4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=uVSW0LweBQYVyH77kAvCwNoaLcpgEMm3s11BO/7NbPHBeN3tEaloY46MTTyfuttBc8IP0fNGLeraMyUZ223D6dx2qF14G7NLITB4O5y6lmP4FHLMrowd48UIOkMzmGt2qpLKzpQzYUq+aWLRXO2gjSejCDL+qIHZY25B1QMtmw4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=POQQCxam; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768900869; x=1800436869;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=o21mBXLZkdjiivg90Q2gdQM6TKsNOOzXueXUU/uC8T4=;
  b=POQQCxamOt+k3NMRARgSzB0pE+e9bo2E6x6n8xeuCrK0+TJKzNPNLa1w
   /M/p78hz36PAOwH49+CKKdFUwLzx9RfOo/axk6eGSzpba3r5BdiA1ey9C
   w9gQl1ZKt5UVtA8MkzMqJC56nmwRU/G/RkGGdqt9wMJl+GQbSWCdrnqs2
   kEd8c2xoOv3xVU60dtnRHuaTd6YAOInvCxzTMn+1jTZarnLrCPCtZO0gV
   NwPp2UrYvF24C4SVEN/c6YIdg6EBkZjHHT9R6uwD7RuHX5aRfVDY9N9wY
   vb0mv8gn9jj6yjUzpoDuvpDgJpZZi7zwDZOVSMQY3jFtuOFQFcg5noPT+
   Q==;
X-CSE-ConnectionGUID: 1kIlwQ+QTE++AdRvHOsJSA==
X-CSE-MsgGUID: 2DUxYjuJTZ6du9vuqvuWuw==
X-IronPort-AV: E=McAfee;i="6800,10657,11676"; a="70191710"
X-IronPort-AV: E=Sophos;i="6.21,240,1763452800"; 
   d="scan'208";a="70191710"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 01:21:08 -0800
X-CSE-ConnectionGUID: Y2GuULWCTcm8EpATCrbtFQ==
X-CSE-MsgGUID: zqpm48zeRBObJRW0hr8C9A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,240,1763452800"; 
   d="scan'208";a="206331108"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2026 01:21:08 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 20 Jan 2026 01:21:07 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 20 Jan 2026 01:21:07 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.35) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 20 Jan 2026 01:21:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s5V03mjb9BDMgW7d6gayelR82MbcucFwsw6V296yLSKaBXyCNfJOdW+5arlK5FXbLuSFlNsjXhJRchj7sJWvDM/XQn9Pveo20qMSnfYHOk2e+F3h1Fy1KKfHuFsCjReS4m0CyYwzramFjwBn2/UeRRAxae9eT8on9UCrIZX7CPfiOAwMtWDyJ8DUZT0CvpR8G6Kp54jJMMZqe/OjbolGYD8iVNPpw2iDMNs6xiELV/1ZmVyTWDEanF623t5JrieUV2Y11d2sQj7cMzXFSzcQcS+U/1fxrrSejVCc0YjppoVvPO+1WK7YqrikgwdEdazeDq2aXE54GX//slWtwlabSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2L2nLhHB0mOy2JNyXegQkLhrVSN3njqa9C+IWpmN6FQ=;
 b=V1wyeFG9VfBjrqP5Zm//wFv8fb0645Qh/YIGerZ0TpUvNNdGP6EWYUq2SPTiageWXVOfeWQw9k2vuvN+3mjUATKo0HnNyF/2po3udaqhmfl6jjZgPZ+g5WYTNs92JEM0iZlClWgQvzdklVdw7QCW2qK2MHYgM+xZL/IVRaLoTf+u6ZRo70M7xrv0wDeovZhe1pXYrCiildnr8p8KxokH6Hm3f6A6/ya3O3Af4uzAoH7fTkPk65z3ezE+6su++iZQ/bYK8RwwKKCCHeXKxGCfAfLj5zh0nEC7nIwI6ggVFI81yyMinm13N8WYpx+4ybkffGJ8Mnf1LoMFH6HWVMaHeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA0PR11MB4687.namprd11.prod.outlook.com (2603:10b6:806:96::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.9; Tue, 20 Jan 2026 09:21:04 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2%4]) with mapi id 15.20.9520.011; Tue, 20 Jan 2026
 09:21:04 +0000
Date: Tue, 20 Jan 2026 17:18:50 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Hansen,
 Dave" <dave.hansen@intel.com>, "Wu, Binbin" <binbin.wu@intel.com>,
	"kas@kernel.org" <kas@kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Annapurve, Vishal" <vannapurve@google.com>, "Gao, Chao"
	<chao.gao@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v4 11/16] KVM: TDX: Add x86 ops for external spt cache
Message-ID: <aW9IetVmF3pIVFRl@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
 <20251121005125.417831-12-rick.p.edgecombe@intel.com>
 <aWrdpZCCDDAffZRM@google.com>
 <aW2XfpmV7FqO2HpA@yzhao56-desk.sh.intel.com>
 <ecf01cf908570ca0a7b2d2fc712dc96146f48571.camel@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ecf01cf908570ca0a7b2d2fc712dc96146f48571.camel@intel.com>
X-ClientProxiedBy: SI2PR02CA0030.apcprd02.prod.outlook.com
 (2603:1096:4:195::17) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA0PR11MB4687:EE_
X-MS-Office365-Filtering-Correlation-Id: 30bb175b-7421-49c0-7342-08de58053c41
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?UDV1VVlWWEZwM0ZyMlhnTUpNeHVzN1ltTEN4eDA5d3BzWmhTWStOaDltdFZW?=
 =?utf-8?B?OUxBNEpka1ZmZVhaTkt2L2VuTG1RbkR4VUtvLzB4a0NtU2szUllWYW5oWHVT?=
 =?utf-8?B?QnFoNXNFMEhaNUl4aDFBMWpOc3FCRktZMzJnRE4ycGFLaWQ3UDdQejdnRmhv?=
 =?utf-8?B?N0xlWlJqT2t5UTNiN0FqUEQrb3RFUFltc2QwVlArNDJqQ0hZV1NqdWxMU1JI?=
 =?utf-8?B?VVEyV3lMbDZtL2lqeHAvRWxqejJ3R2kwR3MzdkcvQkI3YVIzbVVyQUFVbkJY?=
 =?utf-8?B?WnphVmdOZVNuNEJCS1d4bmRxbmM0R25rM1g1VXBDUk1BeW9ySE5xVUNtZmRC?=
 =?utf-8?B?NEFKNjVNdjFxcDlRTHBlTEx6QUF5dm5iTnE2OWgrMTdPQlhJTWdFRjhhUm0y?=
 =?utf-8?B?YWFiZTRSZmJYbHI1MjBWb0lXYkNsMzJmRVkvd0F1RnduYVVaeC9yVGRoK3hr?=
 =?utf-8?B?M1VyTm1MNlJQb1Y3eERzVUZMY1VvZGZHR0JhVE5pSmd4dkVFTCt6eFdiSCtP?=
 =?utf-8?B?YjA2U2JpYnVUd0tVTWcwMERnVTY4M1VpOXA3UmtUWllMcVQrQi9KQXhFeldq?=
 =?utf-8?B?bURhZzZ5YTFPSmg0OGg3bUdqaExVR1dTVCtvRDNkakFUNjZBYng1QjBLUDd6?=
 =?utf-8?B?QjdMd3pmUFlrc3lWV1JTWmNsUmRLaDZjYUVTS0ZrK05ZUWs1MGg5eGlMSDdY?=
 =?utf-8?B?bVJ3TEY1b0JkVzU4NGFYaGRZWVN4SWxzaTdKOCtjR2p0MnRLL0NzZStoT2lQ?=
 =?utf-8?B?bVNEQ3pldWh2OVdVemxGZll5bXNVS0prTlcvL1dEZklmUlRxd3ZvSzYralBE?=
 =?utf-8?B?enEwVU5ndWZmYy9wK2t2M0QwRzBzRlJlUWxtTUtPNTcwd09xblBWOVhTbDZZ?=
 =?utf-8?B?OEUySXF3MHZsQ0dRbkpvclhUM0NkUnZpNFhDS0djSk96RUtJSGVTYVkxQXVp?=
 =?utf-8?B?UXl0Y3c3b0xzVDFmTEFRNStKQjR1dzU5MnJQRHBjRThhb2FEajVOUWg2Z0tx?=
 =?utf-8?B?ZW80SFVhZDEwMWp2MzVEVWxKTWNDY1dwYXhYZkZpQkY4NEpFMXFVNUdXMGM5?=
 =?utf-8?B?RFdyV2E3cTVYam12QjdHMHpNZlhjanQzVFNySHdQWVRDVWZSWTVmVGxZT1lh?=
 =?utf-8?B?dDNINmtSbnRuR2RXaCtsUGVSb1VOR25DU3RtZnUrVjhVd3NGU1JvZ2F4UjBE?=
 =?utf-8?B?ckpOR1hhdW1uVG56UmRRaFVKZTN6MkN6YmxWdnZsOEVVYnFkOURZeU1sd2FD?=
 =?utf-8?B?VndlaFdkdU5YRThlOGQyQlZyS3V4VkZIZlZQQ3IzdHVWbzJpSkU1VkhYYVd4?=
 =?utf-8?B?SHhnNG5XdWlScHBDalZiM3ZXcmVWK2R5QlF1Y1pEdUsvWEJSVDBjREZnbFQ3?=
 =?utf-8?B?clBOVkVMMW1aQzh1Und1dXlIK3dFN3V5UGp1T2hTQVdOL3RUMFVLL3FVUU9s?=
 =?utf-8?B?YlJFc3UwbGc3OWlrQ1lXZysrQnFpcURCeS9tcERNUk9FTTY5c2w4eHNWUDVN?=
 =?utf-8?B?amhBc2drT1hsT3F0ZEl5TFZTYkFGeGdEMTdKRHhwNG43WWNkTHMzSkxwWG80?=
 =?utf-8?B?dGJsMUZTaFN6ajJ6ZWNCb25vbm5LMThXWnZvbVlHcUx5UmQzbDJaS0kyRDAr?=
 =?utf-8?B?cER0NkI4R3FCV1MrVTJvejJTTDBuY2VMZ2I4em9JMmNLbnBOZmExSEpkUVJx?=
 =?utf-8?B?MDdZSEE1bnE3K04zMzhCMko0RkJYNnMyeDR2UG9oMXNWemVqc2dSWjB6QnB1?=
 =?utf-8?B?aDlJeTRzZHFBTEl6RDhZV3JIWTN5ZUIyakpSRGozK1RqaXRLMUxvVzYyQXRE?=
 =?utf-8?B?cTU4L1BWYk4xRFBBa0VaZmlHc3Q3RUpNTXFZNmt1MVBId3JFY2ZOTVBRa2Z2?=
 =?utf-8?B?Ull6NXhwSUV3aW1iRE1NeGNFVzE0WVRqU3lOV004a1hNbU45WkJ1eDhwZW00?=
 =?utf-8?B?VnkxckNGbi9TMWY3QXZoeDhyRlZObHYyN3BybENlU2pRRkFxNTBaTUt1Um4y?=
 =?utf-8?B?NGhGK2lIQjNmV21ETktRL3lFQlZkcUFJNHRYRDVsMFhHSDQ2Vnd0Kyt5Yy9P?=
 =?utf-8?B?dHEzblFXQytkMVNnMDVxQXUxbEZsOTliQzNUekpkejVyVU1lQnhsRmF3L0RX?=
 =?utf-8?Q?01co=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MDdhQ2dkZEw1d0tzNlE1cHRlR3ZrSHNHdWgxbENxZWdLNXY1ZUV4ajU2M3RO?=
 =?utf-8?B?dlh2NGZleTFSU1A5aWtYU3ZuMlgrUzY1MkQxUmg3MlBTait6ZElweisyODkx?=
 =?utf-8?B?cUV2bzNRMEM4cml3N0l2UU5nVk9NdVF1Vzc2U2FuZkhOc3VicTBiTVVISFBl?=
 =?utf-8?B?dlN3MkhocndnT2Erc3dYclNDaERqSHgzb1U2Y08wQzFib1laa1ZYNFYxeG0w?=
 =?utf-8?B?SnYxODRCUGg3M3BsNnRiN2U1R213VitsWU1TRG4vbmt5MFhxOTNsT1plUzVE?=
 =?utf-8?B?b0NiOGpnempyZXFNckltV09hQThBM1pXa3BZRkFtME9FaDUwbFhQRTZSNTRW?=
 =?utf-8?B?K1hMKzdMMTM2L29ZWHhkdVphWEVuTXZ0MmRMakFROEJCbUhRaDFZdFkrczRU?=
 =?utf-8?B?NTJWYTVKY0FOMTdxaXN2Tk15Q2dlMUViSTJMTGd4eFp4UHQ2VDJpbStpU0FU?=
 =?utf-8?B?dUc4QU5Iamd2SGlxMkUrbkVjT2Z3N1FvSWtnbW83d0t4Kyt6VWlZVkNDSnll?=
 =?utf-8?B?Z0NoU1VIYzArZXRTclpCeFFScUt2NlZrRE0wQ3lrWGpiL0tBUXJKQVlVdFBN?=
 =?utf-8?B?aHkyVEVyb01jeDYxMTFWYUErMyt5Z3hQelZyRmtPL0IwMTFQV2tBT3phUVdQ?=
 =?utf-8?B?Q2hlQTVwTnNSamhlZWR6RnNGeDI5ZjcwN3c4UXcwQU1QS3pqc0swQkFJekVL?=
 =?utf-8?B?MTFRdWcyNlR6VU5jdUlwdU1temJ2U3lMc2h2RFRIMU5Xa1VKSEdabjRNSGVR?=
 =?utf-8?B?bnR1dkJwM295WHJobEtGWmFib0VQZmNXNVlxb0ZQUlkrbVp1RklCMCtwdEZI?=
 =?utf-8?B?NzJZWXBnWWhLTE1ORkJUbDFsV3ZYSlRxTEhjZ0RQYzEwQVkyNDlaZVUrMnNv?=
 =?utf-8?B?ZkJVU200MWNDU3VVaUdzV0N0ZGp0VHhnbkFyaUJjTmhBbzA2ZGUzN0tqR052?=
 =?utf-8?B?eFJRd1Zhb1dEZm1hQ3MwQ05IM3JPeS8xYjRJUUR0emNVUys4WDlQYW9vK1dD?=
 =?utf-8?B?TTlKOUQ4WVFnMXQvT3g0eGhxam04clhDcTlMd1FxVWpnZEp1R1RXNXRmeTY5?=
 =?utf-8?B?MEhlYityS2QrRmdFQU02dFI5aU5ydHhlMHVIbG11alpGMkpHMlY0MWRHeU9h?=
 =?utf-8?B?R3BhckVSWjNvT0RhT3o1aFhqYkwzYUpnaWV5TmcwQ2lFOXlIUi9vR2Y4SCtJ?=
 =?utf-8?B?NC9ScXEzVG1Vb2xFc3MvdG12YStSdHE4VVhjN1RVOWcrZ1llWUlxcVY5anNZ?=
 =?utf-8?B?QlFndFZDUHV6dXNTMGtmaE1NYkNVaENDUmxkb0hBaEF3ZndldWxuT3ZYajk5?=
 =?utf-8?B?RUhDaXBseWJQcWEvSGZZS3NrNVhSQlcyNVpLMU9EcVZ3RHdZbGVoSEhvQnpB?=
 =?utf-8?B?WXYzSGo4dEkxMVpTOU1CSElKVm1TWks2cFhxN2JRYXVzZUFWV2haL0FETk1N?=
 =?utf-8?B?dE8yZnJPQXZ5MzdLeHFhNklWbGo3TW01RTMwREhXV0FRSHdlRlZob0M5cTRG?=
 =?utf-8?B?VkgyaGo0VngzWFN6KzBhTWFES29TRWFveUZQbkR5amlYL0t2VzJvZHhPaUtj?=
 =?utf-8?B?WSs0KzhuN3h3MDNKcEloUThFNzVWSFZQL0RYZXdUSDFuQU1FUHdiVURLUmR3?=
 =?utf-8?B?UTBBZFJkSDAvait3SXJ1Mmp1WndjM0VScU9SbFJnaG1TMlJGWldmWUdtWHV5?=
 =?utf-8?B?Yit0c0QyZFgwTkVMTFErSEk4SHBiOVorT045WUxxYU9Bb2ZoUXh1SjVuM01Z?=
 =?utf-8?B?dGJhN1V4MW93UDlGWnhjNnNteHdscFo3MkVYVllEdC90dHNHL05JbWlaWWhi?=
 =?utf-8?B?SHZwZElEMGdFcU12dzV4N3pCL1lUb2U1ZlBVaFJHMXk0RyszNStyaE5DUTFy?=
 =?utf-8?B?QStFV1FrVVNBUTkvUzJ3eTF4bTMwcWhMcEhiTHZGZUNINjJxMDZzRzI1emhO?=
 =?utf-8?B?Q2xYejhmb1IvQk9VZENXRmp0NEt1UElhWko1UG05dEx2QjRkTmcxbDdCOTBU?=
 =?utf-8?B?WGdrbVhpSDFUd2xBcGgwWjB2amNWaVJ2YnJvbGY1UzFteEtiMUJaUUZ0a3B2?=
 =?utf-8?B?RFJicy81RmdtYTRHZElndGVtZi9VWlliMzRaZjFLTkovbWlQcElrZWxzajFn?=
 =?utf-8?B?ZUxHTk94eWJsVGM5WkV2SFkyNVJtamRqa0tFMm1LSnhuMHlPMGtkQ0RIR3Qy?=
 =?utf-8?B?QzJXSW52bjJuS0U1dlROSjZ2STU3QVJ3K2MwY3Y3Zk95NGlqSkpVNFI0ampL?=
 =?utf-8?B?NUYxb21ILzZVUTlFWTJCVTZsbldPb2VKd2JXT3plUFlESWw5aTRWcXFIc0Ex?=
 =?utf-8?B?ZkxUeTdqNFdwc01uRXEzMTEzeSthN2l3K0ZENWJxYXhSOHZyeGIwUT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 30bb175b-7421-49c0-7342-08de58053c41
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2026 09:21:04.3622
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xO0nLAxbxb2L6Ah/fGhOVRnKPNUpFvgwqOCSKrdx4/6pRxaZlJxz+OfOiUXUv9mJGmMxw/AkrxelcoromgXCMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4687
X-OriginatorOrg: intel.com

On Tue, Jan 20, 2026 at 04:42:37PM +0800, Huang, Kai wrote:
> On Mon, 2026-01-19 at 10:31 +0800, Yan Zhao wrote:
> > On Fri, Jan 16, 2026 at 04:53:57PM -0800, Sean Christopherson wrote:
> > > On Thu, Nov 20, 2025, Rick Edgecombe wrote:
> > > > Move mmu_external_spt_cache behind x86 ops.
> > > > 
> > > > In the mirror/external MMU concept, the KVM MMU manages a non-active EPT
> > > > tree for private memory (the mirror). The actual active EPT tree the
> > > > private memory is protected inside the TDX module. Whenever the mirror EPT
> > > > is changed, it needs to call out into one of a set of x86 opts that
> > > > implement various update operation with TDX specific SEAMCALLs and other
> > > > tricks. These implementations operate on the TDX S-EPT (the external).
> > > > 
> > > > In reality these external operations are designed narrowly with respect to
> > > > TDX particulars. On the surface, what TDX specific things are happening to
> > > > fulfill these update operations are mostly hidden from the MMU, but there
> > > > is one particular area of interest where some details leak through.
> > > > 
> > > > The S-EPT needs pages to use for the S-EPT page tables. These page tables
> > > > need to be allocated before taking the mmu lock, like all the rest. So the
> > > > KVM MMU pre-allocates pages for TDX to use for the S-EPT in the same place
> > > > where it pre-allocates the other page tables. It’s not too bad and fits
> > > > nicely with the others.
> > > > 
> > > > However, Dynamic PAMT will need even more pages for the same operations.
> > > > Further, these pages will need to be handed to the arch/x86 side which used
> > > > them for DPAMT updates, which is hard for the existing KVM based cache.
> > > > The details living in core MMU code start to add up.
> > > > 
> > > > So in preparation to make it more complicated, move the external page
> > > > table cache into TDX code by putting it behind some x86 ops. Have one for
> > > > topping up and one for allocation. Don’t go so far to try to hide the
> > > > existence of external page tables completely from the generic MMU, as they
> > > > are currently stored in their mirror struct kvm_mmu_page and it’s quite
> > > > handy.
> > > > 
> > > > To plumb the memory cache operations through tdx.c, export some of
> > > > the functions temporarily. This will be removed in future changes.
> > > > 
> > > > Acked-by: Kiryl Shutsemau <kas@kernel.org>
> > > > Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> > > > ---
> > > 
> > > NAK.  I kinda sorta get why you did this?  But the pages KVM uses for page tables
> > > are KVM's, not to be mixed with PAMT pages.
> > > 
> > > Eww.  Definitely a hard "no".  In tdp_mmu_alloc_sp_for_split(), the allocation
> > > comes from KVM:
> > > 
> > > 	if (mirror) {
> > > 		sp->external_spt = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
> > > 		if (!sp->external_spt) {
> > > 			free_page((unsigned long)sp->spt);
> > > 			kmem_cache_free(mmu_page_header_cache, sp);
> > > 			return NULL;
> > > 		}
> > > 	}
> > > 
> > > But then in kvm_tdp_mmu_map(), via kvm_mmu_alloc_external_spt(), the allocation
> > > comes from get_tdx_prealloc_page()
> > > 
> > >   static void *tdx_alloc_external_fault_cache(struct kvm_vcpu *vcpu)
> > >   {
> > > 	struct page *page = get_tdx_prealloc_page(&to_tdx(vcpu)->prealloc);
> > > 
> > > 	if (WARN_ON_ONCE(!page))
> > > 		return (void *)__get_free_page(GFP_ATOMIC | __GFP_ACCOUNT);
> > > 
> > > 	return page_address(page);
> > >   }
> > > 
> > > But then regardles of where the page came from, KVM frees it.  Seriously.
> > > 
> > >   static void tdp_mmu_free_sp(struct kvm_mmu_page *sp)
> > >   {
> > > 	free_page((unsigned long)sp->external_spt);  <=====
> > > 	free_page((unsigned long)sp->spt);
> > > 	kmem_cache_free(mmu_page_header_cache, sp);
> > >   }
> > IMHO, it's by design. I don't see a problem with KVM freeing the sp->external_spt,
> > regardless of whether it's from:
> > (1) KVM's mmu cache,
> > (2) tdp_mmu_alloc_sp_for_split(), or
> > (3) tdx_alloc_external_fault_cache().
> > Please correct me if I missed anything.
> > 
> > None of (1)-(3) keeps the pages in list after KVM obtains the pages and maps
> > them into SPTEs.
> > 
> > So, with SPTEs as the pages' sole consumer, it's perfectly fine for KVM to free
> > the pages when freeing SPTEs. No?
> > 
> > Also, in the current upstream code, after tdp_mmu_split_huge_pages_root() is
> > invoked for dirty tracking, some sp->spt are allocated from
> > tdp_mmu_alloc_sp_for_split(), while others are from kvm_mmu_memory_cache_alloc().
> > However, tdp_mmu_free_sp() can still free them without any problem.
> > 
> > 
> 
> Well I think it's for consistency, and IMHO you can even argue this is a
> bug in the current code, because IIUC there's indeed one issue in the
> current code.
> 
> When sp->spt is allocated via per-vCPU mmu_shadow_page_cache, it is
> actually initialized to SHADOW_NONPRESENT_VALUE:
> 
>         vcpu->arch.mmu_shadow_page_cache.init_value =                    
>                 SHADOW_NONPRESENT_VALUE;                                 
> 
> So the way sp->spt is allocated in tdp_mmu_alloc_sp_for_split() is
> actually broken IMHO because entries in sp->spt is never initialized.
The sp->spt allocated in tdp_mmu_alloc_sp_for_split() is initialized in
tdp_mmu_split_huge_page()...

> Fortunately tdp_mmu_alloc_sp_for_split() isn't reachable for TDX guests,
> so we are lucky so far.
> 
> A per-VM cache requires more code to handle, but to me I still think we
> should just use the same way to allocate staff when possible, and that
> includes spt->external_spt.

