Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 703D4331C03
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 02:07:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbhCIBHJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 20:07:09 -0500
Received: from mail-dm3nam07on2042.outbound.protection.outlook.com ([40.107.95.42]:7969
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229520AbhCIBGd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Mar 2021 20:06:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iSdWkUt4O+mS4bWJ7gYrb7dXlsWVFayk/JA5YM0zNqDOAQ0GIq0StDrcfJu7xrTiAYgzgHSTq9nAm3wpnAJCWvOUM6iQuzXlXP9rzuoAzG7b95Cj2OmU14TzFCqnvGQDq2frCRhq/3+6gikqRlwPF9MGtwlCl+cc7hlpAcMAYeUrAq7L7wK0zGkqa8c+m6TQqDZK0TQoDLAmk7Zxe9VSbwGOGXkHJm4g4BO2meDGd916t0B/rXG9hLiA2VYr8ZZqMpqIqDqsmSHCosYQZQ4LEdFV6qwAj9eOKnS+zywS23RFuW0uYXvU9nrPnnmnVbihLfqzVOkG0yn39ry3fVdWbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8zL2m8dsSPytsXgkNWZp5jj6rutHX6IgW1K23fh8VqY=;
 b=efRIj6huoxzDcw9vqrvJt3L/TBatJez+7LLpmAwAVIMwa+2BlpKQCwysciiPOmgW7+QZDkTQiEzxc9Jr7rmPfEdHrO8SCrq0uOtV57AncpLPmHNXb6V0Uyh8Qs9FxdjUgHyUI8rSNG/AeWCAxzc2qRnMd5vH+R8QIzWHE05OLNWq+2XSsn3ZuFsuyV4Bk0KvuDwktDeZ8ngBGrjv5go/8hgKJF4wFLEYX/3+skkD0CzzKQrpQe2u4lVh97Ldi15MmxTDK76dssvttRFukSAz4JJI+/8xNG1hnL+8SQ4b13mJlAYzh7ewa7siu+0ixqLvYqmO44rQrYJJIyxh9k4QYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8zL2m8dsSPytsXgkNWZp5jj6rutHX6IgW1K23fh8VqY=;
 b=Jj//QHr49+Aw0ftJnC/iBvRB+I8oM+wq8M2xC9Mhy+N6f1EkaBbXnzfNZHLB7Z3lYumiuC5NhaJneX3m+n6bAD5OXCnpPjIwkLk2dXEHI9poOW2WNykS3mbMAPU1I8j3tgm0dsaHoLhN7hSEfU3J2NksdLFy155Z52iVAKFOcdU=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4973.namprd12.prod.outlook.com (2603:10b6:5:1b7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.23; Tue, 9 Mar
 2021 01:06:29 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3912.027; Tue, 9 Mar 2021
 01:06:29 +0000
Date:   Mon, 8 Mar 2021 21:06:27 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, peterx@redhat.com
Subject: Re: [PATCH v1 00/14] vfio: Device memory DMA mapping improvements
Message-ID: <20210309010627.GA2356281@nvidia.com>
References: <161523878883.3480.12103845207889888280.stgit@gimli.home>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161523878883.3480.12103845207889888280.stgit@gimli.home>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR05CA0064.namprd05.prod.outlook.com
 (2603:10b6:208:236::33) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR05CA0064.namprd05.prod.outlook.com (2603:10b6:208:236::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.23 via Frontend Transport; Tue, 9 Mar 2021 01:06:29 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lJQpQ-009t1x-06; Mon, 08 Mar 2021 21:06:28 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9fa0994a-a610-4ff1-6c9b-08d8e297925d
X-MS-TrafficTypeDiagnostic: DM6PR12MB4973:
X-Microsoft-Antispam-PRVS: <DM6PR12MB49733EBE17E414F145F24DAEC2929@DM6PR12MB4973.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gO8W6KmlozqcdrY9KQSdCU46yWMgKBSL9f8hwujI0L5QxQNBCY9cY4Zvf4ecuKt0DtcBfl3kcaS03teFdiP5YxKtb3n9EBINH2NvX3HsIkYvYBQupUjvPT49hCL0L2N88JXNjRtVAA0sS4eWe7CcQfku2zwCBCM3sKOOSYH0Q1dNEVHM6EeR0bqGgGcuFMXVgXPjFoEZ7rw6CXkDCD8jpgDzSAMZC0ghKyVEc8QKAxMpaPFsjrvpxXXxE9fRsGnAk1sEfc5KTCF9/wFO2uIbeaT8P5Hc6z67mlH4Jmsk/IwoM2vD6VooQ/Lv2ULeMgC+cIePnn2rVdzhTDMWWrCcN8AKIqZYLwxBTSLGR+C88bRyj2HLOsb3wVty5bdID6/pRA2+TjoKlqjdk/mivqvSgA4vMVhUfwOdZUjwCXVDK/RcWb4I2cwvuAr+7H4jsKbIcrFYlQcEna9eGu9DePeJSsbmu2/RBS2nN2PsmNNrYaxyMkompqqbIdZwwvvK3BOW1TPPIhCGdCAWZB6/acOGdg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39860400002)(376002)(346002)(136003)(66556008)(2906002)(316002)(1076003)(478600001)(4744005)(426003)(66946007)(2616005)(6916009)(36756003)(66476007)(8936002)(4326008)(9786002)(186003)(83380400001)(86362001)(9746002)(5660300002)(33656002)(8676002)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?4FZvA7p04lHz0FseKxMhTYeEh/kWTZdshXMSx/XI6C/wnrFzNQfIduIdctqS?=
 =?us-ascii?Q?SPYg7FSC6Kk6vmy7WI9/n74uIJiX31gKeXmnMmVf7VBc6DdGhMUp2CLGVdK1?=
 =?us-ascii?Q?5cdbBEgCw98znSbBO5dpMXUk7fzUWyVEg7DoQMRsp8wyDyR8L9F3lTgTy9i4?=
 =?us-ascii?Q?3PTRT72URaPCHPuksbTZu+ESIcq/NY6vLiu/i7JBX127Sb4kdX8ikGDoJr+d?=
 =?us-ascii?Q?wi1hybBnBL9oYW8z0i6yyCvi6H+00W7KUH8tE5ayTfPmq2NC/V+CalkkIuWm?=
 =?us-ascii?Q?WiDoU5XX9P5VrJgX7WbL4yO6V4MlaeN0UDmPX+zQQyQ6zVZPkjTKJMSFqGox?=
 =?us-ascii?Q?k5sOw5rTlNNgf7ilF9zriQhwDiBbx5KdNc06/YWiuBGu04vmaB3zfJE811a6?=
 =?us-ascii?Q?TiPgr/cthAnj4oLqV/z0HVKtW7kWv8A7gXhoFpaOIY6y/LqCgd/c6K4mJl/3?=
 =?us-ascii?Q?AKnkOuPmT4guQWIjLA5TiIM4WqTgncWjMh9r4n029RWxPLN34rop9jiukAl9?=
 =?us-ascii?Q?iMbNYyKkpt33gxKRphYlSx+JhNN3tgVOGYXjfPGKtADpl2S6U1tFZgbVBA9a?=
 =?us-ascii?Q?NqZmmS66Z/+1YebzRAdIUKhzi4kfy9tXd+bGgr+BISMFY3l6rFe1XS1m91kR?=
 =?us-ascii?Q?bUBOC7jZNhYqIwc4C19+BMLlx8QFjGwDu3YKF7N0Xf35Z+oTHDn+85kb8JKR?=
 =?us-ascii?Q?wnKAK/3IBBxkTvjAWjfCN174RRYJh5yeXJHJkBZKTNRTVji6RvffWKkzQPhm?=
 =?us-ascii?Q?edbc2FB+IfRIeX6670ls3cr8DSMT5CKqP0H2Kv6NK1nsmYK08AjEVPYl2+6B?=
 =?us-ascii?Q?uop/S+Pdw7rfiXXCZKLgcjeciVW8y8DYPZcDfu0u+djiHj9E+zIs70XfVyw0?=
 =?us-ascii?Q?4RTKZUdNqzc6I/F9uSPi6b9HbiFKt2EK1mOy024ys7ydKjhTD8zMegdQaZWO?=
 =?us-ascii?Q?c/eZfwyS4dnv9ldpvYfPIwaFnaaCBOdiJG/9HXDwJggQq9YisWLDv/d5BWmM?=
 =?us-ascii?Q?4AjxsXegnlTBL29+X8g90dz2U5PbXK2aNjqmpyYTeCC6Bhthl+//fxjdJxe6?=
 =?us-ascii?Q?Kv7zyNv0LjiWCqGPHw0vU+CtXQtRd3IJhuik0yAytlJZbD6ts+9EDBMld+Fk?=
 =?us-ascii?Q?2l/ibqHlfIAFXy91Bojni7DiCf0k0VsEGKt2AIzzZX6VXs9nrI1n8q60zdqe?=
 =?us-ascii?Q?fP0jO/vINXe7djAJaICUR3ryqdKmWVAHeBo6x8m2lrBd8xPXvKO2UIbW6j85?=
 =?us-ascii?Q?ocXiBD0dtjiZAjhoglah1+lETpMeGNG+VFfdP60/tbKPfVwdXMHP+HKYeqGw?=
 =?us-ascii?Q?ZkRH7q7moDJ0Eh/oBMYLcfzBVl+9c1YCb0otug/5v6wy6w=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fa0994a-a610-4ff1-6c9b-08d8e297925d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2021 01:06:29.8179
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wK/6B25F5W/tk3ennArKpXKgy8jYKQqHNyA+miB5ruY2d4reTNUAV70WhjvWBiaw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4973
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 08, 2021 at 02:47:16PM -0700, Alex Williamson wrote:
> The primary goal of this series is to better manage device memory
> mappings, both with a much simplified scheme to zap CPU mappings of
> device memory using unmap_mapping_range() and also to restrict IOMMU
> mappings of PFNMAPs to vfio device memory and drop those mappings on
> device release.  This series updates vfio-pci to include the necessary
> vma-to-pfn interface, allowing the type1 IOMMU backend to recognize
> vfio device memory.  If other bus drivers support peer-to-peer DMA,
> they should be updated with a similar callback and trigger the device
> notifier on release.

I only skimmed it for now, but it looks pretty good

I need to sit down and take a very careful look at all of this, my
rdma address_space patch included..

Jason
