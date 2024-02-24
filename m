Return-Path: <kvm+bounces-9594-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E901686227B
	for <lists+kvm@lfdr.de>; Sat, 24 Feb 2024 04:19:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 579D51F23561
	for <lists+kvm@lfdr.de>; Sat, 24 Feb 2024 03:19:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECF7D134C3;
	Sat, 24 Feb 2024 03:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="B89uUnIh";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="shUM8O5c"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC07012B9C;
	Sat, 24 Feb 2024 03:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708744735; cv=fail; b=XofOyuwdRMQfRWUc1J/d6X4uw2LYU+yGkB4zhbxFf183V0GsLP6NkU+XbjqICM9ZI6bbC2va4z7M7KelLEyClxA41xK7/OyArZziFOog5QHJbEfor9t4BOEZWHL3fp80PGRViY0UmTxtoOCW66O8mKhahxyUwJpD/lhPhWngxbo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708744735; c=relaxed/simple;
	bh=B8mFNHK8fkO7hXevepe2i15Znn3rW968awpKBW5akoU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=I0iZ5QRX+YRU764NdRXHm5KVtQcRGyqe8EyoiCBULwaN5UyLmNaAAwwA3oZha64VotXFSyYCOiWX1VLeNxxcnhyhXga+CbA7bFb6T7oLM3XDhE6P5MX3nEoECJ4myxN9IOT9qBMB/uKO2Dk5rUKcFFyFLVSqVO01fXZmL38xUUc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=B89uUnIh; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=shUM8O5c; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41O2sV2k017243;
	Sat, 24 Feb 2024 03:18:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=YU0e4O+vPP+4kw/hUhsjvm4q5rPyMLCzo9qGuGBTcKE=;
 b=B89uUnIhgBOB3vnUnQSpRza8/TIGdn/ArKLT4NImm4qA6Ij4NZ3EowfDMgPp+q59gvKo
 mkchdXymgfiu/kk1+uxoqY33YWt2en12gKKGiG2gzU1nZS+AzHU3MUAssSg41Sdxap1B
 92yrDVYXDcsYVrQtOk0IzWkBzM9Zrfr23iPa3CSGE3pEAhcb8oriyXimXpG9kGKP9EAE
 H3gzzBpTZ/gu1HGM/EAyVFXlzKBZ0Apt5q/2qXIFgxN/5+cU28YBS6/yJ/W7EgLouDV0
 Sv4OMptrfVbW8PiIcQMM0x0yJrjXh7giC+335ES8T82KtxFKEWzimcA+FqS2BuVC1jvu dA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wf82u00kv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 24 Feb 2024 03:18:47 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41O1YBlB016935;
	Sat, 24 Feb 2024 03:18:47 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3wf6w9t1d5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 24 Feb 2024 03:18:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dYKVcrkF8u+Yck6I8UP3u0KADagfhrY1UvLQWLnOYJfF3/A3IvjDQLvxfoETkeaUHzETfohpQ0/O7yr2egeoA8Um1j+6pvDZ1Y3AfEqblMuZXBCa4HKvgoJzEbz+2JoI4tfM6rsmiyvm/RwHG8+5IpCtXWceTET7v954EJhDURdmwgN33k78c9ohUQq1bZJDCdhCU8XeYm65GsGbTBhbjdzd/1hmmYeDc5JGSGuxJC+4/e+TB3jGshD7piY9tMH/TozYzikZfVq9IJhHLmoyTPhdR4J2QpoNv3fF7Q3eFgRyxfGGdlFU1TID0mCBzmL1oeXFxUJZpfetF3koCqClHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YU0e4O+vPP+4kw/hUhsjvm4q5rPyMLCzo9qGuGBTcKE=;
 b=QQOQjE6yc3Ne2ltgxU9jLh6QkPyE/q2/gAIdLZ7EDfD1IQ9KPKqjjzoSEGIFKpgbWuwdbW4+1ClLke+gkyPbeT04BUsJosx60fLMG4ggbQiGm0M4XJpd/gW7gjgfOo//YV+NkZfoOE2j4t9DvneD1LruilkwDq/+2KUJtyVKA+7hi6OIkqzq75uhV2zZNMnjOXvWlY95bLMm3qjkAF9JlJ/3YfbW3yvdLsZy4nql11XGOshEARJ6A8CeWm8eIMQrOtCCF1OY38TD+esZiV5YKXGKaNlUwLIUUC4EsGg4gk0HABElB7WC4ECfJ6fLz3HC3OleMSJrEjUC+ZklRyLCqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YU0e4O+vPP+4kw/hUhsjvm4q5rPyMLCzo9qGuGBTcKE=;
 b=shUM8O5cVLDCR8s6TUFG7lFgZxv88wR8YLP7lMAf4nICVk30mTTS4H2GGyQqJ5+au8kCxEXdcv3Zx2iNy/Olb0y47Yq4w3PZhHakPgI0T2RiW7J69HgWcukBdPiKXdQl5PyUhvPFvuRd3hZwxXE3Xdc/ZAcyS1j+T89yhQGS6KA=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by PH0PR10MB6981.namprd10.prod.outlook.com (2603:10b6:510:282::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.21; Sat, 24 Feb
 2024 03:18:45 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::8156:346:504:7c6f]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::8156:346:504:7c6f%6]) with mapi id 15.20.7316.023; Sat, 24 Feb 2024
 03:18:45 +0000
