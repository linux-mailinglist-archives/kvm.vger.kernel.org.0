Return-Path: <kvm+bounces-69305-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4P46NndpeWmPwwEAu9opvQ
	(envelope-from <kvm+bounces-69305-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 02:42:15 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DE549BFA7
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 02:42:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 92C263019056
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 01:41:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C2B8254B1F;
	Wed, 28 Jan 2026 01:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="abLz4NGc";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="w+Y7CGfk"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAAE623EA92
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 01:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769564487; cv=fail; b=LCZt03bK58Hm+65GwhNhHSUTW01v6Kj50oqUQjdkdWknNUlspRuPTrt1ILa8AP/bg3RuugvgPcVIyx7YWgr3/GsCjVEjtoU/TYsBUJtd41JYvQ/flxmg2G0+ASQgRwwmcA+Z/YqkHb+rWBcpCfZvt42We+4rVpmZ0Da3Djcbuuw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769564487; c=relaxed/simple;
	bh=P/+yTGvoyQ3BiTxLw8/3YjIw0a6Ims2/aRR/Y7voOU4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nYGub0aAMALXzbVOefVlEeAG9L16sluBlw5ki7CUUKEzotDyESDPKQtcAkJz53/GqXGLfdQQrVU1An8XY40V20Lkur0jQ5HAefCrZJqq5VFJhL5YXTAzqEgcmV3gNxAE+RzAR0xG7CCbZTAYwC3xB5+a+CVCYRttsOD8aJULBIY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=abLz4NGc; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=w+Y7CGfk; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60RNFPfN1679755;
	Wed, 28 Jan 2026 01:41:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=T4qFzGwdNU/SrWKsswLABue4cS4YUuhEqAs45Z6TNvI=; b=
	abLz4NGceqSNcp7aMicrmHW8whl+MXGHhad2nkdM2IqDbaGp+fzUHtPqMo5VT7jO
	L7ZdKZb0xwsmadO4gJqbSKJ9lHGAnSdRmKrZ2Lsow6RPQMCaFL0uKl5l6I8I/ycS
	NJUwV+gCnhI1Q/s0neVbmjdMDoN3NlsOUhhzj0jl/uDa8QTtmi28FYqf8HoWgXxD
	JhCnO4ILWH/BeGIE6Rm92Xc3Cqxe/np/SKgaF0sutND89fxf2uzasgDHHV1igghU
	MrbJo7pQEIVzuOUKrAxRaQkIXd0YNo1csA8okZ5q9ITWH2tqNuq2JCYlcKQTQTkG
	Q5unED9MY2lFzPGoFqeJuw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4by2xqrn9a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 Jan 2026 01:41:04 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60RNFOMS019829;
	Wed, 28 Jan 2026 01:41:03 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013035.outbound.protection.outlook.com [40.93.196.35])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhfjcg4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 Jan 2026 01:41:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WZDkxXNk5DIO8HVbsnX8kn005aUUXp4XKQ3tiCJ0mtsZ1DNXMwB97GiWsYnbJImgQCLT4+hjo9ktwlvw74kUgRc2rdWMfQ9idBoS6UbSTCOn3gSqYseXftu+0sN9Sjh3xdHJcP1c+PvDI0+SsNtGZjVHIoH5Jk4Vhc1WoVTkqA5ShNnv3p5OCqvas18goHjKZVX0QjjgWryd/eMQqmA9l/Ek6XjcHI3h8Y8NSDTFnjm5OVGDg/+MUIiMQiMoPbTP61mqiG0cj28iMvfRwWxo+po8TifxLxC/UguOJS4UK4Q0W1Yr6BmlgfPRjSOLWsbp9EhyhI+Si9jfrMUXnlGFew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T4qFzGwdNU/SrWKsswLABue4cS4YUuhEqAs45Z6TNvI=;
 b=fDbkVn9ekVUU3yfDPP92rK5jsPvQGCFS8D7YGBdXmYByki7Xfo2aTBc4WnAh8IIcdgMoP/wFfl7jXy4xaEcS3x9T6Yd+YC7gJMjAPW7qPpPy6E4SUHNensz8i6BrgLoMeFEMLccTw6GqIg4fb6VD7hWKQesjnZAUIYbJWOd+ZIdVpK57/ib2Ud76ZSm+ojymwe5IUI8lGRY2wohoZXYzfkpUkhrFWYtCbB2Y+rbsfOHc04wF5YLxa1Mr+WQc2+TbY2HlYHaoxElHe/qeJ0JipPc0xz0kewb9B8c4eeyuzl9JLZBE0576wx7rdgQjy1vwhz6eN61j3Uodmj7pgshNpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T4qFzGwdNU/SrWKsswLABue4cS4YUuhEqAs45Z6TNvI=;
 b=w+Y7CGfkfPaU/uCrcarB948V+T2MbBLn96sIEEUMRUHszEUMPyKZQsuLjNBkykt02ZTTEYJPJflCmeqPtyUfu5UAulz4FkvimuFx6pwNMO9+tDGsQLXuI/Ao6+bUhT2IUt2MdjRMOwZSWJXIK94r9K8lv9Q3um3y+dqf5gp4ZVc=
