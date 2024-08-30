Return-Path: <kvm+bounces-25576-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 539E0966C8F
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 00:35:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8079F1C21E75
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 22:35:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 263EE1C1AD3;
	Fri, 30 Aug 2024 22:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gAZTT+lk";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="kyOIOW8x"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 837B31BFDF5;
	Fri, 30 Aug 2024 22:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725057346; cv=fail; b=kRvS+v0exTviphjwm6U2ehpkzk0eduo3xAAXHnx3TG8E8+AlACekHIkYTVdSPtbitc5rTJWFDFrkzMqX7mWzRDJ8ICmkVmxPsPQ8s7Xw2YI2uutU7rMRtdVpGG56LTZ8WrEFOpvUKiMG+hLPuPxGYPv5YT+mnqMNtxpBv7m5xU0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725057346; c=relaxed/simple;
	bh=pkYCiqAbUT/9teZ+CTjhjrwIZA+0klz1zYRzymDZd9A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=btR7ROh/xoHnA6AQduV4AVGxN6xKPlbY8kDj2n9oKTJhICG3h3TfUJqgkeqZ63chVdG/ARz7/Dd0khXHnHNGQJJOCh/yilZix1XMBgnrbGo+ZVOABa1ugQtqKL6EhILkoORUdLClom7Brf6ShzByBuKXUWE4VBTucxooP2uEs9Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=gAZTT+lk; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=kyOIOW8x; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47UMMdCe004190;
	Fri, 30 Aug 2024 22:35:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=XpArr+dKlT52KzClTB9Imo3RBZnDHZrGgtFfqEqhxx4=; b=
	gAZTT+lkRvu8+zCHZ9MHOQw5CmiIFUuCmy8uJkOUWNzK1sEBwMCkfjSv1L0N8kJD
	/5QF/UJKTOeYMnmsQR/fxmhHxn0wWnpbN5TjL5MUKuZ7/9u9ktJjTRirNTo+taxe
	nSsEBop0lge/eGqmq8kA28vq/iXH0qdIAJw/tWLk8Yx/ZZfmzEcrKxBwRXQCkLCV
	fxcQboqYoIVG6w5VJaE77Hw3bz6QaxEsS0OKWWLVFmL3iw7o5aRmsctk7qkCasfB
	/DVzcpVo9utT7XibdMVG3rxuP4P8DbE58IMtmo8jtDsSAwX72csqbttrZopyI9rJ
	gDRd9djzaxbAZTG5oMXFog==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41bfgj0wqn-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Aug 2024 22:35:06 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 47UK7lHb020350;
	Fri, 30 Aug 2024 22:28:58 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2048.outbound.protection.outlook.com [104.47.70.48])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 418j8sb29d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Aug 2024 22:28:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mVP/4nWcnPyRz/L+fgghjdkcwaGePSWyGGHx4u8FzBqRmjnQfwVdyO64cwV88t+BIKWQXL5UBBwzCSUBhmxCspnyX3OOM4U9rjB9wAciXCzOKAzqWpUXhnaeOag6Ozj13wVOSB/GVVRw2f4nEctFtlRxYj14C7y0BnIZw5tOqEj909KvaTcGDBVQjET4X0gkIZEZknC7i/MQv/E+txdHHT+hYN4sZu1CMGl0FdRovCx+u8QY3pzRC/QF/KU0RAFraPC6uQa3lZtieqRiAihQMfwABbGpcZJVY9r0NBiwInNfeqifjAS92fj/3tg84EtiijDGIitUUAau4Ne+grSmqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XpArr+dKlT52KzClTB9Imo3RBZnDHZrGgtFfqEqhxx4=;
 b=aRx+HoEbz1k/JVohHG9E//nanNv6dz1lkvXmZeZjRzT5RDrpX5CxsRHGtgtZbT6O0J6q2qYPxBCdTUnOCafB6VZLuAWq376GONi9pJRp4F13SbRnk//DgAOmEz3KcT/aKsUBYdU1DgdnqFEWHsnxfjdu6PensOXtK7Af0IbK+Y6gHAryZSpRHtNckOocq26/Aud0jO6WolcglHaQ0bLfexl8iK6FJcqd64hmOkLp+JS1+xbxcPWp/u2JZXAk5fp9XXsdsbMJkHFNUNDrhVwwqLcPWiQblX1gBEtQdAVG75QlCgJ2bwSBQ4SeeMIDFx9MI38ZDg1AW+ShLqfcFF59aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XpArr+dKlT52KzClTB9Imo3RBZnDHZrGgtFfqEqhxx4=;
 b=kyOIOW8x7138qV0ZAA1BEoCPXgb4qtgPrwkXmkLFo3d8bHqPIvO/FIHi4x4IhHALU/xR1UIcm9biUwEgvt8mLQmuq7q7HFQLLR7NeZ0/1+Ey1ttJUucriM6sV3bC9J0fXMkmxafELjVYcRr1AkSrleb2kVvJGuzA1YgIdM0qv4w=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by BN0PR10MB5077.namprd10.prod.outlook.com (2603:10b6:408:12e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.20; Fri, 30 Aug
 2024 22:28:56 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e%3]) with mapi id 15.20.7918.020; Fri, 30 Aug 2024
 22:28:56 +0000
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
Subject: [PATCH v7 03/10] Kconfig: move ARCH_HAS_OPTIMIZED_POLL to arch/Kconfig
Date: Fri, 30 Aug 2024 15:28:37 -0700
Message-Id: <20240830222844.1601170-4-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240830222844.1601170-1-ankur.a.arora@oracle.com>
References: <20240830222844.1601170-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR21CA0003.namprd21.prod.outlook.com
 (2603:10b6:a03:114::13) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|BN0PR10MB5077:EE_
