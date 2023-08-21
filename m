Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C05187824E4
	for <lists+kvm@lfdr.de>; Mon, 21 Aug 2023 09:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233853AbjHUHwW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Aug 2023 03:52:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232007AbjHUHwV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Aug 2023 03:52:21 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB0C892;
        Mon, 21 Aug 2023 00:52:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692604339; x=1724140339;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=ydyJXV2uiDREnTwI3gj3vAttsFuIxCQTv8UWfNNGtmY=;
  b=mnDC89d+FNDOx4J+93/KwMU2ArLEEGlFTpVjxl0aRTg/CUAoYWmtea37
   k+Ctsdq5Plc+IJ0hpAuqwTYlVBVkfxDDWyY29KF2iEuAr2ggxp6jCdxB7
   SEj5+G/ZKa0zvYnCEaPX8GhBeAtbxliI3xQgqas7rvOuf+XaSOxpeqA0P
   xSvZYIqED1OGbKQ+y/EpyTjx2lMVRKPKm6D8srn3Hpryov4VjjoK04awE
   725AZ6TsGzb/OfjtNoBP9hJwum2b4Kd3G54j6RgP0Ly3LXxpKaE4FXYY8
   fSnHDfWVpPxYpZKljX0AIeH/wM+hDbYCzEdhU0u1/rTrMQx9nWMSPjPux
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10808"; a="370958442"
X-IronPort-AV: E=Sophos;i="6.01,189,1684825200"; 
   d="scan'208";a="370958442"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2023 00:52:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10808"; a="770854584"
X-IronPort-AV: E=Sophos;i="6.01,189,1684825200"; 
   d="scan'208";a="770854584"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga001.jf.intel.com with ESMTP; 21 Aug 2023 00:52:18 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 21 Aug 2023 00:52:18 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Mon, 21 Aug 2023 00:52:18 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.102)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Mon, 21 Aug 2023 00:52:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZB2Xim7ls9fSbNYRbaX9q5LCFDWSE7R3pPqvc+flXJEIwGZ1ZjWKUNPal+WJHcI6pQZVLyz2nczaN1lAhIa7xAxWFZU3pf1fO3Z9B+ml0MmrXiXJN4LwD6g/jga2S8sMJMABp1BmMLpZpC242SrtVqw4WPStuaW4jtTFMbYPq5IiVWzcqGLtnprzXVJh24U9CEUdA/DkxMmLQ0Kjes/qizIeZvWMObKbVXlTA1oxnq7xpGDuXWZRRIdi+PwCPDubkyl+WThiqpBBBqUBU60+9Qf7Ea0uUHZqn28BCUnqzma3aAiVLvflANxnJPS3E4CvespTsvftDisH1TVsd7D8yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ydyJXV2uiDREnTwI3gj3vAttsFuIxCQTv8UWfNNGtmY=;
 b=Xtej7fE9EwTwFuglEKeUgfUx7cKzRRbRRPmd/jR3iBJiZH1nfhQWQ3w96yP1w/v4+hMTAy8BQxxdNjiRNGXwGIzfaUm5r53lzwd3atNDS+YzszLyeY7V//xs6vOpj+Cq343U6xf7bQ7T4RPtg6khFEj83SYENnkTpYuxFfw5P+tNaLG1380h8J0D1CvVUFBrPWc2tC4xhUKnHBZ1j2i+Jl3eCFa4K0pNiOgPy/AYN1PDx3rclWkMicIUI5hw36UppxkJ83buTJ8BotdFd4BLe+3rlRo5grwrrgiDzXJp9zIHj5xNKG26EVR9VuvvProncqebhhe5H1Fifehv21Z98g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by CO6PR11MB5619.namprd11.prod.outlook.com (2603:10b6:5:358::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6699.24; Mon, 21 Aug
 2023 07:52:10 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::146e:30d4:7f1e:7f4b]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::146e:30d4:7f1e:7f4b%3]) with mapi id 15.20.6699.020; Mon, 21 Aug 2023
 07:52:10 +0000
Date:   Mon, 21 Aug 2023 15:52:01 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Hao Xiang <hao.xiang@linux.alibaba.com>
CC:     <kvm@vger.kernel.org>, <shannon.zhao@linux.alibaba.com>,
        <pbonzini@redhat.com>, <seanjc@google.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kvm: x86: emulate MSR_PLATFORM_INFO msr bits
