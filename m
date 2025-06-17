Return-Path: <kvm+bounces-49743-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DD795ADDAF4
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 19:55:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7ABF34A1067
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 17:55:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5BC32749E7;
	Tue, 17 Jun 2025 17:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g5B1vZOB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 058DA273D77;
	Tue, 17 Jun 2025 17:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750182925; cv=fail; b=Tl8os350ZlliBY+pdaKfwBt+SGzTSks/Xw9GUDqVPqFktvNnnmjmbbyDZE3nJOvgJHt5TxVt7EqxhKSCphfGj6/J60gZn+Qi8utjYmqUoPh7WIi0k+sf3eTU45tGmV/LbmI3I/9Xeg/q/tom8fbvfJTAfITAu54h9dXKJYSt2bU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750182925; c=relaxed/simple;
	bh=ZNeu7m3Fh+J2xfhJhleqxjTxwXXEd41Ulf6sG39kE4U=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=UGDt030cVUqr50Fl+I1iVhH9IugioZomv2SBmm5LGR2vE/CsB8GQz3U/WAH8z4t/31wcnH0iHVVg2zusI+KzAzmcdHjhDTVKTfe1QXuYsbUFFn1o1P08XXLfN9aAkQQFEzvhghIRw0NuiB4/3/V+f9vLAFG0SILc8+MIC/YHWiQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g5B1vZOB; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750182925; x=1781718925;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ZNeu7m3Fh+J2xfhJhleqxjTxwXXEd41Ulf6sG39kE4U=;
  b=g5B1vZOBksbYdSSStm5Q2fc44fwZaHHFWfX+XtXttR0UdiDni2zkZWlL
   W95Z7vYthuXmLTAP13zFmPEqU9mu165hj7UER9NoKhbfSxwj0ba4sU3pq
   GnuyX9h9+LYn+ilO5KrtDZbUSI6f5Yc0E3DONF/QoGyhDnEj/Gbln9Nmg
   1twaGn1U9wnj7jEi2/906NouVQGv7fyVUAErSKOeeg2/0536m4Hfk2Kgz
   OQCV7rMYb2IqkehDRfKrQqG9BLjm73NPF0m1985zJMS69kEOGLh7FE6Ln
   KolZAxSK2LUy8F+LPdovUz31guASja27c5NdBlxTy3UJWD5aecyQyiU1y
   g==;
X-CSE-ConnectionGUID: TWYBYGP6TmueaNC+27/sbg==
X-CSE-MsgGUID: baqqImYuQw2g/BXjywX1Xw==
X-IronPort-AV: E=McAfee;i="6800,10657,11467"; a="69824432"
X-IronPort-AV: E=Sophos;i="6.16,243,1744095600"; 
   d="scan'208";a="69824432"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2025 10:55:24 -0700
