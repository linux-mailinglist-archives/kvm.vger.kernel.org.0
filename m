Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74EF664ECAD
	for <lists+kvm@lfdr.de>; Fri, 16 Dec 2022 15:11:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230424AbiLPOLI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Dec 2022 09:11:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230376AbiLPOKm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Dec 2022 09:10:42 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2046.outbound.protection.outlook.com [40.107.96.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5447DB1
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 06:10:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bDg7VPNLLJO9lyZzRzdrz7uftHNp3dUUeNlDFyL69E0fPCfUAdq8dnQ6fJWKxavEC4IKbslChAEh1XTZcrvq+OW4HKrqciBiMxLLQD/Qj1hk73uF+TDi8alLv1p4PUS5L2RDt9D0NbkFrfiLWMOWY7J3stHcHw2K3fpUGJsE3fFtiNi9kvVwrLpMbKr8TPU+niofsTz0gI44bwabFH3NJtNs1HqHvdKoL/8sXLny8raLsJOeysrQCTYm5xIOT9UWZYNE9iEPSnsPb2pM2UsV/aKGJuEdK9Dt8hRjv4sk7yLxHqEE8QmHaMweH/+KnF37mfNXqWTqX/f/Z7hURc+IDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QdChRRNW3qP5CGve3Va/GdYfJVBlZaif3UTCtcYHJNE=;
 b=DdvoNxVc9ggI5BmSuNzsVhPxm1o3//6HpX1NQJxDZT9NuqOtHL38nXnhyncyWwP8tbFgh7hMwvQkyyJRazI8GRsfwtnq4hh7ZQCNeqRV+qCcVfOrH+vvZB0UR3vSTDUQpHIUrkc8wEwgxOr2EV23/mkijUNHeqWKbifc83lMUp1j+6TP2cFU7+QiC1PoIg57Nrk2jmF1/7UtMN2XbaKUQb8GzfrRhUMuEDuKsm1VaACZi8dx1iza979VJ3i4xmexUbSDte3Y0GdOB9R0WqouFAldsL0jlf++dsWe/sVhLBALZIYqWV1w7gDTtjw2uUBUWhlo8YexsJDMwHPLW2Bfcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QdChRRNW3qP5CGve3Va/GdYfJVBlZaif3UTCtcYHJNE=;
 b=sN6BJG9v9VwPhs8RpUHxG0qRQSVwvCk4J6BhAWYrSJ3R6Vo+tJvoc6FF16tr5RhF3IAq6AhuBaopXHLVtoqy5sGDFYaOyrv2ye9vblrQhbxvxyrL/3O/iA2QOxcYMFii+87NGATuN4xRixrJsrIoEP4COG2NlFb6UvWw2SY7JqkvjEEkzE+jjlSyCMlpXMIuMYXuDA9xORMWBW7MYR/5/LKSr1PLhCglT/F+m9n57SkJEQPw0M1eWf6g8NplDdqZw5kL1fltHOQCIAS9EcLwbFpRdKWmU4uMjq7MqgkJ9pdcIGkm7lzs8LXDEMVvJ9FWYWJ1NOYTZt7iRUedKxsF/A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN0PR12MB5859.namprd12.prod.outlook.com (2603:10b6:208:37a::17)
 by MN2PR12MB4485.namprd12.prod.outlook.com (2603:10b6:208:269::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Fri, 16 Dec
 2022 14:10:39 +0000
Received: from MN0PR12MB5859.namprd12.prod.outlook.com
 ([fe80::463f:4cb7:f39a:c4da]) by MN0PR12MB5859.namprd12.prod.outlook.com
 ([fe80::463f:4cb7:f39a:c4da%9]) with mapi id 15.20.5924.012; Fri, 16 Dec 2022
 14:10:39 +0000
Date:   Fri, 16 Dec 2022 10:10:37 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Steve Sistare <steven.sistare@oracle.com>
Cc:     kvm@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>
Subject: Re: [PATCH V5 1/7] vfio/type1: exclude mdevs from VFIO_UPDATE_VADDR
Message-ID: <Y5x8XQDno9Vw6sOI@nvidia.com>
References: <1671141424-81853-1-git-send-email-steven.sistare@oracle.com>
 <1671141424-81853-2-git-send-email-steven.sistare@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1671141424-81853-2-git-send-email-steven.sistare@oracle.com>
X-ClientProxiedBy: MN2PR13CA0025.namprd13.prod.outlook.com
 (2603:10b6:208:160::38) To MN0PR12MB5859.namprd12.prod.outlook.com
 (2603:10b6:208:37a::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB5859:EE_|MN2PR12MB4485:EE_
X-MS-Office365-Filtering-Correlation-Id: 02178838-4b9d-42b0-3642-08dadf6f4ef9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dXkeUg0kh/Y8CXakzqbh+kDrzu1f5BhhnDUTP6hrZGO4uw2/ZA+tXxtaX6mfSCyXUmXFKkaLorSgVXsWAYaj6ukk69dSCYKBA+2/Z8Wvh7C4v/sFhGbHSIHS3EAiaKcWmpUJJio1AbgP7IK4gykHkJQhByvos5KQvr/NqaSwJEGJkQDOp2K+4LU9EOmofdMppxmmOfXymfZpfH7wJhxeVYAu3WB3G+04hwenH44S1FzDtkM9TdY/+IEvwNc3131qQXWKqWtNbkiPvsQlghLeZBQa/EjtiwgaOBUWtZ+E4v3k37iJGDVBRrN/zg3ImVkaQlDq62Lv9frQP2N8XyU/QyHCuFtn4r9BWgTKCLoK2hFp6hWTRoWpOH181HZ3Jn0DuekEWvlyZ3jmbfBeftCCqUqQz56IKgjJqtQICJHPOsi9ytZ54IkSaUvxUukRWZoJoU2iRKZCVTskPeKBuWK2JZEe4f4K9/SFkMigWQzht3n7fayo3rtyLwnyJYVRvcJEgZbAVEzFW3x5qtcmycVlcpoCkFEkZcSPOGa7fT89hTs/JW8c8XSFF02OZLRvA+4OTeO6AsQiFMrd2KSAwtdrinF87HelhJtL/7229Z8y+IIMywxNk9hKvLjvcHTt22t7/Fib+65kdkme2McIDT8LVA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB5859.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(366004)(376002)(39860400002)(136003)(346002)(451199015)(38100700002)(4744005)(4326008)(8676002)(6506007)(86362001)(186003)(26005)(6512007)(5660300002)(6916009)(54906003)(41300700001)(8936002)(66476007)(36756003)(66556008)(316002)(66946007)(478600001)(2906002)(6486002)(83380400001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kki4b1Mbqd1rTmcUGWKgAIMqY1IXuldWVexXKvLc22gG68dACqe4BpK6ajWq?=
 =?us-ascii?Q?1IPC/sv8U8RGWLOvEPmQEgAtEY2truFItIx5/pi5NMG1Ofyvite4m3AEGk6n?=
 =?us-ascii?Q?/sM/kbwuaMM7eZnD6WD8UVBiJ0FMv7NXnm28+d9KjExCfZq/FghpLhoAq6Bl?=
 =?us-ascii?Q?OqJI6tGyxcWGWbvzH4s+XppmcuCHM9vr4qiFUdNnuTcOqnaefb8qPLbVYoza?=
 =?us-ascii?Q?fhBYvR/LPLkSDr/MGZHXh99bOUBsyug9wmvpmws91rkwy2vZEabf01rhwVN5?=
 =?us-ascii?Q?vD8B/MkTi/eWQiOtfZZZMUKaD5ux1KMJbTo/KYLH4nA8o0x9nwi2shYjwpcA?=
 =?us-ascii?Q?tmDf9z3L1psOAZbXfTQwUkcj/3DuOiohcvUXJ9r2dkrNFZN9NuiZREaBfmB7?=
 =?us-ascii?Q?8wxLOnWH+CWR4GKrDTOQHZgQKrvxS2DejJXo594inLK6+5dFog9H1QIHjw57?=
 =?us-ascii?Q?ojByJQeVSYkif1oiA1844+Rdz7zeWlb9hz9RtSQv66lwxvK5VvY7MaplnT4C?=
 =?us-ascii?Q?AHpC1ZwJcR266Z4fkivIAh0hIXd3OJYQyQJ29TdjoNURQtC1quNCXkBED/Y2?=
 =?us-ascii?Q?ZX6RSVGZ+uMPMVIiixV0KnbfCyIjtsjP6NIxabpiGrMTCZVX2BAzJ/9qgjQo?=
 =?us-ascii?Q?dD3Fi+eq0nEHwroS44Ij9ziWET5Z7KRrPRzVLwjyq+mND3yNFI28+Cjxyiw8?=
 =?us-ascii?Q?6HqkGnkvcy+x1knDQspVik/NVkFqJ/N99Ipwk5/NXppoquLM3j0YWkIHQPAR?=
 =?us-ascii?Q?0lWcHPysekcaAZDyjcEZOtJRnrnTqOZnybkGYpW91I3kCH1AWLK9Lfai5qji?=
 =?us-ascii?Q?DKQvJEF2+JH2kE/J+g5/nPmsDMK6mH8ThhmXvofZtsZMsKX44oqQLfkUjT5M?=
 =?us-ascii?Q?qIPQf+U8q6haA2rX0nAQrnz5bcb7FqrZItImQFDbjq26NCbT7MfQ3wVnt4wk?=
 =?us-ascii?Q?aEqGR3GVtOBlnb9xND7JvB5mUpvw/ZaH3OjpyqpIScolKOVHYwRwsapXEMny?=
 =?us-ascii?Q?S/alWuxlta6m0DJe2kIWa4k8xiHJaKVG6Cpv3bVwesPsq4utFN6T1zi3nptq?=
 =?us-ascii?Q?jKsY30GH0c6/8+CeIAx3ZnRCZbLMfITZJu97CU6FqQcX4PmQLxvguQLConbi?=
 =?us-ascii?Q?A32nvZNFOEiogOESznO4xDUBhwkxV23MpX8UPIAZ9yA58fgxYEa/k8Qj+OCJ?=
 =?us-ascii?Q?hwFBTejv7Io39g6mWU5D2WU13dcdzeCMj1xGKrVcE2CUxLPyh/Pgjt8Pa4ia?=
 =?us-ascii?Q?LTxLgNX4Hr2hqtkEcZrCUSGG5RcHa447HLBvdu2cnXvyq8zdgrw9YuJY90nK?=
 =?us-ascii?Q?U+Hap56pjEE0dV4RmITqojZbyp/rcCqDe7u5+06ODP255vn3/ick8X3nHJvI?=
 =?us-ascii?Q?fSHTEJUJ25uwe6XlRMT/JmFrvd7wBPqhv1q+7BBEr/jxYytpc1XeyxrjhUDP?=
 =?us-ascii?Q?NrhjrZ/g+/n9ARHTi7op4W+aOmMjSadssHIAY7c1Dmriz8pnvBxUefSgHWxs?=
 =?us-ascii?Q?Ug0Bxd5m5yF2NzTabn1haHT+Bbup9yNgM94C+ZO+ojs1woClKq2ijtyFUEeK?=
 =?us-ascii?Q?gJokRz6NzmUxnmwCYvc=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 02178838-4b9d-42b0-3642-08dadf6f4ef9
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB5859.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2022 14:10:38.7084
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ns5cVJAJ6Fp6Yq5g3ty6pRb/b6KmPovVfeOulWaOM2ob5v+XX9gTkIZ2601SA0hg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4485
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 15, 2022 at 01:56:58PM -0800, Steve Sistare wrote:
> Disable the VFIO_UPDATE_VADDR capability if mediated devices are present.
> Their kernel threads could be blocked indefinitely by a misbehaving
> userland while trying to pin/unpin pages while vaddrs are being updated.
> 
> Do not allow groups to be added to the container while vaddr's are invalid,
> so we never need to block user threads from pinning, and can delete the
> vaddr-waiting code in a subsequent patch.
> 
> Fixes: c3cbab24db38 ("vfio/type1: implement interfaces to update vaddr")
> 
> Signed-off-by: Steve Sistare <steven.sistare@oracle.com>

No blank line here

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
