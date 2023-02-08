Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED48168E703
	for <lists+kvm@lfdr.de>; Wed,  8 Feb 2023 05:23:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbjBHEXY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 23:23:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjBHEXV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 23:23:21 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6D1230EB3
        for <kvm@vger.kernel.org>; Tue,  7 Feb 2023 20:23:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675830200; x=1707366200;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=AEynu03fksbDZJ5ep0Ql3xSXLoqDvMrdPC0rE3pXHgE=;
  b=e1XSEIX6BEKSK7kHKoR34Wk7sE4nTkdpiGGiKGKYla0MmYOauXjbfWP9
   DUl7c4WxJKO7I3rFhqJmgYwdYYJgnfCaJ2uGqmTlsriR+KBTpEXEje4Jq
   BwgrmXNVund4e1uIksxCb8ekElEil26u2kVm8t5oicUGG5AQe7OQSqoy6
   t8LHNLpQJIFGDcjT5S2jRRIgK/Yxq4/YJyA62u+IvD3B72pG1fl3s0AGv
   VgnczvGDueBVldpwdd/KijYCp+pHACGLbmHaOl2P1IAx74iumZGewbRle
   YRn2VAGPQaK6Mp2NH1aBAvwBL0xzPY5QuwhUnskYfWTh/uWeqAPN3LQsk
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="331838389"
X-IronPort-AV: E=Sophos;i="5.97,280,1669104000"; 
   d="scan'208";a="331838389"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 20:23:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="730706608"
X-IronPort-AV: E=Sophos;i="5.97,280,1669104000"; 
   d="scan'208";a="730706608"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP; 07 Feb 2023 20:23:19 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 7 Feb 2023 20:23:18 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 7 Feb 2023 20:23:18 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.109)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 7 Feb 2023 20:23:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dQ3fC3kcVlr0L/6GXBbdcXKywwxtoc4x254lhIUrB+VHFH+oREOJDPhluLlhutIkSyTINoKDKiw9avs2RAE2UBAsc6woQzaCaCZcapCAl7vDP2gAgVisFjb5fbw0i6X6AzAPboe3LdguiTstQwecIXsnS0gCHSg9IMDHG7tFSXSO8ycW8CtLfIx/aqD0+uiP0obbjvkFkZWGG4WDxvzgBiJ1tQeipYEilegKBS2UZ54tUnoGAtoAsP+F5JfuJ32j8vwoRDSxypUOCSQsFTizR8Bh7UvcbD8QnNENoPINwhqpZrU1it4pHqMKmv5q74zy6YhS8YTJlP2R2sudQX4afw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AEynu03fksbDZJ5ep0Ql3xSXLoqDvMrdPC0rE3pXHgE=;
 b=BxKiH36o+3Cw7uw9lQ7Ceh5D6m9qZj9wYByhIDC/KAo94M4F1PzYfi0y3pXQ2Y9C8YbGj2Rg/wN3J4+DP8k+b4jocS8GEGz75RBiFO5Er5X14Q03pydcDvVZKVfNXFVbhtGKfPn2J8bMXgfQqPRieSewGR59KQq0Sg/5hpNxtVvYOrwE5A3/6GPPXuMUAuzYEZjTh9iMM1/k6luM3ECuIIS8fguATbhU1InxaNvyYqrM7GZIgAnb2OgtxzkNyFz9i0ZSErFIf6QegfhOkliLWMwS8T+kReAX5HX2TXINbtshSSo8Sy4xxBVWaLvlgunvI0XDFTX8Aym2kbctvKSA3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by BN9PR11MB5275.namprd11.prod.outlook.com (2603:10b6:408:134::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17; Wed, 8 Feb
 2023 04:23:17 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%8]) with mapi id 15.20.6064.034; Wed, 8 Feb 2023
 04:23:16 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>, "Liu, Yi L" <yi.l.liu@intel.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
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
Thread-Index: AQHZKnqafBBqpcX9SES7NJ4Rmsa6D66mbRKAgBCGzgCABEckgIACXXuAgAPaJICAAFxyQIAAVkaAgAALUYCAAJKEkIAA04QAgAAB3QCAAABPAIAAAO2AgAAA9wCAAPasAA==
Date:   Wed, 8 Feb 2023 04:23:16 +0000
Message-ID: <BN9PR11MB5276F8E7172F12B19560AC1F8CD89@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <Y91HQUFrY5jbwoHF@nvidia.com>
 <DS0PR11MB75291EFC06C5877AF01270CFC3DA9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB527617553145A90FD72A66958CDA9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Y+EYaTl4+BMZvJWn@nvidia.com>
 <DS0PR11MB75298BF1A29E894EBA1852D4C3DA9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB5276FA68E8CAD6394A8887848CDB9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Y+JOPhSXuzukMlXR@nvidia.com>
 <DS0PR11MB752996D3E24EBE565B97AEE4C3DB9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y+JQECl0mX4pjWgt@nvidia.com>
 <DS0PR11MB7529FA831FCFEDC92B0ECBF2C3DB9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <Y+JRpqIIX8zi2NcH@nvidia.com>
