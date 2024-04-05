Return-Path: <kvm+bounces-13769-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id F250689A789
	for <lists+kvm@lfdr.de>; Sat,  6 Apr 2024 01:15:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 68F7EB22809
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 23:15:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B7B43715E;
	Fri,  5 Apr 2024 23:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="juNF/I/0";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="qL/2oL6A"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F04339A8;
	Fri,  5 Apr 2024 23:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712358934; cv=fail; b=qxu4Ei19SCulruG5uGWK67uvtb1Ok8KgfhX0JAzdl88hWuN3vGA8eE2ODhu3AFdzDo8LZgop5+BJ3igzknMW5WToIo31ag7w0mj2y+gsNrnYqzrPyNnAx/CuqOPCmYGEq/VAckd8ydZPLe3BomrHoQzSJkVXSVcMDI3rMBkWwLI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712358934; c=relaxed/simple;
	bh=Xk4AYeOzimvDLHCJ0l+Bk04xRHDTy65lBmn7+EloUbY=;
	h=References:From:To:Cc:Subject:In-reply-to:Message-ID:Date:
	 Content-Type:MIME-Version; b=aE9XKVsjRE5G58X7jcHy9cUPZFA1WAiYjIAwyuRKgYBE4GwYknUzcRDSf54TRwVXi4q0wfxjwbdHNvmeMvGgDbHqwKpdeh1tarlHuUBBIXSBOi/VfArM43da108EwA0h8hN9ltV+3MHYHtNBZuXhLURBiC/ljcRWquoTr5YFKhs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=juNF/I/0; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=qL/2oL6A; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 435LX4DM005443;
	Fri, 5 Apr 2024 23:14:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=references : from :
 to : cc : subject : in-reply-to : message-id : date : content-type :
 mime-version; s=corp-2023-11-20;
 bh=SIH2Hfnioow3R4yPEynu7LJ0Yuue+dVBsxl1vtGKFKI=;
 b=juNF/I/0KYmcQid03hBgjFn54EXgCYmxPtEJQVu5eQcZFzSDu0KrEKwtj9XQzfBRM4Wq
 cyvaHNOOHXKUiP8V01tWVcMQDzpmpfwDncLiVeHiF5Qpp42OOxyUoniq+FtQ6br4VxgF
 w944SU3KS3Ix8YZdA6trBf8qzKIyErRJb74egnWNd18xIaCkutmasmKUcDd4PilhYOSK
 Kh58IKUuQPVp287q7XlQb8FlzgpnYA1CI/pzpmXM6xxRMVLuUpN8C6mKpzrVjjZ4pB0q
 8UJg0M3hXET6Up86R4VXmleM7gsI8cj3mGswz9zxglZxoFBQZYD2YuUK2Xb1F1KwCJdk jw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3x9euy4g0x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Apr 2024 23:14:25 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 435LuEt8038956;
	Fri, 5 Apr 2024 23:14:07 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3x9emt716e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Apr 2024 23:14:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OqFEmgefre7ibqplvp16FN7OTiNBOp8R20YWPWRF2uRwa9ckeltFP9yb/EImDkLC63Qd1yn2bcE2aACKYSKuC/HzZMr6xwvHIgb4BahMxpbp1XPbAd8nislffsvasuHFQLOcSE0lVcGz1Otqnr0qZ3KcfL1s7qEZOcjMEk/RAXjSQ80h1oGC37F4GJycDn/iY61/QNHSglhksPMoxjBkyoVMXcOLHi3VaUVfSuP5kXmwN3YKPfXSE1wzmk+vFP0qOwkt9FhPyGibLtu5ecfyRcjRE2Bv5UdxA81M8YASF47o47NK+cGM5YylmxJQnfkibZCH/R51iM6W8uR64UUOvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SIH2Hfnioow3R4yPEynu7LJ0Yuue+dVBsxl1vtGKFKI=;
 b=aVFji/n/2J68fntbhatLX6assFKgn0M07a5odj1GJs/N+RelpdDAPO1wJN2zMp8MFxaWYXvRL8nbpxMMjO7A9Ohcm9jFavdJ5PsLz2pz7fz8tq69mXk8O9VN3CX4jGD1Re3E0ThEAxRnt6Mxtt5GMYkJW73DYtknx+Ybi1vkCgyoAX7/vgQfSicFX//ik/eegtqgutR4NmsAq7MlOY29syzKnDgXxcpIliO3sf1/slnLfDbdoc45Ue+brUp7/xUnuWUoaD748stCQ3J60OkYjm9T6Ub0izZHQKAdhCxceKRcdCdb2gMcPuxChHEN/vurY3sv0UcYspfwNlWZASMEsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SIH2Hfnioow3R4yPEynu7LJ0Yuue+dVBsxl1vtGKFKI=;
 b=qL/2oL6A+6N3gsFXCFBIPcvNbLHr0jQI1gyyS9yDA79EqR8NJP23nN7fRaRCqnEN1wVS15hZcF4nmMYtwSKTWvZOoc+0OwDffH88gT7aRJh9NJDQX4pVzQRACdX6myGL0DPqfF7PwGV/Gutl09zWJ/DWttvLaGq5VMN8WqYrp4Y=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by SA1PR10MB5868.namprd10.prod.outlook.com (2603:10b6:806:231::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.46; Fri, 5 Apr
 2024 23:14:04 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::4104:529:ba06:fcb8]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::4104:529:ba06:fcb8%7]) with mapi id 15.20.7409.042; Fri, 5 Apr 2024
 23:14:04 +0000
