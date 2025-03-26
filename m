Return-Path: <kvm+bounces-42084-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BECDA72750
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 00:51:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5E8B7179834
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 23:50:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1772725DB10;
	Wed, 26 Mar 2025 23:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QfSCKBtb";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Xeey5py4"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CCA418801A;
	Wed, 26 Mar 2025 23:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743033035; cv=fail; b=qI9w458PBOOQeOxcVqDL9QFC40rAQmv7d9jmeugwmJtwDoCsrVflMdbddO2Rkg5lbFAUfp24fGh7IiYkrk7GccDyjw304OXVaHSbUcgoFrkNK2gRTjJQUl6b2tEAyMsXbEwSxCCFsIiBnmLNgQQIzPW/JCj+DtzHkuUt3beFGc4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743033035; c=relaxed/simple;
	bh=ejZbXFOg9NbqUEyUpknkSCBdUBbl1cMDwKGusC85gmU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=pmt50DAbVTAO3deFHoT5CinIS+2xgJN8k2qyW7G72h6i5PLl/Ndkr92BvAGOM+xVCgAV2wZRgGwEr9Z1BrNxOORCWmiHSIdqB6t0sgR8Qz+MoN03wOPKJ5pEJQJ8hZfqxZ6EZFEl4N/lYWB3rJKchY2FvH8wcVnBR6OA1bVIP88=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QfSCKBtb; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Xeey5py4; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52QK0d9t032258;
	Wed, 26 Mar 2025 23:50:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=VOIgZr9lGVIWdRwRxuyGDdTH0qOjskQFjOAUy7ZUhlU=; b=
	QfSCKBtbWFWWRv9B11JxrWV5K7WfzGEWXqQF52pLxyqbnI/vuAgiNnWHiIJahl6X
	OKKwNgQI/c4j7xdZi5fL6HbaRRDbiDRJ60RlGlfck5fcgr+V+nrjkqUo77ucip+y
	yOCqgRadRLG6SnyXB4cWOdVPW1tC0fmmpNnAJ2DewW1yppUrYdmbwEpsQKIGzXKJ
	r8u1muZUI+pZSNop+hC94E//humIqnIZCd+k5OX/H45kKkXmZ+gkpSJCueMtHnrv
	r2J0wQa7/DymSqgLUeMCqDqsBb9BndGhqSbbBJf7lXKO6uT/YcFJEZsI2UaUjC8E
	ClaIOi/Ejo3JuAVR5DkBJg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45hnd6av87-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Mar 2025 23:50:28 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52QMY896029591;
	Wed, 26 Mar 2025 23:50:27 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2047.outbound.protection.outlook.com [104.47.57.47])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45jjc32wjm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Mar 2025 23:50:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fCu431ObYaIQtYlELoRxW0dQoVyDzSWK89qG7NSkpKE7cjO3AWZRc/JiqBckL0T5YF7evqpa4zFAGA5Ey983H3gjTElIA3TW6mlzqSu1P1Pw+bYPIIY3rENq7R2NE4Y3Itf0jD9njyf/RpVfmViAPRtHiTyZATkOHs9KKxkDCN0Jn1Ur42CI3og1OCH3MR+Ogv3iHd9CcjVyuKF997bH8wrCEmeEnu+DNScU7EbF9DCPe91txDe2U010F05d8vB7dkk/RmREWyCF+HpmQ4aMIN6yAJ3PcBVu1Zh//7almOvsGDzkvRm0j7nARGSZu41qiOCO4eTbSfhyqCLfIN8hIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VOIgZr9lGVIWdRwRxuyGDdTH0qOjskQFjOAUy7ZUhlU=;
 b=BPCU3gOMhrwMVNy+FsIhOZIOmWBlpGYEdj8qvDiTSCWhGW3IPip6TfVkMMOHkZZD2bnUkqi44YD/EsO/mEC7QwSjcDa48Emi16ox9uSt8h7sIxrN2jQYjlOOsaA/yxARj0BN+EN9PLe1h9hx6OL+Xumajbs6MLlnDhVIaK+X2YyfYp0s+E41/inTp23k18hvQEzEECiqVoIsy8UbI4IRRovJ01tSwq8NiIXwGMnPDGcGThEVv9KTIp+TeSsBzN3gnaUl2anvUbbb7KB5wwJtcZuny5qgs4wbkX8qPNZdAZkD01Msy15d+ZOmqZ5P4HF/baYJgNZoE140k7MSqn4QdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VOIgZr9lGVIWdRwRxuyGDdTH0qOjskQFjOAUy7ZUhlU=;
 b=Xeey5py4CYkVzLoBJkWoGrQXtnlvOyJ1kZy9PYNbxrBrhzRm/HfHT3B9PWZErmTZmy3t36gsPWmCbT328SghuRoJe/pktMBetZc+u4OpHm0jcuq1euaU6cSd8m/UXsx4jnTxMoB1JrRl+GbfFm8vppS4l5KkxAs7m+neGmp//F4=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by BY5PR10MB4209.namprd10.prod.outlook.com (2603:10b6:a03:207::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.42; Wed, 26 Mar
 2025 23:50:25 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%4]) with mapi id 15.20.8534.043; Wed, 26 Mar 2025
 23:50:25 +0000
