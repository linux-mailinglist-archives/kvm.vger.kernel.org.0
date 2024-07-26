Return-Path: <kvm+bounces-22351-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C3EE93D998
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 22:15:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C70FC1F24521
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 20:15:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86E971494C4;
	Fri, 26 Jul 2024 20:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gjwFSQPt";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="t1o4jSpC"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 916B048CDD;
	Fri, 26 Jul 2024 20:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722024900; cv=fail; b=Mv4qUWXoin9GajUU4n+bo4YDXP/7EySQM8CRVQrG3kgX6hXMzP7GXREI8T8go8TLm02tqBnpkksRNkeV7zDaTlKG/50GrhXHkMAKUwUz7ai1nl8p296tXY6Drg3QnVttzmBWVPPGNUwBpGzEjZHS0Kik6YDDXD6ulCjv+d6s5Jg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722024900; c=relaxed/simple;
	bh=hDD4GUCtEZNQmh+QngbajqGxys0TBqlcuihmsGapkNU=;
	h=From:To:Cc:Subject:Date:Message-Id:Content-Type:MIME-Version; b=YA4XF/a6+POyM+q/CII9zD4caIXlWzpanxt9cN81qc7+V+LjyFd4BsLQOQnMSWJUIIMut32Z50ToKrZ7LjWkOeNYZW9JeQUhVMgP6+JHHVzr/9DUT6i/oSzx3r12eNK6h/71apXsOP1lyy9cfMnB/ILVgMPMebaeV4IBcW/EPCU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gjwFSQPt; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=t1o4jSpC; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46QIKwWX011792;
	Fri, 26 Jul 2024 20:13:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:content-transfer-encoding
	:content-type:mime-version; s=corp-2023-11-20; bh=1pTyXSkg1iogw8
	l403XNMcSbM6W109IKLsbs8n6JeoY=; b=gjwFSQPtW3CjPTFkZyGNmFBx00Qajz
	HtAwa6GFTWvmbONM0AVvFsdVeroMsldadjueTFvO4VrV8REMRAR9jN1rMW6Uj2Me
	iGtfdGxO2WpUPCbr+ycQDQ12x5uZdfKWtDfp51Q3S7HHIij2rqUAt45Kir6FXNjs
	EOMnXfP5uAPN+UydPNSS+xFeLVmcS6wANy7VrwRANbeIPCNYSbnOJVFN175ogEja
	Ie/y/SWEOnC2cxCDMOElzQTeLyxQn2R8LjR1IeQP9uTlEWI+t1enYinqTHSwvNSM
	JvSWzAJDtWEFZ1Th8H/ccixejC3LrPC1VSH0STWt940+LMPKaWS90RxQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40hgkr6822-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 26 Jul 2024 20:13:59 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46QIOjJN013515;
	Fri, 26 Jul 2024 20:13:58 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 40h2a645qs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 26 Jul 2024 20:13:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Po77jYF4paWtTjUJYru9VstH7EEz6Snoe/B2f9s519dIckX5h3MW0K2WgbvrVMSb1GCHn5XaJnSd+f+bRzzphSdiKXissegqFk6inMAKuNTjwYbNJ6bhSM3xv2oJRCfDJfcz2AAnojfVodjkjQwbMEO2diY2XqnWZ5Wqv0disxIg4yu8tF3XpcqSvaQjqKT/YY9wfplxr1SISu9llNiNEwNkonI4gtXxQFR6OQ/TrRUloxAS1nTFeTQ7FBAapZM2b6wdc2Inap4cjuLGgAtd8csn92T8PcWk5tw+ZrxGg3FF/NLA9uv83kO7ouN4CRP7fcbr26JfAJ68rbtb1312fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1pTyXSkg1iogw8l403XNMcSbM6W109IKLsbs8n6JeoY=;
 b=vfwJ/aT537HKCvk8JBGLMV8TF6ZolEnd20/eY/FFPwtpVtr0dLkZ+RRuxddAPmoJhVHBN8M3axDrT2zpwPWAQSLY5FZaSjsjPw502hBFxzEQdbgjZkWcxxn4xiH2t99MIOtBW0lSKyKcbnHOs90QeHLuYpXxTRvlqgtcOHXmC0w7c61Vh8nB77vUtmeUgTUzAZ0wpwMR1TiOpMIjgB1U4HnsHm0q3k5S73P2UucP27iES5AmVmchx/QF7U66Ei9NjoaqD839Lu17I93+8vrL2gDrX2ruus2hl2gQY9SaEPg7XeT+3bT3Q3Acf8dT5U7zO9A5QKuYz2/T36RyBGuPHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1pTyXSkg1iogw8l403XNMcSbM6W109IKLsbs8n6JeoY=;
 b=t1o4jSpCRSH6uB5elI6FBPVBR1zj1odcXRCwveM1I5StFbTB55umEhXQpE2HjVKHRqxRgNVuPNwKFNYWpsg1uP9YkMBdxDQ4SOYAwR7e8Jfejub/5V+P9We4Wn7awieZ3QgK7T0gCbOLN8qKDAJtXXeKJ/BLRp1iJoS2scZ7+jc=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by CH3PR10MB7715.namprd10.prod.outlook.com (2603:10b6:610:1bd::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.29; Fri, 26 Jul
 2024 20:13:35 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e%4]) with mapi id 15.20.7784.020; Fri, 26 Jul 2024
 20:13:34 +0000
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
Subject: [PATCH v6 00/10] Enable haltpoll on arm64
Date: Fri, 26 Jul 2024 13:13:22 -0700
Message-Id: <20240726201332.626395-1-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0066.namprd07.prod.outlook.com
 (2603:10b6:a03:60::43) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|CH3PR10MB7715:EE_
