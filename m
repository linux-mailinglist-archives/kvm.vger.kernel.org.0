Return-Path: <kvm+bounces-48388-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E468ACDC59
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 13:15:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1BA2C3A473F
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 11:15:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC8D828E5EF;
	Wed,  4 Jun 2025 11:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ysm7foVG";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="X7DFucy+"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D8C417996;
	Wed,  4 Jun 2025 11:15:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749035736; cv=fail; b=AHBbMCS4KWkvv/Q4R+bMMpSLktP5+TbabyvmC+n4nMJWrWqytvCGdffK4ZGxTguIX1IzWE+OzCQOh20QsHbmwf+5q9Pg7aMsAMnUiRT1ZtU7pS20vwHWQGyeuDNHiigIMLA97QwC0ctwmlKUPiGqByYy8+ENfhQm5G0f5/eBHE8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749035736; c=relaxed/simple;
	bh=yokaSWPvlfIJV7QXvIjaQIoj1OrMJELGlXOV7Nu4eQY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FYrKX8a1XInuq1jOzb+w7NWNUQTkc9gDu9gqEEYBtUQhfvnh57GgRYtp4hf4YU1AxJwzJYAgTg4QH8h0RMlR9dfou/APWSwKW7xijP60hTs7ZIX3+4aTig6wjfSqmPxJN6Xf+T7jg7dz3lcReBT56X8glhS9DrVX+F2bL0T2r3g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Ysm7foVG; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=X7DFucy+; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5549Mf4c010211;
	Wed, 4 Jun 2025 11:15:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=J1TN4YafqE12NHrVV9l9alWhOv0aWVDdk5lQy51cWpY=; b=
	Ysm7foVGpaO/ZMtNV0JL8p23LG0DzcKh2ryITgW9eGiMVjiVO3kCozBzqhXNz7hg
	KO7DRVt1qqPwVnc2ewxGx9SmMwnCX2JjCIe2h4PMLHcmtG+/9aAY+0h2axZlsxAU
	YGKHhK0/0LrnwZ5TUPa0GrtaYap5Q1OwgCe0Ab2zs2wnOUlohPrax27JGwpKxNkN
	AoHyhB4+8iZRzHT8fqT7urEB4TymJqUbE+sG5Og3mWd36V0jdsrvO3H+ykuo3Kyp
	XuCXVM9yLp0yKpPic5tl94IS8bG5rJAYp5QIURip8zbcxbZVMJik4/NpTiv9RmVs
	BLYZlGQAN2W9tnmexq1Esg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 471g8kbrq1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Jun 2025 11:15:26 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 554B57K7040644;
	Wed, 4 Jun 2025 11:15:24 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2069.outbound.protection.outlook.com [40.107.244.69])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46yr7avfvp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Jun 2025 11:15:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OOdY0uITaVP801WsxiPbPq3QaR4YtFq6NaAJFdfwMaDnYR/j2/nn8a+xEINUtyy2TxzFMtVUHECAEDIoF27h6QYYrRv1pokPDPODRDDzpZ/+FJRgM4tHoxSj3FYhRPAchX0sjIBnH4cgpVt7tKHIf+Jcu3vzQqvbUet5fhjGJNCCq2EiQuT7RBz3JUyyIwGvmgTadxKmBHH7avBULyGoauzmWmqGPBKIcQhsWZxuoNuUq1lrdfvUALDZcWj9NTDXTnMxm7KFOoslmaSlj9HCzl23tFjZqrh2nvQuiBip85HzRNzHe0rBV+OFf9zACYB5qGverfshm+OSDAhituQM8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J1TN4YafqE12NHrVV9l9alWhOv0aWVDdk5lQy51cWpY=;
 b=lWwQHbEtdN3PT0uhZkCleAVjKtpz3rSCVoB57ti6pe/RA4qHqX7jPknw+FMjtFT1WsFi0YjQEaT5vWEqghng8/sm3bGf/Bdhsq5QYcyI9T7CMfe25cqLSbaotcT93aQQmBwjmRQzxKUvEy/FJpgs62T7Jq1cYK3hMDTz60MQGL1mpb3rhzEJhJXmtIHa3GRJ+vCjgR82QUZ41GE2QMD/DkR+TcmjvYriG3DL5KSgek5eqXoTzdhJD+XMZi3JgMsqMCAtqfN3O05FUzfKH32VwQ6hEGrXDnaT6R+iJS4qmCR1GyMn/PqLzcqpBeLa0WiLXoujaMFSHTx19gLefWYGTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J1TN4YafqE12NHrVV9l9alWhOv0aWVDdk5lQy51cWpY=;
 b=X7DFucy+LM3+5gKU+z2+VaggQXmo6t8IXAQbXSBsawj9dWfAVVIFHaBRQXoUtprvCTlG6Iy5AyAQ4+qwIet5sQk8U7GV5vhTNWfAimdR50F+R52Yi8tYADzjjOQnCf3vZoT3aR/XURDwqrODDnDwFbcBEkVD8YvEkmtAbPsr0us=
