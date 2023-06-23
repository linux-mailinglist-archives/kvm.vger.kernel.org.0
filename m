Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A20CA73B9A5
	for <lists+kvm@lfdr.de>; Fri, 23 Jun 2023 16:15:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbjFWOPr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jun 2023 10:15:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbjFWOPp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Jun 2023 10:15:45 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2067.outbound.protection.outlook.com [40.107.237.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C65C1713;
        Fri, 23 Jun 2023 07:15:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yf8jgZ8O45+C7OqwG3YfoODso8KSmx9xG/vCOJYZ0XNbh9KMcFisGfShZJpsGwCDBmg+q9yRljO1mf9j+IxWTDTaAeRXID4+AufWN8fGj9ymniq4bpCBSM0TjCGfHzp7bs5FxhmlzGu8x7DrXq27lC+oGKqA3/QdxdUHKUypdFVJSoEYGU37jPyHHizsOsnQCtPCtesV8oBWXixO5INvb8sFtiTwaSHFwF2StlknWAffB6gq7UUxCSnwrQzA7iaVJk5dfCyjfRKu4EqnvRxF7hKIfFY69FYlNEA4f2BoscYD3Tmsj0xQGz27CuSwurK5mIhnGOJHvSSk6viSv5ViPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1MB6i7PLVpZh/C+Y3lNHXIKMI2JGtAYQnEBRujdItZU=;
 b=MpOKKKXwsOrLRYCRKXIGYEZhCVyvQ2Mr+e97M1SilhQMhVDgNQf+Tc4Vj+qONj3gj5jrU5rZ2nan7ZP6dt6rWFQ3faGHdrYLsZqh1L3yNT6KWsbpKuReaVH7evhNkOIMuTHru7G0JoMeN/tcz0m48F9wdgCkrrgA4fvWzmVqrQ3Nj/sOrgxLzYiKwBMCrwLR0LkInznnCWmjPSYQkpPxO1Vx8UenoefOYnSQhx5K1gh0HcVWRP7+1DMDXOygwov4prqPaXzd/1kDBhLR2wrNm9g1g5r5pwMcuRhoa5KL8ttLhceOS5F0tmEa51AJJQF7vMWFj5QpX69Y1cnH1OPFIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1MB6i7PLVpZh/C+Y3lNHXIKMI2JGtAYQnEBRujdItZU=;
 b=Bkjg0Ivz6E5OxUdEqu1BqAy/l5C9OmKSMHJibzdp8P5OiaLDw6Yyck2TfLGIeQgFoq3L0MJCjlTry8Pa0uUMiA+a3M2RvP1WaqXsvoMlBonZq8pCN+mqknHMoLuk/iV2RkgusZAZfTvmXMw89PfOfvK84Nre135ecexaA9MsWAe2QWj1Chg21eeQIDasa/6G1/CK6vv388X9MtO/vj1Ihe4pC2hEivIcU6QnXgK2DhKhz8AGDvs0IlocBX+CESMrcoHc0OBt3AfpSl75/d0lo8dvBISSTVYSyGNw9dL5ezNY0G7gsiGL/KYTJZkT5vC1ioY3Fqun/t7HgwuES0jtJA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DS0PR12MB9275.namprd12.prod.outlook.com (2603:10b6:8:1be::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6544.9; Fri, 23 Jun
 2023 14:15:42 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%7]) with mapi id 15.20.6521.024; Fri, 23 Jun 2023
 14:15:42 +0000
Date:   Fri, 23 Jun 2023 11:15:40 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, kevin.tian@intel.com, joro@8bytes.org,
        robin.murphy@arm.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com,
        yanting.jiang@intel.com, zhenzhong.duan@intel.com,
        clegoate@redhat.com
Subject: Re: [PATCH v12 14/24] iommufd/device: Add iommufd_access_detach() API
Message-ID: <ZJWpDFRuG/HCXjHN@nvidia.com>
References: <20230602121653.80017-1-yi.l.liu@intel.com>
 <20230602121653.80017-15-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230602121653.80017-15-yi.l.liu@intel.com>
