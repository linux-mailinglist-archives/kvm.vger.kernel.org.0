Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72B4C6B33FF
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 03:08:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbjCJCIb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Mar 2023 21:08:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjCJCI2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Mar 2023 21:08:28 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4754DF34DB;
        Thu,  9 Mar 2023 18:08:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678414106; x=1709950106;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GCwAm5wmg6Vay/DMen71momYFINGfzlboKjujp/4bvM=;
  b=V+FRzHqbQHg7aZRRAeZ7AC8VmTrvvQ3vUEwoWBPmGh0VyWNDUhWPn7xE
   PeMb+kIqYoEwLBlwO3idhwq8i4dAJuAD0quAJltJHpqSXlQfKU2wWAhrm
   MCRYIhZSMPzWy544XotLBIeWyVXl3j7ymDjCjnHQ9F4ZIUAXE0DAtttzB
   RQ+fagfHOEptGdkS1Z6OH/yckNorNJlPW6i+TxtSuA9neaV5DjXpcNWXm
   wVQ4j7/MUx3oHzmmcVUTHaYpxxk9Wdn0VHsCI8GF+xRxNwmYkeG4OVzIB
   Sb2YfcqNJtZj0zqCL3VAwPCeRR2Fj4H/5YbGMs+loZ1bnkNQWlTXLEd1a
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="422892707"
X-IronPort-AV: E=Sophos;i="5.98,248,1673942400"; 
   d="scan'208";a="422892707"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2023 18:08:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10644"; a="746538280"
X-IronPort-AV: E=Sophos;i="5.98,248,1673942400"; 
   d="scan'208";a="746538280"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 09 Mar 2023 18:08:23 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 9 Mar 2023 18:08:23 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Thu, 9 Mar 2023 18:08:23 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.108)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Thu, 9 Mar 2023 18:08:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e04IaThj7+CYreN72BFXZKCzLtg6d1dx+oDoSJ1GEetdR0t6oqVFYbQGCyqepx+Thgnhtws2L7HxAv/gIFtbRGsde1B2Oi0ib2IkFzzOEP9kR76Jsq/o9v/n2uifjWWaJHsCX2oj3wHoRGfoqdUwqFh9gsu71JXZAx0M1RHVWKUZU6agbCoCRbheku5dmnPunIYDdiNYKfZHloKFZXWxK9jpRkzOLvzBdqe8W1/FgRRAxCKW01esfoopZrDbvFRfefRbz+uXz1Y3PV650SDMlm1VqK+2jxZAiB/GqnHsZ2klwhJttzTGDwyehEwpVioeq0hxz8B1RThC0Rpk6NSvWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0IY4kTV4e7D/VdwYeDHjlHdLGOgCw3vqH2qUbaXeNn4=;
 b=Q/nk32/DN8UsKxo51iSknxKF5pGn4vhtPPp7BTHMwo7Wsi/5I5lPLXa45z3fYZvY6Bq8t9RVSllawwFyKPtKLszsWnKlTU1VmE7Mzgq+hlcFCaEBcmQkZl3drCpNl31UsE2h1qTZOJZTQnBKAR4SYFKFF+fO+9x6ifDXvNk2PcnU2NpIs+1P2NK9aNz2XijZvk6LB1TzrrtRBfBdyJJ1rTyEYtTo+YV8bWIjo8W6uUu/qy0ASZBlLBADLTceMgJv42hmnDWRzurp0YGuFOfmDaZSRCtw0JHNe3oPJBBPP8w65dntn9ln6PZrFGXxZ0aZnmsidnUs6e/VG0apW7N2RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DS0PR11MB8136.namprd11.prod.outlook.com (2603:10b6:8:159::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Fri, 10 Mar
 2023 02:08:16 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac%9]) with mapi id 15.20.6178.019; Fri, 10 Mar 2023
 02:08:16 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
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
Subject: RE: [PATCH v1 1/5] iommufd: Create access in
 vfio_iommufd_emulated_bind()
Thread-Topic: [PATCH v1 1/5] iommufd: Create access in
 vfio_iommufd_emulated_bind()
Thread-Index: AQHZUb/VKrDPi02EE0KOkFVtC1WCVq7zRkyA
Date:   Fri, 10 Mar 2023 02:08:15 +0000
Message-ID: <BN9PR11MB52766F9DA462F5C7BC23654F8CBA9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230308131340.459224-1-yi.l.liu@intel.com>
 <20230308131340.459224-2-yi.l.liu@intel.com>
