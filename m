Return-Path: <kvm+bounces-37068-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 23930A24810
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 10:58:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 76DA23A5520
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 09:58:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2410149C57;
	Sat,  1 Feb 2025 09:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="n6oyEBGT";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="CzvZGd5R"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B1E14F9ED
	for <kvm@vger.kernel.org>; Sat,  1 Feb 2025 09:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738403877; cv=fail; b=XiEJzaHIv+B2jC+p0SgKBcpEiE2AyyhP+O3YHc2ZoFm/3mxEH6oG+M+AsRH/QX0Yi+J04ow+kBLMScV+SySLOeJmlZ6OBbeznDez/tRiwwmUDuuMIUc4EIbuA5sz8Wzr1gDE4R5b0I9dc0qo+mS2f5vdvqycgPFF+or94WvEWCI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738403877; c=relaxed/simple;
	bh=Wa17K96WHsG+UwDL7GtcB408PTs+VpOZQSc9ceuddZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IKPOYoBHE2XmI5kRCH4NNIdbwvDkxMnQXN1zOkfDhsE6R7pTgCKm9DpkbAKA2zCm5pUs80j51T2ikb0L39qcXTyd1QCV/Det+ed9piay3SllZYjOVZ3TycQxD2sqM/yX+YqFo/jjO/75APS4uyFDDK2uE9nJm1vPao2zvH1oaM4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=n6oyEBGT; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=CzvZGd5R; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5117rLps005614;
	Sat, 1 Feb 2025 09:57:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=K+SxdrdX1InTxo5zQE56qa247cTBfeTJ3jhGnfvxBow=; b=
	n6oyEBGTYBDyicnhuIC5ljE04ZbyXK27z9XwBdsBKta47VODCUOknsCOFM0dXq3l
	efon7rf6UONMm2hR2EKzTGRF3fS7eRknl9NNnaYL6cnO6QXzC41TC/Csw2YjXQGt
	WMcgao4N6BuHZREL3NVRTfqOVwYUhQ/LN9LegvAk1QN0yeqYR5VQOouLTgpKovVj
	stcB9AQAw3oTD+n1uXL2itp6Q9z33YDwmkRFXmUmlGYQ/Lvymxxn8HxYAdrVh6do
	6uC/2wpNtJv26SVHTQDvYNo2AlZhYiG/4vzgw4jZkLXHgRqu5xZAyqHHmYX12tFS
	uZbs1870kRG1qBNn0QkfKw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44hfcgr3bg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 01 Feb 2025 09:57:42 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51190DNK033193;
	Sat, 1 Feb 2025 09:57:41 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2049.outbound.protection.outlook.com [104.47.55.49])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44ha2byda9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 01 Feb 2025 09:57:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LBdL+ty3Qanx1nXH17a34CvIwgpq84JJ2xwgE8ilAcLv06116q8GtQbFV+1tfgDh3hLFe7LvSGLqBCfC+t/Cr3Ja3qchv04WiwU+PVO66XEIze1dndZq4RitL7gttxDXa3892/Q9eAMJ5MQdI5W4R8ehegDcbQTgGd6ay7oO0roBF2HHtiSXBwxjfiM+ftdLvEBGby3Bbuj+CPy6abj474VVEZgQZTYlj16VBkDlwUCY0KEjH+Ntx4xHrUiWDQ5VUyFhC+2B2/CDKlg4JUf6942xtM/czR/We+XrCjAfnMU3sIn38led4jimxCiH6dv8BccxKTtZ2RwBmnyLGi671g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K+SxdrdX1InTxo5zQE56qa247cTBfeTJ3jhGnfvxBow=;
 b=yfwPg4mUPpekjSEHvIkCOGc60ZeFZ6c+si0TQjKvgQFqpo0Spx8zV1HRgjwKKLpBhQwjI2Nwm1nfEXAV49QU1dUPZoQUFN0ymxP2bCl3eeFGSJXXnVN9mPwALjfE6LCSqneQ+JV2LEcGYlgnHt0zVy9E/SmRY88Ik5tRHnktV6pESjZyOzqVKq8fA9//x2BseEkHbKPheAQFSfUsJF8AuDpKtdZu4InMUHMah4QVj1DzPmRwDIFx8twoXjJeWbt9IQmvATlvPomuPJ+x2VAq4lsnwgs9dOsvvGrJ+4V/WawE/idD1/AohFvZ5cGIvp6tdBq/NvhcsejW1Q2o8ZzOFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K+SxdrdX1InTxo5zQE56qa247cTBfeTJ3jhGnfvxBow=;
 b=CzvZGd5R75YM48agHSlPxUOdMz4jKrq1WVowTU+TtEEAMJtKLLHrLN8jQEikDb9LZ27HUTNAQPegP0yxz1XWbVu0y0IDS5jEH/Lb3Zj6XbjcjFBKeORMLLvZWom+Fa6yMkLPrgOAsmOZSqu8KYY4GIKCE92l56TNHAY0bt03m48=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by CO1PR10MB4418.namprd10.prod.outlook.com (2603:10b6:303:94::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.22; Sat, 1 Feb
 2025 09:57:38 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%6]) with mapi id 15.20.8398.018; Sat, 1 Feb 2025
 09:57:38 +0000
