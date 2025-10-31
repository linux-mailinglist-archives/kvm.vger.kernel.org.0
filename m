Return-Path: <kvm+bounces-61723-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C282C26857
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 19:07:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B3ED5188BB86
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 18:07:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 306AF3502BB;
	Fri, 31 Oct 2025 18:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="PG0wSvMM";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="bupcrjSJ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDCE32F29;
	Fri, 31 Oct 2025 18:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761933995; cv=fail; b=klloSid3WKiNOmClnOMWvoSGz+nlb3j9SwV8yOHRZVpmDmhKuv12adba2/99k4hWeSIGXL4m9fFttZ7u8i7NrycBEJrHG9gtfEren09z29f51wURdqmkpR+Mpr5+mJ3PrzwejXqO4jneR9Dsb3TrKmRyNwCihlG/wcK6hzVmHRo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761933995; c=relaxed/simple;
	bh=vHxhAA//jcdm6H53RECP+eKs3dIxbcR4C/oSD2/7Wzk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QLfZsJQ479iaAnyiwVGe+AppHP8W0gSYZxdnoJNeB7lsiEg3cfZdPrI7THKJlI+bLEiqpO6bbg9ndvZ/VfFKYkVxtguOKkcFl0i1nrXvCeDnZw8SjYa7IrJnP3NgHYJ8t2OpC9ewvTvEtObWPdLm0Yh4ISZC7D0vtLJkcYwwS30=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=PG0wSvMM; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=bupcrjSJ; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59VGp5X53754131;
	Fri, 31 Oct 2025 10:58:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=vHxhAA//jcdm6H53RECP+eKs3dIxbcR4C/oSD2/7W
	zk=; b=PG0wSvMMnef4KJBnD0p7ymfKobh14wKVCS8Eq3I3+L/g5N1bs4C1NneuK
	hwxtkGtyQWa7IRHe6yEL96MXzG3/INvi8OIo9VkESVib1elYxR/4iPnmUfKCR1vy
	C96YQ2SNle/yMh6EYlCX21twNMN0IOTna0wC5JkGGpbM/ipoMnHgJRy5DGUdRDO7
	Fn1AcxfMpyJMNnvNZIFuuHHyXxOgDrQ3szQmjSkKl9amAWXFkVTW+EJKTWyBvsN0
	6KsxTMlexMZ8qpXfO+0wN3SzpTGj0LrVqxBZg9Oc39w7YxTNOtWgNa7FCf73/IFU
	26n6mGQPuAzqGBhGJ+SeiXQpCTQ+g==
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11022139.outbound.protection.outlook.com [40.107.209.139])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4a4fstjd3x-2
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 31 Oct 2025 10:58:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QJ5F3zorDchk9c50qKuCVBV05k6M4Hq8Wph2bMLEu9gDxiZWOIKjBdNE2mXebVkmcZ+iu+IGe2si939/+gOhcxh+udCLoNJo+ZTdeGgUAXXFLWuLxr9HGvEifF9ywEgH61y3TiNEN+ZRDSlijlPzx0txFfSBAlDBe+N/4s7fmlrPvBFzHJ99Z4nnZOR0jCWjlo3lMao+y/FcAQFRkLuDP2rCOvMGz/71UsAp8uTeA3x5OjdOoKcRdWDGl1ubEOhs3IwIpzOswhB0fl+X9/Vm0yEWURgTNmjDoUrygoDX8s9GhJHue09R2/+Ma/YUA6xeSbrKVIfdqkPqKfk+iqAcmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vHxhAA//jcdm6H53RECP+eKs3dIxbcR4C/oSD2/7Wzk=;
 b=rREyEU+VxsPoVDoLKq0vp7pf1u7FEvrACBxUiuzj21uPJQc3lHFFXt6hupfyoGV/4eGv6M5NgYyW/+5r//yxR39eUy3UYmVdI55HS9oOT79RdunMH49r37vdpkKawND3NEbV/QSDdUq3p3yKbPZGX7AeOMancvwbczdgdD7XxYXkSWearbXqioIehFeeLBIkWv3YbbQAUiz8S69p+Kri+HiFYetGTJnJbCLc6SwmCTt38SoRlN7LSPi1nqjcTFXqFiQEyfIiY4s/cc+/swmTwKwvGG32zEOe3W8HIiM5PzA5N1bPR/npHy+jVMUp7wTyzH27Fnw/NeH7lKheBBclTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vHxhAA//jcdm6H53RECP+eKs3dIxbcR4C/oSD2/7Wzk=;
 b=bupcrjSJVo+/3LShWJsIUaw3a4XnqJIGmaS/uTST3kCq+0p9fNhjeieotYp6fAB6TIfZxdxyt1UC7HGvd3F9Bm2tfKDrnPNnBsQt2SG5tbhMtBop0NwDMyrx9weul/wX2SqMeBMXzmVqQpssaEEeqNdnQ47lztPLx/cICmLsb6o6q+r2Mb4lYKEAGzmvP6+mSAsbw3Z3peT3Ue/MRbNeB0nur8ACwfUEEiF0qNyiv6P3jHCqyjluA//uEQMldvS4w+101a9uWaOMygzXyGTAr2XUB1eR8GVz4K/qzKaIa9bS+KLqoenGR40Agyz9ISmvOgZtxp57FOo2DPvqwfBpmg==
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 (2603:10b6:408:333::18) by CH3PR02MB10382.namprd02.prod.outlook.com
 (2603:10b6:610:203::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.13; Fri, 31 Oct
 2025 17:58:30 +0000
Received: from LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc]) by LV0PR02MB11133.namprd02.prod.outlook.com
 ([fe80::10e5:8031:1b1b:b2dc%4]) with mapi id 15.20.9253.017; Fri, 31 Oct 2025
 17:58:29 +0000
