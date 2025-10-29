Return-Path: <kvm+bounces-61423-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D53F6C1D61F
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 22:10:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F40B1188B084
	for <lists+kvm@lfdr.de>; Wed, 29 Oct 2025 21:10:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53D35319619;
	Wed, 29 Oct 2025 21:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fZomkhOF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E614B3161AD;
	Wed, 29 Oct 2025 21:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761772160; cv=fail; b=kbQBZLSyv6tkAsW5Nm0MrFlqAwSO36LEBzKwS8kxaCYBadPStMWBtIUhuIDjZLiYIbzXrrovVvWJCrefxjn+8tLq4aF7kuDsDV4egsLTdCcMLQeYF1UZVaxo30xOz25nzjZsfKKyJVL5454A+QYi/oBq934vzXRsNxuWdVAFiIs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761772160; c=relaxed/simple;
	bh=8kFOdj0d0Kda3CuaCDdRwSUQkj80rS21MfrpPxGyzYk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pB2m7lv/weLhXEN3y2dwCzRyrW+7x36ddjD2G333P1dlsjAzPLbdtirz1OCB+WYtkfuhD8vhCOve3AUe22Wd95FLI2kJgKonwg+Le1QR3n/DogD+i5MGDziwYneLm3XH5/HwlOhnqpUgHg6VQVI71XPVlWLdCph7QVEkQx5tXMI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fZomkhOF; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761772159; x=1793308159;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=8kFOdj0d0Kda3CuaCDdRwSUQkj80rS21MfrpPxGyzYk=;
  b=fZomkhOF0dhzqi/7MK9F/YBRRvTgUbVZkaIA8k6PHs8l5RjTmeX3QSoy
   rEJm1gR1T4+Ll8n/WB7Ic7iniz9pbN2Th5IsZ9dCE9HzAyR/VDUaqt8mz
   WAlQK6byBuXRl9HplUAyYsxd5WnF5FY3Ec/bkXJKts0d2u+7CXgjBk03t
   /D9F690sTOL9VXbH8wNU/5DWr3LyEQ46SMPZbClHo3EgqXoICFPuI+R/K
   tHCQAotiL+31kErxK9evE15hMobEDdIX6i2Wm2HWS94yM3HdB2XMd+s6Y
   eCXLhpqy2H7lcfdTJbgNQdtkp60oNHTcQ9TuoCUcpTLpfyt8gD4qsm+cE
   w==;
X-CSE-ConnectionGUID: LPPf13XmSUS9CrcUirCEdA==
X-CSE-MsgGUID: aOAZJdDTQS6mxskKM62YNA==
X-IronPort-AV: E=McAfee;i="6800,10657,11597"; a="63941112"
X-IronPort-AV: E=Sophos;i="6.19,265,1754982000"; 
   d="scan'208";a="63941112"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2025 14:09:17 -0700
