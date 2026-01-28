Return-Path: <kvm+bounces-69310-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kNCzNptteWkHxAEAu9opvQ
	(envelope-from <kvm+bounces-69310-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 02:59:55 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D0A19C155
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 02:59:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 43E98301702C
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 01:59:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45378279DB1;
	Wed, 28 Jan 2026 01:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="oJnkgAuM";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="aO4HLypF"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB59454652
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 01:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769565587; cv=fail; b=KFhj563x2tM2kw53SwDetsKs6Ep5gEHofYnEPmmgcABB+jliJQKtZ9bI3dv+chJadbwQmNJQTjW/cRowCFSmz+3GEluCtcDda0eeOgmMtro9FiPRkNemcDtJivbV4XS0SokflrKarWObyKYG8GnO/FduvQFd7Q5JojXYYr7H8/o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769565587; c=relaxed/simple;
	bh=9eJlYQ4lCf4XyQQzgX0lBf9K+SIVEe8d1Xo46iaNCBY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=W7h7U0vOS8Yyw6QWr29+7eUD+MGgLS6FQPSQUDgfTogRZmjgo8IGvOO+KF3l1G7BEUwm88PR5AX3IN0ym2/BAy06IQUqzcsj1OJWLeMnNA7OkGuh6ZuVBSzzP4mt0ckRY3afw8MEYY2AKc8cNlVnO0YcW2rWFvbX1nA4EFEyt9o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=oJnkgAuM; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=aO4HLypF; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60RNEKn1354380;
	Wed, 28 Jan 2026 01:59:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=HMro+HzX4RYF8UV7rsMJyfPovO+JE7LXGPm2sNabhOo=; b=
	oJnkgAuMYnw0W05oROTXdnMWV2Odjsw+v/KSQdMiFFvBMMS52RpHgrRKqmIS4F6g
	6wE0/hmnwB00lSGUSdko0sKDwaAYqYo2jd93bObBqO5iTQBVj6dPUGsrbXjmQAwV
	T4kRqEakPRs5Kfe40pkxQ8LZonR+MGDHJF4s8FZs5tZwxaT74tQKb1irKOFUo9BC
	oU/oAbzMk8fVcjQoq3lgZWGY2+YZB3hQREyBmc4gwIzF8GtJr+zaF+aQlAj3B/Fv
	GWNlh6B/j5jlhYGYJUVna6lS1LxWDWzQPwxs+m+EnFCoJMjuNzc7rxZUFYjuV+Xh
	Wpc1Y2+k3y7Ac943pMlZPA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4by378gm1s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 Jan 2026 01:59:24 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60RNP3Xe010566;
	Wed, 28 Jan 2026 01:59:23 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010021.outbound.protection.outlook.com [52.101.46.21])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmha9m9d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 Jan 2026 01:59:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DIFNNLeZ6S5aHpMQ/GeA2X8IX8YGABIs4tjc7J9fjxr0hrkNQz1CoTGN39332in4+zvjlbtIOFIkzXE9J3A9KwRVvi8t/Iv2cQUr2v1qDrXtvej+OpVCZwXcys4nyW8tIMFm0HupRCH+v3LtxC01Brdc/AQSfWWv+sNjTkF3pfTChsyv+RYQdHFtGAg4MdOSdbc/bnY/zZswb4yIMCi8B45pVXidDVF4i1mYUt1jcWPVIjX9R6ScMs1+b40Csyt1YsfPcEtvaj66HhE8xFdmUP0sXJ363YwoVXkZSZhCdzeoXYVLcCKbAluDaymcqVu7E4HqBddSi52L9AWxr3Itgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HMro+HzX4RYF8UV7rsMJyfPovO+JE7LXGPm2sNabhOo=;
 b=mHUlUx+dlLMkYYDeFRff4e+OkpdU794hJyc/5Y7iKWVO3YORulQ4mut9NSgVGefk/1OjfOve1g/GZaYfsKrurcCbMR3O0uK1YjB+yuhSMBhABLJbd/l74cMFVq9NSG3zqSd7M0PoDQQaGxQ58W4jrvUtTX98fAoVE4hDYb92PZrJQb5dkjmx3fozHmyTpTqsUeS1F37EW1AJOs9qMTlTJW+vonJTHIm5e/bS697nOJASghrDOs4n3iTQn7PnUBYBP39eIIG/eoSWd6lgIwWQsDNgOgsFcjwFYZALXfWP9iN17+tDR1tHjfFbVHGEY0S2m1EIuL4JVdpikV6c+B8QnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HMro+HzX4RYF8UV7rsMJyfPovO+JE7LXGPm2sNabhOo=;
 b=aO4HLypF/nFzNK18yCkAkJ8c3MLWHwvyn6P0VImhgSHYy1LOLizswrGOILg5Mm5WZYNUTBiDOZ4nl6DeRPqYLU+Srydj4ZnUUSSOwbouaxXdyX73s/p0pdqjGW/W4MDaXi/W/ALJc4V003Ss56OYtbo/fZ1J1D9LaNXUy4uoYMo=
Received: from BLAPR10MB5041.namprd10.prod.outlook.com (2603:10b6:208:30e::6)
 by CH3PR10MB6884.namprd10.prod.outlook.com (2603:10b6:610:145::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Wed, 28 Jan
 2026 01:59:18 +0000
Received: from BLAPR10MB5041.namprd10.prod.outlook.com
 ([fe80::2c19:641c:14b9:b1b4]) by BLAPR10MB5041.namprd10.prod.outlook.com
 ([fe80::2c19:641c:14b9:b1b4%4]) with mapi id 15.20.9542.009; Wed, 28 Jan 2026
 01:59:18 +0000
Message-ID: <c22ec7f4-4f49-4c39-89cf-be20429bb387@oracle.com>
Date: Tue, 27 Jan 2026 20:59:13 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH RESEND 5/5] amd_iommu: Add support for upto 2048
 interrupts per IRT
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
 <20251118101532.4315-6-sarunkod@amd.com>
Content-Language: en-US
From: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
In-Reply-To: <20251118101532.4315-6-sarunkod@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH7PR17CA0051.namprd17.prod.outlook.com
 (2603:10b6:510:325::14) To BLAPR10MB5041.namprd10.prod.outlook.com
 (2603:10b6:208:30e::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5041:EE_|CH3PR10MB6884:EE_
X-MS-Office365-Filtering-Correlation-Id: 49546e65-2444-4933-e9e0-08de5e10d8c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OXIxU2VLVmpjMnJXWHVVV0hJbldDSVBkMnVROXhwZHdWMGRwYXBnSmNIYk9U?=
 =?utf-8?B?V25TMmlhNSswUFlWOWJ3MG81TzYvd3YrTlZCRGtvR0x1Wk5tVVBESGViamR0?=
 =?utf-8?B?WUtSUUQ1RjRmem5XY3BlaXEybHZkTm5GejVCS09GdzJQN1lQMW01di9Rc2hh?=
 =?utf-8?B?WjVwb0V3WWVxUUxzdDFVT2IrVGZSUGVHNHdtUHdNSUxMS0pKMEdDR2ZIbGZ4?=
 =?utf-8?B?ZHVWZkhzd2dWMUg0VSsrNkRadTVGNjRiQ2tGQkNpN0dPOUMzKzcvbTlXRWFm?=
 =?utf-8?B?SFFoK0p1bWxiWnNOdlJEejkwcWc5d290d0JETVJEUVVQYk15NGNYMkZIaGVt?=
 =?utf-8?B?Y2ZBQ253bld3V1JMR01Ca2JYbTAzMTRaL1FpWTcwVDIzVDNzL2cxc2hwV0tm?=
 =?utf-8?B?cFZjYmx3aHA1VFk3MU5xOWhNVXpiZHZTaWxOVHI1OHROSnhCblFCdHc3cC82?=
 =?utf-8?B?SDYwVXZNRnoraEg3aUg4SW5qejl1Q05YZ2xHWU1kTngzU0RGa1dPUytneFZa?=
 =?utf-8?B?K0c4OU9FMFF6dnFNU2JrK0VBNG9ydURoQzBpNE95TG9PQ2c4M1JDVUZ4cEw2?=
 =?utf-8?B?cGVFYXp2TThOd2ZWWlhiNk56Zkc3cFZ1T2dXT2hXcU5KcUhVYWJMdjlidlZr?=
 =?utf-8?B?dkJQd1AzeThVNXRjU0ZHQXNGYzEyVW16Q2tJWExEd2VnYjZCYU4rYzlVb21n?=
 =?utf-8?B?RjRsTzhmWWFXTjE4M2kzcGRrMmJzaGI5SHFNdVJMNkFaQnBpcjJVN21FNXdl?=
 =?utf-8?B?SXdjQnJyWlYzZHhUYmc1dkFUcElVUXBnZEFwRUYvTTF5NmJoY1VSMExhNUlV?=
 =?utf-8?B?dW1NRmsxbWVXVTdoSDM2RFpKT3VEVmxvdmlxM0FSU3puVm0wTmN6dFJlRExC?=
 =?utf-8?B?QnAxbGk5cFlQbCt2SFdJd2dkS2Fna3NlMmNlMUdNQmVPS2k0S1VnUDhDOFdk?=
 =?utf-8?B?dktJaW1iZ3A5MEZiS2phMXFOYzhjWWxLejYvdVdQTml4VWJIeFVkOHJPdUd4?=
 =?utf-8?B?TjlBVUlyRGpPMi9jNitPK2NZYlliT2x3ak92aEpySDhiL0dSNURYYTZlem85?=
 =?utf-8?B?c2xnV2s2Ky9jMTBCZk1uQ1hiMkF1aURlK3FGSkVhK0R2NlhaK1FMVndTQ2Qz?=
 =?utf-8?B?R1IvbjZXbmZKNXF6VFNQeHlsbURiM1BhUUZud2VaenpEYjRoYTIyaC9SS2Qr?=
 =?utf-8?B?OGwwN0EyUEFTQStudWNUbXhYVWFWcllsSDIwMFh6dUQwRm4wRUJXTkM3cVNI?=
 =?utf-8?B?WlhiRWVtbFdlOVJ0ZXI4RERZUWxBdzI3RkRvUkp4S0oxZGwrSzEzS1ZONEdT?=
 =?utf-8?B?U2RwVG5zeVIrSllsWkdXajh2STdrWjFjUmduaGFucnk5eS9NQXQwcit5U2x5?=
 =?utf-8?B?RE5vUmwwUDZpN2F4T2FFKy8vbGkrZWRJcjNuTU5zelVPb2cvM0tlcG4vc29U?=
 =?utf-8?B?QmZrcHBBSTVqbnZPWHhLOFh2ODFPL1FzTzY1czU5bitIalVQUWh6dzZENFFs?=
 =?utf-8?B?TndJNkNac3p0VkRxRlFuTDRva2wrVHJGdmhWTnZ4dWlBKy9tbitUNFJFd1Bj?=
 =?utf-8?B?MEs4Yzl6cmpyaGJTUFIzbjZvYTZYb1FoMjBXcDVvcmFDczVXWVUrbzZoOGMz?=
 =?utf-8?B?TmtYVHR1dXhCYVNvZ1owcVdKRlhVaTNoRlNXSVpXRkJKNXdkUmpXKy9Uei80?=
 =?utf-8?B?eUhxbFVhQ2cvUkNJMnI4NUFiWkVVWlRFeTN1cUpzdXRtWnhIWk1aL25SN3c5?=
 =?utf-8?B?WXdudkp5YThONWZTNG9XaXBVVEsrQitSVWVZdFpmaWlOY0xwdTJrWkZObEhi?=
 =?utf-8?B?UEFXMGswREFaTm9pN2xSY1dTdG5yYmx5cEpLOEp0Z2VBZXFiWVQzZWg4WENi?=
 =?utf-8?B?YUJmL1dGd2g1L1NZWGxMMHJSQks5aElJc0dUejNwWVRMdVIya2d2WWFBWnRZ?=
 =?utf-8?B?QkR2dlo5a2JVbW1rd2t2eUJMK3RrU3cyYUZvNy9jWVM0QjE1QnBvb084aStZ?=
 =?utf-8?B?Y090Q2JsMWtCUnVuRmlGMTc4RkRnN0hUTzNaSGg0cWFpWForZTJQM29YRUJS?=
 =?utf-8?B?eThtckZ4WUxoRzNGT2FFenpjK3FMWnVsU3dLcTNISytHNDNIazVzc1pEbHFr?=
 =?utf-8?Q?v7Yk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5041.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WE9Zc3F1ZVVscFZlbEM5c1ZUTzNhRkswMXJRRGZCR2ZVVmc5U2MrNFV1TEdR?=
 =?utf-8?B?MHU5RUNZL3NMT3E1RFlUWXllVWh3bFJ4eHVscWFYdTdRaEwyRU1FY2FDVGJ2?=
 =?utf-8?B?NEJ0b2pVVDZsSm1tbGRDWFNzMkM5WVZBdDNuNjhLcFpMaDlWUlZFYUhQclds?=
 =?utf-8?B?Z3RjY3M3cUQ1ZGNTUVU1SHdrWUhnbnlrTndrQ1AwcHNwTXZDS3JoVlZMVEVu?=
 =?utf-8?B?SkNQR3BCN1VqTVNwT1NUMnM3cllPWEZBQ0c0d3pqVFhCRk9ackV1eTFzN05P?=
 =?utf-8?B?VFd5Ung4M2UzbUhpd1drcWtUazVVK3NFV0VmSUV1bGV6dG9hSVVXTXNzTlF1?=
 =?utf-8?B?cytvRGZUKzRFTW0rNWJLU2tiZCtVZThHQW01QzlwKzZ6RWhFRy9sWVFQMUJl?=
 =?utf-8?B?Q0VJTy9vUW56TG8vcjB3YUV5Q0d3MENCNUNFN014UWtZZ3QvTGhlbko5TEl3?=
 =?utf-8?B?a1ZrREw4SlVCVmdXU1Q4cTFqUVlJQWtRc0hoR3lMaSsrN3I3WGVrVnJZTXhs?=
 =?utf-8?B?Mi8rclNpN2hmUmNoUGQrUDNUYWJvRTVySEhaakErQW5yMVMwRG94QkxpK3Nj?=
 =?utf-8?B?Y2s0MElpYk9qYjMwVUVNSGZSSWdmY2E0TURITytzWkY0b09vd1ZjU0lHNWsz?=
 =?utf-8?B?VWVJNjVySGprcWwyZndVU04xc2hFVGZYNW5UclZkNm9XMm9PYjJvQ24wTVZU?=
 =?utf-8?B?OFlGVWVBNnFYVnliUnBPbTFJOTkra0hkTEEya2tabFNCb2NKL0I1b2gzelhZ?=
 =?utf-8?B?ditjaE9xZUlIODJMUWw2MW9hZTJiTFlJVW5YV3ZMYXAxaCtGVEMzaFVlUXZJ?=
 =?utf-8?B?UmUzREVlc0FFbHY4aEttaHgxcGZMdFNBMjVWMFFrbThocjZpdXFJeTZxRnNo?=
 =?utf-8?B?QWt4ZTM1eGtXYTE4VUQvREh1ZHJrOHdKcHVOS0N2cWV5K29YMzhsNm5ubHVv?=
 =?utf-8?B?WkFLNks3c0VXWms4UU1DMTlyemtrOEtDazEwZ1EzUzBtc3BpMXd1NmtIM0JR?=
 =?utf-8?B?QjlvekhMS1ZlcTBUT1FpdytWV1NjVVltclZzOWFqYjNPMnhDQWE3U0wvRFgr?=
 =?utf-8?B?UnNyUVdxTkFQMmFyYkUyK0lpWEh1M0pZUnE3OFBlekZNOTVHclMvUXV6a3lp?=
 =?utf-8?B?UlJ4N3FvVmltdUIraWJRYWR0MWtHSzVBQ1VmVXF6NCtFeUpjYlhqS1pPZ1BF?=
 =?utf-8?B?ZEVOMk5BS2F6Yms1TkFBeDBQazUzQ2xpV251NWErUVF3d2l4ZTJ0d3BmTW93?=
 =?utf-8?B?Z0Z3emVWTk41UlNBQmF2cWV2NUdzQTJWZG9ETVNnYVVpUGFWbzVIaGVuRHgr?=
 =?utf-8?B?bEd6Wm82ZUxkOVQwby84blN5blNhN2hvOHJSYSt6RFhjcmdxU05VRDNTc01j?=
 =?utf-8?B?UzA2M0VhS1lDNmJGbXJmalErS2hLMXV5M0tsVGVuMmlSNlQ1MSt1MnVIQkxT?=
 =?utf-8?B?UmhmYVZkMC85SGsxMzhWZ1hQbW9IWjJ5amVnY1RBVnArNTdQS1FJQTg3Vktn?=
 =?utf-8?B?ZU5FMlpuRC9kSGl3NEw5dWtkNGhIZFZLL2JlcE9nTjNCa1RBaDNKbVJGU1pZ?=
 =?utf-8?B?TGNIZ1VPclBiSjdSTHJRR0VKMFdzNzgzaWc1eXpzUHQ3aFV6UHBRZUdEU213?=
 =?utf-8?B?MUtlcDVjZ2xHTXk3MWtuVjk2bG5EVTdSK3dSNzV4N0l4SjBMWTFjTmRzOWNP?=
 =?utf-8?B?N3JQRlpmcmk1SDJ2L3M5QkoybzJRbTJQVFZHQ0hIZjhmUEZHR0xxbW1IR1BR?=
 =?utf-8?B?ZWh1WW5MSm95M1FFR2MyTlIzUVhXOGRVWnluVlN1SzdDR29jZmpCMXVtaFZF?=
 =?utf-8?B?aFg3R0MraDdYN1lQTjBValZuZ0xTVkdYdDUrVytHemJyZnkxcWFKMjhXOUti?=
 =?utf-8?B?VkFKcWVId0hVWmhKblRrRC9tVVRmeTQyKzVDTGpCZ1pFYmN3clEyRlVkUW1k?=
 =?utf-8?B?S3FMYmtQQ2ZIV1N6Ly9nQmQ4S2hjOWYwdi9ndmZ6Y1N6SXdyKzBTbkJhcUUx?=
 =?utf-8?B?a1JUTkVIL05DRVRBMTlTbkFKajQ4b2VLRzFXWlNtZDd4MzlNeEtucUJLeVRs?=
 =?utf-8?B?NXNzeEdtUTRSR2VveFU2Q0NZQkE3MUFxTDk3RjdrN2tXYUZNZWVFQWZUQVI4?=
 =?utf-8?B?OW5zS3QrQ0VXcmlENEF4SnpGV2w0UVZWUFpESVUwRE5JbUc3amFQbzJlN1Fj?=
 =?utf-8?B?MWMxRC80KzUydDNWUzNrT0h0RHBPQlpXaW1MdHJ5U2tXb05mdmFqRlFHL2NW?=
 =?utf-8?B?WGlWcGdhK2ZINXYxRTZHclVWQlpyOXhBM3VpbHNMYkh5SFEza2FNajVMaEhs?=
 =?utf-8?B?UnRWQWkrdG1wdzFsU2todlc4WWtZRmdHYXhqV2FIK1grM2s3eUE0OHl6WUxl?=
 =?utf-8?Q?2/uUBkhDXzamdN7A=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	l98xYfHq8gLaWvaX+0c4HT2dksVvoZM+uZeaOzsXZAc9L9VnNwSxz1b+mv9G78MR7AVSL3YaQETRLVXdo322d4vCnfjT3Es3fB7F+SyeSHofZHbOmarYZOA7dqig/puSyi9tIHUJUuoO2GAyn+GP7OmfBt9B0csIkrjMWJ5mm2uBOCZnyd8+eHS3LLbQOCFPIuUId9hIrnhVjuP9GUqJP/weDyPVYFxfl1U9WW70LWsiBlcyCtpa5jEAQLhOquQzkfMhNj4xgz2sgYtAWBSAIFH/MDBeJa4BV2IkytqM9tnhUq1iUycDuJli1SqXt14CYi4Y2eYWGDppMIiMqkaAfz87AkHUHJBGBCoNX+x1LBZ8IFZlTFi4cQDIbewmIm8HtZz4BqQoMhdaIVHaMitsq2sfSUVbFG4/E33Jz18GIsCDUpnfut27b6l7CbT6CCDXYTpHxtIDfDVuUM/EgDMRk5+qzUlOHIrPA44A/ufl4qa7wjV0Bp/6vB98lxR9B6kuHIamszeI+SPxyNP726vNHMdmG/4Z+ORX39548nqxj16/0Fkr0Hph5xL/PEr5HhKCXEhAoRzv8/oV5nmtHypaNUBwAKxDAUpen+U5T7hAxmI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49546e65-2444-4933-e9e0-08de5e10d8c4
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5041.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 01:59:18.3423
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SMTc8FWVQmU/SJHjY8rrMNA2Kf8y2o1YyOqnDvk//guzl64fHuz5MNDdEUuf4bnwDvpInSPigIr4okTUfIYxUhEiyVvE1q8cMkXfpVBY1AA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6884
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-27_05,2026-01-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 mlxscore=0 spamscore=0 phishscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601280013
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI4MDAxMyBTYWx0ZWRfX4hLZcrNvWWsJ
 b+qg1V9mhbv4oGga4GsiE50YvzwbR7UDjbpGK51JAVrF4ZhPA/SroqdWy/TrLjb0kOhgT2T2oDV
 1dmwltWyNmunbtSpjc74z5VMdkPkSEvWsyuXhEoFtwRNdzUU5C7Hp7DEWB/cTX/k4Ytw5TMS42A
 U/+sGrt15G3MVMyu5YXTEk7YuQAfIetCNCtC7oYEdHE6VMgh8pCugSWwQ9AQ//swMHhhFAxQ6HQ
 rS97HXDrOKDlkAreTPh/skJa3eacxb+AFU4yEbFBGDo3Dl17N4Ax9RhLOPX2gPNOIy+Y2+Mg8xI
 eCXJZn6/eAYoR+0P55WSjMMB09bfWP7fNtJ60lZcf90hqNKghZrmgYb5+GPWObfOLhHLqEZC+08
 BIBdM3J5ZdYwXCZ/PZGyvCRxtfGBQQj1SvtBzxOXPxpgMFZKehX2KUBi++UhBbjrKMw28DeWdDa
 qhNfaHv133ZnTs0Hvdw==
X-Authority-Analysis: v=2.4 cv=a/o9NESF c=1 sm=1 tr=0 ts=69796d7c cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=zd2uoN0lAAAA:8 a=RLwbU2Mi6RIt0sSHZUoA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: m98saglDB44JFtCPdM0scoYhRyUR_slb
X-Proofpoint-ORIG-GUID: m98saglDB44JFtCPdM0scoYhRyUR_slb
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[oracle.com,reject];
	R_DKIM_ALLOW(-0.20)[oracle.com:s=corp-2025-04-25,oracle.onmicrosoft.com:s=selector2-oracle-onmicrosoft-com];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69310-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,oracle.onmicrosoft.com:dkim,oracle.com:mid,oracle.com:dkim,amd.com:email];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[redhat.com,gmail.com,linaro.org,habkost.net,intel.com,google.com,lists.linux.dev,8bytes.org];
	DKIM_TRACE(0.00)[oracle.com:+,oracle.onmicrosoft.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[alejandro.j.jimenez@oracle.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[9]
X-Rspamd-Queue-Id: 2D0A19C155
X-Rspamd-Action: no action



On 11/18/25 5:15 AM, Sairaj Kodilkar wrote:
> AMD IOMMU supports upto 2048 MSIs for a single device function
> when NUM_INT_REMAP_SUP Extended-Feature-Register-2 bit is set to one.
> Software can enable this feature by writing one to NUM_INT_REMAP_MODE
> in the control register. MSI address destination mode (DM) bit decides
> how many MSI data bits are used by IOMMU to index into IRT. When DM = 0,
> IOMMU uses bits 8:0 (max 512) for the index, otherwise (DM = 1)
> IOMMU uses bits 10:0 (max 2048) for IRT index.
> 
> This feature can be enabled with flag `numint2k=on`. In case of
> passhthrough devices viommu uses control register provided by vendor
> capabilites to determine if host IOMMU has enabled 2048 MSIs. If host
> IOMMU has not enabled it then the guest feature is disabled.
> 
> example command line
> '''
> -object iommufd,id=fd0 \
> -device amd_iommu,dma-remap=on,numint2k=on \
> -device vfio-host,host=<DEVID>,iommufd=fd0 \
> '''
> 
> NOTE: In case of legacy VFIO container the guest will always fall back
> to 512 MSIs.
> 
> Signed-off-by: Sairaj Kodilkar <sarunkod@amd.com>
> ---
>  hw/i386/amd_iommu.c | 74 ++++++++++++++++++++++++++++++++++++++++-----
>  hw/i386/amd_iommu.h | 12 ++++++++
>  2 files changed, 79 insertions(+), 7 deletions(-)
> 
> diff --git a/hw/i386/amd_iommu.c b/hw/i386/amd_iommu.c
> index 3221bf5a0303..4f62c4ee3671 100644
> --- a/hw/i386/amd_iommu.c
> +++ b/hw/i386/amd_iommu.c
> @@ -116,7 +116,12 @@ uint64_t amdvi_extended_feature_register(AMDVIState *s)
>  
>  uint64_t amdvi_extended_feature_register2(AMDVIState *s)
>  {
> -    return AMDVI_DEFAULT_EXT_FEATURES2;
> +    uint64_t feature = AMDVI_DEFAULT_EXT_FEATURES2;
> +    if (s->num_int_sup_2k) {
> +        feature |= AMDVI_FEATURE_NUM_INT_REMAP_SUP;
> +    }
> +
> +    return feature;
>  }
>  
>  /* configure MMIO registers at startup/reset */
> @@ -1538,6 +1543,9 @@ static void amdvi_handle_control_write(AMDVIState *s)
>                          AMDVI_MMIO_CONTROL_CMDBUFLEN);
>      s->ga_enabled = !!(control & AMDVI_MMIO_CONTROL_GAEN);
>  
> +    s->num_int_enabled = (control >> AMDVI_MMIO_CONTROL_NUM_INT_REMAP_SHIFT) &
> +                         AMDVI_MMIO_CONTROL_NUM_INT_REMAP_MASK;
> +
>      /* update the flags depending on the control register */
>      if (s->cmdbuf_enabled) {
>          amdvi_assign_orq(s, AMDVI_MMIO_STATUS, AMDVI_MMIO_STATUS_CMDBUF_RUN);
> @@ -2119,6 +2127,25 @@ static int amdvi_int_remap_msi(AMDVIState *iommu,
>       * (page 5)
>       */
>      delivery_mode = (origin->data >> MSI_DATA_DELIVERY_MODE_SHIFT) & 7;
> +    /*
> +     * The MSI address register bit[2] is used to get the destination
> +     * mode. The dest_mode 1 is valid for fixed and arbitrated interrupts
> +     * and when IOMMU supports upto 2048 interrupts.
> +     */
> +    dest_mode = (origin->address >> MSI_ADDR_DEST_MODE_SHIFT) & 1;
> +
> +    if (dest_mode &&
> +        iommu->num_int_enabled == AMDVI_MMIO_CONTROL_NUM_INT_REMAP_2K) {
> +
> +        trace_amdvi_ir_delivery_mode("2K interrupt mode");
> +        ret = __amdvi_int_remap_msi(iommu, origin, translated, dte, &irq, sid);
> +        if (ret < 0) {
> +            goto remap_fail;
> +        }
> +        /* Translate IRQ to MSI messages */
> +        x86_iommu_irq_to_msi_message(&irq, translated);
> +        goto out;
> +    }
>  
>      switch (delivery_mode) {
>      case AMDVI_IOAPIC_INT_TYPE_FIXED:
> @@ -2159,12 +2186,6 @@ static int amdvi_int_remap_msi(AMDVIState *iommu,
>          goto remap_fail;
>      }
>  
> -    /*
> -     * The MSI address register bit[2] is used to get the destination
> -     * mode. The dest_mode 1 is valid for fixed and arbitrated interrupts
> -     * only.
> -     */
> -    dest_mode = (origin->address >> MSI_ADDR_DEST_MODE_SHIFT) & 1;
>      if (dest_mode) {
>          trace_amdvi_ir_err("invalid dest_mode");
>          ret = -AMDVI_IR_ERR;
> @@ -2322,6 +2343,30 @@ static AddressSpace *amdvi_host_dma_iommu(PCIBus *bus, void *opaque, int devfn)
>      return &iommu_as[devfn]->as;
>  }
>  
> +static void amdvi_refresh_efrs_hwinfo(struct AMDVIState *s,
> +                                      struct iommu_hw_info_amd *hwinfo)
> +{
> +    /* Check if host OS has enabled 2K interrupts */
> +    bool hwinfo_ctrl_2k;
> +
> +    if (s->num_int_sup_2k && !hwinfo) {
> +        warn_report("AMDVI: Disabling 2048 MSI for guest, "
> +                    "use IOMMUFD for device passthrough to support it");
> +        s->num_int_sup_2k = 0;
> +    }
> +
> +    hwinfo_ctrl_2k = ((hwinfo->control_register

We need to check that hwinfo is a valid pointer before attempting to access
any of its fields. The code in the line above causes a segfault in the
common case where we are just using the default VFIO legacy backend and no
new options.
Even when trying to use the new feature (numint2k=on) and iommufd backend
in QEMU, if the host kernel was built with CONFIG_AMD_IOMMU_IOMMUFD=n
(which is currently the default), the ioctl IOMMU_GET_HW_INFO will always
return NULL data and hwinfo is also NULL at this point, so we crash and burn.

> +                       >> AMDVI_MMIO_CONTROL_NUM_INT_REMAP_SHIFT)
> +                      & AMDVI_MMIO_CONTROL_NUM_INT_REMAP_2K);
> +
> +    if (s->num_int_sup_2k && !hwinfo_ctrl_2k) {
> +        warn_report("AMDVI: Disabling 2048 MSIs for guest, "
> +                    "as host kernel does not support this feature");
> +        s->num_int_sup_2k = 0;
> +    }
> +
> +    amdvi_refresh_efrs(s);
> +}
>  
>  static bool amdvi_set_iommu_device(PCIBus *bus, void *opaque, int devfn,
>                                     HostIOMMUDevice *hiod, Error **errp)
> @@ -2354,6 +2399,20 @@ static bool amdvi_set_iommu_device(PCIBus *bus, void *opaque, int devfn,
>      object_ref(hiod);
>      g_hash_table_insert(s->hiod_hash, new_key, hiod);
>  
> +    if (hiod->caps.type == IOMMU_HW_INFO_TYPE_AMD) {
> +        /*
> +         * Refresh the MMIO efr registers so that changes are visible to the
> +         * guest.
> +         */
> +        amdvi_refresh_efrs_hwinfo(s, &hiod->caps.vendor_caps.amd);
> +    } else {
> +        /*
> +         * Pass NULL hardware registers when we have non-IOMMUFD
> +         * passthrough device
> +         */
> +        amdvi_refresh_efrs_hwinfo(s, NULL);

This call with hwinfo = NULL causes a segfault as I mentioned above. The
code in amdvi_refresh_efrs_hwinfo() needs to be hardened.

Thank you,
Alejandro

> +    }
> +
>      return true;
>  }
>  
> @@ -2641,6 +2700,7 @@ static const Property amdvi_properties[] = {
>      DEFINE_PROP_BOOL("xtsup", AMDVIState, xtsup, false),
>      DEFINE_PROP_STRING("pci-id", AMDVIState, pci_id),
>      DEFINE_PROP_BOOL("dma-remap", AMDVIState, dma_remap, false),
> +    DEFINE_PROP_BOOL("numint2k", AMDVIState, num_int_sup_2k, false),
>  };
>  
>  static const VMStateDescription vmstate_amdvi_sysbus = {
> diff --git a/hw/i386/amd_iommu.h b/hw/i386/amd_iommu.h
> index c8eaf229b50e..588725fe0c25 100644
> --- a/hw/i386/amd_iommu.h
> +++ b/hw/i386/amd_iommu.h
> @@ -107,6 +107,9 @@
>  #define AMDVI_MMIO_CONTROL_COMWAITINTEN   (1ULL << 4)
>  #define AMDVI_MMIO_CONTROL_CMDBUFLEN      (1ULL << 12)
>  #define AMDVI_MMIO_CONTROL_GAEN           (1ULL << 17)
> +#define AMDVI_MMIO_CONTROL_NUM_INT_REMAP_MASK        (0x3)
> +#define AMDVI_MMIO_CONTROL_NUM_INT_REMAP_SHIFT       (43)
> +#define AMDVI_MMIO_CONTROL_NUM_INT_REMAP_2K          (0x1)
>  
>  /* MMIO status register bits */
>  #define AMDVI_MMIO_STATUS_CMDBUF_RUN  (1 << 4)
> @@ -160,6 +163,7 @@
>  #define AMDVI_PERM_READ             (1 << 0)
>  #define AMDVI_PERM_WRITE            (1 << 1)
>  
> +/* EFR */
>  #define AMDVI_FEATURE_PREFETCH            (1ULL << 0) /* page prefetch       */
>  #define AMDVI_FEATURE_PPR                 (1ULL << 1) /* PPR Support         */
>  #define AMDVI_FEATURE_XT                  (1ULL << 2) /* x2APIC Support      */
> @@ -169,6 +173,9 @@
>  #define AMDVI_FEATURE_HE                  (1ULL << 8) /* hardware error regs */
>  #define AMDVI_FEATURE_PC                  (1ULL << 9) /* Perf counters       */
>  
> +/* EFR2 */
> +#define AMDVI_FEATURE_NUM_INT_REMAP_SUP   (1ULL << 8) /* 2K int support      */
> +
>  /* reserved DTE bits */
>  #define AMDVI_DTE_QUAD0_RESERVED        (GENMASK64(6, 2) | GENMASK64(63, 63))
>  #define AMDVI_DTE_QUAD1_RESERVED        0
> @@ -380,6 +387,8 @@ struct AMDVIState {
>      bool evtlog_enabled;         /* event log enabled            */
>      bool excl_enabled;
>  
> +    uint8_t num_int_enabled;
> +
>      hwaddr devtab;               /* base address device table    */
>      uint64_t devtab_len;         /* device table length          */
>  
> @@ -433,6 +442,9 @@ struct AMDVIState {
>  
>      /* DMA address translation */
>      bool dma_remap;
> +
> +    /* upto 2048 interrupt support */
> +    bool num_int_sup_2k;
>  };
>  
>  uint64_t amdvi_extended_feature_register(AMDVIState *s);


