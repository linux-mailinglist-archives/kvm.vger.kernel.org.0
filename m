Return-Path: <kvm+bounces-56020-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ACF94B391D2
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 04:45:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7073017D80A
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 02:45:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47685267B01;
	Thu, 28 Aug 2025 02:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BwUqNoZP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 579C430CDB5;
	Thu, 28 Aug 2025 02:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756349140; cv=fail; b=Cv6CN86edb54xLbvqPaEQlpz6WuCojU2pXDmJRtEeKMgAOkDs/m0Qfrs6HSw69Oa2jGl7+Sf55kvRDP98HCBYvG07Nh2P98FV2XNucXEVgJJ15dkRLvErYjmFPITPysJg7ZjkR9o5hTASLCbHod/TVHmdjCRZ/dlLNaG2ef2DdA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756349140; c=relaxed/simple;
	bh=ifBUjMPlthVkMKpxg4mO+OixccY6lPYOJ1YXs21KPO4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YCkNvTDg5zzMaZgajZXoMJcMO+7WKcg8YQTlkcKrODo6jJiPD1n5Vf8ZTPcnpu0wytnQ2f3NA6DplHpmS9jjZ+iHchyamxynpwcl39jlQMR00FmqlWw+BgAkBVVaKqAxHKAeviraKdqYpCA7cwY+V5sv4ZS0xu8dSN/97lilu/4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BwUqNoZP; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756349138; x=1787885138;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ifBUjMPlthVkMKpxg4mO+OixccY6lPYOJ1YXs21KPO4=;
  b=BwUqNoZPSEcED0EoDwCi7P1Vx+FOGor9YUTV6hv3eEJ1HE7F935c7HsC
   s1+X+d7t4pSlI7tbt/cVD+DFfaNk3ysjRJR47+uxucPTRJxRI+Gbe3Zgk
   0xFWpxP/WTFrZJ1JcPsbl2Gw9csmR2tl0z+OfHLEbu6NDQIVuPXjxIuz7
   qmGheCRHpldYwz5pWmCz+94XmaTlnCQdvpTTFwkq6NUdUpIF2DvvOytce
   ir0lBd8sb1cBVJmXJVKobZN5SRvW5LNo8bf1uer7rPcnHI0qCIhGWpkxJ
   hlzZyzQTvRDMcjCcw1fuHLBQZpm3PpcprmlzmEopoK8vbJ2cye0tqQ4ts
   w==;
X-CSE-ConnectionGUID: KGYk9emFTnayW8Uuww9jgg==
X-CSE-MsgGUID: HnRZlMLSQMiGkWWKbucXPA==
X-IronPort-AV: E=McAfee;i="6800,10657,11535"; a="46184734"
X-IronPort-AV: E=Sophos;i="6.18,217,1751266800"; 
   d="scan'208";a="46184734"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 19:45:37 -0700
