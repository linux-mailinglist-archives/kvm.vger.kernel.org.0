Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB5226EA924
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 13:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231535AbjDULdc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 07:33:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231485AbjDULda (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 07:33:30 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2042.outbound.protection.outlook.com [40.107.223.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E26E0AD12
        for <kvm@vger.kernel.org>; Fri, 21 Apr 2023 04:33:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UUkvloud5Q99gWOIYzc76Z2WoNOK/X4nUbx+YXKbgGCPAf7tEen+hd394sqGH3+OR0tTKjPRFzqeMiGKZ+X+NeMn+ZwKDZtoupFzl6aE1UUIyqQ1fMWa+FZhnraBBUxqGej4wIa8wl+/pNH0pqi4AS9xkt7sNUKmxJZ0qMLCoXlT8LXsMXH9NjZjikvpNjA4B7RO2505rrjSYl8BxHr3HXzrdOrPnW5tWsbH+2sAxw8zks6zjuEhYMPzugAcJVzGgPXKw2jK/lnAySOlVAwJZVq4nbDg2lvpS/CgeIJUTuAxQgaKkaP1ZojtNEy0vIGDMdwsH8RziJWMAgFz/AV+YQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WVepqNO2nrTiZjsVgc7RA3nifmOUE9COVv6BkN3hxq8=;
 b=cmntQSckIO8EqcBs5b88zrw4YqFFDHpN6JEJoOGZkIm4mG8+Z7wNECj7MzD1NRoFEVaPfib4Ou54gYcYXmhJIGmtb6rDVljV4aScU+hr9IFIFTmuyBBFP8NFLVoqj8PkJgrOfVEQSZsddrl+tYSHr9RSCZHm9gL19G5mBYygGgug1eOiES35IRKArUB9ik2xALotEnnhmb8lIboJqZJd4hd1FEm9NB3iTfsjOScVXIwi83ow0gXfxo6kGqwu3xLd1kXD+67RPSLc+UIy7x84Caf4ziLBDY7MYNJXqQ5SVgSkRq4JfrEW1aR89h9Kzyca0TB5OXMSHBxtP2ow1A99gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WVepqNO2nrTiZjsVgc7RA3nifmOUE9COVv6BkN3hxq8=;
 b=YaxLNGH3B54Vz2JFTvYsy8OYxR7JCWKe0MqyeLAS3YqbQVcFkMyG0zuAOhIkIblB7CpO6lrN3PPF8n72nUG2aeeMnFZwrmzxhJZ6/hUX8/yvTpXkXvmG37DI7OC/RinEz/c8gQPLzw5g9a+2cH7+mxFP7WbcXlozPzW6PxDc8od2DuW+pzrKtDn8XVp7vgrgtbCyWEYH8Htb9f95j3LNz+IOhqEAiJSpO1aFdUa/Mjv9XNmSXUJ/4MQD6wzT3LnoHrsrmmcKX2/pn4v25FQ2KOQ8UDgBMmIxqjKmuVDBejqPWNpxmHgNtPrygcWq2ZL2WRIyl3SzLrqcoYfgQWLDpw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MW4PR12MB7014.namprd12.prod.outlook.com (2603:10b6:303:218::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.21; Fri, 21 Apr
 2023 11:33:26 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6319.020; Fri, 21 Apr 2023
 11:33:26 +0000
Date:   Fri, 21 Apr 2023 08:33:25 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux.dev" <iommu@lists.linux.dev>,
        "Lu, Baolu" <baolu.lu@intel.com>
Subject: Re: RMRR device on non-Intel platform
Message-ID: <ZEJ0hfzfsTcuVO6P@nvidia.com>
References: <BN9PR11MB5276E84229B5BD952D78E9598C639@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20230420081539.6bf301ad.alex.williamson@redhat.com>
 <6cce1c5d-ab50-41c4-6e62-661bc369d860@arm.com>
 <20230420084906.2e4cce42.alex.williamson@redhat.com>
 <fd324213-8d77-cb67-1c52-01cd0997a92c@arm.com>
 <20230420154933.1a79de4e.alex.williamson@redhat.com>
 <BN9PR11MB52760FCB2D35D08723BE3F2A8C609@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52760FCB2D35D08723BE3F2A8C609@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL0PR02CA0102.namprd02.prod.outlook.com
 (2603:10b6:208:51::43) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MW4PR12MB7014:EE_
X-MS-Office365-Filtering-Correlation-Id: 3bd8f931-1eeb-4eeb-de08-08db425c3901
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JIeUqN4/aQH4yLKMx4qUj7zySAl/y95PWqynMbLSDC9PmttxoXn/1q3Apcyli9I8MHNc6/0gBC0wDUMtxIfdMuDVFjvFro5tLepf0Fj4J+xUXATyHtQCBjDLgJgEbRCoktosAlOSZ4LvgCjDePytmXdJ38i9tTZ0tq1qgL2QmyqRBjqu0aD/EPKYEVfC/e5lgUg+A5wfgFyWGxjGHIC32RlNxKYh79xhzpoK8Vy8f0diocV2a3wg8+t934PxRConQwPVgfeHtwSBOjjCO8YE/4iftmxECYYY/W0SBKHmdPov98f/etDoLW7h4o5d8brvIRmOhbNPMWrywrvrA6WL0u/oe8kyF1C7qUg9AJ9ZZQfrtLcqpb966MSAGqIgWMr7R4gbUEw5IcsHT2w80YaQTb9cZAI9Q7IYjruXzumc/Tq46mXjJ0jIBALxgP6YRBEofSju9I8tjQaNxzdOjVjEr9wDQrbyEJgF3aQdwqzkjajPec7bQ8DtZAk/r4ZOyJaELp6oWAtIY3NA6zaG1h8y2t1p1waS6AqIztFulLak3TRwLMAmov/HyrTeIzlrHxck
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(376002)(39860400002)(366004)(136003)(451199021)(6916009)(316002)(66556008)(4326008)(41300700001)(2906002)(66946007)(8676002)(66476007)(5660300002)(8936002)(6506007)(6512007)(26005)(186003)(2616005)(54906003)(478600001)(6486002)(86362001)(38100700002)(558084003)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UphyVQECfD4kJDo4Oy0HI549VG7jTV39FakZgCnUVmGAPC1McdpnSbQOqS/I?=
 =?us-ascii?Q?V01YFE0kCFmEyW741D9UWDSlRhRxJ7nCQrHF/oN1qXhJRJV5EwQivwhOsFyV?=
 =?us-ascii?Q?biaYElAPNM8wVNEQLumTqMlNcViXegs7WZvJoCAV4IRniv6bCDwOgNqIlkuP?=
 =?us-ascii?Q?eA/fk+orljBBqsE95E1VK/uxbvlbefOV6U6rVbLsEx4Ru7NXItVQL7nRgkdO?=
 =?us-ascii?Q?QBcyik8kaenOBcDVZM7KPFHRC3N2GkyqYnlF75800xCQDoeyhE9Y56CnYfC4?=
 =?us-ascii?Q?m40ht36eHKOf1507BhAiU6aO6hDm5r5hA92zNZEh/8S7TJZXEQcSwMtCvavE?=
 =?us-ascii?Q?yJbiQqttdWThbcXM1BzTtJ5D29ey92T08iaoqO28YInDtT/arrKpriupq34h?=
 =?us-ascii?Q?6ceQaZceu3iu0OUH1/qs2aGzxb8C0tvlHdqed6eiYBAHA25pbctD46nCLDwQ?=
 =?us-ascii?Q?OJqSGF2PfxnJE0OqKRVKU1DdO+lhRXG7E4+JPuTN/jlBtee1T1eCtW86jedr?=
 =?us-ascii?Q?wjmRqA+HucaHHLN00qGA9aias5SSZ1TQ2tP3Q/3vSXUM0Q6Eu9+g4623MEKl?=
 =?us-ascii?Q?XjvyKfzGGuhG6d3I0Op3YxCTSEiZmXEvzzGp1WmSH/LmYJtAgFcaknu6unF9?=
 =?us-ascii?Q?Fg3F9EfiOtqi7sTwIiooFkjpaQDeE9t9QaqluUZ47fCiAVohjnUd9G6HPDTU?=
 =?us-ascii?Q?eFpSgxKJ0t+qfaS7w+k23Qs320litPyJjUjqKRGKGI1CTEVh3PKj3Q3TpuYZ?=
 =?us-ascii?Q?ZCY/zUYV3sJvp4wKUs8BlEvwocgm2fjexcrvpmLX6mpBpCz0ZgWY29KPTHwT?=
 =?us-ascii?Q?P96VQFAFuFdDF17aM5VK2zxZbOA3u4XfZunQKLEkGv+Pyh0t51qxTbZl6B0O?=
 =?us-ascii?Q?2jLlu8tGTvpkEqPkarl4j2s+ve30408UpB1N/fTT18wAd58QmYvbuAE/xBYG?=
 =?us-ascii?Q?qDhBxrgo4l/tOOGYLhvmbYC4QWxpW9k/d53kus/bWiRZBiqi3rK5Wpgaxpv4?=
 =?us-ascii?Q?0oR6quKkZGcdrgaxuNNCAQF9XSrUErhOFCZMGJyNx12d2DBQDtKIfV7E/moQ?=
 =?us-ascii?Q?isBP8wJpUt26e7K1DjoOKvk0ZR1zzDRP5AwWDztNKfDXZ79iClPt7mOaSHE4?=
 =?us-ascii?Q?rbEJm9DQRGJ2lPv44iBf4KmSjIbNVVuO8fLGw/X76J5XkMaXxLiinKESkGw0?=
 =?us-ascii?Q?Lgm6SsIWOUr8fjNdhhTfA87NUJWCOY2E+p+rXUgvQmbpjq2gkdw9rMlOGcZA?=
 =?us-ascii?Q?xBxloYe8XwzFwj0/ZgDdIzqYDpjTpr7JbsA1XVvkrePpmiR2QwzBWaZbprxv?=
 =?us-ascii?Q?k3+j7ggH5yhH0jlnTzt7B0ipHB4YPt7vrlV3mYTy4KtPiWzQgGchDdZu+RXV?=
 =?us-ascii?Q?xIJxxryapxaXbaLfIp8I8GZrVVdEhRcU846TdrzpvwqPjhPg1HZUqAsFGIkW?=
 =?us-ascii?Q?G9ukKnx6KLE4djB0pYkpYumwvLxq04Z/B5pw8LjsDXNraZVy+PNUBBzMX/Yp?=
 =?us-ascii?Q?aXvulX8cGm9trVfcSahS2E1VVZ51cXo6an7RLbebE1xfO0JrYDV4Zb1TbqGF?=
 =?us-ascii?Q?eyitPZ0gkA0nEa2mGJY=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bd8f931-1eeb-4eeb-de08-08db425c3901
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2023 11:33:26.5267
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jDo/l63OohnOf2vAm+l6KlDtKCgXQ7KOL6s8H31QAUktVt79xGWe/qsWVOl8YTiT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7014
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

On Fri, Apr 21, 2023 at 04:10:41AM +0000, Tian, Kevin wrote:

> What about device_rmrr_is_relaxable()? Leave it in specific driver or
> consolidate to be generic?

Why can't this convert to IOMMU_RESV_DIRECT_RELAXABLE and let the
core code handle it?

Jason
