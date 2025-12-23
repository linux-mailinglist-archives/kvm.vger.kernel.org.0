Return-Path: <kvm+bounces-66572-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FF60CD808F
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 05:16:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id A41DF300C299
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 04:16:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C00B2E06ED;
	Tue, 23 Dec 2025 04:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="iejlzJI8";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="Y5Yojvtc"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E598C2E03F3;
	Tue, 23 Dec 2025 04:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766463405; cv=fail; b=o4oJp6pLnK53JpUlFsgjWnF4heF9Blgl/McQvMt/1CZivm5hx9g2yu4ND3gmR0TGrRWIwIydgBwYbC4STzmwFHYn5/B1khPeYo0oKp5Qnkx4gbnufGVv98KXdxuZ+bFu2tiLQlxeVSOOLjyZ5FkrMpHY6Jg+KDGAQZhdqad9+vM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766463405; c=relaxed/simple;
	bh=I8v3DOv7BhaojEUYeD0JVO4yM71j1pmbxiBzFKbWxAI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rseAaJpw2PwE+/eBGhSXWjgAALVyHsRrX7wRRjt16wg0ZZ5cQbtAH/n5USbCYhj6emMPxFevuk3iBzqKXyeaV9z7WSoYJBF2w9JKhRkz1K4Tfvjaz7ht0K7w1D6cvaBVLv5vyYltTNy7n//jgNsC0CP1RmN+2NR7pPzEIs6cz6Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=iejlzJI8; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=Y5Yojvtc; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BN0O8dK1151164;
	Mon, 22 Dec 2025 20:16:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=I8v3DOv7BhaojEUYeD0JVO4yM71j1pmbxiBzFKbWx
	AI=; b=iejlzJI8T30rUNJng8pCG8ijTVErfYwqtuhZVf3vxBdgTeniskDnyRTYf
	bjkqP1nht6GerJmnb/kiaQNvXshmlFhTJE7+5XhgbkinILnSvJr78RbeVfoFd7UQ
	Y+kJVmP66S5kQmXfBoWu+aME8WLgpVt/uWSbcVWKEsnWjh/gJsoH6pKdszLbk/B2
	oqS4VCldB2hWF0AE9p//u0ueu/A4HzTBLK5RkACYDvHsq568II+3MjIzsVPD4rDh
	OyLvcT5kLd+l5GXAJXh1fWMoOY34frxL9mGPOON/d3IOXDBsXJlG8+0Uj2dbYuRS
	xPZyuZNmfztaWopBEmMKBdQVOzEZw==
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11020102.outbound.protection.outlook.com [40.93.198.102])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4b5tsjmtdx-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 20:16:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xOf5v8TNhJ4FtBXLaflNqFXlz8crc+n2dL3MlFdOhrB5rE7ws9AAdQ9bezwRZ6i6vj7XKwG83DDywvQ/bOsNYlCmsiaMza/EYJbdel3frlNZshpr2PqpchaMS/C59OSKP643AeMxdwXeNouUAJvHrrgWRZR6ck/K02KxKhqcqK3EEiBpU5yr/o28uASsjj8zNAgg32fYtjnASt+eWy1NqpgWme7n26cPugdBQv7p9S5x2yUKqvMePqVrAIAmn0FvvwJ+X0pqPB84zTqBOEzJC4NhqubPe1WM2dk7IM8KtoNkiuHIr3iA972nbRUjapO0GAyAzZQagsndLcuHdkURBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I8v3DOv7BhaojEUYeD0JVO4yM71j1pmbxiBzFKbWxAI=;
 b=SBcHrCYuKqQNnV0k4ySMBE1j68KAGZi/xd7wLzK0Ja90HHO2i7qEX8/pTMTOaWgponzACdhpw6KJ6jPplv2dLQAR4ITDNS/3DAmliOoY+w8immz2hq0FznH0uaFuv7+jwQVIuZ1grZWAkyi7w1dwqruqdbI7QVqIeswA5pIIE6ciLEViJ8pNkhdiJEO6sHyReeMNjpA87M7Ew+nEqBYsLNvdRAIOjQZXDAtN/OtxaDjkWlOWCI4Hk+jGb/0vyLo2+gbuZXoIj+38jMsfX7Bs1WopDHQu4YqUwYZVFX8KdHZNMz9y02sVdvZ56EaHuNFqgq4exgymnOA3T04bx6rHRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I8v3DOv7BhaojEUYeD0JVO4yM71j1pmbxiBzFKbWxAI=;
 b=Y5YojvtczVClvS/FK/FWw7Um5+gxwC0RwZuFtkEAddquxbOfWhOSYduV72sw5mHCx8UKeEzZYS5JSr4akNlOT3Nvz/shkEBJYOvTTv6HHegBEwlHzOWwgJz7iRH4v5my87BgaD2cDw3o0nvmeCcyk3P1N6MXiX27AvKVQlny790tw/dKB6GcD4+tGZTr5QtFVohW7n5w77JwlQ5Rq4PoHd82qEA46XivLYJKh0SeKw2ybnpTlqQ8BfXwsQUDqOB95PSsAgLH2ygKTU9FI/iIk0iDdXgvxf+YYIeP3wX2I4Ylmsc4UL2s1cd5nD/Q3mz2x0mf6r1ed7J2redMoiRNdA==
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 (2603:10b6:408:333::18) by SJ0PR02MB7759.namprd02.prod.outlook.com
 (2603:10b6:a03:329::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.11; Tue, 23 Dec
 2025 04:15:59 +0000
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc]) by LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc%4]) with mapi id 15.20.9434.009; Tue, 23 Dec 2025
 04:15:59 +0000
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
	<linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 16/18] KVM: nVMX: Setup Intel MBEC in nested secondary
 controls
