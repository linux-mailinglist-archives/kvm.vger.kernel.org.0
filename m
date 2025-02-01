Return-Path: <kvm+bounces-37069-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CBB10A24818
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 11:03:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 61BA17A32A6
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 10:02:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88D6E143890;
	Sat,  1 Feb 2025 10:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PxWVQoi5";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ZTv51X8a"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF6F25761
	for <kvm@vger.kernel.org>; Sat,  1 Feb 2025 10:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738404170; cv=fail; b=jhPRS23FrRhpQFcaOmg4F2a+skgqwYm/aduiKuxDDLFEyBO1rAoM+LphLtZ6kw2NET/gW0tFpCMvsg+5FBrfDIqWeLuggZdTy+uiY82Oy+KZqq0kT3YoVnfi4GsjKlU1/yVQ0P0QY2M8KZij7asl9afIC5TL0Ijgl/79ycYbJYY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738404170; c=relaxed/simple;
	bh=HgTRIO+3j7417Dde78ua+6G5wr6DJuW33MJiGOjsakg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=INjYgjJS4YSx1j5o5BnQZBE80I18+9CKm+UFZXQxCO6TJRYuHZY639ukUUmLpmTDIJAcOtJkxo3fzNGSrXiOHKehMulRNthsqvaDtv0/ivHcMDvrRdQTYifxkrBqnw28Brvm7UwxNAMKU9bTWr5DOUlRGGToh7QDHt9j99B6khs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PxWVQoi5; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ZTv51X8a; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5119SN9H011526;
	Sat, 1 Feb 2025 10:02:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=MMfRS/V+Hryx0stbzfEGRLl3krVuFC4yA62E4dGr76w=; b=
	PxWVQoi558rSxWam/ePKbfxgpHf/GHG9Ad6ee84rR0U+u6nYOJ+xqc/ey8NzWcXc
	8/5vjzNQTLOnL25pAmdCauR0SZ9+hxGZljz5q/43IbiJSM/KqYeap2QGzGRsmmDA
	+BNx4b7m4dxM6aYdeNTh0OmViTcBRMUiGiei45VgtwF55YMnuCFsDFBGbs5bpwc7
	Pz8qDDo6Nsz8mzJO+VP1lul+0tMvOKmC6Lpw4fmnMdeobxI97Q0RPnXjqd7gQvwY
	e2y684ABEV9EiXhe1SvJcK1LUHl42NHCultuBan27Yv7ax04/ZyaZBXcyyHy3BkB
	Sqs8UhFTDS8Hua5k31h04A==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44hfcgr3g9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 01 Feb 2025 10:02:33 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5118j85G008838;
	Sat, 1 Feb 2025 09:57:33 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2044.outbound.protection.outlook.com [104.47.73.44])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44ha25fbmy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 01 Feb 2025 09:57:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AVdXXY0QTWs+CHsvrZ+jS1KxP5zNzqNElt/OTtOz5Yqw1Fot+YTnkS5lyrMOxNdUZ4ToWRP3Fr9hX6KHH0fW36BnnnxfHof+7+0jURggwfp/+v/9B65pMJU/cCeygq7bf5pgYtmP8NZ1r9K+LbkZUfBESKsvHwTvWhyfoLEEUiHBx7D//f3RVP9wifj2lx2CPsGQFhgmGqk+vJ7oKxw47/mkgIL1xV6LwlghJmY9ZVNgkpk0fbzjjiV3LcnHcsTpQZahKbfhsJP7k1b48jaTFuGOtkVKnwkOdDF6Eht7lsbI+00eKeiJYNNqaqQk7v9LbZoJVljB2eMZHQfFLSIwPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MMfRS/V+Hryx0stbzfEGRLl3krVuFC4yA62E4dGr76w=;
 b=uwx9aRUW9tZiJlSisJPDAcYLmi0Cl0dgguQztvWCepN+N1t/NLfeza5QY4w8Lc8O4RErWprZgMz6bbFb0R7bWJ/5NRWa1Hr/gKVdJ9HrO3zhtppAJXi4wMcHC1eVaRzsKl25z/sGxCbRcpLLt/en3b2HRdco6u8QDqoRQq6iXL71c6YkG2uaZ7OKK6T5fCgr5i8HB5i3S4B9KIsasoyG8RtiImBb+weFuMfwth9j5telVrEov1Ke+iElC/IVnAYWNsinWuOmSENkFiSHscuvc/O+hm3H8ZwMVr2K9qceVHnTMAEBWPMmwQdxjq373/I5FAETDkhNJics0b3oE4y1aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MMfRS/V+Hryx0stbzfEGRLl3krVuFC4yA62E4dGr76w=;
 b=ZTv51X8a96p+4gn4UGXbwHv4bQkBfKl6OZrFubjnLgf6mkVRV16wtG3kLMIxAcS3SpwbqEf6Utd/UZ2ZK+RBNaO4j4qpxlmY3zyojtPqVahXifLyJl5n1LAmHjjDlqQV7HXr7+MU9mI9PhbVg+tNCqi6vhKewK7RNCoVS6NF+WA=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CO1PR10MB4418.namprd10.prod.outlook.com (2603:10b6:303:94::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.22; Sat, 1 Feb
 2025 09:57:30 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%6]) with mapi id 15.20.8398.018; Sat, 1 Feb 2025
 09:57:30 +0000
