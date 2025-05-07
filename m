Return-Path: <kvm+bounces-45754-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D09AAAAE7DF
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 19:32:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B105F1C27D2F
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 17:32:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E72A28C84F;
	Wed,  7 May 2025 17:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="aSyeYSwi";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="rK7iX2OZ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 351472B9AA;
	Wed,  7 May 2025 17:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746639139; cv=fail; b=EAgwbd/3ClzanfFWSsQl9YlbBrIL8oyU9/rWbENYsWGRINlTb+HzP3Yg4d4yAwdVZrVXEC2brLOovKTQ7rz6o+D4kuaMel0mUuQuYL2Nja+D0AYAB9gVCzqifjCpbHCAgx4wwmgTt7M1tRXwbUAoQxFSGS3aLuXSf2376mmuoBI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746639139; c=relaxed/simple;
	bh=i7y0nw5LGukp160fAOmvH3Cz5z6857j9zrX8Iy5i37o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nvTfbS7d4fUvpn2s9zY9C3sh33RUcc+7F6uZf/PvLcGMTmz2I8GYui5h4Uk5SfmFTf2gHAL5QRXR7i1Q8IS5KFlkM6wCbLSkYoh4GOUAeDpELtdt3kABMbg/ujvdOR/o/fTrDe1ywcaqhEYFEDjpSBDAcURJ1J+4IuzSTxHfWQc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=aSyeYSwi; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=rK7iX2OZ; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127843.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 547EuUQA028240;
	Wed, 7 May 2025 10:31:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=i7y0nw5LGukp160fAOmvH3Cz5z6857j9zrX8Iy5i3
	7o=; b=aSyeYSwiNmH3Jg7HVz2QhrEO+lavMskNZR0r5WV8yjVUsJL/maETEYoo3
	MmDFfhSmPxw7+vcm9xekHthxaUBz5Jotx8WkoxMgh2vYUHAoTp+R7f71jdymNj0n
	wgM+dZ2X335LXqW4sROto8G18B52j3T9XXb3Eq6W6ysurhpSM9F56V8/Yt7tlT+c
	dNT3z0XTtpDIZ9+VwgDmMcmwG0uXpAyQAVo6RliS//rkUhy/o1ROghUy2ijDcQPB
	EIJn2d06fltUrKhssaGl6u07fXYUWRoRsTVapVTJUjYP+vEExg61TdOdESymBM95
	UOuDlQzrCtBgR8mmrKG2iQcFrmsoA==
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 46dh8j1nnd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 07 May 2025 10:31:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jFmE98THsUan+BokahRJ98hZ6/zaS5mtluqy1M+PorO4UkWwywRwTI40Fq12F3S8vRQLR/ZEgWJqSWXb/rWN5mfuHd0i3tYTaLTtMqamyWcTWYTOyjAAyJuJJc6gHY1+l6lLJXZ6q4wkFKoi9GO+JqcSj6s1HTazliYhYDmZn2r7OM3JR4aVsODrMrTX7aLc2tSAUeNXZtuL6z6KOGFZAbBJV04Tgc6sbxuMI602jgbB35v5xZinuD6khxxRr5A/o8l+nlKaVWzSWyCBm/sGWY/4MRYE8XgIwImrKmnfQvbg8CnbVA+HXmkHmj7kf3OBC+b+sbIv4M9BMgu9DaCJuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i7y0nw5LGukp160fAOmvH3Cz5z6857j9zrX8Iy5i37o=;
 b=bZyuh/4ssr39CStUi1v0RRhfQKcEUN9hOcmjlecZlJkTQFvvMAGny585nDzYtFjHuoiAX7K6ksx7Ltxq7RcFxVH8AWUXBEAcxq0wlJZXVDbR1PAZBEnPYViEfme71Bj61yWDQlvpONMkHcluIw1Hp2gzZFcSJftp4R6s7H9sw2NxHTZFpmkLFhy5ZAKfvCcFOTiv5yQ3RqWwRJ6SQEBCl2TvFCxnusuT3ED3AhA2pYCcu/fIIIEIKFO8qpY+yHNSy+dghAu6xagUUf4BGtGy0wnIfg1/ujX/P0PVT69vh+00SIVp576BfQvJs1a6wLLmXTfY2ne2pEVT0ubYhk8kuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i7y0nw5LGukp160fAOmvH3Cz5z6857j9zrX8Iy5i37o=;
 b=rK7iX2OZsKwpwUVfiLPcHiBvcyN5ndcaG/au2gk7Ws813uOhNtUHRcB+TS6jph5IIBO0WJD7R2MV4Xzj44zpkXkg0BT5k24PLjxcgRM2Ggb9se/4rAI2r9rEy2EPnfi0k0kE2UANiIGdUqg/yJ+ktduxTWljze3hgAAmCT0HIzpUN8Rh1c8AwGNsmek9vj2vmIZv81GeF2z52DIbYhodCkovp1NjX3+p1tbs+sQT8m/spSb+pur1O4hr2rQ6O5Wg7vG6z4iVfu1DjCLAtBaMcf49Ukik80H+PMKkswr3QzOYbXPqRzX95OisPwXZHwkKPTRIzahUskGjVGG6WgfGow==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by BY5PR02MB7042.namprd02.prod.outlook.com
 (2603:10b6:a03:23b::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.21; Wed, 7 May
 2025 17:31:47 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%4]) with mapi id 15.20.8722.020; Wed, 7 May 2025
 17:31:47 +0000
