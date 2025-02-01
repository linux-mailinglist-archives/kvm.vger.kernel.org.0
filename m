Return-Path: <kvm+bounces-37063-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D2869A2480B
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 10:57:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 956063A3761
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 09:57:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0C1C149C51;
	Sat,  1 Feb 2025 09:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kEZRrAI9";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="r5oopIkL"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D74F2145B26
	for <kvm@vger.kernel.org>; Sat,  1 Feb 2025 09:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738403847; cv=fail; b=Ch9BraE6eVbw16Hiq92/TDge6Q2i52RdfCoHCLRE72VCBjDLS+e6SyGyMeqwZYn6h+aRwnsdu+UlksDjVaBdc2EzUMt/vnEeM1RnlYSqsUED4CIQ3UD4uVcGFxqt0xC/HfiXR2xO2WBfdVEP2p/b31wevNux89gIugwVYw5oZbs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738403847; c=relaxed/simple;
	bh=4Znyl6GVihOB+p58YRH/EMDMz1TjMLI/YXqTsNKxBOc=;
	h=Message-ID:Date:From:Subject:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Hb2ZN4o7OFoc7Us09KWB/CpizNq27DYejEOcJmzVXQcmcWV1UviWYcGWgWFi27JEPuwp4GhIUJjUb8BFYdT3BTnV/lQXCxm89jiQSubreqcyWjhbVI5OBghn+yi6bpfEOb/V8C01wLEjlBVO+JyA0ARlV46bsKGQO9oIOkvAtGY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kEZRrAI9; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=r5oopIkL; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5117bAK4013219;
	Sat, 1 Feb 2025 09:57:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=UJkOSEwpjh214ucInXcWwg9rUAvMXMXFZc5IbDSViDY=; b=
	kEZRrAI9gYr3mXU3xq/Q5D8Ywv7HG+O9QTTXLxygIoL1XGW4T644TTsK748kZPUT
	pIX9kGzArJlKUp8qNX7vkMVz2a3Wp6fLNfpIbnpWu+Re78ny5/K6wTPcb/Mal6/q
	Eq3yshZ9ybwWXTtfHMkgWGY3uVtlfrmsWXYeemrqrUUExjfHqc/brlo8KDT9GyRi
	9tGXxUDjl8DNvi4hy0r2T9YAXhdkXpEP6CW1U2ZJzdKbqXioUPNeyiNdGDmZ6yaW
	KtxyQNwtEj+xrzOBXqtpTYkBP4cR9lBKy9Dz5L74z5/NRmi9Fk+oUAToNhG3J3m1
	vv4YvsaEH+f8G1geyplA6g==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44hfcgr3b5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 01 Feb 2025 09:57:08 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51184pqm033184;
	Sat, 1 Feb 2025 09:57:07 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2047.outbound.protection.outlook.com [104.47.55.47])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44ha2byd5k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 01 Feb 2025 09:57:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Hg9TXCcwRKMIXJlSRTEONMb0JiLnR1XhHjsvgQk7r4LAQ4etRh/OomjRF2gqEAGuglb8g2ralDHZt7AhUNGkWGfNe39KPchdZfOwb/bYTYPu7IbdmTtbzOtJsEzS+5KSsY7i03RU+xcPVigQDfMqLzynp+7TgoIGdUFOOblLTuoFYmBCTxQ4Pk1EBOreaneTNdAn8PRFOueaGE150lf2vueBfvPn/vz20EU/tK6FR0C/Q4YMFwPUGHzWu5aGzmXsRsX8ox+81lCQZdfR/i21o09+vw6lxX7vn0zbqJb5Pk7YV4tBenZU8kTvWk9sP0bv6E4U7aC3TDV9t/2Mn3SCdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UJkOSEwpjh214ucInXcWwg9rUAvMXMXFZc5IbDSViDY=;
 b=pL+pqegQ+puJuqe3xuD7/hvubHTdcLYxL9LBOvqODheYqz0FxdnL2LYdllbWhN8PwMDrRBUriibL+gwdchg9wPYWwmCZ3O+osVuIHsiM05f3nGiHBMAkB6vp3Rx3JTFfcRkWWGpgoLGEFd+7kYFs7gkfyXui7Yzm5eFXVHPcAjUOsSytEOz5Vi7M69sj4h0OOfwYuLDIhJMV730isIP4s3m8Nn8y1WGxLIz1wvu7Mg6Di7var5zOI0hx3YeO6yKs8ToqW7bIAshn0IVHRENJT34D7pPDwR//GXWUGYNKbK68nnPuPef1LtHFvCs8q/ET4DCboatt0Scfeu1OzwHLoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UJkOSEwpjh214ucInXcWwg9rUAvMXMXFZc5IbDSViDY=;
 b=r5oopIkLYt7uRsXjV/oEAPlikgtxxJfZllIKDd5kAbkr+7NxtbzNpBwB4sdAYjcMAWpT6/sGsRqFUoOf4vpUTfoU1BIZw2Cxd+nA9GoyHKvkI54eg0u+8xhpg6jm6fpHegXu7MJGTOrMWfTFE82T5CwSL7EF+8noAaRwbdPCXNA=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CO1PR10MB4418.namprd10.prod.outlook.com (2603:10b6:303:94::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.22; Sat, 1 Feb
 2025 09:57:04 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%6]) with mapi id 15.20.8398.018; Sat, 1 Feb 2025
 09:57:04 +0000
