Return-Path: <kvm+bounces-25570-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 17CF6966C5F
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 00:30:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 89C201F22B72
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 22:30:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBF3F1C1AAC;
	Fri, 30 Aug 2024 22:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Lb52HF8B";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jzuE9I9X"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6048E1C1755;
	Fri, 30 Aug 2024 22:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725056987; cv=fail; b=f0orMg4o1XYaUHLR0d/7+ml2uf3sH53z37nV8Dpab0XZHyClkSMyohOmDMpXnsb7OxrHMALKawdRR1T5npPpMY7+BuZk04Do8hXestVMip8k6XpVDVZJVbnzLiAf0k5zEEobscLkMLrNR7FYnaX4ADAlZ4t/9dYzUVvKL9aBVXw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725056987; c=relaxed/simple;
	bh=tw2BZQsJDO35USRTh5dQ2FxL3xhXLDF/2aDa6picnoU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ebvlA9+QJF20co0n5XuOZwcTJOm++X+wmK0A8YW38+qlkZt9CiBdTQt+ZoAX3KjV/mLfiDfUwVT37qjFbT/GkzsgppbP5CO1P10FBbC4m89H+S/cT0eVjDjftxSlpCiUMQwb3w6vmU+ak/vwz5nua399rY4JLnW3szmZ3xsfQT4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Lb52HF8B; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jzuE9I9X; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47UMNgm5027558;
	Fri, 30 Aug 2024 22:29:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=OeVeoQh1HC5YBmuLhbUCgtLoCIJz4hhzdW4bm35kw+E=; b=
	Lb52HF8Bqs7aiqutuK5cL7N9OBzw+w7nrITYTZEfcxJkVmzTQyV7juPq84QbWJcM
	87QdNvI0KGNnTJ7PzYGnURUF+hgXfRKcGLR+A09E0xN9RdPX3p7++Bz/FzSe90O3
	zEYKXrBYFCec+K5IEzczciZlGdheyCx7yh9Sg/Qv76Ue7ObtwGa97Bfd4SQeQwj1
	t/Ft24ppFwrMAXiMFKIROkku5l/dcHyF+DLo+wIqE0nFOmvO4Dv1Lfm8HHnAwMhR
	yE+y9b65URZIbBT206o3zknNMv7xlTIYiCSYLzVGQ976HjqgX7Yp8U7/mB7dPkIm
	KF3bGSb3o0pLxuf0/ILddg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41bptkr06h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Aug 2024 22:29:01 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 47UKEE1Q036519;
	Fri, 30 Aug 2024 22:29:00 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2044.outbound.protection.outlook.com [104.47.70.44])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4189jq3pyj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Aug 2024 22:29:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LYOKBzqI5j07Kk+tHVYAQxW4yLvw+pYGCIwUddfEI+saEjVxPybM18d1qbPDNIrZfWE7G2OYSTrq1DBJsiD4Cy8Arxne/5371+9yt6TjEEesEbRBztEUSwDMVuMJyFh7xkKhkdW5Em0V/Pcd56/HXmwi/lsvHKDdR2cj+N2cn97FRdVpMM4DHnlPF1iHuWO1t/Q/3GVgKB2walHDnlqCxuaLmV9JX9MhwbehTxvgJo7WxWXfdzhpLipTKHJOnxsefrr/QgPV6iifOFglT9LrU/OnE8zwKVulQAXZxd/lEpUhAU3oY7qb75WNQKImQpSUD/Fg9ierX3VBk6B2t0T0Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OeVeoQh1HC5YBmuLhbUCgtLoCIJz4hhzdW4bm35kw+E=;
 b=gV3N+WaVwmQ48uKyGhR/6a04qgbK5Dq3gL7BICmQgaii4u/vDkBqmJZuGGVoFhK5bzFZaSUU3ieghhLA5wskTadf4/twHnoFpeW9ikdw5GbWnmLAGNf41cgNf7C3Nhof6SA8SnzpIEHvUD2BQV8qO1dauy6O5nePtD1uqas3Uq5dr/6yU2Yx+raNIRAQFnh5utoDhWL5eWUOOH55bNQwbpCxV83Rp9QKWFaEQEHWRy4KUJ/jVW2yHSR3TvA9p+rIfoIDTcYiYMsXdqdqrQDYnfafJJhoWx6olISP7W9HtEkkHOV/qrZEhkKJYtFvCacyHrgm65lGmBOGCaUkdrhWKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OeVeoQh1HC5YBmuLhbUCgtLoCIJz4hhzdW4bm35kw+E=;
 b=jzuE9I9XCjLAm46pwZ8/UDhVDmbqpY25OEHm4tMzNwepoAXWK1SQl6JkQg68xJXW87XjpOyV18QPBBDVOJMzrtLIp0RvLdlhOYCn9l4sOg51fP7rQpkLwxVmqULGylyi3z6mE11d9C2r3OOBXETYQiwUDrwvUNhHtHhwNtNo5cs=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by BN0PR10MB5077.namprd10.prod.outlook.com (2603:10b6:408:12e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.20; Fri, 30 Aug
 2024 22:28:58 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e%3]) with mapi id 15.20.7918.020; Fri, 30 Aug 2024
 22:28:58 +0000
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
Subject: [PATCH v7 04/10] cpuidle-haltpoll: define arch_haltpoll_want()
Date: Fri, 30 Aug 2024 15:28:38 -0700
Message-Id: <20240830222844.1601170-5-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240830222844.1601170-1-ankur.a.arora@oracle.com>
References: <20240830222844.1601170-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR11CA0078.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::19) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|BN0PR10MB5077:EE_
X-MS-Office365-Filtering-Correlation-Id: ae06b130-937f-4c85-fa67-08dcc943239d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3OZBj11qn4KeSbI60A8UIm7LEcLVEMgo/ItuhfLYbko3x5H4ilYqFYiISJk7?=
 =?us-ascii?Q?4FTgEElp+WuhOHhvhz8KLCitEAiysYHhjSa5JShobOMZl2WMceRM7CoH1iLZ?=
 =?us-ascii?Q?FtP0qbMAKQmoYMsecuuJyrEnitl4mu+h+rDG2hCNxKmiqskhsCIrKgrXMZSP?=
 =?us-ascii?Q?muXz3hw2Oxyj9EkI3ud1RthAn1GbfbmbWB8KOCrz1fxybotGOd0qI2smZhzH?=
 =?us-ascii?Q?9nDBEjO/a7Q37Ql9RhPBmRa2d/pOQxDRttuWXBkt5m3iNIj67Dmv150Vtarg?=
 =?us-ascii?Q?kN8p+y2qK6cscIfyv5XTqH9Zpw8yy6CGSohAnrydzrftWLEBtkG0iMrA71q/?=
 =?us-ascii?Q?tiEzIdqxttMcOOK5enR+2wCKTQMqBjIrsDYUJMSm8q4s9CJF4UKEGzIp5omR?=
 =?us-ascii?Q?ctO5E+YE+D8XuEe/I4kCKCr8b6mupHl92f3g1VzqyHy3G5Yk+bqA7MBTHFke?=
 =?us-ascii?Q?mvz/bOTa2jMcGANSFC5fZmvTw4ArfRT+Ya7L+HafLAaKoTFZe63Ow+hAK7uz?=
 =?us-ascii?Q?Vv+JuQfd29NWqn6MhjcDY1ZXIiNKcLNIL+2Fp7ehqd0SkoQX4Cd4oAkp2h86?=
 =?us-ascii?Q?RGPRwncmqBRHeCA3W7f3C3OBle+PGxfwupxDQVwFWLrBVunMYqR57QxUo361?=
 =?us-ascii?Q?POmGW/JMSLE910gc0Nw/L/oRs97ml+5hMtMdRgePmF8C/SEOmqySYlAt/0kn?=
 =?us-ascii?Q?2/NPn2OxZWTfiLkKfUNW4kS8YUKhmExI2QDUlwg1OGvdapvh2cVdRGru2gni?=
 =?us-ascii?Q?2QQCcMJWDNWowXkUsWBhxU3CPYEFjdwFcpfHnMXkhHDO2G3wyULYNKjFC/gY?=
 =?us-ascii?Q?kGvuwFGgAT+E2GXIbQMcZCbFKHfjg1uqDE33+YAkqJa7+Za/7av5I5aPjsiM?=
 =?us-ascii?Q?3mw/dZtvhQU8kOzmAFL7zAJMaFgZcKLc6uyU07u/Txa9CcENV6x5+KceDmEH?=
 =?us-ascii?Q?g95GwX/JzjO7kmRKmIV1VGAcQGNxUDfjCrbqOuBmGIQzHqUbHBaZYyuR/lvT?=
 =?us-ascii?Q?z50kch/4CEc36TJHCbXZ3PM4lRQFlCrhq9FBlj9bAHOOC1QyQDfRZrJ8BncC?=
 =?us-ascii?Q?eACD/Tquk3E/nS1RVdnrNrdqnl0ycjfx2lD7xMbE7ayfjfVuCakAvH7gkYZW?=
 =?us-ascii?Q?Hq1VM8EzBYXQbD0bSB/koBL+i0iJNQMM2w4gcLNhvlulpZnWguSUDLSMpAZc?=
 =?us-ascii?Q?OFQBO5dFH8KJTOM68YUkUK88Cz1jr7V6VwSmK+GmZgoxHBjDUPz64b3YUGt4?=
 =?us-ascii?Q?sX6fc9BFZQ52tJSfOwg/fvkvqTV4v43sOl4FyE6a3HSm6inpNhGiqBVOaSdD?=
 =?us-ascii?Q?SjbYGn9UQCjFKxMsrh3jwwV5c8Y+m8MnxmkPUZJdXaZktQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8iuSZhSYJXSaZCA7X6FJmSBjXln33fVhrLbba+y+JvlmKRpVxatfDiJLbLJ7?=
 =?us-ascii?Q?/vHS+AqwWPCpKMfjANsTF0unRHeXMSgZc581BThDtOBBKXSBwbEqJjd8MAky?=
 =?us-ascii?Q?YixDc3oMolCFxt4jxkZ2vcX4mVc+mMNkUasniKtP1cniQLojHwH0/k/qqpcC?=
 =?us-ascii?Q?eKF3Z4JvYHJMsI69fHT5qyIk48xjEc+2ib4k/ZRYATewLf/TMNoMYKtj4/TY?=
 =?us-ascii?Q?Ew7sRJ7hGy3EUc4W98GwDHtJvGhQsnDaRn+a601/kdUpa2fQdJScEanzBX6G?=
 =?us-ascii?Q?iV8ZRyf6djU5YZxcxNVi1xg0VPW7vPwsujUqzhsU0Wz6ED+O1uLABky8BYBR?=
 =?us-ascii?Q?7nZzQNphN3jDEbkXjk/CueawkEcmO6MFv1JFe9fMUBG+oS7gK93lFHy6WAjk?=
 =?us-ascii?Q?8QxtdYUmMROQvOzHa73GSt2fzuT/df4XSkCvXF2hGprQEPgUuoR6VME684Ia?=
 =?us-ascii?Q?lWv9zqKlaDU6wsTdu8qcwGATGXc38ZGM7kRIsuGbdTHxIqhcg/20I51B0OE2?=
 =?us-ascii?Q?IoICHhy5JffJUdnbNZA1VTFu06kC3VTsprJleYLvJDIwg/q8DdDowHyQu7ZY?=
 =?us-ascii?Q?ERwrG+PkqLkUoA0YNkuq1Brppff9QjRLDkrxvbsJxMlLTU9NclRXmFLwzRaQ?=
 =?us-ascii?Q?fnRm+l0j7pmaPNL0CAvi7BRMrYLnFo2EG0LeR/0rnC3MI6FogqWvgor23iZr?=
 =?us-ascii?Q?1sxglcB0CR4AqhLxxzIaQJ98eU9jvhHgj2aAHPSXW6JGknfmgRvFNT2yoBnE?=
 =?us-ascii?Q?za0vkrTeZCzyWS9yPsWT7lBZ73TIjJlZZ0rCIJ9f+Yr6TPwxOJ8upMCKPuZG?=
 =?us-ascii?Q?DhZEZh2rjeorsfAuvy/e+qjTq2jpB8EF2LIkfAsudLgD+HtGvRuA2yAVXuhh?=
 =?us-ascii?Q?eayONGk423dSsFGJMzFXFmFk9xjiwlln1Yv0cX/T80joizPkx5nf0m7ZGSmy?=
 =?us-ascii?Q?1mGxa0H1J70neC3WPtuMEKTrtWUuaCNVMJ/QXjwQlxszRIzusOHYL3QFe1Lt?=
 =?us-ascii?Q?Ua2y5BLKy5ma33mfcXNr/OqAXh2rGkzkuHM0/PN+1Me1vF3lTo9dCNrruCjC?=
 =?us-ascii?Q?iafjkauTdFkGLBhUnQaRCWSORVBa0dZW9oWVsIyvPYqCLii9cICah8jym7I8?=
 =?us-ascii?Q?ZW6mtwBFf9scAwiFT/NejNeKde+4kd5+SBY5Ziv8EoDFFTsTpIC5ODBbv9wl?=
 =?us-ascii?Q?GwvCNMuMJaNa2EzPHrHZq7LhqF+wXmoQq27SZFAgR6PqtHU9sYf8ErFEFoaW?=
 =?us-ascii?Q?NIkiJQprbrtbKn7vGp8Wv55bevg7av80snCeGEU5uNbseExp4rJuLr1kDCfC?=
 =?us-ascii?Q?8QXvCXy+bLRVbGYCFm1Mki3Rj5xTWbx05rGnO7LHLE2Etd1+eE3/C8nrDXbJ?=
 =?us-ascii?Q?2ua2d4nIhRijcsixVUCfLCNQKIO5xUiFMihilGE5z7DZZTg0JpNaOOrQMTmx?=
 =?us-ascii?Q?LvXqg7ENJbl6T32v7MKj4lYumZp8m2llE38diq47/NTrfB+6o9yFe6oiHO7X?=
 =?us-ascii?Q?PyIE4DrNzTpa9rNDCDLUQYqezNRCODl9e845wTE3eWA8wCSF0229EtEPrFAA?=
 =?us-ascii?Q?N54E+KFcArxcJ6CYOqeTZco34aY5QIQqGSwZAmmaj5RJClmqtSJ8fyF4l7t1?=
 =?us-ascii?Q?LQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	FEU1b7vp4lXKWzBpU1DAU0scMv6Jzlg34SNr1N5+KKnRYJx6nC0HGgLytCXwUN+nmUTA9+TQiPAPjnsrAr0eEGDf1QICC6WnIIwU8TPAmNNr6O8PZsBtJhygjWEi9rEwgqX4CTtLUt5MXVaXKhnRLDyDXPVpCBZW0YPS2f/40gtORq4AVdoROiCn/qNeDjOGVyErvGLe2p0cpQ3H1evdHqw+DD//7DbVMf7RlAkzVURCLz4VJ5luYycpc2Y6j9/qd30QbVvoFdbpSOwWo2UjjO/QLWfr1pkdIeH/6WOyNjQwwrGR/vBurP2IuxY4kNuE3Qhcq2W6kSG5ssxKahSvnzntrrHxEoWca0bcC25+qILdP/c3TcYWGveEn1xiCcraX50+H+601/gT7ldqRQZCUsTxtb7TaVcUbUaPRGUO70WxyK85l4YAHSuAn2YfMP3pxuh1y+elyjIxW+10FoHKhPu83+yDQ0hBp2op2AmN7tIgXHDsTerh3DvTeR6y9GiFC+gWfydcAIFz/DBXK6DbysHGu7Ffd2c/RqeDzsTIj5s29jE2fLX+k10jyIbZ9cj0kFeTJCGpHsXonBm6FidJE8XXDHwn4LxBwQ95m9Ftud0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae06b130-937f-4c85-fa67-08dcc943239d
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2024 22:28:58.0805
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vg5NNBpg0YPOSRYjiqqhp/BikQUlSFexxkHJXKh3CR6QQBK8VZKBZLhRfubWGvvAipb+t9bY2UZlQDrTpiPR1NTKiFGVXJyk+h2td90QJ3I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5077
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-30_12,2024-08-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 phishscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408300174
X-Proofpoint-GUID: QwkcGUsHCJInD6d7qXTqZDe3pa0bQYbR
X-Proofpoint-ORIG-GUID: QwkcGUsHCJInD6d7qXTqZDe3pa0bQYbR

