Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89C327096C8
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 13:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231689AbjESLvI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 07:51:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230264AbjESLvG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 07:51:06 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2064.outbound.protection.outlook.com [40.107.92.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50FD3139
        for <kvm@vger.kernel.org>; Fri, 19 May 2023 04:51:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C6T3TvHgo+oew56fj5a474zfTy+608MHvAr9jC5nPqXLifRYOuN9KN4aOk2WQZCDsWxCIYBwxPxsHppQPk04M2RI4delDq+CWPvdpP7cRh+JwNklaHEzSiTSszwtf8l7IymR4M+J05rVN0dWSzMELeHhu0SJU4E3cJyXrdJ6XfCrBjnWcYnjzLd6hOUUeJFMDO+YUPawCpXEEUihPB41fdFkm7e2WduGAgFOys2OB7tTCnsxHMkPbH3IiOv9gfbcOZP2asZgNoKelwLU/8UWAceBfiYPxAobzJEv0LBTGIYiGbuhObBBJMcDAfVuxJyU8sdF0lldbkjKA/45jk3Wdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bXGddmzxQgeQ9UBrb/wfWy4G6g4jsJW8elNf+kiNhD8=;
 b=L57vAh79sBbXCbQQWXG3HX6YmBaXs6GAz4GTxrmTbHp6SQXto7+0r7XoS8WbPtZaVXYQeNwPDxnx9ZlVE411jjuQTFC4CKjzYfsF8/vK5Ljv8NdvoOT+ckLSAF5dSdBvObmg95lBf17mytULiSKNXrCXcDbTPaQRSTRcSF/C1ZW1rPSA6oictadHbpbB0iPAFC+k27++ib8I+WxEPdM4vqYVH7+yfLbk2VbXrfJyegLfvr8kBqNGlFV8i6fL3I+oLPENIiVEEY/DtoBhyjxLw+yLcLT400PhJgbLt0sR0qCBrosSemm1NYEe5huEQeG0iYhyidZY5gBBsrg4Tk+H5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bXGddmzxQgeQ9UBrb/wfWy4G6g4jsJW8elNf+kiNhD8=;
 b=VLlG+gGeqpJlZcc4AZbxHvU/ySHyUL8/RR4BAYs5k8LHQpPXnz8qGHK+6UtFmeLPICDmsIA+JqK4EgB3Xss/OS6xfQk1yPAt5yX2s+TxDCYhf3zzMUvVUuW51ROrPsh9xnbo5M18DN14H+0t/2B5Q4VQGVGupSiP+CAIii7ByGTHVw54Wmc0CpG0xoxf84JlpTAtncrrBrRMnZK9t7SCx37tJKHfQytJ8uyQbUhE7p1cKCnoyDaF87zWxFInBJV9t2G9jL33EPvvBGwKs6VVhfB8S/IcpLSfPPqwg5cE9TxdHCEFBAvQsf05m6Cx+Z2wO+uvDEad+f8b5AWxR5nHuQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB6465.namprd12.prod.outlook.com (2603:10b6:510:1f7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.17; Fri, 19 May
 2023 11:51:02 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6411.021; Fri, 19 May 2023
 11:51:02 +0000
Date:   Fri, 19 May 2023 08:51:01 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Eric Auger <eric.auger@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH RFCv2 04/24] iommu: Add iommu_domain ops for dirty
 tracking
Message-ID: <ZGdipWrnZNI/C7mF@nvidia.com>
References: <20230518204650.14541-1-joao.m.martins@oracle.com>
 <20230518204650.14541-5-joao.m.martins@oracle.com>
 <ZGdgNblpO4rE+IF4@nvidia.com>
 <424d37fc-d1a4-f56c-e034-20fb96b69c86@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <424d37fc-d1a4-f56c-e034-20fb96b69c86@oracle.com>
X-ClientProxiedBy: BLAPR05CA0014.namprd05.prod.outlook.com
 (2603:10b6:208:36e::18) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB6465:EE_
X-MS-Office365-Filtering-Correlation-Id: 697eef42-f2a2-451d-ea28-08db585f5211
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FDYdVswjOqFVnMNf9hquewIEz9E4yKkVE7zDMUgVxUwzuCDZbXRT3yiOAr5J7yUd09TLl4kW7Usg/HQT+H2WiWPjgIX9xBKYKmu3BkeC9EA5WZxDbHr2Fh/QPFY2tyxF4KFblDKu91ZPlDnJYn8CFnJ3eNasBn9K8vvFHz1j9ktSM0ElKsFLOyj+hJU1bUKCQWN3UKDyfBO7GuGPmXyHDk8m3C8i/wY5H6z9gVC7PKRo4nVBv5V4BAqdD2MZPIS/Bwe+d0/5s0qS0UgTJN9czutgtQskck9HhJgDYw2lR+lkQ0Rp5t1iPrj8Yn7f8sJtch8qf3Rwr1RrDB9yAOKbzqnLPl/5amDQzPWxyfAv7ZVWC4MbUPfULMzEVnnknN5lEUCL9u7660eQ/p1nBTSyJYyZJadecqV7/VI+u74yrRyPPlGS26KsBEYQQLh1ydoQSilr37/FE50gEw1c50Mq6MNX3nUJFMlo82jS9QMZl/ajcTg9DVe6u8/5YVuSOglfGUEY/IwuVUELK2vEZKMt276c4a/IVrmO9sC3/eWp774glw5fAwmilyC46dp/wQThefCIeWA1XdsEdnSpTbt/6HJ/T8muejl940maZ/jmIS0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(39860400002)(396003)(346002)(136003)(451199021)(4326008)(478600001)(316002)(7416002)(4744005)(2906002)(8936002)(6916009)(41300700001)(66476007)(66556008)(66946007)(8676002)(54906003)(5660300002)(6486002)(6506007)(6512007)(26005)(186003)(36756003)(2616005)(38100700002)(86362001)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?g72buzYMXlYT8WmcF7p93sojM9qsjTUhzUODcptgbaP+VDHzwCevlKHrD3l/?=
 =?us-ascii?Q?6On6h7Gx7aif32WU0Jx10jS6XUMF8PiGcs9f8fOeSvpv0mwgK6IiAAmQ4zjR?=
 =?us-ascii?Q?UA6vE3R0FTxaef928p7A3fme7cbP5ezM5Olx1Zx9gqVeSDiVEsQizc0ONK1H?=
 =?us-ascii?Q?6zmiY/ytsZkwnvjR0ipVGfBwtrxlsMj+meMIeHbwg4V4pig0NGaaBEnhYm5W?=
 =?us-ascii?Q?douWdOTM9wlkAcG04OfsJLMHtpu7GeFkFWwu2LuWx00RezBa73uH4szK9hc6?=
 =?us-ascii?Q?PhXW7Pv+4zhWU9oFDlWDIsdph8oCpm+DFLIu2YJ8FjPjD0BuEvfzyAgluuxb?=
 =?us-ascii?Q?H5aWLsqiE93pTPNqA4l6IaQzCrF/54H5YaY+RsYPC9HK0PvzZtmeW5QPSZ/S?=
 =?us-ascii?Q?ASWl8aQaKFFlHXVLEz3Ua88kbVMI3TGuJmDNkrNaGjF5ds2Mw2+A+cZVfdES?=
 =?us-ascii?Q?aM0kgq3RmBxiQPbB4RbB2w6tSD0NhJ/MYPLwYXItrxVKY6vLhNS+TEQv6vo1?=
 =?us-ascii?Q?60TF2qCzbkUxFlDsuQUy6eKrOL0Ol6cRC2gs5CjzrQhde4lbh/RlwPJLGhMk?=
 =?us-ascii?Q?FJ4Unf5b+P1SqdxxZCmTfl3wRHzrTCmd63u3og8tUCKyL4+PNNGYyJGvmkgj?=
 =?us-ascii?Q?g2F13hQsLDX+haK9yMuF3oFJ6YzjJhV6yWbiVMpiKilDbOo0LTth+naRssMB?=
 =?us-ascii?Q?x5Z95Ax1tPTgJFSKV5XXRr010CxY9qozFt/Ms+TKJuTDdxX1tRWXjFq3G7LQ?=
 =?us-ascii?Q?fgPk5249D33xeiivgLx9fEXIitR+psDIlX1RAytdLJuyjoGZ+bfy+dugU0Cy?=
 =?us-ascii?Q?UpgSEOysHa+R33ZniyBYrKsMXtHiXHvdS+yS0hK7w24jMJfRo/Emw+G80mnb?=
 =?us-ascii?Q?9bvZvHrXN5zasI3ITeM7fbhJqdsya4qhgVY+Gl5OCB2ocx69WZuL4+5gc6wU?=
 =?us-ascii?Q?laC51gICBPB1+RrU517drWjvf0BT3oiIUSQdXrozjaAM/3jX0GUV7r3aF5sZ?=
 =?us-ascii?Q?2lvEzVsiWrXOemC3dKc0epAinGbztd1syBoz48eF8J7eqj6siGWDzGaF1d2J?=
 =?us-ascii?Q?+2rSOaHU1jQeyvGmYzoEjEhfOGBhfdhHkrak+PmfUQ+qXhDVgGZrSK0GK6La?=
 =?us-ascii?Q?DtBe7XmSrQh9TvFMWjD8UywwU7hrepMLCVlN8Bf9JDnZ80Xg9EAcv9j+Yn+S?=
 =?us-ascii?Q?0j9CCDFUevdWdBMgKGQNjBJbI/+Z/xidG1tTzipOI+G9TMCGIz84kdebDN44?=
 =?us-ascii?Q?T+mlo74CGGwyRen6M0ggKiGXifoM7CT6qk/nThP2MrItKp6NSC9FjGWORZ2r?=
 =?us-ascii?Q?GJ9vsLr71mrxQ9shXRKnzfoWCU3pYo/aD93CorQCHHtj/GZw5ZHksCRLqr2i?=
 =?us-ascii?Q?7kdhesSfXVT9yrOse7PBTIs8UQYf2Lui2ZHlhHy409E57ZLjzMZ+KLVmF4zI?=
 =?us-ascii?Q?IEkYLm9WN+BNtg9zjCeCjTLoSXxDs/rBnEqTWLhUlhtfAhkNgZZ/LLjjbJjh?=
 =?us-ascii?Q?TEschEZyGkd0ysNCrNe1xvJGUqn78lrUgon+Rgqvd0BvJmExI0wW7XvDdPXv?=
 =?us-ascii?Q?/ZglY24CRoAhA7cqedqQQu1OIbrRtX6kAtW2mb3B?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 697eef42-f2a2-451d-ea28-08db585f5211
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2023 11:51:02.6329
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YRQqQK1StbC7oC6EGmf6YllGW5RgXfT28JWWOasfzQYyJU+db7jYyptyMG6xDkir
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6465
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 19, 2023 at 12:47:24PM +0100, Joao Martins wrote:

> In practice it is done as soon after the domain is created but I understand what
> you mean that both should be together; I have this implemented like that as my
> first take as a domain_alloc passed flags, but I was a little undecided because
> we are adding another domain_alloc() op for the user-managed pagetable and after
> having another one we would end up with 3 ways of creating iommu domain -- but
> maybe that's not an issue

It should ride on the same user domain alloc op as some generic flags,
there is no immediate use case to enable dirty tracking for
non-iommufd page tables

Jason
