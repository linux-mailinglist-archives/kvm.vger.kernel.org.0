Return-Path: <kvm+bounces-25791-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B23596A9D0
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 23:14:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CDBF7B20FC2
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 21:14:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96A281EBFF4;
	Tue,  3 Sep 2024 21:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LBhneoj4";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="JZyFG3Ap"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE16E126BE2;
	Tue,  3 Sep 2024 21:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725398029; cv=fail; b=r/FZw+U3LCt8N4RH55xTE0AzEHsRXpUOHIagRbwQF22Z4v1aCmrIcMZUlW/j4U2MWIG7moCxtJ9uQTJhbHHX8jUtNJOwrmg8x8CSpiHXh/e0dOseta8B/rcjOZUtGsxuRUNboCRFPdJRCjJKBLziucq4/1V9eRxEvgl/MhOE6Aw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725398029; c=relaxed/simple;
	bh=/u2D51EfTUvfkaUlalnb+fSEISwwjF8McjcoKTPwjS4=;
	h=References:From:To:Cc:Subject:In-reply-to:Date:Message-ID:
	 Content-Type:MIME-Version; b=rDV95KwY0S2N8qHMRizl4irxdb+lSfKkQVAzhP09kg0iXW3eFM0F6AFu2ow7b41j2cioa0HnZbbLupQb2VgTQ6Ej8eyptE98fHa2kcCwu30QDRzCtfUR6/xsbiOMpx/wvEQtURaAGd6DWbA2jQHxrNe4/SBw8ik4jXKQDwnsHyE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=LBhneoj4; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=JZyFG3Ap; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 483LBZGU011945;
	Tue, 3 Sep 2024 21:12:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	references:from:to:cc:subject:in-reply-to:date:message-id
	:content-type:mime-version; s=corp-2023-11-20; bh=cMSIOtnEMc0bDc
	VQp/EsSYzURxHIX55ZoD9nZkAUHQY=; b=LBhneoj42pxJ6mhqdYPQI7axODKq6j
	bvN6tKF1WWZ/jXfiMIXsPjfnq70hObhg8nz7UdmKW9SIEiTVAiQDS3izBhs/otXr
	Ei7ktvrGScAXJZ9MhAv8emagRoc3QwpUUGcpTJDxRSDu5FTXkgQ6/PlPne786ra0
	2xWYOWTa9wGekYJekqxiVbWmVpJ/Z2ZgUoZuZN7Ior/+vgVeofYhQXaOCVh8E5X4
	sSLp/SqVGBJ9vPDZ77JV+fXqUtSMNVZNy3HrBBBVYzFMhs5gYev22ypUFWTKpQXK
	fB7D4R3o8ciuDtUbg0xcvkJ5ZXAFJcN5BKX4eq+KHQT3b/xs4NYswFng==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41duw7t1gr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Sep 2024 21:12:53 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 483JIYqg018372;
	Tue, 3 Sep 2024 21:12:51 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41bsmf8whj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Sep 2024 21:12:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EcxIt4ig9iWUh4ZT2m7X7jb+4Iml0akvdWgZoHI+6haA6RsIXh3MobmFJXdoSbxYucl0xBxE3BlI0LMp0xKbtZMHrJ0rrMGRnVWMUC8yHvDh5qR7kkbMf+DojnFe6hl/+g86dMjLAHSfAzeeW4vgj2Zcr7SCEOUk3e82fxfX/oxewyN3Kf1rNTfWIe2ZlOe1qJTb8JpQ0yxufXdRuz6tuvKlCcsk0Uv6C33+6PKv0aUJKc29acLe/rKIoK4gZRq6M7PXOuJId7+VeU++jUi172hI7Kp5V+eW0EE1xaKD7tg6ERBiyVwJuKjQ6PVWszOFWMsGWOM9l8gGSaLY4VgnAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cMSIOtnEMc0bDcVQp/EsSYzURxHIX55ZoD9nZkAUHQY=;
 b=OdVTPia01ts8ZYzTi7ssix4wgzbDuqszwEr4+Ht2WFEWEXMB3926zpGj0VdmL6rL/Rysy4R4xJN3w0IZV+6UkY41nUM1EVLRwbRfolD+AjobzYe55uQQp+Sq7DnXeXI6UB1x0CobTPi3XcQ1aW3OU5ejmDxtf76RdfM9k/3rwRH9739jWL2IeWOVD7bVB63gPXRdW80p0gS3CsjX8frYcbonmzBN2W/LEOTNiHHpH4t/HuWhaG93HzKfEKqBne8U1RAhrh2tyVttNMV/wyTRLXmuGWtANwV4JJIHo8mtHoOXvtI/YXQRVtxoOU3mlIxpSiUkBlo+hYSyMajAUW32hA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cMSIOtnEMc0bDcVQp/EsSYzURxHIX55ZoD9nZkAUHQY=;
 b=JZyFG3ApugzzqPbhBky/OIjq4EYwdBLr+L9JoT7SbAPfjEK5muOn4MO1V1dR2mNAC1siFoI+wolRfU+nObZX170xlvzEx9cIF0pf/OMdACeQOvFP/ZSU1js7kYQSoNsqCfSoM6QP3YKGmPbbAehZKAI1x3XS2f+xWsx7iIDssnU=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by SA2PR10MB4474.namprd10.prod.outlook.com (2603:10b6:806:11b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.24; Tue, 3 Sep
 2024 21:12:49 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e%3]) with mapi id 15.20.7918.024; Tue, 3 Sep 2024
 21:12:48 +0000
