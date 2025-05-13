Return-Path: <kvm+bounces-46279-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E7024AB4914
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 04:02:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4332A7B3044
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 02:01:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7DA2189F57;
	Tue, 13 May 2025 02:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="VH53O5L+";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="pSLgMIOl"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F9811548C;
	Tue, 13 May 2025 02:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747101738; cv=fail; b=uJu86EAKy7UBucKag7OsybNvBQEX6YIG01ypSdArrOUGgnzDd1koP7paCRTYIfAA/81U1gPOMEa9PNvHsWqwX/uKz35VwQ0DMbnIKBJlFiLDDHnHeU4kA/KPfeo0a6KUPyIT1mvUySa8OD6S1KDn4mQJyo9K/uO9b4oqpXbhIV8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747101738; c=relaxed/simple;
	bh=1SzhF2sURFY/mmezbuuJBfS8Bn5CqhM3sKaT6QfzGLw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=aS5bfT0AkFZaqPeCmmHphFlZ/SzCQwc5cxZtYp8jwCFOUDjKmuyhaB0lXDg/9ECQ272Y1RsVzYxXoVEnNHOSv0OTgsQMY+vnEGYW6SGLMe024Rt98fQdxfQZE2QYNAZFatmxBRxYmaCgxoLNpLDJ/t1UBVZQ+OQtgjpsEX210vI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=VH53O5L+; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=pSLgMIOl; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54CKeq5l017589;
	Mon, 12 May 2025 19:01:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=1SzhF2sURFY/mmezbuuJBfS8Bn5CqhM3sKaT6QfzG
	Lw=; b=VH53O5L+iw9ibST6G31D90dcAV3N2oDiV4QWkN/MrnUQjx15ygIHtltYI
	/jq/peZH6X9AC03q6VUeZhYBwtAJc/b6FRcKy8t+WnOudmFkMiP9r+IEJitkjz8T
	tZRpcxrWjCtPBTHIwGdDxt5EBGiiMShbuw/vbTgnuH1MD34NVHibVpKjgyMC5zMT
	zxyneQtoOAHgV9NIjD7iwCm5naPRmxuosPx4e34c6Qp/oVPbIf/hsR5cPsGuyScb
	/mYnE0cFIdIRDV19xw1Dudsw50fXAZxGx9H2HkVY0FEO7iUK7IFYVdkq4rhXxxmR
	EdgYZKHK6JMascB0BvBozGRlj4ANg==
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazlp17010000.outbound.protection.outlook.com [40.93.20.0])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 46j6bymejm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 12 May 2025 19:01:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MCMaScxrY5JrKha4hS6FvRiCLnUwDuwA0a8NrteuvDQM1cUvZMk+S3KjYgqGyAELldnlCFwj0NBIhts6dyB0dk7AgTNhw+8gTAPcz/0WXMONjkFpHZ126N9T86M7YRmk/oL6+TQM25vmCkOH0aTIMVnVhqPIRyBBUajTJcyd7uRTM7daL97WZmKi1WZ0Y9PnV6Xsl8RL9T5qDJBj2KVaTpHJVabECvREXM8bPUQ4/knGx+OfbNVlczaxbCUCIbJ0STqkeiDemVWpBR84Qg7SCRauXm6Fdo8wqrFnnHS9x/LpDZfOyaxDBgD1lQrVJIgcUpqamwLgV+dW8ZwfLrz+yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1SzhF2sURFY/mmezbuuJBfS8Bn5CqhM3sKaT6QfzGLw=;
 b=lB4OcNgEl65ojMIcltm6AaNv4JyWTLqS/mWGUiUwsnwdfvJMoO2ly0iliCDSHXsOKFz4ZgHHyTxH7JN4qsZNiu52/WDDmTLfUhqSSDCM0RHNTYvlXk+tmu4OwJsOGbKQnvw9hlugHG51Ra7Mau38ddma5CF6t/XsAeXwQ3EhKrZDC/p7RyF8/6KdJMAHlUkhfLAoHw5pEBeY+CUWe0KEWyDwNRlIh6RIgLu21i9VcPDiPJZGG0UaBOaN5oOgiEoMOhf3SiMAfv//liVpKIUB+i43sfwpIHi2NA/H4Ka+QzJcbY1rxGNOKIbaVaKa7QVwgxGRv8gvYKuhrtwlrkLloQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1SzhF2sURFY/mmezbuuJBfS8Bn5CqhM3sKaT6QfzGLw=;
 b=pSLgMIOlmVrkPMjmEhrU2FGlNUryVvjBEFa8Pbcuxe7lAfSmqYGBIH5XU+CPC5dE98mmbJnzSLHHsu9GyeYED+oV5dmR9n40Lp6LiZ0Ou82pK3yzAoV+wtlEpyuWIxO/BEJUHoVk5dGiuCVTHrJANivVzXSjhp5CXN/PxxgVrT3aUB3RCShtfuAtMQ6udF7jSeZVb0/Fw6QIcYB2bT4Ol6Jb1jtnZ1+VGt269I3JspIZkpD2zWgEkeSULc/UMhJ8d9mINV2ppp08kqKgoAq4s0Vfj//AezxhajiJWlcPiH8OkF3oOOdcCMQShOLQMcjtVBtXbW1ZcKq5NF1XTUamGQ==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by IA0PR02MB9662.namprd02.prod.outlook.com
 (2603:10b6:208:48c::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.26; Tue, 13 May
 2025 02:01:47 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%5]) with mapi id 15.20.8722.027; Tue, 13 May 2025
 02:01:46 +0000
