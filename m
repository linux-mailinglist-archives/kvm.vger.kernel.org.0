Return-Path: <kvm+bounces-46831-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6747FABA029
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 17:44:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2701D1BA5B2E
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 15:44:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1D981C84AD;
	Fri, 16 May 2025 15:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kKChFkNV";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="tU2R4zM2"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAFAB1C4A17;
	Fri, 16 May 2025 15:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747410247; cv=fail; b=EEvxMelAonQbpUM2+s05MxNw6FkihlT315D4RgDbeNWSw87zxqgnRhZIVIgFGySHdqdlWizT5SyR1xtbNFIVDt7mSa8DhF/EIp6WXzrlYgvHcDD9hN3CDD/+ti4ibcO7EWLkoDdiqozhn5VzTqHKPzLeuIA72WMW1Qev/vsovl0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747410247; c=relaxed/simple;
	bh=ljdV7qBS+iDxeb6ODMaXyzCGumd7QwsnPjiOeco+8AQ=;
	h=Date:From:To:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=YxzGp/Micc86W4ITipkgJleMBQaB/W3c4FWt/+ehFuiPlQEDybclrFyIfzpbENTbfeodbYX2TsrEg4jgW0yNTdlU7ZZJEOf9uH5V15O+ZDvO6fVaA/Rt/OV9IP3/WyY5zJiw2ylFuICPu4dg+NvZHrL7pZqhoMCbYVwNnjXOTdM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kKChFkNV; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=tU2R4zM2; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54GF0ffZ021926;
	Fri, 16 May 2025 15:43:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Hrcqa5Q3Vc2AsTV1Oy
	x69PxChvpaF5vQSKxvW4V9mIc=; b=kKChFkNV1Y550giyEAGFBt8wYCgCQEGCNX
	unE3xhdaCsKV8/4jGAZUf04pmKWKLzPLvqKvsFYvCz/3C4BijOvxv1BKAcjaVOyK
	IU6Ci4u1vNrrWNDFWxiG40pKzx2KfCIoLarLvTc3TysKiiwUJqwl3Yi5Xkr4Ym+Z
	O0ENW4fYgmsILbtJfPJVMfFm5C9bNXszFTSsoIfNbzdFu9iVH4v+6msK97q506l4
	8iVq+5fdglfAZDnO/w9XVKtGJOcbo8kjoFD7NEyyF9GhfUkEX/tPEyzWARHHNKTi
	GLtrrBoX2c5/gLSLS7R2SnNGHmg06MaoVmfiw3XGUTsYEqytlrFw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46nrbf1mt3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 May 2025 15:43:49 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54GF3wlx004402;
	Fri, 16 May 2025 15:43:48 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46mqmeu6km-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 May 2025 15:43:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iD6HC8ljulnJvYyqKEd18AKCP8L/5ksjH8K1Pns0dbpBiKQqH6J/yE5yaXM8zwMkRdY74eHoOkOpEphB4MQTlvPBEnxvZKjNbsXG9Rd+tv2iTFv13BljnNQenMIhYQG652hQVz3fcKtpnQh7B4hUp4ErczgwL8gLPUPSMK7Qf6JzU3Z+4X59/raCZ5+esIkk7GYQgTriyL6z0hTycShhZDZaIABFo/hNdFrdMMqJ5HV8OocjBKzKcT+qvGf8Nl4qLMXIW9gS0GPq0pv4MBgbnyZcArEvwJ7sKcrCmkVKt46+GQ2A6xSR/EsXJuHo7Pm57z0BpR+51CCzyvoq6Q0M+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hrcqa5Q3Vc2AsTV1Oyx69PxChvpaF5vQSKxvW4V9mIc=;
 b=SplCPY7oEKUTwrCKcpkPzBee5A3MihJFU9y3cYr/TPdBON3MsN5LXSw5VStW7OcU5DUPOGwg5pW9RZEI/9mRrludcd3/bWIoEJbYNK3WteXesIjaHfjtP1OlDimqHhFwAeeBp5m9p4HFvKq+60Umsh8sXjCCMEKVDQoLV+ziSuv8dNTzdJGgppDiSR/yWnV/Dq4X8GlnWYWk3729vYH0TAQodQv2SS0k9RXFNg0m7upD+nEUOeXX0Ea901UgHbbRxV4KNIxgtK6bxnTxzBFJjAcCXxkzQHhnoSZIQLag+CC5fqTX9mO+o+a4nh3TpfkQovZOqoTB6AA9Dp94Yfmw5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hrcqa5Q3Vc2AsTV1Oyx69PxChvpaF5vQSKxvW4V9mIc=;
 b=tU2R4zM2lEGGT+X1BphF5FZshPn3xPtYr2yyy/ipfrGUGJ8tAf6obEJdXNHsiweyWECsmSjbGAK1ITbeAZ8k8tUvKjeawg1eDfmhLmWE5D/d+1u0odlflpbUtt2hyy+wp3RAaR2xjpkXKSPODXAhGP5NKBVLugQIVhzRirLEa+k=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CO1PR10MB4452.namprd10.prod.outlook.com (2603:10b6:303:6e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.32; Fri, 16 May
 2025 15:43:43 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%6]) with mapi id 15.20.8699.022; Fri, 16 May 2025
 15:43:43 +0000
