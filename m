Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DABD56D574E
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 05:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233132AbjDDDvb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 23:51:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjDDDv2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 23:51:28 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2706A137;
        Mon,  3 Apr 2023 20:51:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680580288; x=1712116288;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NLr1c6oeqLwQzli2wavyEz5bRQ6MMVnbaJcTX7VWfyE=;
  b=UEXp9N7Bk7qwatGGLcS9hCopnXYDexqSVwUvY5q1/qE6K+LPp8UrPh65
   asp+2r1lBu9vgaqzd3LXdBGMUNjLC6qQ5TOI1O/VC2EahrmZWabwy5HlB
   ZqjVU4QR555nCAteUBrPfAW6/g6S5kZXHWCvdqL32zt1Nhp/6/lO/Kxiz
   UBxrXwjTpI0X9bsVsjYg4PieWUQb57nqQGZlc394o+ZL+CvuCttVCfODv
   TCvUG9V/dgc8bZIF6Gy2/J4HCBHyuFXQOkNUz7RowfK93FUpOhOh7gVIW
   7PnNytzMIQLvc0T4VjH90BFWlx3bbRubIFqRgRpPhYDYfRcsYLbQ+DlVX
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="342104895"
X-IronPort-AV: E=Sophos;i="5.98,316,1673942400"; 
   d="scan'208";a="342104895"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2023 20:51:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="686213567"
X-IronPort-AV: E=Sophos;i="5.98,316,1673942400"; 
   d="scan'208";a="686213567"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga002.jf.intel.com with ESMTP; 03 Apr 2023 20:51:27 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Mon, 3 Apr 2023 20:51:27 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Mon, 3 Apr 2023 20:51:27 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.175)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Mon, 3 Apr 2023 20:51:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q4zPSxcXXpsewSmvXGzAn/KkcXeMO5DucOOaeFsr+Xzy6ujydb3qKQLcEqTml2GZVsAgqc2mMIzy67TIsyc0G9vtKd7YzqAIN2/ysSfHFIMYDcRiMDaMas1yvs6sLepxAQ9ZOCZgliaVd7v5eP7LaYgNNwEILKh+Wkw3Fr2BosP+q9IuKbUyfyetZfoMqjQXcv4+yDqxEG/Q0FVw/Kyyr0HWhaIoK/EL76w6QeoUQreFo6VYEOd/0h+H/9pyCVeGojo+GZZU0wwJypxsi+Kk+V9QgTBW9k40DxHaRTOdbZzajizFxPulfXipfP4yEPIacUaQalBg4IYBFEqEDNsbEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pbvGwCEKyRE0bJotkzt+aFuCXA9cPLzmyoG9qC2WxuI=;
 b=SQerQEp1AbK3EJAP5YkH2NRa7CNNGk/GSCqeY9m4Mn9yGFRY/Z4MZucpnSizsu4HR2Mlja8vZAleNpKoWf8vUwSk4RJNfZRzhXUaOg2Wg/xEoJiOqpLI6JuYms4rWluZABMwW0XTEXoY+t+K9w+ddu2xw5xgKQh0UYHGD6CG7doCgdyfw+EuzI+epjHAjiSYoGM2ZBNN8BDnF1tKRITA+g+/jt5tQAzVNng+JmFq36HMW0Win1sVgFsYE6QudBc0Asc8eXXnByjWx/ZS7L8nSPqQeH4MH6nx57CV7YQDsFvrZWN2zbFZXnFTiJoinjQ6drPzjds1a8CsD6adqWc2YQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CH3PR11MB8095.namprd11.prod.outlook.com (2603:10b6:610:154::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Tue, 4 Apr
 2023 03:51:25 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::73e9:b405:2cae:9174%8]) with mapi id 15.20.6254.033; Tue, 4 Apr 2023
 03:51:25 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "darwi@linutronix.de" <darwi@linutronix.de>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "tom.zanussi@linux.intel.com" <tom.zanussi@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V2 7/8] vfio/pci: Support dynamic MSI-x
