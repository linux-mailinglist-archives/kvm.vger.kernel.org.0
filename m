Return-Path: <kvm+bounces-64639-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 71BD4C8916F
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 10:50:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 5A5BE4E4CA8
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 09:50:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4D282FD7B3;
	Wed, 26 Nov 2025 09:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="wByCbPjD";
	dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b="y6fGMlGm"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 032842E6125
	for <kvm@vger.kernel.org>; Wed, 26 Nov 2025 09:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.151.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764150517; cv=fail; b=iXyt16kI8mK/dhcT1CNv7uqCyj8pj3ifjkgZS68jaR6sAgtJ+YrbUAqEPLTY1lk8ebLlOW0P4FMW+C9jJHTVM3hHwMDA1UpmX2lHHAtxXKoZ5fcpmhbUbXKPnGZaJBXkiLbESrMFRtzUaQIc7A1ls/vGdZSS+piabLSja6rC8jY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764150517; c=relaxed/simple;
	bh=cAkwXz2oPAju6ylfKLwAR8Cs2oJtR9m7pvi9UFYv8Lo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gjmtZmpSrc32ynq31C+TSQngAgTGr4TVqj4a6N5QanZi8+xUMeONaWWaq8/ive/N7GKYFyBZ6K50/zWwITb213XJICo+dk1Br2ilZdB7roaDVBvZbnaePn9/Tx7xXqCg8ENd/rsjEn6EODKNcC8AfV2rwlM7wH5bAxChEpn9laA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com; spf=pass smtp.mailfrom=nutanix.com; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=wByCbPjD; dkim=pass (2048-bit key) header.d=nutanix.com header.i=@nutanix.com header.b=y6fGMlGm; arc=fail smtp.client-ip=148.163.151.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nutanix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nutanix.com
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
	by mx0a-002c1b01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AQ97HTQ220212;
	Wed, 26 Nov 2025 01:48:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=
	cc:content-id:content-transfer-encoding:content-type:date:from
	:in-reply-to:message-id:mime-version:references:subject:to; s=
	proofpoint20171006; bh=d9OV3RhM84TUQ4Du9Fc77j1AWF32Y8tdam66cZ4GW
	7I=; b=wByCbPjDrhSJ4cBFJxg4/gjiPdPTxDU7v+ku46eGeHAxFVrpQ7dhywno5
	x9FHKh/VdotwRqqQ63P42Hd5XoeE8fn6ooLviOgVdZFUuu0Qf62b1S04a4PUr8RP
	fpn2ixNQGfejyLMsrMsphgMyFeOrIzITPzIDiRgxG9svLNU4k1davlVumXT81VU3
	QgwTuVG2/IkYynw/T/43mYbDMYiY4eOoTgfaVw8ZPwBF2OeA10nTmJOpWqSAgY2U
	Us5pa8HF/RTde8cgaqXVNwG80e2+SEGEyMchTMYIMqEZHrBelDBgi3QKadUr7h8c
	jk+aJ43fNdM38FiRKONWG7vfywK6Q==
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11021133.outbound.protection.outlook.com [52.101.62.133])
	by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 4angxyspft-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Wed, 26 Nov 2025 01:48:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=px+2S1Y7OZ7DNhvmnwXCAlMGFH7Xch9rE9+ISgNbGyUzgPimlk2bCsHtf6UpVxo1LubtBrSccgc3YZnDfiV2ANqfnrLZX/7NOAvVSsxg7JuoT88Uk/9gTYrG+Kn7DzwE9nD6gHWVYHjf5LsgC31/f7LSu1UXx9wR/qZDn1LU7cFqKhTXFsloZS+l429cQ0191YvoCJ8EaLQRD5Lulq8BfcsCV/UWoqvSsgRIf9y54ryJ6asSZ12xZGAa8aSn98Ibl4dSNuLZ748okaWJsFjfaQfBrA0Y+IpITapGnM2e90fSYSB55GkHkOjgE3FNIv7m0rENhJFNSp117ZHKvaghcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d9OV3RhM84TUQ4Du9Fc77j1AWF32Y8tdam66cZ4GW7I=;
 b=RrrmkUr2CLhrGj4jz4CP7MJn9ZeyvA32oN18rQeUE2lCdDFxpoI0SirQExMljykSxrqtVD7nnPl53SOwJCHydu6n28E5XlhkneOypHc1mCg6qrDNO9qxJqEMT5QqQBA5IydCgaHmXyW5jN3TUqIjnbsMg8hPBh8WSQo7mOJ3EYO4/KNiUjcMkajF5qzCHM54dycUcyqyeEFHMneLgeN3KKLCs3awW3uetONGqlxpV6DYVt4Dw0N5Nz+qXegJZjRXosNfpF86h4yyAjwRH7Mpdn/1UuDzMucDLQ81dFiT5sdM6K7lCqvZ3Z0RZWI1FBhdZ9lGjuMvPW7H943UfU8Czg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d9OV3RhM84TUQ4Du9Fc77j1AWF32Y8tdam66cZ4GW7I=;
 b=y6fGMlGm41oLhoNJZNeyWDrhfhHILv5efDWLVoDo6bGRaJDVu10Bmj7djIjuAOdoPzDP8AHHY/TZ+ANY1OtVlBVfFahE2SxvbmGYDaFCDR0xKeCmpI6bP1HIwTsu5HfXt+Ou4N+/3fD9QoN9vua70cKFwqrI6O7yrIn59shEU2KyJviinKca8fNSLgTd1w9C+dZ6cpFPpVcFVtxXjMb71Op+6giu2IHlpiUe2nZjbFlGOqmRIr99oq8Vb9s2etjyTPEStt6uYXMEk9DiQRWy7dQKOX9nJc8kbUpx13MjIySFHH3rVZTL/XbSibMjCSvrO7A879gToUxwFoSRmqVf3w==
