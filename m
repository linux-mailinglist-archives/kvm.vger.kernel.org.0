Return-Path: <kvm+bounces-43011-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E5EE7A8240D
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 13:57:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 935DE1B65C35
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 11:57:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F31925E471;
	Wed,  9 Apr 2025 11:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ib5ByJwq";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="OMrxCFk9"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E089025D1ED;
	Wed,  9 Apr 2025 11:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744199814; cv=fail; b=oEuR0vjg0rxe2HXo1c7VP+meX2whWc0R10HAOpSaWA4qEbRINXgd8OROUFbKIULcj3POLC/C167gy9Jc1uAxF+ffwbC7RjBZKgfPL5cxV+uD3e1XsQDQRZEcMVRb4yXvD+3d9/Yvq9fuRAF28WDPFZNkQl5fA59d/P+iq1DrtEM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744199814; c=relaxed/simple;
	bh=4T091kRXh5L7tvg0IbBRZ/fwmBqbGdWtXrYjQ0BqC6Q=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=THAHRDHsO8+f0ZNSYQKRcUw4hpvyyi5IG8qdCF9mdnwUMJLwGMEoeL5gcPmy5IKwIhbEpOXLsGiqhBGOY1+KwY97gL2Q+dJGdM+0y9CpEdWIJ8Vzama/g5BvOMIqAkAdFsKPGJ7exH8YygwiW9SHEI9CV4PlSTvmKC/Jbe2XsH8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Ib5ByJwq; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=OMrxCFk9; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5397tvJT025293;
	Wed, 9 Apr 2025 11:56:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=RJx497SoHdOHQJBon5oJAdTaPHWPkz2Lm5v6Ph2zS0E=; b=
	Ib5ByJwq4d4ZjJpFl4JYqAT/eZ2Eo4fmNw4epwsTQWvdAc7hSJuMGhRkDOYvg1V3
	/DPdpJi1E1v7u3bXwkGRLViHIg+q/Jmv5FDah6lMpKCaSQA7Sf0n8KWL5ZBvvpcg
	DrYzklDeiH9wwLAlieh5eXgUEQ4QETLowNUjTBM5yI4nuK8hrrZ9QI47R/hM0g9F
	RHDZYkKBoUOy6SNhOni8mzWe0MGxkb5g7n4zHsTI7h8DUAIRAqqQdhtVpixxwy9J
	jtQM0sOOkLnlWXMYp5vW9IFsQfRspOiTzGsAshvCYUiurhUP8577vyaZnhNPyGEa
	beoLckap6aTnmbHR2G/vLQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45tvjcy1xt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Apr 2025 11:56:27 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 539BTXNo022201;
	Wed, 9 Apr 2025 11:56:15 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazlp17010006.outbound.protection.outlook.com [40.93.11.6])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45ttybedp2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 09 Apr 2025 11:56:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rG7pRs6ZQwTVAtBDp1Z5nZd0ErjkTkBJp0miWzDhTCwAZqJoWFGIAuw2hYK3tRJqUI7byCt3i/8Lyuk6ll9WxUJy7s550qxN8YqstUHdO14oShk26nOetO/1HV9oXFGPqIjwQ0FRGHu2pNE+fmBub4y/bbitdmuXMaqkdveDR0aORcXJ/QAE9pO06ChPha8ngyMDzoxAqWScxYgFIEznLNcR1BXdpzs1romFt6KHUcF7PNgLwTFKNaWufs5pyiQaZHp/y9tpEoiZFsDTBlmv4ssKl7Q4CSKrZFFtvjZxJPXvko6W80wreQIy2MhjdysGnRkM3lAwwQ+NLmFj7fcIqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RJx497SoHdOHQJBon5oJAdTaPHWPkz2Lm5v6Ph2zS0E=;
 b=xBKlUnJv8z3BDOfKtlFHWvYlqU2ZibEjIJ8a55YbgqgVi9xJPmSWCq8at2V3j4eN4BGR0NGq/+mSONa+bJEM6XmshtPWeN9RpnEnVt9dYcEVOmbncnX/q2SwIIF1fraoyl9g6BnxD94QjZylHFyuSrXDCu9VWM0bujUwZ0YeXAUeqWsMkohA3x565nCn7LHCf1HKINcDO8NXVTmeWN3/uEEiX51fxAHx0RCwM9FvNwa6/F8JcYk4l4+P+8otZ+GXlQzMJI++F3spaJLag4tEC3g9iKqIFGaMi/bwowaE1JRQAOQnlK90pOFpf6REEaP9yshX5LfvjqIV4DDejtnRlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RJx497SoHdOHQJBon5oJAdTaPHWPkz2Lm5v6Ph2zS0E=;
 b=OMrxCFk9nKif2EK5Krs3VryiDgUYhNHjJkG/kRGbx+ue4ocOvlszxOI3YjKw43f2Opdf99s8eLwrcw4aB2rSXcZ7b9NOunPH2aXCqsS6lfbaU95zgQVKyLA0BXmgK20pYCOmqVIl/VzZXhNsWmFaZJsbAjisaTUZlZvVj19UWY8=
