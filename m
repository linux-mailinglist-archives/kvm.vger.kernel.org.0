Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D40E7445F5
	for <lists+kvm@lfdr.de>; Sat,  1 Jul 2023 03:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbjGAB7J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 21:59:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjGAB7H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 21:59:07 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36E0B420E;
        Fri, 30 Jun 2023 18:59:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688176747; x=1719712747;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kadwobPbntv7bqEGAJAWmbPreUMwjC7qneUEnCmNsyQ=;
  b=T3nD8HY4QTExSuTwe5OsLIDPWkL8Td5VXrHwfEa3QDHxCBprsamnhX2S
   ptfLfXHyujJDyCI/QpVe/hWuDJXG3mqWOwPGOmT0ONp7ezx+5G+4FYFGO
   D+ybZUtkRNm1DMB5+YXwFQPPlKCd5Q5K1/W4jN2FrEvsQ/+NQm3Kwav8/
   OZ3Lw5tKpXpIgb9qDO6mMsB9FlzvYofvV52HnKukTBlOqLSdW9wtwMrTw
   w2QWrkTgTfjBngk/L2vuig7kKDt55jRU0sm0V9ZrGxaw0Z2r8zSAoD0aH
   LH/25faDJhmmC6lS0xF4hkV4NOxnfnXXVUh/urt1jj+6PhIDQ3CjH87lK
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10757"; a="342119785"
X-IronPort-AV: E=Sophos;i="6.01,172,1684825200"; 
   d="scan'208";a="342119785"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2023 18:59:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10757"; a="964587391"
X-IronPort-AV: E=Sophos;i="6.01,172,1684825200"; 
   d="scan'208";a="964587391"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga006.fm.intel.com with ESMTP; 30 Jun 2023 18:59:06 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 30 Jun 2023 18:59:06 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27 via Frontend Transport; Fri, 30 Jun 2023 18:59:06 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.27; Fri, 30 Jun 2023 18:59:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LPeBEK6OrYF/aB2oSPRyWV2XIbuGiS163qKfXhJIh6WruCV5HG1fU9GbXDOsw5NbN7cpr5VRZwPcTlvYVLQFSZs03TgCXmjYmlviHFrU+Mz975xUM9a1x4o0vhKsSYhVN7U131mlg9uA5Ml+q5VY3kKGUzf2WqqEJjfb7BE+eZAIQaXcMOuyZqm0LkwK/GfG0Xjj90cBTdPjiR6H25tuNJXTgFMlYokfo3+YP63mcevS4YJUlk5EpMwnxm2JurT843qBPGFKl1p6s7YipNyiGyi2rUFE6gDWBQZvJwNHJIy6xFSP/MAnlvUYXDDCRpyTgm0prCU7zO8uXdMVImezOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=doLYAUw5JsT6W3d806pztx4iLn/V2KIYBiYFvtqp11Q=;
 b=VP5jyh26ImYUEO6sHuhWyaSy/6EUM5zBxDoCplb63rVMp8J6b9TJTpJy9KgaKruWk7ft5Nk1ojpU02nV0t+wFBuF4cYNAhtVCoAqzG/nkx+xGE3EGk7UkCxo0/ME60QCxFiKY+welz4I2155RSH/4Ui1E0l8xw9YK7VB2OEOikLReiz5tKqbM77t+ThPQIO9ueEdKrlHTK4as6O+GTmDW3uV4T0TI+Ynwa98ssFWRHTCpptwnMDfyEaKbVlf+ujOwqaLYJIvzuYYb4VpmqiKPUrX2h5oRBSIcyS6qwvUBIUo8AeaO0twbCu34e9szx9FJnAoGC1/2CAiXBOVhzaQOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by BL1PR11MB5955.namprd11.prod.outlook.com (2603:10b6:208:386::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.26; Sat, 1 Jul
 2023 01:59:02 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4707:8818:a403:f7a9]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4707:8818:a403:f7a9%6]) with mapi id 15.20.6544.024; Sat, 1 Jul 2023
 01:59:02 +0000
Message-ID: <8ae1bf2e-48d1-4c9b-4dc3-398c8e199247@intel.com>
Date:   Sat, 1 Jul 2023 09:58:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v3 10/21] KVM:x86: Add #CP support in guest exception
 classification
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Gil Neiger <gil.neiger@intel.com>
CC:     Chao Gao <chao.gao@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "rppt@kernel.org" <rppt@kernel.org>,
        "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
        Rick P Edgecombe <rick.p.edgecombe@intel.com>,
        "john.allen@amd.com" <john.allen@amd.com>
References: <20230511040857.6094-11-weijiang.yang@intel.com>
 <ZH73kDx6VCaBFiyh@chao-email>
 <21568052-eb0f-a8d6-5225-3b422e9470e9@intel.com>
 <ZIulniryqlj0hLnt@google.com>
 <dfdf6d93-a68c-bb07-e59e-8d888dd6ebb6@intel.com>
 <ZIywqx6xTAMFyDPT@google.com>
 <0a98683f-3e60-1f1b-55df-f2a781929fdf@intel.com>
 <ZJ6uKZToMPfwoXW6@chao-email>
 <8dec8b09-2568-a664-e51d-e6ff9f49e7de@intel.com>
 <CO1PR11MB5107FBC68DBA6877E390A633912AA@CO1PR11MB5107.namprd11.prod.outlook.com>
 <ZJ7xjE0qMjpYIiB/@google.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZJ7xjE0qMjpYIiB/@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG3P274CA0001.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::13)
 To PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|BL1PR11MB5955:EE_
