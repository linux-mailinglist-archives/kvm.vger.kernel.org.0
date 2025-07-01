Return-Path: <kvm+bounces-51213-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AFBF7AF043A
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 21:59:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9CA8F4810D1
	for <lists+kvm@lfdr.de>; Tue,  1 Jul 2025 19:59:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4C2D283FDE;
	Tue,  1 Jul 2025 19:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RYX3rDK7";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nU32F0Ow"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 911F515AF6
	for <kvm@vger.kernel.org>; Tue,  1 Jul 2025 19:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751399992; cv=fail; b=co6zFvLO3HGil4lndVLDauUEWpIru4ZZvP07DTtBLF8JUCVl3PsMhGQ1GSrJNLrdUW00ivR8l0cRfwkrSAd4MaSyQ0GU058rLDHX8q3gB3jpaEc1vrhZq7iSTpC/YZrSTJEgVqoDRav7Uk14vAlGiegnhwndHhWHTyPO7lTft4s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751399992; c=relaxed/simple;
	bh=tldWtRoEMLjqYFYp3ltXg8JidbHwmKsgntoDTMRTwoI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Tu8BDcLd0uJGeRX0nwLUWy9SVJODtHSGSCv4e3JPtMVlVGw6S43BIfZr37/aeNLHyvPtniT6G1JiDawbC6jnPvegQ0cs5zWGgV84VKhQT6yGs5MiKpawPR93Fm522Xn+iBBZapFCf+StZdcnvXvJnvoVbDyMQlhOK08VxfdITZE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RYX3rDK7; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=nU32F0Ow; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 561JMlu2011750;
	Tue, 1 Jul 2025 19:59:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=2dwdlJTEJzLiHlRMI5
	j3q/cNY1CqAbK9m47b/jfaGpA=; b=RYX3rDK7Z/lTQbsVnwSkOzoTTJoCKAZDx8
	4QNGhahDZWppB7yC1sSE579cKLlb5pJrFYFmweqLP3kaxeh+OOukuaH3UdR0+iz6
	HE8CcLA/PjOiPNhnD6/Q9oMfiU9VyPJ1VZlwy4gn7AdkZg0GkLAUbERvbz1DfT9U
	2MzzZEArHKOrMBSRXwjOPAeaZ0WtpsKglBA+/NtlAHur6JlT91c9lIR7MhnSllYd
	iDcTSvUG8tO9vXKkFde5tsJROZcqOBGUfo7E1wQ1joJeV22x0QNuAaLe9Q3AcAP3
	S6md0y4f5S5+46BhcC+kKg6XQlbNhxSytup3vZRmjY8pJ+FXh/Tw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47jum7vuu7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 01 Jul 2025 19:59:40 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 561Jmifk033663;
	Tue, 1 Jul 2025 19:59:39 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011065.outbound.protection.outlook.com [52.101.62.65])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47j6ua9bh8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 01 Jul 2025 19:59:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z221EORYPrVS7LZeU0T/VMMLz5+xmSwyKMcVQ8EQJ/VmnXIjkR0iaWPfDZadjPAoHYj67tKQNs/fW/wROhPcnkSzV1ex6abqXyW2yveISrPPPHFmOFX+FeonHO8pb18evdO/7oHElnATFdm+kvYAUxZ3FSSPRZgQ6ZixK8M5ZH20aKTzhySAUND+VlE8niyrDC5baXaYQMIwXKDi3vcEd7K4FhS1qcyum1hxD5d8/9zIjnwPRiWpp6ft2VKMydrN4OQW6azZMhufWQTWRxUSzTcPuoA7ZoAz5FN5Uljj0LVp2s2epM2HM4F06vhj3z3qwXv6PhDrpAj+jkkCjELDUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2dwdlJTEJzLiHlRMI5j3q/cNY1CqAbK9m47b/jfaGpA=;
 b=Mg6m+pcepeqBHRwa4MDviGlgvQjxKtOv+cPTSbyXWy1G4nEJuu6ldLrNo66vZfOLrnfI3q9AXKD1vbaR4FBVC5se/oecgbAgCehdK0QzBkhuUIVthta9/fQ4yBgKK2GDCgjN3H2o6d/puuMLFrbn4d/BdWQMYZ+5gZjNxlkRwZ+5QPCTZVXhdEJbIKpc4gNLY5pylysY55ILMWGKpKahhU+JCYsXna41JTISAxK2/jRzup4Ly28snMlfBfE42bsI2JnqFDp7nunrKn6XW4FKhCfTXzBxGS5uvD5AepXVOzYp2iXlfrLLYShnyLfbiz0imCSAZ6lfxh10vQXmB/63kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2dwdlJTEJzLiHlRMI5j3q/cNY1CqAbK9m47b/jfaGpA=;
 b=nU32F0Owy5CYqw/rsuTPNmZ1OMtB5fY18sgGpB9hN4qycDtp2WmAAi4a9SD3k9V7cV4nl6qVwGZzY+ByUsAW4z64fhUN3bRtxsLhMnvoDtMdDtMw8TNb+USDWufA1syq1OJhSJFjiYZMyo9fa8toqf3BIn+CJQn9FtYJPOkIJi4=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH0PR10MB5194.namprd10.prod.outlook.com (2603:10b6:610:d9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.28; Tue, 1 Jul
 2025 19:59:34 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%6]) with mapi id 15.20.8880.027; Tue, 1 Jul 2025
 19:59:33 +0000
