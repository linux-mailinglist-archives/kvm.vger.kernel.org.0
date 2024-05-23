Return-Path: <kvm+bounces-18046-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A11A18CD306
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 15:00:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 58C81283FEB
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 13:00:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0780C14AD35;
	Thu, 23 May 2024 12:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LZ0qciyU";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jxbroV8V"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0721494AC;
	Thu, 23 May 2024 12:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716469196; cv=fail; b=b3h/GrSNEbS7e78oGSqxwCb9MirQGth5WABnQ9DgZBNk4zR8GpEkTdtTFB1+XiZ8RL5fOfGTDBXTLFZkU0qAKdefWT0m6IwCUJPYFz149a7Th2mdVvd+FVG03K2IpS5wdwelegZwsZEgY64fBMEkyNCcdhYedCWVF9g1GaDqkYk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716469196; c=relaxed/simple;
	bh=jLa2sM46cq3RPRY1icBYsFtXgOU5upuPne+yM7NyA1U=;
	h=Message-ID:Date:Cc:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qW1orFNChmDi3SvxIVh69rTS0juyhZwexQRYUpRaNXix8a5zfoId0S5kPEH6yuNavgUN5c7MFQXhJnrO9KGs6PHviWByKabS23f318WqTU66LRza0Vbxr/yzEQqxHBrWCwXdoxCQbkf691QNDtMSnnOMyfpMppaZWK55SfpWisk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=LZ0qciyU; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jxbroV8V; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44N7bMUL022369;
	Thu, 23 May 2024 12:59:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 cc : subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=f46j/v2Lp4WBSwWKSO888qRKj7gLilCfJ/xPpPeB+Nk=;
 b=LZ0qciyU4rgtK2UvkG1HC+3lCunWKspzvwxsV5CmYc37iM/YgcsjcIS6Cz13JZ9qBcNp
 on3K3DUVr2lNssDgJ/6u9FTNcg8ZUXvaCmTKnmkvF1dtseW6F2U+21sFnNxRy9SFcz/Z
 VijJHy+jDBduMXD5T8JKdSYNRem3zxGKgmYgfdvS9LyosAC5r+wg4inALqczZQs8bSz3
 7+10r26FZ7RMcHoH5P6Y7fZn8+NPWf0QPdrm6vhYVfuSXCdfLinF/+WI70Axqh/t97fm
 ABG9AmLJGZdT/xHzLvYClwOCInYhQXm1jHHPe6N4KJ93fy1eIqinqKDS7sT7TKdyQiLj Sw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y6k46a2s3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 May 2024 12:59:33 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44NBAtBu005063;
	Thu, 23 May 2024 12:59:32 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2171.outbound.protection.outlook.com [104.47.58.171])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3y6jsavg7x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 May 2024 12:59:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=idTeHWX55TdCpRxMUZtB+WHzzovg17DgaLmTWrWK0ThlVPpEwOipyKATSsTwEXYzFJXwdUh3LnYXrLLNA6xxW36Q+Dit9mHsqbGo4voSAuFqJ/WB6LDUKewAPYuDP9V12DaKgnYSPGwIu4vmGnSoRsfoPvE4C+iQq5Sys+sgITqxqaycoNjmPrQaX72Y5co0Y198WEPe/pPEWJZQeB2+iORm32uSsljl9Abzi9G0MIB/GR6h9W0ltj36MjAWIdj8eOH1iv4OUCljoGLdkqUic0IUn/Tlx4ddEYzlowQWLjfA/lV1nUW4BItlg88XzyDtKy5k97FuPhzyP0JV1IFYSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f46j/v2Lp4WBSwWKSO888qRKj7gLilCfJ/xPpPeB+Nk=;
 b=ImS56zqWwDmVLIeC/YAuhWep4Nf0b8z+YzzxUjmFBWdBGW+TiArl/cxH5jrc6kk5ApWE8pydZbbdMIwcI3Z19PzrmJrtRTvlbdhFCs8PX5U6+PEAey7AxR4QyHwu50o+fj6elwuajdiaxQQIaHY2UYEvEfW6bpFkgpxla/2yGCfRHv7ujIGqG2cNdrEh/OQKFhBi4aq3fvmBYgOrP86cJ9wOD8Sr8/uuknoCt1OR0h6xXiueD74QLHoB3gkXGV6UzMKE+eZC6nXVYY0Z6nOuoKvYTxU1iMANPWiwxMt4I1htsFzn3f2DMlInsmHqhzvFY84Wnfi2yGAaQRKmdhdmlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f46j/v2Lp4WBSwWKSO888qRKj7gLilCfJ/xPpPeB+Nk=;
 b=jxbroV8VI5k3cWBeqTj37FbWtlKPF1gGSxeVUOCKsJe4Vt6ekcOwBqXNAJTr+UyPj/IpqGVNTx8qUafkuKhal48VB4xrmN/7wiWlsMMD0i+R+SHU1A/ptkOb+rksSPiUbXCFtQb88CUMZyCtUCGh10/TD7we0mZJuWrycYxoTOg=
