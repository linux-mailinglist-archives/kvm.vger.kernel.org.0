Return-Path: <kvm+bounces-18051-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A7368CD633
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 16:53:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B327A283B3A
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 14:53:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E98711170F;
	Thu, 23 May 2024 14:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KjkOUoSS";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="UK0/0P9B"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECAE0107B3;
	Thu, 23 May 2024 14:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716475962; cv=fail; b=BX9IQwUsgOFoKKjhu3PEoezV3rKSXkVhOXvIt+CFZ2jLCkylx9E9q6d4XYiUlyuUEi3bzBoFAVRB1+zJWZi91gLHbxiDGyOKFcjokLZiGfs29U5934+046BOq5vq9N7fRIX/LLXJmY2RAJZ4r/bw7bsoQWV4axsgIq9ir5+A4Zs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716475962; c=relaxed/simple;
	bh=p19aI8jYlFzIMspPXWPjkNmXxMrgWHdoy7kCh6+bMKE=;
	h=Message-ID:Date:Cc:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FEW4SJgtBxnShFBW/oT8ALR/+lTVNFzQZxwSdkSG4JkSGbiTihisKT/wwi1nZya+XfEjfl3gFzAEpyL1ZNelB+Vud+ePk0M7+EjcjbZj+rOrVrgOvdQaAODqQj8+Emq9ckqwBSWM02Onoi+E1+hOo0n1hgA/fhu2p/MuJP2JW+Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KjkOUoSS; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=UK0/0P9B; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44NEi2e2021737;
	Thu, 23 May 2024 14:52:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 cc : subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=7qGX7SdBDdtsybW3t/cGZa+XxQ7Z+GUuI5j+EX72EnY=;
 b=KjkOUoSSz6lnxQdYGmfjvn8SSFtEAAZhR2ghvQ5MVS6dS4EsD8FsB1+MNI8j9du3KI5w
 j7ohO6txWrmFSRpdlW29HQ+GLiD+FYlWzZJHqQ2p1T13j++rM5YdjdO8ncWKV3Hog1uq
 OBlqNahAgKRwpWlNGstyVTzdf8JQbTxhsOZVJXL8bUQk6/v8Jqir4vZOHj02ENh2y4S0
 DBbqcY7DxtHUc2zvhugrS6u9LbOYfz06B1ZHDCOVXS7FrH9ieLIIPvyMFbhdDo35H48a
 QJXxa12fkcdYZLZTlOZDbScEpgAkmCqhBsVAuSrgZcmXIPTL17MQ+ULQbZyp/f6CDWx+ hQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y6mce2d5t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 May 2024 14:52:12 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44NDvwf3004984;
	Thu, 23 May 2024 14:52:11 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2168.outbound.protection.outlook.com [104.47.73.168])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3y6jsb1ss9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 May 2024 14:52:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FldENhTemQMOiNs6x7OtGVT4GlEng9XEqrbfC83A+0mdRXb1MJgf5TJ2IKbB0aTv5rTkOPVPsg+13isH1I7+y5blsMFjaHEP3Tt3zOdZXtAYvI/okTpUFNDL4Qzic9M4q8TQ0cTU/Siwy53w40A2JQcpcDYk26WYn0qm88EJK/4135OdohDxlHS7sHcLa/aer5tij6EgzaMJ0whoblswhtjFTas4VRacfbdawqs1kMnRveaQIQKNL73bGCdtkuGmf8weDaF6oLnaUCrYfIrOglej0tEGyf0zsdwgYWd1kZF7rVFPCyuK53WXoTW5TnAF0BR5+FlTaW0WESzX4n5Nug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7qGX7SdBDdtsybW3t/cGZa+XxQ7Z+GUuI5j+EX72EnY=;
 b=S/G+pYws1bfwnGImSdz6XH5qk+MYpP/gVOqV13/y0UkLdD3IOkHwn5U8taKS18PRPaFNt6aXmFTm+u/dKWNE1C76/Abx9+pmSzUWlQWEnjOfD5K2WRdjfdYCJqecbL2e0VpRw4gUU44d+lvtAIyRhdzlxgWg5UngQIVki6KcX5MYXIovMvK+wk9wgIlwGxS/OPnrbzlQvMyRnvF+KdjIa/a1EQTnu2TJpvfJSsCvELBKDUJvr9yQpRcCzxtx+TwCDZcq/VAiSMAFu0AAsl/0JObVkFiCUX+Cs5PMx+y+oU3ii7oSfiOQFK29A8VdfC40FhbNEdGJbm51ly3mj5MZuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7qGX7SdBDdtsybW3t/cGZa+XxQ7Z+GUuI5j+EX72EnY=;
 b=UK0/0P9Bb8DjiGnrz3wf2G5+eC3nwsDurRBxBNEiRGZVm4i/NQlHW0bRY7veA2W0JFHaGIsZwuoujGmfX4Xuh57kMXQLw70Ir7dDA2pBY8CmL3QxjZS3DnbUMtvIgsjlE5nU9qtVnmq0fcxrrYS/eQiK7cyeSgiqsORnS/he9Js=
