Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3959B4E62A0
	for <lists+kvm@lfdr.de>; Thu, 24 Mar 2022 12:46:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346172AbiCXLrn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Mar 2022 07:47:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239148AbiCXLrm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Mar 2022 07:47:42 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2072.outbound.protection.outlook.com [40.107.236.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 762FD6E352
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 04:46:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fPwYcX6gSGDNmhCssST61aSphAlQeZFP8Th5lqFq34mnp5y1vbcQBL8unjN+GynhyfvyP/6R5gfyNMqo61QpTNlZulYQGf8UeE7DHMQz+faAg4Xk5cAb2qXI8jjndO/js2KoZMzeUyhVPzjOqQDlz0MZ1a3JGy5zH3Bo1vuLwzB+p3gYvURQweptq9ye4rnyo7+QL3vUim9ZVE30q05Z59Q1RmRhu1L0A3kxL1euHTpfZUxl60nuUqGze/TUILn+16FfTE5waBi8CbPzYdMq1C1pNhWEiglHQsZ6EiTjLsHEer/xNefn/teoP/Py4v+Uv2PbW0iK1GFj/zYYSLYafQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2rNICa+fbUVe7PFjeh614Tq7B3bIjAEJcciDe/hwns4=;
 b=fc2iEwPqLu3hb5ydn3QgM2mNl96EXmbshm0EOcjER71pFKfhGNeHrSF43AJLUFs9rAwQpR7OkCUZHvdzglrj/0EzzTlzDHz1T2LHbl6OeH1TLPlEfOYLHp/KU1V19utmcIUUbGRy9SajC0tVxi0Xn3r+13kKEz0BP2hhT9OMryqXK6MjcSeArA+IvZSIlTslSd99MtD0pTNeMs0RbYFbLMLhTJBAkE+AArSDSA4Nu6C0fPbtFHa1Kw2BBUpW2Jhy9NiLhX3vgcNt9MQR/B2qhK5VfQBNvs5wUjpwd5mAOwMkQb+RZ31u/M7uMQCidWF/01pBE9YSAxCDQ8pIBgN2OQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2rNICa+fbUVe7PFjeh614Tq7B3bIjAEJcciDe/hwns4=;
 b=ZFCTYFNauz9y5O5eOBzQlWJVVMF4N1uyOE3cKXxMh/OflSx0r7tFtEhUVULkhV+UWPUuZkYJVyaD4sc4PMxkyWbCNKAb5Jei1DBg68tpGyrOzURyCu6bqQzkC63MJ8Ng5O7a8BL3k87hqVj+BYPd2bRFnZoaVlkJCLA5XqmF0kj5teIlCDqpFLJSI53sFvTQTOiFRhAZPaEX3ZYiIlgSb7NbbFAO9eUJpSprWK/Rt+5Asf+N37kUiplv7bBS3vL0+RgJATi+K5q4AMPkeGZIP4N0NbxZ6rPGZ2kPoiMRFaCe3yAlDXGCISNYsKsSRjkOMxz0z1Agbrbjzt1L0hf/lA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BN8PR12MB3027.namprd12.prod.outlook.com (2603:10b6:408:64::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.16; Thu, 24 Mar
 2022 11:46:07 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c%6]) with mapi id 15.20.5102.019; Thu, 24 Mar 2022
 11:46:06 +0000
Date:   Thu, 24 Mar 2022 08:46:05 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [PATCH RFC 04/12] kernel/user: Allow user::locked_vm to be
 usable for iommufd
Message-ID: <20220324114605.GX11336@nvidia.com>
References: <808a871b3918dc067031085de3e8af6b49c6ef89.camel@linux.ibm.com>
 <20220322145741.GH11336@nvidia.com>
 <20220322092923.5bc79861.alex.williamson@redhat.com>
 <20220322161521.GJ11336@nvidia.com>
 <BN9PR11MB5276BED72D82280C0A4C6F0C8C199@BN9PR11MB5276.namprd11.prod.outlook.com>
 <CACGkMEutpbOc_+5n3SDuNDyHn19jSH4ukSM9i0SUgWmXDydxnA@mail.gmail.com>
 <BN9PR11MB5276E3566D633CEE245004D08C199@BN9PR11MB5276.namprd11.prod.outlook.com>
 <CACGkMEvTmCFqAsc4z=2OXOdr7X--0BSDpH06kCiAP5MHBjaZtg@mail.gmail.com>
 <BN9PR11MB5276ECF1F1C7D0A80DA086D18C199@BN9PR11MB5276.namprd11.prod.outlook.com>
 <CACGkMEtpWemw6tj=suxNjvSHuixyzhMJBYmqdbhQkinuWNADCQ@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACGkMEtpWemw6tj=suxNjvSHuixyzhMJBYmqdbhQkinuWNADCQ@mail.gmail.com>
