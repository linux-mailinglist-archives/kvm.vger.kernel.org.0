Return-Path: <kvm+bounces-25792-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D55796A9D5
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 23:14:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3294E1C246D6
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 21:14:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C5A11EBFF9;
	Tue,  3 Sep 2024 21:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="h6d5SBXL";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="kD9KJVuW"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6D241EBFE0;
	Tue,  3 Sep 2024 21:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725398087; cv=fail; b=nSn3DE8p4vTLq53RD/M/YZVbWpfVIh4FzDf+SO3SgS/jk+vqiwnaDoYJgYuz7O8s3abBXmE7Mc7axiE8JrPzwEnNuYvLkg4nDv/taWMZjtj7Dm0q4YyJ5eCwDg7fWSCFXeTQzqq3lBx+Q46UHWfPCET2OSUhyN8K+CSOm0pJP6Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725398087; c=relaxed/simple;
	bh=jRARtYvivHHZvHfo98BuRn3Etpzz7jOpCDnS5cIpiRM=;
	h=References:From:To:Cc:Subject:In-reply-to:Message-ID:Date:
	 Content-Type:MIME-Version; b=dFPE3vMnjof0W0LLwmCznaAJlP9ILGXaI8tywZdumQ7PfLUVffKzX0bOr+G40fmuXbEELNWUrEdyqHC4J4ysn+X/OU77NuTTzRmGuwdzbtyxDcL8BT7h+06Y5H7MUm2XXfyWLczelR6MdsCG9eCqlCz5EUK/V1fpLtSKDA54Pxk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=h6d5SBXL; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=kD9KJVuW; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 483LBTCp022739;
	Tue, 3 Sep 2024 21:13:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	references:from:to:cc:subject:in-reply-to:message-id:date
	:content-type:mime-version; s=corp-2023-11-20; bh=t8O/ejiggzCE2U
	Lke0TvOT1uDuVSOEWNi52Ko0qqrJg=; b=h6d5SBXLWrOXY2pevlGWf8frJ0GV9M
	jb8Jz/I3OZPOO16t5ItlnvayEJApOt6m7SkDHve/TUjjr6hAOjZ5wP74hvn4/v+e
	FEmeAaqi7XuyitSqURR6On6Cr1HNnJz7V8beZhjE7jvA78aLTk6iJ25USrGNcrO8
	Awc8QzS9vw9AKoyy6TwmJLYplNFo66WDM9sW/FDxvkjHR0piS45q0Hq/czh+VmLd
	8WyMMyFKKEqnKwijBxO97QX3ef/1rRxrqCK0rMg5nA03WAaR/l7M3fnxl9PC9Owr
	nt6lOI5Hs/fkMjnfY5aBt6DbzZeQ1nBevnSLwSGhIVZmwsSD1FvxA8LQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41dk84jp7d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Sep 2024 21:13:57 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 483L2mv8001723;
	Tue, 3 Sep 2024 21:13:57 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41bsmfh48m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Sep 2024 21:13:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HW4h9Ns5H/IiECmRWgP0mTYZFuDdKtZrmIpkKOcnAdjCHLyetTECu7N8CIBEA2fyWMxtF3pNoyE601qK6YeyWEjEyXlut+wgar7Q21XfTMPWchlxHYqL+PetLEgi5dQsognVvJU6NUA3iNvQ35QoiyXL4nv834L7p7dpF8mHxJ5yXLI5764cEdXdXb9MRkKEnt7bbDI6AE3gaDND2GLOMVUD1XOhhU9pgXNV4MzkWmy6u6rS++pBhj88Conpxi1D1+GLYTpe6AwWI5DiavPgmzxTt1p0PITmpBqGuDZGLGSMsnhQwKfI1OcVmgBIradA5tWjABZvd49FAeatOPGQwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t8O/ejiggzCE2ULke0TvOT1uDuVSOEWNi52Ko0qqrJg=;
 b=Goye7mpbKe4DtvoYHh9u2O3GommiakVR3ZvK1vKcmZ+3L+8YvogidcNUcKRpco+cMf8NxjjWATVhnWG/tSW3QQ3nby+FJopaOCiHcsKX8xm35cHCs44yXOoHnm1D7cgRGz+9NYwZ1rNy9oNS+HUERb+HKedhgIIirk/4UZETDp+S0Gs69Z6pmgfiWkU3ql6N+fWCBdDMU2UQs4yq4S12/MQIcop9PrC5x7A4gRstF5cky26ELGnjJbIP2gNd+8w+AHexql+hwavGZe442UMZBOscpEn1gl6U50pkZtyd9a4os1mTT+IatSe7o9xoX8Yw0ozdiTfAi7WXmJ79hCdCbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t8O/ejiggzCE2ULke0TvOT1uDuVSOEWNi52Ko0qqrJg=;
 b=kD9KJVuWCRdZPgnwXSwkbtPr5ljA3CiLck0x3l6OZY3hA54fTwcStwcsGiOa9j5yx8oid+yTj2h9FsEJFL7HKWDD1BBZexVpHMVMU/Rb8R6IsAoDdiBNagpPgLKl4+QYl5YIPnQDtO2y2MSwY6oNH3jSM8idmbMm1UkrCgU4We4=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by SA2PR10MB4474.namprd10.prod.outlook.com (2603:10b6:806:11b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.24; Tue, 3 Sep
 2024 21:13:54 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e%3]) with mapi id 15.20.7918.024; Tue, 3 Sep 2024
 21:13:54 +0000
