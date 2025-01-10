Return-Path: <kvm+bounces-35117-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5159BA09CDF
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 22:15:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 04A36188E6F5
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 21:15:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8043D2185BB;
	Fri, 10 Jan 2025 21:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DLNzLvCl";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="eSaqzkEx"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2FEC208990
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 21:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736543683; cv=fail; b=XLMP5qZkP1+C8yLTgdCl8wsACFaFMj8KNWP6gIRHl+M4iUKrLtpmN8FK9gFtb9XVMT5scG6QwVgG/x696Atn5lG8NqWVxjwkV+Y7YPIMMNBk4O1R2i72XL0NK2ScKKvXK3KkUS252AfXBj62bVOt4TqvAki9W6tOFKjfS7FTOjk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736543683; c=relaxed/simple;
	bh=VQ2nI51plL9bCnbLB4QS1HYpwR5jkIkwK3CVIJ+3xZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IAVoDWYM25dSgYgmsCUIfZldOyB5f+bYm5c56l4WfwobKPl+4bnygPsvfJESDiSybBEVM59b6CIaU22vMtHLl8zTxCIzTA0UT9wap0VZyy0hd0xqnuyVF9vcqdhRWHCTukh2m3gSW5xEEy5oDKp9Bs/JKG2QF1/E83qGA3bF434=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=DLNzLvCl; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=eSaqzkEx; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50ALBuSq015618;
	Fri, 10 Jan 2025 21:14:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=BOnwreaAj9gKd1f6GfwhXUfn7Kbp1OoUJpyYl1Om26o=; b=
	DLNzLvClJozT3mxhso6/Jg7CA9sjVqA3Xr39HkiPypgiJybI4UMNS26Y5JAvgDkQ
	5FnVuZPozr9V95y2vDfPgbZ3Inbf4t8XXvBQij77KDY18Tg8TQXZBe7qaJR2smYZ
	vIlt0S21V1Y3FjcdPtBsDfdRPFTCXGZqbFncEf3hu+cOdQNA+Jea9mDHR+bRuue8
	vJ8NDWu8oX4h1UD7A5yz/WVvzJhg9OLm0XzP5zCLotO/0EtxBQpac1GP9G+oJxdO
	DxP5M0oDeF5SbmNWT3i43b1gLLVEj/Xor1BTSuVSjCz2OAUkoexA4q+zJzvZOqd9
	fLnziy4HeUZtRK0gsdHKmA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 442my625wd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 21:14:21 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50AKIpL6004868;
	Fri, 10 Jan 2025 21:14:21 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2046.outbound.protection.outlook.com [104.47.70.46])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43xuecwpwk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 21:14:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cuWyyUv0D4aC4OABwcIahAgH9z13jXvpgIeRsExb0UsM8CJ/k9qxKhyjcku7/5f7Pgka1gag8aCoVdhkS4VUL+26u0rlK35FUHq+T/rsOlvBhe5rX+BRyCyPpgGPHvOIbQZ8VosLT/MAUk4LjUc14yFaU6kAYEomO/3GGcUM5/muII+moC7HRO3Qlenc9yUBU2JIQ76PUd7bahmisskXAGA/bnLF2SJgXQH10jvBPlAIIKULYUKyIglY4JSYvSuryLtTmeMXc6ebkgUI8HEuGRfL5johcnwAcpOMyhJeFotwdYEsoxKX21HxcGK1XM2o3PMwA7Gv/d8al5PifewPlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BOnwreaAj9gKd1f6GfwhXUfn7Kbp1OoUJpyYl1Om26o=;
 b=fxl79noNGJ18VH+NTyiHNMjFy/0H2QA4r594dDlnbp8HaixI5AqZGgUVw176fdq/6PvLBhdgzvnptals9lLYsI7WmmR1sIT7Enk6bEIBxSIg6rFy0VBxo0fnCG5WWjdxXIkI+0/P29Cn0jRo9/Bxd7EHUwk2QJ1QI5EJBqKrozFKo7GtJRKH8nBWQJ2cPS6K2eqlIi2RVmaX+e1Gvt+AxKbi5ZrZYj/BGY94h1U3XKwnGtSTM464xchsLDg4dTJXXJJaxgCQegYvMXJJgChlKv7M+PT9NyKjt72AoAGqJp27awfydhdPzHfy9DM/gnUBdHBhH7sC3CGhnlw3lQJJog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BOnwreaAj9gKd1f6GfwhXUfn7Kbp1OoUJpyYl1Om26o=;
 b=eSaqzkExWuRqaY7OBRBu00kcudi68k3A4B3YPGrwZzGfmSOXtqb7S80fAk2ZaMx1vBXKQxkFzzfZnfCcAGDN8d80iXYgiX4BPXU5SJ+16f4ramOZcFXBere/8MgLUZqX+jFzh4aKlYKClgwA2DE9zeJG5o63en0C0tXLtqTa+PI=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by BL3PR10MB6113.namprd10.prod.outlook.com (2603:10b6:208:3b8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.10; Fri, 10 Jan
 2025 21:14:18 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.8335.011; Fri, 10 Jan 2025
 21:14:17 +0000
From: =?UTF-8?q?=E2=80=9CWilliam=20Roche?= <william.roche@oracle.com>
To: david@redhat.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        qemu-arm@nongnu.org
Cc: william.roche@oracle.com, peterx@redhat.com, pbonzini@redhat.com,
        richard.henderson@linaro.org, philmd@linaro.org,
        peter.maydell@linaro.org, mtosatti@redhat.com, imammedo@redhat.com,
        eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
Subject: [PATCH v5 0/6] Poisoned memory recovery on reboot
Date: Fri, 10 Jan 2025 21:13:59 +0000
Message-ID: <20250110211405.2284121-1-william.roche@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cf587c8b-3894-4589-bfea-be5db70e81f3@redhat.com>
References: <cf587c8b-3894-4589-bfea-be5db70e81f3@redhat.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR05CA0048.namprd05.prod.outlook.com
 (2603:10b6:208:335::29) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|BL3PR10MB6113:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a2cb389-ecaf-4f0e-b7b9-08dd31bbbe2a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0ob/B/57fxADe14wFbjL5W9tCge/YJs7F6giLG8Nz5WYaqlBxyUn7PD6eWLG?=
 =?us-ascii?Q?JRgfoUBp2MgyVRyWnd0Hoze7CnvRBgOT7Sn2vX+kL10g3n4/WRwZrEbbEuUC?=
 =?us-ascii?Q?u+ha6uJSmzVv2ZgHeIS2PR4+ajSBgQVC6x3etn6Rp318XNtaCDBaTzvhYDif?=
 =?us-ascii?Q?+OewiJYMs98ZrAa+Ds0zRCx4idT5W98Rx6O8+gu6RKIBU5/3CEn5PZC49q3u?=
 =?us-ascii?Q?iBBrv9yC8Xbvjbnyat6EwNMb6OAQGbD1nDnRecMC0WDHUAoEaYDtyDlOsHM9?=
 =?us-ascii?Q?YmEuMqen/kBFU6vH5dEqCrDua6223m+hr9aJt7KNk5CyuzInKTo0Eb9nxfI8?=
 =?us-ascii?Q?zzgmRYZn+K/fzqtCWDOBqHRAizd8wPT7mGmLSm5OUuES1VMUJSut7MC5VcT2?=
 =?us-ascii?Q?KCYZj6OZBVj4c9/3l/bfygsCeMPzPQXSb6Kw4vqwG8USVCq2pOMYvv9yAqt2?=
 =?us-ascii?Q?1OrkUNVbBCwAJecj+DV6vHg1/CkeSANThgfeeO+Z5zI2UMpgNbNwm2g6HDuu?=
 =?us-ascii?Q?iuZKDpPK2EIN5io6mniYpVhXhVu4VE8nqEi3kDANBnExPaA7mrLU+1KQjdP2?=
 =?us-ascii?Q?yS62IIgTdwyiJa0Ex/gQWWaP9tMxkEpjmgzW8w/9RZvt/JuTjBA7MrPB/FxS?=
 =?us-ascii?Q?JmOpD3TfuxSBiMftqHxsgmUxo9wXOHZqM31gb8F1bu2FuKxyHiwZF8BWxnY3?=
 =?us-ascii?Q?fOdohRKK2ECLcHNkYdtYDK+BMyiJFk4+5+e7oiaIjt7ZQuZ2PTmewDvjH8rJ?=
 =?us-ascii?Q?a7pIXMttm5FGEKgL2LqIeIe+YREl5zgUmQ/JRhqk/x5aprOFPzRcFzpfHydN?=
 =?us-ascii?Q?Kfdr5IkYxl1Juv3bXkrbsGJaVNvyJtGNmIqsHmWSvs0b+ki+JjGWjyaxm4mn?=
 =?us-ascii?Q?2vo9PTLy5GcT/e5IEQYug+U7V5JRD4VSvfp/8XJXoP3aTS+d2b+W97uI5M7L?=
 =?us-ascii?Q?MYmCsmGUYdStDqhdghQDKveMonjlc/zXpExVQUIQjUCJdQcF+dIgdsQuQhoZ?=
 =?us-ascii?Q?r4D5AguS5wlrvkqDw7LzYarnEhERBNjhNM0Bsah41a1/QIZlJBcm5OEHKoTM?=
 =?us-ascii?Q?qA74w9lq4YlE/i36kJwQMrdTro6f1fRAjCLDdRLWVmk0o+uOT+Fq29pQ8zN+?=
 =?us-ascii?Q?Q/6vcxGz7PbUzLuGEuhLp/B2Zqwzb8Clwth79TkEKV6Oa1v9TmpJlx0O+2Ri?=
 =?us-ascii?Q?Za/VYO+6Guz6o3zlDQCYY1MJX78jST5zyUEoZ424ucHVC2o/XW5Wf56paD9Q?=
 =?us-ascii?Q?T6mp4oL7g8Q61uoX0U5TeG2e60rskLvFUQ2smQcwd/knYgjOGlZ49p9Ovy4m?=
 =?us-ascii?Q?2m18ztU0EK3+vIANrqUhKQBJx9XLIvqtij6Vi1NhOFCTQIudF+ml6c/I5ugE?=
 =?us-ascii?Q?RjkD3r542FCb+dPjbr2qGRmTbKTX?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?d6IRkr3fu3j42f8vafENFlTvcuk9sXWPmRNVPLoFcDG6wiuw122f/vUKP7AR?=
 =?us-ascii?Q?i32e6VsB611oF7/sTDtLip3nIdHJmutVs8+n0HC1jyVp1sBcWSuZGoO8y2vW?=
 =?us-ascii?Q?DWRNdK360qdTmO0qzQm0HTD6TxLLIpl4FKRPaaZOb4bQ8v0bMZ7RURJTj3++?=
 =?us-ascii?Q?FCa+PgnNMruD5iq6edLMoj3h9ZbEEfdUtpNkKuoOtxOENUVgQ4dZYVTf2BRE?=
 =?us-ascii?Q?cBCycBRC0ghHHT/N8TIvCa0iyl1E3Sok6etU7UTN0q57iWg3GMXs/fz54Uuq?=
 =?us-ascii?Q?mS8fxfGEiaVkeRpDIOr5OzXzRyEBbLn4t9hhK/QbDfVmCu7Lz3pQ+VdjUhii?=
 =?us-ascii?Q?u1iF4lE2Xuv/smdHsUR/kjHBdy4QsEvmOhEJjtjAesrecCdMf5qJ8z6xWqtP?=
 =?us-ascii?Q?q+diL6N+5TcwRuqmmQ8115Bhznx9hy8qxz9BfyqC3wbM4dEsj3ad7dxkIDjD?=
 =?us-ascii?Q?O1BYnAuURoTyvXnTW+fX8b/XAqnQX2MyiV7f2oxxL2WcX4OGJZVMhFqwkG1T?=
 =?us-ascii?Q?4vXPCV8ek4iIvvgV42F5KkovJIpuYTbJkuwt5u7PjBBsrYNAYedzssuzdwrD?=
 =?us-ascii?Q?Z/+h1vxGWgAYJMs8lOGqJMYShBld/AviDRoA8QtK9z+N9onfrwSV6knYrUv8?=
 =?us-ascii?Q?vonrkouSCJc3nnf7VghFeWASg3KIUwLbGLr7RdH6qQuLI8X/D8fuyYldpQT/?=
 =?us-ascii?Q?Q+dkbKGfGd3hqQhFZaRoVpgtkogHkw4QjmvYrU7pJj26003PSu40kgMNFbst?=
 =?us-ascii?Q?nIAu/8nYH9zZ7PoGcVKiDr3fH+YENxhV5q8KWpER+DsFk2H4uagzYnMlQNA4?=
 =?us-ascii?Q?QYgu0FCKYgTzrXrp6yzLTPzinqQLEzGOVUalzgZdJtpbUqJhzQfcEB1Q9GwF?=
 =?us-ascii?Q?t5RaExbEGdG9KX/j5m5SgPFUjEhGDYo+ibIB7c0qskcRkloo0O1wFIx/Bkk3?=
 =?us-ascii?Q?QmS+jNbyAoHl8Pz9Db8JcZ0nVGTXpLigykMOaIHcidj0oWDf0IOC3npmQ586?=
 =?us-ascii?Q?WYoVY+1mF4H6EbDHH6UJ5K38oQmu4snYG3Vxpv0cAS28uOYM/D8RvOOEU4rg?=
 =?us-ascii?Q?aiiaQPty3/qkl/vneWW9owl2IZx3IP6mjJ9AMaXOUrFiUC3AZq+LxBf4xHlE?=
 =?us-ascii?Q?54NBjl3tCim1dZwzWw2YAj3LeFJwuenA+3xB4ESf13yfs2iEcmJVuyQKDGwS?=
 =?us-ascii?Q?7xDMG66c0tPCc8DNPy/mC91B5d4TVj2hNAcjby/s+tSh7bKiGoc21n2FjvjR?=
 =?us-ascii?Q?5QSwq6+W/ZYN6JrCnRkH33AcIurAWg2o1lDxfojdraQNHvIfRnRG/AdVEhOn?=
 =?us-ascii?Q?m8/aI33CQLeYCqpU3uvmLncPgw35q6DVvxHNibn3TymmOOL149jN7hfPnW98?=
 =?us-ascii?Q?soosrWZ9myII/MoTRi3QdK1usAFXCQ/H9Aog1Qa0gH+8pvdkWRKv0J+GM6Fp?=
 =?us-ascii?Q?T6SDSiIjXr5z/vogrPrP3fftUWxMbMCBSapc1sxVkkfd4O6EAVCp2cGabnS6?=
 =?us-ascii?Q?m6eGBLB/hfPbYMYS7VnfCiE9xUv63StOkQsWH5jpcZGmunAgwiL+DldTOMq7?=
 =?us-ascii?Q?ozCFD8vFNlGtVUxqWElAtqgsLijO8oObt+8v4nDfAVF/byfJn+b3BbO9ke9f?=
 =?us-ascii?Q?lw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	T+whQpv8KtgV9n7aHRaGB2BDjhDqVmkih0QScwIrNKMsw27dH3LmLeZ++Thm/MYVgN0pxZ+hNODNxkRu97QJRHWrEStmleHCyiPIksZqS5cdWXuMmPAUacmxy2O70QV6L9u5JIxm6tPasb4gXVb9opV27fw0IxDgNyZMbpYQlvMQ7SEmRaAhfB3fFZeU2DFE/K+arTNQqQDgTOogQp5CBVvzPqQi1eBqu2AVfkIHrrmiWYKbROSHZcWJELp8VWbfN7wN52l5th0bo149QDZ9SJwUDwyNFfZr8ZzGqo/DV8iQisxV7BZWVbrBpRpMk+VUHIMzmDKs8EaTWvR317uDLQjRkYo3nc0dZGm8sUIZh+orZ787i1URS1uV1cUN9PvB/5ZikkCqiKifGNaeoiWQapgQPVrV/MfCirN65YsYVlAmuaIMiOijgQj40ItlfwUnl+F4H6tl/sX0AcfC5CZSEjRXqx+QqM5fTQde9HE7bv35JZUG65UpSu7PygpEbr2ZYK5DJWVTjFceix7WMiLLSZpk8tZBYvqrysB9a4fKmKTQcqdzmPsvUw/Q0RxovnQIl2S7ozo061TAv7Vc2v4/nhh/FBX2n2KcCCLw8Y14Thg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a2cb389-ecaf-4f0e-b7b9-08dd31bbbe2a
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2025 21:14:17.7346
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nILwCvLtLnPVuovdPCkZ1fYIFLYUPKZHGq8os+SD0+Z5WNjK4cfGDHJmbIZ3BguKxazInI3+AY9dIxa462tNwtSA1RN+tQiAbZWHJyBAO70=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6113
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-10_09,2025-01-10_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 suspectscore=0
 adultscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501100163
X-Proofpoint-GUID: 48ZB1rgxg3-4XBoKzsupdzNUTPRhjaTV
X-Proofpoint-ORIG-GUID: 48ZB1rgxg3-4XBoKzsupdzNUTPRhjaTV

From: William Roche <william.roche@oracle.com>

Hello David,

I'm keeping the description of the patch set you already reviewed:
 ---
This set of patches fixes several problems with hardware memory errors
impacting hugetlbfs memory backed VMs and the generic memory recovery
on VM reset.
When using hugetlbfs large pages, any large page location being impacted
by an HW memory error results in poisoning the entire page, suddenly
making a large chunk of the VM memory unusable.

The main problem that currently exists in Qemu is the lack of backend
file repair before resetting the VM memory, resulting in the impacted
memory to be silently unusable even after a VM reboot.

In order to fix this issue, we take into account the page size of the
impacted memory block when dealing with the associated poisoned page
location.

Using the page size information we also try to regenerate the memory
calling ram_block_discard_range() on VM reset when running
qemu_ram_remap(). So that a poisoned memory backed by a hugetlbfs
file is regenerated with a hole punched in this file. A new page is
loaded when the location is first touched.

In case of a discard failure we fall back to remapping the memory
location. We also have to reset the memory settings and honor the
'prealloc' attribute.

This memory setting is performed by a new remap notification mechanism
calling host_memory_backend_ram_remapped() function when a region of
a memory block is remapped.

We also enrich the messages used to report a memory error relayed to
the VM, providing an identification of memory page and its size in
case of a large page impacted.
 ----

v4->v5
. Updated commit messages (for patches 1, 5 and 6)
. Fixed comment typo of patch 2
. Changed the fall back function parameters to match the
  ram_block_discard_range() function.
. Removed the unused case of remapping a file in this function
. add the assert(block->fd < 0) in this function too
. I merged my patch 7 with you patch 6 (we only have 6 patches now)

This code is scripts/checkpatch.pl clean
'make check' runs clean on both x86 and ARM.


David Hildenbrand (3):
  numa: Introduce and use ram_block_notify_remap()
  hostmem: Factor out applying settings
  hostmem: Handle remapping of RAM

William Roche (3):
  system/physmem: handle hugetlb correctly in qemu_ram_remap()
  system/physmem: poisoned memory discard on reboot
  accel/kvm: Report the loss of a large memory page

 accel/kvm/kvm-all.c       |   2 +-
 backends/hostmem.c        | 189 +++++++++++++++++++++++---------------
 hw/core/numa.c            |  11 +++
 include/exec/cpu-common.h |   3 +-
 include/exec/ramlist.h    |   3 +
 include/system/hostmem.h  |   1 +
 system/physmem.c          |  82 ++++++++++++-----
 target/arm/kvm.c          |  13 +++
 target/i386/kvm/kvm.c     |  18 +++-
 9 files changed, 218 insertions(+), 104 deletions(-)

-- 
2.43.5


