Return-Path: <kvm+bounces-8946-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 749A3858CE0
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 02:46:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F09E81F23DE8
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 01:46:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9ADD01CAA2;
	Sat, 17 Feb 2024 01:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OmhnM+DK";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="XfnmnzYJ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0733F1BC2D;
	Sat, 17 Feb 2024 01:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708134347; cv=fail; b=MnLeY4AH7+VxdARN1+GkupgpG14kJ56URbnP6WSncnx91NpK5QluRCGQjKfLYQaWGid0VP4XFzFH1nPE0CdEHaLB770cP1cu63jjmAScq1ify1UEj9vWTAuRAjF02xGJWcrE1olFdgghgV3+deHnWHqcTFFDJdaU3g9gXQ8zdA0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708134347; c=relaxed/simple;
	bh=zzHV7aVlcM+mukjDROeCC8Fq6X883hhlDyF3jVHGvZU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PlWYiYdfiAeBbfFidHUdc8+z8zmYufkLyOgHYpORbE9gWJ4StnUczXWuzz+BriNXNsmEaT+w7BSQ5dKD/9CDhOu7HdQGwfzX1WtYrCB2KQETdsPWeHg9iQaL78W/k01hFhRxTvuWd4RH8hadBIqneqByPgBB/9ylpQKMe6LKyiU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=OmhnM+DK; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=XfnmnzYJ; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41H1jWZp027323;
	Sat, 17 Feb 2024 01:45:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-11-20; bh=WlEsLVVPKSQa9y4r/u4Iq7fa+0YuuvjUE/LmFL4oTEA=;
 b=OmhnM+DKTeMAsq/lqC2b1bj1bpKNaoImkFBBNDEIjfEKeMs7/C3JgI+Qip1FkYeLKnto
 Tk5aQlOhNbUobYnBYHJhymPIMdQAbKAtxlBP6iwXLmyx7bfFIOLOOJB8G/v9hWDdYjCo
 jfb1tbO6OKrZJEkafEFw81M7CQhtIAgTLcp2A/sJ9ghnj6DY+09oZ3P+KGUExrm5St3T
 z1rxciYtf7tmdg6qG01b4dbUUQF21nQS38n4ASLL7zWTKgW8bIvg3PC4u9lXtbT9jAnQ
 lx8II41OygpAnY63+rziyHQQHBU6Is2lOCTPCH8jQ1s7DhwzrP5rbarBxdyGaZ4dhZVr kA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wakd20010-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 17 Feb 2024 01:45:42 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41H1XBPB027277;
	Sat, 17 Feb 2024 01:45:40 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3wak83g7a9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 17 Feb 2024 01:45:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X44RbacEd4dAqTUL4CGFTW43w9sk6ooEJtOVIjR0CLwxRgF2k9PWkuYCajl6VOd7MD4+ixtk+MwH9gEVYQVrRSHrSHjH5XVeYq28ls69XODTEmSPpIWB7Af+CTaOVpkXMVgW3VbpoCBcmF5d2YArgdo5fSEvuCMBaOftTjzZT8ERVOIGjswZOGh6LmMXzU+lhriQ7YHkBgNx4k4h55Hy7kG1br/YvJdm0r75jYKoMvfnX4gaZhv3U05Q7GeoDNuNOGFhE6vvB9YCkreLV1uwH30hajI51sxDPDjf9vwDNZdCS8Wiz3+l8bjFnyOi0Wz7lrRK/9XqmTmfZK3ic/FQiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WlEsLVVPKSQa9y4r/u4Iq7fa+0YuuvjUE/LmFL4oTEA=;
 b=YdPHfcYzKJ5GCV7OGxAA/UvdpaXntwxPAezgJ2Bx9eladQM5kEIpq1LUpT5voVmqjd49ahoY9WSHxt5TceWf1PTiuE6a9UlENXv4SHBQ7IcKwEWJUwRBUQNRUjCFXmhsGCU4x0wIvY+AMKFo7x9BFsKlHKzv2aioDQhgAGcbK+NKe6sLCE+4A8xxfFN5inqLM7X+R60hQ8fRkJQTioCQkfSu/LUkVQ458Eppx7tmIRmATvLIV0f/VnCb9lsIvY+JvFauuiVCrTeLQHgKTAvv2DtRAKgTkDamRwF+9P9XSH+4gmA3T/oDc2KQrSphQJBOPixOA3FgafgD13aLG9bRpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WlEsLVVPKSQa9y4r/u4Iq7fa+0YuuvjUE/LmFL4oTEA=;
 b=XfnmnzYJUkbU4IXLrL6kj9RfU9x4ZBb3Fih5UKERF2XjrrhThix4rN/RloQ62ok4zNinlT31Wt1XLP0jBigcv7wiqauCLih1XBM4I/FiGLgQYF7PQFUviY4YoExTSlE+eT4yqmu/DQJuSCygREc/Sh6cW9cuAE0hArvW7nv595s=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by DS7PR10MB7299.namprd10.prod.outlook.com (2603:10b6:8:ea::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7292.31; Sat, 17 Feb 2024 01:45:38 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a1c5:b1ad:2955:e7a6]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a1c5:b1ad:2955:e7a6%5]) with mapi id 15.20.7292.029; Sat, 17 Feb 2024
 01:45:38 +0000
