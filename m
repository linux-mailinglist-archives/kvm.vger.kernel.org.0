Return-Path: <kvm+bounces-14480-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 52A158A2B19
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 11:24:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7663D1C21908
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 09:24:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6696151C4F;
	Fri, 12 Apr 2024 09:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="le2aAuXu"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BB624A39;
	Fri, 12 Apr 2024 09:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712913710; cv=fail; b=PYJJqDN9tgugQ1m3lTox8PB5lBbcykQEF1kyBrrFQrkSWwpaO7woVvGF/w8fIpjcBSuy/iPLBPrznMSJHzhtXMLoRSs52xvpEhOUTJt9GyfU+cFNNmmym5+p1CSVEr+s5zbT50fEUNS2xKRzazQDBXeCdeZqA9SoXs0hv6AdFJg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712913710; c=relaxed/simple;
	bh=tk7DoxA3GsiLdbMz2SzGLUal3UyWq+PNCcatgbxN2UI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=l+OWq7rr5HT0Xpdo8HCxvWLpFdj3nznmHnZlU9kxGi6D7bAc6XFu40ghPB2W4vPcKryKUajpmfyWgrSeYYLT5VQVEiHogE+0c9f2w0EaX1VjbmMosWhXFRGa/VYowwpzw729g1UDP36dNJ9n6hK0z1L65TpjC9Dh1ohNo6vvAz4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=le2aAuXu; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712913709; x=1744449709;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tk7DoxA3GsiLdbMz2SzGLUal3UyWq+PNCcatgbxN2UI=;
  b=le2aAuXupYYj5TmRO59lfYs9F7rBcH9qkwhVttQB+f0IQyjGbgWufdhI
   oy2dfMyUCy39dDhnVwirFzO/ZYKe9BdAgFPY8Q1WPG8yKRnHZZOJrqz8P
   UOaRE7m4IBpDRAvZZ86i1CmPzPjIarld6aLyCpfgg8+Wl7pzOFCjx3tZx
   9gQG4wFSD7gO03vZ6pmxDCS3OBDTeNuEYrmb3Nn65C803AJ8WtT6xowaa
   UZpQYoy9hLd8eZ/CDEbc7xPtBtmjGnI9GULCAbnBrPEFQ1g5Wi5kjIpcN
   C+E4Wsxo40J6od/0saZPl0prjPzK1gHHaNfWSNORMSX0tofyl4Px+WG+5
   Q==;
X-CSE-ConnectionGUID: rDGxF0vGS9iP/s5AoTT3pw==
X-CSE-MsgGUID: B7OkWlARSqWt/fwhZs+v7Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11041"; a="8235297"
X-IronPort-AV: E=Sophos;i="6.07,195,1708416000"; 
   d="scan'208";a="8235297"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 02:21:48 -0700
