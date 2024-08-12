Return-Path: <kvm+bounces-23889-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DFDD894F9A8
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 00:37:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 113751C2173E
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 22:37:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE83F197A9B;
	Mon, 12 Aug 2024 22:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YpocKdch";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="dzOJeNmv"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C2E016A955
	for <kvm@vger.kernel.org>; Mon, 12 Aug 2024 22:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723502226; cv=fail; b=Jq6KgGqLUcae6lb0Gily+SlsSIrdyLgrOs3VaWHw+T3zb7JTSUSUV8lVtEKmaB9/vcWvH9vUbFugPLyb8AdvC+NKB/wUPvxOdl3RppSxwNgDNHiBavrdNnAzTparipqKvpc1fr6uLD/tmdMjkTFcpyGQwIq7w/Olg0ymLZjUUm4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723502226; c=relaxed/simple;
	bh=oJuMT/2xKjqQ9RxqmuH1dnEaBQAthA/sksJsHAwZtbM=;
	h=References:From:To:Cc:Subject:In-reply-to:Date:Message-ID:
	 Content-Type:MIME-Version; b=h8G1gtkh2B57/peYNdWjDuyHCKUXf0C+5JIQNocAjUNwGcyUdTLIEZA6X12XwgDD0Yrwp9onMee6Mgjjfd/HlJBV+sj/iYyodcBp81gx9gMKXGn3w1lbD//0zF6XIXGwsZNnrkla9vV8CtxsnTt9cNyuOTHOyqILeKkTG9mEMmE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YpocKdch; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=dzOJeNmv; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47CL7I0q017229;
	Mon, 12 Aug 2024 22:36:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	references:from:to:cc:subject:in-reply-to:date:message-id
	:content-type:mime-version; s=corp-2023-11-20; bh=oJuMT/2xKjqQ9R
	xqmuH1dnEaBQAthA/sksJsHAwZtbM=; b=YpocKdch4SmTJJ6BIiWvSQCeT6yHQu
	O/CpyW8NriP4keaKAugYXthORktsfYYPeLxITRPMUUITQMfDeOYTlXOzYqfpfZdN
	p1G/0hOykPOT1igmw8P9MHvxnE3/+nxqCbw/D9M3kNyrsbL3aWZRpHzF94Gj9bI2
	OpG5e7uW+6sGIpB098uDZrHFt99HpOO6G9qMbIdBlylQplQO2ywQ8M+1Ozov1TwM
	4Gi91XgpEC59BI/Ify03Qy94DtgNtDUmMtY51DvrzyVVaV2muAhkIIo6mHs5sULg
	dB2UjbpW7BVd2SonAjJs1+Hm3mxIU9I9lUE8fCE1AvWcwv0Z9uAC1zrg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40wy4bcs9w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 12 Aug 2024 22:36:06 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 47CM3AEr020945;
	Mon, 12 Aug 2024 22:36:05 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2043.outbound.protection.outlook.com [104.47.74.43])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 40wxne9drp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 12 Aug 2024 22:36:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R1rJ8MCMUTHwxDqeerUbEKkkK+i0KjNx+t4hEpSSZQEVivwQ3CqLb0GBYq5mXLeTjTcp72k4dOiizBefoVChbjC4m5Nf69iewzAUI1SdzzPtk/TEuxkW5WQ5/neSMJcpcaQJcj+47s2tNuTFwiiObi2DYOPw3v0PmqCgAXt0+dZHusKK1hqr20+3gO3ymE4JlTfI8TWETLB1jp5kOL2endUfApe6j+Zj/s4mbCysj7IVgVcX2acTnWk6iFB4Is2lXLCH0W4SKbxWX5j+hsSleBqs/Z/KI3Is/VY+RmZvg6a8N/k50CMFm5cl/+7lUJBPF1HVbJFQa1jkyJ76zds1gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oJuMT/2xKjqQ9RxqmuH1dnEaBQAthA/sksJsHAwZtbM=;
 b=tVAutk9AjqFCKr4elgfhKpagnAgJs2CcguOgR69Z2eiyI1Gp/jG01L9hlyHvj5AwiEdl70CMGzSEtj8N0ZB5bxXsKgaW/Yf/qVgYRFCVIg0I829Mq/PxkItZgeCsTkIhEHdR9F2TBkicDDvm7VkcBnOE91vmnyNJ6e+W375PAOGSuJUroxtceL5Ex7arnaPfV7U2XqkJPC+a1aj+AAKR+p7riJiZ8aapVkpxQ3IOVhcL+Qnm7MDRJmcHTMPlPyEIK+YViggFXxSFIWb5xdnDUn3UYwuCLrLKZg+YNxoUtTZ8QXIQyuNKoZFJVS3iRqECPndIbwLWB6Cu+/bRB44zSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oJuMT/2xKjqQ9RxqmuH1dnEaBQAthA/sksJsHAwZtbM=;
 b=dzOJeNmvcIo5ovocw6CyTCYBm/0QfnUlha8yaNoI5LQhieKhyRSANBXa9r6wSZfntC9B6JAUo6+MzuJjiY5mERGP33wM/8b2Y0lUB6bpEQLkRoIs7HBXQltKwAPmTLzZjVZg7kHP+eTVZ5wgf+rnM1/kdSzOKVaL3otpimtH+ss=
