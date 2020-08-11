Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC7324140F
	for <lists+kvm@lfdr.de>; Tue, 11 Aug 2020 02:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727810AbgHKASl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Aug 2020 20:18:41 -0400
Received: from mga07.intel.com ([134.134.136.100]:51176 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726733AbgHKASk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Aug 2020 20:18:40 -0400
IronPort-SDR: +xpmmPFEFMBjfLrEOey0zxjlg6bq84P2ntTOTljTHsWB70fOo9uJNDqMxB2eyi0Z4NzNruRfxZ
 Ty2h8plq3Pbg==
X-IronPort-AV: E=McAfee;i="6000,8403,9709"; a="217975322"
X-IronPort-AV: E=Sophos;i="5.75,458,1589266800"; 
   d="scan'208";a="217975322"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2020 17:18:39 -0700
IronPort-SDR: AYJ9db4E945V2WtApKiuVM8pT5M9W3BAKjBmVMvHTzmF6iAw4mktxTnYYrXWBju9Jp4WrFJ/NR
 4NoU01x+yWTQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,458,1589266800"; 
   d="scan'208";a="317540213"
Received: from zhangj4-mobl1.ccr.corp.intel.com (HELO [10.255.28.102]) ([10.255.28.102])
  by fmsmga004.fm.intel.com with ESMTP; 10 Aug 2020 17:18:33 -0700
Subject: Re: [PATCH v3 2/2] x86/kvm: Expose new features for supported cpuid
To:     "Luck, Tony" <tony.luck@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Cc:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Park, Kyung Min" <kyung.min.park@intel.com>,
        "ricardo.neri-calderon@linux.intel.com" 
        <ricardo.neri-calderon@linux.intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "jpoimboe@redhat.com" <jpoimboe@redhat.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Shankar, Ravi V" <ravi.v.shankar@intel.com>
References: <1596959242-2372-1-git-send-email-cathy.zhang@intel.com>
 <1596959242-2372-3-git-send-email-cathy.zhang@intel.com>
 <d7e9fb9a-e392-73b1-5fc8-3876cb30665c@redhat.com>
 <27965021-2ec7-aa30-5526-5a6b293b2066@intel.com>
 <e92df7bb267c478f8dfa28a31fc59d95@intel.com>
From:   "Zhang, Cathy" <cathy.zhang@intel.com>
Message-ID: <8f5d3b35-2478-c030-e51d-3183dbcaf4a6@intel.com>
Date:   Tue, 11 Aug 2020 08:18:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <e92df7bb267c478f8dfa28a31fc59d95@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/11/2020 7:59 AM, Luck, Tony wrote:
>> As you suggest, I will split the kvm patch into two parts, SERIALIZE and
>> TSXLDTRK, and this series will include three patches then, 2 kvm patches
>> and 1 kernel patch. SERIALIZE could get merged into 5.9, but TSXLDTRK
>> should wait for the next release. I just want to double confirm with
>> you, please help correct me if I'm wrong.
> Paolo is saying that he has applied the SERIALIZE part to his KVM tree.
>
> https://git.kernel.org/pub/scm/virt/kvm/kvm.git/commit/?h=queue&id=43bd9ef42b3b862c97f1f4e86bf3ace890bef924
>
> Next step for you is a two part series.
>
> Part 1: Add TSXLDTRK to cpufeatures.h
> Part 2: Add TSXLDTRK to arch/x86/kvm/cpuid.c (on top of the version that Paolo committed with SERIALIZE)
>
> Paolo: The 5.9 merge window is still open this week. Will you send the KVM serialize patch to Linus
> before this merge window closes?  Or do you have it queued for v5.10?
>
> -Tony
Got it! Thanks for the explanation, Tony!
