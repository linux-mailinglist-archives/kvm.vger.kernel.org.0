Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8470768741B
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 04:47:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231864AbjBBDrH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 22:47:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbjBBDrF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 22:47:05 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F74C64D8D;
        Wed,  1 Feb 2023 19:47:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675309624; x=1706845624;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6AEr5Bj2x6U7zZJfVN5SpcVOrOpJrgNUqhoImx4sE+A=;
  b=BJeFrUUQwuNsovrdQ9Mglti2oI/GZJ+3Q2NyVIGo+hXaKoY2EkLuZpCF
   6RzRn2M+fgqbafYhWWoaoRyLrGvntD1k1nUnsxEnYw8tyFME1qGLiM/8G
   D5GsifAtoPhWYTBT20moTVaBcx/iEwkiNpCv8hup7nlKh+UhxuA2e3yCe
   mC/Bt9OvXbFtkgcRGK2oon1mrI9F9Gggxm6NS0xTJ3FQgseM/ei9o8nGi
   Neb2hCHZwHzNS4k9v3yntw2YJzywFVZo+ZXa/jstVkzMuLkx0Yqsi1rLk
   Kh/3YjkPjcfPKBYEtlNuDx4E0WqTvikUxiKQcmc1cX80AdgDxnbSFzsJy
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="392924045"
X-IronPort-AV: E=Sophos;i="5.97,266,1669104000"; 
   d="scan'208";a="392924045"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2023 19:47:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="658570200"
X-IronPort-AV: E=Sophos;i="5.97,266,1669104000"; 
   d="scan'208";a="658570200"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga007.jf.intel.com with ESMTP; 01 Feb 2023 19:47:03 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 1 Feb 2023 19:47:02 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 1 Feb 2023 19:47:02 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.104)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 1 Feb 2023 19:47:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d/PLgp4/Iu8lEpgmKKbhdbEJ7zUnl7imEZE+xlLf26MjP+XfvfwWZ3Y0IAT3mXblELgAwnms4UmpfylQZBz20wCXG8N5yhMLZVWfzNOrjZCc5b/pj91yhw9uhe6uOM2kVlFEqDSD5eiYBX+/L9AOr69/DE1JUHR1oni/YMGJ39vytvzIfRmpf3CCJQ0WmDnV1ReEM5AGTdC57VZ2HH62V+FGDFf4Lxf4qwuWtmSQztVXUwRTMRIB344DDQtz0yq78+/hbP46z7ovYrwazdLNAtKKO6IlIzGXJGh5ou1r867DBY/YG7DPBQi43VWOrmsDJ5NmE6n363Zx3JMPCjJMUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Szp9QYdfkNIea9cT1rD5E+/mM0FxkA7lgfpYQ8rUDOE=;
 b=d8IUQ2D1msUrFq22wdPh+1J8vbNzDGom059TbSQhSZvbRGjEqzStuZt/RpUsPeikf5GNEL5zDWOqGRbLMivfHd4Rc5uEAHiE4xXW07uVCzsipP4SqoKJXr3Hk+FPn6p1gwXbpdeK5Ar1MWQeh1hE8sa/2114ZxQP+iMkOOmdszFVBZn66sD2soYZUav7ftU+ofg+JNPVgxan08F8dLrPP0Cosh0pkDa0IN1bf8VV3KSd7Lpg2WQZVTgUg//c2IMoHbKLPfdIdktztYNgzjbzr+IMBK+nXkxwOO9sXrEIL0XZEKdqVQftYKp4eCLF3Mf7LmK09f5qBVFebc2LUx1gFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DM4PR11MB7351.namprd11.prod.outlook.com (2603:10b6:8:104::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27; Thu, 2 Feb
 2023 03:47:00 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3%4]) with mapi id 15.20.6064.024; Thu, 2 Feb 2023
 03:46:59 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>
CC:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "pmorel@linux.ibm.com" <pmorel@linux.ibm.com>,
        "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
        "frankja@linux.ibm.com" <frankja@linux.ibm.com>,
        "imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>,
        "david@redhat.com" <david@redhat.com>,
        "akrowiak@linux.ibm.com" <akrowiak@linux.ibm.com>,
        "jjherne@linux.ibm.com" <jjherne@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] vfio: fix deadlock between group lock and kvm lock
Thread-Topic: [PATCH v2] vfio: fix deadlock between group lock and kvm lock
Thread-Index: AQHZNnJFDhMzPRK6pEGcr6itqpvSQ666vJwAgAA/7dA=
Date:   Thu, 2 Feb 2023 03:46:59 +0000
Message-ID: <DS0PR11MB75298437F96D08758DB92368C3D69@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230201192010.42748-1-mjrosato@linux.ibm.com>
 <20230201162730.685b5332.alex.williamson@redhat.com>
