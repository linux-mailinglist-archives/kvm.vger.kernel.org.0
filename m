Return-Path: <kvm+bounces-56971-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EB129B48BFD
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 13:22:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3FB1D175D17
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 11:21:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D09F22A4DB;
	Mon,  8 Sep 2025 11:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="OjpXpxAf";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="F5yCE1AE"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D8CE226861;
	Mon,  8 Sep 2025 11:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757330417; cv=fail; b=QgDmDkZb8P4qFgx+kV+AGl2x4usrfLQlWgSh29z9TNSWKnOps3KCbE8Hf6VwpuUFC5/8AdLC3S1LSZbA4gzzEc0Adcf02wpJsmbapbA84pAFUdCfaJyhlbxZiv9E0mXacWsY4VUaLqupKMGVGXXLjsFcYBwUccVZ0/BgIK9/weI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757330417; c=relaxed/simple;
	bh=b/YsXcrpPJJ1Y7IUD2uJF+QwrxBEL8Q9RGRypwNQOao=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=d0lahUe42O665/mswrsrpXmro0bz3Wp3yoRWO+3TB7uayHzAErF6CLUSWwWa7LjhpuO6T0SuhwrvSR7R2te0pJ1rhCifpaJPiKRUrweyaQmnpzVeeqBdmbVHGchfiVemSOWwqoBLoL0B8OeT+vmRiRpc93Hh5XdAceIoRpL2fKM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=OjpXpxAf; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=F5yCE1AE; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 588AF5b44030201;
	Mon, 8 Sep 2025 04:20:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=b/YsXcrpPJJ1Y7IUD2uJF+QwrxBEL8Q9RGRypwNQO
	ao=; b=OjpXpxAf2FXc2JOkq19uWqjFOLZS4UFAsewniPjwsG5oJJERwIiexUItl
	WeEEIDCNELUU053ESB1qwjTVrSA5HfxMWSnIvvPUUclOnYeXDER6Ia92y8jANXdO
	lOSAWRZkrbrFVhEF697EfKCYDLXOZ2euFUB+lzXOfDe5wBqtl/TUUdvprG/oytdF
	78lRX2DQNVSE1GKa3ZGBplsvzWMMACcz3sMTpnHJQHgAP6mLIEWbMVIz0coAtYwy
	gNTljOxpazfuKF8vwIZJ4zi60PCH07aG/Qi1ULR9d0+EvA/ejG7/qPYGZi87O8+G
	yPYqRkZbiGGeShODh+163BaE5CdNg==
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10on2133.outbound.protection.outlook.com [40.107.94.133])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 490mgv34y6-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 08 Sep 2025 04:20:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CcLQQl26x3736dXiat7vc77v91nrLKgatP15AkYO265uI9N7JYxAqLR24iqGZo3UqrDfrY54B0VhGhkN1WP9lazd+tbVlB5+Pz3JP8jy2XcshxFttlY8+9KllOxPzAXwhdS0MZWH/oGlrAjV3b2Wr5AcsVRFKg/3N4cSK0t6nrvMpbL+KOWSfVH+kOEuHzXiSEs+6p/5zXij7PkrL4rMLsLhxK8VkCgTrh6D0abPkF8MG49CuhYVcFBxV0Dpgf+OHWRCAmdA8vbMtdykGEpmO4BOMGOqz1/q0fd1RMBTBaPGq6eB1RDdhSmugj6lX9uxsqzp3+Qr9GRo5yLPNNz8ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b/YsXcrpPJJ1Y7IUD2uJF+QwrxBEL8Q9RGRypwNQOao=;
 b=AYTbaCfgkXAFtkT1l+gtLFVX+whWRc3mzG98hI/5DJSyKPT+9mcDKOZh/jxxyEEYSFI7wSwVAHi7GXl2WkCTlcQYOuqY1JsYDTes5NnqwY4wbFPDw1WkxlAKIV5hBdOW/5nUV4KB5nP6l5hoVghj8XQl+UemJqEvAjpbdHNYYHM+sUQWVez4HCH7n3kftWebFhnySlSOMFL0qBzy4XMxVRKbVb7RAwG60S2PnVuWPoXEY4MQwlVgMlpq0yz+EQwoanV+up8mT40ewg9yWB74OB8sS0GBQ14e2JE8v5gL6XgsTLKvAaVnCFBtLmsWLhB8uCKZ/eQU+BHP46tYb+B0MQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b/YsXcrpPJJ1Y7IUD2uJF+QwrxBEL8Q9RGRypwNQOao=;
 b=F5yCE1AEaeR6kFR318aNDNBCq5h02yj0sbRJMYjE7wH8/MlMxBqwaF30f5QKb4yGX7YvH+en0Ozfymvh9CE4QLsFoOUulIhI2LsCB9dbJnhhLBRvODOlZ600p7viq+vNMGNASPuMfdxH1GOPsTfdgwymzetBtddSBouXCWCmQhSAu0V3WSkvrUveL4riAKWY1wDtN+Kd3QTyB5HNcCeFZhwdSXIFCU611RdwomzA2UDsgnbqbYDDrkexZBTHoSi0aL697TJAMFA590DRXMsM10dTSHzr4NPd2WMWQc6uyybT6dKjRiw181pLi10IwcLzEMPB7MciI/7w1TX0S9bs7Q==
