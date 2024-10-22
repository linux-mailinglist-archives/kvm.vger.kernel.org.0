Return-Path: <kvm+bounces-29447-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B0D19AB8E7
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 23:42:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F2462281C34
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 21:42:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B915204090;
	Tue, 22 Oct 2024 21:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EywQE6hM";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nsHXG88a"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB1720124B
	for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 21:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729632934; cv=fail; b=oL0piuM5TuizkfnJ1EGc/E7xNEP6g+Fw4wRIqCwaACMkUqGcWOofPbSzz1h/O/pON1nUuIrHzKAJ6TVQwMu1i22baJfoT3tPlFdnAZS6Cg3h/N7wbvR8Y4sQHq1EGj+4kFrybth0SE8CGjtQAljt5QsTXwtJmSl0WEc62VWHTW4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729632934; c=relaxed/simple;
	bh=OaOK0zfCm3t2D/iJ3gvR8OWqr3ttxYLJX05kPmI5LbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=POp31qfbQuFUtDKrXZ00sUXKqbuvVfvT0AtSECnF0gmesXb5c313UYLql1+DvHtBMg4rv7aW33HYXbb7a3FNeJpXJaG7vyy4yW29dIpxgLTz7OfP481EY2327gV24/3XhaChRWmAWwBPm/4NKYPH0dO6Xo9Fmvl8Bv2rI8CHdIE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=EywQE6hM; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=nsHXG88a; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49MLQeBQ016675;
	Tue, 22 Oct 2024 21:35:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=tI5kdNPntRMQNuLuBEJvdKTgE0oMkyr66BhPU/hYt6Y=; b=
	EywQE6hMZj1zfLej3nX8V2rjw83Yhbv3xJ1LiX6EbdnCh6iIet/ItsMPvLOrtXrh
	RuJQSi3ZCmwzhMrJchF9aSrKkJRRHVq/s5OaCnuSr82BHCgkrShgkQv43Oh9JiWZ
	4CGi4yjcWwE7SdRGMWdt6rg78n221Atnoy5rS5VPl+SZIW3yYyH+XoWr/Xh6KctL
	pdiYSO7J6VLoy4FQUi3cPsBmqiG7+K8QWuoLW92d1Y77rfpGCEBrqkFgYo7QAD/B
	zI5EuQT3v32S7l+eN4c9jgB2BO9J/U9E0eEX6r05tBqVCABsEzcgKWG1Ncfd1zGK
	XhzN5J4begRQ+dWRuYSraA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42cqv3dw6n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Oct 2024 21:35:20 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49MKi39u022663;
	Tue, 22 Oct 2024 21:35:19 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2043.outbound.protection.outlook.com [104.47.56.43])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42c8ew4vfk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Oct 2024 21:35:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eRpD5Jiqm2M30+xt10eV0cCFc1p9cSeDOzLVrAAoHjwISOQi0tvmkeY+fEjQJ9v3p/M8It1Owx+uleWgA+5XU601jxW+V+cvoVec0Y4YFOdr+dClI3L3DrgOdsB+scQh5Hgy7aM+GCoYLaz25OMTPfBOXKfxTKOIGtGDBcnh9R5CIsBZLFFU2vVEhz6nITQV7L4aUFXh/1XQ5eYM9BAk3U+18MnD+GVCGh0IG5UG21Svci8cZBBKdVVSIhRKyJzXChrZqEjR/D0s7GhdfEjjScxvKzpP8vfdfM9WtESLqSH7aOHyt1RLNEztcfB7cUZVVFK1Q9ltylbBkcz1mjN8Fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tI5kdNPntRMQNuLuBEJvdKTgE0oMkyr66BhPU/hYt6Y=;
 b=ijEWw/NdbC4Lqfw6KhxWk2oJJXcUGxvbyYTLgZmALTydzJm+z6AHw0GR+Vcck3FnbqQlAerSBh2D4pEOILLNj0GzT4GvpnJNPvSVHXaK//pQR5jIIB1QXM4IUsWKmCp47rzr5hLO9mwAy5fDIKLyrsRiW0tbvKmU5D3Zhhg2PXyiG5cSJU94Mm5LP3oIWAeWISwBtIvF0za5EsLfrpOCO0twhZGmZExCpEG5cP7p+tCQPTHsbmMk9c09YsO/p9jo4q/+bAc3dwDi7DMs9HrV5oQM//wz3yikUqGCh/oCPw233KcqiP03Va4oOPSpasMKVg/r3xlmbVb/H6Ys23oXaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tI5kdNPntRMQNuLuBEJvdKTgE0oMkyr66BhPU/hYt6Y=;
 b=nsHXG88al/Fp628RzJnPoYLWWfozhfKWN9azkHqMHZsTAU5vnV168pYGU9tpeP7fU89NuTvaCGDix2yRjM34UK3iIai5iADV2TZnumUm/RbOdfbBTz8VULtXxHHOjc2M5JI4n6VweErdsOcAb6zGgCxWetyR6FkBzQuvQX/janM=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by SA2PR10MB4809.namprd10.prod.outlook.com (2603:10b6:806:113::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.16; Tue, 22 Oct
 2024 21:35:17 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%4]) with mapi id 15.20.8069.027; Tue, 22 Oct 2024
 21:35:17 +0000
