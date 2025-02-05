Return-Path: <kvm+bounces-37367-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BFF31A29649
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 17:28:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8F7F318850F4
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 16:29:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF0761DD9AC;
	Wed,  5 Feb 2025 16:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KF/LoWzb";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="K2TSLPgQ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 366351DD874
	for <kvm@vger.kernel.org>; Wed,  5 Feb 2025 16:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738772895; cv=fail; b=fOGL5jNd8jUTjPnBTpQD1aO2bBpmzjmKsQfk/ZBA+1DD6I3PaM75FqbtW8ln+N9Z5q1DwucgR1snqRqrsSukVqSYhgLiY8nVPhkazs0meGxWa8B1SIEw+XhxLsRoTONme7sgsevye5qxzwnbFEkAjJNErHOXH6fniPZbROaSZsg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738772895; c=relaxed/simple;
	bh=0ipZCrl2Z9Pz4hRLQdHxy9DPqEATK+J0Qce4JMGgjmA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GObiFwKd8nym9+3mZ96S2cXPCxUFySui3kInUs8vNQWcVp41YAnGYS/ES1gJWy3Fuz2ewdvr4Lvg7WPZAwvV8ZC3Y9xWIcGpzpOmcfozuFRtEbSPJ/rDWIuOyjPFgJ+lyboo8HOc97muIo7E/DTBoecRRavJCxbjgSPHKqzUlgk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KF/LoWzb; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=K2TSLPgQ; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 515GMrn6009585;
	Wed, 5 Feb 2025 16:27:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=Z3+wq/XzcvID8tnMNMx0zuwE9w7+2G9w4zLOnqs2U2A=; b=
	KF/LoWzb1zRQ44DLlwCgY6+LJjTRHBsqyddAWjtri4YN7yY7MD08KPR7A9R74etM
	xsEv7Dh221qcmKDGR6FN8lNOULYTtwKdLTPSwyakv/bQcKrZGnjvj+19afkllULT
	bIpBe8OAiH0JIemZQXQ+WJc0iiMl05Y7i8D5m4t44oAbnRQwSYoZ0EB7y9QH9tGL
	X26yCqmhdj/b7aQyPYEfDq3wy5lXyBQRvDxP5sLv2OP7sGug3NHqXqsTBrJqY13u
	jdl28FMxoKglmN6BYqO1K8mcskeAZdsiEhjWE5tXPjok6rqgM+p67t69CUs6cnI/
	7aFp3F98kbSi91E0dAsiCQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44kku4tqva-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Feb 2025 16:27:58 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 515EkMeI027028;
	Wed, 5 Feb 2025 16:27:57 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44j8fnsr5x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Feb 2025 16:27:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EwMdtebbsypk5SN8ksvzv0sog0Cv9GR63JQiMIg8viY1s3UXUqeSEClF1V2U1YMAnvybGPcCETgrEKV0nJB7kDaQBjgxPKcNXq7PdAqNrX/6cH3r/80fIlinGCWndF5mpUGKhuAVnTTkER5sqbdUon6Z3kOtHO8QkLCIgDdMcXl1F4fzHxh9NDZa3QHQsgGNqBZztFqhX4Hcs7FVY82YW0U4R9ncspsi8qiaUTOZDvbqQ+AXx/OZ163s0uHb9oUWNLQ9B3/vTP0sRAcKDkz0wd6gu8fmpnxh4q2Qku51giLGFgQKlQqyNeKBVZnjcFOTjvIuAH6NXjk4ch9YboJbpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z3+wq/XzcvID8tnMNMx0zuwE9w7+2G9w4zLOnqs2U2A=;
 b=t/gkllsryVDKko3GqCbvsP2p3REh50/rBX2Evd0WpbjMpyXU5zaG7/byKr2yvpJ1qRhgrKFZEN+Vkb8TlLjCZrHx4aWtHF09p7paX8ShAKfmAupzdKQ4DHddPrvlBOEhRKj7pHkIsJIJx+lbWbBcgcA+sJe0DYvJh6jAya94ylMSem8/zo07WkpdFXGIWn+3CJjd+ELWwXbI2TSKE8WbEH3odRkMDXGczmIfwlfGVQQWPbMJeJ1WaAihFbo1iaMNYm/1G2X0pVCgxXeiPIRbXhwxlP6+cHLNXTijgtqdoPsjxiG3l4V4s7dTSqnM8q61cwN9VJWSgfpna3Si01qQQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z3+wq/XzcvID8tnMNMx0zuwE9w7+2G9w4zLOnqs2U2A=;
 b=K2TSLPgQ0pSWysYGV648B8mlKC8VNs+5kTThnNt4SAco/3Ziw9fGZXs9JOg7Cel1FHoHA+SgZGdkQc/uf+nlsjAFkeUyjWAr6I9RUw8lJCD3TEkhkMaAa1u1ToHw9aC/SyJLGT0QcUkKUBZrOgSdo2WRLNi0nb2yyRcOyk4E0pY=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by SJ1PR10MB6001.namprd10.prod.outlook.com (2603:10b6:a03:488::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.25; Wed, 5 Feb
 2025 16:27:54 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%6]) with mapi id 15.20.8398.025; Wed, 5 Feb 2025
 16:27:54 +0000
