Return-Path: <kvm+bounces-60706-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6912DBF8291
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 20:55:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 112D2423501
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 18:55:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCC6234F24B;
	Tue, 21 Oct 2025 18:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LDVTXiNN";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="LVtJoZRq"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34FD834C14C;
	Tue, 21 Oct 2025 18:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761072917; cv=fail; b=FdXyEXL+pCs9VyWBTSDO8nl2a3giQTIjjEhShz7AKElmpNOgPXcvMEs2BLWV15ywtzG0ujsLcvF1U403gC66O+Ddtpd24foov719cqncNqMPAQHlPSmqQJtVREWarBCTlGR7jfFvDBc6GFwDyLlwBMCUm8CzkiS+k9MBwbOlnrE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761072917; c=relaxed/simple;
	bh=5Xb0hI5upbzse8ha59BicbYb7A6iYe5MzOSeauO4RDw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Iii0dLpvqfatxEBaETNZLeDM5/YiO0jlyhR0wf/zmkh/oO5e92yZrmUIu4UVN/WrGdtczLtxUgbl53D4YnAVjTFvLzLM+eHUShu7svoAOShOXiwfCFC3KxWvKWLorynoUmgfzGxNGe9xHIXYg7Nck4QDJMe23b+yaaghVuuM/0g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=LDVTXiNN; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=LVtJoZRq; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59LGvxqr018699;
	Tue, 21 Oct 2025 18:54:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=iRlSe1NbsF9XIurQUj
	yy9qMEYZNXI4ZWR7/C5qTRw50=; b=LDVTXiNNtPSWEwYcthfmkbsGFX8N/jwNvH
	hrdNNCleeroXYHyCeMrHaf6cEtGbVXDuxTfkm7FPnogc08H9K3rwlAhoGQW0nNe5
	/vEpZLmJarPcZr+bbpI0QwHfVhstqkLBVwVhLcxWwf+WANU3poYcKMY2RhQX6/0x
	VrG5r0qKyiUCAOyfM1agn8JHCoR8YPN30zF/RFwxQC84qfqtKUF4S10Vxa2gGyBb
	PxL28gs9g4/V8VbdvnJ04PIPEK1KiR6qtkfBoCg7vqhRAJd8BDgfkue/qP4L+FQC
	LpBCjHR44Qw9ssL78H1MDyXTwtVlcVFGz8BKuRGIvdwM9nG8P4fg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49w1vdnat9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Oct 2025 18:54:24 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59LHAACM009516;
	Tue, 21 Oct 2025 18:54:23 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011048.outbound.protection.outlook.com [40.107.208.48])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bdfmt5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Oct 2025 18:54:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SxlEcuiGF5UGDWWh7MYOVSNKZzfkUeLcFN85RWazkbfzfDhEre2TNU6J/6tiHtGJn3262Y5SeHsAHPfLJfOK1tamiZ/b4I5WyWSjnqlMe/VpX/fDGAPImVGgRkX16DkotSzvmec9kTw/sGitJ8p6eNorxf6ic/dB4urLVwDo0MIiLFVDWNJDF2nRmqqw15LUxtE5XeJiyw/RCRVqOWIwMMHsnbnbiz5xdd/WAHirc9M0wrBodzSaYSmgt4buJl58vtnwjFpMcLkUSUfTs0lkPbg57+pzN+ktBzQZFsRNhILhI/b/ZM0QO0v2Dp7PsPHqk/dlqc2zDhYi0xTyQyMobw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iRlSe1NbsF9XIurQUjyy9qMEYZNXI4ZWR7/C5qTRw50=;
 b=faLxDRucXYEr/8NvuWlM8sX7960IC/4UviVMvG5gY5WZEJE2fRhlGkaDuuxrrnKYHHfkfZg6nuShKISN8kjVbAGSqpspZBxkO1+fVgSzL3CGMBIge71ehSV3TkmGV0J8kMikhZ4V0qzv1WRtDNBFT32yiU0LBlm2l0SmQ4435qPiOY03YDILese4IyzyxsUVhQ1lV8Adio1n6BvA2PcJDmZ1/2+qyRQZLq7yTR+jZ+gisgQhadVid7XsxWl2RNWswN7jxNIUgqxU0KvAlH0AhZBkHzvXZj7/Y9dsNKNlCO4xJsAQbJ/2dY3A6pCSYKiIQ0svPben+bc6mUyGDxrCaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iRlSe1NbsF9XIurQUjyy9qMEYZNXI4ZWR7/C5qTRw50=;
 b=LVtJoZRq+4WoUfwNl1ch/giRwUgg1hm6D5TaoeQsXBxRyoD/ewxoSk95E/dwOZtFCWjfB2qDBQRQc1auRNNi5YMuoPZcXR95BETtmVEBIiXn025GrB/dhK60mbNGAUBDpb+kAXXotfBJ3aZRCg2iBKKYk7aSsHjlsSUarY7qmmc=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by IA0PR10MB7274.namprd10.prod.outlook.com (2603:10b6:208:40f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.16; Tue, 21 Oct
 2025 18:54:17 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%7]) with mapi id 15.20.9228.015; Tue, 21 Oct 2025
 18:54:17 +0000
