Return-Path: <kvm+bounces-51278-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C1485AF0FEC
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 11:27:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C7D9B188D3B1
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 09:28:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C807E244697;
	Wed,  2 Jul 2025 09:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="X06xgogz";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Ix5QF7g6"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3868B23643F
	for <kvm@vger.kernel.org>; Wed,  2 Jul 2025 09:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751448468; cv=fail; b=b54Fi/ibGY+YDQNSZsx+ijv09FBiU7OsVnBvrL8z6eFL4e1PXAvonPBiI4QHnqOHwZwXz/v22RuZxTHgXMy8e2c1U4lY3nqTiEam4V8oH2OxfUaKKLVmGidinLGpz6NWzFS3tkn/gMboSJJbQdd4angBgC9HcQuZufOv50n99M8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751448468; c=relaxed/simple;
	bh=RjxZBHocvAM2+BnuiTUkGCt9ycWqhoB55d7qrXPdfB4=;
	h=Message-ID:Date:Cc:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=QGhBqMxC/d4fPadihDap2YmsH63O55NleJ7K928uuslpadSBQ/UOXjHO0ngJbysBEtjpuETOybdBwaxbGRenyZWmdS1QnyNQ4p1EkX/YTgKcphNLwpp0nZ7WX73GxMHNUXww9RvyjwOnBsTGBeyU/6MmeLWk9HH+GbKtNaoCNHQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=X06xgogz; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Ix5QF7g6; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5627MoPN025768;
	Wed, 2 Jul 2025 09:27:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=hYS2EPK0b2Nzw89B129lCNdOmTM4oOkDIvyyS5Y/oOg=; b=
	X06xgogzxJeaC2Or4F6SFGfApjWbYcGJpzqJ7TEGlYNdcfxhykpazdT38Rodp9HB
	1le29RQX5v/2br21E6hhUVhe9rYgU+30lepb/AkDTE1KxvCLISfowS2JpnJCsSuq
	oZBYXa0/+AZF476oQsEdNjuNIAl7IB1yfd9hZAZGGYxuRowmNOH+9y46lyXyHd1v
	wGX6a55ucwMrxSKwjD3F8y0gbPD9M2ItdXqiu5GiJ+Ij4mqUQixPV5vo/tko5oe9
	9t+6f9pSbCNmLZJ3Biz9C+wlm+6zBLj7uGQO37aATPWub+txJ9u7hopEzGHPPX5n
	AOBO541W0k6rI4CRA/ZuWg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47j766ek0x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 02 Jul 2025 09:27:30 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5628Lg73019283;
	Wed, 2 Jul 2025 09:27:30 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2073.outbound.protection.outlook.com [40.107.223.73])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 47jy1fqxtc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 02 Jul 2025 09:27:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=womDiLVz5MNXYVgUMz86njFJmZ7D2+dfF/ldjOTFptX3SzdPs45pCjmbaGDyUf7R1fWqy4MzWv+ZPTGbjodojZTw9ix4zPG/hQElvxL7mt2aFH6Jt4KvP2q/CPOlXTRcrRRmA3v/cchw++B51O7tv2OoMLmgPB0SLfta6XRD6ybUB1CBD46zyQmAqNr7RliYXCSkEGNl+7140kMdy9WJLl4dLdknZHHoi2LzHJEwU9ItNJ6APjIZYs4i8xs4UF5qtkdq51mRd9fJae8rKxWz814kf890Xu/LaNMrDJM8uYE+pPQcNndql9EE0PjyL0Jph6zbkqsh4uPIJDbLuphlHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hYS2EPK0b2Nzw89B129lCNdOmTM4oOkDIvyyS5Y/oOg=;
 b=iQeIHz20tubtW4U8EhHSzobEyn47zDtZM/dlvkB6SSfiZ4Mkuun9Hk+Kc5S+OZiouIENPqdbnJ0oPrKAmcyhJgnuYnv7ddQm5c37TNr/1egFbi29iNTkl7buuQWtinwMv7QQGklNtJ09gFU7M2u/ytGzVnyuNh4sp6aygrg0wRZRkS5WTp4ATcZC/+GIxy8Z6BAV1nZ8xhJQhsXiAMlaGXvAJJNgjGQgUmpBbrbaoAR9lJojJsra7oLmvdVE4oZW9jPK0K2uqMrEWYG7LIB2a/pN9KBAF47l1YwXJMrL24Eyn5JU0HS6Kkk0I0Mv1Q4fFsDCdIYvTWlz9GLI2keRTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hYS2EPK0b2Nzw89B129lCNdOmTM4oOkDIvyyS5Y/oOg=;
 b=Ix5QF7g6+SOuXGn6rwltmwuFEi1WEbz/zkL6oMYwUVbB1wF2ZRnqoDIerTd39zNFKM3XYK1LR39UkRgpa/yqq3O2aV3XUTvv0YDS2MDpZFAnGAlDvHBp6B1RujhhhaUkhw7YrEEkqizP3PvpeYzlZEnxHtXeRYi8TYm3zcI3uxw=