X-MS-Office365-Filtering-Correlation-Id: d452a2b9-b749-40ec-d53e-08dcc9432283
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fbY2/ThWqgnAKSZrMp3+ShtPRKoU+95VB/3tTPNvDyK3/CgrcpgeiwY8kfVM?=
 =?us-ascii?Q?xLoA10E5drTpZF7sfytdbt2gKb44Gc8EBvllD48V1oaDd22bIhey+Ne8VszC?=
 =?us-ascii?Q?5ZFyjaFMTLrxI+CypzC3pJL9POtz5BO7/sV18JdN0WRP7oFVu0QX//vvP67A?=
 =?us-ascii?Q?153daQp6c263JUmZF6Xv8Xrqml7b0jictZTlXJrgZFXLHEC12Tt2dy96kWYW?=
 =?us-ascii?Q?hktm/XLaYlptkVPz9bFt0hWuWSuip4Qt6FFFWltoTL8qkliTUZFRjFoLiiVa?=
 =?us-ascii?Q?tjvBsteGZC+VKlyaW66WIH7xCdhDp9Hc+eIfg4nEvRHm2f+VmBs6R9nmuE75?=
 =?us-ascii?Q?KbXbWf9hBYIvVLRohVBPen/0zOIa66ZyYwax7ox17BZA7sa/YFlCsmHKqkAO?=
 =?us-ascii?Q?GfVctEmXD3BPCxu8sgPHgDV75+SvnWHuJvBwizhUJWwSL83hzujZtsEVTxie?=
 =?us-ascii?Q?y1bDAv5WLvhGhE8qtnJkijWE86cNR3El/7Hquo97UgnhsczUY+uMxjMIK6We?=
 =?us-ascii?Q?dU1Ybbnk10aEwFo2xasgdH5SdBRjqnuTgnIv7faIrPzG0TgccU96+tnLm/OO?=
 =?us-ascii?Q?UigzFEhHD0jrUDbxWytcE5qs4hRRzXp1ZJ4w47A3r3sGQbebqAlJwRMoEw5S?=
 =?us-ascii?Q?usAyRM1Anays8iPjXUxrVUBX5p+xCvVdguvb6jvX7YrQInpklZ7a5EQO8eFk?=
 =?us-ascii?Q?jzgdZRYLnqdh3amcfQOSCgKQOjLEFCseXo8aPxzirTo/acsLIPL/W6UoeHCG?=
 =?us-ascii?Q?BSQFqunT0y3Vdekbyc0m1OiFL/dx5kmgPPZOO4j4M7X8W4Dalg5loyTjHQuG?=
 =?us-ascii?Q?Q62mYeHrXvhQvW2dgfA8zyf5K4TDqxsYWw7vVtbKEW6npwYNoUBM0Z6ib/qi?=
 =?us-ascii?Q?HsdJQQF0Gw4Lomdr8zGgqlOn5Padm5mzmKIRg62VAfXkzYqEH+5AVLNtvWKX?=
 =?us-ascii?Q?67p0nKdfxSMGdTFMjZmP+pNxbKVMYOw9/pobfnOYdUGD3u+6Pm0TarqXEYve?=
 =?us-ascii?Q?tzSkgrIQtWEJoSGM0Ycx0kUenv6LUd0iV1sbdMpDdHxellS2XmbcJDyB8zhb?=
 =?us-ascii?Q?vs2tXN6JVZ3JSHT1zm4Q5hYBg7An5Lfueceu6hq35ucRsWzH/NrEk3wkcCOY?=
 =?us-ascii?Q?PqZp+ATU07HYSYfpps4mqfB8iFbfnzhnX081WpPiz0XKOd7Tjgu9eoYq06KY?=
 =?us-ascii?Q?5UCRFkAe3yrpY6K3vA/g5x15VhhlSSjP/vKZxPbfG7UN9jLYKk2Iz7zFDMd5?=
 =?us-ascii?Q?ACJPSGil5Hua8fXjfiVgBPnybMUsSOxmacenbFLfkDA9CPP4kKzcOhVsLO49?=
 =?us-ascii?Q?UNbvX9HKqTo9aNl3YTEQQZjoj6EPXtwLdwsbblFT6Q1X6g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TlkyqKLeyzM9XqSWBxgCJU3NPKHlcBTqCCYzcXBPpNqtX97TtZtlNC6zUNCk?=
 =?us-ascii?Q?FfIIwa90qT9McZN3fyhjXF2mvBIKuoij73cQulk29lTLidwtZxg8R9B6lH2h?=
 =?us-ascii?Q?tCt0TaCKy7VozsnWAlQ7HOlami9ktm2lZ0WhImQ5ehDhuENKTnS3b7OxhoZk?=
 =?us-ascii?Q?Nz5Y90Nz6rW5yVswphggm8SxhLmoF2d6GBVaNKJfbM+RcATj1/lAfM5Nwj1v?=
 =?us-ascii?Q?GpVNlK8v3bOHdQADNdfBX+Wcu3vuyq9Ij1Azp4Vxclz3tVlhyzXwwQlmcXfT?=
 =?us-ascii?Q?dtNDQhOIpoRf3ceGUNlGUN4l9Ukp3HMkJ8llDEnxAWSlJ8Dwxc+TORSL8lWF?=
 =?us-ascii?Q?0XRuorXpp9ZtMLcX2Qw3TvaNn3qX/D0rdSRCZU57gSm1ORXyYVuw8tX7IiAL?=
 =?us-ascii?Q?6n0LxQMCKH7cUwaiVg1udfg9cVyvXRrIOoPMP4cL7CkKRCw48dW54jlzvCzP?=
 =?us-ascii?Q?cPMPtavCafycgFhFy6PvpTkzci64NxlQzW4j5xsXiGnoOl/2OPJxyacunZ1I?=
 =?us-ascii?Q?pDtcGklBig5s0ey9Yz0WyJdjhElivtIQsflINqkWRW3wyYlMAo4sGoVu+SWm?=
 =?us-ascii?Q?0vyCdxfSalOu9dIckxxyqk48ZueR1ysN9IDwEV0S9pIG65N6qmt12aVFSE31?=
 =?us-ascii?Q?2Oz9xTxhPcCJJ6Ob/8pDSLmQY3l7S03epu389FG3xH8p7+Xag0bXsKhxVOey?=
 =?us-ascii?Q?K5KvJZTcd0Hraicc+kyIDI+pPeK8azq2dHaCEeudn0Xn58XXpK9DA6JA1tWq?=
 =?us-ascii?Q?907KB8nHFjEJFn9w9+dNPi9lj4gwD3pQquGoevbxfB41cGEmNe1szqaatwYl?=
 =?us-ascii?Q?CHDbULuAmWzyt/te/2anZwKw0AgSjS3WiOb8YcQBpW3DsEqtb2Q5EShTD2jP?=
 =?us-ascii?Q?XmKuvNDzAdbFWSR0FMxRHBgv938F5ewxkQvAPNeBJSpgDQsUsIPew7PHFHEu?=
 =?us-ascii?Q?XUCMi8Ga6V9mYPceOZnKqSejd51c3iWn8xMEO+u07KbTgSXARfPWNEKhCy23?=
 =?us-ascii?Q?rV9U+9Ap0/n+d8LNJJ5nRng6Owmc0kRfI2vl0coBP9x55/TQQAPE2SorEYEa?=
 =?us-ascii?Q?/VYT+XskiwMKznIf90DiQ6J8caU1ZGU5cW6d6b37Hh4ikwTQSdA+opkSkx6O?=
 =?us-ascii?Q?DHGHk9whczHnm50tHZgsZYXKZH/2GysBGDOg6/J1X2UoMxAaqBzHnkMiPdxi?=
 =?us-ascii?Q?TBbFbJo6sO76vzUNesyGf2I8PFNV2LQ6eCfTZ/+iyBDQ3E7yKDir3+Cck1P1?=
 =?us-ascii?Q?THBZSCO4dGYbReCddvKyHPtIcpIxXS+GMbfGP4uBN+lkTyNUTZqMfK5IGceg?=
 =?us-ascii?Q?qvIvZdMTZ88/LL9hY0SC1Z982KKONU7ORlwYPtdFawkcdkTlFSXKJifoHP8p?=
 =?us-ascii?Q?vLynU9WucwH8/+nvkQTUl6bXVUGMqON+6rZ1DbW6i5tdiJ4t7I19kmfrRUKx?=
 =?us-ascii?Q?oLJClekHUjryeUWs507dGyPkNKzkeGfPz/3UPwiHWjj0aTfK40asjMbm4djY?=
 =?us-ascii?Q?oRmridRC3NqkTExc/JmHPEGCcPY8IlfUvvcx1/Vr7ezzzyfOrAZQd0UOb6sk?=
 =?us-ascii?Q?KqcUiRql97zZ7PNfYVwuSRS6Qnb3CIEa7HgWwOZTwR/XZW3JhYARmCxf3hBd?=
 =?us-ascii?Q?+A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	VDtcDV22Te35tOxn+PiJAN4h6dlThpaDOORiSZ1tvOh2aT1BLJcMaMOeuy6x9M1/55AM0sDw/MVum4v9EAwFMGvDVEQTvkHxo/QFOnFC8HB/kQ506WynM1C/LjXCNXNR9K7wmpW5GkshuwoMCbkXcJnQXbvqnkykefKf4LtouEkYmTMd6lI1KXucBdKqW6sGocpvrFuOMeaZMtca+E19+m6dGfvDY6HfDorfixgWFImVP7ddlWN4dFKx1LTTw6MqmTGG8oKlQhAm4QmW3ibKjX/n5IR+s+KR4Y2hbVpZeyib1xRpxU5pahAzhap8tgfB3ZjhiphGqIunla2iM9A3q58NKf2PiMDqv1xKClpRF/oveXKnHbIJAyL0H1uInFiFmZY90eUzzElgHlycRYiJaj+ByG7fIq3g48+EMP7oUQI/qqb+mZBshq59YnxaBWbVUNCgrGWmPa5TYJnMsoPmCQRgjGqRJj+cJyhnK2NEiYGRl+ijXRs3nWPWHWzY6Mw7y0JlrQw/FOJro6o5wG/MkQlz889iqZDskOXtmaWOxV0wgQz2frE2ixZY+T3rHL9Z0Fg6D1bde6zA6yRitmGjzN0hELG5NX8QDQls4vfiMsE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d452a2b9-b749-40ec-d53e-08dcc9432283
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2024 22:28:56.0758
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I6bFsfsiwUPOoO8bJGmNrH4IAgBp4Z4ECgeNWZNCwsNtz387CKEOpkQNmDSdBKzyevYc9v5WmcBN1bhKCGYcoVRW/gEHdEN7lYTA8hwqKN4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5077
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-30_12,2024-08-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 spamscore=0 malwarescore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2407110000 definitions=main-2408300174
X-Proofpoint-GUID: ib70haBs_1Wiuo1vt-SSg2hDbT9WCq9g
X-Proofpoint-ORIG-GUID: ib70haBs_1Wiuo1vt-SSg2hDbT9WCq9g

