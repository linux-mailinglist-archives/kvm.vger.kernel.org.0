Return-Path: <kvm+bounces-44065-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E45FCA9A047
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 06:55:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3036C7AE4FE
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 04:53:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B8781C5499;
	Thu, 24 Apr 2025 04:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="yaVc5T8x";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="bIm4a54m"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBBFAF510
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 04:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745470495; cv=fail; b=JnufbmW/HcrzTKSQKEh1zk/xuEXNW9YXUlkcpG1WEOigGr0Pq1AvKVuw7towMp6Z8gA1CGMiqINIBWX5tqycAkU6BelSXEmzZ4U6+Bnr3L4YiAeXs1rV0Fc0ZWkM52Szu9rYjjmsQDehh5Zv5wag14PiXbueWmvIB8M+FeatWxE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745470495; c=relaxed/simple;
	bh=w6ReKxD/14pNfr+TuExgmiLlLorrwqV71ZSncx0/Ej0=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NG2oCWrfnOR4hn2VE6jMQR/iDJf+VU1sCd3DYWANWlNIacx+8UQ5WdsJ1TtnMh9frCfbokBJ7LCFqRmdZsqpFh4pKBG+Cs08vN+xOFEKY9p2h5OwqKnivJ5QSWal0/+I/58i/hPpQEj86ixqLJ3AaBE+6ZjOPjfNi473NI5QvZk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=yaVc5T8x; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=bIm4a54m; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127837.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53NJlF07025312;
	Wed, 23 Apr 2025 21:54:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=tNVD8JE/tmmFATMd5ePDxph8Uel2yOqbxua1l3DOG
	Wc=; b=yaVc5T8xHwbHIKhC7To+o0wN9beyXO9IpruVu/82OTUD+ecVyduYjEoEH
	broSmm4WyBlG26it27AFgySgHw29sGx3XBpiY/cSq7goPIyOZDUYOo2qKLp1GFBa
	2ltDpdwQS3ODmchKYQvYmTC0GJD1/3HJBl8U0EAPORVZiczjMU4p+S/eVLA9XSKT
	IVH4Kg2T61Nl2E/QUiAST+2tPAOdOb8ZeC/YFlgJnOzyzsQsGX36vl4NojZMlr+a
	m9uST+qmLUssTX+8+FfvI5kH/mN+xH2Ai6ZMh4r9CuJFZRUiIDrQDl0lfVlD+WD0
	tzjidsZ10aJEEgMXUy0NrTG0tkbKQ==
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazlp17012012.outbound.protection.outlook.com [40.93.14.12])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 466jhvkffg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 23 Apr 2025 21:54:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r13SAG0JRXCgv5G9ysrKLLiJ2uuxDa1C3JV1SOZnwvlWylzbEmdBWsz5qgCpu1GubzEI+PLFDY/RxiGpmkbHCAHXhZpTTc7ch06e2NvSVFf9p02x+W7uyrLX4dDyQhxgaxPprBd8Znatj6foR+YRLQpymW0S39Ha+pokGmNMdFDEzTJCtLpJNsGq2baoRzNOQdSDsHZuYJRxEwW/bXiQf4ee1SzIW6H+uHi7Xq38jlxbEgSFWyyZjHxrTh455j+sdCf+TOpr1cxoudBlck9DKt53w/FxDNJhTGetZxNkNMopMJtqF8LSbbk6SkLh02j+tqNbHuPmW+4Yi2+/WRzrOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tNVD8JE/tmmFATMd5ePDxph8Uel2yOqbxua1l3DOGWc=;
 b=Q+ZqXQa969qcgmbjps97DiOHtwnr1aviEWwIVgjZr4R2Tl9e5lyOz744Ouq4aLVB5bCiZ9ItFSbytEsrAinmjL3X3hEYJwS7vTcJ5s1ZQ2U23c23hYu9OHatDKw3xzrTOjzJVg5SDtqPetlIpX2Jei5MH0e2ZrpCl3bWqPxxVmCQVeA4viVN98n5MHXQuooAGbEr1VSMqS1BxbPxYtFJY5q4v59VHX6VxfNpDWOLLZLCnBMYa3jH/Qh4/oc1eO/n+b7eenSAb+txK+Z+t6jAd+fQ0FV7t1RuWDBQQ3a+jOQhqDt/xNbga16YWDJ+nKRY6kF/AFQFlqmOIoamYb1nRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tNVD8JE/tmmFATMd5ePDxph8Uel2yOqbxua1l3DOGWc=;
 b=bIm4a54mjzhfw2jDovzoy+9pyGk6OYHfi/1Csejldkr5ZvRxuOJkqz9bgJWn8x9O8HfjMxdIAKpab5ewWx3qyrsGVcwJdXu4TtYVhfP39W7TaYWU37Gh+TjaLeKvQRxZwAiC3LtDSUfuYxT/a6jnKvD0B/MYLNu5gA44GWJkT95TiLboL4fnDsnKr+pRCskkg2D1T6qdrZe0Yc5vhxEXYY+UGGvz8fdO8P0MW3YwMJCscI/A/3se6GdoBttE26RBAMZcn9d2rhG4rKX8oa9hZsK5CFBenjl+nbez/xWZsYT83DASAPMFH8ZN4GPdsjfnJcs44zWgoFwx4ggkaywsdQ==
