Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55BD87AB489
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 17:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232334AbjIVPPp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 11:15:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232312AbjIVPPo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 11:15:44 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2054.outbound.protection.outlook.com [40.107.93.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 346E8A3
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 08:15:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MZO7Bna9rPIUB9k6NxpRhx2VhowVfFJvJyFtNcNF2ntuDtcaz0axwKPAzAFFM9h4uFdgjQE9BZ2hDfUD4vYFiEGXVeCrj1CiYdnlEAlCzrO1tRBFHTR7qIPMzGEAZOGVjdSt8aaVRzL6xvkZU8o7bGf6rxvODXqgaqU5BWo6f5jSO8kUYhlBci1sikiDC1NG104J0Yf4AWiiCPFVyAYXN0qHPjVi/xni6Be+VZNz9qivOgt834kjXDgC39zbacQhVY6kldO2KCUqZVYG47GXltU+wahtqSWZdUa17VtILgMZS7ggBKParelv5wqjNRwRqlXPps/ZuWPQYLlCOwKHwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TGIt1gLDPjyHY0CAY6zsuJZ7+CTGP1Ufme+TmZoJnjs=;
 b=E337fmzwTDXZjZzVzZNbaeMItfHodNEi+FA5dcpZQHZ5ZvOcKeUjOvLq0JfjXd/5BwfWLyS1/xJeNq+ztZ/o+pmmOnLz3s9au7FgxdWJqeuTO+9VurqB7VdtCvCcFMmXCU7oBYp0DxTTD2fTpohy5v8MRW+bRP0RS/VQlTFzf5v35WG4DhHOvHotyZ7lh0VQoubHMdXS9ajKhMY1BsZMibdv4nd8fHXNRIr8ZpqvihYShIVd3JwSH3fCdTYLrBkVFtcYGpXkiuF9jgwNyh8wnxlOi+b6j6AM7kOrtmDMi4CHLthkFMmKWsjAoPji2F53T/vjy4kr/CL4h50dYKxlVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TGIt1gLDPjyHY0CAY6zsuJZ7+CTGP1Ufme+TmZoJnjs=;
 b=m0mDjG+gTOU+ipib8nUfhzI2yZHHDa8rebzgOHauiP63EGnDCXUell8D/R9p4QBXUaqa6qy/zMxfANwhCPYO6+LKJjCbSqJe6gKxM0tI6M4bN9MGGL4WIpU0XhWIzeU0wwHT4xLQ7UfrwXgo66HquctZuWRNIfz8O65jim389/j6XkunWobYmbMCKnTZL1oRivs5m5qCLu5rUMjlPWHzKC382r56dDxjP/awlkIBfG2GHXh1errLBgpe1lLP106KzkLOw+mPEHxsLqcRmjM8s0/XhLx9+1NDT6fEGebzZ0pPWFbDf23xN+dX+yq752o3yG8qUlt0c8fgLTy38F+YfA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ0PR12MB6784.namprd12.prod.outlook.com (2603:10b6:a03:44f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.27; Fri, 22 Sep
 2023 15:15:35 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::faf:4cd0:ae27:1073]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::faf:4cd0:ae27:1073%6]) with mapi id 15.20.6792.026; Fri, 22 Sep 2023
 15:15:35 +0000
Date:   Fri, 22 Sep 2023 12:15:34 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Parav Pandit <parav@nvidia.com>, Jason Wang <jasowang@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Feng Liu <feliu@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>
Subject: Re: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20230922151534.GR13733@nvidia.com>
References: <20230921174450.GT13733@nvidia.com>
 <20230921135426-mutt-send-email-mst@kernel.org>
 <20230921181637.GU13733@nvidia.com>
 <20230921152802-mutt-send-email-mst@kernel.org>
 <20230921195345.GZ13733@nvidia.com>
 <20230921155834-mutt-send-email-mst@kernel.org>
 <CACGkMEvD+cTyRtax7_7TBNECQcGPcsziK+jCBgZcLJuETbyjYw@mail.gmail.com>
 <20230922122246.GN13733@nvidia.com>
 <PH0PR12MB548127753F25C45B7EFF203DDCFFA@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20230922111132-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230922111132-mutt-send-email-mst@kernel.org>