References: <20240830222844.1601170-1-ankur.a.arora@oracle.com>
 <20240830222844.1601170-8-ankur.a.arora@oracle.com>
 <20240903081040.GA12270@willie-the-truck>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: Will Deacon <will@kernel.org>
Cc: Ankur Arora <ankur.a.arora@oracle.com>, linux-pm@vger.kernel.org,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, catalin.marinas@arm.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        pbonzini@redhat.com, wanpengli@tencent.com, vkuznets@redhat.com,
        rafael@kernel.org, daniel.lezcano@linaro.org, peterz@infradead.org,
        arnd@arndb.de, lenb@kernel.org, mark.rutland@arm.com,
        harisokn@amazon.com, mtosatti@redhat.com, sudeep.holla@arm.com,
        cl@gentwo.org, misono.tomohiro@fujitsu.com, maobibo@loongson.cn,
        joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
        konrad.wilk@oracle.com
Subject: Re: [PATCH v7 07/10] arm64: define TIF_POLLING_NRFLAG
In-reply-to: <20240903081040.GA12270@willie-the-truck>
Message-ID: <877cbso2y6.fsf@oracle.com>
Date: Tue, 03 Sep 2024 14:13:53 -0700
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0071.namprd03.prod.outlook.com
 (2603:10b6:303:b6::16) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|SA2PR10MB4474:EE_
