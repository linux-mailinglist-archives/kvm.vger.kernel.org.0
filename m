Return-Path: <kvm+bounces-42787-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 809BAA7D0BD
	for <lists+kvm@lfdr.de>; Sun,  6 Apr 2025 23:42:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 480A87A4652
	for <lists+kvm@lfdr.de>; Sun,  6 Apr 2025 21:41:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FB3E2192F8;
	Sun,  6 Apr 2025 21:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eEPQ7g4H";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="i/nXYqzf"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B1B223CB;
	Sun,  6 Apr 2025 21:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743975715; cv=fail; b=N9gBTMmcxjd6K6t+ckCYq9heVULYOhpX2btWRmklL5WDTcELJl+dUCURcFPfbc6U67hR9OMGwCg8Gv27a/BBI/jSlEUtlFvuLp7DpvLx103hybSpWfyDLBpddbgS5lSeRb5eh6nrTACr9NX3ffBq/wDX/WhhinwPUlskCPrMGS0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743975715; c=relaxed/simple;
	bh=e2SPy0BAS2lmdgSucNin4vnFNNtSPnCrwZ6cSWRDkbU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ayZv/6eq8RpxUVmI7mm+0PnYxvAXuYGe7sQWf3kKv8JrcTuhl8HoXxTy0ZXqoThW2ud7F6U4d2G6dn7vOipqc4sjquoh9lOdPvJisW+Pb84qe6j1K41/ojwyRuU3cpcs/mm40xzAgKMt/m13nKSn6HBguHe748zLB7hxPep/5Jo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=eEPQ7g4H; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=i/nXYqzf; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 536LbZUw009172;
	Sun, 6 Apr 2025 21:41:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=519eD6+CWT4Rn2l2Bdg0MMuOktvVPYycXGb/JyxmfGo=; b=
	eEPQ7g4HqoMoAlFVktK0kMq0a2udGZtoxi6nukm87ebvzcCU1vUubCs4Q6/aFmS+
	QGnXOzw5jk8q03Diyw5XNfAgewubegUAFNVc4s46LaTesnRoQ/uBhW0d6gGv0z7M
	32mzUDJhg93f+HEek3gYm7yAYUFgm+KlmB6koPfZKLaJTki7gOXHd6Iu7g0P9cn1
	yJwRf+SuzLo7WkNeEfxn7L34ybJv3OiTVPi/6ds05IH4dQl0nNl7jnlQzQYeJeyG
	76iFRqF4IhMCdhm5Y57gMxp6zBdiWA6eLACb31LHFRI3DNGlBlsdjIk9pM0OZDlC
	b8SobCGdhioiU26+3rsJzw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45tw2thf0h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 06 Apr 2025 21:41:40 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 536HRbb6016263;
	Sun, 6 Apr 2025 21:41:40 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2043.outbound.protection.outlook.com [104.47.74.43])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45tty70vqv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 06 Apr 2025 21:41:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zHasL5Q9qTo3EcySImEfxOXpRFiVHMv47rBdvMQV4K8LIGyUtuzxEMrORco6GmqOp6Pa/cskmDEtjojY/dQpQHec43ctU5FSlpJRvytp7a2hRkwhTDwEUlY8QyE6+cpjUqEFgZUCKWMhTaogkPPYOIzk7TC5YNKX68X3WBTY0AUCb9HT+YyZfxV4vE7UXzO/5QdhEACIeE/i546wtLpM37n0Wk00s/gN5jkm3dYbpenUHRzp5A2E47PW66axDSY6fEu4mwzwp3l71+Lt+qj4c9CHY3Pk594t2fVYaHCAqd3kaaOFT5WYLEVQ9r8RBjeoWwp7Lp1ZUTyDzzigkRDU0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=519eD6+CWT4Rn2l2Bdg0MMuOktvVPYycXGb/JyxmfGo=;
 b=PiU/Gy+W5e/+DO+UWTtp6UPCboUcF5dGymINjuDYJOloCgHPgJuNyBwQbL6pfdj6zhG30CrFupRn7dQaOOULuTMO8FqkxB3NWht5UOq89+9/h7GLSStEWI6W0XzjD/oYO4+A5P44ABMkU5GOTjcrhr6y9EbaLlEy2LWIxUyqRWPfdqG/QleWdG0MZtrAmYq1lOX3VahIxI5256DsWROLzKHKxX2noMYDWH5lKalQZUPfMeSDp6E0bCuOevKfL30DPhrfXvF/U58TmX+lw0gwd0QnG92go/0QDPqHJmug36aRQY4twbryFP8KbZJA7vKp+RyyAjrTkXb8II5MaRABxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=519eD6+CWT4Rn2l2Bdg0MMuOktvVPYycXGb/JyxmfGo=;
 b=i/nXYqzf6fowb/F+RGgOgPB6y5YdRjkkaQioHMW0WNkRE4RD53sOVpS7+cCIb7DdoEHJI2+saKVVLq64GqWHdqeRdbhQZdDBBAx4xc+cfbSLU7TJNx7Ie6BSW7jpSN0iJ7sa2PodNrRZtFtBp2LsCpqts0DS/E/eqnbE4CeLJkE=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by SJ0PR10MB5664.namprd10.prod.outlook.com (2603:10b6:a03:3e2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.42; Sun, 6 Apr
 2025 21:41:37 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%5]) with mapi id 15.20.8606.029; Sun, 6 Apr 2025
 21:41:37 +0000
