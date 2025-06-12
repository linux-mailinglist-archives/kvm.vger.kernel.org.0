Return-Path: <kvm+bounces-49213-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A6B54AD65AC
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 04:29:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 89AD317EF8C
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 02:29:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFE321D63CD;
	Thu, 12 Jun 2025 02:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dF9rq+2d";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="X13T46Zz"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E33145A05;
	Thu, 12 Jun 2025 02:29:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749695356; cv=fail; b=YIZF/WXH54i8YDIqZBpQPCt68UpBJItiseKxaDHUyX6JiHYA8iO86oVRKyfcheAjU3GBdWLv2G/jJRyCDGrJNEJqiA6ZU5kihU8+TEYfs4M4eaYTKTC8vNNGukmq3RNL41FUSBzNShBIKJedhnCk8A4r9dBygIHre9Dgbki3PzQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749695356; c=relaxed/simple;
	bh=tyCQvi7/l8jX2zssBgNHHYCOEUxReyB4YeCyvUTInM4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=R52kFAC+KegvFNp7Zb25NHWgoXGH9TOWMko3ELHkfHOp0p+eKmYajjin8kINSkw0Wyq8Nd5iXH/lI5nfK1k0cTojyJteqY2TDk2vp14UI3ZOvLyAyTIXTCXlLAMO4VIdLA+2xyOUxhfwsFl71LH2hrrMQSZcwb0Ygm7RWzRVgec=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=dF9rq+2d; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=X13T46Zz; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55BMPKfr011257;
	Thu, 12 Jun 2025 02:29:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Wi0k+x4phMmktOd+kSXtyRs+p3oRZLWYkOYtgsMpS8o=; b=
	dF9rq+2dEjq+fusA8o/TtmYHbGsWqZSCV2z8fHRV+b+nlZGPCr4DXYbSjPGVItT7
	UStQ2jSXBwqePmF1gT/5/3KtkdEhgRcIp1yrqWpHoDueagqfYECqGY2Y5P6L7Sx3
	5/JbQnuiX57Pu6tiV2HdJiNzjF6Jw6Jd3OK6I7X0NeTUY99C9+bmQ/fFww8TZmfl
	g4414OSOwv3bK7xTAi8CRwO31WKtihEdFxeBsoQRCkGmU5kJv2HLIOAoKD7fsMBa
	DVud9Yr5dzuIf39ijnTwTDDvOiz37cJbkDW0RkkNfKok2CvuKmePCufKBjKe7KaS
	HrHcoCpMwEnz/XF2mG3peA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 474d1v8tsy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Jun 2025 02:29:09 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55C0uPiQ012027;
	Thu, 12 Jun 2025 02:29:08 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02on2046.outbound.protection.outlook.com [40.107.212.46])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 474bvc073e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Jun 2025 02:29:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Gb/qQrMj8koMcYTfDFurVt2rFk3feKKp+x3J7JmiKbFLV6/eeJUOdE2x0AZ/9oHeaaEk6ll5NQI3Iy6j2TbXoHecvOXZsbgCijchASFtpsryu9/xK5HzD5omphdNu1X70pqWJ45UIh2FaRP5c75CCyovu5Qs3r26ZieGN3qL3ab99wxiBebh5eg3Ba0Q39TEEs4IJ8l37H3W9U7Z88UtsbCbZDa3PPBk490foBWSA2DUOQ5IMIq/4mB7zgHl0ZSJZwe7VNg/aDM91WU2Mu4lFov5Uz6VrT4oX1X5AUhB2190sLv/Ogrp5rANdCHrUaQ97V1a1ql6L/JvWJecfA5qTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Wi0k+x4phMmktOd+kSXtyRs+p3oRZLWYkOYtgsMpS8o=;
 b=SXgkohL5/tj5td7vZ70eMrm+IGa/UBnQMXRgdfwy5p4yNWFI+gzdVMcoY08xUbczZ/goRrGFwfZ4ZrG9tbhY9n1yvP6aZpI+6Qa4JZA5yLquMKZ5eJKWurExEG5ef45+GwxJ8QcDxRos/8lexhVykvGksO2sYx35lJhYixKTR9VJZnOZAS5E+wHkLXCDjxvweEFUMiSxadH21OGfBlKeV0OVS8uFodtxV0R3zRenedRUF65rZt7RsN8ZwP7q7JF2bQ6hohA8jw/MZfF2SKM0udgfHdDn1oB4blR4ObP/sjCDJT2S8wh7o7zynu95mRPXKvEMw1xEvla94Z/LjVqkDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wi0k+x4phMmktOd+kSXtyRs+p3oRZLWYkOYtgsMpS8o=;
 b=X13T46ZzTScpKMh+mc9e/T/xWV7bCK7dO2wtHaiVQ2PVVlSLwNUstZlIaxdTcbVMhiLf++LQbYhcZLZrdxshj1/DQJsnqua9WfqYirURVTDYZA7GANLpeGD9r1fnN6wRgdshBN7I3d9AnQcrbcA/hdJJ0CTImq1Q7ucofq4oge0=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by LV3PR10MB8105.namprd10.prod.outlook.com (2603:10b6:408:28d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.35; Thu, 12 Jun
 2025 02:29:05 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%4]) with mapi id 15.20.8813.024; Thu, 12 Jun 2025
 02:29:05 +0000
