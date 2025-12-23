Return-Path: <kvm+bounces-66596-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 94698CD81A5
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 06:09:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0353D303CF40
	for <lists+kvm@lfdr.de>; Tue, 23 Dec 2025 05:05:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 691443054EC;
	Tue, 23 Dec 2025 05:05:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="mGUV2XVN";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="SaKk5Wy1"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBBF02ED84A
	for <kvm@vger.kernel.org>; Tue, 23 Dec 2025 05:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766466309; cv=fail; b=e3JDTd9lCgWapGrr/uMix2kfw0PPmzA6dyZ6MtbRX85h0WXFD7qmBzOnH8A+rB0WDZhou7L/34afukInFaJ0CKMzA55jgrGh832kYGxGZln0mc1gQ3KwhDT3QsphiJbH3//HYi9bm5fTgFB/MdPNSs6LFqV7dX4RrO+KTQBpGvo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766466309; c=relaxed/simple;
	bh=aeZRe8T4OyukbCKpwPSd6XxORZFSC3lTC43CWewWVXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=s7P9k1Am4P7hnutv4acaRGN4mGDVvISSdXR3+zEzQxYFD+dDd5WcDWJAwLCO74JeceIyQo/J0lPlEtOL/PE2J4ETb0M+KNpy2lXSl3WCAIr2KP171daUzUFt2OftXOpxZNztWt0RkZSZNtW7I/sX6qrJ10IncHwFfPvCv1j890w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=mGUV2XVN; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=SaKk5Wy1; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BN1Loaa733160;
	Mon, 22 Dec 2025 21:05:03 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=xUUu7Cnt0YERaKvDInhEo/wCYNkYQYS6rP/7/LLZt
	kk=; b=mGUV2XVN8UUOGlttG/ze96eoKC1uY5MBxiOFJeZG9rtjMQzHyL00aJXlN
	NiqohLesX4wUGa6X8dUQr+5BxFbHBu/emGb33Xq4foKu4tmgBC0I6m9PdSGMtzPG
	Sbkg47MxcHibSGIyKvHNnl5R/3MBkzZtDB26nhLP+OyRKU3sZ98aLiQTh618Ue7v
	YtB3VEUURzd9rbLAqg7Rl11hpQj1nTCcbFJPr4H897PnUXUrDjYd9Z9a+UPWFpUf
	Iu3vXCEwfTGzK8K0x83SDQhrSyV39ks/AGME5yRkPyZV9fIeb9YLq5KSUkihpxWP
	0kIEN7ptab+dTGpwSZYgJxHYo7gFg==
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11020112.outbound.protection.outlook.com [52.101.201.112])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4b5t77cxqc-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 21:05:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=G17t7ZZMopgjqQTme0t4BbLYqR1QUyHwEFVZPHHBS07rBivIeTsgDx3pQedb0UtaDum9GZjRuzqUGcvMWrEphpcMBPy7bypUnrqk+PWFeuCMj5GxYM4Us05Jwa/DBK2Mc3XjuAh5+k9Y6zunM7MxTekZIVI7aBxbBXnrfojkfF+hVRdKRLrfHxBsLpgBllaYy6oxLJVdPIWRuM3bzqiwnLXHO2Pk7ZnCV0fxatgjPVZr5Db6Y3/r0YOkh/ywjDPoMEJ7kbsQL2gOuo7ibr9/aQaHvnzCA3iTSJyuZc76EEaNGIj79aSTGIQBGTPjG7cOVg5LoyBclTct+KvZi/AwWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xUUu7Cnt0YERaKvDInhEo/wCYNkYQYS6rP/7/LLZtkk=;
 b=gsYYWtcY08c1P8fFGaW4x3yV1owCm9sV6EIH8WAi6ABx0QRtIOUpZS8tf5BUh2e72Jtf5nKLd8lOh2e9pEYuDcgAT7NYh0Mkl4k1G03Tfxq281+6soxwsXYukSruWQpsBHn6v+PwFCf3TJ47j6/R7bSdjJ3vzFQ982fGJ9OMkKYRWPqGcOru6RH+Mt9v4qhwR1j15mmY5ucZO9oJmuu+Ex7jLyDtbCH+KknweTXqP2Ss8Ydw4hWDR/ahOWDhCQKoU2uNkWtIQKrpwrznWGBGqyCLcFqFRroekfg43F1beENPuC8+W8l40XijzszQDdng+Om884OXDYhpQ4EcwbRoMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xUUu7Cnt0YERaKvDInhEo/wCYNkYQYS6rP/7/LLZtkk=;
 b=SaKk5Wy1iVwTicNiooTUmOQxaH2SqkjhcKHDiW8RURyRyKCVAasX7WGjaU4nWpW3qKiSnlB2z7TFgDE9q/KaE8jWPAqZoMWcLw6TGA0uHeBU4IOpCAmsHrp2cVc/iDr40tCBa5XqbWGzTJh188gDZng9uL8lWw+YDx5C5atl0iTm2L7Ua+DZ4GYMk/AMEutFAXn4tkVWBoCCDgCPoy6nibj3A4KOixRdb7fLmeTImKNOF0Aoi9+fGj2X1V17qroaNfMV5EY1Gtk+izpWIQyXbydDb5LfWLzeFVnAxB0CNgNDLT0qventjPaD/STETEexaGrdawMpchp3uiYMyyFopA==
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 (2603:10b6:408:333::18) by PH0PR02MB8488.namprd02.prod.outlook.com
 (2603:10b6:510:105::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9456.11; Tue, 23 Dec
 2025 05:05:00 +0000
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc]) by LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc%4]) with mapi id 15.20.9434.009; Tue, 23 Dec 2025
 05:05:00 +0000
