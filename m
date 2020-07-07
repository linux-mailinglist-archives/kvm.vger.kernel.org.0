Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 749E6217BA9
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 01:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728388AbgGGX2n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jul 2020 19:28:43 -0400
Received: from mga01.intel.com ([192.55.52.88]:29249 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728201AbgGGX2n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jul 2020 19:28:43 -0400
IronPort-SDR: +I19DDyjOFGERBvNvK3plgPjw9xzbL73j/50stKg7F1/lQZvhpk4bmP7yZry2LENBDmkvopKWy
 Lgj5vvpBpdxA==
X-IronPort-AV: E=McAfee;i="6000,8403,9675"; a="165784494"
X-IronPort-AV: E=Sophos;i="5.75,325,1589266800"; 
   d="scan'208";a="165784494"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2020 16:28:42 -0700
IronPort-SDR: 4oxk3/cdvQf9KWOVvw2bdegm7Z+HbeuThMFbBLXaAPYVA7XpM6SSldSWmE4ln9K36c+bj4JfRv
 6ENDZWJ+d+5g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,325,1589266800"; 
   d="scan'208";a="388654573"
Received: from orsmsx107.amr.corp.intel.com ([10.22.240.5])
  by fmsmga001.fm.intel.com with ESMTP; 07 Jul 2020 16:28:42 -0700
Received: from orsmsx115.amr.corp.intel.com (10.22.240.11) by
 ORSMSX107.amr.corp.intel.com (10.22.240.5) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 7 Jul 2020 16:28:41 -0700
Received: from ORSEDG001.ED.cps.intel.com (10.7.248.4) by
 ORSMSX115.amr.corp.intel.com (10.22.240.11) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 7 Jul 2020 16:28:41 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (104.47.46.58) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Tue, 7 Jul 2020 16:28:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oqd5hDwTOl89zGYAJjvmSWeN2XmXel82Dukae3dZ0JaxmAsYDTpO8foPW/iHj+ZmKQYqgRxneavolAuhM8gAVp5Utr/uJzmniVVYZeuCaT68E/24Q7uppSbhqVggblvjqUQF+Kp4aQbQ2HXywdI1GvIrzzldKTH7fmyVwGkDV/ie7eueTatynCIHlSKuNjVI6gpFejh9KR/LXPLQGVYOD0XizuoTZeH0p9y9amLtanfSbDtKuCwDPu40DQNnbHvs36AicNOvD6eoiqkPYGWP9+62m201n4YMvjbq0hClqRbNBVLVjihkP8X176oTlrWb8ot2kLroVdpW7pjDEpJbLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OsO+CJR3N/FdXnpN54tiXs7CZJMltgpVKjL3lvEHOGA=;
 b=jIcLatbDR+v9B6uHqDvkQNtoNN3zndCK0MswFbwvd37yiM+38xRrXKW09HvrZ2hjpuxxmsFmNKqIWpbTMXhxow+2q+UoszqePXAk8fivkT/NDFgqcTxBbXPE2sapOvlHFYjg5A260oD6bhQ9QfBI3SoIdOFLlyybySkqPBPapJuZS32O1YvPNOPc/fosxQj3SKrpBVK824o4aJqgQwC4HmL68kd2eygg20KtaXK4VLEm/Xf1ldtDnIA2agGcNI7uA0/7pdbaHtMOrpNjXjnX1ewHL4XLsAYsXVtX8frD8nFmRSUpi51WH8i6dncWiWyNbHWddYNefA0aaBYxJM0GSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OsO+CJR3N/FdXnpN54tiXs7CZJMltgpVKjL3lvEHOGA=;
 b=Uw2PGROvlkvV5WfUEDjWbNDG00EcMNHpvD5aYdiv5jYIYG8IG0ve0V78WEneaLuffkuxJhWrGuBAQj9LQPXUaVFjIE9gtsmP58N/aAhEnGUV5H/mmOtqsx8dAAeHHk8hlq4wMSrjunl+INp3urLXC1hLpe9+q6pQTTxIXkcVkMg=
Received: from MWHPR11MB1645.namprd11.prod.outlook.com (2603:10b6:301:b::12)
 by MWHPR11MB1295.namprd11.prod.outlook.com (2603:10b6:300:2b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20; Tue, 7 Jul
 2020 23:28:39 +0000
Received: from MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::9864:e0cb:af36:6feb]) by MWHPR11MB1645.namprd11.prod.outlook.com
 ([fe80::9864:e0cb:af36:6feb%5]) with mapi id 15.20.3174.021; Tue, 7 Jul 2020
 23:28:39 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Zhenyu Wang <zhenyuw@linux.intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>
