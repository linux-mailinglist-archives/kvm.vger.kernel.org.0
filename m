Return-Path: <kvm+bounces-71927-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GAWUMJzwn2kyfAQAu9opvQ
	(envelope-from <kvm+bounces-71927-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 08:05:00 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 248011A1960
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 08:05:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CB1FC3059A99
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 07:04:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38E1838E10E;
	Thu, 26 Feb 2026 07:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="xQtoOAqX";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="dHWbRLc5"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC2E8389458
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 07:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772089491; cv=fail; b=QxDbI2TzIiUUHx/OsJWlEV7ZHzVPqpZkyuOBoBS2aE97m4VdWLwGM1+rD1e3N/6ZMv8BMFBbrvrLoB4pRXUaT7ZkGKzQUeQ/zgam1PjjYgXza3mG2AgsWI/aFKPItrZLS8jCL35MCgVQfEiq0mQNUrtSOhsfwAX30kNRoVirq3I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772089491; c=relaxed/simple;
	bh=UvK4WThGJOPx4tyFuXZXzmVLG9xkV0ZHbCSRuTWEPzg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SGqvLueIjElyG8+B7jK7yxOHJOCXQBJI9syBtkwswPqf2E2GlsM/0T6EUolDns8gAuAoygYVOsQr8HSqmfNof6iVp8ZSPOVBGijDQl8ES9mJuJDm+escCDpYhPVd5BL7/ceznWy2qnubuO16oF1mYvsQ55WzV8KoNxf4VVIsZHE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=xQtoOAqX; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=dHWbRLc5; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61Q08WwN2951284;
	Wed, 25 Feb 2026 23:04:25 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=UvK4WThGJOPx4tyFuXZXzmVLG9xkV0ZHbCSRuTWEP
	zg=; b=xQtoOAqXGjdZeZ8Ze3TvYk+dhZ5WyT7RSvVid0cHtn5TRva69s5SIl0bK
	xz2CJePjHT1W4rbtN7alFuucicRdPJEFH8XKdFAR03h6zvgMfQw/ykmx4wrBBgYc
	yTTL+P6Kc5Kr1pEOnh49KYKSAV7GFBWSKwNZ9+hB2bK3ASNuN+7cy08B9x/IIhXe
	EheRkNR+b9rfrrr/gfhyi4v/mNTQJchr+WltTnG6WjHMNTuVMpffUoUTiJOS8t6J
	NVOzwwozdBB3o90cqOdraUBmHXH0z8JdKaN4casuxXg6GgW6u9TJgn14wfSiD/Hb
	o7Gwtz9SYe+IvhamKkz4d9gu648mw==
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11022072.outbound.protection.outlook.com [40.93.195.72])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4cjbbsrpny-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 25 Feb 2026 23:04:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OHMlvjGGJdtsW8QuBAl18+wuTsRQTAqfQIoU0ZyhMSmaoS0LkSKyCgdjPpanQLsFGoMokRV67XHDUc6yBBMU5eTGvfykLazwoVeyJnvO/nEX2yxcIzs+ANtqzXbMF9B7wwiZgsMO4u5AQQEDD9mVKqIrwmI/8xI7zNd8CcxTNegp/Qoc5jDAyOn7uviesJYw/HToBTZv7SAp75eDFFB760eI4itKCMQWg6TnRDnIRQZLrzp/SNpGialq68gwp+6EdXiY9jPoJzuQeqAznb81I/I551V28sBCY35Opz7SLC5C+jiFFubuiMZ6l2dmPuXJESEfw8r7ldcqlgm5GCQdmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UvK4WThGJOPx4tyFuXZXzmVLG9xkV0ZHbCSRuTWEPzg=;
 b=BLY76VdSim8ZG9gtazjtHbwDYfaviLiwHK+rn4pr7gzjkpy4hUGRJnEoGnRHa7yvErZDSZjhz1fStQ8qO+9M2iaLlgDQiYAhlp7Oym75vLnVKzXrfBTarEwVbBZBCVjM+hpESaFkmgFs7QhaLW9UJkdOepoxqBhbINPYs9n4/1qLSA8U/9Z9qfQUP7TVbpw56rLIxMxEr6sykLH4QRixo1bE64TY0FsLHZUhRcN8KqvOZH+YQjVqkULL79+L7z5vRQfY3V4XrRLa9GTzzGC/S4mo/OTlDIqb0r+tS78KawJSvCj0hwJZV9ebt+q+FUlc0NlocLRNketOmtpeyFBoiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UvK4WThGJOPx4tyFuXZXzmVLG9xkV0ZHbCSRuTWEPzg=;
 b=dHWbRLc5wiwf6Z/3h2/KX+h7SekfW6dG40nyUhJdekjrulZ7JcoB0ozrOqvhB7kt36MOYmskFfxksuI1AWztiRrV7NpgJGJJxhGwhIr9PXBzYfbvh2+h5qpRrxXER5l90pJlTEfMNx0BiEilhQPccvecac0GT0Z9BrwKqKrfiFvILtZNPNEH/7Pv1LEF9f+XOSrlo9ADNk6WrunIL//+3K34/heEco40LR4uP82X3r/3i++c87qeAjpUSqfGxzomYBgCQhlCuAhPPh+C9/s0wIAoaOzRrhYUZIWi9G3yoOOLZifsGirFKrOas4vUFgpm2EcxekSIGQ0WdavUmpKW1w==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by DS0PR02MB10688.namprd02.prod.outlook.com (2603:10b6:8:1f4::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.14; Thu, 26 Feb
 2026 07:04:24 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%6]) with mapi id 15.20.9632.010; Thu, 26 Feb 2026
 07:04:23 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
