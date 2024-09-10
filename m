Return-Path: <kvm+bounces-26215-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2173D9730C9
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 12:04:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CFCB32882E0
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 10:04:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D1FB190047;
	Tue, 10 Sep 2024 10:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HBvYrk95";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="PRdRWNga"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C856718C025
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 10:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962554; cv=fail; b=tjJ3pvU1q7AiwlY9N67vJDu5HIO7lwiwHQmN3pe4mVkG2h1mUtNX2v85BDlfQOY+xT2FCYQuKQyq9ZjLPyplcc2X9hcd3JOvkWWpMVechvd7emnYzKAoMmV6M6O+zLdmN4ymvA5/Yrrk2hT7KqXdDPiJSXCPSOxUeuWt8mkPhiw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962554; c=relaxed/simple;
	bh=9u7rMKVGObTv6Fhcv0QKxRjyUxyFdmKKhPI3DDzS1X0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jIRd9ZreUbruqYcD6P2/eIkrM485ga8VkTgu8mFPVla8vD7NZYJ3gNiblACTU/X6rAy8FDEm91IRKc0UpHkBvwL0ArdhDYU5pB+/z+XeYbl3Us+o85qLGorRXt3WfW/xSh50AEJqQ7z2zbcncE1xNJi8b/7FqaQPbC2S0rkwRwo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HBvYrk95; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=PRdRWNga; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48A9QcbN027686;
	Tue, 10 Sep 2024 10:02:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:content-transfer-encoding:content-type:mime-version; s=
	corp-2023-11-20; bh=nvKn/wDBAxD1e10wUSGS3PLbmwSD8bBz13dZQCFyI20=; b=
	HBvYrk95oApy1gmE8K8yh27gqz2yp1Gc+UiRIhs802MbSCoeGZ2a6xyM5BKxSzfM
	gG3Nm0BFEdbakSSHEEBb3P+4gl7jMy2ODD9Ggvx+2DM9cW9KYgFvnMdrnAGTrGCv
	4QxKDeRJhyNnqyzDDMuZVNUhqd2/c09CM2WBOqDQl4OiGJmdyMpTzFBWLuXaurLO
	J9AoGfeA7evW9KWPABQd9F5snGhnwpfDyBZ+ncpI3FvLLZcH6jKrB/F7YTMmsEff
	YQaaBQFGGc1zN3rMzYJlAvc+yLjt4PkW/Bh0RfHS7W1a7zwupIm45Sm8iEFSBMLM
	JR67LvWMMwqOsWkFxH2kgg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41gjbumwjv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Sep 2024 10:02:24 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48A8eqsK019973;
	Tue, 10 Sep 2024 10:02:23 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 41gd9eug8w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Sep 2024 10:02:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XKJyUkTemIwwKG+naajRSpf93StjK9dfZZh7fa+qJqurU2dTLX8zPtgwVcfz9NEVejSISYB3TZ1QQyVslwmT5b4/pVeqGEqgTg+EkSSOEBtUjOQ9zuYDAP7A2URi4xbJM9opN7G9RdpjZChqwA0p9+htqedXXMCnzaFp60IgVUttPuDVDxYVVoGpugG738raeEkN04pv6S6tYLJj4R85OxlhWS/cyAjpLutWFGJ7lZXg6UaUoNj4UfkZWa+V6NOwcJDGV9FrsBBeoBgIHnPc2hlUSNxarB/ZiBRz+Is1SndjIBa+LuY9v32H6eHKF9tevaNZrfRo/LI5+aJC+ZZ51Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nvKn/wDBAxD1e10wUSGS3PLbmwSD8bBz13dZQCFyI20=;
 b=N603uvIplnBOeuKmkIYEaRgbQCfrp6Zp0w91T6+LvaVX2KydP3FbDSrHEfj7a3X6c4TErpzG48iMKs9SUwzs3/xhDHU6PtQYU1M5Nd5kEpoPStbaw1On5ux2GNdcl+7yXBiJ4s9yMv3oBf2bApzAWXGy6UxDWJAtq7s4s16zfjn97LdpukxnkBQ2n6ISh63ogC8BdX6VhCMoN70ju5E6H2Gzn3Jp8OcTVUqYdvheBflZwQvhYvUVyh4F66xuFRGZzbab3Vm94Ze/GWhpi06Js2QudrXyleyDGGdp+3gGaXh6IaGLjXo6FHzh7ajoiVsXAQThN2Pud+RMrLNBThAjWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nvKn/wDBAxD1e10wUSGS3PLbmwSD8bBz13dZQCFyI20=;
 b=PRdRWNga1VB+LSK8160G+FEXvPXmoXConbzxk3Scrr5ScJEL0x/NRCKARqNEAsszq9+MfOBJ9cRp4BWiKuH1kFSBxANMlgbI72XqrZfW+uO7IViorfR0Pl9WsTIQhW7QMfed1+HSNYEDCbNqSABKdtOYbh6Xe/XH7UmCsW2Qt2o=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by PH0PR10MB5894.namprd10.prod.outlook.com (2603:10b6:510:14b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.10; Tue, 10 Sep
 2024 10:02:21 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%5]) with mapi id 15.20.7939.010; Tue, 10 Sep 2024
 10:02:21 +0000
