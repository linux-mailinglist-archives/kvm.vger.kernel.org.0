Return-Path: <kvm+bounces-33821-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C21779F1F22
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2024 14:47:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 21C931674A4
	for <lists+kvm@lfdr.de>; Sat, 14 Dec 2024 13:47:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEC0219645D;
	Sat, 14 Dec 2024 13:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RpzvG6OO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="m0JwvIG+"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A4AE17E015
	for <kvm@vger.kernel.org>; Sat, 14 Dec 2024 13:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734183994; cv=fail; b=Y/6doOibQLRdlzIIRIfGv8NMVWoI8tSdD4z2JOrniQIJucaUDLVEsEFw43EpQMsLwuUI64cW2nif4oAfUtk1wnBDuUOeHFw2uPamimjf+g01haAIpoQ8v1Hngu+uIWyLR5GeQvqXyzrMyJzjrm83P5uHoPEgMDQ5KHlDAuj/PCk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734183994; c=relaxed/simple;
	bh=nTu6Ih4fddF4setJZi4u3grJt/KekHADjzYeyEi/iHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hIP7NhwGm79x6T3pw4UijQwUrCPJz9XQbSBGfS4Hf+fRtsUWOiEo+2awLj2NuAttZ/oBGk6Fviw96JY3FS+15lREU/OLv1CQ9elP0MPYaFiHwGzC2DbxuR+n4YEpDfV9iyQm/y1AVvzEOk3SpsowrxaKBE7TPQd53HERD53ZMW4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RpzvG6OO; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=m0JwvIG+; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BEBbI5p021285;
	Sat, 14 Dec 2024 13:46:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=RrWIw0kV19NHzktD7QkQk83ZP1g/4GS+t/YLHCNKnng=; b=
	RpzvG6OOURE/iqOdjiY7eRcOuTv2Nz01NVicytIzAbqu4kIfMKbJm1st8trfTS+W
	6C20zpkR747DitRD5Aqu0EWeKWHkL80hlN7/eYmhqqY0wRsqrgtSitZ+5XDfV5dj
	gRdgArAnC/EYmof05g6TQl4FUOY+VTcKsMDL44OZKdxzN5cmbuVjBVmDL6jKVsmT
	zbm+lXk4dv4ZKwFxYWea4Gs4WXYYE/Y1XZNIrwZwihqy4DAg2mNhLsQYn3jEBTVE
	B+BfYJgqPM7oVjw4CH2CTzZS4LkfmOILRy1aPyEJTPI+2f7luwbX5rJgq4DYFJL8
	u+c5cvf5EUpeMd2SicRe7Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43h0m00ghb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 14 Dec 2024 13:46:18 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BE8wA69035387;
	Sat, 14 Dec 2024 13:46:16 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43h0f5ka6x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 14 Dec 2024 13:46:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cVWw1B+oMwtylncA8MRVAYaeT60XY2vWuPYw1hCMVNIWj6a2oIWyrM8qSG/JlnXtfmQVUztkDwyQ3GUCRb7Pfxpd+85zbAuOxQzhqZQxoAlvrsgTMXL1e+kZXmewU8HZhFdAV8xtGTNBw2OhcyeM6wq5+dcEhWoEMkvn8DYQClCXzTUt3o/J3GjW3NByvrzNHOniINDi9sbd26cpCZnb6YmDI/htTgNHbAcosEmYASgrqtkTytQvhIStHkZNK118rlb1eAtHRqqBfK1HMo5AEgncK8EUWBJtC7LrYy/jAmkS+kgvlGgSAYRkM8Aw9VCrfUicSb2GkXCq7t1ftFEucw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RrWIw0kV19NHzktD7QkQk83ZP1g/4GS+t/YLHCNKnng=;
 b=U+Qxu2dcjl8RcBQE1RKV1ytW6uLbXeKVknztSIzdKJ16VAyPEdjAC/oeFr5g10bbLpmxxVCsmhgRY/6XHO9sKptoZzdtw0Lw0/In0X/BH8xWZlnr2kgv8Lmejtvz+eGwtr94KtYbEUzxRi78N8s77aITr4/qUB78P/OvB8YYhOmvCtrYcyXLlW5w09KxD4ggGaVrNIDY7m43pi4wYaAGssANlGZh8bzG1ufso4TIwKXhjzuunfcMzG6Q+yX3Hf2IrUD9nsrE52UdhwihOVExLJX1qvic2hv1h6wa8gO7NgMzIczbWNKlLWPh+uRnkrI/YBmtYGEQMzk8EXQBieZbXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RrWIw0kV19NHzktD7QkQk83ZP1g/4GS+t/YLHCNKnng=;
 b=m0JwvIG+wyRqRtxtdTSe1+Jvah5GQd0Q7tdy0MYw5HdQVJoz+tIAM+mniuRqG/GVKoMrt7cCCx3RfkUweHochJGHkznB9UQNtQGRnOJktr1UOSqP2trDXwY3YdiNZm7UJgmkqDtTynKVq0noOMgYhqsmjG/4YBZ4u/y2+OuK1ws=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by SN4PR10MB5624.namprd10.prod.outlook.com (2603:10b6:806:20b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.19; Sat, 14 Dec
 2024 13:46:14 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%4]) with mapi id 15.20.8251.015; Sat, 14 Dec 2024
 13:46:13 +0000
