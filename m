Return-Path: <kvm+bounces-58436-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F66EB93D5D
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 03:27:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7FF6A1905C9E
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 01:27:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E2F1228CB0;
	Tue, 23 Sep 2025 01:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YGA+rNFv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B08351DED5B;
	Tue, 23 Sep 2025 01:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758590812; cv=fail; b=njJAYgtwCFZXNfpfBnQyDPdEkdxIfsXpDdz+iJAYmBsq6hbcprUW1cyRXH0CMer7C0GgvfKTJ1R1XSqerUg9F9Hh9Y72jaCyhpQb+9bGInLCfwagWWB5nh1D9RNsYg5ZaD1Z26q5IERmtrIXnHSprSFBi+kGaxhtHe1mHJV1IM8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758590812; c=relaxed/simple;
	bh=nDU+adRl7LL2dZZV7+4Rd0pnVv6jwhGKX4f0O5FB/58=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gc++EvMI4ThsXDa6RSF6jDE2Tn8GLLelWOQynVZNR5qMwi9ArKf194NYLPonrwtfsNeMXwfxunc44nNcNm/TjgR3sL1Hr7svnl5uK/1645mFoq40EPH+yplNvI+9w++5tIdJVZx0TV3JJ9Fb9w3XCLoUYi9Sfp+4gbmlZcAp5O0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YGA+rNFv; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758590811; x=1790126811;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=nDU+adRl7LL2dZZV7+4Rd0pnVv6jwhGKX4f0O5FB/58=;
  b=YGA+rNFvGaW/tR3ONAaP96GumCORwEUBLRgJP3R3XuXGiABvgRRGOme1
   F6cM8+H2XVYK9Qv8fySwavKKjzNh5q008g8jp3h4DQrblY1GJMwvnfGIf
   xffx/t3Dj3gXKzqq9CBtI7YMMqiT6mV94ULG5FYdPy4af9MJhWKojj+Gr
   egE+VjmFqc5dv22vpDfPjuxC6w5ciiOrKXcUYr5ETaeZzSCnQuXYQFObZ
   kc1or68vKVBUDUtUyCP7D3t4zF/EqUPLTwTOGCBEwFHHYz++cEmoip4D7
   VrGIQ8aaHTWS5C6iHCRivhl3zoF3+MJhweepvVsWitcJ8HujyQr+nkiL/
   A==;
X-CSE-ConnectionGUID: lzsSRcSxTEysuHeQrUtN0Q==
X-CSE-MsgGUID: yoydtaHwT1OZt0uEEuxpjw==
X-IronPort-AV: E=McAfee;i="6800,10657,11561"; a="60786981"
X-IronPort-AV: E=Sophos;i="6.18,286,1751266800"; 
   d="scan'208";a="60786981"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 18:26:50 -0700