Received: from BLAPR10MB5041.namprd10.prod.outlook.com (2603:10b6:208:30e::6)
 by MW4PR10MB6655.namprd10.prod.outlook.com (2603:10b6:303:22c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.16; Wed, 28 Jan
 2026 01:40:59 +0000
Received: from BLAPR10MB5041.namprd10.prod.outlook.com
 ([fe80::2c19:641c:14b9:b1b4]) by BLAPR10MB5041.namprd10.prod.outlook.com
 ([fe80::2c19:641c:14b9:b1b4%4]) with mapi id 15.20.9542.009; Wed, 28 Jan 2026
 01:40:59 +0000
Message-ID: <f7097f24-6c4e-42eb-a2ab-968b6814e969@oracle.com>
Date: Tue, 27 Jan 2026 20:40:53 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH RESEND 3/5] amd-iommu: Add support for set/unset IOMMU
 for VFIO PCI devices
To: Sairaj Kodilkar <sarunkod@amd.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, vasant.hegde@amd.com,
        suravee.suthikulpanit@amd.com
Cc: mst@redhat.com, imammedo@redhat.com, anisinha@redhat.com,
        marcel.apfelbaum@gmail.com, pbonzini@redhat.com,
        richard.henderson@linaro.org, eduardo@habkost.net, yi.l.liu@intel.com,
        eric.auger@redhat.com, zhenzhong.duan@intel.com, cohuck@redhat.com,
        seanjc@google.com, iommu@lists.linux.dev, kevin.tian@intel.com,
        joro@8bytes.org
References: <20251118101532.4315-1-sarunkod@amd.com>
 <20251118101532.4315-4-sarunkod@amd.com>
