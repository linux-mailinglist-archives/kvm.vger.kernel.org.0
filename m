Return-Path: <kvm+bounces-61021-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 43C95C0647F
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 14:39:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E95531AA1B5A
	for <lists+kvm@lfdr.de>; Fri, 24 Oct 2025 12:39:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 213793191D1;
	Fri, 24 Oct 2025 12:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sfvDRi49";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="WEKRxr2g"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 361E92D249E;
	Fri, 24 Oct 2025 12:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761309566; cv=fail; b=IAqD5hU5lave+oAM8I+ZH2bGid+LJIa3OPrE9YG0Yu30mR/dA+eMhQKjaGdRoMdx940grXA3dW0WkFobstJ5q84MnsL+neyzr+axH9gtI3Drk6ipYmWjlvGPTZ+eVWijypmKoIOuonIJsGX7qj5kt+8IUqY7PTaAupH3m2HS6bs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761309566; c=relaxed/simple;
	bh=ouxPAQotKzjO56oQCeGVfyBnJelRZcr+O86b/7Ayp4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PJQSHscPDqnAx0usnhhG8Xbtm3Gj9ylwX9x5HGwMKWE/bUQEkWdPwv91L8sUlGSY9IJZVyX9DDqsz7l1EfUWBgB+cEFpshgtfFSo+roKexBGtTzccS+BfVJcYzdqI8JiX9o5/GhG8EZfoqMMRjVRZcBlzs7LL7hSpqfTvkt/8jo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=sfvDRi49; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=WEKRxr2g; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59O3NqrV021467;
	Fri, 24 Oct 2025 12:39:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=8nOQTLs+2ukGfbIIvoVDW3LvpfTAHIYLsMdRSZPoc58=; b=
	sfvDRi495YFg20uOXtkM1tiU4AM0GgsY1dQVmz2LKMaXafj2J+7FpRLeFWGpnTZW
	cg9dEs5g6KvSzZoyKYbXkTrL26rC0FSR+9ODKNoQpwedyhSXqP+qVtsAT6reBKC/
	bUdGmH74aTn1NkBxnE5DYgzZJbstJlU9X/MtaIPTYcomXxfgSuwQR0qIwVGtk1+l
	7DT+cUM0gkNMWWxii+P758+g9fd8hGtk/ZnBVdwixSIpTPwf7zN9eWLGY/qvhWQU
	bz1yO3kIyYhrp75UY98t2HDqWN5lLGHFj4/vzIgoaatfFgSti1QTplaeogJvofE6
	IUQIjIRgLDxDEcXKvMCxuw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49xvcycma2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Oct 2025 12:39:20 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59OC4CCJ006327;
	Fri, 24 Oct 2025 12:39:19 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013060.outbound.protection.outlook.com [40.93.201.60])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49xwkabqfc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Oct 2025 12:39:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G8OBc3VjvON8kDT4v2M02ghSQrlPXJcJWe6AGE5DvARolTsLmAXAZmICgKDAdw6WXiwU5cIljHY8eQ9A+qHQQLyQuYJaDYYSCZaulXd9lwJGzfMZvGWoyAxlAkJ9+b++Ri2W/fezu5E+FlUHElleUeR9yiB/FS5aHayczrd1lMZaj3Ux4Zp79KDnc9TA7UTGYuV/LybFsAceEDrTfTVR2uNzB+fAW1e65rt30MZ0JLu3jRW0b7Hys4WJXhuh4DUc3WLUJsg0J+z6P7twv+wWRiYCsJc+iwd5ypNp7syc7NgJ4ZhMjvbBgITquz99HE8cnXRtAulqY6Vk3lsWJdLs2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8nOQTLs+2ukGfbIIvoVDW3LvpfTAHIYLsMdRSZPoc58=;
 b=RpWDWWeUugMDv8B0tAG7tEcRygi5N8yMwt8mmyWD0XtJoMJzXAuRDdRSx+IQXYXM8kmVMHuKZlwhjpB92o19bb9E2qNSaltdO4viShvXnFAX2sJX2O2OOiWJAbDBHOi3rzPubQfbe+CfMrmGLtNpUmOxCHdOoS5fp4nM+775P0Ynn/NelFil0PE6BLwwT+Lja0ZI6/50K++lrPAKg9RpuVnJqnEH9peFpd2sme1eIqg+AZFawj01wWvbfEaRa0Oj+rcnSwDG85NNLCE+Xb+F5cH2hE+do03Vh2ZhTIr7zJ7Gi0tbnOEmkos4TEEemFVkLdVMcDZIa7U1rqpEg6VFug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8nOQTLs+2ukGfbIIvoVDW3LvpfTAHIYLsMdRSZPoc58=;
 b=WEKRxr2gedE5qZ1sj3//hoxo+aF9QLhQNKLts4hT2nkKmB91LEQ71rCDiD+aELZiaLy07REZoD2oCtlO35dEouac9ZtYI0vkSNbxzqSvZhUSJQMYQ10YclC5w9Vd+ICUuzXijr4P4GTpyS4z/nwWmr9m50b4JAgRjehSU/JlTnY=
