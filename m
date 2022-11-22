Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 159916342A7
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 18:41:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234209AbiKVRlc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 12:41:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232660AbiKVRla (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 12:41:30 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2073.outbound.protection.outlook.com [40.107.244.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 164647990D
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 09:41:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lJv3BMpagXqQtyqhyv4cdJNI25z9MJcNwrBtR0/8l5M5Gxu2PvOgnGat7iPuOw/mLSc+c6MmGG6xuCpbhRHbd+iwBnPzxvfZyCnyqxKximshjAZCCVZYq19S77LI3Mxh2EqifPGjb7G00rlybUi542a/dciuaYrou2b2dhObeB2mFGxZYSIuhy+2MBLX78MCbcxx4JCofdN/seBsjgVf3Q1NHhuT1dnzTi9cB73cTA+xBYBfyYcuoNtrMUs9htHERstGHXviWhHWeJqtgAyFEVrCY7Z5oHkHysGVLmqfUOigKWDha8JqbIA0uBa1T4dRtY4ZHN32nEJWbQ+tCXn5mQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qaBI9x3FNPhNDo2avcNj0+r369W4q6MhyT9r/M0SGjA=;
 b=XkFmbH70h5O3qm9K8u4aEIEc9oHFMWSf+FeQGmhOUQ4eX+uao1V0L/ODvQZD9R+GdcCL98x6I+GMb8WBFbT2jPGwwiZXR0P2Xru7SBnWk4lpAj8fwcVFlnFjEsW4PWFhYW6rvEe8KPAFEjiC+TXb3TOXg+rkCuPimcLVhZx1gl5yGgUiB5yNWN6+HO4QVhr73JXWcw+/wIZiQ0GWvo7e4x1tJ9CBq/vn5z2I19lmHe4k53pej0/HT74l1Hf0wX/6BNfSRJza0Ttyr1xFQP5y3Y+ZQYJi3Vd0o8PYFvZBRqYF+ga6e13m49hz0x9+zz2vNGdJRzfkIJDqZRLz0QwfOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qaBI9x3FNPhNDo2avcNj0+r369W4q6MhyT9r/M0SGjA=;
 b=rlTERKQIy+jM7oLaYh0sGYzGBDTRbelbsCYx+0DtbFn2p0EMZaOEUovMWpq3k8hfMtq3cmh5QU3bmh8zL5FRY3HLMPMe6sACp4AQKCVODioPtmS0NZKrV4+f1nONlrOXbsyQTmDA5IZEMPdqyyo+LHxuAfgAR7jTTK9MRt4IBJ0Kk5w3qtZdqisFM9DEhpJlnDoiKbX5Wg8VIMPS/Cpu0PyQ2yeBkLzSfjrur5QVC4RxS0BIvLE2fZiCWFXV820U4Zv6Ujn6rQzlJec83lmWzZyOubms4qd0+r1k/58+c6xCGAcw2ooqdAqAreh4GdrFTGUB93Hhy/ezt0iKC0CjDA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BL1PR12MB5254.namprd12.prod.outlook.com (2603:10b6:208:31e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Tue, 22 Nov
 2022 17:41:26 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 17:41:26 +0000
Date:   Tue, 22 Nov 2022 13:41:25 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Lixiao Yang <lixiao.yang@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yi Liu <yi.l.liu@intel.com>, Yu He <yu.he@intel.com>
Subject: Re: [PATCH v3 04/11] vfio: Move storage of allow_unsafe_interrupts
 to vfio_main.c
Message-ID: <Y30JxWOvo1oa2Y3y@nvidia.com>
References: <0-v3-50561e12d92b+313-vfio_iommufd_jgg@nvidia.com>
 <4-v3-50561e12d92b+313-vfio_iommufd_jgg@nvidia.com>
 <20221117131451.7d884cdc.alex.williamson@redhat.com>
 <Y3embh+09Fqu26wJ@nvidia.com>
 <20221118133646.7c6421e7.alex.williamson@redhat.com>
 <Y3wtAPTqKJLxBRBg@nvidia.com>
 <20221122103456.7a97ac9b.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221122103456.7a97ac9b.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1PR13CA0253.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::18) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BL1PR12MB5254:EE_
X-MS-Office365-Filtering-Correlation-Id: 82caa9b7-d10a-4730-a83c-08daccb0c7c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GcFJAydRW75oBRTIbgUa7K2JUwzVeYupilygULSM7aiH/54u2zdwG/L7sQDqp+o/YEM+K0j3Mbnkbzt66aJbGw8zadRVXkMkuj4zzuRbDK7vrPu4EVmMGpy9mwN7tYRXN8f+KOy7SWNQXYclAmLBgjhVDPHUfFl0Uzctd8S9WZjtVPblmzM7qPE8Q08zpHYM2umlydgq+Bgq/UGANDcM93IiH27pqFO7bD9sVaXEyqclXlUxtAtDfmBb4nOvBYnJUlGBm37RLs6FDOVIFTB/OiH0llWAhjTT4sEdLQXEHGIEOg/wJtVFHWyoco2V6BEskFbwwKzZnb79h/MQUcW+CYwZsvRq79QokbEeQ/UoKCeUyMdJREqYIXQRSW6Md1AC1bkyNLJlDL7tSuef5LKdfg6vGavyVhdKyNuMonm0UeOSXtQmJMBAar5WGfQXtcghtM9l0hP+WOrJJM1oZg7qQaSkQXtZFNWgLZyFMXM74WkoD4w+EGJKC0iQa+Sefyq+QN0V5uyZeqZFqFBTGupCDlX2fhQCUr3a8e7Wd2rPc471Nb+wxGE9hFPX+uzP3TnWb1zq9S2xVt8DVA7RyqAY0HMSidtqKJBiViw7zBnRrUcJbJqECU0CxVurVG6GyQfQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(396003)(376002)(366004)(346002)(451199015)(36756003)(5660300002)(4744005)(7416002)(2906002)(66946007)(66476007)(4326008)(66556008)(8676002)(8936002)(6506007)(54906003)(6916009)(86362001)(316002)(26005)(41300700001)(2616005)(6512007)(186003)(478600001)(6486002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8c3Ts/WnqRkDFKUIaojRcCgCeF0edk+bziTdVBt5ZrT22rIrgJbtS9bXFUgd?=
 =?us-ascii?Q?/SX+x1l2Xs3h9Ov+AJoWoPK/XOB4dz5iVvCRgCkD6j6qPfOkFWPoNJ06sBzp?=
 =?us-ascii?Q?Pm8bY+YXPvtM3pUBD2SreJUB5AJaDuzkqBxnsQsAWy1VENVcxs6d4cu0X3LS?=
 =?us-ascii?Q?1HQJkFlJI480thvs5Jh/yX2On5UlllmOU1CROHfFRkRyTy1K6+EU1OJG6gxl?=
 =?us-ascii?Q?7wJ719+O2FRDL4bjlC+8BI96vVSxcy5MqpGUNVe1oHF+4+jqoRf+aGwEeYog?=
 =?us-ascii?Q?wwATjOKzE780WHhwdIEVzILTwMI+wCM11O3PTKGm7bBZU/UUS67AiAdTzXUG?=
 =?us-ascii?Q?LgrV7AILQdrEK4vVw+qRgFl5gM48nE4gWVUd9fnSwi/QWW4BxRFoiWjUIGQE?=
 =?us-ascii?Q?7bJ0gSiKBBLb6Zj2mgepKPix2yfU320xpY10FHBwZrDLXiDG+LK8a2VxWQch?=
 =?us-ascii?Q?zLnUd7RAWboJl5qYrd8lJpackYzvVAQ2RUl5JSMbJJFSVpce/gw80krOvkX3?=
 =?us-ascii?Q?CGLe27+NTAZfvNWltdj2z44UqKE791WRcgp0+7Z4IL3VjaYp6/mbtgJNR6Ww?=
 =?us-ascii?Q?RqmGTiT/Wf7FfIveTSip2sA8B1RoGhtbpVMFV8RxipIaF9eoiVjr8IQIOsah?=
 =?us-ascii?Q?uf47PdA23Xn36pTlf4wgr7AmwYshOC+NSFf7D2aSK4qkrGCODI4LW3n43sn5?=
 =?us-ascii?Q?JcFZ5+ljnkZ/8BV0GXjEzs9d4t3D+EFjtwN+FLgkgB+A1NGtCpcQPGyeC7Dm?=
 =?us-ascii?Q?4C3OAP49G0vs401FGhlE/LvJEP5np/dH5IIz33Gl8JVLpGApqnDW80gC/Acq?=
 =?us-ascii?Q?+ozVlgiCZ2cDObXp4okcyuq1ToHDPsDd91uGzejikTmMUnro10nbAhr5Vgwz?=
 =?us-ascii?Q?ak4JEBJG6WZlpSB5X44Y2nR5SRaUKFq5w6hpcUtQzLCy69owEYSIdRHFpz0L?=
 =?us-ascii?Q?vGrLW82Z4zj8ZWq9P9EE+8I8KOT2epHZsoC0ToP8rM1CeU7yUFN8W7zUTBie?=
 =?us-ascii?Q?wtW5lSA5yC+u5gW3R55o7JqI6cmkrjc9VtSHaTzUuGJSxN/rPA2b0fF64187?=
 =?us-ascii?Q?ofBHlQPYiiSZhAyD2sdYRzJNmnl/PnyjD2KKBQeyqxiRzNlWWFOGCvCy/fiS?=
 =?us-ascii?Q?JXS7HlFAW+8qN5eqKfX11O5BtJ10XgxRrB8JbTFJXVHfPbRj9DJ1cmkyP309?=
 =?us-ascii?Q?TjDBkh0IIVtUr4gsvF5zQZkEmoGdaQhXG10SmUCCeX1g4KoMSdM2j7guq1ty?=
 =?us-ascii?Q?otfO1YaBRC2+GsptYX1stihO8NC0L83dZ+V2Bccn8x4zuNp5iC1MrB3EF0Os?=
 =?us-ascii?Q?EqkQHabiZfE22PwEyLDXqE/rZW6VX1aklrMvQytTBGRADZNPl2cXDBLK8+be?=
 =?us-ascii?Q?UYt8t0tLt7zq0mp0Be9gM4J4uaKKVGYO3TIVqiuhvB2fG7PtFtw97diRRNbk?=
 =?us-ascii?Q?HHOfxX+K5dYqh9NrKI2htykT/xFaFUXhHU5TY9ryH3Smr0iX6SGrEENwDWaj?=
 =?us-ascii?Q?1PVfAkIoD51S710502C96qgx3gOKACo3yPAzPNMCrkO+IpX4nZsdR32q0tt7?=
 =?us-ascii?Q?U8rmPXdCxF4Z9rmQwHU=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82caa9b7-d10a-4730-a83c-08daccb0c7c7
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 17:41:26.5490
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8PRUXWDSztuFrQe7k1VPUSWEyZM0cO62x/nm+KrcTKfyr5wjGRWfYIozcGkG4sEB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5254
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> BTW, what is the actual expected use case of passing an iommufd as a
> vfio container?  I have doubts that it'd make sense to have QEMU look
> for an iommufd in place of a vfio container for anything beyond yet
> another means for early testing of iommufd.  Thanks,

I don't think there is one in production for qemu.

For something like DPDK I can imagine replacing the open logic to use
vfio device cdevs and iommufd, but keeping the rest of the logic the
same so the FD looks and feels like a VFIO container. There is little
value in replacing the VFIO map/unmap/etc ioctls with the IOMMUFD
equivalents.

Jason
