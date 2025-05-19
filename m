Return-Path: <kvm+bounces-46988-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E06BEABC16A
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 16:57:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 001E11B6229C
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 14:57:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1083128467D;
	Mon, 19 May 2025 14:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="L9tr7xvE";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="XR1ybQ83"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 501863F9D2;
	Mon, 19 May 2025 14:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747666646; cv=fail; b=nPmXjRK3hcDFF52Lzhalhi8K2yoE6KFKPyuGqzZjXdQOeC0VXnr0/TBbZ9OWgyZy/cYFDtrpjoL8QbFLEfWL2+cHNwKNAk9X8ymivGp1iEuVEGOgnq/D93SSQ6CsS2BniVwsgchSWzr22lrLexJw1sM0GThNZVHH7J6jPUUb64o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747666646; c=relaxed/simple;
	bh=H482b5odLUimwEiA5Lnap8DqAfU8T4QuncZ4svb/YS8=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=iiSZl3k9FXPYjK7mFdUlFHF0TgJ0GDpH+/WMpivP/2eO0DPxL9JdEj5SEYS6Pyr/jxXadYwI7Np2Ncq4W0AG2VuBAx/Q2l/DaMXyN8q1SZzAWsS7WgtP8TCXQyymf853bbcUz94xBfiH7uXkQsk7Sl9cw42wvxZDfYXgRt25bhQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=L9tr7xvE; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=XR1ybQ83; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54JEXfWl012879;
	Mon, 19 May 2025 14:57:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=IFim86bjRg0ozrMo
	e8rc/sapFWbpQRqYt31lWhuhLpI=; b=L9tr7xvEgnxakSdot7gmZC95m1/IvHGD
	+dIVuZWtRir6rYa/wXG4iHPB/r0wPpoUxFFn8xYPrsgRCbVkGv+gRzClPj9qh1hg
	coLW3xIy5lcvvMNEmio0z320DXY1G+WA/vrmemZ9M5BEtO24nA4//Q5oPg41ilrr
	PvDiOS64BcLFxsiMPqUq9DP3/35lessIdTSbekH4XdtgJg02QJO0Qml3YDoDsGDk
	AiqWSX4Hq/6nwsR7X2SgTk9UFnY3alurJm7wW7YD8fv2K2dChos1GfZRgtd33+Zz
	AHCjgWKG+Al0uhDVASbm7cRVVPC/VfCx99K3E6Nf8WmxSS2/1T9gSw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46pj2ub6b7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 May 2025 14:57:07 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54JDUBt3037227;
	Mon, 19 May 2025 14:57:07 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46pgw7j3fd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 May 2025 14:57:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WmLrBUflElx6pdZP5AJE4fsG1H/mX9cAKcIVQVlGljuoObAsALfnil6w3Wd+Xqe0rGhbI3vIfUmngsd69fFUcZ0KwbLdHz/LF4CYkUt3HQsDDhqEVEANcdsPNoJmoH6Mm0JTlZsiutx+9Y9L6frZhqmgE3EZr/qN3ihgeZXolrKHeIujrO5oDUgmqCasKtE7XUQOJq/JATSbLoS3SmgNYhoNfuQsGmcZsYHHcEHiEHIZZHE/qe663P95vcXnXsFbYD9p9HkNuZNoS6bZCJm7tjDaLRpwOLWqaOfaSoB9TEK1GLcJXunO/t+wBoW5JwpYewGzK/8a5WvCk+jbUXgthg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IFim86bjRg0ozrMoe8rc/sapFWbpQRqYt31lWhuhLpI=;
 b=tpxw1A5D2O7mOsULi5igEsr3NK4ObJFhpPSuP3Iv92TNnVLjpDBz3wBCfk8iAPNs84VNQZJ2hCuuhJYfC1V+9bEoy3zByRZL9CntI+PFIDuZdkha02RYzh8U/dndCa2K+3UD1Yy5YNYtwPcJc0NQQ+AKBnFZ1AuYZSsg4OFu79ONvTor9QW57qetYN45ePXHj2tTBxoVfOLT/P3TyxLTPM17m0KVNmtRnKotMQ4FHHByulK9G3akEwL7Hno2harkrN/gOrZ1ldV6fuWLKsjedpoR7SWXJsBcmqmdsmy1QPsDvtEHs5XvkYRATO5lIovarh0mAsxwJl7IK8Vuk6ZG9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IFim86bjRg0ozrMoe8rc/sapFWbpQRqYt31lWhuhLpI=;
 b=XR1ybQ83hAfuiboP4kpN3BzlIGqx7e1SIblq8O0jN0ZiZhY+KuinUS9zNtQU8carUPyBA4T/fFr+N/h35+vs5YVgSzkQr+mQvpgvjCMigQ/2aPvHWmsomIb8b7xSjU/5C4O5TiAV/iMg2o7RV1Oddn01ETzXa+UTN2bD/Cy0bC0=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SA2PR10MB4585.namprd10.prod.outlook.com (2603:10b6:806:11c::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.30; Mon, 19 May
 2025 14:57:04 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.8746.030; Mon, 19 May 2025
 14:57:03 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James Houghton <jthoughton@google.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>,
        Yang Shi <yang@os.amperecomputing.com>,
        David Hildenbrand <david@redhat.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Matthew Wilcox <willy@infradead.org>,
        Janosch Frank <frankja@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [RESEND PATCH] KVM: s390: rename PROT_NONE to PROT_TYPE_DUMMY
Date: Mon, 19 May 2025 15:56:57 +0100
Message-ID: <20250519145657.178365-1-lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.49.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0361.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18e::6) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SA2PR10MB4585:EE_
X-MS-Office365-Filtering-Correlation-Id: 93ad941f-4927-4b33-f590-08dd96e56aae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BNH324VSEB2TE76O68BhrCogzATr3If1EXRT48DfchLZNQJZo1ETwRuqe8Pz?=
 =?us-ascii?Q?yw9lok0SoPRTdVOyDXEQY1xE6sQvEO7EU4Zu+6FaensGS8JsACMPrCRP9qNZ?=
 =?us-ascii?Q?5FkGpXLRSW3DzQlCkEHfLDHhpV4pn1yYvsy/mBUb2bZQca+r+Agjj6VX/xmF?=
 =?us-ascii?Q?RS2Bz/pc4q3JmX78wguXmH1vNAZ2hp/yPzImnoD9b1UEJHsVq1vkWPpt89H2?=
 =?us-ascii?Q?Lejxc9xdxU7sGgbhis8lclQiINW12Hq5zabizXW9NWjqHTlZD6aWVud2QtZj?=
 =?us-ascii?Q?Q0fI+90s/DF3B8BGsmO9CqCM9/8CZardZRHskKe87oPJSZqEftqoOQ2eYzyc?=
 =?us-ascii?Q?71XTZ8esHNN4uWu5iyUK8KqZmYjk6SwugZKS3PGL+EAhM9Y9X3KUoiIEjTV4?=
 =?us-ascii?Q?CyrDStXx8oXiTwwhdMlqoTk2b2QH9BNntDSTi8bTBB/5fswZ1Ocw24Cs9knL?=
 =?us-ascii?Q?dfYgKEXQ2IE0Rqnu6es37g8BTnaFGSLBkDD/R4fn8uP3D9AMDGJiRnngOucX?=
 =?us-ascii?Q?6X/lHwI7PzO7yeHtmYwU3uPMugIKjPIl2zDjV2v9LTHv8sZgiUQLA3oeluDd?=
 =?us-ascii?Q?ho2ZHl4F7b/yA9zvK8SBuYhXQ3BwhwK7IKV9WabaWcJlumRSPruBpZKiTPqv?=
 =?us-ascii?Q?G7VCwwKOBzuC4mFGYeYDmOPXyCaia3yOLyXkuQhNdpHaFi8GFiuTixEAAsbi?=
 =?us-ascii?Q?Qx60Yh+DNwk2tQs6nLcARP0fWUgs/o03AtqD5glI7cbiGZVXelOzz6d7Sxq9?=
 =?us-ascii?Q?BaCwmMcMqRXrbLYbNhSgf/yu2vvKrGyC6TvI8MfJgyNdHjou4/lBBWUFk4iJ?=
 =?us-ascii?Q?4NoMcaIK/K4RAqD+eY8aimVEin4XGA6GZBW3Dx09cCj9ZTHR+nF4vHPLPTzf?=
 =?us-ascii?Q?YwpmlJhRFscPZGX0yOxNQwlxGlDPRnEobuk3mecLuvEUepCcGB1kZRLiOmQd?=
 =?us-ascii?Q?37zBup9HbapfXjsFBHOdFVno2jrTSj7aj+xGdq/6x9R4X2ONOeKMFpek7IfF?=
 =?us-ascii?Q?ZsvWIGKxn/NOCHtA0akaftqjEQxWP1iHuXXCEa/+X4zgNHU8NyNcu6CKVG/L?=
 =?us-ascii?Q?y1rJKGeqZf8ka6T4Kmi0w4c8SMcaswhL27RUrPN5ETq8ikl1+M/onf1p2ytj?=
 =?us-ascii?Q?/u4RKQ8MDpOrSzxBwP8F5gfQW2Uo0COEcwvXs9dywMmDUmrcSY8jNKhRDoSc?=
 =?us-ascii?Q?avcU4dgFgaFd6bkyG68CiX6BiWNXuGHxQO4IqX19DZiWc0yTFw65v7JHPlRm?=
 =?us-ascii?Q?6e+thCjrQjrBqx/SxcdaXln3W+8UvAJu714+inn5L94/DOixh7riCjNV6flI?=
 =?us-ascii?Q?QhaaFtzXsy+8ZUJSQoAOZHgMglk9ZAiQz7ieO2o1+OJWdqMn+mAHGW6huiKR?=
 =?us-ascii?Q?s01dY/CjfaEFcvSL+80hhcHeq7xa?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IoJf63TOAZdJCVi7wLcDDli7JLJq3eDuj5IM7jbzjClhqPBfVb1haV5c9OiC?=
 =?us-ascii?Q?7rkC6U1CQzWMDDaHE8S2pPKXTOyOXqW2cLHjuX7jRa1jDZKmVGkSjkFaq8Ct?=
 =?us-ascii?Q?V7V3OMGSm6fDKIm8MnX6h3WR8n6Ji+evepcCb1hYNJIzw4xCFUdxdFiANs5F?=
 =?us-ascii?Q?JpiCBz4SNTRj0Z+19fZN+iXF5nJPSYcdXDGRyfWqjPg0sdxEA/vgvGeO2YXG?=
 =?us-ascii?Q?wiiMSYmsVZdDKTadzifKxNzgmRUIgLOLyJqosSfXYx9U6HxnPnCJHn8eHn8c?=
 =?us-ascii?Q?+vws7vs0DNkgG48e7ecfNMZKYG5ee7EXWbF5NnY2b/Z+6GSlAqaGYA+ptIpl?=
 =?us-ascii?Q?FKDZovH519KHxQS8wlPS72JKp5+IbEX4gycGFSkTGYkLy6umWHQ/KX+PMGRC?=
 =?us-ascii?Q?0z+epRgp7sMxnhS2rlzVw6coVguuJlk3/oyFJZ3dae3ehk4Zxgs2VvAYHIJ2?=
 =?us-ascii?Q?IwkhvRSVCWWDZhi/MmTklUfxOqCy+is2DjIMyO/bk80KnKhKuoQsB7eywZMK?=
 =?us-ascii?Q?exFSwPwZqiJFBkHSKpywGUp4M75vnWVX0vdpHUXezVEn+t+/3UC5q+KkZEgN?=
 =?us-ascii?Q?lO9K4Q5rZvkLnSBB3A8qaWvplraKoltRf7OTzOrVYDwOlHeqCLQCUDfGAa+0?=
 =?us-ascii?Q?c5eEe0l7B+vgmgmtGVzIHvTUP0zi7LSC4/NisNFULftxP+kvwEwNlFgycGst?=
 =?us-ascii?Q?NK6TD/JANstQT4OUNj9jHslse/c3UjNne/XaQ8Xn7mOs1VUZXu+B4+tc+qQZ?=
 =?us-ascii?Q?qTHqRtpgmP632227REzjzj24DnmIlFtesOMegBugt5vAxbd2uN3IfxBkRuIo?=
 =?us-ascii?Q?6dTkCp93HQSkLPcWBgI700RogyLjzhL3rwf0BAWnYz/jYVrhEYpm8XDLdf6X?=
 =?us-ascii?Q?KiJax8RsnrRyiWV/wKK8X1x5Lo+IrBi0xWZWdU3kxfXzhfLPat5hCS26DI5U?=
 =?us-ascii?Q?rZA9qL9FFSx2Zyqk2Mv//7T1PUnUAHj13OOQ4InRoYVeCDlhJnfdlhVwAD9A?=
 =?us-ascii?Q?oWsdmBYiW4Vp5g3kzQA/KWlji3Hvlw82bBXWrNd+7f8aGydcbjmNDROOWI8W?=
 =?us-ascii?Q?6dl4J7kS/9n5nHoP1+faKFAGk9f048eTe3ilvYsymHtvP/q5oxMO1gsyqXg4?=
 =?us-ascii?Q?PL8eTjS0FHFu+9dko1lZ/kQyJYuWfhBtPOqvF/mL/GridncwWTtS9wbdPUIh?=
 =?us-ascii?Q?RoYMALF1Y00IBOb8+yEFyFhkeXYUr8+2zu36XA3wwk+gIJkUJs/vUPrE1lyn?=
 =?us-ascii?Q?vH7EKs5WeURP6HLOjVI3L+B+OvfqT8Uw2BM2A+s+ZWKE/3xfgcIDYoqhLkC5?=
 =?us-ascii?Q?AgnpGU+MJOWTBUAVHMYcvrYtYZB5Cd1Edjv8CJcyysTCgtGObVcHmrbXfwZg?=
 =?us-ascii?Q?HvnL2Ho717DnWcH7I8Hn0zrGO8XD3MtYIoYp2BnsP5LvUKI8Uf1gaDL5FFwW?=
 =?us-ascii?Q?NSbzCDujOSUOIEKgvgwbdHnabSvodgUgVhYf6ZML6feiINdpTCWdHuB30bM3?=
 =?us-ascii?Q?pP4xRBYw1fnhHBRGxrupxG81/0rSG6oJqdgizJ2AYaZWANLNfAVLxo3+Kqgx?=
 =?us-ascii?Q?E5M4VFk07SOqhFxGFxozA44JP6qiwCxWeRzflWHBXNlrGX0cQ7xbr7Y40ahb?=
 =?us-ascii?Q?IA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	UQ7RtmfFxU1K5FV6iYL6XGB48eQKa8Z7+TNUbhp+vADm8Lm0R2vs9gK1iQQIpn7rUnjVGlTION7Tgj5Sl/HWI10OLalWZTYRJgFAzWDiR7j6vl+P4RW5CusrIrZZY1EbywxRnI6pHnWfsIEhoW6YmhNxq01a2oSIU1yZn8zyfswAunuG9U6cLrwWlCVWl75JtxHKPdKiVFwRy/ZR0G5YwPKItGwplb5cut9I/Ejv3XKTkZal6eIScivOLf43eDmVmkWrWLZwPSWye/KGY2s6D6Oj1JTFay18Rt/tu3GbHhue88iqmfvcmxTHtPOdxvjbl2AAHCyJiXz9jofzUDG+Bg67KaLdoRurd7yN5nyJDRQcpCrl37d/RY+ADDILUYcIHUuoF4gQ6cdf/awgDv7RtGH9Y9n5XCAUM8Lc40ZtF5Rk5bC7YbGqfZP8RIHZ6WcMpmRnfRMrzNBeHYXvGGZlUtGUPGBalopVzJB1wM3eZvkJb2OJYuW/qeJ56+RZD6hzpr5rAyINtYBP/j/zxRu4vgnxjay6Yr0EcJFBkApwBIJVPgbOwnxZUaFvlHNY32uL/vTxOFprcsJPeQSSvxVW6DP+RJGOZuLAkJBvRNZ6k6o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93ad941f-4927-4b33-f590-08dd96e56aae
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2025 14:57:03.8898
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tasDfxYEXSVqUqiMRBpWIi4FuJ1bU+eu62wc4dfZVEe413eMuZvt14IHa5kXaUx8eK1RaVSorlzZudEXw83Ynz2PBnSX8SDNl24Rbkwpw3Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4585
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-19_06,2025-05-16_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 adultscore=0 spamscore=0 bulkscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505070000 definitions=main-2505190138
X-Authority-Analysis: v=2.4 cv=UKndHDfy c=1 sm=1 tr=0 ts=682b46c3 b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=yPCof4ZbAAAA:8 a=TAZUD9gdAAAA:8 a=VnNF1IyMAAAA:8 a=vzhER2c_AAAA:8 a=20KFwNOVAAAA:8 a=e7gHu1jynlkptK2ULBEA:9 a=f1lSKsbWiCfrRWj5-Iac:22 a=0YTRHmU2iG2pZC6F1fw2:22
 cc=ntf awl=host:13186
