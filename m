Return-Path: <kvm+bounces-42162-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A5332A73F4E
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 21:28:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 025F117358F
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 20:28:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BED21D5ADA;
	Thu, 27 Mar 2025 20:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XxjYHzgS";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="X5Kl9IuW"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFD031C84B7;
	Thu, 27 Mar 2025 20:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743107267; cv=fail; b=N7bKrv5f4QUDlYUAWLRRT1HV6c90v0g2DM8JgvW9L6UaEvVMmHq1fp9eRbW0HindO9fldHzfaHzpudEIGqtPDiv3VLKZoZgfyv0AI3wHDbTZkmIbNGQC1VqbaLlpP4OXSUoKMCzjyq31VdxzRaKYvT4/DbCNVzyGMeiTXGYaxOA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743107267; c=relaxed/simple;
	bh=+1R4Oq9HD/dH15eJke79DdqOJaQL8bnNEIemqchhcUc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fiRREZNK8K5KTm6Qj9WUyxyhDhyqUXtOKeM5592YkpBe+0vDQffXKu3VKOzD91KL3xWKyi/edQLZQXjifMS3gu8XRTs4I9n8BPhW4/9MbtlcaRFBmb9wMNVGaiyoq//PjWItxKXFLTUxeonGPHAhBMhZs/70hY4QwHawZ2LKvtc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=XxjYHzgS; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=X5Kl9IuW; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52RJuBXf028963;
	Thu, 27 Mar 2025 20:27:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=nj01qvc+60d0VExU7oiPtCxC2mvtbDlEL4v3mWA4Vts=; b=
	XxjYHzgSCxfc7WuWBJgPrqoYCJGwMWbx9ZWTOXTOR0LEQykvYZZMWqVkK/XB/YVc
	cVGX8pSoIQiG/yddRMejWMZj+0IFdSF8harIjZAeurXyrIQHsflrN4R+HNXPyLgu
	nuJ4TXzLHPidGhrIDq3qQNOONmBazRrPmyHtl/Lglt+tIwTrPoJBoHSSjRvgncrl
	2OM/l0SLLBjkJO1ApXJ9tTm3glB2BAjc/i9l+DW+i7rObyQrGxrp4Lyg7CWCPenn
	GQSk9nuWwIjilPC77fHPTSCBCI08n6+oXjHPu8WVgVx9IS5UbRMfBgSDdfXsZAOD
	sOqUbUJxpqhHoK3KD3QcnA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45hncrwkr9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Mar 2025 20:27:40 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52RKCT8Z008360;
	Thu, 27 Mar 2025 20:27:40 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45jj6xjb5p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Mar 2025 20:27:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iDidgyve6L9w1FWyV15ywKhBqBU0CmzD1ch2dcdwabn9bkLwjM3vzu3ctNceTAcjRjxoM6ZGbF5m/wspJ4BIgdDaYq9BpApUs6jrLdXl9Ukow+VOX211jV8pPSiSrMRdOMq/2Eu5nc7Wc9cjyoPI8rtHX21fgao0eZgLWMNC0+CvQ/io+RtwMkML0o6youJYF/r2jJWB1rJV1AIIaXuyJdsZKuOgx+QAHdjysM8om7LTcK28MDJFAl1v+HB13+QF79BWYXkz+vHMqnYXqRnj41OAgtt7wausY7A1QslMKOir9VptLSfF6wiFpHz963J2YZ6XYef34cQ8b9JYfTWAjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nj01qvc+60d0VExU7oiPtCxC2mvtbDlEL4v3mWA4Vts=;
 b=TOBt2LoVhsxOXv0UItihX4QcoRIhPi3DznnWYYU4bBOM1A4T6qqz4dh6oQ3z8MYYaJM/7PTTIaFlDJL6OpKZK/gQWcGod5ilJoUPgwmzK4iQTO84yE2DXE/0vb8r/RogKvbbjCUeOjCr9KC3OFdm6aEYpV3NSuKQ5EO/HOslWkwPFKKCLR/luVWU31Tsp0F6GmKm2/RotBSw8A5FLAscSqJkTL3tEPPrD9kDhXpsFmiCGxkiPVNQKrq9w6l+hnQzPVfNUo29zkgX+B/UfQSa5cw8zypXQwoVcXgPULf2fn8TCV6hJfr8kFxicgstfvT9lUXh0+RsEd22vMavc5A9Kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nj01qvc+60d0VExU7oiPtCxC2mvtbDlEL4v3mWA4Vts=;
 b=X5Kl9IuW/zhmAqNWi9I5NaW4rlfud+f0hCVXpAsfKOHorhyjIHLu4gSQ1mNeQGoqnkg/UbhXSX74vVU5B6kw2s3SvooObPV96LR6hNyrbr8a5uqyUFUWd85t4VIj97kywbSwr7wPT+z8R2peakzwvkA/oGf0tOP/AyXBOwAJsCY=
