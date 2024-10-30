Return-Path: <kvm+bounces-29988-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 48AC39B59AF
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 02:56:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6BD501C22523
	for <lists+kvm@lfdr.de>; Wed, 30 Oct 2024 01:56:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3217191F60;
	Wed, 30 Oct 2024 01:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jYwD8V4g";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ValOaRkx"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61DA33398E
	for <kvm@vger.kernel.org>; Wed, 30 Oct 2024 01:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730253404; cv=fail; b=hmTDHrN7L/gTt7b7sBdvktmF3T29d9PYRa8bIyiY3vdrb60jP6eYSMiw4EiwMJKV+jCGV5bg5Ef1DPDRj1zDLIFfnMTmyNPPaMKFY6s+BNxSy57qeDcfVsm7M9tv0jHTu75A1NCl2JuYW35UPvkh3P43zAAeQuL5OPvFDKZkGAE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730253404; c=relaxed/simple;
	bh=FDQV8Ft04Pg+8d4pZLsjt7fl+70nhSxgSTK4R8geFLQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=mP1oJoElFuxdj23E1IVdQz43taSHFn3JtgHz8tUW3VpHSm9GXbUMZUqcnQMFswPS+Cdm5iR//qXLIXBG8np0Og0SADWPVcie9ZPGjvQngcE7NaDJRWoN2qNGzcBXe0ZnAjwreWD6GgaNeEaqOUZVXhHHGSwrbYSXJxfjoqSaiW8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jYwD8V4g; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ValOaRkx; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49U1fdbC027036;
	Wed, 30 Oct 2024 01:56:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=9Oy+8HnX348JmAgN4TnH9nz9SqXdn5d4ycr748o4ofY=; b=
	jYwD8V4gYK+kxxTRIDT/MGQba02oWVK+9jyzya1EycfTYUL20CulluT28RBn54qV
	Fz6Andt3gjqNxBetgLnv8UWVz3tHavucuCXXRNt1SZuDThvyZT6lzBqTfDP4/cfz
	2FfN68tYSYOjKuBZ5IwjJQlNoM8hN2rHe4SIyjraJSFcGS/Z/ySAG+I97jAXn0/1
	jckMEBfQfZqkv/B/PD7W4mBTcH2VcfMkPvnPFOkc/NsJLb0Kf5lT4GUX9wEG5ALn
	NiXUcTkCjtXFrdzb8RZ2qLAFI9wQsNFf3AvAeVe7kJhLo9VgbHW0U6s/sGQlrIxQ
	h6EaKuHWOp2+6DuMM04z+A==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42grgweuvg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Oct 2024 01:56:34 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49TNAf1A008495;
	Wed, 30 Oct 2024 01:56:33 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42hneafy3g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Oct 2024 01:56:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u13gC+Ec9WQCY4USfkLJla4V9L73rpyDKe+N7YyRHLW0lOvNZOUmCvpL5dI9+t3nus0cXqDq+gPDCW3DC+dFudMdrdovBldCd10E9qgLLsA5QSO+6+TsOlgHFHX3sPdQrwdPTAZ+ik0SU7e58E75t+vn7ufcdl8f7Q3N45kvDwnBjXN4qhIgSJudpYEsUzRkVu8Ry2u4yuh+L1gcKWN8Xr/hwcwX73wEb7wnft8GAfaymXpM3vRws7ybyHFzYuFht8l5iexn/08urHwLewDFbKftIoJiPdR5TXiyfqynNiL/WcEsYGt2fvZzk59KNPpxjDyogmv/vX1yuP3qA+cxGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9Oy+8HnX348JmAgN4TnH9nz9SqXdn5d4ycr748o4ofY=;
 b=NqBhfsTtcjJoDw9GYo5VXnOvVNGtIGz/kKqV3ElFCzoopWhpPdeNwVxM4CLGB0/NogktEjwgdzFTpDwr6CUkQ6BcsNsxpgYSVFVjx82+VeF7G6c5J52qsB5Z8zaf/C4LOsFaSztkTwPVNqqjSaCmms9ltVhDUkcHo9ke0idXS52zfQc8gugLiK8wA774XQETb0L+hdx+7K3695i96sXoZW+3x8QyoJnmopBgvN7h8Z6qSJnOvcd9N30moSuJAug3BIjS/uHVw/5+lpt0mVc+PhiJFf8J39cY0KMClzkPjVXAh22p2M6ydSTqACI86gH4zbvWLug5dySU2Do0ZsG0mA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Oy+8HnX348JmAgN4TnH9nz9SqXdn5d4ycr748o4ofY=;
 b=ValOaRkxJmgSL+WTpZZvnwDjx+ay4h4H9aH2nE0qXyfv4uLqpQK1R7kyNUIQNIbVDyXutJJ9kWEzWBvnX4rFrmp+Sab9l8Cz9voTiN5bnAHld/+drqrITu2hgVytZR3clqPdiWDNgkSJggFFyuqbJq5Uygm6E68/FpJzW3dLz5E=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by DS0PR10MB6823.namprd10.prod.outlook.com (2603:10b6:8:11e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.24; Wed, 30 Oct
 2024 01:56:30 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%4]) with mapi id 15.20.8093.027; Wed, 30 Oct 2024
 01:56:30 +0000
