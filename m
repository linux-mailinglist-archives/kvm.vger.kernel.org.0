Return-Path: <kvm+bounces-24841-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BAEA495BCBC
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 19:06:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DF90BB23D99
	for <lists+kvm@lfdr.de>; Thu, 22 Aug 2024 17:03:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 603C41CDFD4;
	Thu, 22 Aug 2024 17:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="m/FB6ZFt";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="CJHTUzDE"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A92171CCEFB;
	Thu, 22 Aug 2024 17:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724346178; cv=fail; b=Geetb5Ahgfrf3nVuA8K3QT2S3wjxnn5PW2eUvVDVnmC/S8pB4FmW9B4Gjwg7DqxO9+97i1/tpwR/oWxmKujGfDxROLCEQJwlyfKhtB6j8zAcjLUV9pXDXhbQ1QFdUSlOpI7HnvlVzrZNxhBc7kBd1al+y65Mf7GtqYP9ggdt9VA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724346178; c=relaxed/simple;
	bh=KQ4Qq54WtuP07aw6sbc5gyRP/q/eC3EY6C9RgafnS70=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Pwisf1nVz5goIqMgbF/KvOwSSf4ZGplBq3EfUJrjVs8lqRhcAvXkcIiKh/9DJ3jH0nxcsnWgFRG9jeVpfPUW8xKQmG9P0oS7ULmFb4eyo2JxIIM4v6U7NNSIS7FMdqbnQpy5Yyi30n63xDkNoybga7J6yKSB7cHIjZfOYaTsxEc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=m/FB6ZFt; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=CJHTUzDE; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47MEQb6s008281;
	Thu, 22 Aug 2024 17:02:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	date:from:to:cc:subject:message-id:references:content-type
	:content-transfer-encoding:in-reply-to:mime-version; s=
	corp-2023-11-20; bh=BE3KYGhgpXVBBPSOYNWgGYdyaAFa9A9F6evta5ZQvkw=; b=
	m/FB6ZFtnZchjTJmRI5B8Z8zhxZFnzJzPvR6Hh9DUz+YJQoM1hL8PDRSMEtVOhoF
	McnPApGqcXALn/oM6lgVR0UVaXwfQiG3i/LxzBQYvIP0aY3cgxpXY3SJfegwipaU
	M6zhl+AvdJd+4MTSV63rdqWIaOXXZFd/V34xJEWKDt0/grsKuWGI0/z5MG2A2b7j
	NN4LP2XhCdbrMHtTBmufU4Ilw42yOxBqxb5i71V+foR3LGmjlNJ8xockj6KT62he
	M/hgYXcvzd+wZIDQ/uUtzPzQbFGtRp3bDLQE5XPHCPwT/6vEVBZyeEIvGtFKv2db
	WQ3b4OmmiZVkbgiIF63nLQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 412m4v2k22-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Aug 2024 17:02:32 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 47MGwxll018849;
	Thu, 22 Aug 2024 17:02:31 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2049.outbound.protection.outlook.com [104.47.56.49])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4169b4g7y7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Aug 2024 17:02:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y51lIor5FvRmhDQipf5wum44Ent6SPEw/5aMdGyuWYAnTt2nuY7R563CVbjJwNNXlCQLvyZMsFgJfUwnxckQOD1ZemOBPB5gDzjC1laHVOsIitOoUgTzkLCRwImfvBBRv6G32tdVwMt0dIs3Ey/FIlYInAIvIDTZvQWUEgTqvJ2EGBh5fzGwbGHjEl8FTDMhTMbNIxekI7LUIxkHzwHWGL6UbbGxruzF3Ca7XngVlRhG+Mh796LP/0Mp/OvijKNWQkfDH1oyh1Q0SKDNM3AyB/zGd4sfGCWRmN6IVE05WxI2yxrfLeHHsqDTmEAXwoLRvUDwkKlzGDbxJTImtw6Rcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BE3KYGhgpXVBBPSOYNWgGYdyaAFa9A9F6evta5ZQvkw=;
 b=io0Kka/CZcyLm+cNzgMS6VREKb9C9ksqWYMGnyvCwtDokYfjT+obgm9QYNRBoKt09s2TvgTuNeZ1kMfi/0dW7nywlPKLX8ye7QNtewbV3fMYWknqWUXjCn1qajn3q98dl9e4/MXRQNKxs78o/LXarQ0HsVBeFlmwr+8Fek2864rKhy5zb3ff2MVblqIwGbru3dBQk71QC/5dyDJs8o54XPz+GhGDImBjy+eF/sLBvyCQ8kRGcnWvLVEZB7gSl7QZiWJDl/dtKn+h1GLT9EhhP76mWt0GRTYq/nj42PIJJsFbSmRCaNoBs1qvDe4ZFfZ1zJFta2fubAGCLcm7F/7EWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BE3KYGhgpXVBBPSOYNWgGYdyaAFa9A9F6evta5ZQvkw=;
 b=CJHTUzDEW1muFN1kuMv+rMBmj3yCEPXV/aUAGm7hp9UWlOIoNKVdAZfPWUZ5a/h0nLQgrih2Ffro64TaiijIThVC85bT8bxXSZh9mbvOVMKiX0TbSTAefm3c5WqyOXCeoEnfosJA/qtNKy1SXAZiMNqph/rxO8uQIwLpvbk/kHM=
