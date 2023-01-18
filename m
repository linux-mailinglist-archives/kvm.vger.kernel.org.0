Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5785C6718D6
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 11:22:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbjARKWp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 05:22:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbjARKWC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 05:22:02 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5DCEA7325
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 01:27:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674034063; x=1705570063;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Un/KQc8yHYjnLEK81VFPi24MDdnhjVOJ6zg9BTVfkXk=;
  b=A0occyVPQIFq1696z1W3rq0Ma6fSkAdYn7IigiMBjQ9V41BahkrNP1nv
   LE6E30wq/U24WgRutt/PYGqHuSlnjve0UhA2jnOhZIPOWjNgKyprLIgFq
   4SZ8YoSXKaVVtTe7RRBiMOG9rrGZKCxPtxpnR/QWt9X9Un5BzICpH9bz8
   5u8/qTCHmP0EbYzbtPxHvNVXrZhjea1OiuGpaNdq9o0d/0K8Wuz9MjuKX
   BJ5JCGrPcaF24S9dscMU9bRbMBDjOdZCiDrLDbyKH48jmBVq8GWMc7icj
   oI6YFQKQ1GXpF2uM2q2VrlMsE8tGrub5i2ZK1hxS/zQjTxc97mPtchsZu
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10593"; a="304622842"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="304622842"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2023 01:27:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10593"; a="637208605"
X-IronPort-AV: E=Sophos;i="5.97,224,1669104000"; 
   d="scan'208";a="637208605"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga006.jf.intel.com with ESMTP; 18 Jan 2023 01:27:33 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 01:27:35 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 18 Jan 2023 01:27:35 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 18 Jan 2023 01:27:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NzcpWWVIThYUBhW+aHV6A34yGftggDJXbbVbsMEjm5w6+JVs7J0ZK9wK46TU+F+fxGvF9Hd+Ds2m+aw62fO4pnAEno8hudnoruajcScBuYPZT42z73oTQInm9bTmG1a5O8zn7HaGmcPy2TtgHmxdAG0+dTOzMIG4I8q6Or2hH0GX6VyPbz+o8/cA4L5yvWMgBt5rcP8eMX3XdmbD9AVDG812ThdqF+g8l0Gg8CDlUpQA7qWCwrxLB8QgMmB2GPmBAAiAvxtI5oUHUtIamZu9EkowsYgWyvl6tF5+5SgfmrR85+vWhUdwamz7eSG4JnOhHgZhv/ut6Kmu5i58NZ63SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Un/KQc8yHYjnLEK81VFPi24MDdnhjVOJ6zg9BTVfkXk=;
 b=TKZB1UfZ32/ckTHM9cY3Ys2r6KZGPrDF5F3yvnAJLqTPDcxdYNJ8QdLLO6j1HGNEzA29W5j7Sv6LYX0cmA9VNGIJFbtD/7HDh3alkwzBIyJT2xiUotc9/KMPUfNv/zIGPI+6zMHmwPu/U0Ggv53HzFqHjRP4516GcTEN97xYiKo8M7UL4hOcaPTmZtBBDRIqVrErEbuBqEXHypUyvbNyQt6LXTJ/Cz7eryzMRZ0OMd4LJcV7afWKmP85qWikeSKFPVdWD7blxDjKACARj8H+/77CxWUaEFpQV17FaYZQiO/upf2G+NpNTl/eli0+6eJaV5M56vALcRcv7ezRM58Xgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ1PR11MB6084.namprd11.prod.outlook.com (2603:10b6:a03:489::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Wed, 18 Jan
 2023 09:27:27 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::6a8d:b95:e1b5:d79d%9]) with mapi id 15.20.5986.023; Wed, 18 Jan 2023
 09:27:27 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>
Subject: RE: [PATCH 07/13] vfio: Pass struct vfio_device_file * to
 vfio_device_open/close()
Thread-Topic: [PATCH 07/13] vfio: Pass struct vfio_device_file * to
 vfio_device_open/close()