From: =?UTF-8?q?=E2=80=9CWilliam=20Roche?= <william.roche@oracle.com>
To: peterx@redhat.com, david@redhat.com, pbonzini@redhat.com,
        richard.henderson@linaro.org, philmd@linaro.org,
        peter.maydell@linaro.org, mtosatti@redhat.com, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: william.roche@oracle.com, joao.m.martins@oracle.com
Subject: [PATCH v1 4/4] accel/kvm: Report the loss of a large memory page
Date: Tue, 22 Oct 2024 21:35:03 +0000
Message-ID: <20241022213503.1189954-5-william.roche@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241022213503.1189954-1-william.roche@oracle.com>
References: <ZwalK7Dq_cf-EA_0@x1n>
 <20241022213503.1189954-1-william.roche@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0072.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::17) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|SA2PR10MB4809:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f3f7b29-874a-4850-e10d-08dcf2e16bcf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wgkbmYDWyfT7dA6PVL45rNeRIKLHrtUDMi7Df8Y88mFLq3QIfuu2NufNo2t8?=
 =?us-ascii?Q?Uo5jHd8RddWn6Ok++TGG8rH+SAMoNaojNi/37D0imfbGHj40Kp/pcxqZRLun?=
 =?us-ascii?Q?W63sckj0pphB2iK2MfYOwCgZfxP9pl1f4iPcAu9wd3BAdeVtHYNmrZXjxZ7n?=
 =?us-ascii?Q?YO5bq2DsH2UusTfpvIY8Tu303kYiHdUrXpQrPa/BRvv5qEnCmCWfefQVewbA?=
 =?us-ascii?Q?qRNVix7yfTUiT2sgj0hvrWdbvmYfTsOxBn4UOeSYxx6V245uc33rehopSusF?=
 =?us-ascii?Q?FBpyHQL6nmeS8XT9auqMkglXY6TXih70cbGskD4eYbrKr6gyrdOdMxb3+yTe?=
 =?us-ascii?Q?tk/wx97p21zPN8TwXtpjMzsbUEkXLNOQJPYEnjomZszje4s8dgJb/ggUs5Gf?=
 =?us-ascii?Q?gF9iUDYwFSYkMLaMiRzUgNPEur5zT9OJDYhBlXdsasP9dCCNz8khaaCW9TMq?=
 =?us-ascii?Q?IPKTI6knCv5oexdiS7Sc24BvuDKqSgfe8r+lHSp4YuhMXwHqaSifa+nZwc4D?=
 =?us-ascii?Q?pV3lCJ5c8GeYk6vGRPqURoKzswMy1KOtc0Q0fUiQpZJI8qONG98mR2OnM6ec?=
 =?us-ascii?Q?f4tiE47Dd6pCJJCtyS1y/6YGBuwtznaQhWMRDUajSQapTeitT8C+kNELs16/?=
 =?us-ascii?Q?/djV9ziYpNSj8a/5FEIe7L8n7WLmLTo0+VoHU96foMG1zbs4vT3tR0Pp3YKr?=
 =?us-ascii?Q?FIqhLnkcGWgYcsVF9V1EbuNFNZ3AoNAUbtFdL6sJwwjrqGrXu6bN7RH5gSOY?=
 =?us-ascii?Q?PkuwSRqctCVKu6GfVFnD1fRCypaCghuBWrVpdEQSQ/HEdA7KzXSWsJxs5M+E?=
 =?us-ascii?Q?R/Dy8eGIEcaNww26A6vSW4nGhPGLeYBhGJBOs4n3FNXqg85ZCghLnllWVyao?=
 =?us-ascii?Q?/jklIXQy0DAsABVuc5w9SuLsKpUjMjqmm9nB9d3Olf5UTYv+O8FW9Z/fa5EQ?=
 =?us-ascii?Q?s5ZLEZolIogWw8KWlBKt0cnpq1cEuw9q5z9BzEcJaze16slWrfEriw/MnBtT?=
 =?us-ascii?Q?OxTjKDQH0jowR9qEBMrEEFzrWnmtT9ORBJ4QV9wPBY/kzu+Y07YxXbB25pzB?=
 =?us-ascii?Q?b2NuuVs88CZLTKsHnkOPv1rzffVbbWm6KAGvWGjdvjX9DnZ1QjQmxsiF6mON?=
 =?us-ascii?Q?M8daD08Eh7UTpU113yr19wGzcHkb/YIan117iepq0OCr13VlC9WwvwJW5y2C?=
 =?us-ascii?Q?KtiIn+vLtglKaEcd986PtRnUCu0nSuVkb7UUDaPC0K4TipCvK4Q2oDS76Soh?=
 =?us-ascii?Q?o4nP3Hs4DAufvjZEjIh6FIykGSF7MMtsWL56oLBtzQ52cCe6ge8Q6GLALk6e?=
 =?us-ascii?Q?oYhu7lapBbcl4G2PcoL4epBGCfPbjZzY55aM+ZInkWPFz5aP2W95SJ5Jm54U?=
 =?us-ascii?Q?eJcDHOU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?x123bjovu5jVDClUllvJpCJUTE4sdL9IGnaRnxETRkJaFFaVjXh7GFAru2cR?=
 =?us-ascii?Q?XNT6AxdxpyjocKzTkzdEkU+LVnt+9AQh2x7z+/Wv0YwidBE9/KOaf6nFpOe7?=
 =?us-ascii?Q?IIWR/fwfqIKBbw2gIKTX0aFCwzRULjj4pe04Hci3LC5qEECchVgy8VnTMLLE?=
 =?us-ascii?Q?TxGMecjbysuTP4A2jdlO/D6wWR0oQSdo2kfas1wN5Ib4I5MAjLiN2nAgHcgJ?=
 =?us-ascii?Q?l6WU90rvON62L8DWoYntNez2+NsjGf7kgX8cGgGkvVJpLkR6zuj1zRSi5wTt?=
 =?us-ascii?Q?13cjpBkMJOo6ljIwzkpAtKtHdlrNH+uFS8ZUoEdp+rJ4BvYeh9+QiR0r6Iai?=
 =?us-ascii?Q?YizQZEMprFiM2pI9t/Ab5Le05Ix9FbNMrhbI92/oQlbUdm9paS71DSi2Fa2T?=
 =?us-ascii?Q?43SZjrz/TVumP4LDxZF9DSrtOpbC/0SavAP0mvZdudMvoSFzCm8EEWLlmekF?=
 =?us-ascii?Q?osnhU7xjEAxKRO2+MomMrHpg7fc/ZN8nesaqvFlqjrctyWNkGXz+5HDB5cfI?=
 =?us-ascii?Q?1nns9+tA1Rp1bQwWxhfQUOoJT6Oesyw0v1v4PY/EGxr2gXLEVsAd60CU3EYz?=
 =?us-ascii?Q?olukGze4uY2ODzxFPunBy98OkhT3eQg2cycZulih0x4GjUTjFCzuhL7kOqDV?=
 =?us-ascii?Q?tRcPid/7v1i1q6dXrlkSPEighC6xiCPAIeXUs9V3Fav4THLAfVhbu9NLOOFq?=
 =?us-ascii?Q?vFJileAgKL3/32ViMAQ4ZiJsu0vYcmi9LGPRg4rPPLFoPu/a5977QHyg3tu1?=
 =?us-ascii?Q?S3p/Rpylq1DLeMkOz0XM2e5SczG3oaoR3lzhlFD3qjfizH1CPyj8Tu4v/Yun?=
 =?us-ascii?Q?F0Tx2tzwulxvUTsVyS+8h6j8li9zaRM7LttRFszp1EPms/8/TemwAsmRdSmW?=
 =?us-ascii?Q?QH/yLxHkR9+auWJwU26uQtE9v+m1cuP2FWnlAec4oAP4CqbrhvhTkAssnluo?=
 =?us-ascii?Q?gs98a26itAByK4qnNZQeNSvVrCGem92wirL909RW697y770QEem5fx64lME3?=
 =?us-ascii?Q?dAZVi0OJsyQu1/owE0SNrfK+1I+qsFJLJm5vzp+38u4SwhrqbIrDLIgCeFQP?=
 =?us-ascii?Q?JUEpKl6m6D4l88bKciba2rvjTszdTGQ8y8UGcY/FQYkDJsR5RUuowaGh2BtY?=
 =?us-ascii?Q?qN11d3lo0CB++t2BTaglVgjkYYbEGKAokXNBWEBfgssL5szLhT6RnZ4ltjAy?=
 =?us-ascii?Q?rVzpwocpusAZt9fL6Uxwq9epPRNuYhjPH3oTs7+pUerTcFlCsVd757FKEmue?=
 =?us-ascii?Q?HOUvjZkHbK8zBzJgZBmjP6m3yPhW/SzUY4ivA9adya/0V6vQXODyg+189V5k?=
 =?us-ascii?Q?XAxEMB7QbvbvUIU7ceQhuQ1h3QmCl5y3K/0BnWK2KDJoSauL9mCQM9VBP1SC?=
 =?us-ascii?Q?6dqQM136NfJH9r5CAD1TsFC2ctYtCpvKESX8YLcprcBJsQtS8C2l3NEjMDin?=
 =?us-ascii?Q?X6pDXIZaqmvcl/nFov546NFJkpULPaAB74iUyp/j5wgF1vvczj0pjaQ/X3W9?=
 =?us-ascii?Q?ueeGwWLVb4RiDjU11hMWejOQbsukR8YriWmdybkYQa9xsF1ySj12JZk05Uj9?=
 =?us-ascii?Q?+HBVWGigJRykse40SabGCF5uPYWmXESwkhDS6Wqf+duxQvytAc960UvYb+1R?=
 =?us-ascii?Q?Cg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	kvQB+fSRTxLPRWCbkGWQwtdAAGDW5g2KenFAkdzcb31GBUhm/CJNgIRfUVPj3DqrbFARwM561qyZ4k5Ti2U11faMssXQXRyyCRaf6EaU0ewMYi5lDvJR1N6+QEkMQTysPUd+iTLSdeHA66omHOMdDMaWYByJpC8rgbKQ5cHpolUXVknCMvOhVlTmp3RD5QLAASNBNOH1TDzMQOtREY1oDPd2+CFX8X6GmNJOq5ASlvzI0gkMNGlEWWobl0Kt+xl/Mb82Hy08vT0dUEfsjOqTGmwNDvzLQLRj8FGgYtr702dj6SFqtrAORH2L5MmjQT0YHi/oB/iU2uWA+5vVfCUDRJ5T8/96z6mxrYumdOOh2hBi7KW5GCttEG2oRDqWPsc3MZjdO20B8p38bcjWovv+NMqWw9cqjFqsDBYwqGOMP96RqL+8AeR0IFbFcZ12v+VS32ci5FYzAzbKe+QPOprgBf+eLdNb/RgZ+3+dteqKdJMwoyiIeG+V4LkhjT0In2vJkZxGmeQASZqfmfuJvZp90YSEaFQxC+A9Mx6yuocKHdciLaLKSiR8W2AAHRKEoOQpudBihzARGGTMSLEt9pIvYcELi7KuG6VyWjKMsPERfZo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f3f7b29-874a-4850-e10d-08dcf2e16bcf
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2024 21:35:17.2391
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sFVdeSB4HVxEniajBtWFyqXgnfnBBryidToRk5YZkr8YRWzw+lRuBIWPeuUZfJtps9XSi/FQZxYA3+ZR9WeLoqevcJ1ouOernCppRzBEoKk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4809
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-22_23,2024-10-22_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 adultscore=0 mlxlogscore=999 spamscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410220140
X-Proofpoint-ORIG-GUID: ecCxOEelqQn7YK_WNp8pkcsNOeAQcmGu
X-Proofpoint-GUID: ecCxOEelqQn7YK_WNp8pkcsNOeAQcmGu

