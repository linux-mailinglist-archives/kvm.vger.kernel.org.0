Return-Path: <kvm+bounces-68300-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DEA4D2F34A
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 11:03:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id CDEBE300429E
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 10:03:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 451A735CBAE;
	Fri, 16 Jan 2026 10:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="pbPLxA3p";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="l0Z4sEPG"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-002c1b01.pphosted.com (mx0b-002c1b01.pphosted.com [148.163.155.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB2E52F1FED;
	Fri, 16 Jan 2026 10:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.155.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768557786; cv=fail; b=Zcc3N43Rg/PU4bezQ0mqzU6ugIXRP9c7sRfDtJrBRUy3GR36NckVeAmFtScipy47cYMusJp37CSY+fkcEb11Us87sQ1mTiUzYGBAWAAe8D6iHsHRRXJMkWT+bLYudY0kjykV6SFkyqK9K5sXUCmtpktaW4+04tDW0h68mRk6fN4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768557786; c=relaxed/simple;
	bh=O1v0J011xRrJf7PvSnOQTfizMcCJwVK41AzkR74jbPg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=kz/hRbnfpSfEzdf29EkVxRr73Wd3i75YDJ4F/2Ayfc5tc/5DQcK57Fgk1nab+wbXWhlHavBdlRMYN0/stntUCHz+Rat2WANhp5l53KT5H7z2FtztjzOx3DSvcaUQzj3I84sGEt3tnWIeyprYLKzmr7gRD9zTvns9dmsD97PmPMI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=pbPLxA3p; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=l0Z4sEPG; arc=fail smtp.client-ip=148.163.155.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127841.ppops.net [127.0.0.1])
	by mx0b-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60G8sGUF2709406;
	Fri, 16 Jan 2026 02:02:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=O1v0J011xRrJf7PvSnOQTfizMcCJwVK41AzkR74jb
	Pg=; b=pbPLxA3pzQwFh0fYpqrbBcdLoauqFc3L6Uc6ba2u8KbxcWeA0twRBkKEe
	nbshilQ13FW2Iws6oxO+p0S9z3/HNmmRsr9yVdqQupT+nd5zJ0Ae1EFKeBeKD2cO
	3pkuDPayVZVKMWd3VImNp96gygdgmCXpe5SL1ibHVCf30av9ISKGv7CDp0pfHU/5
	uYWZ6+XrqRJIGmrTPNiqCB2DrDQ4Cf/Wg3U7Q5FRa/hgGQWIoXSrpiNI1pokDNjW
	tofFfTIeEqfqZ5QNW+Ra225ZhxJgR3WPihFTILBNz2wAvJK2tT1ukoj6cGkmPnMx
	lKFlW0yRpkT14sy4NGF8SHRTgiKRQ==
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11023096.outbound.protection.outlook.com [40.93.196.96])
	by mx0b-002c1b01.pphosted.com (PPS) with ESMTPS id 4bq97whf6m-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 16 Jan 2026 02:02:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A+h2O03icHJ8UDhS6awx5XHDsDWZCMpVNNgJy8pQxHWrGFEe0BhP17EKXpjOIrxDoP/h+o9oYbOh2RdyGcSF5Cxiu88KT0krvLH/dvzqIO/5u4tpjZf/EaHCl22nd2DRdGBrazlcJJOg+OgKO3dQ54VmMiQq9S0oY+iIt/V0cro4bz9vXJ9vSyBdQXTbSvJBAKqGoys3yvxBMdx3+nDB4EuN82UotK0QYT29CwUBHdUXpBMXeTswmQ0imrXh4F2qMjeQbOnhX8pAhPstSe0lD9m1G2Y6X6SIGIG+Hu+ZOWDzuxYfxjeecXdgSg3DppvYNEOCo+5DNAl6bdMTf/b4ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O1v0J011xRrJf7PvSnOQTfizMcCJwVK41AzkR74jbPg=;
 b=Q0YQQX29OOmIQsdeCxD0WxqqPbqRignVTA/wzhtfHeSsRhOqLJGoOakT8IUjN0bPXEAQnsq25qUsKJjOy99GWR9FJfPhXnX6P8LzPoaMmskTY33mphE3pDJJbsl+hssGBgXFzLYsNjLAhsgCqE3PoYmVbLaNeHm4xDpXQMxieS97old6ASWo+E48cZL6TJRe7UVGFVFS40hUpq4hPQismt1l690TYDBe5uKi0s3eF3lXlVGVAgbFs+JkY+gLAk8+5/JOCiJiMrQK3vMYJQhSDGYttPoNKiG2G/IMcgbXXGaiKWuy+XkZrryF/gsarBgnIlkZb1HQm9v6N54faF4fUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O1v0J011xRrJf7PvSnOQTfizMcCJwVK41AzkR74jbPg=;
 b=l0Z4sEPG813tuW+IM9uhJLF1HeyGITkZcxRRgX4YPPnxH7rJSVwKExasJQiR2t714ARVUlWnsdHtE83h6sv3AH7MCZxT0wrUpK3HlJ8HU9qS9bQkbCLm7GF7iuuBayQmRLSq8YBbduVTgK0cyi7trKWRLyqbaH5h56dWQjh5faH+AFxcvBfthjjO7achvwGWpJ76rR7eKlFyvqFXlJWhE9hiS1L2wN91taoUXukYu1p9qWDO9X+zj3c1pRf1AAo+zR7TL7PfM5RDbGi6WGbUosJXgad4TGSqNdT9jC5J81dvWsGMdkK3oPPdn8y6wYzvA73XIflbHtA7Rn7T02Ptxg==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by CH3PR02MB9492.namprd02.prod.outlook.com (2603:10b6:610:123::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.8; Fri, 16 Jan
 2026 10:02:03 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::1ea5:acb6:ebe1:e1c4%5]) with mapi id 15.20.9520.003; Fri, 16 Jan 2026
 10:02:03 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: David Woodhouse <dwmw2@infradead.org>
