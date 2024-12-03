Return-Path: <kvm+bounces-32876-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 27D8F9E10E4
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 02:44:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BF927281298
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 01:44:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6C2F558BB;
	Tue,  3 Dec 2024 01:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="otYub5AN";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="iSh7dOkY"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61FDFB663
	for <kvm@vger.kernel.org>; Tue,  3 Dec 2024 01:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733190239; cv=fail; b=Mx6V8gl2ud7lDoQ1Y+eUF32aR1caFN964oDiAk0y22t8qZPMLEIvxXvf3j3CfergCP6dqw6dj4tv9qDWS4akmM/tXMHB9P3ksC6Tp6BpnUz+OPj83sZd9NUzmoqma2QyqijpnPgjGwAHbr8Szua5XBH+R/r/J5zD4HO0oatoIJY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733190239; c=relaxed/simple;
	bh=nY6U20oWzL8NTg7WKMd0lROh+T8PtEv2j2DlMOKm9gc=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=et2rZvlgbpCUPOXNNuruABJomFVphZVBQs4AI6A1jftMslda1XKPNoamK6dhSig+mFThbI3nNu6Iiei3Wm6ZPwdQZh7ecG4MpxmgDBFinLYNr3UH2PXXYUtAb3PfBJUtsVshfzr9yNYDSk7lRQFrbHndxeHVgl5S+59I5G9HV5g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=otYub5AN; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=iSh7dOkY; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4B2MtvHf000691;
	Tue, 3 Dec 2024 00:15:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=Lwe0DaH/HYuUO1EIr7vEdFG2HkQtkMrU9IVkVwKaOxk=; b=
	otYub5ANRBJ7IKuuvD5QD7Xz+koSbSEUq/5ODzSzxMMYVnStmbJvmvcfx5TRT4cj
	355gHWCkA93Kgm5WSYTiKSx3WLCAKE3y5SynQSfgNlxQ24dBDh9GKqP6+akCbYTI
	ITTymqb99QoPcl3imvNFjS3dwvFj544ic9ZH+5suzRd3+wjZv8NFRfhhUlgpPKPn
	5eFg6UeuxYRu3rfaTQoBWqq3Rh3MlsU5O56fOwJZkhA6tczGH1PqyQ9eeO0F5OCi
	GN+2uw5Zd3BHMMwYzpR++iKv4pHIPWgBD6PAdWEPdkA7VM6RvTHYHTr0XMp2fOcj
	Cjw7urEIUoBVxrH0nvpIxw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 437tas4xqd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Dec 2024 00:15:50 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4B2MP34w039064;
	Tue, 3 Dec 2024 00:15:49 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 437s57af5n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Dec 2024 00:15:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ww1hVUPxGFwrZqc+ICiBzYjitzQkgDVJzrMsbt+fewyXHiaMLXTUf42MZE6b6IxSFvaVZTu2heF0wmLkcO+fIxHFJ9vgRqV1U2X01WjZvvKjwAomVshoXnGx42e3hgELkbj5UNefXtxIh6zfwDQrjMsqmDseeLb9bkrbDzbPzo7fdbaljnRZy1CvVYnlFGMPyHJa6Ua6BlaT7i50HVIbmMRg9a2lTF+vyYJHbKuAXGrXRBOZx9mfu5Fd/jTowTNVYlyqTdsQO7ippd1lyvOn/7AWcfAU3I92fv0GNPsY3dDKJvHqv9+TXwamaUPRp3baUWMHG4++7cSekvUh/pnvfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lwe0DaH/HYuUO1EIr7vEdFG2HkQtkMrU9IVkVwKaOxk=;
 b=JzMqSAdoFWqy7Y2iIOJ6W8LnjdbkzQEyUSqerhJ1Scys5yai2tvS9JalJr5+7C4QSf7v299wHzcPsUE2ObWmZojEJrOSJP/QKwhP8uWadTRK0hYjH6hH56Cay8aQk65736SmC7QEd3nqrR4aZZ93WDLJ81oU0sKDSjTpXyk/ikoYZcIPSlWFb8r3JJmxiF73gk17WqEtb0z2P8Xun7WD9Is8YPtzfGts/rG5JioL3fVCCKUUK18myouW2pPIT78mzhDy3kiBtIL9wiG8AcyzZWYLhbFQIjMKCTXycoOvubi2NhEcja28LzxhBelR7sABNSSOMGrFy814PUS3M0/Xqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lwe0DaH/HYuUO1EIr7vEdFG2HkQtkMrU9IVkVwKaOxk=;
 b=iSh7dOkYimAE8KsHnQVPhkFsm2uhiu4CNlkLEnJ3//z2Z9zVCK2HtH17ZOObum9yWQfuLrDed4zs8sFYSf7yr0A2fkWfZX0sCJpjO+wF8FnP5yVfv5CgrAHJV57JcoQkwk18e0E9R7H/YNBkXL32FtPSM2LKB5lXdxEExt390Fs=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by SJ2PR10MB7037.namprd10.prod.outlook.com (2603:10b6:a03:4c5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.17; Tue, 3 Dec
 2024 00:15:45 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%4]) with mapi id 15.20.8207.017; Tue, 3 Dec 2024
 00:15:45 +0000
