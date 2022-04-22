Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF8BB50BAEC
	for <lists+kvm@lfdr.de>; Fri, 22 Apr 2022 16:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449068AbiDVPBU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Apr 2022 11:01:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449070AbiDVPBR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Apr 2022 11:01:17 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2056.outbound.protection.outlook.com [40.107.220.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7C025C862
        for <kvm@vger.kernel.org>; Fri, 22 Apr 2022 07:58:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=adZ6PTeNTudB6MKaVL13RdO+AfpzaLe4oImv/rn/AX9abwP6EDSxjSM+4PDk8ZZ6p7f4syk50asHFXAWu+n4dvMCQYygaXshF9trtVfAxm3hqKdwyMGZd9F3Rqlb7IWfgmAZVsMhG/itT6iyH8GnGhrM8NVQfPwFjrGnFOq2zN3VXEPXl0Qq9J59vUU0GrK/KTVK7xUxCYPduxKA9yuJ53kOPfufdX2qBNF0EeNRzWy7pyuERQ9bUiLGhuYUFwPnpixNOdsO3zIqf3Aqrn1gm/2ZArdfUuGibRk0uwVc8yH2WEp8Ns/mWDE0SlWRbAyewEyqul6ghVXpS9gYWQgfqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=odCHW/QP+xcTSSUWx82WdK7nbkbWFKUDGy404sz3WV4=;
 b=nHvtENzuIbtd/kBTTdeCytEq3BW4FaV+6RpQkxMcP6XCmGnfXfENMOlz6bfNMH1Geu7ZahG5Jn3wsit1XjS56Bf0tTvXaZ46L7dI/UVgmV8UXvQJuy2pejDIuZ4DJ+T5n54/atVXylpruCDDa8lmhqry/P4+6yjdedbKssh+NObaxyUfidkApszrYyHxIhsvxsimFO+UW99X8ekb9d2kdFkt9IQCPIY3cZVj7ucNXfVbYuflRId6wf2JDOIv1RWpzi0E9+Xmgd+NYJ9V+RfZs1Du+FKTvuYC6PSkwbKcZJ1e2IGp9/G4QgfTlFmuJwmU0cJHm9OVJVSn7MniqkKBJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=odCHW/QP+xcTSSUWx82WdK7nbkbWFKUDGy404sz3WV4=;
 b=W5TmaBbzmZLRQYU2ZfTkI3udrY8ql0nAwAhwlSKyzzNaOZEwlBE682dE4OQRYMbZVIrUztsb4eeU7wmc1/aCT2T5zHCpcEITaaOsesHu02OrF/mO6GUdg0weRbC0WVkrlvhr3PR8/YrPP2+/f0bzEip7czu8B0I/eOovpIwSAN6NJ4h1Bx0T5Ch691kJFDa7z4YnC5FgH1VbMNkHKEzgvJe4okNTbVS7yCQTYqlQS8qIDudqjbbGvIcAcMDTV+VwIVtdupD1AWqmNhwrYIh3SHc4b6AWrD471VAiz5Q6GxxhNuqU4i1XF07UIllYKQBM/uRI8eguSfraGpYkwI/uLQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BY5PR12MB4919.namprd12.prod.outlook.com (2603:10b6:a03:1d6::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.13; Fri, 22 Apr
 2022 14:58:17 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5186.015; Fri, 22 Apr 2022
 14:58:17 +0000
Date:   Fri, 22 Apr 2022 11:58:15 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        qemu-devel@nongnu.org, david@gibson.dropbear.id.au,
        thuth@redhat.com, farman@linux.ibm.com, mjrosato@linux.ibm.com,
        akrowiak@linux.ibm.com, pasic@linux.ibm.com, jjherne@linux.ibm.com,
        jasowang@redhat.com, kvm@vger.kernel.org, nicolinc@nvidia.com,
        eric.auger@redhat.com, eric.auger.pro@gmail.com,
        kevin.tian@intel.com, chao.p.peng@intel.com, yi.y.sun@intel.com,
        peterx@redhat.com
Subject: Re: [RFC 15/18] vfio/iommufd: Implement iommufd backend
Message-ID: <20220422145815.GK2120790@nvidia.com>
References: <20220414104710.28534-1-yi.l.liu@intel.com>
 <20220414104710.28534-16-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220414104710.28534-16-yi.l.liu@intel.com>
X-ClientProxiedBy: BLAP220CA0024.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::29) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 40431e0f-1ee1-4aeb-ca2a-08da24708878
X-MS-TrafficTypeDiagnostic: BY5PR12MB4919:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB49191A0A9F9E51CEA06F4DA0C2F79@BY5PR12MB4919.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N0uM+/9+QUkKCCWbsZRu/HJ0YcBCdLeifVAeqlLJi2w73sknx4ARXGeq7YV7oq4WJsW1gIVbTjXIWdPjFkmkIfQd3CzBDMTKV2WtVJGhOv2yybdlVH7SmoYuWzDYv6UJpj1TMFU2Pm+h+7Xki6CixrnYwZtrh/A9YH4IT5EJHD8H5xGszDx6wgw4GkEP5q3I9ShqYe1mHH/NsMMprTIb94ujOeIO8FE5rdWsgwC5ymKav/aA5PXqj7EPk6pdx6Iy4DQPfCvlW+J7Hh/Dpy92T2gVPJ4lV7Bfy7fTJogp2B5RjQvHmI7fD9bNJPkPqdyimhzrI5bxwsPCNpqvaTox6GtAiiL4qqQemQiwVpVqY3UmsNuurEAubo2R5M0kJsF6XpoxNYUw3Lef1wI6ciQbnGW6ZsS3vOcWKd5O+QsLpD2Z02u+ssm+iXSTV5HPE+NTGT8uClR1z8toa4omcOq2d7zQ2WBdAhXmwHhyNxA6Z5AFItHzkzP+QHcBCxjJ7x8kOL7axvXTExZh6k0xx+TMbE+sCI4/QraqXW0OgB/5IGTvDaQv3EMXZnSZ4gyx/gsz6qkPICv+NZXJus2P/BHuinfuP2958wksITjFtd+BFz6F1aF0dU/XU1eub8hC7KGXuBG+Y6pwOu5SJfuIv57C4w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(8936002)(38100700002)(2906002)(7416002)(6512007)(26005)(1076003)(186003)(6506007)(6486002)(508600001)(66556008)(66476007)(6916009)(2616005)(4326008)(66946007)(8676002)(316002)(83380400001)(86362001)(33656002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6ZcdYb4C1fm+B3eeR31FQuYE9opfqi8QVz7eYcnJWjdszIlFGmBfM2EuHh/E?=
 =?us-ascii?Q?IabLcXVoFpODw25iOej6AFA03Z1pkFn0AF9/FzFtC1ls6fsmZMWwWaYaHAud?=
 =?us-ascii?Q?/OyB5VWb3v1qPD/gCFPAU2uoqgyxTUB5jiH2sRdKWwhdcz693AQweksrdSn4?=
 =?us-ascii?Q?E4P+mBwk13p6rt7eZBHHCFicRzuxBru98f1ao3Nf2vSEFdBCnaTc1zuZrOUg?=
 =?us-ascii?Q?Rz2HPKDEEmX/7SZfAVmNcEM7UlAv0cGllADf7U/2/fDCIu9wcRjbEbLSpvjg?=
 =?us-ascii?Q?E5WZi0TqqWs7/4urEWi3MHGryG2BgArqmfuedkjg9JY2ZejJUXXNuO0Vodd2?=
 =?us-ascii?Q?1AWj4wpDenAuoPW4JXbtrrABvjdV6XPHl7iItgBt4fzkqucCK2+NO79Yvy7j?=
 =?us-ascii?Q?19hE6ErbTNZyj3Djfs/L1ODgrmdRby8zngI+k5x+q89/byrOOP+Th4JJn47P?=
 =?us-ascii?Q?5GPPu2hTf43/200uc77fW1AUAeM6IEdHaeWBv+iXN0sYpjV1AtZpv6ZBFhye?=
 =?us-ascii?Q?kPc/0yS7hBNYKbtQVme/fLvIsKCAAh4xRFcNRIiIeapgtOC/12nOtQhubGnJ?=
 =?us-ascii?Q?5zwEpzhhqmLj4biUdKr6uF+3IDTwRH/iHfRjkFg8hylNisQ87B7VzXvNmP86?=
 =?us-ascii?Q?ViALe9KMytoqmfE5ogrHqmpH2UdVhS7ApUZ2dlS8TelWsagY9YxDSOe7hy61?=
 =?us-ascii?Q?5WYxggGhhfc/FohInR+WXR3czmcxXO65q01tugaMaI2ocSjLHEue/OtSIVca?=
 =?us-ascii?Q?Ndn8PDoP75UlXpHLRKjntXLd4nEqzoD7+czqk6rXed2ZSZvpVAPPZCKGDTPJ?=
 =?us-ascii?Q?g7fOIOaVbhH+MZeNqWz0mzB5kv2s043wEIrTq4og93Wvdp+BGhwC8++R3P+R?=
 =?us-ascii?Q?zgt7VT6ON2jeKup5ZWFv3ulKq13XMTh3smhJ22KlOOFKSUTWsJa1z6/aTkel?=
 =?us-ascii?Q?0siFpEgY7BKc8vBumsipiq7mGimkvG0ge+Zs3xk2Ugq3DX2gy0InQds5yr7H?=
 =?us-ascii?Q?KS6B1frwcoLSVUlVAw7DNJdrroddCAOAD/t1tx03TdovasjLl+vNxtvSJHCR?=
 =?us-ascii?Q?4egQFft6wTn/eE+/yj69Z1l+NtTSvbocw7w4D+W2xmWs29gEKYt5BvLnkxju?=
 =?us-ascii?Q?vEeXgEdg97f5i3t5QCQ0TCrDNuWQ+zwdTvCQ3xGjaebTeQOoVEAUh9DywnGu?=
 =?us-ascii?Q?cqG94gKxIrnA6lqgfPT+yRYzzhtcFX1RI1LLVrJuYxAIFJDWPEN/cUjtHitl?=
 =?us-ascii?Q?kP27NLZdKHEf+6TJYlCxFxKJ3DtP73KZAAbN1b360U6pQ4cdanr3wBQE2u2c?=
 =?us-ascii?Q?FNUU0Pky3TvbTcWI8lQMCSlPhha6HomkkhP7w6rlXZ1QQco0kkpTx/CAbTXD?=
 =?us-ascii?Q?g28nl2ojh6Kt/GGPDxVWvxuFP53zicg88ziVGJ68wznEr/+8X50pgozoOjPP?=
 =?us-ascii?Q?wi+eLx7andZ4+W4bkpeRXqDU/vVgjAD55Zl7eVN2A+B2LYNTGL+tDQBgRIBX?=
 =?us-ascii?Q?ejFJqi+/Kc/1FTd/oB3Ol2/8+p14Fd13ZVJ42zcjbo6GbABKlC7A4f9f1nnE?=
 =?us-ascii?Q?DwSBgsZdIfttDqLbuUGLZqcbHYFGJQroDjMo5desV9xW9NYW1+dRGdiKHLc5?=
 =?us-ascii?Q?I1423Gn7otIZYC5KSa1fnxLutYbMh/rtad2x3pb4Bv78qn96aE0w0NCIWuMS?=
 =?us-ascii?Q?xSXnPc+fwAC9t1tyTzCUThr8T5jBbBVWhdwuXsWoxqCX35m5ok8KtXOOLWe8?=
 =?us-ascii?Q?RxpL0A3HVg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40431e0f-1ee1-4aeb-ca2a-08da24708878
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2022 14:58:17.3244
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AYFkFZUIKqg1J4OY1HYedbTgivUnYBOMrKZPesoi7SwXYcW2hpjjWOR1VKEZ8gE9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4919
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 14, 2022 at 03:47:07AM -0700, Yi Liu wrote:

> +static int vfio_get_devicefd(const char *sysfs_path, Error **errp)
> +{
> +    long int vfio_id = -1, ret = -ENOTTY;
> +    char *path, *tmp = NULL;
> +    DIR *dir;
> +    struct dirent *dent;
> +    struct stat st;
> +    gchar *contents;
> +    gsize length;
> +    int major, minor;
> +    dev_t vfio_devt;
> +
> +    path = g_strdup_printf("%s/vfio-device", sysfs_path);
> +    if (stat(path, &st) < 0) {
> +        error_setg_errno(errp, errno, "no such host device");
> +        goto out;
> +    }
> +
> +    dir = opendir(path);
> +    if (!dir) {
> +        error_setg_errno(errp, errno, "couldn't open dirrectory %s", path);
> +        goto out;
> +    }
> +
> +    while ((dent = readdir(dir))) {
> +        const char *end_name;
> +
> +        if (!strncmp(dent->d_name, "vfio", 4)) {
> +            ret = qemu_strtol(dent->d_name + 4, &end_name, 10, &vfio_id);
> +            if (ret) {
> +                error_setg(errp, "suspicious vfio* file in %s", path);
> +                goto out;
> +            }

Userspace shouldn't explode if there are different files here down the
road. Just search for the first match of vfio\d+ and there is no need
to parse out the vfio_id from the string. Only fail if no match is
found.

> +    tmp = g_strdup_printf("/dev/vfio/devices/vfio%ld", vfio_id);
> +    if (stat(tmp, &st) < 0) {
> +        error_setg_errno(errp, errno, "no such vfio device");
> +        goto out;
> +    }

And simply pass the string directly here, no need to parse out
vfio_id.

I also suggest falling back to using "/dev/char/%u:%u" if the above
does not exist which prevents "vfio/devices/vfio" from turning into
ABI.

It would be a good idea to make a general open_cdev function that does
all this work once the sysfs is found and cdev read out of it, all the
other vfio places can use it too.

> +static int iommufd_attach_device(VFIODevice *vbasedev, AddressSpace *as,
> +                                 Error **errp)
> +{
> +    VFIOContainer *bcontainer;
> +    VFIOIOMMUFDContainer *container;
> +    VFIOAddressSpace *space;
> +    struct vfio_device_info dev_info = { .argsz = sizeof(dev_info) };
> +    int ret, devfd, iommufd;
> +    uint32_t ioas_id;
> +    Error *err = NULL;
> +
> +    devfd = vfio_get_devicefd(vbasedev->sysfsdev, errp);
> +    if (devfd < 0) {
> +        return devfd;
> +    }
> +    vbasedev->fd = devfd;
> +
> +    space = vfio_get_address_space(as);
> +
> +    /* try to attach to an existing container in this space */
> +    QLIST_FOREACH(bcontainer, &space->containers, next) {
> +        if (!object_dynamic_cast(OBJECT(bcontainer),
> +                                 TYPE_VFIO_IOMMUFD_CONTAINER)) {
> +            continue;
> +        }
> +        container = container_of(bcontainer, VFIOIOMMUFDContainer, obj);
> +        if (vfio_device_attach_container(vbasedev, container, &err)) {
> +            const char *msg = error_get_pretty(err);
> +
> +            trace_vfio_iommufd_fail_attach_existing_container(msg);
> +            error_free(err);
> +            err = NULL;
> +        } else {
> +            ret = vfio_ram_block_discard_disable(true);
> +            if (ret) {
> +                vfio_device_detach_container(vbasedev, container, &err);
> +                error_propagate(errp, err);
> +                vfio_put_address_space(space);
> +                close(vbasedev->fd);
> +                error_prepend(errp,
> +                              "Cannot set discarding of RAM broken (%d)", ret);
> +                return ret;
> +            }
> +            goto out;
> +        }
> +    }

?? this logic shouldn't be necessary, a single ioas always supports
all devices, userspace should never need to juggle multiple ioas's
unless it wants to have different address maps.

Something I would like to see confirmed here in qemu is that qemu can
track the hw pagetable id for each device it binds because we will
need that later to do dirty tracking and other things.

> +    /*
> +     * TODO: for now iommufd BE is on par with vfio iommu type1, so it's
> +     * fine to add the whole range as window. For SPAPR, below code
> +     * should be updated.
> +     */
> +    vfio_host_win_add(bcontainer, 0, (hwaddr)-1, 4096);

? Not sure what this is, but I don't expect any changes for SPAPR
someday IOMMU_IOAS_IOVA_RANGES should be able to accurately report its
configuration.

I don't see IOMMU_IOAS_IOVA_RANGES called at all, that seems like a
problem..

(and note that IOVA_RANGES changes with every device attached to the IOAS)

Jason
