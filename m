Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8CFC75A472
	for <lists+kvm@lfdr.de>; Thu, 20 Jul 2023 04:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbjGTCgY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jul 2023 22:36:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjGTCgX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jul 2023 22:36:23 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 415DF1FE2;
        Wed, 19 Jul 2023 19:36:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689820582; x=1721356582;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=BJmv01zHm8SYwrVVzTaFgqAC6SafLqd9n1YN+pmm25A=;
  b=TyUtATo6Hw1GicY3uH7EtsddjJUsZ/Gh0ljfhD09degK4vJwQp795kDF
   WYpz80u9qJt/KRhd2LHjIsuOut6LyS0+UbO+Q6GGRCC6J1e6/yAWkesy5
   R4yosCzBAL+kCqOWtWJ/v1Ugi7Wi9hhdwMNYgF8Le72CyTKE1o8Pgq3eh
   3QjA9aUx3Xp5VGA2Dt56IZcfRqEeyBrbByOakIGM+jB8wS00UphtqUqhW
   TzK9oqJo54sphTxm7sngRI0YXftPmHdlskmAz0eGdt3eN7oGYfGcXg6ik
   R7AhCB19hwvrQaq/MkZrsf0j2sAA0pVZuLcVrdg1+2gWY5qNBprwxf9m6
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10776"; a="351483113"
X-IronPort-AV: E=Sophos;i="6.01,216,1684825200"; 
   d="scan'208";a="351483113"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2023 19:36:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10776"; a="674528779"
X-IronPort-AV: E=Sophos;i="6.01,216,1684825200"; 
   d="scan'208";a="674528779"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga003.jf.intel.com with ESMTP; 19 Jul 2023 19:36:21 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Wed, 19 Jul 2023 19:36:21 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Wed, 19 Jul 2023 19:36:21 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Wed, 19 Jul 2023 19:36:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SuRxQmtefiHNgYaEfF/aoV+NcwumukyTLoz4rMpRhY6pFM8D50qnmT71iqHtDdOIB5rGb0iY8wgD4v34+hsU/VbVYjiL+iIHzaZ+kDKCnlMjZ7rHCjqUUvqIsF3YnSOe90hT+9W39558dF/4mS5oph0ns1uStkx8sfOicEo7lf6OwOLAtkuZU4q9yJqjd9Rf9wy5AhWGtu+ukuSEY1xxtTWf9VEz4OY9i+5WEBVqbRxizDiTg2X5nip2SJdRd7z55emBA+0M1Kz8jAbXRSZvxw3K8nG80qyToXz+MbGQKq7an6oGBsFWANJGgpaWcknvvtg7DpTC0T8DjChAPnfO5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PdkzE+vdXZ4zagiBRENQF76KqINoaFG/99bdtqKWRzk=;
 b=aXOqwFPl90+8rZrG71E410VqdVg+ufX3jfS1jadvTXBdyw4zPY5H9lfY5WUy1U4qllNlzdTh5sRyhYT20km0VWQABSQUrX6/1tMG+Gu0QK0fIyeHLlVck0ILmMmlFC28ufquO5EIBooSuvbTxOdNr8KPLXnj0/VLYc+FF5DdPYgSua29CeZnxrTaS6M6J+DmN5JopNOtLXTzVzfrf75oQNW2a8O13b644wLopng6OP7gytuvV45NNzQJCPSDjVcNraQujjzV0fsRVxVdJGYcfCWLcEEx5dOu7j1Ebskfr4LwWlF7pzLwSSZ0ndv6uS5KJCSSjtx1TqIBdrUSjqthKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SA1PR11MB6712.namprd11.prod.outlook.com (2603:10b6:806:25c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.33; Thu, 20 Jul
 2023 02:36:18 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::137b:ec82:a88c:8159]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::137b:ec82:a88c:8159%4]) with mapi id 15.20.6609.024; Thu, 20 Jul 2023
 02:36:17 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Bradescu, Roxana" <roxabee@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3 2/2] kvm/vfio: avoid bouncing the mutex when adding and
 deleting groups
Thread-Topic: [PATCH v3 2/2] kvm/vfio: avoid bouncing the mutex when adding
 and deleting groups
Thread-Index: AQHZtqT6WmtjXEfJ/0GeKcImZTi8I6/AlmDwgAAL0ICAAVYmUA==
Date:   Thu, 20 Jul 2023 02:36:16 +0000
Message-ID: <BN9PR11MB52763F0990CD23DB63AC36578C3EA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230714224538.404793-1-dmitry.torokhov@gmail.com>
 <20230714224538.404793-2-dmitry.torokhov@gmail.com>
 <BN9PR11MB5276BCE644231C440053AA118C39A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZLd+X7Zcnlq52Tp+@google.com>
