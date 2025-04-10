Return-Path: <kvm+bounces-43098-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E485A84AC8
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 19:16:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E4CAF4A0624
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 17:14:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 125F21F03FE;
	Thu, 10 Apr 2025 17:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Syi0roQ3";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="0VXortzt"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B8631D5CE8;
	Thu, 10 Apr 2025 17:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744305232; cv=fail; b=AWOKTlPh4WtHLu/KN+4s7xlkO/Iltv1Icc3qcGc5N0orOU1NAQka5E1pj1PXexZZr8NfbzzWfU3xl8F9oYtCLSHlUaeGOnUIFwVaGt4EShLLzKRUx2iXARMx8Hzqk9pd9l82u7aXJ6/SeBM4u5i5IyG88vdbGQ0zU4rqy76wnKc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744305232; c=relaxed/simple;
	bh=kCCjWcsDDz5HbFF4zlzyAyIMhqbkhYy6q3c/mWKQ+JY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=WWxg8yVyRgKT8/X62Dmtxrr7nBokz803BbKh2bHzx39LW/vtTSugJtUNOAr5qYujjHiF+yB81jYE6czIYrVPvEtcads3ZFRrPjwYkumOcFEhVAKEM6DhfS5HYgktGzwxI90OofhCb5ChIKyNi008AJx9nme2pPRgoXG1i3i91Vo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Syi0roQ3; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=0VXortzt; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53AH1nfL031737;
	Thu, 10 Apr 2025 17:13:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=xgKZcVzJWrTRVTKgsuLHhqLJ+tK2mRCT95dBQ2JHce0=; b=
	Syi0roQ37BXWdm5j2/qFZ2veIeim+rwZxel0HMYGfzCGveIihLwlh+/uPECTmXEM
	KuIsBsM7srVjnT6cB6qSFYHhOrC6zXEwbby1XEu0dGcvid4UsL5smonKlUi02LAr
	4aHS34ataXkJuWooNdVOYHrW3wZXzFc50CuMfGKh/yD6Kii//jfT8tQ6OP1jnxOq
	XzReT61FaSdLbkgC2GjQ6HIi9OkRjxfV0EPDO5/CRY6k/euQVnwxzNpuCHL5lUiG
	XiPk0SF/iJiqS7UqvEalkos59+sTHiYcxI0DEF+I6Py2PG8iuGs/c4A3SryiP/Dc
	1v1Q7g4Z0XTVErjtLidqPQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45xj1c0129-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 10 Apr 2025 17:13:13 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53AGo2xt022130;
	Thu, 10 Apr 2025 17:13:12 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazlp17013062.outbound.protection.outlook.com [40.93.20.62])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45ttyd92aq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 10 Apr 2025 17:13:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PGdwOtc7LWPw8T64W1tTJM0yn2fwepNIyGJhqLW2Nu1o4Qw/EvN6fCu3L9V2M5q+RCS6GrMuhHO0A4/b5UOVBo/IofP/U8dbbm0WFkHr6yIFl8Np9b/Olturfvv85fC2dSf3dS4RQp2fzdMsAEX+js4e/k8CmMzHvEBJ0N5cK2lSpjFD4pENMONBjoOEfHVxBhTYMy09pF8H8ZGsIaX1Y2JOaWynhKtb1Fh8Nb6r/TErxadVzV6NINyGDAJ8y6oiOIjKIttyzhjaPhpcpggTUS7Qb6uF0SWuFK1PLaHAZhc9LcoD0CTQoMwA9LioceYWzUHsSs/uSabBMv8qPaw2Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xgKZcVzJWrTRVTKgsuLHhqLJ+tK2mRCT95dBQ2JHce0=;
 b=gSa7GtWReqZfqAJbivMUqYcYLbWdfXLs7g5mZ9TuEt4YGnu/XAX9GAn17/cETWBb9yJh0a1ouf9CeT1wVJgR6sqKuWcOi5gzJp/fQdhTfS2HQETQJ8dSO2mVyBKqmSokCcKbHDgUW7K0uuwFaiLRceVNuMnO6eb9lOLXu5MAE4LpkmPWLe9e7eoFZxiW/MMzem504PMUV86stlPXDkY28VjZezyx0X8LRhI1RsqxSNlaaQzeIkyj/YiCf1ZVrvPVlq58ZYqrifUl4N1KhpWHp7c6JvTwRRHjMiYBwIQ1P3H/1iLjOTL9vOu0LPd5zj+ayoAMi76ywitIcLNFGruw2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xgKZcVzJWrTRVTKgsuLHhqLJ+tK2mRCT95dBQ2JHce0=;
 b=0VXortztIyoM90zygt1Cb6LtdLnzdoNhkH3/ktN9UsJ4tlCOryL03o6X21KbEyTX7GuUJSrHPeQ3V0PVODjuvyXLQzR2qJ3k10CtKgMkEekyFL7yrwjvFrPXybMzeBF3xa+OE4VO7C6Ir7MbnZPVWnbNxYKRgCbjPJlNM+FVfxU=
