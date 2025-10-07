Return-Path: <kvm+bounces-59556-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F868BBFF1F
	for <lists+kvm@lfdr.de>; Tue, 07 Oct 2025 03:24:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E5A54189DC20
	for <lists+kvm@lfdr.de>; Tue,  7 Oct 2025 01:24:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62B9A1EB5F8;
	Tue,  7 Oct 2025 01:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OXDhZKzw";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="VcmzS2e0"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4331711CA0;
	Tue,  7 Oct 2025 01:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759800252; cv=fail; b=aKCdb+IvGK5mVhq77O3MykaSOMqj7VNvGUh9O5wMjd8Gx/wzPbRW9LCNwAXnzglkNxeewT5K6kiZS4orf+AkNhjDOy+KMWK9w43x6lFGUwmPzv5ZUuKoz1eaZTqgzOMZOELsFc7279ULg5lwAr4+cRK0B6csvxhN7hnRt1TA/Cc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759800252; c=relaxed/simple;
	bh=937aPNxk4k0WC9toEo/I1/uvGVFxO7B8vFwqUpMZYgw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BppQP7x5iss0HQqsaIyowA57K8Hb94LKP/GAsmf+JBcuD5+Yrb2Pid9TO4X/muJhBvV3yVew8aWchzzluY9G0icAlYe764ZjEhzEcfJffcQFrevbr8bSGF0p3oj46nJ+K6ngjkCYMzmnwK4m0YooYx/E36i8ZhZIrnqFIjRl3Wo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=OXDhZKzw; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=VcmzS2e0; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5971FpxA008917;
	Tue, 7 Oct 2025 01:24:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=KqET1ckhQ8tTcX9vwXl4SmjOqjyqsLj8Fni4FziQXNg=; b=
	OXDhZKzwxtTkwttQ7o67B2ACwtTw87JPQGEMIO5n6y7CA3FC/u3nxQRmeOEFuWCb
	0QR6mcAsy74XK9PCbixqVnX9IX6i14usm2gzy9EzZPqdXlZl8ih0fFncI4SONTOo
	95WOBYMWByNGnEcArPFANODcU3pJiG7uh0J1nCEBLlKrVwXcS+1y/Fu1zTCGXvmG
	9hr93nFSmX8zQagIFJtjn2PpCStimr6DlKNejdXbMrtDZ/OpOKcBr9f2iJbTM7DW
	fLzpASPKlOInrWiHDshvvjeMsZaqh18ib3lFEaUncaQOLIaH0VkSpYSzN8RiMys4
	T3FQj14ifmPaI5wXp+k9ag==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49mrt7r0p7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 Oct 2025 01:24:04 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 596MUEHP034916;
	Tue, 7 Oct 2025 01:24:03 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011040.outbound.protection.outlook.com [52.101.62.40])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49jt17jgq6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 07 Oct 2025 01:24:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y2doiC9ckzamqKr9oUP/xyQS0BCKq35licelcuk/hvCFIV0W5JR0Ntoo9xrMYBpLyQfZzW1Nhwl2Tlv8HUA12dVQebAuFmXQ0aIz6Y1fjnk7QkD/MkTZZdTPvuBpsKHg8PnsQEzj7L48+iqkgvyitsI8aTErSc92KxLorgApdYRYb1RBqK03IWKbhtIZ+0z33cCHB7zisE9XYGQbgD7skYnikqE4SxJ6QzeDgpWye2FxZJCvl2MeccofCmaXszG9FCea6kkzcMNuTrKYlfBcfdDcY+A1YJOnqevAfWN0hJ75uYGuUnGGQdc/fxgMcKlDowdzO6cQX6IW/rL3OXftfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KqET1ckhQ8tTcX9vwXl4SmjOqjyqsLj8Fni4FziQXNg=;
 b=YKlbBdIEyfhQ0hn80NhftoUR77VusG5PBKV32StbCGuu04K+2c445BFXsmSQwSAE0AGyk+dLDRTaeh5a4NwrayAEvJmPKsn18lX/Gl22Vu1Njh8Spp7E8FSQSzVf+Z+2KbrGfOPQSKCHZH1V5wNRGfOWIRHIbK7sxaO6Ag/4x3iv7wkAYlBcQ+uYWiB2r++eZwM18+9DwkYnl3EfQiJGCtvOIguOkIQpHyD/QKXGa+lk93omW4ShLWKgI/x/yCIsbJiQOlWf8GuQ3idub6c1iHLiVJQD6ik3VSo5lCcPMACtHUsJ0pc5YdqjdxY+PfPcPv1hkCX+TiavZPoURFeX7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KqET1ckhQ8tTcX9vwXl4SmjOqjyqsLj8Fni4FziQXNg=;
 b=VcmzS2e08kHWZ0QZfHzzdTH1VMaiogxqsg/IaKTvuxBiVrV8TysHNXfqAsR9NA2abY/8gDgrhSoUjBNR6jqs+0gXpVJXs+Ck+GHwGvSPv86zAyTLj5XFvsu6md/cjoqNYeRM53hUg/75A6AS6KuAzezrjJN+wd30jYco9fXNCsI=
