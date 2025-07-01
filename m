Return-Path: <kvm+bounces-51224-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CB254AF05F0
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 23:48:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C3EB3442824
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 21:48:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F25B2820A7;
	Tue,  1 Jul 2025 21:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="H/RP5r5D";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="AZeUHFry"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2FF078F5D
	for <kvm@vger.kernel.org>; Tue,  1 Jul 2025 21:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751406515; cv=fail; b=QhEvQXfkeeGlNY4lecJO6j0xOUiDOQkt6SI++KZJKkzVx/CBPTxM0MgxhnfrPZ6LJlMrAnciFXa5K6KMvj+UGSKwnnipPK1ocX4j8HpvoKOV7r5Lb+YbfW3ovxEqDdpb9oN7TveTfIaFdFaVTUbqGnOLdlpaY19Wrw8bCA/c9I4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751406515; c=relaxed/simple;
	bh=ITqBepdRPpe9LXV8nhjuJUxSCr19bBWWRUAp5pdQGUc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=h/VuXJu8Zt+FmRSbQ7SRlbp9xAEPrIC7uNeLUkikqSvtjnMZwiuYh2pkzvltmTASQfy0JRVW3DV/ft1+iNtR5EuKL8+10LGeAQegyb+JmYGbA9xDome2if7cfKpjrQGKr2FukmKgrO+KMNsmTazpuwQFT/8aSj5S/E6jj3yi5zQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=H/RP5r5D; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=AZeUHFry; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 561JMe1m013947;
	Tue, 1 Jul 2025 20:01:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=PVzoWoPK4Vj60ybjBS
	qGxStftgbMrwd/tGWICxdmOQA=; b=H/RP5r5DlZ0kYwY399hngy6B7iRdUPjUGl
	jh1jiXkyc56IpoxyqUK1J9OcPxzQNa/5CeXz4PFAUcAxx+uFpeaqFAhDw7nNVFlv
	4aiMEYqULwtUmc/eTnjvaryX6aNpDQyuTd+m0BaiVq+iZLF81VblyW2ruY6I09sY
	UYv39rR+0hlFKWMClL7vkhkuGsOJypva5aJaDxZH9RZYlr+XYoKxzDft+4EaTvOT
	gxcD5NmHPbCtdPyPu8s+gV3Bc8LwHf47f1o2PGlX0i6aUdsLJ3iELUkqasenNgGu
	GOLzMIpS1spMnXR7HvR3Zk2ajk9xEuPpcib6T2CBJJVKm8TQPDCg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47j766dkv2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 01 Jul 2025 20:01:46 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 561JckxV024991;
	Tue, 1 Jul 2025 20:01:45 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04on2089.outbound.protection.outlook.com [40.107.101.89])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 47j6uhhe4m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 01 Jul 2025 20:01:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oEr6BT+c7179TLrPoVxI8CdlHNMAyxr7xCHdffhy8YvPvKbB76x04s/m/Xg7cAFSJJz3VxL8ozWhHEgPMurbES+7lRlsav+mXqsOLBf8k7rbyKwg80pnxECrZX/ZYij0GYcfmu+512wIhuunLd2JvFsRLGI9IiMmugm0iknqSAHbXvRFN19pYMnyQ07uCg0C/La19WzqaMHqxr/MQoO5oWNkt6t9Z3pbvz4GS/SfriDg4otVSYMbSjbxkTchnINa+E1VFU3vX3pfpQp8NnS2gEDdHZ14Rr3oRFTFkw5iT7kbTdjHq9sFVUEeoF24kdsmgU8MORxHJINn61VvR7VEag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PVzoWoPK4Vj60ybjBSqGxStftgbMrwd/tGWICxdmOQA=;
 b=MWtzU5podD7WyLpZ4NOlwdPq6qtQi8JC+Ayg06tumeNC6U/TipRDvq3JJr5dSqts84Ki3pFRbDiJwxcgpNn/649F2YdyglMYsXf+YlpPhjHVUGvNicysumpjC1ZvGmVx8dRLU9qxfVxtCqpO39vrUaUgeEJI7hULF7J+gZDPNya1h+cmyEQbBe/NdsfWoqWTDFYkplTWOTJ7e9wFka53/2RwnnnSv2l4jDMfDngsTmFexN0meB9BI5D6GlOqu7RyYBstHvEjaMgC+AlSJW9sga6SdPpYReGrVdXhK6NsAwdNRbL7xXpdK6Kg+0uINZapBKsyVRfVAvb1t+hyoSUvoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PVzoWoPK4Vj60ybjBSqGxStftgbMrwd/tGWICxdmOQA=;
 b=AZeUHFryhxs/m2/+jn/K5JXMXtzlloF2fjGpC+O+FLjkn/pO3POpGUv5cMltMD10xAQdSSJBioQ1w65XnIETKt+vKkWLeoapjysRxVKolX1NxWHQ3nY9IG4pRPtk8kgO4uaClJp+HBInnd/z7JTKK/TngZDYLk7vmEbY3Vj5vGY=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH3PR10MB7393.namprd10.prod.outlook.com (2603:10b6:610:146::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.21; Tue, 1 Jul
 2025 20:01:42 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%6]) with mapi id 15.20.8880.027; Tue, 1 Jul 2025
 20:01:40 +0000
