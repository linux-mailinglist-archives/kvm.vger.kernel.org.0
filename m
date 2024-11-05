Return-Path: <kvm+bounces-30787-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E01E29BD555
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 19:51:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0FF2B1C2278C
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 18:51:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02E8E1EABB9;
	Tue,  5 Nov 2024 18:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Wc0R0QYZ";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="AB9P2tuf"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 789351E7C16;
	Tue,  5 Nov 2024 18:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730832628; cv=fail; b=XEmvOWDSXL3vZzDImMk2BEVNBeMjJe8RONMO7HvRVyKIiooDzxyfHc3K7TUNBhwcvkWZ/ZHDNxHAROLosu9KwaZwC/VPvyM+SexoW0GqtYuSIKamNWwCBariNAm3YxPQ19Qg/vmeBIv0beyh4nLTcolN2xWqD6dK+b5dxxPOG1Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730832628; c=relaxed/simple;
	bh=nQ8nOb1mS2732E6voI0T6vPV/elJs6JzlICH/Zdofew=;
	h=References:From:To:Cc:Subject:In-reply-to:Date:Message-ID:
	 Content-Type:MIME-Version; b=ZBc4eqqLizpdHOWMruFQZvTdk/puFejjN6/mXuoCZIGF3eOe8Ai88NBXuGO8YmVcqFNTb89w5UKOae2qkdsytdJKqGCKEp80+0PX736BwTMgcNxbUCy45aoFvRYy2UTK6h7TikVCBoaPD/NduOMcDeEgJJnKcZqeSgaUpMjE7vQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Wc0R0QYZ; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=AB9P2tuf; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A5DiYkb026716;
	Tue, 5 Nov 2024 18:49:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=nQ8nOb1mS2732E6voI
	0T6vPV/elJs6JzlICH/Zdofew=; b=Wc0R0QYZrg/aci5WCHZ23x/xb5oiEMboF9
	ZtUq+camT6q363OWueuwU5tIj74pPPO4Se7UEkdmNQfDElkfyGobrNTO0zLrK7ys
	+s3GPW+KdsVTx6v7lUmOTpYTOYOeKZli9Pcj60kbb+Ef30O+YUt9ERCo4MWz0Ycv
	W5YZET6rt5/+CbzIt5x6FGzGbe0zE56JFYZnZkBA/9iSHRopYfRtElm3v8cuIDf+
	M7JrNFd2bAiK4d1ELTio1knJTG8GxvnC2obG6AssdIsf5GeHLYVKIFxZsMLM1PZY
	h7IPhculG31R+JuS7rQA8swY3R5l5Z4bYQIuuIexdO8RtyDkPxyg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42nagc65cj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 05 Nov 2024 18:49:11 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4A5IhtgJ031560;
	Tue, 5 Nov 2024 18:49:10 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42nah79721-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 05 Nov 2024 18:49:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fJb/WCTFsprxlvBMCZCu0FHnc4A10pO7fHXImhPGnPHx7DcrXPI02DfVbymz3abKOq+AGy++OcTi4sSLHkaz9ngA2GvrUFV0kcFBe4AS45fILTw9uwGlJ9wudYZlIucrP0yv7sGsk8QOJ6WGgjctRcgLs0tB3FXu9v4plQZ2ODj9xuDpS9dfp48qcts+8m7aX61bTNKx1snMJ2UISskYt4p+PkVdrRZuHOOV3vMv57xE08hRSKKsXyrLDJMgKeldI4J6RCL9FjVs3Ts/Y1tzFnPAFcOVvBeJIc48nBIhnfPgB9Lgl+WJG5mNcCcudbKbLDcY4FRksEWkNnzwLR4dHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nQ8nOb1mS2732E6voI0T6vPV/elJs6JzlICH/Zdofew=;
 b=iqWgQ3xAUNJ50FS6B16zJjg5H3gOHAcNsKS0VKpq2BtaHpH9+64AGn+NmALouIaqApbouBAEcj9UoF3XN1qi2rVeVI1AY/BbqhhtJbvy/SzEKmjx5z1dt4lGjl16m/64Z9/Dn8nZRGcDwPtAyHc5wwonn01S70PpHW9le4mYPNZ5Fb6bOhYqspRFcbcwLQ+FCtTwvazdupH/1Jjd3ecIk2TnjfwxW9XzrX/e60gLsRQLoAXphSV6tDe4gcBDGfX8NTrdwjH/14HiNJiYOsNaI5AhsY/p1Hog7+djsOs/I8X0VWkToojIcKrd1qO12y1XH2N+QDL0F/Z85OZGaADABA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nQ8nOb1mS2732E6voI0T6vPV/elJs6JzlICH/Zdofew=;
 b=AB9P2tufqcpTe2aWERzvcJjcYWXW7fDgzhfLfB2zKo6NpigbxD3KK1sHZjhj41+JW4kb5uVjHbo38aKUUUF4LrEMSw0US1gocGvSSA7s5FOdoc0JdGY7YmAED8b9phHCVgl3ytmZOLIVkT8gmpuBrlYEC1YUi35DU+7XQqlSUW0=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by MN0PR10MB5911.namprd10.prod.outlook.com (2603:10b6:208:3cd::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Tue, 5 Nov
 2024 18:49:06 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e%5]) with mapi id 15.20.8137.018; Tue, 5 Nov 2024
 18:49:05 +0000
