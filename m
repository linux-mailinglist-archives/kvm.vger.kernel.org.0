Return-Path: <kvm+bounces-51721-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BC41FAFC0CB
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 04:22:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 883D73AE3B6
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 02:21:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54153218EA1;
	Tue,  8 Jul 2025 02:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ThN1Wm5n"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 613EF39FF3
	for <kvm@vger.kernel.org>; Tue,  8 Jul 2025 02:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751941312; cv=fail; b=QCA+lPzWDCU+CubLatxkfkxHSU3Mma+QSRQk49th3dRb4x3u+nvTrJ5mSjdbD3xicboWZctzQdp8gNPP7m0dJP+WiIJbu4TXVKwpZyXnvnyI3ChuCRIVQC1OUGh9PNoSFYgUyQdbgF9QPlw1lHjUKX/7lKEa9hh+mLRZvoaeiFY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751941312; c=relaxed/simple;
	bh=Nq6iRZk6L1jWuZCE+MkyoUyEz/GsUxYK+srHbx/+7IY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ejiTo+SSBzHoVXPRAeaReiSYlvSmrJOVUUPAVv6NLt90d6pYPsdcwxlIfwXoM9dKdCFxsj89Pl0IKCJvZtg/qHr10Bxsr9IGSi8H2dx//Wdv8eQFGNRW09uGbkzmSgGGOTvne/3KYMhtewG+KXjBNGBkOQqyvkjc6yuzj9CLzS4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ThN1Wm5n; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751941310; x=1783477310;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Nq6iRZk6L1jWuZCE+MkyoUyEz/GsUxYK+srHbx/+7IY=;
  b=ThN1Wm5ncZw9M96UML2fV2QYUDwbqQgn6xaT3EEQsImGyd9Lf4QpjB3D
   ElhZGE+xJnSXJbw258ey7/EQYuUA2iz8urXTf7JTrdisutlt7oJxfKMQ3
   ucnPImZvaEDZgtKjVZgDZZ8nKzl42gA6DFUKGM2B9Gxeqea8DxoY0k1iu
   OyUROXZavspzhuZ/o0p3bgW15OrxfCQaCqFvb5OXJfroesjeKSV8oi+3F
   bco7zrGhOLCu8qCilmIow+BxxI1hSOGc8vMe/FsCZWQWukiIihztzyTBO
   LlpMA8Xqwm0MEazWekbpiBfdN9Xa28H5B9GJrgwLp8+5VkqqZ3LT9JKhc
   w==;
X-CSE-ConnectionGUID: z6b0mqTaRdWV6ertoLFOEw==
X-CSE-MsgGUID: nUPH9VxDSi6PWYboGOYdRw==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="57971434"
X-IronPort-AV: E=Sophos;i="6.16,296,1744095600"; 
   d="scan'208";a="57971434"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2025 19:21:49 -0700
