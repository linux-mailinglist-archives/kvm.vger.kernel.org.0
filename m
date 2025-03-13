Return-Path: <kvm+bounces-40875-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AC6FA5EB1E
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 06:23:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 40F6F17253E
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 05:23:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D94A1F9A90;
	Thu, 13 Mar 2025 05:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hWz1gw1t";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="RHnIMx7j"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F6411D5CDE
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 05:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741843377; cv=fail; b=keneFb1k2F/xDAhngCsO5K6aFI+3MfG2hLag2Xp/1qoz7DHD/ExKuEtqNQMN3BzOvwxL4P4vC6nUOn88CjsLdGXQ3F0Dnf5rmZ8ELRXNTqOwlD1ZUpCqs0JZFP+DU3uUgDvcA4WGswAh6HhrFDN5oLA6amMCMtAsDa6RP543D+M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741843377; c=relaxed/simple;
	bh=JTTtVJD9nyeuq6zFIGnb8UTGh/0iiyozSFnZeLqE+WU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VV4YitCERrKhShBjYjGZbn4LUUPO/MRD2ZpF3Ee+RW5DlOilXPlWygoNb9VP8S8EMgKoaMiaClcVRY8xvCopQWnJgxILfsk45POaA9FdlHCa6YtuPswVutFlKEjdgdYiOXuftRkpKyM6c8NcdoYFUnrMXoMpl0XpDqjP9wT0uUY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=hWz1gw1t; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=RHnIMx7j; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52D3uLGS019112;
	Thu, 13 Mar 2025 05:22:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=nPz/HhlRuxe4zmzACGzvAswpfFIr4Uj/3ncEqzpfcZA=; b=
	hWz1gw1twl3WgRz/yi5V0mu4Gz2Y3bFCtlKWKMIj7Sb59l7D3mxTI2lqa0Ve3Um4
	S40brbKYnNBRkinC/QN3ptL0Vfq1pjV8Nxeb71bHkS5ejYqVaoVscCHwH+vZcutn
	NfZi/sAhVpYkJcQo6LEdsjF7UVEzH+R2YOiOrvgPzUjrCNWG82psh4WM70xXrjph
	Qg8cpj6qXKIBA0YNu6pKepHUuq6sChbzp2sa2BYO19323rN1w1580Dxl3hdyfKAe
	e9t5yPakmav8zr4E0qGFFO1eG4iyTB8bVc1YtVi89a6J8Vz5sg4iG1uCiwoM1ebl
	JT65Uqck7rR9E+nBozqryA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45au6vkes8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Mar 2025 05:22:43 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52D3RH9X012272;
	Thu, 13 Mar 2025 05:22:42 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2048.outbound.protection.outlook.com [104.47.58.48])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45atn272s0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Mar 2025 05:22:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=h4pQNBH53LJYF0gmG/u++VCia4IL/k8XF8t+Px4m/ki1V7fmwgMZjwnuD01etdmxGRuN1WPDfRzC6U0/SsJhVyAv2YmMkVfJaakIy6BQ2abBszA8Bw9FfVwYT0HCuwocGoF66cTceN2FuXw5kDrlocDq14f4WXUtKZAvjicT/gY5MBYWVxbDgqu959bDgl843YkDh2QoA9b1JKRTS4NzzDmhWrorq1eH+5BLh0xTF31ohfxOUAxRdg2dUMTESOPvt2p6k31JQvH9SyJfB6OGmRQhz3RtMN//+zMLG+eLxTi1g2/cQ57PBMr5s45IPDDQGMed5sEyAWDzRo4pVQ9buQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nPz/HhlRuxe4zmzACGzvAswpfFIr4Uj/3ncEqzpfcZA=;
 b=Gu/Y/pNOZ9DPp3rDyxRdimLE3gKX5qBor6yQXns11aoG4HRZ+izV7lZFVGesl9oGfw7ZzhkNYTBeiWnBVSWNwjhP2SAQA9imokhCnbkAGo++sKcN9MJRRN6daf81jW3W1u9+54tWzEDjy9UxIerMXSGt6BcsAlgnGKj7hY4uAc6DaPglBG5Zg8btw3Hbtk1t4322Ci8HIYhbGJJhvDV8Kj6rm3z3wPzhpp9aMiUGMxSWQvapDaco2pxzW+gEdF/hYSKLGstftCZ7Y1SVKbPszFNcMJu0oelefRElErqxDfg6FsFFfXOlngKMi3zl8Hoz/iLB04r7PaifZU/v0CJYHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nPz/HhlRuxe4zmzACGzvAswpfFIr4Uj/3ncEqzpfcZA=;
 b=RHnIMx7ja9GnL1YqoIsoQ5BW7Ys9+7WOVkqXnAtya/AP/DvAimi4YVEej3dPCZZl07iBl6STV3RFBxrVL1FEaMuLJZxo3ZIInBeNqct0OE4+YoadZGSNEAaohXXUap3bhw51cKzqRi3PJQtzgLVnX8zNz9QV8ZUmMBrXho21l6k=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by IA0PR10MB6724.namprd10.prod.outlook.com (2603:10b6:208:43e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.27; Thu, 13 Mar
 2025 05:22:40 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%4]) with mapi id 15.20.8511.026; Thu, 13 Mar 2025
 05:22:40 +0000