X-CSE-ConnectionGUID: MguoMc4sTAu7/kCJXuKdcg==
X-CSE-MsgGUID: AuIScuvuR06e28y6frhpUg==
X-ExtLoop1: 1
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2025 14:09:17 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 29 Oct 2025 14:09:17 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 29 Oct 2025 14:09:17 -0700
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.1) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 29 Oct 2025 14:09:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j7Thm37jIA8FaTglqCrb794BxVVvVTd5dOJ1vDDtg6JxabuVP5R1hRx79Yg0o5g+kBvpFyqYODqsmur3j33WYhykMyqComMIgIKF0EwxaMUZJDju7xkcfW2NqMCbi5ohu/IHXQQwe884W00BVynh4wiftJ3jBieFP6Fly1a4plBKWW7anA1i3bYao5qVwxoqMyUDkMexLUU62p14HjVeFtPCftv2zpX1ByC1b0N7a7FO9HWt9UCFxbd/Uyjp9AdXiA/Wz2IMlzn9vmcKzE52iq/AQPxAbsVXkOAgQ77PvgXWTBhZnzbAEC12Y1NnkqFcPuc5roZN91Dk4mERA3OD6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8kFOdj0d0Kda3CuaCDdRwSUQkj80rS21MfrpPxGyzYk=;
 b=rJHT6XpAGbPmKQeUYAsb0WsD0kaTgIwOBwjr2POdgt+/r6wmQ8kTzO17f4tKdT7ZMJym2tu/zAI2bUlBouafZ0DqBzWcQkOUxmDTGl5fLNfC8fGXIYrk8eAMDfvEmxNqMfg3huAKToaQQjaYFof8fjiGSDDAZYKz6k5FPRuPWesu/Sez5HGiY+qGQqulNcyA90A4N1ZwuZh6TIf5atB7R4rsAWWOr1KZBIOng8vE9nMl8EHLYXdpCzuREWUUNhC/vxXaGnSVSqFKIptZe2Dy+PmS9M/1t7pze5AyRWFFXFSGUSOytFvBstr9+dBw6Vpv5wrazaxjP+1eCNwawgPhkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CH3PR11MB7274.namprd11.prod.outlook.com (2603:10b6:610:140::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.19; Wed, 29 Oct
 2025 21:09:13 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9275.013; Wed, 29 Oct 2025
 21:09:13 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>,
	"kas@kernel.org" <kas@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "x86@kernel.org" <x86@kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>
Subject: Re: [PATCH 2/2] x86/virt/tdx: Fix sparse warnings from using 0 for
 NULL
Thread-Topic: [PATCH 2/2] x86/virt/tdx: Fix sparse warnings from using 0 for
 NULL
Thread-Index: AQHcSQ0MO/sqjKpydU+zqG2+h9F2P7TZnnOA
Date: Wed, 29 Oct 2025 21:09:13 +0000
Message-ID: <ded37069ad3ce198d29ed1e1f5b75ef12b0d66ec.camel@intel.com>
References: <20251029194829.F79F929D@davehans-spike.ostc.intel.com>
	 <20251029194833.A20A7907@davehans-spike.ostc.intel.com>
In-Reply-To: <20251029194833.A20A7907@davehans-spike.ostc.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CH3PR11MB7274:EE_
x-ms-office365-filtering-correlation-id: 7fcaa1f7-8db4-4558-f198-08de172f69ab
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?Zkx0RDJpQy8yVmhIMnNPR2c3bUlPYWtsWXMyNjZ1S29jZm5kK0hqR1pwRTVy?=
 =?utf-8?B?dEd0cEg0TnJNZnhPME5NdDhRZ1EyaEdJYnVwMWZUcGlVaHF4a3QrSldpRW9H?=
 =?utf-8?B?Y3JvY3RqSFpIeGFoRDJpdkRwekhmZUZ5cWh3VnczSUwxWTkwSkxnSGxkdTFP?=
 =?utf-8?B?b29pQUE5bFRYVS9NRlFZYS9JQlExMkw0TElBV0pJOFZlSWpoQytBM3U1b0lB?=
 =?utf-8?B?N0JDL1N2Q2F0UEJOZnYxYzl6NTh2Z3k3RndKWlZkRnQxT29RTVMyMC9CZjBB?=
 =?utf-8?B?MG9ZL3pVQytJMFVCVkNuWnpLU2VqSk1rcTZ2SURUaTNqaEJ3K3RRdkZQbklz?=
 =?utf-8?B?blJlTFlON2JCRHExMnYrdXFlVmhXbzRWTDRGS0t5OElEeVJ2T3pOMS9uY1Zw?=
 =?utf-8?B?dUFxSG9nTDJzYkhvSG01TkxnUHpDTEpLVVFKYzhlZWhFWFdOQWt2Ykh3UXdr?=
 =?utf-8?B?a0FRTjcwUTY2UGRXWndtOFR6RkFOMGN1MTl1TDdPQmZLK0JYZjk0bmUwNjlq?=
 =?utf-8?B?MnJMMDRDaVNjeVdXQWxDQlgrMHJzTFdqV1czYkRUV29JZGxqUDJjakRxN3JS?=
 =?utf-8?B?T254TlZldS9sV290ekh0UnNQQ0lUS0pRaUl1Uk14alQ2N08vUThSaEJOUzFH?=
 =?utf-8?B?NVRvbHkzc3N4OFhsdUJXb0FXZTd3NGthWjY0YnkvUDdNQWlVbkV1VjYvL0t2?=
 =?utf-8?B?c2E2OEpEVWRHZzhXT21QSHo4ZTVaUzdMY0lUUmZSbjFJM1NNQjg4Y1VjNzRM?=
 =?utf-8?B?eExIVHJjUHVGQXYzdE4vZkFMVFNJTFJvMzlSejZaRkZ5WFFsR3hpdzY4NkFk?=
 =?utf-8?B?ckZySUNlUHpsZWV6ZDZXcmhRQXNWSXU2bHRjelhMemxDNlB2aDJOUXBXVGJT?=
 =?utf-8?B?bFU2dnVsTjdSSEVHNWlWQ2d1eFlqbDRhajIvdk11dm5HZVdjV2RjY0FUbk92?=
 =?utf-8?B?QStsS091YVQ4MGQ0bUJ4bjkrRmwzcXM2VldXUDZmaXJOZkxwakVGaUJ3WGVp?=
 =?utf-8?B?QTZ0STJiUjAySzJhazhzdDVLRFRweHF2cndnbEVPYnkwS0ErL2MzUVNwRXdp?=
 =?utf-8?B?bmFzL3dYbmZOOHpMSjFyZzRrY2krMm84cVBoNVdCSGVVR3AyL1hyeTFua055?=
 =?utf-8?B?OWVrN0pLSGZLSWc0eHN5aTVKVCt6Q1V2YVc3MVZPNlZaRDhpMEY4RGFrQnlF?=
 =?utf-8?B?ZmdLNHgvb0g2MHVBMGJWNWltUFlTdjcwcnYwUDJESU52RXVSSnZUTzNqc1l3?=
 =?utf-8?B?ZldTK004TyswQTJybW1iR1NkNkdlMlFoVFkydmdHWXB2NjM4b3A3Y3grMm9U?=
 =?utf-8?B?aTN0Rm9LMlZNU3dIbDZTclZveTJGTHIvWVVFQXI4T3A4S2Z6TVpMQ0Q5NFU1?=
 =?utf-8?B?eHpPTHdSMlpod2NOa2tzRStvZ0cwWVJRemhZYzZPVDdBam5yOGZnR3cwSVBj?=
 =?utf-8?B?RlpXdDRLb000ZklkUE1sQ2JSQTRXMmJPT3BvdUtDRkNNSDRqdzZyS1Y4RW1Y?=
 =?utf-8?B?TmZiK2FhK3p2ZFh3MlV5SzNWTFBiSXhRSm5sbW5MQTkwSjN1eWh5UHIxVG52?=
 =?utf-8?B?UnIybW5HYS84MytVdTQzSWxBelpyZFdSQTRpd3BoUGQxK0tKRStoQldOajdZ?=
 =?utf-8?B?V1M2OGdjQ1htSWFqaFVZY1BpWnJic1hWNDBPU1UwRjg0OGxLZTRhb0VVbVNG?=
 =?utf-8?B?N1BFb0NROTMvbDFlM0xwSmpuYS9LVGp1ZVRRT1BTc09tMnJFK21jRUZWYUZR?=
 =?utf-8?B?K2x4U2d1U2RSTDFULy9MYlVrRVB6RjdVc3pnOE55Q1RjWUdBV3JwUU5NMVJz?=
 =?utf-8?B?VEFoVFk3RXl0N1oxM28yR1pFdURqTVNuLzlmNC9jaTl4WktPNmFqTUJHRklh?=
 =?utf-8?B?SUFaVVFTMTJZOXVnWmJLRzd6TW5qWFZJdk41V1ozWmgzMU9laHpMZzZjYzJX?=
 =?utf-8?B?MjR4NnZtaURYVk5TZFhlVldZL2k3WlVpeWhzdzIra2cxZ1JRUll1YkhaNjVp?=
 =?utf-8?B?RmtSbmNIeFRpYjE1SGZUUm5IZkI1V3RVWXFyYm40YzFuSHlmS2pCc29IMnBw?=
 =?utf-8?Q?DNx+Ii?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S1JvNno0V3pzUXNRdjhJVVo0eHhZZ25VTXMyRkxDZ2RVWkQ0aXp5bkZ2Z2ZG?=
 =?utf-8?B?c1BQRjZkVlNrQlhqbURUdFVickZQaGRDOVVKblgwNUZydHd4MWJsQVYyUC8r?=
 =?utf-8?B?Y1ZHQmJEM1YyYjE0TXArSFBtTGkrWkhHVU90L3BYN1B6U1ZtMFFSY0d0c0J1?=
 =?utf-8?B?T1o4aWxOL3dsbkw3aGxpRWhQVFkwMU5hb2dVQVNtM0k1SGdzUDFSbVRMdmls?=
 =?utf-8?B?UVd0VDVZQmc5UnkyZitvUy9oWnMzb01EMS9TcUxEaWtrbWFQbEdGYW9EOVRq?=
 =?utf-8?B?K1RLWUdWUDNzdXdVVzlSSDI5M0ttR1lkQ2NJdmZSOWgwSmtmMUNZOCszQ2M0?=
 =?utf-8?B?VEt1L0lsTUxsN2V4UldSL204NGlQM1BIVjE5dTNBMkVPeHJVR1dXRnMwZjdz?=
 =?utf-8?B?d2ZiaGhMcDh3RDZxRWlZTitQV3ZnbDEwbDBEUHluV0RzQVBMN1RadVNDWmtY?=
 =?utf-8?B?ZHEyWTcvV0hjZzUyZGtTNnFBcHJwTlhpcmc4ZTlzK3JkU0VOWUliTjdRLzhM?=
 =?utf-8?B?ZklabGp5Y25STkRFYURtQ1JWN0NqYklnL0lRaXdIbVM2WjhRSDlXWFQzUzBP?=
 =?utf-8?B?SXFVdVJYN1VDVVdmc1dEWC9OeDlBSHZxeU9UQkRqMVZPRWRZZi9JS1ZXWTAz?=
 =?utf-8?B?aGI5Sy9DQTl3SXJuOVJKd0pkT0VxNVN2MlNzV3pDUllVajFtSGNoV1hWY1ZO?=
 =?utf-8?B?RHNORThCMm9GRlV3b21NbnA2bmVwSjIyZnZNV2RiMFpRZUJ1NHRmNWJ1SUda?=
 =?utf-8?B?dkw4SGNEdmdwdk45VHFFU1dEa2x3dXpycU56U0gybGE3WDlBQjZ4eTZDUFRI?=
 =?utf-8?B?WVgwN1hUNnI0YnVUbzNZMFd5UXFOckpLd21CYlZoNFFJdGg4Z203R0Zqb3Fs?=
 =?utf-8?B?N0NVR3ZXaWRTd1FDNVdSa3kwYlFwWHEzNUR2QW1xQzZSbUdVbnVnQUZhL0g5?=
 =?utf-8?B?MDQ2Q0RMaFZ2UVN3MDBMQUpzekVvMThTQTJnU1QyL2poRWtnNXY1dm8xMXRN?=
 =?utf-8?B?cGdJcm05bDN1em9mU1k1c0VEWFJWdHd5L29XK2dEcXlzQVZhVlpTUnJ4bGVK?=
 =?utf-8?B?MXI0WEhnRCtxSTZrd0xKNWdVLzY5SzhpWVRPYTdFdEpyN2NvckhtY290cVZq?=
 =?utf-8?B?andCR3JydG9xWm4rSTBHK1cwS05SdFN3YkRCM09FQlV2cFJMTVNreU9jT1I2?=
 =?utf-8?B?RUNWWm9Kam5VZzk1WDJOMUFqVC9XNmhVNkZIUnUzVzdScWY0NE1sdGVDaFQ0?=
 =?utf-8?B?NVhyWFcrc0N0dkkwYkN6QTBoQXRNZTlFaERPK09nOTIzTEtnMzdLQW5DemdQ?=
 =?utf-8?B?QkRaR1A1M2pYWjd2T3RwQTB2NlR3OFhKT01oM05yUjdkVDliYkVmYWJuNXUz?=
 =?utf-8?B?Nk9hYWVOVktyb0tod3I0UjdITFpIS0U3ZVo2ZjZIaXFhcDZVa05KWTJ3MFlT?=
 =?utf-8?B?Mno0UU0zTXNucHFacDFVQnZ5ZWEwL2ZnSlNPMVcrZVFtblhiajgrd3NuNldC?=
 =?utf-8?B?cDBnV0N5Rkl4WW5PUlJJSXJ1NGMzUkxEejdNQm1nN2ZxWWNmeHpLd05QcXJ2?=
 =?utf-8?B?bTh0YmdGZW5jektiV2pqaStWYzQ4d3R3V3BnN1kzT2J5cnViSElUTTFHNzQv?=
 =?utf-8?B?dE1WemlQQ2dhS0JmbEo1bjlKb3RkQ2E0MHNDWTJ3c2J0djM5dFgxQWpiTkRC?=
 =?utf-8?B?RUZqVGE0UlE0MGJFZVFhbDRvSyszaStpdW5IaGpJeWhSMHdxYUFhQ25xSUl0?=
 =?utf-8?B?a295aTliT2VvSnE3WGpwRmUwOEVsLzV0QVJuRnA3WEI1YUg3TlZtK0VsYkNG?=
 =?utf-8?B?dng4U2xDNVpqZWdBaHNqWjhpbFk5d0dEM3BjQUdXd2RHbVBPaFpVL0tYZ2sy?=
 =?utf-8?B?cnNNVDgyQytGV015QVF2azlQTVlab1F5Zk5SVG1udXBOUTRWSFhoRkRoY0k5?=
 =?utf-8?B?QjlwZEF5MFNCOWFnWGFEOGY2dml6UCtLa0dVWHRPdXVYRTRrVVJxNStQTHFH?=
 =?utf-8?B?ODg5M1lWN2doMllkU1ZIYWY3bzJocTNUWHhycjRUMUgvbGcyVjhQcm0zL3pE?=
 =?utf-8?B?WThHSjNEOTQ1NU5xQk9uSHcyeWZsT3R1V29nU3h4Z21GV3d3UXdHZlR0enB3?=
 =?utf-8?B?NlJSN25hOW1TWjJ0b1ZtU2xzY2o0SWpEL3JlV25VR3VuM0lGeVdlNzdBY3Zp?=
 =?utf-8?B?WEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8138BC85FD8E1C49A76085C7DF906267@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fcaa1f7-8db4-4558-f198-08de172f69ab
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2025 21:09:13.6582
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 24Ie1dtVzq6P8uFFUkNN2KGYFt4lrI9cG7wf4WVJqiueYAQVLkIiezng5V1GPb2VVPZ1Qu4ppgF7YxqfHPNkWBWsc4YY7RaMaX6eLvORrlk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7274
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTEwLTI5IGF0IDEyOjQ4IC0wNzAwLCBEYXZlIEhhbnNlbiB3cm90ZToNCj4g
RnJvbTogRGF2ZSBIYW5zZW4gPGRhdmUuaGFuc2VuQGxpbnV4LmludGVsLmNvbT4NCj4gDQo+IHNw
YXJzZSBtb2FuczoNCj4gDQo+IAkuLi4gYXJjaC94ODYva3ZtL3ZteC90ZHguYzo4NTk6Mzg6IHdh
cm5pbmc6IFVzaW5nIHBsYWluIGludGVnZXIgYXMgTlVMTCBwb2ludGVyDQo+IA0KPiBmb3Igc2V2
ZXJhbCBURFggcG9pbnRlciBpbml0aWFsaXphdGlvbnMuIFdoaWxlIEkgbG92ZSBhIGdvb2QgcHRy
PTANCj4gbm93IGFuZCB0aGVuLCBpdCdzIGdvb2QgdG8gaGF2ZSBxdWlldCBzcGFyc2UgYnVpbGRz
Lg0KPiANCj4gRml4IHRoZSBzaXRlcyB1cC4NCj4gDQpJZiB3ZSB3YW50IGl0Og0KDQpGaXhlczog
YTUwZjY3M2YyNWUwICgiS1ZNOiBURFg6IERvIFREWCBzcGVjaWZpYyB2Y3B1IGluaXRpYWxpemF0
aW9uIikNCkZpeGVzOiA4ZDAzMmI2ODNjMjkgKCJLVk06IFREWDogY3JlYXRlL2Rlc3Ryb3kgVk0g
c3RydWN0dXJlIikNCg==

