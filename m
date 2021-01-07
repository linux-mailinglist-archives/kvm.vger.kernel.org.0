Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1941E2ECBD9
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 09:42:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727181AbhAGImC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 03:42:02 -0500
Received: from mga05.intel.com ([192.55.52.43]:44443 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725959AbhAGImC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 03:42:02 -0500
IronPort-SDR: QPL46HyHdMlyjw/4LIaV6zp4tb2aXf0arlSVC9pPETV9lHSsse1WV1O+ygCEaf/cpNteLQC+98
 eGrn0oihwCmg==
X-IronPort-AV: E=McAfee;i="6000,8403,9856"; a="262167239"
X-IronPort-AV: E=Sophos;i="5.79,329,1602572400"; 
   d="scan'208";a="262167239"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2021 00:41:20 -0800
IronPort-SDR: 32uvF3M49APq7R4goH9f3+e1lzOgGcAcYk/ITMCi4a16MgcllgVzcJU1seXh1rLuwvfnX4uemN
 eFbhaKJy2yXA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,329,1602572400"; 
   d="scan'208";a="402966900"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by FMSMGA003.fm.intel.com with ESMTP; 07 Jan 2021 00:41:19 -0800
Received: from orsmsx606.amr.corp.intel.com (10.22.229.19) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 7 Jan 2021 00:41:19 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 7 Jan 2021 00:41:19 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.105)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Thu, 7 Jan 2021 00:41:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GvgLRWIehPyq83+dQ25/QiGAOggC8xxkHXCBALufOksSf1qYpzJVhL/1YCSOzNddK1N0ldl5jz2yImzMjOcZOh5N93y10DPcGyIA1yynWUjuGBbWScULoZECl79fUaYpXJ837MU6+LRaLpAhCxUQShoECrJg5QhW/SUjUnaLxvMP9L9Fnu52jgxUTrj8p94AAgLcjXxHqYUDBa4Qj5mq6o+DK7r7A0xHIFcc2lJ31uiYdUwGXftyE7mdbFLxBQ/XhKB6Abphm1l5jPGTVvdlLM76CH2uWz/DEyMsZzm+euwQxKUaLiymlk0lmry1JR08JMVt1y07JCBZs1xNwQ+9jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hyKG88eKBdsRbOE5F44KU5mTEPVbHV5t+1eQJlFulnU=;
 b=GTF6YNK9By6iCZOcFehuTgPFkSJxZZNgv/vcTuZLgMmRXG13WBAemyxmQh2hnYZuPMmV7VZkBNPyJjr+qpOI9lGrf2gzBNxWklqphEpcTEIgj7S1m09S8DwXGh/UQjec6lekz7yNRu/NZPOW05hWcMgiE1xNrjvV/LRjSR3/gmUyuYaN66Tf+PYzD9BQ4YNMWfxXcPLfCoGqA0vEDVGnbqBIougmaIzGi7pK26xHywF3lVNUbajWRSkmZuoubTISkMNIQtRTIRMaiSWSLr2zVMNLd7eDvPSCatJsL5lrvsmEVA6dRtsNcglXb6EQgTiQxWcJ/MtsPdAjDXu8MTQsSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hyKG88eKBdsRbOE5F44KU5mTEPVbHV5t+1eQJlFulnU=;
 b=jyjN6Ffif6XXTpfFJJXXCagrWVcAQc+VDvxhZ6DbtlzydBpgnSeCcxzpaOfEQ5K9C1fzKnHHHr5KDZP9GQB6SPGeiCWcAlxx0S+qr3AaV8aljUnXr3Bk1hIQO3I942mP2Tzvsb1fmzTuydcnsZyA23XEFKy6HO6MzqbFPRX6tGI=
Received: from BYAPR11MB3256.namprd11.prod.outlook.com (2603:10b6:a03:76::19)
 by BYAPR11MB3815.namprd11.prod.outlook.com (2603:10b6:a03:fa::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Thu, 7 Jan
 2021 08:41:18 +0000
Received: from BYAPR11MB3256.namprd11.prod.outlook.com
 ([fe80::ac88:24d1:1225:553d]) by BYAPR11MB3256.namprd11.prod.outlook.com
 ([fe80::ac88:24d1:1225:553d%3]) with mapi id 15.20.3742.006; Thu, 7 Jan 2021
 08:41:17 +0000
From:   "Liu, Jing2" <jing2.liu@intel.com>
To:     "Bae, Chang Seok" <chang.seok.bae@intel.com>,
        "bp@suse.de" <bp@suse.de>, "luto@kernel.org" <luto@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
CC:     "Brown, Len" <len.brown@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH v3 10/21] x86/fpu/xstate: Update xstate save function to
 support dynamic xstate