CC:     "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: RE: [PATCH v3 0/2] VFIO mdev aggregated resources handling
Thread-Topic: [PATCH v3 0/2] VFIO mdev aggregated resources handling
Thread-Index: AQHWDWq7bB5+TEBrpEWwuv/xNBM+XKj9T7IA
Date:   Tue, 7 Jul 2020 23:28:39 +0000
Message-ID: <MWHPR11MB1645CC388BF45FD2E6309C3C8C660@MWHPR11MB1645.namprd11.prod.outlook.com>
References: <20200326054136.2543-1-zhenyuw@linux.intel.com>
 <20200408055824.2378-1-zhenyuw@linux.intel.com>
In-Reply-To: <20200408055824.2378-1-zhenyuw@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.200]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bad39042-54cd-4e38-0040-08d822cd7ab7
x-ms-traffictypediagnostic: MWHPR11MB1295:
x-microsoft-antispam-prvs: <MWHPR11MB1295747B58BE23CFC1A02F838C660@MWHPR11MB1295.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9ElWXewLTEQ/7tVEH/hbXyqVkhqrzaBn5ZnMIt9bf/wKOjZMrWBG+GUk3tBeOoBSXACFYIPDoqesNCXlshkOVTp7zgMdh/yCUfoK9NXBJ5sP4e2oG8hb3KmdWvMw0M9ni5eTfIUKVh8w+V1fw9l/3FAUwrGh30pAWD4V2SVTeRJTPn18LQHZn4Ymfubtm9ZcxP0QtiNjwsFHTWBWxIl34XeWvevrBXjINPJkADOhm+JBXlUaPM4y/KXUkyhAGZcM61IjBlRS9+QaZv78vh7TdnOicZGO1PUpo78nifI23KGCvYE1ZyIJl1ZAORlfUaGN/jsKOoU7qaU/bIhqnOwCRUaGSK+7lShnrJ1rPNCVTQKnswh+O6VJL7EHe3gLLLSFfdevnNGVAl+w9TdNY4P2+g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1645.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(136003)(376002)(396003)(346002)(5660300002)(316002)(54906003)(66946007)(76116006)(66476007)(110136005)(66446008)(64756008)(66556008)(71200400001)(2906002)(186003)(55016002)(9686003)(52536014)(26005)(8936002)(8676002)(33656002)(6506007)(4326008)(86362001)(478600001)(7696005)(966005)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: zi7YcVPwfVZIpIquvL4ELFg7MWK6NZD4iH4akSS/AsO9ltzDgTve89ZdUFPO2fYkju5nyk4mSWakoFCSFJUDwAbuTNgsKuTzDN+DmEYsyvFz8mUtn3QvtpUL2JlvlkWrqZw6yBqp8cjEmPLNxSM8SXAY6bl9zTC+vLsjmS2bcWJKZXnzvv5GSlLETqF8SQjfhKEJuk4SBtMO8cIT6WYcYNJqg9xflMZKNWxFd2WFZs8EUTHFBv0WlZfoJyMF1rFePo/EGgg2PU13lcdPR4jJpcKokZ6hq3kbZXhmnmTFk55TDLRI+0YUMxLpRTYnU33RCoKhfnrOmzi+kx6IRqI5pJpngig+LHYqvgKCKy9t74qPyQVO6S+jSH3UA5VY1RnpRb27PCRsUObppbkAazoFABp8Y2YKy1ea+K7YVxRkVuXxeaoOaoEH9IVo6IIcS8zij88uaETHZvK/mAQ3WGPgoze2M9qzFydTtaHcc6Zu6VD2ow3KZ0+YfPLNibS+Q40z
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1645.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bad39042-54cd-4e38-0040-08d822cd7ab7
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jul 2020 23:28:39.3599
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zHF+nRevcZGfrwDz7p8KNGwawQwIEoB9fnKhYSKiRPJqYo0qL7KgAgOR3oglCiIzF0aCDp5O4M89OQhy9l7weQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1295
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, Alex,=20

