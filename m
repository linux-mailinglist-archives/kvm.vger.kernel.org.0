Return-Path: <kvm+bounces-14878-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 883828A752C
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 21:59:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 137AE1F230EB
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 19:59:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 464BD13958B;
	Tue, 16 Apr 2024 19:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MfJN/Vpe";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="HAiVROTl"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68AD41CF8A;
	Tue, 16 Apr 2024 19:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713297585; cv=fail; b=N1poC7Es9ZtRhwP8s8tq6ndUxKeyq0lnSu6mjz4H4ULVz6o7+WOYQ3PuwhC3QE+2Xu9kDxJeZiTZmVMREz9m1z3b0mWmu2epwJW6CMP1LjPKjN8rDRulXxDiwvghuGEGjtjtkiuxi9PDjCWtrdcOEfiJpkBoLb/EL2qpVcpFhpw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713297585; c=relaxed/simple;
	bh=F4YfughmjhletqdYITdtLcK4uGIJBBIWdI21r10Cklg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=f9rP/5FQxzCJfSisGql5Nnofddacs7W/8skxEwx4g+PBTYnt/G60HqeZbv+IwUgnOY6m5PgGjams91D4fDDn5haR0E7mauqUcZ+oLSHLJAbFzWgNwUgiTTLBGDPPLGxxJ/NdZy+ASZMvDkiy5dWqd8vzINrxDg/CXfi1z6s1HY8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MfJN/Vpe; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=HAiVROTl; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43GJjxv4024208;
	Tue, 16 Apr 2024 19:59:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=D/nrViIwZ/J0D9rQv4bIK8rxQXjStj8O8/Fjz0RXdvc=;
 b=MfJN/Vpevvjd9RdVibus+FteREKcHDoZMKNJTQNhQYQkGc6NE20ZukPIPh9F3OYH/Ccy
 XRpJ/djCCLjJMUT16C89nKdXKXLZrn05QdtwigkqdZeCYu3KrkVwd8QnneKL1XeKs3L8
 0pTnm7/rUoUlsL5cgXVu/vv8aALXVBXRCZb2YMJPkzEcYW55aHRZfzek/X4ZrbwKFM3b
 d+keNPoipJrD2XYcOV42vNjMV2qK8KjZ/83mBkiubVE/KPNpWTCXzBJ9w7qkKLEpLWhp
 QI8OVMQFiIKTI0xQ6hlNC776seBKmxNdcCSDHgRA1y4fp+96KgH0Y2uHHnBPJ7E1fmU+ lw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xfgffe8p0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Apr 2024 19:59:38 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43GJRTCw029150;
	Tue, 16 Apr 2024 19:59:37 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xfgg7rm1t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Apr 2024 19:59:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sv/eYbWtkSqz1VMg09IUZh82p4lGdm58FaZ8LZTnNFFxeI4srpfwP+QxCIOTxW+NF5LoM8EpM07bHqkmZHAtBmiJy/WxB0l5EcprVFAAKCYx/GVpNflyBgBq53HFCcDQKS1ZsW1fzk457s6Lvrxdi4yeDCxqiigyYZaMcXgQTpOb0YwzzYoNsvNJzB2W/jJZtGwA73ccr2ZSK9HS06VAjz5ZO8QDHZClJnnGsWqGO1qeyYnf2F0XQzH4ehXZ4g25ByQf7Pd8C/PlE1K8Js372NoWht6xEZdk78j4rxA5hpMDHbZt/quIDYOy5jzZ7oUOcnj/0Cgv/OSrbdTQWMxFDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D/nrViIwZ/J0D9rQv4bIK8rxQXjStj8O8/Fjz0RXdvc=;
 b=FBDZQUehdjXK9arff/1IhoODXl5SiA6mER0CRRUN+vJnsyH88iY6Unh3d1n7RYnAssoAnQgWnauNLCyFx9EwwuNvl6zx/Qr5ldg6xDT7xEL69SKvnxhQpALbAM+P59uxBJj4gLwKd81JnpjIu3ZuW+GAQOlFqqy1fROdw0A1cb+S4O0m1ZDeaixLqpzg2CDL59O4aWQj5ZLrgPYRg+K0/FMQuVRhP5IaW6cm1Klqf6W26LqzVCx2pc+pYEPPUNcdbAJdtOpsPxklXTBEDEPXNx3dAVi7y0wEOdhhPNz0/BA3d8Cq05GzCRUCEvfGQcsAr2LiJR5u+947QAiSJ3NeEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D/nrViIwZ/J0D9rQv4bIK8rxQXjStj8O8/Fjz0RXdvc=;
 b=HAiVROTl330A6lSddCSyueQQv0so7BCUOLFmVwcYMGbFd4/U3dyS97pQmNOvERk2yhcY8sEf7fVrdpAq37h24+S/UcYmIqJQ9GDeOi3BXiAuOxW1NrnDYycQ5CgfOFWJYpBNEYtsOJ1NTD9SQNA/g++5Bri6yZhe50eLSKWnLSg=
