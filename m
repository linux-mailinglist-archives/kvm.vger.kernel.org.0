Return-Path: <kvm+bounces-40970-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CFCD2A5FD91
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 18:20:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 444413BE9FA
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 17:19:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0070D154C04;
	Thu, 13 Mar 2025 17:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mtUKUOJu";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="cbabJgmv"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB160125B9
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 17:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741886395; cv=fail; b=CPT0u+No+ZmgWzA8/gOy3/Gi3c7PVMcuFe2iTNTZjwoiZ22T+/2HNfMRCccQROB9hTpAkOlRGuEUJb16al67DIeLqB2R0qqW289S/EIRFIdbDWhJLIcFppjEgroBJVObnVJI3+Uqf3+ItlIsWZCjHRHjN/B/VwxthRSEvbx40/8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741886395; c=relaxed/simple;
	bh=HBWJ3RyuMrcnL+Pg/d5xV1wk6lUuydORqbHNX2kzlZQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=s+u7VTTHTs1XguG92lkjIgaLRk3TBAhD1zYutBzvAEdoTP0Sn3HtLvmKDAu5XozA3wWf4U+h1Db9EVnvQAdjjSB8bsRoLEKr1NceA9bx7QWkUOlOv8WFqKIMApoY+mO5OUOqPKe/D2isMbOmQapBQ9P2WBPamhlQTOaLj/H+gtY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mtUKUOJu; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=cbabJgmv; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52DGu2vw020933;
	Thu, 13 Mar 2025 17:19:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=12btlA3sYBFqO3xjPMWmuxoeCXdwrZgN+37pQU4ZGz0=; b=
	mtUKUOJuZ+VmIkAw1va0470XLrk8fpbzLeIyRLPuA8+wH3q1Sxngsrin8Me/RfNV
	ItHpzAPnENmymJ5XBVJRl9EtCmi0u1LB5yhkmLoaOpBiQJ6KKduu2Cxm6gZhTBW7
	ycD8NlcZa9sjmN732olIoXrvEuj5r6+2mjod7bzWoV3zzfy3lMdTpujeJCjXf9SQ
	r7dmZI9H9cILGFKEMUKhNJGNMmVa9zqxl2/RMPO97OohsM8FvlHnyaCPXmDAmJlG
	+/hvFIbl8E/+KjA3qc9mVg6B3Haj6haa00Rk/cpfuGFbNsj5NjSyMH4FeIfMC1be
	zDhbU/v1nk555zdjcdEMVw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45au4dvqah-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Mar 2025 17:19:38 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52DGRqMZ019485;
	Thu, 13 Mar 2025 17:19:38 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2049.outbound.protection.outlook.com [104.47.51.49])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45atn26w2c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Mar 2025 17:19:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r346qInjC2joRs3qLrnXMIu03t81aYxPnHIucdElSv2/aZLy0lj2rp2C3mhW/ZQ/TyOa9TGOfRw0K6y7w+nyrUOKLsd/exH381B9OjPsLmG/1/WDpSc58+eRKEuqUYqTUu/NpDAhOPKbWrzDOU1ROUjCnxU+QMAl4/1EAhPsHWKn54JVR4P9K8/mUnchqt02QgSYFkxkdt1k3/N8OQ5JOpmkC8aGeusIrR+Ce0+iejZ289ZFHgKtqFZs4gijpA07ejE3lq6I8GG5xRByp+QLsYIZCNGEWzA3c7BM/IfuA8OGAeszCKcRde0DmrPGhXxMg4tUbx0O0i9PUVkMgQgr2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=12btlA3sYBFqO3xjPMWmuxoeCXdwrZgN+37pQU4ZGz0=;
 b=aF6YDjj6rGRFNfBD9bbaI7FN7K5T4Q9FPgkERO/c2xBPaOoQVd/CIH140k5gEVvnuQjesGXuWjIajq8rKX9xnqeYLrmhYhLb/sNZoFl2IXlhfweHKRN5Igr9ecFcm1AzqqBdvBQSOoljGL50zzKsIJ2OSqxZGlPJ1NZxpDpeW7G1/wpKiSuAbgD1/ObsCDAj6Ot67qc8SuT/FaqtJBZQ+R5cOIdVccNL/UucDNXT7VLm63gwnUSsLFACZFR7QRKXyAFLfFH+HpWQYb1hO8V9cm7czvjPAsOQJ7wWPx7xbdm3hKCy1GkC9mA0Zb8lKr+/CEuQRZ1vbntep8KOjOlh/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=12btlA3sYBFqO3xjPMWmuxoeCXdwrZgN+37pQU4ZGz0=;
 b=cbabJgmv0aseM4Gbz8F+y+lx5Jw9kV4POTMNRv1X4MCuG2lS2Xe/Cs5XqS6ISzJEhcWRY6yk/YdABLYpVfhFoB1n+nRlZEVAGNR7q3hnVttn39l3bkCkr7Art3rUtE3eZuDy8sKFLBKB/qJCK6nubH6wpkNr2f9o7Ads/J5FkzU=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by PH3PPF87283933B.namprd10.prod.outlook.com (2603:10b6:518:1::7b4) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.28; Thu, 13 Mar
 2025 17:19:35 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%4]) with mapi id 15.20.8511.026; Thu, 13 Mar 2025
 17:19:35 +0000
