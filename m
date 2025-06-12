Return-Path: <kvm+bounces-49214-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DB4DAD65B9
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 04:30:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E581F3AB57E
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 02:30:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC8F41EEA54;
	Thu, 12 Jun 2025 02:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HDj8HzL0";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="yYMu2djy"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4690D1E5711;
	Thu, 12 Jun 2025 02:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749695414; cv=fail; b=La89uP8ZZMB+Ap4u01s0n2h5bS644Md1Y+Bqzpo/enfba5HCH6S8xVkxBaA49s1LFZgBoUM0MO9xzfJlXX9rMI9oR+XlNNaePtzGKGlC1alZiI2v+iTTgvVoj9RoHSiwxHRwv4S769lS+lcu++8RSN0vQvdyqEGjsjUJzkBFMRc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749695414; c=relaxed/simple;
	bh=vYCEi1ZDFX1xtVHXwm8xrzhYPo47hI75rL17uPgfV9A=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gmOIPo8Ua9iXvuJrZZawWhIBhy+cx+xABjo9XYXlG3q1axxf5/VBIu9sbotGVlWBmOpra5bm3omoBkbOuEI77QdgPbXU/cbg/15VDf6QrGBW5QuwCVRTMzYMMfdIi0odj4v9QjBr3GX3fhu5/dp1S65TBpuq8PI7oqfd2T4M3gc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HDj8HzL0; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=yYMu2djy; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55BMPLn1007353;
	Thu, 12 Jun 2025 02:30:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=rjD/4PYEr9kzOvdxD9rHKO1PHrMfGjkZNmLX/ILEIsA=; b=
	HDj8HzL0rVO9hulBbOP530bI7HH/i89fo+NIOd15ItgGbLzyU3QyiwE8+3e3rWWY
	aZWy7mhcBf/9ET6wxRbJ4Ca2SIaraQAsDoIKfgWgJIrWup4Ss0KkpJ9bE7A7cc2X
	raOuyMQse9MNTYndi31o3RnRDjqnzCCmiNtaT2WlDzoxhgfj9MKf+Cu1wJFNOJkC
	8ftbEoSYnOU7ghJ7S+xqcORxxOmIR5mZ9nIkmpNifmyOVsKbarT/BtQdv0qyFjb/
	0OFTAnF5+wsJ/g+JzAEqUhBtwHV0rnMujCXJOHhVp+EtSjO1YFvbd+cKrrg9nt9Q
	qEyCAxfx92mVz8mNVc1dEg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 474buf8rrn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Jun 2025 02:30:06 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55C0F4DI007733;
	Thu, 12 Jun 2025 02:30:05 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10on2051.outbound.protection.outlook.com [40.107.94.51])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 474bvarn8a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Jun 2025 02:30:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M5Hr+XNmGVBmSpOg1xSuRptwYpK34iXAEjMKCS5n0+S703kyAgCNH/MCKFX79Qy5EtM50pT7UZS4ZMOtuPwgWSShCPriEpLOX7V9iWpvApnUSdFFlrul3VNVdNa0Y1Oip4N5olrYRNyGQcDBk5Wj4j96Fo+7VCjlkedTmPZfzuyCxdtg4KvrAC/1h4ElE94m/WhNEB3dYUlnWFt7sVZumBG2oC6oVqfYfiEntr0pOwTrry2Pgzcl8exICHoY4jeJ0WxGsnNPxX3BTNkMabZsuEm4V4l1d/JPTCN+wsly2maLDCpW+v0eL6EWpbIvKEAUlVQLfGtIoS0ZyrqVrz9yOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rjD/4PYEr9kzOvdxD9rHKO1PHrMfGjkZNmLX/ILEIsA=;
 b=akkamimYmARRhSIRbENVs4c5H1msPsE+53Zdk32zV6Qsb6oEqfhu4GKJOFNG0H6G2DxJL79KIwMqRXG8zfU9yyGZDAm6RLhD26ZYBeHgkFVvNttt+O6jiqq54YaBSfyM0A15fHCGGCgpnpCLzaBfdpdv5CCorqP548VwNOvMLXmBqc50CHxOJu5vbgJsZXzuHaIzLUYHi5Ps7/elHmUlSJb2E/2aM3PrG+6TI6oAk+dwZyWx4fufMTCKmNqY+m4oLPhCTUkJ/Il30T1On2xhkRpXW+ih09oEzeMWplV25BuX/bs4wlzVgZp0HFxCEWe0spLm99F3jr0RVxptEvmBSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rjD/4PYEr9kzOvdxD9rHKO1PHrMfGjkZNmLX/ILEIsA=;
 b=yYMu2djyr/SNgpq+YwlR1/2tMLXIitT18H3bwTywuB/y0gEe5uvCuNspxVetRsObFptFTuFm1f8uG7oEB+ahlUVbpx73wVNNmjVuu3x7wTmkQGOKCgn0BxOMiby9PFuKz8CfEs1DuUy3vOQvr7q8v9NPNk9qJwr0vEjgCvyPxys=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by LV3PR10MB8105.namprd10.prod.outlook.com (2603:10b6:408:28d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.35; Thu, 12 Jun
 2025 02:30:03 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%4]) with mapi id 15.20.8813.024; Thu, 12 Jun 2025
 02:30:03 +0000
