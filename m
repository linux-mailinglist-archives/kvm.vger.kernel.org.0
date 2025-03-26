Return-Path: <kvm+bounces-42083-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 64205A7271B
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 00:37:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 199CA1896236
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 23:38:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF21F254849;
	Wed, 26 Mar 2025 23:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JGp+CJ1b";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jf9LxuoP"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DD1D12B94;
	Wed, 26 Mar 2025 23:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743032266; cv=fail; b=u+oY5SlAfa+om/0F3LYNxVAkdk0H2tkOv855IkrvPBDCzqQopKI2k8xsncNJJld6Z3cqNDS+ndkj5XAHmEjWEkPpw1zTjeLxhiunqE3OIlI8pBKcMd6ZzNROL4HVb7DEhrnzqJtyikYgPYMsyaSGk9ssKipF9UHV16YVrE/AEDo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743032266; c=relaxed/simple;
	bh=oCBXWuCpenOLpZFaIBozhzlnZQNiWYjcEvsygsc0acQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=bVryrpTKXRnACtYNiqQ3QMdZqHCsYSfMn/K2sElTyZhVsjbB/zYsqbiRSgtXKqFiRBecK06e3I7uwYkj6weDqJRr+6ZhqRl051mUBCDnVz2OGS4KzrDmvqNIQQz9cKjsMjTrl2jHlAvJXbd1Hj6+T3LQao3YxVMsIa3dcOgeA+E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JGp+CJ1b; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jf9LxuoP; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52QK0YRd032170;
	Wed, 26 Mar 2025 23:37:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=XawZhKEZ+jpVKt0efSYHPHrHwAmXITGKxtLi774rq9k=; b=
	JGp+CJ1bR+axgHsEex/W765rb+10ikKLDUIMwSrWoI/fm/QaxAXJ/HIX2RrXUdr/
	uR9fUDXKquVQ8SNhl1eH+43TnAKN8HYlTMEs5tP1hMrDj2Ku7nHhXWgVigEgxrsX
	UwYolY3QyPy4kjREhRuSzseNz8JL6FbsW0bcCRvMXxblEjCNpInxzXtNut14+Aua
	fjmhSCL1jHVFw5wPuCAL70VQIT4RKGgAXSx3ZchvDW+jsAyQi9aXDGA4SJVTrb2J
	sgv5L78+orkTkEdNJ2lTKYcu/cMjsXyIFqNnF5JUgI/hwaHjI/JBD2PCDrG2e+hf
	yggW/W1P2J2vReC22/lg2g==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45hnd6auy7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Mar 2025 23:37:40 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52QLv2QP028778;
	Wed, 26 Mar 2025 23:37:39 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2046.outbound.protection.outlook.com [104.47.58.46])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45jj6umvvp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Mar 2025 23:37:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P9QAXt1Ly/A5jnlwZaE8MF/c+I58Ruum8FCl8mj9QFlZJM6+Z7sgLgGy0R8wrPA+tcBiYCmnddc0k7jEk/RsB/d6HQGrpfGj+YbP5SzxKgo7P7DVlZW+gozBrIYZDTKeD9J4z/nrAY74o1pe6xXEuswCZUlpgIbB1vJ/ebpkpsfChpJ45dlg7j4121eNtTXVAJDE1EZPy9MThDc8W1uxGleLlJTIzlal2opawmfDAGpl49eFBHlWo7vhli2U7v1Js7TYwnUPPPZxU0QeaWjZhgANtg4Tli5452rlfbSKOMqde24/ec5p5jY36/XNi68v1ivBQhhVkfprzqsBIg3tDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XawZhKEZ+jpVKt0efSYHPHrHwAmXITGKxtLi774rq9k=;
 b=rbXOCx8FWiKet1Rqzdx+M4zhsLOBlKw5UEQPKZ4TuBZk1EaPf+lDcXfLjTKCm2tqoGm1FwPNjejH0MdE9GlpDp8qcNa1Fttdhaprs4GPTIKy7g3PeNskRV3LaGtnT/Id1n67UfDwhysJoqNK/ZmWhJ2EHjw7itgIo0yumDFek3ZDNnVyWjJ3zqFw8saDqEvQb5amXaqRCiXBEceWZ6HdlEUGNm2RuzxjtzTrEvaffTRhB2C/NTeSYdaNc+2KFtVtF/JCGzXnavjK/r7901Wedbv5H/xHsqIsql6fPzaFlJaYzuXy52qbDtHiKWnDTapkZPt6W82Sp5w6y8Ca9tc0yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XawZhKEZ+jpVKt0efSYHPHrHwAmXITGKxtLi774rq9k=;
 b=jf9LxuoPyHfNqCVbB98mzzHhnmkcKWFmY2cZZTuqOIM7T1ZsNRFsd3car56UhdTQLw/Y4N8Q8VceJAeu1jFELhqMA6qFcrOk33Cb0FcA1QNqeiGLPxrRn6dgXIWg5J0nYSPNnmg3qC/uz4+ApRr660OS9v0GFo4VqUzWCi4kCAA=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by IA1PR10MB6735.namprd10.prod.outlook.com (2603:10b6:208:42d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Wed, 26 Mar
 2025 23:37:37 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%4]) with mapi id 15.20.8534.043; Wed, 26 Mar 2025
 23:37:37 +0000
