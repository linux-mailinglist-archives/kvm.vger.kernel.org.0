Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C02B6371C9
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 06:30:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbiKXFaK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 00:30:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiKXFaG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 00:30:06 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB06AC4C1B
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 21:30:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669267804; x=1700803804;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=nphnaDxBR/76AX12hqoKHjWMVy+sK/HzS+GS2ssecpg=;
  b=oGMpS2gxMTp9zE+x0rB1plMZQLizrVsw8bAwfwTQOIhkrk5/yX+9QV2h
   0w+naLYzRGE+tNCIfkO3znbmW3u3pXaZhTSwS3g6QjgEvm/6DucijzRl0
   oZdqB7t/NEzrIWHID0qK4d1eUJ8XNeYtXzQlN0UIKx9GiqdD9OgCsoLYc
   a4WGYflUAsrDy/GWS3XQwxx/H1C42fzxcNCg7Lt/whogpNz7AFE83ufc1
   eZcWtEgVZIRbbpFPJyfl3zZq1Edju4flg6HCJW2OxCKRVW/eYLk+VHqU4
   TKuXfm3i7aTIkkRKzU8YWC7yu6NJnJjoCVrqhBRRndA86QYBPHvBmuH19
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="341108406"
X-IronPort-AV: E=Sophos;i="5.96,189,1665471600"; 
   d="scan'208";a="341108406"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 21:30:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="887219917"
X-IronPort-AV: E=Sophos;i="5.96,189,1665471600"; 
   d="scan'208";a="887219917"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga006.fm.intel.com with ESMTP; 23 Nov 2022 21:30:04 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 21:30:04 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 21:30:03 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 23 Nov 2022 21:30:03 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 23 Nov 2022 21:30:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bdC/fow9EB0PakCPs2+AHVFOAObP/SyKcp0pNnjLQvEBOGbqc6rFVtXV9XzYLMuenR6h626lxlN8rYAmnw196CVny1R6iFqlpeK+hSwi6jdZ9B36sh1fYMunJZkefGrUph2c8Zv0aqicPjwBpDqZ50URgVr8RmfQ3q9JeGFo3a5ZN0xFlcw53yPGDE/fbvMVC4QTIIkRtYeHnhwiNdVj2v7orBYOadLAgpnhmfn22RvRA/fOApfOYPelS3zuksbYuwq0pL+2CjRl1LIHGW3zDvilAoYpAbi71K7cbpp6ROnzjkz1bBtYjSt43v9YZFWN8XJC71a6B2v9tNlThPtTiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nphnaDxBR/76AX12hqoKHjWMVy+sK/HzS+GS2ssecpg=;
 b=bo4GvOWQEyHxukSRHGm654cm0BZokMfWUuWzappDJfvKKPusSVdAD0NsTwTNYUAMmjhS3cczzTRqV0fSouWbFA2cKtmlD1jrw4n7XIU7xNAwe7jYh4MD+Vrpe9FBL4Qg+q/9gPptyHx9GiCcpLL0h2SBNaOTIQhkbM8nQkL9WFy+qOM1eYUmShyVtPjFrchaL7kd79TSCizdpLAdviNscfHWZ9Azt3/70F6uJYIY9W0BFGQtqNesZZ2btC9uUOemR5P9QmcUJlclB2I4LTjMvEb1mh3IvWEnOd3Lq7YcrEnD0egwiiInGweeTdUmD8/wvFwupXgUApKhRpsJWSGmEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ1PR11MB6201.namprd11.prod.outlook.com (2603:10b6:a03:45c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Thu, 24 Nov
 2022 05:30:00 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::d30c:c435:9b26:7dde]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::d30c:c435:9b26:7dde%8]) with mapi id 15.20.5857.018; Thu, 24 Nov 2022
 05:30:00 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Yang, Lixiao" <lixiao.yang@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "He, Yu" <yu.he@intel.com>
Subject: RE: [PATCH v3 04/11] vfio: Move storage of allow_unsafe_interrupts to
 vfio_main.c
Thread-Topic: [PATCH v3 04/11] vfio: Move storage of allow_unsafe_interrupts
 to vfio_main.c