Received: from DS7PR10MB5280.namprd10.prod.outlook.com (2603:10b6:5:3a7::5) by
 PH7PR10MB6335.namprd10.prod.outlook.com (2603:10b6:510:1b2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.50; Tue, 16 Apr
 2024 19:59:35 +0000
Received: from DS7PR10MB5280.namprd10.prod.outlook.com
 ([fe80::c7cc:f6b7:386e:fd5d]) by DS7PR10MB5280.namprd10.prod.outlook.com
 ([fe80::c7cc:f6b7:386e:fd5d%6]) with mapi id 15.20.7452.049; Tue, 16 Apr 2024
 19:59:35 +0000
Message-ID: <812f62bc-6a2f-4226-995b-ed8fd8673a12@oracle.com>
Date: Tue, 16 Apr 2024 15:59:31 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 1/3] x86: KVM: stats: Add a stat to report status of APICv
 inhibition
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, linux-kernel@vger.kernel.org,
        joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
        mark.kanda@oracle.com, suravee.suthikulpanit@amd.com,
        mlevitsk@redhat.com
References: <20240215160136.1256084-1-alejandro.j.jimenez@oracle.com>
 <20240215160136.1256084-2-alejandro.j.jimenez@oracle.com>
 <Zh7BOkOf0i_KZVNO@google.com>
