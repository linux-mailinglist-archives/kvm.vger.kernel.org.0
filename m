Return-Path: <kvm+bounces-68250-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 362B1D28731
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 21:38:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id AD941300D438
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 20:38:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADCFF326939;
	Thu, 15 Jan 2026 20:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="H5hk5yHQ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="FGQjTvc8"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B2B829BDB1;
	Thu, 15 Jan 2026 20:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768509493; cv=fail; b=ZtwwcLSE/chAA7QvhuuwV00KHuixNxYoofg615yx+4EjqGF9+Dg8dYOwLTRLFp2rAJPkeEJGYLkUsKNOyRB+lSgdo/9DxRQ8DRJEPNGNNGlb/q2YkEovTdqUPN4fztl8TpsBBoZ1AVLe8Bg+3RQO+l3R3U0b7NWo0NCNG/Ab/zY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768509493; c=relaxed/simple;
	bh=FqS564JS7YKijEcHjOz8nPIguS5JFySuGP0HfXV12kI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=EKGF70h2mDq8d/V9b4E+Ls3I4Gf9JWDX0S0HFoV4R+eZc80Wv02yQ4RPg0iG7bsMmmW14XTj8TU3yryI760PNyO7V660cc9t+lPi7xgXDTp0f7X1jz8MvdqXZSN6AL+0Wirx6z09WiyIq7IO2Fl1530WrxOluo+qBj+t8gXmJY4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=H5hk5yHQ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=FGQjTvc8; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60FEZDE61940274;
	Thu, 15 Jan 2026 20:37:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=UubLNfxLpnQZC9FAxkOOMXahSvNiP2wnMB9PqjaAKuk=; b=
	H5hk5yHQP8l43Ny8D+ud97xqcw3BHd/qymu9bellC+LmQ+NC7r6d79NrNPIiswnU
	+u0mhDXSHlpky43COdgZT8a2idebTcQVJax/1OjwHNG+wRdKPRbnN5WkDL17I2cN
	23gCOK4yO0NhkM2Nwpuq4JGKud4+wSYwL7w8sPWkKZaEj3K9Nb7B6aTTwig9gPik
	HXxFt9PJOfYd8Y4m5WTZMsRJ9d586m1g7sPRFMIwB6fdddyH4aLvgOc2zTRHfyK/
	lX7RWZ+hnsNZXuWIRK1Yq1rg1n81Dm5fS1YmIukFGuol+88Aokp1J8VBnAJ7eejf
	6HRCIAEe88n4Hpr2M8l7rw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bp5p3c0nm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 20:37:46 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60FKXr38000463;
	Thu, 15 Jan 2026 20:37:46 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011058.outbound.protection.outlook.com [40.93.194.58])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7fjwjh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 20:37:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bkxCi8R/VpkVZxcXRHIioeNaBAyG4DsNcesgbVjkTLsIvp72BwNUZmTw9t9HXv/d3Dk4vfgg+nq6JHFrSISa7zPloGe7yjO/6RCRT0+VzMf8qMNT1bLpvp5eXY8V4w/2iNKvfUl9Rw/F21IiHeipPLG2PLhRh4+IraEnsUIFg+3ucM4a+rzRKLL4J6FiZuwFHqNHLZ4/xelx2ROEn0INa94rIsShDK8O/FM/CqkpZjhHHXc9KSlZx7mk+5XDs4kNzgOHMMlRtfGlcz0dme8gQCrfK6KWlz8MHjkWhrb2Y0iDknI5rOM1BjupJWSRfz0badejJobJ6NNgbN1Vn8Km9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UubLNfxLpnQZC9FAxkOOMXahSvNiP2wnMB9PqjaAKuk=;
 b=tJl98Sd2R7myVOcazB8ubY7cHFNHTwXro7TKxJXPlBlFgR7Nu+7gJieRLlK/rHrQ5nzu6pY0CuhwDUqBaYevRD35L9nsfDMyn7a11YPjsdiEuEZ+lc12qa76KYLzLlKLwln8J5Qu9KWjehyYvmpY227gas9xwjV/J/7HxQ+ZcjcbXTWzK/sYS5Ixot+Y0Ll2LpWxW0UsIJfVxdmERrA1kTVr4VYYWPYR26LRa6pKaEwhGLSMYc/fSsVMAbINNdO/PpxAW9/gB2QSzRJrl3ZVmWYh0lNc+6/5dGV7gRxRUhlM8jUFHCYKpZrJs3NVaO9D5BK1ULLf42wtBBjpj1n2jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UubLNfxLpnQZC9FAxkOOMXahSvNiP2wnMB9PqjaAKuk=;
 b=FGQjTvc8KsaPcCuK0WfFpVW2sJhtRjgTdEFCG6Zn5OmhLbJzubMgEhuHrN4f9fo+XQ9nq3bLS13c+msex+faKKqbEYeTWqAWnrp1Fc7Tgwdlmb0hqbM4n7QnOiR8EGn8q2PGrVpHKbSotmWlNFlJBvX+YoMwXq2C7TR3qsc/q0c=
