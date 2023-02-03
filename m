Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03C77689170
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 09:01:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232721AbjBCH7c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 02:59:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232123AbjBCH65 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 02:58:57 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45BA13344B
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 23:58:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675411136; x=1706947136;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ndeWuM0ZtgCW1DaPknfmrCTDA+Y6T3Xd5EfMM1paVrc=;
  b=XT8iRO1ZMPV+BdJCI6Js7j/gnzLik7s3GhNfO6EA9V73gYljcOOXzaIT
   QBwOjm5mg4H/efgOof2e+cS+6StndNwl9JK74VeGIjVPZH3ZogSIKvUA2
   KrMM9mCKhoAQ9WT//4rPofVou+V9JYR+vq3q06OvxGVeXoi1oErf6SwMD
   +9XFofldfar7BdMuax/MN3/akJaZXCODsjoO738b/o0izhyRzV36QeZTu
   HAaD/AEjuxhSBrCa5exEu2Hg4eANn9tP1k/mAzpTXcEtsQUILWXTFZMSx
   yMaeYGaIWbPj2LO5SuAAkoG34AjVMZRXEYgmogRCuo/jlGbUdxBzeVOeR
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10609"; a="312343869"
X-IronPort-AV: E=Sophos;i="5.97,269,1669104000"; 
   d="scan'208";a="312343869"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2023 23:58:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10609"; a="665618644"
X-IronPort-AV: E=Sophos;i="5.97,269,1669104000"; 
   d="scan'208";a="665618644"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga002.jf.intel.com with ESMTP; 02 Feb 2023 23:58:55 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 2 Feb 2023 23:58:54 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 2 Feb 2023 23:58:54 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.105)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 2 Feb 2023 23:58:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SmsKw02wE6h3DworNKUgoJZ0zgAucA1WXVeV813sS5b5mSwMKx0TxHCh4p1QF+kSkD21l3TCBZl3yZ+KZbw6ndUHNay5IyyWaNfk09uM8dOiDaXyNsmWtoRSgDLpdQXh/PascVeHwO7xJKKT81PzXYCPieZK4SHHml/l5ZnBw0p4Yv7/O7kFCpKjnWgATXGlcvQM9iF3e3e//rnBfOcGMryuWHGLUIMel+KlC3NBvQF0XSzaYw1t+iI09Vyd5q2t9j8cBlunBKtzFFPPbKsLpB0Qt2+FnrI2QWfLG++RdyqOBzgMYeNpz6m9oZHiSQplf7rFeeMCNyx9R6S6F4asFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YFbzcNRNjmG2ABqk7j2oLbX0DWtZAxzGLrYpDgImp1Q=;
 b=EAS8d1tSo+1eeoCVy1/VGritjzlhVzWFaSZUltcJzGunESyArmTG3MNWlWp0RT3651t3VIfve5pkY/dqYMfZWX4eilosKwhbKgk0vquQlPLBg+2wh6Kgt7IO5qrZJuIJAKfDaekWCFmWgR/IGaOrE8Sq6h6Up8vLGlPFQfp9w0YgeEbxYNn9z8et9kaTG4Ilx5xbC6ui30Qtkaj8YcO8tcqnsigGtsoV/k6XUvpOp0TA64hvjHyXecgj+R96MnQYGYdJMeTrpC0m0EdNsIMqoygQcgn3VwYtPXQLC9iyDPxdsH0HHWh8fe2UmE+1upOZfK3nr4lK6E2eP7ucdmIeGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DS0PR11MB8018.namprd11.prod.outlook.com (2603:10b6:8:116::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27; Fri, 3 Feb
 2023 07:58:52 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::e1fa:abbe:2009:b0a3%4]) with mapi id 15.20.6064.024; Fri, 3 Feb 2023
 07:58:52 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH 2/2] docs: vfio: Update vfio.rst per latest interfaces
Thread-Topic: [PATCH 2/2] docs: vfio: Update vfio.rst per latest interfaces
Thread-Index: AQHZNtymfc/0mKQcj0e603kVKITxmK68Nf0AgABk4gCAAEIHAA==
Date:   Fri, 3 Feb 2023 07:58:52 +0000
Message-ID: <DS0PR11MB7529DD5AF47872FA71538D12C3D79@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230202080201.338571-1-yi.l.liu@intel.com>
        <20230202080201.338571-3-yi.l.liu@intel.com>
 <20230202150110.1876c6a9.alex.williamson@redhat.com>
 <BN9PR11MB52764F694E790814B6E9DABC8CD79@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB52764F694E790814B6E9DABC8CD79@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|DS0PR11MB8018:EE_