From: Joao Martins <joao.m.martins@oracle.com>

kvm_para_has_hint(KVM_HINTS_REALTIME) is defined only on x86. In
pursuit of making cpuidle-haltpoll architecture independent, define
arch_haltpoll_want() which handles the architectural checks for
enabling haltpoll.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Mihai Carabas <mihai.carabas@oracle.com>
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 arch/x86/include/asm/cpuidle_haltpoll.h |  1 +
 arch/x86/kernel/kvm.c                   | 13 +++++++++++++
 drivers/cpuidle/cpuidle-haltpoll.c      | 12 +-----------
 include/linux/cpuidle_haltpoll.h        |  5 +++++
 4 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/cpuidle_haltpoll.h b/arch/x86/include/asm/cpuidle_haltpoll.h
index c8b39c6716ff..8a0a12769c2e 100644
--- a/arch/x86/include/asm/cpuidle_haltpoll.h
+++ b/arch/x86/include/asm/cpuidle_haltpoll.h
@@ -4,5 +4,6 @@
 
 void arch_haltpoll_enable(unsigned int cpu);
 void arch_haltpoll_disable(unsigned int cpu);
+bool arch_haltpoll_want(bool force);
 
 #endif
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 263f8aed4e2c..63710cb1aa63 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -1151,4 +1151,17 @@ void arch_haltpoll_disable(unsigned int cpu)
 	smp_call_function_single(cpu, kvm_enable_host_haltpoll, NULL, 1);
 }
 EXPORT_SYMBOL_GPL(arch_haltpoll_disable);
