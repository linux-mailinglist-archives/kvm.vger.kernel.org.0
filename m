Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4EC3D866B
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 06:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbhG1EGB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 00:06:01 -0400
Received: from mga11.intel.com ([192.55.52.93]:4107 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229495AbhG1EGA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jul 2021 00:06:00 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10058"; a="209463568"
X-IronPort-AV: E=Sophos;i="5.84,275,1620716400"; 
   d="scan'208";a="209463568"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jul 2021 21:05:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,275,1620716400"; 
   d="scan'208";a="517263166"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 27 Jul 2021 21:05:58 -0700
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Tue, 27 Jul 2021 21:05:57 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Tue, 27 Jul 2021 21:05:57 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Tue, 27 Jul 2021 21:05:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KOzpEg63hsN55ZxY0UDi35HF9Zc4JG/RBu1gc0aS0tdonU7HKEVSP2o34FaueUICXqGxHAMO8M8MgIy5/IA3furvAJ8Sj9IuQqLsW+g9UavIi+C0wsQY5zB5UghxRNfpcbD+14P9m8PTJMPQSFx363rcjnBdcp6Dv+cR1ZIMPE02Kvve4DLqeMMA3TdK+/vm0TZLFvBFWY6q3HALt8CD/TnCLLpB0Jnvd4hy2Kyw8n1ZWz/XlLC8L/k1CN3eXBqDPaeI7l6nNDuciMFsb9ON6WN6wkzT3mV3Vpurnbfm2gYeOiXUx6NQrL4vgmMlGTaaXvwjfpsVI4o5ihc3sxTB5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IqaFBr7jDo7BSxNbUsq2HAZcFeEHxnuMIJyvK/W6Ngk=;
 b=i9qE9r0ovqpdHGv1YB1rwISwD1H9iz5N5XVW33B76SyAmQcecwgIA0YmSZVYMZCVx/w7Zy22LAb3Vc70DpBsfQifY7Ti0Aii3d1a+VKk7zFJSmEydowXSd5M67Fi1HnriPDUSCiSDiVL9B9zMwJSB3MfXr5NYmjDIoVoImn/GV0ROnkYvnYQUd7GokgTuZnzem/XAolx5xs254Exx1DfzaWp1qMOMPn7Wvw07Tu7DkTwqneoh7XTlTb3poEX8VNBy3V6JpavTJOz+oJz3HWXKL3Wjm9CDvJAA2uVu20OXs5244yw4zo2LM3HFY2xL5+jGbjXlZ9EAigHMaoP1jkLjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IqaFBr7jDo7BSxNbUsq2HAZcFeEHxnuMIJyvK/W6Ngk=;
 b=pxHscYxv/QPyDcO5Mi0opeo5synaP1EL1l2Pi1vq/yAJBlOidxvhoEXhv2TkPrVRQ76NHY4JDeFBXjCe/kaCYDkGB56F5BGLFgk0QW3dZN1/x7AsvGqGEbDYm8Z8kUdQgPTLXHALaXTlblTD8g4UWxB4A3oPj7Ui0f3di95R5oM=
Received: from BN9PR11MB5433.namprd11.prod.outlook.com (2603:10b6:408:11e::13)
 by BN0PR11MB5709.namprd11.prod.outlook.com (2603:10b6:408:148::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Wed, 28 Jul
 2021 04:05:56 +0000
Received: from BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::fd4b:cdde:6790:134]) by BN9PR11MB5433.namprd11.prod.outlook.com
 ([fe80::fd4b:cdde:6790:134%9]) with mapi id 15.20.4352.032; Wed, 28 Jul 2021
 04:05:56 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jean-Philippe Brucker <jean-philippe@linaro.org>
CC:     Jason Gunthorpe <jgg@nvidia.com>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Jason Wang <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shenming Lu <lushenming@huawei.com>,
        Joerg Roedel <joro@8bytes.org>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: RE: [RFC v2] /dev/iommu uAPI proposal
