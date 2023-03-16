Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D25D6BDCE2
	for <lists+kvm@lfdr.de>; Fri, 17 Mar 2023 00:29:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbjCPX3a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 19:29:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjCPX31 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 19:29:27 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8A5D193CD;
        Thu, 16 Mar 2023 16:29:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679009366; x=1710545366;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=cPs0qRYaQPGPBhtFVqGeFCFo+261M80kDwKgGlDsLCE=;
  b=Cvwp3EDGKlT7XWEcg74b3CF2Bs0eOFcu7ABSyUErn0sTqziMKBi2FnNg
   rgRjXRqtpnY8mGHvYvO+YIky5GCtfs04454ALrpceljlgmJvqELIBeUba
   B9L+c5dwR80JW8DK99+M0piNkgF/WCq/DXsm0PFIGwD8Rlg+xSHITZCq+
   YUigAYqcmAgGqfp55zkehNcjTBRDNGVr1oAbDgojm14Bn+cqK7oGY3iuA
   6bv+Uk5OFOx6Ug7HgsaJ08RWuZw/7VNbV9oBOHPncmXNAD1TvcIPU2mb+
   JRgh2L4GZlaxjmCwjsJ93Goeqp79qqKsuwipKtJOR9A9gqdHgOaguwnWo
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="403014679"
X-IronPort-AV: E=Sophos;i="5.98,267,1673942400"; 
   d="scan'208";a="403014679"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 16:29:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="803918919"
X-IronPort-AV: E=Sophos;i="5.98,267,1673942400"; 
   d="scan'208";a="803918919"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga004.jf.intel.com with ESMTP; 16 Mar 2023 16:29:24 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 16 Mar 2023 16:29:24 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 16 Mar 2023 16:29:24 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.40) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 16 Mar 2023 16:29:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GNwnTQfbRpFne9IVwpm8M2V1A1zRAgMMMraxZmpR4sJGuRRD5qbABoQY9VhJ2AlX4zst2ub5bc6+xwj12ErcKR0tPrPJUOEIuBINjd6hflHPMxM+KAwiCdhcZpHUya91NPHojiEy7ysGg1Rna7p0jw+TwVNFGIHb1ZXEnOzA156vLy3ETlCEXNQzhN3kMkQ9HkKHkkwG9KiJBj0A0QfpxTXnErOcZnTJbmWI7m4VvzLo8KSkLUC/Ws58Jhm/VtwHkrfpT444L1nl/ry3W8ZaQMb01ovgbCTya8RWKn4I12AKIKD1pSY2ooeLfpry+yyMVz2/UCqE0/AMW5YZMKBNxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m731wupfgabJko/SRteEwFEWvzZbS0ThhD3AdqMHU3k=;
 b=Z/QYSbJ8wVM6GFkgGglRBNI7mkmc/dUKXr8MbgK36w37GsS3wWY4zNY8783vHP6nW2+Ueb8r3BjxZZZvWmowrrKTc5Oov7W3cqe9xZKCQKEy0l3bVaWHvca/xAH2hzquoCUfn/RcHq3ie/I3x0f+wyTAxLCqan9tw4lvHaetuZCC6Pr2dPa0Y8W6bFxsjDLu8tt5L7i2lDKiySJOm8nOnzgiYkmsQ7Q91nhUr8/64RE7NSZO3O3fngf7x0XZL60haW17BnrJbzHxrBhW6LYGPGh4EGtiJOzAO9ZzpVMNGZCZT4lZnphPdd0XoCwyZ9fD0vgTj0G5fErrQEcziop+vA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA1PR11MB7245.namprd11.prod.outlook.com (2603:10b6:208:42f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Thu, 16 Mar
 2023 23:29:21 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac%8]) with mapi id 15.20.6178.035; Thu, 16 Mar 2023
 23:29:21 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>
Subject: RE: [PATCH v6 12/24] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Topic: [PATCH v6 12/24] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Index: AQHZUcIISo3Z1SbL8EmJASujVt/DZK78flGAgAAE67CAAUg5AIAATEkg
Date:   Thu, 16 Mar 2023 23:29:21 +0000
Message-ID: <BN9PR11MB5276F7879E428080D2B214D98CBC9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230308132903.465159-1-yi.l.liu@intel.com>
 <20230308132903.465159-13-yi.l.liu@intel.com>
 <20230315165311.01f32bfe.alex.williamson@redhat.com>
 <BN9PR11MB5276300FCAAF8BF7B4E03BA48CBF9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230316124532.30839a94.alex.williamson@redhat.com>
