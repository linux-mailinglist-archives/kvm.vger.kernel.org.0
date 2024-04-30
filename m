Return-Path: <kvm+bounces-16255-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EC818B7FDD
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 20:39:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E87DA281F22
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 18:39:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDE8F1A38C3;
	Tue, 30 Apr 2024 18:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iOlCj3XN";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="aI6l9rVv"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21AB723C9;
	Tue, 30 Apr 2024 18:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714502310; cv=fail; b=HJNUEvFUGZBVJnHWYo6ri2aBBMG9MaBU7xl+ON9/r2vS6SRExBj5SF9oevihvnCtBnW6gfFfkUm8/VeB7rv2XIKmG0EITWtIlb4z7JZVLwyQQnixnOlYMpzmFYnuWDSJ0csiNDDUi/6bDQclI4NKr7FYmMM219iBRwCFiPPC+9g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714502310; c=relaxed/simple;
	bh=NDPGzI/c23kfTTC4q3SaITR/rXnM/N3GkRwLpHzjJ2o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WOKLk/BH6IAHxXICuP+kSi9c/kOiCLwGSBSwdlHS2FQAo4ExZ02eHabDyYig0Nu/KkCV4iSg7AUC7VgG058Mtr20SI5akszd+lZfz8RV9a+cr/OVggXLhOQp48J8wg0aMdATVCo2v3CdJTKeZejoxbqet3rwFnn29DdCcEyCRMw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=iOlCj3XN; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=aI6l9rVv; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43UHIj8J013014;
	Tue, 30 Apr 2024 18:37:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=e4hefLP1/keZMizm6J/lhFsjEvynlLKzlO3Rbfd9p2c=;
 b=iOlCj3XN7vSXnPjxAwd2unPhiO8WUbE/fuU/WN6UAOjeHIIM9q6ZDDlVuXHs/GmqsdMq
 buQKx5eo5yPt6hEnsw/gjAMU1ta5JPIio9Uq6Ls6I4WmqkO7/nPjym+riIsk3cgDcpO2
 JDZ6XnrQ7oDggkPSnNQA0E2mLfl0tq86bvKneFb7VT6Vfi0H1ns8t8aW8SqhISpag8dB
 /WajHYjnFIrB1o58wWXByOA47kzPmeljUX2EU5lVp2/vz7btizWPMKlqoRL6bKhcNvG6
 UTpdje0mfdFW6rYDMl4JrB0QxsqR8mkgBrJuydsNMdd2Hv1JJyYxtJ9NsmHs/LtJd4ML pA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xrqy2wxce-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Apr 2024 18:37:48 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43UH3kuE016678;
	Tue, 30 Apr 2024 18:37:47 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3xrqteckhe-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Apr 2024 18:37:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EU7W1x62DXG6f640RtSrrdBH7JNG2k9BkfiiLn017mSCWQqTu80jvdJWi/grrRT0h9s/FjPAKUx0Z/8IqB+r8w70jTHZAbZ9YTAAEOPXnUGX/AK2HyT3F3yr3WU/DsOqM6C6eMlf6RDlt1urI2xyTiEi8Fd/g0iXUDIg/0rzcuampl+9UKWl9iTZrHL5FotNIJ4Tuda9AMkZmOjwqO8qwMpFGszoTwBWbAW9EJKcLB9bXCRREr+gbwHuOs2SXuXM2d0fORCVGYrKZuJhbZuyNWLg0L892WRvwR8wydKNbO/KZjNnvfWxlM/Fol9VzaY07O/jEiyGzx2SwQAmzUNiZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e4hefLP1/keZMizm6J/lhFsjEvynlLKzlO3Rbfd9p2c=;
 b=akVSfEXhhVeKHhhvIEVPVjZsK8AdFszGEDxl0Y+RYL1/Q6ZjmJ9zrBjBQE3H5mkNdeHA6qkbY3si6LnXtp1JDxTIpyVdquyWOA0RKNacYYEvm97DJgHMn8svpXzsWUU1j/USwqTnlYYqyzEyQ8pDjz/HB/8jx3bOEjAu/eT0dkIDQfTMxR1oPS/gVqdK5xVQl96LIBJeRwnxeOEHY2PZxnbGufgKC6Z07Hx+LV6xYBNHRYcCcHvlrvflPGF5ttNfUn9CTahmdGYV0tcGAUpPzH87t6Ty6gUkXIS8RpDxCnVGuGfPqozzvBjDMN7ShgCFRl/zbu5xAssTgKq+hwJC3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e4hefLP1/keZMizm6J/lhFsjEvynlLKzlO3Rbfd9p2c=;
 b=aI6l9rVv5eQsFBYcY/pNVm7wW3AlFTW9nwfutx1oE3XEmT6WLQ0g8wH5asITVMupd/gbl3/5tYweCb1Sh3c+uPdu9EZ+/FyZdf9N4k6F+NnO+DBImGpUokYrvY+a8zxWezBlgChZJJdOMx8LDlfKm0rEedsk00Pv6lOPVrntUKE=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by SN7PR10MB6308.namprd10.prod.outlook.com (2603:10b6:806:270::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.34; Tue, 30 Apr
 2024 18:37:43 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::4104:529:ba06:fcb8]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::4104:529:ba06:fcb8%7]) with mapi id 15.20.7519.031; Tue, 30 Apr 2024
 18:37:43 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-pm@vger.kernel.org, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: catalin.marinas@arm.com, will@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        pbonzini@redhat.com, wanpengli@tencent.com, vkuznets@redhat.com,
        rafael@kernel.org, daniel.lezcano@linaro.org, peterz@infradead.org,
        arnd@arndb.de, lenb@kernel.org, mark.rutland@arm.com,
        harisokn@amazon.com, joao.m.martins@oracle.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
        ankur.a.arora@oracle.com