Received: from PH0PR10MB5893.namprd10.prod.outlook.com (2603:10b6:510:149::11)
 by PH7PR10MB6356.namprd10.prod.outlook.com (2603:10b6:510:1b7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.32; Thu, 10 Apr
 2025 17:13:09 +0000
Received: from PH0PR10MB5893.namprd10.prod.outlook.com
 ([fe80::79f1:d24f:94ea:2b53]) by PH0PR10MB5893.namprd10.prod.outlook.com
 ([fe80::79f1:d24f:94ea:2b53%5]) with mapi id 15.20.8606.033; Thu, 10 Apr 2025
 17:13:09 +0000
Message-ID: <bba773d0-1ef9-4c9f-8728-9cf0888033ad@oracle.com>
Date: Thu, 10 Apr 2025 18:13:02 +0100
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
 <9b7ceea3-8c47-4383-ad9c-1a9bbdc9044a@oracle.com>
 <Z_fnrP4e77mKjdX9@google.com>
Content-Language: en-US
From: Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <Z_fnrP4e77mKjdX9@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0067.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2af::17) To PH0PR10MB5893.namprd10.prod.outlook.com
 (2603:10b6:510:149::11)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5893:EE_|PH7PR10MB6356:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a9ad2b8-2af6-4f0d-6b76-08dd7852f733
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dFVCS3U2WXA1Z3A0dGRUbExHR0NMOGkxWXVDTm1wYS9CRGFsb0g5eWk3RVZm?=
 =?utf-8?B?Nng0ZkdQS0h1alY2YXJnRUlOZUJIMmZ5TkRaNDRsdU1IL3VTenpLUTVaMUYx?=
 =?utf-8?B?eDNhNnY5YlB2YnFEVERvUjlRdzZjcHFXRlE2cXBmTk9sZGpoVXdUM002NjZz?=
 =?utf-8?B?cGgwRDNHcmkzdnRzLyt4VDdkWFZDRlI4QXVOdk1OSjZ0RnJuemJPVnBCVGJv?=
 =?utf-8?B?ZXo5eENoVkJ5NVR2Ry95SW56WDE5THZNR1M4UXJHRGpMTFA4OTJ1cktGOGhY?=
 =?utf-8?B?MXpmVHhjeWh3bGtMdk5ra3MzQ21oSVpxSmRETnBiVjBEVllDQWtTbFUrUU5J?=
 =?utf-8?B?b1NZbFhHRnFrK05acjRidTIzOHRoeXFJVTZsL1lGNlNCNlBPelEyRSsxRjgx?=
 =?utf-8?B?N005OXk0b251UVhOOWFCTWdjUVRuL3NUK2lQWjI4TnVTYzhIUzRvUFpjSVBr?=
 =?utf-8?B?M3MyMjFZS0E1M3ZaZ2t1M21HSnk1SzZ5MzJ1aWxvYnFlZEd3VjRaUyt3ZHRR?=
 =?utf-8?B?eDdIWEFaYWJzVVE4SWM2Yi9vQVNNWUc5UXNzWlg3dHdsZXJUYWZtNTFlbDBp?=
 =?utf-8?B?MXc5L1lSVXp5b1lYZVd4MEFRamZsa25WcWNGQmpQWXdyaWN3RVU2SUl5M2tU?=
 =?utf-8?B?TC9GeEltSVlWVEZWcDdZOFFSeVg5T3ozTGJsZThhTHgyUiswNSs5NjNHWVh5?=
 =?utf-8?B?a3BNbDFGY0FNNUlLQk51QUxuNGlpSm5vVUpOeWl6MWRsNkwxWURyUkNSdUp1?=
 =?utf-8?B?cCtWZlR2ZC85OWNvMXNYNWxGRnhIV1lUeUlpV1pRdVF5anFad2ZSWjEyUHpP?=
 =?utf-8?B?OTFUVHdtRWhud0RzOWoxLzljenFucGNKdks4VWlqZjU4NUZ1M2sxcCtTV2pp?=
 =?utf-8?B?RHZ3UkJka3hxZXhBa0R1Wlg1L2QwV3pPa0ZnQjZVbElLY1QwbDNYMHhVeG5V?=
 =?utf-8?B?OTZ5QjIzZXh0bXZ4L3RHbldoOThKOFFHUmxYV3hTYjU4MmNNbU9GQ016d1JQ?=
 =?utf-8?B?YjRKUE5JcGtMd0tEdk9rNTRVQ1J4MUNFcGc1Wk1ZTUV4V1JvbVdMU3A0Z3pD?=
 =?utf-8?B?eGlyN3R6QzNhbGRwTWxUejhvZ1d4NldnNlMxRmE2aFhYaUgza25iSmJld3Q1?=
 =?utf-8?B?UkxTSlhPendQQkk1dTVSUlRwNmVpei9Gb095c3NpN2szSDlMRjJxZDhpSXdu?=
 =?utf-8?B?VmkrVlV0WFQyM21qRVZWc1ZEZjNLUFlFOW1HUEJZUkI4bXFTeElrMXc1YWhy?=
 =?utf-8?B?cVlWdjlpZGJVSkRobGE1eHZmeVMxQ214QlZ1aVQzaEVhbTVEdXdqU3NpL0tL?=
 =?utf-8?B?Qk5xcnVGZzRoQzlyemUvZ0ZDQUJiUG1kc2FFRGpnaDRDemRTK3Zwdm9nM3lq?=
 =?utf-8?B?Z0ZOT0xYN1FROFNpb3U2QndNR0l2MlZ4d2FYeERJdXYveFdWWFdYN1EwLzQw?=
 =?utf-8?B?ODRCWWFaeW9GNE1RdGc4MFFwcG1lTXB4N0pMckRCWTUvWC8vYWFQMnJOOThp?=
 =?utf-8?B?S2tocTN2UHV3SzdyTnh5eDF4NWxhSDNOTnNJREZuTExuei8wYnlDbWF5TEZE?=
 =?utf-8?B?VmVCZVpXeXQ0SXFkcHZyNEVBdkRTWDVJaHpiZmNSME1aQk1oWWJMVEFZV0Q3?=
 =?utf-8?B?Y3lFQU9HNXN2TUFTc3VMNjRXeWtFdGlPb0NNTnBtZlFSUSs2dWhiZk5iQXVo?=
 =?utf-8?B?UmZ3U1NvaHBsZnNFWDdIK2JaTGg3cXVtdmgzdW9CSU1rS1NPWTdZOXJTM1Uv?=
 =?utf-8?B?U3NTYjJxZFl5K1ZscG84UjdaSThyZ1R5U1RMNGgzd1pXV0tURzNrbndPWnJN?=
 =?utf-8?B?S1VjaWFPOGlMS3QzVlo5K3RLQ05HSXNYWjVWckJkMi9DcHluN0RUNzh2U1JW?=
 =?utf-8?B?ejl3THNjekNzRXdpTDVEQS8vU1N0Y3IxaUhBUmhmdyswdVliNndieTd0eTJu?=
 =?utf-8?Q?Wq/U/idBwPw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5893.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dkZuNHN0QTdiYkhhU21QZSsxUmVXdDJYSXJ1Vk9XVXkzc1MvaThlTEM3Zk5D?=
 =?utf-8?B?d29mKys4OFRlQmNwOFl6NzB3TlBCKzl0YUUrTmxSZUpORmc2YnpKZytGNmxr?=
 =?utf-8?B?eTZUU2NoOHJrckxzU2ZhYmZrYytDQnBycVlCMElWZDRKVnBlUkpNWkYyb2xD?=
 =?utf-8?B?UjYxajlnNG56QUVTcmFWblhUK3FOMU1HNzNsN1hKc1F1ZStJOEFBRENHQk1s?=
 =?utf-8?B?OVpRQTYySmF1QkZtdmFMUDJvZTBCNzVTRWpaSXNXQ1prZUttUWZPc1ZYd0d3?=
 =?utf-8?B?MlQ4RVZ1WHRnekVsK01SV3lWUE9Pb1h6Q3BCd1cxdzRUcGRadXBpdnErMy9y?=
 =?utf-8?B?dGFpaHRoNTUrNW93ZXBNcEFpbjdoOEtLUDcySVVieU50aUxNZ2w5RFJhcTZk?=
 =?utf-8?B?bkZGMzRPZnlUTHRYQmtzaDNOdXFLWkw3UWFiRXNrS05aUTR3TTJUM0lFYzYy?=
 =?utf-8?B?UjQ4RmMzTllaYzAvM1ZhOVRhbEt6SlNTSlZ2V28ya1VtelNpMkxibGsyWFN2?=
 =?utf-8?B?MDhrdThqcjM0NU1pWGE3b2xvcE1kajE2QWh6RGR6aFVOUnhBVUVxUUdDWTR2?=
 =?utf-8?B?c3ZDZ3dvemx6Z2xvRWtCU1dZNWIyS1FIN2xrdFpaSnl1bUp0MndWQkxVdUJK?=
 =?utf-8?B?dVFXc3p0MUMzN2dwN1RhS2xrbCtWRnZWVzVrSm1icUJIQW43M3FYc09xeXJk?=
 =?utf-8?B?UVVRUDFRNldVYy9HQlgrNTFkczRwajNEZVBqL3RVQ29TK01PeTdpUlpqbGFm?=
 =?utf-8?B?WUVUU2dLcjVhUVZLNG1CbnpxY3dkNFp1aFJ4SXdMRG9kUGs2QVEwRnRSZjlF?=
 =?utf-8?B?Z2ZqU2JiYWw1QndpQitEQ0hXbHJwWVdWaDdvR1hmdHpLWGJLNGx3TDdkUXNx?=
 =?utf-8?B?VG8xTk04eDR5N0x3ZUh4WGVISUVvUE9sMEhSU2pHaURtbEpTZ0kwV3FWTHk5?=
 =?utf-8?B?ZjgyYWs5UzFjVFhsdVdMQ3BtUXdtT2pLUmI1SVkvcFh6WnduTHI3bldlVmZX?=
 =?utf-8?B?N05FMkxYRWE3VjhsRHBiS3pVandrQzF1Skxnbjl2Sjh5UU1MYnNjNDhsYUF1?=
 =?utf-8?B?bWRXSjVNK1huakw0WU01a0sxRlZtUE1renhqU2hQQzFTSFU3dmQwMGJJZmFK?=
 =?utf-8?B?aUNDK3N1NVZVVG5Vb1NHSDRHZldyMjFWVldtVkVTU3VqdXoxbGJlZFNVQmZs?=
 =?utf-8?B?M2RncWt5VHZNenMwU3dsS0JOd1ErL3l4M3Bydi91TTdiOEhrdWQ5TVgvRlNP?=
 =?utf-8?B?U1Fkajcrd0JZaVk1MDVYUnJBSWZaTFFLa1l4RGF3VGsrbE1oVWEvVkgyNVVD?=
 =?utf-8?B?cmN5eGNDNWtuS3BPcDhPb3BwbENRZE54YzhYa3pzS01SWjJMcFhXL0FiMWRT?=
 =?utf-8?B?T21MSHVzc2dvU08vZzFRbitaaklNYVVkNFQ2Qm84SXhSOU40WkdnZkRVRmxJ?=
 =?utf-8?B?Zm5LZ0hKelVid1BuYmJEbHBhQmY2dU5DZVFOQkpGSXJRdzUxVzlnRVBseWNj?=
 =?utf-8?B?TnNvcDlxTGVVK0YvWTRaS2tZVXhhaXFhc0c5VVpBQ3k0MnRIb3hMcWtPQXlX?=
 =?utf-8?B?Q09oMUxsNWlwR29JU0RTbkZxZXA0OFJxZlp0VGU4MXdCNmtsakgxR1BaYzR4?=
 =?utf-8?B?VXYvRlYxS2wyZjA1Qnd4ZC9YOTRmQ0tYZmxLNklHSmR5Ylk5aHd1dlZhSVk1?=
 =?utf-8?B?akZmZktWb1pGVlBwU25PbGNVS2xjTHY5WSsxZ3BoUE9OODNnRVVldkhRMlFr?=
 =?utf-8?B?S3JONzJoSkF0Nk1PZ1JkNVNkMzM3TmxIVG40cnIyNm1lcVM0RDV5UlBkTWFK?=
 =?utf-8?B?UEovcHZ2OXhkWGJTVEtjTXlOVzIwYkZDRTdRSjlvVWVaWHZHQWNPclhNSGM3?=
 =?utf-8?B?ZXBJbmtkOVBZbDg3RTBja0hyZ2YrcjBEdFFKY05zVVhJYzg2UFVxbC9DdFZ6?=
 =?utf-8?B?WlIyZkxZd0l4RDh3ck9JeHhMYnBYWXNxS1A4Z3NZZ244Q2xtV0ozcFhGeDd0?=
 =?utf-8?B?bWtkSlFXSDE2andiQ29jQy9zaHl5MzhqUDM3WlF1cldOczZwTnhzTHpKa0Iy?=
 =?utf-8?B?anlBM1FlVjJ5V01vV2trU0dIWGRkUjI0QWtVM2dWcExrNFBmcXczdE5DZkFw?=
 =?utf-8?B?dG16c1Z0NDNOVFk1UTVxWlN5OSttYjZ4cmVJNFdxMnhaNisxdUZrYjd5OXNW?=
 =?utf-8?B?Z0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	veBxrPYiuBLMUVCLJfSvs2SI7hGrBb+bOKCGQ/efoLHv7fsTaLWsksAIoiBU7o5tkbfIDSUhrjeQXC/4Hvx0d6Xh24SOu5pzHvN7qhjZWrn3DnzgF4WkbP0ejV8rB0APupLwkMJlMTasSUD8AWf4aD9Mq2Zvqm1GsrICLtz/NajQZblf7V+pmbYfUC+RcFfxvc0hnrEIpMfBF4qH4knNzObsgNDpzDzYf9ZEnAK/06ZbqkFtroRZFarHK+xddXM52RDgQjWX1iDDuX7j3WjbWKDEkWvJjI+8fHx33Eunt0IFf9CEI/Q/GCKFkE1j2a0BBbh2bibSmSkXH2McsPQTS3WcrbrQ7O+8DMKsv3VqAgV5VpLFTMJjH549p/a7Dk9FZOBtwhqyGdltRpb27ZqyaD8jncxJSPaBNqj9F4HLNo/wk4aVSv3NUjiOUyZRnetxqdm+DFMfOux7XXALxn2L6HcnHwSFaQqCL8aOLjv+ZfHbxZhU8N8QOFpb++wGrOnb3qpyaq2HWcWcrQXUJfYrWJtqlEujX+zjG4ppsnaqO7qkiMy+Zl1KtNd+jqn1OoAMeG0LfDPcCPBzRJLFchhqO+wxJEkPg/5JoLC47rXzavI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a9ad2b8-2af6-4f0d-6b76-08dd7852f733
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5893.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2025 17:13:08.9643
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2A5fkgzGfPclwPuK0zMOM2mou0HRc38lXEtqRE+V4C5wcIjhnBtaFzKNfZ8ZC5Wr+T10tswRVm2FxbHydUiljf61WIdC5jTFguEcA+bIles=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6356
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-10_04,2025-04-10_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 adultscore=0 phishscore=0 malwarescore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2504100123
X-Proofpoint-GUID: 0v0zBik569ES5SHmGQbzwVVze-kfgbUk
X-Proofpoint-ORIG-GUID: 0v0zBik569ES5SHmGQbzwVVze-kfgbUk

