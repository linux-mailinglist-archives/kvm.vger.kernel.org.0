Return-Path: <kvm+bounces-40688-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A65D8A59B9D
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 17:53:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2ACD1188951F
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 16:53:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07F4D230BF5;
	Mon, 10 Mar 2025 16:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Lv4LGama";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="C/D4bd8t"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CE43230BEC
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 16:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741625413; cv=fail; b=EQ0wSEBAT0tZKVkw1duHfBJEpVzuuMNXCpKY7fTjlYovxj8+m5suQ2q+QOrD3l+HrnEiCEzNQG132LoiOxgh3GZmneouJdzpkgpXqcjBFfxq1fAD5Hi+2GfwGdZld6fTRy9YD0u57LA0BJhc20USTNXQVVvMoCbBGi1jRDC9iMo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741625413; c=relaxed/simple;
	bh=UT1d7SARa7Ko9EDyOBgZgc5moqTsh+XBI30lxESLHjA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=gEujJXkHXpVhTw1l9RK748BZdRgdlx0GC5G4khr317Y+x81nVaVJZqkc4xosuUtm5DuPt4tcOr/xTlIhE/c64i1xLfHoCjA7ohD8gP0bo26rqn9pYleKn4Kn3IdOoSVgBm/3mpSMqWllBgenUSviWl4FxThdvlwwusPF7O8XpLA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Lv4LGama; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=C/D4bd8t; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52AGflwC009926;
	Mon, 10 Mar 2025 16:49:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=corKthlz1/pTw9P0u1QTwEOT0hGMv2RU3GQgDw94k2A=; b=
	Lv4LGamaYL27azCT9Gyzrhbcu/OeMrY7OxtvIrADgnLyae09p3LdSnu0VphwX2KE
	Cx4RWRIetnhbwytNOakQZa9WY6t40zXRv+b2ncd9OdGBhjLch3X8P4UM5KrMlo6/
	UhnhKHuaRCcmckk/GywwmenyI9fSxxtYAzbcmnpMryG1sNI4ik4xy28mkRXbyiSi
	P44WKkk6vQ7OGE7z3kVQ8kJkSpXgJkISlXVX7y9nGB5WQIXzq/GW5W5qjwW0ZmNf
	UgLjIyR4DRjE6UQI2Ps7uW3CVy8o9ls+tw+OGwIGnzRT51CVL3i7pT3Xfkf7vTxl
	S+03Z1DsuUdbDBJAsVR69g==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 458dgt313j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Mar 2025 16:49:38 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52AGZ177020067;
	Mon, 10 Mar 2025 16:49:37 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 458cb7v2vn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Mar 2025 16:49:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IzLezl4BGXuRHluuWcLvQZBSFWeWWM3m3FUHjo9i8oTy752OUZtR9pFSnHV3H/8kIe3y2hAogKMsK/gOlp71rvH4CI9DymzPqFaaAb+Exur/XJk9hQ597g+0Sm/dkEWFUpjrQx/89APwlPCBZyk+JJHUZpzWtRw2PBNrcBMUGTf5+ckk1gaLlaK6lCut5P0QW1afsRWTn5KmyO62mrMqMZg0TSPev9Pz5uCRoJqjTXnAm5SDmp3zzG8taPiyDvr6L0WYXUf8t1Z9po1OZ/8WDauEfIGzssn4RmXnK6AE1/mgEuYqL0NBor10vJVIY+TDj9RknVDW61sVyGkUYENmHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=corKthlz1/pTw9P0u1QTwEOT0hGMv2RU3GQgDw94k2A=;
 b=rvgiuWGmIR5A9Kfz0OEj5OHU9TMitQwwuabs8Vv1eQPPCm5xGEeXhB6vYwLAfG6Mv/rgFj9eVh6iKMCC1COF63Tc9eeqMcYx45TgksL1L9C8ks7qPCFKENA9t4GO+VQL8i8RHjZhLZev6O4T6Ckyw55ew4hUF9xf0InFkzdwug4J3YSC+GV3bJMTUQ+B6icCxfpIVC2JS7qSwCbPcwRt2Kr9CJjNjUpiejO4uP9CyQFBWG9SuRv12bRrGRtKQjlxj3giF/g55Wn9p+1cBW1qDLlypztXnuIGIsTBC5XP276GlObveeGLY0oSSChTW1Ib+LrAADq5hxCW5hk5DLALDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=corKthlz1/pTw9P0u1QTwEOT0hGMv2RU3GQgDw94k2A=;
 b=C/D4bd8t8BBeaFIqxl+eBIr6gekEtvDUcai3t4OWZZ9kZY8eJ5bJ4XngxJ+MIeyQzQbXLBl1arPcb/TghKu3QrRiYi69qnSktAfFKPkGaJIaWD7fLostQK6VWdejhUmKp4+9jdUrc0XMmb7G7H9v7Qv0TnzkJkD5VXx/9i/y0c8=
