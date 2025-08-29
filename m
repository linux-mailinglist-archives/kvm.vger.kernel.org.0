Return-Path: <kvm+bounces-56278-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D4E2DB3B9B3
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 13:08:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9FE5C5822A9
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 11:08:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0E98311C06;
	Fri, 29 Aug 2025 11:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="emOTV/HV"
X-Original-To: kvm@vger.kernel.org
Received: from fra-out-009.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-009.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.64.237.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A8EB309DB5;
	Fri, 29 Aug 2025 11:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=3.64.237.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756465722; cv=fail; b=U/n91C6Tw/BjIEHQ5YMbm5qX9JA+74XbSEYdzRqtzxabuS3xLNjwmCgHkeVwka7dpwNioLz564e73G3T36/81/S0mQx19dk15HHQ2hT7hflBGQJHYktnoILShfeoJkylHkd/MdTLT/zmmLPQum2FZAajNR+T12Y3WutDwh2kh8A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756465722; c=relaxed/simple;
	bh=H3Gbp4PZlSfXYHyD4z+Y1zNU4+I9HCteoH9LnaC4B3Y=;
	h=Subject:From:To:CC:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=KGJZMla9xmczbZ6fB3RXBFoVWeRnq/riMvRa5u6C02O5S6IonUkhHa1IhmQMLUwNKn9ntbilr3MoE/MDq4VmmTUOiGqQ6lMB/hU0wndmx4W5rIBnWptXeZZddSiZjMqMrdluLnD8lRK/Ip6iFMX+nSh7YChw3kRblwgVKuCRfLA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (2048-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=emOTV/HV; arc=fail smtp.client-ip=3.64.237.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1756465720; x=1788001720;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version:subject;
  bh=H3Gbp4PZlSfXYHyD4z+Y1zNU4+I9HCteoH9LnaC4B3Y=;
  b=emOTV/HVPNZUbZW6EHsQcfEprnjzCaIJj7vflYpen8ywwnlppVhl05Io
   2yxiuYFk8VH+wkMhh9eFPEHgTd/IfPg0Xrn9cY8WdsuGsU/wyKWjX5XuW
   Ymn2PhXvnV20oYORwg0kBB33pjzwf+KlTbnENi72ZnlCyiIAaeY9g85pN
   4PK1vVJWXCnH4NV/XJgEPA0oNx4X9VCdSl4SmgtKKV06otUwOMmEonXtQ
   8BnnlMOHrBILruK9r25me4Z27xiNmtsQg0vmrPJUr+3ny4auyF0DhVIhX
   t8ZgqeLjO323eiGUgsqTC7s47VQZc5ne1cdfAAOyGRNNJVVogXqMcY3Je
   A==;
X-CSE-ConnectionGUID: uj47GtX7TKaWlFKgQ7wf+g==
X-CSE-MsgGUID: vERVSVXTQ1W49tUyaVsJbw==
X-IronPort-AV: E=Sophos;i="6.17,290,1747699200"; 
   d="scan'208";a="1257867"
Subject: Re: [PATCH v2 0/3] Support "generic" CPUID timing leaf as KVM guest and host
Thread-Topic: [PATCH v2 0/3] Support "generic" CPUID timing leaf as KVM guest and host
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-009.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 11:08:30 +0000
Received: from EX19MTAEUB001.ant.amazon.com [54.240.197.234:18278]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.11.1:2525] with esmtp (Farcaster)
 id 50d610eb-38ce-40d3-842a-fea5e2ac174f; Fri, 29 Aug 2025 11:08:30 +0000 (UTC)
X-Farcaster-Flow-ID: 50d610eb-38ce-40d3-842a-fea5e2ac174f
Received: from EX19EXOEUA001.ant.amazon.com (10.252.50.110) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17;
 Fri, 29 Aug 2025 11:08:26 +0000
Received: from EX19EXOEUC001.ant.amazon.com (10.252.51.133) by
 EX19EXOEUA001.ant.amazon.com (10.252.50.110) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17;
 Fri, 29 Aug 2025 11:08:26 +0000