Date: Tue, 1 Jul 2025 15:59:12 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Alexandre Chartre <alexandre.chartre@oracle.com>,
        Zhao Liu <zhao1.liu@intel.com>, qemu-devel@nongnu.org,
        pbonzini@redhat.com, qemu-stable@nongnu.org,
        boris.ostrovsky@oracle.com, maciej.szmigiero@oracle.com,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] i386/cpu: ARCH_CAPABILITIES should not be advertised on
 AMD
Message-ID: <aGQ-EGmkVkHOZcnn@char.us.oracle.com>
References: <20250630133025.4189544-1-alexandre.chartre@oracle.com>
 <aGO3vOfHUfjgvBQ9@intel.com>
 <c6a79077-024f-4d2f-897c-118ac8bb9b58@intel.com>
 <1ecfac9a-29c0-4612-b4d2-fd6f0e70de9d@oracle.com>
 <e19644ed-3e32-42f7-8d46-70f744ffe33b@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e19644ed-3e32-42f7-8d46-70f744ffe33b@intel.com>
X-ClientProxiedBy: SJ0PR05CA0165.namprd05.prod.outlook.com
 (2603:10b6:a03:339::20) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH0PR10MB5194:EE_
X-MS-Office365-Filtering-Correlation-Id: d790ec6d-7014-4d1d-57f5-08ddb8d9cc4b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7hxJVSBU56jtn7weFoWcoECrsBQDjHOlpt98OwbG0iady66W2JtMGl9ZN4tm?=
 =?us-ascii?Q?pnC3ATDuawbLRHraT0bPPmtMJivPTP66o6/G5gBqXQ4ok+d/8BMVnlToWOoS?=
 =?us-ascii?Q?+fyxdP5pwoVc39Qdy1KEBRE/sDJeaZ19hkw5DIG5yikqfLyjTRO4/66IdCCW?=
 =?us-ascii?Q?RWKYonw0uAq3T3UywlCMHbn8qESPOUPdqCXq7QdBqfJcJEhkUE4/DBRqRSk2?=
 =?us-ascii?Q?OdRByNozomRp26zM5yCEBvGB1FWFPWSfK3Mn0wAqXaqMgL5fxjwOmbfp1Kmu?=
 =?us-ascii?Q?apCfFciQ90CgkihFv0aGVDG8///XXz8HGc2G66Gv8se5gztLRtEPSnrVttJo?=
 =?us-ascii?Q?9Ag2/jDFWf2a9qWLGUL0Ql4CcxALYD+nOfmgf//dUQo5oNgMl/Ut1Tis5gcU?=
 =?us-ascii?Q?Kum3Hl7L5CISemfrVsmNITdgoaz0fJaIg+tgkhddBZ3I70rmNePgq01DjL8A?=
 =?us-ascii?Q?gdv8FcAQzEAfj6uFS5o/KRQj/UDdZqod8F2uOHfbZr6gu5h2TaRdlcyk51a+?=
 =?us-ascii?Q?KmOg3Kfb61OTnqXfHTE625uqwKevW3/5NSB3jHcnoSjYzNFjv4EKOU9/VFbp?=
 =?us-ascii?Q?hd+KwwMf49dNCz4gS1f5hZXwkAzfQq3JwhrGjooRWIHQ3ddswXalM0BbkBr4?=
 =?us-ascii?Q?3BiPnf4hx+zbAZGCnDQ+nrDKZMS0S+o4+/if3Kr+LXqn/9X5x8f31XwJQki3?=
 =?us-ascii?Q?TY72NWywHgbdJODSt0rBEGdXQmeL1PcXGiawudZBfNSmPabJJtkjsMcnQAgG?=
 =?us-ascii?Q?mcQdMEUj4ggIy5F20UdudZ3eSrtc1sSYz9UFaEkMYgWg6mcRn3vsPwacDttO?=
 =?us-ascii?Q?uaoNvX9pkcPKjLW6PE1Y9Ae6zswX5/RkkLUhitwzViTCZbLAcoe+bDqnbB/d?=
 =?us-ascii?Q?DlYdA36LlbEyTmwHmm4YY1Meh//dFFYlK7Oq4BGsiOr54qZOPbtli/Bbn4PF?=
 =?us-ascii?Q?+Z35L5PWEkvsVqHFSZ79k4jp3LhgFeJ8Tk2o6zGRwX9BuFvRvVakb26dC9dL?=
 =?us-ascii?Q?ZTI9wlUzTWoUofzSh2Yi9Vt7e8cWJxnediNHneU2P5F1j6fsQ4VDU5ITOSGr?=
 =?us-ascii?Q?/WnedP7o0Ca+zGZFkbY5f8HoED7XHS9UvylPKZHWCe7R7TTFNIYeHlw7UW9P?=
 =?us-ascii?Q?iuzfNFBKTEr9qPUJ69EA2j5gGzOn1r5vQrGoouY0raF5XFHqdS9KibVJGV4e?=
 =?us-ascii?Q?E1B3BbP8xaEiW/JWwwghjXHWl66IjUzt8Qrldvv3P43STXm/xxkwJslBL4qw?=
 =?us-ascii?Q?NwfHn2fB8frHCRgvwXn9PUGfST9F2ggHSgRWkQ9UbEdwJshSyqfzrJ6WWSr1?=
 =?us-ascii?Q?yuFHHB2IrxB+2RKuVgvIpOLWAfFtg2fpsqfOTROz8btF39eAtiT4OldVS1f2?=
 =?us-ascii?Q?gzD30EeuQ1WlCrpjti6a/JCdD9BbaXuvkCbvm/ydowA4TDxlM4J49YWQt7uK?=
 =?us-ascii?Q?ZZPdtLvxpaQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1Hv1DAEoIErZ+lcnjMqXwNe7aWV30F0XiBLaG9q3YRXseYUo92cpl2ntY3Ee?=
 =?us-ascii?Q?9jfd1uemp9f5RLrjEjOS2zy4AwamA/9vHUf/KWaSL58+Aj8EcXAfeaMCydUE?=
 =?us-ascii?Q?Xv0BwYIA6cl4YA2gVCvIXbXCI6YKQfwqpRwsTu3GlvAWM98Z4DZycGyjyMEQ?=
 =?us-ascii?Q?dyZ8bhwT1L9pa03OATsupBgBzYV+/jltt0j0iSsJu+6PpVrig4MuKf6hEKpA?=
 =?us-ascii?Q?zMrF3XJQ5mZ9mrwlC/DD+MtQFtpYdNbvCUGw+PCjFWw+y5xCZ4wVe7fZ+2RJ?=
 =?us-ascii?Q?vJgGKUiy4k8Uz0dIcz4TWziI7ZVfrvOsMB2g4AZWgeL0zHbsbdZqnGlKvn83?=
 =?us-ascii?Q?XPY6BXnqq8iI3Gqyc+MsY6ELgPqRqrzDwJ6xB4QfyJoUNBAwGXSJ7Sc+ToAF?=
 =?us-ascii?Q?J0fIPMg7b/A+ofFXCvyYm+frs/8TmnBjFTQrZbq0YFWMUsW+xhk/VaoJdFjU?=
 =?us-ascii?Q?zrvQafC6CNjB3MZpUgdecEtVTnKNadS+a0epi+60L2zvoX/HEKnSE7wz4rDa?=
 =?us-ascii?Q?tW5JvMBk82dw6Zs7ROGULAhFZ1BoOZZylzzO47iw/cPmDfMYDXH1F8DTub9f?=
 =?us-ascii?Q?usVe9iw2+ZtAOfFDXlVo7tUd7/01AolTODBY+BUO8PDmHqu4RC1nOZZE0d4w?=
 =?us-ascii?Q?ld6HivUF5LwJhPTiM3wQiGkwNz+GcgrVEFo/QM3MKkjzL3sXS4AOpx2dGEJb?=
 =?us-ascii?Q?Osm8pm1Fzsx1UXrdS/nTg3TksKiEq7ubHUk5bWNQQxKY2RLgNYtb06sbtZgu?=
 =?us-ascii?Q?bpojeVvgZy2egmNTu3hgKU70uxFnCQvO1BrTSno3DdAusqXv6VKUNjGZYPSV?=
 =?us-ascii?Q?qNLf2U7Dd9kPSyJmdYXNgj5X2RJTRJe8DitTCdycJF5/10W5X6KBIzcL3nuJ?=
 =?us-ascii?Q?hmXmlH2sY5xUdgAPwtEHzThKgjsnS5uE+Oexg1+bP1Jr15aD087HzAtoC/Oc?=
 =?us-ascii?Q?6Y4QURz7qq2dkJIkVZDvGMuqF6HJmHtV04FYOlCYsB8xOCzLC+0EiVjnkT8L?=
 =?us-ascii?Q?fm3vsfV/QOwyGV9tFACkioOLiAHUg6lH5IfIQId4uwwe4k5glC+qSsMjUFc9?=
 =?us-ascii?Q?J8jmCUCbgjL4hmUdOna5ZwkqnjCNvRwQL3j8qFeabXbDHj6r2fBfvDeshbOK?=
 =?us-ascii?Q?o5XooBOQyWO7cOimvdefpR/2nIs2obrgRXdbJn6CBiJkTJwPGM3WO/bnjoG2?=
 =?us-ascii?Q?B5fvb1/Xd9OPI/GKIIl7Bc2JoZkVjwOPYxE7MRkhFhJyt8/KVqjDMPs5aKs6?=
 =?us-ascii?Q?FfJ4cWxRsOxQYNzVbZZtD0SuqeUN/Q0WSPVjBlWpFDpg8q+a4OFFeX+qJId0?=
 =?us-ascii?Q?aa6t0Y+1uVktDUPKQREBCFTVj2fL0AAZx4+8v8zSbIa7uXAQNpyDOnMpS+fh?=
 =?us-ascii?Q?kYM82Cg+6+GB+4yqO5xWfDC9bEmUszNz8TKEQqvhlwQEcniJuD4ZEfM/cZ9W?=
 =?us-ascii?Q?5Sv9jwY1yo90dxNKk5KPeRwO8L2fYlw5+/mcRH9Xu88miBLlb1F/t9vKc/Xv?=
 =?us-ascii?Q?8yL3+sDfD1QUNYkAvMckW9zBfMQ31naTizQBB8bKkhpsSjcqkTc7Gyrd/Yrt?=
 =?us-ascii?Q?fvYgjHBck3bEpgg6Ff3GQEN9WpTBKiLp4SUcP8qfhm7ISTc46eXqnnTDI+KZ?=
 =?us-ascii?Q?jg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZqI9Hfu72HbpGD2Tx8ejqNQ/uAGMHzSvxTjSErlrAr5AHeARQy4DwXvF/lAv4yBcHy3mo84R4/wKxM797Iy0wlaaXMSf2QhKLwXC6ynyquVEYE5PJ2gRz+HFsZionXaZVt44vyHKLhvULQuuQYUnDs04BTyFPcT/kOrZZC2SiPii9+vkXmLXo9N38cqYG5Gs8YGNN782+jvFxRn8oWgeY/l5KAcL+TvrvFCLhp+ezNjybF5AUrDgNOL/ZultCw9PwkEJ9Q8a4HXIQwoLU7HwEy7BJh8BaFXS9xKt0cHPI4FKpZp9tzG4c2v18zoEGIUOxVY079EbJijxPhKt3uB+ahjcSD7QJ20PHdMJD5sLXQjiFko1EqiMXQlFO5u1Rn/tOzrtRQNANuPNO/XXVv6Vb/4rwWox+AC8SghbGy6UsYebrBn1b1HjOa23nMG+56PNcM4kaVlq96JOr25bMGDUJiFMevQtabHcyXlMSt6A7yWKjft7bvnYdtnhJVuyt15/PrbirRqXDz3HFKySY/rXYCpj5PxmI93wIZsQL93up4RrmkcgEt4B5UO5KyhhBTybRdsaizl43KKU4/4hcSidnPooQzW721n+4bjfzsRVbH0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d790ec6d-7014-4d1d-57f5-08ddb8d9cc4b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2025 19:59:33.3267
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YYuzEj7bgxj9xAhrWH9CQPmgFC2WZE6PxMkQFpNY+Gl+E24RlJ3gbMJepCaqokK1CYodZluYPtv0wZds6+07Nw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5194
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-01_02,2025-06-27_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 suspectscore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507010139
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzAxMDEzOSBTYWx0ZWRfX6Cp2p344RgY6 BHPvr7PWkf+edTykNBSbO+XmMd5T+uYwD2OFILHQFFu+nix3Bry/wh9WTMRS17xfr3ftpLGM93Y mDLN1yn/OC2oTrY3aesPdawjUuJxZ8hLmyAiE6LwB2JBUzOMB4yLrhfhSisjncv/F/kLKMtQkPB
 veXSTmPRjaO6PGLlTsbzLB2FfRP6C24pkyClPLC9/h+zWGlIVmHcO/lt0Tt0MGtc4Pol2oDcuzx P1PUwPiXYsRMH4oU8wJYhiLOfUi/2yazF1+QKhboQ69V5N6TuVnzSGk71OA1cBMQrqNf+WWHShN JLnKnj+IjwedKiBbbM41dcmBgj9PkVvA3/xxaAek1HyR1X7nAU7az6lYCc/0CwdKIgsDctdllZO
 HMVz+Csngsr9gdHq5SAPqotFuiemwMyRObBAgXZoJbeQLYZRbkQ8mJarfOFSvO5lNOK7bIxG
X-Authority-Analysis: v=2.4 cv=MvBS63ae c=1 sm=1 tr=0 ts=68643e2c cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=346n6OzxTc6sChOVBz4A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: li0ZqqefGtOTL2KWhKTrP5Ap4kDYy-Dy
X-Proofpoint-GUID: li0ZqqefGtOTL2KWhKTrP5Ap4kDYy-Dy

..snip..
> OK, back to the original question "what should the code do?"
> 
> My answer is, it can behave with any of below option:
> 
> - Be vendor agnostic and stick to x86 architecture. If CPUID enumerates a
> feature, then the feature is available architecturally.

Exactly. That is what we believe Windows does.


By this logic KVM is at fault for exposing this irregardless of the
platform (when using -cpu host). And Sean (the KVM maintainer) agrees it is
a bug. But he does not want it in the kernel due to guest ABI and hence
the ask is to put this in QEMU.


> 
> - Based on AMD spec. Ignore the bit since it's a reserved bit. (Expect a
> reserved bit to be zero if not explicitly state by spec is totally wrong!)

Which may change in the future as AMD may expose this CPUID in say X
years. And at that point the first option you enumerated is the more
safer one.

