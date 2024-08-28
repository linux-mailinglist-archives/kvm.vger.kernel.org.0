Return-Path: <kvm+bounces-25239-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E5AA96244E
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 12:08:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E1D812833CD
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 10:08:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2EF516A37C;
	Wed, 28 Aug 2024 10:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="J4n/hm6H";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="yEdkqrLz"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D0A158DC2;
	Wed, 28 Aug 2024 10:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724839682; cv=fail; b=c2F8MdSw4GTyjEzxGNLJIIOSMWDZIsDWrdeHcmjnmXoMPolGAvjX3l9DsuNaDdGtsj/+ihD7B7KY5ti8FxKQDr/b9N24+ELfLhfeDjTDdqTBaOAJpXuWo7ZnHfsqqKewbdfikzYVh0EE5BS94oBetVg4uNZQeSnfEb/9GQ94r18=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724839682; c=relaxed/simple;
	bh=sqARwVeEQgpi5b3mZ+NePyiVZq7O3i+Brp7aA8Rsyi0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=kcDj2/u4XWSwGFqy8LVYWP/ucbfPcKsVRaZ721yLcuv4Vzjxi2RlcOZbOFjiMX+vmPj/cuc8qLSQ6qw9MWQRN1kTJVcra61xxGJ31YUcr2SLwrVMdUI14XvBxiLZu+pUCojPhaVRbdX8C+ePOdrRCSUNeAwWT7d2jDbmpUbcY6E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=J4n/hm6H; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=yEdkqrLz; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47S7tp8m028748;
	Wed, 28 Aug 2024 10:07:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	message-id:date:subject:to:cc:references:from:in-reply-to
	:content-type:content-transfer-encoding:mime-version; s=
	corp-2023-11-20; bh=nXikIl1z5RCZPNYaC7lfqke/BbVB9JFkwgq0VsY5zYk=; b=
	J4n/hm6HFy9A3d9Bn5FeA0DSoutAkoyLVQbkgTTXHadUsCP2EOfyyBdzjUthlgn2
	XisefaGwqeWIYe+n5bkovrJNi1O6+r6dGRmwiImLHxCB/pcCLBpGQvQgomgtbNMx
	j8KngZl6e1kjvBLJ6uPpjUEp1UmUO9GOw7V4tTLxEfX9Xt5TROR02baPHSHGTU90
	65h5NKx+d8Bz/Q0ZxnhSXK0d7M4AQu/OpyL9cqig6z3/2gljtj9dbOUph2Yrg0Nq
	S6o77W8LCW8b01HAYbRbPXz1oCV9QpiqW7+GZ4PGJ7ne4N+jX8yYUQRJslZvt+KM
	1hLrhjrpRv0h2WP4UdYj6g==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 419pur8xp4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 Aug 2024 10:07:51 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 47S8XPJg034931;
	Wed, 28 Aug 2024 10:07:51 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2042.outbound.protection.outlook.com [104.47.73.42])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4189su9g16-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 Aug 2024 10:07:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vHCaMm5fbF94mcF2Ep0X4xeLZ7sLDWW2dxYKDmtqkv4b/OQtdLtmV1llAH85Of1fWIwfWwFvrfhPTMHV+Q5u9uvXvDpchfMjioHRJUy/YO+yukdzIkOs32EoZZv6WS723N687JSOcxgG4eHJ7BTeq0nTaFBVScLB3ViuhxFN83oaYOMNJKg1cgFLvFQSCGELUS/TyNg4EuR0gVbMng6QtL68v337DTaevqbSkQB3kir+tp/Wv1lEFvHB5/v2tQJXcZTsEKlT773BjVm1wFvsAvH+wo7ttDI95bQjtOlBPPTxqjVFCnuaJ+kh/w+DhbuaBt3xpg/C+qh3U0nR4LP38g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nXikIl1z5RCZPNYaC7lfqke/BbVB9JFkwgq0VsY5zYk=;
 b=BMvrZMCesZ5lWPxaKGCX/KGVR6J8EHwUMUsCk70ZtVqTk+AoZuLc/6dLWZNPPseNJDgWY8KIri8Gdqy7Jyt5Xfq93WAFxCCNnQoc8cRoEHHwcpXTGxTP+7nOj/4r3J6unc1bZTMyhySga36egnBU7awNEY/SKnvJLYb6OeCOrautLxxfq+2NT04vfFaMn1nOwkR/HI28rFXCZ4qqgg5Yul24mgDVztR5RYRjstc1zEQHEMWJDJI9G8Gl2kiBKFBNFwI18sAvA51BZT7O+lR7/wlQOhtKjZgH8Ver+YbEO97PhdGIrplAZRD3YDZd36u5VvMDWZnt0p0BP42s+EG+Rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nXikIl1z5RCZPNYaC7lfqke/BbVB9JFkwgq0VsY5zYk=;
 b=yEdkqrLzz9TTpdzompJzessVbuhR/hJH05UDMPYlk56p59pIGSRU51NRUUTVF5YMywgEwMLPjeOJuCiMLx8FWawNyJzI0BZQWo77HK40pmPnAQHfUh0BhkuTq4YTWLyVN8GZeqyuE0tz3JuRxGLVvKgPm8KxIWztcGAFbVfbzhc=