X-CSE-ConnectionGUID: KwwmlqrvSqG8fhM4mxMeiA==
X-CSE-MsgGUID: 0t1FGjHpTJCly2r03v+E3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,286,1751266800"; 
   d="scan'208";a="181874330"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 18:26:49 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 22 Sep 2025 18:26:48 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Mon, 22 Sep 2025 18:26:48 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.59) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 22 Sep 2025 18:26:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sXVL289etIRYLDwjLWgBjI1l7b05l7MAzaq4W2f6t9+uAdalyy5XR9k4sKJ+XEjuB6CyxgDX5+T5OYUMb+O3xmR2qqZRDhkhpTWqiJtNrkJ9TOW3aSK9LnaSzCNu7Dx+o9mGWPQFmxJaL4n40TKg2I3W3Lzyz/Acs4UwGuB054c99+7ZI+VQz59oKgnOROvZN91ruD4tee/GzX6o2srcIbYRzE5eHsTV0v7VEkJCsc/DBFi4kN6CrzIWxSsnYe0lB3vjNdqVfveUdXJdnHfqhfDL3BteuPIaZLnDXJsrPBUSNXy/w2vpkK+suJdhx1hu7ZqZzyAX2t1C1iPOvETXNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nDU+adRl7LL2dZZV7+4Rd0pnVv6jwhGKX4f0O5FB/58=;
 b=kVq3T+r53GgJsYkQYxqRX04GAdMAEHeMxo0QMwths3wOW8h+JTxse/bskNHC861pgbXteAv3waLGSFLdjGOqLH3q1JLAt13BhM0CQY91Kp3BHTQalQcdiKu6RvkfA7qHIxmcKa7mCy7OHdPge0DA0o6SGFns4N5KUswNzgbFwExvvW7JMTbfDbUVGPAYG2WG/wk/qgJtmXM0ns268UEbDr/W6wJozwbJ2EC2ak3yeueO3v/Fn98fyEP/BqYuu0spjSjMMS70U5y5JbasSVVNLbA6NlPNB2w2oUspoNvshtdusq+kx/qwcKa/u4g1YKbWmguS8cuSDZYpp5yjiEnVng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by SA0PR11MB4605.namprd11.prod.outlook.com (2603:10b6:806:95::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Tue, 23 Sep
 2025 01:26:46 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9137.018; Tue, 23 Sep 2025
 01:26:46 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Kohler, Jon" <jon@nutanix.com>, "seanjc@google.com" <seanjc@google.com>
CC: "khushit.shah@nutanix.com" <khushit.shah@nutanix.com>, "x86@kernel.org"
	<x86@kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "hpa@zytor.com" <hpa@zytor.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "bp@alien8.de" <bp@alien8.de>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: skip userspace IOAPIC EOI exit when Directed
 EOI is enabled
Thread-Topic: [PATCH] KVM: x86: skip userspace IOAPIC EOI exit when Directed
 EOI is enabled
Thread-Index: AQHcKLR2qfH/HOUBJUuLEhaZhzaNXbSfxJ6AgAA8NYA=
Date: Tue, 23 Sep 2025 01:26:46 +0000
Message-ID: <a4febcc09bbe15efc043e6ec9f49485e9459adca.camel@intel.com>
References: <20250918162529.640943-1-jon@nutanix.com>
	 <aNHE0U3qxEOniXqO@google.com>
In-Reply-To: <aNHE0U3qxEOniXqO@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|SA0PR11MB4605:EE_
x-ms-office365-filtering-correlation-id: 9bbf95ae-ca29-4a00-8b1d-08ddfa404308
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700021|7053199007;
x-microsoft-antispam-message-info: =?utf-8?B?dlMzNWk0UmtlUW96c29jMnBOTTJDQTg0YXdQdDV3WENoZGY3emlEWTYrenRq?=
 =?utf-8?B?L2ttMkVUcHNZYjNUd0FLZXZienA3alJFdjhnenJpeVdjbSszaW9RM09zc1lZ?=
 =?utf-8?B?VmkvWGZEaDdlUzB1MkdhbFhjWHBMV2NyNTJLMHFoUUNJM2xQU3BKb0VLb0Rn?=
 =?utf-8?B?T1FPTjBZSGIrRFdBZFJGZTVQZFczQ1hyZUZ3SW1QNlQ3clhESktQSmdxeWhW?=
 =?utf-8?B?dVFFc3hUQ1dZRklRREZTdGtIL2w2MWNnYWtnUG52d29GNXAzUytDTjA0Ym5Z?=
 =?utf-8?B?NEw0YzdFQVZuUjVPMjBMY0J2dUtpVUhRMytKSmNRS09iUGdMcjZwY3ZoZklT?=
 =?utf-8?B?dkZXeXRNTTRtWjlYSjc2a2Q5T3dFbzhwTXgyMVhXbEJmdVBjNUlDRHlOVFFO?=
 =?utf-8?B?VUNrakNzdm8zS21Vdk01cktkdHh3OUZGV2l0ZmVCVUlHcXRxVmtlbjY3bnhR?=
 =?utf-8?B?V0x4Ylk2S2pjMXNHNnkycmFpY0N4NEVUQk84aXN0ZWcrZy9Db2d2ZStRSC81?=
 =?utf-8?B?OWNja2NDckd0VXFpR1NiTUU5Ukt1N01oMCsrL2VCTWh1M3c2SG9XbEJmK0hV?=
 =?utf-8?B?WXdBQnBRVm92RUhtaldLWlBvd1VyZU5heDZkbG44STNTQ0pYTERIV1RZeEgv?=
 =?utf-8?B?N3FQZ3lBWHJEaUZRc2FpUGRiR0RNRVI1L3ZDTVhyM0pXM0NWZmd4Qmx4Wis5?=
 =?utf-8?B?TVFrbWIzQ3JEeENxK2E4QXZZdkI3akRYNnJ0UFltZXNVY2w2cHhxT1R6R05j?=
 =?utf-8?B?aktFY082QjRhNmVReGU4TS9EZ2JZMkpEZEZOQnhZd0ZPQ1ByWEJtcTIvSlJN?=
 =?utf-8?B?bzJsa2JLQjQrYjhYSzRIbHZ3akxDOC9RcWtFbHhReElxaTQzN2QzcVlwS2NU?=
 =?utf-8?B?SlBOT3JBcm1NRm4vdzNQUEVXTnRSM2lYeE1oVmQ1VCtoZkwzenN0a2V5S0dw?=
 =?utf-8?B?cUxMRXYvdi9NY0c5d1ppRlpsWXpDNFV2dEhKbkV1Q2ZvT2hYNVpNWDQ0S0o0?=
 =?utf-8?B?b0dHL2J0QTM5WnRVMnlSQUFFYmtSZmcxdU9FNE5SU2ltd3lhaEJYN3BRY21n?=
 =?utf-8?B?Z2JwZWp2Zy9XK2lRTTZ1c2QyT3V3SjE5RU13ZUJTMlR1Z2RTZUF6ZndFWE9y?=
 =?utf-8?B?L1BOYlNXNkoyLzBITG5BZHRiVEl6U0w2Q3V3dDBGNS9oSFF0N1VSVFFLb1B1?=
 =?utf-8?B?SGZYcW5jbHJHc2dIY29QS28wRkprNEVCdElpLzdORE9nWFAzWjVQcGVCVEg4?=
 =?utf-8?B?eU1oaTNFc08yTG5iMFV1SFU0K1FaMEJ5MkNXNTYybUJ3WmRDL1d0NVFOUWZ5?=
 =?utf-8?B?dURwT24xQUhFb3Q3RERiUGljNVVNV0hLUE5uY3l2dHRPaE0yck1sRzc0N1Fy?=
 =?utf-8?B?SjlSd0R2d3BFZDBBYTJhUXRlV1NCdWxrTmpwTDhibDFocXpZZTUxQWx5dWMz?=
 =?utf-8?B?bmxpT05JMFRmTWFLcnRDMW1GV2h4ekhxYlQzdzF5V000WHBYSHhUaHpLbzE3?=
 =?utf-8?B?S213Q05yckttdTQrNWlmQkNkRG5Ta1lQUHk3bjhYV1B0WHhoNks3MCtMMXRl?=
 =?utf-8?B?QUlmQzYwZXdHTC8zR3EvcDJoV2FQSVlGenM2QkUwMUJBeDhIS2h3a2ZTcHZu?=
 =?utf-8?B?OFF4eGtGRVhkNDJMWHhzZzlGL3dNaWlRRVdJQ1poS1p5MFNNU0d4V2lEMHhY?=
 =?utf-8?B?T1h4ZXI3QW0zRVpJeHY3enhXUlo2cDA1Y0M3K2Z5Zndoem5KbjN4R3JrWEdF?=
 =?utf-8?B?M0QvVUc4bmFRalJFbUkxY3cxQm5kMDNaM0tyY1hIaUwzZXNtMXVKelZJbW9s?=
 =?utf-8?B?UkhSdEFCenQrVXhiMEtuV0xveGhscmZtQks0VHkwVSt3L2lxeVg3QXE5ZnJh?=
 =?utf-8?B?OGNmYkx0aXJTZEpZMUtvN2dEcmNRNW8rSmlWU2NFajZmNVVSSzQzcURLMFFH?=
 =?utf-8?Q?X2OCUOA7G6RidIc1JVVUtNOsHTzPSHRh?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700021)(7053199007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YU82QUFnU0pOV21wQ3NEVTgyZTF1UzlhL2VrcWREdm56bE91ckVVTC8rVXhx?=
 =?utf-8?B?UUtCRStRUzEvRlNQNVVVZnRka2x1TXdXeXh2NEEvSS9uVVlvMFV0KzRUeDB5?=
 =?utf-8?B?VDJWcEp4bHFtait1UnVPWllreGpZMVNDcWN3UzR5V2EvWGtaaitrRi9leDVl?=
 =?utf-8?B?TlVHcTByWENwMmZ3My9RSWpzc0hvWHNtYUtxQUhVaGE4elRRM0RkY1RnSE1X?=
 =?utf-8?B?Rll2SmpvRUFOWmtxRTJQVWNZb0orNFdwbDBrbVVjMlVvTExsU0UrUWlUaEt3?=
 =?utf-8?B?TUtkT2o4WkdTM3FIZ2VrL256dGhyT0tMOWJiV0YrNGtZMmVodGlGOGJ3c1BX?=
 =?utf-8?B?NG93QUdrZTRZQlpsTnJGS29Sbjd3aWVCOG51SVdPbDZsYXN5MjZtN2tzdVdB?=
 =?utf-8?B?eTArQXMrVU1lUVYxK0pNS3NHZmdnWjA0TlgzTXAzUVo1ajVVTk5FNzM5NTVD?=
 =?utf-8?B?QWZxeGxxUFRtNERCU2xRSmxjdkgrekVoUFpBSFlwZDJnaEgyTDhqbjhNWnQx?=
 =?utf-8?B?S3NnVFdRbU1maU5jR2ZjYjcvRWlGY1VPOGVZZy9LOGNyN3B1R2VwTjI5c1dL?=
 =?utf-8?B?R1ZEdEQ4ditxckg4MjE0QkJrN0dVNjJtTkhHL0NYVmdLOGhvbThxeFp1OHh6?=
 =?utf-8?B?V1U0eU1BTzRIKzZHMm9lcXNaOUV0WktmcnM0UEg1Vlh3UnlCM0l5WGVSMHA0?=
 =?utf-8?B?M0phT3hBcWpsclFSd2FBUWVoREZuRnIxWGMydEMxVDMyTjBKaWlDcTlvSE4v?=
 =?utf-8?B?T0ZhWUpwUDVVdkxqb1lnRC93eGtwdXZJNlQrTy9taVpiTXpOWm45TmpWd1ZY?=
 =?utf-8?B?TEZiMm9GYjZZazVDc3dxQ2k1VjhHUXltM1RtUG9nMDVDd0U1VUx2TTEvMHdi?=
 =?utf-8?B?MGhBc1pKUXdHY0NEN2J1NjdmMEpLSTBCbXdKdVRUc2FOQ0o0SkV0TWFLRy9t?=
 =?utf-8?B?bUUvZm1sSWErL0tVNDhmUFdUcWZVczBQRURVS3Vvd0xPZDR0THVTalFpVlc1?=
 =?utf-8?B?RmREdmVwSHU2SjVnaWRzK3FzSXZZdTZyVE5HV1BIYnJRd0o3V0RRMDR4Q1lm?=
 =?utf-8?B?RDE2amphNTFjMjUxM09JR2Ewcm9tMzNpNjAvMUJCVVJuZzIzZXpLeFJZQncx?=
 =?utf-8?B?NThOSW1lUlJJd0ZKSWs3UCt2NlRyaHBpTjFtcmRtdFNBV0tmRnZmOHlIUUtJ?=
 =?utf-8?B?eDYyZVFQQ3paa2pqT3dQc1R3OEZFS3MyMjVlSFI4SHp2Q3ZrVUxCTHAyQ1Fp?=
 =?utf-8?B?YVpQcldtTSswUFJ5QlBEdFBBYWpoZmk2dFRDRElEcmRzbkptVnF0T1NJWWhR?=
 =?utf-8?B?YlRFajZFM3Fybm5hU0NGc2NiZWFPKy9lYXA3cDNwbWhkeHNLeko0dzE2YkVj?=
 =?utf-8?B?aldlMGFkUmNWelRjZ2lmbmdOUm9Edm1kRlRzWWVYTXF4eFBlNmFkU2ZaS2lY?=
 =?utf-8?B?aDcwdUpOQmZUd3VNMVM2eVFhZjFVdStqUWVVU2lKanVmWEhab0JCL0kraGZ6?=
 =?utf-8?B?cnhHSU5OTnRzY3VhQTNoakFJbFdNd3dWR2xrR3VGb0dmMjF2NkFYYXJ1UXlS?=
 =?utf-8?B?bU5mMWNkNG1URE4vaTIrMU5CY0JlVkJ3S1I0dmdzNnk3VXdCUXdSeFcrYWZB?=
 =?utf-8?B?YnN5a2l4cEkwTFZ6TElZdEIzYmsxZDNtUzBPM2RmbjZCdVlPUzkrL3JFR0xp?=
 =?utf-8?B?b0dPM1I0eHh4U25uMmx0VGxzTytuVFFrZm1zcXlmcmZxcXNoZi9ZSE15ZVRu?=
 =?utf-8?B?QmlUU0NrdmV6YWZvTXdrUGRHaGhXREozQzhjZTRnVTB6MHE1YndpemVCSnRa?=
 =?utf-8?B?VmllbUZtZTN4cTNVMVJGckkrcERubjNTTktLb3JwbnI1YVZZL3RPeVpkMmo4?=
 =?utf-8?B?L29TZk5kWE11Z050aWVmZTRnVDFDWU1OcHFJWFFOT01EbTlMdWhEWVcxTExl?=
 =?utf-8?B?aUx6Y05raUxUWkxBajZSV3QzdE9DKzYvcHJaZFlSRFZkQ01MNWtrcjRhbUt4?=
 =?utf-8?B?VUhTR3d3cExGQzFzWjF2b1lwVDd0NFFFRE9IK3J6K1dOcHN6TkRhK0xUejlw?=
 =?utf-8?B?d04rVW56Y3UzQThIbmRFb1BwSDRIeTZHclBaMjVOR2RNaXFYemIwK2srY3Vs?=
 =?utf-8?Q?aOCXP1jBBGh5D6Z64c07Fk/Eb?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1B5CC03FF68A334CAD0432695EC4AD1E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bbf95ae-ca29-4a00-8b1d-08ddfa404308
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2025 01:26:46.5520
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rNfcajZjW7jGWm3PusLv+P3AN896RtxN7/WQFKXxwTChJNylTIX6Ww91iVLouu+uHNOL60b07VMlOWDtw/dG0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4605
X-OriginatorOrg: intel.com

DQo+IEZyb206IEtodXNoaXQgU2hhaCA8a2h1c2hpdC5zaGFoQG51dGFuaXguY29tPg0KPiBEYXRl
OiBUaHUsIDE4IFNlcCAyMDI1IDA5OjI1OjI4IC0wNzAwDQo+IFN1YmplY3Q6IFtQQVRDSF0gS1ZN
OiB4ODY6IFN1cHByZXNzIEVPSSBicm9hZGNhc3RzIHdpdGggc3BsaXQgSVJRQ0hJUCBpZg0KPiAg
RGlyZWN0ZWQgRU9JIGlzIGVuYWJsZWQNCj4gDQo+IERvIG5vdCBnZW5lcmF0ZSBhIEtWTV9FWElU
X0lPQVBJQ19FT0kgZXhpdCB0byB1c2Vyc3BhY2Ugd2hlbiBoYW5kbGluZyBFT0lzDQo+IGZvciBh
IHNwbGl0IElSUUNISVAgYW5kIHRoZSB2Q1BVIGhhcyBlbmFibGVkIERpcmVjdGVkIEVPSXMgaW4g
aXRzIGxvY2FsDQo+IEFQSUMsIGkuZS4gaWYgdGhlIGd1ZXN0IGhhcyBzZXQgIlN1cHByZXNzIEVP
SSBCcm9hZGNhc3RzIiBpbiBJbnRlbA0KPiBwYXJsYW5jZS4NCj4gDQo+IEluY29ycmVjdGx5IGJy
b2FkY2FzdGluZyBFT0lzIGNhbiBsZWFkIHRvIGEgcG90ZW50aWFsbHkgZmF0YWwgaW50ZXJydXB0
DQo+IHN0b3JtIGlmIHRoZSBJUlEgbGluZSBpcyBzdGlsbCBhc3NlcnRlZCBhbmQgdXNlcnNwYWNl
IHJlYWN0cyB0byB0aGUgRU9JIGJ5DQo+IHJlLWluamVjdGluZyB0aGUgSVJRLiAgRS5nLiBXaW5k
b3dzIHdpdGggSHlwZXItViBlbmFibGVkIGdldHMgc3R1Y2sgZHVyaW5nDQo+IGJvb3Qgd2hlbiBy
dW5uaW5nIHVuZGVyIFFFTVUgd2l0aCBhIHNwbGl0IElSUUNISVAuDQo+IA0KPiBOb3RlLCBTdXBw
cmVzcyBFT0kgQnJvYWRjYXN0cyBpcyBkZWZpbmVkIG9ubHkgaW4gSW50ZWwncyBTRE0sIG5vdCBp
biBBTUQncw0KPiBBUE0uICBCdXQgdGhlIGJpdCBpcyB3cml0YWJsZSBvbiBzb21lIEFNRCBDUFVz
LCBlLmcuIFR1cmluLCBhbmQgS1ZNJ3MgQUJJDQo+IGlzIHRvIHN1cHBvcnQgRGlyZWN0ZWQgRU9J
IChLVk0ncyBuYW1lKSBpcnJlc3BlY3RpdmUgb2YgZ3Vlc3QgQ1BVIHZlbmRvci4NCj4gDQo+IE5v
dGUgIzIsIEtWTSBkb2Vzbid0IHN1cHBvcnQgRGlyZWN0ZWQgRU9JcyBmb3IgaXRzIGluLWtlcm5l
bCBJL08gQVBJQy4NCj4gU2VlIGNvbW1pdCAwYmNjM2ZiOTViOTcgKCJLVk06IGxhcGljOiBzdG9w
IGFkdmVydGlzaW5nIERJUkVDVEVEX0VPSSB3aGVuDQo+IGluLWtlcm5lbCBJT0FQSUMgaXMgaW4g
dXNlIikuDQo+IA0KPiBGaXhlczogNzU0M2E2MzVhYTA5ICgiS1ZNOiB4ODY6IEFkZCBLVk0gZXhp
dCBmb3IgSU9BUElDIEVPSXMiKQ0KPiBDYzogc3RhYmxlQHZnZXIua2VybmVsLm9yZw0KPiBDbG9z
ZXM6IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2t2bS83RDQ5N0VGMS02MDdELTREMzctOThFNy1E
QUY5NUYwOTkzNDJAbnV0YW5peC5jb20NCj4gU2lnbmVkLW9mZi1ieTogS2h1c2hpdCBTaGFoIDxr
aHVzaGl0LnNoYWhAbnV0YW5peC5jb20+DQo+IExpbms6IGh0dHBzOi8vbG9yZS5rZXJuZWwub3Jn
L3IvMjAyNTA5MTgxNjI1MjkuNjQwOTQzLTEtam9uQG51dGFuaXguY29tDQo+IFtzZWFuOiByZXdy
aXRlIGNoYW5nZWxvZyBhbmQgY29tbWVudF0NCj4gU2lnbmVkLW9mZi1ieTogU2VhbiBDaHJpc3Rv
cGhlcnNvbiA8c2VhbmpjQGdvb2dsZS5jb20+DQoNClJldmlld2VkLWJ5OiBLYWkgSHVhbmcgPGth
aS5odWFuZ0BpbnRlbC5jb20+DQoNCj4gLS0tDQo+ICBhcmNoL3g4Ni9rdm0vbGFwaWMuYyB8IDkg
KysrKysrKysrDQo+ICAxIGZpbGUgY2hhbmdlZCwgOSBpbnNlcnRpb25zKCspDQo+IA0KPiBkaWZm
IC0tZ2l0IGEvYXJjaC94ODYva3ZtL2xhcGljLmMgYi9hcmNoL3g4Ni9rdm0vbGFwaWMuYw0KPiBp
bmRleCA1ZmM0MzczNDFlMDMuLjRkNzcxMTJiODg3ZCAxMDA2NDQNCj4gLS0tIGEvYXJjaC94ODYv
a3ZtL2xhcGljLmMNCj4gKysrIGIvYXJjaC94ODYva3ZtL2xhcGljLmMNCj4gQEAgLTE0MjksNiAr
MTQyOSwxNSBAQCBzdGF0aWMgdm9pZCBrdm1faW9hcGljX3NlbmRfZW9pKHN0cnVjdCBrdm1fbGFw
aWMgKmFwaWMsIGludCB2ZWN0b3IpDQo+ICANCj4gIAkvKiBSZXF1ZXN0IGEgS1ZNIGV4aXQgdG8g
aW5mb3JtIHRoZSB1c2Vyc3BhY2UgSU9BUElDLiAqLw0KPiAgCWlmIChpcnFjaGlwX3NwbGl0KGFw
aWMtPnZjcHUtPmt2bSkpIHsNCj4gKwkJLyoNCj4gKwkJICogRG9uJ3QgZXhpdCB0byB1c2Vyc3Bh
Y2UgaWYgdGhlIGd1ZXN0IGhhcyBlbmFibGVkIERpcmVjdGVkDQo+ICsJCSAqIEVPSSwgYS5rLmEu
IFN1cHByZXNzIEVPSSBCcm9hZGNhc3RzLCBpbiB3aGljaCB0aGUgbG9jYWwgQVBJQw0KPiArCQkg
KiBkb2Vzbid0IGJyb2FkY2FzdCBFT0lzICh0aGUgdGhlIGd1ZXN0IG11c3QgRU9JIHRoZSB0YXJn
ZXQNCj4gKwkJICogSS9PIEFQSUMocykgZGlyZWN0bHkpLg0KPiArCQkgKi8NCj4gKwkJaWYgKGt2
bV9sYXBpY19nZXRfcmVnKGFwaWMsIEFQSUNfU1BJVikgJiBBUElDX1NQSVZfRElSRUNURURfRU9J
KQ0KPiArCQkJcmV0dXJuOw0KPiArDQo+ICAJCWFwaWMtPnZjcHUtPmFyY2gucGVuZGluZ19pb2Fw
aWNfZW9pID0gdmVjdG9yOw0KPiAgCQlrdm1fbWFrZV9yZXF1ZXN0KEtWTV9SRVFfSU9BUElDX0VP
SV9FWElULCBhcGljLT52Y3B1KTsNCj4gIAkJcmV0dXJuOw0KPiANCj4gYmFzZS1jb21taXQ6IDA3
ZTI3YWQxNjM5OWFmY2Q2OTNiZTIwMjExYjBkZmFlNjNlMDYxNWYNCj4gLS0NCg==

