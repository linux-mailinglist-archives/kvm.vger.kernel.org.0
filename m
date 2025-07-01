Return-Path: <kvm+bounces-51189-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 939B5AEF828
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 14:19:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F3A5A3AC038
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 12:19:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 767D51F2B88;
	Tue,  1 Jul 2025 12:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bxJpf1i0";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ER4ywV4n"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B6628373
	for <kvm@vger.kernel.org>; Tue,  1 Jul 2025 12:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751372369; cv=fail; b=uClZ9uB8iSG4G0R7R/y26wU7bIicX0YBNA6LLzQvlQvhCgDQ46CClXUTbo1NgILEaUq4w/P58pwyymZ5n/zl2+zLrQozT+KWdRKNEts5pW137Pde+0LfeBilLQL14dBgMcqv0SB0XuxL8QY/SlbKk3Ep+mJU6PJ+K4YxnrZetzw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751372369; c=relaxed/simple;
	bh=I9O4VaNdWhUW3eRAdTQt8XzXovq2jM+3BEbzLJijkNQ=;
	h=Message-ID:Date:Cc:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=YBuLGWRL5FnknW0UYABakLXZr3ucAd5vf3F2fI1Zo9S3aXoOkMzIY/oq7W8jROAnlTyoi8NH+X/FI94qztxs5LlBXy7ZN5KJ3ZlxS+HA1j6AFqWV8ulzUb+QckgLh4C8nW/2D7BR7M7UWuV5krN+lUY992YmDGx6VuACTB4f0kc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bxJpf1i0; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ER4ywV4n; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 561C4UEO003535;
	Tue, 1 Jul 2025 12:19:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=j/LKRvWEmhnsEsxyZ2E0stjnySARbY3An4Z9XQyu9qs=; b=
	bxJpf1i0cLwm960tggEJst/SLZAG39K++C27J7wtqaPamujJKe5jI7qad0oryHRS
	ZQwAE0FIlfcf8X7tA2NgP3bzWa/B1fag+jFMqNHzr4qPH31GsibFmTEZ9tQ6tbr3
	H+KwaMEAgvdQec9Uei9nr2bDZsQU4eexwVXWeppesyulkbYL43ged9cs03kpkdIr
	XXqVKcqy5heFfOt4n6uMRLp7cZgqTmOI+9GNZAIBKzAIoxYY2Ah9bVWUHPz67V4i
	Si3ZN8Ms5is3w6UKhxuflMAZXRa1fjf6hcdJvFQmg4D2SeqCwwfcOx2ROBkZmjaK
	78fqGMw2QS3urctf2eRiPQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47j80w4kdd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 01 Jul 2025 12:19:11 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 561BFVb5005961;
	Tue, 1 Jul 2025 12:19:10 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10on2087.outbound.protection.outlook.com [40.107.94.87])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 47j6ugx7cw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 01 Jul 2025 12:19:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JEHMYnwnrGkfkPLy6Ie5mjvUElF+CvBvkZorF5NhRQEz1yqSMNoKjBeJwSpq45EZQj39LQlkJJrgKqxZwYqVl20lwguVXRSpQnnjIqV3IQHfF6zy0TX0L4hO+FAE/g+oylmlW2tp8bMgKmfodEazTZVBlisBQVOcW7/Yu8O8etRvxwjGr+NWU6+MF0tUfiXDFuqST5w+9Gemyhns78dtQoPjR37WMGOFG32frbdd02KRtH37aZjxcii2nRI35cu7JU1bwsJgg6ExvdwOSJiZBoHRtMBQa882UH+APbd1WCEgHbdKBl/+hZZFmc1SZL5GxwF2l1aQTi82td2FO5dg0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j/LKRvWEmhnsEsxyZ2E0stjnySARbY3An4Z9XQyu9qs=;
 b=VII9rFE2yVkaBJxgUHvf1wLRlRu2c1Ji7RdmPKjuXMqO6/jhUhb+XuvtwuSXlOzbci016HDFnLdRh1Qu6CMVelWWWH6ufkoNUU/0g76zbEQOUO4HsBIPffmV6Ayw0CY0dMbpSbVRA14+x7qE/yiFjai41u/MK3Oo1lx8YJw39hp/bJquD8EspX/75RwQhS6oG+3IqrjsuNyaTFhMZI377WYaJuYhmXKkxv2ME+3CJV2bwLd1GHK0VfHQ8sHyliNlBT2MsDv0qXzMLy8Ofqk5JlN/C8XTnrCpcykuDSonWI6VtjEWdPDeASXaB4fOrLU//Au2OhlYqTo4v25JUfxklA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j/LKRvWEmhnsEsxyZ2E0stjnySARbY3An4Z9XQyu9qs=;
 b=ER4ywV4nM6UUSH3VmXchJw2/1aTCoS9ik04zU0ckqV8HWfiCaPWt/Xw2rD9CA4+yTQLh4GWFD8ZqlIIsCoVH5303DHc3FpzWyzF+slx2WWF7oOBqDAcKg36hGBfv2tLV/eC1XTtZeRLzgSeEQfJpTAw3WlG7d/M6uwWDYnCwnmE=
