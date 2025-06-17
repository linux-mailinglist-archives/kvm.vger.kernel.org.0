Return-Path: <kvm+bounces-49759-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 18BACADDCD5
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 22:01:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 886403A4951
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 20:01:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7E8A2F270E;
	Tue, 17 Jun 2025 20:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Fp8FaHjM";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="RgYaBYvm"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58DF82EE99C;
	Tue, 17 Jun 2025 20:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750190488; cv=fail; b=gOkhraBYgDG1Hv+/nIDHeq9ULcHCKciyC9m9/jnLFGUi0QgMx2XZjUl3z8Oxa46h5ucbcTuskS7OeccEGyIKmxbUxRYrXueAzlqKdFIDIfhJZWJZbgvPBwQP4MnZZG6LrXXhW/E/s3BEbl91Z5dRqdwsBHhdRtCKGfcKfIfWYxo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750190488; c=relaxed/simple;
	bh=G4dLIh8WsQ88Jp+t9C6uAQozUbJRlLvqBUaBiQM219c=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=eeoiQi5vXO475iZe5uabwUdkSSRkFzpqaJ2DsX2anJW+qcU5Uv8xxifnp2ql+83nSWBa6Fg4mTW7PYs1y/qUS1ctueWRUzvrysbBKarsHUHr+AU7bZ2mhDycKpfJe5C4JwJXa4VKZV1CYYUhMKsGuZ/ouQpR1w2qYHr0U3gPoww=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Fp8FaHjM; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=RgYaBYvm; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55HHtd42024644;
	Tue, 17 Jun 2025 20:01:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=/rCFTB+LcqoNLbzWFjeEI/wiu1j19wfaZTXZkO/GMgk=; b=
	Fp8FaHjMzbNaa9VhRQaYesGCxCBvfHSrIZ3VjT7+BF29vi9OpnkzbwCWNGiIwK37
	dxNew2q1vX+nfOA/6H+YfUxvIxU3/FhApLr8QNYOj9xXvFWETfV0lIPvCOuiL6I0
	0UUTjmVv7nAWcOmbBg5pcaAF9qILMeDusZWhl609ZKSDVSOpX4AiFKehf2GMyTHC
	xfa3LDftleko/WsnIXzue2EBCpSmk+yl0XAVe+53/kZK+ZshiXGPibnUwL9LWRKy
	rRAWPqQqCX4gmmPIP1MCpQ+Y/2X4AdKG32owoRzaAAjXCS2C8KywDHdcvNvpNB8B
	C/KDgTOYfgkIsdCkabNKpQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47900excyf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Jun 2025 20:01:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55HJKTfh031654;
	Tue, 17 Jun 2025 20:01:19 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11on2077.outbound.protection.outlook.com [40.107.220.77])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 478yh9fmre-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Jun 2025 20:01:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PW8g3kvxXfBgzB16jPHy6uNc0rDFAL4u+WKEAGMlGzzneN49P+IK8IDwyPjq6brQMAuXn1PVAPEgER/dYU8ypElrBeQgPopLvBP9dMvN9stDHxzrfYqz5OuS382SsU/1iCqRTn5pNZ0Bscz4NPiYTzV99aImPAu58VXY5uIdETZFUPdlVBPR1XyzYsbmAlLUL9sM8Vfib8hmB3V+68u3YTOMqnD/MPX2WoIKYggjuG8rsJJyYYYxPdxJGg+mCKOyj61Bj4ND3lrgVUMyOKk85Ys6KW+nyalSJlN0ISsTD8uq1tsnZehsyEQEuEskLpGaFIbMBtT0HZezKB2coIjI8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/rCFTB+LcqoNLbzWFjeEI/wiu1j19wfaZTXZkO/GMgk=;
 b=K2zMNks8ZkTG3u3FXh7AtTXngK9IMVOSJcpvV/xUCtVnV5gTfr+33QL5wout1VDxjkvzuFoj34RXSCR9BQOLqxi5TlJA5xGegz/UnINYPjCf3duP0ARsEN9+iVTYShD3s/cPdUZppXDtAY28jc4ta/KnMyCQo82hUTqyFyKlOehw/umW/EZnNmrhqupbnVV9zbv9J/+GgmxAwVVSmEqtTxBAUzY/cdF01VDPkdy5VDKLcB5acQN7jEChncJQqQbHVkSwrjaQ//A/QyBdqQTIJFAFL9IaMcKAlNNMv4hKEJpAhh25qiY6SOeHzChTuElAD7I94msv2wCQPwvVV5VPug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/rCFTB+LcqoNLbzWFjeEI/wiu1j19wfaZTXZkO/GMgk=;
 b=RgYaBYvmPUe4/WGbyj3Op/Da6mhOaSv5d1r2WcyuR6kvK54taIvXk29Wl4U7JCGuuw02fVUdcRNP7D0qC5R43spBEazRKjSxgXiIS3uwXwJaXpXZvVE5uxE7RmQP5WSHjZFVIOPlx8cnxUqvCcQRu7g3iOa+64IsJGo31y5KFPQ=
