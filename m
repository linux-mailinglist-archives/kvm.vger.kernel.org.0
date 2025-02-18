Return-Path: <kvm+bounces-38497-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B336BA3AB27
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 22:38:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B5DFA172ED4
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 21:37:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A85A81DB37B;
	Tue, 18 Feb 2025 21:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FIcFePFS";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="wUKgf8S2"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E2A31DA109;
	Tue, 18 Feb 2025 21:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739914505; cv=fail; b=Es8+WyUm5qqV8jPcqqevfl9uvKNRX8cMxaTp82dytyw6O1TS29A608lhX3n38n91zpZASeES+59hDNIjsO83vfPf5qKUmoaCEzdqcYjf735LIGp3FwUfKxJ5bTPKQglmmrCUL9SaR6UAnjJy2SlkmngF+oVyI7vSecibS4tmnyE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739914505; c=relaxed/simple;
	bh=qaqR4XGs1rLAkNQe1aogofjH5xKp3MtFJ1zAxTh33BM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gp1e4tOSSVKhOhPx166G1kMoS4l5BIhExjR2FBDZI39qprPFX+HfjEJl3KDqlNCiH819hQJNlNDwDXInyJfJ7rF04mnyerogTzEa/NhuAeoGhV1zWCPu1a6CnKkpctKlIoqd+2/8gG5sreI5hOuDIAiI/SFp0jm6MycX/XoYpj4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FIcFePFS; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=wUKgf8S2; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51ILMbPt023032;
	Tue, 18 Feb 2025 21:34:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=G1e1iXCdzl3tSQ3GAIVciNeQKSV+5PuTo241jx8EG3A=; b=
	FIcFePFSFvCtbVgylD53snPXkOvyBOlNDSXQ5p63nKmHfvHc9zKcbk8tg3gU5ErW
	VdFcuUiYUtxrcQCVglRoXMp5BP22Z1IAz3SyTrYqbQAGa7HCueQRzBIZlnNZ0cL+
	AdRw5jxdH0KXpib5QgQpIZ+GtIt/oKuMV2DiceSsfvlJpI1zdh99hf5CCv5+RMqY
	Q0UUSSRMGUgT5YMghN/G+VxMHHTI3fzVemu4palw97QIJzumCH1t8nAANzwdxafS
	lHECVkfflTkPeXdkwJ5xEpEl7Asl/z/4MdUaZODMlwG3iMBIDHe+P5OmdGK1GhgH
	nc7IFN16IX6fqiRFdhwcug==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44w00prafy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Feb 2025 21:34:07 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51IL4sMa009688;
	Tue, 18 Feb 2025 21:34:06 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2041.outbound.protection.outlook.com [104.47.56.41])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44w09bmxb2-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Feb 2025 21:34:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P8X2hek45r7JOYAGE4XbOk+Dp6NTtWe+YSSKWjYOOo3iwAwmDBh5z3U26X6srHghNETRftTXQlw8HGjzU9dhXzEgZOwH+KiS4LjA7C6NCyzEjluv6GD1cgK8W7ehxXI5iCgbXjLYdeFGDXZFfnUP3RLyTj71/MCyr3PrX9xivfhXeY2tjgMqrB8CsdCUV5ma5prnuH3HZK/O+zYZ9gQuNsZqRLodsFHy6PWzdloSV62P+Umug0kgVs2G28c0+at4pE/NorSTzU9M3N35Tnty/Ds4cPGrjQVeor+rg6qdcsKNSYljTsbI2ejHgGkuLjtZX9jzhEWCI5wgFAdSuOT9wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G1e1iXCdzl3tSQ3GAIVciNeQKSV+5PuTo241jx8EG3A=;
 b=DeH3z1wZHiR14Frtpi7Si8UHBTSSBAExEzgOKkOcphgMy4YFrHtZ+E48fo9EY5DbFsUvrs7Xj2Jb10nCxeRpDmS0TFYtO7wHmcp/oRUk3SUaNPM2RLrGzaivWDr4RlXGHoSKdW//1+IW1e8vU8NGqgRYm/vKWAkWbjH73QGdXz/M4NtJkol1LlJh6MDQWG/NZlVBJ01D4fwtmdsXSaDxlZKcIHbB17AQ7ywQAdgxpOcVxq/AI1aaNd0QkMbmqwZKawFVDKd7dihC5U8UOo/oGX34KpYB5a3B5OTU5KmgHcJUfr85EmukX0tMtpoH92AYuuVyfb1AhX7hPLYMGDD7LA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G1e1iXCdzl3tSQ3GAIVciNeQKSV+5PuTo241jx8EG3A=;
 b=wUKgf8S2M4tayKeKnF/buq3im7B2t36DW4iK2xc1AQyvRKl1ghLuOIrbQbuO3q/Jiul1SzBcuGbu/gHyQUk1arjeNf5LEoeX3yKRXaq6uRSXri84zlX1/R9i6z3n81UijKcs8dlfY5Nhjk/ZPFO1GHuR00ETEa/L9G9wq5G8N8w=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by CH0PR10MB4892.namprd10.prod.outlook.com (2603:10b6:610:dd::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.19; Tue, 18 Feb
 2025 21:34:01 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e%2]) with mapi id 15.20.8445.017; Tue, 18 Feb 2025
 21:34:01 +0000
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
Subject: [PATCH v10 11/11] arm64: support cpuidle-haltpoll
Date: Tue, 18 Feb 2025 13:33:37 -0800
Message-Id: <20250218213337.377987-12-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20250218213337.377987-1-ankur.a.arora@oracle.com>
References: <20250218213337.377987-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0286.namprd04.prod.outlook.com
 (2603:10b6:303:89::21) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|CH0PR10MB4892:EE_
