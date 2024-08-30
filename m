Return-Path: <kvm+bounces-25573-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 15C9B966C69
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 00:31:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8ABE51F229FD
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 22:31:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D9261C3F2D;
	Fri, 30 Aug 2024 22:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QHGa7ggU";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="JNFkqIyy"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 606FC1C2DC3;
	Fri, 30 Aug 2024 22:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725056993; cv=fail; b=JLqwWWu/lEyLsQnWMFujsk/P7tzWs818Z5Iyvz05Nap4vb1CuCINy3yfV9jRCh2OBkhloRODnoQBOJb3FOdGik7UzXAPZxVwv/kFFFsGVrJ7+N0DDY1o6GySshz1bLsFmb1ONhSx9MZ3iA0LwvbwH4Zx9EyimkSaraDsTWjjMac=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725056993; c=relaxed/simple;
	bh=16Ox0g2XTqrLkXYGHS1C6or3p6Z8t2sgtas49lNJR1c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gHVqYfMY/8eDOUnHr/l9SH4c3G//p9/uSZcoYZDoJA4V6Pte5YX0ltrl6leScCLW6Go8k2N6LKznqkoMy5QwGK3lHFNHmGdGN4QH7rti3h7TQMRxiMTNVsmscB3vhmjyCm3SXCBAfTAMOwI4lmht6fKqEpeEgl39buIHY2Ly2xw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QHGa7ggU; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=JNFkqIyy; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47UMMUnq004044;
	Fri, 30 Aug 2024 22:29:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=Mo2zoceAXJnd91Af9whV7g7UPhyCEtT1xSWIMyddSQs=; b=
	QHGa7ggUWV5v0nbdGngfQnUjkJ4diE56krmENEQTh5FEbzNTFqQ7ROnzETrqCSVi
	t31jKZ6ajF8bEi0LskghlpOinVeq7aP8fbxE/dJDOxKSkvD34aq3W72lKH94TXsP
	Yw612CgXNunSKhptjCJghm2QBeS4grZfrhqYC1ZFkSW9/0JTzaNfX4BH1Kms1a3F
	k7WG6AUOR1Cfxzl9Qj1ULuIw7iY0a8YkI/mQHGm2tZiaO2dK2IO15JSuojNhyxKg
	ZEKIlRm7msrI+FC9BR3nn7Ae/D9yGQscFBKRHMz9K9/pTr6Qw9Vp+NG/ADCmz6i8
	taOwnDdSyCi/+r05grKJjA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41bfgj0wkf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Aug 2024 22:29:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 47ULj9dO009920;
	Fri, 30 Aug 2024 22:29:18 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2042.outbound.protection.outlook.com [104.47.55.42])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41894sjau8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Aug 2024 22:29:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KKT7enKfDhm2jtQSs69WMLjPH4XUmzWUipdQOE5ulaEdmLgQIOOsUKwCm78zVR4mUrI2KyYwjsrECqW0FwdGDMiRmB8xgEMjV2dD6UZF88SpNhLaPNWPhdye36t9cRCMK9+ZqSWCfAed1ehPaRBTT42G08SPgP3xMIniujnUBz1IgCyOIVWDI+dLsRAKEnBw/njaw4Aa47qWrguw/YzsxVEA8dvB14agzQiaXjE19usGKIOsYXxznpLCjue5ISqkYfgxVqEGQcJxyGCyQNcF8/alj/WA+jmosEH66gZxEsnKEPb16kjfc4nLHQWv8+ZumwCuyqYk7XdMxbLLKEdVHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mo2zoceAXJnd91Af9whV7g7UPhyCEtT1xSWIMyddSQs=;
 b=u8IgIvAnwW/bilN4OiJwuDH1lkQczYgOeAyIxVl8WIK4AmH3Kfljqu8PWM21yV2etTWSRK9hO1uQWskzzIx41tJeFOqiiznXiCaLVORyJ90DVDDJAKYfw2IOsxXrMMew4Ywmo1jldLzpdprR4Cs20GlnINOc4qmg9B7n1u8ceQqKRJmcRNBk82c72sjAIjY2fmiFr2xIM0VVt9CHhZbu0adNUy1wMZ7wlHWcaROZztGsCQT4wRUVkH0igKims0WF5yZrYuy/me/Jspbynp+NOb/E0rXTSPNYXVGrNhhRuCvGY+LCkT44WEp7UgAezJTyoXoZ6+znRENLVolKLTDeCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mo2zoceAXJnd91Af9whV7g7UPhyCEtT1xSWIMyddSQs=;
 b=JNFkqIyyx1l9ihLtvfreOqhSfFRveJ94nTiM0rfxRWqgU8VTds+451GQpzTGJm+jRpZjNJtDEW0k4RUtQokqs9S+uSFK2K9UB7LCiwv1B/EUqHbS6Z/e1XzH/Q7aPeyZdpwwFuRiRfrTNG1KedbakOZ6wsOa2eZFPVNs/yqRJHY=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by IA0PR10MB6771.namprd10.prod.outlook.com (2603:10b6:208:43c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.19; Fri, 30 Aug
 2024 22:29:15 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e%3]) with mapi id 15.20.7918.020; Fri, 30 Aug 2024
 22:29:14 +0000
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
Subject: [PATCH v7 09/10] arm64: support cpuidle-haltpoll
Date: Fri, 30 Aug 2024 15:28:43 -0700
Message-Id: <20240830222844.1601170-10-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240830222844.1601170-1-ankur.a.arora@oracle.com>
References: <20240830222844.1601170-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0007.namprd03.prod.outlook.com
 (2603:10b6:303:8f::12) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|IA0PR10MB6771:EE_
