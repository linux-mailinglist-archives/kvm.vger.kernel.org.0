Return-Path: <kvm+bounces-68096-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id E3EFDD21A76
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 23:49:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 046A5300F074
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 22:49:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5486350293;
	Wed, 14 Jan 2026 22:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fa9xRl0a"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 646D534217C
	for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 22:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768430949; cv=fail; b=FXtJ1mp+qvW4yGqK61WSZoMs7y5h6FZ8ZhbaZA9nb3KSj2xbP7+v2LUT9xYN8i4wP/LnPoBAYRSrHV8E3nxZBv9DLsfldDOfH9oo8vCyy5Y1mifcLwtPyqKOTJ27VSQfq6VT7+PA5qre2SgcGEEEEW53CdEtb18Kll1NIUr1Zj8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768430949; c=relaxed/simple;
	bh=0QlAFXyPlfw3V5Av9ejb8s/xEPPQHhAzVfg5Ef59AAw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CWb1mYAMl9ahKIR/9DgCbvXChZXsXbk72ngBhztyP83K4hj7ZEyCj21SXdXq46mRFWfkKErtjKkbhxDM+t4qpUIsYhoUbDuQiZMkTqBowdbl1phmYlxp2E6dtLuCPx4GTqRfTR8iD6BN2OLUCr6iE5g/1u81PgjWJEaFIVdgT/8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fa9xRl0a; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768430944; x=1799966944;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=0QlAFXyPlfw3V5Av9ejb8s/xEPPQHhAzVfg5Ef59AAw=;
  b=fa9xRl0az2iAQdNVqu9883iydS1cHChxuGzXhkKiVvNSXQco74kjANaO
   HtovIyWqh37eXTQ8uj8tHMrjFU2CrAST3yAO7EsycJFZnojweyGipJtoe
   g+i7Sr7ozemWc0QY31pEH64G44HIVY9vdBwXlqNznIultsE461B8oHoWa
   tjkFinSfrqcOrd62NYIiEZOg6bawU+Zsa2/wQuynsTaK+5nfKtSaIsxmR
   1xXYhk/uIDkNsHqn4jcoIIDW0ITLLIPNDSzB+g5KDiphvUUQ1L2odG+xb
   01Qe5y0iEk2yOduCDBqqGXW5G7Jx10mkswt/mqsupCu3xQH6zErv+Pxn7
   Q==;
X-CSE-ConnectionGUID: gzAcwDfKRSmkgypJLsfLeA==
X-CSE-MsgGUID: zbs5wNxWQf2fFjHgOiP+Ow==
X-IronPort-AV: E=McAfee;i="6800,10657,11671"; a="92410939"
X-IronPort-AV: E=Sophos;i="6.21,226,1763452800"; 
   d="scan'208";a="92410939"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 14:48:58 -0800
