Return-Path: <kvm+bounces-57750-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BAC7B59E11
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 18:46:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 93FFD5808EF
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 16:45:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 690BB320A38;
	Tue, 16 Sep 2025 16:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="tAWqyt5g";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="EoCjTVXm"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16A8B3016E1
	for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 16:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758041101; cv=fail; b=iWnwXoXE1lL9NkItGf/cPgwzah2LraRG1D5Mw0/l2zVZRGpTdxM7pIhZUWJcOO3OsNEabXrsBR9lSu+eAwvV46PpKqsIThnEsQwPyz7C69fttIizdeeuZnX48+/zno7ag3dBdgtuKC8r365IIXSHYR9AcBcVOrLz1RuDAlTNeyo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758041101; c=relaxed/simple;
	bh=rfQyMUXHlB/TRZ6r5bx9NiabRQHZFsp7XnxoEFRcyog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=A76EOUQgXe2vSAsXTS2nltOawNcbyqDNp547nmREW0aaa4zQ/K6fA9tBUPXJZDGoa01KweS5Ie1HzA9VUGPmJlpgRCehpZc3ug1nGSJjoIeWYIFQ3EviHACoaipuxtpK1QCRXp8UNutiLESxHncjxsgCDpC3RJyEZ3v0nXmoe54=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=tAWqyt5g; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=EoCjTVXm; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 58GGVbp43598659;
	Tue, 16 Sep 2025 09:44:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=O53JbwNpBrieS5UJrB9zFScZGNGrmHW8KxzAzRNEQ
	mQ=; b=tAWqyt5gKIGPYHk4H1tWqOOz83p9nwMGHhe92767AxPfjJQ/ho+E/SIKU
	1y/arWnP7tzmriHyz6/EU7e4lFyHrF1xrjBtXZ8y+6cPU3yTPbIPEVc3cIclcKvC
	cUYtSZu6uk+I5RYUM6P6bNmUI9Nel03nVFT6hQlCVizZNi5PZFzKM0XLJEsE2xkI
	10YeXch9SXgVa+uGdgDkDVpCJIgP4yiFqzvFuuCfx5XknecNxlCZSP0BgYbQABud
	bxOWSaN7XAJRYBITpD1AQEu34OixpPbmtUmQpM/blCvjd0Ye2xJGWygq2hQ5bctH
	k5SgWPKQYuFTM7tAcZLt25/AQDrtA==
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11021100.outbound.protection.outlook.com [40.93.194.100])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 496pby2vm0-2
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 16 Sep 2025 09:44:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uulfnuhLfuRWMqtMbmvu7JQNTy+DUG6zcL8sNwcE0Njadd1/EYcE7t4Bzru9A7NeHxBWzd1E6K+V4yx/uAdtsg2HRLMOsNbFkgU09qNGVaxeUSpaVsao1vRg59T1GywPkmj2cId/rH0EDGtGiRQDrqIfj+hDqeTduO9sHrhLZosFE0ick3CCO9NNWmen+dxOG2T7wufqTbWzkKuW7Chzszyuu5CNwKwnoAPAujx3YN/79HFy+xTxKEuRCF5Ar2UFnU9iAHZkCK55YhCDipmdf3+spoiH7zFmpJL1yUYP7YMhYVLFyQWOhXyExmEDmR4nODCtFpBqPuLgnNWRZxPgLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O53JbwNpBrieS5UJrB9zFScZGNGrmHW8KxzAzRNEQmQ=;
 b=FvnNQ5Fj+WW39nUpNsznBszrjbY01Fk1xT36clTllKQfWYVQsq8diBIGcXuAGr81gPYI+W45/xIb5NCx0N/CMiTcr0bY8gUSnk45YKhJSD4fDhJYQ2t7TlgEqCBmgN05xS1N67OLKo3ifgsJxguICfEieZW6N7Wow/3U4UffMLN8+DDz2h3hWFF3sJDiEwFl5QeVPzpuTL/NzXA0zJF0XZt2H1ym5tvihHYjpsNH5MpX7asIq8pYLfW6ldyp/Oi7Wf936pdSRIj0SZ74d3aOiprwA5tYPsShw7uSX4oy81HdzOlwUwgEnodv9jQlRwFG3Je66TWOVo+/xxDkV+WDdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O53JbwNpBrieS5UJrB9zFScZGNGrmHW8KxzAzRNEQmQ=;
 b=EoCjTVXmmCmsxLAIZIo+XrtpfuGeKlTW53lPtq2Cj6+HUgPwjinNhj2PNdJRQrQaFNuX2PC8p0GWhwQtKVBgeZ5sfYSJmhTVPwVieCk+GV3+TjyHmZeyTMEG/G2EKZ2vr6Xg6Jsa8CyV/ncZ6TQdI7G9N+ShYNpYXSvLil/vQQPkX8htDlAGa8IZHhEvrS//IFjLXLUFhnvj0OusINMX7OsmVqq5TkLk75wXGYuUJjL6OtvXFkQ0tPy/ze9PS0ALzt9HmypI3r6eTyRhg/8YomgPe1Cp5wrbwUHG9O/vz5cVHFAXbj43x6OnFd4yF8eMXg1U9PcCQEGpxL0Icjc0xA==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by PH0PR02MB8501.namprd02.prod.outlook.com
 (2603:10b6:510:100::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Tue, 16 Sep
 2025 16:44:54 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%5]) with mapi id 15.20.9115.022; Tue, 16 Sep 2025
 16:44:53 +0000
