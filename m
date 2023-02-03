Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7C286892E4
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 09:58:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232142AbjBCI6S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 03:58:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230456AbjBCI6Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 03:58:16 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33A4116320;
        Fri,  3 Feb 2023 00:58:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675414694; x=1706950694;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TA7E4um/srWI8yohOJKACm+0mMuEiz5pQ4gqcHVPCUQ=;
  b=YJkWO49/BM/rXEHyWbUHuLBct4hhi8lK07mDflq8yzxxK+HVieaUSp4s
   qLXviY2YKYOHIEBh4P7InqdEOMe3JglGcnC31H1zZHRsvsHa8AIMqvkh6
   2cANBcs+Lz1emU5YANqV5/V6M5Gb1sqv1pXEJ3gmflkFD/9ny2WDIx6TG
   jhlviRRe2aKkSVH09IBUqkWvTYjvVugk8H2/qYwjrlPLMS9Xubrtfx9jn
   Xw9bfG/3l2K+5ZviCSWPdJbrqQpQ5H1KAmo97ZRFIXUxT3AYlxO6229E4
   2seDbI+B8KeAJIWWrUsmoY0/P6qDHMNY0gLyfCPEqmWyK1sMLSSgA66qF
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10609"; a="329982650"
X-IronPort-AV: E=Sophos;i="5.97,269,1669104000"; 
   d="scan'208";a="329982650"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2023 00:58:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10609"; a="665653607"
