Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB3DA4B19BC
	for <lists+kvm@lfdr.de>; Fri, 11 Feb 2022 00:45:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345856AbiBJXpN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 18:45:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245029AbiBJXpM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 18:45:12 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2071.outbound.protection.outlook.com [40.107.101.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DB625F75;
        Thu, 10 Feb 2022 15:45:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=exqJCQ1UENFhiPWNDnWlS6Tyk5EsTU4aGrZ+E+pXubEFsecF6pP+XUtms/es4+5fm+YNOq9PJo9hYJ6yznkVKKAdm61aJ7rLmGYpHZSrud3J26cuo5o9e+kUZtsDe2IJsikYr/uEvdatHUBlniatj40vFUvGbWRIopGcknqZEpZeveChGkJB6quRp47LkXJVDS2wdBf7HcQlVllTNHzST4Z6EAScwXaS167Y8dIKydUYHobmko53DYsvd/pCQ1LzC4H9MmdR5wrHq9wjLfRLva82q/XD31YE569xYyYvKHsXvEe5xAL898yZvtqLiQDcvkHrFiaqeGvHla+7UEYDPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aDvIeqZ+4HO+oG5g8sPNGyClV8mA0zBfVkrHCpXvsls=;
 b=lxlYpb7WyCI82MD1FCAHCmfSpyY0WuLhvf065Cf1e4Kx6jpMKdbKaaqGPlpX3JYSh7A2r9AYGXcBLb+O9DiNG10l6a6D06CGWekKWW6f1bzqu7uFUCqlvLGjS5i3fk42SrSOlHaScdBXTZexoXLvKLPYyVl2P7BE5nadg7qTgUznH+wLxhxI2g7NfXZLc9mTKp8D2OrAUTgQMajGjRXdoB/FaRQ36uViaR0A2vI7zcvCtm1FrwTBzygcEn1PfD7YIGPGIr0rUE+VsborjzTHrGBvXEuRKIpub443HAOjpwDCgqXAp3tlM3oCXRVbWaokUmgzStjbywkGF49l/HAxqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aDvIeqZ+4HO+oG5g8sPNGyClV8mA0zBfVkrHCpXvsls=;
 b=a0bw192SSPVyheNJ/s35t/wGPTWKxUGbPXib1+R4rSogJglty3hghcaktErt4Xx4+pFwd8QgHRGzfjXgFw1qf9/mX4qMIsT7cQQCTWJY7EhSY1UQ/7a1g+sgyr/uP6HGvUTPhQcnD/IgWVPftApNaGF8EfbiK3JOZmBzTkXQxg6sJvvlMhTvKs61fleDyHJTdO6PyKLfBvolqU/Tg/RxT2KKVVXVuHpGMXTfOz5K6zFxmshYMnSSfSUuGP8CQo/DZem8N64RkId+MZ/XW3RHRLGM9A4prpfVckMOdSYSGfO9IO4RY3K3YtJEkJRZo52zWZ3GI7LCla9t6pfdUr5eCQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MWHPR1201MB0064.namprd12.prod.outlook.com (2603:10b6:301:58::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.14; Thu, 10 Feb
 2022 23:45:09 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.4975.011; Thu, 10 Feb 2022
 23:45:09 +0000
Date:   Thu, 10 Feb 2022 19:45:08 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Niklas Schnelle <schnelle@linux.ibm.com>,
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
Message-ID: <20220210234508.GJ4160@nvidia.com>
References: <20220208104319.4861fb22.alex.williamson@redhat.com>
 <20220208185141.GH4160@nvidia.com>
 <20220208122624.43ad52ef.alex.williamson@redhat.com>
 <438d8b1e-e149-35f1-a8c9-ed338eb97430@linux.ibm.com>
 <20220208204041.GK4160@nvidia.com>
 <13cf51210d125d48a47d55d9c6a20c93f5a2b78b.camel@linux.ibm.com>
 <20220210130150.GF4160@nvidia.com>
 <fc5cce270dc01d46a6a42f2d268166a0a952fcb3.camel@linux.ibm.com>
 <20220210152305.GG4160@nvidia.com>
 <bcf04ad2-848b-de03-5610-d99e3b761b10@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bcf04ad2-848b-de03-5610-d99e3b761b10@linux.ibm.com>
X-ClientProxiedBy: BL0PR0102CA0062.prod.exchangelabs.com
 (2603:10b6:208:25::39) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 87a6526c-871b-4fa8-7674-08d9ecef5faf
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0064:EE_
X-Microsoft-Antispam-PRVS: <MWHPR1201MB00647DFDA2E5E84F621D1E9BC22F9@MWHPR1201MB0064.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YKWphp686d2LHfhrfL1oXeyEyyZEaSQ4DO7Dgb4PcPb0agmx6IEXY0kvfLDXpmAvKgN3u8/Hkzicr+UpPCo8On8EFBMbptSYlzfaWCnYrJOvBA+BX39PNwG5MVihYUJuHnEjlK9RP3CytS11WGQSA/ngZ4q83FpYnvNtsEyGqOs8G/EWE6j5Z9QOCinNNOHtW53GuDihStqG03P8bSianxMvgi3jWBDu56Eb3e62NuqJ6eq1YbCQqV3NMIVRy1W7xk5/gq0/xGSAUHZN2xOrrHmc1v0SAdJEKd4XRHaM0qbkXLder58FaiT3YUrp1n6eemZqui7E7SQknORIGDM9AvbJrhNh7JBpsU1kiaKjq1/49oVVvMk9KvDyF2LRXADPqxKCaZqR6HUC5Ua6WmYbbH+bPL5l/YePRlnob+rfaOLux+uD2hxZIMVhsWnft3ieWIp8rTeJSrrNI1mO15XXmJvAWAcqdddsTmiv3hDvEepEotKkFv40DPeRWpK65GTKf/JkeftyrqPGyjR7EUAs9UwoSPUWpqijg8vT1cd3RYMM8UefmoWuwZyBIl/uvshOBElQmCmHNkNJE0BRJAmQGkxQbQrgYby9J30yj2WbHcIZSM9Rci5YFDuPSduXDWHkmGEok+k/6a39z3zeWFXQWw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(2906002)(33656002)(316002)(5660300002)(6486002)(86362001)(7416002)(6916009)(54906003)(8936002)(26005)(66946007)(66556008)(66476007)(38100700002)(186003)(36756003)(4326008)(508600001)(8676002)(1076003)(6512007)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OegLJe+I0HpG6iw3mvF61Poi5ceVfIFVFjGCNP4HJ83RrEn0lIpPlQT/mvlY?=
 =?us-ascii?Q?ZjphmQgBTpCKc0dk2pelJ+B5ePZKQh2fggE7HCJ0paJK2EUkRXNNAhfp2GP3?=
 =?us-ascii?Q?9Ysl4QiaDBdoS+ugI8TOUMIrE++pvPUV2nl8A493nQ4oRNLlxeQJzvIg+vfQ?=
 =?us-ascii?Q?9u6tV5ZYjjPsKRgZYJrG9PWh3JdCXjtwRme/OuAqeki/+oHTZ53Xy3sUR82B?=
 =?us-ascii?Q?VCDRlAQpvhkceV0KafmCfowQAD/+7/R0shMMB9nya4GUQlhOTIBw11CCbAbx?=
 =?us-ascii?Q?ye+7f52ptXloUyjD1V7MBpZdHY/U43xioy07XEwo1UuNbRGsVn5d8Ee6nptA?=
 =?us-ascii?Q?Hbx2doJi05QkV95EP6adkR1vBj1e+yblLuQzu8lNEuYsCozxIMgbnlf7q1hl?=
 =?us-ascii?Q?UZUnYu24TINO2ifDOvblqw8smR7JIZCiN9ZcRQV6FOHaJBTcQGB0uM6k94Hm?=
 =?us-ascii?Q?Ud0kHh4tknmVFmVmyD8dwOmZbM+1h/TXjyEqt+2VYD3jJZ6WkQiLpoZEeWnd?=
 =?us-ascii?Q?kQHrdL5BQCisHGzhok+kvh5IubYa+LmF4XZaEA2CA1oDKTQoL70HZ0NHdeFa?=
 =?us-ascii?Q?sPyfrmh6Z3D8VdXnAYmvgxFoOYABT7dsUDZ6wXeVhdlLRAl7LheWTBLPYpib?=
 =?us-ascii?Q?Gg0CCkN+pACTrD1h+f+hyDfuMiuHeTxtU1dCyxXN/9wfyAv3V4sUZxgaPfcI?=
 =?us-ascii?Q?OBeSWB5uzsYwBbQ8wO0Esxr96vq5XM8ofUdNpVZNWyMElHs7pxeL68Evw7wD?=
 =?us-ascii?Q?G1DEEco6GDB/6Qjsm6zEtqK5kx5K8aht9ZgBoV5fFFAcDQHid3s+EoN8HFYt?=
 =?us-ascii?Q?JftG67IfZm6W1B9GzJJcucYKt8xWFXH9+ZqbBYYj8/atpDcesbp1Z8kRcUfV?=
 =?us-ascii?Q?4vT6a1lu2AYCqix+UCWoPuKlp9QWb+1LSIqjgWVcgBY1GRIk4SOsXstLIwZ+?=
 =?us-ascii?Q?e/nJDwiFJim+bmgi7BpmNlKMvVpx0LApOlcSd8LKHrj1rb9kYfxdKyR9vIdp?=
 =?us-ascii?Q?mR8dIcOzMzpRESmLUO0GIpPCNv4KJtbgcsCW5IUXvp1BZHV0PlNZQ2MlHtCA?=
 =?us-ascii?Q?nxpnu+uOI6wGj/gPE69LtofewadRXcWgk9hsMLhIPEHHJp3PZ2NgVxEOhiaP?=
 =?us-ascii?Q?+Vi6MRByKfgKt6e9oAGkXz7BCeQCdAUMICVRdfQpPeQW1+jfycWoQO3tEsrV?=
 =?us-ascii?Q?o0vx+ukpIRswd0W+oxo8gyqL4BjjzcOImiHmKDBipdOfyYoXdvsAWPub3UPY?=
 =?us-ascii?Q?AN20aMuill9yt78qjG/xbODg47Mj7TQyUx8BdlL/7yBRsLKBULMMDW83Zcw4?=
 =?us-ascii?Q?8G9robcElUVT82SVhOrCeIZmUxzwfjGIpfNI0KV1quAkSK7eAixMImrWheDh?=
 =?us-ascii?Q?lUKBvrN+ISDRosuJvamFUs/atJ3nb6zTDGJYoSe5+qqSPcI7OG+uCAG5ucxM?=
 =?us-ascii?Q?yZrFOWBD6LLBmcuv19upYrTMVeqpPkU6tpBxc66H+GKMa0yA0ykU4RSimcdI?=
 =?us-ascii?Q?tUQttrwiyRoLJTcLulTgZUEKbYQDOiADwJzyZYeir7UD13In8jthu9CR9MQp?=
 =?us-ascii?Q?61VAndOVS18OUmftGnU=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87a6526c-871b-4fa8-7674-08d9ecef5faf
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 23:45:09.8027
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2LkcPVj45R8EmvqE0HeDBuHCUKFL2uG50X2zxyfuk+L2k8woVsDK90kk3qqm+Ryi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0064
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 10, 2022 at 01:59:35PM -0500, Matthew Rosato wrote:

> OK, looking into this, thanks for the pointer...  Sounds to me like we then
> want to make the determination upfront and then ensure the right iommu
> domain ops are registered for the device sometime before creation, based
> upon the usecase -- general userspace: s390_iommu_ops (existing), kvm:
> s390_kvm_iommu_domain (new).

Yes, that is the idea. I expect there will be many types of these
special iommu domains. eg Intel has talked about directly using the
KVM CPU page tabe as the IOMMU page table.
 
> > When the special creation flow is triggered you'd just create one of
> > these with the proper ops already setup. >
> > We are imagining a special ioctl to create these things and each IOMMU
> > HW driver can supply a unique implementation suited to their HW
> > design.
> 
> But I haven't connected the dots on this part -- At the end of the day for
> this 'special creation flow' I need the kvm + starting point of the guest
> table + format before we let the new s390_kvm_iommu_domain start doing
> automatic map/unmap during RPCIT intercept -- This initial setup has to come
> from a special ioctl as you say, but where do you see it living?  I could
> certainly roll my own via a KVM ioctl or whatever, but it sounds like you're
> also referring to a general-purpose ioctl to encompass each of the different
> unique implementations, with this s390 kvm approach being one.

So, the ioctl will need, as input, a kvm FD and an iommufd FD, and
additional IOMMU driver specific data (format, starting, etc).

The kvm supplies the context for the RPCIT to be captured in

The result is the creation of an iommu_domain inside iommufd, done by
some iommu_ops->alloc_domain_xxxx() driver callback

Which FD has the ioctl it is a bit of an aesthetic choice, but I
predict that iommufd makes the most sense since an object is being
created inside iommfd.

This flow is very similar to the 'userspace page table' flow others
are looking at, but has the extra twist that a KVM FD is needed to supply
the CPU page table.

It may overlap nicely with the intel direction I mentioned. It is just
ugly layering wise that KVM is getting shoved into platform code and
uapis all over the place, but I suppose that is unavoidable. And the
required loose coupling with the kvm module means all kinds of
symbol_gets'etc :(

Jason