Message-ID: <a3d7a8cc-aad8-4d98-a5ba-79fad20b9df6@oracle.com>
Date: Wed, 5 Feb 2025 17:27:50 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 6/6] hostmem: Handle remapping of RAM
To: Peter Xu <peterx@redhat.com>, David Hildenbrand <david@redhat.com>
Cc: kvm@vger.kernel.org, qemu-devel@nongnu.org, qemu-arm@nongnu.org,
        pbonzini@redhat.com, richard.henderson@linaro.org, philmd@linaro.org,
        peter.maydell@linaro.org, mtosatti@redhat.com, imammedo@redhat.com,
        eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
References: <20250201095726.3768796-1-william.roche@oracle.com>
 <20250201095726.3768796-7-william.roche@oracle.com>
 <7a899f00-833e-4472-abc5-b2b9173eb133@redhat.com> <Z6JVQYDXI2h8Krph@x1.local>
 <a6f08213-e4a3-41af-9625-a88417a9d527@redhat.com> <Z6J1hFuAvpA78Ram@x1.local>
Content-Language: en-US, fr
From: William Roche <william.roche@oracle.com>
In-Reply-To: <Z6J1hFuAvpA78Ram@x1.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0258.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:37c::13) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|SJ1PR10MB6001:EE_
X-MS-Office365-Filtering-Correlation-Id: f0c9dacd-ee2d-49bb-3799-08dd46020ae8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZlZLdlRCVFlkMmJJeDBqb2ord0RDZ0xtQlI3VmZJY2grT3FvdDZvUlV4bWFO?=
 =?utf-8?B?dGd1NktodnpHNnN1V3hJK3RTaENYdkFLZ1BQeUREbVBTTzQzaXFRbW4wYlhy?=
 =?utf-8?B?NUxPcTh4bjhpQmlhVWtHaHpPcjhxQ3ZSK0d4TEdKT1ZvSVhCWFJGbEhZZWVi?=
 =?utf-8?B?NzZjRW1ZZ1JHcFFyTHhJTEF1WE1MWnA5M0hPVStRQkFqakoyWVdDbnhHRDlv?=
 =?utf-8?B?cEVoQVBsWWw2S1RVc2szM1dudWlXRXVzMHhDMTJRRjFETk0vbVRLVTVaS3lz?=
 =?utf-8?B?Y2dNV1lUSU1VcFZpdzdpWmtDZlhlZlhCNnZIbnkrczlaaDVUZWhyckR4MDIw?=
 =?utf-8?B?ejJhUEpBeVMwZktJUHNGRUkxcjkvaGZxS1Q3VVdVSGhmeVl4a3BTTURvZllM?=
 =?utf-8?B?YkxtMnBzUlcyclllZTBPTmVTckVqRFFOVjhMQ0kwaTB6aUU1TmxmTXJEMmd2?=
 =?utf-8?B?UFpDQWZUL3p4VURUUGxVREN6a25rZmlsa056T0ZhOE1tMEphK2N4dE1VZ2xx?=
 =?utf-8?B?aVYvcFdxbzRPaW9wOHFoaVBaYlhjNmZsdE1aalVQWmRDY0ZGSHg1K3hoeklM?=
 =?utf-8?B?S1lsNFMzZURFS1ZYUS9HU3E5WUJ3ZStRYThUMmZqTTF0cFAzVVR1b2xJU0M4?=
 =?utf-8?B?amZSUlM1RXg5MTlRSlJ3YTBWa0QzU0hoSHJZMmtLMXAyeHREdVhjL1M1SC9x?=
 =?utf-8?B?ODUvSWQySWNOR3pGM25ZbVF2enJaWXUwNFNSanlUV1N4VUVxTFVXYU1lUE5v?=
 =?utf-8?B?RW5LMGlIV1BDMUxZdS9uSHdQU1JLSDRzbkgzSmF0U2s1dHVwbTBvWU5XU2xB?=
 =?utf-8?B?ZGxlT2ZKMjdEQys1QUVrYmpPdEx6UlFteXlmbExGQ2dob2lsTERUd0luUG0y?=
 =?utf-8?B?bEFMaHBpbnlMS2hVUjQwVThJSWhkVnFMTUE5VkxUa1JsUlR4WCtlbXRNWWc0?=
 =?utf-8?B?bExORU9HdlVMZ1RJTGZNa0NkZEJhNVFpbDhIb2ZtM0pKWjc2MDc3LzI2Qml6?=
 =?utf-8?B?Z2U1WEJYbVNYbzZUTVhTQWV5ZHNFaUlFQ0lTRGxINkFTenpSa2pPcFd5bEVm?=
 =?utf-8?B?aEx5eEdQUTlmUDB2c3puRFlRb2NKMzRlWFMxc3BEenhNdmxmdFFqUjdVVktw?=
 =?utf-8?B?TDBXdjBaSXMxRThuZkZDUVViMExVdmwwaHNJSXA2YjZLWjNEY0ZSRVBIL1Fm?=
 =?utf-8?B?d2FLbjBESGZXOXFVYzBKWjVMZGl2K0lHbVBYYm9MYndBeWhlbVBkKy9pLzBP?=
 =?utf-8?B?dWh3MkxFY29VNVBTRnhYTUhpVEtEUTY3OTh2aVRhUVU3VTVMWmdqWGRGZzBw?=
 =?utf-8?B?OFIraGZpT3JYRlZCNWxZcy9sYk56UUN4c1kwNGFMOXZJTW9WeWJLZmx6VHhW?=
 =?utf-8?B?aWlPQXVOeXV2c21RYURlTnR6RVlhV0N6YzZKYmMybVhRV1Y3MVowQzFJMTRo?=
 =?utf-8?B?cngxWGJwZDRMVDYySGJwUXg3K3JWaU5rMTZXalNGbDlVUEhpdWtzVi90SVpK?=
 =?utf-8?B?M2hhTkpwRGZOMkV5VkZFYkxEcmN4dHJjc1N2YWZqY0xhVjRqSCtXZGIwYVZj?=
 =?utf-8?B?U0t1Qm9RRjFNeTM3RmZYRFlnTzBHTkovN0plNGVJdG1Zb01sY1Z0dW5yODht?=
 =?utf-8?B?a3M2VTZhUmczVkJUVFhUWldUU2ZLS0NZY2hRT1M3SVpLT1J3Sm9hTG16TkdZ?=
 =?utf-8?B?OFdKMG0rS0xjVEF6SlJJbjA0anZLSDU5ZVZYQ0dwNFQyTmd6Y3NEYTFQcnhh?=
 =?utf-8?B?dm40Vjg3T2h6dHUrRWdCRHFxR3hJWll5TTg3Y1pEc1VTbmRQM1VSN0ZoYklh?=
 =?utf-8?B?N0hUSEVFZDdrVDJFOUI5NERLYkJtbGxCcUp2RjU5RWZqVDM4djMraEZINnhv?=
 =?utf-8?Q?Hu3lAwZ3XyDJM?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WHZZTjlwMnVMenpabjVUOVh4aEhoZkxLM0RvTHJCSXNBWGhBK0RPSWNMR1N3?=
 =?utf-8?B?bUlzemphdTdlZGVWSFI0Vm43Z25rRDliRVRDTDFQRXI3SmNOeE1NdHFVMTlv?=
 =?utf-8?B?VE1mMWk2ZTZkVDBmNVA0eEI4TkJ4cXNCcitXWjhDSWlRM1AxYnNWemdoTFNh?=
 =?utf-8?B?Qlp2QnIvWWlXbXBWTXROdkdLV0JTYmZMdDlNOHFQdnFiQjhrWjYvOGhwNTBX?=
 =?utf-8?B?UHNNYzE5bDZlMTAxSk1MYW1yazhjWHdXcllxTmx5bW9GMFAwd2Ewd2loOTZl?=
 =?utf-8?B?cW9LbXJ6UVFqa2FpZVl5enRsWlJjSDZzRUdQcjlMdXJOT20rRHZYRng5Nm1V?=
 =?utf-8?B?NGZGUm5hTWtuUnVvQXlHSStnRW1vZ21BcCs4elo0akdlOUNiekcvM3VJVHky?=
 =?utf-8?B?MHhsaEJqRGtDZURUc0F6Qy9qWUtZanloUURuM3g2dG9Dbmp3WnJ1VElQOUtZ?=
 =?utf-8?B?ZktiZkFMbVJZV0lMcTZxZFpVSHQ0dFlSeUtFa0NUVWs5dVRwaWNrQzdZeUh3?=
 =?utf-8?B?ZXF6RjU1VzZWNUVsWVplbythMzN2Rlp3Qkk2S3hFQkFMSlkweG5Pb2M1NkQ5?=
 =?utf-8?B?RkRhNkp4UUNkam1ZR1VGdStsWEdqUEV2c2U1SVBGZFBkWWVPdU1mMTgxeWZM?=
 =?utf-8?B?a25PUG1oRkxPczdlVDYrSGJxNjVSN1E2d25icVVOanN0bUxlenFSZmRNRzVN?=
 =?utf-8?B?ekt4RWZKN0ZTNmJDY1I3MmN3N3lIWkltcVdMeHNSMi9MTHRKaS9TektEalow?=
 =?utf-8?B?UzgzNmdQSWlIa01tdVBSMnozUSt3L0MwUklLTGV3MkRmV0RBYVZaYXZVTDQ2?=
 =?utf-8?B?UEdha0I0eXZ0TEVjZmlsQ0ltTW5PTzBKU3ZjWUk0TlZxbU1QYXhtbENiNlQ3?=
 =?utf-8?B?NUFqeXJqRlVEeDV4MjkzcGFZQkNDSTJiYVgrR1JIRlEwVUQ3RkZ1U3Y2UG85?=
 =?utf-8?B?ZWRSUnR2N2g2ZGFZejMzaDdnT3lLSHgwcTI1ZHdkVDRVTW55U2ZOdEtCUVRi?=
 =?utf-8?B?YkhvZWhTZHRIU05qdlpmb3M5R29UV2U0QnI5MWJBUUEzTDYyR0F1QlVVWC9j?=
 =?utf-8?B?ZVhCQ0o3SXUybFZDbUpqc1Jna0oyYkV1eWc2MU5yY2pzSTEzcXFWYlV2QjFY?=
 =?utf-8?B?clAzQlJ1bWNUd0thRE5heXduaDFaVkJHSGRNL1RnVXJLM1JCUkdjOFdPZXJC?=
 =?utf-8?B?REpnUk1yRitDejdBVzZPOWNsOURhYWxwMmZ5RjJRWnZWcjNwOHdUZThDVGp6?=
 =?utf-8?B?a1p1UFNOZlZLOCtXWE9wNVNNZnBBczhpUS9mditubVRBNFlGTlBYQWxudXBw?=
 =?utf-8?B?S1R3TFFYZ1hvdm9QeXRtQ1NyUHVxTVZJVE9hRGhUZ3FuRjI4dXJLR0lhOEJ0?=
 =?utf-8?B?dit5ZGJrNjJ2a3k1ZmZKUE5wWDg5SldNTTJGek1KVFM0NGhieVk3RXJqeEJh?=
 =?utf-8?B?UlVYVHRzaWJsbjMwYVZSaTFQaXhGd1QvU2FUOWtyUXh1ZDh6L1dnTXZJbXUr?=
 =?utf-8?B?Y0FlVHdIczVFdDR1eFNUZ0VWK1M5UzBWVEJxcUhBWlRKSXBhaVE0U3VsS0Rl?=
 =?utf-8?B?NS9wQzR2VDk3dXpoQ3I1OXhuSFl4SDhQM3Qvd0lNREdLck1NeHE1aEtwcWp0?=
 =?utf-8?B?cUIyZEFNQmtEaEViUVdSZUd6aTltNkZtVGk5VWFCMVpMdmhkcHRGbWVBbjdT?=
 =?utf-8?B?cC9wcllEWnlZeUJYZEtQUEYzenFFeTF2eVBHV3V6Q1pHUFRSeXRnT1J3VjZX?=
 =?utf-8?B?cmtDRGdwMGVURW1Pb3kzdDlBZDhTYWRUdjVrK01BbDNGaGwweVlrVFdsTGRv?=
 =?utf-8?B?dFdQSkN4Ym96U3p4a3NMZXcxeEJMOVhvVEhTUG1ITlJRaVh0Y3RXV0NWOUdF?=
 =?utf-8?B?SlJHeGFQWVJWSlVYeThMR1djMjJxVUYvT29WbHBLOVlxTVp5UUtQMVJ6ZHYv?=
 =?utf-8?B?SHhMa0NiUDUrM2cyc3A2Qkt5dUVvVTZRbW14ODhmMytSS3dZUm1sWTV6RUdq?=
 =?utf-8?B?OVpwMENHcHVkR244U0NiUVdhdGhRa0hhZFpEMTllV2t0VGlLRDFjbldNSEdL?=
 =?utf-8?B?SzQxYkNtMEVYMGtjMm55VGt2aFZFR3ZuNHBCbkhhdC9CeUhlZ1VIVlVycHFC?=
 =?utf-8?B?YXlDcnNlcklVWld5OURKRXBtc2s1UTB3NmcwOXcvVTJObDFrQldhM1NNN3dI?=
 =?utf-8?B?cEE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	XeCQjphZ5Qratm/AiO+1xmgf0e3Z4hRlUr8GsRDt0uhaxiuDrVikmQssRtxHNulr2YAmIMwDDumwBJ2dv+rCJ/KwXVa6xjARG1ttDfOOgtlZJH3HTMgtHxoFOQHtXXcvZ5obP3ijgi0adBGbUeRlXIOULmj7KjHHYnZqyGpR3ei2eTCtARMMD48DEvdPMCHGM/lsFh9jw9HGWNntzCyqv3wLQOwmy5T5QUU3dFvqdSUtOelc7XGiDa2O6dqkbbQrC0Kzf9/sP0/c/EvVGusxAx2/wbT9pY/ooZb+6Pj/5PrN6SaZDd9HwNQg/BXr0qJjj+borW/2Mw4P0XzM9WvAsiy7Kun/i7dKRlRIeymv9TGIdxW2/FX0fQ+HkgPY7LqWRPzgBlYd+u7ZgJm4zM1gRt26bmQvFu+HDYAnquyI3NmvUa9T0zVwoQDbnKyUxqqZQ3vrg3x5QQwBUm7q6p6kn1XzHo4NSSG6jei0tNh1oZ9jzjB/k8PJQK0corGN+FVJaZIiAY7cTkJA+tCZ9gS2IKBD+lhZBGhPoeebVj7h4XXP8j0CpHs3czqB65cogVDdK4cXeUBm/7yyOelPKAHMAVsJyrNFhSrpcRdEHs5B4x4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0c9dacd-ee2d-49bb-3799-08dd46020ae8
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2025 16:27:54.5549
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yB7Slil2Y8gNMrd0mBENKjUKZK47xE1ANHPt+OiWlOohMbPcy7af6tDoCZetMTQmah+upXrjBczDe4q3Y8CMgkZtntatDhAwh3EkbDiMMhQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR10MB6001
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-05_06,2025-02-05_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2501170000
 definitions=main-2502050127
