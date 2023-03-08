Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB8B6B008D
	for <lists+kvm@lfdr.de>; Wed,  8 Mar 2023 09:11:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbjCHIL1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Mar 2023 03:11:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbjCHILZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Mar 2023 03:11:25 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5A55A0F08;
        Wed,  8 Mar 2023 00:11:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678263078; x=1709799078;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zBD638sY2VW80Mn2rhNQrp8XJxqVH+QH+IJsb2frwNg=;
  b=gGb18Sb9a4SC6BG/9E2wazFSJJ/0lZq42URtobWhrl6NgkBv7fpl7ESp
   Lyp5axplJYW8dOVUT2Tb5CML94XPP/014pYOYWzNVO4d/HkQA95FttHbk
   e6zaEvq/pBfg3OR2QsJwj0fJn+uJB0ZZPo2LatOBtLJHrQ9RBIQxUB0Js
   g6sr/d5/Xsk7Rb1lL0hJpGZb9Oou5WW/1Aey0TFGfNvSYvaL+Z9/arYzT
   IDYE1iqDph9Qh0yMaAAd0etg4VuBCdsIVaQIBSoU/dqM/QuHdYV3MQApE
   agmXO/8Pvdbdch7AH5yvY8PKFhzx67n2T93g2EnEXLj4PAl0FCIHH+MfL
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="315756052"
X-IronPort-AV: E=Sophos;i="5.98,243,1673942400"; 
   d="scan'208";a="315756052"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2023 00:11:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="626828920"
X-IronPort-AV: E=Sophos;i="5.98,243,1673942400"; 
   d="scan'208";a="626828920"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga003.jf.intel.com with ESMTP; 08 Mar 2023 00:11:09 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 8 Mar 2023 00:11:08 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 8 Mar 2023 00:11:08 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 8 Mar 2023 00:11:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fovBwzBQDGxsdp0XX2DoYhJPIr+pv1ZQCh9Zbue1ZxGRTsi2A6TUCigLIdnFxDrYhEioses6sHlctRE3dbOdGpV5yvJTyDxHzRmkhB9vrE8v7ECdIt/mUt9jFv1l2JHvV2iV5ev0aChybBQ4HNILgahvSraiuDzqt+ZMvdnD4R1NzdorDJqKSlBPGJ4RYC2oXDb+Dk3frXhnXiUdQxpFZZF+dPVqrv80hAt+8PTtTSb669+RDW+26MmmS9d8U4Tpdaro599M3pg35LCifWEvufNrqPZ0ZfpihoxhmDJal1KaWnrGK5TCQLL9rb+KUq3hSPTZlpyLrQOm6KFE1RWzgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vmpTM8Li09CLG8b6OAunKcmGEXS428JXZ49SviOsPwQ=;
 b=UAYmN+ca32plD6PS9VoF1Jb8Wf5djws1OAGhYNfNGH/rX2jiURuxYV1R1pqckGJTL22N2BXM9HdssMNnh+hKhpSS0GkBvXuvr8hyRnOPKvzn0eJn/UymaOzkfeekNh/SJUgFevBD6J241f/Bwov2caQfblZWQIuJmK3T9yI2FWlhl+GV0KPI8PZ7AtWsSy0wZ6h8lFJiK1Aq9Ghb1o/AF4zrXHuLW79nmyIecmEXUOANNyhoQthL00G3IYHVrl0ZZiSMQlEgjaRpqRDShx8CFczfb+PrJzvDryG8Ft6ZllYRENMZ4wpwP1SoDV3ckCwTVqmgK0n9Gw3MeK8aQAEHAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by PH0PR11MB5926.namprd11.prod.outlook.com (2603:10b6:510:14d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Wed, 8 Mar
 2023 08:11:05 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::1aac:b695:f7c5:bcac%8]) with mapi id 15.20.6156.029; Wed, 8 Mar 2023
 08:11:05 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Grzegorz Jaszczyk <jaz@semihalf.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dmy@semihalf.com" <dmy@semihalf.com>,
        "tn@semihalf.com" <tn@semihalf.com>,
        "dbehr@google.com" <dbehr@google.com>,
        "upstream@semihalf.com" <upstream@semihalf.com>,
        "dtor@google.com" <dtor@google.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "abhsahu@nvidia.com" <abhsahu@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Dominik Behr" <dbehr@chromium.org>
