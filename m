Return-Path: <kvm+bounces-66770-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CCC74CE67ED
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 12:18:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6810F300762B
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 11:18:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44D6E301460;
	Mon, 29 Dec 2025 11:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="VYo17e3u";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="LNZwkCYy"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C95427CB02;
	Mon, 29 Dec 2025 11:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767007120; cv=fail; b=PKzZNSRKl77hLErFvRzw2aQ5rC1So1BWMp8vSVD0g8X5BzGAKkVWC22Frw2IRpF1uxmLFuJ24iIQVWYEFc4ZORX7cOxqYNk3fXuzgMMrJXNKn9rPX5bXrVyEA2bkefUIXfopvuLwLCTS0Rvg6GivolTRnoF54mgVEB0kpdIYgK4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767007120; c=relaxed/simple;
	bh=+fZdLv1dsMonEs2fIqj97fM+pm/NpuNSunLTh7LopqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OY4V5vV0L4+mdybebPXDwI5EbtaWiu+aG+dEo4GnezTgarDCumg6HxS1am8zFOUW0iZJaZu+5xfxe/GUkR/mxiILgFY4LL0k7snJuSQFFztKPj2MiXDmBeB61CXKhL9MgyEYtBp6FPREmd5ksQTlawVUegYJJPZYtsyjUYgdo3Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=VYo17e3u; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=LNZwkCYy; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127842.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BSL0cZ51186992;
	Mon, 29 Dec 2025 03:17:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=CXLjSgYA7ZebJnwwUPuvS7D0Kkd2WWyxb9yLE0XvG
	Vo=; b=VYo17e3uAdf6qyQsckr3OU73Op7OGdlZ4BNYp3adpww0r1w8n2+s8lrZL
	ORLZ9hndEx72PcjQr8vvHSSdFyNdNuJ/hu63JgW/QYBa5rJlW1sZouahjZ9WBoOU
	+o6K2Vq3MqEeM6MVkHqtU8lwIjytgUNI3mtjMZ6LCT71tAm1Wq6mSaV71ml1UFLJ
	vdGcD4tUWut9A4wal4daPWPQjMRRTpLJ+t5gOW0j5j7Ug/+CIoLJsWS10P5XV7rn
	wFY/aLINi3UsZzRIG24k+2lsEadYyw6xbh9JN8GUnKrQcmK76vKjPv5ZrniG2CKj
	yWyz636I/rKyN/KEOLjHdLarlKi3w==
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11021083.outbound.protection.outlook.com [40.93.194.83])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4bafnejj8n-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 29 Dec 2025 03:17:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x/YB8moJwySLV5j7X2KF8pGsyhJoURIdygrOvTOxyd7fiPTmXnxBfD9y51uz6F8z7dGPTG0D444qvu3h9XJgby2Mq0pA0TfGOSCmjLPP4QJc/1y9vIwdxLyJmic8WQKYERdK/2JumqzqQi9NkzCX27RJupeVylMxalQTobX/hnIIV9EcSo0N8wvEkivWUJqc2jsujiEFtJDjXr+fn9oI4DwMLFytChZMX3+Zrhw5592iNKdci1l/LhkbP755gW437FSSJbMCh+IxcKoIHzWP9+Gfe7cInzfSXAg7HGBsdVD4lEz4gurMHLmwt6dRxM1HyHzTZBScEqEFijYcBZ/NNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CXLjSgYA7ZebJnwwUPuvS7D0Kkd2WWyxb9yLE0XvGVo=;
 b=ihCPvBJlCTuLBeCJXNPiGCJce/ST7FvvsMdhFhcFNHimAfDjEdR/sn059p600/J4Kf52yD3tDTpxE3MKjpuGXsNywD/aYlYLjyX7giDzzdaR5DTIhBSa2KUMw610S3kvreOwBrUGS/V2sG2HQcVPB3xtw97VYyd80iOdnRJpOHFDgJz4j7mhaxrF+X0gfaWUdMsVLIEzNRRih5dQlnPYoI2K1BmfsShcWaZaiBU4EpH8GgwuiB6wxOPqA7rGY/EuCjY1QKecs0+18dIyG+J//bKRdkLau0cVLEpstfdd4yquHIzGBxp3FYiFVREpLAxpEHrpQbnLYEUm053kzFXFnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CXLjSgYA7ZebJnwwUPuvS7D0Kkd2WWyxb9yLE0XvGVo=;
 b=LNZwkCYyhvUuKZ3BTvCmhl/GDAd+dhW5GPFH8RMvwdt25Fy74koAIT5MdDuFu/zQ9oB7jqOCyYfo3iWEPnxn1GTYA3sj774naTCoy/RQSk6tiA3/4SUyehesClgLWwQV6NsV0VB4wLy3xsVGY6GK9F3vKYu/FrZ8lNNCmRb0JIsLiBaxQ+qw4SvIF4J6rytzQp2JAqyxt7ncrqIhxgZCvWSVa29DrhSTZtbnnEOLJV2CtPNQ0xLyTk/nPmcnxrihMoj5pfcN0oIn+cYqG8wOP5Y97YfvZVjPbwUYPHupt3c+LxqbRFXA81v+gWyQvMY4G8rLYspOVC/1Dmu8YP5qoQ==