Received: from SA2PR02MB7564.namprd02.prod.outlook.com (2603:10b6:806:146::23)
 by CO6PR02MB7682.namprd02.prod.outlook.com (2603:10b6:303:aa::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.11; Wed, 26 Nov
 2025 09:48:20 +0000
Received: from SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::27c4:c948:370:572b]) by SA2PR02MB7564.namprd02.prod.outlook.com
 ([fe80::27c4:c948:370:572b%4]) with mapi id 15.20.9366.009; Wed, 26 Nov 2025
 09:48:20 +0000
From: Khushit Shah <khushit.shah@nutanix.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: Eduardo Habkost <eduardo@habkost.net>,
        "Michael S . Tsirkin"
	<mst@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Marcel Apfelbaum
	<marcel.apfelbaum@gmail.com>,
        Sean Christopherson <seanjc@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "qemu-devel@nongnu.org"
	<qemu-devel@nongnu.org>
Subject: Re: [PATCH] target/i386/kvm: Configure proper KVM SEOIB behavior
Thread-Topic: [PATCH] target/i386/kvm: Configure proper KVM SEOIB behavior
Thread-Index: AQHcXrhurlricMg9iE6/H6LGVi6DLrUEthqA
Date: Wed, 26 Nov 2025 09:48:19 +0000
Message-ID: <F09B2DC7-6825-48B4-94A9-741260832167@nutanix.com>
References: <20251126093742.2110483-1-khushit.shah@nutanix.com>
In-Reply-To: <20251126093742.2110483-1-khushit.shah@nutanix.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR02MB7564:EE_|CO6PR02MB7682:EE_
x-ms-office365-filtering-correlation-id: a0ade3a1-5c3e-4ac6-b983-08de2cd0ee86
x-proofpoint-crosstenant: true
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?qzvpbk940yDO/2DGCmrz2px3Wh23ENFWcUTHzGiKvm9BmIte3nA0LkK7iILf?=
 =?us-ascii?Q?ckb+josW/8dzmzDN0ZmvNnxBchLN7h69k0I6GRViY1siZ3eCcjmhaiWk+Um6?=
 =?us-ascii?Q?3c3VBbNHvSMEhZhgQWLY5wTXxqe6LEs9QaE6a7rFo9q5ZuFJOghh4zHQuJqS?=
 =?us-ascii?Q?0ZmdOChTVR/KC9jG5aaHMCj+PlfvodoUAKG1Oy4jqpxFGMAMYdTaSswcl3zk?=
 =?us-ascii?Q?wQHvUE5CHkrDRLJWsfE+rn/gjwB6+Jwaxx4SgB/H8LtFZvGK4RiOrMKtcFlo?=
 =?us-ascii?Q?heMUoldxyHkHXXBKKltrXHREvCUbMlYhTcchedcX/CqYop4OANKA0wScxIPi?=
 =?us-ascii?Q?fshajgyRHp+MSLDCcVg72sVaZoL8ev7BszhGOxjqUifnoESYGqqX/j/NNZ50?=
 =?us-ascii?Q?jKmQP6f6Ut6ndF2uv7XVubgfRfM0j4/lyIzlQyxmoSm90HFuRldjuKWG3L2M?=
 =?us-ascii?Q?h9ivfdb/Fzvin6A/mQKRvDZQlR2FtnGDo0jv8+nabqddCIPU1DDUkPfKjJbh?=
 =?us-ascii?Q?q1OjypSAQSPdBsss1A1CDDk4UhTYvTS5PZl2p5ABBzl7fMmZq9FlFmQIXoqs?=
 =?us-ascii?Q?eQu9D15e/HJBjjfettQv7IljFEI/28PlF0JCW6gsCbADgTfP+L//8wZ5cUB0?=
 =?us-ascii?Q?YcYS9GoICQJyx0i24fy+csjg7nSx8FQFoj9PT60CEWOX4BiX4U9erF7jE0LV?=
 =?us-ascii?Q?XfAvJIa0qEb5FDaekCI2jj1Hrau6A5HAIpcmjCLXDhZInukx1GM7OYwPWvbO?=
 =?us-ascii?Q?G8Hwr/a2A2BRBP68WuoGnwqBhnBXS+qEQGLsAekr713G293QJmjVxreY0bC6?=
 =?us-ascii?Q?/anewgpU+g/ILsqMhsqDJLn/LPHTDKFFdy6WfC0ksVxOMec5cYraV9N0kZaU?=
 =?us-ascii?Q?pEZ+ONftqK4pa3RFB9Un4/LTVTnbTLOe/i4CtFhz/p3fzLxdHkQlTPtgeqa4?=
 =?us-ascii?Q?6Z5pHmMqFy9t8FL3sWwi8l2PRPROH/Z2n+dmnrztiin1mh617Djr8uVvotGW?=
 =?us-ascii?Q?rKnABdx/VCyz9SR6qo0nBDCRfNnuBL8mWvzQMucP/pCDeNyW2E3VvJYrsf7R?=
 =?us-ascii?Q?UroFd/2pxuJgfhtBfc8lWp/w6ekh3a+xDNysUKyQ72Lu3K6GZNrgwQpGjWu3?=
 =?us-ascii?Q?M6LVZZufocZc4M2YtdJsatqhiaRX3/5C4niMZqXUIJ2Glp8EPJdaO0AfDWUI?=
 =?us-ascii?Q?SMG0rbbPqNKgb5B3J2mcsxGUhvHtqm/JEKpB1GbMQHDUdlZ4Y9WVaVWmfcJk?=
 =?us-ascii?Q?sPXNuer2FlFoJCUrW2peLXNWGwjYYqIs9PKu7oxspOkDaZdVEKp6U0lgxuBu?=
 =?us-ascii?Q?srNulrFqGDzrpBGpEAKJw585A2IoQLRbJdLuoYjnvF1elTfn+swPwO5UajEn?=
 =?us-ascii?Q?OxxLiL8/8fwZOyIwmyJvgQ25M3OPXm+vILi4fg/TCeY1lFeoVLPew5FUB2Ba?=
 =?us-ascii?Q?q3LwCoRehtzngaHHE0qq+lsolV+Qdi2Fpu8o1oD6/NxOh7ZcT0QT11o/LrBB?=
 =?us-ascii?Q?mMhHfmJKdI+Hhz4gy8J69qiTSe0MosjP+S/G?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR02MB7564.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?gtTRScA9dPDnBro3WodVsj3N528O5GjanoMSbKOeLT8YrucX0hzzyN9mh+Zk?=
 =?us-ascii?Q?WqmiTC3acileNrVtf/BoieAXnTHzFxVgKVraoXdi/kMYEGRudNBNorO2wSuH?=
 =?us-ascii?Q?T7ATsBYQc+DY9bI9F4PHK83QZsenS7bQUMMmzEE+X5GlyjxB6J6wgUhnGHR5?=
 =?us-ascii?Q?jpr+TdJl2j9fwu6ZhStgmf1TNWaig4I39lbsXfyvxVPrlpwIzQ1yCXCP1RXN?=
 =?us-ascii?Q?56Y1SW03eRCsQ9EGKcgAXM0LoKPdGzDjHSnz0kSClh1cZdg6uCDNgUqpatQs?=
 =?us-ascii?Q?+uqZzqnCmgY8TJYoiK1sJzjSdjlUgiAz+r5X62PjTA2IUP4wctP/q/ROSC4v?=
 =?us-ascii?Q?PxEZ6BT4qYRUew+HzvXWkS2m6l7duzicT8+CaTYcOsYF9/BT9UIRQB56XlDU?=
 =?us-ascii?Q?jCXTHWKvTeuOy9UTG8CILt52leSnvwofl46s38pLI7nhAlIdFlrRgfKVty+o?=
 =?us-ascii?Q?eTpnyubwAg6WhH70S1o5n/eZafoPxhvxA+K88Qm/mR4k79BW2k3r3EO7nOdv?=
 =?us-ascii?Q?6rcOlFTobEj/0/w71cxoj+Rsx7m3fufg0M5IWpNID63YJsYlrZ4BlfOc+4yc?=
 =?us-ascii?Q?dT6JjC3v35w9XZjVKQc/zvxeuFeA9GFRfDzDNjeGxhad6/NcWi/w402MKgnu?=
 =?us-ascii?Q?KaLrDR/O8UHr8050ZvxyhenepMIUlMKlsBYSHFaXnazoM+lDCeuOeM0vgji5?=
 =?us-ascii?Q?7MEdtbuH2uFjspmgxfabBhqOTel6DAKKALBMzq9W8MQ2TAXS2yMuhIIjduVR?=
 =?us-ascii?Q?fUnKcot+fe4mO03uL4kWJr0MSERJ87tgGtKe0pEuDAh8W8Why4vomuv4Bb4O?=
 =?us-ascii?Q?J6E5mTTkb7VHq0+82DJGXs0Mo3jzeCVH52ntqnC4iSDs0J+sYKAMBYNGLXH4?=
 =?us-ascii?Q?YWOwGnfalH64bowinXJsMJlGkm2VFl8Q6mmbPIVqpLbt1V+7ki7d5eQOcV0O?=
 =?us-ascii?Q?gwClCTb2Bxk9k2lREHW/M6vSr55PE4Q6l5gfKkv5HAqmmlXzky9up8Ope3GW?=
 =?us-ascii?Q?+bBg1C9rMS/MhbjCCagg3a0z/5kmR39HG4gK7rW54AFkShrJ9GS98q4Sd4k5?=
 =?us-ascii?Q?43/uQyDM7Hq37C2djjgQsKBGiXFFz87vXjUHAsBCM1R/Z/47a3U8Q2OyYbTp?=
 =?us-ascii?Q?JnioJaAnzY3Qx/ukjb2uyGgXARlX2hm6NfWqFjBe2ZMan2fErDwTMCv1PqKz?=
 =?us-ascii?Q?kxMApX6NKFemxSl2uBEVFKx6LEApfJmxAqokY230HNehAwa4mxXYxTt9+u/r?=
 =?us-ascii?Q?mEAMYt/1Ocos3wnFcV0Cu8uyr4vAgwwKIs62Kw/P2DQF5IxgwP6zOSHHRPg2?=
 =?us-ascii?Q?Tlbwwo9vZivJz+cxRqIW+bEF3QzT2QrIArmI0oOumjoSW99UcN+8jZ5pom+m?=
 =?us-ascii?Q?Mcs35i1TPZuc8ZE6/K5kEB5aFOaJ1UoQ5mU/TRs3YUTx5bYe+zNwqYEKShje?=
 =?us-ascii?Q?log2TQepRBTQ/bESUr3fgrxqk36EM+X5VxLZL/Y6Zze9EKG6jnUsTJ4aObR6?=
 =?us-ascii?Q?OLefrGBeAjfO0V+iyjYDS2P2so2f9e0KBfAjC5L+zqHHd2RNZB8gZIow0B4M?=
 =?us-ascii?Q?Lc7GE0iM+g8h6Opmp2vDHpx1lHnSbzBpIqK38M2XkjKVIhxgnXk/2AnrvIEW?=
 =?us-ascii?Q?cQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3FDEEAF97377CE41B24843CCAD9E7541@namprd02.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR02MB7564.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0ade3a1-5c3e-4ac6-b983-08de2cd0ee86
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2025 09:48:19.9800
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Uf9cAOmHooTTWAyd0RBpLE4zy2yvC79v4+opdLr+/t+sRsuKdln0GIXBivZfiJVjd9znEzm3Z+0tH7p4kJFoBZxipV++fmrdkGeNaaTLQQ8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR02MB7682
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI2MDA4MCBTYWx0ZWRfX+8DcqZ7MHtNs
 wzijuYmSOXVTYI2RsGd9OsgrD8FLlQdnNDOsO1phuUQKFjAqqWN5QHUzwqsmt6bXDKqJcUbFN7B
 DgL3psbvpaIci8a0rYeiJvY4dlYH7mUbJHIoPWdJITMYGSZgALQoglckQWMjUCkeBy/DajAQw+E
 hbyFRroKW7rXhjqBuYNLdL8CAsUURwHCKePq72OuOr1DcelgD6k5gizvrDmBt9a8q2wwBtKzvC5
 KHPF3TFzY7KuJUGp5GS8X0jy8o0Q2H+bxMm9eK97uFU/rmZcOaQm/oiQuJ2jTy0zgbjJjss4TGr
 ALe9IerzxbeQ+cCKQ2d1JcA/X/RkqTpswq1ih51Uj+GSzLX+ayQjZ85PQG7gSTsfB42vkrthmhL
 ugYkm9oP0rZAtJlBtVHJnTlabXFWiw==
