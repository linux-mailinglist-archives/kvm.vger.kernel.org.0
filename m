Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E54804DA348
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 20:30:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351370AbiCOTbK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 15:31:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233489AbiCOTbJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 15:31:09 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam08on2052.outbound.protection.outlook.com [40.107.102.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 273BA50E33;
        Tue, 15 Mar 2022 12:29:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BG2DzL9Ucs6aTbCWB6wpY51q/GM9QuR0frNZODqnYI5YBbp8+BpY+L72MDruK+uGh9ZQTnK+KlAIlwuZR0XQXc7aBBmsuhcGx9uoP2ZHhBdNDoYEFZJiMnTyKyzT2z4/2oLFeb+LOmVuWQxkTuA+T2J/wpgrqKXRMJM0jjmH7/gd7w5q72oM/xeM7P7D5G+Eej5qGv/h4d/Ep4JyyuhRnCddnmphW+S+Tww3wkF5adR6u1ctb0v1ByUKRhYRfxkRh8ca5+tlNrKSlvOmYKt1r4yPI5DB9bg9Vpdbr+UtaPLh0pJyqPD6RoMzBrNGL4tCOn6uVgdzmxjVpRSWV9WSLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k651dwRkCdE9EfT/MWFMlQh7PbO9TuXlZ+sRuH11XQg=;
 b=V8UxNouL3DJcicgcrM2MaJug1x0yHpX2M9Kn6Xr6W64je8pbuVepwq4p3RZSg2IXAEFPjR7tWh6cRGld/yonJvIU9I21aCNq13gqBg1++pNcCC3CwEQzkDM5cUPUp2GK/zcbtqaRNuWfHeFrtF6KXPvzJ0anZpRNwjEt127z4q7MAs7BsCyM3ApDKlsHqRpSFqxxScpO/E+p3zR0ld1k30kGk38H3+Kymsn2xghLyY0iLg6WNf9lS3Zsf1ZYhd3MNwVn9q2oFuwkd8H6jmYX86+DMgObYLbQpPRVAEgaWf+Xbp/bHthqlWREUzyzIs5959WWO6AW6yyWEOlNokhGJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k651dwRkCdE9EfT/MWFMlQh7PbO9TuXlZ+sRuH11XQg=;
 b=rTRk+USe2tsj7keBhUGj9NV2qfZLAz2hcGgJLywZaHTyDDcvSIhfqGbU1l++fmUvKPGn5B4L72qoDFO6d/N3ns+EqWx5GAOdYDjqjs5xK0NMwTnUIKVzyhzmzWS2Q1dBAdhc+yIIh2H3DN7pZKdY2A/Yh8wFsUOVcusktHqen/DnPuCYviOgTr1gCnzcIX7/LeOlKSG66EoFDB8Uzr0VXpKI5oRl56UCraLeMreDo9AIgIe/w8ruWPaLjEwSo9gZhxTAlmYYh06hfAmFUPnQNHA90T83dd+vbmdTPNY0urJtwQZdICnOJvjBNYd+jUoQh22MjGx7HlDK17l9olf+WA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM5PR12MB2453.namprd12.prod.outlook.com (2603:10b6:4:b5::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.21; Tue, 15 Mar
 2022 19:29:53 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::51a0:4aee:2b4c:ca28]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::51a0:4aee:2b4c:ca28%4]) with mapi id 15.20.5061.029; Tue, 15 Mar 2022
 19:29:53 +0000
Date:   Tue, 15 Mar 2022 16:29:52 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        yuzenghui <yuzenghui@huawei.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: Re: iommufd(+vfio-compat) dirty tracking (Was: Re: [RFC v2 0/4]
 vfio/hisilicon: add acc live migration driver)
