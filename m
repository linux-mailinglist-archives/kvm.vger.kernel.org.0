Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 235FA38DE22
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 01:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232145AbhEWXrk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 23 May 2021 19:47:40 -0400
Received: from mail-dm6nam11on2075.outbound.protection.outlook.com ([40.107.223.75]:36890
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231982AbhEWXrh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 23 May 2021 19:47:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZaqhCb/ESIv0hOnct/fJpC9vheV0eO/NFJ4xOpt4qcoJ0dffj14zEzgAPYewCRP+pVq4CCwO7wMLszrdE9QZOfysNWspqqCvNUta7j/uRSc8pQZFih/0byfOgWo925ccMkDLQvJnCY+9k0Rs5zKvgPUSnqeNJU6hnFSigFHmwmgBBWG88Syb0otLVo714K1uzp1kmROtg2+ic5HWMmEpV/saYhEwphB9SjTZhbcDo3cyin/ww55GMoFzASAWsCAUMleEemh06KO/lEHHuTH5Mgrs0MkJwSndF/S+duajoPfAUWkuWElcONJz5dbMsw9ZdNNqwQ5VmGFhJbFLMBdxAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hmVjzy+htPOyEHSlJh5MQCeyjqJSLoIwCkZ5bqmu4OM=;
 b=fKFMz2HWCZc+/cr5CNQvnvDaNZNEWwIV6MDnSGTJGxEZ95l/Gamzr6InGpfrcbK7q6DfHFa247QfKrWKTvPOO7A+DbpQSBh/N80B8PzAy7jI6bfg6qEdaTrd5RfAfWaIyaSfCKXMYPtwvf5nCqpoJBF3c8vvZpO5Ku6egFFnxIM7tODvRIgn3WE2Z48L/oi3TmQlWIWBL3IldGtKRtpVsovGGfm53R9aHhbb/W+ZMbvJJjLtu7s17PBIbeGIpxbYHb1L07W+kQ/QRS+Kj0GdKsKESNGOtMYbB8FIU8QKRvEtUePpWoqor+3emb7hh8SIpjNQvZnQa1WcCEP/EQZdhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hmVjzy+htPOyEHSlJh5MQCeyjqJSLoIwCkZ5bqmu4OM=;
 b=M8+QDcwhbbQ8MF4mhmEsPCvbmYt5ob2jowyCnnkphFzEJ27LHhXGFx7JHDgKI0q+s0dApXU9X6y/R4VaAys6XpTPnJMyXvkmtGw/Xqta8gIOjaEihYKS8dLBG+pc9qTiDh3ERK9K/nFEeDd8ahjLfdLQdkQvWKS0lpT9pq/W32yGyitpUkQlUxcV8YKUTesxPHyy11K4ChmoQRIGoJLMjoJQ4dgen0XPoM2u6BRpeC9Si++LMfd3kZ6FrkHtAIipv2AGYpUPkmH4tqHmwaawJvIrT7zSVHuJ+afRWtYNNgTDqmTQAZayqszZFulydDOsUO+5ea9XwgXsKoYfUv7nhg==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5287.namprd12.prod.outlook.com (2603:10b6:208:317::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26; Sun, 23 May
 2021 23:46:08 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%7]) with mapi id 15.20.4150.027; Sun, 23 May 2021
 23:46:08 +0000
Date:   Sun, 23 May 2021 20:46:06 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Dave Jiang <dave.jiang@intel.com>
Cc:     alex.williamson@redhat.com, kwankhede@nvidia.com,
        tglx@linutronix.de, vkoul@kernel.org, megha.dey@intel.com,
        jacob.jun.pan@intel.com, ashok.raj@intel.com, yi.l.liu@intel.com,
        baolu.lu@intel.com, kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, dan.j.williams@intel.com,
        eric.auger@redhat.com, pbonzini@redhat.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v6 13/20] vfio/mdev: idxd: add mdev driver registration
 and helper functions
