Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B10967424E
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 20:10:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbjASTKF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 14:10:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230007AbjASTJd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 14:09:33 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on20605.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::605])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88F599AA94
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 11:08:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D033ZQorbCuwLxhETrM02c53PYyV8D5Avf1lkwMZnQ0uyjFuiWi59P+pO0G4QTy+Fl9fvjM9k5IIPyXA+vb9NWb0+O7aj2wCLNOlsdgburjuR+DdBqTSY9krhiyactfAKRLwnjL/7OlEJK5cOLrWaBO+AtoUZVrRtTh8sfb/vUbdWmtlWik5u4wBwZO5KJ7UW2b8IZHUuWKT/7WuiSXGUJQnm3xHinCQBqWoixUlyA/rtQD8A1GfNFhUjjaeSR33Bb4awK2eY3SCqTFcosWn78/eQJoJKB9ibjtNyk6bZ2g5XbVGFJU0qZOGsiAqUOkUosUFPvd8qJk+HQBnUAf3UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5jNQI0DI9IuCyWAuHlU2atHGvRU0r6Rge53Lfi5JN8o=;
 b=f5pMeTUNwkJ4vk7i7vrr8QNhKrB6rCZlKrLc+f/nps4nxjcBBb5WZHVDhpszKAaIrfZOufqU9S9zITbo1uvEsM8T53OVChRzD2eLnpRaOF5xEysXgML49Z3LOoQPb4ukCwybw7eyz6i0aHoODtmJ4iP4UUKE6i0RaQI3WdSUmzrywMS30P7I3XSBME6MKRSupwh8Zc8nK3MIrU6Z39LhXf+L9n7T72GseRtRP5fhemBUa3uNIpBJvciOrO5ASnypwB18TiHFtK4zkIcUI71I76JWBJIDSRsutBalHL8ypyteIig64yNGdXismwPAuSYkPSP+XFvWaeWLmntd2Qz1lQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5jNQI0DI9IuCyWAuHlU2atHGvRU0r6Rge53Lfi5JN8o=;
 b=SgPrQkNj1Png23qtPp8cL1onS13zTdFvdLIG3EwQz87B83quGOHqv7vJlOVKGdB1f9cj1eZsF/CfGGYBlZJ8qkS3zctkkUIYat+hoWDXf4fz6mzvGHtTmeF5oJA2fF4JB147g+essSZ0DQ7McK0WNQISduixTexRveIAp9FzMS7Kz10cyRrJfF3PWtTuPMqgDSVhY6dFImFW5ntJGjeBcu0c2YeCDsq9+3WaH2RJamDVJYnlI7LXCneCaMFkRWaG7uemDs7JRYkH82p3NtStwViCEPRiQo4uGsmJDSUWFCvlFKYXg7MM/l1P5NEX45OVt0Ql/7qpRIpHrzpYBRcp/A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SN7PR12MB7273.namprd12.prod.outlook.com (2603:10b6:806:2ac::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Thu, 19 Jan
 2023 19:07:04 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.6002.013; Thu, 19 Jan 2023
 19:07:04 +0000
Date:   Thu, 19 Jan 2023 15:07:01 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, kevin.tian@intel.com,
        cohuck@redhat.com, eric.auger@redhat.com, nicolinc@nvidia.com,
        kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        suravee.suthikulpanit@amd.com
Subject: Re: [PATCH 05/13] kvm/vfio: Provide struct kvm_device_ops::release()
 insted of ::destroy()
Message-ID: <Y8mU1R0lPl1T5koj@nvidia.com>
References: <20230117134942.101112-1-yi.l.liu@intel.com>
 <20230117134942.101112-6-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230117134942.101112-6-yi.l.liu@intel.com>
X-ClientProxiedBy: BL0PR02CA0032.namprd02.prod.outlook.com
 (2603:10b6:207:3c::45) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SN7PR12MB7273:EE_
X-MS-Office365-Filtering-Correlation-Id: c77b44c3-9dfe-44a7-7584-08dafa5059cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f+C0dPDwQkAWu/hKCQ/iy1oNxFiBWlIW7LsLhz6KWPgSbtz2ZBakAu1mZlTMjgt5a3NMHnqVClE7NiYeRVvxO6CBNMaP7BLJvh61X1Y+pgyvZgyYSJnrHhndiSywWOVABAK9qc8ITrQapvRzh6uNG7iz+eWajpQTWkPwVO3jiaNzNdaaP1mxbtyHw0NN0RXPlB1Kbbb/ajxyGcQnqu9HbIJjf6A/7k5xUwiM06lcVch7tntw0KvVNTYZAw7VARqtbN1a0Ih811OEWFa2KmuBWdx4SbvJTgtkwyD3jl4HJqABR+snCK3u+Gw1Icgldx3GKWocFtUeTpQLi8pVHJFJNrdjpo/7astl4/1FUnUtpeHZKpyQMzbjJbKSXQq/eGNKjF9nAbB7FnJ1H6ya9iJo4T6pKiwWgb+pRN0aFXBPolSX+Kl5v3RMEwoe3pUT0Jp6dFqj0ezqUc1hFO+jMv4waI8z1MmaJzdA7AqRikemf4dUF9HmO1wxcxxxqvaKhYYSXiGKaeVY/ygv4ytfllZo0QyLbwIB2g0cp+XGg/iCfLq1wiyspVvjLM2jfIdgXq9U89zM9DOCLQTADaRqUA9wQuNo2NYeAqr6kjgM5MZ0N0+Gf7acbhmwgZXyEUOGjibxaHTNzwArwQezm+hkfhFyVw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(366004)(39860400002)(346002)(376002)(136003)(451199015)(83380400001)(38100700002)(66946007)(5660300002)(6916009)(86362001)(7416002)(2906002)(8936002)(66556008)(66476007)(8676002)(4326008)(41300700001)(6506007)(186003)(2616005)(6512007)(26005)(6666004)(6486002)(478600001)(316002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rgkMwjRb2JXM3MTBT8AYolQ9cNZInC13JXaaImymWVTIfirIj0mbheaR1RSA?=
 =?us-ascii?Q?oSFr39XqbSF/2R/MgL+FnAZdFLAIrYfCLgIzBbCTjLQf7xiB48DsW9iQRL8m?=
 =?us-ascii?Q?GM1umxzA+eybrajnQKSIt12q5EX0WfznXem6tOkhD5gJ+4nawOlfdyP17j77?=
 =?us-ascii?Q?vYZ9/BAq+u7w8l8i/Ju0V0RUhLGgx1hDz3M6npXGWUPJQjSbHEippgRW5qDy?=
 =?us-ascii?Q?hPN806qE1uBBKNqDZVx+xhVHlKH4adlkUzux3zqOtJNTs77po5CiIcUxc8n9?=
 =?us-ascii?Q?G4SHdycySkW12iABnOf+kckw5qK6RoK7PjNd7z0SnlKGUK3zxcwdidiDmSvl?=
 =?us-ascii?Q?u9b5dwIfURmXMB5+lYe8+x/YNwE7luGGZJpF/sJM17Zi17/NA7WphcAiwKvB?=
 =?us-ascii?Q?r5LOB2iZV2ruyf0Co1lRSZXpGxeBJ2tJU4c9HuDo4RSatwx+7PLVLeRXas7D?=
 =?us-ascii?Q?oVu+II4HfBiXNR4BpBQ4pgeVMkmnTa+C03w6vYg7xRjoV2R56M0ZqNJVWzUd?=
 =?us-ascii?Q?fKKe2oz+pu/Xuh6mwrn6fd16VxeDPW5qwbaJBnLHSXOarK5DSahTZG+l5xro?=
 =?us-ascii?Q?CYzwhp0bcdKIzJmh+d5oc8h6aK/qQvr24Nv0DOIwnTzQd1Fcz39E+wKs2whM?=
 =?us-ascii?Q?+laBlf6gPHamBDu7KsaHUHSA+G8HWgjJFdmR4Yl60xqTu1jlwDlHecBHEyH0?=
 =?us-ascii?Q?do0FsAqh3HPNntmc+w1fhPghYhq3pUQSFpcJv401ANiZgsQzsX/8nim8F4Zh?=
 =?us-ascii?Q?kYcKtvm450HqP/AqNCsqESN+1kvM9x61SZkD8chprfltYGpJlC/bFT5OV7L5?=
 =?us-ascii?Q?EKJ/y6gIBp216Yw4/TbT8nocvPJfK/lYrFUcpQOoGM558tHc0Cc7SaMisQt+?=
 =?us-ascii?Q?Za0Nrj7nI22ni5ydZdV+HuhEu2esO/0gkuSDqfbKqm9EiWP9Q0tvAnHx9JLN?=
 =?us-ascii?Q?B3mtg77I8+HAfaSbef8mF3RYS+0fGSzPUJ+XSDw9HGKnDHHyAwaVpGLgxSJ3?=
 =?us-ascii?Q?Mf/QSJsXOxkvlwfeiIt0jB7pA8t79lSG6DAxQr+ahZzAaoOfesbgioUlmFRn?=
 =?us-ascii?Q?UxSZCzloVhBp7IFtqRbHWa8eaNDFpSLqBXiE17XnYCeKgF8wtKjb8BRnjo47?=
 =?us-ascii?Q?U+o98zmt/5LaA5y0GPvoLmX+08FT9Ykm5ByyN5qWdo5m1niz8s2fPBMhfHQZ?=
 =?us-ascii?Q?5YFDRWyapiG95950KdH7jCJaZ2mfmilcJTfvTLKjzdf13Eyi78NvcUkBdcL0?=
 =?us-ascii?Q?VO18eGA8ftCyz6lo8Ge2fLwMaFJqBWg7nJGYP2pfRvma1OGtldYUSJXY+wOQ?=
 =?us-ascii?Q?THtOm2MrXr8FhsSLAogu9hFhnF3UZGEogMnJZwnYm9qx3yYrMw01Fn6H36H6?=
 =?us-ascii?Q?AulkRWrMoxJzE0KMt21WH3faUlag2KU4YrOaGUG6oYV5UvhNHx6ZQaYpnJeg?=
 =?us-ascii?Q?3vigzV8bXguczPjZWs1x2F+mzymgk3vHkBqFTvx/JExio3YNF78LDcHNmwwT?=
 =?us-ascii?Q?ZHy2b0TukIuVw9nNeMlpQoRUp6dqYjUftQ/z8RCKROZ0sKRmKXuV39IYuroc?=
 =?us-ascii?Q?eihXG3H4LL/x9OCLWoqDW/nWv5VSuu+CTrhnole3?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c77b44c3-9dfe-44a7-7584-08dafa5059cf
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 19:07:03.9473
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 926Gsi+zObgoZs63b9t0dAwcqiao95LzrlfHgUpAZWK9E/1hU9ezVEJhlob0sVnw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7273
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 17, 2023 at 05:49:34AM -0800, Yi Liu wrote:
> This is to avoid a circular refcount problem between the kvm struct and
> the device file. KVM modules holds device/group file reference when the
> device/group is added and releases it per removal or the last kvm reference
> is released. This reference model is ok for the group since there is no
> kvm reference in the group paths.
> 
> But it is a problem for device file since the vfio devices may get kvm
> reference in the device open path and put it in the device file release.
> e.g. Intel kvmgt. This would result in a circular issue since the kvm
> side won't put the device file reference if kvm reference is not 0, while
> the vfio device side needs to put kvm reference in the release callback.
> 
> To solve this problem for device file, let vfio provide release() which
> would be called once kvm file is closed, it won't depend on the last kvm
> reference. Hence avoid circular refcount problem.
> 
> Suggested-by: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  virt/kvm/vfio.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

From Alex's remarks please revise the commit message and add a Fixes
line of some kind that this solves the deadlock Matthew was working
on, and send it stand alone right away

Jason