Date: Tue, 21 Oct 2025 14:54:10 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: ankita@nvidia.com, aniketa@nvidia.com, vsethi@nvidia.com, mochs@nvidia.com,
        skolothumtho@nvidia.com, linmiaohe@huawei.com, nao.horiguchi@gmail.com,
        akpm@linux-foundation.org, david@redhat.com,
        lorenzo.stoakes@oracle.com, vbabka@suse.cz, rppt@kernel.org,
        surenb@google.com, mhocko@suse.com, tony.luck@intel.com, bp@alien8.de,
        rafael@kernel.org, guohanjun@huawei.com, mchehab@kernel.org,
        lenb@kernel.org, kevin.tian@intel.com, alex@shazbot.org,
        cjia@nvidia.com, kwankhede@nvidia.com, targupta@nvidia.com,
        zhiw@nvidia.com, dnigam@nvidia.com, kjaju@nvidia.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-edac@vger.kernel.org, Jonathan.Cameron@huawei.com,
        ira.weiny@intel.com, Smita.KoralahalliChannabasappa@amd.com,
        u.kleine-koenig@baylibre.com, peterz@infradead.org,
        linux-acpi@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 0/3] mm: Implement ECC handling for pfn with no struct
 page
Message-ID: <3ss3epklrmwallhd3nih5qqzjk53dcgns5igudtsg4vnnyjyri@ektyavsup6wk>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, ankita@nvidia.com, aniketa@nvidia.com, vsethi@nvidia.com, 
	mochs@nvidia.com, skolothumtho@nvidia.com, linmiaohe@huawei.com, 
	nao.horiguchi@gmail.com, akpm@linux-foundation.org, david@redhat.com, 
	lorenzo.stoakes@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, tony.luck@intel.com, bp@alien8.de, rafael@kernel.org, 
	guohanjun@huawei.com, mchehab@kernel.org, lenb@kernel.org, kevin.tian@intel.com, 
	alex@shazbot.org, cjia@nvidia.com, kwankhede@nvidia.com, targupta@nvidia.com, 
	zhiw@nvidia.com, dnigam@nvidia.com, kjaju@nvidia.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-edac@vger.kernel.org, 
	Jonathan.Cameron@huawei.com, ira.weiny@intel.com, Smita.KoralahalliChannabasappa@amd.com, 
	u.kleine-koenig@baylibre.com, peterz@infradead.org, linux-acpi@vger.kernel.org, 
	kvm@vger.kernel.org
References: <20251021102327.199099-1-ankita@nvidia.com>
 <hbk4hqrdaz7qipkpb5g2znhva63sghwsiqwlyf6pb6xccjtp47@vci5e4vbkjqo>
 <20251021164444.GB699957@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251021164444.GB699957@nvidia.com>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: MW4PR03CA0051.namprd03.prod.outlook.com
 (2603:10b6:303:8e::26) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|IA0PR10MB7274:EE_
