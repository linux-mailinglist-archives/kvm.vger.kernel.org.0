Return-Path: <kvm+bounces-48699-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ED1CEAD0FC6
	for <lists+kvm@lfdr.de>; Sat,  7 Jun 2025 22:30:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 90C317A6FA8
	for <lists+kvm@lfdr.de>; Sat,  7 Jun 2025 20:29:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48232202F70;
	Sat,  7 Jun 2025 20:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="U6QktewF";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Zic/87pu"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12231EB182;
	Sat,  7 Jun 2025 20:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749328238; cv=fail; b=iitdkNkAXMMxTkTiJib82ZWq64u92dBIp1X7gRYv065C0yI+kHTMIBKXEUI+GPrJhyOjkQQaF7Yg0hjMB1uSN7HZnSeFt/NlyAKlDogwNGWSwVS4WZNIOnq9ZzWh3heVJ7rIfjfR6qWmbrPpJ+EXlbxoYUQVt06OoOZkzvSF3O4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749328238; c=relaxed/simple;
	bh=26ptirQEbboqNpH5J1J5cmmoZxCVift71YtRYiw3A6o=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=CHxqFYkE2H4sYRdm31ESk/jedVZI2w0r8O+pvPdZGmDBK5TJbrGjwpHe1c6Ov8iXibpdt2MmK5D0Kwj5zFVisvjoESG0F8xZDzyJJliuVqj9P8O49EIFxvyQRg2jTZArU6pRyCixHFB9tdQb9IL8r4IlActkMfc4PFsuGFnFtvs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=U6QktewF; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Zic/87pu; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 557JUHGe008917;
	Sat, 7 Jun 2025 20:30:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=VY4o63gwTEymZwIwSZIvEulZww3db28/xxNa6PI5zhI=; b=
	U6QktewF49aMzjumQDknf6eNsE2UFUDQi4a13mP2QsIzhdObu/C0JQ9SGXfrDX4Z
	McmRaGuxhbqs3Qx+TeArU2an1biZQ7AZgqn0zAQI2J0ySFvDwjCUxaJNQQo9mv5P
	iGVcRArjmaJGDsaVWjsLO9VcwLcXrFAVNRWn3FdK77c4GR1CnoAxP6VFf+NGz59D
	Hw2Aqw6Hj2+8SAzExAlxY8sD//p578AY0OuH66ZryKkPmwQd0RcXlsPClQG+Kg/m
	mXJftvwRPCnWmWcw/aIu+M7f0mgkmdldA5Xs3ft10WBiaY/m/HuSTeV7QIURioRd
	zkLdU2klwl9wGqLVoDqD2w==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 474dywre9n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 07 Jun 2025 20:30:31 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 557HNsMT031388;
	Sat, 7 Jun 2025 20:30:30 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2086.outbound.protection.outlook.com [40.107.243.86])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 474bv66w9s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 07 Jun 2025 20:30:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CrfNossBsd9LHwyp4rgIfnTakxQpZJjhb3ZLpyWWvuj5Tgs+3hIkVXV4kTj3+35IjRsDEOphQyUeZDOgEt2dZINvhBT0EccMymuDbQXssVIBNc86cj1KTiHfp3gIUT2XcyRRdh32+DiAKGq+mRk/CDPh2eZbdP2ZsL9tunbd0ls6ODG9ktunKm6vvZzTxKCzFWgLYhFVP8YMZRx6Y3itmGwjYfDFcR4KBQ8Oh7gIAXBHGTBUSUGRdLsb+2zesZ2Secn3LM1ikNCqVA0xNw0/usW81sfSZSM3VHvSlPUB2bSCygy3gOfWmqt4bMT1VPhMNycubqV2e6MPEvjzUbdRkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VY4o63gwTEymZwIwSZIvEulZww3db28/xxNa6PI5zhI=;
 b=Zh1dFQotosthVmW1l2bqomjtZ1TOQqSug0fzQO+/N/k8mVmW+Gpbtj0ZR85ody7lRoPisFSy5BhRhlOP0W6l2LxeciYMP9/GjtjXNY/T643NMmn06Wp1WFSLzS1m6EVVU1nMOhwgZpSec0kHD8XfYUC8Fm+o6GYOKUvCIFULdWBlIljxiUDmqX52ylv0cft+/dd78yHTNgKFepn0yawoVVUTGGBOxn5qpXvdXTVQYPG5utw8txAgcXjh7D3MhUOhHZOjr+A2PegIQYBioh11qwJCCdClPST/hC4ZOkTqCNe00BKb7YcDmDAS9+lCDX6A5KHPWEsoxpCav9tdktuflQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VY4o63gwTEymZwIwSZIvEulZww3db28/xxNa6PI5zhI=;
 b=Zic/87puzF0pnTunDGPXI8Gg0dn9PKQWvlRCuBzMzjcyTzDFtG6L63hzotPiUWdAvPcOyht0itzLHkZGuPaf4MP7cbcN3Ja6rGhzLBjbMmjqBF3jgdgCu76WkCrdTAnRsXwSIn+oi81XrgFJPaD5lE7IJy0lSuDz8cTh+yYUyOE=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by IA4PR10MB8493.namprd10.prod.outlook.com (2603:10b6:208:55e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.23; Sat, 7 Jun
 2025 20:30:26 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::b779:d0be:9e3a:34f0%4]) with mapi id 15.20.8813.024; Sat, 7 Jun 2025
 20:30:26 +0000
