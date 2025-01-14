Return-Path: <kvm+bounces-35399-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 26851A10D3A
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 18:13:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2A957188B55A
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 17:13:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B97961D63F8;
	Tue, 14 Jan 2025 17:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OScBZD7e";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="GpAwZBvf"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E9C1D5150;
	Tue, 14 Jan 2025 17:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736874816; cv=fail; b=Sf5fAggaYaLKEYglvReua/iMcdvawhmb24HEidMdC8gDKTIQemS6JL5qaFHz2LB/R3sKjY72syNDbTb/xB1JpfH6wHCmPeJc00rx6t9Vmy/9EC7hy7YNvY6KEK9/8SDDhRO54iCSbIcwBbG9qCsIxrXmgGyWndphavDVghWtq5M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736874816; c=relaxed/simple;
	bh=p7T/iwEwg17hiJp+irJtT+UtXUmitwz7wwUu+P8EmNE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=P7T/VvHvPbZvtS/S+3IxrFqIlL/HQGPdf6nYjeU1lEmHhULmyxAymgACDAGorjUwDdJb8SmbgzH8vcmAc5VQ7E5aALCHvsBsX2J/f6vhEHAZ46QPZRZlwJTgo+6wgtrH5JfsBXDmjZ4MJcZ8Ooo2uV5ULreg/MKIt3Vjptwe6qQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=OScBZD7e; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=GpAwZBvf; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50EC0otM017872;
	Tue, 14 Jan 2025 17:13:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=ugSdku5ocFzUkAqdipoQLvNvPKCyLbPVFhyzfIVoxps=; b=
	OScBZD7e/HBT1U6ODhGdoqeHtLCA93JPSZQqvfKPw513ccVlpX0Z2kPhaAuFQHRE
	nx5VejkrRCxX6VCZm+R4iW+zFCUE0GiKzN9eznmtHEf+hUt8FgJFxuNR0pti3hF9
	vmnNyp/6R1ADIQ0VzAEYefnFKtrZctpUF7hEBLhyMZqfU+5ZNWDVkAUWLP53AbET
	LpiQTpLnNp3OBdnzzYmlkEVkB0lcn6d8/XOCvKDA7VsL/7YIOdTqhAqGsyfOYohd
	oporaYQqeULoM5nisgnYB8UnfEbeTzjwlDda4Ng5gxwg0xQF7PO/0A73Dv2rYvv8
	O7EhATuHu9ehQTOZ+nW2Iw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 443f7y66cm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Jan 2025 17:13:29 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50EG5u7B034784;
	Tue, 14 Jan 2025 17:13:29 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 443f38dbhd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Jan 2025 17:13:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T1ma4si3tebUGbSurJaXeiFfe7HOy6qg5hEAGx+/mqjVHOWCdrNmvUkN7BBoO/uVzAzCl/1TwXjNForVlhgBLXiI10dsRT/fiBnCmkmSUki3LUnFE7oSctKOrCwGzjWZiOQM1J152S42IoRJyv9FQKv9+kGUdQr26Sse+44HH2KIZ0u9IidvTKvrPRJIu82hn4HRjBHirxB3d8pXjVg92Db2rKh6/rt48WmToCM0ZZ4eXigPmd4ht5HnfEbE4Y2ER7RPuMr6iOLrEYN51EClcFJncxjpcYMmhWCrBvWlVMtX3Xw9tx/O+BrDvc7QPGV8sXRABmmAFPT8znMbpwC2Fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ugSdku5ocFzUkAqdipoQLvNvPKCyLbPVFhyzfIVoxps=;
 b=CM1Il0hsoe05n9lsq1O/LHxoa0xaNjcOdgvqCpFrXlIgtJ1AW0wDE28SBrpvobjKDHWJPQH9gMBnsRH91O70xMFPRyb0UeWPuLGwGSi6k8+LcpYYug+ePXNP5tdxm+aGyEMkp8rc5VjhG+8m17S/0n1/s/0atD6402Pm98Iwq22NuLFPhm/14TmgZvyde5Wer2IGSJ38vutOyoq8pLAX6PIfJyYT6OZJKCX+4rvmaEf2F+p3ccV34VgvpRz73deHY7p4QUyqE9O0FYwTLpRWpY6NIytDuNcNk9a42Af/DBQ0XJRF4+4YqMiw5h8K+xir07iKnmK5ppPpy6FBJM/xxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ugSdku5ocFzUkAqdipoQLvNvPKCyLbPVFhyzfIVoxps=;
 b=GpAwZBvf5WLmNe1IJL5fsdwS3qWdjQiIROOZuvESuduYG2Ctvz6EIyoAHsItiZS1ddbXjylnsHkhsHgEtE/KId6HI6UG4aDvSR4T6SLHTOWwmiTTesVk699x4AOUxFpOzup/CjeYxz4gNoai0FdCtMtSqlkCSVENvjgv1bbLpkM=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by IA0PR10MB7253.namprd10.prod.outlook.com (2603:10b6:208:3de::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.17; Tue, 14 Jan
 2025 17:13:27 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%3]) with mapi id 15.20.8335.017; Tue, 14 Jan 2025
 17:13:27 +0000
