Return-Path: <kvm+bounces-46833-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3952FABA04F
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 17:52:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0E5BE3BBABE
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 15:52:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDF711C6FE7;
	Fri, 16 May 2025 15:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kW74csf7";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="L4fEVa3b"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2926F86359;
	Fri, 16 May 2025 15:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747410739; cv=fail; b=eDfKch9n3RBZwYRSf4x2bIIzYimW6BFbig0VOPQJkQZOlG5Un6c3qiMx5RC6bv3FeeaHeAQjQlVRSo7Zn8CvAvws5dPTlsjWMcs4HUkd2IU10W4v9a5u+t5brfmVHCmjbGmuakHyyVlS6Vbvmguaia11EqDAeKRXY2SvmTMgTI8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747410739; c=relaxed/simple;
	bh=g40JKI5xdKyGnqXUBSQbMXFmLf62j+4sXFTaaN+E+YA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Nhnhu9eOE2XR7xwSiXVpnmMyMHobC0+t6tS08QKIfZ4yrIU9DluQ7ecVOhiv2zNU6L09VLAtMUrqrkBXsvNMrfO3jPVjTZb3UDdDCHK/MgPa7eCyEcMGk0rckIiKHlYHriBmYy58jPRTMJEyRg4LfWfxeRzGsEqEQbJKSSkJRqM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kW74csf7; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=L4fEVa3b; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54GF0gZ4012829;
	Fri, 16 May 2025 15:51:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=8EaNgjuza4374QJO90
	VjOEW+o8/TmT6Hs8RytHosVYE=; b=kW74csf7hNBFl0A6RIiaShGHuompBHLz5U
	w9iogbDH8kp6YzVVZFA2iEiyrfgcigC1rqEs/5S4wx5cRD3Ugv4xlRcjj3/Iznsi
	c2LEhp6Yr0D91d0+qE/ZsquLeWEWuY+i2nbfEUM224Gi3AKn/76gCgV03pZa1vHO
	aXFQPQzH1OCIcRvl5UbV/u0rL4+Ev/7x/tV3BXxfYcu6gQNYHqD/ngFGcIvYOG9a
	YTf1lma4Sh7VNef9Yu1yZEQKHJ32XvwKePjgX25kYAw1aBA4Z3eeiyaJRe7VSoJP
	PhobXYMXGE9utABm8O8gUVkCEcK6lyqni9gNWLyXN2ZG6kFUw96Q==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46nrbj1p5g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 May 2025 15:51:58 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54GEALDW016196;
	Fri, 16 May 2025 15:51:56 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2176.outbound.protection.outlook.com [104.47.57.176])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46mc3689hm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 May 2025 15:51:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ar3YD36jBLcVEGJcBlLOsftvomUfvTmYDypuEbBwTYHbpZY6jj34W6bb1HFyamoC9b5b6Y/5x6ghI6sj/zE5ihBCzzx+0J5GZhpwcMyo+Api2HmG3zMST0MrSc+FBDNyO8BfahnFdv2ctmxURkZaPgo2pCWQjsHMTp7LnZuYj4ohY4r3MWCfQvILKZui3VLz7Vc1IvacyspkWZmozBZVYQpOrOvQ/dhLxq4xWHY63iH3cPoaxQahnhsghTfUJjogg5qcugxcGuBzQmdLVq2h08Do5bAiMhi7wUbqt/LCSyryul8Q9GBD8HB83tc2kiAQP5toqisUqj46hZz/teh5Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8EaNgjuza4374QJO90VjOEW+o8/TmT6Hs8RytHosVYE=;
 b=XdwtVqJw24aP2up5iwNx17IQY7bnsVqDR0jZYthbw66DxRFOSP9yYbY8IfHYtAqr546xp24VVNThU20cPdkcQCH0q61wrJtdZg1ZdZ12x2AUbOnS/Mg/Pery6OYD/FsGCt0Q8N0cfcDM4m8TbPK2z3ikEV9Uiysaupdmqwbb41mrXDbEOszf3rFKXfTNAMk8DNg5O+eQDL2SrQ4S6El1IgvQOGd3yxtWZgtoiMQJwq9XobRy4HeORpx1fTzW8A9L3SAlMrfdz84Jxg6O2heFFFcDm+Pb+vc7RwzJ05h7wViBz8cnzCGFQDMt7teBPN6H6tOfB24LveXFzIHsn01R0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8EaNgjuza4374QJO90VjOEW+o8/TmT6Hs8RytHosVYE=;
 b=L4fEVa3bTOQTLms5Ri4O1hck5LDd3cccnT4XvbCjgRqAdRkatRKWVSPH0tGfqUkMdTCAMgV3A5Gt5xjyUCUbjNOedndfDSoKxwRnfgT3vX3xE1aeJzaX2Qvspwi1C2UofrIEgz/8tACTx70ML++gspJb3OSnOqmnn2ggj3vGsfg=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by BN0PR10MB4854.namprd10.prod.outlook.com (2603:10b6:408:123::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.31; Fri, 16 May
 2025 15:51:54 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%6]) with mapi id 15.20.8722.027; Fri, 16 May 2025
 15:51:53 +0000
