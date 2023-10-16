Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCBEB7CA6E4
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 13:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231508AbjJPLmP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 07:42:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231180AbjJPLmO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 07:42:14 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2041.outbound.protection.outlook.com [40.107.243.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCF3CDC
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 04:42:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fUXdp9x5b2ITq1k+hgArTtcO0uFF26iFtfmR33cBVnrTeJZ4mUjrraAVZ9ZbMrs1LJlxB4r3OzRZiVj+SfLRdtzJPlcTykqU6i7Taj2vvdugtetF+zjsB7ps725bA4Xwhgzqj4ivuCr/qZWEkFsK8SxzlFVkUDzQfCVYM6ozsx7yCAjuAQxdkiteTaltCRqt1TL87zDD8iHkpX2qjtq8dZE4+/0o8Wm3z43+nbdnZduazLHtdxv2tFIVqlXDIBjdbgAbe9BTp6SZi8T3jv13IeXK9MpAnqTfTZ2bsqn4pzgpZ+r5b0p9PnVw8hg8knuMnb2ErFF8kMuv5NfsgxOH0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FBEkoN0NDuNGCx2LGo5KZjjuMsa3sGuS7vCuUFczimA=;
 b=BEL0y8g9LHqG5DE4//r2ZVtPYZ+3UDB9dIZ9mgZq7rbiIPDn7vaPDEfq2AuTqPWBmgPhQAOKC8WNjaTs1NdDI3xf7B6aOyxBJB0VwNKIXw4K23Qo59OTWyazll/rKPJCv/vU2t5bf1NYaC0y/CeyLIgXDg3dewcatTd1SYj50PWx8R4fVbsPc1bzwQixTcdpNs+xxNRKsScqDj5jEsmr2UwMaogFAVq8HI2iLL2r0dm6EuYYIrZW9h72qluCf2D9GF6S8eUCTH/8afpKOYyOhxzz3tqo2ATE2WLhj9isr01L7gHK0H30Xq6oed7tlgTnTjY3zH9XiLtfHmFl8Cg8VA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FBEkoN0NDuNGCx2LGo5KZjjuMsa3sGuS7vCuUFczimA=;
 b=gLTFhFMV2O2/ov0IvgCN7EH0Rgy2sz7qouo0E+Nc91r/2oobdwJnZxeQiHQWU/EtQMCshghIM8gT2+TPZYKkbauHEFUufk5Y3VdzbAOaUa6dQD4JH91yg+nu16gRV+9adtWoD16tJ/v/V7t4aaNxw0SONEbAy5LRbVFlsGv0YeZUFeL92HiryYu8aTeM+BVi/LBhVpPUPpwDdkA8y25ckE+bHv4vpbNpxDMPWU9PKMK+4ZwPmVupvXv3+1/9rSjY0y2GI7Z1u/mibshtggHquhQ2yPckaFLxhPqSUkv0umyJ5kwGGl115GMECgKHi2XKu20M0um4Qap2kCmJzQo7lA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BN9PR12MB5034.namprd12.prod.outlook.com (2603:10b6:408:104::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36; Mon, 16 Oct
 2023 11:42:10 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6863.046; Mon, 16 Oct 2023
 11:42:10 +0000
Date:   Mon, 16 Oct 2023 08:42:10 -0300
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
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v3 19/19] iommu/intel: Access/Dirty bit support for SL
 domains
Message-ID: <20231016114210.GM3952@nvidia.com>
References: <20230923012511.10379-1-joao.m.martins@oracle.com>
 <20230923012511.10379-20-joao.m.martins@oracle.com>
 <c4816f4b-3fde-4adb-901f-4d568a4fd95a@linux.intel.com>
 <764f159d-a19c-4a1d-86a6-a2791ff21e10@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <764f159d-a19c-4a1d-86a6-a2791ff21e10@oracle.com>
X-ClientProxiedBy: MN2PR04CA0013.namprd04.prod.outlook.com
 (2603:10b6:208:d4::26) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BN9PR12MB5034:EE_
X-MS-Office365-Filtering-Correlation-Id: fd059655-33f6-48c0-5cda-08dbce3cef0c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cww5CaxNJg+2dgIc7yvlHcCVUJ+6Rm2ZfGQHNjDJt5OQSqA9pDkcvqKHkdEO4Y7z87gJHqKf8bAEt1soQbARoiiY8cSgh7FIAOFNtqJXQiDhD6IbBqLIERv+vTnMGcmw8r0LZAfaP99t/Fhh/yLxPqkDyqRmXMAB/DlnJJEXVGyOhllkjAIhRJqjPuk7NVs/6BzXRkV4IFsEAnvYZQ2WSXBVCswaY9ie/VDYGY+/ZT24FECJPNba6Hwwy8iDcv7CaXQmq3I8odUWNto/19lTV2kWM8tE8ebwooQ6zTS/LzeUHB1dpgzcGCSSL2dlFyTcU6RR22LpnO9HpeTHJ7/LB7FaIR7SGmqXcMbn6/toPMIA8dJhHJktoLFFfxEXrBLvmzVlVJHemezB1V+6M39sfdQRrE3zV4wN1+YiWmJZwgLP/b5CEO1vvU4aoPBgDCteMtUowTFnDyovRPiPMhIJnlmJWrS8dlrhCapp0VRElc51aYbiP18BNZ+XWnxYS2aviAehnUex468gNNZ2HTn4F7/05LZ8qbqX6kbK7jyra9oT4PMd127jvmmoz8lOJzgApS4lwhLvaGlz6YCV6LvXU/A776ZyWo3+43oLjzs4eLk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(396003)(346002)(136003)(366004)(39860400002)(230922051799003)(1800799009)(186009)(451199024)(64100799003)(1076003)(26005)(2616005)(4744005)(7416002)(6512007)(66946007)(54906003)(66556008)(66476007)(8676002)(4326008)(316002)(8936002)(6916009)(41300700001)(6506007)(5660300002)(6486002)(478600001)(2906002)(38100700002)(36756003)(33656002)(86362001)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Xwv6IROpe8cUY7kWBIp/924lIHQWDMWEajSTRTO2j3/hGDvrr56D8fCBnaz2?=
 =?us-ascii?Q?PTlUy9aaqKJV2zl7ARg/LahP171VvYdBRDoDXx5I1CbnIF6ZQicXixNG4tpp?=
 =?us-ascii?Q?y+1lkkeoffvXT9xNG8qFFijYA37Y9zwLsIqr1nf2+SXowop+vXNVk+lwGFJb?=
 =?us-ascii?Q?Pj7vWXZL4oB5Cng9Sn1NYApTAaEXv1I/QXl43uCfSaCY7X3VVeNBlA//dqwN?=
 =?us-ascii?Q?45t7/ATXYkoB+a3XOI6L7+o+DIYHmdvqrlZc9pzl4+6ZLwm7QGq8WwNBx6N8?=
 =?us-ascii?Q?hHLG/uwadQ03HQ4dzSWHV/Tsm/FEGEIV1gPuw22ZZg9dCvl0dmCW4v8IB1Ke?=
 =?us-ascii?Q?Dz/6IF1EgJgMIyLK5Fif1Hv/2QM9P9cFbfPqFUx7Gc3EpF3h2+rJ30EaEFTF?=
 =?us-ascii?Q?6Kv+S05yT/xa1pZHBYAX6rsShHZEZf7O9Adm1QM2m7ciCIXR37/snPp1yOyg?=
 =?us-ascii?Q?XzkPrFO5cuOGEwcN61DRhGANqHltsGH/MruPUL0Kw0Cn4Se5FhZfPxrr7IZo?=
 =?us-ascii?Q?+VNBs0GgFnm9THSSTOT0izaB+TTm0YwcLIPK9HX/u4SXkfQytkkgclR+Oyfh?=
 =?us-ascii?Q?iJ7QW/2p9sjYS/laQKGsk4CO1RGPNctJgwNuYeL8LkmIfe9VBbk2QUpQPbtP?=
 =?us-ascii?Q?sL7s2soIfxVSzU/eGqXVqbdLsyLdAiv0vQE6L1f4XdOnnNg9x2O2b2hmT2Bg?=
 =?us-ascii?Q?vxnhdZYoXwBo2vsqJmFLZIML+a4RXUKV8gZq5EK7WdYnk5FfHTnOy4aQhqnQ?=
 =?us-ascii?Q?gnVxdFFWg5u5LlracpOsWupcz4kM/rB1qPYcWm5C1AXmOomTclLDwb4M3yob?=
 =?us-ascii?Q?1p8m87OVkLPOGLBED5cffGajAwr1lW+XZrG8UG9sGXyeIJkMcoZCjUxJ+DFc?=
 =?us-ascii?Q?42sFyt3EqpqfV0g3DM2t87kCBqCm4VaAl/fXcJ5wZrHrI45qzZ757EI0YmWo?=
 =?us-ascii?Q?Fz4TS5gu6k2PYZ8hs/aoPWOrM85Vm19haaNuy4OXwQBIrUpVl/k+7ns2y81x?=
 =?us-ascii?Q?K5WUZRz5Kh2esTmUEea4rvLaRVVY0eJccRgu82OqYYrvZqtScKqrVX+yNvW1?=
 =?us-ascii?Q?zVC3sSQtOXq5Dhnhvm3SuJITOGMLnFt9iWqTlgEo0w7Rz7XRfvm66OnlQCBh?=
 =?us-ascii?Q?hYXgYz4zHnJK3rrxw+z+GjExxYy3o9xR69SLXI1sOy8wiwuEOHgUGEG+HzZK?=
 =?us-ascii?Q?d8GXtvx2srMyv+63+qK5w+neB6/E4BdNx5mOtlGkFxW9d1wIYxupKgSJxDYg?=
 =?us-ascii?Q?YZVE4XoUJ3KUsaDtMVKas8dmgDs4fGX8GQ4ZcdPIKmAz+yQDOfhALhCYBP59?=
 =?us-ascii?Q?gcKMGIPRdEmMNVOcF5v5aIs4yHFHa3tMx5i5/JabjBO1lW3MOSs+Kbta5Gtd?=
 =?us-ascii?Q?BeYkee/Wqmwaymjtv6PniTdpQfruh24TfCn8+5e2qQZPRdaPQo4p9TiB3Rwu?=
 =?us-ascii?Q?ZCvbV4dFnON0u7FkSbRjLPfB2z7IcwGJ94kzzBWEmnRq/g7XVWRn1yGf5mqt?=
 =?us-ascii?Q?z8ajRYub+jLeovuTS+OgAarFaS3QRN1ByJT4jeMzBgXh1n6SHWawG4OOqAnH?=
 =?us-ascii?Q?MkYJGHIY6wd33++jh7M=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd059655-33f6-48c0-5cda-08dbce3cef0c
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2023 11:42:10.8057
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wkZScaNO3Azx4+Ug2UYzUp2N68EpvRnIIP8j3rAIR0EeT1usTjIkHXdcuxw14fP3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5034
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 16, 2023 at 11:57:34AM +0100, Joao Martins wrote:

> True. But to be honest, I thought we weren't quite there yet in PASID support
> from IOMMUFD perspective; hence why I didn't aim at it. Or do I have the wrong
> impression? From the code below, it clearly looks the driver does.

I think we should plan that this series will go before the PASID
series

Jason