X-MS-Office365-Filtering-Correlation-Id: ea816e9a-643c-4926-1e5c-08de10d33c7e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Yu4Dwj2TVj79vzsjWSDVMptwScNxfThafqo8eF65dskDEnxo7nRtObWCiui+?=
 =?us-ascii?Q?cQfiEVa6Hfi0Oh55GINw9tDgmxwMxJIBzY/cs2wU9NFEwgrWOibj4Pb9yKoF?=
 =?us-ascii?Q?cP7k6r98jTeT1GumLIFHcB3sSAvU3j1txkz1UfJSqwoFVjtJGD74VwjMOMVr?=
 =?us-ascii?Q?kAn4HqZzuFu9LOSKpyVaHtANS0YoZC645YVNXoLGWHqH7x+fUALyFKHM0npU?=
 =?us-ascii?Q?fytBcnb8SFJyUehONNf2eil6iPnFJUQi2ab4zVZayKjzZtJI9fcEs2Oxk4Ie?=
 =?us-ascii?Q?RohDAsU76ddO1bgCaTP/YmWh+RO98thVoERAXjU/A/0f5gzzj8cekjKmku6g?=
 =?us-ascii?Q?K8qlgbGMhnLffQSkrwTE6NQUAydyXHCJbJ0oXC+8TUEmGZbrm6EN//54RODF?=
 =?us-ascii?Q?N8Q/X7a8Gu0qTH0Io7vai9dUOb65XDs8wSHE/XveU8du9tpa0hgJKvMVg6ZI?=
 =?us-ascii?Q?Jh1RICGWYvGIhK7iYZiISPKo9ygarmrovfveLBlpw9keCLUZZWNrCk+FbsWY?=
 =?us-ascii?Q?/fKe+z3k6DJuMKtm1xaSr2P58/IPor+gUuNO+hl8qNJ5DuEC9QU+Ordb30YS?=
 =?us-ascii?Q?KxBr66Gxm8mpKS4hOncZyGuo/Jd1vTKjH6rCVLuQ5T45ZGMgNeSRdZtgI44f?=
 =?us-ascii?Q?vsbEzsOFUhaFiA9BJc23Zb8KoJ18kidAgVgeZNdrRaZlKvDl5DVWS2uYR1BZ?=
 =?us-ascii?Q?1o1s7t/XGVkCm2DV9Dfh338JmAlzsoSG4UmDUVGI/AHkXWBUp3v4nSw0QAsu?=
 =?us-ascii?Q?GA1rSU22IPWEvXA3cTp9PuJohFbI/9BLtJvMXppDpodEaO8zyVP1NSQY5gm2?=
 =?us-ascii?Q?3iXxM1Ys8MxG93fGbaT3LqWITNR0fhPw88DEibebb5rIiaFzvoASHk1PUGyj?=
 =?us-ascii?Q?s6t5XTFIPnTxXKyfAf4qP07HAdz7DrgwB6Q+HocKkAELn7PyPZg0+Gl1MmIQ?=
 =?us-ascii?Q?dPk8KvsqR6hHP/ihSRaDVDgPHDsC7OsrLmireX/dDo86Q9cPU4KZHDZWtJE8?=
 =?us-ascii?Q?MLuUAvLLaVNF2vRfhPbL3CKbbqLsS4Mm+L+qN92qw1sx6wxUcG9CJer2HRvl?=
 =?us-ascii?Q?8HNkRvx6lpxo8Ddv0niP+yOqOvW+jV/9hCGBdEbXR1w1ft3ZGomQQOjYR9te?=
 =?us-ascii?Q?9xpZpwRyYhP2abmluS8rDoWCo3eNEEy58UzfcDGXvUsNHMTAiskL9ik7tGwk?=
 =?us-ascii?Q?LW5P4F73GzRcf9ADpRmvO0Yrl7vlwpvc2L6IS1tH7tPLWsIwCllByYiib97k?=
 =?us-ascii?Q?QON/HYVdC5fd8TgWhxjmeyUqX9xT/EsevOlv7ecXFj+bvnJ2rF0OEky6vkEi?=
 =?us-ascii?Q?TAGw3NubIY6m9cLDOYhCigczyudd9n0+0f2/QlB7a3IJc2QnoaSpXKBMf+vo?=
 =?us-ascii?Q?WrVrJSqGPvzxL41srVBpyhJ0Zy3jxzAamaJ1NdUzp2NOZvEbFbwWHtw9rdHi?=
 =?us-ascii?Q?eon9k1GTPaHtfVEXwldZ/8XN2SLPX5NA?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?heMIazuNKBmSz8ghw3d4lmdBnw13If2xAO25W1acprCYLbbbytmawbsQO8lI?=
 =?us-ascii?Q?Y4XMHreeQn4W8Hdkxmv7dSkUxBL3opjMjgHoqTxR9DrxRN2H4vPGRSIuPvaU?=
 =?us-ascii?Q?6t3fp1CpgS0S3PbrPl0ybvEOIXsu9XM3JE9RmMMv8Krik+RbJz1aILw8q0RO?=
 =?us-ascii?Q?EcNka6TNl5TnELOAcLHRPQcxjbC553CIVHGJ3Q4Fqj69HaSn0wSCCQ0fVxhr?=
 =?us-ascii?Q?NCxjVQkCbnbS/jIhTyuSEwNkw46dwMnNaMElnV/xHIPI5rgAEgxJtnL5UlbX?=
 =?us-ascii?Q?KiuIjb9oueEwUgke5km1UrLGwoG3DOuMIKlw3qepYW0j+DYUzY+9ZjySNVKA?=
 =?us-ascii?Q?vDvMeEe0mHMuFNOhVkFbWBoy7BxpRzSzRft9KP2djbaT+CI0+chBujqMp2Ij?=
 =?us-ascii?Q?iQ36/Ly6a4gz4i0CC2OdIM30cOqYxVshYENWCg832JWaz/dSvTO4WzSrjD8u?=
 =?us-ascii?Q?8osnzjM1uK7wnD+iRfYdmInAmyc+owSNPIXqeVh2B8QDPaxRUONtzNCL+4iU?=
 =?us-ascii?Q?GBT4ZB5huVukdwc4rp2RtOgZ8G8pbZbmYLpjkgfmLgnxc0z3ViekvzW/9d2M?=
 =?us-ascii?Q?VKirG0XZE8xPbpbMvnrZal+SGKJDZKy+DZH8Mg8AXtFvbisW4nksMrCkolZC?=
 =?us-ascii?Q?d9kKBGW50A02YssZ2ehyqlfg/STWeI+ibXjFFez/b8degiI9rV5oTqZe4CWe?=
 =?us-ascii?Q?prIvRbVg7yYXxX+V1UuHDRsyhsTxNOslsNTMGqMN0DG9+jBFgOqF48/O9/p1?=
 =?us-ascii?Q?TWqIuyAwP7C/fQ/NZLeppKNIfbqC/97OiIozx5JfoHmusFeIfLpLW+2wBE6+?=
 =?us-ascii?Q?Me+Fh0xot8Dj0cYN/aC6d9Ee6R5NH8n2JzNPVwsKlXEL1Av2B64eI8EQe2+F?=
 =?us-ascii?Q?dv9Not7V0lhljhOd9XMkELzYGWkFYJbdjMHbctXJxQCUFXfmzY5SM4wp+XCR?=
 =?us-ascii?Q?Lg57EgiS2o/9YINQhR5ceRlbeZIHwppWcux3dZhjKEjW0wZud8srrhqGTigr?=
 =?us-ascii?Q?Izzhw4ttStQcko5kljznzUiT9qPbbv5FsmJWJ1jlDKyZnJ8AxLOjjA6MErrc?=
 =?us-ascii?Q?D4GDp9iU12DoAmAEzJreeCOJYypvlMO+1pnuBAsmTDLAU7iERJtLcbU6OjI0?=
 =?us-ascii?Q?oCXyI5bnbsAfqn4wFiGR8ofRXJRS1t4xgq/gFVM0+JccHRmhHXdLhZzivMI5?=
 =?us-ascii?Q?yqusTP3zquiuewYgqn3JVTq1Mi4Ic//cX1J2ge5+E5AEMlaAvzjcXEYDW5lx?=
 =?us-ascii?Q?fnTKwZSorh+zyFKw2SAqgdREGD5tDajqbkkH1mgkGOC+5ZKR2+I6tO5GJG0x?=
 =?us-ascii?Q?fD88lfim3G5fHYxxD3Z2XlipW9CBWO8LZxF5UdsjIK5KpMJXGN/4mQ91F7YU?=
 =?us-ascii?Q?F6gFRVkF9me8d3h3ZWw90m56CC+/9HaPc6VVjP8/vz8hRxMXDd3YJvGkXqSD?=
 =?us-ascii?Q?fa+Xv3KFQskfJ25jn8dMznUq6C133hWy0mQDoxNfEruoXY5TPnG72v7fLAb/?=
 =?us-ascii?Q?P243IRlm7vP3H7ag0OJyq4GEto1jCQHkAha+gSVwdlJ7pz4iUJcDWo961LU2?=
 =?us-ascii?Q?oNq5irIQhlfF18XPE5ad4gI6ne5ctI5kcYwz0Fuf?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ogEdNY6OKpnFfzgiqMpqxkQWEraprBNPZdfv6urVGR7Ds1fsPVDA+g3ueSTOH33ddHDovyTO8NpnqGt8StxdLcYFfICZd/f3r9rD8ukt9S0ihnQLTsSbtOs9T8ujFgs5TtxPKHeugu8b8B6hsDg+8cJquSb1cdxF5eNdqbgM9wHj7PpR13WNOlXmBEiPrq4UssqnQynXhDk6CPDMSsE4cZK65DtaLDCMfd6LFZMsKlt2660gH6YytSupkVJG1/x6M6WZR/wdaakaTTNm3YwjgUDdAQPf8kh3pzuvRN950mpTxzSpAR+5LiRiGbhcxfXC+K3Hk13KpI2Dyz/mi3soRkSO/H6/iou+Om6f2YvNToe5bSvEPI24exMCcoYMESuZAqVIyBAMDECn0EcTHCPDjACm2vagQBZb1q0ruS8S8HDdF0ubtDJRpX/X9RVMszaGCfaXTvKGrMS5VaRTDmCkEorooLfU/b7S6AmVbMbGvguGUVpi07ggxbf5YmByHvK0sfHn9K16VJCFpQWJldMK8uhdpFuLWH39leEdA4YVNy7zvaowNfIXvLKRCH7a80flrgOLGLGjYRsYnpGwLHX/qIMuPruq9AipCRaKPBPE6qg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea816e9a-643c-4926-1e5c-08de10d33c7e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2025 18:54:17.3743
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tIZYzKx15Gz8yMsQaZ342lfLU/IdenJDh5bJFE9UZrvNDSD00RrT1UD/P8zTUg9YEyZhUBilOkDedaKywZ2o0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7274
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-21_02,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 mlxscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510210151
X-Proofpoint-GUID: YE-AI7XiaMcyoY4hZm2S1alPeJgs1Kwb
X-Proofpoint-ORIG-GUID: YE-AI7XiaMcyoY4hZm2S1alPeJgs1Kwb
X-Authority-Analysis: v=2.4 cv=WaEBqkhX c=1 sm=1 tr=0 ts=68f7d6e0 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Ikd4Dj_1AAAA:8 a=PNYUstft4m0ZqH4jSeQA:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:12092
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE5MDEwNSBTYWx0ZWRfXw8LSoS8MtkeE
 W5Sdr5QU52VlfpvjnQsXCHq736lRL4qKLYqSDSFKlcUkjMfTFQHkfqDEjqCYQ37mKgM6rpXZVx8
 JyABRXLAihtIPAcKHcyTmYKTOb2TS2qVCjzTdnOEumB0Orgk0r4QdnaGAhNnpqA/+eMuG32Z+B7
 9fMr6YPS4kU81IuZPbdA4YfVvKCUZfHlFLDQkE5mPcgxVkA1K6+Mph+PR3whht9ZTMVaFu+Z66t
 6RGt/2IWcnpz6BtrSujzbAWRwlaJz4s5JfuOezaYmfk4Et6tkXrRsIyAYJR/ux8BI0UQ1VmBCk7
 4R7kjfzZbWnaQdE1nEct0ZjX2dxatgohox31T1rzCcLWdsWreb8DHr2w7LMzEIuDAA001tp4ItT
 KsxCxUkXnXH7bga7i0APjBPlzfrZsFfU53UfgFRzkQxRWF5zCUw=