X-MS-Office365-Filtering-Correlation-Id: c3c6900e-46c9-42f3-8338-08dcadaf6d45
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kDRauQoya/waW2zgfar8Uf0jBzU3DcCHbuUqF+BQnxAUhG33iww3nGMV7N+h?=
 =?us-ascii?Q?YzA1vr6GitZpER2rLrPNUGN1rUNQ6htQBaiMbxcNY8cOs/r/qvTzF7N5rw4w?=
 =?us-ascii?Q?nsBVpfoht2Z/4TsN6WKVTYPruN2qmn3PUpmQ89gQaVTtu9iYOcc/pwQAPE2V?=
 =?us-ascii?Q?G3r3UGh+6GX1i55Flul1LH3FwUij49/Lq6iShsvRSXqsugxgnizG8D2a/Xpn?=
 =?us-ascii?Q?rw7GxBFdP5bfamp8Ffn90Qjk4cpXCIvKeMbc2+pZKkzMTV+vu106CrPe3lmB?=
 =?us-ascii?Q?Gy4R4Y47MsNLfuekQSomB8HHjRctBL3mOCDLaTxTd4kB3qUEtoek6muRRgUX?=
 =?us-ascii?Q?nMXkLjCbEQVfmuXis+5My0wRHMRHfqalLDf6uQFxG7SNO+1DSEhvJSP4a2Xa?=
 =?us-ascii?Q?Zx7EEiJsj8zwKqhqFdQBK+dyKhAOhLqo1iPoZ3i+67F6wPMTTISGYeAaUf1u?=
 =?us-ascii?Q?Vy+yZXngzQ1P98Duhi5eKfRUEMTCIiCgkknTe9I5ypwKe7e+VRhCDrbcVX6P?=
 =?us-ascii?Q?EGcWMeRr2MI9IeEcQ8qN/KKWCTPD+petFUccq4USJ8M8oD95SWvs67vOh+hH?=
 =?us-ascii?Q?3LonkhfCyeUrLeDYbFZnfuY6zXczV/OlrKRmWoOyxiUkEo1wouIoRyrELTB1?=
 =?us-ascii?Q?IMfqrvRRZjuBa3je4bKDoxrFwCYLd/9tQzeHBaXTTe9v0El1LKJsEHMgc6en?=
 =?us-ascii?Q?imDlqtfku+ge/F6QeXDI2x1djR9gNpte12JtZwX84qXUo/mXGMiDfQWJ6qdO?=
 =?us-ascii?Q?Frs3UXrlWMkAZn2w9E6o03zq3DvH2vz9AYCt4yVYbeHrsm5sCIASCz9FNjG8?=
 =?us-ascii?Q?Up/f+ggrDWscRPf1gqhiiUcXmc4vWp/9uxTSLrx5QEVHvH2/yn3nFWTsszMV?=
 =?us-ascii?Q?FtMJ6Vxzzl5jXmJ8bZ7cWAygWNz2Z+vHpK5iXAyAOZj004dO/0O40+e4Bn9N?=
 =?us-ascii?Q?94MkyQB1+6Oj0fYGp166uZbXFI0P+Qb54v02gfgVcWVb5U4gHNx1nwZwXhil?=
 =?us-ascii?Q?06JQm34lc6zxbXvh0uvfBjASOqzVvSms33S24qxAGCn0LLf8s9GfgQXHhe2h?=
 =?us-ascii?Q?YJ3PK2Fp8SUHPZ3ltJPvQt127WA3/99HlkpqMQwQWKoThTLS8JbMEPHL3I+R?=
 =?us-ascii?Q?S835WtKpmdKcvlpC809iC5/iQP/K6JBe0vE8K9xeyvOcFQHBmqX7CzHps1AV?=
 =?us-ascii?Q?5x+dVvDUZs9/PvJBwCXMXNfkEHDrh6aKcQS/lCkLBcM8QkLDA3ASCyibLRId?=
 =?us-ascii?Q?pzkscpSnu6zXfSntJ0jskWJl54h2nGf3GnimOyRXhM6Hm2wclS2t11l/Ftlr?=
 =?us-ascii?Q?uEEBbHnuqMmYKCrZsIU7+J0EedM741BhHn2CTw9MxxyQyA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?j+rMcEJ7t9bnslkdw2eVxgl9TvBe4rsy1dDnpcxP4EThOhjQYKqy3pNQFOqj?=
 =?us-ascii?Q?BoqhqxTR0SOVD/lJLVd8GXfs8vb6zRY8uFcsLzEl/Byr5rbIn2FlgpYYHt40?=
 =?us-ascii?Q?lHxmzL16LYNDno0sJy55LEhE4G89VhPYX0GcK/gM9bzeA3GVUTsVBPKRp2Ri?=
 =?us-ascii?Q?gdoobVPUOvy0Qhxuz67xa7CzfHypmnV9i5RRhpcvL39avz9mh98Onw0dOTTa?=
 =?us-ascii?Q?2g6RE8ddhY3M4b8sJE20YASFnt98uRDdM8LEWXepazTjeBdl/TPQ6F+H0hCt?=
 =?us-ascii?Q?sl8awy+bmnaO1jXTShO1ZMj03uMJPmM+Xj534VHq2TWXkeR3njD3PgQRg/a5?=
 =?us-ascii?Q?915sbbvAEbqs0i7JPyMx5xNYgseFZPLkmk2hL5ViwFp+Rwk5jZM5W9xxIuMP?=
 =?us-ascii?Q?OWZK3PU9gLvcWB3S05PPs6uDu8+GDDjK4ggfZSl63LRVAhLsF0KYugEMWD4B?=
 =?us-ascii?Q?QAHlagMMyJf4wbi/iCy3HMjdAqhAM1IQDeAvHieWtqg4yn2Sd01Qxf01U4ZC?=
 =?us-ascii?Q?ZhncsAFYuAPOF8YdjUokFW2DRSMQs7ULoQq1VgZjr38DmF63HqUeCxP/eyAE?=
 =?us-ascii?Q?fFWU7Maq3VdMg4+jnxSjQhet+DkVTkUJXDqwpieygYQ/w2CRtkHwXfpI9gyF?=
 =?us-ascii?Q?duv0dIRz5Y2yWqjwj6jmWbwS1xEwueOJJUBGBRdycsL4YRGEWMromzARDxH9?=
 =?us-ascii?Q?C6f/U2e3OTy98FMLx/XXH6nUuSovpmZWRr6Zt7WjW581onJyPi5xdeVxX/lm?=
 =?us-ascii?Q?6wo/KMiK+w8dScFCgbRCJDD4LLdFLK3Y2IXAznoocLDGdR8Y3WJERfiGIoo+?=
 =?us-ascii?Q?iFe/EHaTAuVJ4X1mtSoOCWGnARULtAR9VT8LkDFpoyrUyZgoItZJqiJVvNfp?=
 =?us-ascii?Q?cql5K332Os3f3bgnrGsyeqUcSlQJDQO3laYsvCU8bkgApESBWZmUWNp9hGFW?=
 =?us-ascii?Q?XnANAcOFO2ZU2tBFCJMzMlFzfUE4kWnIuPpYboDHNQA5wNKie1LCzIQBz2St?=
 =?us-ascii?Q?nmH49WEbe9iHGed02V2/tR/bxuGVF8bN1PkqxhXXF84n62tY4xcvKACFgd8v?=
 =?us-ascii?Q?gBsN5K0eCY2QWiSsZvEomNv+JILm5Ut5jJfp/LQJzFokP47wFPNHsPpGYH8I?=
 =?us-ascii?Q?dDzchPPRVBx56t4nRHSTTWUQtZ//U0Caeql9+Q3rRxZxKJcsucsNmDsSdJ0s?=
 =?us-ascii?Q?SOIs7fz/XSQTAQ9OBn8JS1OF52HlzdhWYMb2lR44UF6nVKKXrzZzC3ff0XO6?=
 =?us-ascii?Q?HdoOfh0vmPJK6pZpltHp2Q3ztv7Vik96ODulZlCSBIuQktCJoAw6cmy7Yy3m?=
 =?us-ascii?Q?xVt9UY2KBXjVcz02pB6+Ygpi198nAGW5qN9CXj2rVd0n5tCYXV5v1sIFjRNF?=
 =?us-ascii?Q?9Y7NA6NX/mAEyP2xEA2JFoe7Pxv6O27ig5Xmtrglt0a+Bd9CIxaM0bCrWeOO?=
 =?us-ascii?Q?fI6FpdboTmTv+/jVuhWyzIxncsqLytVB4vTn3gI7KWrGP34agYO6I8TBH5IF?=
 =?us-ascii?Q?/HqO07717CdQep3cSivA1zlFtjmutKdpcxkxfdfnfg0Yo9smh1bToxyigQ4j?=
 =?us-ascii?Q?bIPucSWb50oSS4Db31yNeO0ZCddXqvxzTbL+DPVmvTXqNwiuF/sGRoVJqa8U?=
 =?us-ascii?Q?og=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	oivbKFCq0K2tNmpuJV9sjCuQixiT7brlZpI4tKanY7ECXpEHFdgynA19ZePTYx0y/l08c1casbSz0BeoDhJK6wLiY9GM9mVhhj1Kzd1dNPTWygBK+zQd39Z5UaqNedgBh19HiFZjaTfMEUqDd/XBtqhyhlqF0sJBPO17d+xN+dl6bWtVWtyrdrBLqHQ2Xpg1AsBMyfCV5gZ5ObNDHNOE9v1+JUsdzK0B7gTy3nrnB/OFtey8JAbxQuhF/ApyCArHPro6HVUjpjDWeQRDoQ9BbSIj8TnyAKNw073xaJNgJ+szDkBXiKDH5kvWKRPCNaoCMWAGY3zFzG2m/YeNWJANZ609Mqe5zMpgTDIdA3+iZ5Af36aEwbQrM1hVOELjNTFwouEj86A6d4NwskhDKWUE4N22A6SY2hC2rsXWp1A8bDGFXnGodtNCir1yVpWq0rqGbbIR9MhizWOOssZ4HD54WfUgLoVhLRwmb5TLwY6oMH1sfQq6teYi0GHYd11LdDgE2bX466Sqn0WpjkH3kCjp9dgxF4gqGjegfoPd9u8FvnN2f1bBNLkSsK1HbK+vcaRxTL+dqHT4hwUT3J7wkYxu9AIgF/99meNoLVWC/uQER2M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3c6900e-46c9-42f3-8338-08dcadaf6d45
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2024 20:13:34.5880
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sVlp56MX/vCWZoXnm8ifp2sBf3WxX+OUr4Z8XlREe1hh/8fY76PaEfY2IzHtbTKINo2oTFqkIiQN5L/axf+/EpsY5ylTJe/nnWuTGiAEw4M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7715
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-26_12,2024-07-26_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2407260138
X-Proofpoint-ORIG-GUID: u2_vhywIpLkG-kqjSPOXWk3fJtw7Gdvh
X-Proofpoint-GUID: u2_vhywIpLkG-kqjSPOXWk3fJtw7Gdvh

