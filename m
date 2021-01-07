Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0F3C2ED6D1
	for <lists+kvm@lfdr.de>; Thu,  7 Jan 2021 19:41:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727673AbhAGSlH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Jan 2021 13:41:07 -0500
Received: from mga07.intel.com ([134.134.136.100]:48703 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726386AbhAGSlG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Jan 2021 13:41:06 -0500
IronPort-SDR: n59yNbGiWLtgfpxTZh7h8Ywl0d9XduvmDrUkpJGKrj8Scx51SVwc63F6pet9DP1FfO+jEFuv42
 mvKI3VdZXyFg==
X-IronPort-AV: E=McAfee;i="6000,8403,9857"; a="241549667"
X-IronPort-AV: E=Sophos;i="5.79,329,1602572400"; 
   d="scan'208";a="241549667"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2021 10:40:23 -0800
IronPort-SDR: oQqX8k3CPRWNgw8Z6NW7bkTAm+ui5+EdW7HL4igdck6cGlbtNMdcHQYlIGYjvHXkBdLMP3/Hmt
 urv4J0HWsWlA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,329,1602572400"; 
   d="scan'208";a="347085049"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga003.jf.intel.com with ESMTP; 07 Jan 2021 10:40:24 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 7 Jan 2021 10:40:24 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 7 Jan 2021 10:40:23 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 7 Jan 2021 10:40:23 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.176)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Thu, 7 Jan 2021 10:40:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AGbDMPq/sLkBiTnucUzERyJul+foVUl71yhLtQ34TT2fJ6F23S748TEMk7tp/4hLDYjbibd7oQ6MnKKLAb/GNYmKjSgTYKueQaFBMynxyaFAnodrpev9HXEs/6+BMFfH//BvfzUNHjyo9vGRAYjIPhski5cARWlvf4gVAkT6lhiV9s17otsr6C6LQZtkXXKrHacun7Ce/FbnYTkqc/sgRJII17F1sfpKPHGfmOgkpgL3AyuyffxaysNVHRubHiQcILUw8Sj6bRl/+V7/wZijzDAYcSOuKJDqOpjLfeOAcXdnXW37YMAhSB4sAY+pRD9c0697TiVTcBpvYCrVQuKHHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oyKBf+UeMfeiONK1HOkMhQ5GORsgfckWTKGeAU3fUEc=;
 b=E01fXg9RWVxC0pz1CA0K7ZdCOouceveOJCN+MihoQfdJpy69CMkhIQoipvMKfKjkIw1Ph7VWHQYeWQgai+QZJ8vpHcP+2Q3Y3Nm1b4BXE4gOH+K8tMAMfGO/pHWEVK8Yb+d74JRh04LGeG/Pl2AVCNAkW+/bahYmBKBTGP+oByOQuWj92KU+nSoGPMKId1GvPHDXVMI7D/eE1W60FCaRR+y+O5MgAAyEq94ic9v7KO2nVMZXbz4VsOt5ohe6XCA+bbqjf7+3pdun8jitVsnlJiLb/l7QqqZiMtj8cUY6c0Zynigaf+A4oQxnggQJQcNTUEvU/w7hC94IvJi8R+nQ8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oyKBf+UeMfeiONK1HOkMhQ5GORsgfckWTKGeAU3fUEc=;
 b=FZOwAs7k2EWJLpmryszdeKYITBkuFVTnS6hAA/cP00a3n+vFISBH6ex2zbAPW6JstTjSoaCOyupA3W/uGiaFBfLu97n0nGw1nRXWKd1CXFim84zhApnUhHe9bVz85G/JKuHTRJgAzrHWjnVUcAmbk9ZUHQ2UwETGR73Ei2celLA=
Received: from PH0PR11MB4855.namprd11.prod.outlook.com (2603:10b6:510:41::12)
 by PH0PR11MB4837.namprd11.prod.outlook.com (2603:10b6:510:41::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6; Thu, 7 Jan
 2021 18:40:22 +0000
Received: from PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::819:e14a:af80:d33]) by PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::819:e14a:af80:d33%6]) with mapi id 15.20.3721.024; Thu, 7 Jan 2021
 18:40:22 +0000