From: Jon Kohler <jon@nutanix.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] KVM: x86: Load guest/host PKRU outside of the
 fastpath run loop
Thread-Topic: [PATCH 4/4] KVM: x86: Load guest/host PKRU outside of the
 fastpath run loop
Thread-Index: AQHcSe6Mk5n8WDTvbk+yt3fEzmuvoLTcitMA
Date: Fri, 31 Oct 2025 17:58:29 +0000
Message-ID: <0AA5A319-C4FC-4EEB-9317-BDC9E2E2E703@nutanix.com>
References: <20251030224246.3456492-1-seanjc@google.com>
 <20251030224246.3456492-5-seanjc@google.com>
In-Reply-To: <20251030224246.3456492-5-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.700.81)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV0PR02MB11133:EE_|CH3PR02MB10382:EE_
x-ms-office365-filtering-correlation-id: 5c26644c-9dfc-4f89-c89f-08de18a7197d
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|10070799003|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?YW5pV3h1d1RTYlM0V2dzb1RFVHA5L0xMQ2YzTTF0MDUvbDdwNmd3U21xbHVL?=
 =?utf-8?B?cUxoK3VhQWs1K25UUFIybnl3SGdnZFY3Q3pPeWxwOGYxME1mWm84OHAxd2Vy?=
 =?utf-8?B?YTdXMGJsdVlxL0hFbU5meWNmZDh4MzFKQ1NsVnpLanFwdUFOODhRVFJvY3l3?=
 =?utf-8?B?SGxQcXB0ZjFRUkZXUkpueVVmQ3VvaWR6OW40WVk1V2xDKzFJWjBvNGZLci9V?=
 =?utf-8?B?QUxqWnByVjVUQy9CQjcyQzR1YXN4OUh6T2lqVTdMbUsvNWlkUTRHbkpPMEpa?=
 =?utf-8?B?MCtsdVE2ZTU5aDdYdStGdi9KN042UzYzbjQ5VE1Cd0hWVjNRajVqKzhOV0w2?=
 =?utf-8?B?clltSVN1YW8wYjFaQjQwYVowbUFZTU9KRGFZZW1La0VhZWh3eHhGUm5LUFcx?=
 =?utf-8?B?YmE5L2dLTVE5VW45T3dvNXZKd05aYmJXYjlsSlpXMmtCWHVrV3Flc1cvRTZJ?=
 =?utf-8?B?WmY2WXpiZjk3WFVWcVpHQ2FsN2t2UG9TdHFXMU1WV3dEMzdxUGRlODhXK2F4?=
 =?utf-8?B?d3lWRzVEYW9GS2NxRFpZSnUrV01neitpOUdVa0s5VXY1citpaHVta20va3JS?=
 =?utf-8?B?b1Jia09majFreTZoWlE1eXBVb1V0UmQzNE5nbjRDbW9iTkZXeEhxWVo1U3Jj?=
 =?utf-8?B?NzRUWTNET29pTS9vNDByb0tKSVptb1N6RzF4Q1E5SG9ObkVTNWhxN0I2Q2R5?=
 =?utf-8?B?VVJ6QnNaenFUaW9tU25iU0ovU0pVaWphWWN2WUU0S05vb2xhc003UUI4aGRj?=
 =?utf-8?B?YjRDcmtJdmxrazd3Y0pPYzlFUEVNZFhkNVdNVTZ4dWtYbEtNeG4xck53Umto?=
 =?utf-8?B?N2NDRTZvWnJyYlZhai92SkR0NGJYT3ZTS3ZzdW93UnNKTWprOWtMQWcybits?=
 =?utf-8?B?V0hzOFVueUNxZGhld0RkN2l1ZUhKU0w0VDVFSGxnTEwwSmdyUXZuUlBFdzJX?=
 =?utf-8?B?YkRNYnhZcEt2U20vRXYzcEVrZitxbjRPRENZMm5RL0Y3ejBxQ25tMnpMd3Nr?=
 =?utf-8?B?UlFLaitObGJQSFNNNVpQNlM2L29wSnJKN2x0TTJCTnQvWDA1T2JvNlVycXlL?=
 =?utf-8?B?TkdURDFyTWMwczg1K2dOL0hZMXV1VTFsUXlINmlHUnNJWldCVVBER3JpODI3?=
 =?utf-8?B?Wm40UXpCV3ZhbVVpZlpsSDRCeVJzcHBDbDhLejNScDFkSU9MK0xvVDdqWS8x?=
 =?utf-8?B?VlVpZUtVODY5WVQ5WXI3eHhMazh0cVErdyt1dW5odnhtdkdkOXVRakZjK3Mw?=
 =?utf-8?B?Vm04YnFqZi9JdENBNG83dVlXZkNzRHg4VW9mQ25hUk5JcHF3RVZZMU5INVB6?=
 =?utf-8?B?NHAvb0JEWitiblFzcjNZVndjamR0TUhDbEhMdGNoUkNEOU16dnEydTR6c0Zv?=
 =?utf-8?B?ZDBVQzJVbUJqZThFeThIaU5MRXhQN0FGRURkdGUxL2ROaDIvaXF1VEt1WFVE?=
 =?utf-8?B?dCtMMXVzVnREUFlxd3RPd2dXdGRqb2NBWGZoRFdycFFUWkpWQ0tONzZBaGF5?=
 =?utf-8?B?TGttZGRMVjZOaW9WZHhRNGhqUVhuampjdVpmTVlNQnJrZEM4Q3lQR2IreHpp?=
 =?utf-8?B?VE1keWFlckVybWR2Qit2RnFYU1NVSkRCR2hrVDFuTnU1OUoyWFoyOVZuY1FC?=
 =?utf-8?B?eTQvRWE1bForUlhxUjVPbk00eCt0YUJyZm5VQXlyTmtrWG9Nb3Zhci9oaEtr?=
 =?utf-8?B?YUhmNlIzS3BieTVnODVuSzRIMGNiSEl1N0Q1dXhyc3d3NWN1UWtYeWZvVHdo?=
 =?utf-8?B?SkJTVlpvYXlObGl1YXNyajdnYTNLQW1CWEZTZnFUdGl0OWFhL0pQNTJRMnJS?=
 =?utf-8?B?bVdPWnB3d0dNdXk3M1FBQUJ1dlVJT2JhZkR3aDlVUVpLUjlqc2FFUTROaTlS?=
 =?utf-8?B?N3Q0bUIwc3BaTFBKUUVaL0Vqc1hQWXZaUmY4endISmh3bS9Kay95SHV3cU91?=
 =?utf-8?B?Rks1MHNORHVCUHJhVC90OTRoYkREM3FVLzF5ckVrYXoxNzBwSmhxbisvTDMx?=
 =?utf-8?B?WFB6RW5SUGRoSDVtTlhqakI5V2piUG1vYkJaSjcyUmZGYm5PaSszOHJzMWZF?=
 =?utf-8?Q?MKf7Cq?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV0PR02MB11133.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(10070799003)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?QmNjK1hXSjdJNllMbzJBUmZiUXRuNzBQS2JHNTdnL2gzRjFxeWtDOVJSUlE3?=
 =?utf-8?B?ak5ZVHFpdHdYTWh3MWVVYnp2MHR5WVc3SXA0VjdoVFlMMXVCZlp4ZytmVFdq?=
 =?utf-8?B?YlRVR1JxaExvZ2NJS3RuRC8yQ04rYWZma3JlVEZCNnljSmhkWmNiMkc3UHZB?=
 =?utf-8?B?SDBLU2QyR040RUlveEsxc3JZU1pnOXdJZVdUZWxqMGxEMGt0QXU5K3ZUZDRD?=
 =?utf-8?B?N0I1MzZxeVBLTnZ2WnNtYmo1d3daVmN1dXZLT082cklBSEFTVE5YRysrWFZR?=
 =?utf-8?B?RTVMeFhXT1VYVW9EQmR1ZEhLQjU1Znd3THNiOFA0RWdENzB0RmtsTGpFa1A3?=
 =?utf-8?B?QzRBL3I3VE8rME5IRkRFajd6U1RVWmlOYVZJNWV0QWNRUzlKN2VLNDhXK3NO?=
 =?utf-8?B?eVNCbTV2dWlLa1RaMkxVZHVKM2dHWTFKalA0M1BobVgyNXBYSmY3Rm4vQThN?=
 =?utf-8?B?aWZVMS9VL2cvM0RBVUNpRVFDakRQb3YydVVHa01HaHVTaDBDNGdvODU4WlNh?=
 =?utf-8?B?V1I1bzZZOXUwKzBaSTFPd3hUQ2tBdVZHeHhoM2JkRU1lcFhPZVpkLzVxcDA0?=
 =?utf-8?B?N1pjZEExU0RIRFVISkt6TmdzRTA5SlpERXBBK0hQbStOZU00eFZGNDMzRGQ5?=
 =?utf-8?B?RmU4cnRHTzBGZkFQWHJwWlg1UUp4Q1BqSFAxTGZiZE55ajY4TzlObVlJUHYr?=
 =?utf-8?B?LzVyWUpyN1lQNnpXYjAxOHQ5eDdEc0VjSVo3QVFzVlRDZGROVll5KzFlUjM4?=
 =?utf-8?B?Qk15dzNmMFA0SW5YTDdVQURjZkpOQnMyWHlGRlM1NjZiL0tkbFpYd2RoNzI1?=
 =?utf-8?B?V2IxNUhOOHhTdjN6U281cTEwZTVLUHhKY29yNmRyUVlCNVg0SUd3a2hPU0Yr?=
 =?utf-8?B?U0hjM1l6RGtiRHRwbVNvRk42YXBxREtZUkJyOEt0OTQ4dUVkWW1pRkY1U1Bm?=
 =?utf-8?B?YjNnT0RFRWhsc25LS1BzMXhjcGs4R3VlT0pXdjdOR0U2R3hCZ3kyWFFITXJO?=
 =?utf-8?B?R1owTmluNmxkZzk3SUx6Y0d1MXBES2JxUXlxamN0U1JtazE3bGpldGxqWkx3?=
 =?utf-8?B?OVhjbnBrS3pzV1ZJcWIrQldGVUJZT2c3SkhxUW1UaXdSdmRLb0didEhKTmhH?=
 =?utf-8?B?dTZDbU5kWGRjRGdlVlJGRVk0czRrcXdkRDNYa1N2VHhXMmNmaXF1cTU3VVBu?=
 =?utf-8?B?R1pHWlRINVJiWitlRVVJd3FjU1VleVBVMm5VWkV2cUR1cWd4OEtLbEJCYlRE?=
 =?utf-8?B?WXc4dVpsNjMyMEs0MW9neWpoWitORXdkc3Blb252SXBlUm9vcWVpcm1BQlBS?=
 =?utf-8?B?VnpTVFE4NDZHZVRnTEJ5cUlnZTgyVUJBSUJZeWt4RmU4eE0wWFlYdlZTeWI2?=
 =?utf-8?B?NHU4S1RkRDdTQzZ4TVBNbEdKSDVQdjRFa0lkM0ZRV1drV3dZQ3JwN04veFlk?=
 =?utf-8?B?bnd0bGU1UUpXbFBqV1pPUkgwTllPNm1wSHRLSnE1TmJLT1RuT05QbXQ2M3Zr?=
 =?utf-8?B?VWltaHlpV2s0UnpzaVBlTEVadWRlYUhMQU00VlFhRDdjNExnMkdPRWQvL1FP?=
 =?utf-8?B?Nm5aZC9EZG95WklsMzRuR3VPeEJ2NzdFdXUxdXVZSmNzYUt6VXR0K2V3R3dQ?=
 =?utf-8?B?VzYwTndQWVREbnN4TUlEekJMemlSYk1TSFo2Z01FNDhDenA2ZzRFOTJvYU5h?=
 =?utf-8?B?UlFUM1BYbDZ2M3FjY2ltSzlvOHk2TElPc05WN0RDbHVGU0EwL20wdkVISW8w?=
 =?utf-8?B?dUtGWklmeWlGV01vZElScGFxRkcwZHJrTllxMEZ6VUlOZWJHeG0wUW0vbk5u?=
 =?utf-8?B?b0tORkJYNGp4T1hvUFY2N2RKWlA0REVZRCtVK2l5bmM4TGFpemFBQldJbjdr?=
 =?utf-8?B?eURmNklDYWw3N1lwREkxVm12RGdoMWVFYk0rUi9yNjBhREltZ0N5YlpPKzhO?=
 =?utf-8?B?VVFlSllkbDFwc01rNDNaMjlOdHB6Q1QraGMvZFZYR3hOT0U2UkJ6STFjakli?=
 =?utf-8?B?ZnJqR2I2RUpURmNKK1IvMWkveUN0Zzl2dExRRnROTlB2VHZHSDB1VXZibVIz?=
 =?utf-8?B?ZDN0ZE9hdUdyWTVBTmxlVzVveVFvaWs5WmFiM0FkRmo2L2t6bGh1YzZnZzNF?=
 =?utf-8?B?dTRVWFpURFB1Rk95Qmo1eEVyWElFTTRlT1ZDQ3hHYTRvakgxQzFBaWovQXg1?=
 =?utf-8?B?SVphaWRhdXhDVTFUb0daa3FVaCtpblA3N25rNVp6eU41TjN6eFJ5U2x6U2ww?=
 =?utf-8?B?ZHBxaitVc0VUaUw1alhOLzRya2pRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6B5544234F6E6C479D4017E0FB61537E@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV0PR02MB11133.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c26644c-9dfc-4f89-c89f-08de18a7197d
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Oct 2025 17:58:29.9141
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wQ+jGujokvikRmT1RUlpkub0Jj4LDh6+lvZ0kVQ6lWoLqBbcZyMUmnk6bjBr2evd3Qs2r5piMZ/aCfkRcatP83GbQ2zFAoJWy2//HjjhcTk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR02MB10382
X-Proofpoint-ORIG-GUID: LWwYkwPePBgUrfwHmddcPuZNKwKWuZBO
X-Proofpoint-GUID: LWwYkwPePBgUrfwHmddcPuZNKwKWuZBO
X-Authority-Analysis: v=2.4 cv=N8Yk1m9B c=1 sm=1 tr=0 ts=6904f8c9 cx=c_pps
 a=A91p8pFdSY8iZOlwlHItIA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=1XWaLZrsAAAA:8 a=Bcie3u8nvEPerFoYjosA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDMxMDE2MSBTYWx0ZWRfX+By20bWn5fnN
 gwukYCYt5sFjnKOWeVmJpJjO1fdVkTXuX8ZsGOJJ6OsArRnjW9c7OWaGFm35xb7zJA+zT5O4KQ8
 7tPDhQj24K00L4eOZyTbgM4o9D3pc1HyuZ5lxO7us0LEItJ+g9QbtYeHznzfJkrzJ18AZOeb+rA
 RP2SnvXSrLLbN6Fh3CNfRJ3KPZO9cFOUeSXDSj8Hea1zlspyXTdLAwFnkbUyd5WxgRnB6YbERWe
 Cp0BAWttsbsI1n9CIqnBBcBi5oSElL2Jj+NqCVpztKk+/P1Kk7lVqVB1B2KkMYkcqf9UROSxFpW
 esoWV5t7D22CRBTJeu/h8WSqv6CMA763VfaYyxC1r0v1KrICFuvIyRh4E10+s/KXUl3GTQey9LP
 f49YqmWTrStJoXyn/uCNa3MvxrQJYQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-10-31_06,2025-10-29_03,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gT2N0IDMwLCAyMDI1LCBhdCA2OjQy4oCvUE0sIFNlYW4gQ2hyaXN0b3BoZXJzb24g