From: Jon Kohler <jon@nutanix.com>
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
        =?utf-8?B?RXVnZW5pbyBQw6lyZXo=?= <eperezma@redhat.com>,
        Alexei Starovoitov
	<ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller"
	<davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard
 Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux.dev"
	<virtualization@lists.linux.dev>,
        "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH net-next] vhost/net: align variable names with XDP
 terminology
Thread-Topic: [PATCH net-next] vhost/net: align variable names with XDP
 terminology
Thread-Index: AQHbv2Unji7kqewsuUawCHreFj4VAbPHapkAgAACYYA=
Date: Wed, 7 May 2025 17:31:47 +0000
Message-ID: <C9ADA542-813C-42C4-AF5D-92445EB70A6A@nutanix.com>
References: <20250507160206.3267692-1-jon@nutanix.com>
 <681b96fa747b0_1f6aad29448@willemb.c.googlers.com.notmuch>
In-Reply-To: <681b96fa747b0_1f6aad29448@willemb.c.googlers.com.notmuch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.400.131.1.6)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV8PR02MB10287:EE_|BY5PR02MB7042:EE_
x-ms-office365-filtering-correlation-id: 9c5de336-03f9-4d10-03b0-08dd8d8d0b57
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?Nm5NSlV3Um1QYkhJeEE5dlQrWFF0ekN5cTdiQ29IcmRGUml0RkFqbzVyTWJD?=
 =?utf-8?B?QWFGakJCS205K3paakNLMlFxSklyWXFwbTJjVU9OU1poMlhBRXExdkxhRnBT?=
 =?utf-8?B?TjV1Nlg0Zi9oeEJUTUJpZ1d5Nm5WdUl4RWxxRDl3QmVyTVZjZlpBOVNvV2l1?=
 =?utf-8?B?U2hkMVk5Q0ZRTzZHUkt1S1JZSU5QU3Q2V2d1SzRSUGRQNXFVSUdITUVXRThE?=
 =?utf-8?B?Mmw4MWxpR29GVmtVY3JyZ1F6Y2NNZENRNmtJQTNGc0RuTmh2ZWRJbGU4VXFs?=
 =?utf-8?B?RTNjNDBOMUlqeEFadkp3K1JacEpnaUx1MHNHbFRkRVJmVDJCYTBnZEgrWi9q?=
 =?utf-8?B?UFpxSVlnaHdGckJBMHpwOXR3VmlHejFhVGFWNXI5aTRxT3JlVDd4c3ZhWjgw?=
 =?utf-8?B?Sk1uaTQ0TWxWcFRBZW1qWVZ6N1BxWUgzYnpqL0RXdEQzWldaUTRzTTVXbld2?=
 =?utf-8?B?V3NveXloNnRtQ1B3NU5wYjdQdmZsTVJvSzIrY3hVZzlBekpKTUN3Q0NuWDha?=
 =?utf-8?B?a0tDbnoxVUR6VmZ6UDA5d3FuU09rM2Y4WjhGcElvTCtMUStnSGVFRjh0WHh3?=
 =?utf-8?B?dDkrN0JIdkVUQUpBV1hReVFKQVYxc2gra0V5RkMwaVIybmV5TjF0NHBnWkR2?=
 =?utf-8?B?VXB6dUNodWVpa0pXRXYyZHowSndHV1dvd0RXM1NKZEpqSFZRdjVMYkhFM1Ux?=
 =?utf-8?B?eHNiSEpoZytxUWRSM3V6OHdyQnpPMllPMUZ4Y1JKU3h3V2JReWNPcGM2a3hi?=
 =?utf-8?B?Ny9YRFVLMm51TFgzbEFOYSs1RmF1c1VEcW91bW1SV2dFNnBQWThMY25zYVJq?=
 =?utf-8?B?c1IzSjZaRXdtZHU4bkF3UGFYeDVzdnJiSXBqUnlncDNkUnZmZFFpWE1VcmFn?=
 =?utf-8?B?RVdDNVg1QmFkMkV6NGdkdjN6QkxTeHpMQ3BRUWNFR1l3Zm9Xc1FQWEdjaDkv?=
 =?utf-8?B?Tks4SG9OZmFDcjdlckZqZyszNzlXUEZJNDRrUGtTSklrZm9LdmdTNElWZmZi?=
 =?utf-8?B?dnVISGZTVnNjMUNoelZEQUF5K2xhNllPWWlFOVJBVTNpWms5RzhWZkNTS0FR?=
 =?utf-8?B?S3pzUGFWYVhEZ2ROVVJ4VERrOEtpUU10cTZ4WWxWNi9WSzRFdGh6dldGV3ln?=
 =?utf-8?B?bGFBR1poSFlya1REeUQ2MjVHSUs1b29LMXJONHA4TEJvdUpqWTJyTUh2a2xw?=
 =?utf-8?B?bjJqY1FlVHFlQlc0ZmoxVHRnTWl3YTZDZ29CNEd5a2tBYVdhTmxBQi9kTDB6?=
 =?utf-8?B?L2xlNnJ4UWg0L2RPWm9aNHVyeFdEdW9Pc25QQ3Znd0hYZGdsNzZXemZ2VjEz?=
 =?utf-8?B?eUlaQm1jY1RhNXkrMmpUS2hJRmovNGFMdUxnRURaQjM0eU5SUENuSm54VU5p?=
 =?utf-8?B?dHFNeEhldUNYYnZzdDVaVmwwbWtvaFY3MERrMW95SVl5K3RmV2FEREg0WG5S?=
 =?utf-8?B?bUM2OVpHY2w5WGY1ZEFFQkdEdzBVZS9aWHdWUWs0Y0xiR1dWTTV2VHlQNVI1?=
 =?utf-8?B?VE5rYzZHRllCbHJRSm5KWWwzeE1GS0gxSXVtSzhmR29tTlJBUWZCQldUdks4?=
 =?utf-8?B?eHJLOGZoUzh5R3ExaGRaajBMMXdrZFh4RVJXN1VlQXhlYUdkRTNiaXB0bkRX?=
 =?utf-8?B?TjFMY1ByN2ZvdmhCY3A2ZjBCTFV3ZFJzM2s4bDFSandHaGJaT2NocEVlWmR2?=
 =?utf-8?B?Q2lyVzdlYm9lSUp4ZkJOcFcrZkVONUpWcHBWRHFFR1lXUU1JYnVSaG9jZW9q?=
 =?utf-8?B?aEo5VFhYcnZQTDUwVHZMdmFkRTdFempBdmlwTUNYVUo0cTVPZk95clgzQXo5?=
 =?utf-8?B?OEZSSGJMdUhhR1lnTTAraFNtTzNvZ0dwemowSXFvdnVlS1hZN3JoR2FxUWI0?=
 =?utf-8?B?UW12VXFHTlAvSTlWS0FQSEErVTNaY3o2eXd4aXRmbGR5MTRVZ0ErOVlTTDRP?=
 =?utf-8?B?MkxPZ09GN3hlQXRrbmZOOHB3OVEwS2tlZks2VUlnUW5WMStPYmF0dDEvbjE1?=
 =?utf-8?B?a09aZS9mSm93PT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?R0Z5WEh3MVhpTkJ1R1VPZXgrTzJoTmFxOEEydTRDajFCczlBL2ZOUDBDR0Fp?=
 =?utf-8?B?TjFLK2NuWjgwVW0xQkllOFhrQU1oVFhTTXNpdU5MTDBOa1JqaUtIVzdjc1hM?=
 =?utf-8?B?MkV4bFZLZDNXNjlUbVh6UXppNzY1OCt4bVFFc0tGSTJ5MkowU3JxTjZyZXZE?=
 =?utf-8?B?VStIMTRNcVZmS29oV2ZMRlIzN09TbzJiVmVHcUs0YlBkNW52RG9OVXhML05Q?=
 =?utf-8?B?RTBBN2J1SjNkcTNEYnozVEd5Y2tUelZxc3hQY29lckE5T3FOWGJTR0doUDNW?=
 =?utf-8?B?VzJrSUZLUDZJWUN1STZ4S3M2bUdoVWU5OFZQcXpYcDdNLzMzMG96RVIwTGR5?=
 =?utf-8?B?SkQvQUh3N3dBOXYwQmIyNFRBRkhEeVpPZ3l2dzdhM21iZENwNUkzVmQxVU14?=
 =?utf-8?B?NGVHcHFRcWE3b0hEQ2l4RjJIekgyT1E2dWZod3ZmczFmaXpTWTltcFhrUFkz?=
 =?utf-8?B?K1pZai9XWmh2cmJPWFdXYXB3NS9wZU9JNmovZlJqR21MR0wwSmhUSXp6ajBu?=
 =?utf-8?B?WGMva3N5dUZ5ZjRkZ0h4WXkwdG4wb2RNRkEra3RyeUFlcy94WFBFdDV1V1BF?=
 =?utf-8?B?TXFZNFRLK0FaNnM5MWhZcGpTSXlMS0J2akl6aVlEYlFEZnh6MURETUxnLzAw?=
 =?utf-8?B?N2hMeG82aTdScGV3OEVpcjFWUTVRMThtNHRIR1RUN2R4V0lIR1RpSHhPRXYz?=
 =?utf-8?B?a2VxRnJvS2xkNXFMWVdUNWhRV240bktKQ2tkRHVxZzI4L00yR1dBS1VyQUhr?=
 =?utf-8?B?VC9GQWRUa1R2R0hEcFBBcXNFK3FtMEZmaFhyRWRzVVRYWlRkQ2ovTVp0N0Vp?=
 =?utf-8?B?YUluL0N3dk00cmRNazhycitEeHJteWpjSkxTVVJKS0dtcklWbm00ZENFRUdt?=
 =?utf-8?B?eVltY0FzVzhMWDFlUi9IUS9ZRy95VnhETkEvVGUxWHJMOXc4Q1ZYZGN5ZEVG?=
 =?utf-8?B?bmdxK0t2eEErYVExQmRFV0tRQ2lzWmNYajJyTFI0d2syU1UxSFRQejRVbUg0?=
 =?utf-8?B?YUJNTktzOEZjcUJiTTlJZ3owUWxEUGQvT3YzTVRCU21jRlpobGtCM2xUWWtq?=
 =?utf-8?B?YTU3aXd2TnAwdjBvTUExTTdsY0lJTHYxWjA3NS9yNGFLVjdESm5TQWF1YWRn?=
 =?utf-8?B?V01LejhKRDVLbi9jeWNoV211ZHRvb3dCdDI2N2EvU1JSL1ArRk53TWZkY0w0?=
 =?utf-8?B?TWtyaXQvaWRZckhQTTl1WFZON2t4SlA1TTlmNzFOMWlUbE8wVzJadFQ5c1ZP?=
 =?utf-8?B?OG9OY0lZbWsrVWt1a25nV1dTQXUwVHFyOWNlNW5YTHR2UVZmNmJFVFVIOFNM?=
 =?utf-8?B?Si90bVNsdDJFQ3FheVg3WkhmZ1pmc1V6dTNOdkkwZkJzeGF5clBSbi9CMk5Q?=
 =?utf-8?B?TWNqL0xqQktEM2laTHA5ektKeiszOW9CYkdvMzFWSzRYeENaTWxibWFkalVL?=
 =?utf-8?B?MTFyd1dKSVlQNHFHZElNd2ZhTjFCdXBTTEVPUGZ5MXJWWDdGSFNyRFlWRGdh?=
 =?utf-8?B?QzFReGhBWU9FdENUU2JkZXJMc080T3Z2V0xmb2pWeWpMa0E1WXc4bWM5SUdz?=
 =?utf-8?B?T2ZiVElPVjVrRG1lOW43Yk12ZWFQMnF6bVhZQ1MwYzA3SSttNkl2L0FBSzBJ?=
 =?utf-8?B?YW1ndStNWVU0QU12Q2dUUFg3YkRzWWtrcjJkQndMQkpzdVFjZ2Y5S3VPb0Zi?=
 =?utf-8?B?N0dsMDI0NkROK09oQmFqUnNDS3RybUZzK1VTekYvcmx1MEgyNTFuQ3lwSlpK?=
 =?utf-8?B?Y3M5VFd0V3NxNHpjd3RuMUF0SzNleWd1Tkw0YmV1T3kxdk9vOE9ndXZYbm5l?=
 =?utf-8?B?RVdBbWdtNHZuTk9CcWE5NStGclB2OHVuT1JrTnhUc0hEQkFjVm9EdWIvcWVq?=
 =?utf-8?B?RXRaOWhCR2gyeFBXMXlYU0x2MkVHeW9lVzkzcXZkSEFZVm1sV2J0bEV5TURp?=
 =?utf-8?B?VjN3WFlHQjltYyt4dG9rVlcrakpqR0drNVBkb3k0NFU1ZnRhbGJ2bGFRckF1?=
 =?utf-8?B?MWJyMldBZ0NVZnVKUHRsWGZLb3BOKzlOYW1jSURQVFBDT3hxbVRTUHVHUmd2?=
 =?utf-8?B?RE9hb1ZsdG94OTZacXo4OVpQQm5rNHlIcXpYYWVqZmRmUHBYT1lMNmFMR2FF?=
 =?utf-8?B?ZS9ONWo1aStxRkhmMFZ4emJXYStIL2NMdDFaWnFta01xVVVJOWMwUENreGdD?=
 =?utf-8?B?ZHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2201CB7A7745C94EA11B3FC4B23ABD31@namprd02.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c5de336-03f9-4d10-03b0-08dd8d8d0b57
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 May 2025 17:31:47.6585
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QrxWUUxibU97fGwXRruXPEQY8jgRFf9wMBgC/xodbiOQ34A51UE67oUIrU+e53U0tTQOA4GlmT0TGyCkmoXMUIFBeM+jlA3yIhEklI6xTzo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR02MB7042
X-Authority-Analysis: v=2.4 cv=B/y50PtM c=1 sm=1 tr=0 ts=681b990a cx=c_pps a=PdgAl9AEy1hEU2ikvxmBtw==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=dt9VzEwgFbYA:10 a=0kUYKlekyDsA:10 a=pGLkceISAAAA:8 a=64Cc0HZtAAAA:8 a=f_AghcSI2spZymckaScA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: 2xwbn_zlLZrougcExdjatfm_hAAIoOcY
X-Proofpoint-GUID: 2xwbn_zlLZrougcExdjatfm_hAAIoOcY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTA3MDE1OSBTYWx0ZWRfX9ciN0bFEYlG/ Y64YmF55W0+JyTuku5VPgWK2p3hdkKn9Ry+7bNoWBKra77yqWEpNiwgEVXURcivtwjn1mDPjLh3 4Z/ChohbxOBLE4Uq3YsG10V9niNfTl58hYPxDdScwl30s2j59Zj5blLUYxEVhb5kmoKTQt18NaM
 Ktre9nL7cgaH57+OIddFiwYvfOPyCWAL4fgqfcLJBL9f5jycsmQIPZlfUU+9A6HTxp4xv2ly6qY GZl8nqa6v/I6om/0gIX7LYpm+tR0+DsTnYIiQTMxldOKIgSHpE/SO8H8TnBXXzG5Mdp33nUgZ5t Pd2L0sTohvwbBFfOWRFkN1UpOZvo5+PhOec2w+t0boDs7Gt74CKu3rdWQZYwdfLoGpapuDM4JZb
 7U2lpB7kK3EPxixrKgaRON8Xm3te0QxO0GgCVfd1ZrAvsMXJ6EKCRtc3At/m/2xvKHXi+W+Q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-07_05,2025-05-06_01,2025-02-21_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gTWF5IDcsIDIwMjUsIGF0IDE6MjPigK9QTSwgV2lsbGVtIGRlIEJydWlqbiA8d2ls
