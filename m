Return-Path: <kvm+bounces-32452-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CF38F9D888A
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 15:55:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7ADE8B65158
	for <lists+kvm@lfdr.de>; Mon, 25 Nov 2024 14:28:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DDE51B0F21;
	Mon, 25 Nov 2024 14:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="C6q5AEFd";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="CjVPdvc/"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 041761B0F15
	for <kvm@vger.kernel.org>; Mon, 25 Nov 2024 14:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732544868; cv=fail; b=Z7iZuMhJQi0JWnlTVDjR4MPu7Kcf9O4xoZzBJ06vebruIbFcqOssl6zXOvTcbXuHl7/oiuNqIwGOWKeKROKDukkoh1B1cYxvmQOIjrq7VxHHaaJiO2nPCxgIXBjKUwLPahtzC9kmOew5AyeWhC224C17HdaP5pBRo/XHwFp/eqg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732544868; c=relaxed/simple;
	bh=xm7pJRNdtClbqmK64xXUGbItCXn1o4SYhEEftIzeee4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OfTfbpte4a5B3mJCoJp5Zl5CsJo65KcAo04sA2SlZ1QMRP8Zt5zi1oUceUk5yqEERzpLmtNNKzUD7PHzZpoRT2nPAjlWrEkYW1+3bYTO+ObfpwAQ03s8BmR58RsPA0bSWgTPXn8XUx0NKtQ/dyY8Sooh3ZjnJHRj5xRf4oIuRhk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=C6q5AEFd; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=CjVPdvc/; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AP6fk15003729;
	Mon, 25 Nov 2024 14:27:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=uLhbKhI5RH66g6X1oJem2vCjv5om1/AgyTDM5B2oaik=; b=
	C6q5AEFd/S2NqIUqIhdbNY6b6BlJfQrq9mo7k+pXg6/ZxF/xtwPYv7qomFpYsAba
	fmdvDZIX2oFw6/68FDmbbCwqLwmXvUZ38g6i+2IXSMRVvCto1Qk+euHT53NTONXu
	D2cwOO00nzAeOeHxwdY2h221Tj0t6HpP2kM4B5IfomQ6rtWIm/mlKUUjb6vJL9gv
	zy00t3UuCDnzXUlLvXUfKVQ3VJkL0aUjSO11atME/863KHkP2V7fTRTxZ6PdUVIq
	oFNNmvlQCHGSpWhL7H3uWdYznJ04CmqHZ/w1hcaiZFrVd80yjdsBc+VASDW32/oJ
	nxOB/CBog8c6PnfB04Z1DQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43384e369k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Nov 2024 14:27:36 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4APDnGGX004564;
	Mon, 25 Nov 2024 14:27:35 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4335g7j5eu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 25 Nov 2024 14:27:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AA4lWfVwaQZx81vkcEU7N6CQrBXjXWnRoJM7PLcA6c2SD/DB+xVNSWf048e1IadwGETLD70Pg7Gh2vHAbA6ZXofUujMhajzPsOKMGlcSDizJDEK91eGnjcPrxq/IsQvKC9DjV2FU7r5u9XmW95RauFpKCdSDCUXEerQR04BhuzslMo1SKe+SyzJooF+Vi+zyXV1objfA20W8Lr0rlvupC9DBIw+MXS9CLyLkxhY+VKer/GTcedFtL2rTknWvvQZ/dIrbFu/DsQznvKQCGvb8nSg2hFdiGvw5WHXDW6kpwJTjZX1LrRpmzOUsUuUTDgMNSny6QVXR3qAPlfWQbXa7AA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uLhbKhI5RH66g6X1oJem2vCjv5om1/AgyTDM5B2oaik=;
 b=Fp8KLvxT7C0MEgHf9DHUmgKhugsNDPK2Cnnbc21R84KTStbc2H4kpnvfZRfxNNKHGDUoBXXMobyBmwoYEqskau3rpOC58nB+dM2XLXw7Os6FLif/jspHGFQ3O9mTZh87wT0pt0hV3h5l/+lnd3wdTxaXUUFyRIwXXf9FGryhCliS2bHW44KHU06QUPdEp8dx9WilxoHOcJAH36PAWr0avFd2VoOOIh5kTdPGHLywX1+RcqAfwhDfcH23x9el5PgziP38KN19bL7qhDPeDxsolgAVVmNdweYM7m5M/WMbNJHMo0WxD8vB5CLx6SIpHP9PKwXqLdrWlD/OF9NRTQxsDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uLhbKhI5RH66g6X1oJem2vCjv5om1/AgyTDM5B2oaik=;
 b=CjVPdvc/U/aif45smqR+W/kMJVxZGvvw6pSn+sflrE7OOfOmNZgN6170OUmscK2PVV9/an4oDKk5ueT9FidaOKBatuGNSEPlj0aPDgwrMLWCSbucMQa4YMguJGoxOcVac7fO/OaMtV28MgD78Dyi6kjuHFSSVFTLe1Lniw0O6yI=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by IA1PR10MB5995.namprd10.prod.outlook.com (2603:10b6:208:3ed::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.21; Mon, 25 Nov
 2024 14:27:32 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%4]) with mapi id 15.20.8182.018; Mon, 25 Nov 2024
 14:27:32 +0000
