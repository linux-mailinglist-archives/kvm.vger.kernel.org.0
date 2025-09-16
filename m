Return-Path: <kvm+bounces-57754-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 780E8B59E15
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 18:46:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C037358163C
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 16:46:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AF63341AAF;
	Tue, 16 Sep 2025 16:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="KnPuu0Du";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="pC1xVfk9"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35EB431FEE4
	for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 16:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758041105; cv=fail; b=RRlFHuA1zXxzdjQsBdSTh+oayYviwGKJuUAJLJxEDl4msMvGkyE8dlQoEOA+44JKFkyOX/rrvxxbx6Gf0x67xKChB9++kqvRisr3mkNeDRJjoyzbeWd20z25Cpt+84NPwnMkHA2jcvqy+4fdL17MJDp1MBm+J4gFi125G+RkzXY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758041105; c=relaxed/simple;
	bh=VEIycZppr9bgWNaFXFXLW66ZJhKig4qq9riymtl4aUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=sTvWGmpP/mM64uXR3y0Nxv8HN7DYIl51jxSggN21fOcQHTg2QZmkg64ERF/ie25qEd0bqRIUTfPKLG2f20h1YQf7n36XgBRAiETWmUJZgBfAe2OD+bepixOmrYhGxwDRuRTawrB86HqJegP4sNkS6KN5lUBoVIydiG9n8d3j0PQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=KnPuu0Du; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=pC1xVfk9; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 58G9Bc4G3768065;
	Tue, 16 Sep 2025 09:44:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=TMc6e7RUTxJOxNvGDzugZ1uz9PNT8P0LGgKKmglt9
	JU=; b=KnPuu0DuyLi/nz0CL06ZjLQb5a0t9xkr2AV8Vsf486ltLvz0wtFKN9xF8
	YSWATILzIJ+GDhtCaXgqseh7FsFDWXEeK7hP+xnYv40j+3dI3zCujDKAprUG6Ky7
	OOgQ89ImUjsmKervmatIXfQ/50fZ1yyU/s0He6ThFua4eC58OWYiTxQDFpqeKHOa
	pHqTUlmzpvCmzcL/BjV07p/RUAw11EwpLpyvN6xr5lJXFTPfBXWRCJ9/bGOGLgIp
	L7duKs3pxo2ups1oM7pjvxnWQwP0SG+aUPA4RvdST4wAN1l7sjH6ixIbreTWsrYo
	/p5kLg483BWV4EKRVdzjp37/p3ZIA==
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11022080.outbound.protection.outlook.com [40.107.209.80])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 496uaq287x-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 16 Sep 2025 09:44:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vmOXZgC4cEOSKTTPbON43+2W89VMr4GugixRhIREzbo9J5uA5MSphR/7ACJO8lQS18yTL75TVDo/ErUit/3DNItgANhjPEnIFrep/kpYk0vl1bAKONccTPh1lRW+x4J9mD0z78vLFRK0jkeSYrYTqdRu6Iy/ue36UjYXKMSvViP+i2pNfW4fvy5+jpJA1ZOpDanx7ezxfKTmBauMSL/s0O11aXRhcbg9edM8NeTR2ihpSW09in7jrnCbK6TNtx8scJsSf7FnD6Um2TP7tai3CYCE2mhINK8xzVD74O/FV7+p9VerUo6qxeX/AUc4E14BlnjEEdxzQPUgQNiP21S08g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TMc6e7RUTxJOxNvGDzugZ1uz9PNT8P0LGgKKmglt9JU=;
 b=TFFDGkD6xf+39ZXrAKkEb8wEebuDEt3iOBRXFHd0fqGAbVehAw2O3XLAU7l9BamXq9UHzPKpciMzRxDYcIUpGXdztNzEgZdc8oNYCxYqdS6mlSbHFgRyb+kqgadnX2Wa1jzbJwoR5sU7XpgvzYwIZWdApBEa+idnlYUywu2+lEaGdkG4Z8mfcYZR+jJi0vuCJ07C6OXe8ZuBylSGlwGQD4JfugYnmm/oNbjnHTpuKrpm+XrcHZPnIaN8KwpqGIOpTnFmSIHdE31T5Pt4v04GVqNgdjdjaPhmu+gBd56lIFexAQ40J/79z8JgcJ0tO55GVWOQh/N53HptvmgqfpsGCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TMc6e7RUTxJOxNvGDzugZ1uz9PNT8P0LGgKKmglt9JU=;
 b=pC1xVfk9KTqjyqFAO7CzTs/3p2eIgTyPd62QZvNhLn5yvTx5r7heDPTOG0YvM5RAguYFcXZdCbf07UCWoKoUVVL6Uyr1jwOpDrhzYLSPHrMi4tHnVw+bVyiLX1ilyCecm+eV0k0lbgF0hhDSNMXwVNKiHpKD8qR2vhuXvTEBqqjpP95IGpSXNZ4Qxj5P72c0QmyoYbmvWIvejZ39pLrFno8dsjHahmxB5A6u8dprW78fJXJ97Jyv7gs2VigxZTlMFOEhcTpFJyMuLER/3TmJMEe6DNB4nZtURCFiBHEX8iKxwgEyI4F9Dm9qIpsUFMMnphLHFguZAFnVSLoyydlVOg==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by DS0PR02MB9620.namprd02.prod.outlook.com
 (2603:10b6:8:f7::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Tue, 16 Sep
 2025 16:44:52 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%5]) with mapi id 15.20.9115.022; Tue, 16 Sep 2025
 16:44:52 +0000
From: Jon Kohler <jon@nutanix.com>
To: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org
Cc: Jon Kohler <jon@nutanix.com>
Subject: [kvm-unit-tests PATCH 13/17] x86/vmx: switch to new vmx.h pin based VM-execution controls
Date: Tue, 16 Sep 2025 10:22:42 -0700
Message-ID: <20250916172247.610021-14-jon@nutanix.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250916172247.610021-1-jon@nutanix.com>
References: <20250916172247.610021-1-jon@nutanix.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH1PEPF00013309.namprd07.prod.outlook.com
 (2603:10b6:518:1::18) To LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR02MB10287:EE_|DS0PR02MB9620:EE_
