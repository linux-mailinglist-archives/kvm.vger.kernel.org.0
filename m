Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE3F751B122
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 23:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378632AbiEDVkC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 17:40:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378841AbiEDVjn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 17:39:43 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2084.outbound.protection.outlook.com [40.107.92.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B4821C910
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 14:36:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fHO3zeV8m6HSVOBs/0XSoyAQa/S9JAXxdbK5defbP8fnE+rGgakMZ1CjJQB+Ie5hyMu1lpn3r0Ir3D19QZoAVFgKZXBNCF0LUbZw3ncMjg06wPDcwgsW8obJZ/eBVN/YQvCeYuwO5fheNtWcRCAW4V+4sL7PkLeTONd0MgtwgmcgptqCk5bn0zyX99ig8ix78440Zi+p0Q+4SYYL+MT58FXZJASIrOUhqsANPcw+uB81v2zki6j+3qvg+tnIVZDVnvPB6JcBz/R7pFHMuJuL667yJ1mK5CVgjg2n/7fUB7LNg+yLjjFnA/AD4RBzfLeCY9SqpinVCYYTAO8FJqXviQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q8NnrLYXikngXbdW0/vIaYnqmYYwgzvB5oqao8tCihY=;
 b=SztXryiWN556Pje7UKQa/AwZpZIsLtc+cTgdUc97B5p7nj1vS2j5igeaVMjVeILmC5zgt1gC+MxBaByZZjlkfOOCGEX4cFE7R7f4gaHbttmYnAi+ivpTdTWkZxIH49bbBiXeFDCTVtP54W6fTABOEysZCgPfjAnndfHWDVGLibC+4Jy4FHGjViBHldmCi5+K278XppN8I6RhfY+DTJleXPqEIukxNLuk9Mi4aIxbumWealJyvNkf/cFhsixkev5UocF3lO0w/rnwfS9W24Al76vaDqb4D3/jofSJQokK9z4uzJUrB4auF/PAkmfD9DinQ1ik2bnLgAdEts/aZmgyyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q8NnrLYXikngXbdW0/vIaYnqmYYwgzvB5oqao8tCihY=;
 b=rdgj8qwZX8VS37mu9OwP78FM1urAHESN7wkU3eTWle9TIojK18up2O7ME4a+UOzEWC1OByDOFscJ3NoKlLYiA+8y4kVZ+zXihdEJQx4nBMFjrRkWaVO0jJNmHMVyp/wTtAp+2IlZkyO0JieHSEgfcY+Lly//7vCaswW6kQqRIzv+twChJBRKdD/CPgWaUaTccikp81y5VTUhZu7O/OrQYWKP6JW6D/tSfqxDqGZ7WFVdj5gvL7dUHvxBUCGx0OYKN9ikFdulVWZ1GPaaytwv1az7XKZvB0Xw5gOK9LvmDIQ/hqTF4nnmPm/UrM2GGukQHHuvUlAFseFo/XIlzG9ELg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by CH2PR12MB3720.namprd12.prod.outlook.com (2603:10b6:610:29::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Wed, 4 May
 2022 21:36:02 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 21:36:02 +0000
Date:   Wed, 4 May 2022 18:36:00 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Kirti Wankhede <kwankhede@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Longfang Liu <liulongfang@huawei.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Abhishek Sahu <abhsahu@nvidia.com>
Subject: Re: [PATCH v3 2/2] vfio/pci: Remove vfio_device_get_from_dev()
Message-ID: <20220504213600.GN49344@nvidia.com>
References: <2-v3-4adf6c1b8e7c+170-vfio_get_from_dev_jgg@nvidia.com>
 <ab4dcdd6-cc30-f9a9-5e6e-6f040b21e5b2@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab4dcdd6-cc30-f9a9-5e6e-6f040b21e5b2@nvidia.com>
X-ClientProxiedBy: MN2PR02CA0027.namprd02.prod.outlook.com
 (2603:10b6:208:fc::40) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c8b991d8-760a-4dda-4892-08da2e1615e9
X-MS-TrafficTypeDiagnostic: CH2PR12MB3720:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB3720C01B27066C19F4036E9EC2C39@CH2PR12MB3720.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Iqdp3rK8vDQd2xmiXbbIiQSlYUhfOGSXlwqSB0Snwhrfirts6uY0TFIvG1NwiUuV6f6x2vyUm5thjF6jwcEXCdmApOvYWnbXVwzOsmYjBFjuHPcr2MNXLerUnpKIdHF7pFbeMlVtkTHDNb+trBRyITlfalgOvVD3bMgtcCx/bOuQpN6jG8xO2PjXaGIQBvqHZNyvem4UVVcDMOcUWd7iUSSRx1sHA9xlp1+tnw1ojozpTv77pTSRyzWjTYFwRx7DQldElXty3jIoake1zE25p4WBwR/6MDVTbUZEbiGFJUD0xoEWfcMQXk+IwertZcKKYw+uYSTmY8tu5444IbToHSy8N8jg88POkZTTc1mpmnZ52vvMAoJuuIQ+mTb20fFhMwr7vZWPmqJWtfysWmOcG7rQ6fmGrryPHDj1hnA4ggsL5qytatBqbzKujq+tLji77odRvLajGx/Z54m9D9GggMnR1MIN3taSGsfuPIDRt0UX81im2CBTml0FEAF2OZjP5sXXcBwLMYIjdMEKnpseiTA4zpeUZVxF8uoSuxASwyHOnWwfBpUp7rD2kUVQu7wkAaEa+8IXw07hSydLqMqjdAPRZ9WbtKBtoSrUZumhoh2cBOPMyXvhsbPlvZxtJxCbQzulcjlLE7I3hd1b1f/ucw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6512007)(26005)(66556008)(66946007)(37006003)(54906003)(6486002)(66476007)(107886003)(2616005)(6506007)(316002)(86362001)(508600001)(6636002)(186003)(1076003)(38100700002)(4744005)(2906002)(4326008)(8936002)(33656002)(36756003)(6862004)(5660300002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Es7kcuLQPpwpsc8t5dmyMJkepOu1t/DkuV6ruy6jB/Lk9tDluoATTcZ9Z0Fy?=
 =?us-ascii?Q?j9SuO4422rDruFsTyM0EvjC3rHLqLiEZw2o6WRC0la0ElTL+/SFb7Ni4Gs+f?=
 =?us-ascii?Q?hIXIUOWHvF4waxq6frC+pO4x15Rbg+QYZdd5C/RR2tMflrBen9Q3vRyC7Cb9?=
 =?us-ascii?Q?6HI/rTIHYBS6Ylp3iXXhEIMTO9Vofn0IueCYtjs8V/un/Xgv45KkJkq0K+9n?=
 =?us-ascii?Q?qzuqbPD8uMUcd6mEU4eJwf8C63QgmZoto4wV4LBMk5TkbwoAvMCMBaYKFNP0?=
 =?us-ascii?Q?DyR/Ek3Twp4OXxI59iJJkDGTwUC/OqNeN2ra8aC28mJfGnE4ky4nCIwF+m2X?=
 =?us-ascii?Q?xhtRRqxSqSVRP74SktaSTPBB/YOGevxO69kX394L/kbQjGUiUqvpZN2YNbLy?=
 =?us-ascii?Q?m96S1qSueAPzDiS79YUBoPJh/S1pRpgLAbB/e0wPVgob4hOUimSbSKMwvULA?=
 =?us-ascii?Q?EpXfXkYpix/vGTsdgz+HAHvzglgfkvBWRXafLnOUvBUk851IXh4xsLk5dA1g?=
 =?us-ascii?Q?+FgM+3nzsZS/3/uvhd3TPjCmpQjHRpgr3wKid9juo/4jCz6rK9zJR6NFBYWu?=
 =?us-ascii?Q?YHKJHAA2rl+DN4l7QDd2bLV+5R5LgHSRESWANFNaZwwngiM2UlmSs+eQyc8r?=
 =?us-ascii?Q?fviZ0LdfqSOsQEiK0k07usKLmk/LaNGk2c1rv75030yXeJQ2ypCX96hpSgv1?=
 =?us-ascii?Q?WgHbnRPdGP+wokfdLlDqdDs7PFORkDekpHRfzcia15QC7z9joV0HMm69Q8yM?=
 =?us-ascii?Q?WMhMwmlXblo5695GrLMaG+5o+g5rO/xRTglQ5pOshH3l5QKqlesWkbUlKijr?=
 =?us-ascii?Q?U5RYR6VzMT98xCSD9SDpNkJ8gyn2XKtcpd2v5D296i8JAirIYK2tZS2bFR68?=
 =?us-ascii?Q?W313wG8rL6KQ3mIAso83DBBAfZ1iQHiGBQNd2MtbZhBP6lXlXQohLoh5anfE?=
 =?us-ascii?Q?OlaUrpT80Sbsc6SNJduAjxbRgANPjMtbv0pO5y3TCpIJ6OgHaD5UwF23VnY8?=
 =?us-ascii?Q?4WSGZFeYIxuBPsjN72EWqi2YsMlydPX6PaDq4ChNsj5jiUeu4ZRdHcFUFo+9?=
 =?us-ascii?Q?MjRLXiGdvRu9uShabZugbEYkoFrhGmf+ealzF04jPuhTjCpOeoo2cnRhkg9V?=
 =?us-ascii?Q?+ZCtH2V3nH5mX4OiC4lzBWxn0GbJDM9cwek0Bbsj9VesMS4Tlo715Bnr3J7C?=
 =?us-ascii?Q?+aZnIYVcv1i263eWHVU9o2tigE4wnSY0wmOoUcZ10r2wZ7ArqEG0EHJwi5RM?=
 =?us-ascii?Q?shdpuqxhRlQcKRz+EJtvQmU86zj8NLR3AH6l2c2YJiliJSAaYw/TGR8yawHz?=
 =?us-ascii?Q?7/Cab7ki882XpUgw3zna29Y8mbcOsSS7JUAbXeijcLRgQJ+HYGu7i26vdfx0?=
 =?us-ascii?Q?ZUwO2hOiV5N805dialpbHaVKZizDict9+RkBwKXKyTESDrck89asgILZoNfp?=
 =?us-ascii?Q?zwhRXc8BFxmnGv6Sh9IBJ6fcEnbBKIcZ0LY3LMhNAE5yQjFOytE9/PlSqFp/?=
 =?us-ascii?Q?CUzx1hi81sVU5aZIMqN0jP2OmzUzQ9XqrOulGnAEZ64aLrbDcNg77C7tDe0A?=
 =?us-ascii?Q?wN3ZzCzkhYG381gMLB5FcBLSktVMlouFFc1Q4na09EPqhtnN3epnHZD+I0U3?=
 =?us-ascii?Q?bLr7nQoiMZpsuDKgWo57I9m6loKgIBa97i50hD1iDcG1vrPbmV/YykOlOcqg?=
 =?us-ascii?Q?FtvPM8NoIxnlLIGETfJUbLD/r773nS49UFtERbKvtzcQh/eLzoI5zHNKeD7K?=
 =?us-ascii?Q?3+ccfrPkdA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8b991d8-760a-4dda-4892-08da2e1615e9
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 21:36:01.8895
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gjtMOQbDOT6T5K2FCFYuP4Om8emNAhwUyysKy5Ru4mQ3+mj3n9PysLM0ZMRxuXI+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3720
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 05, 2022 at 01:50:45AM +0530, Kirti Wankhede wrote:

> Its not a good practice to force vfio_pci_core vendor drivers to set a
> particular structure pointer in drvdata. drvdata set from a driver should be
> used by same driver and other driver should not assume/rely on it.

Abhishek's series is adding quite a few more callbacks to the
pci_driver that the sub drivers have no need to override. Wrappering
everything is much worse overall, especially as we add new drivers. It
was Ok in the v1 of this series because only 1 function needed
wrappering.

Jason
