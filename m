Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C28E17091CB
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 10:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbjESIkt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 04:40:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbjESIks (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 04:40:48 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36D5CE5D;
        Fri, 19 May 2023 01:40:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684485647; x=1716021647;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=uquxl4LqumwWhgaqOjFC3r5NVVh5ga2ulg7e5s0QI9U=;
  b=iY6NwD8cRKYCl8PNIEdgsZLMf0q+lLzuI7jobeD/vYTg5VxnaqyiS70a
   vOjl5qzhIMWiSOMBwBLC9JqEtfE3voMWCbWfneZDoVngGq3VDblPp9AWF
   gsRhULsfTzZ+z4Lq/t15iSb6qj4OQbZ59tCYdqRQlas2CQ3evxQEBj0la
   mCu3eSPCS9dJ4thmWtGjK6ebg/Ic/VMUKfRnSXtIjZSEs2mf9g7XkpCCC
   xJ92+st5Xwee2srsAN7mfhop1hc8VYrjj9Eszr5JWDUNlOaZ3putKYKGP
   BDi3G8k1C4g7sHEVWN2aGvKj5Fco5DZcfQ7pty++5vQOK7VDWWiUv0AJu
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="349833590"
X-IronPort-AV: E=Sophos;i="6.00,176,1681196400"; 
   d="scan'208";a="349833590"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2023 01:40:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="652975371"
X-IronPort-AV: E=Sophos;i="6.00,176,1681196400"; 
   d="scan'208";a="652975371"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga003.jf.intel.com with ESMTP; 19 May 2023 01:40:46 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 19 May 2023 01:40:45 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 19 May 2023 01:40:45 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.175)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 19 May 2023 01:40:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R5rWmc/tK/2kW8JNIou48J3HCbUBKA6IlKMOa51j/imJAy2l/8StUA1IfkvUrXfcfLHCprAfI3Q7fajuRjiOIySf1NjwL8lnFUNQlVpWrx2h09OK8V+N81sej2bFp31oP0krN5QbWEz49J2jtP4bY2+4C61Etkiu9kuuoJ3DJNbPEgcAUFkYEGYBD4wPHuKS6jA+0un+C9nFaNgEWv0quaLwFFHwJdRwhORQPw9eqPh1nwSr3FY0V/ovvSz1rj/c/usjLJLbng762UV78kIMnw+2l0ec5lYQKOZJ+tOMG6MrOHS4jEBqo+t7EpIlFbjlgCuqWdDStxpeUTN+p3GPYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bnY7GxBVKvp6BtS96EB2awJPXY37LEJxEBUOG5zuCP0=;
 b=d4Hg7NRrrR45/2h7cmVKRZxpcXKVd/WYtbWQBTbWaXyYiBev6wRiRrO5Pe05PKRZsaUOvcqb8MhgWO84qXKqaglPemI1HDBAQJD9Z1gIgXFb+bP3OtzkaYiDfqk/ekPFoQh4V4FYEP1wCf/x8cHBLU8FuHz+C0W752QaKcFePvN5bqNkld1pfcmTq268NGJ/TuizNyrw+PawydxIHlHLRv0iVYv4tWXby1x4VAGmT/H0mo1uY+ilhXozn0zTMpTAsUbDPky0m5pxRnqvVvq3ptp2oO6ROTlLlsIpOA4Zo1UIirc8hWFxNzBpjcmOSYdWJtsj49VxqUNKbh0hdBR3Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
 by DM4PR11MB5229.namprd11.prod.outlook.com (2603:10b6:5:39f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.19; Fri, 19 May
 2023 08:40:42 +0000
Received: from PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5]) by PH8PR11MB6780.namprd11.prod.outlook.com
 ([fe80::b4cb:1f70:7e2a:c4f5%2]) with mapi id 15.20.6411.019; Fri, 19 May 2023
 08:40:42 +0000
Date:   Fri, 19 May 2023 16:40:30 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Sean Christopherson <seanjc@google.com>,
        <pawan.kumar.gupta@linux.intel.com>
CC:     Xiaoyao Li <xiaoyao.li@intel.com>, <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, <linux-kernel@vger.kernel.org>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH] KVM: x86: Track supported ARCH_CAPABILITIES in kvm_caps
Message-ID: <ZGc1/lwk5BAdRyOi@chao-email>
References: <20230506030435.80262-1-chao.gao@intel.com>
 <b472b58d-0469-8a55-985c-1d966ce66419@intel.com>
 <ZGZhW/x5OWPmx1qD@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZGZhW/x5OWPmx1qD@google.com>
