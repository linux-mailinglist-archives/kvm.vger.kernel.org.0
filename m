Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9191268C87
	for <lists+kvm@lfdr.de>; Mon, 14 Sep 2020 15:50:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbgINNt5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 09:49:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:37185 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726757AbgINNsy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Sep 2020 09:48:54 -0400
IronPort-SDR: jg0SIo0jWyreoGQTpKRoDxv/I8pRpsEA0B+/S1q/egFk34J9pspgzWdX21dgrGUu7/6ZtJ+aEP
 wt+rJ5TcrZcA==
X-IronPort-AV: E=McAfee;i="6000,8403,9743"; a="160011181"
X-IronPort-AV: E=Sophos;i="5.76,426,1592895600"; 
   d="scan'208";a="160011181"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2020 06:48:49 -0700
IronPort-SDR: nMuYZroYG0aHqjninmcir0TRYoyqiytXrYJdQa1HaxEEEwj91pzn5/I4JGTsbAmnL52pZkevyJ
 hKc6GpOZBD4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,426,1592895600"; 
   d="scan'208";a="345436238"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga007.jf.intel.com with ESMTP; 14 Sep 2020 06:48:48 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 14 Sep 2020 06:48:48 -0700
Received: from fmsmsx101.amr.corp.intel.com (10.18.124.199) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 14 Sep 2020 06:48:48 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx101.amr.corp.intel.com (10.18.124.199) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 14 Sep 2020 06:48:47 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.36.59) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Mon, 14 Sep 2020 06:48:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=On+r/4PwFdaezeCcEzaGvPQbu48i1L009356IpbJDj2RN98YSjlRwH5UCZLh5fz6xucpSAkI5y/TfuA9sO3SjA5cooe+BkjZMK9C1V9A14XlS6o67JN7B7wkO1ZxW1O9vVdgamp9iaksNwLzc5zbqJ9rXWwK9rndlZfaRK6hAaoUbUHOE6VJF82fet5jhnhBU628XPN/yS+gfG8zT1PRR8ueb3P6/MBiMmaaARXSwtsmQ8OjiiQ5hGpuYrRmBt9wxBO7hizuu3E3kAKXR66KUN6Pb2vVYjl/IEDZ6BM215K3s/R7JG4ywBERosccK/o9m67L5XKElY/bP5e628nf8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z5/P40981l0gFRl97qvG4USF7FfP+rzmdpQaVEYz9Dc=;
 b=lD+gaHNPoV6YEez1coM5E4IKcXFsC9c3bIf56Csy5Di/YmkGnATldaKDkCndqKpEF9mOtKYMH5hpGyALVYecTb2qgzF/qBQLsowAityasIXSj4KwcgjbF+BP0vPkq4AIcpCwuImud3oLKyu4VrhYZL0txbsONq07epZrYYw2UBNlTHf372W6gMCQmccyLgbUh9WxIYEBjylsRJlCb5/402w0DLAMKSb5YOjNHuPoX/ZIXHeHOi2amfI/klvMqDbyVI/MqsnnAHDknDb3B3WlppLWItDSnMs/z2JB8BHs7SkdAAlfVMgWd7Fm001VAj70gHypodX4pgc1PskvGK83oQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z5/P40981l0gFRl97qvG4USF7FfP+rzmdpQaVEYz9Dc=;
 b=QLEOwSOXE2R03H0mqMSZp4EC+/0bS4t6N2w8dRoQ7dMFhViSrKAlgamWBSuuo83RhXlz/iyNDclP47Pkhgl3Q92a4P/M+4pkNk888Egu44zF9Y/nvECJFY0AIAYWboQfvBWl8/zSvufOOtSLVvB7vkHxvd0ZERHRJwCHg+VPH8E=
