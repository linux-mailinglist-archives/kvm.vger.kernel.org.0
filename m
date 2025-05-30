Return-Path: <kvm+bounces-48109-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A4E32AC937E
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 18:25:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 207B23AB53B
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 16:23:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55A3B1C860B;
	Fri, 30 May 2025 16:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bTIJYmio";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="eSqz2rWh"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8943D1BD9F0;
	Fri, 30 May 2025 16:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748622235; cv=fail; b=XWt08s2YsNjFMo+nkQlxxqauQaIp22+U39kd0rBzBSDEMz/wkMSfgLwOGtOBwVQsVh1rHSFaLYqWGZFmo11qDn9x01KlLQF5XspmyP4xicV5JJn5goW/sOXI5bl2bKp+BZGIvDVZaZwlHjbP53jrW2cxdAwbNmBYAB6ExMiQ6KU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748622235; c=relaxed/simple;
	bh=fv50gM84lIu+dXQRY8xnWzPxChGhq4xfuaHspm1xl14=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=agN2Az86mJkuEeSTMlvP4by7ItRbzhENBD1Lpt2y2Ea3U0IdBr3dtX2Gqr6mSGuYiEgERyjXjQd1we56APYf71O3fjj9fbldhofk3rikek4CI96UjnaJZhNrFpg30RWXhJvrFDtv35yH/uVkvC50CMN6iN1Yc63vwudvXEaE+rw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bTIJYmio; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=eSqz2rWh; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54UGNBML007556;
	Fri, 30 May 2025 16:23:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=LlF1p+jQTkQSme2BhgBF96xhIP65ewhmSaPSPgrFHH4=; b=
	bTIJYmio4CRcy1GI2SGPcmrUIGXfxuWWNFDc5rU7iLTTotK6xCJmvc14V4fCfSoy
	4Gi4MYY8h5Zn8PxmZcBegaMuNQdlyl4kCiU6NjbcVPzPXro8ZSdapiuT4O6qMp6u
	DAICXGkJvdO52jMoLrjx2JW1ZdXX/R5jU4S6G0JJO+Jftow+2o4GP/qHVtSTgboF
	yLzsdLaIp266f9VJg0KOFmQL7Ycs9nic1J3H+o1i5L7tPSYhoL83owy57gMVDW/e
	EUQ9b/Yt4PKuhKmO5WnBuol8RMFul1n6q4AfrIPwZO3/4XCgC4Ts/TCHRCxqBlJh
	8CE8uN13Jjo89fqSjrC2ng==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46v2pf2947-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 May 2025 16:23:11 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54UG6k7g019494;
	Fri, 30 May 2025 16:23:11 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011007.outbound.protection.outlook.com [52.101.62.7])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46u4jdg1e6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 May 2025 16:23:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jSMq7K2nD1UjdWxwd0vCAoChp6DU1XFU4Ft4mtRkvg7eJskrndNHiALi1thWpihcEn+x/0kK3kXx+M0pinWwsFcldOp44OZ7ESnoQMyroMJ6c7Sn5oHYzUljSD2R1Y9Kczshkp9St34RFDOvfVISmCf/XyTFdFGeLWufcOtOQn00FdqBlxOY/n2N+XCvOFPHERFAPspUkHcMGVGiMJz8wMGctPa3iCWInRkJzfkczNSJ8ArfZrkNuc7xUJh7O1TomS2MbMaNZ7WUKjWho8hfj/FaFx3ttru2zP8muDRXoW2ndJuwMzWEObPyRZU8772sHpH6h//T+3GlyuY60wFl2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LlF1p+jQTkQSme2BhgBF96xhIP65ewhmSaPSPgrFHH4=;
 b=YsMBxCbSSASnwAZUBu6bY1W+qlq5G/lb99sfPBCl4xlzsiZ4Ruf+faWCyn8TJj4JeiV+eo1YiYZ7xw6FteX3jK30/TmmlHdd+5b/sOXKs1GUUlUPaHud+tIqcQZ79cXK25EScOo7ehLrF4qd9F0X38Hw2lORDTpZNeyQEwhna7cwIQMfFp8pjVZxdECVq20z5mlxx/nm7s5bC6uRRS5K56lzQwt8mU5gMQr+n7nw99KRW6WP2KX7S13Ndc/Oz5sohKQM4UmXlYWUi15VmMZUGMPDVKtnAv3rZP/S37C6Rw9mqQqC+8d9hHnBrzvqItNx02U921sXtFZK6LPstkGVpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LlF1p+jQTkQSme2BhgBF96xhIP65ewhmSaPSPgrFHH4=;
 b=eSqz2rWhLx/hzLB5SAIhiqeluaZDKnqFVNoyd1RTMwI8ro65/NmDxgyByzojz/g4Jvg11InRKMA8JQd6gPnQEC0QJgvtahyIIQHoPFoPBe8P2jno6SzBNnSPJDn3M7SrZjR/C0RVLGryrEiTvl18rQmPI4iOR+zprJmOvMJlZk0=