Gentle ping... Please let us know whether this version looks good.

Thanks
Kevin

> From: Zhenyu Wang <zhenyuw@linux.intel.com>
> Sent: Wednesday, April 8, 2020 1:58 PM
>=20
> Hi,
>=20
> This is a refresh on previous series:
> https://patchwork.kernel.org/cover/11208279/
> and https://patchwork.freedesktop.org/series/70425/
>=20
> Current mdev device create interface depends on fixed mdev type, which
> get uuid from user to create instance of mdev device. If user wants to
> use customized number of resource for mdev device, then only can
> create new mdev type for that which may not be flexible. This
> requirement comes not only from to be able to allocate flexible
> resources for KVMGT, but also from Intel scalable IO virtualization
> which would use vfio/mdev to be able to allocate arbitrary resources
> on mdev instance. More info on [1] [2] [3].
>=20
> As we agreed that for current opaque mdev device type, we'd still
> explore management interface based on mdev sysfs definition. And this
> one tries to follow Alex's previous suggestion to create generic
> parameters under 'mdev' directory for each device, so vendor driver
> could provide support like as other defined mdev sysfs entries.
>=20
> For mdev type with aggregation support, files as "aggregated_instances"
> and "max_aggregation" should be created under 'mdev' directory. E.g
>=20
> /sys/devices/pci0000:00/0000:00:02.0/<UUID>/mdev/
>    |-- aggregated_instances
>    |-- max_aggregation
>=20
> "aggregated_instances" is used to set or return current number of
> instances for aggregation, which can not be larger than "max_aggregation"=
.
>=20
> The first patch is to update the document for new mdev parameter director=
y.
> The second one is to add aggregation support in GVT driver.
>=20
> References:
> [1] https://software.intel.com/en-us/download/intel-virtualization-
> technology-for-directed-io-architecture-specification
> [2] https://software.intel.com/en-us/download/intel-scalable-io-
> virtualization-technical-specification
> [3] https://schd.ws/hosted_files/lc32018/00/LC3-SIOV-final.pdf
>=20
> Changelog:
> v3:
> - add more description for sysfs entries
> - rebase GVT support
> - rename accounting function
>=20
> Zhenyu Wang (2):
>   Documentation/driver-api/vfio-mediated-device.rst: update for
>     aggregation support
>   drm/i915/gvt: mdev aggregation type
>=20
>  .../driver-api/vfio-mediated-device.rst       |  22 +++
>  drivers/gpu/drm/i915/gvt/aperture_gm.c        |  44 +++--
>  drivers/gpu/drm/i915/gvt/gtt.c                |   9 +-
>  drivers/gpu/drm/i915/gvt/gvt.c                |   7 +-
>  drivers/gpu/drm/i915/gvt/gvt.h                |  42 +++--
>  drivers/gpu/drm/i915/gvt/kvmgt.c              | 115 +++++++++++-
>  drivers/gpu/drm/i915/gvt/vgpu.c               | 172 ++++++++++++------
>  7 files changed, 317 insertions(+), 94 deletions(-)
>=20
> --
> 2.25.1

