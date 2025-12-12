Return-Path: <kvm+bounces-65810-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 06C0DCB7F66
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 06:45:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BADF5303FA79
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 05:45:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3879F30C360;
	Fri, 12 Dec 2025 05:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="YC/0ILqg";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="gJCf/ovb"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA2672FF646;
	Fri, 12 Dec 2025 05:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765518315; cv=fail; b=tZQeF3GQN9trOhHWKxgD2/SkIGAs15IlsHts0INjuQJFz07A5NSPxjevHGUtxWYotDxzeK6dz6PT28ZMtN8RokLxYCTfBFtlTngR471dFA+4fjWwIZQRXHCaNtMoacs8iL6SFoB9/e6NR4s9O+KOYhYzJ9Ka94OOOFv7YrStXnE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765518315; c=relaxed/simple;
	bh=yq9pLWick0Y44r+qUrnZCFyxL/1VP9FPhL8ZJeKeAoE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=oReyUlCjXAdoZc4FyvrEq/LXr6Nxsp/MW+/aUNrr57sUFrj6tr+iRHsAHSKFJT9CT/ZfuQ2qWCj5+F6YqcT2AUB9j4JJCQo5wySBHheBOVKoZC3zsC89hlANJJ1EwLhSFgC66bXVurJltVbbxofCZ72gotKrtnfi5rJQfMF+cfQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=YC/0ILqg; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=gJCf/ovb; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BC0ADVb2712777;
	Thu, 11 Dec 2025 21:44:46 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=yq9pLWick0Y44r+qUrnZCFyxL/1VP9FPhL8ZJeKeA
	oE=; b=YC/0ILqgFrvRljWxVOAbb0FaW5P+0MOIRr1JDr7i0F13TotXrFVyjaG7D
	UFYvfYT69kY9soE3R1idAOxbIxMIJgXQhzCDt1r+9cYNyZnV1t/1yV4UokGN2GLq
	FBZD5kjX1XzPkoGsGWE3toRDjj2kGEexoedoXZx1lTD6YE/Pl4VJ++yQzQHGQDK7
	S+LM23tMXx/Ec41UpIjSqiB/0duPcAFekQqSQYEdFpBTlKrRSlWTJ/xid39KiSg5
	oKX5U1DoRXXP2Wa1qQYYs2/eBRZmQ4wJO8ldEYMDyS/gKvOyv/in6nB5fa1WoyiY
	iY2gtvtuuXgtMd2StUlsMYhsfHabQ==
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11022126.outbound.protection.outlook.com [52.101.43.126])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4b08950em5-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 11 Dec 2025 21:44:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IUjr38K3SXxRrRASFMMKPLsrZ+Mw/OeHzYcIpk5Ax8ecVh6pqm1UcDPwtQDFny/e5ndi966BJpv8SKSaKCvUdUI68CRoXsuquCLsoG7g3BeIyv80iCXDL28Y2yAneHACd3N9Yzw2rg0m8hzj62PVztIccZCjbDtARuC6ScpaCLxnE7+m2OA6ikQwo/RjiJLz65JdMFmJvDXVMNM9RKVEIlGw39mI9snUB/yyynp7SUycsp+lyXgnC9uxGi8fJqF7qBVO1GJuOtlyIt3qiKn0qS0SC2DL5PvjQqOaCs4v6rCOb6LiPBai9L85lJdVPDFBgMDMFfcYUwyKZ01OMSJHQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yq9pLWick0Y44r+qUrnZCFyxL/1VP9FPhL8ZJeKeAoE=;
 b=t7niIhO7inKCjCy4OUTFx1732+zANcK8Uc8N9SDdqpbNAZhUjwYWcP1QAvO0s5RtNzfuZP1jHBLxcUMq/lugdTG8LqMV3XOQlUZ6hEOzLLhVXGlMAhYoBiNMe6nKW/KL6woGHxxSjAXK3bLHZIGOGrseObxboWBlEXOO5iKiXRlF1y4tgNRBHMipvH4klNaFA5jq3x76ZAzKZGxNrC5D8JfpM51H80R4tCqi9DOUtM29vOBf6mCxoCm6u3sx71wPv2nz/5iDvap9nEE2szSwaW85wd+/b+aY8mwXFkHT7wpC1KSsfwfAsXFqodIAaXbMbvskjqhrsiD0b+5MIIXmMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yq9pLWick0Y44r+qUrnZCFyxL/1VP9FPhL8ZJeKeAoE=;
 b=gJCf/ovb2lReiyGQ9CcRA9bMBT2AbSQXaoXo7seXk1vsOIvf3Fr3tZ+yKkYYO0mc9RhFWNW/aKzyQF4rMO28uCd/As5w+9ax2od4eRO52Ho2ZJmVpluPTsMQxwP00i++11qPML4u+atWWBCagZylaiNCF2UKdXUqw18OMY+xE9evgG6do6VYp/t1Y1QLTy4fItdnGcKItzYHSmNpL2v/SMUmpO/Jvb6ua3mJD90q/U2EyUh6b/ZPUg8tbEo1wKE/UdQQGUQZgE1Q6ue6zMz8ayQGNYjVlEYe5OrkCUP3peXNgU4IfsDwrj+DU0Ngvk7siJ9CacYhNAMGKJDxDUXBag==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by SA1PR02MB9914.namprd02.prod.outlook.com (2603:10b6:806:387::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.11; Fri, 12 Dec
 2025 05:44:44 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::27c4:c948:370:572b]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::27c4:c948:370:572b%4]) with mapi id 15.20.9412.005; Fri, 12 Dec 2025
 05:44:44 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: Sean Christopherson <seanjc@google.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kai.huang@intel.com"
	<kai.huang@intel.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>, "bp@alien8.de" <bp@alien8.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        Jon Kohler <jon@nutanix.com>,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        "dwmw2@infradead.org"
	<dwmw2@infradead.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v4] KVM: x86: Add x2APIC "features" to control EOI
 broadcast suppression
