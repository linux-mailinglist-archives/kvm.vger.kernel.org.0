Return-Path: <kvm+bounces-14905-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B17A18A7835
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 00:56:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 26FB11F22743
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 22:56:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE68913A261;
	Tue, 16 Apr 2024 22:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HHXqmDv0";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="MJk3/IZI"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16D406EB4C;
	Tue, 16 Apr 2024 22:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713308203; cv=fail; b=lhFpjTdd4XX9W6zUErX0ZkayDNAhTi3DVmpjbsbBqZXBenPxCRiBlZ5ImJZQuKBFdoKxGmuIgfi4YraKxM/a2xmI3noDEa8S+9RD0VTTyntJz5BIRKlXK5QSWfOIy7EGfyycTvHVPapVs7oQ798Nb9OtOpC4JWXsHNziNt98Ftc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713308203; c=relaxed/simple;
	bh=I1mIcx5/v0jtqIdmhSyn3VnnG/gIJ6MYEKJ2rwDhoGw=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=t5OzxMZXgfKQCymmq/lilNBn/czLyoRKlDIf1GnX5me+SlBTuIylNAiRNuZFbg0pHS8/uLajZat+7XfSlQMSHarbIRyxWc3IwCKgNGIHxdivs4g0r4kUOiQHZvlJ2Bf+gDlLSptaALWPoPNUxRLb8eQDwIwuKLQpHOGW1+Nf3OE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HHXqmDv0; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=MJk3/IZI; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43GJjoun006412;
	Tue, 16 Apr 2024 22:56:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=ER71ip6tjzQRocc35RGxM4k3LATlXBXYWNLxKk9BWnY=;
 b=HHXqmDv0uPWHgLNzjQRUL+v9wGALnLodlYy8+9JpOLIvkiRwEhL78IfQZldXuTfrLn5e
 lHtr7iFLWQ1MdgDInDDS/rRdyp3BbENnf0yz8ccshmClafVMdUYfJWkr4ocxF9tx+A+E
 QcT2zUgITEISTLRnYeUDFQGeAmQJrEkisg8sD9LM6GNdDuB6SqtXMTu0Rp/7LzBO5zNW
 5UjrGFadKRcxHO6RTLJp0AtI8SGkU7pbM1bA38Vql51pSElQ2lZEclJYzffZZagm7mMg
 xfLhduc/Be5b80Y4N9fkhDYSvZxCO9kPmXBhQnt6uwxzFmnuZu8ypPLLi91NSNf2Fb6P 7A== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xfgn2pgmk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Apr 2024 22:56:38 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43GL3FVM029401;
	Tue, 16 Apr 2024 22:56:37 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3xfgg7xca3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Apr 2024 22:56:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=biYtt21lpjAOKAOBE3O7FUvXPCQJu1EWhIRgo4DXWfJ10UDpc1MEaRRUcyvp1bXNBwa2Vk+nraSiKsri/vKcWHMbg9b2zbJhA0F8gO+dN2UYNdIMr64Y7VpQFey5mae6lIlD9ooRmpQ/w7sqand1i21q/s46LP7cv6CEElg/MstRI33ucTKgq2TR1BKoNNn/bkO9YeWrPGXKS6FWoVzARCjfb8AIsbSOyNr8rV7kXFVPwLzP6JpYV72AKBKILycdoN23nmdQKF1HmjKq504vyiQXZRNMDWOkoC5iZL9KmItYVHus1tj+yWgFdTQMo05oZE/cxjOMOnVdSdtFs3fS/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ER71ip6tjzQRocc35RGxM4k3LATlXBXYWNLxKk9BWnY=;
 b=Ks3vHkIso+A+j6yKYfIFbuCZFPKibiYYhWBM0H1S3pllZQaM7r2/G8TkTWPBHb+WPutSiyKgrBh40HqTiGUbcoZ1k7ruaDi5CVLSi4DvoIYQPzGH0qX2beNSfU7KyhrXJWhXZ92iHkIHKmDrb+xUx3MDRlHCJhRSpiO4cW/6TvlO7mTfhZdRtoaPafJgkxST+TdrqXpf5sAZ4NwJExgV0KnycjXGsD0P+29REVNhxmEIJFoSXDPgnp1xB13JO73ISE59cjSwfCOoifiuHDU+Hi29Iu2iWwlbTIxyANi1p8teve3xjErX9dbUE7uQTcbsIm2w2Mb4Z3/8Qjs8s1T6MA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ER71ip6tjzQRocc35RGxM4k3LATlXBXYWNLxKk9BWnY=;
 b=MJk3/IZIeCiyoKcIuUtF3TcWH7kij6w1+7c7Gd2ridp9cFjtjSzZfcr65OtQslbRiGbhb9Ohxje30LaKengKyIDum8BDk95KYbNQ01g0y70XMWKVsfpdG1igKxcn/a3gV8/NbRmoOmFyxJ9Cri45pdT2zvqavxHy5tlC78uH9cY=
