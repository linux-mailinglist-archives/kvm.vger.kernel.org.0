Return-Path: <kvm+bounces-29745-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 266689B1343
	for <lists+kvm@lfdr.de>; Sat, 26 Oct 2024 01:32:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9E9921F22B59
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2024 23:32:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CDB91EC011;
	Fri, 25 Oct 2024 23:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iyfyqEWe";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="sGQ2t0/+"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3F181C4A14
	for <kvm@vger.kernel.org>; Fri, 25 Oct 2024 23:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729899132; cv=fail; b=KIm6uZfrna/YI4p10hU85MtQ1NSXzPxz2OVIW79NAyUxUcneqn1/NQmmvO0mIh4haOYjEnbTvgA/65tr8fImpIUzu9mdmTipJsv1pSk+k77b4Kfm3W7Wg0MRCPYEGilp0He8acXviEA/EBl0jXQlAUfriBYfIfFgY+sS0pQRod0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729899132; c=relaxed/simple;
	bh=gmY/fyitivLcxhTBBil8Bxe9/ATZE5NpIz5Y3BXTYTY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=SNktYVVciNGNccp5XD/fdWtzT8dGzhGBvG/cbLwn9uxaBxDDPcGhFUHZdPbDjSPPtNwJLUrpfU5S3ViK2aKxb/d5iK/eAeytxI39YiDxP4YfVg0nvVWxgen1IcnqRxc1nmECJCpFfWFhVvbqswZs1Dcy2KRVJiVWAK1WIOo70Gc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=iyfyqEWe; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=sGQ2t0/+; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49PJdTeo009560;
	Fri, 25 Oct 2024 23:32:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=ZJOnPfoDAVeXy9clvo2zTSQantm4wqD/ZY37GPm963o=; b=
	iyfyqEWeeb7/9+lWT7B/pP97bMggbWBJ/Fu/s226D+Yfh9tSoTY8FYgsT526S/h0
	uCcelagGOhYBvjZT4nUhAGpnqDiQZ00a38wmX6KnzayjdQSVpBaE3a8GM6OqZXTy
	bYiF/Uua4MVvloFzd3klklVP8vtPPldN7qmUr4hJV7MzXh0cm2vGYuyc9UDyRS6U
	FJV06Z2hJUOONG5BbwtY6rJlcBTMhtTijEmlfu2ORvSLF2fYg0DDFbj+ewViQdyS
	z91e+du417NcY/DSris6LIaQ74HNYxO694wu2bxcnM3+1FhLobapFt7t4wfAFVJ5
	nQs6C/XKrT2pi/jBBAU4Mw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42c55v6316-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Oct 2024 23:32:01 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49PLUJYH016400;
	Fri, 25 Oct 2024 23:32:00 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2049.outbound.protection.outlook.com [104.47.57.49])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42emhefct2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 25 Oct 2024 23:31:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wUp1oGqT+uALfwAXMKt+e/EkVIWNbZT5OK/2QzXev/bm5eUbxB0CPkYIVEAnll9/jdT7KpU0DSsNTrob12NWlDIung/74Qp7zJcLL8+4vCpE8+MoWEl7bZHvbU+kNgKGp6vn/krJpTQuULA98fDFa78+i2jTSYiKhOZDnGs3QaE0nEeasbGcG1hzyt+AfOahLdIWf32D54TH6FMpqyjE8CEVaguDUZkuFMv7XevFTRC7bSWkkX7l/UbEfBOabY9I4/zaUkRP3/Nmf6M2bovOIAyDcM3xscmI31EpVd/5gqyBvTMBroVD55BQYJA1FCyXhJbf5hSUObSNCfMDnzzTHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZJOnPfoDAVeXy9clvo2zTSQantm4wqD/ZY37GPm963o=;
 b=M6oNoQAjxemDDdge7f23W+KWfoEIiOlnmQIo1cvi/O/rMrVjVLs7sQgKijoq7TLqPq+NBrPLMsrD16L+NOWYq+bW3f/cUr7OoXpRRZByftKnKMhd2sPXZOwAls9Vk3jexelqn0cRJ2XYRVdOu9EGHaNSD+Mzfbl3I8UfTbPrXc6Jt3LuzZZugpzOR2aR1OsFQlOtF1P2lcWDMHQNVfU3O/yJuHPwfMr7wGR8ljpXO4ueVO8AjY4bLlIEMTFHiwnndY6cQivHi0Myf2To1/D6jjy1E0VXaERPmByaEooOF4bo/bYYJYl+5ClpD8jDS5winqu0mE4995lPr4XBM2cwjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZJOnPfoDAVeXy9clvo2zTSQantm4wqD/ZY37GPm963o=;
 b=sGQ2t0/+hwBeoKUmpl2z7DywIRr62lbdbPviIX18poM2XXR1yrB+5SHa6DKB5fMU498QAbT1KFLEuloMZQo7CeO3WbCTuVHNRidlCtpQ2WYuzKQYwiAmu+XgfjqxjGZIDTA8gxclwrTpT23Zeg/PZ/sJxEGTrB7TvBSVD2Fi3WI=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by MN6PR10MB8141.namprd10.prod.outlook.com (2603:10b6:208:4f9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.18; Fri, 25 Oct
 2024 23:30:58 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%4]) with mapi id 15.20.8093.014; Fri, 25 Oct 2024
 23:30:58 +0000