Thread-Topic: [PATCH v4] KVM: x86: Add x2APIC "features" to control EOI
 broadcast suppression
Thread-Index: AQHcao1m0m+Je6bySUSdnhU8EZf0EbUcy4iAgAC0JwA=
Date: Fri, 12 Dec 2025 05:44:44 +0000
Message-ID: <559DEB29-B0C3-4F7B-8185-114A72D35BE9@nutanix.com>
References: <20251211110024.1409489-1-khushit.shah@nutanix.com>
 <aTsUo9Fc6uu2A7rs@google.com>
In-Reply-To: <aTsUo9Fc6uu2A7rs@google.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|SA1PR02MB9914:EE_
x-ms-office365-filtering-correlation-id: d7c1b776-7764-4e31-3663-08de39418d92
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?NDI2dFQzbDVTNEl0VGNTZjZ1M1RtTGNsdXlVamtQVW92eCtlZnZaZWdMZzBL?=
 =?utf-8?B?QXJtTS9TUVV2eUtLcmFjWXBSUUF5Q0plTnhiTmtuYXRiQUlHRlhGS0FjODJJ?=
 =?utf-8?B?UmE5UXJTbXdkVFZ4NW45WjM4Uy9ZaXFvc1U4bHg1bGdIM09KaDJHM3M1c2tB?=
 =?utf-8?B?V3hFS0dXMFVuMnZYaE5KMGV2Q0k5bDd4Zko0WE5lU0QzSjFCMiswQU8zVnBZ?=
 =?utf-8?B?Zm5jWnFEK0M3RDhWcFFwcTh4bTNFZ0M0R2crYjZ0UlFLNmxESk80dFBnMmlh?=
 =?utf-8?B?cDN5UENkNXh0Yk8vY3dKUTJTK2l5M2RmdUJYVlRuKzZCM0VReityQkE4UXZk?=
 =?utf-8?B?bTZTajMyeXhZME9hSjNxNmR5OXNSQjRrTy95ZGxSM3JKajVEVXJ6QTRpS3BU?=
 =?utf-8?B?YjdRZzBpNzh0dUZxZm5scFZMOXBrSmpseW41Y1dLYWtSYU56eHArVDk4V2JK?=
 =?utf-8?B?ZWtLUW5RbGF1N2hGSjVPWUt2bFA5MDgxbDVkS0ZJYkdvd3RNOExSUzVMYlov?=
 =?utf-8?B?cHovZFpsSEgrSU55dWlMcFBoKzNzKy9JVVBJczVrNjFZN0s4Yi93UjFRRXNH?=
 =?utf-8?B?M1lKblZ3dis5b1RLZFlWZG9Sa0l1aTRHdjFHQ0wyYlVWWi9DQzBwTTkvaG5r?=
 =?utf-8?B?ZkYzeFRGRmZtVjJ0cTFHK0ZSRDNzR1FKOE13MTVaRy8yd1d1eURhVG52aVk0?=
 =?utf-8?B?UEcwQjAyd25CMTNSVEZoMG9CMUFrcUhZZEthOW9INVRKZ0hWc29tV2QxQWlQ?=
 =?utf-8?B?KytHc01pODliZ2tnREsrWWlueExtTjZZSjA5aXlYOWdYang0ZHBFaWcvdDNt?=
 =?utf-8?B?Y3FQVXBTRjVZYnVMR2NrSXRVZ0RiN1ZkRkJSWlhvcnhuRkRvRi9vYWJoSWlQ?=
 =?utf-8?B?MUMxelVrVThZY0xDQ3BienpFTUl6NDI5bDBsNEVzTFpOTTJqckJyOVU3SEhL?=
 =?utf-8?B?REJReGtjRHo0SHc0d1ZDaUhJTUFZR2pBYTJZSy9GaDZaNmNzUitvdzdZTjUy?=
 =?utf-8?B?d1h0SFVoTXpFTkxRTU5IWm9ieTZTdmdKanZEUzJVT09wY2EzNi9yZW45aEZK?=
 =?utf-8?B?QS85QVp2NVVqVEtJaEUxRzU1SUhzbDVla3EvcjZ3dHNBdi9sYXl0eVhxYUJx?=
 =?utf-8?B?cEo3SldDMFBLZkhYVEd5aW9lNWZyNEhLTWtrbzJBMUJhbGxzenRrMjY0Si9F?=
 =?utf-8?B?YW95NVdWUWEzS1VBUldBVGFDTmZLWTRQQUgwTHNTU3dYTW5NZmFFRzNpd1Fn?=
 =?utf-8?B?MEwvbG5uc3lLQzJGbkJncWRDL2hwMXFmazUrdnU1Vk5WMG40MU5MaVE5ZmZu?=
 =?utf-8?B?ZFk1REp2cDArbGFDOXdZYXhOZFA5SkJJcXd6Y2JzaWU2YWt5eHMzSGVjS04w?=
 =?utf-8?B?bWsvK0ZqWWNHV21UaHppL1ZlKzRtUlJ3K3dITXFqaEpmU25tdGpmZ2gxVks0?=
 =?utf-8?B?TGk3UkNYWWNzTXFhWW02L0tNMUFPaWMzU3RHZUp5VWdia3NCTC9pOVFlN29h?=
 =?utf-8?B?U01yU1NiVTU5Ykx3ZWJqZjFpb2NUN3ZzSTdJd1ZpcjR2RjFQMVJLVjIvaHAw?=
 =?utf-8?B?ZWppRm9EeVc0em1PRHMxNFkwRmszL3NOb1Q1TWRRNDVvVk1XYXJBWWRrRkJq?=
 =?utf-8?B?U2IyR0JpVERZZnVleFphQTZoSUp1TVZpamZGbnhZWTdpd2RLTUJ1WUhhRDZY?=
 =?utf-8?B?V0orZnA4Q0M2LzluSXkxNkZ4UnFPOTVHQ0xGeWJpSkNaVlRaTGY5UDJvb0J0?=
 =?utf-8?B?OVFTOGVVaXBmd3RQcEd3QURXVVNDRkwxeDhOcStZdHNMbklTUjdsdCtYR0V2?=
 =?utf-8?B?NzdNMm9mSVpqMDZjQWhJcExYZVp3b2NWYmxtWTZVREI0VnN1cndIMUF6bWpz?=
 =?utf-8?B?OXR0UXlmMWhxeHhWc2VjcG4rZkhTdGlFSVZ6SXBvZTBxUGlyREM3MGtMUUUy?=
 =?utf-8?B?d0NwL3VqTnZRQTRoSEtnRm1NUVJtcnhPelE1TEdGSzMzT0dScEZwU0ZwQ1F2?=
 =?utf-8?B?N3Y5VGtFUEZUcC8xOVQ4MCtKTDV6T2tVcUYydnFQbEwxSjRwWGNHdHF5cXBI?=
 =?utf-8?Q?+4Fqh9?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?blFHbnQzYlUrWHNuL2VHSzZPdHZ2MnpEa2IvSzh2NmF5Z0RlbllXMGNkYVlV?=
 =?utf-8?B?QU9NaGg0RUFjRVNJUnJFYUZpaHR5RTJoYkZpdllpK3dwNlVwRjV3Tmtnbmw0?=
 =?utf-8?B?ZXR0d2FhRWhrSTVUZ3pmcUZSTnVKSDUvbHRZSkNHekNacVRiMHpDRXZzaHNB?=
 =?utf-8?B?UkVCM0lNelNmU2l1TEhSRG5GU3pzUXBENkRoQnE0T1VBcGp1TSs4ZzhXak4z?=
 =?utf-8?B?ckYwVTRUU0JkMS9uTG1lYXNDVGNFVU5SOHR1NGpYZlZ6NmlRZXNLbUtKeGxE?=
 =?utf-8?B?eEdpQXVkcTZmTjhuODlJQWdHVVVyMTV6WjFpWWpmVUhjZmlscDJvNUl6SEZ3?=
 =?utf-8?B?VVdVaFRydmxvcnp5eVFCbFYvR29hRnBXV2VjZXhzaE51TVZDMTg2TDk4YjIz?=
 =?utf-8?B?YkhCK3pOTnFxb1FkY2EzUE1HTkVkV1ZiUzJFaVo1V093RklhTnIrMzRWTXRH?=
 =?utf-8?B?NXZXUnEySmtPbCtsVzNCdnJJQmw5bEN0ZVRmZ0xGc1dMMDdWdXFKckl3NURa?=
 =?utf-8?B?cFJiS0loT0JVOVVTUWFDZHFJL0NyZkMxaE5ITm91azEzZm14TGY4ZFpNUXpj?=
 =?utf-8?B?OXI5ekJPUm5QK0g5REhaK1Q3ZVV1VWprMFF5aDY4dnZKL2NaZm1sbVpVa2Ft?=
 =?utf-8?B?T2FOc0hGSVRweHdtVWZXMzhuS1hnSCt3WkhyeWNVeU1zT0ZlaGc2TlBaamVU?=
 =?utf-8?B?b3ZXMjl5NzhrbEsxQk5uRU5YOTVlWHlyQU92aG9DMnlKODJ1ZGhYTTFicGQr?=
 =?utf-8?B?SmZ1V0tCaWd6a01IeTJ6ZEVFT045REwrSFJLNHJtZGlqcVoxS1B4YStJbHpj?=
 =?utf-8?B?ampjTFBQZmdYZVZHaWNkMEkwSml2cERaQjZydXZyRHkxT2VWVGJ6ZUxPemJn?=
 =?utf-8?B?QjZUK29yOC9VTGxPelg4Qyt4SkFydjd6Rng0UUdOd1UyMDQvWWMwd1c1SDJ1?=
 =?utf-8?B?YVVNbVRKSzhWNXg3a01PcjNOVlViNFI1WkkrWUkrNGNaV3ZXeThUaDYxQWNl?=
 =?utf-8?B?b0RiOUx1VlprZmM5UVRIc2JSTVM2aE1CaGRURkpMRGNhK25jejkwQzk1VFZI?=
 =?utf-8?B?WEtFd0NtM01qdHh2ZTQ4dGlrdklyaStNWFV5dEZKYUlsbElSM2hFeURWMlIz?=
 =?utf-8?B?Z2dhQ1o3WEJveldraGFSQ3E3anVyYXAwcnNpcUVjNTREK093RjZhcldTNHF1?=
 =?utf-8?B?WC9Mc0M1N0x1bGt6TEJ6NmZRdFpERk02emRXV3RncVlUMk9FcUtJcjRhN05m?=
 =?utf-8?B?dU1DaENuVDF4RWZHUWppUVZtSHVackJYTXdpNXRQbEV1aEcyVTNOWjZtT1pN?=
 =?utf-8?B?Q2NEOUlwd2FRckZGS1RBN2wxVmhubUJETXRFN0dXaFZGdUthNmEyYVBaZ3B0?=
 =?utf-8?B?NG5KQmZ1OW96RTAxNFhVMVZCT2FSc1ppS29INkdsSmJVZ2prYzdFS0h5b1dV?=
 =?utf-8?B?eEpoWEhubnV6OGZ2a1lBcisrRmk2WDhTZzJFZTFXYXFMZDJQVjlLVlF4L2tw?=
 =?utf-8?B?dFB4bTBGTFpBK1I0M0FFSnhrN0tNaGJHOGxWQjlZQ2RBcExCWmlnckdPSnNz?=
 =?utf-8?B?bFUrbmhHbFI0TS90Y2NiY2xPVC95VkVXTHJqbm82TlVIVWJib0YwVGpaMS9w?=
 =?utf-8?B?WWNIbnI2MXNrQlI3MmVtbFlvcDVmSDJrSUFpcS9teFIxMWQ4VEdlVzlxcEM5?=
 =?utf-8?B?aCtZcGt6M3FxNWZhNGR5ZFY4eUI4djZUQktFK1pFZTk5eGtyMTVUdDc4UDFt?=
 =?utf-8?B?NE02WitZeGNRS096SExGZTN3c2JSeHEyOXRRbFJKSnhscFcxclFKOHRiWE5w?=
 =?utf-8?B?Mm0vcVFqbmJWTDFsMTFaWllGS2pRZnhtWWF3R2tNUTlkMVdkS21EeUF1OVds?=
 =?utf-8?B?VGZEQnFDaFV2Q0cwWXpNK3V5ZXpqZmZ0UjBML08zSDdoeW1lMEMxUnUrVmlq?=
 =?utf-8?B?dnpKaDlGRi9CcFdLcDlxbFM1NlF5Smh1bzIzVEVMOWFZMSsrN2p3d2l4azdX?=
 =?utf-8?B?SjE4N2tIa2puRk1PN1d5ZUV5T0pnK3FSb0VnTU9WNmNYczFtbWV3cis1bG0y?=
 =?utf-8?B?TWpBYVgvdXZRaVBaNzVXL2VISzZFL1RjUjRNU0MvbVBudmZDMlYySDIza3Yr?=
 =?utf-8?B?eUpaRnNCNXZlNHQ4UVhkQytmRGVQb0Z5SnArTWFxWGhPLzcwdm5obmRpSmc4?=
 =?utf-8?B?UHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <08A0F9AB0E80DD44AA67EDEFFC74005C@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7c1b776-7764-4e31-3663-08de39418d92
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Dec 2025 05:44:44.3445
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JGD65HclM9mWEc9V1ee9j4iLjvygoqqTfHWFs4mRNdEmICKRZLrzvA/g/TvVItwB1Qigo5ojG3JcwX0u1CukaeYTw6mN/Da4qiZgg5JeA0Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR02MB9914
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjEyMDA0MSBTYWx0ZWRfX/nNUylJJyHtw
 B5nHK9/oACji8z/yZ9WjjPy1JgNcjHMkE6C9GjVGwvlITy9N7q1Qeh1dtmVlSJ31YCJwbpVPLOv
 Mfra7FuQ3ebwHXQ+8SGlTy73Y4vdfOBpZYs3SQsg7XuuWNP8BV+A3bCSKDilK+gdUEbXV8THT3f
 iAZsXzJ48HIzVfJPzKyGawjA9ZtYGMJ7iV3W/Nx5bPgwNWrRVpuaRvck1rge34EEHZ/jCEBCm5A
 RVq4wGM8nzDUHtRnoCNWP4JlD8Sgcw2CMkw3bp2iIQDZjsM3u5by541m1yTfnx/5f/8MhX13enr
 3azCGSIU2ZSmoOUM+QZT0jUOT5xM4i8bQAnQAMQxZoGz5rqIN4tjQnvWk+XMZX+lW1haRiTGs9H
 hSEZ5u8PIns+9Xx2xl57MHbG5yXxrA==
