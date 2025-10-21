Return-Path: <kvm+bounces-60689-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CA1CBF7AB5
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 18:32:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 86A50500408
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 16:32:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBDC234CFB6;
	Tue, 21 Oct 2025 16:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UIWQG2lq";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="VM/AMH5G"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F4472DECB0;
	Tue, 21 Oct 2025 16:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761064318; cv=fail; b=Hx6/d3e6r810sSFP5Gpfs2r0CrQOnQkkdwXMRHk/iuiW69qI6cXapZAnbBCNGP2bMpks5VWlUJqVm3M61WBtuKhPxJlMAjh89hAJQBq/XMbAyRKKVehv94TLLpCaH2F53isA6+X9UkrM/FMHIU+bghFloSe7Sq0KEK4QO/R3kUg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761064318; c=relaxed/simple;
	bh=jPu7+91AKZ02QwTGkAdX1R9aOTxDYWfzAuYd+f+pYvU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=QwZXVt1fkldAtkhG+OFjzTpjAxix9TleqBo9uxrFXL36ScscLIz8aKRhUBmcK0faDTpzyyn07W8nua1Em90mJ+3PPApaS0uCAjYBsDPjPTitDlNFV+xUfnihhl0QhHi9sNdBPtfvFOEIXAZTclDBYZoqxrY3KoR9hJlWHAAsLrs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=UIWQG2lq; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=VM/AMH5G; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59LEJ78O008700;
	Tue, 21 Oct 2025 16:30:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=UY8A0MlzlSNajOMH8M
	BBKPHyovdFEHqz8Y5PVPdECqg=; b=UIWQG2lqkN0NIJd0meGCGhmnx71eCEn6RT
	zR64jypuD11zoizTLLw92VBFRo0Nu79VZnuxVGAyvIHOLn0dfn66kpOjRwLZZnQl
	uNZRbijzeJYAlw99qlzxrq4xw0g+6G5cAsEL+TBgtX1UcznDkMXSbzGSc+dIMaM1
	qME3wINNsUmG9J9yBSRzfGVEOdnL4Mg8j57UCNE8doC+DND38NackTYku1GaYNxU
	Vx4JOAO+CQLU+jo6YW6GpwniwJISZ8b4PwUT1xDYpDp77pzsciELeWCdg2cMbXqg
	8a+U3EZN04idqf/Fm6vX8LjIfQIwz5oNKlImY+IykSWoIyi9DQ0w==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49v2vvwuqj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Oct 2025 16:30:57 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59LFaIr3032353;
	Tue, 21 Oct 2025 16:30:57 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012055.outbound.protection.outlook.com [40.107.209.55])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bd3c0m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Oct 2025 16:30:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ruyx1Lvt32OxmKaohuHW4zTsKlQaiR/hMmuXUEvMjYpz9dQ34HDeEXkecWNrRjvlmrwRPPzybwiM1Xr70iKiRKrNFRfvFsZsQ7hHKN1TSDOz6qo7zV3A7tQXe9efP7VijYY+KhMSXnMZpy4gMLl3Vx1Wg81fx4yNMbT2BxKGcEaJOZTx4Xmv/8g97homyL7uhvAUqdznJGAfdGQwz+32HEYcgEOUVS3X2EvZ3S8HS3vmnJ4LJK7vOpgm/bvPoRfdS6FPnXvwIDe1MrekmGdK9PKaINxQpn/xSbfPFU17AUJIRuxUvfu8UWqJ2hlTSxs3MDwzG2NDQITprE5gmlO39A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UY8A0MlzlSNajOMH8MBBKPHyovdFEHqz8Y5PVPdECqg=;
 b=pnBghhkvgQl1MB5ME1zZRYAR7r2HL/EpywhdqVWMvjrwKEQzuIsnYJXDgvKnyYyIZdQOKdZDMTyGcDM+9uHV0fkC0RW6WsYVnB7mDyuwAtfS+LOcsCOOv8/D3bbuDt597+tE1sicFp42RepD3awM9GI6xssUur8m1vDwnh69kd84vjpuaElmWNEym+Awjeho0gfnrcoDkMgNw2NCixemZP58HjSCEPkQPdi6kacxMVN2RgF37XV0SWICSWr9nd13YLDWl6lSneHAyDg9/5Myt0mDrNwjMT55uBEqFqLx8epEgpPH6Hzwd3TZTFlwqCdKiUOylppOnT3M8FeVbnbqhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UY8A0MlzlSNajOMH8MBBKPHyovdFEHqz8Y5PVPdECqg=;
 b=VM/AMH5GpYEkeQR9QU84QDPCHXNo1a6oWkXdhXvkyl0Nb5kqlODGqOCUWiszyb13u1JHn7i8PgfYWMSrnLufoZ6q76AuzB5f37q4ZC5fy7qXN7++I1jUWmrJKOwBhBLkpQdnuvu8Bh1UdbUyPUdrHfFg6QowlgtkUDmMgbVwQzs=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by DS7PR10MB5200.namprd10.prod.outlook.com (2603:10b6:5:3a6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Tue, 21 Oct
 2025 16:30:53 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%7]) with mapi id 15.20.9228.015; Tue, 21 Oct 2025
 16:30:53 +0000