References: <20240925232425.2763385-1-ankur.a.arora@oracle.com>
 <20241105183041.1531976-1-harisokn@amazon.com>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: Haris Okanovic <harisokn@amazon.com>
Cc: ankur.a.arora@oracle.com, catalin.marinas@arm.com,
        linux-pm@vger.kernel.org, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        will@kernel.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        pbonzini@redhat.com, wanpengli@tencent.com, vkuznets@redhat.com,
        rafael@kernel.org, daniel.lezcano@linaro.org, peterz@infradead.org,
        arnd@arndb.de, lenb@kernel.org, mark.rutland@arm.com,
        mtosatti@redhat.com, sudeep.holla@arm.com, cl@gentwo.org,
        misono.tomohiro@fujitsu.com, maobibo@loongson.cn,
        joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
        konrad.wilk@oracle.com
Subject: Re: [PATCH v8 00/11] Enable haltpoll on arm64
In-reply-to: <20241105183041.1531976-1-harisokn@amazon.com>
Date: Tue, 05 Nov 2024 10:49:03 -0800
Message-ID: <87y11x5xeo.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: MW4P222CA0022.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:303:114::27) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|MN0PR10MB5911:EE_
X-MS-Office365-Filtering-Correlation-Id: 321e05c3-8e93-446e-8c0e-08dcfdca85b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?T7w5Upse63tEf37BnaJuCoL2OR349y6noyasHZmlwVcrIN4aQVFPA4eqFjnd?=
 =?us-ascii?Q?LIUlAZJ4yJMZIYKEUS3Utcc0C4k69Vmm4cwhwp6oA6MbR2pS6emyZkN+U9zX?=
 =?us-ascii?Q?Xgq81anUAksyYevvvsG4Ht8VttysjFCcg9Adbv/MGU61rV6TGuvCYfFv6E02?=
 =?us-ascii?Q?tOJrchVBICjyZ+ZoDczBLIcp4nA+CgkV0v5JuCEH8KhCvJykxfu3af9SmE+l?=
 =?us-ascii?Q?fX3n9fDtE98s7P2zcipXY0zn+EJCIfoCo3tZRQzNcuAclIC6PDWrEMOHj0Ub?=
 =?us-ascii?Q?MSlSMRovwUCTywPWp57pNYHPaiugH1l4nVmND1Vhpvry18BsW3xcb2VQzfWp?=
 =?us-ascii?Q?YHuVlzsocyWJcOUYKf7HZd4O7QXnALI8tDJs4ohl7r5zLY2OBzfhtwZ+8GaT?=
 =?us-ascii?Q?T/H/mK5dYSQ7YEOrWQJpw7qzrKlYic2+KGtoyCxZwjrUaUBmiJ7OSNu+kBqQ?=
 =?us-ascii?Q?crTPhJWcs+SFDUwGzQYnLQcZVdaTp3Exous1iO06f62DY/wAKYWxiIPZNLyw?=
 =?us-ascii?Q?3KvtM+nXvJvA/4p9gHaY3vD2C7UPyWDlWrzlu9AHj7T3cCUpH7gk6OyjyO/7?=
 =?us-ascii?Q?gAwk0YGQHWfZZqbJeOtMK0wNk4mg7+eDVtrphjEaYDHSSJ9rGLhXsTSfc7v3?=
 =?us-ascii?Q?zJKcUet4F/X94P+8qTIyC40VOVKV99av5PpHLQopTZxE+4rVNNOUCyFpFkUf?=
 =?us-ascii?Q?Nyjn0Rr2VhU8D4t5QtSij0kQghOihcTZ0BtHxzGd6TpWBOFqjuSob8C/n13G?=
 =?us-ascii?Q?/7kmHTQ/UIfRkLk1dl95E2AdCEyF0KkWQH72E/j1odcMrJT8EU44bEpzEEQE?=
 =?us-ascii?Q?8uO7aCqMa0Ss/gZQBXNWm54/vmu1Dfe7YBTnwtkJZ2nnVigOwXSrtbP9Vltj?=
 =?us-ascii?Q?kTkZBEnyUUMizp9m+/93mG02Te0i04dVNby49GVvtHWEkF0KcQAsFfTnc+sr?=
 =?us-ascii?Q?8yluzuewVR/esvT5UhhnIxFDrOQW2y93VmS7RpjNd/b/EoC9AiAazJLuwVv4?=
 =?us-ascii?Q?HGSDKCoYjscB+ROhyTvz6fpL5cBelfP7rcPjEvYY710WjPqYaj8LisbkXVhG?=
 =?us-ascii?Q?CvRgPUN2F1lX7JcYa6d8wJPcQTolCUsYWaxms0c9oxn+0hrdWXJ/H4GrMISo?=
 =?us-ascii?Q?AhtBX5XyU0qdg4DrsCQhIIUHekSkKocibRkl5TF3XiBq6BL8pftqgRGFJGSn?=
 =?us-ascii?Q?lNgtkjRiEkrN+mZk6ZzYo2WARpiSXd/HEijMSeGKbpUhi7JyaAEGx02q3wUO?=
 =?us-ascii?Q?zuoWtcBGvZPW71ji7uu1HiKqG8yd7NwiJ5YpGugDtlrXkThs2m3ZvIPtX1i8?=
 =?us-ascii?Q?zPsFxAhBxbod9qwG5wKgbxh2?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KWBKjzQCIpx7GBbTU8BJXKSIMrOYDs0xXpDjIUpHNKsKRbhtieeJsxsuByZC?=
 =?us-ascii?Q?On4WUA8oYOZRyF3Hmhe6qCjrm33xTDgdOPOmC+2QDqj7reorykH7BYxhM4vA?=
 =?us-ascii?Q?RBh0E4Uh87KpgM/HGIJ3KE9i6zQ72SICGzsZgOxXtqsxrnfqTL+84aqNu3yh?=
 =?us-ascii?Q?RmlldoCU+y4NhK+Cv/VBhmwnuabyLpDN+Y99gmPcBd2OpEqoT/3fhHQskhws?=
 =?us-ascii?Q?YgxbQaTF4cZSmpxUVuTDDMXfYwH5nLmWUvwg/KXm9aRxah/AFHCCFfnDBnCz?=
 =?us-ascii?Q?2MYGT1pMTx0po8xTKv6YjxIWOkhI5bRKpCyTFPs377ixLLZwcSV5YG2JKR3X?=
 =?us-ascii?Q?c2fjzbosTS1TC75wmxepd/pvaabvu2gErTVtu/FiXmwx175utbdhCMpzyH6R?=
 =?us-ascii?Q?FdlDlyvGTQcwDYMp88blNjwdlKwiqsjoTOQHenaJ5vcZ0/4i4rcHw7/diaHl?=
 =?us-ascii?Q?N3ukQyzl7R78hN+al/TvbmGdVqHqPHIfEjKkpualuct+8x4CYVBkAsH5kATa?=
 =?us-ascii?Q?ONBodoSpYi9LXsA9c7OHwOsGdjxE0KxOM+Ynp66MQtbyAvAzef+ncHcWSEup?=
 =?us-ascii?Q?g35COekKrQG7N1eV2hKdJTjGT1BvRBQkBb9VZ6dnh9jYBh92wVX3JNODV4oP?=
 =?us-ascii?Q?ePJjxdR7VriEkOFsXfp7vZy6nfOAhLjQH2uzUc91Sp2PRKHGkIItFNz9zM0h?=
 =?us-ascii?Q?4CEDLrJca3p8XnkhybPECkQeIBsJ2bwKIxkZnpPboebaje3x+V+pdGjzl8L/?=
 =?us-ascii?Q?3cFbefQETpnL29KAJEJH4Ok6A7bUa+lZ5lD9TFqov/0HxjW1BYm2k4fDNS5L?=
 =?us-ascii?Q?uOopxEDZJ9D05N8nk1dFS/oHuT5R+oaDQpIuzbE20wx/8z/5MCXQDgSLFH4w?=
 =?us-ascii?Q?fLH0Cr8zUhQnvcB4Hqp5KL1imVFskOJucVOk50ojINKkY54YiOW/kJehwVxM?=
 =?us-ascii?Q?AXKr3E5DlDsRoaXS8DTIR1U9QdFyejNb2U740a5DyEOktnbkziNNGaGilqth?=
 =?us-ascii?Q?dN3rN7/VKceKIkl8sgMS8B5/1sjmu3FH5Lko2TYfA0PK+UvWiq1qC0VbATMA?=
 =?us-ascii?Q?QIszheKZoQas8bL8Ht3BJe7yKwMdh4al4YcB2+O25r20Vl3E70ZuQuZiLFjM?=
 =?us-ascii?Q?uMfUfPmyW/Zdb5hXIXQ2yWxldI1XcVNPUqGxKWHu/keQvj4QF8lKrctdKXAR?=
 =?us-ascii?Q?0fwhAVQX+LnEiF624Jxt+P/GGYPsv/L7YmJg6rS/2qEnU0yFUx/hBszrJxc+?=
 =?us-ascii?Q?qoH+joj4L9Q/x4G1NJL9v6PrhaqpDRiVwHRDXqjR3m8BVBaDJwXOktZ98Sz7?=
 =?us-ascii?Q?PpFe85772LaHZ1AOtMPtZ16gWwid/Kfjn40HON+KHzRbxY49MS3t6e0uuwa2?=
 =?us-ascii?Q?BlnWA56mhxIkDbWoAPuYNT5APs6UXFTrqVSK3CMsz4YquFLwvwCVdn7kKb3W?=
 =?us-ascii?Q?xlcnHwDPynQ8amRmcvo2NProyWq2a0nbm/FTihawYhGXuVN4aIDlM3gZcqc8?=
 =?us-ascii?Q?okP/38iu6mEs2aWLEj590eVHNcCx/HnSk7rbOYAQL3SHezs+KncyLLTyCxWy?=
 =?us-ascii?Q?fK9oyWKZ+ptc47dhWCfDWI21aVbgyCfEXqyFsWNiSc/1PWku9rD0heer4onZ?=
 =?us-ascii?Q?IQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0QofUanbL18dOw/a7r1tfOEGXYdegwv8Ovjg+qpuBNYLeLRYrRUYBOtTVmi1a2v4HrEed7ZkJdZ5pS1T3p2AI/64BjEGVDpGSYUXWfb+8pHDeFzUNi6pkxJGMWz34y2Y+a3pTcac+EHCa3O4P82RoWdyRslA5jOCx+l5h7pbPHCVXLC0qctbA6g6BvFssxKzBCjUf+yIpryLw2WIlisXAVdSPYS7tFB2WK+rEl+LBw05aeifkZyNCKRqIyH24pwsAbolsbQi5VeYBj2pHO1Dds6003a+jjHfSI7s+mPL56OWa2ZE8c3bg30OidfEJDQhmoPYFLr9o4xxh3AwE2iEaORHzCujBENHl5Vl2OssyQfIZhSNRgrRyuamf0JhPzD29l5byWiFj1/DymxKBUGxnG/5ITgapnMLMYGgx/1MjX+2TZGzwh6F2C9k4ktDk3CThJesYiJC0THfPW4kvnObZ4415VDaHUzr6B7CSn//1LxkhKLA3HoEyi6mZwQoX8X2URyuW1tJzniX6nHp+a8CG+lTYv+SmxURJhqYaxnVu+EgYp89UfR1phublIn+w42spNsblrxHqEJ3eWO80pDkQcExs9EmVLQJfFP9dXBnmlQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 321e05c3-8e93-446e-8c0e-08dcfdca85b7
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2024 18:49:04.9554
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wuZOLf42bQtm2kTdLJ2EwRCpk4n967IqljdDldErfW/IKB5BimOPgmKFnyCotAw2m9qc18aV6e+YOAMAl/WAH0kMUVoLl/zc8Is6x/rmLkw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR10MB5911
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-05_06,2024-11-05_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=866 spamscore=0
 phishscore=0 malwarescore=0 adultscore=0 suspectscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411050145
X-Proofpoint-ORIG-GUID: Qhu-tdLPM1U8yQhNYNXq74Qutw6-_0Fg
X-Proofpoint-GUID: Qhu-tdLPM1U8yQhNYNXq74Qutw6-_0Fg


Haris Okanovic <harisokn@amazon.com> writes:

> Hi Ankur, Catalin,
>
> How about the following series based on a refactor of arm64's delay()?
> Does it address your earlier concerns?
>
> delay() already implements wfet() and falls back to wfe() w/ evstream
> or a cpu_relax loop. I refactored it to poll an address, and wrapped in
> a new platform-agnostic smp_vcond_load_relaxed() macro. More details in
> the following commit log.

Haven't looked at your series too closely but it looks quite a bit
different from the version I was working on.

Let me send out my version as well in the next few days.

--
ankur