Received: from BN6PR1001MB2068.namprd10.prod.outlook.com
 (2603:10b6:405:2b::35) by CH4PR10MB8225.namprd10.prod.outlook.com
 (2603:10b6:610:1f6::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.27; Mon, 10 Mar
 2025 16:49:35 +0000
Received: from BN6PR1001MB2068.namprd10.prod.outlook.com
 ([fe80::c9b4:7351:3a7d:942f]) by BN6PR1001MB2068.namprd10.prod.outlook.com
 ([fe80::c9b4:7351:3a7d:942f%4]) with mapi id 15.20.8511.026; Mon, 10 Mar 2025
 16:49:35 +0000
Message-ID: <fcb79508-4065-4608-a02d-42539917d10c@oracle.com>
Date: Mon, 10 Mar 2025 09:49:32 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 07/10] target/i386/kvm: query kvm.enable_pmu parameter
To: Zhao Liu <zhao1.liu@intel.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, pbonzini@redhat.com,
        mtosatti@redhat.com, sandipan.das@amd.com, babu.moger@amd.com,
        likexu@tencent.com, like.xu.linux@gmail.com, zhenyuw@linux.intel.com,
        groug@kaod.org, khorenko@virtuozzo.com, alexander.ivanov@virtuozzo.com,
        den@virtuozzo.com, davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
        dapeng1.mi@linux.intel.com, joe.jin@oracle.com
References: <20250302220112.17653-1-dongli.zhang@oracle.com>
 <20250302220112.17653-8-dongli.zhang@oracle.com> <Z86DXK0MAuC+mP/Y@intel.com>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <Z86DXK0MAuC+mP/Y@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR11CA0104.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::45) To BN6PR1001MB2068.namprd10.prod.outlook.com
 (2603:10b6:405:2b::35)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN6PR1001MB2068:EE_|CH4PR10MB8225:EE_