Message-ID: <416a47ff-3324-444b-a2e2-9ea775e61244@oracle.com>
Date: Wed, 30 Oct 2024 02:56:25 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 3/4] system/physmem: Largepage punch hole before reset
 of memory pages
To: David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: peterx@redhat.com, pbonzini@redhat.com, richard.henderson@linaro.org,
        philmd@linaro.org, peter.maydell@linaro.org, mtosatti@redhat.com,
        joao.m.martins@oracle.com
References: <ZwalK7Dq_cf-EA_0@x1n>
 <20241022213503.1189954-1-william.roche@oracle.com>
 <20241022213503.1189954-4-william.roche@oracle.com>
 <0cda6b34-d62c-49c7-b30c-33f171985817@redhat.com>
 <e9f8e404-50db-4e0f-a5e1-749acad49325@oracle.com>
 <6cc00e04-6e38-4970-9d6b-52b56ee20a64@redhat.com>
Content-Language: en-US, fr
From: William Roche <william.roche@oracle.com>
In-Reply-To: <6cc00e04-6e38-4970-9d6b-52b56ee20a64@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P123CA0485.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a8::22) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|DS0PR10MB6823:EE_
X-MS-Office365-Filtering-Correlation-Id: 76c808af-84f9-4451-1f85-08dcf88612ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NkhleGsrVHNLM2crMmJNZURuTTNrNWFkcUNsY0NUN3I3YnpFUzBFVHlrb2Na?=
 =?utf-8?B?OTd3SzVudjdXYTNWV2taSDcyaE9vMUpETzRXQm1DZVR6T1g4UEU3czNTRjZR?=
 =?utf-8?B?bms5YmZTRGRWWC9wc1ZWWllFVXVobjh3MXZuQ0dRdVpQRTc4eHJmRFQxZ2lG?=
 =?utf-8?B?dC9xdG5uNmRQcmFaVTZYSXkwTXpmTmFiVzdUb1VQVG5kMzV3UVd3RE45Ylc1?=
 =?utf-8?B?ZzJuWTZiS2E1N2x3WG5Fa0pmbE9jNlRqbHFITWJPalNKcWJNcVl5bkJVaXUw?=
 =?utf-8?B?Q1ZvRjlWVld4UG9JOVNyckszOENKYUVRT1RZQ1FTamhjU2RRTllOaHlPVXBk?=
 =?utf-8?B?czFSek0rQ2pGY2d1L0VFOVIyQ0JzMXZIUzk5akFlaWJ1SU1sTGpOQkJ0VjdR?=
 =?utf-8?B?cTVXVkJDYnlaY3VoWVZrTUxqblg2R3Brb01EcUpLVHREMHd5NkpOL2tKRFhK?=
 =?utf-8?B?Um12YW9BaDg3bjB0ZnlFa1djUUtlbmUycU5mR09HS0tUbWVoOTFva3kva2JU?=
 =?utf-8?B?MFBjdlVXdExvUUNCTkdKdk9RYm5jemQrM2VPMXU5UExHWVluMnJnVjhTRCtV?=
 =?utf-8?B?SmpxUXNjYWc4V2lvUTAvR29SUGRnZ3ViWjZWcHd1VFN4bUFSWWFRVTlGNXRn?=
 =?utf-8?B?VVdUa2piQ1hSWjI1TERlcTNISnZXQllRbEd4cWVlMGw4M2pHU3ZyK2thcGFU?=
 =?utf-8?B?c0kvNVZWdFlTSmREakpudjg3MldVNHFzSHA0emZDMmJDNU5vSVNUTzBCR3Zo?=
 =?utf-8?B?QVlTenphR1lGRVBTRjRYQnNGcWZtWGhmdWozN1NYZjd0Ymk0TG5ObElHWTBo?=
 =?utf-8?B?TXVRemRYRlZ5c0IvK2ppU1RxK3JwUDAwYkN1TFZXNWFONEN6YldBVEhDNnJM?=
 =?utf-8?B?c2lmNGRwb2VmTUpreTZ2SmFjNUluYWluUnBKZ285Vm1LbFR0M0dtTzRjVnlw?=
 =?utf-8?B?RzZpdTFzV0xMT1RaQzZCRFdMbWhybnJIT1RrelVqbEFieVVIZVJmSktXWEhG?=
 =?utf-8?B?N3VyZTdENld1VHk4Q0d4aUZ6U0NzR1YxY1V1ZExnY1dsOTNCcjFXNHMrNEpZ?=
 =?utf-8?B?WTBXVmIzb2xqc1hZKzNYZHVGSTlMN1pUalg2enFlanc2aXdkTnZGRXFkRUJt?=
 =?utf-8?B?Wk5vbGUzZnY2aHVHTlRvdW5XMXJKeHM3ZFVNejNyV1U4T0hraWhKWjhZWVRZ?=
 =?utf-8?B?bUxad3JacTgyUjVTVWtwb2pPMFMzTVplakEzdkMxVGowLzZkcmptTjhHNlhO?=
 =?utf-8?B?MG9ITHlHOVBWZ2M2dnV0ekdZcm5WT0M4OVFPYTRRSm8xUWVrNTZHbUNKc09u?=
 =?utf-8?B?TTh2ZFl6RC9jYVhuZ3BFRWx1dmdnUE5mZzZwRWM1OXBTazFmNW03eXo1dTZT?=
 =?utf-8?B?eGIrMmJYdW4wdFFRZXNFbXhSZk5panY5V1c4VnJpUHRRdkZZTjBqZUdIWE1Y?=
 =?utf-8?B?aHpDdHZYWndtN05WR2l0TTVnd0UySng0OE9QS3lOZ0ltQzlzUTcyZm5ONDBC?=
 =?utf-8?B?ZUdwbUJvZjJGeVM2UE53c08vaHcxMXVqaDRIdytFY1dnY283YkVBSklnRkdJ?=
 =?utf-8?B?bW90aGJVbjFtb1JmREdpMDlvcWNZdFpOUVlHekZyeTRIRC9EdDJEeDJ3T3ZR?=
 =?utf-8?B?anVsUFFQdy9JK1g1Zm5nMmdKWVlsTkpaRWRtRmFWMUVjby9HdG1xc1ZPNzl1?=
 =?utf-8?B?VDhZcFpaaXUybUJEVzJlSHNGdmZlWTkwMWRrZ2NqTld2b0xEOHZmUnNyZ2ZW?=
 =?utf-8?Q?1hV/AoYOhIUlutZnvmodaXSkCNw8cg9D7s6cWVV?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Q3BQcmxzSFYzZ2Z0UjVvNC9MeVlsMVBBc0R6TG8zVTI2d21DYW5KNW1Dam55?=
 =?utf-8?B?bittZGRQUER0NHdCMU42T0hNTGttT2xOWkhNTGwyTCtrOXFNOWU5eU1IQUhE?=
 =?utf-8?B?bHJvbnBrNktKTDA5MHhoVmxwVks4M1kxYWJGcDFpbzBqOGlaM3Zva3RpbU1F?=
 =?utf-8?B?UnV5VGh2OWttdGMzaVVmMG1ESGpZeHg2c1VLQmg1Qld0MnlCVjAwV3I0NXNL?=
 =?utf-8?B?bkZ6UmF6MTY4Tm9TOVhMNTNBeW1CU05ROWNwQzFualdHUy9qZFkzdVRwOEJr?=
 =?utf-8?B?V0puWDN3MWFSOHJKWmkyd0l5SG1iNzNGc0Z6cnY3UktVelk3NGc5dGozeWpr?=
 =?utf-8?B?UUlNY2VtM3YycW9NcXhta0xMUVdwQWI0Tm9rdnhqQnNWN3FzWWwyVktYVGdh?=
 =?utf-8?B?TmFiRzRKbDYxS2ZWSWhlS3hGczZnZzM3MXpiVnNmcURyb1R1WHNoMXprL3B6?=
 =?utf-8?B?NzJkK3hRdVBuSVN0VitoOVIxNndSSkpvblN5eFdXNFptSDBlYXY5bitIbkNZ?=
 =?utf-8?B?cmlTZ1E3bTlqNjErd3hNQ0doL1Jpc1A1WWlLSGFQZHJ4d3N5WHJrNFJiTzVa?=
 =?utf-8?B?OHlGdndjekNhb1RkL1ZKdk16ZWFSSU4zNzYxQlZtWDdocTVmSjFVTTRQSW8x?=
 =?utf-8?B?Y1c2TjRCSHc3SHBzUlNpRDVIOG15bjBpR1VTa0xDbGZmOWdWRENNTk1qTjgy?=
 =?utf-8?B?RXE5STd6NksvMXI5MUt4b2plTWdISkllYlRxaXJGZ2NkZm9oMHdHci9BRTBM?=
 =?utf-8?B?eE53RCs3WUx3Q21GNTU4Zmh3Qzc5Y1ZjVE5uVGRlQ1FmTEFFUG1rK2xOOGVo?=
 =?utf-8?B?UllyOVVSRFdpSG9iNmJkUjhuRVVlNzJaK2hsQWhabE9iL1Bndmw4QkNoRlN6?=
 =?utf-8?B?S3AybW1Ib3hpNk1zZ1R5VXNCeHVqeVJiWU5KQm9JZmZvNUJkcDhHV2VyZHR3?=
 =?utf-8?B?SXpuZ1pjdk1iTkpjRmtWWEVET25MeEEwTi9mbWZTUE1hUnVrbW8zcGxSWHJR?=
 =?utf-8?B?WTlVQnF6NVN5eldWMnZyWnh0WCtDVHFLNzNXMUVwbDd0M21XNVB6bXJBYlEr?=
 =?utf-8?B?d0Y2WUJOTzQxV0lqRFFXWFcvZnk3Q3gwZER1Y3l6ZEorMzFaWFVtVGxiTmpX?=
 =?utf-8?B?SzROZ3MwNTllNk9JbFZCYTlIOVFNbTk5M2JEYVZXbFNxcGVqcUhQNHFQbi9s?=
 =?utf-8?B?ZnE4c0kyWUdWajljUHJ0N0hqUUl2c05GWFhPVDJzSUUvT1N0cW90SHFvVmx6?=
 =?utf-8?B?VmFJaTVrOFgwR2prNW1mNzdkLzIwNFJKRjREZXJlVTVIeVljRmwwSFYzT1Y5?=
 =?utf-8?B?STNWdE1wR1pvR2NZUC9mZ1FrTzJZaFN5Y2xMajFSNUdxQlpGeE5ienVrWWhW?=
 =?utf-8?B?elo4Y1FSaUU3WHVONE1BSmxsbUEyYTFkK2tlNFpDd0UvSFR0cSsvVlVINW1q?=
 =?utf-8?B?TlNuVXl5SWtoKzFnN0JPc29zK3EzQVUyMUU4dnVvWXJkSWNaNUJtZTlSQUJx?=
 =?utf-8?B?NkRBRDRYRjc0aFk2YldaOXhLK3VCWGZTVnBCS0RmRGx3ajREWG9KWnRONlR2?=
 =?utf-8?B?cUkwZEdhRHZ0bFg2V2Q5RzFuQ0Z4ajdiZ3pCb21ZYno4WENyWmFFb0czaGpS?=
 =?utf-8?B?MkJoc3phYkVpRlRobi9MUmdGWHdiKzcydDBZdDg1UHVBT0xQMjA1bjNkdFor?=
 =?utf-8?B?Z21WRE9JbHV1N1d2SmhaaEZEVE1xN1d3Sm5YbVVxTWdORWpXd1NubDVYd2p3?=
 =?utf-8?B?UFF5cXlMRWgwL2d2KzFibnNMSjVrWXAreW54L1ZvbHlOazFhS2FTQldIYjdH?=
 =?utf-8?B?VXRnS3c1b2NIRFNlNkpLSGxKODdQd28yT1dGNUdjMHozK0M1Vkw0c0UwTnVw?=
 =?utf-8?B?R0hOV1NjejJYUWw3eGxtdW1WSXNrTGNQd3k2cTN5OU90SW15NzZRYVpvcGJw?=
 =?utf-8?B?bGNub1h4emY5UzB3dnd5bDdPbHFqT1JpSE1qeUR0RTNrbmZHMzh2UkRQSW5z?=
 =?utf-8?B?TTczTFlHbkhtZ2V1VlFoekhzbVc2SFp4aVU0Tk9kNzZKU05kaWxucExJeW9o?=
 =?utf-8?B?TnN4U0M5RU9iOHZYcGhBQWdNdnorcDJvS0dxRGpTQW12YktTdHFhbXJRZ1Bw?=
 =?utf-8?B?M25tL0p1TGNjSGREb092d1g4aUFiZjZSdXllcGtDSjlUZHpzOFkwTEFyOHYz?=
 =?utf-8?B?WEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	SaPwszkbVCh3SD3ESoH0AdY9OR9L3qM6Pb3mFe3jqn5VXZR/AUCL6fAz3Oel0DpTXXjDNfN36cbcxhEmas+cA0ivjeWh4dVSQXogcjxS716PHp/tvASOV+CtZcBxchZLwMPKFxdJhFkogCxSHPnZhzdaokdUb/KmHRYbbmA3T+DH5Ua5dNWBE7WlcO39J1YYIv7nRu4vJPZRvoj7La92RbNQBUmEvnwHKw5SLHXLsRcjh9qV4b3gUgYmIBhUvnAspxbw4tQLGkuFCZqTQJrRcyQFO8TZiXSbg6VxEksO6ZvG7/RcS2KUt6ha6nIyqSMtKGC2x0gDzd/2Y+fo0R6pOPs3TFpN6EFq9Ij5OC2/NBB0nCeC4wOuAGvkr5BfEzVw2jkMwDLlDl4rbU9OX3rSHHQx2ZWKFO1SqrUJDa2Bui23srY5sQhRzYTw9y724oKIDcVJY3Sbu1gSUrsfjuvMOagHLw5n0t/T1jWS/Ppg4GEm01oG1fwzC8CFBgEKdsS/oOVbgnu0ceCE036LxXnSzccWLqGLAwUtTegmmgPESvoDvfxx1LrBqqKxHu28PPwP2oUpHBVJ7m8z8uusp1KpbmiOsIo0hlyZ79gy+43UIgg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76c808af-84f9-4451-1f85-08dcf88612ce
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2024 01:56:30.6676
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a8ja20XQR2ojQ3mgdD/mYs/YweullnrRDDONNvZIq3M//SYz4Cz9nPESCaoLFRYJbwl2nILouINgQdlU1CZ6JWNRbCPmZuJn37oWbony90Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6823
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-29_20,2024-10-29_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410300014
X-Proofpoint-ORIG-GUID: hVX0-i8IPGgKBAh2Z2qJbrhPDPz-piK8
X-Proofpoint-GUID: hVX0-i8IPGgKBAh2Z2qJbrhPDPz-piK8