X-MS-Office365-Filtering-Correlation-Id: 21f38c9d-50d6-4ea8-784e-08dd5063f5ea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jC6m9mHBkY4kZ5GLvyjmsY+lGexKEDJmHPVTtXfgB5mmz1lGq8SRkMsv0376?=
 =?us-ascii?Q?umJqXGr26Fq/zHIONkJgDow6qG6PCW5qJ9NNc+miWO2drtzAOM4EntCfn3VF?=
 =?us-ascii?Q?7DnyT9493gizTGdBQl7n5zhPTGVqPOOYYME+9TuUBOUMFzGHBiUB7ZjRB+gY?=
 =?us-ascii?Q?M06c+1aj4iGB7idZntKjInoo6mdxFbkTLgjZKfG17pM6v8qsQhqWIUAapPWf?=
 =?us-ascii?Q?BPcG5BjcGJLwmq7uRZShUIHlNL5wnwu1lu3iANDhKzkKQaMOtigQoagpseqs?=
 =?us-ascii?Q?7Ppnhqcusv2QP/lPHabh/E3TrSx4LFGp1Q1UQJrWfTEsG/sSc7/zAaNHqWto?=
 =?us-ascii?Q?U/W7OVQ0vLov/g+Q7KBMXuG8rSrZs2xM1X80AthGH+BV3/EpGEEpLWqe4xtr?=
 =?us-ascii?Q?5JIqf0WVnyv9SdAqlLiWMCOIHpoGy44I1giV4/wWsSEk7GpU92sKO+kqSqx3?=
 =?us-ascii?Q?qzoREIofASpS+j2QjVHl+2JhE5szma2rz9fVLISGC5UKA1Vxg/URm8U/G0hS?=
 =?us-ascii?Q?44tJ9eDMTYam0Y2j6xIQPxuXtHDh9UGKuEDayY+2MF72rkzHC+FuHpsak36Z?=
 =?us-ascii?Q?PO3ZJ4SXr3ETThEEBBiM0tffeZ2Ls5wZkVTg2ZpZ18CpyUT9PoD2SwsHXy9e?=
 =?us-ascii?Q?kXYZcBXnI4FLOSaDOzd6splx+pK07ahgYfnWuN674h08zrIBjVPH6cYl0PXB?=
 =?us-ascii?Q?d+dOi35Vy8bKfYDwQH1lZR43lqdDSRY+tX03xLiagVN5cbMwfthZisAvT8CY?=
 =?us-ascii?Q?IMhNq4jD7h0cdVqVaj872SbwELRdekmfkXyQEKAxzrRCP/BdUHa/Uzy0SWpn?=
 =?us-ascii?Q?3N95ekh7GlIzbgmUK90lB57577B4pDxk0njE2Eqs86Ypjg7mjyOLTEpWooKL?=
 =?us-ascii?Q?B8QImLKlhzuDmbkz3pktMLPUK19qXeCcS+XUUA7wYqzOsaPeMlE5nc8I04fe?=
 =?us-ascii?Q?2yK2ZhXpqc7/FB1Uq79IXCrRrZTt6rs9tpUHdSFRaBcEGSUxaUoeA1ZUYUES?=
 =?us-ascii?Q?b5KH6mLRnphF1lMoBYRrurR3XP5IEF2Wg0jAzpkmMMg7xs6CA+6pmPwkchxp?=
 =?us-ascii?Q?1IiYmo5FtNEJJREqztB7LhEjBPFNLuMa1nTlSpWa3wpF8yjcnxWvku1rByY6?=
 =?us-ascii?Q?sjrJNHzubKLz8ZDVKTGIil9XLzN9H7FPzlG6dYWzsLDW1wV42qmhFCDfiSVR?=
 =?us-ascii?Q?lbmDCYAnEZ7eLRfZxUl3xLbrHh22JZj3TDZsejSL6X19b6FH9drSDmQjIYR2?=
 =?us-ascii?Q?7Kscp7IrT+Zs3NcRttaugOyyVORFKcF1AETU9A3asJocUzhfFWEJirP57oth?=
 =?us-ascii?Q?xPNzA+cLQEdYcIJrslLjZLWZeGjUC5TiWrBuCa1SuruK0UT6WDozQRx8luKe?=
 =?us-ascii?Q?xMM5UV58VivjvYRDiRbBmQVoLQKK?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?B4ZcYezbjQJT5Vya2p+ecmS3J1yfNuXx7or2qHkgGEfZdbFCWBF7Ob6hVjW/?=
 =?us-ascii?Q?kPceJm1Hc+dPcW7KhC0RDQ75XbFig4VwBGdovRueYJ1bnUWPQaMWfHD59ZQj?=
 =?us-ascii?Q?+SusLV7rbeAbFNwKgUpzRUh0v7FP+MwS630/xPtVEfSk3pwqdCiFs8x/UF3H?=
 =?us-ascii?Q?gCTpWj+P40P0QC5jYCaDDII/Tgm48A3ZV47Ney7oP9YqF+SuOyUskNv6TMOw?=
 =?us-ascii?Q?y/Mimfg1pwVjSLPL3VqbWstxsK+QM6X5vQ4D50d+jkLLDf4+VxWd5nJtHodA?=
 =?us-ascii?Q?1qku7TZ4ugyTic+jb6k2xT3E5wkwDUAchk7vVvRSdYDNu41SYc1Vt38f13Lz?=
 =?us-ascii?Q?mM60Gz1mkN49JOOBOLzNAGxU5dZNcWmFx2lhObJjw2I7jHxUcSPnsUseccxG?=
 =?us-ascii?Q?/agR9l6a7RYwrgKgdS8rDkLWe3Y4fIJLO1VXgBBckRUBbA8r9xop1XrFCjPp?=
 =?us-ascii?Q?KaZvVfDBOSRfi6azwpHIc03ms9LH3TnNIIxVXN/egvO12C4LzNIZkEk1V+w+?=
 =?us-ascii?Q?wJqZUa/8vsFIlg517PrTvQlATEy9dmRuRgOmOMlpWAj68JgUQzS03Uhhkk2b?=
 =?us-ascii?Q?UGvFc2yShW7Xsk+40urTTSVMFVAWqTX0GGtiwtjqJTZpGkeHowNXJ3Iot6Tl?=
 =?us-ascii?Q?t/FjOEGf5h4k35pSlkYqBBoQqA6j9czygaeBuvBUPS/PNjLRrJ2pXiWALgF+?=
 =?us-ascii?Q?2bS4juczeZMjEGVnfNRZRbCKcCCqfLS0g7lVsPXEMohWPP/CKx0qLGZAh/lb?=
 =?us-ascii?Q?p2c1RjxdhmCRHyGdP4VxaLWOkqqWeIKbbR+XQrBk65aJfIxQLL+ef6o2VKPm?=
 =?us-ascii?Q?NglBHv8KNGT++KyxWg1vcG8FSmVdVsdjtSZYwaO3hm90nnf3/ILfmv4bJYPV?=
 =?us-ascii?Q?xF0E69Bo8oMa2wnCnfBLbEL9AbSTlqe7wIBpbA/y0BJoPmloDlLzv53Fp1zE?=
 =?us-ascii?Q?dog1Wsll14mO94UX7JuMYg5z5mOGpigTnRembEMXdWVX74iFbhdHiugIhrrl?=
 =?us-ascii?Q?6BFPVuYVt2q6nMF/XRCIZYLd+Bln2hgIMRPBA3zM5WE3UplUtcVNeU1CsgwS?=
 =?us-ascii?Q?iXG+/UwAhKzw/4o4boz1V/sYetPdRbe41l0WX7NCmXZSVRCDrPXSwvBMD8YK?=
 =?us-ascii?Q?OH6UHGiZqRcvJGyZgZOB/IgsKOfZk4JWoHhJldcq58weTXEka5SFJc9Itmex?=
 =?us-ascii?Q?FdVVl6MB/j1TddgoB/6PUxnUsN0kGJ/9BB6jZKO2W713v5wZ+D8gCNDXT/Lk?=
 =?us-ascii?Q?1kYm/vkYoxHzpB3einRUUcgfodi5N5CcGHGGYSAs7O10syj0cF+dv3Hlzxsi?=
 =?us-ascii?Q?4hsGEwmUhANuaHRaZvv5QMvYZquw024NEgdjaGnjaYXSuTEY0Rzi4FL9dWTg?=
 =?us-ascii?Q?iXQUW1PPbcS1hKhqGTyFYevAdPvMVs3brOU1NFsFfiRrfggFVP4hsEFJtMVo?=
 =?us-ascii?Q?FWMSxA7FB4RJBMdwxZRDfI3dXec4eduyAN/m73bJY7irPrHHPHUgpu1316C1?=
 =?us-ascii?Q?0ooJnAIWkZQ3l28Paj57BLlCPIIKgsqMISPxPVuL7TGPDP+71F67lwwH4Czn?=
 =?us-ascii?Q?QKkKH8TNbXVdFu6YiiqatvGQ0/CXHk52yt6389TeCbds++padDwKtaMQ0TsG?=
 =?us-ascii?Q?WQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MRf+wZtHt60RSCZ6RjzjOLsBFSB7ICDYUwH77SfCdPC64Ym2EjCxF1rUtJYoZ4rgzJNdKqwZtqGA9ByfpUceFoxn0/8/XN9l7i9Ct5QUVbpj0eVUaMgIdrufkNz0FsPX3e0bG/J41MhVlMfy9Gfk+UfEB+883bIhgTHjERBGOiOHluHhMHKDJRKyOJxIKbNZTMFyu6gwgNNIm12F3gQJ9PBNZmn4c5X200yMNQiimL5TbEe94+LyeYLPROjgY1vJ6IMrEr9ozQTNON3fE0jrebf6FgE85VxVkm4B3bQ/NlsSkbBCcHMvoc/rryNd3BbQ7Oj3LTv/1yinxWCJmJOowwal7gOFs9jh5mkfAJBhv2vEg0Xi27YMoypS5OYnd1PGSHDHxk4sB2FS7ufH99ZcDWBrQlP2xRy1rqak9mk1MYXUcsnUwqwUvOpW8wcZ6mnp2/rqpNb8XYVGG1yVxxbLmiSm2wcbjr5av53KYfUUd9nvCrAofMq1757fCcVWTH7flPpoPAV0v2PP9XtuhZ/Ry86btw4GMNu/YHJ8BEuvNFzLLq6TejlwRYHfhLnCsHzftSwaWF01A60aBSWX5RKENkHq3/jfrccDXHjIPtiUr7o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21f38c9d-50d6-4ea8-784e-08dd5063f5ea
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2025 21:34:01.5249
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IH3VU7OCkN2Kf+/jv3gplup7ArO74Cr9K9/oQ8+6+9UNoeHjU9uiH7wND7Wjnpz0Y0x49fRwd083vvQmhCGpUNe5KVF107cxitH9Vb5Tc6M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4892
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-18_10,2025-02-18_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 bulkscore=0 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502100000 definitions=main-2502180144
X-Proofpoint-ORIG-GUID: d_TOqq3aTpegGUM8MDQHkuTWtyPWfEv_
X-Proofpoint-GUID: d_TOqq3aTpegGUM8MDQHkuTWtyPWfEv_

