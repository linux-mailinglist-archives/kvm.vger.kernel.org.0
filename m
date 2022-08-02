Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 712145880A0
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 19:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232167AbiHBRBQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 13:01:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiHBRBO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 13:01:14 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2059.outbound.protection.outlook.com [40.107.94.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91C1115FEC;
        Tue,  2 Aug 2022 10:01:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DhahjCUbMDgdjZAOlLJjYhBDFxnreowcEK9yM9y5QykczG/NcCOmzMdJJc2ok6urqY4XTGvtNLP0FraWzv9VrRo1Hs8qPUvw+QU4s0HsfEggD5+3bndjRzirXrojZ49owQl9W0KL3fkAYgF8DBQLVyDA8RYnwhPFK1jFmFDId0+vigs2dIZQg1qtod3ZtaecLOdY9ux6VXuFxpXWYl7+fRV5yQRbykHpTcXgHEO/tBW/rBI85aSiAyzdtRF08s9mdXmYlUflP1xveGuz2yZFWFMVSQ75KFEAVgVWBcvcMI1lsIBs2Crj5NhVx8k05NiZV+r1+RBlYGkS36l9J1/r7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YJJVXSwkUPpEWaQAn0rniyXHw0lj8K4xMUQy70u0NFc=;
 b=Cqq+P2uo+wZo/PltuIT7FcF8fynMiJ5NC0fVLBCXFDE74Hk0l/x5ChoTNd+I5kL9my5VjRRHIO1raEsW2/sk2XjTRwKym/H+orCAmYVtfIBRIJvvt/dJkbF3ZBtIzDRK5nO0jnXtwPmzGAm9SMsj/Zt0Mvp2/IPPc7KLTCXuN7B6nyFmB/91Hk9WokUcQIkVa278qSh6/CZ5hScVEFLrSX+3s4LUjx6khCmFJQoXQRhOH8LUgFuErLUacsBxmXSX+L3wwhbFqYJPQH6NAgYuMM0ssCw+xB50Dm7kIC/6M2RhYstLRT6xuuP9xFGnnm+1o+heEpXib4wik0B47QmjEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YJJVXSwkUPpEWaQAn0rniyXHw0lj8K4xMUQy70u0NFc=;
 b=Jqyui82zN2Ai1bCErIUsSXtRsfNL8MoIuy8NwvbjawU6igFmdjTwsUu6e4i0embbLuxBDszSAZ0jP8O4kjoJayoOLwsYWp67d/VPqrZR4QCcDYDzCMQ2yBX4UIaIi3OeJgEh7UOUtJdxy1KURNi3cY1PA5egMRM84TBJRj7S1GaPWVqSejVFUgiUFGYfxvwYYv2M3yKwNynyXZmGDKmq0Ti3fbf5g/03e0gMyK6l08K0kPNM4AHgS/Ts+OfH7+cmvdtaQtB6Hrl2TK9mQka06rnveAHUGa7PYYpO8sMw6v6KK1GWukUfEb7TuATpWJDYBvNefeqvsE98ule7duUjfw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MN2PR12MB3071.namprd12.prod.outlook.com (2603:10b6:208:cc::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.11; Tue, 2 Aug
 2022 17:01:09 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::4cce:310f:93:5d58]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::4cce:310f:93:5d58%8]) with mapi id 15.20.5482.016; Tue, 2 Aug 2022
 17:01:09 +0000
Date:   Tue, 2 Aug 2022 14:01:08 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Abhishek Sahu <abhsahu@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Kevin Tian <kevin.tian@intel.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v5 1/5] vfio: Add the device features for the low power
 entry and exit
Message-ID: <YulYVOWh8km2knhx@nvidia.com>
References: <aaef2e78-1ed2-fe8b-d167-8ea2dcbe45b6@nvidia.com>
 <20220725160928.43a17560.alex.williamson@redhat.com>
 <bd7bca18-ae07-c04a-23d3-bf71245da0cc@nvidia.com>
 <20220726172356.GH4438@nvidia.com>
 <f903e2b9-f85b-a4c8-4706-f463919723a3@nvidia.com>
 <20220801124253.11c24d91.alex.williamson@redhat.com>
 <YukvBBClrbCbIitm@nvidia.com>
 <20220802094128.38fba103.alex.williamson@redhat.com>
 <YulSOK+YKjV2634b@nvidia.com>
 <20220802105755.2ee80696.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220802105755.2ee80696.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR12CA0006.namprd12.prod.outlook.com
 (2603:10b6:208:a8::19) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c64202a3-12a3-49bc-a873-08da74a89873
