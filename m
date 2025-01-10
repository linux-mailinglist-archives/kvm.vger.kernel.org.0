Return-Path: <kvm+bounces-35118-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F1273A09CE0
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 22:15:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EE8BE16963B
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 21:15:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1E33218ADB;
	Fri, 10 Jan 2025 21:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="f88xScYA";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="dACU2C/S"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDB4220896C
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 21:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736543683; cv=fail; b=POCjuGI3xxyXC5F94RtpVwveI48MHUD0PBX2dkz37/VUJBSj5yJueME1v/u8T1dKFn0fZH6UO3BrPV6S3WAAnA2hD6nWpalN2mGaGzg5plqOL5vkQ+NIBXmQdV+lvVqBZYlIAGGV09OpS4V3NRj2kGEiLuI+SaUmbeeNXu3pEN0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736543683; c=relaxed/simple;
	bh=Wa17K96WHsG+UwDL7GtcB408PTs+VpOZQSc9ceuddZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qwBNRQ7ZXGYfcQ/iMLpFhSesk/LNZVS2JUkQz253J3At+yEzkxtOvgKBiR1v3IHsdrT9KPWUy1Ls/fgOiYfKUTlZBwGzM74f3H6/xOcJhzPxcLyoV5wMgsA8SuF/VDJhBArFcWGpzIcW/f2Jn1uzS+mmwTdcG185hGQBoR7JWjU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=f88xScYA; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=dACU2C/S; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50ALBqWH013668;
	Fri, 10 Jan 2025 21:14:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=K+SxdrdX1InTxo5zQE56qa247cTBfeTJ3jhGnfvxBow=; b=
	f88xScYA+7IlLEGACmOzAAk+catnPLUNjICpuTY1gzl/FoHS2XzZbGIenbeQAob9
	uTSfqQomZXIvoJCq3EG43mWf2NJ5uGW9koikmALOyrZdVy+xLr0GbEJmh4gu7xyz
	9wvqkUD4DY632I/A7uMs6e1k+E0OcisI/rAxoXx0X4ct262PjNUWi5HdE2nskLke
	TA49pJoBA+bYREwlfvzoYOHLoXpXQtWvHjUAyzzCwImLJnZQ36+f2At2K5iEdWLc
	8gezKd44nLEfcz6uykC3rU74gxRIzVqlNwH9FqsUnygwQAJoLknE/qDz47BqZVSW
	S/h9cQDpjIldka8y7ZNq6Q==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43xw1c3qfq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 21:14:26 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50AKUL48027457;
	Fri, 10 Jan 2025 21:14:25 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2048.outbound.protection.outlook.com [104.47.70.48])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43xued5mxn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 21:14:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Tnz773+lV5hRiLGEgVVtceUQHCOxrtbtAeWVVpc3hbTjsLvnxzyYHJF30foTsy3n5JXlTF3jpUwqQw4O5zT2B1cMQLDLUo4yB+z02q0JBHSyuO0cl7tP7F+vnKNFQ3NsKLlJt/R8Bvl0VIphLXVwxstr60/Lx2RFARVd228Ly7mkgwNzjGlSYRfeVXzC/HhuyPkFrMLmdU4L9S99pcs9z7Ci2xo8iyxLypedd+Vg6g/ZHsMJrb0nw739NFB18jFNyFMAips/Bj7gh8GsAJGoqQvSjdZqrkj/GtmMCBstnZTzNUSmpiBDBfnVls6U2htItd5rf6EXiY7+skHS7eKdNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K+SxdrdX1InTxo5zQE56qa247cTBfeTJ3jhGnfvxBow=;
 b=md6z3WASetaguBJ8U2BXuzgJnVFn9FYiRclsAPtV9Sj5EBrQEqJMBVj91sD+18D+O0k2TzXwyURbmUmhNSuxo1YBBTvwFQBaGmsyovgM2FrE8VXvhKDSXDD0y/Pc9Pam6bg+flVz897hH5W8sukD+8ooy2eSO7m6FPxcAxgE/rER005Oc6UQIZREFvKm360NaVfajxvidU/vA8Vpx146k8AXAwsxhC1RWuNbYTtSdNu6S4A1rJGy4tY8ZSdjEKpgfjrwfrfgcc75hDM9Psjr10lIpYPxEW9rB940oVeL45pUEC2VpI8S2UhFbacL0X2HYh2TTbXI9AhzoVq7Gly6OA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K+SxdrdX1InTxo5zQE56qa247cTBfeTJ3jhGnfvxBow=;
 b=dACU2C/SZWYVPiL5xa8o27b21nKH2cqNg014FkV3vgs67ddO60SC3qcqvN00hZy3+R8DX3koeRoPEWt8cbzWO7shQXeLCChxPGZQq00s2wKJRS3LQdJCghQlteav1cMy+sn9HC2ORmCZq2Hp/dbj/qTW31sM94KOVwxysBjoa38=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by BL3PR10MB6113.namprd10.prod.outlook.com (2603:10b6:208:3b8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.10; Fri, 10 Jan
 2025 21:14:23 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.8335.011; Fri, 10 Jan 2025
 21:14:23 +0000
From: =?UTF-8?q?=E2=80=9CWilliam=20Roche?= <william.roche@oracle.com>
To: david@redhat.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        qemu-arm@nongnu.org
Cc: william.roche@oracle.com, peterx@redhat.com, pbonzini@redhat.com,
        richard.henderson@linaro.org, philmd@linaro.org,
        peter.maydell@linaro.org, mtosatti@redhat.com, imammedo@redhat.com,
        eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
Subject: [PATCH v5 5/6] hostmem: Factor out applying settings
Date: Fri, 10 Jan 2025 21:14:04 +0000
Message-ID: <20250110211405.2284121-6-william.roche@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250110211405.2284121-1-william.roche@oracle.com>
References: <cf587c8b-3894-4589-bfea-be5db70e81f3@redhat.com>
 <20250110211405.2284121-1-william.roche@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0242.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::7) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|BL3PR10MB6113:EE_