CC: Sean Christopherson <seanjc@google.com>,
        "pbonzini@redhat.com"
	<pbonzini@redhat.com>,
        "kai.huang@intel.com" <kai.huang@intel.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>, "bp@alien8.de" <bp@alien8.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        Jon
 Kohler <jon@nutanix.com>,
        Shaju Abraham <shaju.abraham@nutanix.com>
Subject: Re: [PATCH v5 1/3] KVM: x86: Refactor suppress EOI broadcast logic
Thread-Topic: [PATCH v5 1/3] KVM: x86: Refactor suppress EOI broadcast logic
Thread-Index: AQHceLTCGUfuM4IR+kesh1yecA5IOrU/Ft+AgA7r6QCAAuAqAIADuPAAgAAQ+YA=
Date: Fri, 16 Jan 2026 10:02:03 +0000
Message-ID: <E19BAC02-F4E4-4F66-A85D-A0D12D355E23@nutanix.com>
References: <20251229111708.59402-1-khushit.shah@nutanix.com>
 <20251229111708.59402-2-khushit.shah@nutanix.com>
 <e09b6b6f623e98a2b21a1da83ff8071a0a87f021.camel@infradead.org>
 <9CB80182-701E-4D28-A150-B3A0E774CD61@nutanix.com>
 <aWbe8Iut90J0tI1Q@google.com>
 <cda9df77baa12272da735e739e132b2ac272cf9d.camel@infradead.org>
