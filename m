Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 998754DD9DF
	for <lists+kvm@lfdr.de>; Fri, 18 Mar 2022 13:41:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236357AbiCRMmc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Mar 2022 08:42:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230008AbiCRMmb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Mar 2022 08:42:31 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2044.outbound.protection.outlook.com [40.107.101.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30B2C2E35A0
        for <kvm@vger.kernel.org>; Fri, 18 Mar 2022 05:41:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZifhqHa0o3YJdJkrColUIamDaG6RM3emuONPtlyiBf6D94ecy+JeJSERALg+Oe/VRmeDTqKwEHAuOdpevnvW+D0eCi7XPDwEU6S/GKtU4k6s736zV/qdHA+00O+/FUcGF48Gv9gQfZv4uZOIWBxqB95KXor4LlXXBGiuXEAYdb6jz8HKpF90T8oHtNNCdRcBEzgk5cVG5LtXU/iI+Fe1CLL4caPkKxLLryC2Pu/S2gogzQkS7nvDv71xAEod8KI28aB+Zv20CM37H+gohaacZr+afhVRwoOd+bp0kS3BFwqfQ8+mjKOGc6mGP1Gk4ui4Gi0TgA54DA4wAW/umbLygQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HQ5/BPCvx8+n0GMm/tHR28h0HBgLUuAtiPbNJKUQe8Y=;
 b=gdtu9bRukGJ1KZWhu5+pw7GTXBZjkvTYcMTWiptqqAMRSQvr9Eu0QnWb//WlIBiYIOLkXQ0CQePgVd1U9Ws33LeslUB/tki+4LpDks1mQiYYKYNhE/bEwce3Cye+HvX9zhIPJWiLzEomMca+uJNT+qc/j6jjgglEm6RghiZ1Gu2MfzyyZEeFdaP5+xnEiu6+AeiX5ALv1MMyGJZ8HODq/GJVItgpVhXXTqCfOAs87YyZW8Uvws91qCk+Zpyi96x0Dsw5F4rislTZ7241YJnaCT/HhSA9GPHGNsVdqJZpplxE396fP4shLan7mRLn5MrwSWUzVop7J4x0DpN5+VXAbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HQ5/BPCvx8+n0GMm/tHR28h0HBgLUuAtiPbNJKUQe8Y=;
 b=GWYYKM8PNBtTaQ4o1sWuQFqqCkwCTIjES98hghmNuwDbv7OrXiPNGTMzNsSB0t6lpVEQLDm3Biy4OObZ2OrJzUlOxlB0HmJINBrI3vW+ZiKyQG1jz4UHfV8p38FleU1BFrvndpnimGHyfY23gSPz6/b+L0uNrGFIAb+9zIqhGTyBZFhzyoehrTGwMSLoq32Jwk9kMJ+u+m4TwEsZnVPKfh4Jl7oRrJqA/WPWfqYgKdJlpk53q2UZa8pVmDO42hhXFlRXUUFjZTxPTXJcQjjPe/VtJ6ej8AmUTUd3xnigCW3iM8C3v98XWXxJ2aKmEuSemozDj70qDId/+OBaiRSsnQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MWHPR12MB1949.namprd12.prod.outlook.com (2603:10b6:300:107::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.15; Fri, 18 Mar
 2022 12:41:10 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c%5]) with mapi id 15.20.5081.018; Fri, 18 Mar 2022
 12:41:10 +0000
Date:   Fri, 18 Mar 2022 09:41:08 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Thanos Makatos <thanos.makatos@nutanix.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        John Levon <john.levon@nutanix.com>,
        "john.g.johnson@oracle.com" <john.g.johnson@oracle.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        "Liu, Yi L" <yi.l.liu@intel.com>
Subject: Re: iommufd dirty page logging overview
Message-ID: <20220318124108.GF11336@nvidia.com>
References: <DM8PR02MB80050C48AF03C8772EB5988F8B119@DM8PR02MB8005.namprd02.prod.outlook.com>
 <20220316235044.GA388745@nvidia.com>
 <BN9PR11MB52765646E6837CE3BF5979988C139@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52765646E6837CE3BF5979988C139@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR10CA0004.namprd10.prod.outlook.com
 (2603:10b6:208:120::17) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9499dbfc-759b-4530-e4c1-08da08dc9442