X-MS-Office365-Filtering-Correlation-Id: a47fc1a6-29ae-4821-645f-08dd31bbc133
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yvV+zdeAGhhwfHGOhGR3xVXSwby9/MAVnmA+1PyvFPbnVBWZ8S0l6JbLkdKr?=
 =?us-ascii?Q?BylN5uN/gdx82ez6VcQqFqmKQzgasEd0/WNa9AwKTka9LayGGqRc1Z78KlGX?=
 =?us-ascii?Q?R7qjUUhy5qWM9C4FCwTtGDFsheA6Fi0BW+n88p26zjMJ+LPY13Lq+LXmQ/eF?=
 =?us-ascii?Q?8zibT7UY0oTBvjj6daTH+QNpHUNej9GpPakYpagipO8TqI0V6l5Meo3ZQYPz?=
 =?us-ascii?Q?uYIUAqqcLj+UFMNYGQP1zJvkhzVX1ryXUS3m0CVzshJ+UfkQn1KF4vkO+HdW?=
 =?us-ascii?Q?jczHaKhqV35lz5NzIjEF18DuYJJeWnsq1RDj22TB9CXaPsJvVPpq6azL2DYr?=
 =?us-ascii?Q?U5w1lwVJ41qcTfX1e3KeXuMHN2c13dDWHZG23TocqDN12ZGibOAOhcjHgQ+g?=
 =?us-ascii?Q?isGB9W0zBYX1KNX+WnSIbGmjpv57bbPo5zQzR9tG8HNEn/GfRVGzf2xZ1qdG?=
 =?us-ascii?Q?buWripukTBNtZ5LQTutLwdonnhL1S4EZKrZKDe/ccgpCf5wchUKg9Bhk+Y9R?=
 =?us-ascii?Q?C3Bm1HZu+XmqiU4al4pcTVuLFLb7ibV7T//Mp8Pfhm0ns8C9OaN/xFhWbre+?=
 =?us-ascii?Q?a7WWzyf2V4DSrmZHGMQg04cUWLFl2WJLK1QVhnK667dRHO8jlSDg1VxCuNZA?=
 =?us-ascii?Q?ymcfMXrgZK+OiVVIiHGEyHFjYMO68GoiuKsXmPDUavB086EbVmXQpp5d4seJ?=
 =?us-ascii?Q?RSL7OI21zvcIS9EeAKQrcyxa/angU293JulrzToXd9u+AWZBEXDWwHFUwV2B?=
 =?us-ascii?Q?fjBmMkLmdVl7DUBmPSsH4cCguOFkAbqvyhspffrJInu+ugJi4/UtPgMRRAwb?=
 =?us-ascii?Q?ASVs0aa5U76Un1yFQnrvB/3iTcLk+pqxZ37mw/+BN7A66HPBDRqSgwA4r0ko?=
 =?us-ascii?Q?kQjhjCzqLxxEEo+Ljvbpyd1pKixqbsTEGVJRez6s3DbCr89eFQxNXLcsuTpW?=
 =?us-ascii?Q?/bZ+4z1C9QruCTvihkw3WruvbrP7Jpw94+ErD6upw99mMtwQBRkW9FenxZEX?=
 =?us-ascii?Q?FaIfny2Mh+4W6NQyk9Q/q5CXhn5A0voDIvJkQNbutPE0Xz6CFfEThS21Zsna?=
 =?us-ascii?Q?Icnw/iZWboDIQ+N9lOCIhJCaARfsCbxVLnB8dGOIKlwXxCwYHNikM+8geEiU?=
 =?us-ascii?Q?p1VqDzhLWlnSWB+irj2GNKUpDCi6MD9zQRCkfi9z/2Jj9Ptq/F5aZqQINEZL?=
 =?us-ascii?Q?RVuGVkuVRa75sT7+IjeCfv1w3k7QtcC/GOrklOp2ZwU7dniTErF+xqu2Wnb3?=
 =?us-ascii?Q?5QqaqBF1+DuoVMbTplNmypQ8x5FKos7606wDNUkx0oA4pS4C9R1vLFN34qIW?=
 =?us-ascii?Q?9urmj/p8X7X6EGw4jIppSFilpiHKnDETZ4spCsyCgbXejSW3tdGPFdNhP2RV?=
 =?us-ascii?Q?QJ5TydACzt3Q223FGctVNyklEpwz?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yMNyJSXcjG3i1mGs7+fU2GaPYo6sbv79aPrC4i+dq3itOCFXLg0Rz/uilCYI?=
 =?us-ascii?Q?bDsySVBVgwb9fYwqz/RYr2G23ik0j39tDqlvKnhvqyxp1M3Qz/nBw2MJoWwK?=
 =?us-ascii?Q?vX2lgAJYlwZWHmgYchKdYLsXUlKfM/AMu0DhwkTO/JVrWflS9u/O01FbzCFY?=
 =?us-ascii?Q?91bay8wyrbFl1qtKaflV5ZJvUirsGalW6hJU38Bqhfj2qM69b2mythDmK25V?=
 =?us-ascii?Q?Phc3RDFoZRNYjnvZwteDGUnVIr1stKHYAmfDqzNuDMq5QP15xH5b+1mXAyU9?=
 =?us-ascii?Q?gKj83ze+TFUb1hF28Ul7zYWBDQIjS9uBx0Rp7mS4udFyENnH+p7ziUzSjYur?=
 =?us-ascii?Q?p6uB/uS1OLwTRIXvhisRLq+WLbwMci3qCbxnhbgRWCJG585pWe6ILUM+bM/R?=
 =?us-ascii?Q?SlRakruiQ5AmZ4U0SdsRaP2FWw15DfaaADBe+6FJADtb3o+aOxkiY7X8e/fJ?=
 =?us-ascii?Q?Hj/StMi/ejl12yUJbEiju356mM8oWdvlJQnjBIC7dcbsQLlGYPM3JjrP2xH3?=
 =?us-ascii?Q?xzg8C3WsdeRJSm0wsR139lh/kROL4KOoWrz/fZ7DF9dnD9b/fggZPSK5tnph?=
 =?us-ascii?Q?QSuRFoC2H29yutECa/4sKmzkhK3Zd7Qz5ymHtBWgyCP+/yg3Wa8XFgjoBoGs?=
 =?us-ascii?Q?lFEjhb9W3LtptKF/rr6z1Gh5+QL0pwD8jYbg9YzAwQKfHGGeZrWZganPnWTh?=
 =?us-ascii?Q?JJAcJutx9qsM383cfiqgTVi10g/JUJcCqDYcRzK9DvPGQyPsoyU6MUpp7o+d?=
 =?us-ascii?Q?9li/XLAWhDCTRUc+nxzOZi0K70mLbcdSpqiDcc8yHEcqMewsq8EUBGe6W2iL?=
 =?us-ascii?Q?OR+yV1RnPpKCosm+nmL9fbLRxHTbbqZtBnsgCppbZmsj/HUIeeZKUCRgkoH1?=
 =?us-ascii?Q?NSEbHmedBif3PZ/8yjDz3MuAWFoXWHv5V9FRCjlE9E59XN2w0t5U9jJFM93g?=
 =?us-ascii?Q?lQ/OELfa+2awDFrApFuZ9XptcoDXH7tei2JrLLSokRSDYIP9dwgRLyYjy2qa?=
 =?us-ascii?Q?saQJwx7hnBYVvlAR/SUgyD5NzF1eAtdECJ5/+CwKOm7BN2qxSx2ZHCxS4Vq0?=
 =?us-ascii?Q?42+j7R/LJSwduQA8mEWZLpj1/ytLG58gvKMnPIYItmx5BlJXo70/UCDnH/OY?=
 =?us-ascii?Q?LU1fBELWGsj5thh6D2MfHBDcLM5lD41iqU/zpetiCQTX2VtgkuzeWDf9Eo9f?=
 =?us-ascii?Q?ywu6+Ftab0zZUUvcTDfzI88dJr6SjKRbbX0TqX66x1+SIPpzkbemk+qOTgqG?=
 =?us-ascii?Q?kzy1ln5ffJlureoW6lBIGpc4zzpSons/eQJjyqfZZeQLP+8TisnKf7ofxec8?=
 =?us-ascii?Q?D14QMIlrfZzWsssA6QHxn1gxiVcpTPft7vp0F6MwL6/YfiPijUrha5tfufQB?=
 =?us-ascii?Q?cCUHjLtlxxI4xRzZhH4LTL7ibbDPnf+4SHw23FQOlAGmCvDPp+d+Dnid7Whx?=
 =?us-ascii?Q?E4VTFTTYsNRmTKVKJUJ+GP9zwkkc/VFO18gGbakkVAgEZek+e6Xz5Mv1bn62?=
 =?us-ascii?Q?e39zkxU/ibByLMEsJz8m80aMRzrxG7uG1SiQeOtbsLbVZn4a6bb2g5JPSzZO?=
 =?us-ascii?Q?hKr5jnt1nWsOGU1j+cfnb8cGRrMQ46+LIhtTKde48A2FGDj6xXyajrqFwP2u?=
 =?us-ascii?Q?iQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rSW7NpC8fN3QINjuBjdbEYbvQaAIFhVrjCWdTGErNUWa6qIGGZTQ/+18MjBB5oPJXzV3G2yuLTX/4BvJfepfdt6v3R9BQ4emuXb54Ov1ZwH0lD9Ab/CNeOF6l1E8fpqTqkUDRLhuw3l1WWjIf0jRLHK/EIpvoxfZ1zky9LP7kxRtY3tTfqElsA9++ghsZtBv4MoK3MLcQVp7ymfuKddqDZFLhvbpQZfV6p65wfXJB84ecc9ixsDJyC48IoPTXVFQ0k0tv3Z6sMCG7FEmoj4dRZ1dMrpgoHPrG/IHVa2LQzZjPJvgWliI+mbH04EtRPCEQ4bF01VK5+64RXrkw4Bl7dlJzDgWu0vhVZINYwVmKetIkrUC05IHrH+0c7TZwVn/gkG/lvZAIdRXJILGHvNPAjg/4H0KqPZEpyhJS5kemrpP52zXaKtiMLIJ4V25JIGiveUcpOZd+ymPaqRN9/iClEs1TMt5jW9H7wMjslsY/5N0Z6VbBo0XhMvy1r4AZ7hkz9+smvQrwbQGfLveJpT20+KOAyaozGWuCEhvpdqICGjHZieAUNZMaQ775LlAiVS4+1U9/dr5mJUY08Q/HwHIPeum3MhThsbYCaF8ErZI+bQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a47fc1a6-29ae-4821-645f-08dd31bbc133
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2025 21:14:23.1131
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G7BuYs1RyIVC3aHBZFLtmpQr9fZq9YGx/P8ZhsWxCypY0BLSbEgoo+t2LGm7gLmz9FQ1WIVh1+ehp3CN9RQnLFnR4/3xnZ/q5dkUwJJbBXM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6113
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-10_09,2025-01-10_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501100163
X-Proofpoint-ORIG-GUID: 3JXPAq0MZ4yX0Vf5SWOI_1hDPx4r2I1L
X-Proofpoint-GUID: 3JXPAq0MZ4yX0Vf5SWOI_1hDPx4r2I1L

