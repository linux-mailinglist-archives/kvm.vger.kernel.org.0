Return-Path: <kvm+bounces-68298-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id AE2B1D2EC99
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 10:32:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 710FA30B468E
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 09:31:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD23F356A1F;
	Fri, 16 Jan 2026 09:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GYSpBLFe";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="M0D0a+wL"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49FDF3112B2;
	Fri, 16 Jan 2026 09:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768555907; cv=fail; b=ud2L+hRqPWpE3/NCd6sGfo1kvYfECNCCLNlDvHIwd/LlquWIhKd2Jg+iyJf4A0FzzL4rscsfMDAs05F8XzsOtTtTNg7kyJRgba2yo6KakbzcIsnELC0W1nKrCnjhpkwHk6XCYzodEDjclETKmV37ZAA315Htw9T/uK0VN2bx264=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768555907; c=relaxed/simple;
	bh=5jPQmJn4gwoFRcBsS5/ZIJG2jtS+uvy/HzaJZygN1q0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=O2ZxOhXR1gOYYhwOZWlf7SYaQX4nDCpaaiV6UhCakAaF8o7bSXDYHKxSI9GgW+e82AJJvfWMtd1CbRcvBetA8SbnrY0AYQOLTSol00BN6QJlK1PjYyTaYoEqVktdHlKUwyEiEjBkEhj/z42VJNXSep03WlVUmMgpbFh6nBA6c5Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GYSpBLFe; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=M0D0a+wL; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60FNNL1s1655463;
	Fri, 16 Jan 2026 09:31:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=IXZ+dAXgg4jMJ5qyN/grWXg7twO2jLdST0LGXbF9664=; b=
	GYSpBLFeIGSJRJjMpjP8C8Llw3hBg91lX2nTCflon9owNmhRjMlRjz4e/t4iUi8a
	UsoXqeRbsiJmrmUTY07eWpoTc5xgB0sLgymr1t8Z43SVwV6FGHWemLeBlEPjXGNr
	dnC0krBoHl0wdTFsBaeaxdPV9YQM42I+7OUcFyStBEIHKRFJMfqmqA2iZAxhMFtP
	tKe+1WN20QHonPGcQ3z16dRe/W60EUUNFC3VAqXVFNA5YYuATJECq54CIQcSswGU
	aYSHlCYNvVusY76cKTpDYUCQC3qo0pD/4lz7WKccSX5K/aUkbkE4gwN+Phf1J11S
	2/OlndFjgOQ1jTE0MFBt1w==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bp5tc508w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Jan 2026 09:31:13 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60G86RHp004234;
	Fri, 16 Jan 2026 09:31:12 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011013.outbound.protection.outlook.com [40.107.208.13])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7pfuyb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Jan 2026 09:31:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C+EYWlxrDfFhmjA0SKeCoerlwVFMn4Tex09AZ6gov2EBk59iGYDjc7cz/XE5+2s/DUIcu+3Y0Ihv6PpYFCB++m0Cu8HmKuAUV9kZ2375MzNKgM8MADuUuSzO1W2CPlb8Bx79nxI+moMKLkCqq9NRy59w4gT3tcXWBJvL3nBbd/X4SQAi30n0azoLpUAO2FHGzWpe7D5LW1e7NJCiaq7RZAh2D2v6cc7kYbTtEMwGlyo5whsSxgoPjgOceBNko+NmQYOQOY8i1Ia9ijI751QRjqayy7Xa4JqsOjh3yv16PEpkSFzu9Ok+w3YqVR+zg+oMXeshJgwRSxpnLM+4iAHgRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IXZ+dAXgg4jMJ5qyN/grWXg7twO2jLdST0LGXbF9664=;
 b=EBiwutP/anN4SSwXDfs3ZpmYob/paOJwP6mLha3UCEPJQmNPKPcunXaZJ9kH6NwN9WnbIsOLyupKwXuTV5XXxc3xefTYrVzu3CwPCW5ZOksqMjYjV1m5lZIGE1qk6Rz9sj82k9BDzgWu1T7+QfZrVHcetsgS/nyFrdqVj8ari3HgUQnHVfw8VxPdaV2RDsOz1S91nub9AaPV4iZKQGc87NsSL6MnPrAzmeAO3h3pW5v6wBraA97srdeFi7ZsKV1BoUUs79tT5YlctVBWhnFxsMXPScgQCJdBX6R0vQIsJYFUdoOciaNGVcDZQxYM6GBNhNJ508GIhf5qYFE1on14hA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IXZ+dAXgg4jMJ5qyN/grWXg7twO2jLdST0LGXbF9664=;
 b=M0D0a+wL99YTdKHdB82p/KtK0tXfqrT7IUes1KFihzbncDnKoyiQxE6/32Pm+sjofbDbMHZc1mpadBsAOPTYqgxHwTcvIbBF7/0wbR8gTJEsnUDsLooRKQNKQl4qbJZ9W7saJe1G4Ku9zOMgCRZbVkTRhVNLTj6/FleB1FOWcVY=
