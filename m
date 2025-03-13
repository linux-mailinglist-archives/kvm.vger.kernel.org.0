Return-Path: <kvm+bounces-40972-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B0FA2A5FE98
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 18:51:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C3EC5179A1A
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 17:51:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52CE51E5701;
	Thu, 13 Mar 2025 17:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mN7yHari";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ppefxk3P"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99B091EB1B5
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 17:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741888283; cv=fail; b=ZfJva47LRtDobQWWnm+ltSo8gl+Rv41vqjMNex2XRdstatQAFY+L5iHR7bTCVXvJfNm4RswuDrM4NlXP1c/CjpD1eXgOEZRkBXTOUyPiYSPhJEOumkXUvS+Iuq1FfNEaeghW7HsRR0+DK5WFq3pW5u02wNdeCvCgwhTgUh0Nyzg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741888283; c=relaxed/simple;
	bh=IsZR1XVRyWLACWCGb0hXqRoaWPOvn+6I0p6H/H5C834=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Sbri/6XlPQ35hAS3r133dCuivAUo7uZCazfhIwGGClpm9ipRaSgkAqLk5M5p7KlFcbO1i4s2x0glCtST+6OoMz3IAmLevg5bTvmifWNpqYkQKw1FNh3pXl0a+oPTbHuLo8uyU6I6RJBNi/sHHb60CA6tkRyVMEL+IxsjbBwQ8Jg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mN7yHari; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ppefxk3P; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52DHXiGT019670;
	Thu, 13 Mar 2025 17:50:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=6FMYL1ge1Ew4x553mSzWKKz4PrzeusWHE3Z+B3frJIQ=; b=
	mN7yHariSomGC67E5lej34FMkhJ75pZZ7A7zX4Fv4D2Ht3lNGfJY8IAi4u6i8Y2T
	8uklwVkPTdkBKyy/5YDqvy/Nu0fBWQ402HiBjy7pxuRboPKdLn0gz+Ds2fx39j9i
	9qKkFuAldlZOt86LAK9eI/8k3nEAo57zLR6wUZ6EfStMEf5tD5UdMBOaui/k5iwS
	yZUMZ0OU+QOzPkECrhBf6qk8UTLG25/Q6oUFhqaJMF0w+6eDRyEZGSu8KBwpTEdJ
	loDdQPMLNKma8IIgSAvKL4OG8yqjitY9CtmgJRgr3c3ozHIQS9FRYKB422xT5PoE
	j6QWsSqgL01hzm6lhIAnEg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45au4dvsex-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Mar 2025 17:50:58 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52DHkeME002164;
	Thu, 13 Mar 2025 17:50:57 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45atn922bp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Mar 2025 17:50:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DiTGCVdKrtUdsD3HIDrbo5JiAJcTEvDxwe9mysZrtwdgLQyYvOX0sXu7sz/62htQ/kN35hi8I1N0i0edDDTS+9Ur/lHaF+t0nkb9aDBsDC4a1EOoYUG1JQMozgblBIHTzf10xlRjL3PGt+oxUBLLEAxTUZCdvhO3vHr6NN69LvCkGnNqUGMvkrB0MTbxCQtQkJjSnd6laFA6S4z3Sl39YBKVjnp36kfTdC8MHlQ30Q+aWlFQzvKnyw1UsB6XzfZHngmbTiD/cKfIp0qgUTe6FfdIqUspi54ExkQhv/CoQWcxt6CNmObzhi93WX2gbVtjVsVye5rDq2uUq+cv3YowLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6FMYL1ge1Ew4x553mSzWKKz4PrzeusWHE3Z+B3frJIQ=;
 b=fTMCHTHDoPnwHnxsrjcHxkykQ2T8b0j/5c+acXE0kRDxqZ4PHZnCx4Djdl4jOnA39NpTsPLs0Y4088fbf4b+nmtUEb1Z3COgSlYxdZfnAWIk0U07ambvxbNae7cNgg2G3yha5h1QrdiZgDwfNzogwi3RgKmyUzcJ0hmpeyR5sfrP0rtDYJIIHbJUnwUdgh80dR/yh8QvhLVJFvq/UYN1ICCpe0VkdzdMlG3jQWPNc0i1q7Ae0awu90M9bUaUrTASEfkYOy+FIpixHPLriLj9guU5s+81xw5ZHkgnP/eYWewoOFZeo2ywBHiR7ChMcRNqTDnIkFl4qfBUYV3l24pllQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6FMYL1ge1Ew4x553mSzWKKz4PrzeusWHE3Z+B3frJIQ=;
 b=ppefxk3Pi3tXEHI7zyjrTQbuDD2yN5NT8EYhXbdQDdzsvqMHHn6B0zPhDGGYyHJ4zcXpjg6cBLusG0FW7DEzF8v19Up54h00tVg1r+E1cbKF70t76r666BH3pkRVGF9RuaYUBxioddZKPIjAxF30z5eQWn6fCx1e+/o6xgq2Zco=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DS0PR10MB7523.namprd10.prod.outlook.com (2603:10b6:8:158::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.28; Thu, 13 Mar
 2025 17:50:54 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%4]) with mapi id 15.20.8511.026; Thu, 13 Mar 2025
 17:50:54 +0000
