Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C04CB650CE3
	for <lists+kvm@lfdr.de>; Mon, 19 Dec 2022 14:56:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232086AbiLSN4K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Dec 2022 08:56:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231975AbiLSN4H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Dec 2022 08:56:07 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DF21FD3;
        Mon, 19 Dec 2022 05:56:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671458165; x=1702994165;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=I4GE27e2UJJF4frWofmNYo3j5r9yQ5yejvDPShQnCUs=;
  b=i6RHw9WiwxpX2TOzsQECNNUZWcl1nTX6q8X8R09gup4dl6FgD3qONH9/
   XploSynFXCphZo5tQFcHuVNqBDJhbY1XvkzKHmu3sCLbncz7sXLvgTEvL
   NmGsS4jZpHsaZ4kgxKBO1k2dUT53ka2O3jUvHIUyQztBiz3B/+wb4wYN1
   gXteJDkwTF+ZOCN6fC83r0VYvGv6D0qfTOJudwiTfMMnc4n9wsPOBibRa
   YQ/VIZjiCgZDdaUBCMJENFf7wYJetnzk72Ac9GqW/I2331XEe47YC+xVq
   X7FQ2zmmEdujJNCIij8lRFUU81gou3n0lBsAL1UeGUVhMRrT90KAK+GFX
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10566"; a="320522913"
X-IronPort-AV: E=Sophos;i="5.96,255,1665471600"; 
   d="scan'208";a="320522913"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2022 05:56:04 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10566"; a="824855077"
