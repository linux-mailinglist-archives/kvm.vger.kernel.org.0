Return-Path: <kvm+bounces-31306-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 047389C2282
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 17:56:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2239E1C23296
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2024 16:56:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 199E5199230;
	Fri,  8 Nov 2024 16:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="a/o9S3rF";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="fVXC7ht1"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89B7A1922EE
	for <kvm@vger.kernel.org>; Fri,  8 Nov 2024 16:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731084991; cv=fail; b=Mu5VKXaQ2hZa4CF1vZMs4d5/1Vlcw9ZYL9dyZ0ltW8VxcZqwQ/BSHPUfO20jUFZgV2VzNL4V/WLpglme9Y184fcvUj4t7jkl2LJmVTpxKiSWm0UOjXfOvL6uAqklIt7Bxw3dE7XMZ2VBMrx/VU51lxrBmISl5Z0xs/i0egBdOi4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731084991; c=relaxed/simple;
	bh=I7KSlVce60FZGZpQY8aqLPUW/asAlvBQ+2F4uRW4Tt8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=h7gxlgSnoLVFcjA/wb7hQ37sKD08BGw+vkMShayILC/5cLPPGQrMdBwZxHR7EBHQ2W4Elem5PxRxRGraAe4gUbc7TRTUYf5KKFmv4DN4T7eUbTqmLlkFPZ3u4JUMtFUgfb4knWo70b5cHLlElBVFQuGwxd30nAUb0su4DOX0jm8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=a/o9S3rF; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=fVXC7ht1; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A8FtXDo005450;
	Fri, 8 Nov 2024 16:55:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=GMakpEp4ANP0aSBnpvHCt08/4QFcysPMZUCTAE6IIts=; b=
	a/o9S3rF4uGNy9GMt8cuU+2JSxwppm7XgRYjrs62+qFpn5GNDDnTFowAaGpymWp1
	YBKNvxaH1bB7ZKQAoHW8pSom5op9TLVVNPRc1u8XoA1Ji+QhJ6XkmGRhSqgSXnPe
	qXQjzknpL5RG64mGu0Lwb1SteuJaFMYQt588cd+906v2bg904AKvaqIhp+IB9kIq
	QnIPX0p6ASDqxzMtyImkUNY95RShwFKKPfl7/4UROoaDOeYABugXOXTIiRrXJ+PP
	5RFzQ7Ha6CPWignLG3hIEPnFvDpP0BOqS5S99ttgdDs0BTcKCMY07+rI+DUS/Ugq
	nHHi//sjPeD8nLxmPicyQQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42s6gj1w1p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 08 Nov 2024 16:55:50 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4A8FGjvU003658;
	Fri, 8 Nov 2024 16:55:50 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2043.outbound.protection.outlook.com [104.47.56.43])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42p87f1n02-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 08 Nov 2024 16:55:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LPKTObUyFKidhGcOZQJ3rRigKxRZbMZ1iGdhvzqBjX24DKccHtG/k+3GcB2/b90rcdNEZG7KrUWB9j5rJ7UIjnr155oksb+3wR+crKW3XcmZWoUAf/Wo0rMuYliclLGJGBoqZgV/xz2I5FOuWW67YnAEGdGvX6ySUrM878WRMXlK81ZH1hcIMxat5bYwrxqdvSJ8oq3kbbJUnv45hmDtWrRtAFFMskWkMjm73zxPCXTm87JXl2xV7lhek57U1+WZSZ4bqFerICRUcNj96W88ptP9k9tlkyuN5vNTED/iDkYoVtVuTyI97AhK56ShuFPCKdscZvNdYaoMcEXHflrEKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GMakpEp4ANP0aSBnpvHCt08/4QFcysPMZUCTAE6IIts=;
 b=NdEhYAGZESRSkbBJwpN24GuDBCaIpSwyNU8TPAujasKVMeL2ZrbulVdG2FIwoNevKbEJ36IyogeLKq5vvzPnkE02FR7/cxEtOC5MwZvuFKznfhi8fC0+H86cRkb0abpa7vy+vbmJNJr2rhVx89ucd53Hv4fU+Pd11W8+C6dfQrlqQOedeVXbsTm7m7Qp0D6ecN+obLal343buxhnDdiY/rpKyu1lj29XmwtmGjAs/w3adXJhFQ0XYB1u7Q8o+hEo7UOt6KE2Oay3GLVp+QAf2kmibR0bsSUn3abl2bvzDFo6B/9AuUEpanv0XTDixCBcZ7rVFUQy3pUztA/llqxGUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GMakpEp4ANP0aSBnpvHCt08/4QFcysPMZUCTAE6IIts=;
 b=fVXC7ht1uJ/VCbWOZ50OYyFOfeJC/0wyt0sCB5WvZbQGiRyvXuGtaurPZcPIq3FxqqVhNXhr0RhuUbVi2ysL/TzhGLOr6qgRRWDoVg6p8GY2x7cp7gLHB7BheJEIw8a3ps99rMSrXHlLXaVeNLgKFs79Nd0t3RCP4vam7KVXXYE=
