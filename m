Return-Path: <kvm+bounces-48581-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 44065ACF797
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 21:03:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F30BC171E88
	for <lists+kvm@lfdr.de>; Thu,  5 Jun 2025 19:03:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B36B27A928;
	Thu,  5 Jun 2025 19:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Mgz4OTbH";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="iFwBLPhk"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C571F18C06
	for <kvm@vger.kernel.org>; Thu,  5 Jun 2025 19:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749150218; cv=fail; b=fdPHrnUV2A3HI0bhkcy9fcAfspgVuXMDURmDWdbdpeSUH8dC/OYDMNklOtyO2b2YKwtlbznqDrC9ldDh5GN7EnEAijrZlE2e+TkFByOzjBgY20OnUjaJ3Wq0mUAdr2H8jYoGercNrGtXptoaG6N75Zx2elGJyZ43qpNl47RL5lE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749150218; c=relaxed/simple;
	bh=I1FRn904ia6nArxh6I/kbD/pClzia5JYd4aHiLtB01Y=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DTvlkhavUe8HGBl32Rdw5TypDBUW+cY/aNjmPwHSwFEy63TIwIwTIgpL2qKilLifLs0cxRqprOxpuNdcC7bAvHT2gwkIgsZCt07SLlq2ZfIhmnkxZBqqd4umzyIPSl9A4Xk5fMIRumg6Jey+kF/hL4UhOd0aYQ2bgoYvmF93ZCY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Mgz4OTbH; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=iFwBLPhk; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 555FtXbf022629;
	Thu, 5 Jun 2025 19:03:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=TpcwrsyrqZO+T4SqNI0fE5OcuuPFwvr190K+rYNzi6M=; b=
	Mgz4OTbHBYmM+MQwlvKbXgkH+0KxusyIPA3U9J53BqcI/caiBHKWdy6BpqyKdULk
	tvuMi6OAXBfgrJfaHiW4kxJmfTbcAneAgmhG2N5Ewr5K+gd3ZTG5BoDfb6sOYdMp
	slSMxxcxtzqQGFV6Hiaf0kyevq8ExjZSmayo9NWFvfOfIKHp1aDjZe/8RTSmHuZ4
	FAsea12yUL4nzV4mVQlSqWIQHPb7xL/JO9MalempBIs3xEbNfldxSTdw7qpCGzb+
	dsbYA7zuzxff+c9jTSz2ZsG7X2qdUD6aSY5enEvNP6CJdA6qw2vF/zA3Ub42oLFz
	ZrUC/nGgK3Dcqs8e+VzHeg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 471g8cxs5v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Jun 2025 19:03:30 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 555HOqun034359;
	Thu, 5 Jun 2025 19:03:29 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02on2086.outbound.protection.outlook.com [40.107.96.86])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46yr7ceu5t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 05 Jun 2025 19:03:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YysSvRYmDoFqD+Ho5gZLWu/ZOTGOMRHZgrW1i9TTBl4jITaua/FLL/2Tkh19AWOrQIeXZvZSeSIfOyQaMaHBHyaYZhzOaAuZ3ZSpsmpQYfcgJ60vh+RoEBStKhGVkkWgyfyDqZ+Lsshc5L0u8IRUdsWQZ8whTann8wYTmpzLP2vMcjPOGf3nPKVf/tlQ1AzKkldXdkKGs5YwQImdmY2BlR8t8e50dcBpMeFTj1es11/1IGi9GRmvPKZ6DywjnbPi786PWwafoi7aAwNwIapfKcAgKQ0+yM2AyknYia4r80jZfgPQV/V4O7NgN/BwWfxP8tLUGpI0njAqWY9zEH4grw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TpcwrsyrqZO+T4SqNI0fE5OcuuPFwvr190K+rYNzi6M=;
 b=pb926SQQpCddCZE8AeP7/zCnkjxAO0nNHqEsJ0bOMbnM2q77Y47aUwJ8C7JN9h0WkYskY7Wgc3H/pBitTZVqXyPRphV/8jsStHANxrpXBAik6nkNVP0QKKOI7tNPorwfj/sxGy5xktJR2kDP9HHSBG/W9Ee470HfP8LuX3jOCLzTKCQthgr9US5o9Uiy3dz4gGxVqYgqHL9QYa0aB4OcT7kzodWgRBoMZ/MgygD/6iELHmI0Ry7wI2v7QfElGWAjgQIYqEd7Pu8stryGc2Hprao9dE0XBs8E0QxQIuXv8e/zvsEIQwX+tr6mowQPPe9JzOeGPaM8TlV5V2CeYzyh/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TpcwrsyrqZO+T4SqNI0fE5OcuuPFwvr190K+rYNzi6M=;
 b=iFwBLPhkmc/ldaOBb7AcIV/lwCj3C0Ql8iHHFljKRav+JSShahkgtHo+hrSGtHmKaod68/7SAEb4O8GRuInii6n7p/LqcwYR4/ZY+to0jxpU92bfEQSrwT5ljmSn1JV+/HM0XajLq30OxCdiv/UgfmZ7drEmf8lVwXp5pOeisEc=
