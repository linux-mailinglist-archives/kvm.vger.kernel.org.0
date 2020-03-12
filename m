Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13724183942
	for <lists+kvm@lfdr.de>; Thu, 12 Mar 2020 20:12:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbgCLTMU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Mar 2020 15:12:20 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55358 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725268AbgCLTMU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Mar 2020 15:12:20 -0400
Received: by mail-wm1-f67.google.com with SMTP id 6so7334403wmi.5;
        Thu, 12 Mar 2020 12:12:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gRCD7Oq5lGUI5CEgwfVAWNceJsy2l+rhC9BaRHjQSDQ=;
        b=UkbREbjz98xAIBzBb/WxEAxaCrvxlWSAQNLJ25M/AazEyczZZuECCBworRc5LO9Mkm
         BshmghGKOZgy/k55JrfGaumofLA9U3o81NYDDO2mk1k24pI3oidMrnCBkj1I5WZCm7Ic
         q3MGFgTePOGHG8zc8u4no7bpYiLLMry0x2D42Cp1sZLwk+RJi6BmQrAp6zsVVplHemCt
         NmdL5zdFhL4q+6A8QVzz40m3cyxVy3Fyu8MbVVNPiZFHzL6pW1QG1c42bf1fJxVNkPgQ
         Gf0moksmsf6zuDsqXiNNxg61+3dLUwxIWIkt7eR9o+S4iAjqNoNpDCKJcbyfkM8HMrIy
         cSiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gRCD7Oq5lGUI5CEgwfVAWNceJsy2l+rhC9BaRHjQSDQ=;
        b=IFgeu5jW6irBmB71TNHQ/rp7Fo/VxXf8khe2RPz+Gul9vYK3fmfqb1kaSNQxxmzrZD
         DMY60Rys+F14AmOLEgRBYMSN/xuPSJWzHFfvI0IBj7OFxltzM0xeT2FCNX1TFFA5C/Y8
         PRkcANZCjyLGGNUtPfg6wDo6G4+K+yFX0dwt6C16i4jbPthA25PeRrK+0sJNiStNKm54
         m20cMirJWk9eKQe7F7bWsnKfT7qbnw+Rg4vnINC+UyW/3Si3lWUc80RXoQNwE54ZbnNB
         TYEWeqoHADtEUW2K0d6pRE+EmHfIVGmtIdLlljq3Qon1/N7KayNRh5SvhA5gok4MLamB
         1faA==
X-Gm-Message-State: ANhLgQ0t6O84CCqbR0gQ3oYBkvb3QEczJb37sfVQH4OIdTFIKYj31ZFH
        jnlti5tR7O0cNcNqgx6hV2o=
X-Google-Smtp-Source: ADFU+vtdrpXQhmMLt85iscLoQwhBA/QiQBd9jWFN1vhl81j/UDug09Txg5Lnu31wGtFGxV+qtMKRIw==
X-Received: by 2002:a1c:ac46:: with SMTP id v67mr5997726wme.153.1584040338743;
        Thu, 12 Mar 2020 12:12:18 -0700 (PDT)
Received: from jondnuc (IGLD-84-229-155-229.inter.net.il. [84.229.155.229])
        by smtp.gmail.com with ESMTPSA id r3sm99694wrw.76.2020.03.12.12.12.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2020 12:12:17 -0700 (PDT)
Date:   Thu, 12 Mar 2020 21:12:16 +0200
From:   Jon Doron <arilou@gmail.com>
To:     Michael Kelley <mikelley@microsoft.com>
Cc:     vkuznets <vkuznets@redhat.com>, Wei Liu <wei.liu@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
Subject: Re: [PATCH v4 2/5] x86/hyper-v: Add synthetic debugger definitions
Message-ID: <20200312191216.GA2950@jondnuc>
References: <20200309182017.3559534-1-arilou@gmail.com>
 <20200309182017.3559534-3-arilou@gmail.com>
 <DM5PR2101MB104761F98A44ACB77DA5B414D7FE0@DM5PR2101MB1047.namprd21.prod.outlook.com>
 <20200310032453.GC3755153@jondnuc>
 <MW2PR2101MB10522800EB048383C227F556D7FF0@MW2PR2101MB1052.namprd21.prod.outlook.com>
 <87d09hr89w.fsf@vitty.brq.redhat.com>
 <MW2PR2101MB10527BA547449B34FEC65C1FD7FD0@MW2PR2101MB1052.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <MW2PR2101MB10527BA547449B34FEC65C1FD7FD0@MW2PR2101MB1052.namprd21.prod.outlook.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/03/2020, Michael Kelley wrote:
>From: Vitaly Kuznetsov <vkuznets@redhat.com>  Sent: Thursday, March 12, 2020 6:51 AM
>>
>> Michael Kelley <mikelley@microsoft.com> writes:
>>
>> > I'm flexible, and trying to not be a pain-in-the-neck. :-)  What would
>> > the KVM guys think about putting the definitions in a KVM specific
>> > #include file, and clearly marking them as deprecated, mostly
>> > undocumented, and used only to support debugging old Windows
>> > versions?
>>
>> I *think* we should do the following: defines which *are* present in
>> TLFS doc (e.g. HV_FEATURE_DEBUG_MSRS_AVAILABLE,
>> HV_STATUS_OPERATION_DENIED, ...) go to asm/hyperv-tlfs.h, the rest
>> (syndbg) stuff goes to kvm-specific include (I'd suggest we just use
>> hyperv.h we already have).
>>
>> What do you think?
>>
>
>I could live with this proposal, since they *are* in the TLFS v6.0 as it
>exists today. However, v6.0 seems inconsistent in what parts of this
>debugging functionality it exposes, probably just because someone
>hasn't thought comprehensively about the topic across the whole
>document.   I'll make sure that it gets looked at in the next revision
>(which should be a lot sooner that the 2+ years it took to get the v6.0
>revision done).   But I won't be surprised if the remaining vestiges are
>removed at that time, in which case we would want to move the
>definitions from hyperv-tlfs.h to KVM's hyper.h.
>
>Michael

Hi guys, just a quick note I went over the old HyperV TLFS and it seems 
like all the Syndbg MSRs are documented (under Appendix F: Hypervisor 
Synthetic MSRs, from v5.0b).

It seems like the undocumented stuff is HV_X64_MSR_SYNDBG_OPTIONS which 
seems kinda odd because that's how you enable the hypercalls debugging 
interface which is documented.

And the syndbg CPUID leafs are not documented as well.

So would you like me to put all the MSRs in the tlfs omitting the 
HV_X64_MSR_SYNDBG_OPTIONS.

So in hyperv.h we will have HV_X64_MSR_SYNDBG_OPTIONS and the CPUID 
leafs.

Thanks in advance,
-- Jon.