x-ms-office365-filtering-correlation-id: 6933cd12-8749-412f-bdd4-08db05bc7d9a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HxhZ6rtfjPRZJfKoJlwyBNAKZ6bdhNcOy/jOWtHH8O+zzoDM+sKV/34b85AYQQXotG5u7Iaw6GassqDn2Q6hQJaJL7l8xkiIqQI44ubT1e+E8bJDuB2armxX05frBSntPv8AWMBNQZwv0Ot+mZph/LESOCdmCyuIDTeh4nPVWtDG+QDuimj3/vw+iXd8RQpHoJVfMbZHuRHcjD2MH3zL3CPAPY0ojI4SbDWNcMsgSWQm/XNf2HIYeP6P59W6+XS4OvXXWhFYa0kNdsgZPhxf83A0s+2v+VxIQqoNLUc/opBspcDiu5OkyzVNiFv2kUDRWKVpA7nuQnUJ4M3KhnuZ3wwdU7EmGHkZA8XPmWgJbRSxHOmv3TDDMFu58ahllVLd+8Z8G7NCfVc596eJEluHQCS+Ggyl4EdnnZWpRwl4zIeVA7QccL7MfoqVVR7qkcjaZkkS6SHn+z6YbEp2TKvHLrQV/ai64c9kCUwJ2PMZWU1O3rkKk3xM0rGCASFJqk+R7qSutyYpjzp4qiMsrFJ5ryMPUvxPz6KmNgRdR/Duqke2zjbX+kSJpog9QM+GqUJZbdXd7s5UVEYdV8m+mNREpm7XTlfxhtxMFWq84zPTmtCSiZKphN2Oe/KD3dO3o6DSim8TIfMtsEpR/ikTJF49w8yv7tunaJnQK4U+kDIrtL3niHsPP0a6PJRmcEm4CKDEBlBCu3zsmmYkWSI57eWHPaD7OV1clC7dwhSetgR78yo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(366004)(39860400002)(136003)(396003)(346002)(451199018)(2906002)(66946007)(76116006)(4326008)(52536014)(478600001)(4744005)(7696005)(38100700002)(33656002)(5660300002)(66446008)(6506007)(9686003)(26005)(186003)(55016003)(71200400001)(86362001)(8936002)(41300700001)(66556008)(64756008)(38070700005)(8676002)(66476007)(82960400001)(122000001)(316002)(110136005)(54906003)(13296009);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?VcVDUmlFulLaIiSrR6HUXSAi6q7gtDDb8QkEz/oyEvPxN8M6L+ty+RCyzgEg?=
 =?us-ascii?Q?YWR7SVoOTAdAvS4rs0fJ8Wvr94029DuS2wqYHsQF1npJabflbuw4ToSDdaYO?=
 =?us-ascii?Q?dZiapNCPTeLVyivcRR3boN8c51ujf2Bm75K/Za/11xR51NV1X1v5XfwazX4Z?=
 =?us-ascii?Q?PUklRZeDFOuqF+2AzMzMkqv7xj49M1BHvJWgbdP5B5AotJK+EapnOF9Pz1Hq?=
 =?us-ascii?Q?A6uM7BBGpBvsg7nQK4Wh4FDRcaWtlNIxQYp4We4ZZNVtLH+dLN8VJ3I4nTfw?=
 =?us-ascii?Q?x2Xnzj8YnHfblC8+2b1qJVoGOsbfRkUshKvTBRuoNJtNfdC+d0jJ/vK15Nfs?=
 =?us-ascii?Q?vnjazFTrLpwKUP7QXxK2ZhmTReHnDnNiaejf3t70HEWxNOGnG5jN35P5ArS7?=
 =?us-ascii?Q?3Fs0i2JzyKZh6pWi9VnwbR2LaGj7fW3Mrn7q2I2To3xragvU+OcLkqRv+Tf+?=
 =?us-ascii?Q?vAhIgoIbBnEcDpedcEDyFtnL6tqAW1JmGveubuuQAnxkIHgaDD4ccQ2q3HrC?=
 =?us-ascii?Q?iJvxgZ5eiSiYmWeaETZeZc2X4fQuUZyiQExcv2Vlb5JuGT5kmxrxZs87gNUm?=
 =?us-ascii?Q?D9unrc5HJOyLTO0rZVJpvJmkr1hxVXxP52e8utjRsGQQ3JQZ+txRKAYEV/Lc?=
 =?us-ascii?Q?2tTm9dPWLvIGeIyl3JD3c1URE/sSq7UQHgh0BRisNngixF0cObOBspMcVZ6b?=
 =?us-ascii?Q?8vZS1MDYeg9G9FbbRIKlwb+l+BkEH2Ig/5cTnKC8xPDRqKOe1DSOQmKUB7Dh?=
 =?us-ascii?Q?QT4EL7egBYdDwjDgENNstaHNW6TNyvK/4CdWZFhFt1YybxO/IIzwEGdEkRvG?=
 =?us-ascii?Q?z4evRVeL3Vb6E9ntMCAw+YHyRkY7D6U/xBtHvaOFcbVr+VCXcGWJHUVkUJh7?=
 =?us-ascii?Q?gcp39DeRNQFU6aOZlpUH+fI7n0kKF3o52IPuW3Dx81jhxdAh4TABp2z9BzYN?=
 =?us-ascii?Q?lNTSHbG6Egn4r99HX+9tHjDSNYl7haB9/XROfParuyBDgLfQoC/VgE/YqXFw?=
 =?us-ascii?Q?4mnFKpPv+pQeWztPX1LIeKDWX8UWGSmpXxZ8K5Q10gQbhDGeltN8gLpU3akM?=
 =?us-ascii?Q?NsN8kgOVYfU0queuVdiPiINWPUAFzHaNz/JyjvbTShxDoR9Wfz4G7fLbo0Tl?=
 =?us-ascii?Q?Kp+mBJR+/CSViEu7K7/yg4Fv4hddKTzrxSPEaHZX9O87ZMV9B229e3+qqPTo?=
 =?us-ascii?Q?pUf+n0+oALSIfHYQPLA1/0Rpm8794788b/QcT3DGH1Zfoc+/SnDGkvz5SjrD?=
 =?us-ascii?Q?imS7gDZp/IS1q8hDdph07D4+WI0OLmR2T8KRpde5sfUF6qEGcenHjYZVRo7P?=
 =?us-ascii?Q?8awGxjjgSdtmFjyDQqObmwyx1HtbsbEv/xIYhCkP91+42JbizY0dealUOsoT?=
 =?us-ascii?Q?zaWY19rxBRl1YLq7RWYSSkW/EgK/Mwu5no1TUzzRvr1BDnwIE1PrPJXJMUf4?=
 =?us-ascii?Q?dada9saxZ9l3nixmv56o6LfJ96wWOb7S6KUo1og1lnFgcWfzXoO7sAXNUVjF?=
 =?us-ascii?Q?5Kxck3opyYi5OnWtM3RfEShx792hufDTe6Ebro/vcINfA7XZwven4sWa/iwq?=
 =?us-ascii?Q?QVEeceJwt83hHa3HD1jSiBgiX4BfF8xS5PLXzfk3?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6933cd12-8749-412f-bdd4-08db05bc7d9a
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2023 07:58:52.2028
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /a2jvJpDTeixXJvEYEc4xGN5INM3jIqvz71RupNIEFFAzmsHz4WdRjIc12VsFqxma89E9E7Q3EP161M+eQrmDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8018
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Tian, Kevin <kevin.tian@intel.com>
> Sent: Friday, February 3, 2023 12:02 PM
>=20
> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Friday, February 3, 2023 6:01 AM
> > >
> > >  The driver should embed the vfio_device in its own structure and cal=
l
> > > -vfio_init_group_dev() to pre-configure it before going to registrati=
on
> > > -and call vfio_uninit_group_dev() after completing the un-registratio=
n.
> > > +vfio_alloc_device() or _vfio_alloc_device() to allocate the structur=
e,
> >
> > AIUI, _vfio_alloc_device() is only exported because it's used by
> > vfio_alloc_device() which is a macro.  I don't think we want to list
> > _vfio_alloc_device() as an equal alternative, if anything we should
> > discourage any direct use.
> >
>=20
> Agree

Done.

Regards,
Yi Liu
