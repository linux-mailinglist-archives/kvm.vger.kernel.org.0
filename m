Return-Path: <kvm+bounces-48665-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 90C34AD0629
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 17:52:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D65EE3B5333
	for <lists+kvm@lfdr.de>; Fri,  6 Jun 2025 15:50:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3359928AB07;
	Fri,  6 Jun 2025 15:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="cHkiLrbk";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="CSFEcP07"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD12E45009;
	Fri,  6 Jun 2025 15:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749224739; cv=fail; b=mbh6CD5rkLUyDglcWI6krlU2/H7GNVAzTZfIzuI5EURBEW5IvTic1X0vEefz2yeaCwot4kzacguJrCeNcUHkysgSo4y6zHkXy0e29S+W/pNp8E21T+nZiOUKJ5KemnLmEBfIckAp3W0mi/ss5FffhL7VYNZH3wVbgujttO3ivWE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749224739; c=relaxed/simple;
	bh=J/sZYcIWtV8RMt3wyyAPl6QNpmqggyhK/UQZVw9NB3o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZrIRSfjW61vDFYch0X8BwMXMh4XQDeAQerW99Ioh6AohlXlEpOWZXTE1qo0WLQLDpNau7IzfIP1m6zp/Ssx/nvqG6yJzzdD/F4XYJidrxplYHkjkpXkJ3rWriIvS+zNfbBn9/aCBBieeL0zttcKeppjdn/IfAk9hb/9QXx/J12Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=cHkiLrbk; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=CSFEcP07; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5567L1RS008912;
	Fri, 6 Jun 2025 08:45:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=J/sZYcIWtV8RMt3wyyAPl6QNpmqggyhK/UQZVw9NB
	3o=; b=cHkiLrbkZ2yOTjkjdsaa1cPPccQ5p/pLUoeVBMCu59YysdrU8hbFzYTld
	OYXMDfwYTF5K4SoreoNNbgcoMcEUq/xXMjGlF5LWyl3xLQoIvy74q4UUYKNf/onJ
	RfjSgTlCiK8w5HOAjQXl1eLVoY/IS1+iJjA+mjWvRTI/YCuVSljRe9gRBmaMbV/h
	NOVoebKCjTjqaUUdlmmKRQ1SuL5Mh7Rx7f2nnhTG1roha9PyAa0uqC30rgg862Up
	64HVtJvCtb2S9rls43zI8/G8bpaE0xmii4Yb/zCWTCRWcN1Gi7E0zW5CTqhSnWKv
	qScyvMfijN1yBl/+ssphhfh+OSG0Q==
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11020105.outbound.protection.outlook.com [52.101.61.105])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 472t28d3wp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 06 Jun 2025 08:45:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sYtqfHk7ClS23wAsaWp1MHwbP3n9wQdAavH2CCvniA/2t8KQEqXY7B+fFLHQPWI9wDMLN0HNG/5fkcS+HclmLsbUDGPHnfPpsBOkyHCTWKhJ1W9zCoNMs9yv+c9r7zU9HI4cs4imjJxFehwTMfYHhEFf3kds+2NDw6+RLW13rGC2gzkWLqOM+zGjnhB51j7ZjsTDf4XxYc7TW/olv5EPLv23p4yPlDGmtBzNmj1BAnxIvJrCB51a3G4y6MYgR9VXdj0pngHYOaQPH+bgFjW8gnOP9BFsfGou/whX3NXoDz9iDgWZ1gSLdUZuQ2utzlSfNqrNQFIRCt28wd6Oup5nDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J/sZYcIWtV8RMt3wyyAPl6QNpmqggyhK/UQZVw9NB3o=;
 b=tTZVHJimAzPc4W6WUOr1ZXDC+SJAjA5CCmCT8R3T5wIx1vq9p4lGVkP4o4dGIJhkLDl9FjSKRpSBgTWi4XuJvIB+ZQadgrGOoqeo8ieEATdVHXlaIDwUTiMSN/sXxT2/drRiqdoNdJ+9wYGyBByo5Lq2siyQk11WXDru/hhKWrFJV3nv+dlcp+/NJJdnuUzJ9IG98PrepytvDbH8MDlzxjMKp+JkLljX+QWtGkg+FkQr0XjDlDkzwBVaHtTYou7G5Rca5aMimcVxdLZ9wj206pPSxwWB+7lRnTq8npHiG1qYy/SAryqkYhZ3FBjDPhxcwhpjM+RmNVDRbJlK8e8o4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J/sZYcIWtV8RMt3wyyAPl6QNpmqggyhK/UQZVw9NB3o=;
 b=CSFEcP07hqwgrTD8TB/RpAe5dAGhSIYKUJKuHPPtmpLv4n8+tv6O0W0zm9CiDCpkTMnHM1QJHBl+viptLYO9Wy/WeaF4rx/6JPT43cflRSsPdbBF+zygIW5rPlXFCEN/C7h7gXyyt3Hk7LbnLUJpP+XzozTw7ZJ/chDWo4LzKexbt8+16Oa5y6vvtEFtgSb4iH4oYoS0u5XehPYqzF9r3ghwSz2Pn0S/WSW9BpX9yFGozpjzreTAqbLT2Gys3n6cMCRfjP9NRohCxh5ncRP2Y2OLUqGfO6q14YD3VnbWfShgdb2Vh+strga/mh1qfOgfahIPo7+SysNnAqR7EWR0YA==
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 (2603:10b6:408:1fa::10) by PH0PR02MB7704.namprd02.prod.outlook.com
 (2603:10b6:510:53::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.24; Fri, 6 Jun
 2025 15:45:21 +0000
Received: from LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054]) by LV8PR02MB10287.namprd02.prod.outlook.com
 ([fe80::b769:6234:fd94:5054%6]) with mapi id 15.20.8813.020; Fri, 6 Jun 2025
 15:45:21 +0000
