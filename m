Return-Path: <kvm+bounces-32451-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 99D0A9D87ED
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 15:28:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2C77C163AA3
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 14:28:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA0771B393A;
	Mon, 25 Nov 2024 14:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AmVIolHW";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jzXwdYgt"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C7471B218B
	for <kvm@vger.kernel.org>; Mon, 25 Nov 2024 14:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732544864; cv=fail; b=jL1MM7O2eXGB2jyW93XD+QJwGKW/tv+J6Sx9Vquwq3WNwQfQNt+o0IHVzATLFKAzaktH8Y428Tew5jgj4SgWRvo25XxZToCERLTHjkM5I21tdL/c3NDEKRxjD76lE8dPDEV/t7U/yuNRdzok8Zqm99ByEGtK1Ueemc7i68zJRXo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732544864; c=relaxed/simple;
	bh=3x3eehASShvuSIOrTbpseKpgp35G4AXeSMtYgbSwscw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=I94j5nknP56xDxjlxc9I4KxrPdO7frfrpJObrp1IlYW10BuwOu4QpdgSSJZ66/CSyp5yjVz9Y4pZohYWrZrRG93SL4IRBrtZ+NlhrAX8NL4sWBFLXujWPYOrjuR/6VlrhiC8FB/Uh0+9KK3yeV2zBwvtMy4r7qRpf+wzF5RtcAw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AmVIolHW; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jzXwdYgt; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AP6fddJ008463;
	Mon, 25 Nov 2024 14:27:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=JHS4+XYDsk9j0XAnR57ueZ667oZE1aJSdUi/2nBXjAc=; b=
	AmVIolHWziJN0G6zC4KxoNIqlu5lbTrjwgVKMvJKqyX2qrUjDeIBWOzzGpDwFbTX
	coYyhHEkSCKGDHkdvwd/R19wyZ+yMQR0/wdXIOo2I8I0oQTmEf8mPUjlFGnL1mBO
	7wSmnNP9FuPLqlRXb7ByUcYUwYMHsX1fXxlrkdsvieLiCYZW/AJf+yoFS3pXxcUB
	wUha85ZDUBEQUrevN3O54f9gvV8Tolt/p6SfopqBF2pFDqnbkTdFhCrIOEBD2xIi
	3UUzJoSesrk9VWpBWKmyLPTJRTlpKOhfE+U7hSaFhefBEm7Wq6n7Wkf7x8dt5Max
	dM9fZyDSWzAxMtxQXuvG4w==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43382kb6wc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Nov 2024 14:27:25 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4APEPXkB002706;
	Mon, 25 Nov 2024 14:27:24 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4335g7tdjd-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Nov 2024 14:27:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LVKm9c/Rh1k9bPcI9tlo8X4HEIJ9osej5bPnoaUrqWS+/FHrrLmS37oHLJ9anCkrYPcLzVkoYwl2qah/uUbPCXZLIoXbZtJwSGpr34leOZonHho2wyL5yTiO0mRp7GKVp9xdYBC4qvyyf62x2i61PhNp8wWYEES4QN6+RrGDtmhAdUw8C26Xg4uzjaHSrJas1MOQj+kjMNVPENAwKm+9VznV1xJufUmULAHPGrLX2DXoBn8GXdKWQ0+9hXWEOEglQhH3NKcuW948UhU+D+VOefwrxaQEY79kC9nPYY+L++4JIRQighi089lSkIP82Ra4g/9jHlUi2Vgfpn/2g8vz3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JHS4+XYDsk9j0XAnR57ueZ667oZE1aJSdUi/2nBXjAc=;
 b=FD8UmQbwcoBv0U9+Whn4NX+hmilCvO7N9RxrGhMh/mFjeDIPc364LvUoeDSOolEaFYQFSnGNG4m+AFud3Ffo/MdVeN6qLLT1/WWwTphWEQTCSLnsF7NNGRkRfFP9DyT/vtbiKQHn3v5QUds/k3LzlBMl4umwGC50Tp6ZcH6QJaYolVNFlBEF7FSWU6a+zwTTOuu0zEFtxv+FmY6BbSR3e4y/mO7GRJXjXqt2pJr2g069vqgBLG3fRY740w/MCU3pkS+DIa0/VdYfgYsOCa+9IGAiQCz2OAep+2yxvurznQqo/Em26cnsPdHQJx//nuJ+Y0Ahi3bBNBCsxTu8nR9cPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JHS4+XYDsk9j0XAnR57ueZ667oZE1aJSdUi/2nBXjAc=;
 b=jzXwdYgt/r2oii/4DVzk0LujoAHbtf0iCuXDd3D3W++5qeP0Mt55osJ/+xH/pFejHv3GQUsULVzqCsi2d5c1JH/9cwYPd3dk+bNkclS3qS0BrMrgTM+H0kTlBNbHOieTLnIdeWXwz0SWmfKpGvYoc2uqWjNrVsQC4CAxuaJsQzE=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by IA1PR10MB5995.namprd10.prod.outlook.com (2603:10b6:208:3ed::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.21; Mon, 25 Nov
 2024 14:27:21 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%4]) with mapi id 15.20.8182.018; Mon, 25 Nov 2024
 14:27:21 +0000