From: =?UTF-8?q?=E2=80=9CWilliam=20Roche?= <william.roche@oracle.com>
To: pbonzini@redhat.com, peterx@redhat.com, david@redhat.com,
        philmd@linaro.org, marcandre.lureau@redhat.com, berrange@redhat.com,
        thuth@redhat.com, richard.henderson@linaro.org,
        peter.maydell@linaro.org, mtosatti@redhat.com, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, qemu-arm@nongnu.org, william.roche@oracle.com,
        joao.m.martins@oracle.com
Subject: [RFC RESEND 1/6] accel/kvm: SIGBUS handler should also deal with si_addr_lsb
Date: Tue, 10 Sep 2024 10:02:11 +0000
Message-ID: <20240910100216.2744078-2-william.roche@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20240910100216.2744078-1-william.roche@oracle.com>
References: <20240910090747.2741475-1-william.roche@oracle.com>
 <20240910100216.2744078-1-william.roche@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0108.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::49) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|PH0PR10MB5894:EE_
X-MS-Office365-Filtering-Correlation-Id: 5609caa5-8222-409e-d851-08dcd17fa930
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/IBpHQ0pqJyvoeFp49lMc4uq03h33XpBC1rAad9wUwUbf/mKOPeEOOuSlwwC?=
 =?us-ascii?Q?vfBO1nVrc+tC9edJaotiv2j/We4BPDAqPMplkRgpxSqN6jDA6gfrKp5Okz6E?=
 =?us-ascii?Q?EoZhU7ItQEjJZC5f1D2vPZnGvPwiXr5ffg2m8zHMoETxFBU4wJ+mzpTWLf7o?=
 =?us-ascii?Q?NpGnimS993Dxh4fUhhUZs3otv9Mn+87gPucuLFrZ/ay5/spIKcPdlDCTkGON?=
 =?us-ascii?Q?hzXnt+UJE/61cRNWngr/AzpNzeLQvTmlKXkKdyKY5wl8PvXGC9fpFTxF51Ag?=
 =?us-ascii?Q?U02rxzVNOAB/hSxlXFJgzvA7QnrJt8p2EOUHZJ/QaKUqfvesaUp3+SeWDuDa?=
 =?us-ascii?Q?r+twEaB8RopAY7CNdantVrNcbxggEhWew1klf4gSPkmRL5vSL+Io3rq5RZLf?=
 =?us-ascii?Q?P2LBYUXiFrQkrXOHwSNzKYTDaZRvatbCnMltAu6a53b/ey6y/7OJujecH5hD?=
 =?us-ascii?Q?E09/XW+kIE4fKUVPN7wQ8Wy8wDP6U1wgOhAzckKZP4GqL9ff8RhwCTHCCJqt?=
 =?us-ascii?Q?rkN2sa1p/zkEZLtvoWv2hR+HHqtTgBcDn+ZwxbqLcVoRadorbVbPdBjk36oE?=
 =?us-ascii?Q?Fh5rhxvPRRZXrzfCVu0U5QMw1H4B2vjchrXbI/82XLrLa/nKfPxMtpiL30dz?=
 =?us-ascii?Q?D1n5uDqy/UAcYSh9eAcTD3S6hSrOlXqQIAooyixOkXbZREFFhlLJ2bBnTtKl?=
 =?us-ascii?Q?nb2kcuUVotBTXSgBIwCZfacBwi/yynOsBJ9iWQRuLrMR9tat5B3WvnZaJpHs?=
 =?us-ascii?Q?am0QU9n8rt2b5bl2vfPqcM8NhoLqow4tAY67/LS/YFY61a+Qkq4gC+BsgOB2?=
 =?us-ascii?Q?TepxRnieNK5Q5d2ZXPpDFn3N8APVMwH4LzEh4UMoYD4ZgfSMDqJK8U40NZbb?=
 =?us-ascii?Q?2AWgrPWO0WMntODI/I00UUpB1oMiDS0p5r39+B21JZHTV4FE4rEEThHT/iSB?=
 =?us-ascii?Q?1HdG3Ie3RTA/mc6m02JoawVTnPiw6WI6QoEajAuOBhxGcQrqfOygXSFDA6aX?=
 =?us-ascii?Q?+K+lpbWvpKFosXTkQF2B5ZBFEYUcixtM5iBAyk70kqsaSjX014XlzNQJUo59?=
 =?us-ascii?Q?S/8NNyQADaPVy5WMo2MT9dwk8sAnlHBjkBYWc34/eFFKj/oxHtSRxEf9IBp/?=
 =?us-ascii?Q?HYXA6Rw9pFmmAUeoWVIRdwKE+GCniH6f8NSlCz/h5IpPbxlTwuTZ8aSwPC8T?=
 =?us-ascii?Q?hxzWxw1k35DA9QMueZS8lejDg7KpwJqF5VZDGzDo/+qr/WYcvKjQr+sIR2BI?=
 =?us-ascii?Q?CbF3jIt8ukuOFapcxzJvwWgFLzbVrn31FNTz/3VTrBNS+xXMoQDH0TfJcAZf?=
 =?us-ascii?Q?0Srj1ynUsh3xLnioo16Ii37CUW/aQWMX/zd8SMv3d4fN05xTmrfDhAgpF6mD?=
 =?us-ascii?Q?dpfOiBngyjFt8cddSjoCZxKttBx+?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Tr16Z+TRXfXvEuWNnZWe5IHx0eSMwKuiZOks93V6usDJ0HpfiCDL9Lbsuwse?=
 =?us-ascii?Q?+fLnAqqLtu5cpvi76FPbytAABcdf5DrvTISKH5fj6aYmvQaStv68Ew4pK9wo?=
 =?us-ascii?Q?NjALQAWM8EqsnIyDCvGqfDgAsxCeJOMW//kW73F2Bv8a2e/T0XDU/C3Stsyu?=
 =?us-ascii?Q?6PnFedMsDxGloFvq4x1OmgABl6bknfXQDH/bUPhVpORjMqL8SZr5/5wRZDn9?=
 =?us-ascii?Q?x/bDLK+2ZmnMTEbOHZxpSNn38yLx0XqAZnBMhqcriVzjlGJqdaReiXnPobYo?=
 =?us-ascii?Q?d9xw9/pXoQDmzTrHxlqDdbreMO4RcNrdfbjVYn/Uo2WHi2Pw51Ms6fQafn7h?=
 =?us-ascii?Q?H1sc/U5io61B+3aSyFVU053E75NmYZDm4QT5bXl8cIjqUkGbe2St6gDBNxX+?=
 =?us-ascii?Q?uHnz9IdbAgC12nSY3uAxNzKOo3w3dQwDPRMgPsLjJx7wQREe1y2CHC/uakkL?=
 =?us-ascii?Q?PS2kRPHXLahKkj5f5Xf96++bda+Nh9dgtrAyXzDWgCI7THKf8b1Bewv1RuKh?=
 =?us-ascii?Q?yuA1y4YYd4R0+SGSN9zuAzNnCEuPx+9vMXuC/mXzPYAAXUBt5L3+AxDchOTX?=
 =?us-ascii?Q?d/GSoKXohlOE0Bh8rH4TcAtJQqui60tHrS7FmPFWHcd+C1n6r0oDI8i5oC5N?=
 =?us-ascii?Q?a4jtxw2UyPDQsMkIeaYIj9gblfF7GRIdwJu9EZjczcubYZhYBjVe+EEA/cCR?=
 =?us-ascii?Q?M64SB9Ysh+rzY5gMLeNEdrXO4KO6HDHAaTFndnJC1BDo4Fq4ptM9npUHfNAh?=
 =?us-ascii?Q?8gmijLTwhzI0dpLHGHW2hFBeeTWBqJ6Pz2bvaT2VuL6PJAxBLdloaLzfkqYl?=
 =?us-ascii?Q?mmPbE4fcF3Y5r+JZNu+9SSsiSIJY2H9eMdfH6Jijf5/ZCI6R0bv4cVjVgciY?=
 =?us-ascii?Q?flgjJGIX0z2imjUTqNzIf8D9oQy+EJizb36iweykCJb5AYSmV9he+5GZjMMy?=
 =?us-ascii?Q?lR/CLgutHzyslroKl6FwXb2WayVEGdAEszGr4yULYNZ8YJtIO5M5Pd0ZNuq7?=
 =?us-ascii?Q?Ap/idXO8GvGXTvoavbRnYEZIegYqvgsRcqgiUJLx6Wk6Pp52836f9hmoNERz?=
 =?us-ascii?Q?0cVSwChAowEkABBQnwRvDu+PnsaTrClRm2zSx9K5U/yHiSCkLoWYAAsPTbjJ?=
 =?us-ascii?Q?ljHNDapNEI9bFoKJ8FZeSTr1izH6oOUUghyMepJbmJwVIvmFlG85oe97myhH?=
 =?us-ascii?Q?UEsbUJrcyMVTwVMD8xB+IKLe/74W1NK1d6XipTPlEfcYWuUbZRN8KKYMN0Zy?=
 =?us-ascii?Q?90MFrmzDFIqeP2AyzjElnpJMU+n4qXjzy5KriSUcVtwT/jDnqgQVusTUsyZR?=
 =?us-ascii?Q?J/JPoRMP1pmzwsVnRL+KmQD5riciraVkFHZ8Zy75xBrYLfHoqjFpLIHzVouu?=
 =?us-ascii?Q?tu1QpcCyoRyqSOJrUHpuN9LM+tFWspWySSsMXNGR1lnRmgX5HinsB2lJi8xS?=
 =?us-ascii?Q?wFeXZdTVxmcgYiojQbvJJIsUs4ja1AEF6SaGhyg5gClQlORG8vdFbcc5zvqM?=
 =?us-ascii?Q?DY5+MZONH7j38173raE7HKtw3muNLOsJobjgxXZRuyd38yu9mMS9V0cpMIoD?=
 =?us-ascii?Q?GnOcuEstZfoMlo66wYpYdQwAiv+OfDFfjEi7UwQMwfgk1xpVvEKcfaTENo0S?=
 =?us-ascii?Q?DQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	gizr1rMm7dXlxdlxGoNTje/aK2uyt1spYMdbOBWb2UrGkSEFP04DVkw7f9xGd0VZBUKNSIDvUWPzj9Z2r8qsJOucUHXIjsfhPdNvcmgyn81ProxLSW7cj24CnOJvZ4mRXXjxHrTMlOoXWdS7N0lqUJkDfnLqSjj3ExxVY2RrL2QpQ9lQS1yAqEUU48ikUaQ9HOQu3p9cOuCtL0bE4zOoGUlSlr5oAgoRz+6LISBO65U8ELKqZ9ob/pmlW6wrW+TKfKVehSDyUxemEm3tAfvslBzbEAM9IlnMvdALZxG/7iqhsKsU6FHz8CiNmpqZMcu5x6kxUWjAf3doOxXV89uqNSGXbRVCI4933cB1DVCiWvxg7yjFZlGlChaDem82hkst3z4Sd2EapDZyCYcTnpKaeIVy+rAhFvEKoklfcpah/+kTkyA30I35nys9i0aizo3o7QaHIgy0uKJ7gOAT9RWAzwDxsXuGagKRMQ0eNokmcM01CDp07lSqbw8lxRFA3yeEQOGLqlLDFqwYsNeGOVKUXbYV/tVwJx0wOEjJN1hBi2fPQIVlUAf5ZDqXVM7EN7RAgpcvHR3RDShA++UT605ABhzoSJIwe4PZn5NBiY1wAPw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5609caa5-8222-409e-d851-08dcd17fa930
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2024 10:02:21.0960
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /ofartDzhNs47galelG/JsFonuGVl4NiVCxPhV/0nKD8j2mSKgJmKa4MY387mTe9petQqk4kGMMevc9WV+lFj4Y14d9n7IuDWmmsx/uLZ80=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5894
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-10_02,2024-09-09_02,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 bulkscore=0 mlxscore=0 phishscore=0 malwarescore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409100075
X-Proofpoint-GUID: yU4BdGaw02dXTyhXbxRwlRlIzvOXD40n
X-Proofpoint-ORIG-GUID: yU4BdGaw02dXTyhXbxRwlRlIzvOXD40n

