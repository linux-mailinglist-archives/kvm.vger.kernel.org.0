Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F1DC453FC3
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 05:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231472AbhKQEzh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 23:55:37 -0500
Received: from mga02.intel.com ([134.134.136.20]:8783 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230083AbhKQEzh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 23:55:37 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10170"; a="221094867"
X-IronPort-AV: E=Sophos;i="5.87,240,1631602800"; 
   d="scan'208";a="221094867"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2021 20:52:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,240,1631602800"; 
   d="scan'208";a="593156898"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga002.fm.intel.com with ESMTP; 16 Nov 2021 20:52:38 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 16 Nov 2021 20:52:37 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Tue, 16 Nov 2021 20:52:37 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Tue, 16 Nov 2021 20:52:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MUT57HrcCQ2DyxggEzQTqhBHvifMCWrSB596ctYfhLAW0HqvsVC1NWrs4kesCV+5m1TI3lIrFDU5/UUSQ1f/pUqTpcMOZQhri/OgwZg/e85DsYiodHj5AH0VIcgTm5xml/gUFAwzwxwaGpecsAJ9J2v8IXHJUCCsyFxuZ+T4uG2dfnxtiFQDDI2y7gBsNdYEaidDgxMp0BPjtDb7qvJN+jWiL1CoRt16iUGbQm3HkcGwCH1hi091RNjzL9ZP0/29QbuH4dj3pmgJ1cdHYt8jLheqvW3rpaKAIVUoUI7loUNhn0r/ZY320mDO26mwzC/+KwfUn7I4TxfludNg55TnCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Rf9ia5ZJpc6gVSNh/aEqLLdt5GLeJ4avqkIlEspaddo=;
 b=N58YjOFR/FL0Eiy5MOf3AvEILUrrezZe27pLXdCN5qXLzr3+fLdZp1YQRbjHtuOcg2pIG+Yb+D3Uj1o94v9C7QmqaQZG4TmHKib7R7hTMFlsVnuedTI2+LYN0OEnjmG05uodekeVGLPkKhHhEy7KpvNjgmNrjJxRIXapMDUNX6HamTg84ab5nrxq10HzfSLnSBjY+C3MQ89O3dkF1ZcQdEi8rpqpw4WbC/xkVIexxuorL1m8gGemz6YR261Bw2peE/MHvjGJf2utuInPSTHuuvayc3GNoKMUG37esN3HWNkN9es7b1IwQj8p7H2tVM/ELjQ6TIPBvTAlQJtWymsiEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rf9ia5ZJpc6gVSNh/aEqLLdt5GLeJ4avqkIlEspaddo=;
 b=PFofq4SdwbMzPs4QClKH1OrfqB8mZJXwS4RE6LJfZK4f+GjQlFkVAFSF6NAf7yQUZB1AvvUrskucwSnawqQjRf2SPKm8JRlhX9mVLhqK02njsSHI8jlIUvTToqYyyDX7difIJqeTwytc2VVcoTCRXRWlfhuA5NLuBqwm0N2xhdg=
Received: from BY5PR11MB4435.namprd11.prod.outlook.com (2603:10b6:a03:1ce::30)
 by BYAPR11MB3669.namprd11.prod.outlook.com (2603:10b6:a03:f7::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26; Wed, 17 Nov
 2021 04:52:36 +0000
Received: from BY5PR11MB4435.namprd11.prod.outlook.com
 ([fe80::348f:bbe0:8491:993]) by BY5PR11MB4435.namprd11.prod.outlook.com
 ([fe80::348f:bbe0:8491:993%5]) with mapi id 15.20.4690.027; Wed, 17 Nov 2021
 04:52:36 +0000
From:   "Nakajima, Jun" <jun.nakajima@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>
CC:     "Liu, Jing2" <jing2.liu@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Jing Liu <jing2.liu@linux.intel.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "Cooper, Andrew" <andrew.cooper3@citrix.com>,
        "Bae, Chang Seok" <chang.seok.bae@intel.com>
Subject: Re: Thoughts of AMX KVM support based on latest kernel
Thread-Topic: Thoughts of AMX KVM support based on latest kernel
Thread-Index: AdfWMJGMz5/jeSLQRn+nYCX+7Qj8nwE7nDEAABP7RQA=
Date:   Wed, 17 Nov 2021 04:52:35 +0000
Message-ID: <16BF8BE6-B7B1-4F3E-B972-9D82CD2F23C8@intel.com>
References: <BYAPR11MB325685AB8E3DFD245846F854A9939@BYAPR11MB3256.namprd11.prod.outlook.com>
 <878rxn6h6t.ffs@tglx>
In-Reply-To: <878rxn6h6t.ffs@tglx>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.7)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 396722d9-d8d3-4d0c-1151-08d9a9861311
x-ms-traffictypediagnostic: BYAPR11MB3669:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BYAPR11MB366994E58447F6C2BEAF4F9B9A9A9@BYAPR11MB3669.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aSX3pypp4tSyskLSrUZIDfK+p3YFAaMYUMFM3+McAFUO4OJNuu/aYUJBWKC0TtU6l6NKqCCkvWfshvLfUbDZtIHmNUJPq3Ui5ea9J7kkUx0pDkPqasGe2mHYV345CbdyWuGNWjXWPhZP6viLQGtGoPW5Yqe05K7X4CDiqwdRGsDdNWGRpJqPLIpQ9z5Ycagu/qgtp99AWTwE8PnkwQ58d2rvR4kEK0xyTfS3Y77E7Dl86cY1Bxt3vtpKqbVgA0G8ooChWIpdtHh03jBSHsJtL8bhtX1OMnPlfPsJiAkQoo7bRwjF+wlpGDxqWKVyWz6ujh/OFLmHm+QMjPrrkVEjXjU36qcaLAcjdK74pluv2Golvh6EHD/F8XBXr3wwXqSZK/mZKGPhi4sbmtGD/tyhrcC0lmmzXuU5NEtEwYldGSJqvlDxrufzdNRiBJdUiz6S61/cObCnOP0nJvWKldDOvZgn2XkfimFagumFuTK76usu7ZZY0VXIec6NlGDZ+qq1BBuMKr3O/isB31cJVCai41UZuMbkPy27wmk47QjXeRnIrRABaiXarQwot6w9k63vDzlozdW2e/vDq86JYigvU1/Aug+B1ryxcJVdSKGUIArYv2fUWWVqN2uHqiqa6PXlUBV/1pAKIR+v9RBnZxC7GLSXZPZ4E04T1i/huUaXbtNyJWXD02++PHDfOY36qOapMkvq8KAb9weRs4lwNwvApWuw4OvDZMmpUaGRAJ4zl5gG0GIZGYy5cmC8p0jp6A6u
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4435.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8936002)(83380400001)(7416002)(53546011)(6506007)(8676002)(5660300002)(82960400001)(4326008)(26005)(6512007)(2906002)(122000001)(186003)(6486002)(38070700005)(316002)(33656002)(86362001)(71200400001)(66946007)(66476007)(66556008)(64756008)(66446008)(2616005)(38100700002)(508600001)(36756003)(76116006)(6916009)(54906003)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3qJVlhdb5Py/Vjkfp7AstBHDqom/00ItiFhctTLYVv/rCdCO5WvoxPZIx4c2?=
 =?us-ascii?Q?B2KEcVB3SWVZIpqPmYGphJfJ9wYkYQs4Xk8H8yiXbc+a0rVoCFaBKbTQ8WvM?=
 =?us-ascii?Q?wFA5X5vU/zUANVKVaQCzgMGBjbO8TTkAHRzbwF0zxX7dYxaPuCGdbYgwj1Nx?=
 =?us-ascii?Q?wlTRaGgmiJbvAW061hVAticoLMnQyJWuW3+e1BDHCV4JeuQwr5Ws4V/M/PG9?=
 =?us-ascii?Q?dX/SSQrBSZXknOCxMXcZWWgUqW2/uwsSt/ghNCrO0/PJx+ozj6vgoQWmkNVv?=
 =?us-ascii?Q?qJjn42zDPy+RFeulRZNJ/BQpWVtxrg9vB3uaX94BCV8pyxnqav7JyyiVmvVy?=
 =?us-ascii?Q?fIpmcUnnvD0K2Li837nWmg++9g6hegIFEw4xm0BIX/ildV/RweCGZTpg3LKn?=
 =?us-ascii?Q?B+NC8eJ+i9cFBnBwkaGlzrx77eANiUNTIfog2KRAtbc1i5nVMvTRey1tkx36?=
 =?us-ascii?Q?3XKkm37I85j5rd/CJW+0IViK9qTLWStiV3c/v6gY5TBh5qhHYcyBxwIfkAcZ?=
 =?us-ascii?Q?OC4H3/ajx3vwnjkA/An7rcICP/KSOMknOI/ZzSfUZ5BnYKGpPU/C4ZZwkehE?=
 =?us-ascii?Q?vj78g2UqS+UP+Ko06VIqI876VCKKPBsiHbeenDD6UAGjKU72gG7+xIMI2xQ6?=
 =?us-ascii?Q?J2n0bH8fDP1Vq++fw07x1dApUa/OO/jUC0jQU1F2nxGXqbfHGP/QyuWviM8E?=
 =?us-ascii?Q?+NmbCAOxSTWlpNc5xdSjVaiU0QiTT4BEtX2nFW/VbqyaaSHlzhVWV9n8ImB3?=
 =?us-ascii?Q?OTpHts9kvu2eOwnduNYqZwJbpNl77kDtYG6CpgRUWytzFUJY6og+FMsGAZHf?=
 =?us-ascii?Q?Su7VaLokN3rayB39N91pfvNmUZurIKQ6epCOg3XXombeQJjJznlvRq0X0z8T?=
 =?us-ascii?Q?00vsjflgaJDmJHtKU3xmhoN0YyD0NGTDDaNpzprrhjVE7jqXEBvGNmlW8+Oh?=
 =?us-ascii?Q?YOEUl+dNqY303q2sr+Mlwi5wIqqZ7J46fiH4ZO0wp7xMrnnYUAkWtI8/vPOT?=
 =?us-ascii?Q?t81anc/sKWS9FnkFXixa0rUtPcbI5+E8jwZz6DZv/WerN4koY9/+Bg4xtv5v?=
 =?us-ascii?Q?rO/U8PlsDFf+hUHaMhbQwkbAp2GX3Ae919JCYp3f8SxuIuJpAHWmBKM1MEtu?=
 =?us-ascii?Q?y/l/PxkTEruZ7GlmQIDrbkHaUDkl1mElw1RKp9/ihoAefHTetzihUsBNWVNZ?=
 =?us-ascii?Q?1cCKoE5tLlmON4ZPolITKwL9jBku1mudPLDouvFfZTQ8O34MEsIYo2/VRNBN?=
 =?us-ascii?Q?AQffC+oRS1qlF7SSjFHoBUD4ost5Tzra27vb4FsZ4FnIBrzvQyie82SobvZD?=
 =?us-ascii?Q?GD8EH43J91SV8dX4xDy5L4Qq/teiw/gPVszB1OKF+990cxV2009Ls+pql5ov?=
 =?us-ascii?Q?UFHkusu/0Tmm9N650Xzht676VkAc0mRf0msOo2dpMv1LaKT7WI3XxHjA0Zgt?=
 =?us-ascii?Q?nIbsojKSoAWZfVtBHqRIdsqjsO5RwcUnR7DcB26OCfIaN7cvsRNOkU1tosla?=
 =?us-ascii?Q?Qq0rtGRD/nTxI6XbCH+be2702XPB8mHS7KBReFo1FRdXtIj04bmJWg/oQrlF?=
 =?us-ascii?Q?QMKacYIIDOxyMgA4kIF/Zh+mgj/2YzBeY36icN1o4liEyieXPoJtZiEA3pQZ?=
 =?us-ascii?Q?tPrQlimtbS78k2ixOABlT4E=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <CAB01BE743E22444946D4A12DC08887A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4435.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 396722d9-d8d3-4d0c-1151-08d9a9861311
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Nov 2021 04:52:35.8874
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 04W6i89PFBpHJqiKoKYEJ1+NrPHt5CfSSpsz7OI1HEVRVjmgv37OdLGa/NFUV7OGQJZ6SDZsGNWPOmn5MHDZsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3669
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>=20
> On Nov 16, 2021, at 11:20 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
>=20
> Jing,
>=20
> On Wed, Nov 10 2021 at 13:01, Liu, Jing2 wrote:
>=20
> more thoughts.
>=20
>> Once we start passthrough the XFD MSR, we need to save/restore
>> them at VM exit/entry time. If we immediately resume the guest
>> without enabling interrupts/preemptions (exit fast-path), we have no
>> issues. We don't need to save the MSR.
>=20
> Correct.
>=20
>> The question is how the host XFD MSR is restored while control is in
>> KVM.
>>=20
>> The XSAVE(S) instruction saves the (guest) state component[x] as 0 or
>> doesn't save when XFD[x] !=3D 0. Accordingly, XRSTOR(S) cannot restore
>> that (guest state). And it is possible that XFD !=3D 0 and the guest is =
using
>> extended feature at VM exit;
>=20
> You mean on creative guests which just keep AMX state alive and set
> XFD[AMX] =3D 1 to later restore it to XFD[AMX] =3D 0?


Typically a (usual) guest saves the AMX state for the previous process and =
sets XFD[AMX] =3D 1 for the next at context switch time, and a VM exit can =
happen anytime, e.g. right after XFD[AMX] =3D 1.=20
But this case is okay because the state is already saved by the guest.

If a (creative) guest wants to set XFD[AMX] =3D 1 for fun while keeping AMX=
 state alive without saving the AXM state, it may lose the state after VM e=
xit/entry. I think the right thing to do is to avoid such programming in th=
e first place. Let me find out if we can add such notes in the programming =
references.


---=20
Jun


