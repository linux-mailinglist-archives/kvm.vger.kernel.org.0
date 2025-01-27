Return-Path: <kvm+bounces-36694-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D00E6A1FF89
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 22:17:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2686C3A4A3B
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 21:17:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9591E1A83E8;
	Mon, 27 Jan 2025 21:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Nw4KZTdH";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="tVxedO5+"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E451748D
	for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 21:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738012659; cv=fail; b=iXQRu9qWK47jvIGqnbaPQGf0nV3zDGxnd2bfI/IAYBpklyJ3luW5QD7NC2XiR4q+SaIX8LHAZYXNyGtNRlpwKbA1wZnJTatjqHvCrmboRfaYPYvO1gCQYCydEelrZtbwGiJNFfbdw4/Ghi8SAxTKW6h0lfgBhwB0iLvizPEp5CA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738012659; c=relaxed/simple;
	bh=2g5LHnzgY7I910tpCARMmXmLihLaS1p2o68Iidn9EMg=;
	h=Message-ID:Date:From:Subject:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Hhy97EnNAy+NwdFcSdsz0ogz3D6fjJFbDaUYneVJAAor7KffeihUUSz0B8XA0LULLwqLCDIQx78hrsSYnpj5XCJFT5JBz0Dove7uW4TTyWk+fNb8MSBZOewNe4HMkIc4IVTFmutK3Zs8orUQ3WsbMR7hyeQE/B3eVkuXC//9HSA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Nw4KZTdH; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=tVxedO5+; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50RKBnU6008423;
	Mon, 27 Jan 2025 21:17:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=ZRzzFCy5V0nHp4MPutEiO44vUMwVzU/1lws263KUJsE=; b=
	Nw4KZTdHzmue38vVTKdy8ORXaUsRMRpTx+JBcEW+hb4gXHQZvlAlsLP/ckLfZPv8
	UTU/bRgTFlQV2EkbzUVtTd7ZNxl5QrGMfKrVFQ7C+AatnP5jUhTQs50CSF/ZP8LW
	ECXX6c2agTZh6BdIS+TmCLpecwa4e69KZlOfHmGM9IpdwgFH1SQKDFFTvVso4uFG
	JaDvqkRAZoJ1fEzjbVhRCrRanC7YdLMZaKJGJg5N9hPo4QT0qk1KcPchlBtqEMpd
	KbbhgJ7PIpxBHwhaFIgYwlCMNR1pOz8gcZRHvvV9mOadqMTfIpidgM5lIhmQAzuc
	Dww9FAoPAoU7HALNXHMwSg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44ee6d8jnd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jan 2025 21:17:04 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50RJXMXf013779;
	Mon, 27 Jan 2025 21:17:04 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44cpd792wk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jan 2025 21:17:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n5Fd1Ac192qXVW5c0Dqcbm4+vDND/W5pghifccfk4SGkaTUk3lFyHplyCYt7DE+Bxh+ahScWXoI16ySZqpuJ5O2Y3OvipARiQKcLfFo59S0v5NNb9q3tWqKW/bZ8dWv+b6Amw9z9yN3KsNhxMmumSr/kKOv4IPguddAgyPyUNdXWCHDiu0VDtBKSa6iJOVc4F3rlYBKdoS0t2gC/qt7P+o/dJIgk0GnSluO75jkPU66LcSJ/6VHTieVGTLuwuOrhJcQUdi3ScA8YYXaExktJQSynMJ3opFRD6COWkbpsBZDTK9WC8VwUfRjdzCNcNCr/U9B0t//sn7xvCiPDkwxO+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZRzzFCy5V0nHp4MPutEiO44vUMwVzU/1lws263KUJsE=;
 b=y2IGmvCKJ4UabnNiaOIbcDv1TguCue5Ej+2m7EwnkYZE/BlmOUTBQHqqmbb+JATW3OyRsae9+/sphreF342nMLc8fxlAcNekl6HKmOxl6jO9nY48AplmGYCCUQYezQVKAQm1F1XQEutqi8YKDQF57YJxPAZwp3yznr4kumTmfvJrW7dcYIe0Un7PldLa7B/+37tTOaUdrScYS9g6Tqeaapnga/F1xiMZ6nXyFgVCmsgeK08Ti5fDDYf/84gOj6KhnJQWtqioT/K2+vuUlKjp9XLvJDh2mT2+QPtSQTrGrBz77idK+v2d8zGt3RwSJSOM/etSPJlgeJnxxVBDNrq8RA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZRzzFCy5V0nHp4MPutEiO44vUMwVzU/1lws263KUJsE=;
 b=tVxedO5+Dz9kpoAFWp34xUky39s98YCsBW5Sz+V8/Hrz+GZ0bscGR6GMtuQfN1S1ruhONEa4129oiIR74o/n1mZHV/4lD4m7SA7EGvMk8AIQNlxiTT8ArZYSPxRjqc3g/QAxRok8P+h4NxK3Fsq4+eO9/tw4n9kh30yiGxZxmQo=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by LV3PR10MB7938.namprd10.prod.outlook.com (2603:10b6:408:217::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8377.22; Mon, 27 Jan
 2025 21:17:01 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%6]) with mapi id 15.20.8377.021; Mon, 27 Jan 2025
 21:17:01 +0000
