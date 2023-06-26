Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9B6973D9DD
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 10:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbjFZIej (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 04:34:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbjFZIeg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 04:34:36 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00D05DA;
        Mon, 26 Jun 2023 01:34:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687768475; x=1719304475;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3O389o7/J5Sgkoh+UxJFUyw4Y3s6OJTD9CGqcOrWbGQ=;
  b=U/Meeabxb/UnT36ULQ6ZWntws35V9HzWwq8wtKSbVNgHWu7HAxgI/vce
   QtNyvWeo3vJHbwwudgcF5sjGi1G0f2kfKrJwimakNK1EkJXPcsW3TzJ0c
   JHF9ivO9erNk8npQLmHPiHl1NqulmQqgRD0c1cJqc12U+ojcvz2ajcoiX
   pjFipQGf1ZebefzADRt3shFS5LW1+i9/OBI0jVRw1vwqHzAfJ1QKwWmpk
   64JOttWLNRM152qM2y03ARxwnlLEv8/ByrZlYmSKmeV1MsmObkFbjVlb6
   LmXG26HqYm+XstSGKlCT5RDUBOtnbiWaCXjKXMn4qFd2qe0JBxQZeMkJz
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10752"; a="361253691"
X-IronPort-AV: E=Sophos;i="6.01,159,1684825200"; 
   d="scan'208";a="361253691"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2023 01:34:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10752"; a="962695507"
X-IronPort-AV: E=Sophos;i="6.01,159,1684825200"; 
   d="scan'208";a="962695507"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga006.fm.intel.com with ESMTP; 26 Jun 2023 01:34:29 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 26 Jun 2023 01:34:29 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 26 Jun 2023 01:34:29 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.44) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 26 Jun 2023 01:34:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j5uBvkBPBY6FqMDUmQLJaDtYBfAy0eXk+RVbr5R2IHCQ9OHoid2q6197gY4ksGudIQIt9yLaDiLWAEa1Bu3MVhbWuoeT2Cc0vIWauuZoup41JFGKDtDKMhMOgpnPA8CquQV3QkToq5YEvnQmeEoXU96iPQQ/m5xe6U1ydGZR/uXGe0gFc+7AYPSgUQAA9oyK8sebzFiQyH/dSCraAGGBAtlwKFmS3J7KEakTOEQ1RMBwt17obqjaiQvKRYxUrU602tLTxCeU+TkRCiJYrPIUjL4dcPKPEm3Pk0MKIOMu0eZ5INPF1WtdDX1OC5S5vV3IhlSi88L9Hv2yQA4GrgD6tQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lZp7JSMdq4gQNv82frn3rHwhYgEhCTs5aSx76mZmgzc=;
 b=A8aBosHvBtwEvjP7hhj8ubw8Ij6Q1JmDxYP0J2cMmjmC+uXmNG9GPtBqO5z7unpfkTl/SWsOd80w46P9fmtKY45CkT+3T44/Uo0qH5XME5DTbAIbC2tN9Zf+gXnLstAaAkVeat9x1TIQMdhc+J51W+i/6iDNcTe8RfThzrBRZBbg33YKLo/fqProahQLdfuEvhiEjIxUmogTZGTkfLbdqLQYba8dn91ddNO+yx/3nlTXA2hV/Yg/nJ07w1hINHp9e6OL1cZm04VFC8Ei52tv/TLkK8D57WIeZec9xmpSsfubzuXpVEXxe97tEjkqd0BJg5wG/L9EqVth37qW4jkX4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by SJ0PR11MB8294.namprd11.prod.outlook.com (2603:10b6:a03:478::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Mon, 26 Jun
 2023 08:34:26 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e7db:878:dfab:826d]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e7db:878:dfab:826d%3]) with mapi id 15.20.6521.023; Mon, 26 Jun 2023
 08:34:26 +0000
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
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        "clegoate@redhat.com" <clegoate@redhat.com>
Subject: RE: [PATCH v12 18/24] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Thread-Topic: [PATCH v12 18/24] vfio: Add VFIO_DEVICE_BIND_IOMMUFD
Thread-Index: AQHZlUw0PINbjPidUkeXtdGCTAzTl6+YsS6AgAQ157A=
Date:   Mon, 26 Jun 2023 08:34:26 +0000
Message-ID: <DS0PR11MB752904E31251E05619A442B9C326A@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230602121653.80017-1-yi.l.liu@intel.com>
 <20230602121653.80017-19-yi.l.liu@intel.com> <ZJXFEbmY7BOW6QIe@nvidia.com>
