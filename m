Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6660A53BE65
	for <lists+kvm@lfdr.de>; Thu,  2 Jun 2022 21:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238392AbiFBTKe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 15:10:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238435AbiFBTKc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 15:10:32 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2059.outbound.protection.outlook.com [40.107.102.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9AB5B4D;
        Thu,  2 Jun 2022 12:10:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lt6VVA6CHXCDY1hHINeD62XJiKokhVrAdqqbTGjyPj4himzP4A+LbOCzYe9Lj0gKPlghJcvxgU6/Ajo8kHxGfhW4NUJEOy2yxWga0ozug/Q1aLRXWPl6CwMxfsFs8BKUYxvVZgLt1L5r3GkjJflCaqRriazpq7E5kr7R+ryjUrvKQ+v1ToFQfuUZjLj58iCj+9xq0iup5Eqve2VaRCvucx5SvzmkHfJTK9Qc9s4WRa27NZkFN26RsK7tgHaHcC3NG6Rd6W+uGH6PSnFaXd8T4fFX8+jBMZzufXXEu7mlLmZL7NtxgVMspt1bCD4Oz/tf6+0XeGRy4I0g/6HGR/B4Zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CKl0Y+VhXPh9NKgXcJ0wsREGDHKDmwgLPP0cDnx8GKU=;
 b=FCjrTcBamptev/4V3EblcaveZ773j51q3iQtoQ2F/fQJcEaEDT6pdYQ/HpU2pZeYhSQjr+0hkqJ94vv9JkKHJDuOc4Man5gAMq6X1CdX+SnxZVVPzNzXZ4n/sNf0qLZ+8kPp9BnqVIwsvvgxFK+zQ0E0b8L9UbPjp5w6ufZ8NlgUbN9JK8rkfUuM+zoZ49lQ8PnVBicZnmvtxabkmzN434qrAL5YwnX/Z8Ghv3isUOJ4n7LOkR8dw6JFUupXpz0UuN3szzRnsFmU4TriJ2Ul+J21me37h+F9VGcuQ8A82zm6sbfEuMnuJ6llX9HicBufyffXPxMW9Ac9j+rnaiPk9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CKl0Y+VhXPh9NKgXcJ0wsREGDHKDmwgLPP0cDnx8GKU=;
 b=Xz0PBwO5gQ9bOXeI8L/byL+4Yba150expHg1wX9Go5thmGLNOqRkGzEP8dFwbz4VwdkgZ3bMYgwillX3iay5YxqBlNPFk2wnTKDbR7720uC6YzNt4nH+Fm5yKdEdtsfjQthSfCPJZCgTtWVj789c4cX+739jqKwXHOeczkgZu8bIC1VYwbX5NyPM0QnxJIq2c+WTqE8XR4jaMJ5EBhYZztyg/6PDjhO8+rM1UAiNDmCdd4/3Evyh0keogDah8xHwR5/93npVVK07wDVhoc1b7K78C80pttr6PuNEb5PBgoAPrf2g6o9zWchVUquzSpt+yDJ/qCpgAP3NDQQ7RkoKIw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BL1PR12MB5174.namprd12.prod.outlook.com (2603:10b6:208:31c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.12; Thu, 2 Jun
 2022 19:10:27 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::2484:51da:d56f:f1a5]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::2484:51da:d56f:f1a5%9]) with mapi id 15.20.5314.015; Thu, 2 Jun 2022
 19:10:27 +0000
Date:   Thu, 2 Jun 2022 16:10:26 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Halil Pasic <pasic@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH v1 10/18] vfio/ccw: Create a CLOSE FSM event
Message-ID: <20220602191026.GG3936592@nvidia.com>
References: <20220602171948.2790690-1-farman@linux.ibm.com>
 <20220602171948.2790690-11-farman@linux.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220602171948.2790690-11-farman@linux.ibm.com>