X-MS-Office365-Filtering-Correlation-Id: 69171e97-e956-44bf-a3a7-08ddf5405b83
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|52116014|376014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?tEkYYULjvJdiMsaZBn+QTFZTg3XXWHU9dIbiti705wo8ogoQxsS5SJmKcxTM?=
 =?us-ascii?Q?7gsy8O1HRGQ0KuHt0rlIX1cjDXiAdCpask7utjX+SsexzzEd/oMN554awpOJ?=
 =?us-ascii?Q?fYD+peU2iFp1sis9uLDHRWBP4zPVWNtHR+LGYIOMMTMNFfEQTQ5nHXrRc0p4?=
 =?us-ascii?Q?0VkcnTQJCD2L+odErjVSaFtehdDL0mmqBBu/fyg5eHwk94liChr/A332YOvs?=
 =?us-ascii?Q?MKMUZqTBw2Lag4fASZuco3+GXiBKyJc6SUQabqpkZXdnOHgSHVBuZjLjiu59?=
 =?us-ascii?Q?lrNkuEOrkJxiXWO4vhrPNZl9WijKhiRia4b9bZDedlviu51h0Inad7voZQZi?=
 =?us-ascii?Q?zr054MjXnUV6Lo/IoqCLPKBmUZf6+p2xDySEHmbOBu5Nz6qxY7saYEtHdr0F?=
 =?us-ascii?Q?cCGnKtJvnxttv2IZnH2EJ5OALXWnmi2r7lZlgcjFgAHfr8b5v+J5naz8lO0I?=
 =?us-ascii?Q?bmPSllILquF2ezgwPQjEf/FhMYbHmm0ZRYs1idrILUnN2nsknEehJaFao/BW?=
 =?us-ascii?Q?BHmILNmjvwo3hcThyAV+zNDjXXyv+e/AFyFaIRlDQSNEjvGC3nXXTerbPzwm?=
 =?us-ascii?Q?urvRDtEH1737t/M0QfOlVNp0tieV9W/GCUxgxSKt+kFRJlgvGi5x1ZFFIXEn?=
 =?us-ascii?Q?PHg3KCfEB0Vp62TNvrc/7dq03J6miOlkXGOXwNzB6QXngTc4ulfKxOQq8iCU?=
 =?us-ascii?Q?+DGcq9k/pNYBuYyTOQd/x4VTUbNgIju5/TN+1gbWrfr3kXvLkfoG2DlmcKuZ?=
 =?us-ascii?Q?MLJmeud6iJAjHSZAdxmO2SJDJXoo1zqkJhJRwzJLTBcyAWrdLUSTsrOgjLcs?=
 =?us-ascii?Q?YvtDR3YX0NORAY/A74yo96/UTAgqq+yVzqCPJ0FI+vkYqaD6OB9lndLw7p+J?=
 =?us-ascii?Q?4sKANr7BFRbybojTptOYndHqwih3xsjSKRy4Hs4s5gase2M6b2Eb9hkh0js8?=
 =?us-ascii?Q?bl2z6Z0j3Tzvo6jLzv43I0UwK4FbAkUFlC9uhqtKADnb/WVFtpMFukkZmbl6?=
 =?us-ascii?Q?szPaWk2Rh+iLViECcaUlTihqT0Aa868GVQSxpTu/i+riN/M8uAIPOKUISRB8?=
 =?us-ascii?Q?nnk02pmdAPnGSDYtgunToxfSretosR0nc0w/bdAKrTEYhmdGmAly+sOJnV4C?=
 =?us-ascii?Q?D89woq5Pjvmgynrtoof07o1PlR1LD/5oox8KeEVwAUhs3LhB/7W4ixuspCLV?=
 =?us-ascii?Q?PtENhZQj+wGf405EaZX/we4zsu1vMPHe0ZAoWyW5equHOasRNy8VefFCo6qc?=
 =?us-ascii?Q?xNh7P/aVEh0u7WkdxyYcLFxZcBtY84dSyK1BaxDR6RR4Uyh+ZSw+zh88bcss?=
 =?us-ascii?Q?cMA7lx78EdddZk2IvqNTWzoL29iqWENM/+kz2Lr/gPsU8OlswNd8ZTLfZLgA?=
 =?us-ascii?Q?RcfB+3aBrIigtFJlPWLH2LzIFESXCkfsw62TMQfDjV1eXAfI8v+zLQI0i11l?=
 =?us-ascii?Q?ZLW08orUH6NUGgIuod7/dGlY1FuamGKVzULTjOhikkONxJ0z3jdTiw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(52116014)(376014)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?k1VjF3NHJDPYViBZGDzaq/g7ah0S6T2tNJ66MfRl5Alcbag+1GyngMM8PwhT?=
 =?us-ascii?Q?moKxO23LxOXxlyc3tmAiQIiDIQY33MxjNn7FC+gU7EX8hXs/rZKvQ+x5M8be?=
 =?us-ascii?Q?oclrvucEhMX/Ard15b3YIknBYQvHZIB2O8SxVtYMQB94a5ZD+y7MP9Vf7GUC?=
 =?us-ascii?Q?k0fasr8lc4Iu/ZWIeFk75RGoihb2OqR9fyofI8nbUrAn/KSr1kAZRpJKuV0v?=
 =?us-ascii?Q?6p14gOX2Sg8XOCz1J7vqB+pv3d9Xec7ukkIALTctbXhyKvrFreRLGKaFIXF7?=
 =?us-ascii?Q?nrjPRniy6kLKK8tO036OGFgA1gh14VCdgi+PtyzH6SgXSCMDT4usNx0nBZTY?=
 =?us-ascii?Q?sxhxEwJ7UY78N0s7jNxYQ8fjHxlP3EpUR8vS/8ECQeumjyAdbiqzDDZKxpXZ?=
 =?us-ascii?Q?ehD5DHMUdFAXH3ndvDZcpIsVBB+e9yOKPb4d2QR9f8oKbdpqzK9qGVYuDIdj?=
 =?us-ascii?Q?Ohqd4KxCEzpDgsCi0MSmmsCOfqKMVtTndDuxFY3KwPkmv5CBZYlFXda8yUgn?=
 =?us-ascii?Q?Pbl+B3Zcwv2ii5E3PfbaXVOsTwYtahsx4zP2lm82gNYVh+cxczVEzl++O2Bp?=
 =?us-ascii?Q?1mMibMjRePvHa6msNEHeuivzqsgg7BDjuTA5ohPMuOdBOtNCne4X23pVC4qm?=
 =?us-ascii?Q?M7jId7S8cH2+8PJOx2VqCt0PUDdN4o3DxFCvbTHt5rW93imhqawdYUzMBC53?=
 =?us-ascii?Q?chsSsS+CzvEVZ2x5F9rWSf0hEHA8FxnYk6/x3hhQy+EncA2ov/aDs3VtyjbC?=
 =?us-ascii?Q?GUCGGzyC5ErPfNXr1V1bKMQfmqHiW/p3hR5R1Ou5a8owDuPiMIH0pnbhNIjw?=
 =?us-ascii?Q?xOYgnakItvtHlXkzgbFCD6IhlfBuk154c9qqUzRPtTE+FkDTTc77UgmFJZ9i?=
 =?us-ascii?Q?jcVMFWHNeIWbxyxLwfYKvuLjNuqVxYqok3jIHeE1CLdleZ93H6OmowdehRjt?=
 =?us-ascii?Q?6QMLuBcQLBfSqRArCWhrOra9puOLB7u6nCFeKCxP8NCJ6NMH6sSSe8OOkto+?=
 =?us-ascii?Q?FHM6FklVrwFHy4gqNwLitYz6xqklpMkYzFsXqzy+jcrClAjfADplzRCfAao0?=
 =?us-ascii?Q?Ka/F6Jx00WvZkkX9NgYPId4/H7fW08dcbyaiHDsBaICZ9CjqtAIw92Z53uDq?=
 =?us-ascii?Q?+qzEnb2JxT7L759+FFlmUDzoaFV5TKO0idbCXYBq3vz3b07RBRwU6PkkietH?=
 =?us-ascii?Q?aKq31g8Ff/CmvP6eCYg7sUIGjHh9peiEzJe2xXa0Mu8TqF64FPcM+RG81sB7?=
 =?us-ascii?Q?HAt2brRbsJ4YQbolP9NWElnQBZnx6rBnEYLxzpKxJNQSyiSGKS4kDsMa4LMF?=
 =?us-ascii?Q?JQ1BP/zTgJG98s3bsSwwLZmTItDA5mRHdgwuVoSWYXPFzxxWVhQzlDsgEZXw?=
 =?us-ascii?Q?NNcmpVKGfKymp/J8MK6zcCqxveYg7FIGsYefHT5HvK73PypSw1HHkvZ/Fh3W?=
 =?us-ascii?Q?nnxdNblnU/8nvQxnoUSIBCwrQ1s9EpGv/1gj4qD7cTurH8AtqS+OK29SWiWv?=
 =?us-ascii?Q?hvrYhqodiCvFzPuWHl6QnvOe2B457hUJ7sZ0whUxqEQ9PqEvEwTCdBcV58M9?=
 =?us-ascii?Q?CB/Ja/naczU710fHAVEfejG14pzTeOvzWKRZ+ZOKh+8dxH50vB2Bejkh1qxZ?=
 =?us-ascii?Q?9Q=3D=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69171e97-e956-44bf-a3a7-08ddf5405b83
