Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2AE51DE87
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 19:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444260AbiEFSBc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 May 2022 14:01:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385054AbiEFSB2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 May 2022 14:01:28 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2055.outbound.protection.outlook.com [40.107.244.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B50D16D3B5
        for <kvm@vger.kernel.org>; Fri,  6 May 2022 10:57:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XIOM7KNb1oTvzJBGMBwgKRl6LvW5BzzUE0JEud/fJcm4v62VmaYWLCWLzQGM0xMZeJOcB12L+HExQvNiK2AWBp3ndYrnZdSmAzjmm5MZTPTlNheq6oYtWBpYnGeEhlF5KY62hiKFwckqsMeQMczX4cIwopGG2QZTTIWNeNmLGpG75vW1Y8jDp1ZtRUDXlqqKEtP1hdDi81XO/6mKbTRWpHNRwbG2uHFuyM4i7nFsg0fi6w5etvECYI7mUv9S8OAbkETe4s9LQ7du9gVrp7mgaiX/2t5mJB3WTgg2NaepBYlfalYUJp18eyLFhNkhIE3sdgup9DBqnBsk/8VjjjgVUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GzTHn+NvVX0em830ES65KrSP6Ii451kV/piPtQyfWCo=;
 b=oLUzIyppcX/zkICuXW8KPp3Bl/qPZvWrN+rSN+Ae5v/I7Th5zUTCtqL24CgL78v13A3GQIqb70uLhx20112viZFwq330UP+xG99V5bE7vgM05hv/yO6cfQrB9ka+za2wgiWZ+z9cw+F8iInfR35g6RJibQHpkOOiK8WOg8TuSvZ35qZs0WvRVC9bjuc1zHRWCohgbvLNurTYHZ4kIjjt47Fs5NCNzwcIRdck9UlY32FiYSWMX8L4+mhFhNMH9tm8M8pNwWZa6wzhEibZ8gJoAefqN7Y+V0cmyswnnz7Rv4hDKLwEMqZtbbWhSuBQVzmop6Blv4qBLUPnJ+BMTzyx8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GzTHn+NvVX0em830ES65KrSP6Ii451kV/piPtQyfWCo=;
 b=D1dWf2pl9Oa5P75K3P3WrHKxtYfRtFng71OTu/leUARdCsAvOOddDreDqN3Cer4PnmD2myZsqAUtCsWQTSj+kSJEOFkN+6R2XK0y59B9wLMAtNNLrqcWnvwGF+Pwbq4bRKQydLXx8iNdKdfFFR3+5SM3ULFgd3LWN4wJKyVDu8/Yvhux3Br5e3TcmAFdApRtmCZ4AW3PT2kmDDHWUg0CCWLkji6k7t1cG0bS4wpJcEdfruPRcnwZNsWHWrKA28Ha5oT9txFbNVmCOGCkHWcOnpSKHdd2gkUrVcm2bv+A6qNlbZPJEx9p1RWDx3zUIRGeFLA1dT9wiPNpBlTwPHq+8w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM5PR1201MB2523.namprd12.prod.outlook.com (2603:10b6:3:e8::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.27; Fri, 6 May
 2022 17:57:43 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5206.028; Fri, 6 May 2022
 17:57:43 +0000
Date:   Fri, 6 May 2022 14:57:41 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Longfang Liu <liulongfang@huawei.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Abhishek Sahu <abhsahu@nvidia.com>,
        Kirti Wankhede <kwankhede@nvidia.com>
Subject: Re: [PATCH v4 1/2] vfio/pci: Have all VFIO PCI drivers store the
 vfio_pci_core_device in drvdata
Message-ID: <20220506175741.GG49344@nvidia.com>
References: <0-v4-c841817a0349+8f-vfio_get_from_dev_jgg@nvidia.com>
 <1-v4-c841817a0349+8f-vfio_get_from_dev_jgg@nvidia.com>
 <20220506094253.38a16c1b.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220506094253.38a16c1b.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1PR13CA0344.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::19) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7be3fe72-8979-417e-a514-08da2f89eb3a
X-MS-TrafficTypeDiagnostic: DM5PR1201MB2523:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1201MB252316B45B813473DF73C1DDC2C59@DM5PR1201MB2523.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EoEboE+NmsuXcrdwyPi0CjeAov/M7Q4gyP2fkwdcpbDjgG8R3Nzf6BikGJDty3ItctXafwap8ouyJOlTtOQ6RiQMNjbJKuVArGZu1AYwY3LgPXhahsGcJtxGy/vflIV0xmiScM/zCZLCWLfu7fBNDqwXHHhGt16kuvnKuJtYSutPoPOKvxbnc6keYlx/FuUlWnrRd8fJS3WPqDtBjXYl1PhLWk5ueNZUdRvvzMe+eW0gv4B3wKS7kDd7DhNX9rY8JZkW+DaYNDp2Y0S4frZeHTGtMs9FLsigWiD3BpM6QRk0PWN5ouMU56sMDzQxBm8apubmgDS58FRbR47zoHRBJgIhHvmqSdoTTGKQD0LFMhV6YWR8KTLx8qj0fsORVXviStnOciSZvq9d6FMcU94gZNB7gLHJMadHQVigf+qbs5MeoDTs/YALygKqfQR1AubIGdlxJgR9PWRtPemtHa+4OYSr9gZ8F5jQFYow08mNyJxMvRUisaWrHiHR+V/YMDTFj8PvbMtHKeO71zt6YMhgmT1kNKWlRLJwWdUTjjg1jVT8e6DwKH09pmB5QQZN44RGA/mNNeM6JgmnX4wyWJbBCsl0qrhX1Tm8UuPszZEQAgZkRcxeyZwYTXzD+l8kRdBuQ8nUNQ0IMEzLiPxvqceooQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(4326008)(66476007)(8676002)(508600001)(66946007)(66556008)(6506007)(36756003)(5660300002)(6512007)(86362001)(54906003)(4744005)(33656002)(186003)(8936002)(2906002)(316002)(107886003)(6486002)(2616005)(38100700002)(1076003)(26005)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IFxXFs0ozwCffk1zojXwcFAALNFXGNwhtBTo9uacNYOiutZZ1CoiJBQ/R4hX?=
 =?us-ascii?Q?venej0a4xqPCU7Sa15be/dvof503cjgPr2SoQMHkO2uOajyOvrLDWOmJ/OJK?=
 =?us-ascii?Q?aCT4H0TU5NmQEaJ+lrYWqGwA66fwUFeJSLDGdheqqWPdfco+yucxLorVOFqV?=
 =?us-ascii?Q?aZJV7GngsLfioq7CZ/e8JjXSPWkLUQxJfFkbZSg3g3wasWARh4OL0k6RZH0I?=
 =?us-ascii?Q?uhhdHBLN9LheHl+9YVlv3Cnm9S3TcvFTC1sNXODp91nAOVTC965JQ4+ii2Gc?=
 =?us-ascii?Q?Cx2cEaTguq9wPkRt/WnKeoznQ2J9Ve8iDHPGgQn8YFYhIzjBISup65earx6s?=
 =?us-ascii?Q?3DunJCf8g0F5bxRMlGn53q5KBI0FafrwkZz4GXZRmIk8Px6pWeurfPeLM/En?=
 =?us-ascii?Q?UzG4Xi0xpMkXMFXGSICsMjcIN3WDkv9iQrKdJc9TC25IMnEsGe0dZWhdOcOV?=
 =?us-ascii?Q?fHivNo/BRcYXgV5c317GhlMyDbAZOQP3ZGYX2Cg5Hhuzq6Yuqu+UApsOP+AZ?=
 =?us-ascii?Q?r9RD6Li4wC5TnaUUMccMBkf64vGSyU/3GdBuhTxbtsz9/QX1PfHEJ4LZDY4+?=
 =?us-ascii?Q?iBbrAldqHp9KGxVUl4uv2LmCvyEUtlDID9TrRSK+rlVnqTlGvp5Jw95KtDB+?=
 =?us-ascii?Q?y46D3O4OH6gNb3LS2+7kK4yc8f8OuZCiSExpmHiZ7CG81s2tbulYf8dSo11t?=
 =?us-ascii?Q?aAyghTLowt4QdZ+Fwr4X7KhUwZK7xsETE4HW9veK9fHKnMgUY+tNcopC8GJf?=
 =?us-ascii?Q?hrN4nl8A71rz8/dYftbVbFPJgckOBmFHtJSUjCCjUdqJ/NlJt/pHohz1+wOe?=
 =?us-ascii?Q?o/a45rAaPeKm4ljjTfXTkf+/j9FM7ZCFiGjWYCcoOsQeKi6RwlTbcnEclsv5?=
 =?us-ascii?Q?LXSse8eMkhQMugWw4qnQPzxDiNE+kkBoFrQm91dr++ur+fS8Nnv1gzuLSUrb?=
 =?us-ascii?Q?unXKaPOEyGJDI+4Y7VZmofDQzP5QXCukD5IhM7xskSbj8B5AHv/ANzJW6sVN?=
 =?us-ascii?Q?y5BmH3wJ1ZNOs/Fmeqgd3cKAVY/gWOaStctA2nDOYP7zP/lllbemC8vn5hrO?=
 =?us-ascii?Q?2RsxQeraioSNL7xg5fRNVGb/dO9K+OjADyUf1ArS4l01AUK16ltFrHdQZm8x?=
 =?us-ascii?Q?4UNPc6yAqWu6VzP6FQolhTtK2ey8bmo4K1lUWvSeanUCQE3KA1+P/TGNCMNj?=
 =?us-ascii?Q?YnlLwqoFxfavQRcwjAcsbFnLlEFsVb624RH+4XYtqOIOjri+RHXq7MIh7DPo?=
 =?us-ascii?Q?+71XAXkAkHSJE1Tz3X0oNjBqz7puXOVP4Rfga/TIVdXcGV08ZN6C2s94aoTr?=
 =?us-ascii?Q?kgX11PDWiCgVQCoEjU89n43ZilAiMNvfGV08YmowbaPnRz7dxzfHisIBEzwt?=
 =?us-ascii?Q?P0EDl4o5GzqK3u/6dSewynJtLv5ZRTLpC/LNcCZSt1u4sZY//x9WSbCKJHH5?=
 =?us-ascii?Q?SH9u81yGftEPrA1arqV/6pt7uVMKQyhKbs6N76x4Kgqid5/rYbj/DTwNxmtK?=
 =?us-ascii?Q?9unMEDDR3X6Qhm3gMbXvXy4ZQURjFXEEBKdv4O7hjpmYnS4dVtlgSbWWKPTa?=
 =?us-ascii?Q?VzVckcIcKmuCu+XFtdku7EGpO8Dw3YRNtSeWr6g5OqRtL7l7giuvih8dtf3e?=
 =?us-ascii?Q?dFc9VUxl2aRAcRB2Tr1zPxb1l9qJF8t52BrAsjtffIYNbt2KSDDeQFdEZF9d?=
 =?us-ascii?Q?cGEzBsErOLO0iAt16fQrpH1g/Enx4TQuCdA+491lFCaFd6PTC3Gj9pwBiHdB?=
 =?us-ascii?Q?+611+X+OQw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7be3fe72-8979-417e-a514-08da2f89eb3a
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 May 2022 17:57:43.1266
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /EPw6P/xtmHXB2lEUg7bo+sjwI97lQ9i/MOGVQ2Jr28R8JcwujUgIRE6Y87q3n2G
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB2523
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 06, 2022 at 09:42:53AM -0600, Alex Williamson wrote:
> On Thu,  5 May 2022 20:21:39 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > Having a consistent pointer in the drvdata will allow the next patch to
> > make use of the drvdata from some of the core code helpers.
> > 
> > Use a WARN_ON inside vfio_pci_core_enable() to detect drivers that miss
> > this.
> 
> Stale comment, I'll
> 
> s/vfio_pci_core_enable/vfio_pci_core_register_device/
> 
> on commit.  Looks ok otherwise.  Thanks,

Yes, thanks

Jason