Message-ID: <6a6fee3e-989f-4259-a753-ecee3fddfa38@oracle.com>
Date: Sat, 7 Jun 2025 15:30:24 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] vhost-scsi: Fix check for inline_sg_cnt exceeding
 preallocated limit
To: Alok Tiwari <alok.a.tiwari@oracle.com>, mst@redhat.com,
        jasowang@redhat.com, pbonzini@redhat.com, stefanha@redhat.com,
        eperezma@redhat.com, virtualization@lists.linux.dev,
        kvm@vger.kernel.org
Cc: darren.kenny@oracle.com, linux-kernel@vger.kernel.org
References: <20250607194103.1770451-1-alok.a.tiwari@oracle.com>
Content-Language: en-US
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20250607194103.1770451-1-alok.a.tiwari@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR06CA0076.namprd06.prod.outlook.com
 (2603:10b6:5:336::9) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|IA4PR10MB8493:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a46f081-1691-49e7-380e-08dda60222dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZUx6bzN3K0tkeG1KdnBqWElLRHFiVzRkZGU2ZXlsLzc1ZUpkRFdVRmkrak5C?=
 =?utf-8?B?STZIUklIMURPOWhHcmU3YXRrY1ZLaGhHeVhRZDZ5V3RkSVkyeG5MWWduRnV3?=
 =?utf-8?B?MGd6bnNxbGJnMHBrazU2eFlDaFlCNk9oNXFFMXoyK2JvS1lXdlduZ1BzRHM5?=
 =?utf-8?B?RnlIMXpIMHl3NFNYUHkzcEhmN1g2R3MrdXBBdmNWcHBEVThvUWVpTmlCYzdF?=
 =?utf-8?B?SG0xU0MwWHgyeDNvckZBSXdKOGpWT1orNHhRam5jOFpuN2F6QXVFK0dHVVo1?=
 =?utf-8?B?YmRnSHJDSUQ4VmNkTTMvUmkrSXJqRk9YL0I1b1pKU2NGRlo3WFFvaTNmeSt2?=
 =?utf-8?B?Vjg0YkMxZzQzZkdvenV5bG1PQld6TmpWaXpvZndOcVo2Y2ZzT2RWZnZYdm0x?=
 =?utf-8?B?WjdUN2FLMy9OZ1NSYUt2S0xsSmJxN0NLUGxSVzQxYlR4TXVrTnA4bjFJalJt?=
 =?utf-8?B?Y0dSZGp4cC9wU0pZS1R3d2FpbWVLTnEybStQMTdlYjJ0RHVXd21CUVVKRWlu?=
 =?utf-8?B?dlZKNENsbWNMUnU4cmpIU0txTFhhc3BJWlczT203ZElmc3lUY1M1UkVJRDU1?=
 =?utf-8?B?UlY2T0d3eEJpdGZWSC9QQlB2aVhTalEySVEraXErOTlwRG56WVFXMlE2VHVh?=
 =?utf-8?B?K2tHeDQvSzg0K1FHdmFIWG1DUWVnUVgrZ0lDU0FJanNJT3kxRFFwRlZhM1Ux?=
 =?utf-8?B?S1kvaExpMWl1OWlHWnh1M1hZbFgycnRvQU9xVjdyZFErK3hOUUxqelNDdHFM?=
 =?utf-8?B?SEdETjYxZ1lHNStmalFxc2VydUpRdE80c01iZUoyc3dhUHR2WDkyVm9FVXBQ?=
 =?utf-8?B?YVhwc2grNVM4aDZWVE5OT0xPVExmbXF1UUlVdFlIRU1KSCszNythTXpMZjZ2?=
 =?utf-8?B?Ukpnd3NENERicnU5VWFxU3NpQ3hHT3VlYVFsdkFad09OZ1MybW90ajAyN1Vi?=
 =?utf-8?B?VStLcDVYV2d1VHBQTUJWbXo5UHpMZTZiU2VqcHlIbVZWYlA2eVVyNGRqbXlp?=
 =?utf-8?B?amlneE1MNThDVHdzUXpCQVlhbTlDVTNUTXFBZmJuaXVCL09paWFnbXVNS1BJ?=
 =?utf-8?B?MmVzN1dWemQzMEFDZStDUGM1a3R0RE92V05zaUZKNE93NkFycnpLdkF4eXVN?=
 =?utf-8?B?amNTMnpHR2E5eWZueEY0NWozamZRVDB3TTdXSERxSWxNK1N1c21FZU9HYkc1?=
 =?utf-8?B?N25YajNFOU1xOTViK3hMbGRmUk9xajZKNDU0UHZ5Z1NYTTBoTEhjbmVTNE9X?=
 =?utf-8?B?RTVzWFpXQTRvN0dmU0tKbVBHaE03ZW5YMFpqcEJ3bW04VndIY1FxTzA5NWk2?=
 =?utf-8?B?RzA3ZjF5eGZtVlRNRVdnVWFYc0tyU0ZzczVPRXJjMkVJcVZTQXRLckRpcGlN?=
 =?utf-8?B?REZoZnhqM2ZOSGJjUHo5QzRpQ1h5U1hkdUVoYURmUVRTV1F4djJUOVkyWEhp?=
 =?utf-8?B?aDluZXp2bzc3Ry9wbFB0c2o3TUhYOEM3d1BDbVR4YnlOaXBLZGJuT0tLWklE?=
 =?utf-8?B?TDNSS1pENWFLTVFKRWNvWmdVTmxvekVEVnlraFlETzJOVWl3dHFobS96bTRv?=
 =?utf-8?B?SVcra3lidGdDalB3R1FDY1JsYlY2UjByV0NPSU84VmRPT3NPOGhDcXdNT3V0?=
 =?utf-8?B?bTlZOUlRVHowN2ljcGI1QTNzbi9xSWxUSFF5RVZ2MEhXTWJ0Zncra282dGVF?=
 =?utf-8?B?V3pMdE9lZHRUdWRGYUpEN0NmVnVlQk14cElJcWlHcTU5RmdUQnVHekdNSmpS?=
 =?utf-8?B?STBaREJJTjhDUUgrRlJDM20veXF3QWYwSzB6Q0p6YTdWN0dvdGtWQTV2bWR2?=
 =?utf-8?B?WUhBTnN4dnNNZkllK0diL295VFlJcGVkaVFVUWZXV2RFTFVPaWMxU0YzRUhy?=
 =?utf-8?B?dm4xUC9vUmpYZTZHMkx3NmpBSy91d0lVZWJlS2V4RUY5a2c9PQ==?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SlRZL3k2TTRLckcxQUVhOUZnOUlEUGRkSDc0TzNGZjJkbFA5S0pIenZFM1dp?=
 =?utf-8?B?dmt4OFh3ME1UbUJnUmw3Wk1iZk1yTFJqRWxHMXdvUnh3UzdsMXZPTk5LdnpD?=
 =?utf-8?B?bk5iazEwYTNOeXlmK0RlMVZ1NFZVdjBGWitvMnEvVFFoMHAyQ0pJL3hJNVNx?=
 =?utf-8?B?Y01UbXkzK04yRzhDNktlRWRoMmZ0OHY1UHd0eU1aZmxTRHdEbnIzcWc5TlV3?=
 =?utf-8?B?cllURXJxbE8wR1BEM0N2Zm43U2YydkxJUnoyVzg1SXY2ak5QYi9FazVWdzZ3?=
 =?utf-8?B?RERVdjhHNmRyZ0ZFaWFPUmgwYm44K0E4OUQ5Z1IrM3Fmd2J2VVZmcUEzdVAv?=
 =?utf-8?B?dXBJVHc0bEc1VVhIMkVQNUtDNzk1NGQ5TkhtQngvOUUrTkFtRm5VME92eXdm?=
 =?utf-8?B?OGdXczNQbXdSRCtUa2s5bjFKdG5IdnpLNFB2eU5GRnBjZVBUa0c5dUdZMEZB?=
 =?utf-8?B?YXhmSzN2OTRoOHVYMHBmdVNwWWxQKzZFSVk5UEFCSFdyK1FtN1JYK0tzRGxi?=
 =?utf-8?B?UUt5MVUxSkd6bmRNUk5TbG12ZzQ1a1VId2dtbThUTWN0MXVBOUlHTDFrWWpG?=
 =?utf-8?B?a0h4Q3BDMmhlVnphcHozOVNVR2JxTlkrMnRlSGg3c1cyaFZka1dKM3hmSDFV?=
 =?utf-8?B?MVFnODF0Zi9rL3E0SGZIMHJPL3ZvQkttYkw5WnVWSW51SkxOT2JGVG5BcWp6?=
 =?utf-8?B?L3U5RDdTRmU5R3VNVjgzQXoxYjIxOStGTDlZVXVCRHI3RG5jK1Z5dlpHRWNx?=
 =?utf-8?B?TlRPaXJ6eC9tUlZ3RGdzbFJkeXJ5SDFzNkVYK28rbTVwNGxKZG1uZnNISVpp?=
 =?utf-8?B?MnNkN0U0RjQzWVkxQXBTOUJwSmZZditaTmV4c2tZb3V2WWFWYUw1Y1ZGeUFn?=
 =?utf-8?B?QkRETVVpRGloSERweWlORGw0RHdVdjNncWx1bER1RlY2VUxlOVN3cUZvTCtO?=
 =?utf-8?B?bG5QSHpHUFZQOTBqQTdyb2ZkSGgrZEFyWEl6UnVEUW5QV3Z4ajhmb1NWanJz?=
 =?utf-8?B?UTBiUFEvM1lPM3kvSFpEOG1zY2kwanZDOE1NUG9NNHAzSitXcDVOWkhraTBH?=
 =?utf-8?B?cVM1QmlWbjlxY2Z2bXhYM1RPSTV5UUVKMUZGL0YwRjNZeEZFU2FhL0NPWEdI?=
 =?utf-8?B?dWtCOEZ0MWRlaGhlMXlWd1RobmV4d2kxU2JoWC9ZemNxR0o1NjFObVdmVFlu?=
 =?utf-8?B?bmFvZ1BPTlQ2WFBPMjhsMmxqMGJwbzVvd0ZZVGVSZFc4NTU1NGZhc0wxcHFD?=
 =?utf-8?B?OS9iYXZFakc0QWFrbStUdGNoZ29Ed2F6YXV5b2tQWUc0aXlDdmlhNVRsWXVV?=
 =?utf-8?B?N2Q4VS9Gc1pwZmVqaExhUGQ2WUphSnJHQ1BjaWt1b3lBSURnajVDeEFvZFlE?=
 =?utf-8?B?UW4ybUFBNmR0NldtUFlvcXBNMXJzWXdVQnFDWlA5dmNlNEhNRVprOG5iWWc1?=
 =?utf-8?B?U05OVytxVUNYTG94SDJ6RkdZZVc3YlVGQ1JvZ0VRcm0xSy9xT1JudXdaTVFC?=
 =?utf-8?B?azNHOC9LNW9kQlkvekl0TGgrRHU4RnRjeEhNWWdzNWphNWxodnJ3blVkamRu?=
 =?utf-8?B?Z25mbnJZOTRiV052TG0yRlZxTGswaW9QWDhYMWROM0lEYTZ6RWhqb1lkRENp?=
 =?utf-8?B?N1FYVHp1enloMXZSOU5URmdONTY4SERObUduM0dYTU5vRTdKVFo1Z3kyejF3?=
 =?utf-8?B?MHp4TWx0QVRYZU92NWQyOWh1b2Y0dlN3SlJTenVIRzFpTC9UZUkwb3hkbjU4?=
 =?utf-8?B?ZFQ3UVU0MXVuYmYyMkdsQmJjdkFEWFI3QitUVEJLakdtNjlEWXN1T3huS2FH?=
 =?utf-8?B?amZPY3dCdERWVWpMZjg4dG9hZTRaaHZYYUp0ZTljeHBBeEc1Nk0vck5ZdldK?=
 =?utf-8?B?bzJ4c3p1WldWTjRzWS9DSW1SOUY4aVNuYnVhdXdtMElXQ1lWT1h5MzRpVDFF?=
 =?utf-8?B?aWNNcUVrZjhCR01LWW5iWlY0Uk11WXhGM3o1WWFjbXMvbUd2Q2t6WnZ1ZVoz?=
 =?utf-8?B?d05NTXRBOU1JMFF6RE02OTdXajBIL0RCeEI0b0dpbGM2OWRRdm1lRWl6RURu?=
 =?utf-8?B?T0dpa1FUYWlRdFJHeEpJV0hBdWtvUDhhQ0g4eEhMS01SWC9Mbk1TWjIvc29p?=
 =?utf-8?B?Ny9ZNFdMTTBBbm9vdlAvR3dON0hRRWE4ZzM0V1liL1ZjKzlrMk14T0w2dm5C?=
 =?utf-8?B?N1E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PbZRmbtjSf0FWaiUYzVdBbzw3L2ug7kbpEzHLqoCDgwaXME/W6KdqgOgSP5WsuQS71F9mmUvlPYvPX9HrAEdtXDDWzEUXEGj/0E8HtE3UX53afyJzwrfnEG0RuXVzA+7gaMFckVMcWxwQAbxlQZqoLDZ52GFhBsgBmzyo6yc3qTaAUXJECWG1c1SWBAE0NsICjSlxEyoZsTbht3Ur7qAVTSdzH9R5nd9eK2FkCcEZwG7J5gO6A65Gbm+7UfiTl64LylY2UTnTI2OPrCUfswD6XjTN3VO7vrO/mPU/uj+DqHFRI3xvRyoFHwlwYoHYpSUYFTdbQXO+yqB+b3I6YbiG1AmOOY2z2aeZbJ+0iIcKgwGyqQ4DUfKay2MuqA3XSokb1DJc9ClQr+8n0rR3p3pndMOJrk1w1W42p6jQNobOsOH8zc1nmtZBVaCw/dcaa4gY3gKbfTr+5B8J/Z10zz2NA4iK7jTWVDre9D7t8QrnwnfCuVieNX0ZZuKTc/0XqM/NyBmsV+0nnBKJzHa8hqpMScodiIeMrifwTMUOVTZ7Rm9Rs8EWcvE/sAJCFT3SdiXKy/PAt5NfcGT/cFrL7NqZvDTiSmnCd7u8PQQ6sp9NYA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a46f081-1691-49e7-380e-08dda60222dc
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2025 20:30:26.3227
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 63P82bBMVs45t8z6VcX+Jl1prvo4r9ywbOlV4tC6E+M5IHiy/Z+MZP51iwgnCfE1J+e1o0wubA8ffFI90zYzXy7vUU1tpOFmLtwdB/1l2u4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8493
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-07_09,2025-06-05_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 suspectscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506070149
X-Authority-Analysis: v=2.4 cv=fdaty1QF c=1 sm=1 tr=0 ts=6844a167 cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=8KZrJaxwlpsGMJMu7YAA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: qCgfjIqR2UqluKfLp2a0bYAAd18qabz4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjA3MDE0OSBTYWx0ZWRfXxAR6p7dwFjEZ 7QgWK8f0Rp6cKPG97L3JaJDpRiRFo1MTwe0Ctec6MGsCkt+Ez23MaHcPaQMmt4BY20Boul4EKqs m314PP1kv+DFlOPVScFfuRlK5OpIW3J/49s1qII2wH4/l9ajcdVYvT2Ab5zgDEKA19fHRfCROzS
 kAxnOuByCGwo4gTdeHFY2MtFnPYMhAlauF4KvDYrzZBZS3xrR0kGQxwjBieKOm4zhS5ATivmvg4 DCW/wSC4rZ0jBErWf3uYIe6q19Zm1bUDlC4nbeyh0XGIysLGlhuIfiqY+D3Lmd321fISooxtKnj u4K9nc3yqZ+FMRcJY8CoC5J/xC0YotXS3mj4h9hAMtteeDeIFEseUK6JLEc/UV/7p2A9OZBRspA
 phO/XGi3Jk1yszeNfhKp8EsKwWftDplR/JCVvz5606m2e40xwTI2fJpahXxc70M2rdxiCPn+
