Return-Path: <kvm+bounces-36181-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A3FCCA18607
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 21:19:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 602401683BE
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 20:19:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 257DD1F754A;
	Tue, 21 Jan 2025 20:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VvGSh5Dc";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="was9b+eG"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F8801B0F20;
	Tue, 21 Jan 2025 20:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737490762; cv=fail; b=QkqTlXIwALrTSWXRL6tq7K6lh7aVld7EuWmVt+uiViAf9ZQgOnF/+2NIEqQUiwg1WYJpF7hvduSmu2OGQASCb6ZVDaPUp67gYXW/7P2G+VLFOAMz2oV/7jA0RmN6xE7Ke4PGtg4l3eg+toR+SHvk8H2k9wJ5daDKmdPdY5VWbMk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737490762; c=relaxed/simple;
	bh=4AElT7oiZQiL5FHTeRFDWFY8SRpCX+5hVSYbAg7hbzU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=e5gIJ6c/H/l5vy28tzoVKaZRD3pZus73nHGXIaAaKKfwl0E5oJDyyJVoCggDJSXVxCOn7kr/CHr/Lz3j01D7pAHttMigQ7Fyu9/wBylTnqlWCPuRwjT1wZZXX8ZkJdu01UnKWdDw1SR/kITajzwuUpg0xWgB83m5H9O1qMdjx8Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=VvGSh5Dc; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=was9b+eG; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50LJJotf018070;
	Tue, 21 Jan 2025 20:19:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=Gc08CMXJqvj3lfvDI1eoeVV8QeIFbMu7LX1NAoxDgH4=; b=
	VvGSh5DcYBp9+LZf0Wv5QX84i3wRFRSPSEVTvIIeuUowAFYCUEsjeKoH7fRRV8MI
	8o/aoXWHEF7+31/xHQg8hipvgljIjGHat180w9kMbSlZMo3hlVo10u2KbcXt+YJr
	2C1Kn52cx4t7+NrSnVETzawo4pqr0pz+wfCR0KMVOgTGBBn5mJNGPbK/Nz3cBiby
	ySUy0FAY7UEPaM73QnU1hSDddYvn4ex/jMAb2ZMyB5eQRFBbJxoH7YoV3B9z0HhC
	/hnsCrAdfVhgwb/J/avE+S5C/pypTD9hfxZQ2+QaVPtc9nfNMIwp0O1P5TMUOz1B
	uvJ89Kn8VRpBBUeHR1suaw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4485qkxgnn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Jan 2025 20:19:04 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50LIjkHZ030296;
	Tue, 21 Jan 2025 20:19:03 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4491fja2ha-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Jan 2025 20:19:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MovUPafYAC9FLKLtUMfdD4U03PGwkMtLyp5OwXbboicShOf4iMfqRW3AnapdNCZopUczD0UPbkK/Rig/UAUD3QfdnNHy+Xgo4dTCqxpLuI+Jz6xIfBNrAa7CsPN6nXA8KzVD6VRVKrAT+phJPbgDcKAe6vjyVMOXcrk89g/olTc45v3L1ZriFdkizxrfVi3QGk7s5vTdy4VxT0b8hxCuMcABwuC6EnV2ttFHJpB8wx5RrIkKalf6hVjrfXsTgudA46dE9V+wjp30T460O/YSeSFpISWYVZhHDb0nZ4p1u6ljy32djc/TnxUKJdxT0E60cGmvchjNWL5Q8WWr4YO13Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gc08CMXJqvj3lfvDI1eoeVV8QeIFbMu7LX1NAoxDgH4=;
 b=DiaEKqu5WeDAaHMGWKReqMJZf2iuikzdB88ZUCTp2zt51Z9Ujwsop4YRTRiVCMV03CTYXVcXPfSRJWyORJlICGULq2piedpFd2VrZyMwdCWbqG8lN//xpgaJJ9/5BDeSwXL/9QZv39jTPSszgMkD05butmzGbCHzOT96PyQsGkb2bNTElSZdPJdgP+n1mZIEYv025Tb9WYnMukPG0lrcohBflTN5sthQRxxzKc+gPeVGVs5/KyuutUFMQKmJu9CPtM720QOWCK+uQzmBVQm/busybB2gK7WOlWOlAXVx/uVut7aRx2Nldv3/ne6VPyk0rKJ35ADD3Goy21uvtbbMXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gc08CMXJqvj3lfvDI1eoeVV8QeIFbMu7LX1NAoxDgH4=;
 b=was9b+eGWA1/4VbSgmSnWFw9KpAbhM3Hx0vTAZg4zQYT7KF+8/G7GpH3/xzSS1gTStwnX7n7bHN5D9r6/KBnJ4JsJTw2pbVf3KkkzDuj+oNwPPaMKjWWf/6cnHB3mMyHIHqWF707aTi850Ubsz9iGy2PNs4WOuSyLG7QKsr35cg=