Thread-Index: AQHZKnqZIfuu8tlTo0CdxvTgSNrZrK6j6Q2g
Date:   Wed, 18 Jan 2023 09:27:27 +0000
Message-ID: <BN9PR11MB5276DA9EE1D9FE0217B31D8D8CC79@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230117134942.101112-1-yi.l.liu@intel.com>
 <20230117134942.101112-8-yi.l.liu@intel.com>
In-Reply-To: <20230117134942.101112-8-yi.l.liu@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ1PR11MB6084:EE_
x-ms-office365-filtering-correlation-id: 776eabcb-af7b-4ae9-a369-08daf93636e4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Dgc33g7R08qmPV0vJraGgJP+jyAfIRmHhrwlRHXcCB9uByVmMnh0PFnbBmTgNPiRVU76Uq94rmT8cE59hSoAte1Y0pJ2cAy1zJPd1LoH117ON1WOCNlZUgN37KIXmmftAkQL1MJlBxnv19P+Qe/oLmCuboOgjnR1MoMCJfgsSvHjAuVsBxKrAyQpeMiAdnkQY4ffpLwgXe33Wp/RoqOY1y/7U0JfhQ+iT+ZudHk8Lpyx4//o7jU3TEzj1BRarMYN3OVyIrvu+6n+GRyQT7Loy48ACY1oMiy7KJ5X+0tRm3kg2QhO1yfduLfneiYXlCDFqQm17hNuNfh6BWGu06cHVG0+DfjJOwnbQf+Jp1ZkhakAoXDDn2BIwahR9FpOOiO2QvhNG0tutpPWFBL2rQIklfLve1Lc0rkoAkD5uUfeEmZqOQZD08lZlvyunjJfTzMMgojSzZXwRqeeAuwxt0z5ZenDo/dV7rjYAqu1gaMcQT6BrZmB1TZqfoquVqjYp/YbJoQctvne/I8F4RUuLFFmT3OQpKFx1Ts9H+6v+Cg3M7DIUq0G6r0MCRMNgFiKwj8JPyzUM78yVEDJwGTpC+AksEo9t2J/xO2ZF8nmAm7D6E0d9+oLy5JSP6nLZNuKRK0KQXlZxCQNx//VgiSiltL+NffsV29qA+7mByO+Rlp9nxtA4akG0E+0XR8NdCVFSSqJlw/WuqeaFCVT4pxr/EX0KQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(136003)(376002)(396003)(39860400002)(451199015)(83380400001)(2906002)(558084003)(33656002)(38070700005)(38100700002)(122000001)(52536014)(82960400001)(86362001)(4326008)(7416002)(8676002)(5660300002)(55016003)(66946007)(8936002)(66556008)(64756008)(76116006)(66446008)(66476007)(71200400001)(110136005)(41300700001)(26005)(186003)(6506007)(9686003)(54906003)(478600001)(316002)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?HuRYCvBONshzRaiPBx4Z/mfiG3+GPcZtccdChOnmleX4IiK7u3A2q8t1tO+t?=
 =?us-ascii?Q?6dCpmMlQQtDOm7lE9aIGte6LznIO7/Fmyzs7sjRvX7CrfGa4wYF1dP35Hh7d?=
 =?us-ascii?Q?xT2E8sA8P2hA9hWGHvoTkA9R7m1e4BXTzvcMqfYLO0euhg4iDEM2/sSoLEhI?=
 =?us-ascii?Q?xNyfMyyu1qroD+yrLLhhxYu/tzxH8WJymHVINR5gkgYT4r9i77IHzB+5nb9F?=
 =?us-ascii?Q?FiW8QgLKgQgOvreFnxb/GW3gtmYo5Z6JrI1WibWbMR9pAbxIyhTQx84/oBcz?=
 =?us-ascii?Q?ej9hKtUFtOcmHeuZyPvVASOD1vu8rcLqQWxU8dRmsqbMqoFPet44ifSAqdnc?=
 =?us-ascii?Q?riZUGIzB3wJfCbIN0wuAeEgy0Mosz2izsk5QYRzJo1o/OrIDEsYsDK0e+cDo?=
 =?us-ascii?Q?KzxI6c5D5h1oqupQz2azxDLIQmfyhU8rrrkvwDlI9zHzbHQQHP4o7ge6/fF1?=
 =?us-ascii?Q?H/duGQe2glD+GctHAp+m3eAuSCWm/20CpGYZd0Lh94pBm4G6uLHDtQc+YOkK?=
 =?us-ascii?Q?NkQZbPGnCq0UDzPwyABjFpFI0AKFBUOJmUg0K09EB2uiDSojHOq32/lEp3Gq?=
 =?us-ascii?Q?Ue0vOALNc/tJOstcprvltkuiNvluaW54yI3bcSaxVe24YDCMkS3aPYkbPZwZ?=
 =?us-ascii?Q?oLuSJKG/shj1wcwPe3Fmvj7J96b80AUppCm0R68cVkZ6Xxq8m9k0TUdiFpq5?=
 =?us-ascii?Q?LYWZuF2R8FZKphtobsLSWu5/Y/moAo3dln1N/V+QuCUfPHv9a6xrwlR9ONSQ?=
 =?us-ascii?Q?86D8aSkvU6n8MYmvR/IE3H26aSmvjyFovv5ZuFZxhs+6hoCDzMFKwHTbSYTV?=
 =?us-ascii?Q?B9szK8CLEU0tbL2zslUESt21igM5QgH9cHB2zORip12Q+lOEt7JU4xVuDTo+?=
 =?us-ascii?Q?jsf+W0hY2HfDSM3fx/c3qeSTgu6b1YXtv/NlaEsWcwYzGZFk++XeF6MkenW0?=
 =?us-ascii?Q?PIWQ9nhwLSEfL1LA+QpEdagr6PitxX9kIGgM9sBU6/30/o+cIPnkkqpTtuzz?=
 =?us-ascii?Q?9DyXgfArqNWCQNAq7OdzrwtYtI49I+CcwExh42k0bYfNNFdvRUl5bqc6LwvH?=
 =?us-ascii?Q?Jo0cJVRhMVbeMgQBhv9G0fqeH90pIeFGBIZfqrhPCutUDmZVy0kcEQtGLDPY?=
 =?us-ascii?Q?ziHHcYiIQaAykACR9O2gX2WfrMsAZdYFtWKWMUU+HhweqKZxPvW8jdvfRR7o?=
 =?us-ascii?Q?oPIipBCRmvmnO3PEWMNUe7MUvtGK0dnVxqq8k+jgY1wAIUh/MalR3XGbEPn6?=
 =?us-ascii?Q?lfKglEYOUH/47YZxcryICHe1VF4kVu0l2IxMHKT4BeOTrYkixH4SvOtw76Tq?=
 =?us-ascii?Q?iUNS+5qYdPoNUJhveg9MBuNBjEf47Dp2Q+EZiZeQQ+qNm7oUN1CGhYr2lOmk?=
 =?us-ascii?Q?a7U3Xmfeilvk+2/1I2U6T3l+ZKHxRYZBBMjwlMJy8guHoX9Ti1hIjQ8/xtAS?=
 =?us-ascii?Q?XsaVSyPikoRnFEVLqj3wxKJTENAwYsbTVv/Fyi+FT7v2CxEUx9pIkCT/1JNU?=
 =?us-ascii?Q?Mypu2OslfidBdKsMnWsfhQHgYFpbyJxbpj0r861lvhdR+vPRHoIEasFY3Cs1?=
 =?us-ascii?Q?CrQSaJ/obI8Gy8+CTIeK0pQ3hcOt588aKS2U3jc3?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 776eabcb-af7b-4ae9-a369-08daf93636e4
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jan 2023 09:27:27.0537
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qZS1Kz4T7Hf/mt/IIdB5BCL+/lQLpexWuiJG89uzIdP4ptBuZuN2pTcGG3OiKeX6KMmESJKuoxqPo2pFaQl/Mg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6084
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Liu, Yi L <yi.l.liu@intel.com>
> Sent: Tuesday, January 17, 2023 9:50 PM
>=20
> This avoids passing struct kvm * and struct iommufd_ctx * in multiple
> functions. vfio_device_open() becomes to be a locked helper.

remove "to be"

>=20
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
