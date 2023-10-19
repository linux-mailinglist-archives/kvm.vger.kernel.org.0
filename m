Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C92D87D059F
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 01:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346735AbjJSX4W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Oct 2023 19:56:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235570AbjJSX4V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Oct 2023 19:56:21 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2055.outbound.protection.outlook.com [40.107.223.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E912C114
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 16:56:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S6EXAMv3dSYuP76QyAqex8T0yUgzhVvlk/6ydb7Bmg66SYr1PcKgI+pva0FJBERfi3auj+8uzIiVXqsPsrR5v73SHdaIYsMYHOnPdcI1GU4o1mExUs48Vx2BB9PL6fHO+hWiGa35bW0gQdceBlBkpI0A48o+QBtifZbh76cFbsXDWpFWitGacR3n6mtcvF9A13qWEYTBM0HYv6qzn6ORvVaLkxHLtmTSeQGZEJZ7rhi+zgiw1eH1VLV7RBTE8I3JMnfbhMvIhuvLK9iThW3NUwUL8rKKA1v5ZF9SenRIiOTjM0teq347ylyzMcYC1uxSWIm6qETNPCnr8vmuprD5RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EQvtvDFr11AjAOGS9IZg+5e2WNE9Upi6a2E0VrMgDW8=;
 b=UONR0tEQelQrjqpUwEwac+ScZmrstqH7GfiD/zkVPqh8TvWfM8krOQvevBd2LUSRVfuJDF6tOw5dpK0SxtlJkDqWtAVPfNWXxjZDFSffONbaZuX6096ITfGVX/czPusMS9nR1tQk1o/VvjcDHC2jShb+0zmnBN7zc4z2MIRSQ/jHS/LTyXeW8C/9UAgoqDq54drdPaNVB5w7pqZ17Kkm5V9MuvDhg9oLzddDWfMqDi7lT591PI2yY/vpl1KEWZ/30tXAK/fK/YtXCObZrpvj1cSlVSCKVoOaGs2WDah4kDOe0hmfOf9TWQ1WOcFpLk7p0aOjZY0yxhRuUqIfx76VOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EQvtvDFr11AjAOGS9IZg+5e2WNE9Upi6a2E0VrMgDW8=;
 b=s2Te/Hh/JLppX8Uh7HqT1Omz6pzty8e/0sdrUYD+t6JoDltpGqo2Z02jsb5YAf+4TY0JsTGNrsWUCAZ2xyGJXPIPTAwseiQaKCSkZWA7MO2Ads/FoALoYKoBJaYQTACFOthYa5QKsp2Mif+XYKjtdxbuA0MoLcsuXYmrr5L0a0fsBp9rAXUQjSSPXWfPcnj0YC/9scMGNykVQvIMBCcJyqshsfWbXBZoXINpeY9Uhd1r4A6iwiZgQDfIKWp2qVJ6m0t5+luuDJc56xdyIKLAXJUw6qDs5+ETrI8vcKotdlpG9RJkKWopNV3+VK4WoV+qRD5CBsTdgaEku9HUe2btKQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BL1PR12MB5222.namprd12.prod.outlook.com (2603:10b6:208:31e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.25; Thu, 19 Oct
 2023 23:56:16 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6886.034; Thu, 19 Oct 2023
 23:56:16 +0000
Date:   Thu, 19 Oct 2023 20:56:14 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     Baolu Lu <baolu.lu@linux.intel.com>, iommu@lists.linux.dev,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Zhenzhong Duan <zhenzhong.duan@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v4 12/18] iommu/intel: Access/Dirty bit support for SL
 domains
Message-ID: <20231019235614.GZ3952@nvidia.com>
References: <20231018202715.69734-1-joao.m.martins@oracle.com>
 <20231018202715.69734-13-joao.m.martins@oracle.com>
 <fe60a4d5-e134-43fb-bab5-d29341821784@linux.intel.com>
 <c94e1114-a730-478b-8af1-5fd579517c0d@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c94e1114-a730-478b-8af1-5fd579517c0d@oracle.com>
X-ClientProxiedBy: BN8PR04CA0041.namprd04.prod.outlook.com
 (2603:10b6:408:d4::15) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BL1PR12MB5222:EE_
X-MS-Office365-Filtering-Correlation-Id: 388f7064-4186-4ee5-96a4-08dbd0fefb84
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aagjmfOV9C9UX1m9FKtDPZdiHCsYc1JerJa31guDOfyqU/fbjmBeGrs3dXFpsSehByfEO2cDQUQJtdzO5nw2v6HrAXESruPG37A5/grvrHcViuEZzZPJ934H/UoL4+W6eqiwW5WJZGToNdCd/vDkp1V+/iWyI1ShpqPilZHKBMpfZY+5HlS9XE9vCsG4bQyjpECdGLRgiolhTX07HopesXExOYdsVF/5DA/DnOEVyrf1u9fGI82dbMagSlUxhXd3OYKlNilAb0Vc+rGvzCuwQBy9VyEh05zagt80nvY2yG2ltARPcqbl+gN1uXi37LHhh3gB509tuwB7XUkYTMQJWYEiJ7nJ3D34uX3mfy2bUPaP7PgJ7gZs9bqtEIMipR+KzptoE7ye/uFuq8Ryo3TuiIE3dXSXoBD9Hv/Hg95KMJl4OIwyHYl/2zM/CNNvhVts2QgzCE7KlNw+kFFrkiZg9jMBYUcf8hyCXVYb1HcxUJ3uU5o5XqEozv8J4TNSD8JEFH+0IN/bHfiuxAqWrYIJmz9ncJyvJyUwstxKBZQMS4NGc5OIJo06PYhWO/A6NT+EjlRYScy+Yrdf0qJv0b5tNXi+TdU4xJ8vd4+uqhQjbq0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(136003)(366004)(396003)(346002)(230922051799003)(186009)(64100799003)(1800799009)(451199024)(5660300002)(41300700001)(8676002)(4326008)(8936002)(2906002)(4744005)(7416002)(6506007)(6512007)(36756003)(38100700002)(26005)(2616005)(1076003)(6916009)(316002)(66556008)(66946007)(54906003)(478600001)(86362001)(66476007)(33656002)(6486002)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TiFoq7twxNfnCpnn9HEuHq23NPX5KTFjjkB5eekZpU+D/K68uSTvRsU8mq9Z?=
 =?us-ascii?Q?84FlZ02OXbnNhM7/P9CwsAdwbW9ZC2SStHiRdLfiOtWDrMB2gu2tL5blpOrk?=
 =?us-ascii?Q?MGn780k4B8VGOSO/DdFsTGgaSHLdSfIUmiITpvFubn6abDCCboU1OrlW0M50?=
 =?us-ascii?Q?/wKk7QJ6vr6uAxjOAZn8CI/60hxugyFcIcu3RGbH7s+hp2bWKTyuEMotY95R?=
 =?us-ascii?Q?FyGK5k6aOu8PpkAy8NgDKWJ0UZle/v9jxcBuzH4VISEFmlCgxsVhGmfXEJA8?=
 =?us-ascii?Q?JeLHMB/8qxHN4wwJd1uRwa1J+qgRso/KYlnAdHTsqLq49HBD2rIOPw/7PVkh?=
 =?us-ascii?Q?1HbDBIh0o4fnS1/uUqEdiVQiGemgMoz5KiHG4TiAXJB82LwbOjncIFkpkrwA?=
 =?us-ascii?Q?lMkleyuzm6U3TOqE/H3pa0NlA68DmMQDVdiwaq6mT6+/JqKA3uKh6yLwZBpy?=
 =?us-ascii?Q?CG3bo9mqaGLuzuSp4sfKH+NtP3fAHhTfg/thdDvBgCa3aTs0WEsuCPfY5DNJ?=
 =?us-ascii?Q?TQl+lOVXmpq5lfC4rnvFcA0h5+wHjbwUC5vU4AVC5s9MlOcgrH4/eEaUm9io?=
 =?us-ascii?Q?6jqpCU4dk6t+PyqeKlgVGvGWPKl5ye73AF43/jTrwm+YW8IWzqwg+wmKsPqB?=
 =?us-ascii?Q?ae3NfR/CtyfHhSom/mS4401I4aodIRIUa6R0vTqnpcGTNynVwnovcW4TRJDQ?=
 =?us-ascii?Q?+XUEveX7RqIAzdbLi4+jKY6HrL3uFMREgI7rzl+UWOvaR/86fv2aZMmTPQcv?=
 =?us-ascii?Q?24dnPDw9TRRv9p0gfdwHh1TY6xIZeEnHABBThWydxEhXax3iGj0u3q0QplsT?=
 =?us-ascii?Q?pSUH9fvYbeAPWWJ8RHsp8cLhXhgaf1MvWq1EDGPvcbE61S+0ybYJ1ULVBEPp?=
 =?us-ascii?Q?l161KogGTThuP310MhwPdOINxH2chyP8+PcIejJMSJpO7OCQz7waUnUrvY+m?=
 =?us-ascii?Q?oBakKFZOjUTI96sEHsqmZGbp8LsqTfaYC/7M7TeZFK9RFDIbwcxMisvTGxXM?=
 =?us-ascii?Q?ohzY40VBqxA7KZN2autbQPF9SPH9nmFz8pWir62GvF4++8jP+qc6nJaVxzvQ?=
 =?us-ascii?Q?eKgiEF0oGmS9qoz1IVXWr9nXd8Qt97b7Py2en6uOduvbt/6tel2UFfvnQbI2?=
 =?us-ascii?Q?xh3FMqJ3VIgz+WWbiC14Jf9Hg++f5Cxa9ZWQgjciMyLpWIbjuQCE6hJUnQcl?=
 =?us-ascii?Q?QoiLgPBrrllK75KlmNzCWdWu4yEgXqcZpNfVf3f4bDtj2NkGsxqVLQDo4Yet?=
 =?us-ascii?Q?0jufyNneavQictu7wGOOSXgIrY7uOaJOLdwIBlveypnx8AUsqcJ1MU9Lucej?=
 =?us-ascii?Q?VVbrvemZSXmSYmgLKMrxfOZDsclztoX9gPB2dDjxPYEZ9NoKLZmHBLginj3o?=
 =?us-ascii?Q?mbwBmD8SdCiN46ETegRq6xj4uHtzetTCiAZ1bzzTDBCXJBC6kyQ6REP79xW0?=
 =?us-ascii?Q?ymzrbEw/ZmzkEmbAL4+c6qjcEeQqW4U/yM2ZU0rw1WcIJsoggtVaQxhA9ihS?=
 =?us-ascii?Q?zV5x+b7BbHQI2Y/uGwkPmxFhZXc5BvRpdIF/jW7mllTGyiHa9nhvDgZd/Tlo?=
 =?us-ascii?Q?Kigu7nV4oQrCzVjpUIdQdOtqDsxL5OVb7XS44pzO?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 388f7064-4186-4ee5-96a4-08dbd0fefb84
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2023 23:56:16.7025
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XCKgExuXbpovmk40FUs1YCIac4989xsmdqLOvGfJLdEIrdQB+4HfjCLfWG8w6uAB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5222
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 19, 2023 at 10:14:41AM +0100, Joao Martins wrote:

> > We should also support setting dirty tracking even if the domain has not
> > been attached to any device?
> > 
> Considering this rides on hwpt-alloc which attaches a device on domain
> allocation, then this shouldn't be possible in pratice. 

?? It doesn't.. iommufd_hwpt_alloc() pass immediate_attach=false. The
immediate attach is only for IOAS created auto domains which can't
support dirty tracking

Jason
