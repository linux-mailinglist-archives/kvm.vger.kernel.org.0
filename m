Return-Path: <kvm+bounces-46291-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 954DFAB4AFE
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 07:30:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1805219E79F2
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 05:30:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 093621E5B93;
	Tue, 13 May 2025 05:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lJ1B12TC";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="R52a+h0F"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52534189B91;
	Tue, 13 May 2025 05:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747114201; cv=fail; b=fnYJfKOVmD9YKYOKQBQjvuJoSA/861/FeC4bVOXSN3e817t9tVnl3FO38vS9pGlyni23GrxBPnXDSyOMX3Z/efboXgU7slLCcKIGImZosA7Gm5Ib2+BmdkQiz/lMRje/6mncnh+Rc5qcPd+mXHH9LAr07AzGyE/Nmfg9WWHe+Ek=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747114201; c=relaxed/simple;
	bh=vjQz1Qu9pw+YUhSiLX5VSXTQDtVxd+VtIMOsHKnukX0=;
	h=References:From:To:Cc:Subject:In-reply-to:Date:Message-ID:
	 Content-Type:MIME-Version; b=lGG7ePHz7XBvkXnUHn+zUVRHJOQFv4IC4+KP3aboGO6U3mQ0CbRJzF0yK2IfaYdWLZogh9GjbD5h9W9rMIA6/zbKAAi3I199ynejYanBifn13aGpZw0Croj2CB14FzGVvpimA6iavqfFUV1vTOyX/W7LOM77epS4MOVQusDVY9M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lJ1B12TC; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=R52a+h0F; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54D1BsDL002818;
	Tue, 13 May 2025 05:29:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=k/TGOpy2iNiG9nj6rY
	q9VqMzxUVWe6LKdHkQEBHh85w=; b=lJ1B12TCD7wdeD+P+knKU9ZRVkyFny21FS
	la9lKqKZWNAYVGd6ZdgIxhryajfu8MO+qjaUYuW1/jjnkFgaOFJ6/3EE7hHPggdE
	5sem+hhB6f+gC/z+ieHlAokUzwBHwhKp0CzvVolhIdaDIEG5Ab96sm7kQtlWBMHl
	JGgHlSXn7sd72LlANSxSk/tjRnujB7508x3pJhRClcWXXbavi4xrPiYj2xAgG6Ff
	wSU6bAPkzfkEbq2gcyoi/6LJCXU+9eEhlSL0/B2vUWSByxzQHvnOmsE5rrx4Nxfm
	nMfvI6ctIZZ4ai/Ew30yQ7fXc1L0dL1Riiu4Gt/aNXqYyGsCQlEQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46j059v11s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 May 2025 05:29:33 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54D23ONw016234;
	Tue, 13 May 2025 05:29:33 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2045.outbound.protection.outlook.com [104.47.55.45])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46hw88795p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 May 2025 05:29:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SKJ1zhVrIIWP+g5fgs61FiqPQkNNHUugq+lV2M7nOotMCYP8FmOKJxjnQFk5z5Y/i3MwXv5v2ikaDVWVyb2HuU8gGxTyKtp+RQ+5/4fq2/9AqEiCTbK8bh7sG8rMB0El1Sm84IuMz4wJ/8kV7W/p+yRt89mXVXjm+wvsGBmx6NzDF9dqhcqhVFjnJoQb6iuYn2EyJVqHcnOoscgjOB4VpQ0hZe81X5w4hhZgdkjxkLqDeDswNN0i42+5E+ytN0zKNGYSEcVxYBnujN738fyQsjo0cvF/2gPazddgfjs7sz2ww2I/V/e2yHXfcQpp8HlMeIcno4uan2E7iYxCtuP8Ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k/TGOpy2iNiG9nj6rYq9VqMzxUVWe6LKdHkQEBHh85w=;
 b=JVTW55421oN+KMI28xORVBnOteZp2tUPBLKo16NWF6oqkCVDSqjMDMs8SmDc9fg3b5lnKLAoC8sT2ffJ2LTJnkODN7cviZ+xO7jdvQuoA4+MDPPOidWnS3pGbg95ztbAuRC+5UlkSJ2GwO9DzWurUoBieH4jHmi91KOmEtsxT1N8XmjhL24yYxAHTt+TchAAB/L6AO7RHXFD6lsT3pLqDXYsXulBsCMbSJbmqLvwJonPaHVvs7guIepNGVxBY1Im8SsiK0vh6qSOg9hIwn3DZYzPFsY3yvpSHi4IaXnRkXCgoCOqTlRIDx8sEHfJ1bLdLUPqHKgMIulmSuVS6BKseQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k/TGOpy2iNiG9nj6rYq9VqMzxUVWe6LKdHkQEBHh85w=;
 b=R52a+h0F8SvWTGbWsL1k0ukV9EsoKTrctwCVITxTJTfQADozQ5ivZF2e80PEfPoIwCpRTX4/T1zZVpcOmv6q46hyLfZ66b54/F0MU8Yzro//upANW9/4MlIiLkDokr6+KV9aWaUosJfpyL8MWuOAl9tdej2IaPfATcGQD8gIjj0=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by MW4PR10MB5884.namprd10.prod.outlook.com (2603:10b6:303:180::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.26; Tue, 13 May
 2025 05:29:29 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::25a9:32c2:a7b0:de9e%6]) with mapi id 15.20.8678.028; Tue, 13 May 2025
 05:29:29 +0000
