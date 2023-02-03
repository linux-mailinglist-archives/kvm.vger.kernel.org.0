Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BADAE689BF1
	for <lists+kvm@lfdr.de>; Fri,  3 Feb 2023 15:36:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232700AbjBCOf4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Feb 2023 09:35:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232809AbjBCOfy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Feb 2023 09:35:54 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2050.outbound.protection.outlook.com [40.107.101.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0216C1C59D
        for <kvm@vger.kernel.org>; Fri,  3 Feb 2023 06:35:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lcP5Rjsk/UwEBqXujA+Rh+pJJgvj5iNBYVkYZmOcdLNLyQj1Bcm3O6grStDsCRguEjkku4gpLqIheCzIS3NgkJBLH6+rJU0h0UTVXKaLdWy2lf3RqvacJe3FEsKNY1e+B9XvfBPgKUmvTqrzh53QK+Mdi2z/I+hG2bYUWyLyxgIhdMp82hFGf0XW2Ay0sMWQOtbw79FY4QPCy5etbAhwI0N+dZ4J0lIGhCJN4n7Yc2QfuojxK+P+2f2a3SVQJFuG4WTYgfiSmRKJmLbpsXksix61PP8wTdXGao2PquIVMKojgSrt2FpLO3tn55wj3aOIAup5UlSjdDHBCM+zanY7kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iL3CdnBC5NZWxNYV8m6r5uHcQvAGqzixYLKeEHbeBvM=;
 b=hxcncWWNHUC9CtYgoFXIdaxrsPZiNPegln9N5rMDTC9s0zO8Q8N4iSOUoGwWC/g6SxQcx6vwVxfkxZKsjE1vmgU+byuxJ7sUyw4dVCEObp9ksWszQk6x6RS+6d4qbt+MuHDs/WEjqQZ/1622KLlbsb28LsZjhrZQU8otIkFgWN65vlzuP+7Obi9Vddty8bZlaTLQJjInxpmT6FXHq6uCp9fFfQCCNn87fjKkJ+Q+wD5lQ+x83JwqAlhwP/puVAGXNmGccNP3XYN3uEHEX3VWCNeA4W6JJRlEPEI9E5XY+xo76GWqlwW2uPPM0fGkNVyRW/k6gGIgx2QAHL0UJEVROA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iL3CdnBC5NZWxNYV8m6r5uHcQvAGqzixYLKeEHbeBvM=;
 b=Lx0FpFnFLGQ29KlHC+84SXD0UhcN42Uj8c+Vb3qG42AVuLk3qmt8MDEvCrq6gDxaseORE1nSQUIwJNEGB2GBgJSOJRG9QWKH+9OlAvfh7CRbgfnWxQ0MmsMo2QWk2HDQXMeFbH6WdIJYl89RiutsZCcar81OsYirVrfW5CFZv0eAajqrXAim9NWnosG/DsnVAPLymhS1RfNdICv39gt25XDyGp5gmRlmSJKtuRj5nUbVAxlNaiwGOeWkVy6ts/o5Nn6A8MhdULUxbNhthMt05ApQAPPLMvTMsI+SxhRErCYBhTk86VIo8Z22RMqPCix+19Hc9L9hQBN1k9LaeuCClg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BL1PR12MB5224.namprd12.prod.outlook.com (2603:10b6:208:319::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.27; Fri, 3 Feb
 2023 14:35:42 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3cb3:2fce:5c8f:82ee%4]) with mapi id 15.20.6064.031; Fri, 3 Feb 2023
 14:35:41 +0000
Date:   Fri, 3 Feb 2023 10:35:40 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Steve Sistare <steven.sistare@oracle.com>
Cc:     kvm@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>
Subject: Re: [PATCH V8 0/7] fixes for virtual address update
Message-ID: <Y90bvBnrvRAcEQ//@nvidia.com>
References: <1675184289-267876-1-git-send-email-steven.sistare@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1675184289-267876-1-git-send-email-steven.sistare@oracle.com>
X-ClientProxiedBy: BLAPR03CA0011.namprd03.prod.outlook.com
 (2603:10b6:208:32b::16) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BL1PR12MB5224:EE_
