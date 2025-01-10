Return-Path: <kvm+bounces-35106-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A2F1A09CB5
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 21:56:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7D8233A6D4A
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2025 20:56:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F323215F5A;
	Fri, 10 Jan 2025 20:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lZq2LjHR";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="wkyWwPbt"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A09B9215058
	for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 20:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736542606; cv=fail; b=kJYrj5qZOapL8rnBp+vi4qoD2tFKdWRqF4jYcybHBj+EjJjrt5BqCPgjqRCDrq2dvTt3ft4rltZiCXedeD1HfvRTihxVNCxYZUfM3XTZ7DgeSb0spkvGOGV/YIzsktvUFDCcridegw8GxQR017mcgjGHb+MAg7f4+0M531uTn9k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736542606; c=relaxed/simple;
	bh=8v6XnGvHN87sDgwuKiRf/09B43gqryd/a8SXarnUo5o=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Jp+IlG65MpsgNPZlwSAdElDRkK0s52Liti0WmpeLfisvj+P6QGjZWYmxsdXdINNIcfJlWPTC2uxLZZIx8h5mCaoNn4rwK/80Ig2SqQVt/u3fXN7ReUx8FiKemubGX0b4dVaMV0nxSdrqra0FeBKi5PMr9EzA+dtTX4KL1rBMYkA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lZq2LjHR; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=wkyWwPbt; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50AKtqXt021217;
	Fri, 10 Jan 2025 20:56:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=Tnb2hxLEIOV3IMKuUr7G98gZahhE5WyjF96fg9VlSG8=; b=
	lZq2LjHRnw8j2mHLMFxLUrJyuX2JRRnglRCdpvHv9YTu1PlG8q6nYQzxh/GHkMhI
	K8zA1FYmuom6qzwaAvE6y46HbvTHpwCcwgZz0upFPx+5lrvwteQP5nYuPOgMscEn
	osiD2OeTC3JmQ1k0q9DrHa9o1FrwCA1og3A+y/BOvWh8h3jUIl9xx6nNOF0wolNG
	jY+uUv9q8ZhVG/+WKI98JsA0LbaDon79iaFAS1tXWn0s1zLO20kb7CCsBXVjAjMy
	RhMHFKD80R5H3Bv7iMQuGmSPnxHbCyFMsmnGjSKnn+m2fB62gJA0aqI0SNHDfeN7
	hoxzYPzE67CUrJ6DM1j9Qw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 442my6253v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 20:56:27 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50AIedUV004828;
	Fri, 10 Jan 2025 20:56:11 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43xuecw6gg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 20:56:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M10mQkL292E93La2s6A8TwKHrz3lHa5nO38u9wnnBIMA3O2roPo8QD6QDIEwLhn4iR80tIMus1OJTKRdC5y8IXXaGK+r7wYvnmsTnBGatfoZUUj7ujwAHzMGnBHtZX5iR47wySBF3R4hPWETnTOR7a8M4cWX9VKuQREdBeZvGGOwlv1hO3r5rimhlaNWWf/ucIsZJ4Rbo/o1rtQZ/BXPYVrzAr0rhicE2+Pl51u3rH70T95lTic+ZcxqKx+TxfDTn/VovtkTRSy0qzzN9AVV1AYu8/4182sYKUfVk8+PcfDItzo7uGWZeCa59F7YQHjAk/GmCzo/2bVeOoiskTG+Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tnb2hxLEIOV3IMKuUr7G98gZahhE5WyjF96fg9VlSG8=;
 b=P8v3Ip+Z1ul1JdN2SxORK+ETps1lMbNJd/hKPcyGvorzRvXVpQTwZ6AjZWSLw2ZddtUGNlQ6MWwqIDS6MNkuVMjaa5X5s2iVLS1cqYVnrcFI7y4lQ2w/fGHa0Z/ZsksH9sIge1Gkof9uaLvn5My25fy+kQYKNoxg5Dnb7K0iRHGjMZnMi+TZLt0YxQL/17wYb4K7IFdfeC3oAbBfq+SRIrclnLefkYJHMCgJkOPj88Lgt37smpjOq++Nzmf8jBxY6KdF95F/3/nMct837u/LB1F0SMl0zIu99rP7+yVQzLT/icSmNujG6qnUAk89PdCRMu3DYVyeCGT/w+KuEUsa2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tnb2hxLEIOV3IMKuUr7G98gZahhE5WyjF96fg9VlSG8=;
 b=wkyWwPbtzUnY3vOHZVEtjUzkVvKLfZdYjBw5tdvRT4QtYeO88+VU3rSx/HB+yw927DG0nosFWExiwuTDW6xZvnzTg1npi3SePnFByjDvgSFn7ti5QXEIghIfZOGhzvsHpCqaTgGBnUFkQmCkFcRo3t2aZZxiNvJP8iHMySfzyeA=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by BLAPR10MB5156.namprd10.prod.outlook.com (2603:10b6:208:321::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.10; Fri, 10 Jan
 2025 20:56:08 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%7]) with mapi id 15.20.8335.011; Fri, 10 Jan 2025
 20:56:08 +0000
