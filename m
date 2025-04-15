Return-Path: <kvm+bounces-43352-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D902A8A175
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 16:45:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0E8331798C4
	for <lists+kvm@lfdr.de>; Tue, 15 Apr 2025 14:45:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8B472973CD;
	Tue, 15 Apr 2025 14:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="ck5B1RLm";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="ouKku7h6"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB1AA2918DF;
	Tue, 15 Apr 2025 14:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744728296; cv=fail; b=RXmKaDQ21RKMoC+1L2p/jjDOzVPoQFPNAZTLsbsgaVDO857puVAk/SYzzzdipPd68GDHxYfrl2lY6NWx/cF1x0Gv14VyCYNz2rppOxaOXnRep6b8cbTZJ3p6Kc/1Spgva9AJCiPz2SJ3uTsr5KQTDUmSiSHJsfVFxpcl1naPZU4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744728296; c=relaxed/simple;
	bh=DW7Rq8zoN0ttMh3/pt6lcKFQdzpo7e4QFFDTgASAml0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IxRydClTdrZCN2qpTdPEeLDFIdaMZNqckJiFeoWNy2MeFOsEuhno7yJCKGxVwSAjibSRg4BlTdGyc8cHVWhyuz1Y14KlTY/B2H0KVo8VXstD6BkUvOc1cWDd2cxKXeX9GUfgVQykp48P0ns8MWwV49PMuIAEwjKbhKfaJ08ggIs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=ck5B1RLm; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=ouKku7h6; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53FBUJFV028265;
	Tue, 15 Apr 2025 07:44:01 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=DW7Rq8zoN0ttMh3/pt6lcKFQdzpo7e4QFFDTgASAm
	l0=; b=ck5B1RLmX1A8CKMVlaQBE2VjYWGMsJ0F90iHes7iTIKoYYxRYG6ppPNI4
	KO9m/wVlNagpySYbBXpk86iIFAIi35qw9IC8tEaMzgRrqPjiVwdrfP4qvqXdvWny
	grjWr3P8eOTwKp4ixBZLyScctYaz+sgpGch7f929Mf1Kt2VwzKCDdXaXSx5G6xzN
	a4gR93P5JZj5UpM0V7WK56EnTlBptV8prsPTdJBUOanC4T5zGpywYg/mmjdp8riH
	k/r91KcRVWj2sEvkJvbrPPVDEwjpruOnDFcNUoK3ZW9tzZS13aF16eu9YA5GVxzt
	4mDgKyHni2+5aW4mBTVLORWuZ51KA==
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2040.outbound.protection.outlook.com [104.47.70.40])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 45yq8gx4nr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Apr 2025 07:44:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MHF7Bxkv8Ls8fs19hbYYUdW4MT9ETYiXPC7yK4BrB8cvQe/uw/iB5hz3k2dplVF95PNL1dNpBTZVhEJOdR0yz0ZBwJNEKmiLRpCZjZj0nSvpE5Bc88iACideoO8gouUhIvQ7HFXCMh+y53oDRmexZrnfvqGhKg75otfgZlS8Fk3Ps7Xfec4K/E2QXyTa/zSWCeMqxg9PUVVqkpiFdyQF30S0ER9cwqlObwSFuy40X9x5NQdzEg47ijmJHik6qsZk979Yas5vVM+p2UnwY9/zdDMv2KdiHT4xuFH2lBMffUH8gDYUSPwnm2xXZMBnOAra05/KFYBNxGQYTDeDs4ihAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DW7Rq8zoN0ttMh3/pt6lcKFQdzpo7e4QFFDTgASAml0=;
 b=NaD+dB5k9D40FxoZ47jdN2WmBxwrF/GvfRdVNacGFcAL5FNnMMjhU5c2YjE2Jksb64h8NcWg6OmWTFVlNGjWOR7axQsCIwOx2NEjWiiZ0G8teM3xIk3sd/zPVECfwVYHmg2lKyFAolSIRvSYOuJoyIxcw/U4KXXVvQCfs8/jafxdxA7jjGIqR/IOkblJTJPT3MvYF7Yq1uyYXeQg/T9tB/YWCnGj7l58UhW9RFCLnIplTqqUhECAI6o12qn8b2rel9B+Fq+WzfHNb0pqWoasqqSjmnfBWVyA9wW10O6rB2xcwi7vJnSG74boE+Yesl/JlWjGUsNbrZWN5FlSQekg7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DW7Rq8zoN0ttMh3/pt6lcKFQdzpo7e4QFFDTgASAml0=;
 b=ouKku7h6PfmZ7g9YG2rKmPp3vmVdlp3+jKOB/W0nL8D/RMfCaoOjcmGfepPQjMw5msa1xfhkEVgGU4aN5VLSPhDCGbOni6/OEWndqPVVQrBQW3SysoPKsZYmXfYSW2wSxnOZjIuOuFbNzkSlxiV/2feUVs0EUWPz/DAJf7W4MfBAWbXJqsJSsLgdslJFxnIV+nloNLvBBvtHlzAjUj9hOj/g/uP0MnYTv/Wd4tT534EN8CyZbX/hBv1Mq1EPXAJslH3nUhEPW+HyU8OiuI3JGcu2J8eXu79t3CbSqYKT70BkQs7JMSrFOe4F0WxagZHsdbiXQIuU1AyqJTA3ztdD/Q==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by MW4PR02MB7298.namprd02.prod.outlook.com
 (2603:10b6:303:73::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.32; Tue, 15 Apr
 2025 14:43:58 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%4]) with mapi id 15.20.8632.025; Tue, 15 Apr 2025
 14:43:57 +0000
From: Jon Kohler <jon@nutanix.com>
To: =?utf-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
CC: Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini
	<pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org"
	<x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
        Alexander Grest
	<Alexander.Grest@microsoft.com>,
        Nicolas Saenz Julienne <nsaenz@amazon.es>,
        "Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>,
        Tao Su
	<tao1.su@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
        Zhao Liu
	<zhao1.liu@intel.com>
Subject: Re: [RFC PATCH 00/18] KVM: VMX: Introduce Intel Mode-Based Execute
 Control (MBEC)