From: Jon Kohler <jon@nutanix.com>
To: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
Cc: Jon Kohler <jon@nutanix.com>
Subject: [kvm-unit-tests PATCH 15/17] x86/vmx: switch to new vmx.h entry controls
Date: Tue, 16 Sep 2025 10:22:44 -0700
Message-ID: <20250916172247.610021-16-jon@nutanix.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250916172247.610021-1-jon@nutanix.com>
References: <20250916172247.610021-1-jon@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH1PEPF00013309.namprd07.prod.outlook.com
 (2603:10b6:518:1::18) To LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR02MB10287:EE_|PH0PR02MB8501:EE_
X-MS-Office365-Filtering-Correlation-Id: dbe54a4a-fe9b-47b0-9958-08ddf5405c9b
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|52116014|376014|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yWe+CGmsJ3IgU1abT+VuFcazlNowf7hZ0L5GJdAeYKjERlktMuz6wQfO0tUp?=
 =?us-ascii?Q?7LMZNTCdYzDnScnxIVn0ZQvn++qNieT1NsbEih6B39S5mScOGrNFP+8T6e2U?=
 =?us-ascii?Q?d5Rrfke/3MEYthHyII529Pzp5m2gXCbtRp7z2btrcNNOyTp8UgoYNKqd+9JO?=
 =?us-ascii?Q?gET1eyEQm40prwoVGZhGpCmrxm6NR5/qM8tqZASi7Dtiya1aPOZy8Pn+VSQJ?=
 =?us-ascii?Q?xC1VhFoxiRET1VVxdAh9OW8JxPMb7MCGAx/9GpuQfHizbKVN1x3ORNRBmldG?=
 =?us-ascii?Q?4fYBkuZBd46yODHtu1qOkv/V78I7F2xJkalQyvjamce9UvH90BVBe4wGeV0U?=
 =?us-ascii?Q?nZ1AVUZH+TDd2dwXPPCvmp4xk3dsrVbCNo6/5sjUKgsYXw0wiqQwuciS8lAc?=
 =?us-ascii?Q?3WJWHBrnDhoxzh3xghDgq9FcEZgob+I+yfS7Em/oo3PO3yvBCRinUHXFs0lS?=
 =?us-ascii?Q?A+haaIxqBpJliFSB1JSQWNf0BGR4UCCTPjiVDl9Jc5F2xRNf+OcewULLycZa?=
 =?us-ascii?Q?LuQkGzTlP3o9SHucVUko8zdUUsk6UDsS07oqV96iFPN8YHRQkxXXxdirnLKV?=
 =?us-ascii?Q?Kc8AYYnGFLIup7UOUk1s+dQKa3mR3zdzS3U6S/RTWaUZW1q3mWVvterlkr9y?=
 =?us-ascii?Q?/S4PB4bTVofskhOjeP+jmKA+4/tGPCaOLegHB/oc5dJN9hfo3g1/ju7jHCyH?=
 =?us-ascii?Q?3+mmK8EnDIu2qTgshwxBxCc744wQvA5oIBT1JUwCKF1g925rHLdY4VGrTKbF?=
 =?us-ascii?Q?4gE9QiQK+Dr1WnqNsHOnAzMMskDaZVDh5xK5f2Ji8wGDJL1T7AV5U/fdUyXf?=
 =?us-ascii?Q?SQt4udk8gFlohNB178m1cfqgd4M6hKYQUd99yZhF28xIq5oQpGdC9Ol8GUyV?=
 =?us-ascii?Q?2zH7npnOauDn+2ZsXmoaugZMxq6bwjrwy+dUx3bMgdHAWZkDFEHy3SdTpMOw?=
 =?us-ascii?Q?wzsaRTo7n1VwuTgNV/wCl4Gj5hGzGnis9WALlSQjFa7AD6m6UABxTDT3hqEU?=
 =?us-ascii?Q?GRG0fBKbqGv5IV9ngrAJKuo9Wy/sYajR23hFGdvHoVklIRZpf/WIbssBbcwv?=
 =?us-ascii?Q?bltqI0+mbgEYJHqEIjh+dkQSnKS9Rctp/0QksBomz1TAsYUdk/bz1WZ5/U3B?=
 =?us-ascii?Q?fK37yPadAT3nIvNt/aC2B68Y6etVj3Ziid9nKn0NKEkXOJbCVDSxVEWIHpH4?=
 =?us-ascii?Q?GAXszZ8WEsXdUOtu/FLtF0DoooJPqP8HIksaGZCg4zZi/eB/HuDpDqHAbEbn?=
 =?us-ascii?Q?YMnA0I9LUiQObLRYt4hI0nETjgXpOWFiMABJeAlhc4WCF9nLCM/+ioJN5s4H?=
 =?us-ascii?Q?USM0/n2LF2gto+7KRRW3TGRe7Pe+d2NB4HTaKpu1+Ban9N1zml+9ze+1TvXv?=
 =?us-ascii?Q?yeJynpe5Kg+3htMLTFp5y/SALtzUltFC+B8mNJ83/kgl6fQZE5Lx/7OuxbMA?=
 =?us-ascii?Q?/uRCiKBJtN6AC2aJjzfXqL5bwIIW7h7tMaY2luPKYe3T0OAMMfHVUQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(52116014)(376014)(1800799024)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7S0w+JxNmokWwgNwLZ223QqPy+qdKOPaDYH6XeB7Ztd/ymg+nmyYS71Ur17M?=
 =?us-ascii?Q?VSm3n4h3e2v53AOcxt8lDhW4RntnV6r1cQegvbWV96DqaMbfTg6Si/g+qNrR?=
 =?us-ascii?Q?8bW4v84ovFh4U2o4Xksu3tIE28ev+XACUIINmw2fSsl0S5k9NxE8Gb+JfgB9?=
 =?us-ascii?Q?MdXoUXLlHZ6A/dbs3U9xGJXJ1c2gXGnouNTYRCGgINTCK3AXGVslZpMG9AeI?=
 =?us-ascii?Q?M2Cd2A8JPEcs5H+O31YE56em1qBG1tInIFHcaOPn9ZGAbmOC6QGbXM/VPrmA?=
 =?us-ascii?Q?7Djr96zzdbds7ngRVPvLX0tSZC06P0t0f6drFjHQ4VbxD3FX5K2yOOYO3HV7?=
 =?us-ascii?Q?zxAymw6O1sMwUirTv7UxW0cMh3gnUVFSOkRJGbvAVeNz8jGj2vcdfZnEjg/X?=
 =?us-ascii?Q?330RLTe7RAIom82sOX24mW+GWhCOkK37BqIQLNgvaldtoWuOx1ApK+AL+EAp?=
 =?us-ascii?Q?GV2FUUpPiywbG1zApDj9SAvqO3SfosZ/c1CKtljn4QJLZjD8P4JyukO6mRB2?=
 =?us-ascii?Q?JP4uD9nlJPQQgHTDdCXXDAlee05Km0cEK1GwQGPcQESLez4fziKMI5d0W+WB?=
 =?us-ascii?Q?i9KhVsmkeyg9cGEuaK/dG4PFBQsAFAupTuM4Ed98Y1od/ngk9BiuPuXzbGYd?=
 =?us-ascii?Q?q/IoHU/i7B/YnRjC4Zn5H4KcIFSbiNnM6K1HrwU2fJ3u+37IOWi/4Dm5DQuF?=
 =?us-ascii?Q?9ANYl/kLV6vPsa4gwfDQX/0xNqCpCVtgnI9izFtZFTfqEjHhC739281XstZ6?=
 =?us-ascii?Q?6S3yMxTmFlcBzkVD9h4d0IuwGrH06dJDy96TjI3QvGYY65mkD8nyY+yn8V6J?=
 =?us-ascii?Q?Q4NyD6GUahik1KIHXTeCFrz2Fn72jh75bC0xQT4TDLkh7APQCrX6+fTeMTzc?=
 =?us-ascii?Q?N7U4bdJVXFcSnjLZEoR7v0muy2k+rpi5IoBmqcunl6BVmHyj6RBoQEMHXC/i?=
 =?us-ascii?Q?FRXVxk4Lt6Z6tt94IUUUwOQkAOJVDV1rv0wjEaC5blt4zX47P5SLrIpkmvPz?=
 =?us-ascii?Q?rdG89LQLjAHNg8R7gcXTMH4tSKJNJPuT4WHi9t33O+oY3iCvb2clf0nWBP0u?=
 =?us-ascii?Q?HBPI/tPZfst2ClAVYSr0Cmc45K16qkKVf3EcS4iQ1stLvP9MTGx6tHc5HLzq?=
 =?us-ascii?Q?qjZCMNNXvKdZaohFAqkMLR5EBlvTKioTCQ7BF+rvyie9Xhfocu6lG3+mappW?=
 =?us-ascii?Q?3FU5BJDvlwcbC2fADZR6mHArrum3iaXkEtXiRmC4zgMoiPHf3kk4NJDwotnd?=
 =?us-ascii?Q?irq+eQwHc9RADOQJsyMI7Fdj6Ij44kEqbqFtTRR90uW2600ezYi5QCUtpjg+?=
 =?us-ascii?Q?+37MYQtjLq0uwIzGYEpP8M8YTRCBlVbegpRnLWdJF8qqXHepxdOhnEp4lY/i?=
 =?us-ascii?Q?VJ/efGf4vW23coOaH1hzntigxFV6sj9jnRjS7pVW1SEnKYtWVp5TQhf6Ptnp?=
 =?us-ascii?Q?ak2zXb/Td1qCa85G/CYeNlFl6V/vWr6HCO4FtThyx10atbjEPPUAKJYKf73d?=
 =?us-ascii?Q?1nLkI3oO8xqeyVV0ZLTdnFMgh4N/v69fHz/XW3e9Lfbg3/mQXIIeYhOoOBXQ?=
 =?us-ascii?Q?8LLg2t1GDv1im2CG6KoEimQAd1IBlGSJLNzfzJM2Gnsehtmqv4uEsYFqIHTS?=
 =?us-ascii?Q?jA=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbe54a4a-fe9b-47b0-9958-08ddf5405c9b