X-ClientProxiedBy: SGAP274CA0024.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::36)
 To PH8PR11MB6780.namprd11.prod.outlook.com (2603:10b6:510:1cb::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB6780:EE_|DM4PR11MB5229:EE_
X-MS-Office365-Filtering-Correlation-Id: b9b98a29-4b11-4586-6437-08db5844babd
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3VDaadALSvnUz7vaKtAL+kr6fSnnym3hRQt4YUORqmPMcseth3I9/sEXY1TQ4o44OhIH0imA3WSHOxemTIG4QWJDJrLg/yH8xHIjt9pWgzPEoiznk0w9YtYjN073+1avPakuF5b/V2JjE/rgtS8ryoe1sR7zAABOQQivkdJuYwb8hJJoJo8lcfw1crJUhTG2grP2IBYQYh1C5Bu13E5NNydnpPffJaCFIrWuIOUSafPD3EEMfL+mVGzJ+kyTe2Wle+cKv42wtFn+mU76ttURMPFYUrjdVzSNx3YE5hOoUT6pSXERoG2BK4RtkBTy7w/DnQuebB3rWx5GU8fc/PZ+J2H3Ts7JmqUcGY3yg+7ijIWkrOOGteTQp4rAXLDRvriJBfcyMhyBG3TwBFmqAGLC5gObqNKUolX66Q2/WluZYXW9wutVaHPH7cMeCYkZ3maRm4uhnOLr8uHUDz1dMbWUm4uCLf5fAxFcyQq4d5q2G0jntSkDFJcMnCwzoTKbtMaFyYA7KcfP+t93Qc+Ua+jJw8zoVlYG70I6rVEClbJFK3I5eyPLQUXeqTptBUgxidAW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB6780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(39860400002)(396003)(346002)(366004)(136003)(376002)(451199021)(6666004)(83380400001)(5660300002)(2906002)(8676002)(8936002)(44832011)(7416002)(9686003)(6506007)(26005)(53546011)(186003)(82960400001)(66946007)(86362001)(54906003)(6512007)(33716001)(6486002)(4326008)(316002)(41300700001)(478600001)(38100700002)(66556008)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FnV7dAM+SdtCtw8I9WOUt/TuUvEL3hDF3wO3c7W1XcN6n8vWhiA0gdWJTpKc?=
 =?us-ascii?Q?LuMsjcd7Q+oi2mhzd5Q+5p9hy+AEDmf0eQP/CubxV5fWdK1gNK0bqomYWEao?=
 =?us-ascii?Q?nvu5WgsMKOLf7B6l386JzF1X2WotX7hcNanRnUC7DPcgFQAcfc4t91ZDqlKn?=
 =?us-ascii?Q?25zUCLblJFVYRWk2a4GEEh4pNkJB6aMzjqNw4F/2m8eIjuvMue2barJj8766?=
 =?us-ascii?Q?lZaGkm4co+hzOMOXsXXtt8TO9EQ+Iel2J+JQhY6sPTY9z6aj9RCkg6qzym+k?=
 =?us-ascii?Q?x4bZxKO6wObKds8/hwkBf4/NZC6Ey4bzgTIw0S+UkQfS/bo7t30U/YIwkyxQ?=
 =?us-ascii?Q?aY0I2oiDs32AEhHDdbUn8bpr4PBfR7ksxc01O8bI4ChXbOB02Xt9CToM//Kr?=
 =?us-ascii?Q?QfkCL+qFjfCW+GwrsgRopK2BuPhMPGJjrykXUwpTu9XVOCNdCt9F2JGW1e1u?=
 =?us-ascii?Q?LdPBp7SkaFFvFwUJZgw89OG9qkyiBol9h/5susbJQ37OG9JHVE4n/4d4z68b?=
 =?us-ascii?Q?SeK02MZIxZbqu36+idUfhnsyMcGJgZoFHZCCO/MFuOYm3V6IeeR5+6IE9q7e?=
 =?us-ascii?Q?ae6FwuDcVUvSkDn6gr1cCSqel8cdJ7vxQYyfVPcmSR8j11uA8VCC37q/VjTb?=
 =?us-ascii?Q?AvKnA7p+WnJXc6fJgcxdXp8kUi8tggndrnhna3IlCJDBK2XXT6uFVyHKoVyK?=
 =?us-ascii?Q?o18ztHdsN0KEnK8UyF2mYYhzLpJNsjiasiCDkRjXuUdnwJKjX0o+dPNrtPPr?=
 =?us-ascii?Q?QUuUEcspbltQmyZJZP2z3EK5ya4O7Vcxtir3tpaMtmKBN61epqM8qrnz7K+Y?=
 =?us-ascii?Q?J689sQVCGLqP/PJ8G4YJX/Q/kktv39iHTJoJm6tYIEJnOWwS1VhxtdssC22R?=
 =?us-ascii?Q?w+6gNz4oXJgJw2D5pefhYd2kPCCpKpyXmEIPOmgeyEIXph4sWCLBHtdfPOg7?=
 =?us-ascii?Q?n0bDDa4HUv0mIx/hqaUu/3TYEdumS+ZcxZjnwOy+LgPpLHWsVH9ImL0bvL7J?=
 =?us-ascii?Q?rgLB66ktwX6rSZcKXzCR6jGCL4q6Vnujym4lwX12oSGncwBMxbl/klNhIav0?=
 =?us-ascii?Q?NUKR1ecTd9rp7HYFepnS0A+7XQGdCcOi03ZDoNo0/fSshzWq+16zT/RPhgqE?=
 =?us-ascii?Q?/nAClB6H9AK3jmFazrCub/oHCZU1N4u3PqPuF/G4nDepit0F1ka9PaYR1Ho3?=
 =?us-ascii?Q?i+FToMt1jaI3k4HcrTYNjPgYGVxzbyIJuPBy24D/i9PvM84A+W689jbw2DcF?=
 =?us-ascii?Q?wWimlPYjM4+n5F5qradOv0ZrIi+UeGgGBx+nc//dLRJJ+re+pOTKyL34/kU0?=
 =?us-ascii?Q?SYpYX96koEQpZh/VqV7qdYhzUAWC77nv0YtRUkK7daR5OERfsSJ+WALvretC?=
 =?us-ascii?Q?e22/nfPfMatdYAkUZr/ltHGMwfXp4tCqvSxLjFyGXTfSh8UyJPaWLeYHfsIS?=
 =?us-ascii?Q?2UziVi1/y8hZA7uKQDZfuTObBIxFWB/zrhcSUoRhuRL0bVAJ2nic/08991ZU?=
 =?us-ascii?Q?s216RYHArKjUxq91YSlFiP2Gdc+3GXvOL2UIWDfK9VwyXhcDzEkwOcf4l7v0?=
 =?us-ascii?Q?PsBdJzTIAesHaSiVYfW8OKop39m1boJEj6cGxFCH?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b9b98a29-4b11-4586-6437-08db5844babd
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB6780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2023 08:40:42.0581
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MGRVeL4WT3uQ4MoZY2oXbTZ9DmXy2yu795fVcWDzC3H452x03JbHyUWSwHegDq1Lmqb/bMZ0bWUqTYRTBGed5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5229
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+Pawan, could you share your thoughts on questions about FB_CLEAR?

On Thu, May 18, 2023 at 10:33:15AM -0700, Sean Christopherson wrote:
>+Jim
>
>On Thu, May 18, 2023, Xiaoyao Li wrote:
>> On 5/6/2023 11:04 AM, Chao Gao wrote:
>> > to avoid computing the supported value at runtime every time.
>> > 
>> > No functional change intended.
>> 
>> the value of kvm_get_arch_capabilities() can be changed due to
>> 
>> 	if (l1tf_vmx_mitigation != VMENTER_L1D_FLUSH_NEVER)
>> 		data |= ARCH_CAP_SKIP_VMENTRY_L1DFLUSH;
>> 
>> and l1tf_vmx_mitigation can be runtime changed by vmentry_l1d_flush module
>> param.

Thanks for pointing this out. I noticed l1tf_vmx_mitigation and analyzed if
it could be changed at runtime. Obviously I did a wrong analysis.

>
>Nice catch!
>
>> We need a detailed analysis that in no real case can
>> ARCH_CAP_SKIP_VMENTRY_L1DFLUSH bit change runtime.
>
>No, the fact that it _can_ be modified by a writable module param is enough to
>make this patch buggy.
>
>I do like snapshotting and then updating the value, even though there's likely no
>meaningful performance benefit, as that would provide a place to document that
>the "supported" value is dynamic.  Though the fact that it's dynamic is arguably a bug
>in its own right, e.g. if userspace isn't careful, a VM can have vCPUs with different
>values for ARCH_CAPABILITIES.  But fixing that is probably a fool's errand.  So

I am not sure if fixing it is fool. There would be some other problem:

KVM enables L1DLFUSH and creates a guest. Then ARCH_CAP_SKIP_VMENTRY_L1DFLUSH is
exposed to the guest. If L1DFLUSH is disabled at runtime in KVM, the guest
doesn't know this change and won't do L1DFLUSH when entering L2. Then L2 may use
L1TF to leak some secrets of L1.

>I vote to snapshot the value and toggle the ARCH_CAP_SKIP_VMENTRY_L1DFLUSH bit
>when l1tf_vmx_mitigation is modified.

Sure. Will do.

>
>On a somewhat related topic, what in the absolute #$#$ is going on with FB_CLEAR_DIS!?!?
>I made the mistake of digging into why KVM doesn't advertise ARCH_CAP_FB_CLEAR_CTRL...
>
>  1. I see *nothing* in commit 027bbb884be0 ("KVM: x86/speculation: Disable Fill
>     buffer clear within guests") that justifies 1x RDMSR and 2x WRMSR on every
>     entry+exit.
>
>  2. I'm pretty sure conditioning mmio_stale_data_clear on kvm_arch_has_assigned_device()
>     is a bug.  AIUI, the vulnerability applies to _any_ MMIO accesses.  Assigning
>     a device is necessary to let the device DMA into the guest, but it's not
>     necessary to let the guest access MMIO addresses, that's done purely via
>     memslots.
>
>  3. Irrespective of whether or not there is a performance benefit, toggling the
>     MSR on every entry+exit is completely unnecessary if KVM won't do VERW before
>     VM-Enter, i.e. if (!mds_user_clear && !mmio_stale_data_clear), then the
>     toggling can be done in vmx_prepare_switch_to_{guest,host}().  This probably
>     isn't worth pursuing though, as #4 below is more likely, especially since
>     X86_BUG_MSBDS_ONLY is limited to Atom (and MIC, lol) CPUs.
>
>  4. If the host will will _never_ do VERW, i.e. #3 + !X86_BUG_MSBDS_ONLY, then
>     KVM just needs to context switch the MSR between guests since the value that's
>     loaded while running in the host is irrelevant.  E.g. use a percpu cache to
>     track the current value.

Agreed.

Looks VERW can be used in CPL3, should we restore the MSR on returning
to userspace i.e., leverage uret mechanism?

>
>  5. MSR_IA32_MCU_OPT_CTRL is not modified by the host after a CPU is brought up,
>     i.e. the host's desired value is effectively static post-boot, and barring
>     a buggy configuration (running KVM as a guest), the boot CPU's value will be
>     the same as every other CPU.
>
>  6. Performance aside, KVM should not be speculating (ha!) on what the guest
>     will and will not do, and should instead honor whatever behavior is presented
>     to the guest.  If the guest CPU model indicates that VERW flushes buffers,
>     then KVM damn well needs to let VERW flush buffers.
>
>  7. Why on earth did Intel provide a knob that affects both the host and guest,
>     since AFAICT the intent of the MSR is purely to suppress FB clearing for an
>     unsuspecting (or misconfigured?) guest!?!?!

I doubt it is purely for guests. Any chance userspace application may use VERW?

And I don't think the original patch is for misconfigured guest. IIUC, it is
about migrating a guest from a vulnerable host to an invulnerable host.

>
>FWIW, this trainwreck is another reason why I'm not going to look at the proposed
>"Intel IA32_SPEC_CTRL Virtualization" crud until external forces dictate that I
>do so. I have zero confidence that a paravirt interface defined by hardware
>vendors to fiddle with mitigations will be sane, flexible, and extensible.
>
>Anyways, can someone from Intel do some basic performance analysis to justify
>doing RDMSR + WRMSRx2 on every transition?  Unless someone provides numbers that

Pawan, could you help to answer this question?

>show a clear, meaningful benefit to the aggressive toggling, I'm inclined to have
>KVM do #4, e.g. end up with something like:
>
>	/* L1D Flush includes CPU buffer clear to mitigate MDS */
>	if (static_branch_unlikely(&vmx_l1d_should_flush)) {
>		vmx_l1d_flush(vcpu);
>	} else if (static_branch_unlikely(&mds_user_clear) ||
>		   static_branch_unlikely(&mmio_stale_data_clear)) {
>		mds_clear_cpu_buffers();
>	} else if (static_branch_unlikely(&kvm_toggle_fb_clear) {
>		bool enable_fb_clear = !!(vcpu->arch.arch_capabilities & ARCH_CAP_FB_CLEAR);
>
>		if (this_cpu_read(kvm_fb_clear_enabled) != enable_fb_clear) {
>			u64 mcu_opt_ctrl = host_mcu_opt_ctrl;
>
>			if (enable_fb_clear)
>				mcu_opt_ctrl &= ~FB_CLEAR_DIS;
>			else
>				mcu_opt_ctrl |= FB_CLEAR_DIS;
>			native_wrmsrl(MSR_IA32_MCU_OPT_CTRL, mcu_opt_ctrl);
>			this_cpu_write(kvm_fb_clear_enabled, enable_fb_clear);
>		}
>	}
