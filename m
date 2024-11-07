Return-Path: <kvm+bounces-31089-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 31CC19C0225
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 11:22:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9626EB22683
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 10:22:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C166D1EC00E;
	Thu,  7 Nov 2024 10:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YEIWWSD6";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="X3rck6jg"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF901DB54B
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 10:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730974910; cv=fail; b=RJ3hQ4UXTFMf1d2qqCycfhiWFCUfZVuOTMdEi6Yl3OHv7/tsvVnn+NZD/nrfbF2nNagUTfZnDfwjxTkPtbEGV/XpYf9mXyKAhi24hFBVKEpD7nzYohhlfefzmdTOXxP9SNG4dr4zfZLdx1QpSslvi8G0517xX737nKXO2qn5EZc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730974910; c=relaxed/simple;
	bh=fKp+zwGa/7XYS2OcjJ6kO2dFy+2sMp1AGdpRt/bZ/q8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hHsMokRrtszzb2DK1DbuQmihq1ivgSxxhjGClUx9ww5eURey/5wUy+gn0wJEzngsuWRItb9fjeS1XpZMIl64zim+psdZQvCIjodsFC/JDRxxxFJRgDNdeJfUgzkO9qIo4i9x74EeUCtHvEWwVjgRVl4CpAOxIztqicLoqMqT0Ps=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YEIWWSD6; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=X3rck6jg; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A71fYMm000760;
	Thu, 7 Nov 2024 10:21:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=MBAG7MhQBBCzJSZ6lPEp7h0EoZeK3PNMqygbk4HHkbM=; b=
	YEIWWSD6vyXuXSyhTLeUS6pKB7+pKwNU0Q1b+FxSfmF3CV8kkc5sLqwPUcUA5UqY
	ZWWIv+utL2V8YmGDXv8JFF0Wvtud562OY0UuiDqrWom3sp6bmLMGyqnm7KVpg1Kd
	IhUXsbd5A9VfVBVtXKHrYayuT3BrbMw3tP9u2sCSbdImLX749nFjzYJXpNXMhAcs
	zuoHKRLkPhGira15XGZRHhVealG1uvCs+qUQ/caVjovb9jZ7YHGjdRb6eL6e4t8U
	LK6ANRBf6sp6Eqcu7OFEBvFfI/QnxfVlVM8Z9ICWiHkx7vwmznVn5xt4v4xuNEdG
	lnaIxOA4BQ2iQFXzqnEtAA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42nc4c27ky-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 07 Nov 2024 10:21:34 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4A78oADI009824;
	Thu, 7 Nov 2024 10:21:33 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2041.outbound.protection.outlook.com [104.47.55.41])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42nahg538a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 07 Nov 2024 10:21:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HHajgneSUkhH7r93kTq4DDwvYplFpOwV1PIwMZCTKcT+lQwOjmzAQQGaANlmdgk8B2lkGyeB0cPPpylDLMP1X6DH/Kwb1fRKovRL1yrl3cU5TfJRJNIpP2r2ywykFjQfqeIL1d6XV2pM9Gb3PwjLeB7J/hYTImP6H4ISQwCYS/oA7CDZ+nelSfBUg0hkCqI18wsU86HLUeraoyLfoo6AVWcj6FSGrOxP0HbJwnb74sCLFe62CCduLsWu/UBTKCi2B2/bbG+jcCxNR5c1IedaJJvPiHCUA/vmWB5OFhJH7/zjVehI8+S2VeNeTfoso6IHhC8kKCJtsBLnznUBTkJ8Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MBAG7MhQBBCzJSZ6lPEp7h0EoZeK3PNMqygbk4HHkbM=;
 b=mkxNJ1rKNKbyeGtWaccvT1ied8TgS9NrbTrTyafR5/6e48ysG60V9CqkialDYcYoNRA38THW52sD5oQMSW0JT/JA8Vf3iX4wi2iyrkD5KWa/ipNJ03epFe4VtEOUiAOEDxkDPwO+5qhq/1F79p3j+748ilpDUbJ9fYTkpqhVgvGfUVCJgGqdZMQsbUawM9AaL4wAHTT07IqzPJkkpGdMJB0wpseu2LKJuDk/H5asvrj1Lt0heOEK9fHEh5zJzWsbd8X2S9qhZ0RkHFTCuBVT6VIdBOuG562ZMgwpS6H6Q0rcGsPvL0Ys9tGSNvhqaxcRKMtDoqV0Nc+yLHp2lg8Wtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MBAG7MhQBBCzJSZ6lPEp7h0EoZeK3PNMqygbk4HHkbM=;
 b=X3rck6jgzLQVeW3NVa3r9gcOAqKmLvdrCRVIZI/Ok/n+SeMHmrdcyJmJqZWFUo/6QTAWK3YiH+QBfJOU0fSX+5aMBuJacFG8mq/ZfADtY8b4n2e9MZK8ZiuVk0NUU0OzSX4iAs6SL4PlJZA+p5cYAXhQeetXrxnXKKa7fcYtT2c=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by DM6PR10MB4187.namprd10.prod.outlook.com (2603:10b6:5:210::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.19; Thu, 7 Nov
 2024 10:21:31 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%3]) with mapi id 15.20.8137.018; Thu, 7 Nov 2024
 10:21:31 +0000