Message-ID: <3404dceb-2baa-4ac3-8168-c87f3ed50b20@oracle.com>
Date: Sat, 26 Oct 2024 01:30:55 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/4] accel/kvm: Keep track of the HWPoisonPage
 page_size
To: David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: peterx@redhat.com, pbonzini@redhat.com, philmd@linaro.org,
        richard.henderson@linaro.org, peter.maydell@linaro.org,
        mtosatti@redhat.com, joao.m.martins@oracle.com
References: <ZwalK7Dq_cf-EA_0@x1n>
 <20241022213503.1189954-1-william.roche@oracle.com>
 <20241022213503.1189954-3-william.roche@oracle.com>
 <a0fda9e7-d55b-455b-aeaa-27162b6cdc65@redhat.com>
Content-Language: en-US, fr
From: William Roche <william.roche@oracle.com>
In-Reply-To: <a0fda9e7-d55b-455b-aeaa-27162b6cdc65@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PA7P264CA0481.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:3dc::29) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|MN6PR10MB8141:EE_
X-MS-Office365-Filtering-Correlation-Id: 222b9618-924b-4d69-de19-08dcf54d1421
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WGFjOFJBNTQyb3VRWjVCRVV3ei85Z1hJTlJVTFpGdy94dXZXU1ZHVFQwQXJT?=
 =?utf-8?B?WHZHUUpvaCtUdlBzQXpsWTNxNW5aMFFZSi9NNUZUT0cwTXI5VE5IWWpjR2Zx?=
 =?utf-8?B?b2lOMk9CdEZaR2xvQlBIS1lwTXJpVG1wZXVtS2p0ZlRkUW1SU1RYVWtTd0Rr?=
 =?utf-8?B?aUJKWmdONGczYVRiNSszZE1IWEIrQW5IQWRRZzN2OVo2YXc3SlBYQjRFd1J2?=
 =?utf-8?B?dmV0TWFtM2pXeUpnZkFBUzVCdCtMcmFDZDFYZStSSVBPRE5RVTFBWVBiVHZ6?=
 =?utf-8?B?Qkw2LzVDdUV5TDJGK2dGRDU4ZHJSd3JTdk1KYW1Iei93RHNlTUs0aFJOQUFy?=
 =?utf-8?B?YVNlUlIyamQxV3dxM1VzNStEVkRWQjVsR01qMnorSVE3SGJxOWh2QjJiSmZa?=
 =?utf-8?B?TGlLYzFRSklnS2Y0NUgwZFhueG42Z25xUkh0NUg3TEFLVXp6NHhWWWYwY25B?=
 =?utf-8?B?cFNvMlV0V1lyOG50d1BSNWc3dm9OTFB3dkh2K3dCVlZvdkQzUTk3ZENkbjhG?=
 =?utf-8?B?Q09oM0hBVTNoN2VUVXdDaUhjMGdRUHE2RFg3TXExM1ZvcHRpTkVKbEo3cThI?=
 =?utf-8?B?Nno5TkFUZmtZQmNveFhYN0s5bUZZRTZVK3UycUF1UXdBTEphN0VSNWN4encr?=
 =?utf-8?B?SkdTVVhTMUZtZU1RMmR5b0N2a1lMUmFGNU5sMFBHRm1jYjBsZnMvOGVoUmFw?=
 =?utf-8?B?OUxOK1V4K1kvSWlYcDZyaUd6N2pYQmhuOGI0ODBleFNGeEh4dlJlQndheFM4?=
 =?utf-8?B?U2wxOEp1OHVXdDN1VExNayt6UzNaZkV0bFd0NGV4Ny8vRnJmSnZ0VEsxWkM5?=
 =?utf-8?B?NS9vMTZ0ME00MXRvVVJDTHpsWTFSZnMvSm1Kd0Q4RDVKYVY5ZS9xMGg2QTFG?=
 =?utf-8?B?cTdSWHYxTFMrREFLc2huM2JKakx4VzBCQWZDYXNwRVd2M3IwbXV1K1E0VTFo?=
 =?utf-8?B?aGIybXV5VStvUElUYTJuZVIyYzVUZDFNOHFkclhVY2xjUUtLeE1LeWNRUEJJ?=
 =?utf-8?B?WjRNSnpkSUdGTFBBaEZDaVkyODBhb2pqS2ZwbiszVWo5TndYQWpsVHNxYm5E?=
 =?utf-8?B?S01YOGx0ZGR2MTBqVW53VXhUKzQzR1FpMENFWXlWL0xOMEE1UENGOEZ5Smpz?=
 =?utf-8?B?ZGJJWEJJdDR2cWVFTGZJejNVMkx5NEEwL095WlQ0K25yazRwV3ZmekkvRlFW?=
 =?utf-8?B?ZXlzdWFSdmZvelJSL3VjZG80VHhXU3pKR0xGczhoZkE3dnNkWDJaeDRFYlF6?=
 =?utf-8?B?R0U4dEJrUlYvWXZHNGYyL1pySVdHNHVqQ211NVFlUFVkdzgzUWpsM3hwYUg0?=
 =?utf-8?B?SiszbzVJWEx6VXNSd0taaVNpSFYxVkZZWk5HcWdLa2ZzVUhrYkZpbXg1ZE9t?=
 =?utf-8?B?K3Q2SmhJZVhFUkdmSkNjWWFnZnJkdUZ4RllGbmV3enoza1lVdmZlNjY3NnQv?=
 =?utf-8?B?eVp6YkZSNVdsbjJuWWx1SXduUXJwcVJvZ0tucm9BV1Z0S1NRbkFTVDZ4bDNB?=
 =?utf-8?B?Nk1CSm9SdkZ3M1h1WHJxVk0rK2Q4UDFNcDFaVGJyK2I4a212emJEOE9kUXF0?=
 =?utf-8?B?eDVOM3QremphTXNXaWswNmdpNTUydmpqL2RXcCtIWUVScXhUbHpaMDN3ZFgr?=
 =?utf-8?B?LytKSGlwTzVjUThIYjgxQmFoRG1jcVFHK1NVZ21qaGt1d0o0bTg3b3JEOXZN?=
 =?utf-8?B?dGlMNVdIaExJb25xZ253anp0emFkRlNDVFFFejQvbFJ6Ri9kSzZrZHpXNlV2?=
 =?utf-8?Q?0f6T9ScATcAXlDVD29iYVLU0etN8n1aimXdK2on?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eG81TTZpR2pQSDlvbEIwZmJYSjlKN09rYU80RzhDdVh2ajJuRkhMOGFmYSto?=
 =?utf-8?B?UDlocm1IVzRDenhmYU1XNnd4YmhEVTcrVEtUNUgwQS8zZFo4YzNiQmNmUVZy?=
 =?utf-8?B?N05LNlFheE0veHBuRVAzY2duSXhnTzYrbmlZQldmc0tMaTV5eU9RNmNzMC9i?=
 =?utf-8?B?SXJTcHY0MzZiV2d3bTU3REROaUI5WkVHdVAvRGtnc2xTaStIR0tZbTc3Y05a?=
 =?utf-8?B?cXVjd2Y2amVoWmp5bHpJWTBCdVZtbXNOV3FtbzF5QmhWL3JMVEJyOVdrYzJB?=
 =?utf-8?B?L2VOdVhGWFZhTHpwZGlCYnlQbTV6UkZOdm5RUDlFRktZalZaU0YrS3EzWGRu?=
 =?utf-8?B?UWZYSmk0KzRyRUZJeEU4cGYzOUNvRCs5S3dJVng1QXY5Y3FhcGNEQ0xQMjl0?=
 =?utf-8?B?d1dINVFNdVZkbStmZ0xtRVZTRGduRnl2LzJSL3FaMit2YlMvdVhYTkRGaTJm?=
 =?utf-8?B?cURVNHYyNW9jSXhSS1dyWjY2aW41SnM1aDJlSEZTcUs5SkV0QkZoajIxZnFx?=
 =?utf-8?B?SmtVaW1DTmRGYndEZGhHYUFEdllEb2ZBNFlpZ0MxWDJsTXB6dFNoTlJlRVlk?=
 =?utf-8?B?am8veWtaSmE1Tld0WDE5Y1IvYkgvcTlzRkRSdXNOS0FBVVAwVmMrcUVDVTBt?=
 =?utf-8?B?VkRabmFHQVg1NG9NU2krTVBmcVE2WFFXYWdUbmJUdW92NnRqRDdXRStQRDJJ?=
 =?utf-8?B?Q2xna1F4TXZlQmk2QVRzcXhHZVhUak5ObWpPYlB6cVFkNSs5aUE5UUljY0oz?=
 =?utf-8?B?UEFsaWlGMlBGd0Z6MXM1UkR5TmxNRDlBQ1F0czhaNnU2M1pvWTlDdG9mMTFD?=
 =?utf-8?B?UjhER2N6QUs3SHQwNjNBbUpWZGJvQU9zamdFZjZEU1N4Tk11WURlMlhydVYz?=
 =?utf-8?B?TUZQWjBCMG9Mc0ErcHl1eU4xMTVtclpBNG9QSmNrczJwdk1mOEpJU0VDbW1p?=
 =?utf-8?B?dHpxejkrWnlteE5ZVDUvOVpPbVFWdW1jekd4cXU4Wk9Nd3h2aE52bDltVlZa?=
 =?utf-8?B?Q2Y1OFRDeDdFR3Z3Zkw0L2NIV1NGUjlwVzdvRjNJTmFGOUVjdHlCOUU3RDNW?=
 =?utf-8?B?SWNMZkFwRnlGZldLbWJlQ2NIdTkyZExpY253U0pmY2lWeFpwZm42QU5kcUhV?=
 =?utf-8?B?RmJRS2dwV1ZIeERpZW42L1VvOS9XcWpyaVBHek5hZ1VKZ0VUcjVCeU5OMEYx?=
 =?utf-8?B?Uk5KV1MxWXVXUjROeXpHSXp5U1lVN0tHQUNzVW5pZGdYMEVxR2hKN0xmNHJw?=
 =?utf-8?B?azIxYm5NaTBQUGdyTjdEMXhUazhQdXA5RlUyRCsvTy9Zb2FuZjhTSkVCODNE?=
 =?utf-8?B?SjZTMmtZdnJLS0d6ZG1uTHg4Z0hyYktLckJidFJxZlNPdHZhN0lJUFdsNW5i?=
 =?utf-8?B?dWRLcWYybklxVHZaTGFEd1hDZ2hnSjhNN3lmLzR0MFNvWGZGaEVQV214bmlK?=
 =?utf-8?B?Uy9BdVBqT1VmRVFvc0F0M2o4dnNMS0hPTEVIYU5NcHhIOVJldjBIbVJVTUtF?=
 =?utf-8?B?UmF5WWNjVnhFQ1ZMbk5kWDRpdnpOT2ROcDRPUUpWdXNPODBzY2p6SUhWS0Nr?=
 =?utf-8?B?TGIyMEVzVVBjSlpqVWxpVjVZSU0yNHd6OGJOazRvU3NqU3kvd3JMd3BuaFFm?=
 =?utf-8?B?MWgwdnEzcjduemxDNTZzWlFxLy9HZjZiWVdTVUlidDFQMFZKaldQOVJxbGg4?=
 =?utf-8?B?WGZrOER1aWVUR1hvWDhyaW93N1NhZ055NHQ2NE5QNnVHTW5DbmhieEVnR3F1?=
 =?utf-8?B?L3lkQWI3QlVldGlsOXBRak4rbE5SYkFWUjk5M2JxbEM0UXNRTFgwVG5FbWE3?=
 =?utf-8?B?UC8zRHhURUtCNExpMWhPakFDNXhVVm5zSXNUWnZ6MzBMWVpiRW0ycG9wT3c2?=
 =?utf-8?B?cUR4Wmt3endieGE5alBEdUZlN1FQNlgxS2RybkFmelpTRTNjUVJ2SzlzL3BY?=
 =?utf-8?B?ayt5ZzFhUUl5VWpBSGV2MXFKMFFxTmtCazhrb0hzbXEzSThLK1JZRnBJcit5?=
 =?utf-8?B?emtsV2FnU0JjTEQ4ZHJZRWpOc0dFQTNyRXRXckRBSERiU1NmbXVSYjVoeCti?=
 =?utf-8?B?ejluRkpLQnB4R3pFUmI1TEtHa2RQNGozekNpNjB6REpyUU9RSkxxTXJiakd6?=
 =?utf-8?B?UmFsSGRlVmFUWWphbU51SmxqYXo0SVY4SzNlM3NGdmsrVnVkUWhCa2JrWmpF?=
 =?utf-8?B?Y1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8Vx0IZ/AEafexLW6kaXMGd2RMA2P8yVUL3HmjpW/NYwb9Ib98sZcpOY/quXKeERHTdUtxmFKyWqXt5BC7RbEjXJIXGj4g4eiCQ/okTmjMfFUAaHp1PiOKdzsHV951NUhbHDLo2hNhYKHlfEPZmACU48x+emwbxfsI8Rf1ZTYAy4l21yiroB0P3JCakoEQPePclb4XlaayjK/OcGYDqTEjoXYUf1aTRCxxlVAIASn+nyhACWqNMRq+9SLJvTa/XaOOt74Pj2N7SFP0inrpqDF1hv8WzdxJuOElDMZSoKXzMpBkaDyA/qgqeB4RoE886rUD1RAmyojj1+Ljj3gUai6S1TDO1S4zNFoljklsh7ex6gwjVKejh8V0sMPtyBqJ6zA8+hi7oJ+FQACXnZtIIg3bKkB5vlB9XGYLTaHImdRQ14/AayKqRHrguk07corZIpu/9y8RA7wzjXyxBlafy5dPqxWpRD49IZsa2wSlwp78FEuu6u17tjcVgHM++O9yE6YjhBkTll7g8GD8aPi6oN180+GiL/FyHDr4OE0sRuID42GL0GdurlRWD/grQVFnzTK6vgKYGDgXTleJU9RwtJTqxNc653eHVnrNKNkxX+b/Oc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 222b9618-924b-4d69-de19-08dcf54d1421
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2024 23:30:58.0180
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z2CE++ri+Xh+t6R3Crf5cnENgB0KwRMI7Iw7Tpmq88y/rhc+hKhD40RM0rh79BZ4BSuJUbksGavEMYVuSPWdHpsqr7kb4EbCmPn2vEOttEk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB8141
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-25_14,2024-10-25_02,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 phishscore=0
 suspectscore=0 bulkscore=0 adultscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410250182
