Return-Path: <kvm+bounces-40179-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 91F0AA50C55
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 21:14:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 03CC07A3A9C
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 20:13:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1958255E4D;
	Wed,  5 Mar 2025 20:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GPL3TaPV";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="o9r41laI"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1295251790
	for <kvm@vger.kernel.org>; Wed,  5 Mar 2025 20:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741205664; cv=fail; b=a9vimQ8elfusbxEg7erm7X7UD3meSm9vHxhhP6fa1/b8CCTBHi4C5xc5/ruLzTnNfP+Cc6gb2BR8tYi/EK1GXotwN5LzMm6ayLplrHslWKcMOkUTVt6n+a1l1zkenFScpFg9DT664wOANoHNV5hNBvQKtNa9HzsDUlIkmdhrd64=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741205664; c=relaxed/simple;
	bh=bhzKTilNSESzNYn7iPEYLswVvkpXHnb9igzuqhhmhQ0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=pNtTHegP3xt9+vjWS3l7jtxD86NIEeWKFkC3wl9tnIcFObBzuJJVbHC2X+1W8MLJsTVOGYOqfxUEUTG5mJVyFxb+tXlsJIOe/VkQ2kMw4ga8eDZMeCZBMwuH6AkGzdJ3fTCHyvcAfGGcsIHXitIN+uHZ0+dJusVXsgVXWD+frZ8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=GPL3TaPV; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=o9r41laI; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 525IMdrw014059;
	Wed, 5 Mar 2025 20:13:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=sYOG4MUlHR1DFN6DZtanVHFI0qPTbF//awLZChvOW4w=; b=
	GPL3TaPVyORvb9++W1Gi8pEIWsxpmDm47ZwKiWgOTH/WGSYVVsNgndUuL0Du/aQk
	9kEYdcLxElWrc8Ia2jCH8PkQUHUC5y5u3yNbjRxUEZvxx+sWy2/G2b/8UOqDwOhT
	7ec315amMZ+8kU2fFSUzlhNLXWyE2pnkKiFTLuMNpCZxEb9XR8EjnTRwQAHQow2o
	969Uro8cVuIJhUB+uIHEBGgKu3BAkM1OQFJM/abzFbRaSWt6PA1q9itjjUznjFfN
	m2iIQanIbdrgusVa/2ZevPA8bbytO2eH61/6AMXmFTJgeiBn1vb9GiLQJcqSVOAP
	Q2R5bXYoNYW2oM/p877FHQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 453u820mp9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Mar 2025 20:13:55 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 525JtM4j011011;
	Wed, 5 Mar 2025 20:13:54 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2042.outbound.protection.outlook.com [104.47.74.42])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 453rpcg42y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 05 Mar 2025 20:13:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KsdMKfGfhb1No4BKiyU+Y3I+llhPllAUNsGPJWxYGL17WXr25XSLNBNacfkgrREjgr1CMy8ZyDP1U14o0Sm5M1fn9wbcs2iWtf57g2vIwjE6iCF6IltG1Q4At5ZHXYSZyyx7DMGXJRsAZkud3p0LeGKH2dwn6pbD+u4jj0yP+qZ9sTY/RxWFfHLYqL+UnfiMwVuGRgQXZUlON0yNO8+e4eGTT1nJOtsmRWOIeGXOSEjEc9AKI5yPySjayZet1lXfebVa2VxdLTSPIBxdMVNEnNaJRB8QsNsftUQbmyu/B/rBKiakw1dNHjfvJpYi1LdzCGSqKVFMMya0l3F1mon9wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sYOG4MUlHR1DFN6DZtanVHFI0qPTbF//awLZChvOW4w=;
 b=tz01DYac6G6D+j/uGmrWOzIHpluySTfOKaAtSIV8X2cyhitGLxcd858VkdKJUnKrrD+YsH6HyU/j/PHx+OuizAOS4grbeKQetAh9gqalpReccMB6+A2wDWFPpklxvmM4g/GRliTpbouRkRqbovvtMsFCO8Te7U1lOVyxUJg4DEe0rern9cLsVhxg2brv1780jojURClNK5+ZLXVQvy9vc+WgOTjuBji6IgV69/wvbCyBcm6Daa8IZVt7d4iJaQ0wW2JsKTgh12Vlm8M7lUy4fNhpQ7BC3XRW2yu7zvaky0vuruXI5XlnEqwlGJZUvKJrzBKPy6ZzQcEX271R2XH24w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sYOG4MUlHR1DFN6DZtanVHFI0qPTbF//awLZChvOW4w=;
 b=o9r41laIjpo596zmmmAWrwUk26wVaa+CXSL41gH5Aj1f1OrD6UvpdQLo7cKOAGD5tAbU7WPW0/WDWjTiQtsuorc+DxNg4BYIH9FZny9j10vyhjHwF0MlZIPbf6CFFxOqNsuEFcY8qmPZCI5sIkMVM3WR05X6Ss33cV+xcycJ65k=
