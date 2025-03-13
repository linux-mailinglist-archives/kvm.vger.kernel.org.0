Return-Path: <kvm+bounces-40877-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F0B7EA5EB20
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 06:24:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A5EA3188F6DF
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 05:24:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A2C01F91C5;
	Thu, 13 Mar 2025 05:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Xf98aaGh";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="dkFq/KJA"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66F2B8635C
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 05:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741843432; cv=fail; b=fG1xxjs9WtlRTxa16zv1CQX2bRiNRJ5FIW+ojJ+KH/uVEnExSql5AE8BwW5XseMJUBfEvUxrT7szQs19GZq1ISBc0qeV+gVIz3I2kFKFG028kZkXrGBPUT+UlzZ5g1i3rGvvik1SrVnaxEPXhObLfs4ZW+vSuh7BDPUrnh7sBgQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741843432; c=relaxed/simple;
	bh=6wXylgjiSNtmNqQCqfxNCfPZ/wXptf02jeUQlpRlHZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=JC/YWUbWRPeaZNhdja82T9BBUhzJK8JiF0IdjGjuKhkqGMQOTphOhtOforW3aVDDkTS2L0f2QmC4ycKiFRulfzABnRvgxbC+hHcKWAb+QNYZC9GXPBnW0WOIwPqNA5eWR7ERYKNc67kovD0FJZE1It4NMVgW88uhIpo/P69qf2U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Xf98aaGh; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=dkFq/KJA; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52D3uBjP025124;
	Thu, 13 Mar 2025 05:22:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=hcdzFMqVjPWQKhriYZOK6gLu6RwCQN0UuuZji+qxLKs=; b=
	Xf98aaGhaG73Je9fDAqTfCBmFDbu/lt4jROWRTuIdTl2ddSP7JCeKDgwmonJ6q8T
	RPufjcGEyZbJoGLLUdp1zzwWRmt+YkS1pjhYHc16yhCZeg7zeIdh4OqhzJXGglQa
	ha4kEyKlBx8tEbP9A2ItsFllTo3dD2e9pqAJe/ql7QmHDZiXW/2QBR2yIk6Lyh80
	KaxrUCRg9DBRHH3RiFpQfKJIaGNfFogFPeaXNFyScyw/36S8/6VgY10Y1zy3haSF
	upAK1cW2gXZa49c/2fWAAcZ3VYLNLThsSNHIcPUkR/F5vAc2jMPwmzSVD+zBRRiw
	z+hY2MxmoxVYfFn9pHkQvQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45au4dkf1c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Mar 2025 05:22:40 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52D3g3mo002143;
	Thu, 13 Mar 2025 05:22:38 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2041.outbound.protection.outlook.com [104.47.70.41])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45atn87qs6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Mar 2025 05:22:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UmjCRZ300RaqTYSwq4zCyXhtOpnTjkeLuSMyv2P10izRcBxyYKLRJDwSO2nQytwiNHapFEr+ufCF1So7KozdU56Yws6MBZ2WlTHwmEX04BjmdqHbs16PFbX/LP+01P617MyChMKq0xgH5CZkpK6KVoSPJU5taNVupeAphz1rakOwyRoa2GQaE+Ouzn8CVHhcLn5cqpo1gpE35M8vdgbB+iZCQ+oHc5Rp9htfcZ7Pbv/S9HafKClJ6V7ugXwxUBS9T1d7arWIr9O6t/enREhCVhni+uQcQaAMrb5WW2WhrbUECZnNubh4Wv+9xGx09N2mo0Y2qPGO5w1eZix7fYM68Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hcdzFMqVjPWQKhriYZOK6gLu6RwCQN0UuuZji+qxLKs=;
 b=LSW69rjVGJzDPaelUCxydv0GpNc35GbqBUy/Royc1Rz08S5ka68WOsxhxnTbtcpf2lsvprwLSHQmPNdFRLbQRuswj4PDxJ0HMExhWL028nxDyoaDFHR6vqw4w4RjMXioAhmMo/e3BqLoAtRJNZ2u+J8O7ZotN2UIQLb9ZPC/dnAVb4Fux1pXRX9GlrcsGIMnwqeIu+tYx7xTkI9YYaEhE9GEUq/3kzJXRQPUx1u8CWPh+gsln6pUkNBcxnpEW4vc46NL5wZJQoM+f3AI9sL/X4PhJjMNJ3BJxlXJ2NUSv54zIwUN0BJyYZIy1VYBdcyeChD8mQ/XY93eAkZIldQP+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hcdzFMqVjPWQKhriYZOK6gLu6RwCQN0UuuZji+qxLKs=;
 b=dkFq/KJAIdXEeDHJTAlydPTrrHl7s6NbIULZxjH6lwLyMA+8pwhWzhGj85mAYjgkZycYIBwmHpZJnzHWY1F2J8muBYCDcnlB0hNv2/cMizs4j1Udybx+GTatHbn4OsD1juuCJ4LFwFfxoOse492qHzVGhAcOdWjRptLO1SasoX0=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by IA0PR10MB6724.namprd10.prod.outlook.com (2603:10b6:208:43e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.27; Thu, 13 Mar
 2025 05:22:37 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%4]) with mapi id 15.20.8511.026; Thu, 13 Mar 2025
 05:22:37 +0000
