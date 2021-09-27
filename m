Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11BA241A140
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 23:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237187AbhI0VTj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 17:19:39 -0400
Received: from mail-bn8nam11on2064.outbound.protection.outlook.com ([40.107.236.64]:53473
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230046AbhI0VTi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Sep 2021 17:19:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GJoJxTD98ynnerUW6M1DAbK82VbD3WEpdz9K2ZhTl6URjVzPdm7+Wdgx1nDrqxF2wcqkxk9tmZ8VbH/h/H9NNx0HZt2f9xznftta09hhCm8jwXim6V3TgGekDy8bU3Zb5uPHimAFGXMJpHQmQFjsxuVcRqVmhAG7sybXh0irzuB7vMiOUNsCzCnpYiNKDW8NcHNEKZwBOKPXAtq+6TJdAzm7UDdzYzR/RpGck19nW8sedP7/YuUvyVBYvlnYub1Ew9MQFflHFUTyuNc6V/Tj2bFWqCjGzyH30qwtG+BhtjG3LRDUm69rieKKy6hR7LSu2C6GMaxvsxPhjhVzXJwwjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=KXJKXO7aCP1ZaNstUxrXrlmW773SZvHodmQeBZ/1xcI=;
 b=Bk3tIvcPYXK+MH05hgdQT+oyqGMKza3qNW/q5qm1Fi5EqhxwX5i+V2izKs/uWE4Vhsop221Phdd2UxO9zstHQEb8JwEruTqqMhjtAsuCXMG8nFVzvStF1pkzBMq1hZoScc8eWx5+khQ9oBBvZDRJCdvc73h+eSr/2ENyJkzbb+bDdGnx/tvNkU1e7tMCaXtnagigle3c+JcRWB5L84+tef5/opztffCByzZ9G5Zi+T2fAPj3kv2I42NlUu2o8j8kJhZ4E/M1Lp/xeLD1JWSW//9Dh5o4RhNhSJYZYl1cBMaGycwrmLDTOf3MsyRzyZpqqR+u9jHS/65dJCZBMVnLfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KXJKXO7aCP1ZaNstUxrXrlmW773SZvHodmQeBZ/1xcI=;
 b=jnxQIJk3OLH4S/FYE09BYxcsJxvRZRtKTzNJWT15g2wSjFv47+4vyXwyyiKPVRtUKPbTmCgwm1eAD0P70cn4uMoG6FQsnNYgcSLWtgszsSvLsRONMpjP8CZthZYz5trp7LxPJQue/ui1UthwkzwuLn23lH7qoO85p+pgIaKZwefsnEC3LbtS0gJkNThxsF8ehuOtmhSurqZDGIc2ZdaPV5M3Aeg7dtSWyOswj1ve5nkmfmflHk7hxGlORfCk9v6wHnCm+NYQWk4n9P+yf8Vm7TYjmEWrEXQkgyhZv7+em9VnPFj939BPHRMSZo1L1ExeXuIUAMB6JR9niks63VCDxg==
Received: from BY5PR12MB3764.namprd12.prod.outlook.com (2603:10b6:a03:1ac::17)
 by BY5PR12MB4950.namprd12.prod.outlook.com (2603:10b6:a03:1d9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.20; Mon, 27 Sep
 2021 21:17:56 +0000
Received: from BY5PR12MB3764.namprd12.prod.outlook.com
 ([fe80::1d09:e72:91fd:ef05]) by BY5PR12MB3764.namprd12.prod.outlook.com
 ([fe80::1d09:e72:91fd:ef05%7]) with mapi id 15.20.4544.021; Mon, 27 Sep 2021
 21:17:56 +0000
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
CC:     "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "yi.l.liu@intel.com" <yi.l.liu@intel.com>,
        "wangxingang5@huawei.com" <wangxingang5@huawei.com>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "zhangfei.gao@linaro.org" <zhangfei.gao@linaro.org>,
        "zhangfei.gao@gmail.com" <zhangfei.gao@gmail.com>,
        "vivek.gautam@arm.com" <vivek.gautam@arm.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
        "nicoleotsuka@gmail.com" <nicoleotsuka@gmail.com>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        Vikram Sethi <vsethi@nvidia.com>,
        "chenxiang66@hisilicon.com" <chenxiang66@hisilicon.com>,
        "jiangkunkun@huawei.com" <jiangkunkun@huawei.com>
Subject: RE: [PATCH v15 00/12] SMMUv3 Nested Stage Setup (IOMMU part)
Thread-Topic: [PATCH v15 00/12] SMMUv3 Nested Stage Setup (IOMMU part)
Thread-Index: AQHXLsOhPIy4yfhMckeIjXIKtBMRG6u5a1sQ
Date:   Mon, 27 Sep 2021 21:17:56 +0000
Message-ID: <BY5PR12MB37640C26FEBC8AC6E3EDF40BB3A79@BY5PR12MB3764.namprd12.prod.outlook.com>
References: <20210411111228.14386-1-eric.auger@redhat.com>
In-Reply-To: <20210411111228.14386-1-eric.auger@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3c005d6c-1a94-4ddd-599d-08d981fc467e
x-ms-traffictypediagnostic: BY5PR12MB4950:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB495083C7E96B53C231859EA5B3A79@BY5PR12MB4950.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Cu/2mMwCOGEYEmLkBvHMuU7xqFiQi1U1VBgAAo5vz9BxqOZQVEl+z1Bh1Vfo5IFY9UUZ1YE0zbGDJbIlF79bUUVNeXTQEC7nUm/fpw5PugRKiR4xTR9tIR1VgEL+wIDjuFA51coeTHVqNUuQTjHdSTbGzqpG2cXbkDlSuhmQRf5Vh2NgXiC+/xWemBDrWarfaj+ckXJakISGCbEy2J733w4o3NIcb1qU+VJc1c5YLImYwLcFQVtItbP5lr1qngJnshep/uKG0NrIgsSeh3pT3cUkwQ+psrL+HrtPwH2WNUD3P1gI8khNEhomiAHEGJgJ6U+iDJDzGI+aXp/PnqDGUD3ZxPz3mjYkMpKiPrTjHNy/FXsdKKY0id8hwBXVPcJhsG3bjHLKdCk32CVeLgvH9oFuPfkIRgMCd/8Cf30eacv+G7D1lzoMQmY9ArPjzeqKU3kIsA8/+NU1JrJyoikEAbRkT/YDhIdGzaXCY7DyrsZCc9zbA93Y1/k/6+MFRrPCpDzwqzeHWJintRwaniExsNhBQj+6k+kQ7jV9Ouhm6cSNvkGqCYDh4Tj+aHokWru6BF4HebHRCGQRajSyi5paFH3l7eSKHTEcSpbWWIJrQROZ/knDlJxMyEtVplxzafiO45ZCWI9RbCJR2d2mpEztYCGJFp4kU88RZTrUUJPuhc28hejvuFZSWcuSGXbqUdKKIq0jkWDu9ANGlrE59dnkvrBPn5OmQNpMnyGi0GvreRZAjYAfqN6lnQPdOhFtuOVZagxpGEE03FE0gioHCihD5adv/qwwrw8LTeU2ubJtKIA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB3764.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52536014)(5660300002)(76116006)(110136005)(8676002)(54906003)(508600001)(316002)(9686003)(4326008)(8936002)(66946007)(26005)(66446008)(2906002)(64756008)(66556008)(66476007)(7416002)(55016002)(186003)(33656002)(7696005)(38070700005)(71200400001)(966005)(122000001)(86362001)(921005)(6506007)(38100700002)(4744005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Ypv8R93JZLG4spc4z1S4nCItxENoHjn2+YQeOs0VVjeNtnBzdbd3/RB7/9+2?=
 =?us-ascii?Q?1/DgDcVovoGgDzCJYlke2rFD60ZVMuXsjX174/h+A3d0n863Xua3gMrfVgJV?=
 =?us-ascii?Q?5dNgtmUcK0Y+ihPj9EdQuCN0qBKdEyCBhi4dHQKel5cn/H1b4koYnX7SfpWO?=
 =?us-ascii?Q?0B0uq+o0pXMA1PVqk+iety3dd9EMK1gnk7lvd75R6RXV3DRwsLTyYW1HWApu?=
 =?us-ascii?Q?wZGS+yL30bLlXopn7veWnMr6d9my5lNLwNVrSiCB0Exb0QwvL78GhspJic9y?=
 =?us-ascii?Q?Pln3RnLRdHiJP/qK8CjFpG2p2OewkWz2YWL8QX8faI7NScuk0GU+1f18ueuQ?=
 =?us-ascii?Q?Q8miUhOvd0hVOVAgFLU+yi0DkDpHhi5+8IoAKMgcyyN1ypPqLnbeKnswJt6Y?=
 =?us-ascii?Q?+Bado/JwxR9uVclnkHp+4uDjnHtSpqdSDxn0eKlDlykglYpcIYl4qzd8mkNU?=
 =?us-ascii?Q?ONg5wB5HrfE4bfnL7WY69UPUJbAAuYU+yfB1b6jV+f0NXW1YMCPCNDprz1uO?=
 =?us-ascii?Q?F2PZ5Vmctus7GkVB0gX+qfQO2R33b7Z8laznCdY+71EYK9/jIiJxk/SfwwQV?=
 =?us-ascii?Q?8CI7XlP0DqSU/TLjERnJIKXWaJBWg1BibokveBPi5+NTH1odQs7T7se5J2UK?=
 =?us-ascii?Q?ErqdScTP24T0aEKhBZklgfEz79L/hwc5aYSYW2O0XmZahncVLMpRZMVe+Q4b?=
 =?us-ascii?Q?H4GwNClYCE/Kne7qB5M50KDEpR9ucxHPEB5WPILL94lvT1t7vw6rtdnJcalC?=
 =?us-ascii?Q?RaXzj7i8NSGPz8kYvl8YK0bEPUxOSVgWKLzSEXo74YD7FKPFaokvPwSSm8F7?=
 =?us-ascii?Q?mKPQ9DyXOaz8zFH0/RkExBb7iUT9Bnqud5OzKRye61MNUVanslU1Ir6bo1xj?=
 =?us-ascii?Q?tvqfSqJlXXjPoLJ+Fl8AnF6L2scMBtLru6dLa957GJL8R/zECDrP3afqgk8k?=
 =?us-ascii?Q?+lZEafkrc4M3E850prCtf7L3PDni0iPS/YIyL2snswbwclKlwrdlAmNiHTGT?=
 =?us-ascii?Q?WBa/yN4/UnGT79vuooISxFMqQBDkanL8JkClbLv4bFFk+fwLrErN0sDEEj2p?=
 =?us-ascii?Q?ZhEAUzOWPzx2Ek1dOUU4aqvUtLakGqXIMzcC0Br9XPDh7wKf/SJSfEmb5vH9?=
 =?us-ascii?Q?H7Gg3N6QtSJxoHXsgRuBJ+4KEns8FwGSz5AG9qlCv2+4uek3KL1ynLUqNPTH?=
 =?us-ascii?Q?outczxiz0yiwsvdy54EddbD3XkJPLN3g66//7k6DZDdcfV1F0pqWLsbNBuSn?=
 =?us-ascii?Q?c8kSiLOz0VoFe38t59A++97pO60OQUDvwdhpYX0dg9XRgObFTXQ0BXyvqJV5?=
 =?us-ascii?Q?O0+6eg8Gcr0uJOkcsCTalHd9?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB3764.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c005d6c-1a94-4ddd-599d-08d981fc467e
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2021 21:17:56.3733
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yF27nB9jPxKNNPvx/xuAT/gkbt7Zkui37ZRGKkN1hS6uK2IoezKy6+sTgBKYxHD0dv1LJ6SoUgfxVeQCu1x+dw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4950
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,
> This is based on Jean-Philippe's
> [PATCH v14 00/10] iommu: I/O page faults for SMMUv3
> https://www.spinics.net/lists/arm-kernel/msg886518.html
> (including the patches that were not pulled for 5.13)
>

Jean's patches have been merged to v5.14.
Do you anticipate IOMMU/VFIO part patches getting into upstream kernel soon=
?

-KR