Message-ID: <e09204a4-1570-4d39-afc7-e839a0a492d8@oracle.com>
Date: Tue, 3 Dec 2024 01:15:41 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/7] hugetlbfs memory HW error fixes
To: David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: peterx@redhat.com, pbonzini@redhat.com, richard.henderson@linaro.org,
        philmd@linaro.org, peter.maydell@linaro.org, mtosatti@redhat.com,
        imammedo@redhat.com, eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
References: <cf587c8b-3894-4589-bfea-be5db70e81f3@redhat.com>
 <20241125142718.3373203-1-william.roche@oracle.com>
 <48b09647-d2ba-43e5-8e73-16fb4ace6da5@oracle.com>
 <874e2625-b5e7-4247-994a-9b341abbdceb@redhat.com>
Content-Language: en-US, fr
From: William Roche <william.roche@oracle.com>
In-Reply-To: <874e2625-b5e7-4247-994a-9b341abbdceb@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO2P265CA0027.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:61::15) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|SJ2PR10MB7037:EE_
X-MS-Office365-Filtering-Correlation-Id: e0acf22e-e814-4f58-01b4-08dd132fa1b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?S2Jwcml5TGVqY1dRYzFVQW5BbWhZdmxMNDg1RXVQMU81NC9tNHBmZm5yWmo5?=
 =?utf-8?B?VTJRYkZvNS9QbGgrSUh2UmM1SmlMOGlob1BOenBaeExwYmZYd29VM0RETDVR?=
 =?utf-8?B?OW9MSWo2WmdZQnhzRnR6WVRuNnRkTTdqbVgyM1dZZ3IxaUJ6d3JQUkhId0Ix?=
 =?utf-8?B?MHhJaTMwYkxxd0NMM0JlSUUwVkR3L3ZCMjJFdzlvc0kxbnhNVHVZMnk1dXQy?=
 =?utf-8?B?SXBaUUo2TnV3MnRRUUVURythZFoyWk5iREh2MDVlbk9zSmJFSnF6Y1hSU3JQ?=
 =?utf-8?B?M3pnUU5YRnphR2Y0VGtmM1loOGZQWWtZRDR5Q0s1NGowVU9CWUJPR09YRUR2?=
 =?utf-8?B?R1JqK3MrWnErMGVMVjdQYUZ0clJKOExjK1RGcmV3WC85c25SR0U2UGxRcHhw?=
 =?utf-8?B?NUZhdUdZeHFUYmdyUDdJV000OUpSa0NVQ09PenlIQnRrM0t6Mit1bklGMFN0?=
 =?utf-8?B?RGViTHJHZ2JSZjBXVlFjS1RXc29UMEsrQnNPMElFSHQ4RnBlR1cvM1ZJb240?=
 =?utf-8?B?eHVUNVE3YnMvRUF4dUF5V1ZpOEJVTlZ2bCtnb1ZEbWx4bytQQjhTOElOY28x?=
 =?utf-8?B?QXRFOGhNdEkvVDRMdEJCeVdPVWVHYmlzcmpuZFVrd0YzNE1DbnNDQTVERXJx?=
 =?utf-8?B?ejlSMjlPUjQycllJNUtKaEt4cm5HK3ZsL1piSitWRFN4eEFHOXowSDlsS3RY?=
 =?utf-8?B?ZW9IWEdRek85VzEyQ1FOeHBhbzkrdHJwbk9rSHBqdTJGblBEb1pMcEcxdGMy?=
 =?utf-8?B?a00vYitrR2ZpdjA3RUZycmtJaTlYQ1BBOVg5b0d2REM3U2RITS9UUDJaVHFE?=
 =?utf-8?B?dWlDb3I1disxMjlVRVpJY0U4M0ZjdndoTzVucjlVRnpyNDE1dk1KYXdjemZi?=
 =?utf-8?B?NTljeGJLVllGYzdnMGNVbDluV2hMTzJGNVlhSXFGTC9YUW9Ld0VMMkJrQnVW?=
 =?utf-8?B?K2xEVTN0ZHpoeUxMT0NBSFl0T2RqcmN3a0M4Y1g0QndFNFlqL2hzZHJmejdk?=
 =?utf-8?B?U2VmSGFHak9JU09ReEZ3bDhycTBuU3VjbDY4bG1aa0s3MkUrdHFCQXQ4Zk1p?=
 =?utf-8?B?MlBSUFp4NDhxUVZ2SkhaVk1WRjM3TmNPa0pPc1FUK0dOWUo2REV6ZGR5WUhu?=
 =?utf-8?B?TklpdnQyandIYVQvVmNucWxUbGtUb01YeldSOHd5U3psa1hPR1ZpTHlOeHdj?=
 =?utf-8?B?RDF0ZVNOU29nNVhxV1VhZTF0QVQyci9jQjdvY2ZyalNlc0FCN3FjZHNTT3M0?=
 =?utf-8?B?cXFsdTNzZ2pTN085OHJaMlpwdkNSUzNiVUhTd21OcFJiRi9jQ1M5MlJqTm9r?=
 =?utf-8?B?dlF4TzM5dGZva1lEd21jTEZPd0VkVkgwMDZ4TGZQaGR0WkYxYXpDcjllbGlt?=
 =?utf-8?B?b2xIRFNlalJjT1A1RlYybUhTSGp3cHhMQmx1bis1bWhWYmlFVnFLTy8yMnA0?=
 =?utf-8?B?TCtQT3h6T0ZsOFRDc1YwNllEbmxFS2dyN3NGWEVPcjlXOVJPTUdHSzdLNFVM?=
 =?utf-8?B?OEJDdDNWUHFVMXFFOENOSG5LdW1NZ2RoSzlUZzRQcVg2QTRUbzdBL2l2eXVX?=
 =?utf-8?B?LzRrbE45d0tISmkzeVVJWG50U1crb2E2dUlIM0UxMnY3OElpQ3RBOVRDSDRh?=
 =?utf-8?B?WU9QT3U0bEdacmJrZ3NibmNZeEdPcEVQTUdYUmtPbDhodzR1SjRPVU5URThG?=
 =?utf-8?B?clVwL0lIdjh1TWI1dVNmd1plR3BCU2hLYTRma0MyL0xUTXRlTVZSTVVIUDZK?=
 =?utf-8?B?MnZlV0dJYkhHRXk1RkZtUjl2TytjL1BMUHZObTczdTEvZ2dHbGhyYi9Rd1J2?=
 =?utf-8?B?ejlBNmNTcFpBNzRBSktFUT09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OW1FcWQ5MTNEeExvQThDcVI5L1FKOG9ZWnlUdnNBRTY2ckdlR3pXQUNaS0dY?=
 =?utf-8?B?TE9pakRDOWZnOENLckgxOUFlRmpsQkVMWkFCVy9hdEp3TnF2TEpBSmxhWUdx?=
 =?utf-8?B?REhiSTVRbTRuNzZiNTZqY2Z6SFNLWmMrd21IaWhYcHJ5bWNpS0lMcXNjYnJ4?=
 =?utf-8?B?aVRHeENaak5PTmpKQnNZOUN6WVhrWlJ6S3hYeGZqR00xWlY5N3ExTVloZW43?=
 =?utf-8?B?UUhxRmZvaHpHOEI3dlFJZEdqSWlKQnRwU2YzNGR0c0tlTkZYd2FTWXJaZDlp?=
 =?utf-8?B?djZiam1RMlVPV3h3ckU3c0FYR2R5UGNvamVsQjQzckpKZGtMdGk5M29pVnpw?=
 =?utf-8?B?enRmQ2c4bjRBczYyOWFJU3hyUzB6cVdFUGU4ekJwajhyL0pRd2dldzUxbEpv?=
 =?utf-8?B?OHI5cnZoS1U5UFNHS0Z4MXRwcmpNbHdEbHdVQTlNdkFVdjV0b3lJVUpvQlBi?=
 =?utf-8?B?clp5NEIwaUpmOW1uczd5dmhLMXpYMjg4aFdDaVBteGVVWEpHMmk4azFtYWpq?=
 =?utf-8?B?TldSamVsSHorQnBBOHduRjJGc1ZRRzcySGI5dEpsYlRGWGwxRlowN2ZBdjFn?=
 =?utf-8?B?dWRwY3UyUDl4Z24zQXNPelhJdWpUaGw4TmNHcS95dXU0Q0tGcFJ3bjI5RnFM?=
 =?utf-8?B?OXlMRkk2NC9XTkl5M2dGTEZpNkV5ZDJxOVhsMmtqOTdxRVAzakFqQk8xME1w?=
 =?utf-8?B?UGUwV3Q1QVd1OXNSUEhock11L1RHRjd2RFk2cXpVeS9sYkVpMHVhclZJcjVr?=
 =?utf-8?B?enNZUWVxdlJITVMveEtqck5JYm9tNU9RNC9Gd0oyLy96TFFuRW0wSjhQajVK?=
 =?utf-8?B?a2wzRjdhdXQ0QTlJMmpJMUlSd0szNzVsMFVDd3QwYzVrTkRDc3h5MVEvaEgw?=
 =?utf-8?B?UGhQazJNVGpBV0JZZVhnRzVkWElKVUdKU05JSnVBcE9oQmNrYzBoRFQ1VTNI?=
 =?utf-8?B?RnJGaHdzbS8yZFZrMndXR1ovay9nVnVsOGF3K1dtZGFQcjRpdjVaMjREV0Fn?=
 =?utf-8?B?WG5qN29SdGhVM1A0MEQrekFONExSZ2pjcXhyVDZqR2d3ZFBwenBRUWVDMmoz?=
 =?utf-8?B?QmNucEc1N1BXUVVRYXRoTHJHKytoL2FLWmYvbzdIYnF1SS9YMGxWeDFKakRW?=
 =?utf-8?B?MUxNUG53WkM2WUdadit1MGV3bVQ3SWZldXpBU0pWMVE3YkhuQzNhZHBBUEFQ?=
 =?utf-8?B?NEpUcHZTR3N6TTZadmlqZDNVR1M5dGxYNDdRWkhIOU9vZlQ1RllNb3pET0ZL?=
 =?utf-8?B?QVZFNHpWWG9RdUNIVFlFOVBjaDVadGxkTW14ektCU3RRUUJRYVNQWVorRjJl?=
 =?utf-8?B?WStEZEFPNmtIb2lqSncxQTFYR0hJeFZYclhMRytwWjgzRzVISmg0S2dhNUts?=
 =?utf-8?B?a3JaTUQzRTAzd0dDMlVtSlZHQmhJQ3dJRDlXSkNiWWpwTDN1Y1lVUHZacFh4?=
 =?utf-8?B?QTdrTVpKejc3TGhibmZzUmZ5emRTdkg2cFVpR3F6djBpWXpoRW16eGk0WEV2?=
 =?utf-8?B?RzhzdCtmR040cUVzV0dack55ZUFFd2hVRmtLRmJCMlZ4eUtiUzJQRXBvWUpX?=
 =?utf-8?B?NW1XNUxxRVh1V0xyRG83WmVoOGQwakc0R0g3R0lKanBacUdxNWVCcWpXR2ZC?=
 =?utf-8?B?U25pdWRIa3ZlYmIrWGdoTExSV25sNmV6bWhvZFNSSXZFeW53OHlLdVE2QkM2?=
 =?utf-8?B?MVZmWHI5a0s0ZnBURitadmtsQWtjWlVrcjlpdHRGb0ZiUGRPK09SeU83NFg4?=
 =?utf-8?B?NjV5TVhlZW93UFRvSDhjdWRUa2RnYVMxaVdpSkxpWGIySWozMGJPY3NGQ3ZL?=
 =?utf-8?B?RG84UkxoVUNYNGxyckdEV0FNUzk5WnBtb3pUckhTY0xqK2FrdThhbnRqUEFI?=
 =?utf-8?B?anZ0Q2lHM0lSL0lUQUpNeVI3cFpxdHIxeXlEUE9xbmNUZmVKTEFKdVRzUFIx?=
 =?utf-8?B?R1Q0ZW8yc0RvNXJkR2pXUDV6WkdCck9CN0FCbW9aMjFDYTVSNmY2NEVHUC9r?=
 =?utf-8?B?YWFBakhpTlVreGlmMGYycWtvNTNKZk9sUnpoTHU4blZnWFJ3ZmxIZWRYUFly?=
 =?utf-8?B?TUxWaHFrL3E1dmkwSlJDU1hESEVvajVXdzgvQUluSFA5TGxwS0Q1Nit5d28w?=
 =?utf-8?Q?zEDIDfyAZV3xPT5pUqjxFvnI2?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	t/QsIAUMVlTc8c4AFpAFluL54/8ybZzTnENXzoXD5Pesewy4x5t9SRf20Ah8xHWuwd5g+PtpSyCmqy7hDyk5G4BzfYylA6M+qUDT43/SZ19I4U2f5U+g4BkhaUgfqiWCqlhMUSjGXRCSCDL6as7467NWDbQGeycT7uZ5YEYJHe4wTu39MYXT1RU2Ki+fVPT+NY04WzOaNdNY8L6Pxj5gCYdoSe6/kmQR8NRkng1Ymi/w8Wn5ITONbQIUWAzkJw/DX0B8Dts8GdAWhXTG+vdrxYqRAC2qwNQepR5VOND+TEz2IZv+y8npQboqwEbyTi7qkg8cnlJLLMowtBJ3IRI9hNDGESBaxZ6NIOVzT6p5IjSR5OTWNtf/mw8CWkJ3rWS12IoTmYbpMufcP1QxPiTCaBDY+tzzNKAA2aJ3Yt2H+ZYMKYdvtlbxeL/YgIGKGeZjnOPgbQmxRzPBAp8ggmma3I1gVZaWTZbuN9zUCJuLBHoLzPHAy3JfWP8Vl2s20w417rL6x5KYZX7x+rYFYcCac66X6Gne0MLUDafu7gd7jDPMv8dNUL+V5Bb/KhTOc70R9ApTZKCabT3Zl6Iw/+Uu1hQagrEtw/n1Azzxs7AKJI8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0acf22e-e814-4f58-01b4-08dd132fa1b8
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2024 00:15:45.5679
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7h3A920+soqbBY7oDrCqsGdze8tp/OKqfz7pgJjfR1FDqFAXEWo2YSJqrYoqePTEbY2gZxyvPtujYDLs3u+WXl4KU1ne23RcxzG7DdTSDbU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7037
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-02_14,2024-12-02_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 bulkscore=0 phishscore=0 malwarescore=0 mlxscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2412030000
X-Proofpoint-GUID: oMURKh-jtHr6juwiaBDLBRkzYHi9j4LQ
X-Proofpoint-ORIG-GUID: oMURKh-jtHr6juwiaBDLBRkzYHi9j4LQ

