Return-Path: <kvm+bounces-36692-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D8C27A1FF84
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 22:16:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 35EAE164592
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 21:16:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E99441A83EF;
	Mon, 27 Jan 2025 21:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EU3JCaVb";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ACbyG0VR"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BF42748D
	for <kvm@vger.kernel.org>; Mon, 27 Jan 2025 21:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738012598; cv=fail; b=llkImQMbVCDNZp1wyggUzmhQK3hGiqPFPB5IgXlFEY72xjMQ7SyXvVqCWqgUS+3XZn1oigwJdIztDh+t4iOw9WlBJuR4GGZsE6Zh8aEPdwbyvB8eWO9d63j2tkof2Q5/ZcR+8JYUbgGZ2qvZeh08fHZQFMFyAdsodZFMer//jVw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738012598; c=relaxed/simple;
	bh=vbowUxgCQLg2PvlT/90z9MfWcLijWsS4vjMLC/nKkN8=;
	h=Message-ID:Date:From:Subject:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=aGkGi2SGU3oN4uwT9jTnORjgPwwl7xJ7Hx7cSe8Dz3q24MywnCtIZcrTHoto1O8K7fOPrrLDI2R5iMl3RBus/LM2QiWGPCUuzPASc7bH78AmdGYvErR08+937In6C/eoY2NZP1HUqT8aMVkmzt+MY+LFBDjHcsnBj0mpAFBjYOg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=EU3JCaVb; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ACbyG0VR; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50RKBj66017641;
	Mon, 27 Jan 2025 21:16:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=0kAUqQHuL7ISpkcz0P1BHET37rON+PhP36uYyb+pYZs=; b=
	EU3JCaVbpgTyRTnePn2PkWEfFAvGfY2LG2285Gyqp/NapWO5wEAPY1OFfq51WF73
	qQ3kRdw6TWf1HhN7LC26gSmXiw75e1fjy7LHVfVgMdjZj5MQBeoTczM64XI8Lpdh
	LIqIiNYXXKhxr7JdEguuCkNrcVJpvu20W5GdNIV9TnX7aku5F0laUZG2m1qQ2chI
	ecRVlBGnAAxjT7MimJt/rdr6JdzBtwyr7+Hi/8V6SVsN7MoP1D1TDgjYCo+KRf90
	CDDdCMBUWUv109P1f5QtHzec3pLNt/F/bndvu/w4Z5ptMK3OegaOsD9IF467f/Zw
	Ct/68bgPFJ1fKyFVxaDDKQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44eg5kg89h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jan 2025 21:16:24 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50RKwSeU036385;
	Mon, 27 Jan 2025 21:16:23 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44cpd7gewx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jan 2025 21:16:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BdgSRgFbeP0BBK6ocmzbqlM7GerdK8NCxnQwsi6pLy+SbRoYfSH3gpTEKd65qBEUxm7v2IVtZ1vSTkVb59fnz1hwF4wAbeF+W7/iHTQAU++9q+CnKpcM1u7H1ZqJe118v4jA5lJc1MsaPQ54A9Hht62mSo5xissV365c+xOpveAZ2KF1U4/z7DgcrhsrGNaAap/sWwa2BkE5FLo5w780NjB6F9unouAjv6WClm0uJ1bWxGU8fFDRkEXLQd/OTSIxBept6GQumasVHZQKf64CZV4CJB8eYWOO3Mt0P2ESFg5MebYzB6bekptyZpd7WSyEA7RlksKLRzTaOJj7716dxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0kAUqQHuL7ISpkcz0P1BHET37rON+PhP36uYyb+pYZs=;
 b=V+AmJmCD2+XabSVCN5wcUKvc0jd1W2cnwqUyM0S1NNApLA9aJXwgX6tMKja/aEQTBykpA1getGHAyuWjpOGs6b3ZpTkeTIlwgTfsGxot34kQGegkRIQHBwwM1ipKLl/pL8zCE4u0nE0qw//WTpx8qZKCMx7Iy/lkAgPXcO5UHsxUWPA0or+RS7bBMEjLrqVve5NYw3JcoKseSHjeFi3/pY3e2xDVl6Lg3u3kSB8gizoqUF/JJMYs3js4QtizE7NqzITNe7j7NQx00nvxsHW90+mSLRXw6Twjf8JLe0Ov1paR9tiVgkec1sUMoq4606Q9Ve104443VS/CXSORYtu+cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0kAUqQHuL7ISpkcz0P1BHET37rON+PhP36uYyb+pYZs=;
 b=ACbyG0VRxHKpbEY43LxOrlTYcOqxfFDl4B2/PjjsDqrc/OtzdAEbCPF1Z6Qzw5fT99YxmFXoIkH/MfLrpSdBvcfIqUuBDYHrRCuY1xn1CZHjOzkZpRYhH2nIfIxqVge4tMxNyJksY5RG7JWRoG4L1cYB0GkzNwuEK6f/38ASPEA=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by LV3PR10MB7938.namprd10.prod.outlook.com (2603:10b6:408:217::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8377.22; Mon, 27 Jan
 2025 21:16:21 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%6]) with mapi id 15.20.8377.021; Mon, 27 Jan 2025
 21:16:21 +0000