Message-ID: <b8054f76-e427-ac8e-5326-863653057f83@oracle.com>
Date: Fri, 23 Feb 2024 19:18:43 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v2 3/3] KVM: VMX: Combine "check" and "get" APIs for
 passthrough MSR lookups
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20240223202104.3330974-1-seanjc@google.com>
 <20240223202104.3330974-4-seanjc@google.com>
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <20240223202104.3330974-4-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0072.namprd17.prod.outlook.com
 (2603:10b6:a03:167::49) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|PH0PR10MB6981:EE_
X-MS-Office365-Filtering-Correlation-Id: ca22a0b8-9477-4681-fa68-08dc34e74f7d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	JYWwhadFDM+HZ9fsQuzH5V+HEJrbMZD6xTTeSYo5rhAvuQtOtJuLeeRmlHWrpL/TI/E47JSiRW30e1DlNTaBpDIuira4/MGobaGJpNNF66AfzLjO17FqFxXTOmHFOjzF5vHFvcJJol0ByUt8Pi0YAzIlC6c1HEnC/0nIpC/gFHp3tCJiBUY3jB/Z08xo+nqfaz3/pV4ldlZsAW3qD+abBBuMiuFDGgkhkaQ21K5L/tkLdikn3NncW6tNO1PxZf8pphMVvMK9nTAHtoJzhtWJmwvgu4bg1YTFG+90vVAJmAfTN4yXAnaeCzaJgpCqxmuRVi3s1zSgJl225eUrlnuUuBCoVjogcD7pVXjBNHjaPrkOXS9Av++j5fV20h5krJAKRsEr5W4dr4Fj9tNzLkqO2k5uouALBzdxqOlZ5OkNy18+8erkJZhaKl6gqg/DmM+SGwCdzN1Y0yCUFugkGuiXnPuuX1DpEI3G6PfIVYWDkma/82eNrtjWhGlJMSfk6mlkL7VUV7LrTtfXFBt1z9P1JGVtqHdbdCRCfp3WXiya604=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?NkhJUnVvMTZzaGRqd0svOXpnakdMcTlOU1JOMVRQYXZaVFVQd1dWV3prTEQr?=
 =?utf-8?B?dkQrNE53Z0VqWk9nNThjc3dib3ZOTFNxTkxEZGVKSjVBNlFNT01tbzhabEtD?=
 =?utf-8?B?TjBzeFlzc1ZEUWNET3hYbkhSSGdCM2loZEhob2hlM1EzTVN6UWQ0Z2JtWkVn?=
 =?utf-8?B?TTNtNURTYnVWcTdBcEozeHNoRzExeWNUWWhMYWYzYjJMVld2TXp6WlQyYXZl?=
 =?utf-8?B?VDVNV3hoaHR0ZDMydnNOWFd3SzFrVjBJL3d4YmNjZURlZGRtdk1SVGlocHAz?=
 =?utf-8?B?K2RoUjQwNEZNaXIwQ0Y1NXZMVWw2M01vSVg0VlNQSWxMZ2N3NTZna3pqbldL?=
 =?utf-8?B?Qm9oTUtrb0lCSHAxWWE3K3NwQWNtK0tENnNMd3IrUjNyR203dW1LQVNDVlJX?=
 =?utf-8?B?TklmeExHSWN2a1RGNWEwREM2RFZpQnVrV3lXQTcvU1N4cUFSaW11T3Q1QStt?=
 =?utf-8?B?Nnkyd2V3MzlCNE0zU2NhdVhBUWswVlpYbDR4N1Y2Q2I3NzZNTDdNV2xZRzRu?=
 =?utf-8?B?bit4SFlSUWYvUUZLOFNrSk5LRThKclFzWWs4bmZ0ek1OK1o1VWUvalJxTThi?=
 =?utf-8?B?SXhjUU11NG01YUtPTFJSbzRxVml3bGhpU0xKQm9HSGNYVSsrL29XNkcvQ3VU?=
 =?utf-8?B?ZWpjYm1ZQkVLNFhBdSt4OTVyZnJIRmRXdzlKSlhGL2o3Q1UyeHcvR2pLNitE?=
 =?utf-8?B?Umd3dDJMd1hZdmZPNmhPZ3czZHNCeGoxR2NEdTAwY3JjUXlOcFhrZ3BJN01Q?=
 =?utf-8?B?WVRWeWUzdmRVcU8zbmJ4azNuOXJXajhHVzNlVjloeEpGRDNsRjB2QWF1SjhE?=
 =?utf-8?B?WHNGWE1ZSkxnK0dNVVl5NzA2eEJwNTY5dDZnM2J6eXNlYlV5cjlWd1pjaThj?=
 =?utf-8?B?eCtJdHdmNHZabUhJOExHdHJFMlVMcmZkYmpxQ3hVNE9VZjN5ZHJoaWdvUGdW?=
 =?utf-8?B?cXBSalovUXg0K2VlSTQ3VHY4K2RvU3BXd1Rrdng2anVJclI4WUZsZzNtMTV5?=
 =?utf-8?B?czFUUmJSaU95WURYaWd4Tkp2b00yNXhTWHN1TG1zbCtZbUs2Z1ZQQnJicE1M?=
 =?utf-8?B?SGhETjBCYW1GMm9XL0JPZVZkUnVvYmg1QUYvWm9wcTdXRU5STEpqWHRmZlU0?=
 =?utf-8?B?dXNmMWNDQmh0UlJUZ3dEMnhRR0Y3RVo4bDRkL013ejFZSDB0c09OUE5WdEFZ?=
 =?utf-8?B?SXdOTnh6cytwSVpnMWRyTEZ2eExkZzFpSGF0WTFMUjhmb00rNGI2bVlUVFg4?=
 =?utf-8?B?cjBGUTh2Mk1SdXpQaCtuazUrTDRtSkEzVUlGdktibUJyWnlJMVp4WWsyQ3lo?=
 =?utf-8?B?WW1HdlBFVExiQ2dST01ERGpuVFZtK3VVN0R4OU56MmNZQjVJcmRnN1dQM00r?=
 =?utf-8?B?bkV5dmd2aExLbU94T2xVNnB4TTB0RkJlRlo3Mk41MTRrSytkajd1WDZ4Uk1s?=
 =?utf-8?B?OThOdWcwS3JGY3Q3eWticnJHY2NOWC8raU9iYmROWElJdEcvUVNFVXJPemt3?=
 =?utf-8?B?a01YMitKZ0dha1JPT09SVnlGbUtFdnd0TVJUeWp0eUlkNXlUMTZDVGw5aEtV?=
 =?utf-8?B?V1pjNDVmK1FQWnMycTdkcFYrTGdRNUlDenFVUTZXYkkyMnFCRTJ2NlZucW8w?=
 =?utf-8?B?TFdvM3h6QVRqRGRIQWpNTUEwbFZHeTNnMGxKSkkxVHNlYjNHQ1NQY3FzUjFU?=
 =?utf-8?B?NzFyKzlqR0VlVlB0bTRudFVJRFlFdTJ1WDdsbmJzMW5iUGZNSWlmVE1UMnRq?=
 =?utf-8?B?ZmIreUV1N2xBY016RXIyWXNZemxvL05nWFErUFVVNnpUU2MxNjlHQjBXRllJ?=
 =?utf-8?B?bzZmNGI4K2dVUXFlQkttay94aTVSS2NOdEZTRllqcTRNT3pOQ1JwdytRUUQ0?=
 =?utf-8?B?czBLTzNZSGZrY1hkQ04zbnhnMDBWU3VudCtQdUtjSjdMQW5UNU9VZVBrV2pJ?=
 =?utf-8?B?T2ZkRXhtM2ZhUVhjQnRPTVNYbUFiV2ZWZC9LbHpLakRkbVgwVUE1a2Y5Q1ZI?=
 =?utf-8?B?Mzg0YzF4dVJlNWRYVFJpcUxta0pFblIwTW5NWVlXUTE0TVgrZjlsN21oeUZk?=
 =?utf-8?B?blp0U0t5dlB1NEtKWVlnOGs3bTE1aEQyS201NENRaEdEMVYzOEZWRnVYeS82?=
 =?utf-8?Q?OVLCVjnsnCftP4JkgfoC1abhv?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	K4jV5F7n0DBKUqpYOgWq1z18tvvarsnfOHx2rDkkkt+JuvC3WNQRylRDLLBaYgwpMIuh0EhQlZTDsHRQJ6Forcvrw9KMIERYIAZ9mAWydGhOxtvJX0WAAK9uBlTdAQDkIKOb7oKdKJZBNUeD/q763pi1hcKejI9KAD5KdQM5DiqCAl2+aj4OtFxWfaprUMZuYkNCmRFVwyvTTXZM2Y6nmwp3p0/L2944c1ZtwVbtHDR/t4yNWcCuPp6dSlS5HpiAiiu6KBP9s76JRehHzLWOM5+nntZIy5VyB8qrb885QAuiLdnw8nScxw1loOF5N4b28uYPK7/TaWxErPtMzUzd0bk86C8zg9evBEbzM9ZFAJWWkbBoidmp+PubFTaf7sW97EAQBBIViMMGY/tS0h47M390BhxQeQH0HgK9gYWDYY2g9bspvCpmFOEjE4MuUCpkTcgKjya+69rfOE4EHAuBJdRUSpmdoT6VvYpTU2TJ/MZsfgIDTK8UC9B2B+Hqb8LNmt9HJ9la4xcySA+BAkRHZzXXupt4SY51+KRZIsla06vila6PsbZZd+a1KVfNIu01M/+yBJI4SV3t6DTLOgqp73K/V23KVTS7aukhlgp6YOE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca22a0b8-9477-4681-fa68-08dc34e74f7d
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2024 03:18:45.6310
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fhfIpnxRZZD/5pXngntQzp847tbblqcJpeZnRmL3KPElloTG+Al+h18+cW6Q3jiNnmtzQrs+I5wM8UdxvH1ivg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB6981
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-23_08,2024-02-23_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402240025
X-Proofpoint-GUID: LfwTBIomQiJTuEbiKdMldPjy9-p24W0y
X-Proofpoint-ORIG-GUID: LfwTBIomQiJTuEbiKdMldPjy9-p24W0y



