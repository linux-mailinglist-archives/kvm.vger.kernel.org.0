Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB6973A7DD
	for <lists+kvm@lfdr.de>; Thu, 22 Jun 2023 19:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231346AbjFVR7Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jun 2023 13:59:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbjFVR7X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jun 2023 13:59:23 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2076.outbound.protection.outlook.com [40.107.93.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 510CB1FEA;
        Thu, 22 Jun 2023 10:59:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QhA3Z4o5pxeL0ZZDRCESQHOnAGLyO+sICMlq5Ke/Rw6X5nZiCXZBowwmUWbn6JlvS4wuvx8SZu3rq2wpNmbF6JFU7aC4Z0+QH/quWZaWCqmCmxw0dGiU3asQGxBalifP6dnumxFLpm81GEkYjgzf3FvygzLpxLzGgXj6SzXu5h1UQL+gOoUZFKpCP19TAF6NM3HYSsoDsZpMvSQJn94LgB6cOlvCBtHZuOw/tRSo0QCmsqoeoOBOP8XezGPwQNHGth6pHokq9ZEm/JI4Au4SMfoV3YGzDXbnF5RFDiHuOO+K+0fs08qH1oqU/sye8QVcqn7I79k/uCaJLNXOk5JCYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zcTWuY7Z8NdxKwZcEY38CpFONhu3O9/7HEjiy7Guip8=;
 b=SLM9rcwuE+gxUojwy4I4Gyu9I4tiqaL2ncxi/GHOzQnlffJ2L5RBWR8s1upFb2zd2SMvFwkJV5JcshqpOFUEesBsxDvNlcLgsd1Wc+zZw9cMMj2N9YysqH8NYEaEmWP27TQGoWjruN4lJ+BEJHltFSsHSvhx1thT1IY+HODR8Cf9GrUt9kCOJV6S6ihubG53yHTD6uLmMGw2fGARHiVcEzigMbver7EpS3Dkxf+VTmGik4+W+EW5zV/EcMTWclr8s1QY95ttDv/QhKPr7zKi/GkWEUtcLgmjk9qotqjGXsuj2ljnWDj9xbNUrY5+z7NwFM+OaL+VgehFqLz53VuC+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zcTWuY7Z8NdxKwZcEY38CpFONhu3O9/7HEjiy7Guip8=;
 b=UtZe3svQCtYBoOwG+0bxGHGKIMgSNLLn1CUgIK8LYBcg/28b3mq4hDLYlu7xvstJz5eifNHF32/SXRFe51F/BiSPE+CABY1GEXzriLGRpDswzw4TZsFpuDVzLpM76s3aS4Xu5IGBS7VBCSDBwgh1SUX9yQYr6QuE/O9iWlpuGFY1Q7iFeWxY0z3lbkv9D+BlG0d+00xXPUatEmCJMdfU0f8MrbCrPwEWZBkY1Xn+h4gRe2wCHnvIpwOzqfYuoMzdxLq1zvqORb1qabIr5BXXxJNt7W22CFglVbsK5bDNT7Oh8JLh6M8mfMFM17gwnYd0xw2gZhbkHqq52K6B7es79w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA0PR12MB7073.namprd12.prod.outlook.com (2603:10b6:806:2d5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Thu, 22 Jun
 2023 17:59:20 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%7]) with mapi id 15.20.6521.024; Thu, 22 Jun 2023
 17:59:20 +0000
Date:   Thu, 22 Jun 2023 14:59:17 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, kevin.tian@intel.com, joro@8bytes.org,
        robin.murphy@arm.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com,
        yanting.jiang@intel.com, zhenzhong.duan@intel.com,
        clegoate@redhat.com
Subject: Re: [PATCH v12 11/24] vfio-iommufd: Split bind/attach into two steps
Message-ID: <ZJSL9T1ZXL3WdFHc@nvidia.com>
References: <20230602121653.80017-1-yi.l.liu@intel.com>
 <20230602121653.80017-12-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230602121653.80017-12-yi.l.liu@intel.com>