X-MS-Office365-Filtering-Correlation-Id: 9da920c3-b328-4178-12ea-08db05f3ed27
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yFFQ1XBd/ZdlLZbHbjfTD+usmr02dRJUUVIPBHE61MO0k2CMweEud2F9bonsP9VqIaAxbIgr6c9iaz1Bl/O83hYdKVkHnOHgCMh/SSU9Pa4LX0I5OchayhhAqNtfpPxAPg8BPFBTFzGXJ47+RLbVFPNll3JWp5fh69QSvprkwW2JhzyTaMkrCPBuLbhHzci/fgffgQ1HaVe8f/X5n1xRRYR8xDYdZlRrTtne2Hadrk0fnKzO9nFpZEmMShxNbqFsgsP4HE3hcDW/iEOnh5T2J93UH6YSfmvUDmB07M2o8FQ7z85VaHQ7z52YIpWXqgbNn8NhtoGmyeYPTwm1UcEmeQmGLvdn40WntQXQvvkgDJGNXvmgkKeEnOWGYEq2cJuxzZousVTF7O40ZeEKSwrmx6uXe5xj13HYMN7rJ7rvAHta5mPhH3Iv0Rn2migMtobr7HsgBPHjm2Fiyy4BmscnseZMFduD/mYdDatQbmQ9hSV/CJLWX4C3LwIthODctmYIu7Eb5iLAPOd5P1U7cTe9lz7oNZfoNvsNU9Ez8XX28N+msSm43xSTth1+jIuw08mqWL21Z5FCM5G5OdUHPWgYk1SzIe6OM5XweMbYPvQlEhAgLgw5q7ZHy2T+7juKClbSB7Fs3Ug1gFEmMIhqEbcwag==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(376002)(396003)(39860400002)(136003)(451199018)(38100700002)(83380400001)(54906003)(316002)(2616005)(2906002)(36756003)(6506007)(8676002)(26005)(66556008)(66476007)(6486002)(66946007)(6916009)(186003)(478600001)(6512007)(41300700001)(8936002)(4744005)(5660300002)(4326008)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Mq6pJIsZPANla2p8CQL7AKpqC+/L2YfpEVKZAhFbL5fYCyKwYqZOMe7KuA7p?=
 =?us-ascii?Q?K+c5+eAzUPfIYQrCW4so6exfEUzzodV9kMuxSueg/gqa6gndnSjwPOCiKVPl?=
 =?us-ascii?Q?Fzh10XkkGr3dveHEKn3tweClIQ1Yf78qc6uDGPYbtdaHM5l/ffWctu8aBZD5?=
 =?us-ascii?Q?lxVcAi3DwLNlSESVx6pp98RyVLjHkCU61OWLDa4mDcvYFCeYOMizVSNbF7cZ?=
 =?us-ascii?Q?WMXQIUR4eAXD/Eab3xoFdpr9xO90t1l6SQ4tWJNp3AYjiANJeIs0LVXBHt1X?=
 =?us-ascii?Q?UFL6lAGaIjuGzvIQZc1+EUJBOAhUHerv3ehX7SZ85IKnu0mEaw2E/bJjPSkP?=
 =?us-ascii?Q?KZOz1MIjIH+XjTrCDGdErMxHrs1zk5q0L90pkEoiB3too/Ro9KNUz+Uh4Bz2?=
 =?us-ascii?Q?srMI+39n+AFkhFpJ+ac2x7h6qNeFmFUOLM67PMTJSlw3FEnVhHpB+WT6OSb5?=
 =?us-ascii?Q?hkPdms5d71laAhoxKhdHfmge253o0Kjvzj9y/polDqefVdZavHKS1KHH1PPO?=
 =?us-ascii?Q?gyb3I8M4KqFNniFW4MjXufcKG9JKoddrZB0yXaKEwWib6TRgG5wC91mJB5/V?=
 =?us-ascii?Q?fQAChzd6BYTWlnOwDoWEeCF7CrjuFQEyERjpV6uLW5gFz3dF2IPdsso+nRLb?=
 =?us-ascii?Q?GKx3VNjsJp5+VD1sz0CgDNNumFPsmGhALFg8m9RNMdkQRSwCXlAvTpb/QsqT?=
 =?us-ascii?Q?wKZmzFE4/yQsBD9QW5XG7ShVFPfDEZqxmKcIRb2ftKvFA4ER1n9ORCROytjp?=
 =?us-ascii?Q?60/OlbazvXtolmafkmN/UdH2IveUuvcbC06hm2hBo3u2PrsOoIDo/ER5/6d4?=
 =?us-ascii?Q?JL1j/ErThqIXu8nAVL7pM6gcXYWPOn9Ydp/0r1friN49ceZkn/EE1rjO8vBk?=
 =?us-ascii?Q?jovdI7a4tcYuJaDhFwbHK8bIibpDOEzX0ZNn5nz2YtV27owl9MtVzAd3LwDZ?=
 =?us-ascii?Q?rjkfUN/s7KNw4iFOG2OT7OouBBzeWKUW2LeWIQgwA0CT+HmYUDyIGk2XY10Y?=
 =?us-ascii?Q?MwrbP1NBmfK7dm1OUiJbIdGZ2z7zFatBsO6mIpRJREmxSWCSR6Y4rfYmH0E2?=
 =?us-ascii?Q?aP6mxmD3vbBHnKcast3129SysG4jBKKqZc/3GDTVcGw7LWUWuiMMEjzFlx8W?=
 =?us-ascii?Q?MGAro3fHN/96mWj2HIVmK7/fYXd+7FSBqhLMWgQhpATKdUIBfuq5XS2s0aG3?=
 =?us-ascii?Q?MsE+O9NCQCCRG5kfGyAJAYew6a1SwsYfvyduwU+CSWfYgzIsjBDs6jhsN2RH?=
 =?us-ascii?Q?0TPpqDub7beNPbvDirbz3QYXuHmZ3Ewnj7YzMhUIkOC4BBhuTfl0eLwSOWrO?=
 =?us-ascii?Q?WRXbUer7sfIkMzXT0QbS3FmK4B2TR07CAWCh4EBDAMFYWTc6TyZpAKLUg9te?=
 =?us-ascii?Q?BPrQMlAHlzHQV5Fur9odS4g2Vl/+u6SqcUotCpDFGSEAMfB1fgIRxJg/eGRe?=
 =?us-ascii?Q?yozVkojK0Kv1ZpErIyYK1P2HSWHPKrCURfWUCLe/Yv+5s8OSX4q7fl4wqAnq?=
 =?us-ascii?Q?yhdFaU0G37iR+cOyoRDu0GzGVsgHPGRzVSrfSg5Y6uP602g4WNubzuZAj7U/?=
 =?us-ascii?Q?GNbjYKZxiAlC6Gt5voPYFQCL3xw+cEDPq/BDuFE1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9da920c3-b328-4178-12ea-08db05f3ed27
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2023 14:35:41.8728
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 85jADzeHxavdHKHDzVd1WWA5PrJbD8K7UVPbd+r8tS/LpAi35LRBhxG6B/puJGMA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5224
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 31, 2023 at 08:58:02AM -0800, Steve Sistare wrote:
> Fix bugs in the interfaces that allow the underlying memory object of an
> iova range to be mapped in a new address space.  They allow userland to
> indefinitely block vfio mediated device kernel threads, and do not
> propagate the locked_vm count to a new mm.  Also fix a pre-existing bug
> that allows locked_vm underflow.
> 
> The fixes impose restrictions that eliminate waiting conditions, so
> revert the dead code:
>   commit 898b9eaeb3fe ("vfio/type1: block on invalid vaddr")
>   commit 487ace134053 ("vfio/type1: implement notify callback")
>   commit ec5e32940cc9 ("vfio: iommu driver notify callback")

I would still rather we delete this API. Something that doesn't work
with iommufd, and doesn't work with mdevs doesn't seem like it should
be in the kernel.

But it is up to Alex, and the code looks fine:

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
