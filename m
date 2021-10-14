Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0974842D4B2
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 10:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbhJNIXL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 04:23:11 -0400
Received: from mga06.intel.com ([134.134.136.31]:65269 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230010AbhJNIXJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 04:23:09 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10136"; a="288498536"
X-IronPort-AV: E=Sophos;i="5.85,372,1624345200"; 
   d="scan'208";a="288498536"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2021 01:21:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,372,1624345200"; 
   d="scan'208";a="524977105"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga001.jf.intel.com with ESMTP; 14 Oct 2021 01:21:04 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 14 Oct 2021 01:21:04 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Thu, 14 Oct 2021 01:21:04 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Thu, 14 Oct 2021 01:21:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fOfu8Ihet+wqyJiQguSVKVVJGuP4kFOmkiydZl/L4M/+1cYpywnXD9BPp4BuZkwkhvElEsKICw92H+KHgZrnf+746ELqRLEvEhfdT5PAteRG0rn38sLqv963HEpjx9wsLN7Vu9yJaHS7X4KE5m1F4HFYjLn3BcJGD1BhjXFHOYFa7sf3dE9qej4J9nAb63RqUHlde+D/1WoizkKL5KAYNEBdTmY6v4MYqoNFAsvmmGhm++DbB+oaY5jjBF6yNDGSSgvQrisK/ysfuvKT7c/JkkqjCKXsg2ZF+pq/jo+si9j77t1/GIszEiK66zSjiZjI38iUXbf1A5QfPB0mci57sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9f5boawavqDFNXzVSkQz6Bs8/gpoSy+982cGwY8+qjk=;
 b=afR59gq8IkU5uUv27jBFdmpnEI8zl1qMK7Zk+mra4IbmUDbSoyg6pwhppaAxPMQdM4LmlmTyK+VGUm7ZGYEI3Z8Qz+XIxrOMqDjAafClVypURAho2GOg1KrTkkaZkj/Cj2mzCSoPsNARSQcFTkCwX/ovISXOhsSI+GuD6GRdP5Wj5z5FjkDKpW6Rq6zTcTHExcxI6k1vLz4o+utDzmL/WhOxUPTsxGIjbDo+6c67lib3vOCvNE4p48JrMHm0C0Wvj+j0rdwzhMzgrTewNU0Mydp2QpIvVtjRuK+7XGyE12QP/WPJjD5NLCyVDywkzEh2PT6A6zRtnM0eVjiLqnG8yQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9f5boawavqDFNXzVSkQz6Bs8/gpoSy+982cGwY8+qjk=;
 b=I9mbqccd7bE045XbIFI+niNJemNnnS9+ybsKu1G6hhO27GyVW+ny7adpYwbDBwFy7bDJFTNMSROHwpGeyohhdjVhumZ95xcPW5KOXX+2mXr/v/iOgi2IYp6XBDD/r2lRvBC0olxT566KBlPCDtYfbmb3xWO5WqI6vYcPLcslqic=
Received: from BL0PR11MB3252.namprd11.prod.outlook.com (2603:10b6:208:6e::18)
 by BL0PR11MB3379.namprd11.prod.outlook.com (2603:10b6:208:6c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.25; Thu, 14 Oct
 2021 08:21:02 +0000
Received: from BL0PR11MB3252.namprd11.prod.outlook.com
 ([fe80::7d33:5c44:70ad:f165]) by BL0PR11MB3252.namprd11.prod.outlook.com
 ([fe80::7d33:5c44:70ad:f165%7]) with mapi id 15.20.4608.016; Thu, 14 Oct 2021
 08:21:02 +0000
From:   "Liu, Jing2" <jing2.liu@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
CC:     "x86@kernel.org" <x86@kernel.org>,
        "Bae, Chang Seok" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Arjan van de Ven" <arjan@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        Jing Liu <jing2.liu@linux.intel.com>,
        "seanjc@google.com" <seanjc@google.com>
Subject: RE: [patch 13/31] x86/fpu: Move KVMs FPU swapping to FPU core
Thread-Topic: [patch 13/31] x86/fpu: Move KVMs FPU swapping to FPU core
Thread-Index: AQHXv42x8Iw8v1bdT0WqN+QXiZLaIqvQcYTggACYyYCAAR5hgA==
Date:   Thu, 14 Oct 2021 08:21:02 +0000
Message-ID: <BL0PR11MB3252466D4A10A141F025F425A9B89@BL0PR11MB3252.namprd11.prod.outlook.com>
References: <BYAPR11MB3256B39E2A34A09FF64ECC5BA9B79@BYAPR11MB3256.namprd11.prod.outlook.com>
 <87sfx57ycw.ffs@tglx>
In-Reply-To: <87sfx57ycw.ffs@tglx>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
authentication-results: linutronix.de; dkim=none (message not signed)
 header.d=none;linutronix.de; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0f1f11d2-cf69-4cae-2fca-08d98eeb8f6f
x-ms-traffictypediagnostic: BL0PR11MB3379:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR11MB33793C2A9601DDA6CC1A41B2A9B89@BL0PR11MB3379.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8SmhJGvGcLKR5grTv8kBTkZBaN4G/0D2MlAO28Jqt7L2O5L+u6fp0Xp+oqS2mEMxW5+XwzDF+he1aroU31MwkH3qbMPs3ipZvc62Rx7OhlRAruJosqTJiGiY9luYAwehSOlt4xYIoq0X7D01JGgs/Vsv3LHu9UeA0DqS2dd7u8I6Wcj7wfBdM/uJTx0ECcGEnSPvP5FDjftF3cZx5ZSvCPn73eBSFpjyVp17W9QZN+NVNIsohG6I1OevN8LPfKo7pdYYGDZXTuDH7lEs164wzS1QMjdKpiOyK5M1XyXuvHkV5tXLnqCeb8L7QCL4tqp1fFdi0m+i06O/ASVU/s7I10gk/ehtOV66W55pMtCfOETFORLp1V8FgxUMJqV57vlNC79dDiTeBS0EbJA74oMTZlFOzmhgTxF3LLnc16UIP25PZKSJUxKKgO/jUeKihh5wQQE3Nyuf28ZPIuE04FzizV86FJ8Hwcel7A7V515FL+TvZrKT3ESO/LZIEwEkyS0drqitT2uwt1PymkRfCoHM2pHs2vlaU1q1YM+6xoD1qqk0XHs9q2vFMlu3c9kMjWfQ9G1CQmp8xKUhtx8fws2INpt55MDYFnWzo6GVoLUrzAvrxr2vB5UVPGSSooSDLKDn9F9F2vdMCg0gPRAZ2H8Sk7Uhi+aIe74UPuZ3MPjIMlpEF7T+D64tbhvH/ZmczH5q69dIC12LtHojPOs5X1QjuA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR11MB3252.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(55016002)(83380400001)(76116006)(52536014)(66556008)(110136005)(316002)(38070700005)(33656002)(4326008)(5660300002)(8676002)(66946007)(2906002)(8936002)(7696005)(26005)(66476007)(64756008)(66446008)(86362001)(54906003)(71200400001)(122000001)(186003)(38100700002)(82960400001)(6506007)(4744005)(9686003)(508600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?F6mYm5F4CHPSwG1GzK5X0MG66l7Z97ah5HhLrIypPsvEX21shMdZwkFl5oa2?=
 =?us-ascii?Q?HZdT/w9PjG2BSJS9bGzTLPZmjfk9LH5g3a/nsHiCuAcnXYeTDWpvzZJcjvX9?=
 =?us-ascii?Q?UFLNIfIXz5xiZfTUUw8O66K1XthZ5D7nLvprsVqS70wHEbRPspAYZEuafXYl?=
 =?us-ascii?Q?mf2rrhGRNtbMa7LNFnKpCUXkKrsWbZP6NrnEEThNW/QIRU+FqqePhTzM8p9W?=
 =?us-ascii?Q?c1qeyssRGjKMhq83ttjhuwrrPsawxtkHPfrBsSt/aqm5cT2NvAAgGOFZH/gS?=
 =?us-ascii?Q?yWWZJLU7Ea9IGcIYT+NE/qz5sU9h3Z6lfRiymGWBEW9uVFPcHf6W/Lid15i8?=
 =?us-ascii?Q?77kydteT3ZP8si/t8xkKzWaRvaDmTAq1/LZr+Ufu239/4+oniouaL7vty4Z3?=
 =?us-ascii?Q?axm/dx1LvHcsQfupMP/IeAq0SImel4VkNEmMgOyfhlncSaqYmeHX+p1yeR0e?=
 =?us-ascii?Q?nBjiI1PUfAxG20fH1UjTRHooC+wz3rLvfar7o3WW2wtXzkkiYKa5ejmRYli7?=
 =?us-ascii?Q?6MBMpRYyl++Q3i3/EwpcnwL8gUQ8/G+ltOPXB0C5G4qs/ErY0HUPa5Q6t+uS?=
 =?us-ascii?Q?DeLuE4G1jCkkeGCA2x/BjbEyOnggl+t5oLaBbEndYBtFx1tdNO5MXUXFyNJM?=
 =?us-ascii?Q?jrvFkDgSerFrxD9Wt8JN25XZsvPoyJADWkmc+XawErCQ7Wh4fXiHz9J4st+P?=
 =?us-ascii?Q?bQsCdxg72PazWwxlSUjzhhSQcDOMqzRbBdCOWRn6fPlASODNMYtFG0JgjNYE?=
 =?us-ascii?Q?VJqB4SYaf8yMZTTLfT72/bpm/UNqEVVNGZ3X4di+drrdrBlxStwBOgG4HnpO?=
 =?us-ascii?Q?IFbkwusX2evIjuZEQo5EFL1fzqQDAnwoqNOjO5EWVidbjDzXZZhFiMcaWBBG?=
 =?us-ascii?Q?TsFA0nDJ5B3FNWHTjb+AVlCfxEd2nmh8NijCS2Fz4ZFfFLk6KB8IwH+viI/M?=
 =?us-ascii?Q?QPKz7TfdGVoLd+pUtJPfNk5E1xerXcLT7ZPPSSli4hhtkiOnlsDUDvLQTRCF?=
 =?us-ascii?Q?dM9A30JFZBpMUUi61/3WEMjYc95wS1y9A0oPYoMexOslvcWAeSVOPQBWQ3PI?=
 =?us-ascii?Q?1AiyKbW70cSeueJRN4kD/x8b1idaODBIruPaDKzmNi2mE1LQg+Pzfwl46ibT?=
 =?us-ascii?Q?dFTguRtoA4bZhz4uaNjevfAZUkLOd3mPN5ba+eAg6jfwvzMPU2oHDeE3G1OO?=
 =?us-ascii?Q?Q56My7w7OgwVRXYpWTj3kUnQakLnu59MgIU78xuM3pH77fgd0F4KZZiYFknL?=
 =?us-ascii?Q?0JB/+rDBZOetSwdXyhG6OgvzwlW+94yi+eCdHqrHwng9pZtxgxjz0wDwAuLx?=
 =?us-ascii?Q?MqbsNpmBBnl3z9h2adYbL1u6?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR11MB3252.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f1f11d2-cf69-4cae-2fca-08d98eeb8f6f
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2021 08:21:02.3753
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Gyg7K5++uSo2Zuz19DapyVlyzK7welpSveRso81I5tedxXRYTwFrlQ8SBVQO4iTkgYaKj8uVSn9kjuI8zqKkmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR11MB3379
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> > 1. KVM dynamic allocation API:
> > Since KVM also uses dynamic allocation, after KVM detects guest
> > requesting AMX by #NM trap, KVM need alloc extra buffer for this
> > vcpu's current->thread.fpu.fpstate and guest_fpu related.
> > So far, the kernel itself has such API like fpstate_realloc(), but
> > it's static. How about making a common function usable for KVM?
>=20
> Just making that function usable without a proper design how this should
> work at all does not solve anything.
>=20
> We first need a conclusion vs. buffer reallocation.
>=20
> Once that is sorted then we can create proper infrastructure for that in =
the
> FPU core code and not just expose a random function to KVM and hack it in=
to
> submssion.
Yes, we need a consensus on the way we choose and then to see if need a
kernel function for KVM usage.

Thanks,
Jing

>=20
> Thanks,
>=20
>         tglx
