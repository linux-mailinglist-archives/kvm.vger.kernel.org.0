Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDAB9531F39
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 01:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbiEWX20 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 May 2022 19:28:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbiEWX2Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 May 2022 19:28:25 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2054.outbound.protection.outlook.com [40.107.92.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F6796D181
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 16:28:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OX6bwpSco/YTVgL0TZlcGqN46t2gyT7rfPABDp78IgElwwi2bpT5vWHmzNhzKbwxsroecZlgMiGqTpM5OJQnXYndSBRGLAM9enUg/9l5Otwt7GyE/ULI5c0ds+Rj872SWyriRvwEYfs3uLf/8t0DXt7aCcjbiwIJm/56ubZc91Nj2NT+8rj9Xl3IEO3wNktpUd967zcuIJ/eviVsr8me+jzc0W3OmfFQ5D7sgEYbTtNtRF0wgcSNZwnyeNuidb5N96HWN/uXZEqA20C2U0zfP0z11g8h2DgJQE/B7ZeWjC3d+ikxHN9427k48toxI2cRNrBthHmPDuuHc94+qd84lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hOuge/i0TaEVDCbCzfBmXUzbTJmyalutKZaIPzhBK6A=;
 b=EonHxrJfeMKCnHrTB8jdN19NPH+BmyLrv9uZCCO/452YC7BbX9Wp3TUnjKO8UWC2ihubagNZtI7+j5L2SurxWq72jNBphGx5G7r5TJKUw6JP1k/AFNL6wo8VocMpvxZkAuPqhDKTciBQ/RVCNK+clJ8wCoSH5rb6griohMEt5iwJlNW54xRHqjXmjiY5jD93N2sHu2U2NqaEDJi6JujV5MgYcN4eaFTiNsNpMFA+82rlzEfxk9HUQ0m2+AQBZ2MmDS4VvLbyoc85wZCmmb1e7Lxr6Bvi/H1iW0PUAMhY2leHqYXesUGUar9OC9iNU4UABa+emvGzsobyXR0z1nt8Fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hOuge/i0TaEVDCbCzfBmXUzbTJmyalutKZaIPzhBK6A=;
 b=l2rZy5jvoKCTcglz+JV7/5R9LR8LA+53OKZHUQ4GV6zoT81OhCq0Xe2tRY4V7of0UZ6rSSiDyIZEkOULHqdO9TxXAtu52C+NLXJm16jCw9ot19uw2EraegxDDnP/16sUqsIN0qd1MYtlRpJPrYjcPexLFmKYr+s853hH4Ixpbp0/a93bQ7yT6h1fNjpKno2HTw637QsAZyHE6OmnbnvowMUhlFhfYSyg/5G7XOCT6W+ZwwIweDx87fencX7z0FBfXqLUhIHlhWxELXLk4Sa1aGjB+rLx7/+GNImMEwlVFUwMxFIPJbWaGV1t1u8O1tFYFmH/j3yq8SJG+ffXnK9r5A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BN7PR12MB2772.namprd12.prod.outlook.com (2603:10b6:408:26::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.16; Mon, 23 May
 2022 23:28:22 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%7]) with mapi id 15.20.5273.023; Mon, 23 May 2022
 23:28:22 +0000
Date:   Mon, 23 May 2022 20:28:20 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, kvm@vger.kernel.org,
        maorg@nvidia.com, cohuck@redhat.com, kevin.tian@intel.com,
        shameerali.kolothum.thodi@huawei.com, liulongfang@huawei.com
Subject: Re: [PATCH] vfio: Split migration ops from main device ops
Message-ID: <20220523232820.GM1343366@nvidia.com>
References: <20220522094756.219881-1-yishaih@nvidia.com>
 <20220523112500.3a227814.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220523112500.3a227814.alex.williamson@redhat.com>
X-ClientProxiedBy: BL0PR1501CA0030.namprd15.prod.outlook.com
 (2603:10b6:207:17::43) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fc1b6e8d-178f-4892-d9ba-08da3d13ed44
