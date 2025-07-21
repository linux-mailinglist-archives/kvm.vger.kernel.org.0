Return-Path: <kvm+bounces-53029-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0199BB0CC9D
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 23:31:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4586F3BE750
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 21:30:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FB7B23B600;
	Mon, 21 Jul 2025 21:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U8o7UCCZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C7C02F41;
	Mon, 21 Jul 2025 21:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753133459; cv=fail; b=Ae4ZqwWdt259IdTzQQ/2CKFN6M0pg1JuXHQ9bJ6Cw1A8GfYx9yHfns/ne3kTyfnDRCZlvLIxjjEYMT9N1wxU2gQ4HPbfBg4Mgx14grGbrjxBXKpcGTgcZOp7O236sxUZIGP9qpswgZNt3FX5v2bvhZTsit+rhCxsZkcVU2zOz8w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753133459; c=relaxed/simple;
	bh=XMq04rjsyy++gak4uEpw2S/UuG13t5H/TbtWSbzhqIk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pF19R9F90FfurZRgDtonSrd63qMjQqmFWXpOxVzo1FsxNtNvBtXgodbf5wq7J6pzPLZb+qxcbJYwsz+Wh5SUP5XaU8Thms8wQLGLoIBvlYnlzK9oMhnJf3Le8UxBKYfsV9E+6tHfFWcLQYjr+uN6M4Tyet5f+FaA6lM9C3gZu/Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U8o7UCCZ; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753133458; x=1784669458;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=XMq04rjsyy++gak4uEpw2S/UuG13t5H/TbtWSbzhqIk=;
  b=U8o7UCCZWXiEunRwyDhkuv2qk1C88gYufrTLYay4IEXAZvDfcwV/z7uJ
   rFTUrmBbYKiWSQdY9bnZ4akHM/g/YLfBxbnLW5jevh67YDL0hKHZ0fohq
   mpJxvEnjK1aYkpTIrRJilToT0ntqqBa9ouevl11sOpoNsuZ40nCb0U0NK
   fKZP4azCUBs9F9HYdjEfShcRP0vZZ83wu9Mg3kEXjG6skXpiJqMgXH3Zu
   EPu3odr9mhmXIjnklnfjSo+m7aybBqUhzqnsCQuK3LcQqxN6Y9jxp5mls
   f+K+N5HpR69AUWz+1Y0UaZqn6Ej3tv8CSNd2hHteVfALO/CVHYIcUx+/9
   g==;
X-CSE-ConnectionGUID: HNTH5JqsSLShv33sIcGwpg==
X-CSE-MsgGUID: bCJFbmm9TXeikkF+FmiSeA==
X-IronPort-AV: E=McAfee;i="6800,10657,11499"; a="65629900"
X-IronPort-AV: E=Sophos;i="6.16,330,1744095600"; 
   d="scan'208";a="65629900"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2025 14:30:57 -0700
