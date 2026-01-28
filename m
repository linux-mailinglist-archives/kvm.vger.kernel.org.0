Return-Path: <kvm+bounces-69297-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OHHQOihleWl1wwEAu9opvQ
	(envelope-from <kvm+bounces-69297-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 02:23:52 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 011DA9BE2F
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 02:23:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5E0153016ECC
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 01:23:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99F52226CFD;
	Wed, 28 Jan 2026 01:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dJF/jnK6";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="zmDbLwW7"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58E9DB640
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 01:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769563423; cv=fail; b=fMtAfz96qO1goJvIH4Fj2PSIQKunAvOhFlCMP7J0Br0npJ/askwZ8BaoBBAIWm5wUT+NWt/18J3IPVNBU9Yok+pJA6EVW4iUyfk6xyu2qG962pdX+IEMkgB7dAocaZ0sCVe7xwetoJzz3FsfJ22Z8GX49BMwFTBNvMXWIMHfMvc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769563423; c=relaxed/simple;
	bh=vRVjAGTjp+sg5Bir/ePfAD37I/gioGfZwkAFjNuusNY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Q0CBQPO5lXNgQ3/HJmp3LzxET9I2fb1V478vqQO0BCdcTKRNQOehg/Wm9o9+RNOl1eprGgOM383Mfv9iQaiI+h/CVWQS9hMOHRFSoIMoc8zynjBXNV/VfG0LBDIfZF1mtCBa1Ev4LrJ5ejJstbyG0kY9tybvwHOo91aaAQCRnJE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dJF/jnK6; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=zmDbLwW7; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60RNEOjj566861;
	Wed, 28 Jan 2026 01:23:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=5ZMRtz4gklfvnI8OioJr/dP8fQSk+T41hiEh3qbtbOU=; b=
	dJF/jnK6zyTutpkGxO0enHrIq75uR8gy3MjTZPEl8/+HsPhmkNADGUFMXIvpMftE
	S8omVvbzxqFt2QzxA1nPW9GSKF07RWegbK4zMpnUYhAaS95cjQNBq7ThErYwwJTG
	nSnz6DSVdoLWTwbfe0tWkpKTjTdP+7D+n9pVA50IQWRVF15VKsxCiCNBQ2g2fw/e
	K7VVwlebfKuhJKKpdHdw5iEzL289o9wpbppQ98KpgG40B0d/hFdj9SY0G/40jwkl
	VSYiI2QkOe2wdQ03caDDwld5yerUpGJks5wQFJ4xOOHGMjFwSg8EWoThB7H5+5ic
	vjQiLK9msYDX5fAp1BzxKA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4by5b689a5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 Jan 2026 01:23:10 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60S1IVAu019738;
	Wed, 28 Jan 2026 01:23:09 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013011.outbound.protection.outlook.com [40.107.201.11])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhfhxp6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 Jan 2026 01:23:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r5gVJoYO8fsMNTrBe4T10XhxIZ7moHcjEn2QaOxhCUXRwIIGNLOieehMz1aDNeaoJtZLUlOK/CxY7uAAXCWRVQkscDHkRFhgUU5BIrLbZ5RJgSxDUZ0PaZYyQy4P+3icDCqskjPR6Uv8ddC6sP2Bory90QUSiJKi+uDDYpNNxTPHJraq2SsL/0zQvJFipUdNcr69TgpPvkfhtNWDx3ylLjE+m5f97noEJQfefLcU4+GFT4tm/ZfbJMT5vEEVy/LIv3VSLjsc7CeOK4frA9WP2e461rMFnBHQ8hIB2wChl6hF2qSr6ZZfufueNka0IqYyW4plObOjiGOBSfTjgl1B3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5ZMRtz4gklfvnI8OioJr/dP8fQSk+T41hiEh3qbtbOU=;
 b=SvuKxvlplX702sWJkMHUctltTTjVP1X7iSql+BeOQs9I+nUZOgMU1b+hEnKOvKCUjuS9kdjjBpq63tsWC3y5a1kYvVE2fFxI+9Bh9PE1B1Far1ZVLymK8aZQRaUYBPD4gDZROgPejg0Hec4N2o7JxcYorpEr+Vw6yJF5Q6CmXGbaaOAgfCNW0ZUy4NsdIAdpQBCGPZSS7IrUimg2DPh4aqueFhWSKOMJkff8WF/5IIATja6K6JBNiEU1QKQruhDLY2h/5YII7by/W+RrZMSqGF3MH9G5Iig1pT3z6WP0bO+m+XA19OUcOdJrgnrBuVh49FIpN0nC6RREvXIqJXinsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5ZMRtz4gklfvnI8OioJr/dP8fQSk+T41hiEh3qbtbOU=;
 b=zmDbLwW7DmCgD6F5iDP/cg24my3fbxAhfeHTOBhVhIlYTJevJ6Sk2qdbb0NpFxZMswqCS3tt2K9mC1AfRyd6X0g95UgzIjm28yAJwQtbkhu9vtqY93W8o1n6Ag6J5UhGeamlC+kWPtluOF4MZC81va88xFgQwIlgjsB8G2CLBy4=
