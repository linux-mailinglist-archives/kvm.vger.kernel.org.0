Return-Path: <kvm+bounces-51760-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A1540AFC8FB
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 12:55:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B58BC167173
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 10:54:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B826B2D8DA4;
	Tue,  8 Jul 2025 10:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JMT1e/R7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43B1B2D323D
	for <kvm@vger.kernel.org>; Tue,  8 Jul 2025 10:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751972005; cv=fail; b=YtMQ3Tnisudk8dKWSfMoF2svD0gF3gZcECULPs9ZBdxt+Ypt7jCdjHTjSxeWnpqiWcjev/48KFppYCGGQKyxJ0yhlBT5m2SIjwMAwrf8xn4zfPYqIBr9OCnWtrPaUaemrFB8qUhBXwp2HdsGolTDlVVWOGVs0S5cbsiAVBh7d8c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751972005; c=relaxed/simple;
	bh=k0B3THCuDAiSE+KqDck0T1ReIBG4WpRN0EjAdKNWaXA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GxZY+8lUmN9d10mKp9GBXokGlSSVVxSiZ9jLuiyhkBzR6BJBjHltp1BUQ2P2abmEsrjk3OzxmFlPtsG17ZBtikcr0LmDzY/82VJIiqnE9u3DdBxI1hqIxwbKa6KhpC8/Ley+PMT5tOFUQwi6NdGyPGhuxvd9KqaHd6gr6YlJfJI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JMT1e/R7; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751972004; x=1783508004;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=k0B3THCuDAiSE+KqDck0T1ReIBG4WpRN0EjAdKNWaXA=;
  b=JMT1e/R7rc6kAjXyw+RSl5S7+dxrSvHsFTQXC/gZy4IWZ1WCRpV+mOLd
   gGLvCIaS+ym2b6zgSPzMS8IrKd/EMXQiXOQdQWXG4ibf8CYkLk9kgeyYg
   O1klJEgndjYN6YrIwRExiu/bjb70ax7xLOUx1j5zbFba58mon9VGCKuXH
   R1M9xu+mclL2mK4gX7itbwPgP/ilBkFSdfLZu2iQjk7JmW92aY124FVAd
   KiJKzkE/IdxvNuco4EVMEZbA4Wq8F+AlHrj9cQCehPeRdNHt/oDsxncyL
   2cKOeA2I+4kdgrA2F2e2Tjc/TZsTVWKeblKgfFKgYGhcCyhNsVGqn+ymu
   Q==;
X-CSE-ConnectionGUID: 2AfjkgiUTsOoKYgaMd4UVw==
X-CSE-MsgGUID: rJDnlcmuTWCrEJsWc5GUxA==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="76754346"
X-IronPort-AV: E=Sophos;i="6.16,297,1744095600"; 
   d="scan'208";a="76754346"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 03:53:23 -0700