Subject: [PATCH 4/9] cpuidle-haltpoll: define arch_haltpoll_supported()
Date: Tue, 30 Apr 2024 11:37:25 -0700
Message-Id: <20240430183730.561960-5-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240430183730.561960-1-ankur.a.arora@oracle.com>
References: <20240430183730.561960-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0182.namprd04.prod.outlook.com
 (2603:10b6:303:86::7) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|SN7PR10MB6308:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d7fc43f-8e68-4a2e-078e-08dc69449f6a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|7416005|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?E78e1c0eLerg/ZScBAQ5Sn5gtpQKdx77iubekv3oak/v/t2Ccj8UENsNFddY?=
 =?us-ascii?Q?nrbY93udhfCRxaDAvboDrEWNyaOErXl/x6bz7hwgYXEAJUwUImubdpnipELQ?=
 =?us-ascii?Q?rnhH0u/IjWovag04zF0VmJt2QRqJKtPgj0szJXDAx3kiY+83yO3DwqNT9HJH?=
 =?us-ascii?Q?JtIXast8bQrMaoYbcTdhtn/f3Fy1SrYEClhziiroiIpOmHTEkSj5e0ZCzafM?=
 =?us-ascii?Q?uqTLGX5SqPs+9zhUzFl+UYTjveqCJxwEK85y8V+WiftjQidLKPlFLgQF4MjP?=
 =?us-ascii?Q?KAepmeOQSOvlL2Q0BbBMGDuy9e1t2RjpHZO9akUVmnGn0J1WaUzU6i/1Udl8?=
 =?us-ascii?Q?9v5r6dajd4Px2qmXsuFonw8/zpDIgnSSNRioy+gnmlXyO/VtERaa1YHWOUJe?=
 =?us-ascii?Q?kK16lshu4X1oY+X9qi28MwqrOLFuXLzsUVWrB1oKpHmZNGajDTBW1iBwDnPG?=
 =?us-ascii?Q?9vpkVZRYvaaDoxchXHa74olmkfujxTNzXlObS86FLzSzK8yYmeaSHUA0ByQ/?=
 =?us-ascii?Q?HXy73a2wsr7ozSvLGpFxD4IFtKUEW5e9a87osxRZdhs7gSmlghFmueaWoc3v?=
 =?us-ascii?Q?R2oc3TcfZ6KZB0ry728yZZIaNQqD/wofmkmuE0j6AxAeIUEgwWyscbW8I157?=
 =?us-ascii?Q?eeaxYjmRLmRo1ncL0hgQR9uWIbdMvqXgNRK85VwbycZcTnJ9J5k8rS81FsTA?=
 =?us-ascii?Q?HzzVFArxOqsIJQ4eAPYgyodzMuICwbVhtKFSxy0bz9s0r18tMjFSh87agy+Q?=
 =?us-ascii?Q?4NyeDT2V+mmtOthUvhc2SarT3UJXG4KGLzpCAKFoPf9ztJpISqiFL3jcUORo?=
 =?us-ascii?Q?ZWQtHwOWLKrzQyxVJPur8y6inFR0GK45m1FRct8p+eyA5vjZ1kO0OEHgQnFe?=
 =?us-ascii?Q?1bPF62FLXYFk66LIR6xpdfFj75HSKE7z18gpLr4NtpcH4OqmTa8VRczCcs6b?=
 =?us-ascii?Q?kUkWu6Q2ewEaPd66faRCI0Yovmr+nk+VX43BhezEh1JKMJT6tCQYxv5lXy4P?=
 =?us-ascii?Q?wjoTUVjVGgTdvJYCnkcMJZcVv3TM7e4GjCCSK+4fxZDppVnFyYzUANqMrn/m?=
 =?us-ascii?Q?oBM+8pGoWsUIaK2fz1U1gKKHSV4kKlDGf0I3qfXvHL3LwQ6TAqsTYCMwcrU7?=
 =?us-ascii?Q?q5DasR3VR3Avvr2PvGfKE6yuBpl17panxWMpAZATbv2mWikUqZTJoA0DetKw?=
 =?us-ascii?Q?+CUNcIKgAPNDxlwXtSEfiYIuFDTFtquLBXFxSbYmOO5f5ziir7Rd8VWXXY9p?=
 =?us-ascii?Q?5GRtd4tfX5jQARf/4lRtsRKoe+7Te6Uk3CO38dgFyg=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?vspiUkmkGJQ5qfNhoUzuFh+QzS9/mQbLdkBgiZ1Xx1vgRXMqmpU9pu9C7Wac?=
 =?us-ascii?Q?08kYoAqMdMJtMwQR7FT/q0Udk490E397oIMr+VuLCRLQ8Lg1opaTNwrYNXAv?=
 =?us-ascii?Q?K6uwkzKnUTNfFkAEJ0LXKi9+vpm73YvM3CEym/mfmGck4Gfc2dBNCjRIEogY?=
 =?us-ascii?Q?LWAdvK+gdm9/0Z0qxoNQeXgPGzaIebv/1LC74u9/aVRBIx4aTz6wmSQM0U7B?=
 =?us-ascii?Q?ybL5qKKPXDEh3rlA5CRZKSuQhr7qR8AHYW5/Gyak5KN7e6Miw8wPhlt4Jo4Y?=
 =?us-ascii?Q?ovLHWsQj2KwfFPpj63Kr/oro/cIoIO0oanLoGud5kx9nYY8UVSNUp1+Xo7Ct?=
 =?us-ascii?Q?/6QD45g5nyySUZwQCCZvUzxHUIK3bKFHuHmWpyj2LilftL4gvFykIWzg1OPj?=
 =?us-ascii?Q?T1NEZqoxbkvAMma++t/7YDZB8qC3mGPR3EYl59Z9jkUMy9uiN92VHTzXsCEB?=
 =?us-ascii?Q?iAzuZm9MdFzx39aDMM9/MoqWzAKnyVHOpDJ6Xp2ttkAIZm+FD7p/cqEt0sEM?=
 =?us-ascii?Q?IH5fQA67fz68NCWkgpztfawmpRGWeD/wQUgLvR2EhSEqOB/hWSmKmNQmLRwP?=
 =?us-ascii?Q?6C9iU8VM4svaQzhNhPSwrFi629XhuMgfBeHpvp6w8pJQtmJ0d6JVOFTM938m?=
 =?us-ascii?Q?8DSZf9Hx9JSsZs6iW5qYpQ7yd25HZwMOT3IGEqtI+Oj0TRT4/ecgdsVWgDly?=
 =?us-ascii?Q?8o/CFj7fIWYNCLJugasyqkjp+4FT5N48/3oh+CLBMY7rf5OGnybSl+7ASjyU?=
 =?us-ascii?Q?BDF3W1B66zyLYlChmFw4IVCoOJHH/s0C0PjwQD/O+gJmISxLlVrD7UEOAaR2?=
 =?us-ascii?Q?NBDV6omAkyGpHBm4dOBjOG1Hz/5szf0evXWISnFRxUJ7rp9nLItRuS9Sj1VK?=
 =?us-ascii?Q?Fv0I26h3AAU81Gp8IofdPyNwzCDENLnB9gaAMXbHIDHswZOk3bwYJtCkfYHc?=
 =?us-ascii?Q?d4kcaa63+J4q8zUFuMC+El5lijXhtI2o4HlQSoC/x155x2okhf+UngNIshYd?=
 =?us-ascii?Q?nnSrJmUxLpaSAmf0eF8nXuP9qEFfn6M4XKbcRD6vr02MP/2jmjiG6JDB/6uk?=
 =?us-ascii?Q?tVtgNnee4gT/wwcMdiaxkXgMnkb1gms2NcCZ1QQyuCBu/qWLStL5lEdn1471?=
 =?us-ascii?Q?QHSRDkgb6a1hhBT7Ja1iANIGrda72ke/mVyaX2bJBJphg8ryJ9sNwZs7F5V3?=
 =?us-ascii?Q?mopZ7gSSZB6AaDGqQuX11d0gTOsGE4prZOysX1G92j0BSFsoJVcakyhuvXBH?=
 =?us-ascii?Q?j5Y+HzYL/GIBsDj7UPbwW1CIalS0bWAOkreb9COT0LiZ6mgXa79+hPNb2CFM?=
 =?us-ascii?Q?nlWzyxu9Spuau9kQ4UoEKBJjnwJvl5To3PMD2NfuaBy1MdKktc4AaMigikeO?=
 =?us-ascii?Q?EVnYAL5Ot2AI1vWPgF5P98H6U/DDTtGiJHc4gAQeI2Tt4pNjJVVUBlV3TTBD?=
 =?us-ascii?Q?fFpoXXyTIpCIULrAfNDnUNH63fPbwHt+8DOvmTOg4MbYPz0U8Pd1QwSU2QAV?=
 =?us-ascii?Q?glTA5s8h4KtVsq7Ca5ZcZRmnkoIauUkbLSdjiRMQDodIfq+u/xTglFXgFvj0?=
 =?us-ascii?Q?DWFN7Gy+xKgi3kI8gjQaI5W1y9E9y0J374OtENIZowttYj8i5QkfNacwPF8c?=
 =?us-ascii?Q?/Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	nvp3247Ru8IdozOp7m+T98UiiJ8483h/VRexwnooMIgcwkYR/IqH2sfV14EbUH3IFjZBf86NI7jmLCOfAy6yRJaG1N9Bk74RJJPse7RkbXU9Rq9ZXhuAKZiJA5eIiS+sIcjW2g/NteDKKYF9BdPkJUBE0YIWHNBWb7toodfvKN6LSvP+I3AsVdk4AGaN9d5JpH4F2f/HLv+a/G9B4PWRdmMxqn7neYMXVHIRKYzFG3WJjp1G0WNJKSX+xWaqwZQ/gVqY/2e1sxlw2fP9TJ5Sy2Ba7RxaQjOBMU3gInjqgiE95DHLkkUOFVe9HC3UMN6DyzWvYJ2W+Uhc+M6pdbpmJ7vFAJJuC3xycknsl3RxjmjWVbO2y9/xZGmbcfoxxsCMN1jgVJTi5qr8W/14dG8W8bBJyHzi6gE8mwMF8EeOd2pgkNlEo+dUJ9a/5DjV0CZFQ4a/B/UGx7vBJG7LAzSmINJ/vLNyUCaPphioB6uq62985+dn8S2zUUG4jF8V1Kd2N1PkelW+LYEHq4H2kh/pRGnqNaSji0vn4sLTmKvlhTTeVqipQn5fLMtU+VPzvU1PmpGhIpSqnz2TlpeCQ7E8A9Len7w7QgaPTanlQAiOJTc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d7fc43f-8e68-4a2e-078e-08dc69449f6a
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2024 18:37:43.4100
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mHKNFg/0tEqKOg/wdjtEMK2EBU2OVJGbp3ltoBHXjpRNWJ7zRn5VoxTo4xYBVdXMLuUvcZKJwEzUhuHuenDAQH4eq59VYVKHfa53P8ahyTI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6308
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-30_11,2024-04-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 phishscore=0 spamscore=0 bulkscore=0 suspectscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404300134
X-Proofpoint-ORIG-GUID: RguJQfy0gg3UuuZDU4eAMvN8a0vbzSal
X-Proofpoint-GUID: RguJQfy0gg3UuuZDU4eAMvN8a0vbzSal