In-Reply-To: <Y+JRpqIIX8zi2NcH@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|BN9PR11MB5275:EE_
x-ms-office365-filtering-correlation-id: 0a0c2869-5f47-4969-6a1a-08db098c338b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UTA2btu1zo0tsF9a49LnEzqfvpHYH7hASIgazAmiZ++Aug+gQWMQrC77aTtSMcS6ap1pNY53b1HvimIHmdZmMTSfZtzsLCGNPzZZyrRGNStj8BXpH83F5XLAvS+zQv4tej334HcfFlNX/znJIkYOqOh5XrB5RXfV2+/HJZPNzbDXZJXW759cW1bE9Pht1aF03r7SGe2D2CSKBU957qnh8q867sQy+IqMZNJwE3sjnnzYhNnrzo9xQ73vlUXFSMf7tUpG5LgeKTaeDEeSUxfrPSLAsq5NjJrOPqWgjjVc9dfJuCvgC8u34ip+B6oyM9PBrnM1FiB/LkIr/O+/306eawmMqtMcOz39Ncbf/sFI7yfjeetlwr8b0MDHovNg+vrx3tfkK9rqoslKX3eRjrR9CnO/m5yw/jiNH0cRVYgx9GtrQnNwZ5mURUrUIxrVqdd96eXyuqGCwqgUG8CbqU5MLzAYA3A29g7EpdquAfaAI9Y//LbMt5QeqNItrDWGxXybzyw1kArTMtAXqrn59HoiWZ6ZW3v2MWHzWBzwKC6kj9aewIY46amtvajiujpnIcnUOQQa5ce5IVBVJgzzzWDL+A51UmBimHGj5uTLBdr3/GSsFxCpJH3C7wpq3AkqHNq4gzBnf9SnPLzixNFnAkXaVVjbF9ZL9sntV8hTs/JqhJYdKGy4NTbmIdUgOZRA77vdUKMBQXSIvXyJNKPgfWwg0A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(376002)(396003)(366004)(136003)(39860400002)(451199018)(83380400001)(2906002)(7416002)(82960400001)(8936002)(4326008)(6636002)(54906003)(5660300002)(52536014)(33656002)(41300700001)(110136005)(66946007)(76116006)(64756008)(66556008)(66476007)(8676002)(86362001)(55016003)(316002)(66446008)(38070700005)(9686003)(26005)(186003)(38100700002)(71200400001)(7696005)(478600001)(6506007)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?cFXqnQIvEzGH7MjVVnTm1vXwX6bWPiSRbJxftKl1CF9wNDB0NaQvU+oixF5R?=
 =?us-ascii?Q?ZHNi2+TpuxL8x1TI6NtnRsD4I8fH35GEFtO2zvMXWEaoMeq3UVynrrlnNhpU?=
 =?us-ascii?Q?k+gQohcSOCr57PhILhCnkF//fAcso9r/L9BVgSn3/nBNcCoyQ6TVpG2hnO12?=
 =?us-ascii?Q?hcEI7PlQMUqIsUZiROYzSTjk6GNytYY+bL0AB0/FcncxwJnBM8m9Zzsq7Egg?=
 =?us-ascii?Q?/2pBsVxQBylgkw8XSjG4cmeXAX0Htir9hKHMF1nB/RnB/0By4nYEYOy2YlmH?=
 =?us-ascii?Q?oA3LkAqfi3qa4h9FNKgwDbmxLMh2YKZ/3p/RBzdJZIiuVk0H/huHl96c0d7Y?=
 =?us-ascii?Q?5N5dady3nLRbzjFg5ZyvyCYmXFeHcP4VoTFT25yW8P9gcGOWfaWUnKTSn0ji?=
 =?us-ascii?Q?FRs7wPbJZSAd2yVhCIIp7P7cub/6Hs9BQuXj07RZ0bLQMvKwaH8Ny+aucxk+?=
 =?us-ascii?Q?E5Z9qFPnHl0SCLMfm2d6sjPE4ZY2rjB9w6BB2lymmHKsuMHM/BVnyFD4vBGj?=
 =?us-ascii?Q?GO9DOwNXCSuNAxuWQf512sII6C3H6yZuG76LvrJIz0OcbqKt5wAH/+egrCFh?=
 =?us-ascii?Q?uvDAWPkE3bMsFZ/sSu+2Kx0yxYhMI0jg770QkGnA9UHsbeUitVOhVGCYFkuK?=
 =?us-ascii?Q?xKla9sJHgQqFhmbKauwvyyxN1x+b0uhGi2aNub8+CpwzAMH4r5hX+I6AmQzs?=
 =?us-ascii?Q?6uNRfpFmrFDucZlz21A94Dle/lCejdKgy4TQj2mAAYKNtlzhLS8iPksEwcOk?=
 =?us-ascii?Q?3fohWRnDF4KYvfSG3XkU7bUJJH3mPldmIZzBcax2efdEk1rjzbppmUZQeS2j?=
 =?us-ascii?Q?Mh0ou81A7iEDTggOkpbqhXczjPWygEL4xUm/Jq7ZL+eBByl8PfceFeSoRDkA?=
 =?us-ascii?Q?b3UIy0B7jwG/FikuFMbzpTPPCdPTgWC3/y4l6CHvqJymkT6Prxe9W9qHFO9y?=
 =?us-ascii?Q?UfWTPPWQmACtUTpzDFb0kmNqFcWU/bDmJes4SvwpyUGE66ONWSqUXAmETKTm?=
 =?us-ascii?Q?fP1BtGl6RSRKOkzCWONSH4vOxijEQjN421UzRqzT5J7L3nNdaW+3e3bloXfL?=
 =?us-ascii?Q?/+mBetlm4ERm4FjJRbXE4zF3CkSfAvF+H8cioDm8wu0BGF0CJBK7Ls6gQRZD?=
 =?us-ascii?Q?OW4sSRjjrnaXUNtj8omA83ISpnJCRpT554N0YZwSaHwsDyKnpxXOXySq8lTe?=
 =?us-ascii?Q?SfdighOUBUH0/7bzRwwErI8BZgQ1NTJ4RCpG6DB1jhTn02KstpbcDIVNVci7?=
 =?us-ascii?Q?Y1/c3185HDX46D00z+ZtSgUuwf0/xiydS32B/QfIXRSlkc3JPIOWcaHe0BMV?=
 =?us-ascii?Q?GIPrOWbTtvU8K9huiOjLaOaQgcRk7sDDzETEE0IJlFFqJfDdu38cEPLAOVk7?=
 =?us-ascii?Q?nizJ0crDAy4dnYL2F90AFR+hkXqc6FDCNKJdFn167o0BJUikalGZFGQd2l0Y?=
 =?us-ascii?Q?earC+fOY8tWo/VI2z7jQfKFbKQ5J+/mNFp9gP0KSQweOt4kJIThXGjJBbNRc?=
 =?us-ascii?Q?+IyGjaik5JmhdZmN/rhNDaB9b0vgeD1oXBotjQ4lwidg21vqLdWiXCU9h3+J?=
 =?us-ascii?Q?QfZEw+mr42KP9VGIFgyFWEyHY3vZgw8f0dX5KsPF?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a0c2869-5f47-4969-6a1a-08db098c338b
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Feb 2023 04:23:16.7591
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u0ESG0TzF0mVpCDYU8ti18ZRAmBzxkqU9X1Jracb1KstwmDHpY+m6K+vHMH6NXw8OBPAb9j+9IyR1x+Gixh1Ug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5275
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Tuesday, February 7, 2023 9:27 PM
> > >
> > > No, I mean why can't vfio just call iommufd exactly once regardless o=
f
> > > what mode it is running in?
> >
> > This seems to be moving the DMA owner claim out of
> iommufd_device_bind().
> > Is it? Then either group and cdev can claim DMA owner with their own
> DMA
> > marker.
>=20
> No, it has nothing to do with DMA ownership
>=20
> Just keep a flag in vfio saying it is in group mode or device mode and
> act accordingly.

It cannot be a simple flag. needs to be a refcnt since multiple devices=20
in the group might be opened via cdev so the device mode should be
cleared only when the last device via cdev is closed.

Yi actually did implement such a flavor before, kind of introducing
a vfio_group->cdev_opened_cnt field.

Then cdev bind_iommufd checks whether vfio_group->opened_file
has been set in the group open path. If not then increment
vfio_group->cdev_opened_cnt.

cdev close decrements vfio_group->cdev_opened_cnt.

group open checks whether vfio_group->cdev_opened_cnt has been
set. If not go to set vfio_group->opened_file.

In this case only one path can claim DMA ownership.

Is above what you expect?

>=20
> The iommufd DMA owner check is *only* to be used for protecting
> against two unrelated drivers trying to claim the same device.
>=20

this is just one implementation choice. I don't see why it cannot be
extended to allow one driver to protect against two internal paths.
Just simply allow the driver to assign an owner instead of assuming
iommufd_ctx.