X-Proofpoint-GUID: Tzd9iamN7LVt_CwvSENLc3qHqC8TS03f
X-Proofpoint-ORIG-GUID: Tzd9iamN7LVt_CwvSENLc3qHqC8TS03f
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE5MDEzOSBTYWx0ZWRfX+iM8xQ8+gDSI bgIgBBMDJteTFiwb9LL1MWzkVPOKSbyFlfpE5U2XJFO2QMcDNN55n4jMp5x4TK/9pc6HuPz7vVk an2DNOmFhk3CAs8nTXXnhzaILaDmLzhD1+gMsQf4Px7YGOjFFyfBkX3Ul6WzYFYxCVEsKG7aMh0
 TpoGMYGdYQQCQw+eDEkshsrgNZDxhIdNogueZc4vuhJDciaNLbjofiQumS3j7BVbYBiY/ihB/ez RmDDyiVhPT8iZ4eQkCduXETuwMf9VCuN3xTWHyY3Dr6s8Xt/HYNUGzBuoNySC5PKHmrljUJFWkF xFGTSnLy4FNQ2mf1kn2zoRCh7HEnqDK36EDJdBU3OdT8kd2daweUFd0tvylBjLjkYbAdNqFkUrk
 LnTK5o2AQBSPFnvIEsGtUrAJNOZ37QWX7nKizsrEAyu32OUE7awtUxHy2/UwTEdm0rFKGp/H

