Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E27326D518A
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 21:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232450AbjDCTqD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 15:46:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232532AbjDCTpy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 15:45:54 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78CCA2D7E
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 12:45:47 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id e18so30527153wra.9
        for <kvm@vger.kernel.org>; Mon, 03 Apr 2023 12:45:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1680551146;
        h=in-reply-to:from:references:cc:to:content-language:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=819P3QaQV7iAjXbs9vWMCsVbGF1CRSRCWff7gfHGntk=;
        b=wie+cCZ6KfKos7waltEDOrbIcs+ODqNNgDP3zg2I0uFLXCtjKuGphb4ZGl+s+ZK0gP
         aIo5kJFx97AyBgmJJkim1aKelvKpt6lm2wro2AcxAKQYR9Ws4SjXbeMF3IjvmYCJW7yR
         qSuzCks0aGgyfLHd8Asuk/hOkPv3y20sU4B5fgzs9GxlBOzQFuM/qf+UO7YBJp60eoqb
         8nOJ4S5MM+ZsPbNrzg8iJR+PXgkb/5EFH06jCH8LHrN5POt3r2GmRUBzZdF1QpMPk/Qs
         g6YG2S10HwoLBSRCBGeOLgeiqsbw3iPYWAM0qQLU7uL5S7cIkCZhZ8vhwiZeIocUEfGp
         AjQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680551146;
        h=in-reply-to:from:references:cc:to:content-language:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=819P3QaQV7iAjXbs9vWMCsVbGF1CRSRCWff7gfHGntk=;
        b=Urvr+/6Q/hEPpCRDC7O941tbs5mhhfwaXDn7Km7gK/1LZZJZ/ZI+0xhqOJPZjEr29p
         0VgXAoezWpnxLBU8j+xE0zxc7Bbt+OPFQgMOBK9ysEKb+KrK1Tt1EytES/NblepUEqWm
         nMvDEWvC7+s1YmMPYuHLuAT3siVo0auPMTCHb1cHwLggwSXsKAbqprZ/GvTSYjDfM54N
         rfza3GZHaVDJ/JAwFjpNqHakAC9AxJstgb2RPS4o7JSG1FSZzp7VrNWBY1/Zbahs0YLF
         /vnTDVo7Yo3bVrRkDCeogsBDvTKYMgpZiuQMh6FzhLwdBVIQSDGUHEMF16hkB6zG2XH0
         yzSQ==
X-Gm-Message-State: AAQBX9dNddvuakyOPo0C7eKnYqJ0q3bskatZqoAf+wFuUiri3gXgYXNz
        G3IoGT5XU7WE//dNUW7U9pGuJw==
X-Google-Smtp-Source: AKy350Z7StbVBTscEUoEyv9+3tMWokSteL5nrnYUFm2NRxM2xsC5MmQhXl7Z2fMe+uYz7TDlslcvnQ==
X-Received: by 2002:a05:6000:1009:b0:2cf:f01f:ed89 with SMTP id a9-20020a056000100900b002cff01fed89mr26460828wrx.24.1680551145855;
        Mon, 03 Apr 2023 12:45:45 -0700 (PDT)
Received: from ?IPV6:2003:f6:af22:1600:2f4c:bf50:182f:1b04? (p200300f6af2216002f4cbf50182f1b04.dip0.t-ipconnect.de. [2003:f6:af22:1600:2f4c:bf50:182f:1b04])
        by smtp.gmail.com with ESMTPSA id r16-20020a05600c459000b003f03d483966sm15041763wmo.44.2023.04.03.12.45.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Apr 2023 12:45:45 -0700 (PDT)
Content-Type: multipart/mixed; boundary="------------HflgM7aqJsA4VOByrlkcgdQn"
Message-ID: <a6ac4f81-f7de-1507-9be2-057865cdc516@grsecurity.net>
Date:   Mon, 3 Apr 2023 21:45:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH] kvm: initialize all of the kvm_debugregs structure before
 sending it to userspace
Content-Language: en-US, de-DE
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, stable <stable@kernel.org>,
        Xingyuan Mo <hdthky0@gmail.com>
References: <20230214103304.3689213-1-gregkh@linuxfoundation.org>
 <20230220104050.419438-1-minipli@grsecurity.net>