Received: from LO0P265CU003.outbound.protection.outlook.com (10.252.50.44) by
 EX19EXOEUC001.ant.amazon.com (10.252.51.133) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17
 via Frontend Transport; Fri, 29 Aug 2025 11:08:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y+mTRMNLodqwlk56QYgnidMOleRQKpLn+wJMTCp0Vb5xZIch9G2Xn55H9gagUgQMzKIHAMPUEchCi+UhkuIwni1st9+yt3a/2Jy3I7UNmveyo2+C2yWvhzHgZ5PywlHiifn61v6pAVjDpODYRT9p7P7VWgUJSzuEzDISdXMsKboP3ssuP57A+7iWP2DOOcUPFF7NEQqF90OpmFqdj0eZCZLedU4c24uuanKUpnYKx28+HXCxjN5ivy3fao3kpU+PR2Mtl2QcEKw/ONTFjCWegp2c4kbfiHjWVPlJ6JcHfM7U27EBcO7vLetjbK9FpNP0gt9zav5ukCFTX2DccNZm/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H3Gbp4PZlSfXYHyD4z+Y1zNU4+I9HCteoH9LnaC4B3Y=;
 b=qI7ESlPgLMz2oSu1GAzhO6GNKUneDaW1pYvwuU7Z962NWN/gf1Dt/m2zosxAsoSASDkEtvqGhTE2j306SAcdmYibjIkviO9kFT0KHQbbZcbF/Qsz7DHsGHoofyCumebyXPPFrCl7m+0zkGn7l8IdXXxHY03PdUVan/SGlFWsdabURxSzIWpaR8w19fgZhl3JdJ5/DnfYDk5Qsiu/xrMb0HxTiEY6QzFYRjaZtaL73B9/TuYYpC+7gY/MfIlSkLaX5NPcX/r3qWmsGdIJelfF0SSIDcYe8ivN7KFZhxFU56oV+bZQJLBhjmuWAUNCY8zRZ3dnTXUJOdKqHIzc0UI8ZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amazon.co.uk; dmarc=pass action=none header.from=amazon.co.uk;
 dkim=pass header.d=amazon.co.uk; arc=none
Received: from LO3P123MB3308.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:10e::9)
 by LO2P123MB3725.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:128::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.19; Fri, 29 Aug
 2025 11:08:23 +0000
Received: from LO3P123MB3308.GBRP123.PROD.OUTLOOK.COM
 ([fe80::518e:6e5a:dcb5:923b]) by LO3P123MB3308.GBRP123.PROD.OUTLOOK.COM
 ([fe80::518e:6e5a:dcb5:923b%3]) with mapi id 15.20.9073.017; Fri, 29 Aug 2025
 11:08:23 +0000
From: "Durrant, Paul" <pdurrant@amazon.co.uk>
To: David Woodhouse <dwmw2@infradead.org>, Sean Christopherson
	<seanjc@google.com>, "Durrant, Paul" <pdurrant@amazon.co.uk>, "Griffoul,
 Fred" <fgriffo@amazon.co.uk>
CC: Colin Percival <cperciva@tarsnap.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, "H. Peter
 Anvin" <hpa@zytor.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Graf (AWS), Alexander" <graf@amazon.de>,
	Ajay Kaher <ajay.kaher@broadcom.com>, Alexey Makhalov
	<alexey.makhalov@broadcom.com>
Thread-Index: AQHcGMqC228trSsEXUCNLH9IE3vnB7R5iaUA
Date: Fri, 29 Aug 2025 11:08:22 +0000
Message-ID: <54BCC060-1C9B-4BE4-8057-0161E816A9A3@amazon.co.uk>
References: <20250816101308.2594298-1-dwmw2@infradead.org>
 <aKdIvHOKCQ14JlbM@google.com>
 <933dc95ead067cf1b362f7b8c3ce9a72e31658d2.camel@infradead.org>
 <aKdzH2b8ShTVeWhx@google.com>
 <6783241f1bfadad8429f66c82a2f8810a74285a0.camel@infradead.org>
 <aKeGBkv6ZjwM6V9T@google.com>
 <fdcc635f13ddf5c6c2ce3d5376965c81ce4c1b70.camel@infradead.org>
 <01000198cf7ec03e-dfc78632-42ee-480b-8b51-3446fbb555d1-000000@email.amazonses.com>
 <aK4LamiDBhKb-Nm_@google.com>
 <e6dd6de527d2eb92f4a2b4df0be593e2cf7a44d3.camel@infradead.org>
 <aLDo3F3KKW0MzlcH@google.com>
 <ea0d7f43d910cee9600b254e303f468722fa355b.camel@infradead.org>