Message-ID: <20220315192952.GN11336@nvidia.com>
References: <8338fe24-04ab-130a-1324-ab8f8e14816d@oracle.com>
 <20220214140649.GC4160@nvidia.com>
 <6198d35c-f810-cab1-8b43-2f817de2c1ea@oracle.com>
 <20220215162133.GV4160@nvidia.com>
 <7db79281-e72a-29f8-7192-07b739a63897@oracle.com>
 <20220223010303.GK10061@nvidia.com>
 <e4dba6f8-7f5b-e0d5-8ea8-5588459816f7@oracle.com>
 <20220225204424.GA219866@nvidia.com>
 <30066724-b100-a14e-e3d8-092645298d8a@oracle.com>
 <8448d7fb-3808-c4e8-66cf-4a3184c24ec0@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8448d7fb-3808-c4e8-66cf-4a3184c24ec0@oracle.com>
X-ClientProxiedBy: MN2PR15CA0007.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::20) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a360dd74-9171-4ff1-8234-08da06ba2dcb
X-MS-TrafficTypeDiagnostic: DM5PR12MB2453:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB2453E0C66F9F88D1C8CCB041C2109@DM5PR12MB2453.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qUBi0lDy0P0eCHo4YFr2fpUc9tFKeFIhO4IKpDthFOr+PP9/hpWLUCtYhzhay7WG9hWSdUIuVHdKLyZXAZxCnjnvl8HQDaK7d++52N1wSyvEqJWa16/rGAR+dpG3fHmDFJcXvR2g0u3Oaylnrn0PIBP/gf70pU7w+Z8XWAUjAESilvOLnTR5HhdXshHosfarbHsyEHBCs5QskjupLVsfKdveHBSNg60mwmJWhXP2NDq27rPCW3ycaKcstxLAkd2JIjeaY8sdN5FlQhxEBoubd71ASRaJYfqQPmPnbRf2fN8RdTzi29QeUhF/65PdAlbWIVfK+B+8eOXj2CQPnCxv/YBhAyMDuehTiadjzcghx/GXaWjd7uPmA7unO6eKtKY4G7vxwkCfMQWADuTgf9juyRAi29dvdl1a9+hSD2uPeXJmX5nWLUqswJQWoqA6WMZ+pVxrY3pk0i3KcVFqVKxBHyxNtQhdmPBfexdjQAmHC6QmuBzcK43war7W5VirfqhqUxJ93T90YYYzUr8ydgr21w/9YQmv8klvFQVJD7TQqVa+v238YaR0FID1SIOkjC6kxrXAdSuL01csKP7ky3FakFWtl3gWUW50fTjzfEBJY/NF+xnC/HecE4yozspiC2OO2sofX3GWrWwtAO643OqgNrBFlQvYL8NPNWEHbnZIMhuiYiGBmBVKWDlG3BOT0EGx8pdc+0Kc5aUrJJCex3R2eg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(86362001)(6512007)(1076003)(508600001)(38100700002)(8676002)(4326008)(33656002)(66556008)(7416002)(6486002)(2616005)(66476007)(66946007)(316002)(6916009)(54906003)(36756003)(26005)(83380400001)(186003)(6506007)(53546011)(2906002)(8936002)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MIHd0AW3QXYmlLdMnHzrU9wtIxVD97dwGdOxurMRvA4fgl1v3aLUyK8mhS+E?=
 =?us-ascii?Q?P/x7HEyma9bLJioixIa9IXjVw2J7on1zkfiDGfRvtXBHocIh2VaMXYC/U5PE?=
 =?us-ascii?Q?mO9Urk7g0hALOH7iiCdsGI5MNURvFCQbVuKNF6yhelUOhbHGMmXOWKKHEQPH?=
 =?us-ascii?Q?dv1iev7CQUpp+SAylg5oCZySWfuzd8ei+rzEqM0SY8ON8lcnVMreyuAPa8Gj?=
 =?us-ascii?Q?SChqIvzvsx12IAmkx0MuN7q1wlXb5nVRlWVw4wfJxYcGWUk+lTcF3zRwt/86?=
 =?us-ascii?Q?uK5BxKwWBK10xl8Xc0vk6H7BgQRyXsl3JxdbhIKkvMsPnUUclHM5IZ/OqL5b?=
 =?us-ascii?Q?Hf0nrgipOICtjRYYuy3lWXAwFykimmMe8aZ1f5c5ZtqO2dn1CMaGjWOFv4fq?=
 =?us-ascii?Q?g6oSt4RAcpQ2KiTXJoWksOPPeU0ZAgdGsvhFZUNUZs8D5dUgSmnmqk37W0s7?=
 =?us-ascii?Q?XJdrNyXCtkPuhfzpLhpveP7bNaj2uH5g2furMfvJrIobqCyUhjkkQT8LQRX3?=
 =?us-ascii?Q?+7U+BCt+Vsc3jIO28gVVUp6QBj6QoxxxD7o15nHOh4tPizbXFlI2nwTAKXn8?=
 =?us-ascii?Q?JbUh4JEDpg3zBu5aaU3qjMBr/aCbHVh69PSq4h1UyeF/rS4uWjJAEWQjAzFc?=
 =?us-ascii?Q?UMyi2hSnGsm66Fiy7FgN5ybUqCY6LVN/erW8W+1RPR/3cPyQ5bhGwACuZQS4?=
 =?us-ascii?Q?ugKrOaBfE1VsChPaxVBLsBmNzMNlw82XWHolwlFUm3YMt8AQ+6ZT+dtSXfHS?=
 =?us-ascii?Q?Pm5bApcPEqcYK+GmmQwmx+BylFOt3ojSTkEH1Z3ukBXNNIsU+K7dfuu+tWl/?=
 =?us-ascii?Q?jORJxwJ027PbUo1g5qNv98yYN0pGrYJmVTd/xtrPT6MaXnxpm33A5nnw2Mku?=
 =?us-ascii?Q?WWbH/sIl8mKsg9ubLNjrNaYvEmKjwjfANJZT10n7h26ZrvptmYR/jpM3Za5u?=
 =?us-ascii?Q?Cg6KY8lhQx5oziyX+QQ9huFX7fH6p70blGD6B6/3oPF00SDtkjbxb+BJoZI/?=
 =?us-ascii?Q?4NcseZpBQ4h7uZSvqJvkFNOSddLD5DhGt/DvsJXq1/lmMLccGmGQ6KWaGOs6?=
 =?us-ascii?Q?HMyBvLfaO0hk0ewmfAjm4+JhE3n/qGwCmwJB5v/xY0S2Ez1Ge+tcNB9tIpt1?=
 =?us-ascii?Q?HmSYxKb4rDQTBdcGs5r83Pp6n7A3/bMYO5fd2SK6uLzI2gk4a+9Cr5BGHKLq?=
 =?us-ascii?Q?ZO1IP1jhuc9Du+hjPX5tA7h4Wsl03+Ht8nfm8hCzgl38QhCrmqjMz/zEo3+O?=
 =?us-ascii?Q?McPHQx5WEbTmWc0ZfTAQTd5kJZ2lUhwiorb1l6xWW3sRAwK9FPU1l5FQiuSK?=
 =?us-ascii?Q?3+iqm09iSgaDRlD7nNe7SXkqqRqZEvmSffJf+t9tIOXafqtLzq5GsuyhvmJr?=
 =?us-ascii?Q?l1eQ/AHjIU2CRwBvOkuuU2FILeQLEcjt1kQuQaP7p/EmhLnByq3Mn9ZWK//G?=
 =?us-ascii?Q?iZYxyH6I1I/3q0WGDgvIgPgfRdrMeuLq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a360dd74-9171-4ff1-8234-08da06ba2dcb
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2022 19:29:53.0361
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pmVLLWScVs9YBFf50L2k0sRg2oRAbQiqrpUrlCdYAB4nxBpKyyX6Nz8HERjqNYZ5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2453
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 11, 2022 at 01:51:32PM +0000, Joao Martins wrote:
> On 2/28/22 13:01, Joao Martins wrote:
> > On 2/25/22 20:44, Jason Gunthorpe wrote:
> >> On Fri, Feb 25, 2022 at 07:18:37PM +0000, Joao Martins wrote:
> >>> On 2/23/22 01:03, Jason Gunthorpe wrote:
> >>>> On Tue, Feb 22, 2022 at 11:55:55AM +0000, Joao Martins wrote:
> >>> I'll be simplifying the interface in the other type1 series I had and making it
> >>> a simple iommu_set_feature(domain, flag, value) behind an ioctl for iommufd that can
> >>> enable/disable over a domain. Perhaps same trick could be expanded to other
> >>> features to have a bit more control on what userspace is allowed to use. I think
> >>> this just needs to set/clear a feature bit in the domain, for VFIO or userspace
> >>> to have full control during the different stages of migration of dirty tracking.
> >>> In all of the IOMMU implementations/manuals I read it means setting a protection
> >>> domain descriptor flag: AMD is a 2-bit field in the DTE, on Intel likewise but on
> >>> the PASID table only for scalable-mode PTEs, on SMMUv3.2 there's an equivalent
> >>> (albeit past work had also it always-on).
> >>>
> >>> Provided the iommufd does /separately/ more finer granularity on what we can
> >>> do with page tables. Thus the VMM can demote/promote the ioptes to a lower page size
> >>> at will as separate operations, before and after migration respectivally. That logic
> >>> would probably be better to be in separate iommufd ioctls(), as that it's going to be
> >>> expensive.
> >>
> >> This all sounds right to me
> >>
> >> Questions I have:
> >>  - Do we need ranges for some reason? You mentioned ARM SMMU wants
> >>    ranges? how/what/why?
> >>
> > Ignore that. I got mislead by the implementation and when I read the SDM
> > I realized that the implementation was doing the same thing I was doing
> > i.e. enabling dirty-bit in the protection domain at start rather than
> > dynamic toggling. So ARM is similar to Intel/AMD in which you set CD.HD
> > bit in the context descriptor to enable dirty bits or the STE.S2HD in the
> > stream table entry for the stage2 equivalent. Nothing here is per-range
> > basis. And the ranges was only used by the implementation for the eager
> > splitting/merging of IO page table levels.
> > 
> >>  - What about the unmap and read dirty without races operation that
> >>    vfio has?
> >>
> > I am afraid that might need a new unmap iommu op that reads the dirty bit
> > after clearing the page table entry. It's marshalling the bits from
> > iopte into a bitmap as opposed to some logic added on top. As far as I
> > looked for AMD this isn't difficult to add, (same for Intel) it can
> > *I think* reuse all of the unmap code.
> > 
> 
> OK, made some progress.

