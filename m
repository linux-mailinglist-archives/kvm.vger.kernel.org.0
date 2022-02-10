Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2592C4B1194
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 16:23:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243567AbiBJPXK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 10:23:10 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235081AbiBJPXJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 10:23:09 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2055.outbound.protection.outlook.com [40.107.220.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C426418C;
        Thu, 10 Feb 2022 07:23:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gyyBMjASHJTFC+uJ1w2lmxfxYHAM3yYl/WmFZlf1oAJtIoAniEALukuIMEoMfiZw1YvNYabuMNLnXuRlTRNQ2CDTddbkOn7vfNxFsSYXnWJkwKItFg92YpVXxLeM/n2H1M97KlRFhzl+fS7pXY6dUUa5/yDF/Wlg9BHcSukH5lgH2V+Rjkbtig+566jk3kkJ78vvggzqJ9RrLbeMGTk2xXpM/+fb/uyGzlWwDaL6fJh9Z0EeFhjPPT3Y3VOgexJaCjFTWuu41Z899on5AzzcAufJKqRIxR4X1O/gVxL3Nu1w3otpIYi0bLCOXGKQMpEHSzqATPLbBgt8DnPC8JSIVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bOxisac7qMAwX4rSvMNNX89Vi7rrOgtWcmh+oqnp+Tw=;
 b=jv4FsinDPqPucSk1y13aFprBNH16xo4a38gsi0s12+yxxY+87gktbbsLojNbNQLQ7mt8sndQ77qhR77Z6i5a3lVZG07swKbmBcAxM73SwidrFe6X6k9P4EjJIwmO86K5uvgV+sOWz+n6Ftyy9MYwrChJfv4KLd/A1u7Y2l7rUUmMBN/KlfSpL0K5p015JVe+DEJZ+HpVkGsBl/Erp6f+TPJCyapGu9KcJiSepqmF169R68/VQwnumUOYhxU0dnnDp721YlhijBJE7ZC64kZqBAqMkpkR0RSWFmOFLz3eXDAGP/rrXX+nfNbyNbS6HwmNuIPcuZ6NS7MME44912mHWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bOxisac7qMAwX4rSvMNNX89Vi7rrOgtWcmh+oqnp+Tw=;
 b=ieVp6tIMG6r/zU61u4gntUtPUXzxu+yL3H08Lhu8mGtdfkybdFLk8XAB/QlEjm1+oEzbzmmMx1jtgCWtYcBHKNz3lt2ZHXDr25lhaXGA3kiQt+DsePzEqEEu++l1T0+V3OUy85HFmddqGOtx2l1mCx5QWxTbjppbIEQJQZ2hEVjfKsc9ITfWSMy2y05q3tlkwyyDbtV3K1HwK0iGe765Zx2n9hylI6DwiHWLWoKov8sRrlc+01ml90iudYE3JfsdvrDodvBC52wz0Lesst+kQPUkkDIcWqsK7MWEFx69AKCy9bBFFHX2Mbwnin4lHUXQSi6AKMhyOn38K4mqhdCZFA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BN6PR1201MB2513.namprd12.prod.outlook.com (2603:10b6:404:ae::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11; Thu, 10 Feb
 2022 15:23:07 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.4975.011; Thu, 10 Feb 2022
 15:23:07 +0000
Date:   Thu, 10 Feb 2022 11:23:05 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Niklas Schnelle <schnelle@linux.ibm.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        linux-s390@vger.kernel.org, cohuck@redhat.com,
        farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 24/30] vfio-pci/zdev: wire up group notifier
Message-ID: <20220210152305.GG4160@nvidia.com>
References: <20220204211536.321475-1-mjrosato@linux.ibm.com>
 <20220204211536.321475-25-mjrosato@linux.ibm.com>
 <20220208104319.4861fb22.alex.williamson@redhat.com>
 <20220208185141.GH4160@nvidia.com>
 <20220208122624.43ad52ef.alex.williamson@redhat.com>
 <438d8b1e-e149-35f1-a8c9-ed338eb97430@linux.ibm.com>
 <20220208204041.GK4160@nvidia.com>
 <13cf51210d125d48a47d55d9c6a20c93f5a2b78b.camel@linux.ibm.com>
 <20220210130150.GF4160@nvidia.com>
 <fc5cce270dc01d46a6a42f2d268166a0a952fcb3.camel@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fc5cce270dc01d46a6a42f2d268166a0a952fcb3.camel@linux.ibm.com>
X-ClientProxiedBy: MN2PR15CA0007.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::20) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 225fc6f6-43da-47d5-1792-08d9eca93d46
X-MS-TrafficTypeDiagnostic: BN6PR1201MB2513:EE_
X-Microsoft-Antispam-PRVS: <BN6PR1201MB2513AEF6715C7BA2C593E172C22F9@BN6PR1201MB2513.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nyYz8s+eDTFxGWdmr/Z0SyYkgjN81jR8SpCf4bYX0nAhs33HbbWUedgUczmUa2zTbErIsXZBqKOlz1sNgNKre6pOofOcmbIIcEovkinLv5o5Epjskz0yFoCptEHcgbNoLrNJbwyFIM7eg0UQfviiFC3kq6z9Z34eznwdQF4mYkpfWWXhUbO1IEsyIoLB5R7YFayzyevXyZYDHECVUEJTruQG/NcCf62ENWqHXuA9HlYSHQxCLv975CrkIvsVka2XtB1Z1wX1tYKF/QaTqVb9jqFPeQbRuzO0ulE5LMABwAeQwrDNZprUEuf8sFVWbET1NR/bmC7kvT40GO3A1T35ZAKq7E3ZzH0y1fBRkzgi1kqwKlXoYfmk9tJktV/4/TSjlQG3ho7TSfhNxLJ/jM36jTGxQjExOf15tbaK3M6wfmU1KuPLeiVtrm7R3MZVwMfZnp8PVvgdL3bVtiVVv4yUCP+hWnk2JWHwKbUjTg4p5BqFEuNHX2KdrMvKGg0JZjU88/rtXcDAA6Gfc5TSX74d5csXcLkK2WXUhnRwyYqvmYcAhHpKDocbFkrdQUGpHSvew+WPzPjqRsx5V+X3eYFzHxpt3KgiPpgbqvppsyXJRF4ADY+4JnpBz9LcHHCKofmsqrB8ZOdfmwREkWkIMbAuDX1qq2kOBU/5WIS/sBRXJOmBXzCr3HelI9Mbn4Wzw86DNF1wKtrozrK7SAcYMViooJ9eO0EHY1pYYOCbmpzxlbI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(66476007)(86362001)(186003)(26005)(66556008)(8676002)(66946007)(4326008)(6512007)(508600001)(5660300002)(316002)(2906002)(8936002)(36756003)(6916009)(54906003)(7416002)(6506007)(2616005)(33656002)(6486002)(1076003)(966005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YDyb4uLmsAhgLj/ejxjyo1zmtjj48uq3s5beW7ebvdfEI0+KyukJu95Ba5Ah?=
 =?us-ascii?Q?WTRY1OUGLaRbnnvkyUGwJtdaU83utG8YM2aNns7lsQ0tcd2xlmP9EFc5strg?=
 =?us-ascii?Q?rs7ujxdYyDr0jtct0gXxwz78nQOVD2DCCnXfDw/2pnYItgxZxdj84unKToJy?=
 =?us-ascii?Q?MMKQiiaKQHD5W7lDeERJj640miQkD7rNY0s0CEygRwYJzbrG5mpDq8ey86eE?=
 =?us-ascii?Q?UVEhXAlvsVqdklpXAiI3skZEMjQASNy3+o27nVMfs0o0xnHtdE/Q4cgJyCPj?=
 =?us-ascii?Q?wiVgIKGyLbFUgtu9Cj0Kdm1cV6E+g+YhdnOFmeDFOLHJLTTPxRniiS33aTnG?=
 =?us-ascii?Q?HT71E9hbJhjDiLOwmtkwOpBfeltzRO2GVdYv9Te3BM0w+C2BKa30aJM+I0oA?=
 =?us-ascii?Q?yl4sCVKVfGckLxz59j4GKMHmH/dPNE03346UTses4z+EaTyzoIhkJLMnT3xW?=
 =?us-ascii?Q?3ZPG+zotH5Ahkm25pvac3ZxdJP0WupyTHacXemv1UBstOyI3HY/Nqqv2yTO4?=
 =?us-ascii?Q?5brXBL0xXRcdbsdsH8Gipf1821WUm92LpDZjiBOOr54PVcybpBBK04idwk4m?=
 =?us-ascii?Q?H9cJqMWpnjwm9a5nt/zxdY4GlIET56oS6E84G0T2iL5sJHMn03axEfCWlT44?=
 =?us-ascii?Q?U4J5jivih6uFWjai0Iwi3bt1sdozb/Okqcij6PzMfx4wN/FuYGv1X+K/KZQS?=
 =?us-ascii?Q?hlYaCq47O3JUgFUpR8qnwKpaLVjo1jEvFKXhaUOg6jy90D70rRsQbVXEvzas?=
 =?us-ascii?Q?9fVh/Zvt9SAM/V7qa9m3K0kAE8YKqSQQU9fV+bluCTgQY+39FEyOFpFqLb6m?=
 =?us-ascii?Q?Mvx1X9T/4RxaJncma4lqEjG1b8cEFjycETABMeklSX85Xddcv73vOOyL9r2q?=
 =?us-ascii?Q?eTa+KooCawbxE9lFSnN7y6iDMr4Ear4ckIhaxA1wX0/m3987sHsj6LWkpo8G?=
 =?us-ascii?Q?MVjpRIMmKGDdC7nlSRh6fcSTNT79d5Yhmz3fiX1nY6QtZkOvl5nwDf9xh7v3?=
 =?us-ascii?Q?8KMypJZsgX0FaRGtCjflhfLcyrst9TQ4hGtK8ZNSlI2eKenbsprii0rjRpc8?=
 =?us-ascii?Q?/WGrOcJ3vqTsjXwVJjPTdtMgIF/Fc6i0lYpESPzkhfPKGH9nJMzjtdcouMfX?=
 =?us-ascii?Q?aefwIjSm0skAgj/lpgr4f6Fe1yk03eJfXuYZcHBuYAfyyHMlnp0JRY06FXoh?=
 =?us-ascii?Q?dhUFMAI0LjHZjEsYL+oEJSjvCuhfZNarc0ntBxpHl4FpS8NQWj7Zu31SW6sC?=
 =?us-ascii?Q?hQhF+4D4p+ykSYDYiKATFuR1duszqlz9xg1Ql8RXcRF3GQNw5xz4VxZB/MyB?=
 =?us-ascii?Q?BB9ak1dnankxmFPNTsktDLiMXCdkGyiqXuGcANJeyKjQCPdCpNntuoZjwU/i?=
 =?us-ascii?Q?aF5ee0L99cIM2D2iFw1/Js6HOtzIZM6iqbSLuLsjOfRYNlIZzsFDKFH3OnJB?=
 =?us-ascii?Q?wXC3KDft5wWgs1U3iAkNzqpVt4nrD+pMAYZ+gjqwiMJlMeEiRWSqMs6B6VIs?=
 =?us-ascii?Q?RizpdI0M1FXDz+TgNcn0VAeM0+QRVtnaYr3Bjqpat6j7X3T/3JBqNmCFYKGn?=
 =?us-ascii?Q?//eoBsdY0l17KsoRjGo=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 225fc6f6-43da-47d5-1792-08d9eca93d46
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 15:23:07.2673
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: enuN1lIc6PsgDvuKfSiv2f9YNiIlEE6rOAxm49zTsYMS5JktMjuJisdBU7JMqD56
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB2513
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 10, 2022 at 03:06:35PM +0100, Niklas Schnelle wrote:

> > How does the page pinning work?
> 
> The pinning is done directly in the RPCIT interception handler pinning
> both the IOMMU tables and the guest pages mapped for DMA.

And if pinning fails?
 
> > Then the
> > magic kernel code you describe can operate on its own domain without
> > becoming confused with a normal map/unmap domain.
> 
> This sounds like an interesting idea. Looking at
> drivers/iommu/s390_iommu.c most of that is pretty trivial domain
> handling. I wonder if we could share this by marking the existing
> s390_iommu_domain type with kind of a "lent out to KVM" flag. 

Lu has posted a series here:

https://lore.kernel.org/linux-iommu/20220208012559.1121729-1-baolu.lu@linux.intel.com

Which allows the iommu driver to create a domain with unique ops, so
you'd just fork the entire thing, have your own struct
s390_kvm_iommu_domain and related ops.

When the special creation flow is triggered you'd just create one of
these with the proper ops already setup.

We are imagining a special ioctl to create these things and each IOMMU
HW driver can supply a unique implementation suited to their HW
design.

> KVM RPCIT intercept and vice versa. I.e. while the domain is under
> control of KVM's RPCIT handling we make all IOMMU map/unmap fail.

It is not "under the control of" the domain would be created as linked
to kvm and would never, ever, be anything else.
 
> To me this more direct involvement of IOMMU and KVM on s390x is also a
> direct consequence of it using special instructions. Naturally those
> instructions can be intercepted or run under hardware accelerated
> virtualization.

Well, no, you've just created a kernel-side SW emulated nested
translation scheme. Other CPUs have talked about doing this too, but
nobody has attempted it.

You can make the same argument for any CPU's scheme, a trapped mmio
store is not fundamentally any different from a special instruction
that traps, other than how the information is transferred.

> Yes very good analogy. Has any of that nested IOMMU translations work
> been merged yet? 

No. We are making quiet progress, slowly though. I'll add your
interest to my list

> too.  Basically we would then execute RPCIT without leaving the
> hardware virtualization mode (SIE). We believe that that would
> require pinning all of guest memory though because HW can't really
> pin pages.

Right, this is what other iommu HW will have to do.

Jason 