Thread-Topic: [PATCH v3 10/21] x86/fpu/xstate: Update xstate save function to
 support dynamic xstate
Thread-Index: AQHW2UTrFqBCV+fQw0+L013CA01Sqaob5epQ
Date:   Thu, 7 Jan 2021 08:41:17 +0000
Message-ID: <BYAPR11MB3256BBBB24F9131D99CF7EF5A9AF0@BYAPR11MB3256.namprd11.prod.outlook.com>
References: <20201223155717.19556-1-chang.seok.bae@intel.com>
 <20201223155717.19556-11-chang.seok.bae@intel.com>
In-Reply-To: <20201223155717.19556-11-chang.seok.bae@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.204]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e2cfc46e-d96f-420b-b18e-08d8b2e8002b
x-ms-traffictypediagnostic: BYAPR11MB3815:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB3815EDC4482FE49680428F02A9AF0@BYAPR11MB3815.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zNf8W5WXK+j+PFR3jlrMcGmx3lfQK4HkuNnb4VqSITqX6zvR98nJkiRwY+JMe+imoUOxVKXbEgZ/TZBvKJTpUGgmPfztCVPrpqsxtpFoG9YsTlk1ED0jyt3bNYxEuvWp7z5cu50o1o76XLyKzpyqPhneOUNy3v9+iLim7BYLn4zkzJ7sxFfdAkba1PvAH7q4UcMGxxJyN1XNoKYQBA5kadxkSOhjWkEjUz5ANi5zJOsrHNd2yTCoHVe51ACpbdBymzNzQcnQE7GwHcEPFViRtPWW8wiztBiPJINXdwDNGCKqDDT0JgJrhlszBDQuyEfcjR7ZWG4MPVTwU9FS26QSBVKa8rPh3Gadf0VYsy0zaY21rXwTI7sKS0RvmFRliIhUPkjtUJNdUEBHXRX8TKw8Lg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3256.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(376002)(366004)(39860400002)(136003)(54906003)(110136005)(53546011)(66946007)(66476007)(316002)(478600001)(64756008)(66556008)(8676002)(76116006)(5660300002)(83380400001)(15650500001)(8936002)(71200400001)(4326008)(33656002)(55016002)(186003)(86362001)(9686003)(7696005)(6506007)(26005)(2906002)(66446008)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?UFNamgbzEwI9Tc2dPPQRF9HQXHwc1v4pZz68pK7BjT+qauHGXwcWkv/ukkhF?=
 =?us-ascii?Q?XWzOe6Mp26SmvOyIEebzl/PHr41EDWhoIjffXocGbVKIypt7T40RCa/VyAGw?=
 =?us-ascii?Q?f5wXuFAJUNX948ex89lGi0ayhNl/1yAhCgdQkNyx//3JAf7nc6VCDL+7BLwR?=
 =?us-ascii?Q?LI2Rruql5f47BQ17WmoQIlnwtuOkENL+cOEfaoBPMyIECA2dRO+FpxSmIiKk?=
 =?us-ascii?Q?SXmviLZnfhp+kMWwYb/dggdE9NDBX6npJDttqcMxwG9FvU8wRKZpW6V7rE6T?=
 =?us-ascii?Q?HDy9xpg+aRDdERGpyfx0/Mj59pUoF5CKsiQg9mkQLu+JEOJYyyq9ScQi0C+F?=
 =?us-ascii?Q?ywyChTraMrpZkuMyUS6iOzkggVQAQS8KcJFRL/21wNhpH4qQVZ95LNaMCc/4?=
 =?us-ascii?Q?a2h7EMqK3xuU+8aIshHXbhvHyCoSAQL41ZPt9EtsDT1EKEMWMg3k2Yr0ix5H?=
 =?us-ascii?Q?gqt9BTDgYX9vo0qqv6pwctbBSPpA8EE0u49LJAihf2NBxmMJKorJiK8Lj/lI?=
 =?us-ascii?Q?DYpxOyXuise69lfjIWOmIMG+nfmTfGEEW0B8y3HVx20FHGUvPlvnLQ4ubqUE?=
 =?us-ascii?Q?yBn5QZpFQ4m8bjHMB8SPtC1a2wlaWbHySlApC5eyIrMF7asSrBwJE6Io2VUT?=
 =?us-ascii?Q?qdz7b9KCoxsQgXhOCwd1cu6W1Q4F0idymI7Ucs5G3eQifcB1RpCY1MMn5tGL?=
 =?us-ascii?Q?1IptFaNnMuni04E+Ocn36SQdKgxtOPV0gG/WiEIRmESiYQEdB5s1nzZGbUb9?=
 =?us-ascii?Q?FE1o+GE2aYeDt+b0IxQ/mf5oGPeWUcai1ikLWnzKKK292jDfswJEB3Ui33OJ?=
 =?us-ascii?Q?mLXBZdvAEC9LwHc2B0CP4GUb9Qgb4bJBTCYKddxGL4zbHPWFCF0uq9jrTsMK?=
 =?us-ascii?Q?bfOs9Nou3Ft2J2Yp1FWJCL7Adg2jFu8PR4BE7mabwNRk8PcI3MEiP/B8e7sx?=
 =?us-ascii?Q?yHSWfg44j0LxieNRNEovnUkBLH91iwExfqOluAKEWpQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3256.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2cfc46e-d96f-420b-b18e-08d8b2e8002b
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jan 2021 08:41:17.6696
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5xIKBMZrocuUATNayvZnPyRcaMdtwOU6MBF8l9MB8roEW/AImBNMhpqJrz3riw6Dx4fglsWX00PM8Wzp5+CrnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3815
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



