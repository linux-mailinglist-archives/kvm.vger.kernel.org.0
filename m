Return-Path: <kvm+bounces-50949-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D97B7AEAF01
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 08:24:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3F066188CB40
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 06:24:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 273D2211297;
	Fri, 27 Jun 2025 06:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lxfTT41J";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="sTrnA1Av"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5689820A5EA;
	Fri, 27 Jun 2025 06:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751005449; cv=fail; b=J3b64PugwrHHeHQYCj2ca9NLuZ1WJFy0NgFstdI1DMR0WGGNZO34Yi7ACocfINmm9ew3yqosGX7bIKUgZesG4uWb4IhBZMX31K1Ni53lBvPXLzSdnOcFRfGJgAw8meaWOkTjYnzkC7hEDgjaMpsY6iY/31X355hkJ6sqBUejze0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751005449; c=relaxed/simple;
	bh=E1xCML0w9SXnc6uCTrvsrR9U3ud18fHQw7MIyahk+YM=;
	h=Message-ID:Date:Cc:Subject:To:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Gh8VO0KgGBvA5YA+hhzazmTtVdP7wTZz9QpHvcfxeoTScGCHbmNpPbwulQ6I75OGFW+PxLAWnBlh9YJKf1VdAX/07LM9p1mF3LY9pEug8kWQN5INoOFB8Z/RgYm0oIKxsexanb7pCmyh2OxrDMM5HdP+8Pu/wY+muC1NP+E+KmA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lxfTT41J; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=sTrnA1Av; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55R5MlJW028473;
	Fri, 27 Jun 2025 06:23:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=bGtpXko7/2fgAuOlZLtHv7UI25NNoQkxs+FebUvX7SM=; b=
	lxfTT41JiqVVQsfr5/mKHI7k7h9BhML4900Gnbay/8ZlP1NR6RxOMchWFwXaXehT
	9awtT7YleUq7ly/BzvyiErHwmJukqJgtOKwC0oysWFtXZZ81dtTf+OqdseslUK5D
	cySdrdkPpQe2u9Jl8BaM1S96+83QjP2m5Dx8u8kHGLto/OLbj53Gh3nYcRPrw2Mv
	uWWm0+hTnac1iQbStKPjxHDdbMJcJLWo8lkl1WE3jQ2uuWQ1YAGgGAdpiqZMUGBM
	X1BsUJo+GPHDNqkDHCtID6/nlU8OFLZMamjEa2SehIBazukfGj9UlRV1vrK+A0pm
	vSpu25C5/Z0acQBNsZ2u4Q==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47ds8ybacc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Jun 2025 06:23:59 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55R68MQF034140;
	Fri, 27 Jun 2025 06:23:58 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10on2067.outbound.protection.outlook.com [40.107.93.67])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47ehptx1h2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Jun 2025 06:23:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sXOQYmMIwY8tSQ/C4Yv2uW/uHXwN946U2nm/Y6H7oJHdgX4qJSSUIqS1y1JnYAYYG/vyObGBFXXvDkce1v5sGcJ/QynuwEkYKM67TyZ+52j0gtxBhbGxkZMELhV/Zqvn+kJF6YiYYiCHxlgoLxTtPeeqKo9oCB9CyKDqgKgWP8NpRUvhI2rPDZPk9bW7gkkEL28A7SgyloZk9eF+Zae0ZIa6Hj0wtJsVFewSf+CTpz5yoeCrdEWWia+POnLiNp99OUswYa/mD0KVegzTAqKpOoVN0v9goFHw+IehMb3nEHywgIBucy4a0Ya35mWYp4ecaFhaNwkteeUZ4YwoV8UJWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bGtpXko7/2fgAuOlZLtHv7UI25NNoQkxs+FebUvX7SM=;
 b=NGvxKC4gviZu0wCvdoNVgHxOqmigVuUxWLzbnal8kaTsAE0JI97Lptu/U6nuY61ZjySqSY4IaxhbFnPdC5d2jpDo49XZ+1bkDHrav5bHEhIINrLPUw/I6IcAXPzN2QI79xuEYpw7aefKZhfUn+d1tv7ZxvfmEp0qvkXa16jnON25pUXV0rYtW0dykB6UIe9lUqs9dKWDnpdVFcDi6jWVjiR0Fcelo0v/Fy4guYBwKfmqfDWRoT8vd1+8FmAvnhjFfanZRzTyxlaih+fFup7RDhaxkbXu9dSCQuIkxbj/vVFOpIf8YMh2HsKcCT4Q1A/EsglGqjhTv2KPSveLIEsqiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bGtpXko7/2fgAuOlZLtHv7UI25NNoQkxs+FebUvX7SM=;
 b=sTrnA1AvwRxYiR14s7+w6CBOta91aBfHlnSq4rCr1bp4L3gZVWfUojV0Jx0llCkLdU9TuCKdVSqod4gXwNfUe+MWg+3Ve7NbH2zgdtgv61eduD/JU3T1FaQ5t0DcEgvIeg0GWxkAotAiOcEfjIX6Ad+3qif5lZanBJqdKIV8ON4=