PHNlYW5qY0Bnb29nbGUuY29tPiB3cm90ZToNCj4gDQo+ICEtLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPiAgQ0FVVElP
TjogRXh0ZXJuYWwgRW1haWwNCj4gDQo+IHwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tIQ0KPiANCj4gTW92ZSBLVk0ncyBz
d2FwcGluZyBvZiBQS1JVIG91dHNpZGUgb2YgdGhlIGZhc3RwYXRoIGxvb3AsIGFzIHRoZXJlIGlz
IG5vDQo+IEtWTSBjb2RlIGFueXdoZXJlIGluIHRoZSBmYXN0cGF0aCB0aGF0IGFjY2Vzc2VzIGd1
ZXN0L3VzZXJzcGFjZSBtZW1vcnksDQo+IGkuZS4gdGhhdCBjYW4gY29uc3VtZSBwcm90ZWN0aW9u
IGtleXMuDQo+IA0KPiBBcyBkb2N1bWVudGVkIGJ5IGNvbW1pdCAxYmUwZTYxYzFmMjUgKCJLVk0s
IHBrZXlzOiBzYXZlL3Jlc3RvcmUgUEtSVSB3aGVuDQo+IGd1ZXN0L2hvc3Qgc3dpdGNoZXMiKSwg
S1ZNIGp1c3QgbmVlZHMgdG8gZW5zdXJlIHRoZSBob3N0J3MgUEtSVSBpcyBsb2FkZWQNCj4gd2hl
biBLVk0gKG9yIHRoZSBrZXJuZWwgYXQtbGFyZ2UpIG1heSBhY2Nlc3MgdXNlcnNwYWNlIG1lbW9y
eS4gIEFuZCBhdCB0aGUNCj4gdGltZSBvZiBjb21taXQgMWJlMGU2MWMxZjI1LCBLVk0gZGlkbid0
IGhhdmUgYSBmYXN0cGF0aCwgYW5kIFBLVSB3YXMNCj4gc3RyaWN0bHkgY29udGFpbmVkIHRvIFZN
WCwgaS5lLiB0aGVyZSB3YXMgbm8gcmVhc29uIHRvIHN3YXAgUEtSVSBvdXRzaWRlDQo+IG9mIHZt
eF92Y3B1X3J1bigpLg0KPiANCj4gT3ZlciB0aW1lLCB0aGUgIm5lZWQiIHRvIHN3YXAgUEtSVSBj
bG9zZSB0byBWTS1FbnRlciB3YXMgbGlrZWx5IGZhbHNlbHkNCj4gc29saWRpZmllZCBieSB0aGUg
YXNzb2NpYXRpb24gd2l0aCBYRkVBVFVSRXMgaW4gY29tbWl0IDM3NDg2MTM1ZDNhNw0KPiAoIktW
TTogeDg2OiBGaXggcGtydSBzYXZlL3Jlc3RvcmUgd2hlbiBndWVzdCBDUjQuUEtFPTAsIG1vdmUg
aXQgdG8geDg2LmMiKSwNCj4gYW5kIFhGRUFUVVJFIHN3YXBwaW5nIHdhcyBpbiB0dXJuIG1vdmVk
IGNsb3NlIHRvIFZNLUVudGVyL1ZNLUV4aXQgYXMgYQ0KPiBLVk0gaGFjay1hLWZpeCB1dGlvbiBm
b3IgYW4gI01DIGhhbmRsZXIgYnVnIGJ5IGNvbW1pdCAxODExZDk3OWM3MTYNCj4gKCJ4ODYva3Zt
OiBtb3ZlIGt2bV9sb2FkL3B1dF9ndWVzdF94Y3IwIGludG8gYXRvbWljIGNvbnRleHQiKS4NCj4g
DQo+IERlZmVycmluZyB0aGUgUEtSVSBsb2FkcyBzaGF2ZXMgfjQwIGN5Y2xlcyBvZmYgdGhlIGZh
c3RwYXRoIGZvciBJbnRlbCwNCj4gYW5kIH42MCBjeWNsZXMgZm9yIEFNRC4gIEUuZy4gdXNpbmcg
SU5WRCBpbiBLVk0tVW5pdC1UZXN0J3Mgdm1leGl0LmMsDQo+IHdpdGggZXh0cmEgaGFja3MgdG8g
ZW5hYmxlIENSNC5QS0UgYW5kIFBLUlU9KC0xdSAmIH4weDMpLCBsYXRlbmN5IG51bWJlcnMNCj4g
Zm9yIEFNRCBUdXJpbiBnbyBmcm9tIH4xNTYwID0+IH4xNTAwLCBhbmQgZm9yIEludGVsIEVtZXJh
bGQgUmFwaWRzLCBnbw0KPiBmcm9tIH44MTAgPT4gfjc3MC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6
IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUuY29tPg0KPiAtLS0NCj4gYXJjaC94
ODYva3ZtL3N2bS9zdm0uYyB8ICAyIC0tDQo+IGFyY2gveDg2L2t2bS92bXgvdm14LmMgfCAgNCAt
LS0tDQo+IGFyY2gveDg2L2t2bS94ODYuYyAgICAgfCAxNCArKysrKysrKysrLS0tLQ0KPiBhcmNo
L3g4Ni9rdm0veDg2LmggICAgIHwgIDIgLS0NCj4gNCBmaWxlcyBjaGFuZ2VkLCAxMCBpbnNlcnRp
b25zKCspLCAxMiBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0v
c3ZtL3N2bS5jIGIvYXJjaC94ODYva3ZtL3N2bS9zdm0uYw0KPiBpbmRleCBlOGIxNThmNzNjNzku
LmUxZmI4NTNjMjYzYyAxMDA2NDQNCj4gLS0tIGEvYXJjaC94ODYva3ZtL3N2bS9zdm0uYw0KPiAr
KysgYi9hcmNoL3g4Ni9rdm0vc3ZtL3N2bS5jDQo+IEBAIC00MjYwLDcgKzQyNjAsNiBAQCBzdGF0
aWMgX19ub19rY3NhbiBmYXN0cGF0aF90IHN2bV92Y3B1X3J1bihzdHJ1Y3Qga3ZtX3ZjcHUgKnZj
cHUsIHU2NCBydW5fZmxhZ3MpDQo+IHN2bV9zZXRfZHI2KHZjcHUsIERSNl9BQ1RJVkVfTE9XKTsN
Cj4gDQo+IGNsZ2koKTsNCj4gLSBrdm1fbG9hZF9ndWVzdF94c2F2ZV9zdGF0ZSh2Y3B1KTsNCj4g
DQo+IC8qDQo+ICogSGFyZHdhcmUgb25seSBjb250ZXh0IHN3aXRjaGVzIERFQlVHQ1RMIGlmIExC
UiB2aXJ0dWFsaXphdGlvbiBpcw0KPiBAQCAtNDMwMyw3ICs0MzAyLDYgQEAgc3RhdGljIF9fbm9f
a2NzYW4gZmFzdHBhdGhfdCBzdm1fdmNwdV9ydW4oc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCB1NjQg
cnVuX2ZsYWdzKQ0KPiAgICB2Y3B1LT5hcmNoLmhvc3RfZGVidWdjdGwgIT0gc3ZtLT52bWNiLT5z
YXZlLmRiZ2N0bCkNCj4gdXBkYXRlX2RlYnVnY3RsbXNyKHZjcHUtPmFyY2guaG9zdF9kZWJ1Z2N0
bCk7DQo+IA0KPiAtIGt2bV9sb2FkX2hvc3RfeHNhdmVfc3RhdGUodmNwdSk7DQo+IHN0Z2koKTsN
Cj4gDQo+IC8qIEFueSBwZW5kaW5nIE5NSSB3aWxsIGhhcHBlbiBoZXJlICovDQo+IGRpZmYgLS1n
aXQgYS9hcmNoL3g4Ni9rdm0vdm14L3ZteC5jIGIvYXJjaC94ODYva3ZtL3ZteC92bXguYw0KPiBp
bmRleCAxMjNkYWU4Y2Y0NmIuLjU1ZDYzN2NlYTg0YSAxMDA2NDQNCj4gLS0tIGEvYXJjaC94ODYv
a3ZtL3ZteC92bXguYw0KPiArKysgYi9hcmNoL3g4Ni9rdm0vdm14L3ZteC5jDQo+IEBAIC03NDY1
LDggKzc0NjUsNiBAQCBmYXN0cGF0aF90IHZteF92Y3B1X3J1bihzdHJ1Y3Qga3ZtX3ZjcHUgKnZj
cHUsIHU2NCBydW5fZmxhZ3MpDQo+IGlmICh2Y3B1LT5ndWVzdF9kZWJ1ZyAmIEtWTV9HVUVTVERC
R19TSU5HTEVTVEVQKQ0KPiB2bXhfc2V0X2ludGVycnVwdF9zaGFkb3codmNwdSwgMCk7DQo+IA0K
PiAtIGt2bV9sb2FkX2d1ZXN0X3hzYXZlX3N0YXRlKHZjcHUpOw0KPiAtDQo+IHB0X2d1ZXN0X2Vu
dGVyKHZteCk7DQo+IA0KPiBhdG9taWNfc3dpdGNoX3BlcmZfbXNycyh2bXgpOw0KPiBAQCAtNzUx
MCw4ICs3NTA4LDYgQEAgZmFzdHBhdGhfdCB2bXhfdmNwdV9ydW4oc3RydWN0IGt2bV92Y3B1ICp2
Y3B1LCB1NjQgcnVuX2ZsYWdzKQ0KPiANCj4gcHRfZ3Vlc3RfZXhpdCh2bXgpOw0KPiANCj4gLSBr
dm1fbG9hZF9ob3N0X3hzYXZlX3N0YXRlKHZjcHUpOw0KPiAtDQo+IGlmIChpc19ndWVzdF9tb2Rl
KHZjcHUpKSB7DQo+IC8qDQo+ICogVHJhY2sgVk1MQVVOQ0gvVk1SRVNVTUUgdGhhdCBoYXZlIG1h
ZGUgcGFzdCBndWVzdCBzdGF0ZQ0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3g4Ni5jIGIv
YXJjaC94ODYva3ZtL3g4Ni5jDQo+IGluZGV4IGI1YzI4NzllMzMzMC4uNjkyNDAwNmYwNzk2IDEw
MDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9rdm0veDg2LmMNCj4gKysrIGIvYXJjaC94ODYva3ZtL3g4
Ni5jDQo+IEBAIC0xMjMzLDcgKzEyMzMsNyBAQCBzdGF0aWMgdm9pZCBrdm1fbG9hZF9ob3N0X3hm
ZWF0dXJlcyhzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQo+IH0NCj4gfQ0KPiANCj4gLXZvaWQga3Zt
X2xvYWRfZ3Vlc3RfeHNhdmVfc3RhdGUoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQ0KPiArc3RhdGlj
IHZvaWQga3ZtX2xvYWRfZ3Vlc3RfcGtydShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQo+IHsNCj4g
aWYgKHZjcHUtPmFyY2guZ3Vlc3Rfc3RhdGVfcHJvdGVjdGVkKQ0KPiByZXR1cm47DQo+IEBAIC0x
MjQ0LDkgKzEyNDQsOCBAQCB2b2lkIGt2bV9sb2FkX2d1ZXN0X3hzYXZlX3N0YXRlKHN0cnVjdCBr
dm1fdmNwdSAqdmNwdSkNCj4gICAgIGt2bV9pc19jcjRfYml0X3NldCh2Y3B1LCBYODZfQ1I0X1BL
RSkpKQ0KPiB3cnBrcnUodmNwdS0+YXJjaC5wa3J1KTsNCj4gfQ0KPiAtRVhQT1JUX1NZTUJPTF9G
T1JfS1ZNX0lOVEVSTkFMKGt2bV9sb2FkX2d1ZXN0X3hzYXZlX3N0YXRlKTsNCj4gDQo+IC12b2lk
IGt2bV9sb2FkX2hvc3RfeHNhdmVfc3RhdGUoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQ0KPiArc3Rh
dGljIHZvaWQga3ZtX2xvYWRfaG9zdF9wa3J1KHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkNCj4gew0K
PiBpZiAodmNwdS0+YXJjaC5ndWVzdF9zdGF0ZV9wcm90ZWN0ZWQpDQo+IHJldHVybjsNCj4gQEAg
LTEyNTksNyArMTI1OCw2IEBAIHZvaWQga3ZtX2xvYWRfaG9zdF94c2F2ZV9zdGF0ZShzdHJ1Y3Qg
a3ZtX3ZjcHUgKnZjcHUpDQo+IHdycGtydSh2Y3B1LT5hcmNoLmhvc3RfcGtydSk7DQo+IH0NCj4g
fQ0KPiAtRVhQT1JUX1NZTUJPTF9GT1JfS1ZNX0lOVEVSTkFMKGt2bV9sb2FkX2hvc3RfeHNhdmVf
c3RhdGUpOw0KPiANCj4gI2lmZGVmIENPTkZJR19YODZfNjQNCj4gc3RhdGljIGlubGluZSB1NjQg
a3ZtX2d1ZXN0X3N1cHBvcnRlZF94ZmQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQ0KPiBAQCAtMTEz
MzEsNiArMTEzMjksMTIgQEAgc3RhdGljIGludCB2Y3B1X2VudGVyX2d1ZXN0KHN0cnVjdCBrdm1f
dmNwdSAqdmNwdSkNCj4gDQo+IGd1ZXN0X3RpbWluZ19lbnRlcl9pcnFvZmYoKTsNCj4gDQo+ICsg
LyoNCj4gKyAqIFN3YXAgUEtSVSB3aXRoIGhhcmR3YXJlIGJyZWFrcG9pbnRzIGRpc2FibGVkIHRv
IG1pbmltaXplIHRoZSBudW1iZXINCj4gKyAqIG9mIGZsb3dzIHdoZXJlIG5vbi1LVk0gY29kZSBj
YW4gcnVuIHdpdGggZ3Vlc3Qgc3RhdGUgbG9hZGVkLg0KPiArICovDQo+ICsga3ZtX2xvYWRfZ3Vl
c3RfcGtydSh2Y3B1KTsNCj4gKw0KDQpJIHdhcyBtb2NraW5nIHRoaXMgdXAgYWZ0ZXIgUFVDSywg
YW5kIHdlbnQgZG93biBhIHNpbWlsYXItaXNoIHBhdGgsIGJ1dCB3YXMNCnRoaW5raW5nIGl0IG1p
Z2h0IGJlIGludGVyZXN0aW5nIHRvIGhhdmUgYW4geDg2IG9wIGNhbGxlZCBzb21ldGhpbmcgdG8g
dGhlIGVmZmVjdCBvZg0K4oCccHJlcGFyZV9zd2l0Y2hfdG9fZ3Vlc3RfaXJxb2Zm4oCdIGFuZCDi
gJxwcmVwYXJlX3N3aXRjaF90b19ob3N0X2lycW9mZuKAnSwgd2hpY2gNCm1pZ2h0IG1ha2UgZm9y
IGEgcGxhY2UgdG8gbmVzdGxlIGFueSBvdGhlciBzb3J0IG9mIOKAnG5lZWRzIHRvIGJlIGRvbmUg
aW4gYXRvbWljDQpjb250ZXh0IGJ1dCBkb2VzbuKAmXQgbmVlZCB0byBiZSBkb25lIGluIHRoZSBm
YXN0IHBhdGjigJ0gc29ydCBvZiBzdHVmZiAoaWYgYW55KS4NCg0KT25lIG90aGVyIG9uZSB0aGF0
IGNhdWdodCBteSBleWUgd2FzIHRoZSBjcjMgc3R1ZmYgdGhhdCB3YXMgbW92ZWQgb3V0IGEgd2hp
bGUNCmFnbywgYnV0IHRoZW4gbW92ZWQgYmFjayB3aXRoIDFhNzE1ODEwMS4NCg0KSSBoYXZlbuKA
mXQgZ29uZSB0aHJvdWdoIGFic29sdXRlbHkgZXZlcnl0aGluZyBlbHNlIGluIHRoYXQgdGlnaHQg
bG9vcCBjb2RlIChhbmQgZGlkbuKAmXQNCmdldCBhIGNoYW5jZSB0byBkbyB0aGUgc2FtZSBmb3Ig
U1ZNIGNvZGUpLCBidXQgZmlndXJlZCBJ4oCZZCBwdXQgdGhlIGlkZWEgb3V0IHRoZXJlDQp0byBz
ZWUgd2hhdCB5b3UgdGhpbmsuDQoNClRvIGJlIGNsZWFyLCBJ4oCZbSB0b3RhbGx5IE9LIHdpdGgg
dGhlIHNlcmllcyBhcy1pcywganVzdCB0aGlua2luZyBhYm91dCBwZXJoYXBzIGZ1dHVyZQ0Kd2F5
cyB0byBpbmNyZW1lbnRhbGx5IG9wdGltaXplIGhlcmU/DQoNCj4gZm9yICg7Oykgew0KPiAvKg0K
PiAqIEFzc2VydCB0aGF0IHZDUFUgdnMuIFZNIEFQSUN2IHN0YXRlIGlzIGNvbnNpc3RlbnQuICBB
biBBUElDdg0KPiBAQCAtMTEzNTksNiArMTEzNjMsOCBAQCBzdGF0aWMgaW50IHZjcHVfZW50ZXJf
Z3Vlc3Qoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQ0KPiArK3ZjcHUtPnN0YXQuZXhpdHM7DQo+IH0N
Cj4gDQo+ICsga3ZtX2xvYWRfaG9zdF9wa3J1KHZjcHUpOw0KPiArDQo+IC8qDQo+ICogRG8gdGhp
cyBoZXJlIGJlZm9yZSByZXN0b3JpbmcgZGVidWcgcmVnaXN0ZXJzIG9uIHRoZSBob3N0LiAgQW5k
DQo+ICogc2luY2Ugd2UgZG8gdGhpcyBiZWZvcmUgaGFuZGxpbmcgdGhlIHZtZXhpdCwgYSBEUiBh
Y2Nlc3Mgdm1leGl0DQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0veDg2LmggYi9hcmNoL3g4
Ni9rdm0veDg2LmgNCj4gaW5kZXggZjNkYzc3ZjAwNmY5Li4yNGM3NTRiMGRiMmUgMTAwNjQ0DQo+
IC0tLSBhL2FyY2gveDg2L2t2bS94ODYuaA0KPiArKysgYi9hcmNoL3g4Ni9rdm0veDg2LmgNCj4g
QEAgLTYyMiw4ICs2MjIsNiBAQCBzdGF0aWMgaW5saW5lIHZvaWQga3ZtX21hY2hpbmVfY2hlY2so
dm9pZCkNCj4gI2VuZGlmDQo+IH0NCj4gDQo+IC12b2lkIGt2bV9sb2FkX2d1ZXN0X3hzYXZlX3N0
YXRlKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSk7DQo+IC12b2lkIGt2bV9sb2FkX2hvc3RfeHNhdmVf
c3RhdGUoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KTsNCj4gaW50IGt2bV9zcGVjX2N0cmxfdGVzdF92
YWx1ZSh1NjQgdmFsdWUpOw0KPiBpbnQga3ZtX2hhbmRsZV9tZW1vcnlfZmFpbHVyZShzdHJ1Y3Qg
a3ZtX3ZjcHUgKnZjcHUsIGludCByLA0KPiAgICAgIHN0cnVjdCB4ODZfZXhjZXB0aW9uICplKTsN
Cj4gLS0gDQo+IDIuNTEuMS45MzAuZ2FjZjZlODFlYTItZ29vZw0KPiANCg0K