Date: Fri, 16 May 2025 11:51:49 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
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
Message-ID: <wwrdo3hxss67duax4c2hcfunf2bbzuks5bg3g2pv6yfmtf6j7j@daw3b2axl44h>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	James Houghton <jthoughton@google.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>, Yang Shi <yang@os.amperecomputing.com>, 
	David Hildenbrand <david@redhat.com>, Matthew Wilcox <willy@infradead.org>, 
	Janosch Frank <frankja@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	linux-s390@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <cover.1747338438.git.lorenzo.stoakes@oracle.com>
 <3f99d6bc8cd1e78532077adf8b26e973d325188f.1747338438.git.lorenzo.stoakes@oracle.com>
 <yye5j5syytij2rngpxgfxcgusjvtrtjdwqgfxnsbbxc4bibbv7@7gnw3kztmvns>
 <ba332040-cc8f-444b-8091-52bb6dba57e3@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ba332040-cc8f-444b-8091-52bb6dba57e3@lucifer.local>
User-Agent: NeoMutt/20240425
X-ClientProxiedBy: YQZPR01CA0052.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:88::21) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|BN0PR10MB4854:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f98ddc0-556e-484d-64d7-08dd94919428
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?XTJHQBllbTha4eiliHsFJe+fzgZZWjEhbek7YxxM0l1OgKxnMud/z16GkJQZ?=
 =?us-ascii?Q?/lzNA5knM+8UdHIAiU5Xugc2wcF61HOiQ3MhxnvR1fm2cqVAIzGJLnFzhw0u?=
 =?us-ascii?Q?TVVmKj1xbw8Co2ptXEcywZ1ynXdd5aCvKJeb3V+TJCGWelPmQ4kPP4Pu0ZUd?=
 =?us-ascii?Q?F9i9LCpl9aYevUYhO/z+G0m5R+1/kgPoCj7VZA0LFpuOulf6/otKm5fx/7vj?=
 =?us-ascii?Q?NWWsVTU257fFnB2cdfYifU7ozURtLxTC9r/M/JbcjYqKOLYzsKJumWruUiWy?=
 =?us-ascii?Q?fJ/3aOdoHZ5xNi/f8hJj/6C5yqCil9owEBPouX0xWXwTigU2sBc+S3stsycH?=
 =?us-ascii?Q?4YRKP2OJXw0OC1Jd2+mOWBkdJQEVyiOMb+xs8s/UADDdF9wsLP6BxrTZMnI/?=
 =?us-ascii?Q?JnjE1bVMPoAQO2F4FPlulIw9swvB0ffIxlgd53EM0xRf8eR0BO0hPPOexAU7?=
 =?us-ascii?Q?l08oAKM3F5GEISJJO7gydKX3TE4HQcKIuKiw+BezvTF0uEvnuaRZ8PWhrcPj?=
 =?us-ascii?Q?W8jw8FtFtPwolAaorT4X7rjISXmulb2ihK9cSpVxf+hQVaNmRfaVd6YalDkh?=
 =?us-ascii?Q?pNZenhGPkhc8637JEaU9C1EspDDL/w9RdB+OxCzIy2hYYmfDQB6meuQoJssS?=
 =?us-ascii?Q?dq/6hhF8ROKNf++BuRBDwUjJmK6UwJS9ZydLjWiX6rIuZtEV7aHPX3LgWy5C?=
 =?us-ascii?Q?C2/ReW653+hCuAZ5iIJz1opTS9tzPZaxI+ELPKCph99r3HkM9UoIJAsYk7iB?=
 =?us-ascii?Q?QNkoTj+8/y4DFiSF+RZC+3oQXVIt9dvIQC6GSWflR1Sl4qop/XwcUJJ2YCns?=
 =?us-ascii?Q?IiZOsaIYN8j1yo7xSB0dq/O2RG0kC43wMcnFnJpVtEdzTo6s5/rPTrbHTgUY?=
 =?us-ascii?Q?6WsxLOu1CC7LXHvAnRfa8h9sGExFG6YE/0NNKmmtz8P0zRZHs/7XfQNxMuJ8?=
 =?us-ascii?Q?1hj/YeOPqpP+FXiRsRscC+ibEmEAb+NDLjFZtBNRFnLxB9Rfc+0s6PzdQM6c?=
 =?us-ascii?Q?3tp0EeUkpncqS/8290HjbTltK5k0CEfjTVqNx/B5oXqObuPRM4ZxndGPG5Z6?=
 =?us-ascii?Q?F1UVZ2f59eQTXynX+6aWMUyZRonEmfq7tsx/WA9MdrbevMpdQ++BE2zIqae4?=
 =?us-ascii?Q?BKTLljL+DcJ+0b4lGH15SjWu3LyC1H/SsF7VNsQtn9WkjR0sLgAq4zCKYXcF?=
 =?us-ascii?Q?+K1PLHHU999tcgWFZP+QAcTCgMmkYNBGpu40xiSAevzMBEWcBRZCqNNo7MUe?=
 =?us-ascii?Q?c+CENvLs8bUw4jPK8PCg1kw5YGIHbViaaC5g6ftFmcI2IV2/EX9jeae6y74V?=
 =?us-ascii?Q?eigSOXlQmxchHC/9puaYOqDUpvmWPfhL7zjv+SBCv2q79wD+rSsU1ZEHHEtF?=
 =?us-ascii?Q?o5DDXtIxxhJFpv+jwmSAsqt0KyaBi0+8PGSbMDOQbES4i5A/KppogB8kB8af?=
 =?us-ascii?Q?j8lCGqAy18k=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xBqbFNCbyOMW8uId8Qq9Ju7aQDtBSkCoDmPTSC4sUNS79GRTHPnWdTbXpkne?=
 =?us-ascii?Q?3P+YVqJX7/kWDeADGtG8EIwrznT2Sf4dSOCqngJqoPBawfaQMjl6NZ7bKHvy?=
 =?us-ascii?Q?wj3nx6jlpg9oZiWYIhnkNiAH2DErGRXOGikaobvfu1srGMPmRh3L5covJrtq?=
 =?us-ascii?Q?P0vaUtDwk4YpmJQ2FDvsX9ejEL9QqA+mWC5Dk2Kv+aFt61LgfEKuII8zlahZ?=
 =?us-ascii?Q?1J+sXJOgVo9IuWbI6txXMhU295lfr08O7DvTrCGt+Qa2q9U+sDjqNxsvyXg/?=
 =?us-ascii?Q?3u3FmO+Vglw/HtT5DXPbctHzvVSFiZweyb/lc0bFug94IpqjARy4AOjikOWG?=
 =?us-ascii?Q?n6BtP//rWRS3gg8NTsYuMzaT5LFbb5fkgBRtu7eFY7CEhFOEBc6oIbLPQ3vU?=
 =?us-ascii?Q?rf5S9S7NFFkJD7hrnRlkGDMsnRKI4zISKf6Du3UifhtumTY02/kRL2FW5nH6?=
 =?us-ascii?Q?pM99zefX2xR+w2WJEpe5zelTHEMKFklQloA7aMSbzRD2z8DT3i/aXPH9+jA5?=
 =?us-ascii?Q?BUlEgaqVJPbk0k3tOHif0atwPZoxE3EQNAt0SD5Ooz/+kYzN7EG8KIwGlra2?=
 =?us-ascii?Q?nG3Wg9TDsY4jTd/KsUxrHSDQbkXiKbk8gnZCreDNyhIir3SBuJXaCLbPPtbQ?=
 =?us-ascii?Q?kfJES2BYl9Kqv6dnl4vGCRiSZR4hHJnSsi4gp1IA9OUSlT0DAacbOy0rM5Ja?=
 =?us-ascii?Q?ueslf542HSK1ZrjGk/jsdSKOVpd58Ekub6YH85YgOjDXVL+rmsO0DdRqllHf?=
 =?us-ascii?Q?pO/Fkgm9g0beapDg7d7/sygw4V5GY2MOB9I4YVr7gsvLujtMkbaHy9vdlT+f?=
 =?us-ascii?Q?CTEE0qxZ70xZYk/fg7kZRkwL8glOG8BVlZXZqdo7HN8huRHF17ryNaETSX7V?=
 =?us-ascii?Q?crArfqCboZYZtnrOlnUujPoN8mIZ+RHeDPTSRLyOVhlwXeVmFWTb1bWY0Jz/?=
 =?us-ascii?Q?tDr+9afZzwNhLmu2FH14lcbCOkobl1xIEwG1EmanKVWCEfXF6Z1T8t2+1zPe?=
 =?us-ascii?Q?fVy/AL6qQo7FOug5yisOMSdRqqz9kKRD3npe55j6YPKej2GSYt1hTlT/om39?=
 =?us-ascii?Q?7+BHEItZO2kRvMgx7BNrSIcDfAdRndLVph88KukL0QE4XUJ24qmMc0Bbw9io?=
 =?us-ascii?Q?Wl713KixjNDI0NslG+MfOUt1okJWk5lMoxI59pRUlwDib4QtB7rmtsGMXX3Z?=
 =?us-ascii?Q?Uyi5EMo6/jjErU1tBoDVxvv2iYbh9HdRYeGTvK5GWnIodX8EZNTehJ2Z6XIN?=
 =?us-ascii?Q?5lcpKM/aSLy63Kb1/2tLNvlaqNM749ni8Ml3kQrTcKksfbxubu5RqFca9DMt?=
 =?us-ascii?Q?nTgBQNqmgz95i1ZxMjk5UQjxomKfiMPkkJJxFrG+BWrVTYjXh4PhsmkvHQ5k?=
 =?us-ascii?Q?4nSit3XO1UfniIru6ZAKab+XE13HXVI5O5x8BwdWhHKMmGHK2z8uz3wQW7xf?=
 =?us-ascii?Q?rVjYy0JWtxEcGNcuqNqytrtScoFXAFuw/YAABuVtBDck+7ax57Ex8sX1lZev?=
 =?us-ascii?Q?aLG1SvW+3waa0YBRJ7TmxLAKhzS8FjtGID9mFWw6uUvJo6eAbteneQMmtnhy?=
 =?us-ascii?Q?9yiEWjONsXlklfSikENshNrtPtnIOpwvviBe3kOX?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ednLziCOSP3zKJor8zhvoRskmyFIaTh6y/M87k0WU3djvvP5Az9HUQXfa4ABgGjsNKXI9/cxbIVl0rni3AxlNWLPQdClD1BfMcj7stZf9mVf5xnwobUr5j45q5zpwn+Zl5gniPRwp8SLJJWsDwA1plV9n7KIET9HDObwpiWCpf0ZcK11BKXPEGEREg+2Bfo96cRzXbu72I97ixJtYGhbY99ZNfaPu0yO1gk4uhePLHzWv1QqnKYBjcC4UoCPfvkaVwKHlAH6wsaVd+KL+nCJGzxOHaQ0jfcCal5Uc4cykzCPGVIS+zB6/wrJQ0EbJCM2n14ZVUk3BCFrfPPnoBV91RhpXgOBNFVXMOxtRMTAt+wU6oYeunH62+8iIZOOhC1bn9GNdkMWmYneG0yQVKOfyX66V2+O8yRlRh/giqz4/7hrGhDXaXhXIQ2m/wX+NyVK7xSSW5yugtjm3wd9xVvM69ihoSPH0wUQ5r01XTEltGDsZrK3qtRRE2fvfTc6s9ZFznZXM1LLKb1kOt3F9aOVZxnXNgPNp2/OFqxjXA8qZ6pCiIzysaPAJeH/PUKFoFk0ljxuBA4c6SqK7A2gsQhYJaZwwJCnVXba7i1AIBeKuus=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f98ddc0-556e-484d-64d7-08dd94919428
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2025 15:51:53.7387
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pkOOzv/rqTYvrgisYXADK3IMc5A+fM6sllKzD/qXyjniMIjQ3XMFC89W1kVW9AKHG+xVbbtG1BgzwFuifDUD4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4854
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-16_05,2025-05-16_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 spamscore=0
 malwarescore=0 phishscore=0 suspectscore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505070000
 definitions=main-2505160154
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE2MDE1NSBTYWx0ZWRfXyHEFY/JazU5I MTNS42suzTgKDI6pXcbIMIDPMrR5BUX2F7wmhA3uAwcsQHSy3QL3w+QoFFEfx1KUp2yO1mGnduz w5HtWa6pHyV5FvnIt+7vCIHwiKtQabJXcvhATzEyo2ruXik+GbyUnC7Fr/u6iT2xDS+KE1UQq5/
 yd7nrGzX2+7rF5vq8nuLpVBLjbgNRGSxYDxPm89lvFOaw3sSUzive3xpNQTmiG1wNCo55H8Iuqi lPU1KyKtpxthkFruS9FuHhnrLCD54dzAQv7hervFjG/whkNTBrvWgZWIW4cOk+uDgmrE1ZhsmC+ tX+T0u8R3ph7iVHbj3UtB0rcVnQBGIHiANbCPB4ULxkqwuF8VcjGcbywtiX93oZVa4JzRS6+hD6
 baYjeddVd0h2uukH0hAaRcgkkKt3IZBnrC7V+q2FnIWrWSA5iBkoWldssih7x8PMxZNvyapM