Message-ID: <b279de24-2f2c-42fe-81e0-4e53211efba5@oracle.com>
Date: Thu, 13 Mar 2025 12:19:33 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 03/11] nvmet: Add nvmet_fabrics_ops flag to indicate
 SGLs not supported
To: Damien Le Moal <dlemoal@kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: chaitanyak@nvidia.com, kbusch@kernel.org, sagi@grimberg.me,
        joao.m.martins@oracle.com, linux-nvme@lists.infradead.org,
        kvm@vger.kernel.org, kwankhede@nvidia.com, alex.williamson@redhat.com,
        mlevitsk@redhat.com
References: <20250313052222.178524-1-michael.christie@oracle.com>
 <20250313052222.178524-4-michael.christie@oracle.com>
 <970e0d79-f338-4803-92c4-255156a8257e@kernel.org>
 <20250313091349.GA18939@lst.de>
 <574a8296-1bc5-403f-89fb-fd4cedb57c0f@kernel.org>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <574a8296-1bc5-403f-89fb-fd4cedb57c0f@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR02CA0104.namprd02.prod.outlook.com
 (2603:10b6:5:1f4::45) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|PH3PPF87283933B:EE_
X-MS-Office365-Filtering-Correlation-Id: ea56e4e9-25bc-47bd-8a62-08dd62533a1e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NkIvNTNGblE4VExub04zbFJkZ3ZpVnpRKytJUlBxT2hNT0hSYUQ4TklIQVJC?=
 =?utf-8?B?TUZnd0ZzNkM3UGZpanRONC84VitpRXhoYUx5Qmpad3o2QUR1SndXaXlVdHEr?=
 =?utf-8?B?TFY2R2xzemxzeWxYTkhKL2lDRXJSYVAvbVFKbUdlYjdabWhaTE5CaVE4d3VY?=
 =?utf-8?B?aGZ6WlN3NkVJMFY0VU4zTFE3aVF2K0lLM3M0WER3cFRGSGRNcTJKbmlka05N?=
 =?utf-8?B?eUlDZUV6bGJ5ajhHemZOMlNlMlBrdG9tR3BRdEVVQy85NzlzaGlLSkNpWmNN?=
 =?utf-8?B?V0xkVzliV0lBNnpheXhDZG13WThSbnpwRjNEenJWbnUzaWkvRFhPL0QrVTZT?=
 =?utf-8?B?d3hLV09oWDl0SUZtYUlwcEVQdDBWUi81RnBpaEpkZlB5aGE4OU1jNHVSYXRC?=
 =?utf-8?B?cGlDMVJydFBQdDlBKzZMWlV6U0JuNVBPa2N3SDlBeFA1VlBnT2tiL1gxTmZz?=
 =?utf-8?B?ZWpkZklKczg5Y1IrZFl2VExTZWs1R05DcTBaQ0sxQXUyREZ0bStoL1lITjJH?=
 =?utf-8?B?aEZsVGNwWFFhTG1BYTluQjFMazhKUE5saUZKYVVFc2VCem96bm9lalpKbDlh?=
 =?utf-8?B?NzZrK1pHdUNMZUlQYXJicXJWT2loWHV6SFNBSmQ0ZklaRmh4VDc3azEzOFg0?=
 =?utf-8?B?eVUzUDJTWnhPOGZ6Y056STA3UU5NbnkrZlpvaVF3S1oyOEUxRmtRbzhydTM3?=
 =?utf-8?B?QW5YWVB5YmtmUTFmVHdGRnBLRkpuTXNHeGJnMThuNC9XMDJOaW4xTllRd2hk?=
 =?utf-8?B?VnlBR1dyZ0doSlR0ZWdlaW5wZkdBWjN4UklpbVpkU085UzU3QU9VNlQvaUtx?=
 =?utf-8?B?b2llR1NhdzJ2NkFFd0FHTWFyR29jamcxY1dWL2IzSFo1T1N5T3ZxUXArTlph?=
 =?utf-8?B?c1YzdUJUcUZmL2FHZTRHbU1mMUZUL1hhWXRlSDNCMUJyVUsxY05yV2NWRXJL?=
 =?utf-8?B?dDR0Z0ZiZGJzVXUyWENWRHJ3VnhRbklxWmJxblpLaVRCZEViNnJTTVJZZWtx?=
 =?utf-8?B?Y2ZyV1ZGZ1NZK3prQktldm1sQ2sraFE5bGtuOHRPTjFpSzE4Y2hqa1lMb1dz?=
 =?utf-8?B?VkJZMHRna1BoT05FRXZYbzBsTzZOMTBlc3pocHhzYTluMzJuUEhFYXJOQVVQ?=
 =?utf-8?B?SDZlMUVvSi8yYlRWMlVMV2ppS2h4cC9ESmRsbTAzVXFwZXo0SkFFdmI2STgx?=
 =?utf-8?B?S1o2VmpEclFSR2Y3VVc4dHU1cDd5dFA4N2pZMENRQ3hEMGhpN2FjV01tSUM4?=
 =?utf-8?B?TmkxN2NkMDk5ZEsyTTJ2Rk45dHpLVGQrMnZsZS92cWFKeHdJSGY2L0pvWUVk?=
 =?utf-8?B?N09EaWtGVEtSN0NnUDlQKzZtOURHRUk5NWxMVE03dmVXandOWW9jS3dZUzF6?=
 =?utf-8?B?SSttdGhXaXdHOWRUTEIwSzY1SElWdVNqcE9Jcm9kRjFVT2F3ME5kZ0NQMzNI?=
 =?utf-8?B?R1g1dWNtOTg1T01tdjlRU01DSG56ajh5SG45QVZteW9WdXN5YmZEZGphTHRv?=
 =?utf-8?B?dTUzQ1Jwb1kxLzg2STRnZGJCcXhhb2pnd3MrczBvZ0FmYWJzSUhMZkM4c25G?=
 =?utf-8?B?eWk0MEViN2lDRWxtS2tJSkZvUVJyQ0xGWXovdTUxS3RjK1RlbUdSaEM1U0No?=
 =?utf-8?B?NHZFb1prVXRJKzdWaE8wYW81amJST1BwbUJmdG80cDRNM2FmNmlWMGZYM243?=
 =?utf-8?B?b3JQMHRIU20wRWFKK0piWnUrYzFBcDI3M2RpTE8yejcySzM5WkJGSmVzb2da?=
 =?utf-8?B?UHFqN0JEeDZrbXVRNVprd3ZLbUp1Um05ZVJIM2JMRFhRdVVOOG1VZC9uVVk4?=
 =?utf-8?B?NVl6SHVSMnlpSUd6S2ExZDFtQlhweUM1SWtLcytnVWpMRWlqc1cyUkhjNnJX?=
 =?utf-8?Q?Vt1mLYT3l5Sla?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?MzZUaE15V1AzMEpRSGxmNlNkVG9OckNkVy90SjZZd2NJbkFwRFdxM3NmNTl6?=
 =?utf-8?B?QnlyY3BKZ0dMb1VkSlYxSENJZ3dSc2lEaHFXTzRRQzN1eFBZRkYxdTlGUUFR?=
 =?utf-8?B?WjJnNmhUT04vQUdJR3orM2JwTlQ3VmNhMmpGQlA1aHo0RVhmZDlweDVnRGpH?=
 =?utf-8?B?NGtrMmh6NVpHbCtFSUswaU1uVm5KSkpYcGpmbnNzTGc4N0VKMzR4Uy92NzBH?=
 =?utf-8?B?N2ZSNE9ESWVvU3dZSG5UUDdERUh3eGQ1WTN4UkNIM1dUZ3RCUitHRHlad1du?=
 =?utf-8?B?WndJcUh2Q09HOVFPaVo5VnBkQzFzWjBZcUM1c3RNRXJ5S1cwWFZ1L1NMYXdD?=
 =?utf-8?B?V21DOVZGMmdvR1hvVFlxL3dhREdVNE1tMzRCZmNZalY5SkV3NHNjc04zMEs3?=
 =?utf-8?B?Ukh0Mm1iQ2RxM3UzcWdRN3ZsVUZGZkx2ZnJtTGZYanZJTEMrZkNzSzYvb0hI?=
 =?utf-8?B?SHExcko3M0p5Q1BzNytRb2xRTUlHUVVMVCtaeE03clphdmhScjZwV1lobXJk?=
 =?utf-8?B?NkhDclh6S1dqVC8rOGFGNTBkWXgwWkRYNTkvZzZmd24yVVphYlJxRXJpUTNN?=
 =?utf-8?B?ZUg2azBYZlAreXI0TEx6Y29KbTZycnFBOWxKZk5Nc3dCSVUwK0xWdktLSjd2?=
 =?utf-8?B?S2xKOUhyMnY2djRXd0dkOEJMeTBqWElPYUwzTUtES3JEQitTOHZxc2ZwaEVQ?=
 =?utf-8?B?WTkvMEYraDVQRnQ5NDhhc2M3RkRZT0JkaGFPamVKUlNJaklEa3ZUWWROWUNG?=
 =?utf-8?B?N0o5VElkdEJUdU1xTnFXakZQSjYvY1NIOGk2VE85OGpEQVI5ang1Qlp0UHVB?=
 =?utf-8?B?YTBZekJPNXFtaHBKWGg3N3dkY0JVMjBDa25PZ3BoUmRSSDhkQjgzN0pmL3dy?=
 =?utf-8?B?TDg2b016eFBkSElVYkhKNmZNT1ZNcm9iSkpSQU1qL1gxY3FCU3VpZk51eTJN?=
 =?utf-8?B?d2dvcFNKTEc2VDBKdnZvYlpOS2lyRU9kV3FITDVES3JhM2FxMDc4amFoOEtk?=
 =?utf-8?B?NC9YVm1odXkzdUhuekFYQmFKYVdqK2dDWk5QbkdQRUdoYzYrV0pCdUJOZHR6?=
 =?utf-8?B?bzc3dGZER0RQOExIQ0JvMDBYOThlbGpEaG9XWklKcC9DT281K1ZtZ3FiWDlz?=
 =?utf-8?B?elFtcmJ5ZzVyeVJYYVZhdHhORzAwckpDdjBTVk9xRjlCRC9WVFFiZUpDNmdz?=
 =?utf-8?B?eGRQaHNUdTJwV0Z2YWdsZS8yYnVOYk1EY29yTlB5UWJTVVlJTmN6Vm9HNHVa?=
 =?utf-8?B?MUFYSkpxRUxUZzE4WDdiSTFnTERQM2pOK0VmQnRjMjZKVTlyNnV4U1lZWTNW?=
 =?utf-8?B?UjFza2dhWHFXdUQyc09QT3JpZEJFK2ZqV240d2lQNDFYQ3psL1VHRzRnUHZz?=
 =?utf-8?B?QXkrb1Q0MVFlcjZGSDBIY01DaFRWSHpaTENoNUxsWmhLbFhwS3dwdkRIUzIx?=
 =?utf-8?B?N3NMUGlzeXNKVGZIWS9nQnh6Um0rR3orZU5kMjVJWjUyS3A2VmM5RWp0K2JT?=
 =?utf-8?B?QW9helViaGZ3M091eU9VR0JnTndnSXJwbjg2VGdyY1Qrak00cHJrRGR6UnpH?=
 =?utf-8?B?cm82VDU5T3p2TDNJenZqeFAvSHVxOXE2Uk9EangrSk9JQm5UMlFmQS95S1Q0?=
 =?utf-8?B?ZEdYamFFSkVyWTJGOHVFZW9zbHB2eE5hSXZKOGRzQW53L3ZVWnRXcytOeVFo?=
 =?utf-8?B?R2Q4L1B4ekRxS2VzdDcrWVBjMkJVN2pzYnduRTNiaXBjUXk5Ty9jbkNNc3l3?=
 =?utf-8?B?aFJwMkhaTnAxVHdyTDRMU3RZenh1R1BQc1FpYlJidjRHUjVMNy8raGNMU1pB?=
 =?utf-8?B?UUhlSWQ1NlpncTZCbDFvY0UyZWhhdDRlRC80aVJteWFIKzhheHBOU0psdVdm?=
 =?utf-8?B?TVhVajNER3Q1WVBENEpEWE93TGJSZjBJS3RSaVNWZENVcVlRSitZV0JVZDNL?=
 =?utf-8?B?V2dJYTNXTzdBSU1Mb3VzbEtTem5tUGxUN3pRSmpDWmN5SnJGTHhVZS9UdEEv?=
 =?utf-8?B?b1dVdHZUQk1zZGxNSUVXZEtxc0tFQko0Q0RueHJvY1c5djczeGYya2FhYnJK?=
 =?utf-8?B?OUV2UU1rb2JkQkJvNmFhcklhV0thWkVaTGQ2L2hmZnhveGY3cHhOdWI3aVly?=
 =?utf-8?B?Q2NzVnVhSVNzUittS3huVFlqd3RRT1Y5TWtjaSt2b3dsSDhYQ0NIbzZBdlpw?=
 =?utf-8?B?K2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	EZP+bd4yNRWRLg8IOiJJ3OJ8KEtaM2TP5Es/vMD/xZnxf+x9BymF600ZUsKtPllYEPH/rU58jlNEXVafuLlGM1zzHxscqtqLVptIlr7jrh0sb9A2D9tDxea/HQS05yKwoX4IGVR4IE3J0ubG/DmAK/UkkqBLjnCfoMNo5pZAcSct6m/dQ3IYza85lLvAT3/vlhKZn+KCbBzZOpTjsj0NYwKAiBe1bfXIykuUrfxbceR4pe7jeWGmhiW9V5Hbj2RkHTcwgyrzuVkBzM1YJKt9yv8DQ0ezmv1yn5oplbgEpNmvd6ZLs07HfS3UMerMdI4HrdRK/bbIZnyVC6Gf28FmtzCMX6Qz749wpXYWn6C8hyuDazrN66xv+KUhM3/dyG73uR7IQ9gCtPtFxLAFbp4rg4X/Qfca1FJSiuA2XUycLr+isxe8E0en9oonMZcFJJGzqbV0iBALzBzzn4IeOrYYuxaW3agQCW7NwzUwYnyy08odmn8jLs4TXYqPfoAHR3AeQg99boYMOZNIRPpSTkcN2d/Qsoe6OUunfl6HUPN/3i5hKGgC2a78oL2aPALe2WzR7A75vqOoyPuXtS+7t5RssGaxCY7LbPUZQ1o0Q79rBFY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea56e4e9-25bc-47bd-8a62-08dd62533a1e
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2025 17:19:35.4831
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XYmTYCbIVty1Pv3hcqESWmp7wnorTgeOALSweSNPoqFTZK8ZZeOZ7r8/kp+ZJuEyjweM+R254F/y8y1dC4bbsk2tTQe4fspdttaIE7D2BwI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF87283933B
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-13_08,2025-03-11_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 adultscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502280000 definitions=main-2503130132
X-Proofpoint-GUID: 9X3_QFn1XIpfhazSzOY9WFr1UJss1P0a
X-Proofpoint-ORIG-GUID: 9X3_QFn1XIpfhazSzOY9WFr1UJss1P0a