X-CSE-ConnectionGUID: /4ScNcRITKSqPIE2vPc/cg==
X-CSE-MsgGUID: V0Q8YWbHTeaLnerPbiCdZQ==
X-ExtLoop1: 1
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 19:45:38 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 27 Aug 2025 19:45:37 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 27 Aug 2025 19:45:37 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.78)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 27 Aug 2025 19:45:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CTZ+wceZwCob63B7NwVrN0v/0qsjg8dBIEQqlQAQuBgeUD30Qc5vm50vPzrvuA5zNSGN0FhfeVxJfk49dFGDOx8CrEgpPqDX9/cAAwV9mDWfE5oVGR7uN9M+okv2QCo3IeQdA6vjF4yHw/UUuXBSYfY1td4Zg59XrFFOtmPiR715Tv5HP0WNufzQ9m4FPJ7mQgeidbkMWGCe9D1g03F5qIXA7uRVx1h13aHw32JRNSxq/+9nbB47hYXM+B90IIdSaov7BQA4hXVCM7u31wXeog12cHnRVSLHBxVenzFPepbVJZaPHQxxRQ3QrHdRTtP529y8ArMuUjP0KaNtW+DRNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ifBUjMPlthVkMKpxg4mO+OixccY6lPYOJ1YXs21KPO4=;
 b=mcTp+wjrd18jGDMQb8KNrGwB5EP/ykg52Qh8qAfIOCbtM0vbtZouJYuIr+LgbYE77kV0XkNhERsE/B4c7nYtNQR8/DCoeNSmEkL+WjRJYE4NhaG1Ub6GQnW+7BPhccXTsucJ9vQlqVLWK92T0VnWC6Dptx8QGHrtkGQzoFYgRmHaPGr/jxgsCBiMEWk6OnaWWoatEK9+ELFwmkHCCYdRyb0Db4b89z7BEgo5pJIJK9r40BLh+ZZ9YkSvxP4MuMbAVYG8ma+pFZSqnBhc+MResyK4ihrJZSPQyM318ZzWHy3bX3NiGYLm5ypgyGCkjEbZITiD88KHhtl/4YE/d0kddA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by DM3PR11MB8757.namprd11.prod.outlook.com (2603:10b6:8:1af::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Thu, 28 Aug
 2025 02:45:18 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%4]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 02:45:18 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Annapurve, Vishal" <vannapurve@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"Weiny, Ira" <ira.weiny@intel.com>
Subject: Re: [RFC PATCH 05/12] KVM: TDX: Drop superfluous page pinning in
 S-EPT management
Thread-Topic: [RFC PATCH 05/12] KVM: TDX: Drop superfluous page pinning in
 S-EPT management
Thread-Index: AQHcFuaKhUXMa+FhXE2uQ+qsC925e7R3XcOA
Date: Thu, 28 Aug 2025 02:45:18 +0000
Message-ID: <7f01e35bab5334782e392b4ea3ecf0349a452797.camel@intel.com>
References: <20250827000522.4022426-1-seanjc@google.com>
	 <20250827000522.4022426-6-seanjc@google.com>
