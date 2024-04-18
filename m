Return-Path: <kvm+bounces-15064-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AD188A9797
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 12:39:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3D7D9282F21
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 10:39:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCA5015DBC0;
	Thu, 18 Apr 2024 10:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="hBYDi2+p";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="pnfVnYIF"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53C111442F6
	for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 10:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713436642; cv=fail; b=FUZYf5nem0b4FyDeysQ+cHKBYun6sBVEe7umM/Da7ITT/NfhfLTPjysMVCEAYp0Yjgf8iHOQv2TyQhhhllurHyr046FNW1La2gIEZep2NhBhOYn3J4Yngl7cHHGHD/Wd3OFgUX3toXvJ3s/DYexmVul+Cy+eE82GYdNwmSBV5vA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713436642; c=relaxed/simple;
	bh=dOPraJoIfq/jneBO2FsqFKl1fjefVJ8OlyLL4wSYCGI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=irRFqqP8JPVH4Y3xyCFJ5xlla4vohtlGUp+FjVYr+BEGfk/sxthS5JPAL+M/qActMhpOvNRsy4RTmOM9F1T4xNNUqv4gdyfFH+bhITMMxMLM1P2q1lZqGunbrabNraQTlvI1FNTVbSfeK9a2LaAvs0vqQHQ1v1jeCZj7/8oWagk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=hBYDi2+p; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=pnfVnYIF; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127844.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 43HLsVQx020648;
	Thu, 18 Apr 2024 03:36:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	from:to:cc:subject:date:message-id:references:in-reply-to
	:content-type:content-id:content-transfer-encoding:mime-version;
	 s=proofpoint20171006; bh=7vrq5+uWIAHuIgIihyQwvrm+GUDlKtDxOM2SJf
	/gDyw=; b=hBYDi2+piRQ0s8+9xSP+nD5u1m3ov2Mf/uIKrIS/O+k3l6/l8a3TUg
	lf4Drb6KEkxCixRgzIiXzWui1h/WO/jWmeDJ4JsEDdVZOJWw3kBywBhhuSC0cFAk
	AG68+Lrm7bhjoR6g7LnBhHAJaGffsZzNaV3d7nIz7Hq74yxIfNsDENYBqVr/HQLl
	xxRpq0byPquTYGHCKKDbAhaWUpErUAO16Qkfw+TWJmvsNRfl9vYKVzNC0SOXDG1Z
	6nGXJP4EPojMA/3HZr8K0mM758gZ195T22Il4ue7y+XR6KNe09mWlEy8sqWBC4rt
	YJRBOb0k144kR8ffUjmhOeZMC2+ddUYA==
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 3xfsjy2n31-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Apr 2024 03:36:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZJPjaNrzLBB3DGIdKhT7230tM3JbjiBcGpBePe3aaMMookgyPyhejhcunuqm5xFmgluez5YGZkqvHNcF0iiiID/gamG5Skesdze0sH4fmKysTKqZhWdoy9MT8o0ofPwkm0HCmpuvcJO+obAz8oeRpuCxO9H06s1/nKIi5hO9nEoSSflB9bqbZZPuy+aWfjfmIn9avJgV1XK/UH+e4tLOdBf7x2w31GJUGbommxGPaBGBWkcLJzB+D5rOL2bTzFdE7FeQd8gQtu50Q2pk3LCjWeYlRt04e+ELQc2wmyvzvwmQwPbro8h5GW9aaSEWs3p61yoOaFGeTBHC/gFbvMbPgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7vrq5+uWIAHuIgIihyQwvrm+GUDlKtDxOM2SJf/gDyw=;
 b=cS/M77UlGXvcn11Ye62IvVUEibC0D4xaQaFqBfngQCU+gj8curOKQwZj+Z2Oq5yDPXWlNKSBJbowlwhXmE0ZbI71OBXhZQAMBPneGqFBSsbhM8bTBs10Z/FcqLJ+iF3pzTqTJEm/Cz1py/mG2iJBU5x1aEouR63W+UsBvxeRrGCMnD01mtz9iGPPzf6+YwyCirog7wCi0OIx2JtdHgXVUFv+afjDE3XTao6OAs8CX7t7INsN0HKCwKpmFIfOt01pNLtdjoSKs3FPUB+gavMAQ09JW1Jgwga/eghDOBKkqepX6eopi9jrg7zLA9dv/l7H2kJ/1SRCe/Q2+bfH3zghWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7vrq5+uWIAHuIgIihyQwvrm+GUDlKtDxOM2SJf/gDyw=;
 b=pnfVnYIFk82lbdEa+kPm/yXi1Hoxe4QKFGA2y07GjLPbouqV2SNTZAyoI7nsXuVQz5F1rDYEMPbAUr5IGKU4rAZZGWO2L0i+w39d0y9/39p519XutrOMtsuIIz7Af4sw3tDBWclthh7t5N6xSPyMtWj2hlSH+OgM9+ju5Ky9TD8UjLI0sGOFTi7EIV7FpQNHQAXZXsd6Mx5vQ16YyNhZ+64NmO5Duj5Q1dNRXSmeAaw3Ne/ulL9bOzkop1AHbyAVBgwZKW6Uoq+dP/eQoZudoEGFxRjZGHDERx/k8f7NMrdy+aaUWv9rhGSAYTuhSqnM7spdvMHbPzSeaCuJZzYOIA==
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by LV3PR02MB10331.namprd02.prod.outlook.com (2603:10b6:408:1ae::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.41; Thu, 18 Apr
 2024 10:36:40 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::cab5:29a2:97ac:ef9]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::cab5:29a2:97ac:ef9%5]) with mapi id 15.20.7452.049; Thu, 18 Apr 2024
 10:36:40 +0000