In-Reply-To: <ea0d7f43d910cee9600b254e303f468722fa355b.camel@infradead.org>
Accept-Language: en-US
Content-Language: en-GB
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels: MSIP_Label_19e68092-05df-4271-8e3e-b2a4c82ba797_Enabled=true;MSIP_Label_19e68092-05df-4271-8e3e-b2a4c82ba797_SetDate=2025-08-29T11:05:33Z;MSIP_Label_19e68092-05df-4271-8e3e-b2a4c82ba797_ContentBits=0;MSIP_Label_19e68092-05df-4271-8e3e-b2a4c82ba797_Enabled=true;MSIP_Label_19e68092-05df-4271-8e3e-b2a4c82ba797_Tag=50,
 3, 0,
 1;MSIP_Label_19e68092-05df-4271-8e3e-b2a4c82ba797_Name=Confidential;MSIP_Label_19e68092-05df-4271-8e3e-b2a4c82ba797_ActionId=c13fdbb5-fb95-4c8b-9a1a-a05753286162;MSIP_Label_19e68092-05df-4271-8e3e-b2a4c82ba797_SiteId=5280104a-472d-4538-9ccf-1e1d0efe8b1b;MSIP_Label_19e68092-05df-4271-8e3e-b2a4c82ba797_Method=Standard;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amazon.co.uk;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LO3P123MB3308:EE_|LO2P123MB3725:EE_
