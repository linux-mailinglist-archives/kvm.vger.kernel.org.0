Return-Path: <kvm+bounces-14907-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 885C48A7846
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 01:03:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D59E3B23F31
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 23:03:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A12813AA5A;
	Tue, 16 Apr 2024 23:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Fd3Ba5fe";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="w0OGpzuA"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84C29139D0B;
	Tue, 16 Apr 2024 23:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713308560; cv=fail; b=t8a8a3WyapCjuAui8hV1kMYUV1er5x8E1TubWUZleupY6GgmmNl/CVynctgcS1bz8fA4cC6hHnv/LfbFXhEo19aXFuGqKDI7U7vzdKh8pmCCMIxSBb0RPj6E993TbcyWGn2emfnDb+S1yBP5KsGr0RCYLP9Gx1MN8b8wQMibqK4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713308560; c=relaxed/simple;
	bh=AP68FlaPr3OUrB6eRNLYOGSvJdSSlrOSJGv9jmD4ujI=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=vGdxAaNuSMDshH+bvi0i0uTCh5V3c5bTwzQSOU4A8XBoGXoze3i37sRe5k3FCAWYMwlro4/4hcss0p9XS79I9orKSZhB4M4m1s0POsa7A7uIMrRJEjh6suw62eTIsNLhDQHSsSL0cBXkVZBLbRNccgcX7tDdGX8sjpct0fzxARw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Fd3Ba5fe; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=w0OGpzuA; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43GJjkMw006234;
	Tue, 16 Apr 2024 23:02:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=D/gJHAGabSfGjbU47+fpC5apDlUeQ/RLxxwolGaAgAc=;
 b=Fd3Ba5fe6u3c5bj9mzFvVHDDamVJFyCagcSa0q/Xr9JIbooBMxGf7diAn2Ve///LOnB4
 o82lIiLkcfXvfPoBRshBsXm7h6s37wZ9j6ZMd7nS5kJmhWiIBr3RZqbi39iNizJIOQqg
 22mV53901pPtEUgLfvKgvzsJdgxHcbw6U/5lNfldhux7eTAw4b7PAALLiT01XWJ8NDAI
 XDYtWNyH9IiCCb6zqMP0iimP0xiewvV5jXAjOcAFJFNRtP+cb0A3Q7fx+tnrI4SW4nu1
 M9YL8Vszqui+qGTSi+OFCVrOA5gVk6gv3uAatYHYsk2wnyFm5ID6/p9lgbzgkSeCSsvw Qw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xfgn2pgvk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Apr 2024 23:02:34 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43GLE17J012501;
	Tue, 16 Apr 2024 23:02:34 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xgkwfxe0k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Apr 2024 23:02:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YUKZW4qOqCH9jtq2LuqvPjy6JaketssQjSuwY0hbQgWMpAS8LO4gl7tzmCvommkQlx971wBLHzgbp1089RfGYwLvabjoQVHkducUHOkKoY+p9RVK2/ZEUXfz6cfqyIU1+Si6VuVTtVI/B3Q/mPg9Pu5OTTPCWxisHzNX6o8RavdBbLXDZ4qQnX1ModZsD71OzpXJ3bhnwrAeyDPTzcFIq5R+GVZq6LfTDwb3++20DeTUSpYAwnmlXPLJh8HlQYCv2kzW0QZRUlMCXzTbrUJ7C7FWa/7puFsD1fszu9fbW49hSdTINvBJM/XAyFFoyM0TdjEWSF5nyNjYNLqqHDXc4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D/gJHAGabSfGjbU47+fpC5apDlUeQ/RLxxwolGaAgAc=;
 b=gVFh3m5hxEJwNNiAhF8VfbCFGaA1OqK/xIUGXoNHxxJZj0sZsl/kLvet+6ObEVGbA4iGNcjINtWSnuccV/v7AeVsif9jNXpWjdNKanl8BPSzr4Mi6Oy2lTlJCQWjtenPIOO1heyDExSiGMtxWu+tHUmJTfg+cbvI51ulmFebLb14mp/rAyc3Q05eEXQ6b4U1/fmJbokz10rOUb91aQ0gBbA+YqFAvUw6Bog2HxlASU3jGzmREwsi6uPy+lKYCY8mppjOxwXYbjgoFr7TynmW1kgSQncSsiOD/mQS3U/Gelex4800RkpcWyQmnBxsew5L2tlnicingX4A7TWXs1/zcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D/gJHAGabSfGjbU47+fpC5apDlUeQ/RLxxwolGaAgAc=;
 b=w0OGpzuAFSD43DZnPol5QXFsZuLOgc4jrdXclOy1pOeatmOIjvMen/Xw2H9M96HDxtyo9QC+dd+hL2H+1yTh3ixfXA8LiVgYPBhlDM11ifkg1srA81dQCT9K3TN/DF1Xj7/367rTULnN3AWQFnkp2uqM15KNhMiQbJlOOFYRYGc=
