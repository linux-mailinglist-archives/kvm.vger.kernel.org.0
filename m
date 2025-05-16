Return-Path: <kvm+bounces-46830-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 42EA6ABA01E
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 17:42:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 41D513B1578
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 15:41:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1378F149C64;
	Fri, 16 May 2025 15:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kEmtWH9Q";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="qohQFLrg"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F7AF7D07D;
	Fri, 16 May 2025 15:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747410106; cv=fail; b=tcZGO5tXe+cY2xmBerOznTRaH0IWXXg367Fj/fuvlHYxFUCzyXMNN7AXkrTt4iKZZcIrQ5bimI9Int0xgccU55ZmkVvVxPYi8poykuk7O+3WmqrKrnvORg9CRizpEBbQM5pWdh9qDJy29DpQTkmPa02QBhxKG3/K1O6Z9oDaplo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747410106; c=relaxed/simple;
	bh=boAdoWlsarLx2iE9g4mB73+mecNQydrK1N9hHHIIDEw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=n/9kpx41hdge6Mpi5cjgRjozJxa7uIEn3Q7i3Kb4kkBiEYc99BsifDYq2wffQHIWMOtLffxZzq34cXCU8wn+K3Gihf4Vb3+tsSo/xAbZiB10ingkwpqGY2OdDthapPOf5C0lHpa2+9SYxDfjuHBUa7cMTThEfHeNJ1f6bRkp8XE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kEmtWH9Q; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=qohQFLrg; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54GF0i5b019984;
	Fri, 16 May 2025 15:40:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=qR6DLg7p/xsB9V1nYM
	xorGdB7dpbR8vVPV50BATcfwQ=; b=kEmtWH9Qq2hRa5ME1PIrs+6rdwqVM2x0SU
	62bEA3/Z4f9p9fKMoCLkrXp/rnQX4Mc14DjR89sh53Bzpm7dnjfWm0CsCjhCIhGg
	uEoTsLVjIIdZym/1VNuW8hZSghVD9tpgpoJDiMMxyOcK0woQNFacnUOrInLpEosd
	XhWcM+GJ9RVjPIcGuGyb9DtBdBLyEW7rYqSAUSrDVHf4ejzOR14DpooF5p5wjwG1
	hmja4dFzZHuTaxkLf4QZ2Q3KT8sp8N/aN7uIFpgncV7/gO6PwA350VWTmAxpWhbj
	ik2897kPWoF+pXcyQKY3ZvBHwFeVGmBolU7eKMO7DrmgWsD0JDsA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46nrbh9kwc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 May 2025 15:40:31 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54GE4P5k005033;
	Fri, 16 May 2025 15:40:30 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46mrmfgvhu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 May 2025 15:40:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EY1G5hO6ghwK59YAv6kC6sPB4Aqu9nh97fD2mJ+xyCRzLchYln7TruWpfg9kKfQlk0KM9iKSjaxOGK8bPNkkvb84oO+ysRTQo7BGTIZlrekW4mx1HahV+/nFSpNTu+p1GgNuMFLqZXdXvxruBe6SMGhasHEvl/4ztBqmBhiqwd3F822a125DAgJJDbJGq3LeG4uPkPl1WGCn1imeLYMERbWKhTfxtebhIfgeMzJfB3vihclaGbsoCDrhpi9ns0G5VfW5eZRM83N2aplyHQfpsmY6dk7PDDc/V4VkstqCv37zNacr7eccO5PwmSvHjG2E3+nPx/34Ab26Y2cW+JyFFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qR6DLg7p/xsB9V1nYMxorGdB7dpbR8vVPV50BATcfwQ=;
 b=CsfqFaiFN3AFuyPi54J9cxyFjD3X93Jiuu4TXQjhmHzwyvSGGfcUU3KbwepsotLO+4wOrw2MWROJwR5xrtiEF/wo/Xn8g4rlMdasJ60Wh96dVPW93b7kshwSqy/ySG2R1nnoaEV1OS74mk0FBHEzbtCzLxPuNcYkbpgkjBG3R1Ip8YwRft0e79LrJ9/i1Njs0/g1oo+mpnSMkG2ZyIu2kRKnkCtTTRlC9pzC4a8TcPBcwxiDOH9FHv8DHIy2ofqk7eX6dCvsDsqu3e7Ra663O60hCNKH48sfy3PZ8euTskcHlOpkoD3PMzXdnykaYilCKV3C+iAKJfqZ5zBH99QrKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qR6DLg7p/xsB9V1nYMxorGdB7dpbR8vVPV50BATcfwQ=;
 b=qohQFLrgJXSrr9Wpn3dd8CxSaRpWsHX1SfbvYUEuzeZ44qm0PuEyetC2FceRqRwI61LGz06yK1qLFYS4myYn7mGxjkIjm12TVBgUCbDN35BvfIFilrpkOwsabShyOxKZ1NFmWe3sZ5WChRfRwWLS+Kg2kLi4I72181kLRLrMw2c=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by PH8PR10MB6477.namprd10.prod.outlook.com (2603:10b6:510:22f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.33; Fri, 16 May
 2025 15:40:27 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%6]) with mapi id 15.20.8722.027; Fri, 16 May 2025
 15:40:27 +0000