Received: from PH0PR10MB5433.namprd10.prod.outlook.com (2603:10b6:510:e0::9)
 by SA6PR10MB8158.namprd10.prod.outlook.com (2603:10b6:806:442::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.14; Wed, 28 Aug
 2024 10:07:49 +0000
Received: from PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::47be:ad6e:e3be:ba80]) by PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::47be:ad6e:e3be:ba80%6]) with mapi id 15.20.7918.012; Wed, 28 Aug 2024
 10:07:48 +0000
Message-ID: <894fc485-0a0f-479e-88e0-eddb9ccf065c@oracle.com>
Date: Wed, 28 Aug 2024 12:07:44 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] kbuild: use objcopy to generate asm-offsets
To: Masahiro Yamada <masahiroy@kernel.org>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-um@lists.infradead.org, bpf@vger.kernel.org,
        llvm@lists.linux.dev
References: <20240828083605.3093701-1-vegard.nossum@oracle.com>
Content-Language: en-US
From: Vegard Nossum <vegard.nossum@oracle.com>
Autocrypt: addr=vegard.nossum@oracle.com; keydata=
 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 8A==
In-Reply-To: <20240828083605.3093701-1-vegard.nossum@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PR0P264CA0160.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1b::28) To PH0PR10MB5433.namprd10.prod.outlook.com
 (2603:10b6:510:e0::9)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5433:EE_|SA6PR10MB8158:EE_