CC: Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost
	<eduardo@habkost.net>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Marcelo
 Tosatti <mtosatti@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Sean Christopherson <seanjc@google.com>,
        "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
Subject: Re: [PATCH] target/i386/kvm: Configure proper KVM SEOIB behavior
Thread-Topic: [PATCH] target/i386/kvm: Configure proper KVM SEOIB behavior
Thread-Index: AQHcXrhurlricMg9iE6/H6LGVi6DLrUEthqAgBW2oICAeHTggIACPS0A
Date: Thu, 26 Feb 2026 07:04:23 +0000
Message-ID: <8803DF89-C418-41BC-8848-1C2AE38A0D82@nutanix.com>
References: <20251126093742.2110483-1-khushit.shah@nutanix.com>
 <F09B2DC7-6825-48B4-94A9-741260832167@nutanix.com>
 <C1DC0AAE-AE34-42E1-A15C-E03D1EE4D770@nutanix.com>
 <79f110e1-b217-4a70-81f7-d596f822dde5@maciej.szmigiero.name>
In-Reply-To: <79f110e1-b217-4a70-81f7-d596f822dde5@maciej.szmigiero.name>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|DS0PR02MB10688:EE_
x-ms-office365-filtering-correlation-id: 119063e7-628e-4ae1-b19d-08de750545bd
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700021;
x-microsoft-antispam-message-info:
 TebhtNuihwkmvQneM2nAYoWy4M1rbHh+qls6k+qOANa6+jwYXLR8qrZU3fOv13jk7AY3tkOmqgLFFd+D6Ikaa71+plb5VEG37Q8qWbDPes4czq5aBtGyCRZFNMNd89FADAQ6/LuZU5fEW0t8BJVn5yUTaO6is7+NOIL2gJ3Kqad0XpHFg8FewBfwYxpHkfA7LgXiGsgIcU3ncGGmdACUgkDGfE+wvYYxmvuA0Bd+i1SYDWOq9zmyD+s1Sn2U19nFfMCGwODb33VYwINBrzmXwzwLFvTRcbQkw6Eyr88EARiYuLC8gmSzkOaKpByMJB8E5ksgqPTGLmz5w5HoJun/6btxF66M3r0yZS7BlR6GHn8T6B1f+JYjTaODrO/ygzEkk56CiRpG8szE0muZHGeBgT9SNZowrnRYFyHcRKgGtr/aDgjpAoL8VjZtAeuVoKRUX2YoLzIVgtdC7WGaFCYo3TkmTVJnpi07wVvW1TmFXEnFgKqyjT22MyiyowKPtR1/CSZJLliHL75VFlmmaKWpENjL6luucPEcKR0sb4tGRU63gQ209FmfFqiKOq5uniWyNNhESyrdL6tZTY57Yg6Q/oIQFkcKiYGNM+ERzd/Ivs6lWepOdUQgtgDwXZ0elKfgmvrTwWHCfAgTeDaMRmAYEhawYFB9FHpXaCIntnmxSDGQ3qIF3DlxYbu0C6xczCq0s0Mzj/0Gl4lV9geedMLo893WGgxwcMMYBPHlczoFf/dIktKB3htMeQRcJezuyp5JaZXIX7sFDidYzch9bh0JZT5XgOWC+ZEARYjLhneqSLU=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?TDYwRFU3Ti8zUDNocDViZXhzS1pvSU4rNWEzN0I3akI0OVZkMlIvM3B3eWsy?=
 =?utf-8?B?enZyWXJBOFhHejgzREc0RDlvRk9mVUxhbXBweVQ1Y1o0K0RzaXZ5ZnpmYm5H?=
 =?utf-8?B?ZVIvOWwzT1VUNE1wKzdnQlVlY01tOUhjeXltSFltRE0zbGVSaHNvMDMyYndC?=
 =?utf-8?B?UytaVU5kNmcxQzlGemc4VFRFbktoK0xNa0o3aVJZeVVQWkZnK3YrS2FFUitS?=
 =?utf-8?B?Zm9BWTgrVXNtR0ZyRllvdHRjNUl2Qk53QmNwT2xjVnBaNjlCdS9VV2JPZXlO?=
 =?utf-8?B?bFI4eDVpN3lwUHpDUk9hSVlFWHU4bmtBQzcvaVROSGpmeSs0UlBha1lnZGZx?=
 =?utf-8?B?dUd3RW4rczg1L0dDN2tmM1ptNXRxVnAwVHRmMmNTbFFGeHBNWFhBbUFHZENN?=
 =?utf-8?B?UnJTRFAwQUM1bWNNZWNPUi8vczVLcWNLZWtUWXhnOC9WMXVQemw0YTBpSFpx?=
 =?utf-8?B?YWttRThHem9meG04RC9HaW5tcWRMVzJ0dm1sTG85WjVscWxlR2JPd1phQlVq?=
 =?utf-8?B?Z3M4UzJwbGhkS041dUdZZ2RobWtXMnJESzJFbllNbnh3MnBQQnQvemR2WWgw?=
 =?utf-8?B?Rlk3TjUxNUFhWVNOWlEyaUZlNGpXcFR6OWlOcW5RcDdqK0xqaWdyRUNqMXBn?=
 =?utf-8?B?aUQ3SnhzejdwTkNpcUtabGxiZ25ad2xKcnR3KzNjdXBTQjRJMllpdlh6Z0tZ?=
 =?utf-8?B?UlhGbWxJcEdRb1B1eTI2Z0RTMmN4U2hoRkVpc1l6V3hNWmZTb2g3Z2xoMSs5?=
 =?utf-8?B?ZWdaa3FXMlF5YmJiZlp3SytkVjJTNWJzcWUzMStFZjMwcnlwYkZOWkJvczVO?=
 =?utf-8?B?UWVzY05vcWQyc1E0THoxaVZPTGNJUmNucitURDJSS0NWNmxvaWVQMkt1MjRr?=
 =?utf-8?B?NUQ2d2FRTllyZlVKZDRRZXZIR3g0bGlwYjkvOHJaY3QyM1BlN2JnSEJtOVZh?=
 =?utf-8?B?YjNCamE3QWJEZ3psalVQL2hFWFBRdkpzbEJtUjV3SDlFa3JjVXRNd0k1dlZp?=
 =?utf-8?B?dG10VWs5SzNWSDljN0FNbXhHTFNjMG5ENWQxUTBHQnBGR3FpUTZDcUJTaEwy?=
 =?utf-8?B?TWo0LzlhN0hWWDdidzNxOTRqTXpodGs5RHJNallybTNKanVqVXpzcG1KZVlt?=
 =?utf-8?B?MTdMVW05NjVWK1dxZUtLa1o2SUNuVGdhcitPcC9TWVpISWNtaHNtVjF4SG1u?=
 =?utf-8?B?K0poNjlkSm5lVUpzakNJWEc5dWlhNU5ZRnBmWlRKcm1SWWhHalNsQVJhQS93?=
 =?utf-8?B?QnlyeSt4QVVHUVBZL05pUzRvQ0t3cG9odlFyZmhmd2lUN1BNOXgrS0Y0RmRK?=
 =?utf-8?B?cGc4T05VTExOSTFCL0RzNmZnZmloa3p5cmgrQTVnejdiN3g1U1RPTVlTd3BK?=
 =?utf-8?B?V05RcldUSTVSVk1aME1rVEhZV0svUTQ5RGp5Qlk0UlZZeks4V25qQU1BUkVu?=
 =?utf-8?B?YzBBMzJSY2RHazh2THNod2J0TkxTNHl1Y0E5VGNTdGNxam03Q1lJVW1EUTQv?=
 =?utf-8?B?SXRkNEJuZ1Rnei9DMnhCcHNtaUk1eGpueHU1amMrUEdlVDQwYjJBUkZQS24r?=
 =?utf-8?B?cVBRR2Z2ZEk2ajZRL2QvZmJkbGM5N3dtdDYvdlgvWmpDdi9BZnMzTXdyWU5O?=
 =?utf-8?B?cERjTGF5cm1xYy9oZXljbjhrQWorbEJjWFFiVzFMRTBwSHUxVmhPSlptVk5T?=
 =?utf-8?B?VHFXVGphM2ZhZk01dWtvSkpoQ0dsaWlzRUdLU2RyNkZ6cVhYeFpEa2pPVmUr?=
 =?utf-8?B?bEd5NGg5NDBVajd6N08xZFpkcytSSHcvL3oxbXpVOHpvOTZmQmoyYWtnQjVm?=
 =?utf-8?B?VVhrbjl1a3RaZjl0aktMVFRYTG5HVTRwOWN6VkQ2cXo3bGZFVFNETWZhTGFR?=
 =?utf-8?B?d1Y3bGpNRDJCdkVPZHVXVWRKUHdwbkE1UUkwQkJ5MHE1dnRyWForUTNvUWtJ?=
 =?utf-8?B?eWVQY3VrMXV2KytZdU1aTzcvL3VUakNZNlNkNkhlb2cvbjM2Vkh4dXoxUkZ1?=
 =?utf-8?B?WThWYmxPTjFwWEpnRTVDNmFDbVk2cEpTWml6c1hkSnpZaW0yU0JDSm4rbUlR?=
 =?utf-8?B?TnRraFJER2w1eDU3OWFqQjI2RUdmeC9sQ0FHY0RsVWREZnFtRmRpQis2S05h?=
 =?utf-8?B?Uk1uTDdmMlhIcVFzL1JTaWMybnpNMFlwVFhsUmJDUmgyS0cwNS9GMC93RXdu?=
 =?utf-8?B?eEhLeGhLRFZOMnNKSUp4VVJZTythZHpKdTB3Qy9sRUJoemhGNm5CdWdBZFU2?=
 =?utf-8?B?MFFEanVmSUZOU2oyUWJyTFM0MHRaUzdyUkVjRXhXOGUwTjI3c2taRDJTeXUy?=
 =?utf-8?B?L0Vuc1BRTGRienlYRnhrbmZiaVBrYXMrWFhCZkJvUXB5cDdVQmpFdS9NVFZm?=
 =?utf-8?Q?Qfi+L8n4/7akTuqQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7B6A3143DCBEEA4A960439B0F4C0343C@namprd02.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 119063e7-628e-4ae1-b19d-08de750545bd
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Feb 2026 07:04:23.8270
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IM9Q0HB6cl6+GcNhNjhFP5R88LykiF5J+3GvRW1frLrORFmVrhtrRC1ggIi3sCzOaV8FCB3dDu+eUVqcAgsY9hnD2d09oeI49GBTPNpJ4Gs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR02MB10688
X-Authority-Analysis: v=2.4 cv=PL8COPqC c=1 sm=1 tr=0 ts=699ff079 cx=c_pps
 a=oU/Ts+293Snq71mcenrglA==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=HzLeVaNsDn8A:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VofLwUrZ8Iiv6rRUPXIb:22 a=jxMXjlTPpCISP5mWtjnE:22 a=FjMANGMcuP__UM3ky4AA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: dN02Bq-QLMwkXdeagCmM6hC5qCJGoUXu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI2MDA2MSBTYWx0ZWRfX3hEhbpppmfdj
 IrPRGuLWUO8sOD8hVc9EUP2QDcOqJB/LZlYKQU+r5DwVN8Za4E11EKpQGKXrNACL3XQmOUHPMVz
 Ut3ECARLklZJngyzJUxA5+nEKXgMh0vvJ3zny+hRieVz2dNO/1HOBYxyUoy5MwZF3GoGGVbPdQp
 pHQsB4BmIl8RPobJ8w2uXbIA+bgwyO/Ogvq778HG9THiiF42GJ33X+fbJneLaNX0UgyyHI1rPRb
 BnhvWPWuc3xWNWvHm8qB18Ii5yU3TOD1rkqECnXouagiEge+l8m8FdANmA16SM5MhdiLPaRPD0O
 Ikdwsvu7e0MO/fzoP3dCXwmM5TKrcuM3lH5j9tPSDO274YC9QgP939Ub5wujiTi5dIiZNc34cSU
 wPWntKi7Qhs2DyT8Yha0LTrocO3rDGJc+7HNs0MuKuWJnt6w0Nze32L4vd5orQ+q5gnTvS4Y8j9
 hRf3F0Z5cwgamjpGMmg==
