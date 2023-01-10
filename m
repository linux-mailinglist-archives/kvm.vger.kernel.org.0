Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0847E66364F
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 01:32:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235755AbjAJAcK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 19:32:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237796AbjAJAbh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 19:31:37 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2052.outbound.protection.outlook.com [40.107.101.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C70E192A9
        for <kvm@vger.kernel.org>; Mon,  9 Jan 2023 16:31:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DkK2LQ8AR9j0UxlO2oz+QjojNDrU0LjSZAxuw1sf9r2w8M6uXJyGONEIsCXsoVEUc4vF9R+xCd3vEw+qF23RgLR9uttExCYqYbQqez/aXNCtcdlSOv79jPJrQOGBEySPBXA2IyqpnheEbtzaRzV1Zmjn28YWgQP0nAkfJ8ZIeUTMeELvnyjHk1lahjKg0kjenOb3yCIlsYiau0xPnZV/0/4ImTlmw7P5qEHONac5DHodAniRx+VBsYdEiH5Bs2OU6ccsaC0TwcVf6n3LUdGKdHONY3qjrhHstJyF8cMZ9GSOQx8B1PohyHCNZnXFExRKEbvi3kyQoWfvVPVbqb3gxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5YgPdhY2a7Ctulum0xYp2eCTvdVV+LTYrZuaUvAFQiA=;
 b=RWa37qchLsX0gvAt0gq+HN2e/mqdbrzO1lzrJGYA50Zc3jlMdzaUr+lY09ZpKaBVAPIW8kZK7szg5N6HF0XZqRz1laG4CKYtuusRXn6ifYhzMCq/PCIaIq/e8f9FGMfeHNfmfeRI7ksb3sGiSbA2jW1ViKQpkU17+FbfzlMCTw110vbvO5N3Iw8Z357xoNcTBBa/l6e6fxaVRDFaY3y0RO4Tlh7XDOxpPV2l705Uo1Fc7t43XJsI0/SAIIYOdOPnz3CsKRwE5uEjMVcZzIuswNLKf6htWNQmsNRYRisloC++0TJZJQwNzrpPoMtS52dYS7iOQbCgE3YG0Gn1WUstBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5YgPdhY2a7Ctulum0xYp2eCTvdVV+LTYrZuaUvAFQiA=;
 b=kNS3AhqoDsfRpdjg+/G7w2QSh1ZakWrON1jCIoWW7RtRo33SKm/jHo5GwOgxh2OUYD07h1kEON6/hpIQ6rwjmZjx+4I/wjKxcFBAovtLrW5MFgOpvrof+mvgynB9hakEvs0g335BZPcc0NgT+eIxwGhzfk0k/hcLDYgE6CAUNwudKwKk2jNMc5KuV1Rwd+r3XiZD1z7pAJFinPlMCKF7Gux1mN6RCAkcuoNjH5YvXrviEL1J//VKxeHM85Dp4VCw4tRWAGfji+1F6TsSwGPPqyAj2z0Jxxeh09coSDhXryoo5Oq6XsXxEy+mJB4/jYaBH38VXKHdsegsWjEYURoOjg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH0PR12MB7080.namprd12.prod.outlook.com (2603:10b6:510:21d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Tue, 10 Jan
 2023 00:31:17 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5986.018; Tue, 10 Jan 2023
 00:31:17 +0000
Date:   Mon, 9 Jan 2023 20:31:15 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Steven Sistare <steven.sistare@oracle.com>
Cc:     kvm@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>
Subject: Re: [PATCH V7 3/7] vfio/type1: track locked_vm per dma
Message-ID: <Y7yx0517LE7qDEP/@nvidia.com>
References: <1671568765-297322-1-git-send-email-steven.sistare@oracle.com>
 <1671568765-297322-4-git-send-email-steven.sistare@oracle.com>
 <Y7RIEeQW5L+qFt9a@nvidia.com>
 <74b67580-7b4f-560d-19dd-95b376122595@oracle.com>
 <1d5fd387-3e4d-77a5-dc6d-04cc4c9ed3cb@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1d5fd387-3e4d-77a5-dc6d-04cc4c9ed3cb@oracle.com>
X-ClientProxiedBy: BL1PR13CA0094.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::9) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH0PR12MB7080:EE_
X-MS-Office365-Filtering-Correlation-Id: dbf3fd6b-8725-43b0-f8b2-08daf2a1fcad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SC/yxb2K+mp+VnMPFt1jWmZ4tycyaLFfCThp5wz/GP/DPI8erEm46R5e3ZfoxRjYT5q1D93+dcJATyl80ywbDiQ5/NBvlJHtiZbGwI4z1lizY+lc1LbZZ7Pt9P5Jab4N1zfpuGXsIGTB0RjxwV2kG7q82noNtARJMbpT/tRtG4qTYvK63+BWlyHSCbMGHRHfZG5wQF3lBuyShl2/DHJyldG8B01SLLVK3A80h6L65jCTagxnxZU3Wn6I8PEEouvRC83OCHpVFnr2dDMNoL6D4X42SfLe8bAbMTSrKSJcLZD8qk9QZEh63GnOUMK1KgLQ/s4Wc6W5R9B/bD4WCdAyn7CNLG+S2BqMLIY09UTeL6TD6rOPVvKEjkFGSHQdYv1ttWUd16QaZnojfO93cnnihILer98m+1+rJozNYwVtlwTLpZDJydjKxAsmi6kujBgCc2E9eCEoth/DrkiMnygyy0sMiZu7R0NWswgzXQ/YCSUtSJeLNH3rauhZQyh5VSg6qFgbPCLuMl0aTdo4gb4Y0ZjpcYToj1tWbYHzW+ukMy2Eo9shDJ+Uh6H6rmYvVZGJrdw2lk84tzM9ESib3jYFHvgjMhe6yDM0GfqZCsLmY4685mWsfY/tzRMz5DcJToc2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(39860400002)(346002)(396003)(366004)(451199015)(83380400001)(38100700002)(86362001)(6916009)(5660300002)(4326008)(66556008)(8676002)(66476007)(8936002)(2906002)(66946007)(41300700001)(26005)(186003)(6506007)(2616005)(53546011)(6512007)(316002)(6486002)(478600001)(54906003)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xr0L1jXqgfjMfT4ORNoSG8QOj8O3lC2NNFnXMYonQExSgR0VLQecL8OOR2CM?=
 =?us-ascii?Q?Q28n1komW3JbFAPbA2TibKcfZqxWs9Q3MgWQ2SyYW3OdckpM9huH7rKK9KHE?=
 =?us-ascii?Q?YLFJycuLAkzvkTj7DBX7JcXNwrBkO8XpQCx0R+Sw++/yjXZNSLQEwKKesFCN?=
 =?us-ascii?Q?HADlDi0+40hjMDXYrTuumWet35Ak97Pq2wbeLVSqLcOY1KwhdpxsRiFUd2Q4?=
 =?us-ascii?Q?AQsM4gqCTRKgrVkFQugUDy2JE9CErsdvM+XzqDN+5bE85fApsVK0+6DFMKzY?=
 =?us-ascii?Q?du6DAZEvNrs06+bCK9mulbr8vylBpvbDaahO+/me+GjKjfbo7d/tFDPT/nvC?=
 =?us-ascii?Q?CdAnvXl6vXI/dCjV3+6d/wBjHcHgnExfk1phXG+ldbXZ5PqigcidI7vjy6Fx?=
 =?us-ascii?Q?4DMIOSBENDvYszBz0cCua30Tne4CDNOkkmkzto3DLFvNRIvJodi5zT0IcOgD?=
 =?us-ascii?Q?5ZSmd2CpKa5sMzF/p41qceGWgY4chhWvoEwCFk82rR3qXEpJUf3OwvW/p5I/?=
 =?us-ascii?Q?4ykvR/aX50QV7sDXfsPLESFL9CmpsATr6jB0DxTEuLxjOUTcnK3qOvarGnpS?=
 =?us-ascii?Q?5Zm4Iddn16PbI5be35lMwMPbmFaILn3wcTtcz4w8ifs5gWvuAOHFBiyvekbk?=
 =?us-ascii?Q?QfultS7UZL1P5rrlPmn/01RQchO1PXAf+vciJoeNnmlO0aB77O8ydH5t1Iks?=
 =?us-ascii?Q?eWbZ4mGKrbIp7YMGmTBf41keG7tacXNj8x9fkOmU+WxQ5KIH5GhRccidT3ln?=
 =?us-ascii?Q?O5k5fIJ8U3uKj/S/MCynUeDcduQl2tLz3idkp+B1FGl/abYDlDvYhgRdYsji?=
 =?us-ascii?Q?8Y4PbxMGudMlzQapfC6enR22KBC4yQfUiJGEbfwhukYruTIQtquUGPy9Ndcn?=
 =?us-ascii?Q?ku5tEjHl2ZiaQjJDdR7avM6QNGCmDmQBSm0Qm3kToEWbyD7uPUXiQO5pu9oV?=
 =?us-ascii?Q?Xkpcc4zz140DxkMzdE19zv3gdZotNW45Sl5m67MG3kQyFjcgWErxRpK4gVYi?=
 =?us-ascii?Q?kc3lSmJueYDBsKLDDbWfDwqgPyXkQsu3SgzU3F5cmWcWhTPswgJOdqeROP+Z?=
 =?us-ascii?Q?EoTmd/xayDfzmby4nrQg2a1bIwWspxqHTAIaWV3dF/cTbpzeEk7Zz6g6/7r8?=
 =?us-ascii?Q?nlgc5EkT+Bq++xpozmD1Crjh4uDG6rx1/nfPVP5EAnZzwIyLH3sqbTgr/sIg?=
 =?us-ascii?Q?eMVwXjCDrppf/fWDBLjbljhgkXl+gEyC2GGheNPelCw22wU9QetzAY8RX1RN?=
 =?us-ascii?Q?H0WZaS0Sh3hBHAiD8vciW0fAj8sE4QH/oBhZwyZP3EFcKTmbS3O83hkmPbhv?=
 =?us-ascii?Q?B/A/9gYUnpci2UpNXzmVD81Bo4gTIzCNV3bX2Jkkf9uOZZcCJLPg8J1GeqVr?=
 =?us-ascii?Q?jY9S2QV0SMcq+MV41J2pzgNIVBKWH+zU4kzCXr40hB5Q8FCzpMoj/0bSMfEx?=
 =?us-ascii?Q?LhWFHUz5fsESr82vnI7mt2RxrqomqFaqyZrh/MwtOv4LYdccayD35YuPHVV/?=
 =?us-ascii?Q?RHNkfswCMSRE8LpOg1IbNQk0TZOmGs/2nRVySMsyg67DdZjsDanhQj4Vfynj?=
 =?us-ascii?Q?Yp25F8e7Ouh536Bml+q6C8BCRlmz5qBQAejlkAV7?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbf3fd6b-8725-43b0-f8b2-08daf2a1fcad
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2023 00:31:17.0825
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m/I+5opBRe4uJYo8QMALSwI2O3i4zdfVdxlFJTtCs4tyxPYLwkMBEtepnyEBc3gE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7080
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 09, 2023 at 04:24:03PM -0500, Steven Sistare wrote:
> On 1/3/2023 1:13 PM, Steven Sistare wrote:
> > On 1/3/2023 10:21 AM, Jason Gunthorpe wrote:
> >> On Tue, Dec 20, 2022 at 12:39:21PM -0800, Steve Sistare wrote:
> >>> Track locked_vm per dma struct, and create a new subroutine, both for use
> >>> in a subsequent patch.  No functional change.
> >>>
> >>> Fixes: c3cbab24db38 ("vfio/type1: implement interfaces to update vaddr")
> >>> Cc: stable@vger.kernel.org
> >>> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
> >>> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> >>> ---
> >>>  drivers/vfio/vfio_iommu_type1.c | 20 +++++++++++++++-----
> >>>  1 file changed, 15 insertions(+), 5 deletions(-)
> >>>
> >>> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> >>> index 71f980b..588d690 100644
> >>> --- a/drivers/vfio/vfio_iommu_type1.c
> >>> +++ b/drivers/vfio/vfio_iommu_type1.c
> >>> @@ -101,6 +101,7 @@ struct vfio_dma {
> >>>  	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
> >>>  	unsigned long		*bitmap;
> >>>  	struct mm_struct	*mm;
> >>> +	long			locked_vm;
> >>
> >> Why is it long? Can it be negative?
> > 
> > The existing code uses both long and uint64_t for page counts, and I picked one.
> > I'll use size_t instead to match vfio_dma size.
> > 
> >>>  };
> >>>  
> >>>  struct vfio_batch {
> >>> @@ -413,22 +414,21 @@ static int vfio_iova_put_vfio_pfn(struct vfio_dma *dma, struct vfio_pfn *vpfn)
> >>>  	return ret;
> >>>  }
> >>>  
> >>> -static int vfio_lock_acct(struct vfio_dma *dma, long npage, bool async)
> >>> +static int mm_lock_acct(struct task_struct *task, struct mm_struct *mm,
> >>> +			bool lock_cap, long npage, bool async)
> >>>  {
> >>
> >> Now async is even more confusing, the caller really should have a
> >> valid handle on the mm before using it as an argument like this.
> > 
> > The caller holds a grab reference on mm, and mm_lock_acct does mmget_not_zero to 
> > validate the mm.  IMO this is a close analog of the original vfio_lock_acct code
> > where the caller holds a get reference on task, and does get_task_mm to validate
> > the mm.
> > 
> > However, I can hoist the mmget_not_zero from mm_lock_acct to its callsites in
> > vfio_lock_acct and vfio_change_dma_owner.
> 
> Yielding:
> 
> static int mm_lock_acct(struct task_struct *task, struct mm_struct *mm,
>                         bool lock_cap, long npage)
> {
>         int ret = mmap_write_lock_killable(mm);
> 
>         if (!ret) {

Please don't write in the 'single return' style, that is not kernel
code.

'success oriented flow' means you have early returns and goto error so
a straight line read of the function tells what success looks like

Jason