Add architectural support for the cpuidle-haltpoll driver by defining
arch_haltpoll_*(). Also define ARCH_CPUIDLE_HALTPOLL to allow
cpuidle-haltpoll to be selected.

Tested-by: Haris Okanovic <harisokn@amazon.com>
Tested-by: Misono Tomohiro <misono.tomohiro@fujitsu.com>
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 arch/arm64/Kconfig                        |  6 ++++++
 arch/arm64/include/asm/cpuidle_haltpoll.h | 20 ++++++++++++++++++++
 2 files changed, 26 insertions(+)
 create mode 100644 arch/arm64/include/asm/cpuidle_haltpoll.h

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index d96a6c6d8894..eef50fd9a190 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -2485,6 +2485,12 @@ config ARCH_HIBERNATION_HEADER
 config ARCH_SUSPEND_POSSIBLE
 	def_bool y
 
+config ARCH_CPUIDLE_HALTPOLL
+	bool "Enable selection of the cpuidle-haltpoll driver"
+	help
+	  cpuidle-haltpoll allows for adaptive polling based on
+	  current load before entering the idle state.
+
 endmenu # "Power management options"
 
 menu "CPU Power Management"
diff --git a/arch/arm64/include/asm/cpuidle_haltpoll.h b/arch/arm64/include/asm/cpuidle_haltpoll.h
new file mode 100644
index 000000000000..aa01ae9ad5dd
--- /dev/null
+++ b/arch/arm64/include/asm/cpuidle_haltpoll.h
@@ -0,0 +1,20 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef _ARCH_HALTPOLL_H
+#define _ARCH_HALTPOLL_H
+
+static inline void arch_haltpoll_enable(unsigned int cpu) { }
+static inline void arch_haltpoll_disable(unsigned int cpu) { }
+
+static inline bool arch_haltpoll_want(bool force)
+{
+	/*
+	 * Enabling haltpoll requires KVM support for arch_haltpoll_enable(),
+	 * arch_haltpoll_disable().
+	 *
+	 * Given that that's missing right now, only allow force loading for
+	 * haltpoll.
+	 */
+	return force;
+}
+#endif
-- 
2.43.5


