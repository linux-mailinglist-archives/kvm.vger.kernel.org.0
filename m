Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 904907A1624
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 08:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232310AbjIOGbL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 02:31:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232148AbjIOGbK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 02:31:10 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0530270B;
        Thu, 14 Sep 2023 23:30:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694759448; x=1726295448;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=W4qX/GgQLMMxSkE/N3zd4LIHSaynI88NR87SL18Cz5s=;
  b=mJ+fnk6dziA8FL2l4wk7/BgPIVoyzjMt1gu7bBJh8IA3T2DkIHJWSmUI
   utHS4SzJOna2Yj20IUMZnlojuLwZV1a3lbxSMwOAJDE86rNvtpnAIm/jZ
   3e2JjkX4pzwr+jbURO6LF2LDBFe903ejyKO6fNhTvQ6CHDdRhctseB+1q
   isQiUdxGlGKyyLd4GvYIXK5v+U9pFVKh/nhXLcqnrtBvsWhIUMeJFb9iZ
   Xy6Ehf7MitxSQG9fUAtjakIcVgk+wffahmeOm6RajBfEJc6IPpkimJAkc
   nYIbBLjaTogrPlifp0d/b6OZqyRVo7Qxsz1cq3dVUKrQucR+J2RDUldnr
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10833"; a="410113723"
X-IronPort-AV: E=Sophos;i="6.02,148,1688454000"; 
   d="scan'208";a="410113723"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 23:30:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10833"; a="738213352"
X-IronPort-AV: E=Sophos;i="6.02,148,1688454000"; 
   d="scan'208";a="738213352"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Sep 2023 23:30:30 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Thu, 14 Sep 2023 23:30:29 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Thu, 14 Sep 2023 23:30:29 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.171)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Thu, 14 Sep 2023 23:30:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b8nLl1Nz4FtawL8+m+4ut3cXlSI4dnukrVDchoHgA7/j01rz7Dt2F9lraaDG3ZBH15vlRhvo2UgG6DOkz8+HvXBZQTmZ89HXGA/Rg8O23jrQcuZl7NLvi360xFyQcsMrPt4AFZs4FBCR4OoUJXXMJn8Q8fdcoN5iMT2fWNJ8a9IeO8Vr6+S3l/iS6VQ5qN9Lp0XJNRud6wNYfA4/Tg0bqnc3wL8OoCWBjTnGo859laPWAt/ejnC8t8rC879ifbX1C4t+iGRXWEHPb8sZNCdG9TYvGw9mJl9C1j63fNofwwtl3AdGSxxKy9G67cnPtlgefO5AqQL8wvt9V1wGMhy9Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ybpFc26sJGqHi0M99PlQ+iGk3gYZQ1xqdge920zP5zk=;
 b=Akkqrjnnl8KSnL2sswGKaWqBWskAKOVTXEzQaINUdYkaulttmVSO2UrsRamKQlToVtPG60DrzL4dpe+kN9FOEBl/okNRpU8ez1vpS5kuDGdZxkAm4NNqUMSpMETRO83H6c1iBwy/Ofj5CpLA1WkpcXFyST7NaO4aWHweFmFZoGjyYHuT2c6ISc/RXxRIHWWHNRXZ3sjX9cVSveF2mSJHlsSJsW/W/gXOvJReWB+EjphFCV6lUSnCx6e2QPzt+CFz5rwucD0Dq1jdp4/dji6Vn4CL5sEZHeqAtRDlBJYNhNTsQMNba1VpJua9AAjutGJzJmq1KMYNY4xedKs6uN4ICQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by CY8PR11MB6939.namprd11.prod.outlook.com (2603:10b6:930:59::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.20; Fri, 15 Sep
 2023 06:30:22 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::a64d:9793:1235:dd90]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::a64d:9793:1235:dd90%7]) with mapi id 15.20.6792.021; Fri, 15 Sep 2023
 06:30:22 +0000
Message-ID: <c72f3ef9-ee82-84c8-c802-c9593a1dd5d1@intel.com>
Date:   Fri, 15 Sep 2023 14:30:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Subject: Re: [PATCH v6 03/25] x86/fpu/xstate: Add CET supervisor mode state
 support
Content-Language: en-US
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
 <20230914063325.85503-4-weijiang.yang@intel.com>
 <35393ed30962125fd6ce1f91f71595d1111413ec.camel@intel.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <35393ed30962125fd6ce1f91f71595d1111413ec.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR01CA0040.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::14) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|CY8PR11MB6939:EE_
