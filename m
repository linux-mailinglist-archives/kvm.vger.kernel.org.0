Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7829F6A5989
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 13:56:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231260AbjB1M4W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 07:56:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjB1M4V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 07:56:21 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C1002D160;
        Tue, 28 Feb 2023 04:56:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677588980; x=1709124980;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0l7zdTVUe2YpaUuP3/ltdOyELyXSXJYHdlvuaxZrUUg=;
  b=SKp8bbJn0nskgWUBg7s5GmOTjWLTz4d+4H/6/fnv8B0fFJMKHT5y021J
   cdVwQCJIXIN04PgOVj3CeGYn15Y7J6+lNii/vYdgzg82zynvsqJQrRhaT
   Wza4RmTEy5GFICEwm644vkKBPtOEX34aYJ/YyUdX0OYHRQX8J68bGm8W2
   HFbQTaLWwCoX7Og/mKlYym9r77WOB+WyMv1AZmxzBfz0JXpzVv0hF9a4h
   cIA0B7lYlEYen2EZ365EGEJ/PujyckPyAztR7djcCg3xyznmxI5HCFKNe
   Y+YXu1mZqS9D/gUvdlnUti51aGpF3DTNGB1qP8Jy6+/1b6T6TBGdvQNWM
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="420388810"
X-IronPort-AV: E=Sophos;i="5.98,221,1673942400"; 
   d="scan'208";a="420388810"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2023 04:56:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="783832894"
X-IronPort-AV: E=Sophos;i="5.98,221,1673942400"; 
   d="scan'208";a="783832894"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga002.fm.intel.com with ESMTP; 28 Feb 2023 04:56:19 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 28 Feb 2023 04:56:19 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 28 Feb 2023 04:56:19 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 28 Feb 2023 04:56:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mSY4n7ap2QjfQgwXLszChXx/Eajn9bhLaPGoPPwpx50ccboeQDYDZnWvMZhneJah+uVAwDhkW1jcZTCJy7GifslLmJLkoQ8p3TI+iGgJV7U7Rk9DOqSppjni1ME5Xh0PIQWbkLURMVdsT8hy7LbjKSivjp17OKJ8xT5plTdzRutEMLXDTpVDNOh3U5Z9cyAi9X1eUZUPPLnQF8bP65w0lvgsiJm/Mv0pPyv77hN22lzbgDd0XEze3LitOIQrhfPjC58UaBXKcX2ntt955hd6dArKk7ca1Ra/XnRmQOOt5QvZNj+0BI/SEYGq6VAWD7PDHyHbRGu5K3eMsySk4PGQ6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0l7zdTVUe2YpaUuP3/ltdOyELyXSXJYHdlvuaxZrUUg=;
 b=KXJt2EmGNPX8+ket70vN8DFo4YI78EzlPJZm0flfeFJOdZ79NhgKaGblPG9crnY4PsWk9jql7XekygYqhpTCpNwwCiOhwsz4OKFPCOuYNSiUBZA6uG5HvTALeN28Rkd6Cy17XF6OY+N0R4kDLv1wCM1PQ6pC8f3SGmbZKhmQkRinIdW9sr+6hoVQK51n1Y3djxMtWEyK5UfGVZzopqtxSu11dbviajR8AfZI36TF2lxLfwbiaRCR/nw7zpgWphy5bbP38GovSmnhm6R9JVLTb0BYX41ief9lQDKZN84losIbxDTE0L7PefN1LSIWCg/0J9MW/UDc07cuSsJKOjS/sQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DM4PR11MB6552.namprd11.prod.outlook.com (2603:10b6:8:8f::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6134.29; Tue, 28 Feb 2023 12:56:12 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%8]) with mapi id 15.20.6134.030; Tue, 28 Feb 2023
 12:56:12 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: RE: [PATCH v5 10/19] vfio: Add infrastructure for bind_iommufd from
 userspace
Thread-Topic: [PATCH v5 10/19] vfio: Add infrastructure for bind_iommufd from
 userspace
Thread-Index: AQHZSpxK4wL3BAz2vkuMw78Q2DEYMa7jHbWAgACHOBCAAERLMIAAYp0AgAADn8CAAAJDgIAAAHaA
Date:   Tue, 28 Feb 2023 12:56:11 +0000
Message-ID: <DS0PR11MB75292608BBF3686A5FBE9D1FC3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230227111135.61728-1-yi.l.liu@intel.com>
 <20230227111135.61728-11-yi.l.liu@intel.com> <Y/z2mY97uPsCs6Ix@nvidia.com>
 <DS0PR11MB75292E7DCC6FFEBF5B5DF66AC3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <DS0PR11MB75298144318DBA9690DC756FC3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y/30CgUSbkpFN20b@nvidia.com>
 <DS0PR11MB75293900EA1FAD0EFD13EA2AC3AC9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y/34+Vr4Mblf1G4i@nvidia.com>