Thread-Topic: [RFC PATCH 00/18] KVM: VMX: Introduce Intel Mode-Based Execute
 Control (MBEC)
Thread-Index: AQHblFPgL0brNbuxF0+4/LV272jmjbOkqSgAgABKEgA=
Date: Tue, 15 Apr 2025 14:43:57 +0000
Message-ID: <A32D3985-4F3E-4839-BF1D-5674DE372741@nutanix.com>
References: <20250313203702.575156-1-jon@nutanix.com>
 <20250415.AegioKi3ioda@digikod.net>
In-Reply-To: <20250415.AegioKi3ioda@digikod.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.400.131.1.6)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV8PR02MB10287:EE_|MW4PR02MB7298:EE_
x-ms-office365-filtering-correlation-id: 9c69524a-9550-4b80-5156-08dd7c2bf3c7
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|7416014|1800799024|10070799003|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?MXo1MXUvaHZxcGlKTWlSM2YxVnpWS1V5OUVxWFJHN2Z0YjVQTmdkUTVRenBT?=
 =?utf-8?B?UFh1SjVBRlNxNzRKa2I1RFdYamVqVFR0NlNRcWtxQ1haS29sTGtZM2QyRnF2?=
 =?utf-8?B?WE5MeUpFOHREMDFOc2w5T2FKSEszWWdhZHErbkdKWWF0WDFLQXdqWmpjdC9i?=
 =?utf-8?B?VkZURzlpTjJhaUdKWVk5T0FmbW5jNTJqWHlKTXlQcmhDOFJQcDE2WEFCV1dx?=
 =?utf-8?B?aW1UYjZhVElWOERnY0syWFZkWm5DYWZZNHF0Wlc5QUVpVy9rbWpCTjkwWTA2?=
 =?utf-8?B?RHF2UjZ3QVc3Ulo3NXRnQmRFcmhUTUt2S2RvbVc2S0NpMElsRGFUWWY2UUlS?=
 =?utf-8?B?bXU5MUc2SHFFK3FRZzlycnlheWljQ0FYSUJFRUt4TmZWN0NZcDNGU0VuWEhi?=
 =?utf-8?B?bTRndXB1YUV1YUlBWU52ZE9meTkrSmxaZjIvNTljbVMwT2RhNmovUC92OUFW?=
 =?utf-8?B?cDhKZ1ltcmZWdzVSUXNEQ2lPQnJyL3ZzekU5Z0lCWHRDSHZ1a09KcThXeVNz?=
 =?utf-8?B?M1o0QUJQQ0IzZCtJeGg4QnFCZ001OTV1ZDZ0RjdWdytNTXE0MjBzQ1NUU2w3?=
 =?utf-8?B?dEtFbko4NzEzcEJxMFlJdkRacnB2SXJWMk1XL3l6dE53bUp4VEZNaEJTRFdJ?=
 =?utf-8?B?NHVndk1OeEhnUkpzUnZMTU4rd3BOREtpUmtVVTZuTmQvR2g4b3JoS1JDdC8v?=
 =?utf-8?B?OURKdzVObG5RcmRncTZhMHhwakpTZWF3S1NHRkt2cWc5WExmZ2c1UFpEZ3pU?=
 =?utf-8?B?UUQ5WlVBeGtRM3hyTHlhbWhLZ0RNTjFEQmxJaS9acFlLK1EzVzUzRnZUdHdC?=
 =?utf-8?B?WXBEU2xoTWY2ZURUN1FkbTMyMVVzc25UcURRZnBpUG92VlNhU1g1L3RzNnlV?=
 =?utf-8?B?ZFpNaVIzeTJJRFF1TW95SWIxNTFidWRFdW0zT0gzaC9xcWQ3V2xuMk1nK2hM?=
 =?utf-8?B?MktGQlhqVkZ2ckw3SXlHZFRrVHpWZ2FDYVdpMHFyQ2tXY0Z2c2dMMzVsVkdI?=
 =?utf-8?B?REl6dXVBWTdrYS9xMW1XS25ERHhQYzJCUWVsSFBjaDVYTGtmMFQwWDlKS0Nj?=
 =?utf-8?B?WUFVMXRDZERyNmV0QkszeXdKTzRudlgzTzlFeGhxV1hnL2NBNTNnZFh6cC83?=
 =?utf-8?B?WURIVndrQmF2clhkYzdXVnBSYUZzbG01cGdiSGFjMWtIMmhIUytCdmloTEs2?=
 =?utf-8?B?andFemUzTit1WFhuY01KRW5BcnlnbDBPNkxjQjdXT3Z1VVFFRGtoTTJ0Rzlk?=
 =?utf-8?B?SzNDSzdKUVRCeUhIc1BYUzBYVkRZa1dTTHk4MmQ5dnduKzE2VHA2TXFzaWhn?=
 =?utf-8?B?QUwwclhkRzdERTg4SFhCSFhnSHpVaHVRN1hlVUNNK3ZjTllLOUZZOEM4ZnQ2?=
 =?utf-8?B?TXcwVFB1WmdXMWdwN0RZVE43aEc4cVc5R2Z2YWJ4akNUMklaajJ2blQ5d1NL?=
 =?utf-8?B?SHduRFN1MjNaU2RMcUU0TXp4QnVCSGVsZWtEY2tLMjFpdk56VjcrbGtrb2Fj?=
 =?utf-8?B?cTVTVkhITCtOd0pTVlVJS3dWT2JXdllUZGhiWXRsdFBXbkZtVHVISGZxVTRr?=
 =?utf-8?B?MUpVcHdxckZucUxRaWE5MWVoM2FTM085TnFkT3l1Y0lEL0FtVW9sZG9HQXls?=
 =?utf-8?B?ZVJkQXFWRGk5Mi9rQitnNWtEZ1dhUmVmL2NXNjYwNWp0d0RhcWtxRDQwdis2?=
 =?utf-8?B?R2x2V2F5TjJyZjhYSk9SNlRkOXVRbUp4V0J3aXhiRk9kSUk4S0RtZ3djaXVE?=
 =?utf-8?B?R2FSeVUrbDN1MHA0THdCcHA3QmlLblpyNGVLUitlcUFDaDl1emN2YitLL0t3?=
 =?utf-8?B?N0FraFNrUGU0bGdxS0kvWmNLc3JHQTMwUXZRUHVNM01CM1JZbjE3b3BUN2FH?=
 =?utf-8?B?SGlENE0xNWxOSW5sRXgvOWJNdTQrNW13M0YvQ09qODUxeC9nSGxWY3lHQVQz?=
 =?utf-8?Q?Rbmxb5D1CFY=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(10070799003)(366016)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?T3dSaWhXaGJKZVRaT1kzWkhMK0JRNy8zUEYzNWsrV3NucE82UjVJZ0h2ai81?=
 =?utf-8?B?V0ljeFd1NndEN1pGUjJCbmRqVmdUQU01RktESFN3dEFabkV4V3hhZkVSQUpI?=
 =?utf-8?B?LzlnbmRlOUFIQjk4dkduRHBialNOb3hwd0R0OWw2Rit6RUFHb1FnYTZwV1px?=
 =?utf-8?B?UXYrRlpIZDZNNk1DaHhBYmlnREg5MHdkcU5DSmFxditoRnJHeW15UDJya05X?=
 =?utf-8?B?ZTVETjZJNktFa3FOdXh2RkV5UDRkTWhGMlZIUllMMWFZNi9BVmNMY1huamZ3?=
 =?utf-8?B?aUdpYUt4NzFHWFNvZEc0cXo2YmcvdHM5ZjBmTVNnWktXcEZJTUZzMERFYnBy?=
 =?utf-8?B?S2ZKZ3JMNmVDZnVxalhReGE2S2RCZlBJcVE5QW5sNnJMTy9oVmp2aHdqQnVZ?=
 =?utf-8?B?d1Jsc0g3bHZxemdma0w4NHVBTnQ2bnA1YzF2d1RWcjFVWHZHbkZRRTJvRjR5?=
 =?utf-8?B?WlRsdlJnR3RlRFBnQWs3NHpUWHk3cDk4V29yVzkrc2dWNDFGY1V6clJIYkgy?=
 =?utf-8?B?cmhRR1d0N21qMTVhZlNOcFBiYXhvSERvSFcrZmJ6SXJOYWY4ZDFqQWJvQjVw?=
 =?utf-8?B?Y1pkS0xYTEc1SnJnbDk4WXBaei9rTmpmQU9zOXN3TmdYbHozcnROWng3cHhZ?=
 =?utf-8?B?TFBsSjhmMStraGRWUEhEbGJxNlJSM1NLd1lYVEMva3dQYlRQSzFsVzJ3MFd0?=
 =?utf-8?B?ODlFMXZmdTBaRU1VVkV1K2Fpd0lSNnZ6di8rU2RyQ2hZaEJYbk80anRhQitj?=
 =?utf-8?B?NSt1STJNNXZHSFVyR0JPZitKSFpqYzNCNzN4elZKdjN0OWtsYjlBN3ZEeVkr?=
 =?utf-8?B?OWF4VEpJcmxiM3R4by9PRzNRRmV1KzNhUzlOWVFaR0ZDeVBlMHNaK1pFTWE5?=
 =?utf-8?B?L0dXNEtkYnZtMTg0ODRXNWdnUU1oVHBJTDhUK2NTWVlBc2oxRU93YTVSVXNq?=
 =?utf-8?B?VWpuY2JDUERiT05WZ0h1YjcxYURpQkZsZTN3YTkzSXgyVkM4bDBnRnk3NFF3?=
 =?utf-8?B?ZHF6b1J6SkpHUE9YRjFnSHp2NEJJVTBmS29XRzM2WGRPRlFRbEhIclVNQXJ6?=
 =?utf-8?B?LzVncHlJV3prdTBGdmdFSVZZUGRFWUZXUVZJY21ic1haMnd5TFFXc2gzcm1G?=
 =?utf-8?B?cVN4UWlNMGc3UWQzaG1qV1ZIMkpCRkFoVEZnK3liNzcveTZOVVBDMnNnUk9V?=
 =?utf-8?B?S3lIbloyaW5vR01YQTZDVHZNUjZLTVJlVUNwdlBjNU9ZbFJValYyVTBBTkpo?=
 =?utf-8?B?L1lwdDI2Zy9ROVVvcUo0NlNRaVJiaTdOa0h1YjM5OUw3YTdGaTlRTmdzNHpX?=
 =?utf-8?B?RXF2aE9HcS92K0RFTGIzaCtrN0RTM1lCM0dGZFRHQVBqQ3gzYUdmNlFYUWcw?=
 =?utf-8?B?VlBBYTZLOHFOMUpaM1ZHYS9xcDlPbUpCVjFKRFJXU1pnWUo3VGwyYzhWVFBJ?=
 =?utf-8?B?dUtrdnQ3bnFHcFJONEpTaHdwZ1g0a09FOGNoLzdRaDc0N2hGdU5rTStXcC9P?=
 =?utf-8?B?Q0FwdFJPZkRpa282Z0YzQlFocUtrUlJyY1U1MzhrbFVCOHp6RzRERWtCc2VM?=
 =?utf-8?B?aXNGNndub0VsZnpPM2VoRGtrcWYrTUVWelhlemd2bHR4TlpNblVIREVudHpT?=
 =?utf-8?B?L0tCUnUwU2U3ZEl4TW13UXE3dFNkYnBTc291ei8vSkhDWVFoYzdDZHRNZ0Zx?=
 =?utf-8?B?WFdGMXZ2V3UyaEIrSHRLa0dCZWExdmo4aVl2akdWbGNneVRuR3hHN1pEVVdi?=
 =?utf-8?B?SHAvTTV2a2VBTkE0dm96eEJqdURRR1c2TXRZL1M2ZnRIUld6S1A0aFFJcUcv?=
 =?utf-8?B?TUErWU9UZWk1bXBOYmNGdDdFdFNqTFQ1WGZXOWNsWmE0bExTbEs5ODN6WW5G?=
 =?utf-8?B?Vk9ZNHNGTkNDRFJuUXRWbDM1VGpRQy8wTkw1Tlk4UUZHRmtnTFQzYUNjSExH?=
 =?utf-8?B?WHZ5K3RBeitrQmN4cytDQVc0TktQRlNpcHVDeGJ5djBZV0o0Ti96VDlVT2Rr?=
 =?utf-8?B?WWZqbkNTdHNwUldwVGxuWnpRVE1SK2xhVG1yRGhIb1BIYktUend6S1dJSjZ6?=
 =?utf-8?B?VnYyL243Q1FmTXNRaG5EU3VtNXRxQWJjSXpLeWVzOW1oaFhvajNsYmJWanVu?=
 =?utf-8?B?UnMvbndtQVZRc2g4aU5EQjA3VzRvaUMyeHI5WHh4M1pEcDY1TTh0a3czRXNh?=
 =?utf-8?B?WHVibzlJclBvQ2VKUjdMR1d2ZGhYZjVHOUt4SXVkTGx0WU82OGZycC9Fb1Vl?=
 =?utf-8?B?bGlMTG5tTUh2cmhUT3puNTk4a1F3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8A24A81BE89C6A4F948C3581A30CECC5@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV8PR02MB10287.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c69524a-9550-4b80-5156-08dd7c2bf3c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2025 14:43:57.1265
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8wjKf3uHwcBS6MUzQE/QuurLWVwjuForohP9AOoG9n/5Vh71BBsVKvWIjBngvpi8ZmD6+XMoPvLHtO2bmqmNB/KG2KAEvkHoueCAYlFHlfE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR02MB7298
X-Proofpoint-GUID: euKC619rrTGJu3UsLgkR_-5lCKjSqXPR
X-Authority-Analysis: v=2.4 cv=ctqbk04i c=1 sm=1 tr=0 ts=67fe70b1 cx=c_pps a=bqH6H/OQt14Rv/FmpY1ebg==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=XR8D0OoHHMoA:10 a=0kUYKlekyDsA:10 a=NEAV23lmAAAA:8 a=yMhMjlubAAAA:8 a=VwQbUJbxAAAA:8 a=edGIuiaXAAAA:8 a=QyXUC8HyAAAA:8 a=ko1A9RK8ad4ogYjyhvsA:9 a=QEXdDO2ut3YA:10 a=4kyDAASA-Eebq_PzFVE6:22
X-Proofpoint-ORIG-GUID: euKC619rrTGJu3UsLgkR_-5lCKjSqXPR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-15_06,2025-04-15_01,2024-11-22_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gQXByIDE1LCAyMDI1LCBhdCA1OjI54oCvQU0sIE1pY2thw6tsIFNhbGHDvG4gPG1p
Y0BkaWdpa29kLm5ldD4gd3JvdGU6DQo+IA0KPiAhLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLXwNCj4gIENBVVRJT046IEV4
dGVybmFsIEVtYWlsDQo+IA0KPiB8LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLSENCj4gDQo+IEhpLA0KPiANCj4gVGhpcyBz
ZXJpZXMgbG9va3MgZ29vZCwganVzdCBzb21lIGlubGluZWQgcXVlc3Rpb25zLg0KDQpSRSBJbmxp
bmVkIHF1ZXN0aW9ucyAtIERpZCB5b3Ugc2VuZCB0aG9zZSBlbHNld2hlcmU/IEkgZGlkbuKAmXQN
CnNlZSBhbnkgb3RoZXJzIGluIG15IGluYm94LCBub3Igb24gbG9yZS4NCg0KPiBTZWFuLCBQYW9s
bywgd2hhdCBkbyB5b3UgdGhpbms/DQo+IA0KPiBKb24sIHdoYXQgaXMgdGhlIHN0YXR1cyBvZiB0
aGUgUUVNVSBwYXRjaGVzPw0KDQpJIHdhcyB3YWl0aW5nIGZvciBjb21tZW50cyBoZXJlIGJlZm9y
ZSBzZW5kaW5nIHRvIG1haWxpbmcgbGlzdCwgYnV0DQpJIGRpZCBwb3N0IGEgbGluayB0byB0aGUg
dHJlZSBpbiB0aGUgY292ZXIgbGV0dGVyLiBUaGUgYWN0dWFsIGNvbW1pdCBpdHNlbGYNCmlzIHdp
Y2tlZCB0cml2aWFsLCBzbyBrbm9jayBvbiB3b29kLCBJ4oCZZCBpbWFnaW5lIHRoYXQgd291bGQg
YmUgdGhlIGVhc2llc3QNCnBhcnQgb2YgdGhpcyBlbmRlYXZvci4NCg0KV291bGQgeW91IHN1Z2dl
c3QgSSBzZW50IHRob3NlIHRvIFFFTVUgbWFpbGluZyBsaXN0IG5vdywgd2hpbGUga2VybmVsIHNp
ZGUNCmlzIHN0aWxsIGluIFJGQz8gSGFwcHkgdG8gZG8gc28gaWYgdGhhdCBtYWtlcyBzZW5zZS4N
Cg0KaHR0cHM6Ly9naXRodWIuY29tL0pvbktvaGxlci9xZW11L2NvbW1pdC83YTI0NTQxNGEwMTM4
YjgzY2FiY2I4MDlmNTU4NWVmOGI1Zjc4NTUzDQoNCj4gUmVnYXJkcywNCj4gTWlja2HDq2wNCj4g
DQo+IE9uIFRodSwgTWFyIDEzLCAyMDI1IGF0IDAxOjM2OjM5UE0gLTA3MDAsIEpvbiBLb2hsZXIg
d3JvdGU6DQo+PiAjIyBTdW1tYXJ5DQo+PiBUaGlzIHNlcmllcyBpbnRyb2R1Y2VzIHN1cHBvcnQg
Zm9yIEludGVsIE1vZGUtQmFzZWQgRXhlY3V0ZSBDb250cm9sDQo+PiAoTUJFQykgdG8gS1ZNIGFu
ZCBuZXN0ZWQgVk1YIHZpcnR1YWxpemF0aW9uLCBhaW1pbmcgdG8gc2lnbmlmaWNhbnRseQ0KPj4g
cmVkdWNlIFZNZXhpdHMgYW5kIGltcHJvdmUgcGVyZm9ybWFuY2UgZm9yIFdpbmRvd3MgZ3Vlc3Rz
IHJ1bm5pbmcgd2l0aA0KPj4gSHlwZXJ2aXNvci1Qcm90ZWN0ZWQgQ29kZSBJbnRlZ3JpdHkgKEhW
Q0kpLg0KPj4gDQo+PiAjIyBXaGF0Pw0KPj4gSW50ZWwgTUJFQyBpcyBhIGhhcmR3YXJlIGZlYXR1
cmUsIGludHJvZHVjZWQgaW4gdGhlIEthYnlsYWtlDQo+PiBnZW5lcmF0aW9uLCB0aGF0IGFsbG93
cyBmb3IgbW9yZSBncmFudWxhciBjb250cm9sIG92ZXIgZXhlY3V0aW9uDQo+PiBwZXJtaXNzaW9u
cy4gTUJFQyBlbmFibGVzIHRoZSBzZXBhcmF0aW9uIGFuZCB0cmFja2luZyBvZiBleGVjdXRpb24N
Cj4+IHBlcm1pc3Npb25zIGZvciBzdXBlcnZpc29yIChrZXJuZWwpIGFuZCB1c2VyLW1vZGUgY29k
ZS4gSXQgaXMgdXNlZCBhcw0KPj4gYW4gYWNjZWxlcmF0b3IgZm9yIE1pY3Jvc29mdCdzIE1lbW9y
eSBJbnRlZ3JpdHkgWzFdIChhbHNvIGtub3duIGFzDQo+PiBoeXBlcnZpc29yLXByb3RlY3RlZCBj
b2RlIGludGVncml0eSBvciBIVkNJKS4NCj4+IA0KPj4gIyMgV2h5Pw0KPj4gVGhlIHByaW1hcnkg
cmVhc29uIGZvciB0aGlzIGZlYXR1cmUgaXMgcGVyZm9ybWFuY2UuDQo+PiANCj4+IFdpdGhvdXQg
aGFyZHdhcmUtbGV2ZWwgTUJFQywgZW5hYmxpbmcgV2luZG93cyBIVkNJIHJ1bnMgYSAnc29mdHdh
cmUNCj4+IE1CRUMnIGtub3duIGFzIFJlc3RyaWN0ZWQgVXNlciBNb2RlLCB3aGljaCBpbXBvc2Vz
IGEgcnVudGltZSBvdmVyaGVhZA0KPj4gZHVlIHRvIGluY3JlYXNlZCBzdGF0ZSB0cmFuc2l0aW9u
cyBiZXR3ZWVuIHRoZSBndWVzdCdzIEwyIHJvb3QNCj4+IHBhcnRpdGlvbiBhbmQgdGhlIEwyIHNl
Y3VyZSBwYXJ0aXRpb24gZm9yIHJ1bm5pbmcga2VybmVsIG1vZGUgY29kZQ0KPj4gaW50ZWdyaXR5
IG9wZXJhdGlvbnMuDQo+PiANCj4+IEluIHByYWN0aWNlLCB0aGlzIHJlc3VsdHMgaW4gYSBzaWdu
aWZpY2FudCBudW1iZXIgb2YgZXhpdHMuIEZvcg0KPj4gZXhhbXBsZSwgcGxheWluZyBhIFlvdVR1
YmUgdmlkZW8gd2l0aGluIHRoZSBFZGdlIEJyb3dzZXIgcHJvZHVjZXMNCj4+IHJvdWdobHkgMS4y
IG1pbGxpb24gVk1leGl0cy9zZWNvbmQgYWNyb3NzIGFuIDggdkNQVSBXaW5kb3dzIDExIGd1ZXN0
Lg0KPj4gDQo+PiBNb3N0IG9mIHRoZXNlIGV4aXRzIGFyZSBWTVJFQUQvVk1XUklURSBvcGVyYXRp
b25zLCB3aGljaCBjYW4gYmUNCj4+IGVtdWxhdGVkIHdpdGggRW5saWdodGVuZWQgVk1DUyAoZVZN
Q1MpLiBIb3dldmVyLCBldmVuIHdpdGggZVZNQ1MsIHRoaXMNCj4+IGNvbmZpZ3VyYXRpb24gc3Rp
bGwgcHJvZHVjZXMgYXJvdW5kIDIwMCwwMDAgVk1leGl0cy9zZWNvbmQuDQo+PiANCj4+IFdpdGgg
TUJFQyBleHBvc2VkIHRvIHRoZSBMMSBXaW5kb3dzIEh5cGVydmlzb3IsIHRoZSBzYW1lIHNjZW5h
cmlvDQo+PiByZXN1bHRzIGluIGFwcHJveGltYXRlbHkgNTAsMDAwIFZNZXhpdHMvc2Vjb25kLCBh
ICoyNHgqIHJlZHVjdGlvbiBmcm9tDQo+PiB0aGUgYmFzZWxpbmUuDQo+PiANCj4+IE5vdCBhIHR5
cG8sIDI0eCByZWR1Y3Rpb24gaW4gVk1leGl0cy4NCj4+IA0KPj4gIyMgSG93Pw0KPj4gVGhpcyBz
ZXJpZXMgaW1wbGVtZW50cyBjb3JlIEtWTSBzdXBwb3J0IGZvciBleHBvc2luZyB0aGUgTUJFQyBi
aXQgaW4NCj4+IHNlY29uZGFyeSBleGVjdXRpb24gY29udHJvbHMgKGJpdCAyMikgdG8gTDEgYW5k
IEwyLCBiYXNlZCBvbg0KPj4gY29uZmlndXJhdGlvbiBmcm9tIHVzZXIgc3BhY2UgYW5kIGEgbW9k
dWxlIHBhcmFtZXRlcg0KPj4gJ2VuYWJsZV9wdF9ndWVzdF9leGVjX2NvbnRyb2wnLiBUaGUgaW5z
cGlyYXRpb24gZm9yIHRoaXMgc2VyaWVzDQo+PiBzdGFydGVkIHdpdGggTWlja2HDq2wncyBzZXJp
ZXMgZm9yIEhla2kgWzNdLCB3aGVyZSB3ZSd2ZSBleHRyYWN0ZWQsDQo+PiByZWZhY3RvcmVkLCBh
bmQgZXh0ZW5kZWQgdGhlIE1CRUMtc3BlY2lmaWMgdXNlIGNhc2UgdG8gYmUNCj4+IGdlbmVyYWwt
cHVycG9zZS4NCj4+IA0KPj4gTUJFQywgd2hpY2ggYXBwZWFycyBpbiBMaW51eCAvcHJvYy9jcHVp
bmZvIGFzIGVwdF9tb2RlX2Jhc2VkX2V4ZWMsDQo+PiBzcGxpdHMgdGhlIEVQVCBleGVjIGJpdCAo
Yml0IDIgaW4gUFRFKSBpbnRvIHR3byBiaXRzLiBXaGVuIHNlY29uZGFyeQ0KPj4gZXhlY3V0aW9u
IGNvbnRyb2wgYml0IDIyIGlzIHNldCwgUFRFIGJpdCAyIHJlZmxlY3RzIHN1cGVydmlzb3IgbW9k
ZQ0KPj4gZXhlY3V0YWJsZSwgYW5kIFBURSBiaXQgMTAgcmVmbGVjdHMgdXNlciBtb2RlIGV4ZWN1
dGFibGUuDQo+PiANCj4+IFRoZSBzZW1hbnRpY3MgZm9yIEVQVCB2aW9sYXRpb24gcXVhbGlmaWNh
dGlvbnMgYWxzbyBjaGFuZ2Ugd2hlbiBNQkVDDQo+PiBpcyBlbmFibGVkLCB3aXRoIGJpdCA1IHJl
ZmxlY3Rpbmcgc3VwZXJ2aXNvci9rZXJuZWwgbW9kZSBleGVjdXRlDQo+PiBwZXJtaXNzaW9ucyBh
bmQgYml0IDYgcmVmbGVjdGluZyB1c2VyIG1vZGUgZXhlY3V0ZSBwZXJtaXNzaW9ucy4NCj4+IFRo
aXMgdWx0aW1hdGVseSBzZXJ2ZXMgdG8gZXhwb3NlIHRoaXMgZmVhdHVyZSB0byB0aGUgTDEgaHlw
ZXJ2aXNvciwNCj4+IHdoaWNoIGNvbnN1bWVzIE1CRUMgYW5kIGluZm9ybXMgdGhlIEwyIHBhcnRp
dGlvbnMgbm90IHRvIHVzZSB0aGUNCj4+IHNvZnR3YXJlIE1CRUMgYnkgcmVtb3ZpbmcgYml0IDE0
IGluIDB4NDAwMDAwMDQgRUFYIFs0XS4NCj4+IA0KPj4gIyMgV2hlcmU/DQo+PiBFbmFibGVtZW50
IHNwYW5zIGJvdGggVk1YIGNvZGUgYW5kIE1NVSBjb2RlIHRvIHRlYWNoIHRoZSBzaGFkb3cgTU1V
DQo+PiBhYm91dCB0aGUgZGlmZmVyZW50IGV4ZWN1dGlvbiBtb2RlcywgYXMgd2VsbCBhcyB1c2Vy
IHNwYWNlIFZNTSB0byBwYXNzDQo+PiBzZWNvbmRhcnkgZXhlY3V0aW9uIGNvbnRyb2wgYml0IDIy
LiBBIHBhdGNoIGZvciBRRU1VIGVuYWJsZW1lbnQgaXMNCj4+IGF2YWlsYWJsZSBbNV0uDQo+PiAN
Cj4+ICMjIFRlc3RpbmcNCj4+IEluaXRpYWwgdGVzdGluZyBoYXMgYmVlbiBvbiBkb25lIG9uIDYu
MTItYmFzZWQgY29kZSB3aXRoOg0KPj4gIEd1ZXN0cw0KPj4gICAgLSBXaW5kb3dzIDExIDI0SDIg
MjYxMDAuMjg5NA0KPj4gICAgLSBXaW5kb3dzIFNlcnZlciAyMDI1IDI0SDIgMjYxMDAuMjg5NA0K
Pj4gICAgLSBXaW5kb3dzIFNlcnZlciAyMDIyIFcxSDIgMjAzNDguODI1DQo+PiAgUHJvY2Vzc29y
czoNCj4+ICAgIC0gSW50ZWwgU2t5bGFrZSA2MTU0DQo+PiAgICAtIEludGVsIFNhcHBoaXJlIFJh
cGlkcyA2NDQ0WQ0KPj4gDQo+PiAjIyBBY2tub3dsZWRnZW1lbnRzDQo+PiBTcGVjaWFsIHRoYW5r
cyB0byBhbGwgY29udHJpYnV0b3JzIGFuZCByZXZpZXdlcnMgd2hvIGhhdmUgcHJvdmlkZWQNCj4+
IHZhbHVhYmxlIGZlZWRiYWNrIGFuZCBzdXBwb3J0IGZvciB0aGlzIHBhdGNoIHNlcmllcy4NCj4+
IA0KPj4gWzFdIGh0dHBzOi8vdXJsZGVmZW5zZS5wcm9vZnBvaW50LmNvbS92Mi91cmw/dT1odHRw
cy0zQV9fbGVhcm4ubWljcm9zb2Z0LmNvbV9lbi0yRHVzX3dpbmRvd3Nfc2VjdXJpdHlfaGFyZHdh
cmUtMkRzZWN1cml0eV9lbmFibGUtMkR2aXJ0dWFsaXphdGlvbi0yRGJhc2VkLTJEcHJvdGVjdGlv
bi0yRG9mLTJEY29kZS0yRGludGVncml0eSZkPUR3SURhUSZjPXM4ODNHcFVDT0NoS09IaW9jWXRH
Y2cmcj1OR1BSR0dvMzdtUWlTWGdIS201ckNRJm09RXd1NkhibTg5R1FuTmFJVEhNcU9ja2hiYTY5
Ml9nQjEwUEtHMHJOZTRoT3IwcklPZ2FRcFlLLURmSWRCempjbSZzPURQeGFkOFhJdGIzTzUtazhH
c3kwTGVFM1dfMXgxaXJ5bkRUd20tNDc5WmcmZT0NCj4+IFsyXSBodHRwczovL3VybGRlZmVuc2Uu
cHJvb2Zwb2ludC5jb20vdjIvdXJsP3U9aHR0cHMtM0FfX2xlYXJuLm1pY3Jvc29mdC5jb21fZW4t
MkR1c192aXJ0dWFsaXphdGlvbl9oeXBlci0yRHYtMkRvbi0yRHdpbmRvd3NfdGxmc19uZXN0ZWQt
MkR2aXJ0dWFsaXphdGlvbi0yM2VubGlnaHRlbmVkLTJEdm1jcy0yRGludGVsJmQ9RHdJRGFRJmM9
czg4M0dwVUNPQ2hLT0hpb2NZdEdjZyZyPU5HUFJHR28zN21RaVNYZ0hLbTVyQ1EmbT1Fd3U2SGJt
ODlHUW5OYUlUSE1xT2NraGJhNjkyX2dCMTBQS0cwck5lNGhPcjBySU9nYVFwWUstRGZJZEJ6amNt
JnM9eGxqN3ZlTnVKVEJTT3lXM1JrdVNrdk1lbFdOMDBxTGFoSDVWTzFVRnB1WSZlPQ0KPj4gWzNd
IGh0dHBzOi8vdXJsZGVmZW5zZS5wcm9vZnBvaW50LmNvbS92Mi91cmw/dT1odHRwcy0zQV9fcGF0
Y2h3b3JrLmtlcm5lbC5vcmdfcHJvamVjdF9rdm1fcGF0Y2hfMjAyMzExMTMwMjIzMjYuMjQzODgt
MkQ2LTJEbWljLTQwZGlnaWtvZC5uZXRfJmQ9RHdJRGFRJmM9czg4M0dwVUNPQ2hLT0hpb2NZdEdj
ZyZyPU5HUFJHR28zN21RaVNYZ0hLbTVyQ1EmbT1Fd3U2SGJtODlHUW5OYUlUSE1xT2NraGJhNjky
X2dCMTBQS0cwck5lNGhPcjBySU9nYVFwWUstRGZJZEJ6amNtJnM9Q3BQN0dZcF95anBXd1pSakZF
anppNktuMlZiWm00cXJGUkZicE1EdUF5ayZlPQ0KPj4gWzRdIGh0dHBzOi8vdXJsZGVmZW5zZS5w
cm9vZnBvaW50LmNvbS92Mi91cmw/dT1odHRwcy0zQV9fbGVhcm4ubWljcm9zb2Z0LmNvbV9lbi0y
RHVzX3ZpcnR1YWxpemF0aW9uX2h5cGVyLTJEdi0yRG9uLTJEd2luZG93c190bGZzX2ZlYXR1cmUt
MkRkaXNjb3ZlcnktMjNpbXBsZW1lbnRhdGlvbi0yRHJlY29tbWVuZGF0aW9ucy0yRC0yRC0yRDB4
NDAwMDAwMDQmZD1Ed0lEYVEmYz1zODgzR3BVQ09DaEtPSGlvY1l0R2NnJnI9TkdQUkdHbzM3bVFp
U1hnSEttNXJDUSZtPUV3dTZIYm04OUdRbk5hSVRITXFPY2toYmE2OTJfZ0IxMFBLRzByTmU0aE9y
MHJJT2dhUXBZSy1EZklkQnpqY20mcz1zU3JQY0Y5UjRRZkM4aEkteDlvNEJXY0EzUzVOM183RXNB
VU1rVEdhLWFVJmU9DQo+PiBbNV0gaHR0cHM6Ly91cmxkZWZlbnNlLnByb29mcG9pbnQuY29tL3Yy
L3VybD91PWh0dHBzLTNBX19naXRodWIuY29tX0pvbktvaGxlcl9xZW11X3RyZWVfbWJlYy0yRHJm
Yy0yRHYxJmQ9RHdJRGFRJmM9czg4M0dwVUNPQ2hLT0hpb2NZdEdjZyZyPU5HUFJHR28zN21RaVNY
Z0hLbTVyQ1EmbT1Fd3U2SGJtODlHUW5OYUlUSE1xT2NraGJhNjkyX2dCMTBQS0cwck5lNGhPcjBy
SU9nYVFwWUstRGZJZEJ6amNtJnM9Mkt5WTB0NlEwMW5kWUFXS0dnc0pDa0U0VUJVUlU0ODd0UFN6
empJcEZmUSZlPQ0KPj4gDQo+PiBDYzogQWxleGFuZGVyIEdyZXN0IDxBbGV4YW5kZXIuR3Jlc3RA
bWljcm9zb2Z0LmNvbT4NCj4+IENjOiBOaWNvbGFzIFNhZW56IEp1bGllbm5lIDxuc2FlbnpAYW1h
em9uLmVzPg0KPj4gQ2M6IE1hZGhhdmFuIFQuIFZlbmthdGFyYW1hbiA8bWFkdmVua2FAbGludXgu
bWljcm9zb2Z0LmNvbT4NCj4+IENjOiBNaWNrYcOrbCBTYWxhw7xuIDxtaWNAZGlnaWtvZC5uZXQ+
DQo+PiBDYzogVGFvIFN1IDx0YW8xLnN1QGxpbnV4LmludGVsLmNvbT4NCj4+IENjOiBYaWFveWFv
IExpIDx4aWFveWFvLmxpQGludGVsLmNvbT4NCj4+IENjOiBaaGFvIExpdSA8emhhbzEubGl1QGlu
dGVsLmNvbT4NCj4+IA0KPj4gSm9uIEtvaGxlciAoMTEpOg0KPj4gIEtWTTogeDg2OiBBZGQgbW9k
dWxlIHBhcmFtZXRlciBmb3IgSW50ZWwgTUJFQw0KPj4gIEtWTTogeDg2OiBBZGQgcHRfZ3Vlc3Rf
ZXhlY19jb250cm9sIHRvIGt2bV92Y3B1X2FyY2gNCj4+ICBLVk06IFZNWDogV2lyZSB1cCBJbnRl
bCBNQkVDIGVuYWJsZS9kaXNhYmxlIGxvZ2ljDQo+PiAgS1ZNOiB4ODYvbW11OiBSZW1vdmUgU1BU
RV9QRVJNX01BU0sNCj4+ICBLVk06IFZNWDogRXh0ZW5kIEVQVCBWaW9sYXRpb24gcHJvdGVjdGlv
biBiaXRzDQo+PiAgS1ZNOiB4ODYvbW11OiBJbnRyb2R1Y2Ugc2hhZG93X3V4X21hc2sNCj4+ICBL
Vk06IHg4Ni9tbXU6IEFkanVzdCBTUFRFX01NSU9fQUxMT1dFRF9NQVNLIHRvIHVuZGVyc3RhbmQg
TUJFQw0KPj4gIEtWTTogeDg2L21tdTogRXh0ZW5kIG1ha2Vfc3B0ZSB0byB1bmRlcnN0YW5kIE1C
RUMNCj4+ICBLVk06IG5WTVg6IFNldHVwIEludGVsIE1CRUMgaW4gbmVzdGVkIHNlY29uZGFyeSBj
b250cm9scw0KPj4gIEtWTTogVk1YOiBBbGxvdyBNQkVDIHdpdGggRVZNQ1MNCj4+ICBLVk06IHg4
NjogRW5hYmxlIG1vZHVsZSBwYXJhbWV0ZXIgZm9yIE1CRUMNCj4+IA0KPj4gTWlja2HDq2wgU2Fs
YcO8biAoNSk6DQo+PiAgS1ZNOiBWTVg6IGFkZCBjcHVfaGFzX3ZteF9tYmVjIGhlbHBlcg0KPj4g
IEtWTTogVk1YOiBEZWZpbmUgVk1YX0VQVF9VU0VSX0VYRUNVVEFCTEVfTUFTSw0KPj4gIEtWTTog
eDg2L21tdTogRXh0ZW5kIGFjY2VzcyBiaXRmaWVsZCBpbiBrdm1fbW11X3BhZ2Vfcm9sZQ0KPj4g
IEtWTTogVk1YOiBFbmhhbmNlIEVQVCB2aW9sYXRpb24gaGFuZGxlciBmb3IgUFJPVF9VU0VSX0VY
RUMNCj4+ICBLVk06IHg4Ni9tbXU6IEV4dGVuZCBpc19leGVjdXRhYmxlX3B0ZSB0byB1bmRlcnN0
YW5kIE1CRUMNCj4+IA0KPj4gTmlrb2xheSBCb3Jpc292ICgxKToNCj4+ICBLVk06IFZNWDogUmVt
b3ZlIEVQVF9WSU9MQVRJT05TX0FDQ18qX0JJVCBkZWZpbmVzDQo+PiANCj4+IFNlYW4gQ2hyaXN0
b3BoZXJzb24gKDEpOg0KPj4gIEtWTTogblZNWDogRGVjb3VwbGUgRVBUIFJXWCBiaXRzIGZyb20g
RVBUIFZpb2xhdGlvbiBwcm90ZWN0aW9uIGJpdHMNCj4+IA0KPj4gYXJjaC94ODYvaW5jbHVkZS9h
c20va3ZtX2hvc3QuaCB8IDEzICsrKysrLS0tLQ0KPj4gYXJjaC94ODYvaW5jbHVkZS9hc20vdm14
LmggICAgICB8IDQ1ICsrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tDQo+PiBhcmNoL3g4Ni9r
dm0vbW11LmggICAgICAgICAgICAgIHwgIDMgKy0NCj4+IGFyY2gveDg2L2t2bS9tbXUvbW11LmMg
ICAgICAgICAgfCAxMyArKysrKy0tLS0NCj4+IGFyY2gveDg2L2t2bS9tbXUvbW11dHJhY2UuaCAg
ICAgfCAyMyArKysrKysrKysrLS0tLS0NCj4+IGFyY2gveDg2L2t2bS9tbXUvcGFnaW5nX3RtcGwu
aCAgfCAxOSArKysrKysrKystLS0NCj4+IGFyY2gveDg2L2t2bS9tbXUvc3B0ZS5jICAgICAgICAg
fCA1MSArKysrKysrKysrKysrKysrKysrKysrKysrKysrLS0tLS0NCj4+IGFyY2gveDg2L2t2bS9t
bXUvc3B0ZS5oICAgICAgICAgfCAzNiArKysrKysrKysrKysrKystLS0tLS0tLQ0KPj4gYXJjaC94
ODYva3ZtL21tdS90ZHBfbW11LmMgICAgICB8ICAyICstDQo+PiBhcmNoL3g4Ni9rdm0vdm14L2Nh
cGFiaWxpdGllcy5oIHwgIDYgKysrKw0KPj4gYXJjaC94ODYva3ZtL3ZteC9oeXBlcnYuYyAgICAg
ICB8ICA1ICsrKy0NCj4+IGFyY2gveDg2L2t2bS92bXgvaHlwZXJ2X2V2bWNzLmggfCAgMSArDQo+
PiBhcmNoL3g4Ni9rdm0vdm14L25lc3RlZC5jICAgICAgIHwgIDQgKysrDQo+PiBhcmNoL3g4Ni9r
dm0vdm14L3ZteC5jICAgICAgICAgIHwgMjEgKysrKysrKysrKysrLS0NCj4+IGFyY2gveDg2L2t2
bS92bXgvdm14LmggICAgICAgICAgfCAgNyArKysrKw0KPj4gYXJjaC94ODYva3ZtL3g4Ni5jICAg
ICAgICAgICAgICB8ICA0ICsrKw0KPj4gMTYgZmlsZXMgY2hhbmdlZCwgMTkyIGluc2VydGlvbnMo
KyksIDYxIGRlbGV0aW9ucygtKQ0KPj4gDQo+PiAtLSANCj4+IDIuNDMuMA0KDQoNCg==

