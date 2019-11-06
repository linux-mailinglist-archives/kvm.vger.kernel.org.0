Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 762E2F15EE
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2019 13:17:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730091AbfKFMRo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Nov 2019 07:17:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45946 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727961AbfKFMRo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Nov 2019 07:17:44 -0500
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EDA427C084
        for <kvm@vger.kernel.org>; Wed,  6 Nov 2019 12:17:43 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id l3so5572786wrx.21
        for <kvm@vger.kernel.org>; Wed, 06 Nov 2019 04:17:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3JkGp+uV4EX2YLZVMnoCzXMV7AWPPY0mdAbm7lpOXew=;
        b=FEqTbeqF5vSY4EzQ312qUtLlsMFgNlWb3guA91Oo/W5ndj179WS+tJVbNhMJ8Ixd4E
         Y6kKuZ8/dqf/kIF+Ym0Y03YO+wRJgn5JV5SYOV4IQeQYEtsJDS28VgomdAXNRemANbqQ
         1cQUhXCsqFXd4nLJv2m8pbVfyQLuqp2A8m6avum4DFdFBT7Jz8pTrvJFeum9CN8S/y1I
         KYu9Mf8rujELo3+Ey2HVPzoH8/MtE9xFKMUhdgSUzTncXYXiUUNxiHY+kMZrmfV2w6DL
         L8iUNc4hOBk6nnn01vIk1w/6CU+TOtySSGHdU+AVBZR0F6v1qArQwwZfwvw9D7ATrUFL
         CRNQ==
X-Gm-Message-State: APjAAAVWoDwFAqGfXjNnHUcEhX3h5UPZHqz6YkhGHerGERgG4QpBHe5w
        v1OiqfhwTxwKomKiqfD7kgp5jU2hwTmTrI+NoSfT2AwP4vijg81ieh7APss10+F8WbEL7lTOCsE
        OFehOPtLIjsjY
X-Received: by 2002:adf:e94e:: with SMTP id m14mr2467685wrn.233.1573042662554;
        Wed, 06 Nov 2019 04:17:42 -0800 (PST)
X-Google-Smtp-Source: APXvYqwQJTB+/eQhKDoIKLZpiIrACRJvyGIu0CSnXiN36tE+zV7iuxwSMzhyus8+dHVO26p11jq30w==
X-Received: by 2002:adf:e94e:: with SMTP id m14mr2467638wrn.233.1573042661943;
        Wed, 06 Nov 2019 04:17:41 -0800 (PST)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id x7sm46454174wrg.63.2019.11.06.04.17.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Nov 2019 04:17:41 -0800 (PST)
Subject: Re: [PATCH v2 00/14] KVM: x86: Remove emulation_result enums
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Alexander Graf <graf@amazon.com>
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Liran Alon <liran.alon@oracle.com>
References: <20190827214040.18710-1-sean.j.christopherson@intel.com>
 <8dec39ac-7d69-b1fd-d07c-cf9d014c4af3@redhat.com>
 <686b499e-7700-228e-3602-8e0979177acb@amazon.com>
 <20191106005806.GK23297@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <3d827e8b-a04e-0a93-4bb4-e0e9d59036da@redhat.com>
Date:   Wed, 6 Nov 2019 13:17:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191106005806.GK23297@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/11/19 01:58, Sean Christopherson wrote:
>> enum kvm_return {
>>     KVM_RET_USER_EXIT = 0,
>>     KVM_RET_GUEST = 1,
>> };
>>
>> and then consistently use them as return values? That way anyone who has not
>> worked on kvm before can still make sense of the code.
> Hmm, I think it'd make more sense to use #define instead of enum to
> hopefully make it clear that they aren't the *only* values that can be
> returned.  That'd also prevent anyone from changing the return types from
> 'int' to 'enum kvm_return', which IMO would hurt readability overall.
> 
> And maybe KVM_EXIT_TO_USERSPACE and KVM_RETURN_TO_GUEST?

That would be quite some work.  Right now there is some consistency
between all of:

- x86_emulate_instruction and its callers

- vcpu->arch.complete_userspace_io

- vcpu_enter_guest/vcpu_block

- kvm_x86_ops->handle_exit

so it would be very easy to end up with a half-int-half-enum state that
is more confusing than before...

I'm more worried about cases where we have functions returning either 0
or -errno, but 0 lets you enter the guest.  I'm not sure if the only one
is kvm_mmu_reload or there are others.

Paolo