References: <20250218213337.377987-1-ankur.a.arora@oracle.com>
 <20250218213337.377987-2-ankur.a.arora@oracle.com>
User-agent: mu4e 1.4.10; emacs 27.2
From: Ankur Arora <ankur.a.arora@oracle.com>
To: Ankur Arora <ankur.a.arora@oracle.com>
Cc: linux-pm@vger.kernel.org, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, catalin.marinas@arm.com, will@kernel.org,
        x86@kernel.org, pbonzini@redhat.com, vkuznets@redhat.com,
        rafael@kernel.org, daniel.lezcano@linaro.org, peterz@infradead.org,
        arnd@arndb.de, lenb@kernel.org, mark.rutland@arm.com,
        harisokn@amazon.com, mtosatti@redhat.com, sudeep.holla@arm.com,
        cl@gentwo.org, maz@kernel.org, misono.tomohiro@fujitsu.com,
        maobibo@loongson.cn, zhenglifeng1@huawei.com,
        joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
        konrad.wilk@oracle.com
Subject: Re: [PATCH v10 01/11] cpuidle/poll_state: poll via
 smp_cond_load_relaxed_timewait()
In-reply-to: <20250218213337.377987-2-ankur.a.arora@oracle.com>
Date: Mon, 12 May 2025 22:29:28 -0700
Message-ID: <87ikm5jcxz.fsf@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: MW2PR16CA0054.namprd16.prod.outlook.com
 (2603:10b6:907:1::31) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|MW4PR10MB5884:EE_