X-CSE-ConnectionGUID: hPElc7qaQM6gsdtd6PN6WQ==
X-CSE-MsgGUID: zCkYV6giQjC4bKCby20Gjw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,243,1744095600"; 
   d="scan'208";a="149749443"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2025 10:55:23 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 17 Jun 2025 10:55:22 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 17 Jun 2025 10:55:22 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.57)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 17 Jun 2025 10:55:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XcYW2368127FgtulOR047bjaSVoDoF2fLPNWC40Y4RBoq+1+2FIJd4CM2LJpNdFKvD/Lmb6dJ0Fv/GNdZ/BzkU4CB6zDO2PscUkx0sgWSHujp6cXkKmjth6+wKhN8yIsP/ikubioCFZuOkhpIZ1L6lp4lBhQb0hSnRF1rG9B+JS+cKK0rsNb+NTLjMjWG6bmjZkZPDg8eNDQBehV6psUBkwv4N77l51bN9qLR0tP6iVdx8XLfgXpSmYNx6Yk+r+kKo8gH7a8horTAtIr+33/7ayi/M7z+frt2T5Id8QeUqQ4ptCCTtsOnSSVsKRe9N9ORUHHFqHqPMnlRzhbcFjWDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W/d7elhob1GVZGej3ekL3l8B7vBy6A90+l7DzGl5VdA=;
 b=yJJiabPNw7uECwZ27uE6j75YHiQAIICrnwZvM3idArgDHF4W554N6PLpbV22auh8enjh69Ukh0YvvdaF57gS/l+8bx/zYsYlhtsFbjtqEaaAUPZtx4aKPLQYwu+Lo5ga0KhFanoFJw/N80wUBBnH7+cuolC3WSDpfuffmEYtT31yIGSGzZlhOU5gOTVsQQsQKVw2p/xnaebC/JXPVAXe74CMam72sh65bufKiN9TxO8RnkrK//NfbOqBJR4gtm6TE8FLMIkCF5iqp0/UyGcYXv32fifFlTXSfVcKBVkyZK4e5I9zzqyML5q/WwnJS3zqyxbPxsJECBaNCX5BL9MsHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3320.namprd11.prod.outlook.com (2603:10b6:a03:18::25)
 by IA1PR11MB7344.namprd11.prod.outlook.com (2603:10b6:208:423::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.19; Tue, 17 Jun
 2025 17:55:20 +0000
Received: from BYAPR11MB3320.namprd11.prod.outlook.com
 ([fe80::e8c4:59e3:f1d5:af3b]) by BYAPR11MB3320.namprd11.prod.outlook.com
 ([fe80::e8c4:59e3:f1d5:af3b%4]) with mapi id 15.20.8835.027; Tue, 17 Jun 2025
 17:55:20 +0000
Message-ID: <80636908-b355-455b-bac8-4703210ab65d@intel.com>
Date: Tue, 17 Jun 2025 10:55:18 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] x86/traps: Fix DR6/DR7 initialization
Content-Language: en-US
To: "Xin Li (Intel)" <xin@zytor.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>
CC: <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <peterz@infradead.org>,
	<brgerst@gmail.com>, <tony.luck@intel.com>, <fenghuay@nvidia.com>
References: <20250617073234.1020644-1-xin@zytor.com>
From: Sohil Mehta <sohil.mehta@intel.com>
In-Reply-To: <20250617073234.1020644-1-xin@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR02CA0028.namprd02.prod.outlook.com
 (2603:10b6:303:16d::7) To BYAPR11MB3320.namprd11.prod.outlook.com
 (2603:10b6:a03:18::25)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3320:EE_|IA1PR11MB7344:EE_