X-CSE-ConnectionGUID: v17+TWDnTkuWAL5vwqiI2Q==
X-CSE-MsgGUID: RFCUvjtzR/qDb9CuWKi6/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,226,1763452800"; 
   d="scan'208";a="209305791"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 14:48:58 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 14 Jan 2026 14:48:57 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 14 Jan 2026 14:48:57 -0800
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.35) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 14 Jan 2026 14:48:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=skzTmqRRIsY1+2C9uaSt8DrAWXoYNRWz2LWdFzHUQi6vIg+VWLVAgeOzhAynL/Ls4Ino1v/pMUlZIa7Sy28H2CTnadCZQ6Qrf0WOYcMpxKJZuw4LJye2fwjSpgO6rjR2ZIA6KKjFIULd9sGnMEYWUjiwA6GbniMeKQWl1sT/gVybL9NMOZCKb/9pvvireCCsUjx8f1sbZ1Xl+HhkQq0KjF9gMzD4GFo4mKKW5TC52fAHKin5EkMytGoknNqceVJhEY8u5DNjNW7g1NDSCJQ1rgP7cklPWLRDeJC72WpzGCmuiDMq4ssY6XPocSavRNQys+loJNSPQLw5czL+nFHFqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0QlAFXyPlfw3V5Av9ejb8s/xEPPQHhAzVfg5Ef59AAw=;
 b=HrM9pxLwnO3BsoxzocP+tF1HmwcAfOtDx+yA2yA2bYxw3qs+y63InBoqz9wyBTjuqlje+4pJ3tdSWEEgncoNml3gqBLFyxHQED5h9ZosqNWi+5nAr9DKmhnnZCfCXu59dD4iVGRnDTncE4UchAMVxIQ7ZF9gzRn13nZH5DG47OH506wGJsze7Vodpiqmt/4wITdj30NysiYgB0KHE2rIWZiT1T8cCTcovK44Kh/mq37ZYdpTB3AKcT6NojJPv/TruxVSXChoJpdHnzEHLKrPyQSn8g2Y2QIBXYqkkwnLBBt9xrasC7vBjfknMGUK9GThC5m20M3TxyLLxz12U0IDFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by DS4PPF708A6BB3E.namprd11.prod.outlook.com (2603:10b6:f:fc02::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Wed, 14 Jan
 2026 22:48:56 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a%5]) with mapi id 15.20.9499.005; Wed, 14 Jan 2026
 22:48:56 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "nikunj@amd.com" <nikunj@amd.com>
CC: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "joao.m.martins@oracle.com"
	<joao.m.martins@oracle.com>, "santosh.shukla@amd.com"
	<santosh.shukla@amd.com>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH v5 7/8] KVM: SVM: Add Page modification logging support
Thread-Topic: [PATCH v5 7/8] KVM: SVM: Add Page modification logging support
Thread-Index: AQHcfg3Gf+n2YIr5Hk+kfGbv9gnU47VSU86A
Date: Wed, 14 Jan 2026 22:48:56 +0000
Message-ID: <58fbe8af3e34e01e7f5acdf3eefe13b5cab35631.camel@intel.com>
References: <20260105063622.894410-1-nikunj@amd.com>
	 <20260105063622.894410-8-nikunj@amd.com>