Date: Tue, 21 Oct 2025 12:30:48 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: ankita@nvidia.com
Cc: aniketa@nvidia.com, vsethi@nvidia.com, jgg@nvidia.com, mochs@nvidia.com,
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
Message-ID: <hbk4hqrdaz7qipkpb5g2znhva63sghwsiqwlyf6pb6xccjtp47@vci5e4vbkjqo>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	ankita@nvidia.com, aniketa@nvidia.com, vsethi@nvidia.com, jgg@nvidia.com, 
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
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251021102327.199099-1-ankita@nvidia.com>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT4PR01CA0159.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:ac::21) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|DS7PR10MB5200:EE_
X-MS-Office365-Filtering-Correlation-Id: 05aa6fce-decf-4d96-3598-08de10bf3410
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Bao5ZPLQkjhr1K/cDyfcenete+qWrGj0BuvHXEPI1ofvCdNrm5wVZdD9ET11?=
 =?us-ascii?Q?J0QmIdRI+gHGluyQ92//WOPIbIYdXlqOsy0TuTE1E27ljjgscpz60pRMn6hw?=
 =?us-ascii?Q?nMkGgFlOHdS1npFahh4S+fQLphkUfM+YP3+tCg9IYk5ZP5aK4f55XGy2aE+8?=
 =?us-ascii?Q?seV1mVXsxOs0UBs5xJsWzi6E6M6Iv9njQpZfwBZwoNM1DfqQkQ96h5FgDccc?=
 =?us-ascii?Q?2GlAh+gWQT+nvMeqooOgaUbhH3Of3ONeh+0q0Xvnlg25f36Q56GUqmEpod+h?=
 =?us-ascii?Q?VQuly1JcYvEcAkSSjgPoWbAB+1bhK0kMxoMdVBhhkbtKDMiA2P0vLs9RKZXH?=
 =?us-ascii?Q?dUnvo5tGrIRRCP63z/fwQRRdYW2WW7T7wtSuwu+pJjCTuS2o1FrFEIAj/6Sn?=
 =?us-ascii?Q?yg71c+JCd1IAECWTjLNa2v4IC+OKKkVGrvgDueqzMRGv2lzqC9t+V29liKc4?=
 =?us-ascii?Q?O2U1kkMXCqEbXfyNtcipL7rNdfp+yWJ9IZxgNWkitpDBAq+AAW7+4pJPzgIq?=
 =?us-ascii?Q?Py37tIVOt6wdaBqMhRa2P8ocT+3lyn6W7JPkmd3Sw5k2RKemu6b1XtoRkkRQ?=
 =?us-ascii?Q?bZ1D91ihf5MLkD3l516japNiWi3Si3VpuiO+xvUkH9H5uFY0Y/z88TflP61D?=
 =?us-ascii?Q?J7D6ws73IC0nXATdLi3HUpij2uUY7YxjDjjGjxTGb0zoqAkFID69YNLBRKtm?=
 =?us-ascii?Q?Ppja4Q8vlIka2oJG3gN/4s08/2ypmyaudMkdIJktpNyRydwWan98RT5OZvPJ?=
 =?us-ascii?Q?j8MBbqVoCJ//riMPNUWlxXAQ6B3PKwKZBJupTyvW2g2McUMqrLCnpIwqJFPI?=
 =?us-ascii?Q?LlRlYOoKMUSbl6/8Vp/COz9tYMAUstS6XBodXMt8S6AkuRgCYAVg6CyDpzml?=
 =?us-ascii?Q?mGYdMMVG+zUiIsZ2ociVTFd9VE9S3ovoB08RwtY1aylmOTUTve2v5gb+QI6x?=
 =?us-ascii?Q?kXNWuc16abLI5Xj5VOYDmkDNCvQpqvEtUnsTF7UjHAYItuon5/v/VXjgeCk/?=
 =?us-ascii?Q?DGUco0HwWxcooU+Qc218cQNak3SgJcbOyiJPmxZZ+bN/41/6ivn+f8mnAxi9?=
 =?us-ascii?Q?CzbFyciHGaoFOVu01O8NubjQD4AWjCCd3xtQL7y6pDYfbDH0oSNqBZ11My+e?=
 =?us-ascii?Q?WmsEBx4JVqXq+SR5nvM+W34/w8WaimQhxZym8bQAXygLfSlPDJmRGzwzN4vt?=
 =?us-ascii?Q?ae7pPGDdpKsdUE8alUuhMgEG9yCBo4WBIT+UPIULNXvSobrwszBuZgO6oSu7?=
 =?us-ascii?Q?JtOofj5VaZaz37hTjHtbwIHesJPJNjE+XEMMQjadl8KtOL2ohzMcHgPE2f2+?=
 =?us-ascii?Q?kV/GwFQp5b4hloITA7UVV7Z2l/zsivEASubDV0QvMObwSNq8JMffi01gYEP5?=
 =?us-ascii?Q?Qta0GGm4etgDdzX4EoziQalGx9cLuBNKG1pVBcB+canD43mKhS8O/y/grOeE?=
 =?us-ascii?Q?olnIvzkEloYVPBBsSn9gQA9HgJUWQDwNS4XWFFpyW0N+5JwLLNZhPQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?f1J8XOYU0yJpKUlWhgsw8cpNo7MtJrwLRhi+Tv22I0XeKgkhym6Xbhp2jjp+?=
 =?us-ascii?Q?mOeUzl0f0lBbeqH5FTkpGXxyNdDCQjqvLL2+31nKKid+feJBvHuqKGRbeUx/?=
 =?us-ascii?Q?Gh88P8QYU6b7IoR3uPqE7CNy80EFwREHfditrNsqrxhwu5ZH2BnUO4QQcEmy?=
 =?us-ascii?Q?5bXkXoawZ7hXts9oay1fuwfoV6I9mU9E9MoiGVrrg2OroqKo3ZDOUVRww+rv?=
 =?us-ascii?Q?KxJSne+oDS+nRifJ9Nb4owGHNE7dkWe0ijuHpHhReKiuUdCZFQVf9jHDgRfF?=
 =?us-ascii?Q?IcdXv6QKq3l4liicZxf2BB/9zarn5cbxJNVPr7fJnbnG0InrC6AXI4Kwqdhc?=
 =?us-ascii?Q?Jf9YntKjkogp9QqwpnXCjZqR/CArgornhJDPdO4V0sW4yVquRXz8OUn8sJlB?=
 =?us-ascii?Q?vwX5JEL4pDxgDi4arkChNtXX8ZcAndDT7zq/x469BBH2UAf3jirfEuATVcNN?=
 =?us-ascii?Q?obuGQPI/HOdC3R1i5BSIwBOThT0EY7GLslwx1A9gto7951trs3pOZeBLqA0Q?=
 =?us-ascii?Q?FiZKoERz+36wMCjR8oMnSSXz3Gij3sd+z1H54yLFHQldhytD4bRB+X7gw3CD?=
 =?us-ascii?Q?yLmFvsLeqv1XMRoWKJwL1HFfnEYZNV7sIWyi/Fi34IQpSSftSGucGNFiq+Ht?=
 =?us-ascii?Q?YBCYVZzDCQNOVhLujrLFqhzEdkWtUuQixjMvyXAbhAklm/F4KBNsuPD0KEX1?=
 =?us-ascii?Q?7rRjWvOtDbY2Rz0CN5rZlsV6rTIRFjroVU+yQxYbCbKtoFH+Jh3fEMAPKzRr?=
 =?us-ascii?Q?X/VJ4hH8QIQXB8mzKPoG56Vre1IvEvNVLq/7VU/XiZUOzgX1zQ5obLpZBj3+?=
 =?us-ascii?Q?NR06Cdc75uKSPhz09OgoK6yqsQbFlBCMfvW6F3gi+obKevXhCUMN4YQwEn/Y?=
 =?us-ascii?Q?PAR0THB9PZbpQrjEvFj9G14oKxE22JdyxKr0KNggPHG+uXkn+ZPovQpZx3HB?=
 =?us-ascii?Q?rKybp5M5Enbw22A2TFtsTtlyMlnWtW9qPumaWI8Vx6R4JlCY5fdL2dNr8F2R?=
 =?us-ascii?Q?KOeM9F/ReA8Dy8gEIi7uUol6vK8TXhF9EtPXpXZuPW41Z0UReggZzzjUNMQ2?=
 =?us-ascii?Q?HCXRiFqQlR8c1HANIDXr1PlNLS/xp5tUpMXASgJjbagimIzoBjNd+YXIHGhz?=
 =?us-ascii?Q?wbalVnPq/Eg4lz0iaOWwenADjz9l+T1Q+WMJfnaF88AkEmuzeHrNp0pRGTkE?=
 =?us-ascii?Q?qYMoGOepCbNzJWC9lmS18MdoheverknFntACFGJpAI62FI7nTpX2R1UPz8G9?=
 =?us-ascii?Q?YOzsTDxKWKvROfaBd7xXdGv/LDKxTYpsfExQUVjDk9vK/v+GeCAsaUhmpxaA?=
 =?us-ascii?Q?TqWNP9BmG5KJ0XeFjL7+umwxMS5z/03Gea1uqNikraLai7sWUoHnN0qczkPZ?=
 =?us-ascii?Q?f7qjIc6GlOZuG00kcAWLgZO0V3WTxz1nAYkbVdSSMNffiRE4xqsSokyk8wSe?=
 =?us-ascii?Q?4sL9QwpOi9gwqIlqom1t6iXyr1cVJ+2gwHT4Vd5fAGXgUR5z2g0qWKRqRZYc?=
 =?us-ascii?Q?M0O0nL/NcCb+XyxgOwZ+nVeUGrTuB0ZYfIXNM8MIbF83nXbKR8FlVyQMH4ia?=
 =?us-ascii?Q?ms+AnFsWGXnrRyzz/z2H1SRFry9BeKOb4IAE9HOr?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	JWCfL+OScUTomgoq9N+jBC5BHrih/Mhp6BfpP+QAz7w/zMrV0/7pjUeySw1LOJgfcc0ulr07Ftx122P+AOReIeloUwfjsHgU9zFRMPjHFnZsIOyMWmlv+swq/1wkGVx4uLEu/PY46GFnpiylWej1uPmGaCIlX7Dt9HHubzoJ18LsF4TXAnNOV3arkrszdzCa/8tqmmMsCffKjYusvnsnehwNyTNdirpQiibI91OYOopF7ve/IPAhcKA65LzLOUz2qPuvRdRQnrNbxPxh9YYMBZynsG+jBnuk5ZZncpDtRUWqIUCpaiNscXzk+thgq5ctQu3C+y16lrWXMe8PVm7v1C4MZZJepXgi3YqrK9Z+JmnVv0HHISyG/cXqFSk1ql3KmjbhOWzaox9TpuOb1TUjyn6idu2f3ZQiqWUdIq8DB3GawzGFQ/AM3JYVVdoaYVAb86L1zID6q8HYukbtK1kRnVuygysuXgrSBNfV2m52e9aGMSdEuM7EaeYd2biKOtiU6T9y+ZMlkkklHwqMgrnQRLpBx5BH4AL2mQbybNjXQw5m1wKVOwHTAcQv+i5IkOB7eCUmwMpiKS+Th5OLDRqxzn7Y/za5iHrVhJYYejOcFk0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05aa6fce-decf-4d96-3598-08de10bf3410
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2025 16:30:53.3476
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N61XBdTXC+/O65dIOuW53R2CqE5dZ8YViQHOjz/ZGnWk+DwpUFac1hX0M2VaeVzTvu7WDKQ4yXbmikPn3jyuYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5200
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-21_02,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510210130
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMiBTYWx0ZWRfX85BDOT/UuMyn
 CLYm3GqqGVAJ1SVL+xTQ5gcEl1J8XrjA4XCBD8mYg6ajxChEkgnEkEGsuOdHGP4yE0Ff6AwxYVN
 HaKopYgrZvomIHH8F2OG3CdT58CrgdKZQszvCoTsHqV4XV1pYralNGTsif4tM4Nq49wAKjbgrpE
 maeTOjA+eh1o3u3IibGwUcI3zFnm3wpJRMywdrd5/G7K7eqLr+oV/GOU2QNahM5DA45RhrK6zz8
 t548b1AqIAZNINjGnyJI0PXgmVL/6vAFmMp04ckyD3y8ac1GIKp5DmMSYrSi69HP38cJtj1XUco
 xo3euTBj104G/risNBw7JHpU7NOWMCErupuq1lrvCuiaDhPw5rTVtOCuGQ9cfUlfQT6N6hcVEnm
 TjUNKKN7bjDsKbJiZprn8h09I9UlPKJuxISBmzEo3o/Zv7DTYBU=