X-ClientProxiedBy: BL0PR02CA0019.namprd02.prod.outlook.com
 (2603:10b6:207:3c::32) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ0PR12MB6784:EE_
X-MS-Office365-Filtering-Correlation-Id: 6cce7dc0-ac96-4dd1-cc7d-08dbbb7ec53a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7U9GVTcYn/NbfDi/Jhhbs6UsKLxNl/i57g85SN+N+6PA9pr9Gba/8NFsbXpp/tfKp6ANGy9s64KjMQwijOfD9d7MezftbGIJlZjojxfzcMIqTYeReZ4qIwJgG/2d0oB/bYte17w7Lg6JafYBRNaiPx+6IrCt8BeTh21ScwbQ5xJZkm+DQkiwFzz0QgoI7Pm1mjwe8J+U4hy+wulis9jHBQ/9rEDRZuAFOKvEKqqh9FZWVu+NryLUy7zdVjHGc1yatd+xuo7Dzhn16R5zKj5odw6y5YAtALSUL4mbs3yNoc3BWFir3z/hWOObDPik81FUqrpAN8OWEjyyT5qvBERZzjf2PXlrFxBOwg8Ld9VC8sBeqh0yeg/7VJDmU6H/lBVSggL4k0A2ck+8SGvvu5nd5rfCms2gmUZxXqGTPMGKjjcxEowfBjUIVCXthHYoRQtBrD2WZ04s2mNoYh9cDFOp4fSSJl0noQGX41OjIOzXM3AIMTCIsLxvK82s1H7ky11Y2zKBUG3wuPSiAl1euzVYN6OGZ6LnL5AB0zdbslRNJMSng2WfsvJrIS4XCTKwecF6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(396003)(366004)(346002)(39860400002)(451199024)(186009)(1800799009)(54906003)(6916009)(66556008)(36756003)(66946007)(33656002)(66476007)(4744005)(86362001)(316002)(2906002)(41300700001)(38100700002)(5660300002)(6486002)(478600001)(6512007)(4326008)(6506007)(8936002)(107886003)(8676002)(1076003)(26005)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PLXnfqdZunNQ2phTZuk9xgvLrIfc7B/a7F5MHLL9WuSttkY/ZbNRVT3TRXFY?=
 =?us-ascii?Q?4BSIsVqSnu+EloGOhThVyoSrnQH/mU/O4/pzoeDyIoFVKYTRI0wosmseI6Kn?=
 =?us-ascii?Q?yk+8ROEoNzPP1BgKLoCo4UzpAsMy9cOaXrT+6kMGZXvok18YyGNRPufXwYr2?=
 =?us-ascii?Q?YD4opGfmXqhEOo4tDhqXTfCiHw676pckt0+f+SKazlaF0xuFpY1BrFYKYZiV?=
 =?us-ascii?Q?g7bO+zpWnCvGGvAMVFNVqUKmMhCUHU0aGQPAsCXEr0EIN2VXA8ct5o071yg9?=
 =?us-ascii?Q?E5PSDAj+13Qgx5hNCKG9U1HPGhlS9r7CNmG74yXQGeVLwT0FBSq7wqD+Nyy0?=
 =?us-ascii?Q?7/T5KdvqvMNm/0vGgBjtqP+imIQGQClzFCkFgbqSjdJRXslUhQF/QdWzbC+Y?=
 =?us-ascii?Q?tZcylae6wm9gAAKa8VYFEFjgXkhkND+93GNOcpIQYN3LUnvwGYtG+KfmD4oI?=
 =?us-ascii?Q?uCJ0mYFulUI82vr8f9pbiN/19MEdXV1GtRSyKcNgT0CYjisRHW0CjdfKVTFa?=
 =?us-ascii?Q?qXXn51i31qut63/fjiVMYJ2FBiWLZVwNhBOKlWMmgiEh1HH2NVDH9hhnvd6W?=
 =?us-ascii?Q?aJBrRftxsunv1H6VHIF0XSjOrLSSTyjQpicQ9y2coxtFJF9j58ioR/4RyfTw?=
 =?us-ascii?Q?kvICSUMqzOWclEqZZEBpuKoN9/SLSLG9LiB0pMHYZjxkOzMnGg3uJj6lm6k5?=
 =?us-ascii?Q?/TDxB7vWO0uZaCj7z8BsZZA17EWcZoJSM5ZA4VE6shce0uP/SPZX1eQaWN5z?=
 =?us-ascii?Q?RB3p7Rr+jytSsAP+HeCp3PdusUO3r6pSTnmovYb4dmDQc7XrB1xfoNnlUQGT?=
 =?us-ascii?Q?fBR64A3ZjdjIfUoqVv+sZWKKzW7UJmFwDmfdI95cPKMVmsx52O1fVv4cbZTQ?=
 =?us-ascii?Q?8o3UDng5ccR1v9m4CcHHi9LsylYRLAIyiRi+fqZNlosQf7QoOuOtC/mUuJdH?=
 =?us-ascii?Q?vChhYwMA4JZet51vDzE8S7dZ5C5x0o6t9gCl+Ql8aaoqBBjrbbtIKpZEx3UZ?=
 =?us-ascii?Q?XxoT7ekID8fG9kZhuimI/zAmhbYREUWCISUuDK5JKDDcsRhWtkGwZWDAdZcW?=
 =?us-ascii?Q?W/7wIsTz627hdPGeWOwJC28MLwLvIMwZKgm3UV2tRupLL+i3lMQ/dcz6IsOW?=
 =?us-ascii?Q?jEgYqbJ56qN0+dv6vr35QeNJ0RbwyHZ0se29CSDjrEHm3A9T/b7XavgX5HTC?=
 =?us-ascii?Q?aJjtM8yR76fnNJm2LX10hdXZwZ/kE2rjSSEEWxK1xpJMmPPipF/RGSXe2gr7?=
 =?us-ascii?Q?AZxb6rHcg+QsfreKm19lscKAGuctzBtxwXO3BxvzHeJoPNoLs4h9ZoA1vAUz?=
 =?us-ascii?Q?M7kYcqFg5IVxlUOT8yKxuPyaaA8ayvtQMqCu9dBBNCfRnyQ75XYP9DEvxmnV?=
 =?us-ascii?Q?wRTX006keHIz8L+S3JNOlT01Ac0S3UKUg1ccwYMDWEBsqKCL3GSgjR0go75S?=
 =?us-ascii?Q?CDcInpRhR9TmjMwoZ5bNTKJvYDRqSURENDLRV4tPu7polemcAsgFQehW6I3G?=
 =?us-ascii?Q?PCmORiE1KuhvfLkFm2zzUfnKIuHFE9N81NjHcMAvNiL3x4iG9KVc7nV2pHuq?=
 =?us-ascii?Q?r9mIjrC7LEWE59H8XL+KkXyX6gqVj88CzcQzi1bO?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cce7dc0-ac96-4dd1-cc7d-08dbbb7ec53a
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2023 15:15:35.4368
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S+S2GnrkTlLVBGJ+KySGii7z4XHCWqen3+aY2FylOQ1tuF1dMDLplPn7ALtid/QB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6784
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 22, 2023 at 11:13:18AM -0400, Michael S. Tsirkin wrote:
> On Fri, Sep 22, 2023 at 12:25:06PM +0000, Parav Pandit wrote:
> > 
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Friday, September 22, 2023 5:53 PM
> > 
> > 
> > > > And what's more, using MMIO BAR0 then it can work for legacy.
> > > 
> > > Oh? How? Our team didn't think so.
> > 
> > It does not. It was already discussed.
> > The device reset in legacy is not synchronous.
> > The drivers do not wait for reset to complete; it was written for the sw backend.
> > Hence MMIO BAR0 is not the best option in real implementations.
> 
> Or maybe they made it synchronous in hardware, that's all.
> After all same is true for the IO BAR0 e.g. for the PF: IO writes
> are posted anyway.

IO writes are not posted in PCI.

Jason
