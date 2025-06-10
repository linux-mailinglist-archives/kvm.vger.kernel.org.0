Return-Path: <kvm+bounces-48812-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 38646AD3FA5
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 18:55:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DF051178E27
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 16:55:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9F31242D95;
	Tue, 10 Jun 2025 16:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BIga1+NU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E65EA20EB;
	Tue, 10 Jun 2025 16:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749574532; cv=fail; b=TbcvWFpMRjoKDwFlxyIXXz8WYkSUIxl2Da1PqYiFKcQiL7aH2eVOFmtPcTsbumqFc80lFMYA6YTn1b04vXfTtEw5MLYXZEa7cy2PylOah60SWJc7SychbVWDhmEKwNux4gGaVoNkVJ1El6qgcIwV1wYDJpE+vEiqHEOVWLElQH4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749574532; c=relaxed/simple;
	bh=D+2qmI1WNmJr1UMQxQeFxNob8/fWY14n8jET55y1zEc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=BPAvDr2wi3+mH5OzLHWTbWton6998Zoh98DxG6d3j1KTQpYzLnVuTTJkjcJl+nlpzlMm60Dd7giJoD5DjTVPHrg3hj/be7jLGbs+iqyV5VO5Syr1zjvV53MVibEeSxmBZoT/KxFrVcWA8826YSGAvSb3Y/Ff5mXFjADZHiZxOCU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BIga1+NU; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749574531; x=1781110531;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=D+2qmI1WNmJr1UMQxQeFxNob8/fWY14n8jET55y1zEc=;
  b=BIga1+NULWr0h75CfnaKJwI5dUB5j2971QPYb6Dat957Um/+a1qr7uhu
   vd/zeecXO+m4+YsuSWqtNw418Q1Fkx8E3ZDHlmkpnRh7rs+461ogVig2K
   vfkYFwU1mMHIhNUSZQ6k3+dZ7jIhuK9nhKXID6JXX5ISETiHG0a6VS4BB
   QiWAO0QQBz0otdKaZDkbzJM46cnAdwSUXf7mSU7gV5g334xCsnVXhQink
   KyK8LYZZb3vTwZjI05/41E5TZWKz4VQvLI0CgKQ55TcM0npeoybz3NpWc
   0yZm76boA5Ci4V5hy0ww4VMsO1v4Oi+ODNbHFPv3YifwcrkexxKdugoWU
   A==;
X-CSE-ConnectionGUID: Vryq5rM2QsC7yH1axAPHxg==
X-CSE-MsgGUID: f2PfiDa4RWOmEM/tpQvdGA==
X-IronPort-AV: E=McAfee;i="6800,10657,11460"; a="55490658"
X-IronPort-AV: E=Sophos;i="6.16,225,1744095600"; 
   d="scan'208";a="55490658"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 09:55:30 -0700