X-MS-Office365-Filtering-Correlation-Id: 633d2faa-ee46-49a1-62a7-08dbb5b53d25
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Lc84i1NT0Hykpv3lZ27BkxvvqOlV51+JPs5CgzC8hVnoZnULIln4J3gGT7x1tCIGbAjHVh7TyiVxBlOUzk3iTfo1KZoc26lHuNWcixC9IJd9Nz74PhfzEdrk40fHrAJGRfmrUvK/dMIZoN6ekugGJ0zqp98H0Z6036bNDKck+2WMmQM6AlX8IwMZrmbXZP13OySe6Pj5SC0FXyjrq+gHJgpiXqkcmsJaeOOaZeqQPbaahs+pU23lD8CkbdP6tCDvPfkknfdezi5BVoj3KAXvH23HNG9HeMlnqv45L6qBDeVbJczFuSooI71L+surra537ueuPtBWzoJJseexYVbCqgmRi3vvR5glElhLoUQ1QHu2w8qepYgXHMDvNuW3G7eB6z8aLUPuQzhI74D2BAXBZk52K0pxAgEOhUjBJt+V059ck0z1395ycl/GEecASPxRyxWQtLIpThQOyRHIQiVdKnz7FNZbTRdImu9kLfpo5Ut89o1d8IeheDRBITxDBlKzJSQep3N0AHxecrCizWZ1NAh2OhgBECdiJGG20QUnC3tHJiDM0aY4t0lUdQ3xVeFg0dSN0uuiXcfjJtavqS+atEnyBVn6xta9o6NUK/iLZkcXb53i/Dr0qecztb4lD5/tP4HLYUNYv5Tr5H9j+URETA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39860400002)(346002)(376002)(396003)(136003)(186009)(1800799009)(451199024)(2906002)(86362001)(53546011)(31696002)(6512007)(966005)(26005)(2616005)(478600001)(36756003)(6486002)(6666004)(6506007)(83380400001)(38100700002)(82960400001)(41300700001)(31686004)(8936002)(4326008)(8676002)(5660300002)(66556008)(66476007)(54906003)(66946007)(316002)(110136005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TDlhUXNOd2tJUW5VRUVINWQvZHJGSGNWOURZVVljWWIrazFrVm5DSGZnTzdy?=
 =?utf-8?B?UzJIQWNFWVB2VXdMd2tISDVlQ2V5czBnbkxIbjJjZTJlbWlUWHRXak1NZ24z?=
 =?utf-8?B?WlErQmZpc0xob1pjcjN4czhqTmFIcHlrL3NyTVdWRzZwWTNoRUhLKzJZQklJ?=
 =?utf-8?B?cWV1ckhqRXN4RUpPbE0rUEtHWlJYSnNWL3UzVGVOK1pxY0MvYkFmaExrS3dW?=
 =?utf-8?B?aXU0Q0NmK3pKMzgvdVkvdFgrYlk0UmowMGlnTW5nTEluRmN6Qkw3WlFNQkRJ?=
 =?utf-8?B?OXR2Q1ZncWhqZVErZ01yWDRkR0k5YmxJWjhoVG5reTJpNnRHNVJ0UGd6RGxH?=
 =?utf-8?B?MWFWZFNVaHA4TGs5VlVmYSs3b3lsYUpCMlpJdXhOWHJRZjNXMXF2WllIQnB3?=
 =?utf-8?B?Z2VZNTVaaXdORE5tOVNDQm5lWTZPNXh3Ym94RlQxYlJKbnN1WUdnQXpLOTZx?=
 =?utf-8?B?bXZPYmMyMTZmemxFRVJodE9BNnlZb2ovaEFMVnZMdTJMMmtXL0xuQ3ZjZVk2?=
 =?utf-8?B?aWp6NWZLQWRsVXEwL2hHbnJjN3ZIYVl5MHBSQUpUTHZZOFVpTjQ5Zm5ZYmpY?=
 =?utf-8?B?RlFRQ2Q4QWtMZllaL3NYR3JKWDVGd3FCZCthTUtwZkZGN3BseXV4dTU0dytm?=
 =?utf-8?B?eUVjYkhJM1JLeERIbUNOdktuN1l4OSs0cTJlZHJnRlBNN1FqOFh0MVdLWGZK?=
 =?utf-8?B?MjJqT1drMWNOMXZnOHlGVklIQmdMSFlYSUZTdS9PSW1LVkIwWXhEL0c4ejVq?=
 =?utf-8?B?QWt2ZjVDSnMzOGhZRTBuVVJTanBXSFRlMUd5YzVLbXptQ3JhNDJBWmhZV0ti?=
 =?utf-8?B?OEU4WE9kUy9tZXNZQ2hkaVQzLzM4aDdISGdUWTF2ejhsM080UXhraVRCdXhR?=
 =?utf-8?B?WjMwMVlrUUsrYmRscTlGS3FOT2s1UmZTb0J2dGZSVHYwZjlkRHpsd0hvQzdO?=
 =?utf-8?B?dThwZFF4MGNkN3c4RWpiaUR1ay9ubzB1bU9qTjA3ZUNJOXkrVGkrS0NRWkdQ?=
 =?utf-8?B?NHZkWDl3ZWdFVUF0bmtJc1lqTnF6QnR2VGNxbTBMT2s3dXVXVTFEQ2RNWWFz?=
 =?utf-8?B?Qml3SUdKWWpzbUhoUHJoUWlBaHNJVTFZUTYzTE1JeXVPVjZENzlBdjhuZUlr?=
 =?utf-8?B?UE16Y3dldEJiK3ZEYlkzWDJodTVHQ25sSTFzMmdwZlhwdGNOZEE0dWdsc0Fn?=
 =?utf-8?B?eHM0SG5yc1M3U05ZZkZRS09RY0J1L1lCQzUxNkNnQUFUUnVQR0lwSHNXTmZi?=
 =?utf-8?B?S25IeUVwajJmemFaeHhjYm4ycWp3M2pNakIvVDRHUUFNa0VLbWNYVC8wR1FU?=
 =?utf-8?B?b1pjOTFTcFUxTEFWeFh0dk1yVmRZRDFCTjZDMXhGMnZmZG9qNVEyaDI1Zk85?=
 =?utf-8?B?SmxabE1MNjFuNzYvY0V3L2dSdzhUSE1YdzhVTFU3ZXFMTnJXUHVrdzhsUnp2?=
 =?utf-8?B?d2NqUTRSUi82ejR0MHViQXFSdnA1b004M0JTMDBVeC93ZlQwcmZlY0hZaXZI?=
 =?utf-8?B?UXd6ZUNmS1Y0c2xMTmwxOWxmUHZmWVo3dUpvWVVQdUV4MitaYWpLVmlEUWxW?=
 =?utf-8?B?UklLempSUCtKRnlMTWhtdDN6UytwZG96cmRWKytpYlFUUTk0VTV1ZU8wMGtn?=
 =?utf-8?B?UkJDYTdCMER6TzQzUkovVVJOQnhQNTVycisvK2VsSzZxcm13V0ZuV21rUkU1?=
 =?utf-8?B?WDROQTFMdCtTOElRRHhvMDZXL0NHd3g5UHRTaVpQZUhPckFqa0xMTnJtbmJS?=
 =?utf-8?B?c2tDL1duQ25qbnNUcXg3aHlTZ25XVmptZ3JZbjBQLzErdlpnNEFZNkNBV1Bm?=
 =?utf-8?B?WUtXbkNacFc2MU55SHkveXdXYUliT3EwZmtVVFdYU3dQYUhHclBuSE5uUWVV?=
 =?utf-8?B?RDdPZUdDejV0dWlxUEJVVW1GUVZiTjdWek9MOEpyT0xNYkNYTHljelhIa1Nq?=
 =?utf-8?B?b2ZLTFhrTUV2UFYwYkxsd2xmNHo5WXJtYnBLSUplSHBjZmorK3p6WDNPeUZl?=
 =?utf-8?B?TWJQamtEWkt5cTNqb2VnVm4rcDNFUlRCWlh5TWlZNlBERmYzKzZoVFhMa3d1?=
 =?utf-8?B?N2txd0I5VXhUTm1ieXFHZ1FCTW8ydlN0U1hnT21ZMnlFcHdTY0FMUXBkQ1lG?=
 =?utf-8?B?VnVSd1RtZFRmN2MxWGlZRHcrY3lsR2pnSzZacjVrdDBET2dBajhmN0xPK0Nh?=
 =?utf-8?B?cHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 633d2faa-ee46-49a1-62a7-08dbb5b53d25
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2023 06:30:22.4082
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wkrpyl4emC/As/IAUev8TbeeScSvfvwNGLKPxVG6SFSLMp7bw6vLzhtBDnmvG+w4wXsbQIsl+ojv65Mm2DfERw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB6939
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

On 9/15/2023 8:06 AM, Edgecombe, Rick P wrote:
> On Thu, 2023-09-14 at 02:33 -0400, Yang Weijiang wrote:
>> Add supervisor mode state support within FPU xstate management
>> framework.
>> Although supervisor shadow stack is not enabled/used today in
>> kernel,KVM
>           ^ Nit: needs a space
>> requires the support because when KVM advertises shadow stack feature
>> to
>> guest, architechturally it claims the support for both user and
>           ^ Spelling: "architecturally"

Thank you!!

>> supervisor
>> modes for Linux and non-Linux guest OSes.
>>
>> With the xstate support, guest supervisor mode shadow stack state can
>> be
>> properly saved/restored when 1) guest/host FPU context is swapped
>> 2) vCPU
>> thread is sched out/in.
> (2) is a little bit confusing, because the lazy FPU stuff won't always
> save/restore while scheduling.

