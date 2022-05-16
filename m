Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65D04529566
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 01:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245700AbiEPXlb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 19:41:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349158AbiEPXl0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 19:41:26 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2056.outbound.protection.outlook.com [40.107.243.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9527B186E9
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 16:41:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jwTAI93FSKR5/6WuPfiFKlFPAqPgXdT7ONEXBOgcu/w6sVNwnnJdjtRbI+9J5gmzSDiji3fHDyc1hGtS0Iu/YMh0FaAWmvze5WBOD5vC72PgWRsvl2rB3LjlOFz6MkX2JrpA0jBPLA7KkX5u+/LhwTn7JG8P6KZ1FrEpwOf5bfqPQnwmzsk71HrW6AahPj0kFUVRAk7cfTtaWdRQ1pQsnHldUAOXMDxVvPBHOFzW0EVbcBgSi84H0Q+enn9AHCjrVWv6Gvhv/cEOok2XMb93lKjOop1KSwAN8SfJJ+LnbDoUyeaT1fnQuxwUd8vu0gf9woszSJvnRpvOqUEzoesphw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3QxKhKV32+bxufA8/SzBeuxCpXIYPfeKxac8dXUsr+8=;
 b=PTM9oq9iw8BRulumIKv/4pDZyJ6JPOJLClGOADEBUpKCNCxNE01xTfUQOLGw7DaYKA7CCZKkJJX4OBFNBGMwNh2wCz298YAf4XMEquBoaRpCms4udZV0+YA1GT7IdYGmUeDwtpKg/Xl4XArMlRMoW94l4yFnpkOVMCKEAzJBymlayH4fOi9n0aV3W5xw52dSI/gx0N4I6cagh+Qt63qOjWiDAXt6K7zqS+1xr4pgWONySVfaK0Q9dFanLt6U9O/0iQKONCrqZHyMNjy1hfxTkeDMVvCRIwnwlzhgsIxUcgpx0EwXxpgTW58v6g9UEWlipYc/wNEVI53MkomAmBe3EQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3QxKhKV32+bxufA8/SzBeuxCpXIYPfeKxac8dXUsr+8=;
 b=TLtgb+m09GoeaM58y2w/kIEvXT0jxXLbs9hiD5130Cof3/JFG+GceNW9LUsi22J4bGM6b5nE5YdlKW3d4OvFrTGtRQEPayw5NjeY+u2Fn5Yocvyt2OXYUXL1Gp7XA94nWl//VZQcWy3e+gdsqyZrzHry8LSgv0F4aTzq7D87SRdaxq00qSmYwwwgbKJRQFSLlnbJRv5ONjrmTJyYxva9TzBBGN1Wr0OouF5yrXjeQAcsYC6XfeGw3OyNjIhaDJTX4f8lTFEFhzaqK50RhMwAn56GD4sQSDqrfl9ZqH80xvZZQjBhsqCLeE4w3MxPMdWEG8Ifsrr0ZISKD400RoS3og==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BYAPR12MB3319.namprd12.prod.outlook.com (2603:10b6:a03:dc::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Mon, 16 May
 2022 23:41:23 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%5]) with mapi id 15.20.5250.018; Mon, 16 May 2022
 23:41:23 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Cc:     Xiao Guangrong <guangrong.xiao@linux.intel.com>,
        Jike Song <jike.song@intel.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Nicolin Chen <nicolinc@nvidia.com>
Subject: [PATCH v2 0/6] Fully lock the container members of struct vfio_group
Date:   Mon, 16 May 2022 20:41:16 -0300
Message-Id: <0-v2-d035a1842d81+1bf-vfio_group_locking_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0188.namprd13.prod.outlook.com
 (2603:10b6:208:2be::13) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cd7f1557-bcee-4468-4a4d-08da37959606
