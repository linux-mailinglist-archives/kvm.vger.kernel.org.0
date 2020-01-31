Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD0214F3BE
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2020 22:27:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbgAaV1d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jan 2020 16:27:33 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:24589 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726109AbgAaV1d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jan 2020 16:27:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580506052;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FU2nxODLdOz7Yi+32+hHI/RXv+nZoblPZOI/rmsa0cA=;
        b=P2ypfFLqk1lw11BlnG/iuI5LWyVQibZOnIQbkkUKLHW4v9/V8KDpRhaZ/VbQdAsn06GO+c
        KwxRVtp/uX2qqtI0GlIh8tW8nGn69VyXZv8XO1vv/z4j5Rsm8lYjiUILmNq9qvOUnTSczp
        Kq0do7DtG95tcF4VdDG3fi5lYtJbdko=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-233-bAYmRwJqNHaOcnYtzwrq3A-1; Fri, 31 Jan 2020 16:27:28 -0500
X-MC-Unique: bAYmRwJqNHaOcnYtzwrq3A-1
Received: by mail-wm1-f71.google.com with SMTP id b133so2582749wmb.2
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2020 13:27:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FU2nxODLdOz7Yi+32+hHI/RXv+nZoblPZOI/rmsa0cA=;
        b=TxMKvFQR9CzVlpADWAtJaUh7/nC1bwA7NbqsDUs99G/v/f1W9duGSW4bk/NAO72vmp
         +YQ9YqkgFykcnAPUG/kC7/wc7KBw9RI/eG581FArz1VOOY+um6tcEzn8cwhpNqJTDYxT
         tRuak0zQONe3xc/z3r1W/WpQ9/+KWTMbAVERPLt2nR035wFerYtKBtwYGDg0pJydaV5k
         XTWtWn0zaBwZ1S0mFSBhiU15TsoxXtrbbyxUQB3qd7VxVVAfZLKy5cUs+zUbeYONxLGz
         cbbg23bJC7pVUDiri4xbICJsIcSanVBFegYbMvEIYXaBidhZ/slwFYxD1UdPJHwi52jn
         jT3Q==
X-Gm-Message-State: APjAAAWnI7LCvQL0PuVuV/0zpgDT3ns87trgw1P4Yv2x2F+BxGcll36z
        w89bwkliYuqULMJpdT+QHlv6XyYWnlDQSLhKdFCG+c/ERy+Lt4m/d6BRuhjWtWe90J5jyg2Ha1t
        UBfMdMVLQ+SPS
X-Received: by 2002:a1c:9e89:: with SMTP id h131mr13985470wme.161.1580506047670;
        Fri, 31 Jan 2020 13:27:27 -0800 (PST)
X-Google-Smtp-Source: APXvYqzDuT1Hr2oALN/34Ebj0g8Dpq0xQbqotT/kxpAEYNH3SraZ1fzxVmsS+FAPdBhXC0oAT3CUXQ==
X-Received: by 2002:a1c:9e89:: with SMTP id h131mr13985457wme.161.1580506047457;
        Fri, 31 Jan 2020 13:27:27 -0800 (PST)
Received: from [192.168.42.35] (93-33-8-199.ip42.fastwebnet.it. [93.33.8.199])
        by smtp.gmail.com with ESMTPSA id s8sm12589059wrt.57.2020.01.31.13.27.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jan 2020 13:27:27 -0800 (PST)
Subject: Re: [GIT PULL] First batch of KVM changes for 5.6 merge window
To:     Borislav Petkov <bp@suse.de>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
References: <1580408442-23916-1-git-send-email-pbonzini@redhat.com>
 <CAHk-=wjZTUq8u0HZUJ1mKZjb-haBFhX+mKcUv3Kdh9LQb8rg4g@mail.gmail.com>
 <a7038958-bbab-4c53-72f0-ece46dc99b4d@redhat.com>
 <20200131212404.GD14851@zn.tnic>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d0e15553-e8b6-0624-3978-d2ac02a4d06f@redhat.com>
Date:   Fri, 31 Jan 2020 22:27:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200131212404.GD14851@zn.tnic>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/01/20 22:24, Borislav Petkov wrote:
>> I was supposed to get a topic branch and fix everything up so that both
>> CPU_BASED_ and VMX_FEATURE_ constants would get the new naming.  When
>> Boris alerted me of the conflict and I said "thanks I'll sort it out",
>> he probably interpreted it as me not needing the topic branch anymore.
>> I then forgot to remind him, and here we are.
>
> Damn, that was a misunderstanding. I actually had a topic branch:
> tip:x86/cpu and was assuming that you'll see it from the tip-bot
> notifications. But they went to lkml and you weren't CCed. And
> regardless, I should've told you explicitly which one it is, sorry about
> that. I'll be more explicit next time.

No problem, it's fair to say that we both did our best to mess this up. :)

Paolo