X-MS-Office365-Filtering-Correlation-Id: 4007748e-0ce3-45cd-4c75-08dcc7494517
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QjVmQzF2Vk9ZVXNZamkxbUtvWWRKdWNOQ3lqM1dNbTRhaFZqUHhEV1JncnJN?=
 =?utf-8?B?RGFVZ2xqeWVBQWJGdTFUYnhVamxFQ0VMOWJLVVRMdUVJa3VaTWJWbmZVTVRx?=
 =?utf-8?B?VzRaZXBzQzNmNGQxYU1uY1FxemxsYTkwanQzZG41ODE5QVVkWnNmaDN1Qis4?=
 =?utf-8?B?Q05hS3d6ZmVUemdLUW1nbzdVb1p0ZS81MzlxNkErd1RXTlVhRTVaUTVqYXNK?=
 =?utf-8?B?Ulc4K3BWM00zd1NraTN6NVFKZWpjYjF0cFh3YzVPODRwZmlnTzh5QjFFcnU2?=
 =?utf-8?B?MElhaFdUSTd4SXVrVndkdzFEVlpXZEtKVndVbE5IM2V2SVllcEUvSTl4OFRm?=
 =?utf-8?B?L3JuU1ZmK3VuaUtKZ1NrNXIrQ0xGbnJkKzFvZjZSYjlQaWdkSENFaUpBZWRs?=
 =?utf-8?B?ckJ2WUV2RXVzWi9CNzB4VkxJdWlYSU83M2VyYjlpNS9idGpEelZ1OTNibXlB?=
 =?utf-8?B?QmdYOGNablRja0NDakJRUjJpR0ZERE9FdWdoVzlyNFVFRzl5R0hzZUdKYjBu?=
 =?utf-8?B?MGhWNXB4blk5MDdKTm81YVppaHFuSk1QRzhkSlhsSmZ2UlRQTmt3bTBHaWpq?=
 =?utf-8?B?cjI3aWpJSWVFZkpEYzg4Sjl0MU5zNXV2OHY5R3k3VU5jK0IyYndocHRUNzlE?=
 =?utf-8?B?SmFsRmZZUXZwWXB0NHJMQUgydkRiaXdMejZWdDc1M0RTV2lMS2plSXgrMCtn?=
 =?utf-8?B?c1ZOWG1zb0hMZnVtWG1haW1QTUd0K2tIa0FORTJqTzFMZU51UW5hU1o5MUxE?=
 =?utf-8?B?U3NHMC9sTnJBdmFjT0hCb3p0dFdGdUlvVmJEN1JNR2tmUUk2SHNaMiszQWdo?=
 =?utf-8?B?dVVzeWpzVjVScE9JbE5mK21zMGVJbGJhQUx6c1dTSGozWXU5YnU4NmMxY2Vi?=
 =?utf-8?B?aGl2TXhnOERSN05iUXF3RjFkK2RHRGhJSm14MVpQdUhoc2tOZmJRVjY4Q0NP?=
 =?utf-8?B?V09ESzEzZGxkM1ppR0VlZ1NXQXF4ays5QlVIRzR4bEx2OWR4MnBxVll6cVlY?=
 =?utf-8?B?bzBxT2ZaclFkdW4rK3ZKNUtrcWlONHF6d1RjSEFYUTcyZy9xREVFRmR5VUxw?=
 =?utf-8?B?ME1mTWdLa3Y1THFKT3dIVHlRcERPNU1TSHhVOXY2dERadDdMTGxyN2dLTGVy?=
 =?utf-8?B?cFlPdHRwSDRYT3ZOL1ppRWN6dXlkbFluMytYWVJ1YWplUFZSakl4eVNDZHpG?=
 =?utf-8?B?eC95VVI2VzhFUlpUR1I3VGxkbS9ydXdVclhpd2svQmphODRTbmxyME9vV2dL?=
 =?utf-8?B?VkxpcTV3WXpZUDlZdmJiNGFiVDZWSTlCbGZTZ2hDYjJCN2JXdUJEOVNnTmkv?=
 =?utf-8?B?UnBHSGNkaHdETEFTajRZVzBEdUEzUzRjQXRVaUk4akFuYngrU3lkWEpyTkxp?=
 =?utf-8?B?eUs4RTl3YmVXY3VMZ2pNNjdMMk5zU0RDYzZxQ2M5Ny9sT2d4b20xSW4xNUdL?=
 =?utf-8?B?M3duSHdLWDdZMzI3TzlJL1UxcEJEWUtrTlZUL2pFSGZiUWo3YzBTNGFzVGF4?=
 =?utf-8?B?dVZiRys0Njkya3ozTm1iSGsxdWRFVzVlV2hkVzhVdnpRM1l4Rmk3WmwvbjFL?=
 =?utf-8?B?VThrN2hPSDNiN1NWMEY4RFA1SnhYTEUycXJKWTFrZ1U2MXMzVnJpMXIwRFQ5?=
 =?utf-8?B?WmVtdG9iS014TlJVcm9OZTNSMEtkTm1vdkVib280WWoyOWI0amRPcjI0NDJv?=
 =?utf-8?B?WGcxSXVzaTQ4SVphQ1RoaUtUQm9KbEd4SVdQKzNBckwyZ1NUMDU1RTE5OXFi?=
 =?utf-8?B?NUV2TWdVSmxmSGlFK0tIaTVFREJPekJtWm5WaDBCSTNlcnVmOXFqTHp3L2VF?=
 =?utf-8?B?RnpjWVg1S2xzRnF2Rlgrdz09?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5433.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NFREbGtNYUJFWGxnYlJPb0kwVDN4MkhhN0J1TklCdXNMQ1RleG85OTJTVDlt?=
 =?utf-8?B?N1VMYVo4Q1hqMjVPUUlaRHJtVTBmZVJINHE2cWE4ZnoyL1VndldTKzlwUWhp?=
 =?utf-8?B?UXRXS2dDb0tFTUE5UDlBRmF6aHZZTWhsWHBXOWtHVnVvRFZHM3VkZlF6cWQw?=
 =?utf-8?B?dzdHbEFOa0FlYlQ1TUUzU2RhUVkwdWdDREdCVmJoekM5UlZYbXZBTm9uMm5Y?=
 =?utf-8?B?cW9RT1BUcFlxOTNwbFJaVGMrd214MFh6MjhsU3FsOXE4N3V5N3pRdmFtaXhX?=
 =?utf-8?B?ckVFSGswYm5ObUJ0ckhhN2Rsa3pIVGlwRFU4bTVaZzlQOEFiVDRYaldRa0Er?=
 =?utf-8?B?TDFCYVFLcjJHMXVtM0cyeDRLUlFjWE9IVmNMWFVtL2hXc3BYVHFidW1td2k2?=
 =?utf-8?B?cS9BVWRoSDB2NXFJM0plTUJZQ05VOFV4clJFOUhiQmMzTGF3Q3pUNytBRXA4?=
 =?utf-8?B?anFxbGdPc0M0RnFyejN6Z2V5dEp5WElld2VXc2JKSmt5Rkd4WkxYTjhsb1ZZ?=
 =?utf-8?B?Y0RZMlpDc1hkWWh4ZUNraGcxL2VHcXA0WUtPSE5xS0F5VXYxSVd6dkR1SXRq?=
 =?utf-8?B?OG1pMVc0alpuMVV0RFplOWczQmsybzZBNU4vT3hBQmdPc3RvYWw4MndnVi9i?=
 =?utf-8?B?TUFJQjAxKy9QR3FhUjZGQkMrUkgxbjVaZCtGbmlRbTE5TmdtclJXZlRLb1JW?=
 =?utf-8?B?bm1EMTlOZ2FlWnNBV2lmNU1iVlo1ci9HaitVR0luRTZJQ3dUTjhnU0tPRXVt?=
 =?utf-8?B?U3RrZEdXaW5ETnp3aHJuNCtqNURzaVpadnJOUVBsSElRNjVXaEZQWGhmVVhC?=
 =?utf-8?B?Tzc3c0dLaVo2V2lTOG4wZjF1NHgrWi9RQ2NGUk9JVnNrT1VZTnJad3BEbDdl?=
 =?utf-8?B?eDJURUZoa3ltemVyWG9UZXRCcitnZXF1Tk5ybDBvSmlqWjJNRW5zQk1OTzVv?=
 =?utf-8?B?c0RUYkFHRm13N01UQTJaTTk2ZUhTSTRSMlMzaXVrdUJieHVFZFczUFFvcjBU?=
 =?utf-8?B?S1hsSkFlV1J1U0Fqa2NuaEhzMmVrUm5nUndRbTZUdklPSGUzdXBWelVLNE9G?=
 =?utf-8?B?RTcycElvSVZFTVV0aHRyZkNlbXM4UE5TbEdFYnJoVnpMWmlXbmNqVjRObmd2?=
 =?utf-8?B?RTBFUjM1YzBoeGNncTB4ejk3YjFoM1Fpem1TY1pDcXU1OVhtbXNHM3FKdGJn?=
 =?utf-8?B?dVBjbmtJdEdxalNmN0hTbUROUkFKMm9mRDVzZEVQSmdYeTR1VUFaRllUMkVE?=
 =?utf-8?B?d2k0OUFkN1B6cm1QTXlDQmgxMDJsYnpoS1haQ2UwSzhiN1d1OVo1RThiMTNG?=
 =?utf-8?B?N2plWDQvZW9aaUpONTlCKzRzUEZ1NzB0cEVDWnpod05ROFpibStUZHlkMzVq?=
 =?utf-8?B?b0I3MmNlVUlPdFVzVW1oTHNWTGRCS25zRGlZeDBEaDRaOHA1b1p6WTh0VGUx?=
 =?utf-8?B?L0JsL1lqUGlDczRTL0h2Ymh0T3lhd2lzYVlWWGlrQzVWQXluaUgvS1R1Z2ZB?=
 =?utf-8?B?TVNManhZMDlyT2FvVGNrc2ZTZ0hWR01GdjFIVUh0ZDYyaUsySDhiNGp6bTNM?=
 =?utf-8?B?azRuSFl0c2RqajJ6Q1o5QlpoeEhqNTRZYmNxS1BuMzdzNVQxTFExVWZsOElR?=
 =?utf-8?B?MmRqcjdMUzVXd2M1VUdmc0xSZVdQZGxveXNuZHJ2TUQxdzAwN3o1bldvNEZO?=
 =?utf-8?B?U0RndzlwYVNwOEVjM1JVZk11bVlCcGtUVTRxTWNIKy9RYUxINnJsRzR4a3U1?=
 =?utf-8?B?bzVSeHhoZzd4TUVxSXZ0MFJjQjE2L2s4UkkzcCtHOXlIeTBxY3JDQUhaY0w1?=
 =?utf-8?B?ZmMrUVhZdENaM0x2K2UrbWJ2L1VDVHdheFNxZnVyL0swQlo5cFNUNCtLNU9n?=
 =?utf-8?B?WDMvNkpnKzIyUHNkNFdLOWp2RnhZVFJIMmFTZ1JkTmEyZW44VU9CUlNvUGJh?=
 =?utf-8?B?eXRXTlp1dDBJbkJrNjVkL3BCQVE5SlBISldVR3pMZjFFNkFJVUlKbklONU1O?=
 =?utf-8?B?Wk5yR1gzVUQ5Ym5pc3lrd0JsL3lUaHVpcUZNaTlxay9rOVptd3pZcVc3ZzRY?=
 =?utf-8?B?blA5aGd0UGJpU1NpTjVmVDkyZEVQbXYxRnpPcXFYV29LNVdmRDk3Nlc5TER4?=
 =?utf-8?B?ZmdmekxXZE9BZGgxNFFtbFQwR3ZiZ2h6UVRyRFVlaGt4VTNMM0RiQ3hzWHU0?=
 =?utf-8?B?N2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	uMtfJD/sCecWwqyschpMAUnWccG9zvvQlQPbQsgOH49g/gNxZHWzevCtld9OlDb9tzlnscW2Rl+af4sC/GG1QhaAgm5NNU0Shyfg4YLqiincFwp9xQdF8bi1jjWHlJENndI+H3ItRm3kMsC/v9nbF+R7B9+YOZOGxHuZ+yvkbcO7Ybsgr5qejCQzvXQ2xzH6XA4d24XAlnN/ccmCZ7JxUCwvMK0LN1SFsdarNqJ/6hXRQRlBHqBLQlA4IzayprbJmg1fKR5flPvTOjuxfZdF5P9dKIU+9teU9Sb0rx8ur+vGks3G4KALbdCtEN0cSQpeuBIjJW3+8nR8lz/JQvXjd6kA+ffYBgFhADeUARB7ii60SjKAQ3nxxTF6mdK8vt25irA1k7Q/x+SWGp2SJZo8fX04XMkSJ2n2OQevwpxl7qipaa9+xQvWoyklRYOUSaFDbsEyUhFIlHPnqZjt2mqwauzoQmYHl6Uv+BC/vMcHeLa9yozjR1oJuIK1EbF7rDZVm1+jCQloy1OY8ryOaygnlBF5rnuT3FsR30XbPB84gdTyqVVKstIIcYNwURyq2+eleDqAjDSTPPG4OKUZT2yIffrO9vtL1XdVWfozf2d4hxU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4007748e-0ce3-45cd-4c75-08dcc7494517
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5433.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2024 10:07:48.8827
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rqsu3xJhLdnL1ELMXx5MwQzMCiaMtzQ+XAiY4/jQpQcH0siymSxrrd0RqZuRZFyVCXwMl0OorSWVFB1pPo3zArrG/YvrJYDaw7PW28/v4yQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR10MB8158
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-28_03,2024-08-27_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 suspectscore=0
 mlxlogscore=898 malwarescore=0 bulkscore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408280072