Received: from SN4PR10MB5622.namprd10.prod.outlook.com (2603:10b6:806:209::18)
 by SA1PR10MB6344.namprd10.prod.outlook.com (2603:10b6:806:257::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.21; Wed, 2 Jul
 2025 09:27:28 +0000
Received: from SN4PR10MB5622.namprd10.prod.outlook.com
 ([fe80::6bce:37ef:d1de:d084]) by SN4PR10MB5622.namprd10.prod.outlook.com
 ([fe80::6bce:37ef:d1de:d084%7]) with mapi id 15.20.8901.018; Wed, 2 Jul 2025
 09:27:27 +0000
Message-ID: <b01ff0a6-a456-4a6f-8490-f79cf626f727@oracle.com>
Date: Wed, 2 Jul 2025 11:27:21 +0200
User-Agent: Mozilla Thunderbird
Cc: alexandre.chartre@oracle.com, Xiaoyao Li <xiaoyao.li@intel.com>,
        qemu-devel@nongnu.org, pbonzini@redhat.com, qemu-stable@nongnu.org,
        boris.ostrovsky@oracle.com, maciej.szmigiero@oracle.com,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] i386/cpu: ARCH_CAPABILITIES should not be advertised on
 AMD
To: Zhao Liu <zhao1.liu@intel.com>, Igor Mammedov <imammedo@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
References: <20250630133025.4189544-1-alexandre.chartre@oracle.com>
 <aGO3vOfHUfjgvBQ9@intel.com> <c6a79077-024f-4d2f-897c-118ac8bb9b58@intel.com>
 <aGPWW/joFfohy05y@intel.com> <20250701150500.3a4001e9@fedora>
 <aGQ-ke-pZhzLnr8t@char.us.oracle.com> <aGS9E6pT0I57gn+e@intel.com>
Content-Language: en-US
From: Alexandre Chartre <alexandre.chartre@oracle.com>
Autocrypt: addr=alexandre.chartre@oracle.com; keydata=
 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
 swLliy6PdpST