From: Joao Martins <joao.m.martins@oracle.com>

Right now kvm_para_has_hint(KVM_HINTS_REALTIME) is x86 only. In
pursuit of making cpuidle-haltpoll architecture independent, define
arch_haltpoll_supported() which handles the architectural check for
enabling haltpoll.

Move the (kvm_para_available() && kvm_para_has_hint(KVM_HINTS_REALTIME))
check to the x86 specific arch_haltpoll_supported().

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Mihai Carabas <mihai.carabas@oracle.com>
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>

---
Changelog:

  - s/arch_haltpoll_want/arch_haltpoll_supported/
  - change the check in haltpoll_want() from:
      (kvm_para_available() && arch_haltpoll_want()) || force;
    to
      arch_haltpoll_supported() || force;

Dropped Rafael's acked-by due to these changes.

---
 arch/x86/include/asm/cpuidle_haltpoll.h |  1 +
 arch/x86/kernel/kvm.c                   | 10 ++++++++++
 drivers/cpuidle/cpuidle-haltpoll.c      |  9 ++-------
 include/linux/cpuidle_haltpoll.h        |  5 +++++
 4 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/cpuidle_haltpoll.h b/arch/x86/include/asm/cpuidle_haltpoll.h
index c8b39c6716ff..43ce79b88662 100644
--- a/arch/x86/include/asm/cpuidle_haltpoll.h
+++ b/arch/x86/include/asm/cpuidle_haltpoll.h
@@ -4,5 +4,6 @@
 
 void arch_haltpoll_enable(unsigned int cpu);
 void arch_haltpoll_disable(unsigned int cpu);