References: <1707982910-27680-1-git-send-email-mihai.carabas@oracle.com>
 <1707982910-27680-8-git-send-email-mihai.carabas@oracle.com>
 <7f3e540ad30f40ae51f1abda24b1bea2c8b648ea.camel@amazon.com>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: "Okanovic, Haris" <harisokn@amazon.com>
Cc: "mihai.carabas@oracle.com" <mihai.carabas@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "joao.m.martins@oracle.com"
 <joao.m.martins@oracle.com>,
        "dianders@chromium.org"
 <dianders@chromium.org>,
        "ankur.a.arora@oracle.com"
 <ankur.a.arora@oracle.com>,
        "mic@digikod.net" <mic@digikod.net>,
        "pmladek@suse.com" <pmladek@suse.com>,
        "wanpengli@tencent.com"
 <wanpengli@tencent.com>,
        "akpm@linux-foundation.org"
 <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>,
        "catalin.marinas@arm.com"
 <catalin.marinas@arm.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de"
 <tglx@linutronix.de>,
        "daniel.lezcano@linaro.org"
 <daniel.lezcano@linaro.org>,
        "arnd@arndb.de" <arnd@arndb.de>, "will@kernel.org" <will@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "npiggin@gmail.com"
 <npiggin@gmail.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "linux-pm@vger.kernel.org"
 <linux-pm@vger.kernel.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "rick.p.edgecombe@intel.com" <rick.p.edgecombe@intel.com>,
        "juerg.haefliger@canonical.com" <juerg.haefliger@canonical.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 7/8] cpuidle/poll_state: replace cpu_relax with
 smp_cond_load_relaxed
