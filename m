Return-Path: <kvm+bounces-55323-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DF99B2FDC4
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 17:07:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 39B653B5779
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 14:59:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40AD023A9A8;
	Thu, 21 Aug 2025 14:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BF4hzXdU";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="PTKP31TT"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D68D823E334;
	Thu, 21 Aug 2025 14:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755788383; cv=fail; b=c6pEaT3goeyFRRMoa0UfR+romvM5QWh1D1tkh31grU6h7HkkCpYcJRGGP3Qs6QtxLHdfwRySYWTDXaTEkN4QyMOSq504USEMaiL1zNu4PAbMR1nTXbgNAQMqVm231x7/A6yC/eMdR6xtJ8sg6GAFLafSwMRpL2ACtmOMkiW3rTY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755788383; c=relaxed/simple;
	bh=4I2asrQaSKDEDKhMZIl43l5dBh8dal0n+mrF95I1mz4=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=qDXcUJlRE9Nz33iGJodtp3fJxBMUTqhFHXWdztG71mkPKymWH0KgR21WKl3yoZi8v/BoOBroXPWFZCjxi/DhHOAK9SBWKlTGthRFgFVQzqLyHKZZUZMtXdXsgLpJgYpMECt+7jhxh2sFaWBOH4+mb6OWnLOxBVJCpSvpEnLT6kw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=BF4hzXdU; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=PTKP31TT; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57LEl0pi015118;
	Thu, 21 Aug 2025 14:59:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=Izl1RyHYCf9guu6TwB3ZYBHChR1XOIzeYsoshfDGFqw=; b=
	BF4hzXdUYscPoD8T359TJb+2Qs39SS5creGTcPUnoFDXC4UW4nz4LhLbyqWGjQZR
	tBckwbcvoKvehLsm7bvfwcb7CPRtbc2GikojHq4gujvG+UxXwDrMhGgCji5fqpIJ
	HeCSOxVUqiipzNne1RZfDgGCh8llI1f9l6XbB+XI/vAU5To9PKKfJ+JSxBy3Xl/3
	S47HRSZBvM2WkVkA5Y3vsMU2DMQT7hZlOEKIkBDLrbCIJf3QPJuEhlT1ilGhCngr
	sYQBmA/uC+WwmZOH7hxjCSesC6E+3Obx98LWbu+80bNaZnvalBxQil9yrOp6P+Kd
	DWWdXRoEuvwUvlMO+OSbbg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48n0truq8t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Aug 2025 14:59:30 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57LE0G8o020776;
	Thu, 21 Aug 2025 14:59:29 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2067.outbound.protection.outlook.com [40.107.237.67])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48nj6g5y9m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Aug 2025 14:59:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PURkj4TUnd2ORR3r081XxpG2pxzDKXzU5yySvGWMNlVuu+nP1tlj02XenA5mIsfN+LWKvcTBcndT3TZTI7tFF6NA1T9FT6DON3WCToVS+Ag70ZDoY/7e7DLSlT2ZmSqhUPi5g0+bAF5yxuBQpJFeiBmQNv5pj2dMf5yi4S/Ba/nW/xQCxlLkkX1u5M1sUQhLQGwjN59iPHdpMq4XyDBhtoPKj6467+/hy8TjrjIn+hOfP/ebJu6VAK0VsBBOAheNM2uQRiWk7Q0LJuKZ/DuEyheUIHsfQGtG+uZ7scv4hi7zs82VRsVqMP6h3IOhAkMJDzGyvTQ5WiBD1kLrzXFtgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Izl1RyHYCf9guu6TwB3ZYBHChR1XOIzeYsoshfDGFqw=;
 b=xUnRj5ogaSiifHMfSfXgA89GtVGj96JYXCUp8P14yIMPk/lqWqPx8nUE3sqPyu8oOAil3kMya6RUvtVhpg8O7qjfIQBOrKc4dvs+IQvSQE8qNfc29WKYpkHIByqjOFADtk3/jB9ZJRYYauxQwl+qp8iW5HsEhmx94oObuDVzbvUQpX/j7PfphA6vpFXY1dCCzNmYyoGj0zrYRH6kz7+G2ul14iTqPDEVRjtvh/MtJ+sUGYVSBRAwj0Y3Iu9zGL6XE47kPKVmOM7Ri2LeMI9oT33WUH2ipXKzS0EvKZ3prp/ppzpEmupSV+hscPgCmER84Ue5DDoS9mQnJI4yh+erXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Izl1RyHYCf9guu6TwB3ZYBHChR1XOIzeYsoshfDGFqw=;
 b=PTKP31TT4XyFOCrT3s6GmSHmegMjIiZ4fVQ/ozhGHAfA2DZSFwr/+BmhVeE7YQ1f2bD+VETFXn4bjSVTN+VwIpDBrrptLVZ9AFBHP7Cbe0Sp9h/XbrnfDztn0NnKg6hZMmKNKec5xvCMDGAesBOSD8U0o5JDz7TMFr6f7DrlSWY=