X-MS-Exchange-CrossTenant-AuthSource: LV8PR02MB10287.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 16:44:52.0611
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JLhrSBL2+4C64NhmAo2s4sO2xAlJotw67YF0FSEgcBJlESQiyYGx6qhpFSqNu5UQ0yiCqXdmJEjIpSWCWB8n2SzCzNnbEMqvOb/YUOBtHAM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR02MB9620
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDE1NSBTYWx0ZWRfX0kzhuTG3DS9o
 GZKehgRlasWEOXXrODrDt8yLqG2MC1HXfcAjHu9Eq1U2gFHiJCsVKVhXJb6FjX4fkM1ZMnBFlu/
 AR05upv7T7CRmROvPPcuvYKZv7Lr6mJIrcvfgpq5YV5xif7lxab7xu+MBss2afi8LZgbSA2xaX4
 Eus4Xm32GOyDbhdMZ03zOaG3g93wJQLogjiIw6O4S+P1D9R8VjAlFP0LkTbTmTavHKQKu9vs+gK
 bd8ctAIRnV2B50KuG67WtikPO/pPIWhpHNMRbvJeKbplhmAvlQni7bXVAdFpUOeGXqHxyWlUWcp
 6ZioLOMFl9BDsiM/CIioqoORyAWvtVuaRbtgyuNEC2k6m96V+C5qISsZpmcOLY=
X-Authority-Analysis: v=2.4 cv=Qppe3Uyd c=1 sm=1 tr=0 ts=68c99406 cx=c_pps
 a=12vGVFQirf4vZIp7c/z4DQ==:117 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10 a=0kUYKlekyDsA:10 a=64Cc0HZtAAAA:8
 a=9CjWzl4cyUpzCcdfwAkA:9
X-Proofpoint-GUID: WG9XrLb5ZhBoaNZuOd9q1Pp3uQcNSmUF
X-Proofpoint-ORIG-GUID: WG9XrLb5ZhBoaNZuOd9q1Pp3uQcNSmUF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-16_02,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Reason: safe