Message-ID: <60653628-3078-43dd-9a51-5fd46be6f74a@oracle.com>
Date: Wed, 11 Jun 2025 21:29:03 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] vhost-scsi: Improve error handling in
 vhost_scsi_make_nexus and tpg
To: Alok Tiwari <alok.a.tiwari@oracle.com>, mst@redhat.com,
        jasowang@redhat.com, pbonzini@redhat.com, stefanha@redhat.com,
        eperezma@redhat.com, virtualization@lists.linux.dev,
        kvm@vger.kernel.org
Cc: darren.kenny@oracle.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20250611143932.2443796-1-alok.a.tiwari@oracle.com>
 <20250611143932.2443796-2-alok.a.tiwari@oracle.com>
Content-Language: en-US
From: michael.christie@oracle.com
In-Reply-To: <20250611143932.2443796-2-alok.a.tiwari@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0031.namprd03.prod.outlook.com
 (2603:10b6:5:3b5::6) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|LV3PR10MB8105:EE_
X-MS-Office365-Filtering-Correlation-Id: cc872a0f-769e-4e2e-8f08-08dda958e6ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?eGJRREhqZDRSbk5VRlJSbnFJWk9XWmxLYkE5Nk1iMkoranJnSUFUbUd3M09u?=
 =?utf-8?B?NG0zc0I2WmNSb2lSSzdYN0xrYUQ5YjMxNDFwMmVwOWpkcGk3Und4MUdiV0JP?=
 =?utf-8?B?S3pQUWh1dnpQQkZrdFkxUE5qaWxEUWk1N1dwei9QNlloRktpVjZTRHNZZFgr?=
 =?utf-8?B?TUZUNHd6SStHVDZtaTJ6TktSNmprTjdkN253SkdTak5IeDhYd2FCeUVBalpy?=
 =?utf-8?B?cHV4WklnVzJOTXovNHg0TjFuTTZoN0VkbW1PaldacndzTlphWFhRYUNrMWVI?=
 =?utf-8?B?NjV6QUNuWFhtUll3R29PVmJ6bmdqL3dVdUpDQzROTHNSRElNa01HbjErT0tw?=
 =?utf-8?B?SzBkZVlyam1PUUR1T1ZodkJCZFNBblpHZjRBNVB6aFM5ZU9jWGxkTVNYdTFX?=
 =?utf-8?B?OE5WOHVwSlcxL2pvYXp2SFRaYzN1aDMvRm42VXFXY25OVDZyZEw2Nmo4QlZ1?=
 =?utf-8?B?VUlPYXhLV1NMY1FxdE84OTJYczdvakFyTHpQQXJqYXlwUktsK1ZTSkZ2Vlh2?=
 =?utf-8?B?MDRYcDRVSHNlZndhVE5Ick43VWZWc0NpMFo4ckR2cEhlcjJybERZdHAybzM4?=
 =?utf-8?B?S0tZcTkwckNIVDFER0VXdlh4d1lYTlZJRzVzS2lUdHBIQnh5MXcrYmp0b2ty?=
 =?utf-8?B?d00wTDViNmhianF1QmVscGwycHNZakdhV29kRnpIWEVlNkk2QzlKVXFYTExt?=
 =?utf-8?B?bFJQckNleC9YWHp4cUtleUtTTmNXbjdodnFqMWZlMkQvL3pVa0RkdjduMldk?=
 =?utf-8?B?TktJZUFZMU9nc3d0VWZnd2NyTmxaakVRRjZEdjJkak9YZ0g5WHduQzRIcjJk?=
 =?utf-8?B?c2JPS3JCWE5yanpSVStvNHVBaGpGeCtWaUdrd1Y5YWlsVm5xNmdCUTNNQUEv?=
 =?utf-8?B?VHFRL1dNV2kyZFoveHdMcmVCT3pNVXdRRWFKYkVxR2kwMVFFYklWN1hGaFFP?=
 =?utf-8?B?SWs5L3IvN3picjRwdnAyd1RvRjJORHBJWTNIRVJ1Wk53YjJyWlNGSVB2UzR1?=
 =?utf-8?B?RTdTNlVLbDdLdkFraDVTdFFhYXRDMWJlMlRWSzhTUUJiWlhHWDlkRjNYWUIy?=
 =?utf-8?B?T1k4NUsrT1lBZlJjWmlIQ1F0NXd2R1RJbE1idExnbHlJZEpyVWJSTUxoSnZ5?=
 =?utf-8?B?NUNaSEFSaEFLamJmV2RlQVBTQXNWbjBMS1RHRGY3MEMrbmFsbVdrME1SVTlq?=
 =?utf-8?B?K1QxQW9PNm9FV3UwVkNnaURCbmpwYS9UekU1cnU4UDZQYndxek5rY3lIYjJr?=
 =?utf-8?B?S1o2K1B5SjJaUVRxZkFVaUxsTVBjemNhZXdTK0ZqVnJlNklXME9FMnNiSHVm?=
 =?utf-8?B?MU5IZGdkOHJWUVYxNTk1Mm1SUzA0TXBIL3NWbWY0NEc4dlV5bEhvZzJ2LzRG?=
 =?utf-8?B?SjdJMTBKZUpoU0U5TjY0OVZ4dnFxMW1aM0hJSnN2YWRlSEZuL1Zyc1p1OFln?=
 =?utf-8?B?czNleFBMR2dleVJZOUs5cVZYZWhvZTh6eWpjR2ozUmNUbkoxb3RiZ2ZPZFNr?=
 =?utf-8?B?a2hFTjF0ZzR2bEo3TXRsU3lOSkpUenlOU2Zab1QyOFNTZTNjdXNCeENpRnJw?=
 =?utf-8?B?T1R1Q0VkN01ldStNTEJSMXVZck9JSnVTcHZTQzFXYy9qZHZMU1I0QXJiQnF4?=
 =?utf-8?B?SXl1aVVFejBrSWtCcy9ieEE4TmxBQlYrVkdlT3dzSmNMSW9iamloaHJSUGpm?=
 =?utf-8?B?TXFSM3NhSFdsL1FudXBIUDRQbml3Qk1TMmdVdGJyelEzS2ZFMmExaDBQZXlK?=
 =?utf-8?B?djZzUmpMb3NucWxERnlIMWNid1NyTHlta1NlN09NSUpBMkkwcXA1T1dxTUh6?=
 =?utf-8?B?SnNydWJlTjV3Qks1ZkNWWVlIYlpwM2g4VVhZWlAzUG9GbzJaQTQzR05GNWsv?=
 =?utf-8?B?cHY4RU1udWt1SlQrTlFOWGsvdVFIU09JR0V0S2VGb25sVlhtS2drcFNKeWt2?=
 =?utf-8?Q?KW+vYRCyp08=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TUZ6WmVnRTc2bXJzWUpXbE1iL01qNjlDSnJUaG4wdlp1QStNZkR3b2E4UGZm?=
 =?utf-8?B?aWE2MGI4WDBuL2hIUm9EU0t1VVBMRURBVkdhakN3cEtGRTgzV2VTYXlaMFUv?=
 =?utf-8?B?cEJtdkp3YVVRRmJGQWkyUGRMRU4rMmdTSml2ZUwvaE5aaHVCWldXUklZQk5N?=
 =?utf-8?B?T214ZHp3NEFMeVpiQkVTWVhWbXZJYXY1aTlZS0ZQUVhpTTdwTEtYemVwVW5O?=
 =?utf-8?B?Uk94RVZuMjAvcjFWNWtxaVZFQ0hhRGF5NDdrc281MGVTQ3dmVjNLTnJyamdw?=
 =?utf-8?B?cEFJbEpBdlNJQVJEMVJsVDZmVGRJT2huNW5PMExOSFlaQ1duL1dScjVGaWFO?=
 =?utf-8?B?Z25nZi9SaHk2T3ZBUzlPVzlKTElhWE84eE94eWRXbEQ3VERtZUdVZWVzMXJs?=
 =?utf-8?B?RnlLYTM3bytRdW1xTnlrZFNGWTFBQWJ4RlB6aGpzME42WE4zTWdvV0I2QTRP?=
 =?utf-8?B?YnpkcHZKUXpCdk12TWRwM1FRRk51NHhaSHB6OTNEUHIrb0hlSW84TFNlSWE2?=
 =?utf-8?B?NzBsTE5SclFBMEw3WXlLRVR1YjRzakF2c2xtOXNxNGVqNVQxaENPQ3ZkUzA3?=
 =?utf-8?B?b3FZZ1JJNkw1ejY4VlVYWUYwSjAvejJKbGVNTFl6aU5OVjl1M0llRFRzR0Ji?=
 =?utf-8?B?a2cxdDhYL1VQeThzYUFoN1orY2JxVGxYb09xeno0cFFFdlJGVFBTSGIzV01O?=
 =?utf-8?B?N3J5RXNNU2ZuckxOMG1tSlZMaG9uYW13TTdZbnVXZ25HZ3FlbExpS1psNFhP?=
 =?utf-8?B?ZkJJMXFkdGlRTVlWaUVUTnZsQ1FoYnNDL3p4YVdzdjlUWTFyVHdIeXE5bjJu?=
 =?utf-8?B?alZITXh6a09rZ3ExZ3poOUt6RFYxMkxhRU9wQStRMExjM3ZlaFRRMXdxNFZZ?=
 =?utf-8?B?NWJyekdNWXJBb1pWOC9hN3lNZkRpa1dEMTdTWTlSb0dMMVJyWTNGdUJzeitq?=
 =?utf-8?B?VDFoYnpPenJkdmxhWk1oZ0ZMNTczaGZNR3QzQW5NRW10UkEwcGFKZ0JsMHlR?=
 =?utf-8?B?WEY5dEVDVkI2SEVGNUVobHlhUW9TNVducUd5Yk1lYVA1a0R3TklHYWpWbmlE?=
 =?utf-8?B?MmhScGRZWTNJZ1JUcUNVWkx3Snc2enBnbWlEQVpXSjVnK3dUSklLTmcrTHhH?=
 =?utf-8?B?MEUzZUxydDNxY3JTWXFBcDFNdG9nczBtdC9OSzdlOXRWeDNUUGFWTkE1R3pl?=
 =?utf-8?B?L2xrSE02ZUQybnVJeWxvb2ZsN2tLaGsrWm1BRlVhb2xjRE1oNE4xK2Z3cUNO?=
 =?utf-8?B?MW5CbVZSQWpVdVNSeVFQdWhEMnRGaXFSc1hoUHNGWFJITGlQL09neW9OM0tT?=
 =?utf-8?B?Mm5uUy9jeGRUQ2lxd0lyV2RnNjJvWC9FaGRtVC9YZEZhTWdWZDRvcjFHNkNQ?=
 =?utf-8?B?dER5VkU5aDJETkswc29pTjV3V280d2EwWXNKM0dYc3FYYXZWbVZzTGo0clBE?=
 =?utf-8?B?enpKbUtadnlkeHFWUEd2VG5TWXc3NnN2TGZFbHNhSkFUakhaZThPNWNuYXVS?=
 =?utf-8?B?cW5oMURWemoya1hyR0NrV3BIZWNpM01kUjg5MmduQ2k1V0dYQUs2dTVSY3Vi?=
 =?utf-8?B?ZzlDNnNWWTgwQmNlUEdGUUJLblpVTGdKSlVPL01sdDVWZFVsTFVTK1Njd2RV?=
 =?utf-8?B?RkJiZ016QWZYZzA1bEdCdldHM2JLZkVidWNMcmozek9KTm0vVnAxWUFFazlz?=
 =?utf-8?B?OURGS3EveW9QSWltcnhTUjJ6Mk9ucnNLRGhKMHMwSXBuWm9jOXlRUFV4MnlZ?=
 =?utf-8?B?OXk4bUtHN0RRZkFWTGVmK1Vsc1g1bG1oNVRFMXVjTmp1bG1hUi9GUlU0Mzd0?=
 =?utf-8?B?SXp3RlhEejdGQmRtUU9tQVRzNlVwbnpXbUcxR2F0aENLMlZudDlHbmoreWVs?=
 =?utf-8?B?MjJuai9obFhtenExZUsyK2pMTVVTQ21oSmRHZGdTVWtLZ1NvTmxiY3hlWjJi?=
 =?utf-8?B?d1Vrd3pxWlphWlN2b0RONGVaQkVyK0ZqMWlLWmw4QjhxL1ByaUt1YVlrNWhl?=
 =?utf-8?B?Zk83V1pMQldQYXNXem5QTmZ1Y1dzblE2czA2Rm9MRks3UHpSY3VZRndGUlFq?=
 =?utf-8?B?UzA4ZGF4eW5mcnY3YSt0VmY3cmhHeWxmTTVnVCtVRDFEZ05MWUg5Qk05YVJa?=
 =?utf-8?B?N3E5WExoNE8wM1hvRjBwR2o5UTlHU090N0NIZS9OOG9aOWdRallRa2FXVlha?=
 =?utf-8?B?M2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	kjuXNi0R0zqu+appWC/UoIt041mDj0hu2V6u3nQrm8i4qJefu28FYrnmrfooGJaD1QUX+W0pt/WWOM4KTFo5/7jHFe5ZJ95yHIk9uPk5BDrRCpEtHYCtrmQDmpPien/Fdm3FyObl72QV6LaRoPFQsKD1qtHojfV4XlsND27gny9qhcOzHtTtZoWSYj4m6jf/25vPhlMpVEhKc/zecMx9KFr47SgggvrV1x2NrGVnE/d4/XR6dMGZ+OdOg0OWAL5sHkTZgGY0EA4V4xmDq9ZWUcGpOsainffz/8NY6Ka6luiYuSAsnB6Y6Q1VMPUOKYJv1v0uP4GiasrqScUqrr7fZv3TZqF1vzEcQ1oGt6rdTYRpoAcFrtgzkcvgT8orO3PeiM0iWm2WTfOrW3NXob8t5VVOW0k2cz9snaXkVCqJ8ibRWNYMtn20e4qpVjoRtsoE00mkIYe56j4x5dVkg4Gh7oRr+V3y0N/CLDGnNd2RgLb1d5asavPdyl6sGvHW4wyoIQi3TTG8Ug+9og0TJXtSOXE8CBFch/cp5DbWFmS6VvPkM2iH/A/Cv7CAjMXSnD1lSkOx5fJ5jsUzMknFz013vNJ33Z2YylC2JkZY8F2uKNE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc872a0f-769e-4e2e-8f08-08dda958e6ac
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2025 02:29:05.1215
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sbx9d3s6Kg3J0A0DnXdDocLJy/udQBQIx9+FJQz/12t+Rv7h1ML33k5dMgM6kPqcL55vB8ec6DsXjw3jmsOE54f+QXbF9Vi4YCudTZmo1HI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB8105
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-12_01,2025-06-10_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506120018
X-Proofpoint-GUID: Se7Ydpo8OkbkOjNVlfLz2kNKVrQ2tWbC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjEyMDAxOCBTYWx0ZWRfX7yNs5rpPHQxy eoottmxju5KSKWmzuh3IsiEY3YHS3sZfGkV1d/5Zf/VsFY1YuRDePoxLBK7VV4hfy/+xFxwTMpM 5LWACzQz0eZpG9f8eTSpM1Gp+cwCHimXUM2JBCa+qV7GcMNYfowf57Q2JHcP/NO5ZMYlff+XiNw
 1QyrPLI6NBOKDhV7pWufVYu9FghkywO4O/voGDYPfpHNS45OdVq+G+9OY/iUUczG9L29KM1Q2J0 7orMP7PLvICzFdrwwjKAR0Aa8GoX9YdWaoNNNxxsfSOHHWrkIsrzh0dBvY9cPG+j9dkecf+PQW7 VAhNKklQxJu/ATGptJz/dG+izRAgqvguPvL5wXTnWghI+XvV95jS9/tD5J477t0Z2qGvX8VPf0n
 CglliSSpc7dAZbTC2d8BPz+NQRTYptA6EHc7zTfwdH5fQccxPNc5jNs+FPdOSAGCghwv+xDE
X-Proofpoint-ORIG-GUID: Se7Ydpo8OkbkOjNVlfLz2kNKVrQ2tWbC
X-Authority-Analysis: v=2.4 cv=d731yQjE c=1 sm=1 tr=0 ts=684a3b75 b=1 cx=c_pps a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=3kdWww3u6zzPVtheA2sA:9 a=QEXdDO2ut3YA:10

On 6/11/25 9:39 AM, Alok Tiwari wrote:
> Use PTR_ERR to return the actual error code when vhost_scsi_make_nexus
> fails to create a session, instead of returning -ENOMEM.
> This ensures more accurate error propagation.
> 
> Replace NULL with ERR_PTR(ret) in vhost_scsi_make_tpg to follow kernel
> conventions for pointer-returning functions, allowing callers to use
> IS_ERR and PTR_ERR for proper error handling.
> 
> Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>

Reviewed-by: Mike Christie <michael.christie@oracle.com>