Received: from PH0PR02MB7557.namprd02.prod.outlook.com (2603:10b6:510:54::17)
 by PH7PR02MB9965.namprd02.prod.outlook.com (2603:10b6:510:2f9::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9456.14; Mon, 29 Dec
 2025 11:17:47 +0000
Received: from PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef]) by PH0PR02MB7557.namprd02.prod.outlook.com
 ([fe80::4917:bc05:4373:6bef%5]) with mapi id 15.20.9456.013; Mon, 29 Dec 2025
 11:17:47 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: seanjc@google.com, pbonzini@redhat.com, kai.huang@intel.com,
        dwmw2@infradead.org
Cc: mingo@redhat.com, x86@kernel.org, bp@alien8.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        dave.hansen@linux.intel.com, tglx@linutronix.de, jon@nutanix.com,
        shaju.abraham@nutanix.com, Khushit Shah <khushit.shah@nutanix.com>
Subject: [PATCH v5 1/3] KVM: x86: Refactor suppress EOI broadcast logic
Date: Mon, 29 Dec 2025 11:17:06 +0000
Message-ID: <20251229111708.59402-2-khushit.shah@nutanix.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20251229111708.59402-1-khushit.shah@nutanix.com>
References: <20251229111708.59402-1-khushit.shah@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH5P220CA0011.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:34a::11) To PH0PR02MB7557.namprd02.prod.outlook.com
 (2603:10b6:510:54::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR02MB7557:EE_|PH7PR02MB9965:EE_
X-MS-Office365-Filtering-Correlation-Id: fb0ef918-2a68-44e0-923f-08de46cbe55c
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?62RTifGFu8/iY1s2UO+UGnrZJWl7VtCx2zfSj08HRIbqg79LY2MiD7UsMYn/?=
 =?us-ascii?Q?sU7Vp/DvoqIT9xG4xmK2NTPxLy+/YxxHgdetggPanSt4t6WqgPyFV+OqWSBX?=
 =?us-ascii?Q?mZOslWBusS+2BVQ+MMkKKqR6QSDjvOkihtJ8b3+F1qs+JtngoGPMzcUt8+8/?=
 =?us-ascii?Q?N8ykuxMS9UfsZMAAeCM9nUlrpsbOqZhpn3dPknJhIeDYFhV+mtKa1QfjhWMk?=
 =?us-ascii?Q?unYao2s1k0NuqcIi0ol/B/ODoLraO5qcobxIokh1tHVYpD4kSyStY7BLDEPH?=
 =?us-ascii?Q?6cvNjMkA4ULWc7yr0DDjh4/Ccgp0qJ9OvnsQu4bjZ4nq+CAOhBR21vGfTYle?=
 =?us-ascii?Q?TsLxIe4/FgyLrLLGc7QzdlNc81Cewpl1Ak7JmC/vxRyUCBDep4E2Uj1oJhBa?=
 =?us-ascii?Q?IJ4rT1RhgUJuLpQgtnovniDOpcgawqz/Qr3PfZnRdEaNAt08GyYGX4L17Ufp?=
 =?us-ascii?Q?gXNM9mE3v2oowglslSnjfjXOX26MVdRnk6yTJbKD8D0QJJZuy690SSrbqLyQ?=
 =?us-ascii?Q?0ZctF7tE5DzFm8sAm14i4zaSIORZLae8wuL145X0Kv5SPvVSdMzWzeqkDywh?=
 =?us-ascii?Q?ckSdpH5ux4f5KE6xpetsL/GRYey1IQz7ziD8yA1m4gDY7hay0De4zL/MPEr/?=
 =?us-ascii?Q?wcDjMJEnF3BA+W2A48+KqUeInemqriE+jkdivUn58iZdKmuwQpO4ldzxyifJ?=
 =?us-ascii?Q?r9QP4pc9Xm6p/+hZx7asZsuuAg/M9H7xO9FKe2sccHhNYuoEBkptR3q8IrKm?=
 =?us-ascii?Q?2zlEjDnv+GNBMHu916cCvB7uBamOyDG3jbmBzBmX81CPI50ICzk9FWG9k+3Z?=
 =?us-ascii?Q?dSr+Hs2Snj8P77irr0BYfqYeck649YQdRoneeMCZWaEy2DECjEF9sM1u01mr?=
 =?us-ascii?Q?LjLyqsO8ksEDkuVuK6WVQt/OCQqP/Al+IYgCMqsJFnVnATDDjw7fSXPw2Nu9?=
 =?us-ascii?Q?i03IHaJlMlAZrJ/QGsN775Iut/Gnw8mr3BFt+FjCylRkqg1uyLdiXla0J0ej?=
 =?us-ascii?Q?eWNFco/V1TMfp8EvDajnpVoVOz5sQo7JuDKsxCqooWoaBj5Byz49ECUf3Qck?=
 =?us-ascii?Q?VUqjxEEO/REmyK4k94c/XIULTGnygDcpvTMkQh4wS+Iys+kd71ZGsMUfyD7/?=
 =?us-ascii?Q?jTtjvwC4Pd9k3sD8C8yDn/3JErM+0823M7k5voovmBK594Rt79QJ3vfL3OhP?=
 =?us-ascii?Q?xmjcZGt2DtrQi/EnsfbZ0SSqC5m3ixkHhUOym241tL9SMq291aI/EQcJZcp5?=
 =?us-ascii?Q?s5DY6GaQo++XzJLj+X2KTEyJwMppuPEcklC2SXGowhm7hau9Twol2xcrsW4d?=
 =?us-ascii?Q?NcFD+SAezoinB1TWovQIZ6mG3KhExowp98rvuieRTTtHzB8Pv0macRPs45Mr?=
 =?us-ascii?Q?KO6vyJpQiP1M/bbRoqL2aItt9nmlhTHRrlevBOHBSYmbHXX2VbK27CVF09HG?=
 =?us-ascii?Q?7mPqIO2FeNyqvLt5OysIJdlNPgq4BwG7?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR02MB7557.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?f7l4/od9M6aO9YixTQPgvW3XrrE6jhlmtRB+NBjNu5VjdVVzkiIZzVNyDWAh?=
 =?us-ascii?Q?pzxNmjRJQrhAcQpbHqnf16OEbtuuS+vDavpDzUgL34Cyud9/ODZXQ5dADOCc?=
 =?us-ascii?Q?NdcZaaY3ie2IKoftm4U4dAQVCIl6HdTKnMle3v27n5I8h6DWGqGLtoFN159N?=
 =?us-ascii?Q?1wwDIdVEcssjpXsplrzHNx8YOTAWMlM9muCKO1BB+ClZQRUFLlLRfSFiPEhx?=
 =?us-ascii?Q?AF3EfkdCFOUdqRKY9LI8U2MGbqj6OiBzcXSHWQMyCEqKS1zVCM7tinaqUQ4n?=
 =?us-ascii?Q?mSI88GnGuuRDEOhm/3rSEDegZp1GriZp9D/mipy6q8xJb6lMA/Vq82Voh/5s?=
 =?us-ascii?Q?3Gd3EIOTCu1aXCuiaksrnAH6MAFx0j6b3oWr5xfL4yVyVSjaWiezRHvnvg4E?=
 =?us-ascii?Q?3qAblWXjpxZtoRlDsXmy3GEZn3OAMFwuSTtI1iVaoBNujKqoie7up7UQ9Nud?=
 =?us-ascii?Q?P/Ou/puYWcEHnqssPICiwgMFtrOzN3Dj8w8A/uO9SsNEryHmUjQ4XyUtVJPj?=
 =?us-ascii?Q?81KMELhuAwO27WVHHPlfpPGthxirn912Bq6W+eUWJagDlZ/5g1ZWsl8COYL3?=
 =?us-ascii?Q?6MbH0NVn/EC8MtlUCxd3/BgZt+0pMjFJMz1Zb7r6TzHFsow+blsLm+O5paW9?=
 =?us-ascii?Q?94FZYGlOWBIb+u87m7kQtCFhd6aGAo9rShhedkDvImsx3CDpjV5l+nOdog09?=
 =?us-ascii?Q?JCQMHUDuWpwTFU3OOPTTmUoMZpyj1mcuoaGobZZ2Rz+k7G/U+m3QnQ3TsE8T?=
 =?us-ascii?Q?+vpGc4k3wgVCKJWbDFjkjyrAuGnwDm+S5TI/+twT03TLgnM6FxhFJbyWsezl?=
 =?us-ascii?Q?LquhX39R7ZAhbDOG2dXYadeAyTugEQ+kOgVSN0obkUePQPNVfZ3sYkWHZrIC?=
 =?us-ascii?Q?FbtbnGOqrwmnfrvO0qzmMYIBcOmUtf2mKZDMiAFb1nMC6H9e9ml7bVCOXGZY?=
 =?us-ascii?Q?d6ark0c8JC7wpA7SbyJT+6IednP5ILoD6Jk5GRBr2PVAH1kkORZOGOzr4oRv?=
 =?us-ascii?Q?mQzjbkpkMIzEzQmKUqfd7aGjcmfRnOweqkZxe/19Xs77irJGAL27cSkuf314?=
 =?us-ascii?Q?YR74YI9OhGW+gN96EExYuZYcHJFG/cCWIWWXPRKVu/kwgC9cL0qL6glpsuoA?=
 =?us-ascii?Q?OhfTTpj0NuInCbOB/XKXf0AaQFKlneLHAnWdxsCeCPupKOMXCXn6ihDiVZtl?=
 =?us-ascii?Q?oSuJEIKIn4s2aTKcoWmKIV3r+QSLvqQi+s/xoM/55Cn9Zx17IxTd2aM54ph4?=
 =?us-ascii?Q?c+r3lnfxBE33vzaZGok6PRPseamqiRdOB3TdCQs5TzV9KdhrbkmUHdVtZsnf?=
 =?us-ascii?Q?pUuJ7HN3cQKKejGVlIbNDpaJSh9yJ82Sjp59PLKHkexZUwREm6aPKi8KWh4s?=
 =?us-ascii?Q?odQY02C4gwPFnO1rbntMcfrgWk1PqsFyeCRqcBQ8UqspITBoWbYUw2jo4XZn?=
 =?us-ascii?Q?zu+zMb221kyg/T2vB6nekVCe4RApC2hAJu9JPljc7ShwR2+cAmnr0K9pPv2Q?=
 =?us-ascii?Q?ubRr7OXNkagNiEu67aus7r6jyJDgcvWcCEg5Rls+QONbudCtRQ/1qnCHoG0U?=
 =?us-ascii?Q?JNzHBacLHAbDJ2YZlOf6dhur9msVcfS/qGIJQIB/V+LkAj3KCIZwGLVMDK5G?=
 =?us-ascii?Q?uuBcoE4x32iHDNN68mwAp5V6g+hIp0Dj4K56Lbb3j/HLue35MEL2cDntPlVq?=
 =?us-ascii?Q?Hqn9pM3UwNsQrJnjcjbwXNxSitUfr6/Avkftz1S1rUw3C+CRXl7imm8RWR+T?=
 =?us-ascii?Q?sK49DnurX526aMFogT6PYTewHYTamNE=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb0ef918-2a68-44e0-923f-08de46cbe55c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR02MB7557.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2025 11:17:47.4625
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A8nNf2l3Jya3K8SEHeRLnbmd52zyYnLgGb1HEmnpdfSuBQitCmu1S9c7MfKX4R13oxwThOtsAieMAAT+c3utvdI3EbLpGS7vWb8SGsWtMEM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR02MB9965
X-Authority-Analysis: v=2.4 cv=P5c3RyAu c=1 sm=1 tr=0 ts=6952635d cx=c_pps
 a=IDYaL8Jh3K30OkZprGHyjg==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=xqWC_Br6kY4A:10 a=wP3pNCr1ah4A:10 a=0kUYKlekyDsA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=64Cc0HZtAAAA:8 a=D1or6okRyu1H9lat9IUA:9
X-Proofpoint-ORIG-GUID: FoW8LSAJpQL99nE-koJ_xzdgxbjlB30B
X-Proofpoint-GUID: FoW8LSAJpQL99nE-koJ_xzdgxbjlB30B
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjI5MDEwNSBTYWx0ZWRfX60kJWkPKT/p2
 cKxrgBN2cD+oCkh2QcNU3JQbALNMBDXms/VgG7Cbx7EodE2i5/hSO0IpT7KRghV+pSuG9tqn/iU
 tGmzbKGAcrpWqSkYI0FbWat4BGJg7DYmsz7z7XeJZ2V9gOZrt8TNL58vuLU60AT6IJHNdNCdRxI
 veWzYatJ/MI9vr/3vLHcnbOJGoWYhNGRPcQCRBJTz12Ej68Jj10csbQklbSzdSovPuzsZIv9JXN
 2ib2AEr84/LRMVC2NWmsiUhjC7/YYoV6vMBlAgCwYmZ0FXo7SMjiCF+WPftL4nBEp7SMC0Z0Px9
 5tGwCjcNw6eVfi7BukLwC/hQIoqLcy/aIZFurv+6ipno01Q0lhcoFpg7mOZ4YDecxcOsHnKRiek
 ueJbZrhl3dWli8qVqi4gCYXoYwVQ9moeUzR4SWUq+LNJDbnSgGF2EymP5X+TbAzVGq5XnhbmWhT
 wnfoFCkG5HLpP2IzhKw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-29_03,2025-12-29_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Extract the suppress EOI broadcast (Directed EOI) logic into helper
functions and move the check from kvm_ioapic_update_eoi_one() to
kvm_ioapic_update_eoi() (required for a later patch). Prepare
kvm_ioapic_send_eoi() to honor Suppress EOI Broadcast in split IRQCHIP
mode.

Introduce two helper functions:
- kvm_lapic_advertise_suppress_eoi_broadcast(): determines whether KVM
  should advertise Suppress EOI Broadcast support to the guest
- kvm_lapic_respect_suppress_eoi_broadcast(): determines whether KVM should
  honor the guest's request to suppress EOI broadcasts

This refactoring prepares for I/O APIC version 0x20 support and userspace
control of suppress EOI broadcast behavior.

Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
---
 arch/x86/kvm/ioapic.c | 12 +++++++---
 arch/x86/kvm/lapic.c  | 53 ++++++++++++++++++++++++++++++++++++-------
 arch/x86/kvm/lapic.h  |  3 +++
 3 files changed, 57 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
index 2c2783296aed..6bf8d110aece 100644
--- a/arch/x86/kvm/ioapic.c
+++ b/arch/x86/kvm/ioapic.c
@@ -545,7 +545,6 @@ static void kvm_ioapic_update_eoi_one(struct kvm_vcpu *vcpu,
 				      int trigger_mode,
 				      int pin)
 {
-	struct kvm_lapic *apic = vcpu->arch.apic;
 	union kvm_ioapic_redirect_entry *ent = &ioapic->redirtbl[pin];
 
 	/*
@@ -560,8 +559,7 @@ static void kvm_ioapic_update_eoi_one(struct kvm_vcpu *vcpu,
 	kvm_notify_acked_irq(ioapic->kvm, KVM_IRQCHIP_IOAPIC, pin);
 	spin_lock(&ioapic->lock);
 
-	if (trigger_mode != IOAPIC_LEVEL_TRIG ||
-	    kvm_lapic_get_reg(apic, APIC_SPIV) & APIC_SPIV_DIRECTED_EOI)
+	if (trigger_mode != IOAPIC_LEVEL_TRIG)
 		return;
 
 	ASSERT(ent->fields.trig_mode == IOAPIC_LEVEL_TRIG);
@@ -591,10 +589,16 @@ static void kvm_ioapic_update_eoi_one(struct kvm_vcpu *vcpu,
 void kvm_ioapic_update_eoi(struct kvm_vcpu *vcpu, int vector, int trigger_mode)
 {
 	int i;
+	struct kvm_lapic *apic = vcpu->arch.apic;
 	struct kvm_ioapic *ioapic = vcpu->kvm->arch.vioapic;
 
 	spin_lock(&ioapic->lock);
 	rtc_irq_eoi(ioapic, vcpu, vector);
+
+	if ((kvm_lapic_get_reg(apic, APIC_SPIV) & APIC_SPIV_DIRECTED_EOI) &&
+	    kvm_lapic_respect_suppress_eoi_broadcast(ioapic->kvm))
+		goto out;
+
 	for (i = 0; i < IOAPIC_NUM_PINS; i++) {
 		union kvm_ioapic_redirect_entry *ent = &ioapic->redirtbl[i];
 
@@ -602,6 +606,8 @@ void kvm_ioapic_update_eoi(struct kvm_vcpu *vcpu, int vector, int trigger_mode)
 			continue;
 		kvm_ioapic_update_eoi_one(vcpu, ioapic, trigger_mode, i);
 	}
+
+out:
 	spin_unlock(&ioapic->lock);
 }
 
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 0ae7f913d782..2c24fd8d815f 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -105,6 +105,39 @@ bool kvm_apic_pending_eoi(struct kvm_vcpu *vcpu, int vector)
 		apic_test_vector(vector, apic->regs + APIC_IRR);
 }
 
+bool kvm_lapic_advertise_suppress_eoi_broadcast(struct kvm *kvm)
+{
+	/*
+	 * The default in-kernel I/O APIC emulates the 82093AA and does not
+	 * implement an EOI register. Some guests (e.g. Windows with the
+	 * Hyper-V role enabled) disable LAPIC EOI broadcast without checking
+	 * the I/O APIC version, which can cause level-triggered interrupts to
+	 * never be EOI'd.
+	 *
+	 * To avoid this, KVM must not advertise Suppress EOI Broadcast support
+	 * when using the default in-kernel I/O APIC.
+	 *
+	 * Historically, in split IRQCHIP mode, KVM always advertised Suppress
+	 * EOI Broadcast support but did not actually suppress EOIs, resulting
+	 * in quirky behavior.
+	 */
+	return !ioapic_in_kernel(kvm);
+}
+
+bool kvm_lapic_respect_suppress_eoi_broadcast(struct kvm *kvm)
+{
+	/*
+	 * Returns true if KVM should honor the guest's request to suppress EOI
+	 * broadcasts, i.e. actually implement Suppress EOI Broadcast.
+	 *
+	 * Historically, in split IRQCHIP mode, KVM ignored the suppress EOI
+	 * broadcast bit set by the guest and broadcasts EOIs to the userspace
+	 * I/O APIC. For In-kernel I/O APIC, the support itself is not
+	 * advertised, but if bit was set by the guest, it was respected.
+	 */
+	return ioapic_in_kernel(kvm);
+}
+
 __read_mostly DEFINE_STATIC_KEY_FALSE(kvm_has_noapic_vcpu);
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_has_noapic_vcpu);
 
