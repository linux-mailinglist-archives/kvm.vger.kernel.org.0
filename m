Return-Path: <kvm+bounces-66771-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9249CCE67F0
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 12:19:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A72B63011A5B
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 11:18:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D164D30171A;
	Mon, 29 Dec 2025 11:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="XgK2FNMT";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="aj6C5IEk"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8D42749CF;
	Mon, 29 Dec 2025 11:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767007120; cv=fail; b=QB24wOmAQbrGMTUU1jPiW7A9thVmJi3zdds+OwZ9QN783KwowTW5qFkKb/Xdd+n16MlcCKZY3Q7/n8fvHD7eTmM6SiYxzATvmwuLqwTZ4zw/BeZ3VFGxq/KGpwA9O2nAzhwDJyRvS8AE3y5cRV1FlxaSoMHZdBtDAxNFiWR2R68=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767007120; c=relaxed/simple;
	bh=fx8FO3oHjez9pmKEpRBD/WrNGq9ezMGN+sF7HRELj6k=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=oGCaun9fsPdY32jkij1kYbkZcq6dk55znV9x97LJQNQXVOL2u12soTqwR1dd0GiwiNteOZGLplPe+E3eoa6G7nKhg0YfzgHixuz0SyeYdsxZIUyEpdfX2Mzw2yJPK9DoZHUhnN4t4PbryApIK+nJ4eO4jBPFy+WZ07CQFFrTQAA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=XgK2FNMT; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=aj6C5IEk; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BSJsnK8670278;
	Mon, 29 Dec 2025 03:17:42 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=proofpoint20171006; bh=5FRyFzeW8XaGD
	RCcJiwe7m+1ZgGeDBPjRDLmSt1+18c=; b=XgK2FNMTPF7mVMUqWIwmkNwBJ5n2A
	/cfFIk2Vz9VgxpS5nOxHPsDFQsI7G+D9fjy7/wLPlXG1GKQPVljELQgUTb1gCDuK
	RpSCLGI00HzjCnvCVtMRbhQVvU4X3XTMaegDp5NQOOQgXvm1KogPvMZ3uaiOaKM3
	MnQQW2DJqZVyWd5vH+3anzIK/fsSa7nqm1eSi+iv/ljUHiWDfH2/6esn+CEjlHN+
	4IhrhS+bfOktZ+DfrItAxQv890gbNj7W70jsYqITdNV/KUDlt9Y+CPupofuErCKW
	UQt2bRFMegrEl8Aml1+3PPAfiAPgQMKDN93tfLFVETf2yvZMKKWPPOf9A==
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11021103.outbound.protection.outlook.com [40.93.194.103])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4badv92mmq-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 29 Dec 2025 03:17:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bjkAUJKdM5O9u7ace7iC0pHz88bq7GOh85fw6RJe4nc3dx8BELEQ1/ub0NxaAdDgImXlDjKy5ixscpoqKJCVRGqQz7P9KIYxFoja9i63aYxagEaDFAvXzPF088F7P8G9WCzakkse3kXwrcbiRWYV3Yi9tOFCidFK2hmgSbDqXtXgeqtGvO9vbUYP2pE0dLfl0rfcyr55iJ5Os340q2SlRP59TA160ojqAbw+fc4HpfhcYq+EFel8f4M17R2EuZyh4OWYZJV2//0HhDs4Onot2h4agMJvYkMHbGUqOD0SYrmj5p9EgByQ2vedBNHmrbla7l8LLDi3J/PPbCrJbQUwPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5FRyFzeW8XaGDRCcJiwe7m+1ZgGeDBPjRDLmSt1+18c=;
 b=YcT7xlm6tQTE5I+qt7j9hW+/U+8Z837LDKxCqWLQjgHejWSxtrr0Q101Zql8mZE/SxfFqr49dQ88c6D+z/ZhwSohoS575ri1m4U3eJzgtwBENq4epCqOR8fJMCbvpAu+C+MZjdz6Tp23R//RRw5w2GqvdA4oYCLqMEfOsI/NXI2DkqNyn7s5j02iw+xiv44XxCwtxtrhkjqKFtkLy5BHdjM+7Uj7m7GfsyRXVHkBXu97tnA5EuirCOJ3JCcZ/ZoVH0TYJzS3D83EQTDjXxSGFns3zv3djnMKm/3oF/VsTGCx2gtRJFvDOFe3IM6mAAfcrEadq6H/n3bjNgbEGtHf6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5FRyFzeW8XaGDRCcJiwe7m+1ZgGeDBPjRDLmSt1+18c=;
 b=aj6C5IEkCBxzWR2OuWG/RgtOM3YPxYi16lIW7GnwVneIBL+g163NVZb/OlR+fUibD0ezMFbwXB0sVcrjUb4kXuynVnTHkUKPmPtVl38YBkh6U+Pg1YahrDoj7c8JhzwqEAWl2XXS2MI2on5I73cyW+k2CzRe2Ghjj2hyjgrftFv6HSb865dZGn4OAgmJ78grGRYVXrMhl7NSQfVSBA24hjPcfhz8Pi9qSciHPIXYD+UIDn7DNBF2NEVTNuM7fDuwHu1WRdpyNs4a56FSuRkP1RZ/5y/lQXPsaB6ywzGXlah0zg+9nYUjfNr5/DD4rQ/h7ewulPt0BaqxJB+DXuS31A==