X-MS-Office365-Filtering-Correlation-Id: 64876a3b-8760-4d9a-0b64-08dcc9432d67
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Rhcjd/L+IegoYA7KM1LMYFwlohf1RlUX0PoWQ6foQIFoP7BhTiiIp8D9hz29?=
 =?us-ascii?Q?3ZPw+QxidYdVZeUtlNzyLetVZczL7ofa0/IcGR9KINUVCV5RAB86RHE4SNUR?=
 =?us-ascii?Q?c6ObF4jaS66Ue+dSlqjv6aA5p7na/BAtGRrDCWTwkq/3tT1RffdA3ova1QhM?=
 =?us-ascii?Q?Kk7PC/6lhIJ15O3OXtKnQ/VIZSgdzxsReaiGNqpqqIfIPj6AMBFdE3ldaIQu?=
 =?us-ascii?Q?+JE9G2/VltKjkoNBXjDXJ5Oucez7wjtc/11mm/2yb9MWmsG+kSUFcItI9zeQ?=
 =?us-ascii?Q?2inHake1CuyiNLqzRwvRbhanSuDts5fgqoy0CHNRsZM3IMXeCyDh9zOsU7Ag?=
 =?us-ascii?Q?15u0k8mbINawydYI3U5xmQpx3AUvT8W3P1rLkLV1okB/psFR4vTsxi9ACfXh?=
 =?us-ascii?Q?eweCtCvaG6xDkUqICV8G8q70i0EO9dtKYti4NPgpS7vb1q0u1G0p3tcPaIR5?=
 =?us-ascii?Q?NN0tmPlJ6yo1snLUYmIVREO9O9icmckCa5Isso1zuPQn62otk3WDjy57xf+S?=
 =?us-ascii?Q?8YIrvNrq4VIqQbz4v5alJa2QEoGeudfpYW7cZaKG2ralDXUHsMLkWMcQN23V?=
 =?us-ascii?Q?MFLmKzH+VNZ9LEPudzBuc4Igpe4pYDm7NlPcLH4CTeZsRnwTBmswc7nRXa9J?=
 =?us-ascii?Q?rOI0zHHuGOQGQAHBwgyLjxD0rfGsCXdz4bAgKRa+1a2jj0EWecp4zOAYDFC7?=
 =?us-ascii?Q?XUUv1SA3I1eCnJsWbBHhy/eSPaaXoiQdfGIf1KU8UeHqvVXENwYIqLbIcVJQ?=
 =?us-ascii?Q?4/t4MmFktRMf6e9ODPy+C0Yg27fWLT3nvdYlxGOkc/7oPRUzbVqN4gcGD/+7?=
 =?us-ascii?Q?2hJozoQRhfIVDmiaxD5/uqINptxkfLqDd7ynGQ6NmTjBTmMaZgvvXWehsWf5?=
 =?us-ascii?Q?rCAdbi4ff/2YljH2oKslmF0YJnaWxbzrPdPwQImvvy0EXscmoJpSrUpC1cJZ?=
 =?us-ascii?Q?4PJtykOzsMJUMp/iUqeRX9I5xYtqV6DE3vg82AEl2VdLgYvW4F6SnbOjf+mb?=
 =?us-ascii?Q?QQ8zmqE/bUmsJKjsOfW8N2PsaW3hzPgS0etMzVPQ5K7q/vrLl9hzAJeb1UQz?=
 =?us-ascii?Q?NCJ33daP4K1PP7ssi/rT/lLygkfHSw+Xw/lq2Y/6kuuu5exewL69F0H7piHP?=
 =?us-ascii?Q?JWTXBFO+S4Km+Cq+t0Nmb62AV8r3bAwxGY3aolwUgtlxsSLa4Ue5/ASXNJWi?=
 =?us-ascii?Q?/g+UgLLnQg8YjZaZTlReOCcHBFvL8ZG5Ek6JKEIp3rW0Y7IXrdXbmvPPCIHI?=
 =?us-ascii?Q?IlDb6nGxxND2J7Y4jOU1ltbp1imKz0Y3MUSUK0gp2EqrU9gEBZYSWBMuSDir?=
 =?us-ascii?Q?KbtM67Mhi3DO8xK1DEbW20Glz4xM20KSub3YQFneZ6+YaA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OFQQOQmcUzGCPerULB49jNDiOpb0yOUfm9JNf19G/oZTjfKJ0A/OhkLyt5Of?=
 =?us-ascii?Q?jEtH1UB2/hTm87mKHac9hF3c73ZNPdTLT3ZMxQMSx0AvAgavm9L4FT9Ce0Rc?=
 =?us-ascii?Q?SvKkslLG5A2ftak+X2Pw6VmOdy1aU+0rSQcrh8oCaZnAjFqKZCRnffmjqxCw?=
 =?us-ascii?Q?4jePRPf+gwArZpPg+9jcXXdNp/9S/dhLzn48KhFeKFwj4PBYMLMWpZhNWwjT?=
 =?us-ascii?Q?0qpIYXdG9QFJgWXJAxdrkJ9VJyzf58/RLGB40k33nfspuKmIMb4zf2vmLzqg?=
 =?us-ascii?Q?kCVtpm2ICYlHYj982gAE5hfNKPqFeRROTABJQcmR1VRxbrkfJTC8ELhWwHF+?=
 =?us-ascii?Q?1zyuF4HDvMSBJh8SMrVCbgt+B2xG+Qwwdak2BVPWIWmQSLbGRsT9FK38xxRk?=
 =?us-ascii?Q?WhPaEgO7F/ZiXP1FItkWujM55GonM+CHDcoMWvsNnUfKu8DNVjQtY10zSH9Q?=
 =?us-ascii?Q?c+vcdol2XWl4cXUALPSHjtv813M6eg7hFNEMJsmZscjo+CCEaFBbpqA2W7wt?=
 =?us-ascii?Q?7ZtGTQo1wg6CToJwsJGZFJjsddNQ9oM2jE/pMSakVi+rtHmQB936yM7WXwZp?=
 =?us-ascii?Q?2bbCnIlb2+uGUFEmqB4+4qssPeUQFMkm7lFtRT1TdBJdx/TJw4v71DTLs0D4?=
 =?us-ascii?Q?sG3F5YVMZuXobE91HlQm9vuyAYK7SKN3aVDi2Gm3ju8Dgje4DCJDxMf4J16n?=
 =?us-ascii?Q?mQMAcxaS4Vu5Aqk1oin6gILxC37xIzHgyqh+55chI6c0Ph5HOQ6qq3csORos?=
 =?us-ascii?Q?6LLUMqM7NBLx1Dwyzpwkh2NUulHltGXOeqLc92oV1FUdv3vJa093HQMRk5gy?=
 =?us-ascii?Q?tW/ur1aC9+CTl1jMR386hMrK3G02mLlidkYMMUgsIAjEUqU7/AkLk9C20kDR?=
 =?us-ascii?Q?dbWmGBXt/zwK5rdcqYycCDMS6DGtkQrn6wSdpo5DaiXCnftvBDDGLqKXshoM?=
 =?us-ascii?Q?Fqnhb0kWBCZMnWw3aDoMGcv0cDBOp8h1j0Jvcv4TeAfi+1eWSunIHezh2PX4?=
 =?us-ascii?Q?ye0+1TkHUoTPPJYDqGhkj+g9In+/AP8nswHK8zGpcoA7pZ5WVdSDvQADWRu3?=
 =?us-ascii?Q?+vPKAtwkI9dOPQD8KzQ36DdHzQ55U9lOe8fYQUll3Wsi4lOBKsM2hyCYiepF?=
 =?us-ascii?Q?Tet/eGwnt3mpQHv0FgryPSXYhBGcA6FHO20MbEMj8VQ0RdjaS42PkQH6U6kN?=
 =?us-ascii?Q?XCVDcTfBRbkQuJPvXzrdrbi1Mj53ZaO9D1oVoV6V1rcyI1ds8t1B9f4xRyqq?=
 =?us-ascii?Q?TZAjo2iDxwBvvfBPd0NXzZIXJ4c4+bS7q5fyHJbfyJpU0s6WCtNFZ27UTo8r?=
 =?us-ascii?Q?0jfM7JF2uom3oANQWRV+NkLJezk4XOYzqJ/zPTD48Ml01gAazhnZ+FavVBz9?=
 =?us-ascii?Q?yacnw6zZxMRA89qZgzQBkav9Z1ANeOOPOPQ0pVy6jxNJVx7i3wpdOqmisPjV?=
 =?us-ascii?Q?q2Nx+6TTKhLZMRKywWtLrxgEe9YQYcPIc1DLwjNim9IJ5+KsrWVMfEp6MYAw?=
 =?us-ascii?Q?hs4YzycIIAGH7e6NdKFq4WgCdaCGShmatPXgyxufmW99apL/ZeKe6LQXwfIY?=
 =?us-ascii?Q?IQyDfm35uN1D+jOluey3hsfTdswnNwdTJDUQ8PAUt/D4BK4GuZt8cWwXind1?=
 =?us-ascii?Q?Cw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hZbwkjVY9w4c1MdNKcgG8fFVBCzMrNRIX4u7d6pGn7glbBu0zBhheyzH2KoHQhNd5LfENjE2cLMjLNAQ812mp9tWd/jgJJNvlfoAq5I9LC86bn8cKiwmhX8dJlb/jgbWaTxluCprV9fU5W/e61LtKfz18MRXCEAnTUMqUh3BMAWOd16zy2yPke0BhrO/32lHrBqRwa4T8iqA1/G+iLkOnEdy4edBpNUtXfOq0JyxSD596Wbh3c9jPIvmXM3GJr+NLGsZAEqBFoYPtR4yoViC/ukJVmiKUv2MtyJN15cnaAkEPUVrvfg5exdpPndOoiM26dqeyZJD30Y5OhEQpIMjQXRg5CCyf/cRFMWGrLoR9QKfUnTESRKr6VoGwhnON+8cJRS0Fq1RkbGDvg8IBXmOO2BnNbyYaMKQ3ghEsA6RsY2USbyJou7iKYPYCcAUCtgJTlJ36jtnBRNjPeo7WPUuN9htXvdUnoJLFXHkZdfollitFrG830w6EgV8Ck4qY7e/RUfbw0qMPM0EVxF3nmbcq7eTHLLy3TRNtVCF+aI10solLCNcxFHXRWK7wdn+fgGQKCdKweEijJ9qhw+k3MjaV3LgZZLNEv53DFM6pzj2qko=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64876a3b-8760-4d9a-0b64-08dcc9432d67
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2024 22:29:14.3803
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kTKlk5qWhqor+SqoOtJJFUjpnItBhaGHpN7TPYWsKqixAHE0NwrU6YcPwFDdPuWwYotLrmjKEBbeFVcP5iza00OIOYSI8awA5G7XXcWVQ14=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6771
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-30_12,2024-08-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 adultscore=0 suspectscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408300174
X-Proofpoint-GUID: kVC9Z_ZoR_oOeSUee3uYhVkMaVG1Jepg
X-Proofpoint-ORIG-GUID: kVC9Z_ZoR_oOeSUee3uYhVkMaVG1Jepg

