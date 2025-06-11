Return-Path: <kvm+bounces-49036-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A5290AD54E1
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 14:02:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F07B5189CDBA
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 12:03:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03AF5273D6D;
	Wed, 11 Jun 2025 12:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Rau0Ftur";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Wx+nUcKZ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16CCC18DB2B
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 12:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749643360; cv=fail; b=OI7XCU6NaQf6bZabYWjTijj6nny5NOWLZgUcSFZfJY3iMTTqmCg+KePGHjt5PQ7HTc3yaK2FQUMj/2BCkAkuUw6FVZaZf9PiwKMh0DDUQI4zTm+R/XFtYPutxt+5ynbfd59lqhca3zh4mCBQy9xAFEM43iYWtn1bBtYUvzWE14c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749643360; c=relaxed/simple;
	bh=wq1PL7WKHAcN8LxIrXua19HuUeAd+iLVitP3Zfr8khM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=TQfQXshRVZhZoNCgkNCap9HMLn3a84f/4A3lI62HFLa5woW++uwRWPyPGJQx2PWvYyxjepNufTXo5Sa/hYno8KOCAmCfphqwqiEzVMs1ODEpataXocT6Rxtewst6dXrUIyQkwwZTBnMy7sbGhjvi2LcoolACpTQ/fDhu2fi+eJc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Rau0Ftur; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Wx+nUcKZ; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55B1Bw5s001346;
	Wed, 11 Jun 2025 12:02:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=rkDi8UDgUmnDagCCImLC4/cOMPbkvCpae9irGjNV6YI=; b=
	Rau0FturOMMSMdMRWylXBtybnFz5dwpmahq5ZLM6ocGJrmsRvCGP6wOFRyPrYWKG
	KDpRcOnCtYkeIuuO1NujQdzVenpZ0WFA5SZtL5aispx88uEir7mqkImHA6gu23ld
	O5kYBoqt0CbIwiYVLsszotm/Tc1fuA+80V1KYTCebbVZq2BK1Lp5+dRT8821niiD
	BPYyPg7XuNnuu+JRmSVT2uhLuZBGi+bu353Bd4K+fpTw5fpanaCxfnfyxwK2jydY
	gAqZDVrJioSq24sFNN2FHQ4dw3ax/3YTO67jobDTCpGTNMfQK6rS7rBLSdL5Z7tz
	zqV0IlNRA0DkeKF3m1ug5g==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 474c74x6ra-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Jun 2025 12:02:31 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55BB3Hro020433;
	Wed, 11 Jun 2025 12:02:30 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11on2049.outbound.protection.outlook.com [40.107.236.49])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 474bvga2tr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Jun 2025 12:02:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rh1XfnC4yBBm9gjxWK5oouJp3v/Qb4VcZ8mi4+EFGYhjKhBZSbXlyssT20yvJxij5dnEF8Q+6EBvmtFY3QfGHd5d2ozm3S4Ctrvhn0dqnpO0Z4cmg9YPqzj7ehukrdYhsnnOzbuoHjunbjxzI3G9l3jIc2xlFjgQpFLFlD5Zh8aWh+Bh4IM2qhj9F+xsi7737kUlLVf83z2htujEbLSzj6V/1cHPX2ZHaoHsQ+Ca4DVk9XmVVTIH0jobhPvkg/vQnP1C3ecDmWtLMhxLP6R4yI21OFPgKXF2lwWwvU7IGpQ9q2T70iJsCxFo2tPSUXEZ110qrBfLSQBXM2bffoG/pA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rkDi8UDgUmnDagCCImLC4/cOMPbkvCpae9irGjNV6YI=;
 b=zJCOKE2bC7TY42LdCv7yvT0d6pV4tLk7ml/FMO1fnnDLMCMQsK/kMRzxzVJx2FbBGCdZZys5PQVB+3tEgoEuPkZGYgYpDZHuz5Kxqf7MYhU1OGG23V9FUXEZHXQwBYqGO+wlGxMHdg0Rq5hXlSLbejN0xZ/vZU4x73rv99jFEHJY89f2mYPZIT5RHWmXfLoFCeH1q/fFxwsE0Q9El1XUBfuEFrHn9qErPep/NX7W2Ag2IxPIBkau6ZqK/ZLqciNq952jul+aEDCVR+kL21G5zaRSK/P8NvLfSKZ7O/RpqaVKtVSetcBRbuYgsx0+2xX/GwW32r8VcJj33aN00S12/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rkDi8UDgUmnDagCCImLC4/cOMPbkvCpae9irGjNV6YI=;
 b=Wx+nUcKZ6DrKiQaFdZoaZdbIx7juJfcO+KLctn0EefZgW75Wqh05Urpj3j95nn9WhhL1Zr0ioq69kaRcfrkHvH65pmXHACn3hAY4KEiCz8mNME7psb2wgze9Qx6l7Cu8G3arGk5v/N+2Y3mUIW2JiqkuNxsU8hbpfPkOKqkyNOY=
