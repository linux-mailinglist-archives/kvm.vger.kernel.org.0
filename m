Return-Path: <kvm+bounces-39932-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DF9C7A4CDF7
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 23:14:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 280813AC4D3
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 22:14:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E8DE236A8E;
	Mon,  3 Mar 2025 22:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mwwMbcYA";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="yiO2VJyO"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 813D51754B;
	Mon,  3 Mar 2025 22:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741040064; cv=fail; b=sSKECRNZj0wYt/f2MqCAt9xcCBTHmeNdS8XAKoTvEtUAQzQeZmncYwTP3wwCJAtrqz6bb2tWtu13gXHLkqs6XJw0nllafQAM72G7R9SEMg2CcU++sB7L7O8qt1LbgAhgEJ+67ntFtmVNhUrzU2itkOP8e0u5QUT/slCBObdkWcI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741040064; c=relaxed/simple;
	bh=T6/+m59a2Mi3CrFFjCKFGLbOdkKnKy0ncWGQApJWzHI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GWq17dLDUGImzlNCrAJm91gr4Jrd0mfOgQwMHnL5ySe56h+JrwG+ux81shTArLz2wEUxmVA489mbNsPp0AfOPYpfpU3wlXrmN0jxLxbqo6taRXYHZ9w1k489yFeyDfOgaWgDjINva6B1eneQKgxMSF7J+NN7X+iXfBtXFMIHiII=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mwwMbcYA; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=yiO2VJyO; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 523M8Lf4016111;
	Mon, 3 Mar 2025 22:13:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=hJxzGIfk1SGrcydlKkNe8owpc9cxYeTtzuL3nt5DwhM=; b=
	mwwMbcYAA+aZj2D3h3fR/KXznqlMK8ZR0r2fF4AGFu6mAD1IGmFjo3fcK44m05bp
	jjJlXESzoOZwgD3r1sLZNqiog7YkZesqC3g/FeYztFkd9y1WVjFnhHivRoJQfn5c
	yQMN19rV3U3tNmiIxZQQzKnEPAebTBF7Qup51Hy5S0MdEIXVvMV17Uru+L8wEFsN
	x3iQ5yq1jI28UFMAg78jktOp3xH5fY0ogWAMcNK/khEhEQx6ZFmFC7OapOJAzvyq
	0milqg/vU2DyzUy+cD9zz50Os68MbChkiJxoZMcJBq/tqY1gzTB7xHHZJSAkyVq0
	fzyhleZ3cP/MLMPTRGaCKA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 453u86kqu8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Mar 2025 22:13:30 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 523M1Cbj019921;
	Mon, 3 Mar 2025 22:13:29 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 453rp9bu5r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Mar 2025 22:13:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D3/FTuI/ZCCXr5lebrUbyXL47aGs5Jo2SMnOqapjsvEvZdV8aC7xWB8np9upUpVOm36csAZZSG+pPUv798vuzQpAQDOUW4U46xJxukwxJL7vg+kbi8ArhICItaq4Z8WDmmaUQgR2beKoJMnI7rDSwMibIOg85ZLK5Spdp322SxvxICYmslJmGDE4/VaDKZGgedJ1l3DV9OqQXz9a7D49rkK91iKC6KlgoOYrcBl8SJjvdxhrm7c5leua+q2a4D+JzPFiWc7zKmbg6roZOYtuU+YjjJ02uCB8Zm5X8f1TwzK9cfoHyUh7FN+JHdjLcN47trSrrm9nIBuQudvyFFLBhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hJxzGIfk1SGrcydlKkNe8owpc9cxYeTtzuL3nt5DwhM=;
 b=cM8VWBHGo4S9OsTHB3vKT2/HhUsqoO48lhuTFy/zwy6Lki3FE27ug0JT3srSrgDInhCcQ4TqX2nqw0SkBlJ8I3BG5HR7osIOadN+VL+t+pU44c3ibM8l8YpJ9fRmVhBAsykkqNvUBYsktN8c5wNQ7D9nJoZupbwr+064z1Fru9WDJCMM8OqLGRiMxU/v+flqOC49ChskaNrLc5k4PaPzWuEzw4DmvVNJGJFB0qT9SjdUG8tK7aMMEHUbsKSLTAWs+9ElS46ZhKhtc5wCTvrnyrI3QY9LOCDpEQuZvogpQQEilCtwjpMn0mUhUDmU2gm/Dm/o7dAaOZfJnRxKWGvtXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hJxzGIfk1SGrcydlKkNe8owpc9cxYeTtzuL3nt5DwhM=;
 b=yiO2VJyOi+O6kmzdbnM0/iTTpcAXp796UD5Oqw1QyJ70KZjjk3c89SGOJJTJ6e83bp6wnf9T5nJV0T0QARCocKEYx8FYxD7DgNlSt+/82veQSb2md9wRgpGd/Ugj/eKRMpY7qR+DqdpzhFDOAP7wYnNARhLAimOPWlMOtR7+Yug=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by PH8PR10MB6359.namprd10.prod.outlook.com (2603:10b6:510:1be::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.27; Mon, 3 Mar
 2025 22:13:25 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::743a:3154:40da:cf90]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::743a:3154:40da:cf90%4]) with mapi id 15.20.8489.025; Mon, 3 Mar 2025
 22:13:25 +0000
