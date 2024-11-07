Return-Path: <kvm+bounces-31095-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A1C3A9C022A
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 11:22:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5C7A52836D0
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 10:22:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F2E71EF923;
	Thu,  7 Nov 2024 10:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KzLVJLXM";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="oi5jDGHm"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 858041EBA12
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 10:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730974920; cv=fail; b=dLfaCic5FC/on8IwNJOY1MWCsS979iRBJy4zOr1I4ZfHLOElCvzw9vqbjUo4KM729AzQ8gMOzTh1V8LbHhNAfpNuL8qgIS4dy631GcND4wbJAEJvw8pccCR0kLr6J76glC4hjLPRkEP3T5rCY+CjRxS9FKZIT/Pqur2K57C4Yik=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730974920; c=relaxed/simple;
	bh=WU2Mmca9iwsl+m5tT330Go1T/Z4RrFx0ehvQcEOayEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Vf4uJ38uz6KaDqZCMDClzd2wtdH3WHeES3Mxwbm7LgW7Ppq1zRJcxZqG4hKhMZI5AG6o/aqAmddBzT4rVmJcIwSRKR9pwP/qtFdU2MIkBznM/E4B6AfgOlBK/3CoZSruv2flHsDsguekahd8JVqXv8mTsPWpD1F80jyyJ5d/6JI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KzLVJLXM; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=oi5jDGHm; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A71fZFc021950;
	Thu, 7 Nov 2024 10:21:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=jeyke96+8XdUGC7dBmIOrQRrlN3Zn+u9Xf3j5gg4Ztc=; b=
	KzLVJLXMmxXl3y8so0ToHvWhzErh8G+Fy3AxchUrk6KbRUzddABDt6U6oLwewDsy
	K0GnMj0Krpmmv4PVecO0hxD0IihWp1RjW33N8YB7carR9Hs2H7b6s4vJ2gFaEul6
	372lsYAmEI78+K/MjU6nQd/u0wFPBcuibwfrwqPnPVv/dkphowNbn+SagXMQHiD3
	5XSyd52dz4/L7S2cRrKnuO6z5CuyORYB4u9uUwBm6sAFKUFv1YIeOccows1U8VG4
	IrRhrvyhlI5kiBkNYqiYpPMQ8TxpME0OjYEzVdMHHDdPJaQHGoBKukChy28o4MrF
	NxHQdJsYh6iV7WT8JaSHiw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42nbpst3ym-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 07 Nov 2024 10:21:48 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4A78plMD008558;
	Thu, 7 Nov 2024 10:21:47 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2040.outbound.protection.outlook.com [104.47.70.40])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42nah9t0xa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 07 Nov 2024 10:21:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ihj7eY5jHL9vt6kT9UP48YtRMSyyfnNXHc+xxp72bZ1wjgqm+ZPx5nr8HPzg0DjwqJKLVkhuzd6SS18PNJXXRxAjPBWriecHTtkORZjyXYExWGRbn8pqYz/+uDYoXVNTPjJWVG9i9CfwlD8/Uym1wRBuldhRTSPWJN43DPwYAAgvuBxsQ1l3QmtENaV5NPw3KnxoXXJbFqC6N7ABZwa0AIguEPvud6JiE9fpPhMaPq2c0yZRwO0gB57O84xjvkvFOQIMHZwc05iOoYMRzu45Ro1/4B9t6x24CHxp2DbvTOrWW3XrCE6+OCWRwjVhE72xnKdDFXmobbh3uni6fe7YJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jeyke96+8XdUGC7dBmIOrQRrlN3Zn+u9Xf3j5gg4Ztc=;
 b=gHpPnFwML1bgaNjvYEP2orLg4aZd2IqEMrSkB/SpzKGA3AFAWSIYs1mSA61rWFkVctBw1Rvhv/n8j+9lymolDlPUYEB0ixR17e6zXkjE7ZR8uRPQ3M6kFvigwr7MEVCISsdHbVBwFAkUMA7SGD+QDyXYQxdF1wk2+mMvqpGXO7hWLrznFdjBKDGjFn7PA2T1q5ZrKPGs5aAhTEuBdlXuSUzfhscEM2+sDrULWPyYaPBRtzCoF3X+ShjjYktV8unzwxT+vuFdqdopsTaNS8tbXy25uaYs8Arh8izumLFOxRBu2wkRekrgsEofBPVg7vA2x7DomIsp0dmqw9IUUyW9nA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jeyke96+8XdUGC7dBmIOrQRrlN3Zn+u9Xf3j5gg4Ztc=;
 b=oi5jDGHm6jVQHHEmL+xbbDEYCaqdy32ztVAQK8lC8btKskw+VHAYsq0YQ++ryT2wEf5NcLIpQfHTAAMhz2K/mbIasCQZKr+L8T16UlJzLXqywvRpQbr1mK5LJJShMZZHwk342wmNyvYGQqP8NRCdlIU4f5mmvTG/Vp6B9PTrOl0=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by DM6PR10MB4187.namprd10.prod.outlook.com (2603:10b6:5:210::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.19; Thu, 7 Nov
 2024 10:21:44 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%3]) with mapi id 15.20.8137.018; Thu, 7 Nov 2024
 10:21:44 +0000