References: <20240830222844.1601170-1-ankur.a.arora@oracle.com>
 <20240830222844.1601170-10-ankur.a.arora@oracle.com>
 <20240903081348.GB12270@willie-the-truck>
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
Subject: Re: [PATCH v7 09/10] arm64: support cpuidle-haltpoll
In-reply-to: <20240903081348.GB12270@willie-the-truck>
Date: Tue, 03 Sep 2024 14:12:47 -0700
Message-ID: <87frqgo300.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0292.namprd04.prod.outlook.com
 (2603:10b6:303:89::27) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|SA2PR10MB4474:EE_
X-MS-Office365-Filtering-Correlation-Id: 368f7d0d-54a1-4ad1-8dc6-08dccc5d29ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DxEqfg10kCFrdAlbHXjD5NsxPPfUFpC6ca7sowESlg7974eSEZZWRwrJjzAC?=
 =?us-ascii?Q?Lp0FUUWeVKtDB5ARrrw1noMVUF5Pnuv/VuOiXJhnZy12my74YuhadNQ22Uk5?=
 =?us-ascii?Q?G1IKlc569kgeI51Ob+dB7rVCjHdbTShDmCw9upQAPtTK2366Ugkfj9fPFl57?=
 =?us-ascii?Q?EhwAlC6hCKa72AWHanZXuHmP0C710ngjNchFL/c125NKsw9RjlHRVEcORcJc?=
 =?us-ascii?Q?U+LUFCbxGCQ0uBWTvlqJ1KNW/GsLFLztO+iELXgMp3V1YaZdkm3TaAYkJZqn?=
 =?us-ascii?Q?szT0hAuTIyL5IHrygxRLGDWLvl+C++3B0uwbNU1ppeEJ/jiJxEFRqKKmkzqJ?=
 =?us-ascii?Q?iQItHZcSZWvo6RdAWxg7xvc4yheCQE18VGJaXUzjLuLFLepN2vz3I3Q3Y7PD?=
 =?us-ascii?Q?2MGt6QGEZydBtLI1vPROX1AQQZGepCk9CaM9EhrNgYfqhRTS9C80c8rduRIZ?=
 =?us-ascii?Q?NplDbgqscPKZZfoFr93celxFZf1osudidOp21F2QN1EkaU4Py4WEhZcCuZ6d?=
 =?us-ascii?Q?k2JJnG3GCNBsoV3GIWIYDjgbmIfk05XR6vxRebbrwg1pqb19hQUsbqj3W8th?=
 =?us-ascii?Q?yy+Ogj9DhaFeMbV90GeGJvHFOpUH50cCjE/jZeBOvjy0UYdy0yWJvg2QFi6P?=
 =?us-ascii?Q?+YmYKYn5YeN1Kw29YKfgwm9lJelffH/N+m8NomXY4tifKM4dapZrYFxHE67J?=
 =?us-ascii?Q?zLdogYk8ePfZeLxxH2Og7KrIL8djqj7eXSerY7iq+EFClGOMc/NqUHWFuRxh?=
 =?us-ascii?Q?oNz5sx+n9+j3dN/mHtOdFZIvQ2KuwGG7iQ4STgU9vF9hhEzvSf1DOytHomjR?=
 =?us-ascii?Q?DQw/P9vZ2ZJYXwT74vHVfYQmCC3gslG2EJmoMMV2/5WfyOaEK5EV48dgTIBl?=
 =?us-ascii?Q?3Mc7dxAQKjcuf3rH2I6drlLou82vsMQYS+8OsxQszipAXvzA14Qsb1Dei4IE?=
 =?us-ascii?Q?N1wzbSLsz6ia1Z265GR/z9mP1UyG42Om4ev6bfUYuwgWumhxQGFY7iecOmLc?=
 =?us-ascii?Q?/aZ5qAHtb9vG+P6FqSIA50wVnrVLG02Wlj1jOdxkSaSWqaJLfaUtRvp144RE?=
 =?us-ascii?Q?YUp6OFxt/VsHq+kx01MuY1HP8GW13Flw+EG8tTJvjVU7kq+9GeLjbj7xloZR?=
 =?us-ascii?Q?YgT/D77mrkegnCd2jsQIAL41nYrWajnvKaA9F4CiDF/DfvWX22rtg7zk8tSw?=
 =?us-ascii?Q?ZICuye7qQS2bx/8mbw6DlZJWo0ySyRgMk/GOVW8i6Ub8IJ8azU9RNwy4UgI/?=
 =?us-ascii?Q?qOvlM8lt8fEO7SteEvynmDBI/T8S5lZ6OsxMdlTSqXjaQBjCFARkDvkIu9j4?=
 =?us-ascii?Q?t6z4vg0Ai0q4BmBtdW1Cy1HpoTiSq3mHC0tTNxJoKUIyNg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?x4Jz2JSLMBzWYDxnk3IAE0LCCjtR++wgrwN7oCAXUGTqu1847rTNcgd8Mkwb?=
 =?us-ascii?Q?ZsdbXtO6c/HcLUhoO2Ja56f914RS/iyao7qJIBfmWZMiA+N//cWWfNjf6yaB?=
 =?us-ascii?Q?SurKXoT9PVcXjN30sg5JWPKQ9QCTOyCi09KLlzeHJ8RkX9nFHcjd+UToAYMr?=
 =?us-ascii?Q?JeruJskbbeEYE+N5HDPUigjJ9VjxC1DPYU6zwTMF/2E/A8nKNbLB5VHTL4KT?=
 =?us-ascii?Q?44FDzScGVkq6LI4/g/wywE9QRqUOpPUaWSi1nmVGCPmAV7z8/nXUmgXzXj5t?=
 =?us-ascii?Q?FH+sMWq6XgGMuFbTwfPVMa702HWYtsXjj0OhA7NmjY+bpHCicIsXth3nATW6?=
 =?us-ascii?Q?qc4lqhzU/ss7xrqKqG1QBIILYYjddHsFKcaX2yyIit7+07v6bbmKj9WGG+Wm?=
 =?us-ascii?Q?eIYO7jOaYv1F5GaqWgOCM8YTzIMzPkXknUO8vSjYe9fRwnCDznpwcElg+RbK?=
 =?us-ascii?Q?/n8hJopjRcnXnhIBVZa1uuR6qgGKclZ2YSYAY6FLGNgN6pj3maJ3HkAgl8BP?=
 =?us-ascii?Q?vyPPLPC/gELM82bVwPLRPkDsO0UmZq/dBbdDcc+1FBUF/IaLf+t3u87uZcX+?=
 =?us-ascii?Q?ey3Gf2m+I70GOq/DLWKlgCNX1iDb7yU0D9cbzHd/TbBvq5hQYJBlyO+U0iOe?=
 =?us-ascii?Q?3H6nSaceFLo7N/gdUHOBj2wdhtrlU0Zu0nfr7Vl1tJnCrbJjkwlg2x9DlVJG?=
 =?us-ascii?Q?uAvpuT3qLKuPZmPNRpGpY+kLTp3mkrcjk1SzuccSiJ7qlFHFTO3BXOHDUgNn?=
 =?us-ascii?Q?rRUv7BYg1yJ5DLS4S7eXb9Sva40WRXG+MeoNwCZhPDLaVU54y6gWvwNCCbEj?=
 =?us-ascii?Q?ILtqVX+g71AIRzlm+xL3TWRaTbHjspDn38tbvrkSctxdQrnZXdk22MXEH+S0?=
 =?us-ascii?Q?dILda6100wjHhHqKCi8h2wQ29Yjai9e8BNwcwuzaQHHCyrgRBSlR7DXQ4R2d?=
 =?us-ascii?Q?tUaS4/gtUzefQS8/mUIrWP9hRRr47Yr7MVXEruhzzH7eG3jEgt3QByobGyRU?=
 =?us-ascii?Q?Svq6o938GGGVSKqv8urZIoR2ER3SroToflj9CgvIXfiGhW3SGUjLoQmAfV+n?=
 =?us-ascii?Q?e5v+2b5QMhVuZiTh0wqyO2NyUJiU5akI+vK4rDyqxq+efXIpHVDjN/AGKHww?=
 =?us-ascii?Q?Q0nR1HgQNEdY/RLa+hHo08DdulGsjbN5pLUbNZXbdAZRf+aIUtV0lDVJQxM+?=
 =?us-ascii?Q?Tpw/RO1y1nhLcBlHFBfxLgGhS2lwfx8UIhogNCU422LK7XUZ1LS6fQ4Pw4pK?=
 =?us-ascii?Q?ifHZYiH0HoxAlVTUdZOR8E8nupKW/hg3MmLj6P2EUCKOC4oXASaO/1eIe4Yc?=
 =?us-ascii?Q?ZvVwmBNoqeucIFyscvLikbUl297TDlq8j6wtv43lst+GMZMLmQ/DG3UHeuJf?=
 =?us-ascii?Q?kS9fAClA+z9Z7pAYL+zBDkRpCE6gdVhS6DiqRL01TvOnAEU4v5o71gOCug51?=
 =?us-ascii?Q?FedCnmapc8V3ha4LKPqokQXuYaG2X1Xon6nZUy7qVXaB2/EK6+tU4fFouqst?=
 =?us-ascii?Q?UYU/IxlSBBTGpW2fc0D46tNczTp7qwlYpmnub/858XJBc1kkCCj7a5ZANzYa?=
 =?us-ascii?Q?C/CTG6enOG2VOgb7UD/i39p0tusexE8amYEpOJ4GvDiOkPAFW55tXukzlbW6?=
 =?us-ascii?Q?RQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Yd2vdYWk8aby7OBjjsa0tWqj8oL6gpEnsy3KfU8yklZohNOgNAKYNV31xRBM1h1GN1AOexo/0foc8BUN2NPsQ7OJ54pOpEx+a9f89pAvttoictUgQ8+PQlqXHX7kD9kZTXGjjbqhwAGkh1+LpMfY83hsBMFUdE7TY91CCrxP2Dm51vggd23tC46XnRKhIp6QEQuf6MeEfI8rabnl4R1gxjmKaEIdYgz85FAZksorBWzD6lxMHttR5q6e6oxiQcFGfQnkXQcR7mUYCUx0Ib9LleKzv8ggP+YCVPLlAtl+WXMM1UKRgUuCsPappmVIq6xVue9HP4uWZLqpf4qj0E0Bdj8GE6qPBxKQbJzoWCCsZN38zNqurbjQoRBNjUSIdy1RMsuEyxy04KOLlE786vgQAlcrZRwwHgylwJyxdsjkGGVQ6F4duR4k04CJV5drvVj8nz2t37KhldWYQMsDVmPBBmVyPVs5W5RXkKQQfkGLvBL+YORDB6GnOhuuUUtdRqDxY8XYVSpSiwAX0fDrDbzGuvaOi5VK4YDvYsrxCby1zoQGHG5//ucnQKwizAatoN+Mv4+0slpRg1M0LJqwpXHz1AOrS93cjV40aLKrDlQrxlk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 368f7d0d-54a1-4ad1-8dc6-08dccc5d29ee
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2024 21:12:48.8870
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q6wG3DD77zvf1J/b3+n8S9X6NePTAGmuY2VFKQPAvnmAOwOq0joPTjr5F7/8YNPIvt7M6FHdn0r1xYTzaMNadQ9LJ82tLKCAYq9vzkdpyGA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4474
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-03_08,2024-09-03_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 suspectscore=0 malwarescore=0 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2409030169
X-Proofpoint-GUID: slEoaB1FACfu_B0-6D1M7u71gv03T8vj
X-Proofpoint-ORIG-GUID: slEoaB1FACfu_B0-6D1M7u71gv03T8vj