Thread-Topic: [RFC v2] /dev/iommu uAPI proposal
Thread-Index: Add0lrMH87IsTsl5Rp6WN1oQU6kGMQNX5KMAAFvh8lA=
Date:   Wed, 28 Jul 2021 04:05:56 +0000
Message-ID: <BN9PR11MB54337F6363CC350D2985D5008CEA9@BN9PR11MB5433.namprd11.prod.outlook.com>
References: <BN9PR11MB5433B1E4AE5B0480369F97178C189@BN9PR11MB5433.namprd11.prod.outlook.com>
 <YP5u7Fk2pylHNGeY@myrica>
In-Reply-To: <YP5u7Fk2pylHNGeY@myrica>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: linaro.org; dkim=none (message not signed)
 header.d=none;linaro.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: eab97b96-d694-48d7-ab5c-08d9517cffef
x-ms-traffictypediagnostic: BN0PR11MB5709:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN0PR11MB5709C4813BF5DCF63DC9A6718CEA9@BN0PR11MB5709.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4DcdRQgA4681qRiJvC+yaftk3mWdbbh+uYfW8n0hV3gxIJaydv5GtwC7Dy2T7r2UwyuCdNtOfNR0p52SWYyL3RTX1uOcO1XoRLkhVIsaFaDujnkBdG5ikNLK+IR7aW+ciiNSeglS7cD6HuseU/q++1WH536lMN4U3OcBsdmTgWvZ/lshtq3ICi3uwsfUfBK1SVRthUH9hSU1z/blg+Y8V1igXFCtuFkRMrH9St403ZT01bL8L0LLXqyxZPVkb3y/4Y0opF1/YJ+B0itvQvF10Thiwbc2oPoftUE7ETGnhgKsTzIejPWqVeOMBEtZ2SVubQFmBw0TRHjLTElCoIfFi8fFprmruFEgsN9VT/cUoSo74YZ5/LjXyLbWjKuryIf0y36d+R3DZATu7xPHSnvteS0kCQ9YwlPdLX3h+f/C6KUF1clMuWEMJWGtHOoOM+n/YQboO1ZjY4UBJDBsvl7cIoBLFnDxN6fT+ZxQmv6QvSK17uXEw3Ch8aM4/dDvXljwnKxElEMkAxtwN/96wLSeFGDwGQNIyeq143qDJqGqqDDvppdqt7JjERMduLD3eY3L1BphBIjsgUR/RY5D7JDnTw5fvEj4hogQoS+r0ixdrtHkv6pdy71NSOuPV8Yhm+fERG0Karvamq5alvnZXUYrCjVo+HyHDlqc8pX05ijRbLAQH8+Sugf1JrG1p7pinil5kLKKKshMGrUpzv22DdqCrA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5433.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(346002)(39860400002)(376002)(136003)(55016002)(2906002)(9686003)(86362001)(8936002)(4744005)(7416002)(71200400001)(8676002)(4326008)(7696005)(26005)(478600001)(5660300002)(66556008)(6506007)(66476007)(316002)(38100700002)(33656002)(66946007)(6916009)(122000001)(186003)(64756008)(66446008)(52536014)(54906003)(76116006)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ikcL22pvOvIJ7dh4t2qymYbPb+GSCqQMucp9E9vHDuFoF4mZ8MxchDN6jqKl?=
 =?us-ascii?Q?jYXzGqHJhaCgWp1bvmWs0rcb0u+ZIzp7+BOSnpRE19sMELiTtYvLEPmC0u8B?=
 =?us-ascii?Q?mR17yQpgv8qGb+FILAA3KWhqAQelxNQeEzcxF2lxfj79out1+uSgcLgn1PwL?=
 =?us-ascii?Q?KkKxHhJC0OjKZwTFcqxPAXHhE17Vxl1qwcZ0nCLhCZZo40dXX3nhf3vIvFq5?=
 =?us-ascii?Q?SzdmsFRnjeaa6Q4obIAmI7bJq5v+iUr0QY665QxLNWAv8uNo8ixpOZgzai7g?=
 =?us-ascii?Q?t4KwA/fgZrZ7oacqgwT4iBn/f8QXI/yLmHxWDvDsZGNJ9DFlcRKLWID4nz1E?=
 =?us-ascii?Q?hIlNFYs3txycP+qOvZhB2jShNxDj4P8G2obsER6/SxzMya9yAbHoKjDkUp5g?=
 =?us-ascii?Q?jHeQG//MYuAel9sPedTiKgJZUowe+OiA5egzw2biv20EnZ2S5ugi3zLr6bzj?=
 =?us-ascii?Q?ffWMJmvy735CfNCPpgmXL2OjopQWYbH365z93WVItSpOuEt4P1b+VhxW76Cn?=
 =?us-ascii?Q?lDWsbIcGI++sn7xV3nSJ8LaciCyIjEZg8PFlXy09OBuHxzkpPc5+Y/O2t1Rp?=
 =?us-ascii?Q?J6y5qlnx0PL811Acjl6MyCb8C5tcZT330cdjc424DCwz3iG280uVfBcp7IOx?=
 =?us-ascii?Q?vPgT9b07K5n0cbZ92nX05rhwmzhy0VfbjT8tS3maRIsVsp3ncYTGW6X+9sNz?=
 =?us-ascii?Q?wdTFDRUX4mlAlE9p0+HAXbhkrPke55lCFK5RAZSuIt+Q9uq1NN6jrsaMPAco?=
 =?us-ascii?Q?L1UdihfTsMQd4sI+6Lb5Bh7bfTq1uEv8OQnc46wHALD7X+pGNdN5eacP6jIi?=
 =?us-ascii?Q?eDfd4JnZhKowGhtejPgECbw4sjh3J9BIslqZ7trp9SsHLWzNwBXXKFxIG+am?=
 =?us-ascii?Q?Vz+53KjiEpI73yGWskr8jLiv2aoMvhCuvT+BzE9qUJbIn08VfY+lHH47c5F7?=
 =?us-ascii?Q?Hm85iDl8wZt9W9cwzH3Kcy2h8KZA9iK+c1VICdFOyxPqUZQRVhu1Ieaenbmc?=
 =?us-ascii?Q?bl7SJ7Fx5qLt6f+1AyPceltae+49CzZQqQVuWprauNpmBEM7T7yQ7IPUyz4B?=
 =?us-ascii?Q?JcKfcVW8GDBoigkA8/DQuWLNoHWKfp3SSHpQtG56Pgrk6/ePdmdCuOcIejV0?=
 =?us-ascii?Q?4xxSCM8+AbM0LvGWQVhN1EGVhjrjGt4d8Z7wxZ/hAd74Zj7vJZ7SnCTR9eSm?=
 =?us-ascii?Q?ShmRwU5a8Fe4veV6AhlNJ9kOGg+ZaHOnbMRF0qNeFtJesrL+GFh/AwuqkT9g?=
 =?us-ascii?Q?TL2BdNmHx3OHgdXc/Xe5LH5V6brzmGTSV5NDtCYtBbjQRRw4CYkDrU9026NI?=
 =?us-ascii?Q?prMPCRyV5DbyJG5wfW1FVm6F?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5433.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eab97b96-d694-48d7-ab5c-08d9517cffef
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jul 2021 04:05:56.0451
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DtsQ04hW3uXaFbGfQGe9CqcfRCH3oDXg1r6yyeKI7F2mUgMZR7Fnp+qNuVsDUbgyZu+lJLhiFMLk4JAf2fIrkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR11MB5709
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Sent: Monday, July 26, 2021 4:15 PM
>=20
> Hi Kevin,
>=20
> On Fri, Jul 09, 2021 at 07:48:44AM +0000, Tian, Kevin wrote:
> > /dev/iommu provides an unified interface for managing I/O page tables f=
or
> > devices assigned to userspace. Device passthrough frameworks (VFIO,
> vDPA,
> > etc.) are expected to use this interface instead of creating their own =
logic to
> > isolate untrusted device DMAs initiated by userspace.
> >
> > This proposal describes the uAPI of /dev/iommu and also sample
> sequences
> > with VFIO as example in typical usages. The driver-facing kernel API
> provided
> > by the iommu layer is still TBD, which can be discussed after consensus=
 is
> > made on this uAPI.
>=20
> The document looks good to me, I don't have other concerns at the moment
>=20

Thanks for your review.
