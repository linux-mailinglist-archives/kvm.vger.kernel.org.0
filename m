Return-Path: <kvm+bounces-40880-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C8B7A5EB25
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 06:25:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4135F167880
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 05:25:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8751E1F9F79;
	Thu, 13 Mar 2025 05:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JoRxiiga";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="FcbZGwGy"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C5171D5CDE
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 05:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741843494; cv=fail; b=PDbUPC5RZlNDo+TBPkwqmPubHyoT8OxbPi+/wPejupNwO8/MFeJ85/gkjkYEBdqYDenUQbywUxlKOQatjC55arIYPpGt8DYRqYhkDUALnjuUwM41/Ashv0SMuVIsgfNFN152a3BAHl582OZBHnGJ74DjRPBr71zQZc2uJk2tnfY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741843494; c=relaxed/simple;
	bh=fXQuP+CYiFVoUf5gl0lWL2tWZvXpWv2SGakasCwhDW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pRCSSHDW85F9HOel1CIvYiYrYRZZGbx8jtnxpnO/c49QGVp1uOcq1rnvzst/PKvvGDgkHUBbS4kQe+FAVu/YVrv02DRKR6fRcI/TQ2GAPq1a4xKmF1mLAloEcrqwktHF4HQM1WDftXRplioC8iOcJ15vja93d5QG4/DOUEbFjtI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JoRxiiga; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=FcbZGwGy; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52D3tn8M011514;
	Thu, 13 Mar 2025 05:22:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=k/xDWMgD1Lw+3Lyvz3067UPO3gGox7QR/u/h6AifK4A=; b=
	JoRxiigaaxciRoCsQonFgL5PWgacU1w5/y+cNPNNGYM1HJzKLsRHCScarA2jcZ6b
	efCozpXR4wAhTjokWm2O+8BBLKvbSCk5TM9H4QlWxnelsIAFlZ+a0HaMUitTt31f
	Q/KJdQQHTwASvBcj7rKwGqXiCSvWCtbdKoIH178h6HRAfSO7fDH0K6s5/mYyohXd
	+JVAvgS8OboUk9wZQKgDL/XEdmBseC7KBEYO2HyWurFPnxB0YbKK28UeZXsY0KCb
	2DJtwyD8txJkj89Qj4xyLkGJq0JivjY7OaVMNCRLjxIb9OSVRsc8uhBunIUs1Pr0
	OG4Pn5Q3x/ioPLn5WznL1w==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45au4hbee2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Mar 2025 05:22:42 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52D4Lh8n022282;
	Thu, 13 Mar 2025 05:22:41 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2040.outbound.protection.outlook.com [104.47.58.40])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45atmw5mtj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Mar 2025 05:22:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ut/Oq6DCGEX/qiRiDL2AULxPBByhc5UWGy3WDAzi28HR+GRYjDvuqRUPSH7uOHBJqHoUg6IQfKOk484PODtRSdof2kFcHqLo54yBAD557OSYNdFMo0miWVUI1/awuR1Rl1YV4Mwna2yfThiL91mBnK1aa1zpQQX9IWztMZ7UytJEYFfQO2cRhvPR5/OBwPc72+pD2xMRnAEQQpH+y6fAgH8zSihCQiaRrTL3ZheCq35VmrdZmAjmLwxalwj3mOhM7eeXlGm7WPeMuaQ8rinW9cTxpU230kqmfvtSdtV51Ug4K1pRXVTyeI8sQIfz9ls2V6VMYGaO7uj7jCL/2+79sQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k/xDWMgD1Lw+3Lyvz3067UPO3gGox7QR/u/h6AifK4A=;
 b=wd+Hd+TyTaISC6AY5iBcnGo959hPRDd0rcfLYGIRRnwPCYANRi4PpehPNazU1ECLQnwauKcOYg1QAqOP91HStZizr6AHgiGBCF+85s+l3dINHhsoxLI/6j/VXeVbLw4VqGriJ0T46fB0Wo61qSwyjyYcZ2zw7I1nWUDoxrYizgftRCAfcchgf4FR1sj0KU5kinkd48PPiZtJOePLbjXt6L9FfS9tNvH+Gqp741gZWoIuqNDffKoYM6VTETZA8iBrPh8ByswGKSxlJzg4f2eNRhvoFR2hdJjRvxE6EMQkY+3smC66r+gI0CCgWTZj6eYc665OGokeW2kBq5vQ2ZzsTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k/xDWMgD1Lw+3Lyvz3067UPO3gGox7QR/u/h6AifK4A=;
 b=FcbZGwGyobwZPbjv4VgqC3IvOh0NnZITr719Fzhs3QCYQnTmi7N/o0PzvOtct/KIr1zSRcwval4fPtv1Rej1wDqZCriVo9d77f7DTZasW+zuR6FGwkxkMV/tBn9MWfHr55mXXj488mw5t3Pwynm7c9w3EAslas0DvAMjOHUsXig=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by IA0PR10MB6724.namprd10.prod.outlook.com (2603:10b6:208:43e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.27; Thu, 13 Mar
 2025 05:22:38 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%4]) with mapi id 15.20.8511.026; Thu, 13 Mar 2025
 05:22:38 +0000
