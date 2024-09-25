Return-Path: <kvm+bounces-27505-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D725986989
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 01:26:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 52468286E18
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 23:26:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 516DA1A4B6F;
	Wed, 25 Sep 2024 23:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SSZOZzdI";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="tmTteepT"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B191A38E6;
	Wed, 25 Sep 2024 23:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727306734; cv=fail; b=hAOjWiDusGmyTatkPeG5zR84CwwCCemV7MhqHau9i49UQ00mArrzzMN3G05l53sPTwTSytPCH8VmiYa7Yt2VcGiVRYybil5JJO9vpNwEDNIw4Sy2EQSAvexHFOz5SSwrENu8MUkLg/TJncoDRA6Ndv8ANMxN1E6Rq72sDEFl3TI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727306734; c=relaxed/simple;
	bh=v3GaWP172XiLqd+rXefIhasC9+l2FDu3nt3uIc2bu4I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ttCtk16szYDOICNSfkaBE5E1g5Vs/FbjBJ/0Zvh4XxZWqHC3SdZhv5kIrcxYF27wjJi72gXC6pHirRZxdgSBEQNKadXBa8l7GS/ApEOI7dnIyT7Q/7cjLI+yIuVSpw0pIM06DF2PMfLeY8Lpkfc6bfZIDhoB3qOlrkI0XZv0Y1I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SSZOZzdI; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=tmTteepT; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48PLn2aA022983;
	Wed, 25 Sep 2024 23:24:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=z6wAIv17lLsyWur2fP5H/w7PeJyNJoRHHA9dyx1YnpM=; b=
	SSZOZzdIlF0LjE8XCMcfGyS5tCif3a6+4VcQxhUBL9+38P26+uB8S5thERexbi6O
	nzYXLh+K8B60fs2hsYdezfIsWHE8TlNpr9Z62aRVbo3DWPnjoiIbOCxVh1YhG+i0
	VP/Pddxr5musyLoG/Uyrj3douIT0FPES6/3g3haxdvxqbRsgmrsw069bQ5TYc2yR
	UpN09XMVrUV6XEGMAbbIcnVb4LfnKmklc/M2tj4NEoUF7JkAM/YeYFPI7ggeaire
	eMUWOPrqJCNz7sjJCNF/P304rjlh9eoTJPFGujkWUXKhkyyEeKfixNVIBhISKVJz
	i0Q4aIeEDVyTdCGPW/MgpA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41smr1bt0x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Sep 2024 23:24:50 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48PM4VhK025377;
	Wed, 25 Sep 2024 23:24:49 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2040.outbound.protection.outlook.com [104.47.56.40])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41smkbd4g0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Sep 2024 23:24:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eSkcxr8YeaxBql9F+jKmHt3t3gyPdMEa3hUDdeZiy0lLkeD3+CupznNTE24goZ46CUquOudgghzJFh1P+o6YzVFE7Jy/qRQuUxBssa8lpJFeRfA2UfMJ7DGZgPWU/sso5VgqWjEctjzmPS7KYVbgDjkHKoSfrsm27gkhH1vArnl6Zf2swTfswFKn0ZOqucBsHumDAKoByyT0nBWIR2GDPEVQM1zee7q6WAekqXM4BQCmTCGvllD+Tq18zfl1cQ6X/CT7du9mu4c5dlfCgiPKsCN+BsraA9/27vcHUy86BZ2OXsyLUVyDEz/PAIjIhsHJVL/3W+8hIes/cOCB8H3Gxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z6wAIv17lLsyWur2fP5H/w7PeJyNJoRHHA9dyx1YnpM=;
 b=kaBMNzRnrF8tsxyDuP/orvX3xe1KcCYDvW8ZlCgfwfS4R/yDDk9knu2HMi1dHJelJ3AB5odnNXwEWGU045zZtr51AAxNHkLFK2lNFs8H1I+JWuAyaX5IovoQpyc5Fbp9iQOPCubFFsXbfexpaerLj41/3Bavt4hgngoceTlbjL3rhJvqLCq2d4tinwg3T54Yf426CvzW48N7dFIEuc60tWjI8i1uagGiXTx73EthOyKBSI5UCeeF6A0pncoWHh5GWobiuo6kn2cgKbo5PS4uiHTQT7uIf/MH1C6HKa6KK6L5VHKeKZboU3psHKVhm+MY8ih9gokYmAUlyjks1mAvOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z6wAIv17lLsyWur2fP5H/w7PeJyNJoRHHA9dyx1YnpM=;
 b=tmTteepT7CnhvaXA/ZLDF02OJUyeFdqlzAVviOuzocaC+AqCa3SXJM0gpohVMmkEyyJgoVYqv8a2S8ebMxXMJB+e2QgUIncn5awE9skVDkGh5Nop8dgC4L4KOxALN5ybYwzkjqNWXvseZjIwrmRJzn8iNvyQq3qVKGPW8J/dz+U=
