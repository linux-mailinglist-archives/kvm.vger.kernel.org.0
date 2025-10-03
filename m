Return-Path: <kvm+bounces-59460-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 136E2BB72CC
	for <lists+kvm@lfdr.de>; Fri, 03 Oct 2025 16:24:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BBDED4A02CE
	for <lists+kvm@lfdr.de>; Fri,  3 Oct 2025 14:24:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3678823875D;
	Fri,  3 Oct 2025 14:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="clGqyO3l";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="KdYQUYQY"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A11C11CA9;
	Fri,  3 Oct 2025 14:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759501489; cv=fail; b=aioiAOp1o6OAv/zW6yJmGcnjfmamRoTqbctuU4+Tk8DirZ47ez02Wg/ciAujk2cHb+3H+YnSQZK/AQXD2ZTpUZ+fBY1PMkH5TYoZGfLrKMfNsnkj6quErcEtBytC3IsY6nRgfG0EDDjhU4hGw2LLFeBsKVvrUng4icltx+c6VQg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759501489; c=relaxed/simple;
	bh=0tekDTdOXWQ66LOB7ZiHZMbVkkB7vieoGuU51zSTuGY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=lUR7Dt1ivhcA34kHHnfQnKwB3PElde3VY/xL5+O53aPMRT3+/AWZ3XmiNjfKhuTWa68GKYnwl3It/4Mlu0LWKm/zzIPQx6n1yr2fl33/dd6SsmK7e/yY6lDDhC1I2/QDhs9IaFPMUY+Qo1SXFfJNizuXWESDu3DgoToUVsyq+ng=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=clGqyO3l; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=KdYQUYQY; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5938ovIu236242;
	Fri, 3 Oct 2025 07:24:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=0tekDTdOXWQ66LOB7ZiHZMbVkkB7vieoGuU51zSTu
	GY=; b=clGqyO3ly5j4WIg/qiwZ+o8UdPRndtQPmx8j78NMcUKK2KgJp5Us1T9Ol
	0gZeZciTYNVl+Guwxf6H/LGtM7mmR/ZLKf5wpnqRGqCyfCIUuvLzhkFsi3hot8W5
	2jI1HBjhh87GCdfFdC5N1MQ7EGcFgbg5vymq8efAwf115wr5oNaInOPYSw6zxflF
	RN2hjc42b2SmrnaAT+GDumFDBhjCh/pU1OJ8j25ff8jPX/79CGJk7Fw6HgUbuu9n
	PVg2os0CrQwPKu/pnDYStSjjbr6BZMtLm/ry8xDPicofP57DwtVNePRQwMiimsUF
	e3bXPK4EOoq84J+LkJutY5u8qfGJg==
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11020143.outbound.protection.outlook.com [52.101.201.143])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 49jbb78k8n-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 03 Oct 2025 07:24:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z4zttQsPSq2dnj7YBgC/uaODfLol2pvEJwQ6ci+VPwJ2/RwD91fGxzos3L47peQndDg7cLrDaPcei+ZzYDLwuJ52M+9hbnF8aSZRYvyaNRDOLLdv0WHLNouxXW0aAgjehfOGs63eNK09RJ1K0IFtf223OlWA12H7/Z6E5ncLjxvqC0OXn2g6qJVBQJmNDkScE+IK4JpTm/urZrIEuI0+hHmEySOpA42qTX67Nb9YbuW3M+WiBpu9QiDHRhbuaSCsNGwbG6+QmmfatMTGXNZsdLHWHBrUpVoEzDtGySbvvNvFWD3gtPk5Pg5vZ7AdVw78wfi8YGILZVt+zs3pPDNDSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0tekDTdOXWQ66LOB7ZiHZMbVkkB7vieoGuU51zSTuGY=;
 b=fHaWpjNH7eZRlUM0HKFzm4i9aQ/WYf3D+Vg5ytZtmNCR2wL90JaV5Trd122P1C9scTXUCTCpHX5upDHq6gMzUtXhCbYZlHgke8qhHflW0uIwYMNUMLCQywyPsRLXM7DYDxsDjuZ12Qpt9BS7D21fSAqGa7goi8vKUXav7HvLX96HiX8TthBnLUVdKgHyE4SR8ZkgY7ppDmxXJBlJDrXXOg7zjt/lYfvJNchrh6rNV0WKNiCfSqcme6WFZVTjz1bEtnBUi8TunhP7I8lb1Ma3kIL0/O0sMqBmKOMab/F0lrJyhTnktUgp8NHELrUcGn42ZAQ6v/8SfjR0d1L/lKXhXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0tekDTdOXWQ66LOB7ZiHZMbVkkB7vieoGuU51zSTuGY=;
 b=KdYQUYQYh7EE5yQwBkjeN0cPSkmJQ5J3wuBPic7xjddVeJr07QA3ElexQikKnaEN+mh42InOgAeGrICfzHvW2gLy9xZf3Fzyjuu4zV0Tyv2gIOX1I3pyJ1C378nOzyy89o1nIks78dgjR2zplG/k4PO4ndaEiftKLkziAR7+fwtb+RiiscNtTQaDexyZB2T1MSMMBC0l7bMAzcl6kf3BHr9A1eQ+/8P1aDWwOmqGDUTux+mhC9ZjR5KwwG04N/N/okMH7Yi3yGwrnP0XiQMyNF7RFp3t0VYHSrjcgPW99SKPW5a2fpcJNosEJ/V3A1mdNHK5G9B9JBSEdZKRkyQK8A==
