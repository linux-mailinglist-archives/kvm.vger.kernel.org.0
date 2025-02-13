Return-Path: <kvm+bounces-38093-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A7906A34E84
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 20:35:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AF748188E14C
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 19:35:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA60B245B1C;
	Thu, 13 Feb 2025 19:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jKRhOACr";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="aUD2td4Y"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1731928A2CE
	for <kvm@vger.kernel.org>; Thu, 13 Feb 2025 19:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739475329; cv=fail; b=Vz9Qe+0j2HliGFwOV9LCQvOutmf8gXo8hwquilHN6ifdOmeCYEubNnWdT9zgulSdj+cMj7TESZuU0yX59ZvAfzkEfg/n4hcHmUMIIdwlXCu24JkPRSRfZZmjUj8+yPgfWR1zeTI4vMzZYfsaqwL9Ok7l5FLuVQbxhBTklWtTN20=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739475329; c=relaxed/simple;
	bh=9qfNCtUkJaqzuiMgMLd9eNDnWfXZwxqud7+5RBTu+wQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BbthMHWuIj/th+SippK8h1BgpS9AinvgbH3OCBq3wdlcfTe+mkzqBK/YLMDZJTfdqc0lOCuBydh7C6SHmraOIaW5M0fvAwvqemK5/8VzdPQxGJb1FXZLMKHcyt/SW+ScUu7NSdfWI42n3c3hVF/mB8SoVWtF4kjiN/4gJOkGsTc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jKRhOACr; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=aUD2td4Y; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51DGfYd3026117;
	Thu, 13 Feb 2025 19:35:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=3YyV4Tk0EChBP2m+k014cw0cQga19+8Hgt+KN6zt+EY=; b=
	jKRhOACrj3uJo5Ji/JKHbMQI7GX1bnrdliymwvOvc5t+3PMNgksqv68/P0WUHtgN
	fpsayCvnDcmtMLo6EunWoEDC4J6ZWZ3ksf2RW6XtQA3sJN+km0sGeKA+N9+eckIl
	UJmSgWUWYxMYwwbBygXqU5BRt6oQnMC+uN9TTx9lvRj9DiBnink5w4c5lJIpKn3n
	XSIkTsz/dtsOgPnjupU0HByrZ5SwqOz2qeQEBy5qUD1CdAydpO3IrksIol27Yy9N
	1YvX4NC0RWQmd5a84iyaRBiXvvy9DD9zxckuSmaDQ5MnZQN6J2/hdFKk1Lg6TNrx
	uMwC741EpE6cZkHShX4pMQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44p0qytdhc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Feb 2025 19:35:16 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51DIaRwG025151;
	Thu, 13 Feb 2025 19:35:15 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44nwqjr0rk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Feb 2025 19:35:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tDWb7rpSHPY6KDkZNVPDsEsBqmDOtgyetwOdkVlbeUB5HUuQVfJkuIn27bLwPJB/zJA1LiVrmKTLSDol4/wwbmv8ZlzfpDZpRPUjfdarrEAZMuKqL7HX0dZ8n2H9z88k97qHB5PnvmT+9P2QIo28H2NLTNnHsMk0C+Wtkrgmox6MDdTbWEPyHW8PUG8kzy2QhUdJUKqQfysDpUgGZmEmBJar+rovjfzfYvBUFJbP3cobo/6wvad5CTJkTMxfPYlFbRizOJ5ZtglhBq9weViCQTkSnQDxGDeMHN0QT9dyPgj00t+K1oE04TLvxkViqzxdY3V4aVdx9qCuX6i2zj4MRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3YyV4Tk0EChBP2m+k014cw0cQga19+8Hgt+KN6zt+EY=;
 b=aZgvZqB7FOmmtmpeZASNOMnzksHFtUyGWgT7jM1MGcH9oAkeKq1kzwmYgGgS4oyksr+dxhqVMLFtmRvyENcsBOcAAqy6stKdFsqSKFDw8KPCPxBcKjXqSxaigYz6t6xpYs9McbEqpwx4q+SOGwla7CLtwJQTKWI2/5Jkx/sXowzyDr0Amorc+N/V1v+8YjlCBY5KgRD9t70tVzkGGWNsFf24SwiG6dq7/FJlN+ooHLwqg+0SgjbLWBMdXNwet+iO9kULNseXFhQjFOazsFYJ8sKskVjfcMRvhqOqiiZs+Peh9SjUfrTEKAqSugJuL6aeDPelXOA/UDTe8jjW1y0Pbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3YyV4Tk0EChBP2m+k014cw0cQga19+8Hgt+KN6zt+EY=;
 b=aUD2td4YlwiNU7DjWKKU1sdRUgL1FyXXgTWgx3J/QA3WRO+iIhavGh9VEo8N0irUc8DEHTN+PFX+3mwuGuEeS9H05h069kj3+TojLPx/h1F7qHeEqGSwQCGsaHOAGT2jFpEDBmFDoheivVcbG27v0eXgjaRzDbxsYIIjENd5wsw=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CO1PR10MB4786.namprd10.prod.outlook.com (2603:10b6:303:6d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.16; Thu, 13 Feb
 2025 19:35:13 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%6]) with mapi id 15.20.8422.015; Thu, 13 Feb 2025
 19:35:13 +0000
