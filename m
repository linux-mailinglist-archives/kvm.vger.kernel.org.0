Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC777331C06
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 02:08:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbhCIBHn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 20:07:43 -0500
Received: from mail-dm3nam07on2045.outbound.protection.outlook.com ([40.107.95.45]:56609
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229992AbhCIBHK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Mar 2021 20:07:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cJBr77bcd7iVijsCxonk2FM89RF7TpyDYQU6ZAVH0ce6nIELHKl9wZOJdoYP9xU9rGZYHFHsR596nan42wn1wdoAv9ZpKtjL1GgERMOdaD7pumfo1UFmKhOMQbiuaH70wJvKv776SNuTrWRJoI0B0PIEXJqaihPXeKqB8XnTUIErHB0z2oFTkXB8eXrw7F445kf6FY+S0pqR2DspZ9wfYWLGx0TxsgGL9eBj5GBuer/5BiLF+WbENUb73V7nrFJUYaQmZOLOCX1t04h7Bj9V9TVewbDZxfBIXh2DtPIvu6g0sq3982QxGxbMLhkpmYphQ/M3um0QShmRZcOEYK+f3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bbgkR4Mycf8VKy1TxFwoJi8UErv8wo4r4OIX+qkUsvE=;
 b=TQwZ0c3VQqbU3qF1gDSpyvjagpAiIBujoy7KqOwASVtOEuxi58mumKiyLRUXGd+8ThU4M9C7ibOavhAHrcOdcfVBRyvr3Jb23gTFMGPv4ipUSHAmn50EKcGvii0V2Ru3dscPtkO0bGjMcaY+Scgiqi642SQ5ju+LCYY7HoHGYMrV9unR93Aj5o9LIHE82Gus0/wvmGWlZp+vpnOljzRLYWBkmyfffybzALDCDV4LnJFpU/ZEcrUA4bHNKVwTnfo7juO8npcqtpZ66GhX0Fu75UML1hpwIg5le0NnzGikJvzw/XaJvv312AvT/sR21tRZiiuuGBsjdu5x/hYPETtLCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bbgkR4Mycf8VKy1TxFwoJi8UErv8wo4r4OIX+qkUsvE=;
 b=tLfdIwGaYfIp6Rji5CaP+ylvhgyzo8T1lKbw1Nvs/fvaD/UnZM2+laebTsh5Hkxmk0IGFcTfPaxCiBKfXlZTvrGhOvsNAXquTePMEVOeoE39032FekxkTu9pimpRRkx0WU8yvDfvHjxlBdn+yC1+N3TWkBvTiZe79zaj2ZbsOpo=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4973.namprd12.prod.outlook.com (2603:10b6:5:1b7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.23; Tue, 9 Mar
 2021 01:07:09 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3912.027; Tue, 9 Mar 2021
 01:07:09 +0000
Date:   Mon, 8 Mar 2021 21:07:07 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, peterx@redhat.com
Subject: Re: [PATCH v1 13/14] vfio: Remove extern from declarations across
 vfio
Message-ID: <20210309010707.GB2356281@nvidia.com>
References: <161523878883.3480.12103845207889888280.stgit@gimli.home>
 <161524018283.3480.13909145183028051928.stgit@gimli.home>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161524018283.3480.13909145183028051928.stgit@gimli.home>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR06CA0009.namprd06.prod.outlook.com
 (2603:10b6:208:23d::14) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR06CA0009.namprd06.prod.outlook.com (2603:10b6:208:23d::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Tue, 9 Mar 2021 01:07:09 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lJQq3-009t2V-W1; Mon, 08 Mar 2021 21:07:08 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0485f2d8-49c2-4246-5664-08d8e297a9e2
X-MS-TrafficTypeDiagnostic: DM6PR12MB4973:
X-Microsoft-Antispam-PRVS: <DM6PR12MB497337BE0EF0FCFC331A25A0C2929@DM6PR12MB4973.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vaplzn/NePnHi6dxy2vu+9B/jdOx+8clqGC8TQoNJUnydjAIyX6aWvFOh187EYo+Bcxl9JDVjnPT6h+pnc96lwuZoU4462yug2mdpK+Af3hKCwnsKeg0rLVjkM/S1EfEwSfr2txI0v0CN31dR7QjLbQo3xaWjFg1UcmeSj/Xqn5sdi5rGeinl1BXTxh6T3o7djVFvsLHbMtGkdgdX8UgSjfPr0B6gN1m3wpUdZf61Y6Bz+/MZnULIXpYv55nju/DB1klaXwakdZnfHd8ftK/g7ns/RPqEi8dKxD01EXM88GMn7wz95bogZOMcs/bycGjypuMzSo9+W3TdsBbUAJeBORFGQ/dVN+SuqibXkhFjGxWJvcCRezxsAezrhOlsfxMm+zoyYrKpL6KVri8eFnxLKXbvC5YRISjQbxeDhHGIPyzogpzQ0Of+hF3FA0DqFMWnUmwhUwZric3Gs8UbMlFVA0/8OB6USPVaApcAM7gmhBfNvT1ui25MnImdAcJxEQUF6+NZfItbI+ZZAVQj9Z7qw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39860400002)(376002)(346002)(136003)(66556008)(2906002)(316002)(1076003)(478600001)(4744005)(426003)(66946007)(2616005)(6916009)(36756003)(66476007)(8936002)(4326008)(9786002)(186003)(83380400001)(86362001)(9746002)(5660300002)(33656002)(8676002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?58W6V8+y+TaqCI6P0oWjtky2xxNGhx1M+8LN65o8PtlQeTcithqMtuIb970t?=
 =?us-ascii?Q?fk21gauDPHFTSNlHWsZessCS4Cvrw6GY+ZzfqEZYDTKNp+i94OkZEJTtgE3r?=
 =?us-ascii?Q?oyzhh4NrStWKD/82G2Wzxcod9PjtIfUuTyoG9BRhinqdodpu5QcYwiTKrgSD?=
 =?us-ascii?Q?aPK7tpSGp/0/UHJJVKfAUBNZ9qYcC/LnV76aOAtbQIOwJD+Kr5ygZ/PGchd7?=
 =?us-ascii?Q?TzzMDN4s73x0AF/5HDqRtG8yvWEkHGkD+fJwzlwRuGhGwTT759hEFRW8gubJ?=
 =?us-ascii?Q?sV7X1GmcOIJDX/Qx2W716cM2M9K7B8zJ9G1D7LJSYCZnogZ76JdpC/Y9ihdI?=
 =?us-ascii?Q?PWxH/33d09CjH7NCZhGOU/Q1vbRT5ZZUOdU+a1nsQfTbOZZLQAq3FEmlr2sq?=
 =?us-ascii?Q?970Y2Gu31M5cmH3k0wE4D7JgUf7POsybUKSaXN6y7klxsWrjEJ3a/XUFz85L?=
 =?us-ascii?Q?EAJv+K73aNJHCrxlrUsiuTxESWWTYtkFd/ENmwv7Eyu+eUNQ678fk3q2al/H?=
 =?us-ascii?Q?lLrFyBuUiOfDpxskWmfiVQFuGBBG6b6+krS9obaAshB0dpuvq6LGLT+TuCEH?=
 =?us-ascii?Q?7Me+dWQqujGEURZuF63OG+Lo7s9x0hda/AYpnSswNsCCgWs5rQbN80iFcMOa?=
 =?us-ascii?Q?DGM7s1vOtJn+2WljX809GKOLz0MYgHgC3WacNANLZ2RWDYZ19w69LX62fh5D?=
 =?us-ascii?Q?skTe/yoeotOJTLU7/W/CPKJRLdB8ST+P+EIAqUumJTulDh0WSBDj7p03IC6F?=
 =?us-ascii?Q?KC++OUf69tspt/lnwbMrNsPGpDvmJCsQMtzlamuY/vfg0Z94bV/6FCAQqn5b?=
 =?us-ascii?Q?oAvPDLfCAX2KNhJ0gtie8xaAvHcQO2gdbKVcWPmCrE1HzVdUSy85HpJ0VGI7?=
 =?us-ascii?Q?39MiWHe/mRbjELvomBeXaKTKywupuJD7oIWZucvHiSpH/hrJ0+M05Mf5v+wz?=
 =?us-ascii?Q?IdKeJ9Ellf+T8NdT8x9mPyeNbTC4ZGWlSbUOXhppjRrXdGZeLucXBXD4NjN9?=
 =?us-ascii?Q?EkxoyKZbqNjIH8z+nj9AyGUdTqYWOb27g95QnIivPNIKmBq5FuUcO2Tk95Zd?=
 =?us-ascii?Q?WB2xWNT1nwSItsayYcTlWW1bZmMrKIfvwPpHFXS7EUWvTWw6920rLffzCUpa?=
 =?us-ascii?Q?bkSKz2HwmjF78eTpoBsT7LglDy9XePvw7PqPCX660y/YsD3/SdudtqSs2mkT?=
 =?us-ascii?Q?egkBTpp4W03PbOimFFLk9lmf47Tn05l6F/1Z6qMgr6m0ONW3ZrYgHaNEkBMS?=
 =?us-ascii?Q?fx/AQbRLjsqqnPXhgrEgIJudNMbH4U/5okOitzptAMyEs3VWAj0lIWlLFezz?=
 =?us-ascii?Q?rlo19boy7PVAdQZFTZoe3U1uOXahLPtCvbaj/jAj8EwhEg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0485f2d8-49c2-4246-5664-08d8e297a9e2
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2021 01:07:09.2476
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oOC/A4QQD09iBteEulmG4l6dOGZM5nGIRUXvosn3xNADF/7R8yqul64ZftNElqbq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4973
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 08, 2021 at 02:49:42PM -0700, Alex Williamson wrote:
> Cleanup disrecommended usage and docs.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>  Documentation/driver-api/vfio-mediated-device.rst |   19 ++-
>  Documentation/driver-api/vfio.rst                 |    4 -
>  drivers/s390/cio/vfio_ccw_cp.h                    |   13 +-
>  drivers/s390/cio/vfio_ccw_private.h               |   14 +-
>  drivers/s390/crypto/vfio_ap_private.h             |    2 
>  drivers/vfio/fsl-mc/vfio_fsl_mc_private.h         |    7 +
>  drivers/vfio/pci/vfio_pci_private.h               |   66 +++++------
>  drivers/vfio/platform/vfio_platform_private.h     |   31 +++--
>  include/linux/vfio.h                              |  122 ++++++++++-----------
>  9 files changed, 130 insertions(+), 148 deletions(-)

I'm glad to see this, could you apply it instead of waiting for the
other patches?

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