This patchset enables the cpuidle-haltpoll driver and its namesake
governor on arm64. This is specifically interesting for KVM guests by
reducing IPC latencies.

Comparing idle switching latencies on an arm64 KVM guest with 
perf bench sched pipe:

                                     usecs/op       %stdev   

  no haltpoll (baseline)               13.48       +-  5.19%
  with haltpoll                         6.84       +- 22.07%


No change in performance for a similar test on x86:

                                     usecs/op        %stdev   

  haltpoll w/ cpu_relax() (baseline)     4.75      +-  1.76%
  haltpoll w/ smp_cond_load_relaxed()    4.78      +-  2.31%

Both sets of tests were on otherwise idle systems with guest VCPUs
pinned to specific PCPUs. One reason for the higher stdev on arm64
is that trapping of the WFE instruction by the host KVM is contingent
on the number of tasks on the runqueue.


The patch series is organized in three parts: 

 - patch 1, reorganizes the poll_idle() loop, switching to
   smp_cond_load_relaxed() in the polling loop.
   Relatedly patches 2, 3 mangle the config option ARCH_HAS_CPU_RELAX,
   renaming it to ARCH_HAS_OPTIMIZED_POLL.

 - patches 4-6 reorganize the haltpoll selection and init logic
   to allow architecture code to select it. 

 - and finally, patches 7-10 add the bits for arm64 support.