Received: from DS7PR10MB7129.namprd10.prod.outlook.com (2603:10b6:8:e6::5) by
 DS0PR10MB7294.namprd10.prod.outlook.com (2603:10b6:8:f6::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9520.4; Thu, 15 Jan 2026 20:37:42 +0000
Received: from DS7PR10MB7129.namprd10.prod.outlook.com
 ([fe80::c649:a69f:8714:22e8]) by DS7PR10MB7129.namprd10.prod.outlook.com
 ([fe80::c649:a69f:8714:22e8%4]) with mapi id 15.20.9520.005; Thu, 15 Jan 2026
 20:37:38 +0000
Message-ID: <cea56100-9c43-4246-912b-234c6cfdc876@oracle.com>
Date: Thu, 15 Jan 2026 12:37:36 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] KVM: x86: Mitigate kvm-clock drift caused by
 masterclock update
To: dwmw2@infradead.org, kvm@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, dwmw@amazon.co.uk, paul@xen.org,
        tglx@kernel.org, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, joe.jin@oracle.com
References: <20260115202256.119820-1-dongli.zhang@oracle.com>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <20260115202256.119820-1-dongli.zhang@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0015.namprd03.prod.outlook.com
 (2603:10b6:a03:33a::20) To DS7PR10MB7129.namprd10.prod.outlook.com
 (2603:10b6:8:e6::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB7129:EE_|DS0PR10MB7294:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d9496a4-8beb-477f-c0a2-08de5475ec55
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?d2RqakVvMDIzdk1HdVAwaUl4OXlYNTRZZ2ZiNjVSZmZSLzN0MkNOa1dvZzJP?=
 =?utf-8?B?c2VmZDN6RU8zdmtxWDg3bXVMZ1BrczAyM1NyelFXSXhXQ3F3NkNBOURaWDla?=
 =?utf-8?B?U05lZUxIdkZXc0ZENzhMbDltVk0rYmNsNmJFVkRvZVA2bk84YlVONDFYbXBR?=
 =?utf-8?B?N3dOT0hjMUFQNUFWWVB3cStyQ0RsL2hIejN5SXdkb0ZiK2RMRDhOcjdhVi8r?=
 =?utf-8?B?S0dNZ1c5YnllaVR2TkV6Sjk1MTlCbU94Z0x1NFppQktPVk40K2NXb1luaWND?=
 =?utf-8?B?ZFNQeEpDSytqTUlXcEFyUnVLenIray9aNHFTU2k2ZmdKZ2VmOE5KUGQ3cEFt?=
 =?utf-8?B?eTZCU2NOc3BBRjI4M1FlZ3Y1QW9zK21xc1RiWVVOVUhSaCtkZUhMNlJyUmhk?=
 =?utf-8?B?S0YzUzVGaHlhVTFpQU1PdjFFaWd5NTl5QmlzRXZaU0lhdE9FVDA3UUxBUU9Z?=
 =?utf-8?B?bnliVEI4dUlNTkVwM3FjakJ2ZlpPZjlPU245VVlMTDk3TDhTaUpFb0NDK2Mz?=
 =?utf-8?B?RmNLYWVaL2krMkhZZzVtRDdKdlRlTFBRUW9vNllkY0JXM0dYOGFoMEx4Rytt?=
 =?utf-8?B?RlgwU2pXTHIzUXdleXhlVkpnbEFEankwTXJXTUxLY0x3b1g1UkJ0Yi9mVjFW?=
 =?utf-8?B?WjREeXY4RVhGUjFoL1R6cDVDTkZSQmhtcTVzaU5wQ1J5U1BGSThzNDU3YzJY?=
 =?utf-8?B?RGVoS0pwZTB3Y0pFUTFGK2pQdi9QT3NtbWNtVkQ3STZBWFBHMXo1RXFJa1k2?=
 =?utf-8?B?Y0gwWlB6bnBOMzc5OTBObHovNU02OVlSbVJjWkFxc3NMMFNGdkkzWkI4Y2ZJ?=
 =?utf-8?B?ZS9zbjNWZEhZbWxQckpHcWxNVEUzdHZqelRXeHR6QzlVTW05Z1Q4ZjhoeUNp?=
 =?utf-8?B?Z2pRdU1SQjlOcVlSM09lYXN5VDNUL0FWM25XQXNTMDFJd2hXTVh5UEVvZnJS?=
 =?utf-8?B?R0xaNy9sL2JHd3FTTENvQm41N282dDJwbVdkU3ZSOElsbmhndGpnYkkxM2xK?=
 =?utf-8?B?VExQU0RmaWdvcnVBV1Y2R2J2ZWFJcHFrOXR0aHB1SFhDdzhULzJHcEdseHZP?=
 =?utf-8?B?Yjg0T1lEc2E0OXF6NUlZVStpay9HQjN5V2tPZFVwT3BxVWtHNHZUQzFKSk9C?=
 =?utf-8?B?U216L1NSb0Z3L3V6eUxCc2VxZmhEdlJxc082NGRML2liUm9PL1lncEdwN1da?=
 =?utf-8?B?dW52UGlsTzUwODJJKzlyWFh4TnZ5dEJjZEN6OTZNYmRrRTJXTGkzUlZwQWlZ?=
 =?utf-8?B?RlBUVUhaVXhqSmhFVG93M2V3QmxKMC9BSDArakpoVXVhVjY4THRYaUxlWTMw?=
 =?utf-8?B?WXFSTlNIOGtSc3VHR2hnSkpKR0FRZ2NMZEN4Tzd4VHJKVnJsM3crRFZkYkxH?=
 =?utf-8?B?ajRNeU9UTERmNFFyd3VEQ05QRE9FcTk3aXorVXQzaDB1RGp4Tzg0YmFiYU1X?=
 =?utf-8?B?U1pOYVlHdlcrNHVTaWRMb2lyNXE3SGFsK2hXTVFQT2FVQ3hpNHNRSWlkbzZC?=
 =?utf-8?B?N25SUEJ5VDRGT1Nja1o0Nndyc001TU03TzlPbUJhL3ZwZEltMXV5N1FiL21S?=
 =?utf-8?B?dDVLY2VMeUlaNXMySkIzN2dCcWVjd2RzWDlBd203MTB1anF0THo3dDlQOGJ0?=
 =?utf-8?B?M0F5S3ZzNGx0aHZQSVFTNXZ1OW9Na1c3S0h5T0VmK3hRaERnQVRwU1lVMGpj?=
 =?utf-8?B?b3FBM0ZVQnlVYlpzYVNYanhvc0Z3dDFheExjZC82Vk9KdGhIMWl0ckppb2lx?=
 =?utf-8?B?ZlRpN2VESXJTTGh1TERxWXJROEVvS2hJdkFNeDFvekg1TXNTRCs0R2czMlBO?=
 =?utf-8?B?ZmtWcTEyODk3eElYV1V2aHN3ZEZrQ1ptUzJINFJZeGRMQ1M2cU9NQ2JaUEZR?=
 =?utf-8?B?MUJ0cXJSZ05wWE5tV29jUy82dTZXRVpMY0p0emE0Ty9zRVF3a080TGtocGFY?=
 =?utf-8?B?OGZScVp3RUt2NHFQUjZQL0R3b1BHQ0lJSmx2My85ZXBXMXUwaE5vYktiUEMx?=
 =?utf-8?B?enVkN2twa292QXVtWU1lSDliOGVzYkEraWxvWklWUDgyY1R3bGJXUTZJZ251?=
 =?utf-8?B?QW9PN0U5V3FubWVYUlBtd2FsSWhidG5TWldFSnlFL0ljem5oUE40QmZDWUNz?=
 =?utf-8?Q?PRqEEi1SWZVcTxf38roXptodV?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB7129.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c3orVDFFVG5oUHRMZUFnVnJ3ZlU4L0RJMVQwSGJQZklRdjhXQ0JISnU1U1pI?=
 =?utf-8?B?aHhxNEdzblllQ1h3bFUwbTF5WDBuWHU2bURURXpoa01DNVFWemtKbE9yQUVj?=
 =?utf-8?B?ZVQwRHRpUEZUMTd6YVRuYUxvT280eVNSNjUxam15ODFpOFpxUEZZMEI2RUcv?=
 =?utf-8?B?OVNsbkloQUtmSlFMZUR0dnhibkh0VU9lbkRWVXFrSTNoMVRVbmR6US9mcUJi?=
 =?utf-8?B?SFAvWmVDdzVvVVhSS0J5WTh1aFZYNFcyRnhZajJkVE0xRG1YZ0hGQ3JyU0Ja?=
 =?utf-8?B?NE0yS3J0blhER2YrSVdlNy9PK0dRR0pXdk9tbUo4SUdQQ2JJUUpiSUo5ejFF?=
 =?utf-8?B?WnlXY0lCbG1ZOFg5VnpwcVFTYzhodTFYTGZ6VWlSOVhjZlBWUEV1TDdKQmRL?=
 =?utf-8?B?WmRFc084aE45NkY0blc4dEdtcWFteS9Ha3FHamxKb2YxMTBBVXppOFgyWVgx?=
 =?utf-8?B?eDE5U0tCdlpxR2tzWnEyVTZvWEFmQjd3dVV2Ym05Tng4VmdGT2g0amZWcUdO?=
 =?utf-8?B?QVJyc3IvSGZiWEdDU3J1QXZyMUI2OXhlTCtCeG9wMHVsb2dpU2sxRFlieEh1?=
 =?utf-8?B?OXhGSi9CaUlYYXFzVFEvZjFoM3N6L3oyeWJ5ZEg0cHhOekY2cXlCdTdYdC95?=
 =?utf-8?B?eVVrdWlyLzRNSUNIRGppb01tRWlleHNnOWpDL1dLZjB6T1M5WmU3K21EckVp?=
 =?utf-8?B?QmhNZk9ZUFNTTXRha0dvL1BrQWpTWU1MK3FoalhxZ2hoNnNweE5CRWtxNy9J?=
 =?utf-8?B?R0xNbldFMDhlMmdyZXlyOUl6YWpPWndlTGRtN0JWN2xFb2RmTlpVU3NUK3Bj?=
 =?utf-8?B?ZHppMEV2OUY0cFIwL1U4a2I5T00rMDZDVnAxNnVLRHRPVkNXdVV5aS9lb3Fl?=
 =?utf-8?B?dXg4TzNTbGhNQkFuNHA3dGdMM3BKT0pwWUpWcFdmMDQ2M0ozejQzZ0pKSmd6?=
 =?utf-8?B?Y01PeHY2dnI2VVNSa0Q3TkZqZGVFbWd5VmliblpycmdUczhZTTYyZm51ejBh?=
 =?utf-8?B?L2kyd2JTS28vVXlZSk0rN0lpZ1R1aE42azdRZGZ6amFiTGQreURGZ3FGdmw5?=
 =?utf-8?B?akJWQlpZQkp6bnI4QzZ2RElDdU9ia1liRkRheVZPY0x1eVZNN09ORGwrbzdh?=
 =?utf-8?B?Y0QrV0dETkUvbEVUMlgyT0dqUkVDYk9vNDVUeElranFKbTVzQzBkMklFSWxj?=
 =?utf-8?B?Y052enpya0JITldnSnJkTDZKK2hWb1dLNUluWTU5RGU0R3l0azdGR2l0bUc0?=
 =?utf-8?B?bDVLUmNlaUVuOTd3OUN1VHdrdWJwM2xPb0d5dVZZOHB4bTZMaDAzSGlPSmJ4?=
 =?utf-8?B?YzlQeEJGTnZEbjRDeEpuT1djK2txRVZvYUQweFNHUHdEVFhocEQzYW1LVFQ1?=
 =?utf-8?B?WWtuUGxpVEdhbUgwZDViN0s5eUJsa21tTlpxV2NyblhSdGdVVmFnSW0vMS9u?=
 =?utf-8?B?eUVDZnZkVWVqL0owNHBaUkpnUUp0NGZha3UweTBzcCs2RWJmZlZncW9vK2ds?=
 =?utf-8?B?aVZ1ZGQ3TXpBdFZkWXFzc1F2dlMrd1NmTHFhZGtNSmpNMWZqdmFjTlhaMVpn?=
 =?utf-8?B?Mm9jeUlkS2tOTGNaNVBFTkhWU2ZPbHBsYUg5bDZCQmh3bEh1T2twTUMxZTZ5?=
 =?utf-8?B?ZlZrcXUzL3FQb1MyWng0QWZXM0hOcHpxWS9uMEhMc1oyTEV5RWtEMXk1SzlM?=
 =?utf-8?B?cGZOcTMvY00wMW45WFR6VTgzbTR0RzZ3QzBRVlpWSjdpY2FSZExDdjQ2b085?=
 =?utf-8?B?S3A2MG9sdVB0aVdKVE5jMGFKOE1wTTJFbDVKVmtpcXFDRm1uejBKMzNrWUpv?=
 =?utf-8?B?TTRoWThmSUhTQmNhWFpaaE1Xa3IvU3RNU0lKZUF0bGxDWTBiT2UvQVJ2VkpH?=
 =?utf-8?B?eGdxK1hYb1FndXZyYzVnYTJZLzNRTXlPd3dHdm92YXlTWkdMckU4VUF0VXdP?=
 =?utf-8?B?WGdJYWZiaGppUFB4SmdZUUJ5a1V3U09GaDRDTzRkdXRpdENuMXp1YUxDaVVG?=
 =?utf-8?B?by8xbWd1QlNnNnNvbnI5VEpiZ3pMK1Q1MjJnMFlPOFo5a3V5OHo3aE1FdGha?=
 =?utf-8?B?Tml4WHYvYS9lZVhkTzdUT0g2OU9ad2ZVUWxnZ3JucGliTTMrZytyL0o0WU9w?=
 =?utf-8?B?OENRSGRjQ3lqY3RYeXNJMS9hTEF3cEgyWlVUK2hrdUZjcGFLcy9mNVJjb3Jy?=
 =?utf-8?B?UzFPVlJpNmpSUzIrdTkvcG4xRmhwSFpuNXhJbi9LbXJPbjhLdDN5b1EwVHR1?=
 =?utf-8?B?NU9OMktNNWw2YU9ib2cyL0xsQTlYMW9HU0tlZUpMQ0FObUxWZFBpZndBbHVP?=
 =?utf-8?B?TDZ4emNkbjZpRHFtYTFJWmplb0pISEVVUmREMklOSWthVEZETkFjZz09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	eyr+ODsr2RF44gfzVRbKL0yxTOURUaWq0dpGGgDchVpqfYn/GauGABSZ2reS7Rvb6CtPfsCrMTet5ipi6FTBxvNvjlbPBzUM9IP7EhNedJmwj1Qoq0oSnO5N/et8H6xh0Q37erXoLa1UfyhaoZ/NatpViajcTpxr+5WGYbjRz96RbKeCvFBpcRSYo4qOx61XCH7Qew645SgOD3x7807sLS90snl01WuWAFD4BCjykjAjn9qrgb6GTegt/Y6SbT0mT6LD0GcSgO3cBiAoM9SwGCpDG73qWCanOn9DSyXyxhddrMZ1SS3oMa+OYFJsiRkPcQFHkq9nmV1IV6HiIBKu4kteTsdWZ3XWcmV9ztrHmtRisd6VBRq/QxOR7NESDaVBranx7phBi7PC0qVzV5qaHNB3ZDgWxZT/A1pxCbt9OtGePq6nyJ0Wm8iq/qkobHM9TqgT2lheHsnObeP3eKw2buqvd+gM3yEeJ2Xx6lXCmR3jhbQHg706nJDkQQnZBljZE2paLkB1DP4BX8VwuZwEw2DeYeJfRWwGzrZKlwuHhkihjrI0kktMFpP6bs6faGrdp6Qaawx9qYBJOdM5O00l8SHX+BCgyhC97uy677l4EGU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d9496a4-8beb-477f-c0a2-08de5475ec55
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB7129.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2026 20:37:38.7793
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v4gvotZi1RP4b9xBEw+asxqKKritt0X/lQtavPb9XgwXIVrlnMcweRvtTPReOKPTpPGrd6d9/W0OjmQsZXsrmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7294
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-15_06,2026-01-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 bulkscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601150161
X-Authority-Analysis: v=2.4 cv=OJUqHCaB c=1 sm=1 tr=0 ts=6969501a b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=JfrnYn6hAAAA:8 a=yPCof4ZbAAAA:8 a=WlEXhbjKrYvH6h7-IdYA:9
 a=QEXdDO2ut3YA:10 a=1CNFftbPRP8L7MoqJWF3:22 cc=ntf awl=host:13654
X-Proofpoint-ORIG-GUID: nVWZs_9vYxkGuX-LIrMiseBFSX2Ts64k
X-Proofpoint-GUID: nVWZs_9vYxkGuX-LIrMiseBFSX2Ts64k
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE1MDE2MSBTYWx0ZWRfX6jXK2DjwXW/I
 lB5Rbjz+9fPLpdwl5ZG0W3iFqeLOt+Oc9FbiGnjtEwfRGeteMGKzS5iuZHHW+HsEhh2Kc7kVtCi
 CWwRHXguL2v+CHM7rHOENqV6phXTI47NFZYqgle5SV8EAMj2zqr4tTV2dFcpuq8oMmyuQ/7PcPS
 E4723t6g6+ik5L7JiA5VG6Do2Uci5oFK3keSLR+lrDYVtGnB0zECFH06cKz/DkG+fqDY2xTSkJj
 4joYrjaz9WeB6dVwUWJKrf3aBbApbIKC6BZ1U6zg667ROK/ptM9X5FYYs1TAb3tZQ6Dcz3XEevp
 3egN+JkrGMe/tWbEfkjCPr+iZ9mMCzJ8HNd+W6Or+tjExsvraoCeQunf0URww2z62VF+hB7YALZ
 F/Btxe4vWP8pe3Fnv3proT1/FdP8ILf8yhLm+DhuItjMGAcJdWDUxkPwLCtgI26cA4wozNxghBM
 FKTm7ooX+792lharuXhabPQeMgS2SUbjKZ7T7l2w=

Hi David,

On 1/15/26 12:22 PM, Dongli Zhang wrote:
> As noted in commit c52ffadc65e2 ("KVM: x86: Don't unnecessarily
> force masterclock update on vCPU hotplug"), each unnecessary
> KVM_REQ_MASTERCLOCK_UPDATE can cause the kvm-clock time to jump.
> 
> Although that commit addressed the kvm-clock drift issue during vCPU
> hotplugl there are still unnecessary KVM_REQ_MASTERCLOCK_UPDATE requests
> during live migration on the target host.
> 
> The patchset below was authored by David Woodhouse. Two of the patches aim
> to avoid unnecessary KVM_REQ_MASTERCLOCK_UPDATE requests.
> 
> [RFC PATCH v3 00/21] Cleaning up the KVM clock mess
> https://lore.kernel.org/all/20240522001817.619072-1-dwmw2@infradead.org/
> 
> [RFC PATCH v3 10/21] KVM: x86: Fix software TSC upscaling in kvm_update_guest_time()
> [RFC PATCH v3 15/21] KVM: x86: Allow KVM master clock mode when TSCs are offset from each other
> 
> The current patchset has three patches.
> 
> PATCH 1 is a partial copy of "[RFC PATCH v3 10/21] KVM: x86: Fix software
> TSC upscaling in kvm_update_guest_time()", as Sean suggested, "Please do
> this in a separate patch. There's no need to squeeze it in here, and this
> change is complex/subtle enough as it is.", and David's authorship is
> preserved.
> 

Please let me know if this is inappropriate and whether I should have
confirmed with you before reusing your code from the patch below, with your
authorship preserved.

[RFC PATCH v3 10/21] KVM: x86: Fix software TSC upscaling in kvm_update_guest_time()
https://lore.kernel.org/all/20240522001817.619072-11-dwmw2@infradead.org/

The objective is to trigger a discussion on whether there is any quick,
short-term solution to mitigate the kvm-clock drift issue. We can also
resurrect your patchset.

I have some other work in QEMU userspace.

[PATCH 1/1] target/i386/kvm: account blackout downtime for kvm-clock and guest TSC
https://lore.kernel.org/qemu-devel/20251009095831.46297-1-dongli.zhang@oracle.com/

The combination of changes in QEMU and this KVM patchset can make kvm-clock
drift during live migration very very trivial.

Thank you very much!

Dongli Zhang