From: Dongli Zhang <dongli.zhang@oracle.com>
To: kvm@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] KVM: VMX: fix comment to add LBR to passthrough MSRs
Date: Fri, 16 Feb 2024 17:45:11 -0800
Message-Id: <20240217014513.7853-2-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240217014513.7853-1-dongli.zhang@oracle.com>
References: <20240217014513.7853-1-dongli.zhang@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR13CA0028.namprd13.prod.outlook.com
 (2603:10b6:208:160::41) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|DS7PR10MB7299:EE_
X-MS-Office365-Filtering-Correlation-Id: 351e1f5f-393a-4d60-0dd9-08dc2f5a2452
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	JYYNnRrJnLktV2wqz5qTaBsweOHFg0JHaK6oufyUv06c8urfc2hoGcL9Duu2K3bskNmFlWXXA00aDCwZ6GhRmINr7XuEKpA7INtmzkVpDeuXDzHdFJmQeHN1srL/Xv2yRLU55tXZP1qcbwKY48hMLgME7HxFBtQ+SzF4Nd2lIUyWEmmRs8JXZ1D9lB8Bir18erro0VyL0beaxbLQat17w3AwkNmO5IXT8ZHQHH3Ri7s4/hvGDXDiWv181R6NKmuwE6NQPjQlVF/UO/h23NjsXzHu9iLJmdv5At8IWEVAaCoNlrbAugq1sqauQwsXt745Bv1N80nq1BsIFjQiJDlcc+LVczea7GG1WaFHQJ4WJpgxb/0IOfgSkqrL7XEYgfJEfcAtMxyKVqgyXBKUP89w+NbZcpJ8p+wp4YIJzH9z7aL7iX8ai44pfvgNTerIS3ZZFvQckeL9rk/mf2kSg07aGb5T0vbu0fJevqCo2NGrWR8gNp9TNxoF6zdAC3eaIgnq8gYVizeDX8OOhIJ6ETxE51Ob6G+rABhCp2fh2XBsK1lPJD89RIGTOOWovqkIhHZV
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(376002)(396003)(346002)(136003)(39860400002)(230922051799003)(186009)(451199024)(1800799012)(64100799003)(44832011)(5660300002)(4744005)(2906002)(83380400001)(1076003)(8936002)(41300700001)(66476007)(4326008)(8676002)(66556008)(6916009)(478600001)(6666004)(66946007)(2616005)(316002)(26005)(6512007)(6506007)(6486002)(36756003)(86362001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?FkTPVfbufJn6bjA7Iysta18/ZVEyDs+8kG10QhM5aDtSvOKZDJ3j9uSdJfA5?=
 =?us-ascii?Q?XPAV8rrnVJQB8TTktsvabigjtgRLujlq3tMnfkzIKEX1e1L5Hr7JG1i710Ic?=
 =?us-ascii?Q?SQ1R00sQUAtfjwMEM74PWfNi20SsRuwtLA0yn3t29cMiM/KNam1l/j2SbwYe?=
 =?us-ascii?Q?ysUSo7Awu0edwsWjtM6xSnnHsGzSMoBRE9+CoDD+Matsy/bvAvoMxFusiSYr?=
 =?us-ascii?Q?u8ehjcdbImRGtQOH6zs0hVafdV/b+hwz3xjfU+zs+iSwHvQ3HK4LKEp16UK4?=
 =?us-ascii?Q?QcPTMB2lL6iE3UGFz0el7RprVj4ofqVh6/rIn+W2GsjsL8aRpG4YDNWDLc7Q?=
 =?us-ascii?Q?+6V6C4Upr/Kmm3nYHnY2IM7sq3okG7EN4I8Ucwuj2iNpz0y28HLGQQC27YTz?=
 =?us-ascii?Q?6fEBnWbutgwQZLfDZOGn+yV98vXlx6iUF5pExOA0JYHT4WcO0hn14gELT7Sq?=
 =?us-ascii?Q?Qx8+VPNL0LtLh2x/bXTxwnyHCskyjeawQcTms5fxLf5uXxyvLHBnAo0IEzOr?=
 =?us-ascii?Q?GDOxnnKb/8E3wcG7vxhO1zMmDtm06ff6FhFWNzlVX/yT6IXfESmfWNYsJCRm?=
 =?us-ascii?Q?2S0S0VNIJLa83lE6pbAn0FIZ7O7PevkS8deY/2NbKX5BBvQJK6qn41X02QgA?=
 =?us-ascii?Q?Vs3O9wWdT/FL2pexhHGwtN7Va0Qp1gxXSEDcwmHr+nqPvShmJtrzQLkh09eB?=
 =?us-ascii?Q?WCUE9b+vIvsNFCIeRdgRKvVuaKlZSFSNBercTq/+cBcjQF6BKHvg9yEGdjPq?=
 =?us-ascii?Q?aCblxJtqAKS2nFy/C49nIuVbEavT8nLhM2Z8mDbogrSOPSrc50oo9ciR1zUN?=
 =?us-ascii?Q?cOPEboUIzJ1swgHTvzKSvS48T92xCkf/SRKbLvGdcFg6Zr80XpStwUQo1g4q?=
 =?us-ascii?Q?323JvJv8UUdryR0wf6A8g+JWbyLlhJ2toRrYatMH5MjjIjDJOjDMz5KlTPGF?=
 =?us-ascii?Q?HzdeeJ+ru3KUHpefSY6XwWRcG4aZKzUAPWCXZjfQqHRLQzngZP9UTtmNfz2L?=
 =?us-ascii?Q?7rZ7QrTtgmieK6JRHOQtwks+L5vLlCE4+tmVGIqfyc8FIdXZJf6xjs10LAuQ?=
 =?us-ascii?Q?tnqKOSOIL09lUtpwOWoU4RHR7ex94Etlx0sbpSjfDEQKgUDTbykwpbO82uBG?=
 =?us-ascii?Q?l1MB3lvQOajOwF2dLjhVugTnEbkjcxKb2PrSp0iEPTPkEqDKsfeXTiL/tk/m?=
 =?us-ascii?Q?cUg6J1X9P7NBe0vnF0121AdvuaI/H24ZLtVBBy8nqeUleD2Y5nA5fWTDd02k?=
 =?us-ascii?Q?ERRCGPd/wm5HepNeK1oB/ZhVl2FUABlIn1uky9nNSgvQl90tnKXr1jf0n3nc?=
 =?us-ascii?Q?QbzAJ47tPiOEdouXkJ7ia1Mu4Ed5aNvgLIfMRWU9TCsye4vMCVpG+x5hwLKq?=
 =?us-ascii?Q?4WN0wmBKPrTnyvlK5FejNbzA+TMe7m3h7Zg9/wxOmZE7Z/D/sO2YYpnfaj8M?=
 =?us-ascii?Q?C0x4r9moG3GsTkWwA4ojtNix9uHU//dXkopsZ5W98efH1zuFhSC7hAd93A8f?=
 =?us-ascii?Q?4hRrLTOmNT3/iInVQVt2aPJYjpIgP0OosXHeSkGh/KmmoPtTCW9fnF3LQ8vB?=
 =?us-ascii?Q?TcAEKRCYOPHJmWlLjPA1eStrXB6MugVtV1wpkKjAVx1o2yyP1Q42scusRxd8?=
 =?us-ascii?Q?dA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	c13tUrq4C9Fui3V+4+U+/Vuob/90evGd7v6vgGRUA3YMw4nOA3Hw6efcQ6+fuUrZjYzTfA5D7pjHg2N1eKogbts4BJERSFAKapnEppq7UVtPRGU505yGyXvnC6VmX4UNTO5cfX+pgORGka5iqbtZlSs4hjJtCoPVj7KzsTlR99xT3d1EYjN1IDHKQ02MEbcmRGmN9lKGt523wOllI23k6/vZzljV0BUaCWrMGFEor/rI5XW1G+lcodfGjwxVn59Z9Uf6T3YcYncw5iHmco8Gp1W8R6VqRK02+9LHQnjOV2EgIeKYwwkcrQ0LFBFqzFlmVoUlyw8ucjQ8qkAWDUmiFXLPQQeuFHi9xizdsT5TDXvxWoZC4DsC0w1xHVKjedaImsUV0Q2334yepXyRb7ePdYhnfKKvPv3t3vJfI3zz4ATbfZIsHIb6zJGercgo7fP0t12yxwSQ2xW5jeFWL7pFtIgmrs/pTNBKGIzufE7olZ5Xmsm7isG79Yc6F+tQ0PKfuAE1zcVc1jecF45CgZAzUiMGC7hwuXGZqkmTKfPWGXIc2tFS4v921kEKVKcWEZthaYD/NygGqpeMDww40FkzDphZYDDdRPoToMNM7jYkZ60=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 351e1f5f-393a-4d60-0dd9-08dc2f5a2452
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2024 01:45:38.4580
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iwDDpNnIomcRy0txWuxNnH28BR9G5YFhszsPEgDXRHC9veUm5zbh+g70bRa/HjzkTlNkOp6e3FrIbvyuQWkhHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7299
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-16_25,2024-02-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxscore=0 bulkscore=0 spamscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402170010
X-Proofpoint-GUID: sHbBGwL6FLj9l6LsZ4DA3TEp2kOlK6wt
X-Proofpoint-ORIG-GUID: sHbBGwL6FLj9l6LsZ4DA3TEp2kOlK6wt

According to the is_valid_passthrough_msr(), the LBR MSRs are also
passthrough MSRs, since the commit 1b5ac3226a1a ("KVM: vmx/pmu:
Pass-through LBR msrs when the guest LBR event is ACTIVE").

Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
 arch/x86/kvm/vmx/vmx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d4e6625e0a9a..05319b74bd3d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -159,7 +159,7 @@ module_param(allow_smaller_maxphyaddr, bool, S_IRUGO);
 
 /*
  * List of MSRs that can be directly passed to the guest.
- * In addition to these x2apic and PT MSRs are handled specially.
+ * In addition to these x2apic, PT and LBR MSRs are handled specially.
  */
 static u32 vmx_possible_passthrough_msrs[MAX_POSSIBLE_PASSTHROUGH_MSRS] = {
 	MSR_IA32_SPEC_CTRL,
-- 
2.34.1


