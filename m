Return-Path: <kvm+bounces-42262-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 19E63A76D70
	for <lists+kvm@lfdr.de>; Mon, 31 Mar 2025 21:17:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B441C16B062
	for <lists+kvm@lfdr.de>; Mon, 31 Mar 2025 19:17:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CA02214202;
	Mon, 31 Mar 2025 19:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RHd7WYvE";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="uXF5KNOR"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C1A015E97
	for <kvm@vger.kernel.org>; Mon, 31 Mar 2025 19:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743448642; cv=fail; b=WSm4HBgpGBNec0eGby7j9t14LYTkui1z5ttxXiRzqeIG+kLtgvZRDVZyIOJCiMfkP0aU5U+Eg5Ks7wowediO4aD/oG2t8cLGM0Yzz+sKKd2OEKlo1Z+7PkXnKJ7/rrAXlq4KRZCVKN3v4v2iJMoDqip5AOStZtPH5ne8HeYwjf0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743448642; c=relaxed/simple;
	bh=NGfBHiBQpD5TZOVPDYE2Wkh11g1/KZT3N/38lQG8t9s=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Zy14kL0q7RxyqQzkRe8GZTtag/VnS1VW8VJqkVy51BhWuZiDTvUElapbgLGHhN8+NPrALHot4xh6W8U/5j8HPsaFqUWYznLaPhygxDeHJOHP6HF46HinSG7aUCw2wn16+/kSDZu1n8tSu7Cm8wuYdC3kgY33dLDNWlsHrlgwq6w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RHd7WYvE; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=uXF5KNOR; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52VIPaI5000347;
	Mon, 31 Mar 2025 19:16:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=1LLWESXYXPwcEww0Z9aW2zM/sQ6N7mMwRREUwuCDf48=; b=
	RHd7WYvECISmkD4Ol/SsfskmcOT0fuL8tcUxXpxxbhlj7um9FPxzORhZ2rqGex83
	bX5k6qtA8/MY62LEL6L/8MsRssoHkFD9FdRhZqMjQBPIedzLi8xjzEiCw5HQmCPa
	Y+RySU34ptQRlYgYghfhYDsZ+D0GC3gmHGG4c1w5eCQALoFdE21YL9A6Ukm0vKhz
	rk2Wl+eWEd9zkHki1woVofgOq9K3YXSTElBnfC/p68QfrsjKqyykAaxiNm9ece1w
	vQF1gEH66fqViTPY1ewjCb3vpKklwD84r4izKGMHwrukSq2V0MoDmPAabNEVOu5y
	ZqK2m1pNxvFYkFn97fiH3Q==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45p7saky42-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 31 Mar 2025 19:16:54 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52VIFtgg010718;
	Mon, 31 Mar 2025 19:16:52 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2049.outbound.protection.outlook.com [104.47.70.49])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45p7aeah3w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 31 Mar 2025 19:16:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OaXrcmKHk20hIpsm98DeHyGmEaC5QD7WgTIeoEqEwA7MB3jazRHnQzhnUPgmFl/6AgOSYr4n7uaCFCdkSrbP1/uE8GFQQXgMjvhkj5hDXJC6fTIhTYBdLwvYPa0WNbnHGTNQ9evBxR38FzyNg8usQoL3/NsVdTpOdNb73f6OCPqC3YqumWL1QPiOWAo5rNfFsEpcpBiXeuXrvXMyk6ZG6fI+chAnOzjF9peP2NpceWjreeyu7zlTqrFMpzUPbFePqsese1QVvFO9g80kY/ajNOS7Yk1abXOHDFqx7QZXsXJxcKGANNNITtvFPVQcHF22rzIhDEnmTdUSrRX7iJpXAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1LLWESXYXPwcEww0Z9aW2zM/sQ6N7mMwRREUwuCDf48=;
 b=l35H5I75euworIGBQ1MfddVkarp2tV1lCc9E5ibqWNwgTpMQzsceFDm921N345MZk3Bbw6sZxmPfy6N6DuxCtjPIObkrx8ndEeVTyucu+kURDjob31cnlwpnyDmOYplJhX/kSup/Yf8b/oQnNOfextmb99hzFTlgZEhUe1fQ57fFFxTT0PicDBdO6eYsoJlKtJ/6lVLM/h7ZduIuWvU95SZaoLMkuRqAoqnphs36FXRfh0MfSjHdIox8Q1BFLvc6pnO82Rf1n4pNfjD1FEF5nSuB3y4Dr0ytn4FDn3C4XRFBPUutT6s5bbHSRLrYvot/GROt53LgktXW55IZ/mxH7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1LLWESXYXPwcEww0Z9aW2zM/sQ6N7mMwRREUwuCDf48=;
 b=uXF5KNORO1x0yWPK7ATnGbXVwszKLjmPgq7CdPXsAEpzcvzzSFhpyv8/EGpVaAnTrBH/jWmU80BwVqLZixaPVP2zDlZ9dPr9K0cz0rki8xRbpyXi7jhihh/WKbFzUnlNX97x8I+lLSglbTBk1caZrz4YN8vEfD3LJQ7EuH8kZ6I=