X-CSE-ConnectionGUID: QlNxO78xQdWs+lwj4db6gQ==
X-CSE-MsgGUID: C4V8sLiMQvitu2q3S4npUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,225,1744095600"; 
   d="scan'208";a="146873858"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 09:55:31 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 10 Jun 2025 09:55:29 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 10 Jun 2025 09:55:29 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (40.107.101.83)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Tue, 10 Jun 2025 09:55:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bJtfdjojXh0GQU+3E0nVHhstzQcLOqxaegJd3Jp8y1lP8Eu2gXPVdP09IS2WbRfsXm75VYBzUo5qtm0161d8fG5F8bVImRkbLkhotDww5BXnyjOQT1YclAK4k8A6ZU1bvNkm1SJI9EjLegiQZBaPR9vkT2ildqw4RFC8fXopXgdympaYAB7ukcQZrb6GFWJohlm+SZAPu9yVSGuegbuMNRh0nuca/STbiBIdBuPyroxKwzwBA6qtRVgnv/8nP7skYMGQ5aJp+B/TazXKBT9QpwT6o2c5b93jrO1srY51QU6iOwbAmqqp8Wmb6Q0dKFdfA2N+EPBC1CBzRSTAjBtl5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D+2qmI1WNmJr1UMQxQeFxNob8/fWY14n8jET55y1zEc=;
 b=T2douCYgEruQQN+RVdoJV3hBWnO0Gobzv3k1b8pyefqY9GiliWCmVcQbubW74ZOVgIKl7gU/RO0njZy3p66sXxX0isP9v9SYJxeehxVIGmF+cDpKp86KgleuvivosrxjiKxWN2grxxRaPESZz4iCdI8EIqmAlZorYhJhXwlFNQdzupKA9Oq/i9STZmyHLprO/8pPdrvHHbs33fKTpdt6yB8gDZbQzWtbAZGqaQRIPrw6j2gyX31zRYhrogRjOFpnS1GQbq/nA7EcqRP8RcFj2x2Bb8BmjGYD2Qwpb6fKO3FYtDd+Gwl1U4GmlVFsxYGQ29g2aczj8Y3ftZ6DWyth9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA1PR11MB8100.namprd11.prod.outlook.com (2603:10b6:208:445::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.24; Tue, 10 Jun
 2025 16:54:46 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8813.024; Tue, 10 Jun 2025
 16:54:46 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>
CC: "mikko.ylinen@linux.intel.com" <mikko.ylinen@linux.intel.com>, "Huang,
 Kai" <kai.huang@intel.com>, "Yao, Jiewen" <jiewen.yao@intel.com>, "Chatre,
 Reinette" <reinette.chatre@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"Lindgren, Tony" <tony.lindgren@intel.com>, "Shutemov, Kirill"
	<kirill.shutemov@intel.com>, "Hunter, Adrian" <adrian.hunter@intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [RFC PATCH 3/4] KVM: TDX: Exit to userspace for GetTdVmCallInfo
Thread-Topic: [RFC PATCH 3/4] KVM: TDX: Exit to userspace for GetTdVmCallInfo
Thread-Index: AQHb2a1TbQakduG6E0K+sX62VG3CXrP8HXSAgAB+0YCAAAEdAA==
Date: Tue, 10 Jun 2025 16:54:46 +0000
Message-ID: <d4285aa9adb60b774ca1491e2a0be573e6c82c07.camel@intel.com>
References: <20250610021422.1214715-1-binbin.wu@linux.intel.com>
	 <20250610021422.1214715-4-binbin.wu@linux.intel.com>
	 <ff5fd57a-9522-448c-9ab6-e0006cb6b2ee@intel.com>
	 <9421ffccdc40fb5a75921e758626354996abb8a9.camel@intel.com>
In-Reply-To: <9421ffccdc40fb5a75921e758626354996abb8a9.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA1PR11MB8100:EE_
x-ms-office365-filtering-correlation-id: e70e30f6-0c55-4c33-e99e-08dda83f8193
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?enUrcnpwYmZ3RjJSblh0S3dDMDVRczh1SG81UHlCUndDeDNKeWJUdE9iVGJE?=
 =?utf-8?B?VTU3eWZTR2JhVTVWUW1zMThTaVE2ZDMvSFZjSkdjZWM0WXF5ZkFXT2FoVlZa?=
 =?utf-8?B?WTFTeWpvZDduWmdEanJucDVia3NXTTBQMWgwOXd4bjM3RWF1K0Z6Z0ZtemZ0?=
 =?utf-8?B?WmlXZk9PRk9oU0kwNWoyalRuVm9TMVAzZXY4dUh3aXZRdmFKZGY2Y3R1eGN6?=
 =?utf-8?B?Um5PVFlieFJ6b1MxQkg3clNoNXFlWHZuMEpkWXBBK1Z5R2orMEtJRWN3aC9i?=
 =?utf-8?B?c1ZwMzU1ZXEvOFNVd2F5YXpGTmxHS3p1RXVBc0FNUWtkL3llb1Z3NzArZFB0?=
 =?utf-8?B?NE43MHRVYU9Zam9qbm1MT05YYmNSc1FrTVEwQVJPbEVmSnZMUmdZRmFSZlNY?=
 =?utf-8?B?WUdUOHZvNng2bFVIaExRemFBSmtWVTNGMjJqaGpkUVl5ZFFWSlhkOTlqWFlG?=
 =?utf-8?B?Q1hZeGxyUWxCZndwelJOc2hHZmFvU3B1RGI0YjJmUnl4R25YTnB2SUlwZzFu?=
 =?utf-8?B?ZHU2bzErMDlJN0hoOEYwSysrdkdZZmd2V0FYaFhPRXgxaDJJRzNzTEF5TzN1?=
 =?utf-8?B?b1RBeXF3UjlsYzhZTUNVbGFJOWgweTVKV3JsK3lQZ1dZS01mbFNWOHZuTk9o?=
 =?utf-8?B?TGlBODVMYURrcFlRVXlxTGtFMm5nWWpJZ3A2cnJpdHlQSkVsQndwZzlIRFE2?=
 =?utf-8?B?a2VOS2NlTUxCWjk1bVV2cE5weVhkNjQzSHZ2WlRXbzduUUtQemZTeGlsSnhn?=
 =?utf-8?B?ME1LVStRRVlIb3ZnTjFzZWlaRTladzFabE5GQTNLS2dIdlQ1eU55Qk54dGhw?=
 =?utf-8?B?RmdrRVNSMFNSTFVWVVl6YjlYZXdmS0x1K2JSV3ZLVTRpMks0U0U2T1g4UlNq?=
 =?utf-8?B?L1N6K1hBMkhqbllOUnp3OHVwRy9OVVNRc2p6VjczS1RibTl3dy9RWnUydUNQ?=
 =?utf-8?B?eFdrOXR4MDlNeVl5bjlPdDRhcHZWTnlUeE1UOVIrd0xEZEZoUytNcGI0SW0w?=
 =?utf-8?B?RGpNR3AweURFUUZsVGVXRlA2WURNMFZHZGR5em9US25BcEdDTDVKaGlKby9S?=
 =?utf-8?B?NXo3ZVVxcWVqQ0pMNjJJNE55Q2ZXVHRKR0pnSTJ6cmtTbm1PNTNFUUNqcXQx?=
 =?utf-8?B?Y3JaSFlDMm5WbjFYZysxZXlYaHJnSUQ2elRIMmFMZERyTGpTUXpWVE9hY2RY?=
 =?utf-8?B?dHJsMFo4OER3cW9UZHRFQ2hWa0Znaml6aEZkZXZYYUNUVmE5SnRoMlFwdW5W?=
 =?utf-8?B?eVVZaUNqMk5BK2hvTE8zNDVlQk15M0RvV25yaXVYM3VmR3lySkFvY0lDT3Y0?=
 =?utf-8?B?eUI1SmdIQ29UM0xoV2JQQmpCWnVWTm5OVHVsNDdZcVRQSjc3T0Vxdk1DSlRq?=
 =?utf-8?B?S3paLzlJR3ZhUnRSZWk4ckV2NVVweXV5UURVekpQNTVyVkNONkUvSTArM1V3?=
 =?utf-8?B?MWJteHJEYUJpcFJsOXZXK1pWMDlpWjZaWGtQRTM5SlYzaUNuM202TDFKMUp1?=
 =?utf-8?B?OXpLZDJHbGdXU09QVTF2dDlOWXJ3QUx6azNGKzkxQnVpWUFnb2I5bUVjVm1T?=
 =?utf-8?B?VFo4T2tVVTduRklZbng4SmVWMFBMbjZrRzlwUzJIQzJPUXVhKzBJaDNFb1FP?=
 =?utf-8?B?QlFwSk93aWhkZ0NsWWVGRHU0SVlqZkxVZTZCRmF3UldBMFU3WXhqbW5yOFhW?=
 =?utf-8?B?VS9raENpMis2SzRlQTRjdHphMGtTR0hHS25wUVFFSmp2YTlCeTJOaWViYXVz?=
 =?utf-8?B?NUxOUTgvekZMRVRCN0loNmxOUm9UUFVXYVZtSndjRkZiQ0gxWFB3V2JoQnJQ?=
 =?utf-8?B?WFB2TjNvbFp4WDZIVkZrK0Nzbm44T0ZUMnRRMXVncy9RMElidG03SDI1SkZw?=
 =?utf-8?B?S3pIMEVZQ0NEOXhRM0tGbnI5bk50blloWXdzV2tDNWU0Z1Y5a1NGMXZRblNn?=
 =?utf-8?B?K0JwY3JWZ0JBYm9nbGxrSjJzZUhES0E3VGlWMldmZTlmRzQrUVE2MktXRGJr?=
 =?utf-8?Q?jrhDikc1ylo4yvB+aZSubHI9RsZ1LA=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OW8yZjEvZHNQRXlzMVU0RE9jbXExWldQN0lDRjF2L2tjT3VXY29NVnh6UDRl?=
 =?utf-8?B?aTZlMkZvS0pBNmVuNnFsMTJvaE5uY3lGZkVnczIzY2xjTCtpTVUyTUNRWUZj?=
 =?utf-8?B?WWIyaDNMZ2lrbUg4RnJObTlEb0xhYlpTeUZVUXMxUEl5NEh3ZkY3cWJLYmNi?=
 =?utf-8?B?N1ZwQnRzRUtBOEwrQ3F3SWJTMDNZTjZlZFVjWkcvY1ZCVmZKQThYcUR6alRL?=
 =?utf-8?B?Y3ZwYW11bkRsckMvNmhDMzlsVEVET1lRaFRCeEIrOFZyZ2VZem9TNk5uUTA3?=
 =?utf-8?B?UUdkSnVXSCsvbHFMUFZ4b1VQL3lsV3ppU1dvRTU4WWhEWTl4anFjUGZmbWND?=
 =?utf-8?B?UEpBM3FQQkJRTEVKNDdwcWY0TDFhSUpEY2tZVnJBVmh4UDZ2aEV4NThHK0k5?=
 =?utf-8?B?d3VoRDIyS1gycHdWaEFiUkJmOFdUeVg1VmhGSXZua1l0bkhLRDQ0SFA5K2FG?=
 =?utf-8?B?MzhwVUdoMlI1bGdKT2w1cVJ0MklEenkzbXpZSjYxa09KYmlYS0l4WkQwV01j?=
 =?utf-8?B?UEp5OHdiS2pkS1B1aFA5aFJYd2orOU5ZSEVUbHpEKzAzZ2o4dUpPUDQ0cUZp?=
 =?utf-8?B?ditTUHlWRTFoS2Y1YjFwd3dOQ2NhZys2a0RLbVF1MjB0L3lUVmg1YXRpS0lt?=
 =?utf-8?B?cGZUdEJwM3NFZ0ZZT2RjNnlLTWwxck5QMXhsRHdtMDJRYkoxNDdQVTFpM0V2?=
 =?utf-8?B?RnRheGFWcHI1SGdJVEJtU25vS29IZkZsZUd5MTZMOG9LVmtkWWxwRU9qelBH?=
 =?utf-8?B?dHJuM3NiL2duZ1RBYlVnSEFJRyt1UVo3a3B0WVAwUlZ1R200V0tBM0ZwUk5z?=
 =?utf-8?B?c0RORUxaZDk1VENqcTZyWEc2dERMd3dPbGZWeHF0cEE4VmdiTG82ZlZ6MTNo?=
 =?utf-8?B?b0R0TC9yTE5XQm9wNmNWVFljRWNmK3VQOVladVBtSWlRdnh3dDNTamtXL2xk?=
 =?utf-8?B?a0d2UmFSZnl3NnlIK1NNS1ZLYkIwWXBldklwVVM0TVRZUlVzeERJblpDZHN6?=
 =?utf-8?B?UXVNVnBCN0k5bWg3czZycVc3T29rKzd4RC9Xems3WWF5dHRlYWc1Skk2STUy?=
 =?utf-8?B?QlJqZUdwY0wxTGZkSFFlTFdGMEJzLytpa1ZjQ0R5VzFCdnNDQzJjRFRsbjNm?=
 =?utf-8?B?dkxKdU5wRHBTZEljRjcwdVI1QXZWMXdVTEpobnV1b0xNUDRLTk1WRm05dCt3?=
 =?utf-8?B?ZVkrZ3JJa0E3M2VveWw4dEJwaHVqV0ZpQmdFY0k3TzRtMFJORnlzUmFnZmhz?=
 =?utf-8?B?cnVPemJWZnJNQlZST1ppNC9YSHpML1NzT0dMN01jNHphQW5hbjVRMzB5TDNN?=
 =?utf-8?B?MnBOQURtMzQ5K21vZnJNeDUvUkZJaW1sU3EvbXNPb05pOXNtVGtzbzYyU1dF?=
 =?utf-8?B?bWlJNEdTQVY4SGo2V0d0ajNBK0E4VjNOWG9tMGw1RWhIdUFCc2pvM3V2VVdX?=
 =?utf-8?B?cTAyZEJ2QzVCOWNRbk5zd1kza0Q0TVVGQ04zck8yQnkzWC85YlJiUWpsTndG?=
 =?utf-8?B?ck1zSGNoR1NOdFpUSFU3cUM2dmN6MVh5a2VoSDVNRUxZaHp2Y014cXlnbVMw?=
 =?utf-8?B?SjRlSjhQL2hGTlcvZUFqbDNxdDJQaXc0bVExT3Y2ZUFISDlsU3FwSlVleUg2?=
 =?utf-8?B?bEttMVhCenlJYVBVUUFyTTZ0Q0ZWRjNZQlFhY0VyMWdTWTN4MmxFUlZCc012?=
 =?utf-8?B?c0huendFdWRxbElIb1d0dk1PMXQzQWdHWG5PWVVKTGx3V2NSWWt3WXAwaVdR?=
 =?utf-8?B?MlJDRjlNT1owM2ptSVBLdDkxQnpBRDRqcndMbGovYlJ3TE1QNCthbElZNnFq?=
 =?utf-8?B?VjIxdGpiVG9LU2pmQzltdFR1cHdWNWd3RGVrOGE2SFZvcGUvZ3QxU3BkMCtO?=
 =?utf-8?B?TFplaG0wajBHU3lIU241MGdkYnB4d2p5K2dvSHpCQnZvMFgxQkx0RmdwVTc0?=
 =?utf-8?B?SXFYdVEzbnZienBvNlFUTit6ek14MXZlWmE0cTJicXIzL3ZKcjdmV2REbHZu?=
 =?utf-8?B?ek1uS0pTdnlSSHVydm9XNXpKVWdkS0tmeUlxMXdlRXRHdkRXaWRLeVQwbVdJ?=
 =?utf-8?B?dllnVzhDTldMYkxaQ296WkdET3F2NFg4dlZEZ2RRaVlDTFYvN3U4bVE5YjhW?=
 =?utf-8?B?N1R2ckpGcWtTZGF2RG1iLzdpRzB4dUZFWVZFbmhCWC9VVWRQdDFRT2VGR09O?=
 =?utf-8?B?elE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8A49392CD2F1B54EB7E0846E6FC253CE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e70e30f6-0c55-4c33-e99e-08dda83f8193
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2025 16:54:46.6761
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uwAYHdSn2KkCa6Q8eFuQOi/Recg/c5on8+WyEep6/RqEJ1KmIUf3ug/kzvgx2pTR0v/88WlgEe/pqIPHeYdO9PwpC7MXBuEYSQWHlYv1T+c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8100
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA2LTEwIGF0IDA5OjUwIC0wNzAwLCBSaWNrIEVkZ2Vjb21iZSB3cm90ZToN
Cj4gV2h5IGRvIHdlIG5lZWQgYW4gb3B0LWluIGludGVyZmFjZSBpbnN0ZWFkIG9mIGEgd2F5IHRv
IGV4cG9zZSB3aGljaCBleGl0J3MgYXJlDQo+IHN1cHBvcnRlZCBieSBLVk0/IEkgd291bGQgdGhp
bmsgdGhlIG5lZWQgZm9yIGEgVERWTUNBTEwgb3B0LWluIGludGVyZmFjZSB3b3VsZA0KPiBvbmx5
IGNvbWUgdXAgaWYgdGhlcmUgd2FzIGEgYmFkIGd1ZXN0IHRoYXQgd2FzIG1ha2luZyBURFZNQ0FM
THMgdGhhdCBpdCBkaWQgbm90DQo+IHNlZSBpbiBHZXRUZFZtQ2FsbEluZm8uIFNvIHRoYXQgd2Ug
d291bGQgYWN0dWFsbHkgcmVxdWlyZSBhbiBvcHQtaW4gaXMgbm90DQo+IGd1YXJhbnRlZWQuwqAN
Cj4gDQo+IEFub3RoZXIgY29uc2lkZXJhdGlvbiBjb3VsZCBiZSBob3cgdG8gaGFuZGxlIEdldFF1
b3RlIGZvciBhbiBldmVudHVhbCBURFZNQ0FMTA0KPiBvcHQtaW4gaW50ZXJmYWNlLCBzaG91bGQg
aXQgYmUgbmVlZGVkLiBUaGUgcHJvYmxlbSB3b3VsZCBiZSBHZXRRdW90ZSB3b3VsZCBiZQ0KPiBv
cHRlZCBpbiBieSBkZWZhdWx0IGFuZCBtYWtlIHRoZSBpbnRlcmZhY2Ugd2VpcmQuIEJ1dCB3ZSBt
YXkgbm90IHdhbnQgdG8gaGF2ZSBhDQo+IFREVk1DYWxsIHNwZWNpZmljIG9wdC1pbiBpbnRlcmZh
Y2UuIFRoZXJlIGNvdWxkIGJlIG90aGVyIFREWCBiZWhhdmlvcnMgdGhhdCB3ZQ0KPiBuZWVkIHRv
IG9wdC1pbiBhcm91bmQuIEluIHdoaWNoIGNhc2UgdGhlIG9wdC1pbiBpbnRlcmZhY2UgY291bGQg
YmUgbW9yZSBnZW5lcmljLA0KPiBhbmQgYnkgaW1wbGVtZW50aW5nIHRoZSBURFZNQ2FsbCBvcHQt
aW4gaW50ZXJmYWNlIGFoZWFkIG9mIHRpbWUgd2Ugd291bGQgZW5kIHVwDQo+IHdpdGggdHdvIG9w
dC1pbiBpbnRlcmZhY2VzIGluc3RlYWQgb2Ygb25lLg0KPiANCj4gU28gaG93IGFib3V0IGp1c3Qg
YWRkaW5nIGEgZmllbGQgdG8gc3RydWN0IGt2bV90ZHhfY2FwYWJpbGl0aWVzIHRvIGRlc2NyaWJl
IHRoZQ0KPiBLVk0gVERWTWNhbGxzPyBPciBzb21lIG90aGVyIHBsYWNlPyBCdXQgZG9uJ3QgaW52
ZW50IGFuIG9wdC1pbiBpbnRlcmZhY2UNCj4gdW50aWwvaWYgd2UgbmVlZCBpdC4NCg0KT2gsIGFu
ZCB0aGVyZSBhbHJlYWR5IGlzIGEgaHlwZXJjYWxsIGV4aXQgb3B0LWluIGludGVyZmFjZSwgc28N
CktWTV9DQVBfVERYX1VTRVJfRVhJVF9URFZNQ0FMTCB3b3VsZCBvdmVybGFwIHdpdGggaXQsIHJp
Z2h0Pw0K