Message-ID: <9273cb5b-08d1-44b0-8365-b624ded633c4@oracle.com>
Date: Wed, 11 Jun 2025 21:30:01 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] vhost-scsi: Fix typos and formatting in comments and
 logs
To: Alok Tiwari <alok.a.tiwari@oracle.com>, mst@redhat.com,
        jasowang@redhat.com, pbonzini@redhat.com, stefanha@redhat.com,
        eperezma@redhat.com, virtualization@lists.linux.dev,
        kvm@vger.kernel.org
Cc: darren.kenny@oracle.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20250611143932.2443796-1-alok.a.tiwari@oracle.com>
Content-Language: en-US
From: michael.christie@oracle.com
In-Reply-To: <20250611143932.2443796-1-alok.a.tiwari@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0035.namprd03.prod.outlook.com
 (2603:10b6:5:3b5::10) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|LV3PR10MB8105:EE_
X-MS-Office365-Filtering-Correlation-Id: e2de7ae2-c469-424a-ca88-08dda959095f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Z0crNFFSQWIvYzBLMzFUMzhzdnFYR3FHNUZmcFpyeEhRaUIwYkd6b0E2S2FD?=
 =?utf-8?B?NUREZ3dBcmZuNWR3MDJJelJYN0kyOU5HQmMyZjdNVHloUURiNC80M0xYYW5F?=
 =?utf-8?B?YjBVWGdpR2lrNEtsbk5TeFQ0a1U5RHQxTXRtbmk2M1E0M00xZGxkeWtPQyt6?=
 =?utf-8?B?c2tMci9hRTI5QmxNUzdEWEFUeE95elhhSExTQmVrSU1yWllDdUE3ZDR0TXhk?=
 =?utf-8?B?anMxaHJOcStzZkZaR2F5MGp2bzFNclNSbnRKWUl4d1M1TnhtZGZjcUdIbGRB?=
 =?utf-8?B?VTZZVVY5M3orNzRKbEpEQVo2cStZd04xdytkbHNZbWhPaGlpZENkZnRnbklP?=
 =?utf-8?B?MXFHblpzZi92ek5qNGZ0UlQrZmhBenA4OHNuWHFUekQvd2lBNW1qYlpiK3lm?=
 =?utf-8?B?blU2cUVrbFZ6elhKSUhzd2RVR2tWTDMwcDgxRitEOUFrZGM0OCsxN3JITWRk?=
 =?utf-8?B?OFNreldlTjNwTGZGc1BLU2RqMVAzM011SnowTDYrbE5IR3BBaDV0QmtTTVJQ?=
 =?utf-8?B?ZHN1bWc3RDNtTTI1ZTFjSGY5aTArVllZYldFeGpuRjhmeVhoQlhwdUZTV0pj?=
 =?utf-8?B?amxVODkyYkhrQ0tLYTV5MGo5MVUvUmJXZW5yd3RNUklUampQanJ0YkxQdjdO?=
 =?utf-8?B?YnRNTWUzajZNM0tHUG4vaHplVW1iZjcxMk94TlBiSmNMSDJnQm5NYXlJbXVB?=
 =?utf-8?B?NzlMcXNKN3ZHc044SjhWaUllQkp6d3N2Y0MvVWMrWmgzOS9SblJETWIwRVRi?=
 =?utf-8?B?Z2RQWmtheEdha1VBazlCc2FRSi9palZXOFBWSldIZmp3a0FmbUJJTUI0aGpw?=
 =?utf-8?B?MHU4U29JK05UUWRSYytIdkNENFFSdWlsT2VRZWJLOVlUMVoxSGVVVUgyTWJJ?=
 =?utf-8?B?YktNQ0JYTVYyRHdtc0JCYXFGaUNPTmpXN1RSdjV0ZDRaWWtBdGhwK0NDRlhY?=
 =?utf-8?B?Z1E5d3FCME11alkzcExRYms2dUpaaEZWNWNWc3NvMjhuRnBpTFZ2Q3lRZXJO?=
 =?utf-8?B?SS93NURrd3RFZW53V1NiSElVKytRSHJpVUlnazNkQUNJakpqUUkyRVhGRmor?=
 =?utf-8?B?SEl5TGJlM3k1NDJOUWFJL2ExdVpEMzdnR2l6ZllCcEZNTHF2cHp6RmxFTXNJ?=
 =?utf-8?B?L3hnUFpsa3VpbElaK05ic1VVZndpaXlOdEhIaVRtU2xXcUFBcjE5OHRRdEY3?=
 =?utf-8?B?akhsR3UycGNqc0xCaitCODYzQTAxaVRRckJqYjQ1MHFWM0ZXamM4cmxwMkRG?=
 =?utf-8?B?ZG50ZjFBUElIMHd1bE5GVTZrOVRWWTZQeG9hSUJQZUl5b0dIdHRUNWxKbUYv?=
 =?utf-8?B?OVhuVXo5ZHJvR2dGOVpaMXJRL2xDc0pMZjVQWU4zTjIrOFY5V1llNHFBbkJV?=
 =?utf-8?B?OStsV2tNRmhuUW05Y05VcDAreUwwQkFQNitXZ1VsdmlmbmtQb004bWpYV1lQ?=
 =?utf-8?B?NHZBNk5tcWtjTTg2QU11bU5ONVQ4M3F1NVNBTCt0V0ZYcE14SFJEY1BObzZM?=
 =?utf-8?B?MWM1bVB0eDAvOXpwKzdhNnB3bnhDMkM3UkhSSVJ4dGpBWWVvL2xwdXBSak5B?=
 =?utf-8?B?bzRRVEVmaVNxRG1uQXRJMVdZVjJTNnRKOXhwVGFNOGhSeGdseFNMSFcwTmR3?=
 =?utf-8?B?ZFYvNW9CSm5qVjQ1K3poUStYdGQrdnYwY2txQTg2OXlNZmN0OGJlWHd6TllE?=
 =?utf-8?B?QVZqRVg0YmV5bnBSWmExZk0xT2VncGxwT1QrczR0aUZMcGQybVFwbXQ4ei9z?=
 =?utf-8?B?VmM2eHl5ekRWQzlHWGFudWNmTExYUGNYcHR0cU5vaXZwY1JoVUw3NFpDTVdz?=
 =?utf-8?B?cFdpWFprK0poNFg2RkVla0ZmZnUvVnd6R01tWlFXSTduME9zNGUrclUveEE3?=
 =?utf-8?B?VkFQaFUxVTFiYkd6QitkVFM1bDVsN2l2ZDN2aVplcmJqTWc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QWhZaFlvYWZmOFpVSkdtSW1qNVhVWjR6aEFMT2duZGNTcVFmN0ZoeXBQSUF0?=
 =?utf-8?B?ZHNwdnhlK3ZmaDFiazB6T29ZaHE3V0hxNnpIL0U3eThQVkZuYXFEQ1p5bHNv?=
 =?utf-8?B?Sk9Wd08vMEpRbVV2SDhicUVjREtZelNlUEhxZUxUcDh3bzhWUjNvc3ZieW9S?=
 =?utf-8?B?VmpaWDQrTXBoM3U2aS9VNE9wM2MrUWE4VEhWS2srbFhJQW1oTnZIWGthNzRv?=
 =?utf-8?B?eHhieW1PSlRIUkJRUEpTVmUwZ2lBNkpnN084SFk3eHZEMnZFaDlpbmFYc2dU?=
 =?utf-8?B?aysrVy9XVUZPZXVwMDhQQzNnRDZCb3hSL1BnVDlNQnVINE5xWE5ISVEybGJu?=
 =?utf-8?B?ZXRNVlZvZWJzcHBoVDZpTS9pQk9PMnJkTGhzU2E3dE11Wmo0OGdGaFQ4QmRX?=
 =?utf-8?B?cEFCMlMyQk45YU9ScVFxbmxhRHorL3g2Y3VwSUh1clZOL1liM1NRbGhuckRQ?=
 =?utf-8?B?bHh2WDlIKzU1NTJwdUdOMDRDem9FTHlYdTJ1a0Z6THBvOThrbjcyTjROcDVv?=
 =?utf-8?B?MUx6dGhzY29BZm01dGl1eWg4VmhHM2RqUWVDcjZFNzNWVHE5ajJQMGV6cTFx?=
 =?utf-8?B?VUprQTF2aXRPRGp5OUg0bnBIaUxhekRQakw5cGJIeDR1citwSEdlbW9PSk5u?=
 =?utf-8?B?N3F1RDlJN2R4d2h4YUtYZi9uRE90WGVSTXNWWjVKNE9Cc1lmQU02RDJXamxz?=
 =?utf-8?B?S29OUkZpWmprQjcxRXNwUlAyV2JGbEx1SDdkU2lpMUFubXlmbjd4eDNETmpF?=
 =?utf-8?B?blg2TlZqZ0VyWDZQSG81ajRyK1grVGorV01QVmVmODZ4S05TcHRoUGg4Y25q?=
 =?utf-8?B?T3ZaaEZrd0VrZE1TL0lHWTBkR2ZxT2VTWS9mWk9IVFJaLy9TOHo1Znp6cmdm?=
 =?utf-8?B?eHBsamRodDJWOGRsWjVzNWxiWWNicWFSejJ0N2lKOFRiRHVlNmo0b296Tm1a?=
 =?utf-8?B?bEYvRTBUaGhkWFFySDlmS1Vhb0dnc3JpZGJSdUk2RDdrbG1DY2lia3dLQ3Bi?=
 =?utf-8?B?NVdSMXJRTHNHSEZab09uZUJjdzlqR2s5b0pvZHdVL2tGMWdobGV3d0JYemQw?=
 =?utf-8?B?VGFaRmNYZnhGbzUrSFRNTHpENnFQSTJ0TTJrczZtSGVuRFNKNUVDSk1iQnBW?=
 =?utf-8?B?R2N6bjZ6QUYxYWhqMjN2RmswdGZ2SkJrYVFYSG82VkFFNmc2aEFTQ1RnKzhJ?=
 =?utf-8?B?M2ZQU2tpMDZuUUY4b1pta3RVeEwreHpnUjV1OEgxZUNMb1RLTktDVTNWQ0VI?=
 =?utf-8?B?MFgzSmJnTVpCbUFuV3lWNGFwV3ByeGtrUVkzUUlPbDRZWXpVTzB6ZkVUOXg0?=
 =?utf-8?B?blVnODR6dHNNTlgwVVN1Mm02djdSdmZZYURoaVl2T2U1OGpDdGU2bzNrajd0?=
 =?utf-8?B?V0lmMVVyT29mcWd1T0k2NzZxY2JXQTFGcHcyRFdNb1gwYldUL3NzRHdUbElQ?=
 =?utf-8?B?R2VFeXErOEh3bGVtRlBSc0hIMVJKaXlEL0FiN2x4YWUzRUJ2cmt2eFF4eHNw?=
 =?utf-8?B?Zk5sWnR6dFgzbG5MN0d3am1zam1sYzFZakNSYXhrSEM0c2Nka0lsM21pUDhY?=
 =?utf-8?B?b1JKS3pQcjFyYXZacjdjUGRsRmluQVRUT1o5eTlaUCtma2lEdjdZcXBWeXYz?=
 =?utf-8?B?cE9wMlJKNDZqRGY3QjVUOGd6M2NlUEEzYXlYaDQxTmdoYUV2anc2ajVVR0gv?=
 =?utf-8?B?RExJNTU2MWxINlhqd0lQUFZtdTg2NnNLZGJmSy9OOU0wOXRibC9sdkk0WFRW?=
 =?utf-8?B?K0lTbDVBajJrUkJTSEI3Nm1rL2JRVjVFbGtmMEluekdxcG1vMmVodVE4T21R?=
 =?utf-8?B?cHRpbmV2b0ZDVjl4RS82WHlTTTZCS2dITHJRQ1Iya282RnNtbUxLY2VpeFZS?=
 =?utf-8?B?OS9wb09YMGp3R0I0NlptZDY3aStCcnRqZ3RiVnA4MWs5SWxJeFRvazkwTVQ3?=
 =?utf-8?B?Y2p6WmJTMGppc3cvMENpYTZmeDRQYlIzVklSYU1YbHZkUzZRaVdoSEVnME50?=
 =?utf-8?B?QkNaYmV3MmZkZDE1ZDVCOS9pS2lOa0ZLY1J2am40b3RuT3ZHV1RzMXhVU1A0?=
 =?utf-8?B?MnJRaEl5c2dGNmFDZDVYeFJ0dXYzRk9qNnFpMnhCbC9uZzRzUS90Njd5MWE4?=
 =?utf-8?B?aCswVHpseWY3alk4THM5dklKM045dGVKQnJPMzBvNXFUQ3c0MDA2cVB5dEh0?=
 =?utf-8?B?elE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ShVoTEOYGnm2y1Mrk/xMiHW2hs9ZT30Q2kiBAJtQmnUHcG/9QPvFnbebFjXBwbn4VYzcdvEEYmSb2sbqlBBrVQjDjsiEuZ5PeVQLBNkFzEzRxHsXlTjpvTVffLmpr81cmqMklT0ARQ04tdszQ6e4/pNVKWz7fuvf7fcNJO0XliBqgxKYqXcsVGeDMze2nQVFaNQTJ1SY9u+Be8Fk4mjVvNCzU3hR/3g6FCdyk4Hn57ivlvGsqJe0isDCRnlH+UT1eYiKpzFNjUKc+uQR3xI2qzHNtQGjpLsxFPD2i846imIX1ksWl6GIQcVwBh7ymvogokGK4VeyIJLymed5w2YYDP60q6142G/xoGZvYlpdVceq7w1AsrkJBX1aYwz6Az88yGNvkdaNq1XQMPrehbBQA1lOKkWrDJL+5gnRGQTs8CTyUCKgTbWgFbnWoL5c0zCrKthb/TqE8eF8ucTt348cAwW1dZa7Q8X196oYupIktPNv7VQ5dxCJDQzZJwGHLVRyS41wzBHREHZ6EHQZ83GfvuhmaVtyp9yP0b9e1OubHoXaDYmtq01qU1XkPL6v/iPm2788rBb0c1LKphQ7P9UhF2hpkDV85ky2a71wI87Qwk8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2de7ae2-c469-424a-ca88-08dda959095f
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2025 02:30:03.2968
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uZxmN6G0xp7YNVvm8CQ9bffXF+VEMlAnHPlnM2XxhrbXBA7Ua3lxtpt5uCKAIPIczIJEmha/SHUDiL/8GrFgk1Oq3+jFI9mgRS65e+k2vUY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB8105
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-12_01,2025-06-10_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 malwarescore=0 suspectscore=0 spamscore=0 mlxscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506120018
X-Authority-Analysis: v=2.4 cv=RZGQC0tv c=1 sm=1 tr=0 ts=684a3bae cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=I9PaQzWEsBH9tE0XwhEA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: F-rSUSOZvjcHvVhoyU8qO0eI4jCGEFRH
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjEyMDAxOCBTYWx0ZWRfX6wTDz16rz+3V A6Xpyu1/IawMBbtLdGUVIFSiGjCnz4kKd+GVVN16Pzl3s0goYyFSYx1LHSEO30Jzc8tKiVhexfx zSmRnYh9DkHCM1H1kp8srhSrDhDZVAjoFpmZnpc4ywFu+cLMnp1U5HP8Nnw5nFxycJhna/FausO
 6d/IXY52O4gGhmEzhKqw6IiwtNJPDlmYnB4lkeIHw589i2xMHGDGq7JoOiKjJAPg20oirMcZwLB lsEUzeVKcgCmfvWYje3m5JHy+4PHP7BSTAdwMBfekWBS6RHjbE1by/TYTvJvlJYSVJll4ALGmRn QAXxHgY+STLaDpawmtyFaK8P7u1OEuajV/eKRGBN82W0pkbtopAndJttvIKjL8K9edToaO31uk7
 ULBZ1XuTXO2GQ7a20s7LPxCxelhGNNnosEfa6O5hr6iiJbmpHjJNvhoNtV67huhiyUhJiwb6
X-Proofpoint-ORIG-GUID: F-rSUSOZvjcHvVhoyU8qO0eI4jCGEFRH

On 6/11/25 9:39 AM, Alok Tiwari wrote:
> This patch corrects several minor typos and formatting issues.
> Changes include:
> 
> Fixing misspellings like in comments
> - "explict" -> "explicit"
> - "infight" -> "inflight",
> - "with generate" -> "will generate"
> 
> formatting in logs
> - Correcting log formatting specifier from "%dd" to "%d"
> - Adding a missing space in the sysfs emit string to prevent
>   misinterpreted output like "X86_64on ". changing to "X86_64 on "
> - Cleaning up stray semicolons in struct definition endings
> 
> These changes improve code readability and consistency.
> no functionality changes.
> 
> Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>

Reviewed-by: Mike Christie <michael.christie@oracle.com>