In-Reply-To: <cda9df77baa12272da735e739e132b2ac272cf9d.camel@infradead.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|CH3PR02MB9492:EE_
x-ms-office365-filtering-correlation-id: 7dc9c128-6c34-4972-52e7-08de54e64c5d
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info:
 =?utf-8?B?SmJaZXpuK3p1OEJIdmRwamxjVXVaN1NMMnp3NTJjZk13STJSNGZlVVpRTGNh?=
 =?utf-8?B?Y0tMYmR6b252aFhIMlFsTmpTbW9xcUczNC9wcHlEOGJCNWhUWFFrK0o5Z0c3?=
 =?utf-8?B?RWV6WXdTekVhRWZtVlZSdTZtTm9OU2ZZSGxlc2dNdTBmZXFsQzFLb1ZubUlM?=
 =?utf-8?B?ZVhyY3lBSGxuclNwMFZkUlpocDcwUXFNQzZObzN3anYzb1JTejJaTjZpYnRr?=
 =?utf-8?B?VmpiQUdmektzUzhmKzFWbGlCUVFVTkxSR0Jjbi9qNU9YMkE3R09FQVUyUjVv?=
 =?utf-8?B?a2w0empiVGNQOEZ6NDdaaXpETzBOdFUwcW5qUW1CQmoxMmxNZGRGOUtRY0dP?=
 =?utf-8?B?STM3YVM2WjQ0dXBUQkllNFdscUg5YjJvckdOaW9FQ1c4RWZVai9ZaktrNFJn?=
 =?utf-8?B?aVFBU3VMQm5KeXJaTlQ1OTlCWjJ2Zk5CQk4zcCt6cGFpWFZ6WlI1aHZBUjBx?=
 =?utf-8?B?d0FMemF5Wnd0OTVoR1hjVzNtTjJ6cGJqdTh1b2RLN1poUyszejczbEhROXdl?=
 =?utf-8?B?dFBYbmxKQndpaFlIUGJqNjF2Z2grZXBlTEM4MmdTTXkxakMvM05GbDJkeXN2?=
 =?utf-8?B?eE9kYmdwajBwWE9RNWxTUmVORHhPK3h2S0UvbTIxOEV0L21Gamx3N29IVUxV?=
 =?utf-8?B?VVhUMWFhV3F2RVlCbFl2UmFCZHpKa1VSMzZWSUVBWUlYSHNIK0lxa3BQZEdY?=
 =?utf-8?B?YjRhb0pEaWRzYzVZc2JNWUhnd05oc3BZbU5XOUNPUDFneUlxbWJscmdjUVVp?=
 =?utf-8?B?TjNjTDdRRUUzSWlaTDczTG1qWFJNTXh6c0pvRytaTTVZek5QRmhjQ1U2NExq?=
 =?utf-8?B?d0VWbHdxTTAxaUI1dmZOYzJCSzFXQkY4RHp1RmZkQVlybWFXbVJsYmJlWmsr?=
 =?utf-8?B?bU5qRDFtMUtJQzJyeUhNMUt1dmRaZDVhbVNNaGErU1ZxVnBSZWEzTEE2Wkht?=
 =?utf-8?B?SHdDVnlqQ280eE1SSy9FejlHU2Q0dmdOUnVSUFdzcUxrSVlTUkF6M29MNThW?=
 =?utf-8?B?b0pwVmlUeTZoV0h1cnU2OVB0WTVIKzVKb25sc0lkc1piTEdjUGFTcHpaMXBH?=
 =?utf-8?B?NEhrdGlDWFNzNWNVYlVCb0kxenlqc2JuS25PYnNLL1NNam40UTVFeDI1MHZD?=
 =?utf-8?B?M0RBZThKQ1dRbHQxTklFRmxMZEZBQTRPZVFnNm9KdUMzRDJVZHNLQXhhclRs?=
 =?utf-8?B?eHErZmxBUWxmUVpwT2pJYmlESGpWUGdsaTJaeW1WaDRUNUpVUW41VG8xN1ky?=
 =?utf-8?B?U0s4MkliNjJnU2hhOWN5Zy9NVWFQU1FaRStINU05V1BlNDVYMlJIR0p6SlM4?=
 =?utf-8?B?aGNqNVhGdEd2SWFYelFBWVNqYlVXS3M4aFBsemIwbE5LNDgrblcyT2RMSVg5?=
 =?utf-8?B?ckxhTzZnMXdleGVkb2ViUTk0cVhEQ0NnWkUzemFhVXFhNXZ2ZENFQnc5R000?=
 =?utf-8?B?WEduZEE1Q1VGSitTT1VUMnFjWjZ2c0dpSG45NFpFbjVyVUZkMlBBb1E5ZkNX?=
 =?utf-8?B?cDVLMENTODZoVk1nVUwySkRyU0hLTXBURmVweTBNeitBUDZWbTQxcFk2dk9U?=
 =?utf-8?B?OHZTcmFXVWh0Q2gzM2RmM294OUMwdkcxVk1FbmxyKzJ4d05LLy91Z0tGU042?=
 =?utf-8?B?T1p3alZhTkl0S1BzNXFWci84cmwxV2tPdnBiQTVUVWlNdEZ2bFpadXF6RWZ4?=
 =?utf-8?B?WUU3cGw0cEFMUkJJMjhuM1FGN2lXK3NPamt5cDBxYzdEVVBzemlINDNFaTNM?=
 =?utf-8?B?dmdneHF5c1d3TlpzR3B1bTIwdzE3VlZieEJQVmFMeWZWclllbXRnSHAzRnpF?=
 =?utf-8?B?TXppSFd3OERZbjNCbmRvak9tS01SU0lMcDZtNjF3T1RkRXBCU29xaDBpRmNP?=
 =?utf-8?B?ajI5Q2luQlE5anY5MXFON3JXRXlweSt3U21HNkR1aHJybjhjU2wzNjRNYUcv?=
 =?utf-8?B?WnhLR2thWUYzWVM0NGE3ZmRkTlYrLzJiSWl5UGR6MHI0eXp2bFlFNmxSbldI?=
 =?utf-8?B?YVFLcTQySkhWL1hTak1UWVhwS1RrWUtxTElwYnVJNk81cFBpWVk3aUsvaGhF?=
 =?utf-8?B?YStHSmFIbWdKc2pKNnY4ck1UV09WTzRySlhZa3djbEpWcHZtMk1NdWJsMWUw?=
 =?utf-8?B?amxDdnlUU1ZmcWVOcWlvZ002N1hHWWZuT1JVUFovZzBDWkJtSndqQjRyaFdO?=
 =?utf-8?Q?eVh5eYHNVepnr00Yqw4ydG0=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?LytIblRTVDJPdHdNUTRkcEVQcWx0OVFSTHBTZjlIOU1hK1BGcTdiZjBVdjdX?=
 =?utf-8?B?YjZsWXJyZ3hQRTRhNS9qNStTeUZoUmEyYzdDcUlhRXpadzZuMm4wNkpaUFE5?=
 =?utf-8?B?M3ZDUU91WGNHbkJwVjFYSFlDTERTbjBodWxibVg2c0Vkb1Y4WmI4bWJOekQr?=
 =?utf-8?B?QUt3bVhBam85N1ViN2h5ZHNOM1l1aTY2WjRkUzVOYlVNVzJXdC9oa29xU1pE?=
 =?utf-8?B?MGpnRDFZTnhmZlg1cVByakp5WVVxdHVvTHMwbTNUSi9TNzB6YVViNlhiSnVs?=
 =?utf-8?B?TC9vUmJMZ1FWV2w4REVNeDJWWjVxUkdPa1dadWsrUCsyaGtUUDZ6UjJwMnZK?=
 =?utf-8?B?VEhqZnBVL2JYSG5pUnBJVzRZMTg2cmRVYnBBcFVCYUR1Z2h3RGQyT0h3U1Y4?=
 =?utf-8?B?Q2hrQStIa01PeXZ1Q0tyU0dDKzRVb1d2OHlrenN6Wk9oTDRjcU94L2kyVGRj?=
 =?utf-8?B?dFVZOXRleml0THdoM3VtYm9jUG0zK2lDMmRFYTNTdmI5OVVrdHdWTlhtb0c5?=
 =?utf-8?B?bSs3WmRWU2kxcFl0aDVtVVdKMW51K0FGSTRXQmhMbHNMdlFZVTZ5V1huaFJX?=
 =?utf-8?B?SUpSWWJGL3hsUHpPQ0dSaEk3N0o4cFZENGoya280cXZPWXlyRXFHdzZVeDk2?=
 =?utf-8?B?UlZHSkxaNE9OM1cwbUo3Q2psNFphSGxlejVMY0tvQ2FuQVpKV2hZTXlxVzhm?=
 =?utf-8?B?NEI5RVpDT1A4Tjc3ci91MStlcUVLcVZoS05MRjQ5aW4xK1JTeEdqUTBIbTZS?=
 =?utf-8?B?eG5aK0FLS1JhamlUSFlhaWZQMXREYjRIa2gwU29kdXdHT1cwb1FNS284TXlS?=
 =?utf-8?B?TWltRkRMRkM1cnlQV3hXM2lNZER6Y0NPSk9vOWNTWmYrV3EvUnJwT2pNQWc1?=
 =?utf-8?B?QXl6NmlrZ2NsZGlxOGpUMU1iVExFNXNSdUlET1gxOHRRaVRod2dQMlVLZkpy?=
 =?utf-8?B?eHQyTUY0QkpWNkNacUpzZUtHSXNCNmVOc0NWaXphNHFrVmptTVVNQW82dkhG?=
 =?utf-8?B?Y0ZXSy9aTEV5ZHJtcmQyQnorWWlBMEs2Tk5FbmxITlhha2JTZWJrWGFPVDQx?=
 =?utf-8?B?Ly9EZXhQdDlEb1hGMjNUaFR6R0lzaHVTYkduY2dWZmhWVEJhbG5Ta0dqVC9a?=
 =?utf-8?B?dVdNSlV3TkFOc1liNnRSZ293enZKWS94V1U4WDhrYUU3cGhCZnZoYmFCWGxM?=
 =?utf-8?B?MW56T0l4UnkrTWxFZlJTM0xjUW51cmJRZXdTd0VFT21mM3QyU1hNMXJBaVpH?=
 =?utf-8?B?TGQ3Ym5kZGk1K1dJNXJTVGVIQ3JrNlNYL1BuNE8xSUwyejFrcitYSVp6dXNP?=
 =?utf-8?B?Tkc2Uk1pSGVnc3Y1c3pVZ0JmZ3pQM1VESzJKM3ZYcnQ4RHJsY3RnbUYydmpG?=
 =?utf-8?B?eFRYb1dlc0tZRW82K1owWjF4cFVDQm9qNFhXWkpKNzk5czB2T0VJdXJ6NTdD?=
 =?utf-8?B?Ykt5aEJxYUdkUzdQNWhEUk9nVG5qMDl0Z3FPbDZaS2FWL1Fyb3hqVEx5RkNV?=
 =?utf-8?B?MWRHa0RDZ1htT1ppaWdKSlhzVmkvUHE0SkFZOTdxcEZNdjkxZTFPdGR6U0kv?=
 =?utf-8?B?WUd2bXFIeFhIVnpNNmlCWEI2Y241M0EvdUlnK1BEUjlxa2grbS81VjYxZDVI?=
 =?utf-8?B?S3hNL2t0S2xCaStmeXNqSGJnU1hUbThsb3VpV0QvRUI1bW9TaGhDU05PQ0VV?=
 =?utf-8?B?UmwybnpNRjZXSUoySlFZUlRYMEdOVi9NS0JWd2hGSFE1M0o4ckdiQ2NwYVNB?=
 =?utf-8?B?SmdtM2wxSHRBbklTVzF3bVlldXFJY0VoNzZELy9jWE5JUjVTb1JYR0xJU2Nh?=
 =?utf-8?B?aE1qWjk3d2F6MXlxTU9EeWFHTXlZVE1kY0p0bDY4SDFvdnM5dlNkRTJYY2ZY?=
 =?utf-8?B?dk90R3hheWIxWldoeXo3eHQ4dTF0RXRBQ1cxOWRXWndtbGYvQVcycEcwdk5o?=
 =?utf-8?B?S2JObE4wcDJ6TDNEbXpOSVIrMlRTRWlKeE1GMlRMNjZZb0NjcGdDTEwrV0Rm?=
 =?utf-8?B?VkpqZVhEZ2txSHdlNjFoT3dzZVFrRGZWMHlzbTVneFdYR0FDT0Z1djRKTHBK?=
 =?utf-8?B?TUQ5anlGM0svU2dqWHBaWHpqY0YvVEtJZ1o3eU9uenBRTTlLRFZpc2t1UnRr?=
 =?utf-8?B?bjRXKzRsaC9reWp1czVGTGEraWpUajdDVG1mNW55Y0QvU2FOZzcyKzZhNkZW?=
 =?utf-8?B?WWJVRFNodkx2OWR2TTJGakQ5SVI1b2FoQnBjVlBuWnRjemMvTWZUUjFEOU5D?=
 =?utf-8?B?V1BySFN3S0JIaTRDSkQwVCtLeUU3a3ZkQW90WVZMM3VRa1lGZlBpbzN6SU05?=
 =?utf-8?B?aU4vdGNFVVJhazVjZTVWVUNzdU4wempONnFtdzdlaWtTekQyZ3o1L1RWa0dl?=
 =?utf-8?Q?CVwtINCY+CSXMvsU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0D8216E66D676C4DB64973DF3097D7A7@namprd02.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 7dc9c128-6c34-4972-52e7-08de54e64c5d
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2026 10:02:03.3429
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: skItDlqsjHH0b2xfTZApwUUutzm3s1OTw/2DnIGaQayOl06JN7HJqR+nxZrcz2sendo3QyY+Z7kiFHFWNmiyfW55eEzzA1X3P9Ptf+YY1BQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR02MB9492
X-Authority-Analysis: v=2.4 cv=NMrYOk6g c=1 sm=1 tr=0 ts=696a0c9f cx=c_pps
 a=cck1Y2tAR+80KxojUOV8qg==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=vUbySO9Y5rIA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=JfrnYn6hAAAA:8 a=Emmh8iaRBoHFwWYOeO8A:9 a=QEXdDO2ut3YA:10
 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-GUID: GZO-BJHbOac0SPONzSpaye_iD9UWzPNF
