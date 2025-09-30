Return-Path: <kvm+bounces-59084-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F930BABA1E
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 08:02:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4C3CD7A9441
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 06:00:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3997E2580E2;
	Tue, 30 Sep 2025 06:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U7eQq41x"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FB121F37A1
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 06:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759212146; cv=fail; b=alcnrKWOpEffx+6BckwGHjw8w26/IMRxQXstyGdiXfCmlRu4mJqRhbgFcP/j2V9UwVPgpdXRl5ip17VTqP/zBI9EddgSilVm6laVoeT4Kwueg0jtmF/qnZlNBsX47z3bbrlXAfEraPCIvxHpYgCeM1ktiOEbcE7S8Va+IjyfKOU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759212146; c=relaxed/simple;
	bh=jc1B+IYusD06O/aieeBSecGFdMpV2fg1l+xgKqy66/4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Bc6VGTGm9wSSXq2BpUCgHUO/n74djE6jYMVUoG1G8EwDSo4SazDvdKWRwAE8hRlLx4rh1cKnNifWO9iS0bGCS5wnc7ecNSQmZ9eRktpVNqghmHoYPqrUAZF+p/3Gb0MjvAE5tk42+f5ux5AUq9C6eBba0HbnTWWXRFXdm0kHngA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U7eQq41x; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759212144; x=1790748144;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=jc1B+IYusD06O/aieeBSecGFdMpV2fg1l+xgKqy66/4=;
  b=U7eQq41xfdC6rCvaOPmE4UzdU7szp/Aii5Nby27GjB9HrL+NV9wNdSA0
   rzq6DDuaVcWlx8rA7CkRv9vrOeaINyOlUuySd8P6ZuQtp+jOK/R00IDz2
   JXj/Z/IhHcG+NtSWgTJdXJMOSl9gIHAuPWU/YGrMqp+PIQNgkKYfOdTrl
   XfphctRpQvlOBPYxEeNmlIdvxdjk83apzB3yE7ScPpdq9DGcsVZ0Pmahp
   MXbkuok93BrQK6X6ZhuBO7uEd42ZM1m+0sDC/D5bDGJ7xKFUhKzIfavCa
   mwdXT1faw+ZXmyJ29MUckY6OKSQL03ZIQopbBqZBUxBk+wbRMDV4Epg1a
   Q==;
X-CSE-ConnectionGUID: FBlu7eCBRAusWGXQf1jUbA==
X-CSE-MsgGUID: s28XbR2xTzyiKrWfF1Sscw==
X-IronPort-AV: E=McAfee;i="6800,10657,11568"; a="61350285"
X-IronPort-AV: E=Sophos;i="6.18,303,1751266800"; 
   d="scan'208";a="61350285"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2025 23:02:24 -0700
X-CSE-ConnectionGUID: 8oKMCLyBSHircBNlFIBJnQ==
X-CSE-MsgGUID: 4qE+AyPQR9+ic+3eiPdC3w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,303,1751266800"; 
   d="scan'208";a="183615583"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2025 23:02:23 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 29 Sep 2025 23:02:22 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 29 Sep 2025 23:02:22 -0700
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.62) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 29 Sep 2025 23:02:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=je6VmRV8+S6GYdAToK/+se/XcnMI7JNax3WEwbsPE7+By/uCGOXNH628m2BcGv/H9hzglnLj+BBmUa5d+z+GeHQdjA6J4hHqDVclDrYnloFMMlYj1fl5PVarUs79fReoa8kIntRU3zL7iB5NTuCBCcKvf3AX9oIixL2IqWUi67f3B5IOo6ljKYz8GrlDbh9RaDMOodCDe/YD9ashb8hC1opW6UQyXmr9EZqsFvz22+v6n2kUyLuKAH07dQhcAh8i8Pht8bE2L6M5hASS2d9RXsWMYPjsjMbfWDWuWbSBhywfGuCOgQpTW9J/GdBpHoX/zjNrOuyqTnfrNL9+GtqxOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jc1B+IYusD06O/aieeBSecGFdMpV2fg1l+xgKqy66/4=;
 b=Xz+ck4BP8VUar6CGpVbNo4w6OygUqqPsugD/mf5u89WI5GZlKSKvPh3rSif55+oysZYfxlwY0tlRjIZF2aFjI4zAK+6o1FBwDwTZ7TUR9Cr0yeCdl6pZ+6NJewe+3MOiDJGEe/SQFvmcjGdyLUYMHnF2BvmThPGay7ZgQvnDxuGm4Z2y7nXRb6SBiAQckwaZjXIx3z4mxT4gCqlMtqDbNl/7PTQwD8yjqUXR3d0wLZbRSXh1dMtpL4viteCpGnMmQoXZjlOb50TqXaoT7NV+ayABGVeJohHeYTMHCinB8Hc8hWnMxYZRNu71wD2nrQ8iehizPfvS2jRqbiE2joi01A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by CO1PR11MB4803.namprd11.prod.outlook.com (2603:10b6:303:95::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.16; Tue, 30 Sep
 2025 06:02:18 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9160.015; Tue, 30 Sep 2025
 06:02:17 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "nikunj@amd.com" <nikunj@amd.com>
CC: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "joao.m.martins@oracle.com"
	<joao.m.martins@oracle.com>, "santosh.shukla@amd.com"
	<santosh.shukla@amd.com>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH v3 5/5] KVM: SVM: Add Page modification logging support