Received: from SN4PR10MB5622.namprd10.prod.outlook.com (2603:10b6:806:209::18)
 by SJ5PPFDEBD75B51.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7d7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.35; Tue, 1 Jul
 2025 12:19:06 +0000
Received: from SN4PR10MB5622.namprd10.prod.outlook.com
 ([fe80::6bce:37ef:d1de:d084]) by SN4PR10MB5622.namprd10.prod.outlook.com
 ([fe80::6bce:37ef:d1de:d084%7]) with mapi id 15.20.8880.027; Tue, 1 Jul 2025
 12:19:06 +0000
Message-ID: <103249c0-e606-4f6f-aa72-0f45019fd83b@oracle.com>
Date: Tue, 1 Jul 2025 14:19:01 +0200
User-Agent: Mozilla Thunderbird
Cc: alexandre.chartre@oracle.com, qemu-devel@nongnu.org, pbonzini@redhat.com,
        xiaoyao.li@intel.com, qemu-stable@nongnu.org, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, maciej.szmigiero@oracle.com,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] i386/cpu: ARCH_CAPABILITIES should not be advertised on
 AMD
To: Zhao Liu <zhao1.liu@intel.com>
References: <20250630133025.4189544-1-alexandre.chartre@oracle.com>
 <aGO3vOfHUfjgvBQ9@intel.com>
Content-Language: en-US
From: Alexandre Chartre <alexandre.chartre@oracle.com>
Autocrypt: addr=alexandre.chartre@oracle.com; keydata=
 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
 swLliy6PdpST
