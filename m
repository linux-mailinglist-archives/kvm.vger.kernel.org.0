Return-Path: <kvm+bounces-47804-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E67E6AC5932
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 19:54:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C06159E0376
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 17:53:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A620280304;
	Tue, 27 May 2025 17:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XqTZAsab"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F242566;
	Tue, 27 May 2025 17:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368445; cv=fail; b=eXd2ei2zwMBxFL2qOtcwE1KfJ7I8gs6EGvXHexPWqZEb69Au98B12JBDb0jcxNqCYhPyVuS7cgFQzcBrRk8MFCUpoyjsIM4z2iXFknSqJStN8lng2w1SasJE4YT80iO/l3CjI8Ur3KIbT79eHT3DlyCuIhW0qTdhWKMELZHSX48=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368445; c=relaxed/simple;
	bh=f4iydiMMwdTuJdUIjCoh8M6cgeX/PLXCD9mol82P/QY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hWWtse9R5t++4PSHuVLNgzLE+V+fp0gpvwlfll1Yex4cGYlKfftOKjE6BOn8H//P+nYXjUi3uoV+Nh7sfyBaqmYPLXSKx9wdoQp2Wx7mJQ/uT5p+gK0j5uVvCShPDkHFNLPAw8b7QC1QzG/8s7/qQIS0BctBoI5mvo6TSc+yHAM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XqTZAsab; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748368443; x=1779904443;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=f4iydiMMwdTuJdUIjCoh8M6cgeX/PLXCD9mol82P/QY=;
  b=XqTZAsabORvG9DLYrhP7PAJeuqsQhaXieE7b6g6cj2/xxZ5fKyPTadeN
   wLG2mKFyYAqQZ2TKKIJ+dYSoilkY6fKT0x1LBasPu+UIQdRiSgf+rvw1T
   7XIdw/pazpPjnngkXZXfCaIxStx5abwkaMrRQ+j5dYdcwoulJl9fyKTlF
   yIqE4HwCpYwEWjJF1FhT5tKU8QAxcWm8RqvBIUwHmv11kDCTjSioBBr1w
   qXe2D4cUrrbXR6nJR2SivA8YoXu6hKEXspCO16+dO2qlT3O3ChwCFXIq3
   kldVqnViy9E+C5r5RUKY/58dcx5f9hLD4jT/aECTP4FyCH1S18Ed6oUJU
   g==;
X-CSE-ConnectionGUID: 8xSXJFi3RrGq39rkahtEeQ==
X-CSE-MsgGUID: rEkrjGmISQufZQALf+nNcQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11446"; a="50248711"
X-IronPort-AV: E=Sophos;i="6.15,319,1739865600"; 
   d="scan'208";a="50248711"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2025 10:53:58 -0700
X-CSE-ConnectionGUID: pv1aiMvNQV+Ubj/CXRTB2w==
X-CSE-MsgGUID: TSvOGrfzT/+tRTEj2UYxdw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,319,1739865600"; 
   d="scan'208";a="147787163"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2025 10:53:58 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 27 May 2025 10:53:57 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 27 May 2025 10:53:57 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (40.107.101.62)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Tue, 27 May 2025 10:53:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=s91KC3/HK5KpOzCNVHkVpFvbdh0C2ccVFs4OX1Pg3Et0I5tS+nESKpLIXItREsdvT7jJR3yYYNDg7zOjB/CXkHCErUQpKkbZf5LMM+QPffo8atQTS+GhBtWrfyimbUxUYQQDkUduBKUdoBF7V6Ym9EnJ/sMjkfQMqm0DTyMdsyJlIYdJt3WmC+BGTXakvvgXmzDR0Y8Gfa5gNsZ/hp2fMtyfED6Yv5ejb5p+BlSyJRNeRB6WGghjQpWxj4JW912/rRxY09f5YgKdlLCe6vNia8MP0G9U+G/PyXYT/v5k5LmwnOIjZT9X9kYw5oVH63g5kBYJuHPX2xbvCkHWOTwyXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f4iydiMMwdTuJdUIjCoh8M6cgeX/PLXCD9mol82P/QY=;
 b=g+Gp4na37YoKVaYeAF2pVxlrm3DAvi6SDbI5foTFY7027WM7yIw0ZJ5HhUpCXWuoyyyyOOqzeB2WCsgU5DIYqjIa4SuhsaqwI4ojvCPq+F1DSSGpDiHrEqvnHu1PWpuHWKVQLorhU7ZRzY3gojWTTZgm+SD0IUqqipYQ+cssTT+2Vshq/G7XWhXzEjeh5joUOSSW1YhyJFsKW1dK7AdI2Hjmt20r0RQmwzTujDH9Gp+x1zXKeShPUcu7OfJ7kBf1JnJ2t2oE07G+njcUGB9VI1bRU2hK/P/U3bz9BhhB9irTVdqVf8PfLk+aSn5wiqGItABv+hnpzPEw17/ZZHBbtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA2PR11MB5164.namprd11.prod.outlook.com (2603:10b6:806:f9::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.26; Tue, 27 May
 2025 17:53:50 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8746.035; Tue, 27 May 2025
 17:53:50 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "eadavis@qq.com" <eadavis@qq.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "hpa@zytor.com"
	<hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH next V2] KVM: VMX: use __always_inline for is_td_vcpu and
 is_td
