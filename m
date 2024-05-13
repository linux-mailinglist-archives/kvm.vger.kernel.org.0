Return-Path: <kvm+bounces-17313-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C6D48C414A
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 14:59:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9A4D61F24451
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 12:59:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA3651514EF;
	Mon, 13 May 2024 12:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gbf2Jbb0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B1E71474BC;
	Mon, 13 May 2024 12:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715605170; cv=fail; b=Wi77GzzEq0JR0vEtfm48Y9Rbz2rfbhPXoIMG/FycFfN2iQy2Y/exwRCqas6rZbpo2FhgqUY6ppxt2MmRZHqoC4adXOSTxkhAV46vcIJ76X2Ed0GSEBGCeWAxBdu5VeXWlfhypgLHetg+5/EsbpgOK63xmDQQeixYE7c5sJP+wKY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715605170; c=relaxed/simple;
	bh=EqMy2Lua8U3QDtkjqnfvdUJZB0YcBan4Drs++kxz17c=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bY4Q42BkH0YogyuZSDiHN+O2LghOQU71XeRHusHTFw6Ql32vvDPbFQaBhR6iD4AGuax2b4xXRe6anJTKrDMkJ1MVAqIKWKkR5+i6Yf7O94wTz9LDgDvGeBIIHEyiKUgISnJ6+Wx4kGqev2/fLUDHpssu3wyr1UZ0bGuLgys2Y0o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gbf2Jbb0; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715605168; x=1747141168;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=EqMy2Lua8U3QDtkjqnfvdUJZB0YcBan4Drs++kxz17c=;
  b=gbf2Jbb03J5sWR5TmuTc6kGRsl40yNiPbXdoV7xSnveRQjnTS4hFXig4
   INXOdlrQ88EHYGIL1BbwbRTWrnNYyYz/XHPe9oZdQBOE9qUbzfNDrV4t7
   h5J3GTmdP2i099TmB1TWK/UV8FGWgzdHfOCRzOw1ReosWGd/S7er3K46W
   AEdTz79+sK3LFXg9g77feOyaoqQaVpETy9v6jV/iMq+ROnG2B353KhIl0
   E7Z5OpeiQHE+ABh8Qds77HKgvulC3L27nLZuNqP0kRlCjpoXo16ERN0jz
   nBKnzur4stuYeXkMW8AaAzlt3HTjPo1ycPOzkY50+QjBeHysb/d/nTSog
   g==;
X-CSE-ConnectionGUID: M2DggK8HRo260JNgHN6dpg==
X-CSE-MsgGUID: 9xTPIgvORICFqD1Rc7xu7w==
X-IronPort-AV: E=McAfee;i="6600,9927,11071"; a="22136402"
X-IronPort-AV: E=Sophos;i="6.08,158,1712646000"; 
   d="scan'208";a="22136402"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2024 05:59:28 -0700
X-CSE-ConnectionGUID: p4992OK1Qd60Gf/OewkVHg==
X-CSE-MsgGUID: 8Aw14KDKQSW4TfGEEEtHIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,158,1712646000"; 
   d="scan'208";a="35197124"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 May 2024 05:59:28 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 13 May 2024 05:59:27 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 13 May 2024 05:59:26 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 13 May 2024 05:59:26 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 13 May 2024 05:59:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HTYwtlHKOlAC7Nop42yCvqckCpT8L89P2WF7k1vQ+gJQdR4peCjwpPHz6s4nHY7U3hkKeDSWsAkv4RzKqnr4x9UrLQYmuZNPTxK1tX+58pyvWrfDz0sUSjqj0yTrOPKsE9Z1UjCRJ+HXgal+pe9dUU/PeFQ5AqMUK1piHL3IbOpuqHbQ3WNe0WgFeumWKRwnJdmarECKOMabE+X67+WqZOKI4P3uvqmfQnu5MASRpUaujByfpGpKc3ZVblGcY8VMz8VsLsDyk/TCYuADXky/UDkqf6g78jI14/0kb+tJX9/vu4yZQaUJq6qyQgFiupgxAFFxmfBmKX1QQpqnErwLVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EqMy2Lua8U3QDtkjqnfvdUJZB0YcBan4Drs++kxz17c=;
 b=KpXGjXDyNwQOKMAMS0WCP3dbynF1NWudSzN7qTUmUY5Do7n/iIPfQ6HRYCbFvPwrc4roLNFeRDbN9L3hKy1Y8QY8dZSDMWBPcezMgTW+fH2AExWQ4To4pDpOD90+NUPv0qIHaGjGz7ZlffwdaiE2+veJlPZVAvagIvCfRA7zB3C7jQs/liUIbSLA51IhjMpUbHjJv20dQaNe6JMoZc2A3902oyUmkKWjIJfjxUyjhrMgDMuVQYsvCJe8+Da5VhEGjsgqGswXFoKI+gGX782PxJ7lJuxeiCKN3nQ4TW9j0H1/BXqKFOGl/IoBeZRAKLyQSO67CBkrnhiVQh2XKL0xNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by IA1PR11MB8246.namprd11.prod.outlook.com (2603:10b6:208:445::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Mon, 13 May
 2024 12:59:24 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7544.052; Mon, 13 May 2024
 12:59:24 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] KVM: Rename functions related to enabling
 virtualization hardware