Message-ID: <119f7ca6-6e78-4792-b2db-9583efdf57e8@oracle.com>
Date: Mon, 27 Jan 2025 22:16:12 +0100
User-Agent: Mozilla Thunderbird
From: William Roche <william.roche@oracle.com>
Subject: Re: [PATCH v5 2/6] system/physmem: poisoned memory discard on reboot
To: David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: peterx@redhat.com, pbonzini@redhat.com, richard.henderson@linaro.org,
        philmd@linaro.org, peter.maydell@linaro.org, mtosatti@redhat.com,
        imammedo@redhat.com, eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
References: <cf587c8b-3894-4589-bfea-be5db70e81f3@redhat.com>
 <20250110211405.2284121-1-william.roche@oracle.com>
 <20250110211405.2284121-3-william.roche@oracle.com>
 <83c251ff-60b9-4a31-b61f-466942bcf34e@redhat.com>
Content-Language: en-US, fr
In-Reply-To: <83c251ff-60b9-4a31-b61f-466942bcf34e@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LNXP265CA0030.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5c::18) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|LV3PR10MB7938:EE_
X-MS-Office365-Filtering-Correlation-Id: 290ae0a3-cfa7-4a4c-f4ae-08dd3f17d8ad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Rmt2WVdwaTV0bDdWcFZ3d3BaVkFlZ3VvbUY3Mm5Wdlhtbys4VGF3NVhqNmRx?=
 =?utf-8?B?c1JIOGdGOWdCaFlvbVB1UXhKbmlBRW9pR3F2N05KL3Qxd0JxQjJ2dS93T3gr?=
 =?utf-8?B?YU5GOFZHbjZsVVJXTk1qNXd4RW9ScSs2QlEyWU9Rb2ZrRjdwcStFNWhpakJ3?=
 =?utf-8?B?aWM1NTcxRThoTUlFRmJjMitNQXNQVjAvY1k4dUNVdTlwQ2drb0xROXpUbzha?=
 =?utf-8?B?ZGwxMi9rTkgrL252NzNuREd1d1RGL0tIR0l0Q2g5QlpPNk1uL2xTbTB2Qitj?=
 =?utf-8?B?NXZEcGpPdWVUZER4b3ZLbEVaaVNGSExETU5Kb09ReEhNU21uT2JuT2NKSGFZ?=
 =?utf-8?B?allRZVYxdXNJZGpnZFN5OE5ZanFLQU9ta0JTNEdaMDJwdk9xUmtWZS9oSUxC?=
 =?utf-8?B?VmRsbzFvNWw1R210endzVnJ0Lzd1amY0TUZLWU94YXRLdE9NS2NlMCtrWVdP?=
 =?utf-8?B?eE9sRTk0Skg5RUszSWF3eUpqcnNCZExXVXVDVmxIR1Vvd1V5dmFNdnllYllG?=
 =?utf-8?B?SjFrWTZReDZMdWR6cDRHcmFIUWpGZWFGR0FpdWpBVmxVTm1vMGJCd1UzbWxH?=
 =?utf-8?B?NHBUSmZxaVp6L3l4d1dIQXdlZ0VEVGFtd2xQN3ZVVlZXajk5VWtQNWlrT0da?=
 =?utf-8?B?OGFBTi94ZG5Uc3k0WG1nVTkyT3VuYkRjVjV0U3M2S2lpZVVSNHNVWk1Zemd2?=
 =?utf-8?B?UFhWNE1vVjZucER6VlFPaVJta2RxTzIyL0E0dnQ2ZktXSVhlMEJoU21CTzhv?=
 =?utf-8?B?bFJjVG9SU0IyNmM0Y1FDK1JNMllldWVsSVFDUmVYZkc5NXU3YXNQbXNxeTdS?=
 =?utf-8?B?N3FGbk9aSjNZVjd3cXZTSXNub25uWGhaemNVZ1E5Wk5RU29rZ3VHTXRmS3pl?=
 =?utf-8?B?N0R3KzN0aFN3eEl4OThCd2g5ZCtzaHRyK2VDYU5VZ3hPNnhPNzQ0UXAwVk1Z?=
 =?utf-8?B?SXZTTDcvV2JGYThrVkQ4UHh3ZlAxV0RGSS9jYlhPWmEzRC94MldEVFVyb2Ev?=
 =?utf-8?B?VVZpSDQwOUhDOXhZS2lSWEh4R3kzYSt6MFJ6UWlwbjBCd2xnaVRFL3JzU0dX?=
 =?utf-8?B?RTJuc1N4UHU3dm9wakU2eHJvQnNlQjFNWHV5Q2gyVFNYYURoY1dHaTlxRlV2?=
 =?utf-8?B?QVo4UTRDNVNHZ3pwenFuZGtsS0R0YlUrUEJTYktSL1lJNTBrQ3JRQU0xSEY0?=
 =?utf-8?B?cnBaN3FOMVZETURqNnBDazQ2UDExT3RyTk5JVjJwYjVWK1poUTVzbTVwTGJm?=
 =?utf-8?B?a1RkRzVWOUVpZ0l1a28xT3lPM2wrUVRWWUVVakZmOWY4andmeFJqaG5FWUVh?=
 =?utf-8?B?Vzd6UzQ2SjhQUGd1dGV3bE1nUklyRUl4RTNEbGpmVGd2MUpHeDFNcGtXa0xZ?=
 =?utf-8?B?TnN3cVpjKy9BR1JyTkZ2YnBvNy8zbFlMZlNUUkRzZ1hzUjZGbXpBRWxzcklS?=
 =?utf-8?B?NDZVSHExNDQyQjhYVnYzK0ZtV2NGM1U4WU9URHg4VmtWMXYxc3YvQURHbVF4?=
 =?utf-8?B?L3pkQlplQ3pZRndqbFZYWDMxM1FRZnAvcm1xeHh2L3Z4cys0dUhkbllIUjBu?=
 =?utf-8?B?TExZa2FFbnNqK1JxUXFsQU5JRmRPZU83RU8zSW5LcmVOS0NRelZQekZBSkwv?=
 =?utf-8?B?bWNjZXZoR3B0RnhSMHJ6YTAzY0hqQUM0VjQ4QjBsbXJQT1J0b1R3STlVRHZ2?=
 =?utf-8?B?d3dScVdOWFdONSsvVzVEMHovV0F0d1krWllrWjdKZmg2S1ZhUEFtNGM4T1FH?=
 =?utf-8?B?UFFGSVJJVVlkTWxrcUFyV1FjZFYxdC9LUzhNa2xoZmlFbzdzeWcyRVI0Y0Rr?=
 =?utf-8?B?amtVWmprclh4WFNKMEJRYnFpUnQvMUZiVHh5cTk2T2N4NXgyZG4xY0E5WEhZ?=
 =?utf-8?Q?aIpI+dglmThJ9?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?ajFZelBFUURCWG5DYUIyeE5aVnVXU3dTOFRJQ0hXRXEzOU1VMlNialJtYll1?=
 =?utf-8?B?alZlNmdMQmxkZkxrUkUybXB0ZVRuUFZDTzBValI3cXFoSHM3UURRWmhkL0Rk?=
 =?utf-8?B?Y2FVN1dvSjgxZmgxSktSQ0ZMcFYwU1hDeHVqRFRycnpHUUFDcS9DMlBWakFL?=
 =?utf-8?B?alNSNmNsYm5sbWRqT2JzcFdVV2poQUsyQmU4WWRWb0taak9ncGRDd2UwT04v?=
 =?utf-8?B?eit1MGlZNUNsS2FaekZOVnQydVJyeFhxbXkxWGRjS1dyYnRwU25od1BWdUtq?=
 =?utf-8?B?Z3pCZmsrTHlVL09QTGtkZ2JmZHdaUFlFYi9JcExQM0tVRjZlSllHS3E1a0cv?=
 =?utf-8?B?aXJHK1hWUzBKTzdMMVdsWDlVQXRTa2hzRERJejh4cW51djl6MWVSdzVWKzZ0?=
 =?utf-8?B?NUJhZG1UOFJ5SmJ2dVpyMDdtVlNMUXBSVzBPdWN4L2ZncWRBUDlUUWJ3Q25z?=
 =?utf-8?B?TnNmbndOc05Bb2pic1M3Z3BPMlRPenNJcmNoRDg0NlhkZCtJRXBSdGNpNk1N?=
 =?utf-8?B?amowVHdPWTlZNmI3Y0syMkcxRFloOGtZQnZjT1VKcFBOUEQ2SDZoSWdRUDFD?=
 =?utf-8?B?TUVpeTVmSlpINEtybUNsWVJjWEJldGxOYmR5RWhCMVNrVlZwQ1l4SllFS1hK?=
 =?utf-8?B?dURjcXk2bml2SW1lZWVwRjVNR3FlMXBhaVcrTWtkUzhOZUszR1RuTzlBNmxy?=
 =?utf-8?B?bkFGZ2F4L3JIZVZJWENEdWxrRzh3SnBYKzNiOURtQVNra00vZlRIZGFpNVJI?=
 =?utf-8?B?cjk0Y2dHVFdLbHRzditNTngzTE5rOStiMFlzbFRjQ0NsMlFEWUkwS2x4L2pw?=
 =?utf-8?B?QUhjZDlUVHR5WldoQlhTOGxuOGhIMURFVi9rdE5TNGpFT2dBZmphNEdkdjAz?=
 =?utf-8?B?cEg0OFBFb1Q1Ukd3a3lMbHBKdWU4Mm9ZbjRPcGhtSWRRZkp0RVF6VStiWjFC?=
 =?utf-8?B?cnVTVzI4TE9FaGtTbkNVZkdCU1plNjA4UC94THpFcHMyZTlCbEpIV1dpOE40?=
 =?utf-8?B?dXlhRUU3QjMzRlJMWUlkVW1jSmw5em1OQTJGWi9KeHVsbjJvOFlMVjFjdm1P?=
 =?utf-8?B?N1lsRG9NQ1R5NW1GUW9zcGJoUXVlT2hTSnFTaFJFM2pBUzZabkxSaW9QeDdM?=
 =?utf-8?B?WDRkQWxvTTIxN1hFOVB1VGpxd1EzcDlpT2M2cytpN2dUMlFUZU9FLzlNMkp4?=
 =?utf-8?B?bmhVMlBQbWxmZ2dDaW1VRERRMTJmTE9oOG1ST2dnRzZDQVNEMVNRamVITnJO?=
 =?utf-8?B?NTVpUUdtWWdaS0hMOWNpa1FEQ2hVaGFPbWJsRStGRHBnajNlY2MvUXVuV3Zq?=
 =?utf-8?B?SkwvN0hCZ3ZCSjV1TmNHcERoYWU5YjMxbzFsc05McWFqQnk1RUFTdEtQUEF2?=
 =?utf-8?B?Y2NEYW5OVEdRaEM3OEFjcHlSVEVqYmZBclBVbS9WYlRSU1RCV2h0U3VjMkNN?=
 =?utf-8?B?SUhUMzFkZFVpVWhnOCs5Y0F3cDc5TktVWVBjcDd3dUIwNEFNc3dybHkyMlRS?=
 =?utf-8?B?ejM4aDJ1QitCeWRaNEpydVJKcjFweENTNEZ2UFVCSkN2U2pqdUVxeDVEVHVo?=
 =?utf-8?B?OC9HdDRWVUltWi9pOGVKbU5BVHcxK1RoZGt3ZTdZMkcyMThoUlpwTWcxa0t3?=
 =?utf-8?B?SU1PYXdNcGVTSmxJa3VSNHJMSy9Za3lhVzRGL09xVmFLUUJmUTZMNUZiWVZa?=
 =?utf-8?B?RDFsOGd3alFKb1NUNFhEcGRZMGRsMkxWZXFtSlRLRElla3VMdERyTExSSWpy?=
 =?utf-8?B?TzlBZkFUWGYyV3prdzZtMzlROEVuOGdFQ1VzRkZjaDMvYnZ5eS9RUmJDSWZm?=
 =?utf-8?B?dkFLSmx0QnBhN1gyNVNNaHU2d3VLazRPSkZsMDQ5SDlwZTMrZ3ZNOXBXRXZQ?=
 =?utf-8?B?a2hyYVUxbGt0SFRDTnZkcWNqclBZWEF4Zys2ZklCMGh0N1NkSGNNSXdod3BX?=
 =?utf-8?B?N01YQzk3TmM0YitseFVidWFPTVRITUU4YUs5TnlkaVVPMUdaNXRVR2htNlZl?=
 =?utf-8?B?Z3VKajMvZEUwaDRRdjE4YXE5TWRKM3Fra0Y3aUxpS0lEWGlMSTA1S0lBdUQz?=
 =?utf-8?B?SkV1Tjg2NG1DSTJUVktVYzl4RlJDTGZ2ZktJWHBkSUN6VUpEbFFnQ3k1eDRj?=
 =?utf-8?B?N1pSOHJzUGprWTZoc3FHTmozWUNabUxtTVpQOUFHMUxGcnBmbllyMTllc3Ax?=
 =?utf-8?B?QlE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	GAworvUtHpjkCxK5ir+tYlluiUmXlmFWX8kqOwi8O2esnWPi/ivKMoa7Xqv5cZXb46k6/OPhiTSQlITauD20aAiTBECeqo8ZJ5xTt+gsCwviyttLZKvAUfrFPa/c/QTvvjX7+N+Us9EfkVp9GXNHjbxqqLsFGkDTMoU4NfptmhClk7gEWJip6eEbvVCvdNSPrmg/1rGbL97L3y9Cwg3lUbmHQoLjSibViMOfGXb3aDYGDKPkeCJmmT0mqQ839VFuEFwDY2xjhlMYUZ08klFpjXcw/YQBZoF6K/SA8AUkbqkUBO39ZeIkEHzCAHEGpM689vku4gTlh74mnvZMT6YTwfOyQYpjytGozD9uz4lSX0pTTEnRaPnLRqGENI0HjEzidenRyGr+u/xiBwXLY5BXC+nbj5UulLIeQ74u5wjDo011qpfey+ejeEz7Bs1rvRwe7nLq+ZQ1fWBk7lA+1vBaC08KGk9MXzSWWIpy2UopxeSKESRB/csWaFhghgqCr/xZVl8OuWjE7Fz+2wSgtlCZLeHDk2obtoZ//OPkA5TE14H9aFpKE6bCVG89sFX5KJlijP8N7PAPsCl7db8CmIyFYy+IxciySBxWbI02nq/POaI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 290ae0a3-cfa7-4a4c-f4ae-08dd3f17d8ad
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2025 21:16:20.9899
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ksMs0K21AvayJjKpUZOwubVEpp7TbTaoS6zLGBuYeeulX2n2fy6FTakRlTIJIxdxv1nrRsAf731YIw5Q/RTUT0voJtZcCEFgbtVNamxGOXo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB7938
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-27_10,2025-01-27_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501270167
X-Proofpoint-ORIG-GUID: 1vHFaPbo7fzEU6UTmP1EMurq74MyuwlV
X-Proofpoint-GUID: 1vHFaPbo7fzEU6UTmP1EMurq74MyuwlV