From: =?UTF-8?q?=E2=80=9CWilliam=20Roche?= <william.roche@oracle.com>
To: david@redhat.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        qemu-arm@nongnu.org
Cc: william.roche@oracle.com, peterx@redhat.com, pbonzini@redhat.com,
        richard.henderson@linaro.org, philmd@linaro.org,
        peter.maydell@linaro.org, mtosatti@redhat.com, imammedo@redhat.com,
        eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
Subject: [PATCH v2 7/7] system/physmem: Memory settings applied on remap notification
Date: Thu,  7 Nov 2024 10:21:26 +0000
Message-ID: <20241107102126.2183152-8-william.roche@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241107102126.2183152-1-william.roche@oracle.com>
References: <e2ac7ad0-aa26-4af2-8bb3-825cba4ffca0@redhat.com>
 <20241107102126.2183152-1-william.roche@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0025.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::30) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|DM6PR10MB4187:EE_
X-MS-Office365-Filtering-Correlation-Id: 99a41aab-7639-4d0d-98fa-08dcff15fa7b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?u/5baVu9V665QX3GQMl0x0dMvBJfOZLEm3DSj8RjYxzIrKqmTLyJyURCWp1l?=
 =?us-ascii?Q?2yWOfm+9szODc8t389Tj7S/aLJ7+taxkl/5fB1DkvVuYpQoH5wUruz/HHhXp?=
 =?us-ascii?Q?3NhllxRkw5/9p0Y+PWe3FIKsbnzOp4wSQ3Pvl4ZiZ9Gd+t/MyQ5M06ZeCJUN?=
 =?us-ascii?Q?/kcyWOXsYS3bG7Czm0pg2NIKTaWoziY/Tm05Orgk6rqAfrRfG1zIPwvnxef2?=
 =?us-ascii?Q?etL6LJZTwblTjqeSIM+QJ3FNTqvDh8heqs6ujzjhFv/LJ5pzti2zgxqpdTol?=
 =?us-ascii?Q?PxUCtpbqXpGZcAO0wGU29G2MrKV6QNqZGiVC3knqd5Puji2BKIItXvWdihfw?=
 =?us-ascii?Q?TI8z4diw+eyXkeJ6NW+SMnoMwSp/wkdgGl2aMn6ZcFiYJ9XoFv5yrs4kvjk9?=
 =?us-ascii?Q?mP32Kztomn/koGl+otikEgUr/qM/qtJJro529Nv/ihC4Thk9NdNr3IGNDuYn?=
 =?us-ascii?Q?MPxUq/bRxTJxGo54+wBoKSm78AmGEUbNbmcHSqjiyL3vF2EEHTAqiN5O3gGA?=
 =?us-ascii?Q?emLPC7HPhX8vQGh1NL8bDgzrkgLIKImjpZJ40aPA7EkupaZulm43l7iZM5SS?=
 =?us-ascii?Q?xL6k3K9hf/VYjN45hTIBcjb99qgnp0Sud93/3/aM0t/AGy0uqIryHWtrGnbe?=
 =?us-ascii?Q?iSiCxVVftMlSWRaaUpiGGmsusiXjYuehevEFxlZWClsGiJE5TaMM0/TlMXvn?=
 =?us-ascii?Q?tD4DJtgFBS9pQMx10zCRc2v1fnFpZwF7gWJ98HR6yeuOKreLw10sL9l7pIzc?=
 =?us-ascii?Q?wPjQK7yWD6ScYF118fl9jhQd9tK83KbFCodORO6BOzYJdHIqJuqGh4oMSQLt?=
 =?us-ascii?Q?9gi4T2b5MmvEJtNXLutYTOfNELS0VJHJ3wqgLBzG7jufYqLWw4Wi+ChLWCa4?=
 =?us-ascii?Q?OxY/cNG1hrYDkNPAEBTOO1fs2i/+g309oAqYVYFGPTHU+BXH24vSzzPCOpgV?=
 =?us-ascii?Q?pTwlozqBrcV9I9naIfmPc99B4n6kEdc1np1yH7lx6k2Immrz6dIjfkiUu01H?=
 =?us-ascii?Q?4aUOeDyQfN2ASP3In/PXG5tTNquJBEH6cGxissF2n6ZPHM9PjWQ3GiGIkmXI?=
 =?us-ascii?Q?IoKTKNwShBFetbnK1pI0sk2I1HVWuxVfufxEBnTAoPnWXJ5CbEhYS7W2HP1U?=
 =?us-ascii?Q?x6dRNL/yZyza00QDXlLFHL/EpSXvHquiIN02kQK6HEumGzVUjFptJYKyqlYd?=
 =?us-ascii?Q?W+SyWwA/rmmj9dP5CfPu4FYkkZyNv9JtCXVjB18ZaJl+b1NCD0cQN/tmdA2/?=
 =?us-ascii?Q?7SRkVmHn2SU3VJ/A88fYDDLmVfOaxt5M+WaI2lqKYXdg0UNo7zMgexdcBqoK?=
 =?us-ascii?Q?lB4kZK4PdnfaGnT3xmwA8IFT?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HfIIG/OQHvqVbJd3HfGMgHlqYMbM04XRhjRI3j572YxmkmynLpUyLPmDiDR9?=
 =?us-ascii?Q?iKrlCXKTaWnmKm68CxtGFoD/GX2OKljX434qZ98i9OkJjXuxF7P8OQoSUO++?=
 =?us-ascii?Q?SlqRzgH3KQecU+e+cXph8uK2WkQmMAKbK18AwVKZ8L77WxIDC0u5FlkaEhzr?=
 =?us-ascii?Q?omLzb80qs03Y5/TrQCAaE/RzECeZl7AK8QZhohxkHnJCwAYuMsQ7pw7yy7fP?=
 =?us-ascii?Q?gTBPhc71obU+qgIeHoOzEqJDkWr6I11w4cyKUzcVGEI7gYhEovFRVjl0wJU8?=
 =?us-ascii?Q?PEy2+0nZ8MS3jtpMyBmA1ekRjOiGvbrbFK9Ro4mBgvAmya/nVzmYcHWKXekZ?=
 =?us-ascii?Q?5xYtVclO/KCGOZuHfGpZ1w6k7vcyvOz5OyzkjHdK+fon1CZQc2ss20lSitEf?=
 =?us-ascii?Q?zR7yvNnUGykTE7Imwxz3CLGcWOry0onSZqtEEBKZsJMmAov+WxAoJa30Glna?=
 =?us-ascii?Q?7Zg4FAAYMHC0297226OvBG+AAHBYLui9/QKVwzZ7E+qYno0BG1dysvWpNPDc?=
 =?us-ascii?Q?9b8jEzQKVeqQbFYRnk26zR0NEJgfbet8YgP5SMYWXyYtp+1EISbpRGb8RDy4?=
 =?us-ascii?Q?6DcwWOFycjIOOm+8XN7oh+zJwQ4G46gJ55xUwkAKWNoECZqtDU79odAYB2KW?=
 =?us-ascii?Q?xCBdGtBwFgMm/tZjQs4EJTIEu5bV2GJ4wQ7Jgpv9rEeil/gKnXLzmgnWttbi?=
 =?us-ascii?Q?if5UxzX2VK68QmARDvGKS//Z30FlikVXdv7rXePk9xB0zmVqELMb2MfxC0b2?=
 =?us-ascii?Q?ietgN8G5eFg3hNXYlYJRcTiv1H6UYK6ts72VUzdRur+NrvQjpu5vrEdHvYHW?=
 =?us-ascii?Q?KfIqU0bjgEiY5wVTOMoEUpwNfHn7TZHXFjijRk1v2ZssvsA5QJc28c9CLvai?=
 =?us-ascii?Q?Vk//V3v4U4q1jG47CI9StsHrB+qLZ6S5AAHYuvoAvvXixMJj731Zf8ACUw+O?=
 =?us-ascii?Q?HwhaZ+lHrNoFqUsgMRDjZdbKij2PU8RFcuSf8g4vp0qe9MtN0H0V1PcPFSM1?=
 =?us-ascii?Q?5XQgqoyag1CVkPKk2sWPP77Z6Um5Rmo1XCcQK5WEalluH3VMx4nIfhe3snv1?=
 =?us-ascii?Q?K3CbdzT1ZaZr0qBixeDG3i4u+UQ7Nmi/sH1xfrEN7GYUuTG8IK4ObgSxiJPW?=
 =?us-ascii?Q?5P+dvARAGgSFRfPHrZwNqPVgyDycRKFX8gQbMUtWwpH+43EyTmyoZMbFM9aY?=
 =?us-ascii?Q?ASbvQOZqZbKXC0QODN++ouLd5V24wmOUAPhdkdHEqkic3pOW2480da2PLDfc?=
 =?us-ascii?Q?OPdRx/3RYrAK+pKgkhJrwxrtQOXE6vwX/y5jp21NrNV/qXGL0n0zCwzyJLCR?=
 =?us-ascii?Q?FYoGV8KMt+m+BZTUMW0Ko4hMfKJtnsxid2aNrG20BNx+Rc8nGGKbooiZlqvA?=
 =?us-ascii?Q?pJPU6Xs/uTCBhDavp2N5Oqhi11Aqm6wQ3Ul0jrub/VV9NnxAJBLS5noS1eZW?=
 =?us-ascii?Q?d4mnKv0Z1QRxPK9qKUDzU6Xz3OcMfsW1wrVozO82zQGG1gghvZ0W764LnzX1?=
 =?us-ascii?Q?ynTNrO0k3KakNHotpAwaDPTDp6oWZSzlcw9WfGSq4XXRCNsCxEyTToWPYIsL?=
 =?us-ascii?Q?0LT0ahsoMDEVGSthHsME2WpbEA6MSijpTzzu4k1Uxbl1XoWLtctLv8jOlwd5?=
 =?us-ascii?Q?Nw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hP/WZnPkZDZqTO1MjW4IMs+aWOy9nJ6e2AdfCp539AJtDhyPpQtLRXwr1FpamctAfHEECYNpTgtSwlHY1ND4E9Sa3CPVOCmjBRTEg/ZcATz2+LO9kTRTduEQrBVL9m889jmE++KNrHVUp3n3RFZkZH3qVNo/iAUfKlVmsyl4wBs6j+G1XomTY2fx5LBznLq4uXV3JLh6Ktn3QuWBBOXVuvs1otvtJuHGWesaupAKxnk3YXPhTxzvr1kSEuHWsiGwQdW6vUhbMzwow7dgIpx47uAAwCqO+kYNXki3YDxXH3XZ98yyxFgrQzj8R6iPnoSrj1KBAmGPgeMgZoqpPlPe/UM8lHfexqmBr57j3zZ/wDntHtrm129A+RFpc/4h0FSBCGKhlW4OpopZHUrLZhwr/ZzL9ZI3g5gos54skOgN7j/mCSp9uP2kZVbppcq94yi+P76ON43vd32JStGPljZxDAah6ij+SS/kMJ6j7W6llQ8+zzUDWi5Ifw5FFDh6bmQ0N3QGkLCLbCoZ08mjS/gPRhSbOqFJ3kW2mwXFem0oNhZQy3xcAZfJ88vPGE3p130Ut6N6Of17r/e1MB2q/8R95L2mCF60RLxVpFJfzwy2gCE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99a41aab-7639-4d0d-98fa-08dcff15fa7b
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2024 10:21:44.3424
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Avj513UXtWEV2dEj564+tHwL0rgbo/FrDKT4gkYgWuP6keZrPQAZp7yNui/xb0iyQbGVwuE8J5+ZOOjSLo+/AvWLtwTgyDLC0xf7hefIbXM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4187
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-07_01,2024-11-06_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 adultscore=0 phishscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411070079
X-Proofpoint-ORIG-GUID: SDefPObSeaEcgdwoP9vvO5QWReDmC_4R
X-Proofpoint-GUID: SDefPObSeaEcgdwoP9vvO5QWReDmC_4R

From: William Roche <william.roche@oracle.com>

Merging and dump settings are handled by the remap notification
in addition to memory policy and preallocation.
If preallocation is set on a memory block, qemu_prealloc_mem()
call is needed also after a ram_block_discard_range() use for
this block.

Signed-off-by: William Roche <william.roche@oracle.com>
---
 system/physmem.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/system/physmem.c b/system/physmem.c
index e72ca31451..72129d5b1b 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -2225,8 +2225,6 @@ void qemu_ram_remap(ram_addr_t addr, ram_addr_t length)
                                      length, addr);
                         exit(1);
                     }
-                    memory_try_enable_merging(vaddr, length);
-                    qemu_ram_setup_dump(vaddr, length);
                 }
                 ram_block_notify_remap(block->host, offset, length);
             }
-- 
2.43.5