X-MS-Office365-Filtering-Correlation-Id: cffa9803-f4b8-49aa-2fb8-08ddadc82045
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?SEhtMHNoSElkQmM5aDRWUUJ5cVhvaStHTFJQd3o5aGh4OElPUndpcmljTUVT?=
 =?utf-8?B?VmpUbzJPMHcvcVV5QlB5WmlNRFFNTzc5ZFlSY0NndXBKVjZmb2I3ZzYwdTla?=
 =?utf-8?B?a1dONFM5bmlzMWJSK0s4Mit1aEM2aDFERHBHNDhaOXg5Q3lBdXN3T1hRbFlI?=
 =?utf-8?B?U29rQXE1Sy9La3FLM1JiNXpFdUhxZkl2Q2o1U080R20wN0lVbWp5SlVQcjJn?=
 =?utf-8?B?YU04dHBGT0FXMElFbU9sanZYaHFhRlJVVlhEMVBua0g5QXZQRktGQzI5NUEr?=
 =?utf-8?B?b1dCdW5sYXRYTVBDRVNoSU1sYlhDdmFaeU4za2xXbmVvdUlXeHlPaE1iOFQ4?=
 =?utf-8?B?WnhkZElwOC9KSm1xV2RacjFxTkF6dGVKL2hGRi8xSUNkNTVMV2xsRVNHR1p0?=
 =?utf-8?B?UUYrVHpkR0lER0JqbTRJazNFdEEwTnp4UXNvZVc0UVVHTHU2Y1hlWnVYT21J?=
 =?utf-8?B?WVhqZGdBd3dFbXlTRnk3REx4V1NYSnlFQjliZWhoU2w0SGxqbUhvTU5iZDdL?=
 =?utf-8?B?WHRvdWs3Qk5oY09LemhMSW5CdW53OHRPOHp4ZUhKTEhGS1NOV3NHWFM2cWd3?=
 =?utf-8?B?WDI4U0VmbmZobWI0Nlc0VGhjM0V6MnRCUEdpcDZ4bXNNT0NRT3h4Y1hod3A4?=
 =?utf-8?B?SlFIS2YySzJ3RjZlTVp0ZndBa2RoVFBzMUN5OGJyK2tRVXIzZTFhTlkzbGpi?=
 =?utf-8?B?VW5SMitCRFRUMUU3Ynk1T1diZHA0QUp2UUhHSUVVTDhoTWJtMFVLK0czZjJD?=
 =?utf-8?B?OGpoSmxYUnVKMDFtTzBwRXVEb1RjeWcybncrVkcxNmd2QlBlQTBKUVBoS2E1?=
 =?utf-8?B?Z2RBOHMzNCtvdnVSemN4dnE4KzAyRHRsMVhWS2VoYXBBb1VkL1Vrd0Q4dXB2?=
 =?utf-8?B?UHZXUUtzbllFMUR1UXhURzF6WnprVHMzaVphOGNYL0s4MlJWaUY1bThBSkFo?=
 =?utf-8?B?OFpRQmxLOXRpTEVjazNHQlFDeFFHRjltaERaVmpCTU8yM1Z1YnZnSTdURitB?=
 =?utf-8?B?NEFOcEpOSG4xT2UrVWUzNitPYTFwRjZuR3g2c1lreHpTeG56clY4ZnJtNlVo?=
 =?utf-8?B?QlRsSWgrTnA1NG9LanI4WCtUdStnY2hoSGpVa3dDN3ZIa3J5dzY4S3Z0K214?=
 =?utf-8?B?VE93a3pSb2RLalZnMVdZb2JWeEVTNndWUDhjQjdMNlk2QTY5a0RqWjRqWWlW?=
 =?utf-8?B?VDkwU29tQUdoWktScVpDNTczNWtRUmJwVGNJbXF5M0xPQmNXTlpsYklWaDBz?=
 =?utf-8?B?eG9BU0RZWCttWlJyN0ZqeG91SUFNUGUxVkd5UmpMUGlFRG5ZT0kzem83ZWMr?=
 =?utf-8?B?c3UyR2YwKzY3Q1FZYnFOL05Xd3JySk5YTUV6Q1BhbDVBaUlSVUdwV3lWKzk5?=
 =?utf-8?B?bzBJdGYzTGpIUkc1Y29LNGR1aWl6OWJBay9rZzUxNkVyd0drbEV0VEJpaGJx?=
 =?utf-8?B?WXdiMGFnN2tUemxOMXNFdjFoY2JpWkxLN3BJb3NFNVgrMzA1UU5xTHYvSWFk?=
 =?utf-8?B?THlpMUMrbWVQeXBPUFRqaW1xL2lNeS9LK2hUK0xHZWlHM0NvSEh2dnordHBa?=
 =?utf-8?B?eGdZbUF5OVhCUVFQdjZ3c0t1c3EvMG5DcDBqUnc3QzNFMFUwdGV5UWVNL3NH?=
 =?utf-8?B?RnhsS2o2NExGbmd0ejFKVUxZcHBtcDNnT1lDSG5vMXZkQUp4NGdxSEsrV21W?=
 =?utf-8?B?TEpJS2NQLytnbm1vSUtja2t1MFFYMENaand4L1NoL1Zma2NTcHNLRlduNFBv?=
 =?utf-8?B?WHM4MFBKRVF4azdIZ0FqR2NaMDZIbTd1d2Y5VFZPck8yVXFnSThkTnFGbzAv?=
 =?utf-8?B?bEQ0YnV3cngrRkpxRVhabUZIRmtJS1F4QnY4WXpOeGMveEZxZS9CUTdwdDdB?=
 =?utf-8?B?blJZTm5XZmVJK1RyNDdCK1p6VkF3SDhFYThLd0c0bHlpTEc4Z3dDQ215djlX?=
 =?utf-8?Q?YTbAp92/NXg=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3320.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UkN0Mnd0VUx0YmtkeFUyWGp5VXR1dVJ0Q0dIYmsrcXQ5MllleGVoT0xSM0k3?=
 =?utf-8?B?blEwYWJ1b2NnSFpsaXdPOGRDQnVUN3Ywd1ZpckVrMUVaWFZLMkNSc3dvb0p2?=
 =?utf-8?B?aDdnSG9lcENjbTYrZW5aS0JBeVNDR0NFMVllTDFSaDIvNkh3OUdZRzE1OGxt?=
 =?utf-8?B?Y0x0NGtKYlRabEJkL2J6UVZReDQ3MmFrZ2t2aFUranBEUHZDL3JTbkJHL1RX?=
 =?utf-8?B?S0NJWGZGZ3lkVjBVVzVYZ1ZhTkVXbHl6a1ZYUGEybGFEZytiMkxNenEyU04y?=
 =?utf-8?B?aHVFVTVSUTNuNDg4WXk3bUZ3R0I0ellNdDNYUE1WdXhVaDcwWTY0OGdsZ1c5?=
 =?utf-8?B?ems1LzNYbGt4UjQ4NGtTajVIcldLQ3BuQnE0MzBEbThRRlBadDNDWE9MOWt4?=
 =?utf-8?B?WUNneGZwRVNKUjhtMGRRNG9PQllMYXZFODVPYjNkbUFkSHVlYXY0blRGRjkx?=
 =?utf-8?B?Mm9ZWmYwZitoUUozbkpBTDJ3cmVWaXovRENjZG84ZFl5M2ZsWldRaEtac05v?=
 =?utf-8?B?TG01WCtGL1BCMWNHU2R6KzBHK2Y0Rmw1WDVYNjgrWXpFQStRbkFqQ29kWlBL?=
 =?utf-8?B?cFhXVXNXVzVaaHdZY2N6a3JuUXV5VS9HNE95bEdHc0t2WUxaWWtTZGxwMTV6?=
 =?utf-8?B?ZVVNeTNwem4zZHVVMC9weHlWTkMwTHlZaFIzQmVORlZUbkpvRXRlOUNVVVpR?=
 =?utf-8?B?UkxHdGxJVFFHQ1l2ZzlvdFExRllzZWc3dCtLU2JGckZ3R2hDNFR3ZjZJVnZ4?=
 =?utf-8?B?MFplKzA4b0t6bEkrQm1IM0pUbXA1WjlxeXRpeVlQaC83WmZxOGZ6RjlYYWZP?=
 =?utf-8?B?V3NTNzFBR1lOMUw3UlBaRWozbWdIRlBqUjhlNzFzSTY2MGV2K2RhRnc2MzM3?=
 =?utf-8?B?dWJSczRpdEVLenZ6WW8vcmU0N2RscDNTRGsrWnFsc1ExVjQrampoWCtNemhE?=
 =?utf-8?B?TFo4aU4yNEhwUXVnM2xBS1BnSEZ0WHhFZ3R4aVdrY3huNUFzeC9aUTMxSkFm?=
 =?utf-8?B?bldZZUo3Zk5BRGozOTVYK3FCeGlMeDB6OHVpM04wS0EveTZ0LzNMNEwyZlJC?=
 =?utf-8?B?WUhHYUo1bXJKdDdrRXFLcFNpWGk3OGl5U1NlUFlVbG8yc3k5S2N3blBoY09G?=
 =?utf-8?B?T09tdWYycVdjL3BGNE0rVHdxOWVUNHhXLysrUSt3Sm9QNWVTbEpPajlPbGZ6?=
 =?utf-8?B?NVByTmJ4dkl2MW0zc01xU2FXWk9abk5xa0ZDdFFJTXBGZUluL3RxdmVGd0J1?=
 =?utf-8?B?VGs3T2lSUTBBeis0V1l4SWNubVdNbktjMVZqRjgvL01mQWN3SlpHNVpjK0g4?=
 =?utf-8?B?aDlHQVBaOUVvK1h0S1Noakh4b3dEV2k1SWpEQmpSK2ZFdEhUa0RPZlNGRkg2?=
 =?utf-8?B?aHgwcWlKUXZ2NHVVVjFyMjBTQ1dtUk5HVXBOSTh1SEYrb1dNeHViK0NnUjJX?=
 =?utf-8?B?dWtwMFgxSGRwR09CRUJiNGpzYUNYOVFWRVZiZkJNRFhORm42NlBCNFh2Y1Rw?=
 =?utf-8?B?SEVlTWwzNUFVTEllQXozUzJPdGduSmR5K0xLbW5XTllrRGIxSnV3VEgzeG1Z?=
 =?utf-8?B?ZDV1TzdCYVJXaFpsYnVYK3BkckU3a0FodWdYN0xKeVVRb3d2WUY4ZFcxdkJs?=
 =?utf-8?B?dDgrelpOK2ZHWm1Tdko3N0RxUEJjd1B1dkVzRnBaVjhXK01ncXJuVWJPM24w?=
 =?utf-8?B?Vk0wSGVndW16bHRQeTRwcjlYOVpLTUpXRTZhTm1FSXkzaVg1a2NRdlkwczEv?=
 =?utf-8?B?SlpqRTJkK2VnMGdOVFp5a0kwN3lEVzR6WDJvS1VXRjh5cDNpL2VQVmpwMllT?=
 =?utf-8?B?ZFJxMjMrV2JnTzNRc1UxSElXRUtnMCtmT3ltMlFuRXAwclQwNjN4ajVOR01K?=
 =?utf-8?B?Q1VUYVhlTEQ2Z0dYanN4L08ycWNyWHJNdllLVVF5NkEvNHhFZ0pVYjJtanVT?=
 =?utf-8?B?OGEyZUVRK3NiMWhBbVZxVlE3L1hHdHdMckdDK2dDbjl4bTVDWXIraEpIaXA4?=
 =?utf-8?B?NGNwb2xxUm9vdTRsVGtKLzdqYWFaSkpYNkRONkFJeDZVMlpQa0V5VHpodkVS?=
 =?utf-8?B?RCtWdU44THpIbXlSanZSSi9OUXdlbllZMjZCRUdrVmcyMk5hTGp3cjQxT1VK?=
 =?utf-8?Q?ThBGYB9+JWQGNFBCiNBLhVhwv?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cffa9803-f4b8-49aa-2fb8-08ddadc82045
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3320.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2025 17:55:20.4542
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 30vsywj+9X62EuuvDikBJmXJZ2SXly7Xdx5HNI/x6oY3uD6KMJYaZsKn1hpOitnEqWmGWO7LBjw/d+VghVXIhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7344
X-OriginatorOrg: intel.com

