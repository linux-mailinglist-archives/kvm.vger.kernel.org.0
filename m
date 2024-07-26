Return-Path: <kvm+bounces-22354-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0952393D9A9
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 22:22:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6F1F6B233FC
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 20:22:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11BAB148833;
	Fri, 26 Jul 2024 20:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JJit1hjW";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="xlgGU40+"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BFDA383BF;
	Fri, 26 Jul 2024 20:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722025344; cv=fail; b=IYPeO2tt/QvhYc0s9D23JXjtW6MNK82zVqu3wo42rBgHdotfwe4iTFSw9NA/lDKn4HZ268gXEir6+/v4WcIab0rdkqiFizWOvR+XF66gEJbgOqJeLyuzL4E4jmcpepZvGygT8gzsi7FofNmuDO2v65kIxrsL4IfefpUxRqPHFf8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722025344; c=relaxed/simple;
	bh=GCoDdKRU2x/lcp0D9ko4fzveB5KVhWbqcLKRqZxqWfw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Yqu9mKIZbug3NxkamV5yPvCsyJ/JtetXHb6gA6Z4M2NzCaWhvVfE0/ZYcGtHOY5IDz+R4o/FIhyvj/IfF9fdK0TWNm4oEY5AhJwpMZF6MQQG8/NtfrFyoaSpNdQUgZ0isbI3AQLaYC3nbqPNIodCd4sdO3MmTpqg56o/M3XupME=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JJit1hjW; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=xlgGU40+; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46QIM28j013734;
	Fri, 26 Jul 2024 20:21:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=24qhyYScmzk3VEy7btky5OmyKHeAi8lc5bpEIXdQe9s=; b=
	JJit1hjW3UcHcl2HjnrTff2/TtwocUo2+khhtl6187T8UntJ4d9v/g+Jjtd7drAr
	NsF20kLX92zpHvrxgNslAymqk1AoNgM+5HdXTuLDM3csJeDRJlFwWDAEIuUGPI5N
	zDfL2LI8f1U6M5GFTSq5eoAfCITM1KkFqyqv8ndXN74KcdiGzr63g4o7HMZQPEN3
	rbysSF9WBDIwJMKeU4UVOQMziOXSxDyc7Ccagc1fVypH4kiyp/2g7DSdiY+aw6sP
	Za8nHcO10iXfwVVjjNXj/OSyynYEE/y3R0mpRk+m65nMKz9z73MdjRYkbh2V8q4y
	WjHIA4JEwtJ9v2bK2PSTUA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40k7yuvj60-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 26 Jul 2024 20:21:41 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46QJ9tZI038883;
	Fri, 26 Jul 2024 20:21:41 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2044.outbound.protection.outlook.com [104.47.70.44])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 40h26s48f4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 26 Jul 2024 20:21:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Sji5RGEtOsg6iSKoxtznzLeAHqj4jlEl6yaAh2Vbsj5Ej6sa3QN22ZlJXnoXw5gxQFU+3QmLV+stkOak8zp7oZeqOnFs5pYBaYdwzJfylmcSWpVA28spaftaZv7dnZ2yHma79aQ0MJ+/CGI3MDtmhSB76qo789KywlQ1P7FXn1V/vGVbZD8T+6eoFfnW4Fd8/CuNNtNfhU906pkR15RX9Sf18ezvST8p2jTL7k2z9rLdJD7fQcMr+xbkw99OKUSnY0MHqeuGtigTnqeKj47mJMQz2uG8yjRwND4u2RicMgTMItiFWMRqfnwFjMJ+hQaV9lx+/Jj/p8YdHjhUWfYwLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=24qhyYScmzk3VEy7btky5OmyKHeAi8lc5bpEIXdQe9s=;
 b=a98/bX58FAk6y+asRjvBl+UBGEpgnAOcTcY1yw61lFetKkNWpMK3izQ6TixlMLD3Y8tMeJjzVfeWv/Es2MGXR+BSMdCF+KaAIbYGq6IKx53t5x+zUTB6l8NhWOcpxe7vvsCPyohWqeBUHvyzWBCphZUMvToartnw7ic9Mbs9EBGOUfhq0rD6Xz/9ilFQtBKR3oNAoo1i5nWGS89Ov0FwSMDWgMU51BUoNw+bvJWU1wV/qwzgXnjadeytGosnjF2adF9iU0r7D17KmOFIMnvmf18JdSFyYVJVVxcjj+4mMoCt/Vu2zW9LXAPNWugJ4cbuZYG/zZLbsXrG8kgeDLUT2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=24qhyYScmzk3VEy7btky5OmyKHeAi8lc5bpEIXdQe9s=;
 b=xlgGU40+JhR7PzwElpEmUTB0mZvN1EPq+DYhDEK4K2deWz/VUebfr+zf5HTrYgfPN1XpEgebzIchtmJKA8n8Mc1k9YFJtSci9EGqezxbvGGgHwdVn0PhCE4LdO0XW8ygJbKZKzRu3TY/8Oojr5pmEG2F88YV/Io7hdL1HuwbFMI=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by CH0PR10MB5178.namprd10.prod.outlook.com (2603:10b6:610:dd::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.20; Fri, 26 Jul
 2024 20:21:39 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e%4]) with mapi id 15.20.7784.020; Fri, 26 Jul 2024
 20:21:39 +0000
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
        misono.tomohiro@fujitsu.com, joao.m.martins@oracle.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
        ankur.a.arora@oracle.com
