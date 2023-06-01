Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 351C871F634
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 00:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231298AbjFAWph (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 18:45:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbjFAWpf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 18:45:35 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2071.outbound.protection.outlook.com [40.107.92.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B28F413D
        for <kvm@vger.kernel.org>; Thu,  1 Jun 2023 15:45:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eE7TIWxHI15724f1YO3EsnULeNA7cS5yjP8k5pUWMHM2GJ0EvTNCPtXG6LZd1gt2WP39IzvjHXdnykZ2K9DnGSKVUsTuaWTYNbVGBShas7s7bR62rizY/qXqVdy0Sue3i2IGYCE5rNkr4LtqN8GMsdwpoKnFfebDNz/MxF0lxXfX8lVFFSba7cKaM7b4MEi4eLQE2K0WhkNfqVvBK1qkO4iTn6WTFI0TJQKlYW7VrDPupQ6TlngqR2nfnM13mXARtlUQtsm0kcCDNWwjukYA1ompIKw+h9vKDeTbuKD1hmQjuY3UTad1ucCxcOR1P2HbxJ7ybJm9L5/V32qrE7SRsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z6NpYP3Z5DnhHm59aXl6iWQm6y+5/q9vB+CQgBORxLs=;
 b=NwuuPRGLCAoqyytJE0Jwr8fbgx5IVsptpVI8yIs5FXZDhgO/UZGFBnpRKtN8XlH5SS0x0mXt2d9DUUm1u2WFhsE1og3y/ZUQFjlQubwBJComyhE92fIvuMYLMzRMnnWDNc3ir8JDg+0Fi0WyspHpLPBlz+Ybuqf2QJN6zHR2fMT4vLkEMZyzozgWF+GAQWVF7LDi+Ks+alWZJn8LfWVU0oWi/zA+Bv4oNlqNGY/bU2Lzo9uvv6JVbuZ91P3XZiSC2yt/QzlRMX2XaCsEwAhZ5QbJv3/e4WV4x9J6bOWPxBaHDOu63ZkJgGrGzcuLJrNOzl+CeCe1gcudocY76r9iDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z6NpYP3Z5DnhHm59aXl6iWQm6y+5/q9vB+CQgBORxLs=;
 b=iguyPl13v+YRjmVrEL9Q6jKj5d/PXxHQLmP5lCQ3VLHFhed43JxkI4AZ6wVS5j7xkMoNzmCHpc4CBsDc/HUL/79chS7l/OczxwCbnqixUx3yeKzhGxxkzdbQv+FkXoGRG2GWkaxQyVES+5MMqa5D33+HrC7V+xHAPoUf9cWFhrB9sqWvaoWVi6qGbmZdT2ledfIiA1LIwcnX/sydo3dvxx+Qrf9Ql7WyUo32c3zD+Ma0qn8xFptOAoxSvhYcLIGUY8PXbqLPsRvhGG1SkU52IDnNxI1zkxi69VM2v16hMCsuMNyP+6gD1GxRdHhqVnN96hURNRRbMx4xtSlBXkoIAA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ0PR12MB6992.namprd12.prod.outlook.com (2603:10b6:a03:483::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.26; Thu, 1 Jun
 2023 22:45:31 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6433.024; Thu, 1 Jun 2023
 22:45:31 +0000
Date:   Thu, 1 Jun 2023 19:45:28 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Longfang Liu <liulongfang@huawei.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH] vfio: Fixup kconfig ordering for VFIO_PCI_CORE
Message-ID: <ZHkfiMSGuseMabEI@nvidia.com>
References: <0-v1-7eacf832787f+86-vfio_pci_kconfig_jgg@nvidia.com>
 <20230601144238.77c2ad29.alex.williamson@redhat.com>
 <ZHkEG28EFVDKVb/Z@nvidia.com>
 <20230601154857.62cbe199.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230601154857.62cbe199.alex.williamson@redhat.com>
X-ClientProxiedBy: SJ0PR03CA0232.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::27) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ0PR12MB6992:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f89bda3-4bfa-492d-7df5-08db62f1e76a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4pZcWXGFCkaMcgMeLcbQc1kYuELg1zKtZZd/1HKrrYv6td4ega/RtQnSNJvItJ0rR21tu5HdQgnMyUbSdKi+MMp+2c0rNn0QjyDFcp1aHlJrqDZ3/mtk2FH4fAuUsxHpG3xLMg0np/5PTolJuHD3W5ipDjokiynEJCUF/Kju8ecA+F5fjgxuIo06Y2ub3u9DXV/1S/BTkQ4YFL3MSxNoLonMQ/4a43/TY8WVp8AcKueK0iN3BZIJrBwzjWw7bEyVvhRj34EJGLrnKOtmyovcylmh9ynxrSX/FovLEzerd/RW72wtQiiOexxsj/dWz0WeSLHkRzchXcLGVM7qLFK0Kvn7uv77Id44THkRC5HYWzN0TqZlchhK6gol9qqcXMnj0nEaP4Zyd5bDTBQGsm0sT5hVidGkafYxFjmLz+EJY/jMbEiZp/ZaTfmT2qU7eF5TXszpZSD6mYrhv5pwdjeWW2ovux0Pd7h7IT2EWLi4Jnf+s4Yj1v7p1lS7utcA//GhykvzqXbxVWLDG8w0WYri8am4ldZ4wBjfEOl6k2RSVtC4jg0bjtxRT5uZh+RkT3HE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(346002)(366004)(39860400002)(396003)(451199021)(83380400001)(66556008)(6916009)(66476007)(26005)(6666004)(6506007)(6486002)(6512007)(107886003)(478600001)(2616005)(54906003)(186003)(86362001)(4744005)(66946007)(2906002)(5660300002)(8676002)(8936002)(36756003)(41300700001)(4326008)(38100700002)(316002)(66899021);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YLYMkCaPPhb85XutrKOs0lQynLUfGHWoHhWmHxlTaXkgD5O/FukWbbdFmeWi?=
 =?us-ascii?Q?sm36Huy2N7ZD1ntne2wqAkExMr4krAO0UJeizRFyZJP4LBH2NjyRZFP+teBu?=
 =?us-ascii?Q?SNsr4jxjNjNe/QOJ6HLQDEMBnAGYudtYOT/y4z39csBMHEWcV4EPfiHjgbuN?=
 =?us-ascii?Q?reXC+g0P4Cb9iep/fUfQQx2oug4X8Olua1oJSFvprFHrQb9EoqM0zN6hzvM2?=
 =?us-ascii?Q?0lVV4YMmxif3o2U35B9//XmLqfrZNz3tr0apVnFuK6RgRM/58q2fZ75zaQth?=
 =?us-ascii?Q?bXI0Hjr75urNI2rnaM7T1kH254/mTRK3b+CbEj7HcJTN8qIhvWPoIXCS0o4S?=
 =?us-ascii?Q?fAvC+uaZ1jKInJrfY0iuE3itUTS1hXC34cawk69jtT77brlQoqX8pGhpSbnd?=
 =?us-ascii?Q?o+gmO3zC+L+26s9jryZG+Ywl16KZEXDoFlzSpnIBtML7dKH074dLePNBKv/E?=
 =?us-ascii?Q?Y672iy2z6tseNpwIfKBFOJkrX/prAzCgFQ8b4c/GPBQeiRFUTbyQKKmQaW4I?=
 =?us-ascii?Q?Ne7D+FTr0Vxqs2mOE3HLObd9ecDdw+imBY1+M8Mg2K4T2YKHLpFMFpw16YzM?=
 =?us-ascii?Q?5+nLm46116hcytXxkMws67hv6hqDL7Y+vKQJcL0X9dg6SgQ0KZFcdXVA5lQ9?=
 =?us-ascii?Q?LF2wFx4W6aEBjP6qoLkfG/AgGGXe4XwZWlzmphaiUHjI5MZNKNoTWdvdHmt8?=
 =?us-ascii?Q?C2soGjO2ZLf/KjMLSUOlW0XSgsLgiUyqg6YXQ5gSrOvmQFp7KUk0o4gMNb1q?=
 =?us-ascii?Q?AYXHD099Ch0/2ZDyLk7XMNadd6tyLpVDUt6wB7lrqLQe9xzS/GU8GzwtgsVb?=
 =?us-ascii?Q?vE4632cE2SV/fdsIAS48X2uWoNUvaOdTk3MlqyvvSMwZjO002s7vwdwKQvB9?=
 =?us-ascii?Q?1oA+/q5YN3O3gs0WptB17K3gWG6jOwwRMX/qZfiy9V891YY40zvZOFlYReRL?=
 =?us-ascii?Q?OO32VoiHjRH8ijVjgNNghClScyozRfA5Hc/2PW0FPQxwtf9duCjnKGbvyaz1?=
 =?us-ascii?Q?u9uNI2Y+NDln+z4qFkYP5wTNEuVFEFE/Lx4w59q37IZOs60uNRRGC+uGRZZA?=
 =?us-ascii?Q?F73YvSmXYi74/k9qpo0u2ji8Iwv6aP1vxMdnbt8FJ0i65/zVpsT/BSfUhXKC?=
 =?us-ascii?Q?UN4+pq7NZZr9Dv7/+Tz5JmLJ0rbmEubVvOAjePBzDNzyaR2KpWtxQlfmrZmJ?=
 =?us-ascii?Q?dEohlrXDJE+j9lUuen6Lw+UnM8G+VIhj5HPdwwbyPmmf3fhB/DOIvYwL9jQb?=
 =?us-ascii?Q?TL8YtkN6isW0k/Nx5+m1BCGGy90fdEIJkWEi9cISIUszIoJmUnUrp4b9ytOH?=
 =?us-ascii?Q?KTuFrYwomsiZQdCclbwdscx8aQKeRTQ+swFVaBnrxs0RLQGIE4leZBo4Zj31?=
 =?us-ascii?Q?+2hCGA2d3Yvjf1MHKofsh1Sv239Eqjvgv88wuxCpaB+S1GBK9jFDCm4JayRy?=
 =?us-ascii?Q?I2UPng7lucgPvFChSBgelOE/EbmkxbRGff50Q73geZqpRLLrBbonDP+6N3jC?=
 =?us-ascii?Q?QbhLqnnLOxbvQT2l3p1iryfYcC4R1aEIfkHRpu1FDnHhkofGk/CjnKQS0NOC?=
 =?us-ascii?Q?TTolmyLI2yJ/ItixoGm8RSTSn6F89jbid05VEkMy?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f89bda3-4bfa-492d-7df5-08db62f1e76a
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2023 22:45:31.3965
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rg3KYTnAHKyTHsk58iCkZ5TFZ+WFnf9pqSPIkPG+tUn2XEqgaW/JiqN47oJORAl9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6992
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 01, 2023 at 03:48:57PM -0600, Alex Williamson wrote:
> Allowing VFIO_PCI_CORE without building an in-kernel module that
> depends on it seals the deal for me that this is the wrong approach
> though.

I don't think that is abnormal, we have constructs like this around,
kconfig has its limits.

> > > I don't see why we wouldn't just make each of the variant drivers
> > > select VFIO_PCI_CORE.  Thanks,  
> > 
> > It can be done, but it seems more fragile.
> 
> How so?

The if stanza in the core's kconfig does the right thing automatically
without any need to think about the driver kconfigs.

Jason
