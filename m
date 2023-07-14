Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE3D6753D4D
	for <lists+kvm@lfdr.de>; Fri, 14 Jul 2023 16:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235798AbjGNO2C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jul 2023 10:28:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235518AbjGNO2A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jul 2023 10:28:00 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on20618.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e83::618])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4FD83A91;
        Fri, 14 Jul 2023 07:27:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MwUHgKUi5coz1UPTPliR4uWT1tXhEQVEpzCHmg3KZTeSqdN8doG2MHsNtXoaRxao9nmYwZdyvnkJqbrjgXd2zdkqfJHobt1Yzr1nOOe/En7tcft5IQ9HGFbQzYu52l5RJo0d/S30qQz98uya3YFoli5RhkeR1a7DCj+0+yfR+Irp1kS8dw92G4FPnR/9zIn+quQY7a5DhUap2sVLw014M5l7DgJ8KBOMhDMYF71s902pJ9LuCTZnzzT7cKSO5x8NJkdCE7aoETlvOteBGZlAMqc3w1bnq04/9AcfTBzMu4IZ6R8f/nbltNVYLDbUcS4vAqBCuu5LWbMPM1XUoUontg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SWYLfvoVryiCJeMQe6DCRl5fWWDac6Hli4DPJX6j+TA=;
 b=lBnxNYVO2NylkJJlPCeN+2PihwQsHxZaeg9XwDsnmN18AaGz/oOUqNMCc+35uvrQ5vPgtpmtgDd2u7SsLdmlKZ50FVRKlF3+A0ZbcIEzqQLmGe0AT5jozdHoYLtsKzJIIUCtbXXaA8j/2RTA6mHxkGtFaAlOOsNtkLXF9ZdRz6k9kXqs7xmhJGxTMwLxtemsQLkrasBdHdjkT2eh6gqKRTHr4J2KhhZxT3LGy8XPqHKQNBknXWK9M1m1poJ/9T/6yxA8hcemKNFM6ljM56gyjfGuiP4OXEJ4iJn5RYAQwRn+AudaM2QAyTNBWD8nQzjaWVwEQkvaMIlad62AfHpW3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SWYLfvoVryiCJeMQe6DCRl5fWWDac6Hli4DPJX6j+TA=;
 b=Rt92XFmfW2HmPMWaDuIAF9xnMB4vrJxfY5rP9DMQQtlvGQ3QVCbl1LRnVQGmqhZFJatNP7+58KPMVZCsWJjWcxTvSW9KJehASyJHBVo4YhQtdyxuh2c43ol7HPDv4K/NA9KvrgwEhwmp/IASzHNvpEST9VjdCWKaOyYLURznwWux3Kp6a1pV4xq22rELXsJNhavOedsEeFl1GxU8GbxDHxDeKV0+lS0FZo+50Jaq/W8dA2/mrTysyP2q3W7+TxLSz8upov8Nt8a3Q+qGPUsO8zTe4KrDm2fiavvUnuf/4YcVkgVgGrK8Gx80Tt6pEWNMk7OnZJGyZzG6dCXROYzCjA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CY5PR12MB6348.namprd12.prod.outlook.com (2603:10b6:930:f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.27; Fri, 14 Jul
 2023 14:27:42 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::69c1:5d87:c73c:cc55]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::69c1:5d87:c73c:cc55%4]) with mapi id 15.20.6565.028; Fri, 14 Jul 2023
 14:27:41 +0000
Date:   Fri, 14 Jul 2023 11:27:38 -0300
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
Subject: Re: [PATCH v14 21/26] vfio: Avoid repeated user pointer cast in
 vfio_device_fops_unl_ioctl()
Message-ID: <ZLFbWkjNOoZujoWu@nvidia.com>
References: <20230711025928.6438-1-yi.l.liu@intel.com>
 <20230711025928.6438-22-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230711025928.6438-22-yi.l.liu@intel.com>