Received: from BN0PR02MB8080.namprd02.prod.outlook.com (2603:10b6:408:16f::21)
 by MW4PR02MB7490.namprd02.prod.outlook.com (2603:10b6:303:65::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.10; Thu, 24 Apr
 2025 04:54:16 +0000
Received: from BN0PR02MB8080.namprd02.prod.outlook.com
 ([fe80::822a:86bb:d867:447f]) by BN0PR02MB8080.namprd02.prod.outlook.com
 ([fe80::822a:86bb:d867:447f%5]) with mapi id 15.20.8699.005; Thu, 24 Apr 2025
 04:54:15 +0000
Message-ID: <315d76f0-d81c-43ed-a13e-ef9b8e6a0e75@nutanix.com>
Date: Thu, 24 Apr 2025 10:24:04 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 05/10] i386/cpu: Introduce cache model for SapphireRapids
To: Zhao Liu <zhao1.liu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        =?UTF-8?Q?Daniel_P_=2E_Berrang=C3=A9?= <berrange@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>
Cc: Babu Moger <babu.moger@amd.com>, Ewan Hai <ewanhai-oc@zhaoxin.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>, Jason Zeng <jason.zeng@intel.com>,
        Manish Mishra <manish.mishra@nutanix.com>, Tao Su <tao1.su@intel.com>,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20250423114702.1529340-1-zhao1.liu@intel.com>
 <20250423114702.1529340-6-zhao1.liu@intel.com>
Content-Language: en-US
From: Tejus GK <tejus.gk@nutanix.com>
In-Reply-To: <20250423114702.1529340-6-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MAXPR01CA0097.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:5d::15) To BN0PR02MB8080.namprd02.prod.outlook.com
 (2603:10b6:408:16f::21)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN0PR02MB8080:EE_|MW4PR02MB7490:EE_
