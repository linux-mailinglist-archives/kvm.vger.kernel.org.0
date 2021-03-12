Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FDCF338F08
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 14:43:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231285AbhCLNnJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 08:43:09 -0500
Received: from mga06.intel.com ([134.134.136.31]:54621 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230256AbhCLNmt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Mar 2021 08:42:49 -0500
IronPort-SDR: XNA1w7oqcyk19INRPLX/He158GzTHznROZSE/C9017L/YAH2GTGRm7hPGZOrkpl15GSO+xIvIc
 vyV/5MtxcvOA==
X-IronPort-AV: E=McAfee;i="6000,8403,9920"; a="250197409"
X-IronPort-AV: E=Sophos;i="5.81,243,1610438400"; 
   d="scan'208";a="250197409"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2021 05:42:49 -0800
IronPort-SDR: UsbrW8ty6rSblOILWvT4Iw6JxQEBav0UxvhAK4jFSGFLaaKAvLPHVLQlvN6KZD+d8i8tuseWmo
 71k5KIyGzxEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,243,1610438400"; 
   d="scan'208";a="600597905"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga006.fm.intel.com with ESMTP; 12 Mar 2021 05:42:48 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 12 Mar 2021 05:42:48 -0800
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 12 Mar 2021 05:42:47 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Fri, 12 Mar 2021 05:42:47 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.103)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Fri, 12 Mar 2021 05:42:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bTmKdaURUJjsIXul6rRS+M7w4IxF82U1s66rFt6Pz6CX4Y9p0PaHrU+CbWCrU+Kk3m5gbbbYowuNu7PW3a8CRHu+s76mqeM9l5tYMAVhNPFK1KYSf4GhtOfin0fk1lg3RWjqjNzQGUI1rbOEd8VMqXMWPOBsCqM22iYBDZtBZ5serg5aL/6fsxaJCaElrBfDaGCHiGiHMCNHNjCWeprQJ9uPdDJGZhmrH/3CCPnvtdLhbJh6aSkIMVWMmEOAt8pRlGTwDSSVMamx72Cj8Ok1vpAu54DtHpf1c6t5iYDmom6rHhR+GbOeUgTswdl6bKAPSfwQDk0W7TuOn8tdKNXR8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wIK0lrpZaV65ZGp4pzr+FUqXiy0zvvi0u7nzFuSaBRU=;
 b=jqyAJK5fq2StFtxXK7oeZ/b0j6PUrzQ7a2s314BNAu2ofiwWuAVQGtKBdelVkrCkno74CJCRLPXdWpnh/t5Mt5uzLmuixOwhpr7B3fy0O/LeilPnODYbqPLq9T5tPqnYca/jEa449wxcfD/Ij4E4gbh0PYm7KY1AJlORb0U0+CT6RFdkssECmWc89kFCPF9pLA+XlQ0o+eOt28d5xz701nay1j3ux6s3TdTuL7emZuwOm6MYh7X7N+yw3HGcxydm4+WrRccQVIrZvbrvUAU9+8lHeyN7NQBbRzRHwSe2XSoD3Q0cK1RgbP57IYYtryE09pjZqx4bKL7xD8wIFQC75Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wIK0lrpZaV65ZGp4pzr+FUqXiy0zvvi0u7nzFuSaBRU=;
 b=a+ozudpMv/EQTyNNdxgF24Qq6tfceQRG+hJX1hVBt2S2cgn0bn5J5DZCmKYcDpwgFDAKYaJCDqz/NogrgSVmJEFzQlW0hPpZ9howyZFVmcoNNDwqohE7344E9lx3wkYE/rLXNMqIa1rGrKAW+ByC5zxM5p0ZxA6ro61oNS9G8iI=
