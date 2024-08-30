Return-Path: <kvm+bounces-25577-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EC2B966C92
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 00:36:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 54B6D281C61
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 22:36:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AC4C1C2333;
	Fri, 30 Aug 2024 22:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PzN8l/4s";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="HUEMw/sC"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E3A61C2303;
	Fri, 30 Aug 2024 22:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725057349; cv=fail; b=J3pYVL8vevmRFGi89QKe93nzYRnQqZdTl50gTvD6lRCxrj6HwaQKoj+jBYK872mk68P8qbRCKWnu+PJH44FKsu5Mp0rIIDjC+SCEduG9GEyVJGFT/5YZrUIow4BSHBftsBlSVokhRIW3NXt3xZUVtXYB2KzomjJFZZ19NvFkAMU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725057349; c=relaxed/simple;
	bh=khSTJY/llFO781W+oRrGsrt9Ari9F/wxcNbjXtabusk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=CLUsCtZDOnqsi7i35ej8jI331ZEbUF7CtDgyfVkh6EboQRv/dHMzuPMoqWCtRoAjgFSi4ai+AGsx3n0j36uussCwG+jV6wJ0btPPoM30byQjm5xWuT/KtTS+N5Iqkr9iTf6YnFRpow3QPI43UhbbsZmraGGiDB9odBgt8J2bav0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PzN8l/4s; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=HUEMw/sC; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47UMSuj8017381;
	Fri, 30 Aug 2024 22:35:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=ffXvkV+mRWAxyKYRSz1YPBNnPlHXfBa9sCaF3inIVgA=; b=
	PzN8l/4s3QhMt03ChciPi7mPIZDeFFV1t7zUF7r6kGJ/1GNVazca2RT8G24suvbV
	HU3VaxlrSrZsQE58dsT5pdCG5vXh4nYVYoWNlLIokWPKElmJL3p84xJlDkCxasDr
	liPoexsAplclYyrwTtpyCZONa/ydKMyzcBRTzQE/G7NyFUTq/UBPbIEO0Bn0P68a
	A7vmgx8os7bPCbMkYlHZKUB8TooyS2BHK+8gkcggxGrS/RlJcwqZPk9Z3+lt29Mv
	DosM0VHxYD2zwkCA/uDwxlTgT4sPQJLzSOrxQrCY+NuUMkjV/Sy6LwdkuwpsWUUy
	ji/9Kpl3UgfyxUoXX/cQXQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41bpwcr061-6
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Aug 2024 22:35:08 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 47ULHxTj020212;
	Fri, 30 Aug 2024 22:29:12 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 418j8sb2dp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Aug 2024 22:29:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QD1s5ZvJACyZMT8PvjU478UMO8s4wRcRxaJmeiGl35Hu+zP3QjIVV0QJo9WmAvjGUft2od07A0W9eYO79lUpv3tUwylZbo+ZWM1DRXoKG+QDxP26c26pdvE2pWLzMJJZTcbwsQI8onv/AHL+TZB1gjk413+/1mCzhVcPFvuZ9u6rVbum41Lidc80Aw0twlqcLwGHqUDcZeZlEymMXh0mGtKShhSZSbkPrIGWaLSF8wNzbpAYtOsT3WaOUzkR372nr5XcjmQgagbrWATPzgdbV+o6W1sNzUCn7rFNF1c/1iLRX2lk8qLAp0UcipmZkmiY9nB4Bk/sKfzYmrQxSwcrXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ffXvkV+mRWAxyKYRSz1YPBNnPlHXfBa9sCaF3inIVgA=;
 b=uxK30aKwyjpMZaxNw5XSVMi/G6fBlXYcrcw9wBNllmDqcsVlNISv8MQhDofZl1MvzoiZabb9GNpovjD/76OL6DEbQ09xgEM+5H3pvvHvP+G67QgoRuxg1K0IWrtgWlRWWqG18EgvqLaViiJdJNmrWI8jOHiUiyhLi/UbQ9HwhTntOsbkb6v5cGoRvxM5jjBbgVMbyojTel5SboMJoXmC1s8BHO89XNt7Lu6a2UPK8nHFisBQAewHzrqavQ5fnrh9YVs0cKua5WCylrQoyzpNIFRWLpGy/HAZ77Cj3P+N3NgRGBaepVoPJgHVNANsoP/sYHVMeZVXdz4hfgn0cnF97Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ffXvkV+mRWAxyKYRSz1YPBNnPlHXfBa9sCaF3inIVgA=;
 b=HUEMw/sCS4Solk+tvqpqxNpDGN7NWJzoaiFfxhiFXpSq121cxuWPwzf4BIs8yAncbT969n2sQfnhBvf84lFDQojONBPbJ2e0a3rhdPdVOj4O9DIfmOTTXJWfy4/Hx2Rh8iMp4VNGiXuRJD35Lr6LoDv6sBFmMXbxHYckXcSyMlA=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by BN0PR10MB5077.namprd10.prod.outlook.com (2603:10b6:408:12e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.20; Fri, 30 Aug
 2024 22:29:09 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e%3]) with mapi id 15.20.7918.020; Fri, 30 Aug 2024
 22:29:09 +0000
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
Subject: [PATCH v7 08/10] arm64: idle: export arch_cpu_idle
Date: Fri, 30 Aug 2024 15:28:42 -0700
Message-Id: <20240830222844.1601170-9-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240830222844.1601170-1-ankur.a.arora@oracle.com>
References: <20240830222844.1601170-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0234.namprd03.prod.outlook.com
 (2603:10b6:303:b9::29) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|BN0PR10MB5077:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e57c8b1-885a-4ad1-d6a6-08dcc9432a76
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xwSXXdCq5/K1PO52MpQIks/agYERE2M6Mlt8NaoH6M6bkRUTmSnltDf7fGFo?=
 =?us-ascii?Q?TBTGxpwYF0BEbp1iUYx6qid581oDgskNRKDFhYluFvMfXAf+M35pB2fjxQni?=
 =?us-ascii?Q?NhLhkyePIIcS5v65TR1IKekqiDp0yjrskGlijoXGx4tbIJN70C/C8sfosRGe?=
 =?us-ascii?Q?ya9R++r1tjgXk3/eG8iZJKTcrP++f5/DXqtr0PJfVucKLkomUAPmY3ouJqbe?=
 =?us-ascii?Q?lbuC4NtzcROx/1vhk8B8HP8h3C/ZP2izJZ5D/kieYUlPezOiwfUIzBQqvKyf?=
 =?us-ascii?Q?YqmZ1Dq0p082gRlcJXociwEolF2Vj+3wOZ0L+VpdaAGewMjHecRIkAZHM8ko?=
 =?us-ascii?Q?zi2Eq3s5NBm7AlgDlXcchcXnedAo7sYY49kIE+Rd68+WcVzoFWhtE9Eshh9s?=
 =?us-ascii?Q?pJoqdxN4Z7ATshU91WosptfXe188X56cX+Opz9Tq0mo+brsNw59n/tQfAeh2?=
 =?us-ascii?Q?E+vh63m2ZGCF4a7gzNamFTfRNOPOgYWhaiQnezSH2jWRH7aZ42lAm0FqJZsV?=
 =?us-ascii?Q?O9rR2tIGMO9fen8wpf/G/iNC0d4gtqKaxhxtW4L+yIvCT4vSp2SrgI+AhF3W?=
 =?us-ascii?Q?nlEVy5vCbaVv1xsWunQkGwXVeX197ibKbYOl3TpXy+5WwWmcB/pTHSD/iqig?=
 =?us-ascii?Q?Z4dz9HBhT7hxiVhx63pDNVXElUBcoXnFrluqxvWqV8bQeDJCySQ4y243Jz4f?=
 =?us-ascii?Q?k1IRVJrpJlTHIixiQBd62JOMwiPC1kzYgN/T6LJGfrrrCRmKT+JAOo75cHM/?=
 =?us-ascii?Q?PQ75BvlSIyfZpmENfsS0AVovrKtPYLvn4fV191bJq9zlEdC/ThDBpeR9shKz?=
 =?us-ascii?Q?kHpzW0p5VW57aLOyoXGHzLuy/3/Hp5+4Byotlttsh1IdIq/SjEHXuT/sIqmr?=
 =?us-ascii?Q?KgVSm+REuwzwqJ398hjg8z+Cp/bkQ1MYghijRENx+KGEPkKZrWI4n9dWRGPs?=
 =?us-ascii?Q?sfJj1YaQgQrtAxi9nqVaXKG02a5m8r5EPpzSmN4PXUCHCf6uDGmNau+8CwSB?=
 =?us-ascii?Q?prOT+c+buWgZl1leeq2GtgGdoxf0Gu3EeZsUC/Fvw0dmULmo0DzOhPGgz4EN?=
 =?us-ascii?Q?hVjW1ePPtWdoeTOf5EXh+hfxvMnney5xqg2HVITDn5mQlB1KYb9M+5VakQyr?=
 =?us-ascii?Q?B+1q1sJnQPwixSXUUvmm+QbUwLZFFuZ7HoJXEHkr3U1q3v+Lqmf+iq/GDRPj?=
 =?us-ascii?Q?bIvPFM7dy7+J5Y7fqVQdYagnc1Tiu86oq4w9HyFixJL69I27+3gXFO/2L3uT?=
 =?us-ascii?Q?zq4XWRgdulZg44dOQVuWG7oKVejPE3R6aE15pAER5dyycpMhQHaGRrQot1T+?=
 =?us-ascii?Q?+6l1tB7UAQ1/qyLQ/VVCR/brCA9kB1dKxlwAnWaveO7r5g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?l0mg05IQraz8fHX++Z8CEGl48IgKlxHJxjKMIMqGmAhpOMmOHIyljzP9xUMW?=
 =?us-ascii?Q?aSxBXfOMNTuEkaFN0gfBXxVV6BXC4E6k3SAtfgh9Vm6h2tFE5lAPECLeNJRz?=
 =?us-ascii?Q?+DyQq3KIUT5ZlVIHYoZEuDmsWP6ApIQjoYtYMql3LCsSA+XERE8ZIYhuSAvb?=
 =?us-ascii?Q?apbQtvThMuxRlzJA0Vm5BMsUvDKpqdN3ah6Kt8Sqt/ZEEI2QPicS4+S0Csok?=
 =?us-ascii?Q?D9aPrYviY+jG1qAhRl3zhJEdpNR9z7Z1SGX6cNzDI3RyFQGYUlqTsaDcyZ1b?=
 =?us-ascii?Q?YU6anbpIkDjLbYva03XGTkdfhJPcisbetZKz2jxtL4T6JOhnr83fo6oRlPBW?=
 =?us-ascii?Q?U0zygi/wmfUs+RotFl8luBcDzSzNBdoh1km6PJK4MVFe2pSqp/XLtw7p2zPQ?=
 =?us-ascii?Q?iKfm01oF/YPabtvPKvEPOo+NxeCPjKK8dl3aVJKdDpB0+388B8kXF1Ttv2ow?=
 =?us-ascii?Q?WqRsBC1cAey4lS16MgNShnYjVzZiBL1i7V+d1NbsmlAHmWa5qQCQl9LFOWc+?=
 =?us-ascii?Q?hWdpWoVVhl6Q/dApT9POk5DrcGtQTmsqkLLrZVl9yUSx8yvOi4rxprKS428c?=
 =?us-ascii?Q?gLWO0Kg0TubGNmKi7g9MGdqwyBvLVmKHVuloUE7Rbws057mAD7wyt6ObDk++?=
 =?us-ascii?Q?8n/wHsymmZWDaBxOU7hQ5yahXy5E04fsK4eG00CDe6tc+Gfz2el6ZXelBcCi?=
 =?us-ascii?Q?a5A3RF/6AWr4jdty9xshJcUvWrlEe8p8xYd0E4GeKpfLdUX8C6FR6o1Ewemu?=
 =?us-ascii?Q?V5nG2M8HBJ/bcNPyQClHLK1Kzq9hLkXlQiDiGxmeJSX2pQelSCErAJG54Ckg?=
 =?us-ascii?Q?gD+jgKTqNjT9B608wtr+0N4MDlORIH3LYz4oi5DH9F8X3RdljJH9+VEAIF0a?=
 =?us-ascii?Q?Iovpx751HaZ+3JhjHzVhpfNwkRdwA1soqqG4blLNau3bpiijYuNpwZfJ6udT?=
 =?us-ascii?Q?GVFjK8VRNwsCxLLHhJg2ig2myIQZIkFC8HVZjTqpE83j/WJtd7cxONIXEGtv?=
 =?us-ascii?Q?Zm6l2Ejl32Q7WNTRo2ebYreJWBESKvkMcU67USIdKbm2K6iKhz9JbdRDBDIB?=
 =?us-ascii?Q?UdoCq9RAojZXr53fDv6PlhetxHhwYRzsNct+S5iV5gErLVCz7t+IheqSHDJk?=
 =?us-ascii?Q?HgnIz1KPCXMkV9JP+WsPzG+Y0kbRml5Lg+sDdComDaQRlmeSGa2Y7BH+bwjs?=
 =?us-ascii?Q?jUN5/FbQO9x2rrsTTonUKmJ0mucx3AO2aS0T6AwB5zA/fwr/vxsAyK3VxJUz?=
 =?us-ascii?Q?LqvYzb4nbAV67nXOKAArr6nR0lR/E7QERUFezMw3Omt42TXJNIVof7SbFVBj?=
 =?us-ascii?Q?t8peY3Fz2TUkIul24juS/7RHvzpq66xu4KG4Vq1BIcZe18GbHGwDSL4k955W?=
 =?us-ascii?Q?CK6MiYcsRwB/UOlxxqoDclyZ5A2cJdmMYdCi3EE1Ick0rt+dy9StmwALxibc?=
 =?us-ascii?Q?BX+stDZlRRbBqTvuRngEYuBuWs7tpQiZvtf21u9c9lnzuSzzNNib6JbvQqbe?=
 =?us-ascii?Q?THHLSV+rRUGpcxwAp/9xOwAseIH3YEaUmXRmLBw3OjqBuDtSq5gC/zIGTHXc?=
 =?us-ascii?Q?6zlspSmUiU3MOXG0I09PIG0DeTZA1X89YBwFmB4kXkds6TMC4bFjICMHt3bu?=
 =?us-ascii?Q?+A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	NdNR6/ZGTdBfSPLk9WyG6UuCW3K92xfk5eF19rndecLNTtmbKm5Tu47Wiv9Ac8kpsPTnKJtr1ZpDulqhLxcDbkeAp/5T2U98ZbnP1bdIq/2R8K9Q7BUt9GaQMjhbiXRQoIgN3rEM23EE/9MmegvKTatHHLXSK9/y6POKo0nbWYzazw0Gr8BtesNjb1OJRhecBpvPLS3o89J4+kSz1n9dRsPTPhFSM4laC9u6Q87YFcBIkuRLiwiDDvTYgRRdPhlYHMGJJhNvaop085mhKnOdFuFBlSyVUrSj9tAtoq+Auwnh8CROiJU4YRKzffAb2Q+rR2OPKKDUam95inZ28B/50k+praQ8Ele5u/cd2aYR8BWlUmIpZ4ulXWgJAL8PlOf75eYeaQmnhWGdbQeWABiwDwFuJEOjv7ry5V6QCOdJol8wha7ud250crNtQwujHG8A5LCyRJa3koeLFFAB9VRf+s5DE5IeqNvGi3wZyXsz9rvprmQk2i7f0Rfv1n1saWPonca8lE9RgcFK+2TK7KlmLtaUAW8AaVv/nH49XURTfxG63D4yuC4tnQiNmUlGt6W5gRTc/yIneFV3bpPO4/x+rMCSTURyvgocTdaNY9b2N9s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e57c8b1-885a-4ad1-d6a6-08dcc9432a76
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2024 22:29:09.6285
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g4vu2W7WzanWYY5JXB0eLfWBkDTP+8A+2HUAjn+Xzt/NgcWq6+GUoHJvDqxRMPTIt6tsd9VBlgSicmj+WuRVQ2zUGVz0GfpyFhMCn/U+pzA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5077
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-30_12,2024-08-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 spamscore=0 malwarescore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2407110000 definitions=main-2408300174
X-Proofpoint-ORIG-GUID: b2gMZpWzuaXb4eg-8K9uTMApnjqhrvW-
X-Proofpoint-GUID: b2gMZpWzuaXb4eg-8K9uTMApnjqhrvW-

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


