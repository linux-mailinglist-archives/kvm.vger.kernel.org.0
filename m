Return-Path: <kvm+bounces-25571-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B7A98966C62
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 00:30:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6ACE8285014
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 22:30:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65B7A1C2331;
	Fri, 30 Aug 2024 22:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KnqxjLDk";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ZxOXTOmf"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 604DD1C1AA1;
	Fri, 30 Aug 2024 22:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725056987; cv=fail; b=DkuS0RP8JFUIhMxkgtNgEu+AtXZqvJOUYvjbbihqlIzG/QCgynuen4JR4UUT3y04633HUHbquvD5JlajlZ8RuD57NmSrz/bAD49ZDaQRjOvlIRkj86s6fDE2ZctW742KKijrKT5SqkG9rRorUriYADXpmrWS+4tfIpRQXrFIcLk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725056987; c=relaxed/simple;
	bh=4IYKO1drliRDArGIvxKJW7I0De/keZ7AduscTuSMZvA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VFRqAuXkbxFonkuzz8RjfOPZ4MpYu/0uG+1WDvrpwr6mGf6zOrGWvtPhZovHCYALBlMozjuTzDQDa1yEAfTV+nY4PHbwwhq0xV+LBoyhY/apZHqnIpEhiICvPBP8DEq9ww3vGufS4i85CeydOsciUoZf2b2qgAQtVOrXVeMqHBA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KnqxjLDk; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ZxOXTOmf; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47UMN9M3026792;
	Fri, 30 Aug 2024 22:29:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=kliPzWWUuMlufLMM95mgrWmmH+qsRRLUhf6/KNxnbbM=; b=
	KnqxjLDk1K7JasvtrxBXSMcTLYX9JXPbmUcPX6cCGnjVXYnOaIwfpc8FAty7251T
	JUpi6pAz4CBikCsU8IE4b35bMpZykhbK8jJerk+eCzeakF0t6eDe0wK/sxb5Chn3
	aXVzD+0VQNuUPECmC6XDEWkTwkhLfLFq92XlKlhqxxJCbewlos7odxKjyhjjI+Vn
	Lo4UvSW86Ow23z7e8j2kR2bGeUwvUXDZVAJs67CEo9xt9EQaV9ZSGE7kjzHaKnjw
	iqrj/ZFiRbL9HTn05XGWt29bwiC8gs3RE1qeFAVbQQqp7tdFNMVfSz1lcKi2G3cA
	/evWG/tzyZD/lVfsnvXA9w==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41bptkr071-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Aug 2024 22:29:08 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 47UL0MkW010631;
	Fri, 30 Aug 2024 22:29:07 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2042.outbound.protection.outlook.com [104.47.70.42])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41894sjas2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Aug 2024 22:29:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OAOFpb82/8Epd4WXf5Zu6/We1KFQuFt6uq+2OJLeRseiYtsXiG7JmmqTFvLjkJliXZli8QkHq5BOoGUDxNNrWTWaZ4zYZx89z80r+KTKEPRyvdG2+A/cUGGX9qbnGkYK9cBaYbn4v1y0yvuiw/klTw68N5dv59KR9szLrVAUoTsKX2OUFfsDq3Dd0uv4CYNuWELbQp1/b1DDC3R+5usiDehxXM3JIxxdzbdfKRxNv2jEV8Xnz++lFpdlgPKUHF7tv/Ups/eSCDB1Ufwn3njqCSaTROeQoAls77ptY+Xc1SWIOMzXA+alrwZvbNSxqZyAClpvx9EirLLqpVyl+LT8Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kliPzWWUuMlufLMM95mgrWmmH+qsRRLUhf6/KNxnbbM=;
 b=CprRvssz7QlTPBQ1oREBy3O5O1CMweKAKg2IUqhxrN9/MhhakmpA8QymTUDO+iiVRtYTne97q96cnpFAvF0bD4C6ts+ukLKXQJppqWT5hpE6afmWPKI/ut4CFiwUgPIWxUsxFhTs2bnZmDZg59AiopkVVmZRks03RsznnJaR5YDLFzLZuspQJq73JmibEk+2Vd0bYTRFFNoOmNFHwrwnT2RBDRl5t29Ey8LJWmqieFgC8qH8SDO8HtjwcyMvv5g3g4fp+HBpXt1IE8yA13sGLsA2QipEEZhcJvlhO73w46GqzPqGc9WgMZ32L9643waL4kExROJ/0vYcUjNNhecYwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kliPzWWUuMlufLMM95mgrWmmH+qsRRLUhf6/KNxnbbM=;
 b=ZxOXTOmf5k/tX77PPkjCczF0Y0n4b6cQUHvJv7ROrVpNyWwp27eMg/UZhgCBcdh5uE0GdoHKnF/MEWIPNhJbZ+ilV7WDZF3OXVmP5NJNFFwIWgnHlxsX7KiSUKUg1ZednGn9SM+1dTHC+Qqd1X76WQ8GzjP5VxMVOEFfZjmHk74=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by BN0PR10MB5077.namprd10.prod.outlook.com (2603:10b6:408:12e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.20; Fri, 30 Aug
 2024 22:29:05 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e%3]) with mapi id 15.20.7918.020; Fri, 30 Aug 2024
 22:29:04 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-pm@vger.kernel.org, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: catalin.marinas@arm.com, will@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, pbonzini@redhat.com,
        wanpengli@tencent.com, vkuznets@redhat.com, rafael@kernel.org,
        daniel.lezcano@linaro.org, peterz@infradead.org, arnd@arndb.de,
        lenb@kernel.org, mark.rutland@arm.com, harisokn@amazon.com,
        mtosatti@redhat.com, sudeep.holla@arm.com, cl@gentwo.org,
        misono.tomohiro@fujitsu.com, maobibo@loongson.cn,
        joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
        konrad.wilk@oracle.com