Subject: [PATCH v6 04/10] cpuidle-haltpoll: define arch_haltpoll_want()
Date: Fri, 26 Jul 2024 13:21:28 -0700
Message-Id: <20240726202134.627514-2-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240726202134.627514-1-ankur.a.arora@oracle.com>
References: <20240726201332.626395-1-ankur.a.arora@oracle.com>
 <20240726202134.627514-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0276.namprd04.prod.outlook.com
 (2603:10b6:303:89::11) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|CH0PR10MB5178:EE_
X-MS-Office365-Filtering-Correlation-Id: a78bd68e-d46f-4848-f43a-08dcadb08e0d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?i/P1+v7KXQCtMoO37y9O26qry5XCL+4umVZrinHGlxNAz7vf6x49J4Z/GUOL?=
 =?us-ascii?Q?t1LLDO/esE8IA8JXIcRZexqj3GYrzRereLY27GBN2pZNqMd57jhUIrvInIk0?=
 =?us-ascii?Q?iDbyoHzkYqDw+osfNkQPeNlHYTfsfIGA1f8wyXuPB6GaIV2hKncUjEMe/89p?=
 =?us-ascii?Q?yJ10/9Hmr+1pXD/cc4IJarJFUCPh0ONBKz7XgNfM1kAtreZBK0IzEy5JD10E?=
 =?us-ascii?Q?KqKBxlUT10NGwjnIGTgxGXQOSv9aN7d2bpgHi1cIOzwKHCq/dwrAbNB1jQd/?=
 =?us-ascii?Q?eIbPS0tPMr8KJVHeMrExyTNyhn37hEqgdZhkudlHXfCtBpmuGFMEF5dDEu05?=
 =?us-ascii?Q?DW6H0rZC2sC2iwnaAfsNpZu1KAu4jUtsrObzLhw5WWWLB+87p3pa66KyC06r?=
 =?us-ascii?Q?VCfNNTegTvbEOIGOTNKGe5w8oNbOePwYsh6v0VIYVphZWEXiS/sWMHyB+psA?=
 =?us-ascii?Q?lzesPDiEfv1J8xVm4CWZfgY2ElpVTp3ZGl+RQODI9iS/fRsfFIO50s++w66n?=
 =?us-ascii?Q?jMzc/yI3ripQZ1rhunABUukgCBZvksV221gQxUHXxhw1wQdKqyKvDR1FjQFl?=
 =?us-ascii?Q?5iOutBQRcB8X5uyrpM/xX3oJw2JUjS+DPKWkHjY/kMT00+HG/KuqJUEaQG4I?=
 =?us-ascii?Q?SVcfSZctICfe+lOOfoDxknu+qc1zsypu6/pc+KkN4CkqCFgJAj514JeckBWc?=
 =?us-ascii?Q?2VFIIY03mzXY1HdTTPrIwkpJCz8LRSNzTPyYfdwTmmutOFb1aHdNHR6gUGX+?=
 =?us-ascii?Q?XyBLNYxGeat7eumCGQdwd4OUajdqwa4BEK4QiqkvyKJztQS65/AsCAowU0C6?=
 =?us-ascii?Q?B/rBx9xwau/2P6vifQFc4+TtFKFMb4U7c/yiIyRpKrpnnNAOsTgwsPHZSWi1?=
 =?us-ascii?Q?KIJCHcwIcSjJx8tITLuKYwzL4i33Gw68c71cjhL+4nR8TocRfAkv6tVw/Crx?=
 =?us-ascii?Q?7LW3beAHXmmyRK4P/3jyMnZAfJ9epzDtXrNyFF3NqhYJ9hvxDZvA00Y5S10h?=
 =?us-ascii?Q?hrYFCsABGkabocAKnhr/feBtr39A/xpyka6C5ECsvzT418a28qyEQGNVTq8a?=
 =?us-ascii?Q?RSNi8jIyg34SRQYf0gdcFWyyz3bZzaiHxs9VnM+YZSFGPzg3SPRD+pPHfZDf?=
 =?us-ascii?Q?Y+H1zwbVEoEvz+tUBlgMWUNSuK5G8gif9rB3JhZUABZAtRsoIXgnb7fHujbw?=
 =?us-ascii?Q?zwDQNs2wxTNroIQ76qNrvMDqqiDmY3RlWYom9oJRgDfFAl0egJOB56qDNdEN?=
 =?us-ascii?Q?N8T6D+H8xqWFD8SzJa4yLIniBlCvo7aZfuXk9X9nF9Dj4z8iXOrOj0NxeS8z?=
 =?us-ascii?Q?XWDaX61xWYupQ2qAKG5463046uRhNhfOfZawZe6QgJoJYA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Z7BAT1JK926VcN866NbhAqcu5YRP8dIGnrB1BDizRlbz0hUPMPMBqYIyR70H?=
 =?us-ascii?Q?eNX9UuPI5R/a/8QDqWo7t32e9UTiu4TXnU5Y/u1NyXX4UUnwxUcshFSgtr63?=
 =?us-ascii?Q?SAm7rzWmKBIzPkm94MUMilD0fDPOOwly7T/EASjaVBf0XhkGIK9dbjSLVtgQ?=
 =?us-ascii?Q?B8PjiXvicBTvcJgI3BhFcbUiNuSsKcBlDay4aPVxNAlQ7pGcXSr/qfGraeY1?=
 =?us-ascii?Q?d+Q7wfOKwILXq1cUL6hzABY4Q1T7bHbFqK+3QaHpZdyQkPc8+7UgC4g19Xrv?=
 =?us-ascii?Q?6puvNp4hqTTinAbe6mS8G8AhTWkwtVN6tsAdjtxpGtwU8y4vnk8N0+WcbhM+?=
 =?us-ascii?Q?e19uRkpaXpt0dcSBqXOBO3Qtl1iyXt3IGAhb3IDVxTdfMaxdzvo+GB3E2b/x?=
 =?us-ascii?Q?/uz8fk/oD/b28uAdWJ8kQJIcvhq5fDmcGbwpmLq2uptlYA0RMZ1F6bfx3Mr2?=
 =?us-ascii?Q?fMCbkAc5eqKCDJIJjueq5V8+YtZkXl5iWkLSj3EVxvpFfFi0RsVjmpQR8u2O?=
 =?us-ascii?Q?b77RJcVtlY+MCMs/Sz1BpujqHUjyf2VMPbxOVZ6OyzYIl3Qv5LQX49w4y8+H?=
 =?us-ascii?Q?uloFJffLhya4qq2VVGlB5R3Smjqh71QHKpGtSqdyQiqB3Frv2hk+ClHoN9ca?=
 =?us-ascii?Q?IhWWuIiN8YaEoJiXEmhD4qUyEuzR8KAnNCgGuT0pMWpQ9qJD8hXQTQz3wd/w?=
 =?us-ascii?Q?kXkpnT5TGEKty/87ogON75VxXSokiSjRG099D4WwASy4kFTZw8g2TyIsV6kd?=
 =?us-ascii?Q?mm+KWhG4fad0USw6ACPG0PPDTQfF3gUfHEliN4FBenLza5N8FP+G8f0J5FuN?=
 =?us-ascii?Q?WhjQPofAksvBi6Y6avSj5kPov7SQNF8osO6XkVJ5vsxjEvJymARLTleBCD/W?=
 =?us-ascii?Q?kybkRriWCzhYNJw8SJc/GPitzoU5oxizZnr/56kcMgUF5CNpsyPtrBYIXGFH?=
 =?us-ascii?Q?F11iETKLcla4MnMr+JaIB5moo/ErKHh5pcp+DgT2bQ1b/MzjpGhZw5cFgiy6?=
 =?us-ascii?Q?KD7R6+aqC/iFEXVQz0COoiqDqWoWaSyORlDwaZGDiep4vu15eXEtKxBPdY0S?=
 =?us-ascii?Q?fQ+VSa67DmBoNKsaFSOW7kSDh27r1DcrXIVqBEg28BNIIByw4b6nCGMdbqaT?=
 =?us-ascii?Q?+RImEGRWsAw93aO39NZQ2IoBZgYRlLPOKZ9lklsSG5igtYcRp42Hb02zGLPz?=
 =?us-ascii?Q?JNssaHyil1EJOPs4VwYNb6At/Q2kfTcFPLWaQz06GlCh1ijHZM+b2Fg3ddQu?=
 =?us-ascii?Q?DKx+ebrEodrkhdlIAdtWpH6DuypYg6EoXLTkky5CBqW6XS7UzlSzQx9Qz8GD?=
 =?us-ascii?Q?X+o7+54W4oILOxnN0JzD7Z75X4SMWT//bSKBSenDugUwAWT/TVP3a21XPBHr?=
 =?us-ascii?Q?f6V1OzTPBojFtpDHNVdzcDutgUfzj6+PxlFZZxQ5TtDMDORZusMPU9GFhh1/?=
 =?us-ascii?Q?7TBD2oRhR+GdsqzMHmx0v09lF+mPMGNXSELnkv0oSjT5IA+sRfxNIoQK/wch?=
 =?us-ascii?Q?L3xhNWbgfjuWjGaCpepNwFlwJ0+Un+pXY9D4kG2Cppg/AGWx4Al4qAN2tUCl?=
 =?us-ascii?Q?r6nujcT5sNxubJF1c+YBxMrwy1tMzus5BemENWDu38LtidBzxJyCBBYzw8Y0?=
 =?us-ascii?Q?XQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	GK4WXGUZX2L495JETTpQKb7Ob7wD2UMXUa/3DhQroviDTz9GB/i12h1i57u39aXnHfkXDqLwyfA4VMkV3siplY75tE679Q8BiQ7RzgUKPUTPu5xbq+h5VuuZmEEAQTb0fhERjnWX9iJwjGEKCNJoXaH81a6j1vdBWf6I0A6P3Vm943Hfm7Us2fG6JbOIpfigenH8t05YeayF764mNFYqPyU4vuEwtgmQQHzRGi2ihdDmTiIQy9K8kyCwdF6wB2pzPnbWudkJXnBd7Caj/lXpGNKD7aw9dhJTbfWXeKvOW9qEUdA4AiVJBNcfzBaVso+Ky0Eqxixlftj/68FM5BQJXfitNDN7qPkK2J3q8a/3CVFPGFRbusQ8VLKFzcYbqKRTI8o3GMrxkrepXUFz40nutRwHbxMGoXvJq5f1VDlQZw5IDAPq5FG4P+S5xO0mWSs9juqColWzgyPC+UzuiAnVvWG5kD2TJgJR+sbyN/1ZF1hCpcFHzGywYmgoPM6/WUpa0rPybzo6c4JPffN0YZQYEgpYkemsPd8jDViU4GftjcxXdeeVG20NPeVSfhTeSNWYRANYLpWhXO5CcWRu0b6wH9NmWCYjZCz/bfiKgNnDYrE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a78bd68e-d46f-4848-f43a-08dcadb08e0d
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2024 20:21:39.0193
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zVW6G2yLrilTZihQF4+oTIE8xdDP+KMoii30DSoM34QPcJMDdSgZGdFUqeYrWLui3gzlzAQdmk+CP5HmCF9J3WrBH1ktbiY/croS7OkLGAQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5178
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-26_12,2024-07-26_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 adultscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2407260138
X-Proofpoint-GUID: Sh1GbOIojTupsAvChn0gUfpuMNy70GFE
X-Proofpoint-ORIG-GUID: Sh1GbOIojTupsAvChn0gUfpuMNy70GFE