From:   Mathias Krause <minipli@grsecurity.net>
In-Reply-To: <20230220104050.419438-1-minipli@grsecurity.net>
X-Spam-Status: No, score=-1.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a multi-part message in MIME format.
--------------HflgM7aqJsA4VOByrlkcgdQn
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 20.02.23 11:40, Mathias Krause wrote:
> On 14.02.23 11:33, Greg Kroah-Hartman wrote:
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index da4bbd043a7b..50a95c8082fa 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -5254,12 +5254,11 @@ static void kvm_vcpu_ioctl_x86_get_debugregs(struct kvm_vcpu *vcpu,
>>  {
>>  	unsigned long val;
>>  
>> +	memset(dbgregs, 0, sizeof(*dbgregs));
>>  	memcpy(dbgregs->db, vcpu->arch.db, sizeof(vcpu->arch.db));
>>  	kvm_get_dr(vcpu, 6, &val);
>>  	dbgregs->dr6 = val;
>>  	dbgregs->dr7 = vcpu->arch.dr7;
>> -	dbgregs->flags = 0;
>> -	memset(&dbgregs->reserved, 0, sizeof(dbgregs->reserved));
>>  }
>>  
>>  static int kvm_vcpu_ioctl_x86_set_debugregs(struct kvm_vcpu *vcpu,
> 
> While this change handles the info leak for 32 bit kernels just fine, it
> completely ignores that the ABI is broken for such kernels. The bug
> (existing since the introduction of the API) effectively makes using
> DR1..3 impossible. The memcpy() will only copy half of dbgregs->db and
> effectively only allows setting DR0 to its intended value. The remaining
> registers get shuffled around (lower half of db[1] will end up in DR2,
> not DR1) or completely ignored (db[2..3] which should end up in DR3 and
> DR4). Now, this broken ABI might be considdered "API," so I gave it a
> look...
> 
> A Debian code search gave only three real users of these ioctl()s:
> - VirtualBox ([1], lines 1735 ff.),
> - QEMU ([2], in kvm_put_debugregs(): lines 4491 ff. and
>   kvm_get_debugregs(): lines 4515 ff.) and
> - Linux's KVM selftests ([3], lines 722 ff., used in vcpu_load_state()
>   and vcpu_save_state()).
> 
> Linux's selftest uses the API only to read and bounce back the state --
> doesn't do any sanity checks on it.
> 
> VirtualBox and QEMU, OTOH, assume that the array is properly filled,
> i.e. indices 0..3 map to DR0..3. This means, these users are currently
> (and *always* have been) broken when trying to set DR1..3. Time to get
> them fixed before x86-32 vanishes into irrelevance.
> 
> [1] https://www.virtualbox.org/browser/vbox/trunk/src/VBox/VMM/VMMR3/NEMR3Native-linux.cpp?rev=98193#L1735
> [2] https://gitlab.com/qemu-project/qemu/-/blob/v7.2.0/target/i386/kvm/kvm.c#L4480-4522
> [3] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/tools/testing/selftests/kvm/include/x86_64/processor.h?h=v6.2#n722
> 
> An ABI-breaking^Wfixing change like below might be worth to apply on top
> to get that long standing bug fixed:
> 
> -- >8 --
> Subject: [PATCH] KVM: x86: Fix broken debugregs ABI for 32 bit kernels
> 
> The ioctl()s to get and set KVM's debug registers are broken for 32 bit
> kernels as they'd only copy half of the user register state because of
> the UAPI and in-kernel type mismatch (__u64 vs. unsigned long; 8 vs. 4
> bytes).
> 
> This makes it impossible for userland to set anything but DR0 without
> resorting to bit folding tricks.
> 
> Switch to a loop for copying debug registers that'll implicitly do the
> type conversion for us, if needed.
> 
> This ABI breaking change actually fixes known users [1,2] that have been
> broken since the API's introduction in commit a1efbe77c1fd ("KVM: x86:
> Add support for saving&restoring debug registers").
> 
> Also take 'dr6' from the arch part directly, as we do for 'dr7'. There's
> no need to take the clunky route via kvm_get_dr().
> 
> [1] https://www.virtualbox.org/browser/vbox/trunk/src/VBox/VMM/VMMR3/NEMR3Native-linux.cpp?rev=98193#L1735
> [2] https://gitlab.com/qemu-project/qemu/-/blob/v7.2.0/target/i386/kvm/kvm.c#L4480-4522
> 
> Fixes: a1efbe77c1fd ("KVM: x86: Add support for saving&restoring debug registers")
> Cc: stable <stable@kernel.org>	# needs 2c10b61421a2
> Signed-off-by: Mathias Krause <minipli@grsecurity.net>
> ---
>  arch/x86/kvm/x86.c | 17 ++++++++++++-----
>  1 file changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index a2c299d47e69..db3967de7958 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5261,18 +5261,23 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
>  static void kvm_vcpu_ioctl_x86_get_debugregs(struct kvm_vcpu *vcpu,
>  					     struct kvm_debugregs *dbgregs)
>  {
> -	unsigned long val;
> +	unsigned int i;
>  
>  	memset(dbgregs, 0, sizeof(*dbgregs));
> -	memcpy(dbgregs->db, vcpu->arch.db, sizeof(vcpu->arch.db));
> -	kvm_get_dr(vcpu, 6, &val);
> -	dbgregs->dr6 = val;
> +
> +	BUILD_BUG_ON(ARRAY_SIZE(vcpu->arch.db) != ARRAY_SIZE(dbgregs->db));
> +	for (i = 0; i < ARRAY_SIZE(vcpu->arch.db); i++)
> +		dbgregs->db[i] = vcpu->arch.db[i];
> +
> +	dbgregs->dr6 = vcpu->arch.dr6;
>  	dbgregs->dr7 = vcpu->arch.dr7;
>  }
>  
>  static int kvm_vcpu_ioctl_x86_set_debugregs(struct kvm_vcpu *vcpu,
>  					    struct kvm_debugregs *dbgregs)
>  {
> +	unsigned int i;
> +
>  	if (dbgregs->flags)
>  		return -EINVAL;
>  
> @@ -5281,7 +5286,9 @@ static int kvm_vcpu_ioctl_x86_set_debugregs(struct kvm_vcpu *vcpu,
>  	if (!kvm_dr7_valid(dbgregs->dr7))
>  		return -EINVAL;
>  
> -	memcpy(vcpu->arch.db, dbgregs->db, sizeof(vcpu->arch.db));
> +	for (i = 0; i < ARRAY_SIZE(vcpu->arch.db); i++)
> +		vcpu->arch.db[i] = dbgregs->db[i];
> +
>  	kvm_update_dr0123(vcpu);
>  	vcpu->arch.dr6 = dbgregs->dr6;
>  	vcpu->arch.dr7 = dbgregs->dr7;

Ping? No interest in fixing this for i386?

I've attached a PoC showing the bug. It needs to be run on a 32-bit x86
kernel to actually trigger it. It does, however, only show half of the
bug, as the in-VM state differs from KVM's state, too. However, I was
too lazy to implement a full guest code execution setup (and the in-tree
selftests don't support i386), so you have to believe me or try to
follow my argumentation along with KVM's code.

Thanks,
Mathias
--------------HflgM7aqJsA4VOByrlkcgdQn
Content-Type: text/x-csrc; charset=UTF-8; name="dr_kvm.c"
Content-Disposition: attachment; filename="dr_kvm.c"
Content-Transfer-Encoding: base64

LyoKICogVGVzdCBmb3IgS1ZNJ3MgS1ZNX3tHRVQsU0VUfV9ERUJVR1JFR1MgaW9jdGwoKSBi
ZWluZyBicm9rZW4gZm9yIGkzODYuCiAqIEl0IG9ubHkgY29waWVzIGhhbGYgb2YgdGhlIHJl
Z2lzdGVycyBhbmQgaW50ZXJsZWF2ZXMgdGhlbSBldmVuLgogKgogKiBUaGlzIHRlc3Qgb25s
eSBzaG93cyBoYWxmIG9mIHRoZSBidWcsIGFzIHRoZXJlJ3Mgbm8gd2F5IHRvIHJldHJpZXZl
IHRoZQogKiBpbi1WTSBlZmZlY3RpdmUgZGVidWcgcmVnaXN0ZXJzIHdpdGhvdXQgYWN0dWFs
bHkgcnVubmluZyBjb2RlIGluIHRoZSBWTQogKiBpdHNlbGYgKEkgd2FzIHRvbyBsYXp5IHRv
IGltcGxlbWVudCA6UCkuIEJ1dCBpZiB5b3Ugd291bGQgZG8sIHlvdSdkIHNlZQogKiB0aGF0
IG9uIHRoZSBmaXJzdCBpdGVyYXRpb24gYWxyZWFkeSwgd2hlcmUgd2Ugd2FudCB0byBzZXQg
RFIwIG9ubHksIHdlCiAqIGFjdHVhbGx5IGRvIHNldCBEUjEgdG9vIC0tIERSMCB0byAweGMw
ZmZlZTAsIERSMSB0byAweGJhZGMwZGUwLiBGb3IgdGhlCiAqIHNlY29uZCBpdGVyYXRpb24g
d2UgZmFpbCB0byBzZXQgRFIxIHRvIDB4YzBmZmVlMSBidXQgaW5zdGVhZCBzZXQgRFIyIHRv
CiAqIDB4YzBmZmVlMSBhbmQgRFIzIHRvIDB4YmFkYzBkZTEuCiAqCiAqIENvbXBpbGUgYXM6
CiAqICAgJCBnY2MgLW8gZHJfa3ZtIGRyX2t2bS5jCiAqCiAqIFJ1biBhczoKICogICAkIC4v
ZHJfa3ZtCiAqCiAqIElmIHlvdSdyZSBydW5uaW5pbmcgYSBidWdneSAzMi1iaXQgeDg2IGtl
cm5lbCwgdGhlIG91dHB1dCB3aWxsIGxvb2sgbGlrZQogKiB0aGlzOgogKiAgICQgLi9kcl9r
dm0KICogICBkcl9rdm06IHVuZXhwZWN0ZWQgdmFsdWUgb2YgRFIwICgweGJhZGMwZGUwMGMw
ZmZlZTAsIHNob3VsZCBiZSAweGMwZmZlZTApIGFmdGVyIHNldHRpbmcgRFIwCiAqICAgZHJf
a3ZtOiB1bmV4cGVjdGVkIHZhbHVlIG9mIERSMSAoMHhiYWRjMGRlMTBjMGZmZWUxLCBzaG91
bGQgYmUgMHhjMGZmZWUxKSBhZnRlciBzZXR0aW5nIERSMQogKiAgIGRyX2t2bTogdW5leHBl
Y3RlZCB2YWx1ZSBvZiBEUjIgKDB4MCwgc2hvdWxkIGJlIDB4YzBmZmVlMikgYWZ0ZXIgc2V0
dGluZyBEUjIKICogICBkcl9rdm06IHVuZXhwZWN0ZWQgdmFsdWUgb2YgRFIzICgweDAsIHNo
b3VsZCBiZSAweGMwZmZlZTMpIGFmdGVyIHNldHRpbmcgRFIzCiAqCiAqIE9uIGEgNjQgYml0
IGtlcm5lbCBvciBhIGtlcm5lbCBzaGlwaW5nIHRoZSBmaXhbMV0sIG5vIG91dHB1dCBzaG91
bGQgYmUKICogZ2VuZXJhdGVkLgogKgogKiBbMV0gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcv
a3ZtLzIwMjMwMjIwMTA0MDUwLjQxOTQzOC0xLW1pbmlwbGlAZ3JzZWN1cml0eS5uZXQvCiAq
CiAqIC0gbWluaXBsaQogKi8KCiNpbmNsdWRlIDxsaW51eC9rdm0uaD4KI2luY2x1ZGUgPHN5
cy9pb2N0bC5oPgojaW5jbHVkZSA8c3lzL3N0YXQuaD4KI2luY2x1ZGUgPHVuaXN0ZC5oPgoj
aW5jbHVkZSA8c3RyaW5nLmg+CiNpbmNsdWRlIDxmY250bC5oPgojaW5jbHVkZSA8ZXJyLmg+
CgppbnQgbWFpbih2b2lkKSB7CglzdGF0aWMgY29uc3QgY2hhciBkZXZfa3ZtW10gPSAiL2Rl
di9rdm0iOwoJc3RydWN0IGt2bV9kZWJ1Z3JlZ3MgZGJnX3JlZ3M7CglpbnQga3ZtLCB2bSwg
Y3B1OwoJaW50IHJlcyA9IDA7CglpbnQgaSwgajsKCglrdm0gPSBvcGVuKGRldl9rdm0sIE9f
UkRXUik7CglpZiAoa3ZtIDwgMCkKCQllcnIoMSwgIm9wZW4oJXMpIiwgZGV2X2t2bSk7CgoJ
dm0gPSBpb2N0bChrdm0sIEtWTV9DUkVBVEVfVk0sIE5VTEwpOwoJaWYgKHZtIDwgMCkKCQll
cnIoMSwgImlvY3RsKEtWTV9DUkVBVEVfVk0pIik7CgoJaWYgKGlvY3RsKGt2bSwgS1ZNX0NI
RUNLX0VYVEVOU0lPTiwgS1ZNX0NBUF9ERUJVR1JFR1MpID09IDApCgkJZXJyeCgxLCAiS1ZN
X0NBUF9ERUJVR1JFR1Mgbm90IHN1cHBvcnRlZCEiKTsKCgljcHUgPSBpb2N0bCh2bSwgS1ZN
X0NSRUFURV9WQ1BVLCAwKTsKCWlmICh2bSA8IDApCgkJZXJyKDEsICJpb2N0bChLVk1fQ1JF
QVRFX1ZDUFUpIik7CgoJZm9yIChpID0gMDsgaSA8IDQ7IGkrKykgewoJCXVuc2lnbmVkIGxv
bmcgZGJfdmFsOwoKCQltZW1zZXQoJmRiZ19yZWdzLCAwLCBzaXplb2YoZGJnX3JlZ3MpKTsK
CgkJZGJnX3JlZ3MuZGJbaV0gPSAweGJhZGMwZGUwIHwgaTsKCQlkYmdfcmVncy5kYltpXSA8
PD0gMzI7CgkJZGJnX3JlZ3MuZGJbaV0gfD0gMHhjMGZmZWUwIHwgaTsKCgkJZGJfdmFsID0g
ZGJnX3JlZ3MuZGJbaV07CgoJCWlmIChpb2N0bChjcHUsIEtWTV9TRVRfREVCVUdSRUdTLCAm
ZGJnX3JlZ3MpICE9IDApCgkJCWVycigxLCAiaW9jdGwoS1ZNX1NFVF9ERUJVR1JFR1MpIik7
CgoJCW1lbXNldCgmZGJnX3JlZ3MsIDAsIHNpemVvZihkYmdfcmVncykpOwoJCWlmIChpb2N0
bChjcHUsIEtWTV9HRVRfREVCVUdSRUdTLCAmZGJnX3JlZ3MpICE9IDApCgkJCWVycigxLCAi
aW9jdGwoS1ZNX0dFVF9ERUJVR1JFR1MpIik7CgoJCWZvciAoaiA9IDA7IGogPCA0OyBqKysp
IHsKCQkJdW5zaWduZWQgbG9uZyBleHBlY3QgPSBqID09IGkgPyBkYl92YWwgOiAwOwoKCQkJ
aWYgKGRiZ19yZWdzLmRiW2pdICE9IGV4cGVjdCkgewoJCQkJd2FybngoInVuZXhwZWN0ZWQg
dmFsdWUgb2YgRFIlZCAoMHglbGx4LCBzaG91bGQgYmUgMHglbHgpIGFmdGVyIHNldHRpbmcg
RFIlZCIsCgkJCQkgICAgICBqLCBkYmdfcmVncy5kYltqXSwgZXhwZWN0LCBpKTsKCQkJCXJl
cysrOwoJCQl9CgkJfQoJfQoKCWNsb3NlKGt2bSk7CgljbG9zZShjcHUpOwoJY2xvc2Uodm0p
OwoKCXJldHVybiByZXM7Cn0K

--------------HflgM7aqJsA4VOByrlkcgdQn--