Received: from DM6PR11MB3500.namprd11.prod.outlook.com (2603:10b6:5:6a::19) by
 DM6PR11MB4705.namprd11.prod.outlook.com (2603:10b6:5:2a9::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3370.16; Mon, 14 Sep 2020 13:48:44 +0000
Received: from DM6PR11MB3500.namprd11.prod.outlook.com
 ([fe80::18f:be0f:7a57:f684]) by DM6PR11MB3500.namprd11.prod.outlook.com
 ([fe80::18f:be0f:7a57:f684%6]) with mapi id 15.20.3348.019; Mon, 14 Sep 2020
 13:48:44 +0000
From:   "Zeng, Xin" <xin.zeng@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC:     Sean Mooney <smooney@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        =?iso-8859-1?Q?Daniel_P=2EBerrang=E9?= <berrange@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "libvir-list@redhat.com" <libvir-list@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "eauger@redhat.com" <eauger@redhat.com>,
        "Wang, Xin-ran" <xin-ran.wang@intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "openstack-discuss@lists.openstack.org" 
        <openstack-discuss@lists.openstack.org>,
        "Feng, Shaohe" <shaohe.feng@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        Parav Pandit <parav@mellanox.com>,
        "Ding, Jian-feng" <jian-feng.ding@intel.com>,
        "dgilbert@redhat.com" <dgilbert@redhat.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "Xu, Hejie" <hejie.xu@intel.com>,
        "bao.yumeng@zte.com.cn" <bao.yumeng@zte.com.cn>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "eskultet@redhat.com" <eskultet@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "dinechin@redhat.com" <dinechin@redhat.com>,
        "devel@ovirt.org" <devel@ovirt.org>
Subject: RE: device compatibility interface for live migration with assigned
 devices
Thread-Topic: device compatibility interface for live migration with assigned
 devices
Thread-Index: AQHWWW8W4wM4f8g8zEqJJrIxUjiNLKkJnOAAgABHiwCAAhL8AIAFR8uAgAnb6gCAAPsXgIACNNuAgAn8e4CAAKQQgP///oEAgAAG/QCAAFf6gIAAAa4AgAAZYQCAABZDgIAHp3iAgAR+pQCAAaChgIAGKisAgABceICAAAHKgIAABBUAgAAFswCAAo59AIAALZkA///+Q4CACJqBgIABDL6AgAObzICAAASeAIAEGmYAgA05qwCAAME+gIACQQQAgAADTYCAAFdUAIAAc3cAgAELFICABGarUA==
Date:   Mon, 14 Sep 2020 13:48:43 +0000
Message-ID: <DM6PR11MB3500BAC3B7056E348002A7FD88230@DM6PR11MB3500.namprd11.prod.outlook.com>
References: <20200825163925.1c19b0f0.cohuck@redhat.com>
        <20200826064117.GA22243@joy-OptiPlex-7040>
        <20200828154741.30cfc1a3.cohuck@redhat.com>
        <8f5345be73ebf4f8f7f51d6cdc9c2a0d8e0aa45e.camel@redhat.com>
        <20200831044344.GB13784@joy-OptiPlex-7040>
        <20200908164130.2fe0d106.cohuck@redhat.com>
        <20200909021308.GA1277@joy-OptiPlex-7040>
        <20200910143822.2071eca4.cohuck@redhat.com>
        <7cebcb6c8d1a1452b43e8358ee6ee18a150a0238.camel@redhat.com>
        <20200910120244.71e7b630@w520.home>
        <20200911005559.GA3932@joy-OptiPlex-7040>
 <20200911105155.184e32a0@w520.home>
In-Reply-To: <20200911105155.184e32a0@w520.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.147.212]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1d3132ec-298d-480f-ea81-08d858b4e58a
x-ms-traffictypediagnostic: DM6PR11MB4705:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB4705796943A0CF752AD489F788230@DM6PR11MB4705.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eV0vFtVwKN5jlm7ZLP9y7oPVYGG96GByNvwC2tqQ/sryZePKEgfAqKupQBZ5PsBt91StdCUNP7chC30RnDibPvk4oeKEj8iij1ocY4lT33QTrVcgPMNtEVYxBUecph9BILjaoc/NE/xp68BlCCAXmz50/Z0ZowiefqUJKjVm3iFJhhxxcdnGoz98x0NkyCJHScOtjCAqNTFDWnJeXGwvxOWfX2SLvHLRpj3Pk/5zlT+3Ti0V+Dzd0uUsUifwWz9hhVDgQJ6HDQKRlCiC7QDyQhVz9th0+gCuYWjd0lJDbo4eb3ZtDk/1L/yTPZT73KO1GEtGi+/G1ahQyvZnq9m9i67u0taxvqDYLp8YlpJhxEq6SmyhFVLSkLRu4K+dRS80
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3500.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(346002)(39860400002)(376002)(396003)(9686003)(66446008)(8676002)(6636002)(54906003)(7696005)(186003)(110136005)(2906002)(26005)(4326008)(5660300002)(76116006)(86362001)(64756008)(6506007)(33656002)(71200400001)(478600001)(53546011)(52536014)(55016002)(7416002)(83380400001)(66476007)(316002)(66946007)(66556008)(8936002)(21314003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: FcxVKrLs3mmVkmRqcIj5LAkMNxhkjiKzI0IHycBdydv3wPn6DmwPJEO/rR8HE6gREu8V4SFkXYHy6GNxItl1auVFm7fWMFHW5j5i95ASX5UqDTbb6L0Z6VcGrVjmJgIRdN4GBagmLGLk5Me+Mdu7AZl6otUKv+tu0wEvIwmYgymPyrfo8zpaCKBNcJKQQcprvCvuTUIkskI7mwCX2ccwZDg1qMzwOOjDnG/Th6TwBr2q1e7Efd3WdddkskAgOvifeLcDyLIs4nChkV6NRij026pvhw8/SWUQLwRD1qOGLikXK0unCPdyJ2Mv+5EsgEOQoWnUmN6dM5YCzjcqJif+YLzlmUshHgrx31YFzfpvMsSzLu9ejD0JW8iP6FF6tBFJTD7IVT5+e/ziT6STDAz7hWRhqcd8VJ+GIGKeZ3y5Kav6Z8sZeYdLSByU45FKQt3cI3m8YVibz/lF+OCqOxc695buGZcJlM3u7BFoQEZbNEHDHwJIbE2OcRY8ELrAfOLAB1vQvnPUHaQpU3g9RII5CQCuv9Kj3DcTNa16Lly73uWu+1nGbEoRyfVG3Rz8yCCZf9booK6Z9+aKClKHFB7Bl7QalLZc1OOLJZ8MQTk8ie33//6darUdsPNibGhxHC0vtLIb7ocyH2mQXeSHOX38gA==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3500.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d3132ec-298d-480f-ea81-08d858b4e58a
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2020 13:48:43.9120
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FZdGuP7xM5eKddmAhI1/oRDr3ZUTZwPkfuufWy98xChwYvFjziE5QlU0OM2L4gUQ9dk8zx8b6UQdepNxzpfKXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4705
X-OriginatorOrg: intel.com
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Saturday, September 12, 2020 12:52 AM
Alex Williamson <alex.williamson@redhat.com> wrote:
> To: Zhao, Yan Y <yan.y.zhao@intel.com>
> Cc: Sean Mooney <smooney@redhat.com>; Cornelia Huck
> <cohuck@redhat.com>; Daniel P.Berrang=E9 <berrange@redhat.com>;
> kvm@vger.kernel.org; libvir-list@redhat.com; Jason Wang
> <jasowang@redhat.com>; qemu-devel@nongnu.org;
> kwankhede@nvidia.com; eauger@redhat.com; Wang, Xin-ran <xin-
> ran.wang@intel.com>; corbet@lwn.net; openstack-
> discuss@lists.openstack.org; Feng, Shaohe <shaohe.feng@intel.com>; Tian,
> Kevin <kevin.tian@intel.com>; Parav Pandit <parav@mellanox.com>; Ding,
> Jian-feng <jian-feng.ding@intel.com>; dgilbert@redhat.com;
> zhenyuw@linux.intel.com; Xu, Hejie <hejie.xu@intel.com>;
> bao.yumeng@zte.com.cn; intel-gvt-dev@lists.freedesktop.org;
> eskultet@redhat.com; Jiri Pirko <jiri@mellanox.com>; dinechin@redhat.com;
> devel@ovirt.org
> Subject: Re: device compatibility interface for live migration with assig=
ned
> devices
>=20
> On Fri, 11 Sep 2020 08:56:00 +0800
> Yan Zhao <yan.y.zhao@intel.com> wrote:
>=20
> > On Thu, Sep 10, 2020 at 12:02:44PM -0600, Alex Williamson wrote:
> > > On Thu, 10 Sep 2020 13:50:11 +0100
> > > Sean Mooney <smooney@redhat.com> wrote:
> > >
> > > > On Thu, 2020-09-10 at 14:38 +0200, Cornelia Huck wrote:
> > > > > On Wed, 9 Sep 2020 10:13:09 +0800
> > > > > Yan Zhao <yan.y.zhao@intel.com> wrote:
> > > > >
> > > > > > > > still, I'd like to put it more explicitly to make ensure it=
's not
> missed:
> > > > > > > > the reason we want to specify compatible_type as a trait an=
d
> check
> > > > > > > > whether target compatible_type is the superset of source
> > > > > > > > compatible_type is for the consideration of backward
> compatibility.
> > > > > > > > e.g.
> > > > > > > > an old generation device may have a mdev type xxx-v4-yyy,
> while a newer
> > > > > > > > generation  device may be of mdev type xxx-v5-yyy.
> > > > > > > > with the compatible_type traits, the old generation device =
is still
> > > > > > > > able to be regarded as compatible to newer generation devic=
e
> even their
> > > > > > > > mdev types are not equal.
> > > > > > >
> > > > > > > If you want to support migration from v4 to v5, can't the
> (presumably
> > > > > > > newer) driver that supports v5 simply register the v4 type as=
 well,
> so
> > > > > > > that the mdev can be created as v4? (Just like QEMU versioned
> machine
> > > > > > > types work.)
> > > > > >
> > > > > > yes, it should work in some conditions.
> > > > > > but it may not be that good in some cases when v5 and v4 in the
> name string
> > > > > > of mdev type identify hardware generation (e.g. v4 for gen8, an=
d v5
> for
> > > > > > gen9)
> > > > > >
> > > > > > e.g.
> > > > > > (1). when src mdev type is v4 and target mdev type is v5 as
> > > > > > software does not support it initially, and v4 and v5 identify
> hardware
> > > > > > differences.
> > > > >
> > > > > My first hunch here is: Don't introduce types that may be compati=
ble
> > > > > later. Either make them compatible, or make them distinct by desi=
gn,
> > > > > and possibly add a different, compatible type later.
> > > > >
> > > > > > then after software upgrade, v5 is now compatible to v4, should=
 the
> > > > > > software now downgrade mdev type from v5 to v4?
> > > > > > not sure if moving hardware generation info into a separate
> attribute
> > > > > > from mdev type name is better. e.g. remove v4, v5 in mdev type,
> while use
> > > > > > compatible_pci_ids to identify compatibility.
> > > > >
> > > > > If the generations are compatible, don't mention it in the mdev t=
ype.
> > > > > If they aren't, use distinct types, so that management software
> doesn't
> > > > > have to guess. At least that would be my naive approach here.
> > > > yep that is what i would prefer to see too.
> > > > >
> > > > > >
> > > > > > (2) name string of mdev type is composed by "driver_name +
> type_name".
> > > > > > in some devices, e.g. qat, different generations of devices are
> binding to
> > > > > > drivers of different names, e.g. "qat-v4", "qat-v5".
> > > > > > then though type_name is equal, mdev type is not equal. e.g.
> > > > > > "qat-v4-type1", "qat-v5-type1".
> > > > >
> > > > > I guess that shows a shortcoming of that "driver_name + type_name=
"
> > > > > approach? Or maybe I'm just confused.
> > > > yes i really dont like haveing the version in the mdev-type name
> > > > i would stongly perfger just qat-type-1 wehere qat is just there as=
 a way
> of namespacing.
> > > > although symmetric-cryto, asymmetric-cryto and compression woudl
> be a better name then type-1, type-2, type-3 if
> > > > that is what they would end up mapping too. e.g. qat-compression or
> qat-aes is a much better name then type-1
> > > > higher layers of software are unlikely to parse the mdev names but =
as a
> human looking at them its much eaiser to
> > > > understand if the names are meaningful. the qat prefix i think is
> important however to make sure that your mdev-types
> > > > dont colide with other vendeors mdev types. so i woudl encurage all
> vendors to prefix there mdev types with etiher the
> > > > device name or the vendor.
> > >
> > > +1 to all this, the mdev type is meant to indicate a software
> > > compatible interface, if different hardware versions can be software
> > > compatible, then don't make the job of finding a compatible device
> > > harder.  The full type is a combination of the vendor driver name plu=
s
> > > the vendor provided type name specifically in order to provide a type
> > > namespace per vendor driver.  That's done at the mdev core level.
> > > Thanks,
> >
> > hi Alex,
> > got it. so do you suggest that vendors use consistent driver name over
> > generations of devices?
> > for qat, they create different modules for each generation. This
> > practice is not good if they want to support migration between devices
> > of different generations, right?
> >
> > and can I understand that we don't want support of migration between
> > different mdev types even in future ?
>=20
> You need to balance your requirements here.  If you're creating
> different drivers per generation, that suggests different device APIs,
> which is a legitimate use case for different mdev types.  However if
> you're expecting migration compatibility, that must be seamless to the
> guest, therefore the device API must be identical.  That suggests that
> migration between different types doesn't make much sense.  If a new
> generation device wants to expose a new mdev type with new features or
> device API, yet also support migration with an older mdev type, why
> wouldn't it simply expose both the old and the new type? =20

I think all of these make sense, and I am assuming it's also reasonable and=
=20
common that each generation of  device has a separate device driver module.
On the other hand, please be aware that, the mdev type is consisted of the
driver name of the mdev's parent device and the name of a mdev type which
the device driver specifies.=20
If a new generation device driver wants to expose an old mdev type, it has =
to
register  the same driver name as the old one so that the mdev type could=20
be completely same. This doesn't make sense as a) driver name usually is
unique for a device driver module. b) If a system has both these two=20
generation devices, once one generation device driver is loaded, the other=
=20
is not allowed to be loaded due to the same driver name. =20
So to allow a new generation device to simply expose the old mdev type for
compatibility like you proposed, is it possible to create the mdev type by
another approach, e.g. device driver creates its own namespace for the
mdev type instead of mdev's parent device driver name being used currently?

Thanks,
Xin

> It seems much more supportable to simply instantiate an instance of the o=
lder type
> than to create an instance of the new type, which by the contents of
> the migration stream is configured to behave as the older type.  The
> latter sounds very difficult to test.
>
> A challenge when we think about migration between different types,
> particularly across different vendor drivers, is that the migration
> stream is opaque, it's device and vendor specific.  Therefore it's not
> only difficult for userspace to understand the compatibility matrix, but
> also to actually support it in software, maintaining version and bug
> compatibility across different drivers.  It's clearly much, much easier
> when the same code base (and thus the same mdev type) is producing and
> consuming the migration data.  Thanks,
>=20
> Alex