In-Reply-To: <20250827000522.4022426-6-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|DM3PR11MB8757:EE_
x-ms-office365-filtering-correlation-id: 83f9b938-ae3c-40de-2fc6-08dde5dceca4
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?ay9OR0l6UHNGelUxVlFIYzJrTEdFSEhVMldGQVZSTW8xcUdaMnFFV2JGN1Nn?=
 =?utf-8?B?T3A0c212SnUyVjNUUHc1OHl4cVFxMHVpYlRUVENxYUlFcitQRUVNL01EU0JC?=
 =?utf-8?B?ZW02SHhEK1p3YWlGRHdleEVhTzZuYnN1bWFNS0NZZ21IS3hiajlJeWZXN0xG?=
 =?utf-8?B?QytrRjZZUlNQazk0N1FMTS9oVWpERW1oSlBvVkRZWXZyQ21PaUV3UDdmTTdH?=
 =?utf-8?B?ZXQ2TElncDlqRjhRSklrTEpaeVRNOVRhTGJlcmxlaGNvY1dJOWpYR1VIY29W?=
 =?utf-8?B?KzNLbWNONFhPSmkxUkJkMnZTS0NtZzJuYVNUeDlvcWFCNnB2b0RpYUpOMTg0?=
 =?utf-8?B?WVUyRTdxU1JnbERTaFpiMTF2YzU3L1NFY2NrS2hqVmN6dDNTbUhLSWNQUUNS?=
 =?utf-8?B?SjFObWFUWmdvWTZqQkgxMmVRc1FTWWhta2FsQ25HRy8zZ2RoaU5EelVhRFRm?=
 =?utf-8?B?elJmMFRUR3VGZFArOEE3UTdmcmEvWmhWcktpZDBCVjlHbnc0ek1QV2ErSWNl?=
 =?utf-8?B?VndmUGNlcktOTlRrdGFCZ2FtNE8xWGFrVXcxT2hVNjdFcER5KzB0WGNlcXdK?=
 =?utf-8?B?YkkzTDZjb2NENkhEVy8rc0gya21Jek4vb0VsSHRhY1BLQ2J0MW5JY3lzcGNh?=
 =?utf-8?B?KzlzRGVjdzlmWDNaYmFvS283MHBnY0VsWHBrOXdTTlpaZHNGNzRRZ1A4dS9G?=
 =?utf-8?B?S1JNdmFadEFlZjBqdmpqV3pJenRvSVdiMUlvdVIxaVk2d1drZ211ek9obmZt?=
 =?utf-8?B?MXZRM01jMHRMenBJLzI0RzNIdWlGOUpQM3R6aEdjOU1QUTRGMjBFOTdYUkFm?=
 =?utf-8?B?WUlqU1pPMTJpb2ZhaXRoOHVEbW9WMlZ0ckRhc1ZzSkxhTzdERkZQSGtzQVJp?=
 =?utf-8?B?WDBFdUJNWTNVSHRqVm5JVW5nR2lKOGpaTkJ0SWUxZjI4RDdKZG5TSEZXMHAy?=
 =?utf-8?B?OStiQm9wc3gxcmlsc3RrQnJ4N2d4TUFMWTZrZ3hYR2h5dWUwVkhHS2wvTENS?=
 =?utf-8?B?aXBrREwrckhYUWY1Z09TWmhZaVhNMnZsWXR0MjNRTXBWdTdwL3RCUWV6NjZt?=
 =?utf-8?B?NVlWcmlScU9CdlFSNHkwNTgrM0QxSFFsL1N3OXVNUlBDeW5RY1JaSmZHOEJB?=
 =?utf-8?B?Ukl0STF1SGYyZFlrQk5QdFFvbzcvQUdsNXN1SnpnU3NGZzEwc1ZLOEtyTlI1?=
 =?utf-8?B?T29CQ3lpU3JISlNScUtYNitHTFZNV3NkTEVJNWgrWUJadml2NHFKUjhGSkE2?=
 =?utf-8?B?NVdFaDY4bE1Bcm5ZdEZUR0plbUkwdHB3cWhXSkRVbEVmZFVSSXhCbko4a1pl?=
 =?utf-8?B?ZjV6Qzh0MUVja1hKbGJscyt5S3FBYmQ0cFYyaEFEYy9jd1BXYU16U3BpUTFs?=
 =?utf-8?B?V2szQ1p3U1QrMHlIbWNOMHhjRzNQZlR3cXp1SVp1dDYwdmdqdnFwYkF6WUpM?=
 =?utf-8?B?Z08wUmdrbTFGaUxHditIK3FvZHErcTFqRnN4SXFTNllGSDQ3QVZrUXFKeTV0?=
 =?utf-8?B?Ujk0YXdoa2t1N2YwQVVYaS9LSkpyck94UXRZakJWazcxNGxaMDI5WDBqUmJv?=
 =?utf-8?B?SUJFaXo3OXBqbGV1Y1hESjhqRXRsK21XOVNmWnBETkJtcmRDSDJIS2FFNTVj?=
 =?utf-8?B?YWxoL2dVQzkzTU9UT2JFL2J0VjRvaTNORFRVRlNHRVN3NmNxcFlOWTdtYlJp?=
 =?utf-8?B?U2YvOG1QS1ZvbWY2SDBxK2cvWGZDKytpWGd0TzJINFAvTFN5a1R0TmdGZXd2?=
 =?utf-8?B?em5kUzQrNEFLRWRMWVVyWlA5SEg2YXQzTUxtbFpSQnJMNEY5U3h5OW96My9V?=
 =?utf-8?B?VEd2V1VZK2xpQ09pa1QzSkxPT3lkdnN6MCtIbHRuVEsrVGZrdUdxYmVIbm01?=
 =?utf-8?B?ckYwaW16S1Z0Y1gxeWFnUTdJc2JPdnNQV0lMeVdlaWRoSkhPUGRTMzA5dHkx?=
 =?utf-8?B?YjBnbFBHNlJMeFdqZWYwT2JsdzBkblZzVk9oSFo0Z2txbHVkRmZRTHdTN1dk?=
 =?utf-8?B?My9nYUxoN2FnPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MnY4bEE4VkFiSjE2ZzFYRHVTd01WSFRZUit1Rm15SEgvS25JVTZjdnZPeUdx?=
 =?utf-8?B?WHRIbWpWWlBrUEE1WlZUMTk3bVZpcWJTd3Y2TWhrRVlEWHVrSkJYdkhqK0pr?=
 =?utf-8?B?UVpIVnBJZmFEYUdQdm5HM214OGVBUzR1eHR0c2hJMXdWcVlCUllrekE4ZSs2?=
 =?utf-8?B?SXp3THJCSGVmYkxZTWJqWHlvYS9Sa3B6NGsrNE4yOS8zV1FUd3pubVNENEVJ?=
 =?utf-8?B?dmpmRmQzdHl3RFhXSFMwZjI0NGlHanBJeHFZS01EMlRub0IzaXFzUkc3SVZm?=
 =?utf-8?B?VGhkdTE2aFpjNUtOMVlDWURwVkdqOWNXeVRyU0xzUkE1Nnd3eDdHVlVRZTFy?=
 =?utf-8?B?N1ppZFlpNndkeUQ1cWNIVVFtWUZwOUtiZjlSU0JwZW52eTRTblN2bkNuWDg3?=
 =?utf-8?B?WDFNMnFERklwb29GRS9jbjZ5Vmpnc2Q2ZzRET3NTTDU5ZEE2QWplUEZWdHdq?=
 =?utf-8?B?bUFSRGZHcWV0czlOU21aUDJTUGhWK1FaaFBIZGorZlE3cGRicm1BL1U2bXc4?=
 =?utf-8?B?MytvQXBZMjRZTktyZUQwbUNrSzVFcnU1eEpFMnZhT0lHbHdBeWx2TEptZmQx?=
 =?utf-8?B?ZWpacUZxSWNPb1FRQUZXYnNPMDBhVG9vM0hraTJFendRQXVqM3hLU2duQ1J6?=
 =?utf-8?B?ZlpEUk9saFBzZXZ5Z1JxTm1wTmJ0NEFMUEhpR29MdXdSY01FMW5qVFk0UzNZ?=
 =?utf-8?B?ZmhORFVWY2pFcUlwSHpuaFdWR1hCTnkzMFhyeldsSUE5ZmRLRCtxL2F5VDhQ?=
 =?utf-8?B?RDN2VmFtSGtZRWUwZHRxTG52Q01FdkljdGR0MEorS1NGNk9oQVZvd1V0cExC?=
 =?utf-8?B?K3RJMEhTcHlNdVdwSDJRTEZQalhwTGNLcXArTXBtM2ltbnBtWmkyUklweDZU?=
 =?utf-8?B?Mmljd01XekpKNHpZMzRVRHAzNHhvVHBUS2pGL3R3K2ZkWkVvUzI0NTN2Z3Yr?=
 =?utf-8?B?eE90T2M5enpLdTYvalB5bjAvYlptZWNReFdWbE9yeTh4bWlVTERibGRCOGt0?=
 =?utf-8?B?MVg5SXhycHNDaHZ3elpZMUw0NG5vTkJRbDNSRGRBOEFFVlRJN3FEVld0V3VV?=
 =?utf-8?B?OHNnMTdvVHlHeXBTZk1jUjNkeENDdllPNlJicXBNTVdvL2tIU0Z1SytIVGts?=
 =?utf-8?B?UXZsT09oZlFNQnZFYmo5eWtzWGora2ZGbTZRQStjWlJWUHZzZWhMZnA4RXYv?=
 =?utf-8?B?c0VhVElJbTlZaFlsMktWMDUrWllvdER6YXFYdmFrOXpzTWRXRFlhYUNOMHBU?=
 =?utf-8?B?S3NNTXp6MnB0Y3RlWXRza0haZU1zT3BNL1JSQVJ2MTVjK0lsWkJWQnV4Zi9X?=
 =?utf-8?B?MHN2OHpnREFUZ1hrTWdIVWZldVhNZ2Rzc3JLWDhrb0JBTTdETnAvVlIxNEhx?=
 =?utf-8?B?UXFoT21oY1g5NGtNKzZYZE55czNOdDZEZytUUCsyak1SRFA4TFVmVVh4M3lr?=
 =?utf-8?B?VGpJL3JFM2Z5eGdwSnVSS3pTNXdNVkZmR3MxQUJyeFpkUG43K1E5T1k5QkZn?=
 =?utf-8?B?OEpzYk5YV28vd3FkcWJOUFNCeDhTcTRKb0tKbUxpZHlraTRGblJMRnczQk5Y?=
 =?utf-8?B?QUpNRjh5OW5ueTE0QzUwRTlCTEhEUEJNc0N0NXR6cWY4T1c0VURkMzd3NzJh?=
 =?utf-8?B?K2w0enlUNWg5dWgxVDF4aGhESXJiUnY0Zk4ybHdUeDQ0endpYzNJSUZ1VGlB?=
 =?utf-8?B?NEU4aVR5SDdEK25GVTVYZ25BVUVDbnNXSmozenA1eEx6b1U0bC9ydVYrR2F0?=
 =?utf-8?B?TWZUL3BCK04rNmJ5TGRncGVjMGQ4cGpORGgrdmVWbFRPYjc1YVloUC9xWWlr?=
 =?utf-8?B?N3VOVWYrQlZUZlh6b1RUNE52Q2t0cFF4Tzd3dGduVzE4ajFFMWNBRWZsQ3dL?=
 =?utf-8?B?QnhnZm9SbHFlY1NnclFRTW1paTZYUEVPUVZMNEdGWGt4TmZ1NUIxNmh4MkFN?=
 =?utf-8?B?MlI2TlZmOGNLUHJQUHFpWktiMVdzMkRqOXN6MUxYMm5tSis0WEtIZ1VUL3Na?=
 =?utf-8?B?dWlsN3FIbXRZcGNxVWdOajVVOEpIQVNNQnZtVEZQSkdSZFgreTQxS1BlcC9Y?=
 =?utf-8?B?a04wOWp6U0ZISGJpMk1oZDNqbVA3anJlbEorcnFCZ3I4RWpLVVlkL3d2NE1Z?=
 =?utf-8?Q?deK3TnIQhyniq0RPFaJdBz6ia?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D51BE9D19F9FE84D8A11A6E38529D7E2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83f9b938-ae3c-40de-2fc6-08dde5dceca4
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2025 02:45:18.1758
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: v1Rslcp4zIxG0U0FEnojAjfGnKGSL7GLW4jAutlPV1YpMSOCGF7qXW6GaWcOiIC/118ldHfBAmYxGxlbJnRpiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR11MB8757
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA4LTI2IGF0IDE3OjA1IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBEb24ndCBleHBsaWNpdGx5IHBpbiBwYWdlcyB3aGVuIG1hcHBpbmcgcGFnZXMgaW50
byB0aGUgUy1FUFQsIGd1ZXN0X21lbWZkDQo+IGRvZXNuJ3Qgc3VwcG9ydCBwYWdlIG1pZ3JhdGlv
biBpbiBhbnkgY2FwYWNpdHksIGkuZS4gdGhlcmUgYXJlIG5vIG1pZ3JhdGUNCj4gY2FsbGJhY2tz
IGJlY2F1c2UgZ3Vlc3RfbWVtZmQgcGFnZXMgKmNhbid0KiBiZSBtaWdyYXRlZC4gIFNlZSB0aGUg
V0FSTiBpbg0KPiBrdm1fZ21lbV9taWdyYXRlX2ZvbGlvKCkuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5
OiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbT4NCj4gDQoNClJldmlld2Vk
LWJ5OiBLYWkgSHVhbmcgPGthaS5odWFuZ0BpbnRlbC5jb20+DQo=