Received: from DS7PR10MB7129.namprd10.prod.outlook.com (2603:10b6:8:e6::5) by
 DS4PPF9F760C0CB.namprd10.prod.outlook.com (2603:10b6:f:fc00::d37) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Thu, 27 Mar
 2025 20:27:38 +0000
Received: from DS7PR10MB7129.namprd10.prod.outlook.com
 ([fe80::721c:7e49:d8c5:799c]) by DS7PR10MB7129.namprd10.prod.outlook.com
 ([fe80::721c:7e49:d8c5:799c%5]) with mapi id 15.20.8534.040; Thu, 27 Mar 2025
 20:27:38 +0000
Message-ID: <b7fb2187-1475-4e39-927e-8b8990d4fbdd@oracle.com>
Date: Thu, 27 Mar 2025 13:27:36 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/10] vhost-scsi: cache log buffer in I/O queue
 vhost_scsi_cmd
To: Mike Christie <michael.christie@oracle.com>,
        virtualization@lists.linux.dev, kvm@vger.kernel.org,
        netdev@vger.kernel.org
Cc: mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com,
        stefanha@redhat.com, eperezma@redhat.com, joao.m.martins@oracle.com,
        joe.jin@oracle.com, si-wei.liu@oracle.com,
        linux-kernel@vger.kernel.org