Received: from BLAPR10MB5041.namprd10.prod.outlook.com (2603:10b6:208:30e::6)
 by BY5PR10MB4291.namprd10.prod.outlook.com (2603:10b6:a03:207::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.14; Thu, 21 Aug
 2025 14:59:26 +0000
Received: from BLAPR10MB5041.namprd10.prod.outlook.com
 ([fe80::2c19:641c:14b9:b1b4]) by BLAPR10MB5041.namprd10.prod.outlook.com
 ([fe80::2c19:641c:14b9:b1b4%6]) with mapi id 15.20.9031.023; Thu, 21 Aug 2025
 14:59:26 +0000
Message-ID: <1f63036c-a72a-47bf-a75f-23ca7fd3b7cf@oracle.com>
Date: Thu, 21 Aug 2025 10:59:23 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] KVM: SVM: Fix missing LAPIC TPR sync into VMCB::V_TPR
 with AVIC on
To: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>,
        Naveen N Rao <naveen@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky
 <mlevitsk@redhat.com>,
        Suravee Suthikulpanit
 <Suravee.Suthikulpanit@amd.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1755609446.git.maciej.szmigiero@oracle.com>
 <zeavh4vqorbuq23664til6hww6yafm4lniu4dm32ii33hyszvq@5byejwk3bom3>
 <275b4fa3-9675-4953-8766-c6cd4e5f0d57@maciej.szmigiero.name>