Thread-Topic: [PATCH next V2] KVM: VMX: use __always_inline for is_td_vcpu and
 is_td
Thread-Index: AQHbzzBNOoKObRv9l0GxGP3lBQz+EA==
Date: Tue, 27 May 2025 17:53:50 +0000
Message-ID: <c281170eeeda8974eb0e0f755b55c998ba01b7a2.camel@intel.com>
References: <58339ba1-d7ac-45dd-9d62-1a023d528f50@linux.intel.com>
	 <tencent_1A767567C83C1137829622362E4A72756F09@qq.com>
In-Reply-To: <tencent_1A767567C83C1137829622362E4A72756F09@qq.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA2PR11MB5164:EE_
x-ms-office365-filtering-correlation-id: 35dedef7-e778-4486-fab5-08dd9d476ff5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?b0lqOW1ySktBWmduYWRpbmcrTEZ5VDJiRUt4RlQ2dVdJM2ZNZkQrRzlFRGx5?=
 =?utf-8?B?TEdFcU80N01QQ3Q1Qlc5cUtnZVFxdy9hTURWZFZ0aGtRZzcvTi80dlNUQW85?=
 =?utf-8?B?WWU2N2VnT2psOFo5bXRwU3d6R1R3U0t6Sm01aGlVYnoxNnBxZ3FpS2JIRWN0?=
 =?utf-8?B?QytkRzBqM2pYRTNsR2FHVE9NeFBvZEptTWVpSGV6K1FwbnY1YW1FOVk5RGFl?=
 =?utf-8?B?ZGJTYndxSStnM2gxSFlWaGpYY3dRejFGYkp5VmJLRVBYMTBtN1Y3L1VWcGZu?=
 =?utf-8?B?OUc1Qm1weFZVL1dmTDZ1QUQ4OWQ3RFhhTHVmYUtZYXB5Y0tYNi9OYVkzMmto?=
 =?utf-8?B?NXI4YVI4V3luU1VyNEJBdXltYmtpMFNBL2dTWWRyemdGVTlGUVNmSW5MY3NY?=
 =?utf-8?B?S29PbkNkYitXUnJjUEZmSzlhbEttenVjTjJvSkJpcDNiYlV4RGpFb2xvSlMz?=
 =?utf-8?B?dDNvZER5YTBGVFZaU21wU1dzcGxySEg5dDBwM0w2NFRuVFMrNjJSQlV5aXdx?=
 =?utf-8?B?YUxOcStvQ1REYjl5OGNjUFZKeW5zVjRtMTNSZWxRQ2VIZ2J3a0pyZnlxd2Nz?=
 =?utf-8?B?K1FwZDkzT3ZNcFlBZFBqeEx6bk9qQWxHa1RDdko2OXV5R2MzV0JlSGt3S29m?=
 =?utf-8?B?b2tlK3ZBOEJ4QXhzQlpLemttd3kzYzJsWnZVelBjRUJ5dGFsSWdtYzZoSFVy?=
 =?utf-8?B?aUY2dHMxcVJSL2tiSWJBSk1xelJyamRBVGwxa3ZtNSs4aXJGaUZieDdYSE5X?=
 =?utf-8?B?a3gyclFWQzl1ZDFqZkVHRXlmWkc0YWxWUW82OWdJY0xXQzlIWFNGUko0cUtM?=
 =?utf-8?B?TzFxTmZiSWJYQlUvRTlrMW4wZWpsWDB2YVlyM3E1dkNFVDJOT2VXVGhzUkVh?=
 =?utf-8?B?UGs4WTUrenNzWE5qTnNXTm5HdllVT2lrMjZEaVYweWd5Y3V0bk90Mk93cUdZ?=
 =?utf-8?B?NHBFZ3ZjNXVDZ0RQUVRRQ2kyVnJYQi82ZFRacnF4N1Z4cWU3TnAzL2FGQ2xr?=
 =?utf-8?B?SkdUSlFnYm13dFJuVFhaelpLQUhkaE0wNDBxaEF6ODBsMmFRNjJkcEpVWU9J?=
 =?utf-8?B?eThkY2pwM1F3OTFxR1dwNmM0UXhhRHJuUm9sWnUwZnpMNHJKUHRJOXd1S2hy?=
 =?utf-8?B?K0tJVDlPMFlleWhReStKRnVQNndzdW5CYXlNSm9JZDBkTTVQZkltMFJCZkFL?=
 =?utf-8?B?cEZ5YjZVa1RaczdQazlvMHVURlMyNWpxUXhKUzJXQVpVUzJLTVRDMDZSTHJt?=
 =?utf-8?B?MkJVWkhZRXN3UmRwaG4yWmdXWHJZclQ2Qm9pRlVxbUVNNWhoaGRncmZQLzlx?=
 =?utf-8?B?Qys1S0paNzh1V3RWT2d1K1hYbXB0ZU42eEhWdVJBWkgyNStSVDRaMXlmSC9u?=
 =?utf-8?B?OCtTUS9iVVY5V0FKWnRxSnBteHY3R3ZOSHV5UXkrVFNLYmdYYXBIdE42SEU3?=
 =?utf-8?B?SlA1U3RJMWJxVGswZlVCVHNLSE5JN3ZJRFpPSUVjbG01TktjTW1iS0NMenE3?=
 =?utf-8?B?b1FleUV2SldmbDhzdGUzMUphdnVEa0pwWHFzNkNGYjNxSkZXNlZuVWI5a0s0?=
 =?utf-8?B?bXZiMUlOb3c0REtTdGVuSnpLYmF4K2szMHlaWjJwVHBCMklGWEZCOUpnNXhI?=
 =?utf-8?B?TU5rSGo1ampzUW5zb0RUeGV6NGpGTVFOR0VUODI5S0I3WlVrQlVtSzdwR1d1?=
 =?utf-8?B?NnV0WEFlTUt6VGRKZ2JKdS84Zm16TW03eUpaMitKeDZyanY0anNmRm1ScWNQ?=
 =?utf-8?B?SEJWcXBWSitqN1VVRjdvaVJudWw2bFV3UG1ZYmcxeEluRU5semFDZitmQ0VF?=
 =?utf-8?B?Nnp4aVlXTnJIa2IxaG52bGpSMndTQ2h0eDRzUVFtRWFJOFNhdTBtOVlqZzZ5?=
 =?utf-8?B?dUhIQkNCZDQzVW8rUlc0cTVFSGlPUFNqWGtPK1NIeXR4SnN5c1BtOFNRMWZ5?=
 =?utf-8?B?TXdBc0U3dFpUR3kvdmVTSTZTWjhYUHNOQ1plSmJGNXh5U2JhYXl2eWxmK2NR?=
 =?utf-8?Q?M4/VSrTZBs/kxdyM35S0HL4pq8CL7E=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dVBCMDZ1ZzdvV3RwcnJRbitOOElIdGkyb0NjVzVld0lWQ3hXMVd4MUZpUFFV?=
 =?utf-8?B?RSs4ZFlJSkV0bjNjRUZBd1Z0ditYZ0hHWUMvbmludkdzRkdvV2VXYWRncVFX?=
 =?utf-8?B?TlRYZDkrdVd4ckZzK3ZrUkplb2g1dyt4V09Rdk5ZcUhwbVgzaVM3QjhYT0kr?=
 =?utf-8?B?K3pUNHlnUzRsam1UN0hxN29uZTdHY1ErNzI4ZVMwZUJabDUyNHpVRmthVHhN?=
 =?utf-8?B?STU5bXoyQjRFVnVOVVhDNFpmMHhKZ3lFZzdVU1lWVGpxUlhOQXBvV0phTDNT?=
 =?utf-8?B?Ny9hcWx5SkFWRkJ4QkNSLzc5YXV2dlpjUXZjTHh0TEdHS3lqVVdBN2M5VXh6?=
 =?utf-8?B?VGYwVjZSL1V4dEtTR09RYXdHRmhEdmhUVHdiVHdBb1lEWmxqc2FvRGsrN1Fl?=
 =?utf-8?B?VFhBTDZJNGJ3STExVEZKYmFRRzUvc0xYakttWXkwY2YwVjY0R3ZhMktQVSt5?=
 =?utf-8?B?Smg2V0cyZ2NRV3NlekhPM1JxalZrTGVITlFodTg1cDRGQ2NaSzZCV29zWUto?=
 =?utf-8?B?YTNhOHhKUTB0NzZKWmVXRWhTUndmS1hBa3hieGpla3NOSFBtVEMrRW9wckI1?=
 =?utf-8?B?dXJFREIwOHI5WHlNRWFGdk9ub2lUSjhRZXkrakFJVjlLSVRWQVB6ZEZRY2ZJ?=
 =?utf-8?B?eXl3RTFSM1pNMTBkUDZYRTNyS3lOUmxMZFVNYks5QWtKZkNJbWN2STdXM1Fn?=
 =?utf-8?B?VXdzZDUwSEcxMVIySUNaUXVwRU9uNFNGYXdIcFZKa2poZHNXaFBKSDkxSlFn?=
 =?utf-8?B?YjJsTStDcmt2L2NMUmtuWThHeW9NbVUrMjJKa2JkMG9YMHNSWlBuZnBxM1k3?=
 =?utf-8?B?RmhCNjNRK1p0WER6MlV2WEdySDZ0ajFzYUkzUlA3clJ4WkxQRTVxbklZa0p1?=
 =?utf-8?B?VkhjaWwyNDhTMzhYbEZ2RnFyMURJcVRoK0JVcWIxQU9KVmFVTWp3VzBRSmdo?=
 =?utf-8?B?TmQrRHN3aDBSY2M4Y2piby9HaWdzRVJuaXY4T0lEeFZIRDRiUkQ2K2xmQlNZ?=
 =?utf-8?B?TkFvR0NHWTVtWHRkTmpRUTlaaHRDa1NIZ1Vhd1QyVEN3OVVudlByNWptejV2?=
 =?utf-8?B?YisxSTVERkZnS1k5YVJxUmEvQWRoczdzdUEzZXJqQlQ4YTRCVC80SHp5VVVP?=
 =?utf-8?B?VW9ydThsYUpJS0JCR2VlUWVVeDRYNWp4TEtRNEVFVkNDT2d2b2FSSlFrQytJ?=
 =?utf-8?B?WHE2NCtodW1BYktLaXFGTW5NVlRhSmNwT001VUZ1MkVlMTluaDVRdTFYSDdL?=
 =?utf-8?B?U3kwZ3luRFhmSllienlhL28renVzbTFETkZ6MWRtL1RBZitOOStXSEcvWHJw?=
 =?utf-8?B?UGxvL2lVUnYzYVl2cm9FT2xuUzJxTjlaK1lJM2l4NUVmM3JuYXlsVEp1ZTM0?=
 =?utf-8?B?WFVMR1I5dnpnZGFOZzJJOVVCT1JMa215eXRiUnJhNGVUUDU3MmRuc1NOek5W?=
 =?utf-8?B?RkYzaUVDbUtXSHlZbENMampwYmVGUG9yVW5wVXdCRCtmc2ZJZytSN1JnWXMw?=
 =?utf-8?B?Wm9PVFpQWHZ4dVc0bkc0Ry9VQXVEZ1VCWmRmUWRhU25GKzBLbFcyUDQ3Umox?=
 =?utf-8?B?L1B0cndYNHpzYmtRWkF0aTNtQkZwS1dmV283V0NhVUdaRTdRTXJ3QWRCSGJX?=
 =?utf-8?B?QVpiU3lQTXRrd0lVNU1jK2kyenE4aDFMWk1FdVlqR3haVjZJQ0cwZXBrbHQw?=
 =?utf-8?B?anFyWXIwVVNqS2RLNWJrejB6eDdkVGRvYVFrd0tEQ1hMWmtMNHF3NjZDNDBC?=
 =?utf-8?B?a3NRODJrSGtoYk1ncHpSOGpBc1ZEdzFmaDRRUWxURGtqaE9hZ2JlY3lhLzI3?=
 =?utf-8?B?WlhneWlwbUY2eW04NHN0K0ovckl0M0htb0xwS1RpOHJMSWt1ektlTHFIOE5q?=
 =?utf-8?B?a01ISHVkMGxlUTlad2RVMHdRSnkvV1FCbDhOS0tIVWNCaDRBTXAvQlZrZFNJ?=
 =?utf-8?B?c0RwRU0yVXZ2SXN0bWhhOWwrTlUxVjh2R2VvNFQ0TTZMRmhRdmpoRTZ0akJo?=
 =?utf-8?B?N3ArQWMrNUU4RWdvSGtmK1M3WTRZTUZwUEcrc3pmSTVjT3d3NUc4aGozeUtv?=
 =?utf-8?B?QTZxOU9qRUwybXovb1hOclBuOXhaeTZoMXZCcU1taC9iZHM2dTBkNlY5U2I0?=
 =?utf-8?B?bTllS1ZTclZNcThzb1NrcnNjSFd2eGsra2NHOGxSNm9ROVhQbkhSdEIrdUha?=
 =?utf-8?B?d1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <04F0EBC899A44C48896902113C49A7B1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35dedef7-e778-4486-fab5-08dd9d476ff5
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2025 17:53:50.2500
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5uklxTNGzSxAkRHbqP8Abj/UzFQm9EF8vVhPbMMbVtph/yuqXpe2dPjVKk6kW4karjOZrrU1cGk1pp5a2bYpf/x8Sjn0qcuGtDjjJi8Qu24=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5164
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA1LTI3IGF0IDE2OjQ0ICswODAwLCBFZHdhcmQgQWRhbSBEYXZpcyB3cm90
ZToNCj4gaXNfdGQoKSBhbmQgaXNfdGRfdmNwdSgpIHJ1biBpbiBubyBpbnN0cnVtZW50YXRpb24s
IHNvIHVzZSBfX2Fsd2F5c19pbmxpbmUNCj4gdG8gcmVwbGFjZSBpbmxpbmUuDQo+IA0KPiBbMV0N
Cj4gdm1saW51eC5vOiBlcnJvcjogb2JqdG9vbDogdm14X2hhbmRsZV9ubWkrMHg0NzoNCj4gwqDC
oMKgwqDCoMKgwqAgY2FsbCB0byBpc190ZF92Y3B1LmlzcmEuMCgpIGxlYXZlcyAubm9pbnN0ci50
ZXh0IHNlY3Rpb24NCj4gDQo+IEZpeGVzOiA3MTcyYzc1M2MyNmEgKCJLVk06IFZNWDogTW92ZSBj
b21tb24gZmllbGRzIG9mIHN0cnVjdCB2Y3B1X3t2bXgsdGR4fSB0byBhIHN0cnVjdCIpDQo+IFNp
Z25lZC1vZmYtYnk6IEVkd2FyZCBBZGFtIERhdmlzIDxlYWRhdmlzQHFxLmNvbT4NCj4gLS0tDQo+
IFYxIC0+IFYyOiB1c2luZyBfX2Fsd2F5c19pbmxpbmUgdG8gcmVwbGFjZSBub2luc3RyDQoNCkFy
Z2gsIGZvciBzb21lIHJlYXNvbiB0aGUgb3JpZ2luYWwgcmVwb3J0IHdhcyBzZW50IGp1c3QgdG8g
UGFvbG8gYW5kIHNvIEkgZGlkbid0DQpzZWUgdGhpcyB1bnRpbCBub3c6DQpodHRwczovL2xvcmUu
a2VybmVsLm9yZy9vZS1rYnVpbGQtYWxsLzIwMjUwNTA3MTY0MC5mVWd6VDZTRi1sa3BAaW50ZWwu
Y29tLw0KDQpZb3UgKG9yIFBhb2xvKSBtaWdodCB3YW50IHRvIGFkZCB0aGF0IGxpbmsgZm9yIFsx
XS4gRml4IGxvb2tzIGdvb2QuDQoNClRlc3RlZC1ieTogUmljayBFZGdlY29tYmUgPHJpY2sucC5l
ZGdlY29tYmVAaW50ZWwuY29tPg0K