What is still missing: this series largely completes the haltpoll side
of functionality for arm64. There are, however, a few related areas
that still need to be threshed out:

 - WFET support: WFE on arm64 does not guarantee that poll_idle()
   would terminate in halt_poll_ns. Using WFET would address this.
 - KVM_NO_POLL support on arm64
 - KVM TWED support on arm64: allow the host to limit time spent in
   WFE.


Changelog:

v6:

 - reordered the patches to keep poll_idle() and ARCH_HAS_OPTIMIZED_POLL
   changes together (comment from Christoph Lameter)
 - threshes out the commit messages a bit more (comments from Christoph
   Lameter, Sudeep Holla)
 - also rework selection of cpuidle-haltpoll. Now selected based
   on the architectural selection of ARCH_CPUIDLE_HALTPOLL.
 - moved back to arch_haltpoll_want() (comment from Joao Martins)
   Also, arch_haltpoll_want() now takes the force parameter and is
   now responsible for the complete selection (or not) of haltpoll.
 - fixes the build breakage on i386
 - fixes the cpuidle-haltpoll module breakage on arm64 (comment from
   Tomohiro Misono, Haris Okanovic)


v5:
 - rework the poll_idle() loop around smp_cond_load_relaxed() (review
   comment from Tomohiro Misono.)
 - also rework selection of cpuidle-haltpoll. Now selected based
   on the architectural selection of ARCH_CPUIDLE_HALTPOLL.
 - arch_haltpoll_supported() (renamed from arch_haltpoll_want()) on
   arm64 now depends on the event-stream being enabled.
 - limit POLL_IDLE_RELAX_COUNT on arm64 (review comment from Haris Okanovic)
 - ARCH_HAS_CPU_RELAX is now renamed to ARCH_HAS_OPTIMIZED_POLL.

