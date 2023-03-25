Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA3196C8E42
	for <lists+kvm@lfdr.de>; Sat, 25 Mar 2023 13:37:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbjCYMhR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 25 Mar 2023 08:37:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbjCYMhP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 25 Mar 2023 08:37:15 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B718714483
        for <kvm@vger.kernel.org>; Sat, 25 Mar 2023 05:37:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679747826; x=1711283826;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=izxs0leIOPsWCDRmyW4MTlQefiGab8jX5Wl45K6Ovas=;
  b=RJFDB3zCDV/4wFtDXbYkC17I0Ra9Kb/G9NYs7LkvZuK+jcgKTTEDbHh0
   6Km8bCo7pphfOYCaY5Nm4PUktEYHi1EHOiBlH2fGqGS60MrRidBMSlW2Y
   70ubVv1C8XibxHDGHzvi9z4CDC8PRoGErelbV2+JGxAtrwWEiNLEn8vfd
   QnphZgo7n1aHID7tyiirx5nRYDlzTe1WcIa/QT1g7J/ldia8UHaMmJB0E
   TD1eqfa4NZvRoqTFzHPSDkYH5tBLkiaPeh6FeLRctPxT8gjmbh7TA9ves
   3LMltzpyCabEz/RPHnDT4dt9v8kNNimy2eJGrBC7lFPsR8XiHcA3vK6qm
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10659"; a="320366367"
X-IronPort-AV: E=Sophos;i="5.98,290,1673942400"; 
   d="scan'208";a="320366367"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2023 05:37:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10659"; a="713350010"
X-IronPort-AV: E=Sophos;i="5.98,290,1673942400"; 
   d="scan'208";a="713350010"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga008.jf.intel.com with ESMTP; 25 Mar 2023 05:37:05 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Sat, 25 Mar 2023 05:37:05 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Sat, 25 Mar 2023 05:37:05 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Sat, 25 Mar 2023 05:37:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lKPuXSaC1efvKOoZB/h4ajJ1/eBV52UUGhToQwR4kWeamd1penbH5YkWHhDqudoroR5wame0ezV/4zcmYr5szgO3bVgxRbe1lh7cV+xoAreQyv/S2zDHj8JtJR+RZ5j0EqHHP8mpg/xJSN41M6se2hso1EGafYsf0l1QFnlNbsoNM/dwTkP3h8ps2mQ5r01VAemL1gsBVeYucprYetFKTLMvCMH9s1xEzXNCLceN/YMTOF68wRzAQKrgtRba9ubTik5Sr3IJ8ytRqwejNQ8MNaKFSzf924Z4qEzk0BnnyhmxmVTz+3ov95YI1dN8ieqqyHTHrVxwZm0qEbJFJmdkTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Dc4X8B/iep3i3pQ3ThaZLteueh7pzA75I2QZ9xvwRPc=;
 b=c07yaYXISUZEO85W1CFIxg2akze/6L8nm7j2QL2Gf85GZEGR/PQ2FI2EAfTutBlg/xCEXUfmVI8Ke7QjBpV00gTkNbliyD181hsPK+bhtTmzzY5cSiyVlsCuggtl3otxIHdjG6zqac4Ujm8MxFdOPJwVupOHiyGovR/z2lMHLJW/mhbVyy9xQwuREjFHMhUY9dxJCcgmjOm1fveVxbMTf5ADEGjDBPNIp3tiUIxyH/t331/3zFdOEPjJP0+FOjXs2NwcBJkcFwp6kSM/l8p46mC5KCrpeUipJLnn5MTlwnjUiOMbz1OXtxAVVRHn40qmL11dxfvpJNwdLq+AHOQ+jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by IA1PR11MB6513.namprd11.prod.outlook.com (2603:10b6:208:3a3::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Sat, 25 Mar
 2023 12:37:02 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%8]) with mapi id 15.20.6178.038; Sat, 25 Mar 2023
 12:37:02 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: RE: [PATCH v2] docs: kvm: vfio: Require call KVM_DEV_VFIO_GROUP_ADD
 before VFIO_GROUP_GET_DEVICE_FD
Thread-Topic: [PATCH v2] docs: kvm: vfio: Require call KVM_DEV_VFIO_GROUP_ADD
 before VFIO_GROUP_GET_DEVICE_FD
Thread-Index: AQHZRmSHSCn273Q8LUmQ31uY2aWRUa7aPyMAgDFgiYA=
Date:   Sat, 25 Mar 2023 12:37:02 +0000
Message-ID: <DS0PR11MB75294EAD611174E5DEBFAAC8C3859@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230222022231.266381-1-yi.l.liu@intel.com>
 <BN9PR11MB5276EFCF9C8273C441D46DC38CAA9@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB5276EFCF9C8273C441D46DC38CAA9@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|IA1PR11MB6513:EE_