Subject: [PATCH v7 06/10] cpuidle-haltpoll: condition on ARCH_CPUIDLE_HALTPOLL
Date: Fri, 30 Aug 2024 15:28:40 -0700
Message-Id: <20240830222844.1601170-7-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240830222844.1601170-1-ankur.a.arora@oracle.com>
References: <20240830222844.1601170-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0056.namprd02.prod.outlook.com
 (2603:10b6:a03:54::33) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|BN0PR10MB5077:EE_
X-MS-Office365-Filtering-Correlation-Id: 691351c6-8196-434a-271c-08dcc94327b4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?iq9pJGXsy7CS3SkUFuHbUA7/5uUv9dE8lx8cRG7UXu2h5UVeqp/I7F7jgOz1?=
 =?us-ascii?Q?ujexk043qW0J6/wdwP2QN7Vnug03TOeWr67eCSFrRnFs/zidz5cYgHD32aRE?=
 =?us-ascii?Q?j2wlySQrrct3LO7rcAf4bhWToclmQnfbSruAkfWtr/CSLkvdOamWeBHoQL9k?=
 =?us-ascii?Q?+i/8leOjgYQI90s3SpVu2b2eBNCceLIvYTrSJxpo4YISRqHTppbbpPk9hEoq?=
 =?us-ascii?Q?uZYK1QhqUlb4DHNuEaq9IZBnLMgUPhEepgfUYvVazDIZ99hrwZhhOT53pFIW?=
 =?us-ascii?Q?BYfwmtJCcuX0V+JSm+tVXmwdLnlxx6RZLA5txqDfGUWRz+Gd1TnTeDggECu1?=
 =?us-ascii?Q?wRu41+d/qXbftHImJ6a1Cbv/YocmkzzWC0EhSJ9jjyRSOu8YhFmOx8UNrfgA?=
 =?us-ascii?Q?dPV9fxJk3r/k39Z4YdDcGm99WlIryUT8CYQgvw6hdE3KehLX9wNzW3qnU0fq?=
 =?us-ascii?Q?KVS/mw6lwBwHvNVpKZd37Qe35qxhYOA6Ozo+EVtaVaBO/3kpw+C+s+uAEw8T?=
 =?us-ascii?Q?r+oDHaIArBVKX9X7HG5r02zhjHKCRNYqjwUq9Ak0AyNIchVUWqyhYcZT7Vzg?=
 =?us-ascii?Q?FgDIhZXVBzy+OUQKqnNzTFUk4raqnB/iQpFnWpzwmW9Ce4r8+SfyQo3GPgTT?=
 =?us-ascii?Q?lQs5RHe2SQ8tilojLEQVKqROq+Lq80XIV3lzq+h0351R0ORtNqDg397GK9MB?=
 =?us-ascii?Q?IlsWa7ewigllKC99UPtVfqyrr/rFt3Mhyiz/CxqaiETrcytYck8dnuSJQ/QK?=
 =?us-ascii?Q?V5M/NnLt1+ycOFZ0dhQxwZteZyJNxaf72bONOQYZB/I8WFQmN6sreJBMRy2I?=
 =?us-ascii?Q?N9/V1X3XRDdM0qwAqJ6MIKFBTGYkqiGKYpECBN689qU4V6VRccb3ptnalJAW?=
 =?us-ascii?Q?HuyTPgst9SuM5L+Hkmwkw4/2BeOBc746oZUxFPgW2OHSd9ZRyHtc/aZalNVD?=
 =?us-ascii?Q?hxEZLpeNFxqsvgs3TvDOEAAPVMsxu22SUCYTN5mKnCGpnwpmAsM5YaxJagGH?=
 =?us-ascii?Q?9qVxXzcCeSWIV35biSN0DAnvsEUjzrhGPlF0BF31ne/22wM9BrbTkqJ2mBLf?=
 =?us-ascii?Q?m4FbCVv7Bekt5G+2XHY3HxCDdBl9kfeHCHezWxJ3Bxzjf3vpACuEK56cR9PO?=
 =?us-ascii?Q?AXQE0oj2IPmuuuSOPoTfL+dVFqbsGAIQ23fNV8m5PWdBKkq0RSti8qkkbyUd?=
 =?us-ascii?Q?r0eioqISqZG0IbTRKAh16JtSLy97g6li+Dx0/6ckcBwABHRKjVlmJFOiN62R?=
 =?us-ascii?Q?pA+d3uqOmqDQ1XI7M+h8wCAvvTFtWZOJPoUQnxBEdeKghcESUbxEwyFTFK70?=
 =?us-ascii?Q?5E8TIIeN1KW6QuF5WrFYHxKHIYyfSh/owFqGl4pUDy3fVw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GSW8F9IH+K4UCb0iTw7wQxtC2o5cVFQu9Wre8+EdLclJS8b2D5+FuAFTY/zK?=
 =?us-ascii?Q?XAuQ3u1OPxwYM/b1fyj3DWkzmN3eWkwLS1WU6l/9i7b4ilc/SSTx9V+CO/zH?=
 =?us-ascii?Q?bgjM6Jsm4V8/ASJ41bY3UEMWy2tVE9gleyoGS9S1Z2F0uevWvSboRaB0Sazf?=
 =?us-ascii?Q?fuq5mSNvZDuqYu9QZIZOZb9LvU/GDCIFBCcWCvFrBAnCXXRuRFn1OUP0WrkX?=
 =?us-ascii?Q?gAb/D8OkTns/IiwmwuHXSG1y9lUqrhUYVMfZwk8N6/kBtEPizj6AoDp4syRW?=
 =?us-ascii?Q?13ed6YsPB0/GnoRTLUy2snCJ54yvQrFibzAEDsmDQ7Fr7urvM/eMoLiXDa5E?=
 =?us-ascii?Q?GWADGqYf4JL95lANPD4Kn184D1m/9OZ7l7hWUR1UTXJskleClIWGZQh1nBDr?=
 =?us-ascii?Q?QxHu3JZTZUsD+GjNWDUJgU+U3+SCnxFMSgeiNVlAB4ildD3RY1yN0ePUxC9O?=
 =?us-ascii?Q?MOEI9kIo+wtA8rQ2HJuF793x4ejHsC8ovp+s+N49NjUq+dDpZxBsunUA2133?=
 =?us-ascii?Q?Yvu+Zp3tywnsJbVVJLHW/RJCxI1o1GOkv0kPrNo8Trsvt/mDnFAC70lJk4yP?=
 =?us-ascii?Q?315Oq8gQ7VSmCpBrGBa8MY9rxEX7nBU3iYgmAxcoj58Fg5NimCViGgFazvio?=
 =?us-ascii?Q?B3kriGpHoqRLaNNWNBW+mm/dnALfeJ4bY40nzIFhJVQBHOMMBw6HGTTcsUPZ?=
 =?us-ascii?Q?qd0n7iEse0lIkpxnHIuqK+i1B66sG0tWJ9bc+F8HS6/AHtYhlsGG5KSawRKc?=
 =?us-ascii?Q?ETH+xBmGhIHO9sULKA+DcTp3/x5mShb7iHBYSlqvuvQiPbdl+P043PMzJ9tB?=
 =?us-ascii?Q?SLjBKmVsQNjbeMwENzHhnALknawE6AINWIh4kPcEcsj4vTgzt1aweVPTJ7yD?=
 =?us-ascii?Q?/XVAz+/xDIFjYbx4Dux6MjKL+DFaoUfPMouR8NA2xS4TN9teJFERkubNSJHB?=
 =?us-ascii?Q?NQ0+RNudZrexxf+080iePyHbsySKUahDUcayV10HU9fyFGoj1YEwFGT9tC8T?=
 =?us-ascii?Q?pjOP3sF3g3VraFfQHvzxV5Wm7Uy7LutdMI8h4rSeuCYHwTjwN+pYZLzID3o3?=
 =?us-ascii?Q?J5AaXPXFPsVcxIWwm4KCYu3TVcC0slS5cPICT3EVuc4Y6jLRRDnpIay9v0Ky?=
 =?us-ascii?Q?SUTzMUvOOQb1670WWlKQPDtLQcK4vjqcA2L/AK/taN2uJFRzSHfVQJM2zXZl?=
 =?us-ascii?Q?zGYQ/LbUfQlp7z7ecIFw6dHTIoDi9gRqWLOlkKf5ZoYNZfYaSGaN42Q/i8kj?=
 =?us-ascii?Q?hJScHuh3BpaZFgrbJhIgK8SgKtk808RIs6W+cV8gfj1Rpi00lI5GXGMp4658?=
 =?us-ascii?Q?ALbxa+iNLVsTUNU+kWZV+KqNjxVyW0piS7fX8CSi79uuhjIdj8G0SB4fNBxc?=
 =?us-ascii?Q?HAetp9lXtFFVQ9yheYKkjXjkHScnxohXsFVv9bFNLxjmmhzMlpTLxDY8NBsa?=
 =?us-ascii?Q?KUEnlro4vfyGG4rkAdllrb9AEGIt63OVxKy1Xxh2KBzeVf8440erjjK9Vmyi?=
 =?us-ascii?Q?QSrGC00ncgio1ZjmPRdL6I59wBg/UxswLlcemMlOKfx5IgAyIYzanClPMTKb?=
 =?us-ascii?Q?2chAEP4gOXpfPQUZrSboL0JGRG3NapkIhRRwOoE1ofUMUtf7npVI+fJBH97g?=
 =?us-ascii?Q?cw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6y4P4ORl5ABRG04CmslTL1C9e8Bt5Kw1XegAMYeWT8miwMF86s3/OEc0wPjFPdK+w1MUVhKU7GLhu7swv/nFqQ2iSJ9q64MmnI8ZsGWoNm7grftw8njmkexXpax44oEeHtXwy/E82srAHHokZhVPtF/e0vKQcwrec+ebNieK8yrmcTeRcPsgaiLhDQjukau52eqUq3ryLzn+LMsVrZfoPT1NwW+m987pGiGEury9PPJ1ewZPrG6FYq0nPSwWpPzOyMAcfSuYM1OmnPbDkusQCZ2GPEyHksAwGm1mLgKVLhwuqgy8j63nHfxOlW4eu28ziNy2CybIkS/n3sFtgr/OwlQF9QMDvwz3H8qyOjaiJf2NokIVpKc/CKn9EfjSYvgetRZlHT3btduIGehTy9biRScq1hWYoNNhzHY5FSCCziGe8xgd804qT29WtjoNVyyc6+4CfTSi0oC60b4bnHyfu+NsD18h3EZ7Z1lA+wxdwO0Owwe/nH1/sKzz/KW0xcQpkA0UIo5FS8M/U6YP6PxiEEXUqBLAqovZTeOq2hhQ6GsTXTCh/0BQ3/BSpZjKh0gkoqo/U/UKZ1rU8vd47ULKl8RPkT0D689x8OYlH7dujww=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 691351c6-8196-434a-271c-08dcc94327b4
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2024 22:29:04.8917
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SyRYI6bR9ovE7Zg9jm/zAYZzzs+YEDIim2fdiZGjn9F0csH7yh2sxUHpJL/j6faG9JWs2r8DF/tapUOKuj/Pn6ZFciXUMwXn16NnSkS+v4U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5077
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-30_12,2024-08-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408300174
X-Proofpoint-GUID: dCpz5w-uluRkZ-CtLxhu0pga3mPXPKgz
X-Proofpoint-ORIG-GUID: dCpz5w-uluRkZ-CtLxhu0pga3mPXPKgz

