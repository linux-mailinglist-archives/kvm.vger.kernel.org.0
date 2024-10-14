Return-Path: <kvm+bounces-28780-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BEC9B99D3DB
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 17:48:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 415551F24F9A
	for <lists+kvm@lfdr.de>; Mon, 14 Oct 2024 15:48:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 092BC1ABEBF;
	Mon, 14 Oct 2024 15:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gOJaG+R/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC0DC1AE006;
	Mon, 14 Oct 2024 15:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728920894; cv=fail; b=YLDzaj4uZ1Eol7YNHKLyDGnloofP3DkP6BPWToFdy25evBtxvSKdGmZtivkuIhD3vv+xX/75iNUhht5R0x0TP0iOAs2vsG4jRhGE8QeJNdmJkM9RC+76b2mWPNTJHBT0SkYr5z4MYDbIYVb5o9O3425KXBPsmzXOsvWuay+qanA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728920894; c=relaxed/simple;
	bh=D2w4li9d9FdLB9fd24zJ8/CaAudqh8bzsxRX4iNYHsM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OsFYZg4nRQYYDe6s2XMPChwJ7WHOV1G5iTobM+5i9uCp1CCNfC/8NR4QhBW08Z+0lCx0D3STzq3giLpJZpG1iZPkmIg36VSe+EYAPuwq3OseEj6w9Lgbu7L/MBe0XyzvPok5quay1DJw7v/Sl63WLeJKHbrlGdCtprbq1HOLHBs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gOJaG+R/; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728920892; x=1760456892;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=D2w4li9d9FdLB9fd24zJ8/CaAudqh8bzsxRX4iNYHsM=;
  b=gOJaG+R/P5NJbfcQxziqriY/POU7bVPSI4URZ7kEeYjXa3pm7z/INV3e
   nrEHdGa7S8tnldQaMfm99dp+2ikDEL6eoZBVMNvtmxTvgdpEz/sA39Sqm
   qHK4808bwJviYLlKPSNMQxu9JoliGpES3lvmMugy4CgrjWjXqxwAF4EI9
   Lf32B0KdqhUOEJROFWuxFi9FBbmEUOXeXzla/sAV0iQlEhZJGOnH3o4TX
   25vRLFKktKVEpsCepAVKcJnaMfVuoFPtsa1qLM85kDvHqJ9SYCmr7AWNQ
   R420CaTG7Yz3eSPSx2Kv0WEE2Kne+/NSfOYu8RkutPLr92wknCd9M3EB0
   w==;
X-CSE-ConnectionGUID: zNPK3rZTTNWKBAYAjxARlQ==
X-CSE-MsgGUID: 1p8L+cRMRzWkYNUZxYP42w==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="28162087"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="28162087"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2024 08:48:11 -0700
X-CSE-ConnectionGUID: e/or1afZTVmzXMWorwWNKA==
X-CSE-MsgGUID: fzh0GxxbRKyMTf2aomkWKA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,203,1725346800"; 
   d="scan'208";a="108399927"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Oct 2024 08:48:11 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 14 Oct 2024 08:48:10 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 14 Oct 2024 08:48:10 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 14 Oct 2024 08:48:10 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.45) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 14 Oct 2024 08:48:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RolCnOKfj6+ruCaudfviFHc9SY7z6NTT5HP2m7QCBuU2sSAaccyxuCkVokve4BbdXAF25I9a2DkhkqIr+htL7xAaP1EgpDvU40iC+ysGc5A0CZcnHAklFUKBx0X86jLX2WgY7uRFBmXZHvv1hJatm1TdLaG2S0owkrXn8iV/Y6cKvcBEHxgxMXTmqIWWsAimzrP/LVmT5BRp+Ure57KktE1uP1tqMB7ZLeqleTSNKMTYgeLI41oVYbQYoMHVRwcC/Al/VFRTAr3srKdW42tRJNQP36tr2o5frqwvI/VQYXa83Sc3v6pQIwIrcj/WDJqg3fgbK3SKTEg939dL33viPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D2w4li9d9FdLB9fd24zJ8/CaAudqh8bzsxRX4iNYHsM=;
 b=nRZ3kb+T591ql2WEsjN0jDB7WVpbKuzKu1PfeDYkj1u/SS5znSg7ZVRUpXsxGoZro7xEWMtWzvYrIJVFxbkZzLH3uZ5aqY8IbU5WXfW5RWJhhLJzH6vAlIGD10MwK0ocBaoCv4WTqliJNVJtA7urr+jDgkVjggfVEV1rqwOvFPNhz8+hHNljowgaBHTDPPV9ub9GXV4tBJmY9ryd00pX/QYkDjViK5FJvThyxCOE87W/pgbdAidZ0pcfiUikFOXkRJWnPhFdCzlNRPxjFiuMHj4kGKBJagI+KII0v2QSI5DSXehCRG7f4SEhi5wQKxrZgDgRfC1L7KvLtRz5ixGZsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SJ2PR11MB7453.namprd11.prod.outlook.com (2603:10b6:a03:4cb::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.16; Mon, 14 Oct
 2024 15:48:03 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.8048.020; Mon, 14 Oct 2024
 15:48:03 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC: "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "nikunj@amd.com"
	<nikunj@amd.com>, "mtosatti@redhat.com" <mtosatti@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>, "Gao, Chao" <chao.gao@intel.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] KVM: x86: Don't allow tsc_offset, tsc_scaling_ratio
 to change