X-CSE-ConnectionGUID: J4kwKKo7Q/asCoF6uWCTCg==
X-CSE-MsgGUID: vHM60tl2Q0W6/TtpV0d21A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,195,1708416000"; 
   d="scan'208";a="44448608"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Apr 2024 02:21:47 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 12 Apr 2024 02:21:47 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 12 Apr 2024 02:21:47 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 12 Apr 2024 02:21:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MnnvH2BAvoYWv0L+FM9lzz6ZYIGxyaz6+AC5aKKYyMFVdO5UERcL4AYP72PlNF8a29HyzezC59WmnNak75ohZXd7h9T932NLZV3YyaSuGFnq8sBbuUGH0zx0HP5sOZwos/sg7EQmxCh6RpvcL97Wz619j/Xr+lHeTR8o8pwG2E+yzacKeFviLg8QHIgnLEG+R5CSfu+ZgUzPv4cRRQuKvgAHE1LLOoNPfApnf4+KE1vhC2Rcg0S0cw6ZISHfMlG0FEZSUjwWh4pxFZbabcHKvuDqrqSK3aFpOZQGs34JkIV4B6B1M/Dc3Xh/u1MbK6+W5AluvEsvX4oMHl5DiBdrmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MC/q2WOwUEu09pGPzkY0NSJnVSNpVw9VZcGnPyY51o8=;
 b=euT+rpwmhi8kaM0MVxBQGdOs3J5EmTrUrR4BmxYAoV6Q2uhHpmKhA39TF6M2MlTz/cZKBlm3amAX8dN+GgqJ3uRiDfLLosHwdxcjOrXpj4N7CKw3o03guaf0x0ytNR4tgIjWWkJdLfYaOnN2/P8KHqkRBjqANzQkM/yGoPf12W1A/kCFLdA4uV8Xwi3f1O8OLgwiEYz95JtsWjuG9CT+h32tdK9nU1tue7qSWG1li7zviobFRFOovMuVuIBwyYQOCMIT5Uri+cHjhfzvrnCj770AeH1WEYnxXa0WVkiGr3vtPC7QVY+DmED+IM/8So40UmjiLWgIru3jwP5D/W5AMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MN2PR11MB4664.namprd11.prod.outlook.com (2603:10b6:208:26e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.26; Fri, 12 Apr
 2024 09:21:45 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6c9f:86e:4b8e:8234%6]) with mapi id 15.20.7452.019; Fri, 12 Apr 2024
 09:21:45 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>, LKML
	<linux-kernel@vger.kernel.org>, X86 Kernel <x86@kernel.org>, Peter Zijlstra
	<peterz@infradead.org>, "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	Thomas Gleixner <tglx@linutronix.de>, Lu Baolu <baolu.lu@linux.intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen, Dave"
	<dave.hansen@intel.com>, Joerg Roedel <joro@8bytes.org>, "H. Peter Anvin"
	<hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, Ingo Molnar
	<mingo@redhat.com>
CC: "Luse, Paul E" <paul.e.luse@intel.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>, Jens Axboe <axboe@kernel.dk>, "Raj, Ashok"
	<ashok.raj@intel.com>, "maz@kernel.org" <maz@kernel.org>, "seanjc@google.com"
	<seanjc@google.com>, Robin Murphy <robin.murphy@arm.com>,
	"jim.harris@samsung.com" <jim.harris@samsung.com>, "a.manzanares@samsung.com"
	<a.manzanares@samsung.com>, Bjorn Helgaas <helgaas@kernel.org>, "Zeng, Guang"
	<guang.zeng@intel.com>, "robert.hoo.linux@gmail.com"
	<robert.hoo.linux@gmail.com>
Subject: RE: [PATCH v2 07/13] x86/irq: Factor out calling ISR from
 common_interrupt
Thread-Topic: [PATCH v2 07/13] x86/irq: Factor out calling ISR from
 common_interrupt
Thread-Index: AQHah6hf0+1860aOe0i/wzWWSuIGmbFkZOjw
Date: Fri, 12 Apr 2024 09:21:45 +0000
Message-ID: <BN9PR11MB52769DCDF70B551FCFF22DC58C042@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240405223110.1609888-1-jacob.jun.pan@linux.intel.com>
 <20240405223110.1609888-8-jacob.jun.pan@linux.intel.com>