Date: Fri, 16 May 2025 16:43:41 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Houghton <jthoughton@google.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>,
        Yang Shi <yang@os.amperecomputing.com>,
        David Hildenbrand <david@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Janosch Frank <frankja@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm: madvise: make MADV_NOHUGEPAGE a no-op if !THP
Message-ID: <ba332040-cc8f-444b-8091-52bb6dba57e3@lucifer.local>
References: <cover.1747338438.git.lorenzo.stoakes@oracle.com>
 <3f99d6bc8cd1e78532077adf8b26e973d325188f.1747338438.git.lorenzo.stoakes@oracle.com>
 <yye5j5syytij2rngpxgfxcgusjvtrtjdwqgfxnsbbxc4bibbv7@7gnw3kztmvns>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yye5j5syytij2rngpxgfxcgusjvtrtjdwqgfxnsbbxc4bibbv7@7gnw3kztmvns>
X-ClientProxiedBy: LO4P123CA0608.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:314::8) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CO1PR10MB4452:EE_
X-MS-Office365-Filtering-Correlation-Id: a5a384ea-848c-41c9-45c9-08dd9490701d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3q5+875eOuSJYbUOTQ2yexNnBZvsblcbOHIf4BQUxWg6glpHeNsjF6LxU43E?=
 =?us-ascii?Q?Sc+WgenU+UPkRqnUXXmAjUNVXycMmOVPUWEjSCNzHc5uqYPdGtCPBKxtcrzV?=
 =?us-ascii?Q?GobJHNlqycLjMM3f8suoECcRx4MFeFoj8SwuwQ6RECHwyZ4/cl+gZeBrQHy3?=
 =?us-ascii?Q?VuH8YGkRk4i4zmzTiQFiULp2Ols+3470G0wRhNLiX9u3aHMs4Eg0qKlfC4Uc?=
 =?us-ascii?Q?TmGHEpHalZnPE/P1R7mtHeAFa+lq5EgUNXsZEpyXm2hHjdtrkbEtlE/ZV5it?=
 =?us-ascii?Q?0ph4ZsGJubs/xTDx/OW78x0I2yCE/1QHMiXweZD2BCCS+dP4Glzn+CNXM4st?=
 =?us-ascii?Q?aCqTivuBeyf6FY9hHScImhrFUFfjS3AD8apX6CKC4a97BwyE+eQRGDw42rYv?=
 =?us-ascii?Q?2ScqxrZ6aIdQGkfTv2rSMBCl+S1ZxNvWwLt2ZBtgiXuV6KIa5n3j4GNgcfN2?=
 =?us-ascii?Q?BHS2SovagdRjj0sIw3FyP6Jl/m3vbxskHv0k1SkrOb66IRiRCoqmx5ViMrSn?=
 =?us-ascii?Q?lbkXalHU2wh9z/PHgXO0iaL6ij+BQ5lxfCDgzbNN+o/5oJha+FQ7ENZA6Opa?=
 =?us-ascii?Q?hSDTxywK9PmSCTwe5pylpr7XGJHAkaSL3XMLXWWQB/upDA3g/CWDAOIxeaNx?=
 =?us-ascii?Q?hJ686h3O1tqphSvs0UDFvTTrgaCgr1c1QDymMy9SdMD0kp4qnx8Figbs25PS?=
 =?us-ascii?Q?5OSQ8XjjD7GktM03glU/mJvHLe1vwB6Yly5XvMVqLJaYosopjxswlwOPm4fm?=
 =?us-ascii?Q?/Sm21PuWZspE4IWWUANMQ7u+GwG7SUSEqTsQj1xcm3lspTJRtPjuFcEP0dqx?=
 =?us-ascii?Q?GKJzzN7OkL185FAT+2ZQmKs1bHFk+7baycZSf7QkFrGEK2311jLhXAf5yyBd?=
 =?us-ascii?Q?JyY87hZMO6FUN0deBAstM6fWVVMTvLnkm/TFaEj1BPr6BVbX2tERTJKv9YNS?=
 =?us-ascii?Q?SGrIeIRJb2M2vLyS9KWZLSlPyCohfA85Y/zEuWDbNFjt15VcHhTve89nvYT9?=
 =?us-ascii?Q?jb38lQ5/H4cbODN/iEqV8vbVHTG1dNr5LdRrFlqxvXqFPyIzU3yT10jqll3n?=
 =?us-ascii?Q?0BeEqSfZXSlWHf39Bhueq3T/B1DV1GoyFVzE2jUH5TKpr+FQJPwKrggj7ORs?=
 =?us-ascii?Q?/dVFsAo4JE0gZgvj+E4Mul5EPPV12Dht6JIPZxI//1ApeZRDmKCfxg4xIUBG?=
 =?us-ascii?Q?knMG9dtbKDUoyefFnig+JkD6V6r+XGedLIKU8baGyxDF1i/qrUl4UooqkcEd?=
 =?us-ascii?Q?UulQzTE7qKx7JfGEsii6QIYJbRVKgHp0y1SCImdv0zg2UG6KPmhfDL2f+fOs?=
 =?us-ascii?Q?gtNVhUzZAk8Gp+B4RXbT654PJuFLBkiNnNkT/8B88bOI8ZGEo/3Fpg1MaHgn?=
 =?us-ascii?Q?LOETGXZeN1Ot9YPqRyylxVq+hIxc4xgz3aoNapsnhkCJdBYhCBKmxHVMfsQ1?=
 =?us-ascii?Q?bioTzgvUGsYN+BJCIbem4+CR7NRl0d0qnkqzLPBzeWdqnhsNkeZ0jw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cSMlsujRmNx6ebtbq4rAEgKemXaYF+oARxzuT9F7I1sg3vlhespinlTSz3fZ?=
 =?us-ascii?Q?AQmjkOAuQVL6c+kxpOAtpaeXmahygF3YzXOtcPqDsqqiJTSTcxfvqeLdepXW?=
 =?us-ascii?Q?0L7YF2EMmyOyP1c42SEsbtSZizqhEDw9YDDyDG6HFJqek2RhyHylQ3SjRZkA?=
 =?us-ascii?Q?Sjbr/l1nbzTqA5jKNGLnGijJK2AkrIPkPsEKZXQJTVgLCGdcRvGYahehfiMg?=
 =?us-ascii?Q?6TfVB0gDoBGJ97E1s2kGhrqTLfWENP2JIaGAtPZjteJGFf4wqrZ/97VMRgMo?=
 =?us-ascii?Q?xcIiXy0vaBRhOHUNIZGg0nGmZudftM0x/6CtrzTMyA/LeRazPsXBrWaV21za?=
 =?us-ascii?Q?AcJXta3Ley/REH8nPDewTaEMAzkpfNW2yUheDmUoxvXfxmbOwxjvtp0ZLRKh?=
 =?us-ascii?Q?y8fgsVNOZyQ/nipqiY7yhYICqMWS2jxSTl/Z6K7HEG0qNPGuwmi5FM57Y32G?=
 =?us-ascii?Q?pYy7qjpHJFVHl2uAFotVpJ5r3TsPtum3zv4I1ERWBL2u5mpZgfJi3Ac4dIjk?=
 =?us-ascii?Q?q9dFi+RJZ68F7QNzTpbT1bBvmB6ZJvIZFCyRY1mbeXrx/Kl4VkNG6ECCoi9C?=
 =?us-ascii?Q?Ic3GiLniQFyfA8xaP3uLONYJIwkOOlmEbgtehYaKEkB4geW2/fDIOcstyH3E?=
 =?us-ascii?Q?6nkJgmzIJfkJr1NYix3tmDORN10wzRglRyL3YMZ7SRh3Nx67QhSs0iHViENR?=
 =?us-ascii?Q?gC/SrQmxz8/lAPzBBAldU6geHp6UzsmnQg4quuHEKwXljXTOdMUC0inqznrD?=
 =?us-ascii?Q?70XUb3GFdJJMZe/pzXO3s9JRBpL75D59Bfe8A8RQxmHqEpjJXObBw6JJoPbZ?=
 =?us-ascii?Q?fG8RySH3dE2cHCGb4afC/xC2xa2VPs8/mc1RMhNufBeeSK+qHKyF4pl/1PPQ?=
 =?us-ascii?Q?vf0Hwdjdrsnq5mO5/WHLfWxN1MVl8Xm44yXb4uBSp7uPV+6pv9tKOn4PoV9K?=
 =?us-ascii?Q?KKpMLy47/gxyQM2A0enEHGGi6jdbvha7AZi7ufrCKRNSFZT2qJDj4bSGiN9P?=
 =?us-ascii?Q?ALqY/mYOnVb+RrMhHnsDreeqwHSgup2XMMvDoykglo5zK7bfKPpkKFA2WbuB?=
 =?us-ascii?Q?9SAYa9zuBZXmRp/qJ+1yyn/RDu0DIrhaW93nlVFr1HkPxt6aPz8ndP8vlG+z?=
 =?us-ascii?Q?SKrDchhLz/kU/xlYHwb6EjunFoh3nVvnSI/es3ak/EFPBbMj8gbH6HKqAnhV?=
 =?us-ascii?Q?Hzt868WvWK4t7/tqsy4GdxLptK5kWt8edKpFBMD/7sCRiEeRGtZ/jN7ONdTl?=
 =?us-ascii?Q?ldgaHcK0dBvXbf7hlXuL8juYbneXlJr1gT+NqQU4Wvpcp0FT02U5w5SEjJid?=
 =?us-ascii?Q?PLjiMmchazfw03znjZFmz5Si86C7A2CsK9v15SbrCjx5mewEmCds/j1WiYar?=
 =?us-ascii?Q?8UAsaC+GfjCIqOe8TH+ejjPABTTZ26zph5gRLQwq7xMpHE79VfOJs23Us8jV?=
 =?us-ascii?Q?Wb7dM4kIoGGsLlIQXRGBAwhpD/uhZjMM6ztlOMEelf89/p6iMY7QGvjAcCa1?=
 =?us-ascii?Q?CDsz2NHVnm71Fl8KKdEOeg/SbrZUBMmSRq311BDCYH15pOXXnLp/J3NvvVsK?=
 =?us-ascii?Q?hg/0C1W+GxxVDXHaPR9mj2MK7rgJCFkGTvmniXx3qe0vDmKb8L8Q1ceFaVH3?=
 =?us-ascii?Q?Pw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jYGk58qA4ESD2l8DGqa70Fqz+R8W751/joqgSd8hIsnomsoMWvV9Xpsyp0qIKRrzPfy5EgvRvt7jUmszqrViypm6Gz/t3dtKe6j7/rQ1Rlyu5J7YvMku7uwV2KrEC/sWx/NH/IzHvb/1D4vCwTnqAohwEJQrV/CpAxmRQOP+o4D6rgFIlqSQooAaJIpRJ6CqpWpk7ADy0l+ELwXkmRMKkK2guYXDpaymT1hW1jxi70Xk2VqKVQVuSVJi+GNXf5bzyF+FVBrJzByKunNkm4NokxRBwmr9rD9k/tFTsGPIL5L68BqvqBZ0O1Wyu5scFLovRx0FmO0I9zeepq13wchaPDR+aWXxCMARJAiDEwu+dmGbYQqzyBKOWaAydCHKJ10aS5ocpsTCPwJhkTxxYG1Sa9qau5Y4Dceu6ngrQ8Z/9l4EGjvM0AsXYXpHpCFcYEC46fiG5xvW0TXxtdXGIsvL7v7NqXEekYnWRofUfRqN8HdcXHxPUoaFCOcByWrseh3zo0vjNtlNPxh1aeJqs8igrhWwM0VJixNPLhucot8q3pARp9A2ikwh8ZJUE72Y441V3RZyLIDWHI2asHRYMA+e3/s8gagjSEqrBrAceckQCaA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5a384ea-848c-41c9-45c9-08dd9490701d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2025 15:43:43.4573
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jz6PhBe39lg31OuDGALRRYVkb8jryYvDFJVFlx/UoMe2xgMHwA5TuTsWpgABhO8CagK2Qk39RS/K8v2ddGT393hem+wmsNQfJZR7a2SQJrI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4452
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-16_05,2025-05-16_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 adultscore=0 spamscore=0 phishscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505070000 definitions=main-2505160154
X-Authority-Analysis: v=2.4 cv=Xc2JzJ55 c=1 sm=1 tr=0 ts=68275d35 cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10
 a=kj9zAlcOel0A:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=TAZUD9gdAAAA:8 a=JfrnYn6hAAAA:8 a=vzhER2c_AAAA:8 a=20KFwNOVAAAA:8 a=WfAh8arXmj5OWc_a75wA:9 a=CjuIK1q_8ugA:10 a=f1lSKsbWiCfrRWj5-Iac:22 a=1CNFftbPRP8L7MoqJWF3:22
 a=0YTRHmU2iG2pZC6F1fw2:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE2MDE1MyBTYWx0ZWRfX83JqlT71yD0B 7VuPdxcVYi/pM2XLPBKiKfBOsaR2HZ/OTozSvj7Mr8819WJHKdzENloohImHaVAje0lhPhP/J4a phVjVzqpYZRgT1Xxjt9Y+AR01iZUgIGaOWEbYSHujZUM1wmet2XoY6MtcRME1qKiJ1n4jrdpjKE
 FbRC0SfXvbdFeJYCPLxzBNVfiGA11tJkAYJVAuNO6WW3mCR8wteouJZOipIvyEMZr8aGWalAVgg ktfqyRgsHU3YStWN2pQ2D1HFMT+ZnnmHMDIngLscmv+HKMoVdvBjVVO5Z7K7sPZqp/j1SAKFcgU lOLo0BE5WgYW8BY54I1BhNIs8e1nxbYsWdGlvbXfIH/a7LXZhmepn3F6xvMjA0LwIgF3muSM60r
 lrjuw3XUsocbQWZkEsIuNKSJ/aXqfOx1RVOornWaSdAakRhgSKupb+kIHa3ZDWFoH66yqKO0