From: Mike Christie <michael.christie@oracle.com>
To: chaitanyak@nvidia.com, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
        joao.m.martins@oracle.com, linux-nvme@lists.infradead.org,
        kvm@vger.kernel.org, kwankhede@nvidia.com, alex.williamson@redhat.com,
        mlevitsk@redhat.com
Cc: Mike Christie <michael.christie@oracle.com>
Subject: [PATCH RFC 07/11] nvmet: Add static controller support to configfs
Date: Thu, 13 Mar 2025 00:18:08 -0500
Message-ID: <20250313052222.178524-8-michael.christie@oracle.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250313052222.178524-1-michael.christie@oracle.com>
References: <20250313052222.178524-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR16CA0014.namprd16.prod.outlook.com
 (2603:10b6:610:50::24) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|IA0PR10MB6724:EE_
X-MS-Office365-Filtering-Correlation-Id: 1804c362-c86a-4437-d09f-08dd61ef1119
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?YjchA9JAiepVp9HpD9dzV1nKe6JrPKuwyh+Y/515ckHXG+n5vZAJcuVz4j5S?=
 =?us-ascii?Q?p/oEZyyEzsGXp69YsfUfTmzwTat/aeDbB90mWKoghKy60pbBQgn8XwLIXpgX?=
 =?us-ascii?Q?OBylj8gCQy8IFqMGaN2h+VYkkJFQmQOd4eIxyNBFUFX3IFxaXCyJSkzBnLER?=
 =?us-ascii?Q?i7EabVs2Cvp4C/azawP490ff98eiXwBMhprSkvid3dmIFPpLNJBBcuLWf9IQ?=
 =?us-ascii?Q?zk2WQDP3Wv1o6yrGItvhRgrMyyOi2XNbBjcZaZ04RVYGMR1NshekP7ykMxbP?=
 =?us-ascii?Q?OzwMfv+hyi+wND/IysG/klbWCvtU1JmQk/16iJzuH0Bxnq60NNPmZP1OEYdi?=
 =?us-ascii?Q?MuD3Ri/2iaknfcyNh5cub9ms4j+x6eCuppqrCs+K3PNopibcdRbQ7GdDF/La?=
 =?us-ascii?Q?cylJ9pz2F7S/HR4d8TZLyXPzJQ3eAmGt0QE40hSWENfpo0k4G+cyUowRww9u?=
 =?us-ascii?Q?ADbft1skyOoNcALaUkoICMTtr06hp0yA3UdF3sj1gP9cNGhxpYSWr09zIef4?=
 =?us-ascii?Q?c5mM1a1xHVbzMzAZn+4PotPTH+dLVXOyDDN2zXD0/Mlhr2g+I32Bw1YK1YqZ?=
 =?us-ascii?Q?l1wMcjqcNNOoO5eXoPj4sCfW36d98UPRAZbKw0H9qVan2qOgxUX3quKFvTUM?=
 =?us-ascii?Q?AZ4GhUIQBc389ao2wERq1Kr4VLxnS0zgI5uW5fEutGW8epkBGV43Mv5c3J+U?=
 =?us-ascii?Q?f2yKW50/ZJhrmME13N47z4IGu08H2BM3MgHGYuYBD8E/5yxi/zBrBtJgD6wc?=
 =?us-ascii?Q?jBSY3dKLv6Zi5BhY5eUruOUGHffxdV3aHimL7yfdSAKF1g/7OL/z/lONKsQL?=
 =?us-ascii?Q?u77B0OmLMhwAYW3dZ0Nooysw9ydlsdy5CnfSFsDQfa87lvRQMf6WODC5o4Df?=
 =?us-ascii?Q?qE5Io7mwExFHx1C8RUkseyNfk30UMbhN+KzMD8es40eRsP87tCFkeLwylFvP?=
 =?us-ascii?Q?JFD8ZjMKpH6/nlOhC5YmEJN/V6XsOjHiCuaE6oyGGgK44qKy+2JCnEG+0hsk?=
 =?us-ascii?Q?4kSLvK7I//LdLSJHwgomNUDRbQLGWhS6eXHEkEzR96rPM71SDNDI4xjSmHIc?=
 =?us-ascii?Q?XDNUTjNCt00HwdvgYesL68EGRerVoldgd2Z9N2oBAL2sxuZqJVbtUtFAvfFK?=
 =?us-ascii?Q?QhXQ9nkqbwKWwCMe2Djgoc5CrcBhSBJvlaaioQg6krt7tLmJyym6MnZk7CY3?=
 =?us-ascii?Q?j4CB9quavul5xcrWEwMafSOPIklX+QbFAJCb6P/Ep2ID6eIjoMy8CpEMsAbF?=
 =?us-ascii?Q?nb+Le9Iug6MEAjxPRYhfF1gZ4tRAP6YP2rF260DUfBloU4zd4jBKhxXBAtNY?=
 =?us-ascii?Q?IcTjEs/zoFitnO/ymIZ/pM5ykBEIR39KNK2hv3OuJMR9OFcvnt03GLB+7g8B?=
 =?us-ascii?Q?HmlqYiyDN75hBxWPN/Snfdhm8588KRC1MFlBeLkv3CRD4bIUrkQnA3viJZ4U?=
 =?us-ascii?Q?8+ObJiS/xWQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8KCotQkqutOnpFisZAMB1x6KQ7SOLa/OPOB58i1F7fGtK4DOgTMfw80jAEIL?=
 =?us-ascii?Q?Hlz4zKO4k7OGVMtuuLKEceThI/l3yzA7tcCRg9+rXMLIsbA1GdTGqfAtfyd4?=
 =?us-ascii?Q?ovQIrqpFqwnjsOVj8LIBCYUlJ3lGBszqaqI6icgd08O8k6jNDYNblaKEfw/a?=
 =?us-ascii?Q?Ty+1qeNCff7DZqNUCDxL1HvzbfpEvV8PDPVP2NLkb7lk5NsgAoU65W6NrY9t?=
 =?us-ascii?Q?SDJeS3nj36YOovyoHUrTscDDzvHLu9hkrC6J6XP9paH00Ypk8t8lZXDlnE/k?=
 =?us-ascii?Q?caGzxcBVoo0+K324wVqm1oMOG6JpOjWzSU6m89Z6PNrg8cmzX2wGH+f0JJuj?=
 =?us-ascii?Q?V+qz4s1J7/JOxJ9NCZ21FP7qspEk0LGjTUUqjsJCAhjoF+F3N8FDR3Dwbtak?=
 =?us-ascii?Q?ytA9xnvoe8ibLa6NTRQP2OQW9GJvngJ7sSO1539iETG4aT0PX+DtjW/XxuBk?=
 =?us-ascii?Q?VsJo+CoQQ38pgradvtmNhMQ5sjal5OE5QVrDDQPEhPOxfXvYQoQOrjJkxYg1?=
 =?us-ascii?Q?ZXcqxQqv/FwzML+S9wlSQJrtnP7B1Bf3wQWLRbftVy+TSvHI8z9xCpqC0VZc?=
 =?us-ascii?Q?2GhXwa5ywxwBkVn3zRFgW/suSYdT3aJ5laTMtcb10T6adUYcULqj7Rbje9PZ?=
 =?us-ascii?Q?w1qPlko7zj8QlKU/3dzXLec/gmxpTtVmBrjWSuW1WtadVPviweqbQY/+tgUA?=
 =?us-ascii?Q?g8MVhs3dvNo8QYa8jISu6aeLRorUx1U0C180T5ngxsES0hQX+JbVWMB35xBe?=
 =?us-ascii?Q?NdaHx+17QcB7p1jaC50BfasOxaz/bB1r0oJkBaiMORfjL+dXyP7fAc7ztNzc?=
 =?us-ascii?Q?1JJ18SV5S/djbC/lII5PzpGJcMmdGaAtTeAg45vju46OfLOJh3wfIWQERK/O?=
 =?us-ascii?Q?VV35hGblibBFieZG3YFAhr5aCbIyCenpYhQjg7O752Lr/w0wbGQNPx/1+nzp?=
 =?us-ascii?Q?JaVFPJtrFNAhZ8Okp7WUVGesJZqFb8Vy2BhkH9x8jXqt1gFGmWTQpWidePBR?=
 =?us-ascii?Q?ru6wt+h64aOuoHnv5BLwj/uLtW0hc+sYbBnA9Cwwn2KWJYIGV4giQCYYUiqX?=
 =?us-ascii?Q?SBKYC5f4wbxdI0R1NJbOOlPnzo19dfXjhGUHoXbIvZKN0ULkKXqQil8bp1eI?=
 =?us-ascii?Q?/fhRSPzYCgI1GhMXUb7CHDtwQbQ1C0u+7XMj0hBAW7881hSfE3YnBl3haDze?=
 =?us-ascii?Q?It9A1w+tdyt8+BS6cgZ2mvbXagDd62CLfqWT/WiZ1aeGJVgvaWGyckmpQtdW?=
 =?us-ascii?Q?D73iCwVM0rCEsjgY3phBolWspOXgyxAZOSc4stWA8/1HY5e+o3VpnIim0nI6?=
 =?us-ascii?Q?ZF2GvJElIxRGXb1NVu7yf+r8arMkWra0H3MQFH2u/Dco+WmMi2IpaJKLeDNc?=
 =?us-ascii?Q?BUeNP8CWIv+Dqfw66Hbxul4X8OC1Or7DNI8KGv51evHgyT7o/IBeiTobJyER?=
 =?us-ascii?Q?1+YpJzOIyPJZo9AUA6Q+I8RceV5iUf0HVmwdYNn1ukJ1X7IEvo1qdkxOl9vI?=
 =?us-ascii?Q?4MoqJapHSlt3xywBLgI1uS7Nw7IxRnK3iaXNWMA4WoP6vKA4gD55rO3AU3e2?=
 =?us-ascii?Q?CUudPNqvY1MX7Kc+DxvvnVMIXW19iikxQBiVbew/KRuCGkC1vMF2ggq9fFFP?=
 =?us-ascii?Q?sw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	GbM8OQPYYZu4A6H8t2w5L6Qpp7Pybc1bNk7UhlwcAaZkiIPsUEXROGRh+l633aRelq6w6OCtN/VdzuUh8dqdT9+FhnC+f+ReZn7pSmNpQnY/MYS5U0eVjEWkPACg16D3GGDKny70AConVbrd9OGUVjNv/uv3RLmXGdkftOD5XUBDFM1Rk25pI7it8N+8FoUKk8ey2Ke890fqTP6S33dLYF3Ohqfoae+ajU2kB368AeILhHgTN5d+gBgerO5kAXYRD8HW6oQBjUHzDnPOBcsVPtvxbVOjKuI3qMFlxp1Pd6tN6BYKAaAHb59PpXwROXHXh0RvqzeZISGpOa3SXFuoLCu91DkC+1no/q1Wnp4avmu/YI8VU7/ul0WSU3FVqXKoWanD8zBt3Re/Sk3fYZ5BwS8B8BJe+Pt7z8sUa/poDTTxQHCT5UStqT09qE7an7NQhq4siADYLIuMLFy5Ov7u94rM2jP9EgEu93FdesdC5RDsFie8RHtE629qII9ePjFzrtsTDHz0dkJ6vhtgEIs74zXYBPUi80gD7H5aID7D+UHpqZWvrJEuJ/BjkXZWA8mhqNhIFRyzwMABDmxhMCsypmG1d/5yAOtT9SWTtOCPaao=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1804c362-c86a-4437-d09f-08dd61ef1119
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2025 05:22:36.9616
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6wUMUkrFI1xiKVYCkQqqx3Wi7thC9UiRYMcBscLNKKmseOZDpluDw1mjT8YYCqKD0R3c3k/rvaKuN2QL2NM1T6fFCc3uul6xHyRM+getcVw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6724
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-13_02,2025-03-11_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 adultscore=0 spamscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502280000 definitions=main-2503130040
X-Proofpoint-GUID: s0DM4rn1R6X2mYOlPvghvSaACmmNKSel
X-Proofpoint-ORIG-GUID: s0DM4rn1R6X2mYOlPvghvSaACmmNKSel