X-Proofpoint-ORIG-GUID: rGW3NoSjdcWAio16ssA4kuAMG8Ena4N2
X-Proofpoint-GUID: rGW3NoSjdcWAio16ssA4kuAMG8Ena4N2
X-Authority-Analysis: v=2.4 cv=FuwIPmrq c=1 sm=1 tr=0 ts=68f7b542 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=Ikd4Dj_1AAAA:8 a=20KFwNOVAAAA:8 a=_XWUyoS_VYGkJN1oEXQA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13624

* ankita@nvidia.com <ankita@nvidia.com> [251021 06:23]:
> From: Ankit Agrawal <ankita@nvidia.com>
> 
> The kernel MM currently handles ECC errors / poison only on memory page
> backed by struct page. The handling is currently missing for the PFNMAP
> memory that does not have struct pages. The series adds such support.
> 
> Implement a new ECC handling for memory without struct pages. Kernel MM
> expose registration APIs to allow modules that are managing the device
> to register its device memory region. MM then tracks such regions using
> interval tree.
> 
> The mechanism is largely similar to that of ECC on pfn with struct pages.
> If there is an ECC error on a pfn, all the mapping to it are identified
> and a SIGBUS is sent to the user space processes owning those mappings.
> Note that there is one primary difference versus the handling of the
> poison on struct pages, which is to skip unmapping to the poisoned PFN.
> This is done to handle the huge PFNMAP support added recently [1] that
> enables VM_PFNMAP vmas to map at PMD level. Otherwise, a poison to a PFN
> would need breaking the PMD mapping into PTEs to unmap only the poisoned
> PFN. This can have a major performance impact.