From: Jon Kohler <jon@nutanix.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
        Sergey Dyasli <sergey.dyasli@nutanix.com>
Subject: Re: [PATCH] KVM: x86/mmu: Exempt nested EPT page tables from !USER,
 CR0.WP=0 logic
Thread-Topic: [PATCH] KVM: x86/mmu: Exempt nested EPT page tables from !USER,
 CR0.WP=0 logic
Thread-Index: AQHb1BjpL7ey8iXfDkWgZ+PYbYD1nLP2S3+A
Date: Fri, 6 Jun 2025 15:45:20 +0000
Message-ID: <AB0DED95-EAE9-4371-AEBF-9BE212AE3B05@nutanix.com>
References: <20250602234851.54573-1-seanjc@google.com>
In-Reply-To: <20250602234851.54573-1-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-mailer: Apple Mail (2.3826.600.51.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV8PR02MB10287:EE_|PH0PR02MB7704:EE_
x-ms-office365-filtering-correlation-id: 50a07e9b-3fd6-44ac-6a55-08dda51124fe
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|10070799003|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?VFk5cmUxK0NqRUdJVGJ4MjlqM3FuUlltR21LcGErV1NjSE9UYi9ZSUp1N21k?=
 =?utf-8?B?OGlxbkxrYWZUNnAzeVp4STVnNFd1WXZyRmlyeGdaMlM4RHJGbDdnNmo5U3Rw?=
 =?utf-8?B?aUxlNW85ZVhYVE1jZUtuSE5NaXo5dUxGUTZVREI0UjdhcnNoOFdWU25JeitJ?=
 =?utf-8?B?RkJxc1ZPaU9MamlneithSE9RbFRWMnZ2N09hTHpCc3hkWm10VCtQa3ZLNGp3?=
 =?utf-8?B?RFJuZjQxS2hMTXJXb1BnWFBhUUZyL1g1c2xYWS9rMm0zOHFyVHZlL1MwK0t2?=
 =?utf-8?B?UjhBSEZIOWNrdm5ZRG03QWRyOGdYb1kyNzV1MHhjUjhHd0daUTA4MXltaENR?=
 =?utf-8?B?V3dVdDd6L1lmTWk0R1p5bjU2cXg4ZG1sVnRCSzdTbUdkTkZVcDZnMkFkdHZh?=
 =?utf-8?B?NWVOd1psTnNlS3JISjErNXhjS2NDeUx6c0NhenBnenNSRTdTK0pDVlJCNzVF?=
 =?utf-8?B?WWNnK3hGOCtucytCaFZFNm9mREJTOGMwcWF0aXFMYkRNOVlTY2VnSUQxQk9Z?=
 =?utf-8?B?QmZhQ1lWYVVpWVRDYVJxQklGOUZMV3dpUDBTODFCamtIZWtUZDF2OW90Qm93?=
 =?utf-8?B?cXp2ZzRENm5na0E2M0UxQ0VwL2poZXRLQ2w0Ym9NY015NDFUVnIyb2xuZUJQ?=
 =?utf-8?B?RHF6UGlBVHFOTithZWNKSWJBdW8xeitmUjErVmo2REZDK2JneFpXcTdZS25L?=
 =?utf-8?B?VEtQM1B4MWhBU2VqUUJIWFZzcytLS2I5UlFCNHB4YXNqdUU5czRjakxNOVBa?=
 =?utf-8?B?b0hld21vN3NZVlhCa0ZYb0syL3pPOHdEYzgxWTdtU0NDRW13VG1mVXFXZjdG?=
 =?utf-8?B?RUUvQURobUlYUUdvUVIxRHYvdVFSc2dZRVBIQVpvUE80ZmMzNzFaZlNPS2Ny?=
 =?utf-8?B?Z2h0M1dMaXdkSnpvRGQ2YU1IOVJ2emFsNkt3V09NaGJDbVl1RjhubHlHbGp4?=
 =?utf-8?B?R0s0ZW54NUVmWEpLYXZqV1ZKRExlNHRYaWJoV0UwTGFyR3BrMk5TWHMyVTJB?=
 =?utf-8?B?ejBITnJRWmx5MnBtaTZZRkg1R3BoNDVhY2UrN0J3aG12YzlVRyt3dEtpdEdI?=
 =?utf-8?B?Z1JXd0FIVmRtSjcxOXlRaFY2WGZPNzk3Mittd3pOVGVwbEF6cUNwUTJUTlI4?=
 =?utf-8?B?R1lUUjhodnpsWVJrMWlIdU45UktZY3pQelNEODdyQ2VvYVN3Qk5RcnZINjNH?=
 =?utf-8?B?YUR2enNydDk5eXFhOVV3SlRxQUpKcTNHdjNmdUJ6cDk3bnZDWW9VNVRIV3hQ?=
 =?utf-8?B?dnF4WWxDMTJPdjZUanRmR0lOZDJ2NGk2d0RlTXZxVGpEb3RoRDg2MURmUXpG?=
 =?utf-8?B?b3MvTk9OUjQzWlcyQnFPU2JsNXFscUIzQ1RFMURhbWpvNmJ3M2NKR0pWd2hp?=
 =?utf-8?B?V09TVnZYb0lvTlhmVG9xZHE5MTUvOWpmZ0kxQWQwcURmZ2FoZHdRRTIvUkNR?=
 =?utf-8?B?Q0l6cUlJSENJeVZ0WVl1cW5hMDU3N1JJK2JEcEdkMFd3aGhqd2VNU3dHQzhK?=
 =?utf-8?B?QWREaThraERUeVZuSDA1ZUpET29jZHE2ZWZad0QwUlNaQ0hwdjIrQkJVRzhR?=
 =?utf-8?B?SkptZzA1blU2KzFSMy90bmlYQjZPcUtoUEsrbGZxSFBlQUNHRnk5TUREWjZD?=
 =?utf-8?B?aGwvRU1qb0REd2JQWEE0T2NweGNXSXVObUFxZUIwZW1Lc0xIR3VoVEhFZGk5?=
 =?utf-8?B?dkdRU0xoaW1LelVuWTd2TVgzNmtrTjF5TjJWVDlMSHJCNHpkWFNBT1BqeUlJ?=
 =?utf-8?B?d0RoeEVzaXp0VmMvNXpWOEpyRHphYnh1NkFmYUtkOWFERlVUa1l6Q1krM0Nr?=
 =?utf-8?B?eDBVdzFxdllJWk1SVElreDkyQ0R6RXR5RlRjSjNGVGRtUmpwdytzVlFhLzN5?=
 =?utf-8?B?RTM2UFVJU0pTOFhNK2VXaHJlTmFXbGswbHp1Wm1LM0t2djBaMG5udjFrTVdM?=
 =?utf-8?B?b0UvTkNINEROU1VsTHc4eEZoeGpsSnBLTFFGRExwd240NWhiMm80b0xCNTFE?=
 =?utf-8?Q?vppVPq7XAIC/M4DiF7qZLUKn1hP0ig=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR02MB10287.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(10070799003)(1800799024)(38070700018);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?cU90cUUrNk5xZ3hWWGZON2c3UEExdVZDK1h0NFlwaDJ0UVdsdmU1RWFpTDZ2?=
 =?utf-8?B?aFNyeWhBMHRUNXpKcmtwMGFnQ1BtZnlHQUZHUEk3YjVmNTVlZ2swb3lWWHBq?=
 =?utf-8?B?MmFFbkxkbFhFQURjUXpMa1E0SXVINitXVGNucXU4dG5hUXdsSHR0L1IxRmE2?=
 =?utf-8?B?bHBsam4vZytac2Vubm9sK25icHZ2eEFxdmxsZkxRbjRWcEU3Wk1OVFBJMEZa?=
 =?utf-8?B?QVk3Y3R4MTNGbkNDRDk1UkNQSllaL0Z0ZGZqZlBVZEkxbHNiVTZTYm03dlhs?=
 =?utf-8?B?dUJDazAwcTl4TCs3SHM2Tmg5TmV4SzVSd0tNdTdZa2p2bVY0Smpod3RGeGNk?=
 =?utf-8?B?cTNJeW1nU243RHZpaWVxb0puYnpNS2MrODZ5bStGS3lpOWE4THB2akFZajZl?=
 =?utf-8?B?MkhqQk40OVUyVmU4aHN0SnVkNjFSZWFQWmtSSTVsdzk2TTdPUFl4Vkl4cDAx?=
 =?utf-8?B?NCt2aHlOZjAwaUpLS2ZTbkx3Q1Q1VVJjSTJRTmhmSEliN29ReVlyTm1uSWQz?=
 =?utf-8?B?SkptSUFyeTJEZ3lQVlVnM2tmMVdoWHF4dkl5VzYrNXZtZk9iWldtcEU2Vm1w?=
 =?utf-8?B?MnYvbEtuOFRiUHlpS2ZPa1d2STZlT1UzZTJ1WnkwQWprYVNNbkJ2SkVCUlpY?=
 =?utf-8?B?ZWRKMkEyUUR2WGZEVW5BSVFkUENqMmlTMjNDYU85alZyR0NyODE4R2h0SDBU?=
 =?utf-8?B?OEIvb2RaRFhPU3lCV1docHBqcTE4Y0V2blF6MU5LMGlGbmFVTElLUjU2YXhq?=
 =?utf-8?B?d2hReWRZZVZoYVIzR1NBakk4RnZBdTYrc29lczhjZGg3cFBOVkR6QmY5UFFx?=
 =?utf-8?B?WmdXNnFya25DaGxFdkZxUllDRjZxeVlwYnExZzZ6Ujhzdlk1OFZEUVVUUDFF?=
 =?utf-8?B?MjMxUCtFU0dnSk11OWtkMzhXR1lxeGhOcTlsbDFUUG91Y0FBMVU0TGo3MEtD?=
 =?utf-8?B?SXE2K3p3V1JiR3pJTVFYZW1nY0UxM3RrQ2FUZmxFQjA3MWZsRTFKNzBzY1pJ?=
 =?utf-8?B?dXl3VDBMUHRpRnFHTDBnbVg4WTJDTVhFVlQ2ajJSc2tKWlN6b3VQTGJ1Ym5G?=
 =?utf-8?B?cDNuZmxWbmNPZkY5eXBER2ZSaFZlRmIxbUVkSzFxRlhYNnBaYjlpUC90RTdq?=
 =?utf-8?B?OXJHRWl1eXA5SGtEblNYRDhmTm9VSEErQUVIVmdzczUyOTNkY2s5eGJ5Y1h1?=
 =?utf-8?B?ckdqbmNqZkFpcERzTkFCNWgrWDM2QVlEYkF0WVF1R1hhN0thSnlSUUc0RTUr?=
 =?utf-8?B?d2cwY1dsQUlCMWJTQ1BSL0V6R1FBSVBJRFBlaTl1NFlSM1dUdU9DSjJaaHkx?=
 =?utf-8?B?OUFRZUpIbUdvaEgzVDRhVk02OU9yanBlWjNjb2doODM3b2xBalh6YVVUa09K?=
 =?utf-8?B?WGVFT3oyWVBPV1RkQ3luRkIzdVV6Y2J5QTArVmxWZldEUGVmQXlQUGw0UTIx?=
 =?utf-8?B?MGx1Ym9JZ01TTU0wcW9uV3k1bHRGWHByamg1UmYzdGlZblBBdHowY0FsWUlF?=
 =?utf-8?B?WWpmUVhLQkdsYTA0cGdDRjByaWgxRzl4RmY4QUFIVmNSaUk5bnN4bUhVTkw3?=
 =?utf-8?B?Wmx5K0R6dStPUytBM25ZVGorVXY4enQ1UE4ranlqVW43WG9JQ1ZlRTJ4OWpj?=
 =?utf-8?B?NHhibVNhQms2dTg0WXJRRi9LdXdCb0IzRnd2bE05K0JZWDR2ZGVwNTBLdmZM?=
 =?utf-8?B?OUhYcDdBamRXQVltTGI5bG1Id1YwU2xrbFdwQ000MldIc3IyRytxZFZtNjho?=
 =?utf-8?B?UHpXcmFkUnFENWt0aTdWa09hcVV3ZmpFampac1dXdWplL08ySGxXL3B0anIx?=
 =?utf-8?B?L3dDNTRXaHg3K2hZc3A0eW1rQnc1ajVrSktqS0EzSlJWbU9QSVo1OXJQYlVU?=
 =?utf-8?B?QXVpWDN4d2o3NU9IZDBMZldsUVdMYk5BeWF6Q09UQUd3bHpDUjMrSjhsaENm?=
 =?utf-8?B?bVUxYkJaTy9BS0lXOS9MWXNEazhQdkNmTmw0ekd0NmVPaEtqK25zcTVmYkZZ?=
 =?utf-8?B?YnpTcXdnZGNwS0puZWcxNSs0Z3p0ekxzZHlEUnFPWlIrSGQzSEQ0bEZBUlpt?=
 =?utf-8?B?KzRyK2NaQkl3RndSYzZ6dGZrckhUbm9ORjFxWVJTenQyUGZPQ0t4eWpDMDVZ?=
 =?utf-8?B?V1NLYTZ1VjdpSEdDYVRpQ0gwMmRFbFAwSW1aK3hhM3N1MldGNkFqNWgwSG9F?=
 =?utf-8?B?cHNHVzYxVHIyKzlDckE5Z2RMdzRsc0tLZi9DWXJkdXcwYjZWZ2ZGN1MxN2VO?=
 =?utf-8?B?cFpwV3RDSS9oS2R6blBtWEpXMmlnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3813D8DDFF82CC43A7C51B1A9E4950E3@namprd02.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 50a07e9b-3fd6-44ac-6a55-08dda51124fe
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2025 15:45:20.9923
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dRO4MqVXeTNePmDk3jFzREKswrjd/HD0Bu2drIJpp8qzgr+kKb4ZSBoY/mFk+xvYy2mHCnPz3TZYZS/7wqlIMIgJY1lBp05hbacKSXwWa8E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR02MB7704
X-Authority-Analysis: v=2.4 cv=ON0n3TaB c=1 sm=1 tr=0 ts=68430d16 cx=c_pps a=SfbXOumlQYQ7ptoTXzRROw==:117 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=6IFa9wvqVegA:10 a=0kUYKlekyDsA:10 a=1XWaLZrsAAAA:8 a=64Cc0HZtAAAA:8 a=Ja9HPyursiWi4vRtUWwA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjA2MDEzOCBTYWx0ZWRfXzc1IjTzZ4a7w 7AGscKlch3lor9ssxzR7xnNiTyk0UQ0kZWYSW6bm57w/+F5fFwQtArkoxKSSvF6X9JiVAuIwmwJ jEZFpuWC1yh/xvs8hT3mURNIvW7n2OwbVzP1gXWcbmPkgaYx6Q+9YiuiIsxQhlrjLr9Rm7ML0kA
 TdP1fDBMFo9h+2boihOza90cCTltLzxshOzXS7A9+7k+/Xst63tQBAsqLhlYAAR0QG/mhKQbcwJ 1sA1dSUMIfRCWWx3sIeG7YeUHRO6Jfr0Eh0bI6HaQQHaHteQZbY38D7AVcBJkl23SaTdZAPxx1W 96jpDp/YPvP3YTLTnPUuvjnJgtuhKM6Wi52CrtfluECDNED8ZQoIqm8YTk/ccPk2bR8X2E3hPEw
 TBtdemA9LoMdqQFd2c2/Q5tX/m+0KWSQvpAVyQyEHLQuAVWDzsgfzE1DgBvxWl3qRhL5vdLE
X-Proofpoint-GUID: R-smGXwu74-FTNOW-nvDHCN0LfRss6cH
X-Proofpoint-ORIG-GUID: R-smGXwu74-FTNOW-nvDHCN0LfRss6cH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-06_05,2025-06-05_01,2025-03-28_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gSnVuIDIsIDIwMjUsIGF0IDc6NDjigK9QTSwgU2VhbiBDaHJpc3RvcGhlcnNvbiA8
c2VhbmpjQGdvb2dsZS5jb20+IHdyb3RlOg0KPiANCj4gRXhlbXB0IG5lc3RlZCBFUFQgc2hhZG93
IHBhZ2VzIHRhYmxlcyBmcm9tIHRoZSBDUjAuV1A9MCBoYW5kbGluZyBvZg0KPiBzdXBlcnZpc29y
IHdyaXRlcywgYXMgRVBUIGRvZXNuJ3QgaGF2ZSBhIFUvUyBiaXQgYW5kIGlzbid0IGFmZmVjdGVk
IGJ5DQo+IENSMC5XUCAob3IgQ1I0LlNNRVAgaW4gdGhlIGV4Y2VwdGlvbiB0byB0aGUgZXhjZXB0
aW9uKS4NCj4gDQo+IE9wcG9ydHVuaXN0aWNhbGx5IHJlZnJlc2ggdGhlIGNvbW1lbnQgdG8gZXhw
bGFpbiB3aGF0IEtWTSBpcyBkb2luZywgYXMNCj4gdGhlIG9ubHkgcmVjb3JkIG9mIHdoeSBLVk0g
c2hvdmVzIGluIFdSSVRFIGFuZCBkcm9wcyBVU0VSIGlzIGJ1cmllZCBpbg0KPiB5ZWFycy1vbGQg
Y2hhbmdlbG9ncy4NCj4gDQo+IENjOiBKb24gS29obGVyIDxqb25AbnV0YW5peC5jb20+DQo+IENj
OiBTZXJnZXkgRHlhc2xpIDxzZXJnZXkuZHlhc2xpQG51dGFuaXguY29tPg0KPiBTaWduZWQtb2Zm
LWJ5OiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbT4NCj4gLS0tDQo+IGFy
Y2gveDg2L2t2bS9tbXUvcGFnaW5nX3RtcGwuaCB8IDggKysrKysrLS0NCj4gMSBmaWxlIGNoYW5n
ZWQsIDYgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9h
cmNoL3g4Ni9rdm0vbW11L3BhZ2luZ190bXBsLmggYi9hcmNoL3g4Ni9rdm0vbW11L3BhZ2luZ190
bXBsLmgNCj4gaW5kZXggNjhlMzIzNTY4ZTk1Li5lZDc2MmJiNGIwMDcgMTAwNjQ0DQo+IC0tLSBh
L2FyY2gveDg2L2t2bS9tbXUvcGFnaW5nX3RtcGwuaA0KPiArKysgYi9hcmNoL3g4Ni9rdm0vbW11
L3BhZ2luZ190bXBsLmgNCj4gQEAgLTgwNCw5ICs4MDQsMTIgQEAgc3RhdGljIGludCBGTkFNRShw
YWdlX2ZhdWx0KShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHN0cnVjdCBrdm1fcGFnZV9mYXVsdCAq
ZmF1bHQNCj4gaWYgKHIgIT0gUkVUX1BGX0NPTlRJTlVFKQ0KPiByZXR1cm4gcjsNCj4gDQo+ICsj
aWYgUFRUWVBFICE9IFBUVFlQRV9FUFQNCj4gLyoNCj4gLSAqIERvIG5vdCBjaGFuZ2UgcHRlX2Fj
Y2VzcyBpZiB0aGUgcGZuIGlzIGEgbW1pbyBwYWdlLCBvdGhlcndpc2UNCj4gLSAqIHdlIHdpbGwg
Y2FjaGUgdGhlIGluY29ycmVjdCBhY2Nlc3MgaW50byBtbWlvIHNwdGUuDQo+ICsgKiBUcmVhdCB0
aGUgZ3Vlc3QgUFRFIHByb3RlY3Rpb25zIGFzIHdyaXRhYmxlLCBzdXBlcnZpc29yLW9ubHkgaWYg
dGhpcw0KPiArICogaXMgYSBzdXBlcnZpc29yIHdyaXRlIGZhdWx0IGFuZCBDUjAuV1A9MCAoc3Vw
ZXJ2aXNvciBhY2Nlc3NlcyBpZ25vcmUNCj4gKyAqIFBURS5XIGlmIENSMC5XUD0wKS4gIERvbid0
IGNoYW5nZSB0aGUgYWNjZXNzIHR5cGUgZm9yIGVtdWxhdGVkIE1NSU8sDQo+ICsgKiBvdGhlcndp
c2UgS1ZNIHdpbGwgY2FjaGUgaW5jb3JyZWN0IGFjY2VzcyBpbmZvcm1hdGlvbiBpbiB0aGUgU1BU
RS4NCj4gKi8NCj4gaWYgKGZhdWx0LT53cml0ZSAmJiAhKHdhbGtlci5wdGVfYWNjZXNzICYgQUND
X1dSSVRFX01BU0spICYmDQo+ICAgICFpc19jcjBfd3AodmNwdS0+YXJjaC5tbXUpICYmICFmYXVs
dC0+dXNlciAmJiBmYXVsdC0+c2xvdCkgew0KPiBAQCAtODIyLDYgKzgyNSw3IEBAIHN0YXRpYyBp
bnQgRk5BTUUocGFnZV9mYXVsdCkoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBzdHJ1Y3Qga3ZtX3Bh
Z2VfZmF1bHQgKmZhdWx0DQo+IGlmIChpc19jcjRfc21lcCh2Y3B1LT5hcmNoLm1tdSkpDQo+IHdh
bGtlci5wdGVfYWNjZXNzICY9IH5BQ0NfRVhFQ19NQVNLOw0KPiB9DQo+ICsjZW5kaWYNCj4gDQo+
IHIgPSBSRVRfUEZfUkVUUlk7DQo+IHdyaXRlX2xvY2soJnZjcHUtPmt2bS0+bW11X2xvY2spOw0K
PiANCj4gYmFzZS1jb21taXQ6IDNmN2IzMDc3NTdlY2ZmYzFjMThlZGU5ZWUzY2Y5Y2U4MTAxZjNj
YzkNCj4gLS0gDQo+IDIuNDkuMC4xMjA0Lmc3MTY4N2M3YzFkLWdvb2cNCj4gDQoNClRoYW5rcywg
SeKAmWxsIGdpdmUgaXQgYSBnbywgYnV0IExHVE0gaW4gZ2VuZXJhbA0KDQpSZXZpZXdlZC1ieTog
Sm9uIEtvaGxlciA8am9uQG51dGFuaXguY29tPg0KDQo=

