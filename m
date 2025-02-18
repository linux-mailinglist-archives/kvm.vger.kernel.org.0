Return-Path: <kvm+bounces-38488-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BDA6A3AB00
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 22:34:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E15433A2F1C
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 21:34:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91EAA1D934D;
	Tue, 18 Feb 2025 21:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="M3nadEo+";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="hRwTdcJh"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE4CE1D86C7;
	Tue, 18 Feb 2025 21:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739914458; cv=fail; b=a4mKKPaVOQgdU8YkA3GiTrNoN3cFvnWqTwiXUtGOllecSHDkjiNNAso3DIWpOv2nkZvOJQFMLqTHZIgDNxpyoG6GZNeBEXpdyVbCP2wd201RuIElmf5PC4xLgPbgWqD9SHvUk304qfrzDYz6BxINZkr/1Kra4PM/hrKvNK++Dk8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739914458; c=relaxed/simple;
	bh=0y5kmeVUQseL6udD46frzmTo+uCr5U/D+XG5su19BNo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=G7MIGbUlklCAJ89ivRc6YJ2TSnrSlJcFFcpPYqGPW/cLiG+NTX+Cwv2+Jq0uxq6b19X2Qpcx6wcgbF8mWL9pJILtrnGXxFdbx+t+OVJmZFcVwp/ts/eAJiPK9jM3xwTESV3UyGHYy+Ty1YJvIHOuTnkz/G0Yxgoc7U6UwAFqg7A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=M3nadEo+; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=hRwTdcJh; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51ILMjwF020784;
	Tue, 18 Feb 2025 21:33:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=rOk5E/syjAxy97j2O68mpaiNZQJd9QiYVP4Qo3tqLi0=; b=
	M3nadEo+QFCHLOXuJAfAS1YAsCOS1WSKq0DpLmyl2kbqF9JEHXpopjFKKRZVaZ9n
	VBl8jHGV9x51QIUJrbRnMShC289cQzhMT4tDwHnQN5LEd/Dn8RuF7wLPg7XW2opI
	4CidYtpeIfhzB4NpywSC1HtEz1VtVUhBqVSmtsTyU4qgvEKVSuclmRUUDEahH4Zy
	CtF8uG6zFqEo8rYcedxfcNhvY7gsWKKxmrnpGYVls9Xa3PFmR2qZg1ME6ApyiP8y
	lgSic+L3pjADaqtMA6T0qAKeJKJapn0c3TMMTSkpUCFF8QeCw7XivdhuYaYYkf73
	M7FIibWD4LbwKiKYufBuyQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44w00m0aa2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Feb 2025 21:33:44 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51ILAp1F012061;
	Tue, 18 Feb 2025 21:33:43 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44w0b1mr3y-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Feb 2025 21:33:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZHRQbnjC9h8zB4n6y7OShPwcnaD56ioLvQWkbOvtFwpS91wNYhmouRPar9g/jQc2+Y6fMFWg1EMzETWoLsN0DyrAUSItPls4LANnkR4LwV8q+7LoQKWSMF3pW0si+uZRVh7yfqyW1UTIneedHH7Ue6S9YAFkf5dDcmTaK8EbD4u3zyh07TKa4ojuBZ9YwqvH7wsHpsqZJ7QLw2Bl2I4RNI6SHYpo6P044Pj8ORvewhXgBd4QVdZY/cWu3cr2vxgI4wNxf+vb9sm7euQBXNyUYwGc1PIVD6thcf89qnJHBPJHY4R+u9J4QBD82FINl6xeinXtNv1PCsG7iffRUTnK4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rOk5E/syjAxy97j2O68mpaiNZQJd9QiYVP4Qo3tqLi0=;
 b=CYFq5sCQlp2vuUeDyP+1sjCVz6hmtKQduxQqfnpCBE7n87qna8jiiR7CrJHD+ftsJFOuEYDvynASfxHY8gJoJLvjIXQkkKLtgRwwkdxWt2xM9TevROW4xgSyNchhMqm7norysW90dfAM/Mje4pUdVnnMW80A//uZK3BWe6+BRPGit2MTLgaTlpnQZVwS4LUQRT20EmfFpgcnqPI+mGRTudZAf2/63R/yhaqLe7jhj6WtBeJKx/PW2hQX/ZsyTu/mHVGtMHIDO9n5h2PH373ZYsREqKBRzPd2B9jeklA0W+iv125qOtUJRvGn8+NSpSPf783lMUlB1Qy84ytjL1PCEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rOk5E/syjAxy97j2O68mpaiNZQJd9QiYVP4Qo3tqLi0=;
 b=hRwTdcJh5rqd5HYrSv339zOcdKcLb0Ofo+rMNHoDkI5VB3RZl2HDEp6BrIUXpGlsCx0a9PxKK921Ew5CDhS9z7aXmOxVU7w7ylU/gkKTBC3Soebfiay43Ri6yLWd8qk05t1e9AYBuE9khIKDt3lPTiJNBL7Dxfnu09bVBXzACFY=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by IA0PR10MB7275.namprd10.prod.outlook.com (2603:10b6:208:3de::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.14; Tue, 18 Feb
 2025 21:33:40 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e%2]) with mapi id 15.20.8445.017; Tue, 18 Feb 2025
 21:33:40 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-pm@vger.kernel.org, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Cc: catalin.marinas@arm.com, will@kernel.org, x86@kernel.org,
        pbonzini@redhat.com, vkuznets@redhat.com, rafael@kernel.org,
        daniel.lezcano@linaro.org, peterz@infradead.org, arnd@arndb.de,
        lenb@kernel.org, mark.rutland@arm.com, harisokn@amazon.com,
        mtosatti@redhat.com, sudeep.holla@arm.com, cl@gentwo.org,
        maz@kernel.org, misono.tomohiro@fujitsu.com, maobibo@loongson.cn,
        zhenglifeng1@huawei.com, joao.m.martins@oracle.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