Message-ID: <eafb0c10-3393-4372-bf2c-7cc7d2a7b11a@oracle.com>
Date: Sun, 6 Apr 2025 16:41:35 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 6/9] vhost-scsi: log I/O queue write descriptors
To: Dongli Zhang <dongli.zhang@oracle.com>, virtualization@lists.linux.dev,
        kvm@vger.kernel.org, netdev@vger.kernel.org
Cc: mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com,
        stefanha@redhat.com, eperezma@redhat.com, joao.m.martins@oracle.com,
        joe.jin@oracle.com, si-wei.liu@oracle.com,
        linux-kernel@vger.kernel.org
References: <20250403063028.16045-1-dongli.zhang@oracle.com>
 <20250403063028.16045-7-dongli.zhang@oracle.com>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20250403063028.16045-7-dongli.zhang@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0217.namprd03.prod.outlook.com
 (2603:10b6:5:3ba::12) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|SJ0PR10MB5664:EE_
X-MS-Office365-Filtering-Correlation-Id: e2609861-a3b3-4151-4ef8-08dd7553ceea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?SHpWUVpBYW04a1BYbTIzb1V0YzY0ZmRaWlZycXlQZjVya0VHVFdLMmRYbmo5?=
 =?utf-8?B?RFE1UGVnam1rNUdFd051N0RWbXphRGkwc2tMSmRRZ25UdW1lM0xLSmUwOXpX?=
 =?utf-8?B?UTdZV1dSM1k5VUVnczcwL2hJUzJNb1pFc09CVTVaNmFzSDB3dkl5bGp4VWxq?=
 =?utf-8?B?U3ZQL3JMRGNRbEtnRldxSU1CK28ycTB6bXp0L1BsOXJHNllQeDFjUG5zMnU2?=
 =?utf-8?B?UDN1YmZ4T2hLYVJHSWk3THR0ZWtyWnZ3VXpqK1FaRzMvNm1GVEphcitkTDlv?=
 =?utf-8?B?WkM3R1NaaW5aT0t1OER0ZHIrb0Ric2JHaStZWkVITW9XdXRneDRXL2VrWUln?=
 =?utf-8?B?bW5zcGx2MFR3ZHFrUXEyQ09DQVNwdHNLdzJMT2RQSFhqU0w2YVJpTlNKKzRF?=
 =?utf-8?B?TzZCSlZVSXh0UmNHQ3loTytRa1JhNVIvZFdDRVU0dElKekxHeEgxNkNGRFo4?=
 =?utf-8?B?UEpIaG02RVlHVFE4aWw3bHNNZHVWcmNrRGNVZFpEMUNGODNnY0Q0SHcxa3cw?=
 =?utf-8?B?TmQ0TzRyWmVaOVJxeXd5MUFGRElVVEpJZHo0ZFI4ZXl4Uk1leC84NHlTc3M2?=
 =?utf-8?B?SzNuQStKOHh6Q1lJUDZreUZ6NUsyYXhaVllNVmQybzFiemEvVml4N2FzUnJK?=
 =?utf-8?B?czdxb1ExV3U5U1dBVGxvTENvaEVsUXNuUzA0Q0F3R1B0dDlQaUJUWW15dXVF?=
 =?utf-8?B?b3YwYnpyaXVpUDExVWQwUitNUTdGcWhaSjcxWWJXbG5CcUlra2xmMHhHUWJa?=
 =?utf-8?B?YXZZeFRGaWNvaFFzUkd1T1FvNWFoc2R0eEgwZURFdmhVcHlhZ1BneFZsZjlu?=
 =?utf-8?B?YVFnODdoc1U3OWRXUFpXT0ZwWHF0OWNTVjBlamtHazhXeWR2a2pUaDBLbWpV?=
 =?utf-8?B?TURFQmtrK3k5akt1QXFoSmg5a2dFVzJCT25IdFlnbC9uUGx6VGVTVDJRQUdQ?=
 =?utf-8?B?T2dBS09zZFZTdDNOc2RUSlBVc0M3Tyt0TGZxWGdUbFlIMS9NY2V6cWxaWVRB?=
 =?utf-8?B?eWZJMm13VEFPcW9mdTdSZG50YmRvNHMvVFFKYWU0QVBGN280NDh3UTdRWWxF?=
 =?utf-8?B?cWxxbjN2UmRmWXdhK3NlUWM1a1VOcE1pcTkxTVJ4c1JLb3gyejhUeEw0YThq?=
 =?utf-8?B?YlVCUHlQYVh2dU9JaEU3T0xBWmsvYUlFdmxHWUczOFJmaC9nRm04K05GZ0xH?=
 =?utf-8?B?azJQZ25FanRLaUxlWDQ0WFdIWllENlNWTmJhUFZIWU1GREFMQ09MUEpHK0sz?=
 =?utf-8?B?WllNd3dzbnVUOUtmalM0MThTMHg0T2NWenBCbTRBUjVmWUF1S2tpVDZVazUy?=
 =?utf-8?B?TW15Q21EV3hsSE43dEJKaGx0ekw4d1RtRTlWT2JTNGtYQjdhdWZQdEdobFlr?=
 =?utf-8?B?aS9oSXZieXgzMW16RHl5YjNyWjJGTDNTWGhGVyt4NEUxMEZsSVRqbWk1a2F4?=
 =?utf-8?B?c1hlYzN0T3h1ODR3OFRDeFFUZ3R1YnV5K3c1MmgxbzRjZThNeUNTMHVpZklv?=
 =?utf-8?B?QjdTaVJpMHFVak9HZWFBR2xiYkM0bExRWmxrMnVQa0ltVjk3cGpTdGJWVE9N?=
 =?utf-8?B?bmdSbWtVUUVIRVJGQzNheVVnMGdVVmdaRTMvOTZXSGY2eTIrQkhFZW1ISERm?=
 =?utf-8?B?RUk0a051NnlyaTNjcnFLcUIzUE9TK21ocTlkUVdKaEVuSDFKNU5DVU1WbnN6?=
 =?utf-8?B?ZElEUnJvRWFDM0pRL0NrUVRvdU0ya0M1bysxemJNVll2UWdocExoSm1oQlY1?=
 =?utf-8?B?Yk02Z0FBalpEWm9IanoyTjZaREFEK2hSeDRrSzM5QlRRa0RiMHNIM00vMkJs?=
 =?utf-8?B?R0J6K0JOUjJOaFlpWlJzS1R6V0ZUT0NLR3lmbTUvOTU0Zis2WGtGTVZEOElT?=
 =?utf-8?B?Y2JSRUVDeW94VVFrY1pseXRGcFh0MTl6UGl5Rmg4U1VObXI4TGJSQkVqN085?=
 =?utf-8?Q?zZmoAuxZ3O8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?THFCSUFPNkIzVkVzeGNYTEJoZFJjaGVuWEJ3NjFWSlFZQ0xhU0NrQXNPWHBT?=
 =?utf-8?B?cGJPbGtMbWYzVnQ3WGdLZlFVaVdyYkU0VFhwT0JzdzBPRUNySjB6dUlqcG9B?=
 =?utf-8?B?OTB2ZkF4eGsxYUZWeXJsUUtJQ1dodmEwcGlhTFNOYVVzWnhTVWo0RnlIQ2dq?=
 =?utf-8?B?UkRkdHQwWUx0VzVzT0MrU1RjcUcvZkQvMzBoTldzaXd6azNnZHJOV0pENWZp?=
 =?utf-8?B?Q2VqOGliQlN4TklNMnNlK3d5b24relEybmZDRDJ0VjhzZFliQjhyK3VPOWk4?=
 =?utf-8?B?dG10YmhUVm0xeW9QY3ZCMGo2ZXp2a1FmVjFJNjl1SHZLblc2YklqUno2YmFZ?=
 =?utf-8?B?U0w5aStzTVg2ZmN6QTFqcjNTNW1CNVR4bUtySzMwdDhWSEQrVzJtZzFaT2sw?=
 =?utf-8?B?dTl2UGllZ1FOa3dwZUIvbFdVcllCNFJGWkc0eFhSdUt2QnI1VmppdGkrTFpx?=
 =?utf-8?B?K1ZIbzRSeUxwOGF0VEpUNGU3azBadVdoQ0hCUlFZR0pxYXA1bW5FK0NyTGVE?=
 =?utf-8?B?VHlqUW9yVVdSVXNVNG9wdDVKM3hyekczZFY0MjFXcFY1U3BkUm14Z1c4ZXNa?=
 =?utf-8?B?akxFTTZBeG05d0I1RWpiSWl0ZFJ6c3p5b2NDNmF3cjdOSVV0OWFuMWRCYU40?=
 =?utf-8?B?N0oxNEhBRnV1RHp6WC9Td3ZzeVJkZ3VaMnE4QUJYdnFkNUtLdUlPTmNsRkdX?=
 =?utf-8?B?K013QTV3V0xwczhzbUtoR3M2d0NzTU1PeXdMdTd0REVsZ0ZiSkRnTWVSLzZK?=
 =?utf-8?B?cG5QMzF6Z28wNnZJdmhYVzVHZWFVeGFEanU5bWtxWmdXdlIvNm5BRWNMdjI4?=
 =?utf-8?B?QjV1c3R2QkVzWnkxeDdkdzM1K3NnNVoza01CZmVSdHgwK2RYVXNVMENnbkxn?=
 =?utf-8?B?a01WN1RYcjE4dkkyWk1FUWJqck9sbzl3QjVPbHBOekZDZzRmVGwxdE9TVW0r?=
 =?utf-8?B?Z29hMUMrdnhTR2NuSXpPbGw4cEt4R2twYnRLUG11RmRGdk8ybHVEOVp6c2Fx?=
 =?utf-8?B?cFRTQXhva1NIMndIMVJma0RlZ1d0NmQrNkRjSjFrV3FKbjFPenVTM0NsdXYw?=
 =?utf-8?B?ekdjdHEvcjdZRDBJUWY5bXI0RVR2d0xCOXU2aFVFRE9vakVuQkJVbTB2THo0?=
 =?utf-8?B?YWdPSlpUMnJ0ajZTZW82eDJydi9rMnZ4VFduY1I3ZElod2ZYc1ZwYTFyWFU2?=
 =?utf-8?B?V2dhdi9Nb2x6dXIwOFpROGFSdnZxR2RLNkVaNjdjMGRoNmVSQkpNQzg4RG54?=
 =?utf-8?B?akVYMmV5NTM4SXJrSXh2VXlqU3N0SDcyQzdaMWs2Z1pwNGI5VVNxQi96ajly?=
 =?utf-8?B?Wkl3V2NlUU01MWhFNnhyM3FnN2VBZmJqYTVUMnRwUWVNVjJVVXU5a1hjM0w1?=
 =?utf-8?B?Uk5WV3lFKzlQUXRvdUR1dWxDZzNEZWZ4a1RYMzVBc2RjSGVvRTVOOUEwazIy?=
 =?utf-8?B?N1BZSVpnUW9uVklRR1hsRVlIZWF4N1pDWHE4bGFxd21waTMrY0ZSTUVBUFlW?=
 =?utf-8?B?S29HeWhmWWdlYTNlYlJpN0F1YjFMSU92WnF0WWZxL1dXN3pQcUwxV3BvN0FY?=
 =?utf-8?B?MDVhQ1p2RjRMdEVlVVVwUFVnNlMrUHI3OFZIZnNhQUlFYWI2YkJxaGoyOTkv?=
 =?utf-8?B?ei9kTXBlWVNmcEJraitXbTZLdmJjY3Rqb21PejFLbWVwY1BsWDZ0S1ZUQjhw?=
 =?utf-8?B?VjNYSTBYbHdYV3YxYUU2QU8zeC8zTmdGcmErc2t2S2pOQyt1L0FUKy9zTnpr?=
 =?utf-8?B?VWFVMGJyNlJEWnczQWJ5OGxESEplRUg4S3RLQTZ1aXlDSStqenNPdEJCWVlJ?=
 =?utf-8?B?NjF0aVJaUEJPbkZJSzQ2elNkdWl1NFJaWmNYK2g0dWNEMkFyc2F5NkxiVWZ1?=
 =?utf-8?B?ajVVdEE5cW9tVzZ1SjB5blA2T2VJdmVoQXRjZ0pEeXdWK0lZWjZlcG9tSmd0?=
 =?utf-8?B?Z095eVRVZWlmNzBpclNxcjk0RW83OUhMelZEUDV0TWQ2elB0UUJyWHNYNzJE?=
 =?utf-8?B?MW1vcHUrbURzb0xIT01SSGNKYjlTa3NranFkVHhpeFZ1VlVhR0dSaThqejJq?=
 =?utf-8?B?cVUxK05BejI3ekFyRWZwODRsYWVkaDJNSDR5amc4ODZYTER4dFRrRURuc3pv?=
 =?utf-8?B?L08vUng0Mm9nb3d0c3ZIS2tQa0lZR1IzMXU4S0FqQ3NROVpSQUZxRFpkRG9a?=
 =?utf-8?B?TEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	dNcY1rS79LIomEQ5IVSqqhMnKi6VYG2AwhENW1gL1l4G9019Z0egnu3LIMg0R8SymPLDw0b1SUURnnVkU7lSLtOdwhxOLD0/7uVwSLDrKaIH/GhDlPsuAlxLZ76FZxjCjB9SaXiD0vmqvG0vqFk3gt9dBw308xlP8FQShGwkD9B5N6SaLq27IvxWPq497Lb60ngmQ47YpZEKrGLtZhjTiC3fEx6cIUJptaDgARDv6fcFeC7XgS2azaaRt8HbYy1PP1EIg2uCwwe27U7YWZ2Sqw/BWLxXz2RCrvKw7gxqVtZzlCaVTV/pStqErY1n1XSdMVfRF/GxySIfabxSj6dNngmL49ND1T0ZE2xBzbEzI1UwTLY8u3iNzDzXD/KQaSMg2oqvXMofFco66s5nS4uovRXjQykzG0mnebHAGcQbsNGTZ171lBNVHiecsnuN3lT/bbYRn+NGXeS9LtihC9eYUAWbXx3BzckcjKYvb9tSkUb4UizB2fB1aPpAGeSRy1GYFQXTpV4Gz/C/E3NTHBg8wu9GTCSCVKtBwaSmEsxYDDCL2A+goQo8E/XMrqWbE9xWBWMvRn0QRqH2r/e65Mq0EcpvUCXZZpGxtTRrS5GWoek=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2609861-a3b3-4151-4ef8-08dd7553ceea
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2025 21:41:37.2616
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C+svftpirUnc3sHCGJ5KIqA6+1OhqH5vagprCsbZyp5X+NxmgzRSDjjqr1VBhvy8Z5gI4lBxUTFYtwKhB9Qwz+U110FyBz/WgkTd1uywenU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5664
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-06_07,2025-04-03_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=0
 bulkscore=0 adultscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2504060159