Received: from SN4PR10MB5622.namprd10.prod.outlook.com (2603:10b6:806:209::18)
 by CH3PR10MB7530.namprd10.prod.outlook.com (2603:10b6:610:155::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.22; Thu, 23 May
 2024 14:52:08 +0000
Received: from SN4PR10MB5622.namprd10.prod.outlook.com
 ([fe80::6bce:37ef:d1de:d084]) by SN4PR10MB5622.namprd10.prod.outlook.com
 ([fe80::6bce:37ef:d1de:d084%6]) with mapi id 15.20.7611.016; Thu, 23 May 2024
 14:52:08 +0000
Message-ID: <1c69f62e-0dee-4caa-9cbe-f43d8efd597b@oracle.com>
Date: Thu, 23 May 2024 16:52:02 +0200
User-Agent: Mozilla Thunderbird
Cc: alexandre.chartre@oracle.com, linux-kernel@vger.kernel.org,
        daniel.sneddon@linux.intel.com, pawan.kumar.gupta@linux.intel.com,
        tglx@linutronix.de, konrad.wilk@oracle.com, peterz@infradead.org,
        gregkh@linuxfoundation.org, seanjc@google.com,
        andrew.cooper3@citrix.com, dave.hansen@linux.intel.com,
        nik.borisov@suse.com, kpsingh@kernel.org, longman@redhat.com,
        bp@alien8.de, pbonzini@redhat.com
Subject: Re: [PATCH] x86/bhi: BHI mitigation can trigger warning in #DB
 handler
Content-Language: en-US
To: Dave Hansen <dave.hansen@intel.com>, x86@kernel.org, kvm@vger.kernel.org
References: <20240523123322.3326690-1-alexandre.chartre@oracle.com>
 <a04d82be-a0d6-4e53-b47c-dba8402199e7@intel.com>
From: Alexandre Chartre <alexandre.chartre@oracle.com>
Autocrypt: addr=alexandre.chartre@oracle.com; keydata=
 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
 swLliy6PdpST
In-Reply-To: <a04d82be-a0d6-4e53-b47c-dba8402199e7@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0220.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a6::9) To SN4PR10MB5622.namprd10.prod.outlook.com
 (2603:10b6:806:209::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN4PR10MB5622:EE_|CH3PR10MB7530:EE_
X-MS-Office365-Filtering-Correlation-Id: 549589ee-1a3c-43dc-132c-08dc7b37eb63
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|7416005|1800799015|366007;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?UUcxaUR4Y09hS3VPMTBqV1VBL3Uyd1Z6blJPTmZrYWw1OGptWm4zSUp0azBw?=
 =?utf-8?B?aWYyYVRYaDZkeTByMzh5YVl6dUl6bmJQTVg1ZjYybE5VY0dta1Y0MzNlamxR?=
 =?utf-8?B?UE84TGQvaUN6R2dxOVlsUUFLUDJsN3pNTW4ybnd0eHNxaEJVOEF6TlREa0Ex?=
 =?utf-8?B?eGt2MXFqeGFRYXYvK0VyTlZ6eHUrSC9Kc3FTOWxLSDZlQTRFeHRlSytQTUxv?=
 =?utf-8?B?d3UwT0loVW1vbVA3N25TOWtnU1B3VFdGckZQaFBDSVNWL1ZEaEVzcldVcllO?=
 =?utf-8?B?WVlITThnSVpCYmNnYWxUalF1WjJaS2VkRlR2cnJCWkhNYlRhMDNTL0VQTVZr?=
 =?utf-8?B?SXhFNnRUL2U4L2VEWVhtS3l6a1A1MFZOK052Sk1WS291Ympvc3BnZ2lBQUN3?=
 =?utf-8?B?WVh2L2VjUGk5QmQycjUzQklNS0xid0pTdEtEV1hiZVlscVF4VkdWRGJreUF4?=
 =?utf-8?B?Sm11VytCNUMveHFiNFdVY0JGQ2xOU08vTTAydmZmdVg2RXhKMW14bW0yNUhS?=
 =?utf-8?B?R1lDandTeWdiQmE4Vk9rMHpxZG02cDY2Z0xZSkdWLzMvNlZ6Y0RjbDhsY1Ay?=
 =?utf-8?B?Y255eXVyNHBjN09Zdk4wUWQxMDN0bFlNWEpzc1R2bGdsU2JacjlJZEZxemRX?=
 =?utf-8?B?aWhXMW9wUTRiTWVPeW5QakdjN0ZNa0x0bTVVaDVYb1VwN0hQeXp6S0d0blp4?=
 =?utf-8?B?aFVzS2lOQkhhOHJrMDV1KzY3Q1AzUHRXaDBoTWlxb1FlSEltZWlTSzBzM0kz?=
 =?utf-8?B?UGdhQkRqN3E3MWp1UVhkSHBWUG1scys5OVhsaUN1ci9tenNYdmRLMFN5UTAr?=
 =?utf-8?B?Ukk5ckorNXRxcDVGakMyb3VodTNKeTVibXUyTDV6WXNYRjh2cnAwVE5IZVJi?=
 =?utf-8?B?UGtLN25xYzRVTWxob29LRTBoZEw5N3J2NXdXcHl3MHdCc1Vwb041dEdJVVJJ?=
 =?utf-8?B?bThqRzhVY0cyNHlqaGVvOGRySUhWREloOWRLRmp5a0Q5MExnOVhLb1FNUG9t?=
 =?utf-8?B?TnI0ODl2TGZUNEhJdUI5dzczbUsyMEZUU1VtWWFEMVZJNnhnUmZxQWtBNG15?=
 =?utf-8?B?ZFdkbEhEK0xGTlQzaklCbDlmWDFMM05jb1JBbXdwWTdkQXFaR3lHRWFZcElP?=
 =?utf-8?B?UjdIL0xuSjZ1bmpiZjh4TVJoTXNJd1VRaG1tMktYRWU0NzNzWTJlaHY5UVRT?=
 =?utf-8?B?c3Jac1hDbkI5KzA3UXJtME93MlFiTWRzbktMQUw0UklUenNWWisyeXRyVVR4?=
 =?utf-8?B?ajBDUEdrTndNNjJQTVlRRk4rSTZzUFNBOEM3blJNc2laNSttdWNCeEp1R1NY?=
 =?utf-8?B?bWIvelpyTnNFOHgwamZHam11d1ZQRENwMk5VbWgzME1wNVVBREQwSmFBTFdq?=
 =?utf-8?B?MUdhUlVJVWg4OGY5MHhmTGpid1ZjdHRnMUZUTkVhUVJ6YkNQZ0xuQktOc1la?=
 =?utf-8?B?WnB1OEg4VEo2VGR3U3VFbUxRZVMyeVNuVkppbUVpWnpLZXJJTkVvRnhnM1FU?=
 =?utf-8?B?RVR2VytpajIvcDdBaHMveWxpVWFtQ2V5NlptMHIxSDZSR2ZjK3h5ZE5neEMz?=
 =?utf-8?B?UWFZRGRCenVpREppRU5ZRHVhcTBjSm02MzBiSHBtanhqMHRFRjdiaUM1cGlF?=
 =?utf-8?B?SWxYWXd5QmF0dnBSeUxFOUp4RHJQUjlHMmFmZkM4Rk1vNmllSGs3Z2FGOWl2?=
 =?utf-8?B?S3MycElWa1N0NXIwYlAyd3Z6cGFkam96b2drSzFOY2lxUXY1Qi9uaXBRPT0=?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR10MB5622.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?Zm4ybkVFRUhJOGpsVHVydlpKdG13M2QyN20vZU82aEsyMkx3bkVzc2d4ZDdZ?=
 =?utf-8?B?UGM4Q0hMVGJPVENnTkd4Yzd5MEtralNGZFNpbUVZRE1NV2c4RDUwU21Ydy8z?=
 =?utf-8?B?bjd1SzFZM1Z5MHRsTHFBUkk5dERZRHpuN1E5dExjK21aUU0zdEovOWxIb1dm?=
 =?utf-8?B?YmhEeEl3VnI2NHhGSnc4eHdmWnBTWjFaY2ZHYllvR0hlYmMvQTl5WitrcFVG?=
 =?utf-8?B?R3VJajA1cExCR0RaWTB5bHpZdHFYR1AwRVk5cXBNM0QxQjVhQWxldCtteFp5?=
 =?utf-8?B?alk4bE83MEtoelBaUjdpZHRESmtRVnhoZ2lkT0V3TzBKRFVmaXUxM09sOW1Z?=
 =?utf-8?B?Mjlkb3hDaStUOGU0RlF1ZlRxODAwdG9BRDRVNUZFNDV1T2UvcDNyb2hKNksx?=
 =?utf-8?B?MjFHd0RVK0NONXhLd3d2VlRJdm1FRXBuQTFEcUpHVURHd003U2pWQnFvcGM0?=
 =?utf-8?B?T2tyc0duakN1Z0Q0eVRnY2MxL3lxOHRaR0FoNzhlT0gwS3lneEo2NHJTM2sy?=
 =?utf-8?B?UmZGRVNhWHJRdFhweklJV0IwcFEzZVNnMm5IZk04eXlaeWhDQ2MzZEpreDFC?=
 =?utf-8?B?bkJMYWo3R2FiVHBWY3RONDZrRFlZVjNHK1JnTFhiYkNZTTVmVnRNYW1zd25Q?=
 =?utf-8?B?cDNFUkJIYjlqdXdXVnlBc1NscFdFNnVCTTFRSElYbmNXbk5FNUdyUGtabDdH?=
 =?utf-8?B?bEVCcmFwM0psdUtvNFhoSERaQTlXUmVGZmQ0aHFWUFgxQWNWeTFqWG1wb0J4?=
 =?utf-8?B?VEVDZ2xFNFJkcVVBSS9MM3NZSkhjOHJiTFF4R1pObEV3OFRiakhvTFpJNWNR?=
 =?utf-8?B?QUIxS01WSjFFc2VaR2lwMnIyaTBuUHdCdktiR1NYakNXVVI4S2VIMUtzNDJM?=
 =?utf-8?B?eG9DNmsrZ3Nka2NuNHNuKzYwTTB6WkprUFY4bTIwNnpBbDFteHdBbnU1SDZY?=
 =?utf-8?B?TkNCK084WktNcHZaTWZwMjM3YUNQZnhTUk9IMGJ6L0tKdlZlVVpIdTV0N1RG?=
 =?utf-8?B?NllCUHR1N0R5d3FnRDFRczAveHFZWGFaSVozTEIxVjJqb25mVHZpV0xTdFQr?=
 =?utf-8?B?K0U0RGh2aFlFQlpEV0pxSlVoR0lpRGU0a2QxSVBYaWZCeExWaVNpQjhUbDVr?=
 =?utf-8?B?QitLZmVoTUo4c1FwcGh3Q2l4a2ZBR2Z1elBQRjdDSGQyOHRkeHNMU0tMbGdm?=
 =?utf-8?B?WXo4MHpnWWZJOFBDOW5QWjVqOW90c3NLQlpodWUvOWJ0YW8rTkpMTmJHbm5N?=
 =?utf-8?B?TVFUbzlpQlpiTzBMTGFweXdXTVV5RDM1czFCS3Arc2M3Q2VVZFI1SGRSZnEz?=
 =?utf-8?B?azhuWlNUK0x3eThNWXdjWmtiUG9UQ2ovMTc3NDArd0ZqYndTdEtSR2IzcG90?=
 =?utf-8?B?VkxlVjZjUzQ5anJ3ejI0a1hSb3RRVFZJQ3pJZ2pvanVwOVhGRU9RZ253cGlD?=
 =?utf-8?B?SlJZZnlOV2RUUE8wVjNoRG9xck5VZlVUclZBc09adUVGekdtcGxWVHo2a1E3?=
 =?utf-8?B?Rm5XWWFPWWd4eld2bUMxbjBBMmEzQ3NVV3k0d0pQL1pEMnhHOFFFQ3lCaTNK?=
 =?utf-8?B?TWEyZWVFTjc4UWdZc3dMSU1NSFN5RkRka0lDZnJoK3dzY29PN00xMCsvZkpS?=
 =?utf-8?B?RUxQV2xRMURwTCt6RTZyakUvaXRPLzJ2NkVVMFhINGdjYXI2cGJZdTNDbllt?=
 =?utf-8?B?cW1Wd05nRTNDWkxJOWRRUUoxSWRHeVZVaGVqRDhybm5za1dYWll5TnFrV0JU?=
 =?utf-8?B?M0NaQWdLM2hrcUJQbEppNGxTV2tOLzdUWEI2RGFraWlmUngvTVMwVTIwR0hL?=
 =?utf-8?B?bktxeEFXc2w1REF6cHJ2QXBSMmRLVjRwenBQQmxrY2xuZmJ0Q2ZvcFcwT044?=
 =?utf-8?B?R3lHa2FZWDlGNUlmYXZneVR5ZUNycFNUdnNFaUdORTZzVHh2Qy9lV2hrTVVW?=
 =?utf-8?B?dWJ4TTIwd1V3Ti9CUEYwNTR2bTcxSUw2ZElEeDZ3Y3ZST0ZxVWpTZnllRWoz?=
 =?utf-8?B?cjFFL1VzTDY0RjdtUC9KY09GVTc1UmdoU29RSWdOUjZlWGNBZ2lZUGQ4NnlB?=
 =?utf-8?B?Q2xzaVdUSTh2R0wyT2ZqK2RtVDVFV2crUUFoMkF6eVdFMG9MekNybE1nV0hG?=
 =?utf-8?B?N2dVSDJLTVU5Ynk5V1JLajg0QUVWR3pXaVJOTXdUdUh5ZzR6OTJBRTNBWTdM?=
 =?utf-8?B?SlE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	OHSfOJrDuvAERAPZJ7dC1sgPNxPf1zyd/Amerwh83HU4hOlK0MRCi9nM+hbFqTmwgb8YMe7g/6sVA0zuoF2Zo3n+GgxMUHQ+sY713mn1MMLvZAP+lLzbTSmbV12Cfld8GjU3zPWdMOKJgY6tCd+8524PRqPkzwTJdLpN88Py+ANyvLFEyX3qTpSlQv4Kc2Endvt+hGPCF5N6HW2ZchAZV1t+kIv4n1uBXEC8yTVl3MRt3HzAFt2vUbm8DtcG9PoL03MQprovseTjuq3/CJEnGKC8GSmmBPeZrAqnsGDxmBOcAiwl3GoBDOuzOTke9iTsC6agek4LapHd09M+bGfMV6b96J0cOIuNP4NYwZ4aEoJjpEDmfspS59O7WaZ5vXgS+f/07yQ9Jb2CZCalC++2Y68Vp/NRbnAFSZj4qT3v926uCWJBZRq18jrmOULj1iKgZg7a3AcdM/ewGvYzMHz5vqELjT332lZFfbCjKD6GN+zcooizELEgCI+1xniCuWXHfqDcPwbt+nb8OWc8G2RRXW9KmsXLPdeSBVxDVOrNGMykMsFuw10sQMfShBXKxkgFZpJUj21fc9SCpyV6lvKWGh8y73IMR9kD/JayjVr2Sug=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 549589ee-1a3c-43dc-132c-08dc7b37eb63
X-MS-Exchange-CrossTenant-AuthSource: SN4PR10MB5622.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2024 14:52:08.3985
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LzO7yAjQ+pyVPKGmZzD2EEkj/gB/ZLG8K4sASIfoEHdPo94Lix0oR0nLENB6H3g8zHOx3RvYoNkBbp/Jl+lviKPsbquVpsT171IOd2ez0y0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7530
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-23_09,2024-05-23_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405230101
X-Proofpoint-ORIG-GUID: P_GtDpHiTH0RC9DIbnjH_vTXmqTigcPV
X-Proofpoint-GUID: P_GtDpHiTH0RC9DIbnjH_vTXmqTigcPV


On 5/23/24 16:28, Dave Hansen wrote:
> On 5/23/24 05:33, Alexandre Chartre wrote:
>> The problem can be reproduced with the following sequence:
>>
>>   $ cat sysenter_step.c
>>   int main()
>>   { asm("pushf; pop %ax; bts $8,%ax; push %ax; popf; sysenter"); }
>>
>>   $ gcc -o sysenter_step sysenter_step.c
>>
>>   $ ./sysenter_step
>>   Segmentation fault (core dumped)
>>
>> The program is expected to crash, and the #DB handler will issue a warning.
> 
> Should we wrap up this gem and put it with the other entry selftests?

It looks like tools/testing/selftests/x86/single_step_syscall.c tests
sysenter with TF set but it doesn't check if the kernel issues any
warning.

alex.