Content-Language: en-US
From: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
In-Reply-To: <Zh7BOkOf0i_KZVNO@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH2PEPF00003849.namprd17.prod.outlook.com
 (2603:10b6:518:1::66) To DS7PR10MB5280.namprd10.prod.outlook.com
 (2603:10b6:5:3a7::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5280:EE_|PH7PR10MB6335:EE_
X-MS-Office365-Filtering-Correlation-Id: 3eca6b2e-a9e2-4a18-cec0-08dc5e4fbd29
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	/GDMCu6MFX163rPlxFtT2Z0MIObF/lllJaXE0zdWOP5h6wn07tPnXylCOgSBXf9o6QsutbFGn+/NaBRUdX5O4aGnPsYDvhoCdvCsGlny+lfk3+g0xejoacPgq4ILCgWI6Jq6GGpWV+8GwDArlISQO6QorurxNTB6D+uj1bLkneDo/DaIYQ/sf2P0pqcP4S6BI4cu0yLN+6/UmoZvIPEixSyi4g7LRNVEOMmPtCWRwJtqnIIfHfdbfl8cNm9Orj54yvmbfhtVtx4/qu0tmXFCpdxi7wPq6pxV8iHQVopHmAw1zrMe9znlyD9+tJoD/+oFbUDOUJ2rW3jCWcf1ydHnBLXB80nTago0aMSSPJYIq0N2UCh/Bq6fCpMW6MvYW6xQaoBh+GRSZUFExZCQ4aGq4SXH1Oe7jmXzvM25Ek+n4BvIDMw4Ge3brvePhOg9wJVYBZXnamyvfcFPbV+doCzqo8+1VyPbCTUGD85QQZxXPE2HqfvJY37vb2Fh9fXzf1NF/f9FO3xtizbdERG78hVVJ06UVppgm+HcGdirghE85MqqS6bSyptaqJ95wJREvCYawVHxGj3cYKdnpjmgS/VywGq7+FJvNstvXMz62RBADhw6crYlI0aGN/rDAYDKtI2DyVQoHwjxule0nTZ8rl1ZRCQdPHjqKB6M/KIziABy7GE=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5280.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?Y1Q5TDNnNDhVaVI5SmNoRUNTN2FUK1NHcTE2Wkp2ZTNFc1pxcnZreE5JZDFX?=
 =?utf-8?B?RWtvaDVPODA5cWM5dEI0M0Vybjg3T3ZmOEtsbm0xZWF0SDc1MlhLYWlLeUtt?=
 =?utf-8?B?WSs5OTI5Qzk0d2R3S3NHMmFWcGdqOWtrK2phOVo5STVXYUdVak45Nkt5MXpw?=
 =?utf-8?B?WkpjYlRQb3VTZUcrMjI0eWhvblZ4QjdzQXhDaTY4czRuVjNKbW9uc0s5WlND?=
 =?utf-8?B?Q0c3cTF2VjNaTVRrdjJITW51Q0wzSnpVUzljblJkQWtCZHZZZG4vVXpob09j?=
 =?utf-8?B?QU5XTjM2MDM1bmtERWRwVC91TlhadWpPQzJLY0JzZWVqU2MrQzBhdlJGb1ND?=
 =?utf-8?B?MjFjaDdMcVBYZldQU2JHSXVScnhDNXpLRFA4cXFOMlVGdHgwcFltWit4VVB3?=
 =?utf-8?B?QUJaVW9zdmYyZmRyMTFaR0N3emorZXpZN2llSVVFMkVCTElYWllJNUlRbzFj?=
 =?utf-8?B?MmpwRE9aNEl3QmlVM0phUUFuenAxRTFYVDgwekl0bmE0ZVBiNklPcytkM1lO?=
 =?utf-8?B?V24wZGkyRVo3RU5ZVEpTcENjWVN1amxTVTloRWpoSk90Wm41c1M2em55U3p2?=
 =?utf-8?B?RmYzNlVKTjZCVzFxaFlBZ2hEV3hXUVBjQUhOUi81Q1N0bmpYNVNjUTllQzh4?=
 =?utf-8?B?dGc1UHlnZzZTVkE4ZDcrMGhrRHAwTURTc2dtR3dNWjVCd3F6d3h1QmxJYVNR?=
 =?utf-8?B?Zktxa1QzR3cxaEhGSXVJMktaMXR5V2NieUwwTjNMeDB6T2h5NFhLc3BMVWQ0?=
 =?utf-8?B?dUtGdnQ0cXc0WjFuRk5UQXRKMWZzLzlzZDN3aVhuZ0FXWkl5Qk1DeXJCMFl0?=
 =?utf-8?B?NTg3ajZvamNhUDEyZVd0NHBsYXRIOXphWTBRMS9Ea1RBdC92WEpqeElkNXp1?=
 =?utf-8?B?TWFFYVhPSEs0c29vRzlZci9ZZmZnZGh0ZlhJS2RPKzN6SnNqVGoxakZiUDhT?=
 =?utf-8?B?L2FhN2gyWTNNN3hKampxKzFOQ2VkbDNYMm9QeTdBclZhSFVFU1JRd0FMY2E0?=
 =?utf-8?B?RFUyWGM5RnV0d28rYVNERWhIR2xWN2tCRG9LMG8xcm5EOTFoUzd6Q2ttanhn?=
 =?utf-8?B?WllNVzFVc3liTHpyUHl2OTAzZUFCd1VhV3Zhd1BwSEF1U29LR3dkTlRKdnRI?=
 =?utf-8?B?WDlwN2lJUGFUVE1tcmp0SUgzY2oyMzVkeXE3WWRRMTBIK1lSdGdqbndUMTI3?=
 =?utf-8?B?ak5FT2pZUFBpVmwxUVA4YUNPejNzSlJ0Yjhiczl6T3hrc1ZVblhZUjQzU3Vi?=
 =?utf-8?B?bUEwNGlSQ2pVWVlGOS9rT3dsYmxtOTM3R2pxNllDSkw0ZUNHTTFBTGY0Y2I3?=
 =?utf-8?B?TVZPYWxFazVJMkFFaFgyN29hekMxVEpTVjFNSEZoY2JVNk14aDZtQ3d5TXVz?=
 =?utf-8?B?K1lEc3QzRWVOOWNOWDhpNXpZVDVRQW9uSFdENWNiT3hOR29EdlNJOWZtQWhF?=
 =?utf-8?B?QnpJY2t6VVdSZUtOM21pa1dzaTNiY0ZGcWFRUUU2VnMxck9FYm9GL2dLSFMw?=
 =?utf-8?B?cnFGUU82ZFpXek1SRGViNk5EdG4xbWlSSUZwalcwSHgrSFlBNlRCTnNJeEg2?=
 =?utf-8?B?Y3hCRDNiVHA2VGc2TVB3dlYwM2lhZjkyVWNSU2V2YXhvMFFTbXNJeFJ3OFBX?=
 =?utf-8?B?UnNDUDlhbmw5d3JENHZmSGlieDFiMnVFd3liLy9hUDNCREtCdjBZdHoweVpL?=
 =?utf-8?B?ZzJYV1dlTEE0Q3h4L1pvOTJXdXdlYjJ1RUdoSTh2eG9yclY0NjF1Qzg1Vmlx?=
 =?utf-8?B?ZmVGbzJYcHNjaUpnSjJzOXZlSlo4eEtUUDRSbHBCWDB4M0RFV1dVVUs5WXl0?=
 =?utf-8?B?Z0Q5ZTJwc1duSi9mU05FZHAyaUxoWkJzdHR6d3duS3cyNnlQdFFFSGgxTXNj?=
 =?utf-8?B?ZWZkd2Y3SG1MTE5lb2wra1NFaUFYMURXNTgzZTQzUmVGWUk0OStJQmY2TldZ?=
 =?utf-8?B?bXVTOTB5ZE4xaStmcGhMdlFOYXV5b2RTRVcyNjZVem5maXhtRk1xRlRxUUpO?=
 =?utf-8?B?YlMyN1AxOGtTNnUvbDJ4OWhHdVJmVkdPbDVVS1ZPWWZTK284L1plVkRNUU1U?=
 =?utf-8?B?TDVzZFRmYndGYWdnNzNsZnE2VC9aYk9DVTFYTk1vUTc0YVg1bndWN1NIYTZi?=
 =?utf-8?B?dHNPU0VOV29jVGtrNk5IQjAweG1qNmNYV3EzemlyWkNDMWVzNCs5MG9OUWVE?=
 =?utf-8?B?Mnc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	V47uPyF4nmZmUcVllqpcHW0qRzmhjx1KeygquXuxMsU2dXbvq9TJg5QkZ9jQnHeF5g5i3bZiVKpL5fnK5IuMD4sHM3Kgf5wIyroqveL8J8f+SXSp5bJ5Vm8GilEOXl6EcTk9yJB1kKaofM3N3396BVjy7Cd/GonUU0azhPkwMUAPt8Ui1p9b1DBFZJV2Ih+cP725b1s6erEmY4jSGOjc7Ry/QU7zMxB5zH7GzQ1Y1g6kTLuTFKMu7fkxLQrUlhFx/ucNuaoPE6kkojNj4QrGfhd8FRdV1wcXacKyQ9Jy6eF0sevxh+BcpvitCfewgCoguwt66+nLZDWehHWm40f7/El+fK1QX9e5sNlI5S4exul1nLFFjykh5TQNBwoTd6KXTLzpj1HNSEvvMn/buYmz8QvTLxpYHz1xJY6EKv4Tt4ZpvjuVu0xzdOyJWVQiry3qXMa3hKrfOi3CVj1XyEe0YJXoSIwR1JYQjHg2QqJOwLR35aEXqH9vcf+y9JRJgs8FtyBGLxpRFFrBehvEM8lh91fzIznoSxwSjQiAvJ590JnT8psnXamRBQ/sG8ZrZp5xLrrbSg+Nk5oGp0sY20vvVSRzrgzLBcd4fhGfOqWZb7k=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3eca6b2e-a9e2-4a18-cec0-08dc5e4fbd29
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5280.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2024 19:59:35.0850
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lfP3HR0qxRiuPSYQ3jY0q3Cske2fYsJWh1yvfE8ExddSdAmpiGPQW5Nvc/OEpBFkA+w6QhX+RNEPXqB7HXttYHXRHth0pcxwZpwljnBPzoI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6335
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-16_18,2024-04-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 malwarescore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404160127
X-Proofpoint-ORIG-GUID: ZQd5LrucGmZEJMCUCLP26Bz5lFb7RAiX
X-Proofpoint-GUID: ZQd5LrucGmZEJMCUCLP26Bz5lFb7RAiX



On 4/16/24 14:19, Sean Christopherson wrote:
> On Thu, Feb 15, 2024, Alejandro Jimenez wrote:
>> The inhibition status of APICv can currently be checked using the
>> 'kvm_apicv_inhibit_changed' tracepoint, but this is not accessible if
>> tracefs is not available (e.g. kernel lockdown, non-root user). Export
>> inhibition status as a binary stat that can be monitored from userspace
>> without elevated privileges.
>>
>> Signed-off-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
>> ---
>>   arch/x86/include/asm/kvm_host.h |  1 +
>>   arch/x86/kvm/x86.c              | 10 +++++++++-
>>   2 files changed, 10 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index ad5319a503f0..9b960a523715 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -1524,6 +1524,7 @@ struct kvm_vm_stat {
>>   	u64 nx_lpage_splits;
>>   	u64 max_mmu_page_hash_collisions;
>>   	u64 max_mmu_rmap_size;
>> +	u64 apicv_inhibited;

I was about to send v2 based on the earlier feedback. I think the changes would
partially address your comments, but there are still wrinkles. In short, I ended
up with:

per-vCPU:
apicv_active (bool) --> tracks vcpu apic.apicv_active

per-VM:
apicv_inhibited (u64) --> exposes kvm apicv_inhibit_reasons

> 
> Tracking the negative is odd, i.e. if we add a stat, KVM should probably track
> if APICv is fully enabled, not if it's inhibited> 
> This also should be a boolean, not a u64.  Precisely enumerating _why_ APICv is
> inhibited is firmly in debug territory, i.e. not in scope for "official" stats.

 From that perspective I am perhaps stretching the stats official purpose,
by exposing "too much info", showing _why_ APICv is inhibited (i.e. new
VM-wide apicv_inhibited).

It is true that I am approaching this with a "debugging" bias, but _if_ we do
expose a stat related to inhibition state, I don't think it would be overloading
its meaning to encode relevant inhibit reason information on it.
It would be need to be documented, of course, which is something I can do once
we reach an agreement.

> 
> Oh, and this should be a per-vCPU stat, not a VM-wide stat.
> 
> As for whether or not we should add a stat for this, I'm leaning towards "yes".
> APICv can have such a profound impact on performance (and functionality) that
> definitively knowing that it's enabled seems justified.

The new per-vCPU apicv_active stat fills this role.

I see you don't agree with a separate stat exposing VM-wide inhibits due to scope
and ABI restrictions mentioned here and in the cover letter reply. I follow the
argument, but it also seems like we'd be handicapping this interface by not
providing inhibit reasons along with it, since they are essential in determining
whether or not AVIC in particular is working (again my debugging bias). I am aware
this is a slight overloading (hopefully not abuse) of the stats purpose, and so
it might not be acceptable.

Alejandro