Message-ID: <a502af77-6f7e-4ec4-96fc-ed5f6edfbe1c@oracle.com>
Date: Sat, 1 Feb 2025 10:57:00 +0100
User-Agent: Mozilla Thunderbird
From: William Roche <william.roche@oracle.com>
Subject: Re: [PATCH v6 3/6] accel/kvm: Report the loss of a large memory page
To: David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: peterx@redhat.com, pbonzini@redhat.com, richard.henderson@linaro.org,
        philmd@linaro.org, peter.maydell@linaro.org, mtosatti@redhat.com,
        imammedo@redhat.com, eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
References: <20250127213107.3454680-1-william.roche@oracle.com>
 <20250127213107.3454680-4-william.roche@oracle.com>
 <ca2c2d71-e4c0-4ed2-afc0-04f21df1f82d@redhat.com>
Content-Language: en-US, fr
In-Reply-To: <ca2c2d71-e4c0-4ed2-afc0-04f21df1f82d@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P265CA0168.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:312::11) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CO1PR10MB4418:EE_
X-MS-Office365-Filtering-Correlation-Id: d860b213-7f0c-437f-8d00-08dd42a6c7f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?S2pnZTNlcnJGc0txYWViU0taRDQzVGhvYkYweWRicU1EclYzTDV0WE9JdENK?=
 =?utf-8?B?T0g1SUxFd1hnRDhLNWdtc0RyV0ZYVEpQVFcyTDhxeUIwQjY5bDBwbVB0UHRx?=
 =?utf-8?B?bkdUelFQbUVvOGZDUmlxVUhQOEgzQm90a3VNOWx3V3ZlbklpVkllZzlnekxm?=
 =?utf-8?B?TjN2emhpY0VJRzl5NUxsWUJCb0hWSnJmb0c2VE9oeHZqWVBqN0tEY1oyQ1Z5?=
 =?utf-8?B?WWRabStqWVI3V3F0WklEaitSQ3Z4a2NJaUk1MnVhdnBOSFBTcUcyOXFIVmFZ?=
 =?utf-8?B?Q2xYdk0yTU5IeDBNcDZTcVhMVlVTSEhMZWZjTXpvUUJYSEhJelpUdjZIWk5v?=
 =?utf-8?B?MEJ3SEpyNnhtWFlSZm1qeWZrcVA3bGJuUkxDQzlDTmErZ0RQUzdKcENxZ3Rn?=
 =?utf-8?B?cFQrbXlOZ0I4SXRIdUFzc3hsYjZ4RzQyVFNPZ3FlQytsQTlXZlRwUXBUeXph?=
 =?utf-8?B?QWVDdG5TbVdta3BXNTF6QURKZ3pQQk50YUEvM3REVHJhaHRoMzB6WnZNSkc5?=
 =?utf-8?B?Z1hlRmdvT3R0Mnlpc0hKSkl3U0VJVUJ6WmNtRjQ0bC9UMjNBem1WRHhNMmM4?=
 =?utf-8?B?ditTSWxyUXVkWW1oanhXbzB2YzNmSEc2SE5Uems2MVQ3RDAxUzdTWHlVZCtt?=
 =?utf-8?B?T2FlT0QxV1R3RUYzb1U1YU5URjBTZmJoVkczZFpRY1IzdENOek1kYzhqZUIr?=
 =?utf-8?B?TnFhaXRGVmVJNTQ3MTAzYlVMT3RLYVV1NkJ3dEc5dklhUklnemdGQnZ5aUFL?=
 =?utf-8?B?MThvQ0ZSS2Z4bDgvbEhaUGpjdktDR1FmZnFlNDBxdEFCS0lrbnlYNC9sYnJS?=
 =?utf-8?B?T1EvL2gxM2ZNd0xRSEFTSFdkK3F5M2YwQ0xad1huc0VFM0U3SW10R2JQTitn?=
 =?utf-8?B?cGhKdS8xMTZGamxNcDZBR1RKTUJoSlA1ODVmdklsZ01jSXk5YjdsY1d1VUhJ?=
 =?utf-8?B?N0dpL3NCRU4zaWpjWkIvNCs0azgxYmdGNnI1Z1QrYWdieXZjb1BibHlScmpq?=
 =?utf-8?B?VlJ0RTRkVmY1eUJwamk2K3E4OENRcklpYlJydEUrZWYwbVVtaC90S0o5TU8v?=
 =?utf-8?B?bDh1N0c4UDFMN2lpbFc5eHA3d2hHaU15Z3FQMmkvckN3cWJpbGtTNEZJclRJ?=
 =?utf-8?B?SG9BQ2lKQTcrKzQ3VlhkRGtYWm8xWTBZbzZsSmJNa3ZJWE9uUTRWc0pzR3Z5?=
 =?utf-8?B?U2UxdFFwN3NncjJIS2ZZMUhITEJHOTlacEtYTzVESGlrMnJMZVNlWHB0c1hD?=
 =?utf-8?B?Z2lhcktaM0dsRk5oQmFhK3BEU2Q0blZnNkY1WCthVGNZQVlJa3JQWjJSZ3o2?=
 =?utf-8?B?bUk5LzZYU0ViRElKUERoT3Jwc2thY3g3TUR5N05VM255czdjT08wcDRIYUJX?=
 =?utf-8?B?V096amgvVnRTSVhDWlNWODZJQVZibTdicFREdmNFMHFKVTF2azZzWVp6VVNM?=
 =?utf-8?B?Yk9mMWd0a2MxaC9zTkxoQ05WUzhFNmxyMFN5M0xRemNsNXhvRTduQk50dG9p?=
 =?utf-8?B?MjVNWWxIM3lDOUJ6RVd2Vm9SMXAwWWd6VG1rcVBSejVLWGpxeGdKazJSSG5z?=
 =?utf-8?B?QVFDRG5JUTFCOHl5YklFdFhmbWdxbVBEMmY1MC9ydldNRFlsMW8zeTdMcHZh?=
 =?utf-8?B?VkMzV3hDMVRJOFhnSnBYYjhaL2NIMVNCb28yWVJuMFdKd0U2MlZUaUV1YUtD?=
 =?utf-8?B?TGQ5ZjRRNmQwQllWdldKbEpvanNQYnp4VEFGMzBQR25aVGJuMTFoWWlEWlNI?=
 =?utf-8?B?cS92NVF2KzZqTHI2Zi9aeWhnZzVRa3huOVM2ZlBTUHVVNDVNdDRoWVk3Z2g3?=
 =?utf-8?B?MWJtdnNrRnQ1eUlFRkgyY29XWDcwclQzc2pPYkI1dUxnekJlakgrbElkdWI1?=
 =?utf-8?Q?BGjwwQXVxvwPf?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ZE9Hc25Pa2paZ21qc2sybGVaVTFLVGoza3A5azdHVTcwRFVwQlJudzM4YWdj?=
 =?utf-8?B?VWFKK2habi9Ed2NtZzVXWTBVZkU1dDVsK0ZqZk8rWjBVSEF6UVdGMEtmek85?=
 =?utf-8?B?UFBuaVY5L1ROOVJhTjRFNVJoaDhmay9RYkh2MzNUaTJwMWlOZ0hvczhXOHNq?=
 =?utf-8?B?elkzNE1Nb1FHTzVyekJibmYrNEV4Y1hwakh3cW1UN05OOU5TRlZveUxvaWph?=
 =?utf-8?B?VHlpS05jeTR2NWJwNG51TjRwQ3BPcUllcUJUc0dkaEZsTHNkK0poOHdQVVdl?=
 =?utf-8?B?MGtWb3U4OGRpV3U1cHAxMEhJd2J2SFo5bGN3cUdJS0d3aXBnWnBnWVF1YWxR?=
 =?utf-8?B?cVk1NVlFUmJEUlBlZFpBc1lEMEZBSW9pVzlIOXlQZ0g3NGM0MHR5b1dBSko3?=
 =?utf-8?B?SHVNdXdsZ2Nwc2gvVU12TndpVWtvc2ZkaHlFWVdoKzFFZWdHamRmM0J0TDVC?=
 =?utf-8?B?OFNuVWYyYjRJR2R4eXJScWlkZ1d5cjdna0RLT1c5VThzb3E2dm40OG9Jbk5K?=
 =?utf-8?B?Z2RkN1lWTkorR28vZlNxUUJRMXNCTktXc1R2SUJmSkp5alBWY1ZWMDZIbFBD?=
 =?utf-8?B?T1J5QmtCRk10Wi9QekU5eVF3RmwwTlFnb1ZVTzFZbzVCdkZoY2lGVE8yWDVJ?=
 =?utf-8?B?LzVIcVpxR1lqamY3ZThTcXFncDVYVWpDSzZ2TTRUblBtUTFSVDRqOGxncVgv?=
 =?utf-8?B?dk5ZbjBYSkptOE8yZkF4UlJ4T1oxWFFGSUd6bWVWQ0tXR2JTZmFvaFlUZ0pX?=
 =?utf-8?B?WEJublRDQi95a2VwWVgzUnpWQkJPN0E4TzkxWEpRZTI4K0M2U0ZlVTBDZFJG?=
 =?utf-8?B?TkNYS0hNQ3VHYVdnWU1DdEorNk5jelM4T3h0WWkvak9Zajh5cUwyTTQxRTlM?=
 =?utf-8?B?ZytEblRsOFpzN0RVbWY3djd5bGp6VWMybWJsNVp4TUlZUCt0UCtVemVJSGMz?=
 =?utf-8?B?bitkS1pBaTZRcEFIVUp5aUpsdi96bFkyaFRDMU5hb3pmNlFnTVlOYnJRdldI?=
 =?utf-8?B?aHRXM09qSUY0akwxcFRXTnZzUGhBSGZRSS9FbFlsNzB2Lyt0VzBWajY5aXdv?=
 =?utf-8?B?MmNzTzhpRnlyM2twWEhhQWVIUGRISnloLzFUYThKeDYwcFZxUzBQNE5SK1JE?=
 =?utf-8?B?VW96ZllRZ0x4cFh3cjQ3a3JFWlBraDU2RFd3UHFsbU95UDdPeUFIdmtGOGdP?=
 =?utf-8?B?SURldnJPdzJPNHBRcFFFRElGdTVqZGtSMXMrWFVSeXZEQ0R1L2p4aGdDd3NH?=
 =?utf-8?B?YlBBd2JJNnh4bHNZdCtDdVdDMDB1U3RQRDlSZEh2SHFOSk9WK3ljMVRaTENm?=
 =?utf-8?B?bHZYQTZlOGovZThwWllnVjYwRGx4aklXVW5sekhlMEZCVmt4R00yaW1QMVNT?=
 =?utf-8?B?eWJtNDh5M0lpYkNzdTV2VDliR2w0SDV2UFZZUjF4dmpRMVVvTUppYWptZEh1?=
 =?utf-8?B?WXcvMnRDZWdoYzNoTWZkeWdrNmRuUXMzdGQ2Ni9lZ0dJTmJRQkQ0d0wzZ01P?=
 =?utf-8?B?RTMybTdRZ1hodGxXcGEyV1JveGZOZE40RlVtOHlxMlJTWDNqRExnYy8rV20r?=
 =?utf-8?B?YXB1RHFMK1c1YkhycXpTcURuQjRoL0RuNjVsUEFoaEtWTGRXUXhRN2Z4clpU?=
 =?utf-8?B?d1RIS08vSUo2M0RaV2ZrR3Q3NW0xSXFaS3h4WDF4RmhJcDZuL3h0WFc1Q2ZT?=
 =?utf-8?B?ZEUvMVVKdmQxbVI3cURpSUU3dVdQM1VSN1k5OU04c25NWHN6cDlwWXp2VVVy?=
 =?utf-8?B?K3YxZXlXSDBneGhFMWEwMDE0UjFTYjZLYmdaNTI1b0JvTW80NFVjNzBrNWky?=
 =?utf-8?B?dTkrU0R6RzR4NnZIT1RvdXlnRENhMmpoeGFpQ3BHVWpTeFpsQmowUDlCRG5l?=
 =?utf-8?B?TTFBYWViUmEwb09tOTQ5VWtwR1p6ZElxa2ZMbTR2SmxDMXBvWkpmMmlHL2xN?=
 =?utf-8?B?UWc4QzJ3VlVRLysyTFExSllUUlJ2VTJENVVsTVNUaUJxcHFEMFc5RlZtbEw4?=
 =?utf-8?B?cEJHTW5VRVovV2x5c2hRM2ZCLytxVTRETVBHZFVLbjBtQVg4TE1vdk9rNWZN?=
 =?utf-8?B?dldIV1FLa3JqOTVmQXZJWU51VDY1TXdLYXpSRU9SNlhhTTdGY3JmTHIzMzVN?=
 =?utf-8?B?cEV3ek9jT1p1NlIzOFR0NTNHQlNGNEZ0VzE3SGp0L0ladGd1c3ZCY243SFUv?=
 =?utf-8?B?enc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	zaZmEHXOU8cMBN5uia1CbgvXdmK3CtgOxAcm/qYx/Z0ilAbMlrJTXkEEfZHqQyNjfFwT8olD38rmMPEj5JpzXe/ho9Wovf4nIS7/syMutG70BH/izK7cWfcxk+aRRjYOZkkfujETWQX7FFJGvwjsRF/MPiDXg2mxqLhKF8PTWwSB4zj4RBBFa+5fNOo+8xts7V13g0qZYlwZ/ahKp6+fNfmdI/hB1weSvCcPuKezL8GuwL1+NorYOij9avNCCn1rEEUtd9ywXyLZQd+o4HSlU3beBhjEHVveC0Qr4PRG+TDx4g4BMlnjc/Dj3OY+ktAev/7RGf3qdnR4qhgAX6RgoYTe/98Ra5+T+qpqRuOg0G/cZFFgEPdjo8s3sxDHp0JSba+3RRgW+CVMOkuu1xxWnT3gDCo155OwKRjUYmcnXzbBtRDtLUwRm9ycmX8D9AdIgMcOCB8FLgF+oFKcOOW+dqYKQFhZ/AH8SL2Jcf5uBQU6vjFz/XaxN3836lvNs9EZpHh4ixLiK/ASbBip1pcMa/+7Bm69HFBkYRuxhwqYySnh/zj7nRfobsN7/tTlqEzlTL4D4XD1vNEaPt7bp7WvZlgkDRn+qAtnlXElgP2bqUQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d860b213-7f0c-437f-8d00-08dd42a6c7f1
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2025 09:57:04.4729
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ScfVgWVhDugDKnwtp8VKPUjHrVOWQGHDaWEO5Y9JIKkzhF2KRqBoN/mnApmpqZXID7tiJTBQiMJ8+o9gGCE1ZgNB5gzCxC7vxcmCjd2stis=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4418
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-01_04,2025-01-31_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2501170000
 definitions=main-2502010085
