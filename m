Return-Path: <kvm+bounces-57159-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D351BB508D0
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 00:19:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 88A4D4441B2
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 22:19:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FFF72698A2;
	Tue,  9 Sep 2025 22:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hdJ3hso5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39DD1DDC3
	for <kvm@vger.kernel.org>; Tue,  9 Sep 2025 22:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757456354; cv=fail; b=Uv2WwC5UHc6yIqwg3c6IWlcNiMZq6SyLm6Xn0Qqzdqe2Arl6HSBQWrI8Nev0EdObB9WZ07emOeSXSSmWpLpxblCHo8OKVIPv2kyV/CAg7a8hf8AyA4GkZsL4rMr0v6FgJC9YaKjNiCTRVZBUe2fvZOURWUQHqfnjIWTyZI4rk6I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757456354; c=relaxed/simple;
	bh=p90Rn/cd6cPvj/FgkTEDkRpXso/mfHQqz9eoVb0UhjI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=oi+QUTetVYM8ynF0zoWdCuxLTb2iMlKbdvqTNzBXt4qESmip7kaTqLDb/a5Mi8OLGxto/gBoX3NNWnD+czSF6xdkzvtI0kpcnT9hGEG31+votzr7plHt+IVoHzljzSdctluNfLMeQ5xmSCrdkGvro/9voNzigbkMN8MxhJHrXs4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hdJ3hso5; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1757456353; x=1788992353;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=p90Rn/cd6cPvj/FgkTEDkRpXso/mfHQqz9eoVb0UhjI=;
  b=hdJ3hso55iDT3gLYvSE7Cw+bU+aYyV50i3QpeksfRA4UshBJx9I3QdHz
   WVpNxnEYe0wry/SZ2e8bvQXhj+o4zcvG/OZJKxH/LiXrzMCwrQxK4BXsB
   QmrVWvJW7fh3+QZUcjlSqUArhWR5M4ooUCAK48tEK0jdwsSkQigFayX8P
   LOrO5OfdGoTF1W8v2hSafcZXUPHLlTKr6ciOdmrwIGBh7gTgTtt41yJo8
   TopRrnq2fPgcG1YqBSIzd1YbY+gPBIA5TzV/kMqLQPjyQdxeRieqsxPxX
   30gHCAruPuuUv5ldcoVYp+uyWzX/RYQVUURWrWtHxqyLimlCn3ze6wL3/
   g==;
X-CSE-ConnectionGUID: loreUl4wRAuuvgb11HFPxw==
X-CSE-MsgGUID: puwUnMdEQJqCA2DfprkPbw==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="59680726"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="59680726"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 15:19:13 -0700
X-CSE-ConnectionGUID: oRPWO5C0Q6uC5KsPc219TA==
X-CSE-MsgGUID: if52kR00TZuSiWnZajHIAw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,252,1751266800"; 
   d="scan'208";a="173308333"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2025 15:19:13 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 9 Sep 2025 15:19:11 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 9 Sep 2025 15:19:11 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (40.107.101.82)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 9 Sep 2025 15:19:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FqS5RSD7hrevA/Xk3yxOh3hbU3GvXoVOsyDIMVx5oXPxGxV0ya6UbdvSJdBoX+/i3wChVNFj3TBfNogsGaEC07fQONy0QHl9RV5WDOEX4ZC62pRJnkDMFOae+HV2mrrUC05tjkmtsmmY2ZQRIVrdTuk91kjC9J5qPkeijCr6y1oDgKQRjDHMBvXE7qxg+h2XTpUK1EwpfFxxRHVNNRBTmOne7EBzOIxwSsN+jHtjp6DOWx15R55n+wqVJm94B9HuSr21Tb8pH5SU0YUKNr/Lgt5IddJCMlJZKtbrJ4H4KYahMKvR+JzvFMZBQ82YaogB11qBWHXYzn2Tz3OBGzXeDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p90Rn/cd6cPvj/FgkTEDkRpXso/mfHQqz9eoVb0UhjI=;
 b=cVQq1smzjLrriAqe07woaFcyaUR8AFzgNS6rbvuzkP1ZyiaQ639dfy39ziUu0XB4n1ZQrQr/6hKTm7jFEf4OIufjUWe71MwMx97LZikacpLt7NYMPHk9A73b0AFxO1RpP2qeM0Ir720tHZKHYkNGePFwiUHypr3BIQIE0WrTcbzcj/CF7Ayu53vAy8u/5bmeDfdwHgzMYvbK48BcpTj5Q0CX7j2R/EykgEY0kgO8VdITHOIDXKF55ALf5skCOUxqSw6weo0o7uZUdCVXJMu/bVAsGtkLme05xRBOk011wtK803Wh4LHpM42FhH6Q6aqoQJpsNSC7Y4xQsBilBDu6AA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by SA1PR11MB7061.namprd11.prod.outlook.com (2603:10b6:806:2ba::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 9 Sep
 2025 22:19:09 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%4]) with mapi id 15.20.9094.021; Tue, 9 Sep 2025
 22:19:09 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>
