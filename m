Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBCD733FC23
	for <lists+kvm@lfdr.de>; Thu, 18 Mar 2021 01:17:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbhCRAQq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Mar 2021 20:16:46 -0400
Received: from mail-bn8nam12on2063.outbound.protection.outlook.com ([40.107.237.63]:17504
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229973AbhCRAQY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Mar 2021 20:16:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JDRGC1q18o2PEvlnL5+XiSuPur2nAwOm19stcmZxeALwUsLXltzCU5OQaykDzFT6REJkaoYGrxw3VWBj0btozO2MXpRx+k5LRXh+/g0MCKisUV/rcjGPUtL6fPM+Q5/kNfvu9SnGCHQzCD0aUg9hroRrnHEfGoOkPpWRZ8HpEfv/REl/0/dvmMio2D45bj5aeZGSsn/6qARU+EWTe4+YbQwlaNP6tFgLJjBVDqWqkZY1Vlbdh7b0Pduy7bHmf0KMxrRLCNJNLcycskQN4BcrQXN/0c4+bATloUXGWd5I2Mc5Yh5FcCz5lD3pCR/oroTAsK3s2gDJahWgadc0JiZn4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ISqCbUvqCZY3OO3+US+VVT7KeGnLhxc6R0VcHTZAaU8=;
 b=iEjAmT8ZCENiXY01lc4ZgFGefeX0Rka0XFe0eQpoimcdP6UEv26lzmsAnAElOevVf5Sa0jFcbjgBG0k4yzP12tCgvPwo6PM7oH1LSeK+19yt0yC5B3e/3GQIxcC2VnmqmIPdLlptVMv2ynsmF2TuJvv1+XmFcDfYEKIiIdiO7KvKJ/31oEOFQvpAsp0PYYRcnQIatSGp8fxhlHarYXgdXPiaSQFcva3vJ25hLbeV42AD44DdkVMJsCS5k2+2dcCFyTcnkqHK4diH4UHtZxnBNmYYGvukUu/sGgVoET7x6ilJQd2Spu+ufMr1wrkRkVcL6+6iegeu40Q0ypwC9euFHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ISqCbUvqCZY3OO3+US+VVT7KeGnLhxc6R0VcHTZAaU8=;
 b=CfxwPALHvFMrsBK117EKxxI2FShhvnR6ZXEoL4BMRJxkL2duQRvLygUnnM2gaJ15wK1ZK/HKvTKB40F9P6043fuVaJ7Qs+k0d/Ifndf9TFUzdwqT4x9PdmtZ9pucgwVdhWA7Hn+rHEpi8ki/f4eovCUam9aekNSByMP1I6TSDYbanWQpEnufMvPioyo2/uP58lYc5N963sNOfv1Y7chKFHmnPam9IhGvPnWYOAst0jCT5rdBPgvpfMsMU6DlnD8+A4GmspwpvX+6JPN4bbrbKwlftdz6b/jzI7BDVj6PeTWgmGMzx08mAFMJyZVURWO4TrPlJZNFKoS+HJjfAsgOrg==
Received: from BY5PR12MB3764.namprd12.prod.outlook.com (2603:10b6:a03:1ac::17)
 by BYAPR12MB2870.namprd12.prod.outlook.com (2603:10b6:a03:12d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Thu, 18 Mar
 2021 00:16:20 +0000
Received: from BY5PR12MB3764.namprd12.prod.outlook.com
 ([fe80::11bb:b39e:3f42:d2af]) by BY5PR12MB3764.namprd12.prod.outlook.com
 ([fe80::11bb:b39e:3f42:d2af%7]) with mapi id 15.20.3933.032; Thu, 18 Mar 2021
 00:16:20 +0000
From:   Krishna Reddy <vdumpa@nvidia.com>
To:     Eric Auger <eric.auger@redhat.com>,
        "eric.auger.pro@gmail.com" <eric.auger.pro@gmail.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "will@kernel.org" <will@kernel.org>,
        "maz@kernel.org" <maz@kernel.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "tn@semihalf.com" <tn@semihalf.com>,
        "zhukeqian1@huawei.com" <zhukeqian1@huawei.com>
CC:     "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "wangxingang5@huawei.com" <wangxingang5@huawei.com>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "jiangkunkun@huawei.com" <jiangkunkun@huawei.com>,
        "vivek.gautam@arm.com" <vivek.gautam@arm.com>,
        Vikram Sethi <vsethi@nvidia.com>,
        "zhangfei.gao@linaro.org" <zhangfei.gao@linaro.org>,
        Bryan Huntsman <bhuntsman@nvidia.com>,
        Terje Bergstrom <tbergstrom@nvidia.com>,
        Yu-Huan Hsu <YHsu@nvidia.com>,
        Sachin Nikam <Snikam@nvidia.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Pritesh Raithatha <praithatha@nvidia.com>
Subject: RE: [PATCH v14 00/13] SMMUv3 Nested Stage Setup (IOMMU part)
Thread-Topic: [PATCH v14 00/13] SMMUv3 Nested Stage Setup (IOMMU part)
Thread-Index: AQHXCiaNb89RqsuC2kys/alJ4AtXCKqJAFng
Date:   Thu, 18 Mar 2021 00:16:19 +0000
Message-ID: <BY5PR12MB3764A171D7C6E0DA9CDF0C29B3699@BY5PR12MB3764.namprd12.prod.outlook.com>
References: <20210223205634.604221-1-eric.auger@redhat.com>
In-Reply-To: <20210223205634.604221-1-eric.auger@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [216.228.112.22]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: df87b380-46bd-416b-69f8-08d8e9a30e59
x-ms-traffictypediagnostic: BYAPR12MB2870:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB287052B718C45FF325981A1DB3699@BYAPR12MB2870.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ajSaupGgRcvjWeCogd4qKk1I+OaeHrTcqIDddJKj47gLcZ1uhaTkA3jgwB6+cqa6x9gMXYBF0T5BjpbauAmS73hr+c86A6WqEHoWnvhlnnBvi1AqOPNzLCLVu5Ye5Xf0JQMB8ePpuSBAqNgxP+JBKCI7KOD9h0hqM/w374w/Kbwg0O3ZGvMcCKhjcIGkA5TgdPSbYLAQJfa1YbHA8vavCiCYALZze6oG0060ZPw+Z40jkX14djdkk303vZfxjSTMamGdRangmbPit476R2SPjMsdObL6OVWHjJg8mNkFKuZ+3/9f6XVglpt2M4ITjl7+MpA9c/tn/fI7z65VBcxA25A2NtPygB7jV7ZsZymp+VGoZlftqfBz+mkzFQTB6tu6shszcTq+1XVHHI5O7plCeeX0+9bUGogqSsNBy4bQUafRfhwIpHzBB2wbCXNbWNHh9MrCDYJlfiH8UIIf7I+0S1Nr4yfyCVQYq5DnMA9Xxi1XpZBoi5NcK6W4Vre1ScJ70uFTGeXX0yIavDKHE2rD1e3hxfGMDeA7bnW/RGV77Z9vP6tPM2+tUav7GQMI91GFM0ouLGWV1obIFrI8s1HBTGzK8CNf59Pkf30zx4/wRC+VVUgLMLXC/GbUtDsR6Gg6JaQW1U4tVrKNsbCbjhVEfcMK+hdURzTy+NuaM3v4PhgaDtKKBLFuE8uDliAJ7QHZxl2jHc17TxI0+Nsrj1rYBQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB3764.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(39860400002)(396003)(366004)(136003)(6506007)(52536014)(26005)(107886003)(4744005)(316002)(83380400001)(71200400001)(2906002)(66476007)(4326008)(54906003)(478600001)(8676002)(110136005)(8936002)(9686003)(7696005)(86362001)(64756008)(7416002)(966005)(921005)(66556008)(66446008)(76116006)(55016002)(186003)(33656002)(5660300002)(38100700001)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?/YqFc5NsMuzCWL7se/qTr6ElK3gUpAWRtmXEGNagQmSrDii3g4gIbYvdGwLE?=
 =?us-ascii?Q?0pO/lW4K5WnEHraDetesHvrdwW3XMfBWQU7i3xIxtKptI+qsbK6HGvI8lKT+?=
 =?us-ascii?Q?udRCcPmPxNB9y8vOKe/6k8fbOHExJ63fbyAzOls8y69m7cTbS0dzk7D5TfMu?=
 =?us-ascii?Q?Hm0Waofb6kKkCS2+IVty4mIcp8BB5nilQ3BO+4dZ8ZZ0yYHYETVFZ2TXLwfV?=
 =?us-ascii?Q?1jQC5ftiKE+CH2bQu7gzQKBIwdKkb7ovnY9mM1PYWZdL+1Ozc1uVNBF98U2U?=
 =?us-ascii?Q?cZ3L7yrxSZUCa681CdS3rYvR1mqlLoLOIV4i3J7H9ggP1MvIZTKgddN2fkNY?=
 =?us-ascii?Q?d3LGD12o8NpYgLZxlPVxTM5sJYpoXfal3XO1n1zoo1fY/wzR9IRPLUlSz2sj?=
 =?us-ascii?Q?qxcGd1UBrV47X+frEStgdN7+42avz96t4fHoBCCioYAa/d8gE3OLyFx9OLhO?=
 =?us-ascii?Q?HQfFawvmTS1ry0dMHWVQ4pZCqnyUx4bwR/A0W4Cy1aP2CuSDmDVI8plDxUch?=
 =?us-ascii?Q?FBk/bwBCemmVOK/l8GE7u7hZ0jDdhx9xl19UW/jGxRXaJgItqa8Pe01O2swW?=
 =?us-ascii?Q?VoYU8qFtVKn5v7wNGCRv3z6DsDmfqIbpR4g0z7CxdBqaLRkRyq+cigV6LKKh?=
 =?us-ascii?Q?1+Okqkn7bVtUYOWQgHagN5icGcog1rLpKn/kM8jYi3OGAFpiSUnVyPtjd19l?=
 =?us-ascii?Q?FPs3bnpiSRJd9Zi/v8IVwU33Ce7caG/hqjvWweGj1tnKyUV0aikHThRqY052?=
 =?us-ascii?Q?eKTB17PRjyHM+oXAYDoaVTg6GRQKpTtlb3uzeh9DzRtnBwybJrhXYqgSvf6T?=
 =?us-ascii?Q?S9tHMTsrrOGBXJAzq+eMAYc2ypQxThWr/eN44nDT12bCRuipyhO3BKCrRdHt?=
 =?us-ascii?Q?E5+b+RELdx2YDX1SexbSNAknYAUj0n44fvVX50VpzUz0SsEk1Twv5uUUg2qi?=
 =?us-ascii?Q?b9h0QRivedGuKB2QSL/hgI/FBhMCJ0titJs2MO/4EI6Buv43GCLjpyejwMqf?=
 =?us-ascii?Q?5RkrfUgIEzJkHz1BuJC/UlR166LGNVQH/RHPD4une68gUhhR/Qe0oLUjm83j?=
 =?us-ascii?Q?Ic8rceafN85TEmqrxL5n6w+0imxMiwvXXp75iTShFew7Ix2vkW4rzwz5d+3H?=
 =?us-ascii?Q?pPxuZxlbK69+e9vxzZ9zWKAn0DqiDeiZhbMTutaPaG/0B1G8ZiaduOUAUzeI?=
 =?us-ascii?Q?ZmFvhwaeY8T/skWbJaLemvt7Uv9SNF/6mgoZjTFXXPOG3WC81Or/tzJBDLrk?=
 =?us-ascii?Q?+dcXs3lubhkrk4AW0x8ZKz1fgzorcPCLQ9Zp/7b1X3trwOpRI+QNY96eSGZg?=
 =?us-ascii?Q?ajJNrD1L/caF1YUlmrhiCp2x?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB3764.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df87b380-46bd-416b-69f8-08d8e9a30e59
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Mar 2021 00:16:19.9648
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cRR9yRuJmzsJWrvPrVg/6QnyfrFL1BhjYOWGSRmH16twlkos4+zhK2XpfPxOvITiBctQIQjrrcwKaI6XGmPVCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2870
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Tested-by: Krishna Reddy <vdumpa@nvidia.com>

Validated nested translations with NVMe PCI device assigned to Guest VM.=20
Tested with both v12 and v13 of Jean-Philippe's patches as base.

> This is based on Jean-Philippe's
> [PATCH v12 00/10] iommu: I/O page faults for SMMUv3
> https://lore.kernel.org/linux-arm-kernel/YBfij71tyYvh8LhB@myrica/T/

With Jean-Philippe's V13, Patch 12 of this series has a conflict that had t=
o be resolved manually.

-KR


