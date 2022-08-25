Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF6E5A1A88
	for <lists+kvm@lfdr.de>; Thu, 25 Aug 2022 22:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232824AbiHYUph (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Aug 2022 16:45:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241969AbiHYUpc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Aug 2022 16:45:32 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41E8B222A5;
        Thu, 25 Aug 2022 13:45:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661460329; x=1692996329;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xOwZRLhv3yX2DTZzO4RNIhAGbNXqkTZO2Q2ypxP3eok=;
  b=knhZRFNS7RcnGais0GQjA4qKBCn9Ph8ya4yzgeQWr3Q5Bym26xo3P3lL
   Sca3NK5lNMLQbuQGI7nd1BOxD/rtMw998A5R1Jw1Tq3lXYMFVQTWngZJm
   7omsH1Z2d1afHr+pkhi4xlNYmKrLTRJUoyzkbDX9C7x1qHmhZH3FE+KZa
   NGwGRH+jec4Xs66kh2pDRWGXGDOYiiCTtJAgcX11gl4qM45atAL/b/vPl
   ibw/uQZ22c4EoFUYALPDKrpZyaWCUmfHX4PRS7WiuzLbAlvTR1qTq2DUS
   SLvEV5SikwYLFKSonQC0t8Iwc55nRFYMQXU4LIyf2Au+ShxazRtP9xEQl
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10450"; a="295134098"
X-IronPort-AV: E=Sophos;i="5.93,264,1654585200"; 
   d="scan'208";a="295134098"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2022 13:45:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,264,1654585200"; 
   d="scan'208";a="752632874"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga001.fm.intel.com with ESMTP; 25 Aug 2022 13:45:28 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 25 Aug 2022 13:45:28 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 25 Aug 2022 13:45:28 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 25 Aug 2022 13:45:28 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 25 Aug 2022 13:45:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h+iz6Wmc/amTwx1XV49yVXq94ugtrAOGopG07DqFKKz9S10FHXXcKLym3nqncI7PR5nmDNE1zOR1w3Un3IEDTfveB8iDEUIM+OeFb4M5cRjDVyQ6V5XJV8tnIAInKbupJaD2136UMpeTvctoTSRtM4Szpf7jt7jyJPgiJ+jwRPRSfCkCMhOiOQ57PvVlUk4t71/MThcrZVwRW3IOdvoy8n4AKUSVyFymutQiSlqbk75C5mIRXakVBxpOx95jqYcxyPIrOdQ2be1JIY/ARLhbLw7bzYUaPw7BowpdimJ28gfKHSerEmPPpEGl+0xulsFS7hKG7t4gw3AgSsJ6BqdvEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6e0/e8o2bA5C+dI/uFcApbWRSwxGeCwvS+/eI/7WlzU=;
 b=D6fLJqBRzdAeFO8ORHWt0DVAPWpSmyJbYSHS8qWpO0O9LAxwG0p5M1e+LpP7YZ0Liptp5xv9AUrLGZTmXgOJ/Fiq8ZGc/zccjmF50MhQjZuFI7kU5GWCsEXk72Vot0aJ4U2cQcl/XNlm5iEHyJFccisR+T2C/fgmRXxoNMwEqgB6BNdjs8cFkhkC40I0bmWE4Jbrg22VqR6MAgz2zwhNDfQTmP2QKKpImq2yi0MPlBYj+NAQQDEIz126IOFeo/MHL0JRckJNyJFusgRaLhdZitpPVjPKj5jDUv/H/3sA8gpaDOWg2lL+GCsPwsLB/i77l25cwXX54anc5l8hHAgWFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4855.namprd11.prod.outlook.com (2603:10b6:510:41::12)
 by BYAPR11MB2600.namprd11.prod.outlook.com (2603:10b6:a02:c8::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.14; Thu, 25 Aug
 2022 20:45:24 +0000
Received: from PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::5d13:99ae:8dfe:1f01]) by PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::5d13:99ae:8dfe:1f01%3]) with mapi id 15.20.5566.014; Thu, 25 Aug 2022
 20:45:24 +0000
Message-ID: <e52f26d4-c52a-e20d-7bc0-663bb4979827@intel.com>
Date:   Thu, 25 Aug 2022 13:45:22 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [RFC PATCH 1/2] KVM: x86: Add a new system attribute for dynamic
 XSTATE component
Content-Language: en-CA
To:     Sean Christopherson <seanjc@google.com>
CC:     <kvm@vger.kernel.org>, <pbonzini@redhat.com>,
        <linux-kernel@vger.kernel.org>, <yang.zhong@intel.com>
References: <20220823231402.7839-1-chang.seok.bae@intel.com>
 <20220823231402.7839-2-chang.seok.bae@intel.com>
 <YwabSPpC1G9J+aRA@google.com>
 <08e59f2d-24cb-dca8-b1b8-9e80f8a85398@intel.com>
 <YwehLNws0WBNRDgN@google.com>