X-MS-Office365-Filtering-Correlation-Id: 606b325e-5d04-4fb7-0234-08dd82ec1022
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?T1dGUnBGMDNjQWtPbThPeEo4UlU4SExjSitPMHQvT0xRVGF0TlB3V1BIU2RD?=
 =?utf-8?B?OXBwWXN5MCtFQjBhNlVzUXFPRjVSQSs4Vk1Ma0wweCtlWWlwQnZsS08vbWpk?=
 =?utf-8?B?bHBvdWE1YUVzVWlWdkJadFdPd2Y5UWlpMDRnbjJCMVZBMFNpUE44cVczTjBr?=
 =?utf-8?B?djQ5YnZTcXlnOGhVSnd4cjlZMHJRODVaNGJKQ0RUMlAyVkpXUzA0WkowYk9O?=
 =?utf-8?B?cjRZQ0hDVFd2N0gyRWpGMmNaTjlzQ2JLNVJLcmRrczNqMU8vZGRrdTJwdms5?=
 =?utf-8?B?bkxZbjR2ODErY3MrYjFxb09aYWVQVEd2Q1ZxZGg0YVFMNXc0NmxWcWh5MmVy?=
 =?utf-8?B?TzR2ek8zcmRaUC9MWGJlOUFDRGExVHFTZVg1L3hheEZ2LytyZ01waCtpS2FV?=
 =?utf-8?B?R1h1ZU5BQTFoR1VOVmJCVTNyUXFMNjBsZlJSVjd4RGIxanZFcEFTRzB2UUZa?=
 =?utf-8?B?QkJjWUoreDg3Qkl6ZG8wQmpHTWhXSjZBb0hUVkxrcG1sdkQzcXVWc2RDVURK?=
 =?utf-8?B?ZXFrZ090SXh1M3dSNGZ5K0hEbkcwSVZzV2plR0JUUUt4YmdUL294bDdmVjhj?=
 =?utf-8?B?L0ZGbmZ4RVIyYjY1eGpiaHcxVGl2NUhndlgwU2J2NWJFblIwcEhFdVZlb2w1?=
 =?utf-8?B?ZVdJSUNWSEFVaEpSbEVrYVN3R01hQTIzeFdaeW5vVkRnRGVkRUJFajM3dDVB?=
 =?utf-8?B?bzl0NmYrMmkxanpQd2tKVkp1UUpPT3ZxWDArUEYzaTVJMkp4aW1mbGtjcG9H?=
 =?utf-8?B?SkhzakRJWjdqT09zZnAyZnFlc3h2d1J3ZnZDMkUrTmY4NndGSDJXYzF4bE03?=
 =?utf-8?B?dFROOXZwd05xeTRxd25mYUNlZ2JsaDg5b09hd3FGb3g2VW9JU3JiTGRQZFpO?=
 =?utf-8?B?TFBHaTZsaVhtakNIanVQWWQxT2graVgwOU9JWTJObkZQTHFiVksvL1I2NFBI?=
 =?utf-8?B?R004MVJKRi9KQzdTdDZrZkhEKzR5S1hHU2lTb1lEZVRJd2ZRcFVGeUxUcXVT?=
 =?utf-8?B?R3QzeUJKcEJaSDN6dlptYitEcHBvaC9QZDNBQWRZWWs3bjhMdjJyQ1dUSmdY?=
 =?utf-8?B?bC9GOUg2WWRvei9hb0tyWm43TkJ0NENFL0JXVWtmcmRnRWQvdCt1RXhVbHVL?=
 =?utf-8?B?RFI2L05FdkRTa00rOERkMjZMMktVeG5WaG5MOGVIZmtPS1VWSkpTK2JHNDE5?=
 =?utf-8?B?cXg0VFMzS2hFYW8rSUFXUlVEdkJNZk9Kbi84OTlKRThTdmQ1NUNuVG1BOVZP?=
 =?utf-8?B?b2U1YTdmVUhWWnhLcjdiUW9MMjVoT3BuNGNMM1Y2QkMyS3VzZnFOL0UvbGZO?=
 =?utf-8?B?RHVDeGtNOHh1bXhNZUt1SlRtTzFMS3M4YzVCRVBVNjhjZmZuODdlZ1ZvM1lt?=
 =?utf-8?B?amJNVnF6VW8vbnA1MXBta2VFZ25yeDMwblV4cEFOTEpnU3JjOE13VCt4VGgy?=
 =?utf-8?B?d3VWM3gyR2dsQ0laQ2ErQU91aENGM1RyUHQrZ1J3bUFtK1Ura2RZS0QvSk1q?=
 =?utf-8?B?WktEcC9PSy9DdXhSeDBzS01IWEFVbnBCZUMyWUF3N1lEQnFGN0FxYVAyZW1U?=
 =?utf-8?B?Qkh3TXZ5akZmUEhNUG1UQk4vc05rVDlJblhLTE4wSkNlNVN0V0xrZ0hBUWdH?=
 =?utf-8?B?NjJmVHoyM0kwcUpRSmJDRTM2RUwvdGFnWDhKbTZCa2psb3NWd3U2YlV5MGZV?=
 =?utf-8?B?bkpaU3psUFlMTUVoSndDMktHZWJGMjMwOXJidm1MZkp3bHgyL0xJeVRvbUVv?=
 =?utf-8?B?SDlwOE1oNEhNWU5OMVhCQmROSHR5ZW5ZWk4vNGpOOHBuM2U1OXdVTzMrRGVn?=
 =?utf-8?B?dE9vTzJtcmVucUxmdEF6RjNwWnhjZzlaZkRwZnF4TTc5WkZubmVVZ0I4VGk3?=
 =?utf-8?B?RHg4dkxVNEVTcFdXamw3UWJYTmZYeHo1VVFTbDkrVDZpL2lpS0JCTFB5R29R?=
 =?utf-8?Q?+rjNW3W+jk4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR02MB8080.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?em1PL0tqQ001dmRJdXVvMHVkYWUwdVo1ZXFoMDE1ZzQwWTcvMUxjdTZzK3dN?=
 =?utf-8?B?V1Q1YlA4N3pqM0JYYzVuc2M0RUdHdHB6Y2l0WkJJeGRxbjBpdjFIMVdvdXgx?=
 =?utf-8?B?SUttMnRaWkplK3ZBNlR2c0Y3Q0RVbFhCRWRuYjNWWFpESHVteFVHdnY5dzZw?=
 =?utf-8?B?OE1uY2lOZExxSWU0RXRhTUIvQ3BFVCtKUFZrcS9zR3BualRSSzdKSUZLSW9J?=
 =?utf-8?B?cW1nczYvL1loSXJYRUptYkhXbzZlNjd6TnM2L05ENmhOdURsd1BWb3BwN1A0?=
 =?utf-8?B?WXF3cU9CRjQzd0c3SWQzQTlDWHRiL0gySmJCZ25iNEZ2eGEyN0I2YmJ2b1hv?=
 =?utf-8?B?dWRjRHpMbUtYTk82dGw5UEZBTW9pVmlqZW9RNktpR1c1ZElxZzhEc2s0RCt1?=
 =?utf-8?B?WFFmaUVqSW1wcmtWZDk4Vmd2K1B5OXZuNUFvRFZMRnVncEd1cHYzZnc0Zk4r?=
 =?utf-8?B?SHM2UlZ3RlVPK0pzZy92dm5XMGNNM3VGK2krUTZTM2VuKzBYL2lXWXVqV0px?=
 =?utf-8?B?eExRaFhMOXlsNkpFaW53RW1uMkl4bHdsWm1uMmNCQ2tUcnhqRlYzZ2ZCYmx0?=
 =?utf-8?B?SVRZRjNCek1Lcm5KM21ZVEFEaWI4bHN6NHVjQTRSNXBJUmlQbXUwTTNiMjhW?=
 =?utf-8?B?b1VSYWFFTk5obU1tWlVZTFVNdHBWVk9xaHRHb21oMkJEdnlIcUdrL2w4Zmtj?=
 =?utf-8?B?QkcwU0FtSVlnN2ZlL2NybUlyQ1RlcWtacXpRb3Y1N1phUW5CWE1qMTFoaGVq?=
 =?utf-8?B?M3RZMVRtTUxJMUc5a3EzZWYzZkNTaEN0bWlSbU9nU2JxM20rd1dDV21mRkJO?=
 =?utf-8?B?ckV4OElIVzZwTWtldkQ4Y1Z3ajZhdVZQVTJaZFk0aUt5N01vLzB6MTBKZHA5?=
 =?utf-8?B?VTlKRjlNZDMxRG9DcWVycDFsdFRXUHA2VFpCK0V5RmRDN0ppajA1cmkvRmFC?=
 =?utf-8?B?SndmenhJRDUzdDdVWmQzUnA5TStDcVpLMXBzNkgzZjFEQ0JFOXI4VFFzVWhX?=
 =?utf-8?B?QzVTbnNpTjl1YnZKMFdRZHVnZ0I2dk5xUDJ5R2hZWGZuRFp1S2gxeHNzQXd0?=
 =?utf-8?B?bzFaZDEwSGQ4TGZrc3pCOXhlalZCN0NrUXZ0T3JnZ0lmVnJYUU1ZZGRsbEo4?=
 =?utf-8?B?aDFub2ZLV0lMaEsyVmt6bktGWFJVSW81aFpERHhBUHZBMjF5SDFjVVVLVHZK?=
 =?utf-8?B?NUpIWlBDZ0FzbXl0cllUSFVqMHZSYklSNjVUNk4zTlN6N2trRm10M1VITlY5?=
 =?utf-8?B?RmdEVFZqblV6MGgrTUNRZ1JDNU04aXBjZHR0K2ozaEV6VFNtOFdEc3Rld3k2?=
 =?utf-8?B?RlVEa1paY1JKeWhKODliWmJNeWFFbUxLaU0zZ0dUZ1YrMjZOUW5JZ2d5SVk4?=
 =?utf-8?B?YWprNWhuTUpOa3dnc2JSMm1CTWNMcVdaaHcxM2RhK3YxQkxPNlNUenVRdjFo?=
 =?utf-8?B?U25ORGZpR0pzdnozQ2NEREt4eTd1c3I0SGJ4U3YrZW9xSlVYYm5PUlVEOUpW?=
 =?utf-8?B?YmtHQnF1VVpLUzhIRTJlY1IxRTRsZFZiTVBRZFRKMHJsVWQzRUlxNzJFMFJo?=
 =?utf-8?B?QlY2MEoyZm9ibUM2UGF2cDV4MmZxT3ZHVHdhdlhVL0k0SUMxYWo4azBZR3cw?=
 =?utf-8?B?cktMZXBRTWxVeTlNVUtrN2tYTnVobFl6SnExd0JSbXRod1JBS0VkblQ4bXp4?=
 =?utf-8?B?aktFM0Z1SzdWS1FXUU52eGJNQXJONVVxVTlzMkdHb2JqZWxQTFlJeUJvOUtT?=
 =?utf-8?B?K0kyRGF5Tk9rbHVvVndQVkVyS1kzVm9PdXIrR3JUbDhrS0E0R1FaWHhWT20w?=
 =?utf-8?B?NGpGd1VUVEdLNWpVdVdDUkRaaFlqZmR4RDlWV205ZHZjTHArMytsU2pOU3hU?=
 =?utf-8?B?R0hQclFRZEhFNFlJWUsrWXRRTzBZUDBLTEJvVWc4cyt3L01WcEhEOWRtY01n?=
 =?utf-8?B?SThlZkVSNVpmQWlTUnZxK3VXdUlWcEUzZkpjL1NSVkMyVXNIMHVJellDdW9S?=
 =?utf-8?B?TFpaZjZlNzd5R0Z3TkhEZk5aUnNnYXFxZDZkVzNvZEt2VU5yRXJ4ZVV2ckpx?=
 =?utf-8?B?a1dpdDJJK2x2YUJZeFE5M2dad085QU9iUlFDT2ZNOVRvSHFEdjZTOHc5ZW9B?=
 =?utf-8?Q?bI6DRYltsIRg8YDbjlP28eMXk?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 606b325e-5d04-4fb7-0234-08dd82ec1022