Add architectural support for cpuidle-haltpoll driver by defining
arch_haltpoll_*().

Also define ARCH_CPUIDLE_HALTPOLL to allow cpuidle-haltpoll to be
selected, and given that we have an optimized polling mechanism
in smp_cond_load*(), select ARCH_HAS_OPTIMIZED_POLL.

smp_cond_load*() are implemented via LDXR, WFE, with LDXR loading
a memory region in exclusive state and the WFE waiting for any
stores to it.

In the edge case -- no CPU stores to the waited region and there's no
interrupt -- the event-stream will provide the terminating condition
ensuring we don't wait forever, but because the event-stream runs at
a fixed frequency (configured at 10kHz) we might spend more time in
the polling stage than specified by cpuidle_poll_time().

This would only happen in the last iteration, since overshooting the
poll_limit means the governor moves out of the polling stage.

Tested-by: Haris Okanovic <harisokn@amazon.com>
Tested-by: Misono Tomohiro <misono.tomohiro@fujitsu.com>
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 arch/arm64/Kconfig                        | 10 ++++++++++
 arch/arm64/include/asm/cpuidle_haltpoll.h | 10 ++++++++++
 arch/arm64/kernel/Makefile                |  1 +
 arch/arm64/kernel/cpuidle_haltpoll.c      | 22 ++++++++++++++++++++++
 4 files changed, 43 insertions(+)
 create mode 100644 arch/arm64/include/asm/cpuidle_haltpoll.h
 create mode 100644 arch/arm64/kernel/cpuidle_haltpoll.c

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index a2f8ff354ca6..9bd93ce2f9d9 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -36,6 +36,7 @@ config ARM64
 	select ARCH_HAS_MEMBARRIER_SYNC_CORE
 	select ARCH_HAS_NMI_SAFE_THIS_CPU_OPS
 	select ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
