Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC3252EBD2
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 14:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349082AbiETMSt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 08:18:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345906AbiETMSs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 08:18:48 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2060.outbound.protection.outlook.com [40.107.220.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51CEA15F6E5
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 05:18:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LMrY3IbP4xJLhPL0/ghauyHeGoR1MdX9wikCV+Gp6Hf4zn8/HtVBRqp0SBJSXw3ilotKvXqbzpt4LwmhlsGXl8Hm6aC5V0ylhOOx3j7T65b8SlN+25clUZ3veEIdWES9W3GUQqGqSw2paPZHmcaxCCDIEjqbPUBXpaf49dsaRcK61HFR4aa/qeDb2FJpP9mGDAy1tAL2A2q0xhDEhKHvVZK/SOscy2sjz6aGVmr/PxUL2TBhi/XYIRUHms+vSenzKjk1iITEtXzEECIvkFdl5WDZQai/JH3CdNAr7dZ/wNBNxabjdin76sDKayIIQqeaf5dmyTEkXyBnZjG42CQg7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2G9veW2n501+NZPZVnyx5YsCTI0qDtZFOuVyJJShb4c=;
 b=J2jd98kt0OC/ZpUkW+x/K4RWSaqh6r1x1wHsg6uCimxZeTfzaZhjbH+tULn8WYHagVFaOVzqcWokP0Y1nOMjBZD04SquVkXpHWnFpAwNIBosd0f1rl/gx+hCcji+8k3BAQ3U9b0wM1KBR56Oh6cLngBWr2gUu6YH46Fk6yjo6sFpnFSeRLlGSEyDZ9LPDJpYpHEGB7yoWscQcSK2KoFhAg5QI0qxNeyrs2tOTiiXPWGptPw0hGQ5PBDpDozvNpq7c0y5ayV/WdjYPzJIIG90D3h+8EsUkGt8H6XEvpeyrXqpVl5H57ejEjkkdokBPRrjn7moUhrqX/XnZcpOoPyHIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2G9veW2n501+NZPZVnyx5YsCTI0qDtZFOuVyJJShb4c=;
 b=QE/5CO5vNdKf+uGT1qdwlTC63RJbqRDsE6udCUCnBW6aYkx0jlYOsNw8XR6AiejBxcASsV2qByYoz6BPAx0g2c5vHcLdKkwizcANqOqUuQF5iEr7u0KxKnN3w/qn9Dyzmi07CaQhkJF9qz6JU0jcqipx3lLxEpUwOkuu0LgTckeGWcWlPmi9rNW5jMUe5a9F+Ky3XRTA4VMw6eOU11uYxThwkdl7bJ0bNkTTiWWxZUWiPMA2CyYpt3QIkPJDDUUtK6oNB8V7Fe6Z13+0isxP7bShwWS4AZNa65EV0JaiX0Kfp+yYeSSFQxShQPVpf3HL3c5LzaCgXNFuGs/JmsllAA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BY5PR12MB4933.namprd12.prod.outlook.com (2603:10b6:a03:1d5::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.13; Fri, 20 May
 2022 12:18:45 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%7]) with mapi id 15.20.5273.017; Fri, 20 May 2022
 12:18:45 +0000
Date:   Fri, 20 May 2022 09:18:43 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Will Deacon <will@kernel.org>
Subject: Re: [PATCH] vfio: Remove VFIO_TYPE1_NESTING_IOMMU
Message-ID: <20220520121843.GE1343366@nvidia.com>
References: <0-v1-0093c9b0e345+19-vfio_no_nesting_jgg@nvidia.com>
 <3521de8b-3163-7ff0-a823-5d4ec96a2ae5@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3521de8b-3163-7ff0-a823-5d4ec96a2ae5@arm.com>
X-ClientProxiedBy: MN2PR16CA0034.namprd16.prod.outlook.com
 (2603:10b6:208:134::47) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2de1b1f3-0d99-447d-29d0-08da3a5ae2b7