From: Joao Martins <joao.m.martins@oracle.com>

kvm_para_has_hint(KVM_HINTS_REALTIME) is defined only on x86. In
pursuit of making cpuidle-haltpoll architecture independent, define
arch_haltpoll_want() which handles the architectural checks for
enabling haltpoll.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Mihai Carabas <mihai.carabas@oracle.com>
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 arch/x86/include/asm/cpuidle_haltpoll.h |  1 +
 arch/x86/kernel/kvm.c                   | 13 +++++++++++++
 drivers/cpuidle/cpuidle-haltpoll.c      | 12 +-----------
 include/linux/cpuidle_haltpoll.h        |  5 +++++
 4 files changed, 20 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/cpuidle_haltpoll.h b/arch/x86/include/asm/cpuidle_haltpoll.h
index c8b39c6716ff..8a0a12769c2e 100644
--- a/arch/x86/include/asm/cpuidle_haltpoll.h
+++ b/arch/x86/include/asm/cpuidle_haltpoll.h
@@ -4,5 +4,6 @@
 
 void arch_haltpoll_enable(unsigned int cpu);
 void arch_haltpoll_disable(unsigned int cpu);
+bool arch_haltpoll_want(bool force);
 
 #endif
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 263f8aed4e2c..63710cb1aa63 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -1151,4 +1151,17 @@ void arch_haltpoll_disable(unsigned int cpu)
 	smp_call_function_single(cpu, kvm_enable_host_haltpoll, NULL, 1);
 }
 EXPORT_SYMBOL_GPL(arch_haltpoll_disable);