X-Proofpoint-ORIG-GUID: GZO-BJHbOac0SPONzSpaye_iD9UWzPNF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE2MDA3NCBTYWx0ZWRfX7TM2mrNUosvu
 ODuNPfMUZTewibtHOq/d1hilp9cY+ax4VvuuzYiRinhyeiEx4/tv6EHe7Z/OPYYPGoK7TdXW3et
 embuYhDcMhmlGE/j1zz/OvBQ+cd0tI6r2SeTUuvE4AGnbxj2H0bR77cy9dR+rf1KIVE+0cBVnPt
 HYYJbA9HQrtPHrtCgP+9CdXZBbB9Iza6V3a9sipx0pE60BtFtpprNti1tb/AWOg1jGSgH2onMGx
 +RpsuQBBd4yHFb/fcpYhWDH1GbQy3+a8/lCnobNuhhmb0zvgg1Ke25aeqkeJL2gRMrIDsv48PXy
 tFs6hZqjp0wie70Z8D33kV7+nuaclmR3BYyTUul/7uolfY/6bHEXh/C6nGzySowoX7h1kOFPmGv
 +MSLbjgZC+Mrtz762QUOng/5TjM5y8e9G/N0pYzsFs4tIRwxAUed6sLjmKnl86O0uVsKND7bxRu
 NeqbhK+L24ao+8dHoXQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-16_03,2026-01-15_02,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