X-MS-TrafficTypeDiagnostic: MN2PR12MB3071:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UGSQn+23trq4f/qeTuc4Sd6tkllpIYhxOsi+NGT3sHOiD4jaTri5GOW3xJw4ik640i/yMY66Ji8uTGShVbKSV0mLdQ73T1VVRMkChQFuC+F/WlmCcPx3oinDWTtrtA0eEHVyrKJ3lVtDTMX2esfANv8QN+3I7pn2NmcOeeF7GtvQcQnZmz3sE4BFqZIWMjK5WUEyLWFHQn/3y74Yg9dNDxt3ckiJTI2Xfz0lmTltGmacI0R0l4coP0X5N9gczUO9fOpHZ2Kv1iKCNq82hJeJYuWfBicRyzaWKmJI7PQz2PAI7uzLCu+Lon+VO059kbz8phGftbvGGLiMSGMh0wDRcIn7rr/BFqWxuIbKtu3ST7hKaaAg1tNzvHbwJHjiibGrpmgMzXwtD6DYPmqOf+PkXoSK9EuJFzXSXAksNXUqL83hOmHJwugzbPyuDl7Llc4gh8K5wok90HeUwNuIpsgH8VH6AYHV1RrrZ8ULqCa8to1bFYvXho/8H4q+OcUKgQvmwBcoJxdlTJF+P4ZCHaFeVs782KKG9xjh4IWiLbT0oGuApIz2VZLOZ/qDCLafovMU3GCku+klXfTpCQFspu6hL2j/7JD3hWHsmbjdL3hUC4zNVSup5s/F9EK2NMQrGR37v6fKLinqa7Nil6UsCJXFzWfr69DWkwXwgLUZ7YRxcqVeOB47Ju5gLBxeyeAA56kHnyobPRiJySlf8QR9EJm9J4uYfgHOhx32m2SNMmLofdhNCoAEC/8Cshca64xGhDS+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(396003)(39860400002)(136003)(376002)(346002)(6506007)(6512007)(41300700001)(26005)(478600001)(54906003)(6916009)(6486002)(316002)(86362001)(38100700002)(2616005)(186003)(83380400001)(36756003)(2906002)(8936002)(7416002)(66556008)(66946007)(66476007)(8676002)(5660300002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8WuFGQPVqotodaID+U1JmsUPwvZLagI5ZTDSHte7zTQlHoPUavvrFb0wrFW/?=
 =?us-ascii?Q?T5Nfiy4IpO7Z503P92EJ4HSurCSb1UhhJhWvX8pPB6/nW27B31b+MwwMq2AA?=
 =?us-ascii?Q?RC+qrVulLr+kgV/KY3FlcqAAIkMYhiuu81wv5xv6FCz59FwzQzdC1plvuxMN?=
 =?us-ascii?Q?J58srvavvrYt7MPPl9ytAqK6gbKcM2rVGcgXjZtImGSCoFPXTbH9Yb0J0e1O?=
 =?us-ascii?Q?C001UH35IOnuXSzIJgC5KqyLoLCzM2D66m6fTEsvn6PikSBPDPANurHRNquA?=
 =?us-ascii?Q?PD3gFDx+ZHhPv3FzaieffWYa7gBiqtOunrgk7UoshUlDXJmfJHpV5EXgg5a2?=
 =?us-ascii?Q?9fGs1K8qEki4/+QkEGV37PK4otspOM1VlblH53MOmO2lfagPnv9dXNwTDSwj?=
 =?us-ascii?Q?My6OdDIw8CGP1Ly+Kxy+YB2cZc/8nqJ49EE57Kn4cTEEgYQvSA0BUh1vXRha?=
 =?us-ascii?Q?MQ3cDTsI/9d+4T2wI1IbSUELJz320yPW/RNZvBMo3sbercQ0HOg30+CFFg6Q?=
 =?us-ascii?Q?QbQmnnMAHQxQVYCATKJvP24NlVwAZ4ksDl4XrEssNMaGb/YbUToNQvdFw62x?=
 =?us-ascii?Q?MCyQrbRBRR1LzJk75cIcp7CQc+Vtop8KDNGcvTFRRDYwKO+uE2s2A+79ALqu?=
 =?us-ascii?Q?ZizlszCJAbVYN+3M/xu+MeNDWTcCl9rf8sBE7tPHGFhru2dQqGnibKL7MHHW?=
 =?us-ascii?Q?2uKbLYjB9vd5hAT1DEkJTcmI75HSLik1UMWkOyA0hpD1moUB1bcRmrOppCv6?=
 =?us-ascii?Q?g64T+QzuIQ7TqvIXB+mEi3mUyvTIMIy4XeinuwmDtCCLrqM8/EYNp50TKKj+?=
 =?us-ascii?Q?qNTH+bK7bcMzFNqUoOO4i5q2fmUbLlrsQYNg5bnqKxWanf36j4SfS+wKm7Ly?=
 =?us-ascii?Q?W9OgihniQ2l7EA5CpropEQBr66/7phYnYiKTrWlgUglcFP5Twn6NrG25tYkS?=
 =?us-ascii?Q?txw/PKIqfvwwq4+XWNSa6FGpgOQn/wBm0YdJjLEYIA3MbXN1qg9gMXIs6ao9?=
 =?us-ascii?Q?t9exVS20U21gW4DS5xZp3OU7zEP3t8JkRtT3psfl6pzfAPM1YHCv0VNqBWuT?=
 =?us-ascii?Q?IRgoINr/j4aeq4ckj6nk080NqIzU5D/x1IimnkyKAFZivlgeOs6443JbM9n4?=
 =?us-ascii?Q?seNj796PSzwXmkojlyCwsEcm50JOqPROgjtw7y98laV2DXmO7jwkaHHSp7r8?=
 =?us-ascii?Q?yVZhhoroaa5OTlYS2iPH+8jJKoP8WHWIy8VXrK/7w98poEiyRlOwj5esWBK6?=
 =?us-ascii?Q?2+XcehcnIbxoG8ii9xj430FDv77a32642MGtBtmWguqIojMOzig+k1Ox1gGV?=
 =?us-ascii?Q?KGhd9k2Ua3FdDtVFaxwzrDI1tNo8MZFYB7Xewrrz+yD9yBkN8SLOjpL04ENo?=
 =?us-ascii?Q?rGsMk2cN6QBd3a4PZATWivGsK68XBC1a7u1293pKkNPv08j9jK7jeQmPRLgf?=
 =?us-ascii?Q?+F5M18fXdk+02wVBS/LoFmuVgiMzQdr9vC1I1V8+rsev7bviFnaOCxQpAoEa?=
 =?us-ascii?Q?EznSF8OLNIbtEpC0zwS6QERGpogl6d6rqX3zBPz7JRI0opRDOtlcOwUSLNJv?=
 =?us-ascii?Q?ehOjpZUih4aaBDXbP2h0fnFmHV8W7iWEBzl9dHto?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c64202a3-12a3-49bc-a873-08da74a89873
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2022 17:01:08.9421
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mNHMeScrFSnLrOfmcMAw61S7P0mw9SAensXzmrLmWiJqXExAGG8C/ZFxDQ7ZRMBA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3071
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 02, 2022 at 10:57:55AM -0600, Alex Williamson wrote:
> On Tue, 2 Aug 2022 13:35:04 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Tue, Aug 02, 2022 at 09:41:28AM -0600, Alex Williamson wrote:
> > 
> > > The subtlety is that there's a flag and a field and the flag can only
> > > be set if the field is set, the flag can only be clear if the field is
> > > clear, so we return -EINVAL for the other cases?  Why do we have both a
> > > flag and a field?  This isn't like we're adding a feature later and the
> > > flag needs to indicate that the field is present and valid.  It's just
> > > not a very clean interface, imo.  Thanks,  
> > 
> > That isn't how I read Abhishek's proposal.. The eventfd should always
> > work and should always behave as described "The notification through
> > the provided eventfd will be generated only when the device has
> > entered and is resumed from a low power state"
> > 
> > If userspace provides it without LOW_POWER_REENTERY_DISABLE then it
> > still generates the events.
> > 
> > The linkage to LOW_POWER_REENTERY_DISABLE is only that userspace
> > probably needs to use both elements together to generate the
> > auto-reentry behavior. Kernel should not enforce it.
> > 
> > Two fields, orthogonal behaviors.
> 
> What's the point of notifying userspace that the device was resumed if
> it might already be suspended again by the time userspace responds to
> the eventfd? 

I don't know - the eventfds is counting so it does let userspace
monitor frequency of auto-sleeping.

In any case the point is to make simple kernel APIs, not cover every
combination with a use case. Decoupling is simpler than coupling.

Jason