Received: from SA0PR10MB6425.namprd10.prod.outlook.com (2603:10b6:806:2c0::8)
 by BLAPR10MB5042.namprd10.prod.outlook.com (2603:10b6:208:30c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.22; Fri, 8 Nov
 2024 16:55:47 +0000
Received: from SA0PR10MB6425.namprd10.prod.outlook.com
 ([fe80::a37d:ab3f:9a23:c32d]) by SA0PR10MB6425.namprd10.prod.outlook.com
 ([fe80::a37d:ab3f:9a23:c32d%3]) with mapi id 15.20.8137.019; Fri, 8 Nov 2024
 16:55:47 +0000
Message-ID: <c5b9e3dd-b3bf-458e-9c7e-3bd1ccd5b95d@oracle.com>
Date: Fri, 8 Nov 2024 08:55:43 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/7] target/i386/kvm: support perfmon-v2 for reset
To: Sandipan Das <sandipan.das@amd.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, pbonzini@redhat.com,
        mtosatti@redhat.com, babu.moger@amd.com, zhao1.liu@intel.com,
        likexu@tencent.com, like.xu.linux@gmail.com, zhenyuw@linux.intel.com,
        groug@kaod.org, lyan@digitalocean.com, khorenko@virtuozzo.com,
        alexander.ivanov@virtuozzo.com, den@virtuozzo.com, joe.jin@oracle.com,
        davydov-max@yandex-team.ru
References: <20241104094119.4131-1-dongli.zhang@oracle.com>
 <20241104094119.4131-7-dongli.zhang@oracle.com>
 <2b9766eb-9181-4d11-a00f-770cef63bf10@amd.com>
Content-Language: en-US
From: dongli.zhang@oracle.com
In-Reply-To: <2b9766eb-9181-4d11-a00f-770cef63bf10@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BN8PR04CA0043.namprd04.prod.outlook.com
 (2603:10b6:408:d4::17) To SA0PR10MB6425.namprd10.prod.outlook.com
 (2603:10b6:806:2c0::8)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA0PR10MB6425:EE_|BLAPR10MB5042:EE_