+	select ARCH_HAS_OPTIMIZED_POLL
 	select ARCH_HAS_PTE_DEVMAP
 	select ARCH_HAS_PTE_SPECIAL
 	select ARCH_HAS_HW_PTE_YOUNG
@@ -2385,6 +2386,15 @@ config ARCH_HIBERNATION_HEADER
 config ARCH_SUSPEND_POSSIBLE
 	def_bool y
 
+config ARCH_CPUIDLE_HALTPOLL
+	bool "Enable selection of the cpuidle-haltpoll driver"
+	default n
+	help
+	  cpuidle-haltpoll allows for adaptive polling based on
+	  current load before entering the idle state.
+
+	  Some virtualized workloads benefit from using it.
+
 endmenu # "Power management options"
 
 menu "CPU Power Management"
diff --git a/arch/arm64/include/asm/cpuidle_haltpoll.h b/arch/arm64/include/asm/cpuidle_haltpoll.h
new file mode 100644
index 000000000000..ed615a99803b
--- /dev/null
+++ b/arch/arm64/include/asm/cpuidle_haltpoll.h
@@ -0,0 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef _ARCH_HALTPOLL_H
+#define _ARCH_HALTPOLL_H
+
+static inline void arch_haltpoll_enable(unsigned int cpu) { }
+static inline void arch_haltpoll_disable(unsigned int cpu) { }
+
+bool arch_haltpoll_want(bool force);
+#endif
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index 2b112f3b7510..bbfb57eda2f1 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -70,6 +70,7 @@ obj-$(CONFIG_ARM64_PTR_AUTH)		+= pointer_auth.o
 obj-$(CONFIG_ARM64_MTE)			+= mte.o
 obj-y					+= vdso-wrap.o
 obj-$(CONFIG_COMPAT_VDSO)		+= vdso32-wrap.o
