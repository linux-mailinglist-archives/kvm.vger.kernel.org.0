Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BEF4662996
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 16:14:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237154AbjAIPOc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 10:14:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237199AbjAIPNq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 10:13:46 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2083.outbound.protection.outlook.com [40.107.223.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 051FB1B1DE
        for <kvm@vger.kernel.org>; Mon,  9 Jan 2023 07:12:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gR5YutQ0jJrIqvI4yJL8sKq8mt7mLERrYJsFjGqXYNqwPhheRqe7e6v5rtnL3+1D9fw2nRAAT57RCvt1KFbYX8N8ZpZRWXVrP826vbCuh59hFEVc2VPu5DuNz9yOIF7Ki1IT3+CiIQs4sK+eK9D0NcA95ezfbuaPdZiGQwCrJeOBqqPZvv5A2wQX0G2uhk4j1fS6Jt8/xc9G84V8xtqb6MJeSX2LsSApslmRTDUB4OzCVWv31IAlj1zwKISu6DDzDZ96iEBe+1zsrdYSeO97Ky4c2HJcjZSkOKQIn1kPyOKiNL9dkPC8n08Dj+e4ZZUEbNu84MkPZXYTIYqKP91RyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=78/xa1LcM3zifGJyqQFhZV4IlFswXId98A2JVunn8uw=;
 b=gBYXfV9d2VYOzxxmrd8mlIUCSuHJjUmZ/xAnuC0MFovl3SeZ2tqaWfOydwGOz2VPXZu2naM+IcLu6bsiCnmShrm5Oo0tNWarxMugJd9BjFvBYCZHQ2Gd1ZWWvYmgiHQspYwTlsEV3FnhYYxJxsrfEqbytaoU8j8dMNBDtKhXYtrXHhgkk3pPV5+vFwU4Sn81mbs46VQ+YW4Wi+ZUP9LfLLztJXaIL6VAEFTvgjSiIEYKtnHH9KD1UQy1+VV89ryG8G9Kxhmdy5OGC95JI4HtlTpODaZ74JuxPrDn8aU3nxNN4I1xnKSwQWycr8oY9RMzFAPdZ7VlZzasjh13YhDuWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=78/xa1LcM3zifGJyqQFhZV4IlFswXId98A2JVunn8uw=;
 b=bL/TLE30bZVVTFxYgvj9CCmLySIEab1MfKhVVwYH4+9jACpMngcUaIiBvOKlTNxTbtNqTpYjWYDOwVQN4vu6ZTe1ZYCZ8CTa5x402GpCRemnjzKjdj7DxxCFgvUPmQyTYopRXNMJdfbsPrJg2tSHpsHrbv7IxdmQWXYLNPhHoIaQinLaS15ehAHRK3mgWaOAIZxy3BQ7DSueE4C3Yj8m+1XSBnoK3+K++SFVhvwgTYYxHTzozKe7D0q3luG1pHnj7B7el/7/JgvDmW3gzswGUVeOUTYaztvg+UgHuUeDHXXQHkjGkfiIOwY3MIgr2D2L6ZD9qxh8cOBSh22hdSBhZg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA0PR12MB7554.namprd12.prod.outlook.com (2603:10b6:208:43e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Mon, 9 Jan
 2023 15:12:38 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5986.018; Mon, 9 Jan 2023
 15:12:38 +0000
Date:   Mon, 9 Jan 2023 11:12:37 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: Re: [RFC 11/12] vfio: Add ioctls for device cdev iommufd
Message-ID: <Y7wu5UCHeZMZrzFQ@nvidia.com>
References: <20221219084718.9342-1-yi.l.liu@intel.com>
 <20221219084718.9342-12-yi.l.liu@intel.com>
 <BN9PR11MB5276E47BF63C4553DD4C0F4C8CFE9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Y7whYf5/f1ZRRwK1@nvidia.com>
 <f7ee1b8d-0aca-d211-b75f-04048bc367a2@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7ee1b8d-0aca-d211-b75f-04048bc367a2@intel.com>
X-ClientProxiedBy: MN2PR18CA0002.namprd18.prod.outlook.com
 (2603:10b6:208:23c::7) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA0PR12MB7554:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c25e733-204c-4768-5668-08daf253f203
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oziJGF17/vJe68Fy1uNwJ8f3AVsOkLC+PhjUo1RfaYX4F69qfFfkuvO80FdGe6G3/KXZjPi+8ClmVfrRDOW8P0x13/yTMoIidRfIdNaQ8X4uZ6r85DeB9DBn/7cEj+j8cc2JnGb76lG2uNwwktVpDmrXiqbLvPUTgw8fD+uHn1wC2obVxfxNxDsfIRIfCw1gTGyhmyKNTQR7lZOjOKN2sEqjdeQ+8NxMUF4tqiDEQ4X/MLfmIqWaWBOmvk3jM5/HQ20QeODjXBMicCOU6uIe6x7C5TFkW6Fdyjf+n/vznd0DcqZJOB1pdjQYGZA1Q8ARGnwQn6ZJyx+S4goBTEDNjsCws9iYxpr9x9LhVA0jiIB+Q4tWGSa04I7G9nsxeKdIl0twXOftENyvZYHSzsiw9uxYxJprVh4BpiBTeP78ei6mAZtmAYx35V50qdg+CaYhFabwGdr5m/YfCsjXa54JlptzjHFJYGGgbgGL5CEzq7w1cM5Nws4i9YNIuc1ViIO0Uf+b/rjKvuIrbh8W8/DVchWoGlrPrNDaRRznF1B76Cs1pO42QNKeA4RTB7nFBTwqpsFzxzukSqU+7tOIIpG5r5NG2JpEEIAaKA19yvmgfI8JaWN6VU83fS6BprbfnVD0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(376002)(39860400002)(366004)(396003)(451199015)(66946007)(54906003)(2616005)(316002)(6916009)(41300700001)(4326008)(8676002)(66556008)(36756003)(66476007)(86362001)(38100700002)(83380400001)(5660300002)(7416002)(8936002)(6486002)(2906002)(6506007)(53546011)(478600001)(6512007)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?nlZD9pHPZjsWlknWHm44txgi9yPvhVb/ZhFguXcQNz9KjXqOr/6WZWE7hkEE?=
 =?us-ascii?Q?8rHwaTV2xoaTxVJUQptTOJtkluL2SeF5SKva6SSq5SwzMA5QII0dAFecFpTN?=
 =?us-ascii?Q?G7zPccs/fJtzkUeAqmdqNNX+1z1ZX6omWCs6IAKSpqpv2XePlbaGkCwYPze/?=
 =?us-ascii?Q?Yoqbw0g5RN9bOhNdGMsLDHWCnyhFsAbqskKXQAJAsCf4PzN2mvk4/sMGULTh?=
 =?us-ascii?Q?nUyq842HvD6FuT0w+Vi/mJXLg0UbBux5DnVvsLopI3utAS+9EWgXxWxHxefB?=
 =?us-ascii?Q?dlE/mCYi0gK+FiMPek1EEXWUjYPgWJyu1IJanI8vZgq9On0413HpopA1gvbQ?=
 =?us-ascii?Q?n3eQvWp36vK08OJpR5Uuzjr7EFEVE0E3OsDRrrHwLHg5QYLZ54F3JcVAgkbi?=
 =?us-ascii?Q?nfq0Z6YoMe9KOlfppDu0gTQUdvxFsfSpE/eoW88Ozf8rbXG6Q+8pLnLdlreo?=
 =?us-ascii?Q?b4IGtoIlXZlZ0dYbXIxqDWki0g3sJNTTh3YemIcngfny9liZ00jMXzy5JIvt?=
 =?us-ascii?Q?lMrvv+Cicnc6mLOp0DALQF0ihjEogSzBy8fDqN7HWNf+tdccJaR4WSP+3Hly?=
 =?us-ascii?Q?MFELxiojW3/20xBUIGSorO/1LTnRTlnrraRKqFH4NW3U1/rcW1L+RZEatPEC?=
 =?us-ascii?Q?LxLqbJ1Bp1Tsyea8c+JiJUIPCRv+lSSHDF1fQF5boFXMM4He96qlMsPODuKu?=
 =?us-ascii?Q?mtqWQJkqCQ7Z/WeGhCgfyTzLfC7cXIfZQcU+LqnmvZ38SoP7BqUZl4FvB6xA?=
 =?us-ascii?Q?DaI1wJOHkzAXR6NJyiugVeV91sDO4YryU5okrnDu0FohzVsEF+cTrItWdYIQ?=
 =?us-ascii?Q?BCpdkB1QjnjKGvflL0mFGW6MEmeBO9JDVa/Rvi/l9nrX6z585S2h/ev8LX1R?=
 =?us-ascii?Q?xTO74lnXaQI8FM92ptwk161ryl+1XOjnfeiKp78Cob8DuQzYwzd4T4iJ3nOm?=
 =?us-ascii?Q?abrJu78iAwoczGtvUFjGw8mGXlE4tRQj6EZ80Olj56038P0ebTGI6LvYYsph?=
 =?us-ascii?Q?jycfsFVLNygL1lqd14bzCQczyM9qY+w9ja9q3oEm9/SUHecZ3jXGI2eQiwet?=
 =?us-ascii?Q?MhhXVQk3D1S4TLiZN8CHfPG52U3wZop1zSDiVPb9piK+aiojTXB0l8HSt3vN?=
 =?us-ascii?Q?nuRidSXX8Q/QgEY1Xrqo5QH+QYqn09EwfVj6CRCysprLcTWLigB9NRwxvtqb?=
 =?us-ascii?Q?qBbcvbJA7myM/ljK6EP4vB9zXx8HYz35dE+48j4s6H3ykIhYVc6P4HG/Pn45?=
 =?us-ascii?Q?lTKEOB7dY5KHZ2UBHDqGHzwZmW9hb/dNvH+l2vJGw3pozFH6Cagfhpu/U6hu?=
 =?us-ascii?Q?7MOGIZ6FrXFvAjNszeRt1z2bJGTkU/i1Jrf67hLhQeIJYSocaNHOKtLV6L+Y?=
 =?us-ascii?Q?wpcW79DBiD/TlMBuP/N9q3KOrKG+kyLQZCnQ6ZKXcI5IdmANtrnAUNtkN4+C?=
 =?us-ascii?Q?wBdv4x9D418XyqHrYlJomFiy4NnqAisDI/QPiAPxT2mGQD2O1fX8AedvY0Po?=
 =?us-ascii?Q?JPZ908rhkQmWXvmiPyTiINuaFwGNqgOsX47xEFehK0pV7OGQxgVSXp06UgkW?=
 =?us-ascii?Q?vxPEpT5IK5lDquWJUJ54rtZxjul+VMOavM5xuZAy?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c25e733-204c-4768-5668-08daf253f203
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2023 15:12:38.4889
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RgCL/qDlyIJUwSwHwKhRkxVE58q8YfWF3mVfp0ugAuYlK3OP3dukhn6x4zOs+epU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7554
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 09, 2023 at 11:07:06PM +0800, Yi Liu wrote:
> On 2023/1/9 22:14, Jason Gunthorpe wrote:
> > On Mon, Jan 09, 2023 at 07:47:03AM +0000, Tian, Kevin wrote:
> > > > From: Liu, Yi L <yi.l.liu@intel.com>
> > > > Sent: Monday, December 19, 2022 4:47 PM
> > > > 
> > > > @@ -415,7 +416,7 @@ static int vfio_device_first_open(struct
> > > > vfio_device_file *df,
> > > >   	if (!try_module_get(device->dev->driver->owner))
> > > >   		return -ENODEV;
> > > > 
> > > > -	if (iommufd)
> > > > +	if (iommufd && !IS_ERR(iommufd))
> > > >   		ret = vfio_iommufd_bind(device, iommufd, dev_id, pt_id);
> > > >   	else
> > > >   		ret = vfio_device_group_use_iommu(device);
> > > 
> > > can you elaborate how noiommu actually works in the cdev path?
> > 
> > I still need someone to test the noiommu iommufd patch with dpdk, I'll
> > post it in a minute
> 
> I remembered I had mentioned I found one guy to help. But he mentioned
> to me he has got some trouble. I think it may be due to environment. Let
> me check with him tomorrow about if any update.
> 
> > For cdev conversion no-iommu should be triggered by passing in -1 for
> > the iommufd file descriptor to indicate there is no translation. Then
> > the module parameter and security checks should be done before
> > allowing the open to succeed with an identity translation in place.
> > 
> > There should be a check that there is no iommu driver controlling the
> > device as well..
> 
> yes. I used ERR_PTR(-EINVAL) as an indicator of noiommu in this patch.
> I admit this logic is incorrect. Should be

Oh please don't store ERR_PTRs in a structs..

Jason
