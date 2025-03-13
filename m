Return-Path: <kvm+bounces-40873-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D14BA5EB1C
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 06:23:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CD3A53A78A0
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 05:23:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14CFC1FAC4B;
	Thu, 13 Mar 2025 05:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CaPK5HaR";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="IVE7js5U"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B560C1F9A85
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 05:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741843370; cv=fail; b=axeaMkmSG9vn3y6spGuniNOkS++93YIPt9zgmblSgvGTh01ExhV0nOFfZtZ/m4jH/lKAjH2jhB23Ah/ZsLgYwFwpjjm7h+cVlOd4+W3HxmhVqmHQSlEXtcxezcHfH5/nr7OR6EmE3VV7GPez8BaKCxSCW7xnhuJ7VoDFyAxpVlA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741843370; c=relaxed/simple;
	bh=UD+6E6JjGudSURNrzU/E7g5eN8sOh0vGHjkXR098sDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=kj7FFvv3odSDWauMvlF/HbgjIu9YI/bS4S6epvq0NxO6b8NwkAmCZp2ithM/WQqnrMGl/AwyDyuGOBtsYeka+OWOgIyVTCptSuNlZcwa1sIqmaJPHvgXOy+lmgDVJwcMgjel4ytJKDa9iTbsmEEHAlMtK6xxRztrPEsOrVweoWo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CaPK5HaR; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=IVE7js5U; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52D3uISq019090;
	Thu, 13 Mar 2025 05:22:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=y9Wn79rLekMEBO8c+SuIr7jFk1qrAJ0CweOE0hPYT+E=; b=
	CaPK5HaRbgxT838GKbdO9odfsUiwCPJTO40EEDZoleeyFHrsV2aQ68i5gsLQZa+A
	n+RzQjzH9jAgQB1u7IjLXc8go8+BPsJ9sJskeArRzfiFT67ZgGzeA0XKiNMU5IsL
	EhJlSBDPOCrs9Z5+xniFYWf2OlNpUhSzSGwHtNGrATZdLvSNFO36Ou+52pLcQ1IX
	4OiHpSAf7Z28nXGGEnwEgdmU8FuhusMiHrwGF4u48PVFfewZb7y7If5G2Nu9h2WN
	8w6+J7/2GBM0YAZ/44rQyyxzj0SlMTlE1Dz3Zgm7ybaMz7FzBMWL/Hwmuz3FGRAP
	cHBLOkdoX3QVMIKtZn4XoA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45au6vkes2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Mar 2025 05:22:34 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52D4jrOb012313;
	Thu, 13 Mar 2025 05:22:33 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2046.outbound.protection.outlook.com [104.47.58.46])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45atn272ny-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Mar 2025 05:22:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t7FLjtIIi2h67/dK7SzN7n8q+Pp3XWELn0ow2fMifoPjsQsQX62+3U2LRTQS2QW6zwhmiMVPntFg7sjR1SfsQBf7THUL/n/mG9zYeLshdrpRRI19487VrLv+AkPLAw7CNnwvnlpQ7MC2qNP7+wXl09EtckCJeAmUEfCaW3+OGQkWxZlqlwBU92n+lEuJJUuh7DEzFdC6fWXf7atoj66bNErs8Y9y+fcuLEnAg8yKg57mM1cJy4HfyC0O1LeGNO7PHjwNTSgaPz7nnd2rOnDDNZxn0BY5lH7ZKZ+c1S2lCl7kniiXRHgvSifzxWndwspB5Md8UGnVx2u5fyc1Fi+kFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y9Wn79rLekMEBO8c+SuIr7jFk1qrAJ0CweOE0hPYT+E=;
 b=RY4wfj/s64jH5v9fWnh1eJh5NjaRr1ClucUE1SstQOsaegiAQE1N84Zy0aopAIIBS3boLaJHnWNdVrG+gi8JeaQy0+7I0/TOiX48fnEDrNNFKvmHP0knA8TNTK055RnHIXR21ExKJLLlrrReWVIXVqLefdbt1oAW0RgZ6VH3alhS5JUM+OeYW+/o8X3O9kNlEq89ZbN6tIb54jjxl3Vbo+A+XgxDzB9rYqPgw46pizefuuTsWWZtjP2flNXkrGGxt6hNj7hvtTKpWFQLKRDgSXsvIbQoc+rQtDhLICzDlCVxBcavbChg3saj5itBcsTcNVqmf64lVZ1DEc1MZ5MfqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y9Wn79rLekMEBO8c+SuIr7jFk1qrAJ0CweOE0hPYT+E=;
 b=IVE7js5UEcvuFBMKk6Aanwkw+DKetggwF4RtWwSgXdxB7swNDd7J3RHHDT5Ol2OrF1u8x9vpQMuQ7Dn7eEuc2eCjChGpntjwJOw3FJL5VFfh6Q8CZ3mKb4aCptV8RLF2EHasMffwpiunnPZQSW0FsXRl2Xnojt036jYjdjRiDtY=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by IA0PR10MB6724.namprd10.prod.outlook.com (2603:10b6:208:43e::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.27; Thu, 13 Mar
 2025 05:22:31 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%4]) with mapi id 15.20.8511.026; Thu, 13 Mar 2025
 05:22:31 +0000
