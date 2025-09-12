Return-Path: <kvm+bounces-57417-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 298F9B553B2
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 17:34:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D1EC516BA41
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 15:33:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5578313535;
	Fri, 12 Sep 2025 15:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="NAA1tT32";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="jNUnVM6p"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 832423112D3;
	Fri, 12 Sep 2025 15:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757691227; cv=fail; b=CQVr9bhqUlDnaiwzlb9ubERsya+wohxrUITCfQQ1rMrrsuMKnWklrLejQiwOT4keEh223zqLuFZFBGUGBREMAy3rvt5oThCNzQ51DtQTtNdY3xzmAGl26hoapw9aAHfzUh2BRm/R2ltWSZ7+ld8n4Osyg5sXwsCXDYdjel76UEM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757691227; c=relaxed/simple;
	bh=4T3Ua5F7C/hIauU8TRGL3Cu+UPv9DJq0ICeRcjt3iow=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Cl97APPWaz+MPAtdHHXS2t0EX8oRJhk4F4p6O7d+16bS5aQpMrAvNXLYDBuae878OccSiZ+xUM94Ubpj3GODGo1wdjozY8cswldJQ6FdsWO6Iu3vUqquXOMSYCwmHdRxXQY8c1oKRCinA1TT1+UNinghPAqICr+yyb2egPTtvIo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=NAA1tT32; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=jNUnVM6p; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 58CB1tCW032026;
	Fri, 12 Sep 2025 08:33:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=4T3Ua5F7C/hIauU8TRGL3Cu+UPv9DJq0ICeRcjt3i
	ow=; b=NAA1tT32IJlXB+GJ/4y9otnuK+ZWU1GPndunT4ROCoFMLP6TDAVIMwHUu
	X2r2gVMsSz4DgQbbevqH4n8L3WuTqsYua2jLb05Vz5Ucvk5LsAJhfK3iCsVvCVAw
	bAsWcKb/9BGwGybNIBYEC2ISu7d4l6ZWVy6EqtRQRDlVJxj+6Lkm2qCc+Cn3P/O9
	9nrP9z8S0uzUNHBnp1rmXbZPhty0+dhpvHW6xWmIMrhJx3kv6MDc3mVjlrhuUtbb
	9zXnr1jyltv6wc4mux0KcjplLJDyY2QbMrvbbdYYVqUOi5myjzYxjdM5/ermaxCc
	ZSkjElLqZP5Cl6gCX7EiENmyDR/tg==
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11021116.outbound.protection.outlook.com [52.101.52.116])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4946ussvcs-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 12 Sep 2025 08:33:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=m2nP73WQXGcxQNusU4I9SsaMGr6zNHqGbZehpcDJ+I69om3ETbLiHMxM1aRLmfKoafMmi7RdtOSK5Mm6pM8ZKQr+OF9YfG18dMJvGvS2IttGCKnSONx9QoJTiN70PAw6HH/10dwxRn3Mfd0t126P2HZBw6mJ+9YQ48xzvUvBIoPDolwUq1Gq7H6618dLBD+GbV8cP7FwE5A8VBRpUh3WAA3yKXOy2oP7ZK37HTE4MssJfwbRTVvQQUnCEcwNpt7ON238zeZd/LqDHgD/G4CH+LoYLNNRAWHPNsS0pU339g0Mw/bTRJxvHGVluky0sO5xIMKmAZ2xr5YoVhMB+ZkenQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4T3Ua5F7C/hIauU8TRGL3Cu+UPv9DJq0ICeRcjt3iow=;
 b=TdKhZz69HC67pywcnWBzOY4Wfk/qDQH4Fq5l8gMktEqFfrSPid6eUvbbJuKTByyJMNbd54Cj8CV2DhApdZdpVVqljT8iRJw3tarbLV/LP8Co/zfu7jsYeF42LvgJ0V/2Rd/ZeI4v4EiLq80v4tvXz7gekHi3TOs2mVQ9tYEZWIH3NBcHlACCFa6aKHBx5tT6JaGe1aTxOhy23NdsDbs+TtAysTR2yD0iNfrL0qnfUnt+2f0ou9uYjf1ccOFlkH2anvSR81wtQkZ91UeZAeMk4dMTH2oDJN8tbl8uPZKai5xjALZi5W0m9ZVwgAcnkPk5awsaCGA72AMPoZeJkJTADw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4T3Ua5F7C/hIauU8TRGL3Cu+UPv9DJq0ICeRcjt3iow=;
 b=jNUnVM6pCP38JDh46weEKrVf9xoG1QrYIreO/l9sgSjIeTYLi0RXfaJT0yby2IW2XE6EEDy0sIgnHtiPkdJxN1GQaBboDXqzBxkZcGM/5FFnYP43T447UO5i5MroKgAGF91PA0eD/ZoGtvBlmhzvVIvGMXAbfL4QN6MjP3JuacAV1/W2bk7SudijS9ZfVpa9qTMlZKObhVFvIvfHUgpt92GEcDmZRsW53pIiUwpV6iktSKN94JIoFCBMKxT1Q5g835x83oee+hQg74c8VjKFq+9YRT1+urDOe9GPZKjsdkxGO/8QfRUh60nKdCAvBsOxyezZBBGMD7Bvkq7uO3od0w==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by MN2PR02MB7072.namprd02.prod.outlook.com
 (2603:10b6:208:202::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Fri, 12 Sep
 2025 15:33:32 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%5]) with mapi id 15.20.9094.021; Fri, 12 Sep 2025
 15:33:32 +0000
