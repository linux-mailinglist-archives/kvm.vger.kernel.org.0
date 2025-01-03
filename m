Return-Path: <kvm+bounces-34514-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F3F0A00274
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2025 02:37:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3BC223A3B22
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2025 01:36:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 937F414F9F4;
	Fri,  3 Jan 2025 01:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MBtOhYge"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4F2311CA0;
	Fri,  3 Jan 2025 01:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735868212; cv=fail; b=i/z/0b173Pk6J7jGqptpODfxk0CKM7TVry/p9Xvrsrt06my+hG2cmJpsGIBlFZLAKEmIxazViLJPq3/utxB893MOlqP/s398MjmXvY6/msejShinauXY+SoXlzmS9k3ogLmWusSMNzRw4GqzKnGhbVr4rRIcAQBgEApzu5OJ70s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735868212; c=relaxed/simple;
	bh=XFJm7YXxF72XWpvU1zdzP00Mnk90v6TpYiA0Bl1aE+A=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZCcFRbkE5ahiBzZRv8WevOHzL/ibdHhG/ySZsy02x6qHbPIMvWnMBULTOHAoweergR2bj7SF6ZhDK2DzglUAAcDnc8+ivpgjVVPTU6RwOYw0zs6jecbIXTyAdJSrt9rq6pCaB6tsbJiM+5FxiSY8n6gHD3aW6Cwg2yMxVH1F9rQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MBtOhYge; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1735868211; x=1767404211;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=XFJm7YXxF72XWpvU1zdzP00Mnk90v6TpYiA0Bl1aE+A=;
  b=MBtOhYgemu4mPKPQJF0oz5flp+wuFVD8r+uE7ZMBqExvHVTdIn2B8T+8
   rmxM/7lJ+VStqDqaP+2qah9QDLu+2Lao2XK5/qCm7cKOd+GkY6CWT5ppf
   3IX23tXHY5PhUuqf4vqz0lya+qXCQR2Xn8Ya5uqzs4zxKZ7NB8fkSdGV5
   6db4tcWAdWbYgvfuhpXu96WuG4UwJ75bBqxhIe00wP837ReFlxl6zI1SS
   rA/IPJxy/Mv/nIkLEl9NICnkeRXMVHyUThiAMXBpt+3BHRIg/e9L6aEBb
   +DeabXEtiqyuYOtmDGcCX5XNMw8eLaVA4tMMqsc2RM2znu0by9BeQcWCP
   w==;
X-CSE-ConnectionGUID: n+dzZW/8QpiQKIB01IWs5Q==
X-CSE-MsgGUID: /SrDr/1VS0e4JF5FXJa5sQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11303"; a="36278765"
X-IronPort-AV: E=Sophos;i="6.12,286,1728975600"; 
   d="scan'208";a="36278765"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jan 2025 17:36:50 -0800
X-CSE-ConnectionGUID: WptPs+rsQMiOtlGQw9NkPg==
X-CSE-MsgGUID: g9DujY/PS96UH3m/JNluJQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="105700850"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 02 Jan 2025 17:36:49 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Thu, 2 Jan 2025 17:36:48 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Thu, 2 Jan 2025 17:36:48 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 2 Jan 2025 17:36:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kY9sGO6eI56JJtdg/7G0ssdpiVd5191n7zuS3rZHRBzWvJcl4kWziPeepCBEUONj7S3CEbt3EjJxLOrIlIvEOJaeOG/1iKc6eLnzROCCqOtdzKUiEI7UzIwOWYBH0ZygZcGneebZSjtIOyiMMRo57QxSDPu+FImVKItFaN46wokfVdsA4SxvNMyul9UOH2WTehD/pAOe4bEaLJa+FROxaUMq0tR13ieMwLAo2XTQpCQ73krNCmoFo0bx09ORDsikbaC8ZEtCdW4tEGOsZEnyGtneXryph+6GOYusH8lAWgDqT74u6QxnVptkxl+tlnFuLKmt2klespRQovM/1S+oCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XFJm7YXxF72XWpvU1zdzP00Mnk90v6TpYiA0Bl1aE+A=;
 b=j7OeLSNnJzbL8FMPyqwOGS9TQpRVmcH+NPKg5Gy6isKdiwfuSpr0OghTEjBeXlAMILkswE9FbhFXZH7H8vgMmktQb2Iy8+M9EpWnhGtMXvy+KKa1+2/9mG7xNVRaVU0fEL8dCo9mVYYpwe8tQpOgX2svy4PwiO+YjUTrjVwK6dg9AA/2UoHqMiZ9aywb1i/dbLiyfW3E3vvoMQmPQuG+S/EdzokVHNA8TAUeMskgFUXFSgaCGQ44UzTLPOk8J8E4Tst+CQXMR8SXtS2DbH5FGmyT+tte3eGfm6Bsi99uiwtAmhgoIMqu6aZsmtprjH6rJiABz/Qf/TurQxeKkHfj0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by BN9PR11MB5242.namprd11.prod.outlook.com (2603:10b6:408:133::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.13; Fri, 3 Jan
 2025 01:36:42 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8314.013; Fri, 3 Jan 2025
 01:36:42 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "Zhao, Yan Y" <yan.y.zhao@intel.com>, "sean.j.christopherson@intel.com"
	<sean.j.christopherson@intel.com>, "Huang, Kai" <kai.huang@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH 10/13] x86/virt/tdx: Add SEAMCALL wrappers to remove a TD
 private page
