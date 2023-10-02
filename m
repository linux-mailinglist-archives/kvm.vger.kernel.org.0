Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87BDC7B565E
	for <lists+kvm@lfdr.de>; Mon,  2 Oct 2023 17:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237959AbjJBPNb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Oct 2023 11:13:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237774AbjJBPN3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Oct 2023 11:13:29 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2066.outbound.protection.outlook.com [40.107.237.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD16990
        for <kvm@vger.kernel.org>; Mon,  2 Oct 2023 08:13:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PtUa3jbpiyIVOASiEZE0Sgow3FIIxwUZvO+HXgfg6qgviMWmpLUqp3OYvj4+NE/0e2HNXm2pbagA/rj00lARrD4E9pQsjSIjTr3OY+tWjZjQbrTRoK4RNJQdhx1Y1IJ9XWdBO7E7KP4Ixl4Q5nTrPPJr+goc3B+8Zg8YNIfOOWnJQyNccLX28TwVrQeXzS9KOFDCNGbt4jk6D41ga4Fb4IQ4dK8uem3S5BDo4kYzI9dtdnBA3LMU3v3ucuKeEZCFg8WM3OEBjni2lOpptasyPAtr0xDE5Ix0gYigD2rRMHeAuCNPGfW+jgrrD4OBp0Q4yZnOKVIwqhlYf42JwJQi6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5oQwd2sDK+hq1wjsot7UdF2CtRZrV+ZBuAQVrJK8hOY=;
 b=UgC7OUD70TSVb0m/YXghb6L+X48PrJq3jZmziKQDuCNVcxrcU+nZdJR4DpZu9CjcCj/kvYcWxa0utPRdpss5Cj01yLBHdeLm8HY13cuiyCsZy3H+FvMCIiuj3Pb47EX9izxBzx4bxU51Fvolki/srV6lYp6pKbtxxtv6UkLtUrVVcUvtHmv6uSBpH8jzF6zZ2MAgF6O1gWow8Fs7eTtU3SPKSfx/Eq4wZ6/HbzmxuEQ0x6zoNcfieANEqzRr7hOxcuecKb60sOXb7ZeyiKE59W04Q90fLt8PrMx+tN/oD8aYfNl6WUlX6ScpdEP0XLZMEGR/bxoykwRz5YGkZN54Zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5oQwd2sDK+hq1wjsot7UdF2CtRZrV+ZBuAQVrJK8hOY=;
 b=HOERUDl3ql7oM+PXabZPi1NxPSJY8whzUmtzFSfpl2YT85zUGHfcGLLrXnISU/er0a+KjXrZ/LG+5VpuUuuaLzYybY2WrwXDoy3zq/zICmyiHXnBkcteCv1tf7cfkcRoCQt977AwewLytC90Vodca/ZZhSBlRTtdjKouNshs5I2kTv+DKvBmhnFTSDV2Z6Ta1/C4vFqTZNYrw3/tsYKzNIb9LeZ7O5WelLBcwTFO52PlAZyeHUkAbuvivigKVJU+bBhoNUc3e76s4Yp3ziaThBnmhwfWqINhuOvBB6teg7Htw9YyAr0NOIHTTDyxvit1YcZTSePi1qJWIyPqzsVqkw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CY5PR12MB6203.namprd12.prod.outlook.com (2603:10b6:930:24::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6813.23; Mon, 2 Oct
 2023 15:13:24 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6838.030; Mon, 2 Oct 2023
 15:13:23 +0000
Date:   Mon, 2 Oct 2023 12:13:20 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        jasowang@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, parav@nvidia.com,
        feliu@nvidia.com, jiri@nvidia.com, kevin.tian@intel.com,
        joao.m.martins@oracle.com, leonro@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH vfio 10/11] vfio/virtio: Expose admin commands over
 virtio device
Message-ID: <20231002151320.GA650762@nvidia.com>
References: <20230921124040.145386-1-yishaih@nvidia.com>
 <20230921124040.145386-11-yishaih@nvidia.com>
 <20230922055336-mutt-send-email-mst@kernel.org>
 <c3724e2f-7938-abf7-6aea-02bfb3881151@nvidia.com>
 <20230926072538-mutt-send-email-mst@kernel.org>
 <ZRpjClKM5mwY2NI0@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZRpjClKM5mwY2NI0@infradead.org>
X-ClientProxiedBy: BY5PR13CA0002.namprd13.prod.outlook.com
 (2603:10b6:a03:180::15) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CY5PR12MB6203:EE_
X-MS-Office365-Filtering-Correlation-Id: 4774ddb1-436c-4ee5-17b6-08dbc35a1eee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FBdrcDTPTSuZN7JS5db1BkTGhfpWejn9vAMiQWbqra94wCGORIGJw4eY8uCg2VlhorFLccxehqjBPPPzV3mwPIV8DAjlYj7okeubXLyMiQTBQkrVWfsfQx5l98XKuARLwZFNbNzn3Q3Y/wer59ndMZfvIElX8dDwQWJASEpXOo5JkapDEby9S2Q2tCOX1H7fG+0H9c7hMkTYJkh4E+kGSrvnXpRYKDAMH+3Hk4NFLCUpNSQ70oYdMiBlCpgXyduy48grKFS3LPOKqkPYVBanWOqAqZeetJTk74ISTDawH3elPdMydHCVAKW9boWGUYQdk+jZ+YwjwBswCMldgj4IJ+H2U4a7LXS7NfZYAad8M7p0AdvnX/WKOoVnSs4YNry3Di4+BBrxbuY0PFtnYsAprhcM9YLOTDwOxfSPiceNup/iVG7pKwdWFFuEiFGYvaECt1B6AYsOevA99ANyUrAEM/zQ075qvSf2y8MELtCTto/eL+npcP4nTBrsMfauPNX1V436W3/8kAvlMHY/AbS6YqarL7c6PtlKVUKpTXYU+V3ygtinfz70sRA5XxZVzsPhNd6xVQEBVZF+fbHu9qBPxvFbjNm2GeqgO0cj3Vz3RsbbQ3mfRk1ycHgG646dXOMD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(396003)(376002)(136003)(366004)(39860400002)(230922051799003)(186009)(451199024)(64100799003)(1800799009)(2906002)(36756003)(33656002)(86362001)(54906003)(66556008)(66476007)(66946007)(6916009)(107886003)(2616005)(316002)(41300700001)(38100700002)(6486002)(6512007)(26005)(4326008)(8676002)(8936002)(1076003)(478600001)(6506007)(5660300002)(83380400001)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?40jDFJPBVHDV1thVnnLC0npgG6c3cVeCpIsPcqvtEAPoetjHmvM7XJNRFsvZ?=
 =?us-ascii?Q?kSNj+JYkpwzjxIqLLxhtVvjZz3ugEffqjxUYrEkbWmJbku3a1nK7zpD8zbpM?=
 =?us-ascii?Q?dCRHEYjcFqGA+eE8Qax80A+VaEqLcMmOtFXms+gkuLn+F5GIrq+5YD6xy7P8?=
 =?us-ascii?Q?gjGghCniuWw238XnRIBpWmIxhIvw4TlcEzYOJ+BjeKL0GCg2Q3SlCTpF22bG?=
 =?us-ascii?Q?jTc+pv+9QyxLrigN+GnVc7ZiQLf8ZddjeqgyzBLgayxvv3ZG0TR8qWhTzXrB?=
 =?us-ascii?Q?Bbl6IbCuQYmWk1wATIOS1235snzeSvCPOVXZeX2fFHJo8vBfNVv2v+J4eEmX?=
 =?us-ascii?Q?Xodao0GWTBs2jowcTVLakj/SMMmpHUM1FFBNEjNSOXY4eIzum3ugrd7Z/WzI?=
 =?us-ascii?Q?E+dmo/S0Nc0JbC/uuakaL3gYrwidNhhwhdDeCSU0g7qBSXqmWIxqe28BvfS4?=
 =?us-ascii?Q?JqVZXuaZh8U4MvWuWSqtEB4D+A08p3ZZLUp6aa6LvEJzbeW9zN+0LKMDcuKa?=
 =?us-ascii?Q?xheXYZVvJYaF1pytOQJeTrhA53gbXTc7/0AfCFcfLW0eUPJfwVRV7hI4QTIU?=
 =?us-ascii?Q?bMDsn36WyH5WqDCymJH+srWnyGL7Y5MahJfLBHRuSALEq3j7z6VfjaxWLgOv?=
 =?us-ascii?Q?eBjr0t2bANOCfv9a2hCnsZfT9sYlXp+YgiqQoEa0pOtcUVLTfeCrT5DY5dyv?=
 =?us-ascii?Q?GGUbCN9XLRTxAGb8z/Nu8ckqvOcH0IwxhqG0zlHthoNj8CIjKGVXjsNTzOLP?=
 =?us-ascii?Q?yDQ699bFSD4LJ8QIj0gMogyxAmN2TelrGn7IazxozR/OSGnRGw4EKI/kDlPE?=
 =?us-ascii?Q?clHm3EqIxJ7Fbt9o3aIVOVuhbNTmR4ozzG1uYHXmNAHaeboIkGMlgGVUC3vP?=
 =?us-ascii?Q?hJ2CakAEl76CDXsH8qgLL3K4UMxh83N17wUUnOugmQO9/x+Iy0GWxEpVXcXX?=
 =?us-ascii?Q?LB8T5xBiWrZvDrtOPcSiY6obi07WwkOQZ60VLrqZKahUN3tW3hMEQgg/FSod?=
 =?us-ascii?Q?NUewf8raa6zFw7deYOQ3NrtivEglYS7LOYW3bh79/L3NxoWhCc1YSyG0iqWr?=
 =?us-ascii?Q?8nkJ9E/GnjICe+KmVC1sKPEKo1mLG1plmu/OhsuXWP6w+LW502cZXqF1lJ6e?=
 =?us-ascii?Q?GrUkIZS9ylCwrvPwQdIrwWKjxze56n10SO/yuLwETEycwn/nVV2WKvEW5d/n?=
 =?us-ascii?Q?csnRTv2zDu67/aR/Qg9s8Qkl8ctSq/2OeLmzanYTH9sRMok+LtLTuQt27yoP?=
 =?us-ascii?Q?Te+y7mugZVFBQwZcA5GCmFbEH4/usFAtTdF/hW9xsTdYJo60mQNcjJJBgFc/?=
 =?us-ascii?Q?5TTdu+P241bgIR5TRbG9KAbTUzmGd+2UmyffVsrC4Kgrrc3VKh/mCFhT/jzs?=
 =?us-ascii?Q?zX+OcuGEY3zvXuMmPbJwfnlbASt0IXX0rLDz6RseXuxnmayriNZRnIOFx4IX?=
 =?us-ascii?Q?KalRefy0nEto0K6U2LCR5evHb9bPqcM3Jkxsdn+loBT1XuCov2Q+XprPjK3B?=
 =?us-ascii?Q?wAjOnRNgjeHhcjBLshxxAtSjak398grJ7RqCk1WjWAjFhR2k7nha/Nhd03uu?=
 =?us-ascii?Q?4gtUv4RmM5SffVcihOzy4cwIL9irx/qYYKdOtY9t?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4774ddb1-436c-4ee5-17b6-08dbc35a1eee
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Oct 2023 15:13:23.8294
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WU3eTvuXUz6v40OT9XkxT4qNW0vlYf6E8+VVRN5cOVQbRPML68XZlVXq4HsqLcxN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6203
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Oct 01, 2023 at 11:28:26PM -0700, Christoph Hellwig wrote:
> On Tue, Sep 26, 2023 at 07:41:44AM -0400, Michael S. Tsirkin wrote:
> > 
> > Except, there's no reasonable way for virtio to know what is done with
> > the device then. You are not using just 2 symbols at all, instead you
> > are using the rich vq API which was explicitly designed for the driver
> > running the device being responsible for serializing accesses. Which is
> > actually loaded and running. And I *think* your use won't conflict ATM
> > mostly by luck. Witness the hack in patch 01 as exhibit 1 - nothing
> > at all even hints at the fact that the reason for the complicated
> > dance is because another driver pokes at some of the vqs.
> 
> Fully agreed.  The smart nic vendors are trying to do the same mess
> in nvme, and we really need to stop them and agree on proper standarized
> live migration features implemented in the core virtio/nvme code.

??? This patch series is an implementation of changes that OASIS
approved.

The live migration work is going to OASIS first no patches have been
presented.

This thread is arguing about how to split up the code for the
implementatin of the standard given that VFIO owns the VF and the
virtio core owns the PF. The standard defined that PF admin queue
operations are needed to do operations on behalf of the VF.

Jason