X-MS-TrafficTypeDiagnostic: BN7PR12MB2772:EE_
X-Microsoft-Antispam-PRVS: <BN7PR12MB277238341076D165FA7619BBC2D49@BN7PR12MB2772.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KZlCBIE7HqUFGmsrWvHhMkFX/7t0EvRQaeBujkqMWhRYOTxMKkW9ITHTK87ZkgEXXSmCup0bfGKN9ni+/uQmSqAxidwJ6T6E7mbfzPfd7rSf0US9cW8djMfHD0BBwqsbwlsklrU20xp4jgRYi66Rr9CVp6v4DmM8GTj9DlqpzPgz8xRkDSaVrmKl32t960p/bFgyjY7qWeLuZovmqjqEHU0oEeSN3ZYD4bhp2+XMZaks2DqD/mxK+KhMgKefbwsihMs00RpuH+iNUVXitmZwiMO/mOmdE5JA89QdexpBxBlAS0bDXDD1UyQSQs6csYtUMlI1d8L3EkZOh1+vSnqdBQfbvgawWoqiPq0MFJE7IvdJyL+TXM/7kdj40HCqyPZEqWWwFI0pbRaIA9C1Ot9LJpI0NShX3TldesPe8+c0ormo9Y+N4Q8C0XgJwuz/ytqq0rC5D82CofyNuJvUBHXFlkWzXXMoxfZtZgt8bujOVZKItRso2fFCmGn1cInLRZZqcLFF8i7HRMItF+1HYy3feNP31abJdN4nKXOM0yW8oSepayav3UzAuECttTEg0yFYqY/FIe1kP/jke/sv+7xeS+WdcukbNm74Id79kw4HzVP3UZLEvaZXZ4/XSU6gAw+BF14+jr1Gr5+nHj033sgrJA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(66556008)(66946007)(8676002)(2616005)(1076003)(66476007)(66574015)(186003)(4326008)(2906002)(8936002)(5660300002)(38100700002)(6486002)(6916009)(508600001)(316002)(33656002)(6512007)(6506007)(26005)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OsngNNHZxUCq29SdfQJhQpGLW70dsD/gfN0LZNs2j77N0b/2F/pm56GzucP2?=
 =?us-ascii?Q?HVncMrmgfjImTHD2LdFHgR5Tsmgu3XES8n+s/i9zEMGU9lQqiMq3348DyF21?=
 =?us-ascii?Q?JGgIbZVXSwOFgp3ouK/F5vuBmpEl0ALw2QyAzISOKXf1IAnLm553ePWzTdrb?=
 =?us-ascii?Q?cB2uHPThAXNTRF0aZt/2a1q/mDRnfUfAbQhzD9HtkC9VmEhnhxHquCQwDMO1?=
 =?us-ascii?Q?qAIgwxR031M7Xj1zEIPemxFMwdwY0/A7Ua4ovj1I7l1tDXpL6GummSzaW1lB?=
 =?us-ascii?Q?nfLfadwJJJ2qTvKap38O255xQJb+P/3wJc0Wqw0krNZJ5YSrYgeIQxzRINCY?=
 =?us-ascii?Q?Jm3/uZj3a4PSFRsLFoUx1JX2/heRknt0t/j+uQP84BfqTXuk+viBu1vSJD93?=
 =?us-ascii?Q?yfhGV9jHHMQSSkvbDgbgONpYmrjZQojszv6oGHtksp+NLqQ9d+dA3SRIpEgG?=
 =?us-ascii?Q?tLEER9AiY5em6XeUMlcP84r1ZMEPpdDMFuN2E+z22ULED7Dwretu+9bTvUzU?=
 =?us-ascii?Q?ry+Nk2RHFG1tcOdHU0LLfPDh3dtj423DCE2AtuKhSB12hcE0t8TQnrngT/iY?=
 =?us-ascii?Q?dtTffTZTNRw6yr2qoE7MBzvRd5iwlKxC7xQQyeAjlTK4Naoo4QZaJsejCImx?=
 =?us-ascii?Q?kpC6oiVs69FSjvHS0GnN2Qhdotv+6iZdzS+bRcv8aaZuNYp1BW3+a4I3HS9T?=
 =?us-ascii?Q?QtY/rbbsOfXdstcT3Tg4MzmShJTn8Qrx7b0VguOMsi0yNro15e5YaWaWOXIR?=
 =?us-ascii?Q?WHTu54XTI8Cj4sxWn5T2nzIE23nqlwUzYK8wwXJkiJiEOP7hsaAgeT4U1d/k?=
 =?us-ascii?Q?chkiD9N60rzqZ8Alv7D20PUk3pRqyZwCFqnifXQ/EsgbGu/tR5ys1gnjvZxJ?=
 =?us-ascii?Q?cAhFdJmeEGGTpK5gRezMOpB393ZQxe+5rZdFyBd+OgBGKeedUS/y092OBUKQ?=
 =?us-ascii?Q?cJl+Hj3qaVnah3PZf8/gQ1k2+YfaZa5QAojfTKQAxVA450p939AWD0W2RIdd?=
 =?us-ascii?Q?4y5tI1sRrbYfaA3C/6KE1Q0Rv0Akv3C5rXiSOaweHVx6x2j04SjgbmgMqzf3?=
 =?us-ascii?Q?CMTVwm7jfXwv+DSRVcv4OdOKsDYUReHzLCADdlBAqS4RVcjRGVe5i5kvaffF?=
 =?us-ascii?Q?3HU0nLz8bEpDuq4pe4PLQlyweswFSZbQ7He8FbuNylgq54xMpXiqMClDggug?=
 =?us-ascii?Q?9GZrcZUXYh2sCxEi97xEBX64dfNIAuL+FaGHtHvhYSE5DmuXIgCMlHMelMis?=
 =?us-ascii?Q?eeJP3tThOEEMbHDV6CLQ33evYDgyPGFGmmL8l9D1/4tziJWoPlT1W0G1ORdy?=
 =?us-ascii?Q?3qF4rXlfuLOKhVoLyBJuO13NhMY9psQGIWcsTI/9Vj5n3HH3KJ4GAELah2gn?=
 =?us-ascii?Q?er4RaGTEDMqpfOyBGsbS9Rsyvc4upu2xi2z/Wo3bxw+k0N2gBR2YVTHdspeb?=
 =?us-ascii?Q?U/zI7s3bLhG3e+ch2ILWwPcT/iD06Hk7XqJojWgTwCWOhSKEF2Ph4oinynEx?=
 =?us-ascii?Q?vxEWOzyBKkA/xHg6A4OvtabAt6D7HwWjynG/c6hTsrPdCurcb4cl2mf6jhSv?=
 =?us-ascii?Q?cmftc9LZyLBu+TZlq7guUSv4JZoFRnK640z7+r/6jKkA+HnrHxIL7LkQxkXl?=
 =?us-ascii?Q?8P85A4BzUKHVyWx9VcwI9qZr3mKltKafYPGNy1I0GCq/FqJrEuv2h8OoU548?=
 =?us-ascii?Q?POOaKXVb/kXf3VO/BgpZsafSSOR6kU9+IaFZu1GAtgI+QrwxcQ5mmHKitIzE?=
 =?us-ascii?Q?tj7Gr1PcpQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc1b6e8d-178f-4892-d9ba-08da3d13ed44
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2022 23:28:22.2137
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IGnEmcviCOIO2IJcHOtwqJUm2+bH2ZbxxwPuE/SaoFvhOb0NdeqhwN43Y7UITyeD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR12MB2772
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 23, 2022 at 11:25:00AM -0600, Alex Williamson wrote:
> On Sun, 22 May 2022 12:47:56 +0300
> Yishai Hadas <yishaih@nvidia.com> wrote:
> 
> > vfio core checks whether the driver sets some migration op (e.g.
> > set_state/get_state) and accordingly calls its op.
> > 
> > However, currently mlx5 driver sets the above ops without regards to its
> > migration caps.
> > 
> > This might lead to unexpected usage/Oops if user space may call to the
> > above ops even if the driver doesn't support migration. As for example,
> > the migration state_mutex is not initialized in that case.
> > 
> > The cleanest way to manage that seems to split the migration ops from
> > the main device ops, this will let the driver setting them separately
> > from the main ops when it's applicable.
> > 
> > As part of that, cleaned-up HISI driver to match this scheme.
> > 
> > This scheme may enable down the road to come with some extra group of
> > ops (e.g. DMA log) that can be set without regards to the other options
> > based on driver caps.
> 
> It seems like the hisi-acc driver already manages this by registering
> different structs based on the device migration capabilities, why is
> that not the default solution here?  Or of course the mlx5 driver could
> test the migration capabilities before running into the weeds.  We also
> have vfio_device.migration_flags which could factor in here as well.

It starts to hit combinatoral explosion when the next patches add ops
for dirty logging that may be optional too. This is simpler and
simpifies the hisi driver to remove the 2nd ops too.

Jason