In-Reply-To: <20260105063622.894410-8-nikunj@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|DS4PPF708A6BB3E:EE_
x-ms-office365-filtering-correlation-id: 617becd8-a2e8-4ce4-6890-08de53bf193f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?a0NvVjZKTkZVRTBKSlEyMjh5R3hieStsdHFNYnFCckxlYVVhL2hxQ004bWU3?=
 =?utf-8?B?MjQ1UkUydEgyYVRQUTN0MmxpYVl2eTlpc0I2SXhjWmpiUG1YZTNNVmUzdzEz?=
 =?utf-8?B?b0tnbmVTU1FZVEVaMGVzZ2w4bURNV2VVOU12TFc2R0FJOGlYalBLRWxvalRm?=
 =?utf-8?B?OE5VWUxPM0JpN01vUGREUHc5TTFLVy9NMFdGQWpXSG5DK2xZRUthMm1KNW9Q?=
 =?utf-8?B?ZGxOSWtkS1BzSXpmd0NnNVRXQ0IyaVgzcmhaYkJ2WVI5QW1TZnE5SWNJL2pk?=
 =?utf-8?B?QUNNeXd0K0J1all3enk3dFhSWFFnN2tLanlXVFJmajRYMU5FcnY1UXRUanhr?=
 =?utf-8?B?dWpzNXh2VkdxL2xIbnJJQVRwancxMnpOUEsraHVSOW02MjR4WkFuUUs3K0Fp?=
 =?utf-8?B?cldQVlFhOUZpR3BxMlFxS21zRFNsZlpvbEx3dlJLYm4rQzl2SDRRaWZDRUp6?=
 =?utf-8?B?VWVvM08rMVdCL2tpdi8xVTVIZFo0Q2Evc1BDS25PWnF6cWhha0dtdklqQTBj?=
 =?utf-8?B?RzZCYW9wTlR6ajI4NEVmZUgxUWJocmM2QkptT29KdlloV21jZHRpRGJ3R2Nv?=
 =?utf-8?B?Y0ZvZFNuTWVZRFV4dHFwQWZNUEJsQk1CQ1Y3V1ZGMG80NmprWU16NDlObGt3?=
 =?utf-8?B?YXpzUE0wV0tneGtwV2VoVXdqUDFWMXo0SCt1L0hjbmR0UTNZSHp0cVpFaDJQ?=
 =?utf-8?B?ZTB0WU9IODE1MlZ2THN0WWRNZUR0dzZUcWY1NkJFZVVrYjBqeHI1aFpYSmFo?=
 =?utf-8?B?UHM2ekwwWlBPV1o4WDZYazRlV1N5NmhkTXdqVUFZWmxmRjBuYlJoR2F2WkQx?=
 =?utf-8?B?Mk90M3FqK3JWY3RzWG81M21KZ0pnOEtTdHVmZHBJMHFCTzdzRTNpYVZGL1VD?=
 =?utf-8?B?NDVsRmRvU3NFQmRZNHFPODA4azZwNCtISHpEbFE2VkFXVmQ3cGJDTGZhbHJr?=
 =?utf-8?B?ZkEwVkhHN3ZFSlhtTjZYZ2VEdlRCMzJSd2ttRlRGZksxVmJaenNJKzhzb24v?=
 =?utf-8?B?dkNsTFFSdHovVnZIZWlkUUNLdW90eVZrUE1uMUlXU3NmdjVQU0xDNjMyZVlE?=
 =?utf-8?B?VzdQVjZGQm1nU0llUUVHbzNIalpGSUdPUzlqbzJyQ1JvZGFXbGswSlJxbnAx?=
 =?utf-8?B?MXAyVWtTSDZVYlQ4SWMvSVlBQWFpMjNjT0xNaFczaFY0L1pzdlhObWNwNlNs?=
 =?utf-8?B?T2gyVUhNeHlraG1UeWErY1MxSTF5VStyaVVHV21UYzJ3bVo3M3l1OWxsSzNT?=
 =?utf-8?B?bjVWTzhacHJqakZsanh4eVhNU1YzbnhmTW5pYm1OdnVsUE9ZRURYamEvZUlZ?=
 =?utf-8?B?Q0Z0N210ekVIZUtxd1cvK0JiV0JtUSsvYXRBRmN2RFQ3MFFPTXo0NVhFcDZv?=
 =?utf-8?B?eHpnU3VjTHhHV212dnpJMmQ4bjZqVHpOb1F0RUJmbWsrZzdlYU90M1FINmZa?=
 =?utf-8?B?TWpFNW5xNWlJQkZLbXhZYU9DZk1FV0N6b1ZCL2o3STFaSUVxcGI2RFZMQ21E?=
 =?utf-8?B?ZExaNjNqcGVnZ0l2OGNpTzkraXpQMm1tNVpSMm9pY1VmZ0Y3UU1lSFcrbDB1?=
 =?utf-8?B?bnZhY3Ywb0d1NksyMFdOb09OSXRkK0dUdGN2UzZEd3pMeGNkTjlCSG5jMlNp?=
 =?utf-8?B?UzA5cm5SdkpiUGZ1QW1TQzR4L05QeWI2RnBqZGlIeTJoK3ZHY3lmV3JPSU1G?=
 =?utf-8?B?U3RKc1BqUVhqdy9kUkk4VFFnQTNkMmkydHZhVVRFUHU3WmxZSDJhb3hkVHQw?=
 =?utf-8?B?aEJsNUNDT1UxS01PcHErS080ZHFGaCtXdnU1QncwSkdWMFBrQUwvblBtZDZB?=
 =?utf-8?B?TERYTDZWcy9NZ1NCY1NaTlo1b2E4SXlMWlU4QkNoaEpFeEpGV1dOVlpxR2FC?=
 =?utf-8?B?RXJtb0lpOVBFRW82QU9vbW5MZC9adkczZFY5eEIvT1R3elZpdVF4azBFc2N3?=
 =?utf-8?B?WVdzZDBidG01ekZibDNhYlI3OXY5UlBMSHJob0NmL2FUYVR4T2JDdlVWbTZM?=
 =?utf-8?B?cGtYVWpLNXhLRzQyZXNEa0JTY0ZPa0NEMGhzaEhWb2pHbjVoRFhhZktFSlJC?=
 =?utf-8?B?cjdGLzFqSXkvbzlYNklNYVZFUGhoVmxoM1ZCNy9uSUx3emFyQXRSd2FtNWox?=
 =?utf-8?B?RnRYNmhFbkFPQlFCWm5pVng0MlBJR0dOYXZ5WjRBREhNU1ZRdXhrcUNRWjZk?=
 =?utf-8?Q?zAuH9KiRxwf6m7353IYB+zY=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RWxIbjZES3B1NE84UDlkM1pkN1RkbU9nUElidUtIbFZsdTZIM0lqamNEWkVJ?=
 =?utf-8?B?NDhROVFQZDhLVzRYbVd6RFRHUEJSWlBNajJtaTFQR1pJN0pVNTF0M2V1M0Zw?=
 =?utf-8?B?OTh6eS9BYnhOY2VWZXNXMGVCS0FlUW0xNGFrR3lQRzNUWk1yN1Zsb1YyR25k?=
 =?utf-8?B?WnoyR2s3cHZ5Um9YaFpkUklWWHAzdk5WUUVZRkt0amV3N2pJZVYvVHF1bkVn?=
 =?utf-8?B?ZmpaMnc2NWpQUUlkZUQ3aXZva2Z0eHB6TlNzazRrMnM5NDdWaVlUNi9rN2Nr?=
 =?utf-8?B?dUwrbzVnSUZMV2JGUm5mbjJpMXV6eldaaWdYdUJoYjNYUElTdFJXbWMyZ1pE?=
 =?utf-8?B?ejRVNkRTaW1QdTZGb3YrR01oazFGZzM0aFUzQ24zRVFKQ0F4SVM5SkNTTzRy?=
 =?utf-8?B?SUZ3Q0VmR1VNd1NXWHE0NHY2V3FFS0lMdElES3hJSFp5SXJBZE5CMG5TMk1t?=
 =?utf-8?B?UUgvRkp2VGV5L2pXZEZFME02MHlWWU5jUGlpR0s2WGdMcTFRNGpVeDB2ajJQ?=
 =?utf-8?B?RU91UmVraG5TM3AxTHgrdHE3SDdodUlZV3M3RElWaHdjdEFEb1ZEME9oUkUz?=
 =?utf-8?B?bys2ODMweEN6WFl4SVl3b0d4YzkvclRMbG5zZ1ZjSjB6STczUFowQlFDUFhK?=
 =?utf-8?B?ajNFZUR1bUJ2OXZoREF2M1BHQnZHOGNFSUw5THhsSTJjRFFyWlpwUmFjMngw?=
 =?utf-8?B?RTZCOGxQWGhNL1ZRckhrK21nNno2czJIbnd0M2toeFNsdFhOeTcySEFSTVFx?=
 =?utf-8?B?ak1aZUs0SDBKT1ZJVnk5M1h6TCtxUDgya0Y4V1R6QTFYWGRMRnkwbGVNZVdH?=
 =?utf-8?B?eHh5UHFBYnl3TWVRZWpGYUY0akZKcmZZdlJ0dHc5T3Z5OEtaN1FXZGdVemN3?=
 =?utf-8?B?cXJkcCsxUk8wT1FraElHdjlEY3k5UVVYQ0J1RXluMXA0YVRsMC9kUWE3TkRK?=
 =?utf-8?B?eG4yT0o1QmN1cU1XNXJySE50Z3FxcjF0R21yNG5teFlSbEZMV3JSVk80RHgv?=
 =?utf-8?B?clNGbGdvcXVBbjBNMEF3TjlkdXJwV3h2MlBxVnhLZlZUb05OMGRRY0lhajd6?=
 =?utf-8?B?NmdOUm5Ub0pla0hVMk1Od2JVTEhOaHUzQ0RFN3ppb1NGV284L0dNbS9xdGVI?=
 =?utf-8?B?KzhZbVZGS3hBSXNSZ1pHVDlUZ2dGV2hrblhyRHJYVXBxWTFUd3NwMU5acUQ3?=
 =?utf-8?B?d1JJbkFCQmEvNU5IMWRyMG1qRnh5VXN2OHhMczdJOGhNa25EeFhQV3IxNGRx?=
 =?utf-8?B?d01Eb1lSZnhvek9Nb0YxMk81ekZOMVpYdVltb2NzUFRSRURMbXI1dzFyUW01?=
 =?utf-8?B?eE5oc3ZYSFQ1enUrUG9NVGMwaWdJTzk2dUl0T2pDN1RQQm80V3JJQ1Erdkdo?=
 =?utf-8?B?ZUZWRXhQMnN4UlV4SU5sRm0zYXBJREQ2S28vZ25vTm42Kzkyb3hUTnJpdGtm?=
 =?utf-8?B?ZGNwaVc3NWNkcE91ZkhkRU45SVdaUURYNFdza05nUXBVMTM0SEZKQTVYRHpX?=
 =?utf-8?B?Z0hoNkRJdTgzcUd1cGExVnVWYU1xY1diVmtxUUdqQklhQ1F6K2pJVm1CWmVq?=
 =?utf-8?B?WVZxL0IyNXpqS1EwOGVmQmpjeWJEdDNhdkp1dndKOHJ0K2tBLzFNNzQ2cFdk?=
 =?utf-8?B?c3VsYXJMbXBoUDJqNS8rRDhWemtsR3BlMTlKeUs1SnR2cDBvamJadnRoRnhT?=
 =?utf-8?B?ckR6MzBXOGVvekV2YzVmVEV0UUF4d1BnRTlCd1JucVVxUTBLb1JIN21KWnZw?=
 =?utf-8?B?bk9XbEhPaUc2VHplbUZkaTkweWtlY0J5eTZjU0FRMkRHV3VjU3NMamI2SXE4?=
 =?utf-8?B?czNyMEhERzQvWTU1NDVMeWoycUFJUVQ4WFd3VlBJZCtPaXFMWVU4SnRlSTd0?=
 =?utf-8?B?S25TQVNrWUlQUUdBbnAvSFd3YmRCb2dHUGF0N25HWjNKQnpNWGNHeVg5NUFk?=
 =?utf-8?B?aWlocmdOdk1aaXhwdG0rMkluWTNYZm5abUQrQW45Z3ZCVGdUUUhFK3JHdFFn?=
 =?utf-8?B?c3IydnlXQkJXcElOekhLRlFob25YL1BHUUJOYS9aNzY5VDU0blplMVFjVXpH?=
 =?utf-8?B?M0dSaW5GbkJpWUFpNzVFTXYrb1MyOW1VTHBqYVlNY243cWtCc1lWU21PNVY4?=
 =?utf-8?B?aERlV3Y0RXNZQ3BCMWFNdXhhMXlnZUxTaDYycE9wNGlCUXdBbnJTNmVudzA1?=
 =?utf-8?B?a2k4eENIdStNVmFsRHJTVWdiK3dKbUR5bzBuS3lNdVhxNCtRYjl2VkdGbEpk?=
 =?utf-8?B?amU2blFBSHo3bW1CaG9Tc0o0Z2NYaDd5MUVwSDlvSHR1dkRaT093Yzl6M2lO?=
 =?utf-8?B?clRVMndBSURzcFlPK205bnYvUnNLV3hHR2QxN0dqeE5GRk5CV08xdz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <127506E21D7FC14CB58BAFACB5716F3B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 617becd8-a2e8-4ce4-6890-08de53bf193f
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2026 22:48:56.0558
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YwAULkxlaLIa4cKvEt5Txe89NHnOOWKTFo3aJuIf1YgrZgVeVmO9rCGjJ5f3+6pAzlZxqtHuVgBNFhzKVtR9mQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF708A6BB3E
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI2LTAxLTA1IGF0IDA2OjM2ICswMDAwLCBOaWt1bmogQSBEYWRoYW5pYSB3cm90
ZToNCj4gQ3VycmVudGx5LCBkaXJ0eSBsb2dnaW5nIHJlbGllcyBvbiB3cml0ZSBwcm90ZWN0aW5n
IGd1ZXN0IG1lbW9yeSBhbmQNCj4gbWFya2luZyBkaXJ0eSBHRk5zIGR1cmluZyBzdWJzZXF1ZW50
IHdyaXRlIGZhdWx0cy4gVGhpcyBtZXRob2Qgd29ya3MgYnV0DQo+IGluY3VycyBvdmVyaGVhZCBk
dWUgdG8gYWRkaXRpb25hbCB3cml0ZSBmYXVsdHMgZm9yIGVhY2ggZGlydHkgR0ZOLg0KPiANCj4g
SW1wbGVtZW50IHN1cHBvcnQgZm9yIHRoZSBQYWdlIE1vZGlmaWNhdGlvbiBMb2dnaW5nIChQTUwp
IGZlYXR1cmUsIGENCj4gaGFyZHdhcmUtYXNzaXN0ZWQgbWV0aG9kIGZvciBlZmZpY2llbnQgZGly
dHkgbG9nZ2luZy4gUE1MIGF1dG9tYXRpY2FsbHkNCj4gbG9ncyBkaXJ0eSBHUEFbNTE6MTJdIHRv
IGEgNEsgYnVmZmVyIHdoZW4gdGhlIENQVSBzZXRzIE5QVCBELWJpdHMuIFR3byBuZXcNCj4gVk1D
QiBmaWVsZHMgYXJlIHV0aWxpemVkOiBQTUxfQUREUiBhbmQgUE1MX0lOREVYLiBUaGUgUE1MX0lO
REVYIGlzDQo+IGluaXRpYWxpemVkIHRvIDUxMSAoOCBieXRlcyBwZXIgR1BBIGVudHJ5KSwgYW5k
IHRoZSBDUFUgZGVjcmVhc2VzIHRoZQ0KPiBQTUxfSU5ERVggYWZ0ZXIgbG9nZ2luZyBlYWNoIEdQ
QS4gV2hlbiB0aGUgUE1MIGJ1ZmZlciBpcyBmdWxsLCBhDQo+IFZNRVhJVChQTUxfRlVMTCkgd2l0
aCBleGl0IGNvZGUgMHg0MDcgaXMgZ2VuZXJhdGVkLg0KPiANCj4gDQoNCkNvdWxkIHlvdSBhZGQg
c2VudGVuY2UocykgdG8gY2xhcmlmeSBQTUwgd29ya3MgZm9yIFNFViogZ3Vlc3RzIG9uIGhhcmR3
YXJlDQpsZXZlbCBpbiB0aGUgc2FtZSB3YXkgYXMgZm9yIG5vcm1hbCBTVk0gZ3Vlc3RzPw0KDQpU
aGlzIGp1c3RpZmllcyB0aGUgY29kZSBjaGFuZ2UgbGlrZSBhbHdheXMgc2V0dGluZyBjcHVfZGly
dHlfbG9nX3NpemUgZm9yDQphbGwgQU1EIFZNcyB3aGVuIFBNTCBpcyBlbmFibGVkIGluIHN2bV92
bV9pbml0KCkgKElJUkMpLiAgT3RoZXJ3aXNlIHlvdQ0KbmVlZCB0byBoYXZlIGNvZGUgdG8gbWFr
ZSBzdXJlIGl0J3MgY2xlYXJlZCBmb3IgU0VWKiBndWVzdHMuDQo=

