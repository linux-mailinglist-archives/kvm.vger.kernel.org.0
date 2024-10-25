Return-Path: <kvm+bounces-29744-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7468C9B132B
	for <lists+kvm@lfdr.de>; Sat, 26 Oct 2024 01:27:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EBC011F2272E
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2024 23:27:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3B73213144;
	Fri, 25 Oct 2024 23:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cEDZKBR7";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="V8VRDgQz"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F5E7217F5A
	for <kvm@vger.kernel.org>; Fri, 25 Oct 2024 23:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729898866; cv=fail; b=WM0khjJrJRrPGAwEuV9ITJ61QeTClXbrR8pZU277iEJ5qE7XwOCqyh/P15yg9HL8dUauTFmtv6Wy8/TxE+RGypoVh+fYGCDLLC8PSoub55sfhnYpmx5erPSdHLXLAOecFvM63jPDM5Gylv7QMNoHdQC3OQuiIQXDtiw9+2fP2XY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729898866; c=relaxed/simple;
	bh=KFLJMH9lkeeDGTkEs5fFsnCp9XK/BNQQhOnRPOlOhJc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=pxGlCyTUc7bhckBFCM408G3D4pZ919bvnAQlyftU+j8A0fHvubxczpEaGW2FsT+yzQiF8jfrHdKjtmocf1iG5TpLrLeAydlwyVWy3gekAQ1rEd9g6GF8d6/Zb7/FEgjxOTSsqfXOeBghkrSDhxIO7mwOAbkQSSiQd7m4gIB1qqg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cEDZKBR7; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=V8VRDgQz; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49PJdTbp009555;
	Fri, 25 Oct 2024 23:27:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=NH2pSWPPd1U5Ay1vV1GCgzgKCKbfjSLDTmpJtUu7nSs=; b=
	cEDZKBR7ux1GBTrLm09djDY8RvZbpsAyZfImk9HwEaLOuSC8ekB3Wd7CT4psC/mb
	G8nILAwXowp4PZ+hMVsI/S6a/QHFgFsBhXebDFL/OBzDNdUpstSLwuaL5Bi7k7wa
	n8gIM3zvrX6ZmHDuU7+QV7PJ69nBTCwW8k1Twu0ldKPVrYOv/JK8vHfInfSCxKEu
	OfzugoVVKo9FAbtb/6WRDd4F5g2zZ/SoziojRDPIcOwfhLmM2HYPshrJ/4wiqcBV
	4Rvj3wzdu1UcEPSR5mJUUMVZ1T67bpLKSmhvZDEybty6jxJD21rZM1Owg7gTxLPZ
	ynn8UHC3IPGyOlvNdbxnFQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42c55v62y7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Oct 2024 23:27:36 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49PM0reb016379;
	Fri, 25 Oct 2024 23:27:35 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2048.outbound.protection.outlook.com [104.47.56.48])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42emhefatc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Oct 2024 23:27:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cUDvvwtJCoKffSYZSnjn2S76OCHw0UCM12neJGIl8SReZ4JTj+TtgtFquQwEH6kR7tV25XnDfz/WdYrldryqGGQjPz9aF0Z+s92gz+TqGQtoBVqssoFDQrt8Ygeg0tWK6WnIaXMeOdxRieRZGk8LERid6HzDC1MR30ODb5/lWh7p+Fuejfv/+NYYHLPeH/l0N3b75lvAXMhgJIfOjc9tr+8R7uPuH0xkUKEEax3XLfgpDELBeGkFrDGsL53uwDH8K54aslYbrwcZ67tzc9e9C0vZtha3RoFgQNiIBFmNtvspSHn62cmLF2Tx8FQ7Buf2wc1MVAFydLU2TDjRoo4IoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NH2pSWPPd1U5Ay1vV1GCgzgKCKbfjSLDTmpJtUu7nSs=;
 b=drUyZZA0KLP/VvJO7bCeFOZjSbaTd40VcKux8AATrqnTsVcHt6tzBTFETC9fH2Fwr3R9mj88e2y279ghSiqwJOjurdeOhb7PnMiRZ2qwgdKRBhjmjqcAZ4s5wPoE1c2/C7tq5lNuahi2vZL64gYtVib/Q/dWatMzqqCt4RNG2tmM5GAielGovOlRIH86hvtSIVSgcit1PROIAqY4pIhmkNB5JPFtdxqLjzV/OYPDm3WwgZHzTp9tZIsko8dECuc/VeWAG+ycXE6gbbLrttXtEwDazwebXfg62SYBdwRxqcFMCD70BXDJ5kkatsfhpjxsx3VnDqXmNcunK/smbik3gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NH2pSWPPd1U5Ay1vV1GCgzgKCKbfjSLDTmpJtUu7nSs=;
 b=V8VRDgQzfIaw8Lb1a9h3Sl9+bl+iUF1cJ/N3ipvSfW43GaJ6MTvRQ2anA35o1P+66ZLxG8H6Qj0U71uNrcFyN4zG+IqlChKiQzA+FDCEdLlDOUi221+bApvKOryn0oFaDkyMqw/kOPXd7m/hsvjLoAkeNzS2TGz9TswfXrxjKA8=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by MN6PR10MB8141.namprd10.prod.outlook.com (2603:10b6:208:4f9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.18; Fri, 25 Oct
 2024 23:27:33 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%4]) with mapi id 15.20.8093.014; Fri, 25 Oct 2024
 23:27:33 +0000
Message-ID: <e9f8e404-50db-4e0f-a5e1-749acad49325@oracle.com>
Date: Sat, 26 Oct 2024 01:27:31 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 3/4] system/physmem: Largepage punch hole before reset
 of memory pages
To: David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: peterx@redhat.com, pbonzini@redhat.com, richard.henderson@linaro.org,
        philmd@linaro.org, peter.maydell@linaro.org, mtosatti@redhat.com,
        joao.m.martins@oracle.com
References: <ZwalK7Dq_cf-EA_0@x1n>
 <20241022213503.1189954-1-william.roche@oracle.com>
 <20241022213503.1189954-4-william.roche@oracle.com>
 <0cda6b34-d62c-49c7-b30c-33f171985817@redhat.com>
Content-Language: en-US, fr
From: William Roche <william.roche@oracle.com>
In-Reply-To: <0cda6b34-d62c-49c7-b30c-33f171985817@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PR3P193CA0059.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:102:51::34) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|MN6PR10MB8141:EE_
X-MS-Office365-Filtering-Correlation-Id: 6138fe19-18a8-472d-7bb1-08dcf54c99fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZmFoSnFxOWNYWU5RTmtMRmhhdkF5NnVPNm90Z1RudjJ1MDkvVERFVWFzTTg1?=
 =?utf-8?B?TklRVkpDTVNkWVZ5L1BIeXFlZUpVV2pjTW9ya0d1aVgza3lYWGQ1ZEdlSjVP?=
 =?utf-8?B?TXZPRVRMdFJhL3hNY05mRVB2OWNXSFdDNnM2aTc2NXV5aVlmd25pUkxvV0tS?=
 =?utf-8?B?M1JRalhtTEZnWW9odHFrdW45eEJUcHMwRE5HTkxVeTZRcXlIb2E1UStwc3hH?=
 =?utf-8?B?NWJQazNIS0pFeGZjVmtoa2NUalcxVnRMdVk1MU9ZbGtTZ3RzZUZaRWVWMDF6?=
 =?utf-8?B?encvVGJvUWxSVXFWSzY3aGF5QkxmSnNXYzI4Umx0ZnVlV3ZzOWZ3SmVYYzVO?=
 =?utf-8?B?RFAwMnJQUWoxUWdlSHBDdkpXU0NYTTlaUFZrWEtMUUgzM1laMysxV1J3SGtt?=
 =?utf-8?B?SHVTL0xTQmUzOWJoRGFqeVRKdHBJRXpubnFMK25iZjViTCthajg1NVZHeURV?=
 =?utf-8?B?VlpGYnNFcnpWSFZ3R2JvREJtRDdZelBkL3RCenF0WDhSU1diT3QzbzJHdkNR?=
 =?utf-8?B?STRNZTlxeDd0ZXFKT216QjhqaHplY01jSkNxY1hTUXpVMDZBbmlLeFlrZjVU?=
 =?utf-8?B?RHZFZ1gvRWkyQUJWL1o5K2Uxa3hvbEdZUElIaFJvVVRBMkZjVlRLdnlVV1RR?=
 =?utf-8?B?QmlOdjlqeFNPWVJLWU8zNTE4alliNW9weFlac1g5T2RXRVp4OXM4cFkwcDFP?=
 =?utf-8?B?cXZkditTQ3hxQnVWUi91bXcyOGZFTjlvYzlEbC9vVElQZUhqeFNaVUdLSEp1?=
 =?utf-8?B?S3hQczIxYUtPOGNuYmVKLzlEakRuc1J1UzZhN1k3aHlaQ3lNVzk0R3BaWkhY?=
 =?utf-8?B?b0xIc0ErUlhVYnk1TUkyM3RaNnA5SjZNNVMxUzBURHFlRTdLNlZwNVpRbWpC?=
 =?utf-8?B?V3c5T1NtSkIzMCtEL0tEVi9UeWlhRTZCOHNpVXdnenN5b3BlUHZFbzAwN05T?=
 =?utf-8?B?NnQraXI5QmkyRFpKOVlHVDF0cmlXNUFoSFM3YWJkY1hjcFFoRFJIMjUwWmdz?=
 =?utf-8?B?RnR2Y0pSTkwxTDR2ZUpTMFhUaWlPaXo3L1RISmFHTE51bVNYakRBdmhtQ1JN?=
 =?utf-8?B?dm15YlJ6K3BXYW1LbUd2d1FqcGFHVFYwZFhHRFVDTm9hb1AxR2RlQ0Q3TTBx?=
 =?utf-8?B?S0czTW5NQmFoV2FMMmlxaFJMOEVJM1MrOUU4RmZPbnArVjY4eHZ3aUsrcmZE?=
 =?utf-8?B?c0ZPWHhxWDJMSWVYcWhtOTZpZkt3Uk12NktXN2hPK2FiemZaTXg2L25ORU02?=
 =?utf-8?B?MFRsTWM3R3NlVGRhUm1ScGhXSklLejJCU3p6TjJUYmt0THJKMzV2YVdqdWxL?=
 =?utf-8?B?b3VLY2ZtdUFxRnRXVG5YSFJiMUpNRDFGczVObnJFcWdrcnQ4TFNpZXBMaXJO?=
 =?utf-8?B?eG4xNERROXlNa2xaY013aGFUY0xPUXZHTXVZQkxuaVYxWDFwQi9wS2hoWFVG?=
 =?utf-8?B?Wm5leWpCdjU0NWVtVXJJZitoTnlsZHJlMk1JdGNGSENaa2FJK1R4MDRsUUNq?=
 =?utf-8?B?bGtXaVd2OEVYQ3V3NVJHb1BaYmt4bGgzRHFMaGd4VmZyRENSMXFlNHEycUpV?=
 =?utf-8?B?UVdGbnZXZUNPREZRSkN0MnBMcFdRZzk5YU0rTW9lSW5XVFRhVXZxQ2x4Wjlo?=
 =?utf-8?B?UG5kZk44K2NGSno2b1FQa1hXQ0dKcVZBTkdXNDJULy81OTV4T2o2Z1dIOHdS?=
 =?utf-8?B?a0p5dHNnZmpVV3FTT0pFeFZVN1ZTVi9UK29vNktUaDRPdTRlNndyU3VVbHBI?=
 =?utf-8?Q?rsm1OcJme/qOP6i7Vi52N0HXir9wMt53dOfqIhN?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?anQzQUZlZTk5clplNWkxelRFMUp3T3g1cExHcEh4cGUvOCtQK3VQYUxhYUlP?=
 =?utf-8?B?MGdyNzBzSUJPMUNRTWlKNjBqVDVHck80cTBjd1RJcGJBVTlTSEtLUXlMMlVm?=
 =?utf-8?B?SUtzelhuSkgvRmJMVnBqbG9XWERPK1dYRW41ekczYkJlYTdxSkRiZ0ZDMzJw?=
 =?utf-8?B?NmdFV1BTUStuZ3ZMQzBqUjdWMitxem1lOE9wcDdWS3dGS0RjLytZNzA2ejZZ?=
 =?utf-8?B?QkFiR2Z0U2VyMmNldXdVN1RRa1p4ZXRaTU14dUhxN1JsVlljbGtwSGdhVWpw?=
 =?utf-8?B?U2czT2ZRTDhweWYrMDJ2cDdoMnY0d1E1VldaUWlDTGg3cmFsc1V1SHhHZkFq?=
 =?utf-8?B?dUE3NkVMUDZ6MVQzVHZ1c0N3aGg3cVhLN21xZXJSY0tabE9MT0s1SVd0WHhF?=
 =?utf-8?B?M2lWemVrMmFidDloMmlOUCtiMmpuQ0ZEeHNuNklWcTNhK2JqdWxBZGw4ZnJ6?=
 =?utf-8?B?M1Q0WDZwdlYwSHViVUloYy9YSWtiZW9NK284djhpcDJRalpHcHRWU2l3WDVk?=
 =?utf-8?B?cnpiL3NpMmNVcVRSSG9kdnF5K0Jhd3BycXAzM0xRQmlzbXVsRVlzWTRlZk15?=
 =?utf-8?B?Q3RyL3QrY3JMSFZlTzlmclFpYzJsVWVRQjJTeERhd2U0YXhSVU51SlRxRFl6?=
 =?utf-8?B?cXl1blI5dnlkRjBwRmhRNitRcUIrRVdMUmtiN0RENldlbFJPZlRwam5vUmkw?=
 =?utf-8?B?bEZDSFBRY3FoQS9NWjBIaTB2SVNyTHo0cmFvRWtrdHJwQS9sVHBYWXZqYmpz?=
 =?utf-8?B?Q1FLbWtYNThGRkkxaThaNDF3cy8zVS92cFByK3NWYVBvaU5wdUdnS09iY0hX?=
 =?utf-8?B?SkpmMFMxUjlGaDlnajYvTElHUUZCNTBiN05EdDE2Rjl4THV6U0x0UmRsc0xs?=
 =?utf-8?B?T2l6U1hrK3FyUDVSVDMwbFR1T2pLeFJUaER1aHRrc1JQb1p6dTF0bXI3TWJa?=
 =?utf-8?B?NkV6YVVjZGN6MGhpaVloTS94SGsyTlZ4SzVGcENaZVVTVnZId0FjRFlRWWtS?=
 =?utf-8?B?WUp1OVZiSVRlN1NaSlB6Zm1SaUtLZG9xR0tQTnNLM1FLeGxPUHR3MmNXcm0r?=
 =?utf-8?B?d0gvMTh4Wml5c1NJTEtOS0x3ZUZIWTM2QmJjN3J2aS8zL0NOaG1lanR5N2xl?=
 =?utf-8?B?Y3BBS0sydVF4RmNPZnU5cngraDMxQlJIMm1mb3oyM3ZzcFBpd1loWVA1aytT?=
 =?utf-8?B?YU90UVJHS3ZseGYvTzVUYzczdzVQc3RKUVd2aDdsRjZzRHppc3pFRmpDZlU4?=
 =?utf-8?B?SWFqc2FGSGRFbFNmSmFERmx4SzRJcW15TS9TblJiZkpTREpkWHZyT2RXKzJJ?=
 =?utf-8?B?VVVHY2JodHFyUWxvU3J5VTlicHY4S2RKbXl1R2RtRlQ5eWRTT0FzcDdMYWQ4?=
 =?utf-8?B?Tzd2eVNuWDNWcGJWZk1QL1EyUUlHY0lTc1g1UXRsQm5oaUs5QnFNc2d1L294?=
 =?utf-8?B?OU1jUVAvK2dSVFVYLzJJOXhoVzhvbmpBN1V3VTJjdnV0Zmt0NVFsRGtHenBH?=
 =?utf-8?B?TE1UYXJlNFoyQ3N5Y0RCaUl5RFhCT0xlRWcrWVpwSVVZMWdLcUZDYXh0amxj?=
 =?utf-8?B?R3lEWUxXSUVqS2xXSHhDY0hTdzE3Rm5MSER1ZnhNOWdLZVc5VnVYcEUzdEwr?=
 =?utf-8?B?RTlpK09NYjdnZ1ZvZDl4d04yNldaamREYU52ak45TnN6Y2lmNEdYRHBBNXdx?=
 =?utf-8?B?ZEhoSmc0Vm5DelZpNVBjZS9GWGF0ZFdDYVp3R0dTK0d2YUQyRlpGYlRZZFJU?=
 =?utf-8?B?TUdBd3VjcndEcnB0RVNPTEwweng4T2x0UmpDNHJtaVRtL0tNWnZORE5PQ2lO?=
 =?utf-8?B?Tlhtc1JnS1hyaFR6MFJtbHVKRFV6U1ZqdzNZWUFHM2dSZ0tlTEVmUk5GWTY1?=
 =?utf-8?B?MHliaEN3MVgxSFJBMDFJcTVNNitHT3RDTVpSMjE3dC84dWZpKy8yRDM0WVJ3?=
 =?utf-8?B?OVFXRnFaYldteSt0K1VLZkdiell6Q3JoUVV4WlJzQUFwMzJPK01zSzFTMWxm?=
 =?utf-8?B?V0pnN01NNDR4SUU0cUgzZzYzaktCOFM2eTRLOGRUWnMzY1hiSUF6Z0JKVldn?=
 =?utf-8?B?U25BM3VFaENzdlBhc0FSRU4xMDF2N1UxOEw5WWpuUk1Bb3FCVUZUQklhUVc4?=
 =?utf-8?B?Wjl0Q0MxT0M1Ni9kUWxSTjFpblJHZ24wVDdGQ0pWTW9mV3FVWFNEdFd0NThW?=
 =?utf-8?B?Wnc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	KTdeZ82Ix8EcQsDJ7np5aav9v8DQqU3jmzsKed2bzmfHOhp3caaQlnZiQQ0ERdmJyymcP5yK4JMvO/HsG1EjQvyhxpieKLHWq3Ej+72cwO6Atu1+I4lzgeHqAIPRoYCOZj4Q2MSxmLFtx8H0OU+PF3KrSsrI8OieNZ/OiXgaj4tx3DDYncrvL4IXHEXkLzXPvayQUka4y4oe2pZ/iVJoRF8ZRjpdApxsddJQvEa/7ca8gZQdH/Yqst37Ja9E5NGpq+EF7Y6kdbxQOkp3TArOzXrTHt4BNKoKyjFakwkO8rh3jTxM9vQUPkeLSvcC0RA94AKDU+pAHSpLYBhoLrKwoOvSYB4P7OXbnzWlhksTkysu1E0wUbGCebzEHRRUEGS/ri6KwV8fkuY3G0n2nc13fBTJzW17/STsNtfvQM248KZLfP7QehysVxnO1k0B9CXaBX6oz02nfGWry2ikOtV/WpdliLV0Aiz1YC6q97+8weRvaJn8J5Xfe0cjhuEpdLwKUciqZ+nnhbgDfgCNJECPe+w8TYfIVeUQRWv1/6mpysIVqe7VTcqI7AWvkuU7DwEy1xbcapbzhSJdX2f6sW9ckYdDbYeIM+rySEZnK6CuFjw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6138fe19-18a8-472d-7bb1-08dcf54c99fa
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2024 23:27:33.0596
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /4N2zUgWKZ4OcAt+I9L8vgEZj/NiveuY6fWxTKMCZRfxzbGa7vXWbEYzmZxQI/nC23mTVpGxrp+agmey3NlF82iyKAsLOX9VHX+CPvbvX6g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB8141
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-25_14,2024-10-25_02,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 phishscore=0
 suspectscore=0 bulkscore=0 adultscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410250181
X-Proofpoint-GUID: _aDqjkFImmU5D5axMs9_rI4YxKFAivFM
X-Proofpoint-ORIG-GUID: _aDqjkFImmU5D5axMs9_rI4YxKFAivFM

On 10/23/24 09:30, David Hildenbrand wrote:

> On 22.10.24 23:35, “William Roche wrote:
>> From: William Roche <william.roche@oracle.com>
>>
>> When the VM reboots, a memory reset is performed calling
>> qemu_ram_remap() on all hwpoisoned pages.
>> While we take into account the recorded page sizes to repair the
>> memory locations, a large page also needs to punch a hole in the
>> backend file to regenerate a usable memory, cleaning the HW
>> poisoned section. This is mandatory for hugetlbfs case for example.
>>
>> Signed-off-by: William Roche <william.roche@oracle.com>
>> ---
>>   system/physmem.c | 8 ++++++++
>>   1 file changed, 8 insertions(+)
>>
>> diff --git a/system/physmem.c b/system/physmem.c
>> index 3757428336..3f6024a92d 100644
>> --- a/system/physmem.c
>> +++ b/system/physmem.c
>> @@ -2211,6 +2211,14 @@ void qemu_ram_remap(ram_addr_t addr, 
>> ram_addr_t length)
>>                   prot = PROT_READ;
>>                   prot |= block->flags & RAM_READONLY ? 0 : PROT_WRITE;
>>                   if (block->fd >= 0) {
>> +                    if (length > TARGET_PAGE_SIZE && 
>> fallocate(block->fd,
>> +                        FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE,
>> +                        offset + block->fd_offset, length) != 0) {
>> +                        error_report("Could not recreate the file 
>> hole for "
>> +                                     "addr: " RAM_ADDR_FMT "@" 
>> RAM_ADDR_FMT "",
>> +                                     length, addr);
>> +                        exit(1);
>> +                    }
>>                       area = mmap(vaddr, length, prot, flags, block->fd,
>>                                   offset + block->fd_offset);
>>                   } else {
>
> Ah! Just what I commented to patch #3; we should be using 
> ram_discard_range(). It might be better to avoid the mmap() completely 
> if ram_discard_range() worked.


I think you are referring to ram_block_discard_range() here, as 
ram_discard_range() seems to relate to VM migrations, maybe not a VM reset.

Remapping the page is needed to get rid of the poison. So if we want to 
avoid the mmap(), we have to shrink the memory address space -- which 
can be a real problem if we imagine a VM with 1G large pages for 
example. qemu_ram_remap() is used to regenerate the lost memory and the 
mmap() call looks mandatory on the reset phase.


>
> And as raised, there is the problem with memory preallocation (where 
> we should fail if it doesn't work) and ram discards being disabled 
> because something relies on long-term page pinning ...


Yes. Do you suggest that we add a call to qemu_prealloc_mem() for the 
remapped area in case of a backend->prealloc being true ?

Or as we are running on posix machines for this piece of code (ifndef 
_WIN32) maybe we could simply add a MAP_POPULATE flag to the mmap call 
done in qemu_ram_remap() in the case where the backend requires a 
'prealloc' ?  Can you confirm if this flag could be used on all systems 
running this code ?

Unfortunately, I don't know how to get the MEMORY_BACKEND corresponding 
to a given memory block. I'm not sure that MEMORY_BACKEND(block->mr) is 
a valid way to retrieve the Backend object and its 'prealloc' property 
here. Could you please give me a direction here ?

I can send a new version using ram_block_discard_range() as you 
suggested to replace the direct call to fallocate(), if you think it 
would be better.
Please let me know what other enhancement(s) you'd like to see in this 
code change.

Thanks in advance,
William.