Thread-Topic: [PATCH 10/13] x86/virt/tdx: Add SEAMCALL wrappers to remove a TD
 private page
Thread-Index: AQHbXCHXAo4rKJ8NUkqbrXjJZWnavrMER5sA
Date: Fri, 3 Jan 2025 01:36:41 +0000
Message-ID: <f35eff4bf646adad3463b655382e249007a3ff7c.camel@intel.com>
References: <20250101074959.412696-1-pbonzini@redhat.com>
	 <20250101074959.412696-11-pbonzini@redhat.com>
In-Reply-To: <20250101074959.412696-11-pbonzini@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|BN9PR11MB5242:EE_
x-ms-office365-filtering-correlation-id: 20012385-8218-4234-7bac-08dd2b971340
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?a3JQQm05bXBmU05RY2Z2NW5TUkZtbnh5K0FoSU9MSzhNU3cveVEyY2Nka3lJ?=
 =?utf-8?B?OU1wMmNNYk5CWHcvTUpJSjVMVy90Z3M1MmpKUmZPQnpQZHN0VW4xUk5GYVh1?=
 =?utf-8?B?bkRFNWFROUdCUlZ6aEhZa1BYQjJWeEJmUnk2YnpOSDV2VTZkVCtvbldDWTZ2?=
 =?utf-8?B?Ym5oOWIwY011LzBDRDhXRjgrZ1RLVGM0VGpNbi9EVXZTN0dsNHpkV01XUXJE?=
 =?utf-8?B?c3Rjb1pZdTMxSjhVcHNQVGRYc1YxK1FpUFNJSTlKTzV2QVEyTkNzL1hwUkdD?=
 =?utf-8?B?ajFkVFlKNnQ1UXVGeG1yNEtyQUk0OUY0Q1BIT0ZKcHl2UHlhUUlNNXFVd2Zk?=
 =?utf-8?B?YWZkOGZHVnNMaDMxVUdKM3Mvb3VMakhYNlIyOEdydlhTTlQrQTJhdHE1eCtO?=
 =?utf-8?B?b1R0QVdINGZ4ajN1T05sNnpTQWszNlA1d0dBMU9VWmc4NGw3OU01YnJqbU1G?=
 =?utf-8?B?eU90SE4yTlM0YmdkendrcE5uN1JNbzJkRG1BQm9pWUxJRThZcDRFZ09vOXFY?=
 =?utf-8?B?aDFhbCtFQUhKb1JyWkZqcWJrM3FZOEdEdGxuaytHQmUrQThvR2FCSE9yT1BN?=
 =?utf-8?B?eGN6TFEwcGtsQ25GK3JBN2s5eFRSR0RNQnp5YlV6R1F3NEVqRlBKK3Aremdo?=
 =?utf-8?B?cEE0OSthK0RKY3QrYXQrUVd1RXVXb2tBZ052MkowTSs3dE1MUUlrVmRuVlZo?=
 =?utf-8?B?eWxpVmtkWS9aZXhFcnVzdnBweXRtQmZna3Z6Q0dSOWd6NzFFdUI3Y2w1UUxT?=
 =?utf-8?B?ZzJiTW80dHJ0aWgzR2xMWkkwQ09VUTg5eWltY0lFcXVrTmY3UU5tMVUvR1pN?=
 =?utf-8?B?K2o0SW93QmVuK1YzUVZ0L0xUWi9hVVhBR3hZT1VQYjlsdjRyNHhFclhuN1h2?=
 =?utf-8?B?cDlEMEdXNTZ4SzNPRHZBVE9jbXAxTzFGV0doVk5xc0xFeWgyVTFZTlM3cnZs?=
 =?utf-8?B?NlhYOThrRVpIMGNDSGpRRnJ5bDM0MUpPK2cza2E5WHZBMHJOTEZNMHdhcDdu?=
 =?utf-8?B?OGVzRXR4ditjTGh4VGgzMnNGQTM4KzZkeUt6YUlzTytrYkh0RVphdklEUjdS?=
 =?utf-8?B?U3RnYlFPYkM3RmRsd1pPQlBERWlUcnZaaXBNUGkxeThHZG1LRzJWNWF5TDUv?=
 =?utf-8?B?UEpKTmlpclV2UlE3elB1QVhFYURwbGh3VCtzbmZFaW9Nd3NTaXR0SU1uaHp5?=
 =?utf-8?B?c0VnalZqYjdCOUxibkFocU9OS2V0WWEwbmE3QVB5ZXRuTVZQbVcrZGVhYzRl?=
 =?utf-8?B?VG5KSDdGZnFnN2dmTjZ5Zkt0Y0hrd3pyNFJEbU1lK29uL3RPSkoyRk5lY3l3?=
 =?utf-8?B?em1za0JlMm8remxGa3dGSFZIeFBKT0VQUnpaRWdMekVTWlM2bUJjcXVPZlB1?=
 =?utf-8?B?UUtldGN6R0s5eTNWTnkzUHVuWVdQMUI2bVByUU5jS0h6djhDQkhrYVFDcEpQ?=
 =?utf-8?B?YXRZWmlBOTJjc2pPOFNKejVnbDlSdkxzOU5zaHh0ejloRHZod1RyVlcyMUti?=
 =?utf-8?B?V21CcUp0L3J4WC9wWDl4d0FBNldRRTY4VlpDcVhXMUVVVm5kSlN0c0Z3N3I1?=
 =?utf-8?B?NEJyckE3WmxOZk52NkZZamQvQU8yWFdybnA5VU5TdnVweUsyVmt4ZXRCUEJS?=
 =?utf-8?B?Lzd0R3ROV0RETEZ1VmZnVUkrVHNBN0dybG1mQnhpK1Brc2c3LzMwM09TZEcr?=
 =?utf-8?B?UmJoN050eDdEeDBXTEtwdjJPOFY5N09KQW9zVmJoWmVGSUhxUDB2ZTlQMXQ4?=
 =?utf-8?B?V01OMlhPdzdBT2xVbU0zS0NaVXRSMXkxU1FudTd0QnN0NmdmM0tncE1nWHox?=
 =?utf-8?B?eDdQekxHTGtmRzVzeVFvWFVCc3JlK2tWd0pMWXY2bGswMXZ0b1lWQXN4WEpD?=
 =?utf-8?B?dlU5SnpqbHpNWUdiUTZOQ3F5aDhITEhXOHRqblhVWFdVRkdhZDFLTDg0OUpY?=
 =?utf-8?Q?ekhbNMMEHTZqw3sQZVgEHlhD1rWKS9GT?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a043RFhtV2RSU2pGWlNrUkxVNnZ1QUNHK2ZXdzVudUFuRHR4UDVOWUtSWDU1?=
 =?utf-8?B?eTVYSWc4Q1NwY2wvS1ptdTJSQW01cjR2QjNjajZXY00rdEFSNExXeXZ5MHV6?=
 =?utf-8?B?RkFTSjNoQ1VKcWV0endPOWdTWGdaeUVOSllSbXAwOXk5REVGNVQ2dnJYTmMx?=
 =?utf-8?B?OTd2Y3NhdnRxU0M5dGRtS25zVTBReElWV2t2UjRxL1k5TGkrZ0dGZ2JWRENT?=
 =?utf-8?B?cUhJM0UwNzhDK1JPdS9vT1BBYWV6UEtGYkZHYmRvbHp6UWVRVEZUcXg0SmJa?=
 =?utf-8?B?U0xKMWhweERhTFg4aWRYWlU3bGM4eDh4MkQ0RlNiRmdnUllqUFcyUE9VQXNz?=
 =?utf-8?B?UDc1UzdTamUwdjhCcFJCUjhFYUhFVTdZR1dHRzBmR3AxdVljVjdwZ1ByRTA0?=
 =?utf-8?B?dThvd2dWRjhlS2tjOXBISnFkUnVwWUk3c0hMYkpSbkd6MzNYOHpEV1B4dWtw?=
 =?utf-8?B?RGVWemRuSi9UT1lpUUFKNkx1c0dYY3J0K3IvYThaUkVmRHZ2MjFuOE56b2s0?=
 =?utf-8?B?eHAxTFQvZ0pRSHRzTXU5MXBTeVdxTGxLaHF6ZDBVQjlzeFc5ZVYvTXFncGht?=
 =?utf-8?B?TTZoZVNySEp4WGgzQVpyUXBpMHVxeXJIVFBUSWhzT21RY2F2YStlTTlQSkZ2?=
 =?utf-8?B?YWpCbXRaMnJoYXA2WHNFTjAyV2s4ZXdYMitwbmhkSHV5b0g5cDBvU1BqNm9L?=
 =?utf-8?B?WGs0VGE2dWV6Qk12VUtYbm1IN3U0RXJkS3lndEkvUGpDbzdOM0JQbUc0TE0x?=
 =?utf-8?B?cUNSOFRlSUFHdHVrbWpvQnUzVUF4OEsxRTVKTzJORm9PRE0ybjJWY2FNZGFi?=
 =?utf-8?B?RUNsMWYvT2dDNGRHVkVrNnBPNm14YWpPSFJxdllEQnhHTjB6bmdDREYyMDhl?=
 =?utf-8?B?VXVtOHd2ZDA1ZGd4aWl1eTBYR3lFU25kMTBESldLR0tHdDVJdk54bzlSNUZN?=
 =?utf-8?B?T1JYS1VDeHZTSjdrTS9aNnV1dlh5OHFpWTVEeTI4MDk3bDMvck9ibEZ5bnJx?=
 =?utf-8?B?Y1FkcHhZN1lkTWJmckNWZ1VpY3pqckVMME45WTQrQXBObVQwbEtHUEV2RDg1?=
 =?utf-8?B?cHZwRE5sQlNTTVBpM3gwZzB1d3FxYlIydUJiai81cXhzRitaWTdFSlJmZEFD?=
 =?utf-8?B?ZE5FRTF5S0pJZnVOeWpJcEJ3dEJpVS93TWRtY2hEQ0pJRVdTTHZMdTQ5bXhk?=
 =?utf-8?B?MWtrREExRFZ5WGZneXdXWVVaS3J4VmhaQm9GSTR0MCtiQVJObU5MRFhWZkJr?=
 =?utf-8?B?djV5c2JXQzhpV3ozbDB3SmRSSG1NaFhQKzZvbFhHbks2cWJqaFFKcDVFNHNx?=
 =?utf-8?B?UGNGZ2YyR2VrcHdPZitHaU1GUVorM1ZiMEZaQy81dUNza1RPM3QwallvdERp?=
 =?utf-8?B?Zkk3TkMvL0RrR25KdzRXWC9TYTErTjMvWm9WYWE3VWZxOXU5MkJZZUQ2Rno4?=
 =?utf-8?B?RzJXNHE2SFFuRHhMSmpyUmwvZ2g5dkxwRFZ2WjZrZzZaT3Y4SWNZS09yVGZH?=
 =?utf-8?B?a1o1RmdRM1BIYTBoaUZpcDZDeFhDVW43c2l5TzUvN3dsekNOejdLbjczYTZv?=
 =?utf-8?B?OXE3aDF3ZDltRDkwd0Z6a2xKNTRRckl3N0IxcWp2cjgyaG9GeUQrcW5qeVZ6?=
 =?utf-8?B?LzN5UE8xaFBQa0p0ckQ5bXRXTXlpcXFHaUxiWXRJVXZkYUtmcnA5aGlFTHBh?=
 =?utf-8?B?ekRLNU8xVW50R2VQNUxZRTJyYVZFRTE4Q2VRMUMxYTAzNUxTYi84M0d5M0JF?=
 =?utf-8?B?Qm9FQnBwVXRRZDJoNE5LZDh5WHdjSTc3Y2JWZDhLZzl1dnZzOTlxZXppU0hG?=
 =?utf-8?B?ZzYxVTNDSzFvY3R3WG9LcmIvMEkvaGd5Y1htREc2bGgxQm0yNVFvWmdHWldq?=
 =?utf-8?B?Y3pvcHg2b21XcGVoNXRCUDNxZWdqdVdwRWtBa0ZjU3ZJdjl6Z2ZuSHlqZGNQ?=
 =?utf-8?B?NUFZR3RYYmFtbTdsNUtjbXdrb2ZacWNqbnh2d2NON0JzN1pjWURJZTlmVUlu?=
 =?utf-8?B?OGRyTUtFQlYvUVBSUWJYNFlZZ08zNDJ2Q0JGOWZtUVE1cExzemRSSjg0Y09r?=
 =?utf-8?B?SFRCRUl0Rk5VbVhST2ZmMFNMUkZZOUt6dTJZRjM5aUtzTzMvVnZzcEpJRzZU?=
 =?utf-8?B?S2dVemFtS1Z2VTR3N1JndTZpeFRwNEcyZldteURScWZnUEpzNys0TlpZQk0w?=
 =?utf-8?B?Rmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B68BB1EE2DD7D445B62E08C25AF6F26E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20012385-8218-4234-7bac-08dd2b971340
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jan 2025 01:36:41.9277
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HqOT/DcqLVrDaHvZno2qUvn9YyiwaAmcXN81tmFMFR4a77KqObLmJoQOth0OORye0mQlwP//oxGMsjCXQkRHMeX6uTjDYB3jXG69ShWPvpg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5242
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTAxLTAxIGF0IDAyOjQ5IC0wNTAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiBGcm9tOiBJc2FrdSBZYW1haGF0YSA8aXNha3UueWFtYWhhdGFAaW50ZWwuY29tPg0KPiANCj4g
VERYIGFyY2hpdGVjdHVyZSBpbnRyb2R1Y2VzIHRoZSBjb25jZXB0IG9mIHByaXZhdGUgR1BBIHZz
IHNoYXJlZCBHUEEsDQo+IGRlcGVuZGluZyBvbiB0aGUgR1BBLlNIQVJFRCBiaXQuIFRoZSBURFgg
bW9kdWxlIG1haW50YWlucyBhIHNpbmdsZSBTZWN1cmUNCj4gRVBUIChTLUVQVCBvciBTRVBUKSB0
cmVlIHBlciBURCB0byB0cmFuc2xhdGUgVEQncyBwcml2YXRlIG1lbW9yeSBhY2Nlc3NlZA0KPiB1
c2luZyBhIHByaXZhdGUgR1BBLiBXcmFwIHRoZSBTRUFNQ0FMTCBUREguTUVNLlBBR0UuUkVNT1ZF
IHdpdGgNCj4gdGRoX21lbV9wYWdlX3JlbW92ZSgpIGFuZCBUREhfUEhZTUVNX1BBR0VfV0JJTlZE
IHdpdGgNCj4gdGRoX3BoeW1lbV9wYWdlX3diaW52ZF9oa2lkKCkgdG8gdW5tYXAgYSBURCBwcml2
YXRlIHBhZ2UgZnJvbSB0aGUgU0VQVCwNCj4gcmVtb3ZlIHRoZSBURCBwcml2YXRlIHBhZ2UgZnJv
bSB0aGUgVERYIG1vZHVsZSBhbmQgZmx1c2ggY2FjaGUgbGluZXMgdG8NCj4gbWVtb3J5IGFmdGVy
IHJlbW92YWwgb2YgdGhlIHByaXZhdGUgcGFnZS4NCj4gDQo+IENhbGxlcnMgc2hvdWxkIHNwZWNp
ZnkgIkdQQSIgYW5kICJsZXZlbCIgd2hlbiBjYWxsaW5nIHRkaF9tZW1fcGFnZV9yZW1vdmUoKQ0K
PiB0byBpbmRpY2F0ZSB0byB0aGUgVERYIG1vZHVsZSB3aGljaCBURCBwcml2YXRlIHBhZ2UgdG8g
dW5tYXAgYW5kIHJlbW92ZS4NCj4gDQo+IFRESC5NRU0uUEFHRS5SRU1PVkUgbWF5IGZhaWwsIGFu
ZCB0aGUgY2FsbGVyIG9mIHRkaF9tZW1fcGFnZV9yZW1vdmUoKSBjYW4NCj4gY2hlY2sgdGhlIGZ1
bmN0aW9uIHJldHVybiB2YWx1ZSBhbmQgcmV0cmlldmUgZXh0ZW5kZWQgZXJyb3IgaW5mb3JtYXRp
b24NCj4gZnJvbSB0aGUgZnVuY3Rpb24gb3V0cHV0IHBhcmFtZXRlcnMuIEZvbGxvdyB0aGUgVExC
IHRyYWNraW5nIHByb3RvY29sDQo+IGJlZm9yZSBjYWxsaW5nIHRkaF9tZW1fcGFnZV9yZW1vdmUo
KSB0byByZW1vdmUgYSBURCBwcml2YXRlIHBhZ2UgdG8gYXZvaWQNCj4gU0VBTUNBTEwgZmFpbHVy
ZS4NCj4gDQo+IEFmdGVyIHJlbW92aW5nIGEgVEQncyBwcml2YXRlIHBhZ2UsIHRoZSBURFggbW9k
dWxlIGRvZXMgbm90IHdyaXRlIGJhY2sgYW5kDQo+IGludmFsaWRhdGUgY2FjaGUgbGluZXMgYXNz
b2NpYXRlZCB3aXRoIHRoZSBwYWdlIGFuZCB0aGUgcGFnZSdzIGtleUlEIChpLmUuLA0KPiB0aGUg
VEQncyBndWVzdCBrZXlJRCkuIFRoZXJlZm9yZSwgcHJvdmlkZSB0ZGhfcGh5bWVtX3BhZ2Vfd2Jp
bnZkX2hraWQoKSB0bw0KPiBhbGxvdyB0aGUgY2FsbGVyIHRvIHBhc3MgaW4gdGhlIFREJ3MgZ3Vl
c3Qga2V5SUQgYW5kIGludm9rZQ0KPiBUREhfUEhZTUVNX1BBR0VfV0JJTlZEIHRvIHBlcmZvcm0g
dGhpcyBhY3Rpb24uDQo+IA0KPiBCZWZvcmUgcmV1c2luZyB0aGUgcGFnZSwgdGhlIGhvc3Qga2Vy
bmVsIG5lZWRzIHRvIG1hcCB0aGUgcGFnZSB3aXRoIGtleUlEIDANCj4gYW5kIGludm9rZSBtb3Zk
aXI2NGIoKSB0byBjb252ZXJ0IHRoZSBURCBwcml2YXRlIHBhZ2UgdG8gYSBub3JtYWwgc2hhcmVk
DQo+IHBhZ2UuDQo+IA0KPiBUREguTUVNLlBBR0UuUkVNT1ZFIGFuZCBUREhfUEhZTUVNX1BBR0Vf
V0JJTlZEIG1heSBtZWV0IGNvbnRlbnRpb25zIGluc2lkZQ0KPiB0aGUgVERYIG1vZHVsZSBmb3Ig
VERYJ3MgaW50ZXJuYWwgcmVzb3VyY2VzLiBUbyBhdm9pZCBzdGF5aW5nIGluIFNFQU0gbW9kZQ0K
PiBmb3IgdG9vIGxvbmcsIFREWCBtb2R1bGUgd2lsbCByZXR1cm4gYSBCVVNZIGVycm9yIGNvZGUg
dG8gdGhlIGtlcm5lbA0KPiBpbnN0ZWFkIG9mIHNwaW5uaW5nIG9uIHRoZSBsb2Nrcy4gVGhlIGNh
bGxlciBtYXkgbmVlZCB0byBoYW5kbGUgdGhpcyBlcnJvcg0KPiBpbiBzcGVjaWZpYyB3YXlzIChl
LmcuLCByZXRyeSkuIFRoZSB3cmFwcGVycyByZXR1cm4gdGhlIFNFQU1DQUxMIGVycm9yIGNvZGUN
Cj4gZGlyZWN0bHkgdG8gdGhlIGNhbGxlci4gRG9uJ3QgYXR0ZW1wdCB0byBoYW5kbGUgaXQgaW4g
dGhlIGNvcmUga2VybmVsLg0KPiANCj4gW0thaTogU3dpdGNoZWQgZnJvbSBnZW5lcmljIHNlYW1j
YWxsIGV4cG9ydF0NCj4gW1lhbjogUmUtd3JvdGUgdGhlIGNoYW5nZWxvZ10NCj4gQ28tZGV2ZWxv
cGVkLWJ5OiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuLmouY2hyaXN0b3BoZXJzb25AaW50ZWwu
Y29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuLmouY2hyaXN0
b3BoZXJzb25AaW50ZWwuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBJc2FrdSBZYW1haGF0YSA8aXNh
a3UueWFtYWhhdGFAaW50ZWwuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBLYWkgSHVhbmcgPGthaS5o
dWFuZ0BpbnRlbC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IFJpY2sgRWRnZWNvbWJlIDxyaWNrLnAu
ZWRnZWNvbWJlQGludGVsLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogWWFuIFpoYW8gPHlhbi55Lnpo
YW9AaW50ZWwuY29tPg0KPiBNZXNzYWdlLUlEOiA8MjAyNDExMTIwNzM2NTguMjIxNTctMS15YW4u
eS56aGFvQGludGVsLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogUGFvbG8gQm9uemluaSA8cGJvbnpp
bmlAcmVkaGF0LmNvbT4NCj4gLS0tDQo+ICBhcmNoL3g4Ni9pbmNsdWRlL2FzbS90ZHguaCAgfCAg
MiArKw0KPiAgYXJjaC94ODYvdmlydC92bXgvdGR4L3RkeC5jIHwgMjcgKysrKysrKysrKysrKysr
KysrKysrKysrKysrDQo+ICBhcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmggfCAgMSArDQo+ICAz
IGZpbGVzIGNoYW5nZWQsIDMwIGluc2VydGlvbnMoKykNCj4gDQo+IGRpZmYgLS1naXQgYS9hcmNo
L3g4Ni9pbmNsdWRlL2FzbS90ZHguaCBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL3RkeC5oDQo+IGlu
ZGV4IGYwYjdiN2I3ZDUwNi4uNzQ5MzhmNzI1NDgxIDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9p
bmNsdWRlL2FzbS90ZHguaA0KPiArKysgYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS90ZHguaA0KPiBA
QCAtMTU3LDggKzE1NywxMCBAQCB1NjQgdGRoX3ZwX3dyKHN0cnVjdCB0ZHhfdnAgKnZwLCB1NjQg
ZmllbGQsIHU2NCBkYXRhLCB1NjQgbWFzayk7DQo+ICB1NjQgdGRoX3ZwX2luaXRfYXBpY2lkKHN0
cnVjdCB0ZHhfdnAgKnZwLCB1NjQgaW5pdGlhbF9yY3gsIHUzMiB4MmFwaWNpZCk7DQo+ICB1NjQg
dGRoX3BoeW1lbV9wYWdlX3JlY2xhaW0oc3RydWN0IHBhZ2UgKnBhZ2UsIHU2NCAqdGR4X3B0LCB1
NjQgKnRkeF9vd25lciwgdTY0ICp0ZHhfc2l6ZSk7DQo+ICB1NjQgdGRoX21lbV90cmFjayhzdHJ1
Y3QgdGR4X3RkICp0ZHIpOw0KPiArdTY0IHRkaF9tZW1fcGFnZV9yZW1vdmUoc3RydWN0IHRkeF90
ZCAqdGQsIHU2NCBncGEsIHU2NCBsZXZlbCwgdTY0ICpyY3gsIHU2NCAqcmR4KTsNCj4gIHU2NCB0
ZGhfcGh5bWVtX2NhY2hlX3diKGJvb2wgcmVzdW1lKTsNCj4gIHU2NCB0ZGhfcGh5bWVtX3BhZ2Vf
d2JpbnZkX3RkcihzdHJ1Y3QgdGR4X3RkICp0ZCk7DQo+ICt1NjQgdGRoX3BoeW1lbV9wYWdlX3di
aW52ZF9oa2lkKHU2NCBocGEsIHU2NCBoa2lkKTsNCj4gICNlbHNlDQo+ICBzdGF0aWMgaW5saW5l
IHZvaWQgdGR4X2luaXQodm9pZCkgeyB9DQo+ICBzdGF0aWMgaW5saW5lIGludCB0ZHhfY3B1X2Vu
YWJsZSh2b2lkKSB7IHJldHVybiAtRU5PREVWOyB9DQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni92
aXJ0L3ZteC90ZHgvdGR4LmMgYi9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmMNCj4gaW5kZXgg
YzdlNmYzMGQwYTE0Li5jZGU1NWU5YjMyODAgMTAwNjQ0DQo+IC0tLSBhL2FyY2gveDg2L3ZpcnQv
dm14L3RkeC90ZHguYw0KPiArKysgYi9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmMNCj4gQEAg
LTE3NjEsNiArMTc2MSwyMyBAQCB1NjQgdGRoX21lbV90cmFjayhzdHJ1Y3QgdGR4X3RkICp0ZCkN
Cj4gIH0NCj4gIEVYUE9SVF9TWU1CT0xfR1BMKHRkaF9tZW1fdHJhY2spOw0KPiAgDQo+ICt1NjQg
dGRoX21lbV9wYWdlX3JlbW92ZShzdHJ1Y3QgdGR4X3RkICp0ZCwgdTY0IGdwYSwgdTY0IGxldmVs
LCB1NjQgKnJjeCwgdTY0ICpyZHgpDQoNCmxldmVsIGNvdWxkIGJlIGFuIGludCBpbnN0ZWFkIG9m
IGEgdTY0LiBBbiBlbnVtIHdhcyBhbHNvIGRpc2N1c3NlZCwgYnV0DQpjb25zaWRlcmVkIHRvIGJl
IG5vdCBjb21wbGV0ZWx5IG5lY2Vzc2FyeS4gUHJvYmFibHkgd2UgY291bGQgZXZlbiBsb3NlIHRo
ZSBsZXZlbA0KYXJnLCBkZXBlbmRpbmcgb24gd2hhdCB3ZSB3YW50IHRvIGRvIGFib3V0IHRoZSBv
bmUgZm9yIHBhZ2UuYXVnLg0KDQo+ICt7DQo+ICsJc3RydWN0IHRkeF9tb2R1bGVfYXJncyBhcmdz
ID0gew0KPiArCQkucmN4ID0gZ3BhIHwgbGV2ZWwsDQoNCllhbiBoYWQgIj0gZ3BhIHwgKGxldmVs
ICYgMHg3KSIgaGVyZSwgdG8gbWFrZSBzdXJlIHRvIG9ubHkgYXBwbHkgYml0cyAwLTIuDQoNCj4g
KwkJLnJkeCA9IHRkeF90ZHJfcGEodGQpLA0KPiArCX07DQo+ICsJdTY0IHJldDsNCj4gKw0KPiAr
CXJldCA9IHNlYW1jYWxsX3JldChUREhfTUVNX1BBR0VfUkVNT1ZFLCAmYXJncyk7DQo+ICsNCj4g
KwkqcmN4ID0gYXJncy5yY3g7DQo+ICsJKnJkeCA9IGFyZ3MucmR4Ow0KDQpTd2l0Y2ggdG8gZXh0
ZW5kZWRfZXJyMS8yIGlmIHRoZSBvdGhlcnMgZ2V0IGNoYW5nZWQuDQoNCj4gKw0KPiArCXJldHVy
biByZXQ7DQo+ICt9DQo+ICtFWFBPUlRfU1lNQk9MX0dQTCh0ZGhfbWVtX3BhZ2VfcmVtb3ZlKTsN
Cj4gKw0KPiAgdTY0IHRkaF9waHltZW1fY2FjaGVfd2IoYm9vbCByZXN1bWUpDQo+ICB7DQo+ICAJ
c3RydWN0IHRkeF9tb2R1bGVfYXJncyBhcmdzID0gew0KPiBAQCAtMTc4MCwzICsxNzk3LDEzIEBA
IHU2NCB0ZGhfcGh5bWVtX3BhZ2Vfd2JpbnZkX3RkcihzdHJ1Y3QgdGR4X3RkICp0ZCkNCj4gIAly
ZXR1cm4gc2VhbWNhbGwoVERIX1BIWU1FTV9QQUdFX1dCSU5WRCwgJmFyZ3MpOw0KPiAgfQ0KPiAg
RVhQT1JUX1NZTUJPTF9HUEwodGRoX3BoeW1lbV9wYWdlX3diaW52ZF90ZHIpOw0KPiArDQo+ICt1
NjQgdGRoX3BoeW1lbV9wYWdlX3diaW52ZF9oa2lkKHU2NCBocGEsIHU2NCBoa2lkKQ0KPiArew0K
PiArCXN0cnVjdCB0ZHhfbW9kdWxlX2FyZ3MgYXJncyA9IHt9Ow0KPiArDQo+ICsJYXJncy5yY3gg
PSBocGEgfCAoaGtpZCA8PCBib290X2NwdV9kYXRhLng4Nl9waHlzX2JpdHMpOw0KPiArDQo+ICsJ
cmV0dXJuIHNlYW1jYWxsKFRESF9QSFlNRU1fUEFHRV9XQklOVkQsICZhcmdzKTsNCj4gK30NCj4g
K0VYUE9SVF9TWU1CT0xfR1BMKHRkaF9waHltZW1fcGFnZV93YmludmRfaGtpZCk7DQo+IGRpZmYg
LS1naXQgYS9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmggYi9hcmNoL3g4Ni92aXJ0L3ZteC90
ZHgvdGR4LmgNCj4gaW5kZXggNGIwYWQ1MzZhZmQ5Li5kNDljZGQ5YjA1NzcgMTAwNjQ0DQo+IC0t
LSBhL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguaA0KPiArKysgYi9hcmNoL3g4Ni92aXJ0L3Zt
eC90ZHgvdGR4LmgNCj4gQEAgLTMzLDYgKzMzLDcgQEANCj4gICNkZWZpbmUgVERIX1BIWU1FTV9Q
QUdFX1JETUQJCTI0DQo+ICAjZGVmaW5lIFRESF9WUF9SRAkJCTI2DQo+ICAjZGVmaW5lIFRESF9Q
SFlNRU1fUEFHRV9SRUNMQUlNCQkyOA0KPiArI2RlZmluZSBUREhfTUVNX1BBR0VfUkVNT1ZFCQky
OQ0KPiAgI2RlZmluZSBUREhfU1lTX0tFWV9DT05GSUcJCTMxDQo+ICAjZGVmaW5lIFRESF9TWVNf
SU5JVAkJCTMzDQo+ICAjZGVmaW5lIFRESF9TWVNfUkQJCQkzNA0KDQo=