On 12/2/24 17:00, David Hildenbrand wrote:
> On 02.12.24 16:41, William Roche wrote:
>> Hello David,
> 
> Hi,
> 
> sorry for reviewing yet, I was rather sick the last 1.5 weeks.

I hope you get well soon!

>> I've finally tested many page mapping possibilities and tried to
>> identify the error injection reaction on these pages to see if mmap()
>> can be used to recover the impacted area.
>> I'm using the latest upstream kernel I have for that:
>> 6.12.0-rc7.master.20241117.ol9.x86_64
>> But I also got similar results with a kernel not supporting
>> MADV_DONTNEED, for example: 5.15.0-301.163.5.2.el9uek.x86_64
>>
>>
>> Let's start with mapping a file without modifying the mapped area:
>> In this case we should have a clean page cache mapped in the process.
>> If an error is injected on this page, the kernel doesn't even inform the
>> process about the error as the page is replaced (no matter if the
>> mapping was shared of not).
>>
>> The kernel indicates this situation with the following messages:
>>
>> [10759.371701] Injecting memory failure at pfn 0x10d88e
>> [10759.374922] Memory failure: 0x10d88e: corrupted page was clean:
>> dropped without side effects
>> [10759.377525] Memory failure: 0x10d88e: recovery action for clean LRU
>> page: Recovered
> 
> Right. The reason here is that we can simply allocate a new page and 
> load data from disk. No corruption.
> 
>>
>>
>> Now when the page content is modified, in the case of standard page
>> size, we need to consider a MAP_PRIVATE or MAP_SHARED
>> - in the case of a MAP_PRIVATE page, this page is corrupted and the
>> modified data are lost, the kernel will use the SIGBUS mechanism to
>> inform this process if needed.
>>     But remapping the area sweeps away the poisoned page, and allows the
>> process to use the area.
>>
>> - In the case of a MAP_SHARED page, if the content hasn't been sync'ed
>> with the file backend, we also loose the modified data, and the kernel
>> can also raise SIGBUS.
>>     Remapping the area recreates a page cache from the "on disk" file
>> content, clearing the error.
> 
> In a mmap(MAP_SHARED, fd) region that will also require fallocate IIUC.

