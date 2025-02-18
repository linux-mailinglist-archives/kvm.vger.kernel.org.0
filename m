Return-Path: <kvm+bounces-38495-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 54411A3AB2F
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 22:39:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 440BF3AB557
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 21:36:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70C2E1D7E30;
	Tue, 18 Feb 2025 21:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XSlpDKTS";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Tv1zRsnL"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC6571DEFE1;
	Tue, 18 Feb 2025 21:34:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739914490; cv=fail; b=fHOXc6CufbogVzU/9/yLPpjn4WbM0FoJ2E2iyI2QgFYITjcAY67dLEwGmfVbSLRCaFBJdVct8yD32WZhWnBiuHb9B86ddC6JG+c6+FP26Z8EUEETQn2iqdd97Iom9GlOgRugKx71f5tnP0n8hVS4l/UDiNKH4eopPN92d6C6kYA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739914490; c=relaxed/simple;
	bh=56R/cdZ2tLhu8p8xg5lye22c8LTfb8C7HHW/F4/rADg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QAsCzzQBFrHGvSaFiJd7IT57EbP8o3rJ82Yrxw3GXh1FwZTyhjVlaMlJjOAzck2j5YhWlsgi7ae2O+yIzpyvePNLM+UpcuqH4b+ZzTCmjcoWPelI9GEydzp4CqT+ghrL95AwQ7uc3rXvMCG9PvIe81GHkU92SudOeSmEo99aF5k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=XSlpDKTS; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Tv1zRsnL; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51ILMbaK001244;
	Tue, 18 Feb 2025 21:33:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=YjaCIXsLVo6rDKN6LW6YTRd54LO2D0GD+NLYgDHMJ4g=; b=
	XSlpDKTSOqTYHGFw0roCyJbHtJELKWecTanxe4LP2l7VF1NWBiJEbl/ySctpveH6
	b/WWUe4ZwQGNJx5lxrUggIClVeverwaqjF/6t2qPZKjzDivsng9qYQTxZEClT8kU
	jc2OR8D5hCZMfgBZ+L9oGGSPVJCS7kStQkF/tP1SxFR9TRJHoQGG3TRq0mejNc2+
	TFOpwDcNwo4scSOpJUgdMWhc1vl6qj6MCh+qxQrEtlUdUXEx3pu9qwec6hnH0xO0
	9o0GNCVMheDf17oSL60V0OcQwmNPt05F6yRj22dnK/tSgpgN1CFZ1fnhjeL8xD2r
	RfZFxY1odPxKjnd4LMXlZQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44w00ngah4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Feb 2025 21:33:55 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51IL61OB009698;
	Tue, 18 Feb 2025 21:33:54 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2171.outbound.protection.outlook.com [104.47.58.171])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44w09bmx5c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Feb 2025 21:33:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gh9dOTPCo/jrUjqQAjDnEWVb6bEPSoliv/11lY3IPeic7LrNiZ08fGvmyt1m8AduMwZAaRrNbfCeuV3fWLApbQV8llbEHsd++yqPGG5sUBm3M/gXJ30qnOmB52RHSNLNcKcRxl9oA4MzmlBCrqnthUYSF2NwpccAIOSpJ2UxCaKNnqddLEXtQ9+ttQGRgBGCuT2eErWhoPI1hPvFCohAj4FSFH9NMQPlJdHYmRAkPblMwv37uxzRiyuxq3rN4727c9ANJ5gNEaaSiCjI5T0DcoXhQqjm4qhi8qzDUtneHwAyOFcZT3ipM39adewu+zM0JBqFNW4MDUbfWoLiiaMMLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YjaCIXsLVo6rDKN6LW6YTRd54LO2D0GD+NLYgDHMJ4g=;
 b=FXIspIppGblGbMnszvaRwU3P/udSBOAeWA90I1JcdDeuNLXISiMcZd7b8XW252QhBP8gpn48Sg0eV+csjhyhfsYQL7gxgjg5LThM5KfSM7T9EYalvvLU5H0W4PKotMBV+RqEvFsSJ9dIvkYjZv86DWd7L4Ga09R1pWlhYnXkRbbLUIUTN0Xo53cxOnJrzf/hcWwmNon/+RyFMAcaGbxVb4t7vwe+rOg+iSC/kVWEar1o33XK15Y+31IYEuE3Lpe1gMliBk17NaFiiDjXz5qwwKigfawPPWSnb6ZQjbxylYFWs7eOThhQZDaf/v+Yh3aeznDEthp5j7ndXowOLtrfIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YjaCIXsLVo6rDKN6LW6YTRd54LO2D0GD+NLYgDHMJ4g=;
 b=Tv1zRsnLixigj50OJuMgQHeXKT+kFGbIpZhKwXBF4WMP12XJafRSNg941zqukjjoX4s1TQh1xdtsI3hRAl+iBQFasllRIhwt16IKmg04vtuoX7wQKV4LRm4kA54mka2xdcNlv7YYY5gYQSI90WX6cPg69xzANVLWV4CNEykUWrA=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by IA0PR10MB7275.namprd10.prod.outlook.com (2603:10b6:208:3de::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.14; Tue, 18 Feb
 2025 21:33:51 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e%2]) with mapi id 15.20.8445.017; Tue, 18 Feb 2025
 21:33:51 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-pm@vger.kernel.org, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Cc: catalin.marinas@arm.com, will@kernel.org, x86@kernel.org,
        pbonzini@redhat.com, vkuznets@redhat.com, rafael@kernel.org,
        daniel.lezcano@linaro.org, peterz@infradead.org, arnd@arndb.de,
        lenb@kernel.org, mark.rutland@arm.com, harisokn@amazon.com,
        mtosatti@redhat.com, sudeep.holla@arm.com, cl@gentwo.org,
        maz@kernel.org, misono.tomohiro@fujitsu.com, maobibo@loongson.cn,
        zhenglifeng1@huawei.com, joao.m.martins@oracle.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Subject: [PATCH v10 06/11] ACPI: processor_idle: Support polling state for LPI