In-Reply-To: <20240405223110.1609888-8-jacob.jun.pan@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|MN2PR11MB4664:EE_
x-ms-office365-filtering-correlation-id: b320fa49-92bd-44b8-371e-08dc5ad1f917
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lmu775Dw+mYWLiDuJ8kTf730pTiePnk1mkkXGk91vq83DoUk3pSTI3aCWaScBubEkxR5sJWD66o8Wybc5jBWeYjubgKcnyC9WCtl+AGqBrJofzaMgBvTtgludLbhDmAQdogUB5IEwUCiYoA/TuFcPtEYAdjtpyfWzVw2uycHloVnQV1+D4oalZWYXOHaFM3BJ4Darfb0cVcA1zVkckQzH+qu+15Bvf9Uxw2BPCQ6UpmwmikAA3/6SBZ46VEQNIz4amG3MNxnVsE5d5aF0ua2QL5/ssploZK7fZiFkgyrUUfVidd633SLf3mFHoOM1rdM9YN6UkLsdfP8O0LBCWQW9yw95Ln3DTbRa2JuWMLHHp1kdYE4/uBQFG2eMcJEWs0lGWFolTqee8vglk2tFoY7z67h/0+jvp2m/js4TVHGPptRuV+pkZUveI911Gak+tffwgLjE6/1fiQSXDS4bWJIe0C7IQ59xSWFsM+O1/M4OUIvhci4NJU9LFUfwGGfHkNfyeDqbe8qg4o3RHoWU7/y0r/oJUakPG1F7gnztVPq8ibO+Wp7P23B+ct/jq4Gw22EpEqFnRvQv0AmEZpf6NlqUI3u3KONr1TRc5i2CE8CIuTixVhS7/io0EW5BTsnihDLOzZixmdh0jz884iNEniBPzKfpCfrDw7Wj+8N32If7BhnAfXafWnZinwBpRWCAACFCExRdeYwByHYDufPAk/f51HbmvkAxxeurGCHrEXhKIk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(7416005)(1800799015)(921011)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8LfW5eVh49EJ9fKBlfn9A+GP5paR60raRu0TGURd3kCsaNsj/krRo4WMvY+g?=
 =?us-ascii?Q?9sT7H84nmJNKtcCijX4HwZtpSYVHyBpI4P0Y0SgshbeZfsTvRHzel+uGdV3K?=
 =?us-ascii?Q?VDkl5jg1PZVAX1++BZ13NN28GWdJfmnePOLZiMQcZy68iGhReQ/UBUUpr03q?=
 =?us-ascii?Q?0iOl5UZUsxLhk/rkbOEeTOTRvxPSPoLFmxzcTtTyFcwEhPnYQs7RGC5/159N?=
 =?us-ascii?Q?+Mel3uJH8uih/mNmx+iLJRDI/rrROelTz/Jl+xBfCx34iZclSET7onRL5lOg?=
 =?us-ascii?Q?r6ZLU+fV2wiFwLPRKDlVb5j1A8Z2J2qRNbSm58AxNZRFTPzhW/hyLxvVfQkH?=
 =?us-ascii?Q?Ftu2dpYniyFMqfO1Y1ZmjWo1fncaY7tHMEgQLSB+/OWJlcK2lDPzrm26yFqY?=
 =?us-ascii?Q?kxGjNnYmOGUWmloerBnBcyIsdQMIf1kNp4TK4C1FoSfVgSeDegb/AyKGapD7?=
 =?us-ascii?Q?Sjhx4uNPi8crNARahfCjJiidjl+YNlOfUiDeUlNXJ6TgfpL5cW5au/xohPx2?=
 =?us-ascii?Q?VPwQsK5Fs9+reY9t5YfkCcvUJVPt/aMqLCZO3YhLxaHXLM2ajOg46XxbYsB9?=
 =?us-ascii?Q?ZkJM25ipIgGZyF8m3He+MzObLlf68lfwYUihRDQgX8Vs7bB4Ch8a+rZIzE4G?=
 =?us-ascii?Q?IhF4WGTTSf3RahSrV17JOA3YCT/Ht8U5eBWGte+vfYjr4jbQRARfTmdaxnaY?=
 =?us-ascii?Q?nvH508j/otnaV639i141k12Tf1X3jrkTDEiu3Dq+JOajxBCLHEpIJc2lb5Nx?=
 =?us-ascii?Q?O+FvVcuTZWlIgKxkXVyTOILgGysjcqztvdc4GHEV87+UFxFl8VCH+iHcXZVs?=
 =?us-ascii?Q?MYF9RE6uXTUP6NSAzisV6+mh6E41Mt520O7npSF6D6z68X5IWVL9D4Nt9dFp?=
 =?us-ascii?Q?m3zfksdVLKOlSBBoNjK8U4VGUt11b2C4Zd1LxpB/Tkgfvwkri4ERTQ1/qnPi?=
 =?us-ascii?Q?EwueJDbZlCe+MCvutS2dPM/Yypq1GZAa8tBhwq6ePuXTbjl2kxtYMBD08N8J?=
 =?us-ascii?Q?DFcKu0s4l5mYhW25XuJNcA2VE09XR+XioUlpRY1kXUOPDyYp+ntuOMLSdTJ2?=
 =?us-ascii?Q?yw9beXbAgO+BDCYVBPXDlcuxrgzi5gMrwDVi0gvgwTIzm7E+RrcSgT0kpd73?=
 =?us-ascii?Q?GcV/EYjNNShBXOV2aZLkDUNPConC0NZDBD0f8LsceEpTo7h0q3IodzLBBtbL?=
 =?us-ascii?Q?w14DzD/H2WWBBKKAxRy/0AgBhT1ibaXO61tzbGT/IHpwMfTKTy2p2CBUyzDq?=
 =?us-ascii?Q?BOAPRF+sXfqsI0QfoLvUCDDwbssS9OqPBOGaKl/aXg2vPjJ8NWdha5B3oZ91?=
 =?us-ascii?Q?vhWEs8r4tCijFWxePNkcxaDy2b+fxkqTEkhWGkFYjolW4nfgT94V+2v6OAe2?=
 =?us-ascii?Q?OvVQfOkdGRXwdAdwRNRRDzzHq3op77MnFU7Y1SN60ovqPZulSIaT8nHoXFVx?=
 =?us-ascii?Q?Edyfgsuk/icIHTyZNlfnvwKsu5OwTke+77dNYHuW8c1N3/R4zXhJBGUyzfU0?=
 =?us-ascii?Q?CL3zI+N+xPlZ+6XQeuZiuYCoimui6EltJyxGk0apBYXWpp/3/Vr/bj0IAyTq?=
 =?us-ascii?Q?wN2P8U7G9Rf5R3je++ZPxwHhwv4bfIVxKFg8W3z2?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b320fa49-92bd-44b8-371e-08dc5ad1f917
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2024 09:21:45.2855
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: V27I8Xzx9F3ol9g4n/8U72kRHQZkTYWD3viKsn6n0blASNoOMksNO2ybikeVVHtZzkNUvJ+YxsFN0liPXnJzjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4664
X-OriginatorOrg: intel.com

