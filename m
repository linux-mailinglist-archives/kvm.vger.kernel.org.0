Return-Path: <kvm+bounces-49451-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 05A96AD922C
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 17:58:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 454AE1891191
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 15:58:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 940041FFC53;
	Fri, 13 Jun 2025 15:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rTCqyjQz";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="eoY2JaAx"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15DBD19FA93;
	Fri, 13 Jun 2025 15:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749830256; cv=fail; b=tU7RclLKi8Vz0eCZIOO/VtbH5QUwKOXDUa1HjIA2cwWV8SRra7teDaeaztd6mhyK4PDFhALeYmf3JI9gFH5sh7UYAWTBpHsyHX9CHKQyOV8PD/CTOJJz/067DwMaKhc3IGz/ykZHGZSyQP4esqUMJVeGzdyQKMVlJX/jeTfE1Vo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749830256; c=relaxed/simple;
	bh=gDwJAwQ5mAVXeirOPb90NRm9BSxwnhlo6feWrWhTaSI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jNjrsSpSMc1TwlwGV/dQgX91I9w9kKWICyeSHEmQp9fD0YgIh579HYupzdq2rDQ38so1WTsxyIOKq0g8edLzZLhwmsPsV9ONYhRwfxPrbi5ujHpDX4lVhAMtsBMg7p5FmrSlqkgeXkzzlCFMG+KTsQDuhqWHRU4lChbRCTrQKWw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=rTCqyjQz; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=eoY2JaAx; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55DCteNC001681;
	Fri, 13 Jun 2025 15:57:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=FVamXHlAGhO+8JB0Zi
	7BSFLpX+yp0YzGXwClr391/2M=; b=rTCqyjQzzY+RR1uCJLIxgO1PtgwHg+w1Fn
	WwB76ekCt35p8fNp0aPRhv/D/wlzcyRW94oO83dJUx16parJ4Hui9uwMYMOIqjSB
	odsyRnodRaYyks3gCLGXWvb5lXGsAYZiweK6mVz96ZYVeoeOiA3iTl2P8nWl64RG
	cXxwmxO1XNP8Ytp/RuIIq8SBgOThEkgmGzwgk3QRj2SlM6iN2XgaraVEThl3hE5t
	T96JA/K6aDCP7/1LZMikBjg0PXfH5ETcDfO/oDkjHkeRMiwg0+7czruEdk5QLqlb
	zoHHFFbTbS/5JnwYwfhV0NonrrJHxtp9J2Inw42hb+1d1KSEZDFw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 474c14kuny-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Jun 2025 15:57:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55DEuL2W040748;
	Fri, 13 Jun 2025 15:57:18 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011066.outbound.protection.outlook.com [52.101.62.66])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 474bve2gcm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Jun 2025 15:57:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UTna3RO0InpQmQdQckWmvoW9HpOFClfursh4q/zE7nQqaIasmgrKusi/f5DDK1ZhyL4dOo3c9JXuechNdQm/248S76S72Jd57JHjD3Fs0K1nMrACnpZTj3c+axmT0cjB3XOSMANjlget7sSRpFbqn/VKW8mft3pHErb1ZG4VglmnU0KIkkh3HyXdv1GXtTG3gwqflM9CaCzYoMlcyl59ahMvw17j3Sgqg8AHCg2N/HMnrYW7GNr7z6XRk6e6zwoQwTzKP41s92iFwlbH7rze86pPvVHC4m0GBGR7hpMwZcIxQGK0hNBhAGLpf9xUutlPgil+Cw0uicvN5ogf9W/CxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FVamXHlAGhO+8JB0Zi7BSFLpX+yp0YzGXwClr391/2M=;
 b=CbKsNGmO3RO1gVrLJzfQv7V9EZEeWp6pz1Wl7WNrkjojZliitguD5bmP87ueYSG+umkHzmOWt/Fwsm6XKG4xf/SbYwKPDNcuKbFPbfz05FUTRhmUy2l8V4Hkqz5Uz/h0bF9qjblVto1f+uDoZnqLoP3xAH0w5IHRqtFngRqXL9hWX7p7jFD8mVVxaoaoQ0mil7hEjL6WzRshSTR8mxh+24o0Sh+1lndgRD1HrV+tVX5b8bxEHw3115rDOlHyL5t7FIQ8GN+xalC9ygP69tazvOJhMCpglaA76uGw8nFvMqI+fxjef0lQmMqfOR7KYm/Dd4pJOQVHGmgrzJDBPaC0qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FVamXHlAGhO+8JB0Zi7BSFLpX+yp0YzGXwClr391/2M=;
 b=eoY2JaAxIwlpxXgo12X5Sl6dyq8h9gIEpVDtkL4MjyqpH3wNexQ+ZWm8P4MsWqutLmskputQPibb1FZBoDD3qN2mqPEyMrbUY+G3fu6GiVEBe99HfCK20GsY3PVkAUOZpf+7GK+/9inviLoJ+SkJMswaHjisxninInIkmhSpycw=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA1PR10MB6194.namprd10.prod.outlook.com (2603:10b6:208:3a6::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.24; Fri, 13 Jun
 2025 15:57:15 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%6]) with mapi id 15.20.8813.024; Fri, 13 Jun 2025
 15:57:15 +0000