References: <20250317235546.4546-1-dongli.zhang@oracle.com>
 <20250317235546.4546-7-dongli.zhang@oracle.com>
 <80a47281-d995-4499-a4c8-f251ca309450@oracle.com>
 <38b02ca5-59dd-4193-bea7-e15e4f5f426e@oracle.com>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <38b02ca5-59dd-4193-bea7-e15e4f5f426e@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR05CA0001.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::14) To DS7PR10MB7129.namprd10.prod.outlook.com
 (2603:10b6:8:e6::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB7129:EE_|DS4PPF9F760C0CB:EE_
X-MS-Office365-Filtering-Correlation-Id: dd5feaf0-624b-4513-af1a-08dd6d6dd0b1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cm82L0VRYWc3WkxNcEN3WjMzejFwazhmVG9jME81TWJZdHJyVkRTalRYSitH?=
 =?utf-8?B?d2M1dkdNelVBL0tXZFdjcTRCbnFZUG1wRUlFY3gwNWw1YUx6Yk5iVHIzV2xD?=
 =?utf-8?B?VEpZVXZuNEdHZ0szT1JoSVNMb3g0RG1qN0h6NzVhTmkvOEZNeGtnZmlhbGNp?=
 =?utf-8?B?Vm0zT0hTSFFXZnVCODE2c0VkTjV3V2cxSkZ3RkNxbXgwNzl0Slh6SFl2b3Nl?=
 =?utf-8?B?aVVJNWt2Ym93cldXak9TUlU2WDhTbUNIczVFR2ZQZFpSMEVJL2pWamVGdU5F?=
 =?utf-8?B?ZWZHOWtHZzNzY0ZVdklpcVpwOWRHR3gzbFpOZWR0dkhlMVc2QzM3WE9rQjQ4?=
 =?utf-8?B?L0FUbW9oUG1VZ3A2enVjcHdiR1JTdFlzdHRPN0Y3eHdlcDNCSHdnRWlSMnRm?=
 =?utf-8?B?NHBmUzZNbGk4RHBQa2tnWXYrVjhZNUg3VWtHdDk3a0M5bjRhbElMcVdsN3ZL?=
 =?utf-8?B?bG1qdDU3MG9wQjlKY2hBWFU4WUROOFpJelRZZ0FtU1hSL252Z2UxTjhQN29D?=
 =?utf-8?B?MHlLU2lrQXI4KzNZVDByMCsvZkJhcUlVWjJVcXRqQU5oRlFqdjV6QzJkeHVi?=
 =?utf-8?B?ZmMxclhVa2Mzc0hwVlR4Ull1M2hPZmlVaDJFOVZTT04yNUMxSS9yL2dQc2Iw?=
 =?utf-8?B?SnlTQllCTTVYeFh5RTY5ZjhFYklQaWRRTndyS3VSZE00NndZTzg3QXN1MDZV?=
 =?utf-8?B?eWpuWVVLakp5NTVRdkkzbC96UzZ3azRBQWQ1Yy9aK0hlYUZGbDQ2UExJVXpN?=
 =?utf-8?B?enB2WkNZS0NwVEUyVko0MEptd0tGWThrem5Gem1yYVZYUnVBWFpQNThzVGZC?=
 =?utf-8?B?czJiN0hJQm1ab3BadUJhNDVuRUhtQmViLzg3YW5DRzgvS2RZT3BraEFmNkdj?=
 =?utf-8?B?am1HMmJDT0FnN0J3eHh5QndFZXF6ZjZ6dlJUTE5ud3dRaFordnpEZUtNUEE2?=
 =?utf-8?B?V3pzM3RrZGdlRlJDajduL001eEtJUjU4eTNLOUVqUDI0dmc1bjZURXZZbkt4?=
 =?utf-8?B?enkxVER0Y0lsamVWN1kveEIyVlA5b285UlRwWXVrYnJLRG00RmhDbCtnam5z?=
 =?utf-8?B?cjJvZjFlYmFSQzlrZ21reHlSNy92RFVEaGNkOWdQd1BqRnF4WlBvWlhrenp6?=
 =?utf-8?B?M0ZPR3V2WElFMHhyb1c4T25kVklhYUg2SmwwSVpHZ1FLV2tTL0ZaOWpUZDBq?=
 =?utf-8?B?aE9xbDQ5NXZTMWplMWk2NXorcXM5OWgzc2ZtU0p5cStiY09uMzJiNGVNZ21L?=
 =?utf-8?B?UWJPSndIdTdsZkgrdWppMkxWK05WSXZMWk9IcXIremh6YTFnSmYzRkxESUtK?=
 =?utf-8?B?Q3AwZ0ptNS93cko0Qlo1TGc2NDdOSTFHR0Fpb1FRMHNJLzZOc3RTNnRCMVEy?=
 =?utf-8?B?OHFQRnN1aXR4RjZ0dUZkamptcjRXb0ZhWTRhQ0d6MmtKZ2Z5czlsMTZHc25v?=
 =?utf-8?B?U3FwbUpVOHJwN2FLUzdoemFRN3FxTWFTWDlDZUoyZmZ3R1dIa1AwSk1FU1h4?=
 =?utf-8?B?bmxpcDRJNVpIZGxNSitONDZuVTEwc21OeFpTVUhFR29LeWhpd3BxVUdSR3R0?=
 =?utf-8?B?Q1NVamVRTXhlVEMrV2grc2hESGhsamtZenJ1Q05XVDdIN2Nmd2N4eHdHR1RJ?=
 =?utf-8?B?bGhHWFVYOUpmUWppODNISnkvc21Vb0NlOEtaT0FPVG12dXB1WHlNZlFqdk1N?=
 =?utf-8?B?cW5BcktHRk80Rm9rQlNiVktyNE5jVnNLdklJaHZpVWNoSGxpQjArdjZSZkxs?=
 =?utf-8?B?Sk5nSWlVcWtBd0tJaktFSjd5WlhMY2FJM0gwMXVXdmtMbmxnbkJtMCtiZDhj?=
 =?utf-8?B?NzJnN0FjZzRsRWdsM0xSVnhxMjRSYlZ1dkt0SCt2TlhXU0pSbWZzNWwrK0hp?=
 =?utf-8?B?aVRhQVZDTXFYMlltOVZRTnBSWkNhNzVXakdJckVPWERldUE9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB7129.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eEUxVFV2bTJsYThNTmRKemRqRkJEa1pCMG53S0xLRTNHcUtYNkxvZFZMd0g3?=
 =?utf-8?B?a3hRVHd5dHNsTnB1OFFnUDdKVWxIajdhQlMzeVEyT3FwUVRsUGk3Y2d6TzE2?=
 =?utf-8?B?SzNHTHVBdmpUOU1xclVENU4vbU1Lb3hXZDJ5SThZa1A0cVdsWmJFMzZMNUJa?=
 =?utf-8?B?R1N0bTJkalVpaWNUbS8zQ05CbGx5VWFZM2lrS3hVeU50UzJiQndzbjFSbXNF?=
 =?utf-8?B?UFk1SjNSbG5yN3hybVhPL0tTYW4xN2VWcURDQUdtWkZLYjFDZHVxeTBjRElN?=
 =?utf-8?B?bmloVWxSMEQ2ZFdHM01tMTNPd0crazdZeVo1LzVXL2ZkdHk4RTIyMlViMk52?=
 =?utf-8?B?bVFOMGpJYlNMVUJ6d1BIVHNFN1VpVllURzdIZkc2OTBwVVhpRE4yc295Q1Rj?=
 =?utf-8?B?RzNVTWl3MXE5cHB2UGlOUk5qWmpGK0JqY3BXdGxOVURGemlDaUxPdlRNUVd4?=
 =?utf-8?B?eWNxNyt2SWllNHF6Z2RSTWFsdGZrWjA1TFVZZGdrM2pZS3dYb01LSnEyS2tW?=
 =?utf-8?B?SE9JV3R1a3A0cVlrTGUwaVhjeklScVBhNHBBenpwYXgzOEZEVkRvUVV0M3h6?=
 =?utf-8?B?dkM5VWZhRjlyenFRRVA5ZG1pS210WVVKVElEeWhscEJVSE83QVBNR2xoeWly?=
 =?utf-8?B?b3NoUGswOEhJVzdlVzRvcDFEQUsxcnpSck5vTjNpeUtYK2pFb1czTjhvQlg1?=
 =?utf-8?B?cFFKZk9OY0tpMGZ3QTVZTDhJVytxeC9lM0ZyUVlmNDEwNUNOM0hhMkJ3QU9r?=
 =?utf-8?B?aFVLdmNpSGNlVFpiTzRISTRRMGZwRkFCSS94YnNxQXdFSTRDbjg1YU5mWTBi?=
 =?utf-8?B?RDltandQMmcwazEvTmJWQlE3ZDVWbVNMUjRiNktKNm04UzMrT21EdUpXUmpH?=
 =?utf-8?B?L1RmeDV2Z1paY1VSV0xobGZwc1FWLy9DU0IrUUhkN3VMK0RXc0ZkOXk4MVVQ?=
 =?utf-8?B?YUtacnhScVc3bWhRVi8vWWduajZ6ZGVucng2aHl1blM4WG42UzNlYWF5cFVk?=
 =?utf-8?B?blRzQVJoSUhaYitCaFBsRVFONXNTS29yZ21ZWDVVOHNNWlVrYURCVUp2d2NH?=
 =?utf-8?B?M0t4ZTllckY2bFRwb01aRTY1eU5UTSt0RGM5MHBxeEhiZmZ5eldLdFR0R09z?=
 =?utf-8?B?WFR2ZEtKN1hwbWsyMUU2bnZ2YVpHb08yaytrWDdxNWdwcVBlR2ZyV3J5T3Jk?=
 =?utf-8?B?c3NMMmlZaFBGVmNiZGpTdTFUZU8vREd2WVpxVFlnVmtJMW15ZUdvdEpHUUhU?=
 =?utf-8?B?MGFHckZ5eCtNKzRBVnZkbG9WczN6VWdaOXB3RUsvZ0dwLzloQ0FQWVFPMWlX?=
 =?utf-8?B?a3VtYlpJaXVuSDNRYzF6aldpbGRmS3BidUp1R1JoYk9jREVFdkFJbmFDeE1s?=
 =?utf-8?B?L3NaOWNNK2ozbUtKcjZ3YWQreS91ZnNKZzhHakJyUzlSUjdkQTJLZG9sam5C?=
 =?utf-8?B?UW9BWFJvWldpK01ERVQzTUFTbFBKU0FKcWFNdG5GUWxubi9MTXpXbDFLTkdN?=
 =?utf-8?B?T3V5N1hVYTRRdWYvYzdYcGFUWVpzME9TZVdJRmdySEdNdXlvbFk1Wlg1UHoy?=
 =?utf-8?B?aUFidzJ2Nmd0elRMei9OV1lRRDNNc2tZK0FpNTRIWXZ3czNMWEhCY29qZEYy?=
 =?utf-8?B?ekEzYjVTNDh3SVZXWndnNE9RRGFLT1dGN045ckdpNzQvMnR1YUsvcWtpWG55?=
 =?utf-8?B?SEZ2ZkFlY2FBLzAxeHU5Q003VHRLd2VmRG9UQ2tpRitXUzVqUnZqczVZbmRL?=
 =?utf-8?B?ZUFZYkJyUjV3dkk2WU01ZlNXZ3gwRkZPd0Z4YTlwNldtSXI4cC9oaWN2dUR6?=
 =?utf-8?B?SHROT0pCWTJ3NTMyem5tbWdpdlplZzRIalVEUllDNWRZaURJTW1IWENxZ1pv?=
 =?utf-8?B?bUVoMHJRSGlDeGxJcnlMN2svbjlOTEduNzExa2xYTHhKa2ZBT3FwN0ZlL3Vm?=
 =?utf-8?B?T2lta3Zsa0E0a2lHWlhLcFZBRHJLSWs2NTVvRUVmelFYSTRObzdLL2t5VGZq?=
 =?utf-8?B?UGZNNTJDb3NZWG5LVW9vTmgwZWFJMWZUUjl1R1padE1mQlJJUldQazA4Rmxh?=
 =?utf-8?B?TWRMRWdNb01wMHdYUFdReHp1QjVNcks2NE1IcTZxaUxYL3ZaUkVRRWxCcVNk?=
 =?utf-8?B?V2tkOStWSWE1STIwWWFWTzl0SS94RWZNZEJETVBscU1aTHlxRlc0cEwveDZB?=
 =?utf-8?B?b1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	EacYf33nivcc0qApvnZ6D2NAKwbH3Zs1b9VXN8rWOqiNJZlv06lW6uRjHRzMQuPWG9wpnLONK+oqL2ZV27J28CHQJhDmUABclcvjqHYUd7cx/zaVqaNbPsC8FWEaiSpf30zwqclxlFISWx3mRvlBx3/95m4Z73xh8g8N9c+/F92k6jiUMJXgK4aiaKqB09Mu9ghhLUT+Gm8/v555JJOjw/PGWHhJAP1HGGFc+IBnsNh93o3wwDvdEUivYV/3f7RyXcrRcxIFY8T0WtiqJC2LpvEScFoM6l6cw19OI0HmrdQtV1LavVjVYLq8jwofPa5W8AbnTRf4DaTXxe7tzG3SF7NFsi1XLwPJ7K/gJWKJTiiLlloE51fDjPMxMKE1//n+lQ03eK4sLCvEJpIh7IUl6R8GQJ4eLasHSgxhqHwcCZZCcFdl9cJXVqv2oRkcVFVDgbXumskNsGHPoTLe6P7dJeC1PYIHiiVLbAKYjahzddIaQJVXiYNaYFkf0N9WezhMoGQEfCFpEyHw+Bd3vk5AQDP5no5/7GdICpoR0Sutnhd74Kn42CaBRN7h1fGp585C3CRrKei6VtOYNZGGJy0RVQ7v2erlFKoMBPK5zedvI3Q=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd5feaf0-624b-4513-af1a-08dd6d6dd0b1
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB7129.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2025 20:27:37.9562
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pSPBFfiXRB5eoBgURCVjVI7iFWt2TG9//gMAyQ0sf4VX9FBMW/WW7dngcAfS1d79HeYVGH5XFhg/+dmcp8+qWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF9F760C0CB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-27_04,2025-03-27_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 adultscore=0
 phishscore=0 suspectscore=0 malwarescore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2503270137
X-Proofpoint-GUID: xp8S3CHPNxjXtMzstAjeoB3fJhOiQhK4
X-Proofpoint-ORIG-GUID: xp8S3CHPNxjXtMzstAjeoB3fJhOiQhK4

Hi Mike,

On 3/26/25 4:37 PM, Mike Christie wrote:
> On 3/17/25 7:04 PM, Dongli Zhang wrote:
>> @@ -1390,6 +1424,24 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
>>  			goto err;
>>  		}
>>
>> +		if (unlikely(vq_log && log_num)) {
>> +			if (!cmd->tvc_log)
>> +				cmd->tvc_log = kmalloc_array(vq->dev->iov_limit,
>> +							     sizeof(*cmd->tvc_log),
>> +							     GFP_KERNEL);
>> +
>> +			if (likely(cmd->tvc_log)) {
>> +				memcpy(cmd->tvc_log, vq->log,> +				       sizeof(*cmd->tvc_log) * log_num);
>> +				cmd->tvc_log_num = log_num;
> 
> 
> Hey Dongli, this approach seems ok.
> 
> Could you just move this to a function?

Sure. I may re-send v3 following this approach (allocate on-demand in runtime),
and encapsulate above code into a function.

Thank you very much!

Dongli Zhang