Date: Tue, 18 Feb 2025 13:33:32 -0800
Message-Id: <20250218213337.377987-7-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20250218213337.377987-1-ankur.a.arora@oracle.com>
References: <20250218213337.377987-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0280.namprd03.prod.outlook.com
 (2603:10b6:303:b5::15) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|IA0PR10MB7275:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a047033-e59e-46da-cbec-08dd5063eff1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xTXec1EHTTtdw3Dvwflu5zbmFxhc/PcWSjN0zIxgT6DmbNuCk4x/VONcURfV?=
 =?us-ascii?Q?86tNneXjB3Rk1a/6x73dDO+/SL2yyQe0mGhNw5/OIepMuh3+gkhiODiX6xMd?=
 =?us-ascii?Q?3LkO5dmMXh0t3McrmeBC9SauupQU1jEbIAKGnJorULLC88Ox0Q9zPpXDx9Gl?=
 =?us-ascii?Q?J8syAcFkjLOnOUrStzt2fCj1xS5FMMJY9sGzZ7BTyL3MRS/LUx6eT2AA+ml9?=
 =?us-ascii?Q?AFG2fdARGz5ISGhXQ5y9FtXhdaj1rGqNuUVEwb5Q42hCnXp4n+qTtDRo+6pO?=
 =?us-ascii?Q?+YSPofrcvGpiZ4XOu7pSLnp0XArSzw1VfGdP2jU2pXUyExXioMwaDoGkb4Hu?=
 =?us-ascii?Q?Yt+CKilmq8MobRNyXuk/e795YNSgveMdmz3IhUUIbg3FVTV53qNYmsCCKTAT?=
 =?us-ascii?Q?4BWLtb2q88hebRStJ4hP4178UHuJddplslHgvdPnjIR4kMbXXF7LGEp8D2Gi?=
 =?us-ascii?Q?Wq1gg95prKr2RZTMdmJEOB5C6Bb8lGf6wCvzLOfOcugVYcvPnT4DkgsSvl5I?=
 =?us-ascii?Q?e0xJ7QJ/hDFdPITCXW4QJ1xrALL+ZA4W05gB7KIeufcxEBhfAT9DE9Rvz5Is?=
 =?us-ascii?Q?y40OwZ7rgzG+XfbJx9gLjWjT+iAGjV0BylCs9KZHefJZdTo68cNtqZEg/4SG?=
 =?us-ascii?Q?lMGUc0vaeruo1p4D7KAV6+ncYwl3ieKcGJ5AKhNw7V2JFx/N/YZrVCBYklOA?=
 =?us-ascii?Q?OdAJmXc3d2FisnmFyciy9AXy1pyBneMYjIVyUYb3LuLXID0+BIA1PzFASmix?=
 =?us-ascii?Q?ovXVt97EksC1J53lHbwrhmW8h+oV3Vym6YcnYcaf6T+J2XK/5tqK3xUqdKh7?=
 =?us-ascii?Q?Tl/P1wSefgPP04vral+hcPBiAASQmMnqeyqZwzHN2XZtLiVBeN2Bb+CZulAt?=
 =?us-ascii?Q?19qiRc+LAL/QguVWjzoP37FU7RBwuKlVvCvtirguDpqmRruNmmI2qizc4CRq?=
 =?us-ascii?Q?SSSarAULGskFu8/PsxI9hDIOtn+qgwZaekWvw8XPORE+8wzEsexYHmxRnEK9?=
 =?us-ascii?Q?fxE9jr4toUy0Y+zsyBwg9qLEzVTeiC5d/dlzl9kBBIBUbmkt1/XoTH/Bu5Hd?=
 =?us-ascii?Q?OxRcFg8ggm3cqoq3FfHwDlwsFxuCwavCbZXtHX40oazocIMF/Nq7rYnhVML2?=
 =?us-ascii?Q?7RGTcmMlt2F2GfYlZgVWYPlW6Q/DQUPsUm64UssY9lMeEdbcydWoxv0hknfF?=
 =?us-ascii?Q?hvl+YMW7BmJwqdzouHdu1ytk3CGczRwfKqEUcqNwTBytny2Lc1phWFyNrh3C?=
 =?us-ascii?Q?Co07ltZiUgqbsePBBOp2kNX5i//MYpW8eASkS5QsTbmTFNAQjm7SJwMrDbZB?=
 =?us-ascii?Q?uxyIqjtbPKsFG2BdyPkLC2AgII/FoHHPbbVnnlqjtdbHnHl46XX/XjARKHzL?=
 =?us-ascii?Q?wZkxNelOu6IL78fi9niAki2ioK1t?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nEAfP9HxTrPLo4ZVrZHklaab0Y26D8Oh7wDalShX/LpB4YrT1ITOTXE46lJs?=
 =?us-ascii?Q?OTv7iyAkGYnEvsQiRgsdsWa4VwVtdIVAIPCnIO57Do4M9oSE4+BsNcnN5QF+?=
 =?us-ascii?Q?uDWFovIVrYC2pNN8cabNwWiQz1Tl/hgVuB7bKYCqJEC3E+OaNuTgLPHsi5FB?=
 =?us-ascii?Q?cDqw5YDZHbSSGtUQlAczjKBF2ET4lP++X1kdGcfcwz/eVYCZgbq9n+yY9hSx?=
 =?us-ascii?Q?fFJ1iedemZasYjHjC8jShNfaNkgNXGfb7wxl3rd0szj106tJRYOSBoWuItQ6?=
 =?us-ascii?Q?KR30Gzr3z/JPt6Y8lD2zPtUIs6b6VTDFh0lXxkZwp3jA3yJtDGEV+dZ3CReX?=
 =?us-ascii?Q?+mpQO0LXWg6UC5rfvHBG9ujpt+h6hUKJZ1m+aZaJLoDX7HgvKRb0BvYtNxZ+?=
 =?us-ascii?Q?M804e2Bt9r9FTy/GjgRVxH1N4gIjAlw9CLDAYjrL1xoOdVZadIkbGvSbNuKU?=
 =?us-ascii?Q?YbgekgQHKqUj8rPWX+vfLMuwIScGYlYy2bTmDfJjGSpUwEzHY4ll+JUFT/Wj?=
 =?us-ascii?Q?EDtnN08Qj/9k81Aq3nsa2HaBJKr0SVfWhe/ivpqLzFBNJ4SjeBV/w4hsMkHq?=
 =?us-ascii?Q?6ZY5Tr4u9hw+9G8Y0XJKzt5fGy39xpB4RTYthAglQwqqmV20agRJYKOhnZCU?=
 =?us-ascii?Q?oRsza6RqBioBIqOOfYvXyRCTlk/t1L34bp8tEacld306LgGH9qOEJSwiuoY9?=
 =?us-ascii?Q?hCGyqSy1k4DgwvkWR6b4dPAc4kCeeAAsvgTCLl6kKmevI2xHAOSboTL7PFcx?=
 =?us-ascii?Q?hpFYvKNnuiJQ5bxrzq5eLZp1r9fLHpYyrvS/Myj4iPJRP8h5xgyIoRV1I612?=
 =?us-ascii?Q?0ee1m6jwcloOIAXAjwtf32agNMXw1f6wI6I/11x7CmTl++kSBomQrKmYybyy?=
 =?us-ascii?Q?CNkQ0GlFI/BuUs5cMQkFANZRY02LO5vl9hclzvb1zWVuM7znwFOYCNUDTUn0?=
 =?us-ascii?Q?JTHqQt+n1UyRxyEu+fOoIw57+ybeL5q+tXRztToYKfHRK/u8L4o/OlhpqbYn?=
 =?us-ascii?Q?VLtEROb15K8BS/knWEfRnHROrqHirfBLR7mrm7mYhyGf0ac6rgCocSExpeid?=
 =?us-ascii?Q?vZ0RpKjqNKQwZ3sM6HLb2CEFZ8RddDwLG/D4+y0eYNEBujsapflyW47LbsFl?=
 =?us-ascii?Q?kweAmDNowTbDZrtbJ2GLrf8XR9xvsio4dJCqBhef9kG5b9uLt+WinYbB3stv?=
 =?us-ascii?Q?eOpszv0RJkKA4URaYp2Lr8GpQi6EsIp7txHVu2i7l4XGNSep9qW/f3HI1Mlr?=
 =?us-ascii?Q?qn83S8gAmFh77hf6+ClFJkFgxx9DxYofweTcMOBOZkGBtoa577D+oNZ49B0E?=
 =?us-ascii?Q?QDcWYZ5Bqr3GgIacUVJpeDBdsoR+1t3ddPsVy1irKhvyXKbCpOjhwck3IkcX?=
 =?us-ascii?Q?izMx+wnHr4WfLWVLonm/vIREZgm/c2ocR8Ux2NGMZEvPsDbDev5IStKYvoGs?=
 =?us-ascii?Q?3igJ5p+UFLXQD+JoZE5jmWMNVbxowPVzf7gWOj0hJTod/SuPgu9DpQZq250q?=
 =?us-ascii?Q?LRaw3UxewQUoNCeHEPv1EP0lWmUYU998l3/boJhj2mAuFFt97NSSTjroGTVo?=
 =?us-ascii?Q?frvm9CRfooe/lyshyR9+ovXxGKHaRFhljj4j0cRFB+rVOx0ecTKYZn8RGwwb?=
 =?us-ascii?Q?Gw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	J4mmbY4WF3L432V6ISkke2URwW8hMTHuZjliZemUD+Pma2sI+4m+cdmu8Bc8UfZRXoC+pl9+0Bf1VfLhoaYP75eQbT+Lbz7U2jB9S9IgIK2QQIqynRBzpQZmE1bJth+KmUi5rfFIT9QHnw4APQZUZF4SmM0r4+oYBdiE0gvTnMc5QhU3y2+Yv6Q/cDFqv/vYgNtLJT1n5TgH9vUms0Z40ZgpqHHjyuVIdm6Jf+37X3XtfEB4X/zOmsFeDiJktynP2PjE80OLiCh+EfYBsh4IFvOYgOh7ubKTbLO840dfmqUxHJKdWqkBeY1pP6aaKfcjvMe/3FrS6vJMeqh2JF5UOWq2HdVCA2qG3F4Twx3Vm+3ZQQmdHWbro8TZY8Zn6rpFIU04lf0qEuKtveIs2ShwgF5nAJOjEkKoX2drVHwSxXabuPOE2jqvtRj5QgsxcYTQGorfwjoYK9XOQnVqZ7p42UbpxuxAKdmceKQzi8ySMZ8KtQBwMvnP8AKdE23acD/+mh2SdLiS6+ILJSD8LbfriMgV6xNom/WZ7XJzvKO1JMTx3vXJu8Iis5oCqBOjRt2nlsf6th+lm0RDCcGz5Rk1FPMsijeVIoW93KqKqK8GjFA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a047033-e59e-46da-cbec-08dd5063eff1
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2025 21:33:51.5362
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VwABAhwQsjkqFfA6OssX1BLeFx6rbQ6DiZdxidPbx4jum4jxNia5atV3qHMMhXJPm6MvN/6hq3cYmFb22tJRigHkPwhzKAT0muDHyQNfvDc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7275
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-18_10,2025-02-18_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 bulkscore=0 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502100000 definitions=main-2502180144
X-Proofpoint-GUID: dxqArKPnJHAnDfuGWMJqRn2RklFC97XS
X-Proofpoint-ORIG-GUID: dxqArKPnJHAnDfuGWMJqRn2RklFC97XS