On 2/23/24 12:21, Sean Christopherson wrote:
> Combine possible_passthrough_msr_slot() and is_valid_passthrough_msr()
> into a single function, vmx_get_passthrough_msr_slot(), and have the
> combined helper return the slot on success, using a negative value to
> indicate "failure".
> 
> Combining the operations avoids iterating over the array of passthrough
> MSRs twice for relevant MSRs.
> 
> Suggested-by: Dongli Zhang <dongli.zhang@oracle.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 63 +++++++++++++++++-------------------------
>  1 file changed, 25 insertions(+), 38 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 014cf47dc66b..969fd3aa0da3 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -658,25 +658,14 @@ static inline bool cpu_need_virtualize_apic_accesses(struct kvm_vcpu *vcpu)
>  	return flexpriority_enabled && lapic_in_kernel(vcpu);
>  }
>  
> -static int possible_passthrough_msr_slot(u32 msr)
> +static int vmx_get_passthrough_msr_slot(u32 msr)
>  {
> -	u32 i;
> -
> -	for (i = 0; i < ARRAY_SIZE(vmx_possible_passthrough_msrs); i++)
> -		if (vmx_possible_passthrough_msrs[i] == msr)
> -			return i;
> -
> -	return -ENOENT;
> -}
> -
> -static bool is_valid_passthrough_msr(u32 msr)
> -{
> -	bool r;
> +	int i;
>  
>  	switch (msr) {
>  	case 0x800 ... 0x8ff:
>  		/* x2APIC MSRs. These are handled in vmx_update_msr_bitmap_x2apic() */
> -		return true;
> +		return -ENOENT;
>  	case MSR_IA32_RTIT_STATUS:
>  	case MSR_IA32_RTIT_OUTPUT_BASE:
>  	case MSR_IA32_RTIT_OUTPUT_MASK:
> @@ -691,14 +680,16 @@ static bool is_valid_passthrough_msr(u32 msr)
>  	case MSR_LBR_CORE_FROM ... MSR_LBR_CORE_FROM + 8:
>  	case MSR_LBR_CORE_TO ... MSR_LBR_CORE_TO + 8:
>  		/* LBR MSRs. These are handled in vmx_update_intercept_for_lbr_msrs() */
> -		return true;
> +		return -ENOENT;
>  	}
>  
> -	r = possible_passthrough_msr_slot(msr) != -ENOENT;
> -
> -	WARN(!r, "Invalid MSR %x, please adapt vmx_possible_passthrough_msrs[]", msr);
> +	for (i = 0; i < ARRAY_SIZE(vmx_possible_passthrough_msrs); i++) {
> +		if (vmx_possible_passthrough_msrs[i] == msr)
> +			return i;
> +	}
>  
> -	return r;
> +	WARN(1, "Invalid MSR %x, please adapt vmx_possible_passthrough_msrs[]", msr);
> +	return -ENOENT;
>  }
>  
>  struct vmx_uret_msr *vmx_find_uret_msr(struct vcpu_vmx *vmx, u32 msr)
> @@ -3954,6 +3945,7 @@ void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  	unsigned long *msr_bitmap = vmx->vmcs01.msr_bitmap;
> +	int idx;
>  
>  	if (!cpu_has_vmx_msr_bitmap())
>  		return;
> @@ -3963,16 +3955,13 @@ void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
>  	/*
>  	 * Mark the desired intercept state in shadow bitmap, this is needed
>  	 * for resync when the MSR filters change.
> -	*/
> -	if (is_valid_passthrough_msr(msr)) {
> -		int idx = possible_passthrough_msr_slot(msr);
> -
> -		if (idx != -ENOENT) {
> -			if (type & MSR_TYPE_R)
> -				clear_bit(idx, vmx->shadow_msr_intercept.read);
> -			if (type & MSR_TYPE_W)
> -				clear_bit(idx, vmx->shadow_msr_intercept.write);
> -		}
> +	 */
> +	idx = vmx_get_passthrough_msr_slot(msr);
> +	if (idx >= 0) {
> +		if (type & MSR_TYPE_R)
> +			clear_bit(idx, vmx->shadow_msr_intercept.read);
> +		if (type & MSR_TYPE_W)
> +			clear_bit(idx, vmx->shadow_msr_intercept.write);
>  	}
>  
>  	if ((type & MSR_TYPE_R) &&
> @@ -3998,6 +3987,7 @@ void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  	unsigned long *msr_bitmap = vmx->vmcs01.msr_bitmap;
> +	int idx;
>  
>  	if (!cpu_has_vmx_msr_bitmap())
>  		return;
> @@ -4008,15 +3998,12 @@ void vmx_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
>  	 * Mark the desired intercept state in shadow bitmap, this is needed
>  	 * for resync when the MSR filter changes.
>  	*/

BTW, perhaps fix above the above indentation issue too? I did not notice that
when working on the initial patch.

Thank you very much!

Dongli Zhang