Thread-Topic: [PATCH V2 7/8] vfio/pci: Support dynamic MSI-x
Thread-Index: AQHZYb/RZ45AlQ4MQUqOwT6J+5pTU68T7doAgAAAZQCAAUB6AIAATQUAgARk+oCAAC/MgIAAKXoAgABK0YCAAAgOEA==
Date:   Tue, 4 Apr 2023 03:51:25 +0000
Message-ID: <BN9PR11MB527626CAE4BA7ECB64F0E9728C939@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <cover.1680038771.git.reinette.chatre@intel.com>
        <419f3ba2f732154d8ae079b3deb02d0fdbe3e258.1680038771.git.reinette.chatre@intel.com>
        <20230330164050.0069e2a5.alex.williamson@redhat.com>
        <20230330164214.67ccbdfa.alex.williamson@redhat.com>
        <688393bf-445c-15c5-e84d-1c16261a4197@intel.com>
        <20230331162456.3f52b9e3.alex.williamson@redhat.com>
        <e15d588e-b63f-ab70-f6ae-91ceea8be79a@intel.com>
        <20230403142227.1328b373.alex.williamson@redhat.com>
        <57a8c701-bf97-fddd-9ac0-fc4d09e3cb16@intel.com>
 <20230403211841.0e206b67.alex.williamson@redhat.com>
