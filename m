Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B6DC664816
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 19:05:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235204AbjAJSF0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 13:05:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238751AbjAJSEt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 13:04:49 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2084.outbound.protection.outlook.com [40.107.223.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A01CC848DC
        for <kvm@vger.kernel.org>; Tue, 10 Jan 2023 10:02:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S0fQi0C8289QsK73Mj9Y0j2v7kr8e/v8L4NzXiRGjWpUuiQjBxHpQb6sl5/nH6ibW5xkDxKFhi9Ced0uHDUNXy9cQC0xqSXUhHQ62KFAqkUftZdgrbuXL5NB9ViMMIT29mtwHxRlZ1JoMf7lcVPDJsFzVFP7xGzEnOV+9Tc/7b8lydL8xHekvUA3cNLU47wW2KBIYI+q88v7FU8nX6/Dv+msC5oz8ZiLo2C1FPDpMrf0gpvCrVbE2yNWjwuE8iBqjOKzI5m6GIWOQ3H60VNPmXJE4p6jpuRbTKQRBfzcDtmxHX56RzlgkjwjQeByX1tlGzJVP9L5DNVAnUpJXLHPDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=srXpbfC6nH1etkV+fJbht+O3lVS315h69/HcWQTXWVU=;
 b=Ix6f97NXjgvl0DKvexZdFJmDx1yCeeh50NDv3fYIAhm5DSJCGrZ8GbNq8sv7gKyfnOqsG/xjTCSOVNvPeg9NQW8BqsjVDp79AiczFs8eB5mO6lHzrpdR6OIhcmsHyYo+tR7ZB9grHP+SIzI9vCGpvYJs6kRqKKz92OeR2dBlanaCXvT9XtoPD7wlxj6CO2lYuJ3eBfh6KWQzSyklCw4Za9qol8beTtlP10BI1+jgAOzYA7y886cSU2+RUdXtphGeVxvxzfTr6cZ7E1yCot9asJZfVHWaxgFep6rP0NRMQVJqHac9jSaSqIRXvGnK35OmneAQrsBkCjHc07zZlp+5VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=srXpbfC6nH1etkV+fJbht+O3lVS315h69/HcWQTXWVU=;
 b=ZuOC+Arz547Ht4xe1KuUTqkMFiG+UukSxXdjXmLLYuz8D8QdCd2CNZP3DR8/9UshzERmxuwfgX9c0PwFASaYNSo6XrKaQ0w9lVm6EA+PvV7YzvOhpEdnfzVXRZRUwB+cRkbAMc8gUrjzB4dnn4pU/N4cn2bzj5Ny7nZjPIPCeH51R7hyhcLiUy1RTDYQx4ZtuJsbZ73uAXMBDnxIAMNVLgKUQo8hbpv7qsBlk5Om4fMWhUhOU4HhatHDp2VDmUWLicDMQc9YTYB6En04rEbJWWaMnwiJUSbfNj/HhQVh0Z/tUxPGlJS8dNOz4FlgmEQIn3wOHnizzWnSb7dwtO+K2g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ0PR12MB7459.namprd12.prod.outlook.com (2603:10b6:a03:48d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.10; Tue, 10 Jan
 2023 18:02:52 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5986.018; Tue, 10 Jan 2023
 18:02:52 +0000
Date:   Tue, 10 Jan 2023 14:02:50 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: Re: [PATCH] vfio: Support VFIO_NOIOMMU with iommufd
Message-ID: <Y72oSgke7RI4bffg@nvidia.com>
References: <0-v1-5cde901db21d+661fe-iommufd_noiommu_jgg@nvidia.com>
 <BN9PR11MB5276893EAD2587164F9F94878CFF9@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276893EAD2587164F9F94878CFF9@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL1PR13CA0404.namprd13.prod.outlook.com
 (2603:10b6:208:2c2::19) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ0PR12MB7459:EE_
X-MS-Office365-Filtering-Correlation-Id: d177b714-35c8-49a1-dc3e-08daf334e454
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QR0XPUlYYy3WsesJEtzQdLnOjrH+aWvMJvpsI1ivO9b7hHilkLDMf5TMsa8RUUX42GzzPaOMSI76oDkFvDZVc3F0cHpQWF8NiHN5z1VZ3Z/VbfYIvCEpil3ueKlLn5njTtMQAghVi1G2Gr7eu5NXUc7M6hF6Yw5O4TZQi+etV+XVS9JtXdngTrUvMEBoh/TFc59TEev5yaM4Jg5kPGI20WvnAr+o1aLwQidrYdCrGe1uhlmQ9/G2dAIfzGAcCxyy6Vbmu9+lxKvq3GEhL1yAOQdNP+y84M6mfEulZIerY21vJ9LmEj+cRtFFCAI7+zdAsjHetNjzj0hHiBaqOMaS9F23AAtm6YtUWp1PGQjM5wA9gP3rPm2Hn/JbYViJBvCeLDUSZ5DbxrI0RF7A5zUUnOgyHB+VBgaOf481NPcEl1quPBdKQI08laE6MCHSzITtDd6oGhvUMgoJjesK76CL66cg+aOVRrgixCSlMgAiUS//tMmYNPTNJ2xW3BJChmITOdlfp1c6tzsQURWU4jWU+IfAVYCi4YvNrF0sewGsC2M4jW6gG0CDSj25W7SvL3Nz6FNt0jChHyzoqWOttsI28T6aNfW3qRDUe4KiE3nzlWArv2X3HWUucpr8GEH/g7kaaOqfOgBpEqOu3d5cweRkxg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(39860400002)(366004)(136003)(376002)(451199015)(2906002)(41300700001)(66556008)(4326008)(66946007)(6916009)(66476007)(8676002)(8936002)(5660300002)(86362001)(36756003)(6486002)(83380400001)(26005)(6512007)(186003)(478600001)(6506007)(2616005)(316002)(54906003)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?U/xN8H9WVWvHs0EvVz0q/54LmXXF9MIRTwnHFJP9y1pk9DNnsW2UcSyySvsT?=
 =?us-ascii?Q?zRdJ52K9p/eGzqsqgzZ/rSHiuvdr49VJYBBGUtbPEVrwTREFKz+mvN47zNGY?=
 =?us-ascii?Q?+CqjFDiLX046TVuEKOyhCQXEOTBudbArIfVl8K0KTxJ9KEs2Q5DR7gNALBMa?=
 =?us-ascii?Q?xdFZuB4ATUwZtmTFoJbFNy3R7UfxWoxPXKqUwub5yuLm2E/8/PQYbntRFVBQ?=
 =?us-ascii?Q?bp5BVSZusguwvSRY1jI8pSq46AuiK8jkdJUr8XFsMQdmHOg6FQD6atJHe9jI?=
 =?us-ascii?Q?Nlf8dlzCPi2Q8jb96ifJFKMA96Hj0aLRgYQTp615XJzp5i8DRipOxfDhUMDm?=
 =?us-ascii?Q?Bua+n+fDApaagYlb0Z1QHWIVW5QqcX+1eE01kEHvBwKIkZboBPpzGguNVntB?=
 =?us-ascii?Q?+wx6+BckxhCpGkT5FQV2/kEiw4nXmUoOoh4iBcOGAAZ4yknxRJdpMDlQiA9C?=
 =?us-ascii?Q?lgxBCyVStZdxxICQkMq4FSNBHLL6GtiHh+6XTead+mDL9X6U/E6VvukvUL4e?=
 =?us-ascii?Q?sHtvU92g4NoYh3/smc4BaQV4wxYe4I1TG4MuPvpwODI/kmeLZwAXIg2qIfYD?=
 =?us-ascii?Q?UO0EWG/aUCU0qLsLNJTKjScPeiMurcdrxdCsGXrNb4esLPrhdC+xj1mMRUiI?=
 =?us-ascii?Q?y3hOYGOjThcBhwuyegRBvPOqx1JnW2EGjeHWrq6zSS22xO54Z0q4BjpXB3x9?=
 =?us-ascii?Q?fBm7jcGCZFm/7k5icxs+QowBljeO7dcSoUXbbcb2v9CEpIHqhQaFGWznoeC/?=
 =?us-ascii?Q?nom41p4Rc0AU6lb7DhttPLMmOglIVlun3JcTK9Q8r56HGX0d0lhz26LOEs9V?=
 =?us-ascii?Q?JCDqSy3uBGYNf5zrbX0NgNryej3LX7l5d8tbSJrZQoK64MflcFBXr1yqhb3E?=
 =?us-ascii?Q?efbiPChazKsWGyvfkwNOu5MrUNBz/svqeoQjbojetaIx6xYMinmEBBfWb/Zq?=
 =?us-ascii?Q?O2hfez5ou4IWMQYkkFMCfUbE6la+KIvcphiC+FeXWp0/s+VNcPC+5jQ/Vzzb?=
 =?us-ascii?Q?r09LDgi9I0oVYEy9X6vnD1j0MGdfheXZNqOwXirCUsa4PK2PZv/I6yMMcd/c?=
 =?us-ascii?Q?GKIN7jG56hLT+NeX9SmCf8WbTfzI88TENBLljY8R4GcQhCcdnFaFX3Hi+36y?=
 =?us-ascii?Q?HduJCVz1vrDc4UQaPADJvqJ2HGMm33JCn6wY7ujEjL1d9HmHAWjk9cAZDpn8?=
 =?us-ascii?Q?Z4Vr9c1PgbWltWi+RIkvpYP2Ia8iW8WCS6fhowRsri+iUEzBR1K7pytMaJ9t?=
 =?us-ascii?Q?KDx75sr/H0cvjfPxU3Vog9h5u1QUAabTb8e2UCbqIudfntM+1tIQdzhLfEMi?=
 =?us-ascii?Q?G/WgGAYz6AkLnnaW3k4SvcXaJ6yLpy8+IItUlcUCM84ZAPxAqmxl4mD805Hy?=
 =?us-ascii?Q?GdP6+JZLndvjHPlPmrADKWQ1lc/dfRJ86npwe9jTBiITJs1BDwwKfcT5Rijx?=
 =?us-ascii?Q?O5CT+CFEw768YtliJeCVjkJL7aP70a99VGJ1zeFAaN84gSI/9jvRA9uEikHs?=
 =?us-ascii?Q?5v8UiMzJ+mT+j7aYt4X1w8xW5SYstKnBJ1iLyUKF8y/+tDc72OU0bToakHXu?=
 =?us-ascii?Q?xZ8MWU50GBFdX09lplUFoEWnz6On9N3RwK9HOdAa?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d177b714-35c8-49a1-dc3e-08daf334e454
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2023 18:02:52.2680
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pibh99dat4Cfdv/bGPNn8qM4Jvya20d8ZBoj1Y6D9rNFQAD3JfSG16iOgkVTgdvG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB7459
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 10, 2023 at 06:20:33AM +0000, Tian, Kevin wrote:
> > +/**
> > + * iommufd_vfio_compat_ioas_create_id - Return the IOAS ID that vfio
> 
> 'ID' is not returned in this case.
> 
> and it's slightly clearer to remove the trailing '_id' in the function name.
> 
> > @@ -235,6 +253,9 @@ static int iommufd_vfio_check_extension(struct
> > iommufd_ctx *ictx,
> >  	case VFIO_UNMAP_ALL:
> >  		return 1;
> > 
> > +	case VFIO_NOIOMMU_IOMMU:
> > +	return IS_ENABLED(CONFIG_VFIO_NOIOMMU);
> > +
> 
> also check vfio_noiommu?

Can't easily, that value is in another module

> Another subtle difference. The container path has below check which applies
> to noiommu:
> 
> 	/*
> 	 * The container is designed to be an unprivileged interface while
> 	 * the group can be assigned to specific users.  Therefore, only by
> 	 * adding a group to a container does the user get the privilege of
> 	 * enabling the iommu, which may allocate finite resources.  There
> 	 * is no unset_iommu, but by removing all the groups from a container,
> 	 * the container is deprivileged and returns to an unset state.
> 	 */
> 	if (list_empty(&container->group_list) || container->iommu_driver) {
> 		up_write(&container->group_lock);
> 		return -EINVAL;
> 	}

We don't follow that model in iommufd, once you have an iommufd you
can immediately start allocating resources, and it is not considered
"unprivileged". Instead all resource usage is constrained by the cgroup

I suppose it is something of a difference in IOMMUFD_VFIO_CONTAINER
that it behaves like this, but fixing it is not related to noiommu

> > @@ -133,12 +133,13 @@ static int vfio_group_ioctl_set_container(struct
> > vfio_group *group,
> > 
> >  	iommufd = iommufd_ctx_from_file(f.file);
> >  	if (!IS_ERR(iommufd)) {
> > -		u32 ioas_id;
> > -
> > -		ret = iommufd_vfio_compat_ioas_id(iommufd, &ioas_id);
> > -		if (ret) {
> > -			iommufd_ctx_put(group->iommufd);
> > -			goto out_unlock;
> > +		if (!IS_ENABLED(CONFIG_VFIO_NO_IOMMU) ||
> > +		    group->type != VFIO_NO_IOMMU) {
> > +			ret =
> > iommufd_vfio_compat_ioas_create_id(iommufd);
> > +			if (ret) {
> > +				iommufd_ctx_put(group->iommufd);
> > +				goto out_unlock;
> > +			}
> 
> This doesn't prevent userspace from mixing noiommu and the check
> in vfio_iommufd_bind() is partial which only ensures no compat ioas
> when binding a noiommu device. It's still possible to bind a VFIO_IOMMU
> type device and create the compat ioas afterwards.

There are many ways to have an IOAS but also have an iommufd "bound"
to a noiommu device - userspace could just use the native iommufd
interface, or mess with the IOMMUFD_CMD_VFIO_IOAS, for instance.

I don't really want to get to the same kind of protection as vfio
typically did because it would be very invasive for little gain.

So long as a well behaved userspace does not become confused that it
thinks there is translation but none exists I think this is good
enough.

The way it is set here is if userspace somehow had a compat IOAS
assigned then things will fail, and if it attempts to do a map after
binding then it will also fail. This is enough to protect well behaved
userspace.

This will become more explicit in the cdev stuff where userspace must
explicitly specify -1 as the iommufd to run in noiommu and userspace
cannot become confused.

Jason
