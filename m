Return-Path: <kvm+bounces-38486-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 281E8A3AAFC
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 22:34:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EC83F16EA07
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 21:34:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E077F1D5165;
	Tue, 18 Feb 2025 21:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Y61Fcq6X";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="LichkdMa"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6632F1684A4;
	Tue, 18 Feb 2025 21:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739914453; cv=fail; b=Hrs6m6cROo7m45ME9CRjBmNsM97QXRLZ1K7DuhckHjl0T7nD+hOEzV8SKLY06vJGD4w0ZddG8vBLkYXX+a6kdXMWcUewcV6qKlWmOHZab8AiTGREj3gqKgZa7nk0yKWa+7z0U1YvePpDOWe6O0DhgyJ8EYvQlD45UxahS3d3boE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739914453; c=relaxed/simple;
	bh=BRSz8iI991wXxBVxK/iyIvxH/Lc9NvDsuKAC6EhQn4Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=QjUuc5N7RkIusxT9kk2I8msSQPBhPk2x52zkyR0uFgMWpX8vSJRgd1X/Vh1+Uur3EyIqq+g7Ha3AFncmNeRZP0YpMKKOnB/U5+6o9RplW/+I5E6i3GCAqCGH4axaFR8WZUg2y64LAcfF8RQZDR46dW4xnXNH03IuaXp6ZXexKoM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Y61Fcq6X; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=LichkdMa; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51ILMc6Q023039;
	Tue, 18 Feb 2025 21:33:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=kzPuGBTgp6OCo4wBhk67V9qjW7uxEAcHaobp003atFw=; b=
	Y61Fcq6X7RVigif3tY6xfAV3/lNQvsoOSperQyYC58qJsm09FegXJAZ5UqyGk+Od
	JYnQWUdD85yd1zfxxwheoUFQurKhDNhspvKTg3KMXG77LYfLu/zWa/E0Q7vhcksd
	/IG0aHjoRegKEd/k6PNcsYxWScEPDxUSgdt3tIQ9c45AGv3BxCB89G6sxNmu8m+e
	a7mHy+I+sfoIMIQtSTS8PgYJz229slcpwYxGDGhUp6KP8ww50fEFnwto/CBXBNxx
	SZegyuJrAr3J41boZrDYN20UhMG9gvuN4u96PMUa+XDQfnquzSRJCeg0mfRLMrGe
	m0H5bkcRz8/5IuYvSjN43A==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44w00prafc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Feb 2025 21:33:43 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51ILAp1D012061;
	Tue, 18 Feb 2025 21:33:42 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44w0b1mr3y-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Feb 2025 21:33:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M1gfFpD2z4zjAb27+2ntNbweWVR+VN38sG63wUh8F4f3nyIX6bz7VH/1JD/mGiv5GRE4IgaP69bI/9L7j+1H9ARRTiu8UlAaN4UUbSx1h+yuHwDcnhPxklJnlrLJBq6wO7Y6RoyvjCB76oCcwONQq2XgYlW9SWW6w5h9zteL32f8h42J8ffy2DkEwxe0dz8khCt0/sH2lYIwUcVtnV0UX07yOVCYNKrKifccrpjK2J5tWMYmK0nLIzOreZJvB7ZlDnbk+RpEzzj0P20cQZYlPoRfdTvafEIoZ656QxqGCyjyLEpKkDf9zkoVk8ffwZ4mm0d/aRZZ6kaz/n6ixWn1bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kzPuGBTgp6OCo4wBhk67V9qjW7uxEAcHaobp003atFw=;
 b=DOR3pO3g2Y4l20v92X1nSC6FYtfeXlt+eUDzi+/o6eZOv/gi2Bw1+mnTTf/+SStfJnZvf0SWrcJsOTTS+WKtmV8NgclPXCIVJmRVLxjORDUaDQi8vR1Vjbb1yMJkPsKm//Cj8u4yVtiIUK+zR0rd+5acMekyncNVl2sLvzmX2boUFXs4gRV/qWNSY3duXr7VkWZQfH6ic9Ed1kBkwVNjndrD1GJ1D4vJaHkle5bxEmr3JW4lN7yeq93coHDEZZn+EpaaVvq6asVYFnNe8kFWIoehxuLWqdWyNTVKAMUAu9YzLDlR02HVfXX50tKxUlinTIk1+9SU5nnoeGGOXe0QTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kzPuGBTgp6OCo4wBhk67V9qjW7uxEAcHaobp003atFw=;
 b=LichkdMa79BASiyoGsHTHX1LMdZRpMLCGOPafhnM6RxUVsYmtFcRXRmT8I55S/Whh+19Ibjf2Z5UAg70mZ7iZ8Chf06jHTB+pTMAx5jtT8s/RB3WQinHzgqbLNbUSw8TO+1SJCKSgVHAakJRm8YFbQMbm3P/ljCMWJK1MvlLwK4=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by IA0PR10MB7275.namprd10.prod.outlook.com (2603:10b6:208:3de::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.14; Tue, 18 Feb
 2025 21:33:39 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e%2]) with mapi id 15.20.8445.017; Tue, 18 Feb 2025
 21:33:39 +0000
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
Subject: [PATCH v10 01/11] cpuidle/poll_state: poll via smp_cond_load_relaxed_timewait()
Date: Tue, 18 Feb 2025 13:33:27 -0800
Message-Id: <20250218213337.377987-2-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20250218213337.377987-1-ankur.a.arora@oracle.com>
References: <20250218213337.377987-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW2PR16CA0030.namprd16.prod.outlook.com (2603:10b6:907::43)
 To CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|IA0PR10MB7275:EE_