X-MS-Office365-Filtering-Correlation-Id: a9363302-0900-423c-7dd2-08dd91df221e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?glcqCdfYcjy0uMWh1UYmEP2IxXKn22ofEAKlInQZ5ixDUlv8LtM9PiXPwFhF?=
 =?us-ascii?Q?lb5VNTYSEXd0oPmZXuT+VrcOAO01Nen8n5VETfyzZIID6IoTuHsbIapy9pHu?=
 =?us-ascii?Q?Pu8cHNxQL8ib1Ufm93sKlYIiBGb1C1wpTDyVBpYu8V/rTktcKDTzgG+MnUsJ?=
 =?us-ascii?Q?JCl8M5M6g/ryhOOH0WqrXzIRHe2wG+1XNijhdRW8rS7rlGiQVjtWBQ623TVt?=
 =?us-ascii?Q?8ROWwbJdp26h/GgXtanSsE3R1bnuFnyYup0p2GDFaHOguQOvqirygCdLBRgO?=
 =?us-ascii?Q?lRGdyw1hjwGHNdTIx1gDfBVNfAPp+36Eq5H4nPIdmJ2gsR66iliwR1x51W23?=
 =?us-ascii?Q?GMC9K4gAO5viDbS7+6w+C2TwxYpXGHxvhwY+Im6P91Lvdms2Rqhh2Acu2/3W?=
 =?us-ascii?Q?GZiE6wEiGAm7hB9OzOxbgYHkr+rUhT+SeTGx2ZRxVB/HH6/lyhMPrDC9yvIx?=
 =?us-ascii?Q?ePXQv5eS7uPMSB5K2shiENwA2P5vPpuSPdV1Y/XN2nSFfZSagqyRJO1r+fsa?=
 =?us-ascii?Q?GDewrfKWq3uOywNTvmVNYMkVKBJc9d2fVn9JColdKrTtobNCBNcV78H02Tut?=
 =?us-ascii?Q?x3XiFhwtmAo04MFGorzOpZs6XCK6ewegSBtpQlm+foD3VXpTfLEyEkBnsW8b?=
 =?us-ascii?Q?k9DuWEnv8NgepKaqwr+xxXzV51S7UmPMb4picrVCbyQnxZPCHkZM7u8pWzqE?=
 =?us-ascii?Q?86HZBEllum/eWl4axQ067O6Dy6m1NJoRPUajQhdB37FYIFOIz5aZyrLAiUKL?=
 =?us-ascii?Q?nkV1BWG2yN+AfsoOzMJlM1yBfl7dMG9FssLGVxu/FQUb8pD4S/GYoWZL7SLF?=
 =?us-ascii?Q?NRxrzz6vqxW13afjGjlwZTMFi9wodfcqRLCJnjvGtt7LkPjpuGmc1kJm5/Ar?=
 =?us-ascii?Q?2rI47EOplWxUAPi7tQU+4CDBAv1AWXEhjVjcNs0+ael9C+Z+fHmjHBLM595v?=
 =?us-ascii?Q?NOTUPWzuz4l5bcVn3isFeziYUtiWfa5a49Z1wSc7o3wb54nNeJcRBA/yySCH?=
 =?us-ascii?Q?jIdoh3sRBN/wAq2CnBVqgOiAEU+SSM8BKoKROsRJWi330SxOqO1u1oBXq5BQ?=
 =?us-ascii?Q?mwpmBw7MkMepfzgP3GE6kHFXxRPRk4gkMwhuFAqa+s1QqnrHsZup6d0+Xmq3?=
 =?us-ascii?Q?yRi2HBTMSDZRzjE1s84SV3L5SksVYdeh7sySeooaZ+szB1pXAT6kJPCyDl20?=
 =?us-ascii?Q?DZBewJnBtns0yKMte97fP0O2oFCGbSRIrnIso/WKmblDG5yqwgeeKbUBpAx6?=
 =?us-ascii?Q?WhGrSis7jijsQdVUr9eNwBvysPVKVxLzKcBDpK7/phtnwLSHH0IS4uUp5xPH?=
 =?us-ascii?Q?3/5mwqK+1J50qLGT5oOKJpQgUyPCXPweMFGqsIbUM4n2+gR29mkbCdNqlEaN?=
 =?us-ascii?Q?o7PWyrs+CCA+Mnqfba8IH7mmSgcPTBwfSSV2+G755ennSjQxwVbBB98iIq+p?=
 =?us-ascii?Q?0UkWqOlcREs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?s7u5NNsQupILgMYY4AAiuXyVDg28EI0++hDYY8p2SOOo8otW+55vIs7eToin?=
 =?us-ascii?Q?U/OgpS7o5ZcOV3CBVABbYc7+0Vlspn4CM4Eoqy+h4IX3HBo6djVSf0u/C5Q6?=
 =?us-ascii?Q?jGgRb5YYdYN9VhXpRwTn3s2wZm8B70onDXVEGB6DBqSwYxp4UGtQkvW1qgvK?=
 =?us-ascii?Q?hOk73ON7aDEMx+Ps7fKep5RfefVcI1PSb/LH5EF3dHZBkewgDUsrRkmpuhmi?=
 =?us-ascii?Q?Xrr0poLrrwOEWD4HmtUipdrJ44FNWznwY+Bo+Sm+fz60NEfJuqx2JUh17wW3?=
 =?us-ascii?Q?FG3Da3Hxt+5Rtp7NpScMePSKPB1HkVRJ2kWFxvyb86JDI6H+vPLVJQuLzuEI?=
 =?us-ascii?Q?84XBGfevagXeb5e3BSatcsxTQ6V/lu2t5kJzY/ihym+khVboNyZb6f5UaPvx?=
 =?us-ascii?Q?H9xAwWmHBuAYZejXZ5qSQxq6fUp6he+bt57XaJ+4Tz6mHdPQsbJl1rlJZEEC?=
 =?us-ascii?Q?UuQul8a//JH2UgXSiwI9jb/pxB0soHEBcoB3XsFKUJDliVX4b4Am+DJRD77b?=
 =?us-ascii?Q?X8zE0cY4sWpY2IvvPlEMeX6UsBDVl62NkTzhDNrBv0txCp55Ifq01vANUiyw?=
 =?us-ascii?Q?nStkYfAPnP8E75iNWhen/2XO68G7xKVK/N9ff5uckHS8L8vhZeNZ8MNlOM3a?=
 =?us-ascii?Q?ZM+KDXz43JJmO9b7IKzPoD6aeWUOXwcclEt+ART9vo8jcl/RPMuMX+uWMwwB?=
 =?us-ascii?Q?5R7CJssjZ6Yg628mzcW0GUv4t/VkcMwBSvWo6Fnq3uqxe44Fvap8UGTLfjV6?=
 =?us-ascii?Q?UF9k2SCIGg3heuYBfPOFENHop5941AMYOJhmeC7Q23rBUI9cIJrYZsOylPzK?=
 =?us-ascii?Q?AVLsG1KLfndAeMY72kqQVySHgQtQcgpAFMNc1evH4Rnsn+/LNcRM0q1BjJ8i?=
 =?us-ascii?Q?aQm3M3uz4fXrU2wKWfuw82QC3gj3kAqzrelL6uNQOexcsKSXwN/UjhfrUDVt?=
 =?us-ascii?Q?j56ZOCrXiyEA731CtEYLSel7esGNz9JSKh/K4d+fo7wa9tF/dX5Y5LgrdXAM?=
 =?us-ascii?Q?kgV7DSyrB7wSwmfuGjFE0u7A6FWAbNcfcmVYB7J9MPG33M8yXfVLFrEv+igx?=
 =?us-ascii?Q?nfLsh7GbiGaNSp4J/nSaDLT99Lxcn4bCwNBwLuwQRcoTcGxJg4DexuLvocBw?=
 =?us-ascii?Q?c1zATeX33eWm5d1IeVlY35YacwK4UBnAPh0qG4kOsQ9YV3t8Ha4h11vzwQTh?=
 =?us-ascii?Q?qD+nSBDR8HInRykbrCIX4yHWmJnafsAYnwfv4OKWFXf9Fsh/ugNsIAlCM8Q8?=
 =?us-ascii?Q?15s2a0l4dKczLaXekDdn1aYkrALA50EDE5UBOrJqdV0Vzw13w9FCWH92+jWB?=
 =?us-ascii?Q?Jat6FgaI5qzJcA/Ynw9XcVBmaNeUvI3iXV6T7gXivsXP8GqUsr402+edXnLp?=
 =?us-ascii?Q?iROQxMgIWvqQBF7Kdsus1Hesqqem4L2My1eOesZhzsTpzyfeEumnKhbJ7Pei?=
 =?us-ascii?Q?/XahVFIuqCBM872wmN9vDUAtnJguwhZFZacyJJJsK+1exu9U5EzLUp73FOAu?=
 =?us-ascii?Q?ZYFEN3S5Xn0EW4EJDzopfnmPp5CpTy42c3NlcEinYJnHac/ChkG/GyoOigzC?=
 =?us-ascii?Q?8+TE4gpzSkHoKko+k4NGxcy+xXwvTPfn+qWEm0zV4lwxjaU9XcdSkQNnSE0z?=
 =?us-ascii?Q?AA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8rlLH8Rirk3whxROb5aBgCn6LVo7bI4Zee46Pq97Sq8dfk+kT5kckYjEUL0BzwforIqreSoQqlnWvyG3K69zZZILVrv4C7ikXyklUgJD+ieuEpY8ew5ijmoMkU0pWu6mXQXO3MdS8xW+DOmNb9bGPbq/BoBXqdXXzb1XwufizXvDkipmDia0iYKtF5fRgLGhmgi6uCC2Xz4Vt5FKVeHTk1ycNGmB892sPq9RUXJpCu4dvA4JpULnj2xDVEYOPt6M/OJdP8495uvlWe/SMn7x7c9n7B6rsxgngktx7mvirbPKLwQbplDcnFPwnISsviBlVkTNF0ysXkXGuN8Eih2Mhw5JQy+xOg2X6vyyPT03P14FHdj7/HXA9JAcU3AVFqyJYsdqIl9WyTA4hastdF3t6nYC5Ecb7fgrbkHzA0yD72AhdnySigavxJTV2bVUyffSgC1xHdvwjq/Ri2xB5Zv/1q8O0v4vHo1ZBctqQEYzROFc/+UeVJwkv/gUCSMQHPHOox84F0+A9ZsQIrxH9fxz6Vtkcym8fwZ5IV8YGJR6+PFecB3LfOv3pSC8vBt+ErNIVscMVPUGDDzEdvXymLAMCsDkbIveyMhSrKTmlB5+8kA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9363302-0900-423c-7dd2-08dd91df221e
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2025 05:29:29.4451
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IatbCwGRFXO7vVz4Jj2oA9tyyPaGVgq/A7nshH9qF74XgRwXaMqvkJZUSDeby4rlMIweWVEv2jWMCXgLh2WN5DalyPqSVBsVEA/Usk3+B7Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5884
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-12_07,2025-05-09_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2504070000 definitions=main-2505130049
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTEzMDA0OCBTYWx0ZWRfX7SYdRI8WDYRw o44k/73H4YDajpvMLUQ+kxG8K6cGxjXeVzBkH3kQFP8qSN0sStY5JSwvOYY7WTb//OS91XRiObX ZAWHYnJXI5kUnbmSJc+QZvvwWclysS0eLlNXtu12k7EZm86n3n6NtQX1A2dVE38L1d8RJFD0rqA
 S2U9YD79cjGGlD2rwRmgZoLJO+RkYa3kKzVNXQnbj1vEvNxAR+5Re4UEOlo8DKESZ7v8XRG6UGo MHM/DDC0LYXFFoLFNdgePo/mr/kx4Mk6nc9M90NqqX7mS9FpwAgYUYuQT0oagIu26cTXx4dTqJm iYH31TNnw1dqmdDz9C5tTT9eAu8WbZaZqakHn2odTnYFMC1JyHiWhd9aCzqW3TDNcniz9cY8pz0
 BfJz5M7CR6BtZy1TGNps0NAoffOjkHOQw3v8Q/xldK3cw0aEZgeN1HNi8TqMRd+86Z+1v8uN