Thread-Topic: [PATCH 2/2] KVM: x86: Don't allow tsc_offset, tsc_scaling_ratio
 to change
Thread-Index: AQHbHHw7I6lfItviqUm8ERgDYCsBTrKGZ+4A
Date: Mon, 14 Oct 2024 15:48:03 +0000
Message-ID: <86d3e586314037e90c7425e344432ba21d511a26.camel@intel.com>
References: <cover.1728719037.git.isaku.yamahata@intel.com>
	 <3a7444aec08042fe205666864b6858910e86aa98.1728719037.git.isaku.yamahata@intel.com>
In-Reply-To: <3a7444aec08042fe205666864b6858910e86aa98.1728719037.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SJ2PR11MB7453:EE_
x-ms-office365-filtering-correlation-id: eb50b52f-6be4-420e-cd10-08dcec67968b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?a0ZjcktnUUhTNmNxb0JaREg4cWVROWJkb2IzZDNiYWE3L2xtdmdVbFBOSHZ4?=
 =?utf-8?B?WEYrZnoyaFdNNzJyTHVIZE50eGQzSzJ4eUt2ZWVTYjBDTkp6SXdYRm1vaEJG?=
 =?utf-8?B?TVlMNHMreE9yaWdMSUZNSngxM3BhREtFQVdKTjJDall2OXg0aS85VXlFMXNi?=
 =?utf-8?B?S2VjZExuSWtuT0tBMUhPdTlqUHloWEpxK0dJc2MvMmUzc1RZNHQyWjBTcTlU?=
 =?utf-8?B?WXN5K0pmWVdpM0R0N0ZYUjZYb3pReXd6eE4yY2c2OFhVWU1lN1Ficmg2Si9s?=
 =?utf-8?B?OU43c2Focnp4S0UxN3M1MXhwUjE5dHRrRFI5TVBwV1lyVDNaWitOTXBsUVkr?=
 =?utf-8?B?Y2hvMjlZRFoxakNKSG1sbGNPSEYxVVJsbW5yM2NKbUtmd0JxUWpQbm9mbFE0?=
 =?utf-8?B?UE9BZngxUm1ybzAwWHBsclVMclMzSkE2RWhqMnBIckwzdHQzZjZuazNKSmJW?=
 =?utf-8?B?SThiaTNTNTk1YWFLbVVxYkZ2N0NhSC9EZDJlZ0FZTHMvOWVzS3d3RXpXSE12?=
 =?utf-8?B?WFJLaVZqU1IvYlFvRm8xbzlpbURZVGRZbG00bVdUQXRKMjhaNmtzVktSc29F?=
 =?utf-8?B?ZXg5VkNRMU9YUzlvZ1IyRFd0QStXOEQyLzF5bUZYcXF0MUphUzRVSTc2NDd3?=
 =?utf-8?B?SWlNUyt1dXNqQ2xQQU1MaUNZMHo1TExCYTRJR1Urc3MzdThDeDFqenhSTnpO?=
 =?utf-8?B?YlZFTXQvNUwxZ0hwa3FJYlo4V1VON2dGMHBjZldCc1RNRkFwOTYwQ25JOUR0?=
 =?utf-8?B?RU9mTTZybXlBWVlZZk96YkE5UFNDMjZPMHVxczVQc2VORlQrczl5bVFpVFAy?=
 =?utf-8?B?NWdyYys1MWJXYTBLVnFmMEFPT3NzSSsyb2ZpNjlOVjNocDFLbDhOMURkaEty?=
 =?utf-8?B?YkU0RU82emJSb0JQR3JMQUZsRlZZR041WVlWdWxyRWtHUGtud3BZWmJoUGFw?=
 =?utf-8?B?c0RPbmhwakw3UDFpMTlOdmllZ25wTUtXd0xHUDlzZnhabnRJeENTS01tdDNQ?=
 =?utf-8?B?bGw5ZktieVg1aGxsQkJrT2xYK0VsamhpRnpIdUxFMTd3amdSbGttazFENFFC?=
 =?utf-8?B?Qmt0UE1iem9yOW1UcGoxZjMxUmtmekFvNEdURTU4eTNQY3lIczNmN24yZmd4?=
 =?utf-8?B?MERod1JUeHZsV0dsYWYrcTV5YVMwZVpOZUVQQm5wMWpTb0NXeHRQU1pMY0JE?=
 =?utf-8?B?S3hxSy83akpCa1B6MmZMUUdXZDl1RWhuNEhBWUlxNGovL01BcWtsZUFtT1Vu?=
 =?utf-8?B?T2R6QnhrN3NEZEpWVVFscnlDMTRQSzUvbWFrdnNWMksvOEpiRWVrVEZBcUQ1?=
 =?utf-8?B?dmtibVdUSlYwR2R5U09VRXhtRTlwSk5lbmI5b25IYjVTL3NSTmVpTFcwRnhL?=
 =?utf-8?B?NWlmWGFKamEzckxBbjBZQmlCanE1U3RVbDk0S2d5WHg0RGJtMGlXNDZGTjF0?=
 =?utf-8?B?SDFVU2tCV2o3LzB0cTdKSkk3a2d1MUZGci9sbE5QNDJKYWk5ckRQVi9YSDhq?=
 =?utf-8?B?c1VzdTEwdVRBMVN2L3RrR2ZGdTVrT2FrQ1lVb1cyU1JLY2VLVVdIU1pWNzUz?=
 =?utf-8?B?ckJSQXlhckRSZTQvY3RCaFM1d1F6LzNkY3EzcXE5TGxIbjh0Mkloc3pYSFRK?=
 =?utf-8?B?M2xVMGlZN3A4ZFV0cjNlR2pya3dJRlFYdGw2aFJqb1NyWkxsTVU2QTVEQk82?=
 =?utf-8?B?eWMxL0Z5TXZNUWZqdmhDNFpaQ011WkYwclN3RmxTSmk2bTllOXBJY29kVU53?=
 =?utf-8?B?ZGRlQjFtS3pPM0lpMDdJSHloVDd0RXNGSkZhbkkxelZJRkNOT29yNDQ4M09W?=
 =?utf-8?B?L0FoYStJK2FNUXE2LzV0dz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OHJGa1FGaDJDOUtnRVNIaHg4RUlDcnhZdm1KTVVVTkV2MUwyVXVKZ0FWNzUx?=
 =?utf-8?B?RWxZZ2hQMlFwL3dXUTRlL01iekJ2bXhMSVA4NkJEOFAyVTBJNXA2ZElwS1BP?=
 =?utf-8?B?LzdzZEhkSkdsRitzN1hhUmlVQ0x4VEMvK24yZkVPOGVoS0VGWE1pZGRsMEQz?=
 =?utf-8?B?SVRld200TUt2Z1BoUXRsQ01lV2RFb0p5L3cybVZXVElVMGlUc0NEcUZtUlN1?=
 =?utf-8?B?UzJzQ1VjV3BnYjV0dUw1WFdvTVZQcWdYWmZZd0doYnFWL2xPU1VnZE1TOEpC?=
 =?utf-8?B?dTFxcEorTW1rN3pVZ3BoYUJRdlFvck1kRjJJVlhKRG91QUJZV3MyN0J1UGli?=
 =?utf-8?B?RU5QSVBDL2lkanM5NGs1a1JNQWozQ2Q4TTlwTmJGZGpLRWRXV1pNUWwvVkcw?=
 =?utf-8?B?ZkRIL1RlZkFzSnpVMnZrZHlZMWZ3YkNIUnI1aTZyZUhFLzNVSVlGRGh5TWpO?=
 =?utf-8?B?U1l5a1diWmo2UENRdUFxbTNTS0VWTXZGMWtxUllLQTRnTTl5Q3J5c1dHcVQy?=
 =?utf-8?B?anIzcXFGNTdMWmVOeENTcmJ3RldkWXNyNWpOcWtkRGVBMWwxYnZQdkJGM0Fv?=
 =?utf-8?B?WTR4K3NUTmRodzl6eFZVM1E5dElBNUZlWmZoOWNiS1hJa3F2TnVoc3JPN3pC?=
 =?utf-8?B?VkljTTd5TFM4TTU0VmJYZEdMQ09TR2dJdDlWSTl3RDlndE9qTzR4U3ZVWVZo?=
 =?utf-8?B?VnZpQUk0TnN0SHJiQlU4Tmp3VGVGZkNSNnJTb1cxNi9OWlAvSGYwOWExTncz?=
 =?utf-8?B?UkZ0Tm1uWTVlWUZCWDdaalBhZWpwWGpXQ2Z2UVk5Q2V3dGtoTzZzVlhKZ3Fz?=
 =?utf-8?B?SzUxMzBOOTZOdndDZGZpU3F1SVZEZG1pYVNlMTBTaWxSc1NnZHZTQy9iZkNS?=
 =?utf-8?B?WDJGQm42NzlVVy96RytZQ2FGQURjQWZuTjkyZ29LNU9qUWY3ZWQ2NkdML3d1?=
 =?utf-8?B?M1QwZFpHR2NpMWZSMGErSmEyTjdlYkJHK2pwV0N4a21MdkhsZzVIZ3JxS1FE?=
 =?utf-8?B?MWFJdUdEM041YlkxUkdqOG5CUE11QklxK3cwM29uc05XSjZkckdwdVFlbkhL?=
 =?utf-8?B?aFdodU1SRDd1RFlrRjBRb0NHcEU2R1lpRkVKRDJPdWZ6TW9WWUZxMmNUOWU2?=
 =?utf-8?B?MFFzUk8zdjZCK25Mc0hqaHJXQ1pCWGRDVEpxdlZqb3NOTFNxMDdpUmFCVThL?=
 =?utf-8?B?VDkvU1hZUFcxR0lIbWJKZVRRWW9uMERYd2RTRjdDVXdwMHA5QWJQS0RlczRs?=
 =?utf-8?B?WGQ5MlQwWmYwbzdYR2JEZjlrb3p4VEdkQVpUejhIaHFkN0FmeEhuWnpZcnM1?=
 =?utf-8?B?aS9Eblh4cU1hNW93K01ya1FTWWwyWXppQWY3VURHWnI1eFViQWg4ZlhnZEtJ?=
 =?utf-8?B?b2ZQdHh1ZlZRMDlwelYrSWh4MVo1dWQ1YVNnTDZIdWtHdXR1QWVYeG1CNGx3?=
 =?utf-8?B?Mk5rOGhmV21Mb2NyS0V2OWl0d0lOTHMycG9BZTRrT1p2ZUZHam5WV1BTTHY4?=
 =?utf-8?B?Y0VaUHBON1lLNXNQL3l2Sm1ic1BDWU54SWdhNFJ6STFpVktQcy9Zd2NlSUhp?=
 =?utf-8?B?RW91MnpkeVN6MlJXQjN6VUV6U1hMK1BzS2JRSmk3R2wvUHlaZGlUNVg3YUNL?=
 =?utf-8?B?OG5SY0tBWUJuMkp5VWNONlJkeTBORDQyblZuOUVtSWNyK0lVTFZWcThjK0J1?=
 =?utf-8?B?NXlIWEM5NWZhdWdYWmJxTlA4dWJLLys3ZlAyOC9hQ0xYRm9JK08xT0VLOHRZ?=
 =?utf-8?B?TW05UkZtQ0ZEWXhOL0hQK2NTVXRBNEtXNCs2K3ZWa3FvckNkOWY2cmcwM2Jl?=
 =?utf-8?B?bUZyYlYvREc0cDRPL3RNZmxXTzAzRUU0VzRPbFBUNzZkLzE1TGJwWGtKVDJl?=
 =?utf-8?B?ZzdsWlptNEllVnNoemFTQUw4bEJ5MzZhcUlEZkQwSGwyZnVSTjl2S3dQOU5a?=
 =?utf-8?B?Qnd2dTE0VXA1U24zUit5WmtWTTNYMkJoQUl6YUM4RTJvb2JJSFozbWNNTEpr?=
 =?utf-8?B?MkpPZjExWHlIcmhXRXh4OHlIbVg0SHFkS2hsbDNVdU5DeitiT1VEQWllQkVl?=
 =?utf-8?B?N3M4UHZZTmJ3Tm90MVpYSk5qU1hMb2Z5Qk1yNDJxakFpNWp6N2hxRDNCdmRM?=
 =?utf-8?B?RnNNbjVtREVMQnFxcGU0K0Z5U3dGZnk3QmorQzhWR3NTQ1VnWDA1WkpOWFFX?=
 =?utf-8?B?UFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9B0E81039A246A489865F16419146ED5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb50b52f-6be4-420e-cd10-08dcec67968b
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2024 15:48:03.1013
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N5CKc5c/80iaPpu4zJynBfbx5+sBs5DsSi7r45xtT49QHM51sa86cgCps6c3ibUgF6mj3aq9YcRD2RoocTEE20aaicMD3ncz+8MwjEh0GO0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7453
X-OriginatorOrg: intel.com