In-Reply-To: <aGS9E6pT0I57gn+e@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR04CA0114.eurprd04.prod.outlook.com
 (2603:10a6:208:55::19) To SJ0PR10MB5630.namprd10.prod.outlook.com
 (2603:10b6:a03:3d2::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN4PR10MB5622:EE_|SA1PR10MB6344:EE_
X-MS-Office365-Filtering-Correlation-Id: b3237b49-e278-415f-f2b3-08ddb94aa872
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|10070799003;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TDZrd2Vhc2JWV0dod2lJYng2TnJKd3E0VS9NTThhUmFHTjd2UXFuN3lseU9j?=
 =?utf-8?B?Q3lnbHdmZElzYVhCZ3dSVFZVZWJLdERRaTE4UDJGTUc5V1FCRnVvK0tuRmVV?=
 =?utf-8?B?RXJuMytOMXlnM2pDS1h4RHZ4T3BVRkpEQWQ1QVhnSHFRejFnazhDVDdlZzBh?=
 =?utf-8?B?UGNGVTF5VERhMG8wbE9BZk9uQlJPS2pHYzVKc2k2bWlhTjNaaVhoSzJITkRt?=
 =?utf-8?B?RFA1azVnMkJEZDFRY1llS25ETzVXVFp3K0MzcExSbUF6L2dqVTc4dU94SjAz?=
 =?utf-8?B?bDVjRDFFWDdkL2ZiZlpzVmxqWUd3aDFNVkZ1aFVSRG8zeHNBUVNzMlZHaFJK?=
 =?utf-8?B?UlhjN1ZhcUdhR2NySjZmcThBRUJ4RUVYSHJMNlp6dFFEVGJjWVEzdFhkVitS?=
 =?utf-8?B?dG9QdVJzVllSQS83UWVFaklxMmR3d1dCKzB2L2svcEFsSVFnUzROVTc0ZEkv?=
 =?utf-8?B?MUJsUXZ6TVd1eW01REJEcTRoUUl3bnBpY0kyWnZmOEFRd0lweDFGNys5NjFS?=
 =?utf-8?B?UFRqOTROTkxJNXkyYUJEZ0x6a0hyYkh5Q0t5VG4xaEtRNklIcWhGZ1p5aUtk?=
 =?utf-8?B?bVFiL0tKcTFFWFdabjE0ODVGVEw3L3JsS2pwTkc4ZUc5UUJpL2ZWa2d4MkVx?=
 =?utf-8?B?SW12bWFRUWtVa1FHTjgralNKakwxRHUvNlE4cGRVS3hNVVF1QjUzQnVEc0Jq?=
 =?utf-8?B?VE1oYjNhZnhUbUJhQkJlV0pab2w5aHo3U00wK0lUVkdqcEZLd2ppY1FIQlV3?=
 =?utf-8?B?cERIeEptWStyb1lYVlZvbWUvN25EWHVCQ2E4SW5rWlhIOW14OWcxSEtLc3U0?=
 =?utf-8?B?S2pjL3k3S2RManFFMU9HQ1owTUsycHVzb1Fma2QzQk0rWFhKL3VFaXdoTXFU?=
 =?utf-8?B?dHczZEhSVS83K2JIN0tPaFVyUzF6a3NUVzA1Mm9kZlZKUGZhNlVpbnBDQU02?=
 =?utf-8?B?L3N3c25SdUZiUDFqYXd6K3pGcEluT2FPb04ybW54R1E2RFdPOTRwY2xqclhC?=
 =?utf-8?B?VE5BQVIyZm9HWm1oSi9hZ2lvYWROb0VybEE1RVFHU2ZqODFYb1JXeXRDZmRW?=
 =?utf-8?B?d0JsRlhjQlFqZ1VibUJqamJGQTV4enB4SnBGVkpkTFAwMGk2dzFvM0Y4SGYw?=
 =?utf-8?B?WFJwanhIWTZVWk1wMmJFRHZoVnFEaWIrTzQ0UUhLNUc2eDJJYlRFellxOVFT?=
 =?utf-8?B?SE42VGJRV1hOWitEaWpMSXZBVVdQb09pSVhZVjc2UVptbVVEenBSOTBDZFh2?=
 =?utf-8?B?WlZiTjA0dW83MnJNTTI3NElmdTZQUnVTUGd1V2g4ZWhqTXA0YlhjT2V0d3hn?=
 =?utf-8?B?ZFV3aVQ4QnY0UmdBQ3lJUXdmaTEzMkc5eGVFYXNDdDhrNGw2UGlBOUx3dkMz?=
 =?utf-8?B?SnFoTmlqVnVDZUU2M0RIblVhcTU4dXU4MmdoanBVVW1sckg0QStHR0xpWkVh?=
 =?utf-8?B?ckxFSTlZTjZWM2NBYU0zMDB0ckV4T3RDQkxRVmU4NS9YS2NoYWV4VndFUld5?=
 =?utf-8?B?NXZtc2xVUW0wK3BBZytNb3QzODBHOFd3V3RTSzlvWVZvdDE2WU1GMmQvN1dU?=
 =?utf-8?B?N2tta09KSW9iNDVNNmhITmVqWW9NSzBKSHpnZVM5MWd1MEE0aFptN1h0NlZx?=
 =?utf-8?B?TmlET2VUdm1odXV4NUNQZE9FYXZYdm1JemJkRFJnVzJZakhSQWVIcUtQdEtZ?=
 =?utf-8?B?aVBscG1yTFZWRUJjVUhVY29qUkxDS1ZZUUVtTks2a3VDNExLUFhuN3dORFRP?=
 =?utf-8?B?YzdsUmQ0a2R4N3VmcG5tWDJFU1kyMnh0dGY1RVJRME05Rzc5aC9UWXRkUjdS?=
 =?utf-8?B?b2o5NERYY2w0ZE9jbE1MdExXWDhaNDU3M1dyWmZUNFVUcGN2RXB0UUtNUjVJ?=
 =?utf-8?Q?Fz+WUowPM6U0l?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR10MB5622.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(10070799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QktrSWxiY3N5R0dQRE12UFpKYkJmSzUwMVRtK3MyZmw4RlpqRHNhbTc1Nzcv?=
 =?utf-8?B?ZnNROCsxUUcrT3lCbjdBSXUwa3FtUUdOamZ1Z0JYcDVkbnljM2hnc0o3MGhi?=
 =?utf-8?B?MUtXenJwM21jU3FOT2JPU0xvak85OE9SLyt3VU45Z2p0VGVEV2pQNlNTYjRx?=
 =?utf-8?B?c2pkazFTSXR6a0llU1pVVjdsZjlEQmE0S2lWa1h3Q3UvOFlJcmx6YkxWRUJY?=
 =?utf-8?B?d1ZQRHVscUptNU5QbkEzTVpzTS9UcWwzN0FBWHNRNFZmMGdGUHVWVTdUQ1p5?=
 =?utf-8?B?dzFuemdLM0JUQkJsU2JVRnBKK3ZhU3ZneklyaG9xYTc1a3k5OURIUmpSWW50?=
 =?utf-8?B?cXBuUjVTbGN0bTJiR0padHZwTFdmYUtndHlOU0ZkbjVnWmdxTmRUVkNwa3U1?=
 =?utf-8?B?R2hrMTlQbXBsNjd6THlqZXhrWEI2R2RJLzcrVlAybEFZemVWUDNiQWNwclFT?=
 =?utf-8?B?MUtXOVJoa2M0SGlTU1lIYzNWOEZGS2tzQmlRMXFBWjV1ajBrUUp4dEJSeWdW?=
 =?utf-8?B?alU3YXNiM2ZYOWZKWnA2NDhkWDBsWXd6QktyZEtGeE1TRE5KYU9Td0JJbUpI?=
 =?utf-8?B?K3VRQmludzRQS2J4Y0VRN09aMHNDcDVXZ1pZN0YyVzljWlVERUZjL01Kdi9u?=
 =?utf-8?B?YnB3ZkhSeWhTZG9TK3AxSFBudE1naFlNVC9NYjRPWnZNRUNzdWUwZ2pnZ2di?=
 =?utf-8?B?a2srbGV0UDIvQmZyS2w1dGE4TXdNZGEzRThMKzhGQ1pwK1ZwSzYzcFg2YjB1?=
 =?utf-8?B?QTh4MXRMV1ZmM09OOFpndEg1SWdjUlpEUU14RDErNlhEQXR4dEo0MkhPdUZY?=
 =?utf-8?B?RVh3WHV0WHBXQWF5Z3MrMTZqV0c4QkpHYVJZaGZqTHczbkRqRWNjVzlLTEcy?=
 =?utf-8?B?Tk5PSnFiOXZGWEd3anFXWGhVRjlmMUVjVFN4QmRTNnNZT3g1UDQxYXE5eFRx?=
 =?utf-8?B?RUN5L1hHUE1Kem1FTTZNZVVFdEpxMmtudXluZ2xOK2hPeTE0aXFYK0VEMXdC?=
 =?utf-8?B?TU5EK3AwOTBQaGpKZ0xWOE14RW1RWFJPTzJEYVpicDZmRXdtQUNEdlhzNy9N?=
 =?utf-8?B?aVZKQ0FSTHRvWlJ1YzVLR3VOSFloRXdTM3lWeis3V3p0WlBEemVRWWdsZHdO?=
 =?utf-8?B?V2xSWG9WdmZVQXdEdXBKaDI0WmVtQVE0OXFXL1BCWVloL0s4MlgzVVZncTQ1?=
 =?utf-8?B?TGlxVldBdmlqdjZSVlovS1hsODFmUVpzc210bWtWT0wvYzFQS1JTSDY2STRP?=
 =?utf-8?B?UWVMeEhKUHVBSFhCL3RqSmFkZTdVeDF2NTZMS1NtVVJjRjVQSTBibDR6dzQ2?=
 =?utf-8?B?SzdnNmpNWDRjMnZXZlVKaUFJeHB5T3VoejZzbWtaVXJyWG81N3NrUENrcDdk?=
 =?utf-8?B?K0FPcS8zZGExVXhQUEhXN3JiSWxOdTZITmJDL2F3R3hIRzZnaHpmbmc1NDYv?=
 =?utf-8?B?SjIyVVYzM2hvMmRHNjQ4aTFnSlphaUw3TkkvTkovaDdYYUg5WGxTUWN6VnBZ?=
 =?utf-8?B?MXYrMXhQSFIxRXk0NytoYWR1U0VCa0o2cmlNSlQ4Y1lyQ3JzM3RwWk10SXNp?=
 =?utf-8?B?eU1vRXZLc0lHN09HeW9zN2NNV1M5VjZYVFhaM1ZUK3luMmN5SmVvS1ptYnUv?=
 =?utf-8?B?WFBJM3Y4a3M5enM0NGtaRnJ4U29NYnNUNWNuN3RYU2F3ZE1PYXFnQ0lvcUNC?=
 =?utf-8?B?eWRBc3ZwWjdnKzZuc1pVa0E4VjZYNUZLdGY2NzgvNS82RGtwTjkxeHg4ZTVr?=
 =?utf-8?B?VFpBZ3RzOG53NnJkeGk1VlFIL2RuUzlXaHZFWGppdDMyMmFtN1ZUQm9QT29m?=
 =?utf-8?B?Wkt1QnBuMHFVTmp4WXI5VHhrSnc3L0lmRlZoNS9zOWpGUTJadktOa3d0M3Rq?=
 =?utf-8?B?QzZrWCt6RnlyTkF6clVSbDBZUWF1bGp0RjFaTzcrZksyNm9oTytzSkhkVFZn?=
 =?utf-8?B?dXYvQVEvQSs1UnBNYXZSaFZza0EwZ1J0aDIwY1ZZS1BmT2RjOU1HaVVkRXEz?=
 =?utf-8?B?SnYzbHhkaXJocWgxK0JzQlZwbkttaUNoTHJCaCsxQVlKZ1IrOFdlWEZBOTls?=
 =?utf-8?B?T2dTU2ZLaFlHSXJBYWlWMTFKZ01QVEJPdVNjbHc4N091SEIwdGpIRW9lcFBD?=
 =?utf-8?B?MHZmRnpyWFEvSmFMWHdxcTBrYWpDenc1S2tuWWRNekhvRHpLU2t4NnVKbUFP?=
 =?utf-8?B?dHB0R2NWN1hDZ3RSWjBNVysxN3phQ3RDNkUwMWhaWDRrelJRbzE3UGFJYURG?=
 =?utf-8?B?elEvc2lBaTJXa3lLaERjUnhGVHZnPT0=?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	h+cO/E5xNciaW++X9WlCsZO/ZTozXpJPuqBLQNl9EeqH1XI7jn1yg5oW3Bpy/ZTKQiLzjnr3OmMq3/Unv+OTrigYZw/PkRSLRb8uDrR2pLu9TGgyC7CaHWV+QPVCY12wZJBVl3n75csygDXLkJUA9qAl3buw51Ygy7dgq/I5oYDq6IG5hPAdJM9SYSWobsRCN/ZmLILGkXAkOp9BAvqDh4By1DkfRK6f+Dxxszsd5/LaSJCGoRGJ0m2Ew8/rOHLqsr76Q70BCLvpcKe7YZCYpIiTNJ6TYLy4wDXL0VUeXXlFJCab+MlOVvR8hcdRC4Tw/aMTLgBPW5qkqrHwqq8PWTdMMO10tPUwbudnlpQwmEVyJItMs+ta6G+TZ2uKZ8nPsL4zyAM21Rlk7zs4gMZvUBMpEuQjYZjNYKctKWpd07SQ/fvx6VWMs2Q3ARsye5NtNn7I40DURSc3w+K0k6v8IBriURC2Ttq4ds+NLONyekoYZTWqbsYpI5dGVv7+vEMELSI1T4hMazyVpwZ5XbLVK0CBCsTKT2DmuFx0Gf54zQcfKNxR00qnGI2+rTavp7kn955LYVxJtyMXE37RW4yce2xS+9tX9J151+lWy8LcSWs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3237b49-e278-415f-f2b3-08ddb94aa872
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5630.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2025 09:27:27.4600
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AS6WRlCjAC4YnGxauOhlry9SrjYa0sEUWNXMWuwc1tNybJEqwglAYiPmycHkc03ZLZuGpJra4FWmpZgtBLW+wYYdlXSUdQLH6GYshiNEQs8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6344
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-02_01,2025-06-27_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 suspectscore=0 mlxlogscore=999 phishscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507020075
X-Proofpoint-GUID: 9mHPYvjINIaGO3Qbsr0CNBTBK-2MgEWC
X-Proofpoint-ORIG-GUID: 9mHPYvjINIaGO3Qbsr0CNBTBK-2MgEWC
X-Authority-Analysis: v=2.4 cv=b82y4sGx c=1 sm=1 tr=0 ts=6864fb82 b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=wGz7-fTsAAAA:8 a=s_NOnkg2AAAA:8 a=oR9o6jqiCfMVefq3Jk0A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=rnSQA9y58HElrkoqsYbd:22 cc=ntf awl=host:13216
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzAyMDA3NSBTYWx0ZWRfX0gvMyuTE3Oda Xj0AuEkZy1R70g/zHYLYIc+F1ed+i89/xjjyQVduDw8L2Fv0COT0cX8KOlCGXtxYxStjuxXEWro dL7tDQpugPLcSK+ZjnN+xel2nCLZ5PUvEQ2Z4b+YUZ29wQZtSi12Kx0uL9ltouYYm6K1eqG6J/q
 Fnaj96DwzEpzhg/rznO1iky93wN/k/Ow5NtPoKyjRLz02rRq8FTYPj5cgiLj5ns888A4uzqrPZt Bo2+Kz/+jpkPUS8tBikv/VDwQqgMo4sl0VGAQ80r6qs3Sm19HH3r3IScPPWl8LKd4zAyBnoDkqH vp5nIIQ5px4UR/OE8bxL+nDmr/tp6HCM+El8kGu6X8KdkNpKHbBJ5m541u4IB42PK9NS3L0p4pn
 mDjcAW7yJM+JguM9RwOwYWXn3Kw/b/Rdb+rfPoNbZXUZvUTzbpe51BygylhqNveZ5aIX/cI1


On 7/2/25 07:01, Zhao Liu wrote:
> Thanks Igor for looking here and thanks Konrad's explanation.
> 
>>>>> On 7/1/2025 6:26 PM, Zhao Liu wrote:
>>>>>>> unless it was explicitly requested by the user.
>>>>>> But this could still break Windows, just like issue #3001, which enables
>>>>>> arch-capabilities for EPYC-Genoa. This fact shows that even explicitly
>>>>>> turning on arch-capabilities in AMD Guest and utilizing KVM's emulated
>>>>>> value would even break something.
>>>>>>
>>>>>> So even for named CPUs, arch-capabilities=on doesn't reflect the fact
>>>>>> that it is purely emulated, and is (maybe?) harmful.
>>>>>
>>>>> It is because Windows adds wrong code. So it breaks itself and it's just the
>>>>> regression of Windows.
>>>>
>>>> Could you please tell me what the Windows's wrong code is? And what's
>>>> wrong when someone is following the hardware spec?
>>>
>>> the reason is that it's reserved on AMD hence software shouldn't even try
>>> to use it or make any decisions based on that.
>>>
>>>
>>> PS:
>>> on contrary, doing such ad-hoc 'cleanups' for the sake of misbehaving
>>> guest would actually complicate QEMU for no big reason.
>>
>> The guest is not misbehaving. It is following the spec.
> 
> (That's my thinking, and please feel free to correct me.)
> 
> I had the same thought. Windows guys could also say they didn't access
> the reserved MSR unconditionally, and they followed the CPUID feature
> bit to access that MSR. When CPUID is set, it indicates that feature is
> implemented.
> 
> At least I think it makes sense to rely on the CPUID to access the MSR.
> Just as an example, it's unlikely that after the software finds a CPUID
> of 1, it still need to download the latest spec version to confirm
> whether the feature is actually implemented or reserved.
> 
> Based on the above point, this CPUID feature bit is set to 1 in KVM and
> KVM also adds emulation (as a fix) specifically for this MSR. This means
> that Guest is considered to have valid access to this feature MSR,
> except that if Guest doesn't get what it wants, then it is reasonable
> for Guest to assume that the current (v)CPU lacks hardware support and
> mark it as "unsupported processor".
> 
> As Konrad's mentioned, there's the previous explanation about why KVM
> sets this feature bit (it started with a little accident):
> 
> https://lore.kernel.org/kvm/CALMp9eRjDczhSirSismObZnzimxq4m+3s6Ka7OxwPj5Qj6X=BA@mail.gmail.com/#t
> 
> So I think the question is where this fix should be applied (KVM or
> QEMU) or if it should be applied at all, rather than whether Windows has
> the bug.
> 
> But I do agree, such "cleanups" would complicate QEMU, as I listed
> Eduardo as having done similar workaround six years ago:
> 
> https://lore.kernel.org/qemu-devel/20190125220606.4864-1-ehabkost@redhat.com/
> 
> Complexity and technical debt is an important consideration, and another
> consideration is the impact of this issue. Luckily, newer versions of
> Windows are actively compatible with KVM + QEMU:
> 
> https://blogs.windows.com/windows-insider/2025/06/23/announcing-windows-11-insider-preview-build-26120-4452-beta-channel/
> 
> But it's also hard to say if such a problem will happen again.
> Especially if the software works fine on real hardware but fails in
> "-host cpu" (which is supposed synchronized with host as much as
> possible).
> 
>>> Also
>>> KVM does do have plenty of such code, and it's not actively preventing guests from using it.
>>> Given that KVM is not welcoming such change, I think QEMU shouldn't do that either.
>>
>> Because KVM maintainer does not want to touch the guest ABI. He agrees
>> this is a bug.
> 
> If we agree on this fix should be applied on Linux virtualization stack,
> then the question of whether the fix should land in KVM or QEMU is a bit
> like the chicken and egg dilemma.
> 
> I personally think it might be better to roll it out in QEMU first — it
> feels like the safer bet:
> 
>   * Currently, the -cpu host option enables this feature by default, and
>     it's hard to say if anyone is actually relying on this emulated
>     feature (though issue #3001 suggests it causes trouble for Windows).
>     So only when the ABI changes, it's uncertain if anything will break.

I wouldn't expect that any code rely on the presence of this feature (emulated
or or) because it is not available on some cpus (AMD but also some Intel cpus),
so the code should be able to handle the absence of this feature.

Also KVM emulates this MSR only to advertise that the cpu is not impacted by
some speculative execution vulnerabilities, none of which (except one) applies
to AMD cpus. So on AMD, the MSR always says: this cpu is not impacted by
all these vulnerabilities; but you can already figure that because this is an
AMD cpu. The only vulnerability in this MSR that can be present on AMD is SSB,
but it also has an AMD-specific feature to indicate if the cpu is not impacted
(and it is set accordingly by KVM).

Anyway, changing QEMU first is certainly safer before eventually changing KVM.

alex.


>   * Similarly, if only the ABI is changed, I'm a bit unsure if there's
>     any migration based on "-cpu host" and between different versions of
>     kernel. And, based on my analysis at the beginning reply, named CPUs
>     also have the effect if user actively sets "arch-capbilities=on". But
>     the key here point is the migration happens between different kernel
>     versions.
> 
>   * Additionally, handling different versions of ABI can sometimes be
>     quite complex. After changing the ABI, there might be differences
>     between the new kernel and the old stable kernels (and according to
>     doc, the oldest supported kernel is v4.5 - docs/system/target-i386.rst).
>     It's similar to what Ewan previously complained about:
> 
>     https://lore.kernel.org/qemu-devel/53119b66-3528-41d6-ac44-df166699500a@zhaoxin.com/
> 
> So, if anyone is relying on the current emulated feature, changing the
> ABI will inevitably break existing things, and QEMU might have to bear
> the cost of maintaining compatibility with the old ABI. :-(
> 
> Personally, I think the safer approach is to first handle potential old
> dependencies in QEMU through a compat option. Once the use case is
> eliminated in user space, it can clearly demonstrate that the ABI change
> won't disrupt user space.
> 
> The workaround change I proposed to Alexandre isn't meant to be
> permanent. If we upgrade the supported kernel version to >6.17 (assuming
> the ABI can be changed in 6.17), then the workaround can be removed —
> though I admit that day might never come...
> 
> Thanks for your patience.
> Zhao
> 