X-MS-Office365-Filtering-Correlation-Id: 82f50e4a-3fc9-454f-faab-08dd001630f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Qk9MNnhIUVAwU1NkcFhJb2dLMzNDQWdVRFFtSVBhS3JXaVlxYVdKT3QyUnhN?=
 =?utf-8?B?WXhvRjhGVXM2MkQ5VWlIUDhzb1RrWVFrQlY2WEdEalBxWW1mb0NvTmd1VjVk?=
 =?utf-8?B?RGU2VWYyanlFRFd4NnNjaXNXS3ZFL3NpRXBWdjFrc2VNank5T3ovMGRUelhT?=
 =?utf-8?B?MU9tekZFaFBuNTQzSDVqeEsrMjJtajY1K3RtUnI0bGVSdzJ3MXFhRjNTUVdC?=
 =?utf-8?B?L2I1NUh1UWFXakJkbEhURVJuZXI5TWFnSnBJZlJySkJXMHNvaC9IMmNDNHll?=
 =?utf-8?B?dU9oRXdoRmorN2VZY2dxWS9jaFd1RW5WTTZGL3hZeGk0LzFFUHpoYUg4Tkhn?=
 =?utf-8?B?ZGZHalhIK0VyNmkwcmxidEViYkpUVDNaVHFyQlgrUHY1YU5SdUh3S2hqdVlr?=
 =?utf-8?B?cHo4a2pBOGpDc242TXJPNGJYcEozVUEzVVZyR3B0RHo3dHlJZ1dYMW12bFdH?=
 =?utf-8?B?WjVtZlRLSEpzMmllQ3krTEIxbHZNdVY5ZUVwTmdoK3UvcEgyZEh4VllKdWRZ?=
 =?utf-8?B?OVhOTW5UVFdsMFRFbTZPYmRnUktFcHFNcHFVU3ZFUjNpbXhIekRMWTVJWW9t?=
 =?utf-8?B?bDJPRkxHTDlzRkhjUEZCWTIzMUc1ZlVRNDA1UnVrVGFFeTNacFZ6a2pUeTAr?=
 =?utf-8?B?dnRrYTZUaTJMTU5EYnE2UEIwRlJoUmMyaE41dVk3OTN0RzJTTW9MKzZ3VnlP?=
 =?utf-8?B?N1dFMnhsMFpxeDRnVllrK25iUFRBV3d4T1ZzbUdEQTJBKzRlR1RJRksvQTBU?=
 =?utf-8?B?K1YzRnFXUWVTZm1zYmRjMk52QXExQW9mRWlrcm13ZGV3dlBhV01MRkVQdUlI?=
 =?utf-8?B?Z0tiSGFjQlJ4STBaRE1Ta0ZSL3dORTl4WUlnWkgrK0wrYnN3Z1hMR01pVXVw?=
 =?utf-8?B?bUg2WFFzVEcxMTVYckxMbFdrOEtaSjdvT2hDUGpnUFlDcWo2cit5UEEvS0dB?=
 =?utf-8?B?U3k2QmswTzBWaTdYemRHSktjWFk0aCtIRkFIZVpJM3pCNU9kRGN5eStMQXl3?=
 =?utf-8?B?S2lDNG52SE5lUGswc09XWlpDaW5LcWJVYW0yT2JpQlo2L2w3RG5FeVpkVll5?=
 =?utf-8?B?VU9aWHZ4RGZPR1Nmb1FlK1FpKzZ3aTNkdnM3SGtmYVc2dHBTckR3K3ZzbUU2?=
 =?utf-8?B?RkplazlhcUxwQVM4Q1QvcW0wdkVjcmpkS3U0TWQybXFNeXVMSE9ZR0duSCsz?=
 =?utf-8?B?T25SUXpmeFpPcTRxT1l3ZEJqWURNL3NES1BHYTlWbU5HdmhmTER0UXFWdkxP?=
 =?utf-8?B?b3h1dExtVkljV1lpdG1KY2FxSVVOZXh1a0plbU9DTU4vdnFtTGxEcXNhalds?=
 =?utf-8?B?bFZXbUdnN2I5b2dua2daZlRRbDFPcytJVFBvOXN4Tkd2WHJoc0hGWlNCU1N1?=
 =?utf-8?B?K3ZyQmZTK2F3TlQ5WUR1NjArSGNiUVBtNGFlQ0JteEFnZ2FKc0IwUnJxdEEv?=
 =?utf-8?B?SUVCWjVOMmRlRkpzdWxDaEZUVXJkV0EyYjBOOGt4eTF4bTcrOVkwVEY4NXJx?=
 =?utf-8?B?bU41WGJWN29mN0RPOForY3EyVWxmcjNmeTlKOEpJT1dRVjhOb1haa2VaaGJ5?=
 =?utf-8?B?aGs1U1c3Q2tZZmdMd0xYRlFpc1lTakdKald0K1pva2xsREVjQUxxaHJvb05V?=
 =?utf-8?B?cEgrK0Z4TjVjU2N0NmNVNW50ZlZvNzlkU2ZXTGYzaWdoVkc5Y3NxTWsvNk45?=
 =?utf-8?B?WUxLVStEdmNWZm1sVWx2ckVjVDJRTHp0MS9MT0IwWmY2RldCRWJBTkpWc0hC?=
 =?utf-8?Q?iZFUMtYBIWrtgAoGG8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR10MB6425.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MTRvSHZydXdvaDlSTWN0OTF0QnVjaU5POVlaRTZDN3doN1JZakdidzJVZmxD?=
 =?utf-8?B?M3JETFZ4dGttZ2xPR0pqU1Z5TW5PWGhSK2FWSWNEeTA3TVhqMHArTmVnOXdM?=
 =?utf-8?B?d0xIRWVDZ28yaVMvMzVHWTNlRXdHbGczNzJiT3U3VDJhUmd6MGJ4ektJUXRj?=
 =?utf-8?B?UnQ1Q0RhbVFtcHV4ZHExRnpaWnBpUnJQU3lmVk1uSUtEcmNPL3JJNndyNEIz?=
 =?utf-8?B?V0w5ck5NL3JQaU43S2E5eFN0UjhSUnAyZ0dTSVZMUzhuTVlDVkhQbmM0WmVF?=
 =?utf-8?B?N1JqdE5Sam05MW1rV2tTZmJJNEJhdGRVaGVxeHgyWWRxZ3N6OUxUNExtcmZw?=
 =?utf-8?B?ZWxsUXEycjNPdFRyU1gzRmxNclI2TFBzY3lhN1dkQnpVdmplbG1YaWl3Y05W?=
 =?utf-8?B?MExDZTV5aUd3clJHQVFVbW5Ya1QzMitzK0VVd0VIaHp4dk5ZQ21aWG5HN2g0?=
 =?utf-8?B?ZDBJRjZyZDNmZDVLUEMvWFJRN0laMno0cHlSYnprOTE2ZzlXdWdtd01pTW13?=
 =?utf-8?B?VHk2TEVCVjljdHFYYVN3bUFZa3dlcXJ2QVhydEltUitLM2xya2p2Q3RzZFNu?=
 =?utf-8?B?VGM0ZGJ4NUlOVktqY0x1WlRHMlUwamZsUHZpdDZoVzBNMFVVaHNSZlVCRUdV?=
 =?utf-8?B?R0xOcktZSTJ6bHdqcEMvV3RxbVNrc3ZGd0dJbHE2M2dkTlRSY3VKMThLSXVq?=
 =?utf-8?B?TmhmTnZMaStSWWNTOGdDbFI4Tnp3cXptVml3N2xxdEdwd2k1dStweVA2Z0hO?=
 =?utf-8?B?d0Z5MEJHM0NaeHA5clpPbi8xTzRsRGJsYmhTeEFDeTVnTUxMMllYVjRIeEM1?=
 =?utf-8?B?U3hsOTROQWFvV1F2WFlyTWNHTVp0ZmFUcDBxOXVjZC9qejFkQkhVL0VnKzkv?=
 =?utf-8?B?TWpzMnhoaU4xMkQvWUVuWlUvRnZzUU9KME5RRlM0bkVBRTlieXBpUmZQc3Jx?=
 =?utf-8?B?b1YxQmE0K2RvUFE2bHBFNTZEZW9pejk5clM0dUV0WXUwbzNidHo4b3VObEhp?=
 =?utf-8?B?YTFuN2Z1K3h0dXVNMnBqSkJyeFowYUtEcVpLcVM1a1FyNVI4K0pEczNrRWZa?=
 =?utf-8?B?WFBXTjFTdUwvRkF6VTFPRGF0c3pvUmk4Uzkxc00ycmpHaitRNUVJaktISFAy?=
 =?utf-8?B?TC9ZQ2VFclJIUHNxVitwSDZDVFpHRkM3ZVpEam5TS3k2QzI0bEZ6VDVKWDZi?=
 =?utf-8?B?Y2d3andaZ1JaMSttNDdUMkNtejFKVnhpQlZiOEFwUVZuTVM0N0ZORHdsL2RK?=
 =?utf-8?B?d1RQcitxRWhaQmFlOE9MSGgvcWc0M2gySUFNOHlPVzJJWkFCelJqakJiWlhN?=
 =?utf-8?B?dWZoa3RoY3pPeDRmc2FabHhKczFrV0Rya1hlMmozRVMzWWswckVvWE1sTnpK?=
 =?utf-8?B?WGNBa2xSaVQySkZqMVU1UklQbk85ZDNnTktsamZkNnI5Uy8yanRPZU9vU055?=
 =?utf-8?B?Q24vTVJXQW1ReHpwN0NYUkFtcTJ3ZzA5NVZ0RjBxREk4SVZGc25VZnQ2cTVT?=
 =?utf-8?B?NytVSXdVTHV5a3laOTltZTl2ajhMSmpGMGZ5WUNIZXpLcE9MV3FaWUFwdmor?=
 =?utf-8?B?ZnlVZEd3aEdDay9CcGx0REx6UGVuQm8yWnJOZnhNaDg2cS9tSmZ0SGNVdkRz?=
 =?utf-8?B?QXM3WWo1bXo2Sm1FZktkY3liRnE1ZW5TZWN1bm1BNmJlOUd5SktWeEM0MEwy?=
 =?utf-8?B?MEhsRDduL2VzN0lQcUZNR1RjN3BPejY5d3lZRVRUNGwrN2hFVzRCWTI1Zndv?=
 =?utf-8?B?c2ZXOUtBUjk0dW51R1hHZ2tZVnFBTnJxT040WVlDeEQxTTFYaGJKdjBkUFl6?=
 =?utf-8?B?Qk9Xd3lSTlhkR0l6YnBIK090c1krcDBobXZPRnlTdkxHdW5lRWd3NDFLMWd2?=
 =?utf-8?B?anVYTlY3dk1WQVg2M29ncG03cTY1UnE1aTk3WTJqdTM1ckxqZEhHZytsam9T?=
 =?utf-8?B?MHdMbTlTRGFNK0pKVDRLamRrQ1NqRzR3clNRaGpNTFBiQnFUVTlFZDFObXBO?=
 =?utf-8?B?My9VRG1nR2ZFanFwOS9WSTU3MWZVay9BK0NrM1lCN2FaSTA1aHEwTG5Vbi9k?=
 =?utf-8?B?SXY5V21iTk1tN0hZazJFRS8zUEtudUVtRW9jU1NKVm9tYkVDZ2lzcHlGVHRE?=
 =?utf-8?B?a1JyYi95Z3JxUVBxUFdnelowejRIUEpvTGdEKzRXbnZUSUxFUmVicWNLUXdt?=
 =?utf-8?B?UGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	B2g2Z25eOpznIGgxLBykM2BMGfLVoSi/ugv4C9TvIco/CXL/RpYEX9jt7oHQf/0mJfY346JYN8bet3qzRsW3SwYMWSi4M6+SZCIGORT+WxojIfau6baQ+zrRnEbY33FYi1AKKWu33dHbxhjy19WmMizYo84NlV393WWgHqMXNivj7h6K565TIvAEkk3mqUuPEAyFLTSdLlg8B5V40XZWjatcwo7C/QcxEISHRpQ/5Pszofzl3Le6rHK4WzSBAMVS8n5+bsTWORUxCKGzEcbTeFYVl/PIBnVJ6pAcbdcvqo6tA6yU8kPk0FvnpyTsUbLYvBe6H1TI9HMpV6LZOYf+Mb2GV393O+fNrT6F4wh410ugtF7y1rbLqbu2/zMdE6q5C1QpLNtknwKWG2s5N2Ibm1+8BHy5wko9Nf4A5xQZHlwim2e+/+aNlh91h6v0igLeT/OOAGzrqaTwyNbbD73mRCmNqTK0d7hyq6+kqQkSu14ByVK0xRnDwpB5wBji8K4YO7inZPgT0l+vQWc/cBKA1rq35T4VRSYbVTi+zYyN3hagrxdhbx0HTELPnJsAHFwVYZwTnwUdRgqVEUSeLupjJrUBr66Yuxk8caW4Z8niXUk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82f50e4a-3fc9-454f-faab-08dd001630f8