From: =?UTF-8?q?=E2=80=9CWilliam=20Roche?= <william.roche@oracle.com>
To: david@redhat.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        qemu-arm@nongnu.org
Cc: william.roche@oracle.com, peterx@redhat.com, pbonzini@redhat.com,
        richard.henderson@linaro.org, philmd@linaro.org,
        peter.maydell@linaro.org, mtosatti@redhat.com, imammedo@redhat.com,
        eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
Subject: [PATCH v3 1/7] hwpoison_page_list and qemu_ram_remap are based of pages
Date: Mon, 25 Nov 2024 14:27:12 +0000
Message-ID: <20241125142718.3373203-2-william.roche@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241125142718.3373203-1-william.roche@oracle.com>
References: <cf587c8b-3894-4589-bfea-be5db70e81f3@redhat.com>
 <20241125142718.3373203-1-william.roche@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CY5PR10CA0020.namprd10.prod.outlook.com
 (2603:10b6:930:1c::10) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|IA1PR10MB5995:EE_
X-MS-Office365-Filtering-Correlation-Id: 2e825c46-19e7-42f2-cb56-08dd0d5d4613
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FugNdtLa8gfwNc2VNoAUwtWA37tKYnxVf+A3/0mDD2AohSS3dF2NVMHPyeHA?=
 =?us-ascii?Q?4B3tLGp56Ml9e7QbiBzGQ1vSo8vlskiy0WMu8Y4kuqkjGJ1IVpt4fCLVcsH8?=
 =?us-ascii?Q?iCXyrldWVIdU63wU2OARfBZsdOUsfZ+Q2OJFkAo4na2888KC5IB6yWaSwNOF?=
 =?us-ascii?Q?dQK5N1uurD0Z+l+QWJ1pKFcPR4SlclbdO7NrkEVkfcvDfXdufkUA32/QDYs4?=
 =?us-ascii?Q?YOUKVBFsF0whk728Z7u/e4w/WaC/T2QUtm8SX/CPRWdTSfIgOh0aS+Xip3EA?=
 =?us-ascii?Q?56j3yv5Tzb+lYbIEZjDd9wcepbSm2E+A0w1LxkCru3vcYpV9TzeJiE1L3W/k?=
 =?us-ascii?Q?VLfXmfi6T6g/yP9lUkMLhmGIJI5BRygCT12to76r6yT0JLSiKWvKWKEhNReb?=
 =?us-ascii?Q?9/EPmPuuUfF7vSBHpEX7gJYYBdOXpqs2IRzWYdd2oiDp43tfe5qLHHJp5Gcg?=
 =?us-ascii?Q?owkroXA2kGU8Gub/aDcNCeobYtyuK2ajMI2akAhjxGPaMmtECQG3ZWz7TfUz?=
 =?us-ascii?Q?0k42HrqInnN33QtvcaE9wSWR7BmAUrvzHHoRwA3prE2cHC634t32tdU3al6g?=
 =?us-ascii?Q?+NeFpNfrS48KAehXN9JtFQstpKB2eKL29IkP8ys+ChqrP2kcuqxhgxMc6Ti+?=
 =?us-ascii?Q?3jXTsAFQWNY/BvNLISaX0JEEaVFIYX8V61Ax+WOHxZNXn7x228qMd1q7WBae?=
 =?us-ascii?Q?vb/77CCEbfPbC7RH4PPlM2fo/TyMri98VylY5P1WgC/aguLOLb6STkSUOQrK?=
 =?us-ascii?Q?6yRzOchXNjCu77lV+v0TkhKMqvag7RJjjoACbu0h7ZEyjoHG2Us4c49Uy+W3?=
 =?us-ascii?Q?cDv94nYUkUM1Y7emgpEq4BlS3WFxQT5fHbn8iZ1Z/J/Eat1tXgRbPrf+eyln?=
 =?us-ascii?Q?7hRl8eF+iEdnta6oDhhJZ/LQig5vG8NDI1r4w83xmfQ1wbHVRBk73vxdqoeG?=
 =?us-ascii?Q?Jp21aotoZc4ZiOHIToYqR0dCPiWgUNBB0mQfmc/kvamYiGAu3XOEhyHLP47B?=
 =?us-ascii?Q?1NX0bkRJott5ppNF2A2oxvjXk+//pf+OoqggmeNJWjmPGUet7BWGvjccEXvC?=
 =?us-ascii?Q?5XqjIx74RgIZiGm9Ote6G9/RDIWlGKmjHO15T0lKMpTDzNUTvNnI5OGrkhsR?=
 =?us-ascii?Q?70vuGv23m+CVSkU8UwKVoZiQupkgWrNfq8aN7fDyzkBQoeYX5fjD5egxhZgs?=
 =?us-ascii?Q?d44w8WUCcIw/AOd4dPycQbh1HKLjaFmfluWxHWl6woKEZzw0A3HjtXGKltb0?=
 =?us-ascii?Q?OzD43gb6X+Ok0JEsJSHD2oy6XavAh7E+LjRCDTeGcs1oPdbhtfjkaWEhIEif?=
 =?us-ascii?Q?laO36M/+aMzifOQSpz5tsDkk8g7Lc+gG8dcjvvb3llbHBw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KVbkWsBNuW6SU13b1upwi8yQYmR2umhFmJ67V7qOnpcyxBy+KDlGD2QJySxJ?=
 =?us-ascii?Q?jqsOaIRIv2j3WsFjSn7Om4uohZYR4QTPp9oYHqEmIwA/YF1z8JjKGdQ4tlKE?=
 =?us-ascii?Q?MQrivcAv7dvXYUsnyKLS7HkxGQp6xJvQX38KBK4xkUn9p8nss19FMigcJnDv?=
 =?us-ascii?Q?HzL6e+ehjGq/4v2lKbc8aMfrNj31U2T/vTcqagUPMHhgIHICZA1tS/L7n8WW?=
 =?us-ascii?Q?2w0hBHH4O0K7nVvv17etlwLYSeIEaldFhlN4GUgRSi+qKijhNGAgmlfxW7YF?=
 =?us-ascii?Q?g/we4aSJrndLiOECnjJVDNX6aOWlX8/QpwWp3T8X7VN2hepl+pjLGdytHAzl?=
 =?us-ascii?Q?S5QMTHscI+uQ5vNZP6kzUlviLcsl/pjldrAEDicIQXQraf+WxC2sS4RY9bZd?=
 =?us-ascii?Q?X2RLYLwuRMIO6AtfyX4QzxFVM6yO/DCcDj4eKUo3eb8ZLNZ6mNDeGY/dCcd0?=
 =?us-ascii?Q?l/XoCwLPHJWdHi87y1d3wW9GpXbxKxCHUWWry7wuxNAthTWUJ3WdXIakyb1H?=
 =?us-ascii?Q?AI5pjUjgyo3W5SASrjV+GS8g0avgjmy0+FyiQbQSyP0255Un3eqO7FpxaFbv?=
 =?us-ascii?Q?qqHaiQlWcH+NInE9GlXI2Z27wOMunN+EQm9tFLwE54J8FmgE6J+Vn/6IW08p?=
 =?us-ascii?Q?M6g5BfqWzzeWzKgWyDZZMyVtn9tqctJRUQlhGNWge8fLsMkyFQkJw6IoFsyX?=
 =?us-ascii?Q?8yPZeUNoCNADr0ibuZ7gBQxnhDqoAnAvMpBITh5G4iyKSBYt4fWHO3ia7Qln?=
 =?us-ascii?Q?nUsb5LKiBsVYu++a7rG2g7UwU3LgQcCycb1TvRvnKC6Gjm3fvPcgwI2YbPNh?=
 =?us-ascii?Q?TUpJswfBA5WZfenPFsR6I+m6NYGtBpxtQIZgFM50bgSpoOwFS1rJZBEIwDaq?=
 =?us-ascii?Q?7+2hnp5/WF92j18iOZ3bafL8Y670Jkf0qxovRVBTO2F8tbLZKmm2bbGG0I3X?=
 =?us-ascii?Q?cPXKqsF4aQrymC2+XTUd6FMXZAytsHqUcbEXoCa6qR/lmn28grMW5bw2km+1?=
 =?us-ascii?Q?dnReoUB4V721e53aIX7iGzsw3NiwKCfX/g8BfiSQ/BjQIJ+EugfbnWU0tlxI?=
 =?us-ascii?Q?3hyovpCazHqPb9AIiK+kK5sR1BDQc+a4JXLDa9TzI1slm7PWzHGIGBktjnfh?=
 =?us-ascii?Q?mvfCqJysc3qdzFeLB3ociYlEKjGWjGP7VBvWfg1jPNMXRZ4kOOgvq7Bhmkot?=
 =?us-ascii?Q?lNVQvCAUu7kw9hlsEVJzc5YGMl78rz8di4M70gd8su1K5gnLVxfRuONd42kM?=
 =?us-ascii?Q?dKIZnJyD1LEQsCn9kS0IDDQtL2fHKIWS7rvw7ZZQdtzUhDTPxUlnr0xZuaGJ?=
 =?us-ascii?Q?CVWcvssuEHUCD05BVKth9I4Ke5NqpY8PTrQNJDaI8eiuU7Wzjc/LBSx02N6p?=
 =?us-ascii?Q?x7tyhdyY2ZVfldYE8RR6hTz5+8adlrkAsdsPAZ7EX0YwKi0jGrYpEevE4G46?=
 =?us-ascii?Q?+O1beH9uxiOe9k7kyquSl6cnan3X7vwCR8U0Qmp0z0EwXEFaVilybqUNxQPP?=
 =?us-ascii?Q?BeOBDToyR/D/hryOiKrnFJcXXG6ULa0mYvFaxpVIQJO+zFgPhm7p0aYAryTn?=
 =?us-ascii?Q?GS3SUzEj+OVpxkbY+SfRZf3xBy0+T7HY7RVMCrrhFce1K7nuuuP87YeAK5V8?=
 =?us-ascii?Q?mg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MYWba+rrXDHnMZoPKBW+Osl40NQLT+e3skDptYA+HJ7pHj7YzXUaPLXwPRM5ICCXuwU93Jb9DFiebXx+r8W2urA38Zyg5pEwgXhVSz1B9ntsz5+p431diMOsG1PAvi3RHjiNaS6SqhmeFoqhSNbcuXSW62QvtsVsAusnV7zIf7aVUJiBNuF8FWJdTkBwNCmWp3fLcWAIQv+Q32Nmq9gdDIn8SqFA/+nGiZYP/x9GB0VyQmTe3lLEBZtLDR1s1crNVpB36HKUthYn3VuypOF8s2+P8Sw8N9qpNf0aTb4J4ayoVxVEDbHlE+JqdqUVOevlSE9rSgo/Y2QBrmQjeRSYMrLa7hqrT9oHQxf4ORU7BPy+Mar1N/xWvNuMUBcyS+uNi3UtMQt//yUwdL1/PkS+tpVDahT7ABddIioDCw9Rb2hEjJB4VxMobJUqwZV69AJK1GqylGDM/7aR0J4KCNFde66DzS8GOp8/rrTswcUNVVVR+gY6FhGap4ZIp/jl2FDpBn396wySRgBMlVxskWfYzmfUlg8Yb6tXatM3bPK9BB0hYFqb9nRURn1lrrNKFNBkAlye1uDXdoIPF+UbyjOVAEODLheypmtdwDyxev6/wOg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e825c46-19e7-42f2-cb56-08dd0d5d4613
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2024 14:27:21.6949
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bSQQCMlxvzihG1hQYqRPTwP+5AsfUxbHVaTR3mAuVCeKS3+5DqgYPgKhyfEMnSWqWP207nmVE6iIgYBTvajjSvyrC3uvPCn1NwtDagB3YhA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB5995
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-25_09,2024-11-25_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2411250122
X-Proofpoint-ORIG-GUID: WAeDn65P7dQHYD5tO-NzawQDra0gcF2k
X-Proofpoint-GUID: WAeDn65P7dQHYD5tO-NzawQDra0gcF2k

