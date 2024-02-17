Return-Path: <kvm+bounces-8945-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AA45858CDE
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 02:46:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CBD831F23BD2
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 01:46:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C2921C6A0;
	Sat, 17 Feb 2024 01:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Jgr0llvv";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ktXWG+7p"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D0921B7F6;
	Sat, 17 Feb 2024 01:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708134347; cv=fail; b=ZdOoxn9z1US2gkVJ1+V2MkdIY2EDJXxmQxU9wwYgb99DKDil743Uj450LGCyu0nx50Lz8zK3Uk2m7BFpDR7RClksFc5ctKanSpfT8djJdUvwZ0sU2ofBYQ11K5kVQhRjSGmrlfuWfTAeq4prKI1rc0aZ/Z+CbHTvUUjUj++wWXs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708134347; c=relaxed/simple;
	bh=3AanfXwCcCRuKM2GIenLmq2oA3pzCayeaFJ43Mk9bBk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=YmKedzCHQFLJwq3NHcvu+7F7l69hWHKDdDREG/1ovZIYk4ru6d4HAmgOIKeS+soJm5gj+zS8MPCzEwR7voqcM1dpbj+EppXbfzVfkpFgn1gOi/66J8LzSIMG0Gul0FIR/0d/99b+Qcd/7bS4volAGRc5amKf8QWQZxx6dyxGmNY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Jgr0llvv; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ktXWG+7p; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41GKDlC6012205;
	Sat, 17 Feb 2024 01:45:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=JbHoRGe+9E+2H7jveVYLl2WtcCZhNBo/Fe44pZRdaEs=;
 b=Jgr0llvvEcCKM7KQaO/T+cdyATawSZ818PRfOTaIQLjJNxy93DjmPpJmV9w8vrIQz47M
 S60xJor5OuyYQPFn4oLrDmyN0Xa9DtGVPtCNvhNkf2hqZsWLCiHSRwtZV3MZ5WgiAxkq
 Zk+SAZV9Tt765JwgFKShXhYhMzh0lbbcFCUrOGgTtZ9dnyMYJ7JS/JOxPnlPqCSvLZw7
 IsTr4j1C0ecBxZu1duumxPUHZ2WmtGFa3Nk9Uq7j9T5/82njOoE9DFtcBhOeAI/uMAMs
 2fo3VqOq3Ibkh3YEZkS6w0YJquJD36JUG96/TgU2NieotMNUjKonAp7FS3CWoVUoXqSo Bg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w9301pm42-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 17 Feb 2024 01:45:41 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41H1XBPC027277;
	Sat, 17 Feb 2024 01:45:41 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3wak83g7a9-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 17 Feb 2024 01:45:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O3FdcCb6SrxQfB8NjIVE9WPYSk5wTrC+q4xghojv2Ep+sK7YHZdhQ/Kj/Ywtp/UNnODFYQiEhaJv+Jf1Dr5HD4SL2vF5gvjy8rBo0xP+DV4a4OvE5yxDgWF0vRfOmQbiOr7KZoIAEoUk5cag0DfBpnDG2EDgqMCPBrvuS2VTkD7k9l8LA3jlwfWtBskYvLykrwC22ta93MYzB4kxGcu+piXdxt5AFyXR//FDPcj6Oe3tw6WmYpoAO230+tQkqZPoTMlxy9Anbf3YjgErFykFQDx4wgk0KPszmbLw1Kp49NtmG1iF6ksWsmWCbyuVk/dF5x5Oh50U1wPBM5wD3wLdPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JbHoRGe+9E+2H7jveVYLl2WtcCZhNBo/Fe44pZRdaEs=;
 b=iEWRUT9JOYFfNg/6i7KPikQE+Tw2vX/ZPYe4IdZ+iGRr4O5ugsCGo2j2EqGtquy89MPodkLW5yvU1iFiw8xWE30e9e3rKy32rICL67ee91BaXfY2mleADPiQ4pht6b7HZ0Xq1I2zU1qUAyDagjh6qPZWTzmimYOQNuoGn7RnKeAtSMdjL81UBubvHb13Cvic4xQuIyJj9TRMFH+uIM+VhNUgoMSY1c7++tSpUNudYJVjduduwuLaQRuzSnlnXZhxR2+34iWCKoKoXxxggkeXWmXhQWLJFIwJc+NtmdfxuvVC3A+Ttmj/8I2I0MVOg0uMGCaKWvkwIiGq+fT2xpF0Tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JbHoRGe+9E+2H7jveVYLl2WtcCZhNBo/Fe44pZRdaEs=;
 b=ktXWG+7p0F1T936yd3E6NI97l5AumVGMAMMv/CDklXVYiQsvVra8Qh+8gVXmIr3IYfz070LfQ25c65BIA/5Q+IQ3jYJd4YAuuZ+5WznF7CA5NdN5b4nSi2qftNijAH9jMglAyxNJ7uPIBtoDk3kyjCRcG49UFSKecvPwkeFZeXc=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by DS7PR10MB7299.namprd10.prod.outlook.com (2603:10b6:8:ea::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7292.31; Sat, 17 Feb 2024 01:45:39 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a1c5:b1ad:2955:e7a6]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a1c5:b1ad:2955:e7a6%5]) with mapi id 15.20.7292.029; Sat, 17 Feb 2024
 01:45:39 +0000