bGVtZGVicnVpam4ua2VybmVsQGdtYWlsLmNvbT4gd3JvdGU6DQo+IA0KPiAhLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLXwN
Cj4gIENBVVRJT046IEV4dGVybmFsIEVtYWlsDQo+IA0KPiB8LS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLSENCj4gDQo+IEpv
biBLb2hsZXIgd3JvdGU6DQo+PiBSZWZhY3RvciB2YXJpYWJsZSBuYW1lcyBpbiB2aG9zdF9uZXRf
YnVpbGRfeGRwIHRvIGFsaWduIHdpdGggWERQDQo+PiB0ZXJtaW5vbG9neSwgZW5oYW5jaW5nIGNv
ZGUgY2xhcml0eSBhbmQgY29uc2lzdGVuY3kuIEFkZGl0aW9uYWxseSwNCj4+IHJlb3JkZXIgdmFy
aWFibGVzIHRvIGZvbGxvdyBhIHJldmVyc2UgQ2hyaXN0bWFzIHRyZWUgc3RydWN0dXJlLA0KPj4g
aW1wcm92aW5nIGNvZGUgb3JnYW5pemF0aW9uIGFuZCByZWFkYWJpbGl0eS4NCj4+IA0KPj4gVGhp
cyBjaGFuZ2UgaW50cm9kdWNlcyBubyBmdW5jdGlvbmFsIG1vZGlmaWNhdGlvbnMuDQo+PiANCj4+
IFNpZ25lZC1vZmYtYnk6IEpvbiBLb2hsZXIgPGpvbkBudXRhbml4LmNvbT4NCj4gDQo+IFdlIGdl
bmVyYWxseSBkb24ndCBkbyBwdXJlIHJlZmFjdG9yaW5nIHBhdGNoZXMuDQo+IA0KPiBUaGV5IGFk
ZCBjaHVybiB0byBjb2RlIGhpc3RvcnkgZm9yIGxpdHRsZSBnYWluIChhbmQgc29tZQ0KPiBvdmVy
aGVhZCBhbmQgcmlzaykuDQo+IA0KDQpPaywgSeKAmWxsIGNsdWIgdGhpcyB0b2dldGhlciB3aXRo
IHRoZSBsYXJnZXIgY2hhbmdlIEnigJltIHdvcmtpbmcgb24NCmZvciBtdWx0aS1idWZmZXIgc3Vw
cG9ydCBpbiB2aG9zdC9uZXQsIGlsbCBzZW5kIHRoYXQgYXMgYSBzZXJpZXMNCndoZW4gaXQgaXMg
cmVhZHkgZm9yIGV5ZXM=