From: Jon Kohler <jon@nutanix.com>
To: Sean Christopherson <seanjc@google.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de"
	<tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de"
	<bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [RFC PATCH 17/18] KVM: VMX: Allow MBEC with EVMCS
Thread-Topic: [RFC PATCH 17/18] KVM: VMX: Allow MBEC with EVMCS
Thread-Index: AQHblFQAwzN6irY5bE6x7d5A98UrcLPP4sUAgABKfQA=
Date: Tue, 13 May 2025 02:01:46 +0000
Message-ID: <1F4D7E0A-B4DB-4E9B-B97D-FF4DF6A7902C@nutanix.com>
References: <20250313203702.575156-1-jon@nutanix.com>
 <20250313203702.575156-18-jon@nutanix.com> <aCJphDlQLyWri9kR@google.com>
In-Reply-To: <aCJphDlQLyWri9kR@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.400.131.1.6)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV8PR02MB10287:EE_|IA0PR02MB9662:EE_
x-ms-office365-filtering-correlation-id: d42967f8-b8bb-4b0d-e5ac-08dd91c21df0
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|366016|7416014|10070799003|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?b1krbzQvYW9UZk02SGZ1OHJITnBLenRFNmN5SDJ5UmFRY2VoOUxqTElXQVdP?=
 =?utf-8?B?TWJWTUdQcVVWNUtYZitIZmZqVVg4aDAva3V2QUtzbjJ0N3Mrb1JxbGJCYTZz?=
 =?utf-8?B?eVN5WTR3S25OOHZpaENGQjVaNHNLbFlGekQwOURtSzhRZXI3K1JBUm9OLzB1?=
 =?utf-8?B?a1U2SUduTis1RWo3eldUM3lKaHVQd2YwVXNLNnVNMktGQmZ5OGxzcXdRM09i?=
 =?utf-8?B?Sjl6L3BnMFNhOHVQcXhsWEd1WUJiUEQ3ckRRQS95c2NJakhtL20yS3ZYL1A1?=
 =?utf-8?B?dFdZalptV3M3b2lVNXR4eVh5a28xY1RsUUNTT21iUDVIT01kazU1SnpaQk8v?=
 =?utf-8?B?dU5CelFSNFZQcUdjUXl0VXBiU1dlOSs4NTNVM2ttWHpKNGRsa2UzNkxwYURV?=
 =?utf-8?B?L3VIem5RSGE0Mk1GRkkrV29LaW5iRkxnNk1heVBOZW13REIySEpETDdXQkdF?=
 =?utf-8?B?ckIwRFpXZEhrMllFb0piMHAzeVFsQllQeEhGejBlMmhtOHZqalJ2TStrRzNX?=
 =?utf-8?B?b1l6c3IwZVExcUppbE5rSjYwRkdUeEJNRFFraVdhcDBrL3VZOWxFQXdwWVF0?=
 =?utf-8?B?UnRpRGNBbHB4UmFpY0x0cXRmb1VUc2wwek8yUFVNMmZuajgwY0V0ZVpIdEph?=
 =?utf-8?B?bVE3Z3ViMDBOK0RObFFFMUwvRVRaL1c0ZmVZK2ZLVUc4Wmh0cjh5SjNINkZq?=
 =?utf-8?B?UHhFN3FnNTdrcXo3alcrSDJRaEQraHFLWE1HaWFia2pmbkhrTm1rOXpITXQ5?=
 =?utf-8?B?M0ZVcklpZGFqM0NCZ0pSS2Z2K2FVVjNsSVpHMi9ET1NWaW1ERGFyK2xqZmZw?=
 =?utf-8?B?UFFYWXNoTGpwMCsxTGxsaHRTOWk2aDBDYTZyeGZSKys1SG0ySTVKRDNPMTBB?=
 =?utf-8?B?eGpuWER6UXZ5aWNmMjZBMXptL1VHUzFLV1Z2MUdsZEgxSHBMK0lQSnJrK3B3?=
 =?utf-8?B?TzViTyt1Y3F0Nkkybk5hU2RyYnhUWFVCejJtRFFhNThaajJlOWJNR1owT2w2?=
 =?utf-8?B?c3I3UHg1dGdMaXVsbldTcEFOa0dLSWVTU1hhaHVOdnJveWFBaXVpSUQybUJ2?=
 =?utf-8?B?WFVxTVFxUVFBNWFNM1hualVyQlVRNEJrSG1HM2V2MFVNYVhjclpKcDJiUFVr?=
 =?utf-8?B?WTBiajNRN3MwczREWkw0M1RjSlN3OGRMSjVWYnI0NFZGc3llSmQwWUhUOEF1?=
 =?utf-8?B?ZnU2T0VDdW83UTlQZnY5Zng4VFRHU1dSRm5tdk5nT0txS3RhbjhSUld2UXNV?=
 =?utf-8?B?UHNwNTljZE1DLzhiU1EwRzRoU0Nmd3R5aXB2blFFUFZRbG5qcWNWWmR6bzFo?=
 =?utf-8?B?VDlLK25FR09OU1NlTmxwcVRrb3ZkcmloK05Oei9MRkhJdUUyWUtOOXdRZFhs?=
 =?utf-8?B?bmFxZHlRYTgwMzQrR0Mwa3JIaFhwazNwYlZnUXN6TENRdmp4M2RYdG1GdzYx?=
 =?utf-8?B?UkZXSVZIeCtQZ1AwNFViTWFHd3VZSGxFdnU1TkdHM3pLRWp1VmgwUDdaQUhX?=
 =?utf-8?B?QlBMUlppa2NTUWlSMExDYkZ3MnZJcW00SWp6c2J0NW8wSmVSRGttZC84VTdJ?=
 =?utf-8?B?aWZIcDV1UWQ1YlFjOG5qSHNwa2gveHFJSUFvSUhINHZPUyt4YmlhaEdrK1dj?=
 =?utf-8?B?cDdNUnZhbk1mSFk1bVhrbUdub3M0NU5LNi9qRGthNExxUW54K3VTRVJid3hn?=
 =?utf-8?B?Tll4Y1RnYkk0TXhxOTRNbngzZmpiTkFIM3Q4Rkh6Z2x6dUp5T1hZcG5TQVli?=
 =?utf-8?B?bk9vSklmVE5wMjVqK1IyQkdtaWhZQnN5K3NuUEtpcHZpa1IzaXRqRDFPdjky?=
 =?utf-8?B?M3JhdkV2V0VzUWlYVVQ5aU9sMkVhNVp5SGtqMnZPZHVoWGx6SmFpbXRlV1VC?=
 =?utf-8?B?aGNVZkl0ZmV5WExqYnlYd0FMWWpZQ1puZzNXYk5SZVRCS1RzY0hwVHNqVXNH?=
 =?utf-8?B?MzlDNXpNS3pOUTdPK3VsZTJOOVc0MThrSjcyUUc0ZkhvMGhub0tKdW55UHRi?=
 =?utf-8?B?MEFhWW9Udnh3PT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(10070799003)(1800799024)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?dXZrcjBjaDYwUzRYdlV1aUluYlhIQnEyVGc3eFlWYTlSYWNoRHorM3NEYnBn?=
 =?utf-8?B?WWhXWlpldDJ2RlVvM3M5dmlKZVVzTklVcU1pQlV6WXZha0Q0STdsZ0NLRHFY?=
 =?utf-8?B?S3l5ZGJSRW10ejVjNm1PTU9QbnI0bUp0SzlCVlVzd2M5dVRVR0tjbzZOc1ht?=
 =?utf-8?B?bEx2TkxPa0xOVWIvclpVai8vRVZBRW11TXdsd2MrazZDVVVtOXlPeEZ5YXVa?=
 =?utf-8?B?Q045dEt4ZHJrL241WHlpcXZkR3RCVU5rclQyK29PN3c1cm9rWG5sRGNVbjZT?=
 =?utf-8?B?K01kL1FiQUUxNnhjLzkzRmZvNmZqcEJBdHl5T2xPWmh1bVBrWnFvNEN0clla?=
 =?utf-8?B?M2tvRGZleWRlOXJ5TkhYQ2NCUE5pdlhCa25naUptWnVKbGlsUVArRzArQXM5?=
 =?utf-8?B?ZWhKb1RVTjluQnEyYktvSFZ1Y0g5b0JWTCtFWExITWJLOTdnN2M5S3NOT292?=
 =?utf-8?B?cnMyQUJheWRlMmpNWmJ2R2Fyd0x3L01VbU5Hbkl6UFptNFF0YUpTU1YxcWRK?=
 =?utf-8?B?R3VQUGprd3hEU2ZOK0Z4V1VXQnBuRVFBOGk5UmdQaEpobE1GVlA3U29xR3Nu?=
 =?utf-8?B?YVdDRkY2ZmlyYmJ1dWVTeExwT1FPbjdkM001cjB4VXBuK0MwZUhKVzRmQ0FW?=
 =?utf-8?B?YUI1R1FTZ09vTUU3UUwwSkRVR3UrU0xLMDRvRGc0NUxVcnBGUXYydWlNSnhX?=
 =?utf-8?B?dlBrQ2FLeG45Qks3WFRURHd0RGluYnYzSlNWdmZyYWdSdHR6Uk9IWlcwb3pQ?=
 =?utf-8?B?b0t4QjcvdkF4anJuSjRScUJPUis5WXNKZmNsOEN3TC9NbmNja2tVa2J1eEoz?=
 =?utf-8?B?ZGdCUkhtTTJNVit3M1JBd2kvUUM3MnNRaGNUWTVwMnFsMFBSSEJvQ1RjL1d6?=
 =?utf-8?B?c1BCOXdzeUxGbG5NRXhuY3VacDd0eUFoSDF2YURKbTVMZzRGbWZ3dzdMRWNx?=
 =?utf-8?B?VXRmZUxrTUYyb0xobWxvaEdJYzV4dlhYaXZOWHBLODZOdDVadURvY0Y4QmJq?=
 =?utf-8?B?OCtwUG9CL1dXWVB4ZFNBOWE0V0JaK3l0bExHUEJDTG1sdzRraWIxbFllT3Vq?=
 =?utf-8?B?dUNRVGVmQ3h4TEZpVWhGUm1RbWI2R09HV3ZVNktMV1M3c0dXWDlRUVBJZEYx?=
 =?utf-8?B?ZWhocHZCZnRSQ1ZKc1Z6SXYwWGREc2pQRENyWmpVSzZYdzM1bVlMU29OcUl2?=
 =?utf-8?B?WTVObk1vYloxcWlQOVdBS1N3RytBK21NdDNKdkxmNTVSb1VBNFJBMU5kR0Vt?=
 =?utf-8?B?R2tGeldJUDI2d3o2V0cydWZXcHd3U1A4K0FmaWQxamJ0ckZwWk1NQzJ1YTg5?=
 =?utf-8?B?ejFEOU0yeHlVRnNqSmNOd3VjUW5jbEZlRmdTK25nUUJPWXpzOEdJendQOS91?=
 =?utf-8?B?ZEN6QTVyUVJGYTZnV3VMWVY3VmZTR3BRWGNkZkxxaGRwcTlmTlBQZTFUV2R1?=
 =?utf-8?B?N24wRmJiRHRZNjBxR2tDYWdXYnc1RkxuSFJXZ3lYWmRVbW0xTFpGNUF3VnI2?=
 =?utf-8?B?V1gxUitSdFRhT01VcDZyUE92REorcGNtalY2V0Y4T0p1d0lvSHpLbk1CYWRQ?=
 =?utf-8?B?OFJXSkEwdVU3TURtY0N6NFlxVVFoTlJQT1QvRkVIdG5xYXpQcmN3c0lvcEJW?=
 =?utf-8?B?VTZWcFZ6cXFUVGU0aWdmYjIxbWpzQjU1WmhSd20reitOcWdCVHloQkE1am1w?=
 =?utf-8?B?VXR0bmhlMWNVdHlNbHNzK2ZhR2s5OUY5WkUySlllQ01PaU1ubkkvcGZKeGxi?=
 =?utf-8?B?QnRiemtudklvcURVb3BQM3M4QXVGb1VDcHpiYTJueHlkbGxVNVdLdEpoRExB?=
 =?utf-8?B?ZnZ6Mm11VTJYaW9yMlRGQ24xQzdzOERnZmZwOCtWditoN3ZmM2JvSHJqeENk?=
 =?utf-8?B?MldXWndOaGFqRHB3MUNPTUpLU0tPK1VlczRkZXNOMk50MGxDVkdLb01UOS9Y?=
 =?utf-8?B?TisySXRVbFBJK2ZBM3dOUFF3ZG5oUEhsdWpldkNzTUhEeFJZSXhTU25pM2hJ?=
 =?utf-8?B?RjZjVGE4SC9meFZrTE8yWk85bWhydzlHbTRmcXRCUzhwcmlHUUJoYnVyQmlH?=
 =?utf-8?B?dTROUU5pbWFuTmQwV3pRM01mQVZ3elF1VEVSVks4TXg2UERiWWt3NVV0cDNm?=
 =?utf-8?B?OThEWDROUlB2TUR1b3U4aVU1TmlDREZ4TkYybTR4NStWR3NKZ1lkY3dUWmQr?=
 =?utf-8?B?OWRaUFVTTndJMlVoc0N0UW9ZZUNlVGllVkdNOG1nODV6dVUyWW85NG9hVkpU?=
 =?utf-8?B?dTJtZmw2M0xMZnJpWVZrQWxVM2xnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EC0C1F418A7A7A4ABC373E1E87913D86@namprd02.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: d42967f8-b8bb-4b0d-e5ac-08dd91c21df0
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2025 02:01:46.8146
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FS09noro5tTyHtasS5Okt+E+JhvGjMxoR606yhr3C0NzAelB3TUGydmJqdOIURZe6NYzCoqTNN5NTPJIpIHBH+IsE62UiQHFZcxcgNWGlBg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR02MB9662
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTEzMDAxNiBTYWx0ZWRfX/hpfi5LxURS0 b1mVrR0mVmBrKyh9+7OZItRriBUGVTbMwSpvTRXbF4rb7FcE/KjZ63LlkkoN62wptQvF6myZP+y TtUYwqKumsfG3LJaotgigNPMZlX2uT13repqkHXWII7TCfE5gx+m04KJODkbuf3zra2DUF8Gxgy
 NQn0KZuH9OFsVDwUdfE0hzfSS/IOF2ufDEabnGhO2tmjBJsmvlmS2mf5VPZvBFJOOEmtMDh9atP aZ+u/q3bfUrQmVgvs98nXiBwH9uQUecK47PUaPWjKsSrEw2sNMweRV0HBohK5cXZja53UHS6Eei LWB2HKBS5Z/Nfk145HJabpyB0ttOm9RJK7KyzNiUhc7OpSTfI6s+wmkSoXaPHoLoD6d9sb1XP+R
 iuNd+wb6/9CRd52voknjsdbTXuC4v528s+VhduXOebHLT88N7unuamHAmly+GmiE5RV9MZ+i