Message-ID: <ZOMWM+YmScUG3U5W@chao-email>
References: <1692588392-58155-1-git-send-email-hao.xiang@linux.alibaba.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1692588392-58155-1-git-send-email-hao.xiang@linux.alibaba.com>
X-ClientProxiedBy: SI2PR02CA0007.apcprd02.prod.outlook.com
 (2603:1096:4:194::23) To PH8PR11MB6780.namprd11.prod.outlook.com
 (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|CO6PR11MB5619:EE_
X-MS-Office365-Filtering-Correlation-Id: 7acd4c6a-5819-4fd9-b277-08dba21b864a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LHn8x2Xsf4lwKQumPgoJVtGmzL3NjfixaHHxMSFYd7bcEmc/QWY8bIfmXXLxUG8y5sXiasaa6A+o7r25iYXqxUinRtBPrbSJA+1N28GFHqwMbFU2XpfNO3pTcue5H7G1yPiYeOfkb0mlZcQQSvC6SX0nwm7/QgpRL58VlHZG/dMmAU82gz2Cuh4neRHRRtglUTp2BClA1SBndVdll5gEcydwWP1H53faMTKrhSujT1yTmqK8IPKKqNwk6O4SU43Q2Cu4peb3eX7KVTZxZNTmDcTFbl5Nq2BGE5jV/FLnbn9GoQAf8gPX595xlYL5iqieevbE+PQ+BQiBG9jAoPK6NjxuUcfCFRshVNZbUF01Ah5s/sl+fVx7IArD/m8tFJYotpucupIL8ba+1vJFF+w3vdcVnLKR6GIC13RKF/0utL3s1E+lZ1CniPkucf6RcyDOlR6KlM9eXnCIkI+917y0DqJDmjxP4S0vhOi3pWtyFpZBIOOwX7jXU5VxUrP4WOb8AMUHkPXGu2mUnWa6Ev6EGdHot9v9VOAp63Y4kHX/meDHrG7CtfjfK2btKy54CfDpseOJ2lqzlIOSjay4bAaOeZ8cpulD5hWMfKNNvwn88Zs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(136003)(396003)(39860400002)(376002)(366004)(346002)(186009)(1800799009)(451199024)(6916009)(66476007)(66556008)(66946007)(6512007)(316002)(9686003)(82960400001)(8676002)(8936002)(4326008)(33716001)(41300700001)(478600001)(6666004)(38100700002)(6506007)(6486002)(4744005)(2906002)(86362001)(44832011)(5660300002)(26005)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?M6ylWkTBNaMqrjLdSr7LjZ8dMGmvyu9pefFgt08OGEpEmCDNpZEVZzqrw+St?=
 =?us-ascii?Q?9jB0qeFzUs5/UiyRCHwF3lyXSMGkFcbTLpbpm5W4O+XaRIboyYj2RaFtO12O?=
 =?us-ascii?Q?eDERMRiTPuQSzIOC4Lug/GjfGkvq1d9wW+Wm6B1mnyH9SyBzJOHlQgyZ2W1J?=
 =?us-ascii?Q?Wats94J1CUfvm6rU6s5kVwP5TxySZJdvy2l+5mhXc54hLcBwF+xiAQIwLdJF?=
 =?us-ascii?Q?9mLGgj+11G3kiq8lDogn+cIGzTAQQlj4zHF89v1HybuQWLV5w8f5DHytBOpo?=
 =?us-ascii?Q?XNBvgjb8XAVYJl1h0P6kSRZn93xNvvv2T6QtH8rRj6ujl2xg8reYkoOOVcD2?=
 =?us-ascii?Q?Q2ea1IHGW2jIQyHr+tYKkdxvKxwwPGINmOKOCZxoqjZgdYzz6vM3QLVdgIiT?=
 =?us-ascii?Q?XXrrrBcg3oVUUWMM8DmgHn1G/QDC7qvcb+YNABbl68vJ9WcX0C4vCo/EgW0J?=
 =?us-ascii?Q?TbXMwJedmV5bXaFJTsM+iUnQHttDFEFnI1Zxo/4AHG+/C0/TMD17kGXGgIB+?=
 =?us-ascii?Q?p14Vjc9DeKDX+QTXUZV6vmMNGJYXMC8UzzhZOzxte0WZG4DC45oXjX+HycUj?=
 =?us-ascii?Q?klvhmpxNnbsJWISznc4dDVnNAW8jSwUhoPEQaa2So8PgKpBw6B3Ps1WdyugB?=
 =?us-ascii?Q?zsmLSNHipd55hr46oKubeehaQHgiuUiBKWkaZrMdB4w0/9A7yGpQ6Nsz6l/7?=
 =?us-ascii?Q?aP+Tlc+jBZDx6GT4zNJM4d90ZS6M1bkPBTTi2Bzcg8l39BLNqsd9Q64njxLd?=
 =?us-ascii?Q?T08PNpQkjHMIWP3vAbAObAIKinigalbDSMPpeoaBYOaUmZf42UNRYGlOhaZE?=
 =?us-ascii?Q?fQiH0XZ6Z8P0t82/qJdvIWU7Uw8SzZWY9z4KGuWmwHQ02G+lwshG3PmQdw4T?=
 =?us-ascii?Q?vPZgXrwUbRYHvutgulu60kvfhwL6whoHAtTl9a0W7q1VxZTq4moj60wdCyXG?=
 =?us-ascii?Q?ge95orxrryXzWLplGEHE0vYFWiOTSczU4lc2tmVZ0GoylXDg7uQhDJr92BoT?=
 =?us-ascii?Q?D049ctr1daN46+PrYJu1n+9Duh4F9dr41J7FZfyOjXgyjc132H+z9ScYZBVV?=
 =?us-ascii?Q?q+AqOQYr6w+yXFWNxHq7PFtmizDJeCgyfVBctJZ9zkRsbhYTblzwUWv/WUfj?=
 =?us-ascii?Q?ThBRMAHsOKa1G5qUcq3K0AP8CH+AFS28ijFtb7xmYHcb6lEEGtWp4oVzKfve?=
 =?us-ascii?Q?J3ygqa1VnUaBjJiNx9O0dHzFemG1lABQm72luLKsvDZHsbV7UH4LdOnPbGiV?=
 =?us-ascii?Q?h8UHhbvjR31z85GLhEAXb5sWZCwvPSumzyjKJkIpyYdnltCe95TFtIg8sKya?=
 =?us-ascii?Q?IFQrVS5843UkLNfwLRQ9/8Mhf3foSyTWrwPAL6zp13LbFPUv4ZjIHAeYKheO?=
 =?us-ascii?Q?8AkWYWuey4d2w0lZlS3IAF7vt8jeI1Rf0bq1zAQpDZ9qvm5KQ0gCPiT8V92f?=
 =?us-ascii?Q?ZuWgc8VP+Tc/65dUJHFlasaartBru3H7bL/Tz5VeePIjjO3gZToqR34NGliX?=
 =?us-ascii?Q?22dYvqvLp/u4A3iw6GR/yA18ZaD2YHF/s3RQD8pbg0YIStQy6KT9qQygKnWS?=
 =?us-ascii?Q?HQDDajXutJOXZF1MneOAJMkaYaIfGB0juDiEfq0t?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7acd4c6a-5819-4fd9-b277-08dba21b864a
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2023 07:52:10.4831
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EQapLjXA2KKWskipkziyJo6Gwc0oZYqBaJEsl87MMNvktHKr2kRowldHJISiZVyDKeICm7Pk1ZKo/JDjBDHOwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR11MB5619
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 21, 2023 at 11:26:32AM +0800, Hao Xiang wrote:
>For intel platform, The BzyMhz field of Turbostat shows zero
>due to the missing of part msr bits of MSR_PLATFORM_INFO.
>
>Acquire necessary msr bits, and expose following msr info to guest,
>to make sure guest can get correct turbo frequency info.

Userspace VMM (e.g., QEMU) can configure this MSR for guests. Please refer to
tools/testing/selftests/kvm/x86_64/platform_info_test.c.

The question is why KVM needs this patch given KVM already provides interfaces
for QEMU to configure the MSR.
