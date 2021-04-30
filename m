Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A21B36F646
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 09:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231138AbhD3HQp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 03:16:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50742 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230518AbhD3HQo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 30 Apr 2021 03:16:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619766956;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=28TamhQnx/WTmTYJRRukTbFCMkH+GJB8ptneJQNf94c=;
        b=a/h2RXTz3elZH9Q3ky3ZB8QY6ojoZO1C8jAtL2ODlZwdfsEQGfd1V1h5broHEiLkAJt5O+
        grj3CrbDaisb8PEJ9lHlQMr4weprWVBkAK0zCRu4SNVmK6Qe+JHYeHGlEgBvX44DFKcPnY
        JCGzXjl2uvlFxfNLg0oPTd40nxi9eDk=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-271-TLxKE51pMRqEbF9eQMpX9Q-1; Fri, 30 Apr 2021 03:15:54 -0400
X-MC-Unique: TLxKE51pMRqEbF9eQMpX9Q-1
Received: by mail-ed1-f70.google.com with SMTP id m18-20020a0564025112b0290378d2a266ebso29837546edd.15
        for <kvm@vger.kernel.org>; Fri, 30 Apr 2021 00:15:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=28TamhQnx/WTmTYJRRukTbFCMkH+GJB8ptneJQNf94c=;
        b=rOMQrRpXBsi7oeYR8UcaBp7Ggt/xI1W8XlvSPae2x813hAZIwqj4Zxe4GqCfiaWOJr
         WXDiTCnLAyw0flF/i6ryp3Ny7QX5utfQsS6Df7lAedtXEiPpSS4SxrV/8YyE23oMUIbV
         e94+aTWSJCPEDnkpy8HqdbhqWSVc/zdpU4MHpRYwv7eGeu8jLCFyE4j+fBpIG1LtInit
         0jrF/lfhFwJHJltHidnXQh17DCUbv+5u5MF8qiSVdsA+0X//91zU/VwSAErRndX4QyS9
         y8/mHtlpOCsRIZEs4R2BmrY1MiXyXp7utrbyiP8cHASIOBzOZe1jch86LB3XR/Xp3zWA
         BJVg==
X-Gm-Message-State: AOAM5312jLKxkpkFc7xjZKkiofwzBj6ZIg0KDG1xQQ4MkAbKsB+9XceZ
        ItHbpDcNSQ12jPrp1VAnHrOmq/qmL7WzyKMAHc7zMJsQjYmc3bQewq5S41fEL6LXEn5JdMHl9JA
        /QDtPFDb90+qT
X-Received: by 2002:a17:906:7d82:: with SMTP id v2mr2737691ejo.524.1619766953309;
        Fri, 30 Apr 2021 00:15:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyAQdeuZInXmsMkcogPQFLA3VeuUhCp7LSV5xe8bJEmH45eKyauY8xcO7cSejDdlfL6uAEUlg==
X-Received: by 2002:a17:906:7d82:: with SMTP id v2mr2737676ejo.524.1619766953147;
        Fri, 30 Apr 2021 00:15:53 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id i19sm1367781ejd.114.2021.04.30.00.15.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Apr 2021 00:15:52 -0700 (PDT)
Subject: Re: [PATCH 1/4] x86/xen/entry: Rename xenpv_exc_nmi to noist_exc_nmi
To:     Steven Rostedt <rostedt@goodmis.org>,
        Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Andi Kleen <ak@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Uros Bizjak <ubizjak@gmail.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Joerg Roedel <jroedel@suse.de>, Jian Cai <caij2003@gmail.com>,
        xen-devel@lists.xenproject.org
References: <20210426230949.3561-1-jiangshanlai@gmail.com>
 <20210426230949.3561-2-jiangshanlai@gmail.com>
 <20210428172714.53adac43@gandalf.local.home>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d77ee423-53fc-d552-1ff8-6fdf75e416a7@redhat.com>
Date:   Fri, 30 Apr 2021 09:15:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210428172714.53adac43@gandalf.local.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/04/21 23:27, Steven Rostedt wrote:
> On Tue, 27 Apr 2021 07:09:46 +0800
> Lai Jiangshan <jiangshanlai@gmail.com> wrote:
> 
>> From: Lai Jiangshan <laijs@linux.alibaba.com>
>>
>> There is no any functionality change intended.  Just rename it and
>> move it to arch/x86/kernel/nmi.c so that we can resue it later in
>> next patch for early NMI and kvm.
> 
> Nit, but in change logs, please avoid stating "next patch" as searching git
> history (via git blame or whatever) there is no such thing as "next patch".

Interesting, I use next patch(es) relatively often, though you're right 
that something like "in preparation for" works just as well.  Yes, it's 
the previous in "git log", but you get what it's meant in practice. :)

Paolo

> Just state: "so that we can reuse it for early NMI and KVM."
> 
> I also just noticed the typo in "resue". Or maybe both NMI and KVM should
> be sued again ;-)
> 
> -- Steve
> 