From: Joao Martins <joao.m.martins@oracle.com>

ARCH_HAS_OPTIMIZED_POLL gates selection of polling while idle in
poll_idle(). Move the configuration option to arch/Kconfig to allow
non-x86 architectures to select it.

Note that ARCH_HAS_OPTIMIZED_POLL should probably be exclusive with
GENERIC_IDLE_POLL_SETUP (which controls the generic polling logic in
cpu_idle_poll()). However, that would remove boot options
(hlt=, nohlt=). So, leave it untouched for now.

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Mihai Carabas <mihai.carabas@oracle.com>
Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 arch/Kconfig     | 3 +++
 arch/x86/Kconfig | 4 +---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 975dd22a2dbd..d43894369015 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -264,6 +264,9 @@ config HAVE_ARCH_TRACEHOOK
 config HAVE_DMA_CONTIGUOUS
 	bool
 
+config ARCH_HAS_OPTIMIZED_POLL
+	bool
+
 config GENERIC_SMP_IDLE_THREAD
 	bool
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index c1b49d535eb8..0d95170ea0f3 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -134,6 +134,7 @@ config X86
 	select ARCH_WANTS_NO_INSTR
 	select ARCH_WANT_GENERAL_HUGETLB
 	select ARCH_WANT_HUGE_PMD_SHARE
+	select ARCH_HAS_OPTIMIZED_POLL
 	select ARCH_WANT_LD_ORPHAN_WARN
 	select ARCH_WANT_OPTIMIZE_DAX_VMEMMAP	if X86_64
 	select ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP	if X86_64
@@ -373,9 +374,6 @@ config ARCH_MAY_HAVE_PC_FDC
 config GENERIC_CALIBRATE_DELAY
 	def_bool y
 
-config ARCH_HAS_OPTIMIZED_POLL
-	def_bool y
-
 config ARCH_HIBERNATION_POSSIBLE
 	def_bool y
 
-- 
2.43.5