Message-ID: <6e8aedfc-f270-4fa8-a1d3-df0389e505cb@oracle.com>
Date: Thu, 13 Feb 2025 20:35:09 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 0/3] Poisoned memory recovery on reboot
To: Peter Xu <peterx@redhat.com>, david@redhat.com
Cc: kvm@vger.kernel.org, qemu-devel@nongnu.org, qemu-arm@nongnu.org,
        pbonzini@redhat.com, richard.henderson@linaro.org, philmd@linaro.org,
        peter.maydell@linaro.org, joao.m.martins@oracle.com
References: <20250211212707.302391-1-william.roche@oracle.com>
 <Z6vQvr4dCCsBR2sX@x1.local>
Content-Language: en-US, fr
From: William Roche <william.roche@oracle.com>
In-Reply-To: <Z6vQvr4dCCsBR2sX@x1.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS4P189CA0043.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5dd::19) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CO1PR10MB4786:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c45693b-e4f7-4f8e-8178-08dd4c658932
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Ry9PWjVzNW1ZaVRYbGo5bkdPYis1R2tEQXRML3NrZzZoZUNRdDQyeFpRcWg2?=
 =?utf-8?B?RlViYStSWmEzdnZpRW1GQmt6K3k3OG83bmtJM3B0VFF6eGZNNVFQbmhKcW5t?=
 =?utf-8?B?UndBQjlBY1pFYWpvWXh6YnhPM3lPT1JjM0NzUWgrQyt0bW1VNmt3MHY1YVhm?=
 =?utf-8?B?b0ZlRGFUZnVqT0U3ZXJDRnVrMGZsanlBMEg2b0s3WUNKY2lTTWdVckxORG1k?=
 =?utf-8?B?TGZ0MkF1T0IzazM1b2RzMjdEVUZtRUFGb0VBMUVxenA2NVhVbkgreFVUYVBp?=
 =?utf-8?B?ZGhHVkRvZThNS2Q3TEJBWUkvSjlEaTQ4dmd6OGRDK1RxbGp6MktPRUwrcXpv?=
 =?utf-8?B?NTUrR0VldE0vdjV1a20vZnZhOWljRkZya0hkRnBBL2ljUWtVVllhMUM2byt0?=
 =?utf-8?B?UEhUandYZm8zeWZUdEkwN21rSkw2ZVArNVF0akh2R3IyT2x1L09WaDFaWkxE?=
 =?utf-8?B?c0NpZkVaR2kxSDNmckQ4WnlUYlB2RG84WFRmQ1JuUVdzS3M3ckNqK1F2NXlK?=
 =?utf-8?B?WXFVZEEva0ljeHBmbnRjQXdOLzNJSHZTSFI1a01DVzVCU3JMd0NFZzA4MGhp?=
 =?utf-8?B?bGtscXVWazZhYVlTWVBjYVl6VzJuWnNaZE5GdlE3alFmODdZSWN3bkx3OW5t?=
 =?utf-8?B?Z3lMVDJuZGlZWmx3RDY1ZzlEMFNsWHhub3A1WVphKzF4US9lK0tDQ0syakVY?=
 =?utf-8?B?WWdJRHpCdzJJb2VuYmg4bEtyRzZoc3I1TjUyYTJmcDBXRFNuM2ljbGtCZDE2?=
 =?utf-8?B?TUJPVXFlTVdGdHU0cUN6U1JwYXpYYVlNeHhRa3BNVEpmVGZacVJUTENMaTZO?=
 =?utf-8?B?VjVsckFwOWVmRmtTY1U4K0RGbDVxUlVDVHk1SEZDK0pMd0hZakRXNDgxd0JQ?=
 =?utf-8?B?L2gxak5GNGxWVjIzVWRPQk9hU0RDOWZtWUNsMVdZbStTYjAyby9VOXZIazlE?=
 =?utf-8?B?L0lNc25iRTBTU1VFb2h6cnluUGJrTEZmZVhNU2x0enc3akNsRHdaMU1JZXpu?=
 =?utf-8?B?bDF4SkduSDhvTlRjSlhBakx1dlJlUmVmOHA3V3VJSlE0dzQyTWV6ODQ5VVlJ?=
 =?utf-8?B?NFlHVC9laXVjRnVtdDNsWkVHQ2FyNUhWTGVpT3dmdHFsSTdLR0ZyRG5SWUZh?=
 =?utf-8?B?dWVUbU1wMWd1emxuMTlaNEp5aW9IbHAxWUNBYk1yeUw0Wm43cG5qVG40ZUFV?=
 =?utf-8?B?SmVmRnVOVndMSm9Vd0lqMlFrcWI0alc2SnZvZWpjbU1qRlFxNDRrTFhWTFo5?=
 =?utf-8?B?eGpHbWVMK2RSWWpPWUQ4U2orUmJ3NDdWVjI2eVF2cmF0bmM0WERic1diMWxW?=
 =?utf-8?B?NVlObklvelNsUHhKeFVtSmRSSEFDTll4dTlacDFNQU1qQTA4NDlybk9yK01Y?=
 =?utf-8?B?cC9SUE9mcXVtaDl2aVJaV3RxeGhKd25qcm5CMkczcnNSRnVzYTlkZ3BJTWVM?=
 =?utf-8?B?cVJ6STB5N2JITnl4anl4aUNHWUZQMm5LSTJsQ0krQ1VoRHZtWHBvOFZZSnJ3?=
 =?utf-8?B?bUVRMEJ2RnJpQ2d4dGtYOEdOOW12NGh4eGVtYUVWYXJPaW9hMjFyczFoS25j?=
 =?utf-8?B?bzg2YjY2L0k3VkpVMzRtTEYrUkovTjJoMFk2bm9wWnZvaHRaTjdSRXQwVU9o?=
 =?utf-8?B?YVprbmwveDU0RXl6T0NpcXFrVGJhWnBES2V1WmxpNkFQOWNDVERhMG9RSmsr?=
 =?utf-8?B?UEVxMlB6VDVoU0pSUnBnQkRtL25ydFZMbHVNNXdrUlZ5Tk95U2VyME5QS2x1?=
 =?utf-8?B?bkZLV2F2RG5HVk1xa2orbTVJWnZycEdMMzRsY3FRQ3RNc2oxT3c2QWl6L1lq?=
 =?utf-8?B?VExsZVNFdDgwNGRXT1VyY1dxeWw3Mm90SmRMSi9LM3pOV2dKL3hNaVZpdXNm?=
 =?utf-8?Q?x/bUGzaaJKZ/M?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eG5KZSsvRnZ0ajhvRGM0eGw2TVk1N3dKc2VGQUhpcXJDZFlxVDh4SE9pdlFs?=
 =?utf-8?B?U2tIMGc4WFg2UWJudW5xNmNOMkozamVXWE1zbUN5dXN1SHFCM3pCR2tNZWkz?=
 =?utf-8?B?OXJPZXIrTDdBcWl3dTN5aHdaNmp0cGdWVE9neFpPVEhzRVlCZ1dESmplMnNP?=
 =?utf-8?B?SldxV20wZDdZYWpUZUxDak1rSFVUN2IrK2M3dG9yRTZZQXJkZ0JUbEkzRkox?=
 =?utf-8?B?bDA5R0VtNEgxMUV1NmFSWlRHdEk2OCt3RklucFR6SmsxQ1k1Vi8rT0FUU1Zs?=
 =?utf-8?B?REJhMFpYeDJZdmFFOHFpMWdTQXg2RGdNak5jMHpxY21vNVc3NXBwRWdyMDds?=
 =?utf-8?B?TDdESG1naWRSYytMVk9lekw0dCtuV1lMNDl6OGl3dEtKYUlFdG1jSWI5ZHlH?=
 =?utf-8?B?RnJzTjVoUVBURksyS0RBMjZXZmxBK1R0KzFPS3J5aDA2cWRsSGFYaXR4T095?=
 =?utf-8?B?V0lpWkZPVVFVOWhxTWswdGJBSkNDYmU0SWhxMHJJa1NtbDMzS2NZVHBmRUhI?=
 =?utf-8?B?dXpUd2x1bTlsNVEyZ2p3MUhHWVlaZFBIdWQrdFNReGEzSUYwb2pjdkhnYXNZ?=
 =?utf-8?B?SVJIQ3VJTWFocm02VDhGZkFybENmb3I1ZzBEK0lsQnF1TC9ZRkFzZ3N3dHVX?=
 =?utf-8?B?QUMzYkhLZXdnL1FOdjBrWTd4b0kwT1BtTzZpb1dyZm9Bdko5YlNoUk5lZkZm?=
 =?utf-8?B?N2F1cFRPOW4zeGdiclJhM1dWdk5kd0Q3dWhHZEhueHkyR0h0VFNZTkhqeFdU?=
 =?utf-8?B?a3FPbzhPa01EbEkzRjV4SG1WMW1QejEyNW9oVGJGMjM2WTlIckRNTGFYMEtG?=
 =?utf-8?B?QXlPMTU3a01KTGtwbllSRHdPcG9IcWtmSXAxbTFzR2Jud0hTSisrRC9JdXZZ?=
 =?utf-8?B?S3lMSFFsVE9FZjA4c1cyVUcyNG1KT3JrWFhidHA3OFpkRjg2UEIzeE1jOVVm?=
 =?utf-8?B?NUJKNEtCNWxxZWVabUhKYVk4enVMWER0MjhRcTZ5NXhyZnh2MlZLejNPNVdK?=
 =?utf-8?B?RjRMckVZUlJQZ2N0a1h6NU5LbFhESGNGZlpvc1ZlNHo5RnlnbktUMnd0V3RK?=
 =?utf-8?B?YjVhRVRvckxNYTU2OEFPcTlDOURCVVdtN1pJVWhSY2JVc2Z0Mk9KM0puM3FD?=
 =?utf-8?B?L3oxWXRuYVV2bWJTVHFkREtQWS9vTlgxQWZRSkJtVjV2MXFUd0Q5R2Y5MkdI?=
 =?utf-8?B?L2VIQzBsZVBweEw2TTNNeUF4VFFwT0JkZEVSUFM0TTN1N24xTE9hVGRrYjdn?=
 =?utf-8?B?aC81bFBHcjRucGpJbmwwZXhjblFIU0VEMCtzelNZY21JU1RPVFJDOFhoQldK?=
 =?utf-8?B?SWhycmRMNFJLdWhoeWpSZ0pUZFowcGhxTlVTUTc2YXgwOFJtVGQzSkI3UGpK?=
 =?utf-8?B?Mmo5YkVsNFA5eVFqeU0zNWhXNDBpc3VEZjRFa2NiVnJIeGF4UHNEMXJ1SEJY?=
 =?utf-8?B?WGlpaGpEZkF4STBNRkJLRCtYVXlYK3JQbnhwUEowZE9tRFAxek11QlZOb0JS?=
 =?utf-8?B?UzVBVnVQd3NIUlA5NnpmdVR1L0NWNnhJTEUvcy96dVBTRmlaNjl3bXZlaENF?=
 =?utf-8?B?cTRRTXpidVV1KzdoL2VKUzNOQjJyNHkzVytkbktqOEpkQ0tqNGhZOE9HWkx3?=
 =?utf-8?B?ZGh5RkgrOEREeVErU2VyVStPcGZVM1JzTHR0aXR6Qmg4R24xKzZJTFdLMmdY?=
 =?utf-8?B?S1ZZZDV4SjVoWStsZDNNOWlTMkhJdGJ2RWlQcnc1d3RuOUJFZGEyL1FiWDhJ?=
 =?utf-8?B?aVQyYkczeU5PWGYrSE1IYUxsR0VKakdwYndQaGxpL0lERlhUbFJkVDdFcE5s?=
 =?utf-8?B?RExlL3k1RWE1QTd4Wm8rd00xemNYM3VZbGZoa0xGdjgrVFZ2ekluMHZQWi9F?=
 =?utf-8?B?RUxFWnpQQlVhbGo0WnFaZysrQU5UTHlxelZNSVNlQ3M5SVI0cDBZSnExOHB3?=
 =?utf-8?B?c3QwOTk5aEtBb2JpS2kzaUhESTYxRnVkZ2ZoQUZvZUV3ZTJZQ2NxRlFjMXU4?=
 =?utf-8?B?dGV1ZFRsNGxCZTFkYTZiTGNNYU11UHBtR3E3bU92ZXYxU1dtUDlOS0g4RlJ3?=
 =?utf-8?B?K21neW5CYWlpeGNwcGk5d0x5SnMyQ0xvakZwMEZ2N0w5V0xwbm04SDkwOURa?=
 =?utf-8?B?bmpKRG9vR21xMWVOS3p2SG80cDE0VElXQXFab3IydUJJWm0vVVIrR1lETUV3?=
 =?utf-8?B?WFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	JX6f+Z6MxjT/xBCXeCE2QgR5cpFvSXkitW44EHpwqC6sPtXl3H+83rgFaZtTbXwETItKiznveHV0IGzgV4PvXCptSYUtmK8GMd0IPpQz76WKRLiKBGoOadrWE/IRGP6wNzk1PRwIqQ7GxFXk6ADU+lfW6n/j9Juxy9drqaaTabUiNlMG9xC1rOlIpNOd9ymPQQLZJnI5mV/v8eNIYl9PV+nOQXGWX5m6WAJ+cje6L8r9snmG/73ok5DWDEH13idBisvWUPG7jaSp1+kGx3vvxwyLzUjoxaq0mTWt6Y4y62lTxl/w9b7rCvV1yA27L/bE22vqy2TqOa3//tC7l/bheiMshEd5lyeUMoSehNjmIizjSvwEGRW203Hht1B8CJTQO8BkPz5mHfXSxJGJ5vz4IR67SXKEqCGa7XaXCT0e0Ln6CUadSpy3Y123E6O2/mFEymcsi9OjkOK/+ykv1sMqU1bVtgrxmPUAAmBOqQiJBeKKPcdgc/e3UrYkt1Bb4ozp8WvRAVEAbaW6MNqg0wFNhFFALT39RVIdMo2lUOFRAXZ5Hfbob2w+c6tJI9rtFodwysPw6FFQhlmlMsKRXYElxR3ords4/+a846q5rN6mpxM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c45693b-e4f7-4f8e-8178-08dd4c658932
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2025 19:35:13.7476
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mpkLAI+77qRAFoY0KkcavaST2Q+9hHvZp4B0BXvfgBHmaI6pNKe8v5+JjPBzJ9z9Savk4DyQKFL1dXPfmjBbYR3g+fBcAIjMvNhGSwJc5d0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4786
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-13_08,2025-02-13_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2501170000 definitions=main-2502130138
X-Proofpoint-ORIG-GUID: WysSR1KTWIujlDzgXquFYTVomnGDM3VQ
X-Proofpoint-GUID: WysSR1KTWIujlDzgXquFYTVomnGDM3VQ