Received: from BLAPR10MB5041.namprd10.prod.outlook.com (2603:10b6:208:30e::6)
 by DS7PR10MB7347.namprd10.prod.outlook.com (2603:10b6:8:eb::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.12; Wed, 28 Jan
 2026 01:23:07 +0000
Received: from BLAPR10MB5041.namprd10.prod.outlook.com
 ([fe80::2c19:641c:14b9:b1b4]) by BLAPR10MB5041.namprd10.prod.outlook.com
 ([fe80::2c19:641c:14b9:b1b4%4]) with mapi id 15.20.9542.009; Wed, 28 Jan 2026
 01:23:06 +0000
Message-ID: <2c9396a5-e967-4a8d-8e22-85afae4e8f24@oracle.com>
Date: Tue, 27 Jan 2026 20:23:01 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH RESEND 0/5] amd_iommu: support up to 2048 MSI vectors
 per IRT
To: Sairaj Kodilkar <sarunkod@amd.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, vasant.hegde@amd.com,
        suravee.suthikulpanit@amd.com
Cc: mst@redhat.com, imammedo@redhat.com, anisinha@redhat.com,
        marcel.apfelbaum@gmail.com, pbonzini@redhat.com,
        richard.henderson@linaro.org, eduardo@habkost.net, yi.l.liu@intel.com,
        eric.auger@redhat.com, zhenzhong.duan@intel.com, cohuck@redhat.com,
        seanjc@google.com, iommu@lists.linux.dev, kevin.tian@intel.com,
        joro@8bytes.org
References: <20251118101532.4315-1-sarunkod@amd.com>
 <2440cf13-e4d4-4894-b41a-fbdf7cd9b3b5@amd.com>