+obj-$(CONFIG_ARCH_CPUIDLE_HALTPOLL)	+= cpuidle_haltpoll.o
 
 # Force dependency (vdso*-wrap.S includes vdso.so through incbin)
 $(obj)/vdso-wrap.o: $(obj)/vdso/vdso.so
diff --git a/arch/arm64/kernel/cpuidle_haltpoll.c b/arch/arm64/kernel/cpuidle_haltpoll.c
new file mode 100644
index 000000000000..63fc5ebca79b
--- /dev/null
+++ b/arch/arm64/kernel/cpuidle_haltpoll.c
@@ -0,0 +1,22 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/kernel.h>
+#include <clocksource/arm_arch_timer.h>
+#include <asm/cpuidle_haltpoll.h>
+
+bool arch_haltpoll_want(bool force)
+{
+	/*
+	 * Enabling haltpoll requires two things:
+	 *
+	 * - Event stream support to provide a terminating condition to the
+	 *   WFE in the poll loop.
+	 *
+	 * - KVM support for arch_haltpoll_enable(), arch_haltpoll_disable().
+	 *
+	 * Given that the second is missing, allow haltpoll to only be force
+	 * loaded.
+	 */
+	return (arch_timer_evtstrm_available() && false) || force;
+}
+EXPORT_SYMBOL_GPL(arch_haltpoll_want);
-- 
2.43.5


