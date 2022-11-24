Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D0C5637B86
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 15:36:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbiKXOgR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Nov 2022 09:36:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiKXOgQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Nov 2022 09:36:16 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2067.outbound.protection.outlook.com [40.107.94.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 778C685EF4
        for <kvm@vger.kernel.org>; Thu, 24 Nov 2022 06:36:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ipbxElrDLb08cocKVysNtZbU9WUIm3549I30rUOBsHDCwnVn58zUpJ7KwxqncSxZWZb9Vhmg0yo6yqUOB47NMBLdNlBIW9E6H37W6gi8zvRP+MDYQ4fSVDIuRvuGSlUg6+6Y6okRk0277xwSU/9j89q98yk5Jjh6mDoVM0EK35ZuSZ1xS2jijFYi7NzIBgXil69GmFp93Xn0KbfNPnwaD3yYl7RMAQSY2yUktFQrkHkRnCjcbM6GGtYYuQo/yoE9gVV+8Ccu2tgkR+YGm9gHpX0I5Talmhinbc2sYbDbg3eqqaTu4h7KeibyfgDJnR1jT7E3X09WukcVefhh5DyD7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3Ew6ZCFqNL4S1N8uVoWNPk12KYY/LR6apT8taxktmWQ=;
 b=EBOBwrKoIXkhcMO1RKEfGwFNN/8o7674H2dWC/DZouzE7GsVMn6u/e9/3EDTQyUs03Iz1qu32sX1C3shhb+4+MV0i4ax3Jyp5uwY72e6Q1l3IjxfCwjJ4rM6TocJBCjOwjojMtwYJSLA1HD9UwV0UgqcoScaIsVMxyRrWYmY+yTgMBTAdI2xT+P5u01S+iY8ERL3/PyFQ7jZR6w5vpGCXXBS6Z0TXl1/oL5Oj4cCgwk42Bh0ewxy6G/ZntUk/nHD1Ypkdxa8gxoWzwVPErLm74q89YcHUO7smEe4bMDwK2++rGFEnn/+WXGZI8olg2cjPHGTsPrflYRfTSJ3+4bRYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Ew6ZCFqNL4S1N8uVoWNPk12KYY/LR6apT8taxktmWQ=;
 b=R39oSxcVuP+ii+xIy0RWX9WlWr/UJ/BYG3vRCdJC1e7xdu5U5dd4DpL4bJZIidfXZuH9itxDqH5MTwlZ9jPXk37jCqO21z+ZAdAa8a8oPuT4M7j3K9dJqFmDu3XgUdwA7oCXxaE5wlgJUfAan53y34MHQpmbeijMZdfqSamu0/vL8857ZwwLqBK2pYEf3xk1VSYHSliFjiKnlH8Y7Ymh/53dMJ3ga31zjlzEPVYMfCsAocnEiSYGQroqM4ifAZSbXn43+mJ1ubNmE3NukfJqP01aK8PMs8zu9qUBmUuQHw5hIXYVSsHQCLrXbUtIEYMT+KX9+wlqvxxVuh+ca9C9yw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BL1PR12MB5078.namprd12.prod.outlook.com (2603:10b6:208:313::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Thu, 24 Nov
 2022 14:36:14 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.5834.015; Thu, 24 Nov 2022
 14:36:14 +0000
Date:   Thu, 24 Nov 2022 10:36:12 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, kevin.tian@intel.com,
        eric.auger@redhat.com, cohuck@redhat.com, nicolinc@nvidia.com,
        yi.y.sun@linux.intel.com, chao.p.peng@linux.intel.com,
        mjrosato@linux.ibm.com, kvm@vger.kernel.org
Subject: Re: [RFC v2 11/11] vfio: Move vfio group specific code into group.c
Message-ID: <Y3+BXHd7dEL7FYqz@nvidia.com>
References: <20221124122702.26507-1-yi.l.liu@intel.com>
 <20221124122702.26507-12-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221124122702.26507-12-yi.l.liu@intel.com>
X-ClientProxiedBy: BL1PR13CA0355.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::30) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BL1PR12MB5078:EE_
X-MS-Office365-Filtering-Correlation-Id: b9cfafb8-40d4-4fa3-7f5d-08dace293d13
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fl8cRv78++LL40KStZZo4U5Jr0T6RCXVuGy4n5GisNhxJxEZDFxn2fnI5jT8o53eSBhm5ZWMrCKEVO61ZiOMEHPuKXk2eydwSJ9H/rm1a5L6JZO61fGDybYNbFJX04JQmhqople+OiVSYRIdNrIbQlTgazafVcakyIrmSuSS0Qcaw2Mcj+IAij6P5imZvU8t+wsLIOlG4a9nWwDlRAI4It8ke45YScCoRNxY51HcD9Df0FKwfcNd7yxiGfb1tGRKs5xp6mdyQRUuv5hLoyd/pSe9pqdwDs/WUTBw87DwkkuHdA/xid9Por/q4rpCOcoNbM4qpRd/uc0KHNYc0A5fqSlSulOkBy2nIIgUpfz9Jpsa67bacCpl+4Z/MDVRYlJDdBT3WdIC69unBKF9plvJiz+OLca7F5gvNXX/pQ0H4mwOCAzYajqWsLiUN2eplNToteEv13G4cDRWSbnW32sTYH+AYJEnAqCJJYe2IEeuaZJrEFKj0F269INyKkPeYrNx7pZ7iizEDkKnTxP6ZyQJHunjqh7o4PFMdHiWy89mPIXpL78LXjQh/vZ7wgGAwD7Bm2KKtcKGYnfm2dt6XrwirUyJBzQvyngBQQZkMwSKaYO0KHvl4Fk704Lh3vnnxoFpkIBgn+WskCMxakMnTNprofd/W7JmmZ5iTgpxAS38M+8YMYc3Xfbtq0aJUDCo3rtQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(39860400002)(396003)(366004)(346002)(451199015)(36756003)(6916009)(5660300002)(86362001)(4744005)(8936002)(2616005)(186003)(83380400001)(6486002)(6506007)(478600001)(6512007)(26005)(66946007)(4326008)(8676002)(66556008)(38100700002)(66476007)(41300700001)(316002)(2906002)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cgstARXXAcCArTgdn1wxHkesLbigTgt5pY0LUYNnmBk4IfHb4rl20zWGUr7B?=
 =?us-ascii?Q?JIgZO6Wyrz9tZEr3gPn534opI6aL9ujYR2p4GoQ6EJTrat6bInQxQuZK7I1o?=
 =?us-ascii?Q?iy7fY+9Rhf6NtcqDV0DxczcT3TVZ6vmVcgqcxagrbqAJxNiUPeJi1Mbpm5NT?=
 =?us-ascii?Q?Wk1+WL8fND0GJKcD17kyA+beK/NtW5RZWNoAzDPN61UpuOTBZ2jOFW38xfHW?=
 =?us-ascii?Q?DAVzI8lX6fr8QhCdReyQMjU3pDsQI5vMp8lxtLztiIyEJU17tOtRnJVKiaea?=
 =?us-ascii?Q?NJ5ngU90xAERFPwWVWK+nMB/TGZLvTXcxfq9WBcuzjmvjGZJbXUGgJ2zqwiO?=
 =?us-ascii?Q?PTm82/R54rwEk38ylM6v0vg8laTzKa2rvogMHzA5DRmrQq8vhYj3Txa63HEz?=
 =?us-ascii?Q?A+qobeqGpeSDA8yYdZ1rcGpJszdwk/sCXARGqoT68u49ANFE4ocd9TB92l3Y?=
 =?us-ascii?Q?oI9KsmJZYQx2w4NADMtuQWKOaRd+plnuw60XVmXX7q3/sOc1bVBkSV+yfEmm?=
 =?us-ascii?Q?HGzT9fXt5PCiMNYPIOOmjGgZ2Vdp0eAE0gwdMC+AvqCLLW1ifiDtMQkSQJkD?=
 =?us-ascii?Q?AqLAOWzD+4Qjm2UBauMooGC7RB3mAlyMqPwkfD73jvL0TeeePk2PoeUq2ltn?=
 =?us-ascii?Q?0xC2q/v2nLnwKd9ZB+xM6iFJ48vyGTR3RXsd6lUlSaM0EjzIABpJ9y3SqOJl?=
 =?us-ascii?Q?bB70MxgwMuDn7vN1O0zhW0aAzZsIg1N28YVOYkuWAHl+JoXXB13TVAhGnmlU?=
 =?us-ascii?Q?ZQVUFgnOEQkivmEZuuCW9mH2La4thLhgHHYOHdf6cgkKOAycbOna0Whm2w8j?=
 =?us-ascii?Q?7PX2p0M64hM71oKyq5x4tYOxJdV6/OeYITH1pq4kVI81rxZiKXKCwS7S/LdT?=
 =?us-ascii?Q?zfgMIsrtWqeDs4W5L/4DbkGazyB/n8GXpDXKYVufeCy0n7CRGMiUTJqevHEa?=
 =?us-ascii?Q?KWQ6yhSq39ylMlNb7BTQgh/3SzzY/STegkgmJbEW8SiEOFqz9bjGT2hN35BU?=
 =?us-ascii?Q?cjqf1Ydxb69KRcHE4r3oUOJ8/GOfq0m3ZB+Afifx1KpfOWKLPs6G9LM8CTXQ?=
 =?us-ascii?Q?iJHshbUTOYWcmr8wsqUTtUSTIP94Y4BMklp/XM9ZJSCmsr3QYqHK373H65pf?=
 =?us-ascii?Q?0o/AcVr9rwzFjXPL730lvdjzoNH6ynxzjDtJyuWX3eIr5Go/Rgq5rSVxUzy0?=
 =?us-ascii?Q?qWPlMja0cAot0yxJlLsjo+D+TkrQcCqN7J8ysP+Z+E2vnV+Ljjab7zkRwlS2?=
 =?us-ascii?Q?KPj4rd1Tx435V5WHm+PAt+DS+F2Dd/zWraxlp9llwk5O0gUv8JlynE3Dlw3o?=
 =?us-ascii?Q?SnxMLO2Dk6iL27olxHxxZpkMQZwYTXxPMsSwWwTPAPCDvwHjUGtAsUDw4fFq?=
 =?us-ascii?Q?o9CJbSlJVSJc1JiIypW1TbNfpC/VcjnAyTGpggnWkNhGA7NGRn9XATwJXf5K?=
 =?us-ascii?Q?aR2+V7I1f8fOkWRhM+y+AsL1TlVhYaX6yr7TrQrZ4XSgeEbyWEu8IVC+oLH3?=
 =?us-ascii?Q?LaMM8tGepOCyJXVvzH5Tl3IfOUjJMRejpBuGLujLXzKEXsboFb94l7z54bdJ?=
 =?us-ascii?Q?Vpu82F9oEXtZtVry6j0=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9cfafb8-40d4-4fa3-7f5d-08dace293d13
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2022 14:36:14.0640
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B6oPprCqbmebPWo/LsEeFsdHXXLKtAYH7hqG+nCuw37/ws2aVqYerH7dh21tZ4no
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5078
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 24, 2022 at 04:27:02AM -0800, Yi Liu wrote:
> This prepares for compiling out vfio group after vfio device cdev is
> added. No vfio_group decode code should be in vfio_main.c.
> 
> No functional change is intended.
> 
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/Makefile    |   1 +
>  drivers/vfio/group.c     | 842 +++++++++++++++++++++++++++++++++++++++
>  drivers/vfio/vfio.h      |  17 +
>  drivers/vfio/vfio_main.c | 830 +-------------------------------------
>  4 files changed, 863 insertions(+), 827 deletions(-)
>  create mode 100644 drivers/vfio/group.c

vfio_device_open_file() should be moved into group.c as well and
export vfio_device_open/close() instead

Jason