Message-ID: <20210523234606.GJ1002214@nvidia.com>
References: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
 <162164282601.261970.10405911922092921185.stgit@djiang5-desk3.ch.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162164282601.261970.10405911922092921185.stgit@djiang5-desk3.ch.intel.com>
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: YTBPR01CA0017.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:14::30) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by YTBPR01CA0017.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:14::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.27 via Frontend Transport; Sun, 23 May 2021 23:46:08 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lkxnK-00DUxd-AR; Sun, 23 May 2021 20:46:06 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 56fc8848-7a5b-46eb-0c83-08d91e44f01f
X-MS-TrafficTypeDiagnostic: BL1PR12MB5287:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB52876E000137CE66B9B51C3CC2279@BL1PR12MB5287.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ghj2tlS7wXAjix5OrIie2vr6QAve+LGODm2+c4cdpkXfBJjiRgpzr5opnUxzFC6WNJ+b/ypEHpryAGzosjgLER+v2wYNZ3Qd5guzsedbkN2uuYnembjb7+rI1fXaGavCQu2/P04x47sRekKKVK2Dy0+A/EMTSPIzl+4fqw3LHdf1kRYGhsc8J71idXLbSeLIcL9OLMu+izwXlYRBlb3zyfEMcz4HoWgUpyGDAVXbI6sIjgzNgtnMWiPEeOtT/Jqc0kpY5Kazlzx+BfrFHuCYOSf/Hdobbj43uNsAXf7rGauHOZLLXjd/8OCJ0MfNqLQLh6Aph2GoOxjO/cPOT8eJzms8x6/vU01zFno8cr7BP1luZv8YrcipfIlp0thlv1JyPS8b+uE9zKD3So7YFZ12zMoNB3oeavLLT6qimbt3H380BHTZwnZYkx1wJKSPypBFPx2oczuu0D8iOdMDYNKQc0B8tHwjlpdXP1nKRGv4TFiYXi2ejvLf2kzlf2t6Upkir/1NZP6Nq6Vc68/pHCgOEfOiYbe7h+Sh4eaStu3OFJoOKvuXWSgIfdRrYBlMIb9I2STeWIld3Cf8Gi+olSQ1hVL+2TU5K4oVSCNwEfVBiVI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(39860400002)(376002)(396003)(346002)(36756003)(83380400001)(316002)(478600001)(8676002)(8936002)(4326008)(33656002)(186003)(66946007)(2616005)(38100700002)(1076003)(26005)(86362001)(6916009)(9746002)(5660300002)(426003)(2906002)(66476007)(66556008)(7416002)(9786002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?6ps8Wm8VJGfmOx8XcJQRErnLL2wB9erbiU/zyBsxpW31vuNjdTM3mK7qPcXf?=
 =?us-ascii?Q?MEWk6CbVnb8MCsFm9eykkQ9HirEzqjLUwuw7lRWcOR5xUaBoofHXhPAl83lY?=
 =?us-ascii?Q?jEXbNYm/M+/aE884H4G0HTMhDWdkdtldt/IwEzV/89hj3Dk5voiZyUOrFbOG?=
 =?us-ascii?Q?HYtjUXq5+EYwxrDpyD7KIsca1D+5od1zhuYXGxEJOt5ftL5/BkqT6PHCtgHm?=
 =?us-ascii?Q?VrzTv/SwoewBtUUpIiQDzWqHX7uZHLlyPMYSf3zsB2MJm9IpIOZROYUI35FK?=
 =?us-ascii?Q?mosWqLQIoBBk5liCNBZcJ1NNjLhb6yTjOTde9YHfmwxXN/0TGQRY8AaZonn3?=
 =?us-ascii?Q?bWUaIteSrgZyx4o1iGFKLI/JJmj/CC0x+M/n2v64wkDd7UXhVUZQR9WwT3g+?=
 =?us-ascii?Q?8q59UBVsbnaeBIup/VDXWrQThc7jnigEJu2isDURsO8OIZ2Zgzudc/RPKFA8?=
 =?us-ascii?Q?6mh3DrZppMjE4mCW/cwtZH+xCWLnxF1+C0KJ4FYadUjyHYRlcZKeMA58K0ru?=
 =?us-ascii?Q?6jaath1pvHe21zAbhTXXqXtr4YEp3CbIbCy3UDIoWSb17OC8LmYSiDaaIII0?=
 =?us-ascii?Q?PFvhpBgN9Rixzh/Cqn+zz8b+xRB9QkZMjy8bjdcypgXimLanrIhaJG9u2FDf?=
 =?us-ascii?Q?rPPbupWpveefcyKc7uJCLS8DfIhDaGp1/qDSnRCRfSkpCY9i8KtmgWpdrna5?=
 =?us-ascii?Q?OoiWWYJyoZlNKUekYtnI5jg91I/3/QErkgMGCvOol6ZmDja6wMadsvmclkre?=
 =?us-ascii?Q?+bKS7KB+Ob3wM6V5oSRzq8kKmCW0GNMol98xrDqumO46n4zwYhDZ+IUSLyoN?=
 =?us-ascii?Q?Z0wU3MBMiyZ7UkEMK4qyiB6h4LjPNQBpMASSq6GMKQGLTgI0Pt4J4eu+IBSe?=
 =?us-ascii?Q?p75syYD538il9wy32WJ1JAquDMwT0DwEMvejwicoDqnYKJoh3363gJCy6qM/?=
 =?us-ascii?Q?08NFPryQDFoJJ2N25e46ygf0hgNx4G+YA7Y1k4Bzkpndzzwu5G8nPURLZ25k?=
 =?us-ascii?Q?gpWyjYbIbtWhLMQ9t1CuhL6mdd5fZkeI92SyefjGbiw4U9FI50EXRa74Adj6?=
 =?us-ascii?Q?p0kc1M+QTuLC73GuerZX/nv3phdVxFfO06ID5FN6jcTpTJiE9gibkhZCF4ip?=
 =?us-ascii?Q?VZGc55Fg1bpPGVDehNYtOFLLMCotK4wYEvokA+/bIaZLUuzE1vLVwGBQJxFf?=
 =?us-ascii?Q?QHOiOcxXl0ivxCQFLeyPWHcSVO5c86qg9DYtppAJn5ldUzr5921t8v0M1a1g?=
 =?us-ascii?Q?xyTkpNQVvONVuZ4mxUKjPbw2Ua5a+o9vbzUsrkm0tJV/uwtAJtrxivdApoFH?=
 =?us-ascii?Q?fvJmj+Uyx9QTaRAy4OwcoT84?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56fc8848-7a5b-46eb-0c83-08d91e44f01f
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2021 23:46:08.6574
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: saFvWAik6Fjfz+nBvSSJzRKWesxW6Q+EvVtbv2t68SMqlEc8X4qTq5RoKoOgowkI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5287
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 21, 2021 at 05:20:26PM -0700, Dave Jiang wrote:

> +static int idxd_vdcm_probe(struct mdev_device *mdev)
> +{
> +	struct vdcm_idxd *vidxd;
> +	struct vdcm_idxd_type *type;
> +	struct device *dev, *parent;
> +	struct idxd_device *idxd;
> +	bool ims_map[VIDXD_MAX_MSIX_VECS];
> +	int rc;
> +
> +	parent = mdev_parent_dev(mdev);
> +	idxd = dev_get_drvdata(parent);
> +	dev = &mdev->dev;
> +	mdev_set_iommu_device(mdev, parent);
> +	type = idxd_vdcm_get_type(mdev);

This makes my head hurt. There is a kref guarding
mdev_unregister_device() but probe reaches into the parent idxd
device's drvdata? I'm skeptical any of this is locked right

> +static void idxd_vdcm_remove(struct mdev_device *mdev)
> +{
> +	struct vdcm_idxd *vidxd = dev_get_drvdata(&mdev->dev);
> +	struct idxd_wq *wq = vidxd->wq;
> +
> +	vfio_unregister_group_dev(&vidxd->vdev);
> +	mdev_irqs_free(mdev);
> +	mutex_lock(&wq->wq_lock);
> +	idxd_wq_put(wq);
> +	mutex_unlock(&wq->wq_lock);

It is also really weird to see something called put that requires the
caller to hold a mutex... Don't use refcount language for something
tha tis not acting like any sort of refcount.

> +static int idxd_vdcm_open(struct vfio_device *vdev)
> +{
> +	return 0;
> +}
> +
> +static void idxd_vdcm_close(struct vfio_device *vdev)
> +{
> +	struct vdcm_idxd *vidxd = vdev_to_vidxd(vdev);
> +
> +	mutex_lock(&vidxd->dev_lock);
> +	idxd_vdcm_set_irqs(vidxd, VFIO_IRQ_SET_DATA_NONE | VFIO_IRQ_SET_ACTION_TRIGGER,
> +			   VFIO_PCI_MSIX_IRQ_INDEX, 0, 0, NULL);
> +
> +	/* Re-initialize the VIDXD to a pristine state for re-use */
> +	vidxd_init(vidxd);
> +	mutex_unlock(&vidxd->dev_lock);

This is split up weird. open should be doing basic init stuff and
close should just be doing the reset stuff..

Jason
