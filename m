Return-Path: <kvm+bounces-51313-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D7CCAF5D95
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 17:49:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 429C47B3315
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 15:46:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA5812D77F8;
	Wed,  2 Jul 2025 15:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EP33k7Zr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD41F2D3747;
	Wed,  2 Jul 2025 15:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751471256; cv=fail; b=W50znrbM54vGB9JbetaePHqlJYzcrrTCCnzMOsqa1Dt5HKjh29+D8CACMjVdwSzUFAfMJNflAPHJOQfCvmbKS5KgMHOw1KCTaadDNW2KCfm86msgKyJgupNSKBflcF9JPJXTKAh+++zBj/rjxdymBajTqYWi+5o7dinrDbGQKvE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751471256; c=relaxed/simple;
	bh=qDebzayk11j7ys/+sYmjzRWfkAEYZlMdQYh0jKbCI7Y=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=oC/A8cMGEwHb+m5kfr6aBJyMz3iqz5JKIa8LQ3yHGKct4fYag/4O/a42D/9q3coCC/8Z0XX9aoO4LtV4LzOIWAyJuPPKaysG4aleQIM8fkjHXm4udY0n3uFowH5f7dlM+BPnjDq4QjTJObsJLTUNFUD9Y1V16DGktdwaQGBZavs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EP33k7Zr; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751471255; x=1783007255;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=qDebzayk11j7ys/+sYmjzRWfkAEYZlMdQYh0jKbCI7Y=;
  b=EP33k7ZrV7N3WRwjWJ0RUrQ0YPEh59lbwcJNWEV6YkiL9zGxagkrsTBv
   P99k3t2uk+VV3By5/TIi0s0bhnecoEVf8JFL30a2YINknBYEsTs0bjn3e
   oUZ+k6k/s8x4CoIbqiVD6YnIFHP0YhtY8RQ/7nCyWdXy0aQufx8y1CKzq
   orY9Gbx1my4sEgfwo9KwqrSdVhfEmy1Jdc3TDdbUnpte3GNd1XRvUitVV
   WZyvi6zzDEPVmEHQeig9PpxRYrIDqX9uotXBcsDTB20JIl+riTzaWPev+
   Dkf1Aq8gkwLcltDjKxd4IkYkB0DKDLw8gcH1Z7OfoewjzjiYdjPMwCfUe
   w==;
X-CSE-ConnectionGUID: /pqwlNL3TNeH4tRCl4OvWw==
X-CSE-MsgGUID: J11g0fjIR6yR32B/IiEMuw==
X-IronPort-AV: E=McAfee;i="6800,10657,11482"; a="53006054"
X-IronPort-AV: E=Sophos;i="6.16,281,1744095600"; 
   d="scan'208";a="53006054"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2025 08:47:33 -0700
X-CSE-ConnectionGUID: EpPWb3Q4Ssq+U0yBYtfwIg==
X-CSE-MsgGUID: EjhYkEiOQfO3AnL0s7vHpA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,281,1744095600"; 
   d="scan'208";a="154262343"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2025 08:47:32 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 2 Jul 2025 08:47:30 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 2 Jul 2025 08:47:30 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.87)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 2 Jul 2025 08:47:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jEyO0PiukHwZGugYqjKW87Ed8QTZsqyGb+Uw4ZEBObq77IocnECGcKVRYSnBdoPbU9zkrPhBug0yaMT45iL1k4Ax4fH3N7G3c4nzyi1Ecuxs2Iz6dIEannSqoqAPt5/DHCmnVgqITd9us/84PxVvC4i/23RvPvPivRkrjqA8iE7Ok6OACl+Xv2R3Zo8zTlAZ9BsdcYKaGmOyKhcHKQKk+U50FztMJI9bQTXfUQLQIk3d7MPMWVyhYFXYO8oLPHr4dynyfpeeC51PaiWmYXJK9GNANgIX7Pt2NihTltkd6TXWuRQfE1xYb6FQC9d/71oCbs6kG1y8fzzbJp+iqkh64A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qDebzayk11j7ys/+sYmjzRWfkAEYZlMdQYh0jKbCI7Y=;
 b=IpUx1WXumWyRxDNPKhOzchR/QhsiITYnx+YXm0IppBoG/C6xwhC+v6jpPR+pc4Du8RBDN3sMrnRmPH8QFoRDXG0SNd/lLzAdyzlvRxLIqmIoUJM6il7J9fiWU1LCGVu347KNyOEuVGTWDgqjur4ep/9SLb/LJBx+arf8AKXcybF7kG17nK8muF+F/jS/RK3jbLsW/M2t+EIyRaxWJ2Yg9VPT3gtbfd/aaw0unTSNuJiY4ComoqVqwe7DGVhmlPwou2xe/fxXbjkxC3NWNJBTByGdNypenWwjrXduItkn+jeAYEoM0l9ebRlzXVP+y9ck9cVfPMOqOLkTgI6XfnevbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA1PR11MB8574.namprd11.prod.outlook.com (2603:10b6:806:3b1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.20; Wed, 2 Jul
 2025 15:47:29 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8901.018; Wed, 2 Jul 2025
 15:47:28 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "Shutemov, Kirill" <kirill.shutemov@intel.com>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com"
	<tabba@google.com>, "Li, Zhiquan1" <zhiquan1.li@intel.com>, "Du, Fan"
	<fan.du@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "Weiny, Ira" <ira.weiny@intel.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>,
	"Annapurve, Vishal" <vannapurve@google.com>, "jroedel@suse.de"
	<jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>, "pgonda@google.com"
	<pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 15/21] KVM: TDX: Support huge page splitting with
 exclusive kvm->mmu_lock