X-Proofpoint-GUID: JcTtWOUPgSOMxx8TKEfXPNb2gcOUjRE9
X-Proofpoint-ORIG-GUID: JcTtWOUPgSOMxx8TKEfXPNb2gcOUjRE9
X-Authority-Analysis: v=2.4 cv=IbWKmGqa c=1 sm=1 tr=0 ts=693babce cx=c_pps
 a=WO81/b4ipP7ax+rFmsMjaA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=wP3pNCr1ah4A:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=JrUxWP808t2fPUdPwsYA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-12_01,2025-12-11_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQo+IE9uIDEyIERlYyAyMDI1LCBhdCAxMjoyOeKAr0FNLCBTZWFuIENocmlzdG9waGVyc29uIDxz
ZWFuamNAZ29vZ2xlLmNvbT4gd3JvdGU6DQo+IA0KPiBBIGJ1bmNoIG9mIG5pdHMsIGJ1dCBJJ2xs
IGZpeCB0aGVtIHVwIHdoZW4gYXBwbHlpbmcsIGFzc3VtaW5nIG9uIG9uZSBlbHNlIGhhcw0KPiBm
ZWVkYmFjay4NCj4gDQo+IE9uIFRodSwgRGVjIDExLCAyMDI1LCBLaHVzaGl0IFNoYWggd3JvdGU6
DQo+PiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYvaW5jbHVkZS9hc20va3ZtX2hvc3QuaCBiL2FyY2gv
eDg2L2luY2x1ZGUvYXNtL2t2bV9ob3N0LmgNCj4+IGluZGV4IDQ4NTk4ZDAxN2Q2Zi4uNGE2ZDk0
ZGM3YTJhIDEwMDY0NA0KPj4gLS0tIGEvYXJjaC94ODYvaW5jbHVkZS9hc20va3ZtX2hvc3QuaA0K
Pj4gKysrIGIvYXJjaC94ODYvaW5jbHVkZS9hc20va3ZtX2hvc3QuaA0KPj4gQEAgLTEyMjksNiAr
MTIyOSwxMiBAQCBlbnVtIGt2bV9pcnFjaGlwX21vZGUgew0KPj4gS1ZNX0lSUUNISVBfU1BMSVQs
ICAgICAgICAvKiBjcmVhdGVkIHdpdGggS1ZNX0NBUF9TUExJVF9JUlFDSElQICovDQo+PiB9Ow0K
Pj4gDQo+PiArZW51bSBrdm1fc3VwcHJlc3NfZW9pX2Jyb2FkY2FzdF9tb2RlIHsNCj4+ICsgS1ZN
X1NVUFBSRVNTX0VPSV9CUk9BRENBU1RfUVVJUktFRCwgLyogTGVnYWN5IGJlaGF2aW9yICovDQo+
PiArIEtWTV9TVVBQUkVTU19FT0lfQlJPQURDQVNUX0VOQUJMRUQsIC8qIEVuYWJsZSBTdXBwcmVz
cyBFT0kgYnJvYWRjYXN0ICovDQo+PiArIEtWTV9TVVBQUkVTU19FT0lfQlJPQURDQVNUX0RJU0FC
TEVEIC8qIERpc2FibGUgU3VwcHJlc3MgRU9JIGJyb2FkY2FzdCAqLw0KPj4gK307DQo+PiArDQo+
PiBzdHJ1Y3Qga3ZtX3g4Nl9tc3JfZmlsdGVyIHsNCj4+IHU4IGNvdW50Ow0KPj4gYm9vbCBkZWZh
dWx0X2FsbG93OjE7DQo+PiBAQCAtMTQ4MCw2ICsxNDg2LDcgQEAgc3RydWN0IGt2bV9hcmNoIHsN
Cj4+IA0KPj4gYm9vbCB4MmFwaWNfZm9ybWF0Ow0KPj4gYm9vbCB4MmFwaWNfYnJvYWRjYXN0X3F1
aXJrX2Rpc2FibGVkOw0KPj4gKyBlbnVtIGt2bV9zdXBwcmVzc19lb2lfYnJvYWRjYXN0X21vZGUg
c3VwcHJlc3NfZW9pX2Jyb2FkY2FzdF9tb2RlOw0KPiANCj4gRm9yIGJyZXZpdHksIEkgdm90ZSBm
b3IgZW9pX2Jyb2FkY2FzdF9tb2RlIGhlcmUsIGkuZS46DQo+IA0KPiBlbnVtIGt2bV9zdXBwcmVz
c19lb2lfYnJvYWRjYXN0X21vZGUgZW9pX2Jyb2FkY2FzdF9tb2RlOw0KPiANCj4+IGRpZmYgLS1n
aXQgYS9hcmNoL3g4Ni9rdm0vbGFwaWMuYyBiL2FyY2gveDg2L2t2bS9sYXBpYy5jDQo+PiBpbmRl
eCAwYWU3ZjkxM2Q3ODIuLjFlZjBiZDNlZmYxZSAxMDA2NDQNCj4+IC0tLSBhL2FyY2gveDg2L2t2
bS9sYXBpYy5jDQo+PiArKysgYi9hcmNoL3g4Ni9rdm0vbGFwaWMuYw0KPj4gQEAgLTEwNSw2ICsx
MDUsMzQgQEAgYm9vbCBrdm1fYXBpY19wZW5kaW5nX2VvaShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUs
IGludCB2ZWN0b3IpDQo+PiBhcGljX3Rlc3RfdmVjdG9yKHZlY3RvciwgYXBpYy0+cmVncyArIEFQ
SUNfSVJSKTsNCj4+IH0NCj4+IA0KPj4gK3N0YXRpYyBpbmxpbmUgYm9vbCBrdm1fbGFwaWNfYWR2
ZXJ0aXNlX3N1cHByZXNzX2VvaV9icm9hZGNhc3Qoc3RydWN0IGt2bSAqa3ZtKQ0KPiANCj4gRm9y
bWxldHRlci4uLg0KPiANCj4gRG8gbm90IHVzZSAiaW5saW5lIiBmb3IgZnVuY3Rpb25zIHRoYXQg
YXJlIHZpc2libGUgb25seSB0byB0aGUgbG9jYWwgY29tcGlsYXRpb24NCj4gdW5pdC4gICJpbmxp
bmUiIGlzIGp1c3QgYSBoaW50LCBhbmQgbW9kZXJuIGNvbXBpbGVycyBhcmUgc21hcnQgZW5vdWdo
IHRvIGlubGluZQ0KPiBmdW5jdGlvbnMgd2hlbiBhcHByb3ByaWF0ZSB3aXRob3V0IGEgaGludC4N
Cj4gDQo+IEEgbG9uZ2VyIGV4cGxhbmF0aW9uL3JhbnQgaGVyZTogaHR0cHM6Ly91cmxkZWZlbnNl
LnByb29mcG9pbnQuY29tL3YyL3VybD91PWh0dHBzLTNBX19sb3JlLmtlcm5lbC5vcmdfYWxsX1pB
ZGZYLTJCUzMyM0pWV05aQy00MGdvb2dsZS5jb20mZD1Ed0lCQWcmYz1zODgzR3BVQ09DaEtPSGlv
Y1l0R2NnJnI9UEdXTXlpZ25BME5pRG1UbHlQN3ZPVEhvekJ3c19WTjg2eXJWbVNNa0JwMCZtPTFQ
a1RIWkI1QTR3UnMyamlhc0g1cEJOUzdTUTVtX05TdHFoTGpkQzBRUHZQWGh1MGJ3NzFBTnA1THJP
dWg0SGkmcz1QYmVFTTB1MDZ6XzBERUsyNlkxZ1YxN1ZsQXNZN1dYOThCdjd4ajZzOUdVJmU9DQo+
IA0KPj4gK3sNCj4+ICsgLyoNCj4+ICsgICogQWR2ZXJ0aXNlIFN1cHByZXNzIEVPSSBicm9hZGNh
c3Qgc3VwcG9ydCB0byB0aGUgZ3Vlc3QgdW5sZXNzIHRoZSBWTU0NCj4+ICsgICogZXhwbGljaXRs
eSBkaXNhYmxlZCBpdC4NCj4+ICsgICoNCj4+ICsgICogSGlzdG9yaWNhbGx5LCBLVk0gYWR2ZXJ0
aXNlZCB0aGlzIGNhcGFiaWxpdHkgZXZlbiB0aG91Z2ggaXQgZGlkIG5vdA0KPj4gKyAgKiBhY3R1
YWxseSBzdXBwcmVzcyBFT0lzLg0KPj4gKyAgKi8NCj4+ICsgcmV0dXJuIGt2bS0+YXJjaC5zdXBw
cmVzc19lb2lfYnJvYWRjYXN0X21vZGUgIT0NCj4+ICsgS1ZNX1NVUFBSRVNTX0VPSV9CUk9BRENB
U1RfRElTQUJMRUQ7DQo+IA0KPiBXaXRoIGEgc2hvcnRlciBmaWVsZCBuYW1lLCB0aGlzIGNhbiBt
b3JlIGNvbWZvcnRhYmx5IGJlOg0KPiANCj4gcmV0dXJuIGt2bS0+YXJjaC5lb2lfYnJvYWRjYXN0
X21vZGUgIT0gS1ZNX1NVUFBSRVNTX0VPSV9CUk9BRENBU1RfRElTQUJMRUQ7DQo+IA0KPj4gK30N
Cj4+ICsNCj4+ICtzdGF0aWMgaW5saW5lIGJvb2wga3ZtX2xhcGljX2lnbm9yZV9zdXBwcmVzc19l
b2lfYnJvYWRjYXN0KHN0cnVjdCBrdm0gKmt2bSkNCj4+ICt7DQo+PiArIC8qDQo+PiArICAqIFJl
dHVybnMgdHJ1ZSBpZiBLVk0gc2hvdWxkIGlnbm9yZSB0aGUgc3VwcHJlc3MgRU9JIGJyb2FkY2Fz
dCBiaXQgc2V0IGJ5DQo+PiArICAqIHRoZSBndWVzdCBhbmQgYnJvYWRjYXN0IEVPSXMgYW55d2F5
Lg0KPj4gKyAgKg0KPj4gKyAgKiBPbmx5IHJldHVybnMgZmFsc2Ugd2hlbiB0aGUgVk1NIGV4cGxp
Y2l0bHkgZW5hYmxlZCBTdXBwcmVzcyBFT0kNCj4+ICsgICogYnJvYWRjYXN0LiBJZiBkaXNhYmxl
ZCBieSBWTU0sIHRoZSBiaXQgc2hvdWxkIGJlIGlnbm9yZWQgYXMgaXQgaXMgbm90DQo+PiArICAq
IHN1cHBvcnRlZC4gTGVnYWN5IGJlaGF2aW9yIHdhcyB0byBpZ25vcmUgdGhlIGJpdCBhbmQgYnJv
YWRjYXN0IEVPSXMNCj4+ICsgICogYW55d2F5Lg0KPj4gKyAgKi8NCj4+ICsgcmV0dXJuIGt2bS0+
YXJjaC5zdXBwcmVzc19lb2lfYnJvYWRjYXN0X21vZGUgIT0NCj4+ICsgS1ZNX1NVUFBSRVNTX0VP
SV9CUk9BRENBU1RfRU5BQkxFRDsNCj4gDQo+IEFuZCB0aGVuLi4uDQo+IA0KPiByZXR1cm4ga3Zt
LT5hcmNoLmVvaV9icm9hZGNhc3RfbW9kZSAhPSBLVk1fU1VQUFJFU1NfRU9JX0JST0FEQ0FTVF9F
TkFCTEVEOw0KPiANCj4+ICt9DQo+PiArDQo+PiBfX3JlYWRfbW9zdGx5IERFRklORV9TVEFUSUNf
S0VZX0ZBTFNFKGt2bV9oYXNfbm9hcGljX3ZjcHUpOw0KPj4gRVhQT1JUX1NZTUJPTF9GT1JfS1ZN
X0lOVEVSTkFMKGt2bV9oYXNfbm9hcGljX3ZjcHUpOw0KPj4gDQo+PiBAQCAtNTYyLDYgKzU5MCw3
IEBAIHZvaWQga3ZtX2FwaWNfc2V0X3ZlcnNpb24oc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQ0KPj4g
ICogSU9BUElDLg0KPj4gICovDQo+PiBpZiAoZ3Vlc3RfY3B1X2NhcF9oYXModmNwdSwgWDg2X0ZF
QVRVUkVfWDJBUElDKSAmJg0KPj4gKyBrdm1fbGFwaWNfYWR2ZXJ0aXNlX3N1cHByZXNzX2VvaV9i
cm9hZGNhc3QodmNwdS0+a3ZtKSAmJg0KPiANCj4gQWxpZ24gaW5kZW50YXRpb24uDQo+IA0KPj4g
ICAgICFpb2FwaWNfaW5fa2VybmVsKHZjcHUtPmt2bSkpDQo+PiB2IHw9IEFQSUNfTFZSX0RJUkVD
VEVEX0VPSTsNCj4+IGt2bV9sYXBpY19zZXRfcmVnKGFwaWMsIEFQSUNfTFZSLCB2KTsNCj4+IEBA
IC0xNTE3LDYgKzE1NDYsMTcgQEAgc3RhdGljIHZvaWQga3ZtX2lvYXBpY19zZW5kX2VvaShzdHJ1
Y3Qga3ZtX2xhcGljICphcGljLCBpbnQgdmVjdG9yKQ0KPj4gDQo+PiAvKiBSZXF1ZXN0IGEgS1ZN
IGV4aXQgdG8gaW5mb3JtIHRoZSB1c2Vyc3BhY2UgSU9BUElDLiAqLw0KPj4gaWYgKGlycWNoaXBf
c3BsaXQoYXBpYy0+dmNwdS0+a3ZtKSkgew0KPj4gKyAvKg0KPj4gKyAgKiBEb24ndCBleGl0IHRv
IHVzZXJzcGFjZSBpZiB0aGUgZ3Vlc3QgaGFzIGVuYWJsZWQgRGlyZWN0ZWQNCj4+ICsgICogRU9J
LCBhLmsuYS4gU3VwcHJlc3MgRU9JIEJyb2FkY2FzdHMsIGluIHdoaWNoIGNhc2UgdGhlIGxvY2Fs
DQo+PiArICAqIEFQSUMgZG9lc24ndCBicm9hZGNhc3QgRU9JcyAodGhlIGd1ZXN0IG11c3QgRU9J
IHRoZSB0YXJnZXQNCj4+ICsgICogSS9PIEFQSUMocykgZGlyZWN0bHkpLiAgSWdub3JlIHRoZSBz
dXBwcmVzc2lvbiBpZiB1c2Vyc3BhY2UNCj4+ICsgICogaGFzIE5PVCBleHBsaWNpdGx5IGVuYWJs
ZWQgU3VwcHJlc3MgRU9JIGJyb2FkY2FzdC4NCj4+ICsgICovDQo+PiArIGlmICgoa3ZtX2xhcGlj
X2dldF9yZWcoYXBpYywgQVBJQ19TUElWKSAmIEFQSUNfU1BJVl9ESVJFQ1RFRF9FT0kpICYmDQo+
PiArICAgICAgIWt2bV9sYXBpY19pZ25vcmVfc3VwcHJlc3NfZW9pX2Jyb2FkY2FzdChhcGljLT52
Y3B1LT5rdm0pKQ0KPj4gKyByZXR1cm47DQo+PiArDQo+PiBhcGljLT52Y3B1LT5hcmNoLnBlbmRp
bmdfaW9hcGljX2VvaSA9IHZlY3RvcjsNCj4+IGt2bV9tYWtlX3JlcXVlc3QoS1ZNX1JFUV9JT0FQ
SUNfRU9JX0VYSVQsIGFwaWMtPnZjcHUpOw0KPj4gcmV0dXJuOw0KPj4gZGlmZiAtLWdpdCBhL2Fy
Y2gveDg2L2t2bS94ODYuYyBiL2FyY2gveDg2L2t2bS94ODYuYw0KPj4gaW5kZXggYzljMmFhNmY0
NzA1Li44MWI0MGZkYjVmNWYgMTAwNjQ0DQo+PiAtLS0gYS9hcmNoL3g4Ni9rdm0veDg2LmMNCj4+
ICsrKyBiL2FyY2gveDg2L2t2bS94ODYuYw0KPj4gQEAgLTEyMSw4ICsxMjEsMTEgQEAgc3RhdGlj
IHU2NCBfX3JlYWRfbW9zdGx5IGVmZXJfcmVzZXJ2ZWRfYml0cyA9IH4oKHU2NClFRkVSX1NDRSk7
DQo+PiANCj4+ICNkZWZpbmUgS1ZNX0NBUF9QTVVfVkFMSURfTUFTSyBLVk1fUE1VX0NBUF9ESVNB
QkxFDQo+PiANCj4+IC0jZGVmaW5lIEtWTV9YMkFQSUNfQVBJX1ZBTElEX0ZMQUdTIChLVk1fWDJB
UElDX0FQSV9VU0VfMzJCSVRfSURTIHwgXA0KPj4gLSAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIEtWTV9YMkFQSUNfQVBJX0RJU0FCTEVfQlJPQURDQVNUX1FVSVJLKQ0KPj4gKyNk
ZWZpbmUgS1ZNX1gyQVBJQ19BUElfVkFMSURfRkxBR1MgXA0KPj4gKyAoS1ZNX1gyQVBJQ19BUElf
VVNFXzMyQklUX0lEUyB8IFwNCj4+ICsgS1ZNX1gyQVBJQ19BUElfRElTQUJMRV9CUk9BRENBU1Rf
UVVJUksgfCBcDQo+PiArIEtWTV9YMkFQSUNfRU5BQkxFX1NVUFBSRVNTX0VPSV9CUk9BRENBU1Qg
fCBcDQo+PiArIEtWTV9YMkFQSUNfRElTQUJMRV9TVVBQUkVTU19FT0lfQlJPQURDQVNUKQ0KPiAN
Cj4gVW5sZXNzIHNvbWVvbmUgZmVlbHMgc3Ryb25nbHksIEkgdGhpbmsgSSdkIHByZWZlciB0byBr
ZWVwIHRoZSBleGlzdGluZyBzdHlsZSwgZS5nLg0KPiANCj4gI2RlZmluZSBLVk1fWDJBUElDX0FQ
SV9WQUxJRF9GTEFHUyAoS1ZNX1gyQVBJQ19BUElfVVNFXzMyQklUX0lEUyB8IFwNCj4gICAgIEtW
TV9YMkFQSUNfQVBJX0RJU0FCTEVfQlJPQURDQVNUX1FVSVJLIHwgXA0KPiAgICAgS1ZNX1gyQVBJ
Q19FTkFCTEVfU1VQUFJFU1NfRU9JX0JST0FEQ0FTVCB8IFwNCj4gICAgIEtWTV9YMkFQSUNfRElT
QUJMRV9TVVBQUkVTU19FT0lfQlJPQURDQVNUKQ0KPiANCj4+IA0KPj4gc3RhdGljIHZvaWQgdXBk
YXRlX2NyOF9pbnRlcmNlcHQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KTsNCj4+IHN0YXRpYyB2b2lk
IHByb2Nlc3Nfbm1pKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSk7DQo+PiBAQCAtNjc3NywxMiArNjc4
MCwyMiBAQCBpbnQga3ZtX3ZtX2lvY3RsX2VuYWJsZV9jYXAoc3RydWN0IGt2bSAqa3ZtLA0KPj4g
ciA9IC1FSU5WQUw7DQo+PiBpZiAoY2FwLT5hcmdzWzBdICYgfktWTV9YMkFQSUNfQVBJX1ZBTElE
X0ZMQUdTKQ0KPj4gYnJlYWs7DQo+PiArIGlmICgoY2FwLT5hcmdzWzBdICYgS1ZNX1gyQVBJQ19F
TkFCTEVfU1VQUFJFU1NfRU9JX0JST0FEQ0FTVCkgJiYNCj4+ICsgICAgIChjYXAtPmFyZ3NbMF0g
JiBLVk1fWDJBUElDX0RJU0FCTEVfU1VQUFJFU1NfRU9JX0JST0FEQ0FTVCkpDQo+PiArIGJyZWFr
Ow0KPj4gKyBpZiAoIWlycWNoaXBfc3BsaXQoa3ZtKSAmJg0KPj4gKyAgICAgKChjYXAtPmFyZ3Nb
MF0gJiBLVk1fWDJBUElDX0VOQUJMRV9TVVBQUkVTU19FT0lfQlJPQURDQVNUKSB8fA0KPj4gKyAg
ICAgIChjYXAtPmFyZ3NbMF0gJiBLVk1fWDJBUElDX0RJU0FCTEVfU1VQUFJFU1NfRU9JX0JST0FE
Q0FTVCkpKQ0KPj4gKyBicmVhazsNCj4gDQo+IEFnYWluLCB1bmxlc3Mgc29tZW9uZSBmZWVscyBz
dHJvbmdseSwgSSdkIHByZWZlciB0byBoYXZlIHNvbWUgbmV3bGluZXMgaGVyZSwgaS5lLg0KPiAN
Cj4gciA9IC1FSU5WQUw7DQo+IGlmIChjYXAtPmFyZ3NbMF0gJiB+S1ZNX1gyQVBJQ19BUElfVkFM
SURfRkxBR1MpDQo+IGJyZWFrOw0KPiANCj4gaWYgKChjYXAtPmFyZ3NbMF0gJiBLVk1fWDJBUElD
X0VOQUJMRV9TVVBQUkVTU19FT0lfQlJPQURDQVNUKSAmJg0KPiAgICAgKGNhcC0+YXJnc1swXSAm
IEtWTV9YMkFQSUNfRElTQUJMRV9TVVBQUkVTU19FT0lfQlJPQURDQVNUKSkNCj4gYnJlYWs7DQo+
IA0KPiBpZiAoIWlycWNoaXBfc3BsaXQoa3ZtKSAmJg0KPiAgICAgKChjYXAtPmFyZ3NbMF0gJiBL
Vk1fWDJBUElDX0VOQUJMRV9TVVBQUkVTU19FT0lfQlJPQURDQVNUKSB8fA0KPiAgICAgIChjYXAt
PmFyZ3NbMF0gJiBLVk1fWDJBUElDX0RJU0FCTEVfU1VQUFJFU1NfRU9JX0JST0FEQ0FTVCkpKQ0K
PiBicmVhazsNCj4gDQo+IGlmIChjYXAtPmFyZ3NbMF0gJiBLVk1fWDJBUElDX0FQSV9VU0VfMzJC
SVRfSURTKQ0KDQpTZWVtcyBsaWtlIHRoZXJlIHdpbGwgYmUgdjUsIHNvIEkgd2lsbCBpbmNvcnBv
cmF0ZSB0aGVzZSBmaXhlcy4NCg0K