Content-Language: en-US
From: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
In-Reply-To: <275b4fa3-9675-4953-8766-c6cd4e5f0d57@maciej.szmigiero.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH7PR02CA0022.namprd02.prod.outlook.com
 (2603:10b6:510:33d::20) To BLAPR10MB5041.namprd10.prod.outlook.com
 (2603:10b6:208:30e::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5041:EE_|BY5PR10MB4291:EE_
X-MS-Office365-Filtering-Correlation-Id: e8b82781-9ed0-481d-e0c7-08dde0c35286
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?L3N2OWZOZG1Fdk1hRW5qclhGZnoyOVFuM2NKa3RhbWNlZDdEVWlTUUd1R1Vt?=
 =?utf-8?B?MkcreVVoQmF6WmM4ajVxSDcwWE56L0tmSCsrOGRMY3ZxTjIrRnd2OGZoNjVt?=
 =?utf-8?B?ZkVLM2tBbXFFUGRTSWp5eGNRdzlmMGc5UjhpaUZpZDRMeTdwSHZpWTE5RHEv?=
 =?utf-8?B?TnVMeXplUi9FVVFNZzVoUldHeDB3OWcxRTFPMlFYdWlpOVlqczJpdW5TMUZE?=
 =?utf-8?B?TXErR2dKZ0toNFlBSEFqZkk5ekxHTXRvZXh2THYvNWlrMkhibCtudk5iSVNn?=
 =?utf-8?B?VTlnMVZIUEpreWFMRnBUanhpWGFGclVKTy90WnA4ejU2RWFtVm1HOTk3dzFt?=
 =?utf-8?B?c1l2R0lWTHJuZVMxdXNxbWNFYnhJMEF3WTlmd2t0OFh4bm9NSHdvRGdnbUdq?=
 =?utf-8?B?NUc3Z2ZCdWVrUVJSU1R1bFgxVVZqaWVQZGV0NGlHVFRxMXVpZVV5S1hNVi8r?=
 =?utf-8?B?NWZaNThyT3JkV3BsUTBvUUcvSURkVUdDei9ka09kK0ZUa3k1WG1kaENIQjA0?=
 =?utf-8?B?ODIrQUtoQmJ5d2c4ZHNMaHZVZTZGSHRieU9rQlhiL0s1ZjN5cXZaWEZXN21t?=
 =?utf-8?B?alBTTE1qbzdhVFJTVVk4Y2Jhckt2VmJpeDhIOHBBM2trZFpaSXFJTlRzSTM3?=
 =?utf-8?B?NHB1dXFta0VxRngzM0Q0QmsveVZhMzN5NFM4b2JyaGdrRHBDYitUcm03cG85?=
 =?utf-8?B?VWJhZC9JQ215NUozdUdxL1VOcXg0YjRkRnU4dHpURFFXOGpSV0hMVWxkVXJs?=
 =?utf-8?B?bGc2TkNHSThSU3pCQzBFWkMwNW1XMnlXQW41cGRYZ3ZrYzdMU2xKZlhRZFE5?=
 =?utf-8?B?dDRGYWdieWRSYmFKRHA5TENJbmJKU2pwOTN4RXVBVjRVUUdSeGNXdWNXdFRu?=
 =?utf-8?B?cE1mQTVId0F0ajNEaGEwMlZvUFR4QWdDTHZBZW1EY0pzaXF0elN4S1NTTmo0?=
 =?utf-8?B?a0tFNXpWVVRZRTBsZGl5TU0wT01ldTcvTjZPWnJpNXByZ3NPR3RsUkNKOCtr?=
 =?utf-8?B?dVZoNTVKT05sZGZXTDNOak5XdldRWFQxczZrZ0lYbkljdEZYeS92RmlDMldU?=
 =?utf-8?B?L0tpZnlkTUlmS3dIUy9wWDh5TU1qSWllWHliVHovbTdlcGdSaFJkWFVsU1ZI?=
 =?utf-8?B?OG03VnJMd01lU0N6c3NqOEZGRCtrMk9vQXJ6M2o4Tm5qUWM1bXpNUHRHbE1h?=
 =?utf-8?B?amJLbndNOGI0UTlCUUtRbHdDTlNVUk9BTkZXd1VrUXQwMUxGMXRzUGpJc3FK?=
 =?utf-8?B?WDU0YkY0RTdJSjQza0lFWkZJdzAxM1VRY3ZGZEZQSXdzVjlUb29vSGk5a2h5?=
 =?utf-8?B?Wm56L1dnWU9xQWN0QmFnNUMyNXNWVFVEUXFUYmxrekpua3BRS0NSWnhqSHBk?=
 =?utf-8?B?WmVTbzIxMzd5TTZBcU8rN3dkZGRsNjQzaGlpUTkwbnlocHgySHpnYy83M1BD?=
 =?utf-8?B?dE9HQTB3eXpScU1EdXVmM3FiVitjcGtOK1FETFdxQTN1VDBiVmlhaVVCUDU2?=
 =?utf-8?B?K1ZKN0hGT1RMRUdzeXE3SVFhdWEwRTVweTc3cndVUlY0TG15ZWwxN0M3ZEJE?=
 =?utf-8?B?dXlMbnJxV3pMWkhHTmJ3a1E1cDVnbUg5RzZDQ1dLcU9tUy95cHdzNjJNQlYw?=
 =?utf-8?B?M1g4YmlqWVdrMTF2OEQ4RlFaNG5Cajhrdko4VTlLM1d2U0dudDZoREw2amlD?=
 =?utf-8?B?UG5rUi9VWjEyYWxVa2NLdlhzajM5c1Y5Y0p6YTNSOXJPNms1NEt3QzJrMHR1?=
 =?utf-8?B?eU9YbUVGZ0lpTlBIK1RhWUFCWUUxTG14Q1U1eVR4Q2FFUmJYTk9lOUUvS3Ew?=
 =?utf-8?Q?WxWipiXkkC59jV5m0T9OHD5KE/srFzgkV9Qbw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5041.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?alVzMTh0eHR0MjVUbnNGU3c3SFRVQThGbnFRT2ZmYnc5RzJGeGhIbnowaDVY?=
 =?utf-8?B?ZXZVVkZQUlpOZUFLQUJBN1V1SlRVNTFCN1hWbEFheVgrZXdiODFER09hT3FG?=
 =?utf-8?B?SUpmc04vV0lMUlpOT2NlYXFnNFRjMnE0TURKRUd5cjR3V1ltVDVsNXFDSFlz?=
 =?utf-8?B?bWNuK2dobHBDL2UrdWZwMFl1SXdWWGl2N1FWcEZwbGFZZUliYlNzNmo0SWNp?=
 =?utf-8?B?RnhXZzVsUEFkV2Fhc2tLRHIwS0o2eWUrWGF4dHF5WFZtUFc5Z00vVTdjeW5F?=
 =?utf-8?B?VXNGYkJVVFNoUTl0bmtnUmpqOVZ2MStHb0Jta1lwMHE0TzJZZmJnQjQ3dkpy?=
 =?utf-8?B?NmVmU0prZFBLeHBTWmhkMlBtSWRnRHZRSWYvM3U0aWtka01laEhHcFZlUmlK?=
 =?utf-8?B?eG1IVlM4dWpGM0dhaWNxYy9NYVc4azl2TFNZS1c3YnZGU2pXbkNLR0RjVEtT?=
 =?utf-8?B?WGYxT1FhMXk4cmFuaitrRWVtS1BnRzJDR2NJVitPUkVlb2RiM1ZDVk80Tm1Z?=
 =?utf-8?B?blh5TWxvRGRWRkJFeWlLRHBsZ1dtdXd2K1FrTkN5bzJEZHJWUTI2ZVpFeGQ0?=
 =?utf-8?B?VGU4RlFzVnRadkYxaC83QUNTRE4yblIwR1M5UXVPNnhnSDc2bndRTFFBc3BK?=
 =?utf-8?B?WGxNbnJPa3lLQlhiWnV1MnVUM1h0WVRHNXZidHU3Zk84VlMyWmhxWWFsbGRm?=
 =?utf-8?B?RmZXT3VBYjkrWnNVRFZRMW81MUJiVDJneDdHcW9SR29oTlhRcC9wZXJ5ajB1?=
 =?utf-8?B?RlNzOTg0WHRHaVpXV2IzUnU5T2NQcXQycVV6VVZRR25VTUw1ODl0WVBwc0JH?=
 =?utf-8?B?UzlYdnNQV3dtL0UvcXd0eWxYdjNTVDg3UlhDK3NxaGJ5S284SzNuSUVWbkIr?=
 =?utf-8?B?Y21Yc3EzakJUN3A2Mis3VFlsWTFndFBrY2NGWER3aGxTcXhYb0xvK2J4Qmpo?=
 =?utf-8?B?UmI5Rk53WDdhWVQweUplWlV0V3lwY0lqaU9pT01PZ3FWbW0vaCs3VVlvblFB?=
 =?utf-8?B?bDlkd1dQRW9CYmhlVEc1dzBiS3BMZFlqOUhJdG1hMm9IU05SOENXQkF1Y2pT?=
 =?utf-8?B?VEJLNXl6MmZEL3B6ZWZpOHd4OGtvVHkweTlNeWl2Rk5aU1JxalBnZVhzUDFY?=
 =?utf-8?B?SS9ISFZkTXU3UUQ0THdoYVFjOEY4cnNMUkJxSWhWYkc5MHMxUC9aeGVmZGlL?=
 =?utf-8?B?RW1zRkpvK29oQnlNbDUrT1dZU3E4WWYvU1V4eEdXTXRkb1JhOG4wSmhSQ3FQ?=
 =?utf-8?B?MXpMRjZtT0tQb2REQi9BVHFCR2lvOGxHajVKSUVEb09NQzR5T0V5a2luK21j?=
 =?utf-8?B?dVJTN1d4Y1dCV0ZweGRHQWdKdy9vUVRWNTRhcWdrUkdqREFsc0phRHRYNFlN?=
 =?utf-8?B?eEF2UEtncCt0a0hydWZKeUFTV09oV1ZDWisxUmd0ODhGZjlKdUlVVWVTbk8w?=
 =?utf-8?B?ZkxaRTRianV2THB6Wi9nRUdhZmZ5b0FtRFZpZ0pRbGtMV1NOY1kwdlN6blJ2?=
 =?utf-8?B?YXJDTmdaWW1KNk5ZSFdGNll3OGtGajFxU0RaWU1jNlFOWXU5NVhvZE51dzkx?=
 =?utf-8?B?QjFWbUFack5DcEtOYnVNdzRrTHQ0RnJEbkRUNCtNWVh6QVBKUFozK2JnOGgr?=
 =?utf-8?B?TDYyamNWNStDNFlJS2tyYXk1K2FlMXZTb2U2OWZ4YW9zK1M0aDY2eFZYdXkv?=
 =?utf-8?B?aTZoV09kRXozcWR4WkU4bEhGQnp6TG1TYkR4N0JsbTRzT1hOY3VVaFpPMk1W?=
 =?utf-8?B?Z1RIcjh6dDRsdDRMVkRRMjh3anA4bklhNlpDa1pxZFFJRVAxTSsxRUNGbHFz?=
 =?utf-8?B?d1YyTUhrYklieUltcXN1cDJ0d1VGQTlSbWY2cFBJbG5qbUJDcUp5T1lGMXdR?=
 =?utf-8?B?MUtNS2xCSUZsMUlvUXdESzNzN0NuM0NEZVVmVzFIVHNLQjh6dFFLeTB0Ymlu?=
 =?utf-8?B?Rkx4TUk4N0d5TDY1MlVtQlEwYWVzcE1XbEVxSnV4TjRBVU9wbGlLSUR3UEVV?=
 =?utf-8?B?ZFJjMkZlaXhNWCtqUXVqZWQ2T0F5S0ZMVHFZeVpGOXB5cXBlUmVpMnlRcDN6?=
 =?utf-8?B?RlZDbzhEbFU2U3B6Tnd3c1YvWElXVTFBekFtRGlBVU5TdDlEeS90aEs3WGV5?=
 =?utf-8?B?NTUvcnJEMkthUWc3clBsWHNuVVdUS3hsbmRDdW1IeDNyK0wxbWdoWHRlV25M?=
 =?utf-8?B?Vmc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	S5xLwPGU08aW5Lhbf0IiprJ9jg+29bGiF1OhchD6EPMU81EVn/1FVEW7rbHK281Oa0jmT56M78fK+kLmGBGEg7BFKwu8gd0NU5I1l+bsaIzQBLbd17MjLM8QNnkvz3jzDDw8YysazQn8DIDrB+bMj8hKwHtpvPhzbmQ1/tRcRGoLBVqgGLZwjA8EQsgCEM85LcNrCKjj3sP77ekzPFk/9Qp6UTwYc2e1N5djVkd90GC0+yya9jYOtWv0KhcHlZFavdbIocyfNQGVJg99U6n6AYHvOmETdW2JhCTjyEyE7TggnLJTB991mh0KlD1Mx8vZIS2wbDlZkcE2sF1ndaX8o8JdZEQtyQrkSnma8c7IpgoB8XOG4LnMml6RkVahLNHSqtWPRAIwnopLG7c78Q61VBZ3EqhHt0R8lE1FlU4Nk4eu3gV8qVSKSs6FfGpYrCNAvZokWLB14Ln4jX3PfYvXbDLAA29YwwsUrNnMixd9B7336sjoodT5Qvc7ThAMhS4bxRzliv6GaEsJ2S0ChgaFyNVFmi4MCpxUJwyrxS5rRRM7mfFbyMWqbI1PcMfqfjFWLtatzgsR6a+L4xjPyh6zyuWeSILSC5jiEjA+j9wXosQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8b82781-9ed0-481d-e0c7-08dde0c35286
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5041.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2025 14:59:26.6537
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AtYDW8rYjdJqta0YpVClplFIHkQIazlnTdR9P50VFeczp96yZAJOizJN4LPKXW6GZmwhSrJhAqS1lC/YCTi++ImzuqDPqaUizNjtvwAOcO0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4291
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-21_03,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 suspectscore=0 bulkscore=0 spamscore=0 adultscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508210121
X-Proofpoint-ORIG-GUID: nRviozn-rbgnL4Mn8ZdYHWBhnxwRgLeT
X-Proofpoint-GUID: nRviozn-rbgnL4Mn8ZdYHWBhnxwRgLeT
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDE5NyBTYWx0ZWRfX1iQnkZDOfzS4
 DjRZiQBb0qcJ3/0QnoODOxLBVoljxaXW9hdaEVxOIXVTRbSgj6u1RRL+PFv7i7N+1PMjl6XjsZw
 DtgnH7W8g0gKxnNpd7v6q2idLsCPO2XGNf1NMOe5OWqiakP4lUbliKWUmF30fA6U3NHc1Fy05N8
 khKnFZlr8bXtTnMNsVsV0vNtbJFZ8XBKKljq9rB2voz2pG5b0UdVIXPtlx/REQv95dJtVDhWaJ8
 qQOJ9TWVXYno5xWW2ZDLfgrXTjUnBwPiB5rsZ9fmnr8VKhyZnugSFgmwIRFllo9LbuzrYnuy3lk
 qsntb9iHzT83SH5OnPV40c8GJ+3kJmgDKAO8E+aphG21G1db4d/qu6ECdhbYpamSob1fXndcEn1
 Dl/xnJgE9Gl7wihWnqeP0ehD4zhy+MFhwxnIlxy4FtZMu5sWQrA=
X-Authority-Analysis: v=2.4 cv=Qp4HHVyd c=1 sm=1 tr=0 ts=68a73452 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=P-IC7800AAAA:8 a=yPCof4ZbAAAA:8
 a=Mg-KZfQCCSJjPeRREgIA:9 a=QEXdDO2ut3YA:10 a=d3PnA9EDa4IxuAV0gXij:22 cc=ntf
 awl=host:12069



On 8/21/25 7:42 AM, Maciej S. Szmigiero wrote:
> On 21.08.2025 10:18, Naveen N Rao wrote:
>> On Tue, Aug 19, 2025 at 03:32:13PM +0200, Maciej S. Szmigiero wrote:
>>> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
>>>
>>> When AVIC is enabled the normal pre-VMRUN LAPIC TPR to VMCB::V_TPR 
>>> sync in
>>> sync_lapic_to_cr8() is inhibited so any changed TPR in the LAPIC 
>>> state would
>>> *not* get copied into the V_TPR field of VMCB.
>>>
>>> AVIC does sync between these two fields, however it does so only on
>>> explicit guest writes to one of these fields, not on a bare VMRUN.
>>>
>>> This is especially true when it is the userspace setting LAPIC state via
>>> KVM_SET_LAPIC ioctl() since userspace does not have access to the guest
>>> VMCB.
>>
>> Dumb question: why is the VMM updating TPR? Is this related to live
>> migration or such?
> 
> In this case, VMM is resetting LAPIC state on machine reset.
> 
>> I think I do see the problem described here, but when AVIC is
>> temporarily inhibited. So, trying to understand if there are other flows
>> involving the VMM where TPR could be updated outside of the guest.
>>
>>>
>>> Practice shows that it is the V_TPR that is actually used by the AVIC to
>>> decide whether to issue pending interrupts to the CPU (not TPR in 
>>> TASKPRI),
>>> so any leftover value in V_TPR will cause serious interrupt delivery 
>>> issues
>>> in the guest when AVIC is enabled.
>>>
>>> Fix this issue by explicitly copying LAPIC TPR to VMCB::V_TPR in
>>> avic_apicv_post_state_restore(), which gets called from KVM_SET_LAPIC 
>>> and
>>> similar code paths when AVIC is enabled.
>>>
>>> Add also a relevant set of tests to xapic_state_test so hopefully
>>> we'll be protected against getting such regressions in the future.
>>
>> Do the new tests reproduce this issue?
> 
> Yes, and also check quite a bit more of TPR-related functionality.
> 
>>>
>>>
>>> Yes, this breaks real guests when AVIC is enabled.
>>> Specifically, the one OS that sometimes needs different handling and its
>>> name begins with letter 'W'.
>>
>> Indeed, Linux does not use TPR AFAIK.
>>
>>

I believe it does, during the local APIC initialization. When Maciej 
determined the root cause of this issue, I was wondering why we have not 
seen it earlier in Linux. I found that Linux takes a defensive approach 
and drains all pending interrupts during lapic initialization. 
Essentially, for each CPU, Linux will:
- temporarily disable the Local APIC (via Spurious Int Vector Reg)
- set the TPR to accept all "regular" interrupts i.e. tpr=0x10
- drain all pending interrupts in ISR and/or IRR
- attempt the above draining step a max of 512 times
- then re-enable APIC and continue initialization

The relevant code is in setup_local_APIC()
https://elixir.bootlin.com/linux/v6.16/source/arch/x86/kernel/apic/apic.c#L1533-L1545

So without Maciej's proposed change, other OSs that are not as resilient 
could also be affected by this issue.

Alejandro

>> - Naveen
>>
> 
> Thanks,
> Maciej
> 
> 