X-Proofpoint-GUID: lIAtqAd6gl7by8auveKsRsDbvx0-SDHT
X-Proofpoint-ORIG-GUID: lIAtqAd6gl7by8auveKsRsDbvx0-SDHT
X-Authority-Analysis: v=2.4 cv=YqwPR5YX c=1 sm=1 tr=0 ts=68275f1e b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=TAZUD9gdAAAA:8 a=JfrnYn6hAAAA:8 a=vzhER2c_AAAA:8 a=20KFwNOVAAAA:8 a=m72z0NeWfSkJxj5JZ2AA:9 a=CjuIK1q_8ugA:10 a=f1lSKsbWiCfrRWj5-Iac:22 a=1CNFftbPRP8L7MoqJWF3:22
 a=0YTRHmU2iG2pZC6F1fw2:22 cc=ntf awl=host:13186

* Lorenzo Stoakes <lorenzo.stoakes@oracle.com> [250516 11:43]:
> On Fri, May 16, 2025 at 11:40:23AM -0400, Liam R. Howlett wrote:
> > * Lorenzo Stoakes <lorenzo.stoakes@oracle.com> [250515 16:15]:
> > > From: Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>
> > >
> > > VM_NOHUGEPAGE is a no-op if CONFIG_TRANSPARENT_HUGEPAGE is disabled. So
> > > it makes no sense to return an error when calling madvise() with
> > > MADV_NOHUGEPAGE in that case.
> > >
> > > Suggested-by: Matthew Wilcox <willy@infradead.org>
> > > Signed-off-by: Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>
> > > Reviewed-by: Yang Shi <yang@os.amperecomputing.com>
> > > Acked-by: David Hildenbrand <david@redhat.com>
> > > Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> >
> > Nice to see you review this for yourself :)
> 
> Haha yeah... this is a Lorenzo-getting-confused-by-kernel-process situation
> again, this is 100% Ignacio's patch, I just bundled it up in this series to
> enforce ordering.
> 
> >
> > > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> 
> ...But of course I did format-patch -s so I signed it off as well :P
> 
> At any rate the From: field and Ignacio's S-o-b should make everything correct
> in the wash. I think.
> 
> Andrew - this is Ignacio's patch for avoidance of doubt :P

