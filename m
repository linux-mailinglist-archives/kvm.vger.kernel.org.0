Return-Path: <kvm+bounces-51276-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B9601AF0F48
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 11:12:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DDDE21C26BE5
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 09:12:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2515D24113C;
	Wed,  2 Jul 2025 09:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HRk/Zs2z"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7541523C4F8;
	Wed,  2 Jul 2025 09:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751447514; cv=fail; b=FsdQK/8grXC35kRlRYdSS7u54RZqyYBp0rBUi3Dbv9gow5frvIqNNj86Bs/cE2ZXcTTFgKk8+qiwfY3uctkfLtgLTcf0UodTnp3romyy9wEl/8pVIlddZ1howxCUWdpkW0OgDSnp68HUP0yhVtwkJpBsZssBWsvVZRPNUc7oyA4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751447514; c=relaxed/simple;
	bh=mwbF52YfJ0lususBbj5T01M6S9giid/7bk65L5aYWis=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=LvSDa3e4cFtijgsejxieVoukHuCYwfKwGK2JkmXrR5Q6Ox8ezrYTn0ZkvTcKWEuFwqJu5xNOOzQA/WDE2szz8o4BBBk1tRCGOWqZoAGGTFg3cCwKBMWLC/DRlZqUwbWNMiPQjKNt7tbtm/TNWAJXq3DpNVpSulLTS0ghefBWbzo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HRk/Zs2z; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751447512; x=1782983512;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=mwbF52YfJ0lususBbj5T01M6S9giid/7bk65L5aYWis=;
  b=HRk/Zs2z9xenLNiYeC3eVdXI+vXIfjCqt00OpDxK8/u3WKjzNhgm0k6h
   kQZ9by79QN5ptalPypS66YckiybzkGGGMoiJQc1//pdKbJqo3qsyk097K
   epHXxAZk5EBVPeVF9A5Z4/nlH6yfJmzm2pPvodMW2DByd3+EjojIigD7T
   nPQhPh5LJC+aznk2ZAbd64+0wpSEdKw1JRaIcCeffu1F0KVxaHaeqEwIM
   Wa03ANMzNgbj2bwdVxrKGAfUEcFCrj9xuMw6sBQDMaDFw9uahDzaWbNxL
   +RUc9+mpQthT0LdlIHLIKlaa6KVAOmiynXn9l5BN2dN18R1AgLDv9NhpC
   w==;
X-CSE-ConnectionGUID: WU5n/76jSjCwgxE2Ifn7ig==
X-CSE-MsgGUID: d/ofVmVrR6KvGTgksUYjAg==
X-IronPort-AV: E=McAfee;i="6800,10657,11481"; a="64781656"
X-IronPort-AV: E=Sophos;i="6.16,281,1744095600"; 
   d="scan'208";a="64781656"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2025 02:11:52 -0700
