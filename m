Return-Path: <kvm+bounces-35252-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C79BA0ABFC
	for <lists+kvm@lfdr.de>; Sun, 12 Jan 2025 22:20:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2ADE4165FB6
	for <lists+kvm@lfdr.de>; Sun, 12 Jan 2025 21:20:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30D3B17F4F6;
	Sun, 12 Jan 2025 21:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QXgzhMny";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="lUiIqK+z"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 784B3154C0F;
	Sun, 12 Jan 2025 21:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736716799; cv=fail; b=EGzC6I66HGezeFM5we9XaNi20PuWyPeuiF+4y6woVmj2YTWy6mDDTim3naGI7vlu3EJZT4Z9eEaqzB1egsXWOTISMN0oIFY6SrQ3IO6PXPt5krhdnnI3g3q8g3Sjy0tCcHc+4OO0Nf45MlZ5Q2VBZClXBZgxiEPaHUcA5yOT4QA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736716799; c=relaxed/simple;
	bh=JRtysUfdArqCjBWpWk2NOjV4jEuTSeY3VkCmmapWFgA=;
	h=Message-ID:Date:Subject:From:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=aODdWc0dRQ5m+UyAF0i7ymK1uuM32X/vOfEN5uh9XrqucGKYX9ug7A5eyEPI4zREbBF7zWOEek1tjUqGAH89KwQnsqtKBv25SadWqirSZgbm1P2qhNrhkUrxGwi1RO45K7nUv63Cxb7xuVmR3JEJQ2CChYQWtB7tauOX5hLJ2Uc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QXgzhMny; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=lUiIqK+z; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50CLH9R1028790;
	Sun, 12 Jan 2025 21:19:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=3lWmdCz761rH+jtp97+bWq9o+oT7yQXP80W2/Wl8Evw=; b=
	QXgzhMnyPGYs7yItQeXVTCZ2UhpmoEizTboJI63jctrnXz+3aEyv7G3/MVd0Dnrf
	E81rJm5ogUpH9AJDhJuPeC7kKvSSOGEbXHjrvju6k6d6SmLPs/uVL/Ta31Xp9ZRa
	kvmXwWNQF2cXs/KyxSn4ktLnKlsIVpwnKwlIpKzdn5jf+IyuC8CIUCVhX1Wj1i+v
	prjZMmWiwt03wOA+aOMdqwL6xb6t56ryhU0YeJc2JMqphQqO/+CvlhfTyNGnN5p3
	aEVSHcQrLckh2FIbYBIQ8PWNZ2LPCWBJHCYTpISEbdJXFrRJgX9PW/9raOuliyxs
	SW1mn+6jZpnu2qDYA1s3Sw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 443g8sams6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 12 Jan 2025 21:19:50 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50CJbW5u032241;
	Sun, 12 Jan 2025 21:19:49 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2041.outbound.protection.outlook.com [104.47.58.41])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 443f36aru3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 12 Jan 2025 21:19:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FHZWAFk0vGw4lvo0CY9P2htgk0iJgz2olzGYx2mMH1PdK1feuDNyhV0FivCLW9bgScZ9v8VLrOnopAaMyr226SXkOHCad+4SB2My1eeJHgLSMlHL0dg9bMACtSSFrjUzq7Ky9OyQM91lRNl/43ypUZ+yiKfywbS7jasXCJZUyyx54iUPudAUrnFUPbE3aEDnEZt6iATlUxM81y7h2Sf136N6mik/ReG1ovhsmdAWNGDOp58X9CNdjul7w5QX7CS6SLJW9CRN+4ffY8IV6aXJI4xlDukIqLwlJUjSrTGauQTKyh8GPoIe/jABYa4ZWHpAtU/qnuHdXfwUgbAzZzHXPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3lWmdCz761rH+jtp97+bWq9o+oT7yQXP80W2/Wl8Evw=;
 b=D6YJsQzSHVoygpL6WItpXZhkKumLPIvTdrWekLgCwBiib3SO6e0whK6XlgRP/6nVix8C+J3gLEtdg3ZHb+QpMvXWNmkdkcASuLVrHyvM8e/pR/wB7FYGq0vtVfl6mhP5thhy+sepySbzNOi2m9pPwIkZkLkOfV73hWwyDXmKnxj9h8mnoCl6eXJH0NW6ojdqDIOxN0L3/Jl164be1CfonMGJvLslo25J3jzTQMSk6RNiLrVLnVG68iubZ2vXm5oNWDWtdOqaAw+kf7dlfdVzyMmYch3YnzsHdoY4ca542/D/SktzgKto140HiHDjEGCIVxbErtrAldrtEcmdgjLHKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3lWmdCz761rH+jtp97+bWq9o+oT7yQXP80W2/Wl8Evw=;
 b=lUiIqK+zYIBdnQj0UVO3NcfilolHsrE4aEnx1uLGDFEA9KSmhlyrTgsIQKMWFivNOhxRDj4lL4A4gn1tDQixo8jGBxcBI7TTy/i6Ubwyr6zx9Y0B9nZigCRBgCsqix7I5fvnKjhhhc+5NcT9rQkrxD9d6U/RQDawj4ZXCG6tiLU=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by BL3PR10MB6113.namprd10.prod.outlook.com (2603:10b6:208:3b8::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.17; Sun, 12 Jan
 2025 21:19:47 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%3]) with mapi id 15.20.8335.015; Sun, 12 Jan 2025
 21:19:46 +0000
