Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83BBE59B844
	for <lists+kvm@lfdr.de>; Mon, 22 Aug 2022 06:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232630AbiHVEWW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Aug 2022 00:22:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbiHVEWU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Aug 2022 00:22:20 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A40618367;
        Sun, 21 Aug 2022 21:22:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661142140; x=1692678140;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=TL3B6QNl8W0xcDrPudSQdRWw1FV72pN3Bh7tGQNLv1Q=;
  b=Lh/0wAF0dEqJe+a7lgcCrMHJnewoFo5tnOK823gaDuDWrgsPZxR9nRup
   RlCjRwgHMhT/Md0hklL4aY8Vh8Qo+J5EjI7WxaKqmtNwRvn1fPBIpl8W5
   mgYkQpd98xJf7MGvMhaY2Ww6+N0WKQYJwW3N/SVIbuQDw/j6g0mx1lldj
   C6fXXABTB5CJ5gXkJHt2Brm0vIVqVY+IEaz8kZp9WdbnrUzIrvf5IpMD3
   TGxnVwkqQ+NUeS5rfEc7bBS2+VZG4Z0Bsc2E0ACJYMUIq4zcRuM0u5iCM
   QUIC/R7nbiMfwQoSE0Eab9GNGyqGM98JB2gcJUD/s9RhfQAMMEMAP0Cix
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10446"; a="294105015"
X-IronPort-AV: E=Sophos;i="5.93,254,1654585200"; 
   d="scan'208";a="294105015"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2022 21:22:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,254,1654585200"; 
   d="scan'208";a="854346579"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga006.fm.intel.com with ESMTP; 21 Aug 2022 21:22:19 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 21 Aug 2022 21:22:19 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Sun, 21 Aug 2022 21:22:19 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.173)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Sun, 21 Aug 2022 21:22:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K5ZaFBUl19GgHxb6xUzPZz7gucrvcVKG8jQCIHLwKLNoKlxrVjyPuTgZhElTePecn9oIUtMi9frpg2IawECvH5nD0td6bCIIIZ3uxgYwpJ9nmYOU5jv5xORaoA9EQl13iYN1p27qAIPJs5U801XE5eQ7yTTa8t91VTgidzqGfuYzHffw5sddM2WCKitWFQveuWzEIF4YJGnds+j5j46A7rvSs+n65FoAkm7ZDFQuawjEgrYh5g2T/QwTCYk2h6tuMQYUVP5ETuM4qfzrVw00YJ/IWAQYlDvC177LUjAcTlJ989gxsAyjRNS0z2JBC8uiPXahThCN0kTUuXkAZhzsPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ETbmoENyWvrktbEQ8c8TtvQmt1osLvg652CXxQeKWjs=;
 b=IP18LPFuDgm6kqu2RNWfXUw4ICv6dsLuuOQ77KEJvQR6IKgytKHFkwpI6qTO667Yg38vo8jFbHQTkJwS7/rENez49OmVDGNTRYbOORfFRbFcqszeCT+HuLo+terfk5xPwonmxtT5gAqDPiJHtGFxvFczVKQJfn+Y4Oq52NNIO3l5HY97Ha6F+nMHmQV3LTpMwM9CLAokSKPm/QZd2kKfd+b96qhyl4gZXT1kSp9uH03t+75hvFz6542Hn6ehfYpEoV9Aqx70q8ZL9HpmrtRT0sl8oXl3ITrTv6c8LE7LxQkyJ4KZm36Kw+0FzHGNEivS01jpOOWx4AxFL+HfbWcyKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SN6PR11MB3488.namprd11.prod.outlook.com (2603:10b6:805:b8::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Mon, 22 Aug
 2022 04:22:17 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::301a:151:bce8:29ac]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::301a:151:bce8:29ac%3]) with mapi id 15.20.5546.022; Mon, 22 Aug 2022
 04:22:17 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>
Subject: RE: [PATCH 1/2] vfio/pci: Split linux/vfio_pci_core.h
Thread-Topic: [PATCH 1/2] vfio/pci: Split linux/vfio_pci_core.h
Thread-Index: AQHYsk76APm75YT3sUqMbC94LC8yi626WFsA
Date:   Mon, 22 Aug 2022 04:22:17 +0000
Message-ID: <BN9PR11MB527610FD13AEB17B5C98DB7E8C719@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-da6fc51ee22e+562-vfio_pci_priv_jgg@nvidia.com>
 <1-v1-da6fc51ee22e+562-vfio_pci_priv_jgg@nvidia.com>