From: Shivam Kumar <shivam.kumar1@nutanix.com>
To: Sean Christopherson <seanjc@google.com>
CC: "maz@kernel.org" <maz@kernel.org>,
        "pbonzini@redhat.com"
	<pbonzini@redhat.com>,
        "james.morse@arm.com" <james.morse@arm.com>,
        "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
        "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>,
        "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        Aravind Retnakaran
	<aravind.retnakaran@nutanix.com>,
        "Carl Waldspurger [C]"
	<carl.waldspurger@nutanix.com>,
        David Vrabel <david.vrabel@nutanix.com>,
        "david@redhat.com" <david@redhat.com>,
        "will@kernel.org" <will@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Shaju Abraham
	<shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
Subject: Re: [PATCH v10 1/3] KVM: Implement dirty quota-based throttling of
 vcpus
Thread-Topic: [PATCH v10 1/3] KVM: Implement dirty quota-based throttling of
 vcpus
Thread-Index: AQHaZP+QfXJ/NMwR+0W6xjApEmLwu7FrdNIAgAK5uoA=
Date: Thu, 18 Apr 2024 10:36:40 +0000
Message-ID: <BAB5E0D9-5F21-475E-8D57-EEE3E1F071E9@nutanix.com>
References: <20240221195125.102479-1-shivam.kumar1@nutanix.com>
 <20240221195125.102479-2-shivam.kumar1@nutanix.com>
 <Zh6uYhMTAHwTjJUu@google.com>