X-Proofpoint-GUID: tsy28xJ-dQoEQFBM4tw9glqCJaFGG3ut
X-Authority-Analysis: v=2.4 cv=ToXmhCXh c=1 sm=1 tr=0 ts=6822a80e cx=c_pps a=xM7ec0glCC7UZJxDhKPaNg==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=dt9VzEwgFbYA:10 a=0kUYKlekyDsA:10 a=1XWaLZrsAAAA:8 a=64Cc0HZtAAAA:8 a=y_w6Ijrfw27lA8GqHb4A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: tsy28xJ-dQoEQFBM4tw9glqCJaFGG3ut
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-12_07,2025-05-09_01,2025-02-21_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gTWF5IDEyLCAyMDI1LCBhdCA1OjM14oCvUE0sIFNlYW4gQ2hyaXN0b3BoZXJzb24g
PHNlYW5qY0Bnb29nbGUuY29tPiB3cm90ZToNCj4gDQo+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPiAgQ0FVVElP
TjogRXh0ZXJuYWwgRW1haWwNCj4gDQo+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPiANCj4gT24gVGh1LCBNYXIg
MTMsIDIwMjUsIEpvbiBLb2hsZXIgd3JvdGU6DQo+PiBFeHRlbmQgRVZNQ1MxX1NVUFBPUlRFRF8y
TkRFWEVDIHRvIHVuZGVyc3RhbmQgTUJFQyBlbmFibGVtZW50LA0KPj4gb3RoZXJ3aXNlIHByZXNl
bnRpbmcgYm90aCBFVk1DUyBhbmQgTUJFQyBhdCB0aGUgc2FtZSB0aW1lIHdpbGwgZGlzYWJsZQ0K
Pj4gTUJFQyBwcmVzZW50YXRpb24gaW50byB0aGUgZ3Vlc3QuDQo+IA0KPiBBIGJyaWVmIHJ1bmRv
d24gb24gYW55IHJlbGV2YW50IGhpc3Rvcnkgb2YgZVZNQ1Mgc3VwcG9ydCBmb3IgTUJFQyB3b3Vs
ZCBiZQ0KPiBhcHByZWNpYXRlZCwgaWYgdGhlcmUgaXMgYW55Lg0KDQpUaGVyZSBpc27igJl0IGFu
eSwgYnV0IHRoZSBicm9hZGVyIHRoZW1lIG9mIOKAnG1ha2UgdGhlIGNvbW1pdC9zaG9ydCBsb2cg
YmV0dGVy4oCdIHdpbGwNCnRpZHkgdGhpcyB1cCwgYXMgSSBzcGVudCBxdWl0ZSBhIGxvdCBvZiB0
aW1lIG9uIHRoaXMgZVZNQ1MgYXJlYSB0cnlpbmcgdG8gd3JhcCBteQ0KaGVhZCBhcm91bmQgdGhh
dCwgSeKAmWxsIGNvZGlmeSB0aGF0IGtub3dsZWRnZSBpbiB0aGUgY29tbWl0IGxvZw0KDQo+IA0K
Pj4gU2lnbmVkLW9mZi1ieTogSm9uIEtvaGxlciA8am9uQG51dGFuaXguY29tPg0KPj4gDQo+PiAt
LS0NCj4+IGFyY2gveDg2L2t2bS92bXgvaHlwZXJ2LmMgICAgICAgfCA1ICsrKystDQo+PiBhcmNo
L3g4Ni9rdm0vdm14L2h5cGVydl9ldm1jcy5oIHwgMSArDQo+PiAyIGZpbGVzIGNoYW5nZWQsIDUg
aW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPj4gDQo+PiBkaWZmIC0tZ2l0IGEvYXJjaC94
ODYva3ZtL3ZteC9oeXBlcnYuYyBiL2FyY2gveDg2L2t2bS92bXgvaHlwZXJ2LmMNCj4+IGluZGV4
IGZhYjZhMWFkOThkYy4uOTQxYTI5YzllNjY3IDEwMDY0NA0KPj4gLS0tIGEvYXJjaC94ODYva3Zt
L3ZteC9oeXBlcnYuYw0KPj4gKysrIGIvYXJjaC94ODYva3ZtL3ZteC9oeXBlcnYuYw0KPj4gQEAg
LTEzOCw3ICsxMzgsMTAgQEAgdm9pZCBuZXN0ZWRfZXZtY3NfZmlsdGVyX2NvbnRyb2xfbXNyKHN0
cnVjdCBrdm1fdmNwdSAqdmNwdSwgdTMyIG1zcl9pbmRleCwgdTY0ICoNCj4+IGN0bF9oaWdoICY9
IGV2bWNzX2dldF9zdXBwb3J0ZWRfY3RscyhFVk1DU19FWEVDX0NUUkwpOw0KPj4gYnJlYWs7DQo+
PiBjYXNlIE1TUl9JQTMyX1ZNWF9QUk9DQkFTRURfQ1RMUzI6DQo+PiAtIGN0bF9oaWdoICY9IGV2
bWNzX2dldF9zdXBwb3J0ZWRfY3RscyhFVk1DU18yTkRFWEVDKTsNCj4+ICsgc3VwcG9ydGVkX2N0
cmxzID0gZXZtY3NfZ2V0X3N1cHBvcnRlZF9jdGxzKEVWTUNTXzJOREVYRUMpOw0KPj4gKyBpZiAo
IXZjcHUtPmFyY2gucHRfZ3Vlc3RfZXhlY19jb250cm9sKQ0KPj4gKyBzdXBwb3J0ZWRfY3RybHMg
Jj0gflNFQ09OREFSWV9FWEVDX01PREVfQkFTRURfRVBUX0VYRUM7DQo+IA0KPiBObyBpZGVhIHdo
YXQgeW91J3JlIHRyeWluZyB0byBkbywgYnV0IEkgZG9uJ3Qgc2VlIGhvdyB0aGlzIGlzIG5lY2Vz
c2FyeSBpbiBhbnkNCj4gY2FwYWNpdHkuDQoNClRoZSBlVk1DUyBjb2RlIGhhcyB0aGlzIGxvZ2lj
IHRvIGJlIGFibGUgdG8g4oCccGVlbCBiYWNr4oCdIGNoYW5nZXMgYmFzZWQNCm9uIHJ1bnRpbWUg
bGV2ZWwgZW5hYmxlbWVudC4gSSB0aGluayB3aXRoIHRoZSBicm9hZGVyIGNoYW5nZXMgdG8gdGhl
IHNlcmllcw0Kc3VnZ2VzdGVkIChtb3ZpbmcgY29udHJvbCBvdXQgb2YgdmNwdSBzdHJ1Y3R1cmUg
aGVyZSksIHRoZW4gdGhpcyBnb2VzIGF3YXkuDQoNCknigJlsbCBzZWVrIHRvIHNpbXBsaWZ5IHRo
aXMuDQoNCj4gDQo+PiArIGN0bF9oaWdoICY9IHN1cHBvcnRlZF9jdHJsczsNCj4+IGJyZWFrOw0K
Pj4gY2FzZSBNU1JfSUEzMl9WTVhfVFJVRV9QSU5CQVNFRF9DVExTOg0KPj4gY2FzZSBNU1JfSUEz
Ml9WTVhfUElOQkFTRURfQ1RMUzoNCj4+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vdm14L2h5
cGVydl9ldm1jcy5oIGIvYXJjaC94ODYva3ZtL3ZteC9oeXBlcnZfZXZtY3MuaA0KPj4gaW5kZXgg
YTU0M2ZjY2ZjNTc0Li45MzA0MjlmMzc2ZjkgMTAwNjQ0DQo+PiAtLS0gYS9hcmNoL3g4Ni9rdm0v
dm14L2h5cGVydl9ldm1jcy5oDQo+PiArKysgYi9hcmNoL3g4Ni9rdm0vdm14L2h5cGVydl9ldm1j
cy5oDQo+PiBAQCAtODcsNiArODcsNyBAQA0KPj4gU0VDT05EQVJZX0VYRUNfUFRfQ09OQ0VBTF9W
TVggfCBcDQo+PiBTRUNPTkRBUllfRVhFQ19CVVNfTE9DS19ERVRFQ1RJT04gfCBcDQo+PiBTRUNP
TkRBUllfRVhFQ19OT1RJRllfVk1fRVhJVElORyB8IFwNCj4+ICsgU0VDT05EQVJZX0VYRUNfTU9E
RV9CQVNFRF9FUFRfRVhFQyB8IFwNCj4+IFNFQ09OREFSWV9FWEVDX0VOQ0xTX0VYSVRJTkcpDQo+
PiANCj4+ICNkZWZpbmUgRVZNQ1MxX1NVUFBPUlRFRF8zUkRFWEVDICgwVUxMKQ0KPj4gLS0gDQo+
PiAyLjQzLjANCj4+IA0KDQo=

