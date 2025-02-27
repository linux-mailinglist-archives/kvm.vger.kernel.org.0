Return-Path: <kvm+bounces-39627-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EF76A48927
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 20:41:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 11BA81890045
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 19:42:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11DB826F44D;
	Thu, 27 Feb 2025 19:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="V33d3zZt";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="tTetGN22"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ADCD270054;
	Thu, 27 Feb 2025 19:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740685305; cv=fail; b=nVyZfWXW0+K99d40IdsvaeMdz7qMvdEfDF264g4Bt5fPv0eQG4rrEJiFE+8jJI6KJbKdD5seXDJHaSlj+dbaxEQ57Vz7Z8y4vutiCubU6gsQr2kKbGuRpapotVs37Yd4xx7z2jnnxf7Xkz6yje0/i9/b4tgRqfwmB23NdexdC4o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740685305; c=relaxed/simple;
	bh=+KZsLF4EvcjgsL78rwq1bWRaiNRCI6o+SZXWiMgXxAc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=MuJDbZLrYHtxLVmD3I8kIq4Oty5y67UYUYsOcldyd2NXi55jf77PMfHWQSG14G1cHELflRYz3ZHrNtQnoKXK1x7b+DD7/gX3gMtvE9B8VqseKkCeU4VwzA7v/0Ja++vOFnePv4rlG7P9PL/MXasq0kKepjGwb0Yuhk5WJNMX6DE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=V33d3zZt; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=tTetGN22; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127840.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51RBroob028334;
	Thu, 27 Feb 2025 11:05:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=+KZsLF4EvcjgsL78rwq1bWRaiNRCI6o+SZXWiMgXx
	Ac=; b=V33d3zZtvXQwNB0E1STq+zYx7boXqTTzsWXBxxwFC0DtY/bQyWwkcn1Yv
	dL2iLYludO8zvhExynpZzKl2/oOFMQLup1gItGTe9L/AEtNtGXunV0cX6G8AGS+w
	UpknhIHIX6ZLOdqkBe0fEaNmIhbkKq1NZEOKO72G6XrFyXwXdjJyg6hqsbkYJ2sN
	t0G3KHJhmrb/XLUqN77dB7DyZZMdQa4V39sqCjl223jwSm7DU8J7GNn50J6tH+R5
	dJr6OXue9NNVJOlIITcmcj2hFXA/F8YWJF0Z3nRrtG0iOn/TeitvlSZ9ysCK5wqw
	3AUqldQugicCJ1czrWSAMKoujS72w==
Received: from bl0pr05cu006.outbound.protection.outlook.com (mail-BL0PR05CU006.outbound1701.protection.outlook.com [40.93.2.8])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 44ybt06p5y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 27 Feb 2025 11:05:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A0Gzv+re++jf4Cu6TwTnCn63lYWkaMwDqCBl49oB1qTwUCl2+hBCcCclzqyHb7GwCsLtNYaIdOyZTLwimXI7j/91GcnAinWP1fiT7nfW2AV+TBrjSeLqv7+bvB/+ZZeW9ooG7/pEeRFlmOH1xiU82t/QL2ZJPXCtrefBEhDERtuh4ttZEykk3Xsk5G4PNQIyfsJbxx9Tx3TrPG7HuKLD2vG2mREhnb4k/GL11ldA1nEk/ymit4+f7c+dznb5m+Oic+CG9uRKVN+tFhamM4UhOkPEwVna/PEni7J4LbLmMdlqOF9YAnq8jBYIY/rV2BGP51deKmpcsvVow3zbriTvhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+KZsLF4EvcjgsL78rwq1bWRaiNRCI6o+SZXWiMgXxAc=;
 b=rWxLNRH8qjFfjTb9R1jg3FTcy0RjeSbXjbYERXGOSra1N/ilRIpO02PrSbEwQf/vaoJxYmki+H3/5INawYtQHGS2y803A0A2twu8d130cTgdy4fRgtIPwe79FANu6kgWJJZO/FzLsOn68opwiGvBOC6vxtFszA0e6x637mc3Zyd9rx6TicDk1lSDCjORlLBmmYPPANXVDVjAFDggB3PALGAxw8cTo5glnwdTxvF4zKrBGsn9OAUZU4MbopB8NJva+BUVWGBch2Mne5l4ns2eRtkBLkzY588KinfHlyxaNfzstIrl0I3YiQQMyC4yJJIYGwrylLe/nhr1E9fTksvhjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+KZsLF4EvcjgsL78rwq1bWRaiNRCI6o+SZXWiMgXxAc=;
 b=tTetGN22WYZWki4huuoPN/SaSTIl3lJ/8KecK4deK4TN4yMa31xBW1b36s7Y+NvrjMRc5W71u/HzNmQGHpa5drsGCMzMKXGJO3Qr5LD5duiEJBQxXjIx/RMycGkTgbt4QWu6iDD5TKy3LVtu3ESUQuBWv/NlqLhuQ+iiAj3mi4SRCnQKs2/e13ayD1Cc2L+jznehQ2XsNPcjpgLXo/f+yoCCr1d1eMua0Tbn78n0GzHAwupS/sl567uIfsm+Mrnb+C0KcXmMjsknahNmYNsnUrDmteyXPrwHe0c7zzUY7hmOej/YFgNoH7hU7DceHvroETiz5PS3M9Xy5/qT3qk7Lw==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by BY1PR02MB10482.namprd02.prod.outlook.com
 (2603:10b6:a03:5ac::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.21; Thu, 27 Feb
 2025 19:05:27 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%3]) with mapi id 15.20.8489.021; Thu, 27 Feb 2025
 19:05:27 +0000