Date: Fri, 16 May 2025 11:40:23 -0400
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
Message-ID: <yye5j5syytij2rngpxgfxcgusjvtrtjdwqgfxnsbbxc4bibbv7@7gnw3kztmvns>
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
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f99d6bc8cd1e78532077adf8b26e973d325188f.1747338438.git.lorenzo.stoakes@oracle.com>
User-Agent: NeoMutt/20240425
X-ClientProxiedBy: YQXPR0101CA0025.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c00:15::38) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|PH8PR10MB6477:EE_
X-MS-Office365-Filtering-Correlation-Id: 85529d7a-80e1-4689-a97e-08dd948ffb48
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DtgllJp7pPBAmDGD+ckVVDzCuJ+TJ11AVShwY/19lkWtpGnyGa80NBhbY04H?=
 =?us-ascii?Q?gaROxTYGS9Z4+Aip7PLtxlFKor7ARa7CAnLbN6r4jiZs/MCPKto2ERWXYJDy?=
 =?us-ascii?Q?8aMZmpmapM7hGQIGkU/XcLndxsSrWLC9nIURx1XUpAulfqYAce5ZXGjTFo9N?=
 =?us-ascii?Q?96st6l/q9x8VuqPEGJxoMQDq1eG9hQKHnIIkxIPPz2QQj6QZmRnobfT6SyNW?=
 =?us-ascii?Q?ptstuIU+fZc+KhInXWf64JX5Z6ItRFmppSqbqRFexT4fJRrOAU5VsFead/jD?=
 =?us-ascii?Q?OSe8zSK4Jy0aFF9xDq5plTNSNnUMCw64ZqJHEcoS6u1g0oG0mgfZK+yqVF4S?=
 =?us-ascii?Q?M09FysYDjHrAN3fyH0x37EhzYDQ+7/mL7xifapIEqTdBIV47Izba1Hn/aHH+?=
 =?us-ascii?Q?3nkbDxPSvSzle3vk1UcLl7GWxdf0EIT7amN3PONenvCFQysfL+liqUDHd6Za?=
 =?us-ascii?Q?akHPj/VdKTCa/+U1f5hKSCDbYzFeLZA+VvTYIStkZY/8dd6GDb48MT1TAFiM?=
 =?us-ascii?Q?FXYcLarP2npPBlwv1ly0tCd8s6pndfdWTkucbtVWDRRV6C6lzazYRFLgLx60?=
 =?us-ascii?Q?SFCag/agzEj4J4jdjNDKHUlKuO1OmjW57CiFMaDcoElTYMe6CfEor2x5ad3t?=
 =?us-ascii?Q?9Of9dj7zGp0xi1FgLk/4A1FjkVYjkOwf0euHt+Q8KL3rUp41WYQZdg3Q2IzS?=
 =?us-ascii?Q?snnKlo94WaQZXxe9LVxjw9PNEQWUvPXTXF2Qao2gVklbZumn4NzB2Xy+8+Oa?=
 =?us-ascii?Q?yaij/CWGJW4h6UFMFVnlV71X5EbsBaa1T5Ak6TLB9bE5aOr5wG3kLdHj06T6?=
 =?us-ascii?Q?7umFNUuiCr6UYbX16Nq+az2y/5gvsDEPqqw1Fq87wD7tT8sVd4OuKJVGhEl1?=
 =?us-ascii?Q?Lnm68fNUrlWKkbCauCS1tWIPBL4e0B+EDV8G/FLaRfo3VUdsGOY5Mscf+Uf7?=
 =?us-ascii?Q?Pf1gc74/ulmm5J1zDxhjhZ67Pv/GtV2SkNiGX6jez0xyEk8D78I2PAM8IZKN?=
 =?us-ascii?Q?ekYnIsikpiWVf9t7pRUniqN/JxbBcLQMjLqD07DUQ7dCOFmZwUReyC0YCAIW?=
 =?us-ascii?Q?/dGAjptJ3MQfVYF07y/NSu7EufiNBoOAw8Evrz3U4NYLLfNcOOAvkfZ8ULSk?=
 =?us-ascii?Q?e9a8xE8WHIpF5VPxlLbJyJjHxjetc231DFFfDmyr2ktHUI/Mf6aO3BGS5PR5?=
 =?us-ascii?Q?EC0T3AG7eDy++8k3D3POqmciFfzAcGU1MzJlH73gGbB9MZvE61H8p6oXTTCs?=
 =?us-ascii?Q?/cHg/EqLr/KyXng9MxuduaK7p+qaRHAc3scNA/yD5Vj24xDSpZxlopSTA8bR?=
 =?us-ascii?Q?vPZEde5E35aB4X6Du80m3lrmxshHjbWY1nzH3z/UpcF2bKZTbc6iZv5pXs0w?=
 =?us-ascii?Q?VQWMYlquz/SPl6JdliPy39rDYHCSgQB34eZpZgIKGbj94mx1PkcFfqk0N3su?=
 =?us-ascii?Q?NsqtV1BR8bE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?e7+z1kW2pwC0wP451ZMU+bldBOhNfnyBcrOqVu6L1dFhxkZmM6aIuXYUCFIX?=
 =?us-ascii?Q?asF8PfJRJcElTvjeXt/AdUlY+m22VDMpDVYLKVM9jZ6rIZgqQMLMoKmUh4/w?=
 =?us-ascii?Q?SS1wV+Q3DdimvxdLS0sAe67djsJeHcqcFzsdlWAthxqDA9Oz7p5uLTdWpgGb?=
 =?us-ascii?Q?8stnVDG0XH1NAc5uGuokkUJTSu/D583T5267aNaoX8rUryY6FWtzr5Iy7Cdw?=
 =?us-ascii?Q?D8dknq2ocw9VMhKo35DEwGsiMKy8GWD7AKQmPbk2y+hvuf3slCUkjxa+PqY5?=
 =?us-ascii?Q?huj12xRpD6yqM/oCne8WHDoRqCaNcOcsk/wj+vzzevKXf2V95RzJrMEkTxCE?=
 =?us-ascii?Q?cVaNeUALhlgjNxv0XYCGgIRJjGWPzFgtZ3j7f9Uo8BYF+cPCPM809gQkQirY?=
 =?us-ascii?Q?c6BjSBkWoTdgVFQZif4Qp+FwTODhq4ua1ooHe+KxmbcOWJDcZR9b8f6vPiGi?=
 =?us-ascii?Q?oZYzSlFtYUUb8uehfNatv1RooohJZBQ3OMzbChnssRb0xlPWb9KZVXVrA589?=
 =?us-ascii?Q?OnhlZdLg+DNQYlRcxOFbzpKyUAKGt9eM0mJ+Ar+g7eeLMrZ5T6vfO7h2M+zL?=
 =?us-ascii?Q?EJ67XgM/1dAwWaVVeSVzOjhu2y9XT9ciTzfaC6aU/OIpv3v0P5oncjhnwC45?=
 =?us-ascii?Q?kl4zGAxAygrsFdTfWILe8cl49qnoWrXETUy5/dvkoL/2jaztJANAXy3NvJDP?=
 =?us-ascii?Q?qX3smiTxdX3sK0hecXJgpwDpF6Vvt8St5Uuv+/11PKkZ123Cu2eGSe9ReWUq?=
 =?us-ascii?Q?wAQ15Tv8/a3PUOZgMniC9B/1il0IZdCCmRAEqJ2X1qA1Pn/oBoaPpAUEENhi?=
 =?us-ascii?Q?q9WJ60nP7MSSulezdElygmyf2wkWlSGA49PpYP9TJGNWE0P9SKb+mnlHQBWg?=
 =?us-ascii?Q?FWSz3oe00B6lr+uscjRI8d3YprsfLoo32mRDJMB08zExW61TrXVqJz/yNfn2?=
 =?us-ascii?Q?BZ6jGNSIXvdTD3CrmNjS+YJnMLDB7YKxqPC2dEGC1fJZkx+k/tieNl31UtcN?=
 =?us-ascii?Q?sNwCRYVBjYQjMrRK4mGmyLVAUG7joTOeR69m/kW7XsfZ1PUlRoAl+IzCWRG/?=
 =?us-ascii?Q?6CiAQKCqU0qBg3MmmotIbbV5RTFSxj2aIeeO9yxAasS+mMrrcIVbU3H/K/GX?=
 =?us-ascii?Q?gBzeA5MniFndLF44RHHKBbF/IQlLERDbHKkOfgyArxb+ObxM78xkWvSWpJVd?=
 =?us-ascii?Q?xYkQczBa2yGY8j7WDvfnAm0jw+7AQw8ZzJod+RN6itvPZhH5fuLDGiMOwYEt?=
 =?us-ascii?Q?daJklJJGXlfON/S05xZTOcAWZamdYbARHSuCmOdN0l1KI53Fiqf4UOBOyo/G?=
 =?us-ascii?Q?bNW2bGnEeZ3skTq1wsqT9AzjPuVsoj/NUu6dLHYD4CfX13xNmi1HUu8/MHUH?=
 =?us-ascii?Q?vCyO5zQi80jEMESyOQCEU2v4qAez6bdvTLJqlyjqyg1pilOxLNd7EO+WHiH4?=
 =?us-ascii?Q?DW7+Rs4sGeZj7goDiPZre5q6UjMFNZIKfh40Vl8eLphfaS8om15TafmT39rQ?=
 =?us-ascii?Q?QjPP135IuJxzQt1TDRnR1yh2/10XOenuj+H/Rqy0SF/nbgAwoW4CiMEuizch?=
 =?us-ascii?Q?VpUDJWT0H3HnMHlOd/Fj45HIPbm/zZaqvrVrQ9mU?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	DZIZGECxp1P0PAWi9OWK/8T6IH6BCJK1bsSe5/l2aZOktRP4CBpZ4xBu0G6zWCQV4pAW5vTerVVnN/RhV05TznxhCGEgvHT6nVENnUf5RAFa5b5bN959R8YJscPNQgjP5SWyGJGsMBMiyCzunBygx2jvMCqAIR5Rvxkag3UbylOwvoNIvkQ8nk5P+n4u9H9uh3DMKz+pdr4ukYSQvqtrMwjqh0BPCU5IxyxxfBy6N/1lDTLMTC/uTKxHzj2WTurnus4rbWD0U68AKCSi6pxHJjvnhZrVhCAruWQUMJdiuI3IBddI0NfgqX8nOpo1tOEeeC6Gkt5tvFtawJo0POdh0kahE53ORAFqWYZ+9+DKsA1OGQaoZ1ubX+S1mKKEQVFTcGoZNoGNlNGhu3XzTLdX3QzoiYF5N6LqE1m+Ha00WiBUu4ixZiS7aCOwKgN6wuLHkxiPdUk3y15IYYD15Da/+KqyzFQTJ/zxvuxw8YgshqD34+f3JDSKnJIGsjSXqZmlXcm/avPvRny07XwcfoqwtYNXVyd53WmPX33X/QhrIoKZsBvfYIJg0E19i5P/D9MqVymKzuibOoZw2ddlgf8xQBQwbyQDvIc+8GKef2sp6vM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85529d7a-80e1-4689-a97e-08dd948ffb48
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2025 15:40:27.5979
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BgK4oBS22ZOCpGCHCbBUnln9q+BwFeHUKmmvHiIPe7QSrQMx+6TB8W+wIVNa3dax/nFNwjNuILifv6RoAK8hlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6477
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-16_05,2025-05-16_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 suspectscore=0 mlxscore=0 phishscore=0 mlxlogscore=999 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505070000 definitions=main-2505160153
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE2MDE1MiBTYWx0ZWRfX6VOxDgpmVnUV VXjL17qUJFZwQvvriHCPlOxMnGwDO9Eq4GzJiDq/K+hNbxP4OMCvZL1yS58E7pjQyPoXJ9UUvpa KTtbtckVlDXtnvf14XGhlSjhmSO4admvBLDJWAPY7t0RxLzx/XMS103Wvt+sM6VepDISSi/a7cO
 QZqNtQGtp56kNTNH/FZxK8lZ32vhiAF3uH2xWJYmAcyl8UEeQ72b8JCROMi2aGIE2NndAWrKfde 3Su3AQ9DeOONZLiUb5kFAB9yYUS0MspXio1axQ/l37sb4hayZQL+OKYkAcxPxzHgNP6HZGz5d2m O0LkHLvBcb8DteJ0OU8odljLPg7x33Agscdzc7eBlF9IFyGOaBMk0q0KuI9dDX5/CCqS87HNTaU
 4gr+qBm1JrMbJ4Ks9F234ss2N06ZhwXUtA/nVHXmKH5GM1cB1DjzTOZ7/lk/6ysKKH+rUvKi
