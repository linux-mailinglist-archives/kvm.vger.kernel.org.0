Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3635F6E93BE
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 14:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234519AbjDTMK3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Apr 2023 08:10:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231827AbjDTMK1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Apr 2023 08:10:27 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 926A149F5;
        Thu, 20 Apr 2023 05:10:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681992625; x=1713528625;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xGytorPBTixiGwDwkjqAp0Oib+OnUCkO56WW8u4EH9U=;
  b=XaSsCzLpiBlmL/+39Ph/AF/i0pKlMnKBgUIQG/5yEpKLvCbEr3YA5u+l
   NOpyT+LxnPKdY01Fo6g/UMrNoZZm24xTXt3K2CnE/1nevlyJtX9HbbKk6
   7LjxwZjZnq6RGy345D+K3flIlK2K1Mac0HvXd6ko7t+yn14JOkp8V6RdV
   vfs9UyTE+DN1ojs0cvQmlDNSO864U577JHMs5sAUrQALZe545hGmv46Y0
   27UHSODjNYi9RUENYUoPJ3xbA1kTvz0wtiTloa6yFxNKyUUafMEVXV0h7
   qqfAMMf+Y/8oSnK1B7IeqPH0v/xDE9fzis27+SLhASt+nDRo4x6AQ2RCd
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10685"; a="410952237"
X-IronPort-AV: E=Sophos;i="5.99,212,1677571200"; 
   d="scan'208";a="410952237"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Apr 2023 05:10:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10685"; a="761139894"
X-IronPort-AV: E=Sophos;i="5.99,212,1677571200"; 
   d="scan'208";a="761139894"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga004.fm.intel.com with ESMTP; 20 Apr 2023 05:10:24 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 20 Apr 2023 05:10:24 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 20 Apr 2023 05:10:24 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.46) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 20 Apr 2023 05:10:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cf8J5O8ZOiE43hq22pmLhzKZO4A09OBfBPHNhw+jaJE0iGfdoFjab8482eDxZUdjg8DEK+8BRDSqCA+jzOdjN++uuGMuY/t4L+Jkr8RZSwyZW5Gp8suxRZVg2vk1Fs39yKWVkSKc3zVtsPpnLLuoly8Go9RvEmpLFiaGxO80Vzi9iKWesl2qDDZ/EooeMhbsKsGzgQqaU6pxxpwlaiCrSkDozkoJy2XhkxLb7l+aXiD7+gmGKoXvfCg6ZBgungL8wJdpFkwkw5Zq6tGhDI03yfAYJVIehG5/e+5+a+WDzIA6g2l7BJBv9Ft5G+qYdt7sAJXZe0QhlGxl5I0+KTcd0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oerF/HECRu3NrlDFnaeWGKb+xE9zAMvEnyuKgdFOyjs=;
 b=YqhFbQQxQ4PjtHv+yqgtUWq3Isb4FiTZoCob3w9gFmt5cZyvKe4K0PpIkJ3ukq6678eyf7gTTJPjFy8W3k96IH2X+FfWQktYOj/zQkJQDMPNjXfAHg0G87XhFsWecdk2v5IQ/obxV/u4geIa3Icf03dFM5JecLqNhFWXaIoNBXJkJi2FR5TGGLn/Q+AkkmEbH9IjVDG2SEHDW2C1JCjNKhXtD5wAoWGZdsKNzaJDEygJ1rqnfRhuzj561DslEY+2FOxR4+9302XFO5VQ6IfdeRvlkCRUL6HsIdeBydORmdQhZ5nC02fh7tCLahmtJ5CX4oPaVH4LVsUiWW0mrRJz7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CH0PR11MB5563.namprd11.prod.outlook.com (2603:10b6:610:d6::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Thu, 20 Apr
 2023 12:10:22 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::5b44:8f52:dbeb:18e5%5]) with mapi id 15.20.6319.022; Thu, 20 Apr 2023
 12:10:21 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     "Tian, Kevin" <kevin.tian@intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
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
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>
Subject: RE: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Thread-Topic: [PATCH v3 12/12] vfio/pci: Report dev_id in
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO
Thread-Index: AQHZZKiCMJJkpNrujkKpjX0h05Zqwa8cqG8AgAAcMGCAACibgIAAAyuAgAAEPICAAAjLgIAAGeKAgAAG7oCAAAf9gIAAO30AgACaIeCAAJxQgIAHkI0AgAApuICAABWEgIAAGNKAgAA3aoCAACJEAIABGhiAgAA2uYCAAM6MAIAAOT6AgABpLgCAAPyoAIAAA7kQgACCLICAA9TGQIABATgAgAAIdQCAAAm2AIABGm0AgABffwCAArUGYA==
Date:   Thu, 20 Apr 2023 12:10:20 +0000
Message-ID: <DS0PR11MB7529C11E11F187D7BD88C18AC3639@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <BN9PR11MB5276782DA56670C8209470828C989@BN9PR11MB5276.namprd11.prod.outlook.com>
        <ZDfslVwqk6JtPpyD@nvidia.com>
        <20230413120712.3b9bf42d.alex.williamson@redhat.com>
        <BN9PR11MB5276A160CA699933B897C8C18C999@BN9PR11MB5276.namprd11.prod.outlook.com>
        <DS0PR11MB7529B7481AC97261E12AA116C3999@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230414111043.40c15dde.alex.williamson@redhat.com>
        <DS0PR11MB75290A78D6879EC2E31E21AEC39C9@DS0PR11MB7529.namprd11.prod.outlook.com>
        <20230417130140.1b68082e.alex.williamson@redhat.com>
        <ZD2erN3nKbnyqei9@nvidia.com>
        <20230417140642.650fc165.alex.williamson@redhat.com>
        <ZD6TvA+9oI0v4vC2@nvidia.com>
 <20230418123920.5d92f402.alex.williamson@redhat.com>
