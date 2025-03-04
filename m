Return-Path: <kvm+bounces-40091-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 32239A4F0CF
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 23:56:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C152C7AA64E
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 22:55:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2658927C869;
	Tue,  4 Mar 2025 22:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aZoG2YGC";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="kYqbYxlm"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FCCD251791
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 22:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741128890; cv=fail; b=DRqTFXCYQyLLvP1oqUEXbRcII+H+sMR75PijBIeo1ivrt/1wtowEEip5rKSQqvuMqRWJPoNIR8CN2V6uZOBI3hYuoF7/6Z1hLx3xeO6id6EbdUTgznuoRErEJDFApSWu45oPXGvLNE/gcoyKoodTPEoe4FP2Kuy4x7nTxLuDiE8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741128890; c=relaxed/simple;
	bh=kH7YGgNXLopgSeyn2jtFf/xjQ86K03TGL6Wv/V395yY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=c1Tm8UMKgj++QkcA9/SPgX5VKR44UwLlLWJMyzSFGGUBKk+ijxrdfTXIYRDDJyqHHFBnj0Ic+8TbZSaloaCwispe5OiITanQGTCaH7Po34Led6kUoebG7byCcvMXmPxLgyQOQM3vyjddvnrOf05/REPWoFhQhnVbNR4jKm2dhdQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=aZoG2YGC; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=kYqbYxlm; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 524KfeQ2008742;
	Tue, 4 Mar 2025 22:54:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=hRy8a0vwWGTthTpI/GLFjLX4b23gY8GHFyotBKjyVo0=; b=
	aZoG2YGCm+KqsX47+u9f64VfO6eE8zCrVjO85QOTD+iyivsO48OmA3RFozjJKUU8
	zgCuNeQ0HKzXlExXY4mOlb+GyFWHrx7xCEEtEmjH862/HLcuKeme/h2XbwzQpRUf
	1in9PkHPjIGpzONEXAmkwbFu8/VSkYfmo1drx+eX1cmVsN2NWriv7lb68wxPTFKT
	tSuV7++s4h8bO60hxIxxyPiHUySOYTlztUkRbxsOslrB1cA8vJNrI9BpsuBBpU0m
	d9mTEbyVQX9pxFmqEWPpt5jbdCA00fbqDIXA4bdnkiXFLtoepKX0MZHCd6eG/L6a
	Yd6DaNKbbLZhdwKHekXhKw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 453u8wp8qp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Mar 2025 22:54:00 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 524L07pg010933;
	Tue, 4 Mar 2025 22:53:59 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2045.outbound.protection.outlook.com [104.47.55.45])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 453rpb5gqd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Mar 2025 22:53:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Eue3bhIjcb8MaW4T3sPeJZMS3lr//QFGd7WKRNRjDVgaolVSexmdTENQ0O0Jg/dVVmBFyzbxIfzGLI0D0ldgln2HbRAb3iwbJhcy/N7EIOjFv0orjc6hManShE10epq3pDJe64u4HLhGMMixNcLUDSh6gqZpnYYHwR4VD/uCFZ3S/bZAyvwaEQahezFHyIxOHZQ9sMQPLHYfOkEYiejwMUV25IG6cTPMQGxaZWS+ky/Ji2JqIx6MuafDu/0mHaBRok6rX9max6Z+lkAba+YrLeJckawoPQDfYyOBxi4s6ChspMWFJgFYv61C/3rXPtmNqDaB1WdBkxlEanspvPXnIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hRy8a0vwWGTthTpI/GLFjLX4b23gY8GHFyotBKjyVo0=;
 b=bjkGaWKS0wRwrBLPaTvvPJo7beN4WS8G4Y7fH0NfCqC4sbivJVCj0CV5/axw2z8OLSyBkbePfCqsmLhg85EtwfHtkGxKZjEH3mgFJb4gG4cX3kF284dw8LN2RJlIe88D5yVz3fAL5zqOcY8LLbuDdc45v7XI/bhPsOWZ1xQpgLBS+koh4FWnc4d4KNWyugkDVvWRx9Byfoi+wDGsmeppTyK74KtgI1sK208/0qXSG7DtAF8kDK2Th9mkk8efEdbBdeFcUKQ2PhFo5ixaR/NkmwD3dVIlPKLjhLr39KWLNx0O+pHI46k411P+1v2M4ccOKAjUbO9EfkVOC6CPSSqeFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hRy8a0vwWGTthTpI/GLFjLX4b23gY8GHFyotBKjyVo0=;
 b=kYqbYxlmJUxQoElxG8BSxh4zCMlX1z+HRKh7+sGBMiB3ZfPLnW5FDU1mIVVT1t/XdLLtfCUKcZB63jwP80RELhYLrSpx/+eJLRiXXUnk/sm8cjouQB59MhxDv5QiQ/uPExgzkNwvd68uS8QKIAMBLyMxy9hOnjpWmI+yzrW3DEk=