From: Jon Kohler <jon@nutanix.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Jason Wang <jasowang@redhat.com>,
        "eperezma@redhat.com"
	<eperezma@redhat.com>,
        "jonah.palmer@oracle.com" <jonah.palmer@oracle.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>,
        "virtualization@lists.linux.dev"
	<virtualization@lists.linux.dev>,
        "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org"
	<stable@vger.kernel.org>
Subject: Re: [PATCH net 2/2] vhost-net: correctly flush batched packet before
 enabling notification
Thread-Topic: [PATCH net 2/2] vhost-net: correctly flush batched packet before
 enabling notification
Thread-Index: AQHcI78QBWYHJwNr40+h8qu/MFb2LLSPPR2AgABuEICAAAGXAIAAAOGA
Date: Fri, 12 Sep 2025 15:33:32 +0000
Message-ID: <4418BA21-716E-468B-85EB-DB88CCD64F38@nutanix.com>
References: <20250912082658.2262-1-jasowang@redhat.com>
 <20250912082658.2262-2-jasowang@redhat.com>
 <20250912044523-mutt-send-email-mst@kernel.org>
 <63426904-881F-4725-96F5-3343389ED170@nutanix.com>
 <20250912112726-mutt-send-email-mst@kernel.org>
In-Reply-To: <20250912112726-mutt-send-email-mst@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.700.81)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV8PR02MB10287:EE_|MN2PR02MB7072:EE_
x-ms-office365-filtering-correlation-id: fccb4273-d12c-4607-4423-08ddf211bafa
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|10070799003|7416014|376014|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?TGFSSmswaThTdlRaQS9ZS2FaZkVKelBwaFkrOS9PckJnMk9hYkJqOTRkK1gr?=
 =?utf-8?B?ekNqZ2p6b1ZwaWlTd3NaWlNCcnJtb2VPMjFpeWJaZFh0SGZZd05mV3dPZEl2?=
 =?utf-8?B?U25tVlUxbVV3cVVHYTM2Uzl5dHhJTE8yMWJKWjRndzlUS3pnUDhvZVVsLzB4?=
 =?utf-8?B?OXpmR1hIcW5ONjJaS0M5NkRNVGFFS0RyaW5BTlVXZlN3V2x3VDZrTGhjNWRG?=
 =?utf-8?B?bDhuVGQyYVFoY053R0U2YmJ2clpudit5d1UyNFdBMU1nOVBlYXdmcC9rWlc1?=
 =?utf-8?B?WVJHRFJyMlVlU1NWUjhtNUM3YmtmYVp5aUxFbjBQNjBUK0k4MUU5OW1yS0p0?=
 =?utf-8?B?TW5HQ3JKRG5KdXdLZXAxTFlyNFFiSENZRXZPYjErMEduTERQR093SW1ocnU3?=
 =?utf-8?B?ZEdxM1gzbytNckR4VlUvcXcrV0gzcGdHdVlGWEkzWW5zMnlZMWViTTYycDNr?=
 =?utf-8?B?clozaGMzaWl6TS9VeW5UTGxZcU05eEpjcldzeEZvalFMWjBORE95MkhaZDRo?=
 =?utf-8?B?aUN2REhmV21DUDlWclRZclpVZmh4aWttWWVSM3NYYkp0enZRZ0E3ZlRLbTJn?=
 =?utf-8?B?OXNrQ0IvQWxaS01hNElEOERmYmt5RGc2YnNGT2V2NEllMS9uMWw1R2ZwenV3?=
 =?utf-8?B?Kzg1NU0zNkhQbnJBS1pheGhaMWhab1lWYm94WHJiY2hranE2dm1yRUNwNDNS?=
 =?utf-8?B?WUlIa2RidFNBanJBaEYrNEV4a09aMFY3Qnp3TEU2RkJITjd1ODQwUUloVDd1?=
 =?utf-8?B?Wk5XSGxOdVJnS1NkVVJrTCtVY3E1MTdhU0xDdGZIQ2o2eGNBMi8vNXZBTUlS?=
 =?utf-8?B?dHhGcHlZQ09GSENHL1pTNGJjOGhkZTFRR1I1ZW5aRG96citCYi9zY1haT2Fr?=
 =?utf-8?B?WFN3aWFmakRKOGhMZWZNZEFoNkhVZVBJN29NZm0vQmJ4SXJIbGloR1VmU0F6?=
 =?utf-8?B?SGUvbWwxK205N3ZwZVhCSlp2QzdhR0Vtcm5aWG1OUHdKTmVGbm1EV01WdnlI?=
 =?utf-8?B?WlJXVkJCd0tPY2srTjRhYkdzL0UwMEJwT3lKVzRyd1ZFOTh5Vk56aFFIRHdT?=
 =?utf-8?B?QmE1aUgrRjlsUnVUY3pqSWFSRWdLZTVSclRjcCtYcnFLUGlpMjRUbHV3SER4?=
 =?utf-8?B?NlIxMmxkcjVuSkM2Y3NqdXMyQ2JpOHk0d0l1dzhZR2lIOFk5WXdhYXZxU29i?=
 =?utf-8?B?NWRKaEg0WHZaTFdaem14QUZWc2ROZ1ZNbG93OG1oUEcxb3R1UGN5Vi9zamVW?=
 =?utf-8?B?K0xhQWY4VVZvbkpWMWUvdFB4L1E1UEloK2hiWDhLc2ZBNmsrbEJJbXQ3SHRL?=
 =?utf-8?B?bnZBM1R2dFVnV1o1MTZYZlBDM2lnbjFNb0RETWlqeEprZDdNQVRaU0V3SzVu?=
 =?utf-8?B?MVRjZUY2TlpPZHF2UWRjN1U1Z2s5d3J5WWtIYThMV2RwNkp2S2FoT3lPUmwz?=
 =?utf-8?B?SEd4YTc3Si9MSjB3REVab0dWK1hZTmtYS3dUS3FuaDVrWmZJeDRzYlNsejVW?=
 =?utf-8?B?VDdqT3FOUDRxdkhUbDJzUnpyMkROWGh5WDAvTDk3OFZlVTZDMGFxQnFOY2hm?=
 =?utf-8?B?d0xFelJGT3B3ZDd2cFN4ZG1pbEcvL0U5YVpnZEZjclMyRy9PVnZNS2xyR2pQ?=
 =?utf-8?B?N3cxODZPc3JrR25LK1JOVU1SUXFYdkgyTXBkS1ZUazFneTlEZ1RnNFM4clk2?=
 =?utf-8?B?UDE1NlNBd3lDeDF1M1JTZm1SUjNsem42d3pIMU5XVURhRTh2UGtDYnM5ZDhR?=
 =?utf-8?B?bCtJNUdTblYyT1h0T2pYcDQyOUJFSW9lbmxYRVZIbldsaW1rTUZEeXFlbFBx?=
 =?utf-8?B?a1M5UkNGUWNZei9vYStGWkZSZmRqbzhCNU9VdlRsZ0hRdjcxQ1o3ZWVnMzNx?=
 =?utf-8?B?cysrcVgvaDU0VStQUkxOM25ZVEFmSU9JU2taZXVoUGJKcUc1S2hCenJZRlMy?=
 =?utf-8?B?M1UwTTRxb2UxT0tKZUxqZDNCOVZaSFVLZnpiWGF0NkVuaG5oQlhjMHBsdlVp?=
 =?utf-8?Q?qA/Qj4XXwhopYerKp08e9FZjgVfs0w=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(10070799003)(7416014)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?WXhrSCtLUDRDaVRPb2JHb0ZrSnVoaDBqK2ZyamlkUGI4S0VpK2JWc1FZc3hP?=
 =?utf-8?B?U3JvWG5EenNKVWRvSmVpeGhadVQ4L1JuK3RPNUUva3R2eStkaXlRMlJPV0FD?=
 =?utf-8?B?bzJrdHdOb3ZyTm1LaSsyck51M1FoRmljdzltaUlYOHplbUExV3VaK1QyMFp3?=
 =?utf-8?B?YmZsTFViNnNmLzBLZlJFNGZVVXRhd0M2NFM2M0YzVUY2QXI0SlBxTHFqTDdC?=
 =?utf-8?B?cUxLUDhBYURIQlk1eFcvWDZEbVM3K2szSVdTKzBtMEs4ZlI0STRqK3NuVXhl?=
 =?utf-8?B?VlpnZnFLcnN1aTlOVVZKQUNMUjlWd0s2akF0bzF0T1V0M0s0RWpTN05iRGZm?=
 =?utf-8?B?M0g3bFljUzlCWnZDWDdSbCtXZnQ5MWRJczZKOEcycW9Odjk3TTRQTnI3R2Fv?=
 =?utf-8?B?eHNaMEs2Z2pPZEQ4cmxiTG1xazY3ajl0MHBmb1VDMHJpekgvcVY0S2dGOGU5?=
 =?utf-8?B?NDkvSjZQcGF6SnY2aFg4ekRwaWhWQXNPVEthR1QrbkU4UlRXQU1jMUFVWVJQ?=
 =?utf-8?B?VE9RTmNhVU9GWEZrZ3lOeHloNS9hNWFzN2R5Z1J5N3djc3dZVUEvUjBxL3B5?=
 =?utf-8?B?bHBRWUNsMU9tRm9zNmxMTFRRY01ua2ZKVm1PNHU2cHV0R21lMnIzbTJ5Q1Bm?=
 =?utf-8?B?WC9hOU11T2NzU2RpcUJHSGdnOS9rQlIyaFVhQ21IdlVoODVKNE1wbUkwcExa?=
 =?utf-8?B?VG1HcnJadjVxdCszbER2TU00bHlHTlRpQnNPZXhEdGkzQ1l0RGtXU29VUlM5?=
 =?utf-8?B?OHJuVFJ1dXo3Z0lBMFJhSjNDdHYxRUIyODdtOC9nNHpxZDlqckNsMEVzTmJR?=
 =?utf-8?B?M0lyTXhxTUlWakh0NFZNMzNQQ0ZCekVVbklLOUs5VmxLbkRFZHp6NHNjVGlo?=
 =?utf-8?B?THliM3hELzVrVkY0RjZTOHlKY3B1MmF2dFY5VkdVNE5Nai8zSytCb0g0cjk1?=
 =?utf-8?B?M0JIUnZiTm1SYUhjdUpYWW02QWpWZjExSDZIZVVQamNndVJ4SzRKaFNFSUda?=
 =?utf-8?B?ZldHRSt3MzZROWJMRVZEMy9zKzYvWkVwQk5OSWZmdVM2cGdXSk5RU1pBL2Zy?=
 =?utf-8?B?eUsyWFdCSGx4elQ5N2dJVi9WdzcvYjJ4WFZaVTRqZEtEaFZ2bEh0M0lzajlQ?=
 =?utf-8?B?c0w4aEcyNm00WU9aMm9DZnZZWGJIdko2UVlnazd0SE85dllwSkVPS2Z2UXk0?=
 =?utf-8?B?YnBLc0NkSjRsbVNpcGZWME1xbFN2Z1FXUVBKbDRWZ2ZzV2ExSEoxVmx0aVpH?=
 =?utf-8?B?eG81WmlkbnIvblpEbmRKOTVxZGI0THYyYUVJRnh5UEpNb0J0MVZVejhDQ2h2?=
 =?utf-8?B?N1NxbkR0ZWIrR0ZxakJEZXV0U25ESDlQMWxySkZJeGVrT0cxcW9takw5OTNJ?=
 =?utf-8?B?eEs3VnV0SCsxclZrNCtDZjhSc0w3RTBQQW9OZysvSDhuazlROUlxdGJhV1lI?=
 =?utf-8?B?aHNsQjVrRndGTVliYi9FcUdGVnd2SjB6ZEExNUF0RVE1SkRuZjVVc3l2VnVu?=
 =?utf-8?B?TXVCTnZsdUJ0RzYxQmV1L0pIM05XRUZ4WW8xcmhxdEV5Vkt2ZzUzK3pNeHlG?=
 =?utf-8?B?a1lhWGQ4bXJVOERIVXMrSm05TmpUYXgrUnBmVytYWE0zV1B3c3dhajRCbG1N?=
 =?utf-8?B?K05TSzdlZmFuSDF6OGxYbzhFeTBGU1JnOGZOU0hYT3ZRM3gxZy9iUEE5ck1l?=
 =?utf-8?B?QVBkdWJ2b3RtVnY4cWNucGVQMmJIc2NNbytnSU9VRFdpejcrQjhQZE0xdW9V?=
 =?utf-8?B?QjR1YlcyaE1lbmw3VzBNbzFSMGJjMFZGSG8rM0k1bE9IR2dGZGZrWENmQWNG?=
 =?utf-8?B?RTNzcGFuRmdBTDNWdnhyTVp1M1NjOFhjT0M5bXJGR2N0TTFKcWc2RVdkK2M5?=
 =?utf-8?B?OXBuSERBUUFKT1Z6OWpUTTlDSGJSM1ZDUjF3UFBRdmJuc0I1M1FvZnJOOXMr?=
 =?utf-8?B?R2l4MjJyUzlLOHJLWUtJZ3pKYzFmOFg4WnR5bmdrSWFjMURjNVoxRnZEMjBp?=
 =?utf-8?B?SGQ3eWpockxhcTZDQTRGN1BCSGMxSmJjdjhJN01FUE1vdzdnakY5UmZRMlZG?=
 =?utf-8?B?My9xOHJvbjlGLzJyWHRYN3JoSG1OME1EYU1HUXN2bUNZZ2xyQmZtMDJwSS85?=
 =?utf-8?B?NE9wK3ZCTXRTNXhjaTRydzMxb0FjL2pzdGVzQkM4TVA5dFBDU05Oa09US3hM?=
 =?utf-8?B?aVRRZnVHTzJtNS9GZkhxVGFwME5QYXIrc2hQVnpKb2ZBOXppcFVpMVE4QnRO?=
 =?utf-8?B?dHpKa2Fsa3NjNjdyS0RFcFEvY0JBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1CCA88877018A049870CFE35854C7A10@namprd02.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: fccb4273-d12c-4607-4423-08ddf211bafa
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2025 15:33:32.1513
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h1yyZsXsSC6CnATHK0tOgJfidLYj85keWuJY3XVoPACmOTtKAcgZMwXaF7M2wXZOhl1ACKHWiEiZ5SXvA6s+daICViHljE30a5s4xCp5ze0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR02MB7072
X-Proofpoint-ORIG-GUID: ZvfLCTY22MjfWado8lU-ybne5wBWOIId
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTEyMDE0MyBTYWx0ZWRfXwP5tBkg4BSgu
 ZSkEt35Yynfk74+bqe7Z1K054iVI+Pb5mosfWXA3SkDoYGg+ES69ZdM6Pfl8KfAC1bCcQuEj0CM
 p/wGPExEcGuhwaOmD/apX/tflVWdTp1xJnhXFDEgYAfKWFfwi6edmOA7em0+2Go2azvShYwC/hL
 UmirNTRVEdw/bfB9+Z1QTfWdLR1AU8yZEd3NKiKe1S5LKfZZhmHmHT30GbRgMtOewT5sIHr0WZo
 WPSVVtYTVvsCI+BgexA0DX1hT0u9RfX22im4o/pSHm7TztHHRf2lOEfXdGB46CBo2mMuvun6qyD
 yEF88c9RDeo2KBwziZiAufb+JJ4q6dcQTCDaS6KcWSXsOHLV72f3LuT9ujjVq4=
