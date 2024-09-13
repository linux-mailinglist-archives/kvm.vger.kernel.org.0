Return-Path: <kvm+bounces-26851-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 626F797876C
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 20:01:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 536F0B26663
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 18:01:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B990F84E11;
	Fri, 13 Sep 2024 18:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="zxZtUAiZ";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="G60VuKb8"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E8FABA50;
	Fri, 13 Sep 2024 18:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726250500; cv=fail; b=PsI4gok57jK9vFpVMUV91qIF2bW9fdcIKmljkJEAcQFJofvC0Bcpc2kCtS47DxWyYCByMPnAqE9Et7MuDqtt38Toj1nF8TbEqPleSDKNbiibBj7nCHJFfm6nGQDUTzFdSRC4o5CgvZuFpFAEdiSC66ar31vofwAFor1W0m5y8Us=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726250500; c=relaxed/simple;
	bh=FA+SL9gLXJfVzONQAw5dMOA1iNnU3xSuBEPWFZlQ0mo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nUWsXh6srP3x0tbPcliiYyIrc/Mhr8uEHUUclj5Wxiz9p969MoEEq/6coHGbJkS3R/twE/NbPYhw0F/xEphe231skbZQBV6vGPbwG0sm6r5nzy2JYJ40VG20QAdrw3PeVWyRlG0+FILEN9elmIHYpOqTuSsd7EprL0eaEtRnAKQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=zxZtUAiZ; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=G60VuKb8; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48DAMhbu012576;
	Fri, 13 Sep 2024 11:01:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=FA+SL9gLXJfVzONQAw5dMOA1iNnU3xSuBEPWFZlQ0
	mo=; b=zxZtUAiZQ9YwKosGH5ZtVjZFpcRE7OsOUhZixVZPx6aBsOAND3uUB4xHP
	UmfQiC5d7eRbIKxDS68SP2nY0c4cnwDWWlx+fj/ciueE+DYn4L/uh8iXtrycpl0i
	bM6u9mwyz/8Bz1cGgJXvfx0ExXn5A3Ob0k9dT9J5nkDXtwCZNAuRX2i3u2EwIwsB
	Pib2jPKGGyI6ejCw+57rh8hriTbT+JpGDgD4sTS5/do8he/eAnwuA6ZkwqjMkVRv
	H5tF0dTJ3Zq03/yXe8e/mGwMUu0JfG89jlLa9ZfImhRQ+Pa1UeOYxnChdTWO29jA
	r3oUFujUKk9+bqs2+wZ5bn9X069Mw==
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2040.outbound.protection.outlook.com [104.47.57.40])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 41gjr7yq7u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 13 Sep 2024 11:01:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YbzXh7cGrXcmjHb5bGzH/yeAoHD9U39rP7q8HIpvSbrQmGJeV9oHFkKiG+TZ1oOL6pQ6j+WldF8mecTtqkyBOzYEAIfKDActISX3T8BWr8ncrQlOEzrYPaWSF57uZRdcNW/ZqIg5s3j8sM4ikur8oVEjP+/Lm2NeSJxGJ8F3beRSyPcvDRhSlSEU04zH1+qR/YphjpQf5oqf5fQY3T+cwXj06z2H6yZw+YLR5ySD7lYni7bWevJXWdfGG14D2eMDPWC399FpLnhVXOQVQ+taP3FDXLqaPCJHTryvjnYhH0qw/bxz5bpoVwvPMJvKz1ADTMGqgJU32XlXanCpf3M65w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FA+SL9gLXJfVzONQAw5dMOA1iNnU3xSuBEPWFZlQ0mo=;
 b=DkEd1St+GIlEaNZqwcFSCwrMWu45+70yP4rLXOueQMNSXhJ00o4u0cyD849rijXEMWX+SFOybVSaNE+yMvhPijuezLQKMcuybdv7byj24vgmcLFpLk04RAHZoyZCmw7I6B/0gB2IXlyxY5FP2EQ4s74TXKq1QJPnNzZUEVHIny9hnrGumnH4A4o2UGtqOrddnJDRfjKWKMoam1I3itti/b2RWXcm/q/Qi5/gMCg+NP4zmHQfX5TC/MH4Nua0GVtNgHbuneEpvV2OD98ITy7d2uqfbYTeN3ItIa2ASfhGm+y6j1SLnaF6ZjzNhSAwXjEhZyXLMzUwWpvTbvGCQlf4mA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FA+SL9gLXJfVzONQAw5dMOA1iNnU3xSuBEPWFZlQ0mo=;
 b=G60VuKb8X4SP/KuN3LJK1yYMC7CV26OuvJzzdJUhbV9gi6HsvfGeDix2OUM9odW+i6DMAIi321eyPs0FxPgSEHgOjqpZ6k4a1DJhfOLBewUnaCDDcAdEAC1G0h2Mlzr0qvjMuTYbVLchmI/FINP6htTUCv9igQpC3A8HJurxsU62Liw1HGwKbVrDuEtZYTghg6XvSMCT4nxgK+jrhJbW9UlPUTMF64P/lUrp9+1BM9nWL6FvzZWB9n/2MUqeZ3Vv8xexorKc9xXegJFSiO0d2Y0207uVE8134DktIaLPdIpHVrfllajmf83vZ5msU2InlYKdaXOu1Vcz4WsxhuM8Ig==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by CH0PR02MB7963.namprd02.prod.outlook.com
 (2603:10b6:610:104::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.18; Fri, 13 Sep
 2024 18:01:07 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%5]) with mapi id 15.20.7918.020; Fri, 13 Sep 2024
 18:01:07 +0000
