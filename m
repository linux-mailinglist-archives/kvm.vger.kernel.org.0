Return-Path: <kvm+bounces-22359-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 47B6793D9BA
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 22:24:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6C90A1C21700
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 20:24:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7844A1553A1;
	Fri, 26 Jul 2024 20:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="H4f4255H";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Gy2cTacv"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE741552E0;
	Fri, 26 Jul 2024 20:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722025353; cv=fail; b=PLX64XZuLDMSsz0d0eRPRpdUxPz1reuxq/m5TdjZfRaZqJpNfeWTiFJJeOlGEGCiuterJCUa0WYOlXUI2PBCh5s7l98dwm/aXk6gTpzuJvOOHCw8vFLSTHvmqT8ZqcddnwcPK7uRU6Ay/BU6Ntf1ch8V1JmrphLe3TxCNHUlDLY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722025353; c=relaxed/simple;
	bh=aDcCA9Qa7DdQVIrl/V/FInAGrpfDVZvltSoMhbiT9D0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IxoE4xu0guwbZp2/3U1wtSIZwbZHIgNpcYHFVFuAG48Da46Q1d069s7JnIRi2LIlrb/RO1HH8MSJHa6oM+M0V9EX4EbFWyLT8/qgzZiEP2hcXjZ+L9BARfbZ7Bcm4bsxtili1ENfbE/eF3NKGO4NY5hkGF9LDp1iPqaqIhmk3/o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=H4f4255H; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Gy2cTacv; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46QI5Ws7013755;
	Fri, 26 Jul 2024 20:22:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=RNan28hZrueRUqN0lQfwdbjRDfPEGYlHsBOvYRqz08U=; b=
	H4f4255HhHS+2cryxkTkzWhFXLbzQlkC8iI6A/yNfRsGI7aBW6KhZJlP9ZSqlYk6
	RA0l4RIyVUObyUa84Gt7k0ICHhY2xlfogH/4869iG8knLfY70LZUYnQ60saqk7GM
	qAzcHVQJlB1WsWRjRzt3qK+A6WgPzdstZj+gbC3+Q5bhyV+GOvhEqLQs7mFjGsFq
	XBHMdZR+hg2UCTB8J/ZuOTOVDs8KzXAm468yIF07lanBETYHmZsn6LrJDPIeGXdU
	zVx0gwvZ1Iq7bwodUWm6ZbsxAKm5+zoxUf9LHLZCHxQwLPtOui6igDo7CxjWwdPR
	AXcrE2gd1B6wQ/LOaBh/2A==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40k7yuvj6t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 26 Jul 2024 20:22:02 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46QIZnkZ013528;
	Fri, 26 Jul 2024 20:22:02 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 40h2a64dcq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 26 Jul 2024 20:22:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oFV1FiTSmeRZm+axLo4G94clt6T++hmsWIQwzc4KabZtRCC8HNWw4Jm0hZdXAL9LDfqFph8txv2IOl+psesc92BOnXXRC8h3XkcFTqRlPtwDX+HxNPhnxuo/X8qnTH/n47no4NR+24x1J2K9123/J9LM/Tv4jL2GDxROQSJwL0j3HnhDgw5EclxBzOkn+a2MgyvEdfT4RYNBEoIo+cQ+GasGImwaoaUQWqMmpqGqDm7PGfUMd8fiTtdpNAkxY32hSNF9WLwygLtXHtNumy2svFQvmbPL5O71pUqlOIKfncRdzxSmkvk29KA73C2iVrN3LzweYRkd6Wj3AKvxjuGdtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RNan28hZrueRUqN0lQfwdbjRDfPEGYlHsBOvYRqz08U=;
 b=Jw57y2zeC12jszBGwaxEjasr7LkRDfn0HwaJR0tsGzZGfY61QAjUQ0H0QKWlLnz0sKbGuhgjnv+b58tbVtEWrkxYY7HVGOA5UAi0jAZY75SI9oQHXxf57RAqfsjvD8IWzuPQ0WRhPhlG+eAS3K+Y/4zKZGAHjoJIlgIS8htPlyZ+3b3yO6m4tKnQui8G1eNHL0GtcrlEoxolvbqhrXzIQpdEL8ClyfeYP8/P8Ih6stTa59zqGFtJYBC+ZnCvt9r9G/pCdhBNVbL4yp1WMlpJI8SlkLBerPsAdS2gG8uP8p+3R3Xx+l9/00NrEMBb3qKg5dLW4XWiG4Bq2vEtg4x0Gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RNan28hZrueRUqN0lQfwdbjRDfPEGYlHsBOvYRqz08U=;
 b=Gy2cTacvT/oS/tMQtnC+zQgpX90bN+fllpVc81lqV77HvcVPUELoyflXkNCVjAMbqbMtJPL6M/4lPOwkd6OcTdiqBz+b0x/JMNp/VZxGURgye9YgDrpaDWAnWOl/X75/h5KWsTdNzQzQdEQD8qr2gquW6fxCR1ZR63gpgpOmtXw=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by IA1PR10MB7485.namprd10.prod.outlook.com (2603:10b6:208:451::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.20; Fri, 26 Jul
 2024 20:21:59 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e%4]) with mapi id 15.20.7784.020; Fri, 26 Jul 2024
 20:21:59 +0000
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
Subject: [PATCH v6 10/10] cpuidle/poll_state: limit POLL_IDLE_RELAX_COUNT on arm64
Date: Fri, 26 Jul 2024 13:21:34 -0700
Message-Id: <20240726202134.627514-8-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240726202134.627514-1-ankur.a.arora@oracle.com>
References: <20240726201332.626395-1-ankur.a.arora@oracle.com>
 <20240726202134.627514-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4P223CA0020.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:303:80::25) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|IA1PR10MB7485:EE_