Received: from BN6PR1001MB2068.namprd10.prod.outlook.com
 (2603:10b6:405:2b::35) by LV8PR10MB7941.namprd10.prod.outlook.com
 (2603:10b6:408:1fc::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.28; Wed, 5 Mar
 2025 20:13:52 +0000
Received: from BN6PR1001MB2068.namprd10.prod.outlook.com
 ([fe80::c9b4:7351:3a7d:942f]) by BN6PR1001MB2068.namprd10.prod.outlook.com
 ([fe80::c9b4:7351:3a7d:942f%4]) with mapi id 15.20.8511.017; Wed, 5 Mar 2025
 20:13:52 +0000
Message-ID: <dacd2c79-346f-4e95-b24e-2f9b9a6e4f8c@oracle.com>
Date: Wed, 5 Mar 2025 12:13:49 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 04/10] target/i386/kvm: set KVM_PMU_CAP_DISABLE if
 "-pmu" is configured
To: Zhao Liu <zhao1.liu@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, pbonzini@redhat.com,
        mtosatti@redhat.com, sandipan.das@amd.com, babu.moger@amd.com,
        likexu@tencent.com, like.xu.linux@gmail.com, zhenyuw@linux.intel.com,
        groug@kaod.org, khorenko@virtuozzo.com, alexander.ivanov@virtuozzo.com,
        den@virtuozzo.com, davydov-max@yandex-team.ru,
        dapeng1.mi@linux.intel.com, joe.jin@oracle.com
References: <20250302220112.17653-1-dongli.zhang@oracle.com>
 <20250302220112.17653-5-dongli.zhang@oracle.com>
 <76da2b4a-2dc4-417c-91bc-ad29e08c8ba0@intel.com> <Z8hiqwz4ExgWfRFR@intel.com>
Content-Language: en-US
From: dongli.zhang@oracle.com
In-Reply-To: <Z8hiqwz4ExgWfRFR@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR02CA0027.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::40) To BN6PR1001MB2068.namprd10.prod.outlook.com
 (2603:10b6:405:2b::35)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN6PR1001MB2068:EE_|LV8PR10MB7941:EE_