X-ClientProxiedBy: BL0PR02CA0144.namprd02.prod.outlook.com
 (2603:10b6:208:35::49) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 286fd7d7-bcff-45de-4734-08da0d8be1a3
X-MS-TrafficTypeDiagnostic: BN8PR12MB3027:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB30273E66833127E6EE5920ADC2199@BN8PR12MB3027.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cJdXXkFhHIfdQ3J28U5KmjkqQrifyZkNBdR1JjBhmCWEXBm9cic2GB/0snUQG5IWCLL/skptEgpUxOGncva+QfmyBAieD3a8q5ikCTTpO4gKpil7ja8y08MQDiKFLTPPr5Q3fP/aCfvWf5Ldb31zCLslBOSN8Y+PLMjZyLpvojPMOJRVdYkG+dS8DP3AyyHldmLxcfAOR52UclpU4BT3fk1vRL0G+Sw86UdEW786ZnYSONWmgbmyQSiaJRDU0fy0sbeJ7OYUzAQCFNXDc+vRdOMo4IgbWqx7iM1gPAUYOD15pkiA0uX/Av4RXgwY0Lzglj0Uj1ZkBAlLLaEkZj4KSTlygw9jIgr5ghnGLSj1ym7g1p468AZuKaG6hodZ18X3Pn7vQtFlmxSVxwK4czpogLDW+xG1CIYaNgjnclx7VDstu9WiVOT90d+I412SHUjM5+Ccv5OoguD74yKkXkn0S570M6+SNTTEk+GsF+GQkrRGtyRLAIMwsjgsTY+7ZLsL/xYLKzxw82lraqOzVY9OhV6Gpw5eiZZhF6txQ1qPu0LROUuvrFSEa+UjQ66mLd1Ev3iabjR1M+8ZSeCwZ/4q+YrtdXssPJjZz/greS5IaAiCX1/EuEBiCcRSTotX4KF/93IIHyh6MU/zl/l1hUsS8g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(4326008)(66946007)(66556008)(66476007)(8676002)(33656002)(38100700002)(6506007)(2616005)(6486002)(86362001)(186003)(1076003)(26005)(6512007)(54906003)(6916009)(508600001)(83380400001)(4744005)(5660300002)(8936002)(2906002)(7416002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?cs6PHT7qBtqfPPQOwP4buEMYCrSNNHMW26vOXlWSlIiEsQSrhHvJ0vI1Hd78?=
 =?us-ascii?Q?pcvAU0HvfaWPxgLEs7YJYyQtBfjUXunHCa7yVXxPLkt1RQaZzO6iDw/Lc1v1?=
 =?us-ascii?Q?iv/bU1NDvQJg1mpVhM17DVkVwEuLVXifi4TxtfNuUmBc77zF0vMgrIwjnoPx?=
 =?us-ascii?Q?biS/S8bOCttGC1wCB+WWuwaOnZwCOC+XVeTntLeITl0eunafcoVsF7NePoRz?=
 =?us-ascii?Q?Te6GlrtiK6jsDvMdWK5toDU9V6YeYqiqfqdHCgQFc5J8Ce7FWcE45DqLhyfd?=
 =?us-ascii?Q?05njo55SUro0wETPUBw4tMwEHQjVoAPTbrWaewjBoDkvNraVYz4hicpK+o5e?=
 =?us-ascii?Q?Hmkqniwe5983tdzMGM5Hhe+yGx7hh8fERWFunadNCVOnzf2KChe3tfWwKUg7?=
 =?us-ascii?Q?zJTkrAM71/ogKk1WhckozOVh0s+GspMnrnARHtjrRIFrC25PantJhMzHWN8T?=
 =?us-ascii?Q?oVSfDaJnpzAF0HkwAGK0pP0Uxg66m7UJmfPlXV32VtJ/N7YlVp0xBBSA4a7u?=
 =?us-ascii?Q?kZvJg6SkCeEBHBARQG0GhBm79Etf1wpIuZxHNvgbXaMOYIue2fbXj4HENvai?=
 =?us-ascii?Q?Dt0pg4oMulYzEGqpQWLGrIMA06PI287EpyCgBeF8BDL7xUYu2R68e0zXLrUn?=
 =?us-ascii?Q?tyN5PiLTeQz64t0wDH1uKMW2c7bemSpaN0jq757HOiJAp5khIgRbr6CDQDcm?=
 =?us-ascii?Q?/pTzNxGpSlOkm0XJt1eTEJXPy38sB/G6xbmVcLl0WPujyQzJ4W1OdLzBsy3j?=
 =?us-ascii?Q?+zxYlVBiyCMf9kxsuzL6Hi8eG5ic4XuvuIg3CXG/jyelFbgqRh/2oKRDdyrs?=
 =?us-ascii?Q?jFWFAyvY9qiETnherQmn3g+CW+uL9cM0RG9zmVYiQko6wbgwqLTnlvcNuhH/?=
 =?us-ascii?Q?/vnq4vf6CWSiKJDbNJQmVz/UpRp9dUfmsbaxShO8kx7qib8FKjP/0Bwgw4rT?=
 =?us-ascii?Q?53B03S59C8D81WfkvUJoAH4EGCy6qJcvfxeFwIx/2rKMy0ZZhmgULg1saeui?=
 =?us-ascii?Q?pQVH1l4uVlXBb/dpvDiZmFr/Yz1FA67wZhabhOgehSyWKRVw9zP7WFSNTZJP?=
 =?us-ascii?Q?LYtAw7u4OcybntkHCl8GSfudikNEtsHtpUSecXwbP0BdzMO5W6iwxv2DSiLO?=
 =?us-ascii?Q?+ayVAHLpA9HzLYBU3EOwfKgZAM3nDmNrfoyrMF15rL2lxP8n5yvzskQMQtOh?=
 =?us-ascii?Q?JqrZS20gKVu4I6mq+6bW7SykfxA5eYuycDfKrbZclavzKMXlBLPgPD4IRyDu?=
 =?us-ascii?Q?6DXC/OCBtZmJyKWC8oulRAlWcdWkdQV5t5suN7jeGoI07LXV5jg57rGctwWU?=
 =?us-ascii?Q?eqXUtUnwt5o8voGCzlGJ+HRriApNc6JnEog7NE0LclTwiC4qUApCtuyOB/EF?=
 =?us-ascii?Q?Vl89FKv7c/TiKc38NMhNz2K7EooSHQHh6cP3dSary1L0PPJCRQE1aSV/uSAW?=
 =?us-ascii?Q?HSV+nF+fGkOtZ2AaSL1Pv0gQ+gNmiN9+BzWaFtZVq1Go+vpMhaObMsFD48TC?=
 =?us-ascii?Q?irHVGJm0K0yFaJ3/wBkHf4nNey74mLlneeNraaE8N356f7osqW5h42T82IF0?=
 =?us-ascii?Q?GBdbUXyYHe7VgZ60oyKA6v2en486dCLgO4xR2XZLe9M2v+4ID7DY5fVZX8Yj?=
 =?us-ascii?Q?Lx+uIe/6D4qn3DZUvFn+fycUbWdxF2jlMAzwkkpM+fjQsXI5iURcWBT7+cfO?=
 =?us-ascii?Q?pLKH6/MOI+rlHY9K2qUBNp1NdUQs/CjQkuL5NCOrTdaL2Pk3OeiAUhktgpOH?=
 =?us-ascii?Q?rPx12HdrsQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 286fd7d7-bcff-45de-4734-08da0d8be1a3
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2022 11:46:06.8847
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X4fNg0yOuxpyztNcvdGXqigg4P8vZ919T53L8EkbfM/PPqoaes5H8kFjyPmmO2Aa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3027
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 24, 2022 at 11:50:47AM +0800, Jason Wang wrote:

> It's simply because we don't want to break existing userspace. [1]

I'm still waiting to hear what exactly breaks in real systems.

As I explained this is not a significant change, but it could break
something in a few special scenarios.

Also the one place we do have ABI breaks is security, and ulimit is a
security mechanism that isn't working right. So we do clearly need to
understand *exactly* what real thing breaks - if anything.

Jason