Thread-Topic: [PATCH v3 5/5] KVM: SVM: Add Page modification logging support
Thread-Index: AQHcLgTMyh3xhUUVqkqcHNC9xdPIQrSpaEaAgAHW3oCAAARbAA==
Date: Tue, 30 Sep 2025 06:02:17 +0000
Message-ID: <c6f25bdde6200277ce744c6eabb24b40f3311567.camel@intel.com>
References: <20250925101052.1868431-1-nikunj@amd.com>
	 <20250925101052.1868431-6-nikunj@amd.com>
	 <4321f668a69d02e93ad40db9304ef24b66a0f19d.camel@intel.com>
	 <09412800-6643-4ed4-b7d6-3f767fcc2407@amd.com>
In-Reply-To: <09412800-6643-4ed4-b7d6-3f767fcc2407@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|CO1PR11MB4803:EE_
x-ms-office365-filtering-correlation-id: 4a06da8c-5f38-4005-79a7-08ddffe6e94e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?bitYR3dnR0FKaUdtMjRqSm9jRHRpTmpheXl5Qk9OTWU0OFpQbWM3SG1helhv?=
 =?utf-8?B?TkpjWURnTEM5b1hISHl2clRHZXhNRGQySXJMcVJBdG5vdm9YZ0g2bldaOUUr?=
 =?utf-8?B?VmhyRGx2cm9UWU1PdE82RWRUdjlUZEdKOVY4NTVtUGsrSE9LNWUrWDBWOXFD?=
 =?utf-8?B?bnp0NDhDaTF1eU9UbC9wUWROQlZVdTIzY2hDakM4UTlWRXVxYjJBM3V3Qm9R?=
 =?utf-8?B?Wm04UU9Ram9FMys3R0VVMVpDTG4rM0h6dzFjZ0F1cXhEYng4QTFlckxjLzEx?=
 =?utf-8?B?d29yc2l2amtHWHZJRVJKYlFvdW9aNHhHTkFWcVdYV01Tbm55dlorTm9IQ3o2?=
 =?utf-8?B?YlpPT0JGdzhxN3BsdUxhOEM5cE1JWUlVNEV5U0Z6dTZ2ZmtTbHJtcWdVWi94?=
 =?utf-8?B?MjJXajZZRGl5dXJyaUhRSUlQSkNRdk5sc1BGTTJ5SWRmd0pJVVRGM3pEOHds?=
 =?utf-8?B?M0I2WDE1NkNQZXZKZEpTTHNpRCtJNkxyZDJZRTJLMlFldU1BZS9DNDZtODFB?=
 =?utf-8?B?ZlBHZ1VHaDhUalJ3dzNCdjQyZTMveVE0UXZvbnJBeTVmR2hwOWlCWmFkTjQv?=
 =?utf-8?B?Y3BlM1QyUWNNWDJkaDE4cmlSblRKSTRhUnE2bDhiNFJ1bkpzT2s0NXI3MEJp?=
 =?utf-8?B?eERVMUJHS1YySEhOTndvK2p4MzllaHVGWDd1cmhmRW5kcHYveFpyREJsOXFi?=
 =?utf-8?B?V2NmeFpLUE1PUC9XV25zVjFHanlocFlFTUZSU29EOXllaTN0bXA0bWRMVVJn?=
 =?utf-8?B?anlOSVVPWFZBelZSQ0hIMDVmeGZzenlBdFR3blhrT3ZsbktuRkh0SkZmN3lw?=
 =?utf-8?B?RWhoMHZtd1d3V3gzWm9lOWxIR3pPZDlFV252bFBURk04N2RPdFhIaFVGU1d5?=
 =?utf-8?B?ZWpqZ3U1UUpLWUU0OHdBRHZBclB1MzZuNUJublVENzlhUHdtTXNlcml4Wmdo?=
 =?utf-8?B?VmNYM3I1dUMrMVRIaXpVb0RoT0JWeFJoUk5qQjRXZFp5cFhvQURpWmkrYklX?=
 =?utf-8?B?ZXUybGRyV1ZFV0dZcnZjVVdZaWwyYlQ5VjN4dkRpTTYxVmIzSCtkRUNFN0t1?=
 =?utf-8?B?cVgvNVlpbDRzaldKVHJvcE9ZTUtvdnVqQmkrWVNuNHJJUGVDUHlWWTRkVldh?=
 =?utf-8?B?a2tCYzgwM1BvdGxJNEN0aGhvb2ZLQ25UWjc4WEhqNVRJVlJsb1ZpTUZwU0N5?=
 =?utf-8?B?aWRNV3BkQjU5VkhtVzRsWWZJR3Jkak1TZ0Uxa3JJbUluZGp5QzJyTm5jWThE?=
 =?utf-8?B?TEhtQ1l4OGtjcXRMMDNweHFOMnNxb20vYlQ3NVhTWUh0OVFqNmczRC9qczRl?=
 =?utf-8?B?SExGTzJPaGdiMVo1UzR1ZDdTRGNEVkxwY2ExN21qTTVOQVhBR2QxWDRzTUd1?=
 =?utf-8?B?K29GQ2ZUR2RvOHdKb0oxUEhnM0RheU9VVXRZSG1tRGxpT0hKaS9URGJreS9x?=
 =?utf-8?B?eDVhbjRZeWdNaTAwR0pOSG5LY09ZamhIK2wzeGVCUGtGdUpCSTJ0cUxPMnFs?=
 =?utf-8?B?U2x1b050RzBPRWVnZHFwVThDaFkzM0dyV2pwKzBWOVVnY2Y0ZGdHSTYyT2ls?=
 =?utf-8?B?R0tobDRYK09oTGJFc1VuWnlpcHhwU0J0T2dhMnRWQisrL0MyMjVTVVE1OGgv?=
 =?utf-8?B?YXNvbnByOFd6ZHd4TTUwY3p5YzlJR3JUR2VGSnNvN29PcjZweFFtYWxVeUcy?=
 =?utf-8?B?am9GaktUOFcyZlUyWS8wZmQ4T25BT0JWL0JaVFBNeUJDMDFkZXZUNTNWYmhS?=
 =?utf-8?B?OUwvc29YMGN0ZmNqaGF6bXR4NUFWVS9aWkFaQXhyTEFzZkNTZ1htQkZzeHVS?=
 =?utf-8?B?aWZBay9SbjJHblJDZ2NPVlJKV25SZlo3VnBWdGtBZWJTYm5DR1lOSnBDb3BX?=
 =?utf-8?B?Yzh3ME4vVDM2Z1RLWWxkRDlFT1F2Q3d5VW9YQzl4c3d5Y3JVOXpWb0hFMVhF?=
 =?utf-8?B?VmRUMlhVODZhK0hsK3JRZEk4Kzg2Q21rdzNuNllTZlA1dGloUXhacTdPVldy?=
 =?utf-8?B?VHI2RXREY3Ixdm9IY05oSjU0NUJDYXQ3SmJFcDVZL2xhTDlQMkx3RUNTTVpo?=
 =?utf-8?Q?ZXX7fo?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZHMvRzErL2lFZ29LTi9kRmVCekF4b0lyOFNJakdBdmlyK0JkQ2p2b09iOXhp?=
 =?utf-8?B?dGVmOUVGQm9TQzZJOGlsTEJHSnphYTUyY3BxOURmS0dYdHlZM1kyZVhGcTVX?=
 =?utf-8?B?NW03OFBUd0hBdkNYaCtpM2tVWWdUUXJRNzIydS8wSkt2akg5aTJNdy9rQmlj?=
 =?utf-8?B?aDZQams5TnYydktjdmxCTFN3VlNuOHRLck5KcG93VUdZb3BGUGxZUEQxRGxS?=
 =?utf-8?B?NlYzMlluR01SdHFsTzNiMkVGcG5wdm52aEFiMTB1UnNxYTgvVzF6bGgvMUE1?=
 =?utf-8?B?UEtuUFlFUExvZHNtVGl5MEE5S2JGRXA0N1NIb1FJTzZvVjIyZmhObjZWbzcy?=
 =?utf-8?B?WEtlU1JyMERZK0wxUDNZL01PUEZuTTcramNtSjYxRndSNFdNSU9LNGdBQ3BR?=
 =?utf-8?B?ZWRvYmV1T25qNU9aZ3NmRTY4bFYvOVFYSWF6U3dEdkh3aGMvTHZvTEJ4MnRm?=
 =?utf-8?B?T3lRMjhWbEw2UHZDeVZZdi91S1FmSkVoVy9FazFTK2Z3L2t4SkJ1b29rZ2ZK?=
 =?utf-8?B?SDN6djhJdEs2M1pNUk1vcThPWUZXdnovRCt5SVhKcXdZNjFYNmx0N0ZXbDJa?=
 =?utf-8?B?UnpGeXNyQjlLby9iVFVIdktEaS9hSEpzOGF0allqT0RFa2NLQVc0am41WURX?=
 =?utf-8?B?NWtFTDZKZzRQSkhjOUN2K3E3MWR3U1RWeVZmcXgwODlhUTBjalpoVXNPSUVX?=
 =?utf-8?B?N01Qa1dBajVETlE4b3Q0c0JwYndoUjExVkJNbTljaTJqbnJOZ1VjazJoaHBP?=
 =?utf-8?B?S2N6MlFGRUhNSW5uRlFzNkRVSEVWR2FjVXZvMTZnOXpBS2ZtSGxmbTlqUitr?=
 =?utf-8?B?cVNSUmkvb0JvYWVRWFR1KzZFWjY1a052bmgybFNERHNxMS9jMkhMR0ZpbE5B?=
 =?utf-8?B?aVp6QWZ4MGhyR1pMVWViYTEvR3NtQVJoUS9DNUlhdWMwcUppWFZSUE1aOGFC?=
 =?utf-8?B?NTFSRDIzY3MzYnk0S2VwQXJCc28vMmM5UUdWRXZJVnh0M0M5b1k1cE83aGJv?=
 =?utf-8?B?UVJLNVVCcTZicjNFZmh0cHFuZ0dJbnRLazRGZjNqLy9oOWd2ZDZxWXhDdnFi?=
 =?utf-8?B?bUFKSUZBTSt1RFhjdXZ5R3Q5MWxnWmhNUHRTb3crUEROWG12K0ZORlNRNXdB?=
 =?utf-8?B?ZUhLVFd5cEhHa0doZ0gxVGhFV092OGVtMkNSekZ5Q3Q5dFQ4YVpvVS9ib2hm?=
 =?utf-8?B?ZW5tV3pGV3VYR05rZnBrSHQzQTVtZ0hCekJBbCtoYlN4aEFtakNiSWVsWE92?=
 =?utf-8?B?OTB3ZEhaR3NxZEZmWTlrOHhMcmZ6d0hkaTNLeEVvNnVXQlRDTENXS2R2L3BI?=
 =?utf-8?B?M2h1clpydzFTYVpQQjhBdFlzU3g1dUl2NEpzQ2QrSnNrV0N1b2xrZm1IM0xS?=
 =?utf-8?B?bmUwRWs1ZVE5Q2pzV280Qi9ic1MvSk00NGhWZ01ST01jRkk0c2Yzblo4aUhP?=
 =?utf-8?B?ZVVtQjY4YjdlaDFVNXNCMnczMXhhV2lSS3Ywa01JM1crNSs3ZDFLUkxBempo?=
 =?utf-8?B?VEMxV1Nhcm1pUFA1bkZkQ0Z2c2dYRGR4dzU0RzZUd29CVmtEMkZDRFJVWmJn?=
 =?utf-8?B?QmVnQzFFTzR4NkVNb0ZpSzJNN2d2SkRHeW82Nmt6Q1hiV1E4LzRXdlZqRzRT?=
 =?utf-8?B?b3QyYVA3NG9BV0YxVXRsUHZzdWlDM3M2YnlzSVlLdy85Z0JudHZrdmNsMEJG?=
 =?utf-8?B?VGEvV2xtMTQzNW9RTk1RVUFoZm14bGRaTkZLWDFSVmhkRXRtdjBPSzVaVnJV?=
 =?utf-8?B?ano5U3FmS2tVcTlJRzg4aVpGODhVVkNsdWVKa3luOFM2ZjJTeGdmb3VyWlFl?=
 =?utf-8?B?cU94cEtvQ1EyNmhoV1R0UEc1ZVkyTjBKaFFOS1BmWmNUUWpzQzRYNVRJVXpQ?=
 =?utf-8?B?cTdwdkFsbTlKaXBYd2Z4cGhRV1MyWEhzMGgwOGZSWmNEWENmTFBZVmpSQW5o?=
 =?utf-8?B?d0ptVFBVOHU5RUtzZmYvd1c2cVhoRE9TRjlaeWVzV3lsUVJ4UXB3NlZTaXlV?=
 =?utf-8?B?SSsvOWNqaUtjMUV1SVZQak5sMm9hN2FJZjVJYjV5N3k3Yyt1QTlDWU9oUXNW?=
 =?utf-8?B?Q25rRkc0S0hybUE2S2hRdmc4UDkrRVYwSlpFNkNsekhCK1hMK3A5Uno1T1Ay?=
 =?utf-8?Q?ghVhCIMsE8nij7p1D9fatZ2Yt?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CB16F7E6CBA0ED43AAE49D6F05291209@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a06da8c-5f38-4005-79a7-08ddffe6e94e
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Sep 2025 06:02:17.7977
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: i7G0s9B0LXoPXEriBzO4Nvm1sU5e40mjH3hkFn7YxsXc4pqyIHJwDX/gr1DOXli1QF6ovrQUvjzY1LPA7s32/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4803
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA5LTMwIGF0IDExOjE2ICswNTMwLCBOaWt1bmogQS4gRGFkaGFuaWEgd3Jv
dGU6DQo+IA0KPiBPbiA5LzI5LzIwMjUgNzoxMSBBTSwgSHVhbmcsIEthaSB3cm90ZToNCj4gPiAN
Cj4gPiBUaGVyZSBhcmUgZHVwbGljYXRlZCBjb2RlIGJldHdlZW4gU1ZNIGFuZCBWTVggZm9yIHRo
ZSBhYm92ZSBjaHVua3MuICBUaGUNCj4gPiBsb2dpYyBvZiBtYXJraW5nICd1cGRhdGVfY3B1X2Rp
cnR5X2xvZ2dpbmcnIGFzIHBlbmRpbmcgd2hlbiB2Q1BVIGlzIGluIEwyDQo+ID4gbW9kZSBhbmQg
dGhlbiBhY3R1YWxseSB1cGRhdGluZyB0aGUgQ1BVIGRpcnR5IGxvZ2dpbmcgd2hlbiBleGlzdGlu
ZyBmcm9tDQo+ID4gTDIgdG8gTDEgY2FuIGJlIG1hZGUgY29tbW9uLCBhcyBib3RoIFNWTSBhbmQg
Vk1YIHNoYXJlIHRoZSBzYW1lIGxvZ2ljLg0KPiA+IA0KPiA+IEhvdyBhYm91dCBiZWxvdyBkaWZm
IFsqXT8gSXQgY291bGQgYmUgc3BsaXQgaW50byBtdWx0aXBsZSBwYXRjaGVzIChlLmcuLA0KPiA+
IG9uZSB0byBtb3ZlIHRoZSBjb2RlIGFyb3VuZCAndXBkYXRlX2NwdV9kaXJ0eV9sb2dnaW5nX3Bl
bmRpbmcnIGZyb20gVk1YIHRvDQo+ID4geDg2IGNvbW1vbiwgYW5kIHRoZSBvdGhlciBvbmUgdG8g
YXBwbHkgU1ZNIGNoYW5nZXMgb24gdG9wIG9mIHRoYXQpLg0KPiA+IA0KPiA+IEJ1aWxkIHRlc3Qg
b25seSAuLiBJIHBsYW4gdG8gaGF2ZSBhIHRlc3QgYXMgd2VsbCAobmVlZGluZyB0byBzZXR1cCB0
ZXN0aW5nDQo+ID4gZW52aXJvbm1lbnQpIGJ1dCBpdCB3b3VsZCBiZSBncmVhdCB0byBzZWUgd2hl
dGhlciBpdCB3b3JrcyBhdCBTVk0gc2lkZS4NCj4gPiANCj4gPiBbKl0gVGhlIGRpZmYgKGFsc28g
YXR0YWNoZWQpOg0KPiA+IA0KPiBIaSBLYWksDQo+IA0KPiBUaGFuayB5b3UgZm9yIHRoZSBwYXRj
aCB0byBtb3ZlIHRoZSBuZXN0ZWQgQ1BVIGRpcnR5IGxvZ2dpbmcgbG9naWMgdG8gY29tbW9uIGNv
ZGUuIEkgaGF2ZSBhIGNvdXBsZSBvZiBxdWVzdGlvbnM6DQo+IA0KPiAxKSBTaG91bGQgSSBpbmNs
dWRlIHRoaXMgcGF0Y2ggYXMgcGFydCBvZiBteSBQTUwgc2VyaWVzIGFuZCBwb3N0IGl0IHdpdGgg
djQsIG9yIHdvdWxkIHlvdSBwcmVmZXIgdG8gc3VibWl0IGl0IHNlcGFyYXRlbHk/DQoNClBsZWFz
ZSBpbmNsdWRlIGl0IGluIHlvdXIgdjQuICBJdCB3b3VsZCBiZSBlYXNpZXIgdG8gcmV2aWV3IHdp
dGggdGhlIHJlc3QNCm9mIHlvdXIgcGF0Y2hlcy4NCg0KPiANCj4gMikgU2luY2UgeW91IGF1dGhv
cmVkIHRoaXMgcGF0Y2gsIG1heSBJIGFkZCB5b3VyIEZyb20vU2lnbmVkLW9mZi1ieSBsaW5lIHdo
ZW4gaW5jbHVkaW5nIGl0IGluIHRoZSBzZXJpZXM/DQoNCkZlZWwgZnJlZSB0byB1c2UgdGhlIGRp
ZmYuICBJZiB5b3Ugd2FudCB0byBjcmVkaXQgbWUgeWVhaCBhbHNvIGZlZWwgZnJlZQ0KdG8gYWRk
IG15IEZyb20gKG9yIENvLWRldmVsb3BlZC1ieSkgYW5kIFNvQiAtLSB3aGF0ZXZlciB3YXkgc3Vp
dHMgeW91Lg0KDQo+IA0KPiBQbGVhc2UgbGV0IG1lIGtub3cgeW91ciBwcmVmZXJlbmNlLiBJJ20g
aGFwcHkgdG8gaW50ZWdyYXRlIGl0IGludG8gdGhlIHNlcmllcyBvciB3YWl0IGZvciB5b3UgdG8g
c3VibWl0IGl0IGluZGVwZW5kZW50bHkuDQoNClllYWggcGxlYXNlIGludGVncmF0ZSB0byB5b3Vy
IHNlcmllcy4gIFRoYW5rcyENCg==