Received: from BN6PR1001MB2068.namprd10.prod.outlook.com
 (2603:10b6:405:2b::35) by CH4PR10MB8074.namprd10.prod.outlook.com
 (2603:10b6:610:23d::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.17; Tue, 4 Mar
 2025 22:53:57 +0000
Received: from BN6PR1001MB2068.namprd10.prod.outlook.com
 ([fe80::c9b4:7351:3a7d:942f]) by BN6PR1001MB2068.namprd10.prod.outlook.com
 ([fe80::c9b4:7351:3a7d:942f%4]) with mapi id 15.20.8511.017; Tue, 4 Mar 2025
 22:53:57 +0000
Message-ID: <d6644767-3ed9-41be-847f-950d3666e0c6@oracle.com>
Date: Tue, 4 Mar 2025 14:53:54 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/10] target/i386: disable PerfMonV2 when PERFCORE
 unavailable
To: Xiaoyao Li <xiaoyao.li@intel.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Cc: pbonzini@redhat.com, zhao1.liu@intel.com, mtosatti@redhat.com,
        sandipan.das@amd.com, babu.moger@amd.com, likexu@tencent.com,
        like.xu.linux@gmail.com, zhenyuw@linux.intel.com, groug@kaod.org,
        khorenko@virtuozzo.com, alexander.ivanov@virtuozzo.com,
        den@virtuozzo.com, davydov-max@yandex-team.ru,
        dapeng1.mi@linux.intel.com, joe.jin@oracle.com
References: <20250302220112.17653-1-dongli.zhang@oracle.com>
 <20250302220112.17653-2-dongli.zhang@oracle.com>
 <46cd2769-aad6-4b99-aea9-426968a9d7cb@intel.com>
Content-Language: en-US
From: dongli.zhang@oracle.com
In-Reply-To: <46cd2769-aad6-4b99-aea9-426968a9d7cb@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BLAPR03CA0065.namprd03.prod.outlook.com
 (2603:10b6:208:329::10) To BN6PR1001MB2068.namprd10.prod.outlook.com
 (2603:10b6:405:2b::35)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN6PR1001MB2068:EE_|CH4PR10MB8074:EE_