Received: from DM8PR10MB5416.namprd10.prod.outlook.com (2603:10b6:8:3f::19) by
 SJ0PR10MB5718.namprd10.prod.outlook.com (2603:10b6:a03:3ed::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.13; Mon, 12 Aug
 2024 22:36:02 +0000
Received: from DM8PR10MB5416.namprd10.prod.outlook.com
 ([fe80::e085:31f:84d1:e51a]) by DM8PR10MB5416.namprd10.prod.outlook.com
 ([fe80::e085:31f:84d1:e51a%4]) with mapi id 15.20.7875.012; Mon, 12 Aug 2024
 22:36:02 +0000
References: <20240726201332.626395-1-ankur.a.arora@oracle.com>
 <20240726202134.627514-1-ankur.a.arora@oracle.com>
 <20240726202134.627514-5-ankur.a.arora@oracle.com>
 <5bbbba0e-b4c0-eb8b-a7f1-8483847e0397@gentwo.org>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: "Christoph Lameter (Ampere)" <cl@gentwo.org>
Cc: Ankur Arora <ankur.a.arora@oracle.com>, kvm@vger.kernel.org,
        catalin.marinas@arm.com, will@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, pbonzini@redhat.com,
        wanpengli@tencent.com, vkuznets@redhat.com, rafael@kernel.org,
        daniel.lezcano@linaro.org, peterz@infradead.org, arnd@arndb.de,
        lenb@kernel.org, mark.rutland@arm.com, harisokn@amazon.com,
        mtosatti@redhat.com, sudeep.holla@arm.com, misono.tomohiro@fujitsu.com,
        joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
        konrad.wilk@oracle.com
Subject: Re: [PATCH v6 07/10] arm64: define TIF_POLLING_NRFLAG
In-reply-to: <5bbbba0e-b4c0-eb8b-a7f1-8483847e0397@gentwo.org>
Date: Mon, 12 Aug 2024 15:35:59 -0700
Message-ID: <878qx1s71s.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0499.namprd03.prod.outlook.com
 (2603:10b6:408:130::24) To DM8PR10MB5416.namprd10.prod.outlook.com
 (2603:10b6:8:3f::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR10MB5416:EE_|SJ0PR10MB5718:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d8ee78b-4704-4bd6-e391-08dcbb1f252c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pXBGNHGa+iyNHvUUEeTyEyrlsMvLmlqaTSRy4R2DholGLdb5eM1d13rEXgvF?=
 =?us-ascii?Q?ZwZ1IwOsYv38FScjSyDym9vjgTD7Jsy5Ud05g6/obun+Fv2QuBBJrwYOFxqz?=
 =?us-ascii?Q?HeNyRP83O4TUoM+ZqpDijpOc7rk++6rw4ALcPDomjDUGnXbH+3WZlAO8jWtr?=
 =?us-ascii?Q?ASo0mr9veN65m51i4JgJKxe8gcmr1b9RxL/sQ/BqT12C5FdkdXAUPeJAAMAX?=
 =?us-ascii?Q?BiUodl/ENOiTd2oT0qY4JcTmD2o0nDN0qWQbZpdNiSYuqYJSAwR9RP/JTUJJ?=
 =?us-ascii?Q?Aog8GoUHkEIXTMR5THRQz9Bzm54aerfStwTY0H83FVzzBCX0gubthr2RKinc?=
 =?us-ascii?Q?Bq8P6odkT2RyUxffzrkQjHbIW6CJlA9iF6do5OTBzxB5oZ/1xK27aNHqX3WU?=
 =?us-ascii?Q?lYJVhqW6vn3YltRwYs2yypEjS2PFoaNG7/F3TcuaskNMdt0T7w+RgMKy44BE?=
 =?us-ascii?Q?DM3JVJjNC6G/e+23prVSradMSznwhqShRAdfRF2Dum8RruKDeSWhbeNjvzl0?=
 =?us-ascii?Q?URbAguCdjffW32uPtqrhHPP6MTHKSLsMmLIvKsQDcU1/YnsQPVB34rz0KEeb?=
 =?us-ascii?Q?atAMHu21zrqNjXnkDJnaG2AcJ3C3cu5pnAG95wDM3RihXMXH5Vh98Dbh2M1e?=
 =?us-ascii?Q?K7kqLWPSD2LFr8BQFBu7mYdnSoSkZCx2FEOkWGLIaoSqsVeWJlAcEdN5+k3I?=
 =?us-ascii?Q?sSNqXHgLxrdYQjWx5HTWEDpgZRdC79LgwCEHmP3GCRVMWW7irRrNlb9qlv6F?=
 =?us-ascii?Q?IuqHyRdUzqT6ZSXHnPRZTnQR1CnG/2TWgmHt8s8pHtbeutyroCzd+wbYEx3E?=
 =?us-ascii?Q?bE/VguSBLw3DPnWCU138JFAjGih6wsUChNZmtlOO8KGgODGvkaEclnPGAJbY?=
 =?us-ascii?Q?idUN0FkJAl55+5/9fDEyhAaxNUefnrLtaggS7RhvNCJIq66ptaQsHVP93z7G?=
 =?us-ascii?Q?1Zp7ojqIEAyJRWRjIQhsFOC2YvCXZ1Qm6uyttpIuGT4SHjUZEQ5s6ywA026g?=
 =?us-ascii?Q?8X+wuNEeG8Txut95dkKXbkPTkqndBccviJZ9bOsClWaDnrfHYi8ANjdkvDfh?=
 =?us-ascii?Q?ENc0FROvu3IOe0UqLvNejSI50y2MZ07rZhMorKXVGiW2ZnKhoVdh8dhm52Mx?=
 =?us-ascii?Q?j1hINQr3J0Qmg5ZXKZL585uMWt1e+jqWLC9dlrFRaT8tt0/OUJ1qkWRqVCnW?=
 =?us-ascii?Q?bP5GjLPhVY6AAf4PAupF8BwOoZdJAb3zURZI5BgyBm9RggQTayFe/Y18pJls?=
 =?us-ascii?Q?HI331PBxFwjgCuD0UqIIorKl4pX0qp+WDFQscxWDRUki6cXGwlwVCf77mOOZ?=
 =?us-ascii?Q?bDf1mku+/7vI3UvN5VSCCjADZj4BDXTq1pcV845adBg9bg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR10MB5416.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5EObNE3YXHtzRGCNT+bnAErpxJ1HgcP5Bm19CJgeu/sCXJrBChJzTagsns6S?=
 =?us-ascii?Q?6YcgelTABnCbyme86KeRJTlh1heii2w3iYU3UB++tNxc4TVBFP7dxd8TCvCT?=
 =?us-ascii?Q?pzFtPj1bzn79wjXW3oW1oH1vzrMIXHPBp4dy27lO5aVGFJ8VcUyQDkNhiNbZ?=
 =?us-ascii?Q?kxFJ7sztSXARHShxZ23nm/OaM6WlvavrsXvmI+r6aZfLwsYs/6ipMlT//Owm?=
 =?us-ascii?Q?SR16N6+NrM1pskL262GdamSlfVwTJ+57XfYO6ODSP+6F43hHU5cLQ7QjBxoL?=
 =?us-ascii?Q?5ZpJGFqX9JFSMT5rVNUuBswFnv+D5EAhUwD9FW5Rdg4BXUaPSftPO44gOLAg?=
 =?us-ascii?Q?cicxCYnOpaxQ6Q4juG/SCFd5KlXY60iFuIWaMpC9DXbAbO/Vh0vDpMSewA1W?=
 =?us-ascii?Q?m4GVuw6+czS9FAxeBP8IR+JaPZw+8s95DxqzLzxFHXKRgtAOAoIkqmPB8iOw?=
 =?us-ascii?Q?O/4z8MbEZkD5Josggy/4fQCtgdF7ltFFokELyBnW06v/TKD9gNIxEHBOwaw2?=
 =?us-ascii?Q?ms89Zz+moIaxKWpPTb7eLsM0KfcusEFyJuVZmUWhDZMYciTYj3jTmZ7P+VLz?=
 =?us-ascii?Q?fA3zXh0mXI70/pg0u2Ik0pqLbRcrgRQ96hE9tWJyahxT2z6XQJYkXBwBwZdE?=
 =?us-ascii?Q?rlx7E4lQBA0o7STZoGK89W8NcJXaywHu85KvE2TDkGobMqx71JgzPPwHzSba?=
 =?us-ascii?Q?EVfuEKi2uJKHulsYxLNXlG036c8BDOAZGXhbfvvVs1vqzT9G1N/dBZRycl33?=
 =?us-ascii?Q?6897sePiIl5SypP7YYveqkbTweWbcNBVrGTjJ39iHNkFvwTW8sBhwbsBR7bR?=
 =?us-ascii?Q?HgDZCbcxhoVR8mMhnmC+s2LMdSko2w4h34aN/gwU/th56+leIFPVM7kjxRFQ?=
 =?us-ascii?Q?AB1I4wRvetN5royK/Sa/9os0s8uV4/I1WSFCB1sAum3SlwmVfrWlySFXTSrA?=
 =?us-ascii?Q?/1II/jvGHEhQtrRLFvKl+7QndgwpsR28yut9kpld7KhdipI/SCnJaumv3TE9?=
 =?us-ascii?Q?yMUryxoLXzD7/ZdcTurwfNbMo1y3luuN3tBo9QnbXiZEY7LR46y4r5EptL7J?=
 =?us-ascii?Q?oDCOLwxG2Jo9HQJtBoya+Og9nhglMMNr6NVpmjFrP4FhnZk4afojDQItXp9X?=
 =?us-ascii?Q?kjXXvtcaRRdxYAEWOMd8XImvb4UkDjyw4Gu9wjgcLtGjT0yWX6PcpE6OCSfW?=
 =?us-ascii?Q?OhCpB9vNRWOkTVCoLjPMx+w2nesOHmo2yiz1dlSaAesoSU19Jpk7LtAQjBGo?=
 =?us-ascii?Q?W6fQ9q2xBibdqrrMaow0mXmYUrGag48nPjjj+vRhi02ly34zS1bJnhlb5nzq?=
 =?us-ascii?Q?QxWKyX5ZJijof/rDQkFUh5t4T5ZVc6RlqQEZAqcU1deAQl8tjgnSYURREXNL?=
 =?us-ascii?Q?IpHZJHEUUtHbeeZpKYfvKv5W3rDC+Qgve15xD73gEcuNUovK1fO6OPRyVTbp?=
 =?us-ascii?Q?bvKomNRa6ScRHi9YxLp6Zce7SDPuIQrPLYClezOs1WSKRBKjPfn8ggmmPor6?=
 =?us-ascii?Q?Sr+wTyxQTWChkbT31XMadwSJi7y3DZhCk9+qveX053Ze8mtkWFHZZTGu+gyF?=
 =?us-ascii?Q?B2JjIuF/oyFT+uk/G+9EHtszGng9YCxiwJmSPXRk?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	i575juz1x1n8HscCQ3144LQ7+rAhltDWt3Kk5yVO6gkZhkYJmQugae7aISrDKC/t3IW9MXzvbFytnzYqPpBNWjmfC1dF43POmzS66FTbFGxygLWlFHVq5iM06FKPzCE70QtofazECFhKiVPPuwCMhtmTX/6HVZtbIvjMzT+eDkF9Y3a+U3kBe7Fj2x9VAxldObvmEXh/xXEYw1uvwKh2IL37nXaux4ce1iGscQQATaG9FG+x4GINkG5Rub87rfbF4VaqSzj2omp9PjiHZ3+k3uw8H3SBI/Li0Z06TS0LDCjkJtlDUh0w4eq/x1KLLdLDQYX1SIn1J/6SCfABjvSbYTzgSn0SLgUYkqD5TSCxL+/KHyl2RzlDGezG35lDQsiJccvIq7Uy54umsuZ3puQK7g0zLYYvrHa8BuJJzrMzxnVPKgSVOknSIHm3pJ8RE72UglLUuFieArjDezkgRo1krxbpLaw9AWXPQ0VHLgQ32ma1rj1M3BtPjRNiaouFzccT78bIXLbvuf0VnpsW8AaEv9SzFMXOGJVI+ScJM5ASKtd2fpTA9Is6R8TnnJ4N4eaCPbvUDu4y834rtuE+bxuxL3WSaUIwqCUwW6eoe5JN710=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d8ee78b-4704-4bd6-e391-08dcbb1f252c
X-MS-Exchange-CrossTenant-AuthSource: DM8PR10MB5416.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2024 22:36:02.3347
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fxgwtMoeu61piRxnkzwHtx2Muyq+0Ctqhn0MAHbtvcjgN0/ML/6M/1VXpgQM9/Cb31YdnfqmfSRI9mOwG+TdbfzTTCrj7QpBDFt+L95Mkh4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5718
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-12_12,2024-08-12_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 bulkscore=0
 phishscore=0 malwarescore=0 suspectscore=0 spamscore=0 mlxlogscore=803
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408120166
X-Proofpoint-GUID: s2L7ghFhvkaTlYuW5q_Cbh3rBElFU-kj
X-Proofpoint-ORIG-GUID: s2L7ghFhvkaTlYuW5q_Cbh3rBElFU-kj


Christoph Lameter (Ampere) <cl@gentwo.org> writes:

> Reviewed-by: Christoph Lameter <cl@linux.com>

Thanks!

--
ankur