X-Proofpoint-GUID: ZvfLCTY22MjfWado8lU-ybne5wBWOIId
X-Authority-Analysis: v=2.4 cv=V5V90fni c=1 sm=1 tr=0 ts=68c43d4e cx=c_pps
 a=LbO2ZyHrMbRaCxC771SosA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=yJojWOMRYYMA:10 a=0kUYKlekyDsA:10 a=20KFwNOVAAAA:8 a=64Cc0HZtAAAA:8
 a=VwQbUJbxAAAA:8 a=QGCCfucQJgl5T-WAAmoA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-12_05,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gU2VwIDEyLCAyMDI1LCBhdCAxMTozMOKAr0FNLCBNaWNoYWVsIFMuIFRzaXJraW4g
PG1zdEByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPiAgQ0FVVElPTjog
RXh0ZXJuYWwgRW1haWwNCj4gDQo+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPiANCj4gT24gRnJpLCBTZXAgMTIs
IDIwMjUgYXQgMDM6MjQ6NDJQTSArMDAwMCwgSm9uIEtvaGxlciB3cm90ZToNCj4+IA0KPj4gDQo+
Pj4gT24gU2VwIDEyLCAyMDI1LCBhdCA0OjUw4oCvQU0sIE1pY2hhZWwgUy4gVHNpcmtpbiA8bXN0
QHJlZGhhdC5jb20+IHdyb3RlOg0KPj4+IA0KPj4+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPj4+IENBVVRJT046
IEV4dGVybmFsIEVtYWlsDQo+Pj4gDQo+Pj4gfC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0hDQo+Pj4gDQo+Pj4gT24gRnJp
LCBTZXAgMTIsIDIwMjUgYXQgMDQ6MjY6NThQTSArMDgwMCwgSmFzb24gV2FuZyB3cm90ZToNCj4+
Pj4gQ29tbWl0IDhjMmU2YjI2ZmZlMiAoInZob3N0L25ldDogRGVmZXIgVFggcXVldWUgcmUtZW5h
YmxlIHVudGlsIGFmdGVyDQo+Pj4+IHNlbmRtc2ciKSB0cmllcyB0byBkZWZlciB0aGUgbm90aWZp
Y2F0aW9uIGVuYWJsaW5nIGJ5IG1vdmluZyB0aGUgbG9naWMNCj4+Pj4gb3V0IG9mIHRoZSBsb29w
IGFmdGVyIHRoZSB2aG9zdF90eF9iYXRjaCgpIHdoZW4gbm90aGluZyBuZXcgaXMNCj4+Pj4gc3Bv
dHRlZC4gVGhpcyB3aWxsIGJyaW5nIHNpZGUgZWZmZWN0cyBhcyB0aGUgbmV3IGxvZ2ljIHdvdWxk
IGJlIHJldXNlZA0KPj4+PiBmb3Igc2V2ZXJhbCBvdGhlciBlcnJvciBjb25kaXRpb25zLg0KPj4+
PiANCj4+Pj4gT25lIGV4YW1wbGUgaXMgdGhlIElPVExCOiB3aGVuIHRoZXJlJ3MgYW4gSU9UTEIg
bWlzcywgZ2V0X3R4X2J1ZnMoKQ0KPj4+PiBtaWdodCByZXR1cm4gLUVBR0FJTiBhbmQgZXhpdCB0
aGUgbG9vcCBhbmQgc2VlIHRoZXJlJ3Mgc3RpbGwgYXZhaWxhYmxlDQo+Pj4+IGJ1ZmZlcnMsIHNv
IGl0IHdpbGwgcXVldWUgdGhlIHR4IHdvcmsgYWdhaW4gdW50aWwgdXNlcnNwYWNlIGZlZWQgdGhl
DQo+Pj4+IElPVExCIGVudHJ5IGNvcnJlY3RseS4gVGhpcyB3aWxsIHNsb3dkb3duIHRoZSB0eCBw
cm9jZXNzaW5nIGFuZCBtYXkNCj4+Pj4gdHJpZ2dlciB0aGUgVFggd2F0Y2hkb2cgaW4gdGhlIGd1
ZXN0Lg0KPj4+IA0KPj4+IEl0J3Mgbm90IHRoYXQgaXQgbWlnaHQuDQo+Pj4gUGxzIGNsYXJpZnkg
dGhhdCBpdCAqaGFzIGJlZW4gcmVwb3J0ZWQqIHRvIGRvIGV4YWN0bHkgdGhhdCwNCj4+PiBhbmQg
YWRkIGEgbGluayB0byB0aGUgcmVwb3J0Lg0KPj4+IA0KPj4+IA0KPj4+PiBGaXhpbmcgdGhpcyBi
eSBzdGljayB0aGUgbm90aWZpY2FpdG9uIGVuYWJsaW5nIGxvZ2ljIGluc2lkZSB0aGUgbG9vcA0K
Pj4+PiB3aGVuIG5vdGhpbmcgbmV3IGlzIHNwb3R0ZWQgYW5kIGZsdXNoIHRoZSBiYXRjaGVkIGJl
Zm9yZS4NCj4+Pj4gDQo+Pj4+IFJlcG9ydGVkLWJ5OiBKb24gS29obGVyIDxqb25AbnV0YW5peC5j
b20+DQo+Pj4+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+Pj4+IEZpeGVzOiA4YzJlNmIy
NmZmZTIgKCJ2aG9zdC9uZXQ6IERlZmVyIFRYIHF1ZXVlIHJlLWVuYWJsZSB1bnRpbCBhZnRlciBz
ZW5kbXNnIikNCj4+Pj4gU2lnbmVkLW9mZi1ieTogSmFzb24gV2FuZyA8amFzb3dhbmdAcmVkaGF0
LmNvbT4NCj4+PiANCj4+PiBTbyB0aGlzIGlzIG1vc3RseSBhIHJldmVydCwgYnV0IHdpdGgNCj4+
PiAgICAgICAgICAgICAgICAgICAgdmhvc3RfdHhfYmF0Y2gobmV0LCBudnEsIHNvY2ssICZtc2cp
Ow0KPj4+IGFkZGVkIGluIHRvIGF2b2lkIHJlZ3Jlc3NpbmcgcGVyZm9ybWFuY2UuDQo+Pj4gDQo+
Pj4gSWYgeW91IGRvIG5vdCB3YW50IHRvIHN0cnVjdHVyZSBpdCBsaWtlIHRoaXMgKHJldmVydCtv
cHRpbWl6YXRpb24pLA0KPj4+IHRoZW4gcGxzIG1ha2UgdGhhdCBjbGVhciBpbiB0aGUgbWVzc2Fn
ZS4NCj4+PiANCj4+PiANCj4+Pj4gLS0tDQo+Pj4+IGRyaXZlcnMvdmhvc3QvbmV0LmMgfCAzMyAr
KysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4+Pj4gMSBmaWxlIGNoYW5nZWQsIDEz
IGluc2VydGlvbnMoKyksIDIwIGRlbGV0aW9ucygtKQ0KPj4+PiANCj4+Pj4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvdmhvc3QvbmV0LmMgYi9kcml2ZXJzL3Zob3N0L25ldC5jDQo+Pj4+IGluZGV4IDE2
ZTM5ZjNhYjk1Ni4uMzYxMWI3NTM3OTMyIDEwMDY0NA0KPj4+PiAtLS0gYS9kcml2ZXJzL3Zob3N0
L25ldC5jDQo+Pj4+ICsrKyBiL2RyaXZlcnMvdmhvc3QvbmV0LmMNCj4+Pj4gQEAgLTc2NSwxMSAr
NzY1LDExIEBAIHN0YXRpYyB2b2lkIGhhbmRsZV90eF9jb3B5KHN0cnVjdCB2aG9zdF9uZXQgKm5l
dCwgc3RydWN0IHNvY2tldCAqc29jaykNCj4+Pj4gaW50IGVycjsNCj4+Pj4gaW50IHNlbnRfcGt0
cyA9IDA7DQo+Pj4+IGJvb2wgc29ja19jYW5fYmF0Y2ggPSAoc29jay0+c2stPnNrX3NuZGJ1ZiA9
PSBJTlRfTUFYKTsNCj4+Pj4gLSBib29sIGJ1c3lsb29wX2ludHI7DQo+Pj4+IGJvb2wgaW5fb3Jk
ZXIgPSB2aG9zdF9oYXNfZmVhdHVyZSh2cSwgVklSVElPX0ZfSU5fT1JERVIpOw0KPj4+PiANCj4+
Pj4gZG8gew0KPj4+PiAtIGJ1c3lsb29wX2ludHIgPSBmYWxzZTsNCj4+Pj4gKyBib29sIGJ1c3ls
b29wX2ludHIgPSBmYWxzZTsNCj4+Pj4gKw0KPj4+PiBpZiAobnZxLT5kb25lX2lkeCA9PSBWSE9T
VF9ORVRfQkFUQ0gpDQo+Pj4+IHZob3N0X3R4X2JhdGNoKG5ldCwgbnZxLCBzb2NrLCAmbXNnKTsN
Cj4+Pj4gDQo+Pj4+IEBAIC03ODAsMTAgKzc4MCwxOCBAQCBzdGF0aWMgdm9pZCBoYW5kbGVfdHhf
Y29weShzdHJ1Y3Qgdmhvc3RfbmV0ICpuZXQsIHN0cnVjdCBzb2NrZXQgKnNvY2spDQo+Pj4+IGJy
ZWFrOw0KPj4+PiAvKiBOb3RoaW5nIG5ldz8gIFdhaXQgZm9yIGV2ZW50ZmQgdG8gdGVsbCB1cyB0
aGV5IHJlZmlsbGVkLiAqLw0KPj4+PiBpZiAoaGVhZCA9PSB2cS0+bnVtKSB7DQo+Pj4+IC0gLyog
S2lja3MgYXJlIGRpc2FibGVkIGF0IHRoaXMgcG9pbnQsIGJyZWFrIGxvb3AgYW5kDQo+Pj4+IC0g
KiBwcm9jZXNzIGFueSByZW1haW5pbmcgYmF0Y2hlZCBwYWNrZXRzLiBRdWV1ZSB3aWxsDQo+Pj4+
IC0gKiBiZSByZS1lbmFibGVkIGFmdGVyd2FyZHMuDQo+Pj4+ICsgLyogRmx1c2ggYmF0Y2hlZCBw
YWNrZXRzIGJlZm9yZSBlbmFibGluZw0KPj4+PiArICogdmlycXR1ZXVlIG5vdGlmaWNhdGlvbiB0
byByZWR1Y2UNCj4+Pj4gKyAqIHVubmVjc3NhcnkgdmlydHF1ZXVlIGtpY2tzLg0KPj4+IA0KPj4+
IHR5cG9zOiB2aXJ0cXVldWUsIHVubmVjZXNzYXJ5DQo+Pj4gDQo+Pj4+ICovDQo+Pj4+ICsgdmhv
c3RfdHhfYmF0Y2gobmV0LCBudnEsIHNvY2ssICZtc2cpOw0KPj4+PiArIGlmICh1bmxpa2VseShi
dXN5bG9vcF9pbnRyKSkgew0KPj4+PiArIHZob3N0X3BvbGxfcXVldWUoJnZxLT5wb2xsKTsNCj4+
Pj4gKyB9IGVsc2UgaWYgKHVubGlrZWx5KHZob3N0X2VuYWJsZV9ub3RpZnkoJm5ldC0+ZGV2LA0K
Pj4+PiArIHZxKSkpIHsNCj4+Pj4gKyB2aG9zdF9kaXNhYmxlX25vdGlmeSgmbmV0LT5kZXYsIHZx
KTsNCj4+Pj4gKyBjb250aW51ZTsNCj4+Pj4gKyB9DQo+Pj4+IGJyZWFrOw0KPj4+PiB9DQo+PiAN
Cj4+IFNlZSBteSBjb21tZW50IGJlbG93LCBidXQgaG93IGFib3V0IHNvbWV0aGluZyBsaWtlIHRo
aXM/DQo+PiBpZiAoaGVhZCA9PSB2cS0+bnVtKSB7DQo+PiAvKiBGbHVzaCBiYXRjaGVkIHBhY2tl
dHMgYmVmb3JlIGVuYWJsaW5nDQo+PiAqIHZpcnRxdWV1ZSBub3RpZmljYXRpb24gdG8gcmVkdWNl
DQo+PiAqIHVubmVjZXNzYXJ5IHZpcnRxdWV1ZSBraWNrcy4NCj4+ICovDQo+PiB2aG9zdF90eF9i
YXRjaChuZXQsIG52cSwgc29jaywgJm1zZyk7DQo+PiBpZiAodW5saWtlbHkoYnVzeWxvb3BfaW50
cikpDQo+PiAvKiBJZiBpbnRlcnJ1cHRlZCB3aGlsZSBkb2luZyBidXN5IHBvbGxpbmcsDQo+PiAq
IHJlcXVldWUgdGhlIGhhbmRsZXIgdG8gYmUgZmFpciBoYW5kbGVfcngNCj4+ICogYXMgd2VsbCBh
cyBvdGhlciB0YXNrcyB3YWl0aW5nIG9uIGNwdS4NCj4+ICovDQo+PiB2aG9zdF9wb2xsX3F1ZXVl
KCZ2cS0+cG9sbCk7DQo+PiBlbHNlDQo+PiAvKiBBbGwgb2Ygb3VyIHdvcmsgaGFzIGJlZW4gY29t
cGxldGVkOw0KPj4gKiBob3dldmVyLCBiZWZvcmUgbGVhdmluZyB0aGUgVFggaGFuZGxlciwNCj4+
ICogZG8gb25lIGxhc3QgY2hlY2sgZm9yIHdvcmssIGFuZCByZXF1ZXVlDQo+PiAqIGhhbmRsZXIg
aWYgbmVjZXNzYXJ5LiBJZiB0aGVyZSBpcyBubyB3b3JrLA0KPj4gKiBxdWV1ZSB3aWxsIGJlIHJl
ZW5hYmxlZC4NCj4+ICovDQo+PiB2aG9zdF9uZXRfYnVzeV9wb2xsX3RyeV9xdWV1ZShuZXQsIHZx
KTsNCj4gDQo+IA0KPiBJIG1lYW4gaXQncyBmdW5jdGlvbmFsbHkgZXF1aXZhbGVudCwgYnV0IHZo
b3N0X25ldF9idXN5X3BvbGxfdHJ5X3F1ZXVlIA0KPiBjaGVja3MgdGhlIGF2YWlsIHJpbmcgYWdh
aW4gYW5kIHdlIGp1c3QgY2hlY2tlZCBpdC4NCj4gV2h5IGlzIHRoaXMgYSBnb29kIGlkZWE/DQo+
IFRoaXMgaGFwcGVucyBvbiBnb29kIHBhdGggc28gSSBkaXNsaWtlIHVubmVjZXNzYXJ5IHdvcmsg
bGlrZSB0aGlzLg0KDQpGb3IgdGhlIHNha2Ugb2YgZGlzY3Vzc2lvbiwgbGV04oCZcyBzYXkgdmhv
c3RfdHhfYmF0Y2ggYW5kIHRoZQ0Kc2VuZG1zZyB3aXRoaW4gdG9vayAxIGZ1bGwgc2Vjb25kIHRv
IGNvbXBsZXRlLiBBIGxvdCBjb3VsZCBwb3RlbnRpYWxseQ0KaGFwcGVuIGluIHRoYXQgYW1vdW50
IG9mIHRpbWUuIFNvIHN1cmUsIGNvbnRyb2wgcGF0aCB3aXNlIGl0IGxvb2tzIGxpa2UNCndlIGp1
c3QgY2hlY2tlZCBpdCwgYnV0IHRpbWUgd2lzZSwgdGhhdCBjb3VsZCBoYXZlIGJlZW4gYWdlcyBh
Z28uDQoNCj4gDQo+IA0KPj4gYnJlYWs7DQo+PiB9DQo+PiANCj4+IA0KPj4+PiANCj4+Pj4gQEAg
LTgzOSwyMiArODQ3LDcgQEAgc3RhdGljIHZvaWQgaGFuZGxlX3R4X2NvcHkoc3RydWN0IHZob3N0
X25ldCAqbmV0LCBzdHJ1Y3Qgc29ja2V0ICpzb2NrKQ0KPj4+PiArK252cS0+ZG9uZV9pZHg7DQo+
Pj4+IH0gd2hpbGUgKGxpa2VseSghdmhvc3RfZXhjZWVkc193ZWlnaHQodnEsICsrc2VudF9wa3Rz
LCB0b3RhbF9sZW4pKSk7DQo+Pj4+IA0KPj4+PiAtIC8qIEtpY2tzIGFyZSBzdGlsbCBkaXNhYmxl
ZCwgZGlzcGF0Y2ggYW55IHJlbWFpbmluZyBiYXRjaGVkIG1zZ3MuICovDQo+Pj4+IHZob3N0X3R4
X2JhdGNoKG5ldCwgbnZxLCBzb2NrLCAmbXNnKTsNCj4+Pj4gLQ0KPj4+PiAtIGlmICh1bmxpa2Vs
eShidXN5bG9vcF9pbnRyKSkNCj4+Pj4gLSAvKiBJZiBpbnRlcnJ1cHRlZCB3aGlsZSBkb2luZyBi
dXN5IHBvbGxpbmcsIHJlcXVldWUgdGhlDQo+Pj4+IC0gKiBoYW5kbGVyIHRvIGJlIGZhaXIgaGFu
ZGxlX3J4IGFzIHdlbGwgYXMgb3RoZXIgdGFza3MNCj4+Pj4gLSAqIHdhaXRpbmcgb24gY3B1Lg0K
Pj4+PiAtICovDQo+Pj4+IC0gdmhvc3RfcG9sbF9xdWV1ZSgmdnEtPnBvbGwpOw0KPj4+PiAtIGVs
c2UNCj4+Pj4gLSAvKiBBbGwgb2Ygb3VyIHdvcmsgaGFzIGJlZW4gY29tcGxldGVkOyBob3dldmVy
LCBiZWZvcmUNCj4+Pj4gLSAqIGxlYXZpbmcgdGhlIFRYIGhhbmRsZXIsIGRvIG9uZSBsYXN0IGNo
ZWNrIGZvciB3b3JrLA0KPj4+PiAtICogYW5kIHJlcXVldWUgaGFuZGxlciBpZiBuZWNlc3Nhcnku
IElmIHRoZXJlIGlzIG5vIHdvcmssDQo+Pj4+IC0gKiBxdWV1ZSB3aWxsIGJlIHJlZW5hYmxlZC4N
Cj4+Pj4gLSAqLw0KPj4+PiAtIHZob3N0X25ldF9idXN5X3BvbGxfdHJ5X3F1ZXVlKG5ldCwgdnEp
Ow0KPj4gDQo+PiBOb3RlOiB0aGUgdXNlIG9mIHZob3N0X25ldF9idXN5X3BvbGxfdHJ5X3F1ZXVl
IHdhcyBpbnRlbnRpb25hbCBpbiBteQ0KPj4gcGF0Y2ggYXMgaXQgd2FzIGNoZWNraW5nIHRvIHNl
ZSBib3RoIGNvbmRpdGlvbmFscy4NCj4+IA0KPj4gQ2FuIHdlIHNpbXBseSBob2lzdCBteSBsb2dp
YyB1cCBpbnN0ZWFkPw0KPj4gDQo+Pj4+IH0NCj4+Pj4gDQo+Pj4+IHN0YXRpYyB2b2lkIGhhbmRs
ZV90eF96ZXJvY29weShzdHJ1Y3Qgdmhvc3RfbmV0ICpuZXQsIHN0cnVjdCBzb2NrZXQgKnNvY2sp
DQo+Pj4+IC0tIA0KPj4+PiAyLjM0LjENCj4+PiANCj4+IA0KPj4gVGVzdGVkLWJ5OiBKb24gS29o
bGVyIDxqb25AbnV0YW5peC5jb20gPG1haWx0bzpqb25AbnV0YW5peC5jb20+Pg0KPj4gDQo+PiBU
cmllZCB0aGlzIG91dCBvbiBhIDYuMTYgaG9zdCAvIGd1ZXN0IHRoYXQgbG9ja2VkIHVwIHdpdGgg
aW90bGIgbWlzcyBsb29wLA0KPj4gYXBwbGllZCB0aGlzIHBhdGNoIGFuZCBhbGwgd2FzIHdlbGwu
DQo+IA0KDQo=

