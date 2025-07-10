Return-Path: <kvm+bounces-52064-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E105B00F26
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 00:56:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 804D05848E7
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 22:56:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D323F2BE7D6;
	Thu, 10 Jul 2025 22:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hc/5XbzC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E66E28B7E9;
	Thu, 10 Jul 2025 22:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752188156; cv=fail; b=VPdCblIKol2StI/N4A3Pf7rVP9wfVhiHUCmDWmMZxDLGvcIGAMuChfKcSjOL+SkOpJ2lTKAwgtBkSu51V6h/VZYqftbfbrMWTrO+rLXSK95qdkqTNjZRZPw+mEfZ6wKedSDbNOeQmoDhX5+dX+kacDtIrpi8/F7MZVZCD4WtBwQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752188156; c=relaxed/simple;
	bh=mpTdNqTgAJvefWs+MzbBiExvQxtWED/H9UnxH5ZzxZg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=MJq4gF6NZ7sZrhRmanexUZ3Wvf9o9UT4TXNe36eRSPV8Gocl3rGF/eI19xOx1TCyKWIsK880m6T6pHp1PPDAMJzsx0drq8BIxFrahAe0NvO+zLwMBHK6ZWWUlzAhy+1ztgJUekCuxhsbb6ivRmLZEhYZjmfm9rQgNM5+bdQoEwA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hc/5XbzC; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752188154; x=1783724154;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=mpTdNqTgAJvefWs+MzbBiExvQxtWED/H9UnxH5ZzxZg=;
  b=hc/5XbzC0XgJII8FoMypi1hw/JiZVNHy+e9TeM4Mn+r9+Aid3ZQsQ38L
   rVs0hZH63rAnGU2fVYLbC3xIey59j3+1FXAVnS7GBVOOgl77UwufwItTc
   fT1cAMN7qgsf0O4riRd40GiJESazebsEiQjL/3HXlHyGzCsXzPVmscWYq
   hgpbMXIUSQQCpqNVlgiSjT4IBGuxQKoIagyeW5lRgcSDoq+9N+9SBHowK
   ms29AVImu+b9AJDIXYWd04+R0rZIy76pVD63vLCS1yBMqQF5oaXefsPGn
   2gtKNkBk9xm1E2nB4uiiNOgwDz422QRTRxD4z996ioznahZuhtU89HKFt
   g==;
X-CSE-ConnectionGUID: xzrvCL5FSCucPFVHXY6kpg==
X-CSE-MsgGUID: G6cK37dbQ46Mx6M+Ymr94Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11490"; a="54612723"
X-IronPort-AV: E=Sophos;i="6.16,301,1744095600"; 
   d="scan'208";a="54612723"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2025 15:55:15 -0700