Subject: RE: [PATCH] vfio/pci: Propagate ACPI notifications to the user-space
Thread-Topic: [PATCH] vfio/pci: Propagate ACPI notifications to the user-space
Thread-Index: AQHZUUEbYUNRuSCltkm4EZaoKYZWuK7v+k0AgACK2yA=
Date:   Wed, 8 Mar 2023 08:11:05 +0000
Message-ID: <BN9PR11MB527645F3DFD7E278D1C652A48CB49@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230307220553.631069-1-jaz@semihalf.com>
 <20230307164158.4b41e32f.alex.williamson@redhat.com>
In-Reply-To: <20230307164158.4b41e32f.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|PH0PR11MB5926:EE_
x-ms-office365-filtering-correlation-id: ffc366ab-2340-4f55-6a8a-08db1facaa62
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WiX8A2WPzVNNmBx7KIT4IG+hQ+CEgGTIbgjd3OQnRONn1EUVRTgpzFc4d3To/nfApDbwQPzLH5m0hZeTdtVqXbNuTLdoG4dwAR5+aJ8+/R0w9quVGgBcBunAkinI7EU6/QPX0m+MXZrbWeC73WclRZXUJDPa+ryMhxgEsoAhImJh3W2mA9iHUG2V1mDvzK4AOjIdznwecDOGePl0QLv1miMTDjy4EVTe/CX0rJsJ9viwTdAEgSk8l06pDLg4JoqH6YjZaLThFseVpqDZxwkNO1b21XloUfNoEH7c0U3cBsw0Mhnwh+IYiLwBbp+sIBgQf+UQKmhkJ6B8FDCx7SNuf1rpttAbGdkz2etmrc23C5iarWuTCdZKOgsK3BJVSUixPwOJekjpmMdqvjoFuRi+hssQyBh0OlSCFHOoUJDqEI3HdUmJ7zrvfSkVwKwSPnk+qrq1NqzeVsyiK4w9z1MCLyR4K3TBoXwZVTcAayyj/Fbynb8O+ksDBX6K155PW9w5CA+wgW3o/FqqIgbv9tnAA6pYH8wS3K+acBmjsPtEJOGWGo9ri5fl2fUluWxjX21gYgjNlZ7ljZGymPSjModzwnlBMwi/V7rjPnZ9zKrheLdhCvzH+XqMvJxkoNWs85LfxUI3xxexhrJdcNfN3qMBl0Y0bf3rkfP6ADvUSgqozPy8AgW8abmTxAg47603de+9DFe8XnQp/x3WLB3nMWQrDA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(366004)(376002)(136003)(346002)(396003)(451199018)(76116006)(86362001)(38070700005)(122000001)(82960400001)(38100700002)(33656002)(66446008)(4326008)(64756008)(7696005)(15650500001)(5660300002)(66556008)(7416002)(6506007)(66946007)(8936002)(41300700001)(2906002)(8676002)(66476007)(52536014)(9686003)(186003)(26005)(83380400001)(316002)(478600001)(54906003)(55016003)(71200400001)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?QL/T4orWsXeDFJ1HH2BaAIm5y00LalofnVYwusFuAL5iNyrwOGpYS5BMzAOB?=
 =?us-ascii?Q?oNeH56OgV+y5tBoL473zfXiqwsL5SPepurOm10pe6JQGHUOClaQMs4qUBOMO?=
 =?us-ascii?Q?dOW4SXZXR+1WTXbcCAnY2DP7t5JcK6l8ovtP0j0xKF76rPg8tREKmRzGu4oJ?=
 =?us-ascii?Q?pl+Q/wlBEimKUOaoF4uO5ZpH7AG2Xb9+UZIyyy9nauGUfP1KCDHn+b5pz4OW?=
 =?us-ascii?Q?dc2TKOxFnGDPgO8sPoCxvgxtvtbgeE676vycx9fuU3ap7nG8eKOp29mzolKk?=
 =?us-ascii?Q?nOcaMnWfBi2jDthfKkXFtnYMBXn6/p0SDanjW9h/av3ULvi/Y7W1065q610s?=
 =?us-ascii?Q?G4O+WU7wovfekcJarfEjVzo5UU2T9diRhIgrNnMBnK1Q5BJo+Wk8DL3ZHMoY?=
 =?us-ascii?Q?ogWIIbtS+93MtoY8JKgnpLH2N9r3cSvGYNG24HG7PG4ZUkJ14SWjTwRYlEag?=
 =?us-ascii?Q?r88TQWllWSDxJsoa0ZV/nF5eANtfGjH2FrSOkbA4A5xaSEibpzHtBdpEy7pF?=
 =?us-ascii?Q?xT32KiIvLDIlC15m0QDobLy/C2pgSJQ721dYUBdJY3TC+i6lyGRdm2Z9WGd3?=
 =?us-ascii?Q?nMpGJwHA0160Mp0y/BqxmgU4MSLvs/XOUhDwiV2zECtxdqKoMrKWhugL7yJv?=
 =?us-ascii?Q?fYEHhrhf0eiu7qF7o11kZoMgyIpig1rD0VZTDqdqQN8ePnpAAB2ZgfJNnNbB?=
 =?us-ascii?Q?WWUKWDpf5WN6JqaAnLU6j02wwSAUreqpYJWpHSMFpiAdGlvxq5UhVzW0l7Yz?=
 =?us-ascii?Q?i/jiBtSc+xxaCUFn/pDvM6zs+Zyv3dLrxpFPNeKHLU80kfcESAuED3HBHDVU?=
 =?us-ascii?Q?0N7TRvLopVmji5MlsG6dJr3UQP7lYgKaR6egv/ALYiL1laBuguTwl/lACN4K?=
 =?us-ascii?Q?OZXxLsYTGZn0gzNYqRJKQ8iZuNkkJetX+NU+t5QP5V4lauwfMRXFYcKfH60u?=
 =?us-ascii?Q?YPVjKCqqneH09lCk0sR4yx2H4glVlP0E2/lal8WNfi8ijC21Uspeul4n1UGD?=
 =?us-ascii?Q?PcFBb/8A7VgpyVuruuQfJCj295jZoplHBEjCgnsCe46iuLpIz/yPp1g2N1VL?=
 =?us-ascii?Q?ck54yapQz1ThrR9qiaV+qU/biP/AHjjBDOwJsv0b3R+YpgbynhyDTuk/XEqe?=
 =?us-ascii?Q?D6EwYs2nVDX3K6sslucZGjnU45MYwYVisyyGW4euEUgR3IdSvCupLM/x9z9h?=
 =?us-ascii?Q?gBapD3dI73qp08zydtrkljMGRBSffFVcxPqzVPVmXCoIt+mz47yP5RPu3AUF?=
 =?us-ascii?Q?8E4Aa7HkFMNr5Enc0pfv4aK3Huw+KaF+8P12C4FgnidbEc3OMNVdxkRyZpKU?=
 =?us-ascii?Q?/43lUqrqOm6cGCaB9o/YjkZsoxR2GUR4CPRAHQB0bXKMqtT4m/uSGN/YCidM?=
 =?us-ascii?Q?3FYAI6/jje6w1FuI57mQPi7bHDXDNq1NSCcG68yY8z522BljC+nkwXVGKij+?=
 =?us-ascii?Q?O2Iv0tD0uiq7xxN/WKGirXbPFpoFXAI+xFWaLccmRtSqt4p4MbwtLlCrH47q?=
 =?us-ascii?Q?7vSt9BBEhyxbm2bU5FSnweY3xJaC6HHDmkByc4Ue8wISvHWBBTx7+fh3ZX3c?=
 =?us-ascii?Q?Wgs/nv9G0pUgAEGwqdue1F68gZcr97WskdytUHts?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffc366ab-2340-4f55-6a8a-08db1facaa62
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2023 08:11:05.6313
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: n/Th7zQnhDvPslpgcT+0kOVY59uKcxGCGljrHT7V5lUtOe1+JXRsuJbZwrltW6yWc2RkuevZLM2J/HE9KNzbSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5926
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Wednesday, March 8, 2023 7:42 AM
>=20
> On Tue,  7 Mar 2023 22:05:53 +0000
> Grzegorz Jaszczyk <jaz@semihalf.com> wrote:
>=20
> > From: Dominik Behr <dbehr@chromium.org>
> >
> > Hitherto there was no support for propagating ACPI notifications to the
> > guest drivers. In order to provide such support, install a handler for
> > notifications on an ACPI device during vfio-pci device registration. Th=
e
> > handler role is to propagate such ACPI notifications to the user-space
> > via acpi netlink events, which allows VMM to receive and propagate them
> > further to the VMs.
> >
> > Thanks to the above, the actual driver for the pass-through device,
> > which belongs to the guest, can receive and react to device specific
> > notifications.
>=20
> What consumes these events?  Has this been proposed to any VM
> management tools like libvirt?  What sort of ACPI events are we
> expecting to see here and what does userspace do with them?
>=20

and the VM sees a virtual platform and virtual ACPI. Usually an ACPI
event triggers parsing-executing certain ACPI function which needs to
further access platform resource. Presumably someone should copy
the related ACPI function into virtual ACPI table and then in concept
we should allow an ACPI event routed to userspace only if the related
platform resource has been assigned to the user.=20

What would the mechanism to audit it? and if we have a way to do it
probably the ACPI event would be translated into a more generic
event mechanism in the vfio-platform driver covering related resource.


