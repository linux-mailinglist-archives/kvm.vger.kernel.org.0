Return-Path: <kvm+bounces-33822-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 26FB59F1F23
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2024 14:47:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 28B2D160E2C
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2024 13:47:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A055619340F;
	Sat, 14 Dec 2024 13:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JykCFxXd";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nr0QE0cM"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C2E17E015
	for <kvm@vger.kernel.org>; Sat, 14 Dec 2024 13:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734184001; cv=fail; b=Iz+ip+UaLESB9e3HdNSd2tJ9gFzpSjqk4YhgFDJ0IRILP5vl3aqdvM6V3KqeFWlQ9iOqUO1e1ecy+l4EeEiWxWoYGoA4fzuxd53Gz03uIDv09tC1kujr2kP0uNpPX+cqNhBfh9OR1XWwiButvBKvwhUJug+hqIWFghJmYrl/UYA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734184001; c=relaxed/simple;
	bh=Urmo2db6dCZgk3OahhnFmGxkxZyUuEYImTt4Z+DByN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=eP1ASBz8So3Xv8N7H6sDa2PMuJn/wgsZJnab58uP+YdOEXptvVf9WVntmFVIng6Yo/xKmp8okk2T9w7/MktNEk5x2ls0OCfKN+3b9r51Q5eMpCfPLRx8YoAKFJgSUemGzbAh8dDG0gMFGe0qt8BUZPXp/28jyM6ULzNySrhxFn8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JykCFxXd; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=nr0QE0cM; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BEBSN0V028037;
	Sat, 14 Dec 2024 13:46:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=XNRyM619BswnILIqXLgMuU/prXvUSII/sdhBcI+9Y4U=; b=
	JykCFxXdhTiDIeCk5gD/YRQUA14zeO+SvVtjIR+OrgFfraw0SG28TG4JU022ECWx
	HCfisjBgzGNcHNkj3Bb5yZuiWddVCoLofrtHZIxiTMuaN48tz9EsFBxf2dPl8Knr
	zo9CaAsQdbMTfgkAZvNunlyrCgguLN0CE2qkHhwYDi5+u5vBnP1it6nobnpVDIsd
	F8bBmDR2ZJyibEGRDuvqhQYyZajMQvFo2tLu/zekOoWHonKF6Pgt8UfiOKYtqKz7
	NaTWxzR5AYItref60yxDXwcCLN6XSkPlYbSSndjYfQATGeX3/97B4R2FS0WyQ17t
	9TaQCZK3hojJi5sqAQVuwQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43h0t28gmu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 14 Dec 2024 13:46:23 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BEAHq7G032785;
	Sat, 14 Dec 2024 13:46:11 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43h0fbu0px-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 14 Dec 2024 13:46:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=C6b13odjys224mT6WVWbJOgIcOzWdYplf/YXPAoq+jWOAFJaLI6V+DjSmhaFEgqueQdet84plI2m15qMVUbks7U8liC1+JMSg/2fIyiPgMiL2DkuxQNvQEZP4j8k+TlwyTMaSJBrdJjbxFIBhUedhxvXSCP/haiGbEtydOMXvK9fAXsuJXxP2frSBFU7ciK2KmlIVGBYmrFqFEsQW9JsgAAJ19uOpvD91ZpLG6euiU7woQLJ/PZ8gir+2ZYMgVlWvRN+P9PV13MNTrMrKHNPU3uWfT9wCY/lGrTC7kTX4Uzb9uwRBiMo9x9mIT+wv5OmPsU8LbTgJsJxHUrLf1lJ9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XNRyM619BswnILIqXLgMuU/prXvUSII/sdhBcI+9Y4U=;
 b=Rm/tlSovJ3OA9TUOOebSeoVKKfPmKQVkQYBqj+VpKVps1w6hiu3VE7NAqwxLagLi2/fsOKJnrKliZFZZY1UbkVTc6KouxuKAtYBxnUN+yUCqpkoS53rQAabYt/fwpcUZrj6Q67sdSXfMM+tNdfDBHjpgd70KjKdcTcRw4PAhcCpuZZ7I2WRamuG8M+IfwuHaixDrhlRqiPbvskexN1OaD2NVLq4s7vxTRhj4V4xzl/wuefrq0tlhVxDAgSGlN7RtbXXPkXLyQdI4A+ML++QX2HJaSUTJHY9XHYHyAMP3poXXVa805gs/WjSD0TdDM2+Rl3qI2KysMHb+BdaE+pVvJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XNRyM619BswnILIqXLgMuU/prXvUSII/sdhBcI+9Y4U=;
 b=nr0QE0cM2xRFOaqb8fOQVrPCRKuL7oskmAmTi5H7nzKwiZyKAzvwaq72dq21VBA6Y5k/s3ghyWmardZ/SS6Ndt7d0H7OMb+6zV2Bd0pilYx6+YoavB1kU+I2jLlGGzHHAlXe50R/IAvJPmDhN8vRTwFchdfOu8KTQMYJvCaMitw=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by SN4PR10MB5624.namprd10.prod.outlook.com (2603:10b6:806:20b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.19; Sat, 14 Dec
 2024 13:46:06 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%4]) with mapi id 15.20.8251.015; Sat, 14 Dec 2024
 13:46:06 +0000