X-MS-Office365-Filtering-Correlation-Id: ca3e57aa-8e93-44a5-f9e3-08dd5c223f65
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ay8vNHNTZUVqVElENmE4aFpYNlZNQlAvMGxqdXNhODNqTjI2ekM0NVh6UnJU?=
 =?utf-8?B?MnJTUWloUHZQeTAzT0FaUTIrNFNnOVZ1TG5DZCtLbFFMaVVMTXQ4OG5pRUJz?=
 =?utf-8?B?VE4wRlViMnJTQ1MrWFQxWGUySnhNNjYxMFVOdWFCbldINmprZ1V0TWxaOHJD?=
 =?utf-8?B?Q2pNLzJpUG1kOTNPcVZnQm9jZXJobzlLYU4wZHdPUU5iZW5oN2xYRFNWS00w?=
 =?utf-8?B?bEx4SmdKcG5ORlFzUXI2YktPQW9qS1ROSGxFd2xJeDhZd2ZvdjhtcHZmOHVO?=
 =?utf-8?B?SUNtL3phcGozSWJjbWZvcUZaU1orRE42Mi9aSFkxRFBsZnA3ZkJWSUlQNXJW?=
 =?utf-8?B?ei9VUHpobkJSWEN5aVhteXlLOFFXaGVtc3FZbzJlZWxRd2gyYURaMzRoU1hr?=
 =?utf-8?B?cGd6SUIxOWhhYytiZmswc1NGcjEraXIveUpSWW5ZVkpNU3lydE1vN05LYXkx?=
 =?utf-8?B?U3pGRXpxckJ5aUVYS2h2dVZaRnFXc2pMaGZma2VYRnp3OGFZak56dlltWjJZ?=
 =?utf-8?B?WjA4WVd3dythcDVhQkZKL1hOb1g1UDFQaE5HQXZMMUVpdjFHN3Vma1BGUDVC?=
 =?utf-8?B?VTNHYVplcFV5YVV2cWZOcTkra21HWW9RWGQrTW1FWU1ySmFCTmxiaTJ1Vm1M?=
 =?utf-8?B?UkdqeTJXbk8vSlR0b3RZTEZQRGlIcXQvZ0MwdEMyU3ZRYjRRYzFudmxhclVu?=
 =?utf-8?B?eXpxVGxZZ2VTdVprbXNiR1pkZTVueG4vNjVyZjJxaGdJam9hNUMrUCs0TkxD?=
 =?utf-8?B?bStnYVlleUQxcGxLUkYyTUR4S2RRYkxLMDFqU3pWZ0crREpaQnBrZFlXMjB6?=
 =?utf-8?B?VFV4M0JXTGlCNWk2VklIQS96WTdNR0VMOUZNbjdYQitmMlJBK3kyWEtNRFpS?=
 =?utf-8?B?QjkyVEtXbWRWTUZ5bFBnekhlMmZQNGdjOVlxdjJaOU43cEd4d3lKbUgxOGRn?=
 =?utf-8?B?QU5WdDdmRytEMjg4ZTFTQWxrNzBnL2JXYTJxZ1B1Z1Q3ZU9sR2RackdCQWFO?=
 =?utf-8?B?SDRSaVBhdGwybm56M3J4UEZqOFgwcXZRN2cxbE0xMk45eVpncUNoK0hwTWhW?=
 =?utf-8?B?Z2IyR1UxdVdyMUMrVDJsNjhLbW1yNnlsMEZ6ZWZCVjFWSlNLRThnWEpQTGhZ?=
 =?utf-8?B?SG9PRHV2azJHUHF6eFZEbFFHaW1FMlZqbEdTcWdjSXNKQ29TbGFXNWpWOWtX?=
 =?utf-8?B?UTMwUGkrRVJManExQW5ORGNqVzd6Vkk5K2V5aXl6ajJYZEc5SUlNc21zeWUz?=
 =?utf-8?B?dW5MWlgza0xjbGVscm1Pekc3ZVloY1FRWHcyd3RQY21nOGRubSt0b1FXTGNI?=
 =?utf-8?B?MzUyVmF3NW9nSnd3WWl1RzhiK2t1KzVhcVYvNnBWMGFJb2ZmOHBSYWo3bVFQ?=
 =?utf-8?B?SkxnTlhZcUthZDZCdUprSUlFNE9nQkw5U3JxY1FHQ2JZSnVOYTJBMzJ4QWJV?=
 =?utf-8?B?djNuWlRoQms5aTFhOW1odnpOQmkzL2tDRFJiKzVIbmtXSjQveSsrUGxKbHJI?=
 =?utf-8?B?L2dLc2tiMGp6TTZPOG9CYWVkN0U4djlHV1VLbDVMZWNiTXU4Vm1nM1hncG4r?=
 =?utf-8?B?OUFZeU96aDFvdzE1aWlHV1FjbHdHU2VDVXhGcVJHSlBRV3RCZCttelF2aWha?=
 =?utf-8?B?d0IvQ1o5aHF4aDV5MjI4eHhVcEM0Qkc5aW9DN3k4WVNYd2tlL3EzY3lwbys2?=
 =?utf-8?B?L2FSZWFHMllUYVN2eXA5eG9JTFpTaEtvUUZwWnNGR2F6eXd2aGdHTFZTdjBr?=
 =?utf-8?B?M3loV0l4UGtiLytURDVRR2lnQXFjVmZ1emxqMlg4VUhoOVhSc29QM0dLdWlZ?=
 =?utf-8?B?S0QvM0dGNFVsWVdtbkpkeE9vU1F5dHdGTlVtTThET09VdVI4c2JsT0xjazNF?=
 =?utf-8?Q?bmJx/jhQ05TrV?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR1001MB2068.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?R1JnQno5K0RIVi8xRGRuYVdZZ0hNTTNwNDdjR2V2Vzh5b3RZNm0ybVAvNTFj?=
 =?utf-8?B?anUrNmZCbDUxR0JTS3ZBcEJkbU9qMlZRVHB1YTRpaWRHUkZsWlF6SkdlS01h?=
 =?utf-8?B?YUJ4VFpCLzVCclVBVmtXY2ZmOE1mZCtnUG5tWlRkeHZmMVFOT0lrUlNDN0Zi?=
 =?utf-8?B?eml4OWV0UHRHUzM4dFNtNWMwbWJrWE9hTzZETng1eWJjZHEvZHVHT1dZSDIr?=
 =?utf-8?B?d3Rvc0ZpQkFIb2pGTzdHYTk2Y1Fwck1ReS8xSUtFWUlXOXc4eHAwdW8xaU1k?=
 =?utf-8?B?dGxjQ2x1UnBHMDNlV0J4anViYkhVSGhHU3YvVHpNQUcxbVVIdlN0bXJKMkJa?=
 =?utf-8?B?Qkw3Y2Rjei8yZ000VW44TThzWFJJWHVQNUF6dEM0bnQ2enphS3l3VHVnTUZI?=
 =?utf-8?B?K2E3OXUyWkFmR3dqdE5EMkExSVAxV1Q4Y1hnK1FEMUUwYU1QQ05lWkNCNWs0?=
 =?utf-8?B?L2VnYkJIZXdYK20xYXFqWnI1SzZwcC8rdDAwOEQ1YU44REE5Wnk3SmlNU2x3?=
 =?utf-8?B?eWJtOWlNZUlpY3ZUQUdFZ0ZLdnkwdUFISXdVTytjeVVMU0ExU3dBVWw1UkV2?=
 =?utf-8?B?eDBKTm04THpzNzZaSFlJTVFFc0FSbmpsNWhUY0VOa0NyakYrd0wyZkxiSkc2?=
 =?utf-8?B?dEd6QTMwUUppNG9iZHMrREJWazJYWmEyZHhhMU56dUZLdGVHV3lJSVpaTmdh?=
 =?utf-8?B?eWFHM0RLb2ZBOHdodUxCVFhrUUI5R21YSVR2QTg0QU9lWWpBbm42TmJjSnNB?=
 =?utf-8?B?eW1lazJKL1JrN29VUEJLdjEzM084NEgvbVg2U09yL25Ecncyd0ZyNDh4emxk?=
 =?utf-8?B?Y1VacFpRRW01MCtjKzh5Q1dwM29SblpxQmp0WDNxZGhWUmlqT2RPNnpJbFg2?=
 =?utf-8?B?VGcrZndRVUxqWFgxMkNGK2F1RjY4SXVicDNlRCtRR3owN2lDNXRxNkpxSHoy?=
 =?utf-8?B?RFM3T1hnL25zSU1RM3FiK0Y1UXB4SVc0TUJOcHRybHdicnU5QUFaRDhscnVh?=
 =?utf-8?B?SWQrOEJyUmFIM0pkenZmT1FNYzB0NnpGQ0RaMHJrOUVCeHVVVkJEbkJCV0F5?=
 =?utf-8?B?VGZKY0tZa2xGVVhFRUowaE5POFY1bVY3MUNqeGNDYmhncWVLTzU3emxnUXBh?=
 =?utf-8?B?c0J6MW41NkVJZVlWVldxTnRmZ2dTUUcvRzVsK1dha0JHQlZVVlhkaG9QZ2hw?=
 =?utf-8?B?TUJMUmxmc29lK1lMZnc0ekIyb2FTRnNlZFlCSlY2WmVNNFVHU1R4ZkVFWTJJ?=
 =?utf-8?B?OVE4R0E5NFpDSEhvVDd6Ui9EbWpGOSs4SDJwN0tXMi9zcEtMc1Rqb0RyR3Bz?=
 =?utf-8?B?RXVnK1NDV1V3M0Q3U3Y3YTRBRENIVW1vNlpNZTBKTm44bWhObEdYR3hwV2pn?=
 =?utf-8?B?NEVkOU1wMFI2eFROQ2ZTT2lhc0pKQ09GajNiL0E2ZW5XZDlrVWZRQktaNUht?=
 =?utf-8?B?TE9FZ3p6aGxZVHl3Umh0eTlxbVB4WkNSejlrK2JUQzYxM002M2hRMmQwdFNJ?=
 =?utf-8?B?UVJzdm5XQmxma3VMNUVkUndmOWppMHZvWWhWZ2d2c1N1SHJWNnp3T3ZpT2RE?=
 =?utf-8?B?UHpuOW9SS1Y5dDJIV25UaGcvU1ZkUFRwVURVNVNJaG1Qd1g0ZUVJTDl2TEdJ?=
 =?utf-8?B?N0xxVC9ib2xsRnBVWHhFQ0p6aVVFOUpnTXFoSjg3NjNEbGF6c05CWnJqcm5L?=
 =?utf-8?B?TkxQb2FRODFHODNyRC9veEM3WjcySDZtS2E0cDdJTUhGM1VNV1FEeTloTXhj?=
 =?utf-8?B?cU03MklTVytPUWJOYjcyOExhaXpGZkFHS04rQ2dZVTZacEhYRWxMSjRPR0ZP?=
 =?utf-8?B?MjdLNVlJWGpvSkhQS1NvR2pXeUxtLzZGbllpZEYvWThaRWNpQWVvcGk0dnFV?=
 =?utf-8?B?Ulpmb0Jzc3NmT21GaGxYcTZ6L1Q3TnozWkNweFpBUU1ramc4Ly9LV0FqcVNa?=
 =?utf-8?B?Mlc4M1lXWjVwQjdhZ0plZmp4OHhGSTRjRGQ0M1BWOUJqRFlXeG01aUxYdGtu?=
 =?utf-8?B?dGhiTUhkQjJheHdrc04relVibzdMcWpyMFI1Q1gwM1g3Vm1vWExYV2ZpVUhU?=
 =?utf-8?B?dHpQREN4MVVYRkRaMUdYdzZ2ZkhiY05KY2dGbFVMNjg1aUFEaEQ4T0VrZ1F2?=
 =?utf-8?Q?xLQWHurpVExJXPhoEFFYF8v9k?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hwtySzk7c2ENYGnH1LmQ8w0H4L3bLF9+oAqMtt9eG7GBdNbLJeFVsIpzPOZkZwMtg9Dc/EDZh0Bat7S+U3mqXHue/FGV2Hyf9jxEfUea+0/iqEfFS+ws05+Cjrfr2yOnrVl4okH39bCzPwiyyitrhAYofijXMQw9MOuyqJydw34IF1FY58aHNM4TFycUioS6QRMpl7un1quRCjcBapGGVWng/vC05vAWsBTDgZA8hehxR5hBSxx07CpxelTQR2anMGLpPIsQmH5hI9Ly6zYdUWsqkqOGdc5x9yRA3P3BDAUxJTXuZeMhA5XL9wLkH7lZIOu/aNhcWmCGannrawwDO8b/V3J/4ImWK49bz760ZB+FnlsbKJdoo6ExkyryO76TjrECi9yN/mu9YM3GGpWN9eMLRnAwujlDslSSqH4o+5nnEfU/s7eB+7FrSblLtJHbVBtIKECKBWyQjDrgqGQBGmjmNErqnWq1fVE/qeGxQSzRPMlkCvj5Q/l9pbl4Cb5U9Vb8qdOfQ7YT/4V9rJQi2Vm2Ky1dNXGyJK7GxlUC3qhmYQUoQnRNg5/ja/Fk3sJWdD40HUlOuATq+zfP1U4d04rylhuaWIQe4BVLkDStcVk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca3e57aa-8e93-44a5-f9e3-08dd5c223f65