X-MS-Office365-Filtering-Correlation-Id: 4cb70980-cab4-4aac-00a0-08dcadb09a40
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CNc8g+aPhAhfjJ8HGg865vkx/Q9L1tqTJPhlNDj8JGufLzZX2LZb75MbtV17?=
 =?us-ascii?Q?3uynIqW2w1AzSO2O0pYne7BXbNTXPt1i2WeFuNj6Ax9S+Kqr3fLc/KXaTcpS?=
 =?us-ascii?Q?1wq+UYmk57W/c3JTh1xEL/AViHb0J1ooTFfvb8UMyDb2PHFKW27lszChUgJt?=
 =?us-ascii?Q?0a7Cf/MCqR9kE0EwnqiGdWA67ulK639PmincbZh1wQXaPJoq8enMHDRUqVYJ?=
 =?us-ascii?Q?YvLePCpLSlttLZVR9QqXmbd4PGKxDu4oOXL4RT0mZmW/YmDueZn7SH/l/gPl?=
 =?us-ascii?Q?rb2YTgY26aXyRI2VIPDe0ndzVj4r+ZeOrwOHmf4RN4AyfHkViPdVk3Yd2RTd?=
 =?us-ascii?Q?u+/LHe4n/a8JAX0CdfXT/3V33qT5JPkgeiXWiHU/7HjqDSXgE4pdxGwr1PAX?=
 =?us-ascii?Q?68zYmaJHoTkwFkvh44066DKNGbf/RGv0UgpInr/P7WUXqcniSqyloYtli1jP?=
 =?us-ascii?Q?eHXEckvwqPjFqhajzKCxMfThajJ8z+UrS+f2HMquC9PaEIvcnGCqN46aqY5F?=
 =?us-ascii?Q?UNb0HdxwwU9p7Lzz12IrMnQyH6w7BU78EsnKxUfWvTa9vED1uoh0lgtVqkNJ?=
 =?us-ascii?Q?4rvEryDG4IJmP5Wz6gi2xzAm0gJdZNFLY0z8UxgbtJ57p/ov2mPTCROwo7Yb?=
 =?us-ascii?Q?2spbRF189GYJjf7a6dEB4bOp5QIyT11voQij+D+xHM364KI4fzHDkI/3Xzyf?=
 =?us-ascii?Q?RyiBZ+IHj4NLOOhoVJF7UnMy+r90Q6oXNTq6VVmRoWB2yc1TxexAtK4O5fp0?=
 =?us-ascii?Q?dUjkGRZGzgzfHsi4u5rVbm9EUyjr1MXuheSRfkPBCGB4EjFlOS8pHauUi+7z?=
 =?us-ascii?Q?LpkltkO5GVVjsu+hPaD9ne6ugRl+ZlfLGWexq/GFCT7jhara8FoHEaxZ6uoR?=
 =?us-ascii?Q?547d3SIr7+B9oKxecp2h+DFAq7AWleKwHoWuXbw5sKtbEoEN+n0R0f1p+e/x?=
 =?us-ascii?Q?f95LSklCE3BtItEwsY1sPuDWlPsaFaRgzE9js7CJ7zo1/YgxVQUhaqPyerRv?=
 =?us-ascii?Q?dJbkECXALUKfNeZJwdaLbI6lYqxxPOo6vN04PxcgSCGdyzPNRYwKyVQwKnM/?=
 =?us-ascii?Q?YfTUwF/0MGLaLMUibllUf+ozL/tw+YMz8ugiBTWxHda7sj92HTUPNSlOEyhK?=
 =?us-ascii?Q?+O/+QahbBfmBh4y/hah+c8Abhfq9+4HhdybXPYxd5o+04j9wba7t7W34meKx?=
 =?us-ascii?Q?+Xm1NAuVHzvDFZNPiDTAtCkAtsz7P8pHpi0+5zLQI8YV2GU3c9S5NUZwJvDq?=
 =?us-ascii?Q?f+WlDSlPTuL3Z9CAl3mpbs2G4cjmFobRbBNJyWnHV8gQKm/EKXmqDIaL6YYT?=
 =?us-ascii?Q?V1w7iG3y+RDEFAveshzyNQE83LlUfzDjS6KpqnnElTWr8Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bJPbBKgc2S+bVPNm/vl5+V2NnePXqDdoM2f6cwSzZSOCoIzciJtJ0wans37i?=
 =?us-ascii?Q?g2FxWBCM7OYxcfIrsQkeApjr8hVIHrupf3vfDvkEclRQy/54itabNqTVf1ni?=
 =?us-ascii?Q?7NVpT7U6bfdJR6PcofWKOMYKmsu84lThC+YU34sHTXoUjQkEHKpyvRh76BzR?=
 =?us-ascii?Q?vK+MDW+Yngz2SDUcvV352nSDr3WneH2xPasaWDWxWYRA6geWejC5S+pBRgtt?=
 =?us-ascii?Q?hqJiT2DRjUoFaOSHOqX7tg5bg4dc381+AUTiKbL6vSzZIxIXVPXXiU/87gvv?=
 =?us-ascii?Q?avHpgsAFj+4XFdEru875uCfIV4mRnWrGsMQAa3dkrUeCxV92ng5GhCCENWL9?=
 =?us-ascii?Q?vL74Iwhz5ACkzrRm26r9ao1csNQJzjL/iM7nKo9IWyLfBzu66fasKaJ9BLKl?=
 =?us-ascii?Q?c7ejYSn/r+gCEG7Er+km17qR/AdpilaBVeZWQ0bruooWRImXrnUCvp5p7h3x?=
 =?us-ascii?Q?ucEqGRzcB5V4VYSuVbkOmbMxbEKPa9UAreP6WznBF41EGaoAOIxJx1bnuKpD?=
 =?us-ascii?Q?bA2erFyD7gdWjNL2MhZ+cqF5EIlanLshwVCnfxI6SDmvM2dhxXx1ii54RZaL?=
 =?us-ascii?Q?GLXlRqsiMdz1adr6+Qf7X8NPdNnmhEGd9cSgmK9uQ2pXPQuDa2ndgFWpcvoU?=
 =?us-ascii?Q?0vGdO/tBAnqsitKvRobpRnzRQJQIhQVQwQ11WBfDJJT1fBpxKF+2/F6T9fEH?=
 =?us-ascii?Q?e37aKMsn1TKgicVYZrHpxcbVWsxbOTuEHWxJBVfUbP/l55xSj3wOrA+1JG/0?=
 =?us-ascii?Q?vj3PTfSUH4nTkVwIa+1eFdgq7G6+cbt7ePKXcrKfHBfvdgitfLPQ4hpR9xFC?=
 =?us-ascii?Q?isbQDr2dyIykiYo6wodLAHVyC0xYIja/ThuXt0RaXuYt/Ps9b2flyCXvUsTs?=
 =?us-ascii?Q?i36ewUkCkG7YlUQTxnutZLufzGuPJo3fGe9XhKurolVGx7uRIpr0m6u01+30?=
 =?us-ascii?Q?W9UgAixEWuHuxLNRZM7jrT6JoDuzTojmr8Puy4Gs/k50riaF6zXqbc/J6mFG?=
 =?us-ascii?Q?7P/zqqb4ERY7CTj99s1JvRv7L0hrxmINwQWvPP51C0gy/K3xXzDz+mezWMm7?=
 =?us-ascii?Q?ujlsiTuVA2V7k5gla7Z7AZqHRNT4g8vljVPseju+6PX4ajHQwWt7gVry34w1?=
 =?us-ascii?Q?IK+XsKdpOnA+zqnBAy0H+WsRJDpQLHRUFINBsR4qLHy/vpIgNB8odK2UQM3Z?=
 =?us-ascii?Q?gJSAk9tE7AHHdoKGbj+j+w32RmMVMg3lbhX3jZiRGJo8aEGBH12DVm5qntJ8?=
 =?us-ascii?Q?0JILh55IjiVEXiw8rPEs6Nu/HYpWUI6zDSIrBi1IZJhzJDeeoU7PRMV8UjXP?=
 =?us-ascii?Q?f4ubEEQIbuJQZR3B/PTMmXZ6WSgobhWCF1ZNo+btFunedIiOpCN0pdbB7nE9?=
 =?us-ascii?Q?fflQyhYoNaMYRyz3fYl+yGZzuBSl//ECkTniSmslH3jfAAkKH5s0WG6i+1Qc?=
 =?us-ascii?Q?5BmzJqozm6JEPdtLqhwGR8svgJyxKAuuY0S9VFhd1+LRk07/1aCXi9G2AEG/?=
 =?us-ascii?Q?JT8efy1iytuk4hj7aYgdK6w9Au0xydtNnERkiodQYHHaVP1L0nLOWpRyrqdI?=
 =?us-ascii?Q?gG0SsfqUO2HFJOCHXw46Zn/dkNi/rFCKNygl3mXh+9dZYhufK0AmhAwtK3Cg?=
 =?us-ascii?Q?PQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	5ARD2jKZPdF37zfznpXa/AJjeba6YBi5/41YFbiQs/kL7ivMuvbyhDmvPOY33mO2PJzCWwYLpXMX3X4SnsWAUwpszzB4+TqJQKnlzH3pBizfxYtUjdGZnIEIAMj4NHjYn1ir/9ih7STE+CXUJPhVGVusjlohoVH5cYfUIy5xYxCo8zkXs46DReR2MfFbx1l3at3uHz/YNBrD9NP3xp3+l2nz26k+3FQ9xB0lMbJ55MOdyWF9aNmkk7MHU/Q8gwdjCalkXnS7iWl1ZDrNTyd0w24morxS+XSisIFgQXtY2Li0akvFuL/OoBsP3gdDXE+s7NkDTQ333XZwfSQqKLfH0M9gCuMqEteMuK2u2RtR14ehpeeW7LG678qn4COcmVdT3a2BhLPDD7P6qe70S2u88ad5XsalcWj9ZbaxGlFbs9D6mv9tjMPzxC9Hp6THKh0nxZmGZGfJEb/5QahkfgZK27gBzAdJd6Xg7PzeDk0w9vQCP7vKlf4VFux/w85Zp9z7zHMCdZGlzFBiSJUQ+gX4fR2QvZMNz/X8pu9BhF+uA5gBHIvKSiOT21JD+AGx0EjRO6Z0CZaUawi0CiHtaVAeyD3IO+nTjfqfDSDIgbMcPb0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cb70980-cab4-4aac-00a0-08dcadb09a40
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2024 20:21:59.5409
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: v1jxBKoiGlTYWdlDi3SJ/NIyrCCkZRfq5jxuJCZ3SQTggkZdLSogcGZLqiSeKVIbIasbkydD9r2P2Um4YZ/ne8F7qcNWwCyNtCf+ptvtbM4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7485
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-26_12,2024-07-26_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2407260138
X-Proofpoint-GUID: BrdyzMIRI4n0FY-6kuAmnN4GFVO_HxOw
X-Proofpoint-ORIG-GUID: BrdyzMIRI4n0FY-6kuAmnN4GFVO_HxOw

