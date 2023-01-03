Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B67C965C2EF
	for <lists+kvm@lfdr.de>; Tue,  3 Jan 2023 16:24:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233588AbjACPX1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Jan 2023 10:23:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237815AbjACPWx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Jan 2023 10:22:53 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2077.outbound.protection.outlook.com [40.107.94.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EB331135
        for <kvm@vger.kernel.org>; Tue,  3 Jan 2023 07:22:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NcufKO10nyiRdezvQKuqDjrHdfpuwGFaPF529m1n5zgOX832JFZ1/QsD8ynPve4dyz2Pm0vkcezQjtKDIwlq9ANLfAR8dpOGZQnzYJuU00wleQPnqlFrdVWflflUz/sLafOo505t6pClgNjWPaN9Xk2fS2BwXTsRD5zLa2Aq5vfqzudPLWGU8si/yxH58D+EzkuFf4wFLslIN7wzAPEopqKMZMggKAMDPnjpy/pBDNY8LVzM70FP9Hc1p1ie+XOdba7EO/tiJhIrbykoA9YKM2EiEkDNHpRYZhdFOIa6h0DQ4xHjlvgIX0BP62eQUYTHtNVOh7DB0H5TygDRcf29aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y3y/R8o6yHPtQudgyFz/pPJ5V+9m5GNJ05Jh5smWe4M=;
 b=Ep23AXtHos32jsKxN+OJ/DuYte8gF/SIESAv6FkPrYg9YwHOkKyrC2Y5JHto26TI1QdoKbXDSI4zpI6yp8Z+qTHr1DK27MNhPyY7lEgxYhVnCj4Xwiy0TRFzPnkHHlahds/OMnBPnLoU+Wt4fwP312yPwG9kZ6uNCvkIZW/6LE+vgXbTTLgec694WzbaWr1Uyw4WK+POCyLm07hKVaVznK3JA78gtSLoFbSre1lOlHa/GRPVwO/AnFgBkhw79xZ8IYHYY5bZWjPt3C6jR9Jb2xVXC9xrGtjZ7I5QMfiEPCg+lSZHpdZszSB+SDCXSJ+NcYx74iAyiDyAd+F4q19/dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y3y/R8o6yHPtQudgyFz/pPJ5V+9m5GNJ05Jh5smWe4M=;
 b=YwwxnffIRtKIDxyeegVP1z3/5VVYnCgIecUJ79HgYPexetypFNsjB+qkNtb/6WndLW8CrAFEyKk4A0RUMIDjWq0QTDDLYgeTA62YjGHwUhFDN4kGC5s5dgv+yKFVAaJbzwwZzeJ96ivxXgeqh5NZDickysGRSq8voKzBLUn8Lo3Hr4sDxDX9D3x2ACdIAQLqN0PGTJ+ZN5z6Rpa9DnUFGgUOAHGVjNuBDkvyrd/Y66txGrRHKaoFXwCYFnChdCm2Mj8DKVxO4ObM63evAZaCfZ6jTdSGDtVHgWuAztLEbOWdsTjeG/GPJNgHpeATipYhT+6cGiVysWj3fhUx4c+ERQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CY8PR12MB7146.namprd12.prod.outlook.com (2603:10b6:930:5e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Tue, 3 Jan
 2023 15:22:50 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.5944.019; Tue, 3 Jan 2023
 15:22:50 +0000
Date:   Tue, 3 Jan 2023 11:22:49 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Steve Sistare <steven.sistare@oracle.com>
Cc:     kvm@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>
Subject: Re: [PATCH V7 4/7] vfio/type1: restore locked_vm
Message-ID: <Y7RISZXrvjzIyktd@nvidia.com>
References: <1671568765-297322-1-git-send-email-steven.sistare@oracle.com>
 <1671568765-297322-5-git-send-email-steven.sistare@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1671568765-297322-5-git-send-email-steven.sistare@oracle.com>
X-ClientProxiedBy: BL0PR0102CA0070.prod.exchangelabs.com
 (2603:10b6:208:25::47) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CY8PR12MB7146:EE_
X-MS-Office365-Filtering-Correlation-Id: 66dda98d-db7c-4849-925f-08daed9e604b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: awFBdwAvAAmQ/fH1iC946kQSaCH2tXRuz/kpFY5qVvu8PaXXm/Y7gKSRyilNl38Sp41a9IKVlVRZk2teoOCvgFCOvV5mgXKfBJXfhbunM9onrBvkldRlVWfRYRgfsZ5I8xb8sqUUijVU7wuBsDuOHGCffJCe92mkzmc/ChR24pJ6+wgcTIKI9x5ufFN3pK6bGqsjJ8jGsZ1Jx4zeZ/baw3bnuLV+zSWqGgpXOiAPiPDTn7sz3L1Tp0hNoOJISuTO9hz9/2ekfdHf0katWiEbdjfLXbR3BLUO0LsHjNOWjnW4Zg3gOlVWB6r2N7KOq3iZS81+EVKG7OprTWemx5BaOSipN6nLJlnGdCge2+FHxOXaQ8YjZ2Lfuqt3mTXAhcb1OMExWOejFiGOYNHhfGfr1n48eGyVshumvC2pIZ4ExSHupBDKFA/iAsfbzv4IuyQmTyeB5bzMdgqpnBGwwo7lKYGis5W+i/4u1pRIhZ0Iu1vhOIMI10aTwIBnk4o21RZpgx9jaidTyUEj4/i/Lo7FXAhTkKibg89zBy1xxmJmLKovrn2JpDBiDSOHQgVpANMEzXY0YPB329abtLpeZE+utKSkjdfIK6ZZq9gaqeqki4fea3FAB38BFYzF7obUtGio9flAMZ0ZU72JKBn7hQD1wiimuY3tRNtC7/aDPnklaQJItQ7qt3y0lfqifoW4+rxO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(366004)(396003)(346002)(376002)(39860400002)(451199015)(186003)(6486002)(26005)(6512007)(6916009)(54906003)(316002)(478600001)(6506007)(2616005)(4326008)(66946007)(8676002)(66556008)(66476007)(38100700002)(8936002)(4744005)(83380400001)(5660300002)(2906002)(41300700001)(36756003)(86362001)(22166006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Wy1yXeWxT0jZTkfSLL6/LFAwF0sMrAsgOfAqCtfr9nX8mUhVOSGsbCKQwmQP?=
 =?us-ascii?Q?iDxV7KwgGjvinKSIaK0t5TpVWr74lwJEwNLe0NHWLWKtYLLtxEwIyEOP/bZm?=
 =?us-ascii?Q?1xKjlzz1zGS0Pms2rmqB/kIAbYMPRrvbeksDeuOMqUGlZgDY+jQAxA/m9lPo?=
 =?us-ascii?Q?iAEQ/3S/LCtoD9+UGRBvyJWExOafppRIv+tb+aIz/P8/PbgPkFCEw5LUsdJ3?=
 =?us-ascii?Q?ntLb2qnWNgTxnOKwUSr/37ctgui4y4UWheTjGhkSFIEjyZLH6tESkHe14oPj?=
 =?us-ascii?Q?0W5zewiidOXpeL8ORl3vxs2K9l/Pq3OIztmDP0197C3ucNndtHVA0B5mJAuX?=
 =?us-ascii?Q?xgQpoSzrmv1xa3kDPbZC0Wop4bJobP1n8xcAfFh85jZwuCS5jw9dizrW+a3b?=
 =?us-ascii?Q?5MMW163h6bKk92YDA3kiyxhRYKB5pyGd/p7LN9mMa9wBlQtgx+XavVZ3538p?=
 =?us-ascii?Q?c4Mz8n5LpU7MPE1F3R3/2yyYxYuFJCZmjr5dOUIMY8Et3ca81PXnesNQWDMI?=
 =?us-ascii?Q?pvYI2lhVZNheSooHN3ybQ4+lORGiTwUOBzeGgp1Bq3sMraa+uqW/0sx3Gq2O?=
 =?us-ascii?Q?Wjp4XMASADoeCBFa0Oa1LC46C02x3OyWxr2p/TqpFI90aPPXEcz1dsJ/weOs?=
 =?us-ascii?Q?6ZfJDmcOSyFYBP2SrP3t8wf8yiov4UrX7rfESMnjYs1bcTyi7u+lDouGQ6CT?=
 =?us-ascii?Q?/GYIDSsgmiL6YpEhn4Aa8luFu161UE9xz1ggWbSwDbXBKGQ2uYgmIxb5Df6R?=
 =?us-ascii?Q?5UAn+6sTEeZo8nYuqVoczF5QrXTVN+AhaDraD/UdLZh60m5ceha0EaGp16ca?=
 =?us-ascii?Q?yvGU6a51rQAgKZcxK2bm60km+R3M3cX5zkdAbR3t5riJyXjIBvRIdZOQChGY?=
 =?us-ascii?Q?VuBn30GaG4P6opynFWlSalTJ3dJvuWXQeq1sCJh7Sak0naxB+swSX1DnxvHU?=
 =?us-ascii?Q?pDU+yV3f98XWVNXrGK7KUAOpGuMzDD5/FlzO/Dajcl3rpDP8LkWnGb1bxmBV?=
 =?us-ascii?Q?2uiAhwGAb71dQhNozsH6X7yBlLRR80vWv4r0KWOxXSJHagUFd8v19XQpn6n9?=
 =?us-ascii?Q?+MAV0MBKTQZ+J06ZEd/74XUh1p/Yk6YKqYKrNtU8BOEQKGhP2b7FZIBwbks0?=
 =?us-ascii?Q?v+v2SxkvCcheOUtVA+z7CoMtHcOB5TqP2DxRN/4S8w5asdCZmSRShng3hiuk?=
 =?us-ascii?Q?0Gg9r4otMPize2BaaLkT2o4JBIpAlnUN5Bp1WukOqZNkURY0PhVU7k3Cq0lU?=
 =?us-ascii?Q?Ou2BmN1z0Y+tUOY4fv4xahG1yHTLnesL8H5uQ4hoDYJZ3nadTdQjEOQvzff1?=
 =?us-ascii?Q?tK7+PNKCEWQU/AuYH4yC7H95KW0uCtxN+QuMDWQn94gkJ0FivwsqpB27x0Vx?=
 =?us-ascii?Q?c8YAls4PoEAhjlv9MofRVHSPoBZI4kdqQHmlm8iCr7vglzSr2ceW/Li2lDiV?=
 =?us-ascii?Q?ggwdbnBsDyeVFW2VOtFs0/hwFboDZ3eN7WnU9CQ6qd9i+5CEEN9qeHq1wXp5?=
 =?us-ascii?Q?eTtADEMwobS0MYGoFPJW6nmxFPMaCzd/Dnt3zSMmlNFqfmeYOlrC+rSYqLB1?=
 =?us-ascii?Q?IOpXagFXmZUF44ZhDQ2wWHxfVZCTw4PsLYxgKAHS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66dda98d-db7c-4849-925f-08daed9e604b
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2023 15:22:50.4089
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8NFG1hZYlEP+90u5Ey27XFn4P0n9pcrX3aw50taA04lceEdyo1ty/vjcaW6wHWrA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7146
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 20, 2022 at 12:39:22PM -0800, Steve Sistare wrote:
> When a vfio container is preserved across exec or fork-exec, the new
> task's mm has a locked_vm count of 0.  After a dma vaddr is updated using
> VFIO_DMA_MAP_FLAG_VADDR, locked_vm remains 0, and the pinned memory does
> not count against the task's RLIMIT_MEMLOCK.
> 
> To restore the correct locked_vm count, when VFIO_DMA_MAP_FLAG_VADDR is
> used and the dma's mm has changed, add the dma's locked_vm count to
> the new mm->locked_vm, subject to the rlimit.
> 
> Fixes: c3cbab24db38 ("vfio/type1: implement interfaces to update vaddr")
> Cc: stable@vger.kernel.org
> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> ---
>  drivers/vfio/vfio_iommu_type1.c | 32 ++++++++++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)

But you should subtract it from the old one as well?

Jason
