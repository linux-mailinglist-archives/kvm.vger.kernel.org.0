Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A0AF73BA5B
	for <lists+kvm@lfdr.de>; Fri, 23 Jun 2023 16:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbjFWOlD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jun 2023 10:41:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230262AbjFWOlB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Jun 2023 10:41:01 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DFA11706
        for <kvm@vger.kernel.org>; Fri, 23 Jun 2023 07:41:00 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-668711086f4so553257b3a.1
        for <kvm@vger.kernel.org>; Fri, 23 Jun 2023 07:41:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687531260; x=1690123260;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rUmNU59N1Oq8ofE4A5iPwfeZ5YTlQhaGki9SP4Nm4ZQ=;
        b=CvlC5mo4UGcz/D1071KscG4yKEAPe6KCDRA0Tp9wJMS9l1POr3rUV1gmtHWDfLugpV
         pI1SardOFZqV/+ZXkMLx5nzwbJtv0bJylG1rb15SHkJjfWgNVP6L4O5CKrwVSHZNtqqQ
         9adAOuz1jzzT6CDlkd/8e+26e5fttFqeKYOEUs2z8ZLbg46ak33s70I5Rf6SWWnlSgGb
         oLv/i7Lyig4i9X3LKoDdhPwR5di82/ss20dvhUd+C5fFX2MKOttLRO7P5QpLQHmbeCB0
         MgA9i8M5ig/1D8CI3KncPJqjDnPX57/5f2Hn525ReOfF+/yEByKY8Mq/QM5H82wzm2CU
         GJwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687531260; x=1690123260;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rUmNU59N1Oq8ofE4A5iPwfeZ5YTlQhaGki9SP4Nm4ZQ=;
        b=Vur0UU2KljvIIB9AtscVCnPV4aSAx5XlNrZOBXqnI3E8+YymQvNeVC9XAWq1jKyhq7
         2hBN4NtdB1lj+44+XzGbLIgFLkdu6GRetuVoDV36z6ckU4YzndI1uDM/31SnjvNQE5S6
         PHbnRJxU4kCWENeo7gL8NqpFml5wTmLf4Q9QYXewmFvxpEeT9T+AcGTTrafG+/olf0do
         lB/hKE7nVtWOY67Dpb7YlVpd5JWp+NSJhk8LcpCdaIkiG8rD7setrD0LHXlR6tPQr+Xa
         E+TXBNe81+wQDS4tH5qmRax49WX7bpWZn7kHCEwcoB9jOQmtzx6sWxwQSgi9HQNiONMf
         NkwQ==
X-Gm-Message-State: AC+VfDxBaDacKAIWF7qsQj7eN8ReKrws9M6SintpyypfiRnionpVOV+0
        stxOhx9hl1OnTuOArMtLZkvYa/paX/o=
X-Google-Smtp-Source: ACHHUZ6MLF8siG9aHN7MW1SfWC2DUjlTw3a2yfvcYQWmOKiTo/8PTE23O9kTu/afRfl8kIu9IypCqA==
X-Received: by 2002:a05:6a20:3c86:b0:10b:bf2d:71bb with SMTP id b6-20020a056a203c8600b0010bbf2d71bbmr32588902pzj.27.1687531259666;
        Fri, 23 Jun 2023 07:40:59 -0700 (PDT)
Received: from [172.27.236.36] (ec2-16-163-40-128.ap-east-1.compute.amazonaws.com. [16.163.40.128])
        by smtp.gmail.com with ESMTPSA id t12-20020a62ea0c000000b00657fbf81ffbsm4148037pfh.80.2023.06.23.07.40.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Jun 2023 07:40:59 -0700 (PDT)
Message-ID: <40e21715-1af6-e1e8-d315-adda011d1d11@gmail.com>
Date:   Fri, 23 Jun 2023 22:40:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [Bug 217423] TSC synchronization issue in VM restore
To:     bugzilla-daemon@kernel.org, kvm@vger.kernel.org
References: <bug-217423-28872@https.bugzilla.kernel.org/>
 <bug-217423-28872-hZX141cTfZ@https.bugzilla.kernel.org/>