From: Mike Christie <michael.christie@oracle.com>
To: chaitanyak@nvidia.com, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
        joao.m.martins@oracle.com, linux-nvme@lists.infradead.org,
        kvm@vger.kernel.org, kwankhede@nvidia.com, alex.williamson@redhat.com,
        mlevitsk@redhat.com
Cc: Mike Christie <michael.christie@oracle.com>
Subject: [PATCH RFC 08/11] nvmet: Add shadow doorbell support
Date: Thu, 13 Mar 2025 00:18:09 -0500
Message-ID: <20250313052222.178524-9-michael.christie@oracle.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250313052222.178524-1-michael.christie@oracle.com>
References: <20250313052222.178524-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH3P220CA0009.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:610:1e8::27) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|IA0PR10MB6724:EE_
X-MS-Office365-Filtering-Correlation-Id: 1df68a35-fcfe-4248-4d4c-08dd61ef123a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?x/UT5ATBGMWHIHvNUeyd8K2a+p/z9X79P0CobB1ksbIjJW//Tl2cMM6CWVIr?=
 =?us-ascii?Q?gp0rPFl1XlJ8AMbPjDY8kaBYWycfa0z4RY6JxXw6mXWMKMZGOHFt12KKsIkr?=
 =?us-ascii?Q?rTJ39gzufiiDSbpsQDmrdEutZVGzy7XY+D+L8qo2DmpGgyglSrPLJ/v15Ynb?=
 =?us-ascii?Q?yoh0vdaZ6kKbJR4J4U3nUWwMLkcBqupL5c21qT/TH6j3sZJe7mdPmKQsN/nn?=
 =?us-ascii?Q?/Ok4SYTlqdoNaIJKQVbTC1eMPfrSawlCNBkBBNR1yNz3sxvkoDvt02vGBJm5?=
 =?us-ascii?Q?lBkc/davLxPcT8cew56thX5TrJSYVWQUBfZ5PjIOGlsPL647yyU8pzj1L99H?=
 =?us-ascii?Q?zL268LHMxz50D6Qp39rmgZqFYYVLVuOdi7c8y/gkCrDaavkDMesBDBXI/Qt8?=
 =?us-ascii?Q?QXX0xdEyfEEJcxcNFOSe7UwJkqfpqBRoQacW4Y6ibKDgx+Gb3pjNPQOICRQx?=
 =?us-ascii?Q?ZmldXPE8zLa7LrKxg1276GPXpMYl0OlVzAFtLjAPb5DW7k23a/BsCK1dCVe6?=
 =?us-ascii?Q?I87LOElvK6QKgpDrecFu52WprXBKLHgqjV/NUWGqKlO1RnHMxYnggCrHWNTX?=
 =?us-ascii?Q?gQQddWKRijiKFoM2xA9jrqxRwyS29sh9SDcRyVbe3gRaD3CA4zu0WrB4CbXD?=
 =?us-ascii?Q?XzFiBZSwqLogBnLMH06M8g+gUJA0hb44qrwN0vytRGQ8K0u6KIzhiaB46KQt?=
 =?us-ascii?Q?fZ+kEhEFUNOTOcpSUWSoNTCxOPqB8edBEbenww2EXNISQLWXnJ+pJ2MRyxPp?=
 =?us-ascii?Q?X8TUmXA2xbqAqHiDHR3JjrHWf06aquRBygShL5bpKVLKS7njdbg2X9PrqAxC?=
 =?us-ascii?Q?2hOoxSmpDgAhJ6DemMJyX/7rapRV0Sf1JS+6yFuZ2lQioZS5olNKw5S+sozG?=
 =?us-ascii?Q?prACvPxinhgmc8fFZcSXBF8KEBYeETIfdcnK/XmRwTePpF598vkCQYWeO1ke?=
 =?us-ascii?Q?eAQ+6HK4D9tNKNzirgZba/6oOViuwk5hZJppaB/7R/HBie/8G3svXeDgGBVd?=
 =?us-ascii?Q?yisb+f40DbF/6dRdB8Qmi/xBhj1bldd0ot52XC1FmcmZy187bJDz+bttgB+4?=
 =?us-ascii?Q?O23ySjmvYdKzzFefYbMNBl9toKpFORiQhEIWmnHbtFqXLIqZiB+t3sHIP7Hp?=
 =?us-ascii?Q?XI4E39fcQYns/GveFCPR/AcwvaBkeg2N0E65l+Ji/WCO1MgvZfdE+QBsLQu6?=
 =?us-ascii?Q?5pVYoddSTIkKDw8ZnKxfLaVJi5XlZjnwq0gkFVyWND/7pXfSogPx5GD652IK?=
 =?us-ascii?Q?6tT4klv5wiaCN7NAsEI5k/01KQ7Yiog+PSyYJsmDKXyx+jYvUMvhhtJFujX/?=
 =?us-ascii?Q?TD6eBw/ygsh6F/OdM79DJ/ul8CuRWMGI6dv26qZLYlrLZ3aQPiY7H80jbxYj?=
 =?us-ascii?Q?vGqiFq7rUMqU+TpWbV0iS7J6hT+pa4Stf4PzccnQsmzRq9/vFLJJGwhcY+Cz?=
 =?us-ascii?Q?S6jfhjTIKwE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zIqZvqS7fH0e0nVOJopROtx6dlmuv215FsixzFBlEDRljbquqWk+pZo9dBgO?=
 =?us-ascii?Q?Dl8W224FTUkXGDWhanNH3fuRKqz+GgoPJFfnVTkTm+BL3ACPQTvfI/691UH7?=
 =?us-ascii?Q?SHGki4tIqWwj7EHb8RO+BcCV7wdCb1he2WnuKPT+ekKDA+y4HfExT9h06/C/?=
 =?us-ascii?Q?k0h6s6wxrwYV78JjGdGFrKIZiU7CD4d1M83/Rz1AHekAmvqr6KPhvWcMd8Nk?=
 =?us-ascii?Q?mGWSf/rcGoSuB3zp6ze3zkB3/V8G45B/+yFXqXNFRxzUbhRImegPbUQXa5B+?=
 =?us-ascii?Q?bFNxve2wyVIGOiFYmwwLqAVk8qzBYkhRNqmpND2wIKYAykZAet2CirJQAd8Y?=
 =?us-ascii?Q?kVXWYsQf7JjzrJWvPOnW203Eovaz4yU9ZE7enq074UTitMiB3+o+GJeGHE6L?=
 =?us-ascii?Q?aa/gg3C1j7ATNdqGkGAmlLG6qbotyBtvyLDYYLOQN+60IL6fKlLy9M0gGFqS?=
 =?us-ascii?Q?BwpP4USPV+j4nLhqMzuRjlP+6j6S3qRAFLJubiURDJWkhPL+5uA6rtAia/qH?=
 =?us-ascii?Q?Ge8EyBRqJ1XNhhFIQb0QpKR6/Zs3WPfmmTlnvVrOAaU/ykJ29G9hYomenEmn?=
 =?us-ascii?Q?dIRkK2jzQUr1y9JPQcZTI8Sqbm9DXaMwDnNTMx4jbuXwTfnkSvIEfbpZ6xcN?=
 =?us-ascii?Q?HSpaX4RVExkrJQhlVuvgCf9ckikYxidYAe2QKCvmz0KGLF1jFGaZ9ZVtTgNW?=
 =?us-ascii?Q?rA/fAZgcFVt0DoTPLCy6YuGK3k5qkPupG1H9IhyqwZ2jKHfpfwg/PMzZ0yPF?=
 =?us-ascii?Q?xr4kXmIfM6CBAs1q7+N1nagCCZQb+88vyjdwanT9/gIGz06JoYVPfhFROI0V?=
 =?us-ascii?Q?9Yc0Ni/mtxdIiYbAOSwCg3W2FolLIbQkSGjScLFVin8x8DqkvXN65pmdV1yt?=
 =?us-ascii?Q?M4Az0A6VMERkl8xKyJ+wYuwSo4Pd2mqkSzAHM4RX7HXetAR3WNtnC7QRWkfV?=
 =?us-ascii?Q?tJofqEeVcX5Y5c+6uHq2n6xuxfv+pnrFY5ry3MzkUXeIBstlvrd2wsMuiDvk?=
 =?us-ascii?Q?ethhOl8Oxj5itob4rF/kBPeic0+ogss8wTVKW4H/zbsnwi6U/kfrF3gUkxRB?=
 =?us-ascii?Q?0qz4lF9q39FXjbIo4MQdkvkzBXW99BNjUMdQvJUUJhaqvdFqHt1UDv1mRMfO?=
 =?us-ascii?Q?DfcjmpZ7PA+EQg0j+Bh74Jqo80RQN+4/pJ3B1w+HYqG+FOQIFAeYIgB3Dv1b?=
 =?us-ascii?Q?zijvJ/KrtX96pzB3jtt3Vnd/hBnVOZMy9lzJKgSMp5ywV0Xo3LbCCBZPVGqa?=
 =?us-ascii?Q?ghA/ZLeDNW43OanJvhi4CC8bQA9YGHLPqefvTGjuWBGsqR1buiE3t9J/FHgO?=
 =?us-ascii?Q?ITo0CXxe3Gmvwot3c+fe+BZt4Pp/r+dy27oCgmv2vzehKMJS8cUMRLwnnYad?=
 =?us-ascii?Q?f+93CsnWcNPF9hZEtrayzp2g7V+d/4LCqD1aKlbjcG0w3W4Fw0RxT/7s4M47?=
 =?us-ascii?Q?qgME5QudaudetXcG2HR+wiN35Qg+D84fpmvlVNBoKZzHW7VaE3kFar7OlhBT?=
 =?us-ascii?Q?aAOFHoPxHZo2M6zAm2pmsThaKRB1RxmaS7zNzVAsWGmGvRuSoDotbNESPPTa?=
 =?us-ascii?Q?8WQJakyi8UmCTFluenKCSr4avBCYNIagmZLZS9zXc5RevYf5pmZuXyUxuWBC?=
 =?us-ascii?Q?Zg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	4HDHe8TvAZOEmHmqd1//WRLZNIl9wXUeuJHIi9+TexGx6cmBDBngtMusqr2zHWcDGtKdIFEqZuKTmmPHYSeyhQG8YMrjFn8fsH3Oqga+6N23zvobV1vP2biJ+q1SUbSf/Zb3Qj8llt/CyZfc0CuduUlMDLm+aLAkAYjzagMYV2868ceqyEUn49Uemvh857T7/2u95yZt9lFOSWNmRIVriZqVKlGs4szcu3umV82durSNguPfvUryd7EJrDOJVuO/njG3rDKos5wdKM8lVrH++tabY8caHnlXnhQI1X6zdZL3d1VxZiNbh4KUhrcz37dzpM7/kgYUKjSBzP+phnBL9JQEpQeK26BGB3zN4s4FonJ85RVXdQzrd/JSkoRAyA5QoUKl+dcWtzkYrSK/yA3+74obM5ogjy+eBT0n6UyXQIhE02URrCTJbVmb3dAu8AWLOx5mn2HoD8EGIzGMshLj5Z4L8ifaLttNQQEZs5q/ajtu9NNsc/bq41ly7pmI36/3cWNvaL6xrR61Rv4AiNLB0yzsa9y8UCD3KCpWxcKH21KXRUeSdpEW65IQckweMi2eLTbgNDVXJlayKHW0zoMwIfWS7NwQ4dH667S6ZdjDy8w=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1df68a35-fcfe-4248-4d4c-08dd61ef123a
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2025 05:22:38.8210
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 73GW9/SJ6cfD+nbOrqJoiemWf82SCNi+AQ01NQNV54zYdvabN4Bk+e+auQIdm8Lb+/o6CTdAqnIAyCp1DfEX1CurYwKlF/U3RfJfP/f7Ils=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6724
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-13_02,2025-03-11_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2503130040
X-Proofpoint-GUID: _BcA-a0u_NYi_2Ka8Z_wPfFkV3eFX5yQ
X-Proofpoint-ORIG-GUID: _BcA-a0u_NYi_2Ka8Z_wPfFkV3eFX5yQ