Received: from DM4PR10MB7392.namprd10.prod.outlook.com (2603:10b6:8:10c::14)
 by BLAPR10MB4916.namprd10.prod.outlook.com (2603:10b6:208:326::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Fri, 24 Oct
 2025 12:39:13 +0000
Received: from DM4PR10MB7392.namprd10.prod.outlook.com
 ([fe80::9c80:bf10:e7e7:e8da]) by DM4PR10MB7392.namprd10.prod.outlook.com
 ([fe80::9c80:bf10:e7e7:e8da%3]) with mapi id 15.20.9253.011; Fri, 24 Oct 2025
 12:39:13 +0000
From: Ramshankar Venkataraman <ramshankar.venkataraman@oracle.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Ramshankar Venkataraman <ramshankar.venkataraman@oracle.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: Re-export kvm_enable_virtualization() and kvm_disable_virtualization() as normal (global) exports rather than only to KVM's vendor modules
Date: Fri, 24 Oct 2025 18:08:38 +0530
Message-ID: <20251024123838.54976-1-ramshankar.venkataraman@oracle.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250919003303.1355064-6-seanjc@google.com>
References: <20250919003303.1355064-6-seanjc@google.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LNXP265CA0093.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:76::33) To DM4PR10MB7392.namprd10.prod.outlook.com
 (2603:10b6:8:10c::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB7392:EE_|BLAPR10MB4916:EE_
X-MS-Office365-Filtering-Correlation-Id: 034a744d-efe2-4fc9-581f-08de12fa5610
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?aoxjgnYc05nsW4Z4uMVEJ1phIVPVp/9y47isoNiwHp40Q6XieW3eeY/zNOzA?=
 =?us-ascii?Q?HYEt9GOZEdIiqdZLFSNCi695WEIsvVfd+ibF0BfrCQ1peMe7wI/7rZXs4WPX?=
 =?us-ascii?Q?dci1S9HbhgEDgd6y0DCUpGLu64GAuoTYIiNyAALlHfEmkBjJ3mJsNw/3PDcN?=
 =?us-ascii?Q?Yk3RYgM+rFCqo/hCWyWiLDPXd9r8oLmI0sUIQJvIWS5svoBpif/TMlX+n5Ev?=
 =?us-ascii?Q?7JO8RY3h0qsQVSBbpIb8Q/VC5qN9U5HVTKKJG52tGoR/27LVa620khpUY1Xy?=
 =?us-ascii?Q?oZcWufv18T9wB52Pr4INF1DrdLgnZsEl6UCFiHq8f/ESonpxS3P6t3Wr7kbj?=
 =?us-ascii?Q?q3W72V1YdHu4laStPvPILx2wiA+pjWg3ZRgT2r+SdhWmJiRy0yBIR4TBSb14?=
 =?us-ascii?Q?QRnxGub+TEd1eofpX3aMb5eFPOC/MTOOCU4Y9XBS/g8rmVxPc2+TYy7Me4/1?=
 =?us-ascii?Q?A5EhVLbs0QIqxUxSZhjLjP4rRZq3bA3BLgmBNcRArf20y9T8OR/aOh6kWX9M?=
 =?us-ascii?Q?pxvSSx7E1VP3o/jK/oa052s+xRnJj3hM/NPR9napaOawQIzX5TlYyqY4qT9l?=
 =?us-ascii?Q?g/RUoX9vjg3rasRA47xgu3r37m76C9jvB55tSdEIrTRbuUIRAtFXg4aBam+R?=
 =?us-ascii?Q?BOy7CEMXskG/VhTAlflg/ciC0op4p9Fe8zDC2VIM1ez9od27ADxlLgr3BxK7?=
 =?us-ascii?Q?pC+F1KctZsJa5K9TLQTFQdVG1IonKBl6nAEP4rfRaxINZ2/cnvI/EJVkFLWY?=
 =?us-ascii?Q?FaGf54OWMxrKVgSSAcXvyCqtZ+fmkG1nsYrsb3S+U6CDJw3o7MzrHUJlTE47?=
 =?us-ascii?Q?r9e9Q7nmTClIntjzHrCYFOf1SfNeDLRrMF5xy1naldHRWICoQGYDa4Y3wk1/?=
 =?us-ascii?Q?4migJwppxXNSsTEm1vappc0xPwxuvffB/KIlaRCYkQvluSKdMJR/ikBoQ0U4?=
 =?us-ascii?Q?FzUcib1ypMzHEOKhuw8bHafB4Hy2DZoInnpz/OSSmhiTF0VoYZctQGT8KbZg?=
 =?us-ascii?Q?UvG9jm+H+aaJSQve/xoUTffgB57HPXrRCWSWye1OirF8rMEfE+kXBeK/szHL?=
 =?us-ascii?Q?FcnwDKzXcW+WzW8GrW4uf8o5SjDG5Cw0VAzOYJcCWdZeL2hcMep+rtcK3XA+?=
 =?us-ascii?Q?4BxvLmd0WhgN6U6sy8kunnPHTxz3aJReKxBP52ap6XFx8KdYMBIw7zKWpH1M?=
 =?us-ascii?Q?QbJHQH0bVc1BwNTRbdQrZGiVTyYYW6Fh+N4mty1Av/Yh2lN0TOZBpdpEcQ+F?=
 =?us-ascii?Q?LHvD+mHUMoqRqcPqEqkRfTP6jPeMQSMYbgWOYNNl6Ph/xbEftntYujpoIjNx?=
 =?us-ascii?Q?z2jSXg7yNKBt1aAM5KpGNAkU+fkElZ2vKWtX6D4jbM8W1BdGPixu8VVeZvhl?=
 =?us-ascii?Q?OhP6fY8KnGVJ73obO/4RbvoQGe43f12CAxvlNd5DQpUsr50+m3MbHax+l5+f?=
 =?us-ascii?Q?qBl7GCiC5RjH4HG3s3ZH9mbnU5fdg7gD?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB7392.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qfL+bFVg0FhaXI2263gPEpHoLOM3Ewvnic6P4qTUtkC8cxSRP0ENS6V0wh0B?=
 =?us-ascii?Q?Dukl3ZbDG4dUVOsVZdna41Mkxt2/WnZc3dF7GubDSgXRz42/+eyECuAqreRn?=
 =?us-ascii?Q?8wp/XEoTj621MQmVtJd8QaXiBr8dDXwPVHpZB6do7gDzGJhvOi25+gLtEjkP?=
 =?us-ascii?Q?2ievECy6Oy8BG2WIzn8recMDBzCsoJQT2b/C9AyCUe3dFUastxvR0mDsYXDE?=
 =?us-ascii?Q?DRYKDOmTuUf3kgfxRgOm/tkt4v27ivxybdyYl4VpMsV0ed98QcdD9Z7+nIcu?=
 =?us-ascii?Q?dUqjpTey4hty1uXuxcb1uJXYTtSTskyV1nufD7TL2TySiLJMQPGJluSzvYaO?=
 =?us-ascii?Q?JS+vZlFhFXYiulsjpbZXJqiK4jK78tusel8LVaQeYsUJUYzH0iG497DG97jU?=
 =?us-ascii?Q?BtV21nMmH5XQ1SOuaA4tuBdWHxlyHy+uMUlxslSZdIbridL+tD5SzPUNYZkl?=
 =?us-ascii?Q?GuED0x/iRZk5SBARA4yKx4XThFuavsenuiilGvEQGZkv3Sf60Cg+VzcEAQrV?=
 =?us-ascii?Q?TCrkkdKidb2p8+zsxaXozCAf3a94RakpemMHIlqt6lNOVOAVKS3DBQAZ5I+x?=
 =?us-ascii?Q?P2H9a7NuXStKLSkhwyVQMkeGz3JpKJ6mD02utuuko40RZNx5xBJNAOZDO7GW?=
 =?us-ascii?Q?V6AP2T6aWO/WPuD1Ha2WNUKdX29p6HEMT+6hRU7YFQJBti+WQ4p7p/eqWD5F?=
 =?us-ascii?Q?6mdl1h5zVpOCM6S4nLwDeTwO53gVjHBXHwqo9fh8Ha8vw01h1D7UK4fHOn6t?=
 =?us-ascii?Q?LQaAgRDwua0LnJVIgVEWkj5S4nBsozQj62EfD96LdGkaXU2zeacTAxZek90i?=
 =?us-ascii?Q?6qllF9xsf5hbs0d1v6d2CHmNWdFaWkbWpY+d+XlKD4Ne/u5cXjf8WYKRXR/k?=
 =?us-ascii?Q?1J8VteURzujumSW8vMcl/u3PBwAbBHMEJj2L8CwkD+4VubDjmxI3e+nI/Eur?=
 =?us-ascii?Q?P/MF+Xb7Yri2KbyBxO6w9ABjV4ZlmQnjSgcpBSCm+ElW5+j490CtSTy0VLPd?=
 =?us-ascii?Q?+BXNEflZXzoF/sq5Sg6C1DQ0zDPwKKNozBCjTAai+BkYAugBy9nDv/Nweqkj?=
 =?us-ascii?Q?89ghv1vRyBeSXFpVelNfQGylESX8/0YDVHxlBeX3gWJPFGfswq/73P5TRO+X?=
 =?us-ascii?Q?Cq/XxLQnlrnkBkG3lNojy1643aOAVSUaVdELvjuJkT60/xojLToYHGiwQHS7?=
 =?us-ascii?Q?mLRJYYHV2rf4JC8r/KrKLfu76hUeGx9BXf5NjZ3KR56e630G6vMyxt3yPoFt?=
 =?us-ascii?Q?boBZIUZkdvYZOUwMAhfCs1TIcjf+vCQHZJ0Oq3MmpmEZ1/YFhVLL6zvelzE1?=
 =?us-ascii?Q?/Z9c3w8uaKprS6T6AZr+W0hsdW6psQ0r6HpS0T95T4GQgtWBHzyPueuD8fi6?=
 =?us-ascii?Q?X7kfQGsXh7dfx3D7NmDmUdA6sMTZw07IQfbNztOafisAyMfQVOcb0hKoG993?=
 =?us-ascii?Q?/KC09cwkY8XpZgH+bXS1E82VcvaTJoMe++D6Qjtp9dBB/N/FSObihfmEp0Qx?=
 =?us-ascii?Q?5HYWauDqdaDkFu8Wy6pSHngTeyQJl3q4gulWJZVOz7sd71uh5wRX3KRse/GP?=
 =?us-ascii?Q?hpy9DjPZhorDlCdE/bJuMrDX/d/wiubWCBiFu1gp5QMxh3W7WEEZUFQnktMK?=
 =?us-ascii?Q?SGsH8f5BIQa2SpKmBH5fUiQ=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rDHEK/zzBEMs+CaB/1GLD1N1Yw6njrwLlYzfKhj6jiIpHfD/aI4wcrgGAIG1oB3pmMDQnLe3t4Tp9BdkekjExVU3BQKNQl7dk+S/S5wQA5D/qogS76StdD21HgA1ZO4zk3xwEpYxXBebKTH286LdzyBF8RYoyt/WtXGt1QhIjdzJrtatoTPlcIMLK2h0BpISPQ2Yq77M5sE2FzTts7WXFgnPBEqeojVAB6h1xovIkYl3j0Iz50Q75wz+YnDdZ2Gmx0qWap8SYHInlArXBv60IOOv+9VD1IGQcIAMlgg84SsLJpZjg/yUvmvNP4ngdNSvqEC1B9kvdKn4DRCEBkU7FamxycLdUMCVyeZnHfprXhfLPa3aLuNPCZuJrp1YUSdgt3KeQiMD8RClLqpMVvINW2y6Iejje4ZBFUgrL2I+DITP65AXrl2AynbBMvE9YbU5tUZ5U9A3RI4pGaF2/BkwqyxfGve/+2QwDbqSobiEd0qRhJ2IG/QU8rQ9TlGP03w9S/EjpPaBnAoku5kkLpvNs4uYfa47ndbmhqLOf9M3f4cRsm4HZ546WjjoIznqltbdnxkSv+7/OPg+YTLhr+7l5AveZxKZbrUlbx5jDCGx7Gs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 034a744d-efe2-4fc9-581f-08de12fa5610
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB7392.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2025 12:39:13.1941
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YtrEm5vvyWQoWzQDOceaC2oyJyp3Xh45cz38x8+KCPor5huXeJdAvmC3cm7qWmztFzvJkGDyOq6451ixNZOU/PU2QzA+pL3mYi5tl+X8miQmxH9DQDV9OaV1bbqkyi3G
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4916
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-24_02,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 mlxscore=0
 phishscore=0 suspectscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510240113
X-Authority-Analysis: v=2.4 cv=GqlPO01C c=1 sm=1 tr=0 ts=68fb7378 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=97ED1Tl7zgXE0dV2yw8A:9 cc=ntf awl=host:12092
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDIyMDA3MyBTYWx0ZWRfX3+AvS2N+W8Ba
 d3gBRdp8Nj8ihqeHCXG2jxnfZhk/KIu6NVAYn41nEsLD8RlVEOMgBLDqivS+DJ6mOSybBdf3Oiv
 1xhewVjLd9NacU6W9L7nW3N5QvCf4XhUt5TcX7HXd0+M6xVkSz1Z7k3+c1auvAKPH6/0wIgT+rf
 tdswKOCxTYWzWB9fE2rwefjpeXf3Yaf6v2IRp4TJcTtbDY74KF4nrd7eNPi36Hc3+tP3Jqcf6i/
 lK4SsIUCnxmOLupE9N1crMS2iW45PSluPJlXwWWS4WZ6QEiByOh1Z+BuUr4WUrC7la4EcwayZvh
 8jhaaOk0qFL+L3ATQIrL+y7PFSjanKiEhWCbwblNNURkahtL3m1WLTg6IzvWZNRqVKklWasybYX
 BAUSGq+BCPXa+SLHHJdN2k7eK5igLkWKNPak5dNUQr8NoSXjczE=
X-Proofpoint-GUID: EIrYrNNyAxqozEEDxIKvGyDUmyucjjdq
X-Proofpoint-ORIG-GUID: EIrYrNNyAxqozEEDxIKvGyDUmyucjjdq

Starting with 6.12.0 (3efc57369a0ce8f76bf0804f7e673982384e4ac9) KVM modules
enabled virtualization in hardware during module init rather than when the
first VM is started. This meant that VirtualBox users had to manually
unload/disable KVM modules in-order to use VirtualBox.

Starting with 6.16.0, kvm_enable_virtualization() and
kvm_disable_virtualization() functions were exported. VirtualBox made use
of these functions so our users did not need to unload/disable KVM kernel
modules in-order to use VirtualBox. This made it possible to run KVM and
VirtualBox side by side.

Starting with 6.18-rc1, commit 20c48920583675e67b3824f147726e0fbda735ce
("KVM: Export KVM-internal symbols for sub-modules only") removed the
global export of these functions effectively disallowing third-party code
from using them. Users of VirtualBox would be back to unloading/disabling
KVM modules themselves.

This patch re-exports these 2 functions as normal (global) exports which
VirtualBox could use. It would greatly simplify life for users, especially
when switching between KVM and VirtualBox.

Signed-off-by: Ramshankar Venkataraman <ramshankar.venkataraman@oracle.com>
---
 virt/kvm/kvm_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index b7a0ae2a7b20..0abfcb4d2e82 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5723,7 +5723,7 @@ int kvm_enable_virtualization(void)
 	--kvm_usage_count;
 	return r;
 }
-EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_enable_virtualization);
+EXPORT_SYMBOL_GPL(kvm_enable_virtualization);
 
 void kvm_disable_virtualization(void)
 {
@@ -5736,7 +5736,7 @@ void kvm_disable_virtualization(void)
 	cpuhp_remove_state(CPUHP_AP_KVM_ONLINE);
 	kvm_arch_disable_virtualization();
 }
-EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_disable_virtualization);
+EXPORT_SYMBOL_GPL(kvm_disable_virtualization);
 
 static int kvm_init_virtualization(void)
 {
-- 
2.51.0