Migrate to new vmx.h's pin based VM-execution controls, which makes it
easier to grok from one code base to another.

No functional change intended.

Signed-off-by: Jon Kohler <jon@nutanix.com>

---
 x86/vmx.c       |   4 +-
 x86/vmx.h       |   8 ----
 x86/vmx_tests.c | 125 +++++++++++++++++++++++++++---------------------
 3 files changed, 74 insertions(+), 63 deletions(-)

diff --git a/x86/vmx.c b/x86/vmx.c
index dc52efa7..25a8d9f8 100644
--- a/x86/vmx.c
+++ b/x86/vmx.c
@@ -1254,7 +1254,9 @@ int init_vmcs(struct vmcs **vmcs)
 
 	/* All settings to pin/exit/enter/cpu
 	   control fields should be placed here */
-	ctrl_pin |= PIN_EXTINT | PIN_NMI | PIN_VIRT_NMI;
+	ctrl_pin |= PIN_BASED_EXT_INTR_MASK |
+		    PIN_BASED_NMI_EXITING |
+		    PIN_BASED_VIRTUAL_NMIS;
 	ctrl_exit = EXI_LOAD_EFER | EXI_HOST_64 | EXI_LOAD_PAT;
 	ctrl_enter = (ENT_LOAD_EFER | ENT_GUEST_64);
 	/* DIsable IO instruction VMEXIT now */
diff --git a/x86/vmx.h b/x86/vmx.h
index 36e784a7..e0e23ab6 100644
--- a/x86/vmx.h
+++ b/x86/vmx.h
@@ -427,14 +427,6 @@ enum Ctrl_ent {
 	ENT_LOAD_BNDCFGS	= 1UL << 16
 };
 
-enum Ctrl_pin {
-	PIN_EXTINT		= 1ul << 0,
-	PIN_NMI			= 1ul << 3,
-	PIN_VIRT_NMI		= 1ul << 5,
-	PIN_PREEMPT		= 1ul << 6,
-	PIN_POST_INTR		= 1ul << 7,
-};
-
 enum Intr_type {
 	VMX_INTR_TYPE_EXT_INTR = 0,
 	VMX_INTR_TYPE_NMI_INTR = 2,
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index ba50f2ee..1ea5d35b 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -128,11 +128,12 @@ u64 saved_rip;
 
 static int preemption_timer_init(struct vmcs *vmcs)
 {
-	if (!(ctrl_pin_rev.clr & PIN_PREEMPT)) {
+	if (!(ctrl_pin_rev.clr & PIN_BASED_VMX_PREEMPTION_TIMER)) {
 		printf("\tPreemption timer is not supported\n");
 		return VMX_TEST_EXIT;
 	}
-	vmcs_write(PIN_CONTROLS, vmcs_read(PIN_CONTROLS) | PIN_PREEMPT);
+	vmcs_write(PIN_CONTROLS, vmcs_read(PIN_CONTROLS) |
+		   PIN_BASED_VMX_PREEMPTION_TIMER);
 	preempt_val = 10000000;
 	vmcs_write(PREEMPT_TIMER_VALUE, preempt_val);
 	preempt_scale = rdmsr(MSR_IA32_VMX_MISC) & 0x1F;
@@ -194,7 +195,8 @@ static int preemption_timer_exit_handler(union exit_reason exit_reason)
 			       "preemption timer during hlt");
 			vmx_set_test_stage(4);
 			vmcs_write(PIN_CONTROLS,
-				   vmcs_read(PIN_CONTROLS) & ~PIN_PREEMPT);
+				   vmcs_read(PIN_CONTROLS) &
+				   ~PIN_BASED_VMX_PREEMPTION_TIMER);
 			vmcs_write(EXI_CONTROLS,
 				   vmcs_read(EXI_CONTROLS) & ~EXI_SAVE_PREEMPT);
 			vmcs_write(GUEST_ACTV_STATE, ACTV_ACTIVE);
@@ -236,7 +238,8 @@ static int preemption_timer_exit_handler(union exit_reason exit_reason)
 			/* fall through */
 		case 4:
 			vmcs_write(PIN_CONTROLS,
-				   vmcs_read(PIN_CONTROLS) | PIN_PREEMPT);
+				   vmcs_read(PIN_CONTROLS) |
+				   PIN_BASED_VMX_PREEMPTION_TIMER);
 			vmcs_write(PREEMPT_TIMER_VALUE, 0);
 			saved_rip = guest_rip + insn_len;
 			return VMX_TEST_RESUME;
@@ -255,7 +258,8 @@ static int preemption_timer_exit_handler(union exit_reason exit_reason)
 		report_fail("Unknown exit reason, 0x%x", exit_reason.full);
 		print_vmexit_info(exit_reason);
 	}
-	vmcs_write(PIN_CONTROLS, vmcs_read(PIN_CONTROLS) & ~PIN_PREEMPT);
+	vmcs_write(PIN_CONTROLS, vmcs_read(PIN_CONTROLS) &
+		   ~PIN_BASED_VMX_PREEMPTION_TIMER);
 	return VMX_TEST_VMEXIT;
 }
 
@@ -1618,7 +1622,8 @@ static void timer_isr(isr_regs_t *regs)
 static int interrupt_init(struct vmcs *vmcs)
 {
 	msr_bmp_init();
-	vmcs_write(PIN_CONTROLS, vmcs_read(PIN_CONTROLS) & ~PIN_EXTINT);
+	vmcs_write(PIN_CONTROLS, vmcs_read(PIN_CONTROLS) &
+		   ~PIN_BASED_EXT_INTR_MASK);
 	handle_irq(TIMER_VECTOR, timer_isr);
 	return VMX_TEST_START;
 }