From: =?UTF-8?q?=E2=80=9CWilliam=20Roche?= <william.roche@oracle.com>
To: david@redhat.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        qemu-arm@nongnu.org
Cc: william.roche@oracle.com, peterx@redhat.com, pbonzini@redhat.com,
        richard.henderson@linaro.org, philmd@linaro.org,
        peter.maydell@linaro.org, mtosatti@redhat.com, imammedo@redhat.com,
        eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
Subject: [PATCH v4 4/7] numa: Introduce and use ram_block_notify_remap()
Date: Sat, 14 Dec 2024 13:45:52 +0000
Message-ID: <20241214134555.440097-5-william.roche@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241214134555.440097-1-william.roche@oracle.com>
References: <cf587c8b-3894-4589-bfea-be5db70e81f3@redhat.com>
 <20241214134555.440097-1-william.roche@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR03CA0031.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::44) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|SN4PR10MB5624:EE_
X-MS-Office365-Filtering-Correlation-Id: c085a29b-4b11-48d3-6174-08dd1c45a882
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CNHoNWPKO/t7bRqEHkNB3Qm8tmHnUcqC4wSdw8yRC8sLy98GtWhZBxfEvTq9?=
 =?us-ascii?Q?wHS03yHqfADyO/8UK0p/3nMP+XRQToppUXk8resAM8XE/3/5zmAljCYGjRbg?=
 =?us-ascii?Q?9tFBrEx7yKxZiT+VlAgfOih5UB5rSxB2vNigUid+FmvaAvI5x4NQlENmBVDQ?=
 =?us-ascii?Q?1vLc+XQd5hvCdIRcsJf8isTZglIsVdmDM1BhMHpL2dqWlr5Yk2pKvOfSsNv/?=
 =?us-ascii?Q?SAJoEDMAmCMKer+16RMiOHcOQMJW39YQzU6dDMfA0f4V3eqZqY9/ZbZ+u1E+?=
 =?us-ascii?Q?jmH1ZNg4je2hZe2hVGTTsEfmGeEq/SDUPcmtslhmq3rwTmp/NWcPeszN7KoM?=
 =?us-ascii?Q?dFAT0ZZgmTHBGZCkoc9mB15AaSfpqpaUT3ZGY23XsfO+q+uvypDgioi3tUA6?=
 =?us-ascii?Q?MXRHjfP1GyDgfca2a/EVGlKu2YbBevjRVd3cXmHYCfpkwtOvuJ4LO/RU2Lhi?=
 =?us-ascii?Q?AYVFbStV8c4MS+osQuH2lqqjaeKUAN1DlwUssHoSYra6+vh4Mt7jpL6Jq2VW?=
 =?us-ascii?Q?buEiETcGTU1Ub1ZQSeRqmBdqwv6PR6wbKNX8KTqYvL+MdH2rZIC6HEiG13WR?=
 =?us-ascii?Q?tGMas4+jCMnY6O6QPmkORyqF+tzk99v3CTbYYNHlMqxaWIzWnraXg34L+V1Z?=
 =?us-ascii?Q?psN1lJFIH7JbWij8iGvdrnB7l6t76hUqMpEcz31wek7iTQoLFN/wIz4r0o5A?=
 =?us-ascii?Q?UG+p54NdQL0j4yRiWR1i3/z1yuhf2l+p+8Y8XJvfHxA1jhpbrrUTmKqucpGW?=
 =?us-ascii?Q?b0GU7rbDLF03aRsI08tgkKyavJvDFyIrMUvfwXwJnAGVoE2cbmMaLTmC6fVc?=
 =?us-ascii?Q?7gg4J6Ohvh7AIeuuRCuSgV8P5VV+RabSh3YBuwHCIPcQiVCeU/HmkOj3xHpz?=
 =?us-ascii?Q?/NvoDqBEVC0vXs64r7NTBVKddGhNr9pryof5WCeyAN8FP3DNJ2hrnm70khdT?=
 =?us-ascii?Q?dkXsU4Rtm6lfGb3jcSt1ouLoHPi9cQh7ipswMYZJ+GLpo2dTTtjUMG6ckwbT?=
 =?us-ascii?Q?luu8Ej6/gOsqQM4mR8LcLxIt7/qxh92HKTq0h8f+DXVqKIIA7P1PHZhDkAXv?=
 =?us-ascii?Q?ObQMRaFKm1klTgT2s/k5i8rz26pBqLPerM8GwD68X2s0b7RIeJNukEPR8YoN?=
 =?us-ascii?Q?sGlkVZ/GBPuk7AOLTIxo0BrtNQx/ajhEVIEWOwwIJoPfWJ3Im+SlAyoD1KnQ?=
 =?us-ascii?Q?u+kW5H2/iS0V2WLbWxKdt5ZHvE1yI8LkgjwrBWhChsaXgqoSsocOYe8eJlC0?=
 =?us-ascii?Q?r/60hg8jEP5x3jGqURBHXiVqRRiDafJbMnMt3mo6SCgNacBFPwutbtHiVgYQ?=
 =?us-ascii?Q?xG9F5TywrW5/aTXBnhkmMnj5Bh/8gChaTuRw82sVTdfKYQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?y6exoCvfbF+kuLiH5z6/47j3mSqut/B08IdiBNNL5vuOECHz3gGOqwfiOhNY?=
 =?us-ascii?Q?KhFI+u6VyCIQKm/vbkyLJwlolBv5htSQIOBwUGQI2xlAVhJXL7tUTcBMZBGA?=
 =?us-ascii?Q?4/+elnO97SO8p30NmQlEDYkyJ9Qi2zO6u0RvicjPEUX0TG9Z/DZg21pIwlZQ?=
 =?us-ascii?Q?49d8V45t78RMLaCm42iph/oDZWCFpLf2Dp0zErIY2MirRvrtFaePpohUM7tB?=
 =?us-ascii?Q?QwAcOtwJUY0ol+94KiUJNtnrVGlwHKvFn1AcdtyJfWUKDu6sJLQ4wCRuRbRw?=
 =?us-ascii?Q?5MVdVWWoojzNET3iHGy7gqaT3DA/z8HoJPIqmQUzlT30OL+NY9ZhIu69jt9a?=
 =?us-ascii?Q?SopKR/mWW2ksANyJ43VJGwuVEA4270PxJJtNeZ+cZIyr+my5DCK8Q2iK0eXM?=
 =?us-ascii?Q?/RIYcPYbw52cbO9Kc44sNi4BLUi027bndGyh8h7+k9lyDNlA8hhjQcQh/O4L?=
 =?us-ascii?Q?LGgLZyp1t6EYBYWUNcsEqsxx/my7oiiQxuSFT/V5GQ4eD65otMq+fJdp4FNT?=
 =?us-ascii?Q?aEZLAnNWfNNMDLnJbU2wDv14IEmCtrFIkOHIea6RdPvFwrPSRmWmSk+HgGte?=
 =?us-ascii?Q?E80iWzWv7PFvw0puQNhSnm1xvkID02GzlZndtymd2uTBaEgVZMYFCJSfHgG3?=
 =?us-ascii?Q?Xsg1sle+u0ko7nWtrvY0ragURvSFXdMC3eL11jnxmvM8uFo5XEYpPBjFouJf?=
 =?us-ascii?Q?uZEvmJAhGp7NXndBf0pc4RH4x2CRFnd2K2UYMqFcjdIK4F/JA3lsw33sEXrL?=
 =?us-ascii?Q?PkD1tZTK5TVuSxbEY8t1syWZVPtm0boDLR75v1IWtDUmHrDAMlne7LgO/bfL?=
 =?us-ascii?Q?FsTGe9KbttQxLY+O08Iaqe6j0Ut6/ua+FKnesPZwCSL0a9uDvoooU8QFi3f4?=
 =?us-ascii?Q?FaWSxd4lu4N3ENsYnAiY+FujGU6HGAMKEOXm7RQzglPq9EVaMAuP/JtTAYLu?=
 =?us-ascii?Q?v1j77t5+zEhf5vrtgw9jUPNB7RKRk91aGA/QUVwGfroXU93/y2oU5qMNgBoc?=
 =?us-ascii?Q?FqPEwJcxLqS8HunT2MBREX+7IQmg1W3svyv53nCLDXvgwdGOqOaE/ihOTvSy?=
 =?us-ascii?Q?HWJ5tvNoZlBw/XuxoIYaGJXa+BfAmpC4tWLMWEHX/dLjzEizm7+FlrdJHPUo?=
 =?us-ascii?Q?xqqw2v6CE+58yyIyrazM3xqqJp1Lo0YSbbaRBB5UCWt8JOd4Y/pIOe4wnqoP?=
 =?us-ascii?Q?aGNACQKUNyeI8RUM0nKdja/Dgfcve2hcoyYJ4/OI+jGuct2YXBXP7VHIPfG5?=
 =?us-ascii?Q?TlS+r8uH2OW3FU7i/HQbUJJxFKmdEwnUW5W/O6vyv9dAHaq2sxmT4Hb5iNhF?=
 =?us-ascii?Q?fb85EZbfjU9s1oML5tzvGIsqFn605lupLINlm11aHVSTsefQTfXvATW97vB0?=
 =?us-ascii?Q?4JWe1IPJ/pa5IY5BF02/whb7hm0HoFEEhvlPNR3shfmZgMiUcSWy1QaSp7D+?=
 =?us-ascii?Q?DcSodkTAD+oNvibbUTRBa9vu/s8xVYAwzy1nn3G0qM4WplvMfoNCdw23Q210?=
 =?us-ascii?Q?PIJkwxV2yi7OPysb1IUdR72hATZNIPIkfA7r4ytwnDuBVCVDDm/jNuJ4ffnP?=
 =?us-ascii?Q?zPs5IjhokKwalhkE+wUV6F7ROmNjOd6hI8kYqXY9kbvPIUyo0ZNHieOEZgM3?=
 =?us-ascii?Q?oQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/8dj8BRMip9+k4dGH3Jo8e9OHaNNfP+qJEq675SqA5d3gA6lP5YNaycbqw+/wZcEVbFLUEWPtHFyAk9s1666FGOXurU4KumkET7qFS7AalfbfESwd271DjRSH8ac1zxbMR55nXClLqbDJzoAKD3gCj5IOzX+MDZoWeAxAUHbUC9N4qhej4BpsaS2IyR6GLpFs6m2TaAvckR3zwKeHGzKhrmXyxQmbAULLJA6hFGCqdKtouv7qxlVSb8o+935oQ+ukqw5XnQZU4xSovQR6RcTlUwOARBu38QwqOW/ogFbkNMNueAdbFlDiII0MWfdwFLdZEoJQNd21EXZadelPgRxCm8wZx15484QVAXcAkEL+7DHr+tu7mvvKoH3npT/bQ23zFS2wfowVlFNPfAC1+T3r2vGMCSrvvIE2EOWw/jpWaQfUY8eeQC6rMb3tvFfu7eIN39VIywUTqrMUMBhzGJhU2uhqWMfEQn+zuaR4XApasVIO+blO0sfpRwtMfJ2mjvfpavij1pujGlzVxUyL26v6s0O0wdmrG1TiC8iFjaGr+ZkaQbBtSu/A9Ypni+FNRhOWN/dR4zmr0KhtxdcRXOUErAWChXb3sPjRtOFCE0Pu74=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c085a29b-4b11-48d3-6174-08dd1c45a882
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2024 13:46:06.3514
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SnBOsJMjVXUJsg+VSIHfQzZN9HXZPAM9JHrwkLiuNZr51JgF873HmMfWdYk0GhWxkrwXVqlyrDjJqSGwGdjDMYa/MCE28JNE7539TngZ4bQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5624
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-14_05,2024-12-13_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 suspectscore=0
 adultscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2412140112