X-MS-Office365-Filtering-Correlation-Id: 45999628-f45c-441a-dfc3-08dd5063e8da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mqtE2z7cCx6h1rJf6Z0avOG6p3FLwBzC0zNdRtyMi/l0kxJn1xzSQ/IIArOc?=
 =?us-ascii?Q?nqchDtn8VTiMG7CGIH4+BFopCexipEUAk5FpKWkUZm5WeM42gfBFfKu/39ND?=
 =?us-ascii?Q?CFhWOOCFj7ar5wJUfbOfB87v4OO4+CBUkpj5o+Q2LA7l/sr5kFeYrmlAyWtW?=
 =?us-ascii?Q?na74Ob5PlErgI+JYHAspdbR8nExKnMb9oZVHv/MNUQuFIdrEFfu8nCE84YJv?=
 =?us-ascii?Q?qSh5INJuL2eKCqsXZc2d4jac/nKF0PcMOfr2XQ9jOak4TDdsASXqCsRsPDEy?=
 =?us-ascii?Q?UMoSKla02UrSsUY8wDHwLXEyKzs3XA+00tgjmgA/dV1KJ/QmfOZE5h3DgxjG?=
 =?us-ascii?Q?+3CsJJjwDZMhj0O+9MQC2JqEcDSlPyXL84NoRDz9S/Q0nqo94e7GzF6Vd5XA?=
 =?us-ascii?Q?LfrsHUUd7lvdjRqbakrA9P2AGn90cnObArmXbypBL6POUWJRGFZHX3glooIx?=
 =?us-ascii?Q?K8WDSG3N2VYNeH5wZCh2VdXN2hmCvPrGm9qWRjpsCgSSDLrDRuiBptwVQlPW?=
 =?us-ascii?Q?o1RIdb8i5zTOuPE4i225otcPTdyzBELvZjavAQk299uJYhvcIpK00NFBCBsT?=
 =?us-ascii?Q?7JX2WJN9hRX8EbcSlWGOblXYxXYWhgPplUmyQualR87HHxXAiZhVsl2LkZjy?=
 =?us-ascii?Q?AlLogG2vju+rRGQmFAvy2kudKdfaA2NMWDD2flOiiUCvBljCZ8Lbud5MUtlF?=
 =?us-ascii?Q?jQxs2mNYHIEUvaxxknY62MUFngzT8YWQi1YWdzpWmKiLK/g+vqiWmxV6jw8Z?=
 =?us-ascii?Q?XuTbtka3L5N+YI7aO1uB/5iDf/lqRJo9u4Mzr5jCLSX4FIwRPyQDlpfPQRhj?=
 =?us-ascii?Q?QyNbVFv79voHn2owyLrxjTp/G/ELz7W3kwDMxHqoc6BPFMCqis99MiDeAGu9?=
 =?us-ascii?Q?Qvs3qY/sP0t+a9pab6n/cPr11MF64oSE3ruR+d85BERCq2nHc6OJH2vP2lix?=
 =?us-ascii?Q?W2bUYu32dLlKGibmKcWvvJNK5NdyBAIlzqn6C/SzXr8b0gFzjg7HpWU/Avxk?=
 =?us-ascii?Q?mjHiZBATBfW9vj7u9kZOiEDAxpqp0q//QvdEBgxKjM1AE5JrJiJMsG84yAG2?=
 =?us-ascii?Q?3V1a6sR8ijt2HmZHL7VMMGEm21PL8nXebfySq5SDmlNVWFa6vxBIiWqhIyaD?=
 =?us-ascii?Q?m8QOb/6WL0nIUzk8UI4lOxzor4/gjaR/02GaPEZAPq5IiquK1h8boivDKqQo?=
 =?us-ascii?Q?NBImrm6Suj3iELjy0sp6KtgU+v6ekwl47pF1Dph2OFaqZnw8y7Jn+OaTTD6J?=
 =?us-ascii?Q?E2CrW5PNZMQ9GufhUAl46+qh1H+EKBfA0S0M42QI5t9q8ULshhvXWGAYvTfU?=
 =?us-ascii?Q?KouDHVYegM7k55YdPM7bW1Lp5FIW0xE18488hp6AN73vJwLdhRuGi0bad30q?=
 =?us-ascii?Q?+xONthAymtlYR/SbYvExRROd/aO7?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?N2p3jI9eZHFZHAcAWjEJXhpGnbY+VJWFsrBLhdkThPwv2XTfb5yr188IEZD9?=
 =?us-ascii?Q?qkqOz6bSAJGp+i9Bk7Q/vKJDz2UVOQ+9JqZCsEeUJJoKjHOTz/V4v1u17VX7?=
 =?us-ascii?Q?hJ/7sCCwaia/tNT1dB2ic86j5C/AgPmYLC/Bwp0rWVZ5ZsQmA2nzKAzRZveQ?=
 =?us-ascii?Q?khNq8fCZnkJmAhut9o3vmHS5+hTIFkf4E8wzAl3JUpQTG95qdO7iPNv2U38i?=
 =?us-ascii?Q?zdGXzFOEc6KDRZWxBt6b3/Bob35/Xln2TwEocUxtyc1uCbQ8DXC4mZi3xgR2?=
 =?us-ascii?Q?XPZDj6anD1HtjLz4Jv5MHBiiiI2VCgWVK9MaIYfzCZo/L0b7Lf6+a4ylzUbv?=
 =?us-ascii?Q?o6bbExXdgiMQU35FteKSz4z9G5LOwy/R0G8gizenjq1p6xjJV4DTTna+J5M1?=
 =?us-ascii?Q?8vP6LHvp7VCyPWQIIAoqoa4znpOXfDHBm4DjCoRzt8uVJFMlPhgnrJDLKWbU?=
 =?us-ascii?Q?BAntDIjwF+GMHnk3LrT6jlcV0fBG1EMOqRlo9UQnIC14Qs7KCbGQ+9PXy5Mv?=
 =?us-ascii?Q?I9MxCbVplAA8g/UH9NKbt+extQV6EYXcytOhvcSFDjwjMwzFwGsJE8bF9F9v?=
 =?us-ascii?Q?KxswozIPJeNsWS76vHXzn/p+6u2+NVCyetc3zhLLhNhwEiyIzHS3qNYuqWL2?=
 =?us-ascii?Q?rlBYc2pf+EItle729XB6+16XsaCVDb5C+AlDxN2j3xvX7ZJ+ZVcagVSnQthM?=
 =?us-ascii?Q?+OfNas9Io+vrtQQheCpNWCrbLNJ/3U7e9UKbXmaof4IBeAKGm+s3qesz6thJ?=
 =?us-ascii?Q?hg/DGjokPLk9apGn53iixxg39JqGnEOpTPfvCw7i+11hDlKiUeMenlURf6KQ?=
 =?us-ascii?Q?iMJNw3bw6ygn/6lfNlUhhptR5Y/emPqh08Sm5bZBFUCbAg01GhZWW+4xQkpg?=
 =?us-ascii?Q?vBeELkz3j9LZPaeUc0tHw3q07g8irGD9sk9pnMcQqlbBi28xgoY23eZaTnSN?=
 =?us-ascii?Q?QCHlqVFG2Gxst26Iuq0K6KGehHugxvAwho4afoBZx1rCZba9iDK5RoPTd5qY?=
 =?us-ascii?Q?ofbgfjgIMWpwxop+ee1OChQaLPQa2Yp01CDJv5tZHCn0UjFRByHo3yMkXXEC?=
 =?us-ascii?Q?GncRuN8B5BMQmkWdD4CfxbASqB+mHP3JnVrGss9vjkPMEvZyfjT8K2JZoRxQ?=
 =?us-ascii?Q?J4aiVDZ8hkoXb/tn4dV/hA6KCJtIYezETb/qiQslU+UjNjcf8Ra/d1T2U1Wt?=
 =?us-ascii?Q?sd6anqIcarmFIXYFoAhnKnr08OgT2ZLbPcrTCB5rI0OlSesZ+ULw+jQSwjsr?=
 =?us-ascii?Q?IKGMNDOu89wjth3uf1r64YJ52CAXKWwDc4wKt4xBF6opjX3lzRIfRaeb8Fdf?=
 =?us-ascii?Q?jbbOJj7LkgrR+6FMlb6tRSvxD7EzZuagFl0DHSrY5mbmWJp/AjEgxHKOjDkJ?=
 =?us-ascii?Q?g5kwjIV3qk37myQUchURuxF5zjoH5Xt83urJgTa7yxIyEQ4gn7wVhMcFRbqV?=
 =?us-ascii?Q?GiTY7euu54fTXclkhMCjHWlTXgQEeX0xUxGkq3aE2yAKeWJgS2c2LBV/Zv2r?=
 =?us-ascii?Q?dxJ6gJHutYf/uNLhANcdxslaI7MRwx3YylGqURDwhPgfNzXlgFOwJwnUmsar?=
 =?us-ascii?Q?gSrXoeszQq7X+tp9OZNdflzgrDZ6TZeAUclZ4Mt9SR25WPp8XQr2JQ6S9H0H?=
 =?us-ascii?Q?EQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PJaHI2T32YxdqXzMZruebeZ+UlHGLsRz2WnlJXMPrDOtp+MLj0BCfDj+yV7pCvMUd0JaHcaE3I4dZEC815fHP4SX41cjzjwrU2fRhU/LuAJrh/sa4X2qegDagMqe7q9ZTdmOGzrDhFQ2LWa3Kqd0Z5SlLyRAYEWKVSA4wecXbGABjCMB20t8NSrG7zTDSdEJ+0xX+ssoHjiPPx5lbtg+dsBRcqMqmEoM2YDb5Vg2KO95I/7Rl4xsEf1KjnVMIeDITj+sGwMKlYzZauzXkawrG19OYo3HxJkik471ZAGgIhkAKuPBZ9H5XyBKM0OffAlDC3/mr7EdsY/HSLxT7ho49Vaf11XAFQD7dU7tWnMcibXLjgCdavmMDDsz1ZuCU442XfiqkxrC23d1xX2qo8V4JgzbTE8QeztaEqyZhhmhyuEllQ4olO4I62cAE5QnFyajVD5KnUZ2FstW+rHWVZWnZQr3gwor4DBO0wmrD+FXT71UUXde0WK2aVPKwGCDYWLf/7QUGKpm1N0RWXk1wl5s4X0bXWLPnxE/5muvwitzXeBBTWI9DeZOk3UAm+ktXq+6Fn5I2JrBfZjuW6o0Xgj355/O2XmPF/8YjBOYdmjAn8g=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45999628-f45c-441a-dfc3-08dd5063e8da
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2025 21:33:39.6523
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rz8CrJbBp+9YScSWIW8e2FediVXtDc1jablXwWPBEonMtUNjhDLYZK6EI6GA0xpy5+61Cl55R3Ap2WsLXrudSyt65RpL2Z9fC6NQMLZZXek=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7275
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-18_10,2025-02-18_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 adultscore=0 malwarescore=0 suspectscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2502180144
X-Proofpoint-ORIG-GUID: CfzoL4T71IqIjzyp0YAAk9YD4zoy6tr4
X-Proofpoint-GUID: CfzoL4T71IqIjzyp0YAAk9YD4zoy6tr4