Message-ID: <a81f9270-8fa8-4a05-a33a-901dd777a71f@oracle.com>
Date: Mon, 3 Mar 2025 17:13:21 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: alloc_pages_bulk: remove assumption of populating
 only NULL elements
To: Yunsheng Lin <linyunsheng@huawei.com>, Yishai Hadas <yishaih@nvidia.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
        Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
        Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
        Sandeep Dhavale <dhavale@google.com>, Carlos Maiolino <cem@kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
        Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>,
        Jeff Layton <jlayton@kernel.org>, Neil Brown <neilb@suse.de>,
        Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>,
        Tom Talpey <tom@talpey.com>
Cc: Luiz Capitulino <luizcap@redhat.com>,
        Mel Gorman <mgorman@techsingularity.net>,
        Dave Chinner
 <david@fromorbit.com>, kvm@vger.kernel.org,
        virtualization@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org,
        linux-nfs@vger.kernel.org
References: <20250228094424.757465-1-linyunsheng@huawei.com>
Content-Language: en-US
From: Chuck Lever <chuck.lever@oracle.com>
In-Reply-To: <20250228094424.757465-1-linyunsheng@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR13CA0059.namprd13.prod.outlook.com
 (2603:10b6:610:b2::34) To BN0PR10MB5128.namprd10.prod.outlook.com
 (2603:10b6:408:117::24)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN0PR10MB5128:EE_|PH8PR10MB6359:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a613a11-8015-4c9c-e5c9-08dd5aa09e68
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|921020|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?KzJaa0o3REZtNVdhelh0QUtGK2hNK3p5a1F5L0RoMHJHdG1rU1N0WnV0UzIy?=
 =?utf-8?B?dVFVeVplWmQyNWtQM0psNDM3QWdaQ3IvRFkxdE5HalY1elZYeHU2Z3Z0Nk1q?=
 =?utf-8?B?YkdqVlVxQUFrY293VExOZDBNSjErb1R6SUlvZFBPZ1h2dnY5Q0ZRdnVPSWtp?=
 =?utf-8?B?RTI3cFFkOG9PWkZGb1pub1dYcUVOL1diZkFKRjdSWFBGVjRFWXNGc3J4dmFi?=
 =?utf-8?B?QmZLd3JwRldtTFNUNWhENGhCckc1bHQwbVk4ZHhmYVA3ZlIvVWxRRXZFclJN?=
 =?utf-8?B?VVhYdzhCMjZ6citGTk1wNUdGWWZOK0g2OWN5aWI1MXdIVlZmVWl1VXB1TkI2?=
 =?utf-8?B?dzlscWlJb0xqMHl1bEN5R3hRVXhDa1QxS21DZEVHK3dGVHUrb1kzK0JlRndD?=
 =?utf-8?B?Z3RocFVWNU5pdXJIVGxZT1p4cWdUdnR6dnAxbzFLR1c3Z0pLTnpQTXJFWGRK?=
 =?utf-8?B?YXViRTUwNnNXKzd1Vks1cVNIcnBzUkVjSmhxSHVkcWJTdkN3dHFqbGxwaUxn?=
 =?utf-8?B?NFE5RGVLV3F1eGlPUDJYdksxaG9adlZ2TmhXQkdlVzRrM0JqNXZ5MWIydGg4?=
 =?utf-8?B?WWhhQWRTdWMxS1EzVWcrak9ZUnVidU9ESzBVRzJBci85S3VOUWczSzE5YUNK?=
 =?utf-8?B?SjUrSm45OUt5ZGdqUTJDSjh2NWt2UW9CUkVJREpSNXJxeDgzb2dWYXNvS21m?=
 =?utf-8?B?WXY0SzhJRHhxaVBMek04NldVUHYzb3pNcG4vS3FPSnpTVTQwa0JnbEFGVUpJ?=
 =?utf-8?B?TDFBcENUa0Q1Rzg0RHpLa0JVNTl6TDdMVW4wYVkrVDZLZkdxSEdJUEZ3bjc1?=
 =?utf-8?B?aTFaVlpidHJycXJFenpZbm1UVW5oTE9YODl1VzRJSjY3amtMTFRPYmJIQmVs?=
 =?utf-8?B?dGhwakJld3Y0UWNBSUd3eTVSODhxZllKSStXODVZNUhRZ3ZNSWVraHJJMFNE?=
 =?utf-8?B?QXdwZG1lOStMU1poV2tmSUNucy9CNzBEeG9mdDd2OHZhdElsVDdCUWtycnZY?=
 =?utf-8?B?OTVLOTBBWmdaN2hlSmRoZHhsYXhrS1FDWWwzODdabG0xKzYxS2thMisrclVR?=
 =?utf-8?B?K3FaT1ZMOWdvaVNkbElWZXJvUW40T29NbmY5TGYzbk15RVFwQXlPQXE1b1ND?=
 =?utf-8?B?NjZQSWRSN2cvdldpb1FiQ0JBWFJ6ck05ZE5wdUF0K2ZmY0U2L2hDblZuVWtz?=
 =?utf-8?B?eExzeGJEMThnL0NTR05Mc3BQRVFCcEdVaEZaRk5aOC81T2cxTWF5QlBjRlpi?=
 =?utf-8?B?VFd5bUc5eldaTVdtcUd4RERkL05GWnZiVkhCWE1iZlkyaW5hWUsySU1IYUtp?=
 =?utf-8?B?OU45eCs4aGVsQXpMMkFlNnBWSG12ZDhPTUZYS1hyOG1JUkZ6elIzOUs4bkNi?=
 =?utf-8?B?Ykl0eExjNU1GRWM5U3dSR3J0cmxUVHhPYjBkRE0rRDBhVEVNeGVRUWxRWmZL?=
 =?utf-8?B?b1g1UDg4cC9VU1BpQnQ3Z2p2UTNMSDBxZ2oycDhMM0k4MmZnR2NyMmR4YS9t?=
 =?utf-8?B?N3pBcTU0SWZhNHRuNkxKcUhVV2tqbnp5UFU2T28xZkRUQmNKTHJmdkVwZkZX?=
 =?utf-8?B?dFFmVEg5NnVVTi9na1FTUmFFdCs3WDBTV2ZvYTkxcGpJUWNIWnhyQTRpOGRp?=
 =?utf-8?B?UnQzcU80aXh1UU1lbEhFYjRzOGRKZEcrdDluVFlFaUNoajBZK0lKQktnTk5i?=
 =?utf-8?B?ckhIOFNNRCtTZUFEYWZlc2p3S01vV1hvZ05jUWsvTTMxcG91eGVFd2U1Tkx4?=
 =?utf-8?B?OU1ScFk5US9ycUlYbHpqeGtTeGNNSWQ1NE9iRXpSREZJRXl2OWtkSnlYbnp5?=
 =?utf-8?B?WDJUTVlNeFhQc0dZSiszNEpBbE5yTW4rWWVTMnlYTjEwakowNXBUTWl5S042?=
 =?utf-8?B?d0cwcjI5aXJadDJSMXNRMjJ2MURjNHVFSStnTXR5MlV0RmlLOFU0UXpiL2dx?=
 =?utf-8?Q?WeU+T9g/bZ/3x54OGt7zePSPlVDyMHER?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(921020)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TEJGaFdtWCtyZDBKWjZBR21sd09zSXMxQXpiWGZrb0pweUNBbXJIQmlUQi9x?=
 =?utf-8?B?SHk1VnB1UWY5NVRUdk9wRVZHUTlHTWpPZGtocGxjcGJKOHUzeStwMGVRUVZO?=
 =?utf-8?B?Y0JkSCt6RU5tOWVUdWh2OXBjNVRZcmlWYjRDTm93T0I5NHRwRXY0ZXN0Nkx6?=
 =?utf-8?B?WmJCdTZEK0lET0dzbCtZYWpHQjM5YU5EMjBIaDZYQ29qbnNTcjFJak0zTGdS?=
 =?utf-8?B?L2hVV0FjMnZPME10UFRHZS84aWdsRUVpR29PWVdNSS91YW9ZSWpiY1h1TUJR?=
 =?utf-8?B?R2JNdHZkSEU5c1N4WTVBOFhETE8vRlNUZ0FNMCtuMWVtNFU5TzNMOUxwQUVW?=
 =?utf-8?B?WGw5Sm50dng3TkN5Rmp6SlpiRVYvR3hCODVVNFR3RnVIbWJudWFuZFRrSG5B?=
 =?utf-8?B?ZG93REwzSm9vZHRGZ0huU3UvNWl4aWROa1lIMUw3Vk9GaGRKUXI1Z1JvSXBY?=
 =?utf-8?B?aEdEanFMekFxZnh1MzhrekZqbGxNblNTM2Y4VVhFZXVsbm93REM1bHFrQWN6?=
 =?utf-8?B?Z1VXSUhYVHRNQm1aRWl3V21rNllsamNiNnlleWJrNWc5UTIvc2E0QmxpVTht?=
 =?utf-8?B?T1I1N3ZJb1B2Zll3SHVRUmxSemwzNy8zaFV6QWl6VHVGVDNYNnc5RThJa29i?=
 =?utf-8?B?dDFHNldqYzhXbDk1Z0RWaTVaSmNMY1NhVkkwc0NPaU13ZVE3NXZRQjVxMll5?=
 =?utf-8?B?d01vSUZSZU9ERlVna2hOTWc4ZHZYYTlTZTlmUFh1eXVRYzhFLzZWS1VDRGpQ?=
 =?utf-8?B?c2MraWQ1amVpU3d0aE4yNklxNHdVTEJKSjNRMUdoOW1rcnRmV1hmczZmS3Fs?=
 =?utf-8?B?RFQyMVNYZXNIUFJvV2lCd0gwL25Sc0dVVmZCM0NydGwrYmRTRC9Eenh2eFl0?=
 =?utf-8?B?enpCZkE2WDhCOFBxNGtrS3NHT3RhczhNbDRBQjBpZHcya2QyTzdVTitQYlpH?=
 =?utf-8?B?VWh3djNETkZZWm5wMDhnN21RRURaRzF1SnovODl3UGRTOUE1SVVlcDBmLzZU?=
 =?utf-8?B?WGV5STFlN1ZIektxMVV6WXF1ME44WGFnekpJeXRXeXJmZmVZYXJYcDl6Wlc4?=
 =?utf-8?B?cFowaElFWndxbXk2K21ZRmVYbTluWVgvTnFjbG9zN0hjL2hpbUdPbjUyQml2?=
 =?utf-8?B?YkFCN1Z3ZU0wN3ZCMWt2TFJtSWh1OVAwSThwU1N2cnpWM0ZuOSszMHp2VXJM?=
 =?utf-8?B?WmNsaEthR1Z2OTZQTFNpMFQ5cTl6amgyK0RheXQyTCtLZ3BJZVpsdEc4TkNG?=
 =?utf-8?B?aGp5NU5IOElrakUyQzI4bU5obmtiQVVsK1ArajFHaGxRVGtDSGhuQ2NmR2pu?=
 =?utf-8?B?d3F6czZNZTU1NlBVVGFkcGRRbmxJSW9NTStrSkM2R3hhTXQwc0NyMTdqcUZv?=
 =?utf-8?B?TWtzYkhRQlhNYW10NVJQOTMyMEdkaUtoNUhwVUkydDNhL2krVXYwRURjbWh4?=
 =?utf-8?B?dW8xQzcxZEZoQXp6N1RrTmtPTTZ2SjZsVklEbmJUdXBQdDZzVHZGdEJlcU1t?=
 =?utf-8?B?L0ZlRXdqbUd4MnRNMGhDY285UlYrUGxpRlYwVEwzdzJQNFhJdmlzcTZaS0Rl?=
 =?utf-8?B?eWxaeXNzYjVKZ3FjN2oyODFYTU83aHF3ZmdSQkdYdmF4OVROd1QyTmdxcnJx?=
 =?utf-8?B?clc2elgzdEdjTFNRUGdZcThsYkVrY0Q3KzlIS3BUY011RmFoOGdkWFMvdSts?=
 =?utf-8?B?Wmt3UUhmWHN6TnVlcmZXaE9ScGpqTHhLb0JSOTBicUpKUmNJZUErRkwyVnBK?=
 =?utf-8?B?QklPTVUvRXlqa1R1ZkJKNEhnaTNSM3JoeGdxS3ZJT2ZKa0JYSnRGRi9kbmty?=
 =?utf-8?B?ZXBXQ3hyQldQdm80OGYwdTJ6dXBLdnhDNTF0UEwvcG5iaDZxNE5YdU1ubFJn?=
 =?utf-8?B?MUhpS2NINHNMTGxRVlNYUmZQbis5ZmJHMjd1OWJZYUVpK3VKT1gxM01ZZ1Bw?=
 =?utf-8?B?TWtkMSszZCswaXl6cGh0ZGIrSXlNWHljbk10NHNSM29SbFJVM3FMTi9YN2RH?=
 =?utf-8?B?K3dQN1F0eVJRMHVRZlVVRitBVmN2aGVpRXYxajkydkNBSnFkbG5tdW1Hb0RB?=
 =?utf-8?B?UmpOWkRZNVNUSTF4aG01SDdockxvMTBVdE1qR3g4L0ZuMVNlbzZxQ0g3cTI4?=
 =?utf-8?Q?c2eLlnWaadd6YqbAB00/gu18S?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	oaqp4scXJkzMx3bjBWWmcRK3MCVKIFrY/rEeqk8VhqlbBiZ7v2FsKrGFew/Fx//5m+osFNbNs+8kQ0ODKRAaAYcukWxm6Ezo61/gVhvTbAqEBHvtPQ153bjbDnz65QOVx25izaY0KzVpzTXa4Qu2yC+F/ENNmLD0lw2a9kyp9/bvkgpnHZ6Q3LBydGFXGj8X4SW8v0rrTqgP6I2QDsMl7GUwP6bpmmDnVya2darYwWz/dUlKjKEHg9Anqxg0iJGN9QDMK1EuMnpNDMbEACcyYaNPEciZMSkG8ahj4pC6y09JIZpdpN2U1kAFEzb0zKqn1Ei4F0P6ijO3Pam9KEvx5CtAlIVvzVYy5EapBxbtlSbJ+gAEQL3tlpH+eJj6eowZ6MrFqXQgSdT6qLyytxuDEbTt0IqUEER5o5eoEO/vEjlpC+NIBldT9LWMy+g2ESG5Vp3ajRyauLy+cz2xgWjqKQ5bO4AjFyUMJKwFyIT6/guMAOpD7pNYbav++7XCBg7MExz1emrlbdK5oVU2fpZN4TrvjfKWXkDUJ84JgRCDUUHnXt521ZW6744A/Rl4jHHqIAtlfTWY1iPnxmrHwjXeeaU34nOXpm88+3HHkXX/K6A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a613a11-8015-4c9c-e5c9-08dd5aa09e68
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2025 22:13:25.6550
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cq+764QZwX9IwseTyS4aOlrDfd+mXKDM2o76ewQOCSwbdpokf61/osaiKl8mOkEeiotCa61rJQGp9ZtmH0aDCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6359
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-03_11,2025-03-03_04,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 phishscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2503030173
X-Proofpoint-ORIG-GUID: SkK58GMLdKp2lWDovqnshws3geEDpXEr
X-Proofpoint-GUID: SkK58GMLdKp2lWDovqnshws3geEDpXEr

