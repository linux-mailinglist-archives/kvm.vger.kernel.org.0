Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 675F4680CB2
	for <lists+kvm@lfdr.de>; Mon, 30 Jan 2023 13:00:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235718AbjA3L77 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 06:59:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235401AbjA3L7p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 06:59:45 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49A052690
        for <kvm@vger.kernel.org>; Mon, 30 Jan 2023 03:59:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675079950; x=1706615950;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=VgYZxB5qWTAklVLnpBYb8UlwSZR59bpzgw+cmcLu0ks=;
  b=HhsuAIOLUom1tu67jcUoHjDOK8iJXBmbt2wEolVcOm2192iPAxsu3G+z
   IKj9HTyYfPxGCW0t1Y0xaI3N34oshnspoA9hndlxr+960iVs3YyPrwvVf
   vb3LEF0sD/dLI/cGGljSBqpDX6y6P6cAL6simb88mavfVWybEGqbjoWFY
   MqaOeFeIPdgDqBD3T6WP6VcD+2vqMlbdtktTB++0eXABunnom2KQreYQb
   suDqTU+ezjOjjipEKiBai/bRrEHkwVznx/snz3ACS+PeDc3cNbvlXkVUp
   x+k9V5t1lrCBlqbMLz2+ZFO9CP6PZ0ERziM9V5TJTl7GL8WBW4xBoyQTm
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10605"; a="307883733"
X-IronPort-AV: E=Sophos;i="5.97,257,1669104000"; 
   d="scan'208";a="307883733"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2023 03:59:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10605"; a="732673498"
X-IronPort-AV: E=Sophos;i="5.97,257,1669104000"; 
   d="scan'208";a="732673498"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga004.fm.intel.com with ESMTP; 30 Jan 2023 03:59:03 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 30 Jan 2023 03:59:03 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 30 Jan 2023 03:59:03 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.104)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 30 Jan 2023 03:59:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L9tYrgIdgRX3DlbzIrnLBJGV9sfqg/ul/TcJAv8GJwsvcFtszhuasssnkhavQ/VALp1IQS7v/urfuYf2jIZ2OvO8F9zhpwaEbz/iDlPnJojEEPL7fg4+sIlGA9fEQZcTrJj2OPdAx+p8CvbtNR7Zr2jfYLmHRtG4LHOBD4UKWDje0fAfHPFavJkKTNmUuDtfcAuH5tU8MeCoXsFocwH7G/M4e7hsQ2FeAVJ/j4sfarBZnrxcS8VhTXA+FDZTx8kGNjFEPcYL9xxmsG0DN6twROTW1wHOtT7PscIAPQPtNoKsbqPb2h+ZEvewjisy8PwcyOLti5wGNAiWF+jD6FLHCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1z2cgn7wXbDcgYtPE/ysov1HAaqJ+US0u1Vnhw5nZ20=;
 b=bZagd+YT/NQgUyi2qjc0aVKL4MGftPC4WzGt6wiGPic79EKjqTnAXHn3NBVKSJ+ZB2mjYYT1AEBCZC8hC/g09lJnJBB4bY/vE0ASLdJTkRVhe9eqbUQ56qs49MSC/lYDiLscT5d7KPw7VHkdsCbNWOZAK1Zf/MSu2GjsmLhJyJP+wChseQMbg39vwoGtsEnDuZUYTkn9Qxpom1BKKZEXdLa4UfhztE+DcgBM2bMUNskFTs5CKVh989eIeKUA5Z5n3zFP3w0FBvelb42DzrMVBKVWlHrnTChRxDHVL0A9PemWJbuaYgOHSYN5c7cPRhAdOdWkHdZ6Av8K1xll60n+tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by PH7PR11MB7513.namprd11.prod.outlook.com (2603:10b6:510:270::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Mon, 30 Jan
 2023 11:59:01 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3%3]) with mapi id 15.20.6043.036; Mon, 30 Jan 2023
 11:59:00 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>
Subject: RE: [PATCH 10/13] vfio: Make vfio_device_open() exclusive between
 group path and device cdev path
Thread-Topic: [PATCH 10/13] vfio: Make vfio_device_open() exclusive between
 group path and device cdev path
Thread-Index: AQHZKnqawLpQ51DKRkSs/ALC/dgVdq6lg1GAgBFr5LA=
Date:   Mon, 30 Jan 2023 11:59:00 +0000
Message-ID: <DS0PR11MB7529E91906BC8F6FB9A2B1A7C3D39@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230117134942.101112-1-yi.l.liu@intel.com>
 <20230117134942.101112-11-yi.l.liu@intel.com>
 <BN9PR11MB52769CBCA68CD25DAC96B33B8CC49@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB52769CBCA68CD25DAC96B33B8CC49@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|PH7PR11MB7513:EE_