Message-ID: <481cd60a-d633-4251-bb53-d3026e005930@oracle.com>
Date: Sun, 12 Jan 2025 15:19:44 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vhost/scsi: Fix improper cleanup in
 vhost_scsi_set_endpoint()
From: Mike Christie <michael.christie@oracle.com>
To: Haoran Zhang <wh1sper@zju.edu.cn>, mst@redhat.com
Cc: jasowang@redhat.com, pbonzini@redhat.com, stefanha@redhat.com,
        eperezma@redhat.com, virtualization@lists.linux.dev,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250111033454.26596-1-wh1sper@zju.edu.cn>
 <bae5ca72-c6ff-4412-a317-4649f2d09cdf@oracle.com>
Content-Language: en-US
In-Reply-To: <bae5ca72-c6ff-4412-a317-4649f2d09cdf@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR03CA0231.namprd03.prod.outlook.com
 (2603:10b6:5:3ba::26) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|BL3PR10MB6113:EE_
X-MS-Office365-Filtering-Correlation-Id: e8da858a-13f3-45f4-7684-08dd334ed6df
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YWJjU0NSVlF4dmg3TW53QlduNjc1Y2VyZ1FGcEx5UjBvc3dGMmRFNUcxU1U2?=
 =?utf-8?B?UForbkh1QWR3cDBseS9WbXBpUmxQb1lHZ2ptRVpOUEhpblNhR01VNXlRQkt6?=
 =?utf-8?B?TmlQM29QbVJqVW9ST3Q5VmRsMG5ZT04xcWVyWFdVR0FCRjd2YUt5Q1Fxb1lE?=
 =?utf-8?B?Ymo3dDE1NXVmYjNLUjZ5eXUxYWRUZHFvNnlmWDhzYjhDRDNPUnR2RUlnRUpB?=
 =?utf-8?B?Lyt5TG9ZN3MxakxMR1Z6M2VUbjUyMzZuNWdpK2V0dEczQ1dyOGxaeldmSi9u?=
 =?utf-8?B?OExhN1RCKzNpYWxsMGlBR2d3L0tEWVNjNTlLUzUrZEZKcmFwdEpYNkd6NFJi?=
 =?utf-8?B?TkNIYUwvd0NiTkVZODZMUjlCRTRKODAzbXFPbmZWQytTaWJFdk8yM2RrRThr?=
 =?utf-8?B?WldBSnAyNDFseDJTUnE5WkUyYVRjdE9KRUtaREFxVUtFMlZEcG1KbXljMFJo?=
 =?utf-8?B?RmVBeE5LNjFiL2V2RnRmZlNLZ3c2YStoc0l1WElNempCRDJ2MlhkWWU2ckRx?=
 =?utf-8?B?RUtmeTlkeU44eEJ2NGZKaEVDTm5rcVcyUHdMZFo0VGN5SUQyR25jY1NieG9r?=
 =?utf-8?B?ZW1qb3FxMnVIYzlhN1hWcEx1dmNYNmJPVlJDc3R0ckMxSWdXYUw2b2tiMTIr?=
 =?utf-8?B?QnowY3lkd0hGR1V6RU1MOWJJdjBIVk91ZTV0V2dUL0FyK2NOY2lhSkxmQ3FD?=
 =?utf-8?B?aWtiVGdBNm1OQldZRTVQM1FZTUZobjJEckt3Mko4VE1GZExKRFNET0hvWCtr?=
 =?utf-8?B?YnpBVlJWRlB3UTVsT3ZDYXozdEl1R3ZwTG8yMGt3ZUJFMStpQ1loWjlWbndU?=
 =?utf-8?B?bC9GY01BWC85YTZJRWdXdFNuaFhpWmhYSHlmTWZpbUNNUzQrRUhnaEdYdU01?=
 =?utf-8?B?NEkyN3ZaN1A1QUQ4RUVWMXlTcFN4dGR3N09BUVlZdURhWDlkYzJETElCTDJu?=
 =?utf-8?B?bVgwUng3MDVQRHJXeXRVNWRaaVA0dVJaaitpMlpmYmRNNGs2NVFHVzlqWnE3?=
 =?utf-8?B?Y1JLNjVHMnFjM2FJMlJwRUl3QmhoRFpHdHRnUEtNck9HY1lYOUpRMWNmc1lG?=
 =?utf-8?B?UXhWUVFSK091VWc2NWwydXltQk1LVldvT2VTSWIvVVBDdUtKRkJIT2x3Wmsx?=
 =?utf-8?B?UEdkU25waHY5bzJIVHZXQnYvK0JsWUgxY3o5WEJJa3VUbk9OamVVeUJDd3lM?=
 =?utf-8?B?dytIdnkrNHFEZnQxeGJRVzBRckFqR2dwcEZLT25OT0RxOXFHK1V2c09EV2Zk?=
 =?utf-8?B?RFNTQTNJTFRVR3Y3Z2loc2ZQR2Z3NEdDZmJibWZPeS9rcXlDeFpkUEt3VHVu?=
 =?utf-8?B?ek5WK2ZyV2x5bE5obWJEQ2FEQ2piOEpxZ05PNnpVUzZ5QW92Z2FFdVFNekI3?=
 =?utf-8?B?K2piTWJGenJZVWxUOS9Fa2FIeHRvSG1HOHJIQThOc3JlWVRpeEpSQU9aaENv?=
 =?utf-8?B?cnEwOW9ELytnY3JVdURkV2laVndGQmUrREhmOXUySTlGZVlSc01zRkZnQ1dR?=
 =?utf-8?B?dDdZNFZZdDlsTGw3b3NKVjZLbHZQK29SWUdHbGlMcVB3QkVkdkFGL1pMVkND?=
 =?utf-8?B?TllsUEJ4YTVQMGRQQ24yaDBzb1lZSzdrVUI0aTNnTjZ2cWQwVitXMDBqTHY3?=
 =?utf-8?B?bS9kS0FGbzdOWHY5ZHVJODU4VFJKa2dnQ0ZUYkIvZVFyeUw3ekppU0pTK1dM?=
 =?utf-8?B?T2pBY0Y2aCtEQzZuaDJFTWkxSklKME1pQktlRzY4M0s5clNtMXU0L20yK2ky?=
 =?utf-8?B?dnB4WE5INFRLaU5RM083MUUxbDhKQmxuTU44bGNmNlZYRGVFVXRjQW4vSlhl?=
 =?utf-8?B?S0hscnZtZk1mK1hSLzVUUW80RWdUTzZiYk5oU0RXZ0dWZDR4U2xlQ2N2UW1J?=
 =?utf-8?Q?nouiJPK0I2U5x?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NnY4MGpUWkJNczBVNng2OFduSnBaaE1hakRCYkgweHlyOUZML3ZGU0ZOSUdj?=
 =?utf-8?B?R2haU2t0b2Vnc1ZrVUZKdFZmQko3NkFvQWxnaG10bVg0UGg5LzhTTFRCaGFj?=
 =?utf-8?B?Qk1pc0Nwamt5TVFqd281K013VUhwc3RFbUdWMUxBK1FDUVJacWp6Zm11UFJp?=
 =?utf-8?B?RllZN2RKU0c0cldRbjdzVld5RjdpVVpwZVRhbW9EZjdYa2JxUVZzNnQ4RlhP?=
 =?utf-8?B?alpOcTBwa1lmalRMVHRwL2ZlSnYwSCtKSmFPR082RGxMQTQ0cjJNb1J4ZVFD?=
 =?utf-8?B?WWllTkFkSnh3NzNmayt5T0ZUZWRVdEdqMW5hVytSNzYwN2pxUjdURnRVWE1O?=
 =?utf-8?B?cUJERFRaZjlzNXhpeWdqTEZXamxJQ1JsQWxmY0gvRE8xNElldGlmc0hueXV0?=
 =?utf-8?B?b05vVVF4UytnVTgxbDU5bjE5T3JUdllDSmtNUkxDNlFEYXlud3M0a2NNcHU1?=
 =?utf-8?B?eDNjWmNJQ0xJQ3BFNWxlNmRrNmhsd3hOSGJaUFk2OURiQVVIQnF4VFBmd0RD?=
 =?utf-8?B?ZGQvYnBiWXlFbWlDTnYrMkxjWVFSc0U5QkJqM2dibTBYaW5OZXBIUitmZExB?=
 =?utf-8?B?d1FhS2xkNWxqUmo1YmdTcmpjc3JoelkyYXYvMG9nbXJ5eHNvQVIvUEJjNkpP?=
 =?utf-8?B?MitRN01renIzdlZHaG9Ia3E0QVIydjZNNWdaQVNQTkxLajVRSE1lMUZwZlRw?=
 =?utf-8?B?UjRvQ0k2bmE3M2E3STdyL2kzbDFja1J2akl5ZFhKNStmQkZYZ2g0cFAwQWdw?=
 =?utf-8?B?TllGVHI5SGtJMTN5QThIU3RzK1JXQ1pVVFUwNXljMUkyQXZhT1JISE4vYzh4?=
 =?utf-8?B?Y2NsWEhISXhEeUJnVGFvS2JXUXlxNWs5R0J5NFg5U0tNNFdoaFRnSm9VcE43?=
 =?utf-8?B?UVdPa1Q4dG1YR3VldGowbHBjNnBTSk9qTjZseUhZUjlhSXVPUFhwQjA4bThD?=
 =?utf-8?B?Zy9qa1MwcGt2WFpCMHhuRkZpNmt1N1RSWktMVk1YaXh6eXhPOEcyL2g5K1li?=
 =?utf-8?B?dFdFTm1yWVV5amVKZExYS3o4aWFlZUNyeEcycWg4ZmNKZVphdy9IS0tObFBm?=
 =?utf-8?B?WlBEbWJYK0Y5VXI3MUd3dnFqSzlQNVA4bDVQcVoyWHJsVThCLzBjYUYxZFJn?=
 =?utf-8?B?OG90cVBhclZYdE9GdTNXMFcvV1R1SHZoOUhzL2tGaG5yTXJCVWhPNmdTWkEz?=
 =?utf-8?B?YTJEUHJHUGVaL2hQY3UyamliNzlkMmJ0OCtLYnd4S0RPbnFxa1BzNnJpNWc1?=
 =?utf-8?B?Ykw4bGlwV1JndlZCMXRHdjdCSXF0SWFDb3dMdlBUWk9ISXNhVGNjMDZ3RDdI?=
 =?utf-8?B?SFB4SWFaOE5NUmRoSmJNdE51amhyaVVZWmN6Nm12Y0F0TXJpK05EMGNJQ29F?=
 =?utf-8?B?eFVQWitmUWIxdEhGeUVUMW4zVUJHd2FJeERIK2w2Ry83azlGMVpGM3oxVDNN?=
 =?utf-8?B?RFdPRlliQTk3a2ZIMEVNVHNHKzNOVkZyTXpxU1hIWHkxcjFrUy9jL1krSGow?=
 =?utf-8?B?RUszdlNPK3V6NEFDZ2RKOWozalZQSzdWbHFLSVUrYlU5ZzhpUm5rT1NmVnJx?=
 =?utf-8?B?OGlhOWRWQm1oTWpwYi8zVEpzUW92M0RTbEo2T3Z1OENMQ1dvelRHTTVVU01J?=
 =?utf-8?B?NlJiVXByVWpGTHV6ZUljWTY4Qi9sdWVYY3IxQjV1THVRV1ZmaU9UTWs2Wjk0?=
 =?utf-8?B?WHpwMS9ZeGdRbHovWVlLOXkxUFl6SlpFOEJWdmd2U1UySHdoT3AyMW81NExK?=
 =?utf-8?B?Q0tBQVlSS2cwb21MSVg1aGsraGZZQXYvS2dHcm82RldQZzFFSVR3QW83VExp?=
 =?utf-8?B?VjUwWTlKQUhHT0I1eElDN2pHek5EM1NkV0szSTVETDJuWlNPbmcrak0yL3R5?=
 =?utf-8?B?QVhpVXRCREtBdjE1UHBHRGpEZU1xdkNLR1JvbENUQVlHR3M2d1lodnVISzZ4?=
 =?utf-8?B?UTNjRFd4a1VXTHVHVURyQkdwWVFlU0hMYWlYSmpwaXFUUFltdUxoWG82bzBO?=
 =?utf-8?B?ZEV2Rmp3cU5TY1pCOVlsMlJReVR6M3g1aHhvUUdHdm1IdTg1L012VVk5TjBt?=
 =?utf-8?B?Q2ZkVzB1K09hbnJ2RGRpM0VsQ2NDeHNQRG9wMFZQSU5GV3luZFlaQ0lPNnoy?=
 =?utf-8?B?Yk5YbGpzQnV0Ukp3bjZDcEsxTEF3U045WEQ5Z0V3ZFJZRGZSdXNzVWxsSUg2?=
 =?utf-8?B?eFE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	meQnPOKeRgJcT+zW7DDyOIhgGbUrvi01q9wMuoGyZFvW53eMBmFHqTcJ2Q7eo0btqxFRFLwoIIOWJDwooM1Z3iiYHaIQzL/ROVRdjC8/pnsOmcvKsGE17oEKgOjhVMT62knwuWqlPjzhVfNgPkT+Xmlu00tIcCtD6+L+Ii5nKgFtA55JX08uL3cjORUptJG1PkH0wmrcCt/rOCLg+BJL/mhOPO0fBxWDG6/ChxdRpJnzxEKrbiekTVw6xpm0qftGtbF5Bpv9Jq5BWZLI1O1nRi5WOdZTZTrRADQGk1YUCf5XW1+fkIHDngfDEcQyTKtSbI+s0YBaTilnENOpSbdWdyheQR8jqB7Zk8qC6BOPq4ph9VbCYZdpMlOnHAwH+GszaZsng5aJRH4/KIXzTP4qso4eeHF4tHpATl4i2y3dtkOI5AApT1S4kyykeppMsFOqM67rQLWQx9mNsP0Aja5ezs5gh2cZWFVjg3BIkn1TuXmat5qKknKjspFPcZ1+G3KsQZ6Aq2XKafdjO+M73fayWYbzzgL6E33ZkT9q4lH+5hiZ7W8eShpAuQt3V9ubFJgZncPZykzW2O01Z0vmNI63qIksarl5xCNRo8llwtYrBkM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8da858a-13f3-45f4-7684-08dd334ed6df
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2025 21:19:46.3221
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rtMbrSi3rVF+Begq0T/Lv7mvnz60+AE6+jWN9vus6/uXnUANZhaYfP03t3M2jwfXfHz/VJWVMTRLof+pZND5/fmvriCplvyJhuUvw0EIm5g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6113
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-12_10,2025-01-10_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501120188
X-Proofpoint-GUID: jBLoY9v46ajJWjmyKVfcGBFCPtUL4Ttn
X-Proofpoint-ORIG-GUID: jBLoY9v46ajJWjmyKVfcGBFCPtUL4Ttn

