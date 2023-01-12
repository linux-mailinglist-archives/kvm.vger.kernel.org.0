Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB236684AA
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 21:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240806AbjALUzk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 15:55:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240481AbjALUx2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 15:53:28 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52E5A1096
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 12:32:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673555542; x=1705091542;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pceCsDKCiHixV5KKSfjqwSXpCoLDqltouSQ0dRV+TAM=;
  b=M3ENKoyMeJ5DjMt/Rrk0sTalD9kutcHd9sASSkphyQNRswg3N0bsYZUq
   8GzbDCToEfQ5aopR6WCWdC2CMml0zQvU8a2N1t46EVsnSA3JCRa62jLGk
   29KBOdbAC0AOqp94kXjcprS7QZajtErU3b0KBvxCZMAEv3rMt9dS8JfxC
   Qdwic4+auZlPdALdxmvYmtX2CGYVkAtvokOPNiulhPjmcWn5BiCnJDTl9
   1PWO029FLSf6NTFYTqeIXBtgz97zLUb3QkxpI4XAv+jBZUm/cQu/v+QE4
   1KbZ2yGt0oZgI6xjH5xJ2zcMKqHAVaA6YCc3u41yy3M0dFhSmuCWOKffX
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="304204767"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="304204767"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 12:32:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="659972070"
X-IronPort-AV: E=Sophos;i="5.97,211,1669104000"; 
   d="scan'208";a="659972070"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga007.fm.intel.com with ESMTP; 12 Jan 2023 12:32:20 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 12 Jan 2023 12:32:20 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 12 Jan 2023 12:32:20 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 12 Jan 2023 12:32:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jNdcKAWPmdXKEqa53ZIwT3KpDyskF26ePt3vbUewYg/vBwHiEfv3pIGa/YWwXgnhjCgNZxqgvfvv8WMV2Xu/QjkiT/sub3IVlm/Uw08EXJTz9fq/WLDm0JLkNyhSSGcvIeHIDzSDqNWB0hErNpUei8/WDuzTW9ww/3Dw0kjD1fqO2yM3DJUPH32u3LMZonxg1T1/I+cRKmIjAer5h+KAHw3EJjGVYRaAUSm4/g2DHUACkAhusdXY6NPZjjDOaOOGoy/quluwsUzw696SQg5GQiLaUHr72AmvHdWAPO3P61VZrL1lRPeg/iH94IoRDyuUt3DxOUh+qEJ7O/vSco2baA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sPd5bPghB1tHG8bUyoEyguhPnVjg71SFaHd+EHpuPMQ=;
 b=YwQ7Ez5nrZorChkJJxYxHkrtIU8iVp5Kxd0fT/jtiYrYdYBN2+LQfpjf7VvRVRquTybDMVks5+tjSd+1W2PGDfz7NEyykNPzHCY61wqYVVVc05yeRSghm/6O8KUo0bZ9ixxUPpFKYL08TYV9le5qAdJzWRBhpAH5rP277BfmjzlF/QpZWdB2XY+us27Bx3Is3aVMqnfB6BcPjtMHpYoztYCEJetwZX3XJphn6YgMm+8+kaZx3CJTM8CAzVawqIuDLa+aF9TczHJf6TD/PQSqzWExeAZI16vdTprSpQEg6AmYXujFFA9KjO3LX5W5JCOcIs/UHKZSSZJIKEuXkrd09g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4855.namprd11.prod.outlook.com (2603:10b6:510:41::12)
 by SA3PR11MB8002.namprd11.prod.outlook.com (2603:10b6:806:2f6::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Thu, 12 Jan
 2023 20:31:49 +0000
Received: from PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::debd:fb21:3868:b916]) by PH0PR11MB4855.namprd11.prod.outlook.com
 ([fe80::debd:fb21:3868:b916%8]) with mapi id 15.20.5986.018; Thu, 12 Jan 2023
 20:31:49 +0000