This patch allows a user to enable shadow doorbell support and to
report that its supported if the driver also support it.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/nvme/target/admin-cmd.c | 25 ++++++++++++++++++++++++-
 drivers/nvme/target/configfs.c  | 26 ++++++++++++++++++++++++++
 drivers/nvme/target/core.c      |  1 +
 drivers/nvme/target/nvmet.h     |  4 ++++
 4 files changed, 55 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/target/admin-cmd.c b/drivers/nvme/target/admin-cmd.c
index 486ed6f7b717..e15cf25a4033 100644
--- a/drivers/nvme/target/admin-cmd.c
+++ b/drivers/nvme/target/admin-cmd.c
@@ -378,6 +378,8 @@ static void nvmet_get_cmd_effects_admin(struct nvmet_ctrl *ctrl,
 			cpu_to_le32(NVME_CMD_EFFECTS_CSUPP);
 	}
 
+	if (ctrl->ops->set_dbbuf && ctrl->shadow_db)
+		log->acs[nvme_admin_dbbuf] = cpu_to_le32(NVME_CMD_EFFECTS_CSUPP);
 	log->acs[nvme_admin_get_log_page] =
 	log->acs[nvme_admin_identify] =
 	log->acs[nvme_admin_abort_cmd] =
@@ -713,7 +715,8 @@ static void nvmet_execute_identify_ctrl(struct nvmet_req *req)
 		ctratt |= NVME_CTRL_ATTR_RHII;
 	id->ctratt = cpu_to_le32(ctratt);
 