X-MS-Exchange-CrossTenant-AuthSource: LV8PR02MB10287.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 16:44:53.8650
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mGuxy2YLRP1LYCBMInqnrzP0gQJD8R2fAoLY5YaLr0Tn1B8/+Fpvw/6NByVu9TZ+f548n1xXtUCbe/r2LZu8kLw2fV1CMOkmNc+5Oa5pexM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR02MB8501
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDE1NSBTYWx0ZWRfXx3PjioZ123n7
 Nf/Fdse+Y0YIqAhhKKdTD4CH2EL9MQAGsqyQ7QLKSrGYu2lX6y9LxV19O7MYtmdHu4lP1hwVpIr
 Mm62OqGZC20CRjOhnz2/EvTwBWfDYLH65wfGdmtZJlI76aQbimkcZHOfknnMi71X+4MECoiJrJf
 awuCMmc/FYHrNgrgDe3KSFCiQmSh4LYIHVxHRnlCRWaMvo1d8MIOVRV0Gm7xFSoLqLRDjB1YmDm
 vZJljaxFUIQzhnCGmq3wOtiQTvGXMeQm0FeDP1RiD26AD1bVD4kwxaJKqmK4uQX7gvJAsxcAFFw
 lo33YUwPgaZKTPahH9pDWAgsxkISN3mUVYX/+/1n27rn9Iot0++AwMdGMi0z7g=