In-Reply-To: <Y/34+Vr4Mblf1G4i@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|DM4PR11MB6552:EE_
x-ms-office365-filtering-correlation-id: 5da925a3-0c95-4710-a7d5-08db198b2b2a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: d+axtbPD85StLjFF5DoXAqxOSO/QtXfDwofjN3EBCW+Nrr6qJYcZmMB4F1HfcCFD0f/yaeqkvWLuMYBY5B6OwlqWV3PWVuBSZIk0n0qcPy40slNNbKM10+C8G7bvhosennamYkuTrO3WpRnjXV5oLMhMtf0gsFWT5/knkMTfFAiOl+N52Lc5uDzhWRvfUZh7OLh1AnZRqH8Sh3Y+hu/uSE1T5wbkc+Syfwhdcvk4qhKfNW9pUn79ju/PMvAIYqUPpyeeA5Aqt85w0Dz019/fYgukzGStRb+5nco7WoEkyMlvNj4QgcOnchNbcPmduuUJhA2rJt9xOz9Vrx3VlaTCTNvNELfA1ao3qpS990oVWzb+8hIjKJ3Cou+0GhLxG/rnWXdtdGZ2WOp3uXTjAVM7xRqX7OUS4KllwywtLpGzuxGfmX63X4zew5WH8e/MZd8lzvLjHo5R6ni9UodE3VVNaonMd6CGAJgoDGmKHOqWSS0QWlR/G17eByAxN2Ye2+pf1+4JmGRFRgOzgRkPfbGP+oCdIUbomhk4WcGarISyeotpDwBNkAdV3DAN+8TAFSYD3iankDFqvUNznJHfNveL2PEv4DUS7xCuuf8mQmSY1bkHWlClHPLXraLEV9k+f5tAmjAdgT49YgSgZsyASrjeq7+ldlZr4dqFmHsPkI0/rHpY/R/55wRJRpLMCLH95FkzHRFTdsg+hTottsHN8b8vVQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(136003)(396003)(39860400002)(366004)(346002)(451199018)(9686003)(186003)(38100700002)(82960400001)(122000001)(38070700005)(52536014)(8936002)(4326008)(66446008)(66476007)(2906002)(66946007)(5660300002)(7416002)(76116006)(41300700001)(55016003)(66556008)(7696005)(71200400001)(6506007)(6916009)(478600001)(64756008)(26005)(316002)(33656002)(54906003)(8676002)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9cL62S2RKEbHRD3pNUOSPmdYBfeVSZzPf1FgCq/St1Ip3i3mdc1iEItxgArn?=
 =?us-ascii?Q?ObcJa+a8NDgcm+UiDE3lEf1ko8ZRfkBrnwLOAs6xH5yvDdcB26iMKvPmKi7N?=
 =?us-ascii?Q?RiuQL5aqrgJoGfhi/3SV1AF1sY6bZCAPzE/1zgpl6/N8s9hKRT5kZ8gu7k+W?=
 =?us-ascii?Q?3NHah272nupcQ6Sahx/7oMGEgBFRST9hyVnaMebB82hAZCDyp7t5DZXmpYzX?=
 =?us-ascii?Q?ML8OaFbSZVhbU6Bl3kyiVRDrX1qQoaqAgh/en4MIxqjDsTlHRB9nYiYCUzkj?=
 =?us-ascii?Q?yRSt04oKJg+pwhdxdPuIrX+LvVpVaQvIooktRFxsqoVILiKBjhgkiXkgYcfW?=
 =?us-ascii?Q?XjJ7t25h2DHz0NHhkUHssixjrVQGs6f/3ehLTStYf+RfHqQTZzOao/iqQzsG?=
 =?us-ascii?Q?N+vITMag7Uzca+vDZnq7nXWERyfvVDuyb00TadrQ6/9N9RouNbBwwoncIY8r?=
 =?us-ascii?Q?P0n1ezYt6FxPjWnD3i4y2LXGHJbqL1Pv7Jrbxd+AGcjYMopa8nWp2lkAKrPR?=
 =?us-ascii?Q?ozb4ZXzRMYHhQFc8gqAPTQF+/h3k7kk7oUWtFG75wBwnIX+a74WN24HtnRYG?=
 =?us-ascii?Q?BbtckzUtdagTjZzYlGKXohpQ6Xp+Y77u+kpeMSWWlGf2TlmbTR/Q8PH3xN3M?=
 =?us-ascii?Q?zaoj2yOoUeGp76HrPopb0zciGgmz3m8VE6TvH/0vEfSNeEQyIO/quepSvgId?=
 =?us-ascii?Q?oNaTgjpOCDKs34puePjpDwWER58xQC26GAFqRELPAr0Xkow/PKt3vkNobjFh?=
 =?us-ascii?Q?c5q6AoeoaS7HqY/uxnHop6zMn9k3/ePRN9w5SLMjlr6OuOrrnOdoul5CClfx?=
 =?us-ascii?Q?egvq6IviIFWsAev9tRXMdQjAPLh2Qv1VcmCrOKGZeeHtqZJsuJ1BH1FcwwpD?=
 =?us-ascii?Q?OsHg6gVFXyDaGiwdEiN2J4uyWQAP9MkC2TnyUOFMManUCbqXHhiw8E89XeHm?=
 =?us-ascii?Q?VX3bhWRShVL71EHRjAVjacFsC9CCNpxcR5OXWQCm6dmcSgzmbyKHcmY7ndWd?=
 =?us-ascii?Q?3tVD9QfJOi79J9rTwrVw0XGVjytdllcuXmnsHsAdepaQfXyp1uL4HP+2Zsu8?=
 =?us-ascii?Q?yUB3WPzB8ncTQvWX/7BGGKjVFq5w7X/STms+o+X6j9N994XZeMKjZsiR5mhB?=
 =?us-ascii?Q?e1YhBcyjVG4KHDXI7GRmg2QAHcjh5QhjEMfvqeU01qvdKxQuZLJGfOLugnGu?=
 =?us-ascii?Q?/1Ej/YA1xTPMxWg3ZDL6V4XpP2f6/Yv4GzTjbsRcy+aJ/a3stn36UXeCxpuq?=
 =?us-ascii?Q?mliNAExbbZPTw83XFqzvMmZt/tlQUoTQ14FRVhWvOolLDVvDn13Hpe3b01qF?=
 =?us-ascii?Q?9436EmiDNSIop28/nDyvylffcNnrUpAgIvmsrp4kbru+29FId04seBwuImOe?=
 =?us-ascii?Q?CUpKuT8zy50WUGHeUxABmTHtYrc2u6ugwxibWM5/1ArjOEgSfZGlCkixqZGO?=
 =?us-ascii?Q?fRoFSbI6P1ZONLVKrps4T9DI820jVeyzCRzqYdMUsEGbq4fG8iBRf/dXD7eN?=
 =?us-ascii?Q?cwHr1kKCqqHP9bbPd0PEcQifezy0N8xT0oSvcweiz9nA3acBAq/y8ge6HpQH?=
 =?us-ascii?Q?oRj2epOSKGp1dVg5g7TEI9bT+6N36gkj+Dq6EC/o?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5da925a3-0c95-4710-a7d5-08db198b2b2a
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2023 12:56:11.8109
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FVDZlIP2QwuTJWJstLgVGmzjyBhB39RRCXKuCjK/0YANrHnfhl1XvBeQjmdLTghLCgEZqlLxQJxDJtakiqDV6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6552
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, February 28, 2023 8:52 PM
>=20
> On Tue, Feb 28, 2023 at 12:45:47PM +0000, Liu, Yi L wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Tuesday, February 28, 2023 8:31 PM
> > >
> > > On Tue, Feb 28, 2023 at 06:58:38AM +0000, Liu, Yi L wrote:
> > >
> > > > Seems like pt_id is no more needed in the vfio_iommufd_bind()
> > > > since it can get compat_ioas_id in the function itself. Cdev path
> > > > never passes a pt_id to vfio_iommufd_bind() as its attach is done
> > > > by separate ATTACH ioctl. Can we use the dev_id pointer to indicate
> > > > if it needs to get the compat ioas and attach it?
> > >
> > > In this case you need to split the group code to also use the two ste=
p
> > > attach and then the attach will take in the null pt_id.
> >
> > This seems to be the current way in this patch. Right? Group code passe=
s
> > a pt_id pointer to vfio_iommufd_bind(). While the cdev path just passes
> > in a null pt_id pointer. Its attach is done later when user gives pt_id=
.
>=20
> I mean actually explicitly call attach and remove the implicit attach
> during bind flow entirely.

Okay, so I can wrap the iommufd_vfio_compat_ioas_id() and ops->attach_ioas
in a helper for group code to do attach after bind_iommufd. This can avoid =
to
moving the iommufd_vfio_compat_ioas_id() out of iommufd.c as your original
remark.

Is this ok?

Regards,
Yi Liu