From: Jon Kohler <jon@nutanix.com>
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
CC: Chao Gao <chao.gao@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>,
        Josh
 Poimboeuf <jpoimboe@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Dave Hansen
	<dave.hansen@linux.intel.com>, X86 ML <x86@kernel.org>,
        "H. Peter Anvin"
	<hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        "kvm @ vger . kernel .
 org" <kvm@vger.kernel.org>
Subject: Re: [PATCH] x86/bhi: avoid hardware mitigation for
 'spectre_bhi=vmexit'
Thread-Topic: [PATCH] x86/bhi: avoid hardware mitigation for
 'spectre_bhi=vmexit'
Thread-Index:
 AQHbBRtn4jznGhv7KU+IMqTomlXzNrJUQp8AgAAIdoCAAAs8AIAA2x8AgACtw4CAABymgIAAB7MA
Date: Fri, 13 Sep 2024 18:01:07 +0000
Message-ID: <7A4F1605-FB57-4A04-AD6C-F077D8E404E1@nutanix.com>
References: <20240912141156.231429-1-jon@nutanix.com>
 <20240912151410.bazw4tdc7dugtl6c@desk>
 <070B4F7E-5103-4C1B-B901-01CE7191EB9A@nutanix.com>
 <20240912162440.be23sgv5v5ojtf3q@desk> <ZuPNmOLJPJsPlufA@intel.com>
 <3244950F-0422-49AD-812D-DE536DAF5D7E@nutanix.com>
 <20240913173323.6guq4p2h4z7ulgr3@desk>
