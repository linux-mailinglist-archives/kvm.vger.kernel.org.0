Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 331381A36CA
	for <lists+kvm@lfdr.de>; Thu,  9 Apr 2020 17:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728099AbgDIPRk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Apr 2020 11:17:40 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:43055 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727855AbgDIPRk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Apr 2020 11:17:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586445459;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xz/x7+R3F325gRCdi+IZ/dfc0jmeQMCDLQzXTFYiwII=;
        b=ILHC9TwdRqFWUn1c4+2x2uVdf+FZ1IpXuI/ougN8rK9Q+gqm7spcKO9e603l3m8FQClLOx
        qCdF5jhzmDl04oD0GqWynalKoO7P2HaYAlGUC6gznt9YSpE3mF6LdyyLSec8G9pi05Rs55
        h1vV6f/Z0btHZlKvBctnmUFi4foSJbQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-330-PrIdMgcTO9y1RYJCscSgzg-1; Thu, 09 Apr 2020 11:17:36 -0400
X-MC-Unique: PrIdMgcTO9y1RYJCscSgzg-1
Received: by mail-wr1-f71.google.com with SMTP id c8so6529801wru.20
        for <kvm@vger.kernel.org>; Thu, 09 Apr 2020 08:17:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Xz/x7+R3F325gRCdi+IZ/dfc0jmeQMCDLQzXTFYiwII=;
        b=YREa0j9eVf8UUixh9oLj6NaoJ0MHoJwrOpaQsdCQ7dwmU8k5/MK3rtM83QGFOIU/Cj
         RAmPro4TbDd9Pz3aJhZMRESujf+xtOus7qWmp1/LDxdwxS0vXZcgqgHWjJOBFD2eHKXU
         g3I6PupTeK+j/Rwf/87hLZb85hcGfPF6s94qpje6jvLcLEyO65YHp8DKyvyPh+Z1i1EX
         7JtoiOfuZ8n7YqzGkMHBt6nwzlLWGoIbN4L6N3ndxKEbpRu1g0tqifUpLbCYKLIgxPBi
         zCyVXRliZVybs8VRU0IniDxUmZRe7aFGEyIuzN4NAYTIIeCzEme1mMG4oPYg36BCElam
         b55w==
X-Gm-Message-State: AGi0PubnCipPAMva3EUMgHhrtsBj49yRyfBAqTA9SJpXVG9dNJXO2Cov
        uQLaBHPlypCt9KrG1dNSEl3zILgBSKHHd7Zij8JE5f5AprxB0gbP/nnXKrJW8UrxyD5o6Pj+QBM
        /2Tr9BnGMhx3h
X-Received: by 2002:a5d:6183:: with SMTP id j3mr14822040wru.83.1586445454641;
        Thu, 09 Apr 2020 08:17:34 -0700 (PDT)
X-Google-Smtp-Source: APiQypIHzBMEQqCXfIoBEX+rooZW9MeTLAzADd/bCoZQger9W2poqui6FuOadw72A9pT8T34FS1Qfg==
X-Received: by 2002:a5d:6183:: with SMTP id j3mr14822020wru.83.1586445454436;
        Thu, 09 Apr 2020 08:17:34 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id w15sm31255987wra.25.2020.04.09.08.17.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Apr 2020 08:17:33 -0700 (PDT)
Subject: Re: [PATCH v2] x86/kvm: Disable KVM_ASYNC_PF_SEND_ALWAYS
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Andrew Cooper <andrew.cooper3@citrix.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>, stable <stable@vger.kernel.org>
References: <c09dd91f-c280-85a6-c2a2-d44a0d378bbc@redhat.com>
 <4EB5D96F-F322-45BB-9169-6BF932D413D4@amacapital.net>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <931f6e6d-ac17-05f9-0605-ac8f89f40b2b@redhat.com>
Date:   Thu, 9 Apr 2020 17:17:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <4EB5D96F-F322-45BB-9169-6BF932D413D4@amacapital.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/04/20 17:03, Andy Lutomirski wrote:
>> No, I think we wouldn't use a paravirt #VE at this point, we would
>> use the real thing if available.
>> 
>> It would still be possible to switch from the IST to the main
>> kernel stack before writing 0 to the reentrancy word.
> 
> Almost but not quite. We do this for NMI-from-usermode, and it’s
> ugly. But we can’t do this for NMI-from-kernel or #VE-from-kernel
> because there might not be a kernel stack.  Trying to hack around
> this won’t be pretty.
> 
> Frankly, I think that we shouldn’t even try to report memory failure
> to the guest if it happens with interrupts off. Just kill the guest
> cleanly and keep it simple. Or inject an intentionally unrecoverable
> IST exception.

But it would be nice to use #VE for all host-side page faults, not just
for memory failure.

So the solution would be the same as for NMIs, duplicating the stack
frame and patching the outer handler's stack from the recursive #VE
(https://lwn.net/Articles/484932/).  It's ugly but it's a known ugliness.

Paolo