From: Jon Kohler <jon@nutanix.com>
To: Nikolay Borisov <nik.borisov@suse.com>
CC: Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini
	<pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] KVM: nVMX: Decouple EPT RWX bits from EPT
 Violation protection bits
Thread-Topic: [PATCH v2 2/2] KVM: nVMX: Decouple EPT RWX bits from EPT
 Violation protection bits
Thread-Index: AQHbiKuSz38dKdLINEOJF/kN397UALNatxIAgADL5IA=
Date: Thu, 27 Feb 2025 19:05:27 +0000
Message-ID: <88E181D6-323E-4352-8E4C-7B7191707611@nutanix.com>
References: <20250227000705.3199706-1-seanjc@google.com>
 <20250227000705.3199706-3-seanjc@google.com>
 <73f00589-7d6d-489a-ae40-fefdf674ea42@suse.com>
In-Reply-To: <73f00589-7d6d-489a-ae40-fefdf674ea42@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.400.131.1.6)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV8PR02MB10287:EE_|BY1PR02MB10482:EE_
x-ms-office365-filtering-correlation-id: c4921d30-d83f-4896-d7bf-08dd5761b264
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|366016|1800799024|10070799003|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?d3RYUW1wazd2bW5VTUUxMk1paEdhMVpXUGR1WkphTG1xZzlUS2hKUVpjbWhs?=
 =?utf-8?B?S2ZoZGFSVTA2Rmk5eUtUalNRR0ZoaFJuRThHZE9uL3hUNmkxWE1mRXQ3bnlo?=
 =?utf-8?B?R0JyMFdpdGJubnVBWGxJQ3hLaXE4K3VvWnExWHIyNEs3VS9wQTVGSW9la2xJ?=
 =?utf-8?B?VkhzeFRKVmJ1dzdJbVRMRTZIaE9qUXR1M2VjWGRseC8vSDZ3YWdoVjdPT0xt?=
 =?utf-8?B?TCtSbC8rc0NCU3hBZGI3U0h2MlVodjdaSW8rRkR0Mm05UkV1TkRzaWtvcWtZ?=
 =?utf-8?B?V0lBWldieVFsUEVoVllsUC9sVTVXYlJ2L1I2ek9NWE5ab3FMTnVPUlFZenFw?=
 =?utf-8?B?QjBEWFE5UlkyQzVEQWFURzlaVlVTbmhzVjd4QWNPMktSaUk3MHlacnNzMlA5?=
 =?utf-8?B?UUlkVlB2QlZwZHpCTmczSWRuYXZWVjZhNzBDbWd4c3FUOWZOS0hZd3JsTmQv?=
 =?utf-8?B?SDVUT0l2SENSaU9remZyVDlJQkgrSytxTkJ4bzZ6RWYrWjFWOVZOaXhyL1BB?=
 =?utf-8?B?Y2E0d1lqQWVKME84TlI1Ujl0RXZtanljTWJDaFh4aUpSNktJQ2IzK0V5ZXpN?=
 =?utf-8?B?YlJYN3hTM0Z1WWdzTE4zRWNMaW5OUEdqejdMdWdoazFoU21nYXVXVnBQRTNJ?=
 =?utf-8?B?dEoyekhrQURIN056Qm5zanVIa01HNTJRRHY0aTVueHpXWVZuSi9DaWQ4WEda?=
 =?utf-8?B?LysyeXNqcU1lMWxveTc4M1NqTGNFOXVCYzJ1d1N0WUl0MXJtK3JOeWUxZ21l?=
 =?utf-8?B?RmdGNytkYVM3Yks2VnQ1VlhOUW12Wkc4eGk4NWFkb0xKQ3A5ejAzc000MUZh?=
 =?utf-8?B?MGRVS1MzemFyaStjWFB0MHJrZ2pOdXVLMEh5MEtEcEtoa1lTQTRzMGljWUZ2?=
 =?utf-8?B?M1RSaGpOdDNndHJKQ01CcURxSXMrZnRvbXlaQUdRMlYyUnh1Vkg0Y0pOV2Qx?=
 =?utf-8?B?eEx4NHlXZTZUQS9ZV09DOE1nVDVmZGNGVmQ1ZXJuakR1RFk0YjhPOVdUdC9F?=
 =?utf-8?B?dFVxSDRtWWxhWDM5a1VoVzNrYjJ4NkhOdklxOHBzMlpqUmp2TC94T3JSQ0d6?=
 =?utf-8?B?YTdqUkJNWklEOU42U09HK2gzT21SRWx5RFdtaUZTT2V2b1JteHBJMTM5cmc2?=
 =?utf-8?B?SWo3cmk5c1J3L3pvbmFLTnJUN2V0SUZ6TkxQV1RwblpUU0tsaXF6RHlQUk9R?=
 =?utf-8?B?aU52SE9CZ1dMSTNxNGdXWUwxTW96dTAyNm5WTWNvQWp6WXU1K3hpanAyZ245?=
 =?utf-8?B?UTF4N01MbERrY1hKU0tZbkE1eUVGSWcreE16dEd0M3l3aDVHK1hOL202OXpr?=
 =?utf-8?B?QzROVEpFVXlnWkZzQ1Boc2JvQTF1dDVhVE5zSVErcmUzRVUxbHNmWG4vT1g1?=
 =?utf-8?B?QlpuaG9EalFJaXU0YXo4RWhHaVpxR3dWeS9HdWtqK1pRNkhnQlQ4TDlTdVl3?=
 =?utf-8?B?REVodmhaNGpQYzM1RGI5alAveEZZd0g4UUU0VjYyK1dhQm8rYTN5RXk2VzU0?=
 =?utf-8?B?TlNlZVFJbmNEWDAwWnBsSUVmcHlHTkpvUWs2My9NenlUV0VKR2xoQnlpZ2xz?=
 =?utf-8?B?d1NtQmNTSE9kVHEva0ZaeTFHSVVNVFpnMTBRd3h4dm5wSWVIZ1JzR052WVJm?=
 =?utf-8?B?TGxzcUIzS2UvamR5QnU4T0xqNGxCOTNNdFN1VThZTG9DYVQxSnh4Rm9LbWFY?=
 =?utf-8?B?eWFFZk5DcGFqS3IrTG9WSlNzOTNmNk44aHdHdzBPV3locEVRV1o4OUZVaHQ4?=
 =?utf-8?B?MVkzZVpTaTNZUzVYVUhqa05oV1pwQU43WE43QTRTckNwK3NRNElSVTVqYUJH?=
 =?utf-8?B?cmROQTZOeEgzWjZnR3Z4V0VnSS9Fck9mRjVBZTQ5VmJZbzZiOXJYbmdDQWVi?=
 =?utf-8?B?bjczbGpIVFdyV0RzWHBMUUwxTlhSNityUGZIbVJNRzBIRWc9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(10070799003)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?M1NBa29makJhNm5XSnlDVFp0QUFSbDJPZk44NGFyekJyblFqVVhVUjRyTGtU?=
 =?utf-8?B?b28zN3JBZE5mT1dBenZKcG9Wd1gyaVFWTGw1RUJwTzFUckFTYjJWUVJsZzRU?=
 =?utf-8?B?UC9Ka1dkc3k1VG40ZDRDWEppWmFQc29kanJqYVE3ODRyYnNPMW9MRGRDakEv?=
 =?utf-8?B?Uk5NZ0x2WU5pREVNZlNyMURQbG9mTXI0Tm5IcHJjUXgwaU81ZERjbVZjS3pJ?=
 =?utf-8?B?bUxyMjYyTlpmYkZuUkRnSWtiNGExT05KZkV3UE5MZVBTbTVOK0I0Q0ZEQUh5?=
 =?utf-8?B?aEpKRG1KdERScXpLYUk2SVZkN0YyYWsrbDJPaWIrWjJXOUd5SkRETmlSeUZN?=
 =?utf-8?B?TVB1MlFGY0FTWDZZb0tWUGtPWDhwbzZ4b3d2OEdNUUcvY0k5TTQ1Wi8wanZH?=
 =?utf-8?B?OW12Wnkxc1FaMTFVVmoxV0lxSmxaYXB0T2VRQUlIN1FBVmZZcm5YanY3M25U?=
 =?utf-8?B?emI0LzNVRFA5UEh4VlBmSzNkRGh3V3gwN3NWbnJoaEpFaFZlaFVTVkEyZXAv?=
 =?utf-8?B?Q3RZNDBzUVNURmZUdm1ka2Jzd2lhLzVWVWx5alJFd1pnNHZwRHZRd0xXSXJt?=
 =?utf-8?B?eDk5YWxJNkFlMnlVd1dKSkM1OG1JaE5KRC96bTNNTGxIQkYxaHdLTDNBNmJx?=
 =?utf-8?B?ZXdzT0xYUnVRc1dZNmNPRURnSTY1RkJoVXU0OWhUNEJKTTRuSDBsL3lXaTJV?=
 =?utf-8?B?ai9WRHZWUHYwTDVPMUdOYmZlZ1V3SUZPaEFhbDE2MjlFaFlwRTJ4ZTRadTN2?=
 =?utf-8?B?bGdmUXk1QmEvTzN0UFl2aEFmTi9GejFkYUlyRE5nNGZ6cHlWNG1LUmx6TW5Q?=
 =?utf-8?B?b3o0ZlFZdVgxNWhaSTVibWg1TWtCaEZsZkhOTEplWmFjU29SNlRYcHNiQ1Rm?=
 =?utf-8?B?SnA0cGhKeHBjbWhwS0I4b29IeURhSkRncG5CQXdvcDVUUksrNk85b2YvaWc2?=
 =?utf-8?B?ZlBVZVBnSlV1K0lrN3cyZ2k2Mk91MUVLQ1UyWkpFaVB6T1VPb2RMd2xmdG82?=
 =?utf-8?B?VkRsSnFIbno3N2xpNDdJY1hBUmd6clJUblYyTHF2MGJoeDNsekdMR3o4M2Fx?=
 =?utf-8?B?bWd6aEdkVFM2VGJ6UEhyMXhEZHkyYlR0M1B3enRiKzY3SUpRV2NvMjhzaXpH?=
 =?utf-8?B?TkJFbVRxejY1dERnQVZHa0xsRVN1RDl5SldIZGZiNDZZNDlpbm1WYmRhcnps?=
 =?utf-8?B?S3N6S2VmZWdxV1dqV254UmVXTnRDWlJFNkc0SkdkQ1lCYVBadnlQL2tRUCt3?=
 =?utf-8?B?WVNYcHJDTDJXT2xoUTdPbW10UlVNQ3ZTYVErUURhNWROcnZSRC9lVitNM0xx?=
 =?utf-8?B?UzFMbDFIcGcvajVIZmJDMUw5SUFIdndONUpudzZWbDErQS96QUJZeFpoeW1N?=
 =?utf-8?B?dXFScjRSRUZ3dmt3T2lOekR2Z0xFYU9JVkJ6YmZsYnFRaTdRMDJOaWZVbi95?=
 =?utf-8?B?UlBLaTIwYVdzM0UyWndRT0R4MXhRYWxlM05ZZGNtZkM3YXkxanRuZTcxdHI4?=
 =?utf-8?B?d1pVZWtpMFVZbGdmQ1AwZUdXcGh3WEhmR2R5VENoUUR2dUNzRWtKUVAxWEh1?=
 =?utf-8?B?L0k0eDFHYm81Nkg0UWdJZ0VYLzlHblI3empybVE5cFhjd3JQTHY1SEEvd3VN?=
 =?utf-8?B?VVlvNitPaDNKN0RIRHpHWjJtd1lsejlvOTQ4eU9oNCtzZXNQN3NlakcyNk1v?=
 =?utf-8?B?dUtITHF4VlNFOUt4VWF5SVVEcWs4WHBTUlJzKzJISnRYWU05Y0dQZDJBSXVk?=
 =?utf-8?B?alVNckZuM1RxRVNZSkJzUjZ3cFBCN3R6NG5ZQ3ZQUjY5NEVXdGVQQlg5Vi9C?=
 =?utf-8?B?UUEzNGZibm8yckVKRCtrMW9hM1RMVjBiUWRsNkd1Q1d0R0pFc2J4azRQdmdK?=
 =?utf-8?B?aU9KWE1kdkhhWjZMZkFjMHZJYjJqeVF2Zmw5V1BOZGllT0k5Y3ljQS8rV1NM?=
 =?utf-8?B?VTk5eCtMZnczdHRQcm05RzFYZUpmdmFMbm5EVGRvWEQxNjFxRXo4ekpvRjYv?=
 =?utf-8?B?RjBtdTF6NnhhTXBwL2tOblVLQkhFYU81VnlBSmZIbVFUemJPV0VIK1JRUjE0?=
 =?utf-8?B?ckZUdXZtRW9aTjREWkVoakpjc1dFQVVsYm9IZ1BoR1dSNjlhZnRzZi8vaFhO?=
 =?utf-8?B?c2d4Z1h2dWFEYmdoSVh6eHZCN0xBZTl0SzM2S2tDSXNzTWpsT09XNFl2RVc5?=
 =?utf-8?B?K1BKc01rNGkySHYyZGhmMFZaNGEwTzF2V0RreGpqekxKcEVxSElVTFJvMkZo?=
 =?utf-8?B?UWV1RU9mRGx3b0tQeWRjTWMwMGt3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1C04B3876720644D9ACC1F4082580DB1@namprd02.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: c4921d30-d83f-4896-d7bf-08dd5761b264
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Feb 2025 19:05:27.2844
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: V3zmWdPbNAuyBvnxM/7DeP4Hjzcp+PN0xImrRkCP3YIQbs792Avy7OsjjFMWgMRcVGLAdZfSpMxurZ/tF4mBEohxBrwK0ae85tHh5W3//pI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR02MB10482
X-Authority-Analysis: v=2.4 cv=U6JoDfru c=1 sm=1 tr=0 ts=67c0b77a cx=c_pps a=Kq952KYlFoMAqHE57MuLQQ==:117 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10 a=T2h4t0Lz3GQA:10 a=0kUYKlekyDsA:10
 a=NEAV23lmAAAA:8 a=iox4zFpeAAAA:8 a=64Cc0HZtAAAA:8 a=1XWaLZrsAAAA:8 a=MazYlqJYhkOfsdcFVc4A:9 a=QEXdDO2ut3YA:10 a=iFS0Xi_KNk6JYoBecTCZ:22 a=WzC6qhA0u3u7Ye7llzcV:22 a=14NRyaPF5x3gF6G45PvQ:22
