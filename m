Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7E242A060
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 10:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235028AbhJLIyS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 04:54:18 -0400
Received: from mga04.intel.com ([192.55.52.120]:52316 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234611AbhJLIyP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 04:54:15 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10134"; a="225857716"
X-IronPort-AV: E=Sophos;i="5.85,367,1624345200"; 
   d="scan'208";a="225857716"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2021 01:52:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,367,1624345200"; 
   d="scan'208";a="570350824"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga002.fm.intel.com with ESMTP; 12 Oct 2021 01:52:13 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 12 Oct 2021 01:52:13 -0700
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 12 Oct 2021 01:52:12 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Tue, 12 Oct 2021 01:52:12 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.104)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Tue, 12 Oct 2021 01:52:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rir4BbNTd7k9hM5nBt8APP+KZ0atVNkH4kHclV5uKhCT/Cqgwl/v/9KaDiYhFB3SwnPspMcNi68L7iIRDliyf5F1Yn/BiFyD4lMRJom4Utp55LMVi/hVEf1DFwvxlhntaPf/g+FJOXcvSFc3uw3khmesH5zMMo/sEpFJLsQvSX5sHqbT3tiAZYwWxwiGWmMakPECPjK12RVoLlIVSE/D70s5Agq7qcMcNAqnmq7Gvf3ANMDePsxhMQYk6q2n1vH3Ghsl80vZAQLJPZuUGGIao2L/372GhJ7CcJFdBZMJjN6GaMaF7xmlLnPz5FdOqxqVDtcqdFz6aOi5LmTtY5pLSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=El6hQF8D0NmyiYNxM41EbSCw1Ua7HPscQtHSPssDF70=;
 b=G64iWmuEmlExzrQzLOA5cixrQvgcGCk+nPLiJkj/qHTiTkUh3u7Fwql3rCSieyyz3AHaZmTBVsefOpmerGIUyvmTCHLAXVgxw30BqzK+cWaDL+fVAuhZBrz0N7Vwc5PWK+5vg9rvja0MNLowD4ZitBXLZ10Bq08ua1TIwH7JlVcfK/kXwS93W5q1OHJmY0Od5dY4W4FkAlkHa8Imoduk30traprqhYc9zvn+kTFVUiiGG32qMQ1stHBy9Q9c9gKJ9Q3EsSX2bwNPrU0Iez5tldhGAh2uo2ZVCoY7/LdQcxy6BH60qeKhnsLi12RtuMf18B1l+pQcwNp6WGWFRAuqOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=El6hQF8D0NmyiYNxM41EbSCw1Ua7HPscQtHSPssDF70=;
 b=Kbs0QKq510peeG0/fxSrfnugGvT/S4CVx9j/M9UB7gPF8oMfx0EuKUSYsfVLK4j4/6VBukMn8cqCZr4nCVlY5JGYScNSKMR6WTt5q8XObk5w64DIgUQfGQLt2ebilYUFM5RdaLTQkQDk9GdrNbsLcV3KntSWGL9YFM5a0q1GcI4=
Received: from PH0PR11MB5658.namprd11.prod.outlook.com (2603:10b6:510:e2::23)
 by PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19; Tue, 12 Oct
 2021 08:52:09 +0000
Received: from PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::5009:9c8c:4cb4:e119]) by PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::5009:9c8c:4cb4:e119%6]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 08:52:09 +0000
From:   "Liu, Yi L" <yi.l.liu@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
CC:     Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: RE: [PATCH 2/5] vfio: Do not open code the group list search in
 vfio_create_group()
Thread-Topic: [PATCH 2/5] vfio: Do not open code the group list search in
 vfio_create_group()
Thread-Index: AQHXtxtGvfK5y13m70OrljighpjZlKvPEa8w
Date:   Tue, 12 Oct 2021 08:52:08 +0000
Message-ID: <PH0PR11MB56580B37CA925C223D4FFCEAC3B69@PH0PR11MB5658.namprd11.prod.outlook.com>
References: <0-v1-fba989159158+2f9b-vfio_group_cdev_jgg@nvidia.com>
 <2-v1-fba989159158+2f9b-vfio_group_cdev_jgg@nvidia.com>
