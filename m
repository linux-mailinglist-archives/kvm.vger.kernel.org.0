Return-Path: <kvm+bounces-49045-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 58D6AAD5629
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 14:58:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F1AA21892E0B
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 12:58:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8529C283154;
	Wed, 11 Jun 2025 12:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FwxHgGUl";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ZtCW0cDX"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A0023AB9F
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 12:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749646698; cv=fail; b=AlYKthEBUQL8OX7fBCchyUhvoD/4JeQOFR0TBPaaRaB1N2cqVNH1mv5TreNJKAyaf/mGCy7axx2BIKAwBpETsUdDukiHXLkoQTbXJWX1O3xXegQrFrDdCXt6nlZGxfD2JJd5N0vCRpaJKD2SNsVK9yQlhjF3dvTbBj03O25Qkyo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749646698; c=relaxed/simple;
	bh=b0Fh6YpshKH3Dn68wgbEecqCVK18ahuzY0ublYjkpco=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SaVeTZb38YzNAFfXDyzmcxbz9+G/kuzsO6153wSCWAK4Lm86EXITkMHzv2Wj/SDjG9MSu2yhTJXsBARuITk9bYG9sEYXG0x52sDHya+SWa50TsFR8D7HH0P5SjCokJj1qkeoqxPzVNLQYXpA2nk17UR9noY9bDyqKRmZ099oD5I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FwxHgGUl; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ZtCW0cDX; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55BCtXiW002655;
	Wed, 11 Jun 2025 12:58:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=cnO5x+6yViRCxrBzVHA0Ekhv40+vVscTQsZ3RkUDbxE=; b=
	FwxHgGUlGEnSYvc2/ZFCXYwktrpopApzrHcuM3NT7/D9rmrEqgyhI5+wLH7MJZ6d
	KoyokyfL5YmMPhwxdmiU5AJwqIgzbbVpqRjYJq64yi629vPND9CZL047yBhX4rRW
	Mk1rfUMqaOb3W/DEegmZGFInyqiW2p/FvenGdC+8539mPp9H4uZ6lbAnMvRt7xO1
	h0CcsOqkPJoqRBCuhwoxkBSSngZE2FjXSUz6yAVVahDr0zpmPaFM3Z61kWRtM0Jp
	IjiPHHbOy6/1qE5P4bRN7ifKgpZHPp23a62bWbMVsa1rn16mx7sRBLtuD0B9CkGz
	6hX3a9gVcwApk6IBtAj8Yg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 474c74xkj4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Jun 2025 12:58:11 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55BC2E9E011897;
	Wed, 11 Jun 2025 12:58:10 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 474bvb4hnn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Jun 2025 12:58:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q3IQSXsAb7zPJmWPemNiillze5UMvRmBrLjbOemCLebFcl8KLLAgosDP4C42e5VBvfoKHD4aUQdjrJpZvaUuT4kTybu50HeZt4PxWyfqnWEpyq37kCIEeJknBGVQoUKVXWOWyRZ1FK7FrW060yUm34i3HPnT8z0M65XuOuVcfm2Eiif9koQWJtHr1obF3unlPUNgPfR92J6KApdjdvmsaRgp275P7KISlAwVRCZhw4nJ1TDNDZTRrv+JSfhZOmpBYfYsuQwHAIoT5A8Iu7WkS5/a8S4cJgmFrYMEfGgEPxOWPSUFYyF9UUB9unf1fuoTSrhadCAUBD3Jm2NoWvA9pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cnO5x+6yViRCxrBzVHA0Ekhv40+vVscTQsZ3RkUDbxE=;
 b=LdHoX9mZDDEmhP+dXnvtb6jwQp3xGsLObKriR3hq4lyZHqknsIdQ80/S+h1IyHkAEWNLIkvXJUuX9ReUkfFNoEmuTgsCogxaNrfUkIxBvF80/a6/HY/mj8vpVbhTyxOCmBbs+70Uz4HHxNqTrv4LBepEMiz48wRadeIrFXOXniJo2N9dCy5qWccVeWRWHlkt8aDlSr5ermdNihp6VAEM7AN8na3Aypfv+DuaLHEXNavW2NUu0IeS/JoGwKs+JVL37+Gsnz+mpZj63WIR1JQZwOnKS96Wtd9D7fzzFt7lVjSM7/y6ryeXzrNuancH4U7nksrun6uwEuQ8mC4UejiTlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cnO5x+6yViRCxrBzVHA0Ekhv40+vVscTQsZ3RkUDbxE=;
 b=ZtCW0cDXOThqbp7R2BOq5/YbcdDy6qD1UuERIWm2Xwm+MNIv/touetwK7rWNNJdeHk74sqkH+vImJDO8/cnLr0uu/pXGbhkhthVFyNsJSCyTZXmh3XpqzybsLIbOVyId/2ZBN8myW9M5HLV8He5AbjBnUYUMFYzTLgHJxZYVUNI=