X-CSE-ConnectionGUID: pbkfN/ZQRK2bNZ1dBa7CjA==
X-CSE-MsgGUID: RjBLOCXMQ/2LPit4M3sFag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,301,1744095600"; 
   d="scan'208";a="193425019"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2025 15:55:14 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 10 Jul 2025 15:55:13 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 10 Jul 2025 15:55:13 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (40.107.236.85)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 10 Jul 2025 15:55:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Kny/YtWybWsuGZtEOvf17T/4mX5GCNHxidtSU5jJw60LSQ2jEpHQhIEV7qQJ1t6JHrX7BCwhA22iFxYYuBogn7LaH0AzhQ53U3Bfkt1m+cRT2REGPwYua1LMtVc6HxEFBw6aq2cM5BkJ9rii6VGNz1awuLz52tOVLPHzRkO8lZ0f5F0DFy+o9Ydq4gkbA/qpzvpXHXtka4wIndUkpTjH+pEMG74kLprfn1guOz9TBz+MkYveTXm0GPaVXDOmQwkZd8b3g8W2nevTfnFtCY7lfanRbKfSfIqgOINTNVz3C6cJVwN+BRprFiJKMosgOg1tLc2odxtUeEtfuL8s/yFdlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mpTdNqTgAJvefWs+MzbBiExvQxtWED/H9UnxH5ZzxZg=;
 b=cvsQPkYUjG4/bQvDe4tDdU+qcvcN55TbgcRLPKzr57I1uv0OCgG+Sos4oJ8DgcjEGzkltObfHdlvhBc7NZA6s89aNsp8Mc+F4RvhRugDwVJVQy97c3t2dp2lhYE19synmrGs/saAJfze5SsqH/sIptI21VFlc2ZDZ3ASyB8RV9gCV03rmBoQUv08dkr4HejvEByyrDi2V0PmR+fQcDR0vD5dWCKKYxO7F8hEPBNy6q/CcjhbGjsE7tbT5eht6+1ift8p4YjcFjPErh2uN8FQyx6gZawp77vOkXGZLCbmmMyx9+6QgtlT8Bjz75zvjP0wbtPfpHOvcR54UG8UFZ4LGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by CY5PR11MB6485.namprd11.prod.outlook.com (2603:10b6:930:33::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.26; Thu, 10 Jul
 2025 22:54:43 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8901.023; Thu, 10 Jul 2025
 22:54:42 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "nikunj@amd.com" <nikunj@amd.com>
CC: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Edgecombe,
 Rick P" <rick.p.edgecombe@intel.com>, "bp@alien8.de" <bp@alien8.de>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH 2/2] KVM: x86: Reject KVM_SET_TSC_KHZ VM ioctl when vCPU
 has been created
Thread-Topic: [PATCH 2/2] KVM: x86: Reject KVM_SET_TSC_KHZ VM ioctl when vCPU
 has been created
Thread-Index: AQHb8JJNsvqII3I3Gk2c0fgebVez6LQpfEyAgAJ9yoA=
Date: Thu, 10 Jul 2025 22:54:42 +0000
Message-ID: <008f79a7bc1bc8a942897e56824019c9aba02955.camel@intel.com>
References: <cover.1752038725.git.kai.huang@intel.com>
	 <1eaa9ba08d383a7db785491a9bdf667e780a76cc.1752038726.git.kai.huang@intel.com>
	 <6513254f-106e-4ed9-9622-8ed20909e1fa@amd.com>
In-Reply-To: <6513254f-106e-4ed9-9622-8ed20909e1fa@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|CY5PR11MB6485:EE_
x-ms-office365-filtering-correlation-id: 1ed85364-31c1-4f85-f43d-08ddc004c245
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?RzRFRWlpTVpka0NFcHg4MktsY3FpdVFja3pqNkhKczN3RE5Rd0JpbkV5L3Bi?=
 =?utf-8?B?M3ZQRnBUR1BBbCtxT0puSWtUV2M3V2NVN3kwSTNKQXp6ZW9jNm5XWFBQRDY1?=
 =?utf-8?B?Wjk4aXRBL0pvL1dCZTQ0bnlvdGxPT0wwZmtTQTA2d2I3ZWpoeXVFYTRpSmRB?=
 =?utf-8?B?UmxKTnQ2TVJjNzQ4TUFTQXJNUGpKaTFSWFl1L0oxQVBjYXpjTzRFbkR4emVa?=
 =?utf-8?B?aUN5VzJrZnpLQVZoSit4NE5uT2E4MEpGZlRTenFXQXNaWkR5NHRqTG1vWWJP?=
 =?utf-8?B?b1NuNlZVZ0RsTkM4VDNTWU8vNmplbHhBalNDSXNZd3BGazVyRU8rQjUwL0NJ?=
 =?utf-8?B?M0ExMi8xTGJRUWVuRmFKU0Z6ZDJHVWRHc1puWi84VG5qcEpxeVM4TlFCdkF5?=
 =?utf-8?B?Z0p1b0o5RE5tWFdPbzRXbHg1NStkTDdjUzIveWR3NzdpVUNsNzJlemN1Q0gz?=
 =?utf-8?B?cnZXMEpVNTNBMXhKbUlrMmdXUG9aYjFvMjBENHlzVzcyYktyZnBqMEtnRUVa?=
 =?utf-8?B?NkxGdkxpZmZZdE9GOVJPeGRWUGNmZ1R1SnZHcENFdkh2bWU5NTVEUjBISU5T?=
 =?utf-8?B?YXFWdllMcHBsUlFzMTRjdUJFckJwUGRJMGRjMHBla2h5bS9Wci9qRTZ5MDZs?=
 =?utf-8?B?dHV6U0RZZmwySzJEQ0lRTWp3MHE2SjdlS1FVZ2ltVjdUbTVqWFdVZVZFMG1X?=
 =?utf-8?B?SnhVRUsxK0dhK3dPdStpK3NielZKL2RyM3dRbUNCZVNoVW1uSEMwNjdYdTIw?=
 =?utf-8?B?dlowMzY2b0VzSXFCYzFhNy91Zlc0bGNYOFdIVnU1Qlg1bWZOWUk1cjU3U1R1?=
 =?utf-8?B?cmNlMGRNUnczbXhRWjlqZDRNbFg1UmhVMzRUNm8vVHo5a0FRU1NRa2ovUFdT?=
 =?utf-8?B?cXdTSG03THI5Rm1POHdIK25GSHo5R0w5N1pXdm0wcThDQm9YMGo4ZThEd1RV?=
 =?utf-8?B?OXNGTExwc3ZkR1kwQlFJM3BGUTJFSUEyajBNMEhyRnp3TzlpUkFuQmVUZ0hn?=
 =?utf-8?B?Zkxadk4wNFNBUGNjT0ExV2w3UFlMblE0V1FqOHFoV1E5bklRV2lzVHJKMXY2?=
 =?utf-8?B?WkFoSm9QWFdSOUNqajdkY2xVZXBnVTFJK3ZlUFhkUlV1RGxIZFBxdFplL053?=
 =?utf-8?B?VG9CVE1zeGVkNnBqZDh3VFU2aHVVWVRxbEJub0IyOU81aVB3Z1NmdFZtQ2lw?=
 =?utf-8?B?dW1OOFliSWZyeFpxS1ZIYy9LM2lMWWZtYmRBOFZZaVkyZjhKV3dSMEdDZlJm?=
 =?utf-8?B?blJmV2lsSC9RNmM2Vmk5T3FHMGZHaENZaVh2SDVMMXVkOFM0Z0orVmdlbjg2?=
 =?utf-8?B?V1NqM1NMaURRSnRGRWg3UW1qQWI1V1ZmSnN5NU1GK0ZlQ0s2cFI2dzRJdjJ2?=
 =?utf-8?B?OXMzY3FwNEJBeEl4dWRmSXEwL3Zwa3p0SHB5OUQwU1A4WTkzeFlML0krcmVQ?=
 =?utf-8?B?b1I1RmRZcnRVOCtkbzJpY09wN3RtbDlDdm9sNUNBbUdFY3dWRXptVW1vTGQ2?=
 =?utf-8?B?RUlYS2VxQ0UvaXpzdFR1akxGR1dtb2Vuci8vYXNhTW0rcExCSE8rUCtlSGp6?=
 =?utf-8?B?elBlUnk0R1ZITE0wbWF3cStuNzdEdldpcHg4ZjFuMUxEYUViQVZtMnBLZWta?=
 =?utf-8?B?OUpXK1ZuMWY0YzJiOVJTa29GN2xmaDEySTZjc29Yc3psekxkaCtrSTlFWmdE?=
 =?utf-8?B?bGlrNXJlMytqenFFaWJaUEVqc1hMK2x6VW1mNzZQRlhZbytUWXdVZWNHTW4x?=
 =?utf-8?B?QnYwM3BpNFV0UE9WNnRYSDNIRTV5V2IrL1BqKzg1Rk9HREJReFZDWXZweE5h?=
 =?utf-8?B?dCsxVWxwMHdTWHRxZlZ5ajlpQTY1ZkFPQWRoUU9mRUoxbGFNaFp2MFFac0Vw?=
 =?utf-8?B?ZXhrcjkyZ3BFQlF1cVlsbnVhdVM2UkEwOW9tUXpDVFQrL2phOSt0V2gvSWtB?=
 =?utf-8?B?R211WklOblVLcnNONnBsWWtRUnhxYnR2Mmt1U0ZFNVd3QlpZU1gvVU9uQjcw?=
 =?utf-8?B?RXczdmdEazdRPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?djZyQlB2RzVVUWNwZFllbzJoNmhxdzd5SjZoN3BGSkhPNlZPSW5scTM5L24y?=
 =?utf-8?B?RDc1eXF2MHNORXNCcmZWQkh2V0s4T3pOQ1N6enA1b0VTU1U5R20wUkFjZVN5?=
 =?utf-8?B?eFNZRlhJbTBKaGZQMVY2ZlN3SmN1NGY1N3lqQm1MRUxmTUdEdndMRzBLbVdU?=
 =?utf-8?B?U3gwTERpQUdiOGhYZHlhK2JVOTNWNHVHQTdvaHJNL1VMNXRmaXhSQXQvSjVa?=
 =?utf-8?B?c0xTaTFsQlBiU0ptVVVaYmhFb2Fjekx5cVgwZk11YlFSeG9GKy9lZ2xQaXI2?=
 =?utf-8?B?RWNHSUZva25TQnV0aUxkRmd5eUVhQ3I4dUpFcVg4TXM1MzgyQXMrQWdoWG1i?=
 =?utf-8?B?cHNyTHJtS0RhSTN3R2ZEWTJ3a2c3Q05aUlJOS0JpcDErR1Z4N2lwdzVjVXNU?=
 =?utf-8?B?OUxwMkRNL21NOCtQZGtGZUJmRlVVZmJ1eC9YQktDa2hTd1lIbW9GcGMreVQ5?=
 =?utf-8?B?VFk2anhKbmdGeVdrQ01YUG9wdnVuRHJ0WElQWkNIUDlXcnZXeFR2Y0d0NHU1?=
 =?utf-8?B?blpOaHByZ2o4amxpS3UzUzRsd2R1d2VHa2FTZnUyUHZmMHphc3BDMDZrVVEv?=
 =?utf-8?B?cjlsMjBlNk9HbHd5TVpHT3FTWHFjcU40QlB2dDZRZ2VLcWFrSFNtRGlJNzJW?=
 =?utf-8?B?Tzl1WW5uU2t0YXpxWlNZMjI3NlRoVmxkR3RkeFoxbkQwY0NJZmVwMFpUa0V2?=
 =?utf-8?B?N2J2R1JzMnBWRFd6cEZMYks0MEhpelB6WEE0dGJYL3JRN3hZMDJwVnpoK2ZV?=
 =?utf-8?B?WmdyM2daL1BldDdiRWV6ZExDbE1BbGtVSzhnc3JzbGVkWFdkaUUyOC9QSVRa?=
 =?utf-8?B?clpGODMvMVE5OEpHbm5oa1h4Si9maWs4ZVdPOHhwQUw4bm1PaFMzN2tiMURK?=
 =?utf-8?B?alBST3VXWmJROEthYnNqaWFxTEE3TFVCOStlc09hMlRvdjNDNFJYM3NNVzll?=
 =?utf-8?B?STYrc0s1aE4rTmV6WXVReU1ybU1BQU9XV0cxNHFpYk51Wm5qK0pXTkloOGpx?=
 =?utf-8?B?ajdWVkh5WjlWaExXcVlBZHBCcW5TL1psSUJrT3FsZVRMYTF4M0o5Q2UxOVVQ?=
 =?utf-8?B?bGhvR1lSeW9hZVBxWkdlNFlSTDkrcWdUT2ROeGF5ajRNUlVjUUJ6Umlka2NO?=
 =?utf-8?B?LzRNcWZjSWxkOEV0ZW5tVkU1UHJ1WDQ4TnBUWGlZYzRiNjd6NEZtVENzUTBu?=
 =?utf-8?B?YnU3RVNIYlV2UUNBeTBzcGZXUG5PNE84S0VyUkFWbjJYaXFKdU5Rcm04TjZm?=
 =?utf-8?B?OVZMZ3lOdC9DL1UzM0NlL1NRY0FIdyswdjhoL250NVAxTzBPcE5MM2RxZ2Jt?=
 =?utf-8?B?blBJeDdXWkF4cE5lSFpiVmV3aXhZOVZKNDBnd0Fuc0lMZndDeTJsS1QxTzkx?=
 =?utf-8?B?anFDQjRFOTRSclpMQXhFQUFrU21Da0pSdTR5N2ZyYm92UUhRaFRNTlVreUxU?=
 =?utf-8?B?dVhId1J1OUhUTjZPd2d0ZUVjQS9yUEVtUSs4WlpJNFZBSWNLQW1hRkxGVm1N?=
 =?utf-8?B?YVBaQUR3RjdadVJYWmx3R3dDcFpXSDRwQm04TWhjejY3eTR0dkpIdnQ0NTlW?=
 =?utf-8?B?ZCs2dmY4b1VIY1RoTEJqYUhTUkdFL09zQ3FMdzhiYU9vVHFCU2xpS1lSdHdE?=
 =?utf-8?B?VFNEUlBkZThTaHA5eWxoWXhrVTl0S1F1cm9aY29LdnBzeDVaTXp2WlBWRk5G?=
 =?utf-8?B?dklmSTRYV3dYaW5vRlNsVVVOM3FBckloaUwxSkdGUG1SSzNvQm85ZnBvaFdH?=
 =?utf-8?B?TGh1TWxpTjA0eERoRjRyemlYOHpReVFXOHVIU1FFUzdXTTFFeDRSNndIbjRY?=
 =?utf-8?B?RGV6RDRpZHFHRXBhc2tndW4rNHJwM2tqU2lLdS9sQ1NVeGVWVElNUnRxRjNr?=
 =?utf-8?B?ZTVTaUlDS1ZleUlNV0J2ZU1RVVBzWENuanVMeXZSOTkwL3p0OWJSSGMzTENt?=
 =?utf-8?B?Nk1kYmg3c0d3eGNhSmdpNG1za29ZZmJtZHZlVVl1VVBCUlBKSFdEOFlBczU1?=
 =?utf-8?B?M21vOS83a3N3L3lwMnRGd283Z2dTQTBsS2RsZ0NhOVBHMjV3UHczQnNVb3pE?=
 =?utf-8?B?ZTA2b200VTY1OERWMitUcHBrWVRRWWhZZ01TaTZVVTB5elc5M2tNd0l3cGxV?=
 =?utf-8?Q?DpNUDy8L/NpP5/HgE/5HCR4mz?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CABA4AF95E074C4A82108E4643525A31@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ed85364-31c1-4f85-f43d-08ddc004c245
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jul 2025 22:54:42.8076
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DyUQ7P5XkNdgCd01brwaOXNTVchMrNIa5AFLbB9yWGRmpM6ptiHBqfHYpccoX0pgqBZ8xdhJs4gXuFNH3fBSVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6485
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA3LTA5IGF0IDE0OjIxICswNTMwLCBOaWt1bmogQS4gRGFkaGFuaWEgd3Jv
dGU6DQo+IA0KPiBPbiA3LzkvMjAyNSAxMTowOCBBTSwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IFJl
amVjdCB0aGUgS1ZNX1NFVF9UU0NfS0haIFZNIGlvY3RsIHdoZW4gdGhlcmUncyB2Q1BVIGhhcyBh
bHJlYWR5IGJlZW4NCj4gPiBjcmVhdGVkLg0KPiANCj4gUHJvYmFibHkgdGhlIGJlbG93IGlzIGNs
ZWFyOg0KPiANCj4gUmVqZWN0IEtWTV9TRVRfVFNDX0tIWiBWTSBpb2N0bCB3aGVuIHZDUFVzIGhh
dmUgYmVlbiBjcmVhdGVkDQoNCldpbGwgZG8uICBUaGFua3MuDQoNCj4gDQo+ID4gDQo+ID4gVGhl
IFZNIHNjb3BlIEtWTV9TRVRfVFNDX0tIWiBpb2N0bCBpcyB1c2VkIHRvIHNldCB1cCB0aGUgZGVm
YXVsdCBUU0MNCj4gPiBmcmVxdWVuY3kgdGhhdCBhbGwgc3Vic2VxdWVudCBjcmVhdGVkIHZDUFVz
IHVzZS4gIEl0IGlzIG9ubHkgaW50ZW5kZWQgdG8NCj4gPiBiZSBjYWxsZWQgYmVmb3JlIGFueSB2
Q1BVIGlzIGNyZWF0ZWQuICBBbGxvd2luZyBpdCB0byBiZSBjYWxsZWQgYWZ0ZXINCj4gPiB0aGF0
IG9ubHkgcmVzdWx0cyBpbiBjb25mdXNpb24gYnV0IG5vdGhpbmcgZ29vZC4NCj4gPiANCj4gPiBO
b3RlIHRoaXMgaXMgYW4gQUJJIGNoYW5nZS4gIEJ1dCBjdXJyZW50bHkgaW4gUWVtdSAodGhlIGRl
IGZhY3RvDQo+ID4gdXNlcnNwYWNlIFZNTSkgb25seSBURFggdXNlcyB0aGlzIFZNIGlvY3RsLCBh
bmQgaXQgaXMgb25seSBjYWxsZWQgb25jZQ0KPiA+IGJlZm9yZSBjcmVhdGluZyBhbnkgdkNQVSwg
dGhlcmVmb3JlIHRoZSByaXNrIG9mIGJyZWFraW5nIHVzZXJzcGFjZSBpcw0KPiA+IHByZXR0eSBs
b3cuDQo+ID4gDQo+ID4gU3VnZ2VzdGVkLWJ5OiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNA
Z29vZ2xlLmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBLYWkgSHVhbmcgPGthaS5odWFuZ0BpbnRl
bC5jb20+DQo+IA0KPiBSZXZpZXdlZC1ieTogTmlrdW5qIEEgRGFkaGFuaWEgPG5pa3VuakBhbWQu
Y29tPg0KDQpUaGFua3MuICBJJ2xsIGtlZXAgeW91IGd1eXMgUkIgYW55d2F5IGFmdGVyIGFkZGlu
ZyB0aGUgbXV0ZXguICBMZXQgbWUga25vdw0KaWYgeW91IGFyZSBub3QgT0suDQo=