x-ms-office365-filtering-correlation-id: 80f546e7-933a-4691-a03a-08db2d2da26a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oJcItN5C3PcS9rQED1EaL4PfCPo0xzNjtn3979fL6oVjLO0/aGVgRhXru3MdEXER/ZsE5sopELx4LovGaTYwq0VX669gCVMpowFvzYoTgrvMi8z3wzkwBt9ItXtSMm8vN6fYT4Fzz6GSPDDKty1ArhQET4F7SQy3Fen4WTlknnAgWb4jBth5qNVh8tr2nlHS1JM/hJDAnv2DsblJ3KzkG0pluA9mdzlIG6IhFVSYugxD6QsD8RdyIF+FmvYgA1tvRX98joGr2oF97TgDei0T0e1ixHR7Skv1EumBU/KGM+Z+KdJsceuegwvaUFBZwje6g+LJbux+lT8o5FF3ZJmBRXN9u81rPEeNOZtUq1sLTgb+qny/luqQmFUlBFbdUdJnAjJapIXAX0qjg8gsVUV0pfx6Ujnou5VfLa43ltnRGD2KGyJj1z248uLeba0TytgPozLeYWxZAwdp3h45PDCOJyXBLKogFEet1YycT8uDoc4T4fgi1UlL7PT1zE0qNMSBXJNbdfFfR6sNyo53Wu77AL7qLX9wwYl7qpgoYz+HunZ1LbiWfItAJmceuMNw7pgPoS5Q0nXDKHJR3iip2750XbiRgsnOFjJBfRXc033Ax6ARekYqkLbKyfiCeryvuUc5
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(366004)(346002)(396003)(376002)(451199021)(478600001)(38070700005)(9686003)(6506007)(26005)(83380400001)(966005)(186003)(86362001)(33656002)(71200400001)(7696005)(55016003)(41300700001)(110136005)(54906003)(5660300002)(66946007)(122000001)(8936002)(52536014)(316002)(76116006)(4326008)(82960400001)(66476007)(66446008)(64756008)(8676002)(66556008)(38100700002)(2906002)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XsriuCGNLlSekRQ+Tq7g2rVIqn8oX01tiUVZxN0hTKvxsBW9tjplSWSKlukT?=
 =?us-ascii?Q?Pd5BhpKraIBSIiLw8It3jl3QtGUp0z+rXUkNINjoxBVDnuxnVTyA20r+p7me?=
 =?us-ascii?Q?vi0mAGBXWcyxdhkLogHqLZ3M4Z7zT+G3BaQIOvD/rX0Grk/ifzQdgNrWjfgZ?=
 =?us-ascii?Q?wZ1MH3Z5bU1g60RqDgEikRy+7expQl6qYIZyQiNabIds04YBYjOamUrdbBn5?=
 =?us-ascii?Q?94OFSHUlc+dDbBSmZYnwZ0kMj23G5IUDCEQ0FMEuPWFu1duQQ7S3rA5eRcDa?=
 =?us-ascii?Q?wm11UrxE9CtuvYclCvcgfVZ3q6mq6dWINOie182abVZqXyXxxx/QB8qmZ24f?=
 =?us-ascii?Q?+SGMT0mqSNcXJs/w0v+98LQXVnXhiF4iIXSRGkBiA2Sv3mP9+2tzSFmWDURc?=
 =?us-ascii?Q?90QXpMMojwHpRTVwOhdUtbO32pHE15sjL1KjVhn0WFQJpdj0yX/j6bfFdxUl?=
 =?us-ascii?Q?XDGSn8p/1tEJt7md6t9DgbA6YS6YnpLQhsCm0f/rvCzqyQxVSxQIoxO2rUu0?=
 =?us-ascii?Q?s41E/Oy2M/J5H9QVfGyKXxQzH6INv9nMfoal5dKQYZV1dmHHq9c0gWimh0iz?=
 =?us-ascii?Q?4Smg/5Fd9dxrPu3BLckgmnZGENrPqCKF+p/yGfGOf/rS8UqPS596OTrCsSyz?=
 =?us-ascii?Q?/jRblq4nm+Com9t5rJgSm0+9I7u7Tpao/i4byENgVsitywyjFvgvjE8oIWBz?=
 =?us-ascii?Q?bdQ58pCSOYY49qCwgQiT/r7TD9Od0oD96mJhhcylBmOPwIumDLDUbhAlZuau?=
 =?us-ascii?Q?KXMlZ8wNMH8FHwlrKEG8yC13lF6QDG/yTzKGfWjURtmx811aG2no8ZwVb2fd?=
 =?us-ascii?Q?mnQJrI9IJZf8e960qI8aBXq5H+3RAjmM5ojyObl6ixdoBBVAMhJwd4pxdLqa?=
 =?us-ascii?Q?ZoZvbFTkDdX9s5Q8TW7LBVgPGeezqFsI0PaPhRgErsN7Ij9VtVEIxW+gZwkj?=
 =?us-ascii?Q?yr+q6h/q7Ha1sOlim3JaCm8YSO08eoqGy4xrdPrqW7J/Y3NuO/k4x31rlSnR?=
 =?us-ascii?Q?qljm5wYZDMmYqsrqc4TRwgn4YsYOFHFLItLmOqyk+PnjDs3rSVkKMfnoce1h?=
 =?us-ascii?Q?iMgp/r6E6Dknq6DTMpXGGvukjQYXSf4/ghr7cdK/qsXilGeKsvFImr6DTaa5?=
 =?us-ascii?Q?g7+ADtM1BQhrTpLCxWx8upoIWfLc5DX9lcgJN9z+K4FKMzfp8D9GJ46Z8oo1?=
 =?us-ascii?Q?4THF325qdfM+JBy1vsRdXzMozIgug35h37iUuS26cbU/nzOMQJa/DsPFjUVl?=
 =?us-ascii?Q?3RSYnTBlcZGr2nvvnFtA1MOcTTik+QKKAbEy/th118HFfHy/iCOm9+R2vLWC?=
 =?us-ascii?Q?PGtJ/6DAQfYPR/XfIJU+a+E/iVZs5t96XUqb7ef45c6B9lUpMkNqjlEQP1Gc?=
 =?us-ascii?Q?lghKzmXUZVh4o4LuwRTxywr0ROEgpEB6WMzTfgCorZwoAB9GBqU7P8o2e5AX?=
 =?us-ascii?Q?unPb5ViKlZGUR0VVu18e20hzHF5oiYECK9Jf1ksbD3KLX8SaxceM++xtyVjl?=
 =?us-ascii?Q?e/9mavax8OmvGS9ktLgcOOwlxcX5M6qzyW52881Fhu5Y8VanLIFjobUmGTzw?=
 =?us-ascii?Q?vsNIRXCg3snN7QYRjiKgGbuJe0B+1HtkhEQENruk?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80f546e7-933a-4691-a03a-08db2d2da26a
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Mar 2023 12:37:02.4107
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lM+OuyIyyKCqlvBr+I7VZhS989HqqnccxWDyNko2+r5vJwtaFNejr8bq+DuAaqLHgyvlMGjz/wo82gZjYRthiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6513
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Tian, Kevin <kevin.tian@intel.com>
> Sent: Wednesday, February 22, 2023 10:33 AM
>=20
> Paolo's mail address is wrong. Added the right one.