Oh yes, I missed the initial sign off.  I think this is okay, but maybe
you didn't need your own RB?

> 
> >
> > Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> >
> > > ---
> > >  include/linux/huge_mm.h | 5 +++++
> > >  1 file changed, 5 insertions(+)
> > >
> > > diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> > > index 2f190c90192d..1a8082c61e01 100644
> > > --- a/include/linux/huge_mm.h
> > > +++ b/include/linux/huge_mm.h
> > > @@ -506,6 +506,8 @@ bool unmap_huge_pmd_locked(struct vm_area_struct *vma, unsigned long addr,
> > >
> > >  #else /* CONFIG_TRANSPARENT_HUGEPAGE */
> > >
> > > +#include <uapi/asm/mman.h>
> > > +
> > >  static inline bool folio_test_pmd_mappable(struct folio *folio)
> > >  {
> > >  	return false;
> > > @@ -595,6 +597,9 @@ static inline bool unmap_huge_pmd_locked(struct vm_area_struct *vma,
> > >  static inline int hugepage_madvise(struct vm_area_struct *vma,
> > >  				   unsigned long *vm_flags, int advice)
> > >  {
> > > +	/* On a !THP kernel, MADV_NOHUGEPAGE is a no-op, but MADV_HUGEPAGE is not supported */
> > > +	if (advice == MADV_NOHUGEPAGE)
> > > +		return 0;
> > >  	return -EINVAL;
> > >  }
> > >
> > > --
> > > 2.49.0
> > >
> >

