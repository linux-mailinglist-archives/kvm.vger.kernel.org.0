Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E084554331
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 09:04:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236891AbiFVGop (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 02:44:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229918AbiFVGon (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 02:44:43 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C254134671;
        Tue, 21 Jun 2022 23:44:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655880282; x=1687416282;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wVQeln2dkvMuM8ka01YjjdzgLNavlQvJSBnXlKw/6D0=;
  b=AV57/pPHpNz9uEzVXZMU+UMiBkP1gHnmSSHVMjOr03qVfXKkNXiv6bnU
   t4K2GqQvgO7JCRUBhvO8QRQYqEn18VZJnJG289sg++v9gOWczDg/Z1HqL
   FAG+9BjThgsqjqDwGR/1GQp6dEltbvPNwO2A9tYGMxKeg/gOE+qtDueEG
   zfmv/yKSbed7OBu9qKR8MD/KqUn3CT//4WhdLJMLY8oXtMwaFBa1lXoOH
   S99GCnMxlBEDBm5ZzGN+D1SStqmUGOBxrzdOzCiuLGX9yZscLVBawKSSR
   DD0ELnvpwHA7w+zsDxCAhdqCwUuHss47dUUanr8xb05YWLTD/VoKtwISk
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10385"; a="269049768"
X-IronPort-AV: E=Sophos;i="5.92,211,1650956400"; 
   d="scan'208";a="269049768"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2022 23:44:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,211,1650956400"; 
   d="scan'208";a="764757898"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga005.jf.intel.com with ESMTP; 21 Jun 2022 23:44:36 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 21 Jun 2022 23:44:33 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 21 Jun 2022 23:44:32 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 21 Jun 2022 23:44:32 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 21 Jun 2022 23:44:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=COc/AnVUW+mIV21NsIpFuE4b8Di74fM3LSb42eP2E7hTHlh0/5cBzm693YRzXJvFalMCQZ1tB+5ycHEDfO33MVYF24+9Cfh2LALxz7QKS88jSOCM4N4YBQK/8ZhwndDen+D1QkOmQpJjGll6QdvOo+qM56+1dwYaQuarOasxJ8mSGZUiWkeJF7vzegqY6fCzzKYRrCsXRM17coSoOYNV/vnBYPvlN1945+k1NZsua/fgmnibK6jDPiv/Wx/w/D3PN7Wti5zC8cBCuRUWns4mUbNfAYEEhrTwU+fNPRE9CNMyezX61MsHCiV2R0UQFh5bKEPtEyhaNdZcWwVHeJYMog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DJZCqEIyxlqOIiytaETHvB5t3i98wFoPqhaat8oLlzc=;
 b=IHaIZET0f2H7ufLRGwkqnoej3+yWMir6eA08TovGTmRenjubK3KwaDB3i+cKiWEf9KJYAf3zEvKDMJDMpMaRzZYFLS/uAunYM7glzAiXl2FtD3LWifKAyXusdAUtygJVWyk2lwp4jVgKJGc2FxgJ2IXezF0z8N3cfaIUCVHJohN3iQLTkPNAMUdNaxNvC37PQk3cAocpnncmM9zqnDkLIFJc9vTTBCyUhdQbazzSabuyTcyWQVuS4LuN9ECVAeAY4ODCSBmQLu4caksvQj3WsTTN4wscPGtzD1ziLzdxHICp/kALIpQvVCIwvVzOkPIDElVYhDCrB9B3XLhYqAELEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN2PR11MB3870.namprd11.prod.outlook.com (2603:10b6:208:152::11)
 by SJ0PR11MB4943.namprd11.prod.outlook.com (2603:10b6:a03:2ad::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.15; Wed, 22 Jun
 2022 06:44:30 +0000
Received: from MN2PR11MB3870.namprd11.prod.outlook.com
 ([fe80::dd55:c9f5:fbc7:8a74]) by MN2PR11MB3870.namprd11.prod.outlook.com
 ([fe80::dd55:c9f5:fbc7:8a74%3]) with mapi id 15.20.5353.022; Wed, 22 Jun 2022
 06:44:29 +0000
Message-ID: <025806b0-7f62-6ae4-241b-7c084739b01c@intel.com>
Date:   Wed, 22 Jun 2022 14:44:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.10.0
Subject: Re: [RFC PATCH v4 7/7] KVM: selftests: Add tests for VM and vCPU cap
 KVM_CAP_X86_DISABLE_EXITS
Content-Language: en-US
To:     Kechen Lu <kechenl@nvidia.com>, <kvm@vger.kernel.org>,
        <pbonzini@redhat.com>
CC:     <seanjc@google.com>, <chao.gao@intel.com>, <vkuznets@redhat.com>,
        <somduttar@nvidia.com>, <linux-kernel@vger.kernel.org>
References: <20220622004924.155191-1-kechenl@nvidia.com>
 <20220622004924.155191-8-kechenl@nvidia.com>
From:   "Huang, Shaoqin" <shaoqin.huang@intel.com>
In-Reply-To: <20220622004924.155191-8-kechenl@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SGAP274CA0008.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::20)
 To MN2PR11MB3870.namprd11.prod.outlook.com (2603:10b6:208:152::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8bbca191-0eeb-4806-ba40-08da541aa83f
X-MS-TrafficTypeDiagnostic: SJ0PR11MB4943:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-Microsoft-Antispam-PRVS: <SJ0PR11MB4943250A12D74F24297C51ADF7B29@SJ0PR11MB4943.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +N9R/9uyXdz+X4QF5SiqfOdHZ3U4ahvibItGf9HS780RRAEDYg/K9N2O6j6Lgokx3NKZYYc+JCzxpouMaA9R6yMBd4edkv9A0kxMupyS9tQdsg4biEF9N++lcY0gBslQz52DPnvcfECLilLToIVFsQFBh2dVKsXWgz2Noxz0IDAAnXiontCnOHbwuEiBjpY7ON76WS6zpQjOzZ490ZK1e37I7KtFFEzb1Pd5EERg6AIisCkmV1wtJGiYS48sfi2vOcTVNq6Ess6iqgVjOvs1vLtyddJ+4cMuYmOsXqld1m1syVLUS4GZeV7aMIGIoboh/eHW/7P6vy5f/2wj17AaHpUnAlaAvdFtjfEAqlWVNPiOcK/efJTW2lPDNEBOUTPuR4lHKLuWnENBQENjVHH/7oLb8ArKrHkAbOvhTbX6SDFm3OwRMBZY4kJGkHmOjYKFMOQvB+txPCnyoSSjCB5sL1LbskeSLKrk//D2X8uMhwmKezsmOCgQTURSAqRSqAKAUU2V+kG25zyM55270XdsOJQD1r6pQ1zo89DhDprClP47VRCN/bIlAKS+OV16R2sb+HPiH0Hqu1kIOQJGNXT6fvGnV5cG6RfUtQjrbtYusIKdPHxrEV0bxdNUhYQwr4b9aqXC2/zafDRgdUxTMNpF5r3Q525q3A7RsrRAJsIKVqQcymZgG69uZcmsOomcPQSaqOqrV0frBW7s9vkTmJctBym1jlxdhEjKqma2xUga+Vcegk3Ow3VMFxERLYxEsg4otWvJy2X4B1aG6IgRd35Wz4QzAsz8Y2jWfQgbv3QySvQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3870.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(346002)(39860400002)(376002)(366004)(396003)(66476007)(8676002)(6486002)(31696002)(66556008)(478600001)(4326008)(31686004)(83380400001)(2906002)(82960400001)(186003)(86362001)(316002)(38100700002)(6506007)(2616005)(41300700001)(53546011)(8936002)(5660300002)(36756003)(66946007)(26005)(6512007)(6666004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K25FZEZGWm9MWEp6VU5PWktwT1RCU2trRUVueVMxZ2VzdkZUMmQ2VjRDOTR2?=
 =?utf-8?B?Q1Y4cVdHbkhYNGNHRGYxODFLakNuTTNSbWUrYlpUMVI1K25JSHVEYmF0cjJz?=
 =?utf-8?B?ekwrNkJlVXIwWlhHNitVWFVtR0JkK0hFMld5OG85aXJxYWF3SEhsck8vc0V3?=
 =?utf-8?B?cDJNalN4WjFyelloa3dKdUdYOURmMGlTZGEwWEZ0TkFPd1F3VUx6aExjYUt3?=
 =?utf-8?B?V2paOWtNV3RNVVlnajJ2c0Y3ekplSWxoRlJoUlk3Znh3cFlNaFdWL3QvTGtW?=
 =?utf-8?B?WVRYOENtZFIzelJwOUJpVU1NVnJzeVJSYVlnMEJrczR0MFZKZkJzd05kWmk5?=
 =?utf-8?B?T3RyclkrRXFPaWtNSFd2ZzBDTEVWSDQ1elBRWUVxMVNSaVJLdkZpSTZud0dM?=
 =?utf-8?B?NkZtcVZ4R1oxZkkrTlYxY3BpNlNMNDUrTkZOdTk3SHpueGUxSDFGVVFzWS9l?=
 =?utf-8?B?Z0piNzBhelFZcE04Wm5ZMGlFeTRBcHY5WUVFeTJhYjEzc1ZUdUp3WnJ4V3FR?=
 =?utf-8?B?UEZzUnRzWHlrOGpXU1V3c0s1ZXRKOEU2eTZvLzJLRjhxZittbDFWK0hybXhq?=
 =?utf-8?B?LzQ5QUJBdmF2YUFHWUpUdm5RTVpQS3JlN3JGTFh2aEJsclppaDJkUjlyV0VC?=
 =?utf-8?B?QVEvRHp0cWd4NHIxR1Fab1dnS2x1d0gvVjRYMkJqSEUwR3Y4RkV1ak5MWlQv?=
 =?utf-8?B?dmt1ejNIUVVWT25yV20wR2tPaWlWMThNWHUydVp0VkR6U0poYVhIbTJUMEx3?=
 =?utf-8?B?dlVPbkEzQ0JKcDR6V0VtaUNyTUlOT0lWNWxTcm5LMHZadG9waEZBNmttOHVN?=
 =?utf-8?B?WTBjWlR5Ty9udlN5ZHF5UDFkVTNuVjVtQnEwUzREemx4V1VJVDViTktsNjhP?=
 =?utf-8?B?eWtLOHArb3grdVVLQ2ZwVU1xdmhwMGNMOENOY0QvMmNWS29sLzBST1lnNVlI?=
 =?utf-8?B?dXhKdFlnOUJPQWozN3R3ZUJXYkpoTkdQTWRtSzNGL0VGTmVQYkF0SGtEYXd6?=
 =?utf-8?B?R0thVjFORXNIRk9sMDBwYm5wRkJ4V0xiUVNOdlpMSURSVXRzMDlzWnNOWWw2?=
 =?utf-8?B?STg0NEFoek1XMFNRd3lDYzhKaEN2RnM3ajhReHA2WHVJRVJockhxTy9Rck1a?=
 =?utf-8?B?WkRrcVliV055UkFtcjl5cVFsVXZ5WlNRc0NLa0pPWHk5dkZvODkrRHdVcENS?=
 =?utf-8?B?Rlhta3pPeTkwamo2WnBObkZzTUFmQjA1cnk2ZWJDQ05vMEIyWTVzL0VVaTRj?=
 =?utf-8?B?V1IvNVFFa1NONk9YU1BxRUdhQzFwTTNWWlg2dHNzTStyajFhU3ZhdzRYd05N?=
 =?utf-8?B?NmhPaTZTVmJub3d3bHZvKzdHRDg0VFdTZHhOc1ZValZGclYzKytLUjRrT2Iz?=
 =?utf-8?B?T1AydHBTdDVxZXQxNUlQR0pUb2FPdU5oOHdld05ndHBrcDNzRmhjbEw2cm8w?=
 =?utf-8?B?SDZma2FRSHFDbWFNbVdtWXlUcTQ5d2pra2RybUswQUU0QTFQeXZlelY1M0JE?=
 =?utf-8?B?Y1RzMC8zQmtQRDBadUJBMXNFTFNoQm5tdithMEpVaTFZRnorSG9kQ3JveU1k?=
 =?utf-8?B?aEJyajlHRTk1eVBxVkFzMFNER3lXbGFtM0lPNWNIYXh2NE1zQnZ4QTJWZi9t?=
 =?utf-8?B?cWNXZUhRYWE2bUJRbG9IRzR1ejcrdWUwOXVva3krTEdPTlUwbCt6clFUTHNG?=
 =?utf-8?B?Z2wzR0YvWkdEU2lrZ3pqS1ppcGRuV0lXcjRic1pTbldoeUhWZ1BvZ1BFSDVW?=
 =?utf-8?B?MjhXRGtDdkhJZm9hOVA4YnNIUEFqZTB2UG9yUGJMMDhOemloZGpRR2VaMzIy?=
 =?utf-8?B?eGxIS3ZQME9CaHF6RWJCYTYwNmJBNDRHS3hIblVucEZoWG1YeHkxYzRXOURK?=
 =?utf-8?B?M1FEalQ2YWM0N0tvZTlZYThTSmliTlFGTTBkY0pJV2N6V09VakpETEIxVno4?=
 =?utf-8?B?cnJHbnE3ZjE4STJ5RnFNZS9zQStyamtobllKSFJzR1g4M3lGdnZlMzNra0c3?=
 =?utf-8?B?aXB1ZnNXWHRmTXFDWWtFM3VEalI2Qys5UWZxaCtFbXIxaGY4UmZBZDNmaDFj?=
 =?utf-8?B?d2ZOYlZYWWhtT1Z3TjV6bXB5OWJSRmNMbmZtai9CQ2RkcVorSFM4bnVlaUNH?=
 =?utf-8?B?OENtamlUbXhxNGVGMHI1bW9rSjVZeWlBTk0xTS9JejNJWHYvdG5kRy9vMHpn?=
 =?utf-8?B?K3Z3SFJFNTMyTHJkeURLUXQwQ3FTYWZyK1hRd1lsamdkSzY1ZVppdUZ6UFJu?=
 =?utf-8?B?R2R3b01CbWw2cVAxWGpCREkwRGdKUHVIRUJvVEpSRnF1dExTbGRpNU9LVkFa?=
 =?utf-8?B?QkF2alhBSGMyUmc2YlZTdmlOYWlXTUxrSGQ0MmkrRlY1cGp0dmdJV1hGU2Nx?=
 =?utf-8?Q?ZPjxOe6jZDIK1u4M=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8bbca191-0eeb-4806-ba40-08da541aa83f
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3870.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2022 06:44:29.8884
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T8g/DqFHv+Cg0s++0lC5ub4DkQiIm1l7n+5ovtcdgebn49Ova32CfGxkvLUXivsaC6eYrYZLueQT6PNB9jv/RA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4943
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/22/2022 8:49 AM, Kechen Lu wrote:
> Add tests for KVM cap KVM_CAP_X86_DISABLE_EXITS overriding flags
> in VM and vCPU scope both works as expected.
> 
> Suggested-by: Chao Gao <chao.gao@intel.com>
> Signed-off-by: Kechen Lu <kechenl@nvidia.com>
> ---
>   tools/testing/selftests/kvm/.gitignore        |   1 +
>   tools/testing/selftests/kvm/Makefile          |   1 +
>   .../selftests/kvm/include/x86_64/svm_util.h   |   1 +
>   .../selftests/kvm/x86_64/disable_exits_test.c | 145 ++++++++++++++++++
>   4 files changed, 148 insertions(+)
>   create mode 100644 tools/testing/selftests/kvm/x86_64/disable_exits_test.c
> 
> diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
> index 4509a3a7eeae..2b50170db9b2 100644
> --- a/tools/testing/selftests/kvm/.gitignore
> +++ b/tools/testing/selftests/kvm/.gitignore
> @@ -15,6 +15,7 @@
>   /x86_64/cpuid_test
>   /x86_64/cr4_cpuid_sync_test
>   /x86_64/debug_regs
> +/x86_64/disable_exits_test
>   /x86_64/evmcs_test
>   /x86_64/emulator_error_test
>   /x86_64/fix_hypercall_test
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> index 22423c871ed6..de11d1f95700 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -115,6 +115,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/xen_shinfo_test
>   TEST_GEN_PROGS_x86_64 += x86_64/xen_vmcall_test
>   TEST_GEN_PROGS_x86_64 += x86_64/sev_migrate_tests
>   TEST_GEN_PROGS_x86_64 += x86_64/amx_test
> +TEST_GEN_PROGS_x86_64 += x86_64/disable_exits_test
>   TEST_GEN_PROGS_x86_64 += access_tracking_perf_test
>   TEST_GEN_PROGS_x86_64 += demand_paging_test
>   TEST_GEN_PROGS_x86_64 += dirty_log_test
> diff --git a/tools/testing/selftests/kvm/include/x86_64/svm_util.h b/tools/testing/selftests/kvm/include/x86_64/svm_util.h
> index a25aabd8f5e7..d8cad1cff578 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/svm_util.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/svm_util.h
> @@ -17,6 +17,7 @@
>   #define CPUID_SVM		BIT_ULL(CPUID_SVM_BIT)
>   
>   #define SVM_EXIT_MSR		0x07c
> +#define SVM_EXIT_HLT		0x078

There has other people add the SVM_EXIT_HLT in the kvm/queue, so you may 
not need to add it here.

>   #define SVM_EXIT_VMMCALL	0x081
>   
>   struct svm_test_data {
> diff --git a/tools/testing/selftests/kvm/x86_64/disable_exits_test.c b/tools/testing/selftests/kvm/x86_64/disable_exits_test.c
> new file mode 100644
> index 000000000000..2811b07e8885
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/x86_64/disable_exits_test.c
> @@ -0,0 +1,145 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Test per-VM and per-vCPU disable exits cap
> + *
> + */
> +
> +#define _GNU_SOURCE /* for program_invocation_short_name */
> +#include <sys/ioctl.h>
> +
> +#include "test_util.h"
> +#include "kvm_util.h"
> +#include "svm_util.h"
> +#include "vmx.h"
> +#include "processor.h"
> +
> +#define VCPU_ID_1 0
> +#define VCPU_ID_2 1
> +
> +static void guest_code_exits(void) {
> +	asm volatile("sti; hlt; cli");
> +}
> +
> +/* Set debug control for trapped instruction exiting to userspace */
> +static void vcpu_set_debug_exit_userspace(struct kvm_vm *vm, int vcpu_id) {

nit: you should make the code style consistent, please use the format:
function()
{

}

> +	struct kvm_guest_debug debug;
> +	memset(&debug, 0, sizeof(debug));
> +	debug.control = KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_EXIT_USERSPACE;
> +	vcpu_set_guest_debug(vm, vcpu_id, &debug);
> +}
> +
> +static void test_vm_cap_disable_exits(void) {
> +	struct kvm_enable_cap cap = {
> +		.cap = KVM_CAP_X86_DISABLE_EXITS,
> +		.args[0] = KVM_X86_DISABLE_EXITS_HLT|KVM_X86_DISABLE_EXITS_OVERRIDE,
						    ^
			nit: a space is much more clear here

> +	};
> +	struct kvm_vm *vm;
> +	struct kvm_run *run;
> +
> +	/* Create VM */
> +	vm = vm_create_without_vcpus(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES);
> +
> +	/* Test Case #1
> +	 * Default without disabling HLT exits in VM scope
> +	 */
> +	vm_vcpu_add_default(vm, VCPU_ID_1, (void *)guest_code_exits);
> +	vcpu_set_debug_exit_userspace(vm, VCPU_ID_1);
> +	run = vcpu_state(vm, VCPU_ID_1);
> +	vcpu_run(vm, VCPU_ID_1);
> +	/* Exit reason should be HLT */
> +	if (is_amd_cpu())
> +		TEST_ASSERT(run->hw.hardware_exit_reason == SVM_EXIT_HLT,
> +			"Got exit_reason other than HLT: 0x%llx\n",
> +			run->hw.hardware_exit_reason);
> +	else
> +		TEST_ASSERT(run->hw.hardware_exit_reason == EXIT_REASON_HLT,
> +			"Got exit_reason other than HLT: 0x%llx\n",
> +			run->hw.hardware_exit_reason);
> +
> +	/* Test Case #2
> +	 * Disabling HLT exits in VM scope
> +	 */
> +	vm_vcpu_add_default(vm, VCPU_ID_2, (void *)guest_code_exits);
> +	vcpu_set_debug_exit_userspace(vm, VCPU_ID_2);
> +	run = vcpu_state(vm, VCPU_ID_2);

I think you can add more vcpu here to make sure after disabling HLT 
exits in VM scope here, every vcpu will not exit due to the HLT.

> +	/* Set VM scoped cap arg
> +	 * KVM_X86_DISABLE_EXITS_HLT|KVM_X86_DISABLE_EXITS_OVERRIDE
> +	 * after vCPUs creation so requiring override flag
> +	 */
> +	TEST_ASSERT(!vm_enable_cap(vm, &cap), "Failed to set KVM_CAP_X86_DISABLE_EXITS");
> +	vcpu_run(vm, VCPU_ID_2);
> +	/* Exit reason should not be HLT, would finish the guest
> +	 * running and exit (e.g. SVM_EXIT_SHUTDOWN)
> +	 */
> +	if (is_amd_cpu())
> +		TEST_ASSERT(run->hw.hardware_exit_reason != SVM_EXIT_HLT,
> +			"Got exit_reason as HLT: 0x%llx\n",
> +			run->hw.hardware_exit_reason);
> +	else
> +		TEST_ASSERT(run->hw.hardware_exit_reason != EXIT_REASON_HLT,
> +			"Got exit_reason as HLT: 0x%llx\n",
> +			run->hw.hardware_exit_reason);
> +
> +	kvm_vm_free(vm);
> +}
> +
> +static void test_vcpu_cap_disable_exits(void) {
> +	struct kvm_enable_cap cap = {
> +		.cap = KVM_CAP_X86_DISABLE_EXITS,
> +		.args[0] = KVM_X86_DISABLE_EXITS_HLT|KVM_X86_DISABLE_EXITS_OVERRIDE,
> +	};
> +	struct kvm_vm *vm;
> +	struct kvm_run *run;
> +
> +	/* Create VM */
> +	vm = vm_create_without_vcpus(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES);
> +	vm_vcpu_add_default(vm, VCPU_ID_1, (void *)guest_code_exits);
> +	vcpu_set_debug_exit_userspace(vm, VCPU_ID_1);
> +	vm_vcpu_add_default(vm, VCPU_ID_2, (void *)guest_code_exits);
> +	vcpu_set_debug_exit_userspace(vm, VCPU_ID_2);
> +	/* Set vCPU 2 scoped cap arg
> +	 * KVM_X86_DISABLE_EXITS_HLT|KVM_X86_DISABLE_EXITS_OVERRIDE
> +	 */
> +	TEST_ASSERT(!vcpu_enable_cap(vm, VCPU_ID_2, &cap), "Failed to set KVM_CAP_X86_DISABLE_EXITS");
> +
> +	/* Test Case #3
> +	 * Default without disabling HLT exits in this vCPU 1
> +	 */
> +	run = vcpu_state(vm, VCPU_ID_1);
> +	vcpu_run(vm, VCPU_ID_1);
> +	/* Exit reason should be HLT */
> +	if (is_amd_cpu())
> +		TEST_ASSERT(run->hw.hardware_exit_reason == SVM_EXIT_HLT,
> +			"Got exit_reason other than HLT: 0x%llx\n",
> +			run->hw.hardware_exit_reason);
> +	else
> +		TEST_ASSERT(run->hw.hardware_exit_reason == EXIT_REASON_HLT,
> +			"Got exit_reason other than HLT: 0x%llx\n",
> +			run->hw.hardware_exit_reason);
> +
> +	/* Test Case #4
> +	 * Disabling HLT exits in vCPU 2
> +	 */
> +	run = vcpu_state(vm, VCPU_ID_2);
> +	vcpu_run(vm, VCPU_ID_2);
> +	/* Exit reason should not be HLT, would finish the guest
> +	 * running and exit (e.g. SVM_EXIT_SHUTDOWN)
> +	 */
> +	if (is_amd_cpu())
> +		TEST_ASSERT(run->hw.hardware_exit_reason != SVM_EXIT_HLT,
> +			"Got exit_reason as HLT: 0x%llx\n",
> +			run->hw.hardware_exit_reason);
> +	else
> +		TEST_ASSERT(run->hw.hardware_exit_reason != EXIT_REASON_HLT,
> +			"Got exit_reason as HLT: 0x%llx\n",
> +			run->hw.hardware_exit_reason);
> +
> +	kvm_vm_free(vm);
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	test_vm_cap_disable_exits();
> +	test_vcpu_cap_disable_exits();
> +	return 0;
> +}