X-Proofpoint-GUID: T2fHF81ViLURGeljuMdnj2wLlsnoGVpq
X-Proofpoint-ORIG-GUID: T2fHF81ViLURGeljuMdnj2wLlsnoGVpq

On 2/4/25 21:16, Peter Xu wrote:
> On Tue, Feb 04, 2025 at 07:55:52PM +0100, David Hildenbrand wrote:
>> Ah, and now I remember where these 3 patches originate from: virtio-mem
>> handling.
>>
>> For virtio-mem I want to register also a remap handler, for example, to
>> perform the custom preallocation handling.
>>
>> So there will be at least two instances getting notified (memory backend,
>> virtio-mem), and the per-ramblock one would have only allowed to trigger one
>> (at least with a simple callback as we have today for ->resize).
> 
> I see, we can put something into commit log with such on decisions, then
> we'll remember.
> 
> Said that, this still sounds like a per-ramblock thing, so instead of one
> hook function we can also have per-ramblock notifier lists.
> 
> But I agree the perf issue isn't some immediate concern, so I'll leave that
> to you and William.  If so I think we should discuss that in the commit log
> too, so we decide to not care about perf until necessary (or we just make
> it per-ramblock..).
> 
> Thanks,
> 


I agree that we could split this fix in 2 parts: The one fixing the 
hugetlbfs (ignoring the preallocation setting for the moment), and the 
notification mechanism as a second set of patches.