Is the performance impact really a concern in the event of failed
memory?  Does this happen enough to warrant this special case?

Surely it's not failing hardware that may cause performance impacts, so
is this triggered in some other way that I'm missing or a conversation
pointer?

> 
> nvgrace-gpu-vfio-pci module maps the device memory to user VA (Qemu) using
> remap_pfn_range without being added to the kernel [2]. These device memory
> PFNs are not backed by struct page. So make nvgrace-gpu-vfio-pci module
> make use of the mechanism to get poison handling support on the device
> memory.
> 
> Patch rebased to v6.17-rc7.
> 
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
> 
> Link: https://lore.kernel.org/all/20231123003513.24292-1-ankita@nvidia.com/ [v2]
> 
> v2 -> v3
> - Rebased to v6.17-rc7.
> - Skipped the unmapping of PFNMAP during reception of poison. Suggested by
> Jason Gunthorpe, Jiaqi Yan, Vikram Sethi (Thanks!)
> - Updated the check to prevent multiple registration to the same PFN
> range using interval_tree_iter_first. Thanks Shameer Kolothum for the
> suggestion.
> - Removed the callback function in the nvgrace-gpu requiring tracking of
> poisoned PFN as it isn't required anymore.
> - Introduced seperate collect_procs_pfn function to collect the list of
> processes mapping to the poisoned PFN.
> 
> v1 -> v2
> - Change poisoned page tracking from bitmap to hashtable.
> - Addressed miscellaneous comments in v1.
> 
> Link: https://lore.kernel.org/all/20240826204353.2228736-1-peterx@redhat.com/ [1]
> Link: https://lore.kernel.org/all/20240220115055.23546-1-ankita@nvidia.com/ [2]
> 
> Ankit Agrawal (3):
>   mm: handle poisoning of pfn without struct pages
>   mm: Change ghes code to allow poison of non-struct pfn
>   vfio/nvgrace-gpu: register device memory for poison handling
> 
>  MAINTAINERS                         |   1 +
>  drivers/acpi/apei/ghes.c            |   6 --
>  drivers/vfio/pci/nvgrace-gpu/main.c |  45 +++++++++-
>  include/linux/memory-failure.h      |  17 ++++
>  include/linux/mm.h                  |   1 +
>  include/ras/ras_event.h             |   1 +
>  mm/Kconfig                          |   1 +
>  mm/memory-failure.c                 | 128 +++++++++++++++++++++++++++-
>  8 files changed, 192 insertions(+), 8 deletions(-)
>  create mode 100644 include/linux/memory-failure.h
> 
> -- 
> 2.34.1
> 