Subject: [PATCH v10 02/11] cpuidle: rename ARCH_HAS_CPU_RELAX to ARCH_HAS_OPTIMIZED_POLL
Date: Tue, 18 Feb 2025 13:33:28 -0800
Message-Id: <20250218213337.377987-3-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20250218213337.377987-1-ankur.a.arora@oracle.com>
References: <20250218213337.377987-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW2PR16CA0017.namprd16.prod.outlook.com (2603:10b6:907::30)
 To CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|IA0PR10MB7275:EE_
X-MS-Office365-Filtering-Correlation-Id: c90cbf6c-222c-4fce-0635-08dd5063e996
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?j/CDfvShizjRPioqEb8fxLnMn+tGz1Ab5675TbDQJfIUcNZJ0K1yN7FwDi30?=
 =?us-ascii?Q?dgWT5uc0bt4l1l1Z7gjUsZEhDf6TBDL00YHQVPRIZkoiGHGYaeQTelP+/XOF?=
 =?us-ascii?Q?4P66UhBVTRY++guw8Xl15IVWEQHUcrLU9mG7G/fVhsvRjXltsPFDv2n9VjXY?=
 =?us-ascii?Q?JdQP3Jh+QpM0U6EUxihgjnxwoRUwRBXkL7BTXWmDKccXvRSj8E/8YU5j+z+W?=
 =?us-ascii?Q?xFb14gXmkODrtuGD/FCh06t/Ntjq7Fgi1y1g24nXtf4TOz0ay1L6fp4fLKGD?=
 =?us-ascii?Q?WxV1N8UYNblKV4XbyEuqjqsGrPyMl1TqC+w6JX4AnlNZ10oKpLGSx/yWN2OH?=
 =?us-ascii?Q?T/538iA4GjizUWTXuyUO1EHQmb+tPLnmAGDyJvoNafsNTkofF8jbE6aXj9d2?=
 =?us-ascii?Q?61Kpqlm4RqO/qz3fTxWW42YFJ4pCsuHfYNVBvZhbvtOnyIYcy+HCTiKn2IuP?=
 =?us-ascii?Q?u9r9n6Wd8BuJWUr25/nxc+PRXPwi9eP6UlPzVi7Pk7ysxCpqpmsYqs6/Ggcp?=
 =?us-ascii?Q?Hvz06zSKUbbUt8FkbRAKvBcZEa49GTAqoJZeZkfDoKEYEgNrDEovOGs3DPSa?=
 =?us-ascii?Q?rsuhj0DKN2j20Lxzsjb2QUkR3j3K7uWEb54RzopNe+69GnirMnku+Wrcq2NY?=
 =?us-ascii?Q?30KGqmiJm/Oaky/V5YEsFQ7m/GfGhOZig0+clZOdUOzMT7/TSFsyZLejQmfM?=
 =?us-ascii?Q?sFmMWKEqrbRdvGTh9uWBzam99LDloDZz8CUjMJG1mRJSwyDJWNP5aXM3KKwf?=
 =?us-ascii?Q?kQZLiUIsTA0UNN216tCYmmWSiVkFTQcNG22PRzEIKvdmhLQUHNKicu5Os0z1?=
 =?us-ascii?Q?5E4Y0suTlXy0/CJuKyRl8PTDQS+ZzJX5r4tCA7F5hhfqRkUYo0KG6jdjrZ+e?=
 =?us-ascii?Q?WUS07IvQ3kTsqYkWh7/L2TWj6xuBhmFKMevrBs5ePbR21iDduEsOtM8xYpIn?=
 =?us-ascii?Q?bdBZ3zSUK+4NVN1rU/vF/T6ZvnebCISH6HSiZsNuZ0TcSaYFrTOBcJamMdRo?=
 =?us-ascii?Q?TIiqsKYMA7VrmamI7DEbej0N9Y/Mt0k+SSCJeiboMv6C5O3QA+9UlllWOGOM?=
 =?us-ascii?Q?U+dTmm6ZkuznAoGf/Nru7WNtLITnyBAf+MqLVYxnrcnw3crwv2hvt8uLB1g9?=
 =?us-ascii?Q?5IkoHIa0HE/HeXFrrr3W+JXZO+iyx9lMi78BcW4PIy7tDrDBtcdKIiXQD5Ov?=
 =?us-ascii?Q?ThM6LfcNewG11QRzmqKhQpENpO8Tu0JC1Kt95o/ukKLXCl2IC5qHLndPGl0T?=
 =?us-ascii?Q?r1Uf2oVQAZ/6vOnKhnOkrNrGGYR1dksZlngkUJBr69jRU1LNm0VLe13lKip8?=
 =?us-ascii?Q?rNVF8VqdshPcFiMyeQ0LtO7dEdiXiFIkkYrZSot++FimuRlNGFR3Hi2gJNM5?=
 =?us-ascii?Q?EXaOSUFutSMuiNvRB/T9vU/HP9nr?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XFGrDu2Vgk20bOPUrWhexpXHq2xV83WChYSj33fqen7Z7Y5tkZrItVMDtGij?=
 =?us-ascii?Q?p7WwZXGn2ACKgpONjLhaRTb5joZb++wB3Us385pZm7ZYwi4Th6v/581uiVWT?=
 =?us-ascii?Q?k0BnVgZtk4q55hfcQnupHYHC3FXUxSIjeKA4flLkgCc1ljXUggkr6YwXR2p5?=
 =?us-ascii?Q?J4S+7tIxYTnDVHRdguGtJr5xVJcg2yw5x4QCPkjh/b3s85U5AmNgVgA7yXG9?=
 =?us-ascii?Q?lz7hIwSSqkQJB6Mv5qb2yh4DKK2ftjATTwb3bL4zL8o/B+Dqpltc4y75j0fe?=
 =?us-ascii?Q?2pjeBgAX7X0qEi4vSKXTNZJp2eUkseFKAzRRw5Nmt76JWrkz/qohqmZYaUCZ?=
 =?us-ascii?Q?BK28ZOkQA+yDnuV2VfY7cG6ngYgGvL/3vZUzywEcv+TmS/33xUv96Js4haZY?=
 =?us-ascii?Q?tyCtkZAOojVglcdZPyRIXm+tMEmHyLgIq8PE220x4iejEyL7+aulbL2uKdZJ?=
 =?us-ascii?Q?Avm61DFTfU7lQ5uDvTrU1HadkcblDbVR6MoT6DJhEHcRwZlDFEFgNkVaISBA?=
 =?us-ascii?Q?O45cJ7aIk18GkEts0U/CegmxgeZap1V4nkdntvRWhcDZRA+qQkVvpUiRDZ51?=
 =?us-ascii?Q?1P1hI75lTxcViYbTCiEqDlG6oX2jk/J/PC5hTcG7igfRMLeQFHQZOzrs2mou?=
 =?us-ascii?Q?EdisE7d60zqMN95drbnaWACvaDOqL6SN4/nBwNhWpux6d05fQTtJrZSwtqnb?=
 =?us-ascii?Q?3a8q6Dih/uIVSW00L5+DVZk/NnGYJ060tZfgsUmCb1n9RohomzyZNxSA1Ioe?=
 =?us-ascii?Q?W4CQ/x495hltnQ+8llHX7xtWEYeNs1UBYlztzHO/7xzQq/5dqrJoHQD1w3s9?=
 =?us-ascii?Q?N2N/MvLKG1stGF82QCP/haUeu+AF1YAGugm/vj5U+r/64aPX/Yt/bzyhEVUY?=
 =?us-ascii?Q?6jB8orifSk8JBCcOGw+T6edv8XO0gUgiP3hmrNjxewUh0jLm0LLWE2KbIiUg?=
 =?us-ascii?Q?zH/5vjJdNT/YvG+XLK9JInmVza1JVv+bWhWJ9N0UJ4WJ89WPV2t/nT/7qS3A?=
 =?us-ascii?Q?/k1Rv6gW+UuSzZliMST9I+x3g4z7tQk7glIVBWEDNo7hK8WAc6X+Qduy4Feo?=
 =?us-ascii?Q?NWUmcutu345YIvLXGb0h/JMwcMeteKaexgMELxWbvgmKO2DAMxmW35Sf6QUO?=
 =?us-ascii?Q?Ky0WCkcS/cZfi67zvg72A6pK38800lHIfs1HIJMRyLed5CyVFUAl9JVPK6wO?=
 =?us-ascii?Q?6yBiANkG7/ALPcQf2QsBh7XiSxrSvCelCPKwGdA8MbUqFHvO8n3WSWqGPxOA?=
 =?us-ascii?Q?sS5iaPHiG/HULwf7nzjQ77fUPIisXTGqnrN+pVyrZ+vfVdA7TqTTYMio2ezV?=
 =?us-ascii?Q?tHdnH084jdt55ED0MFVyxXmZCofyYYi6E4+zLkH0cHUdJFsKDCNZwJxkfBgA?=
 =?us-ascii?Q?juLfDt1BgjatrQ9wCUygR4IWNW+cksFPggMXkpaX6MKoVXX/gWXnbw89o9rD?=
 =?us-ascii?Q?hAYORyBDQe3J5TFI1EABuVd4l4KEN4HRByiP/fKeODumAqXbVdHxcU1n/raY?=
 =?us-ascii?Q?BcMngk319ekEa0933o870ET2I7G785ALJRENsfWpbIaOel/hLrt7BwQUCuEA?=
 =?us-ascii?Q?L9zlAvTS2JgGVz5LSnwd/Njt7WRj5YMpGhsAKqCvBQ6PsODkrxIrLr7Q8wo6?=
 =?us-ascii?Q?ag=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8HHQ+auC07/9O/JK3JOT06WD1Tu1gbyTf/Ig4hxVxDhZCa7ZwYgS2/VX7nyRI9RlKrIZ0WgyIhsgHCoPdaUh1EnnYxDi59/Ck5vS7jHLy6JT/NVGyVmD9mCKbOqmv4zPwH6XmI38GElpPAvPPiLwei3+D892oYbuB+G5uJS9ZYpUQ08QwUJuD+5VJWspfI1Rs9LFf5MkBsFa3V3BakH8uMvQdPSUbwlx/g/qFjISg3s1NjjUcioJKiDCrUzrhOBsYKF5m6LA56+8BNJmKGh+PiLlk73ztcMyVg7e402FAkr2BCfMkIFkTKNAnk7ZWFgj3DlDGOkPdOljHZKK4tvhuFm0S7Dj7XqXZ3xypAnhI8tXDSB1gXn1cl9GksNC7248ZHZOHd7nkUlA/Y440h0KsZV0MjBu08bAZyGsKnTP4U/xdKn5vfzhbsFLL7vjIOrNwMAvxT7Iz0nDXmpwyWjkOjMC5mUF0N5zpeZMolS7yYf2R3CbZLR+5Ll8QlEp+gpEFdzbrOSvxtQ0f4a06apunABDipZjOBWQQCstXYGA5O1lN7VopRa88RfkClm2eDDe7bK9FzFrzG79JoILVWlx1xzdkhg1MEJn8ceRgLY3WQw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c90cbf6c-222c-4fce-0635-08dd5063e996
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2025 21:33:40.8644
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MbiLKHp0FpYctrSjhbfpkYKlWuaxMGSQt0KLqcYpqAYl0jn+ZQlc2VtLlwsUSOjZ36f60Z8UYYo3uexvpKpIvMAqs99bcn+X2W5Q/OXze7c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7275
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-18_10,2025-02-18_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 adultscore=0 malwarescore=0 suspectscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2502180144
X-Proofpoint-ORIG-GUID: r2pBP0LbY3iXUShCde-cuUMJM6WwGIYd
X-Proofpoint-GUID: r2pBP0LbY3iXUShCde-cuUMJM6WwGIYd