Nice!

 
> It's a WIP (here be dragons!) and still missing things e.g. iommufd selftests,
> revising locking, bugs, and more -- works with my emulated qemu patches which
> is a good sign. But hopefully starts some sort of skeleton of what we were
> talking about in the above thread.

I'm a bit bogged with the coming merge window right now, but will have
more to say in a bit
 
> The bigger TODO, though is the equivalent UAPI for IOMMUFD; I started with
> the vfio-compat one as it was easier provided there's existing userspace to work
> with (Qemu). To be fair the API is not that "far" from what would be IOMMUFD onto
> steering the dirty tracking, read-clear the dirty bits, unmap and
> get dirty. 

I think this is fine to start experimenting with

> But as we discussed earlier, the one gap of VFIO dirty API is that
> it lacks controls for upgrading/downgrading area/IOPTE sizes which
> is where IOMMUFD would most likely shine. When that latter part is
> done we can probably adopt an eager-split approach inside
> vfio-compat.

I think the native API should be new ioctls that operate on the
hw_pagetable object to:
  - enable/disable dirty tracking 
  - read&clear a bitmap from a range
  - read&unmap a bitmap from a range
  - Manipulate IOPTE sizes

As you say it should not be much distance from the VFIO compat stuff

Most probably I would say to leave dirty tracking out of the type1 api
and compat for it. Maybe we can make some limited cases work back
compat, like the whole ioas supports iommu dirty tracking or
something..

Need to understand if it is wortwhile - remember to use any of this
you need a qemu that is updated to the v2 migration interface,
so there is little practical value in back compat to old qemu if we
expect qemu will use the native interface anyhow.

> Additionally I also sort of want to skeleton ARM and Intel to see how it looks.
> Some of the commits made notes of some of research I made, so *I think* the APIs
> introduced capture h/w semantics for all the three IOMMUs supporting dirty
> tracking.

I think the primitives are pretty basic, I'd be surprised if there is
something different :)

Though things to be thinking about are how does this work with nested
translation and other advanced features.

Thanks,
Jason