Date: Fri, 13 Jun 2025 16:57:12 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Peter Xu <peterx@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Alex Williamson <alex.williamson@redhat.com>, Zi Yan <ziy@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>, Alex Mastro <amastro@fb.com>,
        David Hildenbrand <david@redhat.com>, Nico Pache <npache@redhat.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>
Subject: Re: [PATCH 1/5] mm: Deduplicate mm_get_unmapped_area()
Message-ID: <1fa31b8c-4074-45c7-ad59-077b9f0ab8fb@lucifer.local>
References: <20250613134111.469884-1-peterx@redhat.com>
 <20250613134111.469884-2-peterx@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250613134111.469884-2-peterx@redhat.com>
X-ClientProxiedBy: LO2P265CA0483.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13a::8) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA1PR10MB6194:EE_
X-MS-Office365-Filtering-Correlation-Id: 3320d554-6ab3-479b-e773-08ddaa92f728
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+nve8k37MDLiZeuqhhuF37Zpt/DaMgj79EZauhLdP4zpqvYN9/EU9wtaaJam?=
 =?us-ascii?Q?y9/fTASmV/F2XX909LCijMMHUtxM13WzRnfp1+gvGdBEwX6Sakl1IR8grySm?=
 =?us-ascii?Q?CCIGdJH72DtLAKJVIvEBxqxUeGfKUVHf1W235Z48kch1HGywaZHyUHYggXtY?=
 =?us-ascii?Q?ExQeNRIYIfE66pUSYRljtFYzxJA9WZZwtoESrpDndZjUzTOkqEbYc+1wgvW6?=
 =?us-ascii?Q?ddAwfsDd+T2+ZD3LmLFy4O2uiX+spDyl3NxfwZHgsSm7ysR9ob+S1sSfzTTT?=
 =?us-ascii?Q?JPxIIwV4oM8OXVDHsYPaDdV4rMO16HiYHv5erlk2kFz2VpbTv5gPmf+vFpXR?=
 =?us-ascii?Q?MSxUiJ0WWXadBchRaWxiJhOMUf0ug4D519CKzFc6+eH/MVJd/iFUi+JAcOO1?=
 =?us-ascii?Q?uiRlnuWjMv6MCD4HOt7X027/xOpFuJNwhBKoNzzdhvWY+OJ33fFNwyTvoVK9?=
 =?us-ascii?Q?syZ5bfvmZWIlhdyCpnwyzHTBMrZYvuTRrHJb7jpUvhEbFJ9EbVvVLmTrYZru?=
 =?us-ascii?Q?PlSeQ/qKHgzyQxESoh2Tt8Hv/kMVRD2LDXmwiAbYk8EJYwX+zKaHJaztZUCn?=
 =?us-ascii?Q?kOxca1knro32Qmu5Gm9vig9WetoMxZbpGhfJ/kwkjDsjIA+7E91Ah/FgjbuB?=
 =?us-ascii?Q?mG05VkhCFczch/9t4LBG3t6CdM2qNUQvdewytguQWWvL/IiZotg7vI2zFA4J?=
 =?us-ascii?Q?FTKTRpG1OS//dGHb6QwYv2kYk5A5Ie9yf7LeLBZfgbtnYjaZq+ZtsbP56tyR?=
 =?us-ascii?Q?/wHafkTQUs/UsIl0w4SC+lJkRZbGaYksp4t8tOdM90bNh/SvvwBX5/Sfsds3?=
 =?us-ascii?Q?CKVUrohK9w31DNjGVoEdbu8um/5540m3Gz5gQqH3yI4XCKl/rMLL2Hx0BO0c?=
 =?us-ascii?Q?UuhMhIpkgyXQj6i+dh0X512oYJqdIvrFmn6tIBYinbJsUi4tPY13bwZ3bljI?=
 =?us-ascii?Q?hjeRTB3eggxTl0ryAkUVEC1IEiGWH+OOtPechCamNhoPRn/EwP6VHUGpU7rL?=
 =?us-ascii?Q?0+HWdK1OutBidc3K/MkKjiKfVzVUjEkf1+/Z6Zb0UgaL+R20mtLEefR3k+Ez?=
 =?us-ascii?Q?1cOB2/NbSXzrcAfWGkwRVogpRAcCnp0/VqjYGu2q3KOADWNl5J2TnGf1eajD?=
 =?us-ascii?Q?hsRJxmtUWlzDRLPWfVgbjYKSE+plTkOyI48BTJ0NvZP3z5Jzc4s6DFXbZB8J?=
 =?us-ascii?Q?JeupOECBq77voDkmkz2NsuqvJXA781IERSwFjccR8mNJE+g1Dge89W1E1sUi?=
 =?us-ascii?Q?/7d1Ywbvtvja6SKmiXd4R/+VYjISt/MHVA4fKNJUUnn3jcid0lC+YgCin3jJ?=
 =?us-ascii?Q?161CsRACt8QoxwXCQ1vNSLXz8FlfebOUMLguG+4JkGgEms7uEfdnFbuPM5uP?=
 =?us-ascii?Q?Lo/BwwGv5W6bZ+edLX/hso4R9lu7S2SUHVGxPpAJkDE5mi5kro0EyfEdVQXd?=
 =?us-ascii?Q?Dv3CR2qYrgg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?g06pcuJzzZV5of9qi4xDwFmvOysevv7IiID+1U7ZWXOLsqLCkAHniU1QXT89?=
 =?us-ascii?Q?JGEFEutR886Vca0BLHEEo2IaYJA7IaC+kcV0b0+HG9kaVI/glcXbDkSErF8a?=
 =?us-ascii?Q?ozVG80nNXxEF6pmxZ2ezrinR+yazNj2CjMqXTNVAcC0BCUnm3DhtWXyo4CI5?=
 =?us-ascii?Q?I5Hcygk1PHEMZOUIdW1nmP8fb3MqH0pwmRZ68xQK9Z5WzNhSTK8aZuyh8bTV?=
 =?us-ascii?Q?dlyeSpr61vdDF7YAEXmeVf47UEs87tRchGe/Eb7nrSIW/ThghwaJIeP1Vlhl?=
 =?us-ascii?Q?wigMmIX/5O7qjMPxLQq1I2yX3ghzyQ4OckhKi53WtjOXdJwDckbXISEC8exe?=
 =?us-ascii?Q?n5Sbym9CkmArRbm1oybk4Ztad1XBPnNyJod2kYzUYNoH1ByqoXBGNFHXNCdc?=
 =?us-ascii?Q?NgnpaIEOzdXhTCM4sSklFf7FgbTb7ej+eqB3qqoAA14mWG84VUGQCmm/98tY?=
 =?us-ascii?Q?YvJ5M0GpC/BYa+W5uBHe2B6Z8t5eeZen9VbzQbt0xq1B5R4XvJJdvJQeHOgt?=
 =?us-ascii?Q?gPkaYOdk5YFMMKRkvQwB1escC80PHecbAJZLpylNBJHTTvTTW/tN+bdTbcQB?=
 =?us-ascii?Q?vc2AsV6eUYQDZwjhuEb5iSDdJLDyRZoogSyHkNcfnUNqTe7XDuAdhFr+JQe+?=
 =?us-ascii?Q?ZdgyBvoBsf/vcGoX97W5eQzn6o4k4osOjcgeyKm8dBtIgA9BaNbvSUgfQ15J?=
 =?us-ascii?Q?HBwmqoVN+mxo7NPRO6hWQ4d+KxR6o92Z/tUJR1SrR3JqWXwR1VoR6JNYBlbt?=
 =?us-ascii?Q?e95Ew/X5SHXYwbZZwXT3HYEMpJawHfeoyQyIJf+zq4RR3JB+/JJkaRt2Aj79?=
 =?us-ascii?Q?rJrVPUbMs/PRsltzfhRSXwlF1xjMRWux9kghHlpmpsgo8LxxKzmIgGfll+W/?=
 =?us-ascii?Q?EvXFZ+58o/Aa4FRGfo1G2HyQFENvrgdlqdXPCPuKOxCl2CXWfzBbWIECQsV9?=
 =?us-ascii?Q?jl2qcinaBtUYBRPcwowzoky1ASvyHFJeSZdoTVFlZtMOMataBB9yszILyDPg?=
 =?us-ascii?Q?EkqQYD/nGM5WwX+t3rEZYLXz9AG4gdNrGwvTmMMFWOPglfh2wPlWl+T9pDeI?=
 =?us-ascii?Q?6W3GdgxGDOhfF4l1nGPxXXmeHnwv+VRgjlV7246X7XQ7Eh60sspsYpdGHSjU?=
 =?us-ascii?Q?AI6QoBqJ+SzW9h+OoFATxaAmpOxXUQXxWz/SrI8smMNfmiz1UIUSBaACJbVe?=
 =?us-ascii?Q?nTpAFfeUQosqDQo7fm1gYvHi/byz2p/IL0gGs6uPXMH0AHlVaA+mY87DOff7?=
 =?us-ascii?Q?0/2mdTiBmk9Uu8tRaDFp40SxAErh25h+rUTe5NjMm1/KD1NhQnoCSSfN2S4m?=
 =?us-ascii?Q?DIRmk3s0ESZ5DPY9zosBk68lxEvXJ5vGDW3KURRAXOOrYZJfCpH08zKQ8J5y?=
 =?us-ascii?Q?Lr9zhbbby+o38F4+n2UlWB3nBEfiBJ33JXQPAnkAhpKlQ1uSLVhvZ4hEIOIc?=
 =?us-ascii?Q?e0C9Dd39N7clWbAALtckofVjaQ3WVkms2vp/sikLjBgizQ67rByQZJIkuPNU?=
 =?us-ascii?Q?iCxb0go9pqjo2/+lx/36Z0qWQF/cgijCteuIl5kNkdDDKnixua8edMlm0ue9?=
 =?us-ascii?Q?7TKzosmsA+g2BzhZ4OFYdn59mI1F8D+C0rdXLtsLumWqFsEXOf7eB29ebeWj?=
 =?us-ascii?Q?VQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZIBDENx91q07Ytwg9O+mJi5Jb3OVyk6pIuYsePpYG9uErYGaOJXFPBGKJcgorPb6DatU7xDfLmv6tVMh7DJiaXkvgMQ2nXfgfHszqevpjPhr06FXqbCNhu/ubVQsF+wD1HojfJnEOKSHYi9HZK5pGUvpyn5ZD/PpM4XPSxHE1L/L+x9+Nkd0rmeSt3piiqn4G22FSkBA7TLykX4EKW2UBGSv3ZqvKqHH1BKJmyyVZ6CmK6QVYmudcy4LT9pW43eq/WsAvAu703wlATk1DzgQik0wgaNdx0Yjy2K1PToVGefASQ4X05sAq+I/caNvMhXGuiEiQycSJbhblOLK50pqbFeJjOJVsGmpI7RXYHKwvjg0EVPjWJFr39k1MIsj0iK2uYi0Y8FK7EwwdrkVRsgpF+7d8H2WS5qaeiL6CmLeh7WqIBCStkeqxOaPsjyxPN4SsTEdiRNJ2dAiHC5zo65DFxinPhgOBf1qBCCIDlZeAQCFHHOpVhE1iL4pWrZxK0zZ6CKCga6PoVCVF2zKwYKJkfro/pW8Ni+eTvX0Vw7ct/SgFdej6t+tSOldLOVp9n6gGQ5rhB1ncT/TijRlMKdd7kZ9Eb6CwUh0k/wLj2XS8/k=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3320d554-6ab3-479b-e773-08ddaa92f728
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2025 15:57:14.8857
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i38rnBzUJ4XXs1x8Ob7NkJD44PMad816tBXcRJl8GMR4YIM4lDz6EaFpaRhH3yyXBpMsYOAFYHDuJkbiPQLE3oFADaW2R0qJXEMOPePSoos=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6194
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-13_01,2025-06-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506130115
X-Proofpoint-GUID: 6N4oNxdd7FoBVRFj5gOMu5q9l-YnCu31
X-Authority-Analysis: v=2.4 cv=GcEXnRXL c=1 sm=1 tr=0 ts=684c4a5f b=1 cx=c_pps a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=7vS4CG0ItwCUmWQ338MA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjEzMDExNiBTYWx0ZWRfX4qPjMki0jeYH n6iWmGTCREbWJE46YTi9FoPpphfzLQHB1k9vRN4lzm34TEDiRtbxG0NvGYIB+/L4tyIXLnFU5DD NP+iZugUNaZRYpl5wZ3+UbhMFGMQCw11PTVGplq4dSOneEzQy4iXabXl5+FBpivPFK1VJdlwUFG
 T2ADTSEnWXAQ1nVUXpsrI13/o2cHtzO9o2tnAqy5LJJXYsdd778xIatSaw4+dv4DgLXfRi3npyR hROOdpthBGOT1zAGF/A0n/aL/gzCgMd+xn8/0RN60jJY5W7xWkt+K7vA6Glj/BzIBbElbktwuvJ epit2NHzsrS/QTobIfHxHd6hEQC9hGqiFiCN+DWz8AQtJ+4u6oFOijdnP2dMF8CtbsCg+msYvie
 WmSSOGqpBcvE5g8rvGGb1tN0lpJUBscU6kxKHf/HEUBhJo5lPTP9z+NsU/yMDddorJq3Dh9c