Received: from BN6PR11MB4068.namprd11.prod.outlook.com (2603:10b6:405:7c::31)
 by BN6PR1101MB2082.namprd11.prod.outlook.com (2603:10b6:405:51::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Fri, 12 Mar
 2021 13:42:45 +0000
Received: from BN6PR11MB4068.namprd11.prod.outlook.com
 ([fe80::5404:7a7d:4c2a:1c1d]) by BN6PR11MB4068.namprd11.prod.outlook.com
 ([fe80::5404:7a7d:4c2a:1c1d%3]) with mapi id 15.20.3933.031; Fri, 12 Mar 2021
 13:42:45 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     "Raj, Ashok" <ashok.raj@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        "Christoph Hellwig" <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: RE: [PATCH 09/10] vfio/pci: Replace uses of vfio_device_data() with
 container_of
Thread-Topic: [PATCH 09/10] vfio/pci: Replace uses of vfio_device_data() with
 container_of
Thread-Index: AQHXFSzKCMAByn/sCkShXvo1vZOLYaqAW8aQ
Date:   Fri, 12 Mar 2021 13:42:44 +0000
Message-ID: <BN6PR11MB4068E9DE96B512A71BF327ECC36F9@BN6PR11MB4068.namprd11.prod.outlook.com>
References: <0-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com>
 <9-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com>
In-Reply-To: <9-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com>
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
x-ms-office365-filtering-correlation-id: 07883722-5201-40e1-f1c0-08d8e55cb775
x-ms-traffictypediagnostic: BN6PR1101MB2082:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR1101MB20823D619816086C7FF2C243C36F9@BN6PR1101MB2082.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:901;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jz18FeftfCZ0HmrGAq/hIv9ktNqf4sx0L8eLjfkQfJycWysuWF9Cq9Fr+eG0NVSL7ackNTKzCtJqQbqoY05VOJkpSivK+qjUOFt9SpvtKt6prEHp09x5gCL89/ct7l3Zp6JPp4JpJtrCvM8QEox43SA8dyHHKNepfu/Fmqiw8sQJ8WhSYwbsQqhQLvt5pg07vps6akToZBO5OKWEJy9pDyA1FWYV9iw6L3z3Ai07E2tiI/CcQDOs77a9/GC/GWzi5H0DPNjVEnyEcWJN2cznCkF/IUCxpKq2q7eUNAhAfb93Uwlpi2RWjgUNFpLD9Y96onn9UtUeQf4oTkKXxCgJBkxpA4AyjHZcPL2Qbp8Yi77yn6Axg4VDoLEVgJZy+LmQ4GUd3GgOxU9GbYonpsdchV6YApo9D1MmKRXDBZMAYaL1/YhugRueKQZjXShLYmZtONEjnc4BkSnJ9vyqr0lIr6xWNUXQoOMb6MSnsHhmiFJAzcxe9pZPAw93VTi5EOBQZHF3E/IGxfspb7EWn1CIARtZMEPlOtigjnw3s+bQ/zcrwBXQ5YpvZIlmhqZ0Wk34
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB4068.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(346002)(376002)(366004)(39860400002)(110136005)(71200400001)(33656002)(54906003)(316002)(8676002)(8936002)(7416002)(478600001)(86362001)(4744005)(26005)(186003)(6506007)(5660300002)(2906002)(76116006)(9686003)(4326008)(83380400001)(66446008)(7696005)(66476007)(55016002)(66946007)(64756008)(66556008)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?DXrc1Ru2sIUJ9EatjdCXt9oaAncJQwkEtFyHSDZjIhI5Q5vomjMUeDfKqE3+?=
 =?us-ascii?Q?nHtByEB8eOkIEF0I3oKWh4G5tOGEygZiMMPCSlGKl+gCQvg4KEwHeBQvAkw6?=
 =?us-ascii?Q?poux5okhH65uJbfnEBolWe3czBhoSCYrjTtSRe1Qw17+L2PVj32iwTWLPrhA?=
 =?us-ascii?Q?9IlPjLgvPINhOmtEMUMzLX/GN0uEwwUwP3Uc7AftDtabUSjR/XcPYGHRkyrI?=
 =?us-ascii?Q?H7wCW/d04T1r23Brzsi9GW7eFXwnFISkqtrBn0v0+2OhQisSVk+ikdhSUF3W?=
 =?us-ascii?Q?veYErq1A6FNeRlOAyIBTNk964h6htSOYPVD0cR7bVRbCbfLj6gyDoddDRwuc?=
 =?us-ascii?Q?vtgZIkgH5Er8QUgVgzDOmb38BTMiyJEALnOgPLMu7IuDXQFKgLUTqBiPfTSJ?=
 =?us-ascii?Q?dN9MdJ/OWkBXxqgzN5bFlgOJkYO3Yn8LA38nOWYflK7M/3gWifpadGyBGNjy?=
 =?us-ascii?Q?Vbq2TCqNRymfgR+VaUZA+CUdJzix+fkSH3HgCDblyMgerQRwQWz3qmXlkUgM?=
 =?us-ascii?Q?ZTcUtgB8ZL82s43O41c7ZgjUUpMt8tPvveQvfuw2JelRtgHKXr5lvqbKI6rE?=
 =?us-ascii?Q?npNz7/qw9Z8lKlq/2NSyOOAGfbMEqcKlO9hoggGF+yZ+N4i5K4XzeqdWLzD0?=
 =?us-ascii?Q?6fV4k3jKbgxtQxbkT7sllc32xN+EVlJhWtKWgPZpZcp8KwnlAe0Y8ZWrcEeD?=
 =?us-ascii?Q?rb1YoIZo0D3b3vy5OrPoDPk+poW0Qt1ouuy8cEdCywsScpy85isljhz6vOn0?=
 =?us-ascii?Q?T+YOu60i6FJI7JxE5KOJcTsVQetqRU+bMYIqUrhVOAjYlhlFewaVaEGkXHxG?=
 =?us-ascii?Q?BV/UaMp/3y/BAzaOlTThCuJ0+kcZba6TOPrDxAb7HLkN2pDz5zcB1zZBIjCN?=
 =?us-ascii?Q?NYO0TmVF/7Jla7HKXiBM50pFcGytdbjQLIsopZT10HCA1sZfAPFrIbwB24nG?=
 =?us-ascii?Q?x+KIOFnSIj7So5VrsNS7sKZEFm7737xlK5YIAaz6dihlgnaeuxt/cmDO6JcB?=
 =?us-ascii?Q?JGZ+s+ZNa6wg26+55KlrvKYnFGalqFr8ePHbb0qqYzyCQIttCUMM8Zf4/6hW?=
 =?us-ascii?Q?WbHMFDO2vQPUximrbS61A/IG/R51YrKzGLt5Cd9kM5xx+MVSwC3ZrlXndj3J?=
 =?us-ascii?Q?bxGOHFwxPjOBYCZx2A8qqlIQD49QG3w6AmZvqtZxatlUgIXf8xV+G56xciAx?=
 =?us-ascii?Q?NelyJFyUSZXex/Uaa5gn0VXkTVA46Ru/Y7ELtjZAPX7hk+5+Te7H8zcGB81f?=
 =?us-ascii?Q?AnikOC68R/c5j2yjQKn+gquRcw6q2rWpSXmy4dDcOwwQI8nx3EA7OFKYjgY3?=
 =?us-ascii?Q?8qpRc871x7vIGqqsztE1Ux+s?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB4068.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07883722-5201-40e1-f1c0-08d8e55cb775
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Mar 2021 13:42:44.9158
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +H2aUEAAmM1TAxA+uszBfTSWZZ+3Tud+JxtwRE24q5KLeL/cdJFeptNZqs+GXi5BjYCOis/C65Kv5MXanAYN7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1101MB2082
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason,

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, March 10, 2021 5:39 AM
>=20
> This tidies a few confused places that think they can have a refcount on
> the vfio_device but the device_data could be NULL, that isn't possible by
> design.

I think the purpose of this patch is to use container_of in vfio_pci driver
since patch 0008 has already let the callbacks of vfio_device_ops to pass i=
n
struct vfio_device, which can be used to get the vfio_pci_device easily wit=
h
container_of. Just not quite get relationship between the above commit mess=
age.
and the actual purpose. But I'm not a native speaker, so this is not a stro=
ng
comment. Just FYI.

Regards,
Yi Liu
