Return-Path: <kvm+bounces-22090-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 00AB1939B86
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 09:12:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1EDB81C21CC3
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2024 07:12:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0845513D8B3;
	Tue, 23 Jul 2024 07:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b="SoCtu8yk"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE8913B5A6
	for <kvm@vger.kernel.org>; Tue, 23 Jul 2024 07:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.148.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721718671; cv=fail; b=jMoAPUq30oldK/dea0gVjacNbtdxov7hY8ygzp9kGdRkztYUc0YyeTGAo1ZTh6/8wpYID8vYe8HvvpgTXL3KZZIEpXLqYSPrnVl5ILe/r7LL9jYPfVlOgFgd5Fd6k5pKx/KlMQIOBTEgUS6c4MUtGTjUWV6feEwU8ZFxkRpclkQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721718671; c=relaxed/simple;
	bh=rLzOTiuMW/yIVKSXO9kJZaTa3DFhWAG86DYWxqtOtF4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ThgRgirQxgFQulnce/rL3sjGYbn1NbtFS8UCjjUG5mnFOQdCHwTKvVrvwMyTD1rlhZu0D9qctSDFTGD1MAUGnTeHQDwXl1WpomtwLnoNjJp/q7WPfWQBQSU7Pph6hPX7YMo2moyfAOvfFnDmO17rZHSIF3GnS1BbDtSBbCzBCL8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com; spf=pass smtp.mailfrom=marvell.com; dkim=pass (1024-bit key) header.d=marvell.com header.i=@marvell.com header.b=SoCtu8yk; arc=fail smtp.client-ip=67.231.148.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=marvell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=marvell.com
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46N2NaDW003511;
	Tue, 23 Jul 2024 00:10:55 -0700
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
	by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 40hkrwmeuj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Jul 2024 00:10:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fpgZa1RjkvRwNIcmxVIJjws43pRfyZ4mhZsDjJ6MndaftBxUy/Dnr8qNijaP8HjTigX43fc8Pg3kZAH3QFM5CANXu95ht3PC7RoKXEX6UaQV/s3KyJwrGooz3YuuKQxqLBoR3pW1UxtwqxVHlbvRw93vXPHs5bh+ZkkC44kz5e57PzqLi4JgaK7c0aXYPlyWOzH7y/yWiDYdvSb1CAe390jW7Gm0V6ZHhLvJ7/Jp2zgG3+MgxTIRWlOAudFg2P6ZhPdNckc2IZHQadqaw9N9DKErypz8nyuHqxmyyYf8hrKjWu+7R3FwCFuh7ADo0wXzLsx/owM/O4rsmhzt8xzOwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rLzOTiuMW/yIVKSXO9kJZaTa3DFhWAG86DYWxqtOtF4=;
 b=fDKc+xuQ5HVwEhnAxQkDK3gZuJDG9Gn5GTEllcUSuTQzv9QiheQ9P+tNydXKpJbZ1gzWtac34Wsm6D1gWkmaBFDDUQn2PSzABN/GpdHEwPliff95MxUGWratorYyximnADCpI1/WQR8Z6Rn6mk2q9R6WUD5SI8V2lur1NQq50dQEssYJPF2E60CeYgXY2FYCsFpf51mKTshCN4LH5ihlwq3lGyn5ez/eUVPykD8wNvL/hLBG7ullRmxIAJaEIrW+v9ETzRUJFEraWfwkCewYrH+JO8RMzj3RjTuAP5INuXspJMVCCGiLepPgY+oKWW8MF8hGXCzDXWbgsbYyF3gboA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rLzOTiuMW/yIVKSXO9kJZaTa3DFhWAG86DYWxqtOtF4=;
 b=SoCtu8ykMLnVGo6lz5bKO//R11F89On0dXXlB3jaZldZElvIeIrK4U1AYCcyj3/JVuD+q+eFxCAAPAXZrIgfRinejKhDkoqJP9ZyBRU6lDjOmc4cB6cUIM0SukWzQ0GfOgSN3vcqTRQGQkndesNMzaKnZcfwTuDTTP7jF6FVaCo=