X-CSE-ConnectionGUID: /UXjAoXrRrODYnBlu1pt+A==
X-CSE-MsgGUID: 5co31vCsS2u3wOsxIp/nsA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,296,1744095600"; 
   d="scan'208";a="155002613"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2025 19:21:49 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 7 Jul 2025 19:21:48 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 7 Jul 2025 19:21:48 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.58) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 7 Jul 2025 19:21:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C5WDd/jZehFnwWNTlSWDhhK0Jbut/2RscKFiPaG4Q7fef5VFFfg6IayseveG2HEqo9wu9V3911sLhtx3QOvWAQdw1so10a2WPnz25zjwjUyDttf3WSqgPWX3ttmHZrBLFZ2a9FAO0sToaT3jgK/KOn4CPNWMJgs3Egs0EMmmU4JsQt58G/IDMwJ0UgCbhS5TkR0RTEkkdBEXaY/so4sF1qSEMXLovG9YVsPhdXvVNdJuo7eTu6O/ctjO2elO4/gSojn2uj4u2Gjzb5SVym/Mi2KyNO2SYzgVEPlw+WgI6dg+LQo4ST6VkD+/oUn6VMzvQo4BSAbUhy8bcWEVC6OYLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nq6iRZk6L1jWuZCE+MkyoUyEz/GsUxYK+srHbx/+7IY=;
 b=wUoxKXf1NHarwZFP3usUwHiJcv/DbT9RzGkyWiDT8qk4NzbFxYYl5UE39vMdMNKIlgUPiZBmGAuiZC7FAhyLvjc5g5uo4XVOKwS86kJLBXdpfEOC5lcxM2rFKbigAAiLjxn8aHMBrHlFrT7egS2w4hxnzRJL7d1l4Mt/OmxB/8EFQSh0ACyiA5LvH7qupdVHoPNh7Tk6NA5164FHBdnqKCao1iHDNSoIBVDg7VXx7v7Tl7PtLbib/ffW9wVrrrqOm0ekb3A+Y+koLiSE1+DEUQrMkmOSGVn212LFCp1kyrpUodKdEUC6IfouaU79R74KZoFR7OkebL2eWZhrfaDZDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by IA4PR11MB8941.namprd11.prod.outlook.com (2603:10b6:208:55d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.23; Tue, 8 Jul
 2025 02:21:46 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8901.023; Tue, 8 Jul 2025
 02:21:45 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>,
	"nikunj@amd.com" <nikunj@amd.com>
CC: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "vaishali.thakkar@suse.com"
	<vaishali.thakkar@suse.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"santosh.shukla@amd.com" <santosh.shukla@amd.com>, "bp@alien8.de"
	<bp@alien8.de>
Subject: Re: [PATCH v8 2/2] KVM: SVM: Enable Secure TSC for SNP guests
Thread-Topic: [PATCH v8 2/2] KVM: SVM: Enable Secure TSC for SNP guests
Thread-Index: AQHb7yd7VfkdP/oV20S9Gj+gph7qB7Qnf8YA
Date: Tue, 8 Jul 2025 02:21:45 +0000
Message-ID: <26a5d7dcc54ec434615e0cfb340ad93a429b3f90.camel@intel.com>
References: <20250707101029.927906-1-nikunj@amd.com>
	 <20250707101029.927906-3-nikunj@amd.com>
In-Reply-To: <20250707101029.927906-3-nikunj@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|IA4PR11MB8941:EE_
x-ms-office365-filtering-correlation-id: a727721b-b568-449c-0238-08ddbdc62fc1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?QXJjR3hsSmE5V1BQcFhxaXZ4MDdZRGh1eWRSUGpZcVdUUzBad1EzTGNuSHFv?=
 =?utf-8?B?NHNtMVk1a0dYSG41TkJ0aGsyL3diZWZ6cG1OajdhaFVCR2ltQytQNUhrQ05t?=
 =?utf-8?B?OHZVSDM4YWxXcStmd1FGdXQ1MUpkdlZzZExSRmlkUmdxSDJXYmpGR1h5N2FX?=
 =?utf-8?B?akw2ck5NM3g4USt6cmg3NWt0bnlWWDhTRWF0ZW5mWUFDZTVheXNYSldqTE94?=
 =?utf-8?B?U0sweTE4NkU2dGlCVldsK3RJeXNjMFN2SHNMZTRLNjRLRkFUSFlZYmUzSXJF?=
 =?utf-8?B?bXlkOEdoUmltalR4UmwzVGVhMTNDWUJUNTZHaitmZTJXemhaeVZXRDNHT1Vs?=
 =?utf-8?B?cVU2cmhFb1VSei9IMkwyOC9ONG9ZbzZaSFFIK0Eyc2pIUnJ0cXhQWmV0THJl?=
 =?utf-8?B?UlJoZEVCTm9zNHBhSFJta21RV2E0VGRUYUx2WGhpM0NCWkEzdG5vSUtRZE8w?=
 =?utf-8?B?N2s1MGNlUHd1RytSK3lMbzgwZUdiZ3FadGxGcEV6bUh0VnJSaU1vNmxhT3VZ?=
 =?utf-8?B?RlZ6YTVjNmxML3IrODlMNE54Y0hVdGdiNEZKMG9NOUFzY0tUeElRODIwTXRq?=
 =?utf-8?B?Q0ZHL0tiUDlubzlVS3ZqSlVNRit5SFA4SHc1NmdWQXFwcGdkK3BJenR2UnFq?=
 =?utf-8?B?TFNZb0RPb0V2VkxrNWR2bzk1UGVqR200WnRzRjB1M0YvMEQ1SFgrOHAzaGJR?=
 =?utf-8?B?d1hKSG5Kam9IOFlWNHNqNkFxR3d2WW5VblhmVXdnNlVwOS9xN1NoQy9WTm1Q?=
 =?utf-8?B?OG42d3Vyd1BPaXl1SWEzaWt1ZnRMdjUwMU90OGErT1NMOEp3ZXJCS2dhTUR6?=
 =?utf-8?B?VERTSDZqNzcrZDNPeTNES1VnNnpCMmJLQUNSYnRtNGt1cThVVDNuYVpBc3p1?=
 =?utf-8?B?ZWZqejVpdlZFVkVwTTlqNjllRitOVC9WN2xnZkN6d0JkUUQ4Y1RBUzBCaVhI?=
 =?utf-8?B?ekpwNXVzNEJ6MGIyVlJ0WG0xRGs1TGhFTkljSTcyVklaMWlCY0pteUo1QTBy?=
 =?utf-8?B?ajFwSG43U0dYbHhuUU5BNVp0Nk5tSVZLV05odWNmWmFUYk5FN2JCQkI2YjNW?=
 =?utf-8?B?NElmTnlwSmZ6ZnU4ZUMxdlJoUmV4alByaFc0YVBVRGtFUUpYRmdMeVZZdS84?=
 =?utf-8?B?ZGV6VUxLR1YyYzlxcWFtNTNCWlhieE4zZDhoMFdheFVIM2ZyOEk1N0Nrd2FT?=
 =?utf-8?B?Y1ZwdTBoZWxyNEhxRUpOcXJhQVA5SUF5NzJHby9nRm5Nd3hHRDd4Zk1LMUg2?=
 =?utf-8?B?ckhJTzhjSWZ1bTRXWVlrcy9OTER1R2tiNnY4N3gvczFWVk5YcXdUc3R0YjlM?=
 =?utf-8?B?SFc3aWhmdDlRZTBiSHRiR01TOUY3b1ZPZTlSbG1rUE43bTBESDluUUgxSEZt?=
 =?utf-8?B?QWtXdmRDQ0tKdnVacm5veHlLRjU4VWpjMHJ0aDQxSW5vK0lJU0gxU3BTRTdy?=
 =?utf-8?B?SXFVN3dBeHdHTEJwK1d6UVM2U2tOSDhtQ2dTaC9aeERIZFQyMW5Rbm1TOUxD?=
 =?utf-8?B?VURtYXFUU0xBemZJOTNSR1NURW4yTW9WVGhkNm9TNytsMFg1QU9udDB3aHYr?=
 =?utf-8?B?amtuZFdSdkNUSHJOczNXTzVXOXlZbng1RGRmZkVjTElKV0ZUT1Z2UGpRQXRN?=
 =?utf-8?B?TTRIZmhjaUMvOHc5MXBlUXhESk5wanU5dDU3Ylc4OVlqSElEOVdwSEVlRER4?=
 =?utf-8?B?WUdqaE1GQlRCSVBqNUV2dndKdGFWc29oV1FXWlVFcDJESUd1UDBYODhkODI5?=
 =?utf-8?B?bHVsTks0d0c4YlFyalVMT3QzS3ZNZDlXeXN2UVpYSWVWZnBObmRCTGovMEcw?=
 =?utf-8?B?eDJEcnpOcWJONm94VmE1QzhOb25ETVR1bnp3T1dkRGxhK01WRExyRWxkSUky?=
 =?utf-8?B?SGdsQ1lCNzhKWi9GdHVDek92NDZuektjZGMrRTNIeDl6b00xcnNKUDAxaHFa?=
 =?utf-8?B?TWF5anpRZVY2S2NjTFNxNUxGazdRQm4zQ1N6N1E5OUVrWkZzdFRITUtaOXJB?=
 =?utf-8?B?cGU1SUJ3b1RBPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bTdORUF2cXBNc1loRmphNVd4RGNwaFp2NHRvdk82VHhKY3UvZGZWZHREaHE1?=
 =?utf-8?B?Vi9uNzBOaHM4L1pHU0Foazl1VThsOU9pMEZHbVhDOUxacFJMV2htdWdzZE50?=
 =?utf-8?B?ZGZ5dy9jaHBVeGtzTHZBVmpWWVh1U0VtWFVNbmMzNzRKeWdNZ2NPS1kxOUN5?=
 =?utf-8?B?aFhFaXBwK3V2Mmcxak9nSGc5SjU0VVlLbTFTa2o0TEhIM01PejEzbXV2c2d1?=
 =?utf-8?B?K2I2OEV0ekNCN2lLV2hMd0xmZVg5VFAxSDA5dFVxbTV0eitHaWQ3STJ5djV0?=
 =?utf-8?B?UkhhOEpXYzlabmJzaHN4dGpnWXI3ZUJ1d3hkMlg2eS9XVjk1RFRoZFNsa2ZU?=
 =?utf-8?B?UnZ0Tkk4WWM2dVpDaUNNdVZmckY0enF3MXBjYnl4VTJaaWFsakhxeE1tb1hS?=
 =?utf-8?B?YUV4WXJZeXhpcFBKajE3cnJqLzJIM2VMN3krVVlGcGEyMXNRWXM5dURXc0hH?=
 =?utf-8?B?WUc4ak5WYTY4VFNITE9kZTJYditaUFhMRkpuSnhwOW1vTHR6L29WNS9DNlJN?=
 =?utf-8?B?NlFFTVREWG1ERFVZd3VxSFFuQVFZa2RBNXFFSHR0VjhlY09tTHFoUkpYRVQz?=
 =?utf-8?B?a2hCNll1UmFaTlJkczc3cTRDVzZHRnl0MENLVHJFV2ZrQnBpVjZTVUI4WVZ1?=
 =?utf-8?B?eHdySmplbkUwQVhCUXdKc0N4Y1l1bHJqck1mNStFVDVtWFZoUVZsNnoyZUg5?=
 =?utf-8?B?MW5xamlwWk1kdFUrTmlDUXBUa1p2WGJ0NWhvOXNibFo0aXdoN2tEL3lQQ3p4?=
 =?utf-8?B?TFlFUnZENExRS0xEOU92TDMvU2IxOTFFQ3RwTDJSZGpLUGdJNkhZUHljWk1F?=
 =?utf-8?B?ajZoeUY2Q0E3QkJyd2dldWZUWnJpYkplWEF0Yjl0ZXhSTHVob3pWTW8yZWI5?=
 =?utf-8?B?Mkc1NkFSK0tCQkpxYjVHTXRuUGJZTTZMMnhDKzdjaldXYzd2ZDYwZGxmWTVh?=
 =?utf-8?B?MSs0M0lLVEJqeWJiVU15TnY1YmtsM1hEcXBzallVSlhNbmVtTXU0UktlaWhB?=
 =?utf-8?B?b095OWFuWmRRMEY2bks4TXBCemVPc2tVRXpxaW9zWjFlNnJyRW9PSlNJZ2Y3?=
 =?utf-8?B?bElEYXorWGhOSVhQTFlWa2xrb1dzdWZwR2tvZWQrYXVLNWptZC9xVy90enJX?=
 =?utf-8?B?VFM4ZnpSSmJabENCNExDSVd5Rk1OV2NDYjExNzNHckJCQjVHamJGQ1lqR3J2?=
 =?utf-8?B?V21xd0YrR0ZqQjRBdjRneWp1Z3EycWxYcGcwYWdtSnA5MS8rRzFud3pOOVI2?=
 =?utf-8?B?ZU1nRDBKSU1qQ0pKZU0wallvZEFkU255TTNXVEtET2p4dW9lQTRtWER0eita?=
 =?utf-8?B?Tk9UV1dmYWNudnl0RmMrRkY3Ti9hQkx5aVpZUW1CbUEyN09pRnU3eS9WVTd0?=
 =?utf-8?B?RndnWldyRVNaaTdRakpQNGFuWW84WTBqN2Rpd202RjBSM1FNengzUjYrNzNN?=
 =?utf-8?B?MmZWRXoxM1J2RkR3eEliTjRaV1MzTTRIdThnVXFIZm1kN3d0N0xhS0xHRkxw?=
 =?utf-8?B?b285SUdrM1RhNEk1djZsR3pFZTRpNTV5TnJheWMzNVpDYXA4YUhqQU9OY3dI?=
 =?utf-8?B?Qkx5RjY0VUVsZ1BGMHRsdVROV1MrOXUyTFExZnZSRC9EcTNaQ3RBN1dCUEJM?=
 =?utf-8?B?dlFrdjhRbnMzZ2k4Q0trNWgzQmdLelVvd05ncGdLM1ZQdlV3eERlYWhwN3hJ?=
 =?utf-8?B?OW9JUGY2NGZhQkJwUlRFYkNna3BZem5uS29pUncrM3Vuc1NNNmdKTUN3SnFF?=
 =?utf-8?B?dG5kelh1aURFNXU1ZXNkVWZZL3BEb0lKbERUQlQ3cVg0dzZlTFc1WFM3eUxC?=
 =?utf-8?B?UndBUFZuZFNVMG8wZlZ2QUExNG9TR04wYmVpeU1BRlBjdUs0dkxjUUtUdG9V?=
 =?utf-8?B?elJ2ZEs0UWFKQ1VPNGdDa2VOeWNtS0FMelpSait3c2t1MU4zem9uQXBCdTZQ?=
 =?utf-8?B?bGoyd08yU2JRUWNhTnNjVy9obGhZTC9rZW1kc3RIUXdMUnZLZGR3WTBwYndQ?=
 =?utf-8?B?N0R5WTdncERVQ0FrTDlEYm9qTG9Xelg4Z055SnpHcHdYVVNUSTMwMkZmL2ky?=
 =?utf-8?B?blNKYTBpTHVqU08xTGFzK0JjelhTbzFObE9HOUk1enlHSlJEM0g1WVcxT25m?=
 =?utf-8?Q?eXoByK/OpfCLA8VlxP6mtoDWt?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5D71F3A91343184992BDF5FC7E8F3683@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a727721b-b568-449c-0238-08ddbdc62fc1
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2025 02:21:45.8395
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5IxMvf6EUP/TGQnFCuLCHAeV4ECfkC5IhgXKuMRFkM6woB04t9cumh48+KQNGTHhdo3/EKPl494e95yyMDXjYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB8941
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA3LTA3IGF0IDE1OjQwICswNTMwLCBOaWt1bmogQSBEYWRoYW5pYSB3cm90
ZToNCj4gQWRkIHN1cHBvcnQgZm9yIFNlY3VyZSBUU0MsIGFsbG93aW5nIHVzZXJzcGFjZSB0byBj
b25maWd1cmUgdGhlIFNlY3VyZSBUU0MNCj4gZmVhdHVyZSBmb3IgU05QIGd1ZXN0cy4gVXNlIHRo
ZSBTTlAgc3BlY2lmaWNhdGlvbidzIGRlc2lyZWQgVFNDIGZyZXF1ZW5jeQ0KPiBwYXJhbWV0ZXIg
ZHVyaW5nIHRoZSBTTlBfTEFVTkNIX1NUQVJUIGNvbW1hbmQgdG8gc2V0IHRoZSBtZWFuIFRTQw0K
PiBmcmVxdWVuY3kgaW4gS0h6IGZvciBTZWN1cmUgVFNDIGVuYWJsZWQgZ3Vlc3RzLg0KPiANCj4g
QWx3YXlzIHVzZSBrdm0tPmFyY2guYXJjaC5kZWZhdWx0X3RzY19raHogYXMgdGhlIFRTQyBmcmVx
dWVuY3kgdGhhdCBpcw0KPiBwYXNzZWQgdG8gU05QIGd1ZXN0cyBpbiB0aGUgU05QX0xBVU5DSF9T
VEFSVCBjb21tYW5kLiAgVGhlIGRlZmF1bHQgdmFsdWUNCj4gaXMgdGhlIGhvc3QgVFNDIGZyZXF1
ZW5jeS4gIFRoZSB1c2Vyc3BhY2UgY2FuIG9wdGlvbmFsbHkgY2hhbmdlIHRoZSBUU0MNCj4gZnJl
cXVlbmN5IHZpYSB0aGUgS1ZNX1NFVF9UU0NfS0haIGlvY3RsIGJlZm9yZSBjYWxsaW5nIHRoZQ0K
PiBTTlBfTEFVTkNIX1NUQVJUIGlvY3RsLg0KPiANCj4gSW50cm9kdWNlIHRoZSByZWFkLW9ubHkg
TVNSIEdVRVNUX1RTQ19GUkVRICgweGMwMDEwMTM0KSB0aGF0IHJldHVybnMNCj4gZ3Vlc3QncyBl
ZmZlY3RpdmUgZnJlcXVlbmN5IGluIE1IWiB3aGVuIFNlY3VyZSBUU0MgaXMgZW5hYmxlZCBmb3Ig
U05QDQo+IGd1ZXN0cy4gRGlzYWJsZSBpbnRlcmNlcHRpb24gb2YgdGhpcyBNU1Igd2hlbiBTZWN1
cmUgVFNDIGlzIGVuYWJsZWQuIE5vdGUNCj4gdGhhdCBHVUVTVF9UU0NfRlJFUSBNU1IgaXMgYWNj
ZXNzaWJsZSBvbmx5IHRvIHRoZSBndWVzdCBhbmQgbm90IGZyb20gdGhlDQo+IGh5cGVydmlzb3Ig
Y29udGV4dC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IE5pa3VuaiBBIERhZGhhbmlhIDxuaWt1bmpA
YW1kLmNvbT4NCg0KVGhpcyBTb0IgaXNuJ3QgbmVlZGVkLg0KDQo+IENvLWRldmVsb3BlZC1ieTog
S2V0YW4gQ2hhdHVydmVkaSA8S2V0YW4uQ2hhdHVydmVkaUBhbWQuY29tPg0KPiBTaWduZWQtb2Zm
LWJ5OiBLZXRhbiBDaGF0dXJ2ZWRpIDxLZXRhbi5DaGF0dXJ2ZWRpQGFtZC5jb20+DQo+IENvLWRl
dmVsb3BlZC1ieTogU2VhbiBDaHJpc3RvcGhlcnNvbiA8c2VhbmpjQGdvb2dsZS5jb20+DQo+IFNp
Z25lZC1vZmYtYnk6IE5pa3VuaiBBIERhZGhhbmlhIDxuaWt1bmpAYW1kLmNvbT4NCj4gDQoNClsu
Li5dDQoNCj4gQEAgLTIxNDYsNiArMjE1OCwxNCBAQCBzdGF0aWMgaW50IHNucF9sYXVuY2hfc3Rh
cnQoc3RydWN0IGt2bSAqa3ZtLCBzdHJ1Y3Qga3ZtX3Nldl9jbWQgKmFyZ3ApDQo+ICANCj4gIAlz
dGFydC5nY3R4X3BhZGRyID0gX19wc3BfcGEoc2V2LT5zbnBfY29udGV4dCk7DQo+ICAJc3RhcnQu
cG9saWN5ID0gcGFyYW1zLnBvbGljeTsNCj4gKw0KPiArCWlmIChzbnBfc2VjdXJlX3RzY19lbmFi
bGVkKGt2bSkpIHsNCj4gKwkJaWYgKCFrdm0tPmFyY2guZGVmYXVsdF90c2Nfa2h6KQ0KPiArCQkJ
cmV0dXJuIC1FSU5WQUw7DQoNCkhlcmUgc25wX2NvbnRleHRfY3JlYXRlKCkgaGFzIGJlZW4gY2Fs
bGVkIHN1Y2Nlc3NmdWxseSB0aGVyZWZvcmUgSUlVQyB5b3UNCm5lZWQgdG8gdXNlDQoNCgkJZ290
byBlX2ZyZWVfY29udGV4dDsNCg0KaW5zdGVhZC4NCg0KQnR3LCBJSVVDIGl0IHNob3VsZG4ndCBi
ZSBwb3NzaWJsZSBmb3IgdGhlIGt2bS0+YXJjaC5kZWZhdWx0X3RzY19raHogdG8gYmUNCjAuICBQ
ZXJoYXBzIHdlIGNhbiBqdXN0IHJlbW92ZSB0aGUgY2hlY2suDQoNCkV2ZW4gc29tZSBidWcgcmVz
dWx0cyBpbiB0aGUgZGVmYXVsdF90c2Nfa2h6IGJlaW5nIDAsIHdpbGwgdGhlDQpTTlBfTEFVTkNI
X1NUQVJUIGNvbW1hbmQgY2F0Y2ggdGhpcyBhbmQgcmV0dXJuIGVycm9yPw0KDQo+ICsNCj4gKwkJ
c3RhcnQuZGVzaXJlZF90c2Nfa2h6ID0ga3ZtLT5hcmNoLmRlZmF1bHRfdHNjX2toejsNCj4gKwl9
DQo+ICsNCj4gIAltZW1jcHkoc3RhcnQuZ29zdncsIHBhcmFtcy5nb3N2dywgc2l6ZW9mKHBhcmFt
cy5nb3N2dykpOw0KPiAgCXJjID0gX19zZXZfaXNzdWVfY21kKGFyZ3AtPnNldl9mZCwgU0VWX0NN
RF9TTlBfTEFVTkNIX1NUQVJULCAmc3RhcnQsICZhcmdwLT5lcnJvcik7DQo+ICAJaWYgKHJjKSB7
DQo+IEBAIC0yMzg2LDcgKzI0MDYsOSBAQCBzdGF0aWMgaW50IHNucF9sYXVuY2hfdXBkYXRlX3Zt
c2Eoc3RydWN0IGt2bSAqa3ZtLCBzdHJ1Y3Qga3ZtX3Nldl9jbWQgKmFyZ3ApDQo+ICAJCQlyZXR1
cm4gcmV0Ow0KPiAgCQl9DQo+ICANCj4gLQkJc3ZtLT52Y3B1LmFyY2guZ3Vlc3Rfc3RhdGVfcHJv
dGVjdGVkID0gdHJ1ZTsNCj4gKwkJdmNwdS0+YXJjaC5ndWVzdF9zdGF0ZV9wcm90ZWN0ZWQgPSB0
cnVlOw0KPiArCQl2Y3B1LT5hcmNoLmd1ZXN0X3RzY19wcm90ZWN0ZWQgPSBzbnBfc2VjdXJlX3Rz
Y19lbmFibGVkKGt2bSk7DQo+ICsNCg0KKyBYaWFveWFvLg0KDQpUaGUgS1ZNX1NFVF9UU0NfS0ha
IGNhbiBhbHNvIGJlIGEgdkNQVSBpb2N0bCAoaW4gZmFjdCwgdGhlIHN1cHBvcnQgb2YgVk0NCmlv
Y3RsIG9mIGl0IHdhcyBhZGRlZCBsYXRlcikuICBJIGFtIHdvbmRlcmluZyB3aGV0aGVyIHdlIHNo
b3VsZCByZWplY3QNCnRoaXMgdkNQVSBpb2N0bCBmb3IgVFNDIHByb3RlY3RlZCBndWVzdHMsIGxp
a2U6DQoNCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0veDg2LmMgYi9hcmNoL3g4Ni9rdm0veDg2
LmMNCmluZGV4IDI4MDZmNzEwNDI5NS4uNjk5Y2E1ZTc0YmJhIDEwMDY0NA0KLS0tIGEvYXJjaC94
ODYva3ZtL3g4Ni5jDQorKysgYi9hcmNoL3g4Ni9rdm0veDg2LmMNCkBAIC02MTg2LDYgKzYxODYs
MTAgQEAgbG9uZyBrdm1fYXJjaF92Y3B1X2lvY3RsKHN0cnVjdCBmaWxlICpmaWxwLA0KICAgICAg
ICAgICAgICAgIHUzMiB1c2VyX3RzY19raHo7DQogDQogICAgICAgICAgICAgICAgciA9IC1FSU5W
QUw7DQorDQorICAgICAgICAgICAgICAgaWYgKHZjcHUtPmFyY2guZ3Vlc3RfdHNjX3Byb3RlY3Rl
ZCkNCisgICAgICAgICAgICAgICAgICAgICAgIGdvdG8gb3V0Ow0KKw0KICAgICAgICAgICAgICAg
IHVzZXJfdHNjX2toeiA9ICh1MzIpYXJnOw0KIA0KICAgICAgICAgICAgICAgIGlmIChrdm1fY2Fw
cy5oYXNfdHNjX2NvbnRyb2wgJiYNCg0KVERYIGRvZXNuJ3QgZG8gdGhpcyBlaXRoZXIsIGJ1dCBU
RFggaGFzIGl0cyBvd24gdmVyc2lvbiBmb3IgVFNDIHJlbGF0ZWQNCmt2bV94ODZfb3BzIGNhbGxi
YWNrczoNCg0KICAgICAgICAuZ2V0X2wyX3RzY19vZmZzZXQgPSB2dF9vcChnZXRfbDJfdHNjX29m
ZnNldCksICAgICAgICAgICAgICAgICAgIA0KICAgICAgICAuZ2V0X2wyX3RzY19tdWx0aXBsaWVy
ID0gdnRfb3AoZ2V0X2wyX3RzY19tdWx0aXBsaWVyKSwgICAgICAgICAgIA0KICAgICAgICAud3Jp
dGVfdHNjX29mZnNldCA9IHZ0X29wKHdyaXRlX3RzY19vZmZzZXQpLCAgICAgICAgICAgICAgICAg
ICAgIA0KICAgICAgICAud3JpdGVfdHNjX211bHRpcGxpZXIgPSB2dF9vcCh3cml0ZV90c2NfbXVs
dGlwbGllciksDQoNCndoaWNoIGJhc2ljYWxseSBpZ25vcmUgdGhlIG9wZXJhdGlvbnMgZm9yIFRE
WCBndWVzdHMsIHNvIG5vIGhhcm0gZXZlbg0KS1ZNX1NFVF9UU0NfS0haIGlvY3RsIGlzIGNhbGxl
ZCBmb3IgdkNQVSBJIHN1cHBvc2UuDQoNCkJ1dCBJSVJDLCBmb3IgQU1EIHNpZGUgdGhleSBqdXN0
IHVzZSBkZWZhdWx0IHZlcnNpb24gb2YgU1ZNIGd1ZXN0cyB0aHVzDQpTRVYvU05QIGd1ZXN0cyBh
cmUgbm90IGlnbm9yZWQ6DQoNCiAgICAgICAgLmdldF9sMl90c2Nfb2Zmc2V0ID0gc3ZtX2dldF9s
Ml90c2Nfb2Zmc2V0LA0KICAgICAgICAuZ2V0X2wyX3RzY19tdWx0aXBsaWVyID0gc3ZtX2dldF9s
Ml90c2NfbXVsdGlwbGllciwNCiAgICAgICAgLndyaXRlX3RzY19vZmZzZXQgPSBzdm1fd3JpdGVf
dHNjX29mZnNldCwNCiAgICAgICAgLndyaXRlX3RzY19tdWx0aXBsaWVyID0gc3ZtX3dyaXRlX3Rz
Y19tdWx0aXBsaWVyLA0KDQpTbyBJIGFtIG5vdCBzdXJlIHdoZXRoZXIgdGhlcmUgd2lsbCBiZSBw
cm9ibGVtIGhlcmUuDQoNCkFueXdheSwgY29uY2VwdHVhbGx5LCBJIHRoaW5rIHdlIHNob3VsZCBq
dXN0IHJlamVjdCB0aGUgS1ZNX1NFVF9UU0NfS0haDQp2Q1BVIGlvY3RsIGZvciBUU0MgcHJvdGVj
dGVkIGd1ZXN0cy4NCg0KSG93ZXZlciwgaXQgc2VlbXMgZm9yIFNFVi9TTlAgdGhlIHNldHRpbmcg
b2YgZ3Vlc3Rfc3RhdGVfcHJvdGVjdGVkIGFuZA0KZ3Vlc3RfdHNjX3Byb3RlY3RlZCBpcyBkb25l
IGF0IGEgcmF0aGVyIGxhdGUgdGltZSBpbg0Kc25wX2xhdW5jaF91cGRhdGVfdm1zYSgpIGFzIHNo
b3duIGluIHRoaXMgcGF0Y2guICBUaGlzIG1lYW5zIGNoZWNraW5nIG9mDQpndWVzdF90c2NfcHJv
dGVjdGVkIHdvbid0IHdvcmsgaWYgS1ZNX1NFVF9UU0NfS0haIGlzIGNhbGxlZCBhdCBlYXJsaWVy
DQp0aW1lLg0KDQpURFggc2V0cyB0aG9zZSB0d28gYXQgZWFybHkgdGltZSB3aGVuIGluaXRpYWxp
emluZyB0aGUgVk0uICBJIHRoaW5rIHRoZQ0KU0VWL1NOUCBndWVzdHMgc2hvdWxkIGRvIHRoZSBz
YW1lLg0KDQo=