Received: from BN0PR10MB5030.namprd10.prod.outlook.com (2603:10b6:408:12a::18)
 by IA0PR10MB7133.namprd10.prod.outlook.com (2603:10b6:208:400::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.40; Wed, 4 Jun
 2025 11:15:21 +0000
Received: from BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::44db:1978:3a20:4237]) by BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::44db:1978:3a20:4237%6]) with mapi id 15.20.8792.033; Wed, 4 Jun 2025
 11:15:21 +0000
Message-ID: <e16b3bf2-ad1e-4614-a134-cee44a3b1b8b@oracle.com>
Date: Wed, 4 Jun 2025 12:15:10 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] KVM: SVM: Reject SEV{-ES} intra host migration if
 vCPU creation is in-flight
To: Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexander Potapenko <glider@google.com>,
        James Houghton <jthoughton@google.com>,
        Peter Gonda <pgonda@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
References: <20250602224459.41505-1-seanjc@google.com>
 <20250602224459.41505-2-seanjc@google.com>
Content-Language: en-GB
From: Liam Merwick <liam.merwick@oracle.com>
In-Reply-To: <20250602224459.41505-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR04CA0216.apcprd04.prod.outlook.com
 (2603:1096:4:187::18) To BN0PR10MB5030.namprd10.prod.outlook.com
 (2603:10b6:408:12a::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN0PR10MB5030:EE_|IA0PR10MB7133:EE_
X-MS-Office365-Filtering-Correlation-Id: 0dfe5d59-7de3-4ada-2e7e-08dda3591833
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?MlVkVDh6L2ZUNUxjYVRpSTdlQ1NKaHRXaFBGWk1MNTV0c2N3OFNLNjNvc0l1?=
 =?utf-8?B?V3dNSW1tTTFwb0tPWnRKVUY5VUk5ZXFKYnM3NnB0VHF1OVdKbGx6WHpiaCtI?=
 =?utf-8?B?ZWFvVTYyZWJhdnVUUWxCRWdEZkZwZExPTm92WVlqZ1dndERISzBWL1JOY3VX?=
 =?utf-8?B?cG02b0FPNGhLUTZZMHhKTTJzL3VKVnQ4bVFSUEpPSElVRHFGZGVtN000aGYr?=
 =?utf-8?B?bHVxWndvbysvNnpqNWhrZk9GYS9ZRG9YZ1o2RTJGVTE0bXNCWVppekZTZlBn?=
 =?utf-8?B?UlhacEJlRUdVRk50OGFDZzJFQkRiZ2QvSll1Tm1EVkprcFVpYzd2eXBHQVc4?=
 =?utf-8?B?bVhQeGZEN3ZUWEN4YXBTUUdaaGN4bHB2SkRBQXRLNTI4TUJ5dTloSEt6YWQ4?=
 =?utf-8?B?VTJmTkNQMUZ6eC9RWHgwNmdPaW1DTnFuNDJNSjJjYktScDFONTUwb1pHSEJ3?=
 =?utf-8?B?ZnNmVmQ4RVJNZGwycEl6U1R1clJYbU5KdjZ5ZUxsUk9tUTk0dW0vMGd1NlpT?=
 =?utf-8?B?TTVTMW1nVjRIdEtBajZzNktwY1lqUlIzakJjZkl5NmcvY3FKODgveEtsTGoz?=
 =?utf-8?B?TjRqWFl1ZlFNV2xTWHlUcmdBYTFMaGRQNjNySjU3dCs2Nnd6MzRwUWhUbXdJ?=
 =?utf-8?B?cVVhNUNVYlJQZTZPRjBRemRIeFEyZHNmNllVRExYNkRZWFJMOTEzSVJXaDVM?=
 =?utf-8?B?WHFkTElxZHRQakNUZmdDOCtwTFdKOGF1dWJWbmkvRmxWaWU4Y0tSbEJQeVBJ?=
 =?utf-8?B?eTk4SmJTWENqanhVTG1xVlJwM0hYTW5uYkxoV0ZJOWJlOWlZZm1YQ0RIYzA0?=
 =?utf-8?B?eXFvRUpJUXFwRkQ4K3A5akhabElVYXhIc05iRUV4eUVSSkVmcHQrYURxamxp?=
 =?utf-8?B?T3JycmNDbXVzWkJhc2lTVkJKVTZFSFF3dWhqamJtMnI1dVFsOWpaNDI4SkRM?=
 =?utf-8?B?V2RXb29WaUIwR2pTZDY0QjFFQ2I5ZUhGRnJ4VnhBbU05YWNRZjdMTFFWZjMw?=
 =?utf-8?B?SUQ5QkNHNWd2VE5pWEdMMWVidzFrWkR0OWRPYzU5RXpvZGxXUkY4aStlTGxR?=
 =?utf-8?B?OThZSG5CZTlzbk45UU16YVdNTHpiNWZyMGpLbVJWYXJlL0lHWGdsYzcrcGZO?=
 =?utf-8?B?eHp4VXQwbnB0dS9xQndleTBFR3BieFNZYVYvM3NwMFpqR2l5TzdEeFMxTVR2?=
 =?utf-8?B?N2hYOFcxYXpGVWVjd3NLL2tKN25Gb1NVSEtobVpReUlYVStqeFlNN3FiY2F3?=
 =?utf-8?B?eGk4M3RSVVE0MXU2c0Y0bWJwZkNpQzg4b05MVXc1UmFMMVF3dlZtM29tVExu?=
 =?utf-8?B?czliWXlyVnBNczBnRCt6SnpDbkxib1RGRnR6TWp5M0JOSnd6eUpzV3llYWkx?=
 =?utf-8?B?K3cwMXFhSG94NENNVkw1RDE1MGQyZFo1TVQ2YkhaR2czT29POTVQT2hUVTU1?=
 =?utf-8?B?dWl1K2ljREtnRWdKZDJJcWdrQis0YWtWTW9qZ0RJNEdqNGFCSTBoNzVUa0h5?=
 =?utf-8?B?MHhVMXNyVXByQkRMWTBpeThSMStKNkJCbXFLbi8wbUVVc0tobW5JcHVXYzVE?=
 =?utf-8?B?RE9NaTR1YnYyQlBSTHViTEgvc09MZ0l1WHJLU2hiOHA5M293cjFBL0paRVFj?=
 =?utf-8?B?dE96dnhnNUw1U2JzeWVtQWFyZXV2Q3JIT3Z5c1Bhcng3eE9RNzhtMGFmN09L?=
 =?utf-8?B?QUYwS1BQY21Mc2hwT1h4d1dBMG42ZzNBVW9WaWNCNUsvaklUblB3VnlnYUsv?=
 =?utf-8?B?NzJua0NHYXhxQ1JrVlNoT2NQMEdkdU5lazgvdHdvQVhKZnlJeTloQ05LS2lm?=
 =?utf-8?B?R3hRbk9rbHlRNjlNWEhMeVRWa1dLUGR0N3d6b3BweWZidGVVb0VGQ24weHNQ?=
 =?utf-8?B?eDNmVmhCRmplVy9yUFlFcUxYYkRuaDNETjA5QnZUWldRZTRZL0xJMFJJUWJ2?=
 =?utf-8?Q?0cXFcrhgL+s=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5030.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?VGlJVW1DS29JUDlyVEgxODBRL1o5NU1mVy8rbVVwMEp3Q0FndWNEbURPMlV5?=
 =?utf-8?B?ay9aS0VQOXVYTWhLc2M5emF0TWZJa29KOTNScTRPNjM0UW9LNXJtUzFnSUlu?=
 =?utf-8?B?ZlhlMWZwZVJQUVJzeFNmcUFrdS9LRFJwcjBCUVhHZGtGbEVGMkJjMThxVkpr?=
 =?utf-8?B?VmhyczJCK201YktQN2JGODBEcHN2QmQ3Qnc5QVdhcEM3U21LelNZUnAxd3RE?=
 =?utf-8?B?TXFZSTErUUxXR0s1M013TEE5djdaQnUwOWVFVm9BY0Zzam51c1NuWGU2ZUFH?=
 =?utf-8?B?S2s4Rm5seERRN2h3akJPWDVTRzZCZm5vckN0OE1tLy91UFcwTUdHbHFhLzZE?=
 =?utf-8?B?VXhwSlE0SHVZTnlPU2NqSC9rUERRQ1FNNmxnRnBZa3FWYVZuODMzR3pCekpw?=
 =?utf-8?B?T01kd1p4U3UxUnNodWgxbGIwR05QeGlwQzdHUXZ5Q2ZtdjZLS2tnVmFoSmFo?=
 =?utf-8?B?MzBtREpwVS81UUovN3BZVnp6TkVpZmZUOEtITndTZFNqLzIxYUgzVFZOV1pN?=
 =?utf-8?B?Nlc1dzRHdHNIb0ZPNjBjQWVzV0ZxbjlWRjZEWTZFRitpN0h0RUtxcTF3V2ht?=
 =?utf-8?B?ODhIYVM5Nms1VklFNjg3MzVoemJSWVhSTDBuQTFMKzJ2dmxwcTFZbmZQZ3d1?=
 =?utf-8?B?OFRXVUJxTWFsaVJKTWVzY3V4bVVtS091VmxLeXRSZjlQbHNUQ3BBV1VkbjBS?=
 =?utf-8?B?NkM1dzZZaFdZb3kvWEZqSUluQno4d2MvOHA1OFdmeVQ2OHZVUWRnWVQ3SHJB?=
 =?utf-8?B?V3g0bGticVhwRm1ZNVpUUlJIOEhCZ01SNU5DTGNFemFqUHZvaGtYSmZYV0xZ?=
 =?utf-8?B?WkZUZGZ0NHFlV3hSdUU2ZXk2WVdJVEUydnBWbHROb3kwY3EvSzVvV0lNOTdw?=
 =?utf-8?B?K3RDMUhBRjl1SS94MStrcmllWVh1SFFPK1NiT05pKzRMbm83Rm9QRzdleDI3?=
 =?utf-8?B?Sk1yT2lKL1IrSlVsMHlXaXpDUVpPTXV1eXJTaHY4Nk1pUFBqQTYzbmI5ODhJ?=
 =?utf-8?B?WmZDVzh2V2JOTCttdHdhMHlOeVJUaGFqMkdRR2NCY2N4K3JmM2tHREg5MXF0?=
 =?utf-8?B?KzcxTWNSSVB0UTFOQys2RUdOWjlRQzNSbVBIMnNHV0ViclQrRWpHaS9nZmxj?=
 =?utf-8?B?aG16eEJxcFlSUURKN0dXSUNMelN3Z0lKSkJXQXpzcWtRRzBuS1l0clg4SEdq?=
 =?utf-8?B?UFlWck9iSzZmVlFrbmhGcnlaU0VwaGxkUXY0ZFRQeU1RQ0llK1VrZE5zTThN?=
 =?utf-8?B?R0VOdWRqR0VVdWdDV1FkY09yWTVBdDlWQU9NSWx6K0NyaU1NSHVtVThsNldm?=
 =?utf-8?B?L2JwYVd6RXBiSXpaWmY4ZG5vVWVKNVo4QldJMUdseVYwZUNFK1ZyZHloL0tJ?=
 =?utf-8?B?QU05NjBSNDIyTm1BNURWL0g0VTA0RE9Ga21hVnYxYlplOCtHT2tnNTVyZmhZ?=
 =?utf-8?B?MlZLblZQeHkrekVNbTE1T21SK3JoYndONGw3L3VhS2Z3UTJpL0ZJbGdPN1lx?=
 =?utf-8?B?bWZtRjY3RHUzUUVrY3NVT2R0TS9jNmZ2N1YyMHBqdEZGb0FPbjFkTW50dS9W?=
 =?utf-8?B?Z0Z5N2ZadklNZHNpN1FIUCtNOWVQM1BqUTdZWExNS2lKTXN2YzJRNDRtUXBB?=
 =?utf-8?B?aEM1NWcwVW4rRWJYckkwNkZJOXNMQkMySnpUeVBheUttODBBZTBHUG9EL0Jh?=
 =?utf-8?B?SDFIVGVobGtCNWNEL3l1RHRCTUdFUjgwZlh1LzdiV0l0NjVySndrUi92a1ZZ?=
 =?utf-8?B?WEpzMlZ1OVpuc21JWmxJbzNNREw3aVVvY0VvYzdjNzdidjdYSlZQMHU0SmZN?=
 =?utf-8?B?ZXpTWmtSWGZTODBreEN0TmxRdEtyVTBtdjBodWJtbjQyVnZkaE5jazNDd3Rj?=
 =?utf-8?B?RmdYcnd2MExRb3FPeitJdjNQOEdQQ2o4dWFPYTZ2anN1S1h1elJKS1l5b1o4?=
 =?utf-8?B?NjRxRnlwWWo5TzJ1MjdEZEJXUk1lYnhWNS9aVWRhTnR2MnBjb0Q3bk10cERW?=
 =?utf-8?B?VFlSVXpqSGN2ckJ1VHF2emlyUC8zajdkUGNmRnJwNWtjQm9PY1lsc0ZibExy?=
 =?utf-8?B?VVJvbzFnZnNpU05HaWRWWTFJT1IvOWNtbmx4N1MxQVJHQjBKaFFLeEVGMUl0?=
 =?utf-8?Q?B9S3Mvw0Jh9O+d/S4sgnfEUNR?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	lPa939RN21y4TjLN2YjS5ZzOD440FunAzjIX++NHmCJ+Pmw+9fpnZsKnWHAWsPpAYRuOW3oTYcCMDWgDmOb/DN9E7mmApBSRJomyOskeiAR6YLZuts6WUWhNInwilZcWd19HMiv2RHJJ3KeoFru/DWef4752gQ+w4m+ZTVfHYn9nR2XCdRyFwn4nrbwadiXHtiPj3sKmF9n7sPSDjfytjQ4/ZdyZlU85pdS8zpNL0KKUepou1JB5ApJoAgm5b0VlzQkwnb/Me6WYUyOJFK6gELutEx16iR4AQ/ujkROtuJQTqU8hPpa9UVhbgoygn2g9Znbc6RxwFWWp+FUu4bjOJP3+SEoSR3s1IiiPCQnpfiTwoNaOsPItH9NjxHNHNcb967yF7gq81Ark298RiHs+zqVTehqHf5XLMl4kbszPH0ntDdTct12yRIkDPm5bPEBzJwYmTkISRM4BBF6uZV/Eg7UjNS0NaRlS5fzNdDZKbWs+hOr66Jqe3T0hXmBSpVgtWCBYE43nwkSJfgMK7ASLCeivT9mxabni2GaQwv9EVtbmlEF+FCbEgR2CfBq3sQrdATeboxpMnMxihk7juR8tPCVg204crODQXn5iMiykWqI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0dfe5d59-7de3-4ada-2e7e-08dda3591833
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5030.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2025 11:15:21.1942
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ss4yQdv0zgzwgjq7yJXBlwyHElWydPwbEPlkZq8NnOsYOTck8pyE9D7cVFnT4lrEIfwE1ZD1jyN6u/595WRyyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7133
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-04_03,2025-06-03_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 malwarescore=0
 phishscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506040085
X-Proofpoint-GUID: xuZ9dLd3QOd_owMsdcxtjCXo7iR_HlO9
X-Proofpoint-ORIG-GUID: xuZ9dLd3QOd_owMsdcxtjCXo7iR_HlO9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjA0MDA4NSBTYWx0ZWRfX/RyDEunb9PyP fC5BkCIdmH3+kcq/vOyfG+t86DneGVE1pdnUxY3oaos2LdTS70PTrLwE3qYYa4mwO73ci8Ktomh DK0wl4Ld0+LmmC4Egdf9w+njN4XfzaLb9UAlVDxs6/Mc9bHAJpUijStO/fGgSUpzYlHcaSy4g95
 xSMRxAnEqCiN9TU8Ws0Kj1oMi7H83yFur5JxDTYZSnFaOA2VphCPsCrxIzaDQBJgW/K8fodcj/v ebvGEwe9xhO0GYPmz4hkD3EE8OPqXGKgtuKtDkrNSQw9vT19xSLo3Y6os5fp2JnaJxAcoJBqXYd aJTGL5E+Y3hN+bbtcWjLfGMmu+GhvZDIQv7scMmc8pjeVdsRYt1/uMrh686N/rnbWSm7E1nt/gW
 6dpadsu9SC35ISOZb6T5UvJB13GB9LSeecZvdBHsOOOn5HFefuLeA8BkQUmw1A/dm2XXAce9
X-Authority-Analysis: v=2.4 cv=FM4bx/os c=1 sm=1 tr=0 ts=68402ace b=1 cx=c_pps a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=1XWaLZrsAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=23bUkPZOOvTO2IcE9GoA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13206



On 02/06/2025 23:44, Sean Christopherson wrote:
> Reject migration of SEV{-ES} state if either the source or destination VM
> is actively creating a vCPU, i.e. if kvm_vm_ioctl_create_vcpu() is in the
> section between incrementing created_vcpus and online_vcpus.  The bulk of
> vCPU creation runs _outside_ of kvm->lock to allow creating multiple vCPUs
> in parallel, and so sev_info.es_active can get toggled from false=>true in
> the destination VM after (or during) svm_vcpu_create(), resulting in an
> SEV{-ES} VM effectively having a non-SEV{-ES} vCPU.
> 
> The issue manifests most visibly as a crash when trying to free a vCPU's
> NULL VMSA page in an SEV-ES VM, but any number of things can go wrong.
> 
>    BUG: unable to handle page fault for address: ffffebde00000000
>    #PF: supervisor read access in kernel mode
>    #PF: error_code(0x0000) - not-present page
>    PGD 0 P4D 0
>    Oops: Oops: 0000 [#1] SMP KASAN NOPTI
>    CPU: 227 UID: 0 PID: 64063 Comm: syz.5.60023 Tainted: G     U     O        6.15.0-smp-DEV #2 NONE
>    Tainted: [U]=USER, [O]=OOT_MODULE
>    Hardware name: Google, Inc. Arcadia_IT_80/Arcadia_IT_80, BIOS 12.52.0-0 10/28/2024
>    RIP: 0010:constant_test_bit arch/x86/include/asm/bitops.h:206 [inline]
>    RIP: 0010:arch_test_bit arch/x86/include/asm/bitops.h:238 [inline]
>    RIP: 0010:_test_bit include/asm-generic/bitops/instrumented-non-atomic.h:142 [inline]
>    RIP: 0010:PageHead include/linux/page-flags.h:866 [inline]
>    RIP: 0010:___free_pages+0x3e/0x120 mm/page_alloc.c:5067
>    Code: <49> f7 06 40 00 00 00 75 05 45 31 ff eb 0c 66 90 4c 89 f0 4c 39 f0
>    RSP: 0018:ffff8984551978d0 EFLAGS: 00010246
>    RAX: 0000777f80000001 RBX: 0000000000000000 RCX: ffffffff918aeb98
>    RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffffebde00000000
>    RBP: 0000000000000000 R08: ffffebde00000007 R09: 1ffffd7bc0000000
>    R10: dffffc0000000000 R11: fffff97bc0000001 R12: dffffc0000000000
>    R13: ffff8983e19751a8 R14: ffffebde00000000 R15: 1ffffd7bc0000000
>    FS:  0000000000000000(0000) GS:ffff89ee661d3000(0000) knlGS:0000000000000000
>    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>    CR2: ffffebde00000000 CR3: 000000793ceaa000 CR4: 0000000000350ef0
>    DR0: 0000000000000000 DR1: 0000000000000b5f DR2: 0000000000000000
>    DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>    Call Trace:
>     <TASK>
>     sev_free_vcpu+0x413/0x630 arch/x86/kvm/svm/sev.c:3169
>     svm_vcpu_free+0x13a/0x2a0 arch/x86/kvm/svm/svm.c:1515
>     kvm_arch_vcpu_destroy+0x6a/0x1d0 arch/x86/kvm/x86.c:12396
>     kvm_vcpu_destroy virt/kvm/kvm_main.c:470 [inline]
>     kvm_destroy_vcpus+0xd1/0x300 virt/kvm/kvm_main.c:490
>     kvm_arch_destroy_vm+0x636/0x820 arch/x86/kvm/x86.c:12895
>     kvm_put_kvm+0xb8e/0xfb0 virt/kvm/kvm_main.c:1310
>     kvm_vm_release+0x48/0x60 virt/kvm/kvm_main.c:1369
>     __fput+0x3e4/0x9e0 fs/file_table.c:465
>     task_work_run+0x1a9/0x220 kernel/task_work.c:227
>     exit_task_work include/linux/task_work.h:40 [inline]
>     do_exit+0x7f0/0x25b0 kernel/exit.c:953
>     do_group_exit+0x203/0x2d0 kernel/exit.c:1102
>     get_signal+0x1357/0x1480 kernel/signal.c:3034
>     arch_do_signal_or_restart+0x40/0x690 arch/x86/kernel/signal.c:337
>     exit_to_user_mode_loop kernel/entry/common.c:111 [inline]
>     exit_to_user_mode_prepare include/linux/entry-common.h:329 [inline]
>     __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
>     syscall_exit_to_user_mode+0x67/0xb0 kernel/entry/common.c:218
>     do_syscall_64+0x7c/0x150 arch/x86/entry/syscall_64.c:100
>     entry_SYSCALL_64_after_hwframe+0x76/0x7e
>    RIP: 0033:0x7f87a898e969
>     </TASK>
>    Modules linked in: gq(O)
>    gsmi: Log Shutdown Reason 0x03
>    CR2: ffffebde00000000
>    ---[ end trace 0000000000000000 ]---
> 
> Deliberately don't check for a NULL VMSA when freeing the vCPU, as crashing
> the host is likely desirable due to the VMSA being consumed by hardware.
> E.g. if KVM manages to allow VMRUN on the vCPU, hardware may read/write a
> bogus VMSA page.  Accessing PFN 0 is "fine"-ish now that it's sequestered
> away thanks to L1TF, but panicking in this scenario is preferable to
> potentially running with corrupted state.
> 
> Reported-by: Alexander Potapenko <glider@google.com>
> Tested-by: Alexander Potapenko <glider@google.com>
> Fixes: 0b020f5af092 ("KVM: SEV: Add support for SEV-ES intra host migration")
> Fixes: b56639318bb2 ("KVM: SEV: Add support for SEV intra host migration")
> Cc: stable@vger.kernel.org
> Cc: James Houghton <jthoughton@google.com>
> Cc: Peter Gonda <pgonda@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>


Reviewed-by: Liam Merwick <liam.merwick@oracle.com>
Tested-by: Liam Merwick <liam.merwick@oracle.com>

> ---
>   arch/x86/kvm/svm/sev.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index a7a7dc507336..93d899454535 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2032,6 +2032,10 @@ static int sev_check_source_vcpus(struct kvm *dst, struct kvm *src)
>   	struct kvm_vcpu *src_vcpu;
>   	unsigned long i;
>   
> +	if (src->created_vcpus != atomic_read(&src->online_vcpus) ||
> +	    dst->created_vcpus != atomic_read(&dst->online_vcpus))
> +		return -EINVAL;
> +
>   	if (!sev_es_guest(src))
>   		return 0;
>   