Thread-Topic: [RFC PATCH 15/21] KVM: TDX: Support huge page splitting with
 exclusive kvm->mmu_lock
Thread-Index: AQHbtMZgwij9+WzrHUOM0bdyapyf+LQfZ60A
Date: Wed, 2 Jul 2025 15:47:28 +0000
Message-ID: <bfe488aedf5e9c43b2578bbdcbf281cb60c5db41.camel@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
	 <20250424030800.452-1-yan.y.zhao@intel.com>
In-Reply-To: <20250424030800.452-1-yan.y.zhao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA1PR11MB8574:EE_
x-ms-office365-filtering-correlation-id: 8c72ecb5-90cf-48ae-cfee-08ddb97fbfed
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?ak1KTDVMTDRnRzNTYkRtUVpsaXhoaFQxRzFGSFVHdkVKLzVHVTZTTjQxYkla?=
 =?utf-8?B?L1JCTzZmZnhqL2g2dXpuaWdhOC9EZnlHakt0d2JENERhUGgwRnlQTVZuemhE?=
 =?utf-8?B?ZllldlFLWG9Za1dCWGhDOEJHVzdTUHR2SjdhcmtzbHdJdXNabmV1MC85WFQ5?=
 =?utf-8?B?NnEzYVhVOTJEV21WNXN5MWZWbU1FblJFaWs5MjZ5SitsUlVqTWQyZjFjOVNS?=
 =?utf-8?B?OVlrUzZLYklXTWd3ZnpVSDJmMlUxeW5CaTNwZmhqTmlqR1oxWVlSME5PL2p6?=
 =?utf-8?B?ZXZDdFBBOE1RbXpNQmhkaXRDTmx0OHJRWDdnWXEyd2NXNm9Tb0pROHFnZmJ5?=
 =?utf-8?B?ekpUcXpEVFZCMjVTazNNZUUrTC9XMllrbTdCeUh0dUZpQUxMME9oSlZGT0M2?=
 =?utf-8?B?YzdONkxuRzlkSW0wWjQvRmxIMHo1bkRkSHFKWEJWbFA0MHZXa3BlNFZjamlI?=
 =?utf-8?B?clh1UzZkSXVZWDV2bUIvTlN2cTNuU0V6QXNHbEFZM2hwMFJKbmdEcFlwSEJm?=
 =?utf-8?B?cFlmeE9oYUhQZmNEdDJIcjNCekhGazRNUEVGUURMeDhQZEF0OTgrVXM2OHBE?=
 =?utf-8?B?QXloWDg2M0VpTzgyY0hnc0xjTkgwSWpybU1IdEIrT3pud29ZNHpuM3RmdUpN?=
 =?utf-8?B?bkJTdjNySGJjNEx3eDZHajNINzd6VzgvbXJDcCs0aDZLLzNhNzZyN3VIeENV?=
 =?utf-8?B?cVBra1UxT1dsZ0JRajlsbzQ0Yk5mQW5VTjJNNGdFVStEdHVyYVZXRjF1L0E0?=
 =?utf-8?B?cDA1Qk9sL09iKzIyMjZPd3BIdVVUVW9NaVhUMUlUUDFzTkU2RDBvMm9teXNB?=
 =?utf-8?B?V05mQTBac1Nqa2dCVEZYM0J3cDFOVVJ2L2ZScmZaQTVwcXBOQXF6WGNCa2Er?=
 =?utf-8?B?QXZ2S0RkNExkN3hIbXlTWThOS0laZDB1aTJRTmhVREp3UkdDbzI4L1drMmor?=
 =?utf-8?B?b3c3VVJQdnJaLzllM1p2dGlnWkRnNlpnVEljSjkvZW1NL2gyR01Oamk5Mnlk?=
 =?utf-8?B?UVRvVHlnUTRhTUpqOFZMaWtKemIreExVczNRa0hzbDdUanJnc2ZZS1NlZW1M?=
 =?utf-8?B?aUhIWEZBVW1FZWUyQVpOUnVFYlZRTG45bTMzbDc2NkRQZUhWWVZSY0F2VE9w?=
 =?utf-8?B?ODArbzc5MVJCY3pqS3FoZkN3TS85Z0tIYXMrcHIxU3B0cGxqMkgzWW12VWVG?=
 =?utf-8?B?OFFnTHNpV2RBM1FaK3Z6NWZScHdrRjA0SXpBZWRVZzhRRGdyT2xCL3BjczhD?=
 =?utf-8?B?d0lvSlF1bC9oUHBtT2lwbTdvMXlITm5oNzc1ZVkyOGw4V2FDazVveGNlS3RG?=
 =?utf-8?B?RjJoTGhOYUhIQzliKy9sbU1Na3NGZkQ5OUc0TjR1M2VwaUFRbEhwMm1ycHNH?=
 =?utf-8?B?cS9CR2tEU1doQUpVY2dleDZRRmxFRFlBTTFFdUZ2Ym1WOVV1eWh2eVFQdzdH?=
 =?utf-8?B?MWR3OTBSZXo1M1hGanJId1FqNDRseXd4M2xyNytoOUlYRlYzTURiMU1zVGV3?=
 =?utf-8?B?SVJObTR5RUVZSjBOcEFrZFRHalN3ZzFSbG91Q1QwSW1TOTFNYnJnVjFTVnFF?=
 =?utf-8?B?dmRNYURPbTAzd1VhWmt1NHN0UityVkhJM1RmQ1NxbEo3c08xL09WSmI3c2FB?=
 =?utf-8?B?RlNxcUlSUGFqTEJsZHV4eFdsTmRiaVZ0YkhpYWk2NE5BVGZncmZ3bktWTW5q?=
 =?utf-8?B?TGdQTXo2YXJza1VuQnlleG1hYllWeDJiS1BjR2ZNbnFabmd3QlpKYk5IQVpx?=
 =?utf-8?B?b2R2ODhwSXJGV0ZnNzNmSm1NeG54WXlDUFpUemUvdFFjUjcyNURaK211MVBs?=
 =?utf-8?B?c3VacEJmenF5Uk54S2ZDNlZQWkhsV0xXUGRzQ0x1S0ExbmlGMkkxS3J3Zmpo?=
 =?utf-8?B?OWhJbUd1QUtuc05oVVVPdnArNUIrOG5US0VOcUVyaUQ3c0pRM3dYSGp4cy9Z?=
 =?utf-8?B?WXhsbXViT2hTUkpCb1I2dWliOElHRy9XTzdBWnlCUFhBM0lwMmwxU3l4YlpR?=
 =?utf-8?Q?jLZZ2W9htI+HfXX6BouukSPJCGur78=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TUdhcHdyVHFCc0s3SkVNUW83ei94N0czRUQvUUhtUlErcTZEajNsY1IxZVU0?=
 =?utf-8?B?RXIyMEt0Y3NzOTBUdE5aMTRFWTBDR0NNRWpqQjFrWUE1clNyK3l1dzByV2tn?=
 =?utf-8?B?Y0s2Tk9VZkMvN3ZUdFFCQWYrYkhrM1dHVUswWmNrUmpscDREWUpENnY4clRM?=
 =?utf-8?B?UTd4UHRONjFpQzMvdWw0S0tmQ2Rsb2VtU1IydGRkV1FkeHdtdStQOG14c2Vu?=
 =?utf-8?B?QmRvU1FvcnVTTkxzYkhnajhtSXRhNlJHeWJ6MGhxeHBkU0lleDR2TkF1cjhD?=
 =?utf-8?B?UDJEN21pNmM3am02MEtodEZWcXJGaUZOWk9GdTdIcUxIRFhPa3ZKbWh5Q3cw?=
 =?utf-8?B?OEJTMHZOU3VFQTBrWmoxRnRRZ2U1Vkp4bUdjM2F0U2JVTzQzcWhjL0lJNXFt?=
 =?utf-8?B?YVM3bmV5eGE0NHpWMVUvaFg2dW1NNHF0VCtwRFYwdlZkNFhwT2dCSlFMOTJ4?=
 =?utf-8?B?SXkwNTNkWE5tYVF1ZnlvWHdjcVpFUTNZWG1TVkw0aHRzUks2b09QTzVSdURw?=
 =?utf-8?B?ODFkdnhRczZiY0RXMHp5YkxDRVVvUmZ0M1hWN1lzWlQ0TUFZTkJCS0REdVdO?=
 =?utf-8?B?ZkJmQlV5RjRrZGJmeWFRa3d2bHkzWG5tQjlCdUlyMHhvb1ZJUFMrSTZJVW9t?=
 =?utf-8?B?NHBEcDJRRkM5SlVFb1NnQWRDNi9DTXd4ekFMYUpZdlpyM1hsUjhRUloxTUlR?=
 =?utf-8?B?YWRjQmJVcGVsbDBka2FnQWlabTFVamFDb014SEorOUkvWFNlTXdtdFA1Lzlp?=
 =?utf-8?B?K3hRRS9mY1VLMW5oYlBTZUpZeFpjSmVhTmZteFZ2NWhLNEFJY0VlRllOWVFX?=
 =?utf-8?B?aURUKzFiTlVVeHZSbDVuTW8rOGFqV3pBeHVSd01CNVhlV05ZdXdPSVhCdGJE?=
 =?utf-8?B?N1dySUFINVlNSEZjblIyTHBrK2Jqb3JGaGdWYy92eTM5bnpkQ3p2bS9TMDFL?=
 =?utf-8?B?a0p2M25EQ1VLK01WZkMvL0VBMlFYbGRKa3NKOEFhbjNNTkxsVmZiSlp1amFy?=
 =?utf-8?B?M24rWHdPblc0T1g2U2tHTGxRcVF2RERldllmeFdtSUlsM2tEQ2pVOUNldnJX?=
 =?utf-8?B?R3Qyc3QzSFhQRnh3ck40dUovZHlnN1JoanU1U0VBV2dwN1RCMnI1cm1zaFBt?=
 =?utf-8?B?ME1LNW40U05DYjdGWXJNempZbmZRTmtIQVlLeSttcjNiR0Raa1pkK1ZiRDVV?=
 =?utf-8?B?M0sxSHRJSFV5UUo5UGs3UTVqMVQrMEV6RFNhbjEwRnlXM21qNTE3d1NtZXFL?=
 =?utf-8?B?RitWU3RGM1VzMi9CLzRCOEZOWktrYlpYNERpTDB5dldsSkpIZXFSSE9WRWM1?=
 =?utf-8?B?K3VwUnl1c2lMSnlObGorbFl0UmtybS9EcUNydUpuTmpkVmtuVHUxQ00wWkVk?=
 =?utf-8?B?bUl5Y1RzNDc3d0dHQ2s2SktEcHRWY0Z4a0R4UFp5Q1NNWHBDbzZvQkhKU2J3?=
 =?utf-8?B?ZHkxWDAxWTBMdUFXNzFlY3prM1ljdFBaL0FPZWc4OWhYUkFBb1lwalp2MjFT?=
 =?utf-8?B?dC9zdnJKclM1Vk0zVjhBSXV6ZnpGaHNYU2xiRXJMUy8rSm1lcFMzdGxEOGh1?=
 =?utf-8?B?L2pJdVpMdVNadHloOURYWjhDQk1PU2grTzIyY1BLUFd0cy9mN2lOOWdmNy8y?=
 =?utf-8?B?Y1hVdThUZ2xSbWZLZTlNV0pOaS9iT0hIQ1p1aTBiSmZNbWRoYy9hYnVCQ001?=
 =?utf-8?B?MGRBdUZwa1BRdFVGcS8wUDVpRWRKa0pkWTh5ZHlic2RFRU5RUENWeGg0RUFo?=
 =?utf-8?B?OWVvNVFGY1ovQjlmTEpjMFgyZlZwc1BPVUtmMmg2WGwyUjhUN2dXSWxXV05V?=
 =?utf-8?B?SVlEajJXRXlVVm8vZkpSUEV0R2JWeEdxVTJDckpQdU5FWU0zKzF1TEN3cGtJ?=
 =?utf-8?B?SWVuUXVBcVNNdnEyaVNhVXhGdFFsOXI0ZGkvRFkyTXJLdGZTdndHdS91am1Q?=
 =?utf-8?B?YVpFbitEcEJDT0g0UG5HQUNQbkhudU9nZjJ2UWQ4dDI0YUJ1eGRNbGxxK09G?=
 =?utf-8?B?VE9KcVJJZkdjYmI4ZHlMWklhNXc5YXZZS3BScDJSSmp3MjRiakR6UjNuME83?=
 =?utf-8?B?a1hIWkc2L09RNEtRZFc4dDh2YnkrN3V3RTh5WHh4TWhpMkNVS0VaS0cwMG9o?=
 =?utf-8?B?UVd5YzRFcmlaSzNnc0N2S0pkNWRPM1VSMjVVQyt5bEFPUCtZOTNRUTVpQUM3?=
 =?utf-8?B?ZFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2FBA70EFDB94804B850E422ED969A7CA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c72ecb5-90cf-48ae-cfee-08ddb97fbfed
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jul 2025 15:47:28.7377
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qasfWTvgyQov9s0qK+refbTPXAqt/BI4Bk73BpDPaMasunCDMwDZDEXsR1ZP2ZLdqfxmdsg6JX82u0cb8fYwHswc3xOxoyQUM8cWu2dx8ak=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8574
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA0LTI0IGF0IDExOjA4ICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gK3N0
YXRpYyBpbnQgdGR4X3NwdGVfZGVtb3RlX3ByaXZhdGVfc3B0ZShzdHJ1Y3Qga3ZtICprdm0sIGdm
bl90IGdmbiwNCj4gKwkJCQkJZW51bSBwZ19sZXZlbCBsZXZlbCwgc3RydWN0IHBhZ2UgKnBhZ2Up
DQo+ICt7DQo+ICsJaW50IHRkeF9sZXZlbCA9IHBnX2xldmVsX3RvX3RkeF9zZXB0X2xldmVsKGxl
dmVsKTsNCj4gKwlzdHJ1Y3Qga3ZtX3RkeCAqa3ZtX3RkeCA9IHRvX2t2bV90ZHgoa3ZtKTsNCj4g
KwlncGFfdCBncGEgPSBnZm5fdG9fZ3BhKGdmbik7DQo+ICsJdTY0IGVyciwgZW50cnksIGxldmVs
X3N0YXRlOw0KPiArDQo+ICsJZG8gew0KPiArCQllcnIgPSB0ZGhfbWVtX3BhZ2VfZGVtb3RlKCZr
dm1fdGR4LT50ZCwgZ3BhLCB0ZHhfbGV2ZWwsIHBhZ2UsDQo+ICsJCQkJCcKgICZlbnRyeSwgJmxl
dmVsX3N0YXRlKTsNCj4gKwl9IHdoaWxlIChlcnIgPT0gVERYX0lOVEVSUlVQVEVEX1JFU1RBUlRB
QkxFKTsNCj4gKw0KPiArCWlmICh1bmxpa2VseSh0ZHhfb3BlcmFuZF9idXN5KGVycikpKSB7DQo+
ICsJCXRkeF9ub192Y3B1c19lbnRlcl9zdGFydChrdm0pOw0KPiArCQllcnIgPSB0ZGhfbWVtX3Bh
Z2VfZGVtb3RlKCZrdm1fdGR4LT50ZCwgZ3BhLCB0ZHhfbGV2ZWwsIHBhZ2UsDQo+ICsJCQkJCcKg
ICZlbnRyeSwgJmxldmVsX3N0YXRlKTsNCj4gKwkJdGR4X25vX3ZjcHVzX2VudGVyX3N0b3Aoa3Zt
KTsNCj4gKwl9DQo+ICsNCj4gKwlpZiAoS1ZNX0JVR19PTihlcnIsIGt2bSkpIHsNCj4gKwkJcHJf
dGR4X2Vycm9yXzIoVERIX01FTV9QQUdFX0RFTU9URSwgZXJyLCBlbnRyeSwgbGV2ZWxfc3RhdGUp
Ow0KPiArCQlyZXR1cm4gLUVJTzsNCj4gKwl9DQo+ICsJcmV0dXJuIDA7DQo+ICt9DQo+ICsNCj4g
K2ludCB0ZHhfc2VwdF9zcGxpdF9wcml2YXRlX3NwdChzdHJ1Y3Qga3ZtICprdm0sIGdmbl90IGdm
biwgZW51bSBwZ19sZXZlbCBsZXZlbCwNCj4gKwkJCcKgwqDCoMKgwqDCoCB2b2lkICpwcml2YXRl
X3NwdCkNCj4gK3sNCj4gKwlzdHJ1Y3QgcGFnZSAqcGFnZSA9IHZpcnRfdG9fcGFnZShwcml2YXRl
X3NwdCk7DQo+ICsJaW50IHJldDsNCj4gKw0KPiArCWlmIChLVk1fQlVHX09OKHRvX2t2bV90ZHgo
a3ZtKS0+c3RhdGUgIT0gVERfU1RBVEVfUlVOTkFCTEUgfHwgbGV2ZWwgIT0gUEdfTEVWRUxfMk0s
IGt2bSkpDQo+ICsJCXJldHVybiAtRUlOVkFMOw0KPiArDQo+ICsJcmV0ID0gdGR4X3NlcHRfemFw
X3ByaXZhdGVfc3B0ZShrdm0sIGdmbiwgbGV2ZWwsIHBhZ2UpOw0KPiArCWlmIChyZXQgPD0gMCkN
Cj4gKwkJcmV0dXJuIHJldDsNCj4gKw0KPiArCXRkeF90cmFjayhrdm0pOw0KPiArDQo+ICsJcmV0
dXJuIHRkeF9zcHRlX2RlbW90ZV9wcml2YXRlX3NwdGUoa3ZtLCBnZm4sIGxldmVsLCBwYWdlKTsN
Cj4gK30NCg0KVGhlIGxhdGVzdCBURFggZG9jcyB0YWxrIGFib3V0IGEgZmVhdHVyZSBjYWxsZWQg
Tk9OX0JMT0NLSU5HX1JFU0laRS4gSXQgYWxsb3dzDQpmb3IgZGVtb3RlIHdpdGhvdXQgYmxvY2tp
bmcuIElmIHdlIHJlbHkgb24gdGhpcyBmZWF0dXJlIHdlIGNvdWxkIHNpbXBsaWZ5IHRoaXMNCmNv
ZGUuIE5vdCBoYXZpbmcgdHJhbnNpdG9yeSBibG9ja2VkIHN0YXRlIHdvdWxkIHJlZHVjZSB0aGUg
c2NlbmFyaW9zIHRoYXQgaGF2ZQ0KdG8gYmUgYWNjb3VudGVkIGZvci4gV2UgY291bGQgYWxzbyBt
YWtlIGRlbW90ZSBvcGVyYXRpb24gYWNjb21tb2RhdGUgZmFpbHVyZXMNCihyb2xsYmFjayBvbiBT
RUFNQ0FMTCBCVVNZIGlzc3VlKSwgd2hpY2ggbWVhbnMgbW11IHdyaXRlIGxvY2sgaXMgbm8gbG9u
Z2VyDQpuZWVkZWQuIEl0IHdvdWxkIGhhdmUgaGVscGVkIHRoZSBmYXVsdCBwYXRoIGRlbW90ZSBp
c3N1ZSwgd2hpY2ggd2UgaGF2ZSBub3cNCndvcmtlZCBhcm91bmQuIEJ1dCBzdGlsbCwgaXQgc2Vl
bXMgbW9yZSBmbGV4aWJsZSBhcyB3ZWxsIGFzIHNpbXBsZXIuDQoNCldoYXQgYWJvdXQgd2UgcmVs
eSBvbiBpdCB0aGlzIGZlYXR1cmUgZm9yIEtWTSBURFggaHVnZSBtYXBwaW5ncz8NCg==