Received: from PH0PR10MB5893.namprd10.prod.outlook.com (2603:10b6:510:149::11)
 by SA1PR10MB5711.namprd10.prod.outlook.com (2603:10b6:806:23e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.27; Wed, 9 Apr
 2025 11:56:12 +0000
Received: from PH0PR10MB5893.namprd10.prod.outlook.com
 ([fe80::79f1:d24f:94ea:2b53]) by PH0PR10MB5893.namprd10.prod.outlook.com
 ([fe80::79f1:d24f:94ea:2b53%5]) with mapi id 15.20.8606.033; Wed, 9 Apr 2025
 11:56:12 +0000
Message-ID: <9b7ceea3-8c47-4383-ad9c-1a9bbdc9044a@oracle.com>
Date: Wed, 9 Apr 2025 12:56:07 +0100
Subject: Re: [PATCH 64/67] iommu/amd: KVM: SVM: Allow KVM to control need for
 GA log interrupts
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
        Maxim Levitsky <mlevitsk@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Vasant Hegde <vasant.hegde@amd.com>, Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20250404193923.1413163-1-seanjc@google.com>
 <20250404193923.1413163-65-seanjc@google.com>
Content-Language: en-US
From: Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20250404193923.1413163-65-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PAZP264CA0238.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:238::19) To PH0PR10MB5893.namprd10.prod.outlook.com
 (2603:10b6:510:149::11)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5893:EE_|SA1PR10MB5711:EE_
