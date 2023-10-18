Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B76307CEB05
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 00:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbjJRWOm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 18:14:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjJRWOl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 18:14:41 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2062.outbound.protection.outlook.com [40.107.237.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67BA9B6
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 15:14:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FBUwHVNB4VZrZ8OeU3uWk8MjMuLz5z8yj7rTR7zAQptCM2mg0QEI7ivqJX+1nmesJylZfUMtijLbZub9KjFL0EV/IDgqz2vmNs8DAcSk8voWo188z2l035QS/NPRG0WdGUT2BxW4cQOUNcwJiCUz1oWwQfcqFGeJZ0GWs8tHqkE3JxGnWt8aqE2wvBVK4Jzo0FzItAno9V4qhHk1s/MI2UY4Q/a/480w1AYB6EpOPhkL13VCEPrv15QYalul3LRhgxPa/2ZlsHN+X4fVbJmWpB2sIj9LjDHbWWuG/R1AuKFn8n/4cw+TtrJXFFHdmIYh7MHaY5/wNVQXy8DqvNDxIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BhdMgtYfFw4x63sAuTAeobjVgNZKpYViKRCNK0j5BEY=;
 b=Tf63smLhNCfOldjyf12E7KDpqVt4O4iZIAq7q0y6E2h9UNV8jtPIJT0xmgZa4smjkJhwPgoYOkfKPVigAF1OlMpDFtUtbJGd+/4wr72BCDMbwpNwDu3Y5adW6uHsP7wOsCtbGl4H+1ihv06kR2sb3qecv7v5pOgtXlOpASrgWlSBY+Ffl5coyD0RLfuHtlhlPrgMRbo7DL39fHu6dsaNoxP+GjGQzQej596YuJu0n3dzrctfvHCuCwL1jHAkrNuFCxEKbHe/a7bJ9ZPkg+Px6rt1ZWjRMJru42R0KlZvxIbLzIF6/aUV+ox7zQbt8DbEmFsl6Kppq3C9N4aWXbE+Gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BhdMgtYfFw4x63sAuTAeobjVgNZKpYViKRCNK0j5BEY=;
 b=qye32XWkeWsa3K6j1ZE8cUeCyKk/Lt1rIjWZpPHrDLBWiuUe6bpp5H4Or7ZpRHH5Yo6YaZED7R6hBBRXCcPj+jsy1ssvIM0UVqv1ALaz2RxF3ickbol5DSex6/AynwFxQJWY/f0ZAW5kPIXyMai+xNrhu8A/dfbi0HjCT9COvkwbmfu8SCK+APiwwpPRxKRNltv63th5HLwQbab+w6KM5yoIE8L/eu8wh9fPTBzOjYX/PNyVVAFpEmYMtywgKbAxCrWa+Qvkn+mD4fUgbtoCtzY4JdHe+y6UqP3ihOvX3ppACkCt5w6ciL/z2RjXcJDw+6x9HLoEcsR0Ox09O5zuSQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM6PR12MB5022.namprd12.prod.outlook.com (2603:10b6:5:20e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36; Wed, 18 Oct
 2023 22:14:37 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6886.034; Wed, 18 Oct 2023
 22:14:36 +0000
Date:   Wed, 18 Oct 2023 19:14:34 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Zhenzhong Duan <zhenzhong.duan@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v4 01/18] vfio/iova_bitmap: Export more API symbols
Message-ID: <20231018221434.GF3952@nvidia.com>
References: <20231018202715.69734-1-joao.m.martins@oracle.com>
 <20231018202715.69734-2-joao.m.martins@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231018202715.69734-2-joao.m.martins@oracle.com>
X-ClientProxiedBy: BY3PR10CA0024.namprd10.prod.outlook.com
 (2603:10b6:a03:255::29) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM6PR12MB5022:EE_
X-MS-Office365-Filtering-Correlation-Id: bcba8d88-3b02-455c-e324-08dbd0279d6c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WQlg3eIGxilAfMJwPE8AUG2K8lMcC5LrnCxTZlxIZFw4TbixsJPSwdB8+1geITnoEqtxZ+pwoMqH37xOogXALcwbUNgrYK1qm5/n+cbUNFakURNzU+1mZCr7sHhWdNz5Pe0GFW2PvQcJL9POcT6Q9TI3oRBc8mOnrjdEAtChMS3NyqSmkSHUzqDqu2NTa/gKNbKfRiEIcrVpXO9KOxHbqKOLJN7Zmu+7vreHeRznWU+/YJzg24Lud9skhd9g5QLAmocl5nOhyUMGa7fQzkhRaa48NHf2iUuMleU51+/g3hIcjtiBtb6dvDfXzuZuxrmzrc4DROvF0NcGSOFP+hbp+WXMp/vxLTOi91WDLokx3OHnu5y4xDTXUvbgmnZB7dSopVeYDwZZW07Ho0nW+OFQsawYGbNDPqRTDYH9F0Fz5K9mSTYyrAqdcPHjME0LVRirTTEmzl3Jq/LDZPDzmqnE/XFDtfNRashkpZ8kS4uvN59jXPrxMVNEI9/Dm+MzbNicEMO900u37QKahZjxCvxD2i3X0vZCBttbC4u5jKwN7W8qUXdbLcoW6bpv+DE/UcsO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(346002)(396003)(136003)(376002)(230922051799003)(64100799003)(451199024)(1800799009)(186009)(33656002)(86362001)(8936002)(5660300002)(41300700001)(4326008)(8676002)(2906002)(4744005)(7416002)(36756003)(478600001)(6486002)(1076003)(2616005)(26005)(6506007)(6512007)(54906003)(66476007)(66556008)(66946007)(316002)(6916009)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aYEt3j49OxgzNwSrco32s4uUPG9KGRLTlKRnfzcUPRg9ObyD6//jjKu7Gdb9?=
 =?us-ascii?Q?qawfCERA/aKaJehgXzHPZRXSDnchQiAeExXC7fnOKOXgyTST13sBN3cAHE8K?=
 =?us-ascii?Q?987/dQzlvAayyw5kZLxLocS5VsYDJSjLVcqH0EKMvUz4LFSU5XPhWDQ6sn/0?=
 =?us-ascii?Q?S9fCanlGbzVVDU1p+L7oDlR9IPKJeSk5DXV6dv5k8l62pKIHoO/Z8ZGK22Kz?=
 =?us-ascii?Q?7EWDjTYiXeEkGTh+egd3fO02WuMKNNiNb8eUNoFO38+XWcCTp969hKj6vYWS?=
 =?us-ascii?Q?34eND6fB4kpLgnIwDOoCZQNegW+XHOD4bsBjz75w342krPmTrtGLx3YWgVXx?=
 =?us-ascii?Q?Ck5tK3pZoQd15CvdKq1lHTXXlwfNxaGVkrMFbj7ptDdVb5VjYVphyINdzg5Q?=
 =?us-ascii?Q?VOyRRUi4HhEZpvhW5kw0Gi1NkvZ9I2W7krvQ6D6byG9m7+1qSt8Z2Ty3M1H7?=
 =?us-ascii?Q?Ud2uAZL8oQwrDAWoqNP0dLSQ76KIiPKguaNdWdfuASI9dmJTn7aF7lYTFpfW?=
 =?us-ascii?Q?dHepMuGbvmCPhV/yXOpv3RWe740ua3shuCEbBaZn5nf7XaC/EdUFe0RU7V+J?=
 =?us-ascii?Q?ZBq8JJc9eoqi3T5liToE9ZCecK4wy8c9uemhlhypfsJwetQUhDx4Hb1mYl9i?=
 =?us-ascii?Q?pWH0WMyFnXnvdRJ9OjRfIfhUSocIChfP3Wr8rfzPZdxvr05MQBs9RlZDY0s7?=
 =?us-ascii?Q?ld8ZpQg3226IeDP9hDxx1ZFGbC2IBN7sw0dHk8qHCAOKw8viEDpUe2nF57Dg?=
 =?us-ascii?Q?HVNHikWDOryEw+8XfkZpDR0Vpljbvt6i9jZMT6e/XpYYG2Gtkt/keoSh8JRN?=
 =?us-ascii?Q?bDxxGxa8KR4+1V1sPKFlwJBpoURUXi7Tl0RkJXt4ztXtvU4FOh+0tpFJz3G3?=
 =?us-ascii?Q?9SP2TF6eVK29vWY/uV6Agip0fM2it9hHFoM71oMVM10B4rFrnOiqUoN7+ytU?=
 =?us-ascii?Q?r4JGN08gLpzelDA8VUiEkYzR82O0Vc7OBRiYFgWgm4MWow9RBuTVWLkWD+K1?=
 =?us-ascii?Q?usyx8InS34EkEI+VDnZOIWq93hG+ry/+eKnvP5djzCjOPOyhMA6qD/DgBQoJ?=
 =?us-ascii?Q?TXxPaTCq1jtvSV+9FLgKQVzPcdbMCg8DtEjzZZ2hW1eNMpBWzujlJyzcISsD?=
 =?us-ascii?Q?PHsuxUZl05zB8weVzrzIYot4ogutpNKbd8OiY70CVIAAvAIM7IZaGX5xrbOd?=
 =?us-ascii?Q?1HrRTAu/SehToUCkeBwaHpgXBFzTH+e/c4S7cuBnH+SCfXDFqCkrIvctsRmw?=
 =?us-ascii?Q?x1H+RgdS8cchbyKMkrcfe6mNPaz0VIyU6QpDthZJjcuxYUakIwVM2sGnol8N?=
 =?us-ascii?Q?aL16dmXgR/LwZHIKhZPGIXNx3Mn22TxEnDymsmP9vPc5jvCYCwBi5qqJSmaH?=
 =?us-ascii?Q?jkdXcjJ+wDC45zSqHs4ISRko68OmJOZXqYdhw3VrzpekT6F/+d92tM+JPG7n?=
 =?us-ascii?Q?08ssb6gL7ZbbY+vRb4D1xOtISWc+gXwnqjYEtiR6QpfOiVLPHI308H9sXoVS?=
 =?us-ascii?Q?gYym0/Te362qDonDL71jmvZx0vTcV+4YUvZGbkBXXiCaCnvIV8DltnXk9wwM?=
 =?us-ascii?Q?C+wklAkSaWjO8hm+knV8YAhN3Qcpd5DQtv/RTFwr?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bcba8d88-3b02-455c-e324-08dbd0279d6c
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2023 22:14:36.8760
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BT8FE7e8OiX3cnfqkvB+KUXUdT50ubM/8Ed8ohYZtpeLKIsa9wb677KSE8z/Il5H
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5022
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 18, 2023 at 09:26:58PM +0100, Joao Martins wrote:
> In preparation to move iova_bitmap into iommufd, export the rest of API
> symbols that will be used in what could be used by modules, namely:
> 
> 	iova_bitmap_alloc
> 	iova_bitmap_free
> 	iova_bitmap_for_each
> 
> Suggested-by: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> ---
>  drivers/vfio/iova_bitmap.c | 3 +++
>  1 file changed, 3 insertions(+)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
