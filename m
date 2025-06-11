Return-Path: <kvm+bounces-49040-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D5A63AD5586
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 14:28:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8143F3A784E
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 12:28:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B14F27FB27;
	Wed, 11 Jun 2025 12:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bOVF8Vdb";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="YtqTGkxU"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 371B32E6102
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 12:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749644900; cv=fail; b=iV14awosUMyMt7Tj61hBaoKKoBNvYv81J2n+HQ4s7as/aKTVtL8PnEz4v2QeT4ZKx7LtxT+8tZgsfuhKcjS57jSMCabVDUiwLt2jLDmsy7cB1eIDCMZoRogswgZSDn/a9VV+TbG/x4TKkY0uRjCo1JwFd3/CbzLubnQpE9gtUzo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749644900; c=relaxed/simple;
	bh=hYjQVB69iDfIcMQuOBbBPjCIuTXftiuk/yoThm2/0I8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=TLQOGmvuCdxkZbs1zlflOIWAApsukcplBy8GzacM0f8W6shRJpF2ChQDmBWMCw14cO5ipYX8wkn2CX2qM/qlqkOHbSpqkOJPqhOLGGpPIR+o9KW2pf1xChIf2emM9a/7ufTq+e2JfD4ZEiVmu+6SFV0ijHzvlCPmIkGHYCUCGQU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bOVF8Vdb; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=YtqTGkxU; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55BCQGvl000787;
	Wed, 11 Jun 2025 12:28:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=e6j1Jdre7nqBZRyG4k1sJl38wSrv9Z/VqgmhK+wMtDs=; b=
	bOVF8VdbexaThq3nin01Yb5qShTjnKopSPlkJgDdNnqMWnWYhYTpHiXpSxBUkPF2
	5CWMCv+gUmXr+tPF2TW4LlD5W3xCZOi6bpqG6z1Ae6T3AtnPXGqMgYzrlUFtJBF3
	imvKFA/QqdyFROepYOqhzTqOoXk5BRgUtIOcMpR7HEuBuaxNbdLkLVmkk+iW2kVi
	J2piYnQCCfyiy4e6QgTNCCh9MWlDdhk0cbcWI+1NUJcX7RZYLH80s49ynkd+ZpcB
	mBMJotZYzHRM55kwnPY+z50+tEe89gQTIx902ssrUCIa15DnJX1B9jVuZLLc/PFQ
	DW38m9ZkFR1Da1/lcCsp0w==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 474cbeea5g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Jun 2025 12:28:12 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55BC3nhM011804;
	Wed, 11 Jun 2025 12:28:12 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04on2040.outbound.protection.outlook.com [40.107.102.40])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 474bvb3cxq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Jun 2025 12:28:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NoPK5LTPx+gjzEDHrqnvl99u/IQ5M8wMq3fi/X5S/yhvU1LrDiRiVOaiDiOAk2gEt8lOeUcD+AiPsAloagB9S2whyM2QSeK5pcfD6AH/Xq4VLaelV61PjFxkqiZfEGvq21++qm131fgCgMujIh1qCDHuuGugBNT3UVb+YyZuyetJ+B1CJQEeZZAoHoZSr4HujuWO0AcIPABkjM87FqoWGzez/FhNI2jELQZ9IcPnTiOfaqshUsaeyVXXj9YrzKpWKiQlT8OpFB4MOQ0INj+YvGvJmKqMagEGNP6//yC4BbJmRMHPoPZJ7lAM5cuJU/iYWHGv1x2iCjYB4oye46n1ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e6j1Jdre7nqBZRyG4k1sJl38wSrv9Z/VqgmhK+wMtDs=;
 b=XzZBWbAyi4juIiKYoXw+WIh+nhdL3FNsL6Rw/6wnL9G8C1JNARcGRtVWbQ4k/SUV5/vd0ban5wIeQdf+U4l8oOhaVGRh4bChpDi7eP4guta6fNu1b4X8l7xER+t3cjVCMUwpxeuLuQgVIYha1MBNu4I0XD3fBQkBD6sC5MHhRNphd62c/G6RbfIRxhwx96rfoHxIRqmRgnrxRAvSB4+BJWDz17CQbst2ZTWhDcJo3MApp2AiTIACRXiZCRmv/YuQ+BHnsBIXd7EG9ETQLEUS1+9xiEFXuMn3RjSz2VcR4lqG+MBGxhyYV2osLttZAm9XYw7ZAf6amM2/7LjweszIRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e6j1Jdre7nqBZRyG4k1sJl38wSrv9Z/VqgmhK+wMtDs=;
 b=YtqTGkxUntVMe/GEpr489vvI5+K2tIPMXewukTQT7YHORewWK6ZX2HBjIMoj+/f+EtM2rLykoxqaZkhE+CGCrW2QYwNg10rPz19MUAsm8EtbrxmcU1ALgdm1SWYB8GexSfUwfsC/SFXB69Zz+jLFLxdmn3G5gTsk2bxPEzzusew=