smp_cond_load_relaxed(), in its generic polling variant, polls on
the loop condition waiting for it to change, eventually exiting the
loop if the time limit has been exceeded.

To limit the frequency of the relatively expensive time check it is
limited to once every POLL_IDLE_RELAX_COUNT iterations.

arm64, however uses an event based mechanism, where instead of
polling, we wait for store to a region.

Limit the POLL_IDLE_RELAX_COUNT to 1 for that case.

Suggested-by: Haris Okanovic <harisokn@amazon.com>
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 drivers/cpuidle/poll_state.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/cpuidle/poll_state.c b/drivers/cpuidle/poll_state.c
index 532e4ed19e0f..b69fe7b67cb4 100644
--- a/drivers/cpuidle/poll_state.c
+++ b/drivers/cpuidle/poll_state.c
@@ -8,7 +8,18 @@
 #include <linux/sched/clock.h>
 #include <linux/sched/idle.h>
 
+#ifdef CONFIG_ARM64
+/*
+ * POLL_IDLE_RELAX_COUNT determines how often we check for timeout
+ * while polling for TIF_NEED_RESCHED in thread_info->flags.
+ *
+ * Set this to a low value since arm64, instead of polling, uses a
+ * event based mechanism.
+ */
+#define POLL_IDLE_RELAX_COUNT	1
+#else
 #define POLL_IDLE_RELAX_COUNT	200
+#endif
 
 static int __cpuidle poll_idle(struct cpuidle_device *dev,
 			       struct cpuidle_driver *drv, int index)
-- 
2.43.5