Thread-Index: AQHY+gA1L/qNziGKzEi+LQz2iXoY7a5Djn6AgAFEfQCAAFP4AIAFEScAgAEFXgCAAAHQgIAAfwfggAEBtwCAANaKwA==
Date:   Thu, 24 Nov 2022 05:30:00 +0000
Message-ID: <BN9PR11MB52767EC6DD8C2B81D78481028C0F9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v3-50561e12d92b+313-vfio_iommufd_jgg@nvidia.com>
 <4-v3-50561e12d92b+313-vfio_iommufd_jgg@nvidia.com>
 <20221117131451.7d884cdc.alex.williamson@redhat.com>
 <Y3embh+09Fqu26wJ@nvidia.com>
 <20221118133646.7c6421e7.alex.williamson@redhat.com>
 <Y3wtAPTqKJLxBRBg@nvidia.com>
 <20221122103456.7a97ac9b.alex.williamson@redhat.com>
 <Y30JxWOvo1oa2Y3y@nvidia.com>
 <BN9PR11MB5276B441E6C1412CFE5BBA978C0C9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Y35MhFBXyV4yzmF6@nvidia.com>
In-Reply-To: <Y35MhFBXyV4yzmF6@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ1PR11MB6201:EE_
x-ms-office365-filtering-correlation-id: 560ade07-995e-4220-08ff-08dacddceeb9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7N1z7bzBWN/6UPwq1RNEYhfkuHzc8Av+g6mwW70/tcmbL9XmqLrjVKx975BXmV19a/MjF4OKs1/ba75xf+o73PjLkf21izRXZY9jB4f2cAZyjAm36ADeI7++oD3kJDopqZrKRsfs4QApf+pWizzkGggrKP2l22PvhBuE1JEJuYZaHtnF3dXX2Mg/Rvfobicnz0Aw9QgFrZNudMUBg7AAFGUkJAQp7KyzHKWFG01+K70XNk7ApAeHJ+OIal0OK72jW5B7l5iDX6pqXv/sIQrU8Kj6AiQ022xlgO/3YLU+nrEfnwyNRfnbGWwaHBWLkgYG9f3L1nBS+uw6XnI/uj7Zjv0j8XmePt4F7lPbHu/pus/Le670Qlu8fx5/qd9X83ZtFq6r2FUFHRJG4ewoVw1YWxHnhd+wjbNOssjvPMkGrAafYenf0Hsax0B2rsdXNHwdeiSndQ4xUC2fNLfGjsJQr4iK0UO+pJYWKxxRGXQkDE4VWKh7aPq5NsYEk4lf/rfGT0Pw6ckKWXoQjy0NFQNCqpYppL31iywiANQ4baJC/+2WgPF49y8FLyptdFvVw2z1m9+0kxrKuq0OYknC9t/czLUM7ZLOUqKfL6lDRa5GTneNuOfVkuqKp/ez4GF6T404HKpZOJxPBoK47P+07Ax+qptfVEloIbP5ELpIcYxS1hQ8qehgcdFOBdyLW5G6nN8jdsl/QKKUnFpI15qOb2dOPw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(346002)(39860400002)(396003)(366004)(451199015)(55016003)(38070700005)(33656002)(86362001)(71200400001)(54906003)(6916009)(7696005)(6506007)(26005)(478600001)(4744005)(52536014)(5660300002)(66946007)(8936002)(41300700001)(4326008)(76116006)(66556008)(66476007)(66446008)(64756008)(8676002)(2906002)(316002)(9686003)(38100700002)(82960400001)(122000001)(186003)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?6a134SoKQCaX+B5LDumPTaqvMXDp0vYs1jGPIHDpEeAVH/5CbAc6IlnkqkEj?=
 =?us-ascii?Q?yYuWfULn68r59zPFNZ0zE7iVELmwKrewv5nR70XntFHKlK4Q2bjWjUoz9scw?=
 =?us-ascii?Q?dj4rrNhg63yf7gp2shml1h0AGSf+23aSlSSx4kns+lDGoBvZNEK7Gk7eabGZ?=
 =?us-ascii?Q?Cg6QDdK24mRIkvH/7KVZ1CD0q5pIlMO9bpXpZ0Wm/1XrH+cFm7u9kPm3yL60?=
 =?us-ascii?Q?WB8HidMAgHCQtOgElznCKSCnPcdRjKb/4zkT84Iqv4vI/1GiQIciNxhrRd9o?=
 =?us-ascii?Q?H8U893dZVLiHsAyv8TrVKzVUKRow/0SmxMn24rA5FJw+L1MWsJ6h4xeiG75b?=
 =?us-ascii?Q?N/BdJHkNTSS00Iep4Ai9bU4JJTGSos7fCb7C9DXqGf28XqXFLA9Y8dNKa4S3?=
 =?us-ascii?Q?K77pWBDgNKeRd97Ls3so7gfyH57RqeAdCbEEQqHLCPPFJwT7Sh9ClPG02SBd?=
 =?us-ascii?Q?ru/JT4s+1qtdUJWYwGg6X7GeVoYhUimPVEcBwRAunAOJw1Wy1gRhicMSSxss?=
 =?us-ascii?Q?y/kXAMZGNSd3ppJwCJ1yJozwvmpJ5CNOAhKh8f7klAtuBWk9NdzWnOFpgra4?=
 =?us-ascii?Q?1MZsayyjsxcLwOx+J6/gKG3iNWNaqerrrl4BHq3Y0briaW57yPTGHrXaGNMJ?=
 =?us-ascii?Q?Rqk1oxc4ldX+VqSIDVJvrvUl/BiL7Cf7cVpIzkL0riUSuR/ex2XPtoh2HA3B?=
 =?us-ascii?Q?LpeNymk3CiYr02dpDCGJRC09H5ztY/hxaH1UDW+YIjll4Q2inNI6bVNk71GW?=
 =?us-ascii?Q?Q9xDES1p6qSP0tkx2buVnkkYPmFGXyMW84Japqx3TZ7tdVIeL9jn/9cM9ihC?=
 =?us-ascii?Q?GqFuaaMFse85zcj0d7pxj83JFS0RKcW8ndCMQQCzSAe0iBJM9FPJi9lRgZi8?=
 =?us-ascii?Q?EzLD32QZk/sv28EArejPnoFEWggDmYq1h5hOoF+9pKalx4LRgaJpn47J5kyJ?=
 =?us-ascii?Q?VW6cjA7/D0w2i6VyAJpabStkos0euDnY2/gFX9VYmJ9FFQKnd9KuJsxLayxJ?=
 =?us-ascii?Q?W5l6w8kzdim85Zj46DG5oAUEeDEcJxGLPUAAhb7qxOqeBayK7sLANLQAB0b+?=
 =?us-ascii?Q?3AYzuZvULDUCYfm4dlnQRisUsZkXW5dF+LGBsJIzdBlPPnN4g5tMtT3qT/Pf?=
 =?us-ascii?Q?d5DVOblCDI/SSJKwIY02CkN5uj6oMKUE98UCULj/aYbKxi66OSKNdgDgwiIF?=
 =?us-ascii?Q?W9iY0X9Gs6x1NPqmEQSS5NXQLV4+C5H41facZ7EARimyz/XGR6HvaoENlwED?=
 =?us-ascii?Q?2tJAwJkVg1aBfwzq+eh8AhsOd6bXGXKe+5BjUIQouAOTlSUtx15B3A2wUM7N?=
 =?us-ascii?Q?EpPavoTKRithBw8mbCziSs8IQL0gFdHjMaP03sUU4z+DkjVgAgXTDyHZQ+qQ?=
 =?us-ascii?Q?Ha43tFl4JqotjKQheQ9E8p+Kw+d7qgBSfUDYH7ADsY/jKJX2FPp80cZt92vE?=
 =?us-ascii?Q?ff8bv8LUUt4RrFs42Rb8ZQqGN5B+CbiYUw/oj9TGj+usRGjY4m8ZAQ81PBBs?=
 =?us-ascii?Q?O6faBNyZJnwyW8gfXCs2xJkzQ2K8fC+8z82e0L5kzWOTbBYibG8Umqrv+eb5?=
 =?us-ascii?Q?Fhg4I7PNqQxYiwaAqCwAvxUjvnO6lqdcUWeQAMJA?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 560ade07-995e-4220-08ff-08dacddceeb9
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2022 05:30:00.7480
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 96AVk6zYV4joAfAlFb/7VeHup7cmS9+IXp4affNAi0Jh6+lQ6k/zJiM1WKfysMiAKAfWjkjbrNrNpUtZ7+FuYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6201
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Thursday, November 24, 2022 12:38 AM
>=20
> On Wed, Nov 23, 2022 at 01:21:30AM +0000, Tian, Kevin wrote:
>=20
> > I'm not sure the value of entering this mixed world. I could envision
> > dpdk starting to add cdev/iommufd support when it wants to use
> > new features (pasid, iopf, etc.) which are available only via iommufd
> > native api. Before that point it just stays with full vfio legacy.
>=20
> I think the value is for the distro that would benefit from getting
> apps validated and running on iommufd with the least effort invested.
>=20
> So I'd like to see all the vfio apps we can convert to the new device
> interface and iommufd just to be converted, even if they don't make
> use of new features.
>=20

We'll certainly change Qemu but then it will support either legacy vfio
or new iommufd native. No intermediate step like above.

what'd be the practice to push other vfio apps to do such conversion?