From: Dongli Zhang <dongli.zhang@oracle.com>
To: kvm@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] KVM: VMX: return early if msr_bitmap is not supported
Date: Fri, 16 Feb 2024 17:45:12 -0800
Message-Id: <20240217014513.7853-3-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240217014513.7853-1-dongli.zhang@oracle.com>
References: <20240217014513.7853-1-dongli.zhang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0256.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::21) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|DS7PR10MB7299:EE_
X-MS-Office365-Filtering-Correlation-Id: a7364534-8424-455f-6ba8-08dc2f5a2504
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	qAUUV98410fmRpnSkx7BeSPKt8nVPJoY9ZXEAu62ccGgr4hfSO8LM/DH1B/LRDZSVaIt4LNRGH56AhiX6Uixj5JXMtjjxeR03LR/86tlnbC/gjStt2ju78rChwRf5T/7UXBla2Spv92EHLjVM3fvVp+cb1cYPrkdOLfkCQY990bIkKlWKdogvNc+3Wsr6y4MeHoGs+n2C9XYuOJX5VEqPw64U9x35CymWz1fn4Ef28v8yitVwT3KLOrSNer3J3DzgQgRpdInAaUbIJpvVCujiAFVUj9V8shkW7ZGgujcH+zTNH3sm8basrSz5SvnNtjCYN8UiFCVUms29VXsr0l0xMj1TExmKeWrHxODH3d3S74aNAMFY75b4rvswgEbt7975LsYsfo5C8tUexPe7OZNVWN539dRL4QGt2eoluR6DP9dYl0DVzIwnwZ8MlQB0kuNiMwAKpl2tELeYMIZf+0PGzGfgtm6W8/NgmNKxlwPi2R84PwlUEp/g6eMecX/XRJR7suG2eMWxCablm21u7fTwNNS0lqZ13tQDLOc5Xwc5zZtQWY+OXsFmsUA/D4zlJGC
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(376002)(396003)(346002)(136003)(39860400002)(230922051799003)(186009)(451199024)(1800799012)(64100799003)(44832011)(5660300002)(2906002)(83380400001)(1076003)(8936002)(41300700001)(66476007)(4326008)(8676002)(66556008)(6916009)(478600001)(6666004)(66946007)(2616005)(316002)(26005)(6512007)(6506007)(6486002)(36756003)(86362001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?dAt5lRm34mCUxbUHE3RUWhRlem4Tw0zf9he/zDl5xqa0U9hx4S4CWdyU4xeX?=
 =?us-ascii?Q?lW04ut8v/tD2eIjf08A/kXmU55YdAgx1SIrlm20S5/GPLLrQp70cm8taIHUJ?=
 =?us-ascii?Q?Kw/yjhtgxrkXIBI629pla7IDlUq2B3h75m9mdr5vS12k/Zy/motiHpf1ME4/?=
 =?us-ascii?Q?tLghB0guf82qch95ZrCc3Vhu0PvKN7KZnTcS9TPoWo7+nXr1Dcl3A9DAczMd?=
 =?us-ascii?Q?f7wZkEh7EJIElvYVujrA+nKFS5HYYUvOpfpOG8fLkpdwMu0WxfHWUg4bpAWU?=
 =?us-ascii?Q?aXTnWIJG49XTStomEelLkJF1PXZSsxdf0KBr9yDgGgEiyX6KRBClgk0e1g6H?=
 =?us-ascii?Q?CxLR6Y5hH5k8ZTD8q14mZyMQB7zWwLYv452YbvCg8Rfqeso7wFH2iQJSj/In?=
 =?us-ascii?Q?lxiFdClI03Zd3lpZv/F6e7+x4uVXPWweTgKT+Ccq2ZjPmYNmA2nDJFHmsath?=
 =?us-ascii?Q?686aUYNk7H5wxwgxTJYgvncrsoqBmVNOuGU/k/I8g31pEqM41EjuPusmidQF?=
 =?us-ascii?Q?5pRHImQR5uXw6lQpIic/JMLOE/+qFY/vuLLMQ89qfHSj3unlvoWeVSv87jPb?=
 =?us-ascii?Q?FQ80oGs8QuY450QE5u3Bb1EgKJ2nxszosV8k4dL3+rGNZvW+K1FnIYlAVMbT?=
 =?us-ascii?Q?eytD9EHuTdnQkC/Tc48U/vDWpcJ2HcOfpM17qeQZH0jSjivrJjz9T9rvpAqh?=
 =?us-ascii?Q?Hrh0mle/UkwM/rVXabh/wGk3ZgAhAxpMWJsUs49saKG2VAWH6fHbVSWmYA83?=
 =?us-ascii?Q?SFrLI6wANcPL6qTYQu3S+DZhNfGe12WQyehVFqkwXPT90EWvMRSe3/tXKYEL?=
 =?us-ascii?Q?hTkMcffILPkTah6DbCJw7A39TZMK4LCkKr7BKlMowHqMWhgrf+EUyUdQE6Wv?=
 =?us-ascii?Q?q01DwfQhTnuUp0PBJYyLNsNsYzuKCnvs1rHuxY0I0sJpVABrL1kURlDq1N7q?=
 =?us-ascii?Q?WwcWrRkusbpXvpsHxJMd2ck9ujqDmPkweYP6EHxQ3IJUGhnCqW+MIH625PDp?=
 =?us-ascii?Q?tI/wBpi3Dz/UDsRQfVWENbUNabjbPT2vT31+D3x/vQQjobAe9iEbCiWtd6j5?=
 =?us-ascii?Q?8DS6Xhr4ZxHNrmQGoHEysiLWJzelPetdX6NdL/AispWK4PGR1C2cY6gZwcMT?=
 =?us-ascii?Q?l5mISxmgRnZxPMDQlCG5YeHwThgJDaU++Gtp3GpxZKGqVPmIsp5nw5L4eY+S?=
 =?us-ascii?Q?y4xolnucr1cdMyy/DLkGGtx3xgG9kGsdaDiSzzJYvGayBAopEBOQWgKHspH8?=
 =?us-ascii?Q?7VmrPhD4GomiQFVcrrErEEJgKvjvnHOwF0w+X302LpVhopZoD50JVG+08M+p?=
 =?us-ascii?Q?yvAhpx07xvaz8pEmpE3B0phqMLQ4WRwT/ZsIx1yr5dXH9EH2AiB/fWjmZnlW?=
 =?us-ascii?Q?Ut+xYxtmzXwEcos7RE2N9vb9UjfioiwFYg18cBqPNewiYA7b9S0wd/QUpw0i?=
 =?us-ascii?Q?iQVZ6kcuAnSK8LMTYXlT6Ono/8U6z8A/TGYEgDU9ICOJnsN7juP3F2FWXj0u?=
 =?us-ascii?Q?upEpPSA90NOKyQIfO9itq6bFZuGx5lg5BxynktSY5WkqV7sH+L/XXSYfgidB?=
 =?us-ascii?Q?+pFVxT8wtMnnsZ78kUFm+MrYpVCCjPJ3AxgeT1PP9bjfISIqySe2AI4naxPd?=
 =?us-ascii?Q?Jg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	7QTuhTiX5AITMXqdHyAwaPCq1Vxrkd/LXhySmzNLsGldmf1ybLFfED+l+hsTa9LLCudhWqj2SlhREJy9tmBRAmpa+r13k4scvVSuWUuKqAJjry+bT01xV/vA8MnXd8QyYcjFFVijaWZXoAopDvA3NGbU64pgX/KoaRwmWp5lPGdCclEfcV/zPhXL95BkQEm6kiwgXYOmFTI6DABOtunXwMIJeRHUzVkEOjw7jFSN0bwURUvjqGLT2VGViM2OIjUGztXbGjCcIcib04qH6tcDOviJfouJF3N4/iZUQPe1m8GVyFMuIPl/meci2FQNsHLeopF+KlC/DX/ZO+XkRseDx4eKKXF84CeWVFFUeLDgO//E/wonlOO8onL8JuR6/z9Ruf9ecdbCCsQBe6mZgzWxD+nFRRG8Yk+AaPUD6jdiM5UvQmBadpiPpXiTixN1RsL4HudgIeG1QIT30qcYDwg8enhmh5lAUGDejJGVGY/cLFKdVkC/9IyGk8sYRgsfzZy1I013zV8dTgcXmGXHc8rwDF1/wbQUOC3Z0c1hpQ8WLtoJShWoYkk66PwLffmDtgnxpblKQskgx875mlC8sdzZ2/D6BqaMquTMqvjeQiBz3SE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7364534-8424-455f-6ba8-08dc2f5a2504
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2024 01:45:39.5348
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VT0QoJDGLPda3sDJjxwVZA1/Kzd/KkYINM8+3tgsgigTaBDm5M39VhjPV82Mh7N7TxKKZuw3IufFjaJTGfLJjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7299
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-16_25,2024-02-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxscore=0 bulkscore=0 spamscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402170010
X-Proofpoint-GUID: R__Hif8hqIm6n2VrXGgr5y10utWjoPW9
X-Proofpoint-ORIG-GUID: R__Hif8hqIm6n2VrXGgr5y10utWjoPW9

The vmx_msr_filter_changed() may directly/indirectly calls only
vmx_enable_intercept_for_msr() or vmx_disable_intercept_for_msr(). Those
two functions may exit immediately if !cpu_has_vmx_msr_bitmap().

vmx_msr_filter_changed()
-> vmx_disable_intercept_for_msr()
-> pt_update_intercept_for_msr()
   -> vmx_set_intercept_for_msr()
      -> vmx_enable_intercept_for_msr()
      -> vmx_disable_intercept_for_msr()

Therefore, we exit early if !cpu_has_vmx_msr_bitmap().

Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
 arch/x86/kvm/vmx/vmx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 05319b74bd3d..5a866d3c2bc8 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4127,6 +4127,9 @@ static void vmx_msr_filter_changed(struct kvm_vcpu *vcpu)
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	u32 i;
 
+	if (!cpu_has_vmx_msr_bitmap())
+		return;
+
 	/*
 	 * Redo intercept permissions for MSRs that KVM is passing through to
 	 * the guest.  Disabling interception will check the new MSR filter and
-- 
2.34.1