From: =?UTF-8?q?=E2=80=9CWilliam=20Roche?= <william.roche@oracle.com>
To: david@redhat.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        qemu-arm@nongnu.org
Cc: william.roche@oracle.com, peterx@redhat.com, pbonzini@redhat.com,
        richard.henderson@linaro.org, philmd@linaro.org,
        peter.maydell@linaro.org, mtosatti@redhat.com, imammedo@redhat.com,
        eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
Subject: [PATCH v4 7/7] system/physmem: Memory settings applied on remap notification
Date: Sat, 14 Dec 2024 13:45:55 +0000
Message-ID: <20241214134555.440097-8-william.roche@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241214134555.440097-1-william.roche@oracle.com>
References: <cf587c8b-3894-4589-bfea-be5db70e81f3@redhat.com>
 <20241214134555.440097-1-william.roche@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0341.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::16) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|SN4PR10MB5624:EE_
X-MS-Office365-Filtering-Correlation-Id: f28c5bfe-4ebd-4dfc-cfb1-08dd1c45ac9c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?nEp36dF8hGVn9aT+KFgPiqbMgVkQGY2oBToso/u5Ra8Y9L6MMhWdITZSdg+R?=
 =?us-ascii?Q?DXeWHEflq1CsUHwZRe5eb84t67/swfo1pstuZihH97Bl+otBAVmeiYCsP44Y?=
 =?us-ascii?Q?9T4rMIv0nGHSk7lhsHvrDT39PiPSXb9Pt9JiwSCFLB0wCJkKYWoqEIKUFQTY?=
 =?us-ascii?Q?ckyecoJCHXbfmKs4F/Q8+jzCUqRIEsw9ANcAUhiGrBkazxcVmUd5LtQA3Bx5?=
 =?us-ascii?Q?kcFSBp8KCDkeFeryIhLVg8WvzGB/KTixuXLQDlJViDF+Hc7GAsFERXyTLRj6?=
 =?us-ascii?Q?4e0HYXzpBQDXevw87LmDJxAf8zbr37rN3cJbnpYwItGMJhCDvEKJfmdd5JlD?=
 =?us-ascii?Q?S7Tm8e7OfdrXBSDjlaPSxvCdviY6vDusjOvyN/PhWbpL0l3MCx6I5Vj+iEhg?=
 =?us-ascii?Q?5/32zMVu/LN/CjHKvrok1p5z9aKwQQWfsKIZWFdzGx1GETDZiFK/7qDlSs72?=
 =?us-ascii?Q?2w+LOyD/GdNrCT9+BiX+GtJtznkeQK8PBpGbxCXOeCVboEw8kBLYVUrj3OFJ?=
 =?us-ascii?Q?ZFh17zCbvefwKUPCZB6fpmgj+R4/BIOtP8Pttp+Q5jSnQrGUcV5DrRUFeMCq?=
 =?us-ascii?Q?3N91GFHD2gqd2IZIK5r6WWn6m/0dwU6vBroFPsEg4JIDlQzcMFuC+s+KgLSQ?=
 =?us-ascii?Q?e3wT9yyaWk9BI481LC0WuASUoBFDVgk/jSIVisHVCsQHo4phT+qFOy7GHrrs?=
 =?us-ascii?Q?Gk5dlDuiYr5jR1yGRJB4UOTlv1j0Tj7yuIfStpVlsYT9ZXX3u4uBHkVFX7oy?=
 =?us-ascii?Q?Zg3ZgqZ+9LIfBoBh77OMK2hqNqJT/Z3m9zXQO8qws/69QErYLW30aBPLzjwt?=
 =?us-ascii?Q?er+AFW4AuVgDDH2Xwt+w6dVl8Ase9VQZ+vQ6AYeVoxzcl/fqVmqYGUhhe8rJ?=
 =?us-ascii?Q?jDdi8rvmtm/dhXoqeLkFQ+xjsvDbWk2/hrkj2R/YyqzHpHWZ0o5IQI/Ubni+?=
 =?us-ascii?Q?vi2ZgFQSdbCWZP0aRQm0mAtaObE2D+8gF2atbeJ4qrJ0Dl+Lf8efvcaknOtk?=
 =?us-ascii?Q?pSLEs5Y/6XOArbOom9QFHUIifgXQuD9XBwAxTuMIRaEQgxdWSGRNrnnB28cD?=
 =?us-ascii?Q?v0cTVs8dwgkFnNQDSMDFNrG+6u80leV6Hw0sj8j7pXRZC3WWJaO2FkjYU1jP?=
 =?us-ascii?Q?Es3bwYL82+GVQUU5LE7Szpoq1QwQczp4BmSi3KGiEUid+e/iTqm1c2aHl1IQ?=
 =?us-ascii?Q?Qnn5ug0NXWVbxCv91zjTRexH5CbsA9fFhGSTl4gcPhwlRKyqcWWawADCylfx?=
 =?us-ascii?Q?wmH3es3RcZDZLbYLY97bH4uAX9UPACwXAyh3YM9O8Y8FnORy+ucrMMQvP+av?=
 =?us-ascii?Q?2S4UpWDVd+h0bPh/8GRVSy4ntouw4+uW5JGY4pQogOfS2w=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZYTaSREjBt/2t+L4MmL6hxN7Q04p7gbznySnAgP+SfzYNK5QOkS85agbFN45?=
 =?us-ascii?Q?uJr9XbDqseOjm9WgVqHhtcgXlHkcjbYIGS/ycxGPbpSI7iIhvvi7VKLvMua5?=
 =?us-ascii?Q?doGL///SDfj1dpzqtELDilUHxHT1kCZM2l4oxxKK13eAVcbe4Je/iNbTdgb/?=
 =?us-ascii?Q?jvMIHLCKLxC9DDsNQ2wsZmj1DFdyY+g7x3xs0ex1dleHccaWpKW5glDDRh+f?=
 =?us-ascii?Q?f3JqqQF3NazV8D09iceJQoOwT9FkENs0FzU0nSAf0a1e7tKFrkQSc9lJ+A+V?=
 =?us-ascii?Q?dcfayj4l47jJVrXEQVrfOej3nontZpSyVnvRlRY9YdrR528djrkbckRlgAST?=
 =?us-ascii?Q?didW9GvB88Wd5yUPJ2SQM2tDeZBSrTsURY1NoXE11yECXWVw5CoNmCxGxoPr?=
 =?us-ascii?Q?3WLCqA7TxQNppyxhsEt/Wgm4KPIJrj1GxAPrumjHZgEj/i8XRUgrbNIb0Y62?=
 =?us-ascii?Q?rqJXsKKPMPUuNQxLrBvGBwRM9BF0oEoYezixo9LZhxdJa8BviR7aPHhdFqmW?=
 =?us-ascii?Q?qa0w7bpMC/8j99JhomYYXB7cT4J6PuIJWJT/Gv/wAoNEjKoBMrel6ucxT6Ar?=
 =?us-ascii?Q?oLHi2b/14wKxtBA0fPa38nwd8prbuRmpyPdwg1VEDCNiLdyLdOZpTEWsRco8?=
 =?us-ascii?Q?MTBun1RcaJ7zrhYSRHoeBvVJs0fKQjZeiUkobsSP/0V2iA/AE6GpyAc8Xcag?=
 =?us-ascii?Q?m+YtOwzCi1QNYgPnUrmiUeHCN2NdtQVn3n2t76DNJp3df41fu8NO7O2b6LEw?=
 =?us-ascii?Q?PjpHmyA4UBrEA6nYcPBuueemIsJC+XSryx/6JTxb1eEFNKFIl5fBM7bvxgp4?=
 =?us-ascii?Q?mLtqjwHlTEoqVimLsDSAtwq5Yck5kr7fLGn4C+bNTnVSqBPoo9E5yaHSRmD9?=
 =?us-ascii?Q?mhtNPP0PLQdHwumQF7key6YY0cNkZZRZQeNjyWwg24QC0lQc6kY8TjBoxv8b?=
 =?us-ascii?Q?2Uggo3wvIoO9Qwm9M9wG2EmOGKU6zpqamFgsscJk2FquqUpoc6MLamp4tYka?=
 =?us-ascii?Q?4ylLDvKZ07Xqjh7Lb0pV7xi9XBULBMtJADXL7uMhB5p1pT543+kkdndA8Xbj?=
 =?us-ascii?Q?bBaq7kTCftH67KTlaYC+jfdsPHhTYI+he3J1yg2yA1joKBt8JZAQUtlP+oGA?=
 =?us-ascii?Q?H7tUu/nYCRV0XvaFrccvZlyLMkSoispFhBIiBBD2eFJK8sQQMnB5E0t79Dox?=
 =?us-ascii?Q?sjw6It3xuLOfXXTu0Ghy7EYWSSs2k+s1aS96eOy7pfLUCxq5JT1JAxqcG3yt?=
 =?us-ascii?Q?rcnVNT1oj7GCXGftByzFVBDjCY+Q3NBZEvPRKWu9pOzGrbEv/VvKcX+jnDbP?=
 =?us-ascii?Q?EANNTENxsdVdn+4DblBo2e0kD1Ip5omKAYzwZT/C+g5lLPhDRNRluqc68Lel?=
 =?us-ascii?Q?5xrEnda69+iepfMLEQ2cq+bImHzN7sMCN4yA7yRXhdv2JK94E6nW9S5ssOsf?=
 =?us-ascii?Q?tpdhEl7O6yT5Up11ATG9iAop1yPswV58Li9zlnRr8R3/7Xl9gjydolDljxjb?=
 =?us-ascii?Q?3/vVahu7WEnfbRHYJtcprwAivWwXOkWUWkqZLm/tDvC4JCM3K6wSYlyh07YM?=
 =?us-ascii?Q?bp9/jiGv4HWWqby94YOaZKq/gVr1is19Sb1BHeZ3yrufPFyoxLbA+TEsTpLC?=
 =?us-ascii?Q?+g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YVOLyL+bdeW4hhUDKNjj9AhWeouq+UReLecQYxyv/4NpETgg5j8Zzc98Nn09KXW8383QuxcCtPCAutpkTZ9njGAWnfD2H4gU6GwFMaqQKEW9W1/7psU9fj+JrgzkU6wPEBZ2wZ03G0YvGp0kR4uLvBpG/FZ+MP678nw7H7cclQ81h8lLyvI1IgGBI1suiZ/gP7fMMVK0350Xq9VaHRyzIgERO0+yupE9rm4jEcI04dqYpudHLgxWN7x6XEN79XjPU14jnVlI9Ncg4FUmOvqYTdX71jJBq60ERtQFrM7QtI5KAOYNg8rG3nBUPjUy7x4GlO7RuyBgvx2lahQEKJjz9phJK8gzwFiUxgSVLvTf5wUkMRAq81zYLEDUPl7KgBhhkwdVVdom354KUEntlEWv403kzvEGpZVjgA5Nd7fbuucrw2lFHgeBYddtzUAWadxsqvdHTu1IakW9sbibA7CsfnkAjJHKHFMyC7rUFjgccmvyjAtrP7q/mOVxad/8kktyo4TZ1EeazBecijNqj/uduY4aI4dGKrjJMGmfXKAAkVXovm6oaG9zw6DVwqD4Kn3XjIH7STC1KSkJTaXrUz/gftQZJjCx1nDgmJXwsqIF5Cc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f28c5bfe-4ebd-4dfc-cfb1-08dd1c45ac9c
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2024 13:46:13.1900
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9ePS13kWbM6VbwZ6+2Az1DZ90yNLVZDkmOmzu4DvtURE1vDZ+F4wRbwtvypmdJjPDZ8JhvlRUGeyZI5MBIPVD2Odxligach4p5Z8/56OBjM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5624
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-14_06,2024-12-13_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 spamscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=999 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2412140112
X-Proofpoint-GUID: Y0pMNL544rpQWZZXi1aFF7PuZw5T1-7r
X-Proofpoint-ORIG-GUID: Y0pMNL544rpQWZZXi1aFF7PuZw5T1-7r

From: William Roche <william.roche@oracle.com>

Merging and dump settings are handled by the remap notification
in addition to memory policy and preallocation.

Signed-off-by: William Roche <william.roche@oracle.com>
---
 system/physmem.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/system/physmem.c b/system/physmem.c
index 9fc74a5699..c0bfa20efc 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -2242,8 +2242,6 @@ void qemu_ram_remap(ram_addr_t addr)
                     }
                     qemu_ram_remap_mmap(block, vaddr, page_size, offset);
                 }
-                memory_try_enable_merging(vaddr, page_size);
-                qemu_ram_setup_dump(vaddr, page_size);
                 ram_block_notify_remap(block->host, offset, page_size);
             }
 
-- 
2.43.5