X-MS-Exchange-CrossTenant-AuthSource: BN6PR1001MB2068.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2025 20:13:52.1277
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uY2jwDJQXgB9N480Fk0FZwxtQdvmo8sg+KHJayPYCmA6ZJI2Ao15KJLOFaXK6v09AAsveTzO0zjVxXWlIpXyEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7941
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-05_08,2025-03-05_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=935 adultscore=0 mlxscore=0
 spamscore=0 bulkscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2503050154
X-Proofpoint-GUID: 4geSL9jxJnpDWqmE-ui_ylVZd8dDxbTf
X-Proofpoint-ORIG-GUID: 4geSL9jxJnpDWqmE-ui_ylVZd8dDxbTf

Hi Xiaoyao and Zhao,

On 3/5/25 6:41 AM, Zhao Liu wrote:
>>> +        if (has_pmu_cap && !X86_CPU(cpu)->enable_pmu) {
>>
>> One nit, it's safer to use
>>
>> 	(has_pmu_cap & KVM_PMU_CAP_DISABLE) && !X86_CPU(cpu)->enable_pmu
>>
>> Maybe we can rename has_pmu_cap to pmu_cap as well.
> 
> Yes, I agree.
> 

Thanks both of you very much!

I also need to modify PATCH 08/10 where has_pmu_cap is used.

[PATCH v2 08/10] target/i386/kvm: reset AMD PMU registers during VM reset

Dongli Zhang


