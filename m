Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B98C97249F7
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 19:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238578AbjFFRQv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 13:16:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238366AbjFFRQt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 13:16:49 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2066.outbound.protection.outlook.com [40.107.102.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A0A518E;
        Tue,  6 Jun 2023 10:16:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aOxrfD5F4Bj5HfWhOhfb6bdPdfAU1Fs0RqyumX4lflQb2qGd+pRme7Yo2FcLQmFzMeKChYHDf/MZTPWHDHFTzP4L4yIcqeqMWuzqaRFJIvs3NzaVl6FCHynKeSH0yFGbp0fKbk4VLAnXfsRXKw5yqEbYb4YSD57tEmdx8/hz+HDaD+mTRIKoWc21W4k3XDJE+AWQxYc42WXyEiEK7bQYDS/a+Trn/I2icy3O/OzcWGqDIa5UjgTfcEjKgZC7CCI8TBuKXE3RJtilDSELaAu0ptODY4aINcDH9ElUcChz3o7dl0eEdE4FBgYv4LlBk/bM9ai7SS9cOzYrWZ+crw0D5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dx82KZLcT/tjdpR75f169l6rVXphPQxUcdJfn/F/qm8=;
 b=mhukIVCE0kMduqtZ69XszouTBqaE8VyxZxdUQe0i5wIfgIhGLTa/aHd2nu2sh9Oc0XlethFlOqUDYr2EQgQj8FKEoNmklveE7HASWvUVN2tfsE3uXfVYUl8VvpF6rL2s/umoJ3BN+xdtUz8TrQotslMSCcIUwf4RfnggDpdjFKmvYAYynbPDtPkewSv1Z9z0QUZM1LicQTbWKs9lTXkwh6MplE7+0LTjPutxBJUuT2PDohx3g0Ub9cJdg7cSnJVIjE5BKuDMx5MqOA1oAV1zgTE1yIZdkuBxdcDfjVkQOf/b9gyUL6YVXPOyX/XYmvfDwlSb4JcSZIxu9J+niYzmLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dx82KZLcT/tjdpR75f169l6rVXphPQxUcdJfn/F/qm8=;
 b=fLMcL89lRn0NJ5a9chJOqiB3IPoyQ3Zx9TwxSKjibJca8ZlnBO2FbTI/KwvVEANazQOzpz+FPN56JzjwYowsFZT9DEYYrTaLYKEUWFqwoJ88Q1domJ1WtV6vUhBdqW70F4c+iGG1FwUzMJTiHHRg68YZiseKOvdmyF/xcFHQ8T5Ii7650wLkZQlSwzT+p/cpvpaBdtzgJeiwLmTXHTDUm4SviNvVblJyxyJoBfqtjhA0JrBh/EzozX9vMfTDgsohM6Tc2/bXLVXRIcVb/SG5snaP3yibx8g6E1BpkbcS31DnXeDXfzEQU2hoQgxNWlo2cuBxqiGTynXmJ3zd0Ggngw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SJ0PR12MB5487.namprd12.prod.outlook.com (2603:10b6:a03:301::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Tue, 6 Jun
 2023 17:16:46 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6455.028; Tue, 6 Jun 2023
 17:16:46 +0000
Date:   Tue, 6 Jun 2023 14:16:42 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     ankita@nvidia.com, aniketa@nvidia.com, cjia@nvidia.com,
        kwankhede@nvidia.com, targupta@nvidia.com, vsethi@nvidia.com,
        acurrid@nvidia.com, apopple@nvidia.com, jhubbard@nvidia.com,
        danw@nvidia.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/1] vfio/nvgpu: Add vfio pci variant module for grace
 hopper
Message-ID: <ZH9p+giEs6bCYfw8@nvidia.com>
References: <20230606025320.22647-1-ankita@nvidia.com>
 <20230606083238.48ea50e9.alex.williamson@redhat.com>
 <ZH9RfXhbuED2IUgJ@nvidia.com>
 <20230606110510.0f87952c.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230606110510.0f87952c.alex.williamson@redhat.com>
X-ClientProxiedBy: SJ0PR03CA0268.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::33) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SJ0PR12MB5487:EE_
X-MS-Office365-Filtering-Correlation-Id: 50763ff7-91c4-4691-c49f-08db66b1ce36
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xMbtzJAGi0QG3uKGS3z/PozlukYD8uEqkyTdGpMwFRltKHUsWLobjXLdtvs44ByqObRoenvI82t0290rsLRO6rgf+s05DYOp9F0I8XBrtEO9UpmsFtvPMkSrBB37e0KSDns51HmSNbZwMVxsWV99esqsg2hiV+rejqsmHMV+0mjQ7PuDTG+51F6irbuQeZ+ri6Yk2YKhXz0uHugUj2QO8ZSM5AxEDaK+hL7sabFNJ9AyADawLOfC48yLfzvo1GTd3hJpoAlC54pNKPoI9GjId4KaV4lhI0VJ9lPV2Lvz3crnQTKo2HLjh1rDIjRQG4VsauI52PhLzJCzR6A48jpEtXopawXSf3ZzP2dl1Bf+bAVftmgMO/a4ApRoq7XE6M497QLzxWpovh9Y8njjFOv6O1b6qy6Z42N4TdlM+v8eSn9wVo6LEO4L0Vk9viwq0aLyK0NBFC4re7gqyqkI2Y+TpiSvDJ6SKwhUNxZkVw4zG2ealx7kx9G9fEt2TLHTRSDhTMXSvB9LTO7/vrAxs2VD1FbVsBfpvUSbpyCD6WlXVOTM677EvEyj2tpHOfGZhJqpokzbIra9P+/KRqcVf0nJzGlcsof8tjlV7h1d+RTCLWrCf5b71JUPtO6FIas+BFu7NWhljJSpBnf5Wrts2RK2rQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(376002)(39860400002)(346002)(366004)(451199021)(8676002)(316002)(2906002)(5660300002)(8936002)(66556008)(4326008)(6916009)(66946007)(66476007)(41300700001)(6486002)(966005)(6666004)(6512007)(6506007)(26005)(36756003)(186003)(2616005)(478600001)(38100700002)(86362001)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iJu6teF7LSK1u/m8HKIwYET7hNba3kJdyhgQ6UAiFsBNLVUgFYcnRpNb8kXW?=
 =?us-ascii?Q?7PdfokJG7A9jDeDe2fvHkQoAxPS7haXSJWFjVNvE8xBdrM/AEHnvAFeWHRT6?=
 =?us-ascii?Q?A9o7yNSnjkzjd77I5qQaZ+sDX/HOlZGgcEWptndinfTkDyBGtkPtw8FTyxmU?=
 =?us-ascii?Q?s3vTse29hYmQ4h+rCUNcdNrSkz9+zo62ZwgjAhGgoD1uF5ypWH1A1bFcyWU1?=
 =?us-ascii?Q?NTCkVxvuuZxvYlm5LICzYMJKDYA4wPn4MPCB1xTurj2vkc0lU5HxjVEwnqff?=
 =?us-ascii?Q?yrZunPS1LMbajA7KZd6TZALZ3rCRp6l2F0vbuWrNwHpYeJtwYanILqwHsKvu?=
 =?us-ascii?Q?RqrHrO5hxVJm8iine+micNzBT8pg3ih+QDczwJfVgSFnLCfX7gJiHwD/b168?=
 =?us-ascii?Q?Dzl0XnnqL02K4bn83Hriy/UnjKrnzWghai618/MvirQiru2T3S5a80LsHqYJ?=
 =?us-ascii?Q?w1RVLqooear65abgiyMBHRZKvHAhwINy8JO6yqTP2l6U92XJ3Jn7C87uNdsi?=
 =?us-ascii?Q?XCsERQk1AuzhBw7eVZPHjxMrw9+CyGCCJvHH0eI9KP5wORv/aDjFAHRtyHs9?=
 =?us-ascii?Q?Hk+FdnmTBehRq9SKxCoSq1HH6TMB9/xsQV1gnyna4FAx4OU8wzsQvbG16BsT?=
 =?us-ascii?Q?TGHaU/kX8lC6STvtxYy5mxG258UcDbykhTSXQfzmmSbXcUBfrWWG9ylniWG9?=
 =?us-ascii?Q?w0yHJ6FMUipYI/u+TG03/GwDPgwrs6JTusA4nx37pt2hw3FQanRHhv3rvH7L?=
 =?us-ascii?Q?vumKwPA0b1/klbTQqFVIM3NsTRBjeoBsdSqBnFLn4yFWT3JqwCA3JQIhvP59?=
 =?us-ascii?Q?XOnPHxsgoxpGU3p0jn2VjaSXToxnW0Eer1cb4aYmFmVMF76B3qlQ2lNAftpk?=
 =?us-ascii?Q?dcFZfjC9hAPqN3tcei5GaRouTabPDRkzytV7HeCHtEKTz51s7AEa62ZaZelT?=
 =?us-ascii?Q?7SoVfl/Y+T2UEozljT2k7RgcCaO+TzAaopbyqZecoyIOmZ/3WLchRY5ACQid?=
 =?us-ascii?Q?uwh76QXrLEyfy5D1nFlH9XWr8+1dQ6kHNxsfQNIAzF8YFWrggnljxQSqdWWF?=
 =?us-ascii?Q?V5Iul8jalMnGMMSxwqxvZq38Lbau6O/iJnpOy/jqRNkxMRYwUYqg9ZLry4ru?=
 =?us-ascii?Q?oANfqbZZOVGYjnQrwZTeDphdJm3M+okrZB9SgKGGlbC3xJP19HrrkD5/83v/?=
 =?us-ascii?Q?2Puafv7ltnF1wUpMr1MkaskIhU+94qmmakvAk+TrOuyWi6uxdjqblg2IRIEa?=
 =?us-ascii?Q?B3Z9mNjqZLfCwks4B9zAA0TDCZcXlImpsq7v+XgM/mvN/b+SF/usIeR9j2Cx?=
 =?us-ascii?Q?w8DgsaHSv+3cEN1vJyNCSQItkA1MsZbowIIdj6dVBYPTXAzJY4gXB27VE/c/?=
 =?us-ascii?Q?6FYgVgBIPprw/vmqKRvMxVqqvl8I7BzHaDHfdyZ+WMPidBUgz6U3QDjhFx4G?=
 =?us-ascii?Q?s2JKsGXEABL+lCdUx8UoOr1Y3XdvqHhag4Kou4PBvrtDvTJN3/34KesOegZF?=
 =?us-ascii?Q?Q87qMRm31W8DZVjIw0md9f8I6djTLE06/V7DEJySZ1+vHw598SK7imERRm7L?=
 =?us-ascii?Q?oJLWuIoCDz6TYPWke/PlTBbgc2H+BJ4uI6a5rSRf?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50763ff7-91c4-4691-c49f-08db66b1ce36
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 17:16:46.0436
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sCCVvMhrRBL4X4V2XViufDOWXHuGf6vpJTWpy+ysdqggSlHpbm+v66kU/EnbpVSb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5487
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 06, 2023 at 11:05:10AM -0600, Alex Williamson wrote:

> It actually seems more complicated this way.  We're masquerading this
> region as a BAR, but then QEMU needs to know based on device IDs that
> it's really not a BAR, it has special size properties, mapping
> attributes, error handling, etc.  

This seems like something has gone wrong then. ie the SIGUBS error
handling stuff should be totally generic in the qemu side. Mapping
attributes are set by the kernel, qemu shouldn't know, doesn't need to
know.

The size issue is going to a be a problem in future anyhow, I expect
some new standards coming to support non-power-two sizes and they will
want to map to PCI devices in VMs still.

It seems OK to me if qemu can do this generically for any "BAR"
region, at least creating an entire "nvidia only" code path just for
non power 2 BAR sizing seems like a bad ABI choice.

> I'm not privy to a v1, the earliest I see is this (v3):
> 
> https://lore.kernel.org/all/20230405180134.16932-1-ankita@nvidia.com/
> 
> That outlines that we have a proprietary interconnect exposing cache
> coherent memory which requires use of special mapping attributes vs a
> standard PCI BAR and participates in ECC.  All of which seems like it
> would be easier to setup in QEMU if the vfio-pci representation of the
> device didn't masquerade this regions as a standard BAR.  In fact it
> also reminds me of NVlink2 coherent RAM on POWER machines that was
> similarly handled as device specific regions.  

It wasn't so good on POWER and if some of that stuff has been done
more generally we would have been further ahead here..

Jason
