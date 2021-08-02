Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 759963DDCAD
	for <lists+kvm@lfdr.de>; Mon,  2 Aug 2021 17:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235307AbhHBPrM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Aug 2021 11:47:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51325 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234974AbhHBPrM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 2 Aug 2021 11:47:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627919222;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OBaO0yskfvB1zK3p27gj9eBCF5tIPQg8vdX0L4bNNNI=;
        b=D/XG4psezmFJruwEZnNCG71qpTl4kQUueS9YKs/r5T6iQIyug1OqKr3u2fW3aArsxmpjXy
        8mbpQmRGa1TMtUEHbv+XIPqoYxq+rhHBaFlFeny6rDjTbJiq9jBhnf4LdUtNhx7ckixfbH
        pPuIw8TPehEb3FZms8T6wh2QKV9jT8w=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-250-yEfDJAN5O8Sxtfn7hSB3Rw-1; Mon, 02 Aug 2021 11:47:01 -0400
X-MC-Unique: yEfDJAN5O8Sxtfn7hSB3Rw-1
Received: by mail-wm1-f71.google.com with SMTP id n17-20020a7bc5d10000b0290228d7e174f1so3003486wmk.0
        for <kvm@vger.kernel.org>; Mon, 02 Aug 2021 08:47:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OBaO0yskfvB1zK3p27gj9eBCF5tIPQg8vdX0L4bNNNI=;
        b=S9c1sNQYS46X/jrGx9W2ZStyJEajNE3Yr9kcquFgITCNSiG+dlxww2xM3KTD09iDuG
         er/8j/G7Wg+4raYct0Y3MrQVNglbo4Bcp0gjnw5Pv/KbfwJ8stED7V7BiEFWdDDNwP1r
         /uok1UjVifLlWL0sXPzEs6hXf1Lv0WY7/7NJXh5a4uHrKqRu2gzVaDZ1Qes7KqZCbvuc
         kEtXisU10+rDD41mXqChNYOlE/E0bLKr6Eg+82ezShtWrF3IuYWMnNkApLal2kK4SJNJ
         rIliwzvIF7ZUNCJ7cHF2i04rJPUHLcF0ACrhvCz8P3qLB8SQMZsFIpLx5QWeAyC6zaph
         t9Sg==
X-Gm-Message-State: AOAM533Qnf397qhg/5U00FA6C0wdEbYasDjx4ZX44VF6Eg20cP5p4Ccu
        ZZEYqgHBvLZdRMS/MR3ZoJIl6JfGLffqmH5B/zlEhhYea4Tllp99vAYpd8u6xRvAl3BbC/Tfoku
        SLKx+cEBg3XsA
X-Received: by 2002:adf:dcd1:: with SMTP id x17mr18076326wrm.59.1627919220029;
        Mon, 02 Aug 2021 08:47:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxKJ0oh7T9bL3qnP5LMKCiXliBLU7Zbaacor1yX+gUNmJc7/SXOmdfjRXe8LvdFZ+x7zCoTAQ==
X-Received: by 2002:adf:dcd1:: with SMTP id x17mr18076294wrm.59.1627919219812;
        Mon, 02 Aug 2021 08:46:59 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id o28sm12119412wra.71.2021.08.02.08.46.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Aug 2021 08:46:59 -0700 (PDT)
Subject: Re: [RFC PATCH v2 00/69] KVM: X86: TDX support
To:     Sean Christopherson <seanjc@google.com>
Cc:     isaku.yamahata@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        isaku.yamahata@gmail.com
References: <cover.1625186503.git.isaku.yamahata@intel.com>
 <0d453d76-11e7-aeb9-b890-f457afbb6614@redhat.com>
 <YQGLJrvjTNZAqU61@google.com>
 <dc4c3fce-4d10-349c-7b21-00a64eaa9f71@redhat.com>
 <YQgLRLPz3YNiIVK6@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <72587835-d315-a1bb-b240-e957a586da7c@redhat.com>
Date:   Mon, 2 Aug 2021 17:46:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YQgLRLPz3YNiIVK6@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/08/21 17:12, Sean Christopherson wrote:
>> Fair enough (though, for patch 2, it's a bit weird to have vmxoff in
>> virtext.h and not vmxon).
> I don't really disagree, but vmxoff is already in virtext.h for the emergency
> reboot stuff.  This series only touches the vmxon code.
> 

Yes, that's what I meant.  But anyway I've dequeued them.

Paolo