Will Deacon <will@kernel.org> writes:

> On Fri, Aug 30, 2024 at 03:28:43PM -0700, Ankur Arora wrote:
>> Add architectural support for cpuidle-haltpoll driver by defining
>> arch_haltpoll_*().
>>
>> Also define ARCH_CPUIDLE_HALTPOLL to allow cpuidle-haltpoll to be
>> selected, and given that we have an optimized polling mechanism
>> in smp_cond_load*(), select ARCH_HAS_OPTIMIZED_POLL.
>>
>> smp_cond_load*() are implemented via LDXR, WFE, with LDXR loading
>> a memory region in exclusive state and the WFE waiting for any
>> stores to it.
>>
>> In the edge case -- no CPU stores to the waited region and there's no
>> interrupt -- the event-stream will provide the terminating condition
>> ensuring we don't wait forever, but because the event-stream runs at
>> a fixed frequency (configured at 10kHz) we might spend more time in
>> the polling stage than specified by cpuidle_poll_time().
>>
>> This would only happen in the last iteration, since overshooting the
>> poll_limit means the governor moves out of the polling stage.
>>
>> Tested-by: Haris Okanovic <harisokn@amazon.com>
>> Tested-by: Misono Tomohiro <misono.tomohiro@fujitsu.com>
>> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
>> ---
>>  arch/arm64/Kconfig                        | 10 ++++++++++
>>  arch/arm64/include/asm/cpuidle_haltpoll.h | 10 ++++++++++
>>  arch/arm64/kernel/Makefile                |  1 +
>>  arch/arm64/kernel/cpuidle_haltpoll.c      | 22 ++++++++++++++++++++++
>>  4 files changed, 43 insertions(+)
>>  create mode 100644 arch/arm64/include/asm/cpuidle_haltpoll.h
>>  create mode 100644 arch/arm64/kernel/cpuidle_haltpoll.c
>>
>> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
>> index a2f8ff354ca6..9bd93ce2f9d9 100644
>> --- a/arch/arm64/Kconfig
>> +++ b/arch/arm64/Kconfig
>> @@ -36,6 +36,7 @@ config ARM64
>>  	select ARCH_HAS_MEMBARRIER_SYNC_CORE
>>  	select ARCH_HAS_NMI_SAFE_THIS_CPU_OPS
>>  	select ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
>> +	select ARCH_HAS_OPTIMIZED_POLL
>>  	select ARCH_HAS_PTE_DEVMAP
>>  	select ARCH_HAS_PTE_SPECIAL
>>  	select ARCH_HAS_HW_PTE_YOUNG
>> @@ -2385,6 +2386,15 @@ config ARCH_HIBERNATION_HEADER
>>  config ARCH_SUSPEND_POSSIBLE
>>  	def_bool y
>>
>> +config ARCH_CPUIDLE_HALTPOLL
>> +	bool "Enable selection of the cpuidle-haltpoll driver"
>> +	default n
>
> nit: this 'default n' line is redundant.
>
>> +	help
>> +	  cpuidle-haltpoll allows for adaptive polling based on
>> +	  current load before entering the idle state.
>> +
>> +	  Some virtualized workloads benefit from using it.
>
> nit: This sentence is meaningless ^^.