On 6/17/2025 12:32 AM, Xin Li (Intel) wrote:
> Sohil reported seeing a split lock warning when running a test that
> generates userspace #DB:
> 
>   x86/split lock detection: #DB: sigtrap_loop_64/4614 took a bus_lock trap at address: 0x4011ae
> 

The following patches fix the issue for me.

Tested-by: Sohil Mehta <sohil.mehta@intel.com>

> 
> Xin Li (Intel) (2):
>   x86/traps: Initialize DR6 by writing its architectural reset value
>   x86/traps: Initialize DR7 by writing its architectural reset value
> 
>  arch/x86/include/asm/debugreg.h      | 14 ++++++++----
>  arch/x86/include/asm/kvm_host.h      |  2 +-
>  arch/x86/include/uapi/asm/debugreg.h |  7 +++++-
>  arch/x86/kernel/cpu/common.c         | 17 ++++++--------
>  arch/x86/kernel/kgdb.c               |  2 +-
>  arch/x86/kernel/process_32.c         |  2 +-
>  arch/x86/kernel/process_64.c         |  2 +-
>  arch/x86/kernel/traps.c              | 34 +++++++++++++++++-----------
>  arch/x86/kvm/x86.c                   |  4 ++--
>  9 files changed, 50 insertions(+), 34 deletions(-)
> 
> 
> base-commit: 594902c986e269660302f09df9ec4bf1cf017b77