It's true for normal thread, but for vCPU thread, it's a bit different, on the path to
vm-entry, after host/guest fpu states swapped, preemption is not disabled and
vCPU thread could be sched out/in, in this case,  guest FPU states will  be saved/
restored because TIF_NEED_FPU_LOAD is always cleared after swap.

> But trying to explain the details in
> this commit log is probably unnecessary. Maybe something like?
>
>     2) At the proper times while other tasks are scheduled

I just want to justify that enabling of supervisor xstate is necessary for guest.
Maybe I need to reword a bit :-)

> I think also a key part of this is that XFEATURE_CET_KERNEL is not
> *all* of the "guest supervisor mode shadow stack state", at least with
> respect to the MSRs. It might be worth calling that out a little more
> loudly.

OK, I will call it out that supervisor mode shadow stack state also includes IA32_S_CET msr.

>> The alternative is to enable it in KVM domain, but KVM maintainers
>> NAKed
>> the solution. The external discussion can be found at [*], it ended
>> up
>> with adding the support in kernel instead of KVM domain.
>>
>> Note, in KVM case, guest CET supervisor state i.e.,
>> IA32_PL{0,1,2}_MSRs,
>> are preserved after VM-Exit until host/guest fpstates are swapped,
>> but
>> since host supervisor shadow stack is disabled, the preserved MSRs
>> won't
>> hurt host.
> It might beg the question of if this solution will need to be redone by
> some future Linux supervisor shadow stack effort. I *think* the answer
> is no.