Date: Tue, 1 Jul 2025 16:01:21 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Igor Mammedov <imammedo@redhat.com>
Cc: Zhao Liu <zhao1.liu@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        qemu-devel@nongnu.org, pbonzini@redhat.com, qemu-stable@nongnu.org,
        boris.ostrovsky@oracle.com, maciej.szmigiero@oracle.com,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] i386/cpu: ARCH_CAPABILITIES should not be advertised on
 AMD
Message-ID: <aGQ-ke-pZhzLnr8t@char.us.oracle.com>
References: <20250630133025.4189544-1-alexandre.chartre@oracle.com>
 <aGO3vOfHUfjgvBQ9@intel.com>
 <c6a79077-024f-4d2f-897c-118ac8bb9b58@intel.com>
 <aGPWW/joFfohy05y@intel.com>
 <20250701150500.3a4001e9@fedora>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250701150500.3a4001e9@fedora>
X-ClientProxiedBy: AM0PR07CA0013.eurprd07.prod.outlook.com
 (2603:10a6:208:ac::26) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH3PR10MB7393:EE_
X-MS-Office365-Filtering-Correlation-Id: f12a0a51-5d13-4cbc-d849-08ddb8da1842
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Yc+jG95baWOQKeVUj14tPLPNbqchlpFtBeDAVUBdiZfFtO78XHHbxeTJHaUe?=
 =?us-ascii?Q?s5/dYjkNQSPrqzBiLSMN9tPEbNQzIMfRfCg0nT0RpH4m8IaL48qx8LbGQt0W?=
 =?us-ascii?Q?IY91wDFL5X2NbFbxtB8AazLE68hY9N1Q1Og4dISfMtEMXPTLE4p/b7Oxoqp+?=
 =?us-ascii?Q?62MCXi2nY67oCoO7nUCEt3Dsmm7Lig6tZ0ew4Sad1DWMMaIA3Pommc0q11oK?=
 =?us-ascii?Q?q1ZS9R7smw2FJu3NC1WBRyQjVGNvCD+Y8mv/8r2Th+ar2LkCWmdNXyI366FG?=
 =?us-ascii?Q?/8YG6+CNdBmU4xFcvFzrcF9ptX1DdrOA0Sr7zdLq2vmoLAeub7oOgorgfPni?=
 =?us-ascii?Q?AfS52BzxTFf1Nh52URTPW/6qdXuyZSXrQo2bIVaEdaq0o6W4K+M0XJgWY+0d?=
 =?us-ascii?Q?/fCeiqnwz8er8rGCAtrfKJPbUGmunB/kJaWuCciAQve4ISv3UpJUK/yFJxmL?=
 =?us-ascii?Q?kEzJw9Y0tD9GP2Lxa7F0pXdyCMFG6945TX781/FpUywLJSMXFwt0wpLM91Qk?=
 =?us-ascii?Q?REKzL1Gjnw0+iyMpxAP5rx0flZ2zDjhVHcGS5g9GiqNxh74Iua1zzswIe0xR?=
 =?us-ascii?Q?YYWmuP+auXSeT58XFLv/427w52WIlCUhdKss2/NEuIiMgq/jbPnU6c5UvZWb?=
 =?us-ascii?Q?cpbTB68gFt/S6eu349ZE+ftqAwgXJvWuj176oxKjOAnv7fAzIFkzIY80rmW1?=
 =?us-ascii?Q?gP0ivviYOg5q7Ea2kDC4H7GafUcLvEK22XJe/wU/rI4nZJpuOfSNvsqFFHqn?=
 =?us-ascii?Q?Zwfie851OlhAXnv5iL/oQ/FyIYE4G4kcgddM8Yv2jWsxKCnmqDR5YU8fW7qh?=
 =?us-ascii?Q?dSgxHR5KyksLe9YSv6PUvqAvAD8EgphcCsAsh8djkg57wAwWM3ek0LVJ9hBn?=
 =?us-ascii?Q?aDJzdZkBWVxq5gAaknf33ezN0Qe2yw4v5hlbVo0dE/0IaHAFc9Ykb0fGjLCW?=
 =?us-ascii?Q?9p0eZXymAnDwCIhKWqP5kezU3u07l+GalYLy6ajTpiGe+xeHZ226Cd3ewBa5?=
 =?us-ascii?Q?X3E8ccGpeK5MT60GzOelsRvZs5epqB4/Ns4T6O+O/bCuyuNg8yG7wIyLWtgu?=
 =?us-ascii?Q?mISgaejERJ0VzGwSICL3zElEZcSRlVWp4EjWXYn7h5ecs71WbYH23HG7c3+0?=
 =?us-ascii?Q?DhXHy1h+HG+0QfbFKOBTkXESlZ0HuCdz/qpqqdvHZ9aORzF3kizIujrZ8tpA?=
 =?us-ascii?Q?3Z5NIRosBBF4UoWKxXHFU3+NVnaWghxL4lw6jHhBEvSO8E6zALIpVFQaAbSC?=
 =?us-ascii?Q?k0gWyaE+VSlCB+c7txHkjGN5DM3C1a8CK3CO3hSPe7ro0X5P4MBmDTzrwEnO?=
 =?us-ascii?Q?L0drJ3yJTXxPJo8/1tGBp/KC/CyXwdWUcTY7Tihl+D8iTwJ5KXwh6p28EXjF?=
 =?us-ascii?Q?+iI1H0xPLHPizxRH/NERNTNmXj454QpAMfd8zzwQJD2hAy4U4NpcYofqj+cu?=
 =?us-ascii?Q?pWwi15N36F8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VoHHBe+CEPqs3Jk6vGrY4SCi7PAtm6QUFegnnAFnTEi6ihngy+3gVmXb3X5a?=
 =?us-ascii?Q?XZj597RzfVE1Ek8CWfTu34vvVQs91NjpuzQz2N/8J9Rc6tRlqkrc+7dZTLYE?=
 =?us-ascii?Q?/DzoifeqREY1Q0FwyCN+sPFrYNO0wOCnbzWcguCKV6aom3K4dz1wF/9Qd1/7?=
 =?us-ascii?Q?rIGPOYLO37Lb+DO4iSWIfxHZhhbmS4dDSHNcbYGG1ocdJEdLeteH/LBxjfsn?=
 =?us-ascii?Q?Egk7xIWBMTHKpWldfTTd4HJqTWNMBKneKg7SNIoixkXyTXOi1V1e9dNdwzyt?=
 =?us-ascii?Q?gvRIPWnz84vXP6Lc4GuNKFe6/O5yhOhXFYNm4dsSY2vQMqWLQaD1JJ2N2bY/?=
 =?us-ascii?Q?j+G6ldIhZZGJWm4S1Sl+ZxirEoeK4AunUXDpcO+w3Hj8HevAnwuY+zsAUWnj?=
 =?us-ascii?Q?Fzw31FV8ssx5zUlo3X69NeBy9n8SD8+NpbiGSEnp/lV/5Ft7RJP9J0zy/EEC?=
 =?us-ascii?Q?aTZZuMohVbJU6nEG6lBd/9D9HbRWPCJ8AW6qrypKUriepBHKZ/SDUCNRHyuU?=
 =?us-ascii?Q?mIulUhouZepv9xT434XpCM5IQVC1YR8R/XFlKfdVsF5SIWZpVoBtYZixAKzm?=
 =?us-ascii?Q?2smKwxSu84Z2bqwL53coHVYUiOp+iRLFpTOtW27lhrMGaa8ydbefMsx68alq?=
 =?us-ascii?Q?oXbyLcPcoDdsQhDG9K1qUeZ2y3HFRtkfWmqQXY5NMpsbb96aefBCGYZDKjEa?=
 =?us-ascii?Q?UuXV8YN7h1KSOCR/Rf+IO1Buvzd6+Fv3MVSK6SudaH5p8zN5zlX9Cp39tXwx?=
 =?us-ascii?Q?gBfpULBfUtM08pL9BOdxX9Sy0p2FZRI6adEQav77Zhzqiy3HU7GeDTJ1y3Tk?=
 =?us-ascii?Q?2v6bVfnheIlJZV45H5sTpbJmEWDbojmmsmff+4ucJbDgFAwaR7J0t5+aBdV2?=
 =?us-ascii?Q?nnSFVQvafCHIzZRHWonobZK/a1EMj2aQII1XlqOYL8+8LgDYscJSQfRXbUqj?=
 =?us-ascii?Q?PRj2pdPx1tU/FlSqRhWUTtL+TCU1c6MYrWTVaWeJyFwi7dzWWKCIzZ2RRqSf?=
 =?us-ascii?Q?PCs0bjFmTQWA+zHuaehatUzh2r7b7lpx5OPFK04w9Y3ETVHOd4FV1955qnl4?=
 =?us-ascii?Q?hjBomXUmMdrZtE2J6M0PGd+dSuJgWbCs2Htu9q1G0wUYTDaWxNgVA63QkenB?=
 =?us-ascii?Q?geUHmcunCKVgJTQnyMBAvAylwWTWFFznWhEkRnyyunKYFYntYqPowJ0wZVuk?=
 =?us-ascii?Q?UKZtaGB7XHWlJeaGJVs6YrbT9WoQzCtcQ/bP8jHKm5qIVnj2yp9dL/8os/mR?=
 =?us-ascii?Q?sNLAuZr60IYg5LQibt9amLkV+FLh0KbsGxOp3A9j6tDqnlqS6abrFlm9BApA?=
 =?us-ascii?Q?ZfuYEoGvkUIEeAtaX/trHtisCJuKujdhFqjO+z/NM+f5GmmCCCJNOjw6AvjM?=
 =?us-ascii?Q?wFOGgNUv8a64RZmpPEBcyZV6heYlsg1ZYMc/RznsNpqZr27JqXE4zIR39Pc9?=
 =?us-ascii?Q?VsUUh0TqKh45GWqXjmP4s2av95rfZNWOAhArFcMCz3FOwgdRKg09cldROq3l?=
 =?us-ascii?Q?s7hsOt4tRB2jZR0i+EEY3yiF6CyhlCvjIJnDuRJK5l3EaIgt/x68JPV2f9bI?=
 =?us-ascii?Q?QpLBr1GkCNlh5gAyvVkMQ8H22GUUg4/2o7+unGuZ?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/US59JFHH72gO4H4xz9V1HucpdfTfvGh6LnHvsepnOHaspGHq4eAzctKrsSKn9tEgsujF0smbRhfP8DJpGUNWReOmeJoGxZ7mplVSG0ynxdDQkTW1ncHUii9U+FqrjqbsALzlhumhiQDq+6r472y7OWJZGJhM2uEe/DTF4YT4I6jUhD0CmxeunBogLPjcEQCIGtIq/Gml6v/z5vgatoSlrNkmSritKEMVNFPjaYw2n2S222D4fZgNxh+lrWG3vMqh9rVGlgQ4mahlECi49xqqMvGedlV9d7I/c5niMbNv0f0vZwKTqUxgDarBzDN/WpqrLeOPdZontKagaC60bhqSMB0gKZq5Ed6861EG/uoPHhDrpkDEaJkZ45eMbYLl98M4fc1aK6PbaTXpteP24JSCMsW8UNSGAPj1UTHTUgwxOwCB75ixyX6jCgO46T+R8jq27YsP6A3efG4HX4SCbpXNXgcXbKjw9FhZ8y/15VA6l35I5K6fa0zqhmMIpTASR3Fg/1QkdykkysEZQHcTlieLMMLY3aetR0FrMP2gty2SQkRbTbpg0dI+27vO9b7Pqwm9ehYl20vDCjFRSWLTWLMJLb4Z/d2kXF5LcJeIhb5x3Y=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f12a0a51-5d13-4cbc-d849-08ddb8da1842
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2025 20:01:40.9311
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1ok5uoL8vOcKbHpo9UFGRsn0EXTf9uHMJQqtO7obIIBSb7LGzqeDeNy01veZQTqDE40GtIulMlW57sdD2GU1xw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7393
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-01_02,2025-06-27_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=974 adultscore=0
 bulkscore=0 malwarescore=0 spamscore=0 phishscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507010139