X-MS-TrafficTypeDiagnostic: MWHPR12MB1949:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB19495040E6004142C0A7F9EDC2139@MWHPR12MB1949.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oDkzcQQt1d4+6GaIYVDd8k3ce75MTaF0OK7CyGoqcmuGfSif9veEhI4xq2kv2qbG0BE1y7u0T3lZyS0qjEjRVQloshigWLmr8gQ7uCnzMmax9CRrZvNDaoIngfhbHkjb+fhC2H5DgHVcQRYsvJmUAasCpM+VrXKOY4xFhtUX6O0cGmGu/OtVoUrEEaTbPHGeObwqfr15ZgRCf097JyoYripqOpJ2RvLdH2k1SHx8k1mlSjPyH5LeYcuUDRIZ3dkbKW5oOnJWxmOGnkyE9gaayJbhogUwIEU6xqeiGmvXox0cqK90y2yi6Krmd2CiD/GxCUSuB8M2ZTcvXudNkOgxCDQba6ccuPJgly3oh5WdZ3a0uq0NzZ3cgXFdsI0ncmBYqO5J7NXqnSROllgHoYjaugioXm4CPeeoyiHedtnLJGNTW2RfgqodnQ4KJ7enotJq6ax6z7qzC+kUJv/ZBvjUUhFdr6koAuKyfLZx0a1hHT8yYB8orLdShOlmPD4UC2PhsMTUVGuA24ML2HFy+3vXpyDvayrYb/3cOj5PvLcVeku/mwCLv1D+39WIBZ0Kt/jzdXH51uDwq34ZHWIhq17SFKs5I5NvaFgc/Cxg1CCJ68+eqccY7By+1VUSzTYEEYCih8Mdeoxpqj5XALWPLyYrf6gKbypZpLhuPsTV0DcQq03QMVCkaJuSLM2RQ4pe2ndZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2616005)(33656002)(26005)(186003)(6916009)(1076003)(54906003)(316002)(36756003)(38100700002)(2906002)(6506007)(6486002)(86362001)(8676002)(4326008)(66476007)(66556008)(66946007)(8936002)(6512007)(83380400001)(5660300002)(508600001)(7416002)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9t0sImTejwtG7ZbZnRyqZR4H9JFgEpjiWnmc0NLq7ty5zptLwpXw206S8nvu?=
 =?us-ascii?Q?7UjdsW4b/tO4jRCpPNFxqpOcswmNpQtfxUWdDijkEJDz7fuM0L9m3eg5GqYn?=
 =?us-ascii?Q?ch8+caePXFvyIlWtV6UsjsVGPAQny/0LuXTSfPRFE8fWIQyAnaWgnCGS9O4F?=
 =?us-ascii?Q?t0BCTY7zfp+lwM+norB2Y84e0bwV0XFwhuVxiBwgiKBLkmxhOF7brp1seEeZ?=
 =?us-ascii?Q?Soe8St/ZjSpeys0oq/9zp8cBYxWob1mC0aUP9tUBp5Yn0Ona+bv7WH6oAFFY?=
 =?us-ascii?Q?5F0QslT4eYrLV3NaPQiOhLOu3ZYe6zavFiHnewhTbTnvoLitKsQFP8UNBWei?=
 =?us-ascii?Q?4BFUCeZwoMXRqIw56bLnez3y117OKXaUqLKQsXGfJM5pRXuJuUSPL+JKSbPc?=
 =?us-ascii?Q?uNPBU4JH00F/elBGw8gufuf949GXN0WViJH8kmtqTBQIP92ZboODjQ3ODDoE?=
 =?us-ascii?Q?L+e2rGlmN0IUFs1vAl8JOTyRrgptAtOraEbFL0Gr7qemGsMG7ychPKj8zL0K?=
 =?us-ascii?Q?oUVNI8LeHmqAa/iGgBPxgAXnFymxpqQuNmWs7YVf+E30PdSBGr+/ilAuyrMy?=
 =?us-ascii?Q?VAwNOBqb8FwbTfkJ8YG5izKlbJobHCXzEJonfwcYFpR8MZBlbcViC2P6COh1?=
 =?us-ascii?Q?wxLzofXf5598V/kO5Sgb0sNhiwUdoS3B692a9+MNIPaegtJ7N8IiqxPyRvue?=
 =?us-ascii?Q?Vr/fhfvUT5H/2brDKWDQd/Di+0ii5sITF+DwBcJZPRAvUoTf2GBv9xInG/ED?=
 =?us-ascii?Q?LFx+VJRzE8z6evN4yWIlmgJCHKy2V/Wf4ngViVmhTApf1L57lgRg36a6k+fK?=
 =?us-ascii?Q?NhlJLUedtAlr+VQz6Eir4/yW59jmlJ1p97VOsmx11/Yc0SeHsaHK31I5+o5T?=
 =?us-ascii?Q?qxzLgjUEt5bq1z3huC9FXpPmiFc0MnTlhSef2/OnBCLfIvRBshTqFFLVS8pr?=
 =?us-ascii?Q?R/Ve9KkLHTm8Mr/ceyG+MmF9qDEk2IrtQYH/W1L+Bn1JOR8krGJMLJRLgRt2?=
 =?us-ascii?Q?HlakimIP5v676bCIMfk+xMNubq15pQTGREGDZdyT9f7vO6i3RXIXaoHiII1V?=
 =?us-ascii?Q?a+8pA1mzEKX/SHq3IL1SFFQ/JHP4S8vAnx438Luu3Og3ePWwXkBf4jmqGH80?=
 =?us-ascii?Q?5FSYUjJXenbvMlngj/M+wKpWAG7ZdGyzC0LqGzwlrKAlpYQ0pxFdQOQq5n7h?=
 =?us-ascii?Q?I/NBuWd1a//AY4Ho8sOw9Y6dft+lx4RykWKSEVTc0kMn4963f/XAltSZOEjv?=
 =?us-ascii?Q?litXNtzmR5M3sUOG/SL64JN9V+elOBRNhlLVX+5gXp5qvr9JZT4+VF1zMNXo?=
 =?us-ascii?Q?6BPPG5IyFeYzPmeRCMTCk+YykawJReSWceiY41+vyPmkHqmDPeieI16el6g2?=
 =?us-ascii?Q?sDPRQxbgq6T/ZsTLqRoEEkADfHTl+byvDvJtLtBSVSlxpYuosbdmm3L/Bzzs?=
 =?us-ascii?Q?iPJR5OyuW2r6OyA25dMFgfZLDOp4Hn8W?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9499dbfc-759b-4530-e4c1-08da08dc9442
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2022 12:41:10.1616
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gasqNyih8YulUS22LPpejMEC18ZwxCbitVVbOwTBq15gs3021IyarhJ06o9gYYD1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1949
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 18, 2022 at 09:23:49AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Thursday, March 17, 2022 7:51 AM
> > 
> > > there a rough idea of how the new dirty page logging will look like?
> > > Is this already explained in the email threads an I missed it?
> > 
> > I'm hoping to get something to show in the next few weeks, but what
> > I've talked about previously is to have two things:
> > 
> > 1) Control and reporting of dirty tracking via the system IOMMU
> >    through the iommu_domain interface exposed by iommufd
> > 
> > 2) Control and reporting of dirty tracking via a VFIO migration
> >    capable device's internal tracking through a VFIO_DEVICE_FEATURE
> >    interface similar to the v2 migration interface
> > 
> > The two APIs would be semantically very similar but target different
> > HW blocks. Userspace would be in charge to decide which dirty tracker
> > to use and how to configure it.
> > 
> 
> for the 2nd option I suppose userspace is expected to retrieve
> dirty bits via VFIO_DEVICE_FEATURE before every iommufd 
> unmap operation in precopy phase, just like why we need return
> the dirty bitmap to userspace in iommufd unmap interface in
> the 1st option. Correct?

It would have to be after unmap, not before

> Is there any value of having iommufd pull dirty bitmap from
> vfio driver then the userspace can just stick to a unified
> iommufd interface for dirty pages no matter they are tracked
> by system IOMMU or device IP? Sorry if this has been discussed
> in previous threads which I haven't fully checked.

It is something to discuss, this is sort of what the current vfio
interface imagines

But to do it we need to build a whole bunch of infrastructure to
register and control these things and add new ioctls to vfio to
support this. I'm not sure we get a sufficient benifit to be
worthwhile, infact it is probably a net loss as we loose the ability
for userspace to pull the dirty bits from multiple device trackers in
parallel with threading.

Jason
