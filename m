Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66C6A502123
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 05:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349320AbiDOEBm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 00:01:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349312AbiDOEBh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 00:01:37 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD3E5A6E37
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 20:59:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649995144; x=1681531144;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rKspj0jZONqE+vPp8BTRLkH2X9fZKcXfdK3OVj1N2vA=;
  b=T+itA1r97UrQOQoXPeqDV8VGu9fAvUQeS5zwryzdQ7Z7WsKGTwEoiVJM
   OKQ+jKUg9s38Es53BPGRYkqfoAypoWYJBg2DRR7QvOH0h7NdUIaKORYT/
   NR9VkzhPqu0wknNMfKPZmYTtNiIJrMrA39jFsnE7CIAn2tUND7Ipwm8GI
   Wj6cSq9tUJnGLftTbtcEVH9Z0DWPlQyd1oOULIVg9Dn6miAFSau/Uf4gk
   MzH6QPSUw0eLNiCpqwSCyOIen7eifPQOkNjFMK4+mosrUaagxRr+xL2y6
   dySBINr/oWOWuvz4Ua6RcBsiL28mB0JcDzYv7Uorg/xrRF7Q4Hp+4QwpI
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10317"; a="250386914"
X-IronPort-AV: E=Sophos;i="5.90,261,1643702400"; 
   d="scan'208";a="250386914"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2022 20:59:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,261,1643702400"; 
   d="scan'208";a="612592926"
Received: from fmsmsx605.amr.corp.intel.com ([10.18.126.85])
  by fmsmga008.fm.intel.com with ESMTP; 14 Apr 2022 20:59:03 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 14 Apr 2022 20:59:02 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 14 Apr 2022 20:59:02 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.177)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 14 Apr 2022 20:59:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fE9O7i3uMzefbM7KBQTxQvRoM1go/jD+RrchpXYtEnvR+LmzVOnVLXrAGZ4UBUNrL9Hs16PtEdReYy81M7TZYQqd6HQMRb7YzR37rcYhkuTJNChxk0Y5/i1wMIa13/6u+E2A4y3JXJGdFBrKLjW5sorm0msJTcCszr+2J5SQJ2ybJmsm1Yhi1LxKkNfPOPyIn3HTB5gMyZqWE5goGh58TQvJiwnkzQDpmFg7dEgkOL7GJ84mCObfJGNh5x3mih7LG+tjtccTXohuxYDdrIBggIhIk4wbgpstumWxnUmFWkebbW5x0aLsGRkWiyvX9SWq0upofaRmel5G7esmpzEoUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j3twSb90kcPKxbEHxWK6wvSabjuZoIvPYLzL+C2zs+Y=;
 b=jPsZoGV2UDkhsi1T9vSBKJtaHfYEEeZrFudZwUUq50bytOzH1HM54+5In2lm5x/R83zR2NW9bYvzdtuySLfkxAx7VrR2cWgO0szD0BVuYxkH3HvBJANsS1ClLHJFrODIHjBWkgwFFYxxc49oSNfI+Yts9SYVybyC64vp7+wry6yfbTEm4rUc7ZGRRA0dCshIz6LfXFi3ptDE6fB0AkQlcFkoZXWNKYHgl0/T3ACn4vwRb5iGHLP4a5q5zuaNowkmZjLtIBqEh9nomQEYEvatEMB4UK00h/ECR8ZNipHf4wYJpi0O/C/yXEzYJL1E8UEXouDNL+GbATL0v2bjnrwMPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM5PR11MB0042.namprd11.prod.outlook.com (2603:10b6:4:6b::36) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Fri, 15 Apr
 2022 03:59:01 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c4ea:a404:b70b:e54e]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::c4ea:a404:b70b:e54e%8]) with mapi id 15.20.5164.018; Fri, 15 Apr 2022
 03:59:01 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
CC:     Eric Auger <eric.auger@redhat.com>, Christoph Hellwig <hch@lst.de>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: RE: [PATCH 05/10] vfio: Move vfio_external_user_iommu_id() to
 vfio_file_ops
Thread-Topic: [PATCH 05/10] vfio: Move vfio_external_user_iommu_id() to
 vfio_file_ops
Thread-Index: AQHYUDAGnvaJkNvkRU+Ae22bHPJavazwWciw
Date:   Fri, 15 Apr 2022 03:59:01 +0000
Message-ID: <BN9PR11MB52768CA82C2C21ED859EDD578CEE9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <0-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
 <5-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