@@ -1727,17 +1732,20 @@ static int interrupt_exit_handler(union exit_reason exit_reason)
 		case 2:
 		case 5:
 			vmcs_write(PIN_CONTROLS,
-				   vmcs_read(PIN_CONTROLS) | PIN_EXTINT);
+				   vmcs_read(PIN_CONTROLS) |
+				   PIN_BASED_EXT_INTR_MASK);
 			break;
 		case 7:
 			vmcs_write(EXI_CONTROLS, vmcs_read(EXI_CONTROLS) | EXI_INTA);
 			vmcs_write(PIN_CONTROLS,
-				   vmcs_read(PIN_CONTROLS) | PIN_EXTINT);
+				   vmcs_read(PIN_CONTROLS) |
+				   PIN_BASED_EXT_INTR_MASK);
 			break;
 		case 1:
 		case 3:
 			vmcs_write(PIN_CONTROLS,
-				   vmcs_read(PIN_CONTROLS) & ~PIN_EXTINT);
+				   vmcs_read(PIN_CONTROLS) &
+				   ~PIN_BASED_EXT_INTR_MASK);
 			break;
 		case 4:
 		case 6:
@@ -1788,9 +1796,9 @@ static int nmi_hlt_init(struct vmcs *vmcs)
 	msr_bmp_init();
 	handle_irq(NMI_VECTOR, nmi_isr);
 	vmcs_write(PIN_CONTROLS,
-		   vmcs_read(PIN_CONTROLS) & ~PIN_NMI);
+		   vmcs_read(PIN_CONTROLS) & ~PIN_BASED_NMI_EXITING);
 	vmcs_write(PIN_CONTROLS,
-		   vmcs_read(PIN_CONTROLS) & ~PIN_VIRT_NMI);
+		   vmcs_read(PIN_CONTROLS) & ~PIN_BASED_VIRTUAL_NMIS);
 	return VMX_TEST_START;
 }
 
@@ -1860,9 +1868,9 @@ static int nmi_hlt_exit_handler(union exit_reason exit_reason)
         }
 
         vmcs_write(PIN_CONTROLS,
-               vmcs_read(PIN_CONTROLS) | PIN_NMI);
+		   vmcs_read(PIN_CONTROLS) | PIN_BASED_NMI_EXITING);
         vmcs_write(PIN_CONTROLS,
-               vmcs_read(PIN_CONTROLS) | PIN_VIRT_NMI);
+		   vmcs_read(PIN_CONTROLS) | PIN_BASED_VIRTUAL_NMIS);
         vmcs_write(GUEST_RIP, guest_rip + insn_len);
         break;
 
@@ -4053,7 +4061,7 @@ static void test_virtual_intr_ctls(void)
 	u32 pin = saved_pin;
 
 	if (!((ctrl_cpu_rev[1].clr & SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY) &&
-	    (ctrl_pin_rev.clr & PIN_EXTINT)))
+	      (ctrl_pin_rev.clr & PIN_BASED_EXT_INTR_MASK)))
 		return;
 
 	vmcs_write(CPU_EXEC_CTRL0,
@@ -4061,7 +4069,7 @@ static void test_virtual_intr_ctls(void)
 		   CPU_BASED_TPR_SHADOW);
 	vmcs_write(CPU_EXEC_CTRL1,
 		   secondary & ~SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY);
-	vmcs_write(PIN_CONTROLS, pin & ~PIN_EXTINT);
+	vmcs_write(PIN_CONTROLS, pin & ~PIN_BASED_EXT_INTR_MASK);
 	report_prefix_pushf("Virtualize interrupt-delivery disabled; external-interrupt exiting disabled");
 	test_vmx_valid_controls();
 	report_prefix_pop();
@@ -4072,12 +4080,12 @@ static void test_virtual_intr_ctls(void)
 	test_vmx_invalid_controls();
 	report_prefix_pop();
 
-	vmcs_write(PIN_CONTROLS, pin | PIN_EXTINT);
+	vmcs_write(PIN_CONTROLS, pin | PIN_BASED_EXT_INTR_MASK);
 	report_prefix_pushf("Virtualize interrupt-delivery enabled; external-interrupt exiting enabled");
 	test_vmx_valid_controls();
 	report_prefix_pop();
 
-	vmcs_write(PIN_CONTROLS, pin & ~PIN_EXTINT);
+	vmcs_write(PIN_CONTROLS, pin & ~PIN_BASED_EXT_INTR_MASK);
 	report_prefix_pushf("Virtualize interrupt-delivery enabled; external-interrupt exiting disabled");
 	test_vmx_invalid_controls();
 	report_prefix_pop();
@@ -4124,9 +4132,9 @@ static void test_posted_intr(void)
 	u16 vec;
 	int i;
 