X-ClientProxiedBy: BY3PR10CA0017.namprd10.prod.outlook.com
 (2603:10b6:a03:255::22) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA0PR12MB7073:EE_
X-MS-Office365-Filtering-Correlation-Id: a668d668-ad9d-4ca2-7550-08db734a6760
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Wea8jj7mc2nQjRDN0Lp/QwokjryRYgnWDBIcUOx8vw8qcDpGAV3VFbwAFYXjbLlu0xAy2FSMxo0auyBGgUSyrIA0XAi1L68lZAObirdl237xehxpH82Ss36O/nHYPyGEMF6kTVFZfc5Vs1eEc3Cr3lzID7ojxwePcCTAZk9Zf1yDkZ5B0oWlIKzThRIF1peUtytE1JXqL9d/oDi29KuTJh/owm1VaFOYGGFVcydzHAI+Usq6urQqEgbdjaxaDi64o/P7hYGFFWLPKk+WXGXY1+NfKVMAK9SArXZSuNU9UZ/0tnqKXdn80XGi267L4qxsvo4T/lvKjmsf89ke2+D6iS3GgmO6/vfU4WJw04VRfhE4uc9e66rjqCcFvyC5u8BT2e8pE7N2xvttw3+yqEXbFOSkeBuWf0s6OccgwzA9W6aDHGK4sapmh4NpBh15IX2YvwAcyXibYZYXN7p/ThEDIlfGoRYfoYoImDKecKda9deHJ4Z+yHzJp/WW35iqJkVU+hqSPK30I8+y7ofx73WVu7lvS+qfggLIiXPPz5hYp3klc/EcKEXys9ZHMIS+DEKH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(136003)(366004)(39860400002)(346002)(451199021)(8936002)(8676002)(6486002)(83380400001)(36756003)(38100700002)(7416002)(5660300002)(6512007)(478600001)(26005)(66946007)(4326008)(6916009)(66476007)(66556008)(41300700001)(316002)(2616005)(186003)(6506007)(6666004)(2906002)(4744005)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6nJd/JjIBK7wLkg9W3Dbnc2l+O4Qr88w7QZjoQl3Y8YTHiWPN76ltfNlzPuw?=
 =?us-ascii?Q?zXR6wTiFQYFIllGnt9W+XAaMWg+a+VIY805+EQ+6r9phc+OTp4zCXf6eBCSL?=
 =?us-ascii?Q?PHsbd6/ZNmJrWvYivi1SHclwa9EE9EJv4v1LaezNsFKZpfu+ysLS5A90F5em?=
 =?us-ascii?Q?VimdsybKcOdE5hc4WyAlc5qMDygQs9NSp986JsBca7p5/gE0SGKg6Ezra5Hk?=
 =?us-ascii?Q?zfDOQL0sIjCHg9DrTlNzG9ehmbEE5RNdD9KZ1M+efzg7Z4gYJw7T0ZnnGH02?=
 =?us-ascii?Q?TL1Mu9bH2U4KROUppN8VsqbVOt7t1GxrFaYkktbytYrvY2QUeYa7QBwP4Uzt?=
 =?us-ascii?Q?w7oVK3aRUoakJqcY3GycMQ4upWCG9rZDnodbr7fX4IfPT53LU/9NDTv0S/4k?=
 =?us-ascii?Q?nE2SUKrnXMNVzGwYbJz6epuZeqAGBeUHwbE1RsV8aMPN+X5ijS4sK2SOvABD?=
 =?us-ascii?Q?4m6hFVlkGd0CE/cQ2yHWDx38tbTpn+Jb1ZlVVRk+D9a5XlZqIP7Z265BdmWh?=
 =?us-ascii?Q?jyy2+4RMkARTMG9M8ggk6AQdrBn09/tTRRF8bseBJV2y6MZTQkhIEaVxyRTT?=
 =?us-ascii?Q?XepK0ghWvyNvObxHI50gloiAy5l5J5pJmc0UxsNaBpCVPfxiEGKnQMuvZTFR?=
 =?us-ascii?Q?ZkrpifN8jqiH02NwvWu3lkF1cMJh48EttuU14EdpmH0syQf2at/bmAtXD8B6?=
 =?us-ascii?Q?J769L0v/R+xcdnV9aTpLLw61NyLeWqDl4zG8vpmzUMfWSJbDb0sK7RzSlKhH?=
 =?us-ascii?Q?KLt1StwPVyjbcFth9Zx7panZ61b3AIr8o+4GWONPsK1j/Ktoc2bVrx+bFBoQ?=
 =?us-ascii?Q?uSSDPV26a64HHb5UvLZm/BLyyU3PRhhACEELBegskvUB8Tmla1v+J9jthoGC?=
 =?us-ascii?Q?shoWtaDd9cAtGlxqvHyZdjdARkDTNwf6Q6TYG37yPayOodaYxOvvt1RWKKJC?=
 =?us-ascii?Q?2oUBZ2MTAkYb+f/iJ/XYR24TDAhYXe8Qs9St5WmyFFXyHNf8bFDlTqQlgdiQ?=
 =?us-ascii?Q?8eQh87bEnj9Y0HoIu8AHu4clvI/RA6qCdfW33yvdlrhcNU2nPUL+TiFtFSsj?=
 =?us-ascii?Q?luD6rD9Im2OOXuovHIcdNr1BUnGlgM6p4BagxKcVT/ZE3+7YTN8jD2r8SVos?=
 =?us-ascii?Q?M2uCsaPs+P8SdrKrs7CYO33ZaDA7+NhP8MpisXyWY6Q5tznr4AxL6Ua8sAcr?=
 =?us-ascii?Q?+2Uys6UkA+5OvrDicA6tn726nP1eyWNbWiehUqKUTblwSng9ru2wh+OfIsF7?=
 =?us-ascii?Q?MG6QXUl2mGvhYszCzdZOhhnp88vP0TOUPQ0ErszigB02eHAQxiXksUvDeGOX?=
 =?us-ascii?Q?eQWztB6fmZf7Ca/2Oow/0n9HITT/XpcrB6rdadZZcdvD4Ppnf69Fmb53bDJV?=
 =?us-ascii?Q?2jmH3BpvIgL5gShs4cpPTjGQVE5FgjcWRuiDhy+B5vgH3nScBZF5JFpwCFrL?=
 =?us-ascii?Q?GsNMiHYL7kgl4IGd7Dr3DkVJovsVt93nI+aOcUpfF0bhelRvl/ywIqQd4xoo?=
 =?us-ascii?Q?h2EtpBFjJwI0Ee1X+OufDySbOxXQjKZpqF5a96a7/F0v6ON2GmDTtsy5VXo5?=
 =?us-ascii?Q?ntPAg7mvLxU70chatXfs6MAKRHnDu2p7WPpsFnwR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a668d668-ad9d-4ca2-7550-08db734a6760
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2023 17:59:20.4755
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hIkKCt5nGZ6YcHacUFJr0JxBAZ9bfTb8eI7ww3GqduE1VGSux1yfxTQPLWuxJEND
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB7073
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 02, 2023 at 05:16:40AM -0700, Yi Liu wrote:
> This aligns the bind/attach logic with the coming vfio device cdev support.
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Tested-by: Terrence Xu <terrence.xu@intel.com>
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Yanting Jiang <yanting.jiang@intel.com>
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/group.c   | 17 +++++++++++++----
>  drivers/vfio/iommufd.c | 35 +++++++++++++++++------------------
>  drivers/vfio/vfio.h    |  9 +++++++++
>  3 files changed, 39 insertions(+), 22 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