X-Proofpoint-ORIG-GUID: MxIW6SB18WL-2ja9lKqk2qQRnA8K4P-D
X-Proofpoint-GUID: MxIW6SB18WL-2ja9lKqk2qQRnA8K4P-D

On 4/3/25 1:29 AM, Dongli Zhang wrote:
> Log write descriptors for the I/O queue, leveraging vhost_scsi_get_desc()
> and vhost_get_vq_desc() to retrieve the array of write descriptors to
> obtain the log buffer.
> 
> In addition, introduce a vhost-scsi specific function to log vring
> descriptors. In this function, the 'partial' argument is set to false, and
> the 'len' argument is set to 0, because vhost-scsi always logs all pages
> shared by a vring descriptor. Add WARN_ON_ONCE() since vhost-scsi doesn't
> support VIRTIO_F_ACCESS_PLATFORM.
> 
> The per-cmd log buffer is allocated on demand in the submission path after
> VHOST_F_LOG_ALL is set. Return -ENOMEM on allocation failure, in order to
> send SAM_STAT_TASK_SET_FULL to the guest.
> 
> It isn't reclaimed in the completion path. Instead, it is reclaimed when
> VHOST_F_LOG_ALL is removed, or during VHOST_SCSI_SET_ENDPOINT when all
> commands are destroyed.
> 
> Store the log buffer during the submission path and log it in the
> completion path. Logging is also required in the error handling path of the
> submission process.
> 
> Suggested-by: Joao Martins <joao.m.martins@oracle.com>
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> ---
> Changed since v1:
>   - Don't allocate log buffer during initialization. Allocate during
>   - VHOST_SET_FEATURES or VHOST_SCSI_SET_ENDPOINT.
>   - Re-order if staments in vhost_scsi_log_write().
>   - Log after vhost_scsi_send_status() as well.
> Changed since v2:
>   - Merge PATCH 6 and PATCH 7 from v2 as one patch.
>   - Don't pre-allocate log buffer in
>     VHOST_SET_FEATURES/VHOST_SCSI_SET_ENDPOINT. Allocate for only once in
>     submission path in runtime. Reclaim int
>     VHOST_SET_FEATURES/VHOST_SCSI_SET_ENDPOINT.
>   - Encapsulate the one-time on-demand per-cmd log buffer alloc/copy in a
>     helper, as suggested by Mike.
Reviewed-by: Mike Christie <michael.christie@oracle.com>

