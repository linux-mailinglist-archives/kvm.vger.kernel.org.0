Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F29E5223B0
	for <lists+kvm@lfdr.de>; Tue, 10 May 2022 20:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239806AbiEJSTX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 14:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348775AbiEJSS7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 14:18:59 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2068.outbound.protection.outlook.com [40.107.236.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBF8A27D004
        for <kvm@vger.kernel.org>; Tue, 10 May 2022 11:13:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mwuO6hRLtmmuNjRhUhuLo9ijk7bf0vpFXPOpnlHU5rA+tr+R36/A4eT4ceB+4Rno3KbVKcLRINX08ZxKg3mAfXt2cL+GnuwByGnfneAvAUqsjMmPo6/XxOoFqwZN7R/wSEUQyCB32lOcxsg0iQS/ze3vBupJ78XXbwrYPCHRVRFnz5NnHWYl36WMm92OeXwN5yoQQyGjiFnXJxtFGTtLWMDBYxafKkZMFN7euBos4ztm8qStDqtVHBIYHWoXHfJAFcJfa0wNQVOSUzQm/Y254chq2iXrluAtZOzu+va5IwXgyHEeS629lR75cPEXUVitt6hiWvvyGvf2AudT2Wb9vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U7eRvo/XILVo+lvc2g7nq0/hkgOFz/tFooN1Tm6vGmo=;
 b=h0aF6THrCKngPZOZzdaqJAROhth5TK6hMHLf6LKw9ufAgxDs/a48RC4ygh9miFqGxptXLFeov2r0bs+i4kzpdUhUDG2AJbQ9tlyVIXAdj8CMrjg2rgPsEVty87rznNkkJfw2Zk74EYcHvecVrtzwRhmWAr5Pskxg8EWKnXLtNlM/iFNO/FmQkf1PuM0ITabso79rVdy5T/zCGywEnwrMCkHuDrH0AsSZv/U3QdMhF+w6S/+jqGAuAPJQ3mols4MBxmr7hng2bSdv+6WVH+DR2vbBi522eq6xsS5sxyezYku96osjRM/MNNI18AhuocQvZd+Fk5N7yZXbr1DNMkPbxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U7eRvo/XILVo+lvc2g7nq0/hkgOFz/tFooN1Tm6vGmo=;
 b=dtbo+LaS8/t0CXay+WJAb217klDP3Oav+i8MnE0JuF2DhPECxSNGtBOcE0MRgWhhHIIBpCDZMltu9EL1vkYtM4+VkTXtNwbR1oVOyJ5iBHJGLsQVYQpcyDEPjKoTYrzLVdEGr9Y/VmduxZ5mphOF7ggSJELkUKDzte3MA9Bv6stbY7k+MrF1EjpV8dGrWLgR6q7rPc/6TMm4di14wkZ9W7/L4uSwEcl/xN9wNIP3nOLd5H2GxP1bfNdDN4eNXJmrLOeudl5bXwh4tjZtAATqSRSMvpuh5dM7lv2A3bZ0nWXNdV2a7EMrzk09gGt7BwcGjh1gHLfx8ETwV10V2EXp4Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BYAPR12MB3143.namprd12.prod.outlook.com (2603:10b6:a03:a8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Tue, 10 May
 2022 18:13:28 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%5]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 18:13:28 +0000
Date:   Tue, 10 May 2022 15:13:27 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Will Deacon <will@kernel.org>,
        Eric Auger <eric.auger@redhat.com>,
        Vivek Kumar Gautam <Vivek.Gautam@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: Re: [PATCH] vfio: Remove VFIO_TYPE1_NESTING_IOMMU
Message-ID: <20220510181327.GM49344@nvidia.com>
References: <0-v1-0093c9b0e345+19-vfio_no_nesting_jgg@nvidia.com>
 <0e2f7cb8-f0d9-8209-6bc2-ca87fff57f1f@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e2f7cb8-f0d9-8209-6bc2-ca87fff57f1f@arm.com>
X-ClientProxiedBy: BL1PR13CA0302.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::7) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bab49c90-c823-44db-7bfb-08da32b0c870
X-MS-TrafficTypeDiagnostic: BYAPR12MB3143:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB314335C3BC61500C45E0EDD2C2C99@BYAPR12MB3143.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: glEFJyirvKfKdKCxZaZiywigjgRCe0CqPECtJaztKbrgxnatYb2Y/YbwF/PutcEqu3qtoiFIPNGEHEEmIg8n25YVEsMCNSdNDzZ0t9Wl7Rlpx1oG7lNGyNZG1payM+4Zm0X5rb4rqiSMfPF8tCboFyYtBTzzWisN2y2C9vXNSTJYSxkH+DjOnPuCozS5QCkL3cfhzyXjtWQERpJAeHqIruN/pk/gIz5zizF8RX9KpTGnp0iTfBYi7083rKnwQlGTzY9dnrOdV58vHLO+WeOBybkG6weLY8z0pof7PS0IqDmPRV1q84AdLtXMG0RdU/Ddl+6U1ohRBuRXXWsbNihT2/+7JLREeOVV0rhSDUh73bI8lnJ117KLYWg9WcZu9teSKPSo4sBoKj1BaIX6++liwWNFZ5GfqNykw3TYX/rmE57SI/+UHLliH7BHQKNCDomajYqOO0o3jMmzIKPTed4DSZZm7cn1Z0e5Z7OC8fQkkZZmx5z08zfwmyZT74USJiA7IKOAGbkn0LsJqAPQT8XiW1LztwmcdWUL2d6HDiG0GwMZKX1+5HKceKgZwmfAIg3KB16H4JvuYeOC/Xeil2F9gdGViKIAbQO3ZROa2x+jmxse6YqoRGJwdTmkyjBPUYU9O6uysc+oN4nHAIP3yHZFoO+utwxRXetai3TlSK+zLSsRIiraGy/tKSF10WJ2+hueDjrYIpzCo37GE4JoTutO6V8wJwH2PNZ1ZxYWHFJw7xo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(53546011)(86362001)(6506007)(38100700002)(6512007)(83380400001)(26005)(186003)(2616005)(1076003)(8936002)(66556008)(66476007)(8676002)(316002)(4326008)(33656002)(66946007)(36756003)(7416002)(5660300002)(2906002)(508600001)(54906003)(966005)(6486002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4EwGokh8Xiv6+cAwRk/RaJbTDcB2yK3zG4Pga9oKeyI35UA1rjeyo5HlU0oC?=
 =?us-ascii?Q?mD0AUPmWlXeDqvyEsMIIoZg5oTgLpdWrpkdfyjUoCIihRQJOWS76kWqML0Wb?=
 =?us-ascii?Q?q9ZoeFL7XEU8uq3E544FJ4JHuvcVmrI0iXrV3ufW4j6dHZOjPiFpe75SLfvA?=
 =?us-ascii?Q?u+gKwXN2S+s2fMupFR2eHN6TBl32Dg7dImF8cufUaT9OZiyydXxx1gVgWr9h?=
 =?us-ascii?Q?jvUSK0P622ytNPi/fAL8qCGMVyhUzZ/deqbaVm7WN7Z4i9f6DV0KZQRK/NbF?=
 =?us-ascii?Q?FlJhfhpUFjsnIpfImhuxHZXSYxwXzCax9KVvI7yE3GK89YWT3kULed4Y5s0i?=
 =?us-ascii?Q?lkXCJ3ubWEP1CYuGwjGS+B6mH0VMjllIxQOkdjYtRn2VpIeygZjXm8W6PAtJ?=
 =?us-ascii?Q?opAS2ZWty+j9qu8FQ6rqFbH4rUNl4i6T72gmZlCxTgLL9uMa22dYBJSqRNhi?=
 =?us-ascii?Q?ZETkKD/k2TpOg6hB819nff6A7W1KC0lpUyqN8o9C9JMwmnHqbkA2Q0oJ1Nux?=
 =?us-ascii?Q?f6XojiS3oTPCPqdJRgCl6uiWw7NZe2nsKPYyyJpGbBoJCgv2p3fRv+wVF4eE?=
 =?us-ascii?Q?wF3V/wy2MMMxfr+LbXV8AC3uEsFtt5cOfnRqkfARxvUF3VbE8y4dObkZOAR1?=
 =?us-ascii?Q?4VZptn7wGaH9BBacO8lXuIBCd9f5mbwalrx3KXNCnr2X+qcMDKf6ioQ9fxHr?=
 =?us-ascii?Q?AZVJmWCIZ6dy1VW4kn/ZNQjG6h0AnYSsfmyzNcHfNbJ1YIg+/71FnNPaguxc?=
 =?us-ascii?Q?SvCCLHEXOmIJC0ZEJIYq1TeFIQtoaIW1pd0xosqFQWT9Jy1DcEeUCpr0TiGP?=
 =?us-ascii?Q?He1V8S8vowV0ab9N7EJo8I4N0MJVcZm8DleaSbO+wH/ORqzlZx1GKUESLSQq?=
 =?us-ascii?Q?cryD6EvLTBg+Pr/jpTsAQ5c8elRPrpNpHmk3I6D81QtWB3rHRi6cBhMGn4ds?=
 =?us-ascii?Q?deywZtdyi+Tkx9ujW65NXKvCsvPTTucAz/HZkBE2e89MWsboBBbkmMBlg9bm?=
 =?us-ascii?Q?IMlDLgvkl2DkK4Y7qxhmCfktMcnGdnHn6dCf10JIltYrisbwKjPThHwbH4G9?=
 =?us-ascii?Q?fExuTn+hdAvoXWyTLaT63OxG3wjOl/OfZMgnTU8SVfw0sMmd6RYb0ACFCkDU?=
 =?us-ascii?Q?nLQWSgRwYqNuneroBI1xA/yNZ4H8D11+QeAE28bCrqAlXrK00++maYbh7Gn3?=
 =?us-ascii?Q?yDVDAhcOn/WFl7EM6uO2gPicbUNIqbCPX4X8Ko7q/9cD+rnUqNk1UeTi6Wo0?=
 =?us-ascii?Q?ubTD02lgwCuAmOEhoVCDN+IQuaVzrxDGPZQ1HYHMh5WYEvE4hPAXRfscv0pg?=
 =?us-ascii?Q?BrRlaBS8XYytmNEz5V0i1/kUkE7V5FjErP6SUgOXJQ4VHPuoeERyNWetCQ+X?=
 =?us-ascii?Q?BaTFf4q6OBsSPh6Fjle4JSWgQYb+4SXBbV83p4zRYe1393HLftq8tdQaKB+N?=
 =?us-ascii?Q?GpJiA4G81bRQE0uLagifoZk1WA/LeICnFYiuu8UVqyAUCMXBrZDdTnb+TpIJ?=
 =?us-ascii?Q?HT1+8o3tDEXc4pBHI2QIJiP++X9IGEFa2v+JH7vO1JkTRAz8Gg9NRFTeAVa8?=
 =?us-ascii?Q?vCMw7dmiRF0zof4d9d9NW+l1Mf+zAAv0WAv+DxqbUgYPh4Zr/GdNkLgz/+Bw?=
 =?us-ascii?Q?kCHRySgS/JoDVUH0mp5127AEmUa/EXdNI6cAoU4aaxaPNaWnkwAIDdPd37pr?=
 =?us-ascii?Q?c+UqTASJViQgsYHW0zXnzhcY0bT+LsvESUYQF3LHYvPt8GIn9utes0d2kxO+?=
 =?us-ascii?Q?7AL7FdpuNw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bab49c90-c823-44db-7bfb-08da32b0c870
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2022 18:13:28.5887
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NHP648lJTXagN6AXqFsBY3QCm55dXlk+R4yslG5YQf7ZijQvM6YARXkH0SuajDDT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3143
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 10, 2022 at 06:52:06PM +0100, Robin Murphy wrote:
> On 2022-05-10 17:55, Jason Gunthorpe via iommu wrote:
> > This control causes the ARM SMMU drivers to choose a stage 2
> > implementation for the IO pagetable (vs the stage 1 usual default),
> > however this choice has no visible impact to the VFIO user. Further qemu
> > never implemented this and no other userspace user is known.
> > 
> > The original description in commit f5c9ecebaf2a ("vfio/iommu_type1: add
> > new VFIO_TYPE1_NESTING_IOMMU IOMMU type") suggested this was to "provide
> > SMMU translation services to the guest operating system" however the rest
> > of the API to set the guest table pointer for the stage 1 was never
> > completed, or at least never upstreamed, rendering this part useless dead
> > code.
> > 
> > Since the current patches to enable nested translation, aka userspace page
> > tables, rely on iommufd and will not use the enable_nesting()
> > iommu_domain_op, remove this infrastructure. However, don't cut too deep
> > into the SMMU drivers for now expecting the iommufd work to pick it up -
> > we still need to create S2 IO page tables.
> > 
> > Remove VFIO_TYPE1_NESTING_IOMMU and everything under it including the
> > enable_nesting iommu_domain_op.
> > 
> > Just in-case there is some userspace using this continue to treat
> > requesting it as a NOP, but do not advertise support any more.
> 
> I assume the nested translation/guest SVA patches that Eric and Vivek were
> working on pre-IOMMUFD made use of this, and given that they got quite far
> along, I wouldn't be too surprised if some eager cloud vendors might have
> even deployed something based on the patches off the list. 

With upstream there is no way to make use of this flag, if someone is
using it they have other out of tree kernel, vfio, kvm and qemu
patches to make it all work.

You can see how much is still needed in Eric's tree:

https://github.com/eauger/linux/commits/v5.15-rc7-nested-v16

> I can't help feeling a little wary about removing this until IOMMUFD
> can actually offer a functional replacement - is it in the way of
> anything upcoming?

From an upstream perspective if someone has a patched kernel to
complete the feature, then they can patch this part in as well, we
should not carry dead code like this in the kernel and in the uapi.

It is not directly in the way, but this needs to get done at some
point, I'd rather just get it out of the way.

Thanks,
Jason