In-Reply-To: <20230418123920.5d92f402.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|CH0PR11MB5563:EE_
x-ms-office365-filtering-correlation-id: cfd5c3cd-9b5b-42d1-88b6-08db41983691
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: d61Uu8A1w9vZd7rc6mWfx4NrsR/sCfpMs2cW8jQ4QYleyjG5zQShGwa9KsWUkJHGWhfM6t00aHbGdRnzFu3GTImZ2hIW2u96gFpqCOKWQxIjd9ovYUp8GoDgxC1N72zdhFtSU0eJnedP/uxa6uyknTvpQ1+eEzXVi+MpS0rx17pbwr+AuLDBVVAB7SuEUciNQaYRBdR6RXtruNoNxN07CnmPdbC8lqv1ir/iFxvmg19DLjvdngJrcpnmSMkvkkmxD3kemcGfttLdlxQauOJd5oX1RgY/8bYcL//qf0u/dUj43w9xM25kSJgv4DuAZPYpfjWxhqLyfd+L+iPmfC+LZZUDMtvY9KVwVwqHl+xRkB8u3+olCYUYBYMI+5eRLiT2ZEWD+nAyd55P0M73b9mseMOP2oLTOgPgk94Z0BKd1odPuXG6iYi7ta4lP9kS8vhKPBPAq36foxo98iHjLiNrHhu6PNih6Frj2tsVKwrWzVpqApca5uFkOV9Zn5W93JFxbD8uqPy1kTahGqbi8sdvSLgPcEXBestueE5+/6gS166U7wJyHlXXSCz5yWdqC+WbhnIVwtM67KHKkZS0VUnpkMeJ7Dfuh/S0SZLmzHiMO8IcMXFEta5CeN4OucPCggJSPQtJQashvDe9auBgTElZLw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(366004)(396003)(39860400002)(136003)(346002)(451199021)(54906003)(110136005)(4326008)(64756008)(316002)(66476007)(76116006)(66946007)(66556008)(66446008)(478600001)(7696005)(71200400001)(55016003)(8936002)(5660300002)(41300700001)(8676002)(52536014)(7416002)(122000001)(2906002)(82960400001)(86362001)(38070700005)(33656002)(38100700002)(9686003)(26005)(6506007)(186003)(83380400001)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?gFaqxKW+53k5KOlw9mlwyl38yEtP+voqAmetkDD6lC/GR4DBTUvF6/s/6Dsa?=
 =?us-ascii?Q?v6XXykieTEs9RJtwGeTlMvOtSI9ggpqRWJaciWSX1QO1Rhs1ZCDuc9qT2SO0?=
 =?us-ascii?Q?5vtoJUlt2GJk8sNjsGSro8JyQ1lG1LLjSY71+UtE5SK++emhvrs8qWSQnafc?=
 =?us-ascii?Q?OYW4lq7cLjdmWzG43KFunb2OQVxbmn4onxX1WK0+m9TjfJThbGzA/xrzwPiE?=
 =?us-ascii?Q?3xD6hcWF3ww/fTDOL8ogH5Z47K/G7k6XAzzg4wZyb2XV2LquMGyLJvL4Wllr?=
 =?us-ascii?Q?JW8USpA8urKpLRPqeE2RT1oyw82TeWQA8zWkUOlVIxKXPfos4Qaj4Xtn9Xyv?=
 =?us-ascii?Q?y0VgVXjWk7iRODTQwRIjgUFiL/rlun3vaxWd6ZEKW1xwA/Ysg+yj3j/I6a0s?=
 =?us-ascii?Q?w2dRzGzl/wGtJ+yjn/nw0GakHEWeFvpo/64CKaGKfHuiuPJX6LqBhgiLeTlB?=
 =?us-ascii?Q?ym5pjOLNyTIZaMiQLG6oqxGxbrI1xWIskFIGJAS2933xjdPGswbU7vOx8cDs?=
 =?us-ascii?Q?1/PL4DxD1QchJQpOUK8oB8SldjsUFGuW599RR/BoRcz605mkSj+Q+8EXP1tX?=
 =?us-ascii?Q?y8a4SzqUe95PI8E1S0U+t+n8YcVnKfxNhAUoySM0dIcAszFiUcfwsjJ6WiKf?=
 =?us-ascii?Q?M+47vzug9yb/KXXhbv2YOKuJ6R8H2iZkbIS8reMd/L/jApPjGcAMvzC/H5py?=
 =?us-ascii?Q?DdXNjgCO++AYTZSB8Nfm+WtQC25Fw0v5NtvSGoFZlUkKC/I2KXKkiDTNhfwN?=
 =?us-ascii?Q?VxFnjhe+KYGBuW171VaF+G8QXPBc4IwtrCwJwVPHyqw/g1haE8Kd9swXsUYu?=
 =?us-ascii?Q?Dqe2qm0tBCnL63ZolgrM8bBy4ohyXO2kTLSKnQJgCrTnHR2AApDjectwvQRd?=
 =?us-ascii?Q?GNeUC3yBT7DcsctRirjNuHtLtxs+JWd/e8zRVSJBXeWj/nVNCgsJB46A+Pgy?=
 =?us-ascii?Q?JnLFr6MyPkCUJ309oNEGeLAZs9c6lo/8r5r6jCvuWR44ySj4wwPFx6Igv6YC?=
 =?us-ascii?Q?dDsgeBqoWOHIus7dj1TRm+85t+huaNpdGuHp8oXaW5q9SejBAo1DZ2hlfdao?=
 =?us-ascii?Q?CpYqKvSn4hej01ZNuY5FFd0OwKvbYbIjzTM+kg1G+JvCk1z9SJ5Qre0hzo2W?=
 =?us-ascii?Q?w1ZcrW5xWh7drYE1Y2HbRhUyy2ZCP+3SkG0Lu4v5lOQeCUvbpTaFIVSf5HuZ?=
 =?us-ascii?Q?eOo9kFEzGAKzFtcJW81csxLuuB77v8Z/xGIBU8Gwl5ks88m3tMkdQSP6YDzH?=
 =?us-ascii?Q?xf+pbc+unhwZJ/Xc72N3GVrZUG0wLxTD3uXdNdB4336N1ZhZUH4n8xF1o/v8?=
 =?us-ascii?Q?FD322+G/0GB16xflFJydybzkSGZSpZq88nqe4Md5GMydvTJXHvJZCHY44FgS?=
 =?us-ascii?Q?RcgK3rVxTZsunmjgv3t70pkPk5k5X0oWtQMIXkcK1+YpSE5V1+tdbqqfYjmi?=
 =?us-ascii?Q?TDxxPW81E9KeJ3IBlKUgzRbJK8kzlAjmCB9R+CW7Y1t1RVhZ4F//j9dosoeG?=
 =?us-ascii?Q?7MfqVOaKXNc8K65s8UI7ZvKg1Z5AgcEPAR8oH4jg+N4Q740A/Hz4oZ7Zrx11?=
 =?us-ascii?Q?xDaGTObMKIvGFMN1QKs=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cfd5c3cd-9b5b-42d1-88b6-08db41983691
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2023 12:10:20.9199
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pO8O46H/2W2bo2xZPD7fxA/Vh4guvatOKIEJYZqQGRCRNC4Z/+wvlnTscDWE3H8bY8nfEwM/xoKGRXWYQPk8cA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5563
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Wednesday, April 19, 2023 2:39 AM
>=20
> On Tue, 18 Apr 2023 09:57:32 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
>=20
> > On Mon, Apr 17, 2023 at 02:06:42PM -0600, Alex Williamson wrote:
> > > On Mon, 17 Apr 2023 16:31:56 -0300
> > > Jason Gunthorpe <jgg@nvidia.com> wrote:
> > >
> > > > On Mon, Apr 17, 2023 at 01:01:40PM -0600, Alex Williamson wrote:
> > > > > Yes, it's not trivial, but Jason is now proposing that we conside=
r
> > > > > mixing groups, cdevs, and multiple iommufd_ctxs as invalid.  I th=
ink
> > > > > this means that regardless of which device calls INFO, there's on=
ly one
> > > > > answer (assuming same set of devices opened, all cdev, all within=
 same
> > > > > iommufd_ctx).  Based on what I explained about my understanding o=
f INFO2
> > > > > and Jason agreed to, I think the output would be:
> > > > >
> > > > > flags: NOT_RESETABLE | DEV_ID
> > > > > {
> > > > >   { valid devA-id,  devA-BDF },
> > > > >   { valid devC-id,  devC-BDF },
> > > > >   { valid devD-id,  devD-BDF },
> > > > >   { invalid dev-id, devE-BDF },
> > > > > }
> > > > >
> > > > > Here devB gets dropped because the kernel understands that devB i=
s
> > > > > unopened, affected, and owned.  It's therefore not a blocker for
> > > > > hot-reset.
> > > >
> > > > I don't think we want to drop anything because it makes the API
> > > > ill suited for the debugging purpose.
> > > >
> > > > devb should be returned with an invalid dev_id if I understand your
> > > > example. Maybe it should return with -1 as the dev_id instead of 0,=
 to
