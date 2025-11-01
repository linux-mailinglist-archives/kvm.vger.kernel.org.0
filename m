Return-Path: <kvm+bounces-61750-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A66B0C286BF
	for <lists+kvm@lfdr.de>; Sat, 01 Nov 2025 20:44:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5A8C93AFC9F
	for <lists+kvm@lfdr.de>; Sat,  1 Nov 2025 19:44:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56BE52FB625;
	Sat,  1 Nov 2025 19:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HsFpcjnR";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="D/8FPP9b"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE43296BBE
	for <kvm@vger.kernel.org>; Sat,  1 Nov 2025 19:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762026255; cv=fail; b=VikO2P5Khh8SxppNQQKM6bLDnFGX331Sp7q2SdQOKzc76tVQcWBMXfgpJxp4NSodh3gmYHIixVJgoI+/htLxwfc/b2DBiPLyndqecUjRFN3xRU/8FzXCsAqpMJDtS9NneLsCpAP110yuKMTyACz1dh37ynAZoewmuBhGp4/ssZ0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762026255; c=relaxed/simple;
	bh=JYXcj3bQa6Z3qy08kJxFcQB3yFvkUNqNblARsQjwdpY=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=cduArBaXVTp1qRd+tp9ecld/YODK1R1WsxiyJLD3Zm0ejF7GrEKmJh8iJLdBRL40NU1TGggT20RtG2ouPPISS4+o4bqjFbXAvdWu9PLtt3cbniQ1iT8J0T8qYdmt96O5uWPh2hik2eLh28QyUaUYD9vnc2EGwCGGUjUy9LjHzK8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HsFpcjnR; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=D/8FPP9b; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A1Je2dO004378;
	Sat, 1 Nov 2025 19:44:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=nhoziHWWL4d2CXGG
	BGHNj02sMVFHJCwJY7jOQwJOQ6U=; b=HsFpcjnRNDK4lqMKG3vNXqOugwZISq7+
	9ek/eqINY4INdkliQZIw8TpKm1ZO79FA1DOjdZFVXB25EMWLPPNEA0Yh5xZ6f6Cy
	Qoaw+VY+3W8ENVhFo1kGXZ4NBD2FOEEtRCv+z30y/znA/nXz6qEB7xj3b/I6C+4G
	CDNX5yVrMCX+wOcWixFHA4aG9LcAq16P1OKR9MFxgEn9h9JUwfsNuR4swqomIV5w
	t5dj7cNiyajusXC6edCdauflZSgOUrtkcaTpX3M++AxTOJY1erR5FXP8mOIFp2a/
	GEJnPB3FcDv/hFsKu2giDguJUOmUC82f0lnkiJRCXKHouAdViRCNow==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a5rj7g01g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 01 Nov 2025 19:44:05 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A1H30Fb015645;
	Sat, 1 Nov 2025 19:44:04 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012069.outbound.protection.outlook.com [52.101.48.69])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a58n6hcf7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 01 Nov 2025 19:44:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IsleHnSBfWO/WWgcpIf5Y3onFOj5KEJYMJENhkl4hxaLTYNuWq9pW369CIQRo5t+iXY2Qu0tAAvPdY8QtZJTpETvEyg6DNXnUZ2FMZt0kqc1QypUcxbHhl0pUh5OK+WyNzwPRvx8T5lvRKQXUCmtqq6Vkxm+MOlr6q+HfRHQU3fGkIedZymB+/aCv00hygFiuJCa3oiTfj2yaW8s90YFIcH9jkmHJQVeg4+8f+DMXbXLgO/+GgW6Hlic0rSULFEij1OlpBERlyS6e99wxwdsNSoINTa8FYqlhZGgDxlnnK288Oa9c4TGl2YePTD7JgIkbb/4SkV1tKBAoKTRYwUxTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nhoziHWWL4d2CXGGBGHNj02sMVFHJCwJY7jOQwJOQ6U=;
 b=JOl5fQvF/ZPrqQD4Jg1p25sHPTp896eN5D0ZHHGk+kZx2YVoMMu8pLELwTrYfxpsiyL7XaUiab3jFDDUd6tF0f54y0zJcrWuT0MPQevSF1hUQl9beNZHpTwzw/rc3KqyOQp66sJ90AdGzfe4hyGhkphfF+ivAfnHjbNYHZTZk/s/e8Ytgjmuf0YYp1Xe2jTvRqshDQGywRiQbBR6UZIOtCUGpF+RAf0c1aVYy+IsUulTdqv9rAOCadSmHoXocMV3f4dM+RqbrKqmwalPcLA4uJyk/lmfkvH/0CkPcEWbNU6zPUC6xM++9d4RD7FGEMioaHAwTupWhspjRMAXD0AhfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nhoziHWWL4d2CXGGBGHNj02sMVFHJCwJY7jOQwJOQ6U=;
 b=D/8FPP9bHokS0KHcgBoafkplpC/2jZGk4URwt1pCP+2XenvduWl2fhYLI7e4fdpx3+d/ggtUzWpoMcTtdy1dZz90fSX38v8a8IV00j9eDVg9hVMWtiXTAVZ3M9O937L9sl3ikuKN0dF2r4igh6OaNhVh81lqUHDreWgaNbR5SGM=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by DS0PR10MB6199.namprd10.prod.outlook.com (2603:10b6:8:c1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.15; Sat, 1 Nov
 2025 19:44:00 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%2]) with mapi id 15.20.9275.013; Sat, 1 Nov 2025
 19:44:00 +0000