X-CSE-ConnectionGUID: 9j+XwrVdRiOiunR7spV+8A==
X-CSE-MsgGUID: XBMLg+NmQgaMyPG8cqzmaw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,330,1744095600"; 
   d="scan'208";a="159279936"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2025 14:30:57 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 21 Jul 2025 14:30:56 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Mon, 21 Jul 2025 14:30:56 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (40.107.212.52)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 21 Jul 2025 14:30:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LjFFzS3PR9qTkoWVaWfMkMSZOhucqWIEfQ0d63MTXwNq6yFJVdtmlirNAjMhuVCHU3n3SGZ+ZVA1rx2e7PvkfxIXIiCA+pvFZV8nYj0ZGoKnn0ug39Gi0dBM5YMGl2jQX03X2rpy3B7MMuX3i7T/ijulz3Bu0n61LBA76rzu+b/i84m0TgCa+IrQL35AlqS95Ah9er+zOmOT8k72gt+mHBigYAZ+Eyaji7PNpXG5acKuKwO2dhsMNYrof8kbMJsodPqx4q+MJXoXg0XiuTEAn1XzW89xpYT6++MPCAr4gufyxY3AT+mStf2RMXYWafpmLbRd9JhU77nxVpbDLZdw9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XMq04rjsyy++gak4uEpw2S/UuG13t5H/TbtWSbzhqIk=;
 b=y7Ye9r3Jb4pFfAU2rJtjTs20mY8rvJ15DIXNoWRcjLeVYYDpShc+v4nS+OfuPWsXivsUBKWoRiCRaTxKTXOFXXZqqm1Fbed1wxszO/cKZGmnFQiizN6JbpW5lp+LA/8WsMRjkLm5cC/UGnMtoZOaYpdRvypLJUd9PBPkGJpnqnxgjPcywv/ZDUtkPKSeisUS+gE892v+4kIXQZYoo1PZQPHmjhFfZwH3jTpcatl6Zvi901RXXj+SAXiktxZ/b56++xYuRnTaPfCJ/2K8dEPQPA4PPouMKeP+CvsvxhOMPHV//1W+j+6Yg+UcKrcSAuENRP3tW1i2KV+X3PqDahDLLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by IA0PR11MB7308.namprd11.prod.outlook.com (2603:10b6:208:436::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Mon, 21 Jul
 2025 21:30:53 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%4]) with mapi id 15.20.8943.029; Mon, 21 Jul 2025
 21:30:53 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "peterz@infradead.org" <peterz@infradead.org>, "Hansen,
 Dave" <dave.hansen@intel.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>
CC: "ashish.kalra@amd.com" <ashish.kalra@amd.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"x86@kernel.org" <x86@kernel.org>, "kas@kernel.org" <kas@kernel.org>, "Gao,
 Chao" <chao.gao@intel.com>, "Chatre, Reinette" <reinette.chatre@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Williams, Dan
 J" <dan.j.williams@intel.com>, "sagis@google.com" <sagis@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "dwmw@amazon.co.uk" <dwmw@amazon.co.uk>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>
Subject: Re: [PATCH v4 0/7] TDX host: kexec/kdump support
Thread-Topic: [PATCH v4 0/7] TDX host: kexec/kdump support
Thread-Index: AQHb92MJBuxsDpN9PEeyjEaZ/MCJarQ8km6AgAAce4CAAG/GAA==
Date: Mon, 21 Jul 2025 21:30:53 +0000
Message-ID: <66a71a55117b64cad61a9c9206f8142dca03e18b.camel@intel.com>
References: <cover.1752730040.git.kai.huang@intel.com>
	 <f999349e-accb-dcd6-75f4-eb36e0dda79f@amd.com>
	 <8374a887-9bde-c7c0-ace2-0afe22f1f616@amd.com>