From: William Roche <william.roche@oracle.com>

On HW memory error, we need to report better what the impact of this
error is. So when an entire large page is impacted by an error (like the
hugetlbfs case), we give a warning message when this page is first hit:
Memory error: Loosing a large page (size: X) at QEMU addr Y and GUEST addr Z

Signed-off-by: William Roche <william.roche@oracle.com>
---
 accel/kvm/kvm-all.c      | 9 ++++++++-
 include/sysemu/kvm_int.h | 6 ++++--
 target/arm/kvm.c         | 2 +-
 target/i386/kvm/kvm.c    | 2 +-
 4 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 40117eefa7..bddaf1e981 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -1284,7 +1284,7 @@ static void kvm_unpoison_all(void *param)
     }
 }
 
-void kvm_hwpoison_page_add(ram_addr_t ram_addr, size_t sz)
+void kvm_hwpoison_page_add(ram_addr_t ram_addr, size_t sz, void *ha, hwaddr gpa)
 {
     HWPoisonPage *page;
 
@@ -1300,6 +1300,13 @@ void kvm_hwpoison_page_add(ram_addr_t ram_addr, size_t sz)
     page->ram_addr = ram_addr;
     page->page_size = sz;
     QLIST_INSERT_HEAD(&hwpoison_page_list, page, list);
+
+    if (sz > TARGET_PAGE_SIZE) {
+        gpa = ROUND_DOWN(gpa, sz);
+        ha = (void *)ROUND_DOWN((uint64_t)ha, sz);
+        warn_report("Memory error: Loosing a large page (size: %zu) "
+            "at QEMU addr %p and GUEST addr 0x%" HWADDR_PRIx, sz, ha, gpa);
+    }
 }
 
 bool kvm_hwpoisoned_mem(void)