+bool arch_haltpoll_supported(void);
 
 #endif
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 7f0732bc0ccd..e4dcbe9acc07 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -1151,4 +1151,14 @@ void arch_haltpoll_disable(unsigned int cpu)
 	smp_call_function_single(cpu, kvm_enable_host_haltpoll, NULL, 1);
 }
 EXPORT_SYMBOL_GPL(arch_haltpoll_disable);
+
+bool arch_haltpoll_supported(void)
+{
+	/* Do not load haltpoll if idle= is passed */
+	if (boot_option_idle_override != IDLE_NO_OVERRIDE)
+		return false;
+
+	return kvm_para_available() && kvm_para_has_hint(KVM_HINTS_REALTIME);
+}
+EXPORT_SYMBOL_GPL(arch_haltpoll_supported);
 #endif
diff --git a/drivers/cpuidle/cpuidle-haltpoll.c b/drivers/cpuidle/cpuidle-haltpoll.c
index d8515d5c0853..70f585383171 100644
--- a/drivers/cpuidle/cpuidle-haltpoll.c
+++ b/drivers/cpuidle/cpuidle-haltpoll.c
@@ -15,7 +15,6 @@
 #include <linux/cpuidle.h>
 #include <linux/module.h>
 #include <linux/sched/idle.h>