Message-ID: <a1789103-6f6c-4195-9715-d4e6ef8c0e6f@oracle.com>
Date: Tue, 14 Jan 2025 11:13:25 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vhost/scsi: Fix improper cleanup in
 vhost_scsi_set_endpoint()
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Haoran Zhang <wh1sper@zju.edu.cn>, jasowang@redhat.com,
        pbonzini@redhat.com, stefanha@redhat.com, eperezma@redhat.com,
        virtualization@lists.linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20250111033454.26596-1-wh1sper@zju.edu.cn>
 <bae5ca72-c6ff-4412-a317-4649f2d09cdf@oracle.com>
 <481cd60a-d633-4251-bb53-d3026e005930@oracle.com>
 <20250114062550-mutt-send-email-mst@kernel.org>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20250114062550-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR01CA0011.prod.exchangelabs.com (2603:10b6:5:296::16)
 To CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|IA0PR10MB7253:EE_
X-MS-Office365-Filtering-Correlation-Id: 79af3c0a-2adf-419a-7654-08dd34bec27a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NmlnbFR5Y2RySkNYVU9DWmU4RWYvZWxHeVEyZkp5Rk1ZajUxRitDVWE2d084?=
 =?utf-8?B?bXpCUkpSLzB0VHZaWVZDMFBGMXgxU2NXcGFKMjRjeWFrL0F0YS9ueFhxYU5w?=
 =?utf-8?B?dW05Zmo2RE1Ud01EQWNMMVpnV2E5SG9tR1l6WE56Tk91QlRsSmI0ZkhzeDRK?=
 =?utf-8?B?aUwvZWdiYkhvNVRWV2xsSlJpUGhGQkFnMjMyYUxwUVFkQjdUczVEaDZ3QW8r?=
 =?utf-8?B?YTk3SCtTSUQxUHhQbWliSjlSQldLNkRGSW55dG9BOVV6c1ZiL0ZodXdmd1BP?=
 =?utf-8?B?KzluSHZPd3Mrb2pJUnVYMXFiM2lXWTdJZ04zb2N6bVdEaFhteERRZVpPR3Jh?=
 =?utf-8?B?dmRxSXlESXdTWWNXa3Vsc0tFVnVFaU5wdldkdVhnMkx3MnZGN2k0UlVmT24v?=
 =?utf-8?B?MW4yQTBucjBBNGMxNWdoUHB1a1UzU3AwTCtYVnJVUWNMWGd5dm1rYzR0Qm1N?=
 =?utf-8?B?UGFrNERJdFJ6Qm41eHZGS0tmR0llUml1bDRvVU1WTkZJTlZQYTRZZ01KeDFa?=
 =?utf-8?B?eTV5Mk9hallwNVBtWnRiZmlNK2dkMVVWVktGSXJQbHl0YStzcXlqM05MSmZk?=
 =?utf-8?B?V0hXN1NtM245S2dGMEI0cmxXNWE1R20veXo3UlkxeWMvZDlOc2NEbWxwL1VW?=
 =?utf-8?B?YUg1MlBrYXRCR3czTU13cHJYTHluamVZSHRQOGVjbTNuck8yQzJwZzhtSlo0?=
 =?utf-8?B?aWVFZDZsck13emFSZ1BCN3phQ0JCTXd2dFgxNWowUDVMVTFrcytCY0VpT1RB?=
 =?utf-8?B?QzRUd3ZZenduTjltZ3RlMkJ5OXpYY0xDRCsvdDVZRy9SWVBYVkxzeERCTm1o?=
 =?utf-8?B?V0pWUHUvV3lHS2ZMVEJCNEZSVnRzWWo2ZkwxSjZPOGdCY05EaVpnenBUYmV6?=
 =?utf-8?B?WmxGM3BYcDljbmRHWFhveCszeEp2NGljU3p3YmFWZFhKbUtnTWhTK1QzMUd2?=
 =?utf-8?B?cXFObHZXY2JBRC9aalhQWjl1MC9xZU8zbTE3dWdzVjNONWFGcGgzZEdmaFhD?=
 =?utf-8?B?emhlNTB5R2dCQ1RGRE1xYXVndWgwRHpqMFFOaW5jYXBaSmc3UTRGazVFV1lp?=
 =?utf-8?B?QXNaRHhFYkZielZHNUtSMkZ5dWh2VHlVdW8wMW0xVUxRN1FhTzg4dkdwTWRV?=
 =?utf-8?B?VUs5TzhBL2tUc2NTdlYzZzFPelhnZjVQY3FQUzE4azQ5UjQ3b3RLME54MEdM?=
 =?utf-8?B?OVZJRTRnMFR1Lys5VFR4TkJWZ2tvcklQY25YMTZRUXFPWFgzYjlQZEhmd3lT?=
 =?utf-8?B?RmF1TjZLS2NzNkorTWJFTVVPWnRvWWZtMHl1a01KM0FsVzRyVnl6cWVMdGw2?=
 =?utf-8?B?QnlNQUUraHZpY1JnSWYzbFRRRG1kRTNzbnpvMUhkb1JtWlpHbEFja2FxNTV2?=
 =?utf-8?B?S0k4T0VFeEtoV2tleUpIS3RBWG5nNEgvbFo3MXhTMTFMKzI4V1VrclZadGxh?=
 =?utf-8?B?bkxteENRUHM2TkdoM2N0TVczNDlvc1NLY0M1UlJ2ZDZjRzRlN3U5ZmVBcWhw?=
 =?utf-8?B?WG1LMW5HbGx3dUdDaEhNMkdQbDNKd0JxcVRmTUNHUk1hV0NvMUVhRzAxWWds?=
 =?utf-8?B?aWVOSW1VQldINjlHOXZFV3lvT056WWE2WEVJZVRJME1DTnhCZ216UWNmM1gz?=
 =?utf-8?B?QVZlbk80dnlnejBDVi9ZTG8rdU8waEpHbG16S21iNU42NUZIQ1BuSzEzY0VC?=
 =?utf-8?B?L1N3ajQ4UXBzV0h0RlNqd2FNazhBeWpraUdDUStjM3JZZXZhSjVlckhJMnFl?=
 =?utf-8?B?QXNvb1Y3SU5jOHRncGE3RU15VlUyS3pwR0xEd0xqSVVsOE40ZkxyNHlKamVy?=
 =?utf-8?B?Y1JzWXJRbjEyM3BDaVdUNVJmbGswSmh6OW5sNVhNVFh2d3hYek5Md3YyZEYy?=
 =?utf-8?Q?/Zhk8xpexxTkp?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eXg5K1ZDTXZhVlBZK0t6bUIzeVNmTjR6bE5EUGZVS3FjanFBa3oyTDdNQzVK?=
 =?utf-8?B?b1VjK1RkZTJOeG1IbXhmRndhdmFhSmZGRFBLYUttM240ZHFzUm5kbzZhZVg2?=
 =?utf-8?B?VXZ1MEovOGF4MjB6UXpNOUtmL3NUTUhkNHcyQVJOS3llcE9nMlJWQk43VTZr?=
 =?utf-8?B?R2ZzNE9IL04yazNLemd6SXhYTGxlNVpMYkM5NW55akxwZHU2Nk03YXI0NTRK?=
 =?utf-8?B?VUdMakM5aXVpT0hzYVVKOVRBQXhKQWRkZ3dWN1VoMVNuSnM0UG9NeHdENmhh?=
 =?utf-8?B?anF6QnN1V1lhNUlsMzFnRzE5ek5SNVp3NUlKQU9pVHVuRlp3MWdtZEMraHpX?=
 =?utf-8?B?L0ZHTWJSV25DbzhjWTBnMjRDbDM5UGV1UXN6MFpnVWlmbjluaUdrZDBWTUhZ?=
 =?utf-8?B?aHVNbVYrVkxMaHFnaUZXbTNGQzRpeUJrUnQ5dWVkZklIZldCc3JmTGp5RGRZ?=
 =?utf-8?B?dWxQaVA0KzBHQ3pXQ0pZdXRINFUxNzRCWVlYUnZzVXYrbmw1Z2hodHJDK0ZR?=
 =?utf-8?B?WG5PeGpoWnRhWXhWSWhXNjBUdy9iT0REZEhBZVlkTnlFTXdJdUVpVjRLaFlC?=
 =?utf-8?B?b29oc2h3UThmQ3I4d2pwV1B3QWJFdmdkK1EwczhUTWU4NU1sUkZmeStBVmtv?=
 =?utf-8?B?VmVuUlVmd0tiZEtweU9pWTlsMVlRYkp4bEVrb2kwUlh4NElxRW9KdHdKNlNI?=
 =?utf-8?B?eHhyUFdDVlRiT3ZLc200cUw1Z3p0aW0xaGQ2bXdCZTVvSXY1RUljOU1DYTlT?=
 =?utf-8?B?MFVaU3lqenFLOFFWSzBmV0NQak5vWG5MSkxyOUJrMkswQ3AwSTUxYWZsR2c0?=
 =?utf-8?B?RUxvK0xXL0lhdmV0cldtQmNhcnRlQnYrQWZYSEhvaFA3dmQydnFid1FOMUVK?=
 =?utf-8?B?VFFOdWJpS1pHT285ZzRacUIvMDRBc0htMnJtcFl0ZFhhQ0tmVnI5U1lrNEJi?=
 =?utf-8?B?eFpIRmlEaE5FdEU3MWVPYjYycWRYeE5wODFucWp0cWQ4bFVQSVVUYXYvbHpn?=
 =?utf-8?B?Q2tRMWhLMEpnaXhGVnM0MUdaNzF4cTdob1hXY1BDcW9UUUl3MW5QVEd4ZkNP?=
 =?utf-8?B?Qm45UHZlWEdLMElEOXozZGlvUUsxTURVTjRjL1RlYytjUEk3WTV5UGpZR3A2?=
 =?utf-8?B?d0dmY08rcFRDelVJYk1VaE1oNUNOQnZIYWxSNHdHcE5PajA2QlFkNERSVm9s?=
 =?utf-8?B?MmJCR1FiTFA3bFlyelZ2OUR3VS9ZZkxjVGlsbGlwdFp3b29Ta1A5aVI3N2l0?=
 =?utf-8?B?TlFRNDNoZ3dhbHAvK2Y4dnc5S3hzeWFNUHdDdE9lNzVTdmxqZUZRbkdhR2NC?=
 =?utf-8?B?a1BNVEtpcmpxdlNvenlsNTVFcTBQOUlkOUpPNVJ2OVVBc2ZLcThYalJheTRv?=
 =?utf-8?B?dktjcEpVbnlSQ1hJTjlYakx2VXdFSGREUkRxU1JyYmp3WkM4VW9kZHQwQVBa?=
 =?utf-8?B?Q2N4eXVYTTZXUTNRelJ4SUJCaWN6K2JlWk9GckRFckZNbkdXSWEvZWtERjNJ?=
 =?utf-8?B?NEJSRGlnV2RzRGkwMkhJbytDRlJITTk2bHAwR2orekxQK0Rrdld4MXdZam5N?=
 =?utf-8?B?QkRrdDFGUUNIVGMwSHcrWDlnUWJoVXU2QTQvenI1MzI4UElqQ2ppS3BGZ2dD?=
 =?utf-8?B?eC9TT0h6TTRkbVdsdGFrOXZBdGFYQXFhTjJXa2JpSjQrdWNNT1phc21lOUYv?=
 =?utf-8?B?ZEJ2UkVTQWwwTnFOZ09RU1VBWUNZQm56dVY1d0tvZGt0VWszL0tJRGVnMEl0?=
 =?utf-8?B?aU9QV2NpVVNwdlBLYVVXN1FYbE5TYkRmaHhUUjJ4QXpJUzNpSmw5STkxNjR2?=
 =?utf-8?B?UEhaY3EySnhVR3Joa3FJQ2IyYVRXRGR5VWl3ZFd4WkxaRWlCQWZRQWM1Y3JI?=
 =?utf-8?B?TmppckNEL0k0VjBiZlJrczcxa2FJT3lJNHlkRVRxQTJJWUpVamRyNXhzSSt5?=
 =?utf-8?B?TmdPWnkrL3JweG1aVlNtTWpTcDZpd2x4NUxTODZvd0JzbkdacmUwVCtvVENj?=
 =?utf-8?B?ZXErOTRWY1hHWm1GNWRNUWF0djg3NzhmNHdxRWpJckZGdjNUMGlqdUk2MnpD?=
 =?utf-8?B?WHBEUXBKYW1IcVU4aXBndnQ0THN0cXdQL3RQNkVSOEQ5ZWtpaVZGQVpLcTQ0?=
 =?utf-8?B?aG5ySWVmcHY5ejZCaC80UU85QTIwNnovcjJqc0pGTHAwTEFzWEh2bWdyelJG?=
 =?utf-8?B?OXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	djclkT1WLHGHG3IMzRhT0tNCev2g/+Lnm3rRMwdAhWD6yS5pPq8F3PbzRNfgLjEVqumzYC6N8Yw+y37wiRCszNDypKOYHufL417rAOmLMBfpuubm9OYnyeQJgQYqEiZgiYATgXTdozkG7aJ9Slaw0PNFAa+kFg+cgTtxHv7DIQfH3gqCKA2BNeaikorJoJcVe8d/w27RppgUsALrNYjSRwtVTZ82QbqSo6jF33ifPMBFVDyBL3+tb/k0IzZOBWqb+rXSC9SSkgc7oj07/pprPwejlW6QSyrO+9J5oCDq1w9NwHBOcG3sWgNgCp0i6uaD7PKnkennNHPy4K4RF2YqwH+tk76kduSEYiiRY6n5KJeA23vzFprX28zV6k2F8gfj317mpYuAkBNzlth0IIUd7yAABPNP2MU+GnUL7RxWdj3ue3Qz3L2QHsqqdB0/E9Ep1tho3BgdZjGfqs1/CcZq3GLPpbZc078F4eCkXz81I6nWFLrkIXCslD71s8klSOcXK4TBCdalqeZTRg+418unKtyseuIp+asF6mSIqnfYRkM4+vrJhOmeP+8RNcauzvmzNtGTEuBS1Mbj0vQ/eqsdc60Eh+22i3iHFf1ogFnWqEw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79af3c0a-2adf-419a-7654-08dd34bec27a
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2025 17:13:26.9754
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gla6G35ZvpxzxkycMjKEbA1oChpAZbZhhIFi7T8Xd2VBnsm9KQNATRlRxTALnwtxqce7+zqsgTdxAKzHT94CTcXjQw8yj9Dzg+MM7bqW3mw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7253
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-14_05,2025-01-13_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 adultscore=0
 suspectscore=0 phishscore=0 malwarescore=0 mlxlogscore=812 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501140133
X-Proofpoint-ORIG-GUID: xuK6hPTo_7BJiWs7Jk2qq7aq9q_IVm26
X-Proofpoint-GUID: xuK6hPTo_7BJiWs7Jk2qq7aq9q_IVm26

On 1/14/25 5:26 AM, Michael S. Tsirkin wrote:
> 
> Wanna post the patch, Mike?
> 

Yeah, I'll send a patch.