v4 changes from v3:
 - change 7/8 per Rafael input: drop the parens and use ret for the final check
 - add 8/8 which renames the guard for building poll_state

v3 changes from v2:
 - fix 1/7 per Petr Mladek - remove ARCH_HAS_CPU_RELAX from arch/x86/Kconfig
 - add Ack-by from Rafael Wysocki on 2/7

v2 changes from v1:
 - added patch 7 where we change cpu_relax with smp_cond_load_relaxed per PeterZ
   (this improves by 50% at least the CPU cycles consumed in the tests above:
   10,716,881,137 now vs 14,503,014,257 before)
 - removed the ifdef from patch 1 per RafaelW

Please review.

Ankur Arora (5):
  cpuidle: rename ARCH_HAS_CPU_RELAX to ARCH_HAS_OPTIMIZED_POLL
  cpuidle-haltpoll: condition on ARCH_CPUIDLE_HALTPOLL
  arm64: idle: export arch_cpu_idle
  arm64: support cpuidle-haltpoll
  cpuidle/poll_state: limit POLL_IDLE_RELAX_COUNT on arm64

Joao Martins (4):
  Kconfig: move ARCH_HAS_OPTIMIZED_POLL to arch/Kconfig
  cpuidle-haltpoll: define arch_haltpoll_want()
  governors/haltpoll: drop kvm_para_available() check
  arm64: define TIF_POLLING_NRFLAG

Mihai Carabas (1):
  cpuidle/poll_state: poll via smp_cond_load_relaxed()

 arch/Kconfig                              |  3 +++
 arch/arm64/Kconfig                        | 10 ++++++++++
 arch/arm64/include/asm/cpuidle_haltpoll.h |  9 +++++++++
 arch/arm64/include/asm/thread_info.h      |  2 ++
 arch/arm64/kernel/cpuidle.c               | 23 +++++++++++++++++++++++
 arch/arm64/kernel/idle.c                  |  1 +
 arch/x86/Kconfig                          |  5 ++---
 arch/x86/include/asm/cpuidle_haltpoll.h   |  1 +
 arch/x86/kernel/kvm.c                     | 13 +++++++++++++
 drivers/acpi/processor_idle.c             |  4 ++--
 drivers/cpuidle/Kconfig                   |  5 ++---
 drivers/cpuidle/Makefile                  |  2 +-
 drivers/cpuidle/cpuidle-haltpoll.c        | 12 +-----------
 drivers/cpuidle/governors/haltpoll.c      |  6 +-----
 drivers/cpuidle/poll_state.c              | 21 ++++++++++++++++-----
 drivers/idle/Kconfig                      |  1 +
 include/linux/cpuidle.h                   |  2 +-
 include/linux/cpuidle_haltpoll.h          |  5 +++++
 18 files changed, 94 insertions(+), 31 deletions(-)
 create mode 100644 arch/arm64/include/asm/cpuidle_haltpoll.h

-- 
2.43.5