Received: from DS7PR10MB5328.namprd10.prod.outlook.com (2603:10b6:5:3a6::12)
 by SJ5PPF73A72B96A.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7a8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.28; Tue, 17 Jun
 2025 20:01:16 +0000
Received: from DS7PR10MB5328.namprd10.prod.outlook.com
 ([fe80::ea13:c6c1:9956:b29c]) by DS7PR10MB5328.namprd10.prod.outlook.com
 ([fe80::ea13:c6c1:9956:b29c%2]) with mapi id 15.20.8835.027; Tue, 17 Jun 2025
 20:01:16 +0000
Message-ID: <eb95149b-89eb-437f-813d-0045635aee8b@oracle.com>
Date: Wed, 18 Jun 2025 01:31:09 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: Re: [PATCH] vhost: Fix typos in comments and clarity on alignof
 usage
To: Simon Horman <horms@kernel.org>
Cc: mst@redhat.com, jasowang@redhat.com, eperezma@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux.dev,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20250615173933.1610324-1-alok.a.tiwari@oracle.com>
 <20250617183741.GD2545@horms.kernel.org>
Content-Language: en-US
From: ALOK TIWARI <alok.a.tiwari@oracle.com>
In-Reply-To: <20250617183741.GD2545@horms.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR01CA0165.apcprd01.prod.exchangelabs.com
 (2603:1096:4:28::21) To DS7PR10MB5328.namprd10.prod.outlook.com
 (2603:10b6:5:3a6::12)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5328:EE_|SJ5PPF73A72B96A:EE_
