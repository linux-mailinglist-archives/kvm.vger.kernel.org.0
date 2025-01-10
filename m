Return-Path: <kvm+bounces-35010-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DCC1A08ACE
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 09:59:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7481C3A96A7
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 08:59:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1552209F2A;
	Fri, 10 Jan 2025 08:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jsjPt7P6";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Kj2KMEy0"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B235207A28;
	Fri, 10 Jan 2025 08:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736499534; cv=fail; b=l+nFwwVSZXRbkzVh2AOGPQZfXtC199Imisoi7z2e1V35e+/Cw8ayewp2b1XFN+PqlUcvzwQVMcf8eId6azmMB+hdMFwmByNAu/99QLCxTikaOGj2G2bi3EUC8Jda2wBUYk8x8/cdV9uvAKgS/UkKBhfYxp7n5kfmFVq9HzWF0OI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736499534; c=relaxed/simple;
	bh=/jzfAc1r9IIExBNZ8wAd4S18cldof9go3Rsyydb87AY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=PdicTCT33XoiwAw1Zx9GJqCEeEYXf0inPnXMsExMZ+htzJCKKd1RcaQtSsTErr+dIDMCEscC+C083zZfnpkMykfWbZR2U5NYIT7A5obXhLpHK16HxuRUBdOrpe5eHLjIwPIUrY2p3fkGcpxtQ19in/3/UsOlDBljTyHFvVnZWKU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jsjPt7P6; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Kj2KMEy0; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50A8tk3S015349;
	Fri, 10 Jan 2025 08:58:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=yGAlfULb4ZtqL3AZdWTiCSCZAcZVN7d2D7UTfcUH1kk=; b=
	jsjPt7P6qZ97t0WMfFK8IiEK49Q7+l1BB8lBrt/CUKGiwMti41uKiPeSt5nnMD18
	G1m2Ulhi0oDQ4iXd0XMu0uBVtOCxp6bgJr6HJVQUo/621CWQRRpgtC5B/AGYpKSy
	VxhF9ZxQhVQeQiN7xEVYVXxbR29z/OyRgmsEw8VatMoYN9/1KhZZhH78GjRYF63k
	7MXknHUbisRZ5YJt86n9YI/Uf8tqEYM3Vz0lQi8zpTrlgYf4Ab7gkXJOw51txQqs
	1GvHZ0f85qyISxKKXTT7ehuEaIeIn/IPxoDFzgolAI+zBTBURvpf+b0RUkv26m6V
	xB6BaB/pul927DBhNbO75A==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 442gy5sgqp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 08:58:39 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50A7e8Ij020119;
	Fri, 10 Jan 2025 08:58:38 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43xuejjekf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 08:58:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=koZzHKRwONfOyv8WKiM3KSoWytdte4UY8MgNlyvkHz8KS3LjOK1iFvvG63p6kjz+PQZcWVrZWL6znJ8TPq5Vg3GsenNbA7pQzS/vJ+WmmR5h+PFomd/b3tqMHvgT7i8xQ5G1DskIP66G4OmUlV0FlFLGPjfSDFdFxKgpm0Ml6rJvnf2GVra9K9ZP8tHLdU5q4S6sy8QGWES+KwnT5fHbqPIxcFAC5IxcJ8yy//gGRZQOcacAz366xEdK8W/ooMwM9NRhrT4YRSUkoLabJH1zOtBif+GsBdDkazLikhRCQ6qop41roPJggkxjEwqEyKh/XDYDbEK4sNnaxB6eEdvr1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yGAlfULb4ZtqL3AZdWTiCSCZAcZVN7d2D7UTfcUH1kk=;
 b=JpTONjZ7RMQ1Ixh9/o1/rhS3+J57abYmGky+YEl50TDmU689HWpVBsHCkqkmjdoFVxWA8E/ZQKtydb2acS8d3lTXWiVUKyxZC7WnKM0ssnBU5laEPyVzCwFWB2rzpVHE3amkqoN6yviTnaAjCIgvLXE79ouaKQE3olxHsEsdZ0Regafml+2gET4Ttxw2AyV0Q1Hz81nIHV8hq2oypG+Admqg4g7I9T5rBa1kDLSnjAMmxAylqipWEasNd2Y42zGoeeKVU7QIFkJ/Tqx+Tg5eXIAwG/V8nuI/XOuanvuL6sas9uulU0MJWnXOAjPW9zQeHpadgiSi+BIKqNVwfBlgLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yGAlfULb4ZtqL3AZdWTiCSCZAcZVN7d2D7UTfcUH1kk=;
 b=Kj2KMEy0r65mUEXQOvjGAVm2uv9s1+Y66O8Isy7I2/I/nmPr1Qsd3uEOfegNhh493rFtJ4AkVUdEqcnZIcxxBV4MJ/ufA5+hMBzVeaD0oTKovXhrxhr70pdIVdx3wK5/CM1bTNWCiZupdAIQOG2VfDDeYllWinqFWuR0WqxHjsc=
