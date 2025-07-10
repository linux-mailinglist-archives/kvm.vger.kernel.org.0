Return-Path: <kvm+bounces-52062-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DC607B00F10
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 00:53:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E6D435686EA
	for <lists+kvm@lfdr.de>; Thu, 10 Jul 2025 22:53:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA7F729ACED;
	Thu, 10 Jul 2025 22:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IEU0RAOu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF7F1D432D;
	Thu, 10 Jul 2025 22:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752188004; cv=fail; b=g/CkV15nXWUtMHeVUvy3+edzTJYLnF+f+4tsJSYDoNHh51N8v3ry77lxwakMythB6mBErDTL3jg/irqeGNZqosdSrFTHnPDBucS32QLQeOUQcjRQV4rYoXMSbXFs5n65+qrFUX9FuTz30fKrIdvy6s/WZHAhHpQBJCWwedEYCTY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752188004; c=relaxed/simple;
	bh=wqlt9EFqOEMITHHHj3vHvb9YWthVDGjTbuydr5JFtSg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=eczGGOUZFanex/2YREIIkKpes257lhLfIUQPYu1FvT4BrlCsb1vUI1U8b54MbcpOVFYvN3xqgMkx5B3V4GtM3qZVpf2H+/sOG6guphyVdfQZ7MCV211pzhTY0QQ+G+dycCnYFoMY4SPanSlnBUrqd6pO6+wXRaQVTLx+zAZZr2Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IEU0RAOu; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752188003; x=1783724003;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=wqlt9EFqOEMITHHHj3vHvb9YWthVDGjTbuydr5JFtSg=;
  b=IEU0RAOuAF5QHzKw/tJBRND9FxH4DbCWTbfCLGGjuYjouLmbo55X6aVT
   s7NoVDoqAhrPHmko8duubGRXiQfy02+SAU6h3zE4+pfscJrZn+5zkYOs8
   nUlOFiV8kQ1xQz3viWQji7kP2AAghiy75MEloG1X9OU7hKRgK1HDXGXUQ
   t5vtkLOr7SisWUGjNjSMzF/AGSfRLjx+OoCPnMd+fbbsAr1L+TyP1paxS
   Rt/eHJKQPjgT+kUS+OJ7tiod9Fse+Y3vfbFFwulcRuj3uQx9AFpHj+U0k
   TtgcO27XU4ac64Ag5iHR6HNBBM9yyef9Q8PM24gkV4jOkvdQrNlfsa2bu
   Q==;
X-CSE-ConnectionGUID: uQvPleTCQwKhZrvu1ioZnA==
X-CSE-MsgGUID: BdC40NhmRW6vQTB+sW74+Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11490"; a="65181998"
X-IronPort-AV: E=Sophos;i="6.16,301,1744095600"; 
   d="scan'208";a="65181998"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2025 15:53:22 -0700