@@ -554,15 +587,9 @@ void kvm_apic_set_version(struct kvm_vcpu *vcpu)
 
 	v = APIC_VERSION | ((apic->nr_lvt_entries - 1) << 16);
 
-	/*
-	 * KVM emulates 82093AA datasheet (with in-kernel IOAPIC implementation)
-	 * which doesn't have EOI register; Some buggy OSes (e.g. Windows with
-	 * Hyper-V role) disable EOI broadcast in lapic not checking for IOAPIC
-	 * version first and level-triggered interrupts never get EOIed in
-	 * IOAPIC.
-	 */
+
 	if (guest_cpu_cap_has(vcpu, X86_FEATURE_X2APIC) &&
-	    !ioapic_in_kernel(vcpu->kvm))
+	    kvm_lapic_advertise_suppress_eoi_broadcast(vcpu->kvm))
 		v |= APIC_LVR_DIRECTED_EOI;
 	kvm_lapic_set_reg(apic, APIC_LVR, v);
 }
@@ -1517,6 +1544,16 @@ static void kvm_ioapic_send_eoi(struct kvm_lapic *apic, int vector)
 
 	/* Request a KVM exit to inform the userspace IOAPIC. */
 	if (irqchip_split(apic->vcpu->kvm)) {
+		/*
+		 * Don't exit to userspace if the guest has enabled Directed
+		 * EOI, a.k.a. Suppress EOI Broadcasts, in which case the local
+		 * APIC doesn't broadcast EOIs (the guest must EOI the target
+		 * I/O APIC(s) directly).
+		 */
+		if ((kvm_lapic_get_reg(apic, APIC_SPIV) & APIC_SPIV_DIRECTED_EOI) &&
+		     kvm_lapic_respect_suppress_eoi_broadcast(apic->vcpu->kvm))
+			return;
+
 		apic->vcpu->arch.pending_ioapic_eoi = vector;
 		kvm_make_request(KVM_REQ_IOAPIC_EOI_EXIT, apic->vcpu);
 		return;
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 282b9b7da98c..fe2db0f1d190 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -231,6 +231,9 @@ static inline int kvm_lapic_latched_init(struct kvm_vcpu *vcpu)
 
 bool kvm_apic_pending_eoi(struct kvm_vcpu *vcpu, int vector);
 
+bool kvm_lapic_advertise_suppress_eoi_broadcast(struct kvm *kvm);
+bool kvm_lapic_respect_suppress_eoi_broadcast(struct kvm *kvm);
+
 void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu);
 
 void kvm_bitmap_or_dest_vcpus(struct kvm *kvm, struct kvm_lapic_irq *irq,
-- 
2.39.3