X-Proofpoint-ORIG-GUID: 6N4oNxdd7FoBVRFj5gOMu5q9l-YnCu31

You've not cc'd maintainers/reviewers of mm/mmap.c, please make sure to do so.

+cc Liam
+cc Vlastimiil
+cc Jann
+cc Pedro

...!

On Fri, Jun 13, 2025 at 09:41:07AM -0400, Peter Xu wrote:
> Essentially it sets vm_flags==0 for mm_get_unmapped_area_vmflags().  Use
> the helper instead to dedup the lines.
>
> Signed-off-by: Peter Xu <peterx@redhat.com>

This looks fine though, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  mm/mmap.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 09c563c95112..422f5b9d9660 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -871,9 +871,8 @@ mm_get_unmapped_area(struct mm_struct *mm, struct file *file,
>  		     unsigned long addr, unsigned long len,
>  		     unsigned long pgoff, unsigned long flags)
>  {
> -	if (test_bit(MMF_TOPDOWN, &mm->flags))
> -		return arch_get_unmapped_area_topdown(file, addr, len, pgoff, flags, 0);
> -	return arch_get_unmapped_area(file, addr, len, pgoff, flags, 0);
> +	return mm_get_unmapped_area_vmflags(mm, file, addr, len,
> +					    pgoff, flags, 0);
>  }
>  EXPORT_SYMBOL(mm_get_unmapped_area);
>
> --
> 2.49.0
>

