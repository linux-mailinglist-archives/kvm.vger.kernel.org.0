Return-Path: <kvm+bounces-40973-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 06DE4A5FEAF
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 18:56:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 30A5A17C401
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 17:56:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18A481E9907;
	Thu, 13 Mar 2025 17:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WEwTiJqf";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="U5eod9Rr"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A92615DBC1
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 17:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741888591; cv=fail; b=BM2MnR9rzSQzDGTbpWfmjnWHdJRXL6hIzUKO6bRj19xJCDtubCRNvLSFOobRQ+AMSrbjJmH5uB1f2Xo/qlb+OKka5OO8Pc7wIJVXh1R79qCUtFToYQSyrNLvLeAebDz2p+SWcrH7Nh4O7ENR1MV3G5QffO1b4nNzQY3bBBRv6e0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741888591; c=relaxed/simple;
	bh=lOUqusUz9ATW2vgGzRRV+gNPWm6hpNbrW5wSgaMa9NU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=dymEplwgHtgjtB27TQyPlBkE6zE7KiIwMpjbVKWaoMeP5ZkqJjUz7nkYN/g86jTTcIEAp/yk5htIbIKX93BnrFe50LEF0odY/psdoFD8xxWdBkLZ/ehH6HcBk3PJOhV85Dw44BzdaEv64OHQy5aNxY64V50xPKtAzDEEBXVCHkU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WEwTiJqf; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=U5eod9Rr; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52DHXgVX000328;
	Thu, 13 Mar 2025 17:56:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=dg6BJHMS6bNPAQJjOjxeqdPTPAFx8fi7/k4B9FvwGhg=; b=
	WEwTiJqf6zecWErPMamESZ/E+cMmHgiVC+RrEcGYN7A76H6yW6V5/K5PRYanb0Xp
	ynYtzPeqJ0wAVnOv3UL87Nia+gTke7uLQ05nnSbX6shqCw4HkKLPi+HSGBa3UwfB
	CSKnjogSjybI0a0IlJ83BpZCvlYxfzS7YOoNjuuco7NL09xbG9GMV3raUlLKkCzn
	96q9ByyaQEt1WlrTx03EI+De3j1jphJr0RRF8V1GrTfpJTJeBABHDKm1KuMEhnb7
	rs2UkFYdvU+9HEpu17qIuyOgfOtLr85Eu+v2FcbOV7lPvp7uIYQX7svvLkato5vG
	621WJQKswKs0v/ihFE7FWQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45au4hcu3b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Mar 2025 17:56:10 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52DGxxLa003895;
	Thu, 13 Mar 2025 17:56:09 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45atn2fmpb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Mar 2025 17:56:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VQQEPFeymOLni7ydotIb4AloIprGfKVr7pDZo6G4UdB338Gui+rDVCB/CbzzKHjBsk62aXeYAiyctqZ7nMNWHmzf+tkgG/Nqy9tpCRZXBx9nPmsHTDtlQPXJOFD5uwRThrPPzzd8xDS/IWZPwopJ6btxWvmF8Uue/ZkLzylehAvqQKwSeed0wQpkg0o7gEUM8UAcZWotvm7w/Xvyaxox4OEvIno/0+BfzryEr/lcUOygqfwwF29zlYvKb1QUGzIxWm3viDQcmWqQTEiuYCpm/sAzoBUKHyMoQ4JEWTQTidEgTyMQYlSDcnqrxeIClPiwAZMZbXAXjTyaF7TLxhgGRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dg6BJHMS6bNPAQJjOjxeqdPTPAFx8fi7/k4B9FvwGhg=;
 b=y2OITib880e2RKz6I7r+uzKTnwsa/uhDz37ujdZDQl3enzC1F3O+VI30w5lLaBxyejBsOXHZt5ZU+8xeyg+mTKaSFIAuoA/Oxd1Em1OUd0CQXeknNZ4StTKcbG6Q3AliERDCUfzReuvjhtcpbCpvoM0cJVS4L0wCDhyT5Nt/XRaAj+yaPhc2zlDbp4GdfH8aVI+GTyY7OMbOzKloQ0CVXGN0bvFG6WvCl5sThbDMHlw7zsCuQa2C8sD7DHS9DJVKi+RIHuKu8kJYU1ITJqdFVhcC6ekE2Xo+uN8fKQtAsStJobLejFlWB8k6hYoJLu8T2q2gzCBu8skdavWNZR2sRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dg6BJHMS6bNPAQJjOjxeqdPTPAFx8fi7/k4B9FvwGhg=;
 b=U5eod9Rr0MIlv/mSH5waAu0aa0Z/ln5s6abSaVRZlHiRNf0ZRgwVDHMxR7RqfFB3HBFUcYKmpiSi1NEhbjgBY91oW3AoY4tL85MN6TqlZavC/0JWHXWXSWLgEYl/rxWfPPju1YP1hwKWUlvw3aRGmorgjtUIjUio7sbnpVwqBMo=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH3PR10MB6785.namprd10.prod.outlook.com (2603:10b6:610:141::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.30; Thu, 13 Mar
 2025 17:56:06 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%4]) with mapi id 15.20.8511.026; Thu, 13 Mar 2025
 17:56:06 +0000
