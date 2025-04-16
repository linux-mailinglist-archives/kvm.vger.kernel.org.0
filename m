Return-Path: <kvm+bounces-43402-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EDEAEA8B2D7
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 09:59:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7A30D5A061C
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 07:58:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8055022F173;
	Wed, 16 Apr 2025 07:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UQA9OW3u";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="pIxNqLsK"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D828122E3FF;
	Wed, 16 Apr 2025 07:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744790316; cv=fail; b=eVW9r4CvgICbZwOPRKd04ZtYK2nEi4wBWSumFiQJLSvZNftbyC5pKMYW03vUPQuXmYyhcbBtqQeRRq2glGQ5RxX2gqs+iUrPEkB6DhPQVQ5k+Wbf81fhxhfwJEVTc5AYdFyj0UGUFWXaiigII8G60lpE+9HDHpTRfmg0EYt0Uq0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744790316; c=relaxed/simple;
	bh=FbYZytC1kkSXnC5DUmFHjPPjpNCl6eRVdX9ul0zEfjo=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=tmK8TSYvxDOWM/1AfqIjGdgMDNSYKOjNJaOtFVkmWqZucdHOFIbSCUdHDLG7ULwoyP/E0V0dBmaFJJOYTqXh0RNxE6K6CYhyShyW66wJiH7SfDHT2mqf3xp2zxW7TVHmXH8dS/ZwgpKA4oaweTzpmv7mRl+GI/m6HVvlC/DICwE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UQA9OW3u; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=pIxNqLsK; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53G7txc5006209;
	Wed, 16 Apr 2025 07:58:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=sWyi42/GWhq4WHz2MWPGSsgLWS8WZPVVbZz7oO7VqqU=; b=
	UQA9OW3uAhH0BEB5JNufcOjzcRz0PtV17OB4h506keFfDNwYcG0/Ra/Q/+YGddo3
	sKOq90ZuiSZ4qO2x4DIBD+eno5DCK8l8JptLAqOpFoqBY40RtEpk3O76EsmpPMkq
	nCcVjtMzXFom7tC4UOSQ6J88tnrh+D9HzeXlWlzsAjEft+ZYaddhNHOPS3gXloXR
	XkzmXrgJKCWC41TOoSPHpANxO9CxYm1ciclDzIXQ2458yJIioFy+FzFsJEBey5us
	KIwXbaENPO3JssrNCyU9a+w3F1y4NbE8Rd8bB57T7oqdLcR5HgWn0XL3JUGumBE3
	xH4HjNucz9pxDd/MjIvMlQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46185muck2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Apr 2025 07:58:26 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53G7jIFu024735;
	Wed, 16 Apr 2025 07:58:26 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azlp17011029.outbound.protection.outlook.com [40.93.12.29])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 460d51g8bf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Apr 2025 07:58:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TusGdF/8sIiMiqjhhDhxaZS5HEE4DPIUYeX+Ho+rXm9TCKM7aZ04ghv8TvWSAaYbJroTIMapxD7n7wUr52Tk/+wIgcgsrpM78Y+Ogtoi6mK3raajDk4SmdUg1NBcawH2ZmJ9/xBDzLeREkUSG3AmlaRWHwdew2p6pVqH6KuSib4dWhBWYloWHT4TAZnFadGz1j9UbbHsbjecimCeSOeLK2O2Jbe8bolmzKMD4jfjkVT/h6a4XCvRZLOjXixIxKwgTj0lrRY016h91kj7BKbe/4m87oyagaodOjnQJzjW8MAUi3Ijn0PqmwLxAjjJqn1JMO7e4psIrRb4FbtRqVBWkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sWyi42/GWhq4WHz2MWPGSsgLWS8WZPVVbZz7oO7VqqU=;
 b=QvqU/d4IQM+HdAC6GqEKgQzyErzhKdvwoMPWQklx4OV6uhrUyo3efIggcAiCRIN6fh3yFQGqt3RqbLsbFj7XbytVc/NRF6avUgmXegiAyY6srbj+msMA2hSQRCGHaOFhlfCsGAyvE88XzwH94yJqJkKDOD9jIAkuCg3FcOFdcKvHk4lxU1+WGjJmYHeNDnM/29hzBbAXxj/ij3BOqs4AhSdAghX64BOpZ/+yxOV2w5CH4HMmLTbbi0HWQe1z6OXHNjevAJC+QcWTOkYi4AEzw3AkN6mAOE/fHEi9JZDAeiR3L+kfwfWtozvNhzDfaQXhoJeSCSf9RIcxxesbPmbOtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sWyi42/GWhq4WHz2MWPGSsgLWS8WZPVVbZz7oO7VqqU=;
 b=pIxNqLsKLYwpb8jL+NzUUPwnP97TCb3h3htGbj4G+xIhDb5OBWvnLhUpR03F51t8kbXXfeh7LH3mPrISlN6yOoLd7Q2sQhWrQEaqi6oAssCmElQ+LKWClxCB1GbeZONGA06CbhYhvApiXnwsZnsFIAEYOkaylI+HmqKEEvdE67U=