Received: from BN0PR10MB5030.namprd10.prod.outlook.com (2603:10b6:408:12a::18)
 by DS0PR10MB8031.namprd10.prod.outlook.com (2603:10b6:8:200::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.30; Wed, 11 Jun
 2025 12:02:28 +0000
Received: from BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::44db:1978:3a20:4237]) by BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::44db:1978:3a20:4237%6]) with mapi id 15.20.8813.024; Wed, 11 Jun 2025
 12:02:28 +0000
Message-ID: <8690c9e7-4764-45ae-b8da-03b51eed3027@oracle.com>
Date: Wed, 11 Jun 2025 13:02:19 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2 06/14] x86/pmu: Mark all arch events as
 available on AMD, and rename fields
To: Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Dapeng Mi <dapeng1.mi@linux.intel.com>
References: <20250610195415.115404-1-seanjc@google.com>
 <20250610195415.115404-7-seanjc@google.com>
Content-Language: en-GB
From: Liam Merwick <liam.merwick@oracle.com>
In-Reply-To: <20250610195415.115404-7-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR01CA0122.apcprd01.prod.exchangelabs.com
 (2603:1096:4:40::26) To BN0PR10MB5030.namprd10.prod.outlook.com
 (2603:10b6:408:12a::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN0PR10MB5030:EE_|DS0PR10MB8031:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e0e8441-3647-4740-7c3e-08dda8dfd5b5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Q0YxWXppdnpNajlHcE1mbnV0RDJkc0V0RElNZC9QcFRqc3V3Wlc1eFdicllS?=
 =?utf-8?B?dGNUb3VWS1hseWFUb0ZFMlkxYllHOFVWZFVQbFFKeXpPc0FPdTluUU5iako1?=
 =?utf-8?B?M2s5Rm1xWGtNcTQvMlVmd0xPMllERmI0NjBpRm5GQzVxTmh3K255elJVRWZZ?=
 =?utf-8?B?OTZCTVFiUmxTYW5zMzUzNzNPRjFSR25CUHRCZVcyL2greXJkS0JvaVY3L0JB?=
 =?utf-8?B?ZjJ5dEpUVG12SHJta29abEFWNEpLa2tJTjVMWldzbm1vdENaRGhqVWcxKy9Q?=
 =?utf-8?B?RG1sU2pBQVVZSDFpN1FqWWRaT0I1TjB0Ny92NjJvL2xPRkJpeHRzL0VrQUFs?=
 =?utf-8?B?dUdDZ2V2Unk5NnR0N3l2QkovUUw0YnVKb2ZOV1BTZHRac3BmNmg2bi9wemsx?=
 =?utf-8?B?eTQ3M0JiVmVrNXM0UnFraTFJOUU2K1JkRkxvc0Vkb29BdkZJelFkYU56YnM2?=
 =?utf-8?B?YmtheVpTUVRja2xJNzhMT2ZCemtESTk4VGdoVGRhenlkelRzc0JOOFo1RVdY?=
 =?utf-8?B?WGYxdGU4SGVSTlVWNWhyUktPU1FnbEF4K1laNUROMVVkeTA4dUI3WHliTXQ3?=
 =?utf-8?B?S2kwVDZCSjNMbnlCSXRHbXQ1SWczcDl2di9lMHR4b0J6VEZpa0NLMkVtcU81?=
 =?utf-8?B?aDZWaU4wbG4zVlh2ejd1NGs3UEQ5S0x1aHA3ZnhKemRMaERaOWQ0VndPVHhj?=
 =?utf-8?B?aktGaTQ3SHVMYlVaQlZoM1o1Z2p2aVo3RU9pZnl4TlJSTyszbHRnRXJ3YlJN?=
 =?utf-8?B?RGdEZ2xueHowSDBXRXB3Q3VLOXBEVGVKWkJEcjJaQ2NGS0NFbENCYy8vWmZJ?=
 =?utf-8?B?VjF4bnA0MVZ5emUwa0dCQlVMOVZML3BPSjFkR2ttd2xjVStTamJJVUJ6MnZX?=
 =?utf-8?B?cExUbmluaGlNQ1FQOWVlTkcrNElMMUljRXhIWDVNN1E2dEVYSkRvWVdsS3Fj?=
 =?utf-8?B?dTVtamNlVmVaaXkreDJFbEJiNk91QytJQlduNGNiU1dwcFcra2o1UHN6a2lu?=
 =?utf-8?B?S0EwNVVhdnBuVk5pV1cvMkRCSUxKMlBFeXJMNWhPY2FyN01vNTFmWVhISXVT?=
 =?utf-8?B?eGQrTmdSK3lBUXRNZVczeGZTUW9Wd3RMVFRnYXVtRy82dlBhNFplZE5oWTh5?=
 =?utf-8?B?OHZkWEdNbU45VXExS2Z3UitocVJBMUpuQVQ2U2tsRy9RLzg1UUNXS0lKbXpP?=
 =?utf-8?B?YzUyU1I4NVpIOXJlaGY2ODhCZUZWNXdpVlQ5NjIraXNZZWJHY2tYR1pRKzdn?=
 =?utf-8?B?R3FVMlZmaktsYW9DSExUNHpDM1QvZ0k3SUg0TElhYTZwcjZNTkl4Q2svaHI0?=
 =?utf-8?B?RWMxUG15MDVWNlVWS2FzVCt6anA3Y3lyTkUyWXJTeVJwd3ozT2xjT2hxV3l6?=
 =?utf-8?B?VEJ5Z2ZKVDFoZlg0RStWRW9KY3JwQXZXV0NNQnpuRU9FZUZ5OVoyQzVPMHlh?=
 =?utf-8?B?WlpPUUlWTkNvaUJGYlEwUXlleTBlSDJENm1SZDRWbHB1WFF4S0R2elkxSlB6?=
 =?utf-8?B?WTd6dmM3alo0bjRzRDNSUXd2MkZpOEk3RmlQU0ZuK1k1cllQa1lKSmpjMjFL?=
 =?utf-8?B?UlY0OGhKTFlBaGppQ25ZSm8zTDJ2WmpDK3cwL050YTFBOWpQNWxHbGtTdFVx?=
 =?utf-8?B?a2pwbHVBaGwzTUFqNlVkM2ZCTkdRdGoxb3NOMU8yTmtKeEpDMC8wWHd0TlZa?=
 =?utf-8?B?R3ZMWFRaWTl3NEN1clp0NDF6TTR0OEQ1c08wOWp5UUYvRnZFazFVMG9kNzg2?=
 =?utf-8?B?Yk1LMnpvN1NVOFgxblZaNkpqS3FYNW9PNk13N04wa0E5VVhUNEEyL1JVVUtK?=
 =?utf-8?B?OUd0aWovellKVHZDR1V1QmJJTEtDSHVnQjRkTEg2QzByTWRlZEhHZFQvbGJM?=
 =?utf-8?B?RlVRK0N2Ty9EMCtCNFFHTmhLek5HaE5DZUVGZkZFV1NYdzdraGNCOGJoL2RJ?=
 =?utf-8?Q?9RZb0uz1Kn0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5030.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?S21oVFY0bTk0QWRhZ3lKYWpjdlJYckttR3Vra01oQVhsRmxNZjBlRVhsS00w?=
 =?utf-8?B?NHdpRU1lNHFtOWV6R0VIQzBIdEpOT3JDY0pVcWZtemxoNnlnOG5sbW90cnFu?=
 =?utf-8?B?c1JHK2l3RGp5WEN1dG43SkNKZ3RpNG1aZnZJWmlDNWIzemdxT3RIM0Zvc0Z4?=
 =?utf-8?B?OWdyWEpPdGlOSWJXRXRCNU1pU01POUs5eitHVzZtL0hINEZkUzlDTFNXSHBT?=
 =?utf-8?B?SWc2dUVlODEvdlhpdDVJd3FtRU1YVkd0VEtZUnFHbHQ4ZlRNZzZxMmZ6ZFll?=
 =?utf-8?B?RWF4clh6TnhwdjhUWkpHbzR3RzhPaW9CTkxZYUpUY3RPR0g4ODVobzJBOEdz?=
 =?utf-8?B?ZDVJcFpkL01FM3M2Z21VL0Y1WUFCRFdTZXVNMW1aakxTOVB3aS8vcUxTRzBz?=
 =?utf-8?B?ajl1dFNTSTRGYW5SQkw3YkhJTUNwVUZhN05SM0ZJbzczWkpZT3JMZUR0TlUw?=
 =?utf-8?B?NEtPRTM5SUZ5Z084d0o5cmJna1JzVmFyRDBCeUNSQTh5Q3p6NnhEUHBJeHZ3?=
 =?utf-8?B?NXcwL1pGQU45NjJQYm84SGxMT3RMVS84dGQ4RzQvcTZ0U3prNXVjcVlNUjBT?=
 =?utf-8?B?bkhublNuN0dFUHp1a0xoazJkMXBEa3BhbXk5bGMyeGZVQ0tYVzFHdDd1cGgr?=
 =?utf-8?B?ZjQrQ04yM0NZc3liZnZsYjVmMmZzMGR4RlBSVHVudTBjczdveU5JT1FYb3ZB?=
 =?utf-8?B?MXZHM2hEWEErT1E3Nk1CUm9RbmNzRGpHcUk3YWpPY0dCSklZWDFPQ3B1a0Qz?=
 =?utf-8?B?OGVqSnk4ak5hOTRaLzU2N01Va0hhazRvQ2p0R2dhMFJ4ZTI3d2ZPRitqM21K?=
 =?utf-8?B?bVJFRTBNZ0ZVQi9XMC9aR1BDNXNqcytGakdpeGo0SUliNDNSaDd6Nm50ZWk0?=
 =?utf-8?B?MUFGNFJVRlhnKzRKelNmZldwNEYyUEkxZk1lUFllZDBUUEZxMHBMUDNVdG9L?=
 =?utf-8?B?dEZPZ2RVU3c4WlBPbFdiWkZKQWdFbFIzUUJDS2Z4cHpqSmVGbU44WFdZby95?=
 =?utf-8?B?YzR1UG5xK3AzUWJrYk8xWlA5VkFna0JtRnpiaW9zTEh5eG0wbnUydXlHKzBI?=
 =?utf-8?B?M3lEK1ZPbGFxbUpzZzZwZk9zVWlNZ2F4bVpKcmpzTjdLekNNUWx4b3ZUeWpK?=
 =?utf-8?B?ZTZvNHIrNnFKZjkzTVdab0t2YnVJTVpsNC9Mc2dVb01DVVdRSGtxSGtjV0g5?=
 =?utf-8?B?V0pVREV2dldSWGMrK1RrbFA3U1Z0WG9Ha2EyeHRoSXY3MjYycVhVTEdaRDQ2?=
 =?utf-8?B?SFM1RlVzR0pJT2NjaEJZRlpUMFp1dnNrTFA1RXR4Mi8rMXJISkcySlZ5Zyth?=
 =?utf-8?B?S2RtSVlHMEdFdFVqdndSeUlrTkE4am51VGZGdk9NSlA4dHcrdldCVytocTVo?=
 =?utf-8?B?MDllTEQySE1IZzNlY2t1RTV5ejlyYVFEc2xLRjgrcDMyU2kzWFZmc0ovNjAz?=
 =?utf-8?B?dnhTU1lDOTRvT1hNQ1BDMXBLZVY0aThTRnFUSFJnTjZMa1hDZytDVFdsT240?=
 =?utf-8?B?VjNQQTJHSXNvNHNLemRQdkNmQ202d3J2cThwUTJWeFIrbFNDM0FKaENrSFg2?=
 =?utf-8?B?WUh4UjFXMzVtRGF1M3JRTFJZWEhaWTZUVy85RS9BTS81c2dGRUx6bDgyNVVC?=
 =?utf-8?B?cEIzamRJMnBjU0RIU0N2RVpsSjBuSGVEak94UWNhQS83WVVYRkJxNUE1bWJ3?=
 =?utf-8?B?TGJWTXVDTmVGNjJja1pmYU9iNU5qTHk1OFdaS3dhalpXTFRUQVVBaVppZGdE?=
 =?utf-8?B?dWZoTzBiL0t4WkFaQ1lXbEtRTDVlQ3J4UmwwOHVYUU9jR1VwbExkZlRQMERF?=
 =?utf-8?B?eUFBQjU3d0QrbldUMVFlN0ZwaS8yRlpISmo1cnJic0p1VGc5dmZRUHRxQTM3?=
 =?utf-8?B?dnlYREQySjZtcHAwZFFYL29nTFkvK2Y3bU0wZGlibEVkSlRodHVnTW5ES3l6?=
 =?utf-8?B?Sk5pRFdnbzhaL1RHUlF3eElUK1FQSWp2NW1mMkROQTJBeDdDSWlWZEdpQ0N0?=
 =?utf-8?B?SU1Idm42eTdpUUpzNGFlVUUxK0plQUNyTjlOMjBkQi9vdXFIZGJnYzY1Tzk0?=
 =?utf-8?B?K25QRUxVTWR5S1BrMXdick81cGJDdHdLRERjOGpDbVFJRnpKSXFBVE5VcGdB?=
 =?utf-8?Q?dkHIh25WQBlofVul2cq0H5ePC?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	zc7U6UkE3nKq22yNtDWrUq8Se9pQIvJEooMC3CCI4aRzzAHwANkTfWOdXzW0o8hrbNBiDdrV0dyt5P6SaSC0PW9U/i28NGCFGp5yEbDAVB0P9KUQIvWtavdg224t6eVBdHt/vAaXxcD1w1qmFO4/6mrSZG9Vpy8qtY45tYTarqFL6bZjSpLQU1vcGzWKtWFdmsJ99jclaNTB6GKQaLbQElqHS+1wMNCaXmlnJD6qcd3eZZvKZbQ1Y7HaUD4GZoKn+vbdijk22+3bg+Lgsds56NWFf3pmsY7ksPwOsg1Dh97EGqF7Z1KDXJvM2rALPlvjNuuPfXArSDs9idnZ39+0lRmciOj+ze2ZOJCZD2jMSpU7WBoeTjFQHBtY+0RhrU3BEgoMkE0QjBnhybXswfwwIIsPFhVNk8YZyKfYcX9HjgiqqMdABefizmiETxOhpHJrxK8LPiXfzniVBU/39r9HlDd2sOnKZV2OLMuRnivZxshtXXDV3I/iKdUoN8YUHA84gcTGFPIdnBB18EODzB6TNpq9H5RgHYEJeFk1oyOZwlxt0ZNAE46xA9+qxUdi9HvpCC6qpZwv77ctVM7/n27Fvh7EYzlB/RV5Vr1AjDojCNM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e0e8441-3647-4740-7c3e-08dda8dfd5b5
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5030.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2025 12:02:28.1885
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1e5pI14Q+lGB8KWlt2CedQurrMqaWH+53rL7h4PJittZ00M884VR/6DkNY9X9NHDVsNIrLec7g+bHZJ0CtWXhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB8031
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-11_05,2025-06-10_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 mlxlogscore=999
 bulkscore=0 adultscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506110103
X-Authority-Analysis: v=2.4 cv=LIpmQIW9 c=1 sm=1 tr=0 ts=68497057 b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=3yQ7c1qtOwSO99-j:21 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=QyXUC8HyAAAA:8 a=1XWaLZrsAAAA:8 a=yPCof4ZbAAAA:8 a=WvGSajoz8vpRsmAI17sA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13207
X-Proofpoint-ORIG-GUID: S0h11t6sSRPWHBnsXwUmPb1swVQ2YiZR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjExMDEwMyBTYWx0ZWRfXxhsIktdekQye kbzAXpMPnhg/YJd4/L1ohq6kuxk3xZlDsYyXtF1rAiygns56d517A7FMIJ8A2O7WZ/GKLqILuBZ x295aVzApZ4+IO3qYJV0uFXx3FAoLDhQIBcCg2S3zRI324VspW8P7fD5bFh4KZpkcrT6bQWam0L
 QFThPSun29eslQpvP8xsUdu9XKyuMd2VH8+/DgdkWxqRkj2gjwJFfm94XTgclhjRtYAQm7uN5gU LL7Ph3JckvgTxrnsnzHnjlvUWQ5e+G92AUp95w1T2cYtzm78TpG6w5fwmSNJRqD8fOjxlV/xpT/ 3PCF4Bi99FWf2ImePsDwd5gUdtS1JDE6Ga4K4GRW2hvSYfTY86DG9owrKyFgLXqGCtqw43UUugP
 5yzlE4zlIyyBG0Rz73hYOqBwRSQAZqr1rgRhP8Q3cbhBvRx8oZP/Qn8xdfZtgkbiXFl36DgR
X-Proofpoint-GUID: S0h11t6sSRPWHBnsXwUmPb1swVQ2YiZR



On 10/06/2025 20:54, Sean Christopherson wrote:
> Mark all arch events as available on AMD, as AMD PMUs don't provide the
> "not available" CPUID field, and the number of GP counters has nothing to
> do with which architectural events are available/supported.
> 
> Rename gp_counter_mask_length to arch_event_mask_length, and
> pmu_gp_counter_is_available() to pmu_arch_event_is_available(), to
> reflect what the field and helper actually track.
> 
> Cc: Dapeng Mi <dapeng1.mi@linux.intel.com>
> Fixes: b883751a ("x86/pmu: Update testcases to cover AMD PMU")
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Liam Merwick <liam.merwick@oracle.com>

> ---
>   lib/x86/pmu.c | 10 +++++-----
>   lib/x86/pmu.h |  8 ++++----
>   x86/pmu.c     |  8 ++++----
>   3 files changed, 13 insertions(+), 13 deletions(-)
> 
> diff --git a/lib/x86/pmu.c b/lib/x86/pmu.c
> index d06e9455..d37c874c 100644
> --- a/lib/x86/pmu.c
> +++ b/lib/x86/pmu.c
> @@ -18,10 +18,10 @@ void pmu_init(void)
>   
>   		pmu.nr_gp_counters = (cpuid_10.a >> 8) & 0xff;
>   		pmu.gp_counter_width = (cpuid_10.a >> 16) & 0xff;
> -		pmu.gp_counter_mask_length = (cpuid_10.a >> 24) & 0xff;
> +		pmu.arch_event_mask_length = (cpuid_10.a >> 24) & 0xff;
>   
> -		/* CPUID.0xA.EBX bit is '1' if a counter is NOT available. */
> -		pmu.gp_counter_available = ~cpuid_10.b;
> +		/* CPUID.0xA.EBX bit is '1' if an arch event is NOT available. */
> +		pmu.arch_event_available = ~cpuid_10.b;
>   
>   		if (this_cpu_has(X86_FEATURE_PDCM))
>   			pmu.perf_cap = rdmsr(MSR_IA32_PERF_CAPABILITIES);
> @@ -50,8 +50,8 @@ void pmu_init(void)
>   			pmu.msr_gp_event_select_base = MSR_K7_EVNTSEL0;
>   		}
>   		pmu.gp_counter_width = PMC_DEFAULT_WIDTH;
> -		pmu.gp_counter_mask_length = pmu.nr_gp_counters;
> -		pmu.gp_counter_available = (1u << pmu.nr_gp_counters) - 1;
> +		pmu.arch_event_mask_length = 32;
> +		pmu.arch_event_available = -1u;
>   
>   		if (this_cpu_has_perf_global_status()) {
>   			pmu.msr_global_status = MSR_AMD64_PERF_CNTR_GLOBAL_STATUS;
> diff --git a/lib/x86/pmu.h b/lib/x86/pmu.h
> index f07fbd93..c7dc68c1 100644
> --- a/lib/x86/pmu.h
> +++ b/lib/x86/pmu.h
> @@ -63,8 +63,8 @@ struct pmu_caps {
>   	u8 fixed_counter_width;
>   	u8 nr_gp_counters;
>   	u8 gp_counter_width;
> -	u8 gp_counter_mask_length;
> -	u32 gp_counter_available;
> +	u8 arch_event_mask_length;
> +	u32 arch_event_available;
>   	u32 msr_gp_counter_base;
>   	u32 msr_gp_event_select_base;
>   
> @@ -110,9 +110,9 @@ static inline bool this_cpu_has_perf_global_status(void)
>   	return pmu.version > 1;
>   }
>   
> -static inline bool pmu_gp_counter_is_available(int i)
> +static inline bool pmu_arch_event_is_available(int i)
>   {
> -	return pmu.gp_counter_available & BIT(i);
> +	return pmu.arch_event_available & BIT(i);
>   }
>   
>   static inline u64 pmu_lbr_version(void)
> diff --git a/x86/pmu.c b/x86/pmu.c
> index 45c6db3c..e79122ed 100644
> --- a/x86/pmu.c
> +++ b/x86/pmu.c
> @@ -436,7 +436,7 @@ static void check_gp_counters(void)
>   	int i;
>   
>   	for (i = 0; i < gp_events_size; i++)
> -		if (pmu_gp_counter_is_available(i))
> +		if (pmu_arch_event_is_available(i))
>   			check_gp_counter(&gp_events[i]);
>   		else
>   			printf("GP event '%s' is disabled\n",
> @@ -463,7 +463,7 @@ static void check_counters_many(void)
>   	int i, n;
>   
>   	for (i = 0, n = 0; n < pmu.nr_gp_counters; i++) {
> -		if (!pmu_gp_counter_is_available(i))
> +		if (!pmu_arch_event_is_available(i))
>   			continue;
>   
>   		cnt[n].ctr = MSR_GP_COUNTERx(n);
> @@ -902,7 +902,7 @@ static void set_ref_cycle_expectations(void)
>   	uint64_t t0, t1, t2, t3;
>   
>   	/* Bit 2 enumerates the availability of reference cycles events. */
> -	if (!pmu.nr_gp_counters || !pmu_gp_counter_is_available(2))
> +	if (!pmu.nr_gp_counters || !pmu_arch_event_is_available(2))
>   		return;
>   
>   	t0 = fenced_rdtsc();
> @@ -992,7 +992,7 @@ int main(int ac, char **av)
>   	printf("PMU version:         %d\n", pmu.version);
>   	printf("GP counters:         %d\n", pmu.nr_gp_counters);
>   	printf("GP counter width:    %d\n", pmu.gp_counter_width);
> -	printf("Mask length:         %d\n", pmu.gp_counter_mask_length);
> +	printf("Event Mask length:   %d\n", pmu.arch_event_mask_length);
>   	printf("Fixed counters:      %d\n", pmu.nr_fixed_counters);
>   	printf("Fixed counter width: %d\n", pmu.fixed_counter_width);
>   