X-IronPort-AV: E=Sophos;i="5.97,269,1669104000"; 
   d="scan'208";a="665653607"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga002.jf.intel.com with ESMTP; 03 Feb 2023 00:58:13 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 3 Feb 2023 00:58:13 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 3 Feb 2023 00:58:13 -0800
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.42) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 3 Feb 2023 00:58:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EgAJc2SwmKvu0Opp65Pw2iqBIztQkK5z/r5R2c6L0Q7kgYedac0wgmwwZeMFh6tHEnsdmQZI5/G0ZdBwfMdSVVPsfH2fi6dDEiYzb8ITQ6POBiAarlR9HA26uCYKVTZjFDZZNqK3jIHbZTkyKZC/IJecT5IatFoI/V5I0FbuyCUY+ODQP17JX/HfSWekcgMSMqfAjIV+EmqvR3l7m3nk6iL+xgqsHhT3CV9drurbnaj1zojnc7wQwsNL9mHZ1eZ7WSQkF6Rh/eYI8aftCVnnE8Ig+eepSRao6e6zHvMb68LQAA40eCHGxZntavKbr/mEqF4oI8cnRD/e6ITdgOirAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HWUH+iFS7kUG1loC8xULl3lGKnFCBHsZO6TRIHJwsk4=;
 b=nywbCFPaOgY5lFJ3H6JODZz+Eu+8MS6Hwwu9q9/PFNK7+fPxvp0bfpTq621qbwy5Sg66Jc77yAhIQCLWOvT9h6LhiPnYaFHfzMleIj3UaDcdXRXcMPifgnBoTBTsTizRmuL3aaWh80lhC5zOGB4qZF/j54FGxetQPVGTpGur/KWkDx6eVqo3VSN4d+6GvQe8kz8DRCSh5cBImzKYpkyqkFr/9UKKubXCufX6eKmhg3eshYYzNDgkHocnXL2HED7vxJ14RDAeSTYoxnoKRmGOgnKcAWWf7HWIYT8eD+Hw+lONt3qWdwEzIgqhSHTvOfa517vUhK+VK3/1YrJyggHZAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH7PR11MB6475.namprd11.prod.outlook.com (2603:10b6:510:1f1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27; Fri, 3 Feb
 2023 08:58:10 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3%4]) with mapi id 15.20.6064.024; Fri, 3 Feb 2023
 08:58:10 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "cohuck@redhat.com" <cohuck@redhat.com>,
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
Subject: RE: [PATCH v3] vfio: fix deadlock between group lock and kvm lock
Thread-Topic: [PATCH v3] vfio: fix deadlock between group lock and kvm lock
Thread-Index: AQHZNyMjAB7EXHsi0Ue5s99XWjtHT6687BlA
Date:   Fri, 3 Feb 2023 08:58:09 +0000
Message-ID: <DS0PR11MB75295F851A74ACE7CAFB0ACCC3D79@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230202162442.78216-1-mjrosato@linux.ibm.com>
In-Reply-To: <20230202162442.78216-1-mjrosato@linux.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|PH7PR11MB6475:EE_
x-ms-office365-filtering-correlation-id: 0ab63254-68ee-448b-28e8-08db05c4c633
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0IjnufiUGXYUMbvfEOF21DZF8Z5tJCy0QvjM5ugVWRPVgRDvXqbipl8OkgmvyqPYwGZrtPnajZ79OltLCC3FL8BKDPDQmID72Zrh52ETd85AIgAlBh8g+IC5JKTUz3HVgqczeJbfdwULP3yYcNCTnRVr6AYRqsqQznbvNU4NkDRpxwOCOvQAtPlg+6DAat5KUx7AJLFsh5ie6ZoWa8ADwFaxNDLoRbkWlGgtlYspgEA89SvFBxXjL+61bWJqIGEniPsLDK6dIvgvaOKNSOuTKlwkfBY7pKxRjY66f9pYRhEPy1TKLCN5mbKeObH9gAZ4DTVfB8KSD+sGU665L1YR+29ng0uqSMNG/uusGp7nFWCJTES/QpSYn1Xl1WcaCaic1iP0ryzlST1tbFHHdSv4zj4HxVam5LjlCOqzP2N4VpkZEad1PGzRWcZKMUcjLntmthfTuKvD75ZdSoCUHRQ7dmE4f30tL+510oFQYYuCpJy46lWM3PT3gCVBaAOaQEwYOh05q/P+D8qoQ7wbqKAXCi0XX2Gcv2iZjtsvML6gdzMjEAUT3tlgA9D8WRG+nXqNPp97oGEeLcVKM/HbU6nlwPRbIGUWMuPDKZhPLh052yBz3/7m5gqL9gOUwM5AgUpwiYPtYx01Cvd+yXuvE/bkusRNMAuLzCLWSVXyaMF2UzYFn488B27brAXm06jXyibfHGNL+sMZV7jVjY50LEJhyaAsHMs7nrB37IP6L660HJU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(376002)(136003)(396003)(39860400002)(366004)(451199018)(110136005)(26005)(41300700001)(55016003)(186003)(9686003)(6506007)(82960400001)(38100700002)(54906003)(122000001)(8936002)(38070700005)(316002)(2906002)(71200400001)(7696005)(76116006)(52536014)(66556008)(66946007)(33656002)(66476007)(83380400001)(86362001)(7416002)(8676002)(5660300002)(64756008)(66446008)(4326008)(478600001)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?6SmUpTy0Un5+HALjYZMvl/DfVPIc9v8j45Zpo3ZLD9LA/GGgKEkNjY95skZY?=
 =?us-ascii?Q?hyTSVK2AhYe5ImuDGTlWuV35wmpBxBo4zC5Y0bN9b0rrMyOi+pj0GlzNtz0S?=
 =?us-ascii?Q?gUjE0ZnumeqF5r5fmcPfYXqnhsK9SRVCdaW2XfTMxpjkKpEnfMzVDGiEOH+T?=
 =?us-ascii?Q?Q5SIGvXKhPgSIyKsh94hYvKyZ+HUVYPpjQN0PmkIS51qvPs+5LYRa65j/kww?=
 =?us-ascii?Q?AGsmmVBqRajMciL6oUbReyhIc7Ysw4wGNOU48/8J8YeK07VbVHNiCDExuXmk?=
 =?us-ascii?Q?s04ytfyInFXnuZTYkir0G2ktrrLFYDKQpOJWVrl/L+MCaejZJ6WdRTjn1f81?=
 =?us-ascii?Q?NXazlw5byqmYPHs/yrArUDv0tnDiOaa9tYNnc6uEOaJ5vLzZ7fSvWkoy88AU?=
 =?us-ascii?Q?vusRNOcfJWMenrPucSneuRpdx1KMYJIpAUJME7Ic01D08/74meZf2nmowKpi?=
 =?us-ascii?Q?szWogMYJQbrloFe7IhSM8We8JsnP08/xZAyCLZUiaGCYbAmq3DGXjr5KElU/?=
 =?us-ascii?Q?UPC1RZe/FUwY1xraDffgS5R8Uot+mUfCopNGvapfJV6UK3febWwTPXEKUBhK?=
 =?us-ascii?Q?PGISNychkp6GkS9A54LkGv0DUCC1FUw9cAMjnoSLv8ZdCAWzS4tVDaPYd4c+?=
 =?us-ascii?Q?O5E2gKPnhegKBRgrWP9jeKlJUFx0+i+1jyKTYCgLR878baxPUasbK8cGF4gN?=
 =?us-ascii?Q?huwr4035eJaN1etWj2A3B7+zZmPsXTRrPPEpRg4UJ50J5BCWMDhKVgIQ+MxK?=
 =?us-ascii?Q?3aUy2E+Xt9H+dSH+PtTIhWo/ole9DBZrlsQkpLNXHY9egQjNwyTOxhesW5zR?=
 =?us-ascii?Q?E0VTEn5hyFY6qGXnt6Ux9VVv/AobHCqooqWNeC4VUL1AppwEDrRkxdGNZGOb?=
 =?us-ascii?Q?tuVn3/upEdUuiSHGDJcQNyD2VwItIf2orCaZycKtADznO64PYbHdjfIjuxaV?=
 =?us-ascii?Q?4RMA+GnPCO3km9Dm41H2no/ykTILcTLDxCOAzOSzVRHDg39adM9O+IUQacuh?=
 =?us-ascii?Q?s02KBPR/JPVNiLVJsGCfdbRkdpBEF6euV4DFn6B/zv+Ms7TMho7N3sPzoTcL?=
 =?us-ascii?Q?7h+kpvj7Ofpybn+KvPls3jCEXh+pmCyxgy0CNVkXNEwfCjfNf9XEbttSxIoO?=
 =?us-ascii?Q?ShoTTK/yNqTL07MRjb5C1XxsdJTqZv4VgQ1lRrG0GnSV5O7sh3pgCj/xojsw?=
 =?us-ascii?Q?dx2kidWB7vpIqKeby/mpsmo46jHLO3oRwvmp+FyWbhpoxZaivLYsdcW+Ux+T?=
 =?us-ascii?Q?ZJfOAPFZJ/afy1Ty37EJ7O0sXM9VTEIJWhwDhGULybEG/T6jCavatUOCrjD5?=
 =?us-ascii?Q?IOWu1ItDuGSxGo9mlvACAdFEOQiLwuGotgAFBofF5r9tZignH0KFf+0/2MeI?=
 =?us-ascii?Q?J0dzktoObnXLVyiu+9ZAXaUbtEUpCsQIIOcqrGmj13Zkdi+5AcxJ7EcYgdn6?=
 =?us-ascii?Q?CF/W6XaDF+TDiu0kOP/Eh4/GdEF20UEwcOWpHNRY0phkttCRC/hOoTBEPtDW?=
 =?us-ascii?Q?UuapLSBPUz6ouplJu0x2KjjO9f5obQh/KMYN8zEv5xQZ4d3E4wBsMb67IXEp?=
 =?us-ascii?Q?8Scm+wBxS4becA50W8p0miTUVCQEohPW3uQglKZ0?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ab63254-68ee-448b-28e8-08db05c4c633
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2023 08:58:09.9871
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bPtY97npnlEVMMy5D4jq0QWugr+EIgy5HSiua4MWygelQRCXToJUYW4Vjcdo/tmuSx1sn34jhbZxko35kehIIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6475
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Matthew,