On 1/14/25 15:07, David Hildenbrand wrote:
> On 10.01.25 22:14, “William Roche wrote:
>> From: William Roche <william.roche@oracle.com>
>>
>> Repair poisoned memory location(s), calling ram_block_discard_range():
>> punching a hole in the backend file when necessary and regenerating
>> a usable memory.
>> If the kernel doesn't support the madvise calls used by this function
>> and we are dealing with anonymous memory, fall back to remapping the
>> location(s).
>>
>> Signed-off-by: William Roche <william.roche@oracle.com>
>> ---
>>   system/physmem.c | 57 ++++++++++++++++++++++++++++++------------------
>>   1 file changed, 36 insertions(+), 21 deletions(-)
>>
>> diff --git a/system/physmem.c b/system/physmem.c
>> index 7a87548f99..ae1caa97d8 100644
>> --- a/system/physmem.c
>> +++ b/system/physmem.c
>> @@ -2180,13 +2180,32 @@ void qemu_ram_free(RAMBlock *block)
>>   }
>>   #ifndef _WIN32
>> +/* Simply remap the given VM memory location from start to 
>> start+length */
>> +static void qemu_ram_remap_mmap(RAMBlock *block, uint64_t start, 
>> size_t length)
>> +{
>> +    int flags, prot;
>> +    void *area;
>> +    void *host_startaddr = block->host + start;
>> +
>> +    assert(block->fd < 0);
>> +    flags = MAP_FIXED | MAP_ANONYMOUS;
>> +    flags |= block->flags & RAM_SHARED ? MAP_SHARED : MAP_PRIVATE;
>> +    flags |= block->flags & RAM_NORESERVE ? MAP_NORESERVE : 0;
>> +    prot = PROT_READ;
>> +    prot |= block->flags & RAM_READONLY ? 0 : PROT_WRITE;
>> +    area = mmap(host_startaddr, length, prot, flags, -1, 0);
>> +    if (area != host_startaddr) {
>> +        error_report("Could not remap addr: " RAM_ADDR_FMT "@" 
>> RAM_ADDR_FMT "",
>> +                     length, start);
>> +        exit(1);
>> +    }
> 
> Can we return an error and have a single error printed in the caller?
> 
> return area != host_startaddr ? -errno : 0;

Done.

> 
>> +}
>> +
>>   void qemu_ram_remap(ram_addr_t addr)
>>   {
>>       RAMBlock *block;
>>       ram_addr_t offset;
>> -    int flags;
>> -    void *area, *vaddr;
>> -    int prot;
>> +    void *vaddr;
>>       size_t page_size;
>>       RAMBLOCK_FOREACH(block) {
>> @@ -2202,24 +2221,20 @@ void qemu_ram_remap(ram_addr_t addr)
>>               } else if (xen_enabled()) {
>>                   abort();
>>               } else {
>> -                flags = MAP_FIXED;
>> -                flags |= block->flags & RAM_SHARED ?
>> -                         MAP_SHARED : MAP_PRIVATE;
>> -                flags |= block->flags & RAM_NORESERVE ? MAP_NORESERVE : 0;
>> -                prot = PROT_READ;
>> -                prot |= block->flags & RAM_READONLY ? 0 : PROT_WRITE;
>> -                if (block->fd >= 0) {
>> -                    area = mmap(vaddr, page_size, prot, flags, block->fd,
>> -                                offset + block->fd_offset);
>> -                } else {
>> -                    flags |= MAP_ANONYMOUS;
>> -                    area = mmap(vaddr, page_size, prot, flags, -1, 0);
>> -                }
>> -                if (area != vaddr) {
>> -                    error_report("Could not remap addr: "
>> -                                 RAM_ADDR_FMT "@" RAM_ADDR_FMT "",
>> -                                 page_size, addr);
>> -                    exit(1);
>> +                if (ram_block_discard_range(block, offset, page_size) != 0) {
>> +                    /*
>> +                     * Fall back to using mmap() only for anonymous mapping,
>> +                     * as if a backing file is associated we may not be able
>> +                     * to recover the memory in all cases.
>> +                     * So don't take the risk of using only mmap and fail now.
>> +                     */
>> +                    if (block->fd >= 0) {
>> +                        error_report("Memory poison recovery failure addr: "
>> +                                     RAM_ADDR_FMT "@" RAM_ADDR_FMT "",
>> +                                     page_size, addr);
> 
> See my error message proposal as reply to v4 patch #1: we should similarly
> just print rb->idstr, offset and page_size like 
> ram_block_discard_range() does.
> 
> ram_addr_t is weird and not helpful for users.
> 
> 
> To have a single error
> 
> if (ram_block_discard_range(block, offset, page_size) != 0) {
>      /* ...
>      if (block->fd >= 0 || qemu_ram_remap_mmap(block, offset, page_size)) {
>          error_report() ... // use proposal from my reply to v4 patch #1
>          exit(1);
>      }
> }
> 

Done.