X-CSE-ConnectionGUID: aFDoHB2jQRWP/2lRwoQT0Q==
X-CSE-MsgGUID: gz+TTjvuSXyBzN1mqJ1fkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,297,1744095600"; 
   d="scan'208";a="179139965"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 03:53:23 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 03:53:22 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 8 Jul 2025 03:53:22 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.44) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 03:53:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d9HIObYEDbeJQsBiIYW6oEgdS0iC5qiy+JOkZXXAiuuDqxtXknbMS4Cco3mkVL+RDITPgqPPEgK3d65crMrRWRtKX7TNeeB1CccVSlsVryYzUPXzjqcslNnzDgRHDBii4L1DTq8gb98pq6QIOiWpAebLdBkN7FT9jt65c89MfMD4rnPbb8k/gO1zb+EIAKYTI/I5u1oCKvAbsQmXrQZUYKFxuAsO77ukum+F4Vg5ITHEoJVtZ82+8NEnEH2e2vsm7Mj6BLfrB97tcf4YzH7Su2qIEuHXETX/GFotZnvP3pndsQTr7pw0nWJR86EYy7Ikm0XGq0qbvQacsUiEImkq2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k0B3THCuDAiSE+KqDck0T1ReIBG4WpRN0EjAdKNWaXA=;
 b=Z6wSgkksAXGqk2FxHHGhUo7MX6asavfvsG+BS7JAKrm3wDgNhWcWQICVAjQpxoF/EKs1aONjeMkwysNzBNeVTdyrnA82IRpvvVFJMtKiIfFiZYd40vQx+m1EaMr/qMVjp9VfdMIUYW0pezlVT3VdKXVakO0F61uW33QSjuQfOByFvv1i4cz/rFuOwUE4qISqLr/EA4LdVwMVWsiu/XUf3SjNaPWS/RaBxY7822zewOTaQ6SWKhQc31BnxflGYvG6E4id0nUKoB7aHa8kwGBHHxgYEsDOisL4LY6ge/6zLiw3l6AEzCivRbGTVXRkv+ImpQuyuxXrydPOetKpYp1/9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by PH7PR11MB6858.namprd11.prod.outlook.com (2603:10b6:510:1ee::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.26; Tue, 8 Jul
 2025 10:53:05 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8901.023; Tue, 8 Jul 2025
 10:53:05 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>, "nikunj@amd.com" <nikunj@amd.com>
CC: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
	"vaishali.thakkar@suse.com" <vaishali.thakkar@suse.com>, "bp@alien8.de"
	<bp@alien8.de>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"santosh.shukla@amd.com" <santosh.shukla@amd.com>
Subject: Re: [PATCH v8 2/2] KVM: SVM: Enable Secure TSC for SNP guests
Thread-Topic: [PATCH v8 2/2] KVM: SVM: Enable Secure TSC for SNP guests
Thread-Index: AQHb7yd7VfkdP/oV20S9Gj+gph7qB7Qnf8YAgABSdACAADxpgA==
Date: Tue, 8 Jul 2025 10:53:04 +0000
Message-ID: <d8a30e490c50956a358887a3d018a9b86df91fd0.camel@intel.com>
References: <20250707101029.927906-1-nikunj@amd.com>
	 <20250707101029.927906-3-nikunj@amd.com>
	 <26a5d7dcc54ec434615e0cfb340ad93a429b3f90.camel@intel.com>
	 <cf03633c-63ba-40b7-abd1-8cbeb4daadd9@intel.com>
In-Reply-To: <cf03633c-63ba-40b7-abd1-8cbeb4daadd9@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|PH7PR11MB6858:EE_
x-ms-office365-filtering-correlation-id: df8a19ad-f815-415b-82fd-08ddbe0d9df1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?aGNpV0grSUFsS2NkZE5iQi9VUUxLQ3RYbGQ1dEwyZklzVGdzTzhEZmpNckI1?=
 =?utf-8?B?RGtsak1ZVUVFSGVWMzl0Z1ZQVE1PSy82UlBHdWtWVWN0dDB3d2liaHptdnV6?=
 =?utf-8?B?ZmNJMEJvdUl3S01hUlJBMXROS20zUWIySWRJY2ljUlI5VFF0L3EzeDk0anA3?=
 =?utf-8?B?SEorTE9rNERUQjVRUlNRMG11ZzJhSUpuSURHMEg5bnpyeEhLRlV0c0x6aGo5?=
 =?utf-8?B?ODhjbGFPdjVhTUd0MFV4QjlhdjF3NVJITnA3d0VNcmd3YTd6LzB3U1MwZFdS?=
 =?utf-8?B?VTV3cURCU3pQdER0QzNnZnFPYWRHSTZHQkFDeC85MjZ3ckdmMDhhdkZ5UEE3?=
 =?utf-8?B?U0ZRWSt6UFRoSE1LdVo0VE1qQ2V4aU9NenZGVUluVzVmS1VLVmoxTU1XaHJC?=
 =?utf-8?B?Z1pQY1kwK3gvREtaL0xNQ2tnQU5pelh6UURheVN5cVRQWFB0VExpd1JERlRn?=
 =?utf-8?B?WUdCUlFGNWtvdFByWW85c0ZOWk1MWnFwMC9Vdkx6eUhnQ0p5dkVUdTR1VDFO?=
 =?utf-8?B?aXRMdStPRlJIdWNsc05YNW1ZbjdnQVpGYUpKakxLU1UvVG4rdy9BRGIrcEh2?=
 =?utf-8?B?Ujd5ZmNKbjFNQy9IRjhNU3RkSkR0NE1JZ1ZTbm9yUlVlZy91d1VKNXExSEYy?=
 =?utf-8?B?ZkdsVDY4alVGWWozNzR1ajY4OW96ZVRmNG5MWmdveENoVGtZRktDdUsyT3Zh?=
 =?utf-8?B?dFFlVkVYSmVvQVNseThieG8xMm95Q3JaY0YyUGZzNjBRMm5KQWU4YTgxb1Bz?=
 =?utf-8?B?bjREQW9CUGZxZDZFdnNlZFAvRHBDdWhXWFYvMEZpejdiOTJpeUpGL1ZjU1Q4?=
 =?utf-8?B?THZsR1Z6cmZMZ29BbG95MFFURXBqNUJwc0kxY1lYM1JhU2dia1hXd0czL0Jy?=
 =?utf-8?B?Mk1adms0RTJJNXZQS083Y3BpOGEwaWJ5eWRvY29FTTNVcmE1cEhpZ1hYcWFt?=
 =?utf-8?B?NDVZUkdPV050QWZEWTA0VE5mS25WelZ1QmdtMHJkVTFNU0lBQUNZU1FNL251?=
 =?utf-8?B?amUvT0dRcGFJN0s4TElpV0VsOTZIeFhmQ29mc09nVy9YaExQeEZHY3JlNUtL?=
 =?utf-8?B?cmJuYSt5ZjFRWXY1dkI3UHQxWGwxbFlwTzRnVlMrZ2xRV2tFSFVHMnRyaC95?=
 =?utf-8?B?MlhZdnUybGFDUFJqNTBMaGIxdnhsN0UzcGYwSmpVaTA0Y2VIbFNnMjBlRU1x?=
 =?utf-8?B?UDRmM1AyVWEyeXBuOVFqeExtUHM3MGR3c0Q1RlRzTjd6OHpYWW9BaHlwYU5Y?=
 =?utf-8?B?RkFLMGl6OTNoR01yZG03RmtQS294NnU1SGtNTk8rL0cweUdzWlhIMy8xU0lK?=
 =?utf-8?B?VHp3S2JhaHQyd3dKRmM3Sm1vL3Z2QUJzdExTVmpuWFdWNy9ZUFlBcG40TTNp?=
 =?utf-8?B?SEtpb3JTZG94K2syR1E0ektSaXdUOFZpdmtaRFFYRGZscVFRUHAzZm41Y3lw?=
 =?utf-8?B?RkFXWUhGdWpBeExFQVdCazFlZm51MVZac1VXbWZHbmwzU01JNXIyMnRlWlNO?=
 =?utf-8?B?dUY2VkRvbW9UK202NDdWUGxkdVpVaG5qL2dxd011dTJQbFFkUHVETHVVUjhS?=
 =?utf-8?B?dnJvQ1NlbVM0a2lhYlM1RkFFV0NyNEFEcWhVWmpFQUJoaDJOanBMZktlN0ZY?=
 =?utf-8?B?U0gvNXQ2cDkxa3BpbS9ORjladXFqOWZSSDhGVWhQUGVlU0xQZVBlRXhaN1ov?=
 =?utf-8?B?YlNIQUhnSHhRaXZ3WUVIVHFRRHVDamlFaEh3SnhjcTR1RUpZSUt5em1NakdO?=
 =?utf-8?B?V0JZSFlKSzEwMTBiclEzNThsM3E4ak40VDlnbW5pSHo3QmpmYkxMQjBXZlN0?=
 =?utf-8?B?eGMxSUo4Y1lNa2JOc2VEUm8rdlkyMzUyYmZ6emJtVUtMTGhtL0tBVDhNNm1u?=
 =?utf-8?B?VzJUZDJmM0tkamQzR3lyejd4T3BFNHRFTWJ0blZoWXBzY2xEeEhyaisrZGJR?=
 =?utf-8?B?V1NIV2dmdVMyalEwV1VOeDdKVWhiQVN3eGxaYTlHRTJObGV3R1FBam50MFBM?=
 =?utf-8?B?YmNtR1dVNStnPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V3l3aWxyL0JZYUtLemVMYXlNOUprYm15NE9yYnUvMm5XVkY2MGNaRG9qZGFD?=
 =?utf-8?B?N29Tay9ESU9UREprSWN2RnhhRFcxaElhcktBNExQS1BLNG00ZHNQOHdZY1Q3?=
 =?utf-8?B?UVNrQlQ4OENrRWJhVE4ranVLd3lKWm9WdXhvNmJ4ZGNmTUxEczBTNWZKVEli?=
 =?utf-8?B?RE4yUFFjdUVWZEhUZ2t2M1lGaFJYdkJLZVpNSEx6YnN6VDhCWk9sWHNRT2ZW?=
 =?utf-8?B?VHlFekNYdjF0TVdjVCtKVEZwWDJIcXR5Mm04dXFQWU9oNlJKQTUxYzE2amhn?=
 =?utf-8?B?MDNZQzdCSHFqQWd3VmFYUlBlWkNINFltV2ZkRGg3T1dmNXNxd2l5azZnTHlr?=
 =?utf-8?B?Z1drRVdtdnVrN1E4TjFZRXRZSkVKZ1g0Z3hwWUhMUXFCVVkycERJV0czZ2l4?=
 =?utf-8?B?aUZ2MHVKSFpZSmJZdGZ0bTVLTWxtK3RaOU56Rnk4clBmTkNwQ20xQmFEWEVi?=
 =?utf-8?B?MzJlNEt2ek9UcWUrTWRpSTRtUjhVNVRNb2w5bEdjRjBpdVN3ZjVqalhhYUJG?=
 =?utf-8?B?VEhRRStJQWtZTmhtT0xXQ3N2SGJ1cnJMeDN5TUVTbXE0MEdkMmF2OS8zdUt1?=
 =?utf-8?B?dldlOUQxenpmY1lOMjd1dU9vdlFvSjV5T2VFR1hXZW5xZVgxU1hETHFJT2d4?=
 =?utf-8?B?QnpvTFY3OFJSejlQSXhqVGJ6dVk3aEc4WXRMYXlUR0N4WHJzbTBUK21VMENO?=
 =?utf-8?B?L3NaSzFEbmtUUUR3YlUxbi9TYkh1eHFIQVVFQm5Ra29nSlF2NStpOTZrVkJY?=
 =?utf-8?B?OWN0VEhEREpGQnh3ZU9IK3E0S3RhWFlyM0N4VVpuaEVPNVhUejBzWUhTcHZH?=
 =?utf-8?B?YUs2aDR0UkdpN2RXT2ZNZHZWYWoyazQrcHJ5Nkk2QmJObExRU0ZkeTh5MlZQ?=
 =?utf-8?B?QUIvNEcyeHFaNkwwc1JwUzM3WmJweUx1bm9xUG9IZlhtYlNVRTFZWGpsbWlw?=
 =?utf-8?B?blpESWNUeFdQcGlJa3NLSnhPalNsclRMRXhXc1FJdWlRNG41SG9FSEFvb21K?=
 =?utf-8?B?UjNOS0tSVVNXZFR2bXVWWk4xSzJHc1p2cGdmVE5hRXV3d0Q0czNBRDdFMm1N?=
 =?utf-8?B?MEtLMkVLNVk4c2V1amREOGFiM1MrZTQ4cm12RWN6dTRhZ2NWQStWRE9HUW52?=
 =?utf-8?B?cUQ0QmxBc2tXMkZ4VmptcGpXbXdLUTlYQ1drYm53ZXk5bUF4bjhVSG5GMzBl?=
 =?utf-8?B?eTVYT3IxUUtOR2k1WG9Sb1d3NVlKbHcxV2Yra0xuZFRlclNYdVUvczdCQWVp?=
 =?utf-8?B?TldmMjE4Mm9lQVFNM1NrTGZDdkdpREpua2o4YnNUZUdHcklXaVBicDgyRWdk?=
 =?utf-8?B?NEpQUDNoMnFSeUtvMFJsR0hqQjV1RkYyb202bk5IYTMrOFgvQ2VCbm03aml6?=
 =?utf-8?B?RGo3TnJPMVVWMXBXampBQ0lheDNrWUp0WmVUeXU4Uk4waVROckdzT0FrVXZv?=
 =?utf-8?B?WEhKbk9Ibk5zdVdoR01SNWtJa08wQTJNKzhKb3BXWjJEV001SCt6VExYUWVX?=
 =?utf-8?B?SHBESXdRZ2xqUlgvVXdwUFVCT3JSUE1IdzMxVkdiOGxxQUhTK0xETC9vNTNy?=
 =?utf-8?B?bHhRcFNJZnozNmcvUHpLVWJyZnk2cHM1aWMvNkpTbFFXYXNmV2o5MEZJQllK?=
 =?utf-8?B?b2ZkaVBURXk5TkZKMkxWR0ROMno4U3dZR3lmQTk3R0JWMWhVU3pNdE04NGl4?=
 =?utf-8?B?SWluczFsRjNRQkRaUElUZFo1Q3hhVGY5MS83VVg3UGlkSENNR1JZNmdsM3Vu?=
 =?utf-8?B?VHlMTGRCSnpHRWp5bFJEMWk1Qno4S01aVVBYYW8rZkRBWjRrdjBSYkl0S29X?=
 =?utf-8?B?TFVCYnkwVmRNRzk0S1F5TEhveTU0ZUlSeG1jQXFpWlkxbVNvejlqZVNYbE1I?=
 =?utf-8?B?M1l3YXNKTEozZCtUdGhjeDhRaVZXUFNQVEl2MzJTS1BVYUJiazA2empUNVhs?=
 =?utf-8?B?cVZqU1djM0pSMjNCZEdqLytYSVlsN2hQeUJMTGtLcW0zeVE3TWdJR25Sd0dh?=
 =?utf-8?B?K2hQYzVleU5vcEFZQmJVSlVmOTRRcUZUYUdHdEFwMjJyL2VtVWtpdEhLN2ZB?=
 =?utf-8?B?bVlERUdkSjhXREZOM2pXN29hbC9NTDhzUkxwODBwRnQvZVNRODNZVzg1VFdn?=
 =?utf-8?B?QUpyd21ZWGdzN0VFMWhucHMzMU1YckVVVlV3a2RQNit0aSttajNtVmdxYVM5?=
 =?utf-8?B?SVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CD709E36A83E0B4CB2BBEB9C21967699@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df8a19ad-f815-415b-82fd-08ddbe0d9df1
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2025 10:53:04.9838
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5zv7vK6OYneEOXtNgKXuyoKNcKLKE3hfQgv1ongaqqF4vVcz++ELWfPUN74SenhKPQomSUo41IZMt7wHkFS2ow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6858
X-OriginatorOrg: intel.com

DQo+ID4gPiAtCQlzdm0tPnZjcHUuYXJjaC5ndWVzdF9zdGF0ZV9wcm90ZWN0ZWQgPSB0cnVlOw0K
PiA+ID4gKwkJdmNwdS0+YXJjaC5ndWVzdF9zdGF0ZV9wcm90ZWN0ZWQgPSB0cnVlOw0KPiA+ID4g
KwkJdmNwdS0+YXJjaC5ndWVzdF90c2NfcHJvdGVjdGVkID0gc25wX3NlY3VyZV90c2NfZW5hYmxl
ZChrdm0pOw0KPiA+ID4gKw0KPiA+IA0KPiA+ICsgWGlhb3lhby4NCj4gPiANCj4gPiBUaGUgS1ZN
X1NFVF9UU0NfS0haIGNhbiBhbHNvIGJlIGEgdkNQVSBpb2N0bCAoaW4gZmFjdCwgdGhlIHN1cHBv
cnQgb2YgVk0NCj4gPiBpb2N0bCBvZiBpdCB3YXMgYWRkZWQgbGF0ZXIpLiAgSSBhbSB3b25kZXJp
bmcgd2hldGhlciB3ZSBzaG91bGQgcmVqZWN0DQo+ID4gdGhpcyB2Q1BVIGlvY3RsIGZvciBUU0Mg
cHJvdGVjdGVkIGd1ZXN0cywgbGlrZToNCj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYv
a3ZtL3g4Ni5jIGIvYXJjaC94ODYva3ZtL3g4Ni5jDQo+ID4gaW5kZXggMjgwNmY3MTA0Mjk1Li42
OTljYTVlNzRiYmEgMTAwNjQ0DQo+ID4gLS0tIGEvYXJjaC94ODYva3ZtL3g4Ni5jDQo+ID4gKysr
IGIvYXJjaC94ODYva3ZtL3g4Ni5jDQo+ID4gQEAgLTYxODYsNiArNjE4NiwxMCBAQCBsb25nIGt2
bV9hcmNoX3ZjcHVfaW9jdGwoc3RydWN0IGZpbGUgKmZpbHAsDQo+ID4gICAgICAgICAgICAgICAg
ICB1MzIgdXNlcl90c2Nfa2h6Ow0KPiA+ICAgDQo+ID4gICAgICAgICAgICAgICAgICByID0gLUVJ
TlZBTDsNCj4gPiArDQo+ID4gKyAgICAgICAgICAgICAgIGlmICh2Y3B1LT5hcmNoLmd1ZXN0X3Rz
Y19wcm90ZWN0ZWQpDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgZ290byBvdXQ7DQo+ID4g
Kw0KPiA+ICAgICAgICAgICAgICAgICAgdXNlcl90c2Nfa2h6ID0gKHUzMilhcmc7DQo+ID4gICAN
Cj4gPiAgICAgICAgICAgICAgICAgIGlmIChrdm1fY2Fwcy5oYXNfdHNjX2NvbnRyb2wgJiYNCj4g
DQo+IEl0IHNlZW1zIHRvIG5lZWQgdG8gYmUgb3B0LWluIHNpbmNlIGl0IGNoYW5nZXMgdGhlIEFC
SSBzb21laG93LiBFLmcuLCBpdCANCj4gYXQgbGVhc3Qgd29ya3MgYmVmb3JlIHdoZW4gdGhlIFZN
TSBjYWxscyBLVk1fU0VUX1RTQ19LSFogYXQgdmNwdSB3aXRoIA0KPiB0aGUgc2FtZSB2YWx1ZSBw
YXNzZWQgdG8gS1ZNX1NFVF9UU0NfS0haIGF0IHZtLiBCdXQgd2l0aCB0aGUgYWJvdmUgDQo+IGNo
YW5nZSwgaXQgd291bGQgZmFpbC4NCj4gDQo+IFdlbGwsIGluIHJlYWxpdHksIGl0J3MgT0sgZm9y
IFFFTVUgc2luY2UgUUVNVSBleHBsaWNpdGx5IGRvZXNuJ3QgY2FsbCANCj4gS1ZNX1NFVF9UU0Nf
S0haIGF0IHZjcHUgZm9yIFREWCBWTXMuIEJ1dCBJJ20gbm90IHN1cmUgYWJvdXQgdGhlIGltcGFj
dCANCj4gb24gb3RoZXIgVk1Ncy4gQ29uc2lkZXJpbmcgS1ZNIFREWCBzdXBwb3J0IGp1c3QgZ2V0
cyBpbiBmcm9tIHY2LjE2LXJjMSwgDQo+IG1heWJlIGl0IGRvZXNuJ3QgaGF2ZSByZWFsIGltcGFj
dCBmb3Igb3RoZXIgVk1NcyBhcyB3ZWxsPw0KDQpHb29kIHBvaW50LiAgUGVyaGFwcyBQYW9sby9T
ZWFuIGNhbiBhbHNvIGNvbW1lbnQuICBJIGJlbGlldmUgdGhlIHJpc2sgaXMNCnF1aXRlIGxvdyB0
b28uICBJIHdvbid0IGJvdGhlciB1c2luZyAib3B0LWluIiB0aG91Z2guDQo=

