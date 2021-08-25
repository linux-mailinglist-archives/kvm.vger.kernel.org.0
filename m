Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0453F6CB1
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 02:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236589AbhHYAnO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 20:43:14 -0400
Received: from mail-dm6nam10on2074.outbound.protection.outlook.com ([40.107.93.74]:25434
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236487AbhHYAnN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Aug 2021 20:43:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dVu7M5iz3bqjJuPxeGpxMGw0RR0c71JT0/MINP54XhiTEHTAKQ6JGiA12PI/BKKeBjz/Riyx/bhibbYCXqQIvFYJswXu0PMhL6l9ONWMklEFCF/2L0Yq7dY09BzJpQUioa/FiKhYeC+Mmpj2y6Pk+xbzbUOgdDGkuiqFCXy0DYQTjPI9nvx+o77VINZKFDgRnv/C1zyA76D/EOBOdoupryaFSfF5uQltYdPghPvS3HL1+bj9zIS9XazbZpgY9jYcV4VcpOsO+M8k7lIgP8dMFfxLiuAkn36j4GrGxInQGfdG5mpn+n20xkaWZPD9C2Sdz558h/TToRA6eKFMBh78Cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yGCjT4yV9qxPHlRNxn654OWHPBo3RsMAsh4mYWOOGbM=;
 b=fZ8BtqfyxARB+VgfkDCAg1PXhDlUlTx9Sfc8a4SbD5BGpXGtEB6R5700MIAw+JxH3NseXkG1BIjjk1DOSiaepg/vS+GFFTHW7rv7NlOWF8hd5WkGKDnBh+Dc6QawZmsgAbzeZOlwqJxks4psF4nRW/NYhIjo9nh+r4pAcC1KeTgVsMBjhNui4jrHzM2pbJ5tQqtx3BsPWWMkLwt2VT1PiJYb6008/a+Y2ogsJflEWxBzWYWt2hDG7nsDCX16Z+tDppgJzCYwPBxXy7B+COurC+CbKCcUtfuXiJ7AmVgZxUaPd8tMTdSG8r++14rcuHRGs9OSglBYAsqu8ZS8gdwMmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yGCjT4yV9qxPHlRNxn654OWHPBo3RsMAsh4mYWOOGbM=;
 b=Gdl1TIUtKlsOVP0L2eY5HfKxeEfr6hize1GymV1hWaAaP0kIBlB+yjSLER1T3Y15jiq9jchNXNwIFSAGJEzwXFRIWLMdJ7DJS9bYVYACRzQqyTl5OSKS1zd+Ij6MOFLOMjgCIW8wJjEPAYrOm7WD2XUYz6i6iibgqdVtJsXFSMQVRzSDZ+UvZvG+nZ7eZ0miLrde4634UGdjaYjPdn9Xx1F3xahkhcJLFQx94gGc0LqmAQbKx4ebLJTXrpSqkVzMmJ5Ol5HVJutxQeWmVdhxBceh8ie2D4TTS64iuFinYaGWUX6jXQd7FTvYaCi0iVYVW9+BSh1nKe7ExI31aqLY/A==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5240.namprd12.prod.outlook.com (2603:10b6:208:319::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17; Wed, 25 Aug
 2021 00:42:27 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::1de1:52a9:cf66:f336]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::1de1:52a9:cf66:f336%8]) with mapi id 15.20.4436.024; Wed, 25 Aug 2021
 00:42:27 +0000