Received: from BN0PR10MB5030.namprd10.prod.outlook.com (2603:10b6:408:12a::18)
 by DM6PR10MB4250.namprd10.prod.outlook.com (2603:10b6:5:212::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.21; Wed, 11 Jun
 2025 12:58:07 +0000
Received: from BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::44db:1978:3a20:4237]) by BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::44db:1978:3a20:4237%6]) with mapi id 15.20.8813.024; Wed, 11 Jun 2025
 12:58:07 +0000
Message-ID: <13e18529-9b55-48f1-a293-f703f24ee737@oracle.com>
Date: Wed, 11 Jun 2025 13:58:02 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2 12/14] x86/sev: Use
 X86_PROPERTY_SEV_C_BIT to get the AMD SEV C-bit location
To: Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Dapeng Mi <dapeng1.mi@linux.intel.com>,
        liam.merwick@oracle.com
References: <20250610195415.115404-1-seanjc@google.com>
 <20250610195415.115404-13-seanjc@google.com>
Content-Language: en-GB
From: Liam Merwick <liam.merwick@oracle.com>
In-Reply-To: <20250610195415.115404-13-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4PR10CA0015.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5dc::11) To BN0PR10MB5030.namprd10.prod.outlook.com
 (2603:10b6:408:12a::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN0PR10MB5030:EE_|DM6PR10MB4250:EE_
X-MS-Office365-Filtering-Correlation-Id: 409206a7-7f09-4383-180c-08dda8e79c35
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VDBYdHpZanpDVlVqKzJEbUs4aWxWZFVjdTBHZjFSVG1VSHNPL3Y4VWYySlk3?=
 =?utf-8?B?cjlVME9EZzJrV2hoMVB5VC81bk9haTdza2NCZmJZSlNoWHJ3anMzUmZvUERJ?=
 =?utf-8?B?ZU1Ub1UxZ0xtWUVNd0thUzFrM0xKWlNGbFRWc3FBVnFZN2RjLzVYL2VtanQ5?=
 =?utf-8?B?MDUzenJ6bXhtQ2VpbVorNjByeVVuTm5Sd3hTcjJtWmNiY2VIa2lTK0JpVW9t?=
 =?utf-8?B?Rk1KcXE5M0RYVXRQV1gwVFQ5SHFjR2VxdURybTVIaWgzbmlVcDBZcG5qUGdU?=
 =?utf-8?B?OXVMRGp5QmZvYXpTUGMwUVBNT1FDOGZPcXp4RjZwTjJlODdrQStPMG5qNXIv?=
 =?utf-8?B?NDRCTUQ1WUxnMlNlZ1FiTGhhWWVhUlNiSmRWTE1QYnlWbk1HTkthVExZeXhO?=
 =?utf-8?B?M29SdFFocXdtOWVGczA1cHJreHRVUzZhTTVLNHF6QXBSNy9DUWZVajA0ZGNN?=
 =?utf-8?B?Vnp4c0RsN2pQMG5OT3VwZUJWT1U0clJ4V1lVUFZMN2VnQU5nSFpJV1VTNmJN?=
 =?utf-8?B?dTF5VnhoVU84Nk1YU1ptMlZzMjg5c3o4OWsrazZZVDQ4NTJqSzczanlpd0ty?=
 =?utf-8?B?NS94TWREd3lHYXB6VlAyaUdRTkJhYnBLUkpxMjk5dzNGUUlRNU1vYWJQRjRz?=
 =?utf-8?B?T2NId0VCY0x5RWdOeG4wNi9MZzE1c3pxVXVLb0ljWmpNTmtWLzNZNWR2eE1W?=
 =?utf-8?B?V0VBVHlHaE5TSkl5SkRleW9VM05xeXhGa1JBWVRJVXlOVDBEZko0Qmx3VEwv?=
 =?utf-8?B?djQ1bnpFWkc4TjBLenBFaG9BSzVqSWxPekt6Y0tMSXFtMExSRVhDV1dxMHFZ?=
 =?utf-8?B?QS93UjZwaGdSQ1J0Z0hlYWNWMnVscTFldGpXeTRkWG85RlVBQ0dXOXpIY1cz?=
 =?utf-8?B?OGJhQ2RLejQrWEk2Y1R6M3NwYWpjd2JybjJOQ3FDdHg4bmd1YU1ubmg2VkIz?=
 =?utf-8?B?TnRxcThuMjB6aFBjYTNzektEQng4TW1FcTdZT28rSXlwci9Hc0ZxMmtOM2xX?=
 =?utf-8?B?TFA5ektra3hienB5MTVIV2gwNWNvTkQ3MEpQWjVBSkFPcDZTRkRSQ1JQSlcv?=
 =?utf-8?B?U29ZSWlCMDVLRW1TY0w1VW5wT2JKNCtRMDZOS0xwRGt1SlU3ekM0RFRmNTIz?=
 =?utf-8?B?S1c1dkh6QTRCb1BxU3RRUDAvOHh4WklkT0ZDMXlVVmNYcjlLU2tKTTczcjlx?=
 =?utf-8?B?dUJoVlNwNGIwMEN2VHpwTS9jdlZmc2RERmhrdnlVYlZlWG1EbCtDdnpDVEtl?=
 =?utf-8?B?ZXNSWkVSNXp3MWV0RHNMQk9sbm9sVjdvamNBMi9OcTVicWJPS2ZJRFo4UWQz?=
 =?utf-8?B?ODdqOGtqR3NYNXdqMUJUVi9HM0tRYnZoN2VJcjNoZ2M4ZWx1clAzZ09IQWo4?=
 =?utf-8?B?eVlNd3V2SEZ3T3dmMzF3WXpueEQ0d0I5eFVxR3Z3cTFRMFhkRlA5T2YyajJ5?=
 =?utf-8?B?eXZhVGlBaWRydk5FZWV6L1F4OFlTaEUrMXI3TGZUd3N0OU8wK2x5WUJ4WTgx?=
 =?utf-8?B?cTFkUXRFcnlRdTFUbVFlNjNTRjZRK2lnK1NoTFFVa0Q2bitOZGlGQzhaOHc0?=
 =?utf-8?B?dktQNGY0dnNWTTg5d0tUdjBqajBLUGdsWnhUVTN0blRSanFkOUUrNmtQVGl4?=
 =?utf-8?B?YUFuY1ZLUXp0TndmRVBLVDA2REM1MC95a2FQWFJnR3ZGL0trc2crMzFqb0Qr?=
 =?utf-8?B?SE5OMW5OMXZLTVZob1pzUmd1ZHU1VDNGd1V6Rm4xZzlpUSt6ZER5ZHZsTFA1?=
 =?utf-8?B?MEJEelVOZWRiTVFsdVhzZzNXOW95eWVDcXNMemRjT2lNakJsa1g1UVBWckps?=
 =?utf-8?B?azJNaUtRZXZHOTRobmJkSXdaTXg0ZTJNSTVvZ2gyTSs5K2NUdERCZFdjNWxK?=
 =?utf-8?B?Y25ZNGZKWThqbFlEb0NwcDdtdTlCNVBON0IzamRWWGNJNUVQVDQ1RDNjQWpF?=
 =?utf-8?Q?sVSOq6rqM0c=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5030.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UmdacXJxWTJER3ZSN1lGNXl1M2RNMEluTm83Uno5TkJxUHpLeHV5UzRReVdy?=
 =?utf-8?B?L0VRREpkOEhyOVBNVEhGNTdMb3BjNlJMM01UZjIvWGNBbGZWdHliV2xNSkJZ?=
 =?utf-8?B?Y0plZC9HeEhNZXFsSVpCWGYxaFF5K1liSlVDY0owOWE0WmVIeS83RHBDSFd3?=
 =?utf-8?B?ZTlnUktZYlowaFNWOFRtaGU4Zms3aGE0S2pTenVIQzlNb2ZzT0NWMXBtZzJR?=
 =?utf-8?B?TUhuaE9ENVVFaHZtUFM5Uk1lR2E1RUNwQ2Z6MUlGZUJPa0xWRjN6emJzMGMy?=
 =?utf-8?B?U0RiQjFKaWtQbnFybm9LOTJSbzc4NW4zZ3ZNZXVvck5nWG5ML1RCWFgvTnNN?=
 =?utf-8?B?THdrM3diMWRwYlcxMEQ4R2o0TFNhU3Jua3pNa3RKcWlWeGJSWVYxUWJUdW1q?=
 =?utf-8?B?bEgrVndCbGUxZGR0UWljbkRDWktqY0xGbm9CVFRnT1ZHUE8wMTVqcTJpVzVN?=
 =?utf-8?B?SlVwcWM4Sll3dXBJTzl2WGlDZUxZMForcTdHeUhhZ3grR2NOMjlOS0c0VEpp?=
 =?utf-8?B?UURrR09Banp1clc4Y2lha1hMVCtOSXpmd3dDTzlvd0VEVkJ1QjNIc1MwQnVW?=
 =?utf-8?B?QnNKdXFCOEFrZ1ZSOG9vS09DR0diV0w3TExxODZhQk51NnFGSHQvWk04MzMr?=
 =?utf-8?B?UThjZGorYVJ0VTF2REUzekpGMzNjL2JBU2g1U2l3S1FKZGJPNU9tM0RXbGt2?=
 =?utf-8?B?NE1ZU09uMEU3RlJtbmx2bTBCU05ld01GS1FJL1ZFUnpXZVNLMW5CK2F0bTQr?=
 =?utf-8?B?cXFCbVZqSERhWXZVNUJvOFFEMTc1VFRTcVdwdzVxekp4dDFCdlV4cjFpbUU3?=
 =?utf-8?B?MHZFcHI0cWNReERxc1drQ0NoL2NPQU5Td2xrMGM5ZTg1Y2FUKzBXSm5LTkJh?=
 =?utf-8?B?SGVJTjVmdlV3aUlTaFF0UklmZWkzdTE3TDQ4SEpLMlRJQjlYNDBrekZ5SElY?=
 =?utf-8?B?WXZpbVFRL2FhR1h2N0U0ck5VMXpiOThtZHY4R0gvUGpBcEJRb3NHcWZnS2sr?=
 =?utf-8?B?K0puaHo5NlZtdTI1by9jWStyeUZBekwwOENIUUswc2NydmsyVmp5a1MxV2ZC?=
 =?utf-8?B?eTQ2K1hUYmxpTVF6Z1ZXajI4S1F1NzNKYko3ZlU5WktKZkpsK1RFeU9BdGJn?=
 =?utf-8?B?L1NlelQ4QkZ1N1NYSVNIMTFYUVVLR2YxVDBnM09oREgwcWpUa01rNDlPZ3RW?=
 =?utf-8?B?OUVQSG5CdDhFSW1xSEpwVGtEdHVEd3ZiNmU5eWE5N3pGVG9LOEN4d3lhd2JS?=
 =?utf-8?B?NVQ2WE1kajR3YmpDT1N6SmFkSnQrSlBGd1VxYUtZeXlQcStkL3orY0psbHFv?=
 =?utf-8?B?N0NTQ0Y3M3NrRURzMk14YUVYMFhsY3RqSVhiM2lGditZRmZyK21aTWY4MTJp?=
 =?utf-8?B?cllsNEhjSkZ4eG80dk8vMHVid3BJTDFkSzBTMmV3NUcwQkhFOHc1U2xsTU5x?=
 =?utf-8?B?YldSY0tyNEtyZ0dEZWRJM1dJcSt0Rm0xSlI3bkZVVVpTSEcrODd4WHVVVjlz?=
 =?utf-8?B?L3hJdVRackNDc09ocWlkQXA1WGZlaEFNYXhHbmFYajBrU2tRVktreWpUNnJD?=
 =?utf-8?B?NzYrekNVdk1IczRXSzZjWXVMdGNVaXFqaG42R3ZyY1AvVGJ3bEo2L3lLSGhJ?=
 =?utf-8?B?UTRXRWw2TWZZM3VCZE1GOHhGVVA5d2s2Wm1DeVo1cFhYMXlIMG8wbGJnNHBK?=
 =?utf-8?B?MUhvNUJucUpsTG5SaVZXak9DUmsvbHVZU3U1czNEVjhVQVM4RW5NZDlRc0Qv?=
 =?utf-8?B?bVJRWXNRV1h1MEc5cmM0cnNhQ3RmVVh2Y2JucVhpR1Rza2U2azFJc1h1NDg3?=
 =?utf-8?B?TUNOMmpSZDRMQjNIdGRYRUt6TlIxV0tUSVNVd3Qrd251b3lReFE0bWtUZE1m?=
 =?utf-8?B?SCs3V2tKSjBjMnRIYkJXQ3NCWXEwVVczZWNjUVVNYTZmdDF2Y1hOekFHSGxr?=
 =?utf-8?B?TzdtK1dtQ2U3Z01mZWJIV3NjaVpWdU1nakYyQ3l5WkErcVNyWkdNNXJKTWpO?=
 =?utf-8?B?aEdmOXZjMG83YkE4OEVlVDNZSU0vUXZsbVoxL2xTL2prTVl4QlhzaHVjeFBX?=
 =?utf-8?B?cGhhRTVuT0xrN25uTGNCYWtRdFFoakFUV1hvSTlsblVCaityWkVOZkVjK2w3?=
 =?utf-8?Q?u+y7YVO6GMX5wE9tizkCPX84L?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qfNxTfERfd9Yfkv7sy3X1aDYjD8bIJvC8NVKoJizuWMasQigGYiurzMMcKa/4KwXhS3SW97zvD6SoJ4kQ4qLNrst9TDG5c8Oe+aKyZ+I5scJwt+VRAzkmw7ON0a2s571ng9k0jgb2wMLrzjzMErZfjq2JAVQ9BPTVW4sd+9Ty4Cyhmc2VlFjkzaDiZ5djHdIo6XCd4IX/ciCvExLcYuQ9TMf8bf5gvuPW37KtpC7xZGz/4WaO5669Fn0eFbJ7SU7DNb7yCcXC46Fr9E2sETre7JKbeUfnqo4WbspqkB4c277XpFNvpGLtQySDQccAu1II+G35nXHJ53onV2BbWS2AI57UmSkjnrm4kBE7K98YomIAzL3rtRUwGNKNM+XL4WQbtID1Sy7hO7XttAi3jc27KDrxBgy8WPfhFPDvbgl8sj8c5gqqbCOVjdbYtCjTxK8dt8Zz5kOVuNKwhRm0sD7OEylufUwKCpiqt7a1aPXJme4KxoG6tw1fVzEZdpTO6FLzLCSEmG5R79Ohu6yjtauf8axS2/hAoum7z5cyqbz83j40MDQ6n+zsKV+wAU+X1cLqxplfAvYxRyZ7ku8Zjf4ir5FWVZYxkTEksMONuhJCdM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 409206a7-7f09-4383-180c-08dda8e79c35
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5030.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2025 12:58:07.0209
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PDhh96Zzb3DbslrgGqSVP+IVdktuF+6/3ZXlak7h7f5tEwMM5hZu5iwYWL+oKJck+uZEVvp1T+7M40FPojRgEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4250
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-11_05,2025-06-10_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506110111
X-Authority-Analysis: v=2.4 cv=LIpmQIW9 c=1 sm=1 tr=0 ts=68497d63 b=1 cx=c_pps a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=1XWaLZrsAAAA:8 a=yPCof4ZbAAAA:8 a=VnYFVonD1peC4Nocg5QA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: h3_QDJLgIO6VLCIut2ok0cnxnenR_mWv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjExMDExMSBTYWx0ZWRfX/peTk6Gt5xXc 4oQmYW8yUAo/iEqia+iT9dhxE8EQ2NuUYRf1GCSuNecG56CJJdS0HlMIj3OkTLEtVYS/Jpbmfen piWAKrmUIlMhSeD0dlAZD8OPcy172GCdHDmp40LsFaxOAme2ZyD/FJNDEvPWgJBoMiBLPy+bJ9k
 CFXoYsS4WCIr2TDUuDLuZaRHNs2zyRY3UEi/a9ubB44WlfhCspenVTDrqTuALnLCZ3b8988HqqQ qMfAP384ZSHqKCkfp1BnNI+Gur4x9ZSTr8+yGPvD9JILVGDw311quJwOssDidT9eo4i9raPFWpx xV2Ym5FuXRtDpmGGfgpV61pRnBunLJP4eMhXdF6vWmF3ZVFvekUCp4f6PHczSbUnMQPvtgkx5ds
 7dCJ8z/PBny3I6+paKiBkrs1rnL9jtyUl8tAcVk4RL6NdnFncrrrUtZt3Mvnb9fmWKk6d37D
X-Proofpoint-GUID: h3_QDJLgIO6VLCIut2ok0cnxnenR_mWv



On 10/06/2025 20:54, Sean Christopherson wrote:
> Use X86_PROPERTY_SEV_C_BIT instead of open coding equivalent functionality,
> and delete the overly-verbose CPUID_FN_ENCRYPT_MEM_CAPAB macro.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Liam Merwick <liam.merwick@oracle.com>


> ---
>   lib/x86/amd_sev.c | 10 +---------
>   lib/x86/amd_sev.h |  6 ------
>   2 files changed, 1 insertion(+), 15 deletions(-)
> 
> diff --git a/lib/x86/amd_sev.c b/lib/x86/amd_sev.c
> index b7cefd0f..da0e2077 100644
> --- a/lib/x86/amd_sev.c
> +++ b/lib/x86/amd_sev.c
> @@ -33,19 +33,11 @@ bool amd_sev_enabled(void)
>   
>   efi_status_t setup_amd_sev(void)
>   {
> -	struct cpuid cpuid_out;
> -
>   	if (!amd_sev_enabled()) {
>   		return EFI_UNSUPPORTED;
>   	}
>   
> -	/*
> -	 * Extract C-Bit position from ebx[5:0]
> -	 * AMD64 Architecture Programmer's Manual Volume 3
> -	 *   - Section " Function 8000_001Fh - Encrypted Memory Capabilities"
> -	 */
> -	cpuid_out = cpuid(CPUID_FN_ENCRYPT_MEM_CAPAB);
> -	amd_sev_c_bit_pos = (unsigned short)(cpuid_out.b & 0x3f);
> +	amd_sev_c_bit_pos = this_cpu_property(X86_PROPERTY_SEV_C_BIT);
>   
>   	return EFI_SUCCESS;
>   }
> diff --git a/lib/x86/amd_sev.h b/lib/x86/amd_sev.h
> index defcda75..daa33a05 100644
> --- a/lib/x86/amd_sev.h
> +++ b/lib/x86/amd_sev.h
> @@ -19,12 +19,6 @@
>   #include "asm/page.h"
>   #include "efi.h"
>   
> -/*
> - * AMD Programmer's Manual Volume 3
> - *   - Section "Function 8000_001Fh - Encrypted Memory Capabilities"
> - */
> -#define CPUID_FN_ENCRYPT_MEM_CAPAB    0x8000001f
> -
>   /*
>    * AMD Programmer's Manual Volume 2
>    *   - Section "SEV_STATUS MSR"