> > > > make the debugging a bit better.
> > > >
> > > > Userspace should look at only NOT_RESETTABLE to determine if it
> > > > proceeds or not, and it should use the valid dev_id list to iterate
> > > > over the devices it has open to do the config stuff.
> > >
> > > If an affected device is owned, not opened, and not interfering with
> > > the reset, what is it adding to the API to report it for debugging
> > > purposes?
> >
> > It lets it print the entire group of devices, this is the only way
> > something can learn the actual list of all BDFs affected.
>=20
> If we do so, userspace must be able to differentiate which devices are
> blocking, which necessitates at least a bi-modal invalid dev-id.
>=20
> > dev_id can just return 0, we don't need a complex bitmap. Userspace
> > looks at the flag, if !NOT_RESETABLE then it ignores dev_id=3D0.
>=20
> I'm having trouble with a succinct definition of dev-id =3D=3D 0, is it "=
A
> device affected by the hot-reset reset, which does not directly
> contribute to the availability of the hot-reset, ex. an unopened device
> within the same IOMMU group as an opened device (ie. this is not the
> device responsible if hot-reset is unavailable).=20

Hide this device in the list looks fine to me. But the calling user should
not do any new device open before finishing hot-reset. Otherwise, user may
miss a device that needs to do pre/post reset. I think this requirement is
acceptable. Is it?=20

> Whereas dev-id < 0
> (=3D=3D -1) is an affected device which prevents hot-reset, ex. an un-own=
ed
> device, device configured within a different iommufd_ctx, or device
> opened outside of the vfio cdev API."  Is that about right?  Thanks,

Do you mean to have separate err-code for the three possibilities? As
the devid is generated by iommufd and it is u32. I'm not sure if we can
have such err-code definition without reserving some ids in iommufd.=20

Regards,
Yi Liu