On 3/13/25 4:16 AM, Damien Le Moal wrote:
> On 3/13/25 18:13, Christoph Hellwig wrote:
>> On Thu, Mar 13, 2025 at 06:02:29PM +0900, Damien Le Moal wrote:
>>> On 3/13/25 14:18, Mike Christie wrote:
>>>> The nvmet_mdev_pci driver does not initially support SGLs. In some
>>>> prelim testing I don't think there will be a perf gain (the virt related
>>>> interface may be the major bottleneck so I may not notice) so I wasn't
>>>> sure if they will be required/needed. This adds a nvmet_fabrics_ops flag
>>>> so we can tell nvmet core to tell the host we do not supports SGLS.
>>>
>>> That is a major spec violation as NVMe fabrics mandates SGL support.
>>
>> But this is a PCIe controller implementation, not fabrics.
> 
> Ah ! yes !
> 
>> Fabrics does not support PRPs and has very different SGLs from the
>> PCIe ones.  The fact that the spec conflates those in very confusing
>> ways is one of the big mistakes in the spec.
> 
> Yes, and despite tripping on this several times with pci-epf, I did it again :)
> 
> pci-epf has code for handling both PCI PRPs and SGL. We probably can make that
> common with mdev to facilitate SGL support.

Yes. We can. I have different patches depending how much you guys
wanted to integrate things. On the next submission I send them.