The nvmet_mdev_pci driver is going to look like a local PCI driver to
the guest so this patch adds support to create static controllers.

Because the current code assumes dynamic controllers, this new
interface is a little odd so both can co-exist. There's 2 major
differences:
1. Instead of enabling the port when we link a subsys, it's enabled
when we enable a controller under the port (the controller enablement
requires a subsystem linked to it).

2. You have to make a controller in configfs.

You make and setup the subsystem, namespace, and host like normal.
You then make the port like before, but you now have a
static_controller dir under the port. In this dir, you can create
controllers and then link them to subsystems. You then enable
the controller.

Here is a manual (if we are ok with this I'll fix up nvmetcli) that
assumes the subsystem, namespace, and host and port have been
created already:

Here we create a controller with cntrlid 1 under port 1:

mkdir .../nvmet/ports/1/static_controllers/1

You then set the type:

echo mdev-pci > .../nvmet/ports/1/static_controllers/1/trtype

and instead of linking the subsys to the old dir, you use the
controller's dir:

ln -s ...nvmet/subsystems/nqn.my.subsys \
...nvmet/ports/1/static_controllers/1/subsystem/nqn.my.subsys"

You then enable the controller:

echo 1 > .../nvmet/ports/1/static_controllers/1/enable

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/nvme/target/configfs.c | 324 ++++++++++++++++++++++++++++++++-
 drivers/nvme/target/core.c     |   6 +-
 drivers/nvme/target/nvmet.h    |   1 +
 3 files changed, 328 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/target/configfs.c b/drivers/nvme/target/configfs.c
index 896ae65e4918..65b6cbffe805 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -1666,7 +1666,8 @@ static ssize_t nvmet_subsys_attr_qid_max_store(struct config_item *item,
 
 	/* Force reconnect */
 	list_for_each_entry(ctrl, &subsys->ctrls, subsys_entry)
-		ctrl->ops->delete_ctrl(ctrl);
+		if (!(ctrl->ops->flags & NVMF_STATIC_CTRL))
+			ctrl->ops->delete_ctrl(ctrl);
 	up_write(&nvmet_config_sem);
 
 	return cnt;
@@ -1976,6 +1977,323 @@ static const struct config_item_type nvmet_ana_groups_type = {
 	.ct_owner		= THIS_MODULE,
 };
 
+struct nvmet_ctrl_conf {
+	struct nvmet_alloc_ctrl_args args;
+	struct config_group	group;
+	struct config_group	subsys_group;
+	struct nvmet_ctrl	*ctrl;
+	char			hostnqn[NVMF_NQN_SIZE];
+	char			subsysnqn[NVMF_NQN_SIZE];
+};
+
+static inline
+struct nvmet_ctrl_conf *to_nvmet_ctrl_conf(struct config_item *item)
+{
+	return container_of(to_config_group(item), struct nvmet_ctrl_conf,
+			    group);
+}
+
+static bool nvmet_is_ctrl_enabled(struct nvmet_ctrl_conf *conf,
+				  const char *caller)
+{
+	if (conf->ctrl)
+		pr_err("Disable ctrl '%u' before changing attribute in %s\n",
+		       conf->args.cntlid, caller);
+	return conf->ctrl ? true : false;
+}
+
+static ssize_t nvmet_ctrl_enable_show(struct config_item *item, char *page)
+{
+	struct nvmet_ctrl_conf *conf = to_nvmet_ctrl_conf(item);
+
+	return snprintf(page, PAGE_SIZE, "%d\n", conf->ctrl ? true : false);
+}
+
+static ssize_t nvmet_ctrl_enable_store(struct config_item *item,
+		const char *page, size_t count)
+{
+	struct nvmet_port *port = to_nvmet_port(item->ci_parent->ci_parent);
+	struct nvmet_ctrl_conf *conf = to_nvmet_ctrl_conf(item);
+	struct nvmet_ctrl *ctrl;
+	bool val;
+	int ret;
+
+	if (kstrtobool(page, &val))
+		return -EINVAL;
+
+	if (!val)
+		return -EINVAL;
+
+	down_read(&nvmet_config_sem);
+	if (conf->ctrl) {
+		up_read(&nvmet_config_sem);
+		return -EINVAL;
+	}
+
+	if (!conf->args.ops) {
+		pr_err("trtype must be set before enabling controller.\n");
+		up_read(&nvmet_config_sem);
+		return -EINVAL;
+	}
+
+	if (!conf->args.subsysnqn) {
+		pr_err("subsystem must be set before enabling controller.\n");
+		up_read(&nvmet_config_sem);
+		return -EINVAL;
+	}
+
+	if (port->enabled) {
+		pr_err("Cannot create new controllers on enabled port.\n");
+		up_read(&nvmet_config_sem);
+		return -EBUSY;
+	}
+
+	if (port->disc_addr.trtype != conf->args.ops->type) {
+		pr_err("Port trtype and controller trtype must match.\n");
+		up_read(&nvmet_config_sem);
+		return -EINVAL;
+	}
+
+	conf->args.hostnqn = conf->hostnqn;
+	conf->args.port = port;
+	up_read(&nvmet_config_sem);
+
+	ctrl = nvmet_alloc_ctrl(&conf->args);
+	if (!ctrl)
+		return count;
+
+	down_read(&nvmet_config_sem);
+	/* Check if a user did this while nvmet_config_sem was dropped */
+	if (port->enabled) {
+		pr_err("Controller and port were already setup.\n");
+		ret = -EBUSY;
+		goto out_put_ctrl;
+	}
+
+	ret = nvmet_enable_port(port);
+	if (ret)
+		goto out_put_ctrl;
+
+	conf->ctrl = ctrl;
+	up_read(&nvmet_config_sem);
+
+	return count;
+
+out_put_ctrl:
+	up_read(&nvmet_config_sem);
+	nvmet_ctrl_put(ctrl);
+	return ret;
+}
+CONFIGFS_ATTR(nvmet_ctrl_, enable);
+
+static ssize_t nvmet_ctrl_trtype_show(struct config_item *item, char *page)
+{
+	struct nvmet_ctrl_conf *conf = to_nvmet_ctrl_conf(item);
+
+	if (!conf->args.ops)
+		return sprintf(page, "\n");
+
+	return nvmet_trtype_show(conf->args.ops->type, page);
+}
+
+static ssize_t nvmet_ctrl_trtype_store(struct config_item *item,
+				       const char *page, size_t count)
+{
+	struct nvmet_ctrl_conf *conf = to_nvmet_ctrl_conf(item);
+	const struct nvmet_fabrics_ops *ops = NULL;
+	int i;
+
+	if (nvmet_is_ctrl_enabled(conf, __func__))
+		return -EACCES;
+
+	down_write(&nvmet_config_sem);
+	for (i = 0; i < ARRAY_SIZE(nvmet_transport); i++) {
+		if (sysfs_streq(page, nvmet_transport[i].name)) {
+			ops = nvmet_get_ops_by_transport(
+						nvmet_transport[i].type);
+			break;
+		}
+	}
+
+	if (ops && (ops->flags & NVMF_STATIC_CTRL)) {
+		conf->args.ops = ops;
+		up_write(&nvmet_config_sem);
+		return count;
+	}
+	up_write(&nvmet_config_sem);
+
+	pr_err("Invalid value '%s' for trtype\n", page);
+	return -EINVAL;
+}
+CONFIGFS_ATTR(nvmet_ctrl_, trtype);
+
+static struct configfs_attribute *nvmet_ctrl_attrs[] = {
+	&nvmet_ctrl_attr_trtype,
+	&nvmet_ctrl_attr_enable,
+	NULL,
+};
+
+static void nvmet_ctrl_release(struct config_item *item)
+{
+	struct nvmet_ctrl_conf *conf = to_nvmet_ctrl_conf(item);
+	struct nvmet_port *port = conf->args.port;
+	struct module *mod = NULL;
+
+	if (conf->args.ops)
+		mod = conf->args.ops->owner;
+
+	if (conf->ctrl) {
+		conf->args.ops->delete_ctrl(conf->ctrl);
+		nvmet_ctrl_put(conf->ctrl);
+	}
+
+	kfree(conf);
+
+	/*
+	 * We wait for the last user of the port before disabling to make
+	 * it easier on the driver. It knows the controllers will be freed
+	 * and will not require extra locking.
+	 */
+	down_write(&nvmet_config_sem);
+	if (port && port->enabled && list_empty(&port->subsystems))
+		nvmet_disable_port(port);
+	up_write(&nvmet_config_sem);
+
+	if (mod)
+		module_put(mod);
+}
+
+static struct configfs_item_operations nvmet_ctrl_item_ops = {
+	.release		= nvmet_ctrl_release,
+};
+
+static const struct config_item_type nvmet_ctrl_type = {
+	.ct_attrs		= nvmet_ctrl_attrs,
+	.ct_item_ops		= &nvmet_ctrl_item_ops,
+	.ct_owner		= THIS_MODULE,
+};
+
+static int nvmet_ctrl_subsys_allow_link(struct config_item *parent,
+					struct config_item *target)
+{
+	struct nvmet_ctrl_conf *conf = to_nvmet_ctrl_conf(parent->ci_parent);
+	struct nvmet_port *port = to_nvmet_port(parent->ci_parent->ci_parent->ci_parent);
+	struct nvmet_subsys_link *link, *p;
+	struct nvmet_subsys *subsys;
+	int ret;
+
+	if (target->ci_type != &nvmet_subsys_type) {
+		pr_err("can only link subsystems into the subsystem directory.\n");
+		return -EINVAL;
+	}
+
+	down_write(&nvmet_config_sem);
+	if (conf->args.subsysnqn) {
+		pr_err("subsystem %s already set to controller %u\n",
+		       conf->subsysnqn, conf->args.cntlid);
+		ret = -EBUSY;
+		goto out_unlock;
+	}
+
+	subsys = to_subsys(target);
+	link = kmalloc(sizeof(*link), GFP_KERNEL);
+	if (!link) {
+		ret = -ENOMEM;
+		goto out_unlock;
+	}
+	link->subsys = subsys;
+
+	ret = -EEXIST;
+	list_for_each_entry(p, &port->subsystems, entry) {
+		if (p->subsys == subsys)
+			goto out_free_link;
+	}
+	list_add_tail(&link->entry, &port->subsystems);
+
+	memcpy(conf->subsysnqn, subsys->subsysnqn, NVMF_NQN_SIZE);
+	conf->args.subsysnqn = conf->subsysnqn;
+	conf->args.port = port;
+	up_write(&nvmet_config_sem);
+	return 0;
+
+out_free_link:
+	kfree(link);
+out_unlock:
+	up_write(&nvmet_config_sem);
+	return ret;
+}
+
+static void nvmet_ctrl_subsys_drop_link(struct config_item *parent,
+					struct config_item *target)
+{
+	struct nvmet_ctrl_conf *conf = to_nvmet_ctrl_conf(parent->ci_parent);
+	struct nvmet_subsys *subsys = to_subsys(target);
+	struct nvmet_port *port = conf->args.port;
+	struct nvmet_subsys_link *p;
+
+	down_write(&nvmet_config_sem);
+	list_for_each_entry(p, &port->subsystems, entry) {
+		if (p->subsys == subsys)
+			goto found;
+	}
+	up_write(&nvmet_config_sem);
+	return;
+
+found:
+	list_del(&p->entry);
+	conf->args.subsysnqn = NULL;
+	up_write(&nvmet_config_sem);
+	kfree(p);
+}
+
+static struct configfs_item_operations nvmet_ctrl_subsys_item_ops = {
+	.allow_link		= nvmet_ctrl_subsys_allow_link,
+	.drop_link		= nvmet_ctrl_subsys_drop_link,
+};
+
+static const struct config_item_type nvmet_ctrl_subsys_type = {
+	.ct_item_ops		= &nvmet_ctrl_subsys_item_ops,
+	.ct_owner		= THIS_MODULE,
+};
+
+static struct
+config_group *nvmet_ctrl_make_group(struct config_group *group,
+				    const char *name)
+{
+	struct nvmet_ctrl_conf *conf;
+	u16 cntlid;
+
+	if (kstrtou16(name, 0, &cntlid))
+		return ERR_PTR(-EINVAL);
+
+	if (cntlid >= NVMET_MAX_CNTLID)
+		return ERR_PTR(-EINVAL);
+
+	conf = kzalloc(sizeof(*conf), GFP_KERNEL);
+	if (!conf)
+		return ERR_PTR(-ENOMEM);
+
+	conf->args.cntlid = cntlid;
+
+	config_group_init_type_name(&conf->group, name, &nvmet_ctrl_type);
+	config_group_init_type_name(&conf->subsys_group, "subsystem",
+				    &nvmet_ctrl_subsys_type);
+	configfs_add_default_group(&conf->subsys_group, &conf->group);
+
+	return &conf->group;
+}
+
+static struct configfs_group_operations nvmet_controllers_group_ops = {
+	.make_group		= nvmet_ctrl_make_group,
+};
+
+static const struct config_item_type nvmet_controllers_type = {
+	.ct_group_ops		= &nvmet_controllers_group_ops,
+	.ct_owner		= THIS_MODULE,
+};
+
+static struct config_group nvmet_controllers_group;
+
 /*
  * Ports definitions.
  */
@@ -2079,6 +2397,10 @@ static struct config_group *nvmet_ports_make(struct config_group *group,
 			"ana_groups", &nvmet_ana_groups_type);
 	configfs_add_default_group(&port->ana_groups_group, &port->group);
 
+	config_group_init_type_name(&nvmet_controllers_group,
+			"static_controllers", &nvmet_controllers_type);
+	configfs_add_default_group(&nvmet_controllers_group, &port->group);
+
 	port->ana_default_group.port = port;
 	port->ana_default_group.grpid = NVMET_DEFAULT_ANA_GRPID;
 	config_group_init_type_name(&port->ana_default_group.group,
diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index f587ec410023..f8a157e1046b 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -336,7 +336,8 @@ void nvmet_port_del_ctrls(struct nvmet_port *port, struct nvmet_subsys *subsys)
 
 	mutex_lock(&subsys->lock);
 	list_for_each_entry(ctrl, &subsys->ctrls, subsys_entry) {
-		if (ctrl->port == port)
+		if (ctrl->port == port &&
+		    !(ctrl->ops->flags & NVMF_STATIC_CTRL))
 			ctrl->ops->delete_ctrl(ctrl);
 	}
 	mutex_unlock(&subsys->lock);
@@ -1889,7 +1890,8 @@ void nvmet_subsys_del_ctrls(struct nvmet_subsys *subsys)
 
 	mutex_lock(&subsys->lock);
 	list_for_each_entry(ctrl, &subsys->ctrls, subsys_entry)
-		ctrl->ops->delete_ctrl(ctrl);
+		if (!(ctrl->ops->flags & NVMF_STATIC_CTRL))
+			ctrl->ops->delete_ctrl(ctrl);
 	mutex_unlock(&subsys->lock);
 }
 
diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
index 990dd43df5c9..f652c62ebdd2 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -404,6 +404,7 @@ struct nvmet_fabrics_ops {
 #define NVMF_KEYED_SGLS			(1 << 0)
 #define NVMF_METADATA_SUPPORTED		(1 << 1)
 #define NVMF_SGLS_NOT_SUPP		(1 << 2)
+#define NVMF_STATIC_CTRL		(1 << 3)
 	void (*queue_response)(struct nvmet_req *req);
 	int (*add_port)(struct nvmet_port *port);
 	void (*remove_port)(struct nvmet_port *port);
-- 
2.43.0


