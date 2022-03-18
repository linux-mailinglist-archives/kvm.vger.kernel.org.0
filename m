Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA2344DD707
	for <lists+kvm@lfdr.de>; Fri, 18 Mar 2022 10:23:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234418AbiCRJZO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Mar 2022 05:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231384AbiCRJZN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Mar 2022 05:25:13 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 189AADF4F
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 02:23:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647595435; x=1679131435;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=IYRS6TrajK1LIt/8bv20ubz2+3N4MXge9vLAfyBGAfY=;
  b=FReaLgeOS0/W1kMK/nYV8xNpEvJXzuxKUphCI7hdjcSGKgY2xFfAnwrl
   +v8IomGE+9SL+61lDpL8n3NBK/cdfTJX61EPYZhQEjCI6RrQSEncarKvX
   bz+S+MBB39bNqXVJ6DKllmVQal6AuFERHieR/HjK8RnRZTyNSrEGv3p5L
   yo604epdQOLGl4xJdr6HNvLsG55Aa5Fd9DJPd+jK7Xbo4EohEGiv18g4x
   4HQAbjzQQnmP/aUcFq2Wc7p5e8tbYIh7x9AWZBvPYtwvJAGzpDjdkSMx7
   91b6yA8791ii7L4j79nImBoPJ7RLg8mPDIPz7t8+filDKK5t8Nrdgf1iU
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10289"; a="257288552"
X-IronPort-AV: E=Sophos;i="5.90,191,1643702400"; 
   d="scan'208";a="257288552"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2022 02:23:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,191,1643702400"; 
   d="scan'208";a="541756066"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga007.jf.intel.com with ESMTP; 18 Mar 2022 02:23:54 -0700
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 18 Mar 2022 02:23:53 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21 via Frontend Transport; Fri, 18 Mar 2022 02:23:53 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Fri, 18 Mar 2022 02:23:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fi+DCykkQRaVoarnbZk5ZIptpFGepqRM77OpH3UsZ+j6R3pLnMAP56yA72eQb4xZliCOZnoEo1smcoOG+VOQfOHhNmioxu3NfYaCL/2Esh9DBcwgG/kDR3h9BTF2681Fld1UowIF7Lg6cElIxkcjgzn2PH+izKIyxwcImaHN2XE+UzxZe0SMMCez4PsOWartNZC+BfATkGulYmC3YVwMn/1DCwoQ3JLqPMpwXrn3zB1wU6CSefl4VdLVldIN7uHqoPFpEZf0FNoOxUugkdGmwtRQZNTV4Uos+fN7Y9ap67o9mI2CaGfWIRyKMcFhOjAApWsUaqNwMxT3oSASBHkjwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZjdtZzEbDAbbq3CxqUS9yj5h+4YNTCERPr834LLqZCs=;
 b=m7kfJg0dTfUlyVn75bLfwpDXokWhXL5PWKUZA7aC5bli0vMTfAqjMYJ/96hRptjiLkMdjHicD2C0oaqamueVZe9NpWYpcCeyOM1Dn2wtKDIJd0baR95zB2+GLBf0PPwA80AOWaJj8fq+PBTHfUMaHcKlWkCAOdPGYZsCkpXzHB5ZDrMiBMHmSlkEd4qxcnCVq0pLr23RFRwSvaBus8LvIblQoGzhi1HHdxhfz3DxYaVKAYEH2uFlSi0r462D+3LSz/yNvR8upX+OgbiLaOxqv8AkX75RTdGoK7kRVwhUgOuKv76JW/0m39yYaEaBefMkD0mPEY8I2QGDMuVUatmcOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MWHPR1101MB2335.namprd11.prod.outlook.com (2603:10b6:300:73::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14; Fri, 18 Mar
 2022 09:23:49 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c8aa:b5b2:dc34:e893]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c8aa:b5b2:dc34:e893%8]) with mapi id 15.20.5081.018; Fri, 18 Mar 2022
 09:23:49 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Thanos Makatos <thanos.makatos@nutanix.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        John Levon <john.levon@nutanix.com>,
        "john.g.johnson@oracle.com" <john.g.johnson@oracle.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: RE: iommufd dirty page logging overview