From: Mike Christie <michael.christie@oracle.com>
To: chaitanyak@nvidia.com, kbusch@kernel.org, hch@lst.de, sagi@grimberg.me,
        joao.m.martins@oracle.com, linux-nvme@lists.infradead.org,
        kvm@vger.kernel.org, kwankhede@nvidia.com, alex.williamson@redhat.com,
        mlevitsk@redhat.com
Cc: Mike Christie <michael.christie@oracle.com>
Subject: [PATCH RFC 04/11] nvmet: Add function to get nvmet_fabrics_ops from trtype
Date: Thu, 13 Mar 2025 00:18:05 -0500
Message-ID: <20250313052222.178524-5-michael.christie@oracle.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250313052222.178524-1-michael.christie@oracle.com>
References: <20250313052222.178524-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR12CA0028.namprd12.prod.outlook.com
 (2603:10b6:610:57::38) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|IA0PR10MB6724:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a9db3d6-15e2-409d-b8fe-08dd61ef0de3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+hvHznkCWM3SC3P68okzXCtCmj2FRmxhun5L3WhHgQh5h3aYN/NPvA9A3Zof?=
 =?us-ascii?Q?8vldBBPyHIdf2ZoQkENjXDPLGYH7enaqPqr4/opax6mrd2buy/8wwunbU+RF?=
 =?us-ascii?Q?KquJoIw9pDcV6TO0304K07Qjr43vBZ0hTYL9d1sZF1ihrYHiCp8tB9XzNSgI?=
 =?us-ascii?Q?jRnueJ/GxzmcGGVcoxMcfqVvADfU51uI6BImESBEVNfqRpTkDKF/QwiORd/+?=
 =?us-ascii?Q?0JPTaVYeYmTqMxWA1XTjY4PJQ10Aza7uZzAFocO6WJoSxfH7hE3MUNBAz4LR?=
 =?us-ascii?Q?nCrBSrJ7JChIhnBQr+1Ckjmk5231AGTN+3aBi4TOFU+bjJbV2EARj/odXk1Y?=
 =?us-ascii?Q?29pJu2bqnE6zx8J1RrLQ30L6M82hfVk8OZrLh4pVlc8ddY0Ua5adDY0GMPyu?=
 =?us-ascii?Q?9j3VTF6QUO7d6sN69THhJwMrGKcfDa/0H2FtFxYRHvntdpXJswrxXaTRLGaM?=
 =?us-ascii?Q?9DpFJVOqgnrHowjZFd9OHQvymjYDMvvo3V8ayRpXfJfYy3WgoOj37EshFPmM?=
 =?us-ascii?Q?pmtu2x8wmq4YrTN46GyCcAG4Mh56NtCIw4NRH13YSLe2+LJMWzwYSj+faqqh?=
 =?us-ascii?Q?xCLlCmLLutQdJqPUgXtcchHdM7/ubZo0dJj879mZ6vZ4n9wyBC5Og+tf+lNH?=
 =?us-ascii?Q?osX8OJMRhDRQRN97ImJPldasNnyhaWMiQt3vAReCkmw9vhguwe3fI3ONM/BU?=
 =?us-ascii?Q?tQfUrpb0x3amHqJY7l5fSpL7MzK19reHuxcQSjdwHa89+6eML7NE5rcWw6J4?=
 =?us-ascii?Q?UQSiAlUG9NRATrn/I4CM7X2k+8juMKRsosoRJkX0mG35U1zzs5GjiMZqJFTK?=
 =?us-ascii?Q?tjcfPuuqGgbqA3BvqfeGogstvbG1Yt3bozM20QhdH0hAvMJ3GulwmkzKlcui?=
 =?us-ascii?Q?2KK8bKxz/Kch2YH3XxGS/l5Pq8RlHs/KRMhgh41XM0prNrhgWS0tomTOeZpC?=
 =?us-ascii?Q?Taa5+fDoilw3gwa4V1TI5AwDrJZisnheVp9/5fHcAaWbQBRGqBJeNO6hWTkI?=
 =?us-ascii?Q?6y5FlugDpTSxe5vXCMG42If8NF5Ma36z2G5YylZq5R977yy0jC0YsSTWPNMr?=
 =?us-ascii?Q?f3CNUdIUdcqSsCahFSPNI6BLLeBLjP7+cSNxmui9dvhkcUnNnxZJwMgWHZ/u?=
 =?us-ascii?Q?WCpzTJnjOjK0hThoOhrVfEzsGiWOji6dQW/xfrbeR28bzCAV8NhXTdfnhTyh?=
 =?us-ascii?Q?ABxaqRqKRZ5PadPqjibQGyVj02FhzI+x7VS+CLvUm69kBhxLLHth+Te32ved?=
 =?us-ascii?Q?/o8pMOgspazk69TV5MvyOfifa6NUIt8/vTXKzQDeSJM0CjahCbuDbTLFh01g?=
 =?us-ascii?Q?GB6QPZnHwB64urES/mMPysJwy+8LsUeKWbii1g3K0cCW0ob+mM9kCNSo8YTf?=
 =?us-ascii?Q?iw76QrkvDkS/V3SGo9UwGs3GNe2rcz6WZFaJSfLlOU5HNaFlnqLm3T5PNN75?=
 =?us-ascii?Q?Nc9KWtEdMws=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?UOLaxUN9P1+qtCHdUbUz4pwXP4+SEt15troFiH0xHOQ6mAUdmaoFndNTIbIK?=
 =?us-ascii?Q?/rxOZpjy1MfEcn9PmvQwjFMCa736ZFHzVvJZ6QCA94CKlvqhQViRbdDxg4vF?=
 =?us-ascii?Q?3Yp0H7PiBRnEcz3tvTeKroNlLvh4IJF6L7Nx5uLrbR5AXxXnZlKbBu7Vke7o?=
 =?us-ascii?Q?+6p/74HlihouaE7vclqKfRUP/TacLtGNrhkXtumIrQNeoxY2hPKmidRQMUBw?=
 =?us-ascii?Q?3IA3NTCXLJfv+LOHbRb71udDhyMkvdz9GAWpgUd7PwW8kHiJBsaXlsalTa9y?=
 =?us-ascii?Q?JAGSzHBoSwZDcLrrzQTcc3FYwGwxk/eMwMtGR8cL9gON3jztOVQUA1JKKRSh?=
 =?us-ascii?Q?k+fPOYYcy/l3fz1LNkxFiJ2El1ca/vrCQNuqTIKFCD/i/qNIqYpoOGNX2qGj?=
 =?us-ascii?Q?MWXA4vHbFaSOqGOtoA9vKsJjegTAmxxFo1uWd1mO4i1Y9U8jjU1KO6kCVU+v?=
 =?us-ascii?Q?qxuGDJltJ9O4+dAvb8bfEFWF9kyZlmxvSH99Bew47PKP/NRM2HmwmNpXDCSK?=
 =?us-ascii?Q?d+5Mpkhwn2Nk1nhhN93DyZIWscgVM7FvdELPawQBD/UqAKZXTIHGeufP53pQ?=
 =?us-ascii?Q?DyftVM5UeoLwMthoU0cblblFZgFEVh3S7TY0DXzqIysu4bY/S/UkNK3ODfsP?=
 =?us-ascii?Q?RZh6tpsz9sJyasvxSWuGvIyLFjSiWqlgHg/p+MlahL2eUOLULATzNGWphTTc?=
 =?us-ascii?Q?VOqBPNBjOEELj20x0TJesObgU6EWvaSbS/lvH5GMnpRYz7xZHWL7qXjJa+2s?=
 =?us-ascii?Q?sLwkCu5CMJY5d8SLmS0T8nEWkf37kEuYh/0NIZR6QLS/RDJBsNQToqxGUorR?=
 =?us-ascii?Q?FcAK3o3Rwk6b9kiqoniwGtQS8n1p+qHTD1tyEnEQj9f6y8SR6bQDyAispSEi?=
 =?us-ascii?Q?kOdh3kfm5NiQXzqbg3QLsiGXMu0qreBZKHdlp/YieI0RXKLJQb+GTrtF7S37?=
 =?us-ascii?Q?SyUDOmJMiFin68eCohGGUI0/KiMszou9kAWAfXMoezwbWbRpU5EcLJe2jBZd?=
 =?us-ascii?Q?Iys+yqKs8lxtiM9U7s1lOw/l3CbqZUIBLRlkfxeuQyUmCOqUjeZaSFdpJsZr?=
 =?us-ascii?Q?xx5xS5nack/l4sJTze8TFT/t8Nw8Ys8JUajKQkRBw8kOziDYNowjsWRMdY4D?=
 =?us-ascii?Q?IkDn6KO9PE6CVlz6WKxe7cNpUfKNXT7epBavbchQYrDWIDuXetFWL6DhZPoZ?=
 =?us-ascii?Q?4UgGuquMgUEhpDYKdxqNWjwxP+eFrrGFt1WzlTG2kr3eYRFqLQKCAHyKK7hq?=
 =?us-ascii?Q?yf+VRV8gVam8lsGiBaqrR7MssIX/z253ZyQ4H6SwWb1uAtcNHBGctcn2Ub+L?=
 =?us-ascii?Q?AvhvzofEtJ1lmi2jby1qyFO5p4P2uIodr7NyWt8ceAD1wSITH5+MwACnzPnt?=
 =?us-ascii?Q?J4zZyMQOqr2No/LWuikzKkFKpMuu6GCOCqvri3Ux5phaYJEILmZ0oR/6jwlT?=
 =?us-ascii?Q?AFnUZ+Ux34KUxrHYI2E/5YJkUNivkS/eBtgolJk1C+4YMwGiOoLDDKuB16xV?=
 =?us-ascii?Q?AMDPdOMB01A5ogLW68js3GsMp47189rf7C9+mosu2yhe0YefT/wqqpHpZezO?=
 =?us-ascii?Q?SqFsWNeWzBYzPdz5+f1Q01POjU23SNWtnpKS13Fk116U4o9mybT/mto1cj5h?=
 =?us-ascii?Q?Jg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WHbLQyTQnKf4h8htsiNBNKbxV+VFVZrmbsXeZIHB6Dhv9U2+Hr+4sZkxjMU+Zg/kWx4P1HDMfONehQbmbW2evshmUdopJwU7Q03KTSlERlo/mo+vJYpgTPYOV7iYfYFiJkDQ0y7yxNGedk6KUlvt4AfSiFlOSvvGo1/+gXY8G0X2aWGNdOvRjYhPWzlWBd2KVBWSXToM+E5U6acpP8sjYSyWhg5/js1RHMh/hffH2QzYlzWoAim/PRO9XhFQ72FE5RGlvcLm4NIvGaKAWkWDnSpdHa7lLryDjr6CbL5CVLWhGcjSwWnTo1lJINrSz3Lh4OesLwHEbFGuscm/nqbSaCtcLzJounqfhg7yS1mn5TXUn0woYkfN2bzNrHxnZkKbTLYJTGmZrMcSua49cYjKKymhXVECirsiFhgiPd3QkXjHy1N3rhHXGVr8QyD2N3oACOVOnPc5Q7M1Rx3ES2Nalcu27+H6+zbLWkgDkUHbj/XDtAVa/z8z0YeazgHomLir2kfAeVVdSqOsGHgzzjBFF/CU7sr2S3bNeO5EqP5I9LTUPs/NbMKoPC6vZZz/RVE7Smm6Z7DLVWzXaaPj7cvahlZrjurw8DC3iUfWJIj71kM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a9db3d6-15e2-409d-b8fe-08dd61ef0de3
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2025 05:22:31.5912
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CTZ+YJFq+Gw9YBBsicKJBanJHmCrOzo076M93/qjFY0xvr9NHxvi2QHjC7v+u/qBZN+BN6kJEvgJgdrtKPVqQjr4PI+MTZJ/E0bv0Amlo7U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6724
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-13_02,2025-03-11_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 adultscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2503130040
X-Proofpoint-GUID: Y8v74U7Omy3nt60MxwkDvOG4pbKICSL5
X-Proofpoint-ORIG-GUID: Y8v74U7Omy3nt60MxwkDvOG4pbKICSL5