From: William Roche <william.roche@oracle.com>

The SIGBUS signal siginfo reporting a HW memory error
provides a si_addr_lsb fields with an indication of the
impacted memory page size.
This information should be used to track the hwpoisoned
page sizes.

Signed-off-by: William Roche <william.roche@oracle.com>
---
 accel/kvm/kvm-all.c    | 6 ++++--
 accel/stubs/kvm-stub.c | 4 ++--
 include/qemu/osdep.h   | 5 +++--
 include/sysemu/kvm.h   | 4 ++--
 system/cpus.c          | 6 ++++--
 util/oslib-posix.c     | 3 +++
 6 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 75d11a07b2..409c5d3ce6 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2836,6 +2836,7 @@ void kvm_cpu_synchronize_pre_loadvm(CPUState *cpu)
 #ifdef KVM_HAVE_MCE_INJECTION
 static __thread void *pending_sigbus_addr;
 static __thread int pending_sigbus_code;
+static __thread short pending_sigbus_addr_lsb;
 static __thread bool have_sigbus_pending;
 #endif
 
@@ -3542,7 +3543,7 @@ void kvm_init_cpu_signals(CPUState *cpu)
 }
 
 /* Called asynchronously in VCPU thread.  */
-int kvm_on_sigbus_vcpu(CPUState *cpu, int code, void *addr)
+int kvm_on_sigbus_vcpu(CPUState *cpu, int code, void *addr, short addr_lsb)
 {
 #ifdef KVM_HAVE_MCE_INJECTION
     if (have_sigbus_pending) {
@@ -3551,6 +3552,7 @@ int kvm_on_sigbus_vcpu(CPUState *cpu, int code, void *addr)
     have_sigbus_pending = true;
     pending_sigbus_addr = addr;
     pending_sigbus_code = code;
+    pending_sigbus_addr_lsb = addr_lsb;
     qatomic_set(&cpu->exit_request, 1);
     return 0;
 #else
@@ -3559,7 +3561,7 @@ int kvm_on_sigbus_vcpu(CPUState *cpu, int code, void *addr)
 }
 
 /* Called synchronously (via signalfd) in main thread.  */
-int kvm_on_sigbus(int code, void *addr)
+int kvm_on_sigbus(int code, void *addr, short addr_lsb)
 {
 #ifdef KVM_HAVE_MCE_INJECTION
     /* Action required MCE kills the process if SIGBUS is blocked.  Because
diff --git a/accel/stubs/kvm-stub.c b/accel/stubs/kvm-stub.c
index 8e0eb22e61..80780433d8 100644
--- a/accel/stubs/kvm-stub.c
+++ b/accel/stubs/kvm-stub.c
@@ -38,12 +38,12 @@ bool kvm_has_sync_mmu(void)
     return false;
 }
 
-int kvm_on_sigbus_vcpu(CPUState *cpu, int code, void *addr)
+int kvm_on_sigbus_vcpu(CPUState *cpu, int code, void *addr, short addr_lsb)
 {
     return 1;
 }
 
-int kvm_on_sigbus(int code, void *addr)
+int kvm_on_sigbus(int code, void *addr, short addr_lsb)
 {
     return 1;
 }
diff --git a/include/qemu/osdep.h b/include/qemu/osdep.h
index fe7c3c5f67..838271c4b8 100644
--- a/include/qemu/osdep.h
+++ b/include/qemu/osdep.h
@@ -585,8 +585,9 @@ struct qemu_signalfd_siginfo {
     uint64_t ssi_stime;   /* System CPU time consumed (SIGCHLD) */
     uint64_t ssi_addr;    /* Address that generated signal
                              (for hardware-generated signals) */
-    uint8_t  pad[48];     /* Pad size to 128 bytes (allow for
-                             additional fields in the future) */
+    uint16_t ssi_addr_lsb;/* Least significant bit of address (SIGBUS) */
+    uint8_t  pad[46];     /* Pad size to 128 bytes (allow for */
+                          /* additional fields in the future) */
 };
 
 int qemu_signalfd(const sigset_t *mask);
diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index 9cf14ca3d5..21262eb970 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -207,8 +207,8 @@ int kvm_has_gsi_routing(void);
 bool kvm_arm_supports_user_irq(void);
 
 
-int kvm_on_sigbus_vcpu(CPUState *cpu, int code, void *addr);
-int kvm_on_sigbus(int code, void *addr);
+int kvm_on_sigbus_vcpu(CPUState *cpu, int code, void *addr, short addr_lsb);
+int kvm_on_sigbus(int code, void *addr, short addr_lsb);
 
 #ifdef COMPILING_PER_TARGET
 #include "cpu.h"
diff --git a/system/cpus.c b/system/cpus.c
index 1c818ff682..12e630f760 100644
--- a/system/cpus.c
+++ b/system/cpus.c
@@ -376,12 +376,14 @@ static void sigbus_handler(int n, siginfo_t *siginfo, void *ctx)
 
     if (current_cpu) {
         /* Called asynchronously in VCPU thread.  */
-        if (kvm_on_sigbus_vcpu(current_cpu, siginfo->si_code, siginfo->si_addr)) {
+        if (kvm_on_sigbus_vcpu(current_cpu, siginfo->si_code,
+                               siginfo->si_addr, siginfo->si_addr_lsb)) {
             sigbus_reraise();
         }
     } else {
         /* Called synchronously (via signalfd) in main thread.  */
-        if (kvm_on_sigbus(siginfo->si_code, siginfo->si_addr)) {
+        if (kvm_on_sigbus(siginfo->si_code,
+                          siginfo->si_addr, siginfo->si_addr_lsb)) {
             sigbus_reraise();
         }
     }
diff --git a/util/oslib-posix.c b/util/oslib-posix.c
index 11b35e48fb..64517d1e40 100644
--- a/util/oslib-posix.c
+++ b/util/oslib-posix.c
@@ -767,6 +767,9 @@ void sigaction_invoke(struct sigaction *action,
     } else if (info->ssi_signo == SIGILL || info->ssi_signo == SIGFPE ||
                info->ssi_signo == SIGSEGV || info->ssi_signo == SIGBUS) {
         si.si_addr = (void *)(uintptr_t)info->ssi_addr;
+        if (info->ssi_signo == SIGBUS) {
+            si.si_addr_lsb = (short int)info->ssi_addr_lsb;
+        }
     } else if (info->ssi_signo == SIGCHLD) {
         si.si_pid = info->ssi_pid;
         si.si_status = info->ssi_status;
-- 
2.43.5