Received: from BN0PR10MB5030.namprd10.prod.outlook.com (2603:10b6:408:12a::18)
 by PH7PR10MB7033.namprd10.prod.outlook.com (2603:10b6:510:276::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.40; Fri, 30 May
 2025 16:22:52 +0000
Received: from BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::44db:1978:3a20:4237]) by BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::44db:1978:3a20:4237%6]) with mapi id 15.20.8746.030; Fri, 30 May 2025
 16:22:52 +0000
Message-ID: <32b6afc7-c039-4a7c-b311-c39eb6fe197d@oracle.com>
Date: Fri, 30 May 2025 17:22:48 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH 15/16] x86/sev: Use amd_sev_es_enabled() to
 detect if SEV-ES is enabled
To: Sean Christopherson <seanjc@google.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Janosch Frank
 <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        =?UTF-8?Q?Nico_B=C3=B6hr?= <nrb@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, liam.merwick@oracle.com
References: <20250529221929.3807680-1-seanjc@google.com>
 <20250529221929.3807680-16-seanjc@google.com>
Content-Language: en-GB
From: Liam Merwick <liam.merwick@oracle.com>
In-Reply-To: <20250529221929.3807680-16-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0298.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:391::8) To BN0PR10MB5030.namprd10.prod.outlook.com
 (2603:10b6:408:12a::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN0PR10MB5030:EE_|PH7PR10MB7033:EE_
X-MS-Office365-Filtering-Correlation-Id: 43443b1e-0f3b-47e9-ced2-08dd9f9639a0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QnB3WWxkbW9zRDNtNEhHVEVrTDBEd2FTVzA4U0dONFZaQXNpazNtMnBCL255?=
 =?utf-8?B?K0Z4a3ltOGYvSzZwRmFRajQvSm00eHRBc3FCTjMyUWtWZUVVZlExZzc0UFVQ?=
 =?utf-8?B?VGliL3UxUHgySmhES0ZIaDVOM0tkemIxNmZDdWd2dXlPazcwbVVqM3RUVXJo?=
 =?utf-8?B?dUU3dWlDNDFvTnJIRUZEM0poemN0TlA1cHpTUU1XZzJONUlNYVVRcEVqamE3?=
 =?utf-8?B?L25DcXVFbnNESHYxWU56TERKMGp0OUdNYnBPaDhqWUVKZVgzT1JzL3NYREgz?=
 =?utf-8?B?MXIrbDF1bWN4dEV0a0IwbDZ5MUJRNHJ1QVhWdXlJV0NqSFB4dXNoQjNzazN3?=
 =?utf-8?B?czRTSnFyUEVtc3oybzJiQU1xVmZnMFBINTlxR1BuNjdQYmc1N1dkZHYzVTk2?=
 =?utf-8?B?eng5WW42dy9zVXl5RGliN3JxYWZScVdrSmxRV2tBWHJvWW1KbjhIakxyT3RE?=
 =?utf-8?B?c3doVWxsc3NYVnFSRXJ3ZE9oNU5FTjFzRjFhanBOMnJHM2FCSm0rSUpPVDFy?=
 =?utf-8?B?ZmIrQW91Z1FqZWZNKzZNUnBqOEc1c0NoUERSemFsSjQ4dFBHdUtSbCthUmE1?=
 =?utf-8?B?emwxZlJxV3FFTnZneUxKNkU4QnVWbVNmRlVSVWt0THRIWWpSRlJPMXdvNWtt?=
 =?utf-8?B?bUtiTUVJb3ZySUZsTWwxdklobUxsZC91SDVuZjExWG4vd0w2YkYvSWd0bDhi?=
 =?utf-8?B?eDFOVDdEbm5leVoxbWNhb0tUZ0E4S0UrMXdDM0MvQng3aFlPYVRKQUszYkJs?=
 =?utf-8?B?MStNRVdTWFEwS0ZROGM5M3RPY0hMWW1ET0dTNGYxTmhrelVkRGE0ZWVGR05z?=
 =?utf-8?B?VHBRY0VuVEZ3OUM3WjFCNnhJMTA0a0pMa3RkWWpBTjJiRTlwOGttMHhBME1Q?=
 =?utf-8?B?K2ZoUG5IL2E0ekZaQ1Vzek5qYjhlRUFObnhaUTlUcTBaSjlvVk96NHNtR21h?=
 =?utf-8?B?TzBEYTVGYW9xQnJVUTczTU5pMlBQeWZHSCtaTS9BR2pxRDhrR2hpMyt6ZEVr?=
 =?utf-8?B?RDNwUnNZSWNpQkEyUWtvSWpxdVpDSlRwZjBJUnU4VzU5KzgrbENLOTd5d3JZ?=
 =?utf-8?B?VTVlazA1eXROSGthNXlid3VxK0hueVhnM3I0MTVCaERrM0x2aVNZU0JiUkpl?=
 =?utf-8?B?TlY5WVlyNU5NTHdadHF0NnJXUE5PRGM1aTRJZDlVY21UU3MvNDgrRXBkYk83?=
 =?utf-8?B?QTNwODVtSzA3SkVaSmI0Tm9BTXhqRndNc3dEZ3liOFpqMUxPcVpiSlQxR0x5?=
 =?utf-8?B?RmU0UmE4Y0hLTzNCL3pIeXo3dExSNmhBcGIxa09pa3pnZXd1WWRoTFI3QVhW?=
 =?utf-8?B?Sm96TUU5djhpVk1aaVloSmVwK2JhclhqekZxK3U3VVhMSE0vTE1mZDMxQVha?=
 =?utf-8?B?Rno4M3U0RFJELzJjTFQ0ZENiYXR0aTUzM3NnRDM3b0JCTVFUWmlTS1hKbnVx?=
 =?utf-8?B?bW5TdlFqS2cwcXE3aWo1Y0VQWjhNell1QnphemV1cVFSUm5ESjhaSDRUK0hO?=
 =?utf-8?B?MllXN1lockloTWFOd1RsN3lvNEFCbDJGaDVPajNaTzl5SVVzN1FiNUxTdk9r?=
 =?utf-8?B?QW0wOTRhY2VkbHNSNE9UZ1RkY3FpUWV4S0JhNXl3b3FhOGJKSTRlRjQ2Wjkv?=
 =?utf-8?B?ZWNhODhnZ1I1TTNpazE0a3VYTlFSRG5pT0pJWkJKd0lnODVNMTBWUko1OTQv?=
 =?utf-8?B?a3gvR2tVb25IaHhWVDRxYXg5dHE2LzlsN2UraU1IS1B3aS8xT3FCSnZvTVdK?=
 =?utf-8?B?N2NGL1ZBMnVEWlBjWU1zdzRxU2IzOEpITm1JZGlybXFudC9rWDRoWEExemx5?=
 =?utf-8?B?cnBRK01rNEdFMWgzY3hvVGQ1REZPZ1ZQT2xxbWV4Q24wZTdESXRFSFN2TTE1?=
 =?utf-8?B?cXpiSStoY2xkYVNMMG83dHZBWDlaajZlS05ESGhJS3RpQ3kvbjU4VGN3TWor?=
 =?utf-8?Q?04bUlBDpCAs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5030.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cDdWQjNCbjBURHRRbFRhNy9LMS94YmZxZ0tPeVFLRDhGdWdiRldUdFBkNXJY?=
 =?utf-8?B?ajN4Um9uQU8vbEdISThSdEluczdPcStGWWZEaGF4cGtwV3ZZeDR4SzVKNk1x?=
 =?utf-8?B?OTFXS3YySDhmWU14aVFMd2VtVnFRcDlUaW5HMWgxOUlDbG40Y2J3Tnc3NzJj?=
 =?utf-8?B?WXJsckVvT050TEx0enQ4Ym5rVzhMKzhCZ1MzTjIzY29zcFViVDJGMXR1bW01?=
 =?utf-8?B?Umh5aytraXFSMkM1OGFSL1BjL2NObE5rbmxQdmgyNXN6clplcVNCWUNNYVc5?=
 =?utf-8?B?RlJEdmE3ZjdtcDR1RGt1bFdKYk5FaTJ6U2tuR2Rhd0NHTzBtWkhYbHp3eVE5?=
 =?utf-8?B?WGJDc3lmZnQ2Y1Q0WUNLNHkyT2xEUi81RkZxdldjL3Q5aW1PRDNYa0l3QkZ6?=
 =?utf-8?B?aFozYmhZWG83M1M2bEFXUmF0QVExSlN3Y3RNVkZRS0RpMWwyaWNvSVFNR2Fj?=
 =?utf-8?B?ckkzUGpxZElWczZzdmhQY2JHaXVDQlIyV3VXOXFHbkRlTUM0cGJiYzR2VTZK?=
 =?utf-8?B?UWtiWGtxV0d5NWVmcDRROU93ZDU2ZkdEYWt1VEdtbDdQSHFNdXBEb3JBRUhR?=
 =?utf-8?B?TGpHNzRYSXJuakZ4NzcyanVUZGJoNlIvc1lKSDQvY0lqK0xxY2Y3ZTVTWFZT?=
 =?utf-8?B?MndPOUpCYzVpRVFYUVhWY3c2b09ScFFmZ05yNWhjSis4YjduTVBmNlFPU25I?=
 =?utf-8?B?ZnRBeHk5OWxVWFljTDZvc2xpaWcwTzJpVWVvM2hUcjNhYStKclE0RkZQRGhD?=
 =?utf-8?B?QlJQS3pseWdIeFZhYkhhS1hDV1dzMFlGTjdDWHp5dCs4cEJQUW5vU2pJR0tp?=
 =?utf-8?B?bzg2K0txb2QvbHVuSm5neGI1RXp1dDlKM3NUNXVMbjNxVmx5NGVlSmRUQlpT?=
 =?utf-8?B?cld4azRzRkdDSkVaTDQ4cWh2aXJUalU5RVg3cXJtcWdQNG56QVNIQldSd2Vs?=
 =?utf-8?B?bUFHOFhMZVBPZktnTEEwbkEraytsUys1dmR2K3g4aUh2NEJIalhLTURydk5Z?=
 =?utf-8?B?dXBqbmEySkFNdEhpdU1HeWQ2UGM3SUZxZFo0blNNUXU3UThRZFY4NVRZTndK?=
 =?utf-8?B?U05xYmNYMU51a2libzlpR1RwWHlHUDBBYWhyNkRTUjNIUyt3VTZwdnNWb1Zi?=
 =?utf-8?B?KzlrOXZXeitkWm81SHJCMWVXbUN4dEx0YnppVDFCMlJjWUFNbDdObDhmRXNR?=
 =?utf-8?B?eVFKOHhFc29BRStoWis0dlVxSGpjY3ptOE5KdWpwZG0zanVqTlhhNVcydmhQ?=
 =?utf-8?B?NWNocjBCaGpVWXEwaXIxbmdhZWpaUldnYVNnNUNVK2hCREU3Ti9aZXYwREMy?=
 =?utf-8?B?MGo4d04zVURVczkyeVU4Z0R5Y0RvUk1HckU4dW5LNXZidlRCVDR2MHZYNlE5?=
 =?utf-8?B?MzZIMVUzRzZUdkxUNzhBWDJlSzIxM1Y4NDFlakltL1h2VXh5N0xxM3prWjhP?=
 =?utf-8?B?ZDZJSXE1Z3psQmFQYklNVlJJUUY2UEJSR0tJWHNTU1JaSmV1ZXFod3JweDBw?=
 =?utf-8?B?SFNSdW1JbHYzUStqTzhPUHRQUlhFeXZYUCt6NUZMZGxOL3RRck04VkZOb2tv?=
 =?utf-8?B?eGhXUWtaRUNWQVpDKzVTbk8xcEVzcmZzeDFFOG9XKzhSd0g5VzhXZEJCN01Y?=
 =?utf-8?B?bFR3dDF1bi8yYml1aU54UGt3bzRieUtRa1ZKZVNPY051c2lOUE1sOVMyMVoz?=
 =?utf-8?B?VlowSVczUHB4Z0VOZndmUEhUaVE1aDQ5NUVqNjBPckg3RjFUdXR1NWpDeUhu?=
 =?utf-8?B?NzUrRWZPR0lMOVVqQTlaaEM1ZC9MM1VPMHJ5SHB1QjZYMWhPWXF3eDdYZ3V6?=
 =?utf-8?B?Y3pRQ2hCRTlyUVBldEVkR0libXQvOC9YKzZVdjVqamJKb0psTFF3MnZwNzY5?=
 =?utf-8?B?TThWMU01bHFUbmQ5TytxeWVQRmNwUjJwVE9aVmoxbEVXZjVDd1ZQby9JL2x0?=
 =?utf-8?B?NWJjZ0t1UGhXalhEajNKR25nUUphZ1FOWSt3TXR6RDFuS0daRHhkcFFTaVhB?=
 =?utf-8?B?a0VVbndrWDYvcFJTbzYwNTlVc1M0N3M4RmVBdjNTSzY2V0FmRGxVeS9EY1dh?=
 =?utf-8?B?RW1nWTI0RTllSG1haE5VSU5RbzZudmNFYUJVQW84UkozalhrOXh3aTF0L3Fh?=
 =?utf-8?Q?sF/LnjbprV/6mhpSD5SQxHgyV?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	QdAxEgSRHzghE7W/kXl3oPmL3/o/TUgUE0Va3rLGRsBvGnKOMvrhPsA8p65sGRVcuRzj2X9hXVLJIA5nBFcYac7DJ/+1uFnypaSt52xryO75uadDsZltCuqE6CP5VvZzSHXbLDOgXB+W1IopA0OczkZkpUvASUJmzB7jjKWr+O2vjCibP91WGZdgObJgbW6lQ9wYhwJRbFuXs22QGR2LJnmMZIs0GxH4dSbmcEM24A15wvJL4Ktk+auPfJziBqQc5ia5wpfaLCym7PhZnQ5AJ2Cjur415XSYNtMxJsM48El7dxyE+6CAYVbuI5tbnOYKk90/JFnKUPfmYAji5f8rw71yRL77LbuzyTIljX0n+xg0W2M1xpcHNhkqGub1V9NiK64YwbUX4S6AHN9SRfGopHSi1c9ol2T+nD1cY2xbzzwfYl4LmJqh++FNBOID8NyEHO2fHfkOLgXfzryhMD0Jw1LkwPwWBnnC8dDAxoERJ+fmCGXj0pTYqh7IylBGZ23Z4gepiSoBdEjej3VtA9b6s56sI8LxiqpjYMf+NAypD8unZS2jY/LeusWux8Dj02AA2PCsdEvCaTIm/OiisHvqiCgXbXR0oENFIbvBwITj0FE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43443b1e-0f3b-47e9-ced2-08dd9f9639a0
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5030.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2025 16:22:52.1985
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iRXCJ3pOsdSB5uLwPLunixRcSPVoALhqxV48f7ADjoijzRJpM06a77m+zTrNv4zJLxpLDUiZNRZ68PbkS0pY2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7033
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-30_07,2025-05-30_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 spamscore=0
 suspectscore=0 bulkscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2505300145
X-Proofpoint-ORIG-GUID: _P5fNdwLrFJasscPPKR10PHZ4Nn-bnuM
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTMwMDE0NSBTYWx0ZWRfX08U/d66shbQa MMO2LA6XXvpgOOtj2zYQsAh/pcXYHu1lcM/TVrWCMIs25BuU8OShAhhwpwNc3dSyDCFetZ3B2w2 edJlfGJNJEQmh+KoG/4dWYlI9YQmLoCiJhGFhUtTHbj8qscK6JYeu+4aLfje+/XJ+2yDLVB3XGE
 T3VRC1qbqZLi0j7IaA3Q3NFYFollf1cL+HlKLnw7PcsrZkxwwoKRmB87NxMQbtZuoaB5fnhbtNB B1M/voi6i8E66eJhmtbTNiaxXlaRSPgskifxwR6UqPUth6UkKHBqVHeOaRxO65wefbDojn1YbmF xel5znWKswqpFr0vkTUt/JbYn+o46ym8MgWOBj7pO/e9W/P+2GWTsTw2+DrzJrESKNrCTPQKQ6s
 Lnapx/wj3e2zuwE8UTYFOQ/HnAqi83Eg1k9/TDiT+1ADHocSDiQxWtpIx5tKfPV+vzUzbX8K
X-Proofpoint-GUID: _P5fNdwLrFJasscPPKR10PHZ4Nn-bnuM
X-Authority-Analysis: v=2.4 cv=TdeWtQQh c=1 sm=1 tr=0 ts=6839db70 b=1 cx=c_pps a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=1XWaLZrsAAAA:8 a=yPCof4ZbAAAA:8 a=d7hyoCzFUMXhHUj0W7sA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13206



On 29/05/2025 23:19, Sean Christopherson wrote:
> Use amd_sev_es_enabled() in the SEV string I/O test instead manually
> checking the SEV_STATUS MSR.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   x86/amd_sev.c | 12 ++----------
>   1 file changed, 2 insertions(+), 10 deletions(-)
> 
> diff --git a/x86/amd_sev.c b/x86/amd_sev.c
> index 4ec45543..7c207a07 100644
> --- a/x86/amd_sev.c
> +++ b/x86/amd_sev.c
> @@ -19,15 +19,6 @@
>   
>   static char st1[] = "abcdefghijklmnop";
>   
> -static void test_sev_es_activation(void)
> -{
> -	if (rdmsr(MSR_SEV_STATUS) & SEV_ES_ENABLED_MASK) {
> -		printf("SEV-ES is enabled.\n");
> -	} else {
> -		printf("SEV-ES is not enabled.\n");
> -	}
> -}
> -
>   static void test_stringio(void)
>   {
>   	int st1_len = sizeof(st1) - 1;
> @@ -52,7 +43,8 @@ int main(void)
>   		goto out;
>   	}
>   
> -	test_sev_es_activation();
> +	printf("SEV-ES is %senabled.\n", amd_sev_es_enabled() ? "" : "not");

Add a space after 'not' to avoid "notenabled"

Otherwise
Reviewed-by: Liam Merwick <liam.merwick@oracle.com>

> +
>   	test_stringio();
>   
>   out:


