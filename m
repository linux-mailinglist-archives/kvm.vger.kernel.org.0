Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E595A331C08
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 02:08:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbhCIBIU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 20:08:20 -0500
Received: from mail-dm3nam07on2042.outbound.protection.outlook.com ([40.107.95.42]:1569
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230118AbhCIBHr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Mar 2021 20:07:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D0nCSCnQpX7YtdKK1g4nN6NQSCemhB3xcqahUejqAiqK1hU+Qu7RcRhwMggqOEAAXzw24IBnEhNSe6IYCGx6H/5vaJzgyTjhNc+erUgQiI7J6ivSoKeUOzYZIlndVacRgcdbiTJS9j5UB+GtOz6EuMgsSwFH+2mmG1O5tXYaAkfg+y+c2rXsrG+lvr+4PxXGMQEqf9XTF7ED4kxIWfVzwY7NxSzdcoGY1bGOu/v6cd9f5CPbMxsU/xEVL6Pd+M+B40ysKPNmSr4kintwNhk/yjz5zlOTobmZYMvOS1Lhkr98tvirQUCVfpUkHAM35b3tkVjTFoICzA8xW6/aBJVHeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TPn0RWwJC9tpDmRV1FCfmdLWUx8T9MExQXJGBSjdZrE=;
 b=jBjvscflEb56uMAgscT1K3N1QfiJ9VBUN7/IL4OXy6b/xcXLktHvAPN3nLyX8LvVon4AzZzfTSuk+tg1bhqrp5EpQDLHjXE26LRmKKdq4vqeIO1M2kEYf1sKD0or+tl9ds8hQaxJI/0yMIE5+tUcNJHKR+KhuBuBfiiv/kj4gnNFMVGt95Fe/9o30LHXWjWhBXSJcO1hqn4FFbJIFT+N3bHouukEpi9ajaHGUC7MZQBjo6GP7h5wrH5HLRIvq30NByo8qq4PFv6/BsnbJUtpWgHfrMj3bpjxjGHTi5z/yGjXBA123HuEbfrn3kxhSAGesmTLpX/YPnoh0PvnXBJxEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TPn0RWwJC9tpDmRV1FCfmdLWUx8T9MExQXJGBSjdZrE=;
 b=IIVhidUsW0D/xor5b8sU5vYKSUZHHhFDbYsb08u0sP/OOe375G98jKehyfNTTWqz/pY0LeQjFrRcfrpGJ2Sp74YmzAIFHOLW+jRwJq9HWMS0XIdJaC/cakxQ83UR3NUgyQ/+pEg2VyEbqNu0sC8LIdIj+54dTKeTrXZ762o+d3k=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4973.namprd12.prod.outlook.com (2603:10b6:5:1b7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.23; Tue, 9 Mar
 2021 01:07:46 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3912.027; Tue, 9 Mar 2021
 01:07:46 +0000
Date:   Mon, 8 Mar 2021 21:07:45 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, peterx@redhat.com
Subject: Re: [PATCH v1 14/14] vfio: Cleanup use of bare unsigned
Message-ID: <20210309010745.GC2356281@nvidia.com>
References: <161523878883.3480.12103845207889888280.stgit@gimli.home>
 <161524018910.3480.774661659452044338.stgit@gimli.home>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161524018910.3480.774661659452044338.stgit@gimli.home>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BL0PR02CA0086.namprd02.prod.outlook.com
 (2603:10b6:208:51::27) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL0PR02CA0086.namprd02.prod.outlook.com (2603:10b6:208:51::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Tue, 9 Mar 2021 01:07:46 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lJQqf-009t33-As; Mon, 08 Mar 2021 21:07:45 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d3b51794-ac5a-4111-78e2-08d8e297c025
X-MS-TrafficTypeDiagnostic: DM6PR12MB4973:
X-Microsoft-Antispam-PRVS: <DM6PR12MB49739FC1DBE6CD5606E8B5C6C2929@DM6PR12MB4973.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: caD3GXKQ1fjFE1auq95fHD+X+JLFNLPQPUaGNMc3h5ghw8XnXl+nDTHEN72RH8PJGRawoZe9HxqlmsOeiJFlkiSQQe2FeUdGVC+yf40fI4OB/m+To6uk1pNQQKQqaOUhRPNwpsAC/DSn/zMUxQpDtDw8QPhS7gQ/egwDg6PNknSm4xUhquGsK6AaZKyQTRKIZB7Frx25iXbGg+fQMrWViVpdVluqMUePD7E627qkXhiJtkSpjBHZC4ERqg8jY+1PZ3+IZY4k3PMJR35naHwQdYW+SXc46JYsPm6LaUUY+ZIMWYw0GbwSX/T0zm5keYzbeN5qeIweJNS9QaFT+vY3n8AE7zF2GglHZFSM4FUB6JTcVlu/Fj4Ft7R2a5UB8pMBzBIOfrIUZsMzth7IhN0szLrAUGnGKRdtwO9gsVg7/y0+DMh7XcXReNiXh7pIeK12vqoaXTSD3Fkel1XO6fi3gegV24UafKI6cn3NH4m8fFkaCZ3q5iyDUckDc33EYOyZElfKTi21u8nNCKJeZvTM5A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39860400002)(376002)(346002)(136003)(66556008)(2906002)(316002)(1076003)(478600001)(4744005)(426003)(66946007)(2616005)(6916009)(36756003)(66476007)(8936002)(4326008)(9786002)(186003)(83380400001)(86362001)(9746002)(5660300002)(33656002)(8676002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?7J0XJXM2nVkyg/3MT/UTFmcE1fkfAIgTqo5S25B1TDJPF2ZbiCf6UVP3rJdG?=
 =?us-ascii?Q?5huDcbCh180mEIRTx65J7rBHzo/urRVqMTUZX2hgo9irKfUUSBdxnhRmUCBn?=
 =?us-ascii?Q?dCfEsR8OnRofYW8kFIfsgJBiU/NKQfZFfYCroZHGHyv1Y0HaRzCRA+Pqufst?=
 =?us-ascii?Q?avHmHE1/nROKb605PM/WdiJlWAoaCjfsILGys5fmVIovLzE+F8kaNFLFLWAR?=
 =?us-ascii?Q?cA2F+4FPIdAN07SOWNJcQjy0uGEpXFilviKfc/w/lcdVq298XjiaTeOlXtdA?=
 =?us-ascii?Q?0ppRlV8nwfYzODoJh8Zz6bZg5obW6lqMZ1LAa32aRBbR9u2gzXBXyMH097Ld?=
 =?us-ascii?Q?GTj5r1Jb3mYsKbFsZzK6xZ/H7MFk9KxoTJ6ENwkqKsrt6FjnD7QE0fNX40OE?=
 =?us-ascii?Q?XTpU4MCPLtA8Gs52xnpHpXFVUWSFLT5Wb7mDRRGb1cjmcNlwoWQlnliPXe+f?=
 =?us-ascii?Q?FiF40GR/6plZjspchPKIZXqr5fvqgZPfpzN82Ruzay9WWSSDXeEFBphjUlVS?=
 =?us-ascii?Q?phSwXiBZMiA6pnjTUXoyBGiWBey2FOQk4oj0W91RpeXlAgeqn35ovxkzE3ke?=
 =?us-ascii?Q?44sX+jp5z3qt3m4VVKmuYD43TjgoZjHg7N9A4Ip59LjUaGQKdG6k6rardiGf?=
 =?us-ascii?Q?bDl0tB+ZwdIaZR+aBudKN05RKRGgv+U/OjGiG2/VvLOVGLJ6xJR/jA27i4Bd?=
 =?us-ascii?Q?4+tJonZnLm0Ef69n0CeLVVhVfhEpv0c8HQLSOY/Xjn7shxPdi6eyO6hxCuZv?=
 =?us-ascii?Q?iJte8SHx8vhMwPGIoMeg7QfA6i7/6bMuWzDRH6UvWZc0djzUBLAPXtupZQAt?=
 =?us-ascii?Q?zbGKuRiX8eKwwj7eqQRi63EqY18kphSdwjTcVKwf3xxu7sKsVl75OtZrLgcV?=
 =?us-ascii?Q?iPOWrBzOax6zvST3ls3hOPZjruMfDp5QRHeOaKSlh9VKMtvfLcMhvrVi2tPR?=
 =?us-ascii?Q?jigBDFiYF8EtHRo+ZdoIUzS7EAprfeX57UE5GwwQElSi9LDOfTdE0YB2goyu?=
 =?us-ascii?Q?0DKsqO68PbwkuwE5e9SNJXRQ9lPw1lOwMeRKhHRDkxA8VuwkWozdzl4DJbTR?=
 =?us-ascii?Q?mQTJzbE8yOen3rJdiDAwDmSwqBwIDOWPQqag9RaVfDTZM9bz6typkZMjW2H3?=
 =?us-ascii?Q?eu1t5rRxms2foonSQ3dbSIiFgpx95Ue1yFzgMmQA24bJyI1Ucx1+WxThjlrB?=
 =?us-ascii?Q?9qZ40ocG3oA2WA+ylRK8CMsn3zngbvmlIbS7hgZp/IV0bR8vbcNl8evs3Mjo?=
 =?us-ascii?Q?Ru3uutPN8JA1lfzqbXcLNPEYQSkbSxHNggXdJRCXNiG5XUsK2Kn1VTr1cJ/K?=
 =?us-ascii?Q?mNLuSf4wkGuHMtUhTrw5xrQRWYXlUdEH3Su8BSEqlZm9fg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3b51794-ac5a-4111-78e2-08d8e297c025
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2021 01:07:46.6894
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Yuf/XQQn24ry09K2YLs0nhUnNJeEb8fPZ4cT13jlEKtEkLIp8Nm/NEs5T+TIH44/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4973
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 08, 2021 at 02:49:49PM -0700, Alex Williamson wrote:
> Replace with 'unsigned int'.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>  drivers/vfio/pci/vfio_pci_intrs.c             |   42 ++++++++++++++-----------
>  drivers/vfio/pci/vfio_pci_private.h           |    4 +-
>  drivers/vfio/platform/vfio_platform_irq.c     |   21 +++++++------
>  drivers/vfio/platform/vfio_platform_private.h |    4 +-
>  4 files changed, 39 insertions(+), 32 deletions(-)

Indeed, checkpatch has been warning about this too

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Again it would be nice to apply it

Jason