In-Reply-To: <20240913173323.6guq4p2h4z7ulgr3@desk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3774.300.61.1.2)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV8PR02MB10287:EE_|CH0PR02MB7963:EE_
x-ms-office365-filtering-correlation-id: 4829e805-3754-403b-7f9a-08dcd41e0a8d
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?N2grbnpGMEZaWEgyRzlYZ1ZDaXoyMWV0eGdJbkdvQWNKaHMzRVVJYkpXdk9P?=
 =?utf-8?B?eVkzQUlnamxwMHV4OGlDVmh3RmhvNHFOMnNkdFhoYXZmUFgrMUN3R0xBcEp2?=
 =?utf-8?B?aU1tMVU5dXRXRGhJRU94bFJsa2JGaDlQM1ZscFlTSjBiSnhabUY3OEtSQjF5?=
 =?utf-8?B?WW1ISmNGb3FLRDFyZVBYbXo4MnpuZ201VVV5TFFwV1NrcTVKSHdvVTJobXVX?=
 =?utf-8?B?VjQweENIUDdTb3o4eEtjaWx4c2pSenIwcGtJRnRiMktzbzI1UU9xSjhFV3pz?=
 =?utf-8?B?Q1NNOFZrZ3YzZFBhQzEyQ1Q1UjkrcVAvOERHU0FEU3BReGprK2VURWNCcXhD?=
 =?utf-8?B?SWhJbjNxV1ltcG9xYVczZGJkOWtqQzh1QUhNY003TS93QmxKWG4zSVo0S0J6?=
 =?utf-8?B?cDY5KzJZU2cyV3B6NXhjVmQwSy9saU9UUGtabDRENzRLc1hHNC95TW15NHZY?=
 =?utf-8?B?WVc3dzdlL1dMd3RTWitaVDh4T2VONHBhenV2c0FXWFJlTnFKNiswbVBhM0k3?=
 =?utf-8?B?RzBjR2xXeDlBdjVwYzBjNnd5Y3VndXR3VFNGbVY4a3pjZTE4b1V6UkNjd3lj?=
 =?utf-8?B?dmxvdWxhWEpENU96cmdKUnFvbDY0K1ViU3pxMUZrdXJRM2NkUCtFdFVGYjU5?=
 =?utf-8?B?bjcvTlA0VmQzSGNqMXVlSjA4MjVjZC9UdTlYZnljbU54M2VJSDlsclErVC8v?=
 =?utf-8?B?SkRpYkJFNE1EdHBxSGpXV0lsSHRoZENYTldKb0h2bkFJWWxUVnBTMHorV1Vv?=
 =?utf-8?B?RzlLcGNNdVJOZnlPRzJCVmE2LzJuNnE5Q1B3dldzRGtmV09vQ1hEaG1MYlpS?=
 =?utf-8?B?S3NvWThlYjJFbjFEVlJ1L0pEL3F6c0VVZyt6WXdCRFlGdTJsTTQzRko5SzFr?=
 =?utf-8?B?bDFVbEdGVlZZd0hKNVZHRnI0M2ZHN1F1R2hHTGErQmlTUmNteVdsbDBwbko4?=
 =?utf-8?B?akhqU0FmeUpWNmhSOFlNQzdwNnMzNHdYaDk4bk5QY3JrNkRWbnU1NnQ3TVEx?=
 =?utf-8?B?RmpvUGh2bjhyRVBEQ1VnTXlQTUJEM1VOTzRBdkFiQUJZWXRTTUwwcFN5YU5W?=
 =?utf-8?B?SkdJelZTMk01NzlobXk3bU05cHozeHJSSGhZeSt3dUoycU5jbW9FTnNRR0lY?=
 =?utf-8?B?NEcxR01VTTJQOEV6SGV3UEM2bURsdGlPdGZtVjJnOHk0eVRlSTRtaDgzeWJS?=
 =?utf-8?B?VkRLOFE5RDlVN3ArWW5DMjV2RlJiK0YrNTV3RFNJZjdXSCtrakJmTmwwQ2Ji?=
 =?utf-8?B?ZytpYzFNRUtyVXZwVVk1T1JmdkthZ3FIbWZnRHRocksraTFZejFWTzgvRzJU?=
 =?utf-8?B?WWV6TWowalRCeklLWEhpUlNWT3VlRGw5YjRWKzl6NGVxVVFiUmZOdUVHb0F5?=
 =?utf-8?B?VnYxaVpjMVNDbzNRUDBzOXd2VEY3M0tGYUkxSm5VS1VZL0dYbXR3dk54enJp?=
 =?utf-8?B?TzNFKzRRc050eTgwV3RCME5CeDcyMi9qcGFKYkhTa2FlblNBWTdReVhvajlT?=
 =?utf-8?B?SWFPZCtpWmE0eEN1OGhMcnIrTlZKdUtuaWdnemdqcW9PYTRXdENJenhSTGxp?=
 =?utf-8?B?Z0xGUXhWVWhFb2xaUU9vQ0xHRnVtWDNpZHhpN1dmZTlGS3NUSGNEZXJvcCsv?=
 =?utf-8?B?MEZ0dldGVitESFZnSkFWVE9MTldRUktHc0J3UjU1L0NFMXhuTng1ZGRQZmJn?=
 =?utf-8?B?MGJkc2ZmblZZQktia3NRQnRXMVRycVpNWHJuL0ZSOHRoRFJuci90cGlMMGJB?=
 =?utf-8?B?TWUzY3huNmZuTnVqajMvWnNrMzQyME85bTFBdzJUbEgzTE43RzNJRGxyZFl6?=
 =?utf-8?Q?y8EJXDcin8mKphZnkHDw2SQDIVIs1VS3SfyYU=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dmZaV0JmcWE5ZkNycHhyQ21SQ1VNUDg3N09iVEVLdFVrNXVwWmd6ZkVaMUpB?=
 =?utf-8?B?R3hSdlBndXBkSFEzUnBWQ3RSdEx6OTc4L2VqMHRsRUJDSWR5d3lJdFEyeHl4?=
 =?utf-8?B?L2kzTiswN3FXSVpieUJwbjdwUVlVMUhoN0kwK1VyVWhrbFV2Y21qTGhFK3NH?=
 =?utf-8?B?cElFMU1zYkNoY1FMVXM5bDFqWHFqNWsycUxRYU5FdTNhalN3V3RjS0lERDA2?=
 =?utf-8?B?MnFEZUxCOG9UUGZmNGpod2pNTGk3MmFUbk13NTQ4dmZGbTJJOVBwdjhEVnVU?=
 =?utf-8?B?OC9wRXVPU0xTVFBUYkVaM1BqcytLMjVLWGsyWGtuLzEzeVJKNTJndFlsM0o5?=
 =?utf-8?B?WDVlMEhmbUR2UGhaUm1oUFp2QjNDdnU5S0EwTndmMDVPNzg5UzlpcEFxOVNN?=
 =?utf-8?B?R3NqcnFTL0p1YjNCcnlZMXAvUkVhems0UG53SGlXODIwaFh0eU9UclF3Vlp1?=
 =?utf-8?B?Z3VrM0NFQzFVVC9qOElmNTNUUEtZNEpEVm1uVi9lKzNIR1E0MnZiQzh0eldQ?=
 =?utf-8?B?RlJTb05nR2RMUU5RQ1FUMEluQjJmeUxpWXRXU1pkLzg0Vnp6QlRSNSs4dVNI?=
 =?utf-8?B?eG9jTWJ3MGFjdmpvSlQ4MndnaElZbktKd200K2loRU9aL1QyaVprK0FZU0Fi?=
 =?utf-8?B?TWhDMDA1eklUaUk3UjQ3K0hycXEyWnJ3N0g1OStFalFyWW96R2dZaTZibTgv?=
 =?utf-8?B?UnM2TmU1ejFQbmkvYkx0aHhmeDFjQXZGcEdkZGRtNkw1U2tMeEtEUFRqQ3U1?=
 =?utf-8?B?SktPYzMwTWxVYXpraGtqRk9VOFdxeFpPb1lYVGdhamVXWXc4NWJzcmZpWFJ0?=
 =?utf-8?B?dzB5VUZhNFUyOTBnMlVTM2xwOGxVYWZ1WjZQZVA2Umh4Mnc0cFpKQjFCMUw4?=
 =?utf-8?B?SzFwODBGRFkyOFQzOWZnbGZzOXNIczlGbWJKOEZaSTRORDZXeXBrNlJQSGNI?=
 =?utf-8?B?L3dILzMvdlVmYlRIZ1BjWmJUcEVaQTZSTURYUDQ0RmJLVFVMMnQ2MTNWZTlq?=
 =?utf-8?B?bGhsb3hRUnpTTWpoMTNkTnljdHRJa0xVK2U0WUwwaXhkTFRTZFdXZ1RjT2dE?=
 =?utf-8?B?a1Z4VWRhUTRHN3l2anhCZy94MmU0OFlMSlZEUFVrZGlTb3krRTFFZDhlUzQw?=
 =?utf-8?B?OW5nQkdHM2o1NWdhN2g5Q0F1M1JWMCttcWR3K0tYM1ZWMXhKL0tpVjNPUjFh?=
 =?utf-8?B?NDJoZ0RUaU1neGRkaDFJbFM5ZHNEMFp4bzU4WVJ2SEtCT1J4aUJRMklhcHow?=
 =?utf-8?B?eUJ6ekJyQ3ZTRmlUcDhDZm1yREZHc2dFQkEvK2FrSlJ2dml0MU5PS3dkRktR?=
 =?utf-8?B?dmNLZk5pUVExRGp2dDlHTitqWEJvd3lCUk5wem15WXBsR2xhZjFFTW9XZTVL?=
 =?utf-8?B?S21ZQUFGUkNPVVpQZ3U2aEwyTEZvV2JNeUErZ2s3ZzUwZHpEZ3RIYUlyOGpZ?=
 =?utf-8?B?U0ZUWlpHcXM5bzMrWHpSRHZTbStwSHpreGgzZVhaQmlvV21ia2E3TmsweGcy?=
 =?utf-8?B?M0FVSXVoSmZOR3hqRmJrOWVqc1RDdUZhY0pKS2Y3STZ3aUh5SytVOHlsV0Nv?=
 =?utf-8?B?S2d4KzByVFJRaFYveUZaOUZDV2kyM3dJM1dtcGNraHBDNTAwM3dTVEh3OTll?=
 =?utf-8?B?MzNiU0pvSDRGMTMrMTlXSVFhUnNkQ09TVkZlZGpNdGd5OVpWbS91Zmw2MzlU?=
 =?utf-8?B?eWxHejFGcVNpOTVScjZzQ1lMK1FmVkZQOUlPMHNzNWdYYVRmcTcyOTNMU3o5?=
 =?utf-8?B?dUh4SVRESHVwUmk3WnNYdmdtNi9DK0k5S2Z0SDhMZjZIcDBNL1BoS1d6MHF3?=
 =?utf-8?B?Rk9SOUp4OC8zd2xmRXNmY0htSEJDbnVGaXlvaTZJNHZmZ1lvM1JLTlhLR1kz?=
 =?utf-8?B?dE1VSHhNQmQwNGg0Q0N2YlZjeDZXdm5lMmZsUU45YlZvUm5kNnJMUHU1c1ZC?=
 =?utf-8?B?S1RhUUlMejlwbDhTcGc1NDErdlIzQ0V1NDU2TmF5MHorR0N4UStvZVpPWW1E?=
 =?utf-8?B?R2gvRE1TMFFodTFQSnVobWxYOE96WmhYWWprTVN0MWJHYllQWmtGeXYxd0RL?=
 =?utf-8?B?bHc4cklaSGg3UWNhdmhtNWl4Mk1FaXBXWkp4VWxadFdzbFI0NFBKUlpQdUkr?=
 =?utf-8?B?c3d0bGFFRlZHWFhlZHhWelY2L004NkNGUmwvaWhKV2cwakFham5ISEV3NXFR?=
 =?utf-8?B?QlJzclk4V2xJOEtHbmZraVBKU1hpWWhYekFVazhlRlZ3MFlNcjhzSit2WDBB?=
 =?utf-8?B?YWFwUEIvbEI0YnIyRkZoTnA1OEdBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EF39CDE1923A69458ED8AA04E5D0EB01@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV8PR02MB10287.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4829e805-3754-403b-7f9a-08dcd41e0a8d
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2024 18:01:07.0448
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3HQb5PjwR3rMzIgmb3iGvSGRv9Q5s3E0lEGssjruCCSsM9FlXfkYg3cmg0qSR1w2S8/lyT+F1gL9+4nPg2CPJSGsx+Um4m+bazzUdmwiahg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR02MB7963
X-Authority-Analysis: v=2.4 cv=J9z47xnS c=1 sm=1 tr=0 ts=66e47de7 cx=c_pps a=6DIaztarb0XTwjBPIWoXxQ==:117 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=EaEq8P2WXUwA:10 a=0034W8JfsZAA:10 a=0kUYKlekyDsA:10 a=QyXUC8HyAAAA:8
 a=yMhMjlubAAAA:8 a=3P2V5O22bJnmHsLdcgYA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: MXY2KxDOemcFa-hPkULfxV3-6An3gouW