Received: from SN4PR10MB5622.namprd10.prod.outlook.com (2603:10b6:806:209::18)
 by SJ0PR10MB7691.namprd10.prod.outlook.com (2603:10b6:a03:51a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.36; Thu, 23 May
 2024 12:59:30 +0000
Received: from SN4PR10MB5622.namprd10.prod.outlook.com
 ([fe80::6bce:37ef:d1de:d084]) by SN4PR10MB5622.namprd10.prod.outlook.com
 ([fe80::6bce:37ef:d1de:d084%6]) with mapi id 15.20.7611.016; Thu, 23 May 2024
 12:59:30 +0000
Message-ID: <5f064eb5-cabd-4adc-8c6f-6b2e449e3fe9@oracle.com>
Date: Thu, 23 May 2024 14:59:21 +0200
User-Agent: Mozilla Thunderbird
Cc: alexandre.chartre@oracle.com, linux-kernel@vger.kernel.org,
        daniel.sneddon@linux.intel.com, pawan.kumar.gupta@linux.intel.com,
        tglx@linutronix.de, konrad.wilk@oracle.com, peterz@infradead.org,
        gregkh@linuxfoundation.org, seanjc@google.com,
        dave.hansen@linux.intel.com, nik.borisov@suse.com, kpsingh@kernel.org,
        longman@redhat.com, bp@alien8.de, pbonzini@redhat.com,
        "Kaplan, David" <david.kaplan@amd.com>
Subject: Re: [PATCH] x86/bhi: BHI mitigation can trigger warning in #DB
 handler
Content-Language: en-US
To: Andrew Cooper <andrew.cooper3@citrix.com>, x86@kernel.org,
        kvm@vger.kernel.org
References: <20240523123322.3326690-1-alexandre.chartre@oracle.com>
 <771bbaa3-0fa5-4b0a-a0a2-6516b4f42867@citrix.com>
From: Alexandre Chartre <alexandre.chartre@oracle.com>
Autocrypt: addr=alexandre.chartre@oracle.com; keydata=
 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
 swLliy6PdpST
In-Reply-To: <771bbaa3-0fa5-4b0a-a0a2-6516b4f42867@citrix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO4P265CA0211.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:33a::7) To SJ0PR10MB5630.namprd10.prod.outlook.com
 (2603:10b6:a03:3d2::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN4PR10MB5622:EE_|SJ0PR10MB7691:EE_
X-MS-Office365-Filtering-Correlation-Id: b810e252-146e-4802-047f-08dc7b282e66
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|7416005|1800799015;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?THBoQUZuZ202QUE0Y2RDMEtPUHVELzhzblFPZE00aVk2aDllL3p6cUxLK0Rn?=
 =?utf-8?B?WDFUbld0Z25CRmpzb0h6dTJxSVZqZlF1Q1NxVW1jV1h6eWl4UjFWYkdURTZV?=
 =?utf-8?B?OFEzRnk2VmNSQnRnTVgwY3hvWkFuZXFGSmZTUnRzbnZ4RkJkN2p1TkN3T0RN?=
 =?utf-8?B?ZmN5dHZPMzBKWlJXTTFLQmpXNFlnc2lsNE5jaGF6TkdHYTcvOXp6S3diOEcv?=
 =?utf-8?B?SWpXRC9OWkoyS0FHbDJMNnVuaWdyRTJDMzJneDg4V01MWndNYmFrZWpwWEZ1?=
 =?utf-8?B?S1lJQUVyUTdLRWJWTFBlTlphMzZMRkNlT2lhZUFJU2dRNUxpV0dEOFRqQ0VE?=
 =?utf-8?B?Q1RkQnRDNFhIc2tZaElKTk5xTlQ2WS9YalVuU0x6c0luVWNMMEd6YVkzakVV?=
 =?utf-8?B?cWlQSE9RUGMvLzRNR1hyOVM5ZlBrQVVZNHhhSnF4emRBaFE2cnVVYTM2QnFS?=
 =?utf-8?B?TXNLMW02K3pxTnBQdjQyQzN4d2tpV2RlNU5ldy9yYkpVdWNlQ3pGb0Y1VnRP?=
 =?utf-8?B?d09CSzV4TGVoRExYajFqVEpPejY0YkJ4Uk83a2kvMWFCZ3lwd0crNnBnQmhC?=
 =?utf-8?B?NEliM1dUL3F3NVZBSytCcDFxalFHQ29ZaVBPcEhJTEtGaGFZaThycHh0eWN1?=
 =?utf-8?B?U1VzTmZpYmVPenZ0Um9lVzlIWGl2ZU5QUHNkZ2hUa21qNkU2MGJDTlBJSDhk?=
 =?utf-8?B?ZGR6Tnd6b3BXdElNN1lCZU5mWkloQ3c1WVNBdDYySm1qcmhyek1zcUY1SUZh?=
 =?utf-8?B?d1FBNVZtUVlkQi9MUyt0SGVVZVFPUGRrTTdFRm9SZm1OeVVqM3lKVjE3dXEx?=
 =?utf-8?B?M1J2UGJraXJkdTF5TmJuU0dqQUJDUnpaczF5WFZjNzA4SERLOG1ZMW5BeEMw?=
 =?utf-8?B?d2hwM3cxemN3WmNodDBVOGhoQUtKc2cyVG9rS1FyUGpmcnJ1WjV6bXRBZHhC?=
 =?utf-8?B?cEt4N3JWZVJCcjBndXIyNHJ4eEF5Wnh1TGtKcUszdDNrM29TNWlHREV2QkIx?=
 =?utf-8?B?OWd0clZJMWN2bUZKTWlmYWUxb0pSaU5aZEZrdTltSDBDVHQ0TG5PNk9VdG5q?=
 =?utf-8?B?b25PMFpGT3ZWT0R3Vmt3MVlBQUJRS1p3VnFzN1UrbEZMSjMrSkV2OFQvdDhz?=
 =?utf-8?B?cDlVc1dRREJ6U014WC9Cck5SMUQyVGpTOHBIOHBQRFRIZkdhclc0eGpiME5t?=
 =?utf-8?B?Z0NvRlFYM1RxOW5pYklUQUEwK2FmK1A5Tkx0L2cvbWdHbHZiZ3V0UXRJY3Ju?=
 =?utf-8?B?bS85VjgvbGFFbW8yS3ppK3VHOGdRalVpZ1FhaVFOSEVuOTZLL2QrejFXREFw?=
 =?utf-8?B?eExqS2lkdFl0MmRWc0JDWDVEaTEvdUJaZUtRZlBtRzhMdDg4TnIxM0ppN1Fx?=
 =?utf-8?B?SzlicUhXTjJWKzA0dll4Z1FneGlyQTkydE5CeFpQZXNnU2hmMTRyQUJSNjRK?=
 =?utf-8?B?cmNROE5COU1QSjE3Nkg5L2lpbzlxallaOHAxT0MvSzVneVdFRmJNekc1UW1r?=
 =?utf-8?B?RTVjMytrK3pxMm44c3NOR3lST21XKzQ4Tzc5amFON0NnazFybEk5TWxsMHln?=
 =?utf-8?B?L0w4QWh6bFd1UmQzVURtNmgzSXEwM2ZwRlhHeXZ6YmlBUHNuQ2RkSkxZKzNS?=
 =?utf-8?B?WXVVaThZd1RQUWxURmFscjg5SFQxWWhtbFBCK2N0WS90ajdwaG1EejVIU1FG?=
 =?utf-8?B?d1N1MGYxeDRRejRhSHhnVzdPK2NNVCtGWjdqaU5nclU0WnFvYWk4MHZnPT0=?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR10MB5622.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(7416005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?SkR3Y2dmOXFrazdHbkRBMWNxQ21VVmEyUU5KY0FmQlJreGVQMzBWVVlDZEhU?=
 =?utf-8?B?b0t6YkYvMG1MUXR4aWpMRnFjRy9ISk12UFEvU2JjY2pUbEpLU3lJQzI1QlYz?=
 =?utf-8?B?aW1FZHJDTTRDeHJHQ2hlK1FHeVVJRWJodFdTTUpIcDRpVjVMU1Mrbm1CbFJv?=
 =?utf-8?B?aUtveC80eWVmbVU0Tml0bFpnNTl1cWZOeUhVdVV0R0pjc3pzR05VUHl6SGdE?=
 =?utf-8?B?bzBSREY5TmxaSlpETEZReUtReUo3Y1NMWFpINCtLMXZTQnA2ekhyTFJpSUQ5?=
 =?utf-8?B?UW9UWXJTdW1GVFdxK3RleEJ5NnpxN3hGSGpYN0hpYVFlYWUyZWs5ZDNhU3Nx?=
 =?utf-8?B?bWx5d3M2Q2k1MGh6VWt6TDlQSDk0R2ZnYlBQZUpEOWtSZ1lRMHM2T3ZlaGNF?=
 =?utf-8?B?V1pHWTV5ZFdid0tpRmQ1ZE5aR1NyQ2FtU3lTQ2czaFN5dmFjVXpLTEgrT1Ru?=
 =?utf-8?B?U0k3YmdSK0U2QjVVMkdLeS9OV1NyWmFtdXFyOG5UVTl2OEFJNlZSbDY5UWZm?=
 =?utf-8?B?QjB0S1U1WEV4TXZRcGlGVUowa3ArZHJtaEZ2a0hRK0VsQ21md3ZEczd3Tmc4?=
 =?utf-8?B?eXRnYnVWOEdoUkFUM1hOdktYc0NiekRBYmV3cDBlbS82NUwrcDU1Nm1hVjZ3?=
 =?utf-8?B?cGhQQ1pGZUcyRXpCYk5wVHBhZXd0UkxLWDJ1ZU5kK1pKcHJ0UUdWYmdUSVFQ?=
 =?utf-8?B?cWRYYi84aWNtL3JBdFRHclhpcW81VGtEL05yazNXMVJPTVY1OW12cXF1a3Vt?=
 =?utf-8?B?ZTFieEp3cVJMT3liNWRvN0wxWFo2b3d3QlNVZCtaU0V2bDlWamFUbmtoWnN6?=
 =?utf-8?B?bTloQzVQZmhBVlkrc1hkT1Z3OHVRZjZuWTFaTGtsMVI2bWlFOVJJaTJYdXM2?=
 =?utf-8?B?S2N3K3Z0Z3JBRll1dnRESTU0U2dpTWUvMldIOG1VOWhuQTltZ1E5OFkrdlRq?=
 =?utf-8?B?SDdxa1hzK1BoVE1aSzI2UGZialpyekxRZnpZMUtsV0dPN2F4bzA1NnMwQjQw?=
 =?utf-8?B?ZGN2WXdjMTJudU1qMzJOMk55OXVRQ0ZDV01PNW5zalBlaEZ3K2VhZVJoVURH?=
 =?utf-8?B?YlBjTG9UeXVMMm8yYWljU0FkUjZHR3RUZkc5cjFXNWxUV3RTRjlIdGVEckpF?=
 =?utf-8?B?WVlMUC9QdEJuNmd4R2o1RGgxakg3dUVFb3dNRnVyUmFEUTZUd1BmLy82M1BW?=
 =?utf-8?B?T0o5Vlh2UGFBUXY3OHM4OGk0NUo4dzZLUCtWTFRuT2ZxK09SWWh0MnRWNkxF?=
 =?utf-8?B?dHV0M2R5cXdBN2Z5RWtlcWFyZEpORUo3UHo2WnBnNzM0SlZGbDczY0hlUzNC?=
 =?utf-8?B?amZyQ0VkM2tnV0JwbkVsckh4NFVMZ3NEQ2hnaEVwZDEzQ1B0eFY1MXJ0S1Vr?=
 =?utf-8?B?SzlhamliZ0EweWxtSnAwSTdmYmVjQ1dsQnU4d3R2UzljRWh4WkFWeUZ6aXpV?=
 =?utf-8?B?aG4rTzJGRWIwYnI5dDRRaFlMbXR0aGtlUFRqeHFqaU1iWVFoamJzYVBKVUdl?=
 =?utf-8?B?VGNmS3RxUmd1TWc2RUtkWUpqdUhLTTBySkVtS2tRTURlLzFBNFl1dkU4akZt?=
 =?utf-8?B?ak80d2wxTEdadE9oVVZIN0ZEVk84SzhDbDY4dDQyVjhyczV0MVJlOW05YnE2?=
 =?utf-8?B?aDRVejVIZGNxSXgwY2N5MU9uTmp2elJhNGsxRFJ6dlpxK2MwdXkreU5mZGts?=
 =?utf-8?B?R1JEWWZSdnJ1TnUydzJoQXJNVGtrWHBzNkh5TXhoZU1XK050L3NsZGg2VWZp?=
 =?utf-8?B?dWNnd05HazJMalFTeFJmeEwxY05ZcjRSNzUrc3VNMnFNVnRpTEp4K0N2dTds?=
 =?utf-8?B?cnNvdHc1Tlp3L2tyYWwyQ1pBeUUyRnJvMFRzd0NrWDRyaFVrNDdkdGxmVkVm?=
 =?utf-8?B?SDdiSWNzWkxYN2FSYi8xQmpWTnF5Tk5TVVllUE80R202cVF0ZWlYQUMzOXp3?=
 =?utf-8?B?cnFYazBTVzk1VDJqVE5PQ1p5NTNXN2ZvaDRyKzEvbk9DZUlrV1ljTE5Qbm41?=
 =?utf-8?B?ajNxaDNia01IZzk3S1NCSlFrNVV2SklHbE92UlpkU3RzRUwxa2hQVGEwOTly?=
 =?utf-8?B?eWVqYW1oNUNlbU0wQlJ2WHZ0ZUJoY2dBNUxEdCsrcWJlVDdKOVFlUDVNcU9q?=
 =?utf-8?B?NTNMZlZOZlgxbUFTQXhDUjZIaFRtNW1mWnVZZjdUVUM1dUFFaFYrN1hSVmxy?=
 =?utf-8?B?ckE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	eoG83IK3AgJ5dtQ+iOrOM0rwP952k+Kaibro4He9hEjHd496Mk2tYQYLjVkINoakOPPRiCrZncb3x4Vz3zk+HN/v3p2e6kR9jkVj81YXFOw/Xu5JSCCvCZLOX8tU6t7jhj7D+aHskFoaSj72/0SCOmw3xdyuoFRmkWe0JVbQWdkcfBWx74Uy6adTUXvyp6UXhtyZTeY29F6qxPMeORb5S0gxYnwfpYIscPi6ifPop9iNmc+Yq1Xowp/p2ZhezqVyb6B6nPviaWchJNGFAhoTmXcRbfhDXV46EPKNth6iWUYTIDA7FiXrLp6XGfYj4T5N2/sByti0GCDFR7HuLGjt9u6HEkWsh1Ecx5mrrcCi4usA6KkIExth36Do1Uj1ix2AU5D/g+9J54T9qyNYLzy9hhE4N3Yx+gDW4CCApZ3d8qJU/TqinZST/qD0hB213JGehHYE3mOicYPTe21V2FtiDo2arFtINYNyeS2ijnd4hNbr0GCslpmMnn67ZrJw/GjtcqrPoD0+S0SnLxc9E4Erp+HTLM2KAaQ33V5/Dz3gbFvWjZV7DX9h1Rmwf5WSW45/ntLIURpty6jpir7w+FeaIplTtVtOm3E71W3R3QvZ71g=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b810e252-146e-4802-047f-08dc7b282e66
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5630.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2024 12:59:29.9702
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0Se2029yL+N+t9rJitAk77k9pnW7y2GCBOh13gF8s+HpvoBUS9NNEHH4eDR9QPHw35aIMRZSxBYKt3FXm4HIVdm3iz+SJVC8ICR3cgELvRA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB7691
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-23_07,2024-05-23_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxscore=0 adultscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405230089
X-Proofpoint-ORIG-GUID: WRXZStD4crFLkvNurE8AYj2QgoaQqzt2
X-Proofpoint-GUID: WRXZStD4crFLkvNurE8AYj2QgoaQqzt2



On 5/23/24 14:42, Andrew Cooper wrote:
> On 23/05/2024 1:33 pm, Alexandre Chartre wrote:
>> diff --git a/arch/x86/entry/entry_64_compat.S b/arch/x86/entry/entry_64_compat.S
>> index 11c9b8efdc4c..7fa04edc87e9 100644
>> --- a/arch/x86/entry/entry_64_compat.S
>> +++ b/arch/x86/entry/entry_64_compat.S
>> @@ -91,7 +91,6 @@ SYM_INNER_LABEL(entry_SYSENTER_compat_after_hwframe, SYM_L_GLOBAL)
>>   
>>   	IBRS_ENTER
>>   	UNTRAIN_RET
>> -	CLEAR_BRANCH_HISTORY
>>   
>>   	/*
>>   	 * SYSENTER doesn't filter flags, so we need to clear NT and AC
>> @@ -116,6 +115,12 @@ SYM_INNER_LABEL(entry_SYSENTER_compat_after_hwframe, SYM_L_GLOBAL)
>>   	jnz	.Lsysenter_fix_flags
>>   .Lsysenter_flags_fixed:
>>   
>> +	/*
>> +	 * CLEAR_BRANCH_HISTORY can call other functions. It should be invoked
>> +	 * after making sure TF is cleared because single-step is ignored only
>> +	 * for instructions inside the entry_SYSENTER_compat function.
>> +	 */
>> +	CLEAR_BRANCH_HISTORY
> 
> Exactly the same is true of UNTRAIN_RET, although it will only manifest
> in i386 builds running on AMD hardware (SYSENTER is #UD on AMD hardware
> in Long mode.)
> 
> #DB is IST so does handle it's own speculation safety.  It should be
> safe to move all the speculation safety logic in the sysenter handler to
> after .Lsysenter_flags_fixed:, I think?
> 

Right, so something like this:

--- a/arch/x86/entry/entry_64_compat.S
+++ b/arch/x86/entry/entry_64_compat.S
@@ -89,10 +89,6 @@ SYM_INNER_LABEL(entry_SYSENTER_compat_after_hwframe, SYM_L_GLOBAL)
  
         cld
  
-       IBRS_ENTER
-       UNTRAIN_RET
-       CLEAR_BRANCH_HISTORY
-
         /*
          * SYSENTER doesn't filter flags, so we need to clear NT and AC
          * ourselves.  To save a few cycles, we can check whether
@@ -116,6 +112,15 @@ SYM_INNER_LABEL(entry_SYSENTER_compat_after_hwframe, SYM_L_GLOBAL)
         jnz     .Lsysenter_fix_flags
  .Lsysenter_flags_fixed:
  
+       /*
+        * CPU bugs mitigations mechanisms can call other functions. They
+        * should be invoked after making sure TF is cleared because
+        * single-step is ignored only for instructions inside the
+        * entry_SYSENTER_compat function.
+        */
+       IBRS_ENTER
+       UNTRAIN_RET
+       CLEAR_BRANCH_HISTORY
         movq    %rsp, %rdi
         call    do_SYSENTER_32
         jmp     sysret32_from_system_call


alex.