X-Proofpoint-GUID: dN02Bq-QLMwkXdeagCmM6hC5qCJGoUXu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_04,2026-02-25_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.44 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[nutanix.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[nutanix.com:s=proofpoint20171006,nutanix.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_BASE64_TEXT(0.10)[];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	FREEMAIL_CC(0.00)[redhat.com,habkost.net,gmail.com,google.com,vger.kernel.org,nongnu.org];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71927-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,szmigiero.name:email];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.979];
	FROM_NEQ_ENVFROM(0.00)[khushit.shah@nutanix.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[nutanix.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[9];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 248011A1960
X-Rspamd-Action: no action

DQoNCj4gT24gMjUgRmViIDIwMjYsIGF0IDI6MjLigK9BTSwgTWFjaWVqIFMuIFN6bWlnaWVybyA8
bWFpbEBtYWNpZWouc3ptaWdpZXJvLm5hbWU+IHdyb3RlOg0KPiANCj4gTm93IHRoYXQgdGhlIEtW
TSBzaWRlIG9mIHRoaXMgcGF0Y2ggaXMgaW4gTGludXMgdHJlZSBhcmUgdGhlcmUgYW55IHBsYW5z
DQo+IHRvIHN1Ym1pdCBhIHYyIGZvciB2aXNpYmlsaXR5IGFuZCB3aXRoIHVwZGF0ZWQgZmxhZyBu
YW1pbmcgZXZlbiBiZWZvcmUNCj4gZ2V0dGluZyB0aGUgcXVlc3Rpb25zIGFib3ZlIGFuc3dlcmVk
Pw0KPiANCj4+IFJlZ2FyZHMsDQo+PiBLaHVzaGl0DQo+IA0KPiBUaGFua3MsDQo+IE1hY2llag0K
DQpTdXJlLCB3aWxsIHNlbmQgYSB2Mi4=