X-Proofpoint-GUID: MXY2KxDOemcFa-hPkULfxV3-6An3gouW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-13_11,2024-09-13_02,2024-09-02_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gU2VwIDEzLCAyMDI0LCBhdCAxOjMz4oCvUE0sIFBhd2FuIEd1cHRhIDxwYXdhbi5r
dW1hci5ndXB0YUBsaW51eC5pbnRlbC5jb20+IHdyb3RlOg0KPiANCj4gIS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS18DQo+
ICBDQVVUSU9OOiBFeHRlcm5hbCBFbWFpbA0KPiANCj4gfC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0hDQo+IA0KPiBPbiBG
cmksIFNlcCAxMywgMjAyNCBhdCAwMzo1MTowMVBNICswMDAwLCBKb24gS29obGVyIHdyb3RlOg0K
Pj4gDQo+PiANCj4+PiBPbiBTZXAgMTMsIDIwMjQsIGF0IDE6MjjigK9BTSwgQ2hhbyBHYW8gPGNo
YW8uZ2FvQGludGVsLmNvbT4gd3JvdGU6DQo+Pj4gDQo+Pj4gIS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS18DQo+Pj4gQ0FV
VElPTjogRXh0ZXJuYWwgRW1haWwNCj4+PiANCj4+PiB8LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLSENCj4+PiANCj4+PiBP
biBUaHUsIFNlcCAxMiwgMjAyNCBhdCAwOToyNDo0MEFNIC0wNzAwLCBQYXdhbiBHdXB0YSB3cm90
ZToNCj4+Pj4gT24gVGh1LCBTZXAgMTIsIDIwMjQgYXQgMDM6NDQ6MzhQTSArMDAwMCwgSm9uIEtv
aGxlciB3cm90ZToNCj4+Pj4+PiBJdCBpcyBvbmx5IHdvcnRoIGltcGxlbWVudGluZyB0aGUgbG9u
ZyBzZXF1ZW5jZSBpbiBWTUVYSVRfT05MWSBtb2RlIGlmIGl0IGlzDQo+Pj4+Pj4gc2lnbmlmaWNh
bnRseSBiZXR0ZXIgdGhhbiB0b2dnbGluZyB0aGUgTVNSLg0KPj4+Pj4gDQo+Pj4+PiBUaGFua3Mg
Zm9yIHRoZSBwb2ludGVyISBJIGhhZG7igJl0IHNlZW4gdGhhdCBzZWNvbmQgc2VxdWVuY2UuIEni
gJlsbCBkbyBtZWFzdXJlbWVudHMgb24NCj4+Pj4+IHRocmVlIGNhc2VzIGFuZCBjb21lIGJhY2sg
d2l0aCBkYXRhIGZyb20gYW4gU1BSIHN5c3RlbS4NCj4+Pj4+IDEuIGFzLWlzICh3cm1zciBvbiBl
bnRyeSBhbmQgZXhpdCkNCj4+Pj4+IDIuIFNob3J0IHNlcXVlbmNlIChhcyBhIGJhc2VsaW5lKQ0K
Pj4+Pj4gMy4gTG9uZyBzZXF1ZW5jZQ0KPj4+PiANCj4+IA0KPj4gUGF3YW4sDQo+PiANCj4+IFRo
YW5rcyBmb3IgdGhlIHBvaW50ZXIgdG8gdGhlIGxvbmcgc2VxdWVuY2UuIEkndmUgdGVzdGVkIGl0
IGFsb25nIHdpdGggDQo+PiBMaXN0aW5nIDMgKFRTWCBBYm9ydCBzZXF1ZW5jZSkgdXNpbmcgS1VU
IHRzY2RlYWRsaW5lX2ltbWVkIHRlc3QuIFRTWCANCj4+IGFib3J0IHNlcXVlbmNlIHBlcmZvcm1z
IGJldHRlciB1bmxlc3MgQkhJIG1pdGlnYXRpb24gaXMgb2ZmIG9yIA0KPj4gaG9zdC9ndWVzdCBz
cGVjX2N0cmwgdmFsdWVzIG1hdGNoLCBhdm9pZGluZyBXUk1TUiB0b2dnbGluZy4gSGF2aW5nIHRo
ZQ0KPj4gdmFsdWVzIG1hdGNoIHRoZSBESVNfUyB2YWx1ZSBpcyBlYXNpZXIgc2FpZCB0aGFuIGRv
bmUgYWNyb3NzIGEgZmxlZXQNCj4+IHRoYXQgaXMgYWxyZWFkeSB1c2luZyBlSUJSUyBoZWF2aWx5
Lg0KPj4gDQo+PiBUZXN0IFN5c3RlbToNCj4+IC0gSW50ZWwgWGVvbiBHb2xkIDY0NDJZLCBtaWNy
b2NvZGUgMHgyYjAwMDVjMA0KPj4gLSBMaW51eCA2LjYuMzQgKyBwYXRjaGVzLCBxZW11IDguMg0K
Pj4gLSBLVk0gVW5pdCBUZXN0cyBAIGxhdGVzdCAoMTdmNmYyZmQpIHdpdGggdHNjZGVhZGxpbmVf
aW1tZWQgKyBlZGl0czoNCj4+IC0gVG9nZ2xlIHNwZWMgY3RybCBiZWZvcmUgdGVzdCBpbiBtYWlu
KCkNCj4+IC0gVXNlIGNwdSB0eXBlIFNhcHBoaXJlUmFwaWRzLXYyDQo+PiANCj4+IFRlc3Qgc3Ry
aW5nOg0KPj4gVEVTVE5BTUU9dm1leGl0X3RzY2RlYWRsaW5lX2ltbWVkIFRJTUVPVVQ9OTBzIE1B
Q0hJTkU9IEFDQ0VMPSB0YXNrc2V0IC1jIDI2IC4veDg2L3J1biB4ODYvdm1leGl0LmZsYXQgXA0K
Pj4gLXNtcCAxIC1jcHUgU2FwcGhpcmVSYXBpZHMtdjIsK3gyYXBpYywrdHNjLWRlYWRsaW5lIC1h
cHBlbmQgdHNjZGVhZGxpbmVfaW1tZWQgfGdyZXAgdHNjZGVhZGxpbmUNCj4+IA0KPj4gVGVzdCBS
ZXN1bHRzOg0KPj4gMS4gc3BlY3RyZV9iaGk9b24sIGhvc3Qgc3BlY19jdHJsPTEwMjUsIGd1ZXN0
IHNwZWNfY3RybD0xOiB0c2NkZWFkbGluZV9pbW1lZCAzODc4IChXUk1TUiB0b2dnbGluZykNCj4+
IDIuIHNwZWN0cmVfYmhpPW9uLCBob3N0IHNwZWNfY3RybD0xMDI1LCBndWVzdCBzcGVjX2N0cmw9
MTAyNTogdHNjZGVhZGxpbmVfaW1tZWQgMzE1MyAobm8gV1JNU1IgdG9nZ2xpbmcpDQo+PiAzLiBz
cGVjdHJlX2JoaT12bWV4aXQsIEJIQiBsb25nIHNlcXVlbmNlLCBob3N0L2d1ZXN0IHNwZWNfY3Ry
bD0xOiB0c2NkZWFkbGluZV9pbW1lZCAzNjI5IChzdGlsbCBiZXR0ZXIgdGhhbiB0ZXN0IDEsIHBl
bmFsdHkgb25seSBvbiBleGl0KQ0KPj4gNC4gc3BlY3RyZV9iaGk9dm1leGl0LCBUU1ggYWJvcnQg
c2VxdWVuY2UsIGhvc3QvZ3Vlc3Qgc3BlY19jdHJsPTE6IHRzY2RlYWRsaW5lX2ltbWVkIDMyOTQg
KGJlc3QgZ2VuZXJhbCBwdXJwb3NlIHBlcmZvcm1hbmNlKQ0KPiANCj4gVGhpcyBsb29rcyBwcm9t
aXNpbmcuDQoNClRoYW5rcyEgSeKAmWxsIHNlbmQgb3V0IGEgdjIgc28geW91IGNhbiBzZWUgaG93
IGl0IGNvbWVzIHRvZ2V0aGVyLg0KDQo+IA0KPj4gNS4gc3BlY3RyZV9iaGk9dm1leGl0LCBUU1gg
YWJvcnQgc2VxdWVuY2UsIGhvc3Qgc3BlY19jdHJsPTEsIGd1ZXN0IHNwZWNfY3RybD0xMDI1OiB0
c2NkZWFkbGluZV9pbW1lZCA0MDExIChuZWVkcyBvcHRpbWl6YXRpb24pDQo+IA0KPiBPbmNlIFFF
TVUgYWRkcyBzdXBwb3J0IGZvciBleHBvc2luZyBCSElfQ1RSTCwgdGhpcyBpcyBhIHZlcnkgbGlr
ZWx5DQo+IHNjZW5hcmlvLiBUbyBvcHRpbWl6ZSB0aGlzLCBob3N0IG5lZWRzIHRvIGhhdmUgQkhJ
X0RJU19TIHNldC4gV2UgYWxzbyBuZWVkDQo+IHRvIGFjY291bnQgZm9yIHRoZSBjYXNlIHdoZXJl
IHNvbWUgZ3Vlc3RzIHNldCBCSElfRElTX1MgYW5kIG90aGVycyBkb250Lg0KDQpRRU1VIGJhc2Ug
ZW5hYmxlbWVudCBpcyBvbmx5IG9uZSBwYXJ0IG9mIHRoZSBwdXp6bGUuIFRoYXQgd291bGQgbWVh
bg0KYSBjcHUgdHlwZSBjaGFuZ2UgKGUuZy4gU2FwcGhpcmVSYXBpZHMtVnh4eCksIHdoaWNoIFZN
TSBjb250cm9sIHBsYW5lcw0KbmVlZCB0byBwaWNrdXAgKGUuZy4gbGlidmlydCksIGluIGFkZGl0
aW9uIHRvIGd1ZXN0IE9T4oCZcyBuZWVkaW5nIHRvIHBpY2sgaXQgdXAgdG9vLg0KDQpFdmVuIHRo
ZW4sIGl0IGlzbuKAmXQgYWx3YXlzIGF1dG9tYXRpYy4gV2luZG93cyBmb3IgZXhhbXBsZSBkaXNh
YmxlcyB0aGVpcg0KQkhJIG1pdGlnYXRpb24gYnkgZGVmYXVsdCwgcmVxdWlyaW5nIGFkbWluIGlu
dGVydmVudGlvbiB0byBtYW51YWxseSBtb2RpZnkgdGhlDQpyZWdpc3RyeSB0byBlbmFibGUgaXQ6
IA0KaHR0cHM6Ly9tc3JjLm1pY3Jvc29mdC5jb20vdXBkYXRlLWd1aWRlL3Z1bG5lcmFiaWxpdHkv
Q1ZFLTIwMjItMDAwMSANCg0KSSBkb27igJl0IGtub3cgb2ZmaGFuZCBpZiB0aGF0IGlzIEJISV9E
SVNfUyBvciBqdXN0IGEgY2xlYXIgbG9vcCwgaXQgZG9lc27igJl0IHNheQ0KDQpTZXJ2ZXIgU0tV
cyBhcmUgZGlzYWJsZWQgYnkgZGVmYXVsdDogaHR0cHM6Ly9zdXBwb3J0Lm1pY3Jvc29mdC5jb20v
ZW4tdXMvdG9waWMva2I0MDcyNjk4LXdpbmRvd3Mtc2VydmVyLWFuZC1henVyZS1zdGFjay1oY2kt
Z3VpZGFuY2UtdG8tcHJvdGVjdC1hZ2FpbnN0LXNpbGljb24tYmFzZWQtbWljcm9hcmNoaXRlY3R1
cmFsLWFuZC1zcGVjdWxhdGl2ZS1leGVjdXRpb24tc2lkZS1jaGFubmVsLXZ1bG5lcmFiaWxpdGll
cy0yZjk2NTc2My0wMGUyLThmOTgtYjYzMi0wZDk2ZjMwYzhjOGUgDQpEZXNrdG9wL0NsaWVudCBT
S1VzIGFyZSBkaXNhYmxlZCBieSBkZWZhdWx0OiBodHRwczovL3N1cHBvcnQubWljcm9zb2Z0LmNv
bS9lbi11cy90b3BpYy9rYjQwNzMxMTktd2luZG93cy1jbGllbnQtZ3VpZGFuY2UtZm9yLWl0LXBy
b3MtdG8tcHJvdGVjdC1hZ2FpbnN0LXNpbGljb24tYmFzZWQtbWljcm9hcmNoaXRlY3R1cmFsLWFu
ZC1zcGVjdWxhdGl2ZS1leGVjdXRpb24tc2lkZS1jaGFubmVsLXZ1bG5lcmFiaWxpdGllcy0zNTgy
MGE4YS1hZTEzLTEyOTktODhjYy0zNTdmMTA0ZjViMTENCg0KPiANCj4+IEluIHNob3J0LCB0aGVy
ZSBpcyBhIHNpZ25pZmljYW50IHNwZWVkdXAgdG8gYmUgaGFkIGhlcmUuDQo+PiANCj4+IEFzIGZv
ciB0ZXN0IDUsIGhvbmVzdCB0aGF0IGlzIHNvbWV3aGF0IGludmFsaWQgYmVjYXVzZSBpdCB3b3Vs
ZCBiZQ0KPj4gZGVwZW5kZW50IG9uIHRoZSBWTU0gdXNlciBzcGFjZSBzaG93aW5nIEJISV9DVFJM
Lg0KPiANCj4gUmlnaHQuDQo+IA0KPj4gUUVNVSBhcyBhbiBleGFtcGxlIGRvZXMgbm90IGRvIHRo
YXQsIHNvIGV2ZW4gd2l0aCBsYXRlc3QgcWVtdSBhbmQgbGF0ZXN0DQo+PiBrZXJuZWwsIGd1ZXN0
cyB3aWxsIHN0aWxsIHVzZSBCSEIgbG9vcCBldmVuIG9uIFNQUisrIHRvZGF5LCBhbmQgdGhleQ0K
Pj4gY291bGQgdXNlIHRoZSBUU1ggbG9vcCB3aXRoIHRoaXMgcHJvcG9zZWQgY2hhbmdlIGlmIHRo
ZSBWTU0gZXhwb3NlcyBSVE0NCj4+IGZlYXR1cmUuDQo+IA0KPiBJIGRpZCBub3Qga25vdyB0aGF0
IFFFTVUgZG9lcyBub3QgZXhwb3NlIENQVUlELkJISV9DVFJMLiBDaGFvLCBjb3VsZCB5b3UNCj4g
cGxlYXNlIGhlbHAgZ2V0dGluZyB0aGlzIGZlYXR1cmUgZXhwb3NlZCBpbiBRRU1VPw0KPiANCj4+
IEknbSBoYXBweSB0byBwb3N0IGEgVjIgcGF0Y2ggd2l0aCBteSBUU1ggY2hhbmdlcywgb3IgdGFr
ZSBhbnkgb3RoZXINCj4+IHN1Z2dlc3Rpb25zIGhlcmUuDQo+IA0KPiBXaXRoIENQVUlELkJISV9D
VFJMIGV4cG9zZWQgdG8gZ3Vlc3RzLCB0aGlzOg0KPiANCj4+IDIuIHNwZWN0cmVfYmhpPW9uLCBo
b3N0IHNwZWNfY3RybD0xMDI1LCBndWVzdCBzcGVjX2N0cmw9MTAyNTogdHNjZGVhZGxpbmVfaW1t
ZWQgMzE1MyAobm8gV1JNU1IgdG9nZ2xpbmcpDQo+IA0KPiB3aWxsIGJlIHRoZSBtb3N0IGNvbW1v
biBjYXNlLCB3aGljaCBpcyBhbHNvIHRoZSBiZXN0IHBlcmZvcm1pbmcuIElzbid0IGl0DQo+IGJl
dHRlciB0byBhaW0gZm9yIHRoaXM/DQoNCkkgYWdyZWUsIGJ1dCBJIGFsc28gaG9uZXN0bHkgdGhp
bmsgdGhpcyBpcyBhIHZlcnkgbGFyZ2UgaGlsbCB0byBjbGltYi4NCg0KVGhpcyB3aWxsIG9ubHkg
aGFwcGVuIHdoZW4gdGhlIGhvc3QgYW5kIGd1ZXN0IGhhdmUgZnVsbCB1bmRlcnN0YW5kaW5nIG9m
IHRoaXMNCm1pdGlnYXRpb24gYW5kIHRoZSBndWVzdCByZWJvb3RzIHRvIHJlaW5pdGlhbGl6ZS4N
Cg0KSW4gYm90aCBlbnRlcnByaXNlIGFuZCBjbG91ZCBlbnZpcm9ubWVudHMsIGl0IG1heSBiZSBh
biBleHRyZW1lbHkgbG9uZyB0aW1lDQpiZWZvcmUgdGhlcmUgaXMgZnVsbCBhbGlnbm1lbnQgYmV0
d2VlbiB0aGVzZSB0d28gcG9pbnRzIGF0IGEgYnJvYWRlciBmbGVldCBsZXZlbC4gDQoNCkluIHNv
bWUgdXNlIGNhc2VzLCBzdWNoIGFzIHZpcnR1YWwgYXBwbGlhbmNlcyBvciBvbGRlciBvcGVyYXRp
bmcgc3lzdGVtcw0KdGhhdCBtYXkgKm5ldmVyKiBnZXQgdXBkYXRlZCB0byB1bmRlcnN0YW5kIEJI
SV9DVFJMIG9yIGFzIEkgcG9pbnRlZCBvdXQNCmZvciBXaW5kb3dzIFNLVXMsIE1pY3Jvc29mdCBq
dXN0IHN0cmFpZ2h0IHVwIGRpc2FibGVkIGl0IGJ5IGRlZmF1bHQsIHNvIHdl4oCZZA0KYmUgaW1w
b3NpbmcgYSBub24tdHJpdmlhbCB0YXggb24gdGhlbSBmcm9tIHRoZSBvdXRzZXQuDQoNCg0K