X-ClientProxiedBy: SJ0PR03CA0273.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::8) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CY5PR12MB6348:EE_
X-MS-Office365-Filtering-Correlation-Id: b18e3eeb-bf41-4929-bdb9-08db84767b51
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sf2L89lXE9/GDlI/j9+nJEiBi6V7OEkXJ0/1tcLu1z1z0ICWhJKrd1L35bZ+SKLgi6m4CFp9sspZ1V8K0IFY5lL7/lKNAR2xdzncd5HuWxWkAYPUgzdEZAMskIBu17SOqNRyCbiI5z9Q+M/V5/9tJkmHeQMhCSLFMrZLwPc1JqutCi+H+4Ivm0FoxtokCBEJWPqnVUXNFrHgawhh7/JQaJivGs/B5Go3AOzkWgMCsp2yJ9aSlrEOJYQTahtHGkc5ZMq7+WprmL8c6AH4Xc/HxncJwQ8O+DPdG99wQ5bADm9hwjhukFKyH0lOAw3PGUhFABxHsgCRvv9PsDSGxZi4IkbqEPEwZ6T7IG/eXL8BYDsP9v4T0VqkJhDHmPN/ybc1ECeXaGj/4CQYiyfe8y9MfjmYKWePqQyGZ/D/A8FlRNqUgNecCNsE+PV1SSCG93UgG2P19gQl847m2BEWORiUWgFllvQGj2yApzEWY8p0/HrXdI+foBby84wkHei9Vi9YYaa5MsaGvye9hfuk82Qu14fpaZAvoApSE1kTP4srV5aDD2qz32BzIrxBm4oQ+wAR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(136003)(366004)(396003)(346002)(451199021)(186003)(6506007)(41300700001)(26005)(478600001)(316002)(4326008)(6916009)(66946007)(66476007)(66556008)(6486002)(8936002)(7416002)(8676002)(5660300002)(6512007)(6666004)(2616005)(2906002)(83380400001)(4744005)(38100700002)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zzd3VP8vxcQgg7K28UJB08O7i63QJMO1IXa2iW7Kop5P07rwwTF7P4JPH3zR?=
 =?us-ascii?Q?iB4d1h4ZfWGG9vnzmlFhW3glB93HJA28kOc+sFhrGyVmaC9QBWeojyVWDalU?=
 =?us-ascii?Q?k290IqLeUExwdXpMKVilkMkp51J+iPpc6w8H1oHXwN7Wwp5g7MBJ+qgTHN3S?=
 =?us-ascii?Q?YH7oXYPQKLAHNTyeNwFBK2B5Yqec36Bb5S7py/rB4q4VcGM/X3Gzbxcq7U+5?=
 =?us-ascii?Q?lB5UQ5blSVLW8hdVCbTXZ9drtcX+SBwK1kzb/YVbqtOwRy4GbYIs2DCvNjMB?=
 =?us-ascii?Q?RjCmhXYJx+sX9THGz3XBgT9n/g65ugKCX+U8vyFizm34d76aWT1rxbJrxuQF?=
 =?us-ascii?Q?PSxKtafpix/GrjFz7TRIMun2No8kqZhzyYm6FqT9V1aVkA7hJU4MY1nUV1G6?=
 =?us-ascii?Q?Rr0fOws095OdJOY0af6IckJMb6tF5BS10fJsZaD2pz29HSXGINZctyxPsQRt?=
 =?us-ascii?Q?0ZJGXRCMW49W2EvxTIM5/7PQ7IXQUnuCDH/qKloSbrrleFz2ZsB9UlMSQNHJ?=
 =?us-ascii?Q?lX6ocpP2ffwuX/YHHPWKJh524ao2FU53YOLIm6PorPwup5hyxpQEyw7NyT5e?=
 =?us-ascii?Q?F+94iIKlsJxctqjYP8Et1UlfcYlz7UvwEW7h4usxtPz4WkbvWMgusGvAt+9q?=
 =?us-ascii?Q?GpaDd6GnMc46pGisPofYsxeN5DLrkJdmSldTC1bvNDfBpQzu6L6e8bdhIUtk?=
 =?us-ascii?Q?mnf2fLyKSkyR6tHvynXCZHokVFrN7zVusM6UVwXfYYwyjJFPiNIrLmlNo+QP?=
 =?us-ascii?Q?wWzhBJmEiEiPsmLQWJOT4Z0cN9Na2Q6R330+Q93r3Cxbfen3W/7B6sYuAr/x?=
 =?us-ascii?Q?kvr5+auMi6h0MXwrtIM9QM1yEkasuy+5VkHJ4bK20YIDzLh4pLhehFUDI4kX?=
 =?us-ascii?Q?ehRTN6CqgeIqTValZnaOmv/Lvpw/e2+2+OMtKFk7waUkbrS4qnUB8xedivfz?=
 =?us-ascii?Q?46Dp9NtuIBDj6+9WkfI6Yz3P8aLqgrXlqYAQIqQKi+sICJIGSDUUB4eTnDOe?=
 =?us-ascii?Q?DyOz3DgJ6WqZJNKsWiPlntx2vv/cImYJJbZXkm3xur5f4hW+L6ja3Dt+oY8/?=
 =?us-ascii?Q?2rQOVPr8+SNR69TIdhsVEvtaduvZHMt0CHd7LhBUtqvhztl/RwfQH5cBbjcl?=
 =?us-ascii?Q?vTqAykhF0fewPeP2uj32MiocmaoRVrgRAOZXYRX3bfFzyxv17DUf/XiX8+BI?=
 =?us-ascii?Q?F3TQWDCpJ6ipP7/O0d2FAG9P57ZBe1MaFe/YORrsxKOZzaqEfSq7YLfXiebH?=
 =?us-ascii?Q?Rb/xF36KKLdHrv3zCkuZAoHEPp2PnxPnc0EZDKVK0V7TyUj5vNZyfkh3KOE+?=
 =?us-ascii?Q?VONOAEchsMezjVKPD0U0Iqrti4hSLbtvI0bXJ/Cn46pjjcYXhEHU+9wEtJ3T?=
 =?us-ascii?Q?A9genaSrMXL5NNUPlg22ktO+hsGIHSKLYKvTSiE0cEvEK4oHyBbjp5e2HK8r?=
 =?us-ascii?Q?Ih+qJJ9+t80i4n4SPJLdnNWxieiW/1q2E9RkJcmVjxss8y5oNh3Ocqe850xS?=
 =?us-ascii?Q?e65yVIeAIKKmE0Q40w/ncI4NaB/hNrL/Wsa7yAxE4CtEI7txEAfBuwaMcfHg?=
 =?us-ascii?Q?TZufzITq7fxnlSkkcg9bDpSn2nuq5GiG2MNlJhaM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b18e3eeb-bf41-4929-bdb9-08db84767b51
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2023 14:27:41.5827
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lwREZFy/Lskl/C5n7+rCkcKqbFfLB0eBplJC6Q+sehT/pfI3Ms9z32LF3lVuLlTr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6348
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 10, 2023 at 07:59:23PM -0700, Yi Liu wrote:
> This adds a local variable to store the user pointer cast result from arg.
> It avoids the repeated casts in the code when more ioctls are added.
> 
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/vfio_main.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