x-ms-office365-filtering-correlation-id: 87408d07-c556-45d2-6e05-08db02b9601b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 81o7PpNP5DpkybcPt49C6gOJNGRfjBuyJA5+uWoKZczxLBvpjfCUsAZkwMb/qohYn67IzLe6BNqRLfLXmwyv7zpTxbP2xWM6KvJEusFyeTyl1MqFGzJVOKXA5Q7bVAY4zvFONkOFJuNtNCdQLyYZr69LPyYHRHhCYB7GoSGdqYoih2R64c3iHntKyYBTOwpXpB+4PQeXXcjaouVGjvmn4b/fuusqfbsF1OHR3VcYhREwwN6tDM6NroKMWB06zRe6b5/CV8HZEzkW0lgORlJV9runv/6qG1bOnYFWdMzg3oaDt2Bg/Dcr92RepNlEMo2cK2kggUG7VbEugcn0qy4lNNCp2aAtBWRdOY0lVdGPA9XC9t/YOS9sYVyP22pE+MWQaZ2uDau8OMSxMnJL2qxq88upBHYkX0uXi3KAvRjdjO5X5mRc5gxt/u4BASnznKz4pPBMSwLTyT6m3JAW0Z5aXJIID+5O7G2cktFPLirrdaFEd/3VkVIG816x/jo1smGKwn892bKIA5i/CMo6FlgtHUPvEK+3k+IHKsb5mAQ9jSXDRSvoV3I2CL+2y7NhPueAcp0WxJRuAcRbGS5/71/b2V3YvZCm4xUUUzvl/8Qn7+VhiJXN4G1ToGHox8Mw5hKh29BtlIe6T2IqeQvNGXlMbGFwg63pRDQasVXnSoIWppQwm/jahkASejXLeNA9VS4WuIxPS2Zz1hW+3VE3ck+G3Sc/XhPHejVgBgfst1CbcHo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(366004)(376002)(396003)(346002)(39860400002)(451199018)(7416002)(83380400001)(38070700005)(86362001)(122000001)(38100700002)(82960400001)(2906002)(7696005)(71200400001)(6506007)(9686003)(26005)(186003)(478600001)(33656002)(55016003)(8676002)(66476007)(66446008)(64756008)(66556008)(52536014)(8936002)(4326008)(41300700001)(76116006)(66946007)(54906003)(5660300002)(110136005)(316002)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?o71e16uq1ZUw+d3DZXpQhcTPsMEW3ww2lEgimcWZQo06rOm17nNsLBmG4wok?=
 =?us-ascii?Q?eaxmmG6RCV/UhUmrfFaujA9CWTUxam6Fk7qVyJ6wtfWszInsbRhNx4vdWLpo?=
 =?us-ascii?Q?8BTXhScXanHVomOBCl0P9q0a4f0vP71twr+5dW6KPozVvupHHKshfgeheRcQ?=
 =?us-ascii?Q?gR/IqDLxZcOvystWvySJo7Y0CgcYP+m9lDiqC4lP6cyeh1tLrRVshG34cdmp?=
 =?us-ascii?Q?/3t077Hb8Ubtb5Lu8Rqu4TCw+CVk1QRWmyjkpUfRXRVeyzAZING7xrsC8yyg?=
 =?us-ascii?Q?Ot2jsX0BFMEk0eMUMxEVQbvN1ASyObdcu/yXc2ZnKjRQelnBsE/KB9kpW0Wj?=
 =?us-ascii?Q?/uK4386XfraG/3U6RkzOzwPcKQLm6EbVOPm1MV4gagFGCeksMtR98zus91iv?=
 =?us-ascii?Q?Zn54yUy8NDFR2fv+OJV8wEKOHJgj94C+aOcbG4kElHc9tNLTkZ9n+o7PBeOj?=
 =?us-ascii?Q?6H3e5hViGWJrTMx62VZBLX96AbilfJ3KwvjZhuY/iIxoDW1Dg3mL8CpbiydO?=
 =?us-ascii?Q?lpa4ozacKQFYI0S7anm+w2VOM5klKlxDzRjuek6puOtsLXoR8NkMlI6U8DKP?=
 =?us-ascii?Q?6WFySCTLZegTL5p9yQXYj7g336etBpZPzSdJJaBr+roN4C54TZcdvUwm0ePt?=
 =?us-ascii?Q?/YvhaTO71LtuuDxZgKB/SdkW5ZOLq/QaeKv3Ih0gEYWa+/uPinUu2K/pF3LE?=
 =?us-ascii?Q?8J7Og+YV2+EcdFT76xKwI+3m/EwKIN8Ji+yaR6HVyPY/1MBxu/Xs69PD7moR?=
 =?us-ascii?Q?1V+rwrlZzgnFFE+xmlZeiav7rjb2QsKuC4blhRBGFWaa7xnQrLe+tzDWiHjS?=
 =?us-ascii?Q?VkoOy4qJIXL+pOTobn8rzL2oaGUqx64Fvwzqlgr379QrUSYVd9xoGzK9VwDS?=
 =?us-ascii?Q?fq0lFivIg5uN1PVNUR7265Mu+Nw5hex9+ia1ziOs0rb5aSZ7LVoKI5MsKhd7?=
 =?us-ascii?Q?RVkbx/Q+7VsnAR6e8NjeHDVfSbwyvLJ1cAd9gwTmzP7GWFVYMpzCtFa2IC1f?=
 =?us-ascii?Q?XS6pRXR3M5OXipEJqQJGTkEA23He1a9jl5YzHwu/PseDa/b+VMyj7QqoMmIV?=
 =?us-ascii?Q?EqV7GtLR1UgGwWbaDago/XpMRj2BoU0mxY4h+Oa1nS0fQikC9xqrE/4kvsSt?=
 =?us-ascii?Q?Kdy0Blo7zIqSREgkGZ7GTNYbqZ/ypWnQuDrXifEP0pK5oFHbsvvWd2NOfvRG?=
 =?us-ascii?Q?dacyICo8snHtTvpPpYTWWvNxAsm9wRA+3AxVY6tNxB4nruoMacpNPxy+YHvY?=
 =?us-ascii?Q?Q/HFZt7krg88K5O9S0OSNgBrymqESO7+gvqkg+hXwaJC0trX9cRK8I8wfRqa?=
 =?us-ascii?Q?Engs3uAyfAmT/jdYPmK6G8GL9KpGXXlEpZb17BwJkaQO1CgJtDu0FEGtfMZ6?=
 =?us-ascii?Q?S/fqFsqMXM2za3AVz6uEJffqZ8W33TPe1qbmiqsRTXlV34O7RESKmFgpjxrL?=
 =?us-ascii?Q?1WhVwZoKqV5+ZQsRUAOVsMRBlFw/vYTELVnhNso0uk020Fen5edbd/its0FA?=
 =?us-ascii?Q?ch/nBHejF4U0INgpXcSDZU//7BPynYan+qWHZfdCFGWMplSINNPTt/aq0r/X?=
 =?us-ascii?Q?K08ZiPknl68Zq3ihX47CnWhgYXmaDmF1iymZhz1F?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87408d07-c556-45d2-6e05-08db02b9601b
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2023 11:59:00.7516
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /gRo6XFOBFhg/L2Lk+9WjLhPS+RqJmPaKB3NowPmdiq49I2NBoiQmIfaoH7P5+S3J9aTTrm2RYV6VZpeLIy1+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7513
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Tian, Kevin <kevin.tian@intel.com>
> Sent: Thursday, January 19, 2023 5:55 PM
>=20
> > From: Liu, Yi L <yi.l.liu@intel.com>
> > Sent: Tuesday, January 17, 2023 9:50 PM
> >
> > @@ -17,7 +17,11 @@ struct vfio_device;
> >  struct vfio_container;
> >
> >  struct vfio_device_file {
> > +	/* static fields, init per allocation */
> >  	struct vfio_device *device;
> > +	bool single_open;
>=20
> I wonder whether the readability is better by renaming this
> to 'cdev', e.g.:
>=20
> 	/*
> 	 * Device cdev path cannot support multiple device open since
> 	 * it doesn't have a secure way for it. So a second device
> 	 * open attempt should be failed if the caller is from a cdev
> 	 * path or the device has already been opened by a cdev path.
> 	 */
> 	if (device->open_count !=3D 0 &&
> 	    (df->cdev || device->single_open))
> 		return -EINVAL;
>=20
> 	/*
> 	 * group path supports multiple device open, while cdev doesn't.
> 	 * So use vfio_device_group_close() for !singel_open case.
> 	 */
> 	if (!df->cdev)
> 		vfio_device_group_close(df);
>=20
> because from device file p.o.v we just want to differentiate cdev
> vs. group interface. With this change we even don't need the
> comment for the last condition check.
>=20
> it's fine to have device->single_open as it's kind of a status bit
> set in the cdev path to prevent more opens on this device.

Ok.=20

Regards,
Yi Liu
