Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 089483B4794
	for <lists+kvm@lfdr.de>; Fri, 25 Jun 2021 18:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbhFYQyV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Jun 2021 12:54:21 -0400
Received: from mail-dm6nam12on2082.outbound.protection.outlook.com ([40.107.243.82]:27232
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229586AbhFYQyU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Jun 2021 12:54:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ggJuwlYvHWqTZeptlWLri6V7GZt5965NpaDOvWQhu1LJvd1zR6Q4ggq0osNkNFZSODyja6bdCWVieDHMb56V94SpzXluUpyjCqQmEQKzEqB586sr5wAHszS5JnuHWQuh6DS/ARs2ASEgJ/rkw3DOg9RlLLpffRR9pfOwhuw+0xesMGBMQbyNsWpLZWtrJOllHCJASJyd88oKmVunTedbG9aZJnUpZUU6foDLwI9yJIM0xkIi2j1ChfwSv9oY9HC6Ezx0+TfASjYQsqequP3v/5Kx0gjGQuvnM0UiDuA2C3rJAv3fctTsoajpuWdUcc3trifTO9NnEcoWFj/Zqz2L6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m+1u0P+dC7tgSgOHWYyQz6EfhyeVmedKTvOkfpesKis=;
 b=feujoLrMKs+AAjkVcrwtwRM+Pf309SSxuDUTUqKtbe8eOtncEmRZ6tiu+ogV4PM7ywp6+nJlLRpFDzGJzSrBukRie86+85z7nTtd0ieAExCTwq+kV+EaPjHDhIhas/cLIxi5tVS+wpn2c6+W/gDLKGbXWbWDErJ9CTAv//NSB/pd/pWHsnNbF7V2e+B3+eKsnZrBgdyGXXEkz8MfPnX6TrBJcwKgrNDtloTi4VBw1uwGACXP+5jGKL19nSEaRkjYQcTYUVxHF+hshkL8OiWYcWGhy3zbNd2OAz0nGCB8nrE6xm/D8HGfo/RT/Kotgp1FQ6hyKPxU9NPVU9OUTxwLqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m+1u0P+dC7tgSgOHWYyQz6EfhyeVmedKTvOkfpesKis=;
 b=HgFTEQTeMMavE92K8o7XDZXFmXchQ6Jtg+wZDoXZsXxuaDUyPxXFVpN2IYrZKpFFXTqfoJT7Fe8nirQIi7ZQGj8LSZgTWDCAjC+/yxCXyoihd0eL5mf2hSGw4Dpd4MT9V02IwvMei3qpPcdOcOIMHm2HmCsWiiZr75gKUk+PQCJK3gMEDqqCz89NEUzyVe5LCpg2Bj9LuNkQFhkQimj9zmaKLbGY278CjTrD1fNSy1aWoYltJUFwLyFj+EQfmAa7J7DvFDexolhqZxPIdLeu1L/wSIgyUIbh8VvOKFodiAyFJbbdyt7XRd1wPLUh1CQ3BmUm3W7ll3k2QrnP1grVOQ==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5142.namprd12.prod.outlook.com (2603:10b6:208:312::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18; Fri, 25 Jun
 2021 16:51:59 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%8]) with mapi id 15.20.4264.023; Fri, 25 Jun 2021
 16:51:58 +0000