Message-ID: <339be0d4-662c-4db8-90be-e5ae0a1c6ada@oracle.com>
Date: Wed, 26 Mar 2025 18:50:23 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 09/10] vhost-scsi: log event queue write descriptors
To: Dongli Zhang <dongli.zhang@oracle.com>, virtualization@lists.linux.dev,
        kvm@vger.kernel.org, netdev@vger.kernel.org
Cc: mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com,
        stefanha@redhat.com, eperezma@redhat.com, joao.m.martins@oracle.com,
        joe.jin@oracle.com, si-wei.liu@oracle.com,
        linux-kernel@vger.kernel.org
References: <20250317235546.4546-1-dongli.zhang@oracle.com>
 <20250317235546.4546-10-dongli.zhang@oracle.com>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20250317235546.4546-10-dongli.zhang@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7P220CA0052.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:8:224::32) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|BY5PR10MB4209:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d341b45-2cef-4616-7c16-08dd6cc0faaa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bFJZNlFpdlR2Lzh1ZW9tMGFUc3lmRS9NNGNPdWlmTWMxemVOMkgxdWZSWmZT?=
 =?utf-8?B?bDlaZUFVbEw2OU90N3g3SFFwQ1dnWFNxaExMZzdVY2R6U0J0Tlp4MlhYRXgv?=
 =?utf-8?B?d2Vqbjh3V21zaitWUkc1TTNvQWR0SHhjdGw5bzBpTU1pRTNHcHR3OHppL3VV?=
 =?utf-8?B?VGR1MmRpQmRId0tqV1dQL3hHNU1XNlZUMVBxQmZtT1VremZodCt6WXJYQit5?=
 =?utf-8?B?SUlFN3hTSEplODBYcFlxaHB3Z1JWR1hEWkk5b3dGWGoweHNZZ01OaUhkNkJZ?=
 =?utf-8?B?S204MW8rWVovMEk3UmkyS0VGamRxaW5EQklGZzJjSVRsMm4vYmhIc0RsNFdO?=
 =?utf-8?B?U1pNUmh2OGFpREpHLzJWbmw3L0NlQ2RlRm82UGEyRm1ENWpYQUFvMjBEZWQ1?=
 =?utf-8?B?dVBZK3U2S3luRnNFSXJGc2JNMnZSNHNRY3NxQk1XdFVja2tHZGNsT1gzeHJw?=
 =?utf-8?B?Zk5HUTBQWEhob3o5OGQxa2tibU9RYWQ4NTlQcDJ0cTluNWVJRHZ6OUxLMGNx?=
 =?utf-8?B?eGplQjAySGhuUFBqalBHM3JzVTRCcHhUbmRXK2NraHNORkdSeXhGeE5sK2hO?=
 =?utf-8?B?TDdhU0ljWFJlRi9JaVcvczVsYXZFVUljUk53SkM0djEvYldveFZQOW44VjVV?=
 =?utf-8?B?UVJiVmsvVldjeHhpUndIaTFrRVFxY3hYNzlsRXVuck8raml0aTl2UkxIMXAr?=
 =?utf-8?B?Rmp1VGhVNmlBOWk2Qi9YQmlhTWs3c2xIaVpWQml3UjBHV0U2dnBibm56QWFO?=
 =?utf-8?B?bjYvWnBEZWc0dC9VQk01WU1neGFIQ0Y5ZVFLYm9NV2J3TkZMSmJtdndTcGtr?=
 =?utf-8?B?aXF0N3ZaV3JSUVlxUFZqbzBDcFpvQWFLdTFiRmhtRFlVdko5YXFxdm5HclJZ?=
 =?utf-8?B?WXZtTi9mcVR5ZktWNE5adUlBUmZETDZHOWJjMFA1eGZrczN1NS9XSXZ2Uy9q?=
 =?utf-8?B?eHIzZXBNZW5pcW1YOE5vUjdZL05WZGhBT3JEampYMU5ZZ0J0QWMyT0lJNklG?=
 =?utf-8?B?SUpuOGd3TlZPNERqMjdrNW44dTlVdlJxdEJTYWJ5ZDBYdjA0MEIrN1RaTDln?=
 =?utf-8?B?d1RFS3VVMENHUVNMME42cHFqb01CcXNnaVB1OG5jcVNEV3dtM2pVUDd6Y0tV?=
 =?utf-8?B?ZWFxbGJmRCt0RHZGbVR0My8vbWFaTDJoZ2FnOWdTcWlxMHF3RWJkZGp2Q1l3?=
 =?utf-8?B?OFJlV0w3U0lNWWt3ckVMMThUZ25tK0NKUVBrbkpoU0M5ZXR3bGVTcHNLbEZq?=
 =?utf-8?B?M2FOZS93ZVZ2MHVtcytldS8zLzhKM2tWMVdyY05FK29FVENLZGwvV2l6YVdj?=
 =?utf-8?B?Sm4xbktZQytzcllYWGRieTh1djFUSnBZaXR3QmhzcFA2WXl4aStZc2RaTjFi?=
 =?utf-8?B?ZXBXNnZ1ZGRpR3RVSkI2Y3JBZUkrMm5PeEowaTdReW4yMWd3aFU5c0owdEht?=
 =?utf-8?B?elZqc3VWSE13WGVEUm1TYlVXV1QzZzFUNWJsN3V1RGdaMy95L0tycnNPL0I3?=
 =?utf-8?B?YUhsQ25YNHkydHIyaE9nWmhobFFoNjJQZXlHUEFjMjJackd1TWxHOTMwbVNi?=
 =?utf-8?B?Y2JZTXhqMlk3THVoSW9wSFA3V0k0eFJVcFpYcTJ3cDJ6cE1STTVvM2ZiNmhw?=
 =?utf-8?B?aTMyVG4zTm9MdzRDQVlUS2ZuQXZ5dGJZK01NQkd1WEV4ZlVqU1luWmdNbi9F?=
 =?utf-8?B?Tkp0YURsWU1MYXdLSzl3dVRmMGJ6TVFLaFpIN2dwLzFnR2gvQjJCS3Z4MTdX?=
 =?utf-8?B?UlpsUFdkcUdtM3J3UkFSSEVMV1Y5bFR2RjdTOHlRU2FGSWV5ajI5RDYzNFVs?=
 =?utf-8?B?NnpvSEo5WFdKTklsaUFzNHZZSHNJMVp5azRPQkFDM2ZQazViU0lsQWFpL2N4?=
 =?utf-8?Q?s+iE0bvEQwiWa?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YmNwNU9ycTAyeVNMeXBvWUVsOWRJQmVnd1ozMVorLzB0Zk5sSFBFZUFkSlBX?=
 =?utf-8?B?bTB4NGJFOVlmU0ZQVDlCUVVXMlRPa2IvLzV4ZjFUdG9Dc3JkdGI0QVVCQWRh?=
 =?utf-8?B?VEJwaGJpMW9VM3hjR0JTYXRBMFE0M2Y1UkZWRmhCMEJ2THJUNWZvZXNGQi9m?=
 =?utf-8?B?K2pTaWJtaTRNdGl4VWxXVU5QWGZxZFlZWGNEd09Ic1ByTDFEWktERjlicTFL?=
 =?utf-8?B?SlQ1VHJNYWg2aXZld0wydVc2ZWxsemYzdTEwRWc2VENFdk9hakhUYWcrbFg0?=
 =?utf-8?B?YlZGdHp3d25iNkQ0S3FnQ3hzcEdPOTdNWmVwWnBkbUEyK2lMTEJMNVhVYndR?=
 =?utf-8?B?b2JiQnRrd3ovTzhlbFhwbDRGSnlrQ0lJdUx2UHJUQ0dadDZ0ZzEzdXE1cFNm?=
 =?utf-8?B?U2lXNDZaOTJsZktqTUxpaDRpb3RTZVhuVHVPeVM1KzIwTTE0Q2E2K2NCRCta?=
 =?utf-8?B?WUZWVlllRnl1Wmo1Mm1nVFpObWQwV1dhU2s2SFhrRk9SZkVWU1ZQcldCS05r?=
 =?utf-8?B?NzhxVmp4dVpsTEo1c3BXMlByaGF2M3pZL1cxWmVuQUQ0VWpzN1lJbU92MGdl?=
 =?utf-8?B?Rk9OeG5OdTRMRjVQWmNNM1ZhaGR0Skw3Y0tMQldyS2J1dDdvYWlBUkdvdUl3?=
 =?utf-8?B?a2QwR0FjWVJGaHVBVHhIV3g1eVdaMVhZdmkyUURML0QvVlIrb1BheHpiRXl2?=
 =?utf-8?B?b0ExUE54ZUhyRE4wN1E3R0dpek13dkhtVHlKcm5Bc2syaGFiSW1WVUVadlda?=
 =?utf-8?B?Qk5ma1Vvalp0ekgxVnB3aHNLWVI1ZERjNmNNRkdFTG1DV050S1g5ay9NaS8x?=
 =?utf-8?B?Y2haTFRobUxkT0RoY215QnRNanlVZHZMcFZVSXRMejByVnB0dWVNRlE4T0hy?=
 =?utf-8?B?U3hmeVNTSS9NRGM2VXV4am5UQWNUaGVCcHhpV0xrVnUxdTNleGNBU2N5SHpC?=
 =?utf-8?B?aFpwVlBjNzZvRmFlVllnSFlaaXNNU3ZaVHhqcWFjYngyVnQ3NWI5a2wrMXcx?=
 =?utf-8?B?L2pxbDRUUTdEQWZDUkVwYXFFdXA3N0VKWmJabTN4U3Z1WTNFRjRsTzZFL1VN?=
 =?utf-8?B?eWIvV21xeFRIb2tKZS9wUlhHSU1uOUx6UjFIY0hiT0l2UEZsY2t3amkyVXJV?=
 =?utf-8?B?OXlxYkM2MHVjVzJCb3U3RjJLMUU1MUI3Z3RLN3FVQ2lweFFNSmFoa1NJSVdW?=
 =?utf-8?B?T2srZHpTREhXcHh0czJGTFpQSFREeHpFNnBoOXo1VmIyODMwbjg5U29RQzky?=
 =?utf-8?B?bkdWVEtWZEZ3bElReWxSNCtFSksrVzNJeWZJSjVZL25WODdnS0x3bHdpQTE1?=
 =?utf-8?B?U3I3cmlpaTh3RXZYeWtHZ0NCTGQyU0xlcmQvUTVKWVhQM2I3Q05NaUpWZm5m?=
 =?utf-8?B?Uk1xSzlPbFJxR0FkRXFRV3YwMGRqUHhGVFdVWGh5VWtGZ1BUQjViRWNXUm9Q?=
 =?utf-8?B?UTdHLzhVV1F6Q0Q2NHB4cTNySzVOMzQ0QjRrQTNIekNUSDJHcGI0b0VSeEFS?=
 =?utf-8?B?Q095b0pjNitaMXlmMEFRWEZTSGRCSlZtT1hWOHN0T0dkbC82Vm9uNlh3aEJK?=
 =?utf-8?B?UFpsTXEzaGZOV041ZWc5Z1U2cG41V2I3RVVGdjZEb2xwSU5PVVNUUmIrZFVj?=
 =?utf-8?B?aVpvQVo1WlE5bTdraTR1S1A0MEkvSzhkbnZGLzczRGRFb2hYd1dSc1dldjBa?=
 =?utf-8?B?NTdsNWd6NDFSZW1BUCs5c1gvQ1NuUE5QcGZYMmlnSThUVEN3cGY1d0E3MitN?=
 =?utf-8?B?dkRENmw1bnMxdzhoMmtZYi8raGJLMEtMbDNueWJ0Y1BSd2lKc05tb0pnZXNW?=
 =?utf-8?B?Mk9SeUY0ZXdWaElCVzcwQU9JN0pDeWhzTURXQzU1UkhySmhlZHBvZ09zMUxv?=
 =?utf-8?B?SlNtaEhZYW02WDRzNjU2VXcwZEQ5UkhHK0FzR2RMZm5Jc2hZSGtLNTRrWm96?=
 =?utf-8?B?TFdCWVE0NGJHL0g2cEppQUhkRnIyaURzNHBPR0VBYTNFcmlCcGRDRHZVTGlC?=
 =?utf-8?B?UXBIcUN5bm5rMDNBV3lrV1ZmOFBLS0FVWDJWWjJpQzRteE8yK3EvWnJRMkRU?=
 =?utf-8?B?YTNybjZwN05uQWVCM3FXTld2UFZjV29JRjNFVDB6Mzhsa3ljTkkxRkdkRzJq?=
 =?utf-8?B?cEdqR2xTQVBkME0xRlY4WWVqUjZuK2RnWnd0TXMxd3lJZkVNbFRRU2FWUFFU?=
 =?utf-8?B?d1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	QgwjtRDvX/3mwT9D8Hum8winebf3bqhlIZ8E3fA3CRBQla8pS0bCiLlhwiJoo5hL1x78qfIN71Ke0iPrkfQl3kbgdpQmQrOOy21r/NdyW9i6cp7XR0v76xU9DX1wGRo1fmVMZz+tbNcJ3t3xbAZrDf/wNlDPRqgWBnll40uye/CDYL1sSCoMuOBdgISIR2OdUW9e1WA1GVUCcfOHZWAwdzAXYQHE1sLiWMMz6VNePWsuNekbdjU3PJovtYd9pS+ws30IPVifjXjVfOO+d1RzTEP1hI/Zd/rc8kpEgWZL+3WhLmfaDlReaPzy3wvolfzq8oR9nF1sWzi8NUD1ICjXJJcl1V3CiwoxDcVSzyjiSOjTUAXA0OZeUix7bM83KRf9M8MBDZIl9q+0MV/RlSiCIAWRmxPqe7xJ7pvmMTJvMs1g+a1js3KbLPqlhmKKelnOzqun4h85uy8CjScU8chC2xLTwdhJhFE/t3kdSx1dg+JTNmuvz4PEKYat0qb6pU/YMmAYDnqP1JWvhEr0/jm2YVF0o9nCm2i4BWnF3CM16/4GzOjxeInNw/AmX7RjKMYPIDZ6DcgIC5+VXuCRiPzVetMwNBN5EMaXMjHrA8hm1v8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d341b45-2cef-4616-7c16-08dd6cc0faaa
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2025 23:50:25.4225
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dtrWdfgj77dPkQ+zNNXxkzkXs6O3RZJKIH9mv0SCKdysXolyx4QzfHvEvt9vYKMLPbtmXIYWrDIMH4R/f593wnHARB40Zf9cBdCDoewhYkw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4209
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-26_09,2025-03-26_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2503260148
X-Proofpoint-ORIG-GUID: RyJlDJU5ZpMvcj_eh05sXr-RrNlakrvC
X-Proofpoint-GUID: RyJlDJU5ZpMvcj_eh05sXr-RrNlakrvC

On 3/17/25 6:55 PM, Dongli Zhang wrote:
> Log write descriptors for the event queue, leveraging vhost_get_vq_desc()
> to retrieve the array of write descriptors to obtain the log buffer.
> 
> There is only one path for event queue.
> 
> Suggested-by: Joao Martins <joao.m.martins@oracle.com>
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>

Reviewed-by: Mike Christie <michael.christie@oracle.com>