ARCH_HAS_CPU_RELAX is defined on architectures that provide an
primitive (via cpu_relax()) that can be used as part of a polling
mechanism -- one that would be cheaper than spinning in a tight
loop.

However, recent changes in poll_idle() mean that a higher level
primitive -- smp_cond_load_relaxed_timewait() is used for polling.
This would in-turn use cpu_relax() or an architecture specific
implementation. On ARM64 in particular this turns into a WFE which
waits on a store to a cacheline instead of a busy poll.

Accordingly condition the polling drivers on ARCH_HAS_OPTIMIZED_POLL
instead of ARCH_HAS_CPU_RELAX. While at it, make both intel-idle
and cpuidle-haltpoll, which depend on poll_idle() being available,
explicitly depend on ARCH_HAS_OPTIMIZED_POLL.

Suggested-by: Will Deacon <will@kernel.org>
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 arch/x86/Kconfig              | 2 +-
 drivers/acpi/processor_idle.c | 4 ++--
 drivers/cpuidle/Kconfig       | 2 +-
 drivers/cpuidle/Makefile      | 2 +-
 drivers/idle/Kconfig          | 1 +
 include/linux/cpuidle.h       | 2 +-
 6 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 9d7bd0ae48c4..d5f483957d45 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -381,7 +381,7 @@ config ARCH_MAY_HAVE_PC_FDC
 config GENERIC_CALIBRATE_DELAY
 	def_bool y
 