AFAICT KVM needs to be modified if host shadow stack is implemented, at least
guest/host CET supervisor MSRs should be swapped at the earliest time after
vm-exit so that host won't misbehavior on *guest*  MSR contents.

> Most of the xsave managed features are restored before returning to
> userspace because they would have userspace effect. But
> XFEATURE_CET_KERNEL is different. It only effects the kernel. But the
> IA32_PL{0,1,2}_MSRs are used when transitioning to those rings. So for
> Linux they would get used when transitioning back from userspace. In
> order for it to be used when control transfers back *from* userspace,
> it needs to be restored before returning *to* userspace. So despite
> being needed only for the kernel, and having no effect on userspace, it
> might need to be swapped/restored at the same time as the rest of the
> FPU state that only affects userspace.

You're right, for enabling of supervisor mode shadow stack, we need to take
it carefully whenever ring/stack is switching. But we still have time to figure out
the points.

Thanks a lot for bring up such kind of thinking!

> Probably supervisor shadow stack for Linux needs much more analysis,
> but trying to leave some breadcrumbs on the thinking from internal
> reviews. I don't know if it might be good to include some of this
> reasoning in the commit log. It's a bit hand wavy.

IMO, we have put much assumption on the fact that CET supervisor shadow stack is not
enabled in kernel and this patch itself is straightforward and simple, it's just a small
brick for enabling supervisor shadow stack, we would revisit whether something is an
issue based on how SSS is implemented in kernel. So let's not add such kind of reasoning :-)

Thank you for the enlightenment!
>> [*]:
>> https://lore.kernel.org/all/806e26c2-8d21-9cc9-a0b7-7787dd231729@intel.com/
>>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> Otherwise, the code looked good to me.