Received: from DS7PR10MB7129.namprd10.prod.outlook.com (2603:10b6:8:e6::5) by
 LV3PR10MB7721.namprd10.prod.outlook.com (2603:10b6:408:1b7::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8632.34; Wed, 16 Apr 2025 07:58:07 +0000
Received: from DS7PR10MB7129.namprd10.prod.outlook.com
 ([fe80::721c:7e49:d8c5:799c]) by DS7PR10MB7129.namprd10.prod.outlook.com
 ([fe80::721c:7e49:d8c5:799c%5]) with mapi id 15.20.8632.030; Wed, 16 Apr 2025
 07:58:06 +0000
Message-ID: <3cf501d5-925c-4a8c-b3cc-d0b94b4b5e8a@oracle.com>
Date: Wed, 16 Apr 2025 00:58:05 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/9] vhost: modify vhost_log_write() for broader users
From: Dongli Zhang <dongli.zhang@oracle.com>
To: virtualization@lists.linux.dev, kvm@vger.kernel.org,
        netdev@vger.kernel.org, jasowang@redhat.com
Cc: mst@redhat.com, michael.christie@oracle.com, pbonzini@redhat.com,
        stefanha@redhat.com, eperezma@redhat.com, joao.m.martins@oracle.com,
        joe.jin@oracle.com, si-wei.liu@oracle.com,
        linux-kernel@vger.kernel.org
References: <20250403063028.16045-1-dongli.zhang@oracle.com>
 <20250403063028.16045-5-dongli.zhang@oracle.com>