From: Mike Christie <michael.christie@oracle.com>
To: virtualization@lists.linux-foundation.org, mst@redhat.com,
        jasowang@redhat.com, eperezma@redhat.com, kvm@vger.kernel.org
Cc: Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 1/1] vhost: Fix kthread worker cgroup failure handling
Date: Sat,  1 Nov 2025 14:43:58 -0500
Message-ID: <20251101194358.13605-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR03CA0040.namprd03.prod.outlook.com
 (2603:10b6:5:3b5::15) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|DS0PR10MB6199:EE_
X-MS-Office365-Filtering-Correlation-Id: 87ea3266-79c6-498a-0b0e-08de197f0122
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ihIfCnGrNeXij0zn6FFYwBCH1vB/Ka/4VcOT14jFcVGhZshyWvTNmJk2c4GA?=
 =?us-ascii?Q?NH8mnBVDIghl4ttW+6iD+uE3qkcYZ4VzRJKO+pVcOpx3vPAItjW3eLVFwLfU?=
 =?us-ascii?Q?D2KnO2nnaNe2pNLr52iujc8dIi8zvg7CJCSVydcpiGl4SV3x1InWSYi3mzhx?=
 =?us-ascii?Q?PteZyhz10BicGAXcyUpZmktEzCZhMbM9rWAdMclBsrDLfOeg/daxzN8uWL67?=
 =?us-ascii?Q?nw6RVBH36oC9REx8kzxo14lvAcqaKNpPdNhWhe+Ws6kDA+b+9nbDNPZHI4r5?=
 =?us-ascii?Q?xA9uli52nGDAxJcUtYGlNotd1pj95YOhkSKsU/D45qWNL9/jks1MfIM6y9yp?=
 =?us-ascii?Q?Gr6X3hKo/l+9UQ+Qf/4p7gOyZFAwtr1zHQ6WmiFg2l8wC9knpInNMu+z3kfT?=
 =?us-ascii?Q?uDO480CjP89OHLGSdsz8Wk0o1qbMXFbp391V5D/v4JQOwKhHwvoS/CSugHqY?=
 =?us-ascii?Q?Ko0gxLTnMUp5MQKWVMHD+11WZ1XAIGoHePSGq/4R+AdoMqwNJV0ztFX0aej8?=
 =?us-ascii?Q?OLFc68eoBpOQcOw6r8i6s7W0QZ+e90Q0g7+x6koS1/YxdRYOIcr1i/TC94wJ?=
 =?us-ascii?Q?Nr4PJYsgcRsarFGPMnma7/Ew7qwJxKw+4NlZ17uSJ5cIQU2csgEL0mM12tvR?=
 =?us-ascii?Q?BiRjXPHk3/R6N93zG2cmFJqQtHo5mZE01/Uh4iDG+7eC3R5l7TWiESnXiCyA?=
 =?us-ascii?Q?trl5clPhn71eGhpEZKgtRlS9p6nauMgUp77Sr3lqw7YtCXI5PrumveNIUqdk?=
 =?us-ascii?Q?zW8q02lhf7UAV49TK/Yw5UD49DpjTYqZnP3R3lcEOrZaxqJUl4X3zccHwVHf?=
 =?us-ascii?Q?ucJJ3D0+tRhYbZox7b2qtCK4CfskmXvvtUoUcBJtnh/ywZGTZgozodQ19jhd?=
 =?us-ascii?Q?6G70ffylNKlfKgty48RmFGyEnh8VU5yNKLOTisjZ6MRCZsXIUxte1bRMeJDz?=
 =?us-ascii?Q?laImX571qKZWNDVc0om37+2NhnxV6S3C0IY/nREwQOudFZ2Sk9CrXesJ8QVV?=
 =?us-ascii?Q?r8czpetjQj2inv4peWqFm34PPsU6lQvo6f7+8LUBmDODdXCGY3Sy1hhIthPE?=
 =?us-ascii?Q?03niFlI6T7p6sNCjp19xXRqUQ+/eEABmIPusl/N6u0xkvY5SM/FKBezRNfHp?=
 =?us-ascii?Q?pS9AMrVcViafbXNO+NPYFnmYghow5aq/xCqI6oAtETnyKMbltfPq6Kxz0Fsj?=
 =?us-ascii?Q?qwZ9veEudeqo85oSqu8qdoxvj8G80F5WGuvwEABZB7x1muHgkAe3fGlMUjN9?=
 =?us-ascii?Q?8u3x1T15A5a+G2JAti0BltS5TceSNnevsiYS9u/IOYXzbj5UF0MUDL1KDf68?=
 =?us-ascii?Q?UfjbV1pAC+A2mN7pLayoSRFDW+IGqU4PFamVu1xl76Q5XK4hih8lPH+uWDGz?=
 =?us-ascii?Q?3Tr7xgRAQJToogp+wcdUA+9sZvueCUiPoBNd1qutB2Uj0JOXcFT9aapvVKj2?=
 =?us-ascii?Q?J9FIk9LfsL75w2oOVbKTpZg3lDwJYBOI?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?77pC2JToC28EhnhUszCXMD2e6c5onjB7HECFaqK07eswHYpPadG/PalgttD/?=
 =?us-ascii?Q?5m6jAq9pTNbvchDc++/cH/O8glwyGfKTTesITC7jcKdqyJW79fFhbUE8bzf2?=
 =?us-ascii?Q?C4czTRpSShYEPGrRNXcKT/nw+Wc5fr7fs6JSo6MShjkzRmuPUR0aHNnKNzaY?=
 =?us-ascii?Q?9wRhE1SMDz9PZLtRfsD72StLMbRuMmPZZia5Os/Ga3SN5jpMa8idGBu5Hx4K?=
 =?us-ascii?Q?243/WdmMD+1AHhkEc5zg8UWlKx5LeO/WM8qpZ4aH6ajy/FFyXUrkO/qj/AE1?=
 =?us-ascii?Q?5h+Y9FJresLQHAJoQVmN+x7NFDlSwvorbiA2J2EdCuK7h37+dkzV0WFYLpYS?=
 =?us-ascii?Q?kJq+rlSPshBK2QwYRJccQAPkN07hmY4OdlEs/o/eZRGjMEA3mrCROpli9MMn?=
 =?us-ascii?Q?5F48Ck5PzRpNnuwdABTBSrnMvNT+NBkWQnqUS5lPL6SXtXOCSiKFmD1E3vDb?=
 =?us-ascii?Q?B9z6bzTZoi0PlEDbhWh9g4Jd6SIh52t/kRx0ix0gzBF+20X7jq7kkhA/fTQv?=
 =?us-ascii?Q?ksqZuhLgM+NASp0fI6YeF6TH4+fbnV3c+7fQLGhtXPWJJc4hvIV0sxENHFDY?=
 =?us-ascii?Q?b+R3G+S3cNGrklFvXGhp9Nx6P98ZPWFKy/lHob37rbswzyEwv9dklx/nSsGA?=
 =?us-ascii?Q?zygQGYfw055sm1MUH/7+bEfCnlzm1ehdZhV3/05ZoJVK2d6xbXVmGp0pfNzi?=
 =?us-ascii?Q?strzJv07FrWVAWYvDLmelIJywftRLlnXvstoXrnS7KhAc16E788skk/IdC2s?=
 =?us-ascii?Q?eDIuPi0yxjFED+ROS4tWmWq0KMXKNWtIP34tp0Y1aervTkMtRfaWPIHeAnZ9?=
 =?us-ascii?Q?EqnrPqd2q6bvgSLO/1+6XVdJhODWAFU2uyahUnoCIUOdNYCUV8nzkaiNsI4b?=
 =?us-ascii?Q?GkpeoKaQIiNRpUqc7lDhRyi9dYp1SJv503h4FniF+Updy8IU/9EBIR+dXUST?=
 =?us-ascii?Q?h3pPauSpFS35Xc3Kjg9qaAaoe/1RmmswkPxwxpZxMSsn5Qn1rKv/Yf6xi0T6?=
 =?us-ascii?Q?IS2TnZ1Jk3yZzwlp2tCVtZH3WrmhZvuhldai1N3l4SAiv7TNX6cmT6avd8up?=
 =?us-ascii?Q?5cjFT2u4SVeBA1Hp7DCvP5JruB3YZK68IDujAJ46XENO/a2k+SyEoS4RFK2k?=
 =?us-ascii?Q?PCLY7yjMl3nYjfRxayQ9OBqrlGkXhiyXeHb6ZqEY5agV3V2FHHFfIRa+CRSO?=
 =?us-ascii?Q?exvKQOFtbF32su7GPS1j5Nmhj5W/JOe4QbE7YvTQG26laQmqm4SpoyBPWusA?=
 =?us-ascii?Q?w72Ahni11YDkN30455/EglKH+6XXbrszZHZMOirfUsfExRS+n8f/csCs5gmp?=
 =?us-ascii?Q?X7Qv1MU+qEjtWNJlvOaqptuC2TVAKZXe/tzszOEfFICjJauOiJ5cZ0Lc3KSp?=
 =?us-ascii?Q?z9QnSXroswHVAVogq0wkm5fMOOYEeEIB805Rb2mdNPcdIcx6iTDwcxj7tVuA?=
 =?us-ascii?Q?nAUeEeJCJukDzih8sSeqgml9FDY3RTajBsdC+sU1jk4t6KhnibsnAqtftjFM?=
 =?us-ascii?Q?FgWA11GX8DIHE8mZx0catr/B5IA9Qbwx8PBloPml6ofpzrAEQcfUvdSiEo1E?=
 =?us-ascii?Q?iIzvHBOX5snnH7dzAkYV8KPmZjZN4HPM+9gJrKSU5N8GHLm6Kg7oOwYEoZ5Z?=
 =?us-ascii?Q?gA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vjEZlmumzufzf3escIPEw9E5yiPvz6joSe3F9KcHtarwjGzsXMYNVckSo2jvWL30nABSxf/Fe9GF4/eEkXDsqo2SAodAlAaunnUjHUognyhm9BbWEVpK/owPPglFw4EVeloNkGa/5XBkFi1luDiC7wVDnordpU6hAAhFGXZHTCCQPYdMuC8XZ+qmTf+TsVEimlU3DsJn5YhKv1vDSxT88Ox7CFRHDSOoNmjo/0KhFL5g6QoIzBekKIU13P7XtJrimMb9FRJJheZdKzn2hWqNt5pw5tjLON+BcSee0YWwxxIklXlPZUH1kHT1PGFpopT+N1ad9I+lIBng02nbTr+P9kZq1H/gNBxFe4ueJwD0wU9PMTHTv/vuZ5Oymm4E/+tTsGXln6wCxPjkDA9OowfEttQtq4oYL0iNC4HZ1MadYuOXBCBbutY3SFi8Wrhp8k1UxmR9ZtM2ywF1eJSRYVI2LHz6ixh+rd4TKrakn0d+P+Z5DkRypafCLqbXpD1gV1aENViYV+pkXN6zwXlicFhYhlrwiYO64fzCQXAWXxNnP7kws2MKVoMk3UwKGjFdPcSO+eGbhP1EuyKBlRn6CcDcovBJIB3v+NfHDPNDpiB3zLk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87ea3266-79c6-498a-0b0e-08de197f0122
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2025 19:44:00.7237
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x3riCkqZ+kV+NtCHXqu5Bn7wVuEM6NmBy+jnyD8qk0u71zy9nQxPrTvDftljxSV7wESD2WAr9kII4RrMxxiNdbJESslnQRXmrzMG7DwH/AY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6199
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-01_05,2025-10-29_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 adultscore=0 phishscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511010169
X-Authority-Analysis: v=2.4 cv=aexsXBot c=1 sm=1 tr=0 ts=69066305 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=jF8W7N3-U_dp_guu7gUA:9
X-Proofpoint-ORIG-GUID: iZuIrKC2bCWuas-chnQ_Xc6z0iRrZiwa
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTAxMDE2OSBTYWx0ZWRfXxwSOW/y6hBMb
 6m3riZjYwEBFmS0miPZPOB7dTj3CWujaAEHF813mXHjKr7bZrM94uq3X3Me/xq0o8nmuU793BbS
 qpSGmk6sHMP23VN4hY51ZhRTsXiJ/fU8PxkZKQH2ZMMriY1PK+79wqRhIgEA+yaWWi3WynYKbSO
 bhcylzQL5tEHzdj24Rb7TO17jojuFYWqPxthFk0s2NiGAjBzNrIRfWagkG73y8YzYDDwAzi6JZ7
 meibjsbMTmrX1F95Gg4yx800xwn6ssq8rHkqFu/LFzsk+Ty3ztZs0unP26EANeA0zQtatkmtlDF
 sayTteIu0RxZece/hV6UAHNNgv40XDbuEJ9atLDfhWRCp1zOe9/iOErbSrkyf6bTD6nqhSlewZL
 ov4v56GiiMss0V7dF3QyVI4OtpU7YA==
X-Proofpoint-GUID: iZuIrKC2bCWuas-chnQ_Xc6z0iRrZiwa

If we fail to attach to a cgroup we are leaking the id. This adds
a new goto to free the id.

Fixes: 7d9896e9f6d0 ("vhost: Reintroduce kthread API and add mode selection")
Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/vhost/vhost.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 8570fdf2e14a..e6df5bb4932b 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -804,11 +804,13 @@ static int vhost_kthread_worker_create(struct vhost_worker *worker,
 
 	ret = vhost_attach_task_to_cgroups(worker);
 	if (ret)
-		goto stop_worker;
+		goto free_id;
 
 	worker->id = id;
 	return 0;
 
+free_id:
+	xa_erase(&dev->worker_xa, id);
 stop_worker:
 	vhost_kthread_do_stop(worker);
 	return ret;
-- 
2.43.0