On 2/28/25 4:44 AM, Yunsheng Lin wrote:
> As mentioned in [1], it seems odd to check NULL elements in
> the middle of page bulk allocating, and it seems caller can
> do a better job of bulk allocating pages into a whole array
> sequentially without checking NULL elements first before
> doing the page bulk allocation for most of existing users.

Sorry, but this still makes a claim without providing any data
to back it up. Why can callers "do a better job"?


> Through analyzing of bulk allocation API used in fs, it
> seems that the callers are depending on the assumption of
> populating only NULL elements in fs/btrfs/extent_io.c and
> net/sunrpc/svc_xprt.c while erofs and btrfs don't, see:
> commit 91d6ac1d62c3 ("btrfs: allocate page arrays using bulk page allocator")
> commit d6db47e571dc ("erofs: do not use pagepool in z_erofs_gbuf_growsize()")
> commit c9fa563072e1 ("xfs: use alloc_pages_bulk_array() for buffers")
> commit f6e70aab9dfe ("SUNRPC: refresh rq_pages using a bulk page allocator")
> 
> Change SUNRPC and btrfs to not depend on the assumption.
> Other existing callers seems to be passing all NULL elements
> via memset, kzalloc, etc.
> 
> Remove assumption of populating only NULL elements and treat
> page_array as output parameter like kmem_cache_alloc_bulk().
> Remove the above assumption also enable the caller to not
> zero the array before calling the page bulk allocating API,
> which has about 1~2 ns performance improvement for the test
> case of time_bench_page_pool03_slow() for page_pool in a
> x86 vm system, this reduces some performance impact of
> fixing the DMA API misuse problem in [2], performance
> improves from 87.886 ns to 86.429 ns.
> 
> 1. https://lore.kernel.org/all/bd8c2f5c-464d-44ab-b607-390a87ea4cd5@huawei.com/
> 2. https://lore.kernel.org/all/20250212092552.1779679-1-linyunsheng@huawei.com/
> CC: Jesper Dangaard Brouer <hawk@kernel.org>
> CC: Luiz Capitulino <luizcap@redhat.com>
> CC: Mel Gorman <mgorman@techsingularity.net>
> CC: Dave Chinner <david@fromorbit.com>
> CC: Chuck Lever <chuck.lever@oracle.com>
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> Acked-by: Jeff Layton <jlayton@kernel.org>
> ---
> V2:
> 1. Drop RFC tag and rebased on latest linux-next.
> 2. Fix a compile error for xfs.
> 3. Defragmemt the page_array for SUNRPC and btrfs.
> ---
>  drivers/vfio/pci/virtio/migrate.c |  2 --
>  fs/btrfs/extent_io.c              | 23 +++++++++++++++++-----
>  fs/erofs/zutil.c                  | 12 ++++++------
>  fs/xfs/xfs_buf.c                  |  9 +++++----
>  mm/page_alloc.c                   | 32 +++++--------------------------
>  net/core/page_pool.c              |  3 ---
>  net/sunrpc/svc_xprt.c             | 22 +++++++++++++++++----
>  7 files changed, 52 insertions(+), 51 deletions(-)