X-MS-Office365-Filtering-Correlation-Id: 1df1e515-7843-4946-9c6e-08ddadd9b7c0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?LzNJd281ZjZIMm5uWVljbEU4ODZzVGh5UldEczloQ2Zhb3NSWTl6L3V0cEQz?=
 =?utf-8?B?M3JlVVpKYVU1bzlWYk9WUDU3ZnBxOHc0eWpaalh3YnNjN21UNEQyWVp6TlYx?=
 =?utf-8?B?VEFnbkNNNzdMWEJaTGc2NHJIK3lTYzBldHZub0Q3UUhLbWV1SWJ1Z2ZILzhH?=
 =?utf-8?B?Sm9xdDlZc0lLVnh3SUdFcS83UjlacEZTcSsvckRuRzNMWC9DdkVTS3U4dDRk?=
 =?utf-8?B?UFlYSGJlOEt5QkdOcXB1MDZ4eGFqT1ZjZERtdHgrcWxTeTEwWlkyb2twdTBR?=
 =?utf-8?B?Uk5LRjRhMXlLV3ZFRDNlSlNSa0Rac1BtMlN1THFKcGpUendkdVRxM3JZSTNv?=
 =?utf-8?B?Wlo3SFdLcktrbVNOd3E0T1N3M2NndHZDUEx2U1hmMzNTcG5GMy9KcnE3bDVB?=
 =?utf-8?B?REE5SkhnUTRJUGhiLzQ0ZFlmUGk2d05ZenlZWWpwOC84WW9xaU9nSk9vLzBR?=
 =?utf-8?B?ZFJaQlVacnlKc2tlYTNUN2pNdXNoai8veFFyQ2pNS015aE5aUHlrSEZZVE94?=
 =?utf-8?B?SE9zYmNTeXJzV1Q2dFRkbzVBTzZaWkdZR1JwM1JMeWZybDR2cjFYSURwb1Ji?=
 =?utf-8?B?cFVsbHFMendYNldveHNFMkx5cU9rWithY2I2NmJzQ1FKQmxkRXBJUVI4aVpM?=
 =?utf-8?B?dmd0b0NubDUrT0UrTUVENjhRYnQyaXg2T24rdEpyNjN4SXRPajEwb1B4ZUJM?=
 =?utf-8?B?VVBiazZTWjQweFBYNzc4M1F2UzlUenYva3d4UW1wU09TSjI2cWZmaStBdjMv?=
 =?utf-8?B?KzZiOS8xcldhbk5LY3dkY0ZaQm1xRXI0aGJMOG9KTU12QmpXVmtOOXVyZ0hi?=
 =?utf-8?B?TEVpcjF3QmVmNU9YbktLOVZQQ1p0VElUR0ZNRTFOM0F0Unl5YnpQa09LaUtZ?=
 =?utf-8?B?d294UGowYVZ6V3Noa01KUHB4Ym4ycWNYcUJDU0UweWVKdUtqTW5kNkFIdUVn?=
 =?utf-8?B?UnVEQTdFRDFNRHp3U0UreHJXcGxZajRSdUxnZlFaSzNlK0tCVGc1bDR6MW1w?=
 =?utf-8?B?WllLOU56Y1NnbjJRZTUrUm0wYlNLQ1B4dTlDeFhZVUo0TnYzV0craEZmc3gy?=
 =?utf-8?B?Y1g0MzZ4UkZJTTdUa29FWmthTEJRUDh6NXFHWlh1NzJCSVJoT0p5NVp4Zkpt?=
 =?utf-8?B?RWVxNXRvSWIwYk0weFAvamUvSVpDZ2UzeTZKK1VTSFpvYUhBQkRISFRvU0RS?=
 =?utf-8?B?dnhYQnNEc2lCNHhKOGVNbUlSUmtzQktxWmV5RXkxL1h4VVN1aEloWktKbGt1?=
 =?utf-8?B?NjNPOHN0bXprRXh0V3phRXMvT2hGWGlQaHhHQXIzNEVVM01naXdXQnN0ZGw5?=
 =?utf-8?B?NHl5bmlvSDVFVEIraW1VOEFHaDRzdGFLYm1Da3ZvYzhLWDVxT25WQWd3MWVH?=
 =?utf-8?B?ZmluL25VVE5ZaE9xV3VGMVRiWHp6MURkclI4WkZKazZDTmtRWWJQQjV1OHE3?=
 =?utf-8?B?U21VdXJ4UWtNLzBXcmNVVHpKSEFOb2E4T3djaXUxOVVZdWY2Y2FNUGVtUXZ5?=
 =?utf-8?B?RjlTYXJXd2p3M1FGOFlOWWlCYno4VlpUbEdLMk54a2Jxek1VaitUMGQ5VlQ3?=
 =?utf-8?B?REZvTGZ3dS8wRXk0cUR4bFE2OHRtaVFsWkp5R3Q5cjlLMEhkd203YkQzeXFD?=
 =?utf-8?B?TVRORjZmQWVxQ1hVdUZBQTRYRzROUzBNdHpieVB0bnQvRWJ0S2RqNHdCd01y?=
 =?utf-8?B?QjJPcGNPckZNVTN5ZmhuQjZiK0NMaWVRUjhmN3czVW90M0JjcnVoNXdFNlox?=
 =?utf-8?B?bC9KSnRFZGdNRGlYVFRwUkRjT2UrYjdLYnZSVVhQRU1Bb25GRVY1dXBSa2Q2?=
 =?utf-8?B?RklKYnl2TEY5SkxBNTRHT2RHQjBNVmJzZExRNFFZZjdlaC96QTZtUnVVcEZV?=
 =?utf-8?B?c0djaWJ6cUhjenZZV0dWUHJzdUhtZUtYaDg2aDVoQ1ZUMzhRMG5KTDRqeVJD?=
 =?utf-8?Q?c1YjrA9KWz0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5328.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZllqdXBNNkpPZFZLNEJKR1lBL3ZVYjhaS0RFbU15K3NieGNReVB6aDlCK1d4?=
 =?utf-8?B?ck0vQTRKRFlVcjNPWDBVbzdEWVhmSlhWc3l4T2RpRUQ0ek4yYkhldlpZQXNi?=
 =?utf-8?B?RENZL1M1MFFIalYwaFdSM28vc21ESW1QTGh3cjkrZTdDVFoxODZ5VjRCRXJH?=
 =?utf-8?B?THV5MGUxcTA2WHo2dk5LWmdvaG00c3JoN3luQXdyUjhhejRSOGdpUkZaVkpB?=
 =?utf-8?B?SUdqRjZFRmlEZ3J3NmJvanZVRkh2RHNyaDJoUVZtb3F1aHRUUUdyaVdhNEN0?=
 =?utf-8?B?cDAxSmlPTkNZU3VMRHFOeVBwWWJhMWF1UHBlTTRUYys0ZEx2R0xONVhtT0FP?=
 =?utf-8?B?UVBPQWRWVFFsZk1IdEZUa1ROdTg2clYrRVlRU2thZWhQUlAvb25uS2Q1MFk5?=
 =?utf-8?B?Mm9ZVEV1MXFSSEUvNWszc3BENVIwdVVQRjgrQmpLTUMwTU5oN2dyN2xvdW1F?=
 =?utf-8?B?WGpGdzNMZllFNWNpbm9ad3c0NGFBZ3NaVDB1cXN6WFZmRDgxMTBuZGEvTERo?=
 =?utf-8?B?SXRsL3ZrNEc3VndSdXFicTd0amgrOU1OOSt1ekNpM2l0TmlRbDNYalBJeFMz?=
 =?utf-8?B?REI4c3lFekMwZjBNRGMxMFdxak9wYWxPdi9Ja3Jmd2R5WGJMUjFUNGgrQ2tr?=
 =?utf-8?B?aUphVlZrSnJlYllxTVV1alFWODRSSE1ZNzRxTnVJdWpnRytiR3IwU3dFSjI1?=
 =?utf-8?B?Ri9oaDMwZVZYUDF3ZVk3cUJQTkt6bEZ3ZUJrdkxLQ2hGdmZvdnRERmllVEQy?=
 =?utf-8?B?RmVHRHlKdm5IRG9ZdUY3dWI0ams1Y25FQmo1ZGVvRHNJaCswRitoc00rOVFr?=
 =?utf-8?B?ajBKQ2wybmpndlo2RllzWjluWjU0VUhJeGRuMUJ1bkM4RHIvWE5pcUdMejF4?=
 =?utf-8?B?akRwZzB5Q29rc0NzUmowaEVvOGFiZFQ5WjNvVnlkOGsvTWY3b3RxQkxTZ2Fq?=
 =?utf-8?B?eEtpRTZXa0lhd09lb2pNeXF1M0hhQzVJUzFranpBV3pwVDZ3U1ZMRWxFZ2V4?=
 =?utf-8?B?U3NldHh6SWZlWEFYOHIwVzdPajNSTllHZlpmQWNHQncyWTJYQmNuUEdDK2Jp?=
 =?utf-8?B?UTNmWkdhQzdybVgvUkR1bkhvaXFGTERQbzNvWDMreDlPaTlBb2pEL0s0RGsx?=
 =?utf-8?B?citzUmNMc3ptMThwYlA2TXlzNUE2Z1BLRlU1TVA5UHFFZjZlV3pla3lWUld6?=
 =?utf-8?B?TVFJeWg4MENKSVhaakNoR2FFUit6bXBXakVkN2RhRERjRnU2S0VzWEo2Y2Vm?=
 =?utf-8?B?SEwzelV4N0V0UGpFQjJWZXczZkQzWHByR2pjLzYzSklhcXBhMlRGdlpGbXd5?=
 =?utf-8?B?UXpBeFdSNDlWSXovNlRmMjVPT3F3alV2ektxSzk2N0ZseklaU2tucjBScmhJ?=
 =?utf-8?B?bkhpWEFpQkVKbHJDVW5UYnlPSjRmTk1KelJKeDhyWnVlZ21XSXVBb0JOd29C?=
 =?utf-8?B?Sy9aL3Rkd3FFNFlpNGd1UXc3ZDh6SCt1b2RheHhiU04wanhvVjJmeFcvdUg0?=
 =?utf-8?B?cytOYWZ2UFNTSkJuSXRiNjduUHczV0pwd05PNUpTaTFWbUZJVGcrRDJyT1A1?=
 =?utf-8?B?Z3M2amhtZFVaV1dvbHFqdnlIT0xjMVBiQ0hIbEpzakx5Q3FpODRMZFFnbkJz?=
 =?utf-8?B?R1RvZzhHYzVDSUE0d1FZWHk5cmZ3d1lOVHg4UmZicUp0ZTlIakNSejhZaHhF?=
 =?utf-8?B?WEh1bkFuZm5peWZvTFBEQW93WWEwM3RyTzM4bFpNZFJQVndyOXhEK0NsL0NL?=
 =?utf-8?B?aWdXYWtXY0M5ckNRTnJlWlVEUmtJaFA4QkZXclU0Rk1HamU0a1ZWd0hLUEFz?=
 =?utf-8?B?Z3NQaVFiT0J4UFdIc2Z1Vkp1d1Znd29mOWVJQmNSNmtNSjFadmQzbDNpUFZl?=
 =?utf-8?B?Njdad0wyblBvTXZDUE40YkdqTXd6Z2dZampzQUNBQ2JnUzlrRWtTTWJhVUVX?=
 =?utf-8?B?SEIxKzk4allybGl3WWVveFB6WXM2c1N6a0hEOGRnU0xJRFVweE1aVDc5Sisx?=
 =?utf-8?B?QmJqdWg3c2w2S3pjR2xRQ0g1TVd3aG53UDVtRnB5cEN4Zk83YnRVeEVTUnNi?=
 =?utf-8?B?L0J5and3VlVjSlpsSithdW56R041OEM0N3UxWm5TcHVwelFrdFZYV0N0eVJK?=
 =?utf-8?B?MWxha0lLaXUvL2EybmJwcXY4clR0bDAxd1hDMjBsQXdPc0wyOGlNSnhBU2NU?=
 =?utf-8?B?U3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	f+sGWuMafS3JKoNqko10f1Ai48fwkF9+AEKGZqTKEgJqaZVSumBjdcal9JIvEBaRu7GiF/aaUtHhsFeqNqMxzmXNZ2GxWgzXfH3EWi8+/JSaQqkRKHl7WWWQwZGLKCZkG+NqBcEL+OEsyN9U3tEXnqPd7WjWZ/P73bLIW9sZaK8/Au421xZqXFp0YRr7R29kW8qSaoKveUqYRRtYPXJ8CUYTpO9PrQHXj2YD2T2NaLRIjIwwXBP8woKBJ19afor5fg3a+lBdWEmbqMHbzEuG1ynkf5h1PPbjm9cfhMx0OLZGpsCn3IcnMNJFrobxhP5zaz/coQnH2MzrmWyLd/uxMpDr3WiiD3n4rTxOUKAKEI0dvEJgs1ASuQeZmCannPEYP0J2GROi+t5SjwlzHNjh/pfEXowJwdrDCd1NVFI7IBhdez6otXcoWLjUPpFplwK5Wvtx6Fu3w/Jefy9hKvQkiAIa5At0dbraMzQtDz5w61/2lSYn8L4R2MfhQNuljZfmLDKLJ5z0DXGzoP9HVzNkH3uY05jlqWyIt97JRkKSB6TxIlVYtRHQpe9dDo3lN/lhc2ygKQ3NDW1S2KLyqqhXWYK5cFD1XPTtV/P68qqxvUM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1df1e515-7843-4946-9c6e-08ddadd9b7c0
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5328.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2025 20:01:16.2611
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qPQCGtqkVEGJEwCg1b5VsU+pkIwoY5kGOdCfQeVJPHzpVoWoi/l0LXW2VK0FD+t8CTPrYcncG/29r2dzPczbWpFXjZJ/igrNpNJD8OY6wkc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF73A72B96A
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-17_09,2025-06-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 adultscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506170161
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjE3MDE2MSBTYWx0ZWRfX9A6t6ULF39Vm dT7WXrtCcF+SpXIB1Zpr4GfRaY6Mk2ZfUkGqNQtFpMMzarnEwKbDXyf2ITdfSO/jebaS64rXoFz LhOQknlBFz7jQrCDUa4U3a6w6SXdOIg3KS0Hedm5gPpQTSBGhxmxQ+96bpKCOPTpM0jUl1nDmTu
 nkRHIMiX6XCSv7ua+nMDN2RMEiP5oL6cIrdHFfKVNjTk32GImE8UqlkVajRT1oJ2XpAD7Pioq4v X7Ovd7YQxsRMU34h1ck9Ve7tAAdXg1+QP2wFXWile5NGjoE//iNVIjfPa2BKpRYm/bMTTMSL43i iqcLQkwO//fruAGYt+Rl2NP6Jvaakg3cpG12YtAlTdRWLsJubCzpwdrNhpqJPO89/vczomvCYDj
 elt4sG9eqxsLFH43Kx7R1JpLruGofUsLtEd8ZkOPtoKEtohMrz6DMQU68Xnvfqc5/dARIkXs