I would have expected the same thing, but what I noticed is that in the 
case of !hugetlb, even poisoned shared memory seem to be recovered with:
mmap(location, size, PROT_READ|PROT_WRITE, MAP_SHARED|MAP_FIXED, fd, 0)

But we can decide that the normal behavior in this case would be to 
require an fallocate() call, and if this call fails, we fail the recovery.
My tests showed that a standard sized page can be replaced by a new one 
calling the above mmap(). And shared hugetlb case doesn't work this way.

>>
>> In both cases, the kernel indicates messages like:
>> [41589.578750] Injecting memory failure for pfn 0x122105 at process
>> virtual address 0x7f13bad55000
>> [41589.582237] Memory failure: 0x122105: Sending SIGBUS to testdh:7343
>> due to hardware memory corruption
>> [41589.584907] Memory failure: 0x122105: recovery action for dirty LRU
>> page: Recovered
>  > >
>> Now in the case of hugetlbfs pages:
>> This case behaves the same way as the standard page size when using
>> MAP_PRIVATE: mmap of the underlying file is able to sweep away the
>> poisoned page.
>> But the MAP_SHARED case is different: mmap() doesn't clear anything.
>> fallocate() must be used.
> 
> Yes, I recall that is what I initially said. The behavior with 
> MAP_SHARED should be consistent between hugetlb and !hugetlb.

