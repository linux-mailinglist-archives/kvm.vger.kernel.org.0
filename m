Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 203EA6213D3
	for <lists+kvm@lfdr.de>; Tue,  8 Nov 2022 14:54:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234630AbiKHNyS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 08:54:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234688AbiKHNyL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 08:54:11 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2065.outbound.protection.outlook.com [40.107.102.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 374A125E1;
        Tue,  8 Nov 2022 05:54:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I77mmT98eImQG1uZW470CDe0C1yOxouXLpu5n6SRwx+0Q+kpRwEBhJgknzLfj5RjW2etIbJcR+dDq8wQ3Ixd7DMaKvkQMAVgCaaYMTI97jp7W9ekpYq4W1sAuO+6yntotP1Kfo/ZyoOQgW3YU/eSw0popwZ1l3SX2LTW8JpUzmYtOjaRpWV4zAvtMyjF8ZZ7DFwWb5TJcEvOif4JSIriVUdX6IDCZrGnQBLSc+1amsfgGYmYo6ZRUkfXTVfdMY0RASAxVOiJKk2NEBxiI9JP1vCUmhsndfdl1bXMp6m8cM9rgOtZFSAXNAQPYD3xmPHGyGUgpeXP01toO7kP8Dwskg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EO0YBAm+C2Yiu4kWcf7L1xxIeUf+gY3tYTAaA7Ry2Y0=;
 b=Fh9RZbIQFGuxsuaWzb0bBE4GAh2wdAoPVwjHFYAcbgQ7s/DE6d86yFBpousv8aa5bSC5zQhXov/UrUK4koSIu8IO3qqv+O/QKVELDuNXvvtf7CdAipC7YE5WmBcDzatroFRK7SLJKlVd1ZkjERZel8huEZRn8jWHc1YtjZKUPPGtkg/Cc2/aUYy7EbnxPaPtrFuQkvi1KDb+pn9N1xkqPypI3dEci3xDUfuFknvygu2ftTSwVgV2/aHjQRQiJFYZxcoG2ws9dmTdPq+c5nmd84djT8P0phH+Wa1knJAuys+tBR89EvawRc+rB5Md0GOj6rWROeM4Gli5jroZGIj6ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EO0YBAm+C2Yiu4kWcf7L1xxIeUf+gY3tYTAaA7Ry2Y0=;
 b=LV1fIJy7RCmRcQu/tflLxDXzlmQC8lmd5GyEcjQZXKDjLAhMybFCJHSZY1anz5OE+Lu+tSzn5xWbpoh7hvUsipGdhDTAIV28G3UGYhV0tg+ACZnrW5GSeYOYz2p24WWRJA98hwN4uq1wkXYwolQlKBiLt17CVNK/2ph0rxxsqOe6DwfT6ljY6AejxXxEVF9wg+hQo7SK/86ztE5yj7Cu6T4PNlagxoHAxs9BICJFY+Kdvtk3Cw9P0B5ueXSwYMFw0aBlcrrb7P6eQGQlH7afTle0R6LLY8gIpsGALLpPMKDumJ1V1lihxCKqceEVPkeCUOcNNV25tgLid3Opzkdxrw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BL1PR12MB5351.namprd12.prod.outlook.com (2603:10b6:208:317::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Tue, 8 Nov
 2022 13:54:08 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de%6]) with mapi id 15.20.5791.026; Tue, 8 Nov 2022
 13:54:08 +0000
Date:   Tue, 8 Nov 2022 09:54:06 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        linux-s390@vger.kernel.org, iommu@lists.linux.dev,
        Kevin Tian <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>
Subject: Re: S390 testing for IOMMUFD
Message-ID: <Y2pffsdWwnfjrTbv@nvidia.com>
References: <0-v4-0de2f6c78ed0+9d1-iommufd_jgg@nvidia.com>
 <Y2msLjrbvG5XPeNm@nvidia.com>
 <c32829c8-1259-7441-f6df-04f44a39ab2f@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c32829c8-1259-7441-f6df-04f44a39ab2f@linux.ibm.com>
X-ClientProxiedBy: MN2PR06CA0025.namprd06.prod.outlook.com
 (2603:10b6:208:23d::30) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BL1PR12MB5351:EE_