CC: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"dan.carpenter@linaro.org" <dan.carpenter@linaro.org>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH 1/1] KVM: TDX: Fix uninitialized error code for
 __tdx_bringup()
Thread-Topic: [PATCH 1/1] KVM: TDX: Fix uninitialized error code for
 __tdx_bringup()
Thread-Index: AQHcIXN+q1OgUjX1GUOBud0m71VFmLSKrYqAgAAC64CAACyIAIAAj52A
Date: Tue, 9 Sep 2025 22:19:09 +0000
Message-ID: <a881591de9e739e04c55477bf832e60a2dcf171f.camel@intel.com>
References: <20250909101638.170135-1-tony.lindgren@linux.intel.com>
	 <20e22c04918a34268c6aa93efc2950b2c9d3b377.camel@intel.com>
	 <aMAKBUAD-fdJBhOD@tlindgre-MOBL1> <aMAvYIN7-6iqQNBt@google.com>
In-Reply-To: <aMAvYIN7-6iqQNBt@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|SA1PR11MB7061:EE_
x-ms-office365-filtering-correlation-id: 9c915de4-7765-4924-85db-08ddefeee5ea
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?YmFpRlhIQzQvb01tdlJXSXlTblZhUEhnRHYwUFA5Mi9ZM0UvcHdHSEJnZUw0?=
 =?utf-8?B?d0M0L01EYzU3cU9WSWM2dW5zODVDUU1CSmxzZDdHLzdWSmNPektyRVpBaUhS?=
 =?utf-8?B?aEVRNzk2djMzTnBnR2lUY2dpOEg3U2lMTXMzdHFBbHJFYmsyVmozMk42Zytz?=
 =?utf-8?B?aXpDWlIvMGgrZWxWMU5XblVWNi9CS0FBcmpVaXJQZVA1MXVCcFlEcHBsbi9v?=
 =?utf-8?B?bEduK0hsRE9IcEtLRzdCd2dzdlhzb1FPWnpzbDExaUU0ak5tZlZrdVpuTUFI?=
 =?utf-8?B?eUZLYUJSK0g1UjI2VUw3RGgyNkdlb3lrbzZtcXVqVlkxVlN0Y0tDcHViakRy?=
 =?utf-8?B?YXJJRE0vSHBQVnpVN2xXd3pNS3FTQmhaS2I1VDRPTndFdTB2bWQvWjdHSWxN?=
 =?utf-8?B?UUZVU01aK0MzNzFRMjlIdkt1a2NNZWNMNXIrek0xbDB3QVJOaTNGckNlejJn?=
 =?utf-8?B?QmdyWlVBT1FBRWU3MmJtVzdMZUh3dWZCaWJIaHlwZEwvelVmRDU2czE5Z3Bu?=
 =?utf-8?B?SHNSektNd05VOVF0Ukd2RjhwQWhDdTFsT0h3NjNVVm1ZaXFvQUs5aVdaZ2pa?=
 =?utf-8?B?NXp1TWJ3SHhCenF3QWJtVHVaZ1UrY0RONnNiZmRoN2tiNDUrVEdIcEduQSsx?=
 =?utf-8?B?eG12QVF6U0FqRDJMTEMrcGNRRE03NHplcVJ3clpwcTZ6d2tFQUJQaDA4SFBn?=
 =?utf-8?B?cXdiRUVtdGpDbHVTekdlVkltSGN0S0ZocDNwem90YlIzbmFPcEh6cGxBV3FB?=
 =?utf-8?B?OGUvekQxSEQ3TU1MQVJ2R1pWYzlrSkRZSWRlRmRNQXY4dFN1VkE0bys2ZkVL?=
 =?utf-8?B?eFNOMG4wK0RtUTcxMjRvYVZvVkxsOHVhQjFjQW9tUVZVVFY2dEhBRllJTjFU?=
 =?utf-8?B?U3VoWVJ0cXlJMXFMODZNSEhERzl2M3lBWGViaTllSTFsTG5HQ0Z0Wk96U3NG?=
 =?utf-8?B?ampRdDhvVnZObVNxL2QvTDFEOWtaalhJcjlnRlpTMXo2NGJzWXFoSkl3VGp4?=
 =?utf-8?B?QU1FRHdoWmxPaUt5azRGQmJGcDRBZDV3WTc4elI0dWl1T2IxdHNURmx3YmFo?=
 =?utf-8?B?cjEzaTVZWHdaWUhET1dzZHNxeUo0QnBzUnpNQWkwMUpSakZud05xN3pSQXAx?=
 =?utf-8?B?RmtwOVM1QnBUMkRxY2ZrTWRFdkUzZE1RWXp1TlZhWmNsVzA3cllBekh5akFi?=
 =?utf-8?B?RGJONWxwVU0xN1Bka1Z1WGRWWHZuMEg3NWl0aklLSnBWakkzUnVkcW1wMktY?=
 =?utf-8?B?YmtrcmRUSVZLcURBUUg2Q0daUEVnMUFlZGR3bmVMMEQ4bksrM1Q3QlpCcXhx?=
 =?utf-8?B?TEV6dUJza0Y4Zk85WlIyRFNCVXRwNFd6MEV2TTBjZVQ2ZGk2eG5oUTV3SzI0?=
 =?utf-8?B?WW8rU3FhUnNmUHB4ckt3bjNRc1BId3VDWDc2NjZmbmRyRXNrTlBsYmp1WUpR?=
 =?utf-8?B?QlA4aUQzN0xGa3BYNVFsQXUxMkppZGd6Nnh1R0Z0RnhlQ0lTNUtNaEIxaGcy?=
 =?utf-8?B?WTVFUzV0VnhBU1NmN2szS2RBSEhpcG5OUDVZVmh2b1BibTV3QWdVdjA3YjRv?=
 =?utf-8?B?NHFyNGgwVUlkaXMvOE41MHpNU25oVytLTFYvUU5kNHUvMnp0Q2sxeUdOcWJW?=
 =?utf-8?B?ZEdmSGkzWmdqMDlZNERORmU2NFkzWWdmSk9KTFQrbmpyVGdESm03ODJTTDRS?=
 =?utf-8?B?WEp5SEY0dVBDb3FqVEhac3oyWXBNdVNIRm94bjlPVVFBV1QxOU15UVpyUHhN?=
 =?utf-8?B?ZWd2OWJnQU9JUzJDelJOOGplMVZtZk5Sc3M4cGowZ3d0UEVPSTFTR0xvTzJj?=
 =?utf-8?B?V0NySklyZCs0M2JhT0NhcGZ0VVF5eXhMTzBwT2NSR0RWRS9neTRUTHlIb0Ey?=
 =?utf-8?B?bE1TR3FBdHZVWXVDUHFGcGlpUnNWOUNIUmFJSTFLdStJSXl5Z216MmdMTVNN?=
 =?utf-8?B?MzNmRnlnc1RMRTA5Y2dxbXNVejYvVlVNc1l3bEtaaDF1NCtqMlZiUVVxQTVS?=
 =?utf-8?B?clhHcGVFRlV3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b25QZjlEeSsyR1pHZitKVzN0ZGN6MVljc3RGa2tkQ204T2RSaDhwRVRxZnZE?=
 =?utf-8?B?bzNaRGJoZnhNR3IxV29xN2xRZ2xJNzJSV3lxRTd2MFN0cG1YL1RmV2JIczZ3?=
 =?utf-8?B?ZS9VQlJVOHpTRGJDRTlxZWFiWVJMSVpyVjRkMXRpVTBXdWJkS1k0Z3VKcFhD?=
 =?utf-8?B?ei9vVXNRcmlTVmN0R3o4WWw1bGE1S2k0bHhLblBmMzhPWTZ6Q2R5ZnBXU3h4?=
 =?utf-8?B?NXZUSlU3VHY5d08zMGEvbm1GYUthamhDMkpIWGRiQkpheXc2eUVaOWxKWjhj?=
 =?utf-8?B?dWhlUS9jUGZDelU4QklrTjlwQ3RnVmJjRmFHejdQUkhqK1dablNnaGg0VlZo?=
 =?utf-8?B?U2J1K0NPSTRwQ0JBY0RYbVU1MnZkaGgrQ0xxYWNNcVozck9CZUlMclQycHNj?=
 =?utf-8?B?UXhHMVRKVHppc0VvRXNXOG1tcTZyR1NoUTlUZ21YeUZ0Mi8zL3ZTV0paMTZS?=
 =?utf-8?B?c1NWOC84b0Z4VXhBZGpPYnBOQkIyNUJ6SkwrbHNHTTgvSzN3Z0xBNFN6RFJC?=
 =?utf-8?B?bDExYis3SUhDaEZCM2liR1lsbGNoWHZOSXdraUtEY2E0amp6UThnREpVQytU?=
 =?utf-8?B?SVgzK0I3Q3dJUWxhVDl1dWgwYUt5Znh0RVhoQ1ZoUThNK0hqVUxwRnMrZUwv?=
 =?utf-8?B?dk5SR0s4emFRc2FpTWc3OEFNMWk4c1FBVEt6bkx5aWErc2ZjRXF5bVVFNS9U?=
 =?utf-8?B?TXhaTzlRRzFiWU11dEI5Z1pHNTcrOHJxd1lEbFllSmRMQnVlLzVCTjZUeEpn?=
 =?utf-8?B?eHRQZldtcXphMk9nOVpuaVhweXpBQ1FtaWhUUVd0bGdSWmtqb1lqMGRuZXJm?=
 =?utf-8?B?U2NhQnJJKzlOLzh1YVdKeTJVN2lSdjR3RndsRS9rUTdFbFRuQmRkNytQSnFR?=
 =?utf-8?B?OStvemtQSVFVcGRLSGRzSFFtb0Rmek1ZN3FCSXp1SUdoZUR0WXprOHhUd3A2?=
 =?utf-8?B?NjRUYzhCMmF2azFlcVNjR1M2YWpqa0VEQThqbGVEZzNPazN3cDFwbEZqMkM3?=
 =?utf-8?B?OXc4TTNWUk9BZ1FXK3U2ODlEYy8rSUVtYVdKaWdKMUhYQWMya202MFFHaFVu?=
 =?utf-8?B?ckRlVkxRSEVaa09TeU5HQkFnbnQydHNJY3MxQXZyMGhEcS8rVDV4djYrUUpu?=
 =?utf-8?B?L1FLdlRHeXhLZ0kyY2diUDRPSlV0SnQ3aUxvTmF2RWRzL2FjdlhJWGVYTzV4?=
 =?utf-8?B?U2NIS2R0V0JRQ3NXbXpJK3ppK3AwYVZXcGx2QnlqL2Y3RC9lR0hwVktKQjFH?=
 =?utf-8?B?Mk90UDhGNGNsT1Bsa2w5dXYrSFRTd3hseUxJdEFiZmNaS1JENzVPN2N2Wm41?=
 =?utf-8?B?VVQrL25Oc3JrTTlmZDJxcWxyNkJId01LamJuMDU4djh0K3MwVmNwU1BUUDlU?=
 =?utf-8?B?bEF1SlhzZlBVYWdLcVJ2WnlHY0IrWk41b01lUjZKU0pzTTdrQTdWYUswSHM4?=
 =?utf-8?B?QVhiNVFzY1E3QjlDcEVBT2pyQ1h6am5RUnliT05xTHgvR3VJQ1NOSVQ4d0ds?=
 =?utf-8?B?T1ZTZ0hzWDdUYTlZVHBBUmRmdmFlVEVOWGVXYVVFOWRkVko3ZkJCcU0rTHZn?=
 =?utf-8?B?T1JUS2ljelVYSEY2WGZYL2ZuYWdqT0w4Zk9LMHFNWllyMzFRdGJLUDdLUlNu?=
 =?utf-8?B?VXE2dTBqbkc0QW1ITlovWjZzeTJVb1VVVEt3VlRUeWd1MlJJQ3RRMmtBNGZ4?=
 =?utf-8?B?RFY5TURNUE8xK2RFQ2w4UVNnRGxzT0dFMmlWNC9qMERaSkVuTjBLVXlFMjc0?=
 =?utf-8?B?K0VsNXNzRDVBZUxPQll6clYrQWxEUHJTUVlZVUU2aXVWekVPNVh0WC95RjQ2?=
 =?utf-8?B?b280QXZObTVjK25PUytCVzZMK1JiVkxYV2ZobU5tbzdUUkNaQzVLV2ZnY0Jo?=
 =?utf-8?B?Tnp2K0VFQUZzQ2hWMnROKzVmRzlXMWQrSy9JNTRrbGoxVUtpWXZRNjhpVm1N?=
 =?utf-8?B?UHlkbDZqcGRHMUd2WG81ZlNpeUh1bHFPK3NxK29NVm42enpKcUQ2c0lnSXJE?=
 =?utf-8?B?MWZnb3V3dlNFeno4TlROMjg0eFEwdEU2LzBaalZBVUV1NWgrNWk1QW9BVXlI?=
 =?utf-8?B?dUFRN1dSdHFaVUZVU2VHZ3FKaisyR3E3T1VOSktYSUZpamVjT3FaSmNwck1E?=
 =?utf-8?Q?rY2oZOZmmbreb3rIeakqFGDui?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <48A16D8CABC295429603ED3D9A439669@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c915de4-7765-4924-85db-08ddefeee5ea
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2025 22:19:09.4975
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s1nRWToU26cXMaPI0wo/b0SMCahV7Z65N0RsRUPqc3RCrI3NJTSOd6ogQ8Cz6Zdhfcnrn87MnScaGf5qB7e8lg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7061
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA5LTA5IGF0IDA2OjQ1IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUdWUsIFNlcCAwOSwgMjAyNSwgVG9ueSBMaW5kZ3JlbiB3cm90ZToNCj4gPiBP
biBUdWUsIFNlcCAwOSwgMjAyNSBhdCAxMDo1NToxOEFNICswMDAwLCBIdWFuZywgS2FpIHdyb3Rl
Og0KPiA+ID4gSG93IGFib3V0IHdlIGp1c3QgaW5pdGlhbGl6ZSByIHRvIC1FSU5WQUwgb25jZSBi
ZWZvcmUgdGR4X2dldF9zeXNpbmZvKCkgc28NCj4gPiA+IHRoYXQgYWxsICdyID0gLUVJTlZBTDsn
IGNhbiBiZSByZW1vdmVkPyAgSSB0aGluayBpbiB0aGlzIHdheSB0aGUgY29kZQ0KPiA+ID4gd291
bGQgYmUgc2ltcGxlciAoc2VlIGJlbG93IGRpZmYgWypdKT8NCj4gPiA+IA0KPiA+ID4gVGhlICJG
aXhlcyIgdGFnIHdvdWxkIGJlIGhhcmQgdG8gaWRlbnRpZnksDQo+IA0KPiBObywgRml4ZXMgYWx3
YXlzIHBvaW50cyBhdCB0aGUgY29tbWl0KHMpIHRoYXQgaW50cm9kdWNlZCBidWdneSBiZWhhdmlv
ci4gIFdoaWxlDQo+IG9uZSBtaWdodCBhcmd1ZSB0aGF0IGNvbW1pdCA2MWJiMjgyNzk2MjMgd2Fz
IHNldCB1cCB0byBmYWlsIGJ5IGVhcmxpZXIgY29tbWl0cywNCj4gdGhhdCBjb21taXQgaXMgdW5l
cXVpdm9jYWxseSB0aGUgb25lIGFuZCBvbmx5IEZpeGVzIGNvbW1pdC4NCg0KR29vZCB0byBrbm93
LiAgVGhhbmtzIFNlYW4hDQo=