X-Proofpoint-ORIG-GUID: ZdtryZiMjPX-nbwQfZT5dFAmj6IA0Iuy
X-Proofpoint-GUID: ZdtryZiMjPX-nbwQfZT5dFAmj6IA0Iuy


On 28/08/2024 10:36, Vegard Nossum wrote:
> In order to give assembly code access to C structs without having to
> hardcore member offsets, the kernel compiles a C source file listing all
> the structs and offsets that are needed in assembly code. Using some
> C preprocessor trickery and a sed script, the compiled assembly code is
> turned back into C preprocessor code that in turn can be used by the
> asssembly code.
> 
> This sed script is very hard to read and understand.
> 
> Remove the sed script and compile the C source listing structs and
> offsets to an object file (instead of assembly code) that embeds C source
> directly. Then extract the C source using objcopy.
> 
> The resulting code is more readable, less fragile, and sligthly shorter.
> 
> Note to reviewers: The 'objcopy ... /dev/stdout | cat' bit is needed to
> force the correct ordering of the objcopy lines vs. the surrounding echo
> commands; without it, objcopy will open /dev/stdout (which refers to a
> temporary file created by kbuild) and reset the file offset to 0. In
> other words, the pipe ensures that objcopy doesn't overwrite the lines
> that already exist in /dev/stdout.

Turns out LLVM's objcopy doesn't support writing to /dev/stdout, so we
might have to use a temporary file. I'll look into it and send a v2.


Vegard