The enum type prot_type declared in arch/s390/kvm/gaccess.c declares an
unfortunate identifier within it - PROT_NONE.

This clashes with the protection bit define from the uapi for mmap()
declared in include/uapi/asm-generic/mman-common.h, which is indeed what
those casually reading this code would assume this to refer to.

This means that any changes which subsequently alter headers in any way
which results in the uapi header being imported here will cause build
errors.

Resolve the issue by renaming PROT_NONE to PROT_TYPE_DUMMY.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Suggested-by: Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>
Fixes: b3cefd6bf16e ("KVM: s390: Pass initialized arg even if unused")
Cc: stable@vger.kernel.org
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202505140943.IgHDa9s7-lkp@intel.com/
Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Acked-by: Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>
Acked-by: Yang Shi <yang@os.amperecomputing.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Acked-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
Separated out from [0] as problem found in other patch in series.

[0]: https://lore.kernel.org/all/cover.1747338438.git.lorenzo.stoakes@oracle.com/

 arch/s390/kvm/gaccess.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
index f6fded15633a..4e5654ad1604 100644
--- a/arch/s390/kvm/gaccess.c
+++ b/arch/s390/kvm/gaccess.c
@@ -318,7 +318,7 @@ enum prot_type {
 	PROT_TYPE_DAT  = 3,
 	PROT_TYPE_IEP  = 4,
 	/* Dummy value for passing an initialized value when code != PGM_PROTECTION */
-	PROT_NONE,
+	PROT_TYPE_DUMMY,
 };

 static int trans_exc_ending(struct kvm_vcpu *vcpu, int code, unsigned long gva, u8 ar,
@@ -334,7 +334,7 @@ static int trans_exc_ending(struct kvm_vcpu *vcpu, int code, unsigned long gva,
 	switch (code) {
 	case PGM_PROTECTION:
 		switch (prot) {
-		case PROT_NONE:
+		case PROT_TYPE_DUMMY:
 			/* We should never get here, acts like termination */
 			WARN_ON_ONCE(1);
 			break;
@@ -804,7 +804,7 @@ static int guest_range_to_gpas(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
 			gpa = kvm_s390_real_to_abs(vcpu, ga);
 			if (!kvm_is_gpa_in_memslot(vcpu->kvm, gpa)) {
 				rc = PGM_ADDRESSING;
-				prot = PROT_NONE;
+				prot = PROT_TYPE_DUMMY;
 			}
 		}
 		if (rc)
@@ -962,7 +962,7 @@ int access_guest_with_key(struct kvm_vcpu *vcpu, unsigned long ga, u8 ar,
 		if (rc == PGM_PROTECTION)
 			prot = PROT_TYPE_KEYC;
 		else
-			prot = PROT_NONE;
+			prot = PROT_TYPE_DUMMY;
 		rc = trans_exc_ending(vcpu, rc, ga, ar, mode, prot, terminate);
 	}
 out_unlock:
--
2.49.0