Message-ID: <f8c0fed5-01c9-4e2f-8be7-6b36712be1a3@oracle.com>
Date: Thu, 13 Mar 2025 12:56:04 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 10/11] nvmet: Add addr fam and trtype for mdev pci
 driver
To: Christoph Hellwig <hch@lst.de>
Cc: chaitanyak@nvidia.com, kbusch@kernel.org, sagi@grimberg.me,
        joao.m.martins@oracle.com, linux-nvme@lists.infradead.org,
        kvm@vger.kernel.org, kwankhede@nvidia.com, alex.williamson@redhat.com,
        mlevitsk@redhat.com
References: <20250313052222.178524-1-michael.christie@oracle.com>
 <20250313052222.178524-11-michael.christie@oracle.com>
 <20250313064236.GE9967@lst.de>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20250313064236.GE9967@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH5P221CA0014.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:610:1f2::7) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH3PR10MB6785:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e2e8251-ff7e-4c84-08b2-08dd625853d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?N2lqU1BRbnU3V2kzS0NTbEZNajZZTk84Q2Z2bHB2Vkc1UDh1NXBWRGRZTlMx?=
 =?utf-8?B?Uy95SnZRbDNGNHVWZm0rbVZFR0E0bHh1bFZlRk5ndzBCTEwvZHk4bzVCRThD?=
 =?utf-8?B?OGtqdXpzWkVyMTlmOHUzbEtGMjlVMldCdTVFUXRYMkt1U0t0TU13OEVqVDQr?=
 =?utf-8?B?ejVxSHdVMXFMTG9TY0U0MTB6TlJIUUhnbGwxUVc5dWxqaFE3RTFJaEZiMG5u?=
 =?utf-8?B?NEpIRTh0S2RYcWpyUHhGK1IzeGI4a2NLbWp5WlZiakRLelcyKy8rSXhCdHM5?=
 =?utf-8?B?d3RpaWRDR1ZsRDdZT0M3ZkROS244MWFZcndzeUdGMWNRR0ZqWnBYSHNlRUwv?=
 =?utf-8?B?eEhvM0lieExRblRsVGRQTGxMc3QzNlpsTFNIOGFaeXBobFc4SjBVTzd6UlpT?=
 =?utf-8?B?VE9xUGRLTjZEWmtFbVNPYnJ6WXYxaGI4Ui8yQVdUTlprSlkyRHRwY3pJdjI4?=
 =?utf-8?B?dUJhdTgrcUkrS3BnaTFsSkk1ZTQyYWhveFBCVzVTTzRrbldEbksyRHRMaUhK?=
 =?utf-8?B?VWxaYUFva05oQTFDQ3ZaOURhQXZjV1IwbG5KakpBVm1sVWp2cDRxUDhEcVRG?=
 =?utf-8?B?TkhUYTM1b21pbTNhRkRLbFZPakFhWlA0MnZrdEw1UExLdUhaM21XTU5RTnhH?=
 =?utf-8?B?ZjJ6QWZjRjQwOVVpeC9XUVRERkxxb2xRZ01KNDE3Q0YwdVNSUTdmZFlWbyty?=
 =?utf-8?B?WVpKOUxYamlPZFhNODU2dU9sd2hQN3lRWUJQdnFjVmRTRzZwSHRHcnpZL0dy?=
 =?utf-8?B?YU52Y0d2RXI2aXgvVWVNVzBOT2JYemh5NGF2S3BiMnBxRkVUOURraEQ1ZjZl?=
 =?utf-8?B?K0lWQ3gyNGd3VnVCeXJaWFdZMVlIanhVcGpDTjAvU2xXY2lXelVMS0NDZ1Ni?=
 =?utf-8?B?UEVDOFZZdkIrSWMwcVJWaitoWThqcUFJYU9sNTRvS1JXMDhDZVg1ZGRiakJM?=
 =?utf-8?B?RXZOeXFjSlp2UXlPamJNejhkNkQ0Q2wwWThRRlhGOWU2eGx1SUZkRTlWbGRQ?=
 =?utf-8?B?S1NxRU5PYUt4NlBMK2RFTzdRejg1dklsa1N4RnZqOUR5dDNMVEZySDBwMjkr?=
 =?utf-8?B?Zjg0RCtvOFh1U0JOZFhKOEJHRXZxeWpRVGRvbGNLY1VXbHdoRFY4bkx4bno5?=
 =?utf-8?B?RVQ0RS9UdDlQZ1ZHMUU2U00zOG41d25qM3lUU0Nsdy9SU1JTSnNnZElWanhT?=
 =?utf-8?B?Q3NNZVZrbEx0dDV1MCthQ1c4YU1FV0JCeTZ0KzFTeU5ORGt4aCtWRTJSaFM0?=
 =?utf-8?B?Y0pLOFRwamsvUGlkRk10TWhVc3FvZWpVdHZvaytGOWxaaEpGaGs3eVUraWRD?=
 =?utf-8?B?VDliTGd0T1JUemh2eE9MbUlwWmdlUEJkTGx0Sk0rNUE3NXN1VFB1bTVKTE9V?=
 =?utf-8?B?YmdPREMxd1BVMHBsQnJHZWVuNXhvRnFFZ01qMjZrU1BDallWY1VVRnlBbTF1?=
 =?utf-8?B?TmZYcWh5dnlzTVJYWkJiRVlUNzhyWVZFbkdKd0JtY2NHVU42U0h2WXhFU0kv?=
 =?utf-8?B?K3RsRGF0RktYTU54ZjAwSWRLNmMrYmpSUHF2WHlqWGcrOFZFb3R0VGhiSHRy?=
 =?utf-8?B?SnZXM09tMUttS3pmS2Q5RWl2eWRMSlMvMWl2RTJOd1pvcExpZmVqbWtNWjhQ?=
 =?utf-8?B?SW53U2lHTTNEQjlOZURPTE1QelA1TmVoQUhTRnlwdXZFQzg3UkdkM1RyeW83?=
 =?utf-8?B?dlNJcFU5cGVsaHBTT2owWGxnRGhtUGVVZ0ZBeGdTaW5zZDlWVGZwd3gxUGla?=
 =?utf-8?B?d3NzZ0YvcnlpM3hPczNnOUxjUk0xRTIxaExYb3pmRXRGaDU5OVplYytEdjZJ?=
 =?utf-8?B?ak51YW5abzRQMU9JMndrNW1xcVBPb3dUNDVIU1B1V1EvZEFmZTNJRk0zUnJ4?=
 =?utf-8?Q?RoO/bO9zcXfA+?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dlFvVDgvKy9mbmRpNXpTbnUwVnAwbkx4SjZ2T0hsQlo2RllBb1Z2WHYwaWhO?=
 =?utf-8?B?dldOdlBMNFpwNU5rdmRvVG9UZGdLYks3MTNQUGEzeEZIWGtMRVh4VzM3T2tw?=
 =?utf-8?B?QWdWQmpJNTFhUVkvWFJ5OGxlUFVhbHZRWk9ueGx0RC9IVnl5T053ajA5WGVC?=
 =?utf-8?B?S0g3NUV4L204MjJkR2hROGdoVDNnV0lUcmQ4UHZtUWRPdU83MkZDaHJoUHh4?=
 =?utf-8?B?cWtyZlNuYUR5NU9OanAwcDlHWitiOU14ZUhva1dHRlROS0ozZmpKNGgxRHNj?=
 =?utf-8?B?cW1oa2pITWtoWkFyT210MEVHbGRPS3NnOWhvdzVvQjd6dFJ3a1lIMlQwOGJE?=
 =?utf-8?B?djlnNVArekZUQUVxWmx1Y09WOVI4U3lpR0drK2VoNVJMSEcwQ3JkeVczYkxp?=
 =?utf-8?B?YWtvTCtkTHQrVkFmSjh4NVRVU1JoQ3RTNXgxUDVjNFNjL0V2TVB0QzdkQUZS?=
 =?utf-8?B?bFNIdVlxTGdLMFZETzZRdnlDOXVMVUZkM2RkeU9GdFdFT1N6R2kvQlc5UlRK?=
 =?utf-8?B?Z0NBM24vWXl1WGUyUVdjaEhTNjNJbENLUWI2WHBEVHdsK2p0dDIrT09hZW83?=
 =?utf-8?B?elBadlFPZ25Yd0cyT3VsZGRHM1NIMG90OExXQ0NIcFlRTHFUbjhmdDFvVUxx?=
 =?utf-8?B?cTRpQmFVYndPZkExZEhUWktHVXhtMHlKL3BOUFgvWjBQSmtOclZHMEd3czR2?=
 =?utf-8?B?SlBZcU8zQlVySWNWa0NNNkszN2ZVS2xGbktLUVl1ZEdRL2p6RHMwdTI1QWhv?=
 =?utf-8?B?T1JlaVd2UEVJZ3pUaUZOTGplbWtBSFFrWmVsRTc2eXN3L0dtdGdaYThSWURH?=
 =?utf-8?B?VndvaHlSMEowWEZQdXUzUG1ZdGpMZ3Y0d092R1F1aEN1dWZsUXpMZVpDRkw5?=
 =?utf-8?B?b1pITm51dHNCVHdjeWEyNHdBd2hIMUhnVVRZWWFxRG5vbEtkYlFYbStxVzJS?=
 =?utf-8?B?U2RPZVM4V0xhWU9ld0RnbE9JNzc5REUyWHJrUXg5RlZuN2c5cDlBOXdRb00w?=
 =?utf-8?B?R0lJRldLTENXT3RWeFhYT09DTlFDZVdTdUZoWUxEZ1pNVGloS2tWNkl5UlhZ?=
 =?utf-8?B?dWN1ZmlTdm9Uc3NRUWVTdmkxbkVicjJUajd0UHovZHkzOTNCNHVDYjJkRWpS?=
 =?utf-8?B?S1JDWk5JMHJqQVJkT00xQ3lCV1l5Y2tuSVlIU0RPczRqMEVycWc1WW9sa0Vl?=
 =?utf-8?B?dkR2TjdsT2w3d1V3eWZteGtHallNbkNkSGluREg4ZXN4TEdEeVpnWk9vamRl?=
 =?utf-8?B?QWlqNHM3RmZpTGVud1UzWVNBbkN4d0VJUkpwTjFHQ0xLcnFCS0VmOTdHYzda?=
 =?utf-8?B?eTI2WHpBRnhVSERDRHlMOWJMYXUyRERLZmxNVlIycWZIZ05KaU1yNTdOdHJo?=
 =?utf-8?B?S2NyeG9VTDhNcnhpc2xvOW9SZHlFL0J6WGNLS1VsZGJqZk1VYVlzWTBUcGQ3?=
 =?utf-8?B?VzlIM2N6d1l5NEhRZzFDVWQwM3BFWG9xV0htd3RqaDNGYVhZUzAxY2VxZEZB?=
 =?utf-8?B?YmljU0pUeGl1aFlWMGpxMGQydTZ3ZVNlMFYyZVpCdDZXQk9LNjE5SjhDNDFh?=
 =?utf-8?B?N3JwckRiVXNkeE9mUzVpamk0ei9xT0M4d04yVHhiUU9Lcy9qOTlHS2IzZ2Z1?=
 =?utf-8?B?VlZLVEcxSFFOdGVaa1UwR1NsYVZkWG45c1FhcUF4NnhzTzlGeGp1OCt5b3ZR?=
 =?utf-8?B?aVAzc0wreDRWMXhEeXVJWCtxRkxqQlBZTzBhSithd00rSnliMjZVSlNrb1Yz?=
 =?utf-8?B?aXdTMXdoNHAvQ05HcmtLeU9HcmNSbnB5cTJpWGYvRGtnRnRIcTlwV2ZJT2lZ?=
 =?utf-8?B?NUp3SkpiYWl2eXdFcU5JNUJTU0xDRHd1U05TdU8yY3docDhFK216TUJ6b0dJ?=
 =?utf-8?B?ejViS1cvUk9NZUdsRFdacFdyZlpVajlJdCtOWUhnT3JPV1Zld1hRaXJOZ3hM?=
 =?utf-8?B?M3ltR2ttUWJlWHlMdXVHcGlRSVJ1U1paa3hlaFJuV0ZUZ2tQY2ZNcW5rWGd1?=
 =?utf-8?B?d1JPTlZQeVZZZThmaHZ6YXI4aXEyQnJOU3BYMWhFeWxQVzJraEt3TW80Snpv?=
 =?utf-8?B?YUtRM0s4SlgzSUZZVnNJcXplRTg4cHYyZE5Ia0Zkd2NuUVoxeTQ4b241VUZw?=
 =?utf-8?B?KzAvUnlXSVhKNXhzcDdscjRSc2ZsWFAwVU1NdVNlZHd4WW5yRE9jWlFCcnp1?=
 =?utf-8?B?YlE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Z2/40ORi4IeMTInjhQN0vvxLdxwB5AB8+pM0eN5MnIzZDjIHPx6lfP4Brm0V42p8NY1AxzQdUd6/yJm8hjN25CI0sXQwXgLjCi1zmd8UPy+thtv4CQLGtrJG+QGWH+CR8KkM1EE/6W+aXY4M4bsuU1NWuzF2VryZoZ8cDE9NETSTvbo4IF5CK9EtYiSiqoXZHbwoPbgZ+ywiSLRb1RNBxkeRGxMKikA5qvUpbWzJ2+giWk/2AzaPze0Pi9iOXsMndaEor+m/NT9UFCGq1s2MJH/bMgkkjTxf9sZVlAoBx4xi9NNO8q1paNH0GXioXXD9fRoCBjzA8iYpXnt15NydGyggl09jNGJ3keBdXVk0wKQZjj3wEd4KPySinYNKiu9r5p+w8xUTXjzmk2dCuRmsqyvK4vX/cC2kA28BtdxxIW2pg1DHagMkueV1aNJb3EzgR6ZrAJ8sHDUhhHzjZA2XJ6cJw0M4XNSLaSwbek2b/J7LlHXGwnfypiz6ql0MFdg0FHwUMLxgT2/jiR6D6DMhQSEVClZBjjhzb3X+Jmt4KXnR7uF0ERI51EI+baH/+PCj3bFb5CsSBFzpR0D7PbUPgUbCyF7LpMFefL5pOvHFtZk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e2e8251-ff7e-4c84-08b2-08dd625853d7
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2025 17:56:06.1654
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P0zxgmJOLKKxn4jjHEQ51Kqs6iIU/QCJoMOkhL7SCKqoeTUowLGhXIIW5si+qKKjUGAigxu7POnN79ayNuD/dyScX3de0Fx3XLpQCEX4Ejc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6785
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-13_08,2025-03-13_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 mlxlogscore=850 bulkscore=0 malwarescore=0 adultscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502280000 definitions=main-2503130137
X-Proofpoint-GUID: qWkp-VeIxLBIyADn4otxGGhSYn7txAKr
X-Proofpoint-ORIG-GUID: qWkp-VeIxLBIyADn4otxGGhSYn7txAKr