Message-ID: <c45033b9-2ca6-430d-9719-72b123095b64@oracle.com>
Date: Fri, 10 Jan 2025 21:56:04 +0100
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/7] hwpoison_page_list and qemu_ram_remap are based on
 pages
To: David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: peterx@redhat.com, pbonzini@redhat.com, richard.henderson@linaro.org,
        philmd@linaro.org, peter.maydell@linaro.org, mtosatti@redhat.com,
        imammedo@redhat.com, eduardo@habkost.net, marcel.apfelbaum@gmail.com,
        wangyanan55@huawei.com, zhao1.liu@intel.com, joao.m.martins@oracle.com
References: <cf587c8b-3894-4589-bfea-be5db70e81f3@redhat.com>
 <20241214134555.440097-1-william.roche@oracle.com>
 <20241214134555.440097-2-william.roche@oracle.com>
 <a00d6d67-c0a1-4d54-9932-bf3b3a7054d8@redhat.com>
Content-Language: en-US, fr
From: William Roche <william.roche@oracle.com>
In-Reply-To: <a00d6d67-c0a1-4d54-9932-bf3b3a7054d8@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS4PR09CA0002.eurprd09.prod.outlook.com
 (2603:10a6:20b:5e0::9) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|BLAPR10MB5156:EE_