Content-Language: en-US
From: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
In-Reply-To: <20251118101532.4315-4-sarunkod@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH7P220CA0026.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:326::31) To BLAPR10MB5041.namprd10.prod.outlook.com
 (2603:10b6:208:30e::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5041:EE_|MW4PR10MB6655:EE_
X-MS-Office365-Filtering-Correlation-Id: a8870bad-21e2-4e2a-0ec6-08de5e0e4982
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7142099003|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cEhEZTUrWmtyZFRabmpwWlNxMFpHSjZhMjc1SEpCMXdJcG1QRC9kR3E1dGE0?=
 =?utf-8?B?MFVqQW1YTFlKTW1iQkVFT25UWXdFRHRGcFl5MFU4TGx5NmtaTlIvVmtMUmJZ?=
 =?utf-8?B?QjNXcDBZLy9ydWIrV281Q3FGdTBIZ1l2WlR0bGVxeHhvNDhkWHljOVQrbFFw?=
 =?utf-8?B?SXQ5SHdSbWthN1NuRDUxeFZLc0dieVNDMFEvdTdRL2UvalVxa1p4R0lwb3hD?=
 =?utf-8?B?aDZjME1ObXk5MmFVMk1zbnFyVkpYR0Zkc29jV1AvTXpYUEJ6QmRyS0xEbjFa?=
 =?utf-8?B?WWp1TkFEZ2kwRitBSmxpL1laTTR3MDkrWTI3bUZMU3duZ3BPQTRVR1lhNVNK?=
 =?utf-8?B?RnVuSTNnS3hPdVFucVFZNndnd0wwNkFodGJmdDBNdlhXdndOcnRmSkN6SWRY?=
 =?utf-8?B?a1RMOFQrb0l3TFlFV2tKRDNhUVlkZCtHMkRpbEtUSGViUStpQjdCcHg5bkJs?=
 =?utf-8?B?NDJZanJOelJhMzdIblJ4WjhjZDAxQ1g2bjRNVHR6ck5EUWpqZEM4TGdzcWdC?=
 =?utf-8?B?SEJJWUEyKzZtLy85UGRZQzB3Ym1BZjVJZXJoZHRaVllDZ3BTV1RXaGtnNEE1?=
 =?utf-8?B?emErZlpMWXAyOHc2dHJtUnUxd3Bjck12VVE0SmY1ZVM2cW0yRmk0b05qZFBz?=
 =?utf-8?B?UFRLMVQveG13aE5JNW9Mb1ZSNHlUYU9nVC9vSVhsTTRkTkp4ZG1DOW9uSnpE?=
 =?utf-8?B?TXhLUHNXeGdBWU4rcGt4ckQwNGlSS3MzcnBvWExaRFpQRWUya1UvK1RzRFFE?=
 =?utf-8?B?VVVzU0ZpTHFiQ1RMRkxWbVRSOUx5c202MGd1TEZoS2ZKK0VQRkFsSmNkL0lH?=
 =?utf-8?B?Zjg3a1Y5Slh0MHZwdEJWYkRacEZCTU1VTzd6RHRWZlZOQ1FjV2RhdHBZYmhx?=
 =?utf-8?B?Smhvc2tOODRJRTBZYnlQSHp1ZWEyNVpYWCs0UFg5ZzdmNFl1ektjZWt0ckJ1?=
 =?utf-8?B?YUNQVTRZY1pWY05UTFlwMjlUYXNWaGs4Z3dpVVZsR1ZwTEduV3VUL1ZKdEJ3?=
 =?utf-8?B?S3BONDV1SDZkSGVIc2ZWQUVXSnIvNUd0WGV6UjllSjQzLzhEQ0NHN1k1bmY5?=
 =?utf-8?B?NVF1dVlGSi83SnlHUWJGcVBtT3FESFVBa0lRYlBSUGNydXZBQ0V4YTZFWmUy?=
 =?utf-8?B?UVpjS20xYW9CSTJoVE1xQ3VXR3FVdmNHbVhNQ21WdzY0aXd2OWJveGIzS1Fi?=
 =?utf-8?B?Q2xieVFMZTRqZ2w4QVVSWWk1WEpJZFhlSk9mYm9ycFBVU1NXVDFSdWpGUVZJ?=
 =?utf-8?B?YUJ1Z1JlU0VCNmxnZ2RWMTdrY05nWGE0bnZhcmJkTjhiWG5tcnNBaFBETCtu?=
 =?utf-8?B?ZzRkemloYktVZnBvd0tVVm5CdHVMTCtCcDQ4YVBiK2U3OEtxelZid2hvaW15?=
 =?utf-8?B?eElLZUV1dVhHUm96Y3BMeVcrdnlZSytlc1F6Z2xnTzRHTzNZVE5ZTENpWmFZ?=
 =?utf-8?B?UFY3ZkV6NEpNeVZmR2xhdUc5OC9INDQ0ZHdBWU84dlZYVGo3M29PTkVBYkRN?=
 =?utf-8?B?UitzaHc1M2ovd054S0ozV2pNYmVyTCt4OXNkREFzbW5JNUpMc2RLUitWY29R?=
 =?utf-8?B?UExwdXdXNTYrK3VlMkZCRmhKTWVLalpnbGRGRHVBdGNZZElxY1FPWFpuWkdk?=
 =?utf-8?B?bm1LQUIyYVRsUkRRcnBUOEREbU5hMTU5UzlaNHdWaGc5ZkFTR2kvemVsN0Zy?=
 =?utf-8?B?MkR1bHcwb3pxWkNESnVqR1ZoMjh0cUlMMWFOTzNsakptOG1pT0hsUU1STHov?=
 =?utf-8?B?d29Sdmt5Qm50NlBaSW1ZVWlSdTVWWHdlQkRsQTNrMGU1ZzRndzVUV1R3RGNN?=
 =?utf-8?B?a1hlYk8wcm5jZ1ppTHRDQVR4NEM3aUF0V1NuMFpRZjZvZDFHUkFoNXpyY0Fu?=
 =?utf-8?B?QlZZQnpkWTlsbEVSdXZCa1oxMDRteWorZmZpVGFYdXc5ZEtGemJVVC9MRFh5?=
 =?utf-8?B?c1F1YTJDWnJmOCtuTDhCOXZwbGJhN1J2UXc4bHo3OFBaWXd6c2RrMjVqa282?=
 =?utf-8?B?bTZqMTEyUmtxVzZML25LL2tJRSswQldGQWFrVHdPVkh2eDlUWXlpUS9Wa2tV?=
 =?utf-8?B?YUpNQ1lWTkFFWExZMVo4K3dOVHJaWWY1cGlFOXg1M2l0Rkt1dFhZZ2d5OVNa?=
 =?utf-8?Q?tz8o=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5041.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7142099003)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NmcwUHhCWk1YS0w0M25FUnU1WFpMU24rRTNNZmZkSCtxTVhNM09wS0FiQmNm?=
 =?utf-8?B?RHNDOHBZeHUyT0F6NGdPZTZxY0VCdzlPTXU4S3pqS3VWYUYvaWxXVDdGWUlN?=
 =?utf-8?B?V2Z6ZHlCOEVIdGhWalpEa1JKOUI5T08raWd6VFlodWRZTU5FWlRxdVZhdWZ4?=
 =?utf-8?B?Q244UXN2bGlncDlWS0loaGxWZGVBdG9OVXAyeWxMVExZNVFWR2FwbWZ5ZkVB?=
 =?utf-8?B?TU04LzUxM1RLaEVnOEVCZ0tuQlgyNzBNWG9vMSt3TXp3SVhQcWJMTFYxNGFt?=
 =?utf-8?B?YzJSOEpTeCtoNEJZdHdqand1YWh2U3J4R1ZRRk5DaUdWRkVSWi9uTW1USXJL?=
 =?utf-8?B?RU54U2w5NHl4TEV2cGNkWW1xZENwdDdiaDN1ZFJLVlRmdVJla3pSQmFKNjJz?=
 =?utf-8?B?R0R4WmNqdFozZ1NHenE2ZHd5c2UwU1NldjVxL3pvT3puenlUNjBrNVpJR3lD?=
 =?utf-8?B?ZUFEejhwTVhGSkt3T1hRNHZTK0U5aHFIWVZHT2MzUjhjTS9ZOEI3YTlrWjVn?=
 =?utf-8?B?TlU1UkxSWG9mZTczZU00ejJ6SWw3WWVxdjhHNTlRSm5hcC9SZ1FVSmNzOEY1?=
 =?utf-8?B?ellUcXhDbSsrVlJDZTZpL0s0T0cwNExXT2FkME1US3VkK2tiV21SUzBZOUNs?=
 =?utf-8?B?U3NUbzZWTXZVNnE2dGVQT05hVmxsSTFpb2JrYk1GOWhHZ2NhVzNkb1ZucVlN?=
 =?utf-8?B?SkpUS2JyR2NtaW5TekY3bStON29Qcy9LR2VpYzVYNTN6QjRTVTVySjE3U3FL?=
 =?utf-8?B?TUd6ckF1bi9KYTMvRm00Q05DSUh1NkpiR3M0N3ZYa1RCcGFySGJSa3doOGIy?=
 =?utf-8?B?RVJaQk5jTGwrZGpRcHdCUW55SjYyVXMvZ080eUhGK1Q5N3d1bG40WGtkem9n?=
 =?utf-8?B?aUhMOE0vcGV0M0FlaEtGdkN2M0wyeVArMWZqdWFtNldpckVoZzBHYVFDU0Vo?=
 =?utf-8?B?K1ZHeCs0eWlxVDhCWk1vZUpXMDlNV2x3bnIrcXRyQlg1WVpVNGR2K2tidllv?=
 =?utf-8?B?YXdwckR0Wit1bmNNcHg5c3hpVTMwWDJEemhkVC9OMzBRbXN6QlJDdnoxWU9M?=
 =?utf-8?B?dHd6cWtTd0RQVUVtVzJFY2NHU1BHUlQraXREbDRmZTNWV25oK2pxNWtjSmhp?=
 =?utf-8?B?TFZ2RVNNV2VOTnFnS25uVU9QQmZmTXZ6TVBsY291WlBON21uWGRmeVJEUXNy?=
 =?utf-8?B?YmZzYXN3bUlaZTlJM0VUZGlsdExPR044MHdtQTk0OG1TRVFZaVZFMll0VThz?=
 =?utf-8?B?VXA1c214c09aUnFZZitQNDg1ZElSLy9oRjhQUFdwT040QVNpSHN3VlQ4Umdl?=
 =?utf-8?B?cktQRFNSTDh3MTkzdmxKdGhxRFhZajBVUG1sS0RrVVhVK2RTeEVHQXFPUEhn?=
 =?utf-8?B?NVBhc1hXYWdZRnJ5QVBQVERzY3Yzem9uRk9SSXFKcUJjbTZSSVZ0NXZQdUJk?=
 =?utf-8?B?bGl5NjNaQmNNRWdlekRhblQ4Ujdtd3ZCMTBBWUcyZXVQNmtNVW16eS9GVW5R?=
 =?utf-8?B?b0NncHd3M0g0WVNsc1VSaUREdjAvdGk0ZWdyWStGeWFBSUdvMVVITUZ3aTlt?=
 =?utf-8?B?cS9CMzFnY3ptczRsV1RrQVFPYkJERGQ2RzRhS3VMcHZ6REdVNFUzdGpUZ09q?=
 =?utf-8?B?NXd5NXhEUnRSbFhWbmVCQ1haU0xlV1RXMVVWU2FrT3N1Z3pRdU4yUjd0OU5n?=
 =?utf-8?B?SDl1Tk9uOUJraFZzanpJWjY0bzFTTDZ3RFJhL05JUWpiT3J4d2NlZGUweXFp?=
 =?utf-8?B?WEJOT21CSkFBZE9LbWxSbHhSZFBMU0dKZ0tuWmdyWXg3dGtnYjhORkUwWUgy?=
 =?utf-8?B?Wm5VSHhnY0lzTHo3eHNCTUhNQ2dWb2YvUnRhZmw2d2RSZ1l4NXpqdUlQT0R5?=
 =?utf-8?B?VXNxd0w2dkg5UC9XWXAvUnU2R2hqbkpON0RUSUNYam1obEMyNHNSTFA4NmpJ?=
 =?utf-8?B?NExpVlkydDM1UnJSQ0pNSHltbXgrOUgrQUNEbENISzdTQW9LcXJPVVRFeW5J?=
 =?utf-8?B?VTNkc1pHbHhOMHNlY1djVzZqNThmc0JjZkE3MVJUc1RFUHFndUcyaXNEYnRR?=
 =?utf-8?B?Z3lWTWdjTE82ck1ua09jak1kQ084aWJrdDZ3WGdUNmFnVFdac2I0bmVqZGta?=
 =?utf-8?B?TTdqT05Zb1ZFNms3SlZGWk5ZY0t6a3VHOG5weXFIaFg2MEtxaU5ZUTBtcnZU?=
 =?utf-8?B?MFJ2bDl5RHMwenJlUHl3SnlnRU5aSzBnSkpKSUwwRkxwNHpYYmcvVHpPYmMw?=
 =?utf-8?B?N2g4OUliaFV6VSt3R0RiZkdhTkJGT08yMlppRDh6cTFsV1dEYzl2RUR1SEw1?=
 =?utf-8?B?QS90RHZYbENDMEE3M2lONmlpRGNYcC9VVnF4UElhamkyMkhHWnJaZHFqUDRr?=
 =?utf-8?Q?GhKAnJPT3yJyaqX8=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	lLdH21KLTpotBjt5lGQgiVEOnnWDMCaUEWzoqtoWQpOifFt2MMi2rViQ/jcLrYMZw1wmbcvULhWBU2C8S/iweiJVNrj1YQGB/1CPWG16B0mlEhgeJlqZLkpxjl9uOEOK/KV+/ZnBxMFRRCQ+jPK7vgAy+BXK50GYNraOl+c9+FI44GlRp5CK+ehHqeknlQYM3LQvHIhhCaBWwfeZhG06PxV9lvjNVD6KYUwLLM7fdVV7Yam8g+jUVU1wRDt/4Zj1QfuGLluiD6bW/QSU8rb3OFSx3PBcjj2Yv00yGLmNVm5Q6YNEj3FLcWj1nwZ9cpuCFjXhQ7ZQ015QdNbTKaWSxEGpmRL0HjsR47jalQTSo0yoeX4RmxC9iSHDCne27THsmWgRJew+wgSI0kIIknl8qBFSiDX1PMni1AEIfkHpaUdBr1qgLceZPMZe0YWI8r/ej0PZMu2Q0zInF1WRgQSeibNqL7gwOnsy4kxd/GEUkOqJTtMs3PLjGWzpCAP+VdjzzunSHAtT7DmXYbY4dOJ2FcRBSoB7mWCanoe19yIzKoEfsVOj7gyrhV1D+5WxKvoXRxVZkGLUQPqYkkndrTtfVxsdkGKwbe6HvrOP1VMYxl8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8870bad-21e2-4e2a-0ec6-08de5e0e4982
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5041.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 01:40:59.0049
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oPqB8kcQmRXWTcKiiLrgTJHefFN7YlC5Pc4/O/YVsPiyBzwZEduE3Pl2tUJPsgo0+7nutodlpeoGK7F8nTj2GoYfHe9VjPhhLSSDwoPwAE0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6655
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-27_05,2026-01-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601280012
X-Proofpoint-GUID: eQW1v-ZjVefaCtx_2KK7t0OUtGx-l5rL
X-Proofpoint-ORIG-GUID: eQW1v-ZjVefaCtx_2KK7t0OUtGx-l5rL
X-Authority-Analysis: v=2.4 cv=UepciaSN c=1 sm=1 tr=0 ts=69796930 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=zd2uoN0lAAAA:8 a=JQE1nQ4pBp-sCWXtcRMA:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:12103
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI4MDAxMiBTYWx0ZWRfX+m17ub+h09Q5
 8aUjf9ptvEY4htJwVIz5dOQmx0d3orIhoDOqePgQPJW0Q1L+zdEPfSXyOuAuMj6eUbrHFfW7AT3
 0O3OyS+YxHnGXUHBpQNligcU020Gv/mqjMV0tVZ5eg38tcN8OIVAfCsCvF8SQ3XbWA/SyyxKWEO
 FyHYlLeac7lufYuRhXHm6kem3SpJCoT2dyTpITY6zb5O+cRE1WpdS2/qO9Hbaw7gwklbqEKhAEB
 SGmaxHxCyM9ol74bVr9VgVFX3HWHZIknDsXcXqmkKRINP/XzYs/vzQM46GDknZ2B7lfMtIIEX2U
 bONiuzKLdgXGeOR2jN6xkO4RP+bKSBR6xQQsHbZ0aO1DpwRml2A0ic1pAl9tPUwCpG0zedO4v6f
 UMN7xu5ekuHyPEnl2I8dK6ZWUUPxQWG9tnqUNpK7I3M5WpaxbpzQ02rKpxLX9EA6DQ5jdMOOVjE
 9OFn1Tno0amcDU7JP84p11ahwbnp8066TKXo7/Ro=
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[oracle.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[oracle.com:s=corp-2025-04-25,oracle.onmicrosoft.com:s=selector2-oracle-onmicrosoft-com];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[20];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69305-lists,kvm=lfdr.de];
	FREEMAIL_CC(0.00)[redhat.com,gmail.com,linaro.org,habkost.net,intel.com,google.com,lists.linux.dev,8bytes.org];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,amd.com:email];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[alejandro.j.jimenez@oracle.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[oracle.com:+,oracle.onmicrosoft.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[9]
X-Rspamd-Queue-Id: 3DE549BFA7
X-Rspamd-Action: no action

Hi,

On 11/18/25 5:15 AM, Sairaj Kodilkar wrote:
> From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> 
> "Set" function tracks VFIO devices in the hash table. This is useful when
> looking up per-device host IOMMU information later on.
> 
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> Signed-off-by: Sairaj Kodilkar <sarunkod@amd.com>
> ---
>  hw/i386/amd_iommu.c | 71 +++++++++++++++++++++++++++++++++++++++++++++
>  hw/i386/amd_iommu.h |  8 +++++
>  2 files changed, 79 insertions(+)
> 
> diff --git a/hw/i386/amd_iommu.c b/hw/i386/amd_iommu.c
> index 378e0cb55eab..8b146f4d33d2 100644
> --- a/hw/i386/amd_iommu.c
> +++ b/hw/i386/amd_iommu.c
> @@ -382,6 +382,22 @@ static guint amdvi_uint64_hash(gconstpointer v)
>      return (guint)*(const uint64_t *)v;
>  }
>  
> +static guint amdvi_dte_hash(gconstpointer v)
> +{
> +    const struct AMDVI_dte_key *key = v;
> +    guint value = (guint)(uintptr_t)key->bus;
> +
> +    return (guint)(value << 8 | key->devfn);
> +}
> +
> +static gboolean amdvi_dte_equal(gconstpointer v1, gconstpointer v2)
> +{
> +    const struct AMDVI_dte_key *key1 = v1;
> +    const struct AMDVI_dte_key *key2 = v2;
> +
> +    return (key1->bus == key2->bus) && (key1->devfn == key2->devfn);
> +}
> +
>  static AMDVIIOTLBEntry *amdvi_iotlb_lookup(AMDVIState *s, hwaddr addr,
>                                             uint64_t devid)
>  {
> @@ -2291,8 +2307,60 @@ static AddressSpace *amdvi_host_dma_iommu(PCIBus *bus, void *opaque, int devfn)
>      return &iommu_as[devfn]->as;
>  }
>  
> +static bool amdvi_set_iommu_device(PCIBus *bus, void *opaque, int devfn,
> +                                   HostIOMMUDevice *hiod, Error **errp)
> +{
> +    AMDVIState *s = opaque;
> +    struct AMDVI_dte_key *new_key;
> +    struct AMDVI_dte_key key = {
> +        .bus = bus,
> +        .devfn = devfn,
> +    };
> +
> +    assert(hiod);
> +    assert(0 <= devfn && devfn < PCI_DEVFN_MAX);
> +
> +    if (g_hash_table_lookup(s->hiod_hash, &key)) {
> +        error_setg(errp, "Host IOMMU device already exist");

nit: s/exist/exists/

> +        return false;
> +    }
> +
> +    if (hiod->caps.type != IOMMU_HW_INFO_TYPE_AMD &&
> +        hiod->caps.type != IOMMU_HW_INFO_TYPE_DEFAULT) {
> +        error_setg(errp, "IOMMU hardware is not compatible");
> +        return false;
> +    }
> +
> +    new_key = g_malloc(sizeof(*new_key));

When allocating the new key, use g_new0() instead of g_malloc(), matches
the current code better e.g.

new_key = g_new0(AMDVIHIODKey, 1);

*the AMDVIHIODKey type comes from a suggestion I make later.

> +    new_key->bus = bus;
> +    new_key->devfn = devfn;
> +
> +    object_ref(hiod);
> +    g_hash_table_insert(s->hiod_hash, new_key, hiod);
> +
> +    return true;
> +}
> +
> +static void amdvi_unset_iommu_device(PCIBus *bus, void *opaque,
> +                                     int devfn)
> +{
> +    AMDVIState *s = opaque;
> +    struct AMDVI_dte_key key = {
> +        .bus = bus,
> +        .devfn = devfn,
> +    };
> +
> +    if (!g_hash_table_lookup(s->hiod_hash, &key)) {
> +        return;
> +    }
> +
> +    g_hash_table_remove(s->hiod_hash, &key);
> +}
> +

I think we have to explicitly decrement the reference count for the hiod
object when removing the last entry from s->hiod_hash.

It looks like the best approach is to pass a custom value_destroy_func
callback for it when calling g_hash_table_new_full() to create the table.
Both the VT-d and virtio IOMMU implementations do it via that method.


>  static const PCIIOMMUOps amdvi_iommu_ops = {
>      .get_address_space = amdvi_host_dma_iommu,
> +    .set_iommu_device = amdvi_set_iommu_device,
> +    .unset_iommu_device = amdvi_unset_iommu_device,
>  };
>  
>  static const MemoryRegionOps mmio_mem_ops = {
> @@ -2510,6 +2578,9 @@ static void amdvi_sysbus_realize(DeviceState *dev, Error **errp)
>      s->iotlb = g_hash_table_new_full(amdvi_uint64_hash,
>                                       amdvi_uint64_equal, g_free, g_free);
>  
> +    s->hiod_hash = g_hash_table_new_full(amdvi_dte_hash,
> +                                         amdvi_dte_equal, g_free, g_free);
> +
As I mentioned above, I think the last parameter to g_hash_table_new_full()
should be a custom destroy function with a call to:

object_unref((HostIOMMUDevice *)v);


>      /* set up MMIO */
>      memory_region_init_io(&s->mr_mmio, OBJECT(s), &mmio_mem_ops, s,
>                            "amdvi-mmio", AMDVI_MMIO_SIZE);
> diff --git a/hw/i386/amd_iommu.h b/hw/i386/amd_iommu.h
> index daf82fc85f96..e6f6902fe06d 100644
> --- a/hw/i386/amd_iommu.h
> +++ b/hw/i386/amd_iommu.h
> @@ -358,6 +358,11 @@ struct AMDVIPCIState {
>      uint32_t capab_offset;       /* capability offset pointer    */
>  };
>  
> +struct AMDVI_dte_key {
> +    PCIBus *bus;
> +    uint8_t devfn;
> +};
> +

For consistency with earlier usage, use a typedef and CamelCase for the new
AMDVI_dte_key definition i.e.

typedef struct AMDVIDTEKey {
    PCIBus *bus;
    uint8_t devfn;
} AMDVIDTEKey;

having it in the header file is best I think. I will send a patch moving
other definitions to amd_iommu.h as well.

But I am not sure that using "dte" in this case is the best choice. I had
this comment written for another section, fits better here:

hiod_hash and amdvi_dte_hash() should probably use a similar naming to
signal their relationship. Maybe they can all be 'hiod' based i.e.
amdvi_hiod_hash().
This seems to be the choice the VT-d implementation made, and it also
signals we are using the same HostIOMMUDevice abstraction/model. I get that
the device the HostIOMMUDevice represents is identified by a unique DTE on
the host side IOMMU structures, so I am not arguing the naming is
incorrect, but since we also have many places in the code that act on the
guest DTE (e.g. amdvi_get_dte()), it would be better to avoid overloading
'dte' to avoid confusion.

If the above makes sense, then we should also use `typedef struct
AMDVIHIODKey` instead...

Thank you,
Alejandro


>  struct AMDVIState {
>      X86IOMMUState iommu;        /* IOMMU bus device             */
>      AMDVIPCIState *pci;         /* IOMMU PCI device             */
> @@ -416,6 +421,9 @@ struct AMDVIState {
>      /* IOTLB */
>      GHashTable *iotlb;
>  
> +    /* HostIOMMUDevice hash table*/
> +    GHashTable *hiod_hash;
> +
>      /* Interrupt remapping */
>      bool ga_enabled;
>      bool xtsup;