X-Proofpoint-ORIG-GUID: h2BHmj0Ll6fq-_DgQgMnpkFftLh7zSSB
X-Proofpoint-GUID: h2BHmj0Ll6fq-_DgQgMnpkFftLh7zSSB

From: David Hildenbrand <david@redhat.com>

Notify registered listeners about the remap at the end of
qemu_ram_remap() so e.g., a memory backend can re-apply its
settings correctly.

Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: William Roche <william.roche@oracle.com>
---
 hw/core/numa.c         | 11 +++++++++++
 include/exec/ramlist.h |  3 +++
 system/physmem.c       |  1 +
 3 files changed, 15 insertions(+)

diff --git a/hw/core/numa.c b/hw/core/numa.c
index 1b5f44baea..4ca67db483 100644
--- a/hw/core/numa.c
+++ b/hw/core/numa.c
@@ -895,3 +895,14 @@ void ram_block_notify_resize(void *host, size_t old_size, size_t new_size)
         }
     }
 }
+
+void ram_block_notify_remap(void *host, size_t offset, size_t size)
+{
+    RAMBlockNotifier *notifier;
+
+    QLIST_FOREACH(notifier, &ram_list.ramblock_notifiers, next) {
+        if (notifier->ram_block_remapped) {
+            notifier->ram_block_remapped(notifier, host, offset, size);
+        }
+    }
+}
diff --git a/include/exec/ramlist.h b/include/exec/ramlist.h
index d9cfe530be..c1dc785a57 100644
--- a/include/exec/ramlist.h
+++ b/include/exec/ramlist.h
@@ -72,6 +72,8 @@ struct RAMBlockNotifier {
                               size_t max_size);
     void (*ram_block_resized)(RAMBlockNotifier *n, void *host, size_t old_size,
                               size_t new_size);
+    void (*ram_block_remapped)(RAMBlockNotifier *n, void *host, size_t offset,
+                               size_t size);
     QLIST_ENTRY(RAMBlockNotifier) next;
 };
 
@@ -80,6 +82,7 @@ void ram_block_notifier_remove(RAMBlockNotifier *n);
 void ram_block_notify_add(void *host, size_t size, size_t max_size);
 void ram_block_notify_remove(void *host, size_t size, size_t max_size);
 void ram_block_notify_resize(void *host, size_t old_size, size_t new_size);
+void ram_block_notify_remap(void *host, size_t offset, size_t size);
 
 GString *ram_block_format(void);
 
diff --git a/system/physmem.c b/system/physmem.c
index b228a692f8..9fc74a5699 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -2244,6 +2244,7 @@ void qemu_ram_remap(ram_addr_t addr)
                 }
                 memory_try_enable_merging(vaddr, page_size);
                 qemu_ram_setup_dump(vaddr, page_size);
+                ram_block_notify_remap(block->host, offset, page_size);
             }
 
             break;
-- 
2.43.5


