Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7B0338E58
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 14:10:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231252AbhCLNKD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 08:10:03 -0500
Received: from mga12.intel.com ([192.55.52.136]:4706 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230447AbhCLNJd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Mar 2021 08:09:33 -0500
IronPort-SDR: 2hai+qKMvWcKo1Xgh6eFntLXZQTX/6Fg17wPRnTYKsB3zM2f+uoBH3t3iu0xxgCyP77vkhdJCb
 V80jWHs9EGiw==
X-IronPort-AV: E=McAfee;i="6000,8403,9920"; a="168101998"
X-IronPort-AV: E=Sophos;i="5.81,243,1610438400"; 
   d="scan'208";a="168101998"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2021 05:09:33 -0800
IronPort-SDR: NnGFjzlsRmWqFLPy9XXDivOJ6SsE/zJRV/Kx6c0G0eln6BmelyYvXwpKuTtr3XNJ+1CXzPtda6
 9pUet+OExWGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,243,1610438400"; 
   d="scan'208";a="404412412"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by fmsmga008.fm.intel.com with ESMTP; 12 Mar 2021 05:09:32 -0800
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 12 Mar 2021 05:09:32 -0800
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 12 Mar 2021 05:09:31 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Fri, 12 Mar 2021 05:09:31 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.174)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Fri, 12 Mar 2021 05:09:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j7Y4uw+ujr5nhKfcPP6XTy66nhfifPLbFX/OOyP8fmzr5xZU5pTjoXQ+ziy55HofZoKOQzkUpgB+Q6EphDS7k5nHYcOZflocge9uve4AV6SBI6LWPCdirg3pCIVujsTl42tiHFimR+RAtyvr1k27Mo1nNOWpJZtB4XC/jQ/o0eODc+p8oiFmKjADpG98H4Lc/zjJPpvWaJjL0ZvmeYftHmVFHImie/c6xMSqNOYQKB0QoOGb88Dj59ols0kd1fZZsv5QDCJf4/wn8mhs5xeNs/8lsdDQ4RStNU2PgPQfcfQvNHQTVK3pvYyf2x06x6ZPb8m6CYenZXICB8tpe3kgGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z4GiOFqvyo9CWQ0Nk6uPCXt2iwNzN7AfFS+pldUi9fQ=;
 b=JhYOJNjplHFhrASMNpwCCIimE8wQdMM47EVP3E0gah1fiDUFHm5J/L/6v8bMl500iLU83y0NuE7NuMAjULjiojnJdaoHiLZSqQTWix9sSfanP0A14TMCFbM7mwG/aoGk0S90CAUt4LyX/3Zog8kFuodbBp2TbqsgsqR9xBlzDXyG9/IO1PCmCz+tnBY8S7eYAPciaWw8qKoxeelXt+ptHlnw7RVmzqpr1nMPpraZ8ARrvMQgBnyz31sEwYF5WSz6wEytOC9GORwejy6wVjUJ1NLjsu8aM7MW3kI+caqzuEnNTsx/IEXRT1ETAZxgvIe+TOeeskgamRr2NbmtbDn2XA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z4GiOFqvyo9CWQ0Nk6uPCXt2iwNzN7AfFS+pldUi9fQ=;
 b=KoO+i+4MUPQ5EHAHOf6Vzy+2HrZIapuRR7LYyHAAJB/y9RoRYf5Lti9asewePpZc4S/W0tWRawZQTV4HoXMdRJ3PpH24Yj67oF17xnU78NYyitLYXfTxACaowamREUQtrpORXon5lnTNhoUL59a3D0uPsqOfNzHtDtSNBA3hvV4=