X-ClientProxiedBy: YT1P288CA0018.CANP288.PROD.OUTLOOK.COM (2603:10b6:b01::31)
 To LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DS0PR12MB9275:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c0561e1-f4f7-400b-fd5e-08db73f453fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N4spOFu5DLMveNQbviEJFhYE64u2oDmIXR03x62FkucqWlFk2UtixSz0swCPBBOttM26rXzkKbwTKjAWKV/CESxgdP4WBXQDyNb+CUUuA9Uoi+rN4bMx7DDD8g2WB7oJEjX0D1/wB+RhLwlEvoTi2qsuYSIXFpPOtau1W3mDPOajwt1G+yUg61ZAAc9oUxZ7k26AXeB1lAJBcvD2JOYCDBVRR9KjRS1ouZmmmDyIQMNovY1Xp+XbIpaVIiLrNksC0+OUurFu2zmK5O5JObvXcAmhsrKPZQqQ7soLFTa6FJMGNaT8Cu6vLCyMuv8buKaSIVdP4bHGe7Z5XuVF6Og6u7SKDTwU3BxFW+9BBEsO2M+JThsQkUw/UhpR8BIGrk19wn0k/gc7b4pQAii3YOLWs6rWgsuRUDeaNecKVkaohL6bZcKBMvnQwsni/NmPVrRYvw3VONvdFOo+Fk4N24ZtgYe7j7u7A3udedfMJ3CGkpNLqf1+mYOsfdHJu+C1P1q8Sd01IHj5S+rRqIMpq6/MtpiGpGK2ilwv1TPE5ggh1uHGHHfQHS5s68iadPxSwhYD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(136003)(39860400002)(366004)(396003)(451199021)(478600001)(66556008)(66946007)(66476007)(6916009)(36756003)(4326008)(6486002)(38100700002)(316002)(86362001)(26005)(6506007)(6512007)(83380400001)(186003)(2616005)(2906002)(8676002)(41300700001)(8936002)(5660300002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iq28mfGp8wKEB6lTfMmbMTWnqB4rztWR+IpP9vuCmb+LMouoM466PX6vsSLK?=
 =?us-ascii?Q?t17Qm6OT1hRORE5ZMaHM5yO9Se1MDeo7aImcxvEAGBThQ4lsF0Y/5J3mGgau?=
 =?us-ascii?Q?cW8LxM1fpXkMVLVnTG9jZxBgmltpYMb9634FFeoyGS8L0cZDABZCHEFq0jeY?=
 =?us-ascii?Q?dBvVGDDzqeLWIXuJWokbUVinqTtiQ/WIffHBMjgC1prAOpvBRKUm6WD2gdH5?=
 =?us-ascii?Q?1sv8eCwBA7J/JqMYYMpsnduua+sCZ2OHTLYbT6fqFm6cID+w6PA20qx7IBDI?=
 =?us-ascii?Q?Sy8x3ySNHM9leylGRBh181qH4w6R1TMs8uDe+Nce1S8zAssZ5B7xEHXS1TR6?=
 =?us-ascii?Q?sUh7Q2l7Lty8zO7Igo13xc2LqAA0KTo8NI6cUqnQrBEPiLD7drA8FZrD5K4h?=
 =?us-ascii?Q?lH1w1CA3js+ONcT8qKrZV3/3UiaqUK3MApq5waEaN5UHo6+GoqkNHclVSxsG?=
 =?us-ascii?Q?ok3MGZsFUJqVMyLFgonsHSH2IHNgyrTqc6v/5jECy/U4VlEsLIs0qE4uaXy3?=
 =?us-ascii?Q?6tUymd80PRmYlBfjktKZChEkt53MHQfhdLv/LQE31WNiVoneUKytWfjW2wQS?=
 =?us-ascii?Q?n3T00O+2KfGHgBA2N98uTUuA5EDoD/NrbRZ1Kkex3172XPtWYuJ5wxOAodFK?=
 =?us-ascii?Q?lRp/XDAYSPc0sXNTKV6PoyDA9hGtwVHwIBBTRV08ZBr+Y9nIeptwu17qCG1V?=
 =?us-ascii?Q?hvfSlsOghuWkIhpazsvNWErTreMvGB1Kfdjwgs+r+KY68TylpvG2YEvj7oMu?=
 =?us-ascii?Q?g5Rh85CvkWKo7B4hZ3EpPcBTHWVfAq8/Kwxzgmtx09IdRx0GqPEklcGonu5m?=
 =?us-ascii?Q?/f3ygQxAgCtKSjLjwCZhIBPBnHu7dnTduhkXX66FJfl8kw0KD9PGPFJgWxr4?=
 =?us-ascii?Q?wuKNEE18ngPSdNLiI7CJ2aVndbOcHuNJ7slSySsEeS6WIB3PFZjiq8JjS8YQ?=
 =?us-ascii?Q?EmZQgBKJS7IRpynQBzNxPSXTEnUG5iGeLtK03v0ff151W7I5pcqbYN6XHT+c?=
 =?us-ascii?Q?WHbDBBAKeHjn34MlFK64D6AJzlB0mXhsTnO57NSpE7TZ1C/ur+DWJwfWGUrl?=
 =?us-ascii?Q?x3kidxp5vYvrUwSAnNL2LmDEg5SzKih3BmPrZP2B2fS13VfFw9ndFzbICjEq?=
 =?us-ascii?Q?6mZihmM9OPmS4pX9xgGESPhPHgJvKWpZzFIwyYAgOeACBRpP5U/ErIVqD0am?=
 =?us-ascii?Q?ENv8kFYvSg6ijtNLScFvQsFKQhtWjWHhgBWbrE0Ee6whxWzwiI3LCK5Xl3MX?=
 =?us-ascii?Q?UuCdemmqX7lkW7kRR4s10or8pLwP7uF0Y+A4PQ3diQuQqPMVH0bAyN/7o/m0?=
 =?us-ascii?Q?3zxSRrlpx+ku1aU5InbOl7X+bxk072W3x7GHck7HUu38p/Dsntm6b6uTz0T7?=
 =?us-ascii?Q?cPoXR3Cy3rKMFeBIeQO/Hc+3Yi3kMvKP9UlPmgX7kYBTTW24/v2dc7B3B8Is?=
 =?us-ascii?Q?YqCrGL37JrOuiyVbdwGm8ToOjiqB6wVsvF6V09hpboUwMA4O3bNaWgbxua4b?=
 =?us-ascii?Q?vV+hnCUoWhN+CjkyKxhdaGENObcgrV0Ta/L82V5iEQexTEMGBoeBhPsrAXwc?=
 =?us-ascii?Q?JMVv5KVoG0Q37Owg76NByMJgyq3xdDkmpUb4Xk/o?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c0561e1-f4f7-400b-fd5e-08db73f453fc
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2023 14:15:42.2688
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QsSB9ZYrUpx0mzr9D0UiMqtMgXykR3X1MTwMn7JEHthzlEAABKDMGfvqmr8trRdF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9275
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 02, 2023 at 05:16:43AM -0700, Yi Liu wrote:
> From: Nicolin Chen <nicolinc@nvidia.com>
> 
> Previously, the detach routine is only done by the destroy(). And it was
> called by vfio_iommufd_emulated_unbind() when the device runs close(), so
> all the mappings in iopt were cleaned in that setup, when the call trace
> reaches this detach() routine.
> 
> Now, there's a need of a detach uAPI, meaning that it does not only need
> a new iommufd_access_detach() API, but also requires access->ops->unmap()
> call as a cleanup. So add one.
> 
> However, leaving that unprotected can introduce some potential of a race
> condition during the pin_/unpin_pages() call, where access->ioas->iopt is
> getting referenced. So, add an ioas_lock to protect the context of iopt
> referencings.
> 
> Also, to allow the iommufd_access_unpin_pages() callback to happen via
> this unmap() call, add an ioas_unpin pointer, so the unpin routine won't
> be affected by the "access->ioas = NULL" trick.
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Tested-by: Terrence Xu <terrence.xu@intel.com>
> Tested-by: Yanting Jiang <yanting.jiang@intel.com>
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/iommu/iommufd/device.c          | 76 +++++++++++++++++++++++--
>  drivers/iommu/iommufd/iommufd_private.h |  2 +
>  include/linux/iommufd.h                 |  1 +
>  3 files changed, 74 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/iommu/iommufd/device.c b/drivers/iommu/iommufd/device.c
> index 96d4281bfa7c..6b4ff635c15e 100644
> --- a/drivers/iommu/iommufd/device.c
> +++ b/drivers/iommu/iommufd/device.c
> @@ -486,6 +486,7 @@ iommufd_access_create(struct iommufd_ctx *ictx,
>  	iommufd_ctx_get(ictx);
>  	iommufd_object_finalize(ictx, &access->obj);
>  	*id = access->obj.id;
> +	mutex_init(&access->ioas_lock);
>  	return access;
>  }
>  EXPORT_SYMBOL_NS_GPL(iommufd_access_create, IOMMUFD);
> @@ -505,26 +506,66 @@ void iommufd_access_destroy(struct iommufd_access *access)
>  }
>  EXPORT_SYMBOL_NS_GPL(iommufd_access_destroy, IOMMUFD);
>  
> +static void __iommufd_access_detach(struct iommufd_access *access)
> +{
> +	struct iommufd_ioas *cur_ioas = access->ioas;
> +
> +	lockdep_assert_held(&access->ioas_lock);
> +	/*
> +	 * Set ioas to NULL to block any further iommufd_access_pin_pages().
> +	 * iommufd_access_unpin_pages() can continue using access->ioas_unpin.
> +	 */
> +	access->ioas = NULL;
> +
> +	if (access->ops->unmap) {
> +		mutex_unlock(&access->ioas_lock);
> +		access->ops->unmap(access->data, 0, ULONG_MAX);
> +		mutex_lock(&access->ioas_lock);
> +	}
> +	iopt_remove_access(&cur_ioas->iopt, access);
> +	refcount_dec(&cur_ioas->obj.users);
> +}
> +
> +void iommufd_access_detach(struct iommufd_access *access)
> +{
> +	mutex_lock(&access->ioas_lock);
> +	if (WARN_ON(!access->ioas))
> +		goto out;
> +	__iommufd_access_detach(access);
> +out:
> +	access->ioas_unpin = NULL;
> +	mutex_unlock(&access->ioas_lock);
> +}
> +EXPORT_SYMBOL_NS_GPL(iommufd_access_detach, IOMMUFD);

There is not really any benefit to make this two functions

> int iommufd_access_attach(struct iommufd_access *access, u32 ioas_id)
> {
[..]
> 	if (access->ioas) {

if (access->ioas || access->ioas_unpin) {

But I wonder if it should be a WARN_ON? Does VFIO protect against
the userspace racing detach and attach, or do we expect to do it here?

> @@ -579,8 +620,8 @@ void iommufd_access_notify_unmap(struct io_pagetable *iopt, unsigned long iova,
>  void iommufd_access_unpin_pages(struct iommufd_access *access,
>  				unsigned long iova, unsigned long length)
>  {
> -	struct io_pagetable *iopt = &access->ioas->iopt;
>  	struct iopt_area_contig_iter iter;
> +	struct io_pagetable *iopt;
>  	unsigned long last_iova;
>  	struct iopt_area *area;
>  
> @@ -588,6 +629,13 @@ void iommufd_access_unpin_pages(struct iommufd_access *access,
>  	    WARN_ON(check_add_overflow(iova, length - 1, &last_iova)))
>  		return;
>  
> +	mutex_lock(&access->ioas_lock);
> +	if (!access->ioas_unpin) {

This should be WARN_ON(), the driver has done something wrong if we
call this after the access has been detached.

Jason