X-Proofpoint-GUID: OjLCKAy12MculSDGaRpJd0SHJ4wW_jBo
X-Proofpoint-ORIG-GUID: OjLCKAy12MculSDGaRpJd0SHJ4wW_jBo
X-Authority-Analysis: v=2.4 cv=b82y4sGx c=1 sm=1 tr=0 ts=68643eaa b=1 cx=c_pps a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=QyXUC8HyAAAA:8 a=4j_VvojYhsELqbnVhscA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13215
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzAxMDE0MCBTYWx0ZWRfX7G1fMD7PUVuM P5iBL8CPvMXvq/scgCLwREtD+Cijd6Kk7UgjZgirEuuGthqkvidtgHgxgJzTjWMwKDPksAuON1O oyjCK8EdfEAz23QdlrSor2d0ueuHpgK3AWfFk8pnic2m2hYBUEyYJbWqhVN4MLGX28e7pmdnX5k
 CwkU2/QKhFUgS3VQ6jXmuxM/cEpnPkADz1e47WiH6CSCawg5HcmPJwFDzeNf0e4TW4jDnazidsK FdmFbumiIk279aV9yGaQy39xXPPUy9ho9cx8w6SXlk/Pp0ixajzM1ejHHImMQuTkbAdCWr4D5sz DZhkuZmbbBAABy/KOdLjSm92UneBsiRyynUewAQ0fBR9X9oxsSJnPvc1DNpW+WpoI1QdvnIi3xS
 Vwr39xUd8ZzP7cPRsSr/J2PSD7lucGOjXGE1zipDWOsj1AA1mbx7mOzSHSdzdhi6a1Gt/7U/