x-ms-office365-filtering-correlation-id: ba71ab01-ba9b-4d0d-8ab1-08dde6ec5e93
x-ld-processed: 5280104a-472d-4538-9ccf-1e1d0efe8b1b,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Sjc3UituTC8rNEdFWlQzZkhOQ2pTM2l3ZVJIc3pEWDZjdlptSEdmaGN1Sk5T?=
 =?utf-8?B?SFEzY0NldHNRaWQraTZIdWRkN0dHSFNFMXZWRFlFbWFmSU9oRmtGUDhsRDd6?=
 =?utf-8?B?TDJyazUwUE91R00xT2EzZS9IQzZMYXBIcmlER3dkeGtWN2RWdTZFSExTTDA1?=
 =?utf-8?B?bER0R2UyOXV2aHR5ZHBQaFhKZ01uNkhjbmJNWVdLMlRPWEJwalhiOENOc0R1?=
 =?utf-8?B?RWpRS2t2c0JaUTJCZklUV21DOE5KYm1oMGhKd3hjQlJuQ1BqN2pxdjJwWFJs?=
 =?utf-8?B?ZzV4R29ZMlVWU3hxd25QMjV6S3h6OUE1YnFyZE5pSVBSU2JqVm5SVlNjZmpY?=
 =?utf-8?B?bjRLYnBCMUZzV2tEa1Vnb3hheU9kZlc2WjVaelcvMjgxZldaanJ1UVRJL2dC?=
 =?utf-8?B?ZTlGOGhJbkZxZnlkUUNZQWV0akpQWVJ0Smhta3RpN3NvK1ZObWJNMzRWZlRr?=
 =?utf-8?B?Q3NnR1RsbjBKZzQ4UkhzWlc0M056bGYwSHZEMk4xcys5d2JnN1A5c2g5NjM5?=
 =?utf-8?B?VzV5STYvaDVNY2RtV0FHanpZcTJUMTBycG1oancrUjJQMytXTDZaRklVREE1?=
 =?utf-8?B?cmwxTDk3enJCa0RRaEw3NThnWlhnYzRoazZ1dUJYMGJBQVVOS1NlQ09zZWtL?=
 =?utf-8?B?RFVGTWx4TGNGbHovTUkzVjJuZzJRSEt5eGxVUEg5WWc4MVpZSFp5Vzk4Ullj?=
 =?utf-8?B?T29ldXlBR1pHT1JOejVIUTNqMHZRQnV1WEFCdDJ1RXVZaS9KVkdkc3M5dWJB?=
 =?utf-8?B?MEgraFBGbjE4SGxDZkN4YVZKRE13Tm5mZkp4RW91QkVyN3JudGt3TmVKLzZi?=
 =?utf-8?B?enE3bTErbUNvT29nMTc5NWxiamVVall2R09CZU1oM1ZjMVhMcWVnZzVYLzgw?=
 =?utf-8?B?SzUvTXJJRkY3SW0wN2J6NW8wTUVrYitEWUs2QzYzU0hVVnFUQU91Z0tMVkRM?=
 =?utf-8?B?Ui82TnlJdVRQcUYrRFJ3dG1lL2J1blBFU25MRlJ0RkNOaWRHWUtpT0xIWkV4?=
 =?utf-8?B?T2gxZ3NvbFBVeFdGZlYzSC9raFRSZk9udmZtWUhiSjFqWkRWTkU1T2xjSnlP?=
 =?utf-8?B?NHlVMDhybVR0OTVNNWhGbnpEeGdhYzR0ZitpRGx0MGpRT2FJOXJGb1kwSFMx?=
 =?utf-8?B?SlNvdExnOE9qN0NqU21IMkdrblh6TUh1ODJDVUJDRTF1T0ZPdHRWOXVoTkN4?=
 =?utf-8?B?VHVCdVhzeWlKM3R1R2U2YnRNOGpLZXhtemd6UXlsUGtSZUV4TCtaeStlaWtZ?=
 =?utf-8?B?N2w5YkVnTDMvOWZGQWdKRFc0SWhyQUtUZHJFemJOVGt3dEhGWDNrc1IzWlpS?=
 =?utf-8?B?a1UwZ2lMbklqaktQV05aVFhSVTJzckY2N1BpaW9ic0xTUzJTbGx5RHZWL3Vs?=
 =?utf-8?B?bjBaSi92SlBqWkx0VG11YWpGMkZWMjhzODZIWnlIYkZNQzZDYUpEdnUrSk0x?=
 =?utf-8?B?K0RvV1dUWUxXdGNja01wUDl0Vi9QS2oyV0lDWW9SOXdQTDJnalNnNVlkSVBz?=
 =?utf-8?B?ZitqMzUzT212TTJ6MzhuRmJ2NUNmekVSQnlsWGJLN2VoNEZYc0xQQjF4YVJ4?=
 =?utf-8?B?K05EaEs2OXk2MFNVOUw3S0Jqek1hRjZtbDhpUGsyem0xM2lTSWFSajFicWVQ?=
 =?utf-8?B?VFIrUXVNMTZ0S2J2YmdrUVBpczV6dVgrY05qbkJqOUNJMzdiRDVCZFl2YXF0?=
 =?utf-8?B?SXd0cE1iT04zMmJxQnlSUG8yaS9vWm82UDJOQlBvQ2UvYWdiZEhTR1ZDRGFR?=
 =?utf-8?B?TEx2NVp0SUQ1bHhlaEZtcTgzbVE3VUJJWS9WT1pvZVEwUzE4TkVWaTZZTWtl?=
 =?utf-8?B?ZllmYkxsQkthLytnOXp4bGRLdzZSU29rdm4wQ3ovbnVYOVl5b09BWGF3MS9l?=
 =?utf-8?B?Zkt6WFlpaThNb2xvSFVQYm1IQWhwSWR6aXBEVkZKaDJRYlRIdTJlai9DeVFC?=
 =?utf-8?B?S25FSVVSZ1QwWm9QcE5ZbkRETTNoU3lHTWdkZzgrZkRZR0F0THJoRGlWbkUr?=
 =?utf-8?B?VnRvZE1jMEZnPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LO3P123MB3308.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YXhyOGtvTXZlNEtWbVpaUDlJbWVvdzByRjk1TVdETWRNV3dmOEFDZGRQRE53?=
 =?utf-8?B?WUp6ZzNBYXZPQTNwUkthVWlrZDRZTHpMak5OMUlxMlN0dUtSZDJmNlA2Ym5G?=
 =?utf-8?B?ZlBJd0JpMFI5eGJzWm1ENmZndWd2Z0xlRjNxNnNyMVBqVzZkR25FWDNXSlkx?=
 =?utf-8?B?SVplcnRscXpXZmJqR0t4Q0xFM20yWEVnZkxiZStqd3ZxVklqblNhNC9POVp6?=
 =?utf-8?B?MEZ5K1FrOWFTWUNHTTlJNkdFWW9JMTc5WDF5WkNHSml0S29zQmxrSGZZaTFK?=
 =?utf-8?B?bVlEYkE2dE0yZmpQTjc1Z0R0Qy9RTU5MaVcvKzI1ejZhYnRoT0gySEZpL0FN?=
 =?utf-8?B?L2JwOXo5dVB1TW5TTlgwZklSME9qVTBQelY0MFJiaXhtMkY2T0VUUW82Zzhp?=
 =?utf-8?B?MjVnb2Z2YmN6RDdyWGUzUEliM2hzU1l5Y01FalFscm5NbXJBU1FtRkhNRHJs?=
 =?utf-8?B?UkFML1pqblNlbGQyQzV6cVFUZDV6WERMaXVqS0ZLRmREMmtIR2U4TUFrTzFW?=
 =?utf-8?B?Ujc5UEU5T3ExcS9YdWRxeGdxZjlqTlJMdStNL2N6WHJGdEJKNTVzVXVkRWFq?=
 =?utf-8?B?SUIrekJBcVlFN0Q0ekU0MDE4N0ZTNWJFZmV3QUFVM1dHYTNkZ203bjA1WkpG?=
 =?utf-8?B?MGp0bDVkQVlhVFI3bjA1RDZwSmZEYUROU1EybkYwWGFtZG1jZEE3b1hIZkpP?=
 =?utf-8?B?d3dGR0FWMlhGc3lBcUtVWXdlaEdtQVR6Z0RHVkY4emE1ejRkYXYwQW9lU1FZ?=
 =?utf-8?B?dE9oYU1KS3pyME1XNXUxQlRFckdwMStKR1BOWVlidzVxTmZmamVLZm9Kcnhv?=
 =?utf-8?B?ZHdLaDhWTDJXTFZYdHBXTXlWYWxZZzhwd1J3d3RRYS9lRFVINjk2WTV1Z2dK?=
 =?utf-8?B?TU9UZmNldURQSFZLQlpVZHEzM21HRG1WTFNXSDdQRjJIZFJFS3hTelNTWndE?=
 =?utf-8?B?bTQxcFNBQkRpcUZHcjkzd2NDTGlyQm1VUXg1aHdYWnVWSG1JZ1l2WlJtb1Qv?=
 =?utf-8?B?c0Y5b3oyWmxYbVRRYnVUT1BQczc5TWkxRGRWRjJicW5Td3VCRFF3T0hlUGNQ?=
 =?utf-8?B?Nm1Nc1ZIRm5YZU5oeVJ0cWRqcmFkQTIvWm1oR2NET1NzcndkenVkMjJ6Tm9a?=
 =?utf-8?B?SldCQ0pxV3FqdXkxM2FxTXdrMlh3MXhkdnNGWGl5UERzRXZZdXJGcU9UdHRT?=
 =?utf-8?B?QjBwWjFPczQ2VFo1NThPb0grU0dWa2RabXdkZ2QwUHhINnoxR1J5S01meGtY?=
 =?utf-8?B?eVZRcGhsbzFNNHRsbzJwWmMveDg5NXBUZHFZYlNJaWhXNm9zQzVOcDlZdVRs?=
 =?utf-8?B?TDljUzhsVjU2L1hFSGd6UDc5L1BRcjBlR0NrdXgzZGtXWUVXY3FmTkpZV3Qz?=
 =?utf-8?B?dXJvTTA5MlV3Q1dCK2ZTQUlHVXF5b0tESWtZeFllTWlsN0NEUEp2VUN0aHJE?=
 =?utf-8?B?bC9LNEdzNGFSRGM2K1lUQ05LRWxxbnNvbzYrWG9rNjlNMGs0dTlYWkRyQmdk?=
 =?utf-8?B?aGxIRjJpSmFCdHRjZTZoWTJlZVhnNkVMT1dPVFk1RkQ5VUJtUzV6SjN1a2VK?=
 =?utf-8?B?dWR6dGEveXlvZ3kwKzBjQi9CQm1FZmRoOVEvaTduVHYyN29tdk80cUpldFh1?=
 =?utf-8?B?WXlMMHA5MTI2MXpWSkZrUzJBaS9iOFoyS016M2RaNmlLR1BhcHhlUUxhYXMy?=
 =?utf-8?B?Rm04Y0VvV25Ea09pNXlNU0JQVjE3NzUwbXhCRWgrN2ZXTUM2U3E4eThaWnBZ?=
 =?utf-8?B?ZTVkTlloc0tHZlNUbWlyR2xUbEJYZlZDakYwSWVXMkRMeWNuMzhhUzloVnVC?=
 =?utf-8?B?dHVnK2RoYVZDUlMvdU1Ra0FoQm8zbjBGUDVLb2UvUGgvT2xtODFwNFNKa1FI?=
 =?utf-8?B?ZVQ2dXlVUHQzeHpCRWwvbFp5UkdrR3daZW1MRm53UVk5dzNhajFZYTNkMm5m?=
 =?utf-8?B?L0RGdnhqbG5ERm9vRHA2Tmlsa0U3aHZxazRUNVVKL05zOEFOTGRVNUMzNzBJ?=
 =?utf-8?B?MXYxTTRyVjAxQWVuWjF5ZUNxUTh0Z3ZWYTFvTTMxZ1pZbk4yMkJjc2pjenhE?=
 =?utf-8?B?ZWNoMCtzaEdFckdKUTV2cUhRYkhISkRnMTJ5MzNManQ2S0t1cE5CUzRabytV?=
 =?utf-8?B?NUo4YjEwSGNGZVI5VzhvWk43S1JCa3RpN1dmVWtCVWJlRXVEZncrYllNZzh5?=
 =?utf-8?B?QVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E6226098D3CABB488861DA5A0A7DFA9D@GBRP123.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LO3P123MB3308.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: ba71ab01-ba9b-4d0d-8ab1-08dde6ec5e93
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2025 11:08:22.9499
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5280104a-472d-4538-9ccf-1e1d0efe8b1b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Qdx3UTQAmnw5MM92sXdlJDWEPXdZmyk4Qs9qvYCrkU2DtDqyJaI4sGVvd2jNV3hyS2HuLV0aQMqTyVRoS2uQ0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO2P123MB3725
X-OriginatorOrg: amazon.co.uk