X-MS-Office365-Filtering-Correlation-Id: 05b66d8e-b047-4f0f-aaf9-08dd775d8621
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TWpnZjgxYS9QQnAwT3RZU2RkNTNyZ3dKMmM1SHk4UktLRTQvaGh2OWNGbDdJ?=
 =?utf-8?B?ZXZFOG9Gck9mUDg0ZG85VHF5ZGw0aFNCbGxSamxJa1JHWUVJSVZPSTZFV2Nv?=
 =?utf-8?B?V2pNczRLYkE4V0JlYkJEazRSS2xWdXRKRUNNd2F4RUhzR2ZCWXIxWGc2R1Na?=
 =?utf-8?B?d0UzZytCUDhVU0hKY0VoRXg3YjZYMS9BQ3lsYjZFamo3b2xIb0RNV0cyVDBF?=
 =?utf-8?B?VFhiY0hHb1dxNkNHY0JGNXFHcGM4ZWtCeCs2MTJGSGhYR1ZXdUxkUkJWMXhH?=
 =?utf-8?B?TEYzREFBcWlGQnlrMFZEQ0VOUzZtYVlhemsySE55V0tmTCsvSXl5SlRNSlZ0?=
 =?utf-8?B?R21FU0pqTlo4elgxbzNXbzFDTzNuQVFKWkpyRzZOUGFvbE1HV1R1bHgyM3Bu?=
 =?utf-8?B?RTNudkdIVEkvVXNuWHJIeWp0UlFuckQ2U2IwYTFQNm5jODlhOXlYUmJJZHRw?=
 =?utf-8?B?eXNaOXlvV2ZJVjZGcU1aZWcvR05xekxla2xjL1IxYjBaa1dMdU9USThmN0ZQ?=
 =?utf-8?B?RkF1QkE0Q2FzUjJiUVhvMy9FZWJ0cjRvTUNOVER2WGpZdHdiVnZwSzQ1L1JO?=
 =?utf-8?B?dlYwZ2Z5RXFpdlFKS2toVDJyeUV4M3QwNWR2R3RuK1g0NVlUYlhHRXhPZlU4?=
 =?utf-8?B?YWZ1bHMyVXJSRThQU25XUG5WVzBOU1k2dG1QdjNZM1ZUVUI1NyttZkp2dGc2?=
 =?utf-8?B?ZkVnNkVLMDZqRnVwZDlHaUVKMkdMajhkbEdYcllLV3h6YVRyV0dKUEQ4dWUy?=
 =?utf-8?B?U0xCTXlMclI4eGxzaHBXRkVKU2tuK0NVRzZ4SnZneDZ1SXhQZk5JM0Qzb0Iz?=
 =?utf-8?B?M0MrVkVKamIzb3ZESHkwbko5M0I1cHpvSFdBaFhXckpxZ3k3MFp0NlZpc0lI?=
 =?utf-8?B?T1VvcUZsejRkejQ1SzV2elJaUDMvSTFod3JwbUhEZzdQNnhWWGNjREhlaHdY?=
 =?utf-8?B?TDFLNlFVV3hVUmllZ2FWeGxZWGJXRXBReEsrZ0NsTm82M0xxdi9scEEzYUFl?=
 =?utf-8?B?MEJHT2FJTnFkb1lMUjZnVk9KekR2ODZoY1dsQytLUXByV2xvQnNtVUdGWHZT?=
 =?utf-8?B?cWIyV0Z1eFIrN295NVVpRjBSZXFwN2JBeG1MaU5ac1JLT0p6c3hTcFhkOHc2?=
 =?utf-8?B?TmVxU0FQWU1sbjhKaGwvRDJLV3dNSDdqV3JCWlpYTDhuSGhzZElHYUFkV0ox?=
 =?utf-8?B?b216QkxNV2xjZVV0OXZ3RXk1UkFsR1N1Sk9SVDRsTm5aOHRsSlVFZmtkSzNP?=
 =?utf-8?B?TUJjenphdWpxTHAzTW4rdjJPMVh5Ty9nbUlBK3lMczRmbXFxWXlQcWNyMGxs?=
 =?utf-8?B?b2hjZzM4RUlrOVpPK054M2pwR3Jtc21FNVlYQ0x0dU8xbm1KNWtHc2dvWGQ2?=
 =?utf-8?B?bVZ1enZ5NjltQ3Q0alU1ZEhmcFJkR2JUSk4yUlJrdnpzOWpTSlRic0xsZkto?=
 =?utf-8?B?dW42dFVKRlc4cGtRUmM5V3JVNWxTQU1NeG9GbG1uK3FQb3ZZMklMNzk5aUhG?=
 =?utf-8?B?R0paMG9XS3Y3T1pFR2lrZko2VFM2dFRZMVUrZlBYczlNQ2dYdHB1dVJsQVEv?=
 =?utf-8?B?UFB4bmx6Q1RkUHlrOXpxenR5ZldkQzZOVEJKTXZucS81Nk53TzR6ZnB2N2pz?=
 =?utf-8?B?Mm9GVjIyUUFVNDhNNVBhL2NVUENkMFdHYmNmMzF6dk5oaitjNFVRUjZaako5?=
 =?utf-8?B?OHRWZzJ1eWZlbStqa0IvaXZwZ1JtSTVkRFFqNWMvTmY0ODI4cm9JYjBWR0RL?=
 =?utf-8?B?NDduRnluaCt1M1lGN0p2YnljUWplVlpGdC9kVVVBQktISEtyOGhGUE5hZVgx?=
 =?utf-8?B?RGtlOWxBM1NocG1FOXBxcmdUMGQzUnI2VFl3NjN6L0dhZmdJZHVzaHRNS0FZ?=
 =?utf-8?B?anJHTFE0MSt0SXVrMUs5Qzd0Z0NwZ2NCcmZCYXl0RVgxWFF2ZXFQMk4zTG1z?=
 =?utf-8?Q?znJXzBDNSB8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5893.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?U0pucHpvVzB3OERNVHQ2azBnVlY0WmFjQk1BZEZzTEw4c1lzU0g4Z1lqeFBD?=
 =?utf-8?B?NVpwNFdVSkZocTM2Zzk0bkJMVUU1SnQzbGViRFhyaXk1dW1nOUlSTllCcENR?=
 =?utf-8?B?N2Y3NDh5eVlib2tGUm9yaDBvZERYSkQxaDB4Q0tOOHdzYjdOUVRFQUNSWHdS?=
 =?utf-8?B?aDFHSm42UExHYVpKNW1Ea1d5R0hnLzc4Nm44Y3JoNU12ZitLd0FZZ2d0Lzdu?=
 =?utf-8?B?R24wbU5za25SNVBXblJmNDBjalhXa21lWFFnS3JYY1ZEdlUxckk0Vms3R0VU?=
 =?utf-8?B?ZmRRTUhLaHA1ckxDT1lPVkF0a1YxUms5M2pDK3ZRQUxjNnQ0anJtbElQWTl3?=
 =?utf-8?B?L1RhYSszRmVocTRpYk5sUHA5RWNGRUtRMGVzaTNVY04xb2xaMXJjLzhoYW5w?=
 =?utf-8?B?S2h1Tk5RVkJlditUT0laOVI1aVUyM2p2OVhiRU51UDlOTnZtcnh2Z0k5c3l3?=
 =?utf-8?B?N1AwWUlCZXRHRmx4TStBL3k2Qmx3R2FaZ2V4T1pXd2gyZFNxNGxUUis5c0lF?=
 =?utf-8?B?eFNlSjVUL3cxaitYZFNVT3dLMjZDNS9sQTk2L1Z2K1pLK2thN0RINktVZGFS?=
 =?utf-8?B?QW9hMjE4VFZzTitpWGtmQk9vUUhTc0VSRDFWSE45YW5wMWpTWG9IWC80Yy9B?=
 =?utf-8?B?UGQzTUNCeHoxMEFma3RybVZzUHBkeGZic2xaK3dyZ2FHWFZmRmkyd3dRRVpi?=
 =?utf-8?B?ZjhDeXh5eFJmbUc1dnVHdzdmdzJuVlV3Z1pLUS9wNjhXZDVBR1NialZmTWtq?=
 =?utf-8?B?V01ZK3J2ZEp0MlMxNGdYQTJCdVdmaDk0YnlSWXN1Zk9XTXk0b08zdFhwYmY0?=
 =?utf-8?B?blZZTGNZNVBoMnhCVEN4dE9YRHlrNFVtb2ZUK1F0Y1lCVm4wZmJZRDBHTUJV?=
 =?utf-8?B?UWo0a2xiUlR1OFV2MkVTOTBMdlZkbnNXV2F3azRBZmtkb3pRUnI2TXBmZ1Qw?=
 =?utf-8?B?TkYzZE5WNG9tUmdyTzZZejhVeWlvRnEyZFZmOHJlU1ZsdXZFMEJLYmpkM1Zs?=
 =?utf-8?B?RmRyZDhYQUpzTXYwY2hWKzZvY2xrazd4alZRdk1vd09aY0tQZURlS3AzQitI?=
 =?utf-8?B?VkVpRElvbm5IclJUTjFwQmlmdUhrQkhZQWlWUk1XYjlaWGVYdlVYNWFhUktR?=
 =?utf-8?B?TjBJKzFYVUpWVTJFdUkrQU1wcllTQ2VYV1pPN3A1WTEyeWtzcW9zdjlLVUxL?=
 =?utf-8?B?T0YwbU41RzhQcnd1aGxXVWp3VGZ2OXdHbWcvMVFIOXJHS25BVUdwSnJ3UVkv?=
 =?utf-8?B?TUFHcjRkdFhTRXFoOXkwb2d4YTdVam1XNXJtUDRrNysxdTBuVHN1d2VkdXBY?=
 =?utf-8?B?UzJtNjVOVGF3VzFUS1dKSXMwLzA0Yi9KclIvdEFpeWtSc2M2azFHYm82YTRx?=
 =?utf-8?B?NjVlMWFsVmhiOVBYM2tseFJhTUkwSXZlNnYrT00zVUpnaXltWVZqL2UxRjRs?=
 =?utf-8?B?QlE3ZldKcDRJVm4vcDVSU1dHVlRmdHVzcmdwRzVuOTVwYi93b0hwYXpkZFFh?=
 =?utf-8?B?aExqTEZmNHBXZnliSVpzdFZPV21TYUZEdXprY0lRcHRHWEM4Yi9WeHJvdXVm?=
 =?utf-8?B?cWRBV2w3VUJWK3NIMzkvWkl6Q1dSUnRraDdKNi9hMGlpaTlaMkNtYkFyOExa?=
 =?utf-8?B?WTB0MGJpNDVOVEFjbnlOWDNBZHB3NXlyN3hrVUlXVDR5ZUtsYktXeWQzQWdX?=
 =?utf-8?B?V0RGVzRRRHNDc0UwWHMvaG9LMVdxRjV3OWh2SGtsWWc0Qko2Vmg0ajl0Q3U4?=
 =?utf-8?B?S3kwdlp1cWF0U3VGNmY0NzA3WEdPT0hqaHVqNDltWVQ2K2VjM0xGdElIZWJs?=
 =?utf-8?B?VG5XeG1WUGpFYVhoVTdWbVRyRjFsSVdGWkNPVXMzb1NMV1J3WWdMTHZjVWFV?=
 =?utf-8?B?Q0FTbnNjSStuOTRMVjVUbjVFMGxpQi8wUStwanVkS1lsL3phazZOSldmWkY5?=
 =?utf-8?B?dmc2YjFDc1Rlb3lRR0pyeTVCVUlUOS8zSzVNeXowQkpXc2djOWtzbW1HdzRV?=
 =?utf-8?B?RlZ0MERFYnhMbmVDd1JlcFI2eGpUUm41Nnl3M0k5ZmxjTGpvbnZwM3A2czVB?=
 =?utf-8?B?RCtOWkFTazF6QjlsNkhNSDhsUkZsaWZMMGNubm5GWjZSZkl1WlFuTzdDVnhE?=
 =?utf-8?B?eXhIR3FoWXZXLzZtZmdtaG15R0UxcjI3Mnc3WXV5QmNYc21YOEFyM1dXODFN?=
 =?utf-8?B?b1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	XDOJSWIJPvijcJyUshp56MDUXifpCXLZ8OiGfoDOqOkcnjOUPIThJHNRLTuCOxCN7OTQrkNdsbJT5SeMWwcp429IxORqzTlBiMr33VaKg1PfjM1OteLHwIx9Ao1+hFgnAeb6k7IblSNHrXzcU/oHVW9IX3GSxhSo/aum2RM51H5+OaByI/6OfTTZ17cekkZOwTBScZIqb+apSPEgZN/6pXWSJen4lfGBpkIFg6+Bnbxx6o9UAJc6Zmczqum05I2P4s7tG4KTz1Q3x8TrQsjGvkCpvjUXnSLxQN6KytbRVvxykbCPo06YKEN+T9bbUfRVNiAvXfjRhksz586Gso2PDKQbFjnRz9fiqa/tZwY6h3VvUl8Sx6NaTUkynyTK00H9DLG0MPzGk1F341JRLquC9YrJfHh26iFFCLCEXsPcqNCPnSbByDcqM0xnAv9t2rJactShyqYTVkdxzuF0xRN8FwxcNOF/IL2h/ZKu7clmRwepk5bF7fkXKitEOWjjY3+VwWEzwP6hGdYKfwDsfePANpMOOKwzVxVuZEhlTl9MVmUUyCdaPUal2AE7LDOiJnd0gO5KNtMMrWD/44ZapDp3JCrf1kW2Sdcrbj7RIUZ8Yqk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05b66d8e-b047-4f0f-aaf9-08dd775d8621
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5893.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2025 11:56:12.5540
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k16nmGh7cJsNKe4osDmVAZk1Y7os86HXYp/CH07UWX5aLa5xvLVuUrxzEW/YWSOWr4n8Gn07cFEIfkJXggLKcbXViqgnPnq2LMUvW4WCabA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5711
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-09_04,2025-04-08_04,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 adultscore=0 phishscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2504090071
X-Proofpoint-ORIG-GUID: YsFUKzBC5D1LpDY1gXoErKdyGTA2e1kR
X-Proofpoint-GUID: YsFUKzBC5D1LpDY1gXoErKdyGTA2e1kR