In-Reply-To: <20230403211841.0e206b67.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CH3PR11MB8095:EE_
x-ms-office365-filtering-correlation-id: 7b908e9c-d26d-4a5b-2ebb-08db34bfdced
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sqxxi2C4U4cx6NEZ/Iwkh6zrlT0RnbLuBjJUI8k92lv1wd4auFhpFWo+VnFAd+DgohtdicXwWTrR7hPSLhXCZh42b554a+TxkAT2pPac1gTKDWw60hkTPyR2wRmqfYOyajSlPZbLs2tU0I7tEnJZK6B25NbHDE8El5MFnUvbF4tni2RbHBLVV8fGSKFA7bk1yBIlcj/GROzP5DDDvCs0tlwOj7wS9opozGMUg63mpZaincw5m1YX6EnniJz/INRCFbw35w4L2C6Sv+1zk0G23mSH3quEKuiyhd69fTzy5gs/37sb2hpNUTnBaOMoxG4JMjVacu77t6B5Y9kEpcFJpP1SOh0UwPmfIY0aB+VuyKBmKTEboVi+G1jT0Gv6ziuYaN8Ky18N+5Z+/lcVhMnl1oQTDa7049GMDjVXC+xbMKmOrXGtBnI/UZvya2EiPG1JiP5hs3hZr1MK8qFHXxDr1wWRPgjWIbApxvPAqVFX8gQtn7FR7snI9fQS4N4LTzZ2h8TvaCKxnWI6fqRsBLNrak7P2dG36x5p8LKR+m85dnTw99xFZCiEqRjIOqEdxAmOq9ZvRJzEFiXAVvzZzwcjcmK9i9x9FpVbIJPREO0G3O55Jro3blohYnX08wVWNNhR
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(376002)(366004)(396003)(136003)(346002)(451199021)(55016003)(41300700001)(66476007)(66446008)(64756008)(66556008)(76116006)(8676002)(66946007)(316002)(110136005)(54906003)(478600001)(6636002)(4326008)(52536014)(4744005)(8936002)(122000001)(82960400001)(5660300002)(38100700002)(186003)(83380400001)(7696005)(71200400001)(6506007)(26005)(9686003)(86362001)(33656002)(38070700005)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/95rqHqjpomsRGG02+o37jClweBDC3tnte8iO5Qwe7pJsmL5Yty6QsjHGHR6?=
 =?us-ascii?Q?dReZceIG8GZglIkLiYqGzR5HSbfT4YMdbVV6AHblXWBUIzSJSulNgoZWOYAr?=
 =?us-ascii?Q?Az9GBWg1i/zq2Jp+BGNCO0GVBlSkAOBstwB1STazUv5RbRdzTg5YluiWrgwR?=
 =?us-ascii?Q?Dko1GAjyeWhgUl9WKPdC68zmrFqMxHX7yhe3VG3q1+pVnPm3pWpW7ZMbGeWy?=
 =?us-ascii?Q?XHJkYBuMATYdyNftZ9KrLtY9Ioa/5TVTf3RNJMXmLnJAP7HsEMbSA78r3vkc?=
 =?us-ascii?Q?m8AHfx7kfySmPRbfVBVeRPk7lPeasI8JdNz0uaJGAnWZdheZLVf+PDTiiQs1?=
 =?us-ascii?Q?WoYhBEgqSmrEFkQXsVTfFQycxXn6C2oBLkNudzmGP3fnd1gjZQyhS9sBQD6u?=
 =?us-ascii?Q?GtuKYoeAVsTxSE8sPxZsIiO0tPhCSn0ayA4vn1Rd8e5gt9hs8iYFTMWD3cyb?=
 =?us-ascii?Q?6CNWgNXJMNgEuWA/BYzMtVmZjHQZcTauKdhbkN/L252zNDoWPAqwIIIJ477P?=
 =?us-ascii?Q?hK+r3MvRGQ7kTLD3GSpB3+3DM6cE7bPFjZozeZxbulize4ncUZz8qmkeGH7a?=
 =?us-ascii?Q?YcbN3MCZRp0Hu/jo8U1FQS3XmRHZaQ85Ey637CsbyRC1v8tNXSKcGvwguPtL?=
 =?us-ascii?Q?qNYW2nrY4C6CQfPexwerobf5K+okUNZjaQZyxRiOISkRs436nj5o/tjcioJq?=
 =?us-ascii?Q?VZ6dnisLqv9ovhmLN4R2rBOWcdjZv302TgrqP3Ew+OdYtEaY897kAbQ1fesN?=
 =?us-ascii?Q?g1/5h3wxwXyI9UAkrGxiMi938JasZ+u0NUbT/0ClphAMpnt8GXxmntBd051u?=
 =?us-ascii?Q?cY2u3BQ7S8bGmbZD01BTTyEXAaGU7UtgiVpQ1z37SRU+UxvW7s3Que2HVtnv?=
 =?us-ascii?Q?3bxbw4jGXOtnnwP8c17lP0ZijU5dAhD/Id+Q03lv0S9M3VFtWGyiWOHeC9UY?=
 =?us-ascii?Q?i1kpDGRmLtfwRIDErwNZzHi1XosIDKYNcrzRzuAeWsL4uSjUZPPOFxIfltwD?=
 =?us-ascii?Q?vDe8KsVlaeqhaaZrIDpVTSfJncYWvxnPJBmHFr+TXGZ+e35QE+BLNR7ysBOu?=
 =?us-ascii?Q?toM8t/LV+ipeigDG+qMoqKNCKyyAYY/KUT+UbZXugRbQlhtnrSnedai4sFbO?=
 =?us-ascii?Q?6KzSf/a1peHyVRBbRbWm/VED/iH9azCXNYcL/wOIjZfV6hyqU06MXIfRcwd0?=
 =?us-ascii?Q?oyBdlqeFdIZCG4535hW264Y0/zkJIb3NaK0lWVM7vWmSwAjqqdZ60c4wluB/?=
 =?us-ascii?Q?iHAjGVP3TL/S7Dfs7M24DoY0CM2WIYPmL4KoqMw3YE1Fz0hEt7raiRb3TU3X?=
 =?us-ascii?Q?XaVpcctehGR17sFv5p1XLxlYmRgpQXrlOhktWIeMlVSlVadqMdjadn44p89X?=
 =?us-ascii?Q?ZZGdq4Lt9Y/y2ScAZlXAiWrFOQ2IiCHPSi2HKirWdIEj0toml9KexHYAvwQT?=
 =?us-ascii?Q?WmSgb/wvpE7FJXMJ7Tbclg11X2IAtRkxcPCVL01jvxoTYi3wfsk/uVV9j0Td?=
 =?us-ascii?Q?o0HSLKO+vsYnwu3vOzt6XuvzieTbl7QpZJyPFR/n4Yj5NZeotaMvkH4rnbAl?=
 =?us-ascii?Q?MooHdystjIYxmKWWktf9HbLvnw6Hx1q18yyz5I0z?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b908e9c-d26d-4a5b-2ebb-08db34bfdced
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Apr 2023 03:51:25.2559
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: o+f8f/6ekNT8Af7hLMtqg/g+iBf3YdgY1FCtnVEJLh08MYv+t3ODA1eJT4iIdbQJJ4DKQhd5RatL+22RldJHIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8095
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Tuesday, April 4, 2023 11:19 AM
> >
> > Thank you very much for your guidance. I will digest this some more and
> > see how wrappers could be used. In the mean time while trying to think
> how
> > to unify this code I do think there is an issue in this patch in that
> > the get_cached_msi_msg()/pci_write_msi_msg()
> > should not be in an else branch.
> >
> > Specifically, I think it needs to be:
> > 	if (msix) {
> > 		if (irq =3D=3D -EINVAL) {
> > 			/* dynamically allocate interrupt */
> > 		}
> > 		get_cached_msi_msg(irq, &msg);
> > 		pci_write_msi_msg(irq, &msg);
> > 	}
>=20
> Yes, that's looked wrong to me all along, I think that resolves it.
> Thanks,
>=20

Do you mind elaborating why this change is required? I thought
pci_msix_alloc_irq_at() will compose a new msi message to write
hence no need to get cached value again in that case...