X-MS-Exchange-CrossTenant-AuthSource: BN0PR02MB8080.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2025 04:54:15.4608
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CLBQF87hzsp/ZjR6inB+ySO50W92O3J868tf98wPabOVnGV9lBpTk4EGndI0HirH2JKrUltNZ8Cq43h+4Fjpew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR02MB7490
X-Proofpoint-ORIG-GUID: GHgw4rvm_dy_Lw6PdxTTaYeO3UxSD95T
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDI0MDAyOSBTYWx0ZWRfXyFp3VDsbDoKG GFxW74Qtg7x+VoisiBjWcLGh1bds3SCKq20oJrbB5EfT9KxCxerTD1X2kApYybEzYNM7qNmBwx7 F8b0KKsVlNN4+9/7BiFX8t8txSl0siwqDvSlfQgrHV63BnOjGm1aPVTf+MdzeeJaXHLLazEJKp8
 kzPx+eIw0f9nCZ8EA4+QQouQDSszvXAXP0W9ziSDf+EtUrwT7TD4ey8Q9Fg0/sHpR0xsEszh3u5 0I0Jw50qYXpfPdd3qNyNfA2VSOv8+gLX4erPrTF8IsBqE0VIS9Ifq0vS0uuVujZZYs2mPQsqt4M 9VsQewgA9zdTxrVK/hjDizwQxBaZaF/KjJB28IUDEuREysxUqK86ZSepzHuFSFfEiuiozaQDfN4
 vHiU6YjMSAZ8FYt8oUE2JxyesSfF50WodqT5TFu7nQLB59AWLQab4NPcEnr5Z2+SYB/CwMgn
