Return-Path: <kvm+bounces-22357-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 99F3E93D9B1
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 22:23:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0971EB233FF
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 20:23:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93E3914EC4B;
	Fri, 26 Jul 2024 20:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VW8+1wa3";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="QIQIgJCE"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34849149C77;
	Fri, 26 Jul 2024 20:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722025347; cv=fail; b=XlQHqCZRJ1rZx0i4HWqQ9nFI4uQGaOsye0QOHtNqvvEf9qNgFW7WA1A4a1//xToYyd95PvabYWju8vRe+Ee0QQBpFIudrzn+9Z/vsLOMC+uXPYQrvRV8C+XnMJAAo/EVBTvVNQHvJBygWOLQ6DVsusV+oyXhi0Va2712WwRIc0w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722025347; c=relaxed/simple;
	bh=khSTJY/llFO781W+oRrGsrt9Ari9F/wxcNbjXtabusk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fkanr7Gej8cQTOBQDLkiLNo04PL+71EyRbmQ7+4hw151cZgPPvNiLWW66w5XdxMZU0nJVXMKiK6B+nAnu+W7vyNU+naKCkrBOCHUQi1B7Tnzz1UlOdi7AVGxWDB25MWW6yKUApI0k1c2orjVdUM9zmJMvv9jQLrOoNMuLRYLbgU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=VW8+1wa3; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=QIQIgJCE; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46QKAhvw022201;
	Fri, 26 Jul 2024 20:21:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=ffXvkV+mRWAxyKYRSz1YPBNnPlHXfBa9sCaF3inIVgA=; b=
	VW8+1wa3f0gTExdGeAiUBfFHBYqto0aaF8+Jr6nKzLURXpkw6Xvj+uTIoCA4lA9Y
	PgkA08v/DTOzdJfGpvBj1/XEH5HYQp7UMwg7p6olQxciXvJYxwHCaPRRbSjoRd6b
	kfeHhL/jwRTNUuG/HKA3Z8jcjy7QhTGwyFrnJ+03DOyzyXczC7XTVq56FVCzdsqZ
	Oq2X1FF6Ox5+6j7kNmz+75/CMfUbq443aDhVzJQEeUJ4CE9gwH0uBWqa4lsx0Vam
	4nGHVch/o1mvVb91m/iwHPvKmso664DJ1utXuKOAdWASC51UgILiLC08fqxHBz3a
	JcHlKgMwoBSQRGH+mNFI1Q==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40k7yuvj6f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 26 Jul 2024 20:21:55 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46QK138D010718;
	Fri, 26 Jul 2024 20:21:54 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2045.outbound.protection.outlook.com [104.47.55.45])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 40h2848fa6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 26 Jul 2024 20:21:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sqoxEoMvQmaLMA4i325fN74ycqoCv0V0NJQr148Gm6ijIU+dGl0YItxuAg9dL1mUzLQae0FtpX537zth8voO7isN++aM8liFP/QG+0TiyjzD6KWqFo35IkUOQUI1alRn68m3yLMES2yIMwFtVpIOfhIZ8XcKhXFmgLDcfyw8nCDRErZdr7tMo8Sfr1P7QJ+fneR02Buv2o0nbmpgZzcDrf5FAWW3SCa2TqP+9qqk/zeOgdcaHQ2SQ5tyMbWn9yDtV8zrvwCtW+gG28o+Bu5/gHORCf9FM2cyCMytUAkH48K6yDTXlNj78l5jSJI6rDny8jTT7e7+sbqLDsSLMTY7rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ffXvkV+mRWAxyKYRSz1YPBNnPlHXfBa9sCaF3inIVgA=;
 b=oQy858qewAHsKZwk8esLHoAwJbLnw4Za7CJYb6wersz+qYoc6WclgwB1NTSLeAeqRhg3wLgJsi0NvbklfP0xrpFLVvAk3UU1WA412PEjtjNyi2BrSlwMo6GTg7iNw6T65OELUjGM+doRGCMUkTpItxKBuI/hQ/wNWhBRJPnyrW7+3YMEcej5VcsMOIBXHDPxSdLNB7I5A8n0hDL8//rMhiLdtvIf0E9X9shfBe9WnQznMgNMhYPiQ845/a6jjTtl9YQTOxfx3jeX8Ii7n0PNbpGI91j+vcaCBPhn1uoq7fkNgKuZQ01oe80yB68g4ZRinFsltE4p2Hz+cu5KWRihMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ffXvkV+mRWAxyKYRSz1YPBNnPlHXfBa9sCaF3inIVgA=;
 b=QIQIgJCES4JmMToimeNbeLJgNgZ4BC6o2JDQ/xCjgqCOoM4DXVU4Eh2R2SYTL7E8dhz1eWhqGDoALazc7xKfsJeEt8HjFxVZr8sOf/pFaHCuq8xEolWAzEeYvD0+Zh/wS8q2oi5QPbVdiVhySMgQi4v8Xz2OFYBB3WEvcmCNGQc=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by IA1PR10MB7485.namprd10.prod.outlook.com (2603:10b6:208:451::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.20; Fri, 26 Jul
 2024 20:21:51 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e%4]) with mapi id 15.20.7784.020; Fri, 26 Jul 2024
 20:21:51 +0000
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
        misono.tomohiro@fujitsu.com, joao.m.martins@oracle.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
        ankur.a.arora@oracle.com