Received: from PH0PR02MB7557.namprd02.prod.outlook.com (2603:10b6:510:54::17)
 by PH7PR02MB9965.namprd02.prod.outlook.com (2603:10b6:510:2f9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9456.14; Mon, 29 Dec
 2025 11:17:39 +0000
Received: from PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef]) by PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef%5]) with mapi id 15.20.9456.013; Mon, 29 Dec 2025
 11:17:39 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: seanjc@google.com, pbonzini@redhat.com, kai.huang@intel.com,
        dwmw2@infradead.org
Cc: mingo@redhat.com, x86@kernel.org, bp@alien8.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        dave.hansen@linux.intel.com, tglx@linutronix.de, jon@nutanix.com,
        shaju.abraham@nutanix.com, Khushit Shah <khushit.shah@nutanix.com>
Subject: [PATCH v5 0/3] KVM: x86: Add userspace control for Suppress EOI Broadcast
Date: Mon, 29 Dec 2025 11:17:05 +0000
Message-ID: <20251229111708.59402-1-khushit.shah@nutanix.com>
X-Mailer: git-send-email 2.43.7
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH5P220CA0011.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:34a::11) To PH0PR02MB7557.namprd02.prod.outlook.com
 (2603:10b6:510:54::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR02MB7557:EE_|PH7PR02MB9965:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d884399-d6e6-4002-41d0-08de46cbe04b
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1OQH1wdr341HKv+pCLGma5a3b9H8i/b3/T0aPQhYKQh+/oCYtx9lDfX0W9Ea?=
 =?us-ascii?Q?xkq8ii4q9xAYid5XCO4wCLLtqQFmQQ89ZQWM/Eg7SlxmEtKNerud1e+Pvzwg?=
 =?us-ascii?Q?CePR3qQkAyEPDMcK+Z7HUjwnwtoUCpPAAefRDCc5EipcolnKb352FUQl1hjX?=
 =?us-ascii?Q?AgQ2xm4c1zv/ON+CwWor/DU32LZLdcdkzpNE/fCFKD6H2hQjfkwouhEIpSIK?=
 =?us-ascii?Q?J+QASmOl3xyevaze5pNfR32pyuiMAZ9D0oOeiqJBFAdoc54zr4v70s27vllQ?=
 =?us-ascii?Q?KmaISpDBlngiQaggm54mxrXL3Rv86eAQyjFFp+NIVuG0FpqW5/znWFOftQnt?=
 =?us-ascii?Q?xjjT3lwt/39GHI1gK0UktvYTHhzZQbhkZzDM5tgPS+DarHUFfbyTBxHHPGWU?=
 =?us-ascii?Q?nSnSI47ECDyRJvZ3+OsTTstI2pRYEbzzWkHPR48BlmCufm7EZntfID0ydDWL?=
 =?us-ascii?Q?h78uZ5GouzznUKMnd6fBorGIm2psX37vVk5FTRdjXQMFkpcvQkjiFmUpBscy?=
 =?us-ascii?Q?QrLZpCQhvnGB0asZdN+ZzFb0DFaSlKyDg+2rcQIk/PPjwRhVzVl0nDquKezy?=
 =?us-ascii?Q?98rtNr1RgnJ30/qXjPgw2kwy2lgijC2tmgvGESDBfW+95xV8QUppqLCbgCIr?=
 =?us-ascii?Q?EIICTqtgEQRKrS82uq9J6+I1dZtwaFmWUfaYM3rIowgcC32sgOhNJvH56O71?=
 =?us-ascii?Q?ksyPy10VIaZa6FohLGkNq68GCtZfpsNyX3+Q8HTvYACk2gjO4htlQbrNg1Xi?=
 =?us-ascii?Q?D7WttbatbxoT0noiJqGZ01pmWFo/KsS4eDxmmKTbFDit1Jh/1WfqiT0lPYRO?=
 =?us-ascii?Q?8niNEWkipX8ZghpR0evsIMCf8LW4gyqqQ3TePtoe5ucZ1aVCzTOfwtN7n7rM?=
 =?us-ascii?Q?JdWL2N51YkQapiAIRUPaaBl6HxNmjvHoKK+Ftan+GHzZ0K3/iZMKTtVwdISM?=
 =?us-ascii?Q?PGU6tHjx4Gvpv1Y7n+uCfPvoui9RRaEW80Z3RmRQtCzOMS3b7dvAagf2p82k?=
 =?us-ascii?Q?+X126XeZ0CrUzeB73Kf4rHaqUF4kqWJQCdVUhWZuCIuO39cDnqXCninDMr+v?=
 =?us-ascii?Q?o1qzZKJ0Adaf4ZuBe3RJMNkg+qSO1ADkrNIRz5ejCvgdmi1lWN92Rn3bswjY?=
 =?us-ascii?Q?BiGt0leDVYQ5lrGuTfpfNrchQ4oQchu1ZyeVUuPZsa1F6eIrYXOZHJrcnvOW?=
 =?us-ascii?Q?YzXLDuE/m6nOGsTIMPC5KZET5duzwjEJF6TSmXmwNbwSNyS7QFkd3/5Di51B?=
 =?us-ascii?Q?EKRTOZimFwsVqLawvHV93lhG1Iq4r5KTGk/wMLfkurQ7maDBO0fdecFdpsFO?=
 =?us-ascii?Q?gJIFvzOWQFFU4rOpSD4CuN25jyX1A81Ht3Ob2d3nP83KkN1cPo4fMPVtYj3g?=
 =?us-ascii?Q?V0X7/aNOb55bCoA5g7tDkK6C59lf+d36UDinxypJrAxX/ZHl989kWe1JuD35?=
 =?us-ascii?Q?/bgEls8voEsjQxgxKxgYXEviHtV8Ot/l?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR02MB7557.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7wdZUOV9Qgw0EvoWeTnwD9JOU5kSE8n/xZOIbXi3JhAFRlU+1ny2v8C0IAen?=
 =?us-ascii?Q?EfHwsj7/d3KAaq46+688I1F6eX+RiAs6pSR9pW6Wy1MvqsmCuCPeCra7bwXP?=
 =?us-ascii?Q?TPB+CNHp8mFxfKu11+B/eIUNy4eT4ul2SmlwPWA1s5Xpu1N4pSQOJ9P2/2Vm?=
 =?us-ascii?Q?bn3nsHTJlkItaO9J5JBm+Rt4BZg8qa/UTazybgSnaCS+RReQZK9ZE0UVrlM4?=
 =?us-ascii?Q?rrYeiqksgnbEc4tqqkCLGJcrBzFDNSCE5abbLiiPtcY3yRmu/3qmU0LGEtw8?=
 =?us-ascii?Q?dWr8Dz/7oOKCckHfBzP2GNhNHVu4N1BWOadtM5OC1K5YbOMLy1muz2D3iDTd?=
 =?us-ascii?Q?OREJeuSyjcY/z1Eua4CJT9w4wIuSk+QxAQY5sKwdp+rlWmkcAzShI9uUAH7R?=
 =?us-ascii?Q?BPkhuBv+yhKDT9iBI3ZMgxMnFj20w9muGulRUYlnPuI8xCPvOvlv59UInQt5?=
 =?us-ascii?Q?ya/74v91swaUUPbZiOn/HAXn4K9+2vSwqOoCruc85Sd7RJApj5gGjwMYphgR?=
 =?us-ascii?Q?fWEIbzPF03JNH+2cnR0wOBagGCdP4wHbW8t/bAJFEv/XSGATBIBh7pzFvEQo?=
 =?us-ascii?Q?jgVBj5NpafxKB5JWGPLYv9aDbY48jU6JsziTl/nLbplDJZMZU/f4BJ52AR6O?=
 =?us-ascii?Q?/kRFP+5jcHscUb51Rc/hHh/BJheDdf6ngH558LEcclA7XEyeWWQpFkFSdqng?=
 =?us-ascii?Q?HxlvtFv8oaJFvLU8KF70dIJLLJ/343N786PCW9AbjmM2Tyq+bYDUkqUkn2E7?=
 =?us-ascii?Q?VpyQxz+72tiW3CROxzfNUvgVnLSjEOQAcDTlui816CLP6y7yiXwsoIZ30x2u?=
 =?us-ascii?Q?gYuzOmxVF3TDr1q288Z6dFkkIn226RrLKRSprUtubxgoz+dpu5kO88sLCcU7?=
 =?us-ascii?Q?UNdQjOqxTcoyRkRB70arp8bhyS+lqEysW4Gc2oDGjQpAQNVblQmk+606jTBf?=
 =?us-ascii?Q?pwxnPRyWbIsVWxg65JL28SV1hqu6uGFW2OnG92jg4ZpRNMrnJ8Q/aXuIP+pB?=
 =?us-ascii?Q?kLiP17itoluytLiq4SJQ4TimZfcPLKng9/jnY2TTzG46n9FZwMi9iyEWs0lh?=
 =?us-ascii?Q?skJP8pnMAswwnWFeMYiLXOf4DsTFQlTzQM3tFyVhYERvpagSwjzP7BMs/OiM?=
 =?us-ascii?Q?oHPw9ZrMGryKzKLkWzKdPERm+Ri3tRyxKnllGwYSimW16V287qcdRQ4sr9qi?=
 =?us-ascii?Q?SDh+Yjvz8OlP10r0e7yFUk7FuFdeLc19vb5O7OzjJCoyZmO/YqwKuPSp6Njy?=
 =?us-ascii?Q?pcFZRH3sG84PNOMbBkA0hhUXPuOeah9wHt0Buj8RSH7AdutWZnxsUNsT+/H7?=
 =?us-ascii?Q?dTkibTF60UKo9v7jm+zPCeH6KiXe3mmwMGPBa85wbCa76PLHEpZrYzXooT+s?=
 =?us-ascii?Q?4D8WrL0cWrCsFKKN0ZPQkX0fb7VzbKpzR9/ND0nyMuU1fo1UVnscP4BjEDRn?=
 =?us-ascii?Q?/G0LflndvLCagKqdJc96k3/9ZzAxYg9iHHSuweeoaPDahXA7r21sCcgc0JjV?=
 =?us-ascii?Q?rFRSY3SrrCoL/31ovMLGGfKyOpO8qSWQwDI9qqmWQEdFi9f9AgEaGUlW6HPR?=
 =?us-ascii?Q?mo0na7MDxUmUxIXl87eSPXOqsRFSBjAMtQy2PZoXzM+MMq1HNkdsSLTcJwMI?=
 =?us-ascii?Q?6IzHHR/h+mtfhPm1UORYkLxIgQUGEZ+AmmGKjTjhzzSLeYrBFO0fiErFbLK4?=
 =?us-ascii?Q?nJKkDQky7LXssYsBQznuki7ueVtV61zimZgs5vs6S5UyAb/5udaIXbRPhRyK?=
 =?us-ascii?Q?0fjh/6QqmTCnEcsdb6FXlqvNvsxa+cQ=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d884399-d6e6-4002-41d0-08de46cbe04b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR02MB7557.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2025 11:17:39.1791
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nfoGzUKNGHdwdN4ZC2Nx0EKZiaRpmxX3gLeHvsGis0yf2pTbZbJcx94W0GXMh5xTg2zP8OV1hJI9WJ4Kwd0TwnyoYvoFmPYnHVsL74PntgE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR02MB9965
X-Proofpoint-ORIG-GUID: bMEP-5CdEG3FzF7v_N9y-jiz4We2s9V1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjI5MDEwNSBTYWx0ZWRfX00JUXeX9w7Y3
 vYuDq5b4YlOnEg2xyAwUW1thVMEBXX88clN7VK2boUZNG2PCXo9M8Th8gwsBAB17DQx1R/Qq7YH
 UEC8lDsKqIcgt89GEoWNMfT+yc9bhoBSr4A8Ndx11UJhfNx5QS5th1UOQW2WRzjLDZ3H7Iya7Kj
 SNg/0hxILbrn/2yjkkdtSJIvYkawhNvMBF6SjerQwLUHIngHTaPw0MHHjIfHbGHFYeckGshOiw5
 HmM9CPfUwgREHrUlReStaN89kT/k2WfL6Su8DgxMkaciDcx+ZD2yDLXQXfvp0EzH7TwhmpPCf6u
 HTih0pqAFs9AaKDPjnU1H4nRFTBgQMYpUtnZLzmrkDnoFLYXH6+4TiidIXTMWsfYZG48sLLmMnL
 2rrOB9A6MVGJzLyOlS2+DF34Bj1YwLRcQBY5ohitjp0HuPnQQzCiBe4+Dugd0xx9eAthz4BN3h5
 F1upUiPTxLa68hDBZEQ==
X-Proofpoint-GUID: bMEP-5CdEG3FzF7v_N9y-jiz4We2s9V1
X-Authority-Analysis: v=2.4 cv=BuWQAIX5 c=1 sm=1 tr=0 ts=69526356 cx=c_pps
 a=GZ5nxs7iJwyXCG4rR3qJ+A==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=wP3pNCr1ah4A:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=WfwK6sBijsG41Jo_XmkA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-29_03,2025-12-29_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Suppress EOI Broadcast (SEOIB) is an x2APIC feature that stops the local
APIC from broadcasting EOIs to I/O APICs.  When enabled, guests must
directly write to specific I/O APIC's EOI Register (available in I/O APIC
version 0x20+) to EOI the interrupt.