X-Proofpoint-GUID: vnHjHed2EaqZAIOdb-T7ODonxJ8bmfDC
X-Proofpoint-ORIG-GUID: vnHjHed2EaqZAIOdb-T7ODonxJ8bmfDC

On Fri, May 16, 2025 at 11:40:23AM -0400, Liam R. Howlett wrote:
> * Lorenzo Stoakes <lorenzo.stoakes@oracle.com> [250515 16:15]:
> > From: Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>
> >
> > VM_NOHUGEPAGE is a no-op if CONFIG_TRANSPARENT_HUGEPAGE is disabled. So
> > it makes no sense to return an error when calling madvise() with
> > MADV_NOHUGEPAGE in that case.
> >
> > Suggested-by: Matthew Wilcox <willy@infradead.org>
> > Signed-off-by: Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>
> > Reviewed-by: Yang Shi <yang@os.amperecomputing.com>
> > Acked-by: David Hildenbrand <david@redhat.com>
> > Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>
> Nice to see you review this for yourself :)

Haha yeah... this is a Lorenzo-getting-confused-by-kernel-process situation
again, this is 100% Ignacio's patch, I just bundled it up in this series to
enforce ordering.

>
> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

...But of course I did format-patch -s so I signed it off as well :P

At any rate the From: field and Ignacio's S-o-b should make everything correct
in the wash. I think.