From: William Roche <william.roche@oracle.com>

The list of hwpoison pages used to remap the memory on reset
is based on the backend real page size. When dealing with
hugepages, we create a single entry for the entire page.

Co-developed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: William Roche <william.roche@oracle.com>
---
 accel/kvm/kvm-all.c       |  6 +++++-
 include/exec/cpu-common.h |  3 ++-
 system/physmem.c          | 32 ++++++++++++++++++++++++++------
 3 files changed, 33 insertions(+), 8 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 801cff16a5..24c0c4ce3f 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -1278,7 +1278,7 @@ static void kvm_unpoison_all(void *param)
 
     QLIST_FOREACH_SAFE(page, &hwpoison_page_list, list, next_page) {
         QLIST_REMOVE(page, list);
-        qemu_ram_remap(page->ram_addr, TARGET_PAGE_SIZE);
+        qemu_ram_remap(page->ram_addr);
         g_free(page);
     }
 }
@@ -1286,6 +1286,10 @@ static void kvm_unpoison_all(void *param)
 void kvm_hwpoison_page_add(ram_addr_t ram_addr)
 {
     HWPoisonPage *page;
+    size_t page_size = qemu_ram_pagesize_from_addr(ram_addr);
+
+    if (page_size > TARGET_PAGE_SIZE)
+        ram_addr = QEMU_ALIGN_DOWN(ram_addr, page_size);
 
     QLIST_FOREACH(page, &hwpoison_page_list, list) {
         if (page->ram_addr == ram_addr) {
diff --git a/include/exec/cpu-common.h b/include/exec/cpu-common.h
index 638dc806a5..59fbb324fa 100644
--- a/include/exec/cpu-common.h
+++ b/include/exec/cpu-common.h
@@ -67,7 +67,7 @@ typedef uintptr_t ram_addr_t;
 
 /* memory API */
 
-void qemu_ram_remap(ram_addr_t addr, ram_addr_t length);
+void qemu_ram_remap(ram_addr_t addr);
 /* This should not be used by devices.  */
 ram_addr_t qemu_ram_addr_from_host(void *ptr);
 ram_addr_t qemu_ram_addr_from_host_nofail(void *ptr);
@@ -108,6 +108,7 @@ bool qemu_ram_is_named_file(RAMBlock *rb);
 int qemu_ram_get_fd(RAMBlock *rb);
 
 size_t qemu_ram_pagesize(RAMBlock *block);
+size_t qemu_ram_pagesize_from_addr(ram_addr_t addr);
 size_t qemu_ram_pagesize_largest(void);
 
 /**
diff --git a/system/physmem.c b/system/physmem.c
index dc1db3a384..410eabd29d 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -1665,6 +1665,19 @@ size_t qemu_ram_pagesize(RAMBlock *rb)
     return rb->page_size;
 }
 
+/* Return backend real page size used for the given ram_addr. */
+size_t qemu_ram_pagesize_from_addr(ram_addr_t addr)
+{
+    RAMBlock *rb;
+
+    RCU_READ_LOCK_GUARD();
+    rb =  qemu_get_ram_block(addr);
+    if (!rb) {
+        return TARGET_PAGE_SIZE;
+    }
+    return qemu_ram_pagesize(rb);
+}
+
 /* Returns the largest size of page in use */
 size_t qemu_ram_pagesize_largest(void)
 {
@@ -2167,17 +2180,22 @@ void qemu_ram_free(RAMBlock *block)
 }
 
 #ifndef _WIN32
-void qemu_ram_remap(ram_addr_t addr, ram_addr_t length)
+void qemu_ram_remap(ram_addr_t addr)
 {
     RAMBlock *block;
     ram_addr_t offset;
     int flags;
     void *area, *vaddr;
     int prot;
+    size_t page_size;
 
     RAMBLOCK_FOREACH(block) {
         offset = addr - block->offset;
         if (offset < block->max_length) {
+            /* Respect the pagesize of our RAMBlock */
+            page_size = qemu_ram_pagesize(block);
+            offset = QEMU_ALIGN_DOWN(offset, page_size);
+
             vaddr = ramblock_ptr(block, offset);
             if (block->flags & RAM_PREALLOC) {
                 ;
@@ -2191,21 +2209,23 @@ void qemu_ram_remap(ram_addr_t addr, ram_addr_t length)
                 prot = PROT_READ;
                 prot |= block->flags & RAM_READONLY ? 0 : PROT_WRITE;
                 if (block->fd >= 0) {
-                    area = mmap(vaddr, length, prot, flags, block->fd,
+                    area = mmap(vaddr, page_size, prot, flags, block->fd,
                                 offset + block->fd_offset);
                 } else {
                     flags |= MAP_ANONYMOUS;
-                    area = mmap(vaddr, length, prot, flags, -1, 0);
+                    area = mmap(vaddr, page_size, prot, flags, -1, 0);
                 }
                 if (area != vaddr) {
                     error_report("Could not remap addr: "
                                  RAM_ADDR_FMT "@" RAM_ADDR_FMT "",
-                                 length, addr);
+                                 page_size, addr);
                     exit(1);
                 }
-                memory_try_enable_merging(vaddr, length);
-                qemu_ram_setup_dump(vaddr, length);
+                memory_try_enable_merging(vaddr, page_size);
+                qemu_ram_setup_dump(vaddr, page_size);
             }
+
+            break;
         }
     }
 }
-- 
2.43.5


