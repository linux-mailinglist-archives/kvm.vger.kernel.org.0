Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D38125A7F8A
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 16:06:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbiHaOGc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 10:06:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbiHaOGb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 10:06:31 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 480F3D633B
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 07:06:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GjxWamTxMu+EkukopPsIMnVmuyWOG93I3VEC4Titz1RavlR8JRgVwkd8exXbC+AULyo8gdpVLbnOrP+Zb+6u4TIuvqQrwWaJFYSuTts2X+t93I7F1vnbLihZcFxwRBM31rBQuW1CvoKi+hWrIKNLrmJoUqVfO+g1YX8fjUwrDpnVt80UImwMwp9B3jhQHqMFN9fYkNhnJvBxZFagfvxbQkFCJeKmJ4KGWn4w47RdUL7R0jRo0NY/fImY9MuNi9y4hdOyOuYV5ma7U17CXYS0HxT7EQ16O9xamjrj3wPuz4WxyHsOtFhdGWXhYlBDHuH9cIK9hoR7W2Fj11bM9Kw2Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H9pLELFutim5dSLKbcQHdfrMpkfrI6sovqzx4guPNuQ=;
 b=IYP06o8eI20dCzVIkVImrihG7g0RQoYU9Bezyf0gK8ReWZT7UacYC/+V1atly1vT1NeQWrayVGgazDh+l1tQZaPZqB+HadzVSGhKDrpL87QPvXV4evnEZ93izUKiZ55ze1eMC1jm+/rewz0n4RmFmFySAVe+3A8oW4jXzsWYuA9q8yCO1n1E/aYzpbLUxM4Ct6Dsf8eA95IPVl/F7uZfPoG1DC4pWkME8zgqie6+Ci3lRGHPiMaRMCRAXkuDakJ1vNLMYbppCaC53aM1iaWo5moP1edZbAA0H9UcNvJTAmpGVwkWTeLAVvqChMJkwV/vkBNV6SFtnJp3sBZVySOu7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H9pLELFutim5dSLKbcQHdfrMpkfrI6sovqzx4guPNuQ=;
 b=UKJYLrsqsN3Fc8HHmh9cDf8GSWrHBe1y1CQ8GyDLChuTLWuvaSKXOrVTHoxQmoxgpa3zNMcjFzIxCFkzqFV56ZvtfKxedw9qG4ayzL2q2MGJ13or/0bTxbpkPGJ9bBdyIy9lLPS+8kVmxJJVVnQ/OtHthFni90BJpxkx1ja9yBQVm7ZJD4tN8VpKVSEAeYpOHTTbYF7J1P4nTFtZ1KeDJkLAreNavnh9K/AzJO3fIDWRG2Cfa6U7CQ6JAK8uHcqWMp06rGeRQDwDbXafV5dHrzKodpK1UyOHWlNVuYrb3q8VpQY+qdEQEDSWy3sHLxArkpM0qCOLt1ZHGDuHknvN0A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH2PR12MB4181.namprd12.prod.outlook.com (2603:10b6:610:a8::16)
 by CO6PR12MB5476.namprd12.prod.outlook.com (2603:10b6:303:138::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Wed, 31 Aug
 2022 14:06:28 +0000
Received: from CH2PR12MB4181.namprd12.prod.outlook.com
 ([fe80::3d9f:c18a:7310:ae46]) by CH2PR12MB4181.namprd12.prod.outlook.com
 ([fe80::3d9f:c18a:7310:ae46%8]) with mapi id 15.20.5588.010; Wed, 31 Aug 2022
 14:06:28 +0000
Date:   Wed, 31 Aug 2022 11:06:27 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc:     kvm@vger.kernel.org, alex.williamson@redhat.com,
        kevin.tian@intel.com, liulongfang@huawei.com, linuxarm@huawei.com
Subject: Re: [PATCH] hisi_acc_vfio_pci: Correct the function prefix for
 hssi_acc_drvdata()
Message-ID: <Yw9q4yLVhHQiwMSl@nvidia.com>
References: <20220831085943.993-1-shameerali.kolothum.thodi@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220831085943.993-1-shameerali.kolothum.thodi@huawei.com>
X-ClientProxiedBy: BL1PR13CA0341.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::16) To CH2PR12MB4181.namprd12.prod.outlook.com
 (2603:10b6:610:a8::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b0703761-c478-47cf-34fb-08da8b59ff8f
X-MS-TrafficTypeDiagnostic: CO6PR12MB5476:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qZRvyerEx8iD8rsRppCSxLTTRcv2P46RxHwvba1J1T4NJJDNy31ODlwPknWqcp5NrV6gfvjhohNawBTvqujuiCNf+4FWxDJ0+mbxyYzQC0asVyxBRAnQ5CDq3dkzWBhmpZ+YSpBs/7LPF4h7qDcfwN76y5dBcRBsPMU6sAZJRk1LPRekl5qtnlLXoRj9SWiSyXaZm47n4/FDt6ncwEKMLLdp9oh/beXuk8S7pGrN/ff+JIq9P/4Lw7JJUFCXMVPfaFEjPlcKkDMKc4MM89a2TI3OlkcFzm0Ch6dxZGHfFItYcrQOL67BGDymQ8ZLOiaKka6DeXbBZNNHJ5vSdGNr33rEV55bKDT2pm0IJ6BdiGYsNslMe6eSaQj7LXG9zRbjBKkg3bgAJD97NVeXJn/ZC6PI82opG93tFHHBSlg7l/qWoaUFw+pJw4Jxl+8exSy6sE/FLdw7a76Y/YklxCy72h71psnzvni4G/venpodMcA59dmSe65RBQ3hBkdx3hGY9Yh/JvRJgV9zw3QPnho6/OSngH7uHXjQwpdPife+c9viFBI8RKoUApA+b3b+SSRSm7zFypd698XwqJDLfCgCqgN2mv0EzSCGE+WJMiHfprdeT0TXC1qPaOl87ZLi02j9LNpjhR5yeQL5k9wryTLUgAAhYerTKUR+lk0SB24a3bCB6oTVStfjbr8nEly6gRHlzoDKWvK74FjmtBKAgkyOng==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4181.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(136003)(366004)(376002)(346002)(396003)(8676002)(4744005)(4326008)(66476007)(66556008)(186003)(2616005)(5660300002)(6506007)(316002)(41300700001)(38100700002)(66946007)(36756003)(26005)(6512007)(86362001)(6486002)(478600001)(2906002)(6916009)(8936002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zF7vsaDnLJex3BQbd0u6pwEROsNotoWwIEV7FJfIeH7KILhYICEKnhmChPgH?=
 =?us-ascii?Q?Qcvx1QOq1nSaKgdA5G2XYF90yq1nSA5Ikpnbl5ujnfbDRgdKg93d+sAAKOq6?=
 =?us-ascii?Q?xtnBZzCX9ADCBHV/Q5r2S1Pun9xTKKtxmiLyqz8w6Q70TsuWgExLTs0jYnGB?=
 =?us-ascii?Q?FeZnS7jH/Z1QQFuh8ByJPXvH/quCagCIiHsXi0IPrn9YocXViaavRaOCe4Tw?=
 =?us-ascii?Q?p5F5EYTLCYPXwvVF+oMQkoXPDEFo/WRd+Vb6OXeGSU+NXcRd/Uq3zn4Qj9xk?=
 =?us-ascii?Q?MCYtXoNhDIRosCq+joqrvn6Zabo7ZkIVGKWRVgZvqD8tOj7JknZC+S4ZmRyb?=
 =?us-ascii?Q?pox9EwG5kV0q+NDqSTofgmawAvgwXJpTIRNzUJbWSHupmjDs9UcuSBmmsdm8?=
 =?us-ascii?Q?wsadhNpccNKZBO9JROrjq3bIxe/6y9dUm2BN98zj/7iC9DvNZbj647iihJEc?=
 =?us-ascii?Q?vsh9Gs6wbKFj3Cwq9lf22Z9UtQGok8eScMMWVPdBS1uHVmNh5ftEXTD7J8RK?=
 =?us-ascii?Q?omb9VSXiF0JZ0GwZD+qukSs5LhqEP+e5NJz04lY46jF3lUWFA66NziQsTF22?=
 =?us-ascii?Q?wtVDpBv/5isz2DOc07ru80aT0YtozCBAmgR7Jv64ryVih49IUjBTNrdPbbhh?=
 =?us-ascii?Q?IgFUxUazVQjm9AT5WMkyiJN8tmmwOXqDEmuv/mI2TqXXIH/VRDeen3kXRXjX?=
 =?us-ascii?Q?wG0Zr9jrmgDwzJ8rwj6YwD/IirHt51cCkDVT1VY9+PkFnFHraQbNAgdumuQ0?=
 =?us-ascii?Q?sJzbC2AQ29BKX0/Pw5hHuc62ERfbUQzFejfh0mdO+6AonZM6wHRKJpVWWdwO?=
 =?us-ascii?Q?8APNGhdvRpTXeJ4oi8zooZm7EaF3fR1V5VfPSy7EThkqaBMpS0NMllyGz04J?=
 =?us-ascii?Q?Xo2hzcmBy9833FayvdjGSXMquUr+A6Ntobplgixi1TdJUcsbVSxY/TA31ikQ?=
 =?us-ascii?Q?0bI8FnKwYs6fjg8XkAOoCKkdsyYJ8zy9oX/War7LAW/7StNsSxlqi2SjmYhv?=
 =?us-ascii?Q?IPbqtrgdkyf3SbgG4MdENPrvAu0lu2WqkuW9DyCykzkWjhhkv0Ykz+zETNoB?=
 =?us-ascii?Q?rxEO597foyjU+uo4DQCDi0knLmGoOKHvvGbC54HwOCM4GAnXaXcJF4CmbCV5?=
 =?us-ascii?Q?NbdJy7EW4ijvUfBT+YljbVJkSmNw+JZeNtp70XxXO0RajkQdIpcsiINUlVP/?=
 =?us-ascii?Q?wTvgXEklyBVJtXYMmBDL38K5HUbCwxqWNSLeMzb57PtwKrcJ9KrHFNRIf6HA?=
 =?us-ascii?Q?v6Pvcn0T0IsWi9Dd5thNvm3iY6TMTf522aQ6LgCuK5F5PxuDJxQHIOUNPrkF?=
 =?us-ascii?Q?0B9eA+CVPpWttRbmHQY4ZuDtp1xU1NT9SXX2iEkjmuKiH5shZcjvDkgh9KwJ?=
 =?us-ascii?Q?i19YUO72wSsagpUUwZljdaEQbDUWMbVnDOJ8AvPQdCFKL85G6wht7BtT0FCh?=
 =?us-ascii?Q?4lH4EDydpxnewT5XjvZFUQtwmGOgqG04rU6QMBe2FJeRINUtvENqGKdzz7Wk?=
 =?us-ascii?Q?ON21qhtyntgYlrxXKUzJ1x75R5e5ftnn61dPdNZ5/9kVd7/sHeOv5KI3UIq5?=
 =?us-ascii?Q?4t8drkmv4vK59TUoc9/ZPE0my8pGIKphB6Fpo0kj?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0703761-c478-47cf-34fb-08da8b59ff8f
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4181.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2022 14:06:28.5240
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1+ejoJKS+mcfvOUKrfwhLAcQhbqEI+ChXnjXzHG5uLOMT+BD7wWvUQtLL5wf9G9e
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR12MB5476
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 31, 2022 at 09:59:43AM +0100, Shameer Kolothum wrote:
> Commit 91be0bd6c6cf("vfio/pci: Have all VFIO PCI drivers store the
> vfio_pci_core_device in drvdata") introduced a helper function to
> retrieve the drvdata but used "hssi" instead of "hisi" for the
> function prefix. Correct that and also while at it, moved the
> function a bit down so that it's close to other hisi_ prefixed
> functions.
> 
> No functional changes.
> 
> Fixes: 91be0bd6c6cf("vfio/pci: Have all VFIO PCI drivers store the vfio_pci_core_device in drvdata")
> Signed-off-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> ---
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    | 20 +++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
