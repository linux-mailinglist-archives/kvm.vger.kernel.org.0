Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 217A24B319D
	for <lists+kvm@lfdr.de>; Sat, 12 Feb 2022 01:01:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354301AbiBLABZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Feb 2022 19:01:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242360AbiBLABX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Feb 2022 19:01:23 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2068.outbound.protection.outlook.com [40.107.212.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8561D62;
        Fri, 11 Feb 2022 16:01:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oCv1N+TXH8fAMw2rVu3rgLy+r4D2GPkJj/kY1PVRifAKAswtGXsqFnqtP4bq9f3xaBcMfMbcDawoFvNxDtTk5eyYjZVR3iCHsq8xMPaW7p4TLfZ1Nk+hGI+2p1KFdhsm/+pFhXsmW6451JyQMvBP1NRMZyQG+AVhOXKyAWtqTCxUPnADVDkynWPZ8U4xHHIS+Vs6Cl2wH/QCUwdbECE6fcjT2yncoetN6lUT4vYkOX984229+aqAxh1l5KKXRgHYTlNYpEowH85Z+4cvMxY1/mNQrZfaDebf6f+agtxTDQmDq2r08oMX+NDnbG6ADmcUzYGR9eQnspOMqhTEoa946w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t/LwCwoe+uZK3i/Rxh1g8VkaHNVQiLWOuoHvRDeQsVQ=;
 b=Jlh+HWCvvHfIDI2RhXiePcY1OwacDNCY6Rd0XHVEd40QcIY0Hpv4FLqmVRLO4wM8AX2lgposx6cNX+nJgIf2VqxQMvaJPqgE/9f2P66BCua3c6RT9z4XUIw/ffguZKt7/KXJhm2gjOvHd6ITgOl/6yWKIypvLW8MP9x9OzSOoO1n6G1tJ1zqx0fdhFT/cBsMQLO5cRkcmt2x0TiKdyk6PSk4b45r8nk1EiwKASdTM5NGHRZcoNQhNvFl4IFiBv7VQTberpr9X2Zl75jrNUDX93EyKnyHPIHrVl/PAyQGnLgRps0hcS6L47wPyHvrz8UcnYoqhkzju/Cvr21pcRKnkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t/LwCwoe+uZK3i/Rxh1g8VkaHNVQiLWOuoHvRDeQsVQ=;
 b=KVwkYYFHjwP0oZhrMOBU/8YsjI8HCXYp0YGeOcAggoExNlxnYKuOiBqj1tTLoMHO0fTSwYWBi0+iPMJiAFaJp+k/zWPXXHEp4/ZNF6pKRzC6ZjIiFnp3HYFsdVE1k9FN2cl4nGfFZ/cYJi15Ady0uGLBzyltgLiLcZrmblMd5YRbRtFvHWeGOq9nrCO2fkTvR5Uycw8UbYqcs444VGTShWIU1cJEaDhXYWjOCt+QdnB7ptt5MpsYEzK5uv92SMyWXPNJmjH+HlXz22HRfwN2eFqFEASlvnIU750iQre9rh5h7CjOScmyGFvzlSVlZHE4g+1JI7n4cG30sTPWt3zyKQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BY5PR12MB4148.namprd12.prod.outlook.com (2603:10b6:a03:208::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15; Sat, 12 Feb
 2022 00:01:19 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.4975.011; Sat, 12 Feb 2022
 00:01:18 +0000
Date:   Fri, 11 Feb 2022 20:01:17 -0400
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
Subject: Re: [RFC v2 0/4] vfio/hisilicon: add acc live migration driver
Message-ID: <20220212000117.GS4160@nvidia.com>
References: <20220202153945.GT1786498@nvidia.com>
 <c8a0731c589e49068a78afcc73d66bfa@huawei.com>
 <20220202170329.GV1786498@nvidia.com>
 <c6c3007e-3a2e-a376-67a0-b28801bf93aa@oracle.com>
 <20220203151856.GD1786498@nvidia.com>
 <e67654ce-5646-8fe7-1230-00bd7ee66ff3@oracle.com>
 <20220204230750.GR1786498@nvidia.com>
 <0cd1d33a-39b1-9104-a4f8-ff2338699a41@oracle.com>
 <20220211174933.GQ4160@nvidia.com>
 <34ac016b-000f-d6d6-acf1-f39ca1ca9c54@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <34ac016b-000f-d6d6-acf1-f39ca1ca9c54@oracle.com>
X-ClientProxiedBy: MN2PR01CA0047.prod.exchangelabs.com (2603:10b6:208:23f::16)
 To MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d95a58ce-4691-4f63-e194-08d9edbacb85
X-MS-TrafficTypeDiagnostic: BY5PR12MB4148:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB4148ED16DBE4CBB3BAC39B21C2319@BY5PR12MB4148.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zvF49tYL+9H93IO+c4fcWXGVQZL5M4oOic2R29yDlY3WydhjzAuGzdDiWBAlPoXOPo8zCUx2UF20LQE0oONkC3GvVOJUqqr53MKtI7dYUrxzHUHXBiP9Fr2DDcwOiJsQB+y+nu/09hpjYPAAbmWAoEHV4/1xvDV7bFh6OqaZTOZMpj/b3Siu+8NCFWDwWbTu/8Pq+rp3ZUayK8YqeEI25gBi2R8w4131Truo3r9InxLkCtQdZpknGh3zhDb0LvWPxXrGzQ3qUShWikYb1hTgW70oBk9UEvLHbu0ICiJWQRaPkj0rorFm9CnbhzEkpUckKN64GtOmTAmdtImkZeBwZ7CPxYaEe4Zmhu2vTglAVTaxtzmJr9cb4FCO6BSitgJSw9uTJ8r10nsC1yqnfQ8YaSLxZuw+S8O1xo7AZeA7LYVoDX7iDoDnt2osvxCxRi1cJPGPRFKubt+WuFuChPhhPvgj1+xjjXYazeyM6/AhTKMqpZV4oT6tPyZ3+6jdunvIe2455iQnQT8Kw6XA04tK6lZhPfrJjrNtdwf78nnZvmfKzlHjwSp+nMoObNU/uwU394ZgbQUGezQ3rb+Zp3DYArcRleYmvCx5nQWrsw16fnb1f21XcCPY3JGajCa4UCLsyXaVtABEB8L3vdApW9ko37addOT6MveXPT/VqbwvQO9Kbw8MPW1rSAVmD+wmfleYQhLSLsHac7DLTJQzNhHLUF2Ghwgy3DnmeU+XYAd1O6E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(7416002)(83380400001)(5660300002)(2616005)(6512007)(8936002)(1076003)(508600001)(36756003)(33656002)(6486002)(186003)(966005)(26005)(6506007)(2906002)(86362001)(38100700002)(6916009)(54906003)(316002)(66946007)(4326008)(66476007)(8676002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jg5pdacwxmjvelXAxqQ8UQ/1VLrG/iVuc9ALno3v2gPc5w6CLDCsLq4V9OCQ?=
 =?us-ascii?Q?p1GZG1p05BeJNHuBp2AkI15kHgYG+6xMS9nZTDufY5lHpHbL1fbJ+cfUfbKO?=
 =?us-ascii?Q?aZpjmh+vJgAzSjCaj8tDpsXYgUq5QT6ly6kyoHuShE6afeiVgEz0Dg+hhonn?=
 =?us-ascii?Q?B5Lj2Pd5Gvar6CRFEly4E4TpGyKWmxteEBulxM4gRDZI8to6T0Ni+4ttJuR9?=
 =?us-ascii?Q?0IziD6/ettq6Zw9uXScQUkHuJnDHcRDSwB0WUiXCvtkT2wVrLYhgZEyz2GAT?=
 =?us-ascii?Q?+ulL4zSXlmLMig7MWVByJPp8KrBmjYsvbA44LFZXxMP802e21eLBPTd31CMe?=
 =?us-ascii?Q?A6ZPb/jcDGFOvqA5vtYUBjvi5tnVlqrHj8Eh0nVfKhcWl1mZ3XsLcunLqtII?=
 =?us-ascii?Q?GN+PHd7gmKNpD0Q0t+bEhReIcC+iZKrrmcTVvMQezJ+1SggIojN4hgFL6qy9?=
 =?us-ascii?Q?oK/+nvgLoXZtZ+tJnrpNtd4JC2380MSAcGEPfhj9HjBVL7S472svEcMOvuCp?=
 =?us-ascii?Q?mO/wPwLNxp6V47G8KmrInaxqGlhPPgGG6DI9Sy2X5B7TVpijkBhzBpZFOlvc?=
 =?us-ascii?Q?CYHkT3o7Oun7Z9GR6ejL//sJbon0xoYCRjrk4yu7+HGHCxwIScfqZVyAp6ye?=
 =?us-ascii?Q?IPtfFTJ2XM+Fx8RY16X/QVthDLmxpunRpHNqERZLcZtnLetFx96wQ9MeJZB3?=
 =?us-ascii?Q?OfYLLvzxysPWKkZD/pEh6HIVIPELZv9vkkVwCQquTKGhgY6DAojfGw0ahOB3?=
 =?us-ascii?Q?DW44rGkLYyb95GxFKWT/gFANdYPatfHy43VvE76TxpOyYggXIOzvWJv8sRKk?=
 =?us-ascii?Q?hw0qKDb4qmwZkvO9Zq+g3muzWPsk6wwg8xuRFNpLuH1y3sGqxmlOAYVkptkt?=
 =?us-ascii?Q?Gxl2sL0YivpUcbkuBU51U36W0LCrelgNdebm67FswvZFbvhhY6LG0Ce5oG5L?=
 =?us-ascii?Q?n9d4aTtoAF91Tx9rqi/2bMMf8SU6jWblNUOZir6s81Yi5gA9JCCgyCeZ7X+p?=
 =?us-ascii?Q?0xUAfXO1PeqvXBnxrtHTy1tgsh3UvBtDLX4dsbnSYGkJz7ZCltPoJO5eXepQ?=
 =?us-ascii?Q?DIS+0WYf3NS8KfhqUAXdxabRk30wVRiXux+xMMBepIyffH7kJ3q8eYMIRCU5?=
 =?us-ascii?Q?VVi73VkPctKoJ88F0BOBmOZHJPKFr1kH0kjboNxZUQi8ia//c/8TBaCbM7cI?=
 =?us-ascii?Q?01evZivJrKrH042PUEwB4W0dHlpiiT6f2n1hDIBJ5TAAMqs+F/TN6l4E4OLT?=
 =?us-ascii?Q?PgZf1JMYaEu/BmtjpSain2AkqNcFOj5+gNzPu8WV4G02Z/abnpAGbxWp/O8/?=
 =?us-ascii?Q?l8WzOsoCBPSbs/2ZFae1ZRW/luSkJvzS+bw3uxKWLc/OV9WwqAiA/eJ/gyZJ?=
 =?us-ascii?Q?7OhQWDUXvv9GFAoRnTEtfQ8r0UadXBWmuwzBB0IHcAhZuGFByxJdXoFh5nDI?=
 =?us-ascii?Q?6eAFDm7IpA4ODzpxco7hXWjGs8ck2Jou6Wuotq+A7xSYRcm47zY2y+rnk+en?=
 =?us-ascii?Q?1+sx9FfThLTudunRqAKx+DAsawfyeKrP/uikkFZvEsbkq9ZT9+Ji29F1GEh6?=
 =?us-ascii?Q?gdXzl7zfSsh0AKIb2dY=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d95a58ce-4691-4f63-e194-08d9edbacb85
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2022 00:01:18.4993
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OUddXNVYLBo3kIe6+Irzpy0jLB8DoHhUjsZVc1Jo0e1EA4UlIlrJdTqRZB1YCGW8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4148
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 11, 2022 at 09:43:56PM +0000, Joao Martins wrote:
> The plumbing for the hw-accelerated vIOMMU is a little different that
> a regular vIOMMU, at least IIUC host does not take an active part in the
> GVA -> GPA translation. Suravee's preso explains it nicely, if you don't
> have time to fiddle with the SDM:
> 
> https://static.sched.com/hosted_files/kvmforum2021/da/vIOMMU%20KVM%20Forum%202021%20-%20v4.pdf

That looks like the same nesting everyone else is talking about.

I've been refering to this as 'user space page tables' to avoid a lot
of ambiguity becuase what it fundamentally does is allow userspace to
directly manage an IO page table - building the IO PTEs, issue
invalidations, etc.

To be secure the userspace page table is nested under a kernel owned
page table and all the IO PTE offsets/etc are understood to be within
the address space of the kernel owned page table.

When combined with KVM the userspace is just inside a VM.

> 1. Decodes the read and write intent from the memory access.
> 2. If P=0 in the page descriptor, fail the access.
> 3. Compare the A & D bits in the descriptor with the read and write intent in the request.
> 4. If the A or D bits need to be updated in the descriptor:

Ah, so the dirty update is actually atomic on the first write before
any DMA happens - and I suppose all of this happens when the entry is
first loaded into the IOTLB.

So the flush is to allow the IOTLB to see the cleared D bit..

> > split/collapse seems kind of orthogonal to me it doesn't really
> > connect to dirty tracking other than being mostly useful during dirty
> > tracking.
> > 
> > And I wonder how hard split is when trying to atomically preserve any
> > dirty bit..
> > 
> Would would it be hard? The D bit is supposed to be replicated when you
> split to smaller page size.

I guess it depends on how the 'acquire' is done, as the CPU has to
atomically replace a large entry with a pointer to a small entry,
flush the IOTLB then 'acquire' the dirty bit. If the dirty bit is set
in the old entry then it has to sprinkle it into the new entries with
atomics.

> This is just preemptive longterm thinking about the overal problem
> space (probably unnecessary noise at this stage). Particularly
> whenever I need to migrate 1 to 2TB VMs.  Particular that the stage
> *prior* to precopy takes way too long to transfer the whole
> memory. So I was thinking say only transfer the pages that are
> populated[*] in the second-stage page tables (for the CPU) coupled
> with IOMMU tracking from the beginning (prior to vcpus even
> entering). That could probably decrease 1024 1GB Dirtied IOVA
> entries, to maybe only dirty a smaller subset, saving a whole
> bootload of time.

Oh, you want to effectively optimize zero page detection..

> I wonder if we could start progressing the dirty tracking as a first initial series and
> then have the split + collapse handling as a second part? That would be quite
> nice to get me going! :D

I think so, and I think we should. It is such a big problem space, it
needs to get broken up.

Jason