From: Mike Christie <michael.christie@oracle.com>
To: chaitanyak@nvidia.com, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
        joao.m.martins@oracle.com, linux-nvme@lists.infradead.org,
        kvm@vger.kernel.org, kwankhede@nvidia.com, alex.williamson@redhat.com,
        mlevitsk@redhat.com
Cc: Mike Christie <michael.christie@oracle.com>
Subject: [PATCH RFC 09/11] nvmet: Add helpers to find and get static controllers
Date: Thu, 13 Mar 2025 00:18:10 -0500
Message-ID: <20250313052222.178524-10-michael.christie@oracle.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250313052222.178524-1-michael.christie@oracle.com>
References: <20250313052222.178524-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR08CA0002.namprd08.prod.outlook.com
 (2603:10b6:610:33::7) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|IA0PR10MB6724:EE_
X-MS-Office365-Filtering-Correlation-Id: 15cad60d-b139-4fc9-fc53-08dd61ef1357
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4n2f8TlX8H3O0SR0L1aoahOppp3qrRUA5+LjAJ4ZaPE6CRMLDswmmotHUpAK?=
 =?us-ascii?Q?FsuPTq+pco9lb/T0RttukPGjmgHluX8Yo2CiWVraEeYyr53pqOa8jpSZJmLV?=
 =?us-ascii?Q?JC+DZEDO6oT0NuMsuAbXvIvWCuQvxqWZ5Hr5PaRSY9N6F02hAkWcz3SWsqjL?=
 =?us-ascii?Q?WVquwX7chfnipwlmBon+tbVZy19025yl+pa65SATc/QQCeW5edlxaWfyYQ/E?=
 =?us-ascii?Q?swEmyYC3Z9dKVN/V0Vr8sCwXFqXkKgZfKleULgadTfpSyFVu1UyQ0SLJHMjx?=
 =?us-ascii?Q?ZR1hSM6arF5AHMGNBN8WYNqL21m2MQYV0gvTqfMia6K6wUrWpGWlAuafUurw?=
 =?us-ascii?Q?brpRH9EQY0b7nDvHpgvAVjmWSPzVCidYaHKNcB5qi7x8E++z9Tm6vEcUtwhl?=
 =?us-ascii?Q?9gmksv7aM1piE6xQoqxi60SD7+qF78PR2yN9oeIBuiJup/6OKa+tZbBjzMqT?=
 =?us-ascii?Q?mneRcJ0GmXKI+R+CVDlBg6SC4JzS2Rw459bH2I2uWtPSmsS6fcO4Nw1w7ERX?=
 =?us-ascii?Q?AsDUZhUSeZQjBgzisU694IukmNve/RIe0rR0WHZg9YursVfARkgBIYeag0M2?=
 =?us-ascii?Q?uWQQVmI2TM0APS0m9ht4hvqBIz9zku1a/oheZPo6+tO3YpdRWt2bjS8YiufV?=
 =?us-ascii?Q?5YS7LdSvyQszu1lMAjR//Or4/Sq23wpnqszV/vCyQik6zBZYn2u+zrfWDw9P?=
 =?us-ascii?Q?QtemJB3Zs41RkuZ/zXmNiLZP8HM6YQ/FDg2fSER85S2RAq8vCjMxJUTs+ge7?=
 =?us-ascii?Q?37h4zlatnCv9FH0AEF9N505fkY5XTlRGLW2N2sqdtp1kOP+llA3yOHWj8Jb5?=
 =?us-ascii?Q?SkJVK/Uiy+H0j8SozTLrXniqplbLfNGyoJXYWy03tnObRGWUscle7YSKdzwt?=
 =?us-ascii?Q?tiqSb8msCY8isEmx6sJMtAFsRzvou68SuBYceu+2j7ENhgb+GYLcL19R6Mn1?=
 =?us-ascii?Q?Z2JLGFXgSLZuoAZ6nOxYbu9vPXrOtG1yW1T+byikV2vxR6HjcOCZZ9CSvI/P?=
 =?us-ascii?Q?uv43oXXnKXc9T/9tIFP/+HLNtctgiyyPJ0lx1v14aQgv0mJ9hub8hTMBtDrw?=
 =?us-ascii?Q?eIkiiQumrj4VyMDkpN7zyXzgbHRD+Q1ny2B7mepSwQzRCXskNZj7NJOqh9bj?=
 =?us-ascii?Q?HOhkMVSYXPs6oucAdb+ClPKWjQum5ZtSSxJDMyQEHuYSqTiYHdfwbZsQXHlr?=
 =?us-ascii?Q?ehc7O1y5bwSQ4YoGIu8zWPpBwnMrlDHxh+bjkuJTXB5lY3fnjyRQ54sVMwmQ?=
 =?us-ascii?Q?5SlzGfv1LSkrsG7McrR4+HDbj3C6ve1YELLZJ6ZxHTzJaGgcwSEB8J3nFH45?=
 =?us-ascii?Q?BYDrnQauZpgbNBgy4u2QSc6rkJabLFzYCOD2zOWth+u9flRhBpfDznd7UKro?=
 =?us-ascii?Q?s4VDgruC5ndnJdJOcGAJ7B9koEFtfZR56rvlJR1dmYfRhd4kBsKUNSYU+40d?=
 =?us-ascii?Q?Jn/76mPjgFc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ytNU+6tu7sAwSKseAVyCuQk+6MffIO776kcOIkzzmxQy1+CwHlTvUMimhQ4L?=
 =?us-ascii?Q?VbTLjjcUQOFOnDdeOQQgPq+UBXiAUYbu4UmljnL0UWgJ/xyQTTHDJ35DsMgR?=
 =?us-ascii?Q?LL+ZlxS6nm7PXPkPt5T0zzbaRWssQV0irGrjMU+zAKY8+1QeeSFO9flkkEKG?=
 =?us-ascii?Q?T5JKfE5w8okCX1Rx44a1WbWzKs8ZQ5y7MN26d/SX1LOtNzBq4HmQ8sMMVE76?=
 =?us-ascii?Q?dX4bwYL5E0dFLiUnza2RwB+/yhkkZYvLNCcdRDj/Z+UKne7UJQHtUCzhFkUv?=
 =?us-ascii?Q?Uv7cw5O3/ziTZtD/pZUq+AXFSIR/EV1aLgSd0d0ckobrOPk2klU5z8hiRUCV?=
 =?us-ascii?Q?f6b71dYA4vWcigZNuE/1cvfTxwmB12U0jXb2F1unwMe0I+EoxfIMm8b9nBv9?=
 =?us-ascii?Q?xtEMxAnM/emc1oB0klDgG9JXGJiG9WEj+o1lZtxYY9qcBpMu9zMSjg+051CW?=
 =?us-ascii?Q?4nEAa6yzH9JEiStSgHlNKMj+i2oL/bFw27TO06u+b2Ay7nVZFsGhgpROf568?=
 =?us-ascii?Q?jjDUBgVqC/j9w+nc03znWcJrqGXbwX0L6lmu6YIrEqZ5h7iZuiV3GDVRTvzJ?=
 =?us-ascii?Q?nq7/PRda+6IErP7aUQc6iO5BkHEYJ4KzgUxASR45yCOtJ73HYTll0SCTqULy?=
 =?us-ascii?Q?UWoWl2QZnbFwE7wkRe33D0cyDaaDFgTJ6/qW307MJk5d4eSd4WbuTumYE3vq?=
 =?us-ascii?Q?8GjJiJlhW7KTPweX8MrxOmNV9xej4N5gOvvBj09A5sDm8AFwveG+YmW7WjXr?=
 =?us-ascii?Q?eYZGo1OVoLsHPUtHF5EZkspenQlzlME9es5GbKiXPJNhlZQVvHg1ZkQJMno7?=
 =?us-ascii?Q?JjZEas4qmMEyZDmcRm8xYZKuKrcykg8QPxM91PcNOue50WthCo0MsFLHInQz?=
 =?us-ascii?Q?h0D/V40K0reUY92YV7S5o9Ll4PI3HoNusFvW06YBEztuM853Ie3KhKHgjMR2?=
 =?us-ascii?Q?gklrSDYtnUNMZLippTjtg3mmChIanaOwB4lG8YfbeMBWTiBzU3Nk4LWt7D9p?=
 =?us-ascii?Q?rvicIQYwFfyJodQTmr0Gi00AkeAV8RmTYBZDidFDOLmRXZ+2twqmBDrrPo54?=
 =?us-ascii?Q?wvwrqvJa5HRktSW130TgJ4sePLtYuVFyzDvryEdL4C+KZHx8AuDMB7CTYnLg?=
 =?us-ascii?Q?YhNPpIHjngv162u61uNhaLIIRFdjP70REBN+BSygxZuD9JpbcJHt71FTVHT6?=
 =?us-ascii?Q?6Ehz7aBofioDeONn9aaid9f/XgBu0r00FfHnQYvurlkSg7Wrx8CFgV3gL39u?=
 =?us-ascii?Q?bohoGyW02lx7vMn1bdu6bmzlY0ex8OdYE/iN33u8r5o2cmzUGWqzX2NxXh6c?=
 =?us-ascii?Q?Ihhql8okDyN3AwXcb7qo62Oc4Gt5Zm6NE4bdfKHnZzqOU3J3I0+0Ig0T4Q0X?=
 =?us-ascii?Q?otLxxDubm9zxOM+QYsxEKoe/X3l2AXg80WufN3iB5yAhomPwZ+v1/2yedznW?=
 =?us-ascii?Q?W7gLqwLqSrQ1UVdhR88ztjKVRgYxqn1rnxvqC6m9sf4zSZnYq+LkzzyDoenT?=
 =?us-ascii?Q?t/qox9rBLlr1XZS2H44yAdLeNY93I/YEDu1GBRJ8KHIl4BpNtzdSmsFag+Ij?=
 =?us-ascii?Q?kUPf+nMQ6Qi4Z+gmSdoqxnL3kNH0JlA5FpJswGp4zV9fK2dwtuKz1IU8mpNt?=
 =?us-ascii?Q?4w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6BWLIyxSQztKK8ylBfkGvl0rFq8YeA6ycxZ3J49cr6zJTtyG6TXrb224hRvx2cfsMIddQrm7Ux4Vhnh1HvpdyhpCBgF1rttrhjyJoSU1rm70TBgXQWH6gTuhorV0DQFOfpF2ZJUqXQHVMZcKo34qnESyFV7k35vby2+V5ifar0rROdMKsoI0bHGKmcG5REQVaErtQQmGf1QOQTMSk/Ke5fAafEICGnhYQntUVr9PnSux/eEawVe6SD7MshfebZ0VD+6Q/+udHa5hEOBQA9FuXSbsDgSh40moP2mKJNBp0kUO6aJUmBd2jkSSH84zQcJOYpXjZPULdrcrnnh1BuKNacNKPtOwaWYLd8upVPI2sdU91Tp+IiKcL0aQnOdB+l2SbrXp+rEDO+D7BkeRfbI+y02toUHONXIxpzaRAgfgjD8t/FYyuAAhMQKQemn2dddpLiSA2egHEd4g2Voblee69wg+cLOS4vCKhL+Fvf7SBjkAgVKRnhwn8g3WWNX90eXZIs6VgF5yvKX4TvbSDQnpUaf/ja/VTwl+OghdttRyTbRMKkZx4D1Ws1ByCriTRTMVYhn8vMWc3i13f6/BnqEwP0yEvC4jj7AxF180rOS31kY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15cad60d-b139-4fc9-fc53-08dd61ef1357
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2025 05:22:40.7496
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D6WYTikeNAjwU9OxjpQ6XNu+/8losvqsvAWth8CiOE6/v6N/K/Ct6s5BnQequPcWmsAr1VI1YC/k28gGPbyi9iHGZnzxkh8G1nbytIOIssI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6724
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-13_02,2025-03-11_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 adultscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2503130040
X-Proofpoint-GUID: xfwW0U03xmuXLiCx01yq1avU3jSKwvfN
X-Proofpoint-ORIG-GUID: xfwW0U03xmuXLiCx01yq1avU3jSKwvfN