On 10/04/2025 16:45, Sean Christopherson wrote:
> On Wed, Apr 09, 2025, Joao Martins wrote:
>> On 04/04/2025 20:39, Sean Christopherson wrote:
>> I would suggest holding off on this and the next one, while progressing with
>> the rest of the series.
> 
> Agreed, though I think there's a "pure win" alternative that can be safely
> implemented (but it definitely should be done separately).
> 
> If HLT-exiting is disabled for the VM, and the VM doesn't have access to the
> various paravirtual features that can put it into a synthetic HLT state (PV async
> #PF and/or Xen support), then I'm pretty sure GALogIntr can be disabled entirely,
> i.e. disabled during the initial irq_set_vcpu_affinity() and never enabled.  KVM
> doesn't emulate HLT via its full emulator for AMD (just non-unrestricted Intel
> guests), so I'm pretty sure there would be no need for KVM to ever wake a vCPU in
> response to a device interrupt.
> 

Done via IRQ affinity changes already a significant portion of the IRTE and it's
already on a slowpath that performs an invalidation, so via
irq_set_vcpu_affinity is definitely safe.

But even with HLT exits disabled; there's still preemption though? But I guess
that's a bit more rare if it's conditional to HLT exiting being enabled or not,
and whether there's only a single task running.

>>> diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
>>> index 2e016b98fa1b..27b03e718980 100644
>>> --- a/drivers/iommu/amd/iommu.c
>>> +++ b/drivers/iommu/amd/iommu.c
>>> -static void __amd_iommu_update_ga(struct irte_ga *entry, int cpu)
>>> +static void __amd_iommu_update_ga(struct irte_ga *entry, int cpu,
>>> +				  bool ga_log_intr)
>>>  {
>>>  	if (cpu >= 0) {
>>>  		entry->lo.fields_vapic.destination =
>>> @@ -3783,12 +3784,14 @@ static void __amd_iommu_update_ga(struct irte_ga *entry, int cpu)
>>>  		entry->hi.fields.destination =
>>>  					APICID_TO_IRTE_DEST_HI(cpu);
>>>  		entry->lo.fields_vapic.is_run = true;
>>> +		entry->lo.fields_vapic.ga_log_intr = false;
>>>  	} else {
>>>  		entry->lo.fields_vapic.is_run = false;
>>> +		entry->lo.fields_vapic.ga_log_intr = ga_log_intr;
>>>  	}
>>>  }
>>>
>>
>> isRun, Destination and GATag are not cached. Quoting the update from a few years
>> back (page 93 of IOMMU spec dated Feb 2025):
>>
>> | When virtual interrupts are enabled by setting MMIO Offset 0018h[GAEn] and
>> | IRTE[GuestMode=1], IRTE[IsRun], IRTE[Destination], and if present IRTE[GATag],
>> | are not cached by the IOMMU. Modifications to these fields do not require an
>> | invalidation of the Interrupt Remapping Table.
> 
> Ooh, that's super helpful info.  Any objections to me adding verbose comments to
> explain the effective rules for amd_iommu_update_ga()?
> 
That's a great addition, it should have been there from the beginning when we
added the cacheviness of guest-mode IRTE into the mix.