Yeah. Yeah I think I added it to take care of a checkpatch warning.
But clearly it doesn't add anything useful. Will fix.

>> +
>>  endmenu # "Power management options"
>>
>>  menu "CPU Power Management"
>> diff --git a/arch/arm64/include/asm/cpuidle_haltpoll.h b/arch/arm64/include/asm/cpuidle_haltpoll.h
>> new file mode 100644
>> index 000000000000..ed615a99803b
>> --- /dev/null
>> +++ b/arch/arm64/include/asm/cpuidle_haltpoll.h
>> @@ -0,0 +1,10 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +
>> +#ifndef _ARCH_HALTPOLL_H
>> +#define _ARCH_HALTPOLL_H
>> +
>> +static inline void arch_haltpoll_enable(unsigned int cpu) { }
>> +static inline void arch_haltpoll_disable(unsigned int cpu) { }
>> +
>> +bool arch_haltpoll_want(bool force);
>> +#endif
>> diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
>> index 2b112f3b7510..bbfb57eda2f1 100644
>> --- a/arch/arm64/kernel/Makefile
>> +++ b/arch/arm64/kernel/Makefile
>> @@ -70,6 +70,7 @@ obj-$(CONFIG_ARM64_PTR_AUTH)		+= pointer_auth.o
>>  obj-$(CONFIG_ARM64_MTE)			+= mte.o
>>  obj-y					+= vdso-wrap.o
>>  obj-$(CONFIG_COMPAT_VDSO)		+= vdso32-wrap.o
>> +obj-$(CONFIG_ARCH_CPUIDLE_HALTPOLL)	+= cpuidle_haltpoll.o
>>
>>  # Force dependency (vdso*-wrap.S includes vdso.so through incbin)
>>  $(obj)/vdso-wrap.o: $(obj)/vdso/vdso.so
>> diff --git a/arch/arm64/kernel/cpuidle_haltpoll.c b/arch/arm64/kernel/cpuidle_haltpoll.c
>> new file mode 100644
>> index 000000000000..63fc5ebca79b
>> --- /dev/null
>> +++ b/arch/arm64/kernel/cpuidle_haltpoll.c
>> @@ -0,0 +1,22 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +
>> +#include <linux/kernel.h>
>> +#include <clocksource/arm_arch_timer.h>
>> +#include <asm/cpuidle_haltpoll.h>
>> +
>> +bool arch_haltpoll_want(bool force)
>> +{
>> +	/*
>> +	 * Enabling haltpoll requires two things:
>> +	 *
>> +	 * - Event stream support to provide a terminating condition to the
>> +	 *   WFE in the poll loop.
>> +	 *
>> +	 * - KVM support for arch_haltpoll_enable(), arch_haltpoll_disable().
>> +	 *
>> +	 * Given that the second is missing, allow haltpoll to only be force
>> +	 * loaded.
>> +	 */
>> +	return (arch_timer_evtstrm_available() && false) || force;
>> +}
>> +EXPORT_SYMBOL_GPL(arch_haltpoll_want);
>
> This seems a bit over-the-top to justify a new C file. Just have a static
> inline in the header which returns 'force'. The '&& false' is misleading
> and unnecessary with the comment.

So, the only reason for doing it this way was that I wanted to encode the
arch_timer_evtstrm_available() dependency. But you are right that the
comment suffices since the check itself is not operative.

Will fix.

Thanks for reviewing.

--
ankur