X-Proofpoint-GUID: Y88K3JaUpghvqONfzX8lXFRHWhSFsjT4
X-Proofpoint-ORIG-GUID: Y88K3JaUpghvqONfzX8lXFRHWhSFsjT4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-27_07,2025-02-27_01,2024-11-22_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gRmViIDI3LCAyMDI1LCBhdCAxOjUy4oCvQU0sIE5pa29sYXkgQm9yaXNvdiA8bmlr
LmJvcmlzb3ZAc3VzZS5jb20+IHdyb3RlOg0KPiANCj4gIS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS18DQo+IENBVVRJT046
IEV4dGVybmFsIEVtYWlsDQo+IA0KPiB8LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLSENCj4gDQo+IA0KPiANCj4gT24gMjcu
MDIuMjUg0LMuIDI6MDcg0YcuLCBTZWFuIENocmlzdG9waGVyc29uIHdyb3RlOg0KPj4gRGVmaW5l
IGluZGVwZW5kZW50IG1hY3JvcyBmb3IgdGhlIFJXWCBwcm90ZWN0aW9uIGJpdHMgdGhhdCBhcmUg
ZW51bWVyYXRlZA0KPj4gdmlhIEVYSVRfUVVBTElGSUNBVElPTiBmb3IgRVBUIFZpb2xhdGlvbnMs
IGFuZCB0aWUgdGhlbSB0byB0aGUgUldYIGJpdHMgaW4NCj4+IEVQVCBlbnRyaWVzIHZpYSBjb21w
aWxlLXRpbWUgYXNzZXJ0cy4gIFBpZ2d5YmFja2luZyB0aGUgRVBURSBkZWZpbmVzIHdvcmtzDQo+
PiBmb3Igbm93LCBidXQgaXQgY3JlYXRlcyBob2xlcyBpbiB0aGUgRVBUX1ZJT0xBVElPTl94eHgg
bWFjcm9zIGFuZCB3aWxsDQo+PiBjYXVzZSBoZWFkYWNoZXMgaWYvd2hlbiBLVk0gZW11bGF0ZXMg
TW9kZS1CYXNlZCBFeGVjdXRpb24gKE1CRUMpLCBvciBhbnkNCj4+IG90aGVyIGZlYXR1cmVzIHRo
YXQgaW50cm9kdWNlcyBhZGRpdGlvbmFsIHByb3RlY3Rpb24gaW5mb3JtYXRpb24uDQo+PiBPcHBv
cnR1bmlzdGljYWxseSByZW5hbWUgRVBUX1ZJT0xBVElPTl9SV1hfTUFTSyB0byBFUFRfVklPTEFU
SU9OX1BST1RfTUFTSw0KPj4gc28gdGhhdCBpdCBkb2Vzbid0IGJlY29tZSBzdGFsZSBpZi93aGVu
IE1CRUMgc3VwcG9ydCBpcyBhZGRlZC4NCj4+IE5vIGZ1bmN0aW9uYWwgY2hhbmdlIGludGVuZGVk
Lg0KPj4gQ2M6IEpvbiBLb2hsZXIgPGpvbkBudXRhbml4LmNvbT4NCj4+IENjOiBOaWtvbGF5IEJv
cmlzb3YgPG5pay5ib3Jpc292QHN1c2UuY29tPg0KPj4gU2lnbmVkLW9mZi1ieTogU2VhbiBDaHJp
c3RvcGhlcnNvbiA8c2VhbmpjQGdvb2dsZS5jb20+DQo+IA0KPiBSZXZpZXdlZC1ieTogTmlrb2xh
eSBCb3Jpc292IDxuaWsuYm9yaXNvdkBzdXNlLmNvbT4NCg0KTEdUTSwgYnV0IGFueSBjaGFuY2Ug
d2UgY291bGQgaG9sZCB0aGlzIHVudGlsIEkgZ2V0IHRoZSBNQkVDIFJGQw0Kb3V0PyBNeSBhcG9s
b2dpZXMgb24gdGhlIGRlbGF5LCBJIGNhdWdodCBhIHRlcnJpYmxlIGNoZXN0IGNvbGQgYWZ0ZXIN
CndlIG1ldCBhYm91dCBpdCwgZm9sbG93ZWQgYnkgYSBzZWNvbmRhcnkgY2FzZSBvZiBzdHJlcCEg
SnVzdCBnZXR0aW5nDQpiYWNrIGludG8gdGhlIGdyaW5kIG5vdywgc28gSSBuZWVkIHRvIHJlYmFz
ZSBhbmQgc2VuZCB0aG9zZSBvdXQuDQoNCkZvciBhbnlvbmUgY3VyaW91cywgdGhlIGRyYWZ0cyBh
cmUgaGVyZToNCmh0dHBzOi8vZ2l0aHViLmNvbS9Kb25Lb2hsZXIvbGludXgvdHJlZS9tYmVjLXJm
Yy12MS02LjEyIA0KaHR0cHM6Ly9naXRodWIuY29tL0pvbktvaGxlci9xZW11L3RyZWUvbWJlYy1y
ZmMtdjENCg0KSSBuZWVkIHRvIGluY29ycG9yYXRlIHNvbWUgZWFybHkgb2ZmLWxpc3QgcmV2aWV3
IGNvbW1lbnRzIGFuZCBzZW5kDQppdCBvdXQgcHJvcGVybHksIGJ1dCBpbiByZWZlcmVuY2UgdG8g
dGhpcyBzcGVjaWZpYyBjaGFuZ2UsIHlvdSBjYW4NCnNlZSBob3cgSSBhcHByb2FjaGVkIGl0IGhl
cmU6DQpodHRwczovL2dpdGh1Yi5jb20vSm9uS29obGVyL2xpbnV4L2NvbW1pdC8wZDJlODI3MDRl
ZDNlYjI4YzEwNTk2N2M4YWNkNzkwNzUyM2RlZDViIA==