In-Reply-To: <20230308131340.459224-2-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|DS0PR11MB8136:EE_
x-ms-office365-filtering-correlation-id: 59c71b41-4934-4bbc-6265-08db210c4f68
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +tww7JABCvIfkAgi9JuA6+yuQTLFongIffKp8nTyVvvK/JlyK9gfNx4JnqPPwxQHn0qeiu9bwhMkMFxOm9jXpnIj+PqhvKzHlxh/g7HiPKHOjo7cP+tmltbbCOVxPjx31/zWhhB8a7wE5v545hIPrmINVRRp3seQIPYdqZwC7lLybDBw4YBPl67Gf9UWqRqa2qtn9mIlw4HjHs5KEUzpTf0KANqT/35HVrY4UsJurnto/YFIZy/3zS++fkhofABXvHQI7i3zejO/Peu+9cKxzpU8/688fmpB/A4KFt7+TF2OrjnG7jBRycqN5QhGPNGWzz7ydynMCt9e4o9VW1VipjnY9aO+KrKgnnOjGm3VAJfC5nuIG6vN3aPNr/zn0pLLheiUSscfGUYl+lt11KyOpK1Q1GQ74aWyOg2RzCzM+PpuvKbW+1Qs3Brb44KzofEoqzu/at0XmhiX6k6NMocnb2DjZcEAmtX9gOHyZ1dMnpdNM30kdrxJkLr2vgnt29v9xor0GhFztoCG/wdutKZrmHBKKO2+qPXU3uLoVv1k7sNk0lSTsL/N6lm+ZPjrGfW/ejNYbFCcP9AnFinImhH41D0aB3DD/kzXgiD1ILzqPHvzo6hURTz4ClxgEIayJ4LDdeurxY+ZG7zatPEzS1R6vPu6Z7Lczn+9jFwohEAXSOmg4r04yv8YrjyfxNLRXO6fyRAqdC40CdNVxniobToi3w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(376002)(346002)(136003)(39860400002)(396003)(451199018)(82960400001)(83380400001)(33656002)(478600001)(122000001)(55016003)(54906003)(110136005)(38070700005)(316002)(38100700002)(71200400001)(7696005)(6506007)(9686003)(186003)(26005)(5660300002)(52536014)(7416002)(4744005)(64756008)(2906002)(76116006)(66446008)(66476007)(66556008)(41300700001)(8676002)(66946007)(8936002)(4326008)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?lJyb4wB1WZpSfGvOadc+BJ5a6Xrof7nlOYw9OvTKvuguu2Fm88HShUw7Km/f?=
 =?us-ascii?Q?ah8iTnBqQu8O0HgNXc8xtyoJIAnylvTAle6McoPy+lNQCbImgWiqPIi2tr+p?=
 =?us-ascii?Q?LBa2yWESLFjbI1silpDcaUKODMx5PlLd8Qms5r91Hn87FzEkIlJSCT8W2Yi2?=
 =?us-ascii?Q?tHgnVa4feCIYKXw8q/QgbPETiBBzVNhXD2tQSNRQ5D0lamdG9lW4RiO57B3X?=
 =?us-ascii?Q?iRLzvmX4SSVm6HqP/03uAH0/Svb4wOXb/NA0W7JNMwm/w8KUKttF3JUv3YdE?=
 =?us-ascii?Q?Nga9IoVxLM87ElaPVhW9dkDN0U2T8Jk+G46DIPc1k6qYJw4wdIp9W81Dp+o+?=
 =?us-ascii?Q?452zRqPbXmv8csBvp09jd88GcbW5ZaWiFN1iYqZ5hrdGzmE00UnlHJUwzzWi?=
 =?us-ascii?Q?n6aDA/7sbUOkBPgFsZxlc3Wk6sCjIpgBuBO/qDgc5zOLeuW1lxxC8M+AL/11?=
 =?us-ascii?Q?DezPwu3VWLJdGkcnCtFN1f1nkK+nV2Z1IoiXceBLSGKwon3t42DjPURsX4eY?=
 =?us-ascii?Q?acxMi56A2Xhj3lTXotYFlaoEU2Ekk4HFFDEmmLGhMMDd8OtWnbLPGi61Nfon?=
 =?us-ascii?Q?tgvjDpYX/deggnWzIQQDvGfJHZlioPUHWwZeu2PNcgKU9ID9iWjNukh9QTrB?=
 =?us-ascii?Q?WdwLcv/PBMAVTc6NE5As8mZmXAv0p+nDTb9VyYKZ4ifp6vIC72KjK/v+5iPz?=
 =?us-ascii?Q?aWvqgUwpQbscwt3TloWPvOH3hiOQ1650VAKGN5XRMSALWewk8tDVS+AFA5Nv?=
 =?us-ascii?Q?WZAufwYp5N1mn8+i07Y3ujEd2IxwPnFNKLSuY2BGhvnAZwg+8rCJzRxDHBKW?=
 =?us-ascii?Q?T/YMLVYj48JZPL2tuo+TAhaRnMhgFx9U1Tjqw8dJOoBu620G0b6SH3mf0vQw?=
 =?us-ascii?Q?hmGham7uTPJeYfVic3w5cPcT+3tUmYpQoB4hk2/G4Qoor0z5/PFXkFOb+dpb?=
 =?us-ascii?Q?QH1XZhWUqtx0jXVqEK+U4zcxftbi2wUeJDLzXHnbhhK6hP5XSDRj5enEScK+?=
 =?us-ascii?Q?Vy8GV2Ah0vmZMM84pCPSoSyj2sHK57BxeAYgC3axy5RZ6pZkqbVcOb+2sANx?=
 =?us-ascii?Q?CT5SF60QYrDm//DoFiljsypocEA4IyXR7dVOLtkR0q/IpW23U80TbYL73HSp?=
 =?us-ascii?Q?qlatxuaIXWGS6Fd00ANyzuE3Zuz7rYFL7TJcNgoDQ05HSghiUqhybnk/cRD+?=
 =?us-ascii?Q?T6EPszu53XpZ2jDdlzOYBpnKxoFTrQywZtSersboqUZpgeQYXNowUq/zGXpJ?=
 =?us-ascii?Q?c9WNdk8bDNhWJ8AbFWAfFlkYz2rkvKVHNDJszyhwu2fOI/zFs6eJ9aI5qqdy?=
 =?us-ascii?Q?nVFfHpHN6neGVesQWfTkJJehmAZSM12VMbLRAaKV/XWfI+u01+nDblSq7H8O?=
 =?us-ascii?Q?Otev7XPV72CTh31XkccBFht9tGvb8fi0WG9rGdZLbCTp6BqfBN25dTiP7zVR?=
 =?us-ascii?Q?3gtp0i7rOPtG1QgMOT08eK+77xRnNfJhs5lunzrIVNqsCohPKe3WFkPtRPN9?=
 =?us-ascii?Q?n1Zlr/i19zUU10pmlmcKKnQQLrLYU2ydgbkg5syaklEh67k4OCPYvr1mluNN?=
 =?us-ascii?Q?WOqrEHOdlqbWKkBkLIBqApyPhfQexBi+6dSRubl2?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59c71b41-4934-4bbc-6265-08db210c4f68
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2023 02:08:15.7997
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: E2zjjzNxla3iayJNyVmXtEPjwDWsvWcEAauNQXaNV2wkjQh2Rbscmp7OUOxt9V+QH1y3RNUyDpwcTqa6OvGe8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8136
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Wednesday, March 8, 2023 9:14 PM
>
> @@ -449,33 +450,18 @@ iommufd_access_create(struct iommufd_ctx *ictx,
> u32 ioas_id,
>  	access->data =3D data;
>  	access->ops =3D ops;
>=20
> -	obj =3D iommufd_get_object(ictx, ioas_id, IOMMUFD_OBJ_IOAS);
> -	if (IS_ERR(obj)) {
> -		rc =3D PTR_ERR(obj);
> -		goto out_abort;
> -	}
> -	access->ioas =3D container_of(obj, struct iommufd_ioas, obj);
> -	iommufd_ref_to_users(obj);
> -
>  	if (ops->needs_pin_pages)
>  		access->iova_alignment =3D PAGE_SIZE;
>  	else
>  		access->iova_alignment =3D 1;
> -	rc =3D iopt_add_access(&access->ioas->iopt, access);
> -	if (rc)
> -		goto out_put_ioas;
>=20
>  	/* The calling driver is a user until iommufd_access_destroy() */
>  	refcount_inc(&access->obj.users);
> +	mutex_init(&access->ioas_lock);
>  	access->ictx =3D ictx;
>  	iommufd_ctx_get(ictx);

this refcnt get should be moved to the start given next patch
removes the reference in the caller side.
