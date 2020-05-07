Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DAAA1C94AE
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 17:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727849AbgEGPRN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 May 2020 11:17:13 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:55075 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726029AbgEGPRM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 May 2020 11:17:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588864630;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cRIPMJwMfVphGwxMC976WpIk6/4Dq31PdpH7lHRMERw=;
        b=cdgcouRisUwAZxJnRnjIRWESTWvS72YzcktCMpxwcOMbImIFhZ8vHgdcAdPkRh9MSlkwfF
        2nqr5L6miu4VR2xFLfGf08xs5nCFMWaQBIrS4/T+hIna3rYacImSTCctYuLNx+vAGE7NXN
        ORIj2Youz35KUFrNzX0BKEOOW6kTqoA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-392-zvmrGs6DNYOgiyTtQS-y9w-1; Thu, 07 May 2020 11:17:08 -0400
X-MC-Unique: zvmrGs6DNYOgiyTtQS-y9w-1
Received: by mail-wr1-f72.google.com with SMTP id u4so3630942wrm.13
        for <kvm@vger.kernel.org>; Thu, 07 May 2020 08:17:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cRIPMJwMfVphGwxMC976WpIk6/4Dq31PdpH7lHRMERw=;
        b=nhJz7KUnkpbC+cm3uI/1WmdLVzK6s3pt0CwYPAX4Q2SFFoR91NFD2CjjrauaZ5kRHG
         IEAZHSebTRipHfcGqf3L1i0AAVbBYu4Ez6C9OcTbhp5CP3/FHn2D652rGUtqqIXLzlFm
         mOSpcYsmL5TqMR4HdD+1Y9Q7GFUA7aghPQ1xnx3VFcbSFWEl5Qc3+MeHuD1O19Gd76VZ
         svRmI+0p4GHrd8y+bcbWzHhV4hIO8unJyrLvwqWrAw23LJcdJdseMOPSRToGyqJD37pJ
         Y5qNrhVbuxNeNy+CUF7SjPiyQs6yBZ+iwGWOk6VuqpRePTNgrgrs10bHLyDDH/M64v1B
         Szrg==
X-Gm-Message-State: AGi0PuZnM0g+MeV//4e1WoEuwscUnTrZwhZGgwgJvFcel6HYYh+lAwtB
        L73+p2R24vuiSpvWZFTLKXTFPldaKWJeCEA6Org/lwQdKu4crWy/OMMoBbsSy6A2uvT5IyFCG4d
        UBgRXxU8mTsPA
X-Received: by 2002:a1c:ed0b:: with SMTP id l11mr11733498wmh.31.1588864626705;
        Thu, 07 May 2020 08:17:06 -0700 (PDT)
X-Google-Smtp-Source: APiQypIxOythRrjywGd5bcMR7Aky7KZnSEbCO09E3kJJhynh/cbmPoCLvTlRrUUobsVcZbrWuNTNHw==
X-Received: by 2002:a1c:ed0b:: with SMTP id l11mr11733421wmh.31.1588864626355;
        Thu, 07 May 2020 08:17:06 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:8d3e:39e5:cd88:13cc? ([2001:b07:6468:f312:8d3e:39e5:cd88:13cc])
        by smtp.gmail.com with ESMTPSA id v2sm8933907wrn.21.2020.05.07.08.17.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 May 2020 08:17:02 -0700 (PDT)
Subject: Re: [PATCH 1/2] arch/x86: Rename config
 X86_INTEL_MEMORY_PROTECTION_KEYS to generic x86
To:     Dave Hansen <dave.hansen@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     Babu Moger <babu.moger@amd.com>, corbet@lwn.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        sean.j.christopherson@intel.com, x86@kernel.org,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, dave.hansen@linux.intel.com, luto@kernel.org,
        peterz@infradead.org, mchehab+samsung@kernel.org,
        changbin.du@intel.com, namit@vmware.com,
        yang.shi@linux.alibaba.com, asteinhauser@google.com,
        anshuman.khandual@arm.com, jan.kiszka@siemens.com,
        akpm@linux-foundation.org, steven.price@arm.com,
        rppt@linux.vnet.ibm.com, peterx@redhat.com,
        dan.j.williams@intel.com, arjunroy@google.com, logang@deltatee.com,
        thellstrom@vmware.com, aarcange@redhat.com, justin.he@arm.com,
        robin.murphy@arm.com, ira.weiny@intel.com, keescook@chromium.org,
        jgross@suse.com, andrew.cooper3@citrix.com,
        pawan.kumar.gupta@linux.intel.com, fenghua.yu@intel.com,
        vineela.tummalapalli@intel.com, yamada.masahiro@socionext.com,
        sam@ravnborg.org, acme@redhat.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <158880240546.11615.2219410169137148044.stgit@naples-babu.amd.com>
 <158880253347.11615.8499618616856685179.stgit@naples-babu.amd.com>
 <4d86b207-77af-dc5d-88a4-f092be0043f6@intel.com>
 <20200507072934.d5l6cpqyy54lrrla@linutronix.de>
 <034cfb90-7f75-8e36-5b1e-ceaef0dfa50d@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1aca7824-f917-c027-ef02-d3a9e7780c3b@redhat.com>
Date:   Thu, 7 May 2020 17:16:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <034cfb90-7f75-8e36-5b1e-ceaef0dfa50d@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/05/20 16:44, Dave Hansen wrote:
>> You could add a new option (X86_MEMORY_PROTECTION_KEYS) which is
>> def_bool X86_INTEL_MEMORY_PROTECTION_KEYS and avoiding the prompt line.
>> Soo it is selected based on the old option and the user isn't bother. A
>> few cycles later you could remove intel option and add prompt to other.
>> But still little work for…
> That does sound viable, if we decide it's all worth it.
> 
> So, for now my preference would be to change the prompt, but leave the
> CONFIG_ naming in place.

I agree.

What's in a name?  An Intel rose by any other name would smell as sweet.
 Oh wait... :)

Paolo

> If we decide that transitioning the config is
> the right thing (I don't feel super strongly either way), let's use
> Sebastian's trick to avoid the Kconfig prompts.
> 