X-MS-Office365-Filtering-Correlation-Id: 4742b536-1191-4d5f-f58e-08dd5b6f722b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QURTY09EQjNWT05IK1BqUDB0NFp5N3U0dmRwb2hPanRFVXJmN0szaFRIQytm?=
 =?utf-8?B?T3R4ZmVTQVZKODRPUDhjUFluL29najFnanlVUWRqbjN4Mjg2NmhrWkFzRDZG?=
 =?utf-8?B?OHhPZzlRRE9USDc5Q2NNR3plZVdEYit1K1lMUzlpV0RzTGtpdG1paWZtTVZm?=
 =?utf-8?B?RkovVk1MYS8yNUxyckxST25Xa0RWaklmVXR3L0JHNU45cnFPbWtNZ1VMZml6?=
 =?utf-8?B?aWYvZ05lUngwVkowMXg2TnJMcFpVdk1vOUVxdjArSnRtbzQzcXlmWmExOHN2?=
 =?utf-8?B?QnpLRGtEYlg0V0VOT1BUWHdqOGFFd2R5WTFpWlFaUXEyQ2JubkJRN2xVUU5N?=
 =?utf-8?B?Rks1c0JmNFp3eWdOQW9XSGhkMGd0REpHTHY2eGpvaEppSGo4eVlkMEowSW9r?=
 =?utf-8?B?bXNVbUx5Y0pZRVhwOHpJTWg5Zk4vek1JcGRYVThaS2pMTmI3ODYvTy9QTmVD?=
 =?utf-8?B?ZVpUS0ZoOTk4WTBiMmIzOEI2bUJ2c2UxYW1mRStVNU1zcEJBcGo2THZIc1p6?=
 =?utf-8?B?bDg0OFhQaXVTQzhnRkJ0WFhOMy93VlZxaG9qbW5UVlJDNDdRUWdTQzA0WU15?=
 =?utf-8?B?MXJuR2IwSDVQUjNYbFU1TGFOUHZWb3dubFFMM0JrZTBMRHM0by83dlBFVjJC?=
 =?utf-8?B?NlZwU25pM21hcTQwd0VzRmJuNFRPY3JZaUtRL0VwSzBOTThMQWJyaUR0Rm1L?=
 =?utf-8?B?VTV4aVo4QzRZSGVDS2w2U0syeUJDaG44QWlTb3RjVHVRdm1mMUg2TnVJUVll?=
 =?utf-8?B?NkZFT1k4RmJsUEgrVk1Idk1GRXpiWU50a3dsSkZCdTQ0Q2M0dzJCNEp0V0JK?=
 =?utf-8?B?OUxaWDh5NzhFVnRZaDBNVThSakpEQXdXUUhGR2pwUXkwTlI5ZDZlbS9oRk9G?=
 =?utf-8?B?L1hEV3Z5Q1ozWTBaTGZNTmRpNXRnZmw1UjJ2Mk0xRHNwZmFQZkJCaC9XMnJ3?=
 =?utf-8?B?RzQ1RXNhbE9GdFk2N0VtekxKeDVBd3JBTkdrbm5ZYlh4djdXazBRVHRIOTFT?=
 =?utf-8?B?MzhTQ0NYUEVjSGRERDdNWkJROHRTa3IySlRjT3ZEeDEzTjlGVm9qUVU2ZVV3?=
 =?utf-8?B?L0tNbXE4MDJnNmE3MUlIenUrTjFTM1poeW51SXh3UGIyM3pJQ2o1NlBoNk14?=
 =?utf-8?B?OFF5VFBFN3ArZVdyK1hhK2pYS0tyUGVzNVhPdlpmY1BRNTErNld2aFhyandp?=
 =?utf-8?B?RER4dTJ4dWFrbEN0R25qT1diZGx4SU5DeWc1N3BGWFF0b1RDTU91SlFQbHVa?=
 =?utf-8?B?NDE5Z0hQY1ZLWXo3dTV5YTBxeGg4c0Vyb3NOQ0FiS2RkS0hHUnY1RTUxZ0Mr?=
 =?utf-8?B?NllrK1pVaTE1WmhldDBNWXFYVmtoMGV1TDBPMzZkMDlpOSt6c2NuYnlXYTFE?=
 =?utf-8?B?czd6R0RjTEgvdXYwZFpQN1o3SGRTUVVSV3YrL20yT29nUGI2MkNwVk5qZWFG?=
 =?utf-8?B?N3RUQ2V2cVBleEltSm55cExRTGpoVS9nL0hUUTY4eS92ZW4weHhaV2pYZTdk?=
 =?utf-8?B?cVAxemh0YzRwVDdhcVAyR1RNYm1hOHpuRlBaWlo0WEpXcVk4dHZRY2JZcmRC?=
 =?utf-8?B?Qkt1Z3JyV1RjbThBQ3g3L3k2ZmxJVFBsTWlmRXVHZmttVXU1U3ZsVHpmYTRJ?=
 =?utf-8?B?WmQyOHU0UWhKVy9YNDRyMzlkdWFleVZBVnZHODlDdWZUdFVBWlZqWitJOGZR?=
 =?utf-8?B?ZkMxcEoyV29VUU45S3hlaHl6WTU5cW04M0FldUpZWEUrSDhDYmtYc1ZoMDA3?=
 =?utf-8?B?R3dxejBDUzExL29FbmNtMFh0YXVVMmFqTUZEUGVDVTY2TE0yMkFHUklzOGNr?=
 =?utf-8?B?Ujd4ZGZTSjdTZ0NiZXhVVmQwZjlYZ3lJUStPRFNxR01hSVhtbTdJajBiNStv?=
 =?utf-8?Q?JSDoDVLpUiLvi?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR1001MB2068.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?aVhlbVJVUzBjVkM2eEpTem9XeUV3ZzZTZ0o0MXRqWXByUFF1SjNMNzMyUEFH?=
 =?utf-8?B?MHBpTXFweThHYkVLTjBNVHVLQnBiQ254OUpYNmxEZlBaN2xvMTV0dTRzWU82?=
 =?utf-8?B?dWRaRzgvdjdrZllxR0ExNG5HZDE1QzFkNEU3a01MNCtoWjdYTFM1UlRMaFBt?=
 =?utf-8?B?L1h2bWgwSmovanVpbCtPN1pDOGR0QW5yQTNhcDMzZUpIM1RyVGJERmQzcSs0?=
 =?utf-8?B?aVZaQXd3eGVQRkIxTjJTYnlHbnp3cGxvTXJvb21KcDMxTnpqdzJPUEcyYlh0?=
 =?utf-8?B?SVozY0xQKzFpNkR6V2phYnEyaXM1d0dKL01BL3JUUExYeEY3TWFzQ2VWenFu?=
 =?utf-8?B?Y2NFOTN6c3dEZHQ5eWtPMFM0MGgwQWV3YzRUbDBIbjI5emNxb3F1My9VNmQv?=
 =?utf-8?B?cFNlYTZ3MlhlQ3UvdEdQTjA3c0U5NDBpT0prZSt1aDNDMzJwNGFMNWpFN0w1?=
 =?utf-8?B?NjFYZkM1ZnF1YjN6SGV5OFhzR090bWh6UERMb0VKVU5PZ3ZCYXF2NWtvcTd6?=
 =?utf-8?B?WGRJUE9nRmw2SENZcGo1Rk5zZGJzcVVxSk5wQ3NpRFJTaEM0cGZvVnFtOUp1?=
 =?utf-8?B?aEQzMWdwVFFJNTB0MnF6cWZSd09UYlFPMDlwUkdJaldVZ2J1cUw0SlBDdXd2?=
 =?utf-8?B?MEFuZzZxaFRtWmFKY1hrZGszdUxqK1dOVUl3cGhJSUY2R2pZOTBuRjI1ZnNx?=
 =?utf-8?B?VkExemhLREVVMFA0NXVHQzNhK2JUMWhRSHlVU1pZYzcyRVdSR3VYZURwVU03?=
 =?utf-8?B?RDdnY0hqeXJ0MGE5aE0xWCthbGk4c3E2MkQ4Y2RDVnF1ekc0QWFNMURNT0lR?=
 =?utf-8?B?Y2c0ZXd5Slc1WGhTVlNOU284Yzk2WERwSmgyd1ozcGR2dDJnMzhKbEtXd2dv?=
 =?utf-8?B?QmI1NXBLelF6OUx4WTlOOHczbXFMOHEzem9mYTdGOVNWaFBTc29Yc1JFdVlu?=
 =?utf-8?B?anNqbjc1bzZjRkJtQ0V2RnBsVTlEWU5LcjdIRWZFSE5sQnNaRHJVT3dYYXR1?=
 =?utf-8?B?VGtBTGlkNEp2bWo3dXVlQW9veXpKR3BEK28vaFBxeFJUZW4reWFDNjQ5RkRF?=
 =?utf-8?B?TVZEbnh6dWpldURkb0c4RTZRTHh4SnQ4cmJUNmVvNU1CaDZNNlNpWDJIZCt3?=
 =?utf-8?B?eUZkK0Y4NjgvVnhuTkJJY05zVzVEQ1BEaUxWSjdRcUNiR3RCSzBpUGJXY2hK?=
 =?utf-8?B?My9leFFHWUlIckZiZkMzWFdDRk9la2hrelNzTFJsWXppay8rWkJVTWZrem1M?=
 =?utf-8?B?RVNER0ZxMkNxSStjVGFEYmJBOGlFNHY0WnBCZXVhT0EyTE9LWDJ4TkRPaUVU?=
 =?utf-8?B?VmdyekUzVUhTbmd0RDVYdHE1WFYwdU5objlkWUsyNWNoRmFRYTY3ZmYzWWZn?=
 =?utf-8?B?Rmk4TWlDZkZlYzZhSWtWc3hXclZ4U1MwaGIwcHR2Z3ZiM2NobFQzVDljcFVR?=
 =?utf-8?B?UUlkZzZmK2FvZ2xnL1BxZUJucEE0bUJPT0U2cTd1S24rZjF1ZDVmck9xM2Zy?=
 =?utf-8?B?cXA4ZWJIc3RqcmRvVjhYdGRQbHNhMG1vOVpyQ2JWczNKRHpZalFpTVV0dHFt?=
 =?utf-8?B?SG5xTTZyM0V6dmVzSDA5Tm11ZGdFUFZna3VYRGZOQnVSbkZhY2J4TnNQc2Zk?=
 =?utf-8?B?N1Y0SUFoaHMyNWtRZzJuN2Z2UldKS3JSOEJ6TVd0eVVPVElESTFrU0h6c0Vi?=
 =?utf-8?B?ejRxcDVoY1g5Q2ZaSTBCODcxcWpqYkNTTkNVVS81VlN1YmZ4VnY3aENIaHBP?=
 =?utf-8?B?d2NoQlloOHdzTnMzams4NHhFbmdaaDY3ZU54Vk5TbGx5OVJ0blVCUE5TY1BZ?=
 =?utf-8?B?dHliUUdhd3U2QnFDR3B5WjRNQVBmVjJxQmVmT3R5aExMSVhoZ2I0SnZmOTZV?=
 =?utf-8?B?bEk2NTlsUUFSTnlINU1FR2NMdHMzUVZDVGRZQkdjMkx4SmZyK1Vzd1ZvdDE4?=
 =?utf-8?B?RE4rTEJuZUhlK1VCOHdaSWtXY0kvMDNCVnlubE9Zb0R2WUUwSTRDemRRczFj?=
 =?utf-8?B?Ykw2cE4wL2YwU0JzWnhFM2FDVVA5TldpWm1kRGptbWdGQUFIRmYzMFVadFZP?=
 =?utf-8?B?VHRHYlF1dzVnRGxLcXJ2ZzdMYlhiUVA2Wmk5bWc5U0g0TjJqWExraGZlbzUr?=
 =?utf-8?B?ZFZuRS9rTFJFcVRaa3VIUnMyNnpqQXlmL0N4UHJEdmRRYmVGb1BLWCt3NndF?=
 =?utf-8?B?RXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	qOa+CB+WEibugjPsKgwdFEo6bL0v5uQeRo7khX6C/wvaEdBIF1FwA0VQn1xnjIJk5ZHIxdZurKBeosgT6Rtqsp3x1OANJvNlmlAF4F81lHYB/h9CPMgjVlua7eIo0/CdhVCpPQ5l1/MOWnbHi9kJafBC16xTSVfajsRg4aAuuF0ANf5XA3zaH9HFfLhELgMtmb2GcJeq7O35wL/74txKODrpnmwI8oGTGOEtl4qWPcxSXXtJjIo3tflAXb7cp8etCJlTBYweF4wkFrFVcM60t+g1RMXUOk1NPR2uPv/CclNOV7+MOHogB7PveFrKtNwNH7bhvhGTFToGplVnrj/hNOgFwautoZXR4BWc1kw7g0OXgkbI34FCDMploM5LVhrpcIBu2vEk0TXcBwhO9ajkMU3aYl4LVEB7ZqAgbM8IjyYJ1Ag4QdCGoSZU9XxVT99EqcDIETZW51h6vNiUsFRjITOWAs7Gj4bXnB/wavH6zYUrPvUrXlVNxSwgrvAdW2S1v4DWT1YnwovTkIUocjO9L9EJGEBkC/Eu/vaP5JYdv+UvjWov8/3G/QdL6Juafew3ixdOxHCUBgZK4ovG/hfINR2LMglywuBG1HnycHiVK80=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4742b536-1191-4d5f-f58e-08dd5b6f722b
