Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B7BA6BC616
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 07:28:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbjCPG2p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 02:28:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbjCPG2n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 02:28:43 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85C9315577;
        Wed, 15 Mar 2023 23:28:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678948121; x=1710484121;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=A1wKAaulQuklCOf0iyCj5OxJ0ZRDY7L2Oz4zzltyw6U=;
  b=LoTfUoHGCxtUXz7VYAsL7ZA1YbfICCPT9b51LWGPv+hARAivwhOpize7
   bfdryKM8ftyMw6/bpX+xaa2kWhyVPeEgjHqyX9BUgT1Q9fHsCSItJuvNt
   orvFspRwkhjAM8tt8wOfuRF14sxjB4iMCjBWz6Uyn3cPHvzcsnQrpte56
   nd4QwWTYG4jOoxDAp9pCvZvgKkgUhocNOszwVTOdMKApLm17TrcLwqbCZ
   dwI+1wgGcb7qTJY7BgpgMB2/InZkpiJvHfDGuuYmy+k55cj2fo9KdGIxM
   yEqGPkQaZei6sN8pX4BzrQ45QmvczYyHphd+jMwcQ8o97Y22RFbVkCPDq
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="336595832"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="336595832"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 23:28:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="709962055"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="709962055"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga008.jf.intel.com with ESMTP; 15 Mar 2023 23:28:39 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 15 Mar 2023 23:28:38 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 15 Mar 2023 23:28:38 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 15 Mar 2023 23:28:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tfx+kbUslSWvdmMJj7RuOxV4o12eF66LTM5g6gdXM7npLzrEMCHIx1K7j8F/XJ0pJogttefRQYYmN9cdBgcWwnLgURhs+yge0plLF2T0flWaIkpoDkuCp73KsrofrqNiO+WBeK7tQ/amKwCoxqz8C2erb++as1Oa6E3p9NIDULTh7YnLeXYbIWtoj3yvhU1f5bo4vFPZHx22GYdVPwUwzi+2BYnSw2TlSqW73KEvbYsO93sGL8LmITmYXYiOQFjn0+YCAr2NJkHA6s0KhDfmaWTz+TjlvIi726b6sj+ng63TIznq0ROn+os5pJpPL2vTXCIPAo1uReKfaSFy2Sd6jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tp9RzNEDmxWWloS0zNh1FTW4tAb/qtAFdGCZW+9xdoo=;
 b=MJKqNXPpoMPFB3efnLWVl+JmU3lu+o9XFf6wRhljG81INapm7vG5iWgcREtljF2IcPAo1KGj+ZZ4DC/PzdqRW2uVBmn1B6D68zvp/+k97Jf9aj00ICyZMjoKfT8CuxIkVPCBPj751TsopKiy/pHtiOsc+lZVBam6oqiXc/IoxObqSlobELNLrbsw6BfhEzuwwbaTj02mv05TH3P2iUr8Gjz3Vlk7RYeSgnQDl91vrXTeQ4Mryq0PxCdGzB63wkm8f0lKo+uo6WrQHK+q+tDJ3ZANTbuK59E2v+UchrNXzpiiibnoFxP6J9+Z1eV4Rz7J6RVLlVaI+6JPc661rIfdEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DM4PR11MB8227.namprd11.prod.outlook.com (2603:10b6:8:184::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Thu, 16 Mar
 2023 06:28:28 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::6f7:944a:aaad:301f%8]) with mapi id 15.20.6178.031; Thu, 16 Mar 2023
 06:28:28 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     "jgg@nvidia.com" <jgg@nvidia.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: RE: [PATCH v6 12/24] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Topic: [PATCH v6 12/24] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Thread-Index: AQHZV83ljxjAAYqHzEGGeM++m5XIpq787Jlw
Date:   Thu, 16 Mar 2023 06:28:28 +0000
Message-ID: <DS0PR11MB75293503F92A24A716DDE2C6C3BC9@DS0PR11MB7529.namprd11.prod.outlook.com>
References: <20230308132903.465159-1-yi.l.liu@intel.com>
        <20230308132903.465159-13-yi.l.liu@intel.com>
 <20230315165311.01f32bfe.alex.williamson@redhat.com>
 <BN9PR11MB5276300FCAAF8BF7B4E03BA48CBF9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <DS0PR11MB7529C7D0409B47430D7412C5C3BC9@DS0PR11MB7529.namprd11.prod.outlook.com>
 <BN9PR11MB5276ABE919C04E06A0326E8E8CBC9@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB5276ABE919C04E06A0326E8E8CBC9@BN9PR11MB5276.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB7529:EE_|DM4PR11MB8227:EE_