X-Proofpoint-GUID: FBG3rqjFjVeLtEjbrVVRyPsd7TmPaOwy
X-Proofpoint-ORIG-GUID: FBG3rqjFjVeLtEjbrVVRyPsd7TmPaOwy

On 10/23/24 09:28, David Hildenbrand wrote:
> On 22.10.24 23:35, “William Roche wrote:
>> From: William Roche <william.roche@oracle.com>
>>
>> Add the page size information to the hwpoison_page_list elements.
>> As the kernel doesn't always report the actual poisoned page size,
>> we adjust this size from the backend real page size.
>> We take into account the recorded page size to adjust the size
>> and location of the memory hole.
>>
>> Signed-off-by: William Roche <william.roche@oracle.com>
>> ---
>>   accel/kvm/kvm-all.c       | 14 ++++++++++----
>>   include/exec/cpu-common.h |  1 +
>>   include/sysemu/kvm.h      |  3 ++-
>>   include/sysemu/kvm_int.h  |  3 ++-
>>   system/physmem.c          | 20 ++++++++++++++++++++
>>   target/arm/kvm.c          |  8 ++++++--
>>   target/i386/kvm/kvm.c     |  8 ++++++--
>>   7 files changed, 47 insertions(+), 10 deletions(-)
>>
>> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
>> index 2adc4d9c24..40117eefa7 100644
>> --- a/accel/kvm/kvm-all.c
>> +++ b/accel/kvm/kvm-all.c
>> @@ -1266,6 +1266,7 @@ int kvm_vm_check_extension(KVMState *s, unsigned 
>> int extension)
>>    */
>>   typedef struct HWPoisonPage {
>>       ram_addr_t ram_addr;
>> +    size_t     page_size;
>>       QLIST_ENTRY(HWPoisonPage) list;
>>   } HWPoisonPage;
>> @@ -1278,15 +1279,18 @@ static void kvm_unpoison_all(void *param)
>>       QLIST_FOREACH_SAFE(page, &hwpoison_page_list, list, next_page) {
>>           QLIST_REMOVE(page, list);
>> -        qemu_ram_remap(page->ram_addr, TARGET_PAGE_SIZE);
>> +        qemu_ram_remap(page->ram_addr, page->page_size);
> 
> Can't we just use the page size from the RAMBlock in qemu_ram_remap? 
> There we lookup the RAMBlock, and all pages in a RAMBlock have the same 
> size.

Yes, we could use the page size from the RAMBlock in qemu_ram_remap() 
that is called when the VM is resetting. I think that knowing the 
information about the size of poisoned chunk of memory when the poison 
is created is useful to give a trace of what is going on, before seeing 
maybe other pages being reported as poisoned. That's the 4th patch goal 
to give an information as soon as we get it.
It also helps to filter the new errors reported and only create an entry 
in the hwpoison_page_list for new large pages.

Now we could delay the page size retrieval until we are resetting and 
present the information (post mortem). I do think that having the 
information earlier is better in this case.



> 
> I'll note that qemu_ram_remap() is rather stupid and optimized only for 
> private memory (not shmem etc).
> 
> mmap(MAP_FIXED|MAP_SHARED, fd) will give you the same poisoned page from 
> the pagecache; you'd have to punch a hole instead.
> 
> It might be better to use ram_block_discard_range() in the long run. 
> Memory preallocation + page pinning is tricky, but we could simply bail 
> out in these cases (preallocation failing, ram discard being disabled).

I see that ram_block_discard_range() adds more control before discarding 
the RAM region and can also call madvise() in addition to the fallocate 
punch hole for standard sized memory pages. Now as the range is supposed 
to be recreated, I'm not convinced that these madvise calls are necessary.

But we can also notice that this function will report the following 
warning in all cases of not shared file backends:
"ram_block_discard_range: Discarding RAM in private file mappings is 
possibly dangerous, because it will modify the underlying file and will 
affect other users of the file"
Which means that hugetlbfs configurations do see this new cryptic 
warning message on reboot if it is impacted by a memory poisoning.
So I would prefer to leave the fallocate call in the qemu_ram_remap() 
function. Or would you prefer to enhance ram_block_discard_range() code 
to avoid the message in a reset situation (when called from 
qemu_ram_remap) ?


> 
> qemu_ram_remap() might be problematic with page pinning (vfio) as is in 
> any way :(
> 

I agree. If qemu_ram_remap() fails, Qemu is ended either abort() or 
exit(1). Do you say that memory pinning could be detected by 
ram_block_discard_range() or maybe mmap call for the impacted region and 
make one of them fail ? This would be an additional reason to call 
ram_block_discard_range() from qemu_ram_remap().   Is it what you are 
suggesting ?