T24gMjkvMDgvMjAyNSwgMTA6NTEsICJEYXZpZCBXb29kaG91c2UiIDxkd213MkBpbmZyYWRlYWQu
b3JnIDxtYWlsdG86ZHdtdzJAaW5mcmFkZWFkLm9yZz4+IHdyb3RlOg0KW3NuaXBdDQo+IOKAoiBE
ZWNsYXJlIHRoYXQgd2UgZG9uJ3QgY2FyZSB0aGF0IGl0J3Mgc3RyaWN0bHkgYW4gQUJJIGNoYW5n
ZSwgYW5kDQo+IFZNTXMgd2hpY2ggdXNlZCB0byBqdXN0IHBvcHVsYXRlIHRoZSBsZWFmIGFuZCBs
ZXQgS1ZNIGZpbGwgaXQgaW4NCj4gZm9yIFhlbiBndWVzdHMgbm93ICpoYXZlKiB0byB1c2UgdGhl
IG5ldyBBUEkuDQo+IA0KPiANCj4gSSdtIGFjdHVhbGx5IE9LIHdpdGggdGhhdCwgZXZlbiB0aGUg
bGFzdCBvbmUsIGJlY2F1c2UgSSd2ZSBqdXN0IG5vdGljZWQNCj4gdGhhdCBLVk0gaXMgdXBkYXRp
bmcgdGhlICp3cm9uZyogWGVuIGxlYWYuIDB4NDAwMDB4MDMvMiBFQVggaXMgc3VwcG9zZWQNCj4g
dG8gYmUgdGhlICpob3N0KiBUU0MgZnJlcXVlbmN5LCBhbmQgdGhlIGd1ZXN0IGZyZXF1ZW5jeSBp
cyBzdXBwb3NlZCB0bw0KPiBiZSBpbiAweDQwMDAweDAzLzAgRUNYLiBBbmQgTGludXggYXMgYSBY
ZW4gZ3Vlc3QgZG9lc24ndCBldmVuIHVzZSBpdA0KPiBhbnl3YXksIEFGQUlDVA0KPiANCj4gUGF1
bCwgaXQgd2FzIHlvdXIgY29kZSBvcmlnaW5hbGx5OyBhcmUgeW91IGhhcHB5IHdpdGggcmVtb3Zp
bmcgaXQ/DQoNClllcywgaWYgaXQgaXMgaW5jb3JyZWN0IHRoZW4gcGxlYXNlIGZpeCBpdC4gSSBt
dXN0IGhhdmUgYmVjb21lIGNvbmZ1c2VkIHdoaWxzdCByZWFkaW5nIHRoZSBvcmlnaW5hbCBYZW4g
Y29kZS4gDQoNCkNoZWVycywNCg0KICBQYXVsDQoNCg==