Message-ID: <9d238e36-37cf-4fe3-93b2-02a51daee0aa@oracle.com>
Date: Mon, 27 Jan 2025 22:16:57 +0100
User-Agent: Mozilla Thunderbird
From: William Roche <william.roche@oracle.com>
Subject: Re: [PATCH v5 0/6] Poisoned memory recovery on reboot
To: David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: peterx@redhat.com, pbonzini@redhat.com, richard.henderson@linaro.org,
        philmd@linaro.org, peter.maydell@linaro.org, mtosatti@redhat.com,
        imammedo@redhat.com, eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
References: <cf587c8b-3894-4589-bfea-be5db70e81f3@redhat.com>
 <20250110211405.2284121-1-william.roche@oracle.com>
 <7d2765c1-8efb-485e-936b-ea047be7018e@redhat.com>
Content-Language: en-US, fr
In-Reply-To: <7d2765c1-8efb-485e-936b-ea047be7018e@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LNXP265CA0040.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5c::28) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|LV3PR10MB7938:EE_
X-MS-Office365-Filtering-Correlation-Id: 3bcb98d1-ecb9-4f2a-1b5e-08dd3f17f0d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cURxa3NuRVcrY1JPK1hPaW9SME8zUmlYODN6SFVDcW9nQzVlVTVQVnFKS0dp?=
 =?utf-8?B?MnRKQjF4SmxFL0pSY2xIdlVmZXQzQ1I4SWd2b3RzWnZEeFAzUHBKb2Y2Nk9w?=
 =?utf-8?B?Skp6Nlo2bmNSUmp6NktDdzRNUnlEZUVXUUpNMEVTNTV3MVRPWDl1OUpVS3hi?=
 =?utf-8?B?MVk1ZWdnR0F6MkRZV3hUOUNvUWZxMVZBU1MrbjJ6ZVVvbjNVcy9aYkt3ZVFP?=
 =?utf-8?B?UFowK2hEWFk1eWlVWUFYVVk3cnl3RWhnUUNPVG1vY2lkNzlobjBHQW1VRjBo?=
 =?utf-8?B?YzRnWkJPU1FiRXh1VVdYalRZVGJlNE1VTjUzbWltcExKTzhBNWw1SWwxekZS?=
 =?utf-8?B?aUJ3Q05NU3lvTnFmRk9xUnZoSW5lUzhXa1ZYclJGcm8vemxGZCtmby9NTWN2?=
 =?utf-8?B?U2VDNTBqaFJKUGtiVVErbEhGMVBrUlZQRlo0NzQ0WERlMlZ2YWtvNlBGQWdn?=
 =?utf-8?B?MGFoODZzOUNVN200b3RKM2ZpZ0I3ZmdXYWdaWTBXM0RBbndRRmcrckFIZnl3?=
 =?utf-8?B?QkhidEx0STBoTS8xY0p4Z3VjbU5qUUp0SlNYNU1wQUJtODBzcXd1WE4xSzEz?=
 =?utf-8?B?OW1LanRocXpMeWYvVk9iMllKMkxLVmplOFMrZGZESEplTUhGalAvYXFweEs4?=
 =?utf-8?B?UlZPa0p4ejI0NVFwVmxCd1Vwa29MSFkxZEZWQml5MWdsNU8vMXZtQ1VBcUdO?=
 =?utf-8?B?YXV6azgvK1F0TWZUblE2UXE5d2d4QjYzR2NhWkdkN2RkdE1iZEQxTnAwYjRB?=
 =?utf-8?B?TUE1bUUreHNiQmFTZEpxS0pIbVc3YzBYclF2K0hUYXBuMW5xdTltakd0cmN5?=
 =?utf-8?B?NDBoUEkzVFRDWVlXTDVIcmt1cVVDb0l6VE5nREZOaGVqMVFsOEJaakkxZ25F?=
 =?utf-8?B?ZzBXTEc0U2t5YVBKdmZidUxmSkdQMHRnMFMrN3hlSTl5UjBBMllJanhHa0Zs?=
 =?utf-8?B?K3QvTlRaMHRaTTJ3dnQ5SzZzYkR3WWlSTFVPUHBVR1dnTXZiODRwUnFpSXpM?=
 =?utf-8?B?Z2x2eG5HY1Q5bWVvZXBYVEs3aTFQVEV5bW5zbFJHK3A2aXcvZDZTRlMrOEQ1?=
 =?utf-8?B?VzBjU3pyeTd5TXdRYXFhTG42TGJUZS8xZzVmZDRuQWVHb0ZiUVAyVGlDdk9G?=
 =?utf-8?B?U0U3UnoyQzY5MDJCdElrNFBkejFNRVQrZmhUL3RvaHNkdnBjc212UFJtcGZY?=
 =?utf-8?B?dnFBUXVPZXB3ZTN4VExhZ0pBNCtFQ2ZBQUZGdUNjVmNBL3M2Y01TZ3l4RDdD?=
 =?utf-8?B?eHJ6SlFVeEk0bUplaHJMMTBudGpIMS9TZWxxZTBCUEdmbi8yaks1SkdhaHQ0?=
 =?utf-8?B?ZWZKMGVLR1VBRXNDZUpFVFBmL3QrejJLU0c4VXlKTThhakptNEh5SVBIam9F?=
 =?utf-8?B?elFjSmN0WGlUMlgrZXFrRFFhdVo4NVcwcVJXd1dwbzVXRTNBVkZrWDJ6dlZ0?=
 =?utf-8?B?enVLS0R3aUE5djFoTDgvVzU1Skp1RFNEelZnQWluU1IvYjRXOWlOVmZlM0V4?=
 =?utf-8?B?dUtVMkc4VmhVS0NZUmRxV1hrNVVkU1k0NXpmdVpQOVVtK053MkNNUHQ1WVJa?=
 =?utf-8?B?QnA5WUUrN3lmY28xdUF4elBGMUVZSzhERkJVQmwvMi9NMmdvUzYydUxueHEw?=
 =?utf-8?B?VGVJNk5Vb3BYUzl3OFB1RlFLbEs5M2NjUEthVnZvN3hUQUgzVHFwUDdOY3Jl?=
 =?utf-8?B?TGZxT2o2NDFDMlNZeWNtTVh5V0dBTkQ1RzFnR0I4V0svci9ZSjhhVy9sdFE1?=
 =?utf-8?B?WmhEeUt6UGxneGt2cUY2anVPTmFOSGJJV2RFOXJQbFFJZnZWWmtVTm5LcFAz?=
 =?utf-8?B?ZkVvOVJZa3dZLzVjN29zSWI4VEpXN3l0R3FGdm9ScU9ON1U4ajdPUmhSbS9k?=
 =?utf-8?Q?nktPdiQSuPPFe?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?djZDU3J3MCt6TGh1S0ZIYXdRQytZd0ZoMWNOVW1lakp5R1pQWVgvTXBPaEZJ?=
 =?utf-8?B?azc4MHl0NW9McVZ2aW8wTFpuOFJlZGZ4bWZwaUpJUWxxYnNNWVMrL2t0TzRk?=
 =?utf-8?B?M3hoOHNma0dQcEhTYW5xUVNWRkdxemlYK3Y5YkluRFlFaWFRb0l4eGtNd3Jv?=
 =?utf-8?B?STFjZ09XeVBSYTA0OFdaQjZicXVCVVNCeUQ4cUVrbi96Q2I4aFhpQ3luTFZ2?=
 =?utf-8?B?WEhScVB4ZjhEai9uVFdjRWZNSDhGL0I3T1M5Z1VGU0pTOFhNUGxvL1J4Vy9Y?=
 =?utf-8?B?STV5MXJIOEpBaDNCeTZYSGc2bEQvTmQycUFER1NPNExrVS9EL3hsNW96Y2Z2?=
 =?utf-8?B?SW9BbFdrNlB1djIySmwwMXlucmlGSXlLSk0vTmRUcDRJYmFrN1Bwdjc5RkJr?=
 =?utf-8?B?SHhOTGhnL1NXVGRpMjRRK1FzNEYrcUdFS0lBdnBaTGZSMDJHTjdaa2ZiRkRn?=
 =?utf-8?B?eFZrc2lmNHZDTHhXVWMyMjg3Q3o0T09NZThhZGlha0tKcHJmY1BocFVHaWxC?=
 =?utf-8?B?azc0bDJKbS9DcStrV3RBZTFpOXB3UUF5Tm9RT2EvT0E1QWo5dCtKaGUyYmxm?=
 =?utf-8?B?WUlkN0pLaWRLR3pEdkpMNFBianozejV3QzJpYW01eTZwLzkxTWdvNU1ORFp4?=
 =?utf-8?B?dzZGWXgxQ0VsdjEzVksyRWZWWGF6QTNBaTgrK1ozVGhzd2paR203dGxwQkFl?=
 =?utf-8?B?NVY4ZHM0SlZESWg4UzFyVTFuOGRCTTl5NFlGdWpndEw1aFpZeU4yNDgyWjVC?=
 =?utf-8?B?am9vT09mYnhzdGgyQVF0SzQ3Q0V2NG05SWVOVUoxZisvaVNINWJ2NTN3MWNa?=
 =?utf-8?B?QTUyZXhzMUR6VEdya2s3VlV0em9oRStVU3o2YkRoVHYvL3hYeFBIRmdodnFp?=
 =?utf-8?B?Q0tYYVFQdXB4aENsdWgxT28vRGZtcmRwKytPa3RCT29zOTZLVXdMV2VNOS9w?=
 =?utf-8?B?cjZzT1dPMnFFRjhEdE50YW1vd0JRemkrMTYyTkgzRHNDUTd3cEdPTm5ZWWg1?=
 =?utf-8?B?L3FBNnYzcDJtbCtuNzMyK0pmcVkwQ05qNDlYOXpPRmxiNnNFd2UyMTdsUDBW?=
 =?utf-8?B?R1JSNjZEUUZSZFMxUGttUlUvNlRoTEk3bkZoRElBWTlTT2RFZGk0L1h1UW9L?=
 =?utf-8?B?SWNuOS9vK1I1WThBc1dscXVlRU5JNTR5QkN1cUNiYTZyT3Jadm1uSXpvTDh4?=
 =?utf-8?B?VWV1Q3BndEtEeEk3aGJCY3VVRVBOS1k3UE15UElXUzBsSVZVOHRUWTlsQzgr?=
 =?utf-8?B?dkdLeEpDNzE5dkpESENIV2kwaVM1MEwzTG1PMXNlR212S2Y0SGFXSEt4TVIx?=
 =?utf-8?B?QzczWnhLb1VqNDdJSngxRmFIazgrWW04cWdFemVoUk9hM3phQmdVZnd0c3pa?=
 =?utf-8?B?cjMxUlZsZ05JS242NEQ2dXdieFRCMkhKTWQ5OXcrdWNuai9vK2VLRVp6RGE3?=
 =?utf-8?B?Q2J4VjZyY1c4NjBPR2F3c3I5QnFRZnlmSENxcXBBZER6NE1Bb3VxVktiZWpF?=
 =?utf-8?B?WXhUTWlRNTA3dHFUb0RWYkpxSEFhNlEyaXdhMHZLazFONElIL2lPeTdnRk1Q?=
 =?utf-8?B?bHNEWVZYOXNCZ0paaVhXbldvbEw0cU81aHB5YkxGanhEUzc0K0pyWTRVcjBt?=
 =?utf-8?B?NHcxSzh1UUpSZGNxUUYyTm04djI5cEs0OUJHaHZPR3RoRmZPYWNuWVV3cFZK?=
 =?utf-8?B?T1RuSWVrRXdiaGdpSmpUeUxoVitCRXNwUlMvaEVlMnFMKzk0T2dmMGF4R05X?=
 =?utf-8?B?emxtSThTMmtock9tV01kL21sRjJWN2FJWUpXc2kyQUE4UzdodURNbDFtK1dn?=
 =?utf-8?B?VzZRZ0UyUHlUOGdFZk5kVWVNUFpUK3FVelZvQ0RKL1ZPd2Y4UmxxYm9UWGk5?=
 =?utf-8?B?bmRBc1NPWG5ZSytlSGtPS3BmaklEam1BU01iZlRGOE0rQ2dqUjFBdTBJdUov?=
 =?utf-8?B?RzMzQlRneHVSbE9yZ1Bpcmx6SGJSNmVtVVQwSGJyeHhobFZtdUFGY1Nwa1ZJ?=
 =?utf-8?B?b0dzUUc3LytpRlNrMXQ5MmRtWHQvdndjR3g2ZHpybTNDN05rUUVlV00yMTd0?=
 =?utf-8?B?ZHZ5YmNEcmV5VzBUR3Y3NkFza09TQ3duQXpXL1Ntekw3K0hxTXkySVZtYU5j?=
 =?utf-8?B?VWU3K085NjQ0N0t4MDNKZlYxN3Y5N2JMc2EyS1Nuck9PeXMxM2psMFMvVkNY?=
 =?utf-8?B?QlE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	J8poI6B43H1Wk6SZC5n2pJxmgWaHdAbHpQXfVu/G6D2F4cq4Xm9iG1DdNtapDeKO8Cic7OyGF5bnxaiFgIe/dkO/i5jtS9+KnaN7rjQO6S+E2PwR67+qt2JLXt/5NJm0yN/SnfLms4e4D2ShF0TXI48RcVcPo/BrT+zXOAPCV8jefMGgy/TJUlC22G3hOBJsgxgr4cJ3CrRv9D7TBuELhQwWYEUpznh+TyIjqkJlGW+zEwqxOp/k+Rb1lrL11Ze+bN/laV85r1hHSey/OE0AODygTHEnedcjT0MsFeTvt4up8sVQo5wFdiyYrUM4j6TC7mINIt+h0GQHr3hk/3SXMhGQfeIv/DYOU9st1lvsG64inlrXVTPenwa+M0ugO0LBURLD9h0+5PVpukzR9ACRLiIJ7+7a9DWoqVpzZL60l4H8PhwV4Km4d7Ft8kINtHZvF1o4W3Orp7shTy1UhpYqpSwORjGaantjo2v+cbrPDFeipwXF8v4vd+sErpVEChETtkKojuqI2pN45sK+Cv9wm1KDQR/6Pvlj+FMRnIKZx97mJqh6S4ixhh9nTJKPy9GEls8+xEyALN6gHT6qVq77xc5SUxYcVFq/PyNKKfuyTdA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bcb98d1-ecb9-4f2a-1b5e-08dd3f17f0d6
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2025 21:17:01.6269
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NxB3qiZ7kQwDWQbYU+jeH5xcKsSHswSlT3ZsLXYRUWCtuTTjoCGSQKEmKqyVaAvJPPHOaw5fHvwHsgtm+4HpCZFS6XAx3klEE6h+jsWKx9c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7938
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-27_10,2025-01-27_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 malwarescore=0 mlxlogscore=999 bulkscore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501270167
X-Proofpoint-GUID: IcQZtKazx6s9wRhYQM7uw1cxR8gwO0uG
X-Proofpoint-ORIG-GUID: IcQZtKazx6s9wRhYQM7uw1cxR8gwO0uG

On 1/14/25 15:12, David Hildenbrand wrote:
> On 10.01.25 22:13, “William Roche wrote:
>> From: William Roche <william.roche@oracle.com>
>>
>> Hello David,
>>
>> I'm keeping the description of the patch set you already reviewed:
> 
> Hi,
> 
> one request, can you send it out next time (v6) *not* as reply to the 
> previous thread, but just as a new thread to the ML?
> 
> This way, it doesn't all get buried in an RFC thread that a couple of 
> people might just ignore.
> 

Sure, I'll just send a v6 version now.