In-reply-to: <7f3e540ad30f40ae51f1abda24b1bea2c8b648ea.camel@amazon.com>
Message-ID: <87r0fjtn9y.fsf@oracle.com>
Date: Fri, 05 Apr 2024 16:14:49 -0700
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0304.namprd03.prod.outlook.com
 (2603:10b6:303:dd::9) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|SA1PR10MB5868:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	ZAK71qKmZAfN7wIMjqAejcacqCtrd99durf9o8rCV2Qvlu0A9t/O9Zl6OZFMky4VxldSwt4jUW4g2EUkZdYWscNyuPfS0vIQT4f6TJ7HJkN1ZJP/z4AmLJ/MHOzGj+PerTjFozzUg4XU3Qyq96soaaRvxnxDqjJpqmyqo+Wjmt28u3qvK22UjRBpl2Tel7ilLNAgQB69tzCtm7GksGX8lF24P9UXvl6hYFZLDGwTCSsUkDnJn4KccvMoktf1MFnoKvREXd+L6DaF1Wd6p4N0lZSaB3NIx5yvgpHEVPJqDu+C6+nWFxKlvo/AggB9+NJqoq9//BXIXJzhi2vI+8oRFJjCPJs+ADnviZZRgMVqsDJYA25a3PIUWVXmldA6JPiUEEDXu8lYUZjcNYtAmvSAk6HI7J1Uxa0TMIEDSJ5wTj673PARxaQCWETs7lLrMNS9rqGIBF5wflxx1NRZilPyoWmW5rbHYGQJV4AY8CoGqP2EN2vRNh94r8UEi7nZ68cglJngJAjyqqRUwC8yaNWybTDbZro7bS1MLvG00UVRjV35SobaevMNk0PSmv5LYGUL0msHh5kXaVkuCvGZlc75bChTRNwpkHGQWcXzWNbMj81B3i+I8/cTL6Xx0D9EkAXuNMr5QqpSEfzYKhkAy/NTbKIQlldV9GBQWzqPJqX8Cyg=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007)(7416005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?1rbX/tAPUfKMjmAr6d9s8SyhDZyHq1WGGXMLiAtQ4XZaHpwkyBm9rJ5M5Ue+?=
 =?us-ascii?Q?PDXdDRsP3yB+GjSUlbnib2/V7wyYtaoJvxyLbmOHH3XgIMOwnSpDD80iSYE5?=
 =?us-ascii?Q?bROcE+J9hCXLWJcqWI1K0t2fvAiZlKIb1HclmHFVVRTG0PoDZ+ADxYNEwzEs?=
 =?us-ascii?Q?vHXNNI73ioU3w1d3YyCuSeRpwrVhgwPG73Bh7qUrMdvem4UMkfpvejgTnJsr?=
 =?us-ascii?Q?Dy/wQMyBd7G8rW8clUeQ1SD/j0r6vxm8AfR2B6kAZTMZ8tP60JGrY4VHk9m4?=
 =?us-ascii?Q?D3SR6hbMU/euJt7fJIF/4TNnjesUse5dGXBGVnIs2/dGZi/KavHT0eMk9pw2?=
 =?us-ascii?Q?WwIehzreqKq/M6L6gP/zBt7Af2d5xsMdY8vFVybiFf1m3ZcCMIfZUQKsRsHA?=
 =?us-ascii?Q?5TosUh/oibbTvd0ZbHzQCepr5g0LyByg4wgiXN33Z00bUyxBrT/cWLgSkzoa?=
 =?us-ascii?Q?q3h51f5F99myjFL8HMD5q39g49fz+yj6D7ps0YcDTtHcf2+Ya9CWcMsdWbdU?=
 =?us-ascii?Q?fCwoCJ2faxD4Y4Q2mVeZYi80vSwzviBadwIR1ffT6hyCQZx8IOfB8d1BiT05?=
 =?us-ascii?Q?62Yl2SfZnPGM0pmELP0YiDwQFyCepYwIJDjiECPvbZu2VFz0DqmABHv/bPVR?=
 =?us-ascii?Q?HuAEduGzVPrR0sK8pSibWEnenurUWauEXbfrqzjp3P6zFwEV1SW+KngL9YlE?=
 =?us-ascii?Q?KBwFtWkJnCpvO9g4kDEkPU9WMKQNTMoNbbBIincbwKggdVd/hdOsrULZNlHc?=
 =?us-ascii?Q?wbJVtpOtkLZRxvcSIP257hHT3J1LO9RjIw0Exc0sjaQpcisZfWNEh9ZSCmnb?=
 =?us-ascii?Q?eAjvNDgZvKQPbgHE+FZ8ROE5r/Xz0snGjYgyM8NrmNGo7RwPS0jahJDEmpY9?=
 =?us-ascii?Q?ti2tT1Yu0ZS1qQ2oZuZfn+LmkFBfy0x22w4yrL6azAGEQfdZCSzyte4QJs73?=
 =?us-ascii?Q?tyT77/p4/mOHeu2ND4JTz8eQcWkAsD3A4HcgNuTHGQvvFqRkCZRLEOwcsXtc?=
 =?us-ascii?Q?MNzz5hLlCmhkjPUzNaBpevAnw/0fW9BEVCY63V+IWhm7zZWY4P8RNZkHuIyX?=
 =?us-ascii?Q?k716HaD645cJvD0IjiMNIATmh2cF4ylnvlhUM1SYIuXZGJ1IPEtC/LcHvZrO?=
 =?us-ascii?Q?ywK5NG1AckX31/NRALN57Y8UOWFOYLyMr1mQNO/o4rQ49tTW8kR7LrLGI9O9?=
 =?us-ascii?Q?b6Vj+zZGm5BzINRZ6a+NkpNAl78+KstBPZatYgzGtKMiN/lRA8m1VjVFHUfo?=
 =?us-ascii?Q?QiOhkLSuj0+s37sI0DGAHBaJCgjXT+lnBjRF82t5gblz9eAkSYH2hYriYpLx?=
 =?us-ascii?Q?MF8djE7DAB1cZ/Y937RkzpqdXfhakuPgbqYYx8t0/NzvRPSbx2vKXvRMgo+K?=
 =?us-ascii?Q?b/cYkAlYRuiCxJ5Kqm01fqsi7bkKWorpc38+yyU57OFNuwsOOckPF3Kq+37k?=
 =?us-ascii?Q?2U1DMPTheIx2EiiXt1Per//cSHeep1z7HwE0m80Ps9SLP+KJHhU2SeF5k/1B?=
 =?us-ascii?Q?fxmT2xgLWR+Pj4yfAHGu29E0iNGsMu4562YLCNySkjZQauwR4h70h3sXq/7H?=
 =?us-ascii?Q?nQSmAeR4QqkQFqAJig6hM9IhMgyJ4ZbUkxp/+ZI0mo1s+DvwUvh0N4SrQxlN?=
 =?us-ascii?Q?gQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	pTG+c0OpV8VbGnQA9x4oOCOrHTmieeWXQffoftNveGlZ59YuM2ShyKRmvB3QG/ElgHSpHsXhpviaja/JQwsL5yGZCJQxQOYPyEUQFFh8Dbc2zegFKHAN2oYdVcUGMvG8mrykJYjE7h/cL10bNA6thfJPDOwVV87VgO75UkGvXA4I0arUwTfWkaVCH/ZezNNqPeDio2hqsnstXseUsB+EQ+98do63y9Ly149KCImfNFSRO/54VMnPIhu1ljri0RshjeIIdRY44Y/MTHS+xFL4Tg3AIXjX3w4fqtxM0T38i36+O5ynpRElo2M8a7APKC5b0VVjZDG1yFUf3o4Py03ifFaKSw/UH3gXkYfDll9Hn209IH0FOkTnbEzzz698RiBEpLCnUnLBcbkB7rfTkS2wHDrnRgMuCBz82OYNAYlGdErWf11r+Ldmq3ZE9trEgoqWj2seTjrlGHmkCTSJlZ4DHYeBzVRfLwe+EWcdINCVWd6rRitK1QyGN+6Gmf0rjct27zzqKBxALHW9Xm4fW1Qlv5hjQSTfEi5baMTBSRVywEU5D/vDLdIEX/O/CA3UojIFqKf2RNTRIfh3KNFfTkwWYu1PLC8AgkhGvDyOyK1QP2E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0592899b-9881-4838-fd93-08dc55c615f9
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2024 23:14:04.2444
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YjYpXidC2rRuMl9P77+Ut7v6ILFTSytgl6vVyw4PMcTCM8J4VzPTwiCszhzj2CiO9x+btY+xnxQnC64JamBM97xrNXJjTi6ziF8ow++cEQY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5868
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-05_28,2024-04-05_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 suspectscore=0 malwarescore=0 phishscore=0 bulkscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404050167
X-Proofpoint-ORIG-GUID: Xivgl_nI13iEgjgHJCptWL4kdF74p6Mq
X-Proofpoint-GUID: Xivgl_nI13iEgjgHJCptWL4kdF74p6Mq