In-Reply-To: <5-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: edb2f6b3-a83b-48f4-2b3e-08da1e944689
x-ms-traffictypediagnostic: DM5PR11MB0042:EE_
x-microsoft-antispam-prvs: <DM5PR11MB00425086B0BB61FDB733A3A18CEE9@DM5PR11MB0042.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7PlC4lQ5BhJ7jY9DeVc1Wx41y4sGHOydtfFH43b1louX7Hqc4fw/x+uqU0tM2aZTOEJZPPZfRq0wdKiMtXlS9R9t/atM3/QBdZXXhaKB/ewCXevfzI5NK/JxRd/mVGChsTozMgHX0X2yJrRV6PhED5GSCItDatRBbUOIStCG0Qy1KQHeo5+4+jJazLUJMANx6QyZX3ysZHMlrU89lXOluBxwtOMCDnsgxL+X7HfPmkCIL2uByit0wFa37EFEnGpsiIKYuvxE7PU7amoDY4eI3hjVNSHoAhzXz1S28vrrEHGxfM+n7dYXhTVXwP34HQOLcMgf1MWZlI8GujTOXs4K+nK2GKA+k7F1yKCwYg235dINMn9psMKvV4lZFqQZkVqU02cUtVXsxbUGaZmMkaqYeDEWxH5JIcLlngHPDF7/VL+eVLMSmSeGMJhsNC/n5EoY/pEkwdIaF1ffSxZmPn9wA8/VfV/qQBOoB2TilJCOjsmW98zGcZ2FFXSzbsQsf92ERBl/YpXAohhXWeZ33QvA65UNuDK98MUD9KQTF9Z5BrgwHTeO5XxznnqiUBgFwkliO3w1+KOc8vovEOZEOD3TcKQlSnmNHuLFRIMiSGVY2nfji6Hc5wApRt3K3ilyrAb0wMmWkICwNgzx2t3zlhmecjMrQRRglGyWCMwW79ImGk9jlgZELY6GdGOCOdURxFUeyr4ebk0i3GN2et0hbWx3ug==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(26005)(186003)(52536014)(33656002)(86362001)(64756008)(8676002)(76116006)(66446008)(71200400001)(66556008)(316002)(83380400001)(66476007)(4326008)(66946007)(110136005)(38070700005)(54906003)(9686003)(8936002)(107886003)(508600001)(38100700002)(55016003)(82960400001)(122000001)(6506007)(2906002)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3iQJTgCaUdltoi318HYjXIgdW82fqLcf2IWCZlTObvOMCyS6POTrZXA03fEf?=
 =?us-ascii?Q?aABlVzcVHjjmnrblGeS0GsaROPwcKsfGSX/W0m3Bx8YRyjiX7onal73Opb15?=
 =?us-ascii?Q?oC8Gli/8Va0aypZcMqKnOmcarufY2ZNGbCghfYmqHJjYEe+qyNbtVTIOiDnX?=
 =?us-ascii?Q?yW2LpIwCy3Xs5c+KQauPf2a5rzY7C/wLQn1Hp7hQKRrm099g/IQbx9O50Mt8?=
 =?us-ascii?Q?CyfWmu+xuDsXiVadw20FrOi9h2WrhuZRWI98zx8dlW9OUC/B7kaL47OL4xrT?=
 =?us-ascii?Q?NVu/cgI3HVA/1WckQXCL2jpxtObRqQ9s9dZssqt3fUV9DUGFlwuPm9OwE8aB?=
 =?us-ascii?Q?8c5DKke+cqKohWkuKdgD5Yj9TjwOnZGXQ4H7JRUQM9UZeLmk1IRxaNbbLlHM?=
 =?us-ascii?Q?i9NvEtzbyKX6ttQaNhzfsO7MIzPn6pKJ7ZKS4NvWm4yyfqyDr8d8obma6C5H?=
 =?us-ascii?Q?R/hOST8MnUo+tTiMSGQnPGvNReiCVTsi8jZ+XU5le0biQpCAoeVbmFhiilHq?=
 =?us-ascii?Q?QbPIUVFzQb+F7V3mwfOQks9Rb98qs6vDkO2kfhB3KdqmtPmBwd160Vv30Pag?=
 =?us-ascii?Q?8ZW7vgv0Mic9LPDcr9+KnjhToV8wa4uUgPiDKeDUA1a7bNYtDAdlt6XuPkVZ?=
 =?us-ascii?Q?i/aFtFrNl6Q6ntruRWXDM633PqGHD6P1+0TquNBNecQp1ForV0Ptc0oS37Ns?=
 =?us-ascii?Q?yT8trHeiJkevHrDbXsq51jEHHfgBR3aUiY92Mersp8SN3PIKexTburAb9k0H?=
 =?us-ascii?Q?Ft85z8TWTRQ2ABO5oKr/NgABDsTk8QYxoBDYrqb2khi1NxYRRfqrKqE/Ybec?=
 =?us-ascii?Q?+zqW7AWwYUi0/B+vDqHyrFbon64Tj9BaOJy/mM9ZTn7rlN0pt8b5Jgr7Uq86?=
 =?us-ascii?Q?JednsJf10ypQK0QtOY4wQZ4SnU/vfY3FVKuzybRx27pnRK1cGhBvcAlUStJ2?=
 =?us-ascii?Q?yydAXBk9yBTMUuqboJj25/tMZ04wsqByg6B8YRohRZOoaZd1DZT7RSzDYR1h?=
 =?us-ascii?Q?FNfRai9mhVHCyxDDQGSzlGaBjayv7rjg8p3sTMcFVpCxH+L3w8hjYoWMjN0N?=
 =?us-ascii?Q?GpLkZRnSffYy43eS1uYX1hDKU1G987TZW1ujSWk1d9D4E9dR6prcIXBffQg2?=
 =?us-ascii?Q?de3FXo3x9d33GlbKpgcNkS1x/cYl2aaPszFfNrkLGRMBKnkNHL4/WaBc+2NC?=
 =?us-ascii?Q?v177oqw8RagnR7hJzBO3IACPaAJJoUGzgXvMy2jfh1TZHSyQhL9hZH8WfJNP?=
 =?us-ascii?Q?pD7uh3cCCWiRJK9H4m5ZyjCZhYBvfx+8E+mhdDj4eSJv8fthB4re5R0Eu92j?=
 =?us-ascii?Q?gWf17NLDSMWtQ7YVVFThNU+o/fI49Jt82/E3KVFzkIvg9CsFsMQmiBU0Rdlk?=
 =?us-ascii?Q?Ck0wtqY9PXj+3WeMajUyVEdvSQVeh/dgcAjFJGtDQD16LNC8olKli/dNySlo?=
 =?us-ascii?Q?g6s1RZtjOsy1YD/Foob5dNE/NVOAALZ3Bh1l6Zk9QbqG+V9aD3UF04uMNxqk?=
 =?us-ascii?Q?D8VSgSTLTfn+oDnM9b6cVVM32xhCGwOQg0MOH+kpjNIcoAu0SrLs1pc0wu/d?=
 =?us-ascii?Q?8k95LGBZAK6VxADwEaje5DLAa1xTS1SS006zvt51UmD5+70tfcaTE0UxxGzg?=
 =?us-ascii?Q?bzSFLKW/2l2NmVqigR1XtjgOHPw3ju9gc75jOOaGMUDixuZJyYdUhjjYnsFi?=
 =?us-ascii?Q?OOYtKTGbR2r/a4wF6hVlMZlUYrPTKA1GNDijhVS2uUYm0ZetmTmwstUpMtU1?=
 =?us-ascii?Q?4uy48uMXpg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edb2f6b3-a83b-48f4-2b3e-08da1e944689
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2022 03:59:01.2484
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: s1rf8fhK2VOTQHTOjmZF1eWJS2RI8Jz79I+BAnnL2MKpgdNQonomDNFJZB6k7lPqQkfrhMc3CEXgweq90ECTEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB0042
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Friday, April 15, 2022 2:46 AM
>=20
> The only user wants to get a pointer to the struct iommu_group associated
> with the VFIO file being used. Instead of returning the group ID then
> searching sysfs for that string just directly return the iommu_group
> pointer already held by the vfio_group struct.
>=20
> It already has a safe lifetime due to the struct file kref.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

