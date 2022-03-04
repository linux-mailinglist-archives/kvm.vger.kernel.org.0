Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3EE4CDF39
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 22:01:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbiCDUzu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 15:55:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229654AbiCDUzt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 15:55:49 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2085.outbound.protection.outlook.com [40.107.94.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EF1C7805F;
        Fri,  4 Mar 2022 12:55:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YEtNig8XqyAzfIJKqOnTEpRCofINNJSVn91UKJdFJcZzjJ+hm6FaqPzTuevFq0Zygi8tK4hyfDXHZx6NbAILxqi1D+9ZBS3O9UnMlrlE2GdLd02RCPQgoYKuAa1gXoIDMefhgDH0YONs53OWBWYqEyS2feJAq/URUWvEqXYk8Jn7UMzyiDGnxvaaFerZ0kUmjVPUhgIcCgkPX5WQ7au3CpOFH05fe1hPAd/s4GtzGWAocZFBIWGUX7DuNmIBqppCaYm4SC6JVEIfSvILbfKdQgK7A+oPzgLEt8TRrFiWYCUHWxE8u5o+9M/YrZ6CO26oBuo29a89yxTOY3IFfXvrvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c35zJDMurFzq3t9diVpn0bXHJlisB7cYtnavY1kP+XU=;
 b=mv3U325MMM8DyAu993/rHmg5pV+9sdcPeRMA1gbssGjDbHRjWePdp7Pvl2Mpqi9/USHxtTsHY1yUJ9OUTDHo9MPwxx8Aju3JvLgsDgwAp8AwvlULCp3KIaVCxPtGihhHNENExvqSv+o3go/OHeZ7W2pPClsqBiJxJ2yn33EssAbtT71oEBs4X8tIJxXQtyNrwfXFxnd2GvBTb3IFSYK0tEivfti3DLPyfEheNXH39Ahq0IWjzlbKXXsxuoIsgvivYYvX6gWAx67mYdBV7MOdOV/ITrHtGzZiXXaaIK9Qgz2ildk5W0Z/4xUtwmPzzypEgzdcY9Jgbymrx9oUKi7TFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c35zJDMurFzq3t9diVpn0bXHJlisB7cYtnavY1kP+XU=;
 b=a93piIKq5N8U7o55yIQs8Bnscq37M//X0v0252M8YLNyiChWtc6mUhuDK5DvZVkXr/Cj75Tv8h9VM5rHJ75NjvIhtA2fKwemGEYC5HTf0p5KupGzBBIWgFDFFlT40r6L7z8RefnhkUEHgxC1We9MvKMSncZgrysxEGJcH8I6mwD7i6XB5vVAvkQF8GJGkfzSxNG+4qDdCvnTvOF3VGGrLAv7N3oZjt2UXhHqNWpdhkI5168ye3yXLsHqgmJbD2oyWDqZfbrOi7DgKad4VhUk/XAZJOCevW+DIyKthZTsx9zBPQhO538ulBrMG6ywHbqhYV9WGzJ/UyUGuHZBCluLzg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM6PR12MB2844.namprd12.prod.outlook.com (2603:10b6:5:45::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.26; Fri, 4 Mar
 2022 20:54:57 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::51a0:4aee:2b4c:ca28]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::51a0:4aee:2b4c:ca28%4]) with mapi id 15.20.5038.017; Fri, 4 Mar 2022
 20:54:57 +0000
Date:   Fri, 4 Mar 2022 16:54:56 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-pci@vger.kernel.org,
        alex.williamson@redhat.com, cohuck@redhat.com,
        mgurtovoy@nvidia.com, yishaih@nvidia.com, linuxarm@huawei.com,
        liulongfang@huawei.com, prime.zeng@hisilicon.com,
        jonathan.cameron@huawei.com, wangzhou1@hisilicon.com
Subject: Re: [PATCH v8 9/9] hisi_acc_vfio_pci: Use its own PCI reset_done
 error handler