X-Authority-Analysis: v=2.4 cv=ePoTjGp1 c=1 sm=1 tr=0 ts=68c99407 cx=c_pps
 a=q7lH8giswqu+5i8oUQ1grQ==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10 a=0kUYKlekyDsA:10 a=64Cc0HZtAAAA:8
 a=9wdMms_18sAHOBYaV_8A:9
X-Proofpoint-ORIG-GUID: KqcG1Kaw1p2TKhgB_tkypBadWDyTvzBC
X-Proofpoint-GUID: KqcG1Kaw1p2TKhgB_tkypBadWDyTvzBC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-16_02,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Reason: safe

Migrate to new vmx.h's entry controls, which makes it easier to grok
from one code base to another.

No functional change intended.

Signed-off-by: Jon Kohler <jon@nutanix.com>

---
 x86/vmx.c       |  6 +--
 x86/vmx.h       |  9 -----
 x86/vmx_tests.c | 97 ++++++++++++++++++++++++++-----------------------
 3 files changed, 55 insertions(+), 57 deletions(-)

diff --git a/x86/vmx.c b/x86/vmx.c
index bd16e833..7be93a72 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -1167,11 +1167,11 @@ static void init_vmcs_guest(void)
 	guest_cr0 = read_cr0();
 	guest_cr4 = read_cr4();
 	guest_cr3 = read_cr3();
