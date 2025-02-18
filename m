Return-Path: <kvm+bounces-38494-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A6D23A3AB19
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 22:36:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3D6487A4735
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 21:35:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A924C1DE8A0;
	Tue, 18 Feb 2025 21:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Z1uxy3Ew";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="OxqH6AOW"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20C371D5AD8;
	Tue, 18 Feb 2025 21:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739914471; cv=fail; b=I7eb244jWWxB2pIz+XD9v357ySV9azhESA8fJ1eQ7VFoFdV3RKh2EqmUcWsF30w+yaYIgjzCHPq/UIGkC1bLiGNnvtdv2AjTaeHt1+Ua+DA2xWM+p/Jwe5TNS2NGHcg7dVrnflZW/tSB847xvVHrb3xS7DvK0n1vGtzEPimtan4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739914471; c=relaxed/simple;
	bh=h+s0zPrbvlVnDP7LgdMF6n/gdbD2X+UkkYRVL3akutM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PP52IhM/DfF8uHcdnMBmpUUMKFEaVqoozVXT+0pRGEnpWYHxUVOAnFwDfOVANXixYU3tiDAbtP7U+Tn41OCpyiDMtPgTPoJMqF5+EfIq6O7awZYOqF2sy2jMWp7nYe1SQPWJp4d48HNv1pwwFuXIa9GEbAhcHZIZCM0G9WzXF0Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Z1uxy3Ew; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=OxqH6AOW; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51ILMY34020696;
	Tue, 18 Feb 2025 21:34:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=tuXMmugSwWVSw8iGwCPMmmKPajF8YRsj8SWgseskxsA=; b=
	Z1uxy3EwiQ+WkRfbnffn7fFWGEVzj9o+I1WTprkPlHZSWaLmpsrNw3LfTSNhsR5I
	5OmxlhBi0dwEiP6s19wSwj6mJXFPPYS6rFodJm1+JDrUmpVTaTZWKx7v6CiQqQBj
	VxrLSNZYJinZq4ENySeaiks+nTn7en6HpwJWI/j2JT6focQ4qAAG+hYMJHdbcFk6
	ndeKe5HvnMXK7/GMAdBoUEBuKrtr7Lq/sbbtRujS6I84UCa02I6CQncy8TzEfOkc
	D2RTHlFvvg+7+FY+kvoBDibKFKpelMkjbiNuhvEFyiaols+H0lFKHqfkMN6tyVdY
	Za/N+UoBiIXxJjvHJVnYwA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44w00m0aaq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Feb 2025 21:34:06 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51IL4sMZ009688;
	Tue, 18 Feb 2025 21:34:05 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2041.outbound.protection.outlook.com [104.47.56.41])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44w09bmxb2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Feb 2025 21:34:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i5UtGu850nPsL14MsNGEWbZgWi5O3HoR5nAx5IXr6YGY5R85gHSVy3+J8PHfb5MJRz8JaTQVmz8jl90r/VHCY3oiGNIAQA7LfHzsqaqJJycGbSruDrI/MnJwlPd+8jhjfgj0lj/iNWJ/QvgHhtKPoO36UeQqjFPxPyowRbGuhvmiJdgUB6Xb7wm04tV1KxM6ivta8iyVzsptWmB1CwvZXPPypR0YbUdUwrVdkE8uhXpWrqyMHJIuQrI+cCM6Ln4iVhAijkLfhrEGHVKsdsCLmSlSmbYmA/MX5G9C0LpV5cGuBqZ2SYwRv2IfWi5Z5Z0fAeeaqcHwMfeb494BhLXkvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tuXMmugSwWVSw8iGwCPMmmKPajF8YRsj8SWgseskxsA=;
 b=qqsQab/EfN6B3OAFk152fUakDXMWCHcNFq6GiL0gBQxi1QuPfxsSs8Sm99fjjmUIbhohnoEkgqxXitjZOmLFngfJ3+w+O65IsXvy68yBCGOPodyiUCv5qJVsCaRdqYJnjQkb8paEBcyfFVxfQX0U+RjT6UYhc4FyEBfIaPPLFBV7LsQRWDGQKafy4/8/T4BiesY3020URHxWL9UBw8nXDlUpiae2UI8aZrOKNr+M6Pjj2t5z8XIwn337k0hkKiu2iKEYCnO+k0bVcxDh4RNM8P0acIesKth+D7KMiJ3L7VVAtHEjskP0BaUil0ePy3Bmo6oda1D3RuTHjcpSY6vRww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tuXMmugSwWVSw8iGwCPMmmKPajF8YRsj8SWgseskxsA=;
 b=OxqH6AOW0SYARVJ6MWoeskek9sTzLdwXtiduJO5RMbtS/sOfcOQLPYC4d+4H9JzRdXD8+Dl35bH0wqYec5UZg76eAnP2VyJjt97LeMbjj53xHFAncuet5q6okOu03j7e8y6kPgM3+O1JxmpvwOCCI4AhkdZwO1fUkpahEN8wNWI=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by CH0PR10MB4892.namprd10.prod.outlook.com (2603:10b6:610:dd::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.19; Tue, 18 Feb
 2025 21:34:00 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e%2]) with mapi id 15.20.8445.017; Tue, 18 Feb 2025
 21:34:00 +0000
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
Subject: [PATCH v10 10/11] arm64: idle: export arch_cpu_idle()
Date: Tue, 18 Feb 2025 13:33:36 -0800
Message-Id: <20250218213337.377987-11-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20250218213337.377987-1-ankur.a.arora@oracle.com>
References: <20250218213337.377987-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0015.namprd03.prod.outlook.com
 (2603:10b6:303:8f::20) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|CH0PR10MB4892:EE_
