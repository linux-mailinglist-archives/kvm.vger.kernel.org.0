Return-Path: <kvm+bounces-31093-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AEA09C0229
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 11:22:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BFDF528384D
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 10:22:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D806C1EF0A3;
	Thu,  7 Nov 2024 10:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XNehN9t4";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="KdBCTeRq"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76B521EE011
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 10:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730974915; cv=fail; b=bn65iEEu1bTz6j34ss3vBWwY9CWqM8O/2uXkF4kVyFt10wOPSel9kRpPrbh7j/xeG++EobQ7e8SlD3rybV8Oa93FSPl+YLpiBSJHOWXfO87xd1CSRNA2Cnnt+0FTf7pvjomIgMkJz4G2OM1kgwfI3OAJp6KDheoeRc/DXdYKUnc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730974915; c=relaxed/simple;
	bh=Ci6jqE5qYNeWTcl/KaCQydiNirtJi2oszy29vyBDFa4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FuWaUL3j4TEzJPE+rBuWZZH0kt6DS8WWKzGUmyKDWSo/c8APLXFXVJLa/qzCLwcVy01ZZ6UKU+O4Tk/s0Sx2zOvixjlVvdIfaO40cVv66iyXZ88jJiSQZvfhvLicM3QoCCRh2m/Pcy6BZBe6voD1Si2BKQQYDtALmvkzE5ccz2Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=XNehN9t4; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=KdBCTeRq; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A71gRjs020388;
	Thu, 7 Nov 2024 10:21:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=fXE9XjUPrH75g+oLHBDEzkL0PHDXYwMPT4fpyHVZuOk=; b=
	XNehN9t4GXNsLBZ3exgTWhnbtOquvduJQRhT3yCGb+0myuaxm6Gu2yaf5rknpAK0
	xrPWzopsRWZKOVTJF7ExuoZuGiOHyl5B1x7AHZlNbG9BzWoqTBj7Y4+lEHUxB9SS
	D6Jvtqee1KYGerWJeAeSXhFCvAl2cqMvEYv4uYanAC3Fk2zWnlAXlzfG3aqnyYT3
	YD27+nKhk48Aln2Om8YheKYLd4xgUmTvVdK/pcV5/2t9CPWuDgn+kgaJy4vl47BP
	XattMemb7mGKvaw8PpzCf1Gl0VvmXoM3jZsvf1ehHlYkk+DLBbmIiK3Sdl75MQg6
	r61aR0QzNf4uaPLC+N8BIQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42ncmta39m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 07 Nov 2024 10:21:41 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4A79tqJM005034;
	Thu, 7 Nov 2024 10:21:40 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2048.outbound.protection.outlook.com [104.47.58.48])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42p87d7d79-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 07 Nov 2024 10:21:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R230vii3BjCXzWkcoFWYQBeWLG9U4KnRLlS8xluGKDz1hKyYx/On3tcWOnj/MtwplOPN8E1YdbPyFWxK/tVO28Qqqupb17myX8VR4ZsPeasW9bzA+6myWq1Wg7AO37vBC/PAkUqOgkdvK32+1CTpZJq15l9zplc48Mg+dD/UMqSZtAe7HgKtqhq8BGqvXJWi65lqUvCqeZVbXliKcjEY8VDJg+d5yQ73caaC/+u04J5FbMaMwDXJEtxsGPerFY6ILNpJkS1cJqApSXaUhm3DmhrsYoLAnTZii8p76C30J44OvV4oDkjkyoef1kTip49bNVbVnWOzeZWsRZQ0q7WTWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fXE9XjUPrH75g+oLHBDEzkL0PHDXYwMPT4fpyHVZuOk=;
 b=m8CW982ty41hoOLUtLmOjxzbHNR+WrfjkBSZ6+sVHgjj/MsvMm7tMEgH5AOoZk9CnAYZOhj8HULOeSLp/YSRm7VcJMpD/5MoeHnF/xf4AFS9nbbp4wLnUuRVgtCAWsBQWNa7PvNj5gwPxAa8o22DA+Rwga7zPoCnX71Vi8EluXnwFYTdNRatyi5DGJJRZx1dV6XxnbmxcdxUpYepaXRBJk1p68trIWvYXbK0dAdFz4dO7v7tSi9RVKMXpFkLO1olLoDXhXbISeReS92tviFfTBSTnSfYBfBu7SuAAcBv0UCvb9xfret+ai6U6v7y+69yz3afv7gNBuOsxxAKHnDTRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fXE9XjUPrH75g+oLHBDEzkL0PHDXYwMPT4fpyHVZuOk=;
 b=KdBCTeRqYiV4CzeWSaYLcH/kcUVrGnICYUCePfQnQXl6dz79ozFn7WuwUiuWf9fFv8PJWHO8XM6Xaz8/h0DaDdg6THJmm/sdSgiBLC6Pzu11tPbST9EAGBWK8aRypcXGHnmJStDYOjmEzcwwcSXT5Om2RS/J3D5lig0jhLZ7yzw=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by DM6PR10MB4187.namprd10.prod.outlook.com (2603:10b6:5:210::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.19; Thu, 7 Nov
 2024 10:21:37 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%3]) with mapi id 15.20.8137.018; Thu, 7 Nov 2024
 10:21:37 +0000