From: =?UTF-8?q?=E2=80=9CWilliam=20Roche?= <william.roche@oracle.com>
To: david@redhat.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        qemu-arm@nongnu.org
Cc: william.roche@oracle.com, peterx@redhat.com, pbonzini@redhat.com,
        richard.henderson@linaro.org, philmd@linaro.org,
        peter.maydell@linaro.org, mtosatti@redhat.com, imammedo@redhat.com,
        eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
Subject: [PATCH v7 5/6] hostmem: Factor out applying settings
Date: Sat,  1 Feb 2025 09:57:25 +0000
Message-ID: <20250201095726.3768796-6-william.roche@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250201095726.3768796-1-william.roche@oracle.com>
References: <20250201095726.3768796-1-william.roche@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0143.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::28) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|CO1PR10MB4418:EE_
X-MS-Office365-Filtering-Correlation-Id: 951bb5cf-5014-454e-9529-08dd42a6dc5a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?GCR/zVo6U2O2XZQB648dEOU4PG5w4mHw0Ve+v4d1hxdj+lGPH2CE1a5rtCVJ?=
 =?us-ascii?Q?mvcSkz6xYQSzpwsW5OqLk/hm40QquRTwImjY+T2Fqn88mPtBLKHqUIngiBoq?=
 =?us-ascii?Q?3tyc+wadg4CyfYEcNEWZCiCdcbLBr6sUVx9liHRvYTVjOXrpt15byssOZjLq?=
 =?us-ascii?Q?Pziy96Ib2lsCYY+wwtI7lzL2YaECOiuf5t3wjJ4x5kyfu1ELGJHk5hHj2YC5?=
 =?us-ascii?Q?38Ih+Yat6FVjR4xN2RpI9utZDJ77lUjaGv/YQU78MI+JbA7D7kcXYD2JxML3?=
 =?us-ascii?Q?H0pOoeAf67Vu8M+fe0gSSuJa+hdtk/SaG8p5FFoG5EvLEYcr2YOvFU1Q56IE?=
 =?us-ascii?Q?HStfAOknY1BGmW2KLNwy/1r3W4ZbpzJKFfRQB3ivzIe1qgwsoVX2dwwKq56W?=
 =?us-ascii?Q?2xJ3J2mmPxcebn45ZFWww9OlgGwYoLIbhSj5l1WqTUNn7aPYAOb6hCO0Ibd4?=
 =?us-ascii?Q?lSgGlu923E3OToHeMCSo9nuNS1gLdWE0Fz+W/CRtRbZf8Jsh52czQrV6x8i/?=
 =?us-ascii?Q?5/llAwzeAwpKiSykSOC7OR2yS02JLP26ZcThHOZ6fkPiN5/yZshYbGhvXxLU?=
 =?us-ascii?Q?uOc0lFOAMVvdERcp1YeFEOvqF1ig9/QU3FTECU0jMSZc+L5edJZ8mJyDHHPJ?=
 =?us-ascii?Q?ephxQ4vPqwxusURFeKA5zmK/p+oVXpR+pNjVkecnCbX5UFzAd1Y/C89DAIEx?=
 =?us-ascii?Q?A5sVdJos+mB2ifpe4baP0Sac17f/9JRGbsvnf0evfd3b35Y167owOBzyF4hy?=
 =?us-ascii?Q?QuYSulZ4XOJv8EE2cyD/NEgBHPuqNydnj1dTlDe95GuXUYoT/cgvswa/RchJ?=
 =?us-ascii?Q?3hflE8kSmL2jWGDszo7HKNacVj4Fx6dMovvUUbRv/lrNFqgv61gKOWnY6hFl?=
 =?us-ascii?Q?DR/nWlx/MtUTwQ0A5JkMGzvZOUHXbgapQLaSzeI0YAzCPTWTcyCfs2l7zLv5?=
 =?us-ascii?Q?JTKaEmQv2EVI1cfus0MFDjCYi+fdq2fAATv7jOyNY5FmPpn6XpkYTcigj/vw?=
 =?us-ascii?Q?ShikLPzo/VwbsdW79jc6bRQhgAHYglLOsGoCrVk6mTqg9UI+T1+SIJmjnf/2?=
 =?us-ascii?Q?Vfyml1YZyUujfQOqyDmIru7fYPrYHoV0TAvUx4H1q8kaWU4A0E+CjGE0Zx97?=
 =?us-ascii?Q?tk1V7KEcRH7gWi+LRZAgqQErJNcou6j44Jbq6O7a23/8gs0hp3BIZ5AWJBbq?=
 =?us-ascii?Q?YgzBCn/UJZHpkG+j/z5RTHcjXsANJMUh9r9VbwWAxk5IxzbPa+wQk+b+JHqd?=
 =?us-ascii?Q?QIUY+9uYcDv7jCI0YLx907NNncV/8dNmzHlENTnRkd8faarCbAtOJ6RQYEQj?=
 =?us-ascii?Q?ek2rPR6AmaD16iqQbmK2ivdLW0aJ757WQE1Mo6uicv0qj5IEV+UVld2kOUJX?=
 =?us-ascii?Q?224JRHYTkHBsAhCpjQ/1vdtTeyKt?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Y1dbsvR5/SspwUd5Z7afYDO4nZwH8sLyAxBcKHW7qXZb4lw3Wfm+yC0uHu0v?=
 =?us-ascii?Q?bCemLvZU4mGp7bH2rLgyFH2OW5SkbkXKal9YXRswUVl+7zZuE2kd3Yr7Z3tf?=
 =?us-ascii?Q?fxLqixE5JwCJzVaSREF7AH5MQgAjrFPNjcsUsihsFtTcJq4ceCW684oQgTje?=
 =?us-ascii?Q?YXrpgCUKlfIdyfBAk3QDndx8Zc33npZTef4Cq8j2LcMIk42cvD8w8dZ8o8jb?=
 =?us-ascii?Q?MUobvjvQLSSUF4lcP+b8e6Ppqd1+5Kx3mJOJEhrzy4xObAnx+6GXkBpyGdEb?=
 =?us-ascii?Q?8d/ukb8Qu4j++BfYh34nnCDW+umeGs7QHL5uNXTQKtlshnF6fe8uvLUG9w+c?=
 =?us-ascii?Q?jBUuUdPG8s4DeYRaX/rSwfpECu2ksita50nWLrzIOEP7Zgu3GNj0RDf20qeL?=
 =?us-ascii?Q?jusUgIZztnP0a/ERoISYWSsVATeD0uQXaeAmflFvSmbczSh+vhX5E/HeC54D?=
 =?us-ascii?Q?GlFs5FZAsVaFH2MrLtvdI1K8KSyRjX4r0dsPOedhvg1cL5FBjL6nmRNKhvRc?=
 =?us-ascii?Q?K/ysRlV5RymaL/JpCjMH3MKJBjjTGRGfeqn1JEqzODikLMeCELNei7H1n/md?=
 =?us-ascii?Q?Nv1z9h8oA9l2dqkYewNjUzzgzCsZ+9Bibu2mi8xTpt5sTK/hbq/pzn3ue52C?=
 =?us-ascii?Q?SINcbFTfLkzMk61EG1Zxd1A5FuN764wNtskUZqc/YEEURxJPBP8LRPxtiUQ7?=
 =?us-ascii?Q?VJoy+yuq+GKZnfsy3XZFDmuZOZTEsTIg7AILItjfOdNkLUyJlgENWqbYP/GZ?=
 =?us-ascii?Q?aVLkoTsJQoM0T6WDp/Xg77Ly+Ey07kkTZ+9W3hncp2UUuEY6/ewFQGapHrZ1?=
 =?us-ascii?Q?uevuYvz9CdfA//gHv1RcxDeJ5sWvryzrVui8aKfrqqHIvEcrrG2FHoIwoP4n?=
 =?us-ascii?Q?Y8U3hiLRzoDUx/1ojtl082CjKLOawooDrE0AgzbEiqW3+lPcuttu6vfl06PO?=
 =?us-ascii?Q?+Kz2MwHb9dA+NArs1BMgK88NDpFb3Wff0YH55O8jf+zASCQgKBqYKi8hNKdY?=
 =?us-ascii?Q?KAdKIakrdMOqZdDneeEuu/h/Vo5Hpm6joqjwxZFmSrZAtg5LyikWpeoth7hw?=
 =?us-ascii?Q?IiVj0ectPmE6f6Q/Gcxu0AWSPTicryzAmJmX8QkhnipMRl+ITvQgCfWa7lpB?=
 =?us-ascii?Q?swF7g2lNxCuxicF774x7hrfnM84Xp9Xm1ZCUA2iHY9G5bAxrC3QlIqy8iwTj?=
 =?us-ascii?Q?HV2xwN/MyYVEDJBjy4D3fw4eSZL/1zwS9AleLHrs2H6GiwYwAV8Xa1GwKk6R?=
 =?us-ascii?Q?z3Ebs9ibXsGspTbi8qatpUWZ23zV/nGmbvA7nUN/nj4ejYVOWTPJV2BxfqeR?=
 =?us-ascii?Q?p1DFMyKtC+jDssiLfFAF2b7+YzwTQz39gXZNesVDNk7Nc7y0ciXJzDlKfwdJ?=
 =?us-ascii?Q?HWD52uTTyCDwUr0/8LSw3c90CslG1hrspZlF/XRF/jNwP3zBMfBGUw74XqY7?=
 =?us-ascii?Q?2mhdsaxXcw8ph6XQMT2HqlaP3BILz7fYPu6j5O30mOnzBwguwk5n7NAtW/if?=
 =?us-ascii?Q?pp8qLdglPz5+zGvC1VZn2U/ocqAaBtWrJvRMu/f+Av9IcsrWqJKh+c5kE8P5?=
 =?us-ascii?Q?+JAfNjbsovO9j45ZThqybambPB03FTQVsZP7cUdppXBYxvPVLg8EBaZ1/zeH?=
 =?us-ascii?Q?YA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6TcHTvLQOynasmLrMncyE7f5WXRzvbpgm5rk6TQirpZv5kcp/5SHyG+Cq23hgWLJtkKIJt7uVfkdjIIy/qB16t5XJOV2nU4IF5o0/9Xjk4cEye0hLBT2mxg459jL8bpagJfuO+h1F37pFRMO0MbX9xf1/MkPVbTaorhROQ4n4SQQO6SfoItyVrOMm0GWnbDf0Nnay+Gy71GvuLKBtWkuSKMCBiCkvBImx1gnDXzLbHDYuh4PBM7ZdVGj4Wn9rlpvbk+EFokkrrVUEuPKqVzMqBDeSXdTdEbcXRtf+1qROLWwO5xOksU0PhX+Z29dECuvLPmJHe0ZEglWhoTp7v9Ykzp9kzrYfl3v5PQz2BFVleaULDYt7U6zwNqXLUdRlZnKkvZkCfHXzGCMYdlwfRr+lczWbjEMBX6lXiRVmqy0/PtTYUfG5IvvqwbydDHzNINZDIAAl1bb5l0Eu2z6tCKyzg3tvenmXwZ7m2Z59aQ3rw4RpmzVkRaFKyyeKy9uM8LW9BRb7Ng1d121k1qhp9Rx1cTDIuvjH6/Vh+G/Qg/tP30YKataHzfD6Ne+y/H7sGtgDL/P+dEB00ziBh8VgKYm/AzW+F0M1GvMMd8hJGleR8k=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 951bb5cf-5014-454e-9529-08dd42a6dc5a
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Feb 2025 09:57:38.7217
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +YaKyGFSbjFwFi1u5vDv82CGoBK7J0aFOn/T4Dze8dHx+3Y6ZtKEbutyLfBC6HB/cMyi6Xole5uyc2m/TKOWsL+XClwDBHIeTddkVOg2br8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4418
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-01_04,2025-01-31_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 adultscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2501170000
 definitions=main-2502010085
X-Proofpoint-GUID: KpQdMPWyHg4XzcISaJ2UCK60LzJMtLR5
X-Proofpoint-ORIG-GUID: KpQdMPWyHg4XzcISaJ2UCK60LzJMtLR5

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