diff --git a/include/sysemu/kvm_int.h b/include/sysemu/kvm_int.h
index d2160be0ae..af569380ca 100644
--- a/include/sysemu/kvm_int.h
+++ b/include/sysemu/kvm_int.h
@@ -177,12 +177,14 @@ void kvm_set_max_memslot_size(hwaddr max_slot_size);
  * kvm_hwpoison_page_add:
  *
  * Parameters:
- *  @ram_addr: the address in the RAM for the poisoned page
+ *  @addr: the address in the RAM for the poisoned page
  *  @sz: size of the poisoned page as reported by the kernel
+ *  @hva: host virtual address aka QEMU addr
+ *  @gpa: guest physical address aka GUEST addr
  *
  * Add a poisoned page to the list
  *
  * Return: None.
  */
-void kvm_hwpoison_page_add(ram_addr_t ram_addr, size_t sz);
+void kvm_hwpoison_page_add(ram_addr_t addr, size_t sz, void *hva, hwaddr gpa);
 #endif
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 11579e170b..f8eb553f7c 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -2363,7 +2363,7 @@ void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr, short addr_lsb)
             if (sz == TARGET_PAGE_SIZE) {
                 sz = qemu_ram_pagesize_from_host(addr);
             }
-            kvm_hwpoison_page_add(ram_addr, sz);
+            kvm_hwpoison_page_add(ram_addr, sz, addr, paddr);
             /*
              * If this is a BUS_MCEERR_AR, we know we have been called
              * synchronously from the vCPU thread, so we can easily
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 71e674bca0..34cfa8b764 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -757,7 +757,7 @@ void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr, short addr_lsb)
             if (sz == TARGET_PAGE_SIZE) {
                 sz = qemu_ram_pagesize_from_host(addr);
             }
-            kvm_hwpoison_page_add(ram_addr, sz);
+            kvm_hwpoison_page_add(ram_addr, sz, addr, paddr);
             kvm_mce_inject(cpu, paddr, code);
 
             /*
-- 
2.43.5