The inner loop in poll_idle() polls to see if the thread's
TIF_NEED_RESCHED bit is set. The loop exits once the condition is met,
or if the poll time limit has been exceeded.

To minimize the number of instructions executed in each iteration, the
time check is rate-limited. In addition, each loop iteration executes
cpu_relax() which on certain platforms provides a hint to the pipeline
that the loop is busy-waiting, which allows the processor to reduce
power consumption.

However, cpu_relax() is defined optimally only on x86. On arm64, for
instance, it is implemented as a YIELD which only serves as a hint
to the CPU that it prioritize a different hardware thread if one is
available. arm64, does expose a more optimal polling mechanism via
smp_cond_load_relaxed_timewait() which uses LDXR, WFE to wait until a
store to a specified region, or until a timeout.

These semantics are essentially identical to what we want
from poll_idle(). So, restructure the loop to use
smp_cond_load_relaxed_timewait() instead.

The generated code remains close to the original version.

Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 drivers/cpuidle/poll_state.c | 27 ++++++++-------------------
 1 file changed, 8 insertions(+), 19 deletions(-)

diff --git a/drivers/cpuidle/poll_state.c b/drivers/cpuidle/poll_state.c
index 9b6d90a72601..5117d3d37036 100644
--- a/drivers/cpuidle/poll_state.c
+++ b/drivers/cpuidle/poll_state.c
@@ -8,35 +8,24 @@
 #include <linux/sched/clock.h>
 #include <linux/sched/idle.h>
 