KVM has historically mishandled SEOIB support.  When x2APIC was introduced,
KVM advertised the feature without implementing the I/O APIC side (directed
EOI).  This flaw carried over to split IRQCHIP mode, where KVM always
advertised support but didn't actually honor the guest's decision to
suppress EOI broadcast, and kept broadcasting EOIs to userspace.

The broken behavior can cause interrupt storms on guests that perform I/O
APIC EOI well after LAPIC EOI (e.g. Windows with Credential Guard enabled).

KVM "fixed" in-kernel IRQCHIP by not advertising SEOIB support, but
split IRQCHIP was never fixed.  Rather than silently changing guest-visible
behavior, this series adds userspace control via KVM_CAP_X2APIC_API flags,
allowing VMMs to explicitly enable or disable SEOIB support.  When enabled
with in-kernel IRQCHIP, KVM uses I/O APIC version 0x20 which provides the
EOI Register for directed EOI.

The series maintains backward compatibility: if neither flag is set,
legacy behavior is preserved.  Modern VMMs should explicitly set either
KVM_X2APIC_ENABLE_SUPPRESS_EOI_BROADCAST or
KVM_X2APIC_DISABLE_SUPPRESS_EOI_BROADCAST.

Tested:
- No flags set: legacy quirky behavior preserved.
- ENABLE flag set: SEOIB advertised, in-kernel IRQCHIP uses I/O APIC
  version 0x20.