Received: from BLAPR10MB5009.namprd10.prod.outlook.com (2603:10b6:208:321::10)
 by CH2PR10MB4230.namprd10.prod.outlook.com (2603:10b6:610:a5::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.50; Tue, 16 Apr
 2024 22:56:35 +0000
Received: from BLAPR10MB5009.namprd10.prod.outlook.com
 ([fe80::a088:b5e0:2c1:78a0]) by BLAPR10MB5009.namprd10.prod.outlook.com
 ([fe80::a088:b5e0:2c1:78a0%5]) with mapi id 15.20.7452.049; Tue, 16 Apr 2024
 22:56:35 +0000
Message-ID: <77fe7722-cbe9-4880-8096-e2c197c5b757@oracle.com>
Date: Tue, 16 Apr 2024 18:56:28 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM/x86: Do not clear SIPI while in SMM
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, seanjc@google.com, linux-kernel@vger.kernel.org
References: <20240416204729.2541743-1-boris.ostrovsky@oracle.com>
 <c7091688-8af5-4e70-b2d7-6d0a7134dbbe@redhat.com>
 <66cc2113-3417-42d0-bf47-d707816cbb53@oracle.com>
 <CABgObfZ-dFnWK46pyvuaO8TKEKC5pntqa1nXm-7Cwr0rpg5a3w@mail.gmail.com>
Content-Language: en-US
From: boris.ostrovsky@oracle.com
In-Reply-To: <CABgObfZ-dFnWK46pyvuaO8TKEKC5pntqa1nXm-7Cwr0rpg5a3w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR08CA0011.namprd08.prod.outlook.com
 (2603:10b6:a03:100::24) To BLAPR10MB5009.namprd10.prod.outlook.com
 (2603:10b6:208:321::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5009:EE_|CH2PR10MB4230:EE_
X-MS-Office365-Filtering-Correlation-Id: 6503babd-2db8-4b73-025f-08dc5e687739
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	Myglkseql17K4X014T2W83jYklWchoGOzNQoalX1k2PEIPF1fgTvsrRnZEhS1Nv4VHDbMz1vP8cXYBrvoDbPiJWRkNDNpoS8LWaCOK1pEcS65XEn9awBpzFN3ZtUJ6eARdGiXbqcsFEbJwpqQbN+QowVHZleLS0CnO8KSRxk/n6ehe9TyQQI9N2RPKEbVDI7tXD3PTavjUNXFdzVcxZpTeDINUx4LUcVUS+pMQ7lAdiNOSuz2B6+tgUhHMfiM8VkiiCW6GFOINzz197BuiWobAKH6rwRwI0ha/JJbIlrDkfvvPAQmtpAVPXpLQFlaIx1IoyeVEvaTdqwL1vP71L/PJ6wrihJ1XgZnvTzfg9rlN9fJ6BhQVrt4c0vS10FkAeU+QdszQXupFZLMZGxcinivGqyCwDYifc1KzdcukImJykG3ExjfyTC2H89xC9uUxGmsYayOzukTZ93NvR0TuN4wl+U/iR/Ij5T3nChxk2zHrdK4OhiBq/E6sgRdl+hJSjC6/az2aiOQGAJXfxyo17zSZerw2xaTCWlE6eUWLo+RGWs3lIZ7CURdyY6Y54UwLw2NXyXd965CQSKlwECDXMr1MSm9C1yU+IhvNzbK1G9Z86RbbBzqKGq78Rk+t9CUOQ3
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5009.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?Nmc5Q1ZjNHB3Snp2NFlHUlpVdUQwODBWank0V1QzU3o0TTZsajBoNVRSSjRz?=
 =?utf-8?B?bk5uNnk5dDBWb2JpY1VwR05HaEZRV2Eyek15d1ZjaFhmNy9YTDRYb0daUVNW?=
 =?utf-8?B?cnl5SmM3U2lhNGZ4TmdmZTY5VDVnVDlNNWoyUmFFbUVoZktlZUQ0TnUyOHZ1?=
 =?utf-8?B?RU9TZ3BxdUlUU1BFR1lRN0VDbEk4K0tLM2RhMG95VS92MXkxaHQrTkhDbHFV?=
 =?utf-8?B?LzhqRzNsVmFWa0RZSHRPc2F5UXFIQ3pzQUZhUWtJWWhiZTk2UU5yZVlyQXZj?=
 =?utf-8?B?MWdtbkNVbFNoaW9IcC9yS3RLb3VWdmJjendjYXVZWWJNL2RPOVhoY1hVMEQr?=
 =?utf-8?B?cXlHKzRoQjVyN0dMTzN1enJKMm1zUEY5TjZrK0swY0t3SlZONU5wQUthTGZ1?=
 =?utf-8?B?bEZLU09uQUllQ2RMc2xDaFE2Q1A3MWRBT3ZjWWNicXZvdmoxK3VZQ2tLa05H?=
 =?utf-8?B?NGlhYTk0NjlSUFdXSitkUjlIMjU5V0RqYVlmMi8zRmNXdHZrcGU1eHQ1NmFI?=
 =?utf-8?B?NlFYTGdwVEdWSzMrQnQ3QWFTdk5qUUVScmY3MW9PanhaWEt4S0JOWndqc0tl?=
 =?utf-8?B?WWhxZTBFckxkTUlpYU96SGVma3lkWFhIZlFZSXNKWEF0THMvN1R0NzYzZndS?=
 =?utf-8?B?dnNqS2l5c2l1Q3BwMnhSb1g4Z0ZhS2IwaTVRa0lheDhocFBhUVNqeDRZanBM?=
 =?utf-8?B?K3JUeWNzUkx6ZFNkTTNKQkFSWkVzQkc0elh5N2JpU2xQSlJSYkNIaWRUQlV4?=
 =?utf-8?B?eUpPbTlhN09UaE5UTHVFeWgyNGVEVW80My9vaXlKeVRIaTRsTTY4ZW9MQm0v?=
 =?utf-8?B?emc2VlMrV2dvSDZBUVYzWGtmN3d5bGNBalJ4elord3oxbVRUNHJsenFpQUQx?=
 =?utf-8?B?K1djaEt4cWRGbE4rQWZmVW45RzlUd1I5cXVWYmQzSFJ3WFFXQkg0VUJIaGpp?=
 =?utf-8?B?VEd6b1lCQlJRK3lhZ3lPamo1d010NTdEdFlSMUd0aUpDMlE3Mm82QUd4RTJ6?=
 =?utf-8?B?a1JOdGF6WjVZOGF3SFZISzFJWUlHZUpmaHJuUUwzbEFXd282cE5aQ3M3T2d2?=
 =?utf-8?B?MklpQWlNa0FReHRrU3pLTVlJSjBmK0RwL01KbzFQK2g3K3RRYlpRUmhoK0Qr?=
 =?utf-8?B?SGpkMHJjUVc0aUViV0d4UVNGanJOMCtPYk5mSC9FVnA5U2xTaGl6b055TUxW?=
 =?utf-8?B?VjA4Wmk0ais0NERVZnRPOGhWZU4xcytod3FkRFNmNkZDUUhoZVN5bmNkZHRs?=
 =?utf-8?B?TVllK2RRWEcvTEZhTUlmbXBkTHBjRGVLR20rcW03RlJ1V0V6TE1PVm1xbEVE?=
 =?utf-8?B?K3pVYWNhM3p3Szg2V2o3YTdtVFJKQ2ppT1hhSjFIZVhGNE1BMnlMdTVySXBJ?=
 =?utf-8?B?U29xTnU5dDNXSGoxeml4dmFGZGZrc3AvOTJ0Y3JwbmNua0svbXFJVmtqSEJY?=
 =?utf-8?B?TkJwcEVjdnYxT0xiTkRWOFRPTm5QbDJ1bGd0WGM1OUY0NXJnNTdGK3VsQ0wr?=
 =?utf-8?B?dUsyUGVQcXBaQ2ZvYXRKQ1FuZ1RMTVNER2ZwKzhTWE1JUGtiaUdnMmEzTVFz?=
 =?utf-8?B?anoyUUhINTg3RlRaUUoyZmZPaDZjaEQ3NFplL0x4dm4rY3BwaHJTdlEwK1JN?=
 =?utf-8?B?ck9OMitqMnUzaHhlRmEwbW9IQ3phSzdGVGttRmQ5dDNCNTVLTytrM1hmNXdH?=
 =?utf-8?B?NXJDSU11NUJrdit0S0pJWWpUN0pNNyt4ejhkYTdEcHBsaDdhdG15SzIvQWEy?=
 =?utf-8?B?RkdIM3RBNkVJVWwrTmFFOEdZQ2ZBRTRVRFIyUG5iN3pJTXJmSEpGUVFZV1FQ?=
 =?utf-8?B?dGhjYU82SWw5ZlVWOHV4ek5XczFtMnpPS3hkOUgwaHc5WUpyaVpCbUJKVXMr?=
 =?utf-8?B?Znc3alh4ZzhuZXZmU09EbkoxYnBpazBJMlR4VkdJYzlnUEIvWmFvV1J6VUlF?=
 =?utf-8?B?bWpkTFlsYzBPcnF3WXN4NEhqcTNxbFo3d3ZoNVUyU1lHSDFiMEthVGkwQW5r?=
 =?utf-8?B?RHBKV1ZINm5zMW5OVDZyNFdnc0s1VmgySXIydmNSeDd3UVBWa1l0bFk0MGRu?=
 =?utf-8?B?c3FsaTlHVlFmM0VmczQ2ODI3QUNJTDJhakdJWjhVcEtPV3l4KzNYUjVYMEJQ?=
 =?utf-8?B?amV0R1h3U1M1SHdGZmpTWDhCdGxnQWZocXJwR2diWHJ3NlE5NWV3bXdyT2hP?=
 =?utf-8?B?WFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	O7BPgcWps/XoZUh4I4k7OLtLZlMSZaC5qbUNycXLTzcUzYi0eiMIphVfzDdIZmf45fWeUmMirEvehx/BgbRqLJXSxXAxG4jFcz/ASgoYlwPTFQALw10TVQM0WlnaP77vaogPXg9I8DC5gKsUL/j6ITmsZmbkWbGTmrGrHahsG/RkgiYHmLxhvbpKJn3GvExFqR6yI1cu/3LgyMeCp5saQzVJ46aN6M7zvCAUzVGNUjzsDs04PuKMXwbp9Z2kO9bDOenvS/odlbR8QTk7+C+LutRhPU2NJrXKt7xxXvWPraTj8ub63+4uA0KHmwwVqRtfs0Xyakl8gk5IOkKOQHXXgiZQadcz03SjH6TEqBQKeb5VyFzowO9m4y8i3gPTemWeR3Z2huY9XrrhRuUu5qeGEV7zaybyCUTZYdj9LrfhhCpzjs8TqTt1ho78sSw4NmZN/IacON0iVQi5k0GDmkI/Hj+GaKPcnU8zHyE58lXUBkIjhbz0bTS/gOaOyRgdqc3NMb9S2wdNYtXwtz2Qiq69cwDGrw4lqGINx41RohsjjBAWc4e0ePr3cDcyMgAqKJPetrFDrPd3+5DNu4mi9+/BpujIuayJaqtpJc/ybBdBZh0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6503babd-2db8-4b73-025f-08dc5e687739
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5009.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2024 22:56:35.0901
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F7T+USXCmm8RY4IoAwef8iaGLJRTdgJIqOxabfQ7I5kchCSMcAcVlTn430NNHzVca8D1sXVisVDkeggYSsrEQOTU4sC+vPPAplnBHc6vi5s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4230
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-16_18,2024-04-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 mlxscore=0 malwarescore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404160149
X-Proofpoint-ORIG-GUID: Zb_ZD1AMiMbMkCNsbweHJZXW-TkTmad0
X-Proofpoint-GUID: Zb_ZD1AMiMbMkCNsbweHJZXW-TkTmad0

(Sorry, need to resend)

On 4/16/24 6:03 PM, Paolo Bonzini wrote:
> On Tue, Apr 16, 2024 at 10:57 PM <boris.ostrovsky@oracle.com> wrote:
>> On 4/16/24 4:53 PM, Paolo Bonzini wrote:
>>> On 4/16/24 22:47, Boris Ostrovsky wrote:
>>>> Keeping the SIPI pending avoids this scenario.
>>>
>>> This is incorrect - it's yet another ugly legacy facet of x86, but we
>>> have to live with it.  SIPI is discarded because the code is supposed
>>> to retry it if needed ("INIT-SIPI-SIPI").
>>
>> I couldn't find in the SDM/APM a definitive statement about whether SIPI
>> is supposed to be dropped.
> 
> I think the manual is pretty consistent that SIPIs are never latched,
> they're only ever used in wait-for-SIPI state.
> 
>>> The sender should set a flag as early as possible in the SIPI code so
>>> that it's clear that it was not received; and an extra SIPI is not a
>>> problem, it will be ignored anyway and will not cause trouble if
>>> there's a race.
>>>
>>> What is the reproducer for this?
>>
>> Hotplugging/unplugging cpus in a loop, especially if you oversubscribe
>> the guest, will get you there in 10-15 minutes.
>>
>> Typically (although I think not always) this is happening when OVMF if
>> trying to rendezvous and a processor is missing and is sent an extra SMI.
> 
> Can you go into more detail? I wasn't even aware that OVMF's SMM
> supported hotplug - on real hardware I think there's extra work from
> the BMC to coordinate all SMIs across both existing and hotplugged
> packages(*)


It's been supported by OVMF for a couple of years (in fact, IIRC you 
were part of at least initial conversations about this, at least for the 
unplug part).

During hotplug QEMU gathers all cpus in OVMF from (I think) 
ich9_apm_ctrl_changed() and they are all waited for in 
SmmCpuRendezvous()->SmmWaitForApArrival(). Occasionally it may so happen 
that the SMI from QEMU is not delivered to a processor that was *just* 
successfully hotplugged and so it is pinged again 
(https://github.com/tianocore/edk2/blob/fcfdbe29874320e9f876baa7afebc3fca8f4a7df/UefiCpuPkg/PiSmmCpuDxeSmm/MpService.c#L304). 


At the same time this processor is now being brought up by kernel and is 
being sent INIT-SIPI-SIPI. If these (or at least the SIPIs) arrive after 
the SMI reaches the processor then that processor is not going to have a 
good day.


> 
> What should happen is that SMIs are blocked on the new CPUs, so that
> only existing CPUs answer. These restore the 0x30000 segment to
> prepare for the SMI on the new CPUs, and send an INIT-SIPI to start
> the SMI on the new CPUs. Does OVMF do anything like that?
You mean this: 
https://github.com/tianocore/edk2/blob/fcfdbe29874320e9f876baa7afebc3fca8f4a7df/OvmfPkg/CpuHotplugSmm/Smbase.c#L272 
?


-boris