Message-ID: <20220304205456.GD219866@nvidia.com>
References: <20220303230131.2103-1-shameerali.kolothum.thodi@huawei.com>
 <20220303230131.2103-10-shameerali.kolothum.thodi@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220303230131.2103-10-shameerali.kolothum.thodi@huawei.com>
X-ClientProxiedBy: MN2PR08CA0002.namprd08.prod.outlook.com
 (2603:10b6:208:239::7) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 675bea2e-d6eb-4722-58f4-08d9fe213dab
X-MS-TrafficTypeDiagnostic: DM6PR12MB2844:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB2844481FBABC853CF6BF44C3C2059@DM6PR12MB2844.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IWQ4J94BcXYYSwTg0gRVWR6tuBvXzAeZQDQVtQYTm2j3pNtMPRWqrCt0D4CIn0T9A+jR+NYIjajrynYunp6t8R01qyuf+YkZXUpFbubdqzdq+2rGGlWjihve9QXPPcamRiqmp2QwD4Ktk8CnLpUZOxmQebsIFyNnOiLpxH8IOscYSTU1ZIBLZwpLmcoBx11+/x9jbBA3DrVNVJLP2MNeNnn++BGuZKC1ZOnjbVpf9xUTJhVieVCqVH9MllxvZnTGypXqPpFLSijs7Yn4DiGQ6nLM39wICB4w8r3WviqcAMHG6PLZniIEzKhlgypEwRgXWXwlUrCxZNdfIrP7varvxP/iwRbVCwR1LRWxEhgRH6Yn3mdU8zKPpJ6os6Pkfhx+m9Kw8haGqlXf9J0o6wZBhzt0epIJR9mPNciGhhI43w+EzyNalfvhAMg2dodoJV9qQ5ccfquTN6hKepaYPA/XbJnev4RyELJnQtE3ECH0zEkf1gNMOqyZgNtofPiVkL985yTadvzdFCWVMJi7icDvyqbM/Rb/V5g06FJyLxngV+3c1Ksg7qeiP9sxURhySiKacy1D/eStsIn0cTfO4MZicGbJ5ax54Q3lv7hjr2tky+AYGgfg4rDZ1vTSRY0aIhNhaj3nl+vyIzbLpv7TPsBPhNSnWGfMW7eNAyblk7DcrSpb3PsCJEHK85qAOlMSYeAb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(36756003)(6486002)(6506007)(33656002)(1076003)(6916009)(316002)(66476007)(8676002)(4326008)(8936002)(83380400001)(4744005)(66946007)(66556008)(38100700002)(6512007)(186003)(7416002)(26005)(86362001)(2906002)(2616005)(5660300002)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YKKdAS7qBKBhxik8WlfE/sdB98rKiscG06s04XmBlWhRitAtWEHyuhBCzE6h?=
 =?us-ascii?Q?zmrZ6fCI3cB331VO1moASRsshIifW9GeMH0aps0qzZJ0WXdfP0r74FLjBHeC?=
 =?us-ascii?Q?iU04qGhElPTyTn2KQK26fmxEw//pot79mSkE14FF3qlFz2KdaaRN5YdB5xpv?=
 =?us-ascii?Q?8D6Fw5z/QcmOjvmRtVp8WquXME6YlVzREwLqBV3g3PNldRNoPCsEC+aJ9A/y?=
 =?us-ascii?Q?P30gdL8/ApiCBPJiq70M1L5gwxuLfRKN9TDNgfRyYw6ls/z+mXCbzQHtldU9?=
 =?us-ascii?Q?c/5mwU0+BeEyFNqtYNT9hAP6/88jNBuU9zADrtK/xaaOXD2i9BAILJtZtOiI?=
 =?us-ascii?Q?gyzLLif6tvOn+1tYHU50Rw6rN8GKRumoJBElOA/IjeTAtO9tfU2mQeCwrSgA?=
 =?us-ascii?Q?PreaXdi3Rv2SXCJB5j22furcJqQlimAe4Xge6wg5G0HLRPDWAhr2obmBqB2w?=
 =?us-ascii?Q?E3K8gAQ59PbXLs7JGG6SOm5sMgG+VgoWV5AWReanq7041Hpb0ejFK09NHd+O?=
 =?us-ascii?Q?T8hGK/KGBt+lYz66tLyQljM/meh6uDV/tkQl/Ij/+niNplIeQz5UekyEyzzI?=
 =?us-ascii?Q?/RXjitylrH5nxV0xZAV0ArvdUlBzTvTxUTdMBbsmxjlGinGA5GGWdixqHV/+?=
 =?us-ascii?Q?K5OsFukGsj58RX0W+jE9ZucnQEkaCEt/4EpDhz0fwpET5K2kLlMFCRBVSe3d?=
 =?us-ascii?Q?ZRMBAdcIJfM3El3KN8irJSJwtWzZczLrKsv6K3QaSUaX8uCZdSSMNRw+DUpc?=
 =?us-ascii?Q?TMAoOZqH1RII/Xu2UYK72aYU005y0gd5+Vgd/MefQvH5tJSSydzDlKf3qear?=
 =?us-ascii?Q?zoetQGTCylz49k003uKGmZ4qjEkRhicPxKaFfjzZWD7PRip36AwhB4K140it?=
 =?us-ascii?Q?ARxxgHRDiiL4zLCh5sJQ+za7B7V037c9hOIkAVbQsixFO5fMwRBW2P+6ax7h?=
 =?us-ascii?Q?JPh+2NOdHNkKPbLyGsrPqy/7bleb/D7xe8bir1FZPvKicj8yicibU4f/cDJn?=
 =?us-ascii?Q?eEGl525ZN+KJMDe6SYmAuS11MxLsksD+uD/VyjWW6KCFgUYrPhuulQiwKqYc?=
 =?us-ascii?Q?LynzEjOnFepgzifkeZbCQcc/EKEre3nMeyVJlSUyUYS5k2CNxtDYGXNvA2cg?=
 =?us-ascii?Q?wWiNlFC9ae3Qb0zNlasbKhODb7XGGNjhsBDHH5oljBUJJRNMdJjKl21h2kOd?=
 =?us-ascii?Q?vlsSqKjM7YhVY/8VUpt0Fma4fDoT2zbNYb1hHABSdPcFDCVqGd1GFvtrWP02?=
 =?us-ascii?Q?LlUZV74FNv1sKyIJgit/1rk8i7ZarRQdC7XFf/D4I34ffTbC83TKHY4brCfV?=
 =?us-ascii?Q?/J7t97sJUUqrNwikeog46WyGxd+F7Bm9aSzuXHYptA1aQ7WgOQxZxxDiBvA5?=
 =?us-ascii?Q?Jh9mlhJRTzXY0Xx6v8x1o/yLccKHiWpiiSUgxjC6azDHGDKGwJXoL3RdcZ6+?=
 =?us-ascii?Q?OvFyoqYvXnQvhY/sPFz2Fj677yhUIIzzZy9vhHIzK2zvPJJO1XPP+40dJOjS?=
 =?us-ascii?Q?96fXZgZsQWq4fRG+ne08GdRi3eRndLmgHSbJlCRsNfl2RsDCDun1HUgXNu3S?=
 =?us-ascii?Q?s/u9M5f0TvdFV4bemhs=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 675bea2e-d6eb-4722-58f4-08d9fe213dab
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2022 20:54:57.4641
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SYDse/mJuAh9XPTQBQ9OZXeqorD9/ouoeiKCSLQI2GdLiAlQb+GfQgWtkxMQ6oTY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2844
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 03, 2022 at 11:01:31PM +0000, Shameer Kolothum wrote:
> Register private handler for pci_error_handlers.reset_done and update
> state accordingly.
> 
> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> ---
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 57 ++++++++++++++++++-
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.h    |  4 +-
>  2 files changed, 57 insertions(+), 4 deletions(-)

It looks OK to me

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