The new nvmet_mdev_pci driver lives on the mdev bus and does not have
direct access to the configfs interface. For the
nvmet_fabrics_ops.add_port callout we will add a mdev port. However, the
mdev bus driver design requires the device under that to be added in a
separate step (from the driver->probe callout). For this callout we need
a way to find the controllers under a port, so this patch adds some
helpers to be able to loop over the static controllers created under
a port.

The nvmet-mdev-pci driver can then loop over the controllers under
a port and create a mdev/vfio device for the nvmet controller.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/nvme/target/configfs.c | 10 ++++-
 drivers/nvme/target/core.c     | 71 ++++++++++++++++++++++++++++++++++
 drivers/nvme/target/nvmet.h    |  8 ++++
 3 files changed, 88 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/target/configfs.c b/drivers/nvme/target/configfs.c
index a946a879b9d6..31c484d51a69 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -2069,16 +2069,19 @@ static ssize_t nvmet_ctrl_enable_store(struct config_item *item,
 		ret = -EBUSY;
 		goto out_put_ctrl;
 	}
+	list_add_tail(&ctrl->port_entry, &port->static_ctrls);
 
 	ret = nvmet_enable_port(port);
 	if (ret)
-		goto out_put_ctrl;
+		goto out_del_entry;
 
 	conf->ctrl = ctrl;
 	up_read(&nvmet_config_sem);
 
 	return count;
 