Thread-Topic: [PATCH 4/4] KVM: Rename functions related to enabling
 virtualization hardware
Thread-Index: AQHal2odX7QwXH0ic0uvaDNv+lBPGbGVO+sA
Date: Mon, 13 May 2024 12:59:24 +0000
Message-ID: <4f2112f3c4f62607a1186faa138ccc06f38ee523.camel@intel.com>
References: <20240425233951.3344485-1-seanjc@google.com>
	 <20240425233951.3344485-5-seanjc@google.com>
In-Reply-To: <20240425233951.3344485-5-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|IA1PR11MB8246:EE_
x-ms-office365-filtering-correlation-id: 0b9acc48-1347-4979-4d94-08dc734c83c9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|1800799015|376005|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?MnE1djFUOGVUaFFDVzZSZzIrcmxrVFN0NTMyWE5ub0RhZW16STliWDI1b2ZY?=
 =?utf-8?B?RTdnY2VzWEI5NEwrMTlEelI4Z3BRWW1HT1NSSFpLWlJQUmhWbWoxblpLYlpv?=
 =?utf-8?B?ditIWlBTS0h0NGVxUkVvZm9wVkhFMUxqVGZwd2FpMjk3bmljTmFKVkpTempa?=
 =?utf-8?B?YWV5UFZSU1hyYkxMdXpkOU16YkhhTGFuekQ5QlNYQkx2cEd5cHlFKzhDa1J2?=
 =?utf-8?B?UFp2OU9IbDJJSHFzbzhaTFJJVW9IQXVZaDlXaU5ORWROZ3dKcU5TRXlMbDFO?=
 =?utf-8?B?Ukw3SlVCNVF2N29pUDJxTUorS0JvWXpLNFlOZlFzd29LNWZ6N1AxbnF5aDhr?=
 =?utf-8?B?RjI5ajUzdjZoYWxzS1RKSGNpWDRIUXlaUHE5SzZKaTZkWkRJYVBkT3hsS2hq?=
 =?utf-8?B?c2hTOTczcUtBKzRZczJiTTBiYmVScExJbGN2OWRJeHFZNUtEZEJWTm0zV2Ey?=
 =?utf-8?B?ZVlxSnA5SVROWGdlZ1l6d0o5WUp4dFhObkRKdW5SN0tHbS9ZUFhUd1RUaTU3?=
 =?utf-8?B?dWhTR0k3RE9iUHVkWFVGaE94WGYzdjJ2UkRGNjNzYXRiUXlib0V1T1hSWkFj?=
 =?utf-8?B?L0QzKytuVGZmUDVaNHZGTWI5bUgxR2ZraVpqaFRZUFpPdzRWNi9STThsTGEv?=
 =?utf-8?B?ZmxsQVphdjBkZDFVa0JZTDFqcFpaNVpSM282UG5hQm1BelRoSzZyQ29ocDNM?=
 =?utf-8?B?aktOY2RkNmtPRWZPTVRzSUhzTUEvSnlreHVEYkZPM1dNNTJaNkZGaWFaV1Fz?=
 =?utf-8?B?a0NsSksrOFBaQUt0c2lZMlBHMEpXWWxFS3JnVXYrbFNVd2VBNm9OVHhrY2FX?=
 =?utf-8?B?UzNXVFM2TVBOTUJjcy85bjZPVTEyTFNmR2hHTHFjOEJVRTV5OG9JQWdqdTQ1?=
 =?utf-8?B?TERwZ2tudzdpZHdleFZCVXAvelM5WW10WSs0N1pHNG44Y1hQVDQ5clN6TlZn?=
 =?utf-8?B?ZDRmSVVoMGpGL21Yb0sxQ1FmWFBCbThSVEM4OFJKYWVNWDJabTBzZGtlWWdX?=
 =?utf-8?B?RUdaYW5IcG9lUTJGcjJXYjlvRW5oVUgyZDFoSUU4bTgzMjZUWGdMRG5RZzVy?=
 =?utf-8?B?YnBoYnAzdVZFUWk2cndtbkY3QXFucUQxUlJzTTJtWE1lSUF1NXRRNkFXYXU3?=
 =?utf-8?B?cmhDaWF1WWpNeFU2dGp0NWpwYzlUUHdTTEVXbGExZURaQUs1cTVNN3VzZ2No?=
 =?utf-8?B?TE12NlpzOGZwekJZMGd4Q1FPdCtXQWlQYVVkR0NqMGlkU1pDUEhodEc3UERB?=
 =?utf-8?B?bGVqWXFmWm1NclBXRjBSTkNwTGgzZXh0SmRvYW42RHNlem9CNGd0VDBUSEJi?=
 =?utf-8?B?bmV6MFZET28xK1N2WWRCRDdwQjcvZm12Tkh0QzVjQlVZZVJGenJDWlhLVUsy?=
 =?utf-8?B?MEVrSkRINFZmWGpaNEVWVjJpcE9kNDNNVUpRYXhyemt0QzdseHJaSFJ2eWNm?=
 =?utf-8?B?MGJGOCtNbzBtbmVPdmVEY3RuaU1WbWpBdWZyL1Yvc0liTkJrTmtXM2pFdldC?=
 =?utf-8?B?UzBBMjh3T2tXSkZYakF2YVhjbHJKd25PT0xTeGo5WnhiMUpKS3BRc3RMVU5a?=
 =?utf-8?B?Q0lqQU9jM0lJTzM1amFPRTFML05SaUMyai94dUprOS8vaW1KMnovQ3l3Umlt?=
 =?utf-8?B?MXdWR08rNTE5OGdZRVJYRk9pMGVnYTNGRHNqYTdtdkVOZm1BZjMvSVkvSTJZ?=
 =?utf-8?B?YXNYUTgxRUg1NS9raDlKeStHVzN6UmhOclJrNTVPMGh4NjZVR2V5VXRQMXhE?=
 =?utf-8?B?L2xOZHRBT04zR0VDRDRQcGRYTHA3TWE2NFVwRGkwV1dTSzdGdnRLdE04alNO?=
 =?utf-8?B?YnlFc2tpNXRCeVplMy9yZz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V0R2a05vTStHYm5OdWFtQjgrWGUzanJuaCtIcDRUYlNJQWh4dGUvQk5hQTlN?=
 =?utf-8?B?cjBtRkxrSFRiS2FHWHhMb0JUSDh5MExabTV1YkRsL1RlOUhINDFMT0Jod3dF?=
 =?utf-8?B?ZjBwb0VvamZ4T1ZuR2dIcDd3R1ZDK0J2a01QNFFJbEY3cnlkQmI2WDZWYW10?=
 =?utf-8?B?dXBtaWRjTWN4VExkNmlxejAwL3lmdXNKODZyMDFPcksrSWpwaDNuRU9iNFhj?=
 =?utf-8?B?VCsyVkpyRG9SQUxNcFhDbGF6dTYrNy92SEt4bzY5RXhRaVpicHZhc0xKRTls?=
 =?utf-8?B?eUs3Nzc0QzNRQW9CMjF0NG4zeFppRGpaVE52MDBPY1JDdGxGcnlYSXYzS1Jv?=
 =?utf-8?B?T2ZUVUYxZis0d1FXU2ZGOFFLWFc4OTZuMnc1cDlubVUrV2VFclhTYXdvNG9Y?=
 =?utf-8?B?RnY3aFpESVBDVm54L2wzcm5jZmliZ1dnbk9XMWJRSGdMeDdoaStQeStjdC8r?=
 =?utf-8?B?dW1LWkI4VGdiUmo2M0R2VE93a1NtcVlhMGhVdjA1Um1FU2FLYUNlZ2dIbGFZ?=
 =?utf-8?B?aVNLbU0rNWt6QTNSMG9tczIxQ2JIYmJFWTBPQnhrYnF2a1FMOElLbjRmUXpR?=
 =?utf-8?B?b2ZISWRCL2JhM0xMSVNTWHNuRW56TE55NE8xazNLL1VYbFBGcHlCNUZWWnBh?=
 =?utf-8?B?S1creC90T2NqdTMrUXZlUFlLTktReWh4ci9kZ014UlV6M0NmWExLelZmSHlo?=
 =?utf-8?B?S0V0Z1YyWDdqOTc3T1FsZTdVaHZ6SW0wMlIrTElOZGhvZWg3NXV2ZWpuRHNW?=
 =?utf-8?B?dFk1MXRNSzV1VTYvMUw0YndrdGJzOWtEYVhtUGRJYkttcjc5QnpJTTVVNW1G?=
 =?utf-8?B?Zkh1c0tGTFpEb0crNkx5NFFzbDdCWU40d3lMNWIzTDZtYlpBRm1sajhyL0ND?=
 =?utf-8?B?VHhuR3gveHA1WDQ4bDBCL2wyV2hwSnlMaitDci85RTZ5UnJ2aE5za1VhS1pB?=
 =?utf-8?B?dGtsei95THgzeWZYOFlIY0tHK0UrQnhRZFA4Tm00V1RWQ2N3ZCtUeFg0N2Yx?=
 =?utf-8?B?WnNmNmgyTEhKR0xidk9PZVJoMEtkdmc0eUpGVjVUd2dTVVVTVmlJbmxaQ2Yy?=
 =?utf-8?B?RVczdW4zRWtqbEdzNk90YUVXZFA5ZU1SQnkxa1kvcG9jYlpJbmVNQ3ZBT3JU?=
 =?utf-8?B?VTdVZHZ3WnJ1WW44RG83SHE0NE5vY0hDVEdJbzZXRFFGZUo3SC8wTTVGMGtV?=
 =?utf-8?B?SUVpQmUzMllMM0ZMZDhKb0ZnRWtYNnAxWDVjS1ZnQ2dPTWlSVjB6RWdMdjNv?=
 =?utf-8?B?L0lGUnQwZTUxeHNhUGg2OHpRT0JESlgwQTlFNzJIZ000SktkWEhQNWk1SThK?=
 =?utf-8?B?T05FbnpKdHBPZGYycHc0L1B0VVllNHlQL0Z2Tm50blFEcFZpRUlvQWRsWUlt?=
 =?utf-8?B?Y2pMQ2kyN2V3ZHltYWNQRGIxRE9nK1dFWFFCMjVaR1UwUTZndFdkYjBwaDVa?=
 =?utf-8?B?bTJjMGtJU0ZIU0lxWFZZWXBFK2dKb3ZnSWNoMnJndVZBcVZWWVhPT203Ymhm?=
 =?utf-8?B?MThuV2Q2RFdPU1d6NktUeUVJUWNmUFU4U3Q2NDFYazBxNXd4OVkrbStVNTBw?=
 =?utf-8?B?K0JMM1VMZ1I0NEVhVStTUVFCRGI2YmxQMkNlZG9nZ3NvR2FXSEFMTWNUU1RD?=
 =?utf-8?B?OU8vRWp6RjU1dVZCcm9iM0t5bWk0ampCdVNHempocjlLUHhUYlpLbTlhNm0v?=
 =?utf-8?B?MnR1ZlovRmJxd2IycFBOWmt2RGwzTUovZCt4TWRjb2ZjRHA3S1ZDMFM5T3pw?=
 =?utf-8?B?SFd5eGx3VmVQQU9DYmdBM1pvOHhhb0w2cWxHcHU0aERhWnhlR3ozZ3NiRzFz?=
 =?utf-8?B?WUwydVVDaFdod1MxU1N2TUY0RGhOeVdtdldOVVVPNE14dDBDWjhpTWRucStR?=
 =?utf-8?B?Um50M0tBUVd2MlFrZ0NhSFoxZkI5NlJnUThmbWZLajZ2TWg0a2FDdU5VVmc1?=
 =?utf-8?B?aWFMSENNTFRGdUJlTkhKUjZMcExmaGkxL2txKzlNOW53RFEvZCt4cmVkam9B?=
 =?utf-8?B?VHd3T3o2MDBkMGQ3Qm9EWVZXWVVmU0FqM0VFTlIyRnVqRU5ySzRFL0Y0U3pY?=
 =?utf-8?B?MUxwTGNUQzllK2Rsamc0cDk4TDV6TTQ4R2gySVRnSlBTMTIrYWxyN2sra3FH?=
 =?utf-8?Q?obHU9SYPQV5bOlAfTB9Yca0hQ?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <79D3843812F66A479A071AB1505B1E6D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b9acc48-1347-4979-4d94-08dc734c83c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2024 12:59:24.5109
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Wzl0mIZM/1e+7lpkHwiSvKEUznUFU2NtQsqjLnjDTyVPl4zV7gcwWb6Pwob3Z9skh2Jbn1nhmQ0xGKuirnzPRw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8246
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTA0LTI1IGF0IDE2OjM5IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBSZW5hbWUgdGhlIHZhcmlvdXMgZnVuY3Rpb25zIHRoYXQgZW5hYmxlIHZpcnR1YWxp
emF0aW9uIHRvIHByZXBhcmUgZm9yDQo+IHVwY29taW5nIGNoYW5nZXMsIGFuZCB0byBjbGVhbiB1
cCBhcnRpZmFjdHMgb2YgS1ZNJ3MgcHJldmlvdXMgYmVoYXZpb3IsDQo+IHdoaWNoIHJlcXVpcmVk
IG1hbnVhbGx5IGp1Z2dsaW5nIGxvY2tzIGFyb3VuZCBrdm1fdXNhZ2VfY291bnQuDQo+IA0KPiBE
cm9wIHRoZSAibm9sb2NrIiBxdWFsaWZpZXIgZnJvbSBwZXItQ1BVIGZ1bmN0aW9ucyBub3cgdGhh
dCB0aGVyZSBhcmUgbm8NCj4gIm5vbG9jayIgaW1wbGVtZW50YXRpb25zIG9mIHRoZSAiYWxsIiB2
YXJpYW50cywgaS5lLiBub3cgdGhhdCBjYWxsaW5nIGENCj4gbm9uLW5vbG9jayBmdW5jdGlvbiBm
cm9tIGEgbm9sb2NrIGZ1bmN0aW9uIGlzbid0IGNvbmZ1c2luZyAodW5saWtlIHRoaXMNCj4gc2Vu
dGVuY2UpLg0KPiANCj4gRHJvcCAiYWxsIiBmcm9tIHRoZSBvdXRlciBoZWxwZXJzIGFzIHRoZXkg
bm8gbG9uZ2VyIG1hbnVhbGx5IGl0ZXJhdGUNCj4gb3ZlciBhbGwgQ1BVcywgYW5kIGJlY2F1c2Ug
aXQgbWlnaHQgbm90IGJlIG9idmlvdXMgd2hhdCAiYWxsIiByZWZlcnMgdG8uDQo+IEluc3RlYWQs
IHVzZSBkb3VibGUtdW5kZXJzY29yZXMgdG8gY29tbXVuaWNhdGUgdGhhdCB0aGUgcGVyLUNQVSBm
dW5jdGlvbnMNCj4gYXJlIGhlbHBlcnMgdG8gdGhlIG91dGVyIEFQSXMuDQo+IA0KDQpJIGtpbmRh
IHByZWZlcg0KDQoJY3B1X2VuYWJsZV92aXJ0dWFsaXphdGlvbigpOw0KDQppbnN0ZWFkIG9mDQoN
CglfX2t2bV9lbmFibGVfdmlydHVhbGl6YXRpb24oKTsNCg0KQnV0IG9idmlvdXNseSBub3QgYSBz
dHJvbmcgb3BpbmlvbiA6LSkNCg==