X-ClientProxiedBy: BL1PR13CA0212.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::7) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 91295b09-4bac-4435-5faf-08da44cb8de3
X-MS-TrafficTypeDiagnostic: BL1PR12MB5174:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB517493D14C099E73574DE2B4C2DE9@BL1PR12MB5174.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Jv35JGXaZFkMoOEDxw4vMRQNrzVOG/htGmEfHXkJdhT/AzVgGDWPEcPAA21T3O3hu+VIwGKDc/2SgAEGm6cAeSfLEML/jE3nqgYlZoX/lfkgODwUAhT3nfuvUfPtggPRy6iBjU+U6MX5StNeiV92MsgKaLdaExyfl4AHZnzQ6YMF2AuX80TBbrtuNx1FOuD7RFUeIheRGnd/CKs3at9A8zhUpv1taDLgFFVhTt/V4/icKdbmkhf4aDWEMm1djoXpqs4O5cDLWzMT+wPq++OAn3x8sMbCmwMcUFIbBLvTn/9U4fRSZ3jUL3QTxrOUFzA0G0LHX6ZHpMwJZ7YsF4UQn8qLrQbleYXQYD75bm+fPhcE3jUEAwz99UznsMAdLP6BYpwn+xgQsLNTANfF6juV3Sa+XvMM9a2gng/wNLmNhHE57kL/0nP1KFnU5EhbO/+dtJ9igUw1JtYLZ5FGfHi1EAWU7u9S+cgzLDXZpANSslDkDV+pVUgAvKglcRyvcAFBmksGlUWT+60kRWk1lGIqxWGDbjmQLjDeBjGoj9YqluokqFNKtSon+JDNB832QnpUCRXnp5UThe+sdSekq4HV5ZbvDhQIGc8MO8xEvp2ddHGU98blc31LIxx7aMWxgGOqzPQMTlfkGNemA4Ziqn667Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(6512007)(2906002)(86362001)(6506007)(36756003)(6916009)(186003)(4326008)(66556008)(66476007)(66946007)(316002)(38100700002)(54906003)(1076003)(8676002)(508600001)(33656002)(4744005)(5660300002)(8936002)(2616005)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?T858yznyjaEtangQ7sMZpTr8pyeEAGXackB8Zny6ghNt7BTtSsgCM+PVgTb1?=
 =?us-ascii?Q?drV8bBeoOrIRZGlF0RzlrkjEpeH0otiVO6TfF+Z9EqUovgYBShhV4f4HdWQp?=
 =?us-ascii?Q?NnoBFLEINwkwuYAPf4M6jO0FO0/DJuBjM+Pe6Fm+fSUYs4YMa2rrBNkB91DD?=
 =?us-ascii?Q?h5bHTYYwyF5M4qsO8HUYO89UO/NnfFvxSeR+brOgL3AjFBuPxUefcqHe83V4?=
 =?us-ascii?Q?lSkQNaR2f59oQut704X1j+exUhkCEDu5KDa5FTUloUZlkCxufZg/Ilql1CVo?=
 =?us-ascii?Q?xZ2dHayA2crYYteP4cS1HOFud/nM/UqMoK8nCB+Y512mWmZr8h7AeJP/0S18?=
 =?us-ascii?Q?mDAZHObafBeCUcPbVX/JVPDJLPZyb4m+wCCWVxlE/Frp1yIY4aDFb9BpyYX3?=
 =?us-ascii?Q?cU6q5lfa+2LaZ3m5ZRwBSYHs97Vtmd/5sa120azsu3YtNwhoQtjAk8w7kB/M?=
 =?us-ascii?Q?x3QagEvnyUfnc+CeHHcD2XwCEeA2xTydKb6NL4xPi15a8H1IvKoPbhUW8b4t?=
 =?us-ascii?Q?DxbhucS174f4E9wWdGwFARF6/Xd+YIG2PHOE1TAbdAKC/x6U3UmT2JozHttH?=
 =?us-ascii?Q?ENJBKENmKYdrcsIbkYOQ87kARjCibujAgLiuxVz2EAwC3v6FIcMIIQbWKYdE?=
 =?us-ascii?Q?7e53Gn4P3wMCm+cEflgERGMEP2Onz9zun3uWb9UiFxLFgmveb+sVsB9iZJ+E?=
 =?us-ascii?Q?myN+/gMwlaKVqSLAC+M1eqTbMgSBrmYtOHk/uMz9Tfx4AS08hUBi1S4gJV2Y?=
 =?us-ascii?Q?Vp6bZn74LKZlrjgV9wBfMLSVy34O9daR1xBn25z/j/eiXK/YaCHn6X5AislX?=
 =?us-ascii?Q?vGkQkFii1yeJRaWCoZmXzz4Wb0dYO6MutkEYrdMgbxcV1JF6n41C5BGWAekF?=
 =?us-ascii?Q?zixkT0EHN7XZDFJ/4QnQBR/6Htt1UukwU0g2FWQOVuejjLc1LpOokyJZ7jFs?=
 =?us-ascii?Q?6P+XkvJhxs0L9X6u7hS8qrZJFnVCdmvfKeuMi4dAgR65eSgZCADCzF+rMf0L?=
 =?us-ascii?Q?0JF0oTEV7uBUuwH2djySDbHnQu3q0aEJva0zy90Pzl/EngKNdOFtWEdas5P3?=
 =?us-ascii?Q?6PsYORZCl/r7JS6o/31607kBXktOVX8MyYPpZpZUQOvlXC5IfXDxHL81nQPY?=
 =?us-ascii?Q?rdacE3qZZ8UsY2kudkrlNGnq8nsC0tzd/YJOoAU8sgI9QD5EoGqAMyBVtvt5?=
 =?us-ascii?Q?a1acXRBNN+PscJgJIYKE1+xiLbNtkvex/D+Ch1mrYPbYF77lyHoqr9HHbk1O?=
 =?us-ascii?Q?mF5a4t7pV7mzoJSo7qp4qxU4+hxH28PA8o5yWAOyMvurUktF1vUw7bgrDsdk?=
 =?us-ascii?Q?XkT3uFQKkiIqMLNQiQJtLfSKSFGrGfXicnrhdI4GcISH/gkHYNWG4FdBofvG?=
 =?us-ascii?Q?u3DG4WwpulD6gEBWghv+1kWH01le8Bg0p6LvP/7+9u7PZBEotS48+HhwGv6T?=
 =?us-ascii?Q?BQNbuyOwxnjH4C9kNKC0Yy0pIffB6RorQM2qyjfEC6WKrvJc1hmRtNQX3FyK?=
 =?us-ascii?Q?m5LYMYWGjtHyQa58mnbQVOGufyCgzNuaB3CBPMZWrJLtU4WeHKietVH6usbr?=
 =?us-ascii?Q?eIbRimE26AijoHa+3XeBY2xGG5opQ+KqCn7V/hBM3PiCmyij5isALUY5xXXX?=
 =?us-ascii?Q?s5X48eDpNCp23YUODpfJD2Y//bssBRqlPWUyWdnpPO+4ANy53ARfd9Gkeh+I?=
 =?us-ascii?Q?hBdwH3vtDkOGnZSlPtWeKKJGf2kcqqr8Z+Qr5juJj4m/5Vuob5416vtT8j1R?=
 =?us-ascii?Q?TnBqrVt5nw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91295b09-4bac-4435-5faf-08da44cb8de3
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2022 19:10:27.6822
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZSsYs9iJODY3ebVPXdO7l5H87OiM9NP6fAEkQWMpVwfW8l1M2HwBTCKrSGR2vcuD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5174
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 02, 2022 at 07:19:40PM +0200, Eric Farman wrote:

> @@ -278,7 +269,12 @@ static void vfio_ccw_sch_remove(struct subchannel *sch)
>  
>  static void vfio_ccw_sch_shutdown(struct subchannel *sch)
>  {
> -	vfio_ccw_sch_quiesce(sch);
> +	struct vfio_ccw_private *private = dev_get_drvdata(&sch->dev);
> +
> +	if (!private)
> +		return;

WARN_ON here too

Looks Ok otherwise

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