+out_del_entry:
+	list_del(&ctrl->port_entry);
 out_put_ctrl:
 	up_read(&nvmet_config_sem);
 	nvmet_ctrl_put(ctrl);
@@ -2169,6 +2172,10 @@ static void nvmet_ctrl_release(struct config_item *item)
 		mod = conf->args.ops->owner;
 
 	if (conf->ctrl) {
+		down_write(&nvmet_config_sem);
+		list_del(&conf->ctrl->port_entry);
+		up_write(&nvmet_config_sem);
+
 		conf->args.ops->delete_ctrl(conf->ctrl);
 		nvmet_ctrl_put(conf->ctrl);
 	}
@@ -2401,6 +2408,7 @@ static struct config_group *nvmet_ports_make(struct config_group *group,
 
 	INIT_LIST_HEAD(&port->entry);
 	INIT_LIST_HEAD(&port->subsystems);
+	INIT_LIST_HEAD(&port->static_ctrls);
 	INIT_LIST_HEAD(&port->referrals);
 	port->inline_data_size = -1;	/* < 0 == let the transport choose */
 	port->max_queue_size = -1;	/* < 0 == let the transport choose */
diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index 1385368270de..6dab9d0f6b2f 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -1551,6 +1551,76 @@ static void nvmet_fatal_error_handler(struct work_struct *work)
 	ctrl->ops->delete_ctrl(ctrl);
 }
 