In-Reply-To: <ZJXFEbmY7BOW6QIe@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|SJ0PR11MB8294:EE_
x-ms-office365-filtering-correlation-id: 103afde9-624a-43d7-0cb5-08db762026a1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ySN7bf4CpTF9nD65DyXLEYZj9hoVO14yi9S8QRLsRlwjE55Gnpa/dCzR0Qq6Ify+K+Ll/BCQNT9elTlHrQmPyQMS2u0+rPNEW/s33PNzcF+wol4iaBpK/sDBeiX5S0wBcVKt+NOzYWoHV/mWKJ8R2ZLd68V8XO+KLueV+s52L6r1AV64dZij0/EwIcELCuPeXE912HOKk8zupRbJ20QYu7gS/gxbOrKKslLZWiyLDHA5aC7Zrd1mqgoJgx9mz49lS6kRdXnaeRUS5JeucIa0sOFrwBsOtOuriLJzaoza2xBdGaygW+aI5vcwdXUdnZ/+cc62S9CWVtc+Q6QI4SN92TdA6W6X4g0c/HnEnOjU8fWuJ9a+MgOI1VD6ifBgCS00a+uqLoXZC6J2hvtDz8m4GgrBWNGa6S59HD5OV+m6a/bmiQW4mwf54ez5StdaCCPu94oTNorActlnUuzmb0++LFA2uT6lkJtNagkkP/qX9wBQhazsvbkbbYRfjaHF1QXuVwaqs843LnimqAd0mDG5xS1en4x3otFZNaWYw2KMFntDEGH4ELtO6cX4poBIYu2qbPYe1K7FnKInyEIWSBXjWOFA5PUR0mE8+UE1+hY3sag=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(376002)(39860400002)(396003)(136003)(366004)(451199021)(478600001)(54906003)(7696005)(71200400001)(83380400001)(26005)(186003)(9686003)(6506007)(4744005)(66446008)(2906002)(5660300002)(7416002)(52536014)(33656002)(38100700002)(122000001)(76116006)(4326008)(66946007)(55016003)(82960400001)(316002)(86362001)(8936002)(8676002)(41300700001)(6916009)(38070700005)(66476007)(66556008)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2WV+BXyVP8q7rIISTfsvvv9VB/Dk3RfzRflDe2enATG4OmEkpcoFFqAZ9EnR?=
 =?us-ascii?Q?6qJQnSlMqGe6dHeNCWaD3sXqBU9czV6zGWPZiXUNpMhsNuZcENAJHpwOl4gB?=
 =?us-ascii?Q?9ohclPiE8TM7FQgjU8dx54N/Tvtyxn2QS80nBhYcTXb/nK85T7yrfQwirWBp?=
 =?us-ascii?Q?DqVBy+8ByfsUHTtWj19tSbrJMDjmzdaLXFgqt6xpDilSU8mk6vaCeCFxYs5R?=
 =?us-ascii?Q?bX0JYbD285Xw7yflWwsX16StQFOsSFuf0fvDHpr2CNpCqXSJXOBjTK2FebUX?=
 =?us-ascii?Q?DcO4fVU+B4D8Bu7yx1nlhxKQS4ZgKId9mkq7YZ8+/4y6O4tbEeDRNFfjlDaX?=
 =?us-ascii?Q?QSdgSC6uCYmhJmmTtywQsRnEpMmTU7JOqSTTHqJnKMRFjlaIsEBnqVD0Rm5Y?=
 =?us-ascii?Q?HciYZQ42clHs+iy3iQr+61y76JWorHmhPHhIdHh5wAFaLvlOY+ZGiVzqCHGp?=
 =?us-ascii?Q?sQEF2ij8ffQ1BGN8IoWUQDcjw84M5TzBK2uK7Li9eo/Y/CU2EH4EJ77FZZ9y?=
 =?us-ascii?Q?qUEySQCnuBw/I6Z4ipiWULvGYuw00DirLVFGnnUCylr13pXRyagh0Kq7vK1h?=
 =?us-ascii?Q?WKEfIu66cB6JAQxJtdFtYWAdfbAzeUzmbRC7sInisOgDhimE6Uco5cxnl4ji?=
 =?us-ascii?Q?MKrebk8Pf1/p+mHgtJh2QutGdDEztisVBApg1/VUujHm5CiegnHDZym8651s?=
 =?us-ascii?Q?H7xc5rZ3vFe+80Cfu3VOB2Nr08oPhR+diOg75akp3n+T8+hmwOP/spTggHIo?=
 =?us-ascii?Q?gE+xQNLWRA/6/OIGmGMJZagzX9eeIEbcOSRjtzR0RiLhBtM43fAX4BTVmPFY?=
 =?us-ascii?Q?mc2pmUucza20JWAdpySHSJZ1kgWif5vInh64IO8XDgMAefgDY88ozYqiv5QO?=
 =?us-ascii?Q?81HvpVoMjSYK8YuQSTP/tF3aJxZCAjY45+NhTDCMK8GqyU9T8p/iIBS37It6?=
 =?us-ascii?Q?24bsu10DaOf3fPr4SjrF1PN3zR/CbqIxseU9n05rR+HpkYPeUxU6xJ9MiyH1?=
 =?us-ascii?Q?+6WchWCJx9o/q7ZwPjFF+hrrkKnCgTayuqF6tJZ8XFknFl9zeZXti2EZEA+W?=
 =?us-ascii?Q?O3xFLGXFZ0CjGHTL3i2NQ7aL5REsgLPawseie6wXU6pKyRmpJQ5HGoqaZ1Ge?=
 =?us-ascii?Q?48T1at5gIxrkKzStj6br8UE6a1Q2r4l9LmmG8KHc63U+oS8Q7tiDyuGFDFKl?=
 =?us-ascii?Q?KHZCYb0lPeQ+NfnhWAU5zKeKY9cIGIIEzOLVHMgxY9r1uEYRSDmiGk7KJlFZ?=
 =?us-ascii?Q?mP8j+/Hwpqd/aKLedIHys3Jbl+zb/jEPcRbr9l8F8X5qqWg7Yf2KZ4BiSbKa?=
 =?us-ascii?Q?LsSYMF7QrnVPGt/VUWGz8YlNOiFzt8pEg/N9Wo8bpTNkb7Nfl5XhQZ0lQPiD?=
 =?us-ascii?Q?5w1nlc5j3q4xIbWMtPB12YKxk7sh858+yVQCfCjn4V9ms7Y0N3VSD2t/U0I5?=
 =?us-ascii?Q?kGottRrFmqpze3+s1ccEDK7uqiJnTVCS/BtZxCToa/Agn+T+oqkuCBsbz9Fs?=
 =?us-ascii?Q?qLR57qTIY7vSv7gYB43botCFXUwknJMEST0ckTiNo17BdtZHBxfDmCjaLKLA?=
 =?us-ascii?Q?8EOVg0KIcJsu3VfGVblYZU8MGHLrDIKcaB6i2t53?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 103afde9-624a-43d7-0cb5-08db762026a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2023 08:34:26.1727
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8/CqBNoBRCTv8azEv1WbHR6SpN4SjighH0ANEXhGZ/eWbwlWNXu99BZjHihQXbGr4JDopCAq/35Su0DMZ0iyMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB8294
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Saturday, June 24, 2023 12:15 AM

> >  }
> >
> > +static void vfio_device_get_kvm_safe(struct vfio_device_file *df)
> > +{
> > +	spin_lock(&df->kvm_ref_lock);
> > +	if (df->kvm)
> > +		_vfio_device_get_kvm_safe(df->device, df->kvm);
> > +	spin_unlock(&df->kvm_ref_lock);
> > +}
>=20
> I'm surprised symbol_get() can be called from a spinlock, but it sure
> looks like it can..
>=20
> Also moving the if kvm is null test into _vfio_device_get_kvm_safe()
> will save a few lines.
>=20
> Also shouldn't be called _vfio_device...

Ah, any suggestion on the naming? How about vfio_device_get_kvm_safe_locked=
()?

Regards,
Yi Liu