X-MS-Office365-Filtering-Correlation-Id: 8eb6c39c-8708-4142-7ca5-08dccc5d5112
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VQOnrTkG/TOEu8JTwXHoLLPxrupcg+nSEFLWwBDSsf6FGgA42BPU+kri0nIx?=
 =?us-ascii?Q?tDEvwEwC7FH8TRFRBmyr4QEFLQRsJIrGc6OB3q26cpXxRgxLubRaxRVM87CR?=
 =?us-ascii?Q?3CqH7+l28P+R4hv/zsYrKE6yNTogmnm14LD8FdPKpF6ioEtI7gGhV1Sbl/dL?=
 =?us-ascii?Q?kmSD8pDLHT5SjmasbNkDZfEOKARbJbbxIolRaT3AnaTmLko+rBgruvMDUSiI?=
 =?us-ascii?Q?VKWPLU437GnSyotFRkIk1BEIOz+LLgswoIrlXC6wj5bHLpyDT6730D82tQ4M?=
 =?us-ascii?Q?G0RGKFuWxWu0f1dNZsmBFvSmqqRX8lw+h9DOssasy3i9tbn0Z50qIepvaxKQ?=
 =?us-ascii?Q?x6gUSwaknAWAviOYYOTYNwQCaQRv736+X/sRSFcG1unLywVQvj+jahQkGDBS?=
 =?us-ascii?Q?rfUVdvfyk5HVwqWU+ja6a95/lU3S3v6uxK8I9ecB2F2h8OffUhHdrqt+eExH?=
 =?us-ascii?Q?VHecP/Y1Z3onhKLhNwBG7Wr/zz9Ws24kaAKNXw418DTLArdGYj5UyhgtAODc?=
 =?us-ascii?Q?P/cXkHUiPVnO97htdiYVerNOMR5Jd5lhgiLlSdCX216uVwuvMtC/CE99hFjN?=
 =?us-ascii?Q?jFgD7ZVFwYU5te/NfRUhitJOKk1hMBMdI7D4TAqRJkoBIb4CA8B0eZqpamxq?=
 =?us-ascii?Q?obIN2omK1/KIEgST96+S7WBXzhGNMSD+2WkyOpMTbAm3epvO+LpN29bwuIMk?=
 =?us-ascii?Q?Q1LDBBf1x3WtPOdCVr0MX+46RxFghKgzQKPrxjIiqDqFDzP4cGpmc7B6zPBM?=
 =?us-ascii?Q?8xYCk5upjs4gRNZOdf77n4BlE2qHmtwbf4NJCds1Y082ZaklQz89xN4lTR6n?=
 =?us-ascii?Q?JY7EnNDgZyJ7b2daQh65TwHzA9fSrQEFCBFE0mkRhvzeQwPsf3/5a8rsrOXg?=
 =?us-ascii?Q?tgro2dQm6WXjMZ+o8Q75MLCkiUCNlUIACsdRnarE9OjsLVALseN6dri6IuI0?=
 =?us-ascii?Q?1/OYNwO1QJnNYXbPFc6UOs8GBMvD7A/6ovsmJTuNeopWcupAXVVxCkD96y0r?=
 =?us-ascii?Q?JR2It1vsWdfKtJG2g0jXNwsc3Pf2QeuonBPgy0cb5wrznjOcbEVDOSO3kzJh?=
 =?us-ascii?Q?rvDdSTtILuroLGdQdPGu9lpaCGWJpGc885ro1TNV+3i63orCZ/rUHO0Im4kn?=
 =?us-ascii?Q?wDRwB95mIr4L6vC4lY2FFqxBTw2KeKyrON1/Xyb3NX/q/mpRwtAW37VnrkJZ?=
 =?us-ascii?Q?GmettVkJrGuo+Ptg43bbufYeQOu3vB/F9xdCag6pCg6Y/GzVcEvTgFVo90Il?=
 =?us-ascii?Q?+DTYR25v0UVF2ufIoiD6UsFFZaOMR+Dh2vObNij10GGnHctThed3I0J4HMmh?=
 =?us-ascii?Q?ebPvKtxnzXQbbdcHSxLQteYKTC66h0AtGDgeRpmIqrlAmg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?u3gJhF/XNEOwS3Qo4TPAMOjSuxfTJDUNgIljDH6fX2zmR+lqK0SGiOLaviBZ?=
 =?us-ascii?Q?46SOy9DQedzcVOw72qEI/bPfVBIsZUSHjJ5nnaJvszUCvkdu19ovDfx4l5Dh?=
 =?us-ascii?Q?c50WFJJ6fG1s2s2eC1WhoQ8ZwlPmDcYGafzBv4qXvtWJmYWyHLPFj24ADaeY?=
 =?us-ascii?Q?DiMCngXmqgVhBuS2xitAAzA1KZpP3iz8RTKtyiZQFFJs1QrJwBTd3GLPL5Ry?=
 =?us-ascii?Q?ZF2OWLpzkAUPrpTk/qIL0UfWdT1c1UlkMITwVGp6A/sWLIvmFKKoyC6aO/zX?=
 =?us-ascii?Q?Rk4KVQyClJUsUHzweHoYsmzEwVK6XzB9afJkM4vScGVqiKDnKvF+2t7rp5Mu?=
 =?us-ascii?Q?t7EOV7ufgY7yzm26FCL5p9LZlUC8Dpca2Ba9hu8Y4E8BeTifDBuAMlw9Y9q8?=
 =?us-ascii?Q?O5vO7nwovR2Mq6sSfZPT6nY2zqo4IJRd+JuPD9Inuh+px/ZCIbUrC8PZJjjP?=
 =?us-ascii?Q?9qUcpi7obQQwxF1+i7lGqyYZOUPtS5wzcYhOJCp3AVtA0/pITuK5QP88mYMn?=
 =?us-ascii?Q?pl9VbK6RtXFtI7F/WULuvK3bvQ7rxUxNfdyhjoIoVc4Ekp3FpJbSYscW+ofg?=
 =?us-ascii?Q?Vxc8PBGApcD4uJCFtydTp0x+P3KLXQKxzsjqv7YcYuXIWzu1Fdr/wW90oq+a?=
 =?us-ascii?Q?kPxZ/Sq4RIp8HKbr0Cpy+3AViaH7K7htf/q2nVGI1KLDI9ydqwJXybhrHhRf?=
 =?us-ascii?Q?CUKKqtQMMSmhSQgoYu0ggPcAyOKRKkGdCgFSznUw8aF/vUHg7uOvP5Eiy2AC?=
 =?us-ascii?Q?oeRT0RI2rFtHdPIaxi32yCkKhmcz19mPGVdz3fXw+lAcu7c1KnkpS3rZroU2?=
 =?us-ascii?Q?ysfc0Lx1iz8vZNL3rzHsSV/kfHVtJqvUzCtBfIHoKtxKCdGekJ9Hk9LFi36T?=
 =?us-ascii?Q?q8U+CZfqvHZ3umDuyMa98H4qoOJKPlyRTrXnz3Q0SlQdbY8a9KR7aNIo/ygU?=
 =?us-ascii?Q?oQIOMHxnKrJ1VGDtITvhCHZf+DGakkGzVa99wodXqfPArxr8qwTQelhZXJ9n?=
 =?us-ascii?Q?J5akMSpt69reE7GHivJQFkbiSOsADrzT67z5XKK2zXZHdX0T6jQbCNnB8ztH?=
 =?us-ascii?Q?KMvchf3Lg8iT5rmkspwekIIN6uJojR470nzD23oz7o8tppVrSbrPAdSAaOJ/?=
 =?us-ascii?Q?TUJBDLkUTmiTa57+h+f6A2kPgBXTgQ8iWxK3Ob3fnTc7k3/dCOK4yq0f+4tE?=
 =?us-ascii?Q?Co1UIbPr6LjQX/UQAJrf+OuiLrug2qL6STniFrcbJfdhwltPx75NuAgoUqzL?=
 =?us-ascii?Q?uqKQoZW5rXPMbTBbrn40bCEVFpHyOSngq5Xd0f9dLWFen3jM5wZuy/tdcZZg?=
 =?us-ascii?Q?+P5PUTnXXCb3OgA0IhpJYJWrf4jKvC6JHmiW6LrgywXiwmDQnDn3U5MQ3Yyd?=
 =?us-ascii?Q?BGsqYYLzuhsAFJJJJ537Y5yh7JujYE8jO+qiPqY9AAGwNvSUsWEPBDBL+pfi?=
 =?us-ascii?Q?Cbp0rQUl+zH+x5SYXSh8ukkdjX/jL9XjIUjskq4O/glJkXzpnr21qLGXcB1+?=
 =?us-ascii?Q?9kRZxWCCoEYTpCtFk1sOiEW7lRdjFu/3LSO34bFCRey3YEqqq1tDXuEENAdk?=
 =?us-ascii?Q?BtOJUF2zBWaAegA5QUZhtp2zu3pZCvbxscAIDV0ws4gELxjkXU4dHhg2Wlmq?=
 =?us-ascii?Q?Nw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	UTUy18RjenkkEs+WHpMY7yaKgf/Snza/IsEdZhp3H3jFpv5xUjOIZS5ql2Xg/geHDj8HYqG0XpPWy2V2u+1iX27Ub6c3UlwWjHfCAvzTOiCm80AxJk0FnyK2BdczRU/L58kqpxAb4x3GEy6Q3tcEukuUzDLA8SZM0QrthGlnre5wCIZSX+UcnrSbLBXUNPQa4aCgaV2Idca/AbRh2tI5AzHs47C32kNSSJcjeOJYtgtpaHYU4556Y8cR+E3en+c9HxvDsJLHGl6Z45YdaEbN8B0BkojHS3aWVQJVs9Se7Hogak7m/l8//wkzN9hE8Or2ue7fm8V1/A7XDo3xjsvB6LQRt1B+JumqbmZSRxpiUSlpOQ31t9xVLJNbr66dsCsyKA1Yb+sl1A0/O8uokGn3AwnbU8D2uL9j1yBCMbVEmBvCh+mnAnvOA1uDa6VZK0ATwRRapgTc+shrYp2nbLWfW0sDpQWhM8xDUpsOblsEuZOinjwdA0/jUACEg1xYRywtMMvwgP9qXONshzmeuzN9yIQxXsrDm5f3DXhLSIRYD6/wu7Riy7KHsn4L9iSpX7aRR6tBdL1iJDdsb1ovPFgZCpmUrfrs3qf3TFm+csIq9Xg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8eb6c39c-8708-4142-7ca5-08dccc5d5112
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2024 21:13:54.4988
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0wHd9+winghOzZzZd8SmEwrJiss2WyxNb5t2XwbbR1byqtXzNr+M4rH6nB+Ssmcz60yOksOcvq39HvUieXuX6qHqATm34YqWnos7N/MKFJs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4474
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-03_08,2024-09-03_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 bulkscore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2407110000 definitions=main-2409030169
X-Proofpoint-GUID: S0IXPe9cqg99Ra53qj_IPTHmsfQxYfgt
X-Proofpoint-ORIG-GUID: S0IXPe9cqg99Ra53qj_IPTHmsfQxYfgt


Will Deacon <will@kernel.org> writes:

> On Fri, Aug 30, 2024 at 03:28:41PM -0700, Ankur Arora wrote:
>> From: Joao Martins <joao.m.martins@oracle.com>
>>
>> Commit 842514849a61 ("arm64: Remove TIF_POLLING_NRFLAG") had removed
>> TIF_POLLING_NRFLAG because arm64 only supported non-polled idling via
>> cpu_do_idle().
>>
>> To add support for polling via cpuidle-haltpoll, we want to use the
>> standard poll_idle() interface, which sets TIF_POLLING_NRFLAG while
>> polling.
>>
>> Reuse the same bit to define TIF_POLLING_NRFLAG.
>>
>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>> Signed-off-by: Mihai Carabas <mihai.carabas@oracle.com>
>> Reviewed-by: Christoph Lameter <cl@linux.com>
>> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
>> ---
>>  arch/arm64/include/asm/thread_info.h | 2 ++
>>  1 file changed, 2 insertions(+)
>
> Acked-by: Will Deacon <will@kernel.org>

Thanks!

--
ankur