-config ARCH_HAS_CPU_RELAX
+config ARCH_HAS_OPTIMIZED_POLL
 	def_bool y
 
 config ARCH_HIBERNATION_POSSIBLE
diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 698897b29de2..778f0e053988 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -35,7 +35,7 @@
 #include <asm/cpu.h>
 #endif
 
-#define ACPI_IDLE_STATE_START	(IS_ENABLED(CONFIG_ARCH_HAS_CPU_RELAX) ? 1 : 0)
+#define ACPI_IDLE_STATE_START	(IS_ENABLED(CONFIG_ARCH_HAS_OPTIMIZED_POLL) ? 1 : 0)
 
 static unsigned int max_cstate __read_mostly = ACPI_PROCESSOR_MAX_POWER;
 module_param(max_cstate, uint, 0400);
@@ -779,7 +779,7 @@ static int acpi_processor_setup_cstates(struct acpi_processor *pr)
 	if (max_cstate == 0)
 		max_cstate = 1;
 
-	if (IS_ENABLED(CONFIG_ARCH_HAS_CPU_RELAX)) {
+	if (IS_ENABLED(CONFIG_ARCH_HAS_OPTIMIZED_POLL)) {
 		cpuidle_poll_state_init(drv);
 		count = 1;
 	} else {
diff --git a/drivers/cpuidle/Kconfig b/drivers/cpuidle/Kconfig
index cac5997dca50..75f6e176bbc8 100644
--- a/drivers/cpuidle/Kconfig
+++ b/drivers/cpuidle/Kconfig
@@ -73,7 +73,7 @@ endmenu
 
 config HALTPOLL_CPUIDLE
 	tristate "Halt poll cpuidle driver"
-	depends on X86 && KVM_GUEST
+	depends on X86 && KVM_GUEST && ARCH_HAS_OPTIMIZED_POLL
 	select CPU_IDLE_GOV_HALTPOLL
 	default y
 	help
diff --git a/drivers/cpuidle/Makefile b/drivers/cpuidle/Makefile
index d103342b7cfc..f29dfd1525b0 100644
--- a/drivers/cpuidle/Makefile
+++ b/drivers/cpuidle/Makefile
@@ -7,7 +7,7 @@ obj-y += cpuidle.o driver.o governor.o sysfs.o governors/
 obj-$(CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED) += coupled.o
 obj-$(CONFIG_DT_IDLE_STATES)		  += dt_idle_states.o
 obj-$(CONFIG_DT_IDLE_GENPD)		  += dt_idle_genpd.o
-obj-$(CONFIG_ARCH_HAS_CPU_RELAX)	  += poll_state.o
+obj-$(CONFIG_ARCH_HAS_OPTIMIZED_POLL)	  += poll_state.o
 obj-$(CONFIG_HALTPOLL_CPUIDLE)		  += cpuidle-haltpoll.o
 
 ##################################################################################
diff --git a/drivers/idle/Kconfig b/drivers/idle/Kconfig
index 6707d2539fc4..6f9b1d48fede 100644
--- a/drivers/idle/Kconfig
+++ b/drivers/idle/Kconfig
@@ -4,6 +4,7 @@ config INTEL_IDLE
 	depends on CPU_IDLE
 	depends on X86
 	depends on CPU_SUP_INTEL
+	depends on ARCH_HAS_OPTIMIZED_POLL
 	help
 	  Enable intel_idle, a cpuidle driver that includes knowledge of
 	  native Intel hardware idle features.  The acpi_idle driver
diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
index a9ee4fe55dcf..2ecc0907c467 100644
--- a/include/linux/cpuidle.h
+++ b/include/linux/cpuidle.h
@@ -275,7 +275,7 @@ static inline void cpuidle_coupled_parallel_barrier(struct cpuidle_device *dev,
 }
 #endif
 
-#if defined(CONFIG_CPU_IDLE) && defined(CONFIG_ARCH_HAS_CPU_RELAX)
+#if defined(CONFIG_CPU_IDLE) && defined(CONFIG_ARCH_HAS_OPTIMIZED_POLL)
 void cpuidle_poll_state_init(struct cpuidle_driver *drv);
 #else
 static inline void cpuidle_poll_state_init(struct cpuidle_driver *drv) {}
-- 
2.43.5