X-Proofpoint-ORIG-GUID: 5xxtaB7Y25Tlh6paME6WjSI5gs62eFA4
X-Authority-Analysis: v=2.4 cv=X/5SKHTe c=1 sm=1 tr=0 ts=6851c98f cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=h6eXi-EbCxgSsYo2:21 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=hM38cw34fj0ArJh6fKEA:9 a=QEXdDO2ut3YA:10 a=KpMAsf9diV4A:10 a=ftr0zfsHvHYA:10
X-Proofpoint-GUID: 5xxtaB7Y25Tlh6paME6WjSI5gs62eFA4



Thanks Simon,

On 6/18/2025 12:07 AM, Simon Horman wrote:
> On Sun, Jun 15, 2025 at 10:39:11AM -0700, Alok Tiwari wrote:
>> This patch fixes multiple typos and improves comment clarity across
>> vhost.c.
>> - Correct spelling errors: "thead" -> "thread", "RUNNUNG" -> "RUNNING"
>>    and "available".
>> - Improve comment by replacing informal comment ("Supersize me!")
>>    with a clear description.
>> - Use __alignof__ correctly on dereferenced pointer types for better
>>    readability and alignment with kernel documentation.
> Could you expand on the last point?
> I see that the patch uses __alignof__ with rather than without parentheses.
> But I don't follow how that corresponds with the comment above.

only I can say "__alignof__ *vq->avail" is valid C,
but it can hard to read and easy to misinterpret.
Without proper parentheses sometime, __alignof__ *vq->avail can be 
misleading to reader. it may not be immediately clear whether it refers 
to alignment of the pointer vq->avail or
alignment of the object it points to.
__alignof__(*vq->avail) adds parentheses that clarify the intention 
explicitly.
I can not see very clear guide line to using parentheses or not for 
__alignof__ in kernel document apart 
from(https://www.kernel.org/doc/html/latest/process/coding-style.html).
Additionally, I have not been able to locate examples in the kernel code 
where __alignof__ is used without parentheses.


Thanks,
Alok