In the next patches we allow users to create static controllers if the
driver supports it. To get this info we need the nvmet_fabrics_ops
a little sooner then port enablement so this creates a function to go
from trtype to nvmet_fabrics_ops.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/nvme/target/core.c  | 41 +++++++++++++++++++++++--------------
 drivers/nvme/target/nvmet.h |  1 +
 2 files changed, 27 insertions(+), 15 deletions(-)

diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index 4de534eafd89..06967c00e9a2 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -306,6 +306,30 @@ void nvmet_unregister_transport(const struct nvmet_fabrics_ops *ops)
 }
 EXPORT_SYMBOL_GPL(nvmet_unregister_transport);
 
+const struct nvmet_fabrics_ops *nvmet_get_ops_by_transport(int trtype)
+{
+	const struct nvmet_fabrics_ops *ops;
+
+	lockdep_assert_held(&nvmet_config_sem);
+
+	ops = nvmet_transports[trtype];
+	if (!ops) {
+		up_write(&nvmet_config_sem);
+		request_module("nvmet-transport-%d", trtype);
+		down_write(&nvmet_config_sem);
+		ops = nvmet_transports[trtype];
+		if (!ops) {
+			pr_err("transport type %d not supported\n", trtype);
+			return NULL;
+		}
+	}
+
+	if (!try_module_get(ops->owner))
+		return NULL;
+
+	return ops;
+}
+
 void nvmet_port_del_ctrls(struct nvmet_port *port, struct nvmet_subsys *subsys)
 {
 	struct nvmet_ctrl *ctrl;
@@ -325,22 +349,9 @@ int nvmet_enable_port(struct nvmet_port *port)
 
 	lockdep_assert_held(&nvmet_config_sem);
 
-	ops = nvmet_transports[port->disc_addr.trtype];
-	if (!ops) {
-		up_write(&nvmet_config_sem);
-		request_module("nvmet-transport-%d", port->disc_addr.trtype);
-		down_write(&nvmet_config_sem);
-		ops = nvmet_transports[port->disc_addr.trtype];
-		if (!ops) {
-			pr_err("transport type %d not supported\n",
-				port->disc_addr.trtype);
-			return -EINVAL;
-		}
-	}
-
-	if (!try_module_get(ops->owner))
+	ops = nvmet_get_ops_by_transport(port->disc_addr.trtype);
+	if (!ops)
 		return -EINVAL;
-
 	/*
 	 * If the user requested PI support and the transport isn't pi capable,
 	 * don't enable the port.
diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
index ec3d10eb316a..052ea4a105fc 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -622,6 +622,7 @@ void nvmet_port_send_ana_event(struct nvmet_port *port);
 
 int nvmet_register_transport(const struct nvmet_fabrics_ops *ops);
 void nvmet_unregister_transport(const struct nvmet_fabrics_ops *ops);
+const struct nvmet_fabrics_ops *nvmet_get_ops_by_transport(int trtype);
 
 void nvmet_port_del_ctrls(struct nvmet_port *port,
 			  struct nvmet_subsys *subsys);
-- 
2.43.0