From:   "Bae, Chang Seok" <chang.seok.bae@intel.com>
To:     "Liu, Jing2" <jing2.liu@intel.com>
CC:     "bp@suse.de" <bp@suse.de>, "luto@kernel.org" <luto@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "Brown, Len" <len.brown@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 10/21] x86/fpu/xstate: Update xstate save function to
 support dynamic xstate
Thread-Topic: [PATCH v3 10/21] x86/fpu/xstate: Update xstate save function to
 support dynamic xstate
Thread-Index: AQHW2UTrfabGiuGaq0+dx4jPc8ZDRKob7zCAgACnYAA=
Date:   Thu, 7 Jan 2021 18:40:21 +0000
Message-ID: <29CB32F5-1E73-46D4-BF92-18AD05F53E8E@intel.com>
References: <20201223155717.19556-1-chang.seok.bae@intel.com>
 <20201223155717.19556-11-chang.seok.bae@intel.com>
 <BYAPR11MB3256BBBB24F9131D99CF7EF5A9AF0@BYAPR11MB3256.namprd11.prod.outlook.com>
In-Reply-To: <BYAPR11MB3256BBBB24F9131D99CF7EF5A9AF0@BYAPR11MB3256.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.4)
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [112.148.21.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0cb335b7-d15b-43e6-baaa-08d8b33bb099
x-ms-traffictypediagnostic: PH0PR11MB4837:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR11MB48379ECE972354A650DAEB52D8AF0@PH0PR11MB4837.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gO3eN/DI017nQbOcHaiz7+36sVH/CVD4eKaqJHJQdQYwR1Fg0Ram6JJRkqiK+Az3niGJHovoSXIjNPvnl8dOu0tdUj7Ncnq3kmN/RaM41yfc1QjrHgxRfzoG1LGVSKc6NMZTAQhOa+g4sPjpE5eVuvipaIzq6TNMX3F0RDeY3LQ2ZIpHslpvVPDh49pNe2jCjdGTtGc86NW0gHitZmsK5kgbCrNPWVOTM+PweCog0zJ0qH6D/Mo91I0rJ+IXoEqgcA1PLLwirdtygqiNwYoF3fjF76isNHH/SfhMyVMQp9ofEXygAw3gVavsAg/Ci/cz7B0YRHmURcga6tz0sP7Gy5ZzZSk7113oKL4vOfi/lCDdAYxJbQ2k+OFaVfiLlX3+K4Sd9TTAUn0vCpNwh6PMg8pEqWrFyBk2PVZcIqrV9tdRD3lyqJg76pgGSMS9cevR
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4855.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(39860400002)(136003)(396003)(366004)(8936002)(91956017)(66946007)(76116006)(26005)(2616005)(6636002)(64756008)(2906002)(71200400001)(66556008)(54906003)(66476007)(37006003)(6486002)(6512007)(6862004)(66446008)(316002)(36756003)(53546011)(478600001)(86362001)(6506007)(8676002)(5660300002)(4326008)(33656002)(186003)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?nP20rzqrTG0cGq8P8MzGmdMQ2eG5iuslJpiRhgMr9/+QBGa3KpvnrUGHDBuT?=
 =?us-ascii?Q?wxjP2urtEbbAR699uSXiLUxSYF5pXCAWKYZh4eQthxJXsA5/iXscy7B+e8Vi?=
 =?us-ascii?Q?SY237ahK1qxmI7am6j/5nEAKBvSWYDeSXtRwifAW17GzX/3Dj8PZuaxHdS/h?=
 =?us-ascii?Q?3MsvTnFbDqDtuInhKVUYU0WpC4S18C/Nqt8/7Tw0gYfAH0mZ28CEIl6Nr/rS?=
 =?us-ascii?Q?zfd5Y+6P83khHL4SlYzgD9vWFjNaL/m7L9OoMXqLCd+H8taEDQsKw7OF/XSC?=
 =?us-ascii?Q?nN1yd4kP6LZLYN2k7N4BEN7hG1aePG2SAyW51Afxs6PL7ZJo1O/trPfznSZm?=
 =?us-ascii?Q?jaB8LNMrtJz9F7TZbR2aAImzyjVLtbwfMmCi8UQwLxFSKNKhyyjZEHId2KnJ?=
 =?us-ascii?Q?Wmx1asff1ClDIOg63So45PLgfJw7NKUvafniJTzn5djJnUQ2y7IgA0INf0Wh?=
 =?us-ascii?Q?SO+o7fPj4g82qNMA7zI14bNLbB91NWz2f8dwFtKO8m6kw4QWp5zdwokQnqrg?=
 =?us-ascii?Q?d5JdWPe3CljjSmjW3OwC6WBQPS3BAxLphagB5250x4c17zr4iDbZszaCCRwA?=
 =?us-ascii?Q?smUSsWUAgMJktSJnKUPkS93ysqqxM0M7JY7yCMej42YSKf4v74eKw1Q3Yzez?=
 =?us-ascii?Q?HG+iuaU9n8F6UtEgYiFaSL6kIWA2EMF+lFex8xRdOyDok9HDVvGps0mzYfOa?=
 =?us-ascii?Q?jOaW01GrTd8/a/E2KRiaJkqH+dSpwvnj4eCDnj+NqOFIkN+fgilfCLfF/IFC?=
 =?us-ascii?Q?JJA+SNVtCyCcwyehEZRWk3raKJEXkNxxAKz+kLMcNDgUwmlpg6OgWKeCgq5B?=
 =?us-ascii?Q?OxNpjW6p81sVSvxd2tRf/wVKUy+IQukQ4Pv3oue2CVjn9nTjjz+y6FoqjmwC?=
 =?us-ascii?Q?3egwANJFFBihZaNR9xvF9LQFp/wRkHiNLJ5BB96Cq3ZHmPlIfiI9o9UtoU9e?=
 =?us-ascii?Q?GjFIjpmDO0tcQIO2ZddrVtdUVCYxDPDGe/YHhezI5V4YKjkyUoJt2WEhTa1J?=
 =?us-ascii?Q?+gDN?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <15331A1012BFA14AA45075BB840735D2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4855.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cb335b7-d15b-43e6-baaa-08d8b33bb099
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jan 2021 18:40:21.8559
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /arqb4WkgxGKaPKHo0zvuYKt5RLLt/ZBZ/gVkZnpiBVoKc5dIZ/Ml/8yaM0WOdy6EEEDqwd00a06rit/APezk/oFONng5ecW1zXlkO4rVPE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4837
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> On Jan 7, 2021, at 17:41, Liu, Jing2 <jing2.liu@intel.com> wrote:
>=20
> static void kvm_save_current_fpu(struct fpu *fpu)  {
> +	struct fpu *src_fpu =3D &current->thread.fpu;
> +
> 	/*
> 	 * If the target FPU state is not resident in the CPU registers, just
> 	 * memcpy() from current, else save CPU state directly to the target.
> 	 */
> -	if (test_thread_flag(TIF_NEED_FPU_LOAD))
> -		memcpy(&fpu->state, &current->thread.fpu.state,
> +	if (test_thread_flag(TIF_NEED_FPU_LOAD)) {
> +		memcpy(&fpu->state, &src_fpu->state,
> 		       fpu_kernel_xstate_min_size);
> For kvm, if we assume that it does not support dynamic features until thi=
s series,
> memcpy for only fpu->state is correct.=20
> I think this kind of assumption is reasonable and we only make original x=
state work.
>=20
> -	else
> +	} else {
> +		if (fpu->state_mask !=3D src_fpu->state_mask)
> +			fpu->state_mask =3D src_fpu->state_mask;
>=20
> Though dynamic feature is not supported in kvm now, this function still n=
eed
> consider more things for fpu->state_mask.

Can you elaborate this? Which path might be affected by fpu->state_mask
without dynamic state supported in KVM?

> I suggest that we can set it before if...else (for both cases) and not ch=
ange other.=20

I tried a minimum change here.  The fpu->state_mask value does not impact t=
he
memcpy(). So, why do we need to change it for both?

Thanks,
Chang=