Message-ID: <6f22cb44-1a29-cb41-51e3-cbe532686c54@intel.com>
Date:   Thu, 12 Jan 2023 12:31:47 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 1/6] KVM: x86: Clear all supported MPX xfeatures if
 they are not all set
To:     Mingwei Zhang <mizhang@google.com>
CC:     Aaron Lewis <aaronlewis@google.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "jmattson@google.com" <jmattson@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, "bp@suse.de" <bp@suse.de>
References: <20221230162442.3781098-1-aaronlewis@google.com>
 <20221230162442.3781098-2-aaronlewis@google.com>
 <Y7R36wsXn3JqwfEv@google.com>
 <CAAAPnDHff-2XFdAgKdfTQnG_a4TCVqWN9wxEhUtiOfiOVMuRWA@mail.gmail.com>
 <c87904cb-ce6d-1cf4-5b58-4d588660e20f@intel.com>
 <Y8BPs2269itL+WQe@google.com>
 <a1308e46-c319-fb73-1fde-eb3b071c10e8@intel.com>
 <Y8Bcr9VBA/VLjAwd@google.com>
Content-Language: en-CA
From:   "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <Y8Bcr9VBA/VLjAwd@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR03CA0036.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::49) To PH0PR11MB4855.namprd11.prod.outlook.com
 (2603:10b6:510:41::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4855:EE_|SA3PR11MB8002:EE_
X-MS-Office365-Filtering-Correlation-Id: a24a1069-49f6-4462-2c22-08daf4dc07ee
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bINXkte3bO8AfnhX5NkHKBLUXVjN0FtAoA6rU5M3PRNscUQ0hPW1k1gLVPlvRXtn9OYqfLPG4X1JWJWVgACQZY73auWkDJhFikyEDIwKNLxdmYsjal1ZKTPE1m2/Yh0lROvByjzU/ftaE1GUGN5dCm/XZitBDe9zZNl9Q/2OftCWg1vi9TatBNKVFosk/HJwlXLuFzxw5BqDpRQXbVBXL7CAj8va4tpqvMarLNtY5gePwKKrwcTf/ITcFZfdwRZTAYFaJbKiJC1cNNo80NakMGlJNFnFuc64pgoP+HxiW0K2JpQy8Q2myI2mR7Ot8jgYPB84Jgpz4LEnPs1CCM3LBkk9VNvbfJ9htf1+sCaDcFYe9o6n3UHeOgmGkrGSUuycG9yggzz4nxZCuuSuQ6oBgF8XKgwOwGadz/CJoK+SxNF3EcLXHmjOCtoe7MyFURSoPBujLOOu9o+Md7kSvYiNhe4vl3CgQny3wypFn3agR25PS1Nbb9xC8k1K6rRWVFcX0zkGLJlYPIMEyRonQlyYEdOFYQMI3a35tAbm/viR9VNcO5dILq5lvS/k7S+rvk5l5VjPk7bh5FlS5Q78eHDnfyCXcDvu5+Ktq3xsjLb09n4IoQxr7RaJ6pUsrPahZoU7YRI+AqNZgIfjyYUDrJhCyDhZR5J9Tx3mnk3MxbwaVlSXtnmTkcqb9bQ8scsmrzhLfH43cowfUsV9g1sM+kZNm/Ei8S2GJ7Lu44UB9jJJG2YCfHwRWM4HdovPVw6OOMtYkvMOnCQ/Klv7KO3BVE1Ifh9m99IKVwv3u6GjjvJnvFEmkh0Lh1Xi3l2N7/H5OT1C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4855.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(376002)(396003)(136003)(346002)(451199015)(53546011)(66899015)(2906002)(6506007)(966005)(6486002)(26005)(478600001)(6512007)(186003)(31686004)(4326008)(36756003)(54906003)(8676002)(66946007)(6916009)(66476007)(316002)(2616005)(66556008)(41300700001)(8936002)(82960400001)(83380400001)(5660300002)(38100700002)(86362001)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b0hwN051K01PY0ZRRlFlbmp2eVFCMFMxSkxyUkI0WXZ6UkZackNnekE1OFpo?=
 =?utf-8?B?TGp2OG5kK3JKb0hVR3lONEFjeGdLV2FsK0xhQ2VsZGF4VWJiWmtxaFhRR1Mv?=
 =?utf-8?B?RG5NZnhBeit6WUhWVythbTZOUjZFVGhkSmE4Z1B5YlNDUkdtakJia1BTZFZ4?=
 =?utf-8?B?V1RScGovR1V5Q3BjdXhxODUvaWFMVml1aHVxUHdFSE5iS2NOQkQrMXJ5cHo4?=
 =?utf-8?B?NEZuODhOM1Y0YkFXLzFTQWdkYzRmMStnTHIxSE1iMjJlbFlqN0QyWnE3UkpF?=
 =?utf-8?B?U0dsci9IdHFNcGFIQW9vMk43RkJBd2tpcXR4V002QnJpT3Rjc2M5WEtFdzd5?=
 =?utf-8?B?aXZDendvL28wTWs3WEQzM3R0bFBNQzl5MmJBczdUZlVkSkFldHA1UFk4aTVM?=
 =?utf-8?B?dUhoK3ZEYzFFV08vc3crSzlqQ29ZQmJZaVNOSlFzZGNXWlVqU0tVb2FPS3pz?=
 =?utf-8?B?Z1RiSmg5RjBQelV0UzJpVFBIbVFPWjF3ODBYeDQzVFVDMU9kcFZ6MnNKRVBq?=
 =?utf-8?B?cXMrRFYwc2NSeG5DTS8zRFl6cnBRcXYzTEtPSDR3YUNHWTNRdlRibDlmYk43?=
 =?utf-8?B?YmhtZjFrMDNBWlFzTHpxcXZBS1lkeVFncTQrNTRTRUJtc1h1aGMva1ZRY2FG?=
 =?utf-8?B?Tk1QSjRLUU1LcTVCNjhtVDJmUTJZSmhrT0gvK21yV3RmODJERnJ3UjUrbXpC?=
 =?utf-8?B?TkN0ZGRDNlpyNnFLQ3JOMmF2TklIMHprTGFYV0x4eWNXQThUZ1EySXVuVHoz?=
 =?utf-8?B?RkE5bHdsOStzRXJNYllxTUlsd29kQ0pqVTlzY1oxUE1xekpyMVlNeTdBcTNp?=
 =?utf-8?B?UmdaeFhvVEd5RUl5a096MC85ekp4dllXb1BNU2g0RzJDTnRWaWc0MkoxdXZW?=
 =?utf-8?B?WVdzLy85UXRWU2RXRkhaUmlWUlRIb2FYVC9pZ0ZjbEJ0eGtkR0tibXlRK3p0?=
 =?utf-8?B?TnZiYVQ1WTYzbDRLOVRveXdORTdEWGxEcWFIU2lCZkFXeDVBaVcwNmJ6Yjdq?=
 =?utf-8?B?eUNuVFZNRm9ReDJ6WlVscm1Dc2xpL1MwRUIxRHRKcG1mbHdTS2VMMmg0eWFF?=
 =?utf-8?B?VHpaTUJMMnQ3YnFDTTg0TFFlS2tNVm5HeHgzdUFTWnR1MlRLZWRCRE1vTFRJ?=
 =?utf-8?B?UVI1RkRqQ3NMbjRuZ200VUhhOXA4a1ZqRzZzUkhhSEI5M1FvdnMrNU5yUlZ4?=
 =?utf-8?B?TkZxenlBWDlKYjBGdGhMY0RmWVgreWE0WXozNjloZm9aUXJJcUMxWm4wbkJ3?=
 =?utf-8?B?aDFIbm04YmhVZks4NXVPVVVmVDI5ZXdUSWYyVTd6RXlYQ2VMV3dqRndrQ3RK?=
 =?utf-8?B?dHh5RTB3SVA1N2tVMjVBZGhFSWlNT0NROWIvQXFxZDRKNmdrK1ZGNEQ0RGlh?=
 =?utf-8?B?M2dQbGdSMFlGSU1xb0ViTFMveFI4ZnlVdFVvUkNzc3l3blZaeUt5dGQ3SVEx?=
 =?utf-8?B?dDNKbGlCcTJRMXlCZjR4VXZxd3dEYXNnVWFsMEhRbjFFQ3hISWg2NWNBbG1a?=
 =?utf-8?B?dG5OZmduQjlxVmlMVy8ya2Q5V3Z5YXBac3VNTmFOcHhTZDIvcXdvdWQ3dzZP?=
 =?utf-8?B?Yk0xN1ZNcEsxNy9HaVYrREE0cXYyN0pmd3Y3WVgwMXRlc2FZejBPODdYQWt5?=
 =?utf-8?B?dTFabjZYMzNNRG5qNzh5ckpDWjdpZWZrNXBYUEp4R085aThTTTZUckx6cUNB?=
 =?utf-8?B?RkhBdTMvVXg3QkNRNE9jdGdlekZvOHFiVDM2d1JaWE5lWi9xRFNPLzVYYXc1?=
 =?utf-8?B?Z1ZnUWU5bkFkL2RjK2ljV2JkVTc0b3BsUDljVGpwR0JacGhPYnU1MHlhTGlB?=
 =?utf-8?B?NVU0SlptbUZFM05zRFVUVGwrWGRwZyt4L25rMlUreTJoeXM5Z3ladHZaT3dR?=
 =?utf-8?B?MVppMHVBS3B6ZlBiaURoTmRnc1JiVXIxSVEvaVlKR08rMmdHZVd6K0dKcDJM?=
 =?utf-8?B?NFB5Y2Y0Wk4wQ2E0Zkp3ejBRcGFOdWljNDZTSUZOUTlPYlFZQWJacTA0TytY?=
 =?utf-8?B?dHg1UDhuN2MxQXo3VVVKaVo0NUNBa21pNnN2NGpCY0NWazhnV1Vsa2xWUURV?=
 =?utf-8?B?VHh5WnpZcFBGcWJOMC82Z2xJSWFaSVFuV2ZlZllQYU9CQUh0c2pPMzRaOHFE?=
 =?utf-8?B?Sks2K3E4UFdVMlVBL25ETldrZ3NsQnZDM1IzWW1VVWd3UGd4QllEV1hKTith?=
 =?utf-8?B?b1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a24a1069-49f6-4462-2c22-08daf4dc07ee
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4855.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 20:31:49.1565
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qqvYcXcvs5Qrel2fbdceGhMtgXF0nLIQ99yrXoZJShgK/1cJsR/zXvtJL+SHtbgf/a2zw+GVEWBTxbu+718spFaMizaB2mqPN8oJz6vNFOY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB8002
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/12/2023 11:17 AM, Mingwei Zhang wrote:
> 
> But the permitted_xcr0 and supported_xcr0 seems never used
> directly as the parameter of XSETBV, but only for size calculation.

Yeah, I saw that too, and tried to improve it [1]. Maybe this is not a 
big deal in KVM.

> One more question: I am very confused by the implementation of
> xstate_get_guest_group_perm(). It seems fetching the xfeatures from the
> host process (&current->group_leader->thread.fpu). Is this intentional?
> Does that mean in order to enable AMX in the guest we have to enable it
> on the host process first?

Yes, it was designed that QEMU requests permissions via arch_prctl() 
before creating vCPU threads [2][3]. Granted, this feature capability 
will be advertised to the guest. Then, it will *enable* the feature, right?

Thanks,
Chang

[1] 
https://lore.kernel.org/kvm/20220823231402.7839-2-chang.seok.bae@intel.com/
[2] https://lore.kernel.org/lkml/87wnmf66m5.ffs@tglx/
[3] 
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=980fe2fddcff