X-IronPort-AV: E=Sophos;i="5.96,255,1665471600"; 
   d="scan'208";a="824855077"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga005.jf.intel.com with ESMTP; 19 Dec 2022 05:56:04 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 19 Dec 2022 05:56:03 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 19 Dec 2022 05:56:03 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 19 Dec 2022 05:56:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iIAAx8/lPazWaj3fdHPrarfcihKCnzUm3iJ0Rdy9yM/bEL1KMSVI6gK+J4DFQwRtYDVwHj2dbO8lKMhmLYaPfCISM5IESZvjronD+NfTdNX1MEg2yBywxdX6he3Xm+G8MQO8tOOoodKk5ZAgUFs+SKcv6IX1JHaama9yz3Y/ZYrnwyBT5g9n9xCoWb/eRVlDyZrMz9IZqD5262GS2VI7vQzlJkOfp5aCUmCgpiaEIiPIS6A97EbE8UaIaArxUZXu19UwYva8bg38gDPqcpTn57qAOv75kZVG7IZEQF/rdfku29bb2hjEYsDUW0KenXmY2RFrNTGoXXHiF9TzfvueVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=esaW/HApWpK5FmnJ96/X0wtVi7/83HI0/BnkyYRVZDs=;
 b=B1od+OzkX9hgPFEr8LWq2sznCQsTxzKKo2BZCHGIWA5fniqUwyyRCdjl7uO80Mjz6V868Kra7FKnHXWK6aX/KFLrK2stTvSqsW+/kmJNq+0DiVZM3XQuY1mb6LfwHc2e91jSJvhtbSs9v/UNU5c856muNs/itr0Yk/SS5Aze29Tt/Ox15Woj2XqIrJLNlS3LpRZY9vtXCAqsEpbX3qSPUq6GCIj+j2MreMpBLQAGZ30fX+wjlQGf7MownKrxmDGUI0bWlCFF32dp8tDZ7AVuDGEiAQ7f3CWIXjxAoP+4n9bwn40zKe0NIEdH8+p3YzzZ1PEN18H1Bifd6GD3jjxMbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MWHPR1101MB2221.namprd11.prod.outlook.com
 (2603:10b6:301:53::18) by CO1PR11MB4947.namprd11.prod.outlook.com
 (2603:10b6:303:99::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Mon, 19 Dec
 2022 13:55:59 +0000
Received: from MWHPR1101MB2221.namprd11.prod.outlook.com
 ([fe80::5cf5:bbad:8442:f2b4]) by MWHPR1101MB2221.namprd11.prod.outlook.com
 ([fe80::5cf5:bbad:8442:f2b4%2]) with mapi id 15.20.5924.016; Mon, 19 Dec 2022
 13:55:58 +0000
Date:   Mon, 19 Dec 2022 21:56:02 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Sean Christopherson <seanjc@google.com>
CC:     Zhang Chen <chen.zhang@intel.com>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: [RFC PATCH 5/9] x86/bugs: Use Virtual MSRs to request hardware
 mitigations
Message-ID: <Y6BtcutjgcgE8dsv@gao-cwp>
References: <20221210160046.2608762-1-chen.zhang@intel.com>
 <20221210160046.2608762-6-chen.zhang@intel.com>
 <Y5oviY0471JytWPo@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Y5oviY0471JytWPo@google.com>
X-ClientProxiedBy: SG2P153CA0039.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::8)
 To MWHPR1101MB2221.namprd11.prod.outlook.com (2603:10b6:301:53::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1101MB2221:EE_|CO1PR11MB4947:EE_
X-MS-Office365-Filtering-Correlation-Id: 36412217-c2d1-42a0-4c25-08dae1c8c19a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qPQzCmt1bmPcUtkXOBWZ3oJSo91HC5uaW3y6Au7ZA7KJKnKtjOwpzjHzZ9FDXO92vBtBuEItUmrl+vH7LdWgQwAO7C6cwNdY6n+9H0xVcoqrsqkBEjk3Y7xvNoDtNU8T1+G5YWasxMK5NuwJB+wsOXlEFT7k+KwGLl+uNwU5oRXY/AcR2LYp4YFGdYrTkOHj6GjCP9+Zt11mVWellq0t0azwaHmo62q2+HVi+N6yZ7he15Mcrd2IMu8OcvahgVk3KZ1YK6mnmJ/Ckf0N//n12nc6X7dtU3s1jGzDNUHwLELftVgxkyBfTjU0CKWvgENSeTdF1hvR8tMSo0IFowUY3qevAZQUby1RGkGqJu4F9hoRIAT/oHhcFvVSxEZ0y5NkMGVN6Luc5YYP/iBkJLTqoR81uTdGEu76Bmqbneixzs7KYpz/nAR1qhDHeflkMTtNd7KfkW2WH/0GctDS/4CudLBqrD98SsPMO8QYE9PQ8BQruGNnfu5CjiWiL6HMO+YKE9wv2oaZGgydsED7iqbHbxUDJBcdv12/QSVoMvTFlgw49HnzBmV8cGHrA889viQmiOk1xW9W6R13euOJevZUczQa5vrEyn+G9VJIs3p0SpVKmunxcRt9EvVug9IbCA5DjTsl8J+wJ0K0jVkrGoEX5Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1101MB2221.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(396003)(39860400002)(136003)(376002)(366004)(346002)(451199015)(478600001)(2906002)(6506007)(6486002)(186003)(26005)(9686003)(6512007)(54906003)(316002)(6916009)(86362001)(6666004)(44832011)(82960400001)(41300700001)(38100700002)(66556008)(7416002)(66946007)(66476007)(8676002)(4326008)(5660300002)(83380400001)(8936002)(33716001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BsSehQNbS5KNWwohx7KZLUtqYbW0YlkQSQUjDtdyn8AHRii1pHrqQL/UXadH?=
 =?us-ascii?Q?oYDcumKpqmkt62FarLGvSZm75oplOJlxXN6PtFOmcZp3tD5INHNEwhuDHY85?=
 =?us-ascii?Q?exZyz8ow1M7r/ItqHm3rXaJVIStuvM1WQQathlyfrUdFhxCsfwrsGJrHULP3?=
 =?us-ascii?Q?gf/+DnCR3guDHHt2MjKepNZ8MSKNQP9YVg70hNyTouXkZqAb+H2b1bfkIdTS?=
 =?us-ascii?Q?supSqrjKMTCcbB/eAZxFhH7TXxesWyEYIxiFYkriNuCXocV3d1+ubd3xzIIr?=
 =?us-ascii?Q?ETNK+cppP5QxBUH7KdxDM1cB7d21htzCghZYnXp2E9L61vdsIJf5RhJLFyYm?=
 =?us-ascii?Q?oBo0PtQBKDgCGv0QA9hAh8vLCPXEcE/0J7ovqSJ1htmdJuS2KGeGyr2ZNzqC?=
 =?us-ascii?Q?1mjapFr3gUj2Vw7NCrmJJUGYvGBeu9ceaivvEyTxvIkbC9JxCVdg02XmxTUb?=
 =?us-ascii?Q?ylF+eX5sN4ywwqg6u6w/td5Hx7R+zP5ywZ6jyNZuAx2UcxBGi63c7VxbgdaO?=
 =?us-ascii?Q?3bXIiPnHsfkIqXRb/3pzMZUaIbiKMdKtJsJGhgVtK11Yolnd0cFNVmiEM+Rk?=
 =?us-ascii?Q?0rL7fRg5lx6TVAYikAV+rQXz85Qg/wwFcj2GXW9v33XGhWz4tkDSBiSeDU7s?=
 =?us-ascii?Q?NVJwHmbF5cRf6nUUU9QtXO4wfJvHVcGEiE3UkFwToXI/wmC8KsXP7+yvQE67?=
 =?us-ascii?Q?IrCec/x9Kln4QGv//gu6SCviq8RbXLlNJyroWHrJMlS5pWkNRc+pJnYCcK6t?=
 =?us-ascii?Q?N3CdVUO2wAtLruQxqKgpiZb5DrEruEU/+oAXrs/2jaksUsGz6wgZZt6YcyHK?=
 =?us-ascii?Q?r6Sk7BiOly0k2yqG5Ijzjh1MC9dXJmyaGjAwkJZQsYhEICs1N+eCtXQf5w+F?=
 =?us-ascii?Q?RVYTwX/x72RjHW+PHN5Nx/hAIe2TVAKe+QxjTNlf7olADEqycTLwviWS7Bwb?=
 =?us-ascii?Q?FzQL4RPfTCVL0/dkTfruhwEz2bHxXa2G7vXmypuGbu/zc26TLnLlJKrCkkz0?=
 =?us-ascii?Q?DhuOPj0EF+en+di3h3uQqc84DN9YdB07iI2bnkWDhJ2F1NJHf2QPZU1ytwaZ?=
 =?us-ascii?Q?9xAe5twYMd3fPlFIyeKRW5emXN5PEgwAJ6VJJyAR6vYuRYio93rC2cHqQg+N?=
 =?us-ascii?Q?aXmJHvFDmIi1UaGdcPdZufqEsOSfS0HeQPqJ8BGmgZZOTBcMxtcTnYv1OKr9?=
 =?us-ascii?Q?snW0Xp5FUAuBZGmeL1Um9lXmJUNLHB/Vwata4YkiBbuMm9L+JDQrsPh400ZH?=
 =?us-ascii?Q?Q7xXUtYCC118ZF7XaTVVFu/M4bEa19BWzQsFfVvXNU3qoYl0dT9dhwxe5uvM?=
 =?us-ascii?Q?rv4j9PNGItN3MHiBY9pYKb2fx+6Q6362joAEXK5kpAcw6aGtwRKmCURNhl7m?=
 =?us-ascii?Q?wnW+okbiFgM9Wazi/qP5qsBeqL6McBtjmb2h3pjbEaina7+NYQ8LXYkpqiLw?=
 =?us-ascii?Q?1xbr21ZjtcHCsFooQI8RwwXL60VSmTVOTlgEwlCLdkRoN6AhL5/4xKUwKw8b?=
 =?us-ascii?Q?Cgt1WiOgwQgyEn5kSJw7/zwAj6Ieu/Z+iU+kc12h1mJo5OsvpHqwmCafw7Kx?=
 =?us-ascii?Q?b6uM8xPY8OHM+d+9Nn6eYJ4xEck6OnVrs8luS3T+?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 36412217-c2d1-42a0-4c25-08dae1c8c19a
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1101MB2221.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2022 13:55:58.6669
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HXjqePcA5QjzTPXw8yJ1znfv7jhIWcX2XZfqHLCC1L+ahGGlb/pVKWTFvjYn/bXdvQqo/KKNlZgdAqg/hxKMcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4947
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 14, 2022 at 08:18:17PM +0000, Sean Christopherson wrote:
>On Sun, Dec 11, 2022, Zhang Chen wrote:
>> From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
>> 
>> Guests that have different family/model than the host may not be aware
>> of hardware mitigations(such as RRSBA_DIS_S) available on host. This is
>> particularly true when guests migrate. To solve this problem Intel
>> processors have added a virtual MSR interface
>
>Is there any actual "processor" support here?

No.

>  To me, this looks like Intel is
>foisting a paravirt interface on KVM and other hypervisors without collaborating
>with said hypervisors' developers and maintainers.
>
>I get that some of the mitigations are vendor specific, but things like RETPOLINE
>aren't vendor specific.  I haven't followed all of the mitigation stuff very
>closely, but I wouldn't be surprised if there are mitigations now or in the future
>that are common across architectures, e.g. arm64 and x86-64.  Intel doing its own
>thing means AMD and arm64 will likely follow suit, and suddenly KVM is supporting
>multiple paravirt interfaces for very similar things, without having any control
>over the APIs.  That's all kinds of backwards.

But if the interface is defined by KVM rather than Intel, it will likely end up
with different interfaces for different VMMs, then Linux guest needs to support
all of them. And KVM needs to implement Hyper-V's and Xen's interface to support
Hyper-V enlightened and Xen enlightened guest. This is a _real_ problem and
complicates KVM/Linux in a similar way as multiple paravirt interfaces.

The use case of this paravirt interface is specific to Intel CPU microarchitecture.
Supporting multiple paravirt interfaces may not happen in the near future if there
is no use case for AMD and arm64.

>
>And having to wait for Intel to roll out new documentation when software inevitably
>comes up with some clever new mitigation doesn't exactly fill my heart with joy.

There should be some misunderstanding.

A bit for a software mitigation will be added if
1. the software mitigation works well on existing processors. And
2. there will be a new processor on which the software mitigation won't be
   fully effective (due to some microarchiecture change).

IOW, the new documentation comes along with a new microarchitecture (new
processor) rather than software mitigations.