Content-Language: en-US
In-Reply-To: <20250403063028.16045-5-dongli.zhang@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0057.namprd07.prod.outlook.com
 (2603:10b6:a03:60::34) To DS7PR10MB7129.namprd10.prod.outlook.com
 (2603:10b6:8:e6::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB7129:EE_|LV3PR10MB7721:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e86abc8-45f6-4c34-034f-08dd7cbc6c20
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Vk1CNDcwazRYL000dXppMS92OGFHTFFsSnhKMEJQZ2lJWlBjem1vTlUvSVBS?=
 =?utf-8?B?NjhXV1FvMy9pTThmWFI4N0R5dVpZWDJIUnZZa2NxK2ZkN1NWNUthZ0k2ZitM?=
 =?utf-8?B?c2dPdFFRbVVVTXpkbVZnYUIyU2thZS9nNGgrUWFWZHZ0SDlNS2NuYzRHbDZl?=
 =?utf-8?B?SnN1bG9ibmtId3g0SUExMHF6RW5LMk43T1phUnRGZnpTdDl4WUwxeHc1YWJB?=
 =?utf-8?B?M3dNSVJXYUc2U2MvdStiNWdLT1FSbmprdk0wOUk1VWxPT2oyUTNGRzFham9n?=
 =?utf-8?B?dVhXZC90cGxBZ0t3S0c2NEtXTHpjNHRaelpqWnI3SGJWdkwvcS9zdXRiRWZ5?=
 =?utf-8?B?ckVPVXFwd3IvUjM2QnNZYlJEOTRWckY3R0lRLy9pTFBpT0JFTEZIM0RqclBO?=
 =?utf-8?B?MlNtY3ZMUFluVjVrN0ZyZDFKWndIcVhLRzYraEtWL05OMkljaXRodTdETVhv?=
 =?utf-8?B?L2Z1T29oQmhSTldVNFRWK0VYRzdTYTNDampBSXlyRE05RlRyd1FNdnVGalRu?=
 =?utf-8?B?NVFHejZyai9lWjRhUHJrVDZnaGVQc2FlVEtuYVJHdStnZkVjdk16eG1tRmpO?=
 =?utf-8?B?MXU4d0p4TDdsdjlmekt6ZGNydENFZ3VGWmpUTEtld1VWY1I0QytuVkVVTTFB?=
 =?utf-8?B?UWZEekxQYjRrckQ4Z0s1cXVXWXNrRFNHVTVBdWl2dFBjNmw4blJqZE54dVU3?=
 =?utf-8?B?cVUvUjdQMU9vY0dheVliR2hKZmNncEdPRVR0RzNHK29pVFBKbUx1ZHg5UjdX?=
 =?utf-8?B?YVNSRVQzbEdBOUhSTGt3RHV1Rm1KYndDL3QrRXVvYVc4TEIxNEdOUVgzN0VQ?=
 =?utf-8?B?d2tzV2hlU2hseWVJNHNiK1JNcHBNZ0F1WUhKbS9nbm16Wmdxb2VFYjFldFFh?=
 =?utf-8?B?dGRGRFQzeFpCZFJUZDNUTnRLclZOMDZtZSt2NG9aRVBwZGFkQjZGRWdaRTFa?=
 =?utf-8?B?KzYyUmVsNFY3QUluME9ZVC9HaVVGODdtL05rcEFLM3UwaWU2OExuTzJEQUNm?=
 =?utf-8?B?WmlVY0xNTEdvNWhkTE96MHlOTFZPT3pZYUM5TUsyZUI0eVdFZlozam1LOXQ1?=
 =?utf-8?B?OFlnZU9aOTZkN3d5Q3grNFZTMVpzbVhyaS9DVW1xMVNLUEhFNnB6cDdubjdR?=
 =?utf-8?B?bFBKSXI5SGpqVDVtYXowZ2U2eXFWblZ5MlZEK2tYMTRvaS9lNEcreHJHYmZC?=
 =?utf-8?B?eVYrTmFLeHpaN3U1VE55YXlHS1ZJSjJVMWozSGNLMkZsaFdHQm41L2hiUDha?=
 =?utf-8?B?ajZkV0ZNZWtPdUxqVTFDZkN5SEhJL3FDaGh1ek5adzR0SEhLZWQrLzZZYWZn?=
 =?utf-8?B?S2U1Tm14R0FyU280alFubGMrRXViU05mRHlGUEluRUhOQStEcjUyUklOQmcz?=
 =?utf-8?B?bGtaMFRMTU8yTmJPV05XM21ZZTBmbzFHeVJtMUhONjdwUHFEU3ZmSjBYTzY1?=
 =?utf-8?B?bFRkbGYwd0NRaWxuRnE1ZEZRUlYrdmEzLzhNZHozb0pEMHNGN1A2UVNoQWcr?=
 =?utf-8?B?a25VYi8rNSsyNmVJNDlwbGxrd0h1MTlvaUZLd0hNUFA2dXNMV0NOQjYxcTYv?=
 =?utf-8?B?NE5SSXVVemVINmErZ0JVUnBuY1M3dWU4TEoyNVVLakRZTWYwL1E3aitzcGJ6?=
 =?utf-8?B?UFVMVG5Bdnl1Uno5cER1dzhDV25rNFFlVHhNRmVCYzlDTDljbFFJNE5jalN2?=
 =?utf-8?B?TGZrTjZFVjRsdFNUSm5ETm9YQ0NhMFo4VENBY2R5Q1F4UzhXTHJTMEF2TUpQ?=
 =?utf-8?B?MVVhMlJvRDd0NzV6UEdiSCtRZkZadU5QcEdZZjlhZnE5NTBIanEyNVBUQVBR?=
 =?utf-8?B?QzNHWnJ4bkZtai9ieVUzNFZsYVlnRzJFa3FSQlNCY3plcm5yQ1RvTEpXWS8y?=
 =?utf-8?B?RTJkYk1ldkRWKyttajNKMG9CSXdwSzl0SmNwb1RPcHBsbUQzRjNOK05PMHVQ?=
 =?utf-8?Q?ovGo6xTD0+8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB7129.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YkY5NnAwRkJVMzc0clJObFJIQmpwOGJ1bnJLN1FVOHpHZzZCaHlPZGdLVDg2?=
 =?utf-8?B?bmNLT0VhN3JIVEthbTFMRkpLTkhmb3lTcXM0SmdrY0JaMkFyNGtTTFlpeUsr?=
 =?utf-8?B?Z0JSTlh4bDRiT1Q4UnFmdmZOTGFYSTBaUldUbktrWGlEbEphMGNZL1JkbHo0?=
 =?utf-8?B?dDlCMjFnbUsvZWhyS0kvcEhZb01SYlBBYkwwcVdDbFVpSjE4SlR4RWZSNE1m?=
 =?utf-8?B?MWZENXpwMndFUGxsQXVQVzV5SU1CSGQ3U3JRdWVnaG4yVnZ3N2pyL0tyU2RY?=
 =?utf-8?B?MmRQbi9QaVA5QW9ETEo1SXFJSHJvQ3ZZWTducytwQTFHOVFpYmdxdWtyNG91?=
 =?utf-8?B?OERHcE5GOUl5c2ZScHFHOE1JUEJVcmdjSkMwdnpMbUlZS1RiV3lqdEw0TXdZ?=
 =?utf-8?B?SHgrZVU2Nys5TVJWNVdLaUxUMGJSdjhsNEN1aXhMUlZWKytZVFhxV2lmM2xk?=
 =?utf-8?B?SjBTZHFuUDk2clVvNm9jWnBKTE9TYWFjeE9oOTliVG5XMm5IaWNuMmR4Y3Vr?=
 =?utf-8?B?TlZuMDFwbE9oMFlKSHBBOVlWWUxWTzZHUHpjTmVQNXgrRm9pQjkzbjZLdEhW?=
 =?utf-8?B?YXFDNDR0QmZ1SWowcC9BTk1iaWp2WUJ1NmFmRVhmMnIwcjFIcHZydE8rMHZH?=
 =?utf-8?B?dmNnQkN6OUdCZW1IMHRYYmxvWVM4cjIrV1ZYM1F4blVrRjRxM1pxUUs2K0Y4?=
 =?utf-8?B?N1RXVVI4V2hrUnM5SUxUcEVuRDdMcnduRlpvVlRyMFNnR1NNUVJWdkxLdXh3?=
 =?utf-8?B?ZytKMG1tKzh2ZnQwWkFOUWdnQ0FaaGR6K1BVdVdpSHV2Y2F5ZVR4anV2MFZx?=
 =?utf-8?B?ZFBiM2VrSUdvZnhDdkFDNEtaN0JJbFNQdWx5VlBlOWw3djRuRGVDbVB4TUVr?=
 =?utf-8?B?T0FwTFNWUVZrNlFVMHFOQnZudmZjZGJFdFdJZmd2dk0wQlI5Rkc4ZmJPeUhF?=
 =?utf-8?B?SWZ4aG1BQ3FtcnRKeDFadUh0S093NWhGT2UwdmFSdzJCRlUxY3lySUR3eDM3?=
 =?utf-8?B?blNKbDBLeEpMSUprNlNVTGNpMG51OE1DZVk4S1g4U2x2cDY0QzFqZjVpd2J6?=
 =?utf-8?B?SE5RTDd3NXdtalFaTC8vUzl3TDlwL2lSNjlEVFB1ZUhadDFDemdlUmF1MUhI?=
 =?utf-8?B?WmtqNFVjUjFYT0Y2cHcwZnkwM0pOZGV6QUV3UE1VSmYrS3p6TXVsZ09UZW8z?=
 =?utf-8?B?Z3UyTzVTTFVjbnNCeVRhZmRTTEEzbnE1QW90b0l2eVZrbHdYYXFqa3l6Q3Zs?=
 =?utf-8?B?R3dObitqQUdGMnR4MFpEQjJiTzNReEVCRFdZL3NLR2JOMGhmRFdjdElzL0s1?=
 =?utf-8?B?WnVhL3I2T25yR01qNUJ3SUxZWGdFTXdqVjMxV2dEVGlyMlk5cThSTUM2R2dq?=
 =?utf-8?B?cWlLWTRvSlpPaVA3Z2l0cWhYTDlRZTcrLytoYUtkOVpkSk5RejVFaVZVWk5J?=
 =?utf-8?B?U2ZoZEw0R29NTXNyTCtDdkw4NEhTdFFzYnhGWmtLK0NrWXNKWm1IVXh6ajV5?=
 =?utf-8?B?ZkdMdGZDbGhSNGdydWNiRXlFYjhPeGpHQ2ZFVzZqbFJzK0dPUVIxMndUU3ZP?=
 =?utf-8?B?WHdGQkNGbllWOVZoNTdHNjF1TWNiVis0UzZ4bnJJbDRRN1BqaThWNWNlTG5z?=
 =?utf-8?B?ekFBUGZFYTB0UDRZdmM4bUcvWWhwT3lJeHlEd0kwUlFXQ25LcW5ZRUlFUStB?=
 =?utf-8?B?OTNPVS9ta1lvODVSNWcxOHdjQ1FwQ0xaN2k0d0sxcVd2Rm1yNW1Pc0JVdkt1?=
 =?utf-8?B?RkIvSFExWVFNdEZCQmZWVkhObGZDOXpGVXR3bzkxb0xsejhWN2FFSUlGdXhR?=
 =?utf-8?B?WDVkWVhHTFpqOEVtQjdyU3pXM1gyWEVkWWJMQ0lYT3RzUkhrVUVydEViNGZE?=
 =?utf-8?B?WmpaSEE0SmpTY3BNRktkMlhHZ2NmT0pGZWRMZTdtQVdGS2JEYkdHMGlvQU04?=
 =?utf-8?B?UllIeHZEUTNjOVgxSXdFaFkrTE9kSkpONm5tT1R4N2FyYmZsL1liTzJYOFd4?=
 =?utf-8?B?Zi9FTUNuTXNoTUEyUFhVV29yeE9kZzkvdjRyWmVMSU5QKzVacVM5T1gwSWNU?=
 =?utf-8?B?ZmtrODQ3VGU3T0lSR2M2dXVzOXNhcmlNbkw1K3VPRndnWnZVb3Bmd0ZmUjlG?=
 =?utf-8?B?cUdQdTJHbnlYdVR1S2gwYzZrRlZGaDRzM3F4NnZLYlRQR3BPeDhUdmpnUjdv?=
 =?utf-8?B?MVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	tQQ37doNmFZREXUcgPCXSF5Jig/p7FkiXZ2HEPDEM+qIaXLZPSdwaVFC3dUy0on/Mu8b7N+oL/tw5m+JtjTWuQgENhmLJl9jcu74bDsLVs+I9QWEjJjhO0lWfcMy7kppz2xqOC+DPhkfqu9rlzt1HMCWDwU00m0PYpX3CogFY6xLLBtG6D98lmwkrZBkaD+SGC4nlECJEVW6l7tdy1KI6Lm2c+Xbzaegz6Puz91auwn6n8Z/TgbBVU8YaaL/ycvGFzG4eE2h2YkIEb7+vPE8NgmHxYh8OgPQGX7usYDMnAy4D6XLoSUFHtoi5ORd5QPmSr2CxYm/t/c6y1PplanYnamkg03huwiEBc0II2NqlR7xZQ8V/yE4AS2Feg0SrNK9jTbYnIc7mcpdE788BoABLhTOJbZfnXO+dcNWUDgehmCoaZntfOmESoe7JcSgg9NN1wGaUNpVWk/QaEwJPlIHeW76uf2N7V/wfKT/ZiDMZ/GFBEEfq/uXBp0Qmqhtku9OmTjtiT99XgEqaycOum/RI18NKIYJDz5ZAjE1S5CaECLXJq7S60stLo5vhf4Th/TnFfWpMWO5UAeV5CaDHyVfGI4V+QTvAE/xGNzDJ9nS0Tw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e86abc8-45f6-4c34-034f-08dd7cbc6c20
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB7129.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2025 07:58:06.8535
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t6wnqzJa5zcEBz8sTF2D6NdBfp5cI2nluoMsCJfqr+F/+DKu2Wna21eNULS1jGH6FZ7/GkZpimSSYuqU8UpKfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7721
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-16_03,2025-04-15_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502280000 definitions=main-2504160065
X-Proofpoint-ORIG-GUID: LU7dCqsz2DQGxEvjuoO4tfPoMpFtHCl3
X-Proofpoint-GUID: LU7dCqsz2DQGxEvjuoO4tfPoMpFtHCl3

Hi Jason,

Would you mind helping confirm if it resolves your concern in v2?

Thank you very much!

Dongli Zhang

On 4/2/25 11:29 PM, Dongli Zhang wrote:
> Currently, the only user of vhost_log_write() is vhost-net. The 'len'
> argument prevents logging of pages that are not tainted by the RX path.
> 
> Adjustments are needed since more drivers (i.e. vhost-scsi) begin using
> vhost_log_write(). So far vhost-net RX path may only partially use pages
> shared via the last vring descriptor. Unlike vhost-net, vhost-scsi always
> logs all pages shared via vring descriptors. To accommodate this,
> use (len == U64_MAX) to indicate whether the driver would log all pages of
> vring descriptors, or only pages that are tainted by the driver.
> 
> In addition, removes BUG().
> 
> Suggested-by: Joao Martins <joao.m.martins@oracle.com>
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> ---
> Changed since v2:
>   - Document parameters of vhost_log_write().
>   - Use (len == U64_MAX) to indicate whether log all pages, instead of
>     introducing a new parameter.
> 
>  drivers/vhost/vhost.c | 28 ++++++++++++++++++++--------
>  1 file changed, 20 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 9ac25d08f473..494b3da5423a 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -2304,6 +2304,19 @@ static int log_used(struct vhost_virtqueue *vq, u64 used_offset, u64 len)
>  	return 0;
>  }
>  
> +/*
> + * vhost_log_write() - Log in dirty page bitmap
> + * @vq:      vhost virtqueue.
> + * @log:     Array of dirty memory in GPA.
> + * @log_num: Size of vhost_log arrary.
> + * @len:     The total length of memory buffer to log in the dirty bitmap.
> + *	     Some drivers may only partially use pages shared via the last
> + *	     vring descriptor (i.e. vhost-net RX buffer).
> + *	     Use (len == U64_MAX) to indicate the driver would log all
> + *           pages of vring descriptors.
> + * @iov:     Array of dirty memory in HVA.
> + * @count:   Size of iovec array.
> + */
>  int vhost_log_write(struct vhost_virtqueue *vq, struct vhost_log *log,
>  		    unsigned int log_num, u64 len, struct iovec *iov, int count)
>  {
> @@ -2327,15 +2340,14 @@ int vhost_log_write(struct vhost_virtqueue *vq, struct vhost_log *log,
>  		r = log_write(vq->log_base, log[i].addr, l);
>  		if (r < 0)
>  			return r;
> -		len -= l;
> -		if (!len) {
> -			if (vq->log_ctx)
> -				eventfd_signal(vq->log_ctx);
> -			return 0;
> -		}
> +
> +		if (len != U64_MAX)
> +			len -= l;
>  	}
> -	/* Length written exceeds what we have stored. This is a bug. */
> -	BUG();
> +
> +	if (vq->log_ctx)
> +		eventfd_signal(vq->log_ctx);
> +
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(vhost_log_write);