In-Reply-To: <aGO3vOfHUfjgvBQ9@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS4PR10CA0002.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5dc::19) To SN4PR10MB5622.namprd10.prod.outlook.com
 (2603:10b6:806:209::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN4PR10MB5622:EE_|SJ5PPFDEBD75B51:EE_
X-MS-Office365-Filtering-Correlation-Id: 24192ebd-55d0-4151-0abf-08ddb8997942
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|366016|10070799003|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RDJwYSttN2ozWkxXVm93eGtnWkNpTGR4a09RRUV5SWdwUzU5M2h6eWNKdEVa?=
 =?utf-8?B?MjZiTk53bVg1ZlFSSDNzQnBFd1pMVFh2UzlNQnUwZDNEQlY4TXBrZmtpdXA1?=
 =?utf-8?B?RVA1WEFvTzM2S2EwZmJBWkpqc3E1eGhWMDF6K2M0YXdlZDh6VkJzQ1BGc0hN?=
 =?utf-8?B?Qlk0a0ZYeEczWTQrQk5NOTRrU0N4NmdsbzROcEJ0MFNXRXRHSWhUMVpUamd2?=
 =?utf-8?B?eDlrby9QaWZHQWFXYlB3NGhOenBINGw4eHZseWZwcnRGZnNiNVNFWFRROHlw?=
 =?utf-8?B?Z2NXUlVsM0labEhkbW1DWGhUaENta0NQdm5ZQisvblZMMmM5Mlg1cDJ5NjFj?=
 =?utf-8?B?ckJsUG1IYUl2TUE1NCs0TEY0aEsyaExJdDJoeWFKdHBwZ2dwMlY5MDU4RVVS?=
 =?utf-8?B?VWR4Rnhtd3BZVmYvV0ZIeEh4UEprTnljOE1MS0hxajlleE5qSVZjaENJNys2?=
 =?utf-8?B?NlQ2NldtN0c0L3RoMGpNL0RhTkNWSk1kS210SnpvTktDaHIyRFNsSzlzVHo1?=
 =?utf-8?B?emV2ZlVQbkJXMm4rNlZNUHdYWVNxRmJDS2V2QVZzZ1VUaFhZMm1WUjZxeTVm?=
 =?utf-8?B?K0s2dGR1SzBKTldPcEdxTS9XR0N2aWk5Z3RoY0xGTkNmQ1F6eUdQdGR2bEta?=
 =?utf-8?B?OWFkbEQzMzBGRk9UWEtqZk1yMlovUk5nUXE1a0t0SHJvU2tBdlBCTGRSQndO?=
 =?utf-8?B?Zmt1ck9vcVpNUXgzWmFCdkg5ZU5GUnBHUmhnZ09BZkdOWVRTV3l6RUdVQmY5?=
 =?utf-8?B?OEJHSFVsUFpPSlpBangyWGN0dEVyUGgyT0gvWDl3ZlRnV1cvSU9aTFVVZ2Vq?=
 =?utf-8?B?TjMxSkxJQjQ5TUJ2a2VsQnJGMTlhWHArRzdTT3RvYnNxcGZVWEw2TVBVa004?=
 =?utf-8?B?NlVUbDFmZjhkNEtNWExtbGJwSmJmTllxMjlwVVYzcCtPbTV3eE5wL0lOL3BD?=
 =?utf-8?B?d3lVVnppVThiZUZ2eDdLRWJjcThTSExtNEVGTE1HZjF2QkJuL0FFcklpTEtV?=
 =?utf-8?B?aDgrb1RmTXl3YlpCQmM5ZlQ1NzVlanlUcWJmR3RVUVlUWXMyOXc1UWdIOU1w?=
 =?utf-8?B?M1g0NkJMd0RPNDZaRk1MVm9OQ3dDQzU0bWxIVFNFVzFjOExhMGNJaWl4cDhi?=
 =?utf-8?B?R2k2cENqKzFWckhSeE50OXhheUhiWXR2UEtoV2ZuZFAxQ2RjdDdnN2FJbmt6?=
 =?utf-8?B?Z2NKN1o3RjgzTFFBZzk2R0szWkUrV0ZiZllXRTRFRTgwVUVpZmlXUDVpYUty?=
 =?utf-8?B?L3llT3FFM3VwditwSUZTZGRmQkhEcmRiSStuME1oeXdnelpRb2RZTWN2cXRB?=
 =?utf-8?B?YWc0SXhMY2lRVldVL3QveVhSd0FrZTJNNXFwTUthYVJtZnBrUXIxRzZmNXBq?=
 =?utf-8?B?NkpTRTg4MnQrOWl3MUJVTVdib2hETlRwSG9VdEZER0duUS9mRXdZK2oyUWpY?=
 =?utf-8?B?aGZzTFBLdnRWdERNMHFUa1Fwc3k1dzJUbUladUxBa1AyQWNGUjUrc0N2RVox?=
 =?utf-8?B?TzYzNmg1b01ON3ZFd1JhY0lGWVpNbll5aVRUZExUUHJsMWZjMDlXcnNrMHB0?=
 =?utf-8?B?UU5lSHVaWFdxbnloVmFybHRJS2hIYXVLWkloT0c1dFhzalFvVnJ4WEJ0bHND?=
 =?utf-8?B?WU16aWV5RmZwREhjOEs3N051MXZLTHREZ0JNZ3lnUjBHQzNNSklYSmVwN3cr?=
 =?utf-8?B?dnRrT2orVGRjRTJYVVBJSDZLWE5ZWGhORVdNUlNYQTlFUlMyelJPcUErejJX?=
 =?utf-8?B?Skx0WFZOL2haNkZLaTNBMk9mQlFEQ2lCOTlsakxkazVmSEJDcjRjRXNIQ2dU?=
 =?utf-8?B?R1VUcWVnaGp5UFBPUmMvQ3VEc2JWdlkzWmgvRXNIc2o3MmJWUDcrbHNJR2U5?=
 =?utf-8?B?S0JRL3pWK3ZYOC9pQlNGYjNwZDBpNVdPdlpFN0VUblZ4Ni9vb0JzUlhBTENm?=
 =?utf-8?Q?Kqobf9jK4lA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR10MB5622.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(10070799003)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WWg2R1Vic2RvaFBiekhENlNWWTNPVVJLaW1RQ3duVFBveHQzM2NVU1hxRFhj?=
 =?utf-8?B?bnRJQ2tuUHlRb3RwT1cyS0V5VGRWL0Fob2hoTEpVbU1LVjV0SjFMUmJLWlhS?=
 =?utf-8?B?MGs0QzhlNVNMQ1RzRkhFcVJTa1VLdTNuQ1VBUm9LUXlpdTZLYWRPQlhZM3BS?=
 =?utf-8?B?aEdvWStNOHJLWHVKaUIvT21PSTRZTnEyK1llWi9GVTZuKzhLV0JBSXB5Wkpj?=
 =?utf-8?B?NzJnQlJYWmNoM2JRdXNLaXRsSm5zZHRmanBmeUlUVlBhank5QzFscHhETHB4?=
 =?utf-8?B?M0xnVnhhdG1URS9JNU91SU9EK3oybXJrMUdzOEtSZ0F1UGVQVlYxS0grY0VU?=
 =?utf-8?B?cG9pOHdTcEc4LzdyaUhlWlVXNFByeTZqLzdCekNBaGF4S3RJdzBEcTBVVFVr?=
 =?utf-8?B?bURwK0RCTUI5UUYzSnowSi8rVzE5aHp4VGtBaXd3OFljNDRjK2FSb0toNmdn?=
 =?utf-8?B?dDlyditWRVVGeHEwdWQ1ekJLYTF0NkhYS3RaQUVlNGFMZmdIUGd0OWpNM2dq?=
 =?utf-8?B?MTlRTVNyaEowdGVKNVpveThUdmJCZlJvWVhFc0NBNGp5RCtoMHF1cGQybjR6?=
 =?utf-8?B?TXNhRm1BSU8rdEJYTXF2KzFUZ0l2Y2p6RG1OTWF6MUdrTFZaMWVieVRVNjJH?=
 =?utf-8?B?YXdCVHhQSUlLNVJia2ltakM3bUdoSWRTUE5sL3lETEpLSHNrMmY3NkxTaEJq?=
 =?utf-8?B?T3VwbXJ0NUFMN0hkRnRXaVhuendCYVZFU1BFQkI2K3FPclViOWtITXFmQWsy?=
 =?utf-8?B?QmxNTjh4ZmtQeUVEN0hJSk1lSFJFNmFyeGJPa3N0UFN0RThMODJkOUIwN2Jl?=
 =?utf-8?B?MGNSR1pzOTI1cVlXNXBXSTZLckIyMUpiS3BLMDMrbzhzUEs0dXZYd3Bhc29D?=
 =?utf-8?B?dVVsdENXUGg0ak4zRENOZ1R4dnJMZURWTWI5V3pqMGhGK2JaQ0VWYm15MTN6?=
 =?utf-8?B?ZlQxTmZmZkZudWphK05nL2RNQWxkVFlLSmR4QW1lRFo3cDl6VXdNMzhpTnBK?=
 =?utf-8?B?dnBnU3h1cmZ1VUUrS0o2Z0VLNEJzYTNmcEJsWC93d3prUThvNkdCOVNFZXdq?=
 =?utf-8?B?SnJrcXd1NnNPREc5bzdiQU5NUEZZYjk2VjRVaHNiU2hIWUMrMHRxdEIyTVpr?=
 =?utf-8?B?c2tUWWQyZWpncUpLMS9BeU1SMEx2NC9XNUpNbklONkk2aENxQUx0aks5SGJL?=
 =?utf-8?B?SW5BVEUwMmRCY1EwdlU4T0VocFhIY2FKNTcwTTg2L0VSUlZnMmVFempnUzl6?=
 =?utf-8?B?R0g3UVVxcnBGeWRZQU8xR2JGVEhFN0NMSWVOSTQ5SlZ4MytNWmxzRndWZ3do?=
 =?utf-8?B?a3B2WUJGRDAxaFc0TG5XaE43ejlITitQS2NuODArRVpvYXpZeUtLSzJHQ0s0?=
 =?utf-8?B?bVRyL05XdWx4L0NjaTByRFVZU1p5OEc5eWpBRllXOEtCMDhJMUR6WjFxTjVO?=
 =?utf-8?B?MHZEaFk3QkpVbWhPSmNHWmhyY2kzSkFsZVk2dHZWNjI1L0g1ODNYeVoyOWh5?=
 =?utf-8?B?U0wrWTdieCtCdkhGTUFWRGE0U3FNQjBZZHhzU2lTNWM2REx5RW5yZnlXTWQ4?=
 =?utf-8?B?WnllZ3JBTzhxV1ExZm9MZVFiSS9iYWtiRmtKOGwwS1ZVWWdGREhpbHFiMVps?=
 =?utf-8?B?WEQwbHVtOXczZVpXcnNyQ2twUForSjA2TmxDc21BbzJPcXltMWF3WTdXVXRT?=
 =?utf-8?B?NThCZHVrWUV0ZDh3bTQ2TzBmRmRRSG1GOXNFU0piRXd1cVN1TC9oV0M5UWhB?=
 =?utf-8?B?dVV2clZwQWtjUU4ydjFVTUpHVm13L3dkTTk4bTVqRnlyOHdxZ1NBVko0a3l4?=
 =?utf-8?B?emM4Uy9PelFxdndIWThtZTRVbGdJZjR5TSt4WEhnaFJ4eXZRYXhxOGFqWmor?=
 =?utf-8?B?UkhVL05sVXdwVkQ5d214b3ZvTWpTQUJEYmR1UGdJYWNONmltSmxTd2xWMHBH?=
 =?utf-8?B?QzVqT3JIZWo1NmRoSnVDaSsrYkZhb1BwZHFoMkgya1NINUV4VFBGNzZpTmRu?=
 =?utf-8?B?NFhlWkRINWJpSkhNZDVVRHo2Wk56Q2h4OHF0WXkrWUZCWW82TWhwMVVubVNO?=
 =?utf-8?B?ZTZFSEd6cGFKTHdhR29KRlVpSHNUUnZOUk54ek1TbS9XbWlYYmpSTHBrTTZ1?=
 =?utf-8?B?Rzd0enIxdnJEY2xhemw2VlNkcXR1VkozR2ZIMjkwaXVxQlpFVWNFNmNFM1lv?=
 =?utf-8?B?TzhTVSszTTlkbnpLaUttNWNNcWtXQTB6ZDVMVjk3U0RTeENQRWRqNW4wVzYv?=
 =?utf-8?B?MGtSaTA1NnRZcnNpRFVQL3owSFF3PT0=?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DC8hCz5lOgTfSBiN+jp97bORseDAHpQE7Snc+uH9m9LXuFm3x762aVA1Nuxn7Q2LFgW2qW5gFN7ZkNFTL7LMLUhfYZa5dKGIHAAG2ydbWVYcWG6w6tys7M4gFOdhIP//YIbh7wh1N+Tt0BvSC2hniZU18jmjd2drUjJbAEhPQDQNBybPC6bkaFJlChg3Fb+j66faWxeoe1rjoHjbFRSz1eC1M85DiQ4FbuvDyviZ9gksYFK8lQl26WGeH6LJc84ItV9eZaK0B3piNfUhAGxTLC415t1AiNVEDUbAGT8MRLPff1yDBqVv1ZNdT/MFeu9QeH+XcM8UXP9ElDk9QSQQUCh7WcZTsBBjR4KaOk9UMIdA/x32PxqGoNcDxDwhqBkudgnVfPiUgSmrL13Xwf5Nk+gZQQovfWDamoJSeDFRjzG5kPDV3L3RAFUQSP7lTH6wc5gdRqlPlZG9T7hbqWJfEdMeEU4Wo0Aq9m4VngreQq+HBB+o5bIb7WwcuPPqCZAlzsz/jkYMF2JyLIsAxO9rh7yaQjKW5AFQ/lKwUPTa54Pw+GEKm2ZOu1E19HOXig4uv4iqqHnKrVD/i1sAXohSdY4ZSH/1emL4vFUy10tT79A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24192ebd-55d0-4151-0abf-08ddb8997942
X-MS-Exchange-CrossTenant-AuthSource: SN4PR10MB5622.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2025 12:19:06.3490
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4QfmFsX8Q3tmvJtKJV4othY6+vsvLa9Bn7v1kCbe9KMMIvMG7ApivKZTg8Qrpp+lvUOm/JI1+fe6jm/zLRyZReoJHr0iemKI0fd02imnssw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFDEBD75B51
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-01_02,2025-06-27_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507010077
X-Proofpoint-GUID: qWVFdC6bfcjOTy0qEDxwxaU42GH5bMXD
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzAxMDA3NiBTYWx0ZWRfX60BpOduoJqpO v0PAds3+zCOIntlCAdN8sp9AJKHxZRlDwfp2i8h8PCFywf82fwb5gRJTtmnt680IWwDfHNQaEb0 nFoQg24PBWlqNHHPghiEoeg8FUq3OgwJYsEPeBTRcMVUe+pOfIqUzxMURs1/iIkjOHJ84AKOSl3
 xMexblwOkk3IBSG3im+Ix7Zc+58TeB+ojwRqUAaQ+GkcrVjKJt0vXQleQisZvusQi+2sR9gu4Pp RGuetogXypzVB2F4xEWqWn8SOS8lDchdDYRiLT70Q3xjvgXHxOgFKTL6TDAGICUKfgr3bGJFBWe Ogf+YbcU+H/HIqcovAwH/i3Hu63dr8baQW7RRUo+6puTyFLl/ArKMyPAsGyCkm525CdZQcuR0Yv
 9mA5aSiVboNuxuY3/HavnNHjm82YBbMNUj+xAKL8szKBZq+3NF3kY70abHo8TPQ5MKjCm1/D
X-Authority-Analysis: v=2.4 cv=D6hHKuRj c=1 sm=1 tr=0 ts=6863d23f b=1 cx=c_pps a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=p0WdMEafAAAA:8 a=yPCof4ZbAAAA:8 a=D5A2EIzl7hW1ZJc5FxYA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13215
X-Proofpoint-ORIG-GUID: qWVFdC6bfcjOTy0qEDxwxaU42GH5bMXD


On 7/1/25 12:26, Zhao Liu wrote:
> (I'd like to CC Sean again to discuss the possibility of user space
>   removing arch-capabilities completely for AMD)
> 
> On Mon, Jun 30, 2025 at 03:30:25PM +0200, Alexandre Chartre wrote:
>> Date: Mon, 30 Jun 2025 15:30:25 +0200
>> From: Alexandre Chartre <alexandre.chartre@oracle.com>
>> Subject: [PATCH] i386/cpu: ARCH_CAPABILITIES should not be advertised on AMD
>> X-Mailer: git-send-email 2.43.5
>>
>> KVM emulates the ARCH_CAPABILITIES on x86 for both Intel and AMD
>> cpus, although the IA32_ARCH_CAPABILITIES MSR is an Intel-specific
>> MSR and it makes no sense to emulate it on AMD.
>>
>> As a consequence, VMs created on AMD with qemu -cpu host and using
>> KVM will advertise the ARCH_CAPABILITIES feature and provide the
>> IA32_ARCH_CAPABILITIES MSR. This can cause issues (like Windows BSOD)
>> as the guest OS might not expect this MSR to exist on such cpus (the
>> AMD documentation specifies that ARCH_CAPABILITIES feature and MSR
>> are not defined on the AMD architecture).
> 
> This issue looks very similar to this one that others in the community
> reported:
> 
> https://urldefense.com/v3/__https://gitlab.com/qemu-project/qemu/-/issues/3001__;!!ACWV5N9M2RV99hQ!IniD7c-8rcBUxEfJSXIBw2nLjN3la2lNKdPCWBhis7bs4j7k5tCISUMRRt7RrJjeONhumXlVH9x-wzPJSvDpq5s$
> 
> But there's a little difference, pls see the below comment...
> 
>> A fix was proposed in KVM code, however KVM maintainers don't want to
>> change this behavior that exists for 6+ years and suggest changes to be
>> done in qemu instead.
>>
>> So this commit changes the behavior in qemu so that ARCH_CAPABILITIES
>> is not provided by default on AMD cpus when the hypervisor emulates it,
>> but it can still be provided by explicitly setting arch-capabilities=on.
>> Signed-off-by: Alexandre Chartre <alexandre.chartre@oracle.com>
>> ---
>>   target/i386/cpu.c | 14 ++++++++++++++
>>   1 file changed, 14 insertions(+)
>>
>> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
>> index 0d35e95430..7e136c48df 100644
>> --- a/target/i386/cpu.c
>> +++ b/target/i386/cpu.c
>> @@ -8324,6 +8324,20 @@ void x86_cpu_expand_features(X86CPU *cpu, Error **errp)
>>           }
>>       }
>>   
>> +    /*
>> +     * For years, KVM has inadvertently emulated the ARCH_CAPABILITIES
>> +     * MSR on AMD although this is an Intel-specific MSR; and KVM will
>> +     * continue doing so to not change its ABI for existing setups.
>> +     *
>> +     * So ensure that the ARCH_CAPABILITIES MSR is disabled on AMD cpus
>> +     * to prevent providing a cpu with an MSR which is not supposed to
>> +     * be there,
> 
> Yes, disabling this feature bit makes sense on AMD platform. It's fine
> for -cpu host.
> 
>> unless it was explicitly requested by the user.
> 
> But this could still break Windows, just like issue #3001, which enables
> arch-capabilities for EPYC-Genoa. This fact shows that even explicitly
> turning on arch-capabilities in AMD Guest and utilizing KVM's emulated
> value would even break something.
> 
> So even for named CPUs, arch-capabilities=on doesn't reflect the fact
> that it is purely emulated, and is (maybe?) harmful.
> 
>> +     */
>> +    if (IS_AMD_CPU(env) &&
>> +        !(env->user_features[FEAT_7_0_EDX] & CPUID_7_0_EDX_ARCH_CAPABILITIES)) {
>> +        env->features[FEAT_7_0_EDX] &= ~CPUID_7_0_EDX_ARCH_CAPABILITIES;
>> +    }
>> +
> 
> I was considering whether we should tweak it in kvm_arch_get_supported_cpuid()
> until I saw this:
> 
> else if (function == 7 && index == 0 && reg == R_EDX) {
>          /* Not new instructions, just an optimization.  */
>          uint32_t edx;
>          host_cpuid(7, 0, &unused, &unused, &unused, &edx);
>          ret |= edx & CPUID_7_0_EDX_FSRM;
> 
>          /*
>           * Linux v4.17-v4.20 incorrectly return ARCH_CAPABILITIES on SVM hosts.
>           * We can detect the bug by checking if MSR_IA32_ARCH_CAPABILITIES is
>           * returned by KVM_GET_MSR_INDEX_LIST.
>           */
>          if (!has_msr_arch_capabs) {
>              ret &= ~CPUID_7_0_EDX_ARCH_CAPABILITIES;
>          }
> }
> 
> What a pity! QEMU had previously workedaround CPUID_7_0_EDX_ARCH_CAPABILITIES
> correctly, but since then kvm's commit 0cf9135b773b("KVM: x86: Emulate
> MSR_IA32_ARCH_CAPABILITIES on AMD hosts") breaks the balance once again.
> I understand the commit, and it makes up for the mismatch between the
> emulated feature bit and the MSR. Now the Windows exposes the problem of
> such emulation.
> 
> So, to avoid endless workaround thereafter, I think it's time to just
> disable arch-capabilities for AMD Guest (after all, closer to the real
> hardware environment is better).
> 
> Further, it helps to eliminate kernel/kvm concerns when user space resolves
> the legacy issues first. At least, IMO, pushing ABI changes in kernel/kvm
> needs to show that there is no destruction of pre-existing user space, so
> I believe a complete cleanup of QEMU is the appropriate approach.
> 
> The attached code is just some simple example to show what I think:
> Starting with QEMU v10.1 for AMD Guest, to disable arch-capabilties
> feature bit and MSR.
> 
> I don't have an AMD CPU, so it's untested. You can feel free to squash
> it in your patch. If so, it's better to add a "Resolves" tag in your
> commit message:
> 