The cpuidle-haltpoll driver and its namesake governor are selected
under KVM_GUEST on X86. KVM_GUEST in-turn selects ARCH_CPUIDLE_HALTPOLL
and defines the requisite arch_haltpoll_{enable,disable}() functions.

So remove the explicit dependence of HALTPOLL_CPUIDLE on KVM_GUEST,
and instead use ARCH_CPUIDLE_HALTPOLL as proxy for architectural
support for haltpoll.

Also change "halt poll" to "haltpoll" in one of the summary clauses,
since the second form is used everywhere else.

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 arch/x86/Kconfig        | 1 +
 drivers/cpuidle/Kconfig | 5 ++---
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 0d95170ea0f3..6d15e7e07459 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -839,6 +839,7 @@ config KVM_GUEST
 
 config ARCH_CPUIDLE_HALTPOLL
 	def_bool n
+	depends on KVM_GUEST
 	prompt "Disable host haltpoll when loading haltpoll driver"
 	help
 	  If virtualized under KVM, disable host haltpoll.
diff --git a/drivers/cpuidle/Kconfig b/drivers/cpuidle/Kconfig
index 75f6e176bbc8..c1bebadf22bc 100644
--- a/drivers/cpuidle/Kconfig
+++ b/drivers/cpuidle/Kconfig
@@ -35,7 +35,6 @@ config CPU_IDLE_GOV_TEO
 
 config CPU_IDLE_GOV_HALTPOLL
 	bool "Haltpoll governor (for virtualized systems)"
-	depends on KVM_GUEST
 	help
 	  This governor implements haltpoll idle state selection, to be
 	  used in conjunction with the haltpoll cpuidle driver, allowing
@@ -72,8 +71,8 @@ source "drivers/cpuidle/Kconfig.riscv"
 endmenu
 
 config HALTPOLL_CPUIDLE
-	tristate "Halt poll cpuidle driver"
-	depends on X86 && KVM_GUEST && ARCH_HAS_OPTIMIZED_POLL
+	tristate "Haltpoll cpuidle driver"
+	depends on ARCH_CPUIDLE_HALTPOLL && ARCH_HAS_OPTIMIZED_POLL
 	select CPU_IDLE_GOV_HALTPOLL
 	default y
 	help
-- 
2.43.5