In-Reply-To: <2-v1-fba989159158+2f9b-vfio_group_cdev_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3cb74619-15c7-4b2c-18f5-08d98d5d9337
x-ms-traffictypediagnostic: PH0PR11MB5657:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR11MB565727075699494701DFDA94C3B69@PH0PR11MB5657.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1303;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zdpesPAdI0pP55qdsj8UpfYll6GG9IOZEhRdKAF2+86WYjddp3cXPamH+FXPlDzhqAwwt0EbGGHGrfUvG+EjERmLcHiT63coHdYa+Ygi7uU9m1Y2yNtH4p2C2jz4FmHMeCjXuFnMJdk61/ghuWbl4sCyHevO9PKT7I3yjqMY2VDQHUUESAjgTsD/A4eHwogEMLMGm8Jp3VmIUVG3v10oWe9VzDmG/z8YJ4ege1OAhabDGXL/G6LvKw/+w825a12vYqQZXhFQhkmBVf06lmqvLXJ81i6i3AU5a6/YTMHuK/LTJ0MzKd8NuNWRZzaovqirR1lgb1L/MCg+L5Ux+RMXHhHgkbk/y5UJMQydXl8O1lIDDIUF5TlHrjG2RjkhASNFD5fwtc5wwPYZs25LE3VGQc6dzXXonMTdH2fRQvZ17bQ2ke1Q5FFSYQuMLE6MLJrYSe0bjQ7Yyeq7sVFz8ytZ3t2cx5mXQz09y5lO+TpOvkpoMmF/InXGmvAC0oDjmDWL314CqpCY5HLxbbEsAKAagtKZjNz0c7YqdJE521igtuX1BWhAF8h0i0BPdrCfwMa2nMLDaWrnRNAjqkRZROguPCouMjXV2w/NUFeSfuCWmtWCyi7BSQpdBFaI9pO2Ek0apHLdtV4LGF36z2He+QZgz51Sr0gm85KN00nPUyz2YhRYcopLevXCFz29MYWKXU/cp8v6OGxWl2zQU1ijcVOwLQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5658.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(9686003)(4326008)(66446008)(107886003)(76116006)(66946007)(186003)(7696005)(66556008)(26005)(33656002)(122000001)(508600001)(110136005)(86362001)(2906002)(52536014)(66476007)(64756008)(54906003)(316002)(6506007)(5660300002)(55016002)(83380400001)(8936002)(38070700005)(71200400001)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?zVk8OK4PfSG7U9Zb8FlgClBpNExm7Hz7J/i8jbNPslmKNaITapYBSS658KWc?=
 =?us-ascii?Q?kJkrCPEA+JCTl74eVgnmA/yKx+PK1te9wnrLZqsKH1QgD8BlYu6iUqKICZ2S?=
 =?us-ascii?Q?DZdFk2t0mUjn4BGn5Htod2KdFVzSzu2EhpoEqz9lJA8powscE/iH4WtT4DRl?=
 =?us-ascii?Q?PZyzimtIRcUi5yr6OPUMMBfpNN9fu1rIvbrE/bgH8LB9YveTxM98ntzU+BhA?=
 =?us-ascii?Q?FCSSpsOE34nPZuO453GVNMnvSiebJY6OuQXH/B3quq/n75e7DRbL9gBoM+aL?=
 =?us-ascii?Q?i27QoMY3zW9mFzYHIctuF+u2n6rE9Cf8BNin8082pUBoqo7gFf9jnvn7TFHc?=
 =?us-ascii?Q?73jXi2kw0EVNa2hGV7E6u9HkDZ4hGG7CbdHBebVLVAs2dfXPntEB4EUgNUzc?=
 =?us-ascii?Q?Bk9MFTIc2YEwIQRuoiZeefVD1U5Q1ejVF1VCWYlVNul7v5FnMISWmSjV/AmP?=
 =?us-ascii?Q?5eYnlnNmKWVi06D6B0GP4XTtMJIAaanwtWL2OtJHzLgn5vyvjrP/oplAdpYU?=
 =?us-ascii?Q?zsKGskjLa4SRbHxTqls1emqA7RkdcQBENPfGSn3m2AphMr5alBRGKMcGQfkM?=
 =?us-ascii?Q?ObCQ/ZBtAVYVZfoXtgLz0CyBSlXL88aIOqLc96kb9pUO22fPqshFFk+fRWV3?=
 =?us-ascii?Q?mvYywWVYCSpvAHesQ+dBqmNrGlhvNYExpRsg8DdDiclgTevvvgx98fo5OXtm?=
 =?us-ascii?Q?E48LRbFOWjdwetbaOnMM+VLcYLJZp2aEi+9xLao2YfNUh0wEbZfHeIMkYtB+?=
 =?us-ascii?Q?uVKl6wwrWIuwLRijhL3rGdhb9SU0htJQ7r/N+Jrk1k3g4RDHEpQLNQOaXPnU?=
 =?us-ascii?Q?ZQwWZaqHi3rSrotEpbnu5J9ZX2yLKGdL04w9xbSvlb5R1sa9dX9SWbB5OW5S?=
 =?us-ascii?Q?Oxqm+K4KK830iymYxBW2WLP4SvwL0PswLEio3T+S+3WGJncekoDhXl+w33oP?=
 =?us-ascii?Q?YaXU64GHGcz/HUjYovNgNv2sB/biskRViXvjrPXIuBwgimqB+eP7z63EqzUb?=
 =?us-ascii?Q?C1GcWSC+4j7GiU11i+ekh8q3qLmHl35FNw+2IWDXDZoJBoI8yyWiuuxyJaQT?=
 =?us-ascii?Q?IdY27N/m/OcUe2tS9hmjzIzvT242VmvIZfOSOIR/y8mkaXUuTwrB6zVcKcCp?=
 =?us-ascii?Q?aMvuputWByR5f3DHQEys0JPdjNQC3JetU1UDMV/srt+ovwch9NK+qQRCn5ke?=
 =?us-ascii?Q?1wcqMJRM9zSJxDX8csfP/knY2BrPEmeITGVoOPGtFn6F599DeyBhUtBjtrV5?=
 =?us-ascii?Q?jmmM7JVEZ2laMkfy0EFYeaV8YM4A8pw4T5DXyfoBqfPvwiJBPrpcJDr7fojU?=
 =?us-ascii?Q?IfuiY7+qtrvgeE/Dl8bGIKpy?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5658.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cb74619-15c7-4b2c-18f5-08d98d5d9337
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Oct 2021 08:52:09.0026
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 301/SCEa8z/WKB5wxpHd7i4dl+GRiF21h7aUU/eQKF7stDJPXjxFd0q7MnJBKhipPVAmjTDraKYAAgfd7n6dMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5657
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Saturday, October 2, 2021 7:22 AM
>=20
> Split vfio_group_get_from_iommu() into __vfio_group_get_from_iommu() so
> that vfio_create_group() can call it to consolidate this duplicated code.