X-MS-Exchange-CrossTenant-AuthSource: BN6PR1001MB2068.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2025 22:53:57.3027
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sWIF+SSzqOgIB9tS17yVvMv63QSu0kISeSmwbQJc4bhJ90MsNFMrm2r86xqFrahj/HqjeXayVdjuI+4/2Eaa7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR10MB8074
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-04_09,2025-03-04_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 spamscore=0 bulkscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2503040183
X-Proofpoint-ORIG-GUID: 4WnU5W-5nBBLbotxxEtRQQKz66dKPXw4
X-Proofpoint-GUID: 4WnU5W-5nBBLbotxxEtRQQKz66dKPXw4

Hi Xiaoyao,

On 3/4/25 6:40 AM, Xiaoyao Li wrote:
> On 3/3/2025 6:00 AM, Dongli Zhang wrote:
>> When the PERFCORE is disabled with "-cpu host,-perfctr-core", it is
>> reflected in in guest dmesg.
>>
>> [    0.285136] Performance Events: AMD PMU driver.
> 
> I'm a little confused. wWhen no perfctr-core, AMD PMU driver can still be
> probed? (forgive me if I ask a silly question)

Intel use "cpuid -1 -l 0xa" to determine the support of PMU.

However, AMD doesn't use CPUID to determine PMU support (except AMD PMU
PerfMonV2).