Received: from SN4PR10MB5622.namprd10.prod.outlook.com (2603:10b6:806:209::18)
 by DM4PR10MB7505.namprd10.prod.outlook.com (2603:10b6:8:18a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.21; Fri, 27 Jun
 2025 06:23:56 +0000
Received: from SN4PR10MB5622.namprd10.prod.outlook.com
 ([fe80::6bce:37ef:d1de:d084]) by SN4PR10MB5622.namprd10.prod.outlook.com
 ([fe80::6bce:37ef:d1de:d084%7]) with mapi id 15.20.8880.015; Fri, 27 Jun 2025
 06:23:56 +0000
Message-ID: <61df5e77-dfc4-4189-a86d-f1b2cabcac88@oracle.com>
Date: Fri, 27 Jun 2025 08:23:52 +0200
User-Agent: Mozilla Thunderbird
Cc: alexandre.chartre@oracle.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, pbonzini@redhat.com, x86@kernel.org,
        konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH] kvm/x86: ARCH_CAPABILITIES should not be advertised on
 AMD
To: Xiaoyao Li <xiaoyao.li@intel.com>, Sean Christopherson <seanjc@google.com>
References: <20250626125720.3132623-1-alexandre.chartre@oracle.com>
 <aF1S2EIJWN47zLDG@google.com>
 <67bd4e2f-24a8-49d8-80af-feaca6926e45@intel.com>
Content-Language: en-US
From: Alexandre Chartre <alexandre.chartre@oracle.com>
Autocrypt: addr=alexandre.chartre@oracle.com; keydata=
 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
 swLliy6PdpST
