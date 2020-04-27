Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01DF81BAD92
	for <lists+kvm@lfdr.de>; Mon, 27 Apr 2020 21:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbgD0TKd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 15:10:33 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44308 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726625AbgD0TKc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Apr 2020 15:10:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588014631;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I0hVk/6G0HDWyNl0uhimzd8WziWxl6KqqJxBVaLL5oQ=;
        b=hCsBavfIAGzn5beDL74mx6H13Hth5Zov2UcUkl2uFuWld2oVSP3J5U0lSL5nxCuw6t5KTY
        a2GR/bAgfb3W11qKRsPG12/eEyf6kHUccpAcX0qdGoOvMuPc6zA0B1d2nOiKh7yXQX/Mni
        BE2XpcfKSuyvi7v2zFPP9Nmb3VWR6YI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-133-FfaFKMHhMzy6zrvA7XdKHw-1; Mon, 27 Apr 2020 15:10:29 -0400
X-MC-Unique: FfaFKMHhMzy6zrvA7XdKHw-1
Received: by mail-wm1-f71.google.com with SMTP id t62so55637wma.0
        for <kvm@vger.kernel.org>; Mon, 27 Apr 2020 12:10:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=I0hVk/6G0HDWyNl0uhimzd8WziWxl6KqqJxBVaLL5oQ=;
        b=BS9zHYkDEroOTeK4l6GDw+rwonJ/S/xVfgO2fC2q1BJds1i6DM5DxIcuaWHbNMM4b1
         SBjEw/lJJboT/Jd/q66mQX3AdgjTf1MJXqTRiZzn+P9WpV1AK4ydpl7KGbSTLvnJh7rV
         Fc1DHDNF4UL+nRHw6VOq2RxBrGXaifCUpD5X7Q6iKPQNfe2R9IYbGFao0FpYGwjWp6zk
         aiMxupQaMm+J/n/ow9BTH7zIBENukQqBgDgLPsV0gXTMThWnIpmzLMM7wXKWdyl/D8L2
         CDBIKZ3tPS0N4TyaIu/cAickvHBgTpfmzXO0XkHtNSaFk7bcrTZWovNTs1Q0pUBLOMhQ
         ZTVg==
X-Gm-Message-State: AGi0PuY3xEKTzcmO6DnVQ94ooJmYZcX0xv5QJ3ksnld+xifnsp6u4JSr
        Qcqa4HVe4+COQH89TxwEVCboDS9e0rvKprFeYm9W6YoUJCyZnpxPPoNDPFXvI0VssTOfBdBN+kL
        tIb0qGGgekLxE
X-Received: by 2002:adf:cd04:: with SMTP id w4mr30392824wrm.357.1588014628250;
        Mon, 27 Apr 2020 12:10:28 -0700 (PDT)
X-Google-Smtp-Source: APiQypIILVoJz/qNWYWE3ErDemAwYqp/nA424nLm5ZyRRhg+ICEM+y/HKkvpU9uy47Xz8+V0QcM6PQ==
X-Received: by 2002:adf:cd04:: with SMTP id w4mr30392803wrm.357.1588014628029;
        Mon, 27 Apr 2020 12:10:28 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ac19:d1fb:3f5f:d54f? ([2001:b07:6468:f312:ac19:d1fb:3f5f:d54f])
        by smtp.gmail.com with ESMTPSA id k9sm23532061wrd.17.2020.04.27.12.10.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2020 12:10:27 -0700 (PDT)
Subject: Re: [PATCH] [RFC] kvm: x86: emulate APERF/MPERF registers
To:     Jim Mattson <jmattson@google.com>,
        "Li,Rongqing" <lirongqing@baidu.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        "H . Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <1587704935-30960-1-git-send-email-lirongqing@baidu.com>
 <20200424100143.GZ20730@hirez.programming.kicks-ass.net>
 <20200424144625.GB30013@linux.intel.com>
 <CALMp9eQtSrZMRQtxa_Z5WmjayWzJYhSrpNkQbqK5b7Ufxg-cMA@mail.gmail.com>
 <ce51d5f9-aa7b-233b-883d-802d9b00e090@redhat.com>
 <fd2a8092edf54a85979e5781dc354690@baidu.com>
 <CALMp9eQrGuqzy_ZRu+qU3A7PRkoi8JHWFRpm---cMhp9+J4j8A@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f3c2cc31-6388-f7b5-48fd-fb19d059eea3@redhat.com>
Date:   Mon, 27 Apr 2020 21:10:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eQrGuqzy_ZRu+qU3A7PRkoi8JHWFRpm---cMhp9+J4j8A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/04/20 19:30, Jim Mattson wrote:
>>>> I would like to see performance data before enabling this
>>>> unconditionally.
>>> I wouldn't want this to be enabled unconditionally anyway,
>>> because you need to take into account live migration to and from
>>> processors that do not have APERF/MPERF support.
>>> 
>>> Paolo
>> I will add a kvm parameter to consider whether enable MPERF/APERF
>> emulations, and make default value to false
>
> Wouldn't it be better to add a per-VM capability to enable this
> feature?

Yes, you it would be better to use KVM_ENABLE_CAP indeed.

Paolo