In-Reply-To: <ZLd+X7Zcnlq52Tp+@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SA1PR11MB6712:EE_
x-ms-office365-filtering-correlation-id: ee566edc-de9a-473d-aeb6-08db88ca17da
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KumYXwd0fTQVU4lwdnR4APkgmYnJ8d2rEypKa9F6KnA8AWfFTmXRXZ2vfHX365syaVuL8+P2zclwYW0ubD19lrkrHTQ1Yl9IQcG5CCtUqwtoT3Do/1yas9iACrCyKeMke6p4841Ky7pyxLCpBMMe9nOtOlVPhvFNPMwvt+iqMwlLvRtnymOLelSWhqP1tTBjrpaNUypoFvmHSMtOqh5KtJwB4821Yby4BtjYF2g7o0b97fHtvlMJCVqwEsDtlJyav7j/rZzosPEZMNkTayJycJmAeCeT0RSZC8fC103r7hGX2fOLGhTxK3ZfFNw1dpFIAnwMuOGY6OSEq7LMSD4lJOWVai3FWz2VCwABdzggh8ZS8RapXP3KTxpGr3bt+JENfvUf3GEHLGLvt10dDEGdDnrTbi/I8KWSOuADSieQxxEUvbltXdIB25gagaRWhsiXXKy+1pWX8dXA1MolN38Ji8akPSt2ktfm3G/k9oGfmNtM3aDhnDwPKJXqJUFPQT9oW0UuvMLDzxnX79fZIHrNlvUr30lyXaeVhTMdKdAt8vtPTE1bTVs95sXBEh4dZhAf9HMGrSCtH39VWpRYhQMzKF9C67qGvf7UmcUow8ILvBulvOJbfMmJV1uBZi80n4E5
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(396003)(376002)(366004)(39860400002)(451199021)(64756008)(66556008)(6916009)(66446008)(83380400001)(9686003)(316002)(478600001)(82960400001)(4326008)(7696005)(55016003)(66946007)(54906003)(6506007)(26005)(186003)(76116006)(71200400001)(2906002)(33656002)(38070700005)(86362001)(41300700001)(66476007)(5660300002)(52536014)(38100700002)(122000001)(8676002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?+yzhI5NskqEL0X/n/S9C+rwjgDNLN5APOUefTVTw2HJUaVCxLJotIdyjMhDZ?=
 =?us-ascii?Q?sxMWoQ5ceNlNGRNXmo8MjHb9zvcCzh7axmWkQvFBp5xm0QszdNqRQL2BOxSw?=
 =?us-ascii?Q?kV13mDl4PGdsDhGRrmR4/5PBZNmVCxtTzTy9JN3jIhFdF0hmKvqdkq+ro7ng?=
 =?us-ascii?Q?QJwo5EgvU7LG06YNPhb6Z0wp8pRt993+e+XSjtjXuvLve6OmdxiJ35azENuI?=
 =?us-ascii?Q?ZdwFc7JunyD1AY3xjulvR13XJRtQc2QMbQaf72BzKvgHIuDUaelolZ5JnyPH?=
 =?us-ascii?Q?MRuvikMZ1Z8MZiCvy7XXJvOtDOyqaMXLmeh4GnreY/St2nz624vGzVj9KOWF?=
 =?us-ascii?Q?9q4kpPVPlFxOZhzisuefzow/O2LShCWzElcHJ7iRcxnoZ9Yd+/VLVs5dITto?=
 =?us-ascii?Q?JXBtU3Ca2uQjrw/duug1iPLHlPW3clPWKZsxBygMYwr/lcMTdlu9CLf76Fu7?=
 =?us-ascii?Q?v3vEAFLvWN5dwL+avwO3NGmHaL3NSE6Rx9srqYEY202WVmw7BsXqFbuajgeI?=
 =?us-ascii?Q?7RocsJufcRi3aKXoBQgW6s304Quap1VPlgQ9miYc4vngy9LHeUeKpqR7FdC0?=
 =?us-ascii?Q?57cVYZpyxWQhQYNmAthvIib9H52iJbnHe/nzciSPN+l9nCLF8aA+3uvciDsu?=
 =?us-ascii?Q?v7G3WW98xeZ8+ui9IF+uE/ijX2AZEKopdiBDW7FXuDTd/PVGE0hSLyjGSay1?=
 =?us-ascii?Q?wYCOkqeozkMIN0LNKNLeD4a+SmBgwz57EVs9vIA2qEFp1WB9o0O8d1zPDjSu?=
 =?us-ascii?Q?t1ds6jMRl8NOBc4cu0yTExDgnRaCgqNm9+cXd7mW5seDeP0wai51EZtwBHqu?=
 =?us-ascii?Q?scsIw7Fh0l73C+fbWMZli/mbQKmpI8q6lq8AVDofuaMzyGxfffONQd3VcpLs?=
 =?us-ascii?Q?p04X0LjXPEachN25sACgs0ZqlUWEpGnvLIwk/Yono+ncXQiWsiHxlwU7frxS?=
 =?us-ascii?Q?SIw/Sg/gGEWZ22nAvjM+7Y3rdaoMAuLXAqc7wUB616kxHeQlw37rzVq9yb7e?=
 =?us-ascii?Q?ZyEHsQ5WnVl2iAruXscIgn8btlf0RT+uUjkEDNEAGseRmb64d0kwHUYIerKq?=
 =?us-ascii?Q?Bl20KpLut/LlDhsPG0/IHni5AvIJuYBvUrHdgedPD/7EClMtJDPpdCYF9LB9?=
 =?us-ascii?Q?7VzWk7kkeHu5ITfcYfcoTdfVdRyY0pBfv6py1h/paSyn+QXPEJuHcsc8x/xg?=
 =?us-ascii?Q?Um4LUSZxi7iviQtaDfBl1FNw2lw6ehsZnfaxohLdzIc8m91AFEhovKYcK7Ko?=
 =?us-ascii?Q?OgQTiegeAfz6Mw1ViAMDGhWTsmyg7iyunUw2rRKJxt3ZLbBnIz/CuCGhk0q+?=
 =?us-ascii?Q?yuShgFuG9TzGDkG6UVmZe/VanmeC56WViTXNW5CJHgkSFMj46vr5+2UDC/+1?=
 =?us-ascii?Q?Xv/6RZNFBtmDQz/XCS0hSQ1H7XZkE4Lds14UKBHEUvhG+LKNPpreh+5FCAGg?=
 =?us-ascii?Q?y1kYlaFKRa74Lo3ESaooe7FWg6cyTnTlm9TyjNmbFYJ1zbzWoQ9UZD4VGCbp?=
 =?us-ascii?Q?5TInFXMrCUuKSHJk5OqC6Yszser8/wZJHNEiL7trRdxRFHbsjtlo/rdoKBof?=
 =?us-ascii?Q?S+FGa9RyIRtG8QW+JOADyoWwkia5EaZ9UaSgV5C8?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee566edc-de9a-473d-aeb6-08db88ca17da
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jul 2023 02:36:16.7983
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b4h5EQNrKK8tBQC1NPQj3SmHg3e849Dj+ro0nnbb03yoD2m00o4J2alCL+X337USJSM6hMs4jNZYr5CUXmKQ9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6712
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Sent: Wednesday, July 19, 2023 2:11 PM
>=20
> On Wed, Jul 19, 2023 at 05:32:27AM +0000, Tian, Kevin wrote:
> > > From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> > > Sent: Saturday, July 15, 2023 6:46 AM
> > >
> > > @@ -165,30 +161,26 @@ static int kvm_vfio_group_add(struct
> kvm_device
> > > *dev, unsigned int fd)
> > >  	list_for_each_entry(kvg, &kv->group_list, node) {
> > >  		if (kvg->file =3D=3D filp) {
> > >  			ret =3D -EEXIST;
> > > -			goto err_unlock;
> > > +			goto out_unlock;
> > >  		}
> > >  	}
> > >
> > >  	kvg =3D kzalloc(sizeof(*kvg), GFP_KERNEL_ACCOUNT);
> > >  	if (!kvg) {
> > >  		ret =3D -ENOMEM;
> > > -		goto err_unlock;
> > > +		goto out_unlock;
> > >  	}
> > >
> > > -	kvg->file =3D filp;
> > > +	kvg->file =3D get_file(filp);
> >
> > Why is another reference required here?
>=20
> Because the function now has a single exit point and the original
> reference is dropped unconditionally on exit. It looks cleaner than
> checking for non-zero "ret" and deciding whether the reference should be
> dropped or kept.
>=20

A comment is appreciated. otherwise,

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