From:   "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <YwehLNws0WBNRDgN@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR04CA0017.namprd04.prod.outlook.com
 (2603:10b6:a03:217::22) To PH0PR11MB4855.namprd11.prod.outlook.com
 (2603:10b6:510:41::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7af49906-4761-4986-8464-08da86dabc28
X-MS-TrafficTypeDiagnostic: BYAPR11MB2600:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5TEtzFsFG56MLk6/Km+J4d42zzPfaPWtcNDZso0UENKD5NDylVPmmo9/s4voIj9zUZCcHQ2NMsxEkvZW539/Twdeo37T9DBe0OXJKvr1ncwxI3zCK4lZqZgIXeJjv2a+10bp1q+aEzqlhE+Llf3ZV+/VgEp+wxfBUDsDOo1cnCAYEPFmDLNmlpDofaojzn8vbNNLXvsA2lrQWMtUQcOGDd2hLslWRDHNjnMbdm49XQh46uHIt+MOUdcjTbe31vOGkzUrKHpNnPeuwaT7RCXrZnoXio/6vxgWTpak+nhjVqDdgKjZsXK5lBtkbXNeAzvUIMMaWiqwhySf3E8GSG0xMnU2dlpsY1j65kqHauSA9HgfmgjOQMkDC+dj1VsKgdZKQvwchD8Aa/1f2P8Ngu5YwE7FaPNxD42pH7CUUTxMkw6/m3pD+8JgexixY4y2l6m50C9pBnYHVeqovwa7RJabhKG0eMEiaLvneBhcG43IPKXpSDfIopjlOVLvdFy3gXLbkV5p85ISZfaMRpSkrh+9+GGXMhzOO9qfRgJvK0tC5FoCWrZ9uLnPo+56KQJogVWNvhNzhUPIXlpErhPBlFWNmzX0pKkLOK77VLZ6quCthx8v2DaufTaPSk6J0eycWEKX/ZwNvZr4gE2FfWqDxLsz4p+YGcnTDd13UHaFSC17KVaW3wvUs/xvfTkfLUKT8gyNCK3JF36bjB7NmDwr+NeVSnWIU/e6jsLxEk8Dkn2rjut5tzWlckdFfSn4omc2ESMin8vY4YXR5WkJDVM324uiTgV9eB8U90CGZztWM4iU70I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4855.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(39860400002)(376002)(396003)(346002)(136003)(8676002)(31696002)(4326008)(6916009)(66476007)(66946007)(186003)(38100700002)(66556008)(41300700001)(316002)(53546011)(6506007)(86362001)(82960400001)(26005)(6512007)(107886003)(6486002)(2616005)(478600001)(8936002)(83380400001)(2906002)(4744005)(36756003)(31686004)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K3BCVHNFSjJxZTcrU3FVaVhYb0ZaL0xQTTdaQW5lT01KUVBScWJpMWIyL2ln?=
 =?utf-8?B?ZlRYa2ZkT1cvamtrOWQxaExUZkNVTjh0NlRCM3F3NVhvL2VSTWtXWkc3dDUy?=
 =?utf-8?B?TWUxc09PaFVWeWI2WE5FZ2VKOWc4MFNPekpRL1lNVVVJNHd4V3k2aFlQWi9Y?=
 =?utf-8?B?elRrd0o2RjM0MDFrMkl3bTAxWFh1Q29VcktWUk9PY1dOUzhTZEo3bTd5TUZ3?=
 =?utf-8?B?anBqU1E5V2UyNGhhZGNtRHU4RXpvbm90OWxEaDF4V292OEVwaENLWnFzd25R?=
 =?utf-8?B?TGo1S096T1RYWldTdkROalM0WlRKdjZhRHF3N3laT0FSaERZNFVLL21lSWJz?=
 =?utf-8?B?K2U5OG4zUks1d2RzL0tlZ3RNRHJqWmxURE14a2FoOWFvZW45a3hxVW9Xcys0?=
 =?utf-8?B?YW9ZZ0dSQW96Qkw0dzdVL2p5R0tsYWVQUzhjMGlwZTJEaFIwU0VjOFd3QXRu?=
 =?utf-8?B?d2dUMVhpSFZZd3lvVTNCQnhLSUtoSzRsdDZITGM4eDBDRnVvSll5SjFRMkcz?=
 =?utf-8?B?aTJESVNkdVN1N0FwUmZQSHV2TU5TZ29ZSURPclVyRWFXcjFkL2xnY0Z6eENo?=
 =?utf-8?B?cnR6VmlhM1pnUzZpTWlsV3FhQTFzMjNnaVM3WmpkMDR6QisrZ3JaVDBuWWVn?=
 =?utf-8?B?V3RPWXdDaTBDV2hrUzNFSXIrbVNMTjFYSXg3MlMydTNrNzZHa1lTT01mUWQy?=
 =?utf-8?B?c3I5cU5QTitVdmIzMHVLNmdmUlJ0SUwrMGd3WnJiMkFBWTFQOFYxK2VmcHRP?=
 =?utf-8?B?azlkeTkxZ1NCYyt3NWovekloU2hCWDlmYkgrM0ovUis1QlJLOTFUTTNXNlFD?=
 =?utf-8?B?SGZKcnpSaUZNT2dpOFdxczJHSHp6M2tvQWsxQ2EzODJocUtHK0RIMFdNNkla?=
 =?utf-8?B?aTNMdnRMRmptZ2RjM2svc29sUzg4bmNCVlZkNDRmSE5PUlZ2SVB6RkFWd2Ju?=
 =?utf-8?B?dWhWNGU2aXBpMGZ1dmFEU3NEc29YMUVyM1lERU12aWxLWnE4VFFWVnNnaVhN?=
 =?utf-8?B?ankxNUVoT2N6VlltcGZPMHlFVkJTZ1U3L1A4RzVyL0NrTnpRcDgvL0hkTlFR?=
 =?utf-8?B?a04yWllWNi85aXRJOGhtU0hnU09xZUxGbkJFYm1GN0lNQXhZU3J6b2VwTUpV?=
 =?utf-8?B?ZEI2aW1pWEE1VC8rMWtoL3JlaldzUzE0UUtpelRLUUpweGhFcFlQMURuSGpu?=
 =?utf-8?B?aFMzRHRDeXhTZWxNRXFTZDBYV2xxcFdIMi8raTRiVVExaFQ0cXQ5bndtbUND?=
 =?utf-8?B?ajBTc1FaeTRuM2xHM1doTy9nWXFDbWN0WUxXeCtXRTlZWUszSnR3bXBMd0dT?=
 =?utf-8?B?VzQ4eWRFUXpLSERIVzVoL20xcXB3WnNWZnR1T2o2VU1hbkxuMnNrNjJQRTNL?=
 =?utf-8?B?WXpFU3JRVEVBTkIwN0dJYkVZcG9BK0NLR1pHSGRaclR1RkhLaUhRVnkwSUt3?=
 =?utf-8?B?VDBYSjNNanNUVlNLYzJQaENneVhtaTdQdTZkeEZGME9PN2N0M2xpOXZKU1dM?=
 =?utf-8?B?VXFhN2JUdnMxWWt2bVNBZDhNRGFIS09WN2RvQVpiNUdJMm1PdEtDRnVjYmRS?=
 =?utf-8?B?V0V2OGZFSkd2NFNORkg0U3pVNTJIdUo3bi9TcUdJZ3h4MVpBTCt2c2lpMjBN?=
 =?utf-8?B?TlF6SXM2aDhkZTJsbG9QNUM0Si9QcVIxSGh6MTlJSUpJYnhYTXdDR2lOVDZm?=
 =?utf-8?B?NmNKYjVKTG5sZnZJcmNkZWwzMmZpNHFIeXcvUjJlNlpXMjVrT2tMN2Q1N0Mw?=
 =?utf-8?B?eUZUVkY3d25vSXJob2UvbnV0ZmVMQWJ4Q3J2M3ZvRkFEUUZ4L0xOZElWTTVH?=
 =?utf-8?B?YmZyeXBqalFhRVUyNzFna213WHRkZE1XS3NxUS8zZGo0ekgrTkNqMGlkU2lM?=
 =?utf-8?B?OUdBdHk3eVhmdGM1LzBycHJ1cTZVVUViMHJIbGl5VSt4ZUVjQ2p5OXo2Vi9R?=
 =?utf-8?B?RUJYZzdCak95cDNIeld5bzgwVGYvcXpWcUpKTzhBYlBKQktPa2JFQm41L3JF?=
 =?utf-8?B?S3hBT2h0clFQZFBMVW80akpCWXpPTkRUbnEzbGU0T0R2eUh2UDFTcU8zT2lC?=
 =?utf-8?B?YU1rVEZhSG9ZbXFnSTRzNENOTlIxQ05vOW8yUFVMNXA4WDZ6QklhWjJVc2Np?=
 =?utf-8?B?QllmeDkycXd0NWlBVkpsUlMxMHZkSG1DTXlaKy9uUEVVK1BuNm5wdERtWEE0?=
 =?utf-8?B?Nnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7af49906-4761-4986-8464-08da86dabc28
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4855.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2022 20:45:24.6766
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kSOVHYoRrkr36DiFLuv0i03XFCc+qRP0lMvJHceJvgfLmQT0DmlsbjYyW2lfZObY+b6ck3Vpo8JqhKLY8hgD61RTFLoiTERrqL56UExx3bU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2600
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/25/2022 9:19 AM, Sean Christopherson wrote:
> 
> Adding new uAPI and new exports to eliminate one line of userspace code is not a
> good tradeoff.  Am I missing something?  This really seems like solution looking
> for a problem.

Well, then that's your call.

Yeah, that simplification is really minor. With this, I would rather 
think KVM wants enforcement before relaying the request to the host. 
That enforcement is unthinkable without supported_xcr0. But it looks 
like userspace is somehow trusted here for KVM.

Thanks,
Chang
