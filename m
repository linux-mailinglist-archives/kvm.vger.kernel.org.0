Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F495688E5D
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 05:02:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbjBCECb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 23:02:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232375AbjBCECZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 23:02:25 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C78AD1735
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 20:02:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675396937; x=1706932937;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=lZZ83utOKwJLHSgPzAQHStqpyq8RzJqh8iPs1TlavfM=;
  b=TFvU7uAiypebTVUC1a+UpP4licrqZtaMtdEVT5yepFKscb45wlLEepQK
   KRqusu3JmqXyb0BImVVtYvdNbLvx15OTAuoKpfPJrM0PFh7Wa5AgV/Rwd
   1NxZe0plYqOUv6ikBXwCkLNvVnoJ1r1neozCn1UQhr+5hVG0D0K3Xm60m
   oO7ADpzlpSZNfEm2fgUtdjtcTIovpmsXR6zFx/nBAsbHZklKRtE1mNXmq
   FbEXoqxYhLCkMPbiz+/9jTXUdWom/SfcFFrh/11R7r/qz14ipP/TEN17i
   s6Uc1xabSBZvmEaIP6hYizkMFvv2vLWAx5QEJCHY2chSoMAt04n7YN+0D
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10609"; a="391047273"
X-IronPort-AV: E=Sophos;i="5.97,269,1669104000"; 
   d="scan'208";a="391047273"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2023 20:02:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10609"; a="696023009"
X-IronPort-AV: E=Sophos;i="5.97,269,1669104000"; 
   d="scan'208";a="696023009"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP; 02 Feb 2023 20:02:17 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 2 Feb 2023 20:02:17 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 2 Feb 2023 20:02:17 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.105)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 2 Feb 2023 20:02:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TvvKoWgzaB9LEI+EOIssHj+brMp2k+lY792nQ2XncEt6spNCfh/e0uGvsTr/MdWFlydZM6akvQb6D+PxQz3vLVFqNPp8PRj3cqqYmHvenxB3w4p5h7x64JSr77MEJSqWorgKQIdeAmj6qDUmmnMTe+TeDMK6riKlz36MS7nr/a+BslvASTZWO8XAjeCvMOKHWhaVcZw5fd3uKte4Aj8XrK8e6VQSyM+4oiZjyuezzAY3bhRB+YZ5Kb4oQ2ToVdcVRo+uCTymwVAijHo5NgmiadeGoTBZb6AZORXva0Q+NuPq7VQqQ6F3v8HniiI9ijOzKOncH6nrw6sYsG5BWsT8pQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9mHcOmsh+1J1feK7VxgY8zhyjakW3w+2uoUScBvAk+E=;
 b=S4l6ey4cBKZGhtLhk/S0FbLkCnI4os034GoWf3jFjjD0PlKyJqr9Wxm6lDRwM6VhDcTybxNIPKpnSdjU1/k1c+N+y3bX//lV2Dy8v1DY2I0A8uBqmmlC46ib4qHda/1ghzSwTPlyeyPoC8JXssCFz4rTTqVi8YzasTd7Y640s+t2W8sdJ4naRLtyTU5hL2UBvo/piZyiyoC3VBFcm+Ofv987mRh6RuUng9wTSiXLv2XXk2vX04uXoZkG/4qczHPA2uDZV5G2F3GUP4jCmn03+lWq4C6f1TSWGOjKSfa/DK+C/gdPc0LzUc8gZoSBnOiYvqmUBwAgShSOBtKtMOT90A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CO1PR11MB5041.namprd11.prod.outlook.com (2603:10b6:303:90::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.29; Fri, 3 Feb
 2023 04:02:14 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%8]) with mapi id 15.20.6064.027; Fri, 3 Feb 2023
 04:02:14 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH 2/2] docs: vfio: Update vfio.rst per latest interfaces
Thread-Topic: [PATCH 2/2] docs: vfio: Update vfio.rst per latest interfaces
Thread-Index: AQHZNtymRg8eocUJL0GpJUe4G2Nw6668Nf0AgABkzWA=
Date:   Fri, 3 Feb 2023 04:02:14 +0000
Message-ID: <BN9PR11MB52764F694E790814B6E9DABC8CD79@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230202080201.338571-1-yi.l.liu@intel.com>
        <20230202080201.338571-3-yi.l.liu@intel.com>
 <20230202150110.1876c6a9.alex.williamson@redhat.com>