-	id->oacs = 0;
+	if (ctrl->ops->set_dbbuf && ctrl->shadow_db)
+		id->oacs = cpu_to_le16(NVME_CTRL_OACS_DBBUF_SUPP);
 
 	/*
 	 * We don't really have a practical limit on the number of abort
@@ -1640,6 +1643,23 @@ u32 nvmet_admin_cmd_data_len(struct nvmet_req *req)
 	}
 }
 
+static void nvmet_execute_dbbuf(struct nvmet_req *req)
+{
+	struct nvmet_ctrl *ctrl = req->sq->ctrl;
+	struct nvme_command *cmd = req->cmd;
+	u16 status;
+
+	if (!nvmet_is_pci_ctrl(ctrl)) {
+		status = nvmet_report_invalid_opcode(req);
+		goto complete;
+	}
+
+	status = ctrl->ops->set_dbbuf(ctrl, le64_to_cpu(cmd->dbbuf.prp1),
+				    le64_to_cpu(cmd->dbbuf.prp2));
+complete:
+	nvmet_req_complete(req, status);
+}
+
 u16 nvmet_parse_admin_cmd(struct nvmet_req *req)
 {
 	struct nvme_command *cmd = req->cmd;
@@ -1696,6 +1716,9 @@ u16 nvmet_parse_admin_cmd(struct nvmet_req *req)
 	case nvme_admin_keep_alive:
 		req->execute = nvmet_execute_keep_alive;
 		return 0;
+	case nvme_admin_dbbuf:
+		req->execute = nvmet_execute_dbbuf;
+		return 0;
 	default:
 		return nvmet_report_invalid_opcode(req);
 	}
diff --git a/drivers/nvme/target/configfs.c b/drivers/nvme/target/configfs.c
index 65b6cbffe805..a946a879b9d6 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -2086,6 +2086,31 @@ static ssize_t nvmet_ctrl_enable_store(struct config_item *item,
 }
 CONFIGFS_ATTR(nvmet_ctrl_, enable);
 
+static ssize_t nvmet_ctrl_shadow_doorbell_show(struct config_item *item,
+					       char *page)
+{
+	struct nvmet_ctrl_conf *conf = to_nvmet_ctrl_conf(item);
+
+	return snprintf(page, PAGE_SIZE, "%d\n", conf->args.shadow_db);
+}
+
+static ssize_t nvmet_ctrl_shadow_doorbell_store(struct config_item *item,
+						const char *page, size_t count)
+{
+	struct nvmet_ctrl_conf *conf = to_nvmet_ctrl_conf(item);
+	int ret;
+
+	if (nvmet_is_ctrl_enabled(conf, __func__))
+		return -EACCES;
+
+	ret = kstrtobool(page, &conf->args.shadow_db);
+	if (ret)
+		return ret;
+
+	return count;
+}
+CONFIGFS_ATTR(nvmet_ctrl_, shadow_doorbell);
+
 static ssize_t nvmet_ctrl_trtype_show(struct config_item *item, char *page)
 {
 	struct nvmet_ctrl_conf *conf = to_nvmet_ctrl_conf(item);
@@ -2128,6 +2153,7 @@ static ssize_t nvmet_ctrl_trtype_store(struct config_item *item,
 CONFIGFS_ATTR(nvmet_ctrl_, trtype);
 
 static struct configfs_attribute *nvmet_ctrl_attrs[] = {
+	&nvmet_ctrl_attr_shadow_doorbell,
 	&nvmet_ctrl_attr_trtype,
 	&nvmet_ctrl_attr_enable,
 	NULL,
diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index f8a157e1046b..1385368270de 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -1587,6 +1587,7 @@ struct nvmet_ctrl *nvmet_alloc_ctrl(struct nvmet_alloc_ctrl_args *args)
 		goto out_put_subsystem;
 	mutex_init(&ctrl->lock);
 
+	ctrl->shadow_db = args->shadow_db;
 	ctrl->port = args->port;
 	ctrl->ops = args->ops;
 
diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
index f652c62ebdd2..2b0e624b80e1 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -253,6 +253,7 @@ struct nvmet_ctrl {
 	u64			cap;
 	u32			cc;
 	u32			csts;
+	bool			shadow_db;
 
 	uuid_t			hostid;
 	u16			cntlid;
@@ -418,6 +419,8 @@ struct nvmet_fabrics_ops {
 	u8 (*get_mdts)(const struct nvmet_ctrl *ctrl);
 	u16 (*get_max_queue_size)(const struct nvmet_ctrl *ctrl);
 
+	u16 (*set_dbbuf)(struct nvmet_ctrl *ctrl, u64 prp1, u64 prp2);
+
 	/* Operations mandatory for PCI target controllers */
 	u16 (*create_sq)(struct nvmet_ctrl *ctrl, u16 sqid, u16 flags,
 			 u16 qsize, u64 prp1);
@@ -593,6 +596,7 @@ struct nvmet_alloc_ctrl_args {
 	const struct nvmet_fabrics_ops *ops;
 	struct device		*p2p_client;
 	u32			kato;
+	bool			shadow_db;
 	u16			cntlid;
 	__le32			result;
 	u16			error_loc;
-- 
2.43.0