X-CSE-ConnectionGUID: Al1t2vFqSTuJRz1P0T2XVg==
X-CSE-MsgGUID: I4LYbkcUT32KBOvUQhB6Jw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,281,1744095600"; 
   d="scan'208";a="153793707"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2025 02:11:52 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 2 Jul 2025 02:11:51 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 2 Jul 2025 02:11:51 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (40.107.102.77)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 2 Jul 2025 02:11:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FOKiLwvZX/LlHZOLBnlgjksIPNv0TDwzpIt6+PujF+keKB9NyGyk7oEgsamGiIw08t8AEKsG99eXHQV6UFUItntNn1QPg8JKRNSsuLJdVKvYayVTPh1h7AfklJNgV7IbJ2w88pRWaBmrLGKyblKtjtbMauUvM6C8VKp0dlQJfrcVFpiT4nGR2YLf5AZlrjL9DTja43JKYNN0oMkPI7RHgtk7KLB+Nlc+F/+7vBnec+spy5E3MKGI55GTU3r/UlWxRxIxs26DMSMmefLj3Tl+5HBbmeae/vtVbGATsf2JkjN9qTil11XChzeXjTo3nFTzs2fh6cFMgdQXZwCkgUkNfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ct/W9glvQ8RLaffBqe1IWgkJp4IxT5Is4grVEFtLLAA=;
 b=wicSpuSoqnxNvGFhrm5RkKKTI7IjT0MDOemjO/61ObE3pgQHcs4D5cYolkfVGiivV3utbQiin3Hc4MbfiFqNfTX1hPOns4Py/R+NA9vxYobiOHV5K8oU6LFjbeAAGAlIa1Rl/B+cF/em5F97Ars5gUmpMfSy+fxnrCQV2DPkKAnpj8z+m45Tim2L3cIqfHOrwvvIksMuM5drqBTb4BosprDq6Z7m/ojqoYQ+2n0A2bJIONeCM0kva4xUIwJ/spFdRkdiJMmpGxeROcBWztWRQctA0pMK49dCa0EzCJX5ZyjjuDLS4EdOOKMkV7gEVMgm11l+KK/lGzc2QZNZckkWTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DS7PR11MB6296.namprd11.prod.outlook.com (2603:10b6:8:94::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8901.21; Wed, 2 Jul 2025 09:11:20 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8901.018; Wed, 2 Jul 2025
 09:11:20 +0000
Date: Wed, 2 Jul 2025 17:08:42 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen,
 Dave" <dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "tabba@google.com" <tabba@google.com>, "Shutemov, Kirill"
	<kirill.shutemov@intel.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "Peng, Chao P" <chao.p.peng@intel.com>, "Du, Fan"
	<fan.du@intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "Weiny, Ira"
	<ira.weiny@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Annapurve,
 Vishal" <vannapurve@google.com>, "jroedel@suse.de" <jroedel@suse.de>, "Miao,
 Jun" <jun.miao@intel.com>, "Li, Zhiquan1" <zhiquan1.li@intel.com>,
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Message-ID: <aGT3GlN4cPAcOcSL@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <447bae3b7f5f2439b0cb4eb77976d9be843f689b.camel@intel.com>
 <zlxgzuoqwrbuf54wfqycnuxzxz2yduqtsjinr5uq4ss7iuk2rt@qaaolzwsy6ki>
 <4cbdfd3128a6dcc67df41b47336a4479a07bf1bd.camel@intel.com>
 <diqz5xghjca4.fsf@ackerleytng-ctop.c.googlers.com>
 <aGJxU95VvQvQ3bj6@yzhao56-desk.sh.intel.com>
 <a40d2c0105652dfcc01169775d6852bd4729c0a3.camel@intel.com>
 <diqzms9pjaki.fsf@ackerleytng-ctop.c.googlers.com>
 <fe6de7e7d72d0eed6c7a8df4ebff5f79259bd008.camel@intel.com>
 <aGNrlWw1K6nkWdmg@yzhao56-desk.sh.intel.com>
 <cd806e9a190c6915cde16a6d411c32df133a265b.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cd806e9a190c6915cde16a6d411c32df133a265b.camel@intel.com>
X-ClientProxiedBy: SG2PR06CA0229.apcprd06.prod.outlook.com
 (2603:1096:4:ac::13) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DS7PR11MB6296:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b2053e3-3f0c-48f6-d8d2-08ddb94868c8
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?pFpwzs4DBBEX8NondZgqu2uaMlgWvDnPc2/bIOBTcB6T4Xulr10c7thyF7?=
 =?iso-8859-1?Q?hjXJynlgi+uXU84gDS/x2J6VKjImxj2dp/niZgfoEiHUpN6TMBd2gft4MZ?=
 =?iso-8859-1?Q?FWgJOG5/OgZ8yMAVREzDuOn6Tcytrn1GsGO+MMney9LgToBa+puVwbBQfe?=
 =?iso-8859-1?Q?TG9xEtB6LE8dsD/2/lDwE4u7q5nE1i0sO8GB4J/H0XVKbWbryyqwwzXECg?=
 =?iso-8859-1?Q?ZOkPSsZr6dcl82LtEm28OcJzAFpctEbJ9DY0W+cja3/wnX50+KVh7Gg8FB?=
 =?iso-8859-1?Q?RN5LHXsAgBzjdqIzfbE6E1cIsBzklbRKiE+CbEy2OUA6fsMiWxQReeLFy/?=
 =?iso-8859-1?Q?kDCCzJ4UHNcG/ZEKwgV+Z3VokJJM7e++2yl/YG7CGq8HY/mFBU8mjd3o5u?=
 =?iso-8859-1?Q?+KFVD+rMv0U27MCpptzwNHacu/3lDIUnqHH3A7KYBQx7/gqur3OFYDFJoj?=
 =?iso-8859-1?Q?r6scLrCpf4rYg0aSWtj0ikSRquWN3KQSe39ZJgEg1CQDZw9JdJWGIQzF3b?=
 =?iso-8859-1?Q?L7zYm39lwf9UZtoKyT7R9Ov5tbgAnLcKS9bohPSkJhaIW/RHl4h3yMQhDy?=
 =?iso-8859-1?Q?H7iLOgGNPiQrbOzPzBEjjPBlPmWcqUgnsDJ2JK0EyjaC8d/UNJLoJ0WEUS?=
 =?iso-8859-1?Q?on0VVPV7BZqgykefXVF95F6pzeLBXIa/7lvG+U5geqfUsIEtcOLhZHIKVD?=
 =?iso-8859-1?Q?vi/MLHw5356seDRP5a670neaZ5cYhaT3lGTSCkJLtMt6+jNEewnbO5UXFG?=
 =?iso-8859-1?Q?xoGNzjXQxNdq2OmNXOo7UFAxWma87H1J5/WzXbCLuvXoIE01n4eG8USHTJ?=
 =?iso-8859-1?Q?xtPQ8FLiau1U/pkez9EmkqwsrasdWHsr5GAN67LLsp5KSB+5OeqYZp3oG4?=
 =?iso-8859-1?Q?q0r12Xvg4Py7S9iOO3MEQhCljgx2554J+TEQQsEQw3G+aN4N3lq4lK6toV?=
 =?iso-8859-1?Q?gdcEyd6o0KjI51yqDtJ8+kfj+6V8P6tOFtXxEonX7lDntP26jBcvnEj/8X?=
 =?iso-8859-1?Q?ZwFDyiCXoTLvICuHo7VQtK2jMlM8yZvGbl8WUw6tUHC24GGEf2St6ODxLZ?=
 =?iso-8859-1?Q?ozGW/pWAIGSj46Sreu75pncTfqiKOZEfh1lG7/mNRkQuX79COUM5mKbVTz?=
 =?iso-8859-1?Q?1gF2C+h6hLCdx4lIzxjvX+eXLDdqIvQWIfYSYlZWmM821atS27dr6E0M2k?=
 =?iso-8859-1?Q?i0n1QTjfGu4u+DP4JFfXzgvVPkN85AK+2/Bt2epD4pX552ZqPD1QkfSWuM?=
 =?iso-8859-1?Q?Hl25s8zf2Mn3NYOEUWcn5fRfatOruA4K9a3p7WnfjebQ6Px8RGDKyZcw2b?=
 =?iso-8859-1?Q?ahXeoR4FsmCSOW8qHssyvcc8xQDjoquZWLQn5qA+Ub+NtZQBF74RpVyI+N?=
 =?iso-8859-1?Q?U19dpg5fTF5XaLEUXjeAB101Zacx//DWJACXHElUaBtIxHYPVjXzll8Gyk?=
 =?iso-8859-1?Q?OwtXe+bOy2B99pu9F3SU//cBPE/ZJrXvt541NpzkzPXnILpdigkYBhfz3d?=
 =?iso-8859-1?Q?Y=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?cU6ENlYFWpJ+fWIRj150gF/Y4/d4GASZGNBtCzGnuXAk5AhNe7pBcoziNf?=
 =?iso-8859-1?Q?UDRjPO1CAmn7nBdIg8maENGh87VfRKY3z7J6U38iAv3j2XqRXh+5S2ZykJ?=
 =?iso-8859-1?Q?vB/KYht5x9ax7RdxTQfle1wgpUnEcc9ueCZmph8JAo4w+qbqaBxWAlGrR/?=
 =?iso-8859-1?Q?MWzb2TunZl7S/cftSFMRmnTbtRmWGwgfSr15x5GbFnYVZXCdp4HuO2N9TM?=
 =?iso-8859-1?Q?YN2PCWuBsr9+ZVwB3NHRwN0cxErFk066mhY/kFQpy3d4XWsfkWEkJnxDZb?=
 =?iso-8859-1?Q?4Xbpq5NjsYZb9SS7C0bx2bR1YXyXKdYoyNHRzagYYidGovnMcUBpt3bIEz?=
 =?iso-8859-1?Q?dBcZa7gryDRt3wd0Pzarf79Whs7TvOOQ+j/Nz1TC5PhtplzrObSJF5Wl1K?=
 =?iso-8859-1?Q?YyXFpiLZU4yIMX1FB4qAFtZJTh31zo+xFxkg63IQkN1zE/uXQtdRZ5xXkr?=
 =?iso-8859-1?Q?rFZdtN5gHNGiER9birDxr2D+XsJY9vTlWjH/hCefULIzXY4Et+swyclaCP?=
 =?iso-8859-1?Q?5FAUSueqqVpIXiD24faYxIhRk+q57x1GshZfGgIHSECCqfMUdI1nGhSkgP?=
 =?iso-8859-1?Q?BK6fZLVRABXElvF+S2X9uMEpT7T1bR+3pHmtvY2JjKB+NJHQPNEKvr92pB?=
 =?iso-8859-1?Q?g+dTHXLRIRaf24OjBuWy+QDwOGSQUpgoa1mk42edbgUc9B0rhJhVdxy9eh?=
 =?iso-8859-1?Q?mm9DnPDqQc3Gk0HtbmGQOngBQyfPBkDt0yxuYXS5FPHMKNsOXIakElcnFs?=
 =?iso-8859-1?Q?ynd4JEv/l1pnROOy7FgU3/iYBL5kWlRPPPLgSdYRo5ysrmEGnufYXYbPOX?=
 =?iso-8859-1?Q?TWxPm3gwY6hkeHiATHrwoxjLMPUo8TJerTENDjNcv44igP7Ef9bcatfIKV?=
 =?iso-8859-1?Q?2h2yfSvrz9KIkfMwRdSAHie5edz0wIWySmHc4e/+k3IEbOrDn4bzMN14Aw?=
 =?iso-8859-1?Q?7f0fXl34N71gtOnCzhzUV/IBdNtjGidhH/svaltKcym2YOL7uSE8MPduZQ?=
 =?iso-8859-1?Q?eQNmo6NcW8Use3U8KtoMc0YytFT5JtyN7ZcTgu+sXZcOxaw4MWxiykdtly?=
 =?iso-8859-1?Q?T9uqDlTgMTPF2U/5irzJ65CbpMOzL4okiY+PRpzzOkTRHe8JMNSQdskwwD?=
 =?iso-8859-1?Q?TDhFMENL+GrlFiE1IncEmlKTYQOX1+ZkgI5+hVapUZRDEMQSHej19Ylsfb?=
 =?iso-8859-1?Q?7avgslZIJaM3soh+lLu0i0TimmJg7SWT4jyd2PVh3bdn1SEzJCOP5EzCKg?=
 =?iso-8859-1?Q?fa7qGFxtbrrXflgMiMvDdUw6DyPr0SUwOkjVE2HCLwxaEuCKPQCWxqMlyC?=
 =?iso-8859-1?Q?2iXhajV+yiiHnWWjkqpr6JfHcfGXGjqrWYkBJAbT9SNKBh/MIgwsCAu5D+?=
 =?iso-8859-1?Q?gbGnz7Q5Rk1guljx7PJZmYPziC4b4y+uMQt180AYhCUzni6WdwlC/ti5Uj?=
 =?iso-8859-1?Q?oA75OaOOjhqBRYR5KaNFb/37HPaAQC2PM1Kxf8IH5MOXpP9FYJmObPS0NM?=
 =?iso-8859-1?Q?dsz/Vz6+44bjCYACB1S7fm1BSOKFjc9ftmuG62sc1cEQJyx+lnkoD1INia?=
 =?iso-8859-1?Q?J8/GmRwjiUfU26O/WYmBJgvPyfSHtG8ceH0YV0RSMDeImrKXjUkgG7sZ1j?=
 =?iso-8859-1?Q?KE7K7RMQQ1S5fA0EZdikULJLhla0J0QmV8?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b2053e3-3f0c-48f6-d8d2-08ddb94868c8
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2025 09:11:20.5015
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kPUJ4sDP+O+sgTbqNXJeFVe0ITsQqq1jKJ2LSDlW82LHQfoT1V3yNo3uoLuzpvK9F2/w5qVZuaMGlNRUQgd+og==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6296
X-OriginatorOrg: intel.com

On Wed, Jul 02, 2025 at 12:13:42AM +0800, Edgecombe, Rick P wrote:
> On Tue, 2025-07-01 at 13:01 +0800, Yan Zhao wrote:
> > > Maybe Yan can clarify here. I thought the HWpoison scenario was about TDX
> > > module
> > My thinking is to set HWPoison to private pages whenever KVM_BUG_ON() was hit
> > in
> > TDX. i.e., when the page is still mapped in S-EPT but the TD is bugged on and
> > about to tear down.
> > 
> > So, it could be due to KVM or TDX module bugs, which retries can't help.
> 
> We were going to call back into guestmemfd for this, right? Not set it inside
> KVM code.
Right. I think KVM calling back into guestmemf (via a special folio flag or API)
is better than KVM setting HWPoison flag or invoking memory_failure() or its
friends.

> What about a kvm_gmem_buggy_cleanup() instead of the system wide one. KVM calls
> it and then proceeds to bug the TD only from the KVM side. It's not as safe for
> the system, because who knows what a buggy TDX module could do. But TDX module
> could also be buggy without the kernel catching wind of it.
> 
> Having a single callback to basically bug the fd would solve the atomic context
> issue. Then guestmemfd could dump the entire fd into memory_failure() instead of
> returning the pages. And developers could respond by fixing the bug.
Do you mean dumping the entire memory inside fd? Or just memory with certain
folio flags in the fd into memory_failure()?

> IMO maintainability needs to be balanced with efforts to minimize the fallout
> from bugs. In the end a system that is too complex is going to have more bugs
> anyway.
Agreed.
To me, having KVM to indicate memory corruption at a folio level (i.e. 2MB or 1GB
granularity) is acceptable.

KVM can set a flag (e.g. the flag proposed in
https://lore.kernel.org/all/aGN6GIFxh57ElHPA@yzhao56-desk.sh.intel.com).

guest_memfd can check this flag after every zap or after seeing
kvm_gmem_buggy_cleanup(). guest_memfd can choose to report memory_failure() or
leak the memory.

But I'm ok if you think dumping and memory_failure() the entire memory inside fd
is simpler.

> > > bugs. Not TDX busy errors, demote failures, etc. If there are "normal"
> > > failures,
> > > like the ones that can be fixed with retries, then I think HWPoison is not a
> > > good option though.
> > > 
> > > >   there is a way to make 100%
> > > > sure all memory becomes re-usable by the rest of the host, using
> > > > tdx_buggy_shutdown(), wbinvd, etc?
> > 
> > Not sure about this approach. When TDX module is buggy and the page is still
> > accessible to guest as private pages, even with no-more SEAMCALLs flag, is it
> > safe enough for guest_memfd/hugetlb to re-assign the page to allow
> > simultaneous
> > access in shared memory with potential private access from TD or TDX module?
> 
> With the no more seamcall's approach it should be safe (for the system). This is
> essentially what we are doing for kexec.
AFAIK, kexec stops devices first by invoking device's shutdown hook.
Similarly, "the no more seamcall's approach" should interact with devices to
avoid DMAs via private keys.