X-MS-TrafficTypeDiagnostic: BY5PR12MB4933:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB4933B2A88D63DAD1EB753C29C2D39@BY5PR12MB4933.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 07LIHjk0inAuVuqpdlJ3XedI4IpRYksOpWFq8eK0/8dkj1Dj/N4YYbe1ZtOFWGePuXLNz84Qz+3plpN47qRSq4+B0q3FBZWU1hfWmklSQz9nI7F+uJbvT/W7/XG+Bzdx8KJh8LiBfysDYrEdW9IL2p3VSIyg37aMWmJRLH9dKVSOGK3ESsDZVsH7DEPJcvzg7dymNTkhvjXZ9WRH2rLXkYzZZtCJW8lxaQiH0wblEyy1IBKRt0uYSdh4qUNL4DvsTJtcugi7+gWDOBN2OrSHCdrMp9c+TyOmh/OUZ/tFTU/AmFMYTFuRoSEY+B37S67OAHvDxMhzZNwTW0wvJy93Mx++Hm/DVewFwH3BiyAgIfzW+kdW/IHHMDgkDjK3YkBLFeIA6xL77HhXkKHjbcv/7peBfeOrNRpjLQDxjtuA6AMiFDyfqSOsOw5CL3qimh/veD2yVupTCpXnc6kxv5VqQN3LenBHQaYi9IohszrxQuGyWk8E0Iq5fNFipgVb4zbPqHQhvshPewWb72SdzZylcoECv2Ywq6CGn9m/uR3FgTgEKC2x+8QMt4bEEnxEdnwVbhfmWuRJnHLvVeD2wL4fy8JDopYyANp9zJSnlw8dUWTCMZKxnGlVG/mfQ/Nfe/lQO6zFw7VbCq/3sNg9sdqKEw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(6916009)(54906003)(186003)(5660300002)(83380400001)(33656002)(2616005)(4326008)(66556008)(66946007)(66476007)(86362001)(1076003)(8676002)(8936002)(2906002)(508600001)(6486002)(36756003)(26005)(6506007)(6512007)(38100700002)(53546011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?l1MyJ2oyIbgLckm/cKYEkfc0RP/GtTgqwRuODmdrfBrbEHDPkAv47TGCsp+N?=
 =?us-ascii?Q?Y2d454EAJLmkz/L/8d+TD+QhZI6coq0+9w89GfNUGgJa1Y8D6xXAxFuo2FcW?=
 =?us-ascii?Q?N2cToo437KvoMd1jFQMa7CAfSn5SgzMaQk39OfL+AlrDCQzYb+3Yj69b7b6p?=
 =?us-ascii?Q?tNUFYeANKJsGfhHWfsuFVH4mElV72nxQW+b3RSmMm5p6uIvSD/yoGzyI0IlB?=
 =?us-ascii?Q?Ctadj8nMzdRbIu35XRNySzOacMi2MEfmkuMGWK4Gq3hvC0nkqE7q5waEi348?=
 =?us-ascii?Q?YfJ4hvewxTZOiZu8bPEIKslzaG/6ZJlK5kA3EwR1/m8EQ35qDEB5n3S6KKUu?=
 =?us-ascii?Q?CvVbHn6hyxttFUqsPKSHtwLVk/vLABhZQrJTwEeQ4p/aySseyVveXBn8Bys0?=
 =?us-ascii?Q?2WpxY1ZCEnHfGPAa4jPfss3EjCiTiKoDXK0zgg6E6B3GevpB6tDXJTnd1tB3?=
 =?us-ascii?Q?YOQzbEov3L/ODV9VAR+DTBt1Lyil5LqFWJ45wnSDMeFGsrPIzsc0EgGu8nPk?=
 =?us-ascii?Q?Lh1Z5NRkkv0vdEs/a4Q38/E2hfw30+XMt9H1w1QdVNqNmC4yC5mOFLQjG31g?=
 =?us-ascii?Q?kHAFtrDJoChmg/FdlE/FEgMi7zuHm1FVEpcdcgZspYK7IlI7Y6DE904l16wg?=
 =?us-ascii?Q?yfKUAheZNQ47qNHNSGYPM7et3oL1MPwO1KNJravFBSVs9PTeLzz6Hcj3e3G3?=
 =?us-ascii?Q?V3MRgaew4ibWIY5VWACffwDTBGCmw13zhG3N426maE0eNXV1kycE7TfZFHtz?=
 =?us-ascii?Q?0W1XZJnXJTtN4SnqgLMv4GtDWpZk+I1o2A1UKplS0vv3MkxmZpwIOAYJWD+g?=
 =?us-ascii?Q?UIi1IfQ7b7SGTkbsn+JEs7NLEFUtcS62Bk+3IXer8bLakT2EI2MJhQ6ORXSd?=
 =?us-ascii?Q?QCfDE/UEgpe2PANkEPRsDRTVXnTV/MNwMAW6vj0hXdtPs6AUD9Oh/o09f9PB?=
 =?us-ascii?Q?8JPNhUhNFP+FnNe6T/JDVG5i6OZ8tg2TPAPk/WSXFJYEJGJ6jL7WTZ1KVoaz?=
 =?us-ascii?Q?NMRF/cg4QkN5ArmOLKI36oFXbI8TiX+8ISd2Rc6A/3IpU+pw8tfxjaeFvn3y?=
 =?us-ascii?Q?fBLmlqiRlR8OhhzHS+6BQ+HZoxi+eOmWLv9YGZTbZxEpm9qyUdt66hT7QR3R?=
 =?us-ascii?Q?BdZLLNgu8v1aNOk4S5dagP3Dr5IA+TKYEV5T4o4GHoFCGnrGlPKx8K5wEowV?=
 =?us-ascii?Q?SzcOwsvBp/cx3jokmKmWv79DxXjsS1KaPpiI9k2bVuZqr2BWwkKGKiRgA5wE?=
 =?us-ascii?Q?ZFLGI5VNwQz1vDSZ5u6ADn21n+eOR+EQyApNdUbJtLmjj4GjjTcW+zW4GqsK?=
 =?us-ascii?Q?O1hDjQ7WgoR4dD54YL/HzToBOIeYpcuN2zl7TEpYKHu05/qdPnf3qkrjPwf5?=
 =?us-ascii?Q?objrj2AEAaYNHuvyD3f3uVIog48g05unxs+BQkRoRPGwtv/wMoGl1JUmklCn?=
 =?us-ascii?Q?Ujt7vC5YHtsiJ/IyqsDsSsDbk+ohXXACJIep8O8yvj53A3S0VqgB9Y9uvRBj?=
 =?us-ascii?Q?HgnUVGo2F2Tf915c7BabfCbK/4UiNbLH7uKm+cUqlOqOD1pfWKWkYEVt+yYO?=
 =?us-ascii?Q?a66JaSURaOeHlO/OqTL23mINkNIIpf5poMhD/TF2y68F9YBUDz/dk/CZsIHW?=
 =?us-ascii?Q?eo3ZSXNn4yPACpru80EyaxAzWQI0iW798nS13gtdHlkv+huo1MjvgFUMUoQ/?=
 =?us-ascii?Q?XMevHRfikCwMXkeUOjFqYcJiZ1KXtaSAKGSmhFWaJP8eYVb6kGinrszMUj61?=
 =?us-ascii?Q?dyVhPAZP6g=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2de1b1f3-0d99-447d-29d0-08da3a5ae2b7
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2022 12:18:45.3499
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Yxo2c2tjpZEzoyu4JwPqfcgZGoTEB9mVe8kjRiNvu/Nm+RnpvKxe506Ku1djuD8N
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4933
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 20, 2022 at 12:02:23PM +0100, Robin Murphy wrote:
> On 2022-05-10 17:55, Jason Gunthorpe via iommu wrote:
> > This control causes the ARM SMMU drivers to choose a stage 2
> > implementation for the IO pagetable (vs the stage 1 usual default),
> > however this choice has no visible impact to the VFIO user.
> 
> Oh, I should have read more carefully... this isn't entirely true. Stage 2
> has a different permission model from stage 1, so although it's arguably
> undocumented behaviour, VFIO users that know enough about the underlying
> system could use this to get write-only mappings if they so wish.

I think this is getting very pedantic, the intention of this was to
enable nesting, not to expose subtle differences in ARM
architecture. I'm very doubtful something exists here that uses this
without also using the other parts.

> > Just in-case there is some userspace using this continue to treat
> > requesting it as a NOP, but do not advertise support any more.
> 
> This also seems a bit odd, especially given that it's not actually a no-op;
> surely either it's supported and functional or it isn't?

Indeed, I was loath to completely break possibly existing broken
userspace, but I agree we could just fail here as well. Normal
userspace should see the missing capability and not call the API at
all. But maybe somehow hardwired their VMM or something IDK.

> In all honesty, I'm not personally attached to this code either way. If this
> patch had come 5 years ago, when the interface already looked like a bit of
> a dead end, I'd probably have agreed more readily. But now, when we're
> possibly mere months away from implementing the functional equivalent for
> IOMMUFD, which if done right might be able to support a trivial compat layer
> for this anyway,

There won't be compat for this - the generic code is not going to know
about the driver specific details of how nesting works.  The plan is
to have some new op like:

   alloc_user_domain(struct device *dev, void *params, size_t params_len, ..)

And all the special driver-specific iommu domains will be allocated
opaquely this way. The stage 1 or stage 2 choice will be specified in
the params along with any other HW specific parameters required to
hook it up properly.

So, the core code can't just do what VFIO_TYPE1_NESTING_IOMMU is doing
now without also being hardwired to make it work with ARM.

This is why I want to remove it now to be clear we are not going to be
accommodating this API.

> I just don't see what we gain from not at least waiting to see where
> that ends up. The given justification reads as "get rid of this code
> that we already know we'll need to bring back in some form, and
> half-break an unpopular VFIO ABI because it doesn't do *everything*
> that its name might imply", which just isn't convincing me.

No it wont come back. The code that we will need is the driver code in
SMMU, and that wasn't touched here.

We can defer this, as long as we all agree the uAPI is going away.

But I don't see a strong argument why we should wait either.

Jason
