Return-Path: <kvm+bounces-46726-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F144AB90A8
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 22:16:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0F427A0549E
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 20:16:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 760DC29B773;
	Thu, 15 May 2025 20:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dGJXEuJu";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="ONdAPQEd"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4BA5299933;
	Thu, 15 May 2025 20:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747340183; cv=fail; b=uMCbgn4rS6ZtSt2dhYGr3IDSIHVxxbhn7mw7R35UIIn+CzriAkBeiZRXeoi84x5rsTc2N1LFuu53LE6zha6BDzlAPFWVckR1Sy0Gfh61bOPs+iNe6FsO4JzWtmob45eHBYEvW6vV3QDjmVizj8Ptepy+I14osV5wtnwKwlwKy6s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747340183; c=relaxed/simple;
	bh=sP/ZKwqBwq4c2snwFHrQw5KpYgkjizhVFQ1aTbSJUVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VwDyS9oMgtCM0ucGD5biTHsPPbb+cSHyP+ZIqiGR01MARmzRbvPQ14MRUE0ZiPl4vQjibqJDJ6yFxyVRK4UI/i/SP5FeOLnJLH0WC4pbseT6xLn6APQb+PGxUv9y6OoV5/jAd+Ht8FxN9udtRmMFiEl/UlBEwSHjr07LZQHrp5o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dGJXEuJu; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=ONdAPQEd; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54FJVxuB006316;
	Thu, 15 May 2025 20:16:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=zNlJKXeJ/iK7A9h6rXRZeqt+pWnQbf99GXRk/pREH/s=; b=
	dGJXEuJueVUoI2KgAtLN+h14+4er4cr1MfSSrtC/GzRtPbqUFviEQkzpCb8hNR/K
	ISF47DMNMSgngZ5ZFLn0laRv9dk3z2XSJbDFyWncy8BXLqkJH8etApVWSXKKDrtO
	pwQ0oDCJugy/6Fqhoa9EEDGiyQzpllsSd7pHrAwelGSsFIguqkMozcW/r79ymWfd
	Fi78hvI8KGwWz0m2nhGA02RgJi9u39wKOLBgbLIwAvJQMBAGECMRBp/42vRVvTu6
	BHaat3r1GCAKoikzYctANtk5VFPEvSbVzJjyihNUyYyvlt64/qmoiAeVmgULJwjI
	peW7LfXK3Mw5wzv+zyYSew==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46mbcgw4me-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 May 2025 20:16:00 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54FIPMFq026130;
	Thu, 15 May 2025 20:16:00 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazlp17013059.outbound.protection.outlook.com [40.93.20.59])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46mbt9tq3d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 May 2025 20:16:00 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=evNCFg2Ibdeq9nz/DxdaxeBooQRlus5Z7iExXghONQRxeHWxAI90mZegj0er5RC3RgVd6nqLdAXZc8wDmlN9DAM5EGqb0IMqQrXOomOdNLQqQ168YOz/VpYEYLgkdvTa4NPKcsdJA+TzUOwwdnYriGRinr6K/OBphLJ38trGMk2Z8AzEF/woz2tv8RzfHd4lok1Kt8O3VahH3HqW9NEgNS8YWg9JDtZaN5exnNE0hrH7ao/GfT2FcUeNyGZtHluYHa6Jeh4dPCGIsFLIq7hjK6crdKaps8aC7166lKHf3iGr+B+6L5hvo6eUFMEd59OHwtZ1MOJKZRA5RGLTRr64vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zNlJKXeJ/iK7A9h6rXRZeqt+pWnQbf99GXRk/pREH/s=;
 b=A2/OhYvb4Poyk/WgfxSMlrVBrzi0nWppNu5wW3+EKRya/beQJZD0K9QVNc7FT2BsYFC1IfhUiYk3Dyd2N9dWoFXAddcYBqYph/1oHqqKgSyjeYmn1z5fgrwfH6Sou9Rn4SpgGAYZPuMzlO8LB2V3RB0YiErCKMkvejUjNZAj4IMUZ1ADO2VFa0YxkskZZb//5BL9H/blqKPitdNgzaw7dNbKSr2zLXyeGW83tZMczj2hfCy1JCUwsF8l43mTv5b/uGYfzCBpNBKZbanIfhGeXxU4T2x9749PTvK39uN0DKM/pacMbQMw3adPD0T5AvifHn2W1K78wYWOuNYlrkXvfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zNlJKXeJ/iK7A9h6rXRZeqt+pWnQbf99GXRk/pREH/s=;
 b=ONdAPQEdW8D+WKRgsR386OlulpOjzaI/kbSQc+ykhEhOkgTXSiRduVLZadk4elggY5/bkG+qK48P6XmmC5Gvk6YGe4s9X3+Zc47fxyfZ8ZX84/FzRqlQMjb90k2SwufMBBDygVa2JEULs62XVh/4rx4ZX8/hqPdbgLtXUrstK+s=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH3PPF34C504C55.namprd10.prod.outlook.com (2603:10b6:518:1::793) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.30; Thu, 15 May
 2025 20:15:57 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%6]) with mapi id 15.20.8699.022; Thu, 15 May 2025
 20:15:57 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James Houghton <jthoughton@google.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>,
        Yang Shi <yang@os.amperecomputing.com>,
        David Hildenbrand <david@redhat.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Matthew Wilcox <willy@infradead.org>,
        Janosch Frank <frankja@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] mm: madvise: make MADV_NOHUGEPAGE a no-op if !THP