> From: Jacob Pan <jacob.jun.pan@linux.intel.com>
> Sent: Saturday, April 6, 2024 6:31 AM
>=20
> Prepare for calling external IRQ handlers directly from the posted MSI
> demultiplexing loop. Extract the common code with common interrupt to
> avoid code duplication.
>=20
> Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
> ---
>  arch/x86/kernel/irq.c | 23 ++++++++++++++---------
>  1 file changed, 14 insertions(+), 9 deletions(-)
>=20
> diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
> index f39f6147104c..c54de9378943 100644
> --- a/arch/x86/kernel/irq.c
> +++ b/arch/x86/kernel/irq.c
> @@ -242,18 +242,10 @@ static __always_inline void handle_irq(struct
> irq_desc *desc,
>  		__handle_irq(desc, regs);
>  }
>=20
> -/*
> - * common_interrupt() handles all normal device IRQ's (the special SMP
> - * cross-CPU interrupts have their own entry points).
> - */
> -DEFINE_IDTENTRY_IRQ(common_interrupt)
> +static __always_inline void call_irq_handler(int vector, struct pt_regs =
*regs)
>  {
> -	struct pt_regs *old_regs =3D set_irq_regs(regs);
>  	struct irq_desc *desc;
>=20
> -	/* entry code tells RCU that we're not quiescent.  Check it. */
> -	RCU_LOCKDEP_WARN(!rcu_is_watching(), "IRQ failed to wake up
> RCU");
> -
>  	desc =3D __this_cpu_read(vector_irq[vector]);
>  	if (likely(!IS_ERR_OR_NULL(desc))) {
>  		handle_irq(desc, regs);

the hidden lines has one problem:

	} else {
		apic_eoi();

		if (desc =3D=3D VECTOR_UNUSED) {
			...

there will be two EOI's for unused vectors, adding the one
in sysvec_posted_msi_notification().