Received: from BN0PR10MB5030.namprd10.prod.outlook.com (2603:10b6:408:12a::18)
 by SJ0PR10MB5786.namprd10.prod.outlook.com (2603:10b6:a03:3d7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.38; Wed, 11 Jun
 2025 12:28:09 +0000
Received: from BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::44db:1978:3a20:4237]) by BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::44db:1978:3a20:4237%6]) with mapi id 15.20.8813.024; Wed, 11 Jun 2025
 12:28:09 +0000
Message-ID: <ba5246a3-48ee-4f58-83dc-fc2aaecd7153@oracle.com>
Date: Wed, 11 Jun 2025 13:28:05 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2 10/14] x86/sev: Skip the AMD SEV test if
 SEV is unsupported/disabled
To: Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Dapeng Mi <dapeng1.mi@linux.intel.com>,
        liam.merwick@oracle.com
References: <20250610195415.115404-1-seanjc@google.com>
 <20250610195415.115404-11-seanjc@google.com>
Content-Language: en-GB
From: Liam Merwick <liam.merwick@oracle.com>
In-Reply-To: <20250610195415.115404-11-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0387.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:f::15) To BN0PR10MB5030.namprd10.prod.outlook.com
 (2603:10b6:408:12a::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN0PR10MB5030:EE_|SJ0PR10MB5786:EE_
X-MS-Office365-Filtering-Correlation-Id: e72ae835-a3e5-4705-59f4-08dda8e36cbd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TG1kYTN3Q2NoVkFvMEZFWEY1ZXFLMDNFSG5BNXVua2YzNXNDRm9yankwRTg4?=
 =?utf-8?B?TVBQL3pKMWhMTkhxQjFmVnhKUm5icnZIU3pBdTc3UTlBUTFiVmpJZVhIcitE?=
 =?utf-8?B?ZlBNV3B5SlpMRkdKaHVyYlZEM0syRkJ4eUt6VzVSWXkyZ1JCVmxnRTNZOXFq?=
 =?utf-8?B?QzFFcG5NQy82TjhJQWQxRmxTVzFPcm9xcmQ3aGl6R3podWhmZWRYbXorVGxT?=
 =?utf-8?B?OElXblhtTW5pTVlxeXg0WnpUSXUvOVIrWFM0M1puVElNOWNyR2VMOUROTVJ2?=
 =?utf-8?B?c01pZ0gwYSs4NzdPSHBJOW9UN0JhS2l3d0o0NmQxa2xRTGpYT3pwRnRzaUJV?=
 =?utf-8?B?bmxSOEdRQWJVMGJzVmJIeCtOekZWbndtN1BldHdPd3o2Ulp0Q1psTGhlaGxs?=
 =?utf-8?B?T0VkdDZrQlF0NmprWnkvNkUwTXNQRnFLS3BBTHVWTU1WTVE5QjNRcTlLeWlM?=
 =?utf-8?B?Q3J6Zll2enlqZXB6VkQ2Q0dsaXJZalBNYUU1a1BvTk8rQmdvMDRoWkdNazBi?=
 =?utf-8?B?L1JTQnhPeTV0cnZPNWE3MzYwL0ZxZG5GSHdaVjJXNjBPek1EZkdvYWVwYWJF?=
 =?utf-8?B?Zkc3UGNGRHp4amN5YW5RQUNTM1pKKytabVg1WmZFelVEMmhhQWtldnc0Vjls?=
 =?utf-8?B?TjJQQlFWbW9KR2EySkZZcFpzUW00U2prNVpnSTB3NjQ2ZVl1SUR2N0FsOERn?=
 =?utf-8?B?VTA0bXpmMlUvaGs3VWZFT2hkQkNOTkNkd25rQ3FoVmtrUXQzNW5ablhtNE9S?=
 =?utf-8?B?b0h2T3NSbXlveFBkNW1iekNpRDRldGNlUmlGWEw0d0RWYldWcVViWWZmK2xP?=
 =?utf-8?B?L1h3N1ZDNmcxUGVuWnNoVkR0R2p1SGt6RVJOVUlwZlBWdDJseGZnbC9XdW92?=
 =?utf-8?B?eEpiQXdWSENnQVhwc2paOTdXWWpaR2NYOU1YazloQnJGMWpWVVlBVWJCdm50?=
 =?utf-8?B?VFVoRkxxN2FFWEoxeDFGczdxV2tNclhNTGc0TUJUaUZublR0ZFV2OVcwSVdk?=
 =?utf-8?B?S3JPWjBaREFKQUd5WkJGVUxoeHFNRU5EQ0JNQVNxYUNvdlRrRDRkMkExN0RN?=
 =?utf-8?B?ZHpMT0hMVi9yOFEvWFQ5RUJaRDlRYnBGN1RGSk9KRGV6LyswTGhGVVJZdVkv?=
 =?utf-8?B?dTlYc1RFRUlSUVB4ZjhSbWNrQjc0dzUwbnU0enB4WkpVWWIxMHUzUXdrWlFI?=
 =?utf-8?B?WXY5M0JLaFpIaTE2UDBIQzZ4bzBiVTZHdUc5a1pHQ25TSTZXK0pzVnFtbU9l?=
 =?utf-8?B?ZmVpWU9nQWNqN1ZmYjkrSENNdmtrWmNsZUlOS3ZuZEdkckx0Y29veS9tQ1VC?=
 =?utf-8?B?Yk4yV3JJWmIxa0pscDZrdEZGRmxocElkU3JnU2VMY2VmSzdid29BUGF2Zmoz?=
 =?utf-8?B?UVYrZ25zU1V5VE5DaXVBQ1ZqajVEVUptRTVTVm0wUzE5TDVSQ2pQVG84QWJk?=
 =?utf-8?B?Z21YMEMwTGZ0bFBPVVN4UXZsOE9rc3JrZlFqalRqSThpa0ZleWZpcThsTW9M?=
 =?utf-8?B?aTh5T05saU83OUhLYW9ObWlWdVBsRUhmNERYeit2RWlQOENFSmI2UGJnbTBw?=
 =?utf-8?B?ZDZQa1FYMGhBRjY5WVdYWVgrQ2loQWpWQXRJMHp4UjhVaG95YkRLUkJEWXFU?=
 =?utf-8?B?OCtxTUF3RUwwR1pXWXF5OC9rdE5KQ3RsS1I4c3BsWXhWT2tRclAzVkhjNGxN?=
 =?utf-8?B?ZW9hbG8zRUZKRXB1dVJ4SmxjNURoOU5xTUdkWjBRampIbDVjZmFGcHlZNDg0?=
 =?utf-8?B?eDI1SWpBZDFyU3pwaGZyRkNvdEYvbVRIN2xSeHJodThyVmF6S2FnLzJDYXRX?=
 =?utf-8?B?R2VsZXlqb0lUeEJEZmFYY2M0V1lWbnI3SmwxQnppZ24vbk0yeTg5cEpRT1Vq?=
 =?utf-8?B?Vit3UHlrM04xMmg0ZjFFWk80cy92SWtNQVArOEszdE5PZ0xlUllJQldsUlFu?=
 =?utf-8?Q?E8FM908ZzVU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5030.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QkhyY2YwSmJ3NzVDL05QK1ZreXg1M2hUR1ArSUh4OVVJUTdibzAzaFg3RG9y?=
 =?utf-8?B?VmdFeXU4N2NNRUJRYjZUUFpJaGVlSlpMekV1TDJRT3hEaGcrbzh0NGRDYzdt?=
 =?utf-8?B?VlMxVHJhZ3YxVnZnNmJIQThtRjk5YjVweks3NE1NWnpCd3ZGWXo0cFM3bUdL?=
 =?utf-8?B?d3lsZEpxbUhyYkZ4ZnFldCt1Ykk2OURBcWNiRFZhWXphL29UdEpUaUZmQXYr?=
 =?utf-8?B?M2lRZmF6Q2VrVkVQU1N6VUJBZ2hhWkkvN1FPSlN6eW1uMUZ1R1pweTZsUmhj?=
 =?utf-8?B?UElqRWorWkZ6aHQxUHAyYnlNK1lEOHdlZFFrOWZ2dm9oV2ZIS1d2aVJVYTBu?=
 =?utf-8?B?YUdyN0hOckRiVkduaGNhMjhiU2FHbFJJTDhFVGh4NWJKWmtDakwvQk5OVEdE?=
 =?utf-8?B?R2JrMmxuU2NXNkJOVzN2S1FIODVmNHd1WWpabE11V1VIMGtIL1V3REl6YWtM?=
 =?utf-8?B?ditsNTdpS1BkOWoxcGlrNWFCdWlmREdzY0FXN29HZFFxemo1SkFJSXJ6WUxp?=
 =?utf-8?B?UlN2c0NFY1dsdlFuQkZyYVpvWVJvUlgwZE1hM2FtMFpsdVlLZUNkK0ovZGxC?=
 =?utf-8?B?UndRazlXbHMwR2VNZDdFUjN1ZmIzOGxoWmQ0VjJ0WmtOaUgyTG56dFR1Sitl?=
 =?utf-8?B?Vk9LdC82SHpPZ1U1WjBsRUJudU9WcEFKVWZmMTV2dW5BUG9CR3YrMjhuRnZv?=
 =?utf-8?B?dTkyT3ZocVFvcXdJbUY1cm9IampPR1VBVzlnWW1rK0p4UXMzSzBNYW04QVJh?=
 =?utf-8?B?L2hwWTBiQ05jemNFRzM1S29XZnM2Q0J5cWZRNlZJRFlKdzdNWXJ0SXZvaGNZ?=
 =?utf-8?B?dUE2U2pZSTE3MFl3a1hTL1VwWUcwaVBOYVhaT0t1S0dQVGZxLzJCK0tDL1Iw?=
 =?utf-8?B?UnhUMHVFRWZlSDExcXZxTkU2MUtJNlJiaVh0S3dURiswM0E1Y21xOFd2V21X?=
 =?utf-8?B?T2FaVE4wUmtmWHlsUG1BZ01qWkFTMTY5QnpFSHRnMEl3R3BkVFV1UzlCZjJ5?=
 =?utf-8?B?aVpRT3FxbWZJVXNMNmhBUXpTYk5jQlpaaWZKengvMUdtL0lzK1ZxcWJwd2pq?=
 =?utf-8?B?NG81QW1XdnZWZkRFSzNPOFUzdld0UlFwbWdzTWt3YjNUdVZMN21WcGFIVEVY?=
 =?utf-8?B?RUc2Ny9oQzQrVmo5ZExOY1dpdGxGNEYxbGNkRmtvTVJMQmwxK2lLTVZtZnYy?=
 =?utf-8?B?QW5RS2dic0pFOGM4eDNCSVFqTWVlaG1wUDI2NjZEaXBudXdlVndRa0hBZTgx?=
 =?utf-8?B?d2o2L051V051OWR2ZTRxNU1TNU1OSHVFb25sSmFMWHJvV0UxRFB5WEVRMW0z?=
 =?utf-8?B?SzcyS3VSMlNwalJ0bDRZbTl4N3hrRTllWFFyM0tLTmIzVHRicUd5WFpUSnVT?=
 =?utf-8?B?bS9IbnlDMENlOFE3cjJhTVVBN1FkUmRwM0RHd1haSnF6eU82V1p6TU8xZU02?=
 =?utf-8?B?Yzkxcy9uM3VSTFRJUlJicEtQV0hZUW1qOWhlWTl0QWZQdWFTMVpvN2MzUEJR?=
 =?utf-8?B?NVZsWTl1TEY4Q3NiZ1RpQXBvbXlqTTVYZk5iRE9ZQTV1eFdEcmkrMjZKNDZ2?=
 =?utf-8?B?dlcwRTM5NE0wRVltNy9CS0NOM3JYS0FaOENZMFNubVB2WkhtVVlVWDRtVnh5?=
 =?utf-8?B?bi9pR0hTblJyQnRybWJUdVk1R1hnTHVJbmlJNjliZFRwakJDQ1QzVzF1TUcr?=
 =?utf-8?B?QnB2NmxEZUZnQUxnUFFTRDFDbmZRS3l0WVRHUnRtN0JLUEo3b2tqdHFjYXBr?=
 =?utf-8?B?UkVUdmRTMWlLbXNQSjZrUFhpTDBrY2pJZUpYVmlFTXdjRHhiQVd4ZEVpYks5?=
 =?utf-8?B?aS9naUhwVUozbGI1NWxaWER4aVZpSE1OdHNrbnFBc3BGeG1wdDdqRmlQWXcr?=
 =?utf-8?B?dFRzMTRyRzhVNG83c3A2OXZ4Q25mNWxxRVkvRkh5V1Y1bHdkbDEzeU54SkRX?=
 =?utf-8?B?a1FrUStoeDVlUTBYbHZUU2kwWlBMSkovUnRnSnJQUkRZSmFqb2FzaDA4NmZI?=
 =?utf-8?B?QXUwdTA1MVljYzBkMjVIeFFCV3g5alB3UEVLaDluZ3dqNXp3L3B3VExtZEM5?=
 =?utf-8?B?dndUSE53K2FGaGdmSS9OT3lmVVcrM0NRZmlhRzNkdlJzbEh4bkxFL2FnY1B4?=
 =?utf-8?Q?EHBWzh0jEDnGYVVFjZ+h4K/eH?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	dHD9ZdZiyx6RJV7Ju3r2iMsyXAuQnq3ZtzTj0Fxtj791rVJAgAfKdMwG0BAdrHamT/gJzS8vGELjf7YX5x/jpyCo1iYGq53rvLcwIzhZ/JWc9wCdnMkA97WqfIPKCjAYMbRBydepVbAD09ndVti9zmtPoQtBq7inhhxftonhw9OsPYYZOxdbpeQ5Pk7LG0Dt3VEkfeKXUxynoPHIjPB+ymvAbid0B8aHmMGljnBBmBaedFOnu5S7600JRSgpJrrfC7ywXVSa7RKIR7pvrkXoMbz57ySWbWiP7fWADE1mDOQzelU/VG0Yv+TtB/fqjVRiw6AprQHWuZ7s4P9K9ci33g42wM/3D5VfA0pKuRoUi5PyDc3lZgA4C5+YddWZzDqdwPmq8bA8UkBdr316VgVI6LdXckv9jB7+6UftrppsMioYHTNA8s5bwJEGiqhE9nmIT0ifAGHhkpt9s1yCrks6Z9l9xdhX5l5M3R/nEd0p2IPrQMZXe2DASTM5s0lmx5ejviI95mWbjTzA0ctjsrOxbo28w0Kyp62yPc9iOQqFn/nArajdIas5we7vW8+bSrEezLW1A8+JQKdqigjMziUefD1qwzLD5aKlvhqMQodOtJw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e72ae835-a3e5-4705-59f4-08dda8e36cbd
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5030.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2025 12:28:09.3582
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X4gmTCDSsSz2zwE1G0JoatZzmADeIgiMz20WWFDz6xek74wIJ7ghL8MzAh9HbbHHhkNXdm8iFPyKUfZYgy3Qjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5786
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-11_05,2025-06-10_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506110106
X-Proofpoint-GUID: RRF2PWqqVKcrlUiKA8J1yyncLbwk-ugi
X-Authority-Analysis: v=2.4 cv=BffY0qt2 c=1 sm=1 tr=0 ts=6849765c b=1 cx=c_pps a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=1XWaLZrsAAAA:8 a=yPCof4ZbAAAA:8 a=WtScbgGx9-Gc6NA_u7UA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: RRF2PWqqVKcrlUiKA8J1yyncLbwk-ugi
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjExMDEwNyBTYWx0ZWRfXzgoenxRhJ+zt aEjggKedMKCnXJHrjIlpR8wiqOjyZmht93OO4qpP3YXSsdTHVbn/VWB4xwFUlY3huiE0q/QeZlr UAN/yUUYqYn9Kk+P5zimmUseqYvnFu1MDnGpvuMckkrGmZK0sNjEDYg7QYJstCv1AnZl4q/3o80
 y4N8GhlhPzY8Cehp5b/WISgPKJRxqISOyPi89uMBfXa/9NJYsbhNhoNeqXjq4sFg02o30nREtqc VGnxf8uDh94sNM2ghzFm+q6r+Xj+Y0b18Efowslmgbm3TYfXPX6cM5OSmmpLlAqEHxW8R1x09+0 Rm1YqTR8ZYO25isRW5orr3FOnlG7SoKH52zTbP1j2jaDRckgn+ycSthlaz20k9PxonKQGOryKIS
 oJeZMlKIEwAM+KKEK5nEDG3E5TRnwfAhykKTMA3Ed2sjmDCJ82BEACVPkk0Se4oSX2B7VaGe



On 10/06/2025 20:54, Sean Christopherson wrote:
> Skip the AMD SEV test if SEV is unsupported, as KVM-Unit-Tests typically
> don't report failures if feature is missing.
> 
> Opportunistically use amd_sev_enabled() instead of duplicating all of its
> functionality.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Liam Merwick <liam.merwick@oracle.com>


> ---
>   x86/amd_sev.c | 51 +++++++--------------------------------------------
>   1 file changed, 7 insertions(+), 44 deletions(-)
> 
> diff --git a/x86/amd_sev.c b/x86/amd_sev.c
> index 7757d4f8..4ec45543 100644
> --- a/x86/amd_sev.c
> +++ b/x86/amd_sev.c
> @@ -15,51 +15,10 @@
>   #include "x86/amd_sev.h"
>   #include "msr.h"
>   
> -#define EXIT_SUCCESS 0
> -#define EXIT_FAILURE 1
> -
>   #define TESTDEV_IO_PORT 0xe0
>   
>   static char st1[] = "abcdefghijklmnop";
>   
> -static int test_sev_activation(void)
> -{
> -	struct cpuid cpuid_out;
> -	u64 msr_out;
> -
> -	printf("SEV activation test is loaded.\n");
> -
> -	/* Tests if CPUID function to check SEV is implemented */
> -	cpuid_out = cpuid(CPUID_FN_LARGEST_EXT_FUNC_NUM);
> -	printf("CPUID Fn8000_0000[EAX]: 0x%08x\n", cpuid_out.a);
> -	if (cpuid_out.a < CPUID_FN_ENCRYPT_MEM_CAPAB) {
> -		printf("CPUID does not support FN%08x\n",
> -		       CPUID_FN_ENCRYPT_MEM_CAPAB);
> -		return EXIT_FAILURE;
> -	}
> -
> -	/* Tests if SEV is supported */
> -	cpuid_out = cpuid(CPUID_FN_ENCRYPT_MEM_CAPAB);
> -	printf("CPUID Fn8000_001F[EAX]: 0x%08x\n", cpuid_out.a);
> -	printf("CPUID Fn8000_001F[EBX]: 0x%08x\n", cpuid_out.b);
> -	if (!(cpuid_out.a & SEV_SUPPORT_MASK)) {
> -		printf("SEV is not supported.\n");
> -		return EXIT_FAILURE;
> -	}
> -	printf("SEV is supported\n");
> -
> -	/* Tests if SEV is enabled */
> -	msr_out = rdmsr(MSR_SEV_STATUS);
> -	printf("MSR C001_0131[EAX]: 0x%08lx\n", msr_out & 0xffffffff);
> -	if (!(msr_out & SEV_ENABLED_MASK)) {
> -		printf("SEV is not enabled.\n");
> -		return EXIT_FAILURE;
> -	}
> -	printf("SEV is enabled\n");
> -
> -	return EXIT_SUCCESS;
> -}
> -
>   static void test_sev_es_activation(void)
>   {
>   	if (rdmsr(MSR_SEV_STATUS) & SEV_ES_ENABLED_MASK) {
> @@ -88,10 +47,14 @@ static void test_stringio(void)
>   
>   int main(void)
>   {
> -	int rtn;
> -	rtn = test_sev_activation();
> -	report(rtn == EXIT_SUCCESS, "SEV activation test.");
> +	if (!amd_sev_enabled()) {
> +		report_skip("AMD SEV not enabled\n");
> +		goto out;
> +	}
> +
>   	test_sev_es_activation();
>   	test_stringio();
> +
> +out:
>   	return report_summary();
>   }