Date: Thu, 15 May 2025 21:15:46 +0100
Message-ID: <3f99d6bc8cd1e78532077adf8b26e973d325188f.1747338438.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1747338438.git.lorenzo.stoakes@oracle.com>
References: <cover.1747338438.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0274.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:195::9) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH3PPF34C504C55:EE_
X-MS-Office365-Filtering-Correlation-Id: 888dec6f-4fad-410d-b974-08dd93ed4dc0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?RoyKxDsgjvvtuKwxWun71QF17bIPrP1Vt7WU9UDiZFJh8GisYLw6YwF4fzSd?=
 =?us-ascii?Q?rlhQRYZ9DQxvsX+Qo6ZZsj3GHFEJURb9RY/8m2p0ocQ7ARaDhDvGdX+sBIpL?=
 =?us-ascii?Q?jV5cwWR7lRKmDU6OX8uynLe4jlCCaAQMtswKboUAS3pCSaeBiy0+KW/VJwMn?=
 =?us-ascii?Q?5ZgOUuWIahdiqZGzn7Bijw8fBDoRIK4Yvm2+bUd4XvyJycp1G9e1+9Jg3qkh?=
 =?us-ascii?Q?AklM9QLJJeNqrSkZ8ed+Iue4qllIKb9H3qnIsYYyOhRwwAaEX/AH58WlcZQR?=
 =?us-ascii?Q?ZfUVOxqgsj+qcvxQ5Sv7d/d6FnfvuGsVgZmEt9+pquKPyHtXQRoi2qH+YDVX?=
 =?us-ascii?Q?vjGZLyOKB/NXJyO8TB98TugQZsMVsSQGgkEWC0nhtgUQGS22q05VJitfVd9b?=
 =?us-ascii?Q?yhpsGTrRAYox4MFXRPim9r9NAG4ZOroq5p3e4VHK2eeTNsDiybgIwFcMBOKj?=
 =?us-ascii?Q?r2bk7UOidxbk4tlF9qkkG3qq5x++Q/5NU8ZUCEJt9I54hm3ImEWwTK3yNs0t?=
 =?us-ascii?Q?BDtuNsFL4lz+uORePQl5FCfAR9wYTWru+2lyo25Ge/LWjHhbOUytK5uN/Q16?=
 =?us-ascii?Q?1Adauso33LtpfyKb1XfIIyGNXxWMqiK+Pgce2ZakpMCYXL+ge3UprD4O+Jrt?=
 =?us-ascii?Q?iX2GBS9gym7J+20zSBiQbT3IQER20cLbrkeCbGek/gssm3gW+r1q7H4Jsh0+?=
 =?us-ascii?Q?5OjTWc/i3+td0MMDzm2OWP2G7LgF6FMN4asPgf6ZxN/1I0miGVBTEMBcAyuX?=
 =?us-ascii?Q?wKIlWsicg9RW1A5bEVJQbsRMxu0mjeRdFlaPhA2Zh4WsllbCm7B5+hGIHreN?=
 =?us-ascii?Q?Dx+3I/CYV7KJc0uQqD7cUMsBLNokMtoiKG3HWkBb2Il9AbG1oFDW2TZ3OCg6?=
 =?us-ascii?Q?cL1lqUc1ARLtDfnXq1rbQKgoUuqDY2aUELkwIxUxqiggMp71xOLj2iEkKRY5?=
 =?us-ascii?Q?TZRe598Kf5NyaBsevzV8tqDYo77U1TOwwaDrjyvaqw4PWgx9VgFp3aF4S4uW?=
 =?us-ascii?Q?HmZ1h/eQBpRE6WOeH4lx4O/YaltEoW3ieRX37fhFNM6NDIm1hEM2c5sBcxXx?=
 =?us-ascii?Q?Ytc0UeLETj34iw/X3VZHapl6qTtW7JY/1SOTpVhHC2i+YMnpbcmERrxBel2q?=
 =?us-ascii?Q?PnFhR36d6pPb/kLLauy9ihhI7vO0SZ5SHBNJTvtVIIYwqYNnsT15Jq2hbfES?=
 =?us-ascii?Q?GSu5/x7r0xRPsqr+dBtEWtZaKb+MTjIVIQy/rm5+BYtC36mociGAvwkdbBMk?=
 =?us-ascii?Q?1QSnZRDgvIq0maGCtVPCVD9Q7wmKpKYQB4O/C62P07hSA1MfmygIE5HuNXs8?=
 =?us-ascii?Q?7/bH0iZOO1NfmJ/S+3G3Ab5pBz/I/Ov3CrU2k3FZWNfpksvD+uL6N+FB1FKY?=
 =?us-ascii?Q?PxdmHd64tD7mpf8VVuJaL2+ziQkJ3Jz3O3jae+uOolFgwp4hSz1fG7zYOody?=
 =?us-ascii?Q?17+x988zJ/w=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Nhf29lzTqj7J4Dr0XxaHcVT1E/sShwDjdn4sf3PLfbyagyGRVL1CPAOvPzry?=
 =?us-ascii?Q?rJ3HjsWQ+w0vV5yJg5cO8CCsmFQZeRsFRwhLicinEmJRhZ2h0x63yhvEtEFv?=
 =?us-ascii?Q?0xYFQXAhrqIs3OnXamWlg+EDeVkif9V0spRrxCop6LX45Q/+agsprjulgGxm?=
 =?us-ascii?Q?1ZcDuQTlVaASmLF7xqsm7ubTF7TqZCK0cETtC6KdQokKdZam2Xg074rbvW5N?=
 =?us-ascii?Q?dqkkGb47qi5hooaUofbmhjpvR9DRShkRaXU7oiIZvB4ZO9ZbRhKST/pt09Yu?=
 =?us-ascii?Q?ZSyIFgfiUleiiLd4leIY1R0Wq2ePjFoKGdQrOShUgA/dgY1Ja5lUXDCXrMJ3?=
 =?us-ascii?Q?BLTvH1FiQEtG+PUflPkZvmkmonVHAtnF3kw51hbo2Zvh5GbOBmSVLRRzWReh?=
 =?us-ascii?Q?QFBp6hb6tNTLPVwUBPQZsTyv3Wa7Yl3bKzBEllKXIRFJumJaZ/OYu9TBLEPt?=
 =?us-ascii?Q?oKY17UAz/GKoQu1XCU2FqLpmzr5LI+trXs2CiDSmo7JDvHh+I8kFSJmLB5Px?=
 =?us-ascii?Q?LCA+qNXUGgJirARJGckT2dZPGCBLyj8ruiIIzSbicWbPRJPzdBITAWVQvoZg?=
 =?us-ascii?Q?Qfq7zYd1vGKF1u97CeX5fA2MwDOEVpRcJtKsT7Fkzx7pVqjCh00Edp/G8zBr?=
 =?us-ascii?Q?YpUL2NfHTcdmctzcdz+z2W5oVhsyj9SbqyXvXInZqQVRcRfisnJ4NtGd0tQW?=
 =?us-ascii?Q?C7MrTnzCKyH8pfolunSpPEOMxusakse+RTE7k4GDcycBocVm30rSMrAvIiuh?=
 =?us-ascii?Q?5DJQqOAjPbaB+kTm2tsLaw0uEofEhecy6ib8WnxOGgamRs0L1fMZLIeFecHi?=
 =?us-ascii?Q?sxK5UkQqCPqAyunCwvINl/+M3hILUKsCbYnTiU71xA7aKE6BSuyxXqTgiLA3?=
 =?us-ascii?Q?IEgOephGHpidinh8/f6X7x/3POyf89Kc1kbdyy8+iP8SEuV7J+4LaGVhQAI2?=
 =?us-ascii?Q?CFei0l4+aSK92Dpvr4w50cIW+NPeyw37cpKAj/jIkrn/Tb4Zgf4ySIsIHAVc?=
 =?us-ascii?Q?vaapn5XmGXG0mRgtV1WE90qvd3DLM8FD+nl6i5tLrAScNG+r5/2NorWEBR6w?=
 =?us-ascii?Q?E6ZO1psC1akDWExk+QqNxep2rg9WWVxuDIpaRIVuUXmU7uArlCkHhhQXelav?=
 =?us-ascii?Q?WEfgEJyOyVnfU0TBMVPGqHG1+XOrxB96hXcOSQ0EofVBAS/I4o/Jdl8aVrfN?=
 =?us-ascii?Q?D66Q/3U95lfSiiKpNHI+jpYIX6zxwx6DT/kFDvro0KRC0RkYCXQPqZDHk05C?=
 =?us-ascii?Q?xw4aAgSZMxG6ngJT+Jm8uI1g2DTzQT0WZxUtMn3nW1mlIz6L3VsaIJx8joJA?=
 =?us-ascii?Q?3Fry9GiXz7mkrz+/VmZGShn3YLZYfg3Aa7xmlCAZ6wHmq1ZEosd3rEOvwiY4?=
 =?us-ascii?Q?hVQO5pGZnMj7GNz4EspSVhEscAFnYmpBcvZqpZK9RuM3cKBtsYofkktXtInR?=
 =?us-ascii?Q?wAbScINNRmGTM+6NplHsb5L89gn04BI36vxp5bj4d1CYoCQjkSErrO/FEGQX?=
 =?us-ascii?Q?TCptgt7fOQ64PkaudYO7vlcNfwH1W1gzk3bFsKr57Ii7Gh6X7QLR5eZZy2Wc?=
 =?us-ascii?Q?oo0A7DaEcU1Dl0h092fnLipbUEKufDNkCtOIyT6lopKssZxhvPZAvWwm2nA9?=
 =?us-ascii?Q?Pw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	dnfvd4TRUvKWPBkcqAA5TBMGACVQ6Y8M4ftl2LPnEhaPrCDOWAdVUCQppFlaGw++k64966tSW6CEFI34SlEVwV8VQxzbDNF37nqyGlvsjiPukwXi4ZztttkzxGmIW7GrXIYksG06/MxUJhQTtPZ/bZm77WeaUZKw37/260mzmJVwARkzggeY/cyLSzRSfs1HNmL8UeLmclGFJQu7PgNYpShc19kBogsJqHON5W9kYy5WIa2h5qhUrIm2IF9GylB5PdLG8QTgfEW8P7W2Kk1TCcJXq/clHOGED6UyYvFLfrZeI14qugnAMm0Iqb4VtS39YQqxeG7VxDIo6o6skQ9BoGU0tEqI7jPLAHP7v0P5JRe130kAWeahmOQ4XaHtBglE2eSAOSRc7PXCjmxxiF3l8Vgyg2kdzIQzSM4bnvCeDuM72QSIWP/rINhJpt6oGZ2LMQRHLWXtyX1TTCWXJ+LgMxe6wsuc2LV4z4fGPru+kTNCnCVHNkbsMRaL9f6cL9YQAII5c5rFH3w57tPVPbdKHvJzL0KKKVLssuMYnMhW8qUVZPsc/U1a+BK4l2uua1V25CXupcWyUUMID6kDoQ/wIDo9g9KQT+HMvk7L9SmXgR8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 888dec6f-4fad-410d-b974-08dd93ed4dc0
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2025 20:15:57.8326
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BCtjOgf6wNqtln+Sazi6sVQgDq9l9YJuDNvXQ2MamKi7sCz/ECqNELka1zSoXTv+XtgE1ldKSdc0SsayYEdKP/jZjGiRdVyOwEO07oBHTUg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPF34C504C55
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-15_09,2025-05-15_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 mlxscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505070000 definitions=main-2505150198
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE1MDE5OCBTYWx0ZWRfX9TomDHUMwuXQ oSobV78AWAJUybm9ulF41Zaj1EEGQl0v2eEz9YXh9O5exrlCjVGFVDnIGAWRI1JhWuPT/9UTDcK XDQbR3LCScTTucnyHhzKix31Rzr9Dhh4D/UCBy3hwh93vtle+PtMrOISbEp1ikj9F+Wx8ZQ+djL
 W4tAUphpRG/bNZ9cr7C4f1NqBU8M69uMDm0xSMYMpmBjV8hsvyqdt759h4M7yyxgCJz3sa7b9YZ AEzG7iEFus9MkuNRlvJ0u6vcUf9CWd6sEcSANfuD2EkS4iKpGUirxW/KXqY7gAoNwZXHbPUA44p mzEIiAMDRzz9jcDiie86FBOJArZd8ZmSNiWZX+gEmu+GW88vM/yQyDKGOESClxsyy76Kan6Lt1S
 xTKFkwBMK2BiHvaWc2rUlfUU3q9w1wXiKm5f9N59XvIw6dE5GvLrj1+iDv5lGed7cewgxdY4
