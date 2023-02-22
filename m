Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5CD769EF66
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 08:34:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230521AbjBVHek (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Feb 2023 02:34:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbjBVHei (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Feb 2023 02:34:38 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCEEA1E1D1;
        Tue, 21 Feb 2023 23:34:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677051277; x=1708587277;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DCAd8V38UjePXPTY3eqwZ5sS6QHzp5SdaPVJzviQS4w=;
  b=EsMnl8cXCEdpjX676Avdn+Jqta937+fLb8MSnXEIgozfnvkOUM/D1XLC
   jYW9MiCXhWk263OhXjCLjZ288bsSD8ZoPnxq5lGBhwzGq0rB+NRh3+3xr
   yxKSFq5IiLcZe6Lnzp8fzOBWKuIsSUR9TucQkF7VlVjLiooeDizodq/IQ
   pyoh7UDLb0znLtVmz/bnkkjJ+F5hw9wtDQ6WA+FsHZZWNCb8Lw+e2Dgyd
   cTPe5Ns7BP7WWfYDxqTEFuuFUa6belWjyDAW4mSQu/mSDaCgNOf9MXN36
   RYsIlhkcB0kMSO1AA6itYEQu0RASzV6BCf19yL574MIQ5uAXv/SI5oHlk
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="313230778"
X-IronPort-AV: E=Sophos;i="5.97,318,1669104000"; 
   d="scan'208";a="313230778"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2023 23:34:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10628"; a="846020102"
X-IronPort-AV: E=Sophos;i="5.97,318,1669104000"; 
   d="scan'208";a="846020102"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga005.jf.intel.com with ESMTP; 21 Feb 2023 23:34:14 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 21 Feb 2023 23:34:13 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 21 Feb 2023 23:34:13 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 21 Feb 2023 23:34:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G3urrvdunpTh6rzmnqTEZP+De2aGV6U5PrsSMNRombtwyU7o5AJl++uRupM/VyAgqYUW74UCcLoFSraDhENfn0GNIDfZfvMpE8SN8g/yT+QQ5BTLsxMy0ICiXyt+1feBxN90YrosqQ1c6oi3WlSwQzLi+nngEuV5YjpwcB/n703IM0zHlgrO5cFpjdc4iSfbPVAQWv4C2HJ+vOq6F9mrMlcbB+7pDZ/Y2p/pft/I51vXmt88GNoHpRqcFNmvoN4U7UTbt6tIyG5Iu+c0VHYvYUBX+NVIL5S8xHYsAuiTRarvutNXsbdhA4Qu2hCMRWxetqRZxvnP20LCkfJdNyLwWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=76u+qxWYv0hNJ46QylruAYCylZctP0mJjIkqT11IxH4=;
 b=Ukv8cYnkDgWyXUYqWxzgVuZZfPedI7USmFOd2kUS/c0uFdI0dbRWnKvAhCvw4A+hxiYN6o1nj7g2nWt5PMZlsvffelnLbIqpTfTZg6UICdjZ0sNQwAuLEOu8F4VKcL5rvx/BULF473GqKNxrF1MzjrPaA230BJIkIG7OyjtRfi/NEZYO++JbTxf4/6Zo+ytXyRPqnkmxQOjZeRagB3YC0tkBe7zGJ+ur4ET5dnUBPeacqABAkF9KydWpqnUa4DAiwIUbRBPcbsIWhl3/QTPiuqNiMMBQxpXLfsJ5VOjN8gz6JIAXLD1zYkKlR5Eg4GqANcRpy9gfF9ST8/tcbPZPhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5271.namprd11.prod.outlook.com (2603:10b6:208:31a::21)
 by CY5PR11MB6137.namprd11.prod.outlook.com (2603:10b6:930:2b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.19; Wed, 22 Feb
 2023 07:34:06 +0000
Received: from BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::38d9:ca7f:b9fc:ef7f]) by BL1PR11MB5271.namprd11.prod.outlook.com
 ([fe80::38d9:ca7f:b9fc:ef7f%8]) with mapi id 15.20.6111.021; Wed, 22 Feb 2023
 07:34:05 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "joro@8bytes.org" <joro@8bytes.org>,
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
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>
Subject: RE: [PATCH v4 15/19] vfio: Add cdev for vfio_device
Thread-Topic: [PATCH v4 15/19] vfio: Add cdev for vfio_device
Thread-Index: AQHZRadkoRmXDvmkc0igu/sHSk+kHq7alKuA
Date:   Wed, 22 Feb 2023 07:34:05 +0000
Message-ID: <BL1PR11MB5271E06CE9A016A22FEF938C8CAA9@BL1PR11MB5271.namprd11.prod.outlook.com>
References: <20230221034812.138051-1-yi.l.liu@intel.com>
 <20230221034812.138051-16-yi.l.liu@intel.com>
In-Reply-To: <20230221034812.138051-16-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5271:EE_|CY5PR11MB6137:EE_
x-ms-office365-filtering-correlation-id: 41573eed-e6a0-4820-7d52-08db14a72d2e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YoRbrA00CuGqBacDffNb2V5BFeHoRbZKVXd5ytPQl4IqZawiH0uc5wn1wXenCoCcrMchST+3PTsYePnCmR2v9J2O8PniJLKekdMEQObm3CTxDlxT9d5nlcgwVJUtTdxDGdwHdxpwIQXMTmcW9sdEYaM7WHkStCSrBy21GzgDwJNa8miL7Wzy05YKEE+f8h0guO8etVTRW5HYhtzmQHktQ3xuDbCgu68zqu5LTFfa9eDCBiNcczM5ja1b/XXcYgl2oIrSbiA7IwHKQqOZH7epYD82c8MB67myQ6tko7vcP5V+417PTcRjGFByFukJUibDNpfv0n+9xIDrJHMh4ygOX8lGozp7N6owHnlD59Wb5oZuHGrqUuxEcCGFnzEnhNBy9DdFjcqjl7l4ZCYFnvMkZJSNCN6t3XzUKadg153dQ+GqyZs792TioYdh2waKNnyNDI7jjBOc3g7m4QekB6GbO2GXMFsqLfe1EqRa5YKd6rDfl+luMSluHGdeFkQmQo/XRKZC09ApL3ix/x2LLwL+AuzHMo4x2wOu55UjzAEwW6xQ/Hi8cW69TZHQztmp09vw/e5A58UX4fJYNbUCWy+VluTjiEfjwALasJImabT3xTl+UXgEyiOixJJiyNS33+unlwN+j/7hEkdbcQxLv1LEW+eBb/tVSOnzP/38Jzkd5Wpd8PTq7qXJPtZUNXhOTeJQFSPSeQ2ay3m1yjzL2Ivnbw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5271.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(39860400002)(396003)(136003)(366004)(376002)(451199018)(7696005)(5660300002)(7416002)(71200400001)(6506007)(9686003)(26005)(186003)(54906003)(110136005)(478600001)(316002)(83380400001)(38070700005)(64756008)(8676002)(4326008)(66446008)(55016003)(8936002)(41300700001)(52536014)(66556008)(66476007)(76116006)(33656002)(66946007)(122000001)(38100700002)(86362001)(82960400001)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?WjtO8e5LGT8hgIy+jrW/jjcs/8E5NUJxmguClVFOn+ikSSdy+aId8BI982yL?=
 =?us-ascii?Q?kKYdnsqnAid70qaY/D/w/ilGkgIN/uJb8EwnyQUfB71ycwJjO9xzY30RGGMQ?=
 =?us-ascii?Q?jFtjq/C55y+K70pNGrZ+1N5aNz9TSIE83ImT5DseQv97VqTtJF+FhplOzfiv?=
 =?us-ascii?Q?UHNosLbe7QCb19r00US5oMKAHZh5scXOerUlORRST0z1FxCKAFvcfFoJhfBs?=
 =?us-ascii?Q?uI31tcNu032RBSWL4xlRHa3cpd8e/MTvNSvzxrmPMfFbQYUGYaL1EZsXxN2u?=
 =?us-ascii?Q?sO3USC5wUBRr1jtrjAyv3RPyZC9Nm+zQUp5FWddSfXBor0p4CK8YBpy3dBgJ?=
 =?us-ascii?Q?b3Llnsl6HzvfojIB4EngpHUEwEkfyyHjI5F0hvRrAQsSUnZr3xi1Gu7dKwqb?=
 =?us-ascii?Q?0Y3ivAAQPvqUzfhKFojrs9V3BmQhlQyuNlOzt+F9FW4UFrJF8rp/Ez8o7v2v?=
 =?us-ascii?Q?xbP6pmH4NF2IZTKumzDvm/HQUaUO0aZbLktThNIVtmzq0KAxz94piTMyc7MY?=
 =?us-ascii?Q?7RuiajlhRi2MTaeVehneYhIFAPVpy68xbdkakoMop+RkbtA4PH84r8kQgM7Z?=
 =?us-ascii?Q?QofxQnwSfxPe/9E7HTGsuG0Gsx+oaOX5JXTjHCIpa99NURUnxO6HjiVBlONm?=
 =?us-ascii?Q?GxkVOvRSSZjhdvjqL9o7cnDTYMwdC2hbr/BRfb/4y8ulyMGzlcYXNC1bP3SH?=
 =?us-ascii?Q?Nii8Qbf3R0dN5XikQJf9byls6ZJADZx1FeHZSOgmkE4/0LpTrhjJUcevZTrY?=
 =?us-ascii?Q?aP5sM54aViA2BwOhTm/xpyMFtiiIhO5XC4IdF5Hgb0D6Y0hpwYEfeUoKpKE8?=
 =?us-ascii?Q?mJVjec+YFyb+VuToR3dJrvN3qFIM0SnttW9OY8OcEFAmjni96iZ/GDcl7CtV?=
 =?us-ascii?Q?qY5UTpOczkbiA/WMVKOYhq7wNp4tAtg1I9fCRuqCVUJvBQanT81tRXMQxB10?=
 =?us-ascii?Q?Mo/4dPaWb4sV06uHviuMhaAE3aCyMl4cid+8R2vLjzjvvRzsIMg4ULv5qSPS?=
 =?us-ascii?Q?q9Szzt3OIGVDyimv90y6JE/5bzzfTUCwqca9HGtnP43tJUzbHsAc/msSsGg2?=
 =?us-ascii?Q?P5M2IB8V8DtMkNswGDKX09qYWyGK+LYT4OjcRg2aWT545oZ6ft2UrgeF8MmC?=
 =?us-ascii?Q?hAk/TjJDBoBi2thyr0WfgVGu3hZzFnQy+TIusREn5r6uSFmdgQct+wFmcBfK?=
 =?us-ascii?Q?FPs+Q3kvG6Ycy1kUSPN52rDEgramT/e+L33BUN1EzHVpqCQBTrdKModHAMqG?=
 =?us-ascii?Q?LzTC+rJ6k7bvPVhCXsxjSZr4ZQSBtn4hX74v8wpvG2PMRhT1PQ6tv7N2nyF7?=
 =?us-ascii?Q?YY4Zv7TFckwdjN1z19cJ35/maHjQQ8AdIns34EHQAu0lmlMQHLdPpscz5is+?=
 =?us-ascii?Q?1zZ0mFDPEq4GpBzguPeePLHlU3sFxM8ikTagJA0cKoYr7mIHMWUmTKGRaefb?=
 =?us-ascii?Q?CuEZs05gRQ0VApewwYrGAEKsN91hzOheGOrvM0jpLSaCkkqmEWviJGeRHMuC?=
 =?us-ascii?Q?xA7FJbUAoXMOZM8BvktDqY/qoAQFqfHpC55qgKUoAFM2INS0MofX/UXZdPHI?=
 =?us-ascii?Q?BWehUXVYNWK9FMdwEZxASP36jltpzVLw+di17UfY?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5271.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41573eed-e6a0-4820-7d52-08db14a72d2e
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Feb 2023 07:34:05.3016
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6v6JojOqXpU/qEZaE/8aLMw/J+IcKt6O/323SiYReUK7ou22uIz7yafin569lZkMHUTHCr8K8ybIp/Qgag5AUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6137
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Tuesday, February 21, 2023 11:48 AM
>=20
> This allows user to directly open a vfio device w/o using the legacy
> container/group interface, as a prerequisite for supporting new iommu
> features like nested translation.
>=20
> The device fd opened in this manner doesn't have the capability to access
> the device as the fops open() doesn't open the device until the successfu=
l
> BIND_IOMMUFD which be added in next patch.
>=20
> With this patch, devices registered to vfio core have both group and devi=
ce
> interface created.
>=20
> - group interface : /dev/vfio/$groupID
> - device interface: /dev/vfio/devices/vfioX  (X is the minor number and
> 					      is unique across devices)
>=20
> Given a vfio device the user can identify the matching vfioX by checking
> the sysfs path of the device. Take PCI device (0000:6a:01.0) for example,
> /sys/bus/pci/devices/0000\:6a\:01.0/vfio-dev/vfio0/dev contains the
> major:minor of the matching vfioX.
>=20
> Userspace then opens the /dev/vfio/devices/vfioX and checks with fstat
> that the major:minor matches.
>=20
> The vfio_device cdev logic in this patch:
> *) __vfio_register_dev() path ends up doing cdev_device_add() for each
>    vfio_device;
> *) vfio_unregister_group_dev() path does cdev_device_del();
>=20
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