Andrew - this is Ignacio's patch for avoidance of doubt :P

>
> Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
>
> > ---
> >  include/linux/huge_mm.h | 5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> > index 2f190c90192d..1a8082c61e01 100644
> > --- a/include/linux/huge_mm.h
> > +++ b/include/linux/huge_mm.h
> > @@ -506,6 +506,8 @@ bool unmap_huge_pmd_locked(struct vm_area_struct *vma, unsigned long addr,
> >
> >  #else /* CONFIG_TRANSPARENT_HUGEPAGE */
> >
> > +#include <uapi/asm/mman.h>
> > +
> >  static inline bool folio_test_pmd_mappable(struct folio *folio)
> >  {
> >  	return false;
> > @@ -595,6 +597,9 @@ static inline bool unmap_huge_pmd_locked(struct vm_area_struct *vma,
> >  static inline int hugepage_madvise(struct vm_area_struct *vma,
> >  				   unsigned long *vm_flags, int advice)
> >  {
> > +	/* On a !THP kernel, MADV_NOHUGEPAGE is a no-op, but MADV_HUGEPAGE is not supported */
> > +	if (advice == MADV_NOHUGEPAGE)
> > +		return 0;
> >  	return -EINVAL;
> >  }
> >
> > --
> > 2.49.0
> >
>