X-Proofpoint-GUID: Y0ld1EIo036cNjFwtzAnZ-NOKwoRu-eU
X-Authority-Analysis: v=2.4 cv=fvDcZE4f c=1 sm=1 tr=0 ts=68264b80 b=1 cx=c_pps a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=TAZUD9gdAAAA:8 a=JfrnYn6hAAAA:8 a=vzhER2c_AAAA:8 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=uVTOMNW0ezFK_pqGg18A:9 a=f1lSKsbWiCfrRWj5-Iac:22 a=1CNFftbPRP8L7MoqJWF3:22 a=0YTRHmU2iG2pZC6F1fw2:22 cc=ntf
 awl=host:14694
X-Proofpoint-ORIG-GUID: Y0ld1EIo036cNjFwtzAnZ-NOKwoRu-eU

From: Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>

VM_NOHUGEPAGE is a no-op if CONFIG_TRANSPARENT_HUGEPAGE is disabled. So
it makes no sense to return an error when calling madvise() with
MADV_NOHUGEPAGE in that case.

Suggested-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>
Reviewed-by: Yang Shi <yang@os.amperecomputing.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 include/linux/huge_mm.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 2f190c90192d..1a8082c61e01 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -506,6 +506,8 @@ bool unmap_huge_pmd_locked(struct vm_area_struct *vma, unsigned long addr,
 
 #else /* CONFIG_TRANSPARENT_HUGEPAGE */
 
+#include <uapi/asm/mman.h>
+
 static inline bool folio_test_pmd_mappable(struct folio *folio)
 {
 	return false;
@@ -595,6 +597,9 @@ static inline bool unmap_huge_pmd_locked(struct vm_area_struct *vma,
 static inline int hugepage_madvise(struct vm_area_struct *vma,
 				   unsigned long *vm_flags, int advice)
 {
+	/* On a !THP kernel, MADV_NOHUGEPAGE is a no-op, but MADV_HUGEPAGE is not supported */
+	if (advice == MADV_NOHUGEPAGE)
+		return 0;
 	return -EINVAL;
 }
 
-- 
2.49.0