X-MS-Office365-Filtering-Correlation-Id: 1974c31e-64f6-41b5-036e-08dd5ff389c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?Zi9LNC9yd3cwNHBiaHRsSTRycXc0cmRiS1A3T3FSTmhCaHdwS3p6YVBPZlF0?=
 =?utf-8?B?U1d0a3lVVnhvZ3RBaHpOdG0vaFYzeDNUZUJPVW5uREtyY2hWeHIvcjgrUnRQ?=
 =?utf-8?B?eGlDSlpEYWhJRnA4ZkZuMzlGQUhKaHJqbFF0b1pXYWQvNjVhcFRrK0o0cVBN?=
 =?utf-8?B?WSt0TW5USkJoakMxVkZlTGdvUGNxb2YyVEhNaGlsS3UyeDF2QVJLN2hiREht?=
 =?utf-8?B?ZWV3OEMyenEzajFWaDd2RFE4RlNaU1FsdE4vTjdQMmJaMHVXYzU2ZjQveE9Y?=
 =?utf-8?B?YU1qenZYSHd6R28wS0dYL3gyeVNINHlwa1FFZFl3N3M3NFF5YnRwejluZWdJ?=
 =?utf-8?B?VGJmSGtZdmw4Tlk2cHphR3EzMTEzM3l3WllTd3V2b1JJSUFCeG9QbTB4c0Rl?=
 =?utf-8?B?OVdZN0tvb20vUXZPZUIwMURXYk9aNzdOeUs4aE1xM1o1MDJ1emgwWEtOTWpz?=
 =?utf-8?B?WWkrOGR1U2dCWnBCRXJTazQ1K0UwQzV1V1M4TWRJVVZXRUNsWTNkS1BmMDA5?=
 =?utf-8?B?WHFPQzV5bTRBYUxzZ3hzSStKNVFVcWNobkt4dU5yd3hUb3V3bWQ2T09wVXlo?=
 =?utf-8?B?dWY0Yzl3WmJwODdBblRuM000L3ZCQVpvRzdRb1M1aEZRbHMzTzhxQmd5MHc2?=
 =?utf-8?B?cDZGYkZKVnBNK29PVkFMYmF6R0toL2czcnBLeEpYYW9aNi9wdjVMRlZqWUd1?=
 =?utf-8?B?ODlZV0lvVHBjQ2hXcWVNd0ZKNU5vTFl5RjNnVFJzTU9vdGR4SDkvSjFCNWdU?=
 =?utf-8?B?bzByaVZudGI3K3VQUy8xRktla3NMVXFZUGsrSUh3dExuR2FKQmNTbUxZMjVk?=
 =?utf-8?B?Qk9qclpWYyt4RGdRUHZKTi9xN2JpMlJwaGMyVXhDZ1BJZmNHaDgxdUU2ZGNV?=
 =?utf-8?B?MTYxQUc1Y3NsaVQ4QncxZFlDcnVWYlllR3I0K3Z0MVQvMVhybGZRQTlUY0Jk?=
 =?utf-8?B?VnBnK2orYVd3aHByb2E0UGJZNnplUFpVTjVTYkdIbUxrU1o5aDMwQ1FOeW9t?=
 =?utf-8?B?V3JUVGxZaVprYVFXVHdlWFVIcFRCL01XVC9uaHIvQnBaNTZWajRLKzhncWFt?=
 =?utf-8?B?MUFqUEhtSjZURklGdGlhYTJSZTVtWkVKVVgwc3RFYlpRV0Njek9qMG82OWNI?=
 =?utf-8?B?d3JxVEdLRHlkZjRFUGQwWjNEUyt2NkxMTUhzdERKZVh6T09qNEwxM0ZsamFQ?=
 =?utf-8?B?b0RabTBodTJzNzhOSGN4NUhUamVrQjQ0ZU0ycUY4bURPSFMxck5ubVdNQ3Nt?=
 =?utf-8?B?SVNHdDJRcE9TNm50b1Y1RHBBRlgwS1cwc05sR3pkalJlNjAxd1cwdy8rQVdS?=
 =?utf-8?B?TjhlcnJrWUF2VFhlbjh1OWFRTnNQa1htZGtvbDBCQUI3Z0N6a1N5MTdWYXgy?=
 =?utf-8?B?N2JlSi9jQjBxN2ozMWx5ZE1lTll1NXFuaFoxZkVhWVltS2pUbmFMOHNqd0FI?=
 =?utf-8?B?SHVyc1NHRCs4OXJzSWlLV0NmZnpCenQ4VEI0OHg0KyswSzdESUQ4S2VCRE9u?=
 =?utf-8?B?UUJVNHN5NFZ6ZEFPOGdzYmUxWE10VjZBZmNkNGloaWpIdjVJa3ZLZ25UVUpH?=
 =?utf-8?B?L21tTnpqN216VUJUV0FrMW4wRmJ4VXo1NUJLVGZscjdSQ20zcDc4V0JON2hn?=
 =?utf-8?B?cEJQS0NucjY5WFkxaHgzVGxpOGVONVg4dEhqa1poeTRLaVVkUkpPQVRUS290?=
 =?utf-8?B?UjlEK3Y0cWFCMWVlRVJrLzRKR3dYTW5rRlNCeUFDOENicktqTjZBcDRpcGda?=
 =?utf-8?B?b0lMc2h6aXdQdC81eTlpNmVkSFNIOG1WQytTcUZMVlBYUlRiTm5iTlYzTTMx?=
 =?utf-8?B?QWFKemp1S05TNzBkVUYyVXV5SVRMT3FDMWZRckhlR0N0Q1lwVzFmaWR0Y0tl?=
 =?utf-8?Q?f9ysWYvfsRBlJ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR1001MB2068.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?anhmRlFjTERqZ0p0VUlLRHM1M084RzZmYnhVdm5RRUtvTWtsZTBNaVFLL2No?=
 =?utf-8?B?ZW5PaUc2eUkwVUFZSGV3VHRyYzk4dkRoRk1pUTU4UE9rck1WVUFiVDAxcVV3?=
 =?utf-8?B?clpYQ3lDM1lMRWFyODhsaXNRc3EyblJlYkFwUXdPSE9XWXVLT29xb3cvOWkr?=
 =?utf-8?B?dVZCUUlJdlZET3hQejd3Ym5PNjdaOXpTYm04ZjhNWXU5NmVxTjR3Z09NQjhJ?=
 =?utf-8?B?OHNnTGtZRUsvTXN4dEVQVGlKWHRobXlpS0o3Y2NnV1F5NWo2WkZaRWxzTUJ1?=
 =?utf-8?B?bG1Sd2Y5Q2w2c1dHTXJkS2FhZy8xWHlYWWRXc0ZkL09pQk4wYkFPbGJXb2V1?=
 =?utf-8?B?aGZibTFpV01xYk5uTUtDeVdQV01hQWYvYXJtelZDU05qdmZBRUVyODJZdjZy?=
 =?utf-8?B?QVBlTVVEOUQxaDE3VnZSeWw2MmJaKzI0UUFScEhKT1d1U2Y1d2VIZnFGYTBz?=
 =?utf-8?B?MzIvUFdtRkc2cmRNWWlIWU9zNENpWmJQTi9vbFQ1VmROYUUvM1l2RENyMTNn?=
 =?utf-8?B?M1k3YWptNERHMVRKZktOSkt1Z2txbE9hSFBycjIwNWI4WENZNzB1UzY3MmFM?=
 =?utf-8?B?Vyt0TEMyTU1NS3dFaTg0b3FnQUNVSnI2V01SWWc4RnA2K0YvK2ZDcndQbUJs?=
 =?utf-8?B?VnlWN1B5Wk55a2dqT1hialR5cW1sT2Q2U0hiTDRuVk1HWWpKMVFjZ3BubUM1?=
 =?utf-8?B?QmVHcGlVMWJVdnRtZlc0blNqbnZsZExVc2FRVTlzWSt4VHlZaXYrL1hVVCtQ?=
 =?utf-8?B?L0R4TmFIS3Z0UUlPdldOamVCckQzVUZDRXBBY29rd0t3RTdZZ20vMysxUHhK?=
 =?utf-8?B?MkJjSWF5ZHZFb0lOamNOZVB3TWhTbjZYbEd6Vm9HbXJ4N1pWa29ocmNrYWNW?=
 =?utf-8?B?cjVZL0szeXo2cHRtWXpCKytTcGZzdWsxMHBxYTBOL1NKUnhmblZjSUgzRUxZ?=
 =?utf-8?B?MkdvTE1yUUdUQmJNTjIxc1JOb2dTVHlCOWhlOHdhcjlhL0FReXFjcUNsa0dx?=
 =?utf-8?B?NElJTFkvMFdPT1RYdjVvaDNsOVlQWG1SZ3lFTTN0QkdCK0xUVnNGNUhiRzhu?=
 =?utf-8?B?YU1paFNxOW5aNFppbCt5L256SE5NODlFV1d6dloxb3pqS2pjdGNrVGNSektY?=
 =?utf-8?B?UTYrVnlRN1FVQWxrZDNjd1QwWnpyS0ZtQlFTWmRkRjZ3R2xBZmRoQmpuWlpL?=
 =?utf-8?B?aFBMWG5OSnl3U2grWE9lY3hhTWJPOUhRQnQ5Tmk2Z0l2UnpGUHNETEk5SVgx?=
 =?utf-8?B?eVpMRkZlbklpaVlMcFkyekRMUWxnbm85bXFxSjd1L25CanRZNkNOS0VxRGp3?=
 =?utf-8?B?UENCSngyQ01oU0hhSjF3NDFPYkZoQ3ZscWNhR2NpZldZZGJENjZocytJbkdN?=
 =?utf-8?B?ekVuWjhwVlg5NVp1bkN1OFMyVkZJbFc4VzZHdmYwSW5oTHgxM3JWTkZlSUNX?=
 =?utf-8?B?TEFDQmVtZGVaNit5NFQ0VCsvWDk0YzRld1hmUDkyYzgyNXkrU1ByM2xDeDJU?=
 =?utf-8?B?dFpZR3FVQ05FemdyU0N4T2hMd2RXd2tDWkZuN2t4TkZ4QWtVN2ZQazFuaGJx?=
 =?utf-8?B?eGp4OXVvU1lybU9aYWdYSU01M2JDVmxyWi9OVU5PLzA0cUhXWURLeXV5M2NV?=
 =?utf-8?B?bWpSUGR3aXBvNWNkL1F6eUREL0ppS1RCdVZnR0ZvVjUyVGd4dEJtNjRRZlUv?=
 =?utf-8?B?dnplTjNNaVUzaSs4eWNQT0lOYWVacWkvTVJlMldFcjhQVzRoQjgycDl1Zzg5?=
 =?utf-8?B?N093bnVpeWh2ZnREUEV2T1BwVGE0RCtEbXRaODNvVXIrYk5sVUFxTDJWclV1?=
 =?utf-8?B?ZHh3RlI4dWE0bmQxcHIwek8vVFRhOGZpOTg2eWZsSEtleWJ2RTNwQSs1Vkg0?=
 =?utf-8?B?aWl6d3lIUVdxSE9IdFg0dDJ4UE1KSnpaenM5WGFDOE5FYzNVVnZrN1dzcmdr?=
 =?utf-8?B?cUhMZ083SkFWZzFvd0pFZHIzMFZFUXVOUXFDOWtXdG1CRFpEYjVCbmYxello?=
 =?utf-8?B?elhScWdmaE5qWkJzT296Rit2Q2R4Tjc1L0NFa3NFK1IxRVNta1pDb2x2elNn?=
 =?utf-8?B?MmtNNzBpL3pzQkp3cWw0dHFDQ25lUE9TZzFXYms1UWFxMm5IcldJeGtjcW9q?=
 =?utf-8?B?ekpLRTZnK1AwVXNWSEhiTnlSY1M0S2JzN21aYzVvMXlaa1BmTlhEcHV5OW8z?=
 =?utf-8?B?SGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2o3K7PPz7YnQCDqy2zyCH4v2WgY/rG1ny4nLSZqwFsnmG0LV5bhg8VEUpeIL8fMx0SbhQ2PmRfOTw4Ey/JaXigy+Hjln+U776fMJbHn0PTK6X/Yhnh/V9A8pbIbMbXN175iEr8f4iPE29h/W83GZW+bsmgqlU81jWsioWAUlciWwR5k0F6TF5SPPIylDnVnrFn1rIOyw9Ys2SXnlGfA5Oguncn+j73AqonNJ8LK4fb+Gh8CVfpyb7hdxurX8nt3XyjASdpJQPDd9egSMPa9wKQZwRLUyi9CKzF/D08wKfyLIo9ScDRmP01W5Za40XS6USW2CY8KOtEKKW8S0fgZof1qmTTJFTgBgJycs0QIqFQqni0VbkuUp6kiji985LX+dfeuoq3cqmVVAEPc0wxNq/T/WwkKn6oWXcU/CexX83MGau13Ylg7SzawZ+/jXLFfPrtyJY3fuV0rW8h+1O/mMFMOtuwn7b3Hp7joXcxdbLkKHXarzbdlfYkImmO/57pbBTVh2iABOgPgVib4PmBQjZSO8Dz4Qn8phehT6QLHm1z7vXGTfuPk3FGDni+6xhGfRsRNoBAhusEQ9HF3vNtUiy42AKLll2Iec+rJ/AJ5lyVo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1974c31e-64f6-41b5-036e-08dd5ff389c7