X-Proofpoint-ORIG-GUID: utd1dZOOq5JNnceULbrJclynNfN36BuE
X-Proofpoint-GUID: utd1dZOOq5JNnceULbrJclynNfN36BuE
X-Authority-Analysis: v=2.4 cv=BeXVE7t2 c=1 sm=1 tr=0 ts=6926cce7 cx=c_pps
 a=0TjXLQglyxsLlDBGQ9rQow==:117 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=0kUYKlekyDsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yEmMrvy33JanpkBWaFwA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_02,2025-11-25_01,2025-10-01_01
X-Proofpoint-Spam-Reason: safe

Testing summary:

Power-on (split-irqchip):
  - An unpatched kernel with patched QEMU using IOAPIC versions 0x11 and 0x=
20
    shows the expected legacy QUIRKED behavior.
  - A patched kernel with patched QEMU using IOAPIC version 0x11 does not
    advertise SEOIB.
  - A patched kernel with patched QEMU using IOAPIC version 0x20 advertises
    SEOIB and correctly honors suppression.

Migration:
  - Patched QEMU to patched QEMU:
      If the SEOIB state is not QUIRKED and the destination kernel is
      unpatched, migration fails. Otherwise the correct SEOIB state is appl=
ied
      before vCPU execution resumes.
  - Patched QEMU to unpatched QEMU:
      Migration succeeds only when the SEOIB state is QUIRKED.
  - Unpatched QEMU to patched QEMU:
      Migration succeeds and preserves the legacy QUIRKED behavior.