Thread-Topic: iommufd dirty page logging overview
Thread-Index: Adg5jKKwvNkxolKnRPWJ5nYfZVngmwABAPgAAEWHdcA=
Date:   Fri, 18 Mar 2022 09:23:49 +0000
Message-ID: <BN9PR11MB52765646E6837CE3BF5979988C139@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <DM8PR02MB80050C48AF03C8772EB5988F8B119@DM8PR02MB8005.namprd02.prod.outlook.com>
 <20220316235044.GA388745@nvidia.com>
In-Reply-To: <20220316235044.GA388745@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4c77515b-ee17-419f-d6e7-08da08c102da
x-ms-traffictypediagnostic: MWHPR1101MB2335:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <MWHPR1101MB23355F1F0E5F3221CFD780988C139@MWHPR1101MB2335.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wwuokLHAghoezcMiTHStRbmiWFfUCcAagaPxAEJDSUzIFvNmv/QW+ESBeSCbO92N2BrliMl5RzV1KNmNM+2bhZRBKDmzgKmS/JsszcRRlBrlvrjIDNd05kwDdny5qMtsuW/gjCvD/DsRhJYjgwCteRi39OasjU8Jogl+cVKJUrEzKglqevBzUS1IMHkfz1zFZzgIXwx842mseSp/9kDs2eJugZ1gCdkygqq8QMrpQnj/ySsJKc+HQfP/3VPbFqdlLUR10dMhJQV0b8XAICLtqiUOeWo/ek9ebbnnQgXBaO+ghVxtqW6KTJiYXTEehRlvIGIaa4ViLH7g9lGIWIdem9vJv0UMPpbRvRKyv/REeCmv486G+FLBIpktVeAbrJQYvjbiJsxOAbsp7sUbgrMSJT+mNVINBKJS2S2DS/7skSijzpJfad9PKE/yjc1hdtbVyYCUhGFH9Rzp7oi4Anb5K8sllyX4b0wCfqgBTb/aIGd5yBrlBuL86kPKedksBT62TaPg3OPWKHQ8k7sR0gBfLNetyCUh0fJG7wUYACx1Hi/4YoVcJO7pPIEkpqsPzXcNva+VDtqQYzLWaH1/kF+zdp2Q/NlVa8AB7+xykvQjyJrhTjaomI/ZYr9IfZOZhbY94vi16fV66qZPa/Ud8nRmaaQSu8AZdwd8jbr7Ibg7pN6I9NO8qWubwAyTCOAJN08gRmX2xizQCNTji0P/YoqdjVf/vaTjPhQnIWlGsNFBLb0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(82960400001)(122000001)(2906002)(38100700002)(7416002)(5660300002)(71200400001)(8936002)(52536014)(55016003)(110136005)(38070700005)(508600001)(33656002)(316002)(83380400001)(76116006)(186003)(26005)(66946007)(9686003)(7696005)(6506007)(86362001)(54906003)(107886003)(66476007)(4326008)(66446008)(66556008)(8676002)(64756008)(14143004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?NV35C085YfGS/oV6uHnKm6OzEREo4pRAJhbHcqL/SBZ/IQKqeznCKj/M6/ej?=
 =?us-ascii?Q?frGiWJvIIcswX7HiIvVyLfuQuLkexP2LECQG/vWmb1ZQ45epw8D/tBFMcVE7?=
 =?us-ascii?Q?heYqnJPrMwUFyHveVjwZME0JJ7WcigUV/c3pAldm/enYz2SQYd5q0ioiKvsh?=
 =?us-ascii?Q?gle/adp2fezOK1vihBe8VWxm3vZqvw2z3fIbybg7rReM1HkrPSUYCWwfHy3E?=
 =?us-ascii?Q?vecj7pCBaisNYw8QSazZtbTmqTQ1yTWRFqTl3e9hs+tw8F081lH5Li0eyW7Q?=
 =?us-ascii?Q?Wt3BqRqbzHDK34QVeK4r0WamFHDhPWjq1ZJv2Bnw7foxz4Tqd16aafLKaMyJ?=
 =?us-ascii?Q?KMDh+1OsyoAh6+qJHHRyg1FIOfQjKTbvUHkoX6kcKUEHQG+jp2WV8AIsfkql?=
 =?us-ascii?Q?2TMgpS0hQjeVbWr5D9uTV8ToVFY/Dc9pjHCqjt+OLFOS/a5ko1C4pdWNgSjA?=
 =?us-ascii?Q?3COr33Ul1Su5U4OMsEOy1f3cHtem65f8iVZ9nk1cicIqvvzNFq95FyArPE4B?=
 =?us-ascii?Q?yPcAPp6Eks7pLdU6f+JoGTGfjD+WfaR///FI0iRlnewKgq6Ia6sgmhDLqirE?=
 =?us-ascii?Q?WSbzKZg6atrfPO/Kl00fe6Pnl/oiNGaqSJp1dUDvji2bx62L+pHgjUae00zz?=
 =?us-ascii?Q?os/q4T39LiKpQ4hs1+R3BAv+WHIGZbNJ4ttYvca/gV0WdKqh1vQtZTw+nAmN?=
 =?us-ascii?Q?myG6r4Urrl8iIQIIZYe3/LpcDz22FXoix/4tkV2KX2UHb82NnN9guauSGyO0?=
 =?us-ascii?Q?YIQan9qLy7som+eOPhqa4aFlz40gXGncEiVsRMeUJ95oMACfh4xA+1VZbf1+?=
 =?us-ascii?Q?Zk75n9OTI/e4rJaEcwZAFTJkuR0S/2uJOcOFjfSm9MIYc5MBCaKVgpb+Tk9K?=
 =?us-ascii?Q?D468AvYTpLGJ67BveiydaalVXqGaRWy00rVHdGAaYGK2Wl5teQfaZzUBumfv?=
 =?us-ascii?Q?vVXsD4jFzX79+SQO40zBQzMmYJeKdGnQaHevE3IG7DQEOuR+34KU0IQfr2zb?=
 =?us-ascii?Q?11OsqxrdJlSU1uCWFPUflqXps/xBAPFbIp9H2EUg+Q20+1BgVIzxWxZj6h0o?=
 =?us-ascii?Q?jbSKg/gTL6yzReIo/SWKOxvh1LLu9f+cw1h5QWdlUiMjo/Q5sBaWelv3M/mT?=
 =?us-ascii?Q?y0ZvE3zb6uLSXb6+E9nMZClk6n731QEyCH+xOcoGNuUMGBFEazuU6CiUCVmZ?=
 =?us-ascii?Q?5oS7VM+YSYmi29P3o/U+HJp7MktYK5xvEUQcHLfGclmIT+v8RhV2BHML7ul3?=
 =?us-ascii?Q?GdX68LoILQgfXlicgATXrNc71WQR9qeg49h5XaxMD8mr9k/I9IVy0qZaSDAK?=
 =?us-ascii?Q?+CICzWHajvBI74en6gLIJL0xHEwEEw4Ib0O1jQ2bx48hKoYoFC8P0JTPanoj?=
 =?us-ascii?Q?WEHfB3qY/CbTclxBQRGO7zt5Y4w9E6hKx9J1nf9NL78bjbrA73MYVcXAtdLi?=
 =?us-ascii?Q?GkIovgqumnbr+4ViNQV0UwDtI9aeyjWc?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c77515b-ee17-419f-d6e7-08da08c102da
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Mar 2022 09:23:49.5172
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: M5tCtH+17S8JUWWaSfj6v6Ma0w1wncZUBW6Czg/jEprtdvZpinFkpI/HJjZ8LCjWS0QKIizjcoCH67Uv1CDruw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2335
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, March 17, 2022 7:51 AM
>=20
> > there a rough idea of how the new dirty page logging will look like?
> > Is this already explained in the email threads an I missed it?
>=20
> I'm hoping to get something to show in the next few weeks, but what
> I've talked about previously is to have two things:
>=20
> 1) Control and reporting of dirty tracking via the system IOMMU
>    through the iommu_domain interface exposed by iommufd
>=20
> 2) Control and reporting of dirty tracking via a VFIO migration
>    capable device's internal tracking through a VFIO_DEVICE_FEATURE
>    interface similar to the v2 migration interface
>=20
> The two APIs would be semantically very similar but target different
> HW blocks. Userspace would be in charge to decide which dirty tracker
> to use and how to configure it.
>=20

for the 2nd option I suppose userspace is expected to retrieve
dirty bits via VFIO_DEVICE_FEATURE before every iommufd=20
unmap operation in precopy phase, just like why we need return
the dirty bitmap to userspace in iommufd unmap interface in
the 1st option. Correct?

Is there any value of having iommufd pull dirty bitmap from
vfio driver then the userspace can just stick to a unified
iommufd interface for dirty pages no matter they are tracked
by system IOMMU or device IP? Sorry if this has been discussed
in previous threads which I haven't fully checked.

Thanks
Kevin