In-Reply-To: <Zh6uYhMTAHwTjJUu@google.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO6PR02MB7555:EE_|LV3PR02MB10331:EE_
x-ms-office365-filtering-correlation-id: c1ed3266-c916-40f9-e129-08dc5f936eba
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 Yyr7PMNwEt+pWBLiTAnnww7skbK9FFKvMvXdtNOK9cCmxacFO1zxGl4vITq6D3Kr6Q0zhHyvElDV2kkLfG0U3d1XFhO50IAQfykiab/o+W9XGoZFahHTcGrfdrXDVjxav/GXBMFoG6ygtpnRRRsDZ3Zw2TQsQOebwejaZgxmk4YzyHmh++7k82K5nRANkfQ/tYLPVsHlQFfl9u69NYByUN3qTzesPJUNJ7o45r/773nToa8DRupoQDtg7LMIby0cKBPw708hO42i2EHai7CT6Z+2GNIJ325eOeR9TpUMTWjQdDo14XdMjV7HUT7zLqYCaifMo/G5wJQaYQmxncZlUBt+S+bI7GJuEaTASHxQISR0RlZ6dN58b8QcY8sSdiXwribCz+ZgbY3XaF035dgxQNMmUp1VZxlvvUcn/5Pr3rRm30eWHEMLrrW4cm/FjVg6/XiLX0yJ2eLhQh43YVPiFrtKivjZWzCJ3jHZG8xC7r0DXXJJs80HLIjHCgmnhnJNaUNNOkAsIdoQSwGHgtGbzxleSp+KaSaw78skEW98eyEV1+dacfMZX0valFS3tDSUh8eYJBVWAzwoCLauo1Dlscc9/3hkgIOJqrQYHYr426yOTu/CvblrPDZKXYfwg+gtf1g1YlQC33IzDXAfv9TzLkqhaucg39daS0WYAxNJverV5fsruWnMH5Kq3sj5np0nUjyW4SvGqA6QbpYWmEjQHjYFWQCNTAIFMHTx0hLiIjM=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(7416005)(366007)(38070700009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?boZWDphR3YdqG13mCb29UWsjSJS6pjqv/Z6Cj67dJ1YuIDkcF1amr1W1LJUL?=
 =?us-ascii?Q?zmCIaVg34yu11SWNc0xgOxFqLCu3LbpRPsb9ZhzKYFoKJBvM5o8PiExZGaH8?=
 =?us-ascii?Q?Fsk0Qlu00KpM/Tfq0WJSBoNbNpPj7MR0AeEbh6zlQmuuyosKyxbB+2RfmAz7?=
 =?us-ascii?Q?Tv3hFHaoqsfYPBSgYQiyDunfDXRehPVauW1Y/5PTXScMVM6HAex6L4R8AbFl?=
 =?us-ascii?Q?wRdrlOEGmA1Gt538UPiLZlULTm/zPpWgFZzGi1LAIudVY2+5RNNDLMQMZ84g?=
 =?us-ascii?Q?VF2FMzKCXobYAXoAuKGm7TW82EFAAl1XjO9YEBL7i4F+7W/8BpIVQrgr+iWY?=
 =?us-ascii?Q?rOUMhTi6eUDudfkP1QIRdIYi6vuwjg/zkXtBav9c9pY3U87N/uvw3ozRrr1o?=
 =?us-ascii?Q?JCSzdkWQU5Z4+4bhHOH/og1x6RNvZ4xyv+9yO4qgfsf/HgRAx3XiWb+vCpsa?=
 =?us-ascii?Q?ExT28vRU5jfHaBu9CIYnD+p6lWaLFoyHdLjf49jdvPNJlc8w7E8LjvsGcPw2?=
 =?us-ascii?Q?yzr0Z6JOYDQTijt1fQZM9to7E0Zt7FDBISG9wlNxhMXOqNZ6IzNluKY2QW2F?=
 =?us-ascii?Q?UQSjpzyt8e+XM7H51pDKIvPA4Qy6y47snk/EMhgyO9K6ijvG/z29wFq6Oasx?=
 =?us-ascii?Q?qvLwJ7OQ/lx9Yfyiu6MeAselzXBebtVZhbsLlptk0otB/OTPOWyOf5PZG0f5?=
 =?us-ascii?Q?Vy2ckjIYdZl8rjpuKBSj6m9QbG65LPCUcJt44lwvt1ej2dEDnaV1JukZDs6D?=
 =?us-ascii?Q?em73fuEJ4qRrqpiyPZ8QNFYHqa8m4tjWm0eXL7VtnKXoI5UmDd4iSICBZ+zG?=
 =?us-ascii?Q?ql5GecwO35gEn9TSysL8ejlras+VNglmjuB9Z9VeXV5H4eVHSynnczZqSOIX?=
 =?us-ascii?Q?SkDymG0NHPZYB5L539/nKzvd+eL2NAo+SzHt5yFGF1LbMcajv9gHHZSUbYTL?=
 =?us-ascii?Q?kvhReFH90WkEwJWIWqrdsfFY2ELtoyflb3OuJ35pX9lgEmPbqOCjBDVYOv3s?=
 =?us-ascii?Q?4TiEPJ8jXnwhIu+o+zw5bfgjOlabGRk8njSqbSR9zInajicnZ0UoKRc6QudC?=
 =?us-ascii?Q?n/IPvN7pP1IlVJURB4bsBiV6a1pvIcr/xCs5/RiBw+Lv/iTv+cnCH30YLqNW?=
 =?us-ascii?Q?6IuPyVcGcJMR+t/HILh/odclg1/0xBCS49jsS41XXjKGSqsT2gWle+eN8AP5?=
 =?us-ascii?Q?ndwOUewLJGyq6BZQUpg6MbB5AOysOggz3BGSsgJ6KdVQI9ojStHURTlv3Czc?=
 =?us-ascii?Q?0qM3aNpTIYP70DCRKGuvgCNwFj0QZo8ywJTff5CCFJFjEsI0EghAmOvt6DmO?=
 =?us-ascii?Q?vnAHGQtzyrvqu0gASAiVLAvtdPSYabKPkCgGjFyuFE8tH6eakXmsEXVv9gY2?=
 =?us-ascii?Q?v0xqhK8sG0HqAmi33irZlS9aR5lDlVh4BhLOhcLYBkORx5rVJQyaly7wK1wT?=
 =?us-ascii?Q?Yrtowp8hWBeHa04Nhzz8yPUuG4U5dvFt+tIR9MBB98QIKI2528NhKq79OWDY?=
 =?us-ascii?Q?FiWoCfFnYWqeEBWHRXr1AuXB2DxM5u99OrCntCazXsG03othzAB+mhkytoXR?=
 =?us-ascii?Q?aKfkLqLXTT+RXzyFJnJJxdfz7zhzOxq0ZT9fsA8q09rVoocSpio7sM/gOEYM?=
 =?us-ascii?Q?RA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CFDEE9FA0E50D44AA9437178838BCB0A@namprd02.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1ed3266-c916-40f9-e129-08dc5f936eba
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Apr 2024 10:36:40.2158
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0ZNqLgzk+I283USos4apdd9PHtRQkJvjyyHNuBUXBh0BiriSSwoyCFHVsxmDbNzPOVJciLUjvRe5hNVCzDdGrSL2KMO7rLNJp9clZEnkNIE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR02MB10331
X-Proofpoint-ORIG-GUID: BFIgoxl21VeWhhuArfGkSmsoxHG4vSYN
X-Proofpoint-GUID: BFIgoxl21VeWhhuArfGkSmsoxHG4vSYN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-18_08,2024-04-17_01,2023-05-22_02
X-Proofpoint-Spam-Reason: safe


> On 16-Apr-2024, at 10:29 PM, Sean Christopherson <seanjc@google.com> wrot=
e:
> On Wed, Feb 21, 2024, Shivam Kumar wrote:
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index c3308536482b..217f19100003 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -210,6 +210,7 @@ struct kvm_xen_exit {
>> #define KVM_EXIT_NOTIFY           37
>> #define KVM_EXIT_LOONGARCH_IOCSR  38
>> #define KVM_EXIT_MEMORY_FAULT     39
>> +#define KVM_EXIT_DIRTY_QUOTA_EXHAUSTED 40
>>=20
>> /* For KVM_EXIT_INTERNAL_ERROR */
>> /* Emulate instruction failed. */
>> @@ -491,6 +492,12 @@ struct kvm_run {
>> 		struct kvm_sync_regs regs;
>> 		char padding[SYNC_REGS_SIZE_BYTES];
>> 	} s;
>> +	/*
>> +	 * Number of bytes the vCPU is allowed to dirty if KVM_CAP_DIRTY_QUOTA=
 is
>> +	 * enabled. KVM_RUN exits with KVM_EXIT_DIRTY_QUOTA_EXHAUSTED if this =
quota
>> +	 * is exhausted, i.e. dirty_quota_bytes <=3D 0.
>> +	 */
>> +	long dirty_quota_bytes;
>=20
> This needs to be a u64 so that the size is consistent for 32-bit and 64-b=
it
> userspace vs. kernel.
Ack.

Thanks,
Shivam.