X-Proofpoint-GUID: xu18PdUfnltZ4ljJfh48Zo60AbbOi9Av
X-Proofpoint-ORIG-GUID: xu18PdUfnltZ4ljJfh48Zo60AbbOi9Av

On 1/30/25 18:02, David Hildenbrand wrote:
> On 27.01.25 22:31, “William Roche wrote:
>> From: William Roche <william.roche@oracle.com>
>>
>> In case of a large page impacted by a memory error, provide an
>> information about the impacted large page before the memory
>> error injection message.
>>
>> This message would also appear on ras enabled ARM platforms, with
>> the introduction of an x86 similar error injection message.
>>
>> In the case of a large page impacted, we now report:
>> Memory Error on large page from <backend>:<address>+<fd_offset> 
>> +<page_size>
>>
>> Signed-off-by: William Roche <william.roche@oracle.com>
>> ---
>>   accel/kvm/kvm-all.c       | 11 +++++++++++
>>   include/exec/cpu-common.h |  9 +++++++++
>>   system/physmem.c          | 21 +++++++++++++++++++++
>>   target/arm/kvm.c          |  3 +++
>>   4 files changed, 44 insertions(+)
>>
>> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
>> index f89568bfa3..08e14f8960 100644
>> --- a/accel/kvm/kvm-all.c
>> +++ b/accel/kvm/kvm-all.c
>> @@ -1296,6 +1296,17 @@ static void kvm_unpoison_all(void *param)
>>   void kvm_hwpoison_page_add(ram_addr_t ram_addr)
>>   {
>>       HWPoisonPage *page;
>> +    struct RAMBlockInfo rb_info;
>> +
>> +    if (qemu_ram_block_location_info_from_addr(ram_addr, &rb_info)) {
>> +        size_t ps = rb_info.page_size;
>> +        if (ps > TARGET_PAGE_SIZE) {
>> +            uint64_t offset = ram_addr - rb_info.offset;
>> +            error_report("Memory Error on large page from %s:%" PRIx64
>> +                         "+%" PRIx64 " +%zx", rb_info.idstr,
>> +                         QEMU_ALIGN_DOWN(offset, ps), 
>> rb_info.fd_offset, ps);
>> +        }
>> +    }
> 
> Some smaller nits:
> 
> 1) I'd call it qemu_ram_block_info_from_addr() --  drop the "_location"
> 
> 2) Printing the fd_offset only makes sense if there is an fd, right? 
> You'd have to communicate that information as well.
> 
> 
> 
> Apart from that, this series LGTM, thanks!


Thank you David for your feedback.

I'll change the 2 nits above, and add the 2 empty lines missing (in 
patch 3/6).
I also removed the fd_offset information in the message from the 
qemu_ram_remap() function when we don't have an associated fd (patch 2/6).

You also asked me:

> Don't you have to align the fd_offset also down?
> 

fd_offset doesn't need to be aligned as it is used with the value given, 
which should already be adapted to the backend needs (when given by the 
administrator for example)


> I suggest doing the alignment already when calculating "uint64_t offset"
> 

But yes for the offset value itself, it's much better to already align 
it when giving it an initial value. Thanks, I've also made the change.

I'm sending a v7 now including all these changes.

I'll also send an update about the kdump behavior on ARM later next week.

Thanks again,
William.


