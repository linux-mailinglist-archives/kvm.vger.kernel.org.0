Return-Path: <kvm+bounces-60717-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B58E4BF906D
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 00:18:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5722A403BF7
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 22:18:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5635726980F;
	Tue, 21 Oct 2025 22:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RysYsWZv";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="OXgNKgih"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 451D51E89C;
	Tue, 21 Oct 2025 22:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761085113; cv=fail; b=jgMz4OFHRRjOMFQFe06x/RQsMwVAJuptP5wn6ocixtqT8lldV/fAQ+rb9U2iah+yci6gQ8iENwOfXbJBwFFUFs0RDEaeDB/F2pn+LFh5fZN/bp6EJ+O2ujhpnfzsI1/mumYHQhVt0Xbb61tZjSdIPzincnFxIm2zbnbhACkv0xE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761085113; c=relaxed/simple;
	bh=E7y+BY7csGJZYXCi1eeRzYl0atBpIbwd0CBtjgbgPTc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=VUiUU1CYAWWZfjX+XPoAxHBm9pJhDl0+z5bwECeaZFje5l7A7+9ycZ3OGdnegrXqqmqKEwnQ/4yJmAKvhTZ/mv13eEJwZ6PxmQY/A9SuSDjqBd8LxwyuLF4DYJTMPQlET/ZFMA5A7L/gzDXwfMtRN/K/T/uJCbAAeu8NOI0daMs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RysYsWZv; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=OXgNKgih; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59LMCeF5028679;
	Tue, 21 Oct 2025 22:18:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=uQ4LFh0/sMxacL+7ktESzc415c38Fg3qVJA6KY5eJ1o=; b=
	RysYsWZvIyEvXwmTaVoEpeYX17NGDx9LHoPICIFgziJGpAVfpXvS2a0ORu9Fvdq0
	7SvE4uTIcFGques5DpBzCDtnOHAY4zxWfKuAZ5pbFB6DdrybjeSqM/YD5nZLkBov
	ENtmgLp772wKRfqPC1Jp5svAJ0u7YH5t2/5bsMcE8NZZ/yp0McoI6c8juC/nH/hC
	IuTe54jKOBJoZJNXmIoDZAmGKSS2PNIFHl1FhUSOEpAYfy+Zz1R872hDV6n5Fxzb
	lRzzOjR/JNuXh9sZFeQKgPLZInGwCIBHRP0y8ylMpPkYMG6u0tgSAPCzXLZ5TzIy
	+iy+VAnlqFzTM9swo3LA9w==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49v2ypxqg6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Oct 2025 22:18:27 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59LLCEbD031639;
	Tue, 21 Oct 2025 22:18:27 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012012.outbound.protection.outlook.com [52.101.48.12])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bcmxeg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Oct 2025 22:18:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BqmKRl7PUYVxsPJl3ULetwOpap5IySZl9sY3vPxlVi0LJ98DgABb2CtY4qhVT1BdYcdSYK4PrOxZWnIWnpNMiAmGnqjHPKjox/HLDpXPEjgP+fYwwry1TKWMjPg6GBoKHKTUeVjlHJ1Vu6H0NXmcLB67/gznneY5hqUAhDoFbPjNpv5BszZm9CXHnV1jelHWewj7pmrMWbhFWE6xU+crecqWZqJqId4hLtH3dP6F51k0PMmLPsPzEMIoyIT7urekbQQy8jWakreQnD2ayDmVdHj6/grFVbOi1/1X2IqB6W+BBWNpRtXL+9Xwf4PEQaUuPqQ/vxldmos3c0zsG5a2lA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uQ4LFh0/sMxacL+7ktESzc415c38Fg3qVJA6KY5eJ1o=;
 b=v5QEQaYOQro4ibYuMF7sR9skaVW3x2Wry1ZnPwXWRocqfcYAhA+BecMA1q36wIfhVhVqvZK4RxKz2fnYQpOMFm40afb2ZAmxvbf0vqxdZDvo25GbRivWvxwpEVcMGpP4/KmJxR/rNy2Ng1h5a2DyzrmpEqzRkr9ue2VHHqoAjnxapCT7Du07liFpUO0f6I7DghzUhIaP/joh4FwqWootz0tIo7JSIZ4iiVgnyvlCZc0Jary1QwE3iVI5jSWQaiEnKPCNmO7c4+KMfAlsAVoDHNZP8j7u3x9ZmImqK3WE9PvkYIZh9y/SzKlarGsrHCJzU48SpZ34p7ae/m35FHmRPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uQ4LFh0/sMxacL+7ktESzc415c38Fg3qVJA6KY5eJ1o=;
 b=OXgNKgih+rFfd4xEQvfgbRzBGeHNAtUtBhQSg9WBPNsUYfP9wDsdIiSm20AVex5dgcEAqUQ6ofpl/UjbVXTo6iU5BYN4cNYdLBIQd88A/4TQwt8bs5qfgpD2zMBL8cWpKgl1tDiOwHhmpYRcvOIloGqH/4n9e+RdTaoNe0vRKZU=