Thanks. @Alex, do you want a new version or this one is ok?

Regards,
Yi Liu

> > From: Liu, Yi L <yi.l.liu@intel.com>
> > Sent: Wednesday, February 22, 2023 10:23 AM
> >
> > as some vfio_device drivers require a kvm pointer to be set in their
> > open_device and kvm pointer is set to VFIO in GROUP_ADD path.
> >
> > Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> > ---
> > v2:
> >  - Adopt Alex's suggestion
> > v1: https://lore.kernel.org/kvm/20230221034114.135386-1-
> > yi.l.liu@intel.com/
> > ---
> >  Documentation/virt/kvm/devices/vfio.rst | 7 +++++++
> >  1 file changed, 7 insertions(+)
> >
> > diff --git a/Documentation/virt/kvm/devices/vfio.rst
> > b/Documentation/virt/kvm/devices/vfio.rst
> > index 2d20dc561069..79b6811bb4f3 100644
> > --- a/Documentation/virt/kvm/devices/vfio.rst
> > +++ b/Documentation/virt/kvm/devices/vfio.rst
> > @@ -39,3 +39,10 @@ KVM_DEV_VFIO_GROUP attributes:
> >  	- @groupfd is a file descriptor for a VFIO group;
> >  	- @tablefd is a file descriptor for a TCE table allocated via
> >  	  KVM_CREATE_SPAPR_TCE.
> > +
> > +::
> > +
> > +The GROUP_ADD operation above should be invoked prior to accessing
> the
> > +device file descriptor via VFIO_GROUP_GET_DEVICE_FD in order to
> support
> > +drivers which require a kvm pointer to be set in their .open_device()
> > +callback.
> > --
> > 2.34.1