Date:   Fri, 25 Jun 2021 13:51:58 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] vfio/mtty: Delete mdev_devices_list
Message-ID: <20210625165158.GX2371267@nvidia.com>
References: <0-v1-0bc56b362ca7+62-mtty_used_ports_jgg@nvidia.com>
 <20210625102620.500ada5f.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210625102620.500ada5f.alex.williamson@redhat.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BL1PR13CA0422.namprd13.prod.outlook.com
 (2603:10b6:208:2c3::7) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BL1PR13CA0422.namprd13.prod.outlook.com (2603:10b6:208:2c3::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.14 via Frontend Transport; Fri, 25 Jun 2021 16:51:58 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lwp3e-00ClYG-6G; Fri, 25 Jun 2021 13:51:58 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0cb476c8-a07d-4742-4f09-08d937f98c2f
X-MS-TrafficTypeDiagnostic: BL1PR12MB5142:
X-Microsoft-Antispam-PRVS: <BL1PR12MB51420214D89FFC2FFE8E2B33C2069@BL1PR12MB5142.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kQ6fBImtQ75lUqxogOy9Ff+ug4o7nHLX5/p7HgLsxAyK/FBei0X7wfqVA2xRqP0iq9DV2mXmuGlUWQcYli5nbF5TGEiIZSzYoV4Iwgr4dxC7TLfyroq8i+WhB17I5HH1G1g8zgxiPGDowAg4esGP8hr59uWfDWJfTTMMZ5gKpkHEeAf68T0cNDikeHnQn0cNJPCYBA4pRvj5no4W1xQJLp0CL/QT9Nl6ppGjFfdB3RG0Z/qymqQK5UI/mKS2oZanwPdLoA42WHcKSartsGLDrTnT1aOSrmCNAbBrfNA1/AkU/3CXh+IpGw1n5ta2DoJyzWbtpI/6UtBHCNIuJLQg4Cz+gQIW/hBWRyeNP34hLCEO7uiPbxkwGc2Vt/nvzoKhHOGG5EyI90sL2bTLDvVZoIk7rAF8LvJApRp9dcvIAEG5kac0a3fTAM5eDxGvbQakqUTMotfg/oZVrwDpjyriujCxmPUmRITF+OGsK0WlQWQAloZdHVohBa58rDGxPM+QG56HA2GwP0unu9MlU0CxSCBw3N2AY7vQj9D4Ge2TKEE0WH0Uc/I6dRgXzhTkZUCsfGgvySLNfwJXgljEP58IzEx1b6mmVGKXnTZawZ+t0kU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(376002)(396003)(366004)(39860400002)(83380400001)(426003)(1076003)(2906002)(38100700002)(2616005)(5660300002)(86362001)(4326008)(33656002)(66556008)(26005)(8936002)(478600001)(66946007)(186003)(9786002)(9746002)(6916009)(36756003)(8676002)(66476007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xVlRU/nqm0OxNJQo81mN70+ZoLbq/argFWQJJdQKPsur5qkOQLYDMuXW20i/?=
 =?us-ascii?Q?fI+b7w5yPkGNaeqcC0Occjb+1l2D5OKYUT1x59DX1kbMu4DBDu/42ya/aexH?=
 =?us-ascii?Q?l13UjYWlK8PHe+xYXEVBj9bdlJE9g5Pk9+HPC+hRYm0EYIIC+yjrT0fAFzxe?=
 =?us-ascii?Q?FmOzeHrqn6B5emOtIrOpoj9D5hEB6a2rV3O8zc9bp10mJ56rKhudrrdPNWd5?=
 =?us-ascii?Q?cwigX1vYhJINO4RD+DvmE5zTt1mLpW78dwVZ39EmHRnbyr3iw6q7ovzV9NUe?=
 =?us-ascii?Q?aDQQMm+YZ+Zop6WKsjw5x7gyvSIcUrVCZNr2OZGrYg1S/tmlkPeASuyFZg2w?=
 =?us-ascii?Q?MjbZ0uBdXX5xJyu33q9a7f3b8ccFRRDguIvSxZW9Zs1br//+TThqRZQCxP6n?=
 =?us-ascii?Q?yxHELQ7TmDkDOGGcpp6+RDMQQR4WMEhmxxgWLXHNOnhhKpXdz7PINsoYlJeQ?=
 =?us-ascii?Q?UEUuA5YFqPk5aVAvjaPNFkC7PbxOBXk3qDCDCoIHli0KZER2dzEfzxEygLUZ?=
 =?us-ascii?Q?b00SqTXTEtf9jVBtc+x6pABhWhrZ7mFpCoCyhSIf+fL3GVFz9bUSMyQerbMJ?=
 =?us-ascii?Q?fZoIs74FmztqETG38TVbv2QgXTqjRMnHC9TN49Y3tZKXjdyE4dFDvbVr2t4I?=
 =?us-ascii?Q?fF8oxNvUHCLZ9wER86XQlqATGrz4Tcxw8oovK2gKl72tOI2dr6dCFRw6Xz7I?=
 =?us-ascii?Q?g1ZqDrfT4otl3NcJogBc1MW+0X22YPb32dr+Di1HvKbx4dE8AG73pYHTi5c9?=
 =?us-ascii?Q?dfujNto8sIW+VPXwEASFqIjtA2DpMssUc1ZfwMtvhfPmgliIclAFtMZgbVPJ?=
 =?us-ascii?Q?9wqWQ9MJxXCVITVIs+Zc2QLN+PyywgM9V6RU1JWfQaNnw7uQ9hk2g1I9lGcN?=
 =?us-ascii?Q?odD0vQdAskK34/YbnxM58ojAa4gUn+fOQxosSkT+W2P3HJyrDd2+kah+I+13?=
 =?us-ascii?Q?RJPiEbM8yWobLN+w1p1kKiFFLA0cO/L+lq8rhtnzvhOLIw4GOpvfKF3qHX9H?=
 =?us-ascii?Q?9TOPUbBPt/Qd7mWg6BAfi6FAeIA7CI0XfN3ehfr1JNfR7ppdnefI0NZ8BspN?=
 =?us-ascii?Q?Kd+hxDyjjsdFq87GKbo1yVip/QE82KgEzddvvTpWjc1KkszQIrrYMTzqjBYU?=
 =?us-ascii?Q?pMifuU36r5FO4gctTYC1M8MyUZj++gzfrtSa5u5Ih8W8lah2ltbTW9t9Mknb?=
 =?us-ascii?Q?VWtZ1yBmNNCt1aV7BwWv6JZJLbXpzD93beMSDxrsIfsu6BXWYAwakKIqvbIb?=
 =?us-ascii?Q?D+pRNjVgmpaTIhAapbyxZIIVafMNCbzHFXrQLGLghC+v0LFRD2pifZRvSI83?=
 =?us-ascii?Q?zgfvsgiwpAUFh8mC8R0THcBH?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cb476c8-a07d-4742-4f09-08d937f98c2f
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2021 16:51:58.8906
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e9JxcQ6vhvTcU436OPxaWJnhmRZ6cIkGtuPJAGefJyFAv+igHtDFknmaRI+FbzUI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5142
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 25, 2021 at 10:26:20AM -0600, Alex Williamson wrote:
> On Fri, 25 Jun 2021 12:56:04 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > Dan points out that an error case left things on this list. It is also
> > missing locking in available_instances_show().
> > 
> > Further study shows the list isn't needed at all, just store the total
> > ports in use in an atomic and delete the whole thing.
> > 
> > Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> > Fixes: 09177ac91921 ("vfio/mtty: Convert to use vfio_register_group_dev()")
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> >  samples/vfio-mdev/mtty.c | 24 ++++++------------------
> >  1 file changed, 6 insertions(+), 18 deletions(-)
> > 
> > diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
> > index faf9b8e8873a5b..ffbaf07a17eaee 100644
> > +++ b/samples/vfio-mdev/mtty.c
> > @@ -144,8 +144,7 @@ struct mdev_state {
> >  	int nr_ports;
> >  };
> >  
> > -static struct mutex mdev_list_lock;
> > -static struct list_head mdev_devices_list;
> > +static atomic_t mdev_used_ports;
> >  
> >  static const struct file_operations vd_fops = {
> >  	.owner          = THIS_MODULE,
> > @@ -733,15 +732,13 @@ static int mtty_probe(struct mdev_device *mdev)
> >  
> >  	mtty_create_config_space(mdev_state);
> >  
> > -	mutex_lock(&mdev_list_lock);
> > -	list_add(&mdev_state->next, &mdev_devices_list);
> > -	mutex_unlock(&mdev_list_lock);
> > -
> >  	ret = vfio_register_group_dev(&mdev_state->vdev);
> >  	if (ret) {
> >  		kfree(mdev_state);
> >  		return ret;
> >  	}
> > +	atomic_add(mdev_state->nr_ports, &mdev_used_ports);
> > +
> 
> I was just looking at the same and noticing how available_instances is
> not enforced :-\

I saw that too - it is something someone could do on top of this
atomic change without too much trouble. I'm not sure it is worthwhile
to work on these samples too much

> What if we ATOMIC_INIT(MAX_TTYS) and use this as available ports
> rather than used ports.  We can check and return -ENOSPC at the
> beginning or probe if we can't allocate the ports.  The only
> complication is when we need to atomically subtract >1 and not go
> negative.

It is usually done with a cmpxchg loop:

static inline int atomic_sub_if_positive(int i, atomic_t *v)
{
        int dec, c = atomic_read(v);

        do {
                dec = c - i;
                if (unlikely(dec < 0))
                        break;
        } while (!atomic_try_cmpxchg(v, &c, dec));

        return dec;
}

Or even a simple logic with atomic_sub_return() would do well enough
for this.

Jason