From: =?UTF-8?q?=E2=80=9CWilliam=20Roche?= <william.roche@oracle.com>
To: david@redhat.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        qemu-arm@nongnu.org
Cc: william.roche@oracle.com, peterx@redhat.com, pbonzini@redhat.com,
        richard.henderson@linaro.org, philmd@linaro.org,
        peter.maydell@linaro.org, mtosatti@redhat.com, imammedo@redhat.com,
        eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
Subject: [PATCH v2 4/7] numa: Introduce and use ram_block_notify_remap()
Date: Thu,  7 Nov 2024 10:21:23 +0000
Message-ID: <20241107102126.2183152-5-william.roche@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241107102126.2183152-1-william.roche@oracle.com>
References: <e2ac7ad0-aa26-4af2-8bb3-825cba4ffca0@redhat.com>
 <20241107102126.2183152-1-william.roche@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0147.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::32) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|DM6PR10MB4187:EE_
X-MS-Office365-Filtering-Correlation-Id: 9800f390-e847-4bd7-a545-08dcff15f687
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Dlm4KnOFfZDkkdyyoEsoCNwyHCu3W+48wWONhw3rCt+16rwk1GBtGhHNUhRj?=
 =?us-ascii?Q?2D9W73zeqD2zqjfyuOssXcRgkStAr/gfCaDW9RvDtt6CYXtxvcCkDKGNfvmf?=
 =?us-ascii?Q?YYOZQb8X0pSpmhwItYAFIsoCsb+x5aAnYIwMpfUSonUtnLKfd7yI5gzN5foa?=
 =?us-ascii?Q?acBKVT1YCBdwZiGoCqCfWjPgtNoierEsRjDgJBTpRR5X3vhR+UbAyqRuyRuD?=
 =?us-ascii?Q?HatBCYybvRiWDdWY/2Gf/Ku8ECyDsCQ+1xX3gWWDxdQ+jGvIGPX+esMS/jQf?=
 =?us-ascii?Q?Oc1kWOb+EpbQPzAgns5p27lKaMc9MTo3ShpcOB99u4cf+YiEJQGAIghiwMjm?=
 =?us-ascii?Q?4EY64YNELrWgezqOIl5qDG9YzZtoXObUO33M4GH3fsL55wkbsCZFCv3o9+7L?=
 =?us-ascii?Q?Ib6LIjjsCt+nIeXOLPNM/JmGlhPBmTUp/zRD5V7TcybsftfvdFheZoMT0jnB?=
 =?us-ascii?Q?SNfAQiqLP2uLtA1kBN2eSr7gGAAfqT/wNPjA6a3HRTIDFgrdjf5mn3I4S2fD?=
 =?us-ascii?Q?Pk49yUA9QaDgW26SqyOiK7RPlq3COro6UQ5flDcKJRdNa6jclmICPZnhFo5U?=
 =?us-ascii?Q?NJZBnlPKYGOYxyocWz9buCtKcjz5Yn4bLb5Wi0LB+zbKMuO4c1+JX+pzYGK0?=
 =?us-ascii?Q?3EGPcVhkRKxqsNg5InX5X0/c9UmIr3cYPofeudliC77znztj1Saj9R95xYJc?=
 =?us-ascii?Q?fXIGFMPJatvqoVcMrqL8PY3usCrqXQN+sY8M1CuV5CoJVKf1psKEfKFXtut/?=
 =?us-ascii?Q?uMZapFRIB6u/k4zdq8GeWQ/tiKXKdittEMVfxq5zYWcqtGPThJqaNRD2QD13?=
 =?us-ascii?Q?YZS+8BGSaOhHcIx5BBigwZ49YfkAYd7q1iRVCTjBVplMd4WjfK5cKpphx1uN?=
 =?us-ascii?Q?xmeCjq0I8cGHRyVWXrbSw3jbZmH+PusDSSxls1KpHj/KO71Uudnp4Gb2Tk5k?=
 =?us-ascii?Q?l0gBSssxPNhTmUhfR93QhI0VzltPL1jMUCCjlwD/BOnorNPIgS/G+myTq9wH?=
 =?us-ascii?Q?kQtue8u4TuYp+RE4JjkbBqHql1pnaXwa0oiDwlsE9S3Tugl+2oAqc2xzcm3y?=
 =?us-ascii?Q?ssm5UqbTXLUSut/voPNQCT6ec8gAb1Z+B9/cE14slWFiSO6xhbWJSP41+eRS?=
 =?us-ascii?Q?OydgHKg9iRenwJtvTQti+cRvfBnx2XBn0ydc+y4e5a4YXWTc+lkItdRPtxxd?=
 =?us-ascii?Q?PvEwLWpu3eN9oCAF41hA+5tQxTw5NyW3Zx5viqgnED54FWgHTe124IjFISzJ?=
 =?us-ascii?Q?ur6YUYXzAnieH7bM2CLdfifrWEuyJdZ+gwf788GcFo2ueHmGCAbbAuDD7sng?=
 =?us-ascii?Q?QnxNG7tgBF2weM5S9c6HDQ5x?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?UENG4Tw63SNu/Ee6Sk1YiWsbgJK6w8yqwhlkY7ASeTUQCFNLEfKq/IC8qtZN?=
 =?us-ascii?Q?uWBIMVu1QD39rwRKHvrrldTtY5n24WD/9Fyet9SzmzzlSZ+Q7QVvKksBjYNS?=
 =?us-ascii?Q?bV1km+E4RKwDf/pMfgln8kjYiJyCcdi5lxj7bLci/I1oTWmg/Udi+G9K35E8?=
 =?us-ascii?Q?mwQWw1/VmUmvwWpKarwaD/NISREQ4sQ1OYuKauhO7Nkwhls18C/R7geU45BX?=
 =?us-ascii?Q?wIbSX4nGSEhtmUYoKVKwwuB2MT7LWg7YX094LhTgmcCiZhWenYPiyYn8azJU?=
 =?us-ascii?Q?keWrCxXsyehCGdww6Soe7OaLFWyoCCfr+BMbnASk5OZ5gGayYI1P4upUqqQD?=
 =?us-ascii?Q?fg/isJjEK6lDZfYENFPB0pDs0Ct/99am+QfM9/OjS8TNl864eeSQw7kdN1t7?=
 =?us-ascii?Q?Q0jvq0zornLbzQrEbIVPXCcFvzdBJqvyfFE/NS0BD+vHmpRMy3g/69WAI8Yv?=
 =?us-ascii?Q?lcrfJTYf5I6C8KqjmvJgDV75qIthY1ckKWCYnRY2zBfhjWCbm8NApGXk7gMx?=
 =?us-ascii?Q?Nv6ZK2pcI34GV0mmtUNAEPXLzglLVnj2vpBHKYGau3MAKNozGfoRU+O3T3Xl?=
 =?us-ascii?Q?tTWPqfdinAfxHe1UjmZYAaLiC9e/MI0OJhPOAcGObv9gYv/GZoPJlKWaNm0G?=
 =?us-ascii?Q?o1iEslH3ffvUpHxlZmwyugroQ4Z/rHScOPsUziHvCSvJa3Q8pD0LTpVNnY4b?=
 =?us-ascii?Q?86oe9NAhb5Y3dpVgOPzFSiaTnBybrTh4uvbzjbbIngtxe2Y5wmmEAhWwrgt6?=
 =?us-ascii?Q?TXzdOl+i4zQKbQXy6jD67unaVSoRYjQhQMjAXpNhXM8UCgQQ2QQi1QtDuGIf?=
 =?us-ascii?Q?f5S/4cAjd6QrCo+5Cb1Aiz/YXkixMmOVbEhz/ujzoekeLkN7jGaH8GdUAcjy?=
 =?us-ascii?Q?mxWcuCtKCKDa6HoA8F1pYS/fttO1mh8anM21iEPUoSzUnEmE6XhXSELc0+3h?=
 =?us-ascii?Q?z57VD2jUFYiTZWAMnv5dUMTwR7HTFrY1WFHCgEj+yhogniPqi37mSHc5Sca6?=
 =?us-ascii?Q?t/sdeb33HJFQ9RQobPeFkg6LEioGqlDB4C/qQr25fWez8sQUEspYmlfNw9dw?=
 =?us-ascii?Q?lKuSdj+5FtNSLV/XX5q9GieI6ZEatXxKP0jXV5ow2piuT1iyf5gtcd2ZgBEl?=
 =?us-ascii?Q?nMlLYle9lBP+JLNzZVxSdqOxfwm9un3bDmjdRZagLUaZuxJlW727usgmDkfU?=
 =?us-ascii?Q?TmgZcv+K5kymWPaB4YBfZIS2BI1Kln53NrTWN96uAU5x4+UnivHzCLCQ5oNP?=
 =?us-ascii?Q?cM7f0FIgy9diK7HQqyz+lMIpg/TtJBGN4NbCXeCqDIohsprd+AkVHWjn3ee8?=
 =?us-ascii?Q?CahBxUxO6z2cGq0PoSllHWOxGWGxaKEjLOUPIs/Ck72SmDs4c2t2teGjgtxz?=
 =?us-ascii?Q?fZFXM/SjJIAOxgjkYpYCrpdaVzsXL9Do4J5eGcjpfpIRQJwXo2Cpf0bcyW95?=
 =?us-ascii?Q?HiiuNdYkoEdIS3KSNiCBlD+0lfPZZBE3MnZSR8+zzABhpJkuKrmgPUdUwlhY?=
 =?us-ascii?Q?E4HYUjbaiKvilMdPYOVW3wiYuE8x2Z583xdAPqGqoEkH8P4icuHizIyFo2wD?=
 =?us-ascii?Q?fH0gmUVNyAiSRcWdCnCardgzNfx4W0zHmj4xDzwMOAU2eQ74iHYp4ZBVf/us?=
 =?us-ascii?Q?7A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	lxD8u+vLj5YBKg7H33sHPAML6tQ7qZeSuim+obKVCUZmxgRSBDpf60u0VP348BPbvb4hUNLWddoBrLfWL4a6tZT6UK7y67PiDiIotsvKJhZ/dIVW6puJSJkT56DpoG/0JkAwcjGLzO9G6kjcwpRFvZqi+SHz7DLw2XHxMlRc2RdlESKHGV+DogzwCdr05EoDKPc8lKu6PA72geSDe3pZ+wrvDSdSYNYoPqAKNEm0glm2qsij1pW3ycDkHzvrG4u54mUJvrnx5YFdGOfSO0iwoQBMDFrEHJ8oJ9gdVWt9cMv4frK/qPQJKA6ciP/M5dybIoYl3ru1jCXpPmNFe6IeaWWdRo6YDjmC5sTx99Ek+Pl32cICbPYDDKrxNzm2bz7Gf+umeN68HCgjdN/nrLZstolLUGqkLtpBsZTRwUY3fGdE0uZWhkb9tZnlglqdKOwZZnf53UXqmdk1SHFox2hSpYqKrK9CgOcEav/D3zIM2i1QAlAqtFni1Q8HDIfyV+kNT8Fk1E6jFFdCq0siw4RpPdBNo2ODiw+PEDyKNUDjp28dbfv9Kc0to4RyZXrvf2PRFupPR0KB9vQMKy0Wo8Eufjt7p2ZmY1roh5kfCOCYLnY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9800f390-e847-4bd7-a545-08dcff15f687
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2024 10:21:37.6900
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /zP4sEgOdpi9tvdu7+Uo1Z/hVZyB2giLM2eXjKnWeelH48erYSWJLqscfaRhu9TrZZFCd1Gd9MudT6UsDCIrRNFXrUSc79XtKNgJzGLPdZg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4187
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-07_01,2024-11-06_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411070079
X-Proofpoint-GUID: 3-mCPM56Ttq2iA6ciyLKePMeGhPaqB7g
X-Proofpoint-ORIG-GUID: 3-mCPM56Ttq2iA6ciyLKePMeGhPaqB7g

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
index dfea120cc5..e72ca31451 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -2228,6 +2228,7 @@ void qemu_ram_remap(ram_addr_t addr, ram_addr_t length)
                     memory_try_enable_merging(vaddr, length);
                     qemu_ram_setup_dump(vaddr, length);
                 }
+                ram_block_notify_remap(block->host, offset, length);
             }
         }
     }
-- 
2.43.5