The tests showed that they are different.

>>
>>
>> In both cases, the kernel indicates messages like:
>> [89141.724295] Injecting memory failure for pfn 0x117800 at process
>> virtual address 0x7fd148800000
>> [89141.727103] Memory failure: 0x117800: Sending SIGBUS to testdh:9480
>> due to hardware memory corruption
>> [89141.729829] Memory failure: 0x117800: recovery action for huge page:
>> Recovered
>>
>> Conclusion:
>> We can't count on the mmap() method only for the hugetlbfs case with
>> MAP_SHARED.
>>

At the end of this email, I included the source code of a simplistic 
test case that shows that the page is replaced in the case of standard 
page size.

The idea of this test is simple:

1/ Create a local FILE with:
# dd if=/dev/zero of=./FILE bs=4k count=2
2+0 records in
2+0 records out
8192 bytes (8.2 kB, 8.0 KiB) copied, 0.000337674 s, 24.3 MB/s

2/ As root run:
# ./poisonedShared4k
Mapping 8192 bytes from file FILE
Reading and writing the first 2 pages content:
Read: Read: Wrote: Initial mem page 0
Wrote: Initial mem page 1
Data pages at 0x7f71a19d6000  physically 0x124fb0000
Data pages at 0x7f71a19d7000  physically 0x128ce4000
Poisoning 4k at 0x7f71a19d6000
Signal 7 received
	code 4		Signal code
	addr 0x7f71a19d6000	Memory location
	si_addr_lsb 12