In-Reply-To: <8374a887-9bde-c7c0-ace2-0afe22f1f616@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|IA0PR11MB7308:EE_
x-ms-office365-filtering-correlation-id: 6110b61f-a36e-4c94-3ad7-08ddc89ddf59
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Q0puNjhRR01vUlBTNDVTeVAwRXpXazFXczQzeXdKSlF5VUpIaU5XZExVL25Z?=
 =?utf-8?B?aDJuWU8xOUhVZjhGanB1TkxyREQyQUlyYUFLRDVqVVlrTW9rVDlYazVXZ0hq?=
 =?utf-8?B?L1JkRXpXbTQ0eXRjQmRoa3NYMGZlWVFLbTBUZGdkSWV6Ukk2ZUNPRVBTbThs?=
 =?utf-8?B?ZDFKSHBrcXNNbGEwM1FYNVIxUlprSDhvWmU1emVKY3pwbDBCY2MrcGhSNHNj?=
 =?utf-8?B?dzFySGdSaEtXOGxtTTAzQ0s4M1FTUGJpTFNhVkZYN0t1ZEtmOTQyNDk2bTJK?=
 =?utf-8?B?YkUwQVgvcW9HOHRRR1lqaUpBNTFnQXFTWktkaW50c1d5U3M2bk13RUplRUxZ?=
 =?utf-8?B?VDJVQ2ZnaHpwUEpINHg5ZkpCTE5OV0w4UG5iMFc1MVhSTFBYR25HNm1tenZD?=
 =?utf-8?B?ZEs4LzZWUzhmbFhIM2JJWHdGbXVlTmMrYUhNem0yRWpZaE41MGZFQVU5Q05X?=
 =?utf-8?B?S3pvc1JyTUxnSzZZbHVJQ0E3T2t5Z2RZcFZmbWJGZWFmNmNzMTd4dTFDT1pr?=
 =?utf-8?B?RjNqZ1k4NVdKVlBidnF3eGI2bDBOZzJ5OTk0Q0dOOWFLZ3dJUDVnZzkzbkpy?=
 =?utf-8?B?SUZVUzdQeW90K0dBNzBEUGVPUGQ1cndXRzhyUXp2Q1dBRXN6dFYwVlE4ZEFQ?=
 =?utf-8?B?cnRzN0Z6OHFhVlpzOVp5MXkxK24zLzlVa3owWnVUWEVaOGVldFF6cEw1emdp?=
 =?utf-8?B?YlRrM0NQQnMwRGcvcjY5c0ovVXNCMUpDc1N2dTlmZEZ0YXhpRG5VTTV1K3kv?=
 =?utf-8?B?L2VHSUpPTWkyOXI1czhuLzJRK090b01qUEVkRXBRdDNRc3Ric1dSNll6Z1k0?=
 =?utf-8?B?cHU1Q1lzcmlybkcwQVRrWDZqUWUxMG1mZXUwL2VJYzZNTlE1dUI0TVJRejRt?=
 =?utf-8?B?c0dCa1o0TitLbVhFZW1TVzQwTjd4TE1SU0JjVWJ3MlAwckhJY2dlR0xSbmVa?=
 =?utf-8?B?ZGNVanFaaW1VbC9ESlhKckhCQjRUa3lCY3krZ2VwYjhXeFdPSys0U1FnbzdX?=
 =?utf-8?B?YVJkQ1RMOVcrTGV4bCthdlBjc0xkaWhNb3BncnowNjU3YTl2ZldwQ1FzcnV2?=
 =?utf-8?B?aUVIVWtTdmV4aUhTazd2K2x1ZVl4QzYrSWRaaGFxQjFYdll6cTU2YUdWOGIz?=
 =?utf-8?B?MjhRWlJZNjZvWi9FTk5PYXliWVEzQzVuZTd5bE1za1RYSDJlYkFoOU5MNURa?=
 =?utf-8?B?elpuOWN4RVJSdnNMWTJWTFFabkNuZkdCTkhzNEpUZlNHWDlvYkZ4MmgrZ0hz?=
 =?utf-8?B?N1VrQjJ3MjlwdXYydVloamV2QTI3TDZzUVlRa2lNUThMVnlTcVI3MkNJNVJS?=
 =?utf-8?B?YnVDU3BjYmJJNkNSQ3VVbndaa1Z5dFlKUEszNkNFRGxvWHlwRzlBWE4rYmZX?=
 =?utf-8?B?a2txZVM3OS8wbExhcDNZRmYwODBiaHhZajREM3A2Ynk4ejAwZFFhQjlZSFpN?=
 =?utf-8?B?cGxrR0VmaUx6a2ZET0E0eWlOVG1qWExUcTV2N2JPMUNVM2s5emsvbE5SN0Ix?=
 =?utf-8?B?ekhWKzlNYmQyVktRelBYSHZLK0I2NWxuQ3FxUWl3emg4NW1wM0NsVE45Ly94?=
 =?utf-8?B?eWhEY1ZRUGlxV05tZVczeWQvZUttNEIrMjVZSndkM05DRkJMdUQwUHVqWWVk?=
 =?utf-8?B?dTZUSXU3b09lK1l6Uzd1OCs2K1QyR2E5MUNDN05PZDlINmVBYTJLWkluR0RO?=
 =?utf-8?B?cTFNRGtqRVpMNkxnTDdJaFFsajRqK0xOR1Z4eTJDRS9SKzR3TTRJSUxYU3FS?=
 =?utf-8?B?OWNmTnU5VXhyVVMyZ2JySjRsMlQ4YUpaK2sxRDM5cWhIeGd2dnNJQ083YjV4?=
 =?utf-8?B?SHp0eHhLc0JpbkNadFpERmxsMHVSOWcrbVl2L3FYak9ha1FiNnNpZUhxWXBI?=
 =?utf-8?B?aDlHQTR3ZEFkcHhpZHdWMnRBVWNLbTFZR2x2WWw3NnVjSmhHb0t6a0VwRThy?=
 =?utf-8?B?UEEyRytSRUFEenNDQ1N5a1FIVXhtV3lPbEwyRGZxTzJFeSsvejZZcDZreUlD?=
 =?utf-8?Q?d4vwTeEoXboFvUa07KTGfLOIGjO8eM=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TCtyVU5EZ2RLTmdaelgrcXcwNkxUbzBCaFZyL3o5S0l0eUt0VWU4NXhKb2Np?=
 =?utf-8?B?RlU4NnQ3d2lSSnU0NUZwVzVnVW5lMWpoRDFlVlY0QWdqeGNNSUlRSVhrU3Y1?=
 =?utf-8?B?MEZIQnlnVS92T0c5WXFUWSt2RzcyOCs2UmNsVS9lV2ZhRzB4SUxMTStwZlha?=
 =?utf-8?B?bnVaWG9nZmZBaDZpMnRLdndDZHBhYWc2SjBJdXRHa0g2Umd0cnNpeDRwUWND?=
 =?utf-8?B?dG4yQ1E5VmJieS9YcUx1aG1UQWZyQ2FlTE9nMisyemZFZU1kTm9VcFh0ZWpU?=
 =?utf-8?B?MnB1RmdjaHZYSDN6Z3FvdmFNN2F1OUkrZktqZzdZUlZld2FTNzNvaWxJeFM5?=
 =?utf-8?B?L0trVGNoWGtwSUFGTXJ0R2hvSjFPbktVUHNJQjBGN0ttOHlWV21GbmZOT0h1?=
 =?utf-8?B?bzhPaEtwNzVseXRNT1VHSVdNMk1zNmJYN3hiK0xDQnBjN3FzUkp0RWFSbC9W?=
 =?utf-8?B?SUtsMXBZZWdEQXhUSmxlNEQ4VzVIdStWTnNnbzcxOUdHNmhXKy9ySFQranI4?=
 =?utf-8?B?NjVIV1o0Z3pWeC96NmJrRytqWHdXRitDQUJYRnVzVzcrRGhGS0Z0SUpGd1kr?=
 =?utf-8?B?QVJnSmFGbHpBZjJkOWZRbHdMQ09FLzI2NTllbGF1WVJNN3V4eXk3NTlZZGlp?=
 =?utf-8?B?NEpPcGlNU3poR1VLWjB4UmVPV2I5eFlDTnRpUTBHOGtrbFJoc2NYQUR4czFG?=
 =?utf-8?B?dVRJUkUvR1pDM01lUTRlNUN6QzM0aTVOSVcxb29iUi9Ka1FrZEdZU0VtRlFM?=
 =?utf-8?B?UzFqeEJMK3V1VXM5MnFtMk9ZWVEzeWRBRVFOQWxVdUN5bHdmbi9pL0pCWVl2?=
 =?utf-8?B?WlB2clkwODlQNUV4RzVxK3ZmSkM2ODZjbnJucXN0andySFFyVCt2Ni9DUUF3?=
 =?utf-8?B?Yi9vWjFUMHRNL0VxekJnQys5bUJUb2dWMTk3ZGczaWZlTjQwcWJVaEtYZ2VT?=
 =?utf-8?B?dU0rRnlRSjNPVVRCTXdqYXQ0aWd4ZGNPaUdORTBvWFdxRzBnaHpuM0s4QWor?=
 =?utf-8?B?UDRjTDZMVGpsYTc1VDd0UFBGblFlRTd0Y05NeGpnK3JsemdtSkkzRU4rN1I5?=
 =?utf-8?B?QzFaQ1RPckd4dExDNXNRbElEYW1sTnV6R0VyenZ6eDdnbzZMMEZmTjJuQVZu?=
 =?utf-8?B?OWlZRmtiZVp0QVZZWWpvRVNId2x0Uy93Y2hRU1huYnU0Nnp4a3J2bWYrWUFL?=
 =?utf-8?B?bW1RRmV0dnJRbVRTakp2QlJvZXU2YzVwY3JKd01YRGRmRjM2bEdLMzhFK24w?=
 =?utf-8?B?TFRiUFZ0MHFDazAzaWExb1RRSUxXVFhPYmNXL1pMUlZ3aDQvcVIwVmhPbzE0?=
 =?utf-8?B?V3g1VVphbmFIWDNRNUN6UGk5TWhmZGJMVVVPcmROVldyYXB4RHllRzZNTjNP?=
 =?utf-8?B?bzJoeTY3eGN2cEltbEN3T2tZRml5SXMxcks2VnRyazlmV3hGeFVzMllHbU9I?=
 =?utf-8?B?Z0Jibkw5ajAzZVBTWTVTSDVscDBPTmFxek81ZE1zbEozVEtEdXFqSERNdk0z?=
 =?utf-8?B?UkY3aDRjRjMvWWdEWEc1VmJwanhXaXR5VFpKZ0UxQ2cxYXd3K29qL0FmZmlZ?=
 =?utf-8?B?TXo4R1Zua3FvWE1qWWRmelVxZS9VTEkyWHZTSENMOVhLMjM1QVlCMEtJMitX?=
 =?utf-8?B?YVdtQUpyRm05cFc0bEtiYW5XZkpoVXNMTEhvbzJQQWFYbTJBWit3VnBRUnZC?=
 =?utf-8?B?MmduZ3Z6VjdxUFRXc0w2MFdlWm9aZG5mUVh4bUo5dmkxZGFoUGZUY0R1bnVE?=
 =?utf-8?B?YzlLVjV2a2Z4L2h5aFhHVi9OU2dPeFc4ZHdUU0tQSmc2TTNIa1NGeWlYbXJN?=
 =?utf-8?B?QkhiRUl2RUV0UlphUDlINVkvZis4bzFKZ0YrRVM0T0tuVjFWcEdrVzhDbFhX?=
 =?utf-8?B?ZWF2TTJ3dkEyR2NxbkJ5emVpL24xenR1enRrZTNKZ2pWZlMwajJLRkxGaHp5?=
 =?utf-8?B?eXFHY04vQWxKdUtNbUY5U0ZvZ3ZQTzI4NFFPY3ZFd1g1dkJNRFhjN1NtRzRN?=
 =?utf-8?B?Z2NHczJZQmcvRUZtbTlxeTk3REpLZGgzcVBzZXJueWhyckVpeEpUbFNpUi9U?=
 =?utf-8?B?bzQyWHNtSVZTNmtZdlRpS2ZRMjdvRXpKN2JadnR1UUtvNE9iY1E1cE1mdnJs?=
 =?utf-8?Q?xliWIHtfa06ICGEnI7LkAa+qR?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <62B9C95E31C1AC488ED728BAEC99FE52@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6110b61f-a36e-4c94-3ad7-08ddc89ddf59
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jul 2025 21:30:53.8505
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /QJuDspz54rxuI9gsv73REuMJKajstr9Z4aDWAWbW3zRkCLKNxKZaTwVtcqQrdX2J7v3zyyxPOSsDU9WhFj1kQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7308
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA3LTIxIGF0IDA5OjUwIC0wNTAwLCBUb20gTGVuZGFja3kgd3JvdGU6DQo+
IE9uIDcvMjEvMjUgMDg6MDgsIFRvbSBMZW5kYWNreSB3cm90ZToNCj4gPiBPbiA3LzE3LzI1IDE2
OjQ2LCBLYWkgSHVhbmcgd3JvdGU6DQo+ID4gPiBUaGlzIHNlcmllcyBpcyB0aGUgbGF0ZXN0IGF0
dGVtcHQgdG8gc3VwcG9ydCBrZXhlYyBvbiBURFggaG9zdCBmb2xsb3dpbmcNCj4gPiA+IERhdmUn
cyBzdWdnZXN0aW9uIHRvIHVzZSBhIHBlcmNwdSBib29sZWFuIHRvIGNvbnRyb2wgV0JJTlZEIGR1
cmluZw0KPiA+ID4ga2V4ZWMuDQo+ID4gPiANCj4gPiA+IEhpIEJvcmlzL1RvbSwNCj4gPiA+IA0K
PiA+ID4gQXMgcmVxdWVzdGVkLCBJIGFkZGVkIHRoZSBmaXJzdCBwYXRjaCB0byBjbGVhbnVwIHRo
ZSBsYXN0IHR3byAndW5zaWduZWQNCj4gPiA+IGludCcgcGFyYW1ldGVycyBvZiB0aGUgcmVsb2Nh
dGVfa2VybmVsKCkgaW50byBvbmUgJ3Vuc2lnbmVkIGludCcgYW5kIHBhc3MNCj4gPiA+IGZsYWdz
IGluc3RlYWQuwqAgVGhlIHBhdGNoIDIgKHBhdGNoIDEgaW4gdjMpIGFsc28gZ2V0cyB1cGRhdGVk
IGJhc2VkIG9uDQo+ID4gPiB0aGF0LsKgIFdvdWxkIHlvdSBoZWxwIHRvIHJldmlldz/CoCBUaGFu
a3MuDQo+ID4gPiANCj4gPiA+IEkgdGVzdGVkIHRoYXQgYm90aCBub3JtYWwga2V4ZWMgYW5kIHBy
ZXNlcnZlX2NvbnRleHQga2V4ZWMgd29ya3MgKHVzaW5nDQo+ID4gPiB0aGUgdG9vbHMvdGVzdGlu
Zy9zZWxmdGVzdHMva2V4ZWMvdGVzdF9rZXhlY19qdW1wLnNoKS7CoCBCdXQgSSBkb24ndCBoYXZl
DQo+ID4gPiBTTUUgY2FwYWJsZSBtYWNoaW5lIHRvIHRlc3QuDQo+ID4gPiANCj4gPiA+IEhpIFRv
bSwgSSBhZGRlZCB5b3VyIFJldmlld2VkLWJ5IGFuZCBUZXN0ZWQtYnkgaW4gdGhlIHBhdGNoIDIg
YW55d2F5DQo+ID4gPiBzaW5jZSBJIGJlbGlldmUgdGhlIGNoYW5nZSBpcyB0cml2aWFsIGFuZCBz
dHJhaWdodGZvcndhcmQpLsKgIEJ1dCBkdWUgdG8NCj4gPiA+IHRoZSBjbGVhbnVwIHBhdGNoLCBJ
IGFwcHJlY2lhdGUgaWYgeW91IGNhbiBoZWxwIHRvIHRlc3QgdGhlIGZpcnN0IHR3bw0KPiA+ID4g
cGF0Y2hlcyBhZ2Fpbi7CoCBUaGFua3MgYSBsb3QhDQo+ID4gDQo+ID4gRXZlcnl0aGluZyBpcyB3
b3JraW5nLCBUaGFua3MhDQo+IA0KPiBTZWUgbXkgY29tbWVudHMgaW4gcGF0Y2ggIzEuIEkgZGlk
bid0IHRlc3Qgd2l0aCBjb250ZXh0IHByZXNlcnZhdGlvbiwgc28NCj4gdGhhdCBiaXQgd2FzIG5l
dmVyIHNldC4gSWYgaXQgd2FzLCBJIHRoaW5rIHRoaW5ncyB3b3VsZCBoYXZlIGZhaWxlZC4NCg0K
SSBhY3R1YWxseSB0ZXN0ZWQgdGhlIHRlc3Rfa2V4ZWNfanVtcC5zaCBpbiBrc2VsZnRlc3QgYXMg
bWVudGlvbmVkIGFib3ZlDQppbiBhIFZNLiAgSSBnb3QgIiMga2V4ZWNfanVtcCBzdWNjZWVkZWQg
W1BBU1NdIiBzbyBJIHRoaW5rIGl0IHdvcmtlZCA6LSkgDQpCdXQgdW5mb3J0dW5hdGVseSBJIGRv
bid0IGtub3cgaG93IHRvIHRlc3QgcHJlc2VydmVfY29udGV4dCBrZXhlYyBpbiBhbnkNCm90aGVy
IHdheS4NCg==