Message-ID: <8467cd63-8a0b-4bcf-b539-8cfe040f55a4@oracle.com>
Date: Thu, 13 Mar 2025 12:50:53 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 02/11] nvmet: Export nvmet_add_async_event and add
 definitions
To: Christoph Hellwig <hch@lst.de>
Cc: chaitanyak@nvidia.com, kbusch@kernel.org, sagi@grimberg.me,
        joao.m.martins@oracle.com, linux-nvme@lists.infradead.org,
        kvm@vger.kernel.org, kwankhede@nvidia.com, alex.williamson@redhat.com,
        mlevitsk@redhat.com
References: <20250313052222.178524-1-michael.christie@oracle.com>
 <20250313052222.178524-3-michael.christie@oracle.com>
 <20250313063651.GB9967@lst.de>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20250313063651.GB9967@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR11CA0066.namprd11.prod.outlook.com
 (2603:10b6:5:14c::43) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DS0PR10MB7523:EE_
X-MS-Office365-Filtering-Correlation-Id: 1113df32-0dff-434d-501f-08dd62579a08
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UWpRU1hqZVlkeDJPbDUxTFI0aVcvajZvT3pSNU1zeVdPeUNFbm44WUZPZ3ZG?=
 =?utf-8?B?YldFbWRhWk1vZkcyaGc1bHY5RTNFd1FKRjJJeWNRRE1HYjFPRWZydU85TzVa?=
 =?utf-8?B?andTR3R3cUF2Z2REQ2ZST2pxU3A2b1BvMVN3Y3ZlRS9sZEJNSDBHbkFaOG5p?=
 =?utf-8?B?Q2UrOHRmMjJwQzZCckd6UHFBT2lDckg3THhWN0VjN3dGeWxJcTQ4TjhGbmpp?=
 =?utf-8?B?c0RvSHJDRkx6bVRmUVVjUW9hc3NXWkt5eURTLzBURlN3T04vblVsM1lUdXpH?=
 =?utf-8?B?bnRsWktaejZYMkI1TmhBQTBIc1hzNzVwZENDUnBTbWdvdWRzOVVMVWk3bDhi?=
 =?utf-8?B?cTVJbCtmZnRGazVFZFRKM2tiOFo4clk2bjhqSG5KOEpMNTVEVEwzRVVNNUlM?=
 =?utf-8?B?bXFiVHVYejhvSHlLMXRTU3dnRFhLaEtIVlFYdHJCRkRTdWo4S21PVjZiMElG?=
 =?utf-8?B?NzlqLzMyaDBUQ1NtSEU0VVlwejFRUGt4MXRUdGd3aU5pUUppOHNZZTl0SmRx?=
 =?utf-8?B?RW90dWtJenU2T2E1cU1RZVM3d2tieGhDT0lSL3dWZ3ExaHNEUXpCYXVDVm5W?=
 =?utf-8?B?Z1NaaEJ4ckd6VUVKNmFJL2RhNU5tNEFubTZXZ3FtMy9tMUZVZzA0TWZYTWZq?=
 =?utf-8?B?MmxBMU5RbVplWGhHdEdXcWRRYUoyRGswd3JDQjZqVlQvQ2VVYWltNmFIc2hG?=
 =?utf-8?B?SEVpQmtJVkJXRk9zdkJyZm5OenRDRzQxZHdOT2dtR0F3bDNpWWZ5ejBRLy9L?=
 =?utf-8?B?c0dvQTlNZXVub1ROaHZ6ZjJCU3JrN0pSRk1kOWVOdVE3YkN5Vm9ERjExNGZr?=
 =?utf-8?B?STJya3h3RU0xcEhVblhDWWtiL3c1Tk5waFpkZTVlalhveVFaNmE4aVp6a1Vs?=
 =?utf-8?B?KzB5eTdVZ2taSE8rbnhvQUdtVFJ0UmxEeEMwTG5JcHRxNHhoWE9DNGJzeFU2?=
 =?utf-8?B?Y1NYYXE5NHJyZTMvYnpwYmNwTENHbmNNNU51dlZGOStlTURURGdRS3o1R2x1?=
 =?utf-8?B?RE1KRU8vZ09VbWNoWTF3ZndYSm8vaGlMTHZlRlZyZlVRTXlMbzlXR1gxaDJ6?=
 =?utf-8?B?YkhCZUtyWGIyb25XVG9VNk1NNWIvdDdVdHpNbXMzczQxZkttMDZsMUZWc0xR?=
 =?utf-8?B?THpoLzRNbjdxalFlYTI3UFpRUk9XdThNNjdjakdnL2NXZXRWeEMvbXhIaTZi?=
 =?utf-8?B?TVliaUZ0TzUrZjJoWXJzdmFKZ2xaT28xR2RWUTNMd1V1cDI4WUY1NVlaRURU?=
 =?utf-8?B?SnpJNTMrd05iRkxRa1lLcWprNGtaOTJqUXFOVFhGdElQaDM5cWE1aXk4QmZB?=
 =?utf-8?B?clp5NnhlMmxaSXh1aEZVTmNwdC9ENWNKRnFjWk1Hd1hQMkhSN1NCV0RFcjNR?=
 =?utf-8?B?U3M2Zk1MV2xrQmFYOWU5ektqRWU1aTR2QnFuSU1nYXFrWUYzd1k2cmhuNHVW?=
 =?utf-8?B?a3lZSmwzZ1JSQ29ZZy9Vb3oyL011aldOOFNENjM5SkF1bHNKNng2L25wclRk?=
 =?utf-8?B?cVRGUDY5UVlIUUhLUlZRUkNaWG5ndmZPRFFWcFlJa0NhZHdhd0pKdGdrTjBr?=
 =?utf-8?B?ZzYzZGxLSW45OG9sT093cmFkaUJBQldQRlVIZ214Sjl0cDY1V2NZMnpoZkpU?=
 =?utf-8?B?MkJoTGwweTN2Wm9DTXRoMjNMaEtHOE0wWG4xRU96M3ZaWGwrK0RhOUdIaUhB?=
 =?utf-8?B?azNacm5KM3d1NStOb1FITE1tUlk4ZXErazkyUHlaNzdRaXJ6UUtVdWl4Mmgw?=
 =?utf-8?B?Ukp3Q2ZaaHNhVitwSzhpdWJ6a1pabFptUms3UGJBWWpPa3pBY3NqVjN1OTds?=
 =?utf-8?B?WitnZUZYdjJ4L0JjZ0t0SVBvRWJ1RTBxTzhDU3dMVzhJZk0zOEtWc1FwVzBQ?=
 =?utf-8?Q?5XQVfJ0u+xLtW?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UnhQLzdIQXJ2cVc5UmdNbVo2V1NJTVFUOHBzMDZCblEzRXJCdGVQbDhrVXJW?=
 =?utf-8?B?TFBKSDFqZjF2VGxjd3lUR3VhN0h2UTdwTi9vTGVCNisxamc3WVJpY1JHclZo?=
 =?utf-8?B?eVFiOXU3WnlZY1VZRnhVTC9jM0FpWXdBckQ4dmFXUnE3NCtQTEQ2bm5DQWhQ?=
 =?utf-8?B?RmNJVW4yNVJidUFnR05hRFF1TU9vVUtXWGdoUWJnQmhabHkxak5INExDVEd4?=
 =?utf-8?B?R1BVTXVvTWp5Tm9VRVcvbHg2VW1xdGJRMkM2Z205Q01WNWhqVXYyVDhyVWEv?=
 =?utf-8?B?NjJvT2N6UDB5a0RQeS9mdmhNZkFaeXB3ejBKbzFYcmFVYzFuSFdmbVFkdkI2?=
 =?utf-8?B?SUNEdEV6N3UzK1c5R1Z0cHoyTmJVOUFKK3NJWkZPbzVCQnI3aTZ4QXBvbU9V?=
 =?utf-8?B?RmFJeENmWFIzZWpXNG9SVFdZcHlZbGJzRkUwZUJONGJjTGp3Nkl1VGVEZjVw?=
 =?utf-8?B?dUxRd0hGTWg2Sm5NZ0MwNTEyU2VQOEpMMVp3TjgyK2lOeGg4WmFub2gvTmVi?=
 =?utf-8?B?R1dmeGsrZ1g5ZnFDcFZFdk4wV2dtNG0vMmtYVlU2alhqZmdNY2pwWWhZejVQ?=
 =?utf-8?B?TC9RRlYvTEVjVWw3YnkvZ2lvdkc4TElGWFFPcTh5c0FGTlhwMnhTeGt1Nm1x?=
 =?utf-8?B?c2IzYUJOUHJxQ24wRVVzRWFVMlRUdDZUdGdwR3VyLzhnM3VSck9IWWtDZndE?=
 =?utf-8?B?U0pkRk5VWnZGeWJqUS9VQVRSYzQva2JRbElwdWZHc05tb0hNbCtkV0ZDRHNv?=
 =?utf-8?B?QnFkR09UTVZ2QkwzMS92ZEVGSWR4RWVUNzhIdmpRdTd4dXZGK1RyK3JjaHNu?=
 =?utf-8?B?aW1Sa3dZYkdOS0xJdE9jQkh0dFp4dmxLd0ZxRzlEL1owSXVGd28yN0xnbkhY?=
 =?utf-8?B?a2lSQlN2SmpiU3dJNlBDblREVEZpRGREZTg0OVVDc1hHcFVsdVF4Zm5lRGQ2?=
 =?utf-8?B?bER5YXJ1RFl3WktRMTZpQ2ZvUjJ3L2Z5c1p1UEYycHEzTUZEZUNzM1YyTnN0?=
 =?utf-8?B?TGJ5Y0llUHZxeWV4cnFpN2I3ekc0MGE4aWRUWUVxa1VJY0hja3FZc2RjeDU2?=
 =?utf-8?B?eENEa2ZpZStqMVhsK0tSWldybWRnM01WN1RVSmlkT0pRRlFjMkxxVVBaaHFw?=
 =?utf-8?B?VkkzTko0VHNHRm9LQjNMaldKR3hoam5KdXJkcTlmcFJ2UTdUVVBBSlJ2UXVK?=
 =?utf-8?B?WEJ1STNZSzlONEFGd3BxVVk3eWFMSXh6VEhYUWV2TDUrRXVKaGRUUlg1bExC?=
 =?utf-8?B?bytBRE1CYzVXN0FybEZ5VnB3emx1dDJ1d1VhTGg0dHljT2JxSkhmRE1vNHoz?=
 =?utf-8?B?WVgxelMvWG5jSGRoZW1PenBkTXUwaFhEQzF2TytXQy9XNWhEc3VkRjh0a3l4?=
 =?utf-8?B?RWpyOUgwVDFRWGV3SGhIQ3FGSFVyR1g3RC9oa0pCQTlUcEdWalpWMjA0Z0Ji?=
 =?utf-8?B?Nkp0ank4NEpDdFlNb2kwOVhteEpIUVExeGVhS0VBRlJSUThxdzBMWW9zNHo5?=
 =?utf-8?B?NVJ1SkttRVlLakpLVGFrKzNYMzRYMnMzNzNUMWxGTExGSEJaZkd1b3h5U0dF?=
 =?utf-8?B?NGowRTRtaFN5SERVZWJub0NRUHprVmZqNmJxcENRR1JKdDM1MkxCNnE2Um1T?=
 =?utf-8?B?aDExL3RRSG9qcU9QRU1GbXNWWnk5MmFNWUpxTHZtSEhaSlNDMTZDMm8ra3Jw?=
 =?utf-8?B?bVJDMXUyUTZFSGtIWWdINnQ4ckpvSVl4N2pMeWl6RXBTK09nL1dxVEtrUlJq?=
 =?utf-8?B?elVqaXdiWVRKR1FkZXdWZ2JhTU5hbk1Mc0pCSWwxV1hubTVPMTlZRmlOMHov?=
 =?utf-8?B?TEczYjBSMWExKzdCdWFpcnlDYjNFUmoyTHRWVEZtUEtNSytJWU9xdVEvZUhF?=
 =?utf-8?B?bFI3VWVDeCtsbG1DTHhkUmsvT29UKzRGeGFpUURkb0JHRGwzVjJXbUFmeGc3?=
 =?utf-8?B?b3BlbEhzZHFKNXJMSHM0UExTcjRDWEhIZUladWp5SXdOZWhERFJKNENoaWdB?=
 =?utf-8?B?SUUzWldzbStOYVhGdzgweFcrdU5PUlVlcUhSbXFuQ1NobHpPdXgyMTRzL2xM?=
 =?utf-8?B?ZnZvUzBHb3FPdjhISE1Fay9MTzgxSkRHS1VsQTlnZmlSRG9PMG9oemV4bFQx?=
 =?utf-8?B?RXczdkMwb09HVTZzMWorbjNWQzdWSlBMZDRFMXhvc1VDYWNnNjBnUE0xQXA5?=
 =?utf-8?B?Smc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rlyg749+7SsWpheYAQU0T4AmAWLCOMaJzKJgEeB4w1kzpp0yhFdrYCpHCaijlhZiynAqJikthsx8uBxci4lNCSglrVnk0QKrqnNFE0NZwDEiaeTCVtKe3IZ1s0Qs8TpjalAOh3ojZvEHqc8Xr8Uut4InZiNp/F2vvgdKm+ozlHI7Mp/4072WxmDdFPg47OHfABFQnP0K2Ixp5FnsSQ/8uCzvsNnkJtPtXyC1ymV/n+hcIQyKhQQwRsgU9E7DUCV95CoN1RaNsXejgWAAq8SsEcPOnqu7olXgMfM+alMBhjTu4mtPZo8dA3rBqjLjXSXKupSIJHS/B9kY4e4dkt3Bo1RgnAlUa7/1Jb5AFU1uDIO156rBTvKhJ5HuDAHwFS3KUlF0ga6NBudxCtiv14YQomZq4Fhfiy2dvnqzGjyJUIjoJhXX0mlN0/aei0CQsbxbamXYXSpBERLtD7Bz8I0VShKsAPCNEDlcSwzilOKW9ke5McAZcWWyXpqZ6vn4IXAR0ajRodQrFsQdmIBhqKyYGD8IjpwvB5CgzS364CZEfWTgywy6b1WVkZxyt6lDFfuZWjiuewVWN5V6/SpMeCh4x2VDNmAUyFSHPHD9Z8OrHeE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1113df32-0dff-434d-501f-08dd62579a08
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2025 17:50:54.4156
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SztygXlKOq8fXBujm0BeTIJyCRRsVg9BNeR07N0RFA4G5GzfyWp4RFzqoEEZM6T8y/MK68lRLgP7uznongbM6ZProIVdNZ17o1NTtIyR78k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7523
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-13_08,2025-03-13_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=929 phishscore=0
 suspectscore=0 adultscore=0 spamscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502280000 definitions=main-2503130136
X-Proofpoint-GUID: xpD63y-xoSvGPfDsrBYaSQyTln6YERMa
X-Proofpoint-ORIG-GUID: xpD63y-xoSvGPfDsrBYaSQyTln6YERMa

On 3/13/25 1:36 AM, Christoph Hellwig wrote:
> On Thu, Mar 13, 2025 at 12:18:03AM -0500, Mike Christie wrote:
>> This exports nvmet_add_async_event and adds some AER definitions that
>> will be used by the nvmet_mdev_pci driver.
> 
> Can you add a little explanation why mdev needs it by pci-epf not?
> 

It's due to how the drivers handle NVME_REG_DBS. The mdev driver
registers a callback where when we get a write to the memory at
NVME_REG_DBS + N, the callback is run. If we get:

NVME_REG_DBS + ... some invalid queue

we were going to send a NVME_AER_ERROR_INVALID_DB_REG.

The pci-epf driver just checks the specific queues:

sq->db = NVME_REG_DBS + (sqid * 2 * sizeof(u32));
...
sq->tail = nvmet_pci_epf_bar_read32(ctrl, sq->db);
while (sq->tail ...) {

so doesn't see if the host where to do a invalid write.