X-Proofpoint-GUID: qCgfjIqR2UqluKfLp2a0bYAAd18qabz4

On 6/7/25 2:40 PM, Alok Tiwari wrote:
> The condition comparing ret to VHOST_SCSI_PREALLOC_SGLS was incorrect,
> as ret holds the result of kstrtouint() (typically 0 on success),
> not the parsed value. Update the check to use cnt, which contains the
> actual user-provided value.
> 
> prevents silently accepting values exceeding the maximum inline_sg_cnt.
> 
> Fixes: bca939d5bcd0 ("vhost-scsi: Dynamically allocate scatterlists")
> Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
> ---
>  drivers/vhost/scsi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
> index c12a0d4e6386..8d655b2d15d9 100644
> --- a/drivers/vhost/scsi.c
> +++ b/drivers/vhost/scsi.c
> @@ -71,7 +71,7 @@ static int vhost_scsi_set_inline_sg_cnt(const char *buf,
>  	if (ret)
>  		return ret;
>  
> -	if (ret > VHOST_SCSI_PREALLOC_SGLS) {
> +	if (cnt > VHOST_SCSI_PREALLOC_SGLS) {
>  		pr_err("Max inline_sg_cnt is %u\n", VHOST_SCSI_PREALLOC_SGLS);
>  		return -EINVAL;
>  	}

Thanks.

Reviewed-by: Mike Christie <michael.christie@oracle.com>