The first part would be the 3 first patches (including a corrected 
version of patch 2)  and the second part could be an adaptation of the 
next 3 patches, with their notification implementation dealing with 
merging, dump *and* preallocation setup.


But I'd be happy to help with the implementation of this 2nd aspect too:

In order to apply settings like preallocation to a RAMBLock we need to 
find its associated HostMemoryBackend (where we have the 'prealloc' flag).
To do so, we record a RAMBlockNotifier in the HostMemoryBackend struct, 
so that the notification triggered by the remap action:
    ram_block_notify_remap(block->host, offset, page_size);
will go through the list of notifiers ram_list.ramblock_notifiers to run 
the not NULL ram_block_remapped entries on all of them.

For each of them, we know the associated HostMemoryBackend (as it 
contains the RAMBlockNotifier), and we verify which one corresponds to 
the host address given, so that we can apply the appropriate settings.

IIUC, my proposal (with David's code) currently has a 
per-HostMemoryBackend notification.

Now if I want to implement a per-RAMBlock notification, would you 
suggest to consider that the 'mr' attibute of a RAMBlock always points 
to a HostMemoryBackend.mr, so that we could get the HostMemoryBackend 
associated to the block from a
     container_of(block->mr, HostMemoryBackend, mr) ?

If this is valid, than we could apply the appropriate settings from 
there, but can't we have RAMBlocks not pointing to a HostMemoryBackend.mr ?


I'm probably confused about what you are referring to.
So how would you suggest that I make the notification per-ramblock ?
Thanks in advance for your feedback.


I'll send a corrected version of the first 3 patches, unless you want to 
go with the current version of the patches 4/6, 5/6 and 6/6, so that we 
can deal with preallocation.

Please let me know.

Thanks,
William.