Received: from DS0PR10MB7933.namprd10.prod.outlook.com (2603:10b6:8:1b8::15)
 by SA1PR10MB6613.namprd10.prod.outlook.com (2603:10b6:806:2be::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.16; Thu, 22 Aug
 2024 17:02:26 +0000
Received: from DS0PR10MB7933.namprd10.prod.outlook.com
 ([fe80::2561:85b0:ae8f:9490]) by DS0PR10MB7933.namprd10.prod.outlook.com
 ([fe80::2561:85b0:ae8f:9490%3]) with mapi id 15.20.7897.014; Thu, 22 Aug 2024
 17:02:24 +0000
Date: Thu, 22 Aug 2024 13:02:22 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: pbonzini@redhat.com, chao.p.peng@linux.intel.com, seanjc@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        maple-tree@lists.infradead.org
Subject: Re: [PATCH RFC] KVM: Use maple tree to manage memory attributes.
Message-ID: <ybl7pmkjbjkuaqzpmsq53yvcxmayc3lyslftwojddmhj6k23xf@xnuevrpgsrjf>
References: <20240822065544.65013-1-zhangpeng.00@bytedance.com>
 <8eb1b3c4-5797-4497-b80f-3735a6bf1564@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <8eb1b3c4-5797-4497-b80f-3735a6bf1564@bytedance.com>
User-Agent: NeoMutt/20240425
X-ClientProxiedBy: YT4PR01CA0468.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:d6::10) To DS0PR10MB7933.namprd10.prod.outlook.com
 (2603:10b6:8:1b8::15)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR10MB7933:EE_|SA1PR10MB6613:EE_