Subject: [PATCH v6 08/10] arm64: idle: export arch_cpu_idle
Date: Fri, 26 Jul 2024 13:21:32 -0700
Message-Id: <20240726202134.627514-6-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240726202134.627514-1-ankur.a.arora@oracle.com>
References: <20240726201332.626395-1-ankur.a.arora@oracle.com>
 <20240726202134.627514-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0209.namprd03.prod.outlook.com
 (2603:10b6:303:b8::34) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|IA1PR10MB7485:EE_
X-MS-Office365-Filtering-Correlation-Id: 049b8a9b-80a3-4e97-6e2c-08dcadb095ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?v/tBVqc6w3K7j/MzN6qbqTv+YGpULz82NdAXzBVhPL/tUkPemY/P4OrQSUe2?=
 =?us-ascii?Q?Nb5Y+fXJITcrsLuNuxqYK3OSnV8O5gIh0VmgIDCDX8rSAduX3tKSh03GUsND?=
 =?us-ascii?Q?vTEY39FPZ8ZOm6uIhA69gTJelxt4RUwVDNCtmXh1kwEHI9JoKNrmhYbGBNNI?=
 =?us-ascii?Q?eVFOTTjYsr3JPRdvTuHYjQGPFK4yX1ynGUD5wDjZF2h6kD/Qdp7DKe2rCeYy?=
 =?us-ascii?Q?E14N2Y1uokAI2KexN/vS/EMLy1V6ML05PP5wm9XwtO4dIElLcTyXJdXLxU5T?=
 =?us-ascii?Q?wHnmtffPTYjjb5Ric+ovsEC3BUMJrtIjnCRUJKFSbX9kEOres9hhNoHuDnOh?=
 =?us-ascii?Q?ySsQ6c6u/sNMthTAVaYzmPBOrc4ckj9lXC8WoMxNUqjLfXwOcfKtAiM1XGv0?=
 =?us-ascii?Q?/CSDUzT+5WgBARWWAlOpllCjIHBC+5WIap6So0L6ggw219jYZmn+/62/pv1w?=
 =?us-ascii?Q?f3HsgefSAqVAKDiruegGX6a3PebNvt2mlxP1SlyOgLrmb/jiEUel+oVYH2rP?=
 =?us-ascii?Q?7ugTJsnbrBTf8yU/YqUwmKWQrSuFWyny5lTSKOhZPapJMYcmS+mK1FXEaAgt?=
 =?us-ascii?Q?Sm6a8xoIoTzobX0qudoi/E30F4x+cnJYrqV4BBst83bsXEIdITWPSD0kQkvx?=
 =?us-ascii?Q?hI4g1Lbgfeah3yQ447vNc+cNpS/FROxcD0cYenvw+rVqES1i8aDOpZMIDffP?=
 =?us-ascii?Q?S5rlykOFXT2QAjB2FCiGntyE6Qsq7Ri8LtTyRkMlQp00f2n72BgLvVFM/G2K?=
 =?us-ascii?Q?RhiDipL0ajHELqfWZbhBYG9ktMga8PhWZGlUtD2nLOBH9ju8NlPytavArEU3?=
 =?us-ascii?Q?BRgIN7STnNg44bUf3bTLjsNlvNRSTyo5mZZGt2AM38IgxfJa86Irb8hbsQGd?=
 =?us-ascii?Q?3ufcSehreTPsZTgQr5aLkFnizjc0rdlSqZkYbPiwKz06YCRr/a0t8ULdHi5k?=
 =?us-ascii?Q?Q/GjR1UmqLnBjDGhx9W51DRHPRUf7fVUbmuLSWcAhyDcTHIDQIKGPHCRW4zc?=
 =?us-ascii?Q?gPTNA/j3g64agLb839b6GYVDvLH9h4g80LyC60na+mdP8kvG8Nid2XA6P00z?=
 =?us-ascii?Q?GYCrWQXhJviGz7YJ9gllvOlWS/IO5nl67fGeMePnJrHwXMYWjIVtuJn227WE?=
 =?us-ascii?Q?inmipYslwYQoGCnDj67o6It2uMOQE0HR2ESc1WRr0Hiu3wol5zhiGeVh/Z5y?=
 =?us-ascii?Q?CioDa9tnKViAN7UFo3iVDVctRAiJKSgqdzE9eZF/M9tFIu/U18aUXVDKm7Ov?=
 =?us-ascii?Q?V0hPRADliPkp9H0zGNdH+zwsEZpCd7FRuJ8nNbYXjaBPCKL4pHyKmR3eAYdU?=
 =?us-ascii?Q?4NaqFOeZba10Qus9RHWc87P/KT962bXz9oOy8MXhOnga0A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vPMqYYF/ip6gJ+xLpgbV3B4Yf1xFPrYgslG5qHGr6yyggPRBjGMLXZjd/31b?=
 =?us-ascii?Q?2XvCqM++T6a1NiSWBIu1p8ynZTOe+kUyhzX4b0ldfZyjXUntn9HR8voxpYN/?=
 =?us-ascii?Q?EFVGnEUlwlMRVI1X4rHSxSnfPSxzr21jO4AWhlcPuvsftMBRmwRucS3suY4x?=
 =?us-ascii?Q?56B/9kOhdhnEfmAElWU62eQvNU5vDc8ReUwcKZQogYPRaSEB1hKueLjhdNj7?=
 =?us-ascii?Q?Ai3k5C5tU2XSVoTYLIBr1u4V6UhLtEjDs3tQP0bCqh9j9nImtNE0KB9a70qz?=
 =?us-ascii?Q?ReVqrfAljcBq/tvyU/JoeKEjWhAdbtoi0UBypXsX+ktfTU0QzBCAPnBiO5sg?=
 =?us-ascii?Q?HcjXhRmzKp25sQ11A+OBvPUSYPRPmrWQD3JL/dA6qcGHpIS5lnEPBhnjYKQ3?=
 =?us-ascii?Q?UhqTlC4vF1kFbD2gqjTqFf5NpbAMAKuk5MiuSusyfs8LN09viLHlKh9v9rA6?=
 =?us-ascii?Q?FZXatzz8zIOx4VgdfjZnQjD8v8HgBPlLZKYPgXT+9Ztli/Q5mhUOm5FmEDgi?=
 =?us-ascii?Q?FJz5gPTmeP3BoYCRbJNlYNFsn05QaCqW/k+RUGvgZ+/7yKjbv5UaC8P8kG63?=
 =?us-ascii?Q?2lJj5Rl3m2U0hI3znJv9L3sC4q741SRvq0hP7GTNz3lGObig/1XnCdE8dQIb?=
 =?us-ascii?Q?lZTHa9NYMZ6QVsXx5ujVO9emsNUNvQYVK4FSsu+MZDNPl2X7Q4+CoIotp0EU?=
 =?us-ascii?Q?yX40DAYb+U4cDMaZQAYhXU/onq3KEI+gRxHnOtUbWRxPjvpi+XcWvCFg1aDY?=
 =?us-ascii?Q?wEA5DfOGwfJQTBAX732xc86wfj4jDzl6cxTWolvXXhQbGIuyj7F67h5wBaOL?=
 =?us-ascii?Q?PnkxKtM3f003ynwSRYzcWgYaLNE6nZXiCBB5VEd9W7ISQBWcqiqpqjmNfUjo?=
 =?us-ascii?Q?K4GWrO+B/Zz/NtWqJZNeoIaU5pucKqv/cJBaOD3kYagmljYM4tSBoMrEdd5R?=
 =?us-ascii?Q?DpgXLr+JVkIUpFod1VT4KB3qK4pf27fx7Qrf0Bw2aTBCkyBCO9Fx+/0adejK?=
 =?us-ascii?Q?6xtZXyCGdmrEpiUzNz77uhnwL9koJgHYsblXGjUctkxBtBskk3VtRGpF04Ej?=
 =?us-ascii?Q?mGwifQ4B5bIRqbGayfcaQlYPrTsuqY1mAkFJM0iJZ0GAbigt1/YHay/t5mua?=
 =?us-ascii?Q?hgZKED0/bvLaThAjjWYCWkJ3UC+sZvuDVSu5FDZo80JZ6RWctbJ+j72KmPWp?=
 =?us-ascii?Q?iQ8qCLrHk6H3g/A8Nrd+KCrALK4lGprUWwxGVN7/L0W4qqDw0GpxwkvnuDDT?=
 =?us-ascii?Q?lwQrFgjtl/udqbS4YGM/Z8frnLo6HfPKKAQ06wMS26spu8Poz02aBBoIFnaW?=
 =?us-ascii?Q?kzuV/oWepnGzI2kh9WsktlnWVAeiF6nZJYnO6Txq/SlnHlU+atFecRhL0z9f?=
 =?us-ascii?Q?yzkByfNWifS/PfAIqeAgY+kXcmxzeQdfRN1T47rsxBnArARaQutGvZhZBcvR?=
 =?us-ascii?Q?DiQtI+zMTRiQIIgN/cEFnO1n3wkRjwd3mrRVL0jFAsJjK44x+xBrIe8zKPSh?=
 =?us-ascii?Q?2HcfYH1NT4CVdOz/hJFp+mvZNZ0fmY0BUS6eV3V6wGmLXScAI1bxyPHox0OW?=
 =?us-ascii?Q?tT2kXC5qxrb1UmYVlTsWaVWYnJnBUcv+zt8fj9POxZlWJcbazRDyLDDYOky/?=
 =?us-ascii?Q?EQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	JkS27XTwczyUJoVKRQ3U+2iw/noJAGkLD1l+65V3fu0r5w5MeVq1rDX7qH77Mv7O2pD2K5cEhGs8COTRgIkoaQbSjYzwJNAHZXbnPSW3o0F+WLpJabU5Ur26fRKQlNIbnHOvYGOeiyOYk12M8wE2LuTPGWdLiMUwzFOcG6Rmj5C1HtEKj4krzj+2Rz8106hwaVoshwNxlLZC68bQstrrXn/wiB5NL5YqAEIfVyMyTdE4Wp/+cyCF7MXJ7Xpk2AnND464b8ESbrTRTABKqkBAuYI/8gVDtcrwJtY3RPz299dnJQuwY8zZ/Tmh9J1dRyr4OyMtJbW0Jh282q+gYcEB4+4zJWarTdP0zf24Ml4Tv3KGzhNBfEhJyXuZfbv2RVOjYgCAiita6K/AFhsUUXIJQfYQ7dzzoK9K8DUQ4/GZ54tbipiC/3SefwErhGyN1Ni+shA2fHJE+KR3/y8TU7XF+YlNir/PEMfp98r73N1eeKDmxNaEWO5IhIDBOIorG/lqrYLidPkisCY/vk3VeP8yQliJ89QLBraj5IBiJjQz1/AYiGPeaRFO4trGKAro/zlZSzQy3f0IeJKlIZCPG24hBKZJSWAwVqTyGVmF/cycW2g=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 049b8a9b-80a3-4e97-6e2c-08dcadb095ae
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2024 20:21:51.8305
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SD34RvZ7udOhmUuHm3olU5Zi8zMJkdPxeyVbGqV6MC4VLW4TjLFM6lzteXKl4AOQr+7ZUM4L0LtVx9PhTEMT6gLNGxS6VKiH2DE5Ck+Ea+A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7485
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-26_12,2024-07-26_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 spamscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2407110000 definitions=main-2407260138
X-Proofpoint-GUID: kaBN3B6PkVJAEJVvcyaBeDXM50Imrm_X
X-Proofpoint-ORIG-GUID: kaBN3B6PkVJAEJVvcyaBeDXM50Imrm_X

Needed for cpuidle-haltpoll.

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 arch/arm64/kernel/idle.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kernel/idle.c b/arch/arm64/kernel/idle.c
index 05cfb347ec26..b85ba0df9b02 100644
--- a/arch/arm64/kernel/idle.c
+++ b/arch/arm64/kernel/idle.c
@@ -43,3 +43,4 @@ void __cpuidle arch_cpu_idle(void)
 	 */
 	cpu_do_idle();
 }
+EXPORT_SYMBOL_GPL(arch_cpu_idle);
-- 
2.43.5