Received: from DM8PR10MB5416.namprd10.prod.outlook.com (2603:10b6:8:3f::19) by
 PH0PR10MB7008.namprd10.prod.outlook.com (2603:10b6:510:287::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.13; Wed, 25 Sep
 2024 23:24:46 +0000
Received: from DM8PR10MB5416.namprd10.prod.outlook.com
 ([fe80::e085:31f:84d1:e51a]) by DM8PR10MB5416.namprd10.prod.outlook.com
 ([fe80::e085:31f:84d1:e51a%5]) with mapi id 15.20.8005.010; Wed, 25 Sep 2024
 23:24:46 +0000
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
        misono.tomohiro@fujitsu.com, maobibo@loongson.cn,
        joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
        konrad.wilk@oracle.com
Subject: [PATCH v8 07/11] arm64: define TIF_POLLING_NRFLAG
Date: Wed, 25 Sep 2024 16:24:21 -0700
Message-Id: <20240925232425.2763385-8-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240925232425.2763385-1-ankur.a.arora@oracle.com>
References: <20240925232425.2763385-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW2PR16CA0052.namprd16.prod.outlook.com
 (2603:10b6:907:1::29) To DM8PR10MB5416.namprd10.prod.outlook.com
 (2603:10b6:8:3f::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR10MB5416:EE_|PH0PR10MB7008:EE_
X-MS-Office365-Filtering-Correlation-Id: af997ede-b3b3-47e6-dd68-08dcddb93df5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Sm2LqOT2PTbuNTN2NKrkL+cdmrrZUFzxuTxPL/8rrzuAndqhhlSpqaXEQOa9?=
 =?us-ascii?Q?kFgLePHZVOJyxVXOYDscDTMMz3TNDlJC5CGbsczOUr4Ayw6OE6FbxNF1N+4X?=
 =?us-ascii?Q?naCTXjPAZQIh0V+pCLgMnu+mQDi5VpS2L96mN4p3xNVkEnXNvT3MP9ffE2DE?=
 =?us-ascii?Q?qgUKkvorKxN9sJSkQL5YgNMmD6I49J87enmQmsnvLjRPNWXOK/Hv9xfGTJM3?=
 =?us-ascii?Q?reTBly9/zABAQqdkiLeGJZ7Kt3xozB4wXaBkRybCT1uDUAyU2ul5jeRxKy1S?=
 =?us-ascii?Q?eGHQR+BwU28oNPjAm8YDW5USHf7H79W8Ps4JpjsYdo/+IZDbYt7J5/5+MxIz?=
 =?us-ascii?Q?vDvUakVyI9rgZxMjb57uULzZ1iymk6W5ELnnfZffO0GOz56SwSTH+Vk2jq25?=
 =?us-ascii?Q?ep32tGgaK885klbUPyB58+Xvnah622okvWcV56wz8ynXNixuwh4l2rSrR2rJ?=
 =?us-ascii?Q?VT2v80c02TxnYADZhZJDGSt6YmkH9E9kQCfp+cA/nlXckjI93WB9Zcf/pqyT?=
 =?us-ascii?Q?4M7Sd/xmIiPwa+xRK//EoA/KvPXO6J8jJ7uKIfBZLS59MzVqAIvr4N7qr/J9?=
 =?us-ascii?Q?E0qriPxw15M6YITbxA/1pQywDtJcgVmlpJ33uieQHsjzcPWHcduNUW/ibioX?=
 =?us-ascii?Q?LufrxOFIn6TpSkg/z0amKe+6cIqqQ5bKlO87qqgSaF9onh/IMnHn8jhRenVH?=
 =?us-ascii?Q?cAbdW8QLfBsbjS1EvkPBcUDGYAmHjVE8eLEDo/JVDpuXPqSDrlQG0HZjyj2/?=
 =?us-ascii?Q?jeeJj4wBO+eTHEKPgPnODlxAmtpqybtT7qn3ZASyqEPKqPz7B7ePUKrdNyin?=
 =?us-ascii?Q?clJX2L3o1SpqMbPAeLahy5XnRme6ZzFFd4n19spsHZCDIo+AMNtJHypw+v51?=
 =?us-ascii?Q?NBw+PV/oQC+lE/vI13Z+M0lUlrVxqrnEYysO/UPMbKhG9gu/qI4m5WS4SDlL?=
 =?us-ascii?Q?JqUy9LUUSTSsmX0UIogVTIF2NHGqLIIPA/mb09coDp2u2RgoNb4sVFKqbNtv?=
 =?us-ascii?Q?20uC1uGmNcx890Oi8tJ5/N7y6XoS4zfv88GwMat8RsKzMnPGQx2h/kKxqvr2?=
 =?us-ascii?Q?RbbeQSXZisG86Ut6QMuAv1QE90iXYb2cnvlhKhZu7k6Wjn7IbDCD8ryBgoFW?=
 =?us-ascii?Q?malcC2fNIXx4GiW/saFC+iM6h6avj7aBcZKvWBdFIX2iWBAmsyuyzwdmPE0X?=
 =?us-ascii?Q?hjWVFaxUiFZvPfJak9IVXWBlDqKg+lNtIKtl//fo0RrgOXgMbYn1B3qhDex6?=
 =?us-ascii?Q?JyzxkqgCowz1bW1bhTEaUN/AuVA2cDDt3JxdSPa9oA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR10MB5416.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?P4kEJaj0CXe3j6M6EW8faeGYIYURItDaR0wLugK9GZv/Ql4p4faWkJBqmkla?=
 =?us-ascii?Q?eRJN5hGEdsEc0yj1enIs1Rt/WaHU6jhs6ladpIontmTU0JPHGVawJ4XgMQRi?=
 =?us-ascii?Q?RsHguhPxVig8keiedUnDzmz9ZKC13PMxRCm7d1D+HqqmTnqHjIDLhCty4XFC?=
 =?us-ascii?Q?3J16PrFTFunAHrjkaBecTljKiRKDt7VzTlYIgouhTnt+Mqe0lDpZVdCM0Mx8?=
 =?us-ascii?Q?9Wywc67HO3gRkrS1EMWYRmqGZNBnWK3xTUEJte1XKkl96FkVK3nmDqxOExnD?=
 =?us-ascii?Q?b84Fy3R3idrXgf6zjSqFkYAYXQ7mN0cqCGGGnQu4Q9t50kv0nnG1WCJmP80g?=
 =?us-ascii?Q?32n5eYrUDKrxWJvYelPHL01UlXfaKnTYRWzDYEg/ZogumvE4ui5G7vkngD7X?=
 =?us-ascii?Q?p3b1p4PtlX764S6OBcumA0vVuklYW/roAH12SXhsOqBXcZcfsp0lrHPu9A9g?=
 =?us-ascii?Q?ULOQcKaD0ud55yH2dEE+vLlTYSx8gicm3xMn0NPI3OYaVj4FmK/C3Qi8upQB?=
 =?us-ascii?Q?bmRchX8VSill+PbmVn+XkOzIaHQobOOtYLcQs7f6ojDTARFUitW8z5jqdHGL?=
 =?us-ascii?Q?DcohTJ8EHr6UmyIWtP8z2xy70MIFPQCbC7w6mxE+FOPtJ17PVJrZF4WzyURb?=
 =?us-ascii?Q?pQi9/UG5BPLuzZv0dhEbE5uBs8KtauZBF5n+9ogYGPB/kQQPaY+r59iEmv8W?=
 =?us-ascii?Q?+w3zJxrB1m3Aeis4YQZVHvrNLYzy3zih8I2NrsD2SO3++LhO9LN2UyEQ8bnj?=
 =?us-ascii?Q?R8j+lJRRO+wbYKyzaJLqfsycEOvvKvILDghprRnzNjMp1Slfdnapcua7liuV?=
 =?us-ascii?Q?OwTqEpv2BsdG+Lo2uHoBQOSWfnMvn+LcawQUA/1kMDefBihYTd5AEnxJ9hhe?=
 =?us-ascii?Q?p3UWbTFBpgLzojVd+ATpXCq8N02N49AIHdt/gCENV6bnbE01DyS5JbIzNGv0?=
 =?us-ascii?Q?TPBEx37kYJbY0DrSYfk8Z0laWwaS8X0LY29041MC18CKfq3HbzXnmPTC1kWM?=
 =?us-ascii?Q?nxLZQ8M3WkMTdSr2at8/CNLQ/37f+L6v/S/ROgDYlnTJCTb/qSFqQ1M57zka?=
 =?us-ascii?Q?4Mdn4v22LyDAf8FcrR19sICl/pBpJZDwuSIp7ec6NN45gZbIWNPDsw/PbiXR?=
 =?us-ascii?Q?femdRovCe7vWzFpWLiHb/OXyBHAwdgwcMngl9lhbNEIF+pLl4GGAHtpwoJ4u?=
 =?us-ascii?Q?NMgO1rd6dE1uty8biWyxrPdlPYvCUzN8fdUlXlij6Vt2jQNLCYBKx+LBXItt?=
 =?us-ascii?Q?mr/Z/F9W18bn+/RZe69s14DDv1qH/3YTFPtdz4FSqM8OC9JYOXPLmghiyTJu?=
 =?us-ascii?Q?Tsv0/zqgnqdMvOPKwZUulLcnaZSP0p0gKZAhsPZxOKdxpa22bN0ey/cyVWCg?=
 =?us-ascii?Q?tJaY6I9cfe7Z6/h/yb6IKoc+uI1/V+ujtRiK+g+prRn9ZIvF4hd1opq3M+pE?=
 =?us-ascii?Q?oySznFIXqNOzOf3G066U+bu8xwauSZtkY94aIgNE11y9f0ZAumKQih1eTk+m?=
 =?us-ascii?Q?AMldjEQbY7er0SH7PD56I1NBZPA4aeu5rdtn5I4Sz0qE2C01eRCrMDqo/MzW?=
 =?us-ascii?Q?3iPVKLWlb3JhL68Or3ZKeYSu7wD2uYv7Y3MHzibfIG5wl0DeDB4XqM8s9Ul2?=
 =?us-ascii?Q?TQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8JG11k07YtL0nWoQwsaIKKl5wZLqNmCdddvAw18Z5LiOXHR8RPJYU+bBbNkFTPqzMM/jNDS/9rOWDVsKenetjDQtUtwrjELpawGjiw30d0LrhyEUwTP2Zji+TRKZvaVRduQolLGQr6Rsk/N+/AaGDb5KuR8T0QE5AycYlYlqXca4tKYRyvuuggT/tkeMQA8jBxlVTWUv+ShFFvHpMd8BPB2Q7zakq5wIKodkSLv/z42qBB2OOtc8fvO8vFA4SOAQTjGvVaGGzHUkCQZ9a7gzLZmhG+6yCsdCpfK2U0wv/SvC1nk5C1a/0W6B81i2S3y485BcGHc1GZbRVL/AtrCYVJJpd1d+7ftouxcs9e2YRq/IWPHoW/AQ1PFKgkxZi1y8mDFXW0FxWC5yypzR1WDFEknzeUjNBN6xvkGgppGoQuwNH6x4X3V0XzJLS1TpWKk+ZFZaBCO9sgaj30cdx8uqcx26OEHXsWqLSFg8iOLTkI0P7PchMJQlDnU9R2xuFYLh83N+uDUn/F2BKzakeCMSPr/1CKp9Y5s+LPsNC+LMLbNPHPYGUL6Z0378bINwTmcnn1EZuFI5AlRYYhdGHpYnFIClh3CT5e2s4OY3p9Bp0Ns=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af997ede-b3b3-47e6-dd68-08dcddb93df5
X-MS-Exchange-CrossTenant-AuthSource: DM8PR10MB5416.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2024 23:24:45.9459
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xSMveraU0n2zT0Zas/bSIxQ8xuXV8+3ccyHSJ586xsTa2+h0J4i4tKUCYxtnZhEdWNmKpxVeoJV0HxgeUBAfbe/pDT9u+C1Y000tDAdf7r4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB7008
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-25_14,2024-09-25_02,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 mlxscore=0 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409250164
X-Proofpoint-ORIG-GUID: e107NlYvY_n_dBD9ToxvksLNCeJHXUCV
X-Proofpoint-GUID: e107NlYvY_n_dBD9ToxvksLNCeJHXUCV

From: Joao Martins <joao.m.martins@oracle.com>

Commit 842514849a61 ("arm64: Remove TIF_POLLING_NRFLAG") had removed
TIF_POLLING_NRFLAG because arm64 only supported non-polled idling via
cpu_do_idle().

To add support for polling via cpuidle-haltpoll, we want to use the
standard poll_idle() interface, which sets TIF_POLLING_NRFLAG while
polling.

Reuse the same bit to define TIF_POLLING_NRFLAG.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Mihai Carabas <mihai.carabas@oracle.com>
Reviewed-by: Christoph Lameter <cl@linux.com>
Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 arch/arm64/include/asm/thread_info.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
index 1114c1c3300a..5326cd583b01 100644
--- a/arch/arm64/include/asm/thread_info.h
+++ b/arch/arm64/include/asm/thread_info.h
@@ -69,6 +69,7 @@ void arch_setup_new_exec(void);
 #define TIF_SYSCALL_TRACEPOINT	10	/* syscall tracepoint for ftrace */
 #define TIF_SECCOMP		11	/* syscall secure computing */
 #define TIF_SYSCALL_EMU		12	/* syscall emulation active */
+#define TIF_POLLING_NRFLAG	16	/* set while polling in poll_idle() */
 #define TIF_MEMDIE		18	/* is terminating due to OOM killer */
 #define TIF_FREEZE		19
 #define TIF_RESTORE_SIGMASK	20
@@ -92,6 +93,7 @@ void arch_setup_new_exec(void);
 #define _TIF_SYSCALL_TRACEPOINT	(1 << TIF_SYSCALL_TRACEPOINT)
 #define _TIF_SECCOMP		(1 << TIF_SECCOMP)
 #define _TIF_SYSCALL_EMU	(1 << TIF_SYSCALL_EMU)
+#define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
 #define _TIF_UPROBE		(1 << TIF_UPROBE)
 #define _TIF_SINGLESTEP		(1 << TIF_SINGLESTEP)
 #define _TIF_32BIT		(1 << TIF_32BIT)
-- 
2.43.5