* Jason Gunthorpe <jgg@nvidia.com> [251021 12:44]:
> On Tue, Oct 21, 2025 at 12:30:48PM -0400, Liam R. Howlett wrote:
> > > enables VM_PFNMAP vmas to map at PMD level. Otherwise, a poison to a PFN
> > > would need breaking the PMD mapping into PTEs to unmap only the poisoned
> > > PFN. This can have a major performance impact.
> > 
> > Is the performance impact really a concern in the event of failed
> > memory? 
> 
> Yes, something like the KVM S2 is very sensitive to page size for TLB
> performace.
> 
> > Does this happen enough to warrant this special case?
> 
> If you have a 100k sized cluster it happens constantly :\
> 
> > Surely it's not failing hardware that may cause performance impacts, so
> > is this triggered in some other way that I'm missing or a conversation
> > pointer?
> 
> It is the splitting of a pgd/pmd level into PTEs that gets mirrored
> into the S2 and then greatly increases the cost of table walks inside
> a guest. The HW caches are sized for 1G S2 PTEs, not 4k.

Ah, I see.  Seems like a worthy addition to the commit message?  I mean,
this is really a choice of throwing away memory for the benefit of tlb
performance.  Seems like a valid choice in your usecase but less so for
the average laptop.

Won't leaving the poisoned memory mapped cause migration issues?  Even
if the machine is migrated, my understanding is the poison follows
through checkpoint restore.

Thanks,
Liam