X-MS-Office365-Filtering-Correlation-Id: a0a64db4-bf7b-48ff-b95f-08db79d6bdd0
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GIEMfCCRfySLWTtqAUllj9HPr+VDFn6sZIhKj05OXOzZw9eXnLV/dr8vCdDEOY6CUHeiWuwlai310YzCjTUu695Anrw35UWTVy0PTujh2nk9FxR3T7En2gE/FiPVdwcPyxG7u7IdD4Ouf2CgGAwRjmPgDYoxpXO+h+Gb7sr2bGYf9ey0VM4532ogQZYqekzrOF4vt8+a32R4DTUTmn2yRuh/EkMzPSVHXwmuA9yJLMj0tLz7yD5avu73lN7/ZR9jwrgEDR4tKuHgv92vYJrwZPvN7Y5z6jQrkgY/OVaSbrTjr7rmOd1pOucErDrKEdjB7+S9vKk1n76xMrmH/Q/sY9P2KRXLXDG4+Pi5vMD1mjDeZg68EEBoNOW+KzP8fdUFNgIUHBthcAOW510zH+zY3ey7BBbzfNr0UutYpI4Ff8XLZNH5lx3JkLrsJGzQ7CbCAwLvblWg4dAZMVgnptxcIzPNpjEqYC39snre7pfUO8X0LW9Vi1ftez+ahDHQvrt9WujmJoRPQeTJRVd5cV6A0Sc0fs7iQyT+x5rPVuQW7xhdN6zD9C4Jae+l2vdZKqt9JCsKZOCxFrcvfip5KcPIlStRhPRODQ7/uqFggaD4uSBS8WvQ4xaFItUFnS0HDhNGaguUJUo02ZpdeDyGLysUpg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(39860400002)(366004)(396003)(136003)(451199021)(53546011)(6666004)(4744005)(6486002)(54906003)(110136005)(83380400001)(6506007)(2906002)(6512007)(2616005)(26005)(186003)(478600001)(5660300002)(36756003)(316002)(4326008)(31696002)(6636002)(82960400001)(66946007)(38100700002)(8936002)(41300700001)(66556008)(86362001)(66476007)(8676002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RjA1dG9EZGVURzRubVl4TzZaNzRsU3FCclowQVRydDRkWVV1cXhCUkFqUlcw?=
 =?utf-8?B?ZHNIWmdod1paRnpVWVNWUnJEOVRoQjVmQ3IyRXZ3bnMvVzUzcEhOTVFkU3R3?=
 =?utf-8?B?NGRFdUtOVDgzeTY3UHRnNy9jV2FvUHhQVmUwdnlJenhlR2FmS1JhY3V6aklu?=
 =?utf-8?B?bnpXbVhpb29uU0hETlVZMVdFdk03VHNsbWFDNDAydHU3U1JqbCtWN1dkWVNy?=
 =?utf-8?B?NURZYjhYV3R5dHRSeE41eHE2OVA4bFV4aDFQRlc1U1VjUi9UY2Z2cGpWZ2F0?=
 =?utf-8?B?eC9xUXRxc2M1anQ5ZE5BdEFuNCsvdGw4VW1LclpwcmVHQUt3VFVRUytTYVcy?=
 =?utf-8?B?MEZEZXBOZWFsVGZGeExoTlg1d2MxM3FSaUhSeWpTTkxablROOE1XR3ExbGtH?=
 =?utf-8?B?NndNQWNSTWhmSWREZm11V1V0ekF6YkRMUVFWK2ZaSHZ6MkpzMlRGc1NGZllF?=
 =?utf-8?B?M0trdm9IV0h3clB2ZHBZaFBiMFRLRGRzZFUybUQ5RXQ4SUM2dzhJUHdDV1hZ?=
 =?utf-8?B?S1ovbzgwWWxXelg0MWNPU2F1VFI1WWpCd21VdGVHckJvZ0FkR1NSMk9XOW5T?=
 =?utf-8?B?cmZKZnRzYmVjYTBvSXdBVGdVcmRhTVF5TnVRWXpVeDZWZzNaYnc4c3h3a3Ew?=
 =?utf-8?B?VDhxYUJOQWZxdVVQSGxIdmhCMG9Tb3ZIdUZQM25RTVhPNHYvR2tWNjhTcUJK?=
 =?utf-8?B?TUhxOE5KYTV4cncybzV5MW9zN3E5WEE5em9nd2RLMjJiV0FIenlKbXZsNXVu?=
 =?utf-8?B?NVB2VHpNSkQ1ejljQkl1U2hheEVCTldIQXNQaElXVVBpSnN3NDRKWld0TEZZ?=
 =?utf-8?B?T3pJTkk1dGZkeEU2UzFsWkw1eHhtdVliYzlqamNCRGVyOURodnB0Zm5OVExW?=
 =?utf-8?B?UFJOclFLczhSdVlzRktXNTJuZVhVK1ZkU2dOYkRKK09HbXZHVFpYY04wN05u?=
 =?utf-8?B?cE1FTURtdURiN2dZYVBxNVBXbEJyUU84Q1MzdVN0RE50UGJtazJLaTdORFZX?=
 =?utf-8?B?cnRNM3d4US9GV1hiS0x6bndITUNjRVc5bEZNS3NyY3FKWUZxM2ZZMUZXemZM?=
 =?utf-8?B?dDVnRndMaTQrUSt0T3VKNy9ialc3ZkZUSWl0SnpFMUtUbFVSUlBSQUVuVEdM?=
 =?utf-8?B?emc5Sm5iUnVwVFc3NkxFVGdFcGlVaU42bVFMTEdhNW1kNmgzRXgxYlk2VmJX?=
 =?utf-8?B?UzdjVkFWYitsMU96c1dNM0FOL2dmM2k3cE5LdzRYc2luRGxiU1VyYmtGN3Fk?=
 =?utf-8?B?bEJMRVFBNkI2dnB6NUw0YkZBNXZKSGNIMFF6aTA4MkJRVnN2VXFHQ3pRVStq?=
 =?utf-8?B?ZGhlT1dHMkEyWUh2TVVTNVVEbG8wQ2Yva1lsTlMyam9meXMvT3hYMGdCcjFZ?=
 =?utf-8?B?aUhVOUkyKzFiR2haSlpnZzcxZ2JrZHlwYTRkZUgyQ0phM3hCb3ZOeTJLeXdp?=
 =?utf-8?B?WGJRS3NkUHk2dDAzUGVQOWQ3VitNamQ0VDI2N1J5cHJlT1l1OURUd1ZaRGdP?=
 =?utf-8?B?L0RyelhQQXpVVHkra3I5alJGalNCczcxVWNWK0I0cmpwQ3ZBbzhHcUQ0L1pH?=
 =?utf-8?B?UGovdUdBNVN0aGhqNzN1VXp1RmJuZkZrb3lRQlRsM1lnMWtvUVFKaC8zOGJ0?=
 =?utf-8?B?b0tZcThXZ094enpSd3ppb0orazgyWHpzR3J2T1NyZi9tb2tUTGxTVzRvN3py?=
 =?utf-8?B?RmE3ZDkxeHd2ZFpxVFhnclcxSWk0VjJIclNOMEFnY0FKWTZEMXNLUlhyNzdU?=
 =?utf-8?B?dTlGMGNQckpVbS9ZZGozcGFleEdBUlFsUHY3QnhoUXBnNnRzTDI4ZENqdWZa?=
 =?utf-8?B?a2NhUVlyTjlFT281UDdOZUJUa00rYUNETXgvY1FGYmN6Q3BzSEhMWUk4WWpJ?=
 =?utf-8?B?akUvS3p1dTR6S2VTdXJDQ0hLODhaamUrSTQyVUdNMmhQdGNiZzEwOTNEV1FU?=
 =?utf-8?B?aDFaN3hkL1ZDS1hScjFBbFFTSFJYZWk3d0VGUzkrU1huUUp6VHNaenVIOU9D?=
 =?utf-8?B?YW5iL1htREZXYzYvWkdZQjh4T3B2TjlaUFJzMkhFelRhVTJHL0ZqRk50RUM2?=
 =?utf-8?B?cEtONFFHOElxL3Y0encvVXJlVDNMRDZocEllRVJ3aGU4MFhIYWViQkJ3NXlM?=
 =?utf-8?B?cWZ0RkhzYmJzbFY4aXIxTEd3UWNvVTJCTWliRVhGRWFnS2hZZkx6RFMxRStD?=
 =?utf-8?B?cHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a0a64db4-bf7b-48ff-b95f-08db79d6bdd0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2023 01:59:02.0739
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lEhJd/SuhNZvP/E8rPMnQPuQ+41wKTqe8VZpmGH1dR5GzK3WqH55zL1P/6ROb2+hzvbScd6PKpzkzhtS9SsVuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5955
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/30/2023 11:15 PM, Sean Christopherson wrote:
> On Fri, Jun 30, 2023, Gil Neiger wrote:
>> Intel will not produce any CPU with CET that does not enumerate IA32_VMX_BASIC[56] as 1.
>>
>> One can check that bit before injecting a #CP with error code, but it should
>> not be necessary if CET is enumerated.
>>
>> Of course, if the KVM may run as a guest of another VMM/hypervisor, it may be
>> that the virtual CPU in which KVM operates may enumerate CET but clear the
>> bit in IA32_VMX_BASIC.
> Yeah, I think KVM should be paranoid and expose CET to the guest if and only if
> IA32_VMX_BASIC[56] is 1.  That'll also help validate nested support, e.g. will
> make it more obvious if userspace+KVM provides a  "bad" model to L1.

OK, will do it, thanks you two!