Content-Language: en-US
From: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
In-Reply-To: <2440cf13-e4d4-4894-b41a-fbdf7cd9b3b5@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PH2PEPF00003855.namprd17.prod.outlook.com
 (2603:10b6:518:1::75) To BLAPR10MB5041.namprd10.prod.outlook.com
 (2603:10b6:208:30e::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5041:EE_|DS7PR10MB7347:EE_
X-MS-Office365-Filtering-Correlation-Id: e82a0952-34f9-49e4-dba2-08de5e0bca5e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bjJ3SnhzN3grcXpZZ09RRXJpYzJsWHFsY0Y1d0ZkcVZvN2twa2VaNERFRnBL?=
 =?utf-8?B?OXZQditjMVFSOExBYXFwTnBhdkdTeG9iMW9LeVBCNTZvQlB5WEFYMFVjekZY?=
 =?utf-8?B?L2tLSnB0c25JOGlKT1ArK2Y4enRjNWtFcDZpVmphdWVsT29OUG1mVzRBMFYy?=
 =?utf-8?B?WE42anlXc0YxRGF5aHY5VTVISXVBSXBJSDVmSVl4NUFEWU5Cb3M0N2xERXlh?=
 =?utf-8?B?SExKZ2RlVlBqall3dUU3akoxcDdwa2VmQ3BmWlMySVpYQkVkbDBiNDZWbjBK?=
 =?utf-8?B?K0lsY3M0WUVVcTVNYk5wMDRwcTB3MDFNNTlMdXpseno2aTkwNWZBZmRxcFo0?=
 =?utf-8?B?SDM2SzZPMUhOaEJ5aHVaVHVRRUVHbnAxRmM1c1QwQ3B4ZklBTkgrSUQ3Sm1v?=
 =?utf-8?B?NVlxQldVQUxOUlR4TUtIT2RxYjhSd1NhNHJseUNIb1NYZWtmRjFOa0x2VE5j?=
 =?utf-8?B?b1VyM1dsb1pudjVVQW1GeXhkbjh1UklFOFlXekdqOXRPQkVjN0UvSktjUjlC?=
 =?utf-8?B?MkZteFl0cGxUWk1yWjBpckt1eStDZDZIRzYvbTN3ZjZpWE81aFNyTWR5L2Y5?=
 =?utf-8?B?Z3dmRWZBR2JDUDhYU3BXOGFTNE9PMkw1T3QyVmMzbFZ5YlVYK3U5UkdzY3ds?=
 =?utf-8?B?YnptUm9TS0FML3BmWStJVlkwb0lRTDRCU0tVVE1leEh2OFNoSzVrYityQWRX?=
 =?utf-8?B?aFh4eXVRL3JlYnZkN2FPTnhkUWlkSVJYaTY0YVdvV3VacU5PTlZiRktkUlRz?=
 =?utf-8?B?VVJzTkNKS2xPbWlkYi9Rb0lZbVFyalBqMkEwb2FRMEd0Z3B4YUZDZjdqUGUr?=
 =?utf-8?B?TFJBSC9uMVJMdFdZbHAzVCs1Qjlqcy8vaVVONjNKWnN3SktabG8vUEZONEk1?=
 =?utf-8?B?eFluakxBN25LbDROY3hERzF6T2Z4aE9TSFVQcXc3Qy9ZMVpOTEk2Njl0M1p6?=
 =?utf-8?B?Q3E2ZmN6eHpHM1NLUm9QWko2N0FZUFlydnlvTStaYzVITnVXYmR4UW8yTWd6?=
 =?utf-8?B?R3NMakVkSXg3NUl0d21QMllZQ3FHVkZlbDBySHRPWUZaVjJMd3l6bTJFL1Zs?=
 =?utf-8?B?VTN6a3Y4Zm5HZXhuWnZDM2N6dkhZMHFPU0Z3RFIzMVJaMkcwY0hBRzdNeHJz?=
 =?utf-8?B?TTNyNHVRQ00yZnBPZFBlRHBYek93c1g1NXpQdlkvanlYbGEzQ3lUU0tsZVow?=
 =?utf-8?B?UEJqYTU2QTZyWC93UVRQVDEzUVJCMVA3Z1UrcHl4d3BhYlYzdG9hSEFSUGxH?=
 =?utf-8?B?U3ZFVlgxRjFDMFRTb3VVc0FrZi9WZldiNGVMVE9hQi9CUHhvd0NoTWtJWjZs?=
 =?utf-8?B?MVRRSkhBeTdrSHg5QjJOSEx0ZENiMmoydTFqbm9XNElvdC9GL1Yrd3lsdUR6?=
 =?utf-8?B?cDZIaXhudllHck9MZ2xZV0NRa1g5MHJBRWJnajdQV2xRTnhrcnFLdkpGcDd3?=
 =?utf-8?B?UVlGS3dLdWpXSlI0eU9yZERZTTk4ZGk3WlhFYW9HSGswZURSTnBDS29YdmI2?=
 =?utf-8?B?NTBmRXI3a2xlQ3BKblMzdmdTNmhKenFMdHJjUEkrcWtkTTZUQlZ4T1g2c3RU?=
 =?utf-8?B?andLQUFyZ000Wnh4VnBFaktGNnd6T2Jjc2lxL2c3NXJ5ZzNOU05rUFhCbzkx?=
 =?utf-8?B?T0pGTDAxeVd1NC9ESGR6cVFhcVRMcEg2NE80WjhVaXdIVUtpQS90aTF5a2lh?=
 =?utf-8?B?Q3NNM1RVUDlLaFNFS1RUQU9keFcvUDh6V3h6MXA4bU5WZkEwV1pOKzFzc21t?=
 =?utf-8?B?Umh0Z09LcHNMYVhtZUJaZmtRQkx4ejF6UVZEZ1lNRDVFSVVMYzUxUklpTHpP?=
 =?utf-8?B?dnJ3Rkd0aGJLbHdOMTJhaXR2TDVCSDhMSXppUGtlVkJmeW9ZYktuQ2RBRmI0?=
 =?utf-8?B?NkFJM3pUYVdaOVpaWC96QlRMYWUrNmVxUStzU3BtditnRWNZVXZ2VmVTL2dk?=
 =?utf-8?B?V29WVXk1SDRndDVxV3RwSXYreWVCTmdLWkNKOVZFTk9FY0ZJQjBneHl2SThq?=
 =?utf-8?B?V0I3ZU9KUm1BZXFUeWUxM1dsT0YzMXNlT1dzRUdLelFOMEZpM3JZTExiOGor?=
 =?utf-8?B?RnhiSzgyYTRjQndaaHpiK01rUi9WTm5vQnFXZ0gwc0dTV3hQdDk2OW1aeVBQ?=
 =?utf-8?Q?QSMUdNTRdpdhwHQ7UEjuPNTJT?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5041.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?UE90UE4wVFZzdHB2UkF6alBTbWtlQXZ2QnlZa3JyWklLb010SVFxSVBCakVz?=
 =?utf-8?B?WXI4TTNHTllyd1F3czhTYVp1eFNNM3lXQ1JkQkpSK0tyd20ybXl6WVZDQUJN?=
 =?utf-8?B?UXBaU3ZxUDBlNXI1a0QyNWVUdjZwckZHUGh3Ykk4L0RzWHZSZFlhK2xtcWJM?=
 =?utf-8?B?QTNaejd6aDJtOU5odWc0T2MxRzZqcUVGcjROSDNkSS90VkFvM2doejJxbnE2?=
 =?utf-8?B?bGNGVTNGMmxVRm5aZ0dudUdWZlVJRmhoWkRDTlZxWlowaS91Y2NzMjhuWFNI?=
 =?utf-8?B?U0hZUGpiR3lHSFF4VDZQZmE2eUFlNUV2a2t4OVVMcXBNZXlsWVNpaVhBRUlZ?=
 =?utf-8?B?TW9FUjRGR0t3a2xCaEtuOWRRNmxRaDdTaTM2NHBCYjkvWFE3L3o2cjVIME1r?=
 =?utf-8?B?THoxZzY5NWFIWSt3QWpTTkdEL25abkNWV1M0RDU2UlhBUTRNR29DWlh3OFEy?=
 =?utf-8?B?cTdhei9NOEdjZkl1b3JPTW10a0REY2x4TklSOVZxaWpZVVgxcTUya2wyUW9L?=
 =?utf-8?B?bjBmcmJPSUdHWTFINTFPR1Y1OWhaMkpzNGdudkRqR3d0V09pc016MzM0MkVH?=
 =?utf-8?B?dWdUTEYvWGh2cXlNSDUrTFo3azNic1J3SXVMM1BKcEZ4cC9NTkZMYm9QYXJG?=
 =?utf-8?B?NG5FT0tGQ1RzbjFUQ09hRHNPUGlVS0JKWlFjbEozUWF4emQ3aTl2dmJpZUhZ?=
 =?utf-8?B?L1dBSHJDeHlvUVJCU0ljYzF5dkxid0xMckt4TTBnYThOd0RUMzRwdG9BdkFq?=
 =?utf-8?B?SkF3cGdSMklLUVoyUVBtTE5pWUhCdm9XeWtHS2pXQ0xXNVpPU1JlalBRWTEw?=
 =?utf-8?B?bHprVm1qVWtSTGg0ZStHczJOdmtzZERYVGJwOXp3WittSEpMTEg1MkpMVjNK?=
 =?utf-8?B?MGpJSlpBS0VKWXJXcG5uU0NtWG9URnBDY251MWV1NDlVNG1xSmQzT2NhemtH?=
 =?utf-8?B?RjFVaUU4bE1sYU1FMUlqc0pvc0tJYzlMTXAwTDRyRTN4Nlo1bW5URXJzVnp6?=
 =?utf-8?B?TFd6b1NXZ0Z1Qk1lZVF6N29HM0FBNEUwMFIrUVR0V0dLUGMyR0QvL3lJM2RP?=
 =?utf-8?B?WVZZdm53MUY5Ykk5NWRET01qNlFIL0Q1cWxrYmk0OVVNTkZmZ3FkQ0JQeFZL?=
 =?utf-8?B?Slk4RG12dXdTd3RnWUlZd2Z3ME9WSkkvRWJxMkpKdHVCVWRrVTA5K3BUejIr?=
 =?utf-8?B?bE1RODExWDJqNXZ2ZDdpS0pBczNLbThOa0dOY2lMbEtiMWEzdjhRbVBKTThS?=
 =?utf-8?B?RE83WTFCSEJNV0YwY09lQmp6MUZPaXNOZ2xXZTlWYjJwbzNHc1V4d0xSWHVs?=
 =?utf-8?B?M1ZXR3VpNWx3YlVCMk5Kb2hsMTI3V0tVYlVYSm1NV2FILy84MmI2NXFvRE1X?=
 =?utf-8?B?U3pVWnFBN3A0ZkxLN1RKWC9WaXdHdEpXdFNrR09LN3NaYWFNc1BmS25JR28y?=
 =?utf-8?B?Z21tYWVISG1xMnA0U3Z6N2hVZHFtcE5Od0NkdTdIOS9kZi8yOGx3b0NRTVVW?=
 =?utf-8?B?YmhzTzN6ZGRtb2h3aW83dTBrQ3l1bDR0VDFDUDByOFNLRGRudXlkMnJIRS8w?=
 =?utf-8?B?ckg0cnJaMGYzRnlEWXBWZVZzM2FsbGxmdGJlWDRsdmFjTG44ZkwzMzN1azl4?=
 =?utf-8?B?TDF0ZkdJc3VWVmlMUXZoTU41S05wbktQcEVtdEdzYVZqTjhJOTA4cFNmUjQv?=
 =?utf-8?B?QXFKbWduRDZLK1lGQUh5a2J3UHRpYXBOa1RpdjVMWkRwcEFhbkQ5MWkyVk9k?=
 =?utf-8?B?dVljUWJvV2s2U2xNeFhDbmpFbk5mWkpGNFd0Z25JMGl1STN6Kzh1Q0hvTWZX?=
 =?utf-8?B?YThMVVg3b3o5SjY5QzhSbVY5YVJKa20zZ1hGaGlKdnFjVEUzZ1djWUhBNCtZ?=
 =?utf-8?B?UldqYWxEN1dTTXZPNm5wdFJpbzJFQmY2ZzI5NDZJbGRyOXhDQlh3YjYxK0lF?=
 =?utf-8?B?dERRU3BIaThtYitEU0V4aGpyYmJkOWt1SzErbllVMGlMbzdIdTVpNStxUDg1?=
 =?utf-8?B?TzBhSW5teks0bk13NjNkN2UvQngyTEtWNVBmVTNXN21Za28rNFFmMW92aWJp?=
 =?utf-8?B?eExOb3JOV3RtV0twZHZ1K0owWHljQ2QyeVVrVDhPVU9oVHBWbzROUkR2dXkx?=
 =?utf-8?B?Umtuc3pNWThheU43UnBvUk1LVXYrL3hpTXc5Q0dobUpEbVJSU2J4YnpmbzQx?=
 =?utf-8?B?RUw2bEErQW55ak9Xc29OMHdGYU5SQ0hLaUZZcGE1MGM3NlhZa0Y1eVhxNUpw?=
 =?utf-8?B?UHhXMUNtM0JjR1UzaC9YRWw2amVXemlFR2EySnZ0cHBaSThNWC83ampiK2Fn?=
 =?utf-8?B?R3dOSGZKK0ZLK3VFWVdPYW1WTENMTFlHU2NPWDJDeVNVeUdNQ0dneFpjMmJk?=
 =?utf-8?Q?/iD5JKt3DWWPGiIw=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	xHOVy9f9156IgFpnq4V2teCTI2nlcEEt+B6Tl9mosP8wwkMucdY4iR6Qk9Wm/eslxyAO6L4xCiDJtpLa9JUSgfmh+kwYs97mWGbm2KrKF95H069bqSThtc9661BQ7y8wSVTnvkh0QhT0lYawBzSe3gBUSkEmE1ZWzbTTShmpmJzpeMC0xWi3NX6l45nUBx2edimxHvrPyqUO6GXgcuXdfzEXhcSlRUwx3HNwYGT6NiFXXemjVvyQVeNr5toUpU0uWJPSMyfV8IqeJQ2ROF/G/WklqjVUgKeihVP7DWMvMihPlRvi7wIlruOyENin/3EqABIMRL/gzMRWV7+UqfCRSjfS9a/Fsk8VruvbAyicS/8d8wOiVediIL4itwdaSOB5E8OUd4q8RY6my1Sp0kQOltMq/NLcjLTI5LyRenIuX6uqmH+D1Bqb6bDUX6Vcjhm0q7HWwoB4NFl5Tdb9KJoyv1kuad4HYcWdexST8ww3ydkndIQ8+LNw/e+WktobAMep1oR/l9ji4Us4xc0FuKlwQuLiwHE/rr6hjSIzqBdnjfx1++BIugTu4ZevRguXzEHlole/cwjFkqIHqYSIA97REdj2WGY26sgJEInNFT8igs4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e82a0952-34f9-49e4-dba2-08de5e0bca5e
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5041.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 01:23:06.8170
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9di6eHG7tZ1gTrF0rOcJaR60bSN46PIvzJwqC6OcXkpQJqmJET0Uz1o9fBog3JQ7ExQFZ4NtJELStYamDJczrNtqE6MYVaCOM0cyFYlOA/M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7347
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-27_05,2026-01-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601280009
X-Proofpoint-GUID: -uM2HMqXxbeWwxygGCbuGCM0dy90q2p8
X-Authority-Analysis: v=2.4 cv=OLQqHCaB c=1 sm=1 tr=0 ts=697964fe b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=zd2uoN0lAAAA:8 a=uQTHwiPSqmYELLZNr8EA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12103
X-Proofpoint-ORIG-GUID: -uM2HMqXxbeWwxygGCbuGCM0dy90q2p8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI4MDAwOSBTYWx0ZWRfX0kt8/JwkegUJ
 qdP37mTbdtJNTnpvBJL8b1Twu6rJDGa2/70KpjsUBjTjn44HJSQdpG9eBcaVOFiYAyvdw3NeWKU
 RPu413x5AhOiSRfOhdLxYBnF3E9/wSHF/gL1YpwjlKRdyVQk9DzPW5iM8tLI8D3vDJAbLuRmMb4
 g9Az2ivqM27smDvjYhdRT5fJboG65ipVO/xYz5ZUJJ0Ub3+eQvUZ0vpkPnYrQeQmMaLygPZwLCY
 T/Su9g/I92rBjSBGGIW09TA9JEm8yLmsWhRZ+4gEf530uPZWkbCb2ev7eD1NO9N5cu5ERb74Ptw
 5aEp2mc33kt53W+6zs+bQxdaPIRuvBtaJc9V8rPH7hWqaalXcDQ2MLEZjWB9gv49P5kqoRwspxG
 0Ne7SL3gsZgTpCii56S+/MO3nI8pCUP0pyAE5+0QfFIot21nn8ta0sB1Xz4KzBz6BIdO11LPkWy
 orYqXBEHNk/qi2+FvGtYz4N955VsksKL5t6eh4OU=
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[oracle.com,reject];
	R_DKIM_ALLOW(-0.20)[oracle.com:s=corp-2025-04-25,oracle.onmicrosoft.com:s=selector2-oracle-onmicrosoft-com];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69297-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[oracle.onmicrosoft.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,oracle.com:mid,oracle.com:dkim,amd.com:email];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[redhat.com,gmail.com,linaro.org,habkost.net,intel.com,google.com,lists.linux.dev,8bytes.org];
	DKIM_TRACE(0.00)[oracle.com:+,oracle.onmicrosoft.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[alejandro.j.jimenez@oracle.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[9]
X-Rspamd-Queue-Id: 011DA9BE2F
X-Rspamd-Action: no action

Hi Sairaj,

On 1/7/26 1:09 AM, Sairaj Kodilkar wrote:
> Hello all,
> 
> Gentle ping,
> 

I mentioned privately that I am investigating the main
limitations/alternatives that are listed below, but I don't yet have any
suggestions as to the best way to move forward. So while I am still hoping
from feedback from others in the list, I'll reply to this series as if it
will be merged using the current approach.

Thank you,
Alejandro

> On 11/18/2025 3:45 PM, Sairaj Kodilkar wrote:
>> Resending this series with KVM and IOMMU maintainers in CC.
>>
>> AMD IOMMU can route upto 2048 MSI vectors through a single
>> Interrupt Remapping Table (IRT) entry. This series brings the same
>> capability to the emulated AMD IOMMU in QEMU.
>>
>> Highlights
>> ----------
>> * Sets bits [9:8] in Extended-Feature-Register-2 to advertise 2K MSI
>>    support to the guest.
>> * Uses bits [10:0] of the MSI data to select the IRTE when the guest
>>    programs MSIs in logical-destination mode.
>> * Introduces a new IOMMU device property:
>>          -device amd-iommu,...,numint2k=on
>>
>>    The feature is **opt-in**; guests keep the 512-MSI behaviour unless
>>    `numint2k=on` is supplied.
>>
>> Passthrough devices
>> -------------------
>> When a PCI function is passed through via iommufd the code checks the
>> host’s vendor capabilities.  If the host IOMMU has not enabled
>> 2K-MSI support (bits [44:43] set in the control register) the guest
>> feature is disabled even if `numint2k=on` was requested.
>>
>> The detection logic relies on the iommufd interface; with the legacy
>> VFIO container the guest always falls back to 512 MSIs.
>>
>> Example
>> -------
>> qemu-system-x86_64 \
>> -enable-kvm -m 10G -smp cpus=8 \
>> -kernel /boot/vmlinuz \
>> -initrd /boot/initrd.img \
>> -append "console=ttyS0 earlyprintk=serial root=<DEVICE>"
>> -device amd-iommu,dma-remap=on,numint2k=on \
>> -object iommufd,id=iommufd0 \
>> -device vfio-pci,host=<DEVID>,iommufd=iommufd0 \
>> -global kvm-pit.lost_tick_policy=discard \
>> -cpu host \
>> -machine q35,kernel_irqchip=split \
>> -nographic \
>> -smbios type=0,version=2.8 \
>> -blockdev node-
>> name=drive0,driver=qcow2,file.driver=file,file.filename=<IMAGE> \
>> -device virtio-blk-pci,drive=drive0
>>
>> Limitations
>> -----------
>> This approach works well for features queried after IOMMUFD
>> initialization but cannot handle features needed during early QEMU
>> setup, before IOMMUFD is available.
>>
>> A key example is EFR2[HTRangeIgnore]. When this bit is set, the physical
>> IOMMU treats HyperTransport (HT) address ranges as regular memory
>> accesses rather than reserved regions. This has important implications
>> for memory layout:
>>
>> * Without HTRangeIgnore: QEMU must relocate RAM above 4G to above 1T on
>>    AMD platforms to avoid HT conflicts
>> * With HTRangeIgnore: QEMU can safely place RAM immediately above 4G,
>>    improving memory utilization
>>
>> Since RAM layout must be determined before IOMMUFD initialization, QEMU
>> cannot use hwinfo to query EFR2[HTRangeIgnore] feature bit.
>>
>> Another limitation with using the control register is that, if BIOS enables
>> particular feature (e.g. ControlRegister[GCR3TRPMode) without kernel support
>> QEMU incorrectly assumes that host kernel supports that feature potentially
>> causing guest failure.
>>
>> Alternative considered
>> ----------------------
>> We also explored alternate approach which uses KVM capability
>> "KVM_CAP_AMD_NUM_INT_2K_SUP", which user can query to know if host
>> kernel supports 2K MSIs. Similarly, this enables qemu to detect the
>> presence of EFR2[HTRangeIgnore] during RAM initialization.
>>
>> Although current implementation allows 2K MSI support only with
>> iommufd, it keeps the logic inside the vfio/iommufd and avoids
>> modifying KVM ABI. I am happy to discuss advantages and drawbacks of
>> both approaches.
>>
>> ------------------------------------------------------------------------
>>
>> The patches are based on top of bc831f37398b (qemu master). Additionally
>> it requires linux kernel with patches[1] which expose control register
>> via IOMMU_GET_HW_INFO ioctl.
>>
>> [1] https://lore.kernel.org/linux-iommu/20251029095846.4486-1-
>> sarunkod@amd.com/
>>
>> ------------------------------------------------------------------------
>>
>> Sairaj Kodilkar (3):
>>    vfio/iommufd: Add amd specific hardware info struct to vendor
>>      capability
>>    amd_iommu: Add support for extended feature register 2
>>    amd_iommu: Add support for upto 2048 interrupts per IRT
>>
>> Suravee Suthikulpanit (2):
>>    [DO NOT MERGE] linux-headers: Introduce struct iommu_hw_info_amd
>>    amd-iommu: Add support for set/unset IOMMU for VFIO PCI devices
>>
>>   hw/i386/acpi-build.c               |   4 +-
>>   hw/i386/amd_iommu-stub.c           |   5 +
>>   hw/i386/amd_iommu.c                | 163 +++++++++++++++++++++++++++--
>>   hw/i386/amd_iommu.h                |  24 +++++
>>   include/system/host_iommu_device.h |   1 +
>>   linux-headers/linux/iommufd.h      |  20 ++++
>>   6 files changed, 207 insertions(+), 10 deletions(-)
>>
> 