Received: from DS7PR10MB7129.namprd10.prod.outlook.com (2603:10b6:8:e6::5) by
 CO6PR10MB5602.namprd10.prod.outlook.com (2603:10b6:303:149::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.42; Mon, 31 Mar
 2025 19:16:49 +0000
Received: from DS7PR10MB7129.namprd10.prod.outlook.com
 ([fe80::721c:7e49:d8c5:799c]) by DS7PR10MB7129.namprd10.prod.outlook.com
 ([fe80::721c:7e49:d8c5:799c%5]) with mapi id 15.20.8583.033; Mon, 31 Mar 2025
 19:16:49 +0000
Message-ID: <a94487ab-b06d-4df4-92d8-feceeeaf5ec3@oracle.com>
Date: Mon, 31 Mar 2025 12:16:47 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/10] target/i386/kvm: reset AMD PMU registers during
 VM reset
To: ewanhai <ewanhai-oc@zhaoxin.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Cc: pbonzini@redhat.com, mtosatti@redhat.com, sandipan.das@amd.com,
        babu.moger@amd.com, likexu@tencent.com, like.xu.linux@gmail.com,
        zhenyuw@linux.intel.com, groug@kaod.org, khorenko@virtuozzo.com,
        alexander.ivanov@virtuozzo.com, den@virtuozzo.com,
        davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
        dapeng1.mi@linux.intel.com, joe.jin@oracle.com, ewanhai@zhaoxin.com,
        cobechen@zhaoxin.com, louisqi@zhaoxin.com, liamni@zhaoxin.com,
        frankzhu@zhaoxin.com, silviazhao@zhaoxin.com, zhao1.liu@intel.com