Reviewed-by: Liu Yi L <yi.l.liu@intel.com>

Regards,
Yi Liu

> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/vfio/vfio.c | 55 ++++++++++++++++++++++++---------------------
>  1 file changed, 30 insertions(+), 25 deletions(-)
>=20
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 32a53cb3598524..1cb12033b02240 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -344,10 +344,35 @@ static void vfio_group_unlock_and_free(struct
> vfio_group *group)
>  /**
>   * Group objects - create, release, get, put, search
>   */
> +static struct vfio_group *
> +__vfio_group_get_from_iommu(struct iommu_group *iommu_group)
> +{
> +	struct vfio_group *group;
> +
> +	list_for_each_entry(group, &vfio.group_list, vfio_next) {
> +		if (group->iommu_group =3D=3D iommu_group) {
> +			vfio_group_get(group);
> +			return group;
> +		}
> +	}
> +	return NULL;
> +}
> +
> +static struct vfio_group *
> +vfio_group_get_from_iommu(struct iommu_group *iommu_group)
> +{
> +	struct vfio_group *group;
> +
> +	mutex_lock(&vfio.group_lock);
> +	group =3D __vfio_group_get_from_iommu(iommu_group);
> +	mutex_unlock(&vfio.group_lock);
> +	return group;
> +}
> +
>  static struct vfio_group *vfio_create_group(struct iommu_group
> *iommu_group,
>  		enum vfio_group_type type)
>  {
> -	struct vfio_group *group, *tmp;
> +	struct vfio_group *group, *existing_group;
>  	struct device *dev;
>  	int ret, minor;
>=20
> @@ -378,12 +403,10 @@ static struct vfio_group *vfio_create_group(struct
> iommu_group *iommu_group,
>  	mutex_lock(&vfio.group_lock);
>=20
>  	/* Did we race creating this group? */
> -	list_for_each_entry(tmp, &vfio.group_list, vfio_next) {
> -		if (tmp->iommu_group =3D=3D iommu_group) {
> -			vfio_group_get(tmp);
> -			vfio_group_unlock_and_free(group);
> -			return tmp;
> -		}
> +	existing_group =3D __vfio_group_get_from_iommu(iommu_group);
> +	if (existing_group) {
> +		vfio_group_unlock_and_free(group);
> +		return existing_group;
>  	}
>=20
>  	minor =3D vfio_alloc_group_minor(group);
> @@ -440,24 +463,6 @@ static void vfio_group_get(struct vfio_group *group)
>  	kref_get(&group->kref);
>  }
>=20
> -static
> -struct vfio_group *vfio_group_get_from_iommu(struct iommu_group
> *iommu_group)
> -{
> -	struct vfio_group *group;
> -
> -	mutex_lock(&vfio.group_lock);
> -	list_for_each_entry(group, &vfio.group_list, vfio_next) {
> -		if (group->iommu_group =3D=3D iommu_group) {
> -			vfio_group_get(group);
> -			mutex_unlock(&vfio.group_lock);
> -			return group;
> -		}
> -	}
> -	mutex_unlock(&vfio.group_lock);
> -
> -	return NULL;
> -}
> -
>  static struct vfio_group *vfio_group_get_from_minor(int minor)
>  {
>  	struct vfio_group *group;
> --
> 2.33.0