Received: from MN2PR02MB6367.namprd02.prod.outlook.com (2603:10b6:208:184::16)
 by CH2PR02MB6726.namprd02.prod.outlook.com (2603:10b6:610:aa::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.16; Fri, 3 Oct
 2025 14:24:02 +0000
Received: from MN2PR02MB6367.namprd02.prod.outlook.com
 ([fe80::e3f8:10bc:1a6c:7328]) by MN2PR02MB6367.namprd02.prod.outlook.com
 ([fe80::e3f8:10bc:1a6c:7328%6]) with mapi id 15.20.9160.014; Fri, 3 Oct 2025
 14:24:02 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: Sean Christopherson <seanjc@google.com>
CC: Jon Kohler <jon@nutanix.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Thomas
 Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Borislav
 Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: skip userspace IOAPIC EOI exit when Directed
 EOI is enabled
Thread-Topic: [PATCH] KVM: x86: skip userspace IOAPIC EOI exit when Directed
 EOI is enabled
Thread-Index: AQHcKLOgBGqDS4wr/EWm+kbhH0rY57SfxJ+AgABfUICAEG1YAA==
Date: Fri, 3 Oct 2025 14:24:02 +0000
Message-ID: <B116CE75-43FD-41C4-BB3A-9B0A52FFD06B@nutanix.com>
References: <20250918162529.640943-1-jon@nutanix.com>
 <aNHE0U3qxEOniXqO@google.com>
 <7F944F65-4473-440A-9A2C-235C88672E36@nutanix.com>
In-Reply-To: <7F944F65-4473-440A-9A2C-235C88672E36@nutanix.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN2PR02MB6367:EE_|CH2PR02MB6726:EE_
x-ms-office365-filtering-correlation-id: 2223c515-6563-40ff-0688-08de02888060
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?VW50ZVJqclBMVmlGQ3Y3ZENmaTVEU1YwUWpuS3NCY3BZZ1B2bStiTFpiVjRu?=
 =?utf-8?B?UDF6WlBZbUZHbEhZY3ZNMFQwM24wdmpwbndWd0l6NVhpT3ViZFJaUHFHWERX?=
 =?utf-8?B?MHVZZXJPSkMxTTFIVjR1QWQ2Z014RHJLWUI1VXI0R2wreUx2ZzZKL1hjNGoz?=
 =?utf-8?B?cFYxVXlMREMvVlFzRVhITWlqNTR3TmlWanA4NmFDakp4NjNJSllLRHM2eGdm?=
 =?utf-8?B?dFVCT3pkVGdhaTRSaURRVU1NcmNKNXhtci9jM2tOa2RuSGxVRVZQanNkcmlp?=
 =?utf-8?B?NHJSRHhIN2g2YS91b1VIemlBSzZVUmR4M2lMazlwTnNIVWpiUkdaMW1pcjA4?=
 =?utf-8?B?bHA4Yzl1K1lGMFlRRFFkckQ4Mmo5eVgzZ2RKWjFhUks2cEhhcHUxSGNtUEpR?=
 =?utf-8?B?dXpnYkgrM1h2RkdueitPU0taSkE1a0ZvWmJzaHh0dE5CS1BQcW9lMUVyd2E1?=
 =?utf-8?B?QjN1N0ZZV3pVbC9lWlBrMG1xbjJZeHROZ2tuWjlnM0tweDQ2K2QvN0Z5M2tt?=
 =?utf-8?B?WlI2UTllZUtqMWNjS1k2SytTb0xPVVpzMXM1N1N0VkFhUjRabXVRcEQ4Z0V4?=
 =?utf-8?B?V3FnLytYUlZZcmhHZzkrQ1lDTFdlN0JvN1lPZlFRaVBYdE9aLy9uUnp1aW84?=
 =?utf-8?B?WXBmd1IvN1h3TTZGNU80MlpIZHNPM0ZPZmMyVjUzTTc5VlUwd3puTzVkTXEx?=
 =?utf-8?B?SXlSK0tnS3lObHlHREZTRHFDM3hZbjFvOEIxMHk0SFcwR1Y5YURGUXhQci84?=
 =?utf-8?B?SjQxMVFNL0Zjd2RrbEtUVmFNWDZYTlpYMnRJQ1JmNmdLVWxwZFVJOGpXclpv?=
 =?utf-8?B?SmtkMzFxaXh5SHNqVzNPaXNmOHNCc0V0dHAyQXMxd3M2YTl6Wm03MVF4L0ta?=
 =?utf-8?B?b2xtcFBudm15TkVQaldpV3czWEs2WlVubFlURzhHWTMzTFpDK1psTUhUajhI?=
 =?utf-8?B?UytiQ3g4a0h1WnlTd21TNVJRSUVScUpQc0tackZvRUdHVS9KZ3NNZzlIU01o?=
 =?utf-8?B?NkVZK05LcStiR1BzemIxblJPeE5keXZmNHVEbTBhZGRaVmVYakM0eDNGaDU4?=
 =?utf-8?B?dEVlUVBieGljQzZENDBQWFc5UU5QbE93WGhEbFhSMkVsOW5SVkM3SHR2Rm5m?=
 =?utf-8?B?NWxZeUFVSU1FTEhqTmloUUFWenRPMFBmZVNub0NtcGZtTENBY1EvQXJjOU5H?=
 =?utf-8?B?STVNOTMvb0FjTW85TmVoOC9scXBFaFgyVXgyQ0xxbmlySTFVOUN6cEQ2YW1V?=
 =?utf-8?B?N3lkcnJ5ZzZ0NWRGM3M0VlVpRU9iMWpwYzVzTjg3RVMxR1BWWDZ1YTVjL2Nm?=
 =?utf-8?B?RjViS3RJNWd0aU9Sa2ljMkxYNm5HZlMzQmVnVTZXeEU3b3JwRGFGSGJpcHdP?=
 =?utf-8?B?dTYyaEZaQ2NQeENNdkF4NVF3L0pEaHZ1SWk1UFJTa3N5cUJKbGdPZmQ0NkFr?=
 =?utf-8?B?SXVobHg4ZkE3TGROVUNxcXB0VVI1NU1DMW5kYUpJUVI3UmF2NkZiMVk4UWhw?=
 =?utf-8?B?cFFMVFpBVWJxVzB0eC9tZU12eDhNczl3RTdzTndtbFpSMFRrSVJhNVJGQ0hp?=
 =?utf-8?B?VGttSnRZSyttWlltZTg0NW1iVjZaWXhtZG0rU3VkTmtEVVJoSGtsdVFkekoy?=
 =?utf-8?B?eFNxQnE0aXRGR0JjZXVnZnZGZkNGbjVsMVA4Q0dwOHQ4SEdFMEl6SWczM0Rr?=
 =?utf-8?B?RS9kZWUxM2ZVTSs2REt6emwxZ0tlTUJPVDlHVDBJNVFNT3FxUG5OblVwMTJL?=
 =?utf-8?B?OE1BRldZNG5xcHlteDFrSjlGTFFDUERKellXR2pRRUJIcHR2ZGJjZVJkQmxZ?=
 =?utf-8?B?ZHJVMGpGZnhlbjQ0R0VEUVlFNDJ3N3ZUS3dEa3JCdlQ0YlNIYml6SXlUN3Bv?=
 =?utf-8?B?L1k0MkdhTnJyVXdBYWhycmI5NzRBRU1KVnNaSU8rbW5KSGVlMkg2S0NGYzl0?=
 =?utf-8?B?YytZQythb04vbUdDQlk2dW9BcUJNOXdhVlI5QzFjVWd5ZjlOTlpnQ2JEaUJT?=
 =?utf-8?B?YnpuQTd4SEdCR0JOVFFCcHVDL25hczQ0K0NHRFF0MzlKaFphZ0FqMVNObTdu?=
 =?utf-8?Q?e748aD?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR02MB6367.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?SVNPaTJ0T3VFbnVzR0JKZXF4UEMyQng2REp0YWxXd1FyVmpwT1o4RW96eGVL?=
 =?utf-8?B?VUZtQ2IreUwrNFBqdUJGQ0VFSWRiNmhPamFlc0hRRkhTWittc0wvbnZnVDRa?=
 =?utf-8?B?Q0NnaE1mSTFTVU1JbUFjdUdwRE94QW9QT08ybUhkcE43UkgyMUw0cGxoakps?=
 =?utf-8?B?ZXBHMlNTTkZhR21vVWdHalB1a2gzei92bXJuNDZoZlVScERKZko0Vmc5cDI0?=
 =?utf-8?B?OHMwZllMRGJ2eEVNNCs4TFA1ekxBRDd2SWRjQ3ZrNHZuWmJub29tdStSTmpB?=
 =?utf-8?B?SENXOUZ0YnJJeDQwdXJ0dTJsU1pJNDFmTXpDVElNQ01DMXpsSUhMSnQ4K21z?=
 =?utf-8?B?RDZha3AyUUxoZ2ZkckIwbng0UlQ2bStjMGhMY21xWDFIM1RyUG9DYVZGU2ZD?=
 =?utf-8?B?NUlsNFhMUTFFb0luL29uNDZsR2lCS3MvQjAzOGo2Sjdod0NibStJLzhCTUo2?=
 =?utf-8?B?Y1RGZTV2ckFxU1g5S0UzeUVkZkVrUTRoQ2FFRXhJb3c0Q29PbWpmVzd0bUNi?=
 =?utf-8?B?ZGZDZ3pvVWFRanIrbzZLSkg4N1NvVkRYcDZLbVZ1eTNGRDVST3hXVnVOVzdF?=
 =?utf-8?B?V0NVT0FURDBSdGVmR3p6V0pzdG9qN3BGREt2a1ZGcnhveGdOWWtERUp1MXd1?=
 =?utf-8?B?Y1FiZW1sMVl4cGNZVWJZQzFiZk5zUzRxdk1vMWUyNUNlSytEdUVvSTBxZG5G?=
 =?utf-8?B?Y0QxQ29LTTN6WTV0VUhWVWRsTW1qV3FiVHhkK2JQNVBmSXkvZENodVc3MHdZ?=
 =?utf-8?B?VHo4YU94UCtKOC9IUE1sSGJvOFRDSDVxUXB6eGsyRUU3TjN3cFJzbjYweVcr?=
 =?utf-8?B?TUpNSGM3aW9OT202aW5iMGJmWmYrWlZWS2dnMzBrZE1rYzV0cVNXeURzem9t?=
 =?utf-8?B?RXFvVUxtYmo4SEhncGZWWTl6ckZLdGcwMjRDTUMwNmErcjhkWjVOZ3lLSXkr?=
 =?utf-8?B?Q0hab09nQ1MrTW1ZRm9jbjMwZ3kreGlScThFU0ZUd0JmUGlEVFVOVnhlS1Rq?=
 =?utf-8?B?UUlWMjBQYWtXT2Z0QnZsaXRwVktkMmhDb1NESFM1UmJQdjhOOXlraDlXenFv?=
 =?utf-8?B?V0pOOWxWVUp0MUwyYWxkMHhKTEFhbG1USE9jaEVJZCtlM2xaVENBQ3J0MG5S?=
 =?utf-8?B?N29QTXRENHZYMWcwTkRqM25iMEpwZmZ1ajlDcGY2RVV6UllqMTgrVGtJU2Fp?=
 =?utf-8?B?SHhSeTZVeCsyMkJEWVJIQk93WWwyMTArejBXMmFwOFptNHNLMW5mcktyUjJN?=
 =?utf-8?B?S2N4ZTJySXNkZkJGY0JZVVBJdUJ6NXdHMW9ROWcvMzN2R01XT09ZajlEZ0Ji?=
 =?utf-8?B?Z29EdUVOd0I4YUJzVWRUTURHTDloaStFL2xlVFRJNFZCTlZVcXV4eWdJUXR3?=
 =?utf-8?B?QmdyVmQxR2RYcG9GcXduL0hBdVJOczBoYldvL2lZZkFoTXpTVUtSdnBVZW5j?=
 =?utf-8?B?KzJOWEc0cGg5WUZVRndhaEVhZW05SS95Z0E5bFRJbUNUZzdEY25ocUF5alBm?=
 =?utf-8?B?WjJZdXQvbUlQTEk3bHhwa09remlSbDVzOVBOYmJQaGNob0wzV0hZSnNsbnRJ?=
 =?utf-8?B?TTBhbGZmWDc4d2xuU3c5QkVEYTN0OUNUclFHM2pSbGRZRXZrdmt0VVZNVTlz?=
 =?utf-8?B?WFNPZk5lN2w2MU9CZzJ4U3hIZkZHTlFTRzVNemROUUxmbFVkRm9hZ0JIM3Bw?=
 =?utf-8?B?eHZkOEpXdlgxaGpqUmtMMHNSVk9BSXE2eW9aVmJrVEU5c3lxS1N6YnFtZG04?=
 =?utf-8?B?SUdrTTFOUzdJanVPN1F6aXhWYjEvWm53K0JoSTVKbjhZRmI5OW42SkZkZWs4?=
 =?utf-8?B?NHIvZnUwNkRYOWtZZDB2U0lmQXZJTHhJUW9ZRkZYTVBhVzJOWVVlTzg5YmJT?=
 =?utf-8?B?WVVPSENyUW9HVlVhWVZjSnlDMDhXa3N0K2Y0SHNNYTA0M29uWnRkZUFuVy9O?=
 =?utf-8?B?S2ZIWS9kZE5oY0oxQ2NBNUVZVHNnS3RabmcrZFlWRjE1Y3JRMG5VZlF2MFho?=
 =?utf-8?B?SExoQ09ieDZkNy83Qmc4MmdxRW5MeldydnhnV1BQNnJPRml3dVZCTHVvSWFi?=
 =?utf-8?B?NElpQjgrdlUvQXBQOHBJd3RBWDdpdjczdllHMlJ1RjE4bXN0d3htRDlUbzZn?=
 =?utf-8?B?MFo1N1FkOGJWMDJLUWtZa05aY0w1cFRDUEgvbG8wZXcxZmdaS2RseVVOcGpw?=
 =?utf-8?B?QkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BCC661993C88F340A628E5DB8592FE95@namprd02.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR02MB6367.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2223c515-6563-40ff-0688-08de02888060
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2025 14:24:02.5261
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6tpLIqqYHwTII5EsPMt+Q5nJQefCQcnIWPkjyQyA0ljBQ1itIUff+7k1uMcAzqiyOzvlCmyX0Uak1vO1rxO2coj8+ZvbM7Qd2pbcoPC7mRg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR02MB6726
X-Authority-Analysis: v=2.4 cv=BsqQAIX5 c=1 sm=1 tr=0 ts=68dfdc84 cx=c_pps
 a=BHs4Y4KwHPdQvdroJDo5uQ==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=x6icFKpwvdMA:10 a=0kUYKlekyDsA:10 a=83DlxX229ggCH-LCY8AA:9
 a=QEXdDO2ut3YA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: SIApLeGevXPAfYdnRUmBaHxVCtKff-_2
X-Proofpoint-ORIG-GUID: SIApLeGevXPAfYdnRUmBaHxVCtKff-_2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDAzMDExNyBTYWx0ZWRfX+Fpf5aFHiV1d
 qQHh1pGis7/y7Z0YSNC+4XoqN+z/fuHfpIWicoPQNtlO0sss2qSiev8nF7YH+ci4qS/3z/b0EJI
 GloyGq7zrYqc4VGqCPGsJ5wUhDN7nGu3EgcgMco2X+F0Iqm8IAPS0Zt82GEXp/SRPlyapboolE5
 xk9cgWLc/ELiUUA5U3fP3HVrwaputi2d0/0zLZ6W5/woIEgDTZVK64/pwGclpDHLGVC3VCX19fE
 dW29guKzRLsl7tq+s6BklPLwOKktxujHCn7W8k/ijSC9jyL/tbo9oPmMt/kl8QcFEjBoOmrRYjV
 D9SB2qmu4r2/WUW0nFWzyEOiIsgxNNGzN3bNCSMqfHrGnI8T8s/DInMmA3mw+WKWXfAah9Z7xNV
 ZzUak3s2JNTlqMPhF0FOwavdaJO+tg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-03_04,2025-10-02_03,2025-03-28_01
X-Proofpoint-Spam-Reason: safe

SGkgU2VhbiwNCg0KQW55IHVwZGF0ZXMgb24gdGhpcz8NCg0KSSBzdWdnZXN0IGFkZGluZyBhIG5l
dyBLVk0gY2FwYWJpbGl0eSB0aGF0IGRpc2FibGVzIGFkdmVydGlzaW5nIHN1cHBvcnQgZm9yIEVP
SQ0KYnJvYWRjYXN0IHN1cHByZXNzaW9uIHdoZW4gdXNpbmcgc3BsaXQtaXJxY2hpcC4gSXQgaXMg
c2ltaWxhciBpbiBzcGlyaXQgdG8NCktWTV9DQVBfWDJBUElDX0FQSSBmb3IgeDJBUElDIHF1aXJr
cy4NCg0KQnkgZGVmYXVsdCwgd2Ugc3RpbGwgYXNzdW1lIHRoZSB1c2Vyc3BhY2UgSS9PIEFQSUMg
aW1wbGVtZW50cyB0aGUgRU9JIHJlZ2lzdGVyLg0KSWYgaXQgZG9lcyBub3QsIHVzZXJzcGFjZSBj
YW4gc2V0IGEgZmxhZyBiZWZvcmUgdkNQVSBjcmVhdGlvbiAoYWZ0ZXIgc2VsZWN0aW5nDQpzcGxp
dC1pcnFjaGlwIG1vZGUpIHRvIGRpc2FibGUgRU9JIGJyb2FkY2FzdCBzdXBwcmVzc2lvbi4gVGhp
cyBzaG91bGQgYmUgYQ0KcGVyLVZNIGZsYWcsIGFzIGFsbCBBUElDcyB3aWxsIHNoYXJlIHRoZSBz
YW1lIGJlaGF2aW9yLiBJIGFtIHNoYXJpbmcgYQ0KcHJlbGltaW5hcnkgZGlmZiBmb3IgZGlzY3Vz
c2lvbi4gVGhlIGVhcmxpZXIgZml4IGNhbiBzaXQgb24gdG9wIG9mIHRoaXMuIFRoaXMganVzdCAN
CmFsbG93cyBkaXNhYmxpbmcgRU9JIGJyb2FkY2FzdCBzdXBwcmVzc2lvbiB1bmRlciBzcGxpdC1p
cnFjaGlwLg0KDQpXaGF0IGFyZSB5b3VyIHRob3VnaHRzIG9uIHRoaXM/IElmIHRoaXMgc2VlbXMg
cmVhc29uYWJsZSwgSSBjYW4gc2VuZCBhIHByb3Blcg0KcGF0Y2guDQoNCkFwb2xvZ2llcyBpZiBz
ZW5kaW5nIGFuIGlubGluZSBkaWZmIGlzbuKAmXQgc3RhbmRhcmQgcHJvY2VkdXJlLg0KDQpUaGFu
a3MsDQpLaHVzaGl0DQoNCi0tLQ0KZGlmZiAtLWdpdCBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL2t2
bV9ob3N0LmggYi9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9rdm1faG9zdC5oDQppbmRleCBmMTlhNzZk
M2NhMGUuLjhlMDg3MjMyZGJjZCAxMDA2NDQNCi0tLSBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL2t2
bV9ob3N0LmgNCisrKyBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL2t2bV9ob3N0LmgNCkBAIC0xNDU3
LDYgKzE0NTcsOCBAQCBzdHJ1Y3Qga3ZtX2FyY2ggew0KIA0KICAgICAgICBib29sIGRpc2FibGVk
X2xhcGljX2ZvdW5kOw0KIA0KKyAgICAgICBib29sIGRpc2FibGVfZW9pX2Jyb2FkY2FzdF9zdXBw
cmVzc2lvbl9zdXBwb3J0Ow0KKw0KICAgICAgICBib29sIHgyYXBpY19mb3JtYXQ7DQogICAgICAg
IGJvb2wgeDJhcGljX2Jyb2FkY2FzdF9xdWlya19kaXNhYmxlZDsNCiANCmRpZmYgLS1naXQgYS9h
cmNoL3g4Ni9pbmNsdWRlL3VhcGkvYXNtL2t2bS5oIGIvYXJjaC94ODYvaW5jbHVkZS91YXBpL2Fz
bS9rdm0uaA0KaW5kZXggMGYxNWQ2ODM4MTdkLi5lODIyZWQ0MzEwZjUgMTAwNjQ0DQotLS0gYS9h
cmNoL3g4Ni9pbmNsdWRlL3VhcGkvYXNtL2t2bS5oDQorKysgYi9hcmNoL3g4Ni9pbmNsdWRlL3Vh
cGkvYXNtL2t2bS5oDQpAQCAtODc5LDYgKzg3OSw4IEBAIHN0cnVjdCBrdm1fc2V2X3NucF9sYXVu
Y2hfZmluaXNoIHsNCiAgICAgICAgX191NjQgcGFkMVs0XTsNCiB9Ow0KIA0KKyNkZWZpbmUgS1ZN
X1NQTElUX0lSUUNISVBfQVBJX0RJU0FCTEVfRU9JX0JST0FEQ0FTVF9TVVBQUkVTU0lPTiAoMVVM
TCA8PCAwKQ0KKw0KICNkZWZpbmUgS1ZNX1gyQVBJQ19BUElfVVNFXzMyQklUX0lEUyAgICAgICAg
ICAgICgxVUxMIDw8IDApDQogI2RlZmluZSBLVk1fWDJBUElDX0FQSV9ESVNBQkxFX0JST0FEQ0FT
VF9RVUlSSyAgKDFVTEwgPDwgMSkNCiANCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vbGFwaWMu
YyBiL2FyY2gveDg2L2t2bS9sYXBpYy5jDQppbmRleCA0ZDc3MTEyYjg4N2QuLjFhMDc3YjVhNzVk
NyAxMDA2NDQNCi0tLSBhL2FyY2gveDg2L2t2bS9sYXBpYy5jDQorKysgYi9hcmNoL3g4Ni9rdm0v
bGFwaWMuYw0KQEAgLTU1OCw3ICs1NTgsOCBAQCB2b2lkIGt2bV9hcGljX3NldF92ZXJzaW9uKHN0
cnVjdCBrdm1fdmNwdSAqdmNwdSkNCiAgICAgICAgICogSU9BUElDLg0KICAgICAgICAgKi8NCiAg
ICAgICAgaWYgKGd1ZXN0X2NwdV9jYXBfaGFzKHZjcHUsIFg4Nl9GRUFUVVJFX1gyQVBJQykgJiYN
Ci0gICAgICAgICAgICFpb2FwaWNfaW5fa2VybmVsKHZjcHUtPmt2bSkpDQorICAgICAgICAgICAh
aW9hcGljX2luX2tlcm5lbCh2Y3B1LT5rdm0pICYmDQorICAgICAgICAgICAhdmNwdS0+a3ZtLT5h
cmNoLmRpc2FibGVfZW9pX2Jyb2FkY2FzdF9zdXBwcmVzc2lvbl9zdXBwb3J0KQ0KICAgICAgICAg
ICAgICAgIHYgfD0gQVBJQ19MVlJfRElSRUNURURfRU9JOw0KICAgICAgICBrdm1fbGFwaWNfc2V0
X3JlZyhhcGljLCBBUElDX0xWUiwgdik7DQogfQ0KZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS94
ODYuYyBiL2FyY2gveDg2L2t2bS94ODYuYw0KaW5kZXggNzA2YjZmZDU2ZDNjLi45ODg0Yzc4MDEz
OGEgMTAwNjQ0DQotLS0gYS9hcmNoL3g4Ni9rdm0veDg2LmMNCisrKyBiL2FyY2gveDg2L2t2bS94
ODYuYw0KQEAgLTQ3ODUsNiArNDc4NSw5IEBAIGludCBrdm1fdm1faW9jdGxfY2hlY2tfZXh0ZW5z
aW9uKHN0cnVjdCBrdm0gKmt2bSwgbG9uZyBleHQpDQogICAgICAgIGNhc2UgS1ZNX0NBUF9WTV9U
U0NfQ09OVFJPTDoNCiAgICAgICAgICAgICAgICByID0ga3ZtX2NhcHMuaGFzX3RzY19jb250cm9s
Ow0KICAgICAgICAgICAgICAgIGJyZWFrOw0KKyAgICAgICBjYXNlIEtWTV9DQVBfU1BMSVRfSVJR
Q0hJUF9BUEk6DQorICAgICAgICAgICAgICAgciA9IEtWTV9TUExJVF9JUlFDSElQX0FQSV9ESVNB
QkxFX0VPSV9CUk9BRENBU1RfU1VQUFJFU1NJT047DQorICAgICAgICAgICAgICAgYnJlYWs7DQog
ICAgICAgIGNhc2UgS1ZNX0NBUF9YMkFQSUNfQVBJOg0KICAgICAgICAgICAgICAgIHIgPSBLVk1f
WDJBUElDX0FQSV9WQUxJRF9GTEFHUzsNCiAgICAgICAgICAgICAgICBicmVhazsNCkBAIC02NDU1
LDYgKzY0NTgsMjMgQEAgaW50IGt2bV92bV9pb2N0bF9lbmFibGVfY2FwKHN0cnVjdCBrdm0gKmt2
bSwNCiAgICAgICAgICAgICAgICBtdXRleF91bmxvY2soJmt2bS0+bG9jayk7DQogICAgICAgICAg
ICAgICAgYnJlYWs7DQogICAgICAgIH0NCisgICAgICAgY2FzZSBLVk1fQ0FQX1NQTElUX0lSUUNI
SVBfQVBJOiB7DQorICAgICAgICAgICAgICAgbXV0ZXhfbG9jaygma3ZtLT5sb2NrKTsNCisgICAg
ICAgICAgICAgICBpZiAoIWlycWNoaXBfc3BsaXQoa3ZtKSkgew0KKyAgICAgICAgICAgICAgICAg
ICAgICAgciA9IC1FTlhJTzsNCisgICAgICAgICAgICAgICAgICAgICAgIGdvdG8gc3BsaXRfaXJx
Y2hpcF9hcGlfdW5sb2NrOw0KKyAgICAgICAgICAgICAgIH0NCisgICAgICAgICAgICAgICBpZiAo
a3ZtLT5jcmVhdGVkX3ZjcHVzKSB7DQorICAgICAgICAgICAgICAgICAgICAgICByID0gLUVJTlZB
TDsNCisgICAgICAgICAgICAgICAgICAgICAgIGdvdG8gc3BsaXRfaXJxY2hpcF9hcGlfdW5sb2Nr
Ow0KKyAgICAgICAgICAgICAgIH0NCisgICAgICAgICAgICAgICBrdm0tPmFyY2guZGlzYWJsZV9l
b2lfYnJvYWRjYXN0X3N1cHByZXNzaW9uX3N1cHBvcnQgPSAoY2FwLT5hcmdzWzBdDQorICAgICAg
ICAgICAgICAgICAgICAgICAmIEtWTV9TUExJVF9JUlFDSElQX0FQSV9ESVNBQkxFX0VPSV9CUk9B
RENBU1RfU1VQUFJFU1NJT04pICE9IDA7DQorICAgICAgICAgICAgICAgciA9IDA7DQorc3BsaXRf
aXJxY2hpcF9hcGlfdW5sb2NrOg0KKyAgICAgICAgICAgICAgIG11dGV4X3VubG9jaygma3ZtLT5s
b2NrKTsNCisgICAgICAgICAgICAgICBicmVhazsNCisgICAgICAgfQ0KICAgICAgICBjYXNlIEtW
TV9DQVBfWDJBUElDX0FQSToNCiAgICAgICAgICAgICAgICByID0gLUVJTlZBTDsNCiAgICAgICAg
ICAgICAgICBpZiAoY2FwLT5hcmdzWzBdICYgfktWTV9YMkFQSUNfQVBJX1ZBTElEX0ZMQUdTKQ0K
ZGlmZiAtLWdpdCBhL2luY2x1ZGUvdWFwaS9saW51eC9rdm0uaCBiL2luY2x1ZGUvdWFwaS9saW51
eC9rdm0uaA0KaW5kZXggZjBmMGQ0OWQyNTQ0Li43MzJhOTNmOTM2NWUgMTAwNjQ0DQotLS0gYS9p
bmNsdWRlL3VhcGkvbGludXgva3ZtLmgNCisrKyBiL2luY2x1ZGUvdWFwaS9saW51eC9rdm0uaA0K
QEAgLTk2Miw2ICs5NjIsNyBAQCBzdHJ1Y3Qga3ZtX2VuYWJsZV9jYXAgew0KICNkZWZpbmUgS1ZN
X0NBUF9BUk1fRUwyX0UySDAgMjQxDQogI2RlZmluZSBLVk1fQ0FQX1JJU0NWX01QX1NUQVRFX1JF
U0VUIDI0Mg0KICNkZWZpbmUgS1ZNX0NBUF9BUk1fQ0FDSEVBQkxFX1BGTk1BUF9TVVBQT1JURUQg
MjQzDQorI2RlZmluZSBLVk1fQ0FQX1NQTElUX0lSUUNISVBfQVBJIDI0NA0KIA0KIHN0cnVjdCBr
dm1faXJxX3JvdXRpbmdfaXJxY2hpcCB7DQogICAgICAgIF9fdTMyIGlycWNoaXA7DQoNCg==