On 04/04/2025 20:39, Sean Christopherson wrote:
> Add plumbing to the AMD IOMMU driver to allow KVM to control whether or
> not an IRTE is configured to generate GA log interrupts.  KVM only needs a
> notification if the target vCPU is blocking, so the vCPU can be awakened.
> If a vCPU is preempted or exits to userspace, KVM clears is_run, but will
> set the vCPU back to running when userspace does KVM_RUN and/or the vCPU
> task is scheduled back in, i.e. KVM doesn't need a notification.
> 
> Unconditionally pass "true" in all KVM paths to isolate the IOMMU changes
> from the KVM changes insofar as possible.
> 
> Opportunistically swap the ordering of parameters for amd_iommu_update_ga()
> so that the match amd_iommu_activate_guest_mode().

Unfortunately I think this patch and the next one might be riding on the
assumption that amd_iommu_update_ga() is always cheap :( -- see below.

I didn't spot anything else flawed in the series though, just this one. I would
suggest holding off on this and the next one, while progressing with the rest of
the series.

> diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
> index 2e016b98fa1b..27b03e718980 100644
> --- a/drivers/iommu/amd/iommu.c
> +++ b/drivers/iommu/amd/iommu.c
> -static void __amd_iommu_update_ga(struct irte_ga *entry, int cpu)
> +static void __amd_iommu_update_ga(struct irte_ga *entry, int cpu,
> +				  bool ga_log_intr)
>  {
>  	if (cpu >= 0) {
>  		entry->lo.fields_vapic.destination =
> @@ -3783,12 +3784,14 @@ static void __amd_iommu_update_ga(struct irte_ga *entry, int cpu)
>  		entry->hi.fields.destination =
>  					APICID_TO_IRTE_DEST_HI(cpu);
>  		entry->lo.fields_vapic.is_run = true;
> +		entry->lo.fields_vapic.ga_log_intr = false;
>  	} else {
>  		entry->lo.fields_vapic.is_run = false;
> +		entry->lo.fields_vapic.ga_log_intr = ga_log_intr;
>  	}
>  }
>

isRun, Destination and GATag are not cached. Quoting the update from a few years
back (page 93 of IOMMU spec dated Feb 2025):

| When virtual interrupts are enabled by setting MMIO Offset 0018h[GAEn] and
| IRTE[GuestMode=1], IRTE[IsRun], IRTE[Destination], and if present IRTE[GATag],
| are not cached by the IOMMU. Modifications to these fields do not require an
| invalidation of the Interrupt Remapping Table.

This is the reason we were able to get rid of the IOMMU invalidation in
amd_iommu_update_ga() ... which sped up vmexit/vmenter flow with iommu avic.
Besides the lock contention that was observed at the time, we were seeing stalls
in this path with enough vCPUs IIRC; CCing Alejandro to keep me honest.

Now this change above is incorrect as is and to make it correct: you will need
xor with the previous content of the IRTE::ga_log_intr and then if it changes
then you re-add back an invalidation command via
iommu_flush_irt_and_complete()). The latter is what I am worried will
reintroduce these above problem :(

The invalidation command (which has a completion barrier to serialize
invalidation execution) takes some time in h/w, and will make all your vcpus
content on the irq table lock (as is). Even assuming you somehow move the
invalidation outside the lock, you will content on the iommu lock (for the
command queue) or best case assuming no locks (which I am not sure it is
possible) you will need to wait for the command to complete until you can
progress forward with entering/exiting.

Unless the GALogIntr bit is somehow also not cached too which wouldn't need the
invalidation command (which would be good news!). Adding Suravee/Vasant here.

It's a nice trick how you would leverage this in SVM, but do you have
measurements that corroborate its introduction? How many unnecessary GALog
entries were you able to avoid with this trick say on a workload that would
exercise this (like netperf 1byte RR test that sleeps and wakes up a lot) ?

I should also mention that there's a different logic that is alternative to
GALog (in Genoa or more recent), which is GAPPI support whereby an entry is
generated but a more rare condition. Quoting the an excerpts below:

| This mode is enabled by setting MMIO Offset 0018h[GAPPIEn]=1. Under this
| mode, guest interrupts (IRTE[GuestMode]=1) update the vAPIC backing page IRR
| status as normal.

| In GAPPI mode, a GAPPI interrupt is generated if all of the guest IRR bits
| were previously clear prior to the last IRR update. This indicates the new
| interrupt is the first pending interrupt to the
| vCPU. The GAPPI interrupt is used to signal Hypervisor software to schedule
| one or more vCPUs to execute pending interrupts.

| Implementations may not be able to perfectly determine if all of the IRR bits
| were previously clear prior to updating the vAPIC backing page to set IRR.
| Spurious interrupts may be generated as a
| result. Software must be designed to handle this possibility

Page 99, "2.2.5.5 Guest APIC Physical Processor Interrupt",
https://www.amd.com/content/dam/amd/en/documents/processor-tech-docs/specifications/48882_IOMMU.pdf