X-Authority-Analysis: v=2.4 cv=H63bw/Yi c=1 sm=1 tr=0 ts=68275c6f cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10
 a=kj9zAlcOel0A:10 a=dt9VzEwgFbYA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=TAZUD9gdAAAA:8 a=JfrnYn6hAAAA:8 a=vzhER2c_AAAA:8 a=20KFwNOVAAAA:8 a=yqdwDZ3QDgWQZVnLSmMA:9 a=CjuIK1q_8ugA:10 a=f1lSKsbWiCfrRWj5-Iac:22 a=1CNFftbPRP8L7MoqJWF3:22
 a=0YTRHmU2iG2pZC6F1fw2:22
X-Proofpoint-GUID: uX7u907SPIqfIe1JvSP2ZiDYwmHVOQvT
X-Proofpoint-ORIG-GUID: uX7u907SPIqfIe1JvSP2ZiDYwmHVOQvT

* Lorenzo Stoakes <lorenzo.stoakes@oracle.com> [250515 16:15]:
> From: Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>
> 
> VM_NOHUGEPAGE is a no-op if CONFIG_TRANSPARENT_HUGEPAGE is disabled. So
> it makes no sense to return an error when calling madvise() with
> MADV_NOHUGEPAGE in that case.
> 
> Suggested-by: Matthew Wilcox <willy@infradead.org>
> Signed-off-by: Ignacio Moreno Gonzalez <Ignacio.MorenoGonzalez@kuka.com>
> Reviewed-by: Yang Shi <yang@os.amperecomputing.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Nice to see you review this for yourself :)

> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>

> ---
>  include/linux/huge_mm.h | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index 2f190c90192d..1a8082c61e01 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -506,6 +506,8 @@ bool unmap_huge_pmd_locked(struct vm_area_struct *vma, unsigned long addr,
>  
>  #else /* CONFIG_TRANSPARENT_HUGEPAGE */
>  
> +#include <uapi/asm/mman.h>
> +
>  static inline bool folio_test_pmd_mappable(struct folio *folio)
>  {
>  	return false;
> @@ -595,6 +597,9 @@ static inline bool unmap_huge_pmd_locked(struct vm_area_struct *vma,
>  static inline int hugepage_madvise(struct vm_area_struct *vma,
>  				   unsigned long *vm_flags, int advice)
>  {
> +	/* On a !THP kernel, MADV_NOHUGEPAGE is a no-op, but MADV_HUGEPAGE is not supported */
> +	if (advice == MADV_NOHUGEPAGE)
> +		return 0;
>  	return -EINVAL;
>  }
>  
> -- 
> 2.49.0
> 