X-CSE-ConnectionGUID: b346OZOERxWbSZTCgmld0A==
X-CSE-MsgGUID: A/7g8mkoSM63SbE3R80Orw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,301,1744095600"; 
   d="scan'208";a="155994331"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2025 15:53:22 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 10 Jul 2025 15:53:21 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 10 Jul 2025 15:53:21 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.42)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 10 Jul 2025 15:53:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ufkxq82KsE/Dl6KGAHgJl0WaAwojJq1AWbcRf9g49F1T0iIylydMZyyEBikpiDH/7M/eFkWpIW49Sod+/iqQkItCa66SXsS5TsEgjeU8X4P1luUimMJNw50Pr8BLBG6e+ix9wkMKN2f//XzmDWZjQ/qk/9wO8nCAujLHvRqg8F3ZO2R2gx9bZF+Oic3AbPhHlV4Bb3IhgBgb1a0j/udEy95qT+aLKp6i1h2YUHUR1QTL9kMAnDWkNgSdonDzZC4MlnRQmddbxXoeGbaybATw7EqGtCDKewyAZuieSwIWS4eWO/vvOLI0Q8lOsBX+vDmH7Tg77T4IrvoMI2K+1YqGJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wqlt9EFqOEMITHHHj3vHvb9YWthVDGjTbuydr5JFtSg=;
 b=LgRBWHU73os68nHCWvs/s1lMaHXU39e7l5tG0XEmje1W1sp/r8BNZVznWsPGXke7wrJV7WIjWqjdcpMbDY2SB5OmM5aBeD5HlApMN71jmFdydb0AFa01F8ziYSYgKGyza/w57UInVk7ZkGfVd/V7VREfdOWlwn4leFUyImZC74vfvRhTbPbMAp2Hh31ig0ZOc0UN5WJMNOZ4755sbLzs/rq3U84HfgbkhQqJrV4lAifVWt4fpDyL80ZpFxxgpUUFtvf4tQJrHIoSmD6P1JP/VkbS7l/Qq5nnplAkNVxocs56QVMwbKAzCBsRpF91zf2iZvQQqWzpIdVhaAhpbDmN8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by SA0PR11MB4624.namprd11.prod.outlook.com (2603:10b6:806:98::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.27; Thu, 10 Jul
 2025 22:52:50 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8901.023; Thu, 10 Jul 2025
 22:52:49 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "nikunj@amd.com" <nikunj@amd.com>
CC: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Edgecombe,
 Rick P" <rick.p.edgecombe@intel.com>, "bp@alien8.de" <bp@alien8.de>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH 1/2] KVM: x86: Reject KVM_SET_TSC_KHZ vCPU ioctl for TSC
 protected guest
Thread-Topic: [PATCH 1/2] KVM: x86: Reject KVM_SET_TSC_KHZ vCPU ioctl for TSC
 protected guest
Thread-Index: AQHb8JJLIckCSKhKI0SfYM7v0qBEG7QpeMyAgAKAwwA=
Date: Thu, 10 Jul 2025 22:52:49 +0000
Message-ID: <9b2e872b1948df129e5f893c2fbd9b11d0920696.camel@intel.com>
References: <cover.1752038725.git.kai.huang@intel.com>
	 <8aebb276ab413f2e4a6512286bd8b6def3596dfe.1752038725.git.kai.huang@intel.com>
	 <e3da1c7e-fa47-415f-99bf-f372057f0a75@amd.com>
In-Reply-To: <e3da1c7e-fa47-415f-99bf-f372057f0a75@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|SA0PR11MB4624:EE_
x-ms-office365-filtering-correlation-id: 722a0dad-ba45-4743-7bf2-08ddc0047ef1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?cjFjUC92Skk0eG8wVTNhcThRUm1UUEFKSmIrS3k5d204U3RUMUlvNk1sOG9O?=
 =?utf-8?B?NG9Od3hLRGtQRk1KYXRiQ3Jhb1dhMjRiRzZmaFNuRXZUSzgzQVU5RUZsSGVz?=
 =?utf-8?B?bWE2MVlMd29WelB1cFhaVVBpRjMxcktTRjVFTzBBU1BKQmJRZERTTStPL285?=
 =?utf-8?B?ekRvdmpBNy9peERGRWVhTlhVUkU2TDZxY0RER2d3RStkSE9uN0NYWEFocURZ?=
 =?utf-8?B?YkI4VEFrbFNKV1Y5OHVsUmViUEZMY1FLa0lMcUx4clpSYXk1V0pjRzQrUUMz?=
 =?utf-8?B?ZE5ZZ2V3QytleEhkSkdwV0loeUFFYk1YNXZQRWJmTjFodFJnU1lRTFo4M0RP?=
 =?utf-8?B?T0ZLUi9IakQ5MXhzbmVnZWdJVnVwcytybWtkdVQ0eTl1OGpPYVA5NmNQcE1v?=
 =?utf-8?B?U0pCdEpObWZuc2o4SjRpckIwUW5RWWNlV1hGQ3dPS2RRR0hKcTlpSlNZVW9E?=
 =?utf-8?B?RXlVajRhNzZpdmZDM2tidk1lSzdPaUhZRFVZUXl3WXNDVW5xUkc3MDRMWkdi?=
 =?utf-8?B?VTZ3Wkg5NzNmQWIxbUhCekdxT0g3UmUyMCtzcTQyVHFHYkY0WFg5NnRrWDFu?=
 =?utf-8?B?blpqU1l5R1RQVzZ5U0dFcnR0Z0FOWFRYK0xIdTJGM1E2UjBYL1UrbXE0bkJy?=
 =?utf-8?B?R1F2WEFHZmpmVGZ5VHppbEpsNVZORUVxYWFFOGd0eFBqWjJyYUtRQ1lpM2pH?=
 =?utf-8?B?V1JKRWk0Z0tqYjRoa0pydmdTbHpIaVlrdXVPcmRsaG9UdDhvelBMV09zWjBZ?=
 =?utf-8?B?NldFMm8wN1ZhdEpxRTdYeldCR25PRFQydXlkUVIxRjVpbitZNVRoaHdaU3dI?=
 =?utf-8?B?bHhva2dJdmpEWkJOdDBKbUJsV3pSOUFRampxOEprRzJOa2dBVUZxQ0V2YTl1?=
 =?utf-8?B?ekdZZ3JTN1FLRWJiUVE2S21IeVhoVnNTZ25KWE1OYlVvMnltK25NRFV0UTVs?=
 =?utf-8?B?dHJwMzEzeGNwai9HWGhWaFpxT2c3NVl6K2s3ZVZCVTZOVmppcXZsSjBMbTVL?=
 =?utf-8?B?ZEl5Qjd4bjB4VE1XTUpZRVFSTHV0djNsbHFDWElOWUM4QytpYWR2UUhibk5w?=
 =?utf-8?B?T0JsemlHMDJxaldqSkVKNmI1Rmx0anhXQnp2YTNHZXZCdlBraDZacml6TFd2?=
 =?utf-8?B?N0JiZkEvVzJPbWd2a2ZhM05qbkZLdTMybElZSlZmZWVLUFFVeHhLS2JWbnBO?=
 =?utf-8?B?UUJUWk42T0o4Z3VxNitjdjBmZXRsQW5IZU1jQk13dytEaXliSDIzY2pLK1Jr?=
 =?utf-8?B?LzZrT2FzUzlnZDJxMVZVbUg3ZlJ0OHdlRFo0dzkzY01wWk1hd3E3a0srYjc4?=
 =?utf-8?B?c1hyMzVjdGtHeVdqWm9xcUV1NWRKUHNpMmNjT0gyYVFTcmhCRzkrYUtRVk82?=
 =?utf-8?B?YjEvODQ2Q2RPTGQ0OXlCRjF3SW9kWTNISlovYXA3Q2lRTGsrMjg0cDgrZ2tB?=
 =?utf-8?B?UDF6dzhJUExaWktXdFRteSt4RkVpcmVBK0xSUXl3THhFY05VZGJzMVF2M0FV?=
 =?utf-8?B?UXZJNG8rUXBmZzhmajVsbThLandDRU94bEVSVzdQS2dXRTcveFZnVnJ2WGZL?=
 =?utf-8?B?S0Mrc2JZTE5IMmFBaGMxZ3pBVjZKRXFDSjhJcmpWdUh0TnNLS20yb3dSV3JK?=
 =?utf-8?B?c3lHU2wwbGgzMVdDNjFrdFVSK3RGeXRjVU9qZHNPcmVSeDc2REtlVFMzMzQ3?=
 =?utf-8?B?WXNuMjF2K1BkUnBTUForeDB2NEFnWFpzb05RdVgrTTBqejk1cHFaQ0ZwaG0z?=
 =?utf-8?B?cHpvUlY2Vk9wOFAwMU9LMWJmVHJTWVptSTNlQ3RhUkErdlVCaEJhQ3lIdEdV?=
 =?utf-8?B?YkkyekRNVzdYU0ZTSHVYWlQ1WjdBdXN2RXJCZmlkNTU1ZklSaExra0NzdVZN?=
 =?utf-8?B?RXlQQnZ1SXpjRnM1bG9MOVF2a3VlZGlTR3VjRk1Bdk10TkRIVUpEZWVRRHho?=
 =?utf-8?B?Wkp0RXNTK25lRm54ZERHbWNHMXY2OFJNKzNvTDM5bWkwWEJwL0p4emtFK1Rv?=
 =?utf-8?B?d09qcHZhcnRRPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SEtGelpJZHZPTnF6QzRzbkU5aCtZMFlMdlMxL2xQOTlHelVaa014cDhZRW9y?=
 =?utf-8?B?SXdiSUxja1k2WmZ2MmVrVkVSS1Jia29hakw3Z1plcjNVL2U1dmRVQmxlT2pB?=
 =?utf-8?B?em5ZQmZiOGhCVHk4djVIRE5DUmRsVDFTc28xd1JwTnd3RWxqQWJnYkNncndV?=
 =?utf-8?B?OXloc2lxajJ5Q0pxdldjK2pVbTBlMU1ZTzNDV3E5ZGQyQkpsdndqYjhlZ2ZE?=
 =?utf-8?B?bVQwMWRyTXA0QjQvMlc0ZXd2azNZSDN4K3IzOUoyaTFlWUJnWEtuSFl1NzJM?=
 =?utf-8?B?UHZ0dHhTelBmYmRsM05JY2VHYVlHWlVlQUVYYmVHb3RoRlBWbVB1bytZS0do?=
 =?utf-8?B?M3B2UUZGeHZnQmpnYkhnRlZRTE5VZkFnQWVLWXd4NTNDTFRkY004ZmFlQ3Fw?=
 =?utf-8?B?K2ROK3lGWkhlUVpVU0N3WXRKa2g1ditUdkR3RmtGbjdqMGE4NkdGWjF3QjUr?=
 =?utf-8?B?YUM5MWFwWWdFQldvYngwTHBiYkVNWk1Nc0ViaGR4ZXpvVC9MTFJXNkVaaU1R?=
 =?utf-8?B?YWhhcVB3bkRmV2RIWk0vaThsRC9MbUl4VnRRWnY4MTJQS1d5RDVpSFZWeHp2?=
 =?utf-8?B?SlQycS9hT3UvQWRLaUVnUDk1bFAxcCtROUFuS3JLa3RQU2xCZFdvUFdPaERN?=
 =?utf-8?B?Wms3KzhtNjkyTDBkaUpZK3BRQzlpbm9jaHBxWWJIdUU2WkZmNGszTTB4eXRj?=
 =?utf-8?B?eTlWRVJxMThKTzZ6RkVLOFFJNGF1TVQ1T2k5YUdvS0FjZExHQ3JEOTJhT01J?=
 =?utf-8?B?QUZ1SGZrK0J3T0syOWZ4NEV0UldQR25wMm00MDR5UE5YNERwVUE3YjVSTkE1?=
 =?utf-8?B?RnRFbklsREFYTmtsTjlnSCtFNUhIdkxjRXV3aFJTdDFmWWJTN3VoaXEvc3lE?=
 =?utf-8?B?WXZIc0hVV2VPdTd2WUlkc1Y5aDJiZnd5d0FqQ3dlU3RJelhoaDl2anVFd2xz?=
 =?utf-8?B?U2ZWdGlSdEUyd1dHcUxSQ0VKci9VWGxMUGdqbFpOUTluK283Ky9FUkdqaDNs?=
 =?utf-8?B?UEc5dG4yR2tEM1lhOHZiN0p3QWxQZDlyV1lSSTJQMm5KZDVMY3pxczRTLzNV?=
 =?utf-8?B?eXBsdnN5T0xUY3J1cWs0YUowY3dIOElBWE0vUWVZak0rYXFkMXc0QzBhN1hi?=
 =?utf-8?B?d3cyWGc2azNUZHoyS05mMUhLdC81KzB4dWVac01EQndlNUVNemNzYWVLaW1C?=
 =?utf-8?B?ck0ydkRSaFRHNkJCT0ljS2JKd1d2blRvS3VEQjJ3R2RCYlVwNFhnL1IxcFdD?=
 =?utf-8?B?OStBN0tFeklERmk5MSsxNlpMbTRGL3MxQkUyaUdRU3h1aFBweEZ4a3BmQ2hZ?=
 =?utf-8?B?V3QvNTZtUFY4WjFHbWorUzVNV3B1MEtCWUZXTXl6ZmMxQ2Q0N3g1M25FZ05i?=
 =?utf-8?B?azRCUmxnZGFna3MzVkYxSDNIZVNsYXQ1aHFjeFR1alJ1QkFpK1Arb0dtMU5W?=
 =?utf-8?B?bWpiYmg0UjFuc2pMR0ROTG1aaTBPYmFMMEJHRXdtVWVpSUxQY1pQN2FvV0ZC?=
 =?utf-8?B?Q2tHNGR0WmpwMlJIekZEeXVnaEN1YTF3ZW5HSHRZc205b0NxMGJHeURiMHZI?=
 =?utf-8?B?YytxL1NBRWdIQWdyM2swOUM0bmszRnBlbk9UampJb1dZTUMvbmlYQVR2MEpV?=
 =?utf-8?B?dFVwVnhuczJIemtkVnFhQ01IV0hNc0YwTWphd0FiMEZOcHkzK2Q0dC9HNUFS?=
 =?utf-8?B?bjZGZEVJcnBGUFlmZ1NwT0hUVHQwT2ZtRUhwR3lObU5FeXg2SHE2THhNYmlU?=
 =?utf-8?B?TGZBZXRvRnVvRmQ4dlF3bDlsNkR3YUpZdkx3WE9yVy9aR1cvZ3Z5Q05LckEr?=
 =?utf-8?B?K0xXaUllMG02b21xUkhwRlVzbm5HT1lGMHNPanNMVHV6MXRLOEZwVHNSaGUv?=
 =?utf-8?B?NkNFb2JraGNSMGdUMGxIYkVMYzdHVG5qMjRNL3k1TnFQOGRYeHJFQitRZnlu?=
 =?utf-8?B?K0Vxak9qTm9SV3pNYy8ycDhpeW11TGRuRk94ZW9idGRqMnRNZmtOZWJCTVlQ?=
 =?utf-8?B?SkpOT1BrMlJhZXFCMHpiVXQrOTRXN0xlUFAxR0hHaWlrRCszT3dUR1lsVUtS?=
 =?utf-8?B?VFdNZGJQWFNEb0phN3pGbU9va2NDaThWRDhpNllNQ0gxOXJGS1hYeHFNWERp?=
 =?utf-8?Q?OD1MTdx6bMJetZXaCfvRXPAqW?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <80363890A66C514BB5262E0FC6E595D1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 722a0dad-ba45-4743-7bf2-08ddc0047ef1
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jul 2025 22:52:49.8158
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qYhqm+C97S/sr4fKoMd81EzcUet/E+PFM5p2zQcnxzf5xDfgdHFv5Z+pzxPHtE6G3WMFqQOVsKYHAuoaIAgs8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4624
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA3LTA5IGF0IDE0OjA5ICswNTMwLCBOaWt1bmogQS4gRGFkaGFuaWEgd3Jv
dGU6DQo+IA0KPiBPbiA3LzkvMjAyNSAxMTowNyBBTSwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IFJl
amVjdCBLVk1fU0VUX1RTQ19LSFogdkNQVSBpb2N0bCBpZiBndWVzdCdzIFRTQyBpcyBwcm90ZWN0
ZWQgYW5kIG5vdA0KPiA+IGNoYW5nZWFibGUgYnkgS1ZNLg0KPiA+IA0KPiA+IEZvciBzdWNoIFRT
QyBwcm90ZWN0ZWQgZ3Vlc3RzLCBlLmcuIFREWCBndWVzdHMsIHR5cGljYWxseSB0aGUgVFNDIGlz
DQo+ID4gY29uZmlndXJlZCBvbmNlIGF0IFZNIGxldmVsIGJlZm9yZSBhbnkgdkNQVSBhcmUgY3Jl
YXRlZCBhbmQgcmVtYWlucw0KPiA+IHVuY2hhbmdlZCBkdXJpbmcgVk0ncyBsaWZldGltZS4gIEtW
TSBwcm92aWRlcyB0aGUgS1ZNX1NFVF9UU0NfS0haIFZNDQo+ID4gc2NvcGUgaW9jdGwgdG8gYWxs
b3cgdGhlIHVzZXJzcGFjZSBWTU0gdG8gY29uZmlndXJlIHRoZSBUU0Mgb2Ygc3VjaCBWTS4NCj4g
PiBBZnRlciB0aGF0IHRoZSB1c2Vyc3BhY2UgVk1NIGlzIG5vdCBzdXBwb3NlZCB0byBjYWxsIHRo
ZSBLVk1fU0VUX1RTQ19LSFoNCj4gPiB2Q1BVIHNjb3BlIGlvY3RsIGFueW1vcmUgd2hlbiBjcmVh
dGluZyB0aGUgdkNQVS4NCj4gPiANCj4gPiBUaGUgZGUgZmFjdG8gdXNlcnNwYWNlIFZNTSBRZW11
IGRvZXMgdGhpcyBmb3IgVERYIGd1ZXN0cy4gIFRoZSB1cGNvbWluZw0KPiA+IFNFVi1TTlAgZ3Vl
c3RzIHdpdGggU2VjdXJlIFRTQyBzaG91bGQgZm9sbG93Lg0KPiA+IA0KPiA+IE5vdGUgdGhpcyBj
b3VsZCBiZSBhIGJyZWFrIG9mIEFCSS4gIEJ1dCBmb3Igbm93IG9ubHkgVERYIGd1ZXN0cyBhcmUg
VFNDDQo+ID4gcHJvdGVjdGVkIGFuZCBvbmx5IFFlbXUgc3VwcG9ydHMgVERYLCB0aHVzIGluIHBy
YWN0aWNlIHRoaXMgc2hvdWxkIG5vdA0KPiA+IGJyZWFrIGFueSBleGlzdGluZyB1c2Vyc3BhY2Uu
DQo+ID4gDQo+ID4gU3VnZ2VzdGVkLWJ5OiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29v
Z2xlLmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBLYWkgSHVhbmcgPGthaS5odWFuZ0BpbnRlbC5j
b20+DQo+IA0KPiBOZWVkIHRvIGFkZCB0aGlzIGluIERvY3VtZW50YXRpb24vdmlydC9rdm0vYXBp
LnJzdCBhcyB3ZWxsLCBzYXlpbmcgdGhhdA0KPiBmb3IgVERYIGFuZCBTZWN1cmVUU0MgZW5hYmxl
ZCBTTlAgZ3Vlc3RzLCBLVk1fU0VUX1RTQ19LSFogdkNQVSBpb2N0bCBpcw0KPiBub3QgdmFsaWQu
DQo+IA0KPiANCg0KR29vZCBwb2ludC4gIFRoYW5rcyBmb3IgYnJpbmdpbmcgaXQgdXAuDQoNCkkg
d2lsbCBhZGQgYmVsb3cgdG8gdGhlIGRvYyB1bmxlc3Mgc29tZW9uZSBoYXMgY29tbWVudHM/DQoN
CkknbGwgcHJvYmFibHkgc3BsaXQgdGhlIGRvYyBkaWZmIGludG8gdHdvIHBhcnRzIGFuZCBtZXJn
ZSBlYWNoIHRvIHRoZQ0KcmVzcGVjdGl2ZSBjb2RlIGNoYW5nZSBwYXRjaCwgc2luY2UgdGhlIGNo
YW5nZSB0byB0aGUgZG9jIGNvbnRhaW5zIGNoYW5nZQ0KdG8gYm90aCB2bSBpb2N0bCBhbmQgdmNw
dSBpb2N0bC4NCg0KQnR3LCBJIHRoaW5rIEknbGwgbm90IG1lbnRpb24gU2VjdXJlIFRTQyBlbmFi
bGVkIFNFVi1TTlAgZ3Vlc3RzIGZvciBub3cNCmJlY2F1c2UgaXQgaXMgbm90IGluIHVwc3RyZWFt
IHlldC4gIEJ1dCBJIHRyaWVkIHRvIG1ha2UgdGhlIHRleHQgaW4gYSB3YXkNCnRoYXQgY291bGQg
YmUgZWFzaWx5IGV4dGVuZGVkIHRvIGNvdmVyIFNlY3VyZSBUU0MgZ3Vlc3RzLg0KDQpkaWZmIC0t
Z2l0IGEvRG9jdW1lbnRhdGlvbi92aXJ0L2t2bS9hcGkucnN0DQpiL0RvY3VtZW50YXRpb24vdmly
dC9rdm0vYXBpLnJzdA0KaW5kZXggNDNlZDU3ZTA0OGE4Li5hZDYxYmNiYTM3OTEgMTAwNjQ0DQot
LS0gYS9Eb2N1bWVudGF0aW9uL3ZpcnQva3ZtL2FwaS5yc3QNCisrKyBiL0RvY3VtZW50YXRpb24v
dmlydC9rdm0vYXBpLnJzdA0KQEAgLTIwMDYsNyArMjAwNiwxMyBAQCBmcmVxdWVuY3kgaXMgS0h6
Lg0KIA0KIElmIHRoZSBLVk1fQ0FQX1ZNX1RTQ19DT05UUk9MIGNhcGFiaWxpdHkgaXMgYWR2ZXJ0
aXNlZCwgdGhpcyBjYW4gYWxzbw0KIGJlIHVzZWQgYXMgYSB2bSBpb2N0bCB0byBzZXQgdGhlIGlu
aXRpYWwgdHNjIGZyZXF1ZW5jeSBvZiBzdWJzZXF1ZW50bHkNCi1jcmVhdGVkIHZDUFVzLg0KK2Ny
ZWF0ZWQgdkNQVXMuICBJdCBtdXN0IGJlIGNhbGxlZCBiZWZvcmUgYW55IHZDUFUgaXMgY3JlYXRl
ZC4NCisNCitGb3IgVFNDIHByb3RlY3RlZCBDb0NvIFZNcyB3aGVyZSBUU0MgaXMgY29uZmlndXJl
ZCBvbmNlIGF0IFZNIHNjb3BlIGFuZA0KK3JlbWFpbnMgdW5jaGFuZ2VkIGR1cmluZyBWTSdzIGxp
ZmV0aW1lLCB0aGUgVk0gaW9jdGwgc2hvdWxkIGJlIHVzZWQgdG8NCitjb25maWd1cmUgdGhlIFRT
QyBhbmQgdGhlIHZDUFUgaW9jdGwgZmFpbHMuDQorDQorRXhhbXBsZSBvZiBzdWNoIENvQ28gVk1z
OiBURFggZ3Vlc3RzLg0KDQoNCg0K