X-Authority-Analysis: v=2.4 cv=U52SDfru c=1 sm=1 tr=0 ts=6809c407 cx=c_pps a=rJOuE113HAlAKDwVaFkQAw==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=XR8D0OoHHMoA:10 a=0kUYKlekyDsA:10 a=64Cc0HZtAAAA:8 a=QyXUC8HyAAAA:8 a=20KFwNOVAAAA:8 a=QX6PcPXmvLdf8_MoLAAA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: GHgw4rvm_dy_Lw6PdxTTaYeO3UxSD95T
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.680,FMLib:17.12.80.40
 definitions=2025-04-24_01,2025-04-22_01,2025-02-21_01
X-Proofpoint-Spam-Reason: safe

On 23/04/25 5:16 PM, Zhao Liu wrote:
> !-------------------------------------------------------------------|
>    CAUTION: External Email
> 
> |-------------------------------------------------------------------!
> 
> Add the cache model to SapphireRapids (v4) to better emulate its
> environment.
> 
> The cache model is based on SapphireRapids-SP (Scalable Performance):
> 
>        --- cache 0 ---
>        cache type                         = data cache (1)
>        cache level                        = 0x1 (1)
>        self-initializing cache level      = true
>        fully associative cache            = false
>        maximum IDs for CPUs sharing cache = 0x1 (1)
>        maximum IDs for cores in pkg       = 0x3f (63)
>        system coherency line size         = 0x40 (64)
>        physical line partitions           = 0x1 (1)
>        ways of associativity              = 0xc (12)
>        number of sets                     = 0x40 (64)
>        WBINVD/INVD acts on lower caches   = false
>        inclusive to lower caches          = false
>        complex cache indexing             = false
>        number of sets (s)                 = 64
>        (size synth)                       = 49152 (48 KB)
>        --- cache 1 ---
>        cache type                         = instruction cache (2)
>        cache level                        = 0x1 (1)
>        self-initializing cache level      = true
>        fully associative cache            = false
>        maximum IDs for CPUs sharing cache = 0x1 (1)
>        maximum IDs for cores in pkg       = 0x3f (63)
>        system coherency line size         = 0x40 (64)
>        physical line partitions           = 0x1 (1)
>        ways of associativity              = 0x8 (8)
>        number of sets                     = 0x40 (64)
>        WBINVD/INVD acts on lower caches   = false
>        inclusive to lower caches          = false
>        complex cache indexing             = false
>        number of sets (s)                 = 64
>        (size synth)                       = 32768 (32 KB)
>        --- cache 2 ---
>        cache type                         = unified cache (3)
>        cache level                        = 0x2 (2)
>        self-initializing cache level      = true
>        fully associative cache            = false
>        maximum IDs for CPUs sharing cache = 0x1 (1)
>        maximum IDs for cores in pkg       = 0x3f (63)
>        system coherency line size         = 0x40 (64)
>        physical line partitions           = 0x1 (1)
>        ways of associativity              = 0x10 (16)
>        number of sets                     = 0x800 (2048)
>        WBINVD/INVD acts on lower caches   = false
>        inclusive to lower caches          = false
>        complex cache indexing             = false
>        number of sets (s)                 = 2048
>        (size synth)                       = 2097152 (2 MB)
>        --- cache 3 ---
>        cache type                         = unified cache (3)
>        cache level                        = 0x3 (3)
>        self-initializing cache level      = true
>        fully associative cache            = false
>        maximum IDs for CPUs sharing cache = 0x7f (127)
>        maximum IDs for cores in pkg       = 0x3f (63)
>        system coherency line size         = 0x40 (64)
>        physical line partitions           = 0x1 (1)
>        ways of associativity              = 0xf (15)
>        number of sets                     = 0x10000 (65536)
>        WBINVD/INVD acts on lower caches   = false
>        inclusive to lower caches          = false
>        complex cache indexing             = true
>        number of sets (s)                 = 65536
>        (size synth)                       = 62914560 (60 MB)
>        --- cache 4 ---
>        cache type                         = no more caches (0)
> 
> Suggested-by: Tejus GK <tejus.gk@nutanix.com>
> Suggested-by: Jason Zeng <jason.zeng@intel.com>
> Suggested-by: "Daniel P . Berrangé" <berrange@redhat.com>
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> ---
>   target/i386/cpu.c | 96 +++++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 96 insertions(+)
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 00e4a8372c28..d90e048d48f2 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -2453,6 +2453,97 @@ static const CPUCaches epyc_genoa_cache_info = {
>       },
>   };
>   
> +static const CPUCaches xeon_spr_cache_info = {
> +    .l1d_cache = &(CPUCacheInfo) {
> +        // CPUID 0x4.0x0.EAX
> +        .type = DATA_CACHE,
> +        .level = 1,
> +        .self_init = true,
> +
> +        // CPUID 0x4.0x0.EBX
> +        .line_size = 64,
> +        .partitions = 1,
> +        .associativity = 12,
> +
> +        // CPUID 0x4.0x0.ECX
> +        .sets = 64,
> +
> +        // CPUID 0x4.0x0.EDX
> +        .no_invd_sharing = false,
> +        .inclusive = false,
> +        .complex_indexing = false,
> +
> +        .size = 48 * KiB,
> +        .share_level = CPU_TOPOLOGY_LEVEL_CORE,
> +    },
> +    .l1i_cache = &(CPUCacheInfo) {
> +        // CPUID 0x4.0x1.EAX
> +        .type = INSTRUCTION_CACHE,
> +        .level = 1,
> +        .self_init = true,
> +
> +        // CPUID 0x4.0x1.EBX
> +        .line_size = 64,
> +        .partitions = 1,
> +        .associativity = 8,
> +
> +        // CPUID 0x4.0x1.ECX
> +        .sets = 64,
> +
> +        // CPUID 0x4.0x1.EDX
> +        .no_invd_sharing = false,
> +        .inclusive = false,
> +        .complex_indexing = false,
> +
> +        .size = 32 * KiB,
> +        .share_level = CPU_TOPOLOGY_LEVEL_CORE,
> +    },
> +    .l2_cache = &(CPUCacheInfo) {
> +        // CPUID 0x4.0x2.EAX
> +        .type = UNIFIED_CACHE,
> +        .level = 2,
> +        .self_init = true,
> +
> +        // CPUID 0x4.0x2.EBX
> +        .line_size = 64,
> +        .partitions = 1,
> +        .associativity = 16,
> +
> +        // CPUID 0x4.0x2.ECX
> +        .sets = 2048,
> +
> +        // CPUID 0x4.0x2.EDX
> +        .no_invd_sharing = false,
> +        .inclusive = false,
> +        .complex_indexing = false,
> +
> +        .size = 2 * MiB,
> +        .share_level = CPU_TOPOLOGY_LEVEL_CORE,
> +    },
> +    .l3_cache = &(CPUCacheInfo) {
> +        // CPUID 0x4.0x3.EAX
> +        .type = UNIFIED_CACHE,
> +        .level = 3,
> +        .self_init = true,
> +
> +        // CPUID 0x4.0x3.EBX
> +        .line_size = 64,
> +        .partitions = 1,
> +        .associativity = 15,
> +
> +        // CPUID 0x4.0x3.ECX
> +        .sets = 65536,
> +
> +        // CPUID 0x4.0x3.EDX
> +        .no_invd_sharing = false,
> +        .inclusive = false,
> +        .complex_indexing = true,
> +
> +        .size = 60 * MiB,
> +        .share_level = CPU_TOPOLOGY_LEVEL_SOCKET,
> +    },
> +};
> +
>   static const CPUCaches xeon_gnr_cache_info = {
>       .l1d_cache = &(CPUCacheInfo) {
>           // CPUID 0x4.0x0.EAX
> @@ -4455,6 +4546,11 @@ static const X86CPUDefinition builtin_x86_defs[] = {
>                       { /* end of list */ }
>                   }
>               },
> +            {
> +                .version = 4,
> +                .note = "with spr-sp cache model",
> +                .cache_info = &xeon_spr_cache_info,
> +            },
>               { /* end of list */ }
>           }
>       },


Thank you for this improvement! I see that even within the SPR-SP line 
of Processors, the cache sizes vary across different models. What 
happens for an instance when a processor only has 37.5 MiB of L3 per 
socket, but the CPU Model exposes 60 MiB of L3 to the VM?

regards,
Tejus