Received: from BN0PR10MB5030.namprd10.prod.outlook.com (2603:10b6:408:12a::18)
 by MN6PR10MB7422.namprd10.prod.outlook.com (2603:10b6:208:46d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.10; Fri, 10 Jan
 2025 08:58:23 +0000
Received: from BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::44db:1978:3a20:4237]) by BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::44db:1978:3a20:4237%5]) with mapi id 15.20.8335.011; Fri, 10 Jan 2025
 08:58:23 +0000
Message-ID: <32ed551f-d499-47fe-8f76-f80cb1513d9a@oracle.com>
Date: Fri, 10 Jan 2025 08:58:17 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] KVM: Introduce KVM_EXIT_SNP_REQ_CERTS for SNP
 certificate-fetching
To: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, seanjc@google.com, jroedel@suse.de,
        thomas.lendacky@amd.com, ashish.kalra@amd.com, pankaj.gupta@amd.com,
        dionnaglaze@google.com, huibo.wang@amd.com, liam.merwick@oracle.com
References: <20241218152226.1113411-1-michael.roth@amd.com>
 <20241218152226.1113411-2-michael.roth@amd.com>
Content-Language: en-US
From: Liam Merwick <liam.merwick@oracle.com>
In-Reply-To: <20241218152226.1113411-2-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0154.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:188::15) To BN0PR10MB5030.namprd10.prod.outlook.com
 (2603:10b6:408:12a::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN0PR10MB5030:EE_|MN6PR10MB7422:EE_
X-MS-Office365-Filtering-Correlation-Id: d413a2b4-7151-4c37-8b65-08dd3154eff6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VHAwanFhVkVUM1NjallFZzZnUThqNkgzYlM1aTVUUUhCMStrTW4xK1FCV1lE?=
 =?utf-8?B?RkQ4N3BqSVJ6cytMSk1wYjkvYUlWaHUyNHBNZFRsdldVQlFURXBQMklFc0ZF?=
 =?utf-8?B?SU9NWnVZQVQ4SXpJV0ptdUJZZi9IazljaEJOcFQ1REF5Q0ZWR0h0cStWMmZP?=
 =?utf-8?B?MXNjRTFtUWlTbngxemZVb3dCMzkvTGlISXg4NGlCMEVremdDYWxKemYvejVt?=
 =?utf-8?B?eDFpMldEMVdLN1dqT2gvcmdoMlNaQXViNEg3Wi9MNDQ0QU96ZVBScWZnRjQx?=
 =?utf-8?B?UUl4b1R0RXlwMFc2Mko0cmluVDltUVowL3VmNzkwYmMzWjRWMFJ0TnhQRW1D?=
 =?utf-8?B?YlRIc3FFYnFXd0JSVWN3NzF0UllDa2d5dFh4ZktLcVpIdzIrMWdGeWhyY0VG?=
 =?utf-8?B?MExueHlDb2xUZ2VpNWJFeDJXWWdob2poMUpLQjlDNzlCSDV6ZGxwdkFRVmg4?=
 =?utf-8?B?WktVamxMM3Q2QTRESDN1cjFLK0NmYW9QMTdFalVrcmNKN1VmMUNGZERHYjNB?=
 =?utf-8?B?TFowTDltOFU5ekFDQklZQjlGZThVb2dvQU5sSzVRUTJKM1FIUmh4ZDFRdHlE?=
 =?utf-8?B?c0p1Z3ozV3A1RGxZeUhiNzVvVVVFbG9JV0tBL0VjckZMeTZPSXczdE5XWk1G?=
 =?utf-8?B?VjRoMW1Hcjl4NnNLK2M0cjZvWjcvMGRIZFVLdnJCZjhrdXljUUpxaWczTkJw?=
 =?utf-8?B?UXJ1am1XMnliRnVPd2g1c2FEZDJnSnVOdGpiMk9OSm50Z2xqOVY3dEI3V0l4?=
 =?utf-8?B?NFJ5OXVoMERTWXRIalo4eHM1VTR3QW04ZHR2VFJkMHZWWm5OekRLZ2c3OVNX?=
 =?utf-8?B?N3dkd2Q5MGFxMzNXdkFnSzkzVC9oODY1MjAvUExkV1N5STlSTGRyZHRqUStC?=
 =?utf-8?B?d29Id0JHNHd3SFhQUFo3NWtxZzdvTTN4RjZBQjF3UUw5NFllZmgwU1BNWXVx?=
 =?utf-8?B?d3B4UHJ3ZU1JTUthMi9vMWJYNEZiV2JXaHM0eU1WcVBSN1YzUkRHSzlmUU40?=
 =?utf-8?B?TWxBaFhIaG9GSmI0TkJGd0tTWkIzdFRQRDd3RUhDaU9KZ1hnMlRYTml2YVlT?=
 =?utf-8?B?K0hBZ2kvNFNCaEpyL1ZxT2ZqTFF4SnlraW4xbjVRaTJyVFZsSnlzTjNKNUZG?=
 =?utf-8?B?VVlOaWV2ZThCWmFBejRuYkxwNWk1MDNJRFVaQTNZcDgrMEN5bERZMkppQ2lX?=
 =?utf-8?B?MmRPUVhYVFBud1dnRmppRFlYZ3lIc092eUxjSXVpUlpDTEZWTWhPNjV3YzJC?=
 =?utf-8?B?aXo3c01McWYrOWRvK1NtckJhbElzazJCUzdQNS9ITStvalp3RktOaHpsQ2E3?=
 =?utf-8?B?cWhzNWZGaGYyekhma0JRc2J4MUl0bHM3dENrZnNodnU2djFScHNydkdrQkpV?=
 =?utf-8?B?Q2h5TURvdTNQUTFzQ01aMkRlMnRwZ29PTEJnUTVhcms3SUROUCtuNXdWSDU1?=
 =?utf-8?B?WE16dU1kTGdYaE9yTlF4ZnNabWllQkJUaDk0ZDNxaWxXMm5nUS90TStrM2li?=
 =?utf-8?B?UTZZWklkZzFSUDdWMERpVDdUNFRaOXcxOXVsMm10L2J2VStDN1JQOW5ITXhZ?=
 =?utf-8?B?bzN4dWt5ZFNJekpKN0N3MUlLNklQSzFacHZicGVieGl1Ym9PYUVlWGMxMFBF?=
 =?utf-8?B?cEZkWmQ0MmprRU80YzUvNjFmVDVNVTQwK2YrL2xDeFBycERIckpZTUpsMlg4?=
 =?utf-8?B?RTNwbUg2Tnk1azJwRTlvbTV3TE01bnBXUi80UURRUm5zUGNaSEsydWRrQVF2?=
 =?utf-8?B?UEkzblMxb1dqa0szcGt3UkJVTXMvY3VTN3NZOWtQNytNdG9aMEdNNytieVJZ?=
 =?utf-8?B?bDk5bXpSaW10bFBwTUVSbEl6S0lLSitrdzdYZ2xzbnA5eEI5cGZjK3Yra0RD?=
 =?utf-8?Q?InYXbUacB2vTx?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5030.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K1hxMjNWU00yMzdGaTBPb29BWXZ3NzlUbHdzSzBvNEZzbHB4OGZ4OWhzbys3?=
 =?utf-8?B?V1NrYmxDcm1TbnhlUHFRTFFJbjhsOXFWSG81Y2tKM2dpYWpyOXZ6UmR4d2xK?=
 =?utf-8?B?cDNhbUorWUVVR3d0WCtQZ2NDTUk5eWFaU0RVaGdDWkNrSHBRb3JUQ2ZzZE1k?=
 =?utf-8?B?NnNrM2doWDZVQVhQYzhoOERRbW1obWxPM1BzSEQ4Q2xzbDlPRmJmT0hzWmcr?=
 =?utf-8?B?ZUFyZktnOEdFRnpvbVY3OGNYTklUMStNSHdya010bFFNRnZMVzRhbnhqSk5j?=
 =?utf-8?B?Y2tucmtPL294bWw0dk5ISDljdjB0TlRySmZjVkd5cG9BUDNUNG9HVHFCNmJt?=
 =?utf-8?B?cXVDMUh0Rk85dFROZUltWlA4d0JIa0pNRFh1MmlLbmkzYzdyTk9EbFBIMDlx?=
 =?utf-8?B?LytUZ1hmeGpXR2E4SHBrNHJkZktuK3lqU3BnZHlvcTFwUWMwMzRKaThRcHNT?=
 =?utf-8?B?YmlTaHhMY1ZjRVVVcnZQY3BtZkVKQm1CbGEzMGdGODQ0UkVvWXc3a2MrU29o?=
 =?utf-8?B?Lzc1ZFBOSXhXa2h6Z1RFa0lvWGtxWThCUFFOc1pxN3M1UFNCWXRHRWE5YWNi?=
 =?utf-8?B?a3VUNlRYRVVOSjcyb3A3M3hvWXlLYWdza005MjJ2QWhlbmtCTEJscVhjZVNz?=
 =?utf-8?B?N0I5TG1GOUJkK2VhVkl5UmdNU2U1czBCTDd2Q1dDdEY2WmFWWXF2YVR6elBQ?=
 =?utf-8?B?UWpYSEtSS1B2VndYZmdpbEJqMXpxNlpIZFI5OGhoTlVTKzF3aGtveFp1WkdB?=
 =?utf-8?B?QUMvKzhrdFVOVm5XQlYzTE5SS2JEc2NsOEwxbkNzUEQ5VFlJdVJuTTlVZzI5?=
 =?utf-8?B?a2o5Z3VwNStRUjVKY1NGT0ExbGdDS0ZKZmZVenRkRHJJM0Zobk1VNmF6S1Fl?=
 =?utf-8?B?UFFNTndsRnFtWkZXMDNhS0ZpNE0xbmwvei9DQ3hrTVAvVTlXMU1XQVZlNmRD?=
 =?utf-8?B?a2RzNkFsMHpQZFFIS3grU2NvSVdJQzVkYTBTMTJ2cHRUdzRQRFJlMFdMcWQ4?=
 =?utf-8?B?eS9OOFBrMElkcGJIbVpPdi80UHkzVTZLaFZSbEthQU5mVGltM29NM1VLeW9h?=
 =?utf-8?B?YXBpajNIZ0ZLUDJzYnA0V0tONHByR2xnNGVuL3Z4RVE1M3V2Y2J4cFU0ODRT?=
 =?utf-8?B?Z1NIa3I4V2ZhendCemNSb1ZwU0JpamloWTJvbTQ0N3R4RW1OeTIxL0doamxq?=
 =?utf-8?B?d0Rka09yOWcxb3ZVVVArd2hoQWQrbzcwajhKYnJ6eVJzZzJXNTZUZEVOTjQv?=
 =?utf-8?B?b3ZpSmp4cm5Tak9wMkZuZjVFMmgzclgxMXRuUEt2NUpMU3FpWExJNU96UlZi?=
 =?utf-8?B?MGZ0NzlncFZSTEtFS0VMdUhsYjhGamMrTmI1Y3lnS2JNUVRrdXdHdzRKQkZR?=
 =?utf-8?B?Mmx4T09UZ24yaElhQ2FnRzZXTWs1a2R6VXdjYnNkdFN0U3E1bWZkZm5DaTJo?=
 =?utf-8?B?YnFwZUNYK3REaVBhWFdrL1NBWjZKSmQ3MHF4N29uOGtvQzBRMmpwQitBdWY5?=
 =?utf-8?B?b1ZEaW1xNnI4TlY0T3pTcWNZV0lEWnJpVytMaFJHR04wNkQvVlNXblVuVWtH?=
 =?utf-8?B?WDk1UHdaRmZ1c3RNa1pCTy94a0ZlclNCV2w2enRhZlhOM0l1cWphYjZQZE1Q?=
 =?utf-8?B?TVR2cWZhVTRTWDM5bDJ5aSt0a1R3cVVud0U0dEd6dFNISkhTbDRrM3lYZy9N?=
 =?utf-8?B?NjlOU1JDajkxQkNYV0xIL1JSeUpULzhaSHRVbXpvN1pnekYxc2ordlFVVjRO?=
 =?utf-8?B?ditNY1VtUmp0UGxZWGJES3c5VjdMTDhLNW5XTy9nY2lFUTEwTE5UU2tyUTFq?=
 =?utf-8?B?ZkVyNkVyMHdJeVdzWUw0ZGJKZWl1L29nREkwRmhua2d4RlNXaHJhOW8wNEtL?=
 =?utf-8?B?azVtK3p6QkZMYmY0Q3hmQ2UyZGd4S0RuVVdQZ1VyYndhQTQ2VWZUYVlTS2x2?=
 =?utf-8?B?TXVFQmVJSUVxOERmVHB5K0VWeGRJM2FTUEE5Zms4MXluYml6S1JuWklWelVw?=
 =?utf-8?B?UHB2VE1rSWFrbXBqWWxZcDREY0VPZ1dWNG1JdnpDU2tuQXZzeG1MVkRhVFp0?=
 =?utf-8?B?ajI0a2JYZTRiU0pBbkQ3VUhwenk5NFREK0RMcEswUFp0NFN6YWkveVIwSGtO?=
 =?utf-8?B?YkdJNnBDYjh0aWlwUGpxeWxweGNGSjVrZWVWN3NrYVFHWWlYbjJ3NzlpeFcy?=
 =?utf-8?B?aXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	117Th9lqIky/oQQ8mPw3FT2biafeDYLpjPadl4kmtdw6Vz/FdYBduixHyaQgPoDxdiuIfI6A11zwxV5cNSSKQo6S5NmRDKi2fmG4kH0HHbrReT/C6jhCOFGtu2zjVRWFic7wRtR0kShqXkDAbGfdG89FwBm2n4b9ufdJ03jpdsv4yaeoid2dkL+gM25R+yUrFvldYf9BoqpPtOmkVXW5dT2hcJ+RYZiuGzbF+gT7hsJK7vhreH7QT0gyPR3CaN7X/v9LHr7E8GNPAbRm1xEbzfGn+JNk7fQGZgZwebq6Xk1iMHAf5hDOr5QceKnTwFl6xZ98ac55TaSTgQ062iMEYzxdZ1qIZDKoWybgiB0t7JDpAlNLFUfZrL9KU8e1fsO2ppaj64U6mN4JI0S9UHvmaL3+qNfbdQwm0ZJoQDuFhxoivk+AFWcJ73cRCYivCOm8ffY/wTWP+IQuBdf05iQiC40rwa3zRQkheSeQrrVfxeaypQRZuPRkstf1QNW5PXZLTOQbQU+ig/2/Dw9jzJAv9l6d9QzYGFfA3Y0tMhBaeIdvPRny94BxOcL6kPld6AZnRj3J8PwbJpPKL9pNnykNKaXFFikY/ZSI/up6OImJ2BQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d413a2b4-7151-4c37-8b65-08dd3154eff6
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5030.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2025 08:58:23.1542
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wl2oXttxMh2q1UHIfarqIc0VES64Zoj3x4GKfBQCT71knTjmVxE/6ajz9xvpUcEZA6FtjVw+d1LHJ81x32WrVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB7422
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-10_03,2025-01-09_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501100074
X-Proofpoint-GUID: ebF44WwzeXQ_z5y1ct0sub0GWuwcbEDb
X-Proofpoint-ORIG-GUID: ebF44WwzeXQ_z5y1ct0sub0GWuwcbEDb



On 18/12/2024 15:22, Michael Roth wrote:
> For SEV-SNP, the host can optionally provide a certificate table to the
> guest when it issues an attestation request to firmware (see GHCB 2.0
> specification regarding "SNP Extended Guest Requests"). This certificate
> table can then be used to verify the endorsement key used by firmware to
> sign the attestation report.
> 
> While it is possible for guests to obtain the certificates through other
> means, handling it via the host provides more flexibility in being able
> to keep the certificate data in sync with the endorsement key throughout
> host-side operations that might resulting in the endorsement key
> changing.
> 
> In the case of KVM, userspace will be responsible for fetching the
> certificate table and keeping it in sync with any modifications to the
> endorsement key by other userspace management tools. Define a new
> KVM_EXIT_SNP_REQ_CERTS event where userspace is provided with the GPA of
> the buffer the guest has provided as part of the attestation request so
> that userspace can write the certificate data into it while relying on
> filesystem-based locking to keep the certificates up-to-date relative to
> the endorsement keys installed/utilized by firmware at the time the
> certificates are fetched.
> 
> Also introduce a KVM_CAP_EXIT_SNP_REQ_CERTS capability to enable/disable
> the exit for cases where userspace does not support
> certificate-fetching, in which case KVM will fall back to returning an
> empty certificate table if the guest provides a buffer for it.
> 
> Signed-off-by: Michael Roth <michael.roth@amd.com>

Reviewed-by: Liam Merwick <liam.merwick@oracle.com>
Tested-by: Liam Merwick <liam.merwick@oracle.com>

> ---
>   Documentation/virt/kvm/api.rst  | 93 +++++++++++++++++++++++++++++++++
>   arch/x86/include/asm/kvm_host.h |  1 +
>   arch/x86/kvm/svm/sev.c          | 43 ++++++++++++---
>   arch/x86/kvm/x86.c              | 11 ++++
>   include/uapi/linux/kvm.h        | 10 ++++
>   include/uapi/linux/sev-guest.h  |  8 +++
>   6 files changed, 160 insertions(+), 6 deletions(-)
> 