Thread-Topic: [RFC PATCH 16/18] KVM: nVMX: Setup Intel MBEC in nested
 secondary controls
Thread-Index: AQHblFP+zKVeD6YsG0SWYuKyvTcTxLPP4hwAgWB634A=
Date: Tue, 23 Dec 2025 04:15:59 +0000
Message-ID: <9C6BF34C-AF88-4E57-8449-886CEC1B4F21@nutanix.com>
References: <20250313203702.575156-1-jon@nutanix.com>
 <20250313203702.575156-17-jon@nutanix.com> <aCJo9qZdTrWBOwhf@google.com>
In-Reply-To: <aCJo9qZdTrWBOwhf@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3864.300.41.1.7)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV0PR02MB11133:EE_|SJ0PR02MB7759:EE_
x-ms-office365-filtering-correlation-id: 7053aad5-cb92-4746-9935-08de41d9fa53
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|376014|7416014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?V0RwdjlhdCtuc1NOeGxNQ2Y3dGc4SE43UmtIK25zZFAxMUwwRjVYVFp0cmlI?=
 =?utf-8?B?cU5DYmszMjgxZXdsZTVsVVNKSVNSZlpDeGM0cms1ZG9MNVpiajNEZkU1d3Vo?=
 =?utf-8?B?TnZOMGN3TCswb3BQY1NnSzhLa09abG1ERCtvREx2YUZpZkxkYUNYb25nY1Ra?=
 =?utf-8?B?YWQyY3dBbEI1Ris5b0FLQTU1NjE3NzRuK0QzL0xybktHL1UvQjMvSHpKQ2Q4?=
 =?utf-8?B?aVd5eW1Yc3BJeHdKQjVvREtUMzcwcU9Td3lLb29SUWZPRDB2ZnUxcXRkVzRo?=
 =?utf-8?B?WXJOWjNIaG5keUd1Ym9jdUErVDdYbVJPUjhZcE04aVVvK0xGQ0pEY1c2UkU3?=
 =?utf-8?B?RWRqQS9LaGgvZk1MTDg4U1MyaWZRRStSSmt5UjhVL1Z3a0V0RzF1WWQ0Kzhr?=
 =?utf-8?B?RFdVSnpldzQxMzg4eUoxd2VUMW83TnVZb0hPN2ZNYkkxbmxwU2dvQm10WkMr?=
 =?utf-8?B?Z3VSZ0xudFlucWlYejVjKzlZOGs4U244MWdxcng3ajhjK2lYWW4xYnVUQTRt?=
 =?utf-8?B?NlBGMGNCaFpwYjZ3YXJSUUgrWSs1dUoxQkxKZmpNUXd0K1h5dU1uSEhYTXpM?=
 =?utf-8?B?YTJiN1R2cFBrYVlPQ1JuZVI1U2x0THlLV25EUytTWTBDeGZwNEhkU1dzaHEv?=
 =?utf-8?B?WEZlbnhMdjdOdHNWTnRONkxPd2FCZnZoQ00zeGYrZWYrRnREUW0wTVRQd0dX?=
 =?utf-8?B?SDkrMWdER0FOSlFEWUlHNlkyV1BMMndqN3RmWlFLZ0g0ZG01SHR2Y0lVb2Fa?=
 =?utf-8?B?ZUNJWWpvWmdYTDd2cmtDSVlXeTFDblNBb2Fqak5TTjAyQ3E2eER0WXZERyt6?=
 =?utf-8?B?OTAxeHl3amQ1MWEvQ3BkajRoT1pQNDhpK0YyTTFTZjVaRW13cGFXMFo2Ujds?=
 =?utf-8?B?di9pTlZ4TndZZEt3MEZtMi9zMzN5YUdQY0dxVGE4djBZNENoOEZ0aWdKeEE0?=
 =?utf-8?B?aDNTZ2pqclg4UC9IY1hDeXZjQ21hWUM0TnA4ank5ajQ4RDJ0T00vZ0NFKzY1?=
 =?utf-8?B?NVJvbmQ1ZGsrUytaZloyd2V1YmRyMVVkS3FsM3J4cEdDckdDcWl0YkVSUDA5?=
 =?utf-8?B?NEhvQ0F3U2s1YXVhOHRXYU11WklYais0NGduQXJ2bWJ2OXhMM091b1ZpNFpt?=
 =?utf-8?B?bUVPVUk2TE53T1FTanlTZWp2Um9FMzRiak80ZmxnVzI5WHBDL2xOQ2cxZm9T?=
 =?utf-8?B?ZmJYQUsyV1BweTlFbVliZXh1QjQ3UytvWjhQcGw2L2pYcVNzcERWZHhCaTBv?=
 =?utf-8?B?Skd1bDZJd2k3eGNGSU42WWxtZ21OTXJzdm5CcHBhb3J0eHhGUjZ0OU5KaWR2?=
 =?utf-8?B?ZnVOSExsOWJtRVdHRFp1Smd5Z3E5ekhjbWlFNHdRZGpLbTdMeEl1WW56ajdq?=
 =?utf-8?B?QlJpdGFnU0ppQjZabmFqaHF3NU1xVVdOVmVwTWFUcWdWL2xHb2NJbGNDSDRY?=
 =?utf-8?B?RmxpRk94SXhqdE1DM1U0WFhKYmptU0lmM2ZDV3RoL0JIVGpNemgxWUJva3k5?=
 =?utf-8?B?ekdPOTBUMllhY1M2cTdkUUJ5NXd4Rkt2RXY3NElGbjdaTTVJbE05MFZISW5P?=
 =?utf-8?B?blB1RFNDYUFCQ1VTOXlKNldYSkgwNVdib2w2UzdSQ1BRa0hBb04yTXQzN1VJ?=
 =?utf-8?B?R0FrN0x0ak5HWXlqR1hPeWtsVUtDeEtneHRITWZWN3k1aHd6UmVVT1pLM3BZ?=
 =?utf-8?B?a1NpVkF5eVZodEtGN25WOHdGbE9xZllnZzR3bXJ2S3BnT0k2WmI3NVlkTUg1?=
 =?utf-8?B?cmhEUmpiOXhsZzlRQWNOL1RGZVJjYm5NK2pRVXNCRWVHZlcxY29JUnhyV01X?=
 =?utf-8?B?NlNxdWpHVDcydnNiVkZieDg0ZndQd2Rpckt5ZjNUZmE3VWt3NCtHT3Rta1FG?=
 =?utf-8?B?YXhRNFIyZ0x0UGdwWTRqRHpTRWdPZDZ1STBScTN3c0F4dElnWWlwaE5ISUhS?=
 =?utf-8?B?U01qSjFvNWR2S3RDN1JzY3l1RlV2RXdHcnA3eHlXZHU4T0lDZlBzVXlTbDJa?=
 =?utf-8?B?V1RzSWNsamNjb1RPQUFIek1qSGFVWXBIQTR6TjNMMjlZbGZJNnN1SUgxdERs?=
 =?utf-8?Q?wTK+Op?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV0PR02MB11133.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(376014)(7416014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?eVd1K0t0UnljaGxKWkNuQnNwcitlMkFpZjY5YmxWeDlSaWw1TXUycTZUTk9N?=
 =?utf-8?B?VVpkd2tHc3ZsR0gwaVF3bFljTTQybXJnVkF2QU5tdTlxRnBiM1p4YWJTdjJG?=
 =?utf-8?B?WVNESUFMamxGLzU3S1dCOGJzSEtaVVdtM3IvNmNZRWt1UExFQTh5RUR2ZW1L?=
 =?utf-8?B?THEyK29GSWNBWlUxZDJ1UFdGQXFUampCL0JNVlhUejAwaUZIR1JDUGd3dHYy?=
 =?utf-8?B?OFJhWkd0L2tpcUx2Z3o4Nm5yN0hBejc4c1lHOXN2bXMrWXYrVm9LcFdEcUlp?=
 =?utf-8?B?c2YxSVkrQWVBS3hPQ0dOUnJnRnhNRjF4bVZ4QWhBMzNxeUJQdnVCMzRYU0FR?=
 =?utf-8?B?c0pFRnBRYW5ua0VVd0thNGR5SzE5T2hmSERFOXhMTHFKSkpHOGZvVGdvUHl6?=
 =?utf-8?B?QkNGYmRpSm9reHJ5OE1SWHN3TWsxVXlJajZpSGQzSHVEYk1QdlJTTTdUdkRE?=
 =?utf-8?B?a3E2YzQ4NGp4cmdpN0s1TFZhdHQyYUd6R2Q0d0hmTWMrb1NsU3EwSU1PY2NB?=
 =?utf-8?B?VENsMHAwM0JwT2tDaHh5R0tyaXV4OVVoRTBqWDNhaW9qOGxKVzNiSXJhbnBz?=
 =?utf-8?B?Q01yUmR0OHQzVm1vdFNTSW81L1ZCdWxHaHE1K1I5d1FjSlF2alFhcXEyOWt4?=
 =?utf-8?B?UGdvbTl1MGozOFhER0trVUdWS0NZeEdZWTRGbm9MNHBRY1pUYjdib0NEL2ll?=
 =?utf-8?B?SFI2MlJNa2xDZGRGYUViTlBwMXBQQmxYa0dxUytWWWNNR0FGSng4NmRVYTli?=
 =?utf-8?B?NC9vL3RlUWRMaWQ4ZXI5Tm5rSXlyUFlJc1k5VzErMjN6UGF6VlYxWEV6SC9F?=
 =?utf-8?B?MVY4NUg1RlNUUWJ2SmdEN0VkdlhOMnFUQWN1VmRDbWxraFpNbXV1aWxxZWJs?=
 =?utf-8?B?K0pTaTFBZXVYTXphS1IrVThlUm9jRDZGVUVMSHV5QmFGU0E3T29wUUNhSkpq?=
 =?utf-8?B?VTJIODlzYWpDaERFNDBOeWlXeHZtalVmKy93U2ZndHB2empQUVJIRjRaamZu?=
 =?utf-8?B?emtZV0VNaXdwUXhDY01DalI0RUFvVStCcGl3aWNxY2pmQXF2NHJSZlBKajk3?=
 =?utf-8?B?R2t6Sm9xdHp2dTltUEFja1Rxbk1Gdm5Gb2NDWUIwelVJNG5HajhTYUg5cms1?=
 =?utf-8?B?bUZNWU9PMTlTd1F4Z1AyWS9DbVh0U0Rwd04wcWUzcFZKR29WaFlSNTU3aTNy?=
 =?utf-8?B?WHBkMjh2QThzTlJheVQ1MnlCa3lMa2dQRGdBbGZuOUc0d3VKQXBWMDJmd3Mw?=
 =?utf-8?B?cE1hck5IUTFBVFlZWm5pbjhIMzRuMXFLbGJLWGlIakppTERCRG91dHJCQTNh?=
 =?utf-8?B?aGUxN1hYdG95Vy9MWXNUUnMwSGQ5V3ZFU2NSTVNhRVNTU3RwNmVlTkhOdE5F?=
 =?utf-8?B?V0FIRXNNdkdHNEdMbTNkV1EvOFVQaUN2VDhjaEZxWTJXRmhvcFpEN051QnlI?=
 =?utf-8?B?dEYvckJXWkk5N0xlVjJ2blQyYkdIT0NNSkJsZHFIeW1xVDdsUW1YSExMSHNj?=
 =?utf-8?B?Z21DbjIvd0Fud2luSVZ2VHVseWZub3E1MHV4Zk9mdmw1VG42RXJHR1BiNG1R?=
 =?utf-8?B?b3IvMzhaR1pwMnlVaE5HY240emZNQTNBS2tYWG45VVFkT0NKSndGV3NkalJY?=
 =?utf-8?B?UzNzaGdvWDBaQ2EyTGdBRnV5a2RoVXZVZmNLTzI1Rk1mY2VndlJBMXYwT1FY?=
 =?utf-8?B?Z3YwV2pleUVtdVpBdkF0Wkh0M1hRUUkyS1BMRmdhdlFSN1hCOEpBdWtIRFhO?=
 =?utf-8?B?RTdhOVBybXgwbzcxakF3VFVReVVNMVhtN2JDRjlSbDRCYnNGWU9qeHg4dmVW?=
 =?utf-8?B?Y2FRSTdQczlvMnREVzA5bzVtQ2h1ZUg3d0w0R1JVNUNISXM5bFBXMk1jZGtE?=
 =?utf-8?B?NDRLT0krS0xBaThtQjAwYWh5ZENPWXZCb3gyaG9oWFNtZjN4S2pGVXlzUGVT?=
 =?utf-8?B?Qk9VUmYydGtpd3JYbXI1WlV0b1FxVnVmNlVlS2V4b3JOVXZLNkptTTQwUlRj?=
 =?utf-8?B?OTJKdWorQkJpaFNLYk5kdEtuNy9LSFRCc081VTYrSnE3c3Z4Vk1LTFNKbVlG?=
 =?utf-8?B?WDFlY2FjTlgrZTd2ZDVmbU5NeGlHQzc1VW8xeHU5R1E0bWdteS9uMjV6MFZo?=
 =?utf-8?B?L2k2VG1LTGwrS1pzQ05kMGdMQWlONml5ajYwZzdtbmVXOVVnQWxCcGxkays0?=
 =?utf-8?B?WVZIMXlzbHY1YSt0K0c5RVNickRNM000M1Uzb0tkSlcxTjJMeWYzRDNSajhw?=
 =?utf-8?B?UmJ2T3BLMlNicUh3bWV1Q1N0NjVGVlJQN1c3YUVlcTBZcGdxRmVxZ0xPNmlV?=
 =?utf-8?B?RmRMeFhoWmVYM3ZSVnJCOEh2UEQxczBCL3I3eGVzRmEreE0yZkpHSVM0Z1BT?=
 =?utf-8?Q?EWICx2WBm6vP3bRFI1dGm0qjmf0P9CXJQ3IktoWSQ9QvW?=
x-ms-exchange-antispam-messagedata-1: OKWjiFf7urTMsTUJc1KIXyIbAM7R26IH9wM=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9940715A0A8FA54494CEBB5938DAAC56@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV0PR02MB11133.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7053aad5-cb92-4746-9935-08de41d9fa53
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Dec 2025 04:15:59.5618
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sCpdYFVJ8Pi4Eq9YyCEUlkC5dSu9SMb2jGAzYXat8V1i74qkEkNvH7ONpBIZmR4SoDSIW6skJhotBpZ9sCD2bXAcofcjDgwM4JP8dMljpxQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR02MB7759
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIzMDAzMyBTYWx0ZWRfX3+A3h/ICq/Da
 X9fQ6eGMhx+aBfdFA5lhpIk0hgTqRPiqsDqRdd7vtfiaP2LEt47yvJetE6XzegiItle0NAp0g7L
 6RNSTjOLkd/BJhvzam79/U6fcOFt68WV5wgUOCLyOyp+bfdJ1rpvkS5rhTJL0HSz2keDsxQ8rGI
 tFRU905qwiV+iugjeFlYuqzltjNOH55upj3xPMhX+RbeIPDitJ36COGnV40JbosJ5AtrAT23dih
 gnyaujoheNlUU0ZWhch4eJhVwLOTsU9KjKBdybrkR1Sc9E8epE1fSwbyNMiG51Z5ICqJQYb6zDF
 qA9JxD1gzKzfLU4Tu+cZmSf+IztLA1JfxVMgvgkz56/7vk2fF6MRjkNPlbCCpGoLdcaZLumJvJ/
 aDlmX9f34XO4uAwZ9+8sWPHX0jHgflYy5ETWIrvEn4yoiI/pKfdYWTUM04QSqQWTeWDoXG+5IBj
 xxMtvcPJqFaIq533k3Q==
X-Proofpoint-GUID: ZSlrCfjxdqjNUpnHeE1-cBbwrralmqpR
X-Proofpoint-ORIG-GUID: ZSlrCfjxdqjNUpnHeE1-cBbwrralmqpR
X-Authority-Analysis: v=2.4 cv=Xr73+FF9 c=1 sm=1 tr=0 ts=694a1781 cx=c_pps
 a=cPJgcE//urRiG05FhKkhAw==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=1XWaLZrsAAAA:8 a=64Cc0HZtAAAA:8 a=JB5INLPt3qtKfKYTUOQA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-23_01,2025-12-22_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gTWF5IDEyLCAyMDI1LCBhdCA1OjMy4oCvUE0sIFNlYW4gQ2hyaXN0b3BoZXJzb24g
PHNlYW5qY0Bnb29nbGUuY29tPiB3cm90ZToNCj4gDQo+IE9uIFRodSwgTWFyIDEzLCAyMDI1LCBK
b24gS29obGVyIHdyb3RlOg0KPj4gU2V0dXAgSW50ZWwgTW9kZSBCYXNlZCBFeGVjdXRpb24gQ29u
dHJvbCAoYml0IDIyKSBmb3IgbmVzdGVkDQo+PiBndWVzdCwgZ2F0ZWQgb24gbW9kdWxlIHBhcmFt
ZXRlciBlbmFibGVtZW50Lg0KPiANCj4gKlRoaXMqIGlzIHRoZSBlbmFibGVtZW50IHBhdGNoLiAg
QW5kIGl0J3Mgbm90IGRvaW5nICJTZXR1cCIsIGl0J3MgYWR2ZXJ0aXNpbmcNCj4gU0VDT05EQVJZ
X0VYRUNfTU9ERV9CQVNFRF9FUFRfRVhFQyB0byB1c2Vyc3BhY2UgYW5kIGFsbG93aW5nIHVzZXJz
cGFjZSB0byBleHBvc2UNCj4gYW5kIGFkdmVydGlzZSB0aGUgZmVhdHVyZSB0byB0aGUgZ3Vlc3Qu
DQoNClJpZ2h0IHlvdSBhcmUhIFRoYW5rcyBmb3IgdGhlIGZlZWRiYWNrIG9uIHRoaXMgYml0LCB0
aGlzIHdhcyBjcml0aWNhbCBhcyBJIHdhcw0KYWJsZSB0byByZWFsbHkgc2ltcGxpZnkgYSBsb3Qg
b2YgdGhlIHNlcmllcyBieSBmb2N1c2luZyBvbiB0aGlzIG9uZSBiaXQuIEnigJl2ZQ0KbWFkZSB0
aGUgY29tbWl0IGxvZyBtb3JlIHZlcmJvc2UgaW4gdjEsIGFuZCBtb3ZlZCBib3RoIHRoZSBMMiBl
bmFibGVtZW50ICh0aGlzDQpzdHVmZikgYXMgd2VsbCBhcyB0aGUgTU1VIGVuYWJsZW1lbnQgdG8g
dGhpcyBzYW1lIGNvcm5lciBvZiB0aGUgd29ybGQuIE11Y2gNCmNsZWFuZXIgb3ZlcmFsbC4NCg0K
Pj4gU2lnbmVkLW9mZi1ieTogSm9uIEtvaGxlciA8am9uQG51dGFuaXguY29tPg0KPj4gDQo+PiAt
LS0NCj4+IGFyY2gveDg2L2t2bS92bXgvbmVzdGVkLmMgfCA0ICsrKysNCj4+IDEgZmlsZSBjaGFu
Z2VkLCA0IGluc2VydGlvbnMoKykNCj4+IA0KPj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS92
bXgvbmVzdGVkLmMgYi9hcmNoL3g4Ni9rdm0vdm14L25lc3RlZC5jDQo+PiBpbmRleCA5MzFhNzM2
MWMzMGYuLmNlM2E2ZDZkZmNlNyAxMDA2NDQNCj4+IC0tLSBhL2FyY2gveDg2L2t2bS92bXgvbmVz
dGVkLmMNCj4+ICsrKyBiL2FyY2gveDg2L2t2bS92bXgvbmVzdGVkLmMNCj4+IEBAIC03MDk5LDYg
KzcwOTksMTAgQEAgc3RhdGljIHZvaWQgbmVzdGVkX3ZteF9zZXR1cF9zZWNvbmRhcnlfY3Rscyh1
MzIgZXB0X2NhcHMsDQo+PiAqLw0KPj4gaWYgKGNwdV9oYXNfdm14X3ZtZnVuYygpKQ0KPj4gbXNy
cy0+dm1mdW5jX2NvbnRyb2xzID0gVk1YX1ZNRlVOQ19FUFRQX1NXSVRDSElORzsNCj4+ICsNCj4+
ICsgaWYgKGVuYWJsZV9wdF9ndWVzdF9leGVjX2NvbnRyb2wpDQo+PiArIG1zcnMtPnNlY29uZGFy
eV9jdGxzX2hpZ2ggfD0NCj4+ICsgU0VDT05EQVJZX0VYRUNfTU9ERV9CQVNFRF9FUFRfRVhFQzsN
Cj4gDQo+IExhbmQgdGhpcyBhYm92ZSB0aGUgVk1GVU5DIHN0dWZmIHNvIHRoYXQgbW9yZSBvZiB0
aGUgc2Vjb25kYXJ5X2N0bHNfaGlnaCBjb2RlIGlzDQo+IGNsdW1wZWQgdG9nZXRoZXIuDQoNCkFj
ay9kb25lLiANCg0KPj4gfQ0KPj4gDQo+PiAvKg0KPj4gLS0gDQo+PiAyLjQzLjANCj4+IA0KPiAN
Cg0K

