Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB8E73FF7CB
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 01:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348029AbhIBXY6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 19:24:58 -0400
Received: from mga04.intel.com ([192.55.52.120]:25062 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344233AbhIBXY5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Sep 2021 19:24:57 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10095"; a="217414976"
X-IronPort-AV: E=Sophos;i="5.85,263,1624345200"; 
   d="scan'208";a="217414976"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2021 16:23:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,263,1624345200"; 
   d="scan'208";a="578414951"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by orsmga004.jf.intel.com with ESMTP; 02 Sep 2021 16:23:58 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 2 Sep 2021 16:23:57 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 2 Sep 2021 16:23:57 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Thu, 2 Sep 2021 16:23:57 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Thu, 2 Sep 2021 16:23:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H+/cPBhC4QJZuJmYDr927Ppib+MuVf+I2gbR3iPIO0sYC4kO6s+lICWG//iMlez1bq1KZ8FQGOwWpJjG+KFhz1mSh7CZ9sZ52AcTXLB7AWd7Mqw4g9VXvwXUXujLV3/pDhFhRtgi0XvDnsb6rhVBCXLwQ3d+kkkxe34EylMvn89u6nNVjcX/aFBnG3IufFR4a5K5hvFcoCX2Kyp6YlsWKZ2mWMUKNv06kxc1NbXWSpKHlm7kUx8Ump18D6RH1GUjnEJrqt1rfIOzCJa7lZ/LXvgg3RBz14tqGQ6PxiTgfFaOY70ZdTCjmQ0xal/2eUpGahYP2vzMJkKO9lkv/tWFnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P1MRYC1ccuZuEUb3bhpVgzaCWw4vV85m7snmOk+lxzY=;
 b=DNLfxIt1jQgl8hsydvnT2RjUWfGoY6fwblZ5MxfpPLvYxBNqpny1ex8Nid6/EBQMrvIHAiJR96H6WJwDmwaef9MckHgxqPKVqTfkij+Pb3GlOe1Zkkhil3oL2O0Hj3vzC3ZL08UgUOxPCGozWvmJ8X5goofvyBwVi209akvQcmB2T9gktRVnTBMN4OwFOUTF44zCGKKbsv4dDcW0DwfmmlozSYNR7LKeArIrLlsmBrwxNNMLxAAA+7hoToLoIhK32brPWxiHQESzKgiApElhtlr7gDJyVBaNwOCB4iewivQZcTTtzfEqdsu06MayDf+VMy8KMh6A5k3EozhISsluGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P1MRYC1ccuZuEUb3bhpVgzaCWw4vV85m7snmOk+lxzY=;
 b=giaXe/3n5So4z7hlusGzqr1UnPTyPE01x+tI/u2fIUV0oiR5Xib1WeM7yA6o97L7vuZKIJDrlDANbSuco/naRydrUP3OihJo9Rb24A/3cUfBlg+qZn9daT/5HFJQdp3bZeDbxqVKyQ1l7TYVfSg8YWzG4bG/N1D4mFM3v82aW98=
Received: from BYAPR11MB3717.namprd11.prod.outlook.com (20.178.239.140) by
 SJ0PR11MB5069.namprd11.prod.outlook.com (20.182.106.70) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4415.14; Thu, 2 Sep 2021 23:23:51 +0000
Received: from BYAPR11MB3717.namprd11.prod.outlook.com
 ([fe80::bd96:f74e:235a:90fd]) by BYAPR11MB3717.namprd11.prod.outlook.com
 ([fe80::bd96:f74e:235a:90fd%3]) with mapi id 15.20.4457.024; Thu, 2 Sep 2021
 23:23:50 +0000
From:   "Yao, Yuan" <yuan.yao@intel.com>
To:     Ashish Kalra <Ashish.Kalra@amd.com>,
        "yuan.yao@linux.intel.com" <yuan.yao@linux.intel.com>
CC:     "Thomas.Lendacky@amd.com" <Thomas.Lendacky@amd.com>,
        "armbru@redhat.com" <armbru@redhat.com>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "ehabkost@redhat.com" <ehabkost@redhat.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
Subject: RE: [RFC][PATCH v1 00/10] Enable encrypted guest memory access in
 QEMU
Thread-Topic: [RFC][PATCH v1 00/10] Enable encrypted guest memory access in
 QEMU
Thread-Index: AQHXQhjaQ3J0WksA2kKj3NZitTxgHquRgreAgACX/3A=
Date:   Thu, 2 Sep 2021 23:23:50 +0000
Message-ID: <BYAPR11MB37179FAB0D067E0177498E2795CE9@BYAPR11MB3717.namprd11.prod.outlook.com>
References: <20210506014037.11982-1-yuan.yao@linux.intel.com>
 <20210902140433.12994-1-Ashish.Kalra@amd.com>
In-Reply-To: <20210902140433.12994-1-Ashish.Kalra@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 135a7c5a-0eb7-4935-e358-08d96e68b8c4
x-ms-traffictypediagnostic: SJ0PR11MB5069:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR11MB50698C5421C365F3CCB45C7095CE9@SJ0PR11MB5069.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Rp84ZAKTd38qMTGDutOy4qnW2ImrdfLVJAPoWz2lQnvwErrB4dGxRaaU+PXkRk6yp3EUnw0f4t29zMAl2Ji56J23mMxxo6FxryjOjStQtHznn6ML0cO6jRLvO80XhKioKF1euAa0FdwApFCYhE8vk/jnJnvcuTOHpAJ6BDvphL7xBBux3Eveigx4cmpdH5B4UKv/h2X+d+qyUkCtbc3CEWr0eFcQTwHUrgZjECTyqLzdbd5HQLlyqRcvEY7HXGir3zpy2yVVgwtQgkrF7Yg6zhl5uYilO7D2vfaSjHciW/CBFdYznY4YrQlIbuOS1AUf9KoB8ptMXChNYNQmShDBma29lgfinhiz63cNkToPs7ENUYfec6d0qV9UwG5TiQrR4qh7+tO3t0kH5jwVe/xzfKg4O6U+EUBEvMy6k2Z1szJx2e76MBM3RiOZzAvZOls8ubRrAVY2u8XeYg+0i32lfMqPb8MaDewlp7QvtHYXvQr/Vkhc2MPI+K4qNi1vSDaf3LoR/tm7CBVqsBooSc6jsBWfO1d3ITOjmMf/bz/plM/oFK2yKXNttsqQlVyGj7jU2jfFPDLrHy6NJLHeeTaBW9W44Voyo2lcHJeI90nXXPqcloJzSHIuecRm+cpoyMwQ9I3Do4vw5UVRo53zJ12GjhzsS5lTL/F78pPSF4zc1bGDl59Q3VoYbk9vIS12mmDT1baUy+Gtk56YDLAP11dAuQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3717.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(39860400002)(136003)(396003)(376002)(38070700005)(7416002)(76116006)(2906002)(55016002)(66446008)(122000001)(316002)(110136005)(26005)(66476007)(64756008)(6506007)(52536014)(186003)(9686003)(66556008)(478600001)(71200400001)(8676002)(33656002)(66946007)(8936002)(38100700002)(7696005)(4326008)(54906003)(86362001)(83380400001)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?izXnaX/oV85jZVXeoiUae/anDK+NikqYTFa9v8gyIA2VTDeA9HF+Z/oHzd7q?=
 =?us-ascii?Q?K22UzuGvD3u1Zga0KR1wwtEpD/+XH5+g+i2X14AQ38jJEtvIAlcyZyWFTM6i?=
 =?us-ascii?Q?zlRF19IwcT5O9FhC97Ekpgg9UvomnIkZiD3Iz7VOdkJeNKLtK6hlH41tzD9W?=
 =?us-ascii?Q?nCF7oA5IghV30FFiaK4g1aahth2F2qUSsZI8jivSnilrIwafpYQEUqOaDF+T?=
 =?us-ascii?Q?11kxY3RLIB/ModoC6IRGcbGAdj2wITbsDQyPFYzXFQSCjLvpcjicZhp7OzKC?=
 =?us-ascii?Q?kNEQtP7E17Vo5xPO4/RXpcrGzBB04X9Ypv5dC1PN5rHmKVO3QQxKOEQy/vz7?=
 =?us-ascii?Q?fVKUM+4VgDCpDK8OmAZ27992H4ZlILQX2ysxad8a4dRRHTT2QEgcvzPbf6sP?=
 =?us-ascii?Q?W1QzwJt1kITf9+gyBazSAImIkb5+528dhFP/35D117SItZjBCreaM+muYzar?=
 =?us-ascii?Q?Gkv4OZ1OI5MjeDPdg7j0t4T24sBdvI+wHRs0T/ua4KJCMJ5h5BcIkrbNNVRV?=
 =?us-ascii?Q?8S1I+F4p6UEeD35eEDWionUgJUz9GpRaQZJ1oH1FDFsvEaLB/zj0fnqFOl79?=
 =?us-ascii?Q?NBxzM5Fy08UYvZww94WRXIZPM3pdKGWUZU/7jof702V7jYRJXQvnIrFT1Gr5?=
 =?us-ascii?Q?fSC4j39P4RMNfQ1CYl62/JHSo+62V77R+SIEvmFoqqHFpDXK3tUVT1IVd9mR?=
 =?us-ascii?Q?ZGrFqRsXsQ6jjyjYGdqbR5xvFHQezuVadWFS1jnByw8IWc8/eM9mids4X/o0?=
 =?us-ascii?Q?VQZp4ji0Y+4NOSDuEpXragqaTBe236Y6nJj/z5kS/kESyhZX4yhTa7LLvCzr?=
 =?us-ascii?Q?aQUuFtWpNUqAZ9n4AGpwCCcoh2/99aZpKyya8B6geb8UAKHpBdg4zPJejNXK?=
 =?us-ascii?Q?gFkyGUYvhA3Y0Amrp3RqxbnKKaMdFDQIaUSWLlYK36cWZcD/qCcL6TzSRplS?=
 =?us-ascii?Q?S0PkB95ym7a6VJSSM8nFPOPYgxVrXPP01FnVsjR8ndoBba9JAY0aMAGokQJP?=
 =?us-ascii?Q?wS8wxePbT8h/KbXDezGJTVWcsyL8kUs1bWr6u6+/nvijFGfe/OUVhI/3Kxz4?=
 =?us-ascii?Q?mnNbOUuNnbpsUhFKw1xQtndTyEPZSDJVLz6WIQ8nSR4F8CC1lv6BnQ3wcyCu?=
 =?us-ascii?Q?dGbyp6OrbL/sAKiwMFMbi9fzfr57V4GEKP5YD1Esth5GQXcnxR02PihM9P4u?=
 =?us-ascii?Q?lfoX+xBJCdQ+Qsjm2gABpmkmw71+SQK3n05CptKb5pi+Zrd3Ho79uc9ld6po?=
 =?us-ascii?Q?nIdx9hnIbrtlTpClqNrSDGgUEOF38Zl3KfgpmxLE4ikzT1y76Jpf+u/XXzwn?=
 =?us-ascii?Q?Rucd+w3F6Sf6Socq1SbRaHqG?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3717.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 135a7c5a-0eb7-4935-e358-08d96e68b8c4
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2021 23:23:50.3681
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xCE/Xrf7vUfsz2FcuBv86c6wJHgXN8CyhJEdeqXa3LgkmeusQByrPTbvoIDn1AMrtHLi0Sm3ZE3wqTqwg7aDyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5069
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>-----Original Message-----
>From: Ashish Kalra <Ashish.Kalra@amd.com>
>Sent: Thursday, September 02, 2021 22:05
>To: yuan.yao@linux.intel.com
>Cc: Thomas.Lendacky@amd.com; armbru@redhat.com; ashish.kalra@amd.com; brij=
esh.singh@amd.com;
>dgilbert@redhat.com; ehabkost@redhat.com; Yamahata, Isaku <isaku.yamahata@=
intel.com>; kvm@vger.kernel.org;
>mst@redhat.com; mtosatti@redhat.com; pbonzini@redhat.com; qemu-devel@nongn=
u.org; Yao, Yuan
><yuan.yao@intel.com>
>Subject: [RFC][PATCH v1 00/10] Enable encrypted guest memory access in QEM=
U
>
>> - We introduce another new vm level ioctl focus on the encrypted
>>     guest memory accessing:
>>
>>     KVM_MEMORY_ENCRYPT_{READ,WRITE}_MEMORY
>>
>>     struct kvm_rw_memory rw;
>>     rw.addr =3D gpa_OR_hva;
>>     rw.buf =3D (__u64)src;
>>     rw.len =3D len;
>>     kvm_vm_ioctl(kvm_state,
>>                  KVM_MEMORY_ENCRYPT_{READ,WRITE}_MEMORY,
>>                  &rw);
>>
>>     This new ioctl has more neutral and general name for its
>>     purpose, the debugging support of AMD SEV and INTEL TDX
>>     can be covered by a unify QEMU implementation on x86 with this
>>     ioctl. Although only INTEL TD guest is supported in this series,
>>     AMD SEV could be also supported with implementation of this
>>     ioctl in KVM, plus small modifications in QEMU to enable the
>>     unify part.
>
>A general comment, we have sev_ioctl() interface for SEV guests and
>probably this new vm level ioctl will not work for us.
>
>It probably makes more sense to do this TDX/SEV level abstraction
>using the Memory Region's ram_debug_ops, which can point these to
>TDX specific vm level ioctl and SEV specific ioctl at the lowest
>level of this interface.
>
Hi Ashish,

Yes, this new ioctl is now working as the low-level interface for=20
Memory Region's ram_debug_ops. SEV can use=20
kvm_setup_set_memory_region_debug_ops() to install a new
callback to KVM for installing SEV only low-level implementation,
then call kvm_set_memory_region_debug_ops() to do Memory
Region's ram_debug_ops installation later.


>Thanks,
>Ashish