From: =?UTF-8?q?=E2=80=9CWilliam=20Roche?= <william.roche@oracle.com>
To: david@redhat.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        qemu-arm@nongnu.org
Cc: william.roche@oracle.com, peterx@redhat.com, pbonzini@redhat.com,
        richard.henderson@linaro.org, philmd@linaro.org,
        peter.maydell@linaro.org, mtosatti@redhat.com, imammedo@redhat.com,
        eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
Subject: [PATCH v3 6/7] hostmem: Handle remapping of RAM
Date: Mon, 25 Nov 2024 14:27:17 +0000
Message-ID: <20241125142718.3373203-7-william.roche@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241125142718.3373203-1-william.roche@oracle.com>
References: <cf587c8b-3894-4589-bfea-be5db70e81f3@redhat.com>
 <20241125142718.3373203-1-william.roche@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0034.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ae::8) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|IA1PR10MB5995:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e5a0238-f9da-422b-83d5-08dd0d5d4c5d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?75dhWzv3TbugQTe/DJWPvKzCXeZBMozvZ0SGUAbk5kzPWlPMvfTSLeqURA8P?=
 =?us-ascii?Q?CUC1LCNhoyfBfMLOY5FsoXwhEeFZmHqJAUvH2BBOU31D8TXFXKMsG+bOPBMh?=
 =?us-ascii?Q?8XhEBTV/DYe2ulemdFMYFPjuUUqmgqa0Z7cmU2BU0FKrUmoJuuba6mSXpLuW?=
 =?us-ascii?Q?IWG7Y4jFc06DEGlDhaBXZ1xRz8Lo6jkdQufq9Zbnqmc6wnWU14q/sqVKq4zY?=
 =?us-ascii?Q?x/d27QCtCgtVrJdGPMeAVc3Kr5ButiW4ESRbgQ0fTPXIJzvvmWxMOVwx9ij9?=
 =?us-ascii?Q?eP6jgvtpRqod/GgzKpcxMfKjIYs7V2FRJyBC365ehSUR/KJ/u6xsFW8NU3PS?=
 =?us-ascii?Q?SXO8uoN892ujy8L0gPXjTZYb8Hov4SY37BHArHelk2CJ/oSt3xej5t7oeRvm?=
 =?us-ascii?Q?uzFBSxmQpAcnTAnXfd8XJH35yd1yO8I2fesIWuQMudyc78quZLx0QQFApYM6?=
 =?us-ascii?Q?4A9oinb4twdYTBgv0NpXBRl8EDPVCHbl2fpl/965DdXDyVizQhDE1PMI6fzE?=
 =?us-ascii?Q?0IndNSdm3JUVrOyNrHgQ+EcIoMt8wVnBYRit2i8kVgSWayB69YWcf5ca34xt?=
 =?us-ascii?Q?BjrA4jIHGuHOGLiE9ijDV+3lIRqxPpUQ2UnJY0dxeP5u6gFUmCmfbf3RbJZI?=
 =?us-ascii?Q?VrIq3+BAaPNrjaX/uc6YyWzZ5Y2JazZ1a2fcKVNIZkkriHB2BfEYKmsB6mts?=
 =?us-ascii?Q?VEGQXojvIUCLpGFc3EWiWDWRTxJKDwi3n+FHyItRjrllxq+mQG3zFkzaj1b8?=
 =?us-ascii?Q?pzOSce5j4VhF4Gg0GA8bGgNR3gRyHstkLty+8JiCGKKcv6ZZesLl5378XFgK?=
 =?us-ascii?Q?ZkbiXtATsigjdSmDfNMmYQZDsTSRoHL93B5hMPOaPKeMMQJaRYQRpSPVlmcf?=
 =?us-ascii?Q?c049kyaP0OvgzGkI5mFSUZ/UcbvChiKFzjHHgqAJychz082N/XJ4Mo2Wy7rv?=
 =?us-ascii?Q?3zRUNiqwUwrsOqggVgJ7vbU34U6fRoZs8R90mtJvJou0Q1wiVKqAmJRgm8pX?=
 =?us-ascii?Q?tfUhSv5m7rDjYEFLPAWkp3u0nPGVvUAVhcDyjFYLO6S6ijcRy0xukLkxq42s?=
 =?us-ascii?Q?6WQuaLE31NQhiVDNYT5jldicnLwV71JnwUCHQtAC+do2uefgsy2ecdPxgoVT?=
 =?us-ascii?Q?g0cUqSMRLp+JbaFWr6CxTc2kOhpJ1DWDdAW2NPWCm4JSZCHTF+lNFxg203G0?=
 =?us-ascii?Q?fgOUnE+CQeTPofJyw/0LeRBHyPG/wjYpmWJCF+NWnIMMY6nE34VGOUtxBmgX?=
 =?us-ascii?Q?7LLEmYpYwik9BKwJ71tQArRY9UCils5Xrc2MikH+OgTcyQdKCgAkWlEURDI5?=
 =?us-ascii?Q?dYXj7jWvRPxiVJCZCpXs9N2jADKBdILrQ6pms/MTorTcaA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+XTwfhOyatDZPx+TxozJTri6KZeHDFDmlwX+RcQP0rujPHdPc2KS/9+EyCvt?=
 =?us-ascii?Q?7U7kWdHxG7g//8kZQV10hAayMBko5B1YhxyfX6lI9YbCQx0zUhpOdg5w51Og?=
 =?us-ascii?Q?tzwYxlXcIjXKIMyfcyXNoXpNC4uloNvrGf6BNfmtoDpWg3sc1UIV2v3MJqSJ?=
 =?us-ascii?Q?p6lm0NdJ8ZPHuiviJcVzTSlM8aLn4c1QjvPXOxhOcu4C4izIzbvkl8w9O18I?=
 =?us-ascii?Q?FkWSJr95ZuwOGKyhBE+inbLcMzqupSuktWDziLWDGUT2VE6vNAw8X/A19jb4?=
 =?us-ascii?Q?xTjVGEPCdiMX1NaD2F3gH2xb8ujVxtMCsbakWZ1OrQuZRkAE3BrWWxB0Gn2G?=
 =?us-ascii?Q?h4VLm2NTKuz4tsftGCs5fFngivK7BGdtVLEadNrR2juCMXao8ybUD+hvB9ir?=
 =?us-ascii?Q?QEypFlooGFP5mpqsXMGdpJRhpcvg02SsRVDO2OGxhFodX0pI6YI0g1+OTN5j?=
 =?us-ascii?Q?6S3vL5wLj8xneyjHLFI7d4EhHV3TNOaCaDgKhaOQNS/aoO0yK/X+3tJJIBb/?=
 =?us-ascii?Q?Arq0HJo1rlUmcBFmCcLMIY2ulbA4y23MxdbeR1/YU5XnNvu5HpeG9OFt8fqA?=
 =?us-ascii?Q?ak4jQOAdq8VRsQUwBDpIi3COEsp6+8u9hIX/ZmW6yt75uKJEGLvhBISyqfM7?=
 =?us-ascii?Q?L/KtLvQxnTXxPd4XuCUrUaPSt9fmdHh/ozCh6jDRBHCorYzRvjtLjhU6PYE9?=
 =?us-ascii?Q?E+jwYZZDGvHq801ILCTm6afyilVcHFv78eyUb0Dj8TdtuijTC3Ye9wlYx/ur?=
 =?us-ascii?Q?61VD2VYsvfXKw5SmZKSL2rDOZM4nlO+TH7U4thbVq6mYAv/y/aEojDROHMR+?=
 =?us-ascii?Q?vS15vUwJE+9T3XXjljfoE9QVRGDtePylijaDaRiwkeBe+tYjYJea+YnVicS5?=
 =?us-ascii?Q?sDgbX3DniX8d3TXJ3MN+gqcenY8ViXVp1+FeL2sScb0WTS64uHw3+bTz8AwZ?=
 =?us-ascii?Q?83ozXG73reazjXexw6DSDhz74LjrhWUlQo0Kd4OeC7gzYi+JbabVN+F7xEUX?=
 =?us-ascii?Q?aVyZr+nFD2p9SN+TsDDypxLH7ts6iVT5AGm/EfpZ5lEOAcfExf9Yerq+oKkc?=
 =?us-ascii?Q?bKI+mYHoSE32m0v3vaBvChHHochozbRnZ50yADyvwrHNIfcKVmiVxIQreoYE?=
 =?us-ascii?Q?iQqy0evYVzAO5EivY0SJQFlg9X+l/snQMI7vR5CU09qUMNqv00qU4bDAKAzd?=
 =?us-ascii?Q?lS5BZ7YuPkcLc2+tQnzyCYaRmQaH/n6eQE4lNcvHfQzBgjBLcUst8BprTSMk?=
 =?us-ascii?Q?mdt3mDlaCJ04XJRXrHDuhasEAZ8f5zT/ndwOKexayj/szLcehJhbWEyfV0F2?=
 =?us-ascii?Q?DXUnxTHIhlRT5fTofsLWyg7gtUG6cAcv0UJNDHem6virICb4gTbMq8UA/UXS?=
 =?us-ascii?Q?j91rGOxLmZeJMSaIc+y47iAEP55PljZurG9w8teYgljNqZW09mVhF3fJ1qEO?=
 =?us-ascii?Q?5yOTT05DWMx5Ry3+A3Umn7TbZT9lXqL/30PSNmACGPjXb6CaTrfpbuSoyoII?=
 =?us-ascii?Q?fk6gWa+folN7xrC1S4YTDVASvAFinoMkjJ9eU9X6j68zcqLKgNPRhdcBZkIR?=
 =?us-ascii?Q?AZ9nN4brIS5hJT8dmd+C5cykMxZqmEq7wCxiRPSlXAu0aa8HQqBLUveEqxcn?=
 =?us-ascii?Q?5A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	B5gN8+tSHm+LkP7qank2XU0+dnF/459T2pTcvDyS+g2r3bl5KRjl8go58OFkX9IwmN9tOWTEGoebR39AzcKG4Hv8zZriAGDay6YHI8bjRdGNaxgYLwQqTQ8ajYE3nzi9+P9c61k/PxlF4RsXXfIZ/zoRhYHxypgpN1OKB/kXFyuTN/4l4W8OemJVkhkGiY34niAGuqSVTBtcpTNj+kCwLWAET8KDqnvcMw8yL88GWd9rvHuuSmRKuZQAdxYXqoUE5sjVkFbifyh/R0EO1ca0e9Ntp/pwRYOBZeDgpQ9WdLs79LOjDCWhn6KP51Ba9jHim0g0Zdb3yn+J3jZaev1BzImtjZP7rgKlVqtZK5CQMWD9cvGTbVAvu5FF2vq4B39b9twc9EG9mH7RHJb0wcOLqx5eJjqiylP3qhn2bybyAADbiJMZ4EffFyxv44RSpdez2aWWX6CjncKNJaBJCDzqXuLmiqjpJA8xTXIZDegAoP8RrRLEI/fAjhG8WARMoFP90o2BwzbddPkOLjbd5Vc0K8K0lyuFZ00CfYaFV8L1oalQEp2facT8OA28yeK5TI3eShAFI0zEPKKnpg7w5mXkk7MA+2UYx2+XRTnbIEIC7tw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e5a0238-f9da-422b-83d5-08dd0d5d4c5d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2024 14:27:32.3144
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +aLBZ8ibvyZlTu4l2eADfTrPqSyGnymAdqJtP2NGAR0MF79mTE5TMfLMWNhD8FsM+pl15vfiCFcYqwMbVmy+Z8ztDOJVa5G7+7qaAbKio9o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB5995
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-25_09,2024-11-25_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 adultscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411250122
X-Proofpoint-GUID: qEZxZVNDXFh7sP87PW7FXQc6OUgzpczh
X-Proofpoint-ORIG-GUID: qEZxZVNDXFh7sP87PW7FXQc6OUgzpczh

