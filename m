Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D89E50339E
	for <lists+kvm@lfdr.de>; Sat, 16 Apr 2022 07:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbiDPBIL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 21:08:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiDPBIJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 21:08:09 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE3D2FA21D
        for <kvm@vger.kernel.org>; Fri, 15 Apr 2022 18:05:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650071135; x=1681607135;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4o2/kh02ysKNGtJiwq1bfkosyFq24Ym/Y3pL5n4Bfc4=;
  b=QyEvVGfC6G5GADdCpk+TgBlFXu7RxnHoJY7Jk/F65qnwatgFxJ13m9dq
   cjT2PQZzppJnbPXF3bQgz7dy7V8A8VpTExMPffk1WUOv4TM0uAj2sQQA7
   MMp7hLgCRtvuVgB5gC88dxGw3uYfS9MU6fg7m6Jbk4UHbI9p3ovGN2coc
   KWOGeZ+9FO6cD3wbwaMJV8xn43pDD8yOGibP4uE8SwX5QITRkS6lgOIUx
   SxpMicMDpAjz+FMFJJPJ4VTcyYUKqfhAdSRoKnYcz+D8wOsG2zi1JG4dy
   6dmHIGt7cKvt2l/TL9b6Og1/xgM/VDdc8bP3Z0x5KsTMAM6WVEaCFWV3u
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10318"; a="243836519"
X-IronPort-AV: E=Sophos;i="5.90,264,1643702400"; 
   d="scan'208";a="243836519"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2022 17:42:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,264,1643702400"; 
   d="scan'208";a="509123540"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga003.jf.intel.com with ESMTP; 15 Apr 2022 17:42:53 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 15 Apr 2022 17:42:53 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Fri, 15 Apr 2022 17:42:53 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.176)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Fri, 15 Apr 2022 17:42:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nFDWqaAILvIbyT07J0cVqVYNAwj/NJtwPZhBi5tBJ7U00HEsCbBl5cfq305VAypApuHkpithiYXEe+Rg/crXpYKspDQMnFOLU5y/TDU0HRISZ/baeqFGMzpG+BGrDWu6oAUDvRfuZYDJ1rpc3TOJG3ujWeScC1Tusq/rx2Iu+jXdhWSr0dnFo4tYLQElJ5Lv3PzM0psCboZ72gxcRPtUx5C9LrNin5ZFkEzABoU78/pupeaCwAuJAKlS3LUVTr6oSto2pp0Y46Sn+MeeCumfEEHbrHs7Yx1Oje8eAE2QLdbhwlN5Wuo2rYTB0UA3exPT3oHdriFYEMZ48GW6t4xkVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4o2/kh02ysKNGtJiwq1bfkosyFq24Ym/Y3pL5n4Bfc4=;
 b=mpxDj62xFPnnKopRVcjy4Jc308sCf39tNipantxWyb2EfTS+uoKc7mVZ4ZSxXMdFlxPOJPRNEnVw4e5vTTTZEv6MbYTUniiByVvWxm+P5rgXf7zyvB0UKWS2YRDowq1kDt+Vs9sS2HWLsBLtAUYH71zhwXJn6FtYlZv98UcwO3Dl3MAOQAk/SfAoaG4Hx4lQczg8VjzeCMflGVkAoRL/s764coV66Va9eEEbXcc4rkFoUmAnvyIX7StPY7ofOq4TKRo4Wok8ty0RMjeVCp2TFyIr26D47ezOYYy59ftHQFdNx7n2+B7XFRHv3hXgYIFFRc7N9RjKPbMFAMn3a5HaFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by MW4PR11MB5892.namprd11.prod.outlook.com (2603:10b6:303:16a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Sat, 16 Apr
 2022 00:42:51 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c4ea:a404:b70b:e54e]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c4ea:a404:b70b:e54e%8]) with mapi id 15.20.5164.020; Sat, 16 Apr 2022
 00:42:50 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: RE: [PATCH 09/10] kvm/vfio: Remove vfio_group from kvm
Thread-Topic: [PATCH 09/10] kvm/vfio: Remove vfio_group from kvm
Thread-Index: AQHYUC/7oxrMq/lk40i2DwOU5MPLw6zwX1UwgAEnfwCAACeJ8A==
Date:   Sat, 16 Apr 2022 00:42:50 +0000
Message-ID: <BN9PR11MB5276894C5E020B8925BB6C238CF19@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
 <9-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
 <BN9PR11MB5276994F15C8A13C33C600118CEE9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220415215604.GN2120790@nvidia.com>