From: Jon Kohler <jon@nutanix.com>
To: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
Cc: Jon Kohler <jon@nutanix.com>
Subject: [kvm-unit-tests PATCH 05/10] x86/vmx: update EPT read write execute test for MBEC support
Date: Mon, 22 Dec 2025 22:48:45 -0700
Message-ID: <20251223054850.1611618-6-jon@nutanix.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251223054850.1611618-1-jon@nutanix.com>
References: <20251223054850.1611618-1-jon@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH8PR07CA0018.namprd07.prod.outlook.com
 (2603:10b6:510:2cd::15) To LV0PR02MB11133.namprd02.prod.outlook.com
 (2603:10b6:408:333::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV0PR02MB11133:EE_|PH0PR02MB8488:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e95cb6c-b1cb-4007-f76b-08de41e0d2ec
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|52116014|366016|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZSodSGsVD6Yw9Al98JSZnllKv9wU0Nos9xqE12KOF+q7g2MfGmc84FbQB8Qq?=
 =?us-ascii?Q?VzF5E7f8pSN0DGiBRQ+T0Q4VoV/BRJc2a8/bodJKKuvgcH8MqjzKmVnF6GK1?=
 =?us-ascii?Q?ijZO4jB0My+PblrLImCruQX4CaY0iZYkCuCc2SQe+bHAGsm+7coWnwTg8u6J?=
 =?us-ascii?Q?5Yt3EsDQEVMuO++W20ssEfxjxxtGxnr6/85j6F5iTIcD8++7Opo89ErgWU7M?=
 =?us-ascii?Q?9jH8xym7Dq2Sj9+gwaTR/X56IOzTJ77AWebvfiikwhVsgbnzNTNewTy6lBfN?=
 =?us-ascii?Q?DcuuGXJ5ZnzzGcgjck019D4VTi3tH6oJ0yrG1GwyGJ4uvIQkYbSIAAPpWSAM?=
 =?us-ascii?Q?iZ+bbmQonuabacpE9i5/FCBGIZDteiSxPdhXaXUhtRkKCeDuwbXbcUNL+gtG?=
 =?us-ascii?Q?ZueanO/sLIOeOKovCUUNOMDV8/hJWfROgHRzacC/ny/6tkR8eR9EuOm7yjr9?=
 =?us-ascii?Q?t6gj3Ki2CW6a8kCDWNssbhYi/ZaIOUOVBtnC7r7qZjug87pkOXVekwgp1bxw?=
 =?us-ascii?Q?mm6Xz5zu6MoDK1OdT2cMcIGs/TXUToB56z8STmEe40q1CnzlWp0bEFK+4THv?=
 =?us-ascii?Q?wYGZYVKPlLo8LtkZ/munXsp5J7wnqjHqqZoVR/wOZbdMjyw/7UKkE+xM9gsW?=
 =?us-ascii?Q?sTPSFoGHJ4UBYyP8bq+IIXmOZPMNW6uGzNe6JmKvv8S/Of7qAWzIekHjeh1Y?=
 =?us-ascii?Q?m649IzwZU7bEgCVZfOm3Vi0IOe+jWLZ9HfmXF9F19nfAoKvtNXzEl5h9FJL9?=
 =?us-ascii?Q?7q+/0YgicPnTCHp74Qgdg/QXPZnUXEBD7SHRj4EeWNiiN6xXo7ugfx4lo5EC?=
 =?us-ascii?Q?9O8H5TrfiObYjwKrf1620hd2yzyJexxEBMaJYVu8vAIDCJp4H/diN/tlgjze?=
 =?us-ascii?Q?o+RsPg0qlQfUW1syXjPmIOh6t5hLwM5A5yHkTy9XiIUk5qOfaNUrCDu/cCCm?=
 =?us-ascii?Q?31+C13VklftLBtSuy6WxDgbPu5RtApgFiNqItMTDU9iphRwvh37Kfqrc90ie?=
 =?us-ascii?Q?czLRZ2n99T4iY/Ve2/cPj1+w3KGL6HU7XtB+sJnMj6lY80Tyd8keUAEXBhob?=
 =?us-ascii?Q?7Js4eRzre85lBSJwq+ITPq65B39nC54NbgiZ/WadSRr6SSKX1S0az+eBQ4qQ?=
 =?us-ascii?Q?SIuPKDDOe3IHJ5DeWIXdxq8aQ9k1uW7/xivYvE5eBrunaSh06+XxYWvX95xb?=
 =?us-ascii?Q?Uo+lUh4EEI29jUzhfvBapnC6ttVF7ZCwB7gJz11bIQ3KsSK7MzpjBNfi023G?=
 =?us-ascii?Q?sr1u4GsBTuwiUpc1D9wod7OLRgu9eTUKHKQ4O6ctSlhV6EhRdYsk2ZboElJ+?=
 =?us-ascii?Q?X75+RPaXOWgB+ZqKflsfQ8SJkgbw+eKc0v6r8ebi4WXBvbbSA1mHxjwetea8?=
 =?us-ascii?Q?mvddboyrfI35+AO5A/keSX//hylEABJ3Keyc3JkR0F9SxpOAwyvcuXAE65i9?=
 =?us-ascii?Q?SKXjsGY5Uiv4MjCQJA3wiMuHphHmWqbdQCWw7d0WmPOI05cFCFAUo1KnZPel?=
 =?us-ascii?Q?3MkwnjEXlCngjHRnrq6Kss+pfnFUjrkyLEY4?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV0PR02MB11133.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(52116014)(366016)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?j6nrAvOl1/XIo4kYjKSDCq9tt4qM54I9MScSoWJvtwA4jvEsx7ws5mLQYZ5w?=
 =?us-ascii?Q?CaJAKDllh0KybNTLhT50/cq5QA9LkvhrO7y+9/UnPcy6vABdT4L9yIqBrImb?=
 =?us-ascii?Q?+QImZz1EqxFBdZFJId2CDcBJNGcQWtd7h/+11MnMnmpSryMfaYIlno5h/J47?=
 =?us-ascii?Q?AVvFFfR8sgCWpWPSk5JQITbfndPXit9PADtvyZTnnjvZoPxuvfgA6uU/5olK?=
 =?us-ascii?Q?DmwfTUuN/NoMuprCDyFleetngHcCR7w1RVPf3xdL6HHSg4s4ucRis25nbfHx?=
 =?us-ascii?Q?JdufNXC4amzbVOzs/1TtWSS17KypqzDEcPTYNKS/CKEYtFb+8szxdmwvYhtP?=
 =?us-ascii?Q?SUMADtHEjS+84xWpsxRe3w7xJ8sdEXaG5PtRKF87360+ACQ3kxoVnX12sSPJ?=
 =?us-ascii?Q?9DhD5AHWrtOz1v4Gz2eokM9oVHOOE0yiSHy4cfCtxUefkHiu1aR5eTqSH/zg?=
 =?us-ascii?Q?PeRuJhsy0QSrQ9e7ystoTsiNNQV1QdtilzHRitrruBXoY0Xtq5OrlSb2ZdXu?=
 =?us-ascii?Q?DqTBdTHxx0HA9R0l/K/RXM6sE23AFKNzQj5DRtR2OWjfgxpFBpRr23EKZ9Sg?=
 =?us-ascii?Q?xlUG9EtTKG2XkpM58qp95KoJZVPd1xebcmHe4veq2INHa0ZRODSVOpXNC4o7?=
 =?us-ascii?Q?Ugw69r4AaipufNuDXrOshamXY8AaIsjaFZKIfyLFj3zMa76nKIMSvDIb7fWz?=
 =?us-ascii?Q?j3X5AbBqky43ZlCXUhCUuey0wTdoJJUS8YoHPc9AIE4FCObUGpJ34jVthirV?=
 =?us-ascii?Q?+V0OK8dA0GkrWrYtS2zQBJRmLu0YqCk6df3Cc4fnVFDC7toNWcxaDiAdxv3Z?=
 =?us-ascii?Q?AvDjq3zT1dBrgLMF6AerW+PJrgS7BMBoGI9wafzaapMq1MpCLFru0HGAsEtd?=
 =?us-ascii?Q?57cdziobygcUsDvgnJYpq7uWLppRY+Jllf8rBA1adPzj1Sar9bSML0Uy3KTy?=
 =?us-ascii?Q?U178LDwPDzJ9zJHfqeDqZsDd3xaBiPPwrZ/+ZbccM8Qp4YrjSjVvvp9OJ4sc?=
 =?us-ascii?Q?JVcSeL7qgOVvHuPYOJqsFcSRlkVbiLNARAZmEx19asCM19SqKIkeQqYOWE0C?=
 =?us-ascii?Q?INhfkX8tzMxMEM4RVMGJnhai0KRaTMt7mZIE9AYj+TBl39+8yo35o7tG4lWl?=
 =?us-ascii?Q?087AG9BaQS+cFb3aQi+UXgOrnJPs39ByBdlISbwoKgX1ZN/SPsb4olCHfbAK?=
 =?us-ascii?Q?IxXherXr607dQK11B7fTw6QUI//CuVTFoXgDchwqYmAu55XiTXCmAM/QvEET?=
 =?us-ascii?Q?VBK627brG22VcLETPQlgqXWHgbMWL5M4oIdnStadFum5U9Z1swwTw0s9m7CX?=
 =?us-ascii?Q?kiL9hrCwD68PrIhuH0fooyveQTzdiWEUSuf/DSb8MO/lvGbHvAwo7mulBQLm?=
 =?us-ascii?Q?Z1jmJJ9N3oJRGOB1LAZk5vd/m+Mp2HqNEB90X/3vv6sD5KtVDeDk8/+bPLF+?=
 =?us-ascii?Q?b6NpO2dgcr6XtjLqX4Kf8cLxiC9KhNa2NsH2bc750aJTF0aqmyP+8KrYE4nj?=
 =?us-ascii?Q?9pJ48qhSXEIcxnAo7vQk/Rf2ToVIFLTrDAgYqtbqrUm3VoFP+1ZBHlwcWp5B?=
 =?us-ascii?Q?RhyKTr2od71jSuuSDh/dEQKCl03f25LMN1qdfa0xAt7Nr+TkN5LiaChfzJ9R?=
 =?us-ascii?Q?XbbXwNjDMG4qxrDL0PBIs7RdkRLidW+bJ15ydGaxhOKL3lneXT6XDW8LBTWL?=
 =?us-ascii?Q?4KxEeR+yZO43AqM8gXdSqPfqmBHTeB7T0M2FBRZBvsqJ+VVuBk3sIjJ7dQ9l?=
 =?us-ascii?Q?8zMMvaMvIWfo36R2bFuBy9bGCosSRXQ=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e95cb6c-b1cb-4007-f76b-08de41e0d2ec
X-MS-Exchange-CrossTenant-AuthSource: LV0PR02MB11133.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2025 05:05:00.2039
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TQF5VO0CLdB5oSey675f13+jNNJrgh6//F/EvTqXKCLmwmZv4wuBjbnJ/5dP5/uoLO09rufCjFDAi7rbPmM9OYjRVGhA120RtBrKCnWZCbA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR02MB8488
X-Proofpoint-ORIG-GUID: SD_IyDji65dx5tImVM5usRZfmKn7VnoJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIzMDA0MCBTYWx0ZWRfXzOdl47oohLxI
 cIxR+dSHali0pWoY4Tb+PQKZ0zTlIIDocnRrbxCBU/wZPmkjSclSGtiTLh4MM8lDI3wd7gw8E63
 NBB7zyelrzciDoUHABuwy7eIG2DjraSk7PS/VZgoMu1isas8feMpzY+HXMOHNbcu+iUNn6V1AmH
 OHtA0ae7VpNWcZj5sZGc8CVFV6qaLW25AAXpSLIGqQrjWOsMu7fDDCzu3Wp2Rl2RdDTz0TCFi+w
 eKOxIz/SBH3QJxJ82td+lmoZagLODvXZyDJMMD+qVgpFV2przMO8Z6vad8Z0PtukVSF3dcu4VCT
 dyC0E3nRrUlAWPOYOVAX+ab1J2hFfbofT/tk1nSOMVXQ1WCp1K9vfsbq2/qnlcfAHrqbwtvwQpZ
 Qm54pQdsCSLTmLzEho5D57+8DU2BhjzKz8M5Hn1N+J7LtyrbRavMnxzz0+CukJtj7mh/IPR9AzH
 mwpp6plFGWalYOiqKFw==
X-Proofpoint-GUID: SD_IyDji65dx5tImVM5usRZfmKn7VnoJ
X-Authority-Analysis: v=2.4 cv=MrxfKmae c=1 sm=1 tr=0 ts=694a22ff cx=c_pps
 a=cE3fiHRxMl4nLvvI2vbFbA==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=wP3pNCr1ah4A:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=64Cc0HZtAAAA:8 a=pDvDTJNMLZo9QSsiC0QA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-23_01,2025-12-22_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Extend ept_access_test_read_write_execute to cover MBEC EPT rwx case,
which uses OP_EXEC_USER to execute user mode code when MBEC is enabled.

Tests pass with both -vmx-mbec and +vmx-mbec.

Signed-off-by: Jon Kohler <jon@nutanix.com>
---
 x86/vmx_tests.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 9a636eef..ce871141 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -2885,6 +2885,9 @@ static void ept_access_test_read_write_execute(void)
 	ept_access_allowed(EPT_RA | EPT_WA | EPT_EA, OP_READ);
 	ept_access_allowed(EPT_RA | EPT_WA | EPT_EA, OP_WRITE);
 	ept_access_allowed(EPT_RA | EPT_WA | EPT_EA, OP_EXEC);
+
+	if (is_mbec_supported())
+		ept_access_allowed(EPT_PRESENT, OP_EXEC_USER);
 }
 
 static void ept_access_test_reserved_bits(void)
-- 
2.43.0