From: =?UTF-8?q?=E2=80=9CWilliam=20Roche?= <william.roche@oracle.com>
To: david@redhat.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        qemu-arm@nongnu.org
Cc: william.roche@oracle.com, peterx@redhat.com, pbonzini@redhat.com,
        richard.henderson@linaro.org, philmd@linaro.org,
        peter.maydell@linaro.org, mtosatti@redhat.com, imammedo@redhat.com,
        eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
Subject: [PATCH v2 1/7] accel/kvm: Keep track of the HWPoisonPage page_size
Date: Thu,  7 Nov 2024 10:21:20 +0000
Message-ID: <20241107102126.2183152-2-william.roche@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241107102126.2183152-1-william.roche@oracle.com>
References: <e2ac7ad0-aa26-4af2-8bb3-825cba4ffca0@redhat.com>
 <20241107102126.2183152-1-william.roche@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0142.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::27) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|DM6PR10MB4187:EE_
X-MS-Office365-Filtering-Correlation-Id: d34a29b5-9ce7-44b2-150d-08dcff15f277
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ODqAlK0lOQKENbJ0TKITwTlPxUZC3sp4WiVxt2R5fXAbytbRsto4M4d9IU66?=
 =?us-ascii?Q?5Rn7YTpx/Pop3olf7P+wA1iUUyWm0ImBekx1nQEYOMBldgkMCxT+VgKdLcn+?=
 =?us-ascii?Q?riOgm9HenklaIG6sSgk2wgBUc9A5Hpfgxx0xw5bYtIK5s9C9NVXyOrD+Jm5j?=
 =?us-ascii?Q?4YQVaWM5eocWi/TIf/UoEeutPXHuPQ+yjeSH1aRTASqofA9X35hY4jQc/RAy?=
 =?us-ascii?Q?fAuckoJ/Tr8ipCIOBSwduQqPWBlhfAOgfTIhnR6XU5qCPl4CS3nommn9bzVy?=
 =?us-ascii?Q?MljaJtwy5ZqEIxgf3Jdq4dwO1C1knbG0J5uiNeXNtsrlShfTQ4NB1gwaAhGw?=
 =?us-ascii?Q?XLHF+3cdINBi+wbxskXi7N3AodSiytm/6YvxnteTkJSd5qbiGC+nt9BWToof?=
 =?us-ascii?Q?8jpD8BNyLskVkm13n3KWeZyz2Nuno+gqOq0FJw0eo0SZBuhSEc4+IXjn49Sr?=
 =?us-ascii?Q?N5/GidJxyn4oAwZ96TzGbJYh86mHZ11Y9yECzSun7C9dFvSI0CFFYZWmJfsw?=
 =?us-ascii?Q?Gvn/InAsXA8xqPSpPWjeMWYBhsr06znCBwUs3iRh1tt03fHF7yOWFp+iaaFc?=
 =?us-ascii?Q?ZHZ1J7Grm/yu1e0TKzBMKKXd6kUJeW2KzoONLb1MCi2miu8nk/ZAcvHsbhr7?=
 =?us-ascii?Q?Hp71wbEGBPQOCAgBRRlVrrdf6tFHKAE/RnIlbigO+Mcy2oeV+xw94OOvXgwx?=
 =?us-ascii?Q?QhUWU8DfbPflK9HB9vnTLuUZoZsXxwpKeuuSGENLR+vy/r39tet0MerR8v7+?=
 =?us-ascii?Q?kpPJcyINbOd78o2JWBcWI/21D/8Wo4Bsvfouk6IXm6/5WUJenJxiuAdRx4mW?=
 =?us-ascii?Q?U76ShTkaW4vxQsrjpMmJj8Rv2ZDJjKVWWhjoKrnsvLp1La9MHFQzQiRMVpwd?=
 =?us-ascii?Q?ITs243EnZL/apU0xRYlNntbNVDiK73tFslfZodffiQJkuw8x1H6TvkjULHWt?=
 =?us-ascii?Q?khTHm9Wqn4+WbCf/coM+tebATT3qmguQzV1dD4Bac1I04KzCafQMBlD2abbz?=
 =?us-ascii?Q?+serDuEQIz8MSVn0dOu8SnSxFTTUz25Voq9iRD6aCq3/JiKltUolJSNk4yLU?=
 =?us-ascii?Q?V43O6Zsob/R7hAu02hwXKY/tUs/jZ+S+GI60vEvgunB2xP0lWU4WHwRo53bk?=
 =?us-ascii?Q?9YoqH9+Z/MVp53uewTe9jWd7l5giQhqXEckvlUe0it4NP/Unvc2bI7COajt0?=
 =?us-ascii?Q?jZO/tjzbS23coJ6b1sn9kYeB+JKA64vlyUj0IJm5l34noGFeednjt4F2C82Q?=
 =?us-ascii?Q?ktcbv8c/y3VaOgj5KLkUL5EUKiyVPOeOc0IrOQRUU9eLrGEsgtBvQUabvLsm?=
 =?us-ascii?Q?Xr/bRfEH16wS2DfBjSQzEvYT?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HIb3W/FP2kyGqBKfyZdd9USidV/Ey+3C6ZGS6TYdkAlAIHumOSsSJRU2dF23?=
 =?us-ascii?Q?viM0dm4QoIm+d02C70HlNrbt1x2lehb54USKcn1FlBSXDXaZpNfGUYVNQLes?=
 =?us-ascii?Q?Bh/z/Kerj4/NfPtrSVYFlpITTGuhQhWof3ccP7pgBX+xnoqRIu6+n1NAIuAu?=
 =?us-ascii?Q?eGNsZOUlGk89RzWdpPRP3HHsXrtpCjZLIL6q7ayELIME5iLaBECsVoqGtnSO?=
 =?us-ascii?Q?IQCe7/EKi8maUXs7MEXY7W3fZAjIH5T3oxlrs/+Bx0THZruEVQDZ6UHiio6Y?=
 =?us-ascii?Q?pf/ZiIEB7TRQvNK1XVPihieGIaVHE+neB/JZxr3c+R3SrjDPOxO6rBFmCSl5?=
 =?us-ascii?Q?AejEJYdz764jiZGNViXu6MzDoQ1Ov8OJarQYWJfo/ccDB+8yXOwt1ZeRJCp5?=
 =?us-ascii?Q?1OVgma+sBaChH+mj64KKbPajoPzPymcXcSHedrjlaOw9dTUjLXHgx3Et5jJR?=
 =?us-ascii?Q?IhgeSsUvzmeRPSBXBpaA56GRpLi3Ptt7LUP8i7LzbhfXM/cm999zNUGJeLe1?=
 =?us-ascii?Q?FPOItO9qRtWqRDb5J1E2xQ4IamaiqBzqfo418Jt/+vqz/8MMfRXV0cUGf3Bf?=
 =?us-ascii?Q?vVKsnrVPCXASzqd9SiIildrwHf4nndomLM4lgpYg2FbvzAoJalPFQ3ojKZ3d?=
 =?us-ascii?Q?T1fYubBv2hi35jirxcIdPR+e+xZbBDSPlLdkr/u8SaiUwfSVX2OkwN2iQTry?=
 =?us-ascii?Q?ZVAGASamC3KP1pg1swRfQFuzdcDGa+iYG+47k/8bou8bcgUHbK0mR234pKd7?=
 =?us-ascii?Q?g6AMv2dsRHle3X1bRBTa+bXDwyxT33JZol+z9AOLqDfEPUPb8TzyXWtUfcbF?=
 =?us-ascii?Q?El6SoxLVPd+HiZJMN+q8UAIeJkcwMo/4+NIWx6kUA3StBCLjRPouK2EpQ5l6?=
 =?us-ascii?Q?7eGIVQ7D387DVg42MQgFR0r9XuMFac/GpSHlpKKAtJXwG1opbxXFo2B48zYn?=
 =?us-ascii?Q?ZszyaZ4izKv+0tam6p1MMwCPjPRNyscGstTmDnSvooKBUo0VANHiRYezG/bi?=
 =?us-ascii?Q?hKZztm6eNo86c3cyPOQUq0vqD62DRst0Q3YOw0623XZEMBvBqR5A9uJhABJ8?=
 =?us-ascii?Q?i6L0pYqa5//1YkX2RZkZdIfm49i4vo19WOg2UdRxSU2MTfDny1Gx43icejsb?=
 =?us-ascii?Q?gtis2ry78aR+rsSI+rTnRCm6fPZsxpe6zcvs0HA+xfXWD3rh9L/1EGG83PDE?=
 =?us-ascii?Q?8GJjg+edPQ6FqwSrv9TYYV7hcqihhKZPYGxejJagSSBfSxt33+CVr4mH7l30?=
 =?us-ascii?Q?88LsT9c9S2gy4G43HBFrYh8qJg2YcEiXAaU2tXfUbVCfJ44MuU3hrLaO4D1r?=
 =?us-ascii?Q?Z41nYtxHdzKqd5yE9ZtsvEw3wopLLJMwtgIOFayr24u5LJWkToGJ70MnP94h?=
 =?us-ascii?Q?PxoAvbSwQkxnyhzG1LYZ4Wxf54WUyZGu1ZD1CpPSjEodZiTuyWW67f+9fvNa?=
 =?us-ascii?Q?HeRN8n92cyB1dRxQWjBuqTNeRtBFuHkoLWMbr/rLti4dQttnJW0BfCJgkkGB?=
 =?us-ascii?Q?oJOBXddqLqRDnng+f65xybiDOnohOGKubIuqyQ43pE2ZVoZd1mIRI3Obi8R+?=
 =?us-ascii?Q?C1GbcWdql7ZhqSBIDt7DEljtqi1mdHZMQZ7vz3JxMmFdvjHzeInQY23Q5P60?=
 =?us-ascii?Q?GQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WHYAGtTDCeJQhI6xwOGtQqWp3hfcaKksbyr6QnoYti8M2PVK6NB8MdxVwaxGbqf2p0yanWnDZoPVleb+TM3VYp8rwNDHHo+Fi6C/K3lHPchRYWXG7zY3axedZoWIonfVcdu1UPfQ7tyzWznnER4VxbHrLodDQrczoH3oIiUDvHVPV4btvIJIO0a2/4yGiD2wPgQh5BhAH3CehAxHOGKb25l88zgtE7cppDYsgjHQ5Ik6FiSHiM5dWkHsFqcnopcdLbf7V8aWhHgx6eKGCIui9d9CzCJqkFbgtKIAmMQ+o1Xawf5BsBjpryeP+0xyMeS8FxRxFn9z6FFsjMQqtXeN8CvQNVlRNtZ54JatQ5cFD8RMpA7I5BR6EioyB8Tl+DAk/I09N2001pPQsHZ7nOjSwazP5u4gXot2LraQhsAQLhp/WR13Jidj5jNvAf9zlm6FgIIUwpT66x6RvUpElfeEnecywsrRQd0AnpngEv6lNCg28TdOVdVcLMNyItwafdFKrvjiZRKoosxaoL/KVS4RFGhmx40zgG2+2LMI2qQy5z6QPIQr7dDYYbS4s43qASrEEFLUyZMJGI0yt+ph0Gk3uxivs5VHOCCfISr3ycL06aU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d34a29b5-9ce7-44b2-150d-08dcff15f277
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2024 10:21:30.9328
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tPje6gvFc9GWGpVZBeaL9C9g7ihQzcR7yR5Ojilh7sMgjHBcQewNLewqaQSK6WHIXIYVs4PPIWFeTe9Px9WxMYUJQRu6ej4Lyh2cGeUk95Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4187
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-07_01,2024-11-06_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2409260000 definitions=main-2411070079
X-Proofpoint-ORIG-GUID: 5mdBIILOWk07rTbpKxVgphhJCeZHNMvp
X-Proofpoint-GUID: 5mdBIILOWk07rTbpKxVgphhJCeZHNMvp