-	if (!((ctrl_pin_rev.clr & PIN_POST_INTR) &&
-	    (ctrl_cpu_rev[1].clr & SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY) &&
-	    (ctrl_exit_rev.clr & EXI_INTA)))
+	if (!((ctrl_pin_rev.clr & PIN_BASED_POSTED_INTR) &&
+	      (ctrl_cpu_rev[1].clr & SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY) &&
+	      (ctrl_exit_rev.clr & EXI_INTA)))
 		return;
 
 	vmcs_write(CPU_EXEC_CTRL0,
@@ -4136,7 +4144,7 @@ static void test_posted_intr(void)
 	/*
 	 * Test virtual-interrupt-delivery and acknowledge-interrupt-on-exit
 	 */
-	pin |= PIN_POST_INTR;
+	pin |= PIN_BASED_POSTED_INTR;
 	vmcs_write(PIN_CONTROLS, pin);
 	secondary &= ~SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY;
 	vmcs_write(CPU_EXEC_CTRL1, secondary);
@@ -4777,8 +4785,9 @@ static void test_nmi_ctrls(void)
 {
 	u32 pin_ctrls, cpu_ctrls0, test_pin_ctrls, test_cpu_ctrls0;
 
-	if ((ctrl_pin_rev.clr & (PIN_NMI | PIN_VIRT_NMI)) !=
-	    (PIN_NMI | PIN_VIRT_NMI)) {
+	if ((ctrl_pin_rev.clr &
+	     (PIN_BASED_NMI_EXITING | PIN_BASED_VIRTUAL_NMIS)) !=
+	    (PIN_BASED_NMI_EXITING | PIN_BASED_VIRTUAL_NMIS)) {
 		report_skip("%s : NMI exiting and/or Virtual NMIs not supported", __func__);
 		return;
 	}
@@ -4787,7 +4796,7 @@ static void test_nmi_ctrls(void)
 	pin_ctrls = vmcs_read(PIN_CONTROLS);
 	cpu_ctrls0 = vmcs_read(CPU_EXEC_CTRL0);
 
-	test_pin_ctrls = pin_ctrls & ~(PIN_NMI | PIN_VIRT_NMI);
+	test_pin_ctrls = pin_ctrls & ~(PIN_BASED_NMI_EXITING | PIN_BASED_VIRTUAL_NMIS);
 	test_cpu_ctrls0 = cpu_ctrls0 & ~CPU_BASED_NMI_WINDOW_EXITING;
 
 	vmcs_write(PIN_CONTROLS, test_pin_ctrls);
@@ -4795,17 +4804,19 @@ static void test_nmi_ctrls(void)
 	test_vmx_valid_controls();
 	report_prefix_pop();
 
-	vmcs_write(PIN_CONTROLS, test_pin_ctrls | PIN_VIRT_NMI);
+	vmcs_write(PIN_CONTROLS, test_pin_ctrls | PIN_BASED_VIRTUAL_NMIS);
 	report_prefix_pushf("NMI-exiting disabled, virtual-NMIs enabled");
 	test_vmx_invalid_controls();
 	report_prefix_pop();
 
-	vmcs_write(PIN_CONTROLS, test_pin_ctrls | (PIN_NMI | PIN_VIRT_NMI));
+	vmcs_write(PIN_CONTROLS,
+		   test_pin_ctrls | (PIN_BASED_NMI_EXITING |
+		   PIN_BASED_VIRTUAL_NMIS));
 	report_prefix_pushf("NMI-exiting enabled, virtual-NMIs enabled");
 	test_vmx_valid_controls();
 	report_prefix_pop();
 
-	vmcs_write(PIN_CONTROLS, test_pin_ctrls | PIN_NMI);
+	vmcs_write(PIN_CONTROLS, test_pin_ctrls | PIN_BASED_NMI_EXITING);
 	report_prefix_pushf("NMI-exiting enabled, virtual-NMIs disabled");
 	test_vmx_valid_controls();
 	report_prefix_pop();
@@ -4828,14 +4839,16 @@ static void test_nmi_ctrls(void)
 	test_vmx_valid_controls();
 	report_prefix_pop();
 
-	vmcs_write(PIN_CONTROLS, test_pin_ctrls | (PIN_NMI | PIN_VIRT_NMI));
+	vmcs_write(PIN_CONTROLS, test_pin_ctrls |
+		   (PIN_BASED_NMI_EXITING | PIN_BASED_VIRTUAL_NMIS));
 	vmcs_write(CPU_EXEC_CTRL0, test_cpu_ctrls0 |
 		   CPU_BASED_NMI_WINDOW_EXITING);
 	report_prefix_pushf("Virtual-NMIs enabled, NMI-window-exiting enabled");
 	test_vmx_valid_controls();
 	report_prefix_pop();
 
-	vmcs_write(PIN_CONTROLS, test_pin_ctrls | (PIN_NMI | PIN_VIRT_NMI));
+	vmcs_write(PIN_CONTROLS, test_pin_ctrls |
+		   (PIN_BASED_NMI_EXITING | PIN_BASED_VIRTUAL_NMIS));
 	vmcs_write(CPU_EXEC_CTRL0, test_cpu_ctrls0);
 	report_prefix_pushf("Virtual-NMIs enabled, NMI-window-exiting disabled");
 	test_vmx_valid_controls();
@@ -5101,12 +5114,12 @@ static void test_vmx_preemption_timer(void)
 	u32 exit = saved_exit;
 
 	if (!((ctrl_exit_rev.clr & EXI_SAVE_PREEMPT) ||
-	    (ctrl_pin_rev.clr & PIN_PREEMPT))) {
+	    (ctrl_pin_rev.clr & PIN_BASED_VMX_PREEMPTION_TIMER))) {
 		report_skip("%s : \"Save-VMX-preemption-timer\" and/or \"Enable-VMX-preemption-timer\" control not supported", __func__);
 		return;
 	}
 
-	pin |= PIN_PREEMPT;
+	pin |= PIN_BASED_VMX_PREEMPTION_TIMER;
 	vmcs_write(PIN_CONTROLS, pin);
 	exit &= ~EXI_SAVE_PREEMPT;
 	vmcs_write(EXI_CONTROLS, exit);
@@ -5120,7 +5133,7 @@ static void test_vmx_preemption_timer(void)
 	test_vmx_valid_controls();
 	report_prefix_pop();
 
-	pin &= ~PIN_PREEMPT;
+	pin &= ~PIN_BASED_VMX_PREEMPTION_TIMER;
 	vmcs_write(PIN_CONTROLS, pin);
 	report_prefix_pushf("enable-VMX-preemption-timer disabled, save-VMX-preemption-timer enabled");
 	test_vmx_invalid_controls();
@@ -6294,7 +6307,7 @@ static bool cpu_has_apicv(void)
 {
 	return ((ctrl_cpu_rev[1].clr & SECONDARY_EXEC_APIC_REGISTER_VIRT) &&
 		(ctrl_cpu_rev[1].clr & SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY) &&
-		(ctrl_pin_rev.clr & PIN_POST_INTR));
+		(ctrl_pin_rev.clr & PIN_BASED_POSTED_INTR));
 }
 
 /* Validates APIC register access across valid virtualization configurations. */
@@ -8665,7 +8678,7 @@ static void vmx_pending_event_test_core(bool guest_hlt)
 	vmx_pending_event_guest_run = false;
 	test_set_guest(vmx_pending_event_guest);
 
-	vmcs_set_bits(PIN_CONTROLS, PIN_EXTINT);
+	vmcs_set_bits(PIN_CONTROLS, PIN_BASED_EXT_INTR_MASK);
 
 	enter_guest();
 	skip_exit_vmcall();
@@ -8739,7 +8752,7 @@ static void vmx_nmi_window_test(void)
 	u64 nop_addr;
 	void *db_fault_addr = get_idt_addr(&boot_idt[DB_VECTOR]);
 
-	if (!(ctrl_pin_rev.clr & PIN_VIRT_NMI)) {
+	if (!(ctrl_pin_rev.clr & PIN_BASED_VIRTUAL_NMIS)) {
 		report_skip("%s : \"Virtual NMIs\" exec control not supported", __func__);
 		return;
 	}
@@ -8753,7 +8766,7 @@ static void vmx_nmi_window_test(void)
 
 	report_prefix_push("NMI-window");
 	test_set_guest(vmx_nmi_window_test_guest);
-	vmcs_set_bits(PIN_CONTROLS, PIN_VIRT_NMI);
+	vmcs_set_bits(PIN_CONTROLS, PIN_BASED_VIRTUAL_NMIS);
 	enter_guest();
 	skip_exit_vmcall();
 	nop_addr = vmcs_read(GUEST_RIP);
@@ -9064,13 +9077,13 @@ static void vmx_preemption_timer_zero_test_guest(void)
 
 static void vmx_preemption_timer_zero_activate_preemption_timer(void)
 {
-	vmcs_set_bits(PIN_CONTROLS, PIN_PREEMPT);
+	vmcs_set_bits(PIN_CONTROLS, PIN_BASED_VMX_PREEMPTION_TIMER);
 	vmcs_write(PREEMPT_TIMER_VALUE, 0);
 }
 
 static void vmx_preemption_timer_zero_advance_past_vmcall(void)
 {
-	vmcs_clear_bits(PIN_CONTROLS, PIN_PREEMPT);
+	vmcs_clear_bits(PIN_CONTROLS, PIN_BASED_VMX_PREEMPTION_TIMER);
 	enter_guest();
 	skip_exit_vmcall();
 }
@@ -9114,7 +9127,7 @@ static void vmx_preemption_timer_zero_test(void)
 	handler old_db;
 	u32 reason;
 
-	if (!(ctrl_pin_rev.clr & PIN_PREEMPT)) {
+	if (!(ctrl_pin_rev.clr & PIN_BASED_VMX_PREEMPTION_TIMER)) {
 		report_skip("%s : \"Activate VMX-preemption timer\" pin control not supported", __func__);
 		return;
 	}
@@ -9165,7 +9178,7 @@ static void vmx_preemption_timer_zero_test(void)
 	report(reason == VMX_EXC_NMI, "Exit reason is 0x%x (expected 0x%x)",
 	       reason, VMX_EXC_NMI);
 
-	vmcs_clear_bits(PIN_CONTROLS, PIN_PREEMPT);
+	vmcs_clear_bits(PIN_CONTROLS, PIN_BASED_VMX_PREEMPTION_TIMER);
 	enter_guest();
 
 	handle_exception(DB_VECTOR, old_db);
@@ -9229,7 +9242,7 @@ static void vmx_preemption_timer_tf_test(void)
 	u32 reason;
 	int i;
 
-	if (!(ctrl_pin_rev.clr & PIN_PREEMPT)) {
+	if (!(ctrl_pin_rev.clr & PIN_BASED_VMX_PREEMPTION_TIMER)) {
 		report_skip("%s : \"Activate VMX-preemption timer\" pin control not supported", __func__);
 		return;
 	}
@@ -9243,7 +9256,7 @@ static void vmx_preemption_timer_tf_test(void)
 	skip_exit_vmcall();
 
 	vmx_set_test_stage(1);
-	vmcs_set_bits(PIN_CONTROLS, PIN_PREEMPT);
+	vmcs_set_bits(PIN_CONTROLS, PIN_BASED_VMX_PREEMPTION_TIMER);
 	vmcs_write(PREEMPT_TIMER_VALUE, 50000);
 	vmcs_write(GUEST_RFLAGS, X86_EFLAGS_FIXED | X86_EFLAGS_TF);
 
@@ -9268,7 +9281,7 @@ static void vmx_preemption_timer_tf_test(void)
 	report(reason == VMX_PREEMPT, "No single-step traps skipped");
 
 	vmx_set_test_stage(2);
-	vmcs_clear_bits(PIN_CONTROLS, PIN_PREEMPT);
+	vmcs_clear_bits(PIN_CONTROLS, PIN_BASED_VMX_PREEMPTION_TIMER);
 	enter_guest();
 
 	handle_exception(DB_VECTOR, old_db);
@@ -9320,7 +9333,7 @@ static void vmx_preemption_timer_expiry_test(void)
 	u64 tsc_deadline;
 	u32 reason;
 
-	if (!(ctrl_pin_rev.clr & PIN_PREEMPT)) {
+	if (!(ctrl_pin_rev.clr & PIN_BASED_VMX_PREEMPTION_TIMER)) {
 		report_skip("%s : \"Activate VMX-preemption timer\" pin control not supported", __func__);
 		return;
 	}
@@ -9334,7 +9347,7 @@ static void vmx_preemption_timer_expiry_test(void)
 	preemption_timer_value =
 		VMX_PREEMPTION_TIMER_EXPIRY_CYCLES >> misc.pt_bit;
 
-	vmcs_set_bits(PIN_CONTROLS, PIN_PREEMPT);
+	vmcs_set_bits(PIN_CONTROLS, PIN_BASED_VMX_PREEMPTION_TIMER);
 	vmcs_write(PREEMPT_TIMER_VALUE, preemption_timer_value);
 	vmx_set_test_stage(0);
 
@@ -9349,7 +9362,7 @@ static void vmx_preemption_timer_expiry_test(void)
 	       "Last stored guest TSC (%lu) < TSC deadline (%lu)",
 	       vmx_preemption_timer_expiry_finish, tsc_deadline);
 
-	vmcs_clear_bits(PIN_CONTROLS, PIN_PREEMPT);
+	vmcs_clear_bits(PIN_CONTROLS, PIN_BASED_VMX_PREEMPTION_TIMER);
 	vmx_set_test_stage(1);
 	enter_guest();
 }
@@ -9570,7 +9583,7 @@ static void enable_vid(void)
 	virtual_apic_page = alloc_page();
 	vmcs_write(APIC_VIRT_ADDR, (u64)virtual_apic_page);
 
-	vmcs_set_bits(PIN_CONTROLS, PIN_EXTINT);
+	vmcs_set_bits(PIN_CONTROLS, PIN_BASED_EXT_INTR_MASK);
 
 	vmcs_write(EOI_EXIT_BITMAP0, 0x0);
 	vmcs_write(EOI_EXIT_BITMAP1, 0x0);
@@ -9589,7 +9602,7 @@ static void enable_posted_interrupts(void)
 {
 	void *pi_desc = alloc_page();
 
-	vmcs_set_bits(PIN_CONTROLS, PIN_POST_INTR);
+	vmcs_set_bits(PIN_CONTROLS, PIN_BASED_POSTED_INTR);
 	vmcs_set_bits(EXI_CONTROLS, EXI_INTA);
 	vmcs_write(PINV, PI_VECTOR);
 	vmcs_write(POSTED_INTR_DESC_ADDR, (u64)pi_desc);
@@ -9761,7 +9774,8 @@ static void vmx_apic_passthrough(bool set_irq_line_from_thread)
 
 	disable_intercept_for_x2apic_msrs();
 
-	vmcs_write(PIN_CONTROLS, vmcs_read(PIN_CONTROLS) & ~PIN_EXTINT);
+	vmcs_write(PIN_CONTROLS,
+		   vmcs_read(PIN_CONTROLS) & ~PIN_BASED_EXT_INTR_MASK);
 
 	vmcs_write(CPU_EXEC_CTRL0, vmcs_read(CPU_EXEC_CTRL0) | cpu_ctrl_0);
 	vmcs_write(CPU_EXEC_CTRL1, vmcs_read(CPU_EXEC_CTRL1) | cpu_ctrl_1);
@@ -9823,7 +9837,7 @@ static void vmx_apic_passthrough_tpr_threshold_test(void)
 	int ipi_vector = 0xe1;
 
 	disable_intercept_for_x2apic_msrs();
-	vmcs_clear_bits(PIN_CONTROLS, PIN_EXTINT);
+	vmcs_clear_bits(PIN_CONTROLS, PIN_BASED_EXT_INTR_MASK);
 
 	/* Raise L0 TPR-threshold by queueing vector in LAPIC IRR */
 	cli();
@@ -10094,7 +10108,8 @@ static void sipi_test_ap_thread(void *data)
 
 	/* passthrough lapic to L2 */
 	disable_intercept_for_x2apic_msrs();
-	vmcs_write(PIN_CONTROLS, vmcs_read(PIN_CONTROLS) & ~PIN_EXTINT);
+	vmcs_write(PIN_CONTROLS,
+		   vmcs_read(PIN_CONTROLS) & ~PIN_BASED_EXT_INTR_MASK);
 	vmcs_write(CPU_EXEC_CTRL0, vmcs_read(CPU_EXEC_CTRL0) | cpu_ctrl_0);
 	vmcs_write(CPU_EXEC_CTRL1, vmcs_read(CPU_EXEC_CTRL1) | cpu_ctrl_1);
 
@@ -10146,7 +10161,8 @@ static void vmx_sipi_signal_test(void)
 
 	/* passthrough lapic to L2 */
 	disable_intercept_for_x2apic_msrs();
-	vmcs_write(PIN_CONTROLS, vmcs_read(PIN_CONTROLS) & ~PIN_EXTINT);
+	vmcs_write(PIN_CONTROLS,
+		   vmcs_read(PIN_CONTROLS) & ~PIN_BASED_EXT_INTR_MASK);
 	vmcs_write(CPU_EXEC_CTRL0, vmcs_read(CPU_EXEC_CTRL0) | cpu_ctrl_0);
 	vmcs_write(CPU_EXEC_CTRL1, vmcs_read(CPU_EXEC_CTRL1) | cpu_ctrl_1);
 
@@ -10577,11 +10593,12 @@ static void rdtsc_vmexit_diff_test(void)
 
 static int invalid_msr_init(struct vmcs *vmcs)
 {
-	if (!(ctrl_pin_rev.clr & PIN_PREEMPT)) {
+	if (!(ctrl_pin_rev.clr & PIN_BASED_VMX_PREEMPTION_TIMER)) {
 		printf("\tPreemption timer is not supported\n");
 		return VMX_TEST_EXIT;
 	}
-	vmcs_write(PIN_CONTROLS, vmcs_read(PIN_CONTROLS) | PIN_PREEMPT);
+	vmcs_write(PIN_CONTROLS,
+		   vmcs_read(PIN_CONTROLS) | PIN_BASED_VMX_PREEMPTION_TIMER);
 	preempt_val = 10000000;
 	vmcs_write(PREEMPT_TIMER_VALUE, preempt_val);
 	preempt_scale = rdmsr(MSR_IA32_VMX_MISC) & 0x1F;
-- 
2.43.0