This is a nice improvement.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

> ---
>  drivers/vfio/vfio.c  | 20 ++++++++-----
>  include/linux/vfio.h |  2 +-
>  virt/kvm/vfio.c      | 68 ++++++--------------------------------------
>  3 files changed, 22 insertions(+), 68 deletions(-)
>=20
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 93508f6a8beda5..4d62de69705573 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -1919,10 +1919,7 @@ static const struct file_operations
> vfio_device_fops =3D {
>   * increments the container user counter to prevent
>   * the VFIO group from disposal before KVM exits.
>   *
> - * 3. The external user calls vfio_external_user_iommu_id()
> - * to know an IOMMU ID.
> - *
> - * 4. When the external KVM finishes, it calls
> + * 3. When the external KVM finishes, it calls
>   * vfio_group_put_external_user() to release the VFIO group.
>   * This call decrements the container user counter.
>   */
> @@ -2001,11 +1998,19 @@ bool vfio_external_group_match_file(struct
> vfio_group *test_group,
>  }
>  EXPORT_SYMBOL_GPL(vfio_external_group_match_file);
>=20
> -int vfio_external_user_iommu_id(struct vfio_group *group)
> +/**
> + * vfio_file_iommu_group - Return the struct iommu_group for the vfio fi=
le
> + * @filep: VFIO file
> + *
> + * The returned iommu_group is valid as long as a ref is held on the fil=
ep.
> + * VFIO files always have an iommu_group, so this cannot fail.
> + */
> +static struct iommu_group *vfio_file_iommu_group(struct file *filep)
>  {
> -	return iommu_group_id(group->iommu_group);
> +	struct vfio_group *group =3D filep->private_data;
> +
> +	return group->iommu_group;
>  }
> -EXPORT_SYMBOL_GPL(vfio_external_user_iommu_id);
>=20
>  long vfio_external_check_extension(struct vfio_group *group, unsigned lo=
ng
> arg)
>  {
> @@ -2014,6 +2019,7 @@ long vfio_external_check_extension(struct
> vfio_group *group, unsigned long arg)
>  EXPORT_SYMBOL_GPL(vfio_external_check_extension);
>=20
>  static const struct vfio_file_ops vfio_file_group_ops =3D {
> +	.get_iommu_group =3D vfio_file_iommu_group,
>  };
>=20
>  /**
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index 409bbf817206cc..e5ca7d5a0f1584 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -139,6 +139,7 @@ int vfio_mig_get_next_state(struct vfio_device
> *device,
>   * External user API
>   */
>  struct vfio_file_ops {
> +	struct iommu_group *(*get_iommu_group)(struct file *filep);
>  };
>  extern struct vfio_group *vfio_group_get_external_user(struct file *file=
p);
>  extern void vfio_group_put_external_user(struct vfio_group *group);
> @@ -146,7 +147,6 @@ extern struct vfio_group
> *vfio_group_get_external_user_from_dev(struct device
>  								*dev);
>  extern bool vfio_external_group_match_file(struct vfio_group *group,
>  					   struct file *filep);
> -extern int vfio_external_user_iommu_id(struct vfio_group *group);
>  extern long vfio_external_check_extension(struct vfio_group *group,
>  					  unsigned long arg);
>  const struct vfio_file_ops *vfio_file_get_ops(struct file *filep);
> diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
> index 254d8c18378163..743e4870fa1825 100644
> --- a/virt/kvm/vfio.c
> +++ b/virt/kvm/vfio.c
> @@ -118,47 +118,14 @@ static bool kvm_vfio_group_is_coherent(struct
> vfio_group *vfio_group)
>  	return ret > 0;
>  }
>=20
> -static int kvm_vfio_external_user_iommu_id(struct vfio_group *vfio_group=
)
> -{
> -	int (*fn)(struct vfio_group *);
> -	int ret =3D -EINVAL;
> -
> -	fn =3D symbol_get(vfio_external_user_iommu_id);
> -	if (!fn)
> -		return ret;
> -
> -	ret =3D fn(vfio_group);
> -
> -	symbol_put(vfio_external_user_iommu_id);
> -
> -	return ret;
> -}
> -
> -static struct iommu_group *kvm_vfio_group_get_iommu_group(
> -		struct vfio_group *group)
> -{
> -	int group_id =3D kvm_vfio_external_user_iommu_id(group);
> -
> -	if (group_id < 0)
> -		return NULL;
> -
> -	return iommu_group_get_by_id(group_id);
> -}
> -
>  static void kvm_spapr_tce_release_vfio_group(struct kvm *kvm,
> -		struct vfio_group *vfio_group)
> +					     struct kvm_vfio_group *kvg)
>  {
> -	struct iommu_group *grp;
> -
>  	if (!IS_ENABLED(CONFIG_SPAPR_TCE_IOMMU))
>  		return;
>=20
> -	grp =3D kvm_vfio_group_get_iommu_group(vfio_group);
> -	if (WARN_ON_ONCE(!grp))
> -		return;
> -
> -	kvm_spapr_tce_release_iommu_group(kvm, grp);
> -	iommu_group_put(grp);
> +	kvm_spapr_tce_release_iommu_group(kvm,
> +					  kvg->ops->get_iommu_group(kvg-
> >filp));
>  }
>=20
>  /*
> @@ -283,7 +250,7 @@ static int kvm_vfio_group_del(struct kvm_device
> *dev, unsigned int fd)
>=20
>  		list_del(&kvg->node);
>  		kvm_arch_end_assignment(dev->kvm);
> -		kvm_spapr_tce_release_vfio_group(dev->kvm, kvg-
> >vfio_group);
> +		kvm_spapr_tce_release_vfio_group(dev->kvm, kvg);
>  		kvm_vfio_group_set_kvm(kvg->vfio_group, NULL);
>  		kvm_vfio_group_put_external_user(kvg->vfio_group);
>  		fput(kvg->filp);
> @@ -306,10 +273,8 @@ static int kvm_vfio_group_set_spapr_tce(struct
> kvm_device *dev,
>  {
>  	struct kvm_vfio_spapr_tce param;
>  	struct kvm_vfio *kv =3D dev->private;
> -	struct vfio_group *vfio_group;
>  	struct kvm_vfio_group *kvg;
>  	struct fd f;
> -	struct iommu_group *grp;
>  	int ret;
>=20
>  	if (!IS_ENABLED(CONFIG_SPAPR_TCE_IOMMU))
> @@ -322,18 +287,6 @@ static int kvm_vfio_group_set_spapr_tce(struct
> kvm_device *dev,
>  	if (!f.file)
>  		return -EBADF;
>=20
> -	vfio_group =3D kvm_vfio_group_get_external_user(f.file);
> -	if (IS_ERR(vfio_group)) {
> -		ret =3D PTR_ERR(vfio_group);
> -		goto err_fdput;
> -	}
> -
> -	grp =3D kvm_vfio_group_get_iommu_group(vfio_group);
> -	if (WARN_ON_ONCE(!grp)) {
> -		ret =3D -EIO;
> -		goto err_put_external;
> -	}
> -
>  	ret =3D -ENOENT;
>=20
>  	mutex_lock(&kv->lock);
> @@ -341,18 +294,13 @@ static int kvm_vfio_group_set_spapr_tce(struct
> kvm_device *dev,
>  	list_for_each_entry(kvg, &kv->group_list, node) {
>  		if (kvg->filp !=3D f.file)
>  			continue;
> -
> -		ret =3D kvm_spapr_tce_attach_iommu_group(dev->kvm,
> param.tablefd,
> -						       grp);
> +		ret =3D kvm_spapr_tce_attach_iommu_group(
> +			dev->kvm, param.tablefd,
> +			kvg->ops->get_iommu_group(kvg->filp));
>  		break;
>  	}
>=20
>  	mutex_unlock(&kv->lock);
> -
> -	iommu_group_put(grp);
> -err_put_external:
> -	kvm_vfio_group_put_external_user(vfio_group);
> -err_fdput:
>  	fdput(f);
>  	return ret;
>  }
> @@ -418,7 +366,7 @@ static void kvm_vfio_destroy(struct kvm_device *dev)
>  	struct kvm_vfio_group *kvg, *tmp;
>=20
>  	list_for_each_entry_safe(kvg, tmp, &kv->group_list, node) {
> -		kvm_spapr_tce_release_vfio_group(dev->kvm, kvg-
> >vfio_group);
> +		kvm_spapr_tce_release_vfio_group(dev->kvm, kvg);
>  		kvm_vfio_group_set_kvm(kvg->vfio_group, NULL);
>  		kvm_vfio_group_put_external_user(kvg->vfio_group);
>  		fput(kvg->filp);
> --
> 2.35.1