I have derived everything from Linux kernel function amd_pmu_init().

As line 1521, the PMU isn't supported by old AMD CPUs.

1516 __init int amd_pmu_init(void)
1517 {
1518         int ret;
1519
1520         /* Performance-monitoring supported from K7 and later: */
1521         if (boot_cpu_data.x86 < 6)
1522                 return -ENODEV;
1523
1524         x86_pmu = amd_pmu;
1525
1526         ret = amd_core_pmu_init();


1. Therefore, at least 4 PMCs are available (without 'perfctr-core').

2. With 'perfctr-core', there are 6 PMCs. (line 1410)

1404 static int __init amd_core_pmu_init(void)
1405 {
1406         union cpuid_0x80000022_ebx ebx;
1407         u64 even_ctr_mask = 0ULL;
1408         int i;
1409
1410         if (!boot_cpu_has(X86_FEATURE_PERFCTR_CORE))
1411                 return 0;
1412
1413         /* Avoid calculating the value each time in the NMI handler */
1414         perf_nmi_window = msecs_to_jiffies(100);
1415
1416         /*
1417          * If core performance counter extensions exists, we must use
1418          * MSR_F15H_PERF_CTL/MSR_F15H_PERF_CTR msrs. See also
1419          * amd_pmu_addr_offset().
1420          */
1421         x86_pmu.eventsel        = MSR_F15H_PERF_CTL;
1422         x86_pmu.perfctr         = MSR_F15H_PERF_CTR;
1423         x86_pmu.cntr_mask64     = GENMASK_ULL(AMD64_NUM_COUNTERS_CORE
- 1, 0);


3. With PerfMonV2, extra global registers are available, as well as PMCs.
(line 1426)

1425         /* Check for Performance Monitoring v2 support */
1426         if (boot_cpu_has(X86_FEATURE_PERFMON_V2)) {
1427                 ebx.full = cpuid_ebx(EXT_PERFMON_DEBUG_FEATURES);
1428
1429                 /* Update PMU version for later usage */
1430                 x86_pmu.version = 2;
1431
1432                 /* Find the number of available Core PMCs */
1433                 x86_pmu.cntr_mask64 =
GENMASK_ULL(ebx.split.num_core_pmc - 1, 0);
1434
1435                 amd_pmu_global_cntr_mask = x86_pmu.cntr_mask64;
1436
1437                 /* Update PMC handling functions */
1438                 x86_pmu.enable_all = amd_pmu_v2_enable_all;
1439                 x86_pmu.disable_all = amd_pmu_v2_disable_all;
1440                 x86_pmu.enable = amd_pmu_v2_enable_event;
1441                 x86_pmu.handle_irq = amd_pmu_v2_handle_irq;
1442                 static_call_update(amd_pmu_test_overflow,
amd_pmu_test_overflow_status);
1443         }


That's why legacy 4-PMC PMU is probed after we disable perfctr-core.

- (boot_cpu_data.x86 < 6): No PMU.
- Without perfctr-core: 4 PMCs
- With perfctr-core: 6 PMCs
- PerfMonV2: PMCs (currently 6) + global PMU registers


May this resolve your concern in another thread that "This looks like a KVM
bug."? This isn't a KVM bug. It is because AMD's lack of the configuration
to disable PMU.

Thank you very much!

Dongli Zhang

> 
>> However, the guest CPUID indicates the PerfMonV2 is still available.
>>
>> CPU:
>>     Extended Performance Monitoring and Debugging (0x80000022):
>>        AMD performance monitoring V2         = true
>>        AMD LBR V2                            = false
>>        AMD LBR stack & PMC freezing          = false
>>        number of core perf ctrs              = 0x6 (6)
>>        number of LBR stack entries           = 0x0 (0)
>>        number of avail Northbridge perf ctrs = 0x0 (0)
>>        number of available UMC PMCs          = 0x0 (0)
>>        active UMCs bitmask                   = 0x0
>>
>> Disable PerfMonV2 in CPUID when PERFCORE is disabled.
>>
>> Suggested-by: Zhao Liu <zhao1.liu@intel.com>
> 
> Though I have above confusion of the description, the change itself looks
> good to me. So
> 
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> 
>> Fixes: 209b0ac12074 ("target/i386: Add PerfMonV2 feature bit")
>> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
>> ---
>> Changed since v1:
>>    - Use feature_dependencies (suggested by Zhao Liu).
>>
>>   target/i386/cpu.c | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
>> index 72ab147e85..b6d6167910 100644
>> --- a/target/i386/cpu.c
>> +++ b/target/i386/cpu.c
>> @@ -1805,6 +1805,10 @@ static FeatureDep feature_dependencies[] = {
>>           .from = { FEAT_7_1_EDX,             CPUID_7_1_EDX_AVX10 },
>>           .to = { FEAT_24_0_EBX,              ~0ull },
>>       },
>> +    {
>> +        .from = { FEAT_8000_0001_ECX,       CPUID_EXT3_PERFCORE },
>> +        .to = { FEAT_8000_0022_EAX,        
>> CPUID_8000_0022_EAX_PERFMON_V2 },
>> +    },
>>   };
>>     typedef struct X86RegisterInfo32 {
> 