Received: from BN6PR11MB4068.namprd11.prod.outlook.com (2603:10b6:405:7c::31)
 by BN6PR1101MB2292.namprd11.prod.outlook.com (2603:10b6:405:4d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Fri, 12 Mar
 2021 13:09:30 +0000
Received: from BN6PR11MB4068.namprd11.prod.outlook.com
 ([fe80::5404:7a7d:4c2a:1c1d]) by BN6PR11MB4068.namprd11.prod.outlook.com
 ([fe80::5404:7a7d:4c2a:1c1d%3]) with mapi id 15.20.3933.031; Fri, 12 Mar 2021
 13:09:30 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>
CC:     "Raj, Ashok" <ashok.raj@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        "Christoph Hellwig" <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: RE: [PATCH 06/10] vfio/mdev: Use
 vfio_init/register/unregister_group_dev
Thread-Topic: [PATCH 06/10] vfio/mdev: Use
 vfio_init/register/unregister_group_dev
Thread-Index: AQHXFSzE4vmedbf78k+dP8Yp8Z61BqqAV1DA
Date:   Fri, 12 Mar 2021 13:09:30 +0000
Message-ID: <BN6PR11MB4068414C5658DC859FE27441C36F9@BN6PR11MB4068.namprd11.prod.outlook.com>
References: <0-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com>
 <6-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com>
In-Reply-To: <6-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.102.204.36]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 87e4a6eb-b6fb-46b3-3bb1-08d8e558128e
x-ms-traffictypediagnostic: BN6PR1101MB2292:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR1101MB2292295BB497937886328FD5C36F9@BN6PR1101MB2292.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1107;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: apOBUpJ6cuDJ/SybVy0AQQAvnRsBzJwwTq9Lp6bjy5TlRQtTFbZusrgue+sEXb/NJ1zaeFCtmMDJ6lWyZ1MQd11Y4f/OuB4W2g9O9LnIA2WC+BzudZY7U0DGGiN7MgWobGwcA3R7rJFK+P+48iqh2vPtwdtVlWu6U8tABeVIanwZTunqXiBV4+92Q0zYboG8GLeXs7192QjHlJrBdtm6mOWy6ZzgzcD+CSvGcH+AL1rFhwdGSoyikAdBY2ODf0crJuJ3fxHEyFMTj8p8kS9ZxVqYVlFgEkCN7gqnbRLGW3IBGMTfuHvq5kPOkIrTNMUJ8doJnGNZVSkPj51gh5OfoW+3Gmz6Vag/8ebpSr/n+GcZF3ZO8N7iRgRHv6/Rg3L/cW91Pa7Sj9IE/exP8Kch5kgUcuJlimMp8ATOkl+dHvcJhvpccxR9hJNSZhOi1fhLJNn3eCGSIJDFQjoXsJvF34e+h7f3/UqIrQi92CjGxvG0sUtUUEzinihUWHO6dmAvVcpmDxHgEPRoG1zJarfaEweTWDco6f7mm7eFzq6EvqgFmT6HaljWKdjnYK8+Kx/G
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB4068.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(346002)(366004)(396003)(376002)(52536014)(55016002)(4326008)(9686003)(66476007)(66446008)(64756008)(66556008)(316002)(66946007)(76116006)(110136005)(54906003)(478600001)(26005)(558084003)(8676002)(8936002)(5660300002)(33656002)(71200400001)(186003)(6506007)(7696005)(86362001)(2906002)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?IYfylY0dLx1T0kLvhHzfbONhXDs8Odz0RxQWnHoACaCfNZv1qBEgXBHWB+aU?=
 =?us-ascii?Q?vz4k3wwRot0bk2RWZ3v7XYCWc/wl7b84qmDWyW/ePgWTv5TenCERGCtSgXSt?=
 =?us-ascii?Q?+gQieqVJ8VYJbYBxg0gJbng5Zr1u85jU/FfDcqEmiAFbtia9guz5EIP0cPVC?=
 =?us-ascii?Q?SaKDwIRx0MlmvGXgSIBjZEMWXVbuaO94t4Ei566arM8b3JuZ+WdnQRDb8f2N?=
 =?us-ascii?Q?RSdvfGjGAxfhFtjnzU2aOzdE2MKp0KZJ4I2szCrcl2BX51Lxrys7npErH/uM?=
 =?us-ascii?Q?iH25Dw64icDEC+6enJuvNW4y/VEA7rICfY/BGWsVbsZL5DiLPsReGmJuZojD?=
 =?us-ascii?Q?WbipSSbhNl7dtwy5nWpfoU9Y2oGzCqwQf1UpkG5sUNX53YpTllKf5PEgbmsT?=
 =?us-ascii?Q?OD9B8KtRIZZ05BVq7bbGHJ4Tuvrsj5Ya30E7To2+gHpT2MZgWF3bOnVoDMB1?=
 =?us-ascii?Q?ByHlpeQyDzBRv6GMmqKUPo1DTm8KPjZpZw/TPOA7dgMyKxRqPH/AKlLfYg1d?=
 =?us-ascii?Q?egEsIafdVJtOhlkqsU/AzFyZSErjdgPr+4okaqDde1zSuX3YjACEH3GtSdOP?=
 =?us-ascii?Q?nPyVnzKgg2K12AivqIOy5hC37/edkcDEOswBOZ2vulF444GiYG1w3p7UGhkM?=
 =?us-ascii?Q?mo/7CuWQ101WaS0nZYaSVL7LK0oUsjUvUYY/yVZMnOkKRF4nAp0z61w5SrG5?=
 =?us-ascii?Q?1RWBrnwsfliBEquBq95gqCh8fLZKDt4lnTxYe996BBoSfapUtUcsFMoC+/z2?=
 =?us-ascii?Q?F4gbflnJNBF916vueKzaTZSGkdo+OEbaOtxd+ol5qkor5066r3e9vm3giW+i?=
 =?us-ascii?Q?g6ah4hn5yuHmrmJVHyD60OFLP0wRez8WyWtkMotgILVIutkUsa0yAV+qgZwI?=
 =?us-ascii?Q?N32859Xs57HYUB3ZQLrIqwV82oukWMaduZydIn116G66HahZyMQ3Lh5JylQu?=
 =?us-ascii?Q?dqySU5lJNBAq8wS9sdJ4/m5EF+tdgY/2FLeBgWz4ONcZpvY3g+oYCHgKmBut?=
 =?us-ascii?Q?Y/32DJRQT8jZy1I1EL+3S57S52gL6Pgsd7rtdREseV0UJ83SEAJp5MprxNgD?=
 =?us-ascii?Q?pHfqFFbfKS18/LIduYScIoTUjGZyCuD1e33qL2kZMFk8PPgHm/nsXOIe5AJK?=
 =?us-ascii?Q?Hyt11vTIZejU9Vn2qYcs+Ss1tB56/sAjMgyeI2rjh9OFYE+0Z1cA2uy0r3ra?=
 =?us-ascii?Q?LA+Amldmua/edujZQ50+OqoUbfA09mzt6XFZoxWWfMB1lL2+nWyZlna/mlId?=
 =?us-ascii?Q?SUeb2WbW6Zw355A4KnbBujQec8MPsTeMcDD4zZ/lxde914toUyrMth61BKct?=
 =?us-ascii?Q?OCb87SodrtyQFWJ+F85ENemY?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB4068.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87e4a6eb-b6fb-46b3-3bb1-08d8e558128e
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Mar 2021 13:09:30.2630
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: C8EXWHpJJ0CWOF+6wMWrIP+pxQRus5peUn9z7T9gxN0CNBH8ytf8vw5BIj+NJEhlyCQOV4nr4UAoU/QSidkpcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2292
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason,

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, March 10, 2021 5:39 AM
>=20
> mdev gets little benefit because it doesn't actually do anything, however
> it is the last user, so move the code here for now.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---

Reviewed-by: Liu Yi L <yi.l.liu@intel.com>

Regards,
Yi Liu