From: =?UTF-8?q?=E2=80=9CWilliam=20Roche?= <william.roche@oracle.com>
To: david@redhat.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        qemu-arm@nongnu.org
Cc: william.roche@oracle.com, peterx@redhat.com, pbonzini@redhat.com,
        richard.henderson@linaro.org, philmd@linaro.org,
        peter.maydell@linaro.org, mtosatti@redhat.com, imammedo@redhat.com,
        eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
Subject: [PATCH v7 1/6] system/physmem: handle hugetlb correctly in qemu_ram_remap()
Date: Sat,  1 Feb 2025 09:57:21 +0000
Message-ID: <20250201095726.3768796-2-william.roche@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250201095726.3768796-1-william.roche@oracle.com>
References: <20250201095726.3768796-1-william.roche@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0094.namprd03.prod.outlook.com
 (2603:10b6:a03:333::9) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CO1PR10MB4418:EE_
X-MS-Office365-Filtering-Correlation-Id: 226f3f40-3b03-4a1c-eb52-08dd42a6d758
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ED6T4UWfEX7plSpZpIznczQImlm7/IxwkTv8InH2kMtYsJk207B5tAGHQVLF?=
 =?us-ascii?Q?OHaDQGDZetsW4sS3zEtH6fALwHmyKVkZhcM9rIoFVl6b2PEsHtAfuJ+ssY5r?=
 =?us-ascii?Q?QiSZE43b3n5gJ8GF43h3P/zA4XK4I9NpQV6iSe9521nIiFkO80VFptKTzey6?=
 =?us-ascii?Q?tUP7nP6yHpuMXIdNrzj8kiaNxi7b20SZtnKDOlfDl1HMvzC3MC6G6pIg3Byo?=
 =?us-ascii?Q?yVdHmp/dwnUuEA2PLHG578DrcnuauTWITufRTPHxGMuvzqCmeGB3CQjTyU3U?=
 =?us-ascii?Q?fY+hKYAuv503grJ8c4y8dcW4zPVjeAzV+pwntZoAjrWAktSGbkGsC5WfpB7B?=
 =?us-ascii?Q?teXId3zz0KjdolMc0RtTyOFb33k6WKLeOKH8AYzM6Oh9eJOM+4lUrCY1Vbih?=
 =?us-ascii?Q?+PPLji7kZdBDiwuCqg26GhlLq0VvjMmzpWBKVmb7bF4YUfwKTzr5cumOYGyf?=
 =?us-ascii?Q?E2AAU935sHncPXgyY0kKRhT9x7Rvv+T3HwVNEc4ZOvXiGbTEE13670QqZURw?=
 =?us-ascii?Q?ML2vwA/DkwceRgibGOnn+ixddVh/PuvLX20638D1aQ6KmOwWIu+I8+fULuo1?=
 =?us-ascii?Q?7cbgcLk46j9vnUEjE9Iz9foatGEMVQBVZxx6M7p6x3cjnEVmuat5JY47aerZ?=
 =?us-ascii?Q?8c8gbg/PVY1xpVCG/cqzssAIyStE0nIPuoe7lan/+DqdCzzNKAcs2sOUC+eV?=
 =?us-ascii?Q?5kjkCZ7gYeMcdfw8eJiOf/bIH8BqnYvtE1nhTWM58rExjvwBMGjnKg4WmnMn?=
 =?us-ascii?Q?GY7Yegmf2JgvOw+k1xwCaX54MtAvFktjsVhpm/fukqAafe0R3GVx8rtImPpE?=
 =?us-ascii?Q?NyqU94fhtf2AwmcBY/8dQwqnW94OD5xFEasXCsiMAwfUTq3gB7jZBznPbRQK?=
 =?us-ascii?Q?ZMDUGxzM6/ltl3OsZbZEBvXvzHt2VcrcDgT8zcmBFxp6wpoPwR4ZBe/G8fnr?=
 =?us-ascii?Q?vLrau1mfl3uFR8Bc0EOhMhFON+tUydVomPFusYPNd9Awo737GlrBJ6BfZVuK?=
 =?us-ascii?Q?yNa/NlMjkNfQp7AOVCUlb7vnu8W6e8Jjf4zAsfPdVaJDE89PwWX4/mzwnKNT?=
 =?us-ascii?Q?av0utBPFuzwYuGdUhMxcis95PAPTifdBOr0QCTAABw8tA3uU/BfHSOQVitBA?=
 =?us-ascii?Q?/AShYh/d+Ez4EvfJC9pZaFV6zLeB9ksxbWOT/lVRY5O9YysZFXnU1U4/xkzK?=
 =?us-ascii?Q?fdMTkgNw7WM/KsIlH0Ti29KSSr7NWwU6Aye225qnORggJHRITGePutybABU8?=
 =?us-ascii?Q?eQ16/Ilf0mfkmAawWRfuwhMM0pHe1BqPQHqNifa+3aGZhM9YGjR+BAjeD5Cu?=
 =?us-ascii?Q?9fd6XTOHVybO0bN5Lk7D82LjdnlrEshV6Dnti8VFHdVHV7ABNf+vHL9KowVz?=
 =?us-ascii?Q?d7EgE0pD5aqw1XCV4ZKz9pnc8n4u?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?aqrWM0SmFnMe/aO76CGP5/veuHt/udXdRLDdMQOgqsdpFq8lxMc5UvmUTt5n?=
 =?us-ascii?Q?9VDZlwQoez1ZBqmkLEFHx3gKC13kSSdd88jycEH3ImFAOnmcyoTssbg4vzEG?=
 =?us-ascii?Q?s7RyL6x19iXZxo++WGTaWmZ3IpfWmqkX1AzSY4bhEMyzghTdCqPUriVoErg4?=
 =?us-ascii?Q?mfNZx8KxTld/1/aoASX94M9hGsgVhTzVZadJpW6SR+jxc0m6nSq2ZvYeDsuZ?=
 =?us-ascii?Q?tE9j88r7zsPpXm0/lqqj2dvf9c/yY9FwQdH2jPzyKMbRAuJ0ht9TZOYGAbP7?=
 =?us-ascii?Q?ML1YL6GYn2ZurF8JL9ahciIMwXy5vVCfZ/VfMsAuPIp14J/bCusxuhBzYkPH?=
 =?us-ascii?Q?BtL+DOu0MyaFu+J65sH7Mzpjq5b8OEt5Nqsu2fAz6ojMRgtqVPiC28JvyhzE?=
 =?us-ascii?Q?xgRZQUQ0WDijj8WrJ0vcEQ1fmTa1TpfTGH97u6eSVBQ/y3mSHaDG9N7JBL7g?=
 =?us-ascii?Q?rNMWTCyzXp+akpZRsw105bl3g5Fkr6bEtjHAKhh0EY74A45J0Y8wgUQ5zb2G?=
 =?us-ascii?Q?46wllFCKQNtEgCHTyEHV/4dBnx9aUIv/2se5avjddWkRtYkxmfPOfII7wVLu?=
 =?us-ascii?Q?iVZjS+Oym+1MwIVh5LJA5lfurl46tW+D1x2grQxDEWZ8rY3Tej/4diffiQ4F?=
 =?us-ascii?Q?77W2cKXs+4UvJAiR1X5lXHc+gkm62on6h/g5hOb0od2h757k7vYIW5U8dKZq?=
 =?us-ascii?Q?SgXqIoWBtKBPY1nlYVxjlD2q+JB6AhO7L3IBLGgjBUvVU2OGnKxA2F68u7t/?=
 =?us-ascii?Q?gAX969j7ZUNbQKKJEMaTEBJ68CCZka7SpCgN0siYcmRcqW/hyQSR/o+9Iz0u?=
 =?us-ascii?Q?pM40Xid78Ca51M15eX+EfMGPOG4dsS9PP0nVPkApQa0bu3YUZqSbWFttiGvF?=
 =?us-ascii?Q?X/C98+7AECYNmR2V4CEfxV3/S74lqcEdtamjpa37PLnL9iAcQ3c/RGX6U4yo?=
 =?us-ascii?Q?OpJK1gF0VakjHRLGdp/alsFVzEz3aJHniyvI6jIZAQrmp8QlKUbCQeqSIAKK?=
 =?us-ascii?Q?bhRrBDPGkzD8M7V69lUWweE2ihPv4kR9PkhVKzoevQbhkbWoKOTGKPQF1pV9?=
 =?us-ascii?Q?WSsSb0LkLF33SSAMgcwISmOrRzAmuAV1ai+80dWiV2BYZCP16FSCx7JhpN6z?=
 =?us-ascii?Q?YTBNRtEvJmRDQMeb0fcVvvKM82czOM8Q/O6GKbAfiMn+IdwlWQSJPgxvEMZ3?=
 =?us-ascii?Q?uiHnE/QFBo7UPoQKIpeWWt1KnTwSAhpk6o3x2OYQlxmR9jd7kv6Imzee3ouM?=
 =?us-ascii?Q?LC0T7L2axupBgT67Bei+4EwapZCX4hHEt4zJ2tVPPdyXxG1BTRduuc8TtNfj?=
 =?us-ascii?Q?xY+0T0OKzCZg9NA1dtLcDdvZMBXXcQUIzPu8ZPuZlbcwkI0WDVVAMSryxRSx?=
 =?us-ascii?Q?qyo8o5wAdA3klEL3r2B1yAOFRGv0ZOr0mfdCIKNjjTnRdZIfAlG1TtcgRuEn?=
 =?us-ascii?Q?JbBI4Q5L9zjpFOmsOGDMPDhf6jJiuI6JdW/93PKVGHv9ZYXoiY/X4jJuh2v8?=
 =?us-ascii?Q?d4/wwtwajTBqmsiDXZJrBGgPDtEy9Mc96lu93uOPok1mpke3K5YtxYWweHlK?=
 =?us-ascii?Q?PVn5tnnRIYcVaQjyaistjU798xV9CBpZhuBOlWoY4xkaoZsOs0+xrDQFqvfp?=
 =?us-ascii?Q?EQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	IGjdJ6bv6Za3EV9epQD22yxwvk5pdvLDvZoJcvAoicnCCs1w1vstZ89yc8FwL4QD5X9PYmyGkcCuvnxJaIpWyH+1ZhElol84bVBIk6xlHlTl9tjcOHLDX6NEHuINHsPNgh1w1OGfB5YkhJI0SafpTBZoGCpHymJ2ww3ex4QID6ZiMM0Tqum0/HZCdtQL0uCKipDpTOR7ANmNOqfw/TtSLYuUJ/zWQuKZZDQSh6nR3KWau3q5q5rDJYaqT05H8rjApylPUvBBgsP1fyVC++HZO1lcjKHSvhJAGlDalfOABYUQgEx2sF7+RLY86YyeCQS1Sz4juHwh54kz6SuGQQUFD8gRl0o/tp6gF1j8NRIw2lgHGcytxcEipSwwSO5Ij0OjsF67ZqQzTiHQGr8NGJj+DxJHg/9f79oVZ9ClAeEQL6QWXp9OEBY8AWMPWMgLMQkI3LuhxxlwpFlmA4+ZGvy/5tTbrbv47aqjREfrXSs7+h2uiO01FFjmzGDPJ9JtCWOsHVT0kZaT1VZlhiQxnl+MQl4CubQhZQ6FYNi3tlbWR17VHq9iDxIO9J698PXPtRstolHcrguTw5jTjrfS+tELZBYPpecHYomL/bQGgQX9rew=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 226f3f40-3b03-4a1c-eb52-08dd42a6d758
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2025 09:57:30.4244
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JwC3KXweXquMcE3OvRhLzxMU4WMEh+G6EJ7TCHtVspPQvDgQg3GWyh723YsJ3qHXCESqRkouHcpj/1h0YGnfH5n6ifo1UK5gh4EGwiZGxmg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4418
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-01_04,2025-01-31_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 mlxscore=0 phishscore=0 spamscore=0 adultscore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2501170000 definitions=main-2502010085
X-Proofpoint-GUID: o-2NZiEjKINZj8JZcFUKVV5DesK-Qwwo
X-Proofpoint-ORIG-GUID: o-2NZiEjKINZj8JZcFUKVV5DesK-Qwwo