Received: from BLAPR10MB5041.namprd10.prod.outlook.com (2603:10b6:208:30e::6)
 by SJ2PR10MB7559.namprd10.prod.outlook.com (2603:10b6:a03:546::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Tue, 21 Oct
 2025 22:18:04 +0000
Received: from BLAPR10MB5041.namprd10.prod.outlook.com
 ([fe80::2c19:641c:14b9:b1b4]) by BLAPR10MB5041.namprd10.prod.outlook.com
 ([fe80::2c19:641c:14b9:b1b4%4]) with mapi id 15.20.9253.011; Tue, 21 Oct 2025
 22:18:03 +0000
Message-ID: <87d60dcd-972c-4ab6-aa6c-0d912a792345@oracle.com>
Date: Tue, 21 Oct 2025 18:18:00 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/3] vfio/type1: handle DMA map/unmap up to the
 addressable limit
To: Alex Mastro <amastro@fb.com>, Alex Williamson <alex.williamson@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20251012-fix-unmap-v4-0-9eefc90ed14c@fb.com>
 <20251012-fix-unmap-v4-3-9eefc90ed14c@fb.com>
Content-Language: en-US
From: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
In-Reply-To: <20251012-fix-unmap-v4-3-9eefc90ed14c@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH2PEPF00003851.namprd17.prod.outlook.com
 (2603:10b6:518:1::76) To BLAPR10MB5041.namprd10.prod.outlook.com
 (2603:10b6:208:30e::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5041:EE_|SJ2PR10MB7559:EE_
X-MS-Office365-Filtering-Correlation-Id: be8e98a1-ce69-4681-8889-08de10efb410
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RVdKa0R1WHJNbWk1WmNPR0x4cEs4d0tFZWRHWUthSmhwYTZtM1BhWVpoSUkv?=
 =?utf-8?B?R1AxZFNoTXR5N0w4Ync1SFdqYmdlaHMyTnpaenN3YU02RkxkcENUVWM0SzQ0?=
 =?utf-8?B?dXlIaFYwbTNoc3dhUnZHcUVlUFhkR2p0YTNaQWc1dE1iMDdGSFdXNDBBOHNI?=
 =?utf-8?B?eDh6ZE4vM1ptc3RQVHYrNzUrR3FoS1QzdWt4ZERzelJSTzhDM3NKVGgwNndq?=
 =?utf-8?B?c3lzZmtuOXoxdXREUTkySmRxSDEvaDhDRUlBYUZ4cEZwNWhTVlJpZTNNZFZQ?=
 =?utf-8?B?Znh1ZXhtZzQwMEY3STNBVTBPd09FYzZHeVJCL2dESE1lZk9OU29TQktXQmtm?=
 =?utf-8?B?K2w3V2JWVWU0QUREZDFHZ1o1ZE9lSWVtbmVDazMzc2lJNkNqRENQc1dvOEpB?=
 =?utf-8?B?cG1HR1kxdnpwNTQ0UXlyWnlwNUdoTlptQS9jSWhtbE5YeVNSKy9UeUF1RllY?=
 =?utf-8?B?NGVPRVAwY3lyVHdkeWhrVVppZzRqZFAwV0VFN2cxYUE0UUZSVVF0Qk9SS2NK?=
 =?utf-8?B?aE9CM1ErQzJJbUFYakVNcWoxc2l4UnpxUUMwUms0VHZEaFVEQXVzVFpVdFRW?=
 =?utf-8?B?WkVrb3N1eUZVcU40MkFiNmhjK0kwMXp6RjNleXdRaGkwR1RNOHBzZHQ3ejJl?=
 =?utf-8?B?VkYvV09xVjMyaCtnTEczaDI1czRNdEVaYSsyQUFDeERoMjgzVzRqNzV2L01L?=
 =?utf-8?B?VFpjNWtWTWVjTFo5RGFlL2xoRWNvS0c2dTNHdjZueHFyUExkMVU5NCthRGdL?=
 =?utf-8?B?Zm1zdVIyclFWNmYrd01wd1pHaDhmQ1Qzams1YmFZNUdxcGdKaFhOQzk1UU55?=
 =?utf-8?B?cUxZZHRlcXRzTUowcER5NHVtQnE1Mmh2MGgwem9TUWRzangySklpOHNpUFlN?=
 =?utf-8?B?a0hTR3VtUjBFdnJ5S2hrYnljVFlaTHFUdC9rN25JS2MxQUdmRHdwY1NySzl6?=
 =?utf-8?B?RFBJc0RQZ3pPNm93a0tEVW5BTGFWdFdBZHdJa3NuYitlQ0QwK0hhRFd1N01Y?=
 =?utf-8?B?eEg4OVlyaDY1SjBtK3hZNHBlVVpnc1g0MUpQVmdkUEdjV1pvV1NZVk5uL01p?=
 =?utf-8?B?Z0Z0SStiZEt4UEJPQThWZGpNWHNySHE4NjVkb3Q3U2xWWXVTRGFhUENZNXpt?=
 =?utf-8?B?SzE3QVVGTWo4UXgvdlNaaTBXRkQzYloxc3dLVm93OFhJOXA4ZEFWRVFoUjFu?=
 =?utf-8?B?M0hNdXg5QkFIZGJxc1lidnpsUXBMNStUWTExZUJCOFhtZlRSSlFuajQzays5?=
 =?utf-8?B?cHhrQWdnaDdzSVltSkdZRncwUk4yOXZwUVV2dzJxU0FYS2NGamRXbldSNlZI?=
 =?utf-8?B?VW11TUdTcXBFYUdEWW5hekVBbk1oOXZydjdCNEpNMG4rSGt4cjFQMXBYVnE2?=
 =?utf-8?B?SS9kaHdKT2QwNTFSM2tzUjNEa0FtekFHRmtvMmxJOW14c29ibFhtNnRod2VX?=
 =?utf-8?B?RzlZQnVvU3Z4SGo0NXdadEl0aHoyNDR5ZSt6dGF1bnBvVU1VK0F0Smp0Nm5Q?=
 =?utf-8?B?di9nU3l6TU0xZFJqY0ptQlgyOEZaWFZLOENDaTJyOFd0YmlUR0RBTzBNK1Fy?=
 =?utf-8?B?L3JUNXNEUitVVEUyamtwR3ZZVHZIbkJleXBEckwzdEdTUVBIblp1R0VyNTNT?=
 =?utf-8?B?MG9KOCtpTUN5L1Y5aXJhM2VEQzBoT05TeTFLZTJFdXhyWDRzYkIrS1hwSUVR?=
 =?utf-8?B?TUk3amNNN1dWSWltTHNBUVZmSU1YcCttWEs1Zlo5b2NRUHVaakpMWVVzekpP?=
 =?utf-8?B?OGxUdXFWZldON1dYVzRPRW1NUXY2WWlmSDFqSkFLanEzRmo0T0d4UHEvMEV5?=
 =?utf-8?B?dVJZdjFBcytzVzBhd0g4RzJEU0tpMDNLc3RGVGF5anBFS0NmQ1A3Ky9odnRU?=
 =?utf-8?B?dktqSWxOMVg0SUQ2NkdwSXZCaFMrTEtHdUpxREVobVhxMnZGRmwxSmRDTTU4?=
 =?utf-8?Q?vzQ2r0IMV/6j9CR7r9BYuiXuzn+7L9KL?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5041.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VTE1ZEUzZDFoRnR3aGxJRDVUcHZsTDM2a1lBL29XS1h5QXd0ZFgraXRxTXVP?=
 =?utf-8?B?d1NCQVhheXJxM3NYckRpcVF5NklnKzNlbnBwaFdkVG5XZkZjYjE0cm96WXRH?=
 =?utf-8?B?SEMxckVaWTEySTJHQW5zNGVtSXFZaVNrYW4zdjdoVUk2MTNRTW9FNXU5cmhB?=
 =?utf-8?B?K0hNZzcvRTNFTnlwZmdQc3loMkNDWk5UN0tkQkh4aGN2SGU1dG5pWjNjUkVj?=
 =?utf-8?B?U3g4UWdLbjEyTVZNVHN3WkVUaEtabUFvcjhIaFVBUUtMRVhRVWpoRmVuY3hG?=
 =?utf-8?B?d0ZTUXE0eHN3WXA1MFFtb1R1YXNTNjRmM2dKY0pudUxMRnAwRkt5TGRudlk5?=
 =?utf-8?B?NFJ0OUlOQ3puSC84OTExT1RnSys2enAxOG5yUmI5eHo5NWM0NnAxR3ArQ3Zn?=
 =?utf-8?B?SWtMMExDYUk1b3VFRVRqMXpVSjVhS1doTlVkbWNONldEZVBJa2xPR1YzZFZH?=
 =?utf-8?B?ek5ib3EyRVpjYXVTWjhXVnJ5QkpjSCt1R0xob3NEcVJLM0I1T05JTlVCdXlW?=
 =?utf-8?B?SnVEYmpYY2ZBMjl3WmRVeG1JMzZTdCtGeHpmZzEzNlU4WndNVW5KeE82QlpC?=
 =?utf-8?B?M0ZxaTM3bzZ0Y3l1NzdJVjJtZW1HRCs3eExCTmRPTC8wRHBwdVpldFUxRWJS?=
 =?utf-8?B?aHdtQ2JrMjBTV1l4RkpDVFR2QS9TOFUwUllISjdSWUhRR0FRVVgwMlV4Ri9Y?=
 =?utf-8?B?aVhWZ1o2T0RVTGhmRHFvTm1OYjhtOEFZVXA0ODVmVEZXWUtYN3hKMDhjWXI3?=
 =?utf-8?B?SnpRREZWK0VBVThISlhRWXRFSVJNL2QyY0RoMHppT2p5cmRZRnZuNW9uSHl0?=
 =?utf-8?B?NjUrNUlVL3E3alJXZVd4bk5ZRG9wZFR0MWFkWTErR2FTODY3SnZZSlA4eVlH?=
 =?utf-8?B?UC9zSDV3dUNZQkNFenM0enVNMXFZUmdHcUlwMiswd2psaG9KakxQdlVxUE9M?=
 =?utf-8?B?Yk5vdWhNWlZiZHFqaElmcVVtbFRlbnJsN0lvUFBUbnY1WUpTY3ZreEpmS2s4?=
 =?utf-8?B?TzNYRDZ4amNTaXJnam9VMnZ0aVhWYVYzbDdaU2lNdStzTzNQYnhoY2VSc05s?=
 =?utf-8?B?RkM3eHozd1dxcUEvYXlHYTljNXZDOG9TM1d5SnJPdnFPeUZLTkZiV1V2bE5C?=
 =?utf-8?B?UkNZWTN4dTJDbnJ6dllUN1lpWVVGUGdOU3RDVzRUREg0SXFzL1RHeEwycU02?=
 =?utf-8?B?bWozN3hnS0VpRkpoemlpZlJTRENKZ29NdjhVa09MSkRoSVpVZzhaQ3lFOU9k?=
 =?utf-8?B?MHpGNWxWK0xVeHQ4VkpCTW5DWGN2VnZybmxKNUpwdEJXZjV2ckIrTGVqYnIx?=
 =?utf-8?B?RUdwMUZLSUwrUGthNERkYnlJZUpac29PcEtOdUNNQ3JSWW8zYWxFeUh1UmNa?=
 =?utf-8?B?V0lOSXI3TSt5clBya3A3bEJ5QW50OXVWaUJJWUxSbW5pcGJ6ejR6ZGdMbVpP?=
 =?utf-8?B?cFc4WFpCZjJFdnVVdi94cCtnTWM3VStHc1lNSk95S1FHV3FaZVo5MnFmTjFz?=
 =?utf-8?B?a2dqYTRjRmFxRDNQYXlzbjJqYWZkM0w1eW1NbEVKZVRGQkVzZG54OXROaG1u?=
 =?utf-8?B?VjZCWkNlR25kK3lZMW5jZkQ2UzVDYSt5M0hsbHNQSDVtY254akNvQjgyYXUr?=
 =?utf-8?B?MnlLUkhFRGlEcU1VN0srV24vNWxHdTBoS3gzeFJKK0UwOGw1Y3pVYWJvOFc4?=
 =?utf-8?B?R25sWTgvcndxK0JWRnpKZDNjSlJKWHBzQURRRmdXeXBiZ3djcTd6T0dQT2tU?=
 =?utf-8?B?a0lWa2tNdW9weDlmTWNsN1lsZ0FWbXhRR3JEZndIZ0FpbERiQUlZQVBTSlNJ?=
 =?utf-8?B?TW1pb0xRYWQvMFZnc2xIZ3NLRUtkZTRQbFkzeGtpWld4dDl5M0hVZEh6cDVh?=
 =?utf-8?B?QnU1SkZ1SU8ycjFzWGUycUgzN200cGhpendxajdLaWpwVnc3TlVYQlZnSkJV?=
 =?utf-8?B?cFBNNG55WjFyWGx0dTFWYkVGNHU2dUhMOFJtMjNuMTQzUTlHRU1XK1BBUmtF?=
 =?utf-8?B?Z2VQcHVkYUs0TkZsNWxKa2ZWalQwR1VWWkVWY2ZNVEg2WUVFcGpoYWNrNEhs?=
 =?utf-8?B?cmluUWk3RFNsT3ovV2NUcHduTHdMWktSQUF4N1dxek4yYXVwVU9aQjdPbHJv?=
 =?utf-8?B?ZVZHUzZUTmh6ZHhaRDliakhqMjd4SUVWK0ZxalNJSXJ0cVh1NThTU2pmLytP?=
 =?utf-8?Q?wqbH5TZhABUNbNie7/TinRw=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8RrVWbtCRaVcDTdL+y+y1pMMlU0rdEMf5AK9T8tml+r/Pl+Dnmly0wlsluOjVmkQzqIjMRuRdf/OhrLVll9I+b+Z8Zy54nbMcEiOJxJDuCMe6yqvoyB+XBJTxXmKpniMDRhS4WXjlh+qmElCATRVFvYFSHEx61lIxk/FMRo969fqFTTFE2db3Jn+jSE/C9axmg3W89fyvGQNjh3C9QGGLglPiUx24UH8aYk+QMds8uHSCi0+1TGBfwyzhH3cnwAggAUcuXKVG+6V1NdFqTNjn7/bhh6ZJg3D4s/6GdbN7KnSuClLvTJELa8dEnELS5Ozs3lfCSibk5IwabPv1yaOH5oXd+bCS6gugf/Jw+yqiio15/yOxBcqr1M8wMIzJNm4upa01TmSCaus1Umby7dwoUjkrOxRNFe934kgTeE5lPj0HEy6nnKNwPn77s24ZH8cY43hjc1O1oU7ZOT4Ab4ArViFbYbX/8oTWU3dBg9guJACxVfSfyej+7VaDBV3VDJCMbFM/3LZaPDqNH8/lz8eYNGgmv3izSDbSh+sA05kp/LtTsTOYG/uQLwxSB12wkss7r1/o1HUYk3QECo6AucPUFkRBNR7U4Ml9K7cOUllbFI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be8e98a1-ce69-4681-8889-08de10efb410
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5041.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2025 22:18:03.9049
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xRCOGuWpfvATdW46nI7Uu9SoLh/TQ1PSHiUE3OTMUhvutUtlCitSvq49Ln8xAWWOS5ahWdwyZj30bVxutiD/hHhm7ChY1Knralf+dlN1mds=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7559
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-21_03,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 phishscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510210181
X-Proofpoint-GUID: UucRn8DZAsjmsC9wdb3dlX1uwJo6tv1-
X-Proofpoint-ORIG-GUID: UucRn8DZAsjmsC9wdb3dlX1uwJo6tv1-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMyBTYWx0ZWRfXzFst3M3ZiRDn
 FDarkypxPKTV4gHkJteH0iv3k8LwGgZXv/j+oDV+NZvW3xiq2vMjUvvl4x962PZ/FlsCwQf30yZ
 rW6gKqomQ1pYvaZZE4Y25nEu00brQ5zZWvi979dkx4fxiXzW13vUciFZs/IQuksZFFykuf0xw9Q
 +SwlAxVpsLZZ3fbNrkNYeFyQeg2LxzqpmdP3w1O4kgMzb1L6RkSHD0OojGG91x8TVaCXfCn6TZh
 C3rdGMQfRHB9Vbk2kQqZ4BLBBRUNTcsKFDjBAnqk19XVA4te2Y7zW0TZyhSmtKBXySoytSslKJo
 riiQxAp8opQeqs8dKajZK1U/HSANP3kzQlNiBOUzzA88uOVkkn8iTUf3MGNJ8CiuZFoSJZvP8Uf
 HJdYQHbaexi4KjDSZ6HXeL3uZSywKw==
X-Authority-Analysis: v=2.4 cv=Nu7cssdJ c=1 sm=1 tr=0 ts=68f806b4 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=FOH2dFAWAAAA:8 a=UNodPjKoDCw7iiSSy_IA:9 a=QEXdDO2ut3YA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22

Hi Alex,

On 10/13/25 1:32 AM, Alex Mastro wrote:
> Handle DMA map/unmap operations up to the addressable limit by comparing
> against inclusive end-of-range limits, and changing iteration to
> perform relative traversals across range sizes, rather than absolute
> traversals across addresses.
> 
> vfio_link_dma inserts a zero-sized vfio_dma into the rb-tree, and is
> only used for that purpose, so discard the size from consideration for
> the insertion point.

I made a small comment about this on the corresponding code below..

> 
> Signed-off-by: Alex Mastro <amastro@fb.com>
> ---
>   drivers/vfio/vfio_iommu_type1.c | 77 ++++++++++++++++++++++-------------------
>   1 file changed, 42 insertions(+), 35 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 48b84a7af2e1..a65625dcf708 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -166,12 +166,14 @@ static struct vfio_dma *vfio_find_dma(struct vfio_iommu *iommu,
>   {
>   	struct rb_node *node = iommu->dma_list.rb_node;
>   
> +	WARN_ON(!size);
> +
>   	while (node) {
>   		struct vfio_dma *dma = rb_entry(node, struct vfio_dma, node);
>   
> -		if (start + size <= dma->iova)
> +		if (start + size - 1 < dma->iova)
>   			node = node->rb_left;
> -		else if (start >= dma->iova + dma->size)
> +		else if (start > dma->iova + dma->size - 1)
>   			node = node->rb_right;
>   		else
>   			return dma;
> @@ -181,16 +183,19 @@ static struct vfio_dma *vfio_find_dma(struct vfio_iommu *iommu,
>   }
>   
>   static struct rb_node *vfio_find_dma_first_node(struct vfio_iommu *iommu,
> -						dma_addr_t start, size_t size)
> +						dma_addr_t start,
> +						dma_addr_t end)
>   {
>   	struct rb_node *res = NULL;
>   	struct rb_node *node = iommu->dma_list.rb_node;
>   	struct vfio_dma *dma_res = NULL;
>   
> +	WARN_ON(end < start);
> +
>   	while (node) {
>   		struct vfio_dma *dma = rb_entry(node, struct vfio_dma, node);
>   
> -		if (start < dma->iova + dma->size) {
> +		if (start <= dma->iova + dma->size - 1) {
>   			res = node;
>   			dma_res = dma;
>   			if (start >= dma->iova)
> @@ -200,7 +205,7 @@ static struct rb_node *vfio_find_dma_first_node(struct vfio_iommu *iommu,
>   			node = node->rb_right;
>   		}
>   	}
> -	if (res && size && dma_res->iova >= start + size)
> +	if (res && dma_res->iova > end)
>   		res = NULL;
>   	return res;
>   }
> @@ -210,11 +215,13 @@ static void vfio_link_dma(struct vfio_iommu *iommu, struct vfio_dma *new)
>   	struct rb_node **link = &iommu->dma_list.rb_node, *parent = NULL;
>   	struct vfio_dma *dma;
>   
> +	WARN_ON(new->size != 0);
> +
>   	while (*link) {
>   		parent = *link;
>   		dma = rb_entry(parent, struct vfio_dma, node);
>   
> -		if (new->iova + new->size <= dma->iova)
> +		if (new->iova <= dma->iova)
It is possible I missed a previous thread where this was already 
discussed, but why are we adding this new restriction that 
vfio_link_dma() will _always_ be called with dma->size = 0? I know it is 
the case now, but is there a reason why future code could not try to 
insert a non-zero sized node?

I thought it would be more fitting to add overflow protection here too, 
as it is done for other code paths in the file? I know the WARN_ON() 
above will make us aware if there is ever another caller that attempts 
to use size !=0, so this is more of a nit about consistency than a 
concern about correctness.

Thank you,
Alejandro

>   			link = &(*link)->rb_left;
>   		else
>   			link = &(*link)->rb_right;
> @@ -1071,12 +1078,12 @@ static size_t unmap_unpin_slow(struct vfio_domain *domain,
>   static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
>   			     bool do_accounting)
>   {
> -	dma_addr_t iova = dma->iova, end = dma->iova + dma->size;
>   	struct vfio_domain *domain, *d;
>   	LIST_HEAD(unmapped_region_list);
>   	struct iommu_iotlb_gather iotlb_gather;
>   	int unmapped_region_cnt = 0;
>   	long unlocked = 0;
> +	size_t pos = 0;
>   
>   	if (!dma->size)
>   		return 0;
> @@ -1100,13 +1107,14 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
>   	}
>   
>   	iommu_iotlb_gather_init(&iotlb_gather);
> -	while (iova < end) {
> +	while (pos < dma->size) {
>   		size_t unmapped, len;
>   		phys_addr_t phys, next;
> +		dma_addr_t iova = dma->iova + pos;
>   
>   		phys = iommu_iova_to_phys(domain->domain, iova);
>   		if (WARN_ON(!phys)) {
> -			iova += PAGE_SIZE;
> +			pos += PAGE_SIZE;
>   			continue;
>   		}
>   
> @@ -1115,7 +1123,7 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
>   		 * may require hardware cache flushing, try to find the
>   		 * largest contiguous physical memory chunk to unmap.
>   		 */
> -		for (len = PAGE_SIZE; iova + len < end; len += PAGE_SIZE) {
> +		for (len = PAGE_SIZE; pos + len < dma->size; len += PAGE_SIZE) {
>   			next = iommu_iova_to_phys(domain->domain, iova + len);
>   			if (next != phys + len)
>   				break;
> @@ -1136,7 +1144,7 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
>   				break;
>   		}
>   
> -		iova += unmapped;
> +		pos += unmapped;
>   	}
>   
>   	dma->iommu_mapped = false;
> @@ -1228,7 +1236,7 @@ static int update_user_bitmap(u64 __user *bitmap, struct vfio_iommu *iommu,
>   }
>   
>   static int vfio_iova_dirty_bitmap(u64 __user *bitmap, struct vfio_iommu *iommu,
> -				  dma_addr_t iova, size_t size, size_t pgsize)
> +				  dma_addr_t iova, dma_addr_t iova_end, size_t pgsize)
>   {
>   	struct vfio_dma *dma;
>   	struct rb_node *n;
> @@ -1245,8 +1253,8 @@ static int vfio_iova_dirty_bitmap(u64 __user *bitmap, struct vfio_iommu *iommu,
>   	if (dma && dma->iova != iova)
>   		return -EINVAL;
>   
> -	dma = vfio_find_dma(iommu, iova + size - 1, 0);
> -	if (dma && dma->iova + dma->size != iova + size)
> +	dma = vfio_find_dma(iommu, iova_end, 1);
> +	if (dma && dma->iova + dma->size - 1 != iova_end)
>   		return -EINVAL;
>   
>   	for (n = rb_first(&iommu->dma_list); n; n = rb_next(n)) {
> @@ -1255,7 +1263,7 @@ static int vfio_iova_dirty_bitmap(u64 __user *bitmap, struct vfio_iommu *iommu,
>   		if (dma->iova < iova)
>   			continue;
>   
> -		if (dma->iova > iova + size - 1)
> +		if (dma->iova > iova_end)
>   			break;
>   
>   		ret = update_user_bitmap(bitmap, iommu, dma, iova, pgsize);
> @@ -1348,7 +1356,7 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>   	if (unmap_all) {
>   		if (iova || size)
>   			goto unlock;
> -		size = SIZE_MAX;
> +		iova_end = ~(dma_addr_t)0;
>   	} else {
>   		if (!size || size & (pgsize - 1))
>   			goto unlock;
> @@ -1403,17 +1411,17 @@ static int vfio_dma_do_unmap(struct vfio_iommu *iommu,
>   		if (dma && dma->iova != iova)
>   			goto unlock;
>   
> -		dma = vfio_find_dma(iommu, iova_end, 0);
> -		if (dma && dma->iova + dma->size != iova + size)
> +		dma = vfio_find_dma(iommu, iova_end, 1);
> +		if (dma && dma->iova + dma->size - 1 != iova_end)
>   			goto unlock;
>   	}
>   
>   	ret = 0;
> -	n = first_n = vfio_find_dma_first_node(iommu, iova, size);
> +	n = first_n = vfio_find_dma_first_node(iommu, iova, iova_end);
>   
>   	while (n) {
>   		dma = rb_entry(n, struct vfio_dma, node);
> -		if (dma->iova >= iova + size)
> +		if (dma->iova > iova_end)
>   			break;
>   
>   		if (!iommu->v2 && iova > dma->iova)
> @@ -1743,12 +1751,12 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
>   
>   	for (; n; n = rb_next(n)) {
>   		struct vfio_dma *dma;
> -		dma_addr_t iova;
> +		size_t pos = 0;
>   
>   		dma = rb_entry(n, struct vfio_dma, node);
> -		iova = dma->iova;
>   
> -		while (iova < dma->iova + dma->size) {
> +		while (pos < dma->size) {
> +			dma_addr_t iova = dma->iova + pos;
>   			phys_addr_t phys;
>   			size_t size;
>   
> @@ -1764,14 +1772,14 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
>   				phys = iommu_iova_to_phys(d->domain, iova);
>   
>   				if (WARN_ON(!phys)) {
> -					iova += PAGE_SIZE;
> +					pos += PAGE_SIZE;
>   					continue;
>   				}
>   
>   				size = PAGE_SIZE;
>   				p = phys + size;
>   				i = iova + size;
> -				while (i < dma->iova + dma->size &&
> +				while (pos + size < dma->size &&
>   				       p == iommu_iova_to_phys(d->domain, i)) {
>   					size += PAGE_SIZE;
>   					p += PAGE_SIZE;
> @@ -1779,9 +1787,8 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
>   				}
>   			} else {
>   				unsigned long pfn;
> -				unsigned long vaddr = dma->vaddr +
> -						     (iova - dma->iova);
> -				size_t n = dma->iova + dma->size - iova;
> +				unsigned long vaddr = dma->vaddr + pos;
> +				size_t n = dma->size - pos;
>   				long npage;
>   
>   				npage = vfio_pin_pages_remote(dma, vaddr,
> @@ -1812,7 +1819,7 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
>   				goto unwind;
>   			}
>   
> -			iova += size;
> +			pos += size;
>   		}
>   	}
>   
> @@ -1829,29 +1836,29 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
>   unwind:
>   	for (; n; n = rb_prev(n)) {
>   		struct vfio_dma *dma = rb_entry(n, struct vfio_dma, node);
> -		dma_addr_t iova;
> +		size_t pos = 0;
>   
>   		if (dma->iommu_mapped) {
>   			iommu_unmap(domain->domain, dma->iova, dma->size);
>   			continue;
>   		}
>   
> -		iova = dma->iova;
> -		while (iova < dma->iova + dma->size) {
> +		while (pos < dma->size) {
> +			dma_addr_t iova = dma->iova + pos;
>   			phys_addr_t phys, p;
>   			size_t size;
>   			dma_addr_t i;
>   
>   			phys = iommu_iova_to_phys(domain->domain, iova);
>   			if (!phys) {
> -				iova += PAGE_SIZE;
> +				pos += PAGE_SIZE;
>   				continue;
>   			}
>   
>   			size = PAGE_SIZE;
>   			p = phys + size;
>   			i = iova + size;
> -			while (i < dma->iova + dma->size &&
> +			while (pos + size < dma->size &&
>   			       p == iommu_iova_to_phys(domain->domain, i)) {
>   				size += PAGE_SIZE;
>   				p += PAGE_SIZE;
> @@ -2989,7 +2996,7 @@ static int vfio_iommu_type1_dirty_pages(struct vfio_iommu *iommu,
>   
>   		if (iommu->dirty_page_tracking)
>   			ret = vfio_iova_dirty_bitmap(range.bitmap.data,
> -						     iommu, iova, size,
> +						     iommu, iova, iova_end,
>   						     range.bitmap.pgsize);
>   		else
>   			ret = -EINVAL;
> 