> From: Matthew Rosato <mjrosato@linux.ibm.com>
> Sent: Friday, February 3, 2023 12:25 AM
>=20
> After 51cdc8bc120e, we have another deadlock scenario between the
> kvm->lock and the vfio group_lock with two different codepaths acquiring
> the locks in different order.  Specifically in vfio_open_device, vfio
> holds the vfio group_lock when issuing device->ops->open_device but
> some
> drivers (like vfio-ap) need to acquire kvm->lock during their open_device
> routine;  Meanwhile, kvm_vfio_release will acquire the kvm->lock first
> before calling vfio_file_set_kvm which will acquire the vfio group_lock.
>=20
> To resolve this, let's remove the need for the vfio group_lock from the
> kvm_vfio_release codepath.  This is done by introducing a new spinlock to
> protect modifications to the vfio group kvm pointer, and acquiring a kvm
> ref from within vfio while holding this spinlock, with the reference held
> until the last close for the device in question.
>=20
> Fixes: 51cdc8bc120e ("kvm/vfio: Fix potential deadlock on vfio group_lock=
")
> Reported-by: Anthony Krowiak <akrowiak@linux.ibm.com>
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
> Changes from v2:
> * Relocate the new functions back to vfio_main and externalize to call
>   from group (Kevin) since cdev will need this too
> * s/vfio_kvm_*_kvm/vfio_device_*_kvm/ and only pass device as input.
>   Handle new kvm_ref_lock directly inside vfio_device_get_kvm (Alex)
> * Add assert_lockdep_held for dev_set lock (Alex)
> * Internalize error paths for vfio_device_get_kvm_safe and now return
>   void - either device->kvm is set with a ref taken or is NULL (Alex)
> * Other flow suggestions to make the call path cleaner - Thanks! (Alex)
> * Can't pass group->kvm to vfio_device_open, as it references the value
>   outside of new lock.  Pass device->kvm to minimize changes in this
>   fix (Alex, Yi)
> Changes from v1:
> * use spin_lock instead of spin_lock_irqsave (Jason)
> * clear device->kvm_put as part of vfio_kvm_put_kvm (Yi)
> * Re-arrange code to avoid referencing the group contents from within
>   vfio_main (Kevin) which meant moving most of the code in this patch
>   to group.c along with getting/dropping of the dev_set lock
> ---
>  drivers/vfio/group.c     | 32 ++++++++++++++----
>  drivers/vfio/vfio.h      | 14 ++++++++
>  drivers/vfio/vfio_main.c | 70
> ++++++++++++++++++++++++++++++++++++----
>  include/linux/vfio.h     |  2 +-
>  4 files changed, 103 insertions(+), 15 deletions(-)
>=20
> diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
> index bb24b2f0271e..7fed4233ca23 100644
> --- a/drivers/vfio/group.c
> +++ b/drivers/vfio/group.c
> @@ -164,13 +164,23 @@ static int vfio_device_group_open(struct
> vfio_device *device)
>  		goto out_unlock;
>  	}
>=20
> +	mutex_lock(&device->dev_set->lock);
> +
>  	/*
> -	 * Here we pass the KVM pointer with the group under the lock.  If
> the
> -	 * device driver will use it, it must obtain a reference and release it
> -	 * during close_device.
> +	 * Before the first device open, get the KVM pointer currently
> +	 * associated with the group (if there is one) and obtain a reference
> +	 * now that will be held until the open_count reaches 0 again.  Save
> +	 * the pointer in the device for use by drivers.
>  	 */
> -	ret =3D vfio_device_open(device, device->group->iommufd,
> -			       device->group->kvm);
> +	if (device->open_count =3D=3D 0)
> +		vfio_device_get_kvm_safe(device);
> +
> +	ret =3D vfio_device_open(device, device->group->iommufd, device-
> >kvm);
> +
> +	if (device->open_count =3D=3D 0)
> +		vfio_device_put_kvm(device);
> +
> +	mutex_unlock(&device->dev_set->lock);
>=20
>  out_unlock:
>  	mutex_unlock(&device->group->group_lock);
> @@ -180,7 +190,14 @@ static int vfio_device_group_open(struct
> vfio_device *device)
>  void vfio_device_group_close(struct vfio_device *device)
>  {
>  	mutex_lock(&device->group->group_lock);
> +	mutex_lock(&device->dev_set->lock);
> +
>  	vfio_device_close(device, device->group->iommufd);
> +
> +	if (device->open_count =3D=3D 0)
> +		vfio_device_put_kvm(device);
> +
> +	mutex_unlock(&device->dev_set->lock);
>  	mutex_unlock(&device->group->group_lock);
>  }
>=20
> @@ -450,6 +467,7 @@ static struct vfio_group *vfio_group_alloc(struct
> iommu_group *iommu_group,
>=20
>  	refcount_set(&group->drivers, 1);
>  	mutex_init(&group->group_lock);
> +	spin_lock_init(&group->kvm_ref_lock);
>  	INIT_LIST_HEAD(&group->device_list);
>  	mutex_init(&group->device_lock);
>  	group->iommu_group =3D iommu_group;
> @@ -803,9 +821,9 @@ void vfio_file_set_kvm(struct file *file, struct kvm
> *kvm)
>  	if (!vfio_file_is_group(file))
>  		return;
>=20
> -	mutex_lock(&group->group_lock);
> +	spin_lock(&group->kvm_ref_lock);
>  	group->kvm =3D kvm;
> -	mutex_unlock(&group->group_lock);
> +	spin_unlock(&group->kvm_ref_lock);
>  }
>  EXPORT_SYMBOL_GPL(vfio_file_set_kvm);
>=20
> diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> index f8219a438bfb..20d715b0a3a8 100644
> --- a/drivers/vfio/vfio.h
> +++ b/drivers/vfio/vfio.h
> @@ -74,6 +74,7 @@ struct vfio_group {
>  	struct file			*opened_file;
>  	struct blocking_notifier_head	notifier;
>  	struct iommufd_ctx		*iommufd;
> +	spinlock_t			kvm_ref_lock;
>  };
>=20
>  int vfio_device_set_group(struct vfio_device *device,
> @@ -251,4 +252,17 @@ extern bool vfio_noiommu __read_mostly;
>  enum { vfio_noiommu =3D false };
>  #endif
>=20
> +#ifdef CONFIG_HAVE_KVM
> +void vfio_device_get_kvm_safe(struct vfio_device *device);
> +void vfio_device_put_kvm(struct vfio_device *device);
> +#else
> +static inline void vfio_device_get_kvm_safe(struct vfio_device *device)
> +{
> +}
> +
> +static inline void vfio_device_put_kvm(struct vfio_device *device)
> +{
> +}
> +#endif
> +
>  #endif
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 5177bb061b17..4762550e9f42 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -16,6 +16,9 @@
>  #include <linux/fs.h>
>  #include <linux/idr.h>
>  #include <linux/iommu.h>
> +#ifdef CONFIG_HAVE_KVM
> +#include <linux/kvm_host.h>
> +#endif
>  #include <linux/list.h>
>  #include <linux/miscdevice.h>
>  #include <linux/module.h>
> @@ -338,6 +341,62 @@ void vfio_unregister_group_dev(struct vfio_device
> *device)
>  }
>  EXPORT_SYMBOL_GPL(vfio_unregister_group_dev);
>=20
> +#ifdef CONFIG_HAVE_KVM
> +void vfio_device_get_kvm_safe(struct vfio_device *device)
> +{
> +	void (*pfn)(struct kvm *kvm);
> +	bool (*fn)(struct kvm *kvm);
> +	bool ret;
> +
> +	lockdep_assert_held(&device->dev_set->lock);
> +
> +	spin_lock(&device->group->kvm_ref_lock);
> +	if (!device->group->kvm)
> +		goto unlock;
> +
> +	pfn =3D symbol_get(kvm_put_kvm);
> +	if (WARN_ON(!pfn))
> +		goto unlock;
> +
> +	fn =3D symbol_get(kvm_get_kvm_safe);
> +	if (WARN_ON(!fn)) {
> +		symbol_put(kvm_put_kvm);
> +		goto unlock;
> +	}
> +
> +	ret =3D fn(device->group->kvm);
> +	symbol_put(kvm_get_kvm_safe);
> +	if (!ret) {
> +		symbol_put(kvm_put_kvm);
> +		goto unlock;
> +	}
> +
> +	device->put_kvm =3D pfn;
> +	device->kvm =3D device->group->kvm;
> +
> +unlock:
> +	spin_unlock(&device->group->kvm_ref_lock);
> +}
> +
> +void vfio_device_put_kvm(struct vfio_device *device)
> +{
> +	lockdep_assert_held(&device->dev_set->lock);
> +
> +	if (!device->kvm)
> +		return;
> +
> +	if (WARN_ON(!device->put_kvm))
> +		goto clear;
> +
> +	device->put_kvm(device->kvm);
> +	device->put_kvm =3D NULL;
> +	symbol_put(kvm_put_kvm);
> +
> +clear:
> +	device->kvm =3D NULL;
> +}
> +#endif
> +
>  /* true if the vfio_device has open_device() called but not close_device=
()
> */
>  static bool vfio_assert_device_open(struct vfio_device *device)
>  {
> @@ -361,7 +420,6 @@ static int vfio_device_first_open(struct vfio_device
> *device,
>  	if (ret)
>  		goto err_module_put;
>=20
> -	device->kvm =3D kvm;

Since you've deleted the only usage of kvm pointer in this function, I
guess you can remove the kvm parameter from vfio_device_open()
and vfio_device_first_open(). :-) if it makes this patch too big, may
just have another patch to do it.

Regards,
Yi Liu
>  	if (device->ops->open_device) {
>  		ret =3D device->ops->open_device(device);
>  		if (ret)
> @@ -370,7 +428,6 @@ static int vfio_device_first_open(struct vfio_device
> *device,
>  	return 0;
>=20
>  err_unuse_iommu:
> -	device->kvm =3D NULL;
>  	if (iommufd)
>  		vfio_iommufd_unbind(device);
>  	else
> @@ -387,7 +444,6 @@ static void vfio_device_last_close(struct vfio_device
> *device,
>=20
>  	if (device->ops->close_device)
>  		device->ops->close_device(device);
> -	device->kvm =3D NULL;
>  	if (iommufd)
>  		vfio_iommufd_unbind(device);
>  	else
> @@ -400,14 +456,14 @@ int vfio_device_open(struct vfio_device *device,
>  {
>  	int ret =3D 0;
>=20
> -	mutex_lock(&device->dev_set->lock);
> +	lockdep_assert_held(&device->dev_set->lock);
> +
>  	device->open_count++;
>  	if (device->open_count =3D=3D 1) {
>  		ret =3D vfio_device_first_open(device, iommufd, kvm);
>  		if (ret)
>  			device->open_count--;
>  	}
> -	mutex_unlock(&device->dev_set->lock);
>=20
>  	return ret;
>  }
> @@ -415,12 +471,12 @@ int vfio_device_open(struct vfio_device *device,
>  void vfio_device_close(struct vfio_device *device,
>  		       struct iommufd_ctx *iommufd)
>  {
> -	mutex_lock(&device->dev_set->lock);
> +	lockdep_assert_held(&device->dev_set->lock);
> +
>  	vfio_assert_device_open(device);
>  	if (device->open_count =3D=3D 1)
>  		vfio_device_last_close(device, iommufd);
>  	device->open_count--;
> -	mutex_unlock(&device->dev_set->lock);
>  }
>=20
>  /*
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 35be78e9ae57..87ff862ff555 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -46,7 +46,6 @@ struct vfio_device {
>  	struct vfio_device_set *dev_set;
>  	struct list_head dev_set_list;
>  	unsigned int migration_flags;
> -	/* Driver must reference the kvm during open_device or never
> touch it */
>  	struct kvm *kvm;
>=20
>  	/* Members below here are private, not for driver use */
> @@ -58,6 +57,7 @@ struct vfio_device {
>  	struct list_head group_next;
>  	struct list_head iommu_entry;
>  	struct iommufd_access *iommufd_access;
> +	void (*put_kvm)(struct kvm *kvm);
>  #if IS_ENABLED(CONFIG_IOMMUFD)
>  	struct iommufd_device *iommufd_device;
>  	struct iommufd_ctx *iommufd_ictx;
> --
> 2.39.1