-#define POLL_IDLE_RELAX_COUNT	200
-
 static int __cpuidle poll_idle(struct cpuidle_device *dev,
 			       struct cpuidle_driver *drv, int index)
 {
-	u64 time_start;
-
-	time_start = local_clock_noinstr();
 
 	dev->poll_time_limit = false;
 
 	raw_local_irq_enable();
 	if (!current_set_polling_and_test()) {
-		unsigned int loop_count = 0;
-		u64 limit;
+		unsigned long flags;
+		u64 time_start = local_clock_noinstr();
+		u64 limit = cpuidle_poll_time(drv, dev);
 
-		limit = cpuidle_poll_time(drv, dev);
+		flags = smp_cond_load_relaxed_timewait(&current_thread_info()->flags,
+						       VAL & _TIF_NEED_RESCHED,
+						       local_clock_noinstr(),
+						       time_start + limit);
 
-		while (!need_resched()) {
-			cpu_relax();
-			if (loop_count++ < POLL_IDLE_RELAX_COUNT)
-				continue;
-
-			loop_count = 0;
-			if (local_clock_noinstr() - time_start > limit) {
-				dev->poll_time_limit = true;
-				break;
-			}
-		}
+		dev->poll_time_limit = !(flags & _TIF_NEED_RESCHED);
 	}
 	raw_local_irq_disable();
 
-- 
2.43.5