In-Reply-To: <1-v1-da6fc51ee22e+562-vfio_pci_priv_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e68714a3-e0e1-47b0-18c5-08da83f5e5bf
x-ms-traffictypediagnostic: SN6PR11MB3488:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0V+dJlTS9P9eVbQ7Hhbvo+rpdYaEqUYQ2G/OQmetx9lXyasDCdFIkG6TmYNlIdd0+i6PxAax2UVN1+0upVK9Vea+xoIko2y6H+2c/My0+ftNX0NEsvSScUonCS/BYJcjIMi5Bn+kfwOBkXu/uteH67BJ7w2kcpeebyeQ5EcW7x7Nt/2SrVt93DgkoNpsfeJs8UN0JRuRpIwht3bzLOMZew83J9btHC5Ij9xsm8MESaO1jeju08cJSB9aDC/Wp+vsQmvLFkj798mtuUraWBo9GnOelZ2R7bLURjsK8TUUJ4AQoOJ4ZEo1iyiwT8sG2JrtGD2NnEQ47+59j5S1pMBU8U3bZH1iDI1LP8BYgIec5o/3tlK4anT7hA18zA0ZxnbYBqTbIQe/sCntlOD4N875B9ZOyqhbY/z9fRdx+5wG79xDI/xl4Ng8N7sE1sBzwLXmpP1+ypOeLCUIhfOWo9Y8auDuVIsuVUF5cipFckULSUgPVSaIA/OCwXt6PNxc6X5cgAhp8B1Gkr9jkEV8u16xLpgd1+3nUckVNJlUVPxDmYRZGELO/vvGiDlLt4TvH8BQzUQ9YKjYNqMQ5u3vDxFKVoIOjuM2N5gcqqBB5fZFLbqSi89sSm7Zued4qO+E1untGaKUk51YW0EUyWN4R3BW34s6AOjmf3fhuAWPPLkHwbOeVwkUjVzeRbRz/LTCNkwq3QhC9hs25ksYJ2lCFc2s9sJhzbBVYuRy7qx4TysFPXW37NYMua6AgghhcIhzwacDakkO+AWfCdng12UQ125nEQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(376002)(366004)(346002)(136003)(396003)(8676002)(52536014)(66446008)(64756008)(66476007)(66556008)(316002)(110136005)(76116006)(66946007)(55016003)(4744005)(5660300002)(8936002)(2906002)(38100700002)(122000001)(86362001)(33656002)(82960400001)(38070700005)(41300700001)(478600001)(6506007)(7696005)(71200400001)(186003)(26005)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?6IfJqNabVGUOS5Q3x71NCKguXGAlKraGfk7prHhDdX6Qg0h1dW/7tjuFS3nK?=
 =?us-ascii?Q?0pX7ip5puZVYtYNEL4G3tTpGOzalBr3pcymSmMh1zrAa+DsWi6DLSST4XUAq?=
 =?us-ascii?Q?Uh91op7UScGo4p+7vepz8OxLb7pSujrMUsRSPfyVyWyohdKasUkGq1LDJ2lH?=
 =?us-ascii?Q?apcZsOQHVjrlBEtFoxkZBUcnOLAbjfcvas5QNG6vwHD0OM2EDBCbTKK5mhds?=
 =?us-ascii?Q?Au1NhRpTikdJ/RlI6xbPBZ86IdN1VFGlcRmO+gCMXkARi4GX2eBBBSUKTja3?=
 =?us-ascii?Q?sBP83+wzCEqlc5rLRwH1bcXOtW9FHYojP0N4JnP3Ifr1LvOfIyk3x0uXq5Kh?=
 =?us-ascii?Q?Q299iDUswC7nI4iDZXCLKr8O5cjPckfBQ1o8RyS3Iv7d2ZZYGEblD3Ln9g3/?=
 =?us-ascii?Q?q7dE9YWzfqqMUIr5Ifs3Em6m6Izta667d/DmCR6xZyPYLQAc6VA8Shn3rTvC?=
 =?us-ascii?Q?5ctUAQWJUZsSR+74BbaBC0vlDTCCPxQlYEg1p42jZfOSS5B4vmWyLSlJ/TY1?=
 =?us-ascii?Q?jZ7hcIRH7Ac0vJzJBkhnFlMm95ZYd1VxplpcK4MkOKIkTaJJyDfh6UErWO97?=
 =?us-ascii?Q?Y7MwtCrRcUieUx+5zllFr+vsFgQbyjgxeiu/Blw17YdkK9jZ0gxs+Q+b0ueh?=
 =?us-ascii?Q?QebUTNSItfGdY6IkdRF/+UQKfMoPrNM+/skWCBxu1mle1UHXgXnlAtROONry?=
 =?us-ascii?Q?1u9v4uCzjZu2ZSZTmL/urtokOX5Vw7b6XE0cQ4jvnxlYQ1qx88V5IIue77Rk?=
 =?us-ascii?Q?kjYEiuvpDhrKoO3934lFAEbpIW9FnDWejixsxzxlkR6hllSeJYAhclh7I+zJ?=
 =?us-ascii?Q?lFUA59qSwFXURt7cPdcbMP8QGlkE2YRrFHT1K+meLRCpltrMP0OSrwrKh6fq?=
 =?us-ascii?Q?d6IWkPJB5p2Q7w6q60ljSbB7TWqzhGnF+UIuivgx4/w3YhKb9vs5jXN0h+fm?=
 =?us-ascii?Q?QxIWudCsEnY8eigkUqGuKvyLQT4yfFCZ6xslXSnEa5sNJALuPKH65GYl5kMl?=
 =?us-ascii?Q?2rUYvZizldT9i7/if25MA6lAulsMCoouKZfBP0RjZS/wUDbXCNyMhvyYds8x?=
 =?us-ascii?Q?oTj8SuJqvEr0txDxa5YTiMmI0X5rVAXoS2lnZ7x6Ol4D1QzDaagEAOPD37kK?=
 =?us-ascii?Q?l2dPrOJ9s/izHLjUGUARdRom2a5jf33+fSkkpbpfL4B7w+EzilS8a5qrh/Ra?=
 =?us-ascii?Q?8WM5eVyTgPYKufsWio/fKgnHW4QdLDEWm3lz4WqAASvl80FLpesCGrNTEBIR?=
 =?us-ascii?Q?wLsbDWIUQCLP1GNg75C7TVFWY69gI2vBoXAhxm3GUhVmeYSFqiQrGwKheSE3?=
 =?us-ascii?Q?fkp1kBd3nGi7d4vq2Qp0rSp+W07TWTSvBIfyROay6sRlibcieRlD+kz77FhY?=
 =?us-ascii?Q?3x4q5+2US3Lf9XbwUw7vuQdjIpwuTuOpn9Amv2ak3sv7hwh3wRwi2VYqaAXx?=
 =?us-ascii?Q?LlQvezcH1GnkC3gVhtbZuq5JGCjvf3ntImvW0MGu0ipiYU7KLYbjfWBC3Xsc?=
 =?us-ascii?Q?Otvoo5YI8qhnMozr1vFAIm5Wv0p3oCsDTfB/RB/VGUqL4rBbN7w/2hmY0PB1?=
 =?us-ascii?Q?94wQ+ggZsb7dmO+C5y6WHj2C3zc2IGNSPax8i76E?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e68714a3-e0e1-47b0-18c5-08da83f5e5bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2022 04:22:17.0922
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wAb9DtkUf8MVnmUR2rm8o6HFBs8rglosd8xE9loBPt4RIIPZJN3074xextkEo8licmxKiazKxNBwmWuhlEjF1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3488
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, August 17, 2022 11:30 PM
>=20
> +/* Will be exported for vfio pci drivers usage */
>  int vfio_pci_register_dev_region(struct vfio_pci_core_device *vdev,
>  				 unsigned int type, unsigned int subtype,
>  				 const struct vfio_pci_regops *ops,
>  				 size_t size, u32 flags, void *data);

NIT. This wants to follow the convention of other exported symbols
in following line i.e. having 'vfio_pci_core_' as the prefix.

Apart from that:

Reviewed-by: <kevin.tian@intel.com>