On 2/11/25 23:35, Peter Xu wrote:
> On Tue, Feb 11, 2025 at 09:27:04PM +0000, “William Roche wrote:
>> From: William Roche <william.roche@oracle.com>
>>
>> Here is a very simplified version of my fix only dealing with the
>> recovery of huge pages on VM reset.
>>   ---
>> This set of patches fixes an existing bug with hardware memory errors
>> impacting hugetlbfs memory backed VMs and its recovery on VM reset.
>> When using hugetlbfs large pages, any large page location being impacted
>> by an HW memory error results in poisoning the entire page, suddenly
>> making a large chunk of the VM memory unusable.
>>
>> The main problem that currently exists in Qemu is the lack of backend
>> file repair before resetting the VM memory, resulting in the impacted
>> memory to be silently unusable even after a VM reboot.
>>
>> In order to fix this issue, we take into account the page size of the
>> impacted memory block when dealing with the associated poisoned page
>> location.
>>
>> Using the page size information we also try to regenerate the memory
>> calling ram_block_discard_range() on VM reset when running
>> qemu_ram_remap(). So that a poisoned memory backed by a hugetlbfs
>> file is regenerated with a hole punched in this file. A new page is
>> loaded when the location is first touched.  In case of a discard
>> failure we fall back to remapping the memory location.
>>
>> But we currently don't reset the memory settings and the 'prealloc'
>> attribute is ignored after the remap from the file backend.
> 
> queued patch 1-2, thanks.
> 

Thank you very much Peter, and thanks to David too !

According to me, ARM needs more than only error injection messages.
For example, the loop of errors that can appear during kdump when 
dealing with large pages is a real problem, hanging a VM.

There is also the remap notification (to better deal with 'prealloc' 
attribute for example) that needs to be implemented now.

And finally the kernel KVM enhancement needed on x86 to return a more 
accurate SIGBUS siginfo.si_addr_lsb value on large pages memory errors.
Qemu could than take this information into account to provide more 
useful feedback about the 'failed' memory size.

I don't know yet when I'll have the possibility to come back to these 
problems, but at least we have the recovery of large pages mostly fixed 
with the 2 patches queued.

Thanks again,
William.