On Tue, Jul 01, 2025 at 03:05:00PM +0200, Igor Mammedov wrote:
> On Tue, 1 Jul 2025 20:36:43 +0800
> Zhao Liu <zhao1.liu@intel.com> wrote:
> 
> > On Tue, Jul 01, 2025 at 07:12:44PM +0800, Xiaoyao Li wrote:
> > > Date: Tue, 1 Jul 2025 19:12:44 +0800
> > > From: Xiaoyao Li <xiaoyao.li@intel.com>
> > > Subject: Re: [PATCH] i386/cpu: ARCH_CAPABILITIES should not be advertised
> > >  on AMD
> > > 
> > > On 7/1/2025 6:26 PM, Zhao Liu wrote:  
> > > > > unless it was explicitly requested by the user.  
> > > > But this could still break Windows, just like issue #3001, which enables
> > > > arch-capabilities for EPYC-Genoa. This fact shows that even explicitly
> > > > turning on arch-capabilities in AMD Guest and utilizing KVM's emulated
> > > > value would even break something.
> > > > 
> > > > So even for named CPUs, arch-capabilities=on doesn't reflect the fact
> > > > that it is purely emulated, and is (maybe?) harmful.  
> > > 
> > > It is because Windows adds wrong code. So it breaks itself and it's just the
> > > regression of Windows.  
> > 
> > Could you please tell me what the Windows's wrong code is? And what's
> > wrong when someone is following the hardware spec?
> 
> the reason is that it's reserved on AMD hence software shouldn't even try
> to use it or make any decisions based on that.
> 
> 
> PS:
> on contrary, doing such ad-hoc 'cleanups' for the sake of misbehaving
> guest would actually complicate QEMU for no big reason.

The guest is not misbehaving. It is following the spec.
> 
> Also
> KVM does do have plenty of such code, and it's not actively preventing guests from using it.
> Given that KVM is not welcoming such change, I think QEMU shouldn't do that either.

Because KVM maintainer does not want to touch the guest ABI. He agrees
this is a bug.