X-MS-Office365-Filtering-Correlation-Id: fbd78bab-175a-4609-119d-08dac190b4c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XAV54aTl5pI01q2ZNIZFyxq9/Oaew5i+eYTY4d9dv9saCxOBro91HFbOHZNrEhofLDeFfpuxFtIsCXpsaxg9Ba7k3TKc7ARX2h1M33xMoP4z7+j5sohLeop/jXgkw1R52ZSisPAjgQpZ1LhpZLzDvpiPjTsJ/Ob/gvqCl53uZ8IF/1n1Gj0AKQrMZOMtCJQvSFMOWN8ADj8xomGSbV/CIQqmT7KKycQLrSyZg8oeUYKOJBE47pSt+KaKvloDM6DJ40H3SjW4BnfxrQ6k10jS+lbwBeIztxRpcjr2q+86/95rs0GTodmVM44c5d9q5cDYdMkfJ82PTZTjEtmbpbPN/Dji8li1MkTiRsSdmJHG6fPvRsfYVOMwiwf/oQiYJodHxV3hIFuQ4d+thsD7p1io26tTbRcrryDY9NeRd5RJZcQzdNvpSsrioymiX4ZJpshWjsEr/1mNiAwqfX4WVnZO2iOVgMhHwnzUZKwZzrlCmlCq4XrrEb5eiq32mICY1UmbOqf67ccjdlQwI9MBWg/KuPMTsFaBPzbgxBMS7eOKe5O5Hm76Z8ewOYR20867s+nPYt6ufZpX+je/AXhwbnhNuKvKCxprDLDM4cQyQqtyCKK1DqhnfySvbk3wPppJGY38deBDmRlvyYojBM07IknFtNbR6Yt5jXBJxwY1dq+qiILP8Lx5ZfRQdvUmebtu4eVvhrIbXAO/O3V0m0vkfepWTdyTIH/lhl6NFPHtHfSzUkQVjc4NejxM7Ef+6AZP2iC/ndthhzAjHkLeEmzUCZycSA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(376002)(346002)(366004)(136003)(451199015)(66476007)(6512007)(83380400001)(186003)(2616005)(38100700002)(26005)(8936002)(7416002)(54906003)(2906002)(5660300002)(107886003)(6486002)(966005)(478600001)(6506007)(41300700001)(66556008)(8676002)(316002)(4326008)(6916009)(66946007)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jjOBWSwiVF5N32eOcwFZfGzfOpR+0NIA8Z4+2kS22mQMt5Fyri7PxIHjGj0j?=
 =?us-ascii?Q?PqntuWSNPzuGkN6DKhaysl1o74fMqVzKv1sxLuqgZHPSV70yATGq+veZIDAF?=
 =?us-ascii?Q?tyqIm7qsq0v5gvo0sdlR/FYG/mdpCCblAZg0QgZeCP7uP+Y9rmIRiMvFxVS2?=
 =?us-ascii?Q?PfFdDVCpUiB3qqi0+Fov9gfdxWLns0rjvMJF2jpiWiGb4HMq28m9aWBoczGQ?=
 =?us-ascii?Q?jYR0S3nY0lbn5xTZ5W2NY/OFYGADHFcMuHvtkEkxbQsdfm+jLzZz7njw8FAy?=
 =?us-ascii?Q?cM8WXZofyIk0RJWg95P/aV+A7dxL2i7TzVu2Wtfmlexr5VDCjtXqUp+GBL++?=
 =?us-ascii?Q?iYw4SQ2kUFiDUEfxSsknQZ9oF076QAaPIzlfHA2wT4/L60j/v3QeNMCEKtcZ?=
 =?us-ascii?Q?Fiagudk6LRr6UoXTu3q2xQJ63emlAhYEsqbTMPPP6kxijKlTygqRTYUAKLD9?=
 =?us-ascii?Q?XPHx9g+KzY+EhKL7cdWAK0usHRHqTKD3+U5UEaILuJRPokAxnhsO+pd4eodt?=
 =?us-ascii?Q?pbHNrLWXKFOenuydAg2zKk/1d+o/pJVQjn5uAO36zy46kMzT7hsnVQx9N45y?=
 =?us-ascii?Q?4BhpQ6U20VLAWZL6J1RiOMSozuHDDOec3mlUFLZ06LoHE56czQLQdIZjPCDy?=
 =?us-ascii?Q?Kuk8sAI/OP2bMAlTWWfxy0dEIDR0zb6JCJhOhMB+G3tmAueghrSRMPRNmUEN?=
 =?us-ascii?Q?YivzmSc+F90eHQ1aFPpKsiiP8S+xj+F3qY3DwGJbUmGAL0x/7VKFeJaU5G0q?=
 =?us-ascii?Q?qsLV/+RI++9fs9BKkXHXGfIt9w5TRwuMaX05ZiWu/iDieQwEwjPjvbYaVHUd?=
 =?us-ascii?Q?yBu+Rqdsnr9P9Rj2FW+bgZfu27mGBP3UXE9zai5GGzmMDnt4e7TF+rduQqSN?=
 =?us-ascii?Q?5FT5eXP31OncsILF+uC8nlKmLi186uzwjOllJ6idaq1aEKu46jJcTtBHCmea?=
 =?us-ascii?Q?PuQw9c+w4a108m7wXJXcxr2O2MWa37qlSjDrnGV9p1ttvzI7Nez122eFzius?=
 =?us-ascii?Q?MyJV2KV/aASHxProzoG5KyHzIMO1/kdoYZGakUH13q6Jmczd3htPxlEuCUfu?=
 =?us-ascii?Q?somTE16nNwWrntWY6bD8nv+fgcicV/fU+G9nMqyT1BZ/DjYJ1DChCNcRWqCy?=
 =?us-ascii?Q?9m2Jv7/Cc1WG3ZoU3O5/zrHxdybukQasrRUWPN16xZc/Y6WQXgtXLV6fa/F1?=
 =?us-ascii?Q?529zMKOKNbXUBd+DdVsxw+C/eATt6u87W3xVEDUBATm0Gp2juefQRqvbDhaI?=
 =?us-ascii?Q?s+jH7zy0FQrV4h9iJH5HbmbA1FoiilglHF0Jar/WjS1k8ufn5h8gw86MC0h+?=
 =?us-ascii?Q?Fn0DY+6ThsApPYrT2ODauf9kHL5Il4x+//4Q/eKfpYzU/kOS1dYGsbN4CD5Q?=
 =?us-ascii?Q?WMCOqncQAK0w4h6b6RSobHEA/flfq7Erdf69DX0fIv2UW+dUPR1CPfUzwm28?=
 =?us-ascii?Q?ctySNeQHpBiOFckkFY/DnNltgFKuXHWHXIPN8N+NowpXa50Ps277CEHauDn5?=
 =?us-ascii?Q?C3ET2dr4eeX1aDBg5DQIwZ27X4qwWWb3lGSHkRH6hJUX8MCBt2fYNyix5nl1?=
 =?us-ascii?Q?2BiKEZMcoQrNS52+HEM=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbd78bab-175a-4609-119d-08dac190b4c6
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2022 13:54:08.0083
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S+cpMKRV0ClZp2egkLOt6JxqkjbZ5o5RSWAfEPs+7XzruCmbPI5ughvdPg3QPEPG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5351
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 08, 2022 at 08:50:53AM -0500, Matthew Rosato wrote:

> FWIW, vfio-pci via s390 is working fine so far, though I'll put it
> through more paces over the next few weeks and report if I find
> anything.

OK great

> As far as mdev drivers...  
> 
> -ccw: Sounds like Eric is already aware there is an issue and is investigating (I see errors as well).
> 
> -ap: I see the exact same issue that Christian mentioned...  I'll talk to Tony & Jason about it.

A clue what is going wrong might get a quick realization on the
problem?

I'm guessing something in the vfio side more than the access 'pinning'
part?

> > If I recall there was some desire from the S390 platform team to start
> > building on iommufd to create some vIOMMU acceleration for S390
> > guests, this is a necessary first step.
> 
> There's probably something here for -ccw in the future, but you
> might be thinking of s390 vfio-pci e.g. to implement the in-kernel
> handling of nested mappings on s390 -- yep, work in in progress
> here, not ready for sharing yet but I have been most recently basing
> my work on top of the nesting series
> https://github.com/yiliu1765/iommufd/tree/iommufd-v6.0-rc3-nesting

The relation is that if vfio-pci wants to do the above then
vfio-ccw/ap will have to run on iommufd when used in the same VM as
vfio-pci.

So we need it to work :)

Jason