On 10/28/24 18:01, David Hildenbrand wrote:
> On 26.10.24 01:27, William Roche wrote:
>> On 10/23/24 09:30, David Hildenbrand wrote:
>>
>>> On 22.10.24 23:35, “William Roche wrote:
>>>> From: William Roche <william.roche@oracle.com>
>>>>
>>>> When the VM reboots, a memory reset is performed calling
>>>> qemu_ram_remap() on all hwpoisoned pages.
>>>> While we take into account the recorded page sizes to repair the
>>>> memory locations, a large page also needs to punch a hole in the
>>>> backend file to regenerate a usable memory, cleaning the HW
>>>> poisoned section. This is mandatory for hugetlbfs case for example.
>>>>
>>>> Signed-off-by: William Roche <william.roche@oracle.com>
>>>> ---
>>>>    system/physmem.c | 8 ++++++++
>>>>    1 file changed, 8 insertions(+)
>>>>
>>>> diff --git a/system/physmem.c b/system/physmem.c
>>>> index 3757428336..3f6024a92d 100644
>>>> --- a/system/physmem.c
>>>> +++ b/system/physmem.c
>>>> @@ -2211,6 +2211,14 @@ void qemu_ram_remap(ram_addr_t addr,
>>>> ram_addr_t length)
>>>>                    prot = PROT_READ;
>>>>                    prot |= block->flags & RAM_READONLY ? 0 : 
>>>> PROT_WRITE;
>>>>                    if (block->fd >= 0) {
>>>> +                    if (length > TARGET_PAGE_SIZE &&
>>>> fallocate(block->fd,
>>>> +                        FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE,
>>>> +                        offset + block->fd_offset, length) != 0) {
>>>> +                        error_report("Could not recreate the file
>>>> hole for "
>>>> +                                     "addr: " RAM_ADDR_FMT "@"
>>>> RAM_ADDR_FMT "",
>>>> +                                     length, addr);
>>>> +                        exit(1);
>>>> +                    }
>>>>                        area = mmap(vaddr, length, prot, flags, 
>>>> block->fd,
>>>>                                    offset + block->fd_offset);
>>>>                    } else {
>>>
>>> Ah! Just what I commented to patch #3; we should be using
>>> ram_discard_range(). It might be better to avoid the mmap() completely
>>> if ram_discard_range() worked.
>>
> 
> Hi!
> 
>>
>> I think you are referring to ram_block_discard_range() here, as
>> ram_discard_range() seems to relate to VM migrations, maybe not a VM 
>> reset.
> 
> Please take a look at the users of ram_block_discard_range(), including 
> virtio-balloon to completely zap guest memory, so we will get fresh 
> memory on next access. It takes care of process-private and file-backed 
> (shared) memory.

The calls to madvise should take care of releasing the memory for the 
mapped area, and it is called for standard page sized memory.

>>
>> Remapping the page is needed to get rid of the poison. So if we want to
>> avoid the mmap(), we have to shrink the memory address space -- which
>> can be a real problem if we imagine a VM with 1G large pages for
>> example. qemu_ram_remap() is used to regenerate the lost memory and the
>> mmap() call looks mandatory on the reset phase.
> 
> Why can't we use ram_block_discard_range() to zap the poisoned page 
> (unmap from page tables + conditionally drop from the page cache)? Is 
> there anything important I am missing?

Or maybe _I'm_ missing something important, but what I understand is that:
    need_madvise = (rb->page_size == qemu_real_host_page_size());

ensures that the madvise call on ram_block_discard_range() is not done 
in the case off hugepages.
In this case, we need to call mmap the remap the hugetlbfs large page.

As I said in the previous email, recent kernels start to implement these 
calls for hugetlbfs, but I'm not sure that changing the mechanism of 
this ram_block_discard_range() function now is appropriate.
Do you agree with that ?


>>
>>
>>>
>>> And as raised, there is the problem with memory preallocation (where
>>> we should fail if it doesn't work) and ram discards being disabled
>>> because something relies on long-term page pinning ...
>>
>>
>> Yes. Do you suggest that we add a call to qemu_prealloc_mem() for the
>> remapped area in case of a backend->prealloc being true ?
> 
> Yes. Otherwise, with hugetlb, you might run out of hugetlb pages at 
> runtime and SIGBUS QEMU :(
> 
>>
>> Or as we are running on posix machines for this piece of code (ifndef
>> _WIN32) maybe we could simply add a MAP_POPULATE flag to the mmap call
>> done in qemu_ram_remap() in the case where the backend requires a
>> 'prealloc' ?  Can you confirm if this flag could be used on all systems
>> running this code ?
> 
> Please use qemu_prealloc_mem(). MAP_POPULATE has no guarantees, it's 
> really weird :/ mmap() might succeed even though MAP_POPULATE didn't 
> work ... and it's problematic with NUMA policies because we essentially 
> lose (overwrite) them.
> 
> And the whole mmap(MAP_FIXED) is an ugly hack. For example, we wouldn't 
> reset the memory policy we apply in 
> host_memory_backend_memory_complete() ... that code really needs a 
> rewrite to do it properly.

Maybe I can try to call madvise on hugepages too, only in this VM reset 
situation, and deal with the failure scenario of older kernels not 
supporting it... Leaving the behavior unchanged for every other 
locations calling this function.

But I'll need to verify these madvise effect on hugetlbfs on the latest 
upstream kernel and some older kernels too.



> 
> Ideally, we'd do something high-level like
> 
> 
> if (ram_block_discard_is_disabled()) {
>      /*
>       * We cannot safely discard RAM,  ... for example we might have
>       * to remap all guest RAM into vfio after discarding the
>       * problematic pages ... TODO.
>       */
>      exit(0);
> }
> 
> /* Throw away the problematic (poisoned) page. *./
> if (ram_block_discard_range()) {
>      /* Conditionally fallback to MAP_FIXED workaround */
>      ...
> }
> 
> /* If prealloction was requested, we really must re-preallcoate. */
> if (prealloc && qemu_prealloc_mem()) {
>      /* Preallocation failed .... */
>      exit(0);
> }
> 
> As you note the last part is tricky. See bwloe.
> 
>>
>> Unfortunately, I don't know how to get the MEMORY_BACKEND corresponding
>> to a given memory block. I'm not sure that MEMORY_BACKEND(block->mr) is
>> a valid way to retrieve the Backend object and its 'prealloc' property
>> here. Could you please give me a direction here ?
> 
> We could add a RAM_PREALLOC flag to hint that this memory has "prealloc" 
> semantics.
> 
> I once had an alternative approach: Similar to ram_block_notify_resize() 
> we would implement ram_block_notify_remap().
> 
> That's where the backend could register and re-apply mmap properties 
> like NUMA policies (in case we have to fallback to MAP_FIXED) and handle 
> the preallocation.
> 
> So one would implement a ram_block_notify_remap() and maybe indicate if 
> we had to do MAP_FIXED or if we only discarded the page.
> 
> I once had a prototype for that, let me dig ...

That would be great !  Thanks.

> 
>>
>> I can send a new version using ram_block_discard_range() as you
>> suggested to replace the direct call to fallocate(), if you think it
>> would be better.
>> Please let me know what other enhancement(s) you'd like to see in this
>> code change.
> 
> Something along the lines above. Please let me know if you see problems 
> with that approach that I am missing.


Let me check the madvise use on hugetlbfs and if it works as expected,
I'll try to implement a V2 version of the fix proposal integrating a 
modified ram_block_discard_range() function.

I'll also remove the page size information from the signal handlers
and only keep it in the kvm_hwpoison_page_add() function.

I'll investigate how to keep track of the 'prealloc' attribute to 
optionally use when remapping the hugepages (on older kernels).
And if you find the prototype code you talked about that would 
definitely help :)

Thanks a lot,
William.