From: William Roche <william.roche@oracle.com>

The list of hwpoison pages used to remap the memory on reset
is based on the backend real page size.
To correctly handle hugetlb, we must mmap(MAP_FIXED) a complete
hugetlb page; hugetlb pages cannot be partially mapped.

Signed-off-by: William Roche <william.roche@oracle.com>
Co-developed-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
---
 accel/kvm/kvm-all.c       |  2 +-
 include/exec/cpu-common.h |  2 +-
 system/physmem.c          | 38 +++++++++++++++++++++++++++++---------
 3 files changed, 31 insertions(+), 11 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index c65b790433..f89568bfa3 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -1288,7 +1288,7 @@ static void kvm_unpoison_all(void *param)
 
     QLIST_FOREACH_SAFE(page, &hwpoison_page_list, list, next_page) {
         QLIST_REMOVE(page, list);
-        qemu_ram_remap(page->ram_addr, TARGET_PAGE_SIZE);
+        qemu_ram_remap(page->ram_addr);
         g_free(page);
     }
 }
diff --git a/include/exec/cpu-common.h b/include/exec/cpu-common.h
index b1d76d6985..3771b2130c 100644
--- a/include/exec/cpu-common.h
+++ b/include/exec/cpu-common.h
@@ -67,7 +67,7 @@ typedef uintptr_t ram_addr_t;
 
 /* memory API */
 