Received: from BN0PR10MB5030.namprd10.prod.outlook.com (2603:10b6:408:12a::18)
 by DM3PR10MB7972.namprd10.prod.outlook.com (2603:10b6:0:43::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8356.21; Tue, 21 Jan 2025 20:19:00 +0000
Received: from BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::44db:1978:3a20:4237]) by BN0PR10MB5030.namprd10.prod.outlook.com
 ([fe80::44db:1978:3a20:4237%5]) with mapi id 15.20.8356.020; Tue, 21 Jan 2025
 20:19:00 +0000
Message-ID: <cd8f0c33-1f26-48a5-a3d4-1d4ad4192160@oracle.com>
Date: Tue, 21 Jan 2025 20:18:55 +0000
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/1] KVM: Introduce KVM_EXIT_SNP_REQ_CERTS for SNP
 certificate-fetching
To: Melody Wang <huibo.wang@amd.com>, kvm@vger.kernel.org
Cc: linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson
 <seanjc@google.com>, roedel@suse.de,
        Tom Lendacky <thomas.lendacky@amd.com>, ashish.kalra@amd.com,
        pankaj.gupta@amd.com, dionnaglaze@google.com,
        Michael Roth <michael.roth@amd.com>
References: <20250120215818.522175-1-huibo.wang@amd.com>
 <20250120215818.522175-2-huibo.wang@amd.com>
