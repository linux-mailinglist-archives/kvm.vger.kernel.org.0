Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72FE01885CE
	for <lists+kvm@lfdr.de>; Tue, 17 Mar 2020 14:33:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbgCQNdH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Mar 2020 09:33:07 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:21946 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726680AbgCQNdG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 17 Mar 2020 09:33:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584451985;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E7zuFhHvHX7D775C7MaAaYJ92gT6oGYTA6DTapmetfQ=;
        b=PLMvdquGPSGBp3oR81dnOrldF+YJoZG/am2KKsUZPgP6Z7M/J9TYQ5uGVbgvBtR7NqRTJf
        WUpEasSqH+OhWKrObtG/1/7gKeteTysw2pF51n2T+YMca6igcj4WQMuknqjJO8kh8G44W7
        xeI09jcUDF0x5dWLxaKieGwkMLlvK+Q=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-172-sdmi6ThZOfqsaYeTRPWxzQ-1; Tue, 17 Mar 2020 09:33:03 -0400
X-MC-Unique: sdmi6ThZOfqsaYeTRPWxzQ-1
Received: by mail-wr1-f69.google.com with SMTP id q18so10671892wrw.5
        for <kvm@vger.kernel.org>; Tue, 17 Mar 2020 06:33:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=E7zuFhHvHX7D775C7MaAaYJ92gT6oGYTA6DTapmetfQ=;
        b=W0ivO8kPjioBTQo7i6lWQV0pVQjnidGbChZdvZQVDw/yPC3O4FQrRa1DsRWIBhh+qW
         FOg68y75RM1qC17iOUs06Z+ecLEeIScTZMp/3Ax5dXGpDsMTMjejfCA7QX7npzVGWrs3
         IGxkvB3QJL2L7QqfyeomLl4ABfcUm2YF/pI2+LGBBIKTGN9ASBCf0JxF7QOwXV9yunSe
         blAQSJf/reQUWsaL3KetiqXl8I8dgdrRF8JwQIFBspQmbKQ/aAlB6Uiww57BvAYeZOVr
         ZfL240q6mspaf7D/GmJYRh2lX/dIzdq2emu8VWtqhO/In7bUtBSFRnJ7jpf/93Z84acx
         BcKQ==
X-Gm-Message-State: ANhLgQ3f7PKuJScOJHM/A/fiyEr9cojqdjHKIerv57ABdMDMgqNu3091
        N3dlE2N0Ztfg3pImuyjtCYMDQ3NoYtpU4Q3U+kIjDL2i1N2+k3Q3kQic0M340NckgO1wjf0nI2Q
        mESM1maiFx4kr
X-Received: by 2002:adf:e28b:: with SMTP id v11mr6461863wri.229.1584451982198;
        Tue, 17 Mar 2020 06:33:02 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vspUP3POi8cWqgPs4xPdU+s8VhcdCjcztAf0aeGYxZCMh0t962xvNKlG2AksRcBDXZWLM0WYw==
X-Received: by 2002:adf:e28b:: with SMTP id v11mr6461836wri.229.1584451981915;
        Tue, 17 Mar 2020 06:33:01 -0700 (PDT)
Received: from [192.168.178.58] ([151.21.15.227])
        by smtp.gmail.com with ESMTPSA id r1sm4073476wmh.0.2020.03.17.06.33.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Mar 2020 06:33:01 -0700 (PDT)
Subject: Re: [PATCH RFC 0/4] KVM: MIPS: Provide arch-specific
 kvm_flush_remote_tlbs()
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-mips@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20200207223520.735523-1-peterx@redhat.com>
 <44ba59d6-39a5-4221-1ae6-41e5a305d316@redhat.com>
 <20200311183201.GK479302@xz-x1>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2db8490e-e4a0-79d0-5088-a9571b01703d@redhat.com>
Date:   Tue, 17 Mar 2020 14:33:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200311183201.GK479302@xz-x1>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/03/20 19:32, Peter Xu wrote:
> On Wed, Feb 12, 2020 at 01:25:30PM +0100, Paolo Bonzini wrote:
>> On 07/02/20 23:35, Peter Xu wrote:
>>> [This series is RFC because I don't have MIPS to compile and test]
>>>
>>> kvm_flush_remote_tlbs() can be arch-specific, by either:
>>>
>>> - Completely replace kvm_flush_remote_tlbs(), like ARM, who is the
>>>   only user of CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL so far
>>>
>>> - Doing something extra before kvm_flush_remote_tlbs(), like MIPS VZ
>>>   support, however still wants to have the common tlb flush to be part
>>>   of the process.  Could refer to kvm_vz_flush_shadow_all().  Then in
>>>   MIPS it's awkward to flush remote TLBs: we'll need to call the mips
>>>   hooks.
>>>
>>> It's awkward to have different ways to specialize this procedure,
>>> especially MIPS cannot use the genenal interface which is quite a
>>> pity.  It's good to make it a common interface.
>>>
>>> This patch series removes the 2nd MIPS usage above, and let it also
>>> use the common kvm_flush_remote_tlbs() interface.  It should be
>>> suggested that we always keep kvm_flush_remote_tlbs() be a common
>>> entrance for tlb flushing on all archs.
>>>
>>> This idea comes from the reading of Sean's patchset on dynamic memslot
>>> allocation, where a new dirty log specific hook is added for flushing
>>> TLBs only for the MIPS code [1].  With this patchset, logically the
>>> new hook in that patch can be dropped so we can directly use
>>> kvm_flush_remote_tlbs().
>>>
>>> TODO: We can even extend another common interface for ranged TLB, but
>>> let's see how we think about this series first.
>>>
>>> Any comment is welcomed, thanks.
>>>
>>> Peter Xu (4):
>>>   KVM: Provide kvm_flush_remote_tlbs_common()
>>>   KVM: MIPS: Drop flush_shadow_memslot() callback
>>>   KVM: MIPS: Replace all the kvm_flush_remote_tlbs() references
>>>   KVM: MIPS: Define arch-specific kvm_flush_remote_tlbs()
>>>
>>>  arch/mips/include/asm/kvm_host.h |  7 -------
>>>  arch/mips/kvm/Kconfig            |  1 +
>>>  arch/mips/kvm/mips.c             | 22 ++++++++++------------
>>>  arch/mips/kvm/trap_emul.c        | 15 +--------------
>>>  arch/mips/kvm/vz.c               | 14 ++------------
>>>  include/linux/kvm_host.h         |  1 +
>>>  virt/kvm/kvm_main.c              | 10 ++++++++--
>>>  7 files changed, 23 insertions(+), 47 deletions(-)
>>>
>>
>> Compile-tested and queued.
> 
> Just in case it fells through the crach - Paolo, do you still have
> plan to queue this again?

Yes, I wanted to make it compile first though.  I'm undecided between
queuing your series and killing KVM MIPS honestly.

Paolo