Received: from DS7PR10MB7129.namprd10.prod.outlook.com (2603:10b6:8:e6::5) by
 SJ5PPFCC3E08AE4.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7ce) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.6; Fri, 16 Jan
 2026 09:31:09 +0000
Received: from DS7PR10MB7129.namprd10.prod.outlook.com
 ([fe80::c649:a69f:8714:22e8]) by DS7PR10MB7129.namprd10.prod.outlook.com
 ([fe80::c649:a69f:8714:22e8%4]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 09:31:09 +0000
Message-ID: <4ed7a646-707a-40c9-93f9-2289fedf5709@oracle.com>
Date: Fri, 16 Jan 2026 01:31:06 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] KVM: x86: Mitigate kvm-clock drift caused by
 masterclock update
To: David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, paul@xen.org, tglx@kernel.org,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        joe.jin@oracle.com
References: <20260115202256.119820-1-dongli.zhang@oracle.com>
 <cea56100-9c43-4246-912b-234c6cfdc876@oracle.com>
 <285e30927dad5736df58aad5d957448e93b2d047.camel@infradead.org>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <285e30927dad5736df58aad5d957448e93b2d047.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR02CA0036.namprd02.prod.outlook.com
 (2603:10b6:207:3c::49) To DS7PR10MB7129.namprd10.prod.outlook.com
 (2603:10b6:8:e6::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB7129:EE_|SJ5PPFCC3E08AE4:EE_
X-MS-Office365-Filtering-Correlation-Id: d252ad8e-d8db-4161-b7de-08de54e1fb3a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZUlZTDhJK0Q3QWVtWVp0SkRPODR6R2RjMzYycG93MlVHWVVQelpITkxrOUwr?=
 =?utf-8?B?ZC9ERXRhUXYwNk8xS1ExVE5MUDJyS0xUa2l2ejhaNjgvYzEwK0dkdFJDVG5R?=
 =?utf-8?B?amV2YklJYmRNajF2WEpHdWtsWEJCMmZlYzAzczB5UXBYSmFmZys4Z0VlU25N?=
 =?utf-8?B?cmZlLzlXd3EvQm5mSmN0ckswUXQxaGhXcTdaa3B2Y0lxcENVTXBuM09GMVZQ?=
 =?utf-8?B?V2R2SElPSjB3RHljRmI2QUFHUVhkUUp0U3dtTnJQR1laMFZyek0vcytBWElq?=
 =?utf-8?B?RzJvYzE3MWJJSmZoRkhJZXhWNUFVenlIOTV6MXZ5YldmRVRiTlRFQVB1L3Zl?=
 =?utf-8?B?RmhVOGIvNklTK0RyVmtGNG1zNlI3UTE2SCtXQmJzQVllTi9SbHNTaFZGNUtk?=
 =?utf-8?B?Vy9WSTBlQ0RSVE96czFnSkNJT2FkUThTZnhVUStsdFJ6Vkl0Qyt3RUV5aWVO?=
 =?utf-8?B?WHVJbTBwRG9EeU1XSkFaYTBMZEV3S3p1dWFNV0Zialo4ckhYWUJLN21VdU0z?=
 =?utf-8?B?djdHOTRtSWgvOUEzSVJCQThrZms0RjN1VkxGTGx4N1VLUjB0TGxBV1I5QWJF?=
 =?utf-8?B?alZPVDNwbllucDVoWHpxQlBMZU1TeVpUZU51c21KTjQ5K1VhOUZ1b0tydTNJ?=
 =?utf-8?B?ZTM5VDUxZ0s4Znl3RmJOZ2wxNEp3SUZvTWN2WlZ5clJ2aXJaSTVzUXZITDM2?=
 =?utf-8?B?M01YcEFBRUVNVTlLT1JhcUhPNUc2R1NlTGdkTm9DRTU4VzJwT0o2d3B4bHFK?=
 =?utf-8?B?ZHhzZlRDSFQ4dm13cXRlNXpjbWFoL2p1cGtMVjFGUWoyeG1DQlFUc1NRUDNG?=
 =?utf-8?B?UXNTWHhvVWdHbHl0bEdlcUtHOEhNUlo3aTR5azFlVDJJOWhUaGYxWkprTFg4?=
 =?utf-8?B?Ym9HaEZsNmZNRFYrc0FRdWJpekFjTTVPdG0wekRmZkh4WUVld3BmUmgxd05B?=
 =?utf-8?B?NDZMQjN6Y1lSUzRZcXJUL0xUTlVvdlFSS0ErWWR1UCtVN3pueG5OeFpQamRr?=
 =?utf-8?B?MzNNZFBYbklXYldURkc2NnJ4RUVuSXFHQ1BCOGZWSElxN1VWZDQyKzV0RlB0?=
 =?utf-8?B?RkdvaXBVVlFua2ZBYkdqaXd0ekNaa3YzckFUNnNtNVlSeGZOaDN4QmpWZy9q?=
 =?utf-8?B?ODFuN0d6QWxTNG1DRDNHS3FlbGVBaEt4VGwzUWttN0FJcDdROUc2cUcyVlNp?=
 =?utf-8?B?Mzh2UmpJeS9hZWR0OXBaUGQwSFhGMmo0L1kydnRqK25EdklscnAxU1VaNURN?=
 =?utf-8?B?Qm9pNEN0RkNIZzJXbnZ3RVUveXBOM3FNVW5QZHdkMXFHK3FnWmpFOEJMZ0dM?=
 =?utf-8?B?YTRVNERnTlU3WmlOZFNSckhSMmc2aHU0d1FRYUhWTFNCM1R4TFluVXUvcVNt?=
 =?utf-8?B?VGtQaStiWW85bWI0eUkwT3VEcWpYeU9KLzNFbytBZzI4SjA2ZkdZYWtjZ05U?=
 =?utf-8?B?ZTdJdTNOaHg1RDZRc29meUJYektjdTJrVnNHZTB6MlhiVTAyeTlOUm1xSVZH?=
 =?utf-8?B?cklCU1dCcFRxQmZiWEZZNmthYngzWXBSWUJEenRWT3NMR2hKalJFZHpjd0px?=
 =?utf-8?B?NmRXeWM1eXdnQ0tPZTczRThUc3FGcjJzbWpveHNFYm5PVWhkVmdpMEU2RHFJ?=
 =?utf-8?B?WjVFbnBZdjUrYUdJd3E2YWZHTzB4ZHo2VDRBa1o4L3Z4TGZRYUQ0Q0kyU3hm?=
 =?utf-8?B?M1FIcTg2SkNpSlhHRVRjQ2JCcCs0cFFodkdCVlRzL21CNnQ2K2RZeFpLMHIz?=
 =?utf-8?B?c3VnVEVUcDhPWER1QWczVisvSS9LZ3BKWVMrWFFNVE9xUzI4bUh0aFk3ZXV2?=
 =?utf-8?B?TTgzL2VINnpneXUwUkFqUU80SG9vZitGdXd1dzVsNTdMaEF6L1lOcXo5NlRs?=
 =?utf-8?B?dXNGLzhOcEMzdGtyZmNOZGhqdXNSQ0htTFRjVHVmREttVHlndWt0aldHelph?=
 =?utf-8?B?R3FGN3FSczZMNkpIeGdGTGRIWURBaTE3b01iZEhXTER3QUlKYjdTb0tIOGJ0?=
 =?utf-8?B?M2xjbktsT2I1N05PbmM2YmhZd0tyWGJySlB2OGdLa1ZsNDA0anZFWG40TUU3?=
 =?utf-8?B?eVcwQ3I4SVZlTUFWK3MyQXhuVHoxNGJNazRFbVVaWllwc1RteFYxbG12aGhR?=
 =?utf-8?Q?yS5OB5pgIlc+rB6VFmYpO3RhF?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB7129.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?T1l2UjR3MjF6Q09rOUt3aDdYYVNySU9nOHo4eHNmaTljdldXNW9NUFd4djJC?=
 =?utf-8?B?d29jdTdQQUw2RnI5aldxSmgrcHFPYzR6aVlxSlNweisxalFTczdXU3R5UWhP?=
 =?utf-8?B?QlBYYWMrNEY5cE45MHFkdnZTZ1Bmbkhpa3VNNUhrUmZ0Rk9IV0VFNjFkWC9w?=
 =?utf-8?B?Y1U1TXdBTVVBakVtKzlkNm5kUFdKRm1lR2lyQVVkNHI1T1krTkV2c3VBcmtv?=
 =?utf-8?B?dW5iT0x1eWNHcnlmTGZhdkNFcG9RZFErY1FvOWhPaTBqVG9rZDZma0RscytG?=
 =?utf-8?B?elFQeFpFUlQ3R1lKL3B4Q25uUjY3RG1FWng5c2VTaVJsdFlvbXV2eTFYWVlK?=
 =?utf-8?B?a3RnZThjOHR1VUszRUQ1ZEYzMTZBa2VmVEVTU0FvV3FmWVBQNHVveXd1ZlE0?=
 =?utf-8?B?MnFXcUdSS2FTV3ZWZG52dC94UkplVzkvSmFSOU43a05hL0MwV3lxRVdEelZp?=
 =?utf-8?B?N0g0bDJnMXVINkYxS2I3RmZKckJsNzY0ZmVEQU90SnduelU4TDFQWEFaaysz?=
 =?utf-8?B?SEFnV29yZy9pcWFVbFk2ZTRlVDJDNkhRcGdmRHY3U0t4WStBcFVTSVRVSnY1?=
 =?utf-8?B?WnlPOXdXdjhuSklsMVV3YjRaSXEyUGtuVjRXUlMzWm9WNyszeHB3OEZiVkpV?=
 =?utf-8?B?ajRHNzJtMjNyb0czRjhCMkFvbEJXZ0Fxem0zR0pYeUdFUlV1K2Q5WkJZTTZO?=
 =?utf-8?B?dG1pMXRtcStKZHg4VG5hTU9HVUFDOHhUTEw4UW1uMzR0TDA0STZMR1dZRWxo?=
 =?utf-8?B?OEo2NHB6V0dOb0FDOC9wTGtpZFlDSUxWeEJ1RW1OL2Rnbzg3bnFsQnVzMm15?=
 =?utf-8?B?MlVoR2tzTm1rTklTRmMyYlhBc2Zxa3F1cFBDaStVUGhSVXBHZ0srNFo0U3pQ?=
 =?utf-8?B?T3pyczVxZTZhckRMMDRJU0gxTjIyeU1KOTIraG9WcDdUb3ZJT3ZBWUZZNGtn?=
 =?utf-8?B?Um5YTlhGV1YwZ3ZoUE9SSDIrU2FtS1RYMU9TWDVJdGFRdnEvUDZiRmNOb09r?=
 =?utf-8?B?NXIxY0RtYXRLclk4KzNTWk54M2dzSFZjUlFsQ2FoWXhNdFdLS1JPTEJCR3RJ?=
 =?utf-8?B?VVhrRWp1SUhqclVKa3pMQjBGZGk2ZXNwSkdBVE1rTE96M1NwRGo0UW9kTExo?=
 =?utf-8?B?RDZNV0M2akJhdDU2b3RHS1ByUkhUQnAxakN3ZjFmamFiZ2UyREJFTDBGUFAw?=
 =?utf-8?B?dWtwOEZGdkR1UXVJNGlIQWNXV3pZQmZ1T3dySUVPdWNjNWlZZmJjdjJjdnJS?=
 =?utf-8?B?M0VNVGNMa2x1YTFDRFJQbWRaVS96K2NlMVhWZGYvdmtSSzR5K045c3NBcDZG?=
 =?utf-8?B?eXFub3dBaHJwT1ljblNITnk4S3dsLy93M0kxcUFlbDhtRXBPR2JwWU5EdERG?=
 =?utf-8?B?ZSsyV0ZnZ3V2YnZhUC9scUVvbnhqVzk3YlQ1OXhPeDd3Sy9BWTFHdlVTZXYr?=
 =?utf-8?B?RGp3VHo0Nm1Od3IzN2RBOGI1aDhGMWF0U0twY0dXVWhRZk1ZWGJ3bW9BSDBN?=
 =?utf-8?B?MXpteGhLK2ltYXBjSkU2UnlpN2trUVRjbHhCamY3UkIzSUtlUjdHQkttVVFh?=
 =?utf-8?B?c2EvekN1dEM0ditBMCt4QjFMRHpJUzVaOFUrNVNEblBGbk5BZG00clRHUENH?=
 =?utf-8?B?QVRXSjI2YnA1NmtWOXY3T2tDdXZtazlKSmV2aVpnUUdkaDV2SzNJdFlmSXFU?=
 =?utf-8?B?cnpKMmIzandLQitadzBNaXFxR0dVQVNjNXBZenBLWUZLcFNzL2hCd1pkMFAw?=
 =?utf-8?B?ZFNyRFVYV2dEUWo1Z1VnWjUyYWJIdlMyS1ZLcHBnd0JNbVhvamZXZVBodzZS?=
 =?utf-8?B?encvK2RiZlRYWkRSblFzVXl4OGtpMVQxZk5ETm9Hbk9JeW0xTGNuM0tGK3ll?=
 =?utf-8?B?RkpLdVoyTjNpOEUyd0Z3Ung2dXE4WUdsUnRFdEUxYmFZRW1YTW0vUHU2c2tB?=
 =?utf-8?B?R1FIOVd4T1RhQ0JqSkdYVjI5M2hPSmN1MWJtOVl0Qi91YVVqUzVaWDRncFRh?=
 =?utf-8?B?b2t4UUNBQ3J5bHRYRGphemJ0Mmo2eW5TRHBmbEJ0M2pqcngyOUhlWTlMM0dx?=
 =?utf-8?B?RkMwOFpSckRZTCsxQThTV0JVVkxsSDBnakx4SXVVekZndG1ob00xMmUyVkpp?=
 =?utf-8?B?bHdPejQ3cjZ4UEdRYmtDbXR6MHlSUXlYOWRHYkJjTVFFY055U0xyaDhiRjk1?=
 =?utf-8?B?UUFTdDlsZFJBYVp0RzhzRk96QjdNcEpwQXdPdUJwZWRXd1J6eUdSMlFlTi9s?=
 =?utf-8?B?Ly9zNnU0UkEvZFJ6alVPdWc2VWVHQU9KWitIUWxKcUNqRm80TEpYVmdQWWEr?=
 =?utf-8?B?OW1Edm5ubTdranMzZy9HT0J1RExjcEwxQkVVNVUzWmZFZkt4N0ZCQT09?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	kmSgAE1FdI3QtXDb+/aPK1vLCzshKOgs4M9it5vsVzam5NSCXX883hgv9hoPp43OLpXOKaF/H52G3NUm0hW0TVaM6WD08CpE34DqiqJgk8P4T4q1SFF2kzb9jD3XN16obWgMz7+weI72hPbTP6zxK8lUCwqgL2xf51xTgwV8bd4b6rAU2YGxydWD6EJaYbRU5CcptQjq1wmMh+r3i/cjgCbhxL1CQ2dhNMolTRp9oVBTzqibvvcgl57UZujVVMhRhU+9a7WSgKWgqcHIUJniDzwK6qfjnzfEXmlkDUZEWAx6lgym3HQ0vtaUb8Ut2ssgugR0fp3Zizo9yCjguCPHjxvxxnHpCLCPrmDI3OUNBCtD5VuHyp603yOP+qNaxdZcVaOmAGXq5nNDWk9hbiwSBHdCX58ti4cgU8gXJO0CfhV2WckUmt93lAYXqYsQmw2TB2qxX/f6bcgbGGskc78aEFWvwjft1ModdSYc/WbLJXKeMNNECoC3eIGN7AB3W5RQWMY69Ptu4olS+247GRIX59eRUqUrCRSlbwXts1A3oUBjxqWBNdF+dpc61LvL8z3NjO+L+M5plsYoMhSXkYqRV1yDvsUnHlHNFUZk0WQdt/4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d252ad8e-d8db-4161-b7de-08de54e1fb3a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB7129.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 09:31:09.3837
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BvJtR/MZGqOzmq7FWN715vswa3RDPiOlEs41O2DC1/nX+eTG7lnycGt7Y4CzK8OWzgq9xUIkwd6X9MA8HgsUMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFCC3E08AE4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-16_03,2026-01-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 spamscore=0 adultscore=0 mlxscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601160069
X-Authority-Analysis: v=2.4 cv=XP09iAhE c=1 sm=1 tr=0 ts=696a0561 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=JfrnYn6hAAAA:8 a=yPCof4ZbAAAA:8 a=DMPg5WXVKIDBKyMp2XMA:9
 a=QEXdDO2ut3YA:10 a=1CNFftbPRP8L7MoqJWF3:22 cc=ntf awl=host:12110
X-Proofpoint-GUID: 0K5MuLLLcIyixW4C-s_hbw3sKDWx7sTd
X-Proofpoint-ORIG-GUID: 0K5MuLLLcIyixW4C-s_hbw3sKDWx7sTd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE2MDA3MCBTYWx0ZWRfX3Uq4G+TQoA63
 ROQLtaUMDReAtALWmWh3r8abudb/qOPnxT8ka8QToPzTpiVjKm8XOMdMgFtHfFjihtXm7vbOgZ1
 m2EHkEH8Vr+HmtwYOI6k5iYsxGp+/bEzaHfmIcPcwpY+YKpRqprCkBzAg4QBjIj7xbsIeUPRJrY
 fmVMMP/Pc+71ZBm9d/1wb+5FoybKeHFAOy9QamnFr5lnDPDoFkoRwrS16T1kwlb7MFhAgrWUMHb
 wRMwxvLH7rIpHZDFpvvXjI9m1fmnkrfzBQ9dY6HUqc/3GEczeeBHqOs32bpFce8byeuck2Ud1L7
 M+LhQH4K5zRwxByNKLVJV9GptEQuwMp2wPSslW1VA+RgFdEQchsS461MBnE3W3heJIB9hREobxx
 zVbs61Uj0BWDpNItD6J7OIn7PdzBqCvfxWJM3VvvGpSNVwORDuuIROV8mxyc59+qDP6Bx6p7P5M
 LDhyAl7Pw4gYKYg+ZFyXXBQy08a2lSpb1Dst5pFo=

Hi David,

On 1/15/26 1:13 PM, David Woodhouse wrote:
> On Thu, 2026-01-15 at 12:37 -0800, Dongli Zhang wrote:
>>
>> Please let me know if this is inappropriate and whether I should have
>> confirmed with you before reusing your code from the patch below, with your
>> authorship preserved.
>>
>> [RFC PATCH v3 10/21] KVM: x86: Fix software TSC upscaling in kvm_update_guest_time()
>> https://lore.kernel.org/all/20240522001817.619072-11-dwmw2@infradead.org/
>>
>> The objective is to trigger a discussion on whether there is any quick,
>> short-term solution to mitigate the kvm-clock drift issue. We can also
>> resurrect your patchset.
>>
>> I have some other work in QEMU userspace.
>>
>> [PATCH 1/1] target/i386/kvm: account blackout downtime for kvm-clock and guest TSC
>> https://lore.kernel.org/qemu-devel/20251009095831.46297-1-dongli.zhang@oracle.com/
>>
>> The combination of changes in QEMU and this KVM patchset can make kvm-clock
>> drift during live migration very very trivial.
>>
>> Thank you very much!
> 
> Not at all inappropriate; thank you so much for updating it. I've been
> meaning to do so but it's never made it back to the top of my list.
> 
> I don't believe that the existing KVM_SET_CLOCK is viable though. The
> aim is that you should be able to create a new KVM on the same host and
> set the kvmclock, and the contents of the pvclock that the new guest
> sees should be *identical*. Not just 'close'.
> 
> I believe we need Jack's KVM_[GS]ET_CLOCK_GUEST for that to be
> feasible, so I'd very much prefer that any resurrection of this series
> should include that, even if some of the other patches are dropped for
> now.
> 
> Thanks again.

Thank you very much for the feedback.

The issue addressed by this patchset cannot be resolved only by
KVM_[GS]ET_CLOCK_GUEST.

The problem I am trying to solve is avoiding unnecessary
KVM_REQ_MASTERCLOCK_UPDATE requests. Even when using KVM_[GS]ET_CLOCK_GUEST, if
vCPUs already have pending KVM_REQ_MASTERCLOCK_UPDATE requests, unpausing the
vCPUs from the host userspace VMM (i.e., QEMU) can still trigger multiple master
clock updates - typically proportional to the number of vCPUs.

As we known, each KVM_REQ_MASTERCLOCK_UPDATE can cause unexpected kvm-clock
forward/backward drift.

Therefore, rather than KVM_[GS]ET_CLOCK_GUEST, this patchset is more relevant to
the other two of your patches, defining a new policy to minimize
KVM_REQ_MASTERCLOCK_UPDATE.

[RFC PATCH v3 10/21] KVM: x86: Fix software TSC upscaling in kvm_update_guest_time()
[RFC PATCH v3 15/21] KVM: x86: Allow KVM master clock mode when TSCs are offset
from each other


Suppose the combination of QEMU and KVM. The following details explain the
problem I am trying to address.

(Assuming TSC scaling is *inactive*)


## Problem 1. Account the live migration downtimes into kvm-clock and guest_tsc.

So far, QEMU/KVM live migration does not account all elapsed blackout downtimes.
For example, if a guest is live-migrated to a file, left idle for one hour, and
then restored from that file to the target host, the one-hour blackout period
will not be reflected in the kvm-clock or guest TSC.

This can be resolved by leveraging KVM_VCPU_TSC_CTRL and KVM_CLOCK_REALTIME in
QEMU. I have sent a QEMU patch (and just received your feedback on that thread).

[PATCH 1/1] target/i386/kvm: account blackout downtime for kvm-clock and guest TSC
https://lore.kernel.org/qemu-devel/20251009095831.46297-1-dongli.zhang@oracle.com/


## Problem 2. The kvm-clock drifts due to changes in the PVTI data.

Unlike the previous vCPU hotplug-related kvm-clock drift issue, during live
migration the amount of drift is not determined by the time elapsed between two
masterclock updates. Instead, it occurs because guest_clock and guest_tsc are
not stopped or resumed at the same point in time.

For example, MSR_IA32_TSC and KVM_GET_CLOCK are used to save guest_tsc and
guest_clock on the source host. This is effectively equivalent to stopping their
counters. However, they are not stopped simultaneously: guest_tsc stops at time
point P1, while guest_clock stops at time point P2.

- kvm_get_msr_common(MSR_IA32_TSC) for vCPU=0 ===> P1
- kvm_get_msr_common(MSR_IA32_TSC) for vCPU=1
- kvm_get_msr_common(MSR_IA32_TSC) for vCPU=2
- kvm_get_msr_common(MSR_IA32_TSC) for vCPU=3
- kvm_get_msr_common(MSR_IA32_TSC) for vCPU=4
... ...
- kvm_get_msr_common(MSR_IA32_TSC) for vCPU=N
- KVM_GET_CLOCK                               ===> P2

On the target host, QEMU restores the saved values using MSR_IA32_TSC and
KVM_SET_CLOCK. As a result, guest_tsc resumes counting at time point P3, while
guest_clock resumes counting at time point P4.

- kvm_set_msr_common(MSR_IA32_TSC) for vCPU=1 ===> P3
- kvm_set_msr_common(MSR_IA32_TSC) for vCPU=2
- kvm_set_msr_common(MSR_IA32_TSC) for vCPU=3
- kvm_set_msr_common(MSR_IA32_TSC) for vCPU=4
- kvm_set_msr_common(MSR_IA32_TSC) for vCPU=5
... ...
- kvm_set_msr_common(MSR_IA32_TSC) for vCPU=N
- KVM_SET_CLOCK                               ====> P4


Therefore, below are the equations I use to calculate the expected kvm-clock drift.

T1_ns  = P2 - P1 (nanoseconds)
T2_tsc = P4 - P3 (cycles)
T2_ns  = pvclock_scale_delta(T2_tsc,
                             hv_clock_src.tsc_to_system_mul,
                             hv_clock_src.tsc_shift)

if (T2_ns > T1_ns)
    backward drift: T2_ns - T1_ns
else if (T1_ns > T2_ns)
    forward drift: T1_ns - T2_ns


To fix this issue, ideally both guest_tsc and guest_clock should be stopped and
resumed at exactly the same time.

As you mentioned in the QEMU patch, "the kvmclock should be a fixed relationship
from the guest's TSC which doesn't change for the whole lifetime of the guest."

Fortunately, to take advantage of KVM_VCPU_TSC_CTRL and KVM_CLOCK_REALTIME in
QEMU can achieve the same goal.

[PATCH 1/1] target/i386/kvm: account blackout downtime for kvm-clock and guest TSC
https://lore.kernel.org/qemu-devel/20251009095831.46297-1-dongli.zhang@oracle.com/


## Problem 3. Unfortunately, unnecessary KVM_REQ_MASTERCLOCK_UPDATE requests are
being triggered for the vCPUs.

During kvm_synchronize_tsc() or kvm_arch_tsc_set_attr(KVM_VCPU_TSC_OFFSET),
KVM_REQ_MASTERCLOCK_UPDATE requests may be set either before or after KVM_SET_CLOCK.

As a result, once all vCPUs are unpaused, these unnecessary
KVM_REQ_MASTERCLOCK_UPDATE requests can lead to kvm-clock drift.

Indeed, only PATCH 1 and PATCH 3 from this patch set are sufficient to mitigate
the issue.


With above changes in both QEMU and KVM, a same-host live migration of a 4-vCPU
VM with approximately 10 seconds of downtime (introduced on purpose) results in
only about 4 nanoseconds of backward drift in my test environment. We may even
be able to make more improvement from QEMU to rule out the remaining 4 nanoseconds.

old_clock->tsc_timestamp = 32041800585
old_clock->system_time = 3639151
old_clock->tsc_to_system_mul = 3186238974
old_clock->tsc_shift = -1

new_clock->tsc_timestamp = 213016088950
new_clock->system_time = 67131895453
new_clock->tsc_to_system_mul = 3186238974
new_clock->tsc_shift =  -1

If I do not introduce the ~10 seconds of downtime on purpose during live
migration, the drift is always 0 nanoseconds.

I introduce downtime on purpose by stopping the target QEMU before live
migration. The target QEMU will not resume until the 'cont' command is issued in
the QEMU monitor.


Regarding goal, I appreciate if there can be any quick solution (even short
term) or half-measures to support:

- Account for live migration downtime.
- Minimize kvm-clock drift (especially backward).

Thank you very much!

Dongli Zhang