-	if (ctrl_enter & ENT_GUEST_64) {
+	if (ctrl_enter & VM_ENTRY_IA32E_MODE) {
 		guest_cr0 |= X86_CR0_PG;
 		guest_cr4 |= X86_CR4_PAE;
 	}
-	if ((ctrl_enter & ENT_GUEST_64) == 0)
+	if ((ctrl_enter & VM_ENTRY_IA32E_MODE) == 0)
 		guest_cr4 &= (~X86_CR4_PCIDE);
 	if (guest_cr0 & X86_CR0_PG)
 		guest_cr0 |= X86_CR0_PE;
@@ -1260,7 +1260,7 @@ int init_vmcs(struct vmcs **vmcs)
 	ctrl_exit = VM_EXIT_LOAD_IA32_EFER |
 		    VM_EXIT_HOST_ADDR_SPACE_SIZE |
 		    VM_EXIT_LOAD_IA32_PAT;
-	ctrl_enter = (ENT_LOAD_EFER | ENT_GUEST_64);
+	ctrl_enter = (VM_ENTRY_LOAD_IA32_EFER | VM_ENTRY_IA32E_MODE);
 	/* DIsable IO instruction VMEXIT now */
 	ctrl_cpu[0] &= (~(CPU_BASED_UNCOND_IO_EXITING | CPU_BASED_USE_IO_BITMAPS));
 	ctrl_cpu[1] = 0;
diff --git a/x86/vmx.h b/x86/vmx.h
index 30503ff4..8bb49d8e 100644
--- a/x86/vmx.h
+++ b/x86/vmx.h
@@ -406,15 +406,6 @@ enum Reason {
 	VMX_XRSTORS		= 64,
 };
 
-enum Ctrl_ent {
-	ENT_LOAD_DBGCTLS	= 1UL << 2,
-	ENT_GUEST_64		= 1UL << 9,
-	ENT_LOAD_PERF		= 1UL << 13,
-	ENT_LOAD_PAT		= 1UL << 14,
-	ENT_LOAD_EFER		= 1UL << 15,
-	ENT_LOAD_BNDCFGS	= 1UL << 16
-};
-
 enum Intr_type {
 	VMX_INTR_TYPE_EXT_INTR = 0,
 	VMX_INTR_TYPE_NMI_INTR = 2,
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 77a63a3e..2f9858a3 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -316,14 +316,14 @@ static int test_ctrl_pat_init(struct vmcs *vmcs)
 	msr_bmp_init();
 	if (!(ctrl_exit_rev.clr & VM_EXIT_SAVE_IA32_PAT) &&
 	    !(ctrl_exit_rev.clr & VM_EXIT_LOAD_IA32_PAT) &&
-	    !(ctrl_enter_rev.clr & ENT_LOAD_PAT)) {
+	    !(ctrl_enter_rev.clr & VM_ENTRY_LOAD_IA32_PAT)) {
 		printf("\tSave/load PAT is not supported\n");
 		return 1;
 	}
 
 	ctrl_ent = vmcs_read(ENT_CONTROLS);
 	ctrl_exi = vmcs_read(EXI_CONTROLS);
-	ctrl_ent |= ctrl_enter_rev.clr & ENT_LOAD_PAT;
+	ctrl_ent |= ctrl_enter_rev.clr & VM_ENTRY_LOAD_IA32_PAT;
 	ctrl_exi |= ctrl_exit_rev.clr & (VM_EXIT_SAVE_IA32_PAT |
 					 VM_EXIT_LOAD_IA32_PAT);
 	vmcs_write(ENT_CONTROLS, ctrl_ent);
@@ -339,7 +339,7 @@ static void test_ctrl_pat_main(void)
 	u64 guest_ia32_pat;
 
 	guest_ia32_pat = rdmsr(MSR_IA32_CR_PAT);
-	if (!(ctrl_enter_rev.clr & ENT_LOAD_PAT))
+	if (!(ctrl_enter_rev.clr & VM_ENTRY_LOAD_IA32_PAT))
 		printf("\tENT_LOAD_PAT is not supported.\n");
 	else {
 		if (guest_ia32_pat != 0) {
@@ -350,7 +350,7 @@ static void test_ctrl_pat_main(void)
 	wrmsr(MSR_IA32_CR_PAT, 0x6);
 	vmcall();
 	guest_ia32_pat = rdmsr(MSR_IA32_CR_PAT);
-	if (ctrl_enter_rev.clr & ENT_LOAD_PAT)
+	if (ctrl_enter_rev.clr & VM_ENTRY_LOAD_IA32_PAT)
 		report(guest_ia32_pat == ia32_pat, "Entry load PAT");
 }
 
@@ -390,7 +390,7 @@ static int test_ctrl_efer_init(struct vmcs *vmcs)
 	u64 ctrl_exi;
 
 	msr_bmp_init();
-	ctrl_ent = vmcs_read(ENT_CONTROLS) | ENT_LOAD_EFER;
+	ctrl_ent = vmcs_read(ENT_CONTROLS) | VM_ENTRY_LOAD_IA32_EFER;
 	ctrl_exi = vmcs_read(EXI_CONTROLS) |
 		   VM_EXIT_SAVE_IA32_EFER |
 		   VM_EXIT_LOAD_IA32_EFER;
@@ -407,7 +407,7 @@ static void test_ctrl_efer_main(void)
 	u64 guest_ia32_efer;
 
 	guest_ia32_efer = rdmsr(MSR_EFER);
-	if (!(ctrl_enter_rev.clr & ENT_LOAD_EFER))
+	if (!(ctrl_enter_rev.clr & VM_ENTRY_LOAD_IA32_EFER))
 		printf("\tENT_LOAD_EFER is not supported.\n");
 	else {
 		if (guest_ia32_efer != (ia32_efer ^ EFER_NX)) {
@@ -418,7 +418,7 @@ static void test_ctrl_efer_main(void)
 	wrmsr(MSR_EFER, ia32_efer);
 	vmcall();
 	guest_ia32_efer = rdmsr(MSR_EFER);
-	if (ctrl_enter_rev.clr & ENT_LOAD_EFER)
+	if (ctrl_enter_rev.clr & VM_ENTRY_LOAD_IA32_EFER)
 		report(guest_ia32_efer == ia32_efer, "Entry load EFER");
 }
 
@@ -1922,7 +1922,8 @@ static int dbgctls_init(struct vmcs *vmcs)
 	vmcs_write(GUEST_DR7, 0x404);
 	vmcs_write(GUEST_DEBUGCTL, 0x2);
 
-	vmcs_write(ENT_CONTROLS, vmcs_read(ENT_CONTROLS) | ENT_LOAD_DBGCTLS);
+	vmcs_write(ENT_CONTROLS,
+		   vmcs_read(ENT_CONTROLS) | VM_ENTRY_LOAD_DEBUG_CONTROLS);
 	vmcs_write(EXI_CONTROLS,
 		   vmcs_read(EXI_CONTROLS) | VM_EXIT_SAVE_DEBUG_CONTROLS);
 
@@ -1947,7 +1948,7 @@ static void dbgctls_main(void)
 	vmcall();
 	report(vmx_get_test_stage() == 1, "Save debug controls");
 
-	if (ctrl_enter_rev.set & ENT_LOAD_DBGCTLS ||
+	if (ctrl_enter_rev.set & VM_ENTRY_LOAD_DEBUG_CONTROLS ||
 	    ctrl_exit_rev.set & VM_EXIT_SAVE_DEBUG_CONTROLS) {
 		printf("\tDebug controls are always loaded/saved\n");
 		return;
@@ -1998,7 +1999,8 @@ static int dbgctls_exit_handler(union exit_reason exit_reason)
 			vmcs_write(GUEST_DEBUGCTL, 0x2);
 
 			vmcs_write(ENT_CONTROLS,
-				vmcs_read(ENT_CONTROLS) & ~ENT_LOAD_DBGCTLS);
+				   vmcs_read(ENT_CONTROLS) &
+				   ~VM_ENTRY_LOAD_DEBUG_CONTROLS);
 			vmcs_write(EXI_CONTROLS,
 				   vmcs_read(EXI_CONTROLS) &
 				   ~VM_EXIT_SAVE_DEBUG_CONTROLS);
@@ -5382,7 +5384,7 @@ static void vmx_mtf_pdpte_test(void)
 	 * when the guest started out in long mode.
 	 */
 	ent_ctls = vmcs_read(ENT_CONTROLS);
-	vmcs_write(ENT_CONTROLS, ent_ctls & ~ENT_GUEST_64);
+	vmcs_write(ENT_CONTROLS, ent_ctls & ~VM_ENTRY_IA32E_MODE);
 
 	guest_efer = vmcs_read(GUEST_EFER);
 	vmcs_write(GUEST_EFER, guest_efer & ~(EFER_LMA | EFER_LME));
@@ -7299,11 +7301,11 @@ static void test_efer_one(u32 fld, const char * fld_name, u64 efer,
 		if (!!(efer & EFER_LME) != !!(ctrl & VM_EXIT_HOST_ADDR_SPACE_SIZE))
 			ok = false;
 	}
-	if (ctrl_fld == ENT_CONTROLS && (ctrl & ENT_LOAD_EFER)) {
+	if (ctrl_fld == ENT_CONTROLS && (ctrl & VM_ENTRY_LOAD_IA32_EFER)) {
 		/* Check LMA too since CR0.PG is set.  */
-		if (!!(efer & EFER_LMA) != !!(ctrl & ENT_GUEST_64))
+		if (!!(efer & EFER_LMA) != !!(ctrl & VM_ENTRY_IA32E_MODE))
 			ok = false;
-		if (!!(efer & EFER_LME) != !!(ctrl & ENT_GUEST_64))
+		if (!!(efer & EFER_LME) != !!(ctrl & VM_ENTRY_IA32E_MODE))
 			ok = false;
 	}
 
@@ -7312,7 +7314,7 @@ static void test_efer_one(u32 fld, const char * fld_name, u64 efer,
 	 * Perhaps write the test in assembly and make sure it
 	 * can be run in either mode?
 	 */
-	if (fld == GUEST_EFER && ok && !(ctrl & ENT_GUEST_64))
+	if (fld == GUEST_EFER && ok && !(ctrl & VM_ENTRY_IA32E_MODE))
 		return;
 
 	vmcs_write(ctrl_fld, ctrl);
@@ -7446,15 +7448,15 @@ static void test_host_efer(void)
  */
 static void test_guest_efer(void)
 {
-	if (!(ctrl_enter_rev.clr & ENT_LOAD_EFER)) {
+	if (!(ctrl_enter_rev.clr & VM_ENTRY_LOAD_IA32_EFER)) {
 		report_skip("%s : \"Load-IA32-EFER\" entry control not supported", __func__);
 		return;
 	}
 
 	vmcs_write(GUEST_EFER, rdmsr(MSR_EFER));
 	test_efer(GUEST_EFER, "GUEST_EFER", ENT_CONTROLS,
-		  ctrl_enter_rev.clr & ENT_LOAD_EFER,
-		  ENT_GUEST_64);
+		  ctrl_enter_rev.clr & VM_ENTRY_LOAD_IA32_EFER,
+		  VM_ENTRY_IA32E_MODE);
 }
 
 /*
@@ -7487,8 +7489,8 @@ static void test_pat(u32 field, const char * field_name, u32 ctrl_field,
 				report_prefix_pop();
 
 			} else {	// GUEST_PAT
-				test_guest_state("ENT_LOAD_PAT disabled", false,
-						 val, "GUEST_PAT");
+				test_guest_state("VM_ENTRY_LOAD_IA32_PAT disabled",
+						 false, val, "GUEST_PAT");
 			}
 		}
 	}
@@ -7520,7 +7522,7 @@ static void test_pat(u32 field, const char * field_name, u32 ctrl_field,
 
 			} else {	// GUEST_PAT
 				error = (i == 0x2 || i == 0x3 || i >= 0x8);
-				test_guest_state("ENT_LOAD_PAT enabled", !!error,
+				test_guest_state("VM_ENTRY_LOAD_IA32_PAT enabled", !!error,
 						 val, "GUEST_PAT");
 
 				if (!(ctrl_exit_rev.clr & VM_EXIT_LOAD_IA32_PAT))
@@ -7725,13 +7727,14 @@ static void test_load_guest_perf_global_ctrl(void)
 		return;
 	}
 
-	if (!(ctrl_enter_rev.clr & ENT_LOAD_PERF)) {
+	if (!(ctrl_enter_rev.clr & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL)) {
 		report_skip("%s : \"Load IA32_PERF_GLOBAL_CTRL\" entry control not supported", __func__);
 		return;
 	}
 
 	test_perf_global_ctrl(GUEST_PERF_GLOBAL_CTRL, "GUEST_PERF_GLOBAL_CTRL",
-				   ENT_CONTROLS, "ENT_CONTROLS", ENT_LOAD_PERF);
+			      ENT_CONTROLS, "ENT_CONTROLS",
+			      VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL);
 }
 
 
@@ -7912,7 +7915,7 @@ static void test_host_addr_size(void)
 	assert(vmcs_read(EXI_CONTROLS) & VM_EXIT_HOST_ADDR_SPACE_SIZE);
 	assert(cr4_saved & X86_CR4_PAE);
 
-	vmcs_write(ENT_CONTROLS, entry_ctrl_saved | ENT_GUEST_64);
+	vmcs_write(ENT_CONTROLS, entry_ctrl_saved | VM_ENTRY_IA32E_MODE);
 	report_prefix_pushf("\"IA-32e mode guest\" enabled");
 	test_vmx_vmlaunch(0);
 	report_prefix_pop();
@@ -7935,7 +7938,7 @@ static void test_host_addr_size(void)
 	test_vmx_vmlaunch_must_fail(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD);
 	report_prefix_pop();
 
-	vmcs_write(ENT_CONTROLS, entry_ctrl_saved | ENT_GUEST_64);
+	vmcs_write(ENT_CONTROLS, entry_ctrl_saved | VM_ENTRY_IA32E_MODE);
 	vmcs_write(HOST_RIP, rip_saved);
 	vmcs_write(HOST_CR4, cr4_saved);
 
@@ -7994,22 +7997,22 @@ static void test_guest_dr7(void)
 	u64 val;
 	int i;
 
-	if (ctrl_enter_rev.set & ENT_LOAD_DBGCTLS) {
-		vmcs_clear_bits(ENT_CONTROLS, ENT_LOAD_DBGCTLS);
+	if (ctrl_enter_rev.set & VM_ENTRY_LOAD_DEBUG_CONTROLS) {
+		vmcs_clear_bits(ENT_CONTROLS, VM_ENTRY_LOAD_DEBUG_CONTROLS);
 		for (i = 0; i < 64; i++) {
 			val = 1ull << i;
 			vmcs_write(GUEST_DR7, val);
-			test_guest_state("ENT_LOAD_DBGCTLS disabled", false,
-					 val, "GUEST_DR7");
+			test_guest_state("VM_ENTRY_LOAD_DEBUG_CONTROLS disabled",
+					 false, val, "GUEST_DR7");
 		}
 	}
-	if (ctrl_enter_rev.clr & ENT_LOAD_DBGCTLS) {
-		vmcs_set_bits(ENT_CONTROLS, ENT_LOAD_DBGCTLS);
+	if (ctrl_enter_rev.clr & VM_ENTRY_LOAD_DEBUG_CONTROLS) {
+		vmcs_set_bits(ENT_CONTROLS, VM_ENTRY_LOAD_DEBUG_CONTROLS);
 		for (i = 0; i < 64; i++) {
 			val = 1ull << i;
 			vmcs_write(GUEST_DR7, val);
-			test_guest_state("ENT_LOAD_DBGCTLS enabled", i >= 32,
-					 val, "GUEST_DR7");
+			test_guest_state("VM_ENTRY_LOAD_DEBUG_CONTROLS enabled",
+					 i >= 32, val, "GUEST_DR7");
 		}
 	}
 	vmcs_write(GUEST_DR7, dr7_saved);
@@ -8030,12 +8033,13 @@ static void test_load_guest_pat(void)
 	/*
 	 * "load IA32_PAT" VM-entry control
 	 */
-	if (!(ctrl_enter_rev.clr & ENT_LOAD_PAT)) {
+	if (!(ctrl_enter_rev.clr & VM_ENTRY_LOAD_IA32_PAT)) {
 		report_skip("%s : \"Load-IA32-PAT\" entry control not supported", __func__);
 		return;
 	}
 
-	test_pat(GUEST_PAT, "GUEST_PAT", ENT_CONTROLS, ENT_LOAD_PAT);
+	test_pat(GUEST_PAT, "GUEST_PAT", ENT_CONTROLS,
+		 VM_ENTRY_LOAD_IA32_PAT);
 }
 
 #define MSR_IA32_BNDCFGS_RSVD_MASK	0x00000ffc
@@ -8054,29 +8058,29 @@ static void test_load_guest_bndcfgs(void)
 	u64 bndcfgs_saved = vmcs_read(GUEST_BNDCFGS);
 	u64 bndcfgs;
 
-	if (!(ctrl_enter_rev.clr & ENT_LOAD_BNDCFGS)) {
+	if (!(ctrl_enter_rev.clr & VM_ENTRY_LOAD_BNDCFGS)) {
 		report_skip("%s : \"Load-IA32-BNDCFGS\" entry control not supported", __func__);
 		return;
 	}
 
-	vmcs_clear_bits(ENT_CONTROLS, ENT_LOAD_BNDCFGS);
+	vmcs_clear_bits(ENT_CONTROLS, VM_ENTRY_LOAD_BNDCFGS);
 
 	vmcs_write(GUEST_BNDCFGS, NONCANONICAL);
-	test_guest_state("ENT_LOAD_BNDCFGS disabled", false,
+	test_guest_state("VM_ENTRY_LOAD_BNDCFGS disabled", false,
 			 GUEST_BNDCFGS, "GUEST_BNDCFGS");
 	bndcfgs = bndcfgs_saved | MSR_IA32_BNDCFGS_RSVD_MASK;
 	vmcs_write(GUEST_BNDCFGS, bndcfgs);
-	test_guest_state("ENT_LOAD_BNDCFGS disabled", false,
+	test_guest_state("VM_ENTRY_LOAD_BNDCFGS disabled", false,
 			 GUEST_BNDCFGS, "GUEST_BNDCFGS");
 
-	vmcs_set_bits(ENT_CONTROLS, ENT_LOAD_BNDCFGS);
+	vmcs_set_bits(ENT_CONTROLS, VM_ENTRY_LOAD_BNDCFGS);
 
 	vmcs_write(GUEST_BNDCFGS, NONCANONICAL);
-	test_guest_state("ENT_LOAD_BNDCFGS enabled", true,
+	test_guest_state("VM_ENTRY_LOAD_BNDCFGS enabled", true,
 			 GUEST_BNDCFGS, "GUEST_BNDCFGS");
 	bndcfgs = bndcfgs_saved | MSR_IA32_BNDCFGS_RSVD_MASK;
 	vmcs_write(GUEST_BNDCFGS, bndcfgs);
-	test_guest_state("ENT_LOAD_BNDCFGS enabled", true,
+	test_guest_state("VM_ENTRY_LOAD_BNDCFGS enabled", true,
 			 GUEST_BNDCFGS, "GUEST_BNDCFGS");
 
 	vmcs_write(GUEST_BNDCFGS, bndcfgs_saved);
@@ -8335,7 +8339,8 @@ asm (".code32\n"
 static void setup_unrestricted_guest(void)
 {
 	vmcs_write(GUEST_CR0, vmcs_read(GUEST_CR0) & ~(X86_CR0_PG));
-	vmcs_write(ENT_CONTROLS, vmcs_read(ENT_CONTROLS) & ~ENT_GUEST_64);
+	vmcs_write(ENT_CONTROLS,
+		   vmcs_read(ENT_CONTROLS) & ~VM_ENTRY_IA32E_MODE);
 	vmcs_write(GUEST_EFER, vmcs_read(GUEST_EFER) & ~EFER_LMA);
 	vmcs_write(GUEST_RIP, virt_to_phys(unrestricted_guest_main));
 }
@@ -8343,7 +8348,8 @@ static void setup_unrestricted_guest(void)
 static void unsetup_unrestricted_guest(void)
 {
 	vmcs_write(GUEST_CR0, vmcs_read(GUEST_CR0) | X86_CR0_PG);
-	vmcs_write(ENT_CONTROLS, vmcs_read(ENT_CONTROLS) | ENT_GUEST_64);
+	vmcs_write(ENT_CONTROLS,
+		   vmcs_read(ENT_CONTROLS) | VM_ENTRY_IA32E_MODE);
 	vmcs_write(GUEST_EFER, vmcs_read(GUEST_EFER) | EFER_LMA);
 	vmcs_write(GUEST_RIP, (u64) phys_to_virt(vmcs_read(GUEST_RIP)));
 	vmcs_write(GUEST_RSP, (u64) phys_to_virt(vmcs_read(GUEST_RSP)));
@@ -9563,7 +9569,8 @@ static void vmx_db_test(void)
 	 */
 	if (this_cpu_has(X86_FEATURE_RTM)) {
 		vmcs_write(ENT_CONTROLS,
-			   vmcs_read(ENT_CONTROLS) | ENT_LOAD_DBGCTLS);
+			   vmcs_read(ENT_CONTROLS) |
+			   VM_ENTRY_LOAD_DEBUG_CONTROLS);
 		/*
 		 * Set DR7.RTM[bit 11] and IA32_DEBUGCTL.RTM[bit 15]
 		 * in the guest to enable advanced debugging of RTM
-- 
2.43.0