Message-ID: <38b02ca5-59dd-4193-bea7-e15e4f5f426e@oracle.com>
Date: Wed, 26 Mar 2025 18:37:35 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/10] vhost-scsi: cache log buffer in I/O queue
 vhost_scsi_cmd
To: Dongli Zhang <dongli.zhang@oracle.com>, virtualization@lists.linux.dev,
        kvm@vger.kernel.org, netdev@vger.kernel.org
Cc: mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com,
        stefanha@redhat.com, eperezma@redhat.com, joao.m.martins@oracle.com,
        joe.jin@oracle.com, si-wei.liu@oracle.com,
        linux-kernel@vger.kernel.org
References: <20250317235546.4546-1-dongli.zhang@oracle.com>
 <20250317235546.4546-7-dongli.zhang@oracle.com>
 <80a47281-d995-4499-a4c8-f251ca309450@oracle.com>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <80a47281-d995-4499-a4c8-f251ca309450@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0003.namprd03.prod.outlook.com
 (2603:10b6:5:3b8::8) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|IA1PR10MB6735:EE_
X-MS-Office365-Filtering-Correlation-Id: eff9e151-4195-41f8-b012-08dd6cbf30ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dzV6aG82ZTVVRk9QV0x4dG1BZFRtQ2VHeERQWWdqVnludDJweXNzWjhsVzQw?=
 =?utf-8?B?QVZQeE5lK3JKNHFYV0tpT3VaNllhWFFMOUJxTU40VWxlemMvY2ZHQUhSN1V3?=
 =?utf-8?B?UU94Sk1pc1dyWHJid3IzZEIvSGdEQXNub0ZrcXp2ZnFLd1NmWmRoQU5ZU3pV?=
 =?utf-8?B?OTdGNk9Ka1dHUklaMGo3cUV1NlFPSkpPd2VQMU1xSG0zdGlQSnlrOG1RUTFn?=
 =?utf-8?B?SmRaeVdodWVreEhmMk1PVERtWkI1R01VNkRLc3d5VlZqK0syWk5jWmZuQko5?=
 =?utf-8?B?QzQwWXNOam16eklnNExLdTZvV2xlc1lyWTczeWZGdGwyL2lxeG1kZng5NlJi?=
 =?utf-8?B?NFI4T2NCRlJvMHl1dGVFcTEvQjdXd2VRcStrY0IzeFYyd0U3Z1piNzhacW5S?=
 =?utf-8?B?OXJoeUN2Ni9FS3VnbExoRnpWcnlaWHFqV3VYQ3UxbW5tVVRTTUlvQTNzS3Jn?=
 =?utf-8?B?aWtEUTNqUlJpZWlENWVvMldIdEx4WHMwaVBtZGFMMVVLUHNMWlBNb2xMNmlG?=
 =?utf-8?B?M25kaStLTnp2aTNlckxISHBkRm1xMnNUNkYwaHVIb056UWR2Y3BMa0QwOHRl?=
 =?utf-8?B?RzE3S3ByTy82S1RpTnd0clJrMHdjTExwZzJUeVFXNmlIdU1ieW5jcFBoT1NM?=
 =?utf-8?B?ZXBEdzFuUWtKaGdQbE51UzhGTTJJL3BUcm1oWFhoNFBZRUNqek1OOFBUQlUz?=
 =?utf-8?B?MHhRNVVnenhLM3p3QjMzd1prcjJhNER2SEJsSFUzU3FvVSt5T1JoT3J5cTBP?=
 =?utf-8?B?YTZaWmR5ZzIzTkNNcmFpdTZ4MUFCcTVVWGE4S2t5eHkwZDAzZGtsSnZOZW01?=
 =?utf-8?B?UE9nbGhrUHhUaFJ4ckZzYTJUb3M0MlY5WE5DRzEzRGtueHh4T3laWU1pSUh6?=
 =?utf-8?B?RDA3b3NHSnIrZTRuVDBsc29tT3hxNk9JWG1wajVEZ2prbXZqZks2N0VleXFr?=
 =?utf-8?B?MDBlVjhYc05LNDZBdkM4UzJ1WGIyVkFPazR1Zk5pWnVqUnlOeVJGN0dXcWtV?=
 =?utf-8?B?R0c2N0puK1VZM0libmtpQnZrR1FEMzYzK3FTbEorNUdWWW0xTGJGT1pTK1pq?=
 =?utf-8?B?TU1QdnZwZm43QjlUVDZEVW1UTU8wdUlwbm5TMlFzZWNkT2FESkZVZFlqR0dw?=
 =?utf-8?B?Q3V4bGFvcFZnTmdvLy9xTUl3UDJqcGxEY293YTFhYlRyMGNXWmtIODk0RTNX?=
 =?utf-8?B?M2tYTHpNbVBBUnl0M2xZb2xQa3o2VFlDNmEwd3NydW5GYmRZSGlnK3d3TWxq?=
 =?utf-8?B?anFNRDNtSEs2UVM5MUZDSGhoSkp2NUV2WVBQS2FBSWRZWEx4UlhiVWV1Nkhq?=
 =?utf-8?B?blhUUTZ1RVZLMU5hQitpalJVWGNHYmdaczJ6ODEydWJ3cHlmUCtXNHUySEtY?=
 =?utf-8?B?eG9WeGhabGtXRllhUk9HTm5sVDdzb2ZHcFh6cS9UeUk3Qmp6b1R4cGRqY2Vj?=
 =?utf-8?B?N2p6bHNVVHZha2k2ZzQxS0dCdHo4QitFcnh2eFNtRnh1TDdOR21pQ2pGUFQ1?=
 =?utf-8?B?Y0wxcjJjbW8vU2lQaFVwUnZhUHBuK2ZrTFFEaDV1MkhkTjd3YkpXNWhRWmlH?=
 =?utf-8?B?T0ttUTFmeHpsT3lCQ3ZxZ2EwMnhadUxFSjAzVk42ekNoOTl2UW5lZTRYdjhS?=
 =?utf-8?B?VFNxanlwcDJSNWxuUmFMRWF2YXZQQ2J3bzJHYXV5K2IyRVNtdERIa1hBajRk?=
 =?utf-8?B?OUNGdGJ2M2lwTlI0YU4rZWF6L05tejcvSXM0UWorL1pvZGppK0ZmWTR1aTVB?=
 =?utf-8?B?ejd1MlBQaFRJUnkvNkZycHNUQktRZWZLcmFxbWdyYm81T0JSYnBwbTlCL2Ja?=
 =?utf-8?B?WGxxS1dUZUI3S2txWG81bUpPY3M0bjY0ZS9hc1hBMzg0c3JyUEZjM2xWblNl?=
 =?utf-8?B?ai9XcDREdmhQTlN6S1huSEQ5UWxGUGhrdlhaYWMxU0hJamc9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VFR2djJ5WEJhRDBqaE1YNHhZN0VpUUZ3MnFtTDNrc3oyaUhUWWxTc1lxamlW?=
 =?utf-8?B?YXBsMGQ1bVdQSmlPckVVNUs4WHlrR3VLcEpTR3cyN3dLWlM2TjdjTThCVWJI?=
 =?utf-8?B?UW5udUlLa0t0eHdrVyt0MXZXbnRoaFR6dlIvTWtuMEhlbFI2Z28wMjg2YytC?=
 =?utf-8?B?Qk1KU0hrOGFjRUFqVEhWNlh2VVNIQ1VkTWkxYXltcW92eU03TkppVFppeTgy?=
 =?utf-8?B?QnhqZFBPOEtOTkZrQXdieUxPZnRsSXRDREdkTThSQXBLNDZvM0RuZEpRbUZj?=
 =?utf-8?B?RmtDbHF6OUhyMElBUGx0dkFtbGtrK3ExemZBUWVPaVhVWVJIb0dIZzRHd0Va?=
 =?utf-8?B?cmxxS0taSnpQbmtjTm1mS1pJY2crQVhiVVFPRHR3dUdURW85Q2Z6UzF4cito?=
 =?utf-8?B?Q3YwSDNLQXRJYml6blo0REF1SGVjTDRhWUQ4eVkvQzhJb2dhdk0zS0J6RSsy?=
 =?utf-8?B?MWtMSnhtQ0wwWmdCWGRzVVVIWVJuVjh1UU1GWFFNWDZOaHVCa2o5OEV6Q1Mx?=
 =?utf-8?B?YVRFYU9LUlBDaTluQmsrQm9yeUJuVzArc2RvY2Y2TmRYVlBKMkpJWE13RW9w?=
 =?utf-8?B?andnK0RJOFVSOFZGTEZmNHpZNHFoai9lb0Z0aEdSWFRGbDcxK2NRTUZkc3c3?=
 =?utf-8?B?TEw2bmVtM0xNTnprQ3RUVzdJYVQzUTI5N3k3NXNLZW1idDc2U0JGTi84K01z?=
 =?utf-8?B?ZXVoTmV3RUUyQXBmb0gxelJzY05aWHIzT3hjRHBGaDErZzA3aXNPNm40ZVB4?=
 =?utf-8?B?US9IcnIzaUNCU2kzTTZHR0tQdlNLYU5pRVoySGFjU2xBQmJLemJnWjlkSXRh?=
 =?utf-8?B?RGc2cmVYUWQ2MHMyYkxtQllPREhsTlVQS1dYbHNFckhOVVovMXdjbENncEwv?=
 =?utf-8?B?Y3JkcFo2MmhSaWRzbDI4M1JuR1FnUm5GRk1mdWtLOUFKZkk1YVI1U09Md2p0?=
 =?utf-8?B?czBmY2hsZTRleTg2QzNuVE1nbHZjOHk0L3VCYmd4eEVzRDBTQmI5QTFzcWt4?=
 =?utf-8?B?dFFTT09GSzJ3WnVMZWY2V0pBYmtJblJOcGo4Y09wMmJmRWsraFZsT0JUcjNt?=
 =?utf-8?B?SnppOWQ3R0tzY2RhRE93U0ErdzY1OVNkYTE1NFQvNGVVTGZWZjJXeW5KME4x?=
 =?utf-8?B?MEFMSDRwUVc3SEVWV1poN2tuTUJLckFxbFlDbkI1RmZkTk9zM1NvazZJQlRP?=
 =?utf-8?B?VGRKc201MVArNExyUStjQVV5emlCeStrN2lsWXlpSEN2MWZIbFRFcmRWVkFS?=
 =?utf-8?B?dExLc25rY0I0Y1htRHR3UzQ0YVFMeXJ5WFRaOTR6enRzb0F5eVBsMXZtN0NI?=
 =?utf-8?B?MXY2dG92L0ZWYmRZNHk3Vy80TldhbVF0SHB2OTMvQy8vN0RZRW9aVFFpeTBI?=
 =?utf-8?B?Mkw3WG9qcTBPZGkxWFQ0aDFUd0tEempoeHg3bXpsemRsRlI4SUhSYnhwNmpa?=
 =?utf-8?B?ZXVISWNvZUUvVWJwNDA1OUhYNU5oWEtJVHlOTUw5UFlRamM3NURSSi9ZNWlV?=
 =?utf-8?B?SldWMU56ejVTcTErOE5iQkdYTU5SeTFYNWFPZmJNbFYwNERWRnBrQ3NPbURF?=
 =?utf-8?B?YldaYUVNMys5SDI4aCtXVEd2ekREM0h0SzI4c3FjRzk1QVlidTNES0VGNnZZ?=
 =?utf-8?B?UklNdUlkU3FvTFl0MXE5OWs2eVYxOERpa0VleXlpYVFOL2NqZ0pFdjl1UEp0?=
 =?utf-8?B?SVZpY05LYWczbDdoZWRVVjJnajNXdnJ0S3FTSXFyUDhsKzVxenpnVEZYTTlE?=
 =?utf-8?B?eU4zSWNvNE5lOFB6cUV3clNLREorRUNVQ09MMytBQy9EQWlXRzVxWFBYSjNQ?=
 =?utf-8?B?S1RLbCtTQm9wWUloRmp3TlUvZVJYek11T0JRelhDVGcycnNiT25hUXNDU3RX?=
 =?utf-8?B?NXVGLzNBSkMzL1daS1BwVk9CM01HZzNrcjZtYmNJZjk0ZmdOU2tmRFdxdFF0?=
 =?utf-8?B?djJkcmd2SXlNWUNVS1ZqWUdXY1BiL05hSTZsNHZaMkkzUVJ5Z3pUYkNpQnpL?=
 =?utf-8?B?UXFET0JFWlNYR0R0RVhjVjFkbEY3aWJXeTh1eG55V0RTV3h2eS9TMmk5YkRz?=
 =?utf-8?B?Y2FvMUdtWGZ5QkNmN1prVllGdFg5bThlMEVhQld5Mld0c2RZYzVpMGV1UkxZ?=
 =?utf-8?B?aVY5Q2VIWDdoVFdwaXJWR29JNVhYZXp3SWE2U3E2OSsrVTBMK3MwUUJCdWE2?=
 =?utf-8?B?Znc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	u+n4pg7Qn73IcnTRdiGYv6TfZCNwuKXAj3ksaYpdId+E1RYxy14PqfKd1O5yrJ42UhgXXTgKERQ/SnzO4M5nDH8yL/rkUalFxLtxetu90GtxQPY9CCpwY0miyqgJEBxc3ZekvRifiT4U5X2fhmhPffU+vLJ+/SSSdFhMNSxRTD0si5ICkKecSRbeXT3qLKD7dWcBVS4P3GIOYL9vygVM/OhBuI/NoX7myO/rTJPZIugHsTkKS/8mNkBEh+YkDELwSptHM5ueQGKsjOUOri6z99fHyW6kIhCYqLasEkv92pjAZwgfcmmUs5R4kPCwGxX78rRkB0WMU2mtfT/JxwY3tzm08UBpfcpDPH7plm+x0QAeCamLnfI6yMSXKJCmqUM7OJiL0puXxbfMqnXZKrnQ4dzb4Ln441SGG8SBa39X47kQTu56RoEQqHuhhQeLh2vGyDrGuOLr1wsX7QeECPeucRHrVH1AZkJBPCUFbpaBXbhazerGVJ+6FejIjgv/8mlFdgRJ/LKsZ29LOlG9TMpVDTvhTm7NbnlQq2sET9CUhDiX9KVcbOXen1yzgRTodIEGEx4ZvsEsFuWeBP3bprX+vOdVpmQdF1DOgSh+MIqVw58=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eff9e151-4195-41f8-b012-08dd6cbf30ce
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2025 23:37:37.1457
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EmO1uhp7oF1vQw1DuY1giY9Qxl7ZeJ4kZUBdpA8DuIgr2F3ySNAW3QAZ/BqPInFgyGHimi2MTrf3wXSTHBM9+vzo7RvYNd5BQuxqROQoYjE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6735
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-26_09,2025-03-26_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 adultscore=0 malwarescore=0 spamscore=0 mlxlogscore=986 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2503260146
X-Proofpoint-ORIG-GUID: fFh6r667__hc3xQUKhL3_BSQUyOhfzed
X-Proofpoint-GUID: fFh6r667__hc3xQUKhL3_BSQUyOhfzed

On 3/17/25 7:04 PM, Dongli Zhang wrote:
> @@ -1390,6 +1424,24 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
>  			goto err;
>  		}
> 
> +		if (unlikely(vq_log && log_num)) {
> +			if (!cmd->tvc_log)
> +				cmd->tvc_log = kmalloc_array(vq->dev->iov_limit,
> +							     sizeof(*cmd->tvc_log),
> +							     GFP_KERNEL);
> +
> +			if (likely(cmd->tvc_log)) {
> +				memcpy(cmd->tvc_log, vq->log,> +				       sizeof(*cmd->tvc_log) * log_num);
> +				cmd->tvc_log_num = log_num;


Hey Dongli, this approach seems ok.

Could you just move this to a function?