In-Reply-To: <20230316124532.30839a94.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA1PR11MB7245:EE_
x-ms-office365-filtering-correlation-id: d02c3246-7894-47e4-e625-08db26764542
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VOmlZPrh1XArT6975oS1mgyXMzXB2Q2M/JHQoYkysE0g7piRwacf3up5/cIEtlDancsSxtG8h6mbaVWztfcFfaUjQBF4fp1FpsGYVkoAo63ZEtJrfqKvZBi0PhEzYKDKzIVoZphj8CkAsfOc/+6sEZ9rMmt597eAvnT74uPg99EibW5N11jko6FZzIBkRiCc4EJE1QkeOYpGlDaFujh5Vnzoz2Uwd3GOOkwYRzlnv2ZlVOH2+KWnSQqXqXv9RwBcsHR5rvVxy6sDlhdOsI9/cDH0W7/RtIzuh5eY809JIBM9SA5YugRKphP/ek4hgS22zqI5URgdPm9+yt/V/eS86Nw+j8ozwZ6IJNErJYW9OuZmAL1Xk9vKfBNjvFNAZfrllNKsdaT4+v5ZqBxmVeMSNllKj7cDgIHhJx8+7S0YyYPzVf8eNxQwFvR2Lps51IYFsv7yXzrb/4CpSKLnwMqWEv+ivrFG/0W2AFroMluGfKb3BdtFY9JlrxTu44MfBwRz8eh0frh4gq2B4WUjFbnlIQUvD+2x8toTuobWz5NZ20XULc9exafnE180MGJIBc/2HGvn0BtlVov9rWTLda7tximYgKF0c0bzhMxb3wMLzwDgSJG2LaAwVJTKq1H8KlOVHq6IIUWuiB7vD4dKgL3sJBkVICihj4Bgb7u3+e9Y0ApCpl+nK9zXzyDkkTILrWd+ftioxWXx6OAnoKhGVrfhLw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(136003)(376002)(396003)(366004)(346002)(451199018)(5660300002)(8936002)(7416002)(66556008)(6916009)(41300700001)(83380400001)(66446008)(9686003)(71200400001)(7696005)(478600001)(6506007)(26005)(54906003)(52536014)(38070700005)(66476007)(8676002)(33656002)(76116006)(4326008)(64756008)(66946007)(55016003)(86362001)(316002)(38100700002)(186003)(122000001)(2906002)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?VZ4ECAHjcRowOgsWaV5b46emgVljGg2p6orS+Voj4DNFi58dTpcET2AO4Qw9?=
 =?us-ascii?Q?Y/Yz8RNJL4Gwoo7o7Cpwgk4rcU9/8ugFg3hDgMRIKCne0Tm4tSW0Gh0nH4oA?=
 =?us-ascii?Q?9q/DlawrN7GwRsFikb7MwajZmicR8TbQ3lRRC38VZcS0th9oqQ9YLzY7iKmH?=
 =?us-ascii?Q?HYQrZieQ1kNK2diMObJmPPRWyglHaOm0aIoOpVUiY0GKMnDFh2BaJIpR9Vgi?=
 =?us-ascii?Q?WcU7THXW/0l4sYL10d0kwcgkm9mXjCcDkrKlnKuvdbD2Q+qL7BeM65IX+i++?=
 =?us-ascii?Q?dpMHcZalkQxy2urqyBEHpMaITXzDaLuVXkKtACZZ57dhOnG+QYqD5JGmE6y9?=
 =?us-ascii?Q?cwvAP654J7Sdr+gkysU7ZMKtAulMmyE78Q+j209QV8jDorTqqPp3kLfDpR/n?=
 =?us-ascii?Q?CyqaLSomzmSEtWKemUQwOICGIA2XAEjy3Yfp1joA/0fc/mm9v05Cr0HBUph7?=
 =?us-ascii?Q?9dM++6N3VQb1If74P2X21qmhyonj3g4CVHcYGdaX1hLQSrxNmS7GjX49nMpD?=
 =?us-ascii?Q?MPMNlYZF1ESa0/yZx3U7Z0m/Tpl4YLjhGZwPmrNJWgsvyR1I+j94LQbg474T?=
 =?us-ascii?Q?tV2i86YJzoR35/CgIjT4EauHRKDlbPRBH+nHM/36DeRJcOoFgx9oulUOSVsO?=
 =?us-ascii?Q?XDpW+6EoRx4uhgdIJF8KTvSd2lBxeU/tgZgc56H/XVedBI9Re9/Kwv+DlAaH?=
 =?us-ascii?Q?saOYFSVnbS3unTLvq3toPzxekUmlt2Md+iTHe7y3E+le96i7eF5ZE10EvNAW?=
 =?us-ascii?Q?hUCw4Rk4EcHE7ox4UUR/4JXNfMslsxGioNJx6bpn+N8tx0wQ6OpDBY7MHloE?=
 =?us-ascii?Q?mLiITzNCPTHVChntRV6NB7ae/1iZHMpSiJUvRw5UHpp697EoIM2rgbHiQa2w?=
 =?us-ascii?Q?DEtFlDhHmck5Axj2H7nGZOy4P1v5X+5jY/mfUcJ7vyz/JsOmA2/eJ/4fB68W?=
 =?us-ascii?Q?ZIbG1aANgTf8DI8ZViMUaWmkCJMLZCn8AihzegjOgoSqxxL6fxAz7Za8Jyt+?=
 =?us-ascii?Q?7kidRNQSYLmVXB0FTMc0Zxudcism1OlDq9LXfq/hQUy8w33VVhwlSjry2iKd?=
 =?us-ascii?Q?+SngOiBx0jnkJpGMXd5Xl36LYT4TDFgWBNsHyU9oehN2jmck81ZYySmGaeZ7?=
 =?us-ascii?Q?xt5NkTchF7/doFOlxi/gZ/AoIQtSdmPo3XCFEVX6+4FK1C3anzyQbKLbuYnf?=
 =?us-ascii?Q?SVDJknT8SIjbp/skKG7PCilYsy1PgvyAzh8UgqQQ+rrENKhZToIgYfyuqq2/?=
 =?us-ascii?Q?FUpecQ8zLElbGc8pxJX2u3In/cy3ryWhaMz1WgKscNsVYEVd/5tgJ7/bJTVq?=
 =?us-ascii?Q?Szbgq31dHYGF/IAD1cHs4BADm8vr3HLcC+I60cdvTprrh50Jv7oW4xPTZ98A?=
 =?us-ascii?Q?F+KfY5L3++zt673h1SEdhYZQQOPBsGiHSJ2/8ZqI6U/bqdctYmx5VPI+QCqo?=
 =?us-ascii?Q?79Fa4qXXdkmK5HduYC8oqH5q9UOyvcwqao5096V2li23wIg+jNVA+D9YavJp?=
 =?us-ascii?Q?zHkEPZzzoER+EWuARL9cxr3Chfghrst9eMJMWde8rJNkNk9SCo/Eoa8ttAI1?=
 =?us-ascii?Q?dsdXa/opincMCP+9q45EVYMbudGlmicoX3JHWdek?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d02c3246-7894-47e4-e625-08db26764542
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2023 23:29:21.2597
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5YI+rEM4mvHOmhvSDMRk+8vtEkdQ2C1b0M9v6xAnSULkO5q35T534dvmwZ8obsbpkZkTtLJG6iIkW164Zwyn9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7245
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson
> Sent: Friday, March 17, 2023 2:46 AM
>=20
> On Wed, 15 Mar 2023 23:31:23 +0000
> "Tian, Kevin" <kevin.tian@intel.com> wrote:
>=20
> > > From: Alex Williamson <alex.williamson@redhat.com>
> > > Sent: Thursday, March 16, 2023 6:53 AM
> > > I'm afraid this proposal reduces or eliminates the handshake we have
> > > with userspace between VFIO_DEVICE_GET_PCI_HOT_RESET_INFO and
> > > VFIO_DEVICE_PCI_HOT_RESET, which could promote userspace to ignore
> the
> > > _INFO ioctl altogether, resulting in drivers that don't understand th=
e
> > > scope of the reset.  Is it worth it?  What do we really gain?
> >
> > Jason raised the concern whether GET_PCI_HOT_RESET_INFO is actually
> > useful today.
> >
> > It's an interface on opened device. So the tiny difference is whether t=
he
> > user knows the device is resettable when calling GET_INFO or later when
> > actually calling PCI_HOT_RESET.
>=20
> No, GET_PCI_HOT_RESET_INFO conveys not only whether a PCI_HOT_RESET
> can
> be performed, but equally important the scope of the reset, ie. which
> devices are affected by the reset.  If we de-emphasize the INFO
> portion, then this easily gets confused as just a variant of
> VFIO_DEVICE_RESET, which is explicitly a device-level cscope reset.  In
> fact, I'd say the interface is not only trying to validate that the
> user has sufficient privileges for the reset, but that they explicitly
> acknowledge the scope of the reset.
>=20

IMHO the usefulness of scope is if it's discoverable by the management
stack which then can try to assign devices with affected reset to a same
user.

but this info is only available after the device is opened. Then the mgmt.
stack just assigns devices w/o awareness of reset scope and nothing
can be changed by the user no matter it knows the scope or not.

from this angle I don't see a value of probe-and-reset vs. direct reset
when reset itself also takes the scope into consideration. Probably the
slight difference is that with probe a more informative error message
can be printed out?