52:51 is not an improvement. 1-2 ns is barely worth mentioning. The
sunrpc and btrfs callers are more complex and carry duplicated code.

Not an outright objection from me, but it's hard to justify this change.


> diff --git a/drivers/vfio/pci/virtio/migrate.c b/drivers/vfio/pci/virtio/migrate.c
> index ba92bb4e9af9..9f003a237dec 100644
> --- a/drivers/vfio/pci/virtio/migrate.c
> +++ b/drivers/vfio/pci/virtio/migrate.c
> @@ -91,8 +91,6 @@ static int virtiovf_add_migration_pages(struct virtiovf_data_buffer *buf,
>  		if (ret)
>  			goto err_append;
>  		buf->allocated_length += filled * PAGE_SIZE;
> -		/* clean input for another bulk allocation */
> -		memset(page_list, 0, filled * sizeof(*page_list));
>  		to_fill = min_t(unsigned int, to_alloc,
>  				PAGE_SIZE / sizeof(*page_list));
>  	} while (to_alloc > 0);
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index f0a1da40d641..ef52cedd9873 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -623,13 +623,26 @@ int btrfs_alloc_page_array(unsigned int nr_pages, struct page **page_array,
>  			   bool nofail)
>  {
>  	const gfp_t gfp = nofail ? (GFP_NOFS | __GFP_NOFAIL) : GFP_NOFS;
> -	unsigned int allocated;
> +	unsigned int allocated, ret;
>  
> -	for (allocated = 0; allocated < nr_pages;) {
> -		unsigned int last = allocated;
> +	/* Defragment page_array so pages can be bulk allocated into remaining
> +	 * NULL elements sequentially.
> +	 */
> +	for (allocated = 0, ret = 0; ret < nr_pages; ret++) {
> +		if (page_array[ret]) {
> +			page_array[allocated] = page_array[ret];
> +			if (ret != allocated)
> +				page_array[ret] = NULL;
> +
> +			allocated++;
> +		}
> +	}
>  
> -		allocated = alloc_pages_bulk(gfp, nr_pages, page_array);
> -		if (unlikely(allocated == last)) {
> +	while (allocated < nr_pages) {
> +		ret = alloc_pages_bulk(gfp, nr_pages - allocated,
> +				       page_array + allocated);
> +		allocated += ret;
> +		if (unlikely(!ret)) {
>  			/* No progress, fail and do cleanup. */
>  			for (int i = 0; i < allocated; i++) {
>  				__free_page(page_array[i]);
> diff --git a/fs/erofs/zutil.c b/fs/erofs/zutil.c
> index 55ff2ab5128e..1c50b5e27371 100644
> --- a/fs/erofs/zutil.c
> +++ b/fs/erofs/zutil.c
> @@ -85,13 +85,13 @@ int z_erofs_gbuf_growsize(unsigned int nrpages)
>  
>  		for (j = 0; j < gbuf->nrpages; ++j)
>  			tmp_pages[j] = gbuf->pages[j];
> -		do {
> -			last = j;
> -			j = alloc_pages_bulk(GFP_KERNEL, nrpages,
> -					     tmp_pages);
> -			if (last == j)
> +
> +		for (last = j; last < nrpages; last += j) {
> +			j = alloc_pages_bulk(GFP_KERNEL, nrpages - last,
> +					     tmp_pages + last);
> +			if (!j)
>  				goto out;
> -		} while (j != nrpages);
> +		}
>  
>  		ptr = vmap(tmp_pages, nrpages, VM_MAP, PAGE_KERNEL);
>  		if (!ptr)
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index 5d560e9073f4..b4e95b2dd0f0 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -319,16 +319,17 @@ xfs_buf_alloc_pages(
>  	 * least one extra page.
>  	 */
>  	for (;;) {
> -		long	last = filled;
> +		long	alloc;
>  
> -		filled = alloc_pages_bulk(gfp_mask, bp->b_page_count,
> -					  bp->b_pages);
> +		alloc = alloc_pages_bulk(gfp_mask, bp->b_page_count - filled,
> +					 bp->b_pages + filled);
> +		filled += alloc;
>  		if (filled == bp->b_page_count) {
>  			XFS_STATS_INC(bp->b_mount, xb_page_found);
>  			break;
>  		}
>  
> -		if (filled != last)
> +		if (alloc)
>  			continue;
>  
>  		if (flags & XBF_READ_AHEAD) {
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index f07c95eb5ac1..625d14ee4a41 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -4599,9 +4599,6 @@ static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
>   * This is a batched version of the page allocator that attempts to
>   * allocate nr_pages quickly. Pages are added to the page_array.
>   *
> - * Note that only NULL elements are populated with pages and nr_pages
> - * is the maximum number of pages that will be stored in the array.
> - *
>   * Returns the number of pages in the array.
>   */
>  unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
> @@ -4617,29 +4614,18 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
>  	struct alloc_context ac;
>  	gfp_t alloc_gfp;
>  	unsigned int alloc_flags = ALLOC_WMARK_LOW;
> -	int nr_populated = 0, nr_account = 0;
> -
> -	/*
> -	 * Skip populated array elements to determine if any pages need
> -	 * to be allocated before disabling IRQs.
> -	 */
> -	while (nr_populated < nr_pages && page_array[nr_populated])
> -		nr_populated++;
> +	int nr_populated = 0;
>  
>  	/* No pages requested? */
>  	if (unlikely(nr_pages <= 0))
>  		goto out;
>  
> -	/* Already populated array? */
> -	if (unlikely(nr_pages - nr_populated == 0))
> -		goto out;
> -
>  	/* Bulk allocator does not support memcg accounting. */
>  	if (memcg_kmem_online() && (gfp & __GFP_ACCOUNT))
>  		goto failed;
>  
>  	/* Use the single page allocator for one page. */
> -	if (nr_pages - nr_populated == 1)
> +	if (nr_pages == 1)
>  		goto failed;
>  
>  #ifdef CONFIG_PAGE_OWNER
> @@ -4711,24 +4697,16 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
>  	/* Attempt the batch allocation */
>  	pcp_list = &pcp->lists[order_to_pindex(ac.migratetype, 0)];
>  	while (nr_populated < nr_pages) {
> -
> -		/* Skip existing pages */
> -		if (page_array[nr_populated]) {
> -			nr_populated++;
> -			continue;
> -		}
> -
>  		page = __rmqueue_pcplist(zone, 0, ac.migratetype, alloc_flags,
>  								pcp, pcp_list);
>  		if (unlikely(!page)) {
>  			/* Try and allocate at least one page */
> -			if (!nr_account) {
> +			if (!nr_populated) {
>  				pcp_spin_unlock(pcp);
>  				goto failed_irq;
>  			}
>  			break;
>  		}
> -		nr_account++;
>  
>  		prep_new_page(page, 0, gfp, 0);
>  		set_page_refcounted(page);
> @@ -4738,8 +4716,8 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
>  	pcp_spin_unlock(pcp);
>  	pcp_trylock_finish(UP_flags);
>  
> -	__count_zid_vm_events(PGALLOC, zone_idx(zone), nr_account);
> -	zone_statistics(zonelist_zone(ac.preferred_zoneref), zone, nr_account);
> +	__count_zid_vm_events(PGALLOC, zone_idx(zone), nr_populated);
> +	zone_statistics(zonelist_zone(ac.preferred_zoneref), zone, nr_populated);
>  
>  out:
>  	return nr_populated;
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index acef1fcd8ddc..200b99375cb6 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -544,9 +544,6 @@ static noinline netmem_ref __page_pool_alloc_pages_slow(struct page_pool *pool,
>  	if (unlikely(pool->alloc.count > 0))
>  		return pool->alloc.cache[--pool->alloc.count];
>  
> -	/* Mark empty alloc.cache slots "empty" for alloc_pages_bulk */
> -	memset(&pool->alloc.cache, 0, sizeof(void *) * bulk);
> -
>  	nr_pages = alloc_pages_bulk_node(gfp, pool->p.nid, bulk,
>  					 (struct page **)pool->alloc.cache);
>  	if (unlikely(!nr_pages))
> diff --git a/net/sunrpc/svc_xprt.c b/net/sunrpc/svc_xprt.c
> index ae25405d8bd2..80fbc4ffef6d 100644
> --- a/net/sunrpc/svc_xprt.c
> +++ b/net/sunrpc/svc_xprt.c
> @@ -663,9 +663,23 @@ static bool svc_alloc_arg(struct svc_rqst *rqstp)
>  		pages = RPCSVC_MAXPAGES;
>  	}
>  
> -	for (filled = 0; filled < pages; filled = ret) {
> -		ret = alloc_pages_bulk(GFP_KERNEL, pages, rqstp->rq_pages);
> -		if (ret > filled)
> +	/* Defragment the rqstp->rq_pages so pages can be bulk allocated into
> +	 * remaining NULL elements sequentially.
> +	 */
> +	for (filled = 0, ret = 0; ret < pages; ret++) {
> +		if (rqstp->rq_pages[ret]) {
> +			rqstp->rq_pages[filled] = rqstp->rq_pages[ret];
> +			if (ret != filled)
> +				rqstp->rq_pages[ret] = NULL;
> +
> +			filled++;
> +		}
> +	}
> +
> +	for (; filled < pages; filled += ret) {
> +		ret = alloc_pages_bulk(GFP_KERNEL, pages - filled,
> +				       rqstp->rq_pages + filled);
> +		if (ret)
>  			/* Made progress, don't sleep yet */
>  			continue;
>  
> @@ -674,7 +688,7 @@ static bool svc_alloc_arg(struct svc_rqst *rqstp)
>  			set_current_state(TASK_RUNNING);
>  			return false;
>  		}
> -		trace_svc_alloc_arg_err(pages, ret);
> +		trace_svc_alloc_arg_err(pages, filled);
>  		memalloc_retry_wait(GFP_KERNEL);
>  	}
>  	rqstp->rq_page_end = &rqstp->rq_pages[pages];


-- 
Chuck Lever

