Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E3A17A4217
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 09:17:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233318AbjIRHRT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 03:17:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236754AbjIRHRL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 03:17:11 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1EA2A8;
        Mon, 18 Sep 2023 00:17:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695021425; x=1726557425;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WudwTdJWgMId2gb+WYdeD6IceQKY4AoHNVJkE2gntwQ=;
  b=SaQ2kkeu5+JN44X7hhb+JkSsfFAPPuPGchF7uWQP9GaBDDKz+5pvpu8h
   CvgBSSYc9lO7l/krtquthikXbi0GoEHeWamzG8MMGF+Xk/GvvNunmThWZ
   5a7Ox54bFbkmr6v/a6KGnjW9vH7u8prKOP4pqGz6U4NMiLrdUfCeehz9b
   mFifPlV6RZoyvmZJ00m96CTCh0p0CMk8oyOEOBrpTDHRYafjb6TfP5Mlz
   ysKmjj2LXhTpJIGbSc19qZR9j0SUhl8L2b1bsXRp3V2xYLK7eHBsJpkcX
   azkWJX70ijdiB9AdZTFxEd/SMh9TEy4VKEUn9GqmVivByfrFbO7zoKq9e
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10836"; a="382328358"
X-IronPort-AV: E=Sophos;i="6.02,156,1688454000"; 
   d="scan'208";a="382328358"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2023 00:17:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10836"; a="888926722"
X-IronPort-AV: E=Sophos;i="6.02,156,1688454000"; 
   d="scan'208";a="888926722"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 18 Sep 2023 00:16:21 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Mon, 18 Sep 2023 00:17:03 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Mon, 18 Sep 2023 00:17:03 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Mon, 18 Sep 2023 00:17:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DWiI2HS9lyjwQ8Df80Fhsg0/sLFcUckKVeK54LZyMX0UQ0uZ+fcyXFpoOsK60KDTwvQl4j+JtWiNu5a24DC3SBdFkqGhk6gGeidosOZDDcH7iRIm+HEbXsBNvTw8mnFSUijvWN04b2mn+nljjYG6/yzyHPki79pXtvIO/M87661dDH/haDluWGbk36xnqJBQTLPCvjHxOIR5h/FKR00ObpyieUN43i9ZzLaRBgUjCgvBuexWRuO9rMwfDH2G9GaJrTnlDsq2feFMkRlvT7v6aC+ehnQo6tiqCiNNjZXzaAKLroDOc49BxY3kykI95qhL4Yg9GijQHniYXf6CLRV5EQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WudwTdJWgMId2gb+WYdeD6IceQKY4AoHNVJkE2gntwQ=;
 b=TGmxbC+KvqZyftZ5Bpd5wG27HpSFDfvjsFqHjd0GSsYKSHK8l7gSV5kbFojH6cvFgrSdEEJ0G13NQUzoQugXczcEN3QmUyjPfwptn7t2fvjxphPPA0gnbDONofF6ufJQ/0MmvMm+hQWzmCypRO90X/amvBrZrfoEsKbknFgjNMGo5Ro6uqWycudY/ZCkf3YTM7T80wxDHMDFKZ4v/LwBlYKZCo2PSi10j4Gl71lzOCDttJdEocJC+7hRvpqkxhLNXzfLEYRRP9SJfWsaZFMRK6XiZ1uzK1bDkNkJpmWS9CBpm5D+D92KaUC19N8QXQ+LsYxGFhTE8xz2l7aS17RIwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by LV3PR11MB8508.namprd11.prod.outlook.com (2603:10b6:408:1b4::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.24; Mon, 18 Sep
 2023 07:17:00 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::a64d:9793:1235:dd90]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::a64d:9793:1235:dd90%7]) with mapi id 15.20.6792.024; Mon, 18 Sep 2023
 07:17:00 +0000
Message-ID: <7d783993-1ef5-e1ed-591c-c87a9d879782@intel.com>
Date:   Mon, 18 Sep 2023 15:16:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v6 01/25] x86/fpu/xstate: Manually check and add
 XFEATURE_CET_USER xstate bit
To:     "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "peterz@infradead.org" <peterz@infradead.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "john.allen@amd.com" <john.allen@amd.com>
References: <20230914063325.85503-1-weijiang.yang@intel.com>
 <20230914063325.85503-2-weijiang.yang@intel.com>
 <868ea527d82f8b9ab7360663db0ef42e6900dc87.camel@intel.com>
 <8307c089-cff5-db41-5248-7e0f2801143f@intel.com>
 <c91f6e5885b8d052b0a1d96d0ccc5a479d9f2b69.camel@intel.com>
Content-Language: en-US
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <c91f6e5885b8d052b0a1d96d0ccc5a479d9f2b69.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SGBP274CA0015.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::27)
 To PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|LV3PR11MB8508:EE_