- DISABLE flag set: SEOIB not advertised.

Changes in v5:
- Split into 3-patch series (refactor, I/O APIC 0x20 support, userspace
  control)
- Extended to support in-kernel IRQCHIP mode.
- I/O APIC version 0x20 is used when enabling with in-kernel IRQCHIP

David Woodhouse (1):
  KVM: x86/ioapic: Implement support for I/O APIC version 0x20 with EOIR

Khushit Shah (2):
  KVM: x86: Refactor suppress EOI broadcast logic
  KVM: x86: Add x2APIC "features" to control EOI broadcast suppression

 Documentation/virt/kvm/api.rst  | 28 +++++++++++-
 arch/x86/include/asm/kvm_host.h |  7 +++
 arch/x86/include/uapi/asm/kvm.h |  6 ++-
 arch/x86/kvm/ioapic.c           | 43 ++++++++++++++++---
 arch/x86/kvm/ioapic.h           | 19 +++++----
 arch/x86/kvm/lapic.c            | 75 +++++++++++++++++++++++++++++----
 arch/x86/kvm/lapic.h            |  3 ++
 arch/x86/kvm/trace.h            | 17 ++++++++
 arch/x86/kvm/x86.c              | 15 ++++++-
 9 files changed, 186 insertions(+), 27 deletions(-)

-- 
2.39.3