Content-Language: en-US
From: Liam Merwick <liam.merwick@oracle.com>
In-Reply-To: <20250120215818.522175-2-huibo.wang@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0021.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ae::22) To BN0PR10MB5030.namprd10.prod.outlook.com
 (2603:10b6:408:12a::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN0PR10MB5030:EE_|DM3PR10MB7972:EE_
X-MS-Office365-Filtering-Correlation-Id: 371d5590-2fec-4ca1-5be2-08dd3a58d79d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|10070799003|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?OC9MazYrNnh1QWgrSXpteFZKd0NZVW1pc2lzR2p5eU1zdEhlRWVvNm5KMS9E?=
 =?utf-8?B?aTZBamtUMEdwNDREb3h4emd0TG95eHRwajdmNTl0UEs1Y0o1cjg3THhaOUlI?=
 =?utf-8?B?dHJhUURtNDM5ellqUTBxQ0dYSzVObUJaRHBHQ3o0aS84YzVROXdTNkYxWnRM?=
 =?utf-8?B?R2pkaU5rMVpiZS83RHhOZm1wYVkwSk14Mnp4UWhBcVczRmtURXJNNTlkVzVx?=
 =?utf-8?B?OWU0anNYa2Q2eE9nS2VkVTRrU1dMaENXQXkvc2hyQThKR2F4QWhWRzJaRlMz?=
 =?utf-8?B?VkRBcEt4akJXL0I0V1hpWGQ3N1FEdy9Tb1Q4OU1QM1ZqNWJ0S3E4a1NyYUtj?=
 =?utf-8?B?cWIxRitWL3RSanlUN1FZcXZqcGdEK2VxeGIvVWpWT3kveFRLaXVKTXBwRUpG?=
 =?utf-8?B?WWVxcjh2N2dHNzdicFMwSHlCMUhEeWpOMWEwdWZLT2JKTVI5ckxBM2RwaUx5?=
 =?utf-8?B?RlF2NmtlZ3BXZGtveURUNm5jL0VCTjBJOGtqWkZUVjlONzJCU3lKQTZPaysr?=
 =?utf-8?B?dkUrSk1xOWJkSVhna3d3QTI5TTdxa3VteXlKcDJhZ3F0Vk85MWdUVkNlVXlv?=
 =?utf-8?B?U0xseXpJYzB6d29GYktISFdEY0ZuaGxYNzF1WEV1QWhQUG05VGxQWm9rd0dB?=
 =?utf-8?B?S1F4a0g3bUpaYWtudExHQTRHTmpwVXB2REI5RWpnTGZjaTJ6bmNIL3pJZCtK?=
 =?utf-8?B?RlkyQ2M4UHRLbTY5TXV5d0x6NU1FYmgvOXpEMlZmUUhTYTRDWS9MdzIya3J1?=
 =?utf-8?B?dkxoMzFyOFBMZnRTcDJ6Z3d5MHdWNmw0WndiSjFvQmpzWEIrWXdEeFNTWEw4?=
 =?utf-8?B?Q3J0WTJ1bDZUNzdaWXdUajVEeHpvUE1sSGlaSXF6c2s0eE83SFFMOWhkOXVB?=
 =?utf-8?B?VDFtb3VLWnBHSlZnTzhpa0lZRldtU2VhWmJwV1NBQkZRQ2FneWVIOXNiN0Qz?=
 =?utf-8?B?b1piRUh2T1hMajJaaWdJTWpUQS85d2lyZ2F1QTlRWWdEWFhFalRsaUxsU2xk?=
 =?utf-8?B?eUo4eXlXK3RyeXlrVmF4Y2czWEV4MFYvWENaRkFUS2o1L2NqVlNtOTNIUlJw?=
 =?utf-8?B?TTZJYzhMbFR3WDhJY3E3anhNcXFUaDlSNVZVQ1pyZE1CVXhoMG9ud0xDZVdi?=
 =?utf-8?B?R0Fkb2FlYkV5VVlCNHpFRHd0Y1pLdHB6M25XZzFVLzlXZmczK2tvQjNVaHp3?=
 =?utf-8?B?ejRDYVV1MW9mSmFxWVRKYzJ0YWppaVcxSlJGVVZKeVlaM3JkMndiZHZERjFN?=
 =?utf-8?B?YzdxaENaeHhKMWp0aWd2cSttV2t5dDRsMWZpTE9jUGRrYjk4VDhYNVk1ZzdZ?=
 =?utf-8?B?dS9nbzlyV3E4cVhZcnJKb1UwaVA5bDgyUVpZdGgySGtIRW03RjRWdXFKN283?=
 =?utf-8?B?ekcyUVd2cGtwVDRXUHhTbkJVaHVHRGdVcVlEMVpHRWdGL0xqOXZEM2taMW5G?=
 =?utf-8?B?YW02WGpxOUNKbGl2R1MyMXBLN08xY2dYWktqYWNkb09FcWhHanVKbkUwa0Rh?=
 =?utf-8?B?Z2svVXAzN0ZVak82ZHJONFAzVEJLOWlaT0NPTXV0UytaR0x2Zjdobkpqbkpx?=
 =?utf-8?B?Wnl5ZlFVY0VqWk11RXVpZ1Urdy9OYWI0QkswV0VjS25mcmVIU25ORHJKeFJQ?=
 =?utf-8?B?cmUzS2tneXVHQ3NzWWtZdWk5eHNLdG1HTW9DNUlaVmM5MnJydStoU08zWGhU?=
 =?utf-8?B?ejBuOTA5alluZGREaDk0YzdsZ0cvOUNPMXdmU01vU1V3SG55UlJESWtYVjZP?=
 =?utf-8?B?cVVpT1hVb3lJNDBiSkJUMjNMeTM1c2FhaGFlRDhQcE9yZzZDS1pnZGZRVmxE?=
 =?utf-8?B?enQxQjNySHBINnFFTmdhK0NuUWtWdDJCOE9ZK2w2N0dJSjhsTmk4ZTVPbEQ0?=
 =?utf-8?Q?7BGs1nGNrxYKu?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5030.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(10070799003)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?STg0WDM4blpTKy9hUENva0tNc01zblRISXR2cEM2ZlVvMG9SWVRybXV2aEtE?=
 =?utf-8?B?YkJBa0xZYWNHVzZpZ0wyenZzbWdtQzl3V2xUM1dGaDBKaVo5eFQ3M0JTUjFB?=
 =?utf-8?B?OENzS3BFeGlqdGR1dDNBTTZNUE5RcTNVUjN1RWpoNG5uTFFVTzE4M0tsQkJ1?=
 =?utf-8?B?akk0OEZ4N0tGU1Yyc3ByRWJoczZPS3pBOGNtTkM3dDZkU2l4R1N1VjI1UnlO?=
 =?utf-8?B?Nlg1UXN5NjNwcXBkdVIxa0ZoQ3VSZ2J6bGlEK0d3TXJPRC90TlZlOVV6UkdX?=
 =?utf-8?B?bkNIR0JOVUwvdkZmdUFHaFh6ZGFnL1Vscm9oNERkSWtnRkM1UGJlbzZReXc0?=
 =?utf-8?B?UW5ZVU1GU3QrVWhDWERNSGJpREsrUEdnblhaNmlMT3hOVlM2NmpsUzlqR01r?=
 =?utf-8?B?VVdIRUFVdlQ0UVFwZTNpMmcyZng0L0Ixckpud0ZUUlpGSmgwOTJZVzFtV1ow?=
 =?utf-8?B?QlBpbGhzQlVjc09tY3VqaEpGaDgvcnByLzBKOU5ZZUZJMkJmOVIrd1l2UnNm?=
 =?utf-8?B?TjR6dkhkbmxRSlBUeEtLWEx5STMrcFg0Q0FibldNZ1FTZE5HR3oxa2ZTU3ZR?=
 =?utf-8?B?VFpkcHlzck9jSTNyejhRTElVbUVUTTlNY2FrbHgwa0lNY0pkRi9ZS09yNnV3?=
 =?utf-8?B?OExhZnhhaGVZdElJV29SMCt2OUVOemVZaE1OOWxmNHBWNmxBdTFrWnRGV1pZ?=
 =?utf-8?B?MUlHR1JsZ1JMektYYVA0S1c4a25MSW9GaG9iZ3B1OTJJWUJUTi9UcysrUWhs?=
 =?utf-8?B?bEJleGp5WWEwZFl3bm9vejNNUmR6RS9tWFcrenJtL1RSQzdxQWxCRVYyUThQ?=
 =?utf-8?B?VGhtK1FPWHBXVEppTmxObmFaSDFyU0U4KzdNSFZIQjhxN3RTUXNheU45dlQ5?=
 =?utf-8?B?RkdDRW82Z2IvWkVlNVZBRjFHeWVxZUFPeVFhMytSbFJTWS8rNmVydzJPaDZx?=
 =?utf-8?B?QnE5VVBSOGJyZXdLRUMzdkNUZmJBQlBPRTJ6cDk2YnNhVUIrSUZ1TUlBQ3VN?=
 =?utf-8?B?QXh4U01kdlQ5Umt1eVk5c1NDNS95NHByWDV4ckhyTElHOW05WjdXVEtmSURB?=
 =?utf-8?B?RTFOVXhETUxRTTkyU29uRm5GZDZWTGQzMTYycGEwSHRhN3R3YUJWZWRtL1Rx?=
 =?utf-8?B?MUdZVW9MWEd0SWYzR0Q0ZGpmTk1RT040TnoydGU5c3dsS0YyeW5GL0tjcW9X?=
 =?utf-8?B?dng4WjUrVmJSRVZqbjBmaGlRVzk1R1B4azJvT1VyZ2pLT21raDhRL1MzUTAy?=
 =?utf-8?B?djFYK2JnK3lwUU82d3pmMkF5RE45S0l2OHo3M3V5eUpYUEw3WGV1UWh2Z0Zz?=
 =?utf-8?B?MGFjLzlVN1ZJeEV5OXdaL3lzSHE5Z0dOZ0dmbkVvZ0RiNlVUTS96L2w4RTVp?=
 =?utf-8?B?dzF3cU5zL2IrN3YxS3VHQUY3cWpPWHpCVytvMkxUeXpseVdYTk42RTZNaVlj?=
 =?utf-8?B?aWxvTDhkSjM0K0RTeHo3ZWtJNlBRUktVWFhzUERPbG1RRW5za2UvdlFSTVk0?=
 =?utf-8?B?NTVDaEIvSnlQVEc4L0RpOFdiWnAvZHpURmw0K3ZnMXgrTWJQd1Qrb3dUb0wz?=
 =?utf-8?B?N2JOa29EdEg3eXg3c2tSNmpFL2Q5M2tjcVIrWU1rdzhoWGdCUHIzNDM2TmlE?=
 =?utf-8?B?YVdiYUxwU1p0aXdJQVU5d3ZFVTBLeXhMVFJhUXR4UW9STDZEa0JlZnNaU1d0?=
 =?utf-8?B?dTlieEoxTThGOEIvMmx5VXlQUjdzcnEraEpwcWRrbGkrNlpXemRTOXpTRUhL?=
 =?utf-8?B?QVk4cWRoK0NBQldGcllDV3ZpQjBzQjVueC9zOHBKajhncDJnbkRVWWNBU0VO?=
 =?utf-8?B?REFmdnlKL3NGekpVaVUzYTJtQ2gxeGFnV2hZcXJISlZyYVBpWE1PdmxWbEc5?=
 =?utf-8?B?R0dMcXpQcmlkN25TL25YYXNpVERUTTNvcHJWeFBMMmJqdm9XM21aRnZhWTdT?=
 =?utf-8?B?UDRVT1ljYTRTc0YwSHNSMTd1Y1RFaDhMQ1FTWm80Z09aUFZseFJVcjg4WURP?=
 =?utf-8?B?Qy8za1prbDdRcHh4VThWS3ExdEZvU0NxOGRSN1psSmZxNWEreVFhc2RxNHpo?=
 =?utf-8?B?cWtaKzJ2QmorbDZ0UkdOTHE2bzA3aXZsL2xtOGU0VVNDbWtJemhGd09lVzNm?=
 =?utf-8?B?K0MvbEVwd2FHOXJ1VWcyUlV3OEZUWHBoUTFMZWVKdVl2NkF5alY3QXZXTlph?=
 =?utf-8?Q?7w7fNel+/k8jPLIdNPIzY1k=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	tuUjv9tuCo2q7TGb+cFtxCePK+P8tCh3iKDqkHiqKgVXl1dSQbCkVZRqaaojrk3Goi1hyKj+jnWWirm0Qs6toBxI2X27FpPIaQUSeyxqdjP0hqIX4EUAC7iwW4hKfxMuipfNSHdrp8KbWDuzRdCqA4VCwWvlu9Y90kWJb+lKbJ2+MwEtmfccGa/7cPP3Gfa/hIdcPZQcXRf+5qjb7K6o65LpJzEOs4ByFEONoyKtgUa5YmQQ4DrAJPO0XWtpRYvnEnqJBtIzIKKmRXtKZvdvbn0FZsCWC/VUaqLCbNGPj7KfhXXBiqw7LdxecDcsSo2FQARxVBUyhL/4C7G02py3e+Dz4PjjC1bOFMscI5oKSoSHq7nfHDc2inM7qMCcVb3TnLQNxGVYLsl2Y0NBN6FOR96sGobWiHOaPS4pLWVkH4h0m3+ieT2ejSeQvrir9yqvCRpcYb0U750ozIVeqEz2dC30GUHSa6nnQNQiJ0LVgXronNsBPiZrXYn8/N368SBrqa6Id07lrI0YP7SZM5TtKnj9atKwnTm2wWHLpMXuGGsVW3O+WMMOIw51DloIX+8muEvFRz+IHVIqo8YU7CdrbYv6Nm1IBa8lzjO5Hk05D6I=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 371d5590-2fec-4ca1-5be2-08dd3a58d79d
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5030.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2025 20:19:00.7693
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: btju7bl67lD4GXEW9M36GTIh2GMPH1nkFKl2KldfpmTfQTkVZ1bjdwwAlLGZDOZArhQY3g+3yDf4GZn+J6IuXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR10MB7972
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-21_08,2025-01-21_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2501210162
X-Proofpoint-ORIG-GUID: zfdVVKST2_fUNE--nmL0Tg6MLVPCqbY1
X-Proofpoint-GUID: zfdVVKST2_fUNE--nmL0Tg6MLVPCqbY1



On 20/01/2025 21:58, Melody Wang wrote:
> From: Michael Roth <michael.roth@amd.com>
> 
> For SEV-SNP, the host can optionally provide a certificate table to the
> guest when it issues an attestation request to firmware (see GHCB 2.0
> specification regarding "SNP Extended Guest Requests"). This certificate
> table can then be used to verify the endorsement key used by firmware to
> sign the attestation report.
> 
> While it is possible for guests to obtain the certificates through other
> means, handling it via the host provides more flexibility in being able
> to keep the certificate data in sync with the endorsement key throughout
> host-side operations that might resulting in the endorsement key
> changing.
> 
> In the case of KVM, userspace will be responsible for fetching the
> certificate table and keeping it in sync with any modifications to the
> endorsement key by other userspace management tools. Define a new
> KVM_EXIT_SNP_REQ_CERTS event where userspace is provided with the GPA of
> the buffer the guest has provided as part of the attestation request so
> that userspace can write the certificate data into it while relying on
> filesystem-based locking to keep the certificates up-to-date relative to
> the endorsement keys installed/utilized by firmware at the time the
> certificates are fetched.
> 
> Also introduce a KVM_CAP_EXIT_SNP_REQ_CERTS capability to enable/disable
> the exit for cases where userspace does not support
> certificate-fetching, in which case KVM will fall back to returning an
> empty certificate table if the guest provides a buffer for it.
> 
>    [Melody: Update the documentation scheme about how file locking is
>    expected to happen.]
> 
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> Signed-off-by: Melody Wang <huibo.wang@amd.com>

Reviewed-by: Liam Merwick <liam.merwick@oracle.com>


> ---
>   Documentation/virt/kvm/api.rst  | 106 ++++++++++++++++++++++++++++++++
>   arch/x86/include/asm/kvm_host.h |   1 +
>   arch/x86/kvm/svm/sev.c          |  43 +++++++++++--
>   arch/x86/kvm/x86.c              |  11 ++++
>   include/uapi/linux/kvm.h        |  10 +++
>   include/uapi/linux/sev-guest.h  |   8 +++
>   6 files changed, 173 insertions(+), 6 deletions(-)
> 