X-MS-Office365-Filtering-Correlation-Id: f37c4eaf-a4bf-4545-95aa-08dbb8173ff7
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: atAVCWWRfRHhHohz3By+HXzhopMrNaZg0yn8fagsHLQ8rB8IP7G2YGZQT68Dgak4Uqfmjc+WuTWy9uq62LXv2z8dyIQehxuxphONiHHx3X4rCKeC8Qtnebj3J7xVZNWGNSMjAp7MM7FDD9ddla0RcJUl0aIlyh1bEhaohxChkEYMOuRaAVKDPpfl7RasE/fmPQHm5mrxOout/rdSLpXn35jS5/P0Sgh8cHRGPBPAKvfoj0gK0fdWC5kCFYfTG6R8YYu65UYVSiN9JFrvggXWyjFdgpZk+m7VyZA5f7qdgWYUkbpKAdy8rx+lxzhf8WD2yeKS5UEivsRBjl77mW4Zzq+FkaoFjfSz3tMoOf3Io2/LklLXxTZ9UQmIfIWoyJxZ0OyiUU37+y8J34UpQ1PochA07u+6YyYPoxflfK8n9KgJ7veXJ0yhpmIum6b4SuMtONWVHVUC0WoIO6CmYtuHDRQ2JR2ZmYoy/BrtrF+KJL9iy8iTTW4Z28JZCDDCSdmfIXEaL6THEQc9AiWoVTG8tCdQMH6jn1xhJZLebmu9fdD+vIeHj+5+BC4x1m7671qNLoU9yk2OC0024YxmGwY0tYfSJxeHpSlICUuOPMu3N1nDLq3ctiy3z1ocWEa0U92w5Xox6BDHs8VkjjXfK5R8gQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(39860400002)(396003)(366004)(376002)(346002)(186009)(451199024)(1800799009)(54906003)(66556008)(36756003)(31686004)(26005)(2616005)(2906002)(82960400001)(4744005)(38100700002)(5660300002)(31696002)(86362001)(8936002)(8676002)(4326008)(316002)(41300700001)(66946007)(66476007)(478600001)(110136005)(53546011)(6486002)(6666004)(6506007)(6512007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SEVjWExTNzZqVFlrVnRwd2k3dW9CZVk4OTBWSy82bE9SVlhiQTFjYWEwREhn?=
 =?utf-8?B?VmpickhRTForSWVRa1NlelJqbVMvWlo2V0tyTHlKMENRNW02eG1sakwyaWti?=
 =?utf-8?B?M0hybWdLSjNRVFFwMVZlQmJMMndORG4wdEVpRVFmN2JNMlZPbXRxS0lZRG9H?=
 =?utf-8?B?blJxQVBSUGkrRkpqN3lxVDRjMDh3N0ljSFdqUXUraUs0N0twZURUMFJtcUp4?=
 =?utf-8?B?ZGh2VFgxc3lJcmlSRHB4eDNXUWVzMEgxemRlUTBlZDE4YkRhNmFrODZnVlpt?=
 =?utf-8?B?UVNXemxZTTdVNlVRakpIOGUrbkJhK0o2dmNyTkpYM0RXbU5kaGZpRGJDTlNT?=
 =?utf-8?B?ZkJMSU5wWEhtV3pheHpncStZVHQzMEJhZWlZeWprZ3EvcFpGQWdIbnZvK1pt?=
 =?utf-8?B?VHQxdGFpL3hYWFpwaHI3LzVJVnYwUlFaVEVCendkVUFROFdESkt3VnM4KzFI?=
 =?utf-8?B?ZWRuK042UGdiemh2VFQ0U2pKSVlGSUFRSUp3Q1hWb3FQNFNXOE4wMDRhdS9v?=
 =?utf-8?B?N2VET3hsMmYzeCtLdVFXMEJCRTk4TVFuSEE0VFJNbzFJdkJCaDNHd0JONDFY?=
 =?utf-8?B?WmFyaVhEdXNpcXZTRDQrb1BYM1NmanJWTVZVOE5waENOcEZEOGdoc3VPaEFk?=
 =?utf-8?B?TzlHRE5pclNMTHUwdCtLQ2ZqYlliS1BDaVNCOC9xUkkrUXprdXpVMVRvdFpD?=
 =?utf-8?B?NEhmM2lTMkthRXdrbExUaWVqQ0ZOenMyU0dnZFpJTlR6c2I0N2lVcWo3cmZF?=
 =?utf-8?B?OUlMTUdpdFBJbTQ5M2VwazI0Mk1KUG9VeElkV082ZFo3T3JLaG5BR2NSRVVW?=
 =?utf-8?B?aTd5ODJlQk0vY2RITjRhVS9oN3hKYUJHQ29Xcm1VZS8va0hBa3VYNzFrL3ky?=
 =?utf-8?B?SWdyT3BGOUYwd0trM3daMklrek41V0lRTy91a0Jsa1JOL21VbkZnVlhBSlBj?=
 =?utf-8?B?Y1ZaOWtPOFRFRkc2SHhaSDl4R2ZSZ1luNThndnlNWExiaHlCaTJSN2M3UmJj?=
 =?utf-8?B?VzFITmJ3aDAycURidURsenU0M256TW8zL2lsNmNtSnFPYnk5S1ZYZzFwb1Zv?=
 =?utf-8?B?cUp5YUZQU0pLT29SbkVyakFLSkVjWndJaGZFSFlOVENBbU5HckxFSThnK0Np?=
 =?utf-8?B?ZzlKYXFSdDVpOEVOUEJTOTN3d3lJS0swUzFXWGpUNE4yOEU3a1VsSEExZFBI?=
 =?utf-8?B?MjVzd1U2eXBlNmo0Yktnck45Y0l3TVdjdlpTUGtabFBSNStxOXEwRWZuSzZI?=
 =?utf-8?B?dHZwblB0L3F1TTd2MUxzLzMveHFvOE9Uc29TRnRzWDVVdytNMksrTWdoTGVX?=
 =?utf-8?B?Z01oS3FyMTJzRnBpZkpBS05VTER2d0VJT3VBY29RTVFCODB4L0MxdHZXQTR1?=
 =?utf-8?B?WUgrNVZ2bHlRdUtqTTVwekRQUTBZcG5PZjVYNXVrajJaQUsyMGt6QmxxenVW?=
 =?utf-8?B?UEpGUHhKY3QwcDg0N0hYSzFhODNFejBNay9wTnpod1FoWnNsdHBGVnY3R21U?=
 =?utf-8?B?UnAvUFFkL3JMNVBNTXN4ZFVjNGttRk5xai9JTFZmamx3N3VEbXZ5ZjVxK3Fl?=
 =?utf-8?B?ZWFGSzhnQlFyMnhuV3Ntb3Z3QitQMlpvMEdOUjBWTUFTOS9MY3gzdVhwdm13?=
 =?utf-8?B?V0drQ3N3UUFxNytTdG1KOEN5b1dwMHJGbHVJZnBRUDBtRi93ZFV5cnNOVzIy?=
 =?utf-8?B?ZWMvWGpTZmhYNGE4SWJxMkoyUHQ4QzJRZldNRFB6ZVdxVWFKYUFIazJKa25T?=
 =?utf-8?B?VGJKOGRNcWNnT3llMWIxUkovM3o4d3c3b0REd09FRWRRdkoweHZjN2FQWnIv?=
 =?utf-8?B?OE1OcUZBd2R1TVpSdGJycTkzU1hSOVA3d0FvUzNnUnRIVy84akRDWHNubDlY?=
 =?utf-8?B?VVV0bVpGQmtPZ2YxcTNwYzFsUjdQek43LzNjZHRSVVNDUmtUWUwzWktGSldY?=
 =?utf-8?B?ZzBkc3B3N2lrTWNmQTFQVzREbk5Ba3grWE1hNzFXTjQ1UUFMOWRrV1VLa1JC?=
 =?utf-8?B?MXNsNHNTWm4wNklzaE9UTEpUWU9VQWdhMmtVa0dQaVJ3WHFNa2EvMk94aEdy?=
 =?utf-8?B?bTcwaVNDUkRwM2lrR243MHg0Wm1JeC9VTXpRMm1VbEFXQjBrRnNpcHZvV0Nj?=
 =?utf-8?B?WFVwejRNWGQ4c2szdndCYlVsSE1ubUlqc1Q4WHlLRHJRL3FBSlF1djVUQTd1?=
 =?utf-8?B?L3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f37c4eaf-a4bf-4545-95aa-08dbb8173ff7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2023 07:17:00.2046
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VU6+ZevLyLJDToWuVzvUOLwN8AkTYAMYYqkDPDKDA43s/1WqnLFWhueEsjsk0qJlJPpLKWtJl1FM4j1oS/YaEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8508
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/16/2023 12:35 AM, Edgecombe, Rick P wrote:
> On Fri, 2023-09-15 at 10:32 +0800, Yang, Weijiang wrote:
>>> Also, this doesn't discuss the real main reason for this patch, and
>>> that is that KVM will soon use the xfeature for user ibt, and so
>>> there
>>> will now be a reason to have XFEATURE_CET_USER depend on IBT.
>> This is one justification for Linux OS, another reason is there's
>> non-Linux
>> OS which is using the user IBT feature.  I should make the reasons
>> clearer
>> in changelog, thanks for pointing it out!
> The point I was trying to make was today (before this series) nothing
> on the system can use user IBT. Not the host, and not in any guest
> because KVM doesn't support it. So the added xfeature dependency on IBT
> was not previously needed. It is being added only for KVM CET support
> (which, yes, may run on guests with non-standard CPUID).

Agree, I'll highlight this in changelog, thanks!