+
+bool arch_haltpoll_want(bool force)
+{
+	/* Do not load haltpoll if idle= is passed */
+	if (boot_option_idle_override != IDLE_NO_OVERRIDE)
+		return false;
+
+	if (!kvm_para_available())
+		return false;
+
+	return kvm_para_has_hint(KVM_HINTS_REALTIME) || force;
+}
+EXPORT_SYMBOL_GPL(arch_haltpoll_want);
 #endif
diff --git a/drivers/cpuidle/cpuidle-haltpoll.c b/drivers/cpuidle/cpuidle-haltpoll.c
index d8515d5c0853..d47906632ce3 100644
--- a/drivers/cpuidle/cpuidle-haltpoll.c
+++ b/drivers/cpuidle/cpuidle-haltpoll.c
@@ -15,7 +15,6 @@
 #include <linux/cpuidle.h>
 #include <linux/module.h>
 #include <linux/sched/idle.h>
-#include <linux/kvm_para.h>
 #include <linux/cpuidle_haltpoll.h>
 
 static bool force __read_mostly;
@@ -93,21 +92,12 @@ static void haltpoll_uninit(void)
 	haltpoll_cpuidle_devices = NULL;
 }
 
-static bool haltpoll_want(void)
-{
-	return kvm_para_has_hint(KVM_HINTS_REALTIME) || force;
-}
-
 static int __init haltpoll_init(void)
 {
 	int ret;
 	struct cpuidle_driver *drv = &haltpoll_driver;
 
-	/* Do not load haltpoll if idle= is passed */
-	if (boot_option_idle_override != IDLE_NO_OVERRIDE)
-		return -ENODEV;
-
-	if (!kvm_para_available() || !haltpoll_want())
+	if (!arch_haltpoll_want(force))
 		return -ENODEV;
 
 	cpuidle_poll_state_init(drv);
diff --git a/include/linux/cpuidle_haltpoll.h b/include/linux/cpuidle_haltpoll.h
index d50c1e0411a2..68eb7a757120 100644
--- a/include/linux/cpuidle_haltpoll.h
+++ b/include/linux/cpuidle_haltpoll.h
@@ -12,5 +12,10 @@ static inline void arch_haltpoll_enable(unsigned int cpu)
 static inline void arch_haltpoll_disable(unsigned int cpu)
 {
 }
+
+static inline bool arch_haltpoll_want(bool force)
+{
+	return false;
+}
 #endif
 #endif
-- 
2.43.5