X-MS-Office365-Filtering-Correlation-Id: 089fc724-6fbd-4796-f694-08dd5063f4d3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ThCquP26NoSGVNPGckvXMIaQT7tV1mk3Hd/5NhWbzRnvZvqOwqOTf5EjciuL?=
 =?us-ascii?Q?Fuwq+eYxQAKFImjcsndHNxJDU3kIr6u/QR/5ZnHViPMI+WMHFBeIHE/130e2?=
 =?us-ascii?Q?+1ZLPamt5Mi2P7R/12gKlzDF5B2TkWb98+aaZBJ9BkKhzs2IECCxHYHPX6Tf?=
 =?us-ascii?Q?uvYxFCaZZ/xXMGDWp0R/9RstRzOQmk40K+lWsVIIyJxn72iL1zcBZCKwKa95?=
 =?us-ascii?Q?v8dfV+4yUVv+6lx4Ovt8RszeQBHYmoEeCyzA5FQwvGB6d2KA80NXE8yOTqmG?=
 =?us-ascii?Q?R1my4ivwgO63jpf/lk0csHhaIqQhfFboOsvLVx5YCK6+5dyTiVaX684zJ1wa?=
 =?us-ascii?Q?DbtdCXHNIUaR645aviz2+RgAEBcIcRYIXofjhL4A9CMaCRulUIaTbk1nYzgK?=
 =?us-ascii?Q?i7O3vL35lIZeGNIl7gr6BvFfLtdl2N0G2Om8WLhPxtxks3nzaoxYWqoKpw1Y?=
 =?us-ascii?Q?1ySBgNCsXK1ydmEZjt4C1490U7U9+uuQdJBjgan/+Sk5HV5W4kpqs6MxOOiK?=
 =?us-ascii?Q?aEGH516EgeoudKeHjv6nEeAr5YX9dK4IsUyoAjJIG2OkqGktYNXOb04XHv5v?=
 =?us-ascii?Q?lzXVp1l42bAkgzdotbH3fque909PYdEnfyP0JukRHDfh3yRhxYl1FRPBQn+R?=
 =?us-ascii?Q?22kFRRrpI7p+oLIeK2DPAdonhJwrHKQucCc7qoF3fEwi++dFHR1eY2W2uV+J?=
 =?us-ascii?Q?gxgr1sklC8fw8CjhjnU1SdpUzOBwIbfhJYM1i0rJyav4XeLkEPykLU7223pC?=
 =?us-ascii?Q?Vi/MTeP+hbRfPqjNeQOtgt4PHCN8Fypq+PBYIoBZsf1U2nc7UiTvAXkrn3SB?=
 =?us-ascii?Q?+ZOGnPM+GVaemXl6n6/v+4CulYx/qOU3gXcgfMD4MYXj/YRZ76q3fkgcvdy2?=
 =?us-ascii?Q?GJ7Lb+ZSSp56feLWD0Gkhom7g7aFeeG5gRkqVeUsKoose1BPUSupToGT9hAS?=
 =?us-ascii?Q?8JXmKB8F9vHo3twDxv72Pm8ww44Z/IpIw3R5RmIKKbHf+3hHUuLRxUW6KbqA?=
 =?us-ascii?Q?wg3r2DVvG6/3ZM4fYDT6fOo6HGGRStOZX65WlK1y17mr1+QPeAFlAziN3QiH?=
 =?us-ascii?Q?ku0Rvv0NNoaUsKVoLd48pAgLdEcQTuI5pfrzbFD81bnWz6dHPjdKKqUBVp+W?=
 =?us-ascii?Q?tL8nm7jzHxCUhpsYKAAdpR/Z106zkFW0UW9ERRfJeOV6Y7W9uc6X6p4bm5Uf?=
 =?us-ascii?Q?m/8LpTAWD9IZLORpBLxMNZz7VYzrHdCIdHZZxEuV/M/BwONrhukuqHkGVB+q?=
 =?us-ascii?Q?TVzCCdQ2lhVS0Fqp7q10wcBV6G/GAPJaCqx1zVq45vaqTdX7j8Twm7eNdFpe?=
 =?us-ascii?Q?wPOLtKCzNk7fT9SI1Tner5IBOB7edxsA+fp/o/CVhewtI70kPK0ijQ5MUvp2?=
 =?us-ascii?Q?CDtmVaYO0QoCwxjGQJO4XY+dVMEt?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?B7uSWQQR1MyX3+zoGt50xKTWm9A8olv7NAvFuoLck4T63IMfhKmyQO++F/J2?=
 =?us-ascii?Q?ZlTx3zE/ZPBjxDCjDI3n8+PmL7ZqHbSXU5prQtkHbT1bcOnVphG+p6H/z43s?=
 =?us-ascii?Q?qduGoHEAzGl0zWlDCkhc/Ix+8ET2BSRJm6at4zhP3S0YFi1vcWs6in88iyqB?=
 =?us-ascii?Q?DHK4chsipaAPALXral+ismqRcpwdvbjP7eZNOg9n7zQfP2ASmGPG8A6+SDuN?=
 =?us-ascii?Q?zwRwf1otnR2lApVK6CvZ8/fG4FofZoUyOVzi15vlwl2k6QGdEICK6REG6bPd?=
 =?us-ascii?Q?Y3lRV9lYSQYFAF3fkykw6LpPLN+m5aBdyTmwHfZmny5PRMlwLF3bLcb+I+50?=
 =?us-ascii?Q?N7Gr2zKTLaAvgkmoJMAO4OZEe/akJY9nsZtIf8eeo5S9mMGCgJEb6IEvhp5x?=
 =?us-ascii?Q?DDDI636O4hG65W+6ghbHBTS0lg9Dkykw5Mw862g5urZLgWkhcMONtFdH2uUE?=
 =?us-ascii?Q?KcfpybzVkkobsab3PB0/SMJhe/OZGf6F/PZWYQ/VV5hmGmBA50D8fxvFXGjF?=
 =?us-ascii?Q?PBeceOnpAuc7sZoqUMq8vXhURDcOSrBticqJb5ylR0KCHRfSxDsStUTX2Pkx?=
 =?us-ascii?Q?2TzZFxPNYagsMyi0Ww5Y+oPCPnZHgrktQ9fonDaUWBWbdKay82zdpT5Hrko1?=
 =?us-ascii?Q?RJsVbgAWdAwSBzEeOVbLti+376ElRmQfTiKNnIIMvha8wz+L3UTzVn9EUuQv?=
 =?us-ascii?Q?eT5UI2X3TMuSS6hPO57NLXub0YVvYVlONLXgR3dT5WSGQoQjcSu7pMbX0Eox?=
 =?us-ascii?Q?yj7nZgBr6SytQ2YfQ6h+bRr5Mj0IIIc8azK67j6ds1liv127Ry7C2DCRIooU?=
 =?us-ascii?Q?V3FgrtBvGTrgiVuCFCxHmFXAOeBJMeBjtss+VhikwVYPz3/HaHIZZenOwvJy?=
 =?us-ascii?Q?Tvs97PEqUTbzzVkzxCpOmrLAeos33FK6qPT8TI+AEd7nj9+qO7r9HCWSYtM7?=
 =?us-ascii?Q?P6s6rIltwrrE47h6lbV2K0Kq33wmSgzFeS4kpYfm0MKo5GiPHDjam/Y8CDkC?=
 =?us-ascii?Q?Qct5tpWrVs3kdHykXeWdqFzmDi+1BYeiCQHAGSOKEdQgRGw0cejLeDjIDJH3?=
 =?us-ascii?Q?B7UakQV7dCFzlIdRIlrrIUk78dWXTphbsZrGwsLh6EbWFnwkRvPXZ/sKn5GE?=
 =?us-ascii?Q?1aHbA6IMMXhjI42vH4XNXHTqteM5NsgHv8yPh38IL0uCEGp3NTcrkTJ9pXUk?=
 =?us-ascii?Q?21C8dnHvBMABtvoMwfyM4TDZfbtiodLx3CYTRlIky9NWWLn2bg11GGqyi2Mh?=
 =?us-ascii?Q?8cbeBFViu+rAns0sL5oInNtKRsx23KzyNjFRUqNSM8DgBE6B2foJfQuqKrKA?=
 =?us-ascii?Q?E4xcByX7a91qKqzAMVWR5D5ZbBROWN1aNkuuwEj97t9TN0r7ltOl3s8/Ohlt?=
 =?us-ascii?Q?nSFg/rqil/45Jzl0Ym91WDkO3X6xRvrastbz5SCGv12Q2I+GUMbYpgy3cYu0?=
 =?us-ascii?Q?dnbf5nBO67sDA5enbyiOodMqlJaF8MCbivRQ/uaSRmMz38Kvslm01bBuMtz1?=
 =?us-ascii?Q?TyuVB8pyNI58hHDbLvizxaUhcKrqmoIM9TTrTi3Be3O0+vpjCrze6DFIoN6C?=
 =?us-ascii?Q?x5/q39TxDMdIcd6DnY9Ekzqb2/tssIectcrHkszQbl75tjYUq5yWIS3LflH6?=
 =?us-ascii?Q?Pg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8cJx1Xppa9wgXNcNoncaAq5M/hd3lUxTN63DbkSXnfZ1qbco9j9fI7DcWBwgoVVBkL3FFa6Qx+4DP+5a7iE/qPK4kylt0uCTyq4oyBsCO445fBTqEjYYwBKRL4cHsjN5O0+ti/EDKBiH2wfyz407uoiHzAVasWGyII9VnveLbCiz4qkw2lHqxrxMHDcn+4uIc/q9fdoubQ2dhOxeQHF2x+ez4tQuVaP4sdfYwDvD8Ziol6cSHBbN6wfXYsW5kDAXKXkrV49tD6THVeChhTp0PLdtkmNvv3IQe7Qz08SLIk1YZtN7XluY8dymw1/St57LcFzRjPl3xAAUeqpOR2qYDRraDJihE1d+m92g4YDq28gLU0dqh6QX13/0e1LffRPmMP3V5hEiszSqypa5IiBCxI4cL6usxemmZUqfnfy+LuyCYUSWmsU2JLTctJnkaUMZksAbAmz0UXZui5tpBSmKlceBLehdTJhBg0Dzhgs3KeiZt14lMovXX8pDpYdPU5aPExyR+MY7ogVTnhipyzVry4njevUi2Fu2UTKrPoeWVPC1oTFLFoXgi82Iu6zfycvdQxeqRIL14PdBwO8hEqA+SiB7DfyUIK+Mwb8epiPWpq4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 089fc724-6fbd-4796-f694-08dd5063f4d3
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2025 21:33:59.6767
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9GZIFtZ354Sho4MhW5tAEo3Pm+/I6buJfCfC77nvpWSTaQVukDRWGLkpnyPQ5tazS6FiLzoFO0lWNc0uwurBUlDsHPQY7R11eok08xY7UjA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4892
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-18_10,2025-02-18_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 bulkscore=0 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502100000 definitions=main-2502180144
X-Proofpoint-ORIG-GUID: 4SAVWgCGe8aczgdyz_2iUoaKCINu_oHR
X-Proofpoint-GUID: 4SAVWgCGe8aczgdyz_2iUoaKCINu_oHR

Needed for cpuidle-haltpoll.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 arch/arm64/kernel/idle.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kernel/idle.c b/arch/arm64/kernel/idle.c
index 05cfb347ec26..b85ba0df9b02 100644
--- a/arch/arm64/kernel/idle.c
+++ b/arch/arm64/kernel/idle.c
@@ -43,3 +43,4 @@ void __cpuidle arch_cpu_idle(void)
 	 */
 	cpu_do_idle();
 }
+EXPORT_SYMBOL_GPL(arch_cpu_idle);
-- 
2.43.5