DQoNCj4gT24gMTYgSmFuIDIwMjYsIGF0IDI6MzHigK9QTSwgRGF2aWQgV29vZGhvdXNlIDxkd213
MkBpbmZyYWRlYWQub3JnPiB3cm90ZToNCj4gDQo+IEJ1dCBLVk0gKndpbGwqIG5vdGlmeSBsaXN0
ZW5lcnMsIHN1cmVseT8gV2hlbiB0aGUgZ3Vlc3QgaXNzdWVzIHRoZSBFT0kNCj4gdmlhIHRoZSBJ
L08gQVBJQyBFT0lSIHJlZ2lzdGVyLg0KPiANCj4gRm9yIHRoYXQgY29tbWl0IHRvIGhhdmUgbWFk
ZSBhbnkgZGlmZmVyZW5jZSwgWGVuICpoYXMqIHRvIGhhdmUgYmVlbg0KPiBidWdneSwgZW5hYmxp
bmcgZGlyZWN0ZWQgRU9JIGluIHRoZSBsb2NhbCBBUElDIGRlc3BpdGUgdGhlIEkvTyBBUElDIG5v
dA0KPiBoYXZpbmcgdGhlIHJlcXVpcmVkIHN1cHBvcnQuIFRodXMgaW50ZXJydXB0cyBuZXZlciBn
b3QgRU9JJ2QgYXQgYWxsLA0KPiBhbmQgc3VyZSwgdGhlIG5vdGlmaWVycyBkaWRuJ3QgZ2V0IGNh
bGxlZC4NCg0KWW91IGFyZSBkZXNjcmliaW5nIA0KMGJjYzNmYjk1Yjk3ICgiS1ZNOiBsYXBpYzog
c3RvcCBhZHZlcnRpc2luZyBESVJFQ1RFRF9FT0kgd2hlbiBpbi1rZXJuZWwgSU9BUElDIGlzIGlu
IHVzZeKAnSkNClNpbmNlIHRoZW4gSSBndWVzcyB0aGlzIGlzc3VlIHNob3VsZCBoYXZlIGJlZW4g
Zml4ZWQ/ISAgQXMNCmM4MDZhNmFkMzViZiAoIktWTTogeDg2OiBjYWxsIGlycSBub3RpZmllcnMg
d2l0aCBkaXJlY3RlZCBFT0nigJ0pICB3YXMgbXVjaCBlYXJsaWVyLg0KDQo+IE9uIDE2IEphbiAy
MDI2LCBhdCAyOjMx4oCvUE0sIERhdmlkIFdvb2Rob3VzZSA8ZHdtdzJAaW5mcmFkZWFkLm9yZz4g
d3JvdGU6DQo+IA0KPiBJZiB5b3UncmUgY29uY2VybmVkIGFib3V0IHdoYXQgdG8gYmFja3BvcnQg
dG8gc3RhYmxlLCB0aGVuIGFyZ3VhYmx5DQo+IGl0J3MgKm9ubHkqIEtWTV9YMkFQSUNfRElTQUJM
RV9TVVBQUkVTU19FT0lfQlJPQURDQVNUIHdoaWNoIHNob3VsZCBiZQ0KPiBiYWNrcG9ydGVkLCBh
cyB0aGF0J3MgdGhlIGJ1ZywgYW5kIF9FTkFCTEVfIGlzIGEgbmV3IGZlYXR1cmU/DQoNCkkgdGhp
bmsgbmVpdGhlciBESVNBQkxFIG9yIEVOQUJMRSBpcyBhIG5ldyBmZWF0dXJlIGF0IGxlYXN0IGZv
ciBzcGxpdCBJUlFDSElQLg0KSXTigJlzIGp1c3QgZ2l2aW5nIGEgd2F5IHRvIHVzZXItc3BhY2Ug
dG8gZml4IGEgYnVnIGluIGEgd2F5IHRoZXkgbGlrZSwgYmVjYXVzZSB0aGF04oCZcyBob3cNCml0
IHNob3VsZCBoYXZlIGJlZW4gZnJvbSB0aGUgYmVnaW5uaW5nLg==