Received: from BLAPR10MB5041.namprd10.prod.outlook.com (2603:10b6:208:30e::6)
 by CH3PR10MB7187.namprd10.prod.outlook.com (2603:10b6:610:120::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Tue, 7 Oct
 2025 01:23:58 +0000
Received: from BLAPR10MB5041.namprd10.prod.outlook.com
 ([fe80::2c19:641c:14b9:b1b4]) by BLAPR10MB5041.namprd10.prod.outlook.com
 ([fe80::2c19:641c:14b9:b1b4%4]) with mapi id 15.20.9182.017; Tue, 7 Oct 2025
 01:23:58 +0000
Message-ID: <68e18f2c-79ad-45ec-99b9-99ff68ba5438@oracle.com>
Date: Mon, 6 Oct 2025 21:23:56 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vfio: fix VFIO_IOMMU_UNMAP_DMA when end of range would
 overflow u64
To: Alex Mastro <amastro@fb.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20251005-fix-unmap-v1-1-6687732ed44e@fb.com>
 <20251006121618.GA3365647@ziepe.ca>
 <aOPuU0O6PlOjd/Xs@devgpu015.cco6.facebook.com>
 <20251006225039.GA3441843@ziepe.ca>
 <aORhMMOU5p3j69ld@devgpu015.cco6.facebook.com>
Content-Language: en-US
From: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
In-Reply-To: <aORhMMOU5p3j69ld@devgpu015.cco6.facebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BN0PR04CA0090.namprd04.prod.outlook.com
 (2603:10b6:408:ea::35) To BLAPR10MB5041.namprd10.prod.outlook.com
 (2603:10b6:208:30e::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5041:EE_|CH3PR10MB7187:EE_
X-MS-Office365-Filtering-Correlation-Id: 76860c97-9f21-4edf-3679-08de0540309e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?R0x1Wm1NOHFQQTVaNG1Da2pTTGRlajVnMU94bHo0QmcxNUtiSzZSQW1xbm5a?=
 =?utf-8?B?V3pML1E4enZkdkR2TTR0K1hCTFBvTy84clgzelpFcFVkWXp0TEFIODJrWlUx?=
 =?utf-8?B?STNiV1c4VmdzejlrcEU4NENIRXFpM0tVdzlZZU9WUkRBL21zZ00rWDNnWEc3?=
 =?utf-8?B?M1NSM3p4SERTRjRxM3FpVmtYMFNHRDZ0ZEY3bEowdzZYZWFuN2lXbXhjdXQ1?=
 =?utf-8?B?WVEzTWxmYzQ4UHRmbVUwbTB5QVhpZ1pWSVlMeTMxUyt5TnFOa3Zzd2g2ZE0r?=
 =?utf-8?B?K1poTTNhVEE1Mkw2QVZlVmtNeENzMHNodS9HeEZxbEhKT1g3dk1wZlVKa1Y4?=
 =?utf-8?B?ekhMaHdaZUxUS0xGY2h4NzVybDFRNkFzNk8wMlM1a3Y3S2Y4N2dUbTkvUE1o?=
 =?utf-8?B?djF0SmtJc2dzWHdkM0xkemt4ako4RnFmSVJwQkdhdHBPWTlDSUNFb3JxQWZn?=
 =?utf-8?B?VFEyYlNSNVBMTlZmSUFhZU1TakIxNmJrN3NVMnNCZzFmUG1zZTk0cFczb2JH?=
 =?utf-8?B?am1jeGluZ04waFQrVE1jbGlIRklEeWE2Z0FGV2hiZmdyTVJqR0pXeEhUdGV5?=
 =?utf-8?B?ancyT0h0cHo4b2htTEYrcC93bFZRWnl5ZjRkbjVHcjAyN0l2RTZiSCt3VVEr?=
 =?utf-8?B?WjNlN002M0xMZ3pMblV6RXk3T1VNYnhOeHBQcERzMzNYbStDMDVndzdBeXBl?=
 =?utf-8?B?SlRGRFN5Y2VZVVdEQW12Y2FrcnBCVjcvMUZlNlZ3UU9nejg4K21MYjM3YTJQ?=
 =?utf-8?B?YVFuSm42YUlaUEd2TUI0QkdZYWk5bEVWdTJSZDhKZWQyUEI0ZkhvMjA2SXZO?=
 =?utf-8?B?cmV3UXY2UVhkTVYxTVVaQXZORHkxS3kxWjQ5ck43VEFBaU4wZHZuaHVBelpP?=
 =?utf-8?B?bldIVGdsdFJhb3VOcFFtQnc0T1ZFcUVRREZpUWlRQngxaDVPZzFnSmYwcTdQ?=
 =?utf-8?B?eWg2MmJIbkdBVWFmK2FQVUYxSHNyVHF4d1UzcWJaOHRvTXRobGdEaDltSzBU?=
 =?utf-8?B?dmNMcXJDUjNUYU5UV3RSZC9aWEJVMHR0bXhpdk93cXNkV1BsS3NnTzlkR0FK?=
 =?utf-8?B?aUZKZFYrdE1DUzdmcytaWU5nclpWUjUwdGVwWnZwZW9TeEdMUm5meHduTnNT?=
 =?utf-8?B?Y2NyY2hoMjN5K2ZLTkQvaWpsRjB3cDB0T3ZmNU8yNkdpQjZrTEM2WXNGdEk0?=
 =?utf-8?B?c05OSmo1TGR4Qmprdy9zU3MrUlV2TWJKbEQ5Zk5kZEcvQ1U4bW0zbjJEQXFa?=
 =?utf-8?B?ZDZJVFBHa3dESWtZV01rTTFSR0lJU0dFTmFiRUNSSnczaSsvWE45dHB2ZXh4?=
 =?utf-8?B?RldjdGc1R1JnakdFKzJzZUVmcVNOam1ERCtUcjM4S3N6OWNYcklJRUt4TWtH?=
 =?utf-8?B?M2hacFVyNUQ4cW1jelc3dDBITUpUZGkyenFYS0gya2R2c3c4YU9SVEJIUEta?=
 =?utf-8?B?MzVXckRnWnErN0ZiRzk1RFdtMSsvVTk3UWVzVk1VZlQyMEF3MG90bFdtVUZv?=
 =?utf-8?B?aUdjOU1rV3k3S0owNlVjZUE3RXMzWW9HSWt4L3ZzOGNxZHZMb29HYmV2RjNv?=
 =?utf-8?B?TngxZlc3MHlYMkJySTVHMy9DaFpGQjVtUU1yS05mcXBJU0xYSk43bXkxdHdM?=
 =?utf-8?B?ZE5DVFhabGVheG54MGt6MjA5Q3JJSkNCWVBhTGhMOGppSUlQRk1VTHRGUzFI?=
 =?utf-8?B?N2d5eXZrZ0RWUWpNQjVqbU9kT0FSK2NjQktxcDlYTEozTm8vSmZueXBYMU9C?=
 =?utf-8?B?ODk3dzdNV3ZrZHJZS21PMUJ0OEZOOEZIdlV4TkJvZGZ2emM2cXp1SGNvQ2xP?=
 =?utf-8?B?blQ3S25tMExteGVjQk40MG80NmpqV2tHQkNOQ1Y3R2F4aTZ3NkRUbGxPa3RZ?=
 =?utf-8?B?NmN5Njg5eGJSUTJqN3Z0UXZRVzBqbWJZK2hGVHVJREZRMnd5NkRXZU1iZ2hh?=
 =?utf-8?Q?5JGV7GeNM3E=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5041.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NVVEVXFDZ2ZIUjBCUzM1WWR0MTdsdVpGUSt4YktCT0RMNzZqUUJWNE1KTHRj?=
 =?utf-8?B?QlNkN0hZQ1VhSk9JRjA3Z0psWGNuRVpnbGcrakQ4REh2aUlkMGs3SjBmNk43?=
 =?utf-8?B?QUdTYThmeXlzamp6YlZTRTRvZC8wNE9NaW4vd2JRdXZOQmswbWF5eTF5RHE4?=
 =?utf-8?B?b284cnpHM3VjUkUvOFFwcU9SWmJNMDZ3T1JPdVRodS9BYTdtVGlQMU9DWE9n?=
 =?utf-8?B?VXVqUzBpVm1DcVFJVWZJbkRjVkg3Q0hhWWxHOUpTOEFSU1BaM0NiNlV3aXRn?=
 =?utf-8?B?NXZwcGJtamlER1pUSlpyTDBNb3hpalhkZUhUNXVzSldEbEJXdS9MTW84SzZi?=
 =?utf-8?B?V0dGOTJjZFBLckRsR01OVkdrblVZUkJ3azF2d2pDUDl1TmcyeDdEZ0hjSDZr?=
 =?utf-8?B?RnQzRTFpOFBjeHJVVnZCdEUyMnBkeTRVY1dBcG0zRWFkUW9DUy8vaEZpay8w?=
 =?utf-8?B?aGo1cE9sSnZYUHAwYmZldCtqVUZxek1rbk15dUtQeTBtMXVXSndJSVY5MW03?=
 =?utf-8?B?blNRYlpjMloySTJZTXVHbk5oeTdZRkxqS2gwL3NwNkMzTHF3VW1CR091QWN4?=
 =?utf-8?B?UVJ1VzZxRk5CRnNuMnQ3L2xwUXg2bVNWb21NeXhQYmVqUnAweGpYNTdFL05R?=
 =?utf-8?B?OUFTOU1wbUtJQU1CaHN0ZTFoNGtPQjljMnVRajd2THp6Q2UwMEQ1NU1GMFVa?=
 =?utf-8?B?UVllc3VDOGFCbFJjaXRPOFlSUmwydVpEdDRVditGck5XRU1DSjBIZmVHRDdV?=
 =?utf-8?B?YTRNemtLcWxDL1JLZzJyZCtwb0pSY3graWRWWlMrZnRNZlRqSXBLZE1Mb3h0?=
 =?utf-8?B?MklJYllWNlVubU5HMmlMb2w0U2w0SGdXUThmdU8wOFcwN2NQaUNRaFkvd3pL?=
 =?utf-8?B?Q0JLaWVGRStaQlNETXZ0MkxGZ0h2dDRVaXJQekxHOUhXTjJmRSt0N1l5U2Yr?=
 =?utf-8?B?Y3BBVTZRMXRkSzlVeERGdktCQzJkMTZRdmtsZ0tDVDVNM2JuR1BzQ2F5L2tl?=
 =?utf-8?B?dXZkUXQ0ZzJJa2xaeW8yMC9YUk9UWVhJeWc2KzA1aE5RcjZxeEI0SU82dkRM?=
 =?utf-8?B?dFNZdS9sN2kvWTA4ZUlzdmt5Z3U3TG1wNXQ4aHNjU3JRS25OaS9SM240a002?=
 =?utf-8?B?M3p1WlU3WTNsei9NWDkwdVhRYnRLeDBITDJCNDlyT05HbmliTzk5TFMyNzhY?=
 =?utf-8?B?MGhJMlM2N09oYXBYM1lCb0thY3FhUHcvN2RrK08yNVJQcnhQcXJTNVh5UEZr?=
 =?utf-8?B?VVBqcHNEV1JrelFRRTYwYkgyZGFseFF5RHd0Qzh0VWN1VHg4Ri9LUHhOa2pl?=
 =?utf-8?B?aTVDeFh4WjdBS3BOZzNVUTNpaDFvOHNxRkxBSmZaY0lnU2ZpT1pubEh6YjBV?=
 =?utf-8?B?Q1V3N0NSWUFTbFE5bENuKzlQUDlwcHVkYkZTNTJEaml4dGxrY1ZoQjBFY21n?=
 =?utf-8?B?RFdzME9HaU5MdDBQeEFrTE1ncEowR1dXcTVmYkhDcjlsZjRDL2RRaXkvcFlh?=
 =?utf-8?B?NzJyeUlyRlhFQ2piQkhOaFl6ZC9QeUQraDlTNEYvVHJmQy95OUZWcjhCeHlv?=
 =?utf-8?B?Ums3YXdTWEhXZVRNdXNFam01cW1qWmViQXl6cnRERkMzYlZudFBSS1lycHU1?=
 =?utf-8?B?czN3SUtUa2x6N3pYd0RPbmRxeW9Ud2RXcHphbzBSQUF5eWN1ejhjS3ZNYks0?=
 =?utf-8?B?aEtmeHFRK1UxdGZramZ5cVlvTXFPNlZtbWxJSU5PVzZ1NjFlcktXNFRoemxl?=
 =?utf-8?B?M3RobFhqaVZHWTlFUi9mMERmaHhOYVJzVzl0ZGcyQjg4RGlpOXlMb1RVMWx2?=
 =?utf-8?B?ZGFIWGg0QkQrdHJiSnpjQlp5ZVl2czYxVWI4TWszUlh4bEtJUkppU2Rva0dE?=
 =?utf-8?B?K3VXQ2k0cStJS040djFzV3BNaUN4Wlg4dnhNTklPb1JBeUdycE5UZ0thcE9P?=
 =?utf-8?B?bjlDaDdOb1hJaHBOVXJHb0hJS0V3QkExSzJDdGw4MjIzRlhJNVhMVXRnUURK?=
 =?utf-8?B?Y005UEwyWGxpN2c2Qlhkek5PKzNxWWpxS0VnRXhzWGxudGpVZ3g2Tzd1YXRh?=
 =?utf-8?B?bG5LTWlncnNZYmRGdnY4Z0drNlhyOG0vL2drd2VIUmtyVTV0ZGMyMDFoL2NO?=
 =?utf-8?B?bjV3ZTAwMmN3RUV3eXdZTEU0UGZtODhuSTRsTHFQclhaSW5SbTZWODRHSzNF?=
 =?utf-8?Q?Hs3tcLAjWrZik2yPnx6xVlg=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Vl+qGMKzJ+aPJDXX24Cy/sgmehWULgmYq5K/+pDcJUHZACv9sCADIm4Pd7XvAeNTtn9FLJzQ/v45K8pIupEGPuBDd3xHFdWjnTIG3kEg8qrGqUK0QZCZU/fE3bqpXZS17UyihdnwESmVvdM9Z+T4EVnVWze7I6E3a/GExKqkUlPyXPUnm9Psjyk28i1PCRxJqjMT8ioJ6z1oZj1L9w9HBAiDndAePw44pYiYq9l+cTsT5fHO6+qNL4/XC8AxRcnXFL96Ds6ZXsymXXTkRMrYACHUwlo5vE6e0FTzl848/p/IBFmb9Mv3ziCZ+zxfvzNv3/JkRl1UjpiWwIEGPi6lDuDkJy2dq+SiLX+1YJoQXG2+bPLmLrFcDWXpne5WKQZ0aKtJkuOey6e3kJel73+6JDDuRxXrB2az3YLP4uQ7jpfCcyHBYsGRjvuo9hMYTVuNuVG/yTdXqsiN/5SzpydnLDd0o2Vb5Bdv69WvZkbbqh5Lb02KyLzGjdEIH4uRg3LPx4A4ZjNn3YwOTU7w2z9aK8kHJAOFz5Bopn1p01tehzTbkW38/L38oRgEjViRCK4Qi2QSnaLMKTHre2C5HvbfTeBwvJv4SFtcQ//qzC1udFo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76860c97-9f21-4edf-3679-08de0540309e
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5041.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2025 01:23:58.6425
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1F8lATe2oql8csr6uu9ylUV6GOMqtHjP3AWKxOj+9qa1wEOpNBl/6JWgvGQJdErRgpgcoeWCRYzJetHL64IggcouN5yxYO2xbrs/S5wKGuE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7187
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-06_07,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 phishscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2509150000 definitions=main-2510070010
X-Proofpoint-GUID: mrzFN8alrj2D9fyEre--NVEc4h5kvXFW
X-Proofpoint-ORIG-GUID: mrzFN8alrj2D9fyEre--NVEc4h5kvXFW
X-Authority-Analysis: v=2.4 cv=SPZPlevH c=1 sm=1 tr=0 ts=68e46bb4 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=P-IC7800AAAA:8 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=NEAV23lmAAAA:8 a=W8Edxb2CRnsGHHFYsRkA:9 a=QEXdDO2ut3YA:10
 a=d3PnA9EDa4IxuAV0gXij:22 cc=ntf awl=host:12091
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA3MDAwNiBTYWx0ZWRfX+dhq9RIJCB9n
 WC7p3EdZJFPLST5t7XB55F2gqNQXsyd9zxGDoThefMLJIaOdatxXB1y/ZvrXduh910d+ULo+xXB
 3kYPrpvkzbExRrTvDe9qPfXGxSc865Pml2Xi7T92IgxQi+ANlWYT6sAWr69++ELJB1VsRh+C5g4
 yIPpENZhQIBjOE0or74jVf29bEp1s06W6YBZIwe93HjwrA5/kehnmIjhQtzANjQ8MDYD6J499h0
 j5oR6bwcM5/cN8ETxfFbzNhjdfUxF2ZKpBXJdp93iMCgnByIouFvkPHMqpJvEuDAJdGD5q5BQGk
 dVQkO+dp7X6YL0wRhrnV31NZuHyKYdPCYg2NejoJCA5A/yKzJkwqNVC+Ol8S+KJzBlI7GEkG18e
 pOXf5jhw/L+XeSsd5cFwrnqdQTi0HF/GTdVGUA15CV5R7Dx74Sw=

Hi Alex, Jason,

On 10/6/25 8:39 PM, Alex Mastro wrote:
> On Mon, Oct 06, 2025 at 07:50:39PM -0300, Jason Gunthorpe wrote:
>> Could we block right at the ioctl inputs that end at ULONG_MAX? Maybe
>> that is a good enough fix?
> 
> That would be a simpler, and perhaps less risky fix than surgically fixing every
> affected place.
> 

If going this way, we'd also have to deny the MAP requests. Right now we 
have this problem because you can map a range ending at the top of the 
address space, but not unmap it. The map operation doesn't overflow 
because vfio_dma_do_map() calls vfio_link_dma() with dma->size == 0, and 
it grows the size later in vfio_pin_map_dma()...

https://elixir.bootlin.com/linux/v6.17.1/source/drivers/vfio/vfio_iommu_type1.c#L1676-L1677

> If we were to do that, I think VFIO_IOMMU_TYPE1_INFO_CAP_IOVA_RANGE should
> report coherent limits -- i.e. it should "lie" and say the last page (or
> whatever) of u64 addressable space is inaccessible so that the UAPI is coherent
> with itself. It should be legal to map/unmap iova ranges up to the limits it
> claims to support.
> 
Agree.

> I have doubts that anyone actually relies on MAP_DMA-ing such
> end-of-u64-mappings in practice, so perhaps it's OK?
> 

The AMD IOMMU supports a 64-bit IOVA, so when using the AMD vIOMMU with 
DMA remapping enabled + VF passthrough + a Linux guest with 
iommu.forcedac=1 we hit this issue since the driver (mlx5) starts 
requesting mappings for IOVAs right at the top of the address space.

I mentioned this issue on the cover letter for:
https://lore.kernel.org/qemu-devel/20250919213515.917111-1-alejandro.j.jimenez@oracle.com/

and linked to my candidate fix:

https://github.com/aljimenezb/linux/commit/014be8cafe7464d278729583a2dd5d94514e2e2a

The reason why I hadn't send it to the list yet is because I noticed the 
additional locations Jason mentioned earlier in the thread (e.g. 
vfio_find_dma(), vfio_iommu_replay()) and wanted to put together a 
reproducer that also triggered those paths.

I mentioned in the notes for the patch above why I chose a slightly more 
complex method than the '- 1' approach, since there is a chance that 
iova+size could also go beyond the end of the address space and actually 
wrap around.

My goal was not to trust the inputs at all if possible. We could also 
use check_add_overflow() if we want to add explicit error reporting in 
vfio_iommu_type1 when an overflow is detected. i.e. catch bad callers 
that don't sanitize their inputs as opposed to letting them handle the 
error on the return path...

Thank you,
Alejandro