On 1/12/25 11:35 AM, michael.christie@oracle.com wrote:
> So I think to fix the issue, we would want to:
> 
> 1. move the
> 
> memcpy(vs_tpg, vs->vs_tpg, len);
> 
> to the end of the function after we do the vhost_scsi_flush. This will
> be more complicated than the current memcpy though. We will want to
> merge the local vs_tpg and the vs->vs_tpg like:
> 
> for (i = 0; i < VHOST_SCSI_MAX_TARGET; i++) {
> 	if (vs_tpg[i])
> 		vs->vs_tpg[i] = vs_tpg[i])
> }

I think I wrote that in reverse. We would want:

vhost_scsi_flush(vs);

if (vs->vs_tpg) {
	for (i = 0; i < VHOST_SCSI_MAX_TARGET; i++) {
		if (vs->vs_tpg[i])
			vs_tpg[i] = vs->vs_tpg[i])
	}
}

kfree(vs->vs_tpg);
vs->vs_tpg = vs_tpg;

or we could just allocate the vs_tpg with the vhost_scsi like:

struct vhost_scsi {
	....

	struct vhost_scsi_tpg *vs_tpg[VHOST_SCSI_MAX_TARGET];

then when we loop in vhost_scsi_set/clear_endpoint set/clear the
every vs_tpg entry.