X-MS-Exchange-CrossTenant-AuthSource: SA0PR10MB6425.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2024 16:55:46.9178
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JoA0f/P9QtbWsxneDHJUsFXjsSsDN5c8V0twOl+wu/SF1nIUVIjA7LzkqAPVRsXq1M7M8PMS2q32JK+bsGaMqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5042
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-08_14,2024-11-08_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411080140
X-Proofpoint-GUID: vymG99jZGI27LqpmlzStOQGx5yItl3xl
X-Proofpoint-ORIG-GUID: vymG99jZGI27LqpmlzStOQGx5yItl3xl

Hi Sandipan,

On 11/8/24 5:09 AM, Sandipan Das wrote:
> On 11/4/2024 3:10 PM, Dongli Zhang wrote:

[snip]

>> +             * separate set of addresses for the selector and counter
>> +             * registers. Additionally, the address of the next selector or
>> +             * counter register is determined by incrementing the address
>> +             * of the current register by two.
>>               */
>> -            if (num_pmu_gp_counters == AMD64_NUM_COUNTERS_CORE) {
>> +            if (num_pmu_gp_counters == AMD64_NUM_COUNTERS_CORE ||
>> +                has_pmu_version == 2) {
> 
> Future PMU versions are expected to be backwards compatible. So it may be
> better to look for has_pmu_version > 1.
> 

Sure. I will change that in v2. Thank you very much!

Dongli Zhang