-void qemu_ram_remap(ram_addr_t addr, ram_addr_t length);
+void qemu_ram_remap(ram_addr_t addr);
 /* This should not be used by devices.  */
 ram_addr_t qemu_ram_addr_from_host(void *ptr);
 ram_addr_t qemu_ram_addr_from_host_nofail(void *ptr);
diff --git a/system/physmem.c b/system/physmem.c
index c76503aea8..3dd2adde73 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -2167,17 +2167,35 @@ void qemu_ram_free(RAMBlock *block)
 }
 
 #ifndef _WIN32
-void qemu_ram_remap(ram_addr_t addr, ram_addr_t length)
+/*
+ * qemu_ram_remap - remap a single RAM page
+ *
+ * @addr: address in ram_addr_t address space.
+ *
+ * This function will try remapping a single page of guest RAM identified by
+ * @addr, essentially discarding memory to recover from previously poisoned
+ * memory (MCE). The page size depends on the RAMBlock (i.e., hugetlb). @addr
+ * does not have to point at the start of the page.
+ *
+ * This function is only to be used during system resets; it will kill the
+ * VM if remapping failed.
+ */
+void qemu_ram_remap(ram_addr_t addr)
 {
     RAMBlock *block;
-    ram_addr_t offset;
+    uint64_t offset;
     int flags;
     void *area, *vaddr;
     int prot;
+    size_t page_size;
 
     RAMBLOCK_FOREACH(block) {
         offset = addr - block->offset;
         if (offset < block->max_length) {
+            /* Respect the pagesize of our RAMBlock */
+            page_size = qemu_ram_pagesize(block);
+            offset = QEMU_ALIGN_DOWN(offset, page_size);
+
             vaddr = ramblock_ptr(block, offset);
             if (block->flags & RAM_PREALLOC) {
                 ;
@@ -2191,21 +2209,23 @@ void qemu_ram_remap(ram_addr_t addr, ram_addr_t length)
                 prot = PROT_READ;
                 prot |= block->flags & RAM_READONLY ? 0 : PROT_WRITE;
                 if (block->fd >= 0) {
-                    area = mmap(vaddr, length, prot, flags, block->fd,
+                    area = mmap(vaddr, page_size, prot, flags, block->fd,
                                 offset + block->fd_offset);
                 } else {
                     flags |= MAP_ANONYMOUS;
-                    area = mmap(vaddr, length, prot, flags, -1, 0);
+                    area = mmap(vaddr, page_size, prot, flags, -1, 0);
                 }
                 if (area != vaddr) {
-                    error_report("Could not remap addr: "
-                                 RAM_ADDR_FMT "@" RAM_ADDR_FMT "",
-                                 length, addr);
+                    error_report("Could not remap RAM %s:%" PRIx64 "+%" PRIx64
+                                 " +%zx", block->idstr, offset,
+                                 block->fd_offset, page_size);
                     exit(1);
                 }
-                memory_try_enable_merging(vaddr, length);
-                qemu_ram_setup_dump(vaddr, length);
+                memory_try_enable_merging(vaddr, page_size);
+                qemu_ram_setup_dump(vaddr, page_size);
             }
+
+            break;
         }
     }
 }
-- 
2.43.5