X-MS-Exchange-CrossTenant-AuthSource: BN6PR1001MB2068.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2025 16:49:35.2041
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /or0RVjBKNjR79kxTVWkMlGBrOfxT6PUGFp4depzvIyzsswWK+ZyiiSU09kfSwsZUMwtXsxOrn0hxhHvDgVd/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR10MB8225
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-10_06,2025-03-07_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 phishscore=0 adultscore=0 bulkscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502100000 definitions=main-2503100131
X-Proofpoint-GUID: -ujJsDxegJ2mV-sGoB7IOIrQi1ofwwjM
X-Proofpoint-ORIG-GUID: -ujJsDxegJ2mV-sGoB7IOIrQi1ofwwjM

Hi Zhao,

On 3/9/25 11:14 PM, Zhao Liu wrote:
> On Sun, Mar 02, 2025 at 02:00:15PM -0800, Dongli Zhang wrote:
>> Date: Sun,  2 Mar 2025 14:00:15 -0800
>> From: Dongli Zhang <dongli.zhang@oracle.com>
>> Subject: [PATCH v2 07/10] target/i386/kvm: query kvm.enable_pmu parameter
>> X-Mailer: git-send-email 2.43.5
>>
>> There is no way to distinguish between the following scenarios:
>>
>> (1) KVM_CAP_PMU_CAPABILITY is not supported.
>> (2) KVM_CAP_PMU_CAPABILITY is supported but disabled via the module
>> parameter kvm.enable_pmu=N.
>>
>> In scenario (1), there is no way to fully disable AMD PMU virtualization.
>>
>> In scenario (2), PMU virtualization is completely disabled by the KVM
>> module.
> 
> KVM_CAP_PMU_CAPABILITY is introduced since ba7bb663f554 ("KVM: x86:
> Provide per VM capability for disabling PMU virtualization") in v5.18,
> so I understand you want to handle the old linux before v5.18.
> 
> Let's sort out all the cases:
> 
> 1) v5.18 and after, if the parameter "enable_pmu" is Y and then
>    KVM_CAP_PMU_CAPABILITY exists, so everything could work.
> 
> 2) v5.18 and after, "enable_pmu" is N and then KVM_CAP_PMU_CAPABILITY
>    doesn't exist, QEMU needs to helpe user disable vPMU.
> 
> 3) v5.17 (since "enable_pmu" is introduced in v5.17 since 4732f2444acd
>    ("KVM: x86: Making the module parameter of vPMU more common")),
>    there's no KVM_CAP_PMU_CAPABILITY and vPMU enablement depends on
>    "enable_pmu". QEMU's enable_pmu option should depend on kvm
>    parameter.
> 
> 4) before v5.17, there's no "enable_pmu" so that there's no way to
>    fully disable AMD PMU.
> 
> IIUC, you want to distinguish 2) and 3). And your current codes won't
> break old kernels on 4) because "kvm_pmu_disabled" defaults false.
> Therefore, overall the idea of this patch is good for me.
> 
> But IMO, the logics all above can be compatible by:
> 
>  * First check the KVM_CAP_PMU_CAPABILITY,
>  * Only if KVM_CAP_PMU_CAPABILITY doesn't exist, then check the kvm parameter
> 
> ...instead of always checking the parameter as you are currently doing.
> 
> What about this change? :-)
> 
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 4902694129f9..9a6044e41a82 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -2055,13 +2055,34 @@ int kvm_arch_pre_create_vcpu(CPUState *cpu, Error **errp)
>           * behavior on Intel platform because current "pmu" property works
>           * as expected.
>           */
> -        if (has_pmu_cap && !X86_CPU(cpu)->enable_pmu) {
> -            ret = kvm_vm_enable_cap(kvm_state, KVM_CAP_PMU_CAPABILITY, 0,
> -                                    KVM_PMU_CAP_DISABLE);
> -            if (ret < 0) {
> -                error_setg_errno(errp, -ret,
> -                                 "Failed to set KVM_PMU_CAP_DISABLE");
> -                return ret;
> +        if (has_pmu_cap) {
> +            if (!X86_CPU(cpu)->enable_pmu) {
> +                ret = kvm_vm_enable_cap(kvm_state, KVM_CAP_PMU_CAPABILITY, 0,
> +                                        KVM_PMU_CAP_DISABLE);
> +                if (ret < 0) {
> +                    error_setg_errno(errp, -ret,
> +                                     "Failed to set KVM_PMU_CAP_DISABLE");
> +                    return ret;
> +                }
> +            }
> +        } else {
> +            /*
> +             * KVM_CAP_PMU_CAPABILITY is introduced in Linux v5.18. For old linux,
> +             * we have to check enable_pmu parameter for vPMU support.
> +             */
> +            g_autofree char *kvm_enable_pmu;
> +
> +            /*
> +             * The kvm.enable_pmu's permission is 0444. It does not change until a
> +             * reload of the KVM module.
> +             */
> +            if (g_file_get_contents("/sys/module/kvm/parameters/enable_pmu",
> +                &kvm_enable_pmu, NULL, NULL)) {
> +                if (*kvm_enable_pmu == 'N' && !X86_CPU(cpu)->enable_pmu) {

BTW, may I assume you meant:

if (*kvm_enable_pmu == 'N' && X86_CPU(cpu)->enable_pmu) {

not

if (*kvm_enable_pmu == 'N' && !X86_CPU(cpu)->enable_pmu) {

That is, return error because the QEMU isn't able to enable vPMU, because
of the kernel module configuration.

> +                    error_setg(errp, "Failed to enable PMU since "
> +                               "KVM's enable_pmu parameter is disabled");
> +                    return -1;
> +                }
>              }
>          }
>      }
> 
> ---
> 
> This example not only eliminates the static variable “kvm_pmu_disabled”,
> but also explicitly informs the user that vPMU is not available and
> QEMU's "pmu" option doesn't work.
> 
> As a comparison, your patch 8 actually "silently" disables PMU (in the
> kvm_init_pmu_info()) and user can only find it in Guest through PMU
> exceptions.

As replied in PATCH 08, we may still need a static variable
"kvm_pmu_disabled", in order to tell if we need to reset PMU registers when:

- X86_CPU(cpu)->enable_pmu = false.
- KVM_CAP_PMU_CAPABILITY returns 0.

If (kvm.enable_pmu=N)
    It is safe to skip PMU registers' reset
Otherwise
    We cannot skip reset.


Dongli Zhang

> 
> Thanks,
> Zhao
> 
> 


