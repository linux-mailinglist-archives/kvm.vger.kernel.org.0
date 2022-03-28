Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEC504E9F44
	for <lists+kvm@lfdr.de>; Mon, 28 Mar 2022 20:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245365AbiC1S7j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Mar 2022 14:59:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245363AbiC1S7i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Mar 2022 14:59:38 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2047.outbound.protection.outlook.com [40.107.244.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD54A6213D
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 11:57:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LKOHYBy6Cja6bRVb3/tBoBBKiE5SNwIfFPtFEnYBRmswoiW1z0iLLGT34mjIxkEfACUoskPNHTp9Jm198XrElVVwYTn/l6ToE2vPA8+fr+tuKfPeIMDNhpIN5qfD2fBTxUfhdHci8VcizZStd4g7fgGy4j4YThSTKbGBdrSfUxm3ESu+JkT2/eVZKlX8PzAbqW2i07gvXLaB1tDGHsnYo2WJFWg0JRbaMzA/svapmke4B/NBb9xTC8XShWfkCZSYhR/e0Ai505Il9XYuLTPmH+uffPTB0P1vvovNJYnHvyZPTqYQ4ZdyPwBZprUiBEqWGS/xilfUsq2XXj+7rhbgvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4FqQ/DiEb8A2HD7SG0fByPpjRbTZYdgZOaRryODKWak=;
 b=AZc9XGKt2LTKGExTcz55SBDzPzOaeK9Xa5m22bN7oL64TVmPmRMtq9TkhHIQzQ4KG2UzDjcJT1mPAQSwE8uwJC1DXsFyGU+6aPHP3TmWGCKmGKc5MLMxNuCdz6J+Ym4xi0AjBN5P0+3EpEFeD2BMO1Cji1b34h1/mNqBX3Qmnhm8a6UW6NxM1OCQ3Fm8qJOIxdHtg64LdwygoftFR3yZeI1IyxJ8jjMfbxmqOjpCRaLqbmVfSIkl4NI3P5VzuA3DstPGNk6tx0BkyuQtoYxNg8nKuaJO3gGZxGOSxBnOSW+yYk8cU9pMhkHBjN+vKKSiUun1K7InuP/f4Clf0FiAAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4FqQ/DiEb8A2HD7SG0fByPpjRbTZYdgZOaRryODKWak=;
 b=tHZsrt+vwAj2AOEWHR/2EBhXKzzDhu2zf4d3NWkbhs//J67FCquwXIf008VwK8tebZIR0ypUifkFFOGRfvCft4PTZ1PNvta6x91NlcvSOc8uWUdkp2MlsK5Y9SNg1j+y7Mlf3P0w/1JFCR4YTnPnQcuCbjVPIVNsrotNTABDT0XLQwjdkkpPuCX7UZM84MiDK88DApoN8HcoT0eikPtG/QJ6RVh/VFHqj/leIxDF119ybEKhfQDMWe0lD3n4bodQEtMUPL3Z2m/LPOdedKhFQRvtNu3EOL/Jr1HdGo2wSBuInHxsiGSh7ftbI6gTCCxjwZiDL1IpZp8dwsVnwO2DqQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MWHPR12MB1486.namprd12.prod.outlook.com (2603:10b6:301:10::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.18; Mon, 28 Mar
 2022 18:57:55 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c%6]) with mapi id 15.20.5102.023; Mon, 28 Mar 2022
 18:57:54 +0000
Date:   Mon, 28 Mar 2022 15:57:53 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [PATCH RFC 08/12] iommufd: IOCTLs for the io_pagetable
Message-ID: <20220328185753.GA1716663@nvidia.com>
References: <0-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <8-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <20220323131038.3b5cb95b.alex.williamson@redhat.com>
 <20220323193439.GS11336@nvidia.com>
 <20220323140446.097fd8cc.alex.williamson@redhat.com>
 <20220323203418.GT11336@nvidia.com>
 <20220323225438.GA1228113@nvidia.com>
 <BN9PR11MB5276EB80AFCC3003955A46248C199@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220324134622.GB1184709@nvidia.com>
 <20220328111723.24fa5118.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220328111723.24fa5118.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR22CA0005.namprd22.prod.outlook.com
 (2603:10b6:208:238::10) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c752834d-66bc-4c0b-9500-08da10ecdddb