Date:   Tue, 24 Aug 2021 21:42:26 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Tony Krowiak <akrowiak@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        linux-s390@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Christoph Hellwig <hch@lst.de>, kvm@vger.kernel.org
Subject: Re: [PATCH v4] vfio/ap_ops: Convert to use vfio_register_group_dev()
Message-ID: <20210825004226.GC1721383@nvidia.com>
References: <0-v4-0203a4ab0596+f7-vfio_ap_jgg@nvidia.com>
 <20210824143001.37d01a77.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210824143001.37d01a77.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR16CA0016.namprd16.prod.outlook.com
 (2603:10b6:208:134::29) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR16CA0016.namprd16.prod.outlook.com (2603:10b6:208:134::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Wed, 25 Aug 2021 00:42:27 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mIgzq-004jQJ-IU; Tue, 24 Aug 2021 21:42:26 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b4badcd7-852c-42dd-76da-08d967613687
X-MS-TrafficTypeDiagnostic: BL1PR12MB5240:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5240EFD4BF66C43860F4585DC2C69@BL1PR12MB5240.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Lxei9CiESti1Ede17NLNCcLGRWxSnbYsaUvZ088P3XYkj1hGbscelVyquVTCt8dRRgCHnV1Ww83bTRNA96HzVsVGQpUp43btCXiapIFDHdfmcuKTC8o5jcOFNeIqTNT+BxJbWVw2sBVp8TqDnHVaJ9eLKa4eOU1f/9ao9zu9wxnXt7cn3HshXAUns+UOVPGr/euXAh8usA8i7V0gh04nV+8kL6f7Qdh5v9lEZ01kAkVebcHsWqlg2E7di9eneWi4xfAyX57cKEJmb159994YMPa+PyfzpiZ3OdEcfhB+YoMqlAeQv3oYo+6kRgg8Su6DC3AZMX3DdxGvq+0WZGmghZRmhkF45fLj5AOGcLzVk61JZFLbUCwUEd3Ifz5Gz/EH7/Vov9f/MykAAsFxF+KuOnv3KpwquzfNn6VuAqwA8kZ4Yn7swYtYP7ZfLu3j+n4fojrpmlx3+oDAtnc26AmIvSHxFH/1LTaO7cOOUwYF2rgvti0eth9YNkGYc/to2yT8gHZKdeD2xgK3rqrZh4N527Wgcn442+CjmZPO1Xav5llRKbe5rfzKFHz0WLPy9/WPtATuKJaydnv0Wt+3/7j+nOA2S47X39l+kg5b8yp0XA1X8t56+SLatQr5pB5kG+IVLW/dLRPxgSdhCzhuEk4QSg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(346002)(376002)(396003)(39850400004)(66556008)(38100700002)(66476007)(8676002)(8936002)(86362001)(426003)(26005)(186003)(66946007)(9786002)(9746002)(2906002)(5660300002)(4326008)(316002)(83380400001)(54906003)(36756003)(478600001)(1076003)(6916009)(2616005)(33656002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eMMZunFxwzEoirK7wpdpYksBNWDCkGV1mc6bsEFS3KSpJNz43SyJ1VTNzf3Q?=
 =?us-ascii?Q?2SkRS9UzYP35SQOMYV7Fl5Vs+2lbRZVR0384HEIhnNVjfR8pawA5swQjOh1X?=
 =?us-ascii?Q?hmqYF/GBcYmjVy9WsphQJ/jNrPFEJBj6RMlou6wqDd5LrFXG5IaMNhOJKrSK?=
 =?us-ascii?Q?KszyaIG3rO1M/Y8tiq9dh0i+RdzbNEkQue/Fmy4sGmkBCogFZ6TLJYe/G3xc?=
 =?us-ascii?Q?d55IOzocsSaT3vQrfHpNrsvWpsdy2vXSpqm9aSgp3OWwui4+IKPtUlODf7uF?=
 =?us-ascii?Q?s4irw8c+2Di+VceRzZg+na2oqUovGZqEhT1sj4scbLMcvoh+uJd21oj3FEga?=
 =?us-ascii?Q?4S2AwizVouhZvUdFWIkY5hCjPkiPYY7Y9je271pOcnBZRmnNy7E1dmyRh+O4?=
 =?us-ascii?Q?D/l9igrmLGhhPVi7Pd1BGPedngPvTS6A4qjyipp1Fme/vbj73S3bVLt2DmV+?=
 =?us-ascii?Q?r7gtWhMXdsfTB45r64sgjgcjQbo3hKI7fZVLPlOeSKi0i9TPpmdFaFTioeYh?=
 =?us-ascii?Q?wbAZoAitc4hDN0DCO0yrI2PhY9kXVHxYCdxSKH+XzSNpepZlO4nBSAVZE4yM?=
 =?us-ascii?Q?TinuSwT4H2yYMt9hjZtQBTHvCcKqVeSAb1JmiO/eZt8bDtGkR/2Nqtg4Zd7j?=
 =?us-ascii?Q?3xKwdY5pCn+hZBS0s+Aa1hh8lyUjdpgXa8XMQx5t5Kjzeo5CIW1YcRawejFl?=
 =?us-ascii?Q?lfgC8FcbDmbxDkbRXclYM3FyJiY5JqK71tqz9T64dSXumJuZ0+c9AplIj5yF?=
 =?us-ascii?Q?IBwtQxzBOREdr4ZpzYseM+3Mp/gLx3mYZYglV1XTGjj9+Zhv1mb6XCgFJabk?=
 =?us-ascii?Q?6ZfxZOjjdrsAAcK/E/k1jHUzcrztNA87dy98aMamKeP4YD6agvY8D/yp75AG?=
 =?us-ascii?Q?6EhEAI4N+tCb1Bhgub3+oXiI3Hptd52uLNJDgy+T1WJcRiyL+hgadli00CKs?=
 =?us-ascii?Q?QspXONpgYIkxn+nc33sJdNoT4z7qJH1YgPUowv7cdM53LekI27rM62TgImx0?=
 =?us-ascii?Q?T97LGwXIDazn7dRGC8hWo4wpdZw4h6ZkLUREtWVIdWHlLRyjT8Mk4hPEtVvc?=
 =?us-ascii?Q?/19EoR7+66+bm041ByTfpObTqQqNfRLWj027U2VMinF/wgzNIZuiflAW76my?=
 =?us-ascii?Q?XGZI/kS0D+rrnP9yh0jUEmAaYzYWoKdBm+C+HvytLC2GtZZA9GcW0t1PGx7H?=
 =?us-ascii?Q?gcg1z+jzsRY7egaeGsbkeKpc9vQPlBNU6T02+5bEQ8RRmfxP5HQx6Dhs1hu2?=
 =?us-ascii?Q?sbLaQbgqyiJHyJihCkf4tHLVJcji9MMeOLzVCEdLuO0GNRCnYFYRQSxy59ei?=
 =?us-ascii?Q?p1FFf5k16fbIleD2gcQU6X7r?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4badcd7-852c-42dd-76da-08d967613687
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2021 00:42:27.5515
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DIAI7a3ZwFjr1qMd1K2KjuQA/DdQ8aamdFfZSqtWxM2HUxxi57RJ6lFzYlomCBia
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5240
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 24, 2021 at 02:30:01PM -0600, Alex Williamson wrote:
> On Mon, 23 Aug 2021 11:42:04 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > This is straightforward conversion, the ap_matrix_mdev is actually serving
> > as the vfio_device and we can replace all the mdev_get_drvdata()'s with a
> > simple container_of() or a dev_get_drvdata() for sysfs paths.
> > 
> > Cc: Alex Williamson <alex.williamson@redhat.com>
> > Cc: Cornelia Huck <cohuck@redhat.com>
> > Cc: kvm@vger.kernel.org
> > Cc: Christoph Hellwig <hch@lst.de>
> > Reviewed-by: Tony Krowiak <akrowiak@linux.ibm.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> >  drivers/s390/crypto/vfio_ap_ops.c     | 155 +++++++++++++++-----------
> >  drivers/s390/crypto/vfio_ap_private.h |   2 +
> >  2 files changed, 91 insertions(+), 66 deletions(-)
> 
> Jason & Tony,
> 
> Would one of you please rebase on the other's series?  The merge
> conflict between this and 20210823212047.1476436-1-akrowiak@linux.ibm.com
> is more than I'd like to bury into a merge commit and I can't test beyond
> a cross compile.  Thanks,

Tony, as you have the Hw to test it is probably best if you do it, all
I can do is the same as Alex.

Thanks,
Jason