References: <20250302220112.17653-1-dongli.zhang@oracle.com>
 <20250302220112.17653-9-dongli.zhang@oracle.com>
 <8a547bf5-bdd4-4a49-883a-02b4aa0cc92c@zhaoxin.com>
 <84653627-3a20-44fd-8955-a19264bd2348@oracle.com>
 <e3a64575-ab1f-4b6f-a91d-37a862715742@zhaoxin.com>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <e3a64575-ab1f-4b6f-a91d-37a862715742@zhaoxin.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR10CA0009.namprd10.prod.outlook.com
 (2603:10b6:a03:255::14) To DS7PR10MB7129.namprd10.prod.outlook.com
 (2603:10b6:8:e6::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB7129:EE_|CO6PR10MB5602:EE_
X-MS-Office365-Filtering-Correlation-Id: dcff8b4d-7233-4b34-2fb5-08dd70889637
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?c0VVSFB3UTU0a01KSlRoZ3p2aVlRMitab01NajBCZzJBWmwvRm5xSjlDVElX?=
 =?utf-8?B?ZlVydmtVR2ZRQzhwNlVZa2JvSmJEY0NNWnV2ZDhKUHJjOVY4djQzVTNKbzJo?=
 =?utf-8?B?MmlZNENZMUdYL1p4R2taWVd2bEwrWjU5RFdUN2NkeW4zUWwrRHhPNm1TQlYv?=
 =?utf-8?B?WkZTVS9HOUZQRi9zWklDR3ZQalkveTlyMFFYeXhZMHF1NTkzYU4wM01DZ1ZX?=
 =?utf-8?B?YitpdDVCSkJLcG1vcTNHRWVvZGRrRDREalY3YXRpNzEvRm1scnVheTJxcFZ6?=
 =?utf-8?B?UlFJWEowd2Z2NEVJL1hMSEgwYkJIbHBPN3ZBckp4ZTNHZlVMdnd6VHBES3RT?=
 =?utf-8?B?M0d1OEc0ZW40TVo0R0ovYW5DdmNoOEtQSUhJU3dKSzVDNGd1c0NiL1ZYc2pH?=
 =?utf-8?B?MWRkNkQ5Z0s5Ny90RGVTd3c2QlZkUEJsUnZ5VWVBUjRFS3pvaVpQekY3eGxJ?=
 =?utf-8?B?VFovS1NYQjBQdFlOcWdiMXFqUVdwRXJTbFJ2ajBlS0RTV1k2M3JPbENXbTd4?=
 =?utf-8?B?TU9vL1R6eFhMZmpHNWlMeDV4VWhLSUJJWXZnWTRTOXZBdDVhdjVNMnMybVF2?=
 =?utf-8?B?RDdLeGszQzZUSjdUdWQvdVZKNm4vKy8xeU9XYjRQNmgrUjlvQmo2MjRJem4y?=
 =?utf-8?B?SHdtdC80KzhCT1hqS1JsMmk2SXJRUFFCcWMyR3g1RE5TTFNWRDRONTgxcmVx?=
 =?utf-8?B?R2k0ZCt3NFZYVjhYTjlQL215YlBMVklqUXJ6ZGRvM0hCaVgwcFN1dFJsL3h2?=
 =?utf-8?B?U3M3OThORUE0SVB2WVRDWmRrV2Q4OE5pTVNnK1UzTm5aVTR6WWJqVFIyRWxt?=
 =?utf-8?B?RjZaZUF5WDRDTG51YkFtYlJEYXdmZFpUaFJVeU1WVWpGcnJEU0F1QVIvWUVW?=
 =?utf-8?B?cW9MazNubWJWSElqOW03VmtJWU1iT1N3bndrZGFVNlZBTGdvaXR4eCtkaDU5?=
 =?utf-8?B?azAzQTRjc2VmVnhtbldZdHZMS1ZUTW8xRzhzbUx1RldRdFE1U2N1YlJQQXh0?=
 =?utf-8?B?WHVqNVoyS3VEMmFHeHRKLzJpK1hoTW5XVi8rN1R2L29DZElqeTlQYjBaWmFs?=
 =?utf-8?B?NnkyeGE1T3ordGNXYTFYWFBXUnhxbEFvQ3ZYM0V6MlduRjdkcUpFaGFBSkJJ?=
 =?utf-8?B?ZUxhVXJ1SWR2OGNrVW1ZeTFEbWxnekxDQzVoYnFaeGNZU3hqL0Z0ZlcrK0RT?=
 =?utf-8?B?eDNyc1p0L24wbGVRcU85QjB0TnJUNk0yVmxGSlYyc2FETGZLd3ZNYmJBblB4?=
 =?utf-8?B?SzNjeWdrWGVPZFNXQm13ODhnU1ZNYkxxN2ZROU9wYVRpaU5GdjVvZVkxYjBR?=
 =?utf-8?B?MHRjYmZvSnVHSDdiYzRSNzJna1lnMjh4Y0kzYmplYXA0UmxHR0FpZ0pzWUF0?=
 =?utf-8?B?M1cwYnJRUHVnVXlVV1QzOWJMOE5iNktXMmt5YVBMZnhtQXFxeXdTU0JGSHln?=
 =?utf-8?B?LzBVem9Cc3NTVUU0L2Yxc2dta1VKUkFaRkxvcVNzTzNIR2JXbVdoOGdvQyto?=
 =?utf-8?B?Q3hIYnBaWUNNZTVqS01ZYjBOYlQ5U2J0V0NBU2FrQ0NyYUZSWVIxL2VwL0Vu?=
 =?utf-8?B?ZTdtU1VWU0tWc3JKUDdiZ2Jwcjl4amIzdFZNb0pGL051Z0tHNy9mai9RcXVn?=
 =?utf-8?B?OXpod1kwVTF5Nzh2NkRZUWQxeWlxTlNIUWZDaEt2OEZWbmlzRUhML3c2dDBR?=
 =?utf-8?B?RWxVZGNjTG1OMUhyVE85czltdmhnaG9SMWNWdFhGK3U4WXB0bWFyOWkvc3pV?=
 =?utf-8?B?Z3Y2NFN0RlJNZU1kbmthcGkzZmZBd2ZYTUxDeTJMdm9wZHJBRlNkQzgrdHIz?=
 =?utf-8?B?enVLeXRXeEdLUVR2SWhvbGo5dnJmbHQ3cjJqMkJvWmFLMEdGaURqcXlsakdH?=
 =?utf-8?Q?cYWZoFLanHLqD?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB7129.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bHlDeVUvT01YQ1drbWZpLzFSakIzaVdtUVkrd2RMV2JsWG1nK29xMDlzdk1y?=
 =?utf-8?B?UE56ZWtpQU1mZWxId01yamd1MDVKZktYaDFuZ1FOOG1leVdxdEx2R3BhRGNM?=
 =?utf-8?B?UElWSkVXQXdaSGdKM3RKVUJydGtZeU1oeUVJVTZvdjl1M3hmb1A4eS81Nko4?=
 =?utf-8?B?akxVaGEzZEx0SW5uRW1qZk1ZbEY4Wkc2bURIb3N0K2t5UGdHekwzQnR5VkJl?=
 =?utf-8?B?d2JxOG5jZTVqbmhiMUp0bDBOczY5Z0dCZ3c3MkQ0TkRrdDZwWGhTZ1Qxdjd1?=
 =?utf-8?B?N2I5MnpxL2VIZXVBL2kxVzBRS3pteCs3cnpsRFJHRm0rVk04ZTRSYVJubStW?=
 =?utf-8?B?R3BqMEEvZjZmK0gyRnlvemtQTlF2QUlkZVVTM2QyNXBkWW1IUUtOVWdQRnlV?=
 =?utf-8?B?SDF1V2dVaDdwRS9IQXNSY3pYT1Z0cmdtempXRmxqQTd4VmdzcDNQTG5XOEhR?=
 =?utf-8?B?TEJBM0xHYUNUdzRWK3BYdUEwMi9wZ1VGenpvM1dZdUNWTHdydm5LamRBQkZr?=
 =?utf-8?B?WnpNRG1peFBYTjhjWXRRbDFXN1JiWnk1bWhXdzNlZTQ3TENQNi9MY0Y2UWd6?=
 =?utf-8?B?SUovcGN1WlphTUJ1bDhlY3VnSVFJMnRtQk5SaGE5dVIyWFlIVkNQcll0VmNR?=
 =?utf-8?B?U0hOMS9ockpDalFMdTNwbTF1Z1N2R3hybEtxT1FhK2d6Zjd1dVNpOXd6VFBX?=
 =?utf-8?B?NE80aURYSGRONTljcTFJUHhaOXRNMmppZ2JwTWF1bzRYZFcvUlNxKzV5ZEM2?=
 =?utf-8?B?TGs2cXdpM2phT0J4eWRFOEdKNjduQkYyNkhRWlJZSDBzT3Q0RGhadVYzWVkw?=
 =?utf-8?B?aU1iOVRxMTFRUlR5STViVEVEU3VBbFNKam5oSEYyTFFTMzNzRHZiQ3Q3Vlk5?=
 =?utf-8?B?MUM2ZEhpRTcwdnVaQTI5NXNiR0szMFVhWWJ5TVB5V2ZibEVDTVJ3Nll1aStI?=
 =?utf-8?B?K24vQUNhRERrSzRjTzhjZkxBdjRtZVhBVnF2b3U4dWl6bGxHTW9RYTNtVEk2?=
 =?utf-8?B?QTR3Q2hCOTlLTXYzR2QzVVpQdzBjWDJCVlEzNTU2OG5xbU1aL1pYcmhyOERO?=
 =?utf-8?B?UE9hOGQ0VWNERXcvQkpDMGNqL04wOGVnRlJvbmF1VWhkM01XL2RZdlNSaExU?=
 =?utf-8?B?M3c3UUpXMzh3VlRyTXpPZ0UrR2xzS3NBWFg0bGtMN1NxUVRJN0YxOXBEdE8x?=
 =?utf-8?B?bUw5K0tHSTZkTENCcUFGUWtSRjZZS0ZnTDZJUXVPUXUrdm1xWENqY3NXWDJE?=
 =?utf-8?B?NjU4RXJnQWFPWjYwMnk5Q0dlUkZIeS9TcGxvaUI2UVZ3Rlo2aUZqRXBrb21Z?=
 =?utf-8?B?TlpEOEpOWWtUWHF3WVRubWlzVG5EaFZCZmlhYlQvYkMvcllMS1M0OVhjeFBH?=
 =?utf-8?B?MDY3bjIvZ09ZMjhNRWxrV0xpdWUxRzRRc1JOZTRGSjFGbTd5WUUrSmJ0QkI3?=
 =?utf-8?B?OXpPQmFsdEE4U0JxNm5ISmlZci80b2JrOHdCS0FjbTM1Y29xK2R3aFhuandI?=
 =?utf-8?B?OTYwRUJlazVOOGFteCtMbEhqdGc0TXhWYS9VclhsWDRtK21GSEFRa0lCdjU4?=
 =?utf-8?B?bUpyWWdvNGdUMmw0VUprQk1GZDNRS3FyTjUwR24rVVlacWh3ZzUreUVEclI2?=
 =?utf-8?B?d1NvNnY4TVRZQUtLNE5oc3Q2K3NCbmZRWWtmR3JQWnZGa2hQNXVKWkY3RFJp?=
 =?utf-8?B?UGlPQzR4YXlqV1JJd1k2Mnl0QlFBY0gvRy9NbXo2MTdyMXdCVHIrNmg3cUNl?=
 =?utf-8?B?c2prR2RqdTB1NC9UYzdvUEJuTkx5bW5wMDRCZC9FODhWekFoMWJBU2VDMTJY?=
 =?utf-8?B?Rk8xSnlXT0NvVTNyRHcrU3R0RFF0R28xUlUySnJpZEh6RDFWbVZuR3Z2MEpy?=
 =?utf-8?B?dTdkdlhJNkRqRnFzN0gyS3VGK3h4dzYwYjRLa1lTQzUrU1R3NzZsVWkyaHJL?=
 =?utf-8?B?alM4Z0pLYkdTNTVqZjJSdm5OY3pPTDNmUHl4WjVXeWlEeDRFdHZHaFRDdWRR?=
 =?utf-8?B?bjFUeUxKTjNZcDZrWVBtNGRqRENRbVlDU2dQVG5NcDNwcDVTTTZXWmhBRDhh?=
 =?utf-8?B?bDZJd2RDeERNaUVha2tlLy9xMFk0S3FkRHo0T1pYaE85M3p6eTduV1hMcVdz?=
 =?utf-8?B?Ry8wbEs1TzB5aWRZOTNyZFdIdjNXM1c2Z09idHpHOGdWejNFUmd2a2llUXFO?=
 =?utf-8?B?R0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	o9g6L4pbWPOcbO9hcU9p/Eif8jaldIFMA6PbmLVB49p6B3pAINywugbGcPfxAG+gz3+VCSnYyog6KCvCD3AajZuIOBkI0qXRfnQdu91JCLRGwDiLy1oYvDrllizIrVemOGpw7HQXr+KMCtZIi6EJ5pUGkAbr2r/YsQoXlsqOKKliT+PJiulQoN/Prrx9RDkBifK9eZvuT0odimwBVeDrlQjbVrSBo3Og6Lx3Aj9KJoJDw4skRK+bzg1oyRQmsOLUggjKjSwwmT6XQf8JsSMNxrqPlHFXEzNB2UTR0AsbtwSaCUiP4KRVs3u09SsehEJfH+BzSwgJDVONbefxxFHxGHPTcJBU4/LUDdQ5xw7NdviEcRjkwWLOjL+hNolUu9Yo/r7YrOjkpC1TE2vNPiUAMefEEZ+g0YZS6dETh50WZQIn8Y12J+kXY5nxjlUpf3u+AVnSFIs3WAk/dl63deLKOpBDvk3LJBiEr9TnsnMgvmzyvFCRiXCnqgV4U187ojlWxxmp2bVxw6Qbn4JnSrD6pUapFu1S0RZTgaj9E9maWpfajCx7yt2yrpmDym59ShFeJ4HKScWneWG2RMRiVZisbLxRf41J+v5HhgszqxNpxKg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dcff8b4d-7233-4b34-2fb5-08dd70889637
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB7129.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2025 19:16:49.6559
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ixGVX2RRq3pn/iTjp/47QMW8Cyyxhr+caVFLiMCNq11iErXWmNQWjybCcSrJMV/pJu+5rZsCJ3QNO1HiHohPrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5602
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-31_08,2025-03-27_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 adultscore=0 malwarescore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2503310134
X-Proofpoint-GUID: meflzzrP-afihGKCw5cHCfBD2EJCy9s8
X-Proofpoint-ORIG-GUID: meflzzrP-afihGKCw5cHCfBD2EJCy9s8

Hi ewanhai,

On 3/30/25 8:55 PM, ewanhai wrote:
> Hi Dongli,
> 

[snip]

> 
> [2] As mentioned in [1], QEMU always sets the vCPU's vendor to match the host's
> vendor
> when acceleration (KVM or HVF) is enabled. Therefore, if users want to emulate a
> Zhaoxin CPU on an Intel host, the vendor must be set manually.Furthermore,
> should we display a warning to users who enable both vPMU and KVM acceleration
> but do not manually set the guest vendor when it differs from the host vendor?

Maybe not? Sometimes I emulate AMD on Intel host, while vendor is still the
default :)