T24gU2F0LCAyMDI0LTEwLTEyIGF0IDAwOjU1IC0wNzAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToN
Cj4gUHJvYmxlbQ0KPiBUaGUgY3VycmVudCB4ODYgS1ZNIGltcGxlbWVudGF0aW9uIGNvbmZsaWN0
cyB3aXRoIHByb3RlY3RlZCBUU0MgYmVjYXVzZSB0aGUNCj4gVk1NIGNhbid0IGNoYW5nZSB0aGUg
VFNDIG9mZnNldC9tdWx0aXBsaWVyLsKgIERpc2FibGUgb3IgaWdub3JlIHRoZSBLVk0NCj4gbG9n
aWMgdG8gY2hhbmdlL2FkanVzdCB0aGUgVFNDIG9mZnNldC9tdWx0aXBsaWVyIHNvbWVob3cuDQo+
IA0KPiBCZWNhdXNlIEtWTSBlbXVsYXRlcyB0aGUgVFNDIHRpbWVyIG9yIHRoZSBUU0MgZGVhZGxp
bmUgdGltZXIgd2l0aCB0aGUgVFNDDQo+IG9mZnNldC9tdWx0aXBsaWVyLCB0aGUgVFNDIHRpbWVy
IGludGVycnVwdHMgaXMgaW5qZWN0ZWQgdG8gdGhlIGd1ZXN0IGF0IHRoZQ0KPiB3cm9uZyB0aW1l
IGlmIHRoZSBLVk0gVFNDIG9mZnNldCBpcyBkaWZmZXJlbnQgZnJvbSB3aGF0IHRoZSBURFggbW9k
dWxlDQo+IGRldGVybWluZWQuDQo+IA0KPiBPcmlnaW5hbGx5IHRoaXMgaXNzdWUgd2FzIGZvdW5k
IGJ5IGN5Y2xpYyB0ZXN0IG9mIHJ0LXRlc3QgWzFdIGFzIHRoZQ0KPiBsYXRlbmN5IGluIFREWCBj
YXNlIGlzIHdvcnNlIHRoYW4gVk1YIHZhbHVlICsgVERYIFNFQU1DQUxMIG92ZXJoZWFkLsKgIEl0
DQo+IHR1cm5lZCBvdXQgdGhhdCB0aGUgS1ZNIFRTQyBvZmZzZXQgaXMgZGlmZmVyZW50IGZyb20g
d2hhdCB0aGUgVERYIG1vZHVsZQ0KPiBkZXRlcm1pbmVzLg0KPiANCj4gU29sdXRpb24NCj4gVGhl
IHNvbHV0aW9uIGlzIHRvIGtlZXAgdGhlIEtWTSBUU0Mgb2Zmc2V0L211bHRpcGxpZXIgdGhlIHNh
bWUgYXMgdGhlIHZhbHVlDQo+IG9mIHRoZSBURFggbW9kdWxlIHNvbWVob3cuwqAgUG9zc2libGUg
c29sdXRpb25zIGFyZSBhcyBmb2xsb3dzLg0KPiAtIFNraXAgdGhlIGxvZ2ljDQo+IMKgIElnbm9y
ZSAob3IgZG9uJ3QgY2FsbCByZWxhdGVkIGZ1bmN0aW9ucykgdGhlIHJlcXVlc3QgdG8gY2hhbmdl
IHRoZSBUU0MNCj4gwqAgb2Zmc2V0L211bHRpcGxpZXIuDQo+IMKgIFByb3MNCj4gwqAgLSBMb2dp
Y2FsbHkgY2xlYW4uwqAgVGhpcyBpcyBzaW1pbGFyIHRvIHRoZSBndWVzdF9wcm90ZWN0ZWQgY2Fz
ZS4NCj4gwqAgQ29ucw0KPiDCoCAtIE5lZWRzIHRvIGlkZW50aWZ5IHRoZSBjYWxsIHNpdGVzLg0K
PiANCj4gLSBSZXZlcnQgdGhlIGNoYW5nZSBhdCB0aGUgaG9va3MgYWZ0ZXIgVFNDIGFkanVzdG1l
bnQNCj4gwqAgeDg2IEtWTSBkZWZpbmVzIHRoZSB2ZW5kb3IgaG9va3Mgd2hlbiBUU0Mgb2Zmc2V0
L211bHRpcGxpZXIgYXJlDQo+IMKgIGNoYW5nZWQuwqAgVGhlIGNhbGxiYWNrIGNhbiByZXZlcnQg
dGhlIGNoYW5nZS4NCj4gwqAgUHJvcw0KPiDCoCAtIFdlIGRvbid0IG5lZWQgdG8gY2FyZSBhYm91
dCB0aGUgbG9naWMgdG8gY2hhbmdlIHRoZSBUU0MNCj4gwqDCoMKgIG9mZnNldC9tdWx0aXBsaWVy
Lg0KPiDCoCBDb25zOg0KPiDCoCAtIEhhY2t5IHRvIHJldmVydCB0aGUgS1ZNIHg4NiBjb21tb24g
Y29kZSBsb2dpYy4NCj4gDQo+IENob29zZSB0aGUgZmlyc3Qgb25lLsKgIFdpdGggdGhpcyBwYXRj
aCBzZXJpZXMsIFNFVi1TTlAgc2VjdXJlIFRTQyBjYW4gYmUNCj4gc3VwcG9ydGVkLg0KPiANCj4g
WzFdIGh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS91dGlscy9ydC10ZXN0cy9ydC10ZXN0
cy5naXQNCj4gDQo+IFJlcG9ydGVkLWJ5OiBNYXJjZWxvIFRvc2F0dGkgPG10b3NhdHRpQHJlZGhh
dC5jb20+DQoNCklJVUMgdGhpcyBwcm9ibGVtIHdhcyByZXBvcnRlZCBieSBNYXJjZWxvIGFuZCBo
ZSB0ZXN0ZWQgdGhlc2UgcGF0Y2hlcyBhbmQgZm91bmQNCnRoYXQgdGhleSBkaWQgKm5vdCogcmVz
b2x2ZSBoaXMgaXNzdWU/IEJ1dCBvZmZsaW5lIHlvdSBtZW50aW9uZWQgdGhhdCB5b3UNCnJlcHJv
ZHVjZWQgYSBzaW1pbGFyIHNlZW1pbmcgYnVnIG9uIHlvdXIgZW5kIHRoYXQgKndhcyogcmVzb2x2
ZWQgYnkgdGhlc2UNCnBhdGNoZXMuIElmIEkgZ290IHRoYXQgcmlnaHQsIEkgd291bGQgdGhpbmsg
d2Ugc2hvdWxkIGZpZ3VyZSBvdXQgTWFyY2VsbydzDQpwcm9ibGVtIGJlZm9yZSBmaXhpbmcgdGhp
cyB1cHN0cmVhbS4gSWYgaXQgb25seSBhZmZlY3RzIG91dC1vZi10cmVlIFREWCBjb2RlIHdlDQpj
YW4gdGFrZSBtb3JlIHRpbWUgYW5kIG5vdCB0aHJhc2ggdGhlIGNvZGUgYXMgaXQgZ2V0cyB1bnRh
bmdsZWQgZnVydGhlci4NCg==