siglongjmp used
Remapping the poisoned page
Reading and writing the first 2 pages content:
Read: Read: Initial mem page 1
Wrote: Rewrite mem page 0
Wrote: Rewrite mem page 1
Data pages at 0x7f71a19d6000  physically 0x10c367000
Data pages at 0x7f71a19d7000  physically 0x128ce4000


  ---

As we can see, this process:
- maps the FILE,
- tries to read and write the beginning of the first 2 pages
- gives their physical addresses
- poison the first page with a madvise(MADV_HWPOISON) call
- shows the SIGBUS signal received and recovers from it
- simply remaps the same page from the file
- tries again to read and write the beginning of the first 2 pages
- gives their physical addresses

  ---

The test (run on 6.12.0-rc7.master.20241117.ol9.x86_64) showed the 
memory is usable after the remap.
Do you see a different behavior, with an even more recent kernel ?

 >> So According to these tests results, we should change the part of the
 >> qemu_ram_remap() function (in the 2nd patch) to something like:
 >>
 >> +                if (ram_block_discard_range(block, offset + 
block->fd_offset,
 >> +                                            length) != 0) {
 >> +                    /*
 >> +                     * Fold back to using mmap(), but it cannot 
repair a
 >> +                     * shared hugetlbfs region. In this case we fail.
 >> +                     */
 >
 >
 > But why do we special-case hugetlb here? How would mmap(MAP_FIXED) help
 > to discard dirty pagecache data in a mmap(MAD_SHARED, fd) mapping?

You can see the behavior with the test case.

But for Qemu, we could decide to ignore that, and choose to fail in the 
generic case:

+                    /*
+                     * Fold back to using mmap(), but it should not 
repair a
+                     * shared file memory region. In this case we fail.
+                     */
+                    if (block->fd >= 0 && qemu_ram_is_shared(block)) {
+                        error_report("Shared memory poison recovery 
failure addr: "
+                                     RAM_ADDR_FMT "@" RAM_ADDR_FMT "",
+                                     length, addr);
+                        exit(1);
+                    }

Do you think this would be more secure ?

HTH,
William.


  ---------------------------------

#include <sys/types.h>
#include <sys/mman.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <stdint.h>
#include <signal.h>
#include <string.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <setjmp.h>

#define PAGEMAP_ENTRY 8
#define GET_BIT(X,Y) (X & ((uint64_t)1<<Y)) >> Y
#define GET_PFN(X) X & 0x7FFFFFFFFFFFFF
const int __endian_bit = 1;
#define is_bigendian() ( (*(char*)&__endian_bit) == 0 )

#define ALLOC_PAGES 2
#define myFile "FILE"
static sigjmp_buf jmpbuf;

/*
  * Generate an error on the given page.
  */
static void memory_error_advise(void* virtual_page) {
    int ret;

    printf("Poisoning 4k at %p\n", virtual_page);
    if (sigsetjmp(jmpbuf, 1) == 0) {
       ret = madvise(virtual_page, 4096, MADV_HWPOISON);
       if (ret)
          printf("Poisoning failed - madvise: %s", strerror(errno));
    }
}

static void print_physical_address(uint64_t virt_addr) {
    char path_buf [0x100];
    FILE * f;
    uint64_t read_val, file_offset, pfn = 0;
    long pgsz;
    unsigned char c_buf[PAGEMAP_ENTRY];
    pid_t my_pid = getpid();
    int status, i;

    sprintf(path_buf, "/proc/%u/pagemap", my_pid);

    f = fopen(path_buf, "rb");
    if(!f){
       printf("Error! Cannot open %s\n", path_buf);
       exit(EXIT_FAILURE);
    }

    pgsz = getpagesize();
    file_offset = virt_addr / pgsz * PAGEMAP_ENTRY;
    status = fseek(f, file_offset, SEEK_SET);
    if(status){
       perror("Failed to do fseek!");
       fclose(f);
       exit(EXIT_FAILURE);
    }

    for(i=0; i < PAGEMAP_ENTRY; i++){
       int c = getc(f);
       if(c==EOF){
          fclose(f);
          exit(EXIT_FAILURE);
       }
       if(is_bigendian())
            c_buf[i] = c;
       else
            c_buf[PAGEMAP_ENTRY - i - 1] = c;
    }
    fclose(f);

    read_val = 0;
    for(i=0; i < PAGEMAP_ENTRY; i++){
       read_val = (read_val << 8) + c_buf[i];
    }

    if(GET_BIT(read_val, 63)) { // Bit 63 page present
       pfn = GET_PFN(read_val);
    } else {
       printf("Page not present !\n");
    }
    if(GET_BIT(read_val, 62)) // Bit 62 page swapped
       printf("Page swapped\n");

    if (pfn == 0) {
       printf("Virt address translation 0x%llx failed\n");
       exit(EXIT_FAILURE);
    }

    printf("Data pages at 0x%llx  physically 0x%llx\n",
          (unsigned long long)virt_addr, (unsigned long long)pfn * pgsz);
}

/*
  * SIGBUS handler to display the given information.
  */
static void sigbus_action(int signum, siginfo_t *siginfo, void *ctx) {
    printf("Signal %d received\n", signum);
    printf("\tcode %d\t\tSignal code\n", siginfo->si_code);
    printf("\taddr 0x%llx\tMemory location\n", siginfo->si_addr);
    printf("\tsi_addr_lsb %d\n", siginfo->si_addr_lsb);

   if (siginfo->si_code == 4) { /* BUS_MCEERR_AR */
	fprintf(stderr, "siglongjmp used\n");
	siglongjmp(jmpbuf, 1);
   }
}

static void read_write(void* addr, int nb_pages, char* prefix) {
    int i;
    fprintf(stderr, "Reading and writing the first %d pages content:\n", 
nb_pages);
    if (sigsetjmp(jmpbuf, 1) == 0) {
       // read the strings at the beginning of each page.
       for (i=0; i < nb_pages; i++) {
          printf("Read: %s", ((char *)addr+ i*4096));
       }
       // also write something
       for (i=0; i < 2; i++) {
          sprintf(((char *)addr + i*4096), "%s %d\n", prefix, i);
	 printf("Wrote: %s %d\n", prefix, i);
       }
    }
}

int main(int argc, char ** argv) {
    int opt, fd, i;
    struct sigaction my_sigaction;
    uint64_t virt_addr, phys_addr;
    void *local_pnt, *v;
    struct stat statbuf;
    off_t s;

    // Need to have the CAP_SYS_ADMIN capability to get PFNs values in 
pagemap.
    if (getuid() != 0) {
       fprintf(stderr, "Usage: %s needs to run as root\n", argv[0]);
       exit(EXIT_FAILURE);
    }

    // attach our SIGBUS handler.
    my_sigaction.sa_sigaction = sigbus_action;
    my_sigaction.sa_flags = SA_SIGINFO | SA_NODEFER | SA_SIGINFO;
    if (sigaction(SIGBUS, &my_sigaction, NULL) == -1) {
       perror("Signal handler attach failed");
       exit(EXIT_FAILURE);
    }

    fd = open(myFile, O_RDWR);
    if (fd == -1) {
       perror("open");
       exit(EXIT_FAILURE);
    }
    if (fstat(fd, &statbuf) == -1) {
       perror("fstat");
       exit(EXIT_FAILURE);
    }
    s = statbuf.st_size;
    if (s < 2*4096) {
      fprintf(stderr, "File must be at least 2 pages large\n");
      exit(EXIT_FAILURE);
    }

    printf("Mapping %d bytes from file %s\n", s, myFile);
    local_pnt = mmap(NULL, s, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
    if (local_pnt == MAP_FAILED) {
      perror("mmap");
      exit(EXIT_FAILURE);
    }
    read_write(local_pnt, 2, "Initial mem page");

    virt_addr = (uint64_t)local_pnt;
    print_physical_address(virt_addr);
    print_physical_address(virt_addr+getpagesize());

    // Explicit error
    memory_error_advise((void*)virt_addr);

    // Remap the poisoned page
    fprintf(stderr, "Remapping the poisoned page\n");
    v = mmap(local_pnt, 4092, PROT_READ|PROT_WRITE, 
MAP_SHARED|MAP_FIXED, fd, 0);
    if ((v == MAP_FAILED) || (v != local_pnt)) {
       perror("mmap");
    }

    read_write(local_pnt, 2, "Rewrite mem page");
    print_physical_address(virt_addr);
    print_physical_address(virt_addr+getpagesize());
    return 0;
}