>> I did many efforts, and I could not use Zhaoxin's PMU on Intel hypervisor.
>>

[snip]

>>
>> So far I am not able to use Zhaoxin PMU on Intel hypervisor.
>>
>> Since I don't have Zhaoxin environment, I am not sure about "vice versa".
>>
>> Unless there is more suggestion from Zhao, I may replace is_same_vendor() with
>> vendor_compatible().
> I'm sorry I didn't provide you with enough information about the Zhaoxin PMU.
> 
> 1. I made a mistake in the Zhaoxin YongFeng vCPU model patch. The correct model
> should be 0x5b, but I mistakenly set it to 0xb (11). The mistake happened because
> I overlooked the extended model bits from cpuid[eax=0x1].eax and only used the
> base model. I'll send a fix patch soon.
> 
> 2. As you can see in zhaoxin_pmu_init() in the Linux kernel, there is no handling
> for CPUs with family 0x7 and model (base + extended) 0x5b. The reason is clear:
> we submitted a patch for zhaoxin_pmu_init() to support YongFeng two years ago
> (https://urldefense.com/v3/__https://lore.kernel.org/lkml/20230323024026.823-1-
> silviazhao-oc@zhaoxin.com/__;!!ACWV5N9M2RV99hQ!NduXM-
> ouGzo6_imecWUY_JxPGGp72W4M0Gk3ian-
> na03t2R2BfTPwxnfNOS8JO1IGAL_F9G3ZnsY7zh2F7vuXAIS$ ),
> but received no response. We will keep trying to resubmit it.
> 