In-Reply-To: <67bd4e2f-24a8-49d8-80af-feaca6926e45@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PA7P264CA0264.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:375::9) To SN4PR10MB5622.namprd10.prod.outlook.com
 (2603:10b6:806:209::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN4PR10MB5622:EE_|DM4PR10MB7505:EE_
X-MS-Office365-Filtering-Correlation-Id: b9016273-1623-446b-b14e-08ddb54331be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|10070799003|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cFFReUYySlkwR1N0NnN2UkJwMFJHTmNTcklsemFTWFltL2s5Ri85UlNSTmVq?=
 =?utf-8?B?RUcwcitFQWZjbmRjSEZuVjFIOGtFTUg1ZTdUY0pobG5uZ0hrSzB5RXBZZzlp?=
 =?utf-8?B?alRFdVlVNXdncTdUelBRTkFMeVVZN3dEODBJR0c3Y21yenpCWk9POGtBR2lN?=
 =?utf-8?B?YWVNT2gzWXlBOVg4YTJtYmNPUkRhRFhNM0NJK0F2c0FFSHZKN0lYSDVNTUpv?=
 =?utf-8?B?MzBZWVVBS0RDbmFQTEdiaTJOL2RNZEhkZnhLRlFxQ25ScG42dmU1ZVdiL21x?=
 =?utf-8?B?UWVzNWNrTTZNL2JYYmJqU1Qxc0VVVWpPRS8wVGNCdlA4NHRjbktkUDdvTXM0?=
 =?utf-8?B?MkRpRFp3Q1FvcEgrUVgyNWR0bkdIYmI1cTJ6SElVRlhnRzBjNm12c2ZsblZZ?=
 =?utf-8?B?YXZacmVjbzF2Y1krVUZ0R0YyL0RPc1EvT21TUmgzcnlLUnJzSGYzeG4xQVJk?=
 =?utf-8?B?eldBWkwycVdEUjlSWkhIZVRaYXVnMzVWZUN6NHZLOU80WGUvcGJBMTQyQWR2?=
 =?utf-8?B?QS9PU2JQR21ibnpkKzFtMldGM0R6MlNFM3NzYUxBOTBESjBRclhKbDNmY3NU?=
 =?utf-8?B?ZEt3QVJiZlR4TUZhV3g1UHFvOWNLNjVLL1dHSTNVdXdSUmF4N1NMMnQxSEtC?=
 =?utf-8?B?SDkrZk9TK2VrbVJKWUFldW5TQ0JRbm5GNFJ1cmdVakk2QUhWU3g2SWRra0xW?=
 =?utf-8?B?eUFUbS82MlBxQ0E4Y1llbkVnZEN0OER6ZldhUlV6Y2c5UFdBajJLbnl0SmFz?=
 =?utf-8?B?RjM4elM0T0loTWlORjdGaEJHQUMzK0xiYkNFWW5MdVN6ZlZRVEk0NFlzSkNv?=
 =?utf-8?B?WTlaWDFHQ3dCRUJTVE55Mk1IVkorOEVGMDNxcGF0RVYyclNkVytCMFozd3Ra?=
 =?utf-8?B?R2RkamQ1WURSZkd5V1dBQUEyQUdDQVVIUXEyU2FIZm9NT24rS1U0dTdMaFh3?=
 =?utf-8?B?QzJJSk5KV2dZQ21BQ0NqUUM0WEMvK3lKclg5dFlOZVNoQyt5d0R4QnFIblN1?=
 =?utf-8?B?UmFTVVE4bS94OXlxUGl2MWN6WlNFNXR1S1lKUEF0TmhYME9WV2plTjlwUkFj?=
 =?utf-8?B?Y1lsTm41Ty9CWnRHUkI5UUFWSllPSTBKTE15MGZEK1F6dWxxSlhTMUFPUWdw?=
 =?utf-8?B?anlSRmgrbjdHMmxpZWU5Ly8veWx0Q1NUc091bEFJdE5xVDlZNkR2Y0NkV1Ni?=
 =?utf-8?B?a0tqNEp1VWlQQXJyNDF4MGFSL0lHY2IrTkhoWTQ0a0dwZVdLell2N1RuWDZQ?=
 =?utf-8?B?c2RWZEt4c3ZILzk3TkVVYzBKVFBKOG16OTMvMTZuaURDeHBuRUVtOG5YZmpP?=
 =?utf-8?B?ajROb1d2YmRyemo2bnc5QnNCbXJ3dlY3T3dtejA2ZTV6MUltdFRiWXQ1MWhM?=
 =?utf-8?B?VEZnN2lUMXhySVo5MEtpdzRFVzVyOTlkYjBDTkFzK29STk5wRVBqUUxWTTR6?=
 =?utf-8?B?eHlvMVdjb3pwR3pHOStSMm1Fb1E5OXFZdXhOTEhHSUZqNHkxWTBhQVd1M3ow?=
 =?utf-8?B?V2dST1BaaDV1dzFraGxXbEZ4OEFSaWMxaC9FU3VMT0FRam1TUW9QNW5TTkZs?=
 =?utf-8?B?NVY0QmtYUXlzaXU5RmVRbmJkSzQzTVFOUE5LUWZxUW1mNlFJZ2lHa0kwc3hq?=
 =?utf-8?B?V3g2OUNHOUR1OVAyVmlqejd1cWFrVEduU1ZUcU1ieEN0Wks2MzFwcFRpb28z?=
 =?utf-8?B?Y0dzK3h5WGdhMnE2YzdITUJFQ0t4NHJOYkpZRWNWS3BpWTZ1dFdpYXNGK1li?=
 =?utf-8?B?bHh0SEJ3Vk0veU1FMHBiWTRRWHRTS21yNXhhVTlKRjdZNndObVhYc2hCMVpN?=
 =?utf-8?B?OGcvc1JZazA5NTJMY09qZVdsYWdKQndlckVYa0pTZ0hzVEJTcWNlc0RaSVZC?=
 =?utf-8?B?ZXFYcjJxaG1zTjFIMWJnbzhxS21PQjVTZXp6VkhWZjB6VklKR3Q0R0FJMTAx?=
 =?utf-8?Q?UbdNB+c+2ok=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN4PR10MB5622.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?K1RteEpSWEROK1JyQk55OVY5UEc0cHI2ZWgwUWdwS0QrdUFyRW1aV0xqWUpI?=
 =?utf-8?B?Z0pUVDM3NGx2TTAyVXNvQ2JHU1NVQXo4eHgySm0zenIzOVJzQmR2UWh3ZHUw?=
 =?utf-8?B?TWVwV3Y5NW5oZUtNOTR4b3pkYjlxNWVHRzAwbUY5WEUwOGpjUnV2ZXJ3ZCsr?=
 =?utf-8?B?V0liSVRhMjJRUkZOTEY5NjQ2YkR1OEY4dXgxTDRTWXdiY1VRV0ZRQXcrUTc3?=
 =?utf-8?B?d2l2cTFjOHRTOXRDZjNTditUTjhhZEVERnk5TzRPZXN4ZlBLeitZc1AxbHJa?=
 =?utf-8?B?ZlJBVU50Umo0aHN5YkdmT3A3STBsUVMxTHNId01TS25LcW9haFhsa0pST2xS?=
 =?utf-8?B?WVpIN3dscXgydWUwcEVTUUF3WUFpR2JuQ1RYbTA1QitBQmFSbGx1eWNJclNO?=
 =?utf-8?B?dVFVOHNlSDhqU3MyU090VC9NSmt6NWdnYTB2eHVYTlQ3dkU5TkYyMzdqUlpE?=
 =?utf-8?B?ZHZBT1ZqU3lxQlVRNEgxZ3JzQ1hwRlF3VUo2UTRZdktLNmFDVUd2Z21iQVJQ?=
 =?utf-8?B?T0k5V25UbjFoVi84Tk54ZTdsTVUwdy9Fd01WTUwzMUZPM1B3SVBPMk00eFpJ?=
 =?utf-8?B?MHllRDkyU0wzcE1iVWpGcmhSMDg5WmhYQ1IyZ0JqYWgzWUEwS0FWZzJVcTdF?=
 =?utf-8?B?L3IrOFd5L3JpaTBheG9UMDVwcUZpMkgvRHhNUkVHOFkyYS9vcys1dFFCTnNG?=
 =?utf-8?B?K1R1TU1jaGRBTU1vV2kzN2ZMUkpQTUdVUnBGWi8vcENOcUNRV2dDa2h4WGU4?=
 =?utf-8?B?VkpqVkhWTlZnamZpTm5rSHlJK3ZVNmpRZHV1bEZIbWhjcGVMZjZqL0dua25Z?=
 =?utf-8?B?S24wMklRemdlYWJ1M3NUMjFaR3ZTTXpJVGhRS0ZZOFRxNEJWazVldWtIWkVE?=
 =?utf-8?B?Y3N2ZE5FcEZUSVZRRFVEWUd4QkEwTjBLWWdidnNSUGlDOE5sUXd5MDc2NXZR?=
 =?utf-8?B?MEw3RXZvSHVmSlJocEY4VlBYUnJiRmxYUGJnWVFWZUhDMXhTUERkSHd6aDRu?=
 =?utf-8?B?Uk9lUjRiVlJYSDhrdzZwb1JzUExNdjI2S1FmTnM1ZDVneEg5bEpxczhwR3h1?=
 =?utf-8?B?TFAvSnlEbWN3WE95Wm9xN1k4UnhNZENrc2ZreWRQSU1YaHRvZGRXMWhTQ0tG?=
 =?utf-8?B?bkNjYjk1R0FGMzJvalRaYWtMb0xaMXhmQ0xvenlMbzN0cEx2dEp6OXhmN0x0?=
 =?utf-8?B?ejJEQ1g3V01vWnNXMGlTWVJCVjVLTGMraE5LMWhncnVRa2JMbVJZdmtLUUxk?=
 =?utf-8?B?ZWpOS1A1WFNkMVZKRXFBN3dNbUhSK0d0ZWRpOXl2eU5HTmdzYUNwd095WmhE?=
 =?utf-8?B?VWIydkt0VzMzeUpWTkViYlkzbkF5eXVOQXQvaHFPNzIwN2pJME5GV0pXRDAz?=
 =?utf-8?B?TzRqbStiR21la3M2Y0UxNlkrYURJS3ZvejhPaG9OQUc2Y1dURVQybytHL0xT?=
 =?utf-8?B?KzRrOXh1LzFMOVFHQkY0OFlDbnNJVjhKZi8vYytyOGtrWG8zcjVjdW9zamc2?=
 =?utf-8?B?VThjUzlWU1JaVHhNRjdhMDk5MThMN25mU2dpRm1KOHZwUWpvNHozdUV3UXRy?=
 =?utf-8?B?amV6UTZuOEZDaU01anY0d3lVOWU4RUJhbzljV1EwWDQrMitkbEJRSUgzUXJo?=
 =?utf-8?B?S0FOU3VBSC9EM2c5bitlRzBrcWlyYnB6aEFQTnJ3TktQZU03MUhKVm93bVdJ?=
 =?utf-8?B?a1doMm5mTTU5c2VOZzhUV2JUK1M2ZkdRM2hadkpHSGNZMXp0L2JUR3djWXZ3?=
 =?utf-8?B?dTJvNk5oNW5wR2VZNjJKZ2xWOVdYeGhqL09vYTlPaEFEWTJPNXdQSHA5azdh?=
 =?utf-8?B?cXhYeXV5ZEVuamhFRzhuZk5rcGVmWUdLMTY3aTYva0ZKSHFTN0dVUWtxcVFJ?=
 =?utf-8?B?OHEza0RRd1Z0R2lGZ1VWd3BZT3ZINERTVmc5clJJWjFKaDhkNTRzbENKVmdr?=
 =?utf-8?B?UHVjU2FlVXJJMHd3eGlrMTFMbzVXTnk4QUFaZ3ZSR01uSWtKa3R0YWdyejAr?=
 =?utf-8?B?RG5hS1VHQmdVandMdVlocFNLc3FVbmM4RzFZSGV2bGRYaDhWQzg3MjFBV1BC?=
 =?utf-8?B?ZUU2QkpnN3FaQnVMajJJTnF6Zk56dW1SRlgzYm9yZmFiRVQ1OUVucnBBenli?=
 =?utf-8?B?M1JuYmdnbThSOVNGRkhub0RIT0VsOVpiVGw2Wk9rb01PamdjTDArN2lOZ3I3?=
 =?utf-8?B?bzJYL20rWjlkWjdNQzFha0l4cFRLUy9ZeENidmg0VFlVdFBpZFpER3FLS3Bu?=
 =?utf-8?B?N1lkdEgvMFozTERwZVMzS1dvbTRnPT0=?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	dEAmKtKrnsW7fZPRLT2M5bt4eG5uzBGqhyoGnJTbBzcCCgYwPDLLbg3XxKnG8VafCelt3pDWLDshtrXr7TuGNQwYbFmg9XycDpiBoOcXUpmlWLMre2QJkasIGZsS4+FKT4Dp0u/g/XYeyUTmz8tgTgSnmYxY4TpodIfeoq9as+oYb+L1Sqq+FzHdc1I+AW1KzORg8n7rlJeiYels0o1OzNQ3uk+c6aDi6fzY+VaeLlZSb1LWFFtwCodq9Euk6o1O2amQL+Cce1Knmez5CBY/lEcFYLI1txckkpx9+AOAtBJfDqrs01oYKgGocXSaH2yxGfTI51qX1n2M9Vk5YEtgN0fY3Kv/TFDId60qvfxFEF2zKld5x3YMz+OW/CvyJskZonnXer/DTVY4gTUWS5YFI96/G/7T6AZkPaVf/b3fKU1/5KLdOfV1Boo8RMTjOaDkcXowDceotml7OR3m7CXKRCu2ElxOleKi0t+2jSqurYLqVrhigy5t0GCWmtxzvOoCxlo8jOpvXvmr7g5r7fkvzj6GxWxNAAYQA7+vRvckDh2NV82O0fxYN5d8WA2BV1aOCj5ez0DvSzbca9WGWCv29dP3suzqvpv8fqrekEUd6x8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9016273-1623-446b-b14e-08ddb54331be
X-MS-Exchange-CrossTenant-AuthSource: SN4PR10MB5622.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2025 06:23:56.1123
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bwrlDjr9yq4EBwX8sIordTCWvBFNp9JqgV4NhCMmF8J+U84wh3mj6s9VhcdvQv5LE99FTxGpeIRbubbVaFY8ZrcyVn0yoBde8M841sgTHDc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB7505
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-06-27_02,2025-06-26_05,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 bulkscore=0
 malwarescore=0 phishscore=0 suspectscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506270050
X-Proofpoint-ORIG-GUID: JqueTmya0NCA2h6_Cvx749VcshLbOMOK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjI3MDA1MCBTYWx0ZWRfXwbFx1XhcOJVL jzfVfOUdfxc3AHjKAFWTrFlTkIh14ThJccugZLeO1zke5/1lAcs44aXFqjhp1uqvGaomRZNKIEz 4yA12tkrF/mTikuH16L7574YjwQFeO5YQlsodYPIeUKh2f9h05wNhmGrX6IPJYvK39bhbNWvoSQ
 N7P18tGT3gBUbC9YRYxJDoUUWBzi13hIaqU4Pl+3HmTa6H7yRpENHpLkbJLCJLoynb/VBGTBYaE +DXGGAH6k3FME2FacKOnnZkSSDuPTcojYxhX6bHl2hDpVsDfS0ivQxRUfnzyvBug+yFZu50YAFG T3OttBy9E7RqBskCd4Kg4J8BWr7+YeJp/j+U9VBMtU2pL7YwbS1op6o1xUQHy3/n3Ff1fvHPCeb
 XsmqkkAmfehBt3AT1C3egsYRO9zWkcQ0Sdqb0wL32q3dQIt9fUIyNvdjrYYvuHlCUEv2fTcE
X-Proofpoint-GUID: JqueTmya0NCA2h6_Cvx749VcshLbOMOK
X-Authority-Analysis: v=2.4 cv=PqSTbxM3 c=1 sm=1 tr=0 ts=685e38ff cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=QyXUC8HyAAAA:8 a=Pc1svKVbrSqc2DL2SMUA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10


On 6/27/25 07:41, Xiaoyao Li wrote:
> On 6/26/2025 10:02 PM, Sean Christopherson wrote:
>> +Jim
>>
>> For the scope, "KVM: x86:"
>>
>> On Thu, Jun 26, 2025, Alexandre Chartre wrote:
>>> KVM emulates the ARCH_CAPABILITIES on x86 for both vmx and svm.
>>> However the IA32_ARCH_CAPABILITIES MSR is an Intel-specific MSR
>>> so it makes no sense to emulate it on AMD.
>>>
>>> The AMD documentation specifies that this MSR is not defined on
>>> the AMD architecture. So emulating this MSR on AMD can even cause
>>> issues (like Windows BSOD) as the guest OS might not expect this
>>> MSR to exist on such architecture.
>>>
>>> Signed-off-by: Alexandre Chartre<alexandre.chartre@oracle.com>
>>> ---
>>>
>>> A similar patch was submitted some years ago but it looks like it felt
>>> through the cracks:
>>> https://lore.kernel.org/kvm/20190307093143.77182-1- xiaoyao.li@linux.intel.com/
>> It didn't fall through the cracks, we deliberately elected to emulate the MSR in
>> common code so that KVM's advertised CPUID support would match KVM's emulation.
>>
>>    On Thu, 2019-03-07 at 19:15 +0100, Paolo Bonzini wrote:
>>    > On 07/03/19 18:37, Sean Christopherson wrote:
>>    > > On Thu, Mar 07, 2019 at 05:31:43PM +0800, Xiaoyao Li wrote:
>>    > > > At present, we report F(ARCH_CAPABILITIES) for x86 arch(both vmx and svm)
>>    > > > unconditionally, but we only emulate this MSR in vmx. It will cause #GP
>>    > > > while guest kernel rdmsr(MSR_IA32_ARCH_CAPABILITIES) in an AMD host.
>>    > > >
>>    > > > Since MSR IA32_ARCH_CAPABILITIES is an intel-specific MSR, it makes no
>>    > > > sense to emulate it in svm. Thus this patch chooses to only emulate it
>>    > > > for vmx, and moves the related handling to vmx related files.
>>    > >
>>    > > What about emulating the MSR on an AMD host for testing purpsoes?  It
>>    > > might be a useful way for someone without Intel hardware to test spectre
>>    > > related flows.
>>    > >
>>    > > In other words, an alternative to restricting emulation of the MSR to
>>    > > Intel CPUS would be to move MSR_IA32_ARCH_CAPABILITIES handling into
>>    > > kvm_{get,set}_msr_common().  Guest access to MSR_IA32_ARCH_CAPABILITIES
>>    > > is gated by X86_FEATURE_ARCH_CAPABILITIES in the guest's CPUID, e.g.
>>    > > RDMSR will naturally #GP fault if userspace passes through the host's
>>    > > CPUID on a non-Intel system.
>>    >
>>    > This is also better because it wouldn't change the guest ABI for AMD
>>    > processors.  Dropping CPUID flags is generally not a good idea.
>>    >
>>    > Paolo
>>
>> I don't necessarily disagree about emulating ARCH_CAPABILITIES being pointless,
>> but Paolo's point about not changing ABI for existing setups still stands.  This
>> has been KVM's behavior for 6 years (since commit 0cf9135b773b ("KVM: x86: Emulate
>> MSR_IA32_ARCH_CAPABILITIES on AMD hosts"); 7 years, if we go back to when KVM
>> enumerated support without emulating the MSR (commit 1eaafe91a0df ("kvm: x86:
>> IA32_ARCH_CAPABILITIES is always supported").
>>
>> And it's not like KVM is forcing userspace to enumerate support for
>> ARCH_CAPABILITIES, e.g. QEMU's named AMD configs don't enumerate support.  So
>> while I completely agree KVM's behavior is odd and annoying for userspace to deal
>> with, this is probably something that should be addressed in userspace.
>>
>>> I am resurecting this change because some recent Windows updates (like OS Build
>>> 26100.4351) crashes on AMD KVM guests (BSOD with Stop code: UNSUPPORTED PROCESSOR)
>>> just because the ARCH_CAPABILITIES is available.
> 
> Isn't it the Windows bugs? I think it is incorrect to assume AMD will never implement ARCH_CAPABILITIES.
> 

Yes, although on one hand they are just following the current AMD specification which
says that ARCH_CAPABILITIES is not defined on AMD cpus; but on the other hand they are
breaking a 6+ years behavior. So it might be nice if we could prevent such an issue in
the future.

Note that a Windows update preview has just been released with a fix (OS Build 26100.4484),
but the Windows automatic update will still install the version with the issue at the moment
(automatic update doesn't install preview).

alex.