Okanovic, Haris <harisokn@amazon.com> writes:

> On Thu, 2024-02-15 at 09:41 +0200, Mihai Carabas wrote:
>> cpu_relax on ARM64 does a simple "yield". Thus we replace it with
>> smp_cond_load_relaxed which basically does a "wfe".
>>
>> Suggested-by: Peter Zijlstra <peterz@infradead.org>
>> Signed-off-by: Mihai Carabas <mihai.carabas@oracle.com>
>> ---
>>  drivers/cpuidle/poll_state.c | 15 ++++++++++-----
>>  1 file changed, 10 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/cpuidle/poll_state.c b/drivers/cpuidle/poll_state.c
>> index 9b6d90a72601..1e45be906e72 100644
>> --- a/drivers/cpuidle/poll_state.c
>> +++ b/drivers/cpuidle/poll_state.c
>> @@ -13,6 +13,7 @@
>>  static int __cpuidle poll_idle(struct cpuidle_device *dev,
>>  			       struct cpuidle_driver *drv, int index)
>>  {
>> +	unsigned long ret;
>>  	u64 time_start;
>>
>>  	time_start = local_clock_noinstr();
>> @@ -26,12 +27,16 @@ static int __cpuidle poll_idle(struct cpuidle_device *dev,
>>
>>  		limit = cpuidle_poll_time(drv, dev);
>>
>> -		while (!need_resched()) {
>> -			cpu_relax();
>> -			if (loop_count++ < POLL_IDLE_RELAX_COUNT)
>> -				continue;
>> -
>> +		for (;;) {
>>  			loop_count = 0;
>> +
>> +			ret = smp_cond_load_relaxed(&current_thread_info()->flags,
>> +						    VAL & _TIF_NEED_RESCHED ||
>> +						    loop_count++ >= POLL_IDLE_RELAX_COUNT);
>
> Is it necessary to repeat this 200 times with a wfe poll?

The POLL_IDLE_RELAX_COUNT is there because on x86 each cpu_relax()
iteration is much shorter.

With WFE, it makes less sense.

> Does kvm not implement a timeout period?

Not yet, but it does become more useful after a WFE haltpoll is
available on ARM64.

Haltpoll does have a timeout, which you should be able to tune via
/sys/module/haltpoll/parameters/ but that, of course, won't help here.

> Could you make it configurable? This patch improves certain workloads
> on AWS Graviton instances as well, but blocks up to 6ms in 200 * 30us
> increments before going to wfi, which is a bit excessive.

Yeah, this looks like a problem. We could solve it by making it an
architectural parameter. Though I worry about ARM platforms with
much smaller default timeouts.
The other possibility is using WFET in the primitive, but then we
have that dependency and that's a bigger change.

Will address this in the next version.

Thanks for pointing this out.

--
ankur