On 3/13/25 1:42 AM, Christoph Hellwig wrote:
> On Thu, Mar 13, 2025 at 12:18:11AM -0500, Mike Christie wrote:
>> This allocates 253 for mdev pci since it might not fit into any
>> existing value (not sure how to co-exist with pci-epf).
>>
>> One of the reasons this patchset is a RFC is because I was not sure
>> if allocating a new number for this was the best. Another approach
>> is that I could break up pci-epf into a:
>>
>> 1. PCI component - Common PCI and NVMe PCI code.
>> 2. Interface/bus component - Callouts so pci-epf can use the
>> pci_epf_driver/pci_epf_ops and mdev-pci can use mdev and vfio
>> callouts.
>> 3. Memory management component - Callouts for using DMA for pci-epf
>> vs vfio related memory for mdev-pci.
>>
>> On one hand, by creating a core nvmet pci driver then have subdrivers
>> we could share NVMF_ADDR_FAMILY_PCI and NVMF_TRTYPE_PCI. However,
>> it will get messy. There is some PCI code we could share for 1
>> but 2 and 3 will make sharing difficult becuse of how different the
>> drivers work (mdev-vfio vs pci-epf layers).
> 
> I think we'll need to discuss this more based on concrete code proposals
> once we go along, but here's my handwavy 2cents for now:
> 
>   - in addition to the pure software endpoint and mdev I also expect
>     hardardware offloaded PCIe endpoints to show up really soon, so
>     we'll have more than just the two
>   - having common code for different PCIe tagets where applicable is
>     thus a good idea, but I'd expect it to be a set of library
>     functions or conditionals in the core code, not a new layer
>     with indirect calls

A lib based approach will be easier. I'll take a stab at it on the next
posting.

>   - I had quite a lot of discussions with Damien about the trtype and
>     related bits.  I suspect by the time we get to having multiple
>     PCIe endpoints we just need to split the configfs interface naming
>     from the on-wire fabrics trtrype enum to not need trtype assignments.