In-Reply-To: <20230201162730.685b5332.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|DM4PR11MB7351:EE_
x-ms-office365-filtering-correlation-id: 7ec14ef4-b44c-4200-8954-08db04d02339
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cMo95HlkU/n/UgmswnCbczRZlmULuOQ5H57it+aneSnnzAtXo4HmtDiNpwl8BPsQyTrZn2Tw/94fLcAHU4vgjF6s1DtTUCbvFAhCuDOv4ERRVxhAyPyOQRy+TUT1IQMGGX44bQmMpJWQXluHUPMGBoga4ODybj0H+6WrwL/U/vbyhwpK/1TaAZXPK1iNCTXE9lOGuvGRgSfI2v5TxvSxa+Vesgmo38F81XEim7PRKeuog0ic0f/QjTgOi0AYuNnN8S/UgubzoCsrW+mS25g/rqcF+UyRVCdKImfuLPh7BmRiReQCLtD/NE5/YlOHJRn3PaZCuXcsnA02ZLheWHMtpIPHVGzUmTOE7IgRhaiHF8a799DN+GfeiDuZB2qC3/tCYhxRjA/oMT57xohI8uxL2YIjXUShLQiDv9KlPSZQM7xi2JgFAZHPLUSa3svwM95YKhpbSDsWQIb0zPmkAM1X7JSwL1EBKZk0gJmm8CUpK3UW9U4mOr1c3tlV6+C+upelqKTKmMlxFgqdlD2IEgtmC938imjbjImmIgafn13Dajt28E19u5Pcsk2FNtc7Oy+ecMskMI0lEQt6QBiSvoi0Dzx6SGB67tP72GatLea4QxxL83HqV6Y3XslOUnEgusFXdxFTXSO9ORn/7W5Wsce24Mp6XhOerEfIXTck3t8yHMhTCTXyeS5IJLAWb8172dJDuVejDRm3ZJs/1KrQHxxwFZVFG2IPIz4weH9KHxvFI1w=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(366004)(376002)(346002)(136003)(396003)(451199018)(52536014)(8936002)(316002)(86362001)(6506007)(71200400001)(7696005)(478600001)(38100700002)(82960400001)(38070700005)(26005)(186003)(9686003)(122000001)(7416002)(5660300002)(54906003)(110136005)(55016003)(2906002)(33656002)(83380400001)(4326008)(41300700001)(8676002)(66556008)(66476007)(66946007)(64756008)(66446008)(76116006)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?W/QUfnDG5tk/AIjnSLZEGEHBPQlQolihrxYfqcHcw9NFKcoctgHqpteqfdg0?=
 =?us-ascii?Q?tong8tmq4JCSxpOQa3tdAeb63KS4h9Zsx7Tk91ZP/wzp7EkV8kwCJmB3rwWw?=
 =?us-ascii?Q?Kw7leGVEb3EkPrQZmc+ZL8GMTltAlsLHe8A3eKduBCA9C566ahdsV2C/9QZC?=
 =?us-ascii?Q?AM1J1bHXt9TDtAyJ2Lgb//agNIdnjKagiX7kARCGEVMsart35fZvFOCVXNr5?=
 =?us-ascii?Q?VAzhyJm2cAhk95IjDxrIPo9B6mD4bUpDnZgCnYmcWKwCuiv2SgtYhyJBWvRS?=
 =?us-ascii?Q?czKKsDZrG1/0clrMp7dkVbxP5+Nn7LUHO7hDLPzLtHSKShJ/kNANx6hp67EN?=
 =?us-ascii?Q?9tsC15Mj0JClLV2viRoPpQpDiSfAjIT55jUW0LdzAXXwVcxD5WzJYUYlJK/v?=
 =?us-ascii?Q?E9l7Q2mFSlU/UCrqO2a2GDZycQ+3lkzvHmhJ8pfNl0ixyJoJNen+qIVpaaEz?=
 =?us-ascii?Q?NxnuBzsSatzdKZbFvcHMwM413OP7W2/6ddLYUa6INxamA8B9jGzbUPEUZF0f?=
 =?us-ascii?Q?TGhb5/9/qa/BtphuYGVtYkkOU2mO5UIBExTTnR2JMuT8s+bDoYERWbPAHdrY?=
 =?us-ascii?Q?4ILMAwYB9dsO0LYDR+vP4hoBlM2+0eev/Qxrn1W38qZLRymXdLg64271lo/8?=
 =?us-ascii?Q?UBKzZ6DBOJjNrHSLBI5G+tIzsnBaCIorvCl0e6a5++x+7BFsClVT3lEHCLsx?=
 =?us-ascii?Q?Q5pQKiaddA7zM/VYPYkN3qPWWXox7/1hLYmodHbxf7C39BV7ebxP/jDMh5lP?=
 =?us-ascii?Q?qG7x4bxqJRCEpckXowZiQPy8JI9DyQEsLlBk/kp8rTLGWimPq3IQf/GVnRFF?=
 =?us-ascii?Q?+SyD7Y+8GEjf3YqDrJfaAenUmzl9QtA00vjgahp0nobXnMQ5FS7cHEuA+OBe?=
 =?us-ascii?Q?Zefviv4wWS2mzQN0opaR+eTVQFlo2amSHlK2Wu7Bxr6nmuHffERnjL7JWIPQ?=
 =?us-ascii?Q?1rk5EZwOuBOJeipTa0LfQ2gU4yVIxmGtskikOrfQUIWKkRV6NUMWlWAExZH2?=
 =?us-ascii?Q?KY+NFPRdGdy4V5K3wTw/J0GFTdXaw3vsivRAmlneq8mjtahSefxuNbHvxSJf?=
 =?us-ascii?Q?u5YQMubDgCuh4RwTWXNED5qJ4OJFWViOeNokglGYRz8Y5F/KBJj+6ZBSO9wP?=
 =?us-ascii?Q?EsadJ/5PEVFp4c0IztFWiAFYBhn/CSqenF5o6OoMEVw/ohAxqs9dVboHssRX?=
 =?us-ascii?Q?fJpNeM5i8KPfSiDKRyjeul0G58PzmdET2YCRj0mH9NvTM8NI1xy4rMKymCsY?=
 =?us-ascii?Q?3GI3YUKi7hc+GVruzglPOYkDE2ogbu1E3YGFgzy6AiO48Nx9Rs7Lg9aGSIDj?=
 =?us-ascii?Q?Pu3Uyn1xOAg4zOobg53lDls2qNXVTAJyXNBIQyfP3Tq57BLiXGe2mLshD8uq?=
 =?us-ascii?Q?cJ2YlNwg4jyz1xweAdA+uN4/PIu9CjYi5pI3F0OYBI42pVP92FFieHZYYY1r?=
 =?us-ascii?Q?WHeb+sP1E+e1ap3GF26N81YYjTyPG894Twww6OYY0liyh4VFxovvbJL37V5o?=
 =?us-ascii?Q?4Ir3LZIiyYgcrzvhxDuDw8DAM6G8pKXmKo2/Y2sJ69XXLN2M0nqANa0bN2d3?=
 =?us-ascii?Q?JrWtPRjFIhiAap9+FviwxMl8WF66ensbZUNq4OJC?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ec14ef4-b44c-4200-8954-08db04d02339
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Feb 2023 03:46:59.3582
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6KKH0XDqF5rMKKzePZZ0oAcOinSK0k3PoxHUwp6fhNes8jV/Yj9S7bb11HznOGe/owFrVnxwzK/kc2l6lOETfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7351
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Thursday, February 2, 2023 7:28 AM
>=20
> On Wed,  1 Feb 2023 14:20:10 -0500
> Matthew Rosato <mjrosato@linux.ibm.com> wrote:
>=20
> > After 51cdc8bc120e, we have another deadlock scenario between the
> > kvm->lock and the vfio group_lock with two different codepaths acquirin=
g
> > the locks in different order.  Specifically in vfio_open_device, vfio
> > holds the vfio group_lock when issuing device->ops->open_device but
> some
> > drivers (like vfio-ap) need to acquire kvm->lock during their open_devi=
ce
> > routine;  Meanwhile, kvm_vfio_release will acquire the kvm->lock first
> > before calling vfio_file_set_kvm which will acquire the vfio group_lock=
.
> >
> > To resolve this, let's remove the need for the vfio group_lock from the
> > kvm_vfio_release codepath.  This is done by introducing a new spinlock =
to
> > protect modifications to the vfio group kvm pointer, and acquiring a kv=
m
> > ref from within vfio while holding this spinlock, with the reference he=
ld
> > until the last close for the device in question.
> >
> > Fixes: 51cdc8bc120e ("kvm/vfio: Fix potential deadlock on vfio group_lo=
ck")
> > Reported-by: Anthony Krowiak <akrowiak@linux.ibm.com>
> > Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> > Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> > ---
> > Changes from v1:
> > * use spin_lock instead of spin_lock_irqsave (Jason)
> > * clear device->kvm_put as part of vfio_kvm_put_kvm (Yi)
> > * Re-arrange code to avoid referencing the group contents from within
> >   vfio_main (Kevin) which meant moving most of the code in this patch
> >   to group.c along with getting/dropping of the dev_set lock
> > ---
> >  drivers/vfio/group.c     | 90
> +++++++++++++++++++++++++++++++++++++---
> >  drivers/vfio/vfio.h      |  1 +
> >  drivers/vfio/vfio_main.c | 11 ++---
> >  include/linux/vfio.h     |  2 +-
> >  4 files changed, 91 insertions(+), 13 deletions(-)
> >
> > diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
> > index bb24b2f0271e..52f434861294 100644
> > --- a/drivers/vfio/group.c
> > +++ b/drivers/vfio/group.c
> > @@ -13,6 +13,9 @@
> >  #include <linux/vfio.h>
> >  #include <linux/iommufd.h>
> >  #include <linux/anon_inodes.h>
> > +#ifdef CONFIG_HAVE_KVM
> > +#include <linux/kvm_host.h>
> > +#endif
> >  #include "vfio.h"
> >
> >  static struct vfio {
> > @@ -154,6 +157,55 @@ static int vfio_group_ioctl_set_container(struct
> vfio_group *group,
> >  	return ret;
> >  }
> >
> > +#ifdef CONFIG_HAVE_KVM
> > +static bool vfio_kvm_get_kvm_safe(struct vfio_device *device, struct
> kvm *kvm)
>=20
> I'm tempted to name these vfio_device_get_kvm_safe() and only pass the
> vfio_device, where of course we can get the kvm pointer from the group
> internally.
>=20
> > +{
> > +	void (*pfn)(struct kvm *kvm);
> > +	bool (*fn)(struct kvm *kvm);
> > +	bool ret;
> > +
>=20
> We should assert_lockdep_held(&device->dev_set->lock) in both of these
> since that seems to be what's protecting device->kvm and
> device->put_kvm.
>=20
> If we change as above to get the kvm pointer from the group within this
> function, we can also move the kvm_ref_lock here, which seems to
> simplify the caller quite a bit.
>=20
> > +	pfn =3D symbol_get(kvm_put_kvm);
> > +	if (WARN_ON(!pfn))
> > +		return false;
> > +
> > +	fn =3D symbol_get(kvm_get_kvm_safe);
> > +	if (WARN_ON(!fn)) {
> > +		symbol_put(kvm_put_kvm);
> > +		return false;
> > +	}
> > +
> > +	ret =3D fn(kvm);
> > +	if (ret)
> > +		device->put_kvm =3D pfn;
> > +	else
> > +		symbol_put(kvm_put_kvm);
> > +
> > +	symbol_put(kvm_get_kvm_safe);
> > +
> > +	return ret;
> > +}
> > +
> > +static void vfio_kvm_put_kvm(struct vfio_device *device)
> > +{
> > +	if (WARN_ON(!device->kvm || !device->put_kvm))
> > +		return;
>=20
> It simplifies the caller if we can use this even in the !device->kvm
> case.
>=20
> > +
> > +	device->put_kvm(device->kvm);
> > +	device->put_kvm =3D NULL;
> > +	symbol_put(kvm_put_kvm);
> > +}
> > +
> > +#else
> > +static bool vfio_kvm_get_kvm_safe(struct vfio_device *device, struct
> kvm *kvm)
> > +{
> > +	return false;
> > +}
> > +
> > +static void vfio_kvm_put_kvm(struct vfio_device *device)
> > +{
> > +}
> > +#endif
> > +
> >  static int vfio_device_group_open(struct vfio_device *device)
> >  {
> >  	int ret;
> > @@ -164,14 +216,32 @@ static int vfio_device_group_open(struct
> vfio_device *device)
> >  		goto out_unlock;
> >  	}
> >
> > +	mutex_lock(&device->dev_set->lock);
> > +
> >  	/*
> > -	 * Here we pass the KVM pointer with the group under the lock.  If
> the
> > -	 * device driver will use it, it must obtain a reference and release =
it
> > -	 * during close_device.
> > +	 * Before the first device open, get the KVM pointer currently
> > +	 * associated with the group (if there is one) and obtain a reference
> > +	 * now that will be held until the open_count reaches 0 again.  Save
> > +	 * the pointer in the device for use by drivers.
> >  	 */
> > +	if (device->open_count =3D=3D 0) {
> > +		spin_lock(&device->group->kvm_ref_lock);
> > +		if (device->group->kvm &&
> > +		    vfio_kvm_get_kvm_safe(device, device->group->kvm))
> > +			device->kvm =3D device->group->kvm;
> > +		spin_unlock(&device->group->kvm_ref_lock);
> > +	}
> > +
> >  	ret =3D vfio_device_open(device, device->group->iommufd,
> >  			       device->group->kvm);
>=20
> We're using device->group->kvm outside of kvm_ref_lock here, it should
> be using device->kvm.

Existing code set device->kvm in the vfio_device_first_open() which is
called by vfio_device_open(). After above change, seems not necessary
to pass kvm pointer into the call chain. Isn't it?

Regards,
Yi Liu