X-MS-TrafficTypeDiagnostic: BYAPR12MB3319:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB3319DFBFCE92E004BB938D2BC2CF9@BYAPR12MB3319.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xqvy96NPszsFQF5gL2Q5C7m9ZBEQTg05zO+NyNhia68KR5GGNd0Y9bvd86mOjFveGg0J0plTVuM4nPoOCBto2rqYUneBg9pZg1Ca5kGAzeBlbHVfHUa0CFliO/I2IpLkjwJjLLoyhqEweqKbk5FUjAMeKDuzkIyZ8Tw6n8ez80SoTeZ0Hau0NRB81PgvfnCniazcuwGBSeqOTpbtgJcDncWyPxm6b+P73fZY01g/UouJPgxX08rj6o91AqO/Lc0lMBU9PdbGFe0jjRrpfsdbLgF/7xBFtTLzrkccAaK9aCwGdia6KE34I4qWWjXHqJNM6Jx7/2XONXumwnfAYwB5PgzDWfrKmLhZQbmWRyl8INj5I4t5bYKBs/E2HjxTT+vMfPwjMn1J8pyLalx5bPbU0oDluq5OZjUSPSu6kGdJwfowbQ7hq/RhDt/P8b+P+cfbpTKMmmhLaH9clF6VS1hAVq7Bk6KroOX1lW5G3Yv+vZRWan4jCNm3ei35G8q1f4bc+Ew80HygchNl4L7mlR3erW13L3WGDnNbKBxI6TILJzt/Intio2YCngU5/9ai6bsuGD27mvtB7CPBsJg0KGvR1VnwPfeFBpBX2I32pcQRrAIcRhhZB6pmKI4wR8VxEUpKkQlPaVXpP3aIZHw4lLNOBcJso4miDi3y8kZByFKg5Mv8A9jYHyMd60xFAbxclBeBQY40ZeM+T4J3Faz8gwbx+Pq7LWmaVos5vgv+taulwz8iozsKqVAKMwD7f+86l+GBinzxOKCrb5yRTlthVO2YOTvp+O4waN9FDk84NhF5VqY+U315Sik3YejvhVRhWQZQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(66946007)(66556008)(8936002)(4326008)(8676002)(66476007)(86362001)(508600001)(966005)(6486002)(186003)(26005)(6506007)(36756003)(2616005)(107886003)(2906002)(54906003)(6666004)(38100700002)(83380400001)(6512007)(110136005)(316002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tadCbiXM+eynejn0O7EibloPUL4QB4TmC+yFa61qRKjlHYrRw8ultUmPHHLI?=
 =?us-ascii?Q?CSKilKzONXn6ncnMEQc2qRZ0MCh5RW0CP1kpOmkNAQ1EzEJKQvJsuse9ccOO?=
 =?us-ascii?Q?xD9ZPLeKds432+Szy9xOvTEeAsZzhTQJ/xkeL5qjVVgDXLoxb0DquatSwoZs?=
 =?us-ascii?Q?01tlO2Br2AcjD0EDbSvPty5UeItZFs3vUfL2qkjFXuizYEIHy092j75H1PTq?=
 =?us-ascii?Q?mglsa8TOUsiyGTp9gAzK+XF2Hb0RoRSmH/oN+v2cmhT/kxO5IdlFGpsgP8bb?=
 =?us-ascii?Q?S5UBIVh2xY9XA87WDA9Q5IEg3yUITSnGDlaoPsCxi6ALXtbsj+TIIw8QiDZb?=
 =?us-ascii?Q?xXpB1ZTKsydPdq/TS5xuFMCjWiaFMLzBxeP5VtawuTdK8a+bZsBKIcV5UvqK?=
 =?us-ascii?Q?QdrD+l7BWTCPWsSBfaMAXzAgv1IrsXvMU+CYbu4F1W4HqiC2R/Ipu2XWY2wd?=
 =?us-ascii?Q?sj75VKLZn2LEfOivugnOL8rM85XAhU71p5AJho2C9ioys5yJbRAhsPBVPm5B?=
 =?us-ascii?Q?rFQC0nM36tr6KZSdt8vhJSVzOgFFCNiYblUIZ6+0Dbnihw8KsQaDBMrTfM+e?=
 =?us-ascii?Q?i/R4agyjBncGFX7hdLMIndh+/fNiOCcCClpI8LW/E1n8Zr2+IH7OHVfXNmxO?=
 =?us-ascii?Q?ox7L1JA8o1LmAJq0YD22JUgViRZ1H3VrcbiVSgIjZlMW30mmOTpA0E2QmdeX?=
 =?us-ascii?Q?AvE9PvbVE8YhoVoq1Drye4YL1E14cwzg1xXZVSFuW6wFLMUsBEq9rP8ALVyK?=
 =?us-ascii?Q?J9ri57VExxCkniHUkVB3bayl4XB90Qm4YLqlkURF+VKAapkDUsmhPxnAdyV8?=
 =?us-ascii?Q?MyHqpJ/07kvQBJ8L/ygmyF4x+1gil8yEEgYZC5Fr8BJyG3X9yJyASUpHLfpt?=
 =?us-ascii?Q?l0JUlgnO2ey569PQI0eb8NiLDyeVDEjZj4MROYsXjrNA1hlCfmpxFVrPoGLe?=
 =?us-ascii?Q?Ym6bb992LQAvJlsUbaBBA0xZXKKE2qfDOKNAENkxWkLIWyCsw1hfxXFRtQlT?=
 =?us-ascii?Q?9mdviVKDfLYb4pdjaNoKqVMDfmuUMQXs3ZrHXgfEv7vRINxiC127INt9qxnm?=
 =?us-ascii?Q?S+mY/pq6EgBRW9a+Lk1di7s2gtzyoQvK89VH7TPNbXceezHbq+S7QT1tvi3S?=
 =?us-ascii?Q?fHvEcurrGH8XlvKML8yoyv6g0KHm7XcgVxV9cLy5O9UM6R2dObYkoGYyO1xz?=
 =?us-ascii?Q?USNaW8Ms5SddlsQjrK3JU3M+gNAk+38RjceHlzqfnS7t42ylVnBHOYOt/MXZ?=
 =?us-ascii?Q?WS6s+3BLtqkUd5c90Qi3Nko+nVWRnhK6KMtBuDBb4jAxouIjX0IqXsobRG4+?=
 =?us-ascii?Q?N/3lplutsz+4hMc16z5Ch5vxmS+r10QYXK9Bvm4k+CRL1XjZx8pAhw4JMtCG?=
 =?us-ascii?Q?m7+B6I/E13/0CrZUBOYQ6P3nJuxky1SKjrfqcolSw2wvSxsms6GMJlHUPY1x?=
 =?us-ascii?Q?GehSjU9tNynimmwRUhoBGNtqU3jOsdVMQg6pPiyTXgYDXYEGmLhi+FFI8gnz?=
 =?us-ascii?Q?97HmN2Ktx7PAqgBhkf2C1GSzb5Ni7GjvHk/6hMNztSx6EA+32BswEiDeDyAm?=
 =?us-ascii?Q?F5PdfHW1B7Q8ii8hX+tBzjVR4aGJy03aDWwE505cgeX+ICOGeKpuShRNvydI?=
 =?us-ascii?Q?LneSqsL0YnQsvK12+bXq0+tF1blzihHuWpWIslhJu18YtOsKVuZQlUmR++2J?=
 =?us-ascii?Q?0kOYqyCqdsrEp11bQOZgCkcH4X7R/HuprmrM0HJA489gn97zoZhWF5Y0XVf4?=
 =?us-ascii?Q?0ju36MHB6Q=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd7f1557-bcee-4468-4a4d-08da37959606
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2022 23:41:23.3933
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P+5ck02V2TLVCBPdIY5TcLywN6hAtGfwHWrrZTd33N+R7UvkI4eTHXc3qvqndeAs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3319
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The atomic based scheme for tracking the group->container and group->kvm
has two race conditions, simplify it by adding a rwsem to protect those
values and related and remove the atomics.

This is on github: https://github.com/jgunthorpe/linux/commits/vfio_group_locking

v2:
 - Updated comments and commit messages
 - Rebased on vfio next
 - Left the dev_warn in place, will adjust it later
 - s/singleton_file/opened_file/
v1: https://lore.kernel.org/r/0-v1-c1d14aae2e8f+2f4-vfio_group_locking_jgg@nvidia.com

Cc: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Jason Gunthorpe (6):
  vfio: Add missing locking for struct vfio_group::kvm
  vfio: Change struct vfio_group::opened from an atomic to bool
  vfio: Split up vfio_group_get_device_fd()
  vfio: Fully lock struct vfio_group::container
  vfio: Simplify the life cycle of the group FD
  vfio: Change struct vfio_group::container_users to a non-atomic int

 drivers/vfio/vfio.c | 266 +++++++++++++++++++++++++++-----------------
 1 file changed, 163 insertions(+), 103 deletions(-)


base-commit: 6a985ae80befcf2c00e7c889336bfe9e9739e2ef
-- 
2.36.0