From: David Hildenbrand <david@redhat.com>

Let's register a RAM block notifier and react on remap notifications.
Simply re-apply the settings. Exit if something goes wrong.

Note: qemu_ram_remap() will not remap when RAM_PREALLOC is set. Could be
that hostmem is still missing to update that flag ...

Signed-off-by: David Hildenbrand <david@redhat.com>
Signed-off-by: William Roche <william.roche@oracle.com>
---
 backends/hostmem.c       | 34 ++++++++++++++++++++++++++++++++++
 include/sysemu/hostmem.h |  1 +
 2 files changed, 35 insertions(+)

diff --git a/backends/hostmem.c b/backends/hostmem.c
index bf85d716e5..863f6da11d 100644
--- a/backends/hostmem.c
+++ b/backends/hostmem.c
@@ -361,11 +361,37 @@ static void host_memory_backend_set_prealloc_threads(Object *obj, Visitor *v,
     backend->prealloc_threads = value;
 }
 
+static void host_memory_backend_ram_remapped(RAMBlockNotifier *n, void *host,
+                                             size_t offset, size_t size)
+{
+    HostMemoryBackend *backend = container_of(n, HostMemoryBackend,
+                                              ram_notifier);
+    Error *err = NULL;
+
+    if (!host_memory_backend_mr_inited(backend) ||
+        memory_region_get_ram_ptr(&backend->mr) != host) {
+        return;
+    }
+
+    host_memory_backend_apply_settings(backend, host + offset, size, &err);
+    if (err) {
+        /*
+         * If memory settings can't be successfully applied on remap,
+         * don't take the risk to continue without them.
+         */
+        error_report_err(err);
+        exit(1);
+    }
+}
+
 static void host_memory_backend_init(Object *obj)
 {
     HostMemoryBackend *backend = MEMORY_BACKEND(obj);
     MachineState *machine = MACHINE(qdev_get_machine());
 
+    backend->ram_notifier.ram_block_remapped = host_memory_backend_ram_remapped;
+    ram_block_notifier_add(&backend->ram_notifier);
+
     /* TODO: convert access to globals to compat properties */
     backend->merge = machine_mem_merge(machine);
     backend->dump = machine_dump_guest_core(machine);
@@ -379,6 +405,13 @@ static void host_memory_backend_post_init(Object *obj)
     object_apply_compat_props(obj);
 }
 
+static void host_memory_backend_finalize(Object *obj)
+{
+    HostMemoryBackend *backend = MEMORY_BACKEND(obj);
+
+    ram_block_notifier_remove(&backend->ram_notifier);
+}
+
 bool host_memory_backend_mr_inited(HostMemoryBackend *backend)
 {
     /*
@@ -595,6 +628,7 @@ static const TypeInfo host_memory_backend_info = {
     .instance_size = sizeof(HostMemoryBackend),
     .instance_init = host_memory_backend_init,
     .instance_post_init = host_memory_backend_post_init,
+    .instance_finalize = host_memory_backend_finalize,
     .interfaces = (InterfaceInfo[]) {
         { TYPE_USER_CREATABLE },
         { }
diff --git a/include/sysemu/hostmem.h b/include/sysemu/hostmem.h
index 67f45abe39..98309a9457 100644
--- a/include/sysemu/hostmem.h
+++ b/include/sysemu/hostmem.h
@@ -83,6 +83,7 @@ struct HostMemoryBackend {
     HostMemPolicy policy;
 
     MemoryRegion mr;
+    RAMBlockNotifier ram_notifier;
 };
 
 bool host_memory_backend_mr_inited(HostMemoryBackend *backend);
-- 
2.43.5