+
+bool arch_haltpoll_want(bool force)
+{
+	/* Do not load haltpoll if idle= is passed */
+	if (boot_option_idle_override != IDLE_NO_OVERRIDE)
+		return false;
+
+	if (!kvm_para_available())
+		return false;
+
+	return kvm_para_has_hint(KVM_HINTS_REALTIME) || force;
+}
+EXPORT_SYMBOL_GPL(arch_haltpoll_want);
 #endif
diff --git a/drivers/cpuidle/cpuidle-haltpoll.c b/drivers/cpuidle/cpuidle-haltpoll.c
index bcd03e893a0a..e532aa2bf608 100644
--- a/drivers/cpuidle/cpuidle-haltpoll.c
+++ b/drivers/cpuidle/cpuidle-haltpoll.c
@@ -15,7 +15,6 @@
 #include <linux/cpuidle.h>
 #include <linux/module.h>
 #include <linux/sched/idle.h>
-#include <linux/kvm_para.h>
 #include <linux/cpuidle_haltpoll.h>
 
 static bool force __read_mostly;
@@ -93,21 +92,12 @@ static void haltpoll_uninit(void)
 	haltpoll_cpuidle_devices = NULL;
 }
 
-static bool haltpoll_want(void)
-{
-	return kvm_para_has_hint(KVM_HINTS_REALTIME) || force;
-}
-
 static int __init haltpoll_init(void)
 {
 	int ret;
 	struct cpuidle_driver *drv = &haltpoll_driver;
 
-	/* Do not load haltpoll if idle= is passed */
-	if (boot_option_idle_override != IDLE_NO_OVERRIDE)
-		return -ENODEV;
-
-	if (!kvm_para_available() || !haltpoll_want())
+	if (!arch_haltpoll_want(force))
 		return -ENODEV;
 
 	cpuidle_poll_state_init(drv);
diff --git a/include/linux/cpuidle_haltpoll.h b/include/linux/cpuidle_haltpoll.h
index d50c1e0411a2..68eb7a757120 100644
--- a/include/linux/cpuidle_haltpoll.h
+++ b/include/linux/cpuidle_haltpoll.h
@@ -12,5 +12,10 @@ static inline void arch_haltpoll_enable(unsigned int cpu)
 static inline void arch_haltpoll_disable(unsigned int cpu)
 {
 }
+
+static inline bool arch_haltpoll_want(bool force)
+{
+	return false;
+}
 #endif
 #endif
-- 
2.43.5


