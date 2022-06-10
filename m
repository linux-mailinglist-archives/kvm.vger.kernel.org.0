Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47C1E5466CF
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 14:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242506AbiFJMtR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jun 2022 08:49:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239131AbiFJMtI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jun 2022 08:49:08 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CAEC1EEF6;
        Fri, 10 Jun 2022 05:49:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654865347; x=1686401347;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=tgp8OHfSndf8X9XOTJF9Tb0izZaAsaa2D0KBtc/ukNo=;
  b=d9YWw9b92M3fXAVdGCcSSxlDxxwlOx9fNiiKgDyhhNbABmJww0tmWXC2
   3yo4GcMb3iVZLPKSIQFxHnNdLxERAOKzlRrp0Bfpui32gHOPwUymOkUiX
   FVQy9TX9mtjpPvx5e0mExLXlQDGjEeOjmnMuh3q9wtyLePC6MsJh027f2
   yHskeDmpTIQLwjSxZQjTzfeAGIGslr2o3xf1p9WRxP0EJ79FyCu1cfKx3
   JIkKTgUA7nsQX/DJwMG+PGogetYctgV6ZR5E9qTG9bfXK1iAcbY/RXFyt
   +5O1tzppNlU891NMjg2LrAFQqbFqf6f9m/Nn0/ePxGvx8jA+5o0kJ7NM+
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10373"; a="275152767"
X-IronPort-AV: E=Sophos;i="5.91,290,1647327600"; 
   d="scan'208";a="275152767"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2022 05:49:06 -0700
X-IronPort-AV: E=Sophos;i="5.91,290,1647327600"; 
   d="scan'208";a="684527290"
Received: from elmerred-mobl2.amr.corp.intel.com (HELO [10.251.8.219]) ([10.251.8.219])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2022 05:49:05 -0700
Message-ID: <2854ae00-e965-ab0f-80dd-6012ae36b271@intel.com>
Date:   Fri, 10 Jun 2022 05:49:04 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 1/2] x86: notify hypervisor about guest entering s2idle
 state
Content-Language: en-US
To:     Grzegorz Jaszczyk <jaz@semihalf.com>
Cc:     linux-kernel@vger.kernel.org, Dmytro Maluka <dmy@semihalf.com>,
        Zide Chen <zide.chen@intel.corp-partner.google.com>,
        Peter Fang <peter.fang@intel.corp-partner.google.com>,
        Tomasz Nowicki <tn@semihalf.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>, Pavel Machek <pavel@ucw.cz>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Ashish Kalra <ashish.kalra@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Pratik Vishwakarma <Pratik.Vishwakarma@amd.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sachi King <nakato@nakato.io>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Dunn <daviddunn@google.com>,
        Wei Wang <wei.w.wang@intel.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        "open list:ACPI" <linux-acpi@vger.kernel.org>,
        "open list:HIBERNATION (aka Software Suspend, aka swsusp)" 
        <linux-pm@vger.kernel.org>
References: <20220609110337.1238762-1-jaz@semihalf.com>
 <20220609110337.1238762-2-jaz@semihalf.com>
 <f62ab257-b2e0-3097-e394-93a9e7a0d2bf@intel.com>
 <CAH76GKPo6VL33tBaZyszL8wvjpzJ7hjOg3o1JddaEnuGbwk=dQ@mail.gmail.com>
From:   Dave Hansen <dave.hansen@intel.com>
In-Reply-To: <CAH76GKPo6VL33tBaZyszL8wvjpzJ7hjOg3o1JddaEnuGbwk=dQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/10/22 04:36, Grzegorz Jaszczyk wrote:
> czw., 9 cze 2022 o 16:27 Dave Hansen <dave.hansen@intel.com> napisał(a):
>> On 6/9/22 04:03, Grzegorz Jaszczyk wrote:
>>> Co-developed-by: Peter Fang <peter.fang@intel.corp-partner.google.com>
>>> Signed-off-by: Peter Fang <peter.fang@intel.corp-partner.google.com>
>>> Co-developed-by: Tomasz Nowicki <tn@semihalf.com>
>>> Signed-off-by: Tomasz Nowicki <tn@semihalf.com>
>>> Signed-off-by: Zide Chen <zide.chen@intel.corp-partner.google.com>
>>> Co-developed-by: Grzegorz Jaszczyk <jaz@semihalf.com>
>>> Signed-off-by: Grzegorz Jaszczyk <jaz@semihalf.com>
>>> ---
>>>  Documentation/virt/kvm/x86/hypercalls.rst | 7 +++++++
>>>  arch/x86/kvm/x86.c                        | 3 +++
>>>  drivers/acpi/x86/s2idle.c                 | 8 ++++++++
>>>  include/linux/suspend.h                   | 1 +
>>>  include/uapi/linux/kvm_para.h             | 1 +
>>>  kernel/power/suspend.c                    | 4 ++++
>>>  6 files changed, 24 insertions(+)
>> What's the deal with these emails?
>>
>>         zide.chen@intel.corp-partner.google.com
>>
>> I see a smattering of those in the git logs, but never for Intel folks.
> I've kept emails as they were in the original patch and I do not think
> I should change them. This is what Zide and Peter originally used.

"Original patch"?  Where did you get this from?

>> I'll also say that I'm a bit suspicious of a patch that includes 5
>> authors for 24 lines of code.  Did it really take five of you to write
>> 24 lines of code?
> This patch was built iteratively: original patch comes from Zide and
> Peter, I've squashed it with Tomasz later changes and reworked by
> myself for upstream. I didn't want to take credentials from any of the
> above so ended up with Zide as an author and 3 co-developers. Please
> let me know if that's an issue.

It just looks awfully fishy.

If it were me, and I'd put enough work into it to believe I deserved
credit as an *author* (again, of ~13 lines of actual code), I'd probably
just zap all the other SoB's and mention them in the changelog.  I'd
also explain where the code came from.

Your text above wouldn't be horrible context to add to a cover letter.