X-MS-TrafficTypeDiagnostic: MWHPR12MB1486:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB14869F51D557FBDA5B7FD1CAC21D9@MWHPR12MB1486.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f9vaJH5cD1soWQVlQe4E8Q/uJ5whgG8rsr281aSbAINJNxdIEeaUzk9adW3oOoNlg3NZtxdZos3GAs9C//zrRJqbnxAzw8pLKYPYRRLpkopJjGJUVCxLYHGg9kDj7uvCYMUTXyeU2qbzICpdLMwCvspBc/n8pAGCc07xDgGO9Ygw+Jw7sWjKyXuI+7PVjkrFzXJBUjAAV/cjlhKaVZl2r73V8n5KgdE/uFsIIgU86OffNKUPxHuX/W87gJtF6j8Rdk5Xc04vlx5xIGkkdCf/r5d+10lbEiXqMGJLCpoQwFcsvVjNJ97d9DJfhGvlvoQ7NZ8oru5zItJlCuJpzHWwz9dYNc5susFUO+JPYJL+vQPc/Q3/MVDg0/6bfmpvahNip+L0f75x8xCZkZ9VVjlOkzRcyK+c4plYQpWMry2/cbkhvsDdlAlM3ynCgWWstLbW3NCzgibwdUd9rvT7v4k7QBJEW0E5RTinu7bOIF812Vb4h+Oi1i6ipls4+WvziQDq1O7SuY0iBhXNL9Uk3SeIjGBlWNzqjW05hcCi+rprJOsGj39Rzlpl+aXy6CURIu7JDAPPrZdFPD3Owzepa3R34xuAbUe1BoP9PzKD1/8EuKQfyZh35rJGqtBaWN+iTqNSfs6MIWvgq/A2hZLFZoBWaw+YY4mKjppqHqKH68fbZ/uDxS7AziPmZn5vHeUb2NRPzlINquFtzn2im9XScV3K1Hv/Fjsizz+6j+ODQ9GZPEI9N94mGYz1Z5blFPewd8ef
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(8676002)(66476007)(66556008)(6486002)(66946007)(38100700002)(6506007)(508600001)(45080400002)(966005)(86362001)(6916009)(316002)(83380400001)(8936002)(6512007)(2616005)(54906003)(26005)(1076003)(186003)(2906002)(36756003)(5660300002)(33656002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vc5sl6x9ohsIfheTWUGReGLrpayZrZu1qjQNbdX9jLu3/V8Ds+qHn2snd5cU?=
 =?us-ascii?Q?/NWk8ICh7X7Nh+Ec4zg9k52QH3u47joFEL2BHeZgZEhImeTel2igcmv31NIg?=
 =?us-ascii?Q?H8PGrtB25B2op/4IA+SBoNy6BA1qcgGzY0QkOF9jlZQGw6LGuKf1B+OKB+EE?=
 =?us-ascii?Q?J2Ct6EtsdC7DxvfX7iDv0YShYVQgCk1kqaviyBXtMTXA/YLBuP5QGwq6XNCh?=
 =?us-ascii?Q?8Z8MsMUNMpfK8jn5clW4toiTUJMK+x7SEkmXj6rv3iG2XHr8narAwePNnwEL?=
 =?us-ascii?Q?GfpbNlo7jKMCLQwrJ8GqVyI04yqyKefOv43RXgLFW9kmn/8jvBD0BUnpuQom?=
 =?us-ascii?Q?2aUBbC4xeHqpF86ewHlnNFrsOfzE0NAnNuTUFff5cKkGtkDOUWn2wr3DOw7d?=
 =?us-ascii?Q?oL3Xp2BxpROfATl72B6DwUQbGxIK4UWxcBYvB83QXpwKBdoEnAatrtX3znhV?=
 =?us-ascii?Q?xpmendDyte5qXllVx2fmjhqXVJqsAckEE6WywEiM7w0PC6+avatbIR9pGCEZ?=
 =?us-ascii?Q?XTI55TH3abFMLfH5whD/A6t2PdD1YqTLXobVku8lNpso9wmkujHNwS5B2TEW?=
 =?us-ascii?Q?HlEE3XiM3b4ynnn5uZ9PTXrolWObqMLPBoE6mOVvMGk44/EMRl1S8DaNic/X?=
 =?us-ascii?Q?CsdqEwcFlQ4z/tclGdmHQRVCfjeMts9sLYiqCxzwa8ER9mr0foFEovCkS+Bf?=
 =?us-ascii?Q?mau4p0v6qBPyAArVYGqzFUEgqs0X1oYqaLcOBZy7SlaCiGyDlU8GDIXgkJyW?=
 =?us-ascii?Q?A35A5tWmzk4wz+8dZXKdokQ5xCNk81ya+xX72X0QNF0+oi9KiHLVFzLZAicC?=
 =?us-ascii?Q?H41G1XiF/AeZ4nEZ4+ikKL+f4y/upvtsSL7a5p4OK0q7L7pHkw2YJhTwcynP?=
 =?us-ascii?Q?3259k8rlZtiB+gG9pHPKvmPZBXau/vHLrvC/JaA3Cq5F+PgbyikFtEQshgt6?=
 =?us-ascii?Q?TR7tYyKXHz1OB3tetO2B2n2oB5rrD0U2rGp9qK3pbFUce+APoUJfyfcMaxIa?=
 =?us-ascii?Q?39/tGKMUZRXpNhnVjuzQRd2dy3iNknmQChbzzrCOGmjrxk6TIMFgPF1J6XDI?=
 =?us-ascii?Q?wYvazbyzlbsRCUajXAWJZD9qA0RrgAn6N9QkK1AWohXE7/hZAfdiIZYy05kW?=
 =?us-ascii?Q?dHuHFtmZhDqCqRA5wQr1YtBcrLhmr2AWUQTqOVuMmISfrFYvkVhsbWh6Ybmz?=
 =?us-ascii?Q?9TheaSxr5ome/p5uApT++YZatkphy0DRlVkkfdZZSsiQiZbq2b/+beQ2cUqQ?=
 =?us-ascii?Q?4SheBRzUV7BGHss8p/gf6zoKYYBdRfQDR4+pKbx9NJ85qUflL77IJ0xjlrNE?=
 =?us-ascii?Q?qV8oHepIDwwyE46qBRSzHiR647ljF9Ne9q9gx7uJsYDzcehJ3gdi3xAcSGQU?=
 =?us-ascii?Q?O4DcBhGjwLZYLXhv1W0o8qjm6PCo1Zm8OtEfp1s9sqt2u+teTIbbU7Cl3q7z?=
 =?us-ascii?Q?TFT6gjPgXj95DjJR9PnwcPcG2cldFP/+o+U9PXwfHbBUf9shhhg5BMtJtHBh?=
 =?us-ascii?Q?Nk/U+5JAIQdEf1fb1kdiupBqlzfDGjGxfIkK0wq64v8WETjE0jnU/bEBgUwH?=
 =?us-ascii?Q?Oif30C5ONwHAoOP3UN10HEqVEDFEmH+z45RI6q3zuIL63WZCBgaQBax2MjHI?=
 =?us-ascii?Q?KPFLu4K9O00VMfwSDXVqqZn9VThSZBectknH+nNdAPKOhG+vB7HvKGODOS8I?=
 =?us-ascii?Q?Z5HZKaQ32og619Z3ZnPfz3ElVfhu2msJL5WekRZWu3UrFyOGAVpnMxN47YUc?=
 =?us-ascii?Q?6Am+eypR3A=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c752834d-66bc-4c0b-9500-08da10ecdddb
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2022 18:57:54.8546
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bluv/JpcVBIdQXHCBFDcPtKdNCOHceVsgP9SsPUvsfluvyw1feXeOMRtFblcmh+J
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1486
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 28, 2022 at 11:17:23AM -0600, Alex Williamson wrote:
> On Thu, 24 Mar 2022 10:46:22 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Thu, Mar 24, 2022 at 07:25:03AM +0000, Tian, Kevin wrote:
> > 
> > > Based on that here is a quick tweak of the force-snoop part (not compiled).  
> > 
> > I liked your previous idea better, that IOMMU_CAP_CACHE_COHERENCY
> > started out OK but got weird. So lets fix it back to the way it was.
> > 
> > How about this:
> > 
> > https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgithub.com%2Fjgunthorpe%2Flinux%2Fcommits%2Fintel_no_snoop&amp;data=04%7C01%7Cjgg%40nvidia.com%7C9d34426f1c1646af43a608da10ded6b5%7C43083d15727340c1b7db39efd9ccc17a%7C0%7C0%7C637840846514240225%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000&amp;sdata=%2ByHWyE8Yxcwxe8r8LoMQD9tPh5%2FZPaGfNsUkMlpRfWM%3D&amp;reserved=0
> > 
> > b11c19a4b34c2a iommu: Move the Intel no-snoop control off of IOMMU_CACHE
> > 5263947f9d5f36 vfio: Require that device support DMA cache coherence
> 
> I have some issues with the argument here:
> 
>   This will block device/platform/iommu combinations that do not
>   support cache coherent DMA - but these never worked anyhow as VFIO
>   did not expose any interface to perform the required cache
>   maintenance operations.
> 
> VFIO never intended to provide such operations, it only tried to make
> the coherence of the device visible to userspace such that it can
> perform operations via other means, for example via KVM.  The "never
> worked" statement here seems false.

VFIO is generic. I expect if DPDK connects to VFIO then it will work
properly. That is definitely not the case today when
dev_is_dma_coherent() is false. This is what the paragraph is talking
about.

Remember, x86 wires dev_is_dma_coherent() to true, so this above
remark is not related to anything about x86.

We don't have a way in VFIO to negotiate that 'vfio can only be used
with kvm' so I hope no cases like that really do exist :( Do you know
of any?

> Commit b11c19a4b34c2a also appears to be a behavioral change.  AIUI
> vfio_domain.enforce_cache_coherency would only be set on Intel VT-d
> where snoop-control is supported, this translates to KVM emulating
> coherency instructions everywhere except VT-d w/ snoop-control.

It seems so.

> My understanding of AMD-Vi is that no-snoop TLPs are always coherent, so
> this would trigger unnecessary wbinvd emulation on those platforms.  

I look in the AMD manual and it looks like it works the same as intel
with a dedicated IOPTE bit:

  #define IOMMU_PTE_FC (1ULL << 60)

https://www.amd.com/system/files/TechDocs/48882_IOMMU.pdf Pg 79:

 FC: Force Coherent. Software uses the FC bit in the PTE to indicate
 the source of the upstream coherent attribute state for an
 untranslated DMA transaction.1 = the IOMMU sets the coherent attribute
 state in the upstream request. 0 = the IOMMU passes on the coherent
 attribute state from the originating request. Device internal
 address/page table translations are considered "untranslated accesses"
 by IOMMU.The FC state is returned in the ATS response to the device
 endpoint via the state of the (N)oSnoop bit.

So, currently AMD and Intel have exactly the same HW feature with a
different kAPI..

I would say it is wrong that AMD creates kernel owned domains for the
DMA-API to use that do not support snoop.

> don't know if other archs need similar, but it seems we're changing
> polarity wrt no-snoop TLPs from "everyone is coherent except this case
> on Intel" to "everyone is non-coherent except this opposite case on
> Intel".

Yes. We should not assume no-snoop blocking is a HW feature without
explicit knowledge that it is.

From a kAPI compat perspective IOMMU_CAP_CACHE_COHERENCY
only has two impacts:
 - Only on x86 arch it controls kvm_arch_register_noncoherent_dma()
 - It triggers IOMMU_CACHE

If we look at the list of places where IOMMU_CAP_CACHE_COHERENCY is set:

 drivers/iommu/intel/iommu.c
   Must have IOMMU_CACHE set/clear to control no-snoop blocking

 drivers/iommu/amd/iommu.c
   Always sets its no-snoop block, inconsistent with Intel

 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
 drivers/iommu/arm/arm-smmu/arm-smmu.c
 drivers/iommu/arm/arm-smmu/qcom_iommu.c
   Must have IOMMU_CACHE set, ARM arch has no
   kvm_arch_register_noncoherent_dma()

   From what I could tell in the manuals and the prior discussion
   SMMU doesn't block no-snoop.

   ie ARM lies about IOMMU_CAP_CACHE_COHERENCY because it needs
   IOMM_CACHE set to work.

 drivers/iommu/fsl_pamu_domain.c
 drivers/iommu/s390-iommu.c
   Ignore IOMM_CACHE, arch has no kvm_arch_register_noncoherent_dma()

   No idea if the HW blocks no-snoop or not, but it doesn't matter.

So other than AMD, it is OK to change the sense and makes it clearer
for future driver authors what they are expected to do with this.

Thanks,
Jason