-#include <linux/kvm_para.h>
 #include <linux/cpuidle_haltpoll.h>
 
 static bool force __read_mostly;
@@ -95,7 +94,7 @@ static void haltpoll_uninit(void)
 
 static bool haltpoll_want(void)
 {
-	return kvm_para_has_hint(KVM_HINTS_REALTIME) || force;
+	return arch_haltpoll_supported() || force;
 }
 
 static int __init haltpoll_init(void)
@@ -103,11 +102,7 @@ static int __init haltpoll_init(void)
 	int ret;
 	struct cpuidle_driver *drv = &haltpoll_driver;
 
-	/* Do not load haltpoll if idle= is passed */
-	if (boot_option_idle_override != IDLE_NO_OVERRIDE)
-		return -ENODEV;
-
-	if (!kvm_para_available() || !haltpoll_want())
+	if (!haltpoll_want())
 		return -ENODEV;
 
 	cpuidle_poll_state_init(drv);
diff --git a/include/linux/cpuidle_haltpoll.h b/include/linux/cpuidle_haltpoll.h
index d50c1e0411a2..a3caf01d3f0e 100644
--- a/include/linux/cpuidle_haltpoll.h
+++ b/include/linux/cpuidle_haltpoll.h
@@ -12,5 +12,10 @@ static inline void arch_haltpoll_enable(unsigned int cpu)
 static inline void arch_haltpoll_disable(unsigned int cpu)
 {
 }
+
+static inline bool arch_haltpoll_supported(void)
+{
+	return false;
+}
 #endif
 #endif
-- 
2.39.3