+/**
+ * nvmet_find_get_static_ctrl - find a static controller by port and cntlid
+ * @port: port to search under
+ * @trtype: transport type of the controller
+ * @cntlid: controller ID
+ *
+ * Returns: On success this returns a nvmet_ctrl with the refcount increased
+ * by one that the caller must drop.
+ */
+struct nvmet_ctrl *nvmet_find_get_static_ctrl(struct nvmet_port *port,
+					      int trtype, u16 cntlid)
+{
+	struct nvmet_ctrl *ctrl;
+
+	down_read(&nvmet_config_sem);
+
+	list_for_each_entry(ctrl, &port->static_ctrls, port_entry) {
+		if (ctrl->ops->type != trtype)
+			continue;
+
+		if (ctrl->cntlid == cntlid) {
+			if (!kref_get_unless_zero(&ctrl->ref))
+				ctrl = NULL;
+
+			up_read(&nvmet_config_sem);
+			return ctrl;
+		}
+	}
+
+	up_read(&nvmet_config_sem);
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(nvmet_find_get_static_ctrl);
+
+/**
+ * nvmet_for_each_static_ctrl - execute fn over matching static controllers
+ * @port: port that the controller is using.
+ * @trtype: transport type of the controller.
+ * @fn: function to execute on each matching controller.
+ * @priv: driver specific struct passed to fn.
+ *
+ * This must be called with the nvmet_config_sem.
+ *
+ * Returns: passes fn's return value to caller.
+ */
+int nvmet_for_each_static_ctrl(struct nvmet_port *port, int trtype,
+			       nvmet_ctlr_iter_fn *fn, void *priv)
+{
+	struct nvmet_ctrl *ctrl;
+	int ret = 0;
+
+	lockdep_assert_held(&nvmet_config_sem);
+
+	list_for_each_entry(ctrl, &port->static_ctrls, port_entry) {
+		if (ctrl->ops->type != trtype)
+			continue;
+
+		if (!kref_get_unless_zero(&ctrl->ref))
+			continue;
+
+		ret = fn(priv, port, ctrl);
+		nvmet_ctrl_put(ctrl);
+		if (ret)
+			break;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(nvmet_for_each_static_ctrl);
+
 struct nvmet_ctrl *nvmet_alloc_ctrl(struct nvmet_alloc_ctrl_args *args)
 {
 	struct nvmet_subsys *subsys;
@@ -1599,6 +1669,7 @@ struct nvmet_ctrl *nvmet_alloc_ctrl(struct nvmet_alloc_ctrl_args *args)
 
 	INIT_WORK(&ctrl->async_event_work, nvmet_async_event_work);
 	INIT_LIST_HEAD(&ctrl->async_events);
+	INIT_LIST_HEAD(&ctrl->port_entry);
 	INIT_RADIX_TREE(&ctrl->p2p_ns_map, GFP_KERNEL);
 	INIT_WORK(&ctrl->fatal_err_work, nvmet_fatal_error_handler);
 	INIT_DELAYED_WORK(&ctrl->ka_work, nvmet_keep_alive_timer);
diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
index 2b0e624b80e1..a16d1c74e3d9 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -196,6 +196,7 @@ struct nvmet_port {
 	struct config_group		group;
 	struct config_group		subsys_group;
 	struct list_head		subsystems;
+	struct list_head		static_ctrls;
 	struct config_group		referrals_group;
 	struct list_head		referrals;
 	struct list_head		global_entry;
@@ -268,6 +269,7 @@ struct nvmet_ctrl {
 	struct list_head	async_events;
 	struct work_struct	async_event_work;
 
+	struct list_head	port_entry;
 	struct list_head	subsys_entry;
 	struct kref		ref;
 	struct delayed_work	ka_work;
@@ -603,6 +605,12 @@ struct nvmet_alloc_ctrl_args {
 	u16			status;
 };
 
+typedef int (nvmet_ctlr_iter_fn)(void *priv, struct nvmet_port *port,
+				 struct nvmet_ctrl *ctrl);
+int nvmet_for_each_static_ctrl(struct nvmet_port *port, int trtype,
+			       nvmet_ctlr_iter_fn *fn, void *priv);
+struct nvmet_ctrl *nvmet_find_get_static_ctrl(struct nvmet_port *port,
+					      int trtype, u16 cntlid);
 struct nvmet_ctrl *nvmet_alloc_ctrl(struct nvmet_alloc_ctrl_args *args);
 struct nvmet_ctrl *nvmet_ctrl_find_get(const char *subsysnqn,
 				       const char *hostnqn, u16 cntlid,
-- 
2.43.0