Thank you very much for explanation.

The VM (v5.15) is able to detect PMU after the below is applied.

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 1b64ceaaba..9077c4c44f 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -5503,7 +5503,7 @@ static const X86CPUDefinition builtin_x86_defs[] = {
         .level = 0x1F,
         .vendor = CPUID_VENDOR_ZHAOXIN1,
         .family = 7,
-        .model = 11,
+        .model = 0x3b,
         .stepping = 3,
         /* missing: CPUID_HT, CPUID_TM, CPUID_PBE */
         .features[FEAT_1_EDX] =

I have changed model to 0x3b.

[    0.298541] smpboot: CPU0: Centaur Zhaoxin YongFeng Processor (family: 0x7,
model: 0x3b, stepping: 0x3)
[    0.299294] Performance Events:
[    0.299295] core: Welcome to zhaoxin pmu!
[    0.300176] core: Version check pass!
[    0.301002] ZXE events, zhaoxin PMU driver.
[    0.301177] ... version:                2
[    0.302061] ... bit width:              48
[    0.302174] ... generic registers:      4
[    0.303053] ... value mask:             0000ffffffffffff
[    0.303174] ... max period:             00007fffffffffff
[    0.304174] ... fixed-purpose events:   3
[    0.305063] ... event mask:             000000070000000f


In the v3 patchset, it always follows the Intel path, if both guest and host are
Intel or Zhaoxin.

https://lore.kernel.org/qemu-devel/20250331013307.11937-9-dongli.zhang@oracle.com/


Thank you very much!

Dongli Zhang