From: William Roche <william.roche@oracle.com>

When a memory page is added to the hwpoison_page_list, include
the page size information.  This size is the backend real page
size. To better deal with hugepages, we create a single entry
for the entire page.

Signed-off-by: William Roche <william.roche@oracle.com>
---
 accel/kvm/kvm-all.c       |  8 +++++++-
 include/exec/cpu-common.h |  1 +
 system/physmem.c          | 13 +++++++++++++
 3 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 801cff16a5..6dd06f5edf 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -1266,6 +1266,7 @@ int kvm_vm_check_extension(KVMState *s, unsigned int extension)
  */
 typedef struct HWPoisonPage {
     ram_addr_t ram_addr;
+    size_t     page_size;
     QLIST_ENTRY(HWPoisonPage) list;
 } HWPoisonPage;
 
@@ -1278,7 +1279,7 @@ static void kvm_unpoison_all(void *param)
 
     QLIST_FOREACH_SAFE(page, &hwpoison_page_list, list, next_page) {
         QLIST_REMOVE(page, list);
-        qemu_ram_remap(page->ram_addr, TARGET_PAGE_SIZE);
+        qemu_ram_remap(page->ram_addr, page->page_size);
         g_free(page);
     }
 }
@@ -1286,6 +1287,10 @@ static void kvm_unpoison_all(void *param)
 void kvm_hwpoison_page_add(ram_addr_t ram_addr)
 {
     HWPoisonPage *page;
+    size_t sz = qemu_ram_pagesize_from_addr(ram_addr);
+
+    if (sz > TARGET_PAGE_SIZE)
+        ram_addr = ROUND_DOWN(ram_addr, sz);
 
     QLIST_FOREACH(page, &hwpoison_page_list, list) {
         if (page->ram_addr == ram_addr) {
@@ -1294,6 +1299,7 @@ void kvm_hwpoison_page_add(ram_addr_t ram_addr)
     }
     page = g_new(HWPoisonPage, 1);
     page->ram_addr = ram_addr;
+    page->page_size = sz;
     QLIST_INSERT_HEAD(&hwpoison_page_list, page, list);
 }
 
diff --git a/include/exec/cpu-common.h b/include/exec/cpu-common.h
index 638dc806a5..8f8f7ad567 100644
--- a/include/exec/cpu-common.h
+++ b/include/exec/cpu-common.h
@@ -108,6 +108,7 @@ bool qemu_ram_is_named_file(RAMBlock *rb);
 int qemu_ram_get_fd(RAMBlock *rb);
 
 size_t qemu_ram_pagesize(RAMBlock *block);
+size_t qemu_ram_pagesize_from_addr(ram_addr_t addr);
 size_t qemu_ram_pagesize_largest(void);
 
 /**
diff --git a/system/physmem.c b/system/physmem.c
index dc1db3a384..750604d47d 100644
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
-- 
2.43.5


