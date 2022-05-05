Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7084C51C903
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 21:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355244AbiEETcr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 15:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384353AbiEETcn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 15:32:43 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on2062.outbound.protection.outlook.com [40.107.95.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 379CE56209
        for <kvm@vger.kernel.org>; Thu,  5 May 2022 12:29:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FNzbwwV9TWQT6P0aTZVxZU+yqOj7pGkuwripLZPODPkgu4fYxLYL2GkzOGDk2GGLiFAJYJh5TuyfIHuwzT5d7WHuW8NxWFKJAYkqGGbA18aAneyCLBPyj+zjBhj7Qdgr7poXNFAvhFeFnknuWR90P8nZdAeR++l/BKBif7saTnTPKYc1bb8EptXKV+QHpc9Fwhxgcrgp50aLvoohaGDs8oHRx1rGHZHESqnQoj95n7wmUNpRRKvLTHKeIUL8v4cO8UDx3YX+kq/St/BTcVklelLQJFQLA1RhAJaTgOQuuh1qgEs2Tzzo/B5Nu/xwgnYnBP7lvIxOsC/6B5ij8kCbPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ApnH5XwZIBRm2jst7utcyqE5UihJWDYxUGfkzk3giww=;
 b=cwzG1yPw/eAb4NTz7+lkdHbIF5hGL6h4/HV9sbX0oJcrXw409C4umBjLoPJTU1BrH4v7KwJX+Gb34wk7k4cH2vlCHc3WbIMV8uk5bOu63nln3DJtqDhfqeXav9icy9F7iAngTiHYIxI9UUyKWquRhS+s9n6f9pxZBRrfMhQhyVxCbtl6PtlilcmCD74sNlMutXsKyVDJbWkc38DTG6ZvWYWnJdzCTT7FcISF9zbXQh1OhGoLYMbUVkflr1RTAzl+2H0yi/dXSxfuqp3dTXBZ3cdTj3Sr6Dw8QimMjECZrkWYbyRI0bBXdzv6Kyvx0Pf8qLHaWkPzJHHTuQpBwIlpJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ApnH5XwZIBRm2jst7utcyqE5UihJWDYxUGfkzk3giww=;
 b=ghj19jCX2yxr7x7m8F5oYkTIua39p9m5wu8Ur24ODTcfcz06zmzYBWKs13+mBmfXEX9lYAi2w/47CbDfleANO717wInBabRMIBQnpCCpJ2SzFfRPE1KHU93U0reevMBFJX5HoA8NWKXF7yGk07eney9sxYRFP5SDyOJCHAcFln5VAdjeh80C3W3EHPrJtuEfTTAAWJatvV5our9IQMwfAyYS6KGkmNydV5LdGYJRDHYQC7vrXf17/VXHDy8uOoKZDpOcBfbwqGeaAN94V4nJf+nA6HqepAsRWaPnqE8PmztyPPRkhsUNqOeuPOnf0fI0mQn6AN7kEU6DreOE4cclXA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BL0PR12MB5538.namprd12.prod.outlook.com (2603:10b6:208:1c9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Thu, 5 May
 2022 19:29:00 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5206.027; Thu, 5 May 2022
 19:29:00 +0000
Date:   Thu, 5 May 2022 16:28:59 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Longfang Liu <liulongfang@huawei.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Abhishek Sahu <abhsahu@nvidia.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
Subject: Re: [PATCH v3 1/2] vfio/pci: Have all VFIO PCI drivers store the
 vfio_pci_core_device in drvdata
Message-ID: <20220505192859.GX49344@nvidia.com>
References: <0-v3-4adf6c1b8e7c+170-vfio_get_from_dev_jgg@nvidia.com>
 <1-v3-4adf6c1b8e7c+170-vfio_get_from_dev_jgg@nvidia.com>
 <20220505121047.5b798dd6.alex.williamson@redhat.com>
 <20220505183421.GU49344@nvidia.com>
 <20220505125409.7388d369.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220505125409.7388d369.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR10CA0006.namprd10.prod.outlook.com
 (2603:10b6:208:120::19) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 22a323e2-d019-4edd-7628-08da2ecd818a
X-MS-TrafficTypeDiagnostic: BL0PR12MB5538:EE_
X-Microsoft-Antispam-PRVS: <BL0PR12MB5538D811D0BD0EBAA390CC16C2C29@BL0PR12MB5538.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: adBLysjliMAU/8lCY00i/RxBaFDJjylflcoMJ5ymiGUfwe5/PRZcdHakB5icG14DGGSaLnc3Hl9to1HUAWvNwW886F+98oRLrSCtW1wvGIwgYxzOwuANO1LaWUyOZBGm5j/VbLpfcI1ogJ2PGrrEzjJ4TCbBRTVNuOXl3zXbWLaVEzH2CdOqeNs/oSPv6RYP2EyLPcS27OYV5W1hJlPYrYcA6xLJVbOtZLnvYJ7hJiaTXtsW2miA13/30Qkm8YWwn+kcb2ObBEwA2LgdMgRyIfXIkSvkghU+aBc1DlZyCCaEzxLi0bXCY3U9tXqALv+D+R9L9MZJ6SjGKLVLhAIA4MFkApFfXP1HNrEPgUYDa09muEFdFNbt22cMYZgajKZOpz+VOWHTlhsTUozzrVy5rDzWqNQ86kVBgAFPSQFpY2N34P14ixnrXb7xy/sSIRNo2/1FRlFURFlYkBxUbShm3IDfAcbxGOJZIziGrPhnOGdM+rs3S7xhKgQ4ShoxQOd0/1rEQETnIU/LTPsP2WY59St9ZNhRpiSseKjLE890YYDpSpxDJzEBJqJLKDepMN214Y7WJ68GYrG4EjJgS4hinC3OSC5lwuLVPMuXWxOeZe3d6nyMe/zrxPZp7xfUgIQyR4OYoVvUvDDLwRu19NyTtA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(8676002)(6916009)(6506007)(107886003)(1076003)(26005)(2616005)(66946007)(66556008)(54906003)(6512007)(316002)(6486002)(86362001)(8936002)(508600001)(186003)(2906002)(36756003)(5660300002)(4326008)(33656002)(38100700002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fzAlyNn/DIV2eUhWHUj+tcC96Fnk8VplfKbdm4dB0s1v9e7UnXfVRpxGBi1p?=
 =?us-ascii?Q?xTybtlhRx5JdmmcPFY2jE1kYPddwAp5tQIgVfJvGGHGEkNPJXSKtTCt7PQ34?=
 =?us-ascii?Q?+lIXexmHLxjzZ1M9EVqpnYf5fVbn2eFIvr7SuauTvX2Od6FSwv4K5YZvjzmS?=
 =?us-ascii?Q?c7mkQ4xcrj9YIOBEdO0reJdsTY+dMm41YTA85bUd2SgTjhFdYWfTFNx1AIlr?=
 =?us-ascii?Q?tWh0uG2JPV9kz3/Q3u2MLuQ7/blxQ+zQzgnmN2qKliPvFgdNcRAHyjgRJikr?=
 =?us-ascii?Q?uichB8zxHfbniD87osdzZAMbt7r1ZewdwjrHciVFQA9uaTWFb6q3eZUyY7mL?=
 =?us-ascii?Q?7tYlD69s2oui+DYFbBexabwcc5w56Y9+umbMgX3ShMj8lT0u48qnmakzdTMn?=
 =?us-ascii?Q?gC42T/BV7MD1vBeti0PdBFpyiwhhV6vAonqpFNeJSv/rIBlSUr/XSS3OxXL9?=
 =?us-ascii?Q?7Gt+5EcUsztwTyXG5dWW36RfEjKE08vsUYKYNJFe5oZeqNNm+4Wykj+nmzPp?=
 =?us-ascii?Q?sm/qGavwK8TFZCGUjCmhRQn0YFKdK0QdroscuoEncu/jv2JHNHVhNHhfVdR9?=
 =?us-ascii?Q?jknkouXEWvWfqT9t0jbZIFq1yh5Gv0YSxRwl2M0Dmwocmaq4i0c7Fu8XRqi7?=
 =?us-ascii?Q?Fl9/gKVBAZUIj+Dky8nODiD/43qJdqYBbXpW7zPRUocCcjeGNZvf2nnWufs6?=
 =?us-ascii?Q?tfTe7pcL3o55fIBm/AN8KmfWSyzicdWqOcrCSp2Xqt4m14xfajeAvf8ZDzPe?=
 =?us-ascii?Q?5LYbRVeyb1FZx56Jrsi+QDBRZXhu2fRrdFQ0gAkJgOcBtCZpqzhZSzSkywtg?=
 =?us-ascii?Q?IBhd0STI0Rttfw7myTNu3y3GsJYF+tW6/gOoJ2xVf29qh68/d5HvWWctU4oI?=
 =?us-ascii?Q?R93h0dFA2xVyF/3S8RB2MDXpqMpSPXAx7MBVOXNqEE8iDuqRMU6xV6s0i60i?=
 =?us-ascii?Q?eQrB4/lZ4krcVEuvaqVew+CwWQAQGjsowZmGXSa/aIqWIvxstGs0jMskwZmQ?=
 =?us-ascii?Q?/LUXCnu2g3uMgxLOgPUrubOR0V3WddAEUUeQ8VSqh5w5pmQspTzfQpDhrDYk?=
 =?us-ascii?Q?FQ0m/xZJDfRnCEh0AGwQirKgRA/KGyz/2s4ThEJ4JmPshhGd7dhpJ640qf4Z?=
 =?us-ascii?Q?r71Tn+LVu37BEa1to7hCor7XwZ6pH5/+0cIF1PeeO/Jh//ZqTS28plEIPDNv?=
 =?us-ascii?Q?JgFVxh3KF3SMYthCVScJcxbZWmJeruQTIu8Yti2IJCEEksU/LmUn6u6VQfNB?=
 =?us-ascii?Q?pvnD/acNfFRPDtM/95MbZXvC66j/YfZrB5ujZ+m5RRvzBMD1rE8A+cL2noG3?=
 =?us-ascii?Q?LPqT2UeHCzAEj6rRCkondgkFmoOqU9xxJYlGJMLP5q4/0mvHlO2U6vqBYLfI?=
 =?us-ascii?Q?YP0WPAhcbEfs0YY4meWGwwuFeuusx3OM0BBI3037dXbOyQ38GxaTPxdSaT1L?=
 =?us-ascii?Q?1hmSLSJypo4mgSmNk00qufTke2WFhPjtww672+1qc54ClK1TFWoIDlcGaBLJ?=
 =?us-ascii?Q?C1IDnO4dUFHeAAOZns1kTigRa6OTaW5BIqN7SLi1bp1MSofwRQJ3Yc8lXJJh?=
 =?us-ascii?Q?9vqKKleOWDemGWMp06cJKwWV3A3WlaPTh72P7HyULBaE11eWdlOl4r0F8oSS?=
 =?us-ascii?Q?imIBIa0Gpm52uokEuYjIWyIE6vvOn/E+hjrLDEGB+v5uYMGkzcFOehTqc1hW?=
 =?us-ascii?Q?Z3YUlM9gW8EbfAZWn57MEY6cHjGR5XyxkEgx3VCdQ2Im2ULmDaDgIgtxMv8O?=
 =?us-ascii?Q?20hlGV2szQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22a323e2-d019-4edd-7628-08da2ecd818a
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2022 19:29:00.6291
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4iF1vq9rf6lIwpu/AtUgZSY4Q3ofgiwY6bSNUcwJ47wC4re22MlKmbp+ydQzk0Xq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5538
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 05, 2022 at 12:54:09PM -0600, Alex Williamson wrote:
> > > I'd also rather see the variant driver fail to register with the core
> > > than to see a failure opening the device an arbitrary time later.  
> > 
> > It still permits a driver to be wrong, eg all the drivers are like
> > this today:
> > 
> > 	ret = vfio_pci_core_register_device(&hisi_acc_vdev->core_device);
> > 	if (ret)
> > 		goto out_free;
> > 	dev_set_drvdata(&pdev->dev, &hisi_acc_vdev->core_device);
> > 
> > So a WARN_ON inside register_device will not catch the mistake, as
> > this is the common pattern it isn't as helpful.
> 
> In the above case the WARN_ON would trigger because drvdata isn't set
> to the core device for the registration call.  Yes, a driver could
> still set drvdata after the registration call, but then they get to
> explain why they set drvdata twice and thought they could get away with
> changing it after the core made pretty clear that it wants a specific
> thing there.  Thanks,

I'm OK with this idea, it is not quite a nice to set the drvdata in
the middle of the probe function, but it does work here.

I'll fix it

Jason