x-ms-office365-filtering-correlation-id: b6d6f04b-f1c1-44a0-8690-08db25e7a793
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 469hpfEVYmQWASLtrvxTNiqK/oCxcYgCo5bfxjjs1uUseE6USALOXnfImmgbMHVKyKmpr5nwksZTbq/D3IA6K6GAVNfZ1cu/2BFPKB3ZVotMvUZob4aRRIZoC3jyar394Iz7caThpyyvSwHTF2A5ZDhY40kIFSS+I75fvvRpLDT0lxRaQXMo60DDjHswo0HiddFYLL49ciq3DFaW1KnJ5Hecb8o8Dl8LlfSa1xpKT3eHE22e0U+A4iH8OMxSOqI9l1d7wzaA6KploAJtewAQoL2IWSqt1o8eAvdLdZMQ5a7cAN7Kgqf0M+hN4HThrB+QGwpf/+aoWml5CLA9HJwKz47jAZUXWtsm92PotKmMo3QROrpiIDQ6OYcnIcU9OL2VpU1mvzgleV+fbgxe+xXzBvEAg8hO8GYoABve6KBY4pEgQh/+wEUWu7UDDTrh6vL9fbNcVU3Xfm1gR5oGIFFVAflpr4lexPXTv/Czi5sHW+QrBPmxjKddnxBBRxBuRck41/PMaBdcSDckzdZ53LctTx7w75UG+8B8aKCPoDr+UJ9p3wuzVggmm6Oukudkz3kkMwZQEEv+mCPdGrTr7nYiwO8gcyANOc9A/OKK1rhResL9pqwzsy+RxijmlIZUXQrDS1cRdVrHD2+xj3+K2W/QWHvLxNiLqq4C7eW4UCxTJ9FszEdtpbONzZcMFXGfEelyE9MCfx9Igx9jW8kdsnVzww==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(39860400002)(136003)(346002)(396003)(376002)(451199018)(8936002)(7416002)(5660300002)(41300700001)(4326008)(52536014)(33656002)(55016003)(38070700005)(86362001)(82960400001)(122000001)(38100700002)(2906002)(9686003)(83380400001)(186003)(26005)(478600001)(7696005)(6506007)(71200400001)(76116006)(66446008)(64756008)(66946007)(66556008)(8676002)(54906003)(66476007)(110136005)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?CwktWIp8Vm/VkKu08NazOY3xSXR22HMJIRwMH2vZGKavtSbuM7iG6sU6fm1k?=
 =?us-ascii?Q?kUXd3iSPXshP05DrVib7rWZK3GpD+MRPBBugnn1cQeLnxu1uEUqBLGkLTSOb?=
 =?us-ascii?Q?yPlTatTRMY/KT+x2NpvJLHUaj3FBBkXizFrKnCsso4gLL4e/8QbmdQtz0FB6?=
 =?us-ascii?Q?dm2mf7QT/+m4Xq8BDoNQr1cq3mPgSS/fqXjwXNDmxkF0sBqtXb/hyXJZv8Tl?=
 =?us-ascii?Q?9LnWstMbTpYei4fy9M/K50y8swG7KqwwTDu5E0JBatXCdq4ZTTtVHt7YaL7q?=
 =?us-ascii?Q?p8PhdWi7XTpQ1iE9PbXIK76+yIcCLp4unqPcG2WtgfLSjFqtsq/jmtsY3hff?=
 =?us-ascii?Q?c8EWeolyQsbwAxfUfDZ+3g8mn8W6L8JY5MjQx4IyisKBLVYn1dT2JL06A+e3?=
 =?us-ascii?Q?610ANlts6uHkOFgVlhm3r5VXZ0uz2rE/zjEXQSCxu46rPzjSienWznqEGmSM?=
 =?us-ascii?Q?jGOTetGZ0hAHHbiQe7XBL84nOxNfCOk6XkToWQ7DxVs2IDPiTOqzuR5sNPwg?=
 =?us-ascii?Q?4LnuZz3yS92M+IxpheXOy/J9nJdlixa0UsPuixp5GG6hOr7HwGT0rKrvqxIE?=
 =?us-ascii?Q?OlcuDkQC9765keAlkFDkE+9vj5aUxkVe6SXn3jdeuuqKp9bfmhqNggYFZ1u0?=
 =?us-ascii?Q?oWrQi3QH5fX47KW/Au6xggidBllJJ9lmT3ttzM11j8gLXLevl2AyWTcFfb2H?=
 =?us-ascii?Q?l82KETT14EXrGLjS8TYNMpXNiR8Mk1NuFjHyAeBymjQp+YBZMT7bK+VP64JI?=
 =?us-ascii?Q?fkPSAJxTTxgKb79mgBZZRGHEcko3YKbWx5yS8T2fwn9hG9UcJDyv2XqPrhkL?=
 =?us-ascii?Q?u61F7VC2L5EsbGfIh6RAgkZjRQ7ra7ie4i/gbifJM3UTaAqHzxg9DJIKQ2aY?=
 =?us-ascii?Q?JYCxO+IEPFjWMSJxr4Nr64L2t057e7ESsKnaNKw0m93sbzil2jITp1o4r/4o?=
 =?us-ascii?Q?TMQSskFuPJpKGc59Eqo6aT9e+mEKDyMzlla16EU/PKtt7s43DKQn45pjPgKN?=
 =?us-ascii?Q?pIC59vMusAvsV+iNPiYNJi5tyCcuH5EYmT/31zsmCj2ZOdMx9LM3Mkh89uN/?=
 =?us-ascii?Q?k4A9dkr99eVl1vKJ/SC/kXrEIjtu/LWJt3IV+KMUI9NFIaJXtkI0ietwblwO?=
 =?us-ascii?Q?jlyFJdIpSaHvqAXvUU4P7mymwz6i4BvCLA2yyrDoCjlVPup9pu39swlJqpk+?=
 =?us-ascii?Q?sc7JdczMUQd4Kz5sNtnvpFrCh+wPXFm50IsLWwzZu6mm15QtzPfgS+zXrTl0?=
 =?us-ascii?Q?d4NhVr6lxDjHfj8guMsqGDLWc9EAk8wW6fcJCCYWBvOt6iyqgrQ46x2JITTg?=
 =?us-ascii?Q?e24gPVRsHkqE4gO5MmFOd+X4C7eYNia+VfbY2GBuajTbCYa50oeHu7Hk3G7W?=
 =?us-ascii?Q?4em3AUqBtX3W0k7Q9KojTkX/ycYvVOXfxpt4n5uHMnsoLFUcHTI4nEYDghy/?=
 =?us-ascii?Q?6iOFOpS6OxQHRSjIqXB4JRA+4/lRU2EL6wJIpy1uASpLFqsoFnpS7J4pG5is?=
 =?us-ascii?Q?5tV8TgZFb5uocG35TTnzMqYWRrmQuSlmEpCEV1wFMlzBz1jrti/0f1Erdm7J?=
 =?us-ascii?Q?Oe7O+2nTOmg6T0m9oSn7SaEGoJNlgTSfKhV4FEY5?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6d6f04b-f1c1-44a0-8690-08db25e7a793
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2023 06:28:28.1567
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: l3RyBwqD2FMsw/g8OCzE3Y1Dgldk4iUhhWbzNDysYiPyLvzoyospV5F7Mbi18CKyw1/HWSUdj45t2BZtGxRjvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB8227
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
> Sent: Thursday, March 16, 2023 2:10 PM
>=20
> > From: Liu, Yi L <yi.l.liu@intel.com>
> > Sent: Thursday, March 16, 2023 11:55 AM
> >
> > > From: Tian, Kevin <kevin.tian@intel.com>
> > > Sent: Thursday, March 16, 2023 7:31 AM
> > >
> > > > From: Alex Williamson <alex.williamson@redhat.com>
> > > > Sent: Thursday, March 16, 2023 6:53 AM
> > > >
> > > > On Wed,  8 Mar 2023 05:28:51 -0800
> > > > Yi Liu <yi.l.liu@intel.com> wrote:
> > > >
> > > > > This is another method to issue PCI hot reset for the users that
> bounds
> > > > > device to a positive iommufd value. In such case, iommufd is a pr=
oof
> of
> > > > > device ownership. By passing a zero-length fd array, user indicat=
es
> > > kernel
> > > > > to do ownership check with the bound iommufd. All the opened
> devices
> > > > within
> > > > > the affected dev_set should have been bound to the same iommufd.
> > > This is
> > > > > simpler and faster as user does not need to pass a set of fds and
> kernel
> > > > > no need to search the device within the given fds.
> > > >
> > > > Couldn't this same idea apply to containers?
> > >
> > > User is allowed to create multiple containers. Looks we don't have a =
way
> > > to check whether multiple containers belong to the same user today.
> >
> > Hi Kevin,
> >
> > This reminds me. In the compat mode, container fd is actually iommufd.
> > If the compat mode passes a zeror-length array to do reset, it is possi=
ble
> > that the opened devices in this affected dev_set may be set to differen=
t
> > containers (a.k.a. iommufd_ctx). This would break what we defined in
> > uapi. So a better description is users that use cdev can use this zero-=
length
> > approach. And also, in kernel, we need to check if this approach is abu=
sed
> > by the compat mode.
> >
>=20
> In normal case legacy application uses group fd array and new application
> with cdev uses zero-length approach.
>=20
> In rare case an application which opens /dev/iommu but opts to use it
> as a container in compat mode can also use zero-length array to reset
> if all devices are attached to a single container (internally to a same
> iommufd_ctx). It's still kind of matching uAPI description.
>
> I'm not sure whether we want to add explicit check to prevent it.
>
> Of course if affected devices span multiple compat iommufd's then
> it will fail.

Yes. this failure matches the uapi description. And it is rare case,
mostly likely applications should be explicitly updated to use cdev
and then use this zero-length approach. Before that, the legacy
applications do not know it at all. Even it uses this approach
by mistake, it will fail in the multiple compat iommufd case.

So maybe no need to limit it.

> The open Alex raised is whether we want to further extend it to
> legacy container if all affected devices are in one container. But
> I hesitate to do so since iommufd is the future and if an application
> can be rewritten to utilize zero-length reset then it probably
> should explicitly embrace iommufd instead.

For this, I agree with you.

>=20
> Anyway let's not wait here. Send your v7 and we can have more
> focused discussion in your split series about hot reset.

Sure. Once Nicolin's patch is updated, I can send v7 with the hot
reset series as well.

Regards,
Yi Liu