Received: from MN2PR02MB6367.namprd02.prod.outlook.com (2603:10b6:208:184::16)
 by DS0PR02MB10941.namprd02.prod.outlook.com (2603:10b6:8:293::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Mon, 8 Sep
 2025 11:20:01 +0000
Received: from MN2PR02MB6367.namprd02.prod.outlook.com
 ([fe80::e3f8:10bc:1a6c:7328]) by MN2PR02MB6367.namprd02.prod.outlook.com
 ([fe80::e3f8:10bc:1a6c:7328%4]) with mapi id 15.20.9094.018; Mon, 8 Sep 2025
 11:19:55 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>
CC: "seanjc@google.com" <seanjc@google.com>,
        "pbonzini@redhat.com"
	<pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Shaju Abraham
	<shaju.abraham@nutanix.com>
Subject: Re: [BUG] [KVM/VMX] Level triggered interrupts mishandled on Windows
 w/ nested virt(Credential Guard) when using split irqchip
Thread-Topic: [BUG] [KVM/VMX] Level triggered interrupts mishandled on Windows
 w/ nested virt(Credential Guard) when using split irqchip
Thread-Index: AQHcHnl3X2e3RPdxkUCpUW5qLv/tRrSJApSAgAAlboA=
Date: Mon, 8 Sep 2025 11:19:55 +0000
Message-ID: <D373804C-B758-48F9-8178-393034AF12DD@nutanix.com>
References: <7D497EF1-607D-4D37-98E7-DAF95F099342@nutanix.com>
 <87a535fh5g.fsf@redhat.com>
In-Reply-To: <87a535fh5g.fsf@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR02MB6367:EE_|DS0PR02MB10941:EE_
x-ms-office365-filtering-correlation-id: 169ee58c-e4fc-406e-4289-08ddeec9a3b2
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?c0xNN0ZQVEpMTTdqcVZ2UkdIMU44eGNydERPS2dXTVcra1ArWm9RWlVrejV0?=
 =?utf-8?B?SjROc0dYMUVMbUNQS2RJTlhDcVd2ajdEajJFMjJ1dkg5OTUwR1hTNjZoUitK?=
 =?utf-8?B?aUhBOElqeUUxMUNwaFpHSEpjN3Z4ZGpBTXkxMjNyUktsb1ZxMlBEdEhLN2R4?=
 =?utf-8?B?ZFNlbU5WUDJ5ZXU2by85S09qOHJjM1NjKzYxYy9LVDl3czZUbFExUjFoVFph?=
 =?utf-8?B?UXg2NUZsbW9mZDI4MkVyT2RvZ2VLTkhkdDZCQjRpbkhhdUpvbEVRQUJkTmt1?=
 =?utf-8?B?NVllQVRvR25CcUY4akxUY0Iwb3VWMnlGRnNlM0pQZXBjTUhQdSt3N2J2TnRG?=
 =?utf-8?B?dkpJcUpEOGF5aks4UFdTRUJpRzgydVpodWg3T21SYm9PczY0ekp3RDNCeGw0?=
 =?utf-8?B?VjR2dEkwYTBjRWNZTENsYUU2Q1QxNnN0VTNkbW00WHhYbmg5cnR2RU8yZnQv?=
 =?utf-8?B?aWk0S1pTdGNJUEgvNFdhWWdOQk1DM2YxK2Uyd1VIT2lUT1VjcjlKN2x5amF4?=
 =?utf-8?B?NHdiS1UxN0JPK1RuU0NBdlBsU2Zjcy81S01wK3NKWWRkMmtQck91bUd3TGM0?=
 =?utf-8?B?TW9xclQ0QVg2bmpuSVhxTC9scFJMSkhlc2F1Q3pFeDJEdzFOcDllWUpSQUs1?=
 =?utf-8?B?VU9NN1hZVzErSzRNMzNKOHlPTktsbjNIVnY1bDZmd043M1I2T09uYkhzT2pw?=
 =?utf-8?B?am0rVmNFSVhMYkIwMmRncDUyWCt6WlNUUkQvck4vSDg1OXZOYW1PSldQZ2wy?=
 =?utf-8?B?M3A3bXBKc0NHQTVObkZNOGxmQlN1UGhOd3RxK3NDMjU2RW1iUkc4a2h6RHZR?=
 =?utf-8?B?bmFqSFY2Z092a1FkM3FwSkRyMUZvN09ySXdaTjMxVzFpc2ZvV2RzTG51TVJF?=
 =?utf-8?B?SmxNbW9sL1lmRnpWcDVQS2dRTDcxUWJLR3J6WDl2VUFDSXBuMCtLMUJ0VG9k?=
 =?utf-8?B?UFlDK2dTQ2pmd2xzZEpxbU9hczNybE03YWJqcS9NV1QvU1lySi9FZXpSaU5o?=
 =?utf-8?B?N1hDQnUwT0x6SENEdTVHdmc0Y252V0hZS0EyNkk2VVd5dUZaaGVaZHN4eStB?=
 =?utf-8?B?b1pLU2ljZ3BiaXVJaVhEMFpyR0NaZ3VyREpwR3pJbHMrUnVPcUwycFJQM2sv?=
 =?utf-8?B?VGU4R0RVZisraE4wK2N6OEwzdnk1b3E4ajVZT211bUtTNjZPT3N1dFVKZ245?=
 =?utf-8?B?d2RzdnN1aEZDUFcwQ3NucWRjeWNrSUdQdDdLdjQ4SVB6bTh5eWliY2RNTDNJ?=
 =?utf-8?B?UmNjK2xKdXlub1RzN3kvWjd2a1M0YWJaT1NsejBJZ29mZjljMnM3MXZzOElP?=
 =?utf-8?B?UXFXY2thQTg5Q1pvdzI4dWxtZWcxUVpUUUZpUGxmWlZTT1BRdHFPQWFyYWcw?=
 =?utf-8?B?SG54VFhDa3ZhalpqQm9LdmZOekxLUG9aTWFvR0IyRVJuMk1RMkR3MmpBd05V?=
 =?utf-8?B?YUdlSUdhdlAvOUJPMzdjUU55cmNqRlR6VmRpTXlCZ3lBMmthRXBSUjdpL1FP?=
 =?utf-8?B?cXpjT2lLT3NEak81WmtVNGYvYTBnOUVtbWpJQnVxOWVzY1VGMmpSUnZkemRp?=
 =?utf-8?B?QVpEWDRjWisxcmhpc3hzQlF4M2pEWElIUUc4Z0pyS0hhNDlLUTZIWkI1WlBT?=
 =?utf-8?B?UGJWTnZzNGhWbStFODRkRE9jTWJ3Ry96RjJ6U2IyVHpOd1dxQ0ZrY2J3T1ZX?=
 =?utf-8?B?VWJBOXdna2dRZFpMM1hBMlkxYjVsY3JSMEtMRVlSblZsRVp3WmpRQSt2ZSsw?=
 =?utf-8?B?Wm5MYWVCT2gyTS9PeStOOXJ0L1JRdDVoM29DdFdjYU16Y25sd01DVzQ0dFVm?=
 =?utf-8?B?QnFRRytjZ2J3NEtxaFdic2EzUnd0bjQ5TTFhdm1DTVRMMlZoWTIxVmdJQ1lT?=
 =?utf-8?B?WElEUUF3ZGlTbC9Hdzk0S0tNbnpHSUlFNEtaMGNrcG8vOTJtY2krb3JNdnRM?=
 =?utf-8?B?Z0tYb01Oek5vU2NwUC80d25wS0xkdm5qNmo1MkFFK3VObkdNSkZiUTloTUY2?=
 =?utf-8?B?RFBmMzhsYWZBPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR02MB6367.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?cUJDZSswUzAxYzhnSk1Pdk5kcUhrVVp1Sm4zWW5RZnMzSTdjbEFYdmtGLzdK?=
 =?utf-8?B?NFFpZ1M0Z216ck0zTzJETUdRTGZKUHlQRFdXUFptdnBySDd2d2J5S1NoWjhn?=
 =?utf-8?B?MnI3c0FETDhBaGswd3NzckQ0eEY2L2p4WGpqd3VBYlVBWGh4SUcvVGRNMFA0?=
 =?utf-8?B?b2l4cEZKcEVNQ2hoaHFyMnQvdWwxbW9qaDBPSVpOd0U0ZzNnL05RWnZMSzMz?=
 =?utf-8?B?elBsOEk2NFl1ZEc2MUlxdHhSUkFSMDJvUEpFb3EvaGhXdEdmdzdJTWFqbHVo?=
 =?utf-8?B?SkJDQ1lFcWFGSEdLWTZzRjk1Y0FncmMwNHh3cmRUakkwU2EwaHl3eFlZRFNi?=
 =?utf-8?B?bmxZc1ZzNlNRM0RuWm1qUFo5NWxyUXZOUzM5Q1lwZ1hDd2tTL3A3a1Y4UGNr?=
 =?utf-8?B?L0hJTWRNd0ZaT3VRK2ZpeHhTTFMrcmFPK0diN2RCa3FsMzZzem5nNFlyekY5?=
 =?utf-8?B?ZjNoNUJxeFFwYmlZdUJicnV1amh0Q2V5Wm5yK2xuMFBzNzZ4c2dxK2Zva1F2?=
 =?utf-8?B?anZIKzN5QzdVUGt1V1hnaWdrelJ6TXRweHFhQXJLT1UyU2xFQmZoakdPZnVo?=
 =?utf-8?B?d3psbDNSSnVITEJMRUdjbEZsVVR4aWFZTEtuMGpzR2VwZit0aWFNMFBuMmZY?=
 =?utf-8?B?bm96UUdsY0dmV0lMYkEyWkd1NmJsSWJRdWpyUlpmakpsdVgxVlRKUE9NYXN1?=
 =?utf-8?B?OXBnUU83em02TFVYZkg4R2RhQzAxV0NPYVZQR2VhS01ENFdBcTM5WFdFTFVH?=
 =?utf-8?B?Y3BwMVBiWEdiTHFKcVdZZ21FMEJxVGRuSCs5TWNBVGxPS3hSQUtJY2dVcnNH?=
 =?utf-8?B?WW84ZU9GM1d3cmp5MWhnY2dTV1JrZUpHVFVXNTQvYXlBSzI1aElZSFplZXk1?=
 =?utf-8?B?ZnRCTytGUnl2c2doMnVIRmNKR3F3Yms0NUo4c3JJSUZmSUJPS0xwYTlaRS8z?=
 =?utf-8?B?RzVjeHVoalVzOHBUeXpIdUhkb1NMWjRHMWVhU3JyczdBRmF3T2U4MHZyV05M?=
 =?utf-8?B?ZHBqZDJGS1ZteHRXdWhWL01yamJ6QjRMRTBYSkxEUXhDSzgyL3VSU1E4Qm5S?=
 =?utf-8?B?QU8yNFhjNUVuak5udWZCd011UzZ1cWJUOE5uaE1iZWhrM3pTY0RJd0tialJr?=
 =?utf-8?B?bUZjM1pCc0RORUM1c2lNZkQ3SXF3WGRWYVVOZEkvV2VxUXdYV0grZnNyUGVM?=
 =?utf-8?B?QjlFMTZrZVdIQ1Vtd3NlZWY5dkNGRkxBd1NrcDdmZ2xUU2tnV01Renh1S09K?=
 =?utf-8?B?TnVobEJ3VnpobVNCTjUxdENrK0oxYmxzVUdaRkd0QjFpaTV1MFZOcUUwRU5P?=
 =?utf-8?B?UzNwSmNIenRQMGIwNVRvQjdOYW1uaHJHVmswY2ZwdGpQeCtiVlF1RTlxb01h?=
 =?utf-8?B?MHhVNGZlQjBQajlJQkpKcFRkbnYyUi80ZnRPRC9oTVdiNXFJeFAzVytQRGRo?=
 =?utf-8?B?di8xS0U4S3QxTUJQYmRJTXkxNVNHeUlPakJJWmhHSmJxWXNRUmlTK1JobWxQ?=
 =?utf-8?B?YVdnamdnK1Jzc1JUSG9tOC9RbkptTE9WdE5PVXh0WDF6QjF4YkhwMmpFOEZR?=
 =?utf-8?B?Q1Y3Z3JXMGFMT3VpdHRaMXEyRmswaStFSEtBajBiLzVzNWNaaEt1bS9mMlB5?=
 =?utf-8?B?d0RINGhIaDZoU3V2L0h6OEo5ZmlKQVJvWGFJemZlSTRPK2RRTS9nTDlwdkkw?=
 =?utf-8?B?cDA0Z3l2d0ZQdUtVWXZJNTQ3Z29vOTQwTVU1RTF4OFgxdTNRQmdSb0liZFVR?=
 =?utf-8?B?Uk44WEd2ZlErWVlyK1JSUmVOVnhvV1RieEdQdmdXL2g4eUtJek1GbnZaWXRz?=
 =?utf-8?B?MVovcFdWVUZEVWcydjZRcjJ1Q3JwbHJpVVk5cjdPRGgrc0ZaUGdtV3I5Z1Zu?=
 =?utf-8?B?ZUZNMFNtWkxSekxHbDM2eHdnWEk5LzVpQ3l5L3RPbS9RSXU1aFVkcFVKcEY5?=
 =?utf-8?B?QjNCYms3VkVHeTN2Rk9XMVZ4WmtkeXJEUzlIbm9VZEwrTWU4ZmVVc3RIaHBv?=
 =?utf-8?B?T0lXZHovN1VjZ2REZ05SU0piaU1vTVlPeEZMZ3FaM0hJelhlVFc1eUQ0cEhO?=
 =?utf-8?B?YnBra2NTVWlkSFNzLzdiVE1DWVlIOUJxRUsyTjlaWXplSWlEVUVXYUZsaGRZ?=
 =?utf-8?B?dzZGQWRaNjRrZ2o1Z29obUZVYUFEWW82RmtBYXI4dU5aTCtKaWp0dldmd0FW?=
 =?utf-8?B?K3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <91E745A1D3694D4ABF1CD9420CCF2FB6@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR02MB6367.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 169ee58c-e4fc-406e-4289-08ddeec9a3b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Sep 2025 11:19:55.8218
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Irh89FwIet4AZQdnHyZ5kS5hdxZ27SO/j2sZqRSNEeRlv9o/l4y+741R/LnKlfT68OUNyvmnMhg1SzPOyHmbEGMumyfu01FWdQnN7VXTSM0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR02MB10941
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDExMyBTYWx0ZWRfX7p4RzcTkgHsY
 lSFS++/Jgz+v3imF/StmkxdpDRm4QhcXMa3EO4HofyC36szoYR5NzxA/Lrp0xJIAvmAIaT6NAgJ
 Y+FmBO6TsEbXr2LQO0jJPJBLN/zcyPtx4cpw3rJltUTKMn5tNF66Ze16FtRNVLiP8HJuopDIdOO
 lWNrSx5DymleYvBP03VqPbMehHN9o3e366xk6BojxSwkWjIQiL0c+M+HfmqFWTIOz53cHSpCpVE
 4JOvHbRl0Mvxv8qKgfqBszP88ygWG7di8cTcNYnmrb/g1kfHCgZB3OE+c1BnnDlLOX8YtP43ZyE
 VFJH6V6Gj7AnRyKxhEi7BwBmvpQwFfMDdhEbQHzyncriI6mJD0kSp5zM1M+D6g=
X-Proofpoint-GUID: DYnEMyN3nEGL9LgEtsBEN-D_Ekl3r8Va
X-Authority-Analysis: v=2.4 cv=TIVFS0la c=1 sm=1 tr=0 ts=68bebbe4 cx=c_pps
 a=5wlz3ThtJF9ytvJAc8lWzg==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=0kUYKlekyDsA:10 a=20KFwNOVAAAA:8 a=_u8brMD2H3qQ4bOhfo0A:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: DYnEMyN3nEGL9LgEtsBEN-D_Ekl3r8Va
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-08_04,2025-09-08_01,2025-03-28_01
X-Proofpoint-Spam-Reason: safe

VGhhbmtzIHlvdSBmb3IgdGhlIGNvbW1lbnRzIFZpdGFseSENCg0KPiBPbiA4IFNlcCAyMDI1LCBh
dCAyOjM14oCvUE0sIFZpdGFseSBLdXpuZXRzb3YgPHZrdXpuZXRzQHJlZGhhdC5jb20+IHdyb3Rl
Og0KPiANCj4gSXMgdGhlcmUgYSBzcGVjaWZpYyByZWFzb24gdG8gbm90IGVuYWJsZSBhbnkgSHlw
ZXItViBlbmxpZ2h0ZW5tZW50cyBmb3INCj4geW91ciBndWVzdD8gRm9yIG5lc3RlZCBjYXNlcywg
ZmVhdHVyZXMgbGlrZSBFbmlnaHRlbmRlZCBWTUNTDQo+ICgnaHYtZXZtY3MnKSwgJ2h2LXZhcGlj
JywgJ2h2LWFwaWN2JywgLi4uIGNhbiBjaGFuZ2UgV2luZG93cydzIGJlaGF2aW9yDQo+IGEgbG90
LiBJJ2QgZXZlbiBzdWdnZXN0IHlvdSBzdGFydCB3aXRoICdodi1wYXNzdGhyb3VnaCcgdG8gc2Vl
IGlmIHRoZQ0KPiBzbG93bmVzcyBnb2VzIGF3YXkgYW5kIGlmIHllcywgdGhlbiB0cnkgdG8gZmlu
ZCB0aGUgcmVxdWlyZWQgc2V0IG9mDQo+IG9wdGlvbnMgeW91IGNhbiB1c2UgaW4geW91ciBzZXR1
cC4NCg0KDQpBY3R1YWxseSBpbiBwcm9kdWN0aW9uIHdlIHVzZSBhbiBleHRlbnNpdmUgc2V0IG9m
IGNwdSBmZWF0dXJlcyBleHBvc2VkIHRvIHRoZSBndWVzdCwgc3RpbGwgdGhlIGlzc3VlIHBlcnNp
c3RzLCANCldpdGggdGhlIGZvbGxvd2luZyBodi0qIG9wdGlvbnMgYWxzbyB0aGUgaXNzdWUgaXMg
cHJlc2VudDoNCiAgICAgICBoeXBlcnZpc29yPW9uLGh2LXRpbWU9b24saHYtcmVsYXhlZD1vbixo
di12YXBpYz1vbixodi1zcGlubG9ja3M9MHgyMDAwLGh2LXZwaW5kZXg9b24saHYtcnVudGltZT1v
bixodi1zeW5pYz1vbiwgDQogICAgICAgaHYtc3RpbWVyPW9uLGh2LXRsYmZsdXNoPW9uLGh2LWlw
aT1vbixodi1ldm1jcz1vbg0KDQo+IA0KPiBPbiA4IFNlcCAyMDI1LCBhdCAyOjM14oCvUE0sIFZp
dGFseSBLdXpuZXRzb3YgPHZrdXpuZXRzQHJlZGhhdC5jb20+IHdyb3RlOg0KPiANCj4gU2luZ2xl
IENQVSBXaW5kb3dzIGd1ZXN0cyBhcmUgYWx3YXlzIHZlcnkgc2xvdywgZG91Ymx5IHNvIHdoZW4g
cnVubmluZyBuZXN0ZWQuDQoNClRoZSBidWcgd2FzIHJlcHJvZHVjaWJsZSBldmVuIHdpdGggbW9y
ZSBjcHVzIGxpa2UgKDQsOCksIHdlIHVzZSAxIHRvIHJlZHVjZSBub2lzZSBpbiBjYXB0dXJlZCBs
b2dzLg0KDQpJIHNob3VsZCBhbHNvIG1lbnRpb24gYnkgc2xvdyBib290IHdlIG1lYW4gZXh0cmVt
ZWx5IHNsb3cgKD4zaCkuDQoNClRoYW5rcywNCktodXNoaXQ=