X-MS-Office365-Filtering-Correlation-Id: 6228f8cd-dfd7-4ecc-3e49-08dcc2cc31ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|27256017;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Qk9yOEVxQWFaTEMzQmJFcVZyRzAyQ0xvNXdVbUg4MU1NZjIwZFc1WEQ0dUJO?=
 =?utf-8?B?bjB6ekdoSFBHbHp3NjlZQjMwSjJJbFg1TFZ4UVRlTVl3Tk1VeHFWeXBNMUJk?=
 =?utf-8?B?TlBPL2w4VDRkc0tLRnhuWnRLT293RWlyTm5tanZhV3hjS1hST3lHZWxYUjlk?=
 =?utf-8?B?eE44dXl0aDNVazAzUUhFcDhhRmZsNERKVjdZa1dpSDUxQy95Mm0wdkRCLzB1?=
 =?utf-8?B?aUVTaUJ4djZxNTdZcmRrTFdBd0RyckJZU3ovYlpWZVVWb0VoRThIdjBCT0Mv?=
 =?utf-8?B?My83elVEMWw4SVFDSFArTi8zRVhITCttQ3RPYzF2cjZZLzNxVjJCRW94NWxl?=
 =?utf-8?B?VnZ2aXNsNldZQllGSnRRVU5wWlJnU3pUQURwSXhRL0hxUmdvUnI5aFZnZVhj?=
 =?utf-8?B?aXRrb0ZvR2p4azdtd0dxVkYxUkk5bDlQaXZaS3VQb3I2a2hJbjYwZGR1UWp5?=
 =?utf-8?B?bFd3S0N6cEpqby9CQTZYZTZhcm1POFFpTklZYlVVeWZuSlFaelF2a1VsbG1L?=
 =?utf-8?B?WWFSWDBNNnphcFJsclE4TkhBM3FYMnJsdnBJWUVpM00wM2M4d2hhMzN1Uk5Z?=
 =?utf-8?B?WlZVQWhoUklaT052Tm4wRHRkVS8zTzZ4bmp0T3Jkd3ZDbUpaaFVlcFhqM0V4?=
 =?utf-8?B?UGJlR0lhZDRaSjJCNHdOcEdTZmZNTXVvN3BZeHg5bnMyWTZ3SEZpdUV6ZU51?=
 =?utf-8?B?K2l6dFBiVmVMTlhQVUlYUFNTajFlZEw1UzRiUURXUiszNFAzMWQyc0U5N1hQ?=
 =?utf-8?B?Zm5vSHdUY0ZBRVlhUVhQbWVMOG5iUWNLYkg3cTJpaXVYNTRCV1RpRXJ1OUlI?=
 =?utf-8?B?cktJclp0TWJkdThzTndXdHhUNlNONzJ3b0Z1SFRXa1dVT2RNbDNsQXRtMVpl?=
 =?utf-8?B?QzQ2dE9OS1poRG1RR1E4STkvTnlpRzRMb1RRU3VUdVNML2hpQnhPQkU4UDJF?=
 =?utf-8?B?eGVpVjBLN3BVck9CTnhHVFpISjlVNWxGVVZuVndkckczZGtQdWZLbGlGTzha?=
 =?utf-8?B?REw1c2xIeVNsYjQ0RGsvUmNFMFJzNTBnUVc5a3FZcDhPbVhhNVMyWEdRQ2Ez?=
 =?utf-8?B?VVlvZ2RVTmd2T2NNdjFvT2xDcG8rSXV2dzZyWWZwQmUxQ2U0S0UyTzhyOHMv?=
 =?utf-8?B?QVdsVE53U1F3RDNDR3JjTTQ5Wk10b2txTzZ4T2xKUG4veHlST3o0cTE0Rndo?=
 =?utf-8?B?TDZJeFZRUjEvUGdwMVpwZGFZV1U3Z0VrMFh6SVBwUXJoSDhyZGp1d1JVM2ti?=
 =?utf-8?B?bngvMDRmbzFGRGVhQktBM2g5TGU5RlRJNS9WaVVZemt1MlVJMzBDMFV4ekJW?=
 =?utf-8?B?bHZMdExDeW5mWWVZQk51UkgzdWR2aHlaeG4yYm9LRWh5anJpWnM4VXZXR1k0?=
 =?utf-8?B?ZGNiSUJhRkJNQlo0VXE2cmNTU3k3aGFmNExsaVNnUGJkdWsvbjRsbmYvREJK?=
 =?utf-8?B?RG1wb01FQmgwUTVSWVdRakVkWWRlYk5aOFV2Z24zS1pRQnBENlVZMmJXWnl4?=
 =?utf-8?B?NXFQaHl6eUZVVWZDNVZGUkVpd3BTMTNnejhSUmlpZ3lGUVg0SlVWUkk0ck5s?=
 =?utf-8?B?RnpQTGh3RzV6WnRlUlh3LzJZM2NTYXUvdlVuNEdnUG5SVnBvT2JVbFVBckEx?=
 =?utf-8?B?aitockMxclJhV3VHalhwRk9DUUZvb3liUVd5Sm11Y0MvWWwxSURNcnFJQVlD?=
 =?utf-8?B?ZE8xTE05RHhidUNVc1UxMk1aTXliNUo0MjVOUVZ5UTdhVWJvbFVSUzZlWmJV?=
 =?utf-8?B?ZlZoODVYY04yUnQ1elFaWEZwZy9DSmhYaGNWcTNmTTVqRmIzQTZXK1ovcFcv?=
 =?utf-8?B?N2xPMWcwaGNlNHRjVk4xT1JMYy9EaUpJWEpwdWFTczhTYlJ6RlJyN3M2TjN4?=
 =?utf-8?B?OHBNWTJ6aHIxT0FJYzhubDNlUGU3KzZrZ0VaMGR0MkNPbFE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR10MB7933.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(27256017);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RU9ISno5UXJ6NEhaUWZ3Rm40ZVFuOWpiY2J5aDFuTmlrZDdaZTU5WERBbnhs?=
 =?utf-8?B?ZnZOS0tTR2NFUWt5cDd0RFZaTlMyM1Z3VjVkbVpDaG1QZmxWVklSaGhzOTl2?=
 =?utf-8?B?SUdxVEIxRmpOMzkzRHgyRTg1dnJFZDl2clduV2FKUkcwMVVXK0ZpTUFmdGNX?=
 =?utf-8?B?Q05GeWUyUzBNODVzY1RlV0hLaXVpaGU3WENSY2JLSWxIb3hscGJmUWFPZWgy?=
 =?utf-8?B?VnExNUUydlhlS2Vnelcyd3RsamVNbFNCbGJmU2tWbng5RWEzaDRuVUd1WElM?=
 =?utf-8?B?aHBxZG9PNzFtR0JuUHFkUUNQVTdaMGFPcUYyb0NXeUh6Tlp6ZWlZRENqcGI4?=
 =?utf-8?B?WFVGbXJOU3VlRFRTMGx0bWNZeWkwQks4a1dScEVaVERXczlDQVNzUGIzRjdn?=
 =?utf-8?B?OVhCcDdMOGtLSEJWbUJlaWNZTzQwYTNnckFMdUxadmI5VExFa1JUOWRWNWlV?=
 =?utf-8?B?b1RzWmNEUnhlY2ZnMm9EK2RwZHFQeUNFckdvSFoyNlkxWnU4cTJXUnRKd3Va?=
 =?utf-8?B?TytwbVBqMUwrU0lFRXQxaGYyR2pwTTlLV0RoUDVLS2ZMQUVBbG11b0o1OFRt?=
 =?utf-8?B?Z2tjUmhCdEEvbjhyRGJXclRoVDVLZTFuRTJZeDVVNWZQSGJNUVVPSzNhMUNt?=
 =?utf-8?B?SDNzaEZlNTZlMlI2b0tPYkJVNEdPQm9JYlc5SERIejh5NlU1S1A2dy9jb1dB?=
 =?utf-8?B?Sjg0dFhOamV3cHh3YnZmVUFIR0lpVmxBakk3S3doREtTekd4dnJwdmdTUmRy?=
 =?utf-8?B?c01naW9vdUpFSTd3SFhzc2dBaHBmY244K05Wd3RYSys5N3Q4WVNlOTAxaDQ5?=
 =?utf-8?B?WnFQUkdtRWJ6bC9GT1p2OUdNcGpoZFdzTkJVS3RUbU9LQ3ZuWDVwREhzU2dV?=
 =?utf-8?B?Zkl0V1ZlaS9BVW14QzQvQTdTNFNxc0NWV3BZTHBoVmVnR2VBVG9jcnlrUWpp?=
 =?utf-8?B?cCtFRmhsKzVQSW5XVnRBU254VWdHcWxzb3NmL3ZJSG1ZL211TW1ESUtGamRH?=
 =?utf-8?B?RVpsNzA2bTlxWk9JUEx2VE5KK1RGbXc0NnNEQVpSSWt4bVB5d3lud2FZZ1dp?=
 =?utf-8?B?MDZ6bnZZOWhQcjVKalZZUTNnaTJ0QXdJN1JocWIxY0p2R3h2Y2dObWs0RXJu?=
 =?utf-8?B?b2QwUzVDQy9YVmZpbEIrR2dydjdmL0MwWVpEemNrbHl1KzhleGw5VUplamNa?=
 =?utf-8?B?am9zaGtES0x4UVN4Qi9icXQ3MXo4aHdDQXhVc214aTFvL2Z5WkxFSGtPd3hl?=
 =?utf-8?B?TjRuaERpczluRTVZeHdMdVZsT1ExQUt4b3ZnMnFOQVBtTDlMQ3NxcW5DRzlv?=
 =?utf-8?B?bUtUNDZscGViTUgzLytOSDNkcGZaZzZUZ1FjOWs4bVF5MzlYU3B0cjhGSXdK?=
 =?utf-8?B?enowdHViRWhjWExpWkl2YSsya1FBQUpreVU4MUkyUjlGS2hDOG11SHAyZ09P?=
 =?utf-8?B?V2sra0ZHWmY1aW1CSjBtRWRGR2wwQm5yTDl5cmluRWtKRXNZVmxhUWk1SnJl?=
 =?utf-8?B?SDNpT2Njc0huN0NOQTNJYldlbGd3YU1oK2pmNzVROVN6L1V2dXhnZzIyVWk4?=
 =?utf-8?B?eGE1UHJodVFpTUV1MmdhZEVwN0ZNa1UrVFI5WmpKRkdXUzcxMW1ibDFlVFF0?=
 =?utf-8?B?UGFtL1NrUzBvVkFFWFZnbjVwZmcyMjc5YXBqK21rZDRxZnFnT0F6NDQvSTlY?=
 =?utf-8?B?UlN4M0JvTlhSbU80RHQyalpmV1VFQnF0ZjdFcUtleWxaSEFSeDFGRFJGMGVx?=
 =?utf-8?B?cHhMRFRoRG9oZXR5T3JmT1h6Z1pMdGtRRzkvYk12SU40RHYvOWl4cXNJZnFh?=
 =?utf-8?B?ZVorRnNzTlluNENkV3BRd1N5cGFIcFE4MHduZExucEJEWnc0U2gybTRmTDVz?=
 =?utf-8?B?UlBmVGkwUVQxL1lpdktWRU8zdW5UVXgyYjhNMkVxdG8wUzlWTmx2eUdvQkZv?=
 =?utf-8?B?WFNKUDZPelNJbkwxWFVWeXFLeDdOckRmV08vTUM1SCszYS9yV1lEUW5aUkky?=
 =?utf-8?B?WHk5dTM4cmh5L2hWeDdzYktDRlBqVmhicFVYMWlCMUtFZmZCajJTQ2lDZXM3?=
 =?utf-8?B?S3Yxa0o5elcveTZLU2wxVkE5UzF5UXBQai9pNU93NTEzT3JrNjNScm03Nnk5?=
 =?utf-8?Q?oQmsp+jdtamc2voU2pU60yEHg?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	OxLC9DSRKulObZH1wBvxZP2DonP6jk5+Vmt890NvfnVbYRgPo+TmmDkDgHS0BSkc3t7tifUd28x/+N4VJCAFjckaRBP+Wbdt9kUg9cut2rZZBXJysE10Ejxh6OQcpnj/jh+6sEnAnalCweF4hXuyqrOtnYsOFk1HiYScxHKrOqiwrlBn7jg/CP/5Vyga/ygIly3TGrtM9ifIRV6//HoCn/xqrvYySlzt/a1jfYhz/E50U8hQfCfqgVWN3+USSNaizx93+apgxua5ziBfZShpRJP0xmO2lnKUX2TF06j+dQQwm+fEnhUcoRloQ/bSDyrn5RM+1ecyzoHTlVBhUu8EbhjrvTaPhwlPlfv1OeG0WnjlGsGhEjA8dCwN/HKRtvke9JSpyr+7VKPU7il96km5vwUznFwSXoksi//DEf25aLPhHC/YCYx2iNsENhh2k2kbU5GuWp8nLs+zH2B3XFEuwwd1+++OqpiEFqNnu9xx00MEzdTgFT4WMNGwDtvbEaxbCwmHoEvwrlsSN1ImqMJMBQgdU0XvQdVJv0JZbSjwIm80SITAEELI6v2TjA4fZ3V5N9vcogPDyHozQk7JMZsBPm57blpiIfOusOLRAZRYU/g=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6228f8cd-dfd7-4ecc-3e49-08dcc2cc31ed