From: David Hildenbrand <david@redhat.com>

We want to reuse the functionality when remapping RAM.

Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: William Roche <william.roche@oracle.com>
---
 backends/hostmem.c | 155 ++++++++++++++++++++++++---------------------
 1 file changed, 82 insertions(+), 73 deletions(-)

diff --git a/backends/hostmem.c b/backends/hostmem.c
index bceca1a8d9..46d80f98b4 100644
--- a/backends/hostmem.c
+++ b/backends/hostmem.c
@@ -36,6 +36,87 @@ QEMU_BUILD_BUG_ON(HOST_MEM_POLICY_BIND != MPOL_BIND);
 QEMU_BUILD_BUG_ON(HOST_MEM_POLICY_INTERLEAVE != MPOL_INTERLEAVE);
 #endif
 
+static void host_memory_backend_apply_settings(HostMemoryBackend *backend,
+                                               void *ptr, uint64_t size,
+                                               Error **errp)
+{
+    bool async = !phase_check(PHASE_LATE_BACKENDS_CREATED);
+
+    if (backend->merge) {
+        qemu_madvise(ptr, size, QEMU_MADV_MERGEABLE);
+    }
+    if (!backend->dump) {
+        qemu_madvise(ptr, size, QEMU_MADV_DONTDUMP);
+    }
+#ifdef CONFIG_NUMA
+    unsigned long lastbit = find_last_bit(backend->host_nodes, MAX_NODES);
+    /* lastbit == MAX_NODES means maxnode = 0 */
+    unsigned long maxnode = (lastbit + 1) % (MAX_NODES + 1);
+    /*
+     * Ensure policy won't be ignored in case memory is preallocated
+     * before mbind(). note: MPOL_MF_STRICT is ignored on hugepages so
+     * this doesn't catch hugepage case.
+     */
+    unsigned flags = MPOL_MF_STRICT | MPOL_MF_MOVE;
+    int mode = backend->policy;
+
+    /*
+     * Check for invalid host-nodes and policies and give more verbose
+     * error messages than mbind().
+     */
+    if (maxnode && backend->policy == MPOL_DEFAULT) {
+        error_setg(errp, "host-nodes must be empty for policy default,"
+                   " or you should explicitly specify a policy other"
+                   " than default");
+        return;
+    } else if (maxnode == 0 && backend->policy != MPOL_DEFAULT) {
+        error_setg(errp, "host-nodes must be set for policy %s",
+                   HostMemPolicy_str(backend->policy));
+        return;
+    }
+
+    /*
+     * We can have up to MAX_NODES nodes, but we need to pass maxnode+1
+     * as argument to mbind() due to an old Linux bug (feature?) which
+     * cuts off the last specified node. This means backend->host_nodes
+     * must have MAX_NODES+1 bits available.
+     */
+    assert(sizeof(backend->host_nodes) >=
+           BITS_TO_LONGS(MAX_NODES + 1) * sizeof(unsigned long));
+    assert(maxnode <= MAX_NODES);
+
+#ifdef HAVE_NUMA_HAS_PREFERRED_MANY
+    if (mode == MPOL_PREFERRED && numa_has_preferred_many() > 0) {
+        /*
+         * Replace with MPOL_PREFERRED_MANY otherwise the mbind() below
+         * silently picks the first node.
+         */
+        mode = MPOL_PREFERRED_MANY;
+    }
+#endif
+
+    if (maxnode &&
+        mbind(ptr, size, mode, backend->host_nodes, maxnode + 1, flags)) {
+        if (backend->policy != MPOL_DEFAULT || errno != ENOSYS) {
+            error_setg_errno(errp, errno,
+                             "cannot bind memory to host NUMA nodes");
+            return;
+        }
+    }
+#endif
+    /*
+     * Preallocate memory after the NUMA policy has been instantiated.
+     * This is necessary to guarantee memory is allocated with
+     * specified NUMA policy in place.
+     */
+    if (backend->prealloc &&
+        !qemu_prealloc_mem(memory_region_get_fd(&backend->mr),
+                           ptr, size, backend->prealloc_threads,
+                           backend->prealloc_context, async, errp)) {
+        return;
+    }
+}
+
 char *
 host_memory_backend_get_name(HostMemoryBackend *backend)
 {
@@ -337,7 +418,6 @@ host_memory_backend_memory_complete(UserCreatable *uc, Error **errp)
     void *ptr;
     uint64_t sz;
     size_t pagesize;
-    bool async = !phase_check(PHASE_LATE_BACKENDS_CREATED);
 
     if (!bc->alloc) {
         return;
@@ -357,78 +437,7 @@ host_memory_backend_memory_complete(UserCreatable *uc, Error **errp)
         return;
     }
 
-    if (backend->merge) {
-        qemu_madvise(ptr, sz, QEMU_MADV_MERGEABLE);
-    }
-    if (!backend->dump) {
-        qemu_madvise(ptr, sz, QEMU_MADV_DONTDUMP);
-    }
-#ifdef CONFIG_NUMA
-    unsigned long lastbit = find_last_bit(backend->host_nodes, MAX_NODES);
-    /* lastbit == MAX_NODES means maxnode = 0 */
-    unsigned long maxnode = (lastbit + 1) % (MAX_NODES + 1);
-    /*
-     * Ensure policy won't be ignored in case memory is preallocated
-     * before mbind(). note: MPOL_MF_STRICT is ignored on hugepages so
-     * this doesn't catch hugepage case.
-     */
-    unsigned flags = MPOL_MF_STRICT | MPOL_MF_MOVE;
-    int mode = backend->policy;
-
-    /* check for invalid host-nodes and policies and give more verbose
-     * error messages than mbind(). */
-    if (maxnode && backend->policy == MPOL_DEFAULT) {
-        error_setg(errp, "host-nodes must be empty for policy default,"
-                   " or you should explicitly specify a policy other"
-                   " than default");
-        return;
-    } else if (maxnode == 0 && backend->policy != MPOL_DEFAULT) {
-        error_setg(errp, "host-nodes must be set for policy %s",
-                   HostMemPolicy_str(backend->policy));
-        return;
-    }
-
-    /*
-     * We can have up to MAX_NODES nodes, but we need to pass maxnode+1
-     * as argument to mbind() due to an old Linux bug (feature?) which
-     * cuts off the last specified node. This means backend->host_nodes
-     * must have MAX_NODES+1 bits available.
-     */
-    assert(sizeof(backend->host_nodes) >=
-           BITS_TO_LONGS(MAX_NODES + 1) * sizeof(unsigned long));
-    assert(maxnode <= MAX_NODES);
-
-#ifdef HAVE_NUMA_HAS_PREFERRED_MANY
-    if (mode == MPOL_PREFERRED && numa_has_preferred_many() > 0) {
-        /*
-         * Replace with MPOL_PREFERRED_MANY otherwise the mbind() below
-         * silently picks the first node.
-         */
-        mode = MPOL_PREFERRED_MANY;
-    }
-#endif
-
-    if (maxnode &&
-        mbind(ptr, sz, mode, backend->host_nodes, maxnode + 1, flags)) {
-        if (backend->policy != MPOL_DEFAULT || errno != ENOSYS) {
-            error_setg_errno(errp, errno,
-                             "cannot bind memory to host NUMA nodes");
-            return;
-        }
-    }
-#endif
-    /*
-     * Preallocate memory after the NUMA policy has been instantiated.
-     * This is necessary to guarantee memory is allocated with
-     * specified NUMA policy in place.
-     */
-    if (backend->prealloc && !qemu_prealloc_mem(memory_region_get_fd(&backend->mr),
-                                                ptr, sz,
-                                                backend->prealloc_threads,
-                                                backend->prealloc_context,
-                                                async, errp)) {
-        return;
-    }
+    host_memory_backend_apply_settings(backend, ptr, sz, errp);
 }
 
 static bool
-- 
2.43.5