>> This is the reason we were able to get rid of the IOMMU invalidation in
>> amd_iommu_update_ga() ... which sped up vmexit/vmenter flow with iommu avic.
>> Besides the lock contention that was observed at the time, we were seeing stalls
>> in this path with enough vCPUs IIRC; CCing Alejandro to keep me honest.
>>
>> Now this change above is incorrect as is and to make it correct: you will need
>> xor with the previous content of the IRTE::ga_log_intr and then if it changes
>> then you re-add back an invalidation command via
>> iommu_flush_irt_and_complete()). The latter is what I am worried will
>> reintroduce these above problem :(
> 
> Ya, the need to flush definitely changes things.
> 
>> The invalidation command (which has a completion barrier to serialize
>> invalidation execution) takes some time in h/w, and will make all your vcpus
>> content on the irq table lock (as is). Even assuming you somehow move the
>> invalidation outside the lock, you will content on the iommu lock (for the
>> command queue) or best case assuming no locks (which I am not sure it is
>> possible) you will need to wait for the command to complete until you can
>> progress forward with entering/exiting.
>>
>> Unless the GALogIntr bit is somehow also not cached too which wouldn't need the
>> invalidation command (which would be good news!). Adding Suravee/Vasant here.
>>
>> It's a nice trick how you would leverage this in SVM, but do you have
>> measurements that corroborate its introduction? How many unnecessary GALog
>> entries were you able to avoid with this trick say on a workload that would
>> exercise this (like netperf 1byte RR test that sleeps and wakes up a lot) ?
> 
> I didn't do any measurements; I assumed the opportunistic toggling of GALogIntr
> would be "free".
> 
> There might be optimizations that could be done, but I think the better solution
> is to simply disable GALogIntr when it's not needed.  That'd limit the benefits
> to select setups, but trying to optimize IRQ bypass for VMs that are CPU-overcommited,
> i.e. can't do native HLT, seems rather pointless.
> 
/me nods