X-MS-Exchange-CrossTenant-AuthSource: DS0PR10MB7933.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2024 17:02:24.7700
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AZmhaIRY80Bs82uD284Ltatkc6H6c9jp6Ks6E/09320JIqYrSwUQrMR2oPfbsEW3GDoV8zhtikiN4oda6wSJ6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6613
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-22_10,2024-08-22_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 phishscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408220127
X-Proofpoint-ORIG-GUID: wv4Pt3pxRBWvuWkT88lhXHXSMx-XH5Zs
X-Proofpoint-GUID: wv4Pt3pxRBWvuWkT88lhXHXSMx-XH5Zs

* Peng Zhang <zhangpeng.00@bytedance.com> [240822 03:30]:
>=20
>=20
> =E5=9C=A8 2024/8/22 14:55, Peng Zhang =E5=86=99=E9=81=93:
> > Currently, xarray is used to manage memory attributes. The memory
> > attributes management here is an interval problem. However, xarray is
> > not suitable for handling interval problems. It may cause memory waste
> > and is not efficient. Switching it to maple tree is more elegant. Using
> > maple tree here has the following three advantages:
> > 1. Less memory overhead.
> > 2. More efficient interval operations.
> > 3. Simpler code.
> >=20
> > This is the first user of the maple tree interface mas_find_range(),
> > and it does not have any test cases yet, so its stability is unclear.
> >=20
> > Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
> > ---
> >   include/linux/kvm_host.h |  5 +++--
> >   virt/kvm/kvm_main.c      | 47 ++++++++++++++-------------------------=
-
> >   2 files changed, 19 insertions(+), 33 deletions(-)
> >=20
> > I haven't tested this code yet, and I'm not very familiar with kvm, so =
I'd
> > be happy if someone could help test it. This is just an RFC now. Any co=
mments
> > are welcome.
> >=20
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 79a6b1a63027..9b3351d88d64 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -35,6 +35,7 @@
> >   #include <linux/interval_tree.h>
> >   #include <linux/rbtree.h>
> >   #include <linux/xarray.h>
> The header file of xarray can be deleted.
>=20
> > +#include <linux/maple_tree.h>
> >   #include <asm/signal.h>
> >   #include <linux/kvm.h>
> > @@ -839,7 +840,7 @@ struct kvm {
> >   #endif
> >   #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
> >   	/* Protected by slots_locks (for writes) and RCU (for reads) */
> > -	struct xarray mem_attr_array;
> > +	struct maple_tree mem_attr_mtree;
> >   #endif
> >   	char stats_id[KVM_STATS_NAME_SIZE];
> >   };
> > @@ -2410,7 +2411,7 @@ static inline void kvm_prepare_memory_fault_exit(=
struct kvm_vcpu *vcpu,
> >   #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
> >   static inline unsigned long kvm_get_memory_attributes(struct kvm *kvm=
, gfn_t gfn)
> >   {
> > -	return xa_to_value(xa_load(&kvm->mem_attr_array, gfn));
> > +	return xa_to_value(mtree_load(&kvm->mem_attr_mtree, gfn));
> >   }
> >   bool kvm_range_has_memory_attributes(struct kvm *kvm, gfn_t start, gf=
n_t end,
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 92901656a0d4..9a99c334f4af 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -10,6 +10,7 @@
> >    *   Yaniv Kamay  <yaniv@qumranet.com>
> >    */
> > +#include "linux/maple_tree.h"
> This line should be deleted.
> >   #include <kvm/iodev.h>
> >   #include <linux/kvm_host.h>
> > @@ -1159,7 +1160,8 @@ static struct kvm *kvm_create_vm(unsigned long ty=
pe, const char *fdname)
> >   	rcuwait_init(&kvm->mn_memslots_update_rcuwait);
> >   	xa_init(&kvm->vcpu_array);
> >   #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
> > -	xa_init(&kvm->mem_attr_array);
> > +	mt_init_flags(&kvm->mem_attr_mtree, MT_FLAGS_LOCK_EXTERN);
> There is a flag missing here, should be:
> mt_init_flags(&kvm->mem_attr_mtree, MT_FLAGS_LOCK_EXTERN | MT_FLAGS_USE_R=
CU);

I'm not sure rcu is needed as the readers are under the mutex lock in
kvm?  That is, this flag is used so that lookups are rcu safe, but I
don't think it is needed (but I'm not sure).

>=20
> > +	mt_set_external_lock(&kvm->mem_attr_mtree, &kvm->slots_lock);
> >   #endif
> >   	INIT_LIST_HEAD(&kvm->gpc_list);
> > @@ -1356,7 +1358,9 @@ static void kvm_destroy_vm(struct kvm *kvm)
> >   	cleanup_srcu_struct(&kvm->irq_srcu);
> >   	cleanup_srcu_struct(&kvm->srcu);
> >   #ifdef CONFIG_KVM_GENERIC_MEMORY_ATTRIBUTES
> > -	xa_destroy(&kvm->mem_attr_array);
> > +	mutex_lock(&kvm->slots_lock);
> > +	__mt_destroy(&kvm->mem_attr_mtree);
> > +	mutex_unlock(&kvm->slots_lock);
> >   #endif
> >   	kvm_arch_free_vm(kvm);
> >   	preempt_notifier_dec();
> > @@ -2413,30 +2417,20 @@ static u64 kvm_supported_mem_attributes(struct =
kvm *kvm)
> >   bool kvm_range_has_memory_attributes(struct kvm *kvm, gfn_t start, gf=
n_t end,
> >   				     unsigned long mask, unsigned long attrs)
> >   {
> > -	XA_STATE(xas, &kvm->mem_attr_array, start);
> > -	unsigned long index;
> > +	MA_STATE(mas, &kvm->mem_attr_mtree, start, start);
> >   	void *entry;
> >   	mask &=3D kvm_supported_mem_attributes(kvm);
> >   	if (attrs & ~mask)
> >   		return false;
> > -	if (end =3D=3D start + 1)
> > -		return (kvm_get_memory_attributes(kvm, start) & mask) =3D=3D attrs;
> > -
> >   	guard(rcu)();
> > -	if (!attrs)
> > -		return !xas_find(&xas, end - 1);
> > -
> > -	for (index =3D start; index < end; index++) {
> > -		do {
> > -			entry =3D xas_next(&xas);
> > -		} while (xas_retry(&xas, entry));
> > -		if (xas.xa_index !=3D index ||
> > -		    (xa_to_value(entry) & mask) !=3D attrs)
> > +	do {
> > +		entry =3D mas_find_range(&mas, end - 1);
> > +		if ((xa_to_value(entry) & mask) !=3D attrs)
> >   			return false;
> > -	}
> > +	} while (mas.last < end - 1);
> >   	return true;
> >   }
> > @@ -2524,9 +2518,9 @@ static int kvm_vm_set_mem_attributes(struct kvm *=
kvm, gfn_t start, gfn_t end,
> >   		.on_lock =3D kvm_mmu_invalidate_end,
> >   		.may_block =3D true,
> >   	};
> > -	unsigned long i;
> >   	void *entry;
> >   	int r =3D 0;
> > +	MA_STATE(mas, &kvm->mem_attr_mtree, start, end - 1);
> >   	entry =3D attributes ? xa_mk_value(attributes) : NULL;
> > @@ -2540,20 +2534,11 @@ static int kvm_vm_set_mem_attributes(struct kvm=
 *kvm, gfn_t start, gfn_t end,
> >   	 * Reserve memory ahead of time to avoid having to deal with failure=
s
> >   	 * partway through setting the new attributes.
> >   	 */
> > -	for (i =3D start; i < end; i++) {
> > -		r =3D xa_reserve(&kvm->mem_attr_array, i, GFP_KERNEL_ACCOUNT);
> > -		if (r)
> > -			goto out_unlock;
> > -	}
> > -
> > +	r =3D mas_preallocate(&mas, entry, GFP_KERNEL_ACCOUNT);
> > +	if (r)
> > +		goto out_unlock;
> >   	kvm_handle_gfn_range(kvm, &pre_set_range);
> > -
> > -	for (i =3D start; i < end; i++) {
> > -		r =3D xa_err(xa_store(&kvm->mem_attr_array, i, entry,
> > -				    GFP_KERNEL_ACCOUNT));
> > -		KVM_BUG_ON(r, kvm);
> > -	}
> > -
> > +	mas_store_prealloc(&mas, entry);
> >   	kvm_handle_gfn_range(kvm, &post_set_range);
> >   out_unlock:

