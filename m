Return-Path: <kvm+bounces-27765-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D738798BA93
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 13:05:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 704DE1F21099
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2024 11:05:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18C861BF32A;
	Tue,  1 Oct 2024 11:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HOwUToR7";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="AUaQS8JG"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 512DA1BE870;
	Tue,  1 Oct 2024 11:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727780708; cv=fail; b=H1hhHEeLrtCprc6kG9FutC4eCavu/U0OmqpAOlKSXWOF87VArPP2F6fk5VkRXanO7RFwIw9YlRGiVcB+BmlTwQ41PdcszwQdGoE/r1IPyYbyvz0OtAVNwo+uyblF7g7wf3e8BkVxgSNmzCczGhz6vlpYyN22j6cOJQ5UMVDGed0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727780708; c=relaxed/simple;
	bh=EW27sVMljnxG+M9+vaoAjadhwnXi3rntU/oL5X5gwBg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NrgE0C/g3PrFeB3tlg0M8kNQfNKSwHVoYDfB50U6aoMlGq6w7PsdYadXue14dcFmb8pyARPB4o9hTG/Elg+VCoB79z3GKo+lFHAZ2tcHf6IXISTztGOuzT1gXIF2jZxBJkb9DkoEtGgOeeNbPxJPuFBYZqKDFWQJajdwsELkvTM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HOwUToR7; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=AUaQS8JG; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4911tbQG024908;
	Tue, 1 Oct 2024 11:05:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=jRix2NnLk3TIOzSQstdWeqOU3FvT610zTPQ9LFJIjkU=; b=
	HOwUToR7b6gkb38EoaVTGaDDA2BsqCXIiZcjTtn2rHnQrPajCG3ROvLII47xhwfT
	ZfRYIRjFV22/fVyFEWtHeMjWQaVNAQJQI8vbxLfQr7bx0l1NoYPD9WgFhFGCmqJf
	mWEHPQAtkIMqbA3cZQY22xEY5OEcKcN3AGUderUrnNrmpuqKdJREXWPKsnQ9MYES
	/EJkouvywnhQGs6is3/ZDYMRYNh2SPelr+PQJSgdBBO2ut0jw9KOXWNLUfpyWflx
	B77M2yRogFHk3e4qgGXZXM3x4tukBshJKYxOq/DYGmNIBLjtb4gWzw9jtrjc7LhS
	FRWGLlZqfWcIKy2oekJRIw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41x9p9nujj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 01 Oct 2024 11:05:01 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 491AVB4i040537;
	Tue, 1 Oct 2024 11:05:00 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2040.outbound.protection.outlook.com [104.47.70.40])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41x887bty1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 01 Oct 2024 11:05:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y+FkkNL2QvLt3QWN/Ng3Z4FlNwTe3hE4r+Rgod+xzsmflB5uzt2OUlM/0vdH/66+QOv7quCWdFzKK6ln65RIDVHkv285UlInjL6sHdyJdw9neJUpbIuemuSBBQj8mN6raRABE5VXhpuABxE5wbiWn8Hq47ofIeFgNNpEkSIshQPkfrPNoV8S3LR6upVqwZJjcGp4ceY7IscTRrPXTGaXpjBNqED1NE+aY+ZLpWvcP/JEOylrNEaxKmIO2Oj2upBwmc7pzZfBiOAAhYd0Dy6/afwVZf95ZSjSim9wp1a5SlU1CWAcD/FLgcUPJdBzbbWxmBGdHl+r1eEPmG0j+HanRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jRix2NnLk3TIOzSQstdWeqOU3FvT610zTPQ9LFJIjkU=;
 b=C//NzIK9pWf8r2BJHc1EhqRAzeXJZ1YjDXsGNVUtLh6r/aHdb1i3FJoHGexuXJQq14Lbuu55pyv93JkLKYrbLacoWvN+FScYuS8c4ucEf7mTUqL8FWu2K/sTqLO88EuDpkAE42BEElUTUtzAJwVkBeCJ4XrdH57l47AWYFmxgsjD2adjcw9/cmxUyiOnpLsow19ypGffkSSNE6JQ+nHwOuz3AzZyhcD3/6smd8HdHTpKrnaWt5+7bmfrnY+lmQHqMUBZMNg18TyvfG1QBdPsS7X/X3+BI1L3uxxZjsmh/v3y3FbwG0Y2j1SiI6NaWpdN97j0R59m7UVKTFDbmlGvhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jRix2NnLk3TIOzSQstdWeqOU3FvT610zTPQ9LFJIjkU=;
 b=AUaQS8JGT7ddfwnzF98R+poOUUxdhJwY5I4pvk8huLI8BS19/YVP5LM5qJmPQw6M82SnJhVl4wAvUBSjeZmpcOwAIBw5YFsHI9VmPwWDN+xxdUb30cMiBjzmAQ8nzFW1qkfwgroKYpiAq9DAk18MOc+1In7E+mzNqPm6RSjelsE=
Received: from PH0PR10MB5893.namprd10.prod.outlook.com (2603:10b6:510:149::11)
 by MN6PR10MB7490.namprd10.prod.outlook.com (2603:10b6:208:47d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.15; Tue, 1 Oct
 2024 11:04:57 +0000
Received: from PH0PR10MB5893.namprd10.prod.outlook.com
 ([fe80::79f1:d24f:94ea:2b53]) by PH0PR10MB5893.namprd10.prod.outlook.com
 ([fe80::79f1:d24f:94ea:2b53%3]) with mapi id 15.20.8026.013; Tue, 1 Oct 2024
 11:04:57 +0000
Message-ID: <2d5f2f91-2c3a-4b0e-bacd-aeac6d4da724@oracle.com>
Date: Tue, 1 Oct 2024 12:04:47 +0100
Subject: Re: [PATCH] KVM: SVM: Disable AVIC on SNP-enabled system without
 HvInUseWrAllowed feature
To: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc: pbonzini@redhat.com, seanjc@google.com, david.kaplan@amd.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20240930055035.31412-1-suravee.suthikulpanit@amd.com>
Content-Language: en-US
From: Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20240930055035.31412-1-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR04CA0002.apcprd04.prod.outlook.com
 (2603:1096:4:197::17) To PH0PR10MB5893.namprd10.prod.outlook.com
 (2603:10b6:510:149::11)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5893:EE_|MN6PR10MB7490:EE_
X-MS-Office365-Filtering-Correlation-Id: 92a63d18-ac3f-44c3-fca9-08dce208e2f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?enRTU3EzeElZZ3VaVnZxdW9NcG1MK0xQbWg2MXc4UDhub0NwRE1EamxjZFF5?=
 =?utf-8?B?Y0E0L0lQZnpIOEpYYTF4d2llNjQrT0J0TkVxcHpRcXlTL3BKYndYOTg2dGZr?=
 =?utf-8?B?QTJ6NU1WV3ZVQncxdlBzblRkamVOZHlkTGUva292WXo4cXcyc3p5R1BsUDhs?=
 =?utf-8?B?dXZCM3hHODFBNlRIR3NHT0RpVS8wRHFMTjgxWU9vM2FyYVJwY2VOc2pxRXhy?=
 =?utf-8?B?M3ZqUy9pSXB0Q2R4b0FidFk4cDNUQTM3VGFxVVpHV3RYL015eGtjeTNwb1RT?=
 =?utf-8?B?dWtwOXVObEljWi8vZVIwSzJ0UzQxR2tmS1JWcC9JYi9UZmZTV0Z2bEhOVlhn?=
 =?utf-8?B?L0MwOHVSa05Bc240VXJsa1lOYjhYaERtZ1dhcXZWazZ0VE5EbkUwM2FmcE8y?=
 =?utf-8?B?WEk5Qjg4T2Foc1V5Qk1oazRvZmlrTE5iUWlqVzZHRzdkbFZ0TTNCd0t5TDZC?=
 =?utf-8?B?ZTVOSXVrOXJJMmVIRjVRYnhyMmx4dHlwZS9zNkZTMTFYcWt5WDBpbWtNZUMz?=
 =?utf-8?B?M3NUZzF4TjdvZE9xcEJKTkFvK2pyRXN6TCtrN0Fld2J2QkpqeFU4WXRQY3JX?=
 =?utf-8?B?K0IvUHl4a2xxMjY5RzVUR0hYaDE1ck5lUzdIQ1Z5N01yOGxIaUxrYWF4dlRm?=
 =?utf-8?B?MmpVWHRXaElCSXFMNGRGZXFCck1ZYXZObGM0ajEycTNCSDJOZktaTU9DQnJu?=
 =?utf-8?B?Y3ViQ3VhUytJZzVwRFNHOWg3K202aU44UHhraUJNQzUxa04xRU14ajNsMU01?=
 =?utf-8?B?ajhOUmNsY1l3bHBsZlhTMzRBcERBVzJDdlg5clpwUnV0VU9uc2hWZEtXZXFZ?=
 =?utf-8?B?WFJtUmJuSVEvcG9Na1U3THFRU2I5Y2ZVNzFzVS9IOG4zaW5TRG1CNXcweUl4?=
 =?utf-8?B?L1ZRRG1mcGdTQklMYjRpUTJDeHlQaUR4cVVIRmNpOFkwRFMyM2lzaGU0Z295?=
 =?utf-8?B?b3hsVDlEMVdDUHRSMUpaWkNKeGNSdk12UjBiT1BhRjJnNFVtdXNXSVFiTzFi?=
 =?utf-8?B?ZFpZV1NqdCtueitjdmN3Nk8wWFhNUTFyVW1yMCtmam8vTHNhQUk3U1k1bU9v?=
 =?utf-8?B?SmFDb0R2bnE2Y2pIUGJ6eWNha2FHd21WdnQxbzMyc2U3YjVyemVxQjNhSm5p?=
 =?utf-8?B?VWFmRmFHK1dSWnBNelJyYXY5b28yWU5vQjQ5ZUhFQnpXOUF4N3daY3AvYlRm?=
 =?utf-8?B?Zis1VHViN3VtM3ZsVWppSUtnODRIMWVOUWNKN1pRQ1U0LzkyMnNSMUtORXF0?=
 =?utf-8?B?dGpUQ0EvdlBmSDRMU0FjZWFnbllLTUhxOTVsR1RSM28vaTdJVVdhTlBwOGcr?=
 =?utf-8?B?NXRubzFWQ3lCWDV0V1hCdjhhV1lyaVhqMWxTaGFCNUFzSFVEK0ZadzdwU2R1?=
 =?utf-8?B?UEl0cDIzYnRrdzl5K1l2bG96SC82Ym9YVXlBdkNSZzgrWHFUQ0kyK2lEN2d4?=
 =?utf-8?B?ZkpwYzdPN0IyQ0hhK3QzcElSU3ovbkZLOWFSZFhFbm9hanczK2Z4OW1RUmxF?=
 =?utf-8?B?WXozMHFEYjZsQkZjckdreUUvbUxDM3RNQXRjeHA1T0dqYUVaelpaSENhQ2Mr?=
 =?utf-8?B?WUplMm5EV3kxME5RcG1QeFpybkEwaURTcy95bXVoSlNYNjFWME5YaTVkaS91?=
 =?utf-8?B?N2RxVjh6eHdQNW5BTCtRektYRW45VmU2OHUzcVlUQ3ZtcEF5SFVBaUNSUFh2?=
 =?utf-8?B?NytuZ3BXelBiUzltTHI3RmVkd2JFT2xEbndBTEZ0bmxNRW9Vb2tzS0llWVVV?=
 =?utf-8?B?Rm9lL2lvLzRmeG9ZZjloNmFoRndzWVNZSjhGMWx1TjNiV3FKdklSS2dJb3Z0?=
 =?utf-8?B?UXluS0I2WVVvNHk1VjdjUT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5893.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Wnc2TGhIMFVDbWtJZmVmQmFvZ2tYUFdrTFNDYjAwV0htaTNObW9WejNIcUVL?=
 =?utf-8?B?aGdYV1BTdXhWRXV3blpINjVsSkFXZERIeFNSQ3BHcDRybWRvd3ZCVWZQam90?=
 =?utf-8?B?K3VMQzdmcjBXRFZUUnFaTWRuWkxpYm9VK29XZ1k3YWFNUDRYRlpDTjZyeTVC?=
 =?utf-8?B?dTI1ZDJuN2pMdi9VVjBGZVBXVWJ2NzdOQmwwWkJKWFR1eVVHdWxrWHBmbmNH?=
 =?utf-8?B?aURLMWd3TzRVN050SW5mclJVWGtxZ2JlVjY3S0lwcUdzUUR1REdXcWd6QS9i?=
 =?utf-8?B?NUlZRU0vRmg2czFydjhWWnBuR25CQUtOY2Vsc3JhbG5weWxGSnlrcCthQTdq?=
 =?utf-8?B?WWhGWnJtVFE0bVdkK0FHSkFzR284YWZLQnhlYlJtMG9lUktob2g0ZzNvTnhm?=
 =?utf-8?B?ejZEU0hwRnd0NXpPWExtVEMyeEZIZ3JsY1VzY0tkWHJ2STExdGxyeXFxYlli?=
 =?utf-8?B?WEYzV3N3Q0F3STllV2FqTXI2S3RERmQ2N1h4VEwrUWw3bzA2TGhoMWJSVmlU?=
 =?utf-8?B?SFE3SGhKMW5RL2ZkenBqbmpUZ1VxWWpIaGVnZDhSM2c1dGhOWWFpM1BKV1Qx?=
 =?utf-8?B?ZHl0cmtRVlZVVlBKa0g5ZFRRZnA5Mlo2MzJQNHpQbW1QbmhYNlE0aXNyOVpR?=
 =?utf-8?B?WWRKaVBWdEc1TWM5SGZKSDBySEhrZW93Y2NUMHBBbTgwN1V3STBrbER3bnp4?=
 =?utf-8?B?RWRQSTFRMk8va0o5WVc2T2xaU2dya0xrcW0xY2p1amZWbHQ2SW1WVzYrTU9s?=
 =?utf-8?B?cmN3RWYxL3BiN2lqWnhBb0J0OGI5M1JQYjk4RDJROGEzOVdTS0pFa0hMYlhq?=
 =?utf-8?B?ZlVnL0dLTXoxQjFJV0w1UE1RQ1piTjdFdnBlWkVaVFVKdE12UmhmZlNsd2lr?=
 =?utf-8?B?WDJrdmdLUGFlZjdlcThOTEtyMHZkcE9wRzhVa0x4d01YVytVSTBMa2FkVkRt?=
 =?utf-8?B?eklaeE9UelB2emJWb0Rnb3FyY2h1V1BxSjZnSjNyNmxubjFIK29DRzJISXhJ?=
 =?utf-8?B?Z0x6eDJGK0s1SW5tSlg4OHY4NHF5QzVEeVhkS3BqRGpVaENmeWc0bi85ellx?=
 =?utf-8?B?ODBZUms0bVBHNEhBaFFrZ0gxb1FuSTJ2eGIxc0dvdlcxdkpHMWR2OWMydzY3?=
 =?utf-8?B?dDFPUmpMYndQQS9wVStUUmN1NGNLYjVNSkdiWU1IajV6TGNLYVZPdkRMaEN0?=
 =?utf-8?B?eTF2Q3hjdGMxUTZ1NitaZldmby80cjJJUEFvSzdtaDNsZ3pIellUeVJXZDYr?=
 =?utf-8?B?L3Z6cVBseFpuZ01LRmxrTkRqc3A1azQzek9Qb3ZJNUg2STNuZ3hDNHpwOHJM?=
 =?utf-8?B?U3Bvenkvajk0QU5kcHlYV2xSK05TK3pBOGJUcHVQRlk0QUFsNHNtUVl5QTdt?=
 =?utf-8?B?V1U0d05iMVdQUkh6c0NKd3lWNFpxbmpkSzZEemliMXk2aC9scjBBY0JLUG9Y?=
 =?utf-8?B?blNTM3IwTExkUmZLUU1CRW95bytOS0xkSXpjRVQ4enl3QnFQWGdYMjNyYkJh?=
 =?utf-8?B?d0ROSXdUbGYvVnY5TGRCL3JDT0VwOGJvKzNLTDE3QU1OMzVVL21mZ1V5UUJC?=
 =?utf-8?B?dWpNbW1pcCtEbU81RzNweTBmbGgvZUJHUkpxVUFsRnlaN1dqM2RCTFpwSTJv?=
 =?utf-8?B?SGRYVGxzM05ONjFJYzhqd3Iyd1duZjRtYnNkRnpvd29sQlZhLzV3OXNZKytu?=
 =?utf-8?B?WXl2SmVTSy8wcThEWjBwMVBlRDRBYnFrWTQ1emNGa2lWZkxtaFRLSFdsNFp0?=
 =?utf-8?B?RjRHUVFweG5YL3ZBa28yOGZkRjk0QnlLVDc3SXZqQVBHQlFyNW1yeFQ2bHN0?=
 =?utf-8?B?bGdZMlZpTno4TWwycmpXNGdvNWJaTEVoOWczY0xXU2FjSUgxc21DZy94VzRZ?=
 =?utf-8?B?SXNaeHYyMFgyOU9UT0xoRTFZTmFyUEhaeWNMVDcxKzdrTm5RQ3FzUjk3MmRQ?=
 =?utf-8?B?eVliSVhxY0xsdXBwWnh0RVMvL1g2VkdFVFhoeWdsd2U4S25mNFJNZFQ4NDEv?=
 =?utf-8?B?bVhwUkJPVDF0RzZ6c2lTeTVnMVF4eEdqTFpUdkFwYWxnaWJObnZZVnA4Mkg5?=
 =?utf-8?B?Yzc3ajk0bGk1YndNNTlPZW9YT2t4Tmx4K2xRZ1JjWFVCT2ZwSGpJUzdPU2Zo?=
 =?utf-8?B?dmFTT0RDM2N2MTVnTGoyN2JoWk1CUjhrNlIwSkswQ3Jqbk02TnpFbk5EYVRC?=
 =?utf-8?B?bmc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	l6bUFMhC58fFNx/rO7VwME3ppC/0Ry/ytxGVrQ7nOQynEtrOi0aZ3VJHkQmt/BSW+3RR05XTRg55obgW39ZFDh4P06kCpIC7b0k7/pwRBL4Os1OOpUPYUK/htuX3ZloQb4l/oYu6kbERI/CXaLaIeumZf4COSvehb+aIBmvjLkt4gyt7hakYVo7ChKBakISaJuEYlo37n09yp6mht6jZ29v0Iv4IhFmJdP+xB9aG1dHKmai7Rmzc/ClyCvsbVPsg8ZbkCeCfXMOD+RTu05eXpFvDPFIxd6EjIKYVhZOkIegqj7CEDPF5Em9AM+wFOl+rSy6pgq77leiNH3neGPTNGhj49aQC7Yy8Iy5WxHwE9XrYnpvdvq8/WwTieWvOz8Zfk+olKFerG3+PC1LWsiwmrGwAlEwiSrL0uRwClfizXJ7cKbrqeqwP0hBxiRt+rQjm942e6eAxNfbRar731uWg0uNtVIyut2Hr83uGPCmJUVllF3Mxya6syvr5pLWs31+tgBv1Ebcrq/FhNzdUZHYHvFwa6iB8D1m8jL6qq6ZFG0AsTVFi7r9RoyyzQ2L908nepMJbwUqAZDqIBUaEiwJMOREF8uuLi/D+VhZ7PdG9Vgg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92a63d18-ac3f-44c3-fca9-08dce208e2f1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5893.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2024 11:04:57.8065
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VHOTLxeKtmPjuGAwrU+5jg34erk3J0X+QJis/AkrMuBJxahjJs/SLr/accVn8hGQxshao9GhKp2NkGSw6oSGaLv+CJznsA6xxjY1doRmzrQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB7490
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-01_07,2024-09-30_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 malwarescore=0 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=495
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2410010072
X-Proofpoint-ORIG-GUID: NbOJT5ow9ZVDeyLKRZgSrfyci8LYftHA
X-Proofpoint-GUID: NbOJT5ow9ZVDeyLKRZgSrfyci8LYftHA

On 30/09/2024 06:50, Suravee Suthikulpanit wrote:
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index dd4682857c12..921b6de80e24 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -448,6 +448,7 @@
>  #define X86_FEATURE_SME_COHERENT	(19*32+10) /* AMD hardware-enforced cache coherency */
>  #define X86_FEATURE_DEBUG_SWAP		(19*32+14) /* "debug_swap" AMD SEV-ES full debug state swap support */
>  #define X86_FEATURE_SVSM		(19*32+28) /* "svsm" SVSM present */
> +#define X86_FEATURE_HV_INUSE_WR_ALLOWED	(19*32+30) /* Write to in-use hypervisor-owned pages allowed */
>  
>  /* AMD-defined Extended Feature 2 EAX, CPUID level 0x80000021 (EAX), word 20 */
>  #define X86_FEATURE_NO_NESTED_DATA_BP	(20*32+ 0) /* No Nested Data Breakpoints */
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 4b74ea91f4e6..42f2caf17d6a 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -1199,6 +1199,12 @@ bool avic_hardware_setup(void)
>  		return false;
>  	}
>  
> +	if (cc_platform_has(CC_ATTR_HOST_SEV_SNP) &&
> +	    !boot_cpu_has(X86_FEATURE_HV_INUSE_WR_ALLOWED)) {
> +		pr_warn("AVIC disabled: missing HvInUseWrAllowed on SNP-enabled system");
> +		return false;
> +	}
> +

Wouldn't be better to make this is APICv inhibit to allow non-SNP guests to work
with AVIC?

	Joao