X-MS-Office365-Filtering-Correlation-Id: f29732db-34b8-4961-2185-08dd31b934ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?WXlLbG1UZGVhZ1l4SFpjTUlMekk1TG43d1pWNjBadHFleTEvUU5xT2VJZWVp?=
 =?utf-8?B?WWk0azdCVFRJOFRZNkJEbVB2aDR2bkNXT2xBSHYxK0RBbkFramlTTzZNT0dP?=
 =?utf-8?B?Qnh1L0IwVUJYMHZCK2Q5MEduMnFnYTdOUGtJRVp1RjVCSHR0VXpPeWNIV3FY?=
 =?utf-8?B?TG9YRE9qUEUxbzFJVS9JQVVsMWJrdVBKRUJJa2d6K09uam9PdUhYNVJWdXVC?=
 =?utf-8?B?UlFWZ0NQZTF3K0lnbTZJb0NPRzlKVWJKR0xUb1BteVVrK2s1SGhkZmZuL0NJ?=
 =?utf-8?B?WWFEeENmUkxnZ3ZZTllwYnhucjFFMlM4RnN6Ly9iKytVU2NmeXNGdnlaQmhX?=
 =?utf-8?B?SWY4ZXJuZmQ1VDE1dWRvZmpPM0EyODNUU0trZW02bVpTTkFac0hKMnR1Ry9o?=
 =?utf-8?B?dWxCY0JhV0J4YVJ1U0dSa0NvZlowQXQzemVWcFpxRU9CL28yNXpYTno0aE1y?=
 =?utf-8?B?bVFDV0RSZ3d5RzRPRDFQUmpHQlhSaE1MWmJnWFdNOEU3dkZ5ZURKZkF4UEdQ?=
 =?utf-8?B?ODZkYXUwNDVBN1hQT2t5cFduSzZWd01vTnN6QjlMaDJRR2lMUWVLMTkwaGdS?=
 =?utf-8?B?NEpwUHlvT0VjQmRjU25Rd2k5ZVEyTFJ0eE9aVTAwcldVWjJEdU0vZGlTaXFE?=
 =?utf-8?B?bVNvYURVNDcvTmxtKzZyT1NCbmxZOGR4UG5BRFlKWmdtZitFdFl1ZWxPQVJq?=
 =?utf-8?B?Z0tFTlU1YU9VU0xkMCt3akhSWFhxL2lwOVN6R0txSGovQzlJSVQ3elRRdnRG?=
 =?utf-8?B?M2Q4RFU5dnAwbTJyNVE4YzEyaGFzcWxsS1ZvcG5RL0ZBVGNvdjRmQURTSklm?=
 =?utf-8?B?WUJEbWNMWkNMUU80RnErS3lyWlErWXdQbkQ2UnpGeitmYzhCU2FrVUF4dzgz?=
 =?utf-8?B?NUp6Mjdhcm9iZ3VTUG5RT3BBditOaW10VkpiUWVyT0NoclBqem5WY0VsYmRB?=
 =?utf-8?B?SDhxRTBPKzcrc0owVE4yeENsSEtTNUtibm1pWUU1eDJyb0cyclNQMTRvSkky?=
 =?utf-8?B?RDJUSEgrd1pWR0NhNUZuZ3dhYlJBcFFrTmVNZ0ZKM1FoZWhBL0R0U3dXMUJO?=
 =?utf-8?B?dFZtSkZFU2dTZHU2dW45bk5WQnFqazFKWkRvZy96ZDNqZHA5NU5HUUtTNWZ1?=
 =?utf-8?B?ZW1KbmV2ZXllMHU5Y0tOemtoK3N1WFFUZldGdUExaUZPMm1Dc3VJdWpCNjlz?=
 =?utf-8?B?b0pXU1JTeXNrWWFWQXZzV2syUGdKeXFMVnZON1pKSVNGM3dVbG9RbjFyRjlj?=
 =?utf-8?B?ZTZCd0JMbGd3UkszUWM5bjJ4ZEJHaGFDNHNPcCtFeHZhd1IzaHZQcWhnOFVk?=
 =?utf-8?B?SGFMZnRBbnZ1ZU5BYjlsdm16eHM2YXVCMGpEcUtuYzFLZWVHM0JENlZ3Z0xJ?=
 =?utf-8?B?NHFGZ0FaV0lSVDkwVVNDZm5OendLMU9xZjI1MWJJZmpDM3c1TnE1bGNRQ1Zh?=
 =?utf-8?B?eW5Kdkt4cTZYczhxYU1xRU1wUVA1ekZxVEN2T21MRVRQcEFjRm1BeUN6LzhB?=
 =?utf-8?B?MkVPa3Q3ZDFHaStTK3VjaXNOanlHek5wQUZ0aXZGU1hhNnQ1MlhFbmZTL3la?=
 =?utf-8?B?VUpWYWxCQnNEajJROGtQQTl4RURLZFRVUGhOZjZWN2FXK2dPZ2JFUmkwZUxG?=
 =?utf-8?B?eldwNnBnL3lZWTExQUthK21jblY2aDM3dWJZcjNXdWFkd2VOS2FCdlVscHhW?=
 =?utf-8?B?ZEpQYUtyNnhNSU5NMFJzM2pKOHBZaUdDNHYvdWhXbXovbitZOEFWdHQvb0JD?=
 =?utf-8?B?UjlKU1B2MStEVkZhUFFrUXJJcEhyRHByUEZ4K2M4YWhlVjh3aXpiOENJdFdo?=
 =?utf-8?B?ak5VdkhUOWo3bm1sNUVMM3d4Um56MmFTQTRKbDFNT2ZzeXZvb1RNR0V0Z2xP?=
 =?utf-8?Q?eBhNqYhHwv6gH?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?NFBaMTRoaXI1T2VLV1JPQVBUeWtWN3BLWlk1Q2JMT2psNzltYTA1bWkxR0pG?=
 =?utf-8?B?RWtLaXJSVU1NSllocXNoUEV4SHNjbWJqSkYyLzcycXlZODVpZndFcGxPd0di?=
 =?utf-8?B?VjR4YUNITmJVd1B4U01hODM5UFdmdDA5OUt2K2hkbDMvcGQxbUdjZm01L2t0?=
 =?utf-8?B?MlFHajVmRU1BRmFhNGllKzNQMnZ2VDIxUzA0ZVlPTzdONDh6aVVZd2NpeVZ2?=
 =?utf-8?B?UUdnclJ0NDhPcFA0WGRGSjZVREQ3ajNGRmg5WjFxVFpZaHloMWExOVBXYXN3?=
 =?utf-8?B?VE9JbTdhV3NSUjRNalZjS1FpQ3ZrUWt3SkpYTDk1blduQjJUdTNpSkYvNVRn?=
 =?utf-8?B?VGZ5ak5pYXpoL2pqZWNEZzQ5a3U1K3lZcEdzMjMwYlBoakdtcnArZm9jM0NV?=
 =?utf-8?B?SC9hR1R3R3k5TTRXRy9zbGJ5aEVubnF0ak93REFLbmJjSTA1dHp4ekVzaC9y?=
 =?utf-8?B?QjBEMDhzZm82UE96SjZwaGY1VDZrWWo3YnhZQ0JKRTcraW5ZVUs0UThnc0Er?=
 =?utf-8?B?eDJLenl1bWFWR01mZzF4S2xRbW8zOW9YaWkwaGJOcWgrMWsrRnZIdTljY3hk?=
 =?utf-8?B?R2Y0SHVVZjIzeTlQUXdBVkRvSlY2V0ZRL0pEaWM4SlZqWXlsUk5KSzhWck1P?=
 =?utf-8?B?TWM0SDgxOGJiSldCUU5ueXhuKzQ2MWNPREQvdjQ5R1ZVWFo1OXRWdXhOdG40?=
 =?utf-8?B?clk0YWFNNDhEMTVMQWEzUHptTHk4YXdOdmswWXlwVWErZHJLSFQ4My9OK2FZ?=
 =?utf-8?B?TXZNZGdlVng4WC9xN2I5ZVdtdzRoS3JJV3NsczM2UDBlNHVMdnovc0xKNEY5?=
 =?utf-8?B?T09DRS9jMG5qNWxIRXhQTzNDVENhWWlFRVd1dU9XYkIxYzdhTUhPRUpLUUFn?=
 =?utf-8?B?WkZWejFLRXJDeXlHLzQzb3NMN3AwVlBTSEVuYW9WMC84TmNENGJmb3ZVM2tu?=
 =?utf-8?B?QVRMbXBlQmh3STVJWkhZNURpemFUQzV2cCtRcDdpa3JPT1plL0gxMGcyTTFK?=
 =?utf-8?B?c1RHQ3FPL0E4eTVKNm92M1pSd21KcFB4elJvTnZLSjQ0UCs4VUVaSWdkd1NH?=
 =?utf-8?B?V3d0SnpDekJ2bjBLbzdaKzBIUDlWN0NyUkl4WmNVbVJ3N2VuQzQvN2pXOWx6?=
 =?utf-8?B?dWNibzZwaFRMTkVwZDlGcHFRczZ0a3JTN3o0WnZ5RXRxTDJxL1FCMmE5NGd6?=
 =?utf-8?B?cjFKVHJUbWdCVGE4NkNSbWxmdHZxUmNYbmorZEtCYlFIQkFzZWpHM3BQQnd3?=
 =?utf-8?B?Y290UWdYVHFJeUs1VXErZmMwNDZYY3NWM0RCYTVaQjBma25jNERjalcrWUtn?=
 =?utf-8?B?REZWNVdybVNCQ1h5WFAxV21RRnhBYXVZUGhVclhTaTdMOFZlSUJHSFFVUlhr?=
 =?utf-8?B?VHF5c1lPZytlZVRyWlVkak5JRWNXK1h6V1lNRXpscklqNmRUZTFDdTFINUJn?=
 =?utf-8?B?OWNOaWJwY1JzcGN5RjZOUU4rdlpCT0c4VHRNRGtkbXJmQ1QybDRhL05aMkJL?=
 =?utf-8?B?YWV0NVhNUUtCTXkwNDVGbUhHcUNhTlN0QkVSMFBKdnRwQTlOT1poUW4xdm5Y?=
 =?utf-8?B?dVZrUFdJSzlDaEk0eTZhYlM1b0orYzhtcWduYlY0ejRtMjY1UVMrRGpSQkhM?=
 =?utf-8?B?SlJkSEtERUFLZFVJUmtDOXhtQUlvS202YmlZelJ1NUp5TDNZODRXanExL1kx?=
 =?utf-8?B?SzNCRDVPa2Zmbmk3dEoyMnJVaDZydzJyeExYMVg2ekxMemxnQlFaYUd0Y01i?=
 =?utf-8?B?WmNBeHZVaXJFRGdlSGhQQnM0MDFkSmdBcGR4WG0wdkRTWEErMUxkdGI3MVBq?=
 =?utf-8?B?VW1ySzhoSHc0YTY1eGpxUVZsaVRET3hITnViU0NXNWt5blhuYkd2RXQwOEdQ?=
 =?utf-8?B?YnU2S2I2TGhrM0dweDVxU1VjSHc4WUw3R2Z5VXEzWU1FK2hDZW0za3VBS2NE?=
 =?utf-8?B?NDFBdDNUNjJOZDdmS3Y3ZHU3UWVVMG9ISVpuc1FFN1J3Qno3K0w5NHBETmlQ?=
 =?utf-8?B?QnVzUzRla0wxaUpBK2txbzV6VzZrbzVWZS8weW05Q0JPWnd0Q3NMcncrZzFP?=
 =?utf-8?B?VWdYVGllNUc3a1A5aEU0N3NiazlUVTlTRUUvZjNram1xVldGSnltZjg2blY5?=
 =?utf-8?B?S0lSZVh5QXcwellZMm5KNFJNbzB3L3lTRTV4SSt3WkhBL2ZFRjdrR3Vnc1Yx?=
 =?utf-8?B?d1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	McqasBGNhQQj2OLaLgQTGB4FmnQR7u8aVziZUA+JLPJBXTv2tmEhqapEof+1ST0qpAz9pZDldn75FwPgl+vkWfoDd72GqXm9pF+l9A2Q2n7htR45mBH2zO1cJEKTjdCblY7PqAEtyjnVtBOmpQtN8XxufKRCZD73QoXVlalKGevBENuIw5fYi9rBeDWvYjHQfZA3Y4RqPBbkGDsWhlPpkU+NEuRgC3lMnFJxj9n9rn3WHL6YX6j2fGjpd4IemPU0KGSRArfclvj8lcSYVirWTQHuEJCsInx941HecJxBifvTbWbSDIecwlymgOCPmkfkJh/hGf+EZqUkUAz8eRVUzwU5PLG3dRfbTmZCu8/1El90svQ8xsO91lGfvS66C4QmLh0+6kCOe4nukirrmBroNUJ/vnYb8uBfdlBf1j9Ym7dEjOElpjbkU5XR82oVZgbfUbeNPu7e2GGzZRqIIVXfhvBvk/uJiiTCnFqijADCrg9BITTTFWznlbEuZEV5j9vXz82/x7161OuP7n+1sbhoouZDUbsGzYNrJILnbUr5GfvDmmQ1HAjC4Ab+qRdubf83yrvR8F8b9DtwRrSCYJCMgs0pQ0DW1RYzl2Tcfm6qftA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f29732db-34b8-4961-2185-08dd31b934ec
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2025 20:56:08.5347
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k2Kk4Ytzr8oBNSQceEt/Udq1C7V/avxrQNO6UVxfff78XRuIZfTG7V2S31s7bN/ELt/8eXAMVJkTEIkAwDywawwWXEKgHWi0NVDHdDYCXZM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5156
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-10_09,2025-01-10_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 suspectscore=0
 adultscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501100161