Received: from BN0PR10MB5030.namprd10.prod.outlook.com (2603:10b6:408:12a::18)
 by CO1PR10MB4420.namprd10.prod.outlook.com (2603:10b6:303:97::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.20; Thu, 5 Jun
 2025 19:03:26 +0000
Received: from BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::44db:1978:3a20:4237]) by BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::44db:1978:3a20:4237%6]) with mapi id 15.20.8792.033; Thu, 5 Jun 2025
 19:03:26 +0000
Message-ID: <03b2e404-afa7-4b12-bcc8-ffea92fe088b@oracle.com>
Date: Thu, 5 Jun 2025 20:03:21 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] KVM: Batch setting of per-page memory attributes to
 avoid soft lockup
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, thomas.lendacky@amd.com,
        michael.roth@amd.com, tabba@google.com, ackerleytng@google.com,
        liam.merwick@oracle.com
References: <20250605152502.919385-1-liam.merwick@oracle.com>
 <20250605152502.919385-2-liam.merwick@oracle.com>
 <aEG-bmjRgqlxZAIR@google.com>
Content-Language: en-GB
From: Liam Merwick <liam.merwick@oracle.com>
In-Reply-To: <aEG-bmjRgqlxZAIR@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR06CA0090.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::31) To BN0PR10MB5030.namprd10.prod.outlook.com
 (2603:10b6:408:12a::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN0PR10MB5030:EE_|CO1PR10MB4420:EE_
X-MS-Office365-Filtering-Correlation-Id: 2421a039-ff35-4b1b-97d1-08dda463a6a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZjFRVS9pN1Yrb1dhZ1JBR1M0VTI2bVI4SUUwaUJYZkp6Y0NpS25KM1NRWmQ4?=
 =?utf-8?B?SWcrdVBrRXRranNlaDVURCtaRk5Pamk3UEpHWGhuZkUrWm5nR25zd2h3WFZD?=
 =?utf-8?B?REJNaWgvdDNMd0xZUlJKa0JpQm1mUm5HYWd1aFRoQTdkZjgyK3dscWFkTzda?=
 =?utf-8?B?MkhKYkE0VmZXMmlZSjRDYzl0bjlPNDg5NmxtZEhlQjlReXo5c0YxSGw2SlE3?=
 =?utf-8?B?UlAxUnFLUkQ0OHNpcU5BckZXSVAwWjJzVldJOFRMdDlldVRzc2lZU1diNnRL?=
 =?utf-8?B?YnpkTTM3OHNqWEUyVHhuZnpadkF4ZjhYdVRnc0NkTmppWWpYMlgvM2lNSXkz?=
 =?utf-8?B?V204K1JUeDdyMEs0Sm9YcVArNVRUNWNXRzRFRjdQczk1c2dSbS80WXFoTWRs?=
 =?utf-8?B?aktaZUNMYzV1dE1TbWhUM1R4WUdqY2FvZFVUYVp3d3JLZUxYRC96NHNIaHVR?=
 =?utf-8?B?MzZ6Si9Zb0FRdGQzeWZrNGR0Q0tVdDJjZWRMN3VmVzJoZHFmTHdWL1J3QjZ1?=
 =?utf-8?B?S2pPYURQUm9GQzRzVDd2T291NXNzcllpNytRcmVlY3VPVlZ2QTVXZHdaNDg4?=
 =?utf-8?B?R2FiR1l1a3pyMitTbDdFakUyWkFFL2xEZU15Tzg2N2diSjZLTXc2Y2szeS9q?=
 =?utf-8?B?NXZ3ekxQcUxOY2ZHNFN3dUJRQUpqd0RUc1Q1WFRKYm0wcDFWNWQ5V3p3OERY?=
 =?utf-8?B?VnpGRzg0QWRzRWE4WXk3V2w0SmFZd2U0WmJGOVpOZVpSRGVqRmdESjBBT1Fq?=
 =?utf-8?B?amFJb2kvUVRndk1qbzJWbk0vYmFqaFRyV0hVSjFCVDlkMThGZTdRQlhPdUxG?=
 =?utf-8?B?bHhzTCtnTlVTMHZpcDVySFlTcVpmcjg1UGtqZjQzdC9mbmlkdTg4OWdhYW4z?=
 =?utf-8?B?d3Mxd1RqYXNBelQvQWM1bjJoYnNERStVeHo4cnprbjA1SGltbUJRZG1FNU5W?=
 =?utf-8?B?Umw3TUpKaERPc3Z2WU9qNVBVM3UvUk5zRVlTemc5c0FKWG1qZk1DR0k3eHRv?=
 =?utf-8?B?dkx3T0kxMVFNVTRZYklOcWt4akpLVnlMTHpnVGduSXR1ckdsTHV1ZmN3dDd1?=
 =?utf-8?B?bmNsK1VuQXYvRndjZTZGNTJmZnhYTkFnT2NiSURuOXk4TDZFV0FtaFJTZXhn?=
 =?utf-8?B?ZFpGMlZiRk1QZytDcGhqZWhYS0w3dXVUdUgraG9hTTBINURBTHRmeWxUK0Nm?=
 =?utf-8?B?RFZhYzZSd2ZFcjJlNUMrSHBrQ2pWNkJPZmFGaERqU211QytvZzB6R0RRQng0?=
 =?utf-8?B?c3NBeGZsYVBUQ3Blam9wNDBvb3JEZUpjN0hVcGo2ekNOSmxqY1E4VEpWOGZi?=
 =?utf-8?B?VE5lT1pIYytMbWk3UEoxS2ErbWNoMkI0ZXR4OUJ1T3JMaXEwUlpjb0JCWWtZ?=
 =?utf-8?B?R0htMnRvSGliNmViY2E4VjJXaDFMK2J5U1orSEl2UWIvQmZBS1ZuTVZZMWoy?=
 =?utf-8?B?S1hjSkw4c3YwbTZFcWh0Vk56Mng2ZUFhMUZHTDUvY2ZmZlpwUlFwQjdHcjgz?=
 =?utf-8?B?R25mRGVwcGZVQjdFNlhvcVozVUpJdGxPK2Zjc1BpdUlibE1vWVFVc2hOZkYr?=
 =?utf-8?B?Qk4zdFRZMERlWTlOd09UbHVhQXV3V3NrUXMrSThmNzBUSXpxbFJsVFlVNW1j?=
 =?utf-8?B?RkxvQldVTjN5eVFXYkhyQXRJOENkclBTOTFLVlZBbE8zUDN2TUllQ2swTkRR?=
 =?utf-8?B?RnNtVDVlSXJYQjZqb3RGTDRIQ0VMZ2FxZWxIVllVSWw1SlFlTkliazhmVVhJ?=
 =?utf-8?B?aWVBa3VWd1kwekZiWkhLaTRTQy9sL1lrNTZrZzJ0Q3hpYlFmenNJUmhFcFN1?=
 =?utf-8?B?dm1uQzh5eDhZU0hQbXNoMEI0UjdvYzI5MkRubkV4a3pNQ2NOTGxnbEpuRmNF?=
 =?utf-8?B?RXBrRXhPc2RUdGtQYnZ6KzJRUjExVnZWbml1K0xBM1dpSFpKZTEzeEVtZ2d3?=
 =?utf-8?Q?JG6GkS+T/u0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5030.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZFl1UkNLOEozQiszVHptb2N3bytRWmNrYVhtdThvMG1HQ0FJOVlwNkhkQkxx?=
 =?utf-8?B?M0FmS0twcmNseGhoeHVkT1FITU1PQnNWa2VWZ0pac2k5Y1V4WHFjVk8vRW5z?=
 =?utf-8?B?RnJOTmppSzlqMDE2eHFmaTlxTHBvN2EwZ3hHRERYRVNaQmV3aHBUalRkajlk?=
 =?utf-8?B?dm4vSXRTbzdwN2J6QUVvVEtObnNPbGxEQU1mV0kvL3NySFBEZ1JKU29hU2pu?=
 =?utf-8?B?QksvcEtZaGJ2d2U4N2Y2ZE41Skw5a1VITVgwVUMxVGNFZzJoNStQT2RPWkNv?=
 =?utf-8?B?eDZaeWdkaHgzNitnTnhva2R1Zmk1UkFCaDVDdk1BVDBLZXdtRmxMUVF3Qmtx?=
 =?utf-8?B?bytvaGpQZVFkK2ZPdk5pSGo0V3N1T05UTDR3K3hhN2ExVHFsdGZObEJRdU9j?=
 =?utf-8?B?SS9WenY3b0kxdUp2cVVDcjcxQitzSDFoTzl6MndQc2RKRkZXamh4MUg0RlRG?=
 =?utf-8?B?T3BjcmV0ZGc0Mnhjd2dCZE5EYWZiamhhMHJyYnF3bHZwbjI2K1BkbW5iYmxa?=
 =?utf-8?B?VkY0NjdHVnpQbFovOHhnOFJrQmNOeDByeUIybW1GQnVrcnAxWkl0L1QrZEU1?=
 =?utf-8?B?YzMwRURuU3RRNHdlNmlOeUtFOTZ2ZVh0MngvS3QrUWR2blEwc1VZVmpvcXZQ?=
 =?utf-8?B?VGNZQk9kbTYrbjBNZldXbGwzN3JWeWE4Sm1ZUzNwb2NsNTNIUldXclJWR1Nv?=
 =?utf-8?B?OTVuaWp4d2ZMdE5rMzRYaWVhNUVPWnRvV2k0bUhTUjBHejMyYWNWbmpFUnpj?=
 =?utf-8?B?NElydVNGa2RTMWxUaXM5M0RZL2pNVWJHWjVrUFlKeWJlUVkxYitmOFBUNTNX?=
 =?utf-8?B?bGFZY2JDMDU0T3ZwT0dUMnJPa2hiN2xJVHZaVWlqUXNSMXdwUVEvODB2dEJG?=
 =?utf-8?B?UHhwNndSbTdrV2g5V2R5aTdPOS93M1hIWklxcmhkUEVxQWdMeGNYZGpBeEdi?=
 =?utf-8?B?UjlnOFdrS2ZOVGI2Y0xQeHJCYzZhVlE0MUlxdGZqZnFtMVNIck90RTEyd1FW?=
 =?utf-8?B?TDY3WS9VYnVVL1NxSGRpcC9NejdOdTdYQ240Q0t3Z0o1TVMyRm1MYVZMcjNK?=
 =?utf-8?B?NWI2RTYzYVlrcS9ENU9IVXM0S1hldzVxaElXM1hiMmxkbktxd1llQkptNkJC?=
 =?utf-8?B?Z2VEYTBVQVhMYXdqZitzL01pR0kyTWJ1TUY0eGMzd3NrRnN1VCtoZzVwMkFB?=
 =?utf-8?B?VnRHNGZzRlVQT0txa3N0anJPS09ZcDB3YmgwTkMvRWV4cHlTaThOd1J6a1Yw?=
 =?utf-8?B?NzA1Wk1aZWc5YmFja0RBbkxPT2xxRFpPaVlsb1dSNE9ORU1HQlFJbHR5UlQ0?=
 =?utf-8?B?eW1aNFJxL3pqZ0hlY2FEOFZoWW5qYy9NQnAyMCtoVmhnZWk2SHVLdW5HSlFO?=
 =?utf-8?B?UGE5MDdiR295czdlQ0JKR3F0MHlNN0JpUDNSNkZLT243dUlmYjVFT0hDRWdU?=
 =?utf-8?B?V2RCWDFkSkR2NmplMWMwNlJVNHJkeldacGZXUkJPMWhHSFNwSTZGRDB1S01F?=
 =?utf-8?B?MDUyY0VJOWVKREIvVnJkeFBEdE0xRzlzd2NPNDB6d2J1SkFrWTJwN2tWdFdL?=
 =?utf-8?B?RUNHVTFabG9Xa29KN0FvR1FuMGJadUc0MkZMakdGZTkrTlBoZ3VWY3E1ZTZQ?=
 =?utf-8?B?Y29QOFQrVGliajJ1RGRDRUVOWGJRYk53cjBGOWtockNiajdNMVBpMVdsRFJO?=
 =?utf-8?B?eUcvalYvQ2xBWjhPZFp3MEFrcEt0V0dIVTVmS2M5WGNTSnMrWWpiM21EL2Vn?=
 =?utf-8?B?aXZONU9XTjNTYVZHY0JNSjN6elkrYklCYWVUYXhxZStlNU5NTWlLWjJEbVFz?=
 =?utf-8?B?YTNCMTN1WVFPUFJ3Mk1BcElBSklJeWxIYjQvSVhDRng1MitFZW1RM2FCYjBU?=
 =?utf-8?B?UW80eGt2SVNuUTZ3clJUM3F1VU1rWUlzcExrYXZ0UHp2SzloVW15R0FhMjJn?=
 =?utf-8?B?T1NCbExOc0lVc1pMSlNRcFNUQlUzdyt4c3QzNXZrbi9MQ2FTNjk4T256UlBq?=
 =?utf-8?B?Z3dPbnVJZ0VoWGxuYzkxaXI2a2ZCSlkxd09CNUpDa1c0R0t2dzBwVFZqeUhD?=
 =?utf-8?B?ek5ucFo5MjZXbWxEMGtzdzlXWmlIMHE5VXZiNFE2MkhrRHo3TmRPVC9kTVRs?=
 =?utf-8?B?ZEFqeFJmakxSbGsreUVUeUp6ckZDT2JOR3RBQ0QxUnloWnJZMWgvSjNCV2M0?=
 =?utf-8?B?bnc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VTfIeYvDGjGuPLke+4OmjrZGBvuK9V/Bcd/Z+WKB7AAVm39fqRh7+Y6qqCBHjbFWwXz5B+4EMgEhNpfOmuXreIF9csIwkR9xlTh74DGD1yBoNJrTdvEMnQBHlW8rzHnav3z3f8hmjNhEKSRqV2KRfBI3v1rSYavLDREb4N2QUKuSCDiS1qhylH0GxB96Te1Z4XQ3VyQK/m+kPtsL2V9D8hnWvfbi+/ea/9M68YNSLB+DMX9Q8aZDfA2AZilbZNj+B+9cWOyaoPJSfoHaSxuDci6ObM1qo737YJ3CA5zc7APPogRNYlrfCmwXjViooOBkBZmVRh28TnQIudyXu5AXuigwiH/FwPwe3mrPe/tVuG1o1l+1/a+GHOaBFafZP9ZEBMRmhWJFoWQ8W9DlcztvfwYWTSKu7FB3W8gJLgvxj7WK1JlEnvBrWAkNBaB7Udoe2+KMJIz/eIWOSs8GbyaWlOOcl1N26xr6lL/p1c9tLQAt0jgr1uoBAC8iK4jtP1KpTy8N/rqsCmG+55NCW9XVCAzMHiOA+oI981OTgX2KfmAwFOS2rqpHeUide6wZJMNdI3kn7mckrxe3mxDZ2sEV4W323DuVYTLguqN7HUBjAp0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2421a039-ff35-4b1b-97d1-08dda463a6a2
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5030.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2025 19:03:26.2398
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DNlcqYjuqESZRdaxVVFEef64A+/CGMuWyD9K/lVzCAEm3px3gOp99B2C9rAymy+TtwTWy01x+S2NCwlazviWWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4420
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-05_05,2025-06-05_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506050170
X-Proofpoint-GUID: VP3U2uC0PrCoEPCFChz_Vxg4pgMukajs
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjA1MDE3MCBTYWx0ZWRfX0e04SN39Me/+ vkjx1Cmgu90ym34ae1zTwN00XB4lef0yVkuv1kJHwneLIdykq6wt2/4c78s7mda0WVFXnE0wC2a AHa3vZzlMl/FyZjMXhnpmrAG+Mwm2V05ULWi4BYGi2xmDkrYT9qNxJDWXUl1ft6YX0DWsZNd4A4
 nJT16IR1uYpxPaaVEjad6fp7jS5O2HNNuHVtJutZvFQALsqdVLVmdGwUEWzh+4iGbeos9EH/Vul uhLuGYAlj50gL0LPVrnkPw0Uz95F3mOuN75hRledN0qxiPnm614NfmA5VncunR8rvzWMDrH9TyY l4OyMyDMuUzJ7ApD4Vu5oypV+9wlDE98cxk8vA9GEAzDAtWhuZpeLNHKnH29vQwjLbCKcGujGOB
 0xyALiA9L0QyDtLe0MZu9mDB16p501JIw6YEOuiL3MjMbtLhBA1HvXeC9EFL4Mw8WpFNafQk
X-Authority-Analysis: v=2.4 cv=KaTSsRYD c=1 sm=1 tr=0 ts=6841ea02 b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=RLsDiMGc5Gk9ZDdDfrkA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13207
X-Proofpoint-ORIG-GUID: VP3U2uC0PrCoEPCFChz_Vxg4pgMukajs



On 05/06/2025 16:57, Sean Christopherson wrote:
> On Thu, Jun 05, 2025, Liam Merwick wrote:
>> When booting an SEV-SNP guest with a sufficiently large amount of memory (1TB+),
>> the host can experience CPU soft lockups when running an operation in
>> kvm_vm_set_mem_attributes() to set memory attributes on the whole
>> range of guest memory.
>>
>> watchdog: BUG: soft lockup - CPU#8 stuck for 26s! [qemu-kvm:6372]
>> CPU: 8 UID: 0 PID: 6372 Comm: qemu-kvm Kdump: loaded Not tainted 6.15.0-rc7.20250520.el9uek.rc1.x86_64 #1 PREEMPT(voluntary)
>> Hardware name: Oracle Corporation ORACLE SERVER E4-2c/Asm,MB Tray,2U,E4-2c, BIOS 78016600 11/13/2024
>> RIP: 0010:xas_create+0x78/0x1f0
>> Code: 00 00 00 41 80 fc 01 0f 84 82 00 00 00 ba 06 00 00 00 bd 06 00 00 00 49 8b 45 08 4d 8d 65 08 41 39 d6 73 20 83 ed 06 48 85 c0 <74> 67 48 89 c2 83 e2 03 48 83 fa 02 75 0c 48 3d 00 10 00 00 0f 87
>> RSP: 0018:ffffad890a34b940 EFLAGS: 00000286
>> RAX: ffff96f30b261daa RBX: ffffad890a34b9c8 RCX: 0000000000000000
>> RDX: 000000000000001e RSI: 0000000000000000 RDI: 0000000000000000
>> RBP: 0000000000000018 R08: 0000000000000000 R09: 0000000000000000
>> R10: 0000000000000000 R11: 0000000000000000 R12: ffffad890a356868
>> R13: ffffad890a356860 R14: 0000000000000000 R15: ffffad890a356868
>> FS:  00007f5578a2a400(0000) GS:ffff97ed317e1000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> CR2: 00007f015c70fb18 CR3: 00000001109fd006 CR4: 0000000000f70ef0
>> PKRU: 55555554
>> Call Trace:
>>   <TASK>
>>   xas_store+0x58/0x630
> 
> Trim the '?' lines when including a backtrace in a changelog, they're pure noise.
> 

Ack

>>   __xa_store+0xa5/0x130
>>   xa_store+0x2c/0x50
>>   kvm_vm_set_mem_attributes+0x343/0x710 [kvm]
>>   kvm_vm_ioctl+0x796/0xab0 [kvm]
>>   __x64_sys_ioctl+0xa3/0xd0
>>   do_syscall_64+0x8c/0x7a0
>>   entry_SYSCALL_64_after_hwframe+0x76/0x7e
>> RIP: 0033:0x7f5578d031bb
>> Code: ff ff ff 85 c0 79 9b 49 c7 c4 ff ff ff ff 5b 5d 4c 89 e0 41 5c c3 66 0f 1f 84 00 00 00 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 2d 4c 0f 00 f7 d8 64 89 01 48
>> RSP: 002b:00007ffe0a742b88 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
>> RAX: ffffffffffffffda RBX: 000000004020aed2 RCX: 00007f5578d031bb
>> RDX: 00007ffe0a742c80 RSI: 000000004020aed2 RDI: 000000000000000b
>> RBP: 0000010000000000 R08: 0000010000000000 R09: 0000017680000000
>> R10: 0000000000000080 R11: 0000000000000246 R12: 00005575e5f95120
>> R13: 00007ffe0a742c80 R14: 0000000000000008 R15: 00005575e5f961e0
>>
>> Limit the range of memory per operation when setting the attributes to
>> avoid holding kvm->slots_lock for too long and causing a cpu soft lockup.
> 
> Holding slots_lock is totally fine.  Presumably the issue is that the CPU never
> reschedules.
> 
> E.g. I would expect this to make the problem go away, though it's probably not a
> complete fix (I'm guessing kvm_range_has_memory_attributes() can be made to yell
> too).
> 

That indeed works. I couldn't trigger anything in 
kvm_range_has_memory_attributes() but am limited to about 2TiB.
I'll do some more tracing before I send a v2 to see if there any more 
places that might be close to hitting the limit.

Thanks,
Liam


> I'd strongly prefer to avoid arbitrary batching, because that raises a bunch of
> questions that are difficult to answer, e.g. what guarantees 512GiB is a "good"
> batch size on _all_ systems.
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index b24db92e98f3..28230bad43f4 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2513,6 +2513,8 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
>                  r = xa_reserve(&kvm->mem_attr_array, i, GFP_KERNEL_ACCOUNT);
>                  if (r)
>                          goto out_unlock;
> +
> +               cond_resched();
>          }
>   
>          kvm_handle_gfn_range(kvm, &pre_set_range);
> @@ -2521,6 +2523,7 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
>                  r = xa_err(xa_store(&kvm->mem_attr_array, i, entry,
>                                      GFP_KERNEL_ACCOUNT));
>                  KVM_BUG_ON(r, kvm);
> +               cond_resched();
>          }
>   
>          kvm_handle_gfn_range(kvm, &post_set_range);