In-Reply-To: <20230202150110.1876c6a9.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CO1PR11MB5041:EE_
x-ms-office365-filtering-correlation-id: 7cb36523-d130-4a38-09c4-08db059b6f2b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Y+M9h802Wb5oHkkBlX6+vcu3o/wz++dqxMlEf3MNKIivFo60VtPgQ4AY7tORUtO3PqhOLYVAqZU8Uqk7ZbIn06lvQKEQT3ywdqhqK/K3CkXVfVeaQeOicbjBPms95B5KSF9SWUs3Tejx1jmXOiQ10OJaHkI6v1w9V3n34kWxEyPgCnjl8vZZgCNu7s3lLCLSbq5S4BrQzo4kXAVN9cUEtpZxUAzkInayYUwGkYoQv3QLY4TOJn4h9XdcY9/b9i/HQRskcLJOAaJ34xsCO9A7kVzeF++F+/Zak3Nt4nLOvarL72N02qsMRF631Oem+N5LNLaBEVhNxVAXOJyY8ie1X8WG3T90LDMsbR6dZN47GwpCsBO9E/ineJlcD5Hagxa6QG67ZjHGThKx9iuKlroNUnvadwbqVk7hcyK4v2sDivcN8OqDGzJw8SFv1wlM+gzcF0RlwOh///XBHJP9WSX5I2FGIODNyO1B9lXF1IheKSc8lk1lJsgUgUYZKQQfN5NH1FwbLgM853yGK8uziMjJm24p4LelweEZNME/OKimdIobuxeqgH78m2442HZkK/9M5k8FOozs8a+bGsN/hOKzXUSOMIrkZFZx+cHmQ5UdMIejd5w+LaCWPzfxB2qq6D29m3A59uYny1s4Z4YQvHSyJEtPB8/Id5n5f09UzOqT1Wdl5xrgWXJoZMbfnW7WUMqv7toULv1FNCnVgrEAJN53CQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(376002)(39860400002)(366004)(136003)(396003)(451199018)(122000001)(316002)(478600001)(9686003)(38070700005)(41300700001)(26005)(186003)(86362001)(55016003)(71200400001)(7696005)(52536014)(8936002)(82960400001)(38100700002)(33656002)(6506007)(5660300002)(66946007)(4744005)(4326008)(66556008)(66476007)(66446008)(64756008)(8676002)(76116006)(2906002)(54906003)(110136005)(6636002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?PZikNyXOQFdIdozEetX3cGrU0gSNWDwfTijbAjZwQ8PqtiXBEFhj/nMB4MZy?=
 =?us-ascii?Q?OFikHzOxYpPqBqXr1ZFxWdHE4wovW9rDaJIiMK4c2txV/KYYpb8G3BJHd3wt?=
 =?us-ascii?Q?tUGiZG7tRfsvYn6ZiPufSZp7GygtFAgFObElC6otIunTdSdGc75S8P+auK6w?=
 =?us-ascii?Q?eIunUKPXo9RlThOuB0RHOHIF/MoEAx302SinmL48G3dFI+EQ/GWJFEkGIf4Y?=
 =?us-ascii?Q?1dUkQn463Xnwjs07ij2Ek6fb6FHGoFogroC/X1JIsYM8e7UMJrhxlFEa6mwa?=
 =?us-ascii?Q?GfDcY1R4MArVXR1pMTX3+1OhBer3ZJLun+OIoI9EffboTYFEkJJ+Dje3zMwl?=
 =?us-ascii?Q?rEAeDy7WP/eSGtRmH/cTOBGBNgO5zESV2r0FE0VlnvP5cLuOKa3CgMiMvCdD?=
 =?us-ascii?Q?TDi66klEGY3Vbv0oua+OMXtuDTSH67OK2s0aF4lmi060d7i3eLWQjn2vElmH?=
 =?us-ascii?Q?QLkuq0QWrt6OibE+NKe5b3IXeKNYyPWWC3F47xmeyL5Y3M9WC35O/QLa0eGJ?=
 =?us-ascii?Q?hiW3Qx6Q6hLUcstrAXTRz4+SLdYNGc/vFK/6q/f2QFkbmvV8WbimIzm3HX3Q?=
 =?us-ascii?Q?/r5aeuem2Y3jO8on8jiRAQE7nBVWKbS0FQ5KnU75hG8pWNWOeyR2rBqLbgSY?=
 =?us-ascii?Q?0/OQrxCTbN3Pt7W38ndxG36KR2/p1nNK+MMwiWbco1wim8jZn1ORLi4oQH0C?=
 =?us-ascii?Q?dhaaHlQmWn1ZiPnkgh7Oz1rnjty2Fi8PbPm06vVgPZMeBX2nbZZCVCL9Aq4d?=
 =?us-ascii?Q?57Rfi2inhSHt4SjU2/v/jkeVp8XrA32S/SBx+kS2uet//jzKd6p6OZhnVBQE?=
 =?us-ascii?Q?bJd3SLcgs+2wDcJaUxr+P5paw4OjQOmUFRhPr0NARVkyMqdXXwyh2dQeWFMM?=
 =?us-ascii?Q?lgIjv+Kfdqr4p3AVpz4fRvvUToVJw+wooH1EF6WjS7gD6Aqv5syFmmrf4wbD?=
 =?us-ascii?Q?D6A+nldJuDPMKIxk+QgGsZfoa/a3cTIkaWzvdmHDV/c9qE2t8ZeSYEncdVWO?=
 =?us-ascii?Q?bKb8XEsv2xXu8Elpzg6PUkW44WWftLLZ4hNmlKL5U6yvIFmafXgvGtjTQi5B?=
 =?us-ascii?Q?H3cx/apiXB6CDSH1cVooAbFVGkQyaRf/emB23wfAZiwJaYXMdpoKdYYJxtQB?=
 =?us-ascii?Q?VllUK/8sgdgsM+LRbqO8O2fFLigpyRafbo1ffRS2mYWIz52eyIS7pn4hqEvQ?=
 =?us-ascii?Q?+1PqFT0jPcMHuJaw5gVAYPHE5ue6CsiGfq2lfirs1t8Gnqc5VzaXnim6Uttk?=
 =?us-ascii?Q?YvtoVQ4lzRaApLxENngCgTs/BIMYs34L8gFZnT3/tCWwdyeS8FBK3m3pNRYG?=
 =?us-ascii?Q?gC19CGcaUOva4DkJl7nYCL47wM/fAbkMOCZ5/aPSM/3e6KAM4fpQKaBxu0iA?=
 =?us-ascii?Q?QW+GKWlngzeMeSZS0w+jhpY3AkYJSEd7KUzjKl0rjCX08QS+jr9a1xlZ8jr0?=
 =?us-ascii?Q?veIFrHzSd33S62IZ1yGgfClo2sgJeYGjxNyZCaOuVRfSK5N5FsxcnupAyghX?=
 =?us-ascii?Q?AkAufI80ULo/UdC1xfc7aY9Egy4PJUPYnvYFFvLcJF0jsfLEylIZ058yM28/?=
 =?us-ascii?Q?EQqpbhRz8yBqmkhq+CPzMuVA7UXrTLqYU8HQz5sE?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cb36523-d130-4a38-09c4-08db059b6f2b
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2023 04:02:14.6062
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sBO6DWShCOtssNIG8iKrsXS/y6M7REcZAeHcEXiYy859z7U5TWGAWyfVZBU6m7WbhOGJEzs/l4pdzCPogMLDHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5041
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
> Sent: Friday, February 3, 2023 6:01 AM
> >
> >  The driver should embed the vfio_device in its own structure and call
> > -vfio_init_group_dev() to pre-configure it before going to registration
> > -and call vfio_uninit_group_dev() after completing the un-registration.
> > +vfio_alloc_device() or _vfio_alloc_device() to allocate the structure,
>=20
> AIUI, _vfio_alloc_device() is only exported because it's used by
> vfio_alloc_device() which is a macro.  I don't think we want to list
> _vfio_alloc_device() as an equal alternative, if anything we should
> discourage any direct use.
>=20

Agree