Received: from BLAPR10MB5009.namprd10.prod.outlook.com (2603:10b6:208:321::10)
 by CH2PR10MB4230.namprd10.prod.outlook.com (2603:10b6:610:a5::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.50; Tue, 16 Apr
 2024 23:02:32 +0000
Received: from BLAPR10MB5009.namprd10.prod.outlook.com
 ([fe80::a088:b5e0:2c1:78a0]) by BLAPR10MB5009.namprd10.prod.outlook.com
 ([fe80::a088:b5e0:2c1:78a0%5]) with mapi id 15.20.7452.049; Tue, 16 Apr 2024
 23:02:32 +0000
Message-ID: <638ed26f-cd00-4a10-bd29-3f568b311da0@oracle.com>
Date: Tue, 16 Apr 2024 19:02:30 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM/x86: Do not clear SIPI while in SMM
To: Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240416204729.2541743-1-boris.ostrovsky@oracle.com>
 <c7091688-8af5-4e70-b2d7-6d0a7134dbbe@redhat.com>
 <66cc2113-3417-42d0-bf47-d707816cbb53@oracle.com>
 <CABgObfZ-dFnWK46pyvuaO8TKEKC5pntqa1nXm-7Cwr0rpg5a3w@mail.gmail.com>
 <Zh74XcF2xWSq7_ZA@google.com>
Content-Language: en-US
From: boris.ostrovsky@oracle.com
In-Reply-To: <Zh74XcF2xWSq7_ZA@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR18CA0025.namprd18.prod.outlook.com
 (2603:10b6:208:23c::30) To BLAPR10MB5009.namprd10.prod.outlook.com
 (2603:10b6:208:321::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5009:EE_|CH2PR10MB4230:EE_
X-MS-Office365-Filtering-Correlation-Id: 772cfd3c-f5ea-4257-bf9f-08dc5e694c07
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	j8JBL9shV8ijya4ET0DIao0WFA8xAYpIOJ8CvMpWS+JJ6G/KPnvEQ9uVHQOAMMI8TTm0xmWCsjjRFUIa8ku0vkKzoczXnET7IIcg9Lc/egOh8iDxcOkIswXxwv1D/XL7g2/G+5qYMGMvF4D9IOtJpYOB8rkV9ZRhJg5xNO0Z1QewZfBaRDCl91Ng4ujGUB3YGP3yq1W0mtVsmOuxnLqcGFBTqZeLDSz5ZZg5DgSDo1Sp/80iE0GnIm2x997di7O5GjGTr4ebfO8JO5/X0MZ+h3vM1Kr8ole/RdvCGqwDd2nb3T02imvqHjuVL/Z6shKGNJKq4SuRBxE4bp4xZBgVozKH++vTePD6AV0G+TMPffjeeQnHbL4SZVVEa3lqcwCGbQomF1HouMU0FA/DwPXgr5wZSScL9bXcd771CIwHjZqXz4eL9Rbkgz+DsOMZgy8eRT5iVO4EVPiNRxm1uPh+5EXfiEyXjqdcGaSJo8pF6SgoFV7Y+RDpW77okcKAOZA6CP7DZR2z01ARaWCNqbMzZcReynTaPePlaHjSlSsFTwgkFSfbPuix24fdpWNJN9G/ze9iq4Sc6ZCulzcEj8v0ajFjDcrvOK1xNGCyE3WLYR/9ykbxBWl99Ciq1nS14NI8PBghvmCdQNIJ5mQkPjmjMI9/prK8omgnQz8eDO78eSs=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5009.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?ZDZpMzByYWIxdDdBUkZzZkZUN1EwRHk4bjdmQ1JRK2F6NExYNXpTZWd2TGlQ?=
 =?utf-8?B?c3Rtb2NQa1ovOWk3eW5BWUpwT0tmNkpYV1hBNlJsalhuRDhhS245OVBCVGo0?=
 =?utf-8?B?QUlMTDdScXJFc2pRd3ZaTVVIdGxxMk5oTVl4b3A1RVNtN2dJWHJ4OVB6dUli?=
 =?utf-8?B?dzFNbE9IaHZIeG5wMldWVUg5ei9JaUJaOFBPL0FiNzV6d1lBTHZaenBrMU5y?=
 =?utf-8?B?MENrMWtPL0Q0Wjc0MFNEcXY5S1JlbzJ6TGJWSE5aUXBCMm1TS09rMitGajUy?=
 =?utf-8?B?VlZsVVorZXUrM1BvRWpZdWo3V2p3RXlkQWwxWHVKUGxCR2Y5aUM2aEdzNHR2?=
 =?utf-8?B?QkppemdYVXp3bmpFT2psVER2Sk9FTTFRakRCYThaQlZoL2R2SzUyNk0zZlJt?=
 =?utf-8?B?SGNkZ0l4ampHbFZyUE41dC9YejNSb0xTZXEvcWJ4UGhyQnhydFlTOTB2ZmUz?=
 =?utf-8?B?UGx5UG5rMVBjbHRvb2ovM0ZlMGcxUmRYMHBYVUdVaVVPL2dLcHM0cktSenl2?=
 =?utf-8?B?UWpLRUdpTGU5ckpia3F1Y1BkbCt3TklvejBPT3JaemtIVUJoMlFqNWlOMFR1?=
 =?utf-8?B?TFJDRkRtbUxuYm5jemlpSkRWdTlTYXlqV0RySTd0WE1Db29nLzNSTi85MERC?=
 =?utf-8?B?U09GR2N2VGpPZ25GU3MvTnU1MXNrWXpSL1lFZnJ1d251N21NS2w2Wkl6QmNH?=
 =?utf-8?B?MEp6SVNqRTlNWm1MUzFqYk5lZktTaDd2NW9pdm1weitjd3NwNUczMlo2cGtR?=
 =?utf-8?B?VktLMlRaVFRCUUZRcGFnczVma3dRUEh0eEN3bVVBNkpSR0p3VjRpbjI2bHpJ?=
 =?utf-8?B?T2xvRXZJYlIrbmdtYmtJdmQvTjM4aEZlNGUreGFJdFBFWnNMVlRxU0hacFl0?=
 =?utf-8?B?RzRUS2NxZ1luVGhBTFVrdEd0a1pwcmJJYjlmaUpQdTFZSmxZZVMzVzJoWWM4?=
 =?utf-8?B?RWJPMmNLUTdOM3F5MHl4U0RiOFlvbjc2R2tmWm5INFhqaFNXb3Y4M3ZNZjFO?=
 =?utf-8?B?cS9jUjhFaFpVOVlJT29mOWdlVVEwR0NicU1wdldXMzc3ZnFrYVd2N01NVVRk?=
 =?utf-8?B?SjRScTRYSTBKUjVEWFN1QUdNRUVCQWdNd3Awbmx4VzFUeVZpbThkS3dGZnZz?=
 =?utf-8?B?KzdUSGx2ampaMTdUR29JQWVrUU54UnBmcTZCMndRY0I0QmU1aU5MZld3MkQ3?=
 =?utf-8?B?VUtqN2NrY2ZnZEo3MEwwbWlHQTVLOUNsdHhnWVQzc2lCNCt6Tk90bDNDc0Vo?=
 =?utf-8?B?cjRKNllzRXZMbTFhVkM1WUxueEt2RmNKWjlGK1EzZER3SUF6c0UyN3Ivb1hy?=
 =?utf-8?B?T2pkemNMcmpnSG9KVktQKy9MT1JNeE96bWk2WGd3UnlEL1hNU0s5UlU2Y3Mx?=
 =?utf-8?B?Q3o2Uzl2ODhBUStOR1RVeE1uVmFyZE1EYnMvWHo2ZG5KcXd6VjRkNTR0SlVC?=
 =?utf-8?B?dGtFMThkaWRlWnBxSVdjbDg5K3BPdy9yRGQ5aWdZdHlRNDdBZ2VHZ3NSYnZT?=
 =?utf-8?B?MUR4azl6RkgzMVV5bThhb2NMb215QnRxUG5DUlJ2N0RXNlluSUtFZHlwZ2kz?=
 =?utf-8?B?bDY5ZXl2MzlwSFNwUU1FaWxxT1JoU09mRVpYUy9KY2dnMUlsQkEyTGhVeWwr?=
 =?utf-8?B?Ty9kdzNhS0UzS0pWNkV4bERPYlU1MWFaOHJjeFNFYmZtRjZ4VzczVG5aYnJ6?=
 =?utf-8?B?M2g4Sjc4MzYyMkRIRFVZV2JxV0JUSHV5eS8zYnl2TmwwYTdvWi9saUNhMnlx?=
 =?utf-8?B?azFtUUpaOU5SWjg0aVVleTBYWWhqT0VKRGZJM2NtVzl4MGR0UTZ0YVBhRWtS?=
 =?utf-8?B?N2NORVVDM0ZMQlhPOXQ5Nm10RTBLNHUyeWdPbmN5U2FDL2FubjFocGJtNTFs?=
 =?utf-8?B?dHdFRktKM2JndytzSzhzVHh2Q1J3OUovMDJRdFJIKytLV0xyc3ViaGFzS0U1?=
 =?utf-8?B?bit1ZGsza0lvVnlKMU9zVnpvdlFFMjh3MkpHMUF4dnJCWkhNakM2RTVrMDZs?=
 =?utf-8?B?WHV5T2haVGtoREt4L1FhTDVlV0dWSXZldWpvZVpNUGpUSE92NENsZ1JsKzVO?=
 =?utf-8?B?ZTd5YXN6Q2grcFdNRGZXVkRPUHE2eGgxUGd6V1RhVnA0V2pyeFZ0OFFQa1RO?=
 =?utf-8?B?bDhSRk9DVnZwbGJSSEwrbHV1dHpVZmZ1RlFHM0dnaEhkZmZncVRScTAwQXVt?=
 =?utf-8?B?VHc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	8DtIQAhP0QedfbNcb7S6IJ+bDvVB5Mylb0PFZRvtwGKNbTxsf38xxjMn5Rb9u2HNGLOViwvQSEos56nNDQaQQrd8oGRQt7HraoqJEMEqjUO3c1G9zih7tSJ8Rb/dFMAmXfS+P286FPU7PX7Phuk8ZWjCHFENdC+kVEmZJ9EMj1P8yafwEshq3Qd4NRrJE5Q8dC1EEW4vHgbIroRjnNSlbOZeUjPbyLNH9HnnkHFp6J+t3OD6RsoDf1l9E5uiHzaPW99Qr5RWt71sXcuKz3g4c8EvuiVBY/16vc02pGZis1GeUWJAtHXblsJxTMZgQaQixg6T2aXUzMFVUVh3Vf0x9pCpEmL/WvW0zzGIYw4StocEwp1+TpgMo9bLEdqGz/H31FN/vvcTmpKBcrlrMIVYsj/7GM+xYRGmiRv1GbaCCWCY7S2886KajS0Uesl7d/1yudIJAbTMT5LP9ZqC7acVY75LooHoRIdqre1f2PKNcVYTG1TBW7ErUHfydnyZrcNrjMy0T+yaBTlWHjzoXrNpehp+5EIO0LfUCybFfHaC0CGyZcPA8hIuk1Ad6/VpuO0uq41jCIAvOg9yC57HVAvUNqxtkWT+oDvdiGTuMbU7tXA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 772cfd3c-f5ea-4257-bf9f-08dc5e694c07
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5009.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2024 23:02:32.0555
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OYsnT31Zo3EvKbmwg5ox247O5q7L7oblYsXfs+yOAx7B+fOgYgN4M7imEVfowC0gR7S915rgYN8iTGtznyEUc7suj29fGuWBmZIBsNGRqas=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4230
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-16_18,2024-04-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 mlxlogscore=999
 suspectscore=0 adultscore=0 phishscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2404160149
X-Proofpoint-ORIG-GUID: hc9_GJCjklrMhv5KP1RXzjRy8Egjv_rZ
X-Proofpoint-GUID: hc9_GJCjklrMhv5KP1RXzjRy8Egjv_rZ



On 4/16/24 6:14 PM, Sean Christopherson wrote:
> On Wed, Apr 17, 2024, Paolo Bonzini wrote:
>> On Tue, Apr 16, 2024 at 10:57 PM <boris.ostrovsky@oracle.com> wrote:
>>> On 4/16/24 4:53 PM, Paolo Bonzini wrote:
>>>> On 4/16/24 22:47, Boris Ostrovsky wrote:
>>>>> Keeping the SIPI pending avoids this scenario.
>>>>
>>>> This is incorrect - it's yet another ugly legacy facet of x86, but we
>>>> have to live with it.  SIPI is discarded because the code is supposed
>>>> to retry it if needed ("INIT-SIPI-SIPI").
>>>
>>> I couldn't find in the SDM/APM a definitive statement about whether SIPI
>>> is supposed to be dropped.
>>
>> I think the manual is pretty consistent that SIPIs are never latched,
>> they're only ever used in wait-for-SIPI state.
> 
> Ya, the "Interrupt Command Register (ICR)" section for "110 (Start-Up)" explicitly
> says it's software's responsibility to detect whether or not the SIPI was delivered,
> and to resend SIPI(s) if needed.
> 
>    IPIs sent with this delivery mode are not automatically retried if the source
>    APIC is unable to deliver it. It is up to the software to determine if the
>    SIPI was not successfully delivered and to reissue the SIPI if necessary.


Right, I saw that. I was hoping to see something about SIPI being 
dropped. IOW my question was what happens to a SIPI that was delivered 
to a processor in SMM and not what should I do if it wasn't.

-boris

