Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD6935A4A9
	for <lists+kvm@lfdr.de>; Fri,  9 Apr 2021 19:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234309AbhDIRcd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Apr 2021 13:32:33 -0400
Received: from mail-dm6nam08on2040.outbound.protection.outlook.com ([40.107.102.40]:30912
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234150AbhDIRcc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Apr 2021 13:32:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nQRcGwrvF+517y5oCHmI4NvnnxDloRf4C/xAoSLP2uY0IStGCzjKiNDHWnWnzPDVuloEST9WEbMMuY0hSmow8uXlLt3lYtY4z6Yy+ZRUaOSOcNJ3h9EbWWfVej4VJw9CbVT5HLaDnZBry5gvpP0oux6tpAQLGyYgEwpjwCBwMOdlwwiEfoYsWWE5LzR2SLgpTMS+EWuUVbb2TDI1B9zjTVl7+TfaHUVxlQWEenr1g33voCq9+CF+qv41X9om5DM43G/b8QdD42D4403Rn9HAQHOm0xclLT9e+nBwEhWeONY9gNavGb7B5fGSFpNzzDqpLd1CRhF72MtyPg86fGPuQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ellk4W0aul95RedaH8+BVgT2YEJEhqTMvB+watE/CqQ=;
 b=YDEbsBWHJ9fP0wbDyBiUn+FLmPf2i9Vuemk1LbSCKwuy9gqIBdiqfkolTBlEGG1fogJ6IUToRbEqyepN0T2Ajp30xgU4BLaMpd/btJszaJtqUoaiFiWsyGOGAx6bOYuB2M+VwVAgVHEszVQfitoNoGAJxJAmjq9w7BOOBakqNd6bADD8BWJ3lZcD7gsr1h4v5dOJ5AUi5VkVr8Vgxy+/GBvVXNDDzdEnI7tB9+Xy5LiHWtb2oBii0wF2T4sHpYx3rReOKGmyFVAxmRrvrJHkNARy5JZuHEbpZWct9kp3xLiFal35MUhFUu9LeTuiOtz+g9Scv0rRcL7T/ryFkF/gpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ellk4W0aul95RedaH8+BVgT2YEJEhqTMvB+watE/CqQ=;
 b=R5hKed+55I/nwJ2wTbSu+WdiEtFkWHRwsLaauKT3UxmdFvFvqHknYsBkPGmFvIQzqTtNuqrUULXUS40mrlMjOZMMEUzkjf5y/8m6hUSOWrW9xaWI/8AXWNbBhfdIAIB5sV0cB70mgUs2CM5HCSxYENW3uV8qYT9+MkmWZCCeltk96TZPGJALvMJZHRQia6YTUYywUwkPXgbQ3UR3RFfI5JVApmHyAxF+Ym6o15ghagE/Mx0iDUxIQhjWQxqHmk2jM8NLb9VapX4Af6p87jDY97fQOp6mW4yS6JbBFXvHwW7/PwvqJu4OqsD98gWQWCAlWMyTNZa542I8kdeYDfymkA==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB3827.namprd12.prod.outlook.com (2603:10b6:a03:1ab::16)
 by BYAPR12MB3477.namprd12.prod.outlook.com (2603:10b6:a03:ac::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17; Fri, 9 Apr
 2021 17:32:18 +0000
Received: from BY5PR12MB3827.namprd12.prod.outlook.com
 ([fe80::4c46:77c0:7d7:7e43]) by BY5PR12MB3827.namprd12.prod.outlook.com
 ([fe80::4c46:77c0:7d7:7e43%6]) with mapi id 15.20.4020.018; Fri, 9 Apr 2021
 17:32:18 +0000
Date:   Fri, 9 Apr 2021 14:32:16 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Zengtao (B)" <prime.zeng@hisilicon.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterx@redhat.com" <peterx@redhat.com>
Subject: Re: [PATCH v1 01/14] vfio: Create vfio_fs_type with inode per device
Message-ID: <20210409173216.GA7405@nvidia.com>
References: <161523878883.3480.12103845207889888280.stgit@gimli.home>
 <161524004828.3480.1817334832614722574.stgit@gimli.home>
 <d9fdf4e8435244be826782daada0fd7b@hisilicon.com>
 <20210409082400.1004fcef@x1.home.shazbot.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210409082400.1004fcef@x1.home.shazbot.org>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR02CA0021.namprd02.prod.outlook.com
 (2603:10b6:208:fc::34) To BY5PR12MB3827.namprd12.prod.outlook.com
 (2603:10b6:a03:1ab::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR02CA0021.namprd02.prod.outlook.com (2603:10b6:208:fc::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Fri, 9 Apr 2021 17:32:17 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lUuzQ-003Pma-0k; Fri, 09 Apr 2021 14:32:16 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2d54038b-0620-4fb0-3867-08d8fb7d6c3a
X-MS-TrafficTypeDiagnostic: BYAPR12MB3477:
X-Microsoft-Antispam-PRVS: <BYAPR12MB3477ED464586490671219213C2739@BYAPR12MB3477.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TBtuUdqtb12QvXQoGUyt/uw2XnE40Tn5hijkyX7DLhaMTJ7VViJqphXMdDH9IqNznM3aEcEOdlggrmangcedbL7aJCZZvsKFLmf6wYgDiwQBv+QdtDZqoVaqNeEWk539YLjQlAO7GyBRi4sYcjWGcA7XBEGRQfYRxarqKWlkcLHFa6EtEmgSU4OqvInkwVRV5AjyUjyxgZNFC7rZSBGGBuHe4Z4W1U56j5P9Uru7ZJSCK66BWHzDnhquSdAlcXDOh2/JMs/ou5cyBTLm1Job5gJutf/+AOcQTUgzeqFr7rOQXnz3wwX0NzkjkX/BTMIWVv4O3ho5nVLNbCHFr40JzkH940EtmPBB8slVQC2q6F2bvm/iQxCpnB5K3UrWe2YGhj6blXxKT92jHUYiup5MJ7WZ6hp+C/HM2wYzubU+V/pe1v94u4DsHI/9ttS8u43uyFpA8B8ANurJ0lMQtIzy5REyNuNr3xHb0JE1h6aGUcMCp9lHZ8pyz03DxoQu/MOjYE6kpB3T1g9Og4qSvgV3ytB+dBoTAg5V1JxghwbCHrqU7LDNovFdFZkIeClOShC7roYmY0SmYzh51c2NWWn1q6/XI02nUlA8ecwUpDNj39z/1fV3D4fiR5Zimn5c677URFuUBe1hlqypQwpCYGNZmagc/knE1+fJtuBgWpYqr0k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB3827.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(346002)(136003)(39860400002)(396003)(2906002)(9786002)(4326008)(33656002)(26005)(66556008)(66476007)(1076003)(9746002)(66946007)(36756003)(86362001)(5660300002)(186003)(426003)(4744005)(8936002)(478600001)(6916009)(8676002)(54906003)(2616005)(316002)(38100700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?u097bstpxShwQ0wd/qJ1EM2fmOH0w0omJ2m3eEbdCs+fBgeduGp5tcc5B9o2?=
 =?us-ascii?Q?ff7ehKE3/kpM5W0amIindOy9kls/zXKNvlvwoR6yNyU/HI1+nhUz0fxo2K5v?=
 =?us-ascii?Q?eOz6SlWQCSZimpP/djrAa324kh0aGZrsOsyhxhzIHqzu1xLs1u06f5l2mlbW?=
 =?us-ascii?Q?/C1aDHiMTj76h5mGA3wDZj9ttym6ToTAgoSrzGU9eFnfJ4xafeMXCEhIAxIU?=
 =?us-ascii?Q?lEYCtSGJcTbRm3iZrPY7rsDo3YHWILVEk2NjqW2ykE/Q02/as0EM8apBXbz1?=
 =?us-ascii?Q?dehZc2B/Zg3zD9h3SoTuDmoSC7CZBr7h9XvQUg/vp7Fkr3sM98RRZUdAU4yr?=
 =?us-ascii?Q?SntInsjVjsMl+vKPSZ8JxZZxjGIftBR9D3YwBftfX4QfCv9kq4IFx2Fa8rks?=
 =?us-ascii?Q?Pb3hdiwAES1hqLGitJe6t060sKJJcOkuij7te0JD/qfnn/F/KFDOT4yQwuSz?=
 =?us-ascii?Q?iOOBi/sg4jSsGA8ugFsYI54Lzr9UCIoSSW54UUtr3QVk1aXfvcwKA2vXEtEF?=
 =?us-ascii?Q?YTLH66NtgUcXjiQm4JRnjlCGZatVeFLEVuDh01xmNXOd9KHbSqnW/O7ZEYGg?=
 =?us-ascii?Q?HqdeAjIxX6yHJDDK6cvMOIFlCl9YOPQtzp38iQoDzF3MpMHYYuSNQbjxF4zT?=
 =?us-ascii?Q?ak9G8QN9B1BMI3UR/RmdOkUa/lIlofyBed0mgopQznQQ8MxFrOaA5lhOEqIz?=
 =?us-ascii?Q?pySpfXYAOHNY71689jw5U/oxCKvz7owDkTKOa7Qx39oFlDnfRieVPC2GONfq?=
 =?us-ascii?Q?Cp4FmDl+UT9f0uaw+SF95QCUS7rnozWrvHzipBwvwiWOhMlD9L5ImXT2FPaW?=
 =?us-ascii?Q?vLbCopjnbNVFFWbeBT5DKOBYxOiW90rv9vhBi0V7Yrlcmua9IS3HZ/ymR1Tf?=
 =?us-ascii?Q?FJ6jHDNkCao/YMDeDgdWjOB/lsGnV7pcUYXP37imB3Sya6Dnzi40BbdlnULs?=
 =?us-ascii?Q?D9hZNb9KW2WO/PchXnYaTP9sZrkVwfMFueGhLZtBiryxRp5frmZ19ucSTLPv?=
 =?us-ascii?Q?ZQSPaHB9rdiWGmv2gzr+57vqZhpT9R0uJA7qP+gPdBL9Tzr67HJRpi5p0jPd?=
 =?us-ascii?Q?W9ulwESEUZAXP6SCDqNsIdXVAdjda2OZeFTSsWq8fR1PA6UTZSaBdqUgaKvV?=
 =?us-ascii?Q?9kK3JvomJ0YogRLDRLmV8r0tvxN8V1aCTifzfDIfsLcxp3ZdSaRAS73ch3If?=
 =?us-ascii?Q?t+eNQxfw1daMYVsUXVGwIf+l8H+6aVwftrcyTZdZKjWTlwXm82cYkzUWV65T?=
 =?us-ascii?Q?76FfRElKDrpO0un86YQyesW9KDS+DvxYLpNquek5DVmCPmVrYQk/MuJGJTAY?=
 =?us-ascii?Q?G8zz6AFDRqjOWi0Hi6mIqDap3dI3pLq4oU/PEOyvXsDooQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d54038b-0620-4fb0-3867-08d8fb7d6c3a
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB3827.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2021 17:32:18.1192
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +H+JzQ0yv7VC0wb2hyVv1k6TrZHW+DxZm/Z9pqMPnADwJrIyc+mpJhge/Mpnx8mi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3477
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 09, 2021 at 08:24:00AM -0600, Alex Williamson wrote:

> > >  #define DRIVER_VERSION	"0.3"
> > >  #define DRIVER_AUTHOR	"Alex Williamson <alex.williamson@redhat.com>"
> > >  #define DRIVER_DESC	"VFIO - User Level meta-driver"
> > > 
> > > +#define VFIO_MAGIC 0x5646494f /* "VFIO" */  
> > Move to include/uapi/linux/magic.h ? 
> 
> Hmm, yeah, I suppose it probably should go there.  Thanks.

From my review we haven't been doing that unless it is actually uapi
relavent for some reason (this is not)

In particular with CH having a patch series to eliminate all of these
cases and drop the constants..

Jason