Thanks for the fix update, I will give it a try and submit a new patch version.

alex.

> Resolves: https://urldefense.com/v3/__https://gitlab.com/qemu-project/qemu/-/issues/3001__;!!ACWV5N9M2RV99hQ!IniD7c-8rcBUxEfJSXIBw2nLjN3la2lNKdPCWBhis7bs4j7k5tCISUMRRt7RrJjeONhumXlVH9x-wzPJSvDpq5s$
> 
> Thanks,
> Zhao
> ---
> diff --git a/hw/i386/pc.c b/hw/i386/pc.c
> index b2116335752d..c175e7d9e7b8 100644
> --- a/hw/i386/pc.c
> +++ b/hw/i386/pc.c
> @@ -81,7 +81,9 @@
>       { "qemu64-" TYPE_X86_CPU, "model-id", "QEMU Virtual CPU version " v, },\
>       { "athlon-" TYPE_X86_CPU, "model-id", "QEMU Virtual CPU version " v, },
> 
> -GlobalProperty pc_compat_10_0[] = {};
> +GlobalProperty pc_compat_10_0[] = {
> +    { TYPE_X86_CPU, "x-amd-disable-arch-capabs", "false" },
> +};
>   const size_t pc_compat_10_0_len = G_N_ELEMENTS(pc_compat_10_0);
> 
>   GlobalProperty pc_compat_9_2[] = {};
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 9aa0ea447860..a8e83efd83f6 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -8336,10 +8336,12 @@ void x86_cpu_expand_features(X86CPU *cpu, Error **errp)
>        *
>        * So ensure that the ARCH_CAPABILITIES MSR is disabled on AMD cpus
>        * to prevent providing a cpu with an MSR which is not supposed to
> -     * be there, unless it was explicitly requested by the user.
> +     * be there.
>        */
> -    if (IS_AMD_CPU(env) &&
> -        !(env->user_features[FEAT_7_0_EDX] & CPUID_7_0_EDX_ARCH_CAPABILITIES)) {
> +    if (cpu->amd_disable_arch_capabs && IS_AMD_CPU(env)) {
> +        mark_unavailable_features(cpu, FEAT_7_0_EDX,
> +            env->user_features[FEAT_7_0_EDX] & CPUID_7_0_EDX_ARCH_CAPABILITIES,
> +            "This feature is not available for AMD Guest");
>           env->features[FEAT_7_0_EDX] &= ~CPUID_7_0_EDX_ARCH_CAPABILITIES;
>       }
> 
> @@ -9414,6 +9416,8 @@ static const Property x86_cpu_properties[] = {
>       DEFINE_PROP_BOOL("x-intel-pt-auto-level", X86CPU, intel_pt_auto_level,
>                        true),
>       DEFINE_PROP_BOOL("x-l1-cache-per-thread", X86CPU, l1_cache_per_core, true),
> +    DEFINE_PROP_BOOL("x-amd-disable-arch-capabs", X86CPU, amd_disable_arch_capabs,
> +                     true),
>   };
> 
>   #ifndef CONFIG_USER_ONLY
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index 51e10139dfdf..a3fc80de3a75 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -2306,6 +2306,13 @@ struct ArchCPU {
>        */
>       uint32_t guest_phys_bits;
> 
> +    /*
> +     * Compatibility bits for old machine types.
> +     * If true disable CPUID_7_0_EDX_ARCH_CAPABILITIES and
> +     * MSR_IA32_ARCH_CAPABILITIES for AMD Guest.
> +     */
> +    bool amd_disable_arch_capabs;
> +
>       /* in order to simplify APIC support, we leave this pointer to the
>          user */
>       struct DeviceState *apic_state;
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 234878c613f6..40a50ae193c7 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -2368,6 +2368,11 @@ int kvm_arch_init_vcpu(CPUState *cs)
> 
>       cpu->kvm_msr_buf = g_malloc0(MSR_BUF_SIZE);
> 
> +    if (cpu->amd_disable_arch_capabs &&
> +        !(env->features[FEAT_7_0_EDX] & CPUID_7_0_EDX_ARCH_CAPABILITIES)) {
> +        has_msr_arch_capabs = false;
> +    }
> +
>       if (!(env->features[FEAT_8000_0001_EDX] & CPUID_EXT2_RDTSCP)) {
>           has_msr_tsc_aux = false;
>       }
> 
> 
> 
> 