Content-Language: en-US
From:   Robert Hoo <robert.hoo.linux@gmail.com>
In-Reply-To: <bug-217423-28872-hZX141cTfZ@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,TVD_PH_BODY_ACCOUNTS_PRE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/18/2023 8:48 PM, bugzilla-daemon@kernel.org wrote:
[...]
(Sorry for late response)
>> Can elaborate more on this hrtimer issue/code path?
> 
> Below are the steps in detail, I traced them via bpftrace, to simplify the
> analysis, the preemption timer on host is disabled, guest is running with
> TSC timer deadline mode.
> 
> TSC changes before save VM:
> 1 create VM/VCPU, guest TSC start from 0 (VCPU initial value)
>    host_tsc0 = 0 + offset0
> 2 pause VM after guest start finished (about 200ms)
>    host_tsc1 = guest_tsc1 + offset0
>    guest_tsc1_deadline = guest_tsc1 + expire1
> 3 save VM state
>    save guest_tsc1 by reading MSR_IA32_TSC
>    save guest_tsc1_deadline by reading MSR_IA32_TSC_DEADLINE
> 
> TSC changes in restore VM (to simplify the analysis, step 4
> and step 5 ignore the host TSC changes in restore process):
> 4 create VM/VCPU, guest TSC start from 0 (VCPU initial value)
>    host_tsc3 = 0 + offset1
> 5 restore VM state
>    set MSR_IA32_TSC by guest_tsc1
>    set MSR_IA32_TSC_DEADLINE by guest_tsc1_deadline
> 6 start VM
>    VCPU_RUN
> 
> In step 5 setting MSR_IA32_TSC, because the guest_tsc1 is within 1 second,
> KVM will take this update as TSC synchronize, then skip update offset1.
> This means the guest TSC is still at 0 (initialize value).

IIUC, here no matter synchronizing = true or false, offset will always be 
updated, i.e. __kvm_synchronize_tsc() will be called. But the offset value will 
differ.

I guess your environment is tsc_stable, then offset = kvm->arch.cur_tsc_offset, 
which is 0. That is to say, the elapsed time isn't counted in by the heuristics 
method in current code, that's the culprit.

static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
{
	...
	offset = kvm_compute_l1_tsc_offset(vcpu, data);
	...

	/*
	 * For a reliable TSC, we can match TSC offsets, and for an unstable
	 * TSC, we add elapsed time in this computation.  We could let the
	 * compensation code attempt to catch up if we fall behind, but
	 * it's better to try to match offsets from the beginning.
          */
	if (synchronizing &&
	    vcpu->arch.virtual_tsc_khz == kvm->arch.last_tsc_khz) {
		if (!kvm_check_tsc_unstable()) {
			offset = kvm->arch.cur_tsc_offset;
		} else {
			u64 delta = nsec_to_cycles(vcpu, elapsed);
			data += delta;
			offset = kvm_compute_l1_tsc_offset(vcpu, data);
		}
		matched = true;
	}

	__kvm_synchronize_tsc(vcpu, offset, data, ns, matched);
	raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
}


>> An alternative, I think, is to bypass this directly write IA32_MSR_TSC way
>> to set/sync TSC offsets, but follow new approach introduced in your VMM by
>>
>> commit 828ca89628bfcb1b8f27535025f69dd00eb55207
>> Author: Oliver Upton <oliver.upton@linux.dev>
>> Date:   Thu Sep 16 18:15:38 2021 +0000
>>
>>       KVM: x86: Expose TSC offset controls to userspace
>>
>> ...
>>
>> Documentation/virt/kvm/devices/vcpu.rst:
>>
>> 4.1 ATTRIBUTE: KVM_VCPU_TSC_OFFSET
>>
>> :Parameters: 64-bit unsigned TSC offset
>>
>> ...
>>
>> Specifies the guest's TSC offset relative to the host's TSC. The guest's
>> TSC is then derived by the following equation:
>>
>>     guest_tsc = host_tsc + KVM_VCPU_TSC_OFFSET
>>
>> The following describes a possible algorithm to use for this purpose
>> ...
> 
> "TSC counts the time during which the VM was paused.", This new feature works
> for live migration. But if we save/restore VM with snapshot, the TSC should be
> paused either?
> 
Not sure what's host's TSC situation when host is, say, suspended/hibernated. VM 
Save/Restore can refer to that.
But, the key point of this new approach is to use OFFSET rather than direct TSC 
value, this is like x86 TSC_ADJUST was introduced, and is preferred.
Via this new interface,
"... Ensure that the KVM_CLOCK_REALTIME flag is set in the provided structure.
KVM will advance the VM's kvmclock to account for elapsed time since recording 
the clock values.", therefore I think it can solve your problem, rather than 
modify the ancient and heuristics code at high risk.
