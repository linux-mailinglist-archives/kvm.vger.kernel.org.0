Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2687123801
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 15:28:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731953AbfETN20 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 09:28:26 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44982 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727319AbfETN2Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 09:28:25 -0400
Received: by mail-wr1-f68.google.com with SMTP id w13so3864912wru.11
        for <kvm@vger.kernel.org>; Mon, 20 May 2019 06:28:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NrkZvAEDWXv/HS9Bju0L0ls+uMkGzRifZPjkgjwuCy4=;
        b=U+V0ssoPz1c0Wn4LDgFHqMNR52EbvythE5FSjtj47IIb9onsgfCRi753KY0znIolwi
         7lu3lmxdGei9PB/GOmcHcwnyhF66de2bvsF6s6RHpsP8L8YApzEer/H7SUzOHdEsOz4N
         AK8QGSHMZO/apwhc9f7wqobPRoDhxqsHVathH7fVBdpD/bSdU5qEtRUGIHIf0ISKuRsF
         MeJGXhg8fbu16tFQtz6iboDlub4SKqfUJ4DZIWAP/U1OSR9SEGKjVXHRHDikB17MVLI8
         lLjwLJ90OWZuikTrXdTwatOS+WQxcVFtpWcFVbR3JVmbuptj1q7W4+fMCDpCEVi2vE5K
         XNLQ==
X-Gm-Message-State: APjAAAUmmh6n3by7m7DPncokPLFuouOHlj1JwbKFJeKtYIuUQmpKuXx6
        OuL/SA/KA79Tg8+79+ShBm+D5RyoZaFBXw==
X-Google-Smtp-Source: APXvYqzm8QDvEKA8/b/yxIXNcM9hXgSwj9yYAAnoGRucn0lA/jTxYmM+JmVk5rzBPl5e86SyickEkg==
X-Received: by 2002:adf:ec0f:: with SMTP id x15mr45248169wrn.120.1558358903760;
        Mon, 20 May 2019 06:28:23 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ac04:eef9:b257:b844? ([2001:b07:6468:f312:ac04:eef9:b257:b844])
        by smtp.gmail.com with ESMTPSA id h15sm17131771wru.52.2019.05.20.06.28.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 06:28:23 -0700 (PDT)
Subject: Re: [PATCH 3/3] tests: kvm: Add tests for KVM_SET_NESTED_STATE
To:     Thomas Huth <thuth@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>, rkrcmar@redhat.com,
        jmattson@google.com, marcorr@google.com, kvm@vger.kernel.org
Cc:     Peter Shier <pshier@google.com>, Andrew Jones <drjones@redhat.com>
References: <20190502183141.258667-1-aaronlewis@google.com>
 <120edfea-4200-8ab9-981b-d49cfea02d5d@redhat.com>
 <5e068c9b-570b-07ff-8af7-65b0d3f49174@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f55847d3-bc5a-1928-e912-ad332c4e641d@redhat.com>
Date:   Mon, 20 May 2019 15:28:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <5e068c9b-570b-07ff-8af7-65b0d3f49174@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/05/19 15:07, Thomas Huth wrote:
> On 08/05/2019 14.05, Paolo Bonzini wrote:
>> On 02/05/19 13:31, Aaron Lewis wrote:
>>> Add tests for KVM_SET_NESTED_STATE and for various code paths in its implementation in vmx_set_nested_state().
>>>
>>> Signed-off-by: Aaron Lewis <aaronlewis@google.com>
>>> Reviewed-by: Marc Orr <marcorr@google.com>
>>> Reviewed-by: Peter Shier <pshier@google.com>
>>> ---
>>>  tools/testing/selftests/kvm/.gitignore        |   1 +
>>>  tools/testing/selftests/kvm/Makefile          |   1 +
>>>  .../testing/selftests/kvm/include/kvm_util.h  |   4 +
>>>  tools/testing/selftests/kvm/lib/kvm_util.c    |  32 ++
>>>  .../kvm/x86_64/vmx_set_nested_state_test.c    | 275 ++++++++++++++++++
>>>  5 files changed, 313 insertions(+)
>>>  create mode 100644 tools/testing/selftests/kvm/x86_64/vmx_set_nested_state_test.c
>>>
>>> diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
>>> index 2689d1ea6d7a..bbaa97dbd19e 100644
>>> --- a/tools/testing/selftests/kvm/.gitignore
>>> +++ b/tools/testing/selftests/kvm/.gitignore
>>> @@ -6,4 +6,5 @@
>>>  /x86_64/vmx_close_while_nested_test
>>>  /x86_64/vmx_tsc_adjust_test
>>>  /x86_64/state_test
>>> +/x86_64/vmx_set_nested_state_test
>>>  /dirty_log_test
>>> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
>>> index f8588cca2bef..10eff4317226 100644
>>> --- a/tools/testing/selftests/kvm/Makefile
>>> +++ b/tools/testing/selftests/kvm/Makefile
>>> @@ -20,6 +20,7 @@ TEST_GEN_PROGS_x86_64 += x86_64/evmcs_test
>>>  TEST_GEN_PROGS_x86_64 += x86_64/hyperv_cpuid
>>>  TEST_GEN_PROGS_x86_64 += x86_64/vmx_close_while_nested_test
>>>  TEST_GEN_PROGS_x86_64 += x86_64/smm_test
>>> +TEST_GEN_PROGS_x86_64 += x86_64/vmx_set_nested_state_test
>>>  TEST_GEN_PROGS_x86_64 += dirty_log_test
>>>  TEST_GEN_PROGS_x86_64 += clear_dirty_log_test
>>>  
>>> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
>>> index 07b71ad9734a..8c6b9619797d 100644
>>> --- a/tools/testing/selftests/kvm/include/kvm_util.h
>>> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
>>> @@ -118,6 +118,10 @@ void vcpu_events_get(struct kvm_vm *vm, uint32_t vcpuid,
>>>  		     struct kvm_vcpu_events *events);
>>>  void vcpu_events_set(struct kvm_vm *vm, uint32_t vcpuid,
>>>  		     struct kvm_vcpu_events *events);
>>> +void vcpu_nested_state_get(struct kvm_vm *vm, uint32_t vcpuid,
>>> +			   struct kvm_nested_state *state);
>>> +int vcpu_nested_state_set(struct kvm_vm *vm, uint32_t vcpuid,
>>> +			  struct kvm_nested_state *state, bool ignore_error);
>>>  
> [...]
>>
>> Queued all three, thanks.
> 
> struct kvm_nested_state is only declared on x86 ... so this currently
> fails for me when compiling the kvm selftests for s390x:
> 
> include/kvm_util.h:124:14: warning: ‘struct kvm_nested_state’ declared
> inside parameter list will not be visible outside of this definition or
> declaration
>        struct kvm_nested_state *state);
>               ^~~~~~~~~~~~~~~~
> include/kvm_util.h:126:13: warning: ‘struct kvm_nested_state’ declared
> inside parameter list will not be visible outside of this definition or
> declaration
>       struct kvm_nested_state *state, bool ignore_error);
>              ^~~~~~~~~~~~~~~~
> 
> ... so I guess these functions should be wrapped with "#ifdef __x86_64__" ?

Yes, please.

Paolo