X-Proofpoint-GUID: 0MzMJU11zkaa8_95v4aJ0VFs_ftuK8vK
X-Proofpoint-ORIG-GUID: 0MzMJU11zkaa8_95v4aJ0VFs_ftuK8vK

On 1/8/25 22:34, David Hildenbrand wrote:
> On 14.12.24 14:45, “William Roche wrote:
>> From: William Roche <william.roche@oracle.com>
> 
> Subject should likely start with "system/physmem:".
> 
> Maybe
> 
> "system/physmem: handle hugetlb correctly in qemu_ram_remap()"

I updated the commit title

> 
>>
>> The list of hwpoison pages used to remap the memory on reset
>> is based on the backend real page size. When dealing with
>> hugepages, we create a single entry for the entire page.
> 
> Maybe add something like:
> 
> "To correctly handle hugetlb, we must mmap(MAP_FIXED) a complete hugetlb 
> page; hugetlb pages cannot be partially mapped."
> 

Updated into the commit message

>>
>> Co-developed-by: David Hildenbrand <david@redhat.com>
>> Signed-off-by: William Roche <william.roche@oracle.com>
>> ---
>>   accel/kvm/kvm-all.c       |  6 +++++-
>>   include/exec/cpu-common.h |  3 ++-
>>   system/physmem.c          | 32 ++++++++++++++++++++++++++------
>>   3 files changed, 33 insertions(+), 8 deletions(-)
>>
>> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
>> index 801cff16a5..24c0c4ce3f 100644
>> --- a/accel/kvm/kvm-all.c
>> +++ b/accel/kvm/kvm-all.c
>> @@ -1278,7 +1278,7 @@ static void kvm_unpoison_all(void *param)
>>       QLIST_FOREACH_SAFE(page, &hwpoison_page_list, list, next_page) {
>>           QLIST_REMOVE(page, list);
>> -        qemu_ram_remap(page->ram_addr, TARGET_PAGE_SIZE);
>> +        qemu_ram_remap(page->ram_addr);
>>           g_free(page);
>>       }
>>   }
>> @@ -1286,6 +1286,10 @@ static void kvm_unpoison_all(void *param)
>>   void kvm_hwpoison_page_add(ram_addr_t ram_addr)
>>   {
>>       HWPoisonPage *page;
>> +    size_t page_size = qemu_ram_pagesize_from_addr(ram_addr);
>> +
>> +    if (page_size > TARGET_PAGE_SIZE)
>> +        ram_addr = QEMU_ALIGN_DOWN(ram_addr, page_size);
> 
> Is that part still required? I thought it would be sufficient (at least 
> in the context of this patch) to handle it all in qemu_ram_remap().
> 
> qemu_ram_remap() will calculate the range to process based on the 
> RAMBlock page size. IOW, the QEMU_ALIGN_DOWN() we do now in 
> qemu_ram_remap().
> 
> Or am I missing something?
> 
> (sorry if we discussed that already; if there is a good reason it might 
> make sense to state it in the patch description)

You are right, but at this patch level we still need to round up the 
address and doing it here is small enough.
Of course, the code changes on patch 3/7 where we change both x86 and 
ARM versions of the code to align the memory pointer correctly in both 
cases.