From: Lifeng Zheng <zhenglifeng1@huawei.com>

Initialize an optional polling state besides LPI states.

Wrap up a new enter method to correctly reflect the actual entered state
when the polling state is enabled.

Signed-off-by: Lifeng Zheng <zhenglifeng1@huawei.com>
Reviewed-by: Jie Zhan <zhanjie9@hisilicon.com>
---
 drivers/acpi/processor_idle.c | 39 ++++++++++++++++++++++++++++++-----
 1 file changed, 34 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 778f0e053988..1a9228f55355 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -1191,20 +1191,46 @@ static int acpi_idle_lpi_enter(struct cpuidle_device *dev,
 	return -EINVAL;
 }
 
+/* To correctly reflect the entered state if the poll state is enabled. */
+static int acpi_idle_lpi_enter_with_poll_state(struct cpuidle_device *dev,
+			       struct cpuidle_driver *drv, int index)
+{
+	int entered_state;
+
+	if (unlikely(index < 1))
+		return -EINVAL;
+
+	entered_state = acpi_idle_lpi_enter(dev, drv, index - 1);
+	if (entered_state < 0)
+		return entered_state;
+
+	return entered_state + 1;
+}
+
 static int acpi_processor_setup_lpi_states(struct acpi_processor *pr)
 {
-	int i;
+	int i, count;
 	struct acpi_lpi_state *lpi;
 	struct cpuidle_state *state;
 	struct cpuidle_driver *drv = &acpi_idle_driver;
+	typeof(state->enter) enter_method;
 
 	if (!pr->flags.has_lpi)
 		return -EOPNOTSUPP;
 
+	if (IS_ENABLED(CONFIG_ARCH_HAS_OPTIMIZED_POLL)) {
+		cpuidle_poll_state_init(drv);
+		count = 1;
+		enter_method = acpi_idle_lpi_enter_with_poll_state;
+	} else {
+		count = 0;
+		enter_method = acpi_idle_lpi_enter;
+	}
+
 	for (i = 0; i < pr->power.count && i < CPUIDLE_STATE_MAX; i++) {
 		lpi = &pr->power.lpi_states[i];
 
-		state = &drv->states[i];
+		state = &drv->states[count];
 		snprintf(state->name, CPUIDLE_NAME_LEN, "LPI-%d", i);
 		strscpy(state->desc, lpi->desc, CPUIDLE_DESC_LEN);
 		state->exit_latency = lpi->wake_latency;
@@ -1212,11 +1238,14 @@ static int acpi_processor_setup_lpi_states(struct acpi_processor *pr)
 		state->flags |= arch_get_idle_state_flags(lpi->arch_flags);
 		if (i != 0 && lpi->entry_method == ACPI_CSTATE_FFH)
 			state->flags |= CPUIDLE_FLAG_RCU_IDLE;
-		state->enter = acpi_idle_lpi_enter;
-		drv->safe_state_index = i;
+		state->enter = enter_method;
+		drv->safe_state_index = count;
+		count++;
+		if (count == CPUIDLE_STATE_MAX)
+			break;
 	}
 
-	drv->state_count = i;
+	drv->state_count = count;
 
 	return 0;
 }
-- 
2.43.5