-----Original Message-----
From: Bae, Chang Seok <chang.seok.bae@intel.com>=20
Sent: Wednesday, December 23, 2020 11:57 PM
To: bp@suse.de; luto@kernel.org; tglx@linutronix.de; mingo@kernel.org; x86@=
kernel.org
Cc: Brown, Len <len.brown@intel.com>; Hansen, Dave <dave.hansen@intel.com>;=
 Liu, Jing2 <jing2.liu@intel.com>; Shankar, Ravi V <ravi.v.shankar@intel.co=
m>; linux-kernel@vger.kernel.org; Bae, Chang Seok <chang.seok.bae@intel.com=
>; kvm@vger.kernel.org
Subject: [PATCH v3 10/21] x86/fpu/xstate: Update xstate save function to su=
pport dynamic xstate

copy_xregs_to_kernel() used to save all user states in a kernel buffer.
When the dynamic user state is enabled, it becomes conditional which state =
to be saved.

fpu->state_mask can indicate which state components are reserved to be
saved in XSAVE buffer. Use it as XSAVE's instruction mask to select states.

KVM used to save all xstate via copy_xregs_to_kernel(). Update KVM to set a=
 valid fpu->state_mask, which will be necessary to correctly handle dynamic=
 state buffers.

See comments together below.

No functional change until the kernel supports dynamic user states.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
Reviewed-by: Len Brown <len.brown@intel.com>
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
[...]
 		/*
 		 * AVX512 state is tracked here because its use is diff --git a/arch/x86=
/kvm/x86.c b/arch/x86/kvm/x86.c index 4aecfba04bd3..93b5bacad67a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9214,15 +9214,20 @@ static int complete_emulated_mmio(struct kvm_vcpu *=
vcpu)
=20
 static void kvm_save_current_fpu(struct fpu *fpu)  {
+	struct fpu *src_fpu =3D &current->thread.fpu;
+
 	/*
 	 * If the target FPU state is not resident in the CPU registers, just
 	 * memcpy() from current, else save CPU state directly to the target.
 	 */
-	if (test_thread_flag(TIF_NEED_FPU_LOAD))
-		memcpy(&fpu->state, &current->thread.fpu.state,
+	if (test_thread_flag(TIF_NEED_FPU_LOAD)) {
+		memcpy(&fpu->state, &src_fpu->state,
 		       fpu_kernel_xstate_min_size);
For kvm, if we assume that it does not support dynamic features until this =
series,
memcpy for only fpu->state is correct.=20
I think this kind of assumption is reasonable and we only make original xst=
ate work.

-	else
+	} else {
+		if (fpu->state_mask !=3D src_fpu->state_mask)
+			fpu->state_mask =3D src_fpu->state_mask;

Though dynamic feature is not supported in kvm now, this function still nee=
d
consider more things for fpu->state_mask.
I suggest that we can set it before if...else (for both cases) and not chan=
ge other.=20

Thanks,
Jing

 		copy_fpregs_to_fpstate(fpu);
+	}

 }

=20
 /* Swap (qemu) user FPU context for the guest FPU context. */
--
2.17.1