Received: from DS0PR18MB5368.namprd18.prod.outlook.com (2603:10b6:8:12f::17)
 by CO6PR18MB3873.namprd18.prod.outlook.com (2603:10b6:5:350::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.17; Tue, 23 Jul
 2024 07:10:52 +0000
Received: from DS0PR18MB5368.namprd18.prod.outlook.com
 ([fe80::ad53:bef2:cc17:13ac]) by DS0PR18MB5368.namprd18.prod.outlook.com
 ([fe80::ad53:bef2:cc17:13ac%5]) with mapi id 15.20.7762.030; Tue, 23 Jul 2024
 07:10:52 +0000
From: Srujana Challa <schalla@marvell.com>
To: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>
CC: "virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Vamsi Krishna Attunuru
	<vattunuru@marvell.com>,
        Shijith Thotton <sthotton@marvell.com>,
        Nithin Kumar
 Dabilpuram <ndabilpuram@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>, "joro@8bytes.org" <joro@8bytes.org>,
        "will@kernel.org" <will@kernel.org>
Subject: RE: [EXTERNAL] Re: [PATCH] vdpa: Add support for no-IOMMU mode
Thread-Topic: [EXTERNAL] Re: [PATCH] vdpa: Add support for no-IOMMU mode
Thread-Index: AQHasnq4Ve/zJa91a0mQb+nM4LHR9bH6+HqAgANtqRCABESwAIAAB/wAgAGBD8A=
Date: Tue, 23 Jul 2024 07:10:52 +0000
Message-ID:
 <DS0PR18MB5368298DAEA53CF7F9710B46A0A92@DS0PR18MB5368.namprd18.prod.outlook.com>
References: <20240530101823.1210161-1-schalla@marvell.com>
 <20240717054547-mutt-send-email-mst@kernel.org>
 <DS0PR18MB536893E8C3A628A95BF8DDA0A0AD2@DS0PR18MB5368.namprd18.prod.outlook.com>
 <CACGkMEtQ3SWBpS-00BBCJxoUK5AQRB=FhKGEqigh81GTbRf61A@mail.gmail.com>
 <20240722034957-mutt-send-email-mst@kernel.org>
In-Reply-To: <20240722034957-mutt-send-email-mst@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR18MB5368:EE_|CO6PR18MB3873:EE_
x-ms-office365-filtering-correlation-id: 9384450a-4f58-435b-bfbf-08dcaae696b1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?QTQxbWQrOWxvUm5JWklBMVA4cGVZckFYclZISUsraCtWRjE3Z05tRTBnZDZI?=
 =?utf-8?B?ZXpndzBmRC9qSUJiSUZtRUoveXFRZlJydGpnZ2xOUzlMQnNjbEt3NzErWjlB?=
 =?utf-8?B?SDBRdS93QW90dHRBaGV2NktPTXA2U0FBSmFGWlRBRzIydTJFLzBsZXlsQnVi?=
 =?utf-8?B?eHhoQVJ1OVpURXl1ZFVHYzNWU1FXM2xqcEdoUTJ6U25PczdMRGgzZ0pUanhz?=
 =?utf-8?B?ajAyeVFZMjEwTVpIS0hjSU5idC9aUVl3d0ZVNFlKRFdMUUl0bjBxM2xjSnlE?=
 =?utf-8?B?VHZ0T1FpSmhob3dwNUJiWDhDL3RwUnhYeFZSU3FicW1pL2gzK0poSVY5U3Qw?=
 =?utf-8?B?d0M4TlRLRGpwQjlUcWtPNXRDa0ZENkdUcFQ4K1pLaU1JWU1RdW1rNTYzSmFs?=
 =?utf-8?B?NndTbXRMN1BlQzB3cEFzSjZZM3d1ek5HU2VzWi9GRmZXTVZtdGpTZlBQOTZt?=
 =?utf-8?B?am1zVWZSVy9Da0R1SkRiZWhnNGRDbTR2Y2xtS0szb2RtZC90V0UwME5HSTlI?=
 =?utf-8?B?a2lGWlc0UC9pNWtmaWJ4emxHWTFzYnBOeitoQU8ramg0RjlXeUlDTmZ3ZmZt?=
 =?utf-8?B?RFB3eS9vN2dmTFA1SFlyeWFBSVo0dVpBVHczNU05cnEwSGRCaVMzQlJNRFVw?=
 =?utf-8?B?WUZGeGozU3lGRmxhU0VTOVQvUzl0QmF3bFV0RFhYMGFhcDJnNm02M2hRT0dE?=
 =?utf-8?B?emZNRGdWVzhsbzRxN2dsZ1VuTjBsWGVtZFVPM1MwTVJVR0ZBZDhVcG0zbEll?=
 =?utf-8?B?TDJvN2RLZmNBUlhHM1VMZHo1aXl3TDFLNStuNXFxaktzSVB4b2ZpaXdFaWVZ?=
 =?utf-8?B?aGpUMWowVVZYSGlBUW5IMk9vYVVRR0FvbUNTSmxXMnk2OGlGZXIzU1RlemF4?=
 =?utf-8?B?dDRHZ0hXdWgvcXk0cm5SUk1MNmhjSFhMS2F6bzVFRXVKeFNEeVFZUStlWS9k?=
 =?utf-8?B?Zm9rUno1ekUzYWNmaEdMMjNxNSs2UFpydjFJVGZGejZ6TUFLbXNYWGxzV3Rx?=
 =?utf-8?B?Zm5yNmdwcmdhd2dlTllHUnRnUlFaTmtsdGlid3NCWTVLa2oreVI2M0pDRDEx?=
 =?utf-8?B?cmRpNHNKNVd0OXlxc0l0SHZqV3NpNFo4Slc4aFV1bzdvUVlMQXFwUm8rZnpr?=
 =?utf-8?B?TDZYd2pZOVRRUENIcWVZaEcxT0Jqa0l4dEdqbTJUTEJWZWp6d2d3dnBrV090?=
 =?utf-8?B?bXZGSXBrYllOa1JaT1U0ZThvdmY2S2d5dk5rdDVEcE44ZHo2TXJxU3RrVzEx?=
 =?utf-8?B?djZud2RLUlU2YjJvamIrMzlGRnJMc2xSM2RqZW9TS0t5NWwzWlZBcmsrR0V4?=
 =?utf-8?B?WkNkMWoyclc3R3NuWmNjMEhFdXY1eEJyQWtaWHFnZGgreWFjVDhMaGVWNXVF?=
 =?utf-8?B?cjJjSVQzQjQ2TzhQM2N5T0hpRFl6U0drdU00Znd1aXBFOXhRL2xrakRJVEtG?=
 =?utf-8?B?WFNZcUpLaVZsUjQxeTZTT0lFbENvTDJFM3gydkpMYzgxQ2hNV2svMHBNa3Ar?=
 =?utf-8?B?V2FOalJwUzNKdzB6d1RibExXMWtWMDVwckQ1ZGxXWnFlZnZZOGVWdTF2K0M2?=
 =?utf-8?B?V3ROc3AxTkhJMFI4U09jc2huY2YxSHZQWWFSczdNaDRialYzSnNsYk1Iclgz?=
 =?utf-8?B?bkRWTDFGVW5xU3BJbUxIbm1uNmhtR1VBSG5jSkMzQmQzeHVIN1JwZU9FVnNM?=
 =?utf-8?B?OFdnak9nbnVCd21NbTBkeGxiRjhmdzFLbzhkWjM3anBZTllsc3dnc2xHeHBy?=
 =?utf-8?B?Y0dscnJLWmh6RXBUVUs1QThFalJaNTVkYnRoc21GRWRVNXNWS1QrYnBlYVhR?=
 =?utf-8?B?S2ZZSzZncTlydkdKeEZIMjVyaGhqMVVWYXh3azVJVlVhQlVXUzFHUE00dTVi?=
 =?utf-8?B?aHQvcmh0NUgxT1JMa0VvZG91QlRScU9ybExNOTBvRlFTanc9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR18MB5368.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?YUtabEZodHZ3WFBPWDVnOWZaUGY3OGtMcGcvWmRSSXA5d1JHSnQ0K1pIaW5X?=
 =?utf-8?B?bG1USXJhS1hKelIxOXNhckRrdnlkT3ZWdHFEUEdPeWFOaVR4c0tGdTNUS09x?=
 =?utf-8?B?Vk1EUWR0dHF5S0lqQ0FVZXV4RDZjS1NGQUpYd25QeE1WS0svekE5VnVYbVI3?=
 =?utf-8?B?STNMUXZBNUVRZHdBMy81NTZoenF5RG0rdnJyY1EyUzV2dGZVSnRDQUNXNlBK?=
 =?utf-8?B?Nk1HWHJvVGhMeXpuVGVyWFRlZ3NLQzdPVWdnMlVJRE8xUEJxakdDRHh4akow?=
 =?utf-8?B?eVFQTEN0Yk91dUxwRVBRaVRFdUVmSk5zTkZmcnFtZkpSNmxrczNFb3k1Tldk?=
 =?utf-8?B?aERMeHVDemFGYmVEM1RQdUVpbldqRkdMR3A2cWdLOWxidStocjl6bGdnNkJI?=
 =?utf-8?B?Z0x3c282VHlZMUhEZEZONHYwQnU4Y3NoR0xRNzV6TWQ1UkNQZ0JsbVYxVlp6?=
 =?utf-8?B?eDNFalRMQ2JIRXpEN0Z3WUVJa1cvZ0tYOE50WjQrZExSbGFWb2JHcU1CcWZS?=
 =?utf-8?B?RzFYdVd6V2F5N242SEhjc2N2SE1BMlBmcFRmQ1JmbTRoK3pIZEZnb3lUbW1Q?=
 =?utf-8?B?Rk1rdVp4cTNFMEZvWWNIVnhGc0poS3E4WWhRV0NVeURkRWlhMTlYK2FSMWNG?=
 =?utf-8?B?OW1oZ255WnluUFNrK3cxMExWZUpNY2ZBK3JvdERuMHBKVHMySjRTTHdwRko3?=
 =?utf-8?B?Z3AyZzNKeGVjenNhaG9mK1duQkc3enZlT1M5VHNibkMvNWJFRUVqNWsycDFG?=
 =?utf-8?B?bHRwbXZ5RFc3R2JiMFZFNWxMNzhjSlBYZEZlSGxFOUgvRkRIK092QTRpZ3Fw?=
 =?utf-8?B?T29LTGM2c1BFM2pNS3hxVURsMkp1VGRQWW9jbC94R2lRQ1hQZ0xLR2dOZGNU?=
 =?utf-8?B?SDJrOXJUSEZZS1lkNE1jQUhrR1dYNTZNRHkxdUcvOElFS3E3NU9jbXM3TkNL?=
 =?utf-8?B?a3plTDR6bXhDOHB5b2lIUFdlbWVrRnZQeHlkK3lJc096RkNEOHB1WVUwcFc5?=
 =?utf-8?B?ZGFOKzlaT1A0RnIxdVJMS3hiSkMvZnFlZFJ4V1pLK2lnSHB6Q05TWTNmWWNV?=
 =?utf-8?B?L1phYmcyVXVBdW8zRVE2Z2pEMEF0NGdJOVNQRzVDaDFFYnU1ckorV21keHR4?=
 =?utf-8?B?eFFCN0VleFhTdDgycUdSN2dHZzFUalF0eTZKL2J1WDhHZ21KcGZrUE56QmdQ?=
 =?utf-8?B?RWtHNXFKWFlLU1VIaUo5czZZTzRQYU9ZZmJhTUdwSzYxbzJvQXdMRnNSM1pD?=
 =?utf-8?B?UThjSEZ6WFN4T1doWHIzYlB2TGFHb2ZpS3B3SzdJVTRvaGVvcTEyVVRJVTMr?=
 =?utf-8?B?SHhuYTZNYUx1YldtZHNOeFQ0blpZSklvUXJtTmxKeEdlNXo3NXd4NDd2bTNa?=
 =?utf-8?B?QVI3c3NSVHd6N2Z3U0dUek1mMThKYW5EZmFHaUgyZEdjUDhhNnJWbUdJN2Fa?=
 =?utf-8?B?VCtkKzVSY1plcXdvdlJaRm9WZzBuVFJzbmxNYkYzc2pxYnNqZjBKamxLK3lp?=
 =?utf-8?B?WlBrZTF2VzIzVWhTUTJ1Q29oNmk2QlJLaDVnTmJkNFhQdGs2dHdGbDVFc3Vp?=
 =?utf-8?B?MnduRWhBRDF0eUVCQjVHSnM1M2czaG1CcWJqT0ZwM29ud2FPdDY4ZWxSVVp5?=
 =?utf-8?B?b01jdktWWThHZ1BPYWtzaDZ2OWZwZVlIcDF2ajNLcEMrL0NoVUF1bDRrbFVK?=
 =?utf-8?B?Q3UxOHVFMzNQOHoxbjNTcUxpZUFMNzdiQXk4MmF1MGpjVFFydDhnWEhKZXRp?=
 =?utf-8?B?SVJQUVREZkIwbnRPYlFOUklpQ1plTEJRVnpvZlZEd1JaczZDTGxWbHZGUGhl?=
 =?utf-8?B?c1BTRGNKRFRGTW1mRkQzZldKYVhlTXJkc2l1aHQ2WGYzeVp4N05waExEMk5y?=
 =?utf-8?B?OUxzWmRzM3MvRjdBR0JxTUxyd3VIN0pVd2F3Lzl2ekpyU0RYLzA0UzlYc01J?=
 =?utf-8?B?TnBwNU9iR1FnbWNLQnpQZUV2N2dtKzR1SWlnbTFRdTV5OE5UTUZaUGt3OEJP?=
 =?utf-8?B?NDQrbG5vRzRaVnNiZzdURVRWQjdTZ0NJbFh6djZkWGpoZUY1c1lTcDl3Q1Zx?=
 =?utf-8?B?dWxhWDFUcnJpUWZkSVVYTHdJNmtZcVlyTUZ2TXNDbUhaZnpTaGdPYUlBZEhn?=
 =?utf-8?Q?/ESA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR18MB5368.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9384450a-4f58-435b-bfbf-08dcaae696b1
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2024 07:10:52.6985
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kdtVlynI0Rid40pLOaA0vfpTUSKEqEUF4YJlSDAEm1w3gM+NCfI/pwerTCcBAFJx1gHKEu+L2SoTT5Ia4ENqsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR18MB3873
X-Proofpoint-ORIG-GUID: bAmX59X6kM0QrnraGIUyKnltbIzjsVFv
X-Proofpoint-GUID: bAmX59X6kM0QrnraGIUyKnltbIzjsVFv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-22_18,2024-07-23_01,2024-05-17_01

PiBPbiBNb24sIEp1bCAyMiwgMjAyNCBhdCAwMzoyMjoyMlBNICswODAwLCBKYXNvbiBXYW5nIHdy
b3RlOg0KPiA+IE9uIEZyaSwgSnVsIDE5LCAyMDI0IGF0IDExOjQw4oCvUE0gU3J1amFuYSBDaGFs
bGEgPHNjaGFsbGFAbWFydmVsbC5jb20+DQo+IHdyb3RlOg0KPiA+ID4NCj4gPiA+ID4gT24gVGh1
LCBNYXkgMzAsIDIwMjQgYXQgMDM6NDg6MjNQTSArMDUzMCwgU3J1amFuYSBDaGFsbGEgd3JvdGU6
DQo+ID4gPiA+ID4gVGhpcyBjb21taXQgaW50cm9kdWNlcyBzdXBwb3J0IGZvciBhbiBVTlNBRkUs
IG5vLUlPTU1VIG1vZGUgaW4NCj4gPiA+ID4gPiB0aGUgdmhvc3QtdmRwYSBkcml2ZXIuIFdoZW4g
ZW5hYmxlZCwgdGhpcyBtb2RlIHByb3ZpZGVzIG5vDQo+ID4gPiA+ID4gZGV2aWNlIGlzb2xhdGlv
biwgbm8gRE1BIHRyYW5zbGF0aW9uLCBubyBob3N0IGtlcm5lbCBwcm90ZWN0aW9uLA0KPiA+ID4g
PiA+IGFuZCBjYW5ub3QgYmUgdXNlZCBmb3IgZGV2aWNlIGFzc2lnbm1lbnQgdG8gdmlydHVhbCBt
YWNoaW5lcy4gSXQNCj4gPiA+ID4gPiByZXF1aXJlcyBSQVdJTyBwZXJtaXNzaW9ucyBhbmQgd2ls
bCB0YWludCB0aGUga2VybmVsLg0KPiA+ID4gPiA+IFRoaXMgbW9kZSByZXF1aXJlcyBlbmFibGlu
ZyB0aGUNCj4gPiA+ID4gImVuYWJsZV92aG9zdF92ZHBhX3Vuc2FmZV9ub2lvbW11X21vZGUiDQo+
ID4gPiA+ID4gb3B0aW9uIG9uIHRoZSB2aG9zdC12ZHBhIGRyaXZlci4gVGhpcyBtb2RlIHdvdWxk
IGJlIHVzZWZ1bCB0bw0KPiA+ID4gPiA+IGdldCBiZXR0ZXIgcGVyZm9ybWFuY2Ugb24gc3BlY2lm
aWNlIGxvdyBlbmQgbWFjaGluZXMgYW5kIGNhbiBiZQ0KPiA+ID4gPiA+IGxldmVyYWdlZCBieSBl
bWJlZGRlZCBwbGF0Zm9ybXMgd2hlcmUgYXBwbGljYXRpb25zIHJ1biBpbiBjb250cm9sbGVkDQo+
IGVudmlyb25tZW50Lg0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gU2lnbmVkLW9mZi1ieTogU3J1amFu
YSBDaGFsbGEgPHNjaGFsbGFAbWFydmVsbC5jb20+DQo+ID4gPiA+DQo+ID4gPiA+IFRob3VnaHQg
aGFyZCBhYm91dCB0aGF0Lg0KPiA+ID4gPiBJIHRoaW5rIGdpdmVuIHZmaW8gc3VwcG9ydHMgdGhp
cywgd2UgY2FuIGRvIHRoYXQgdG9vLCBhbmQgdGhlIGV4dGVuc2lvbiBpcw0KPiBzbWFsbC4NCj4g
PiA+ID4NCj4gPiA+ID4gSG93ZXZlciwgaXQgbG9va3MgbGlrZSBzZXR0aW5nIHRoaXMgcGFyYW1l
dGVyIHdpbGwgYXV0b21hdGljYWxseQ0KPiA+ID4gPiBjaGFuZ2UgdGhlIGJlaGF2aW91ciBmb3Ig
ZXhpc3RpbmcgdXNlcnNwYWNlIHdoZW4NCj4gSU9NTVVfRE9NQUlOX0lERU5USVRZIGlzIHNldC4N
Ck91ciBpbml0aWFsIHRob3VnaHQgd2FzIHRvIHN1cHBvcnQgb25seSBmb3Igbm8taW9tbXUgY2Fz
ZSwgaW4gd2hpY2ggZG9tYWluIGl0c2VsZg0Kd29uJ3QgYmUgZXhpc3QuICAgU28sIHdlIGNhbiBt
b2RpZnkgdGhlIGNvZGUgYXMgYmVsb3cgdG8gY2hlY2sgZm9yIG9ubHkgcHJlc2VuY2Ugb2YgZG9t
YWluLg0KSSB0aGluaywgIG9ubHkgaGFuZGxpbmcgb2Ygbm8taW9tbXUgY2FzZSB3b3VsZG4ndCBl
ZmZlY3QgdGhlIGV4aXN0aW5nIHVzZXJzcGFjZS4NCisgICBpZiAoKCFkb21haW4pICYmIHZob3N0
X3ZkcGFfbm9pb21tdSAmJiBjYXBhYmxlKENBUF9TWVNfUkFXSU8pKSB7DQoNCj4gPiA+ID4NCj4g
PiA+ID4gSSBzdWdnZXN0IGEgbmV3IGRvbWFpbiB0eXBlIGZvciB1c2UganVzdCBmb3IgdGhpcyBw
dXJwb3NlLg0KPiA+DQo+ID4gSSdtIG5vdCBzdXJlIEkgZ2V0IHRoaXMsIHdlIHdhbnQgdG8gYnlw
YXNzIElPTU1VLCBzbyBpdCBkb2Vzbid0IGV2ZW4NCj4gPiBoYXZlIGEgZG9tYW4uDQo+IA0KPiB5
ZXMsIGEgZmFrZSBvbmUuIG9yIGNvbWUgdXAgd2l0aCBzb21lIG90aGVyIGZsYWcgdGhhdCB1c2Vy
c3BhY2Ugd2lsbCBzZXQuDQo+IA0KPiA+ID4gVGhpcyB3YXkgaWYgaG9zdCBoYXMNCj4gPiA+ID4g
YW4gaW9tbXUsIHRoZW4gdGhlIHNhbWUga2VybmVsIGNhbiBydW4gYm90aCBWTXMgd2l0aCBpc29s
YXRpb24gYW5kDQo+ID4gPiA+IHVuc2FmZSBlbWJlZGRlZCBhcHBzIHdpdGhvdXQuDQo+ID4gPiBD
b3VsZCB5b3UgcHJvdmlkZSBmdXJ0aGVyIGRldGFpbHMgb24gdGhpcyBjb25jZXB0PyBXaGF0IGNy
aXRlcmlhDQo+ID4gPiB3b3VsZCBkZXRlcm1pbmUgdGhlIGNvbmZpZ3VyYXRpb24gb2YgdGhlIG5l
dyBkb21haW4gdHlwZT8gV291bGQgdGhpcw0KPiA+ID4gcmVxdWlyZSBhIGJvb3QgcGFyYW1ldGVy
IHNpbWlsYXIgdG8gSU9NTVVfRE9NQUlOX0lERU5USVRZLCBzdWNoIGFzDQo+IGlvbW11LnBhc3N0
aHJvdWdoPTEgb3IgaW9tbXUucHQ/DQo+ID4NCj4gPiBUaGFua3MNCj4gPg0KPiA+ID4gPg0KPiA+
ID4gPiA+IC0tLQ0KPiA+ID4gPiA+ICBkcml2ZXJzL3Zob3N0L3ZkcGEuYyB8IDIzICsrKysrKysr
KysrKysrKysrKysrKysrDQo+ID4gPiA+ID4gIDEgZmlsZSBjaGFuZ2VkLCAyMyBpbnNlcnRpb25z
KCspDQo+ID4gPiA+ID4NCj4gPiA+ID4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy92aG9zdC92ZHBh
LmMgYi9kcml2ZXJzL3Zob3N0L3ZkcGEuYyBpbmRleA0KPiA+ID4gPiA+IGJjNGE1MWU0NjM4Yi4u
ZDA3MWMzMDEyNWFhIDEwMDY0NA0KPiA+ID4gPiA+IC0tLSBhL2RyaXZlcnMvdmhvc3QvdmRwYS5j
DQo+ID4gPiA+ID4gKysrIGIvZHJpdmVycy92aG9zdC92ZHBhLmMNCj4gPiA+ID4gPiBAQCAtMzYs
NiArMzYsMTEgQEAgZW51bSB7DQo+ID4gPiA+ID4NCj4gPiA+ID4gPiAgI2RlZmluZSBWSE9TVF9W
RFBBX0lPVExCX0JVQ0tFVFMgMTYNCj4gPiA+ID4gPg0KPiA+ID4gPiA+ICtib29sIHZob3N0X3Zk
cGFfbm9pb21tdTsNCj4gPiA+ID4gPiArbW9kdWxlX3BhcmFtX25hbWVkKGVuYWJsZV92aG9zdF92
ZHBhX3Vuc2FmZV9ub2lvbW11X21vZGUsDQo+ID4gPiA+ID4gKyAgICAgICAgICAgICAgdmhvc3Rf
dmRwYV9ub2lvbW11LCBib29sLCAwNjQ0KTsNCj4gPiA+ID4gPiArTU9EVUxFX1BBUk1fREVTQyhl
bmFibGVfdmhvc3RfdmRwYV91bnNhZmVfbm9pb21tdV9tb2RlLA0KPiA+ID4gPiAiRW5hYmxlDQo+
ID4gPiA+ID4gK1VOU0FGRSwgbm8tSU9NTVUgbW9kZS4gIFRoaXMgbW9kZSBwcm92aWRlcyBubyBk
ZXZpY2UgaXNvbGF0aW9uLA0KPiA+ID4gPiA+ICtubyBETUEgdHJhbnNsYXRpb24sIG5vIGhvc3Qg
a2VybmVsIHByb3RlY3Rpb24sIGNhbm5vdCBiZSB1c2VkDQo+ID4gPiA+ID4gK2ZvciBkZXZpY2Ug
YXNzaWdubWVudCB0byB2aXJ0dWFsIG1hY2hpbmVzLCByZXF1aXJlcyBSQVdJTw0KPiA+ID4gPiA+
ICtwZXJtaXNzaW9ucywgYW5kIHdpbGwgdGFpbnQgdGhlIGtlcm5lbC4gIElmIHlvdSBkbyBub3Qg
a25vdyB3aGF0IHRoaXMgaXMNCj4gZm9yLCBzdGVwIGF3YXkuDQo+ID4gPiA+ID4gKyhkZWZhdWx0
OiBmYWxzZSkiKTsNCj4gPiA+ID4gPiArDQo+ID4gPiA+ID4gIHN0cnVjdCB2aG9zdF92ZHBhX2Fz
IHsNCj4gPiA+ID4gPiAgICAgc3RydWN0IGhsaXN0X25vZGUgaGFzaF9saW5rOw0KPiA+ID4gPiA+
ICAgICBzdHJ1Y3Qgdmhvc3RfaW90bGIgaW90bGI7DQo+ID4gPiA+ID4gQEAgLTYwLDYgKzY1LDcg
QEAgc3RydWN0IHZob3N0X3ZkcGEgew0KPiA+ID4gPiA+ICAgICBzdHJ1Y3QgdmRwYV9pb3ZhX3Jh
bmdlIHJhbmdlOw0KPiA+ID4gPiA+ICAgICB1MzIgYmF0Y2hfYXNpZDsNCj4gPiA+ID4gPiAgICAg
Ym9vbCBzdXNwZW5kZWQ7DQo+ID4gPiA+ID4gKyAgIGJvb2wgbm9pb21tdV9lbjsNCj4gPiA+ID4g
PiAgfTsNCj4gPiA+ID4gPg0KPiA+ID4gPiA+ICBzdGF0aWMgREVGSU5FX0lEQSh2aG9zdF92ZHBh
X2lkYSk7IEBAIC04ODcsNiArODkzLDEwIEBAIHN0YXRpYw0KPiA+ID4gPiA+IHZvaWQgdmhvc3Rf
dmRwYV9nZW5lcmFsX3VubWFwKHN0cnVjdCB2aG9zdF92ZHBhICp2LCAgew0KPiA+ID4gPiA+ICAg
ICBzdHJ1Y3QgdmRwYV9kZXZpY2UgKnZkcGEgPSB2LT52ZHBhOw0KPiA+ID4gPiA+ICAgICBjb25z
dCBzdHJ1Y3QgdmRwYV9jb25maWdfb3BzICpvcHMgPSB2ZHBhLT5jb25maWc7DQo+ID4gPiA+ID4g
Kw0KPiA+ID4gPiA+ICsgICBpZiAodi0+bm9pb21tdV9lbikNCj4gPiA+ID4gPiArICAgICAgICAg
ICByZXR1cm47DQo+ID4gPiA+ID4gKw0KPiA+ID4gPiA+ICAgICBpZiAob3BzLT5kbWFfbWFwKSB7
DQo+ID4gPiA+ID4gICAgICAgICAgICAgb3BzLT5kbWFfdW5tYXAodmRwYSwgYXNpZCwgbWFwLT5z
dGFydCwgbWFwLT5zaXplKTsNCj4gPiA+ID4gPiAgICAgfSBlbHNlIGlmIChvcHMtPnNldF9tYXAg
PT0gTlVMTCkgeyBAQCAtOTgwLDYgKzk5MCw5IEBADQo+ID4gPiA+ID4gc3RhdGljIGludCB2aG9z
dF92ZHBhX21hcChzdHJ1Y3Qgdmhvc3RfdmRwYSAqdiwNCj4gPiA+ID4gc3RydWN0IHZob3N0X2lv
dGxiICppb3RsYiwNCj4gPiA+ID4gPiAgICAgaWYgKHIpDQo+ID4gPiA+ID4gICAgICAgICAgICAg
cmV0dXJuIHI7DQo+ID4gPiA+ID4NCj4gPiA+ID4gPiArICAgaWYgKHYtPm5vaW9tbXVfZW4pDQo+
ID4gPiA+ID4gKyAgICAgICAgICAgZ290byBza2lwX21hcDsNCj4gPiA+ID4gPiArDQo+ID4gPiA+
ID4gICAgIGlmIChvcHMtPmRtYV9tYXApIHsNCj4gPiA+ID4gPiAgICAgICAgICAgICByID0gb3Bz
LT5kbWFfbWFwKHZkcGEsIGFzaWQsIGlvdmEsIHNpemUsIHBhLCBwZXJtLCBvcGFxdWUpOw0KPiA+
ID4gPiA+ICAgICB9IGVsc2UgaWYgKG9wcy0+c2V0X21hcCkgew0KPiA+ID4gPiA+IEBAIC05OTUs
NiArMTAwOCw3IEBAIHN0YXRpYyBpbnQgdmhvc3RfdmRwYV9tYXAoc3RydWN0IHZob3N0X3ZkcGEN
Cj4gPiA+ID4gPiAqdiwNCj4gPiA+ID4gc3RydWN0IHZob3N0X2lvdGxiICppb3RsYiwNCj4gPiA+
ID4gPiAgICAgICAgICAgICByZXR1cm4gcjsNCj4gPiA+ID4gPiAgICAgfQ0KPiA+ID4gPiA+DQo+
ID4gPiA+ID4gK3NraXBfbWFwOg0KPiA+ID4gPiA+ICAgICBpZiAoIXZkcGEtPnVzZV92YSkNCj4g
PiA+ID4gPiAgICAgICAgICAgICBhdG9taWM2NF9hZGQoUEZOX0RPV04oc2l6ZSksICZkZXYtPm1t
LT5waW5uZWRfdm0pOw0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gQEAgLTEyOTgsNiArMTMxMiw3IEBA
IHN0YXRpYyBpbnQgdmhvc3RfdmRwYV9hbGxvY19kb21haW4oc3RydWN0DQo+ID4gPiA+IHZob3N0
X3ZkcGEgKnYpDQo+ID4gPiA+ID4gICAgIHN0cnVjdCB2ZHBhX2RldmljZSAqdmRwYSA9IHYtPnZk
cGE7DQo+ID4gPiA+ID4gICAgIGNvbnN0IHN0cnVjdCB2ZHBhX2NvbmZpZ19vcHMgKm9wcyA9IHZk
cGEtPmNvbmZpZzsNCj4gPiA+ID4gPiAgICAgc3RydWN0IGRldmljZSAqZG1hX2RldiA9IHZkcGFf
Z2V0X2RtYV9kZXYodmRwYSk7DQo+ID4gPiA+ID4gKyAgIHN0cnVjdCBpb21tdV9kb21haW4gKmRv
bWFpbjsNCj4gPiA+ID4gPiAgICAgY29uc3Qgc3RydWN0IGJ1c190eXBlICpidXM7DQo+ID4gPiA+
ID4gICAgIGludCByZXQ7DQo+ID4gPiA+ID4NCj4gPiA+ID4gPiBAQCAtMTMwNSw2ICsxMzIwLDE0
IEBAIHN0YXRpYyBpbnQgdmhvc3RfdmRwYV9hbGxvY19kb21haW4oc3RydWN0DQo+ID4gPiA+IHZo
b3N0X3ZkcGEgKnYpDQo+ID4gPiA+ID4gICAgIGlmIChvcHMtPnNldF9tYXAgfHwgb3BzLT5kbWFf
bWFwKQ0KPiA+ID4gPiA+ICAgICAgICAgICAgIHJldHVybiAwOw0KPiA+ID4gPiA+DQo+ID4gPiA+
ID4gKyAgIGRvbWFpbiA9IGlvbW11X2dldF9kb21haW5fZm9yX2RldihkbWFfZGV2KTsNCj4gPiA+
ID4gPiArICAgaWYgKCghZG9tYWluIHx8IGRvbWFpbi0+dHlwZSA9PSBJT01NVV9ET01BSU5fSURF
TlRJVFkpICYmDQo+ID4gPiA+ID4gKyAgICAgICB2aG9zdF92ZHBhX25vaW9tbXUgJiYgY2FwYWJs
ZShDQVBfU1lTX1JBV0lPKSkgew0KPiA+ID4gPg0KPiA+ID4gPiBTbyBpZiB1c2Vyc3BhY2UgZG9l
cyBub3QgaGF2ZSBDQVBfU1lTX1JBV0lPIGluc3RlYWQgb2YgZmFpbGluZw0KPiA+ID4gPiB3aXRo
IGEgcGVybWlzc2lvbiBlcnJvciB0aGUgZnVuY3Rpb25hbGl0eSBjaGFuZ2VzIHNpbGVudGx5Pw0K
PiA+ID4gPiBUaGF0J3MgY29uZnVzaW5nLCBJIHRoaW5rLg0KPiA+ID4gWWVzLCB5b3UgYXJlIGNv
cnJlY3QuIEkgd2lsbCBtb2RpZnkgdGhlIGNvZGUgdG8gcmV0dXJuIGVycm9yIHdoZW4NCj4gPiA+
IHZob3N0X3ZkcGFfbm9pb21tdSBpcyBzZXQgYW5kIENBUF9TWVNfUkFXSU8gaXMgbm90IHNldC4N
Cj4gPiA+DQo+ID4gPiBUaGFua3MuDQo+ID4gPiA+DQo+ID4gPiA+DQo+ID4gPiA+ID4gKyAgICAg
ICAgICAgYWRkX3RhaW50KFRBSU5UX1VTRVIsIExPQ0tERVBfU1RJTExfT0spOw0KPiA+ID4gPiA+
ICsgICAgICAgICAgIGRldl93YXJuKCZ2LT5kZXYsICJBZGRpbmcga2VybmVsIHRhaW50IGZvciBu
b2lvbW11DQo+ID4gPiA+ID4gKyBvbg0KPiA+ID4gPiBkZXZpY2VcbiIpOw0KPiA+ID4gPiA+ICsg
ICAgICAgICAgIHYtPm5vaW9tbXVfZW4gPSB0cnVlOw0KPiA+ID4gPiA+ICsgICAgICAgICAgIHJl
dHVybiAwOw0KPiA+ID4gPiA+ICsgICB9DQo+ID4gPiA+ID4gICAgIGJ1cyA9IGRtYV9kZXYtPmJ1
czsNCj4gPiA+ID4gPiAgICAgaWYgKCFidXMpDQo+ID4gPiA+ID4gICAgICAgICAgICAgcmV0dXJu
IC1FRkFVTFQ7DQo+ID4gPiA+ID4gLS0NCj4gPiA+ID4gPiAyLjI1LjENCj4gPiA+DQoNCg==