X-Authority-Analysis: v=2.4 cv=RPmzH5i+ c=1 sm=1 tr=0 ts=6822d8bd cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10
 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=7CQSdrXTAAAA:8 a=uGh1ttrlDttsrxddKyAA:9 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-ORIG-GUID: aN9DnB3emIqRLujnmrNZVBn9KAmqlftk
X-Proofpoint-GUID: aN9DnB3emIqRLujnmrNZVBn9KAmqlftk


Ankur Arora <ankur.a.arora@oracle.com> writes:

> The inner loop in poll_idle() polls to see if the thread's
> TIF_NEED_RESCHED bit is set. The loop exits once the condition is met,
> or if the poll time limit has been exceeded.
>
> To minimize the number of instructions executed in each iteration, the
> time check is rate-limited. In addition, each loop iteration executes
> cpu_relax() which on certain platforms provides a hint to the pipeline
> that the loop is busy-waiting, which allows the processor to reduce
> power consumption.
>
> However, cpu_relax() is defined optimally only on x86. On arm64, for
> instance, it is implemented as a YIELD which only serves as a hint
> to the CPU that it prioritize a different hardware thread if one is
> available. arm64, does expose a more optimal polling mechanism via
> smp_cond_load_relaxed_timewait() which uses LDXR, WFE to wait until a
> store to a specified region, or until a timeout.
>
> These semantics are essentially identical to what we want
> from poll_idle(). So, restructure the loop to use
> smp_cond_load_relaxed_timewait() instead.
>
> The generated code remains close to the original version.
>
> Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
> ---
>  drivers/cpuidle/poll_state.c | 27 ++++++++-------------------
>  1 file changed, 8 insertions(+), 19 deletions(-)
>
> diff --git a/drivers/cpuidle/poll_state.c b/drivers/cpuidle/poll_state.c
> index 9b6d90a72601..5117d3d37036 100644
> --- a/drivers/cpuidle/poll_state.c
> +++ b/drivers/cpuidle/poll_state.c
> @@ -8,35 +8,24 @@
>  #include <linux/sched/clock.h>
>  #include <linux/sched/idle.h>
>
> -#define POLL_IDLE_RELAX_COUNT	200
> -
>  static int __cpuidle poll_idle(struct cpuidle_device *dev,
>  			       struct cpuidle_driver *drv, int index)
>  {
> -	u64 time_start;
> -
> -	time_start = local_clock_noinstr();
>
>  	dev->poll_time_limit = false;
>
>  	raw_local_irq_enable();
>  	if (!current_set_polling_and_test()) {
> -		unsigned int loop_count = 0;
> -		u64 limit;
> +		unsigned long flags;
> +		u64 time_start = local_clock_noinstr();
> +		u64 limit = cpuidle_poll_time(drv, dev);
>
> -		limit = cpuidle_poll_time(drv, dev);
> +		flags = smp_cond_load_relaxed_timewait(&current_thread_info()->flags,
> +						       VAL & _TIF_NEED_RESCHED,
> +						       local_clock_noinstr(),
> +						       time_start + limit);
>
> -		while (!need_resched()) {
> -			cpu_relax();
> -			if (loop_count++ < POLL_IDLE_RELAX_COUNT)
> -				continue;
> -
> -			loop_count = 0;
> -			if (local_clock_noinstr() - time_start > limit) {
> -				dev->poll_time_limit = true;
> -				break;
> -			}
> -		}
> +		dev->poll_time_limit = !(flags & _TIF_NEED_RESCHED);
>  	}
>  	raw_local_irq_disable();

The barrier-v2 [1] interface is slightly different from the one proposed
in v1 (which this series is based on.)

[1] https://lore.kernel.org/lkml/20250502085223.1316925-1-ankur.a.arora@oracle.com/

For testing please use the following patch. It adds a new parameter
(__smp_cond_timewait_coarse) explicitly specifying the waiting policy.

--

diff --git a/drivers/cpuidle/poll_state.c b/drivers/cpuidle/poll_state.c
index 9b6d90a72601..2970368663c7 100644
--- a/drivers/cpuidle/poll_state.c
+++ b/drivers/cpuidle/poll_state.c
@@ -8,35 +8,25 @@
 #include <linux/sched/clock.h>
 #include <linux/sched/idle.h>

-#define POLL_IDLE_RELAX_COUNT	200
-
 static int __cpuidle poll_idle(struct cpuidle_device *dev,
 			       struct cpuidle_driver *drv, int index)
 {
-	u64 time_start;
-
-	time_start = local_clock_noinstr();

 	dev->poll_time_limit = false;

 	raw_local_irq_enable();
 	if (!current_set_polling_and_test()) {
-		unsigned int loop_count = 0;
-		u64 limit;
+		unsigned long flags;
+		u64 time_start = local_clock_noinstr();
+		u64 limit = cpuidle_poll_time(drv, dev);

-		limit = cpuidle_poll_time(drv, dev);
+		flags = smp_cond_load_relaxed_timewait(&current_thread_info()->flags,
+						       VAL & _TIF_NEED_RESCHED,
+						       __smp_cond_timewait_coarse,
+						       local_clock_noinstr(),
+						       time_start + limit);

-		while (!need_resched()) {
-			cpu_relax();
-			if (loop_count++ < POLL_IDLE_RELAX_COUNT)
-				continue;
-
-			loop_count = 0;
-			if (local_clock_noinstr() - time_start > limit) {
-				dev->poll_time_limit = true;
-				break;
-			}
-		}
+		dev->poll_time_limit = !(flags & _TIF_NEED_RESCHED);
 	}
 	raw_local_irq_disable();

--
ankur