In-Reply-To: <20220415215604.GN2120790@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.401.20
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bf543c20-0590-4658-eebb-08da1f42093c
x-ms-traffictypediagnostic: MW4PR11MB5892:EE_
x-microsoft-antispam-prvs: <MW4PR11MB5892C7C9E33ED10F6CC1B0FE8CF19@MW4PR11MB5892.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lieLHaqaH3HXI75T8TKMy9uPMQ1gL3cYqj5fPvQTauf1yPlzBzHU/DG+s+OKoCQ87jwT/yrFovWFTAJZVF4+m/y+o8hSU6opWwkyaZpDLyVgXchV4gIm3fHAyCpzCQr+0etA/SL9jldSLUV/CXxJu61IoGQe/Es2c6YkgUdC5AVI0hAcZwMCF32ejORaLvkW9VV/M/HE7iUGXGHp/De3T1Xa/Z4sPGHm0WcjuZIcBZ55TSNenDaaszrdlVrdYiA26RWI7F5rRBlH+L6JgeHaSbn2FNEflXxgBYQfr6Pv8kmhTEc5qNzgM+JoVG3o6vT6VWRbOhOBHAcrSzhJtzmGkkGtA23SQjCdguZ1P60gcrguovVmLPJzwYx3C+YJ5C2DfdnLcij0/wE/njTGDuXEz8ZptRxOA3lqBhOJvNZnmbxd1R5ve9ZL6hFRsRl3V6xTXg0EaUfmt0f6nQeNqscAw+v9DQpfcCcoDHLeC6hqTE/ncpHPvUUINZNDwFuLryqJCiSPQmbVTGi/EVWdcoo6F17dFdvxqoHPvTYsruKVYGwbVVhGl3CwYsMKONFfQ0L7rrhlHerYBzPb8HDPfPGq6jRnsXah9glLeU6yj+UwCy+0iWvBu0DOC58QfJCM21i4TsSuuzIttUBLTIzyWq+XVkJ8naB8AG5OksMyZj/RJ8Xe68gj3MViZ7xyGA3ka7E2XkXvZFbHxjM/lS1kpg0vXg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66476007)(66556008)(66946007)(8676002)(66446008)(64756008)(76116006)(2906002)(26005)(38100700002)(9686003)(316002)(33656002)(83380400001)(86362001)(6506007)(107886003)(7696005)(122000001)(4326008)(8936002)(38070700005)(52536014)(6916009)(54906003)(55016003)(71200400001)(82960400001)(186003)(508600001)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?OCa2228y6homEJ7XtIB2rK9IG5NY+CgyUjqnby48tpoz84xwODIXlbbPA+7e?=
 =?us-ascii?Q?lPmbIpyKdmBrVO2cfq455ge9RoXoSaNweImWeqZNYQtAZ8ksGWfWx/zLvPls?=
 =?us-ascii?Q?0ZXNItbDMHEDjdufUYqn7IngfjhQerLM/tNby/gNCQw9DTw/jTguThrDkja/?=
 =?us-ascii?Q?U18hLYUKifkLgvIBkOpZXIEszmD+GtsyDWTFwvUI2MPWXoP3nngWSP5dKg2Z?=
 =?us-ascii?Q?wYUq3rJ/sC9m+Hv39jHka+XFIQyYXnPGaf4OHnoxOZ8ynNLCqfZqFa/nUh+P?=
 =?us-ascii?Q?tEfrp7PWgCLkXPmWlGaWDNVoHaOhXTlHbftoha3TBQmxQgdjUe++fhoNZ7ob?=
 =?us-ascii?Q?kvCvS0erscGwl0fxBq/iIHs0xv/B1pUFcvMUBLMn2Ex+NrqpvleKSHmIz9wV?=
 =?us-ascii?Q?4W/Y15fmS/ASpB3tE7wKrfdSQOAJlXhkff6JlE2ZAnrjCiRy5pjEeFsBzFLN?=
 =?us-ascii?Q?1kEGfT6gbjDfcXEALkLI6rE9lk/YOFofQbQrYuF1+6xtmWdhKl3O2DWgj5gc?=
 =?us-ascii?Q?+/oNta9QHnkOegD9xZAeSXEzCl3vOjBqbpNInKIXYafoQhEneXrJQTHylZyu?=
 =?us-ascii?Q?ZJxX73gqGJgvsozg4QmWOXlY5M55ZPmNo8vHw0UGybEACociu2Sh9vPVSRpF?=
 =?us-ascii?Q?ocW+vlRjT1uK99eZ1nxkhTAQuLfN4DHsB2rrePhUJFC0RkASoJhKgqDHSLHn?=
 =?us-ascii?Q?RU9xUFQ5U+sFlVJLTxFUbhLAmoaIcsvndwzThOwksJvYIklNlUM6XmSxlUhE?=
 =?us-ascii?Q?NvFqTKwKYVY44+yalMUMMCW/zpn6wv4T9XmQiFMRTlzHXcZ6MveVolvp7xdG?=
 =?us-ascii?Q?cR8/fxTm1/O5++6EV92Qaxk+BbYKXKLOcPFBfRVU1GKGmrJ351uYwkCX2srP?=
 =?us-ascii?Q?tp4EfH+zR1VbZdbvZb/4+87JBRqbTQnhhnEOrsVIBiFCX2aq6rzQW1UCrocg?=
 =?us-ascii?Q?Q5SRD/iiLoxtkYiV51Ozf9vlcROxMxKyr0EbHGbhXdUn6t7uTTa53pZMg0tx?=
 =?us-ascii?Q?gOAF59YD3/CTOoH2sUWnIzD1WS9M3uR5gvRQE3yaOHMmLK1aDwSezKrUJ5/M?=
 =?us-ascii?Q?im6pZKOAXE0Qeh6EcDVtzZOLRrs+sIjtHrSglVVVfNeWPAsKi+NgOkY5n+RZ?=
 =?us-ascii?Q?1PfVWtERbGXMFGVnv2cKxjpz6fwlV/1Ejfh2N64eEPGx71LVsZqRUddy8IxV?=
 =?us-ascii?Q?WyAryiL/kIEu5VBSnFf6E/n7xplevnBa7mlrkgJYP2RlkM/1VIgh1AGVlZmp?=
 =?us-ascii?Q?74oVIzrPQqMV/dXLyyBdyMLcMfFY7avosTgNuRZB3DL77tF9Gx0XSshjcaVW?=
 =?us-ascii?Q?sPsHq4vvzgxnAAv6OvoRHwdmGX7FGMD+/KgjQrSx+Rir9XppF44l/+XkW9HB?=
 =?us-ascii?Q?IM+LKDsZpencaaNGwVkxYlr62cOmtFe8UMA/QpzyANHxH+0BENkUq59Xk1Wu?=
 =?us-ascii?Q?y0CovVZlpzGzsz89E4os+aJdxdq/qSAv4C/SZwHo/Fl4lUeLbRQWdLal6AOA?=
 =?us-ascii?Q?UB2HfJwX8pygSqb3yYhQ/LkX6OW0u7NoRLVVcOEBRBExT1VJhZRWFvT5xX5+?=
 =?us-ascii?Q?Vbu2bvtSTOHB3pfA8LSM56fzI/WQkigx0h+NbPqdIb0UevLKNjDZSXN+dLtJ?=
 =?us-ascii?Q?8iWeRzusUEnQDuDZuhX7sfdAuO/KnCO2GTZGeXUrjqBl4nQgz3DZf5zXEXfF?=
 =?us-ascii?Q?bO20+YpjAmhDR7ub36JMGWRh+36pD85QX4IuCPIUwHFqc2SOVRB2rtBTKst7?=
 =?us-ascii?Q?HnAEgQOZrQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf543c20-0590-4658-eebb-08da1f42093c
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2022 00:42:50.8700
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qW5XI+LayDJnsHzw8lvF6s+jp++71eTs3AF3y18QkJ1QTgmoIWvtxpHxwd2AQjRp9aMeYLCAcwfwXe2hXO5RGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5892
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
> Sent: Saturday, April 16, 2022 5:56 AM
>=20
> On Fri, Apr 15, 2022 at 04:21:45AM +0000, Tian, Kevin wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Friday, April 15, 2022 2:46 AM
> > >
> > > None of the VFIO APIs take in the vfio_group anymore, so we can remov=
e
> it
> > > completely.
> > >
> > > This has a subtle side effect on the enforced coherency tracking. The
> > > vfio_group_get_external_user() was holding on to the container_users
> which
> > > would prevent the iommu_domain and thus the enforced coherency
> value
> > > from
> > > changing while the group is registered with kvm.
> > >
> > > It changes the security proof slightly into 'user must hold a group F=
D
> > > that has a device that cannot enforce DMA coherence'. As opening the
> group
> > > FD, not attaching the container, is the privileged operation this doe=
sn't
> > > change the security properties much.
> >
> > If we allow vfio_file_enforced_coherent() to return error then the secu=
rity
> > proof can be sustained? In this case kvm can simply reject adding a gro=
up
> > which is opened but not attached to a container.
>=20
> The issue is the user can detatch the container from the group because
> kvm no longer holds a refcount on the container.
>=20

See your point. In this case the guest already loses the access to the
device once the container is detached from the group thus using a
stale coherency info in KVM side is probably just fine which becomes
more a performance issue.

Then what about PPC? w/o holding a reference to container is there
any impact on spapr_tce_table which is attached to the group?=20
I don't know the relationship between this table and vfio container
and whether there is a lifetime dependency in between.=20

Thanks
Kevin
