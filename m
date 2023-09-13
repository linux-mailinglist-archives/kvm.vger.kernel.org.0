Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA0879E3FF
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 11:44:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239364AbjIMJoI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 05:44:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239371AbjIMJoH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 05:44:07 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 528ED19A9;
        Wed, 13 Sep 2023 02:44:03 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-68fb85afef4so2979935b3a.1;
        Wed, 13 Sep 2023 02:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694598243; x=1695203043; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iBSXAIGrgjNBs8P647jgkvf2ZHivdcT73i0SBVdEVm0=;
        b=o/W7XC6tp96FtEgoJTJZg7RE+fQfv7umh4qUTvJyOzOXbpzrgNp2orVUvD3MMNHzua
         S4HfWK0SchlewzQsfzCkA66073whknrQm6Z9Pgc3rXm0d7r2VEMEIm+HqxNpPvytIV8M
         ULs6P7Gd6b9xPiN5GGVpxYBlxoGWZbXmCegqIg+7f7khK6dOwsnuj4GPsDDRivtDkMa+
         H8WybI3gRr3FY6NPMt3l6BBJ3d/kJYHvHPFamR6CD3fY1RhLVPj2OdFmyFb6WL9TJNSe
         SWXLvxodfdnMtJqyg053HtGEqltAqv9xJAjkRbmlP2s/gsfE7s3uoypgjvC/ngUlpfhL
         7zAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694598243; x=1695203043;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iBSXAIGrgjNBs8P647jgkvf2ZHivdcT73i0SBVdEVm0=;
        b=Q13wIvC77tfTrGi5zQ5htiuJcER4K2C98bVyOKOIBOLChJRakoL6R1AuilugvDT0St
         dqqmibY6bNkODgt9IRnx/Rw1lEb+8D/GIKWtdHcPlbuxVCeDRQajnpN9RAu8/XZaX4R9
         Jmj7o7C2dyxs/DRENYvwcgh/j/57U0Vhg48W7w7Zr7hzCUrx73qFHRyq+dT1Tn66rJLY
         czrPBlCifxap/I0DaycoJwEVsG4zdJFv9Q2iIF/EX+JKOk99t1SkZby+M9cAp9oI44vH
         f+dul7H+U0rXinsCgjNv7w0E691emwQHzFKWz5isPOeVHzFGz1V+GDk1h3UOQW05pTmF
         l5cQ==
X-Gm-Message-State: AOJu0YxgfupdaxCjAxPN1Q9g0ayE9FmjOMi1xjWdmyVDKXXS2PWb3LSR
        N1j5aqAZqfxSgSuxJxgEL3doPQlkuvrEyA==
X-Google-Smtp-Source: AGHT+IGWGeOKIoiXCDNh+wQqVzdSJfRgbLonJvldu3BPnpBXMnlgyW+J7ZrFRAr1TEpD63DbUUXkVA==
X-Received: by 2002:a05:6a00:15d3:b0:68f:efc2:ba3d with SMTP id o19-20020a056a0015d300b0068fefc2ba3dmr2275886pfu.33.1694598242702;
        Wed, 13 Sep 2023 02:44:02 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id y5-20020aa78045000000b0064d74808738sm8723681pfm.214.2023.09.13.02.44.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Sep 2023 02:44:02 -0700 (PDT)
Message-ID: <38859747-d4f1-b4e2-98c7-bd529cd09976@gmail.com>
Date:   Wed, 13 Sep 2023 17:43:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH v5] KVM: x86/tsc: Don't sync TSC on the first write in
 state restoration
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
References: <20230913072113.78885-1-likexu@tencent.com>
 <e506ceb2d837344999c4899525a3490d8c46c95b.camel@infradead.org>
 <90194cd0-61d8-18b9-980a-b46f903409b4@gmail.com>
 <461B7217-7AA7-479E-9060-772E243CB03D@infradead.org>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <461B7217-7AA7-479E-9060-772E243CB03D@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 13/9/2023 5:30 pm, David Woodhouse wrote:
> 
> 
> On 13 September 2023 11:17:49 CEST, Like Xu <like.xu.linux@gmail.com> wrote:
>>> I think you also need to set kvm->arch.user_set_tsc() in
>>> kvm_arch_tsc_set_attr(), don't you?
>>
>> How about:
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index c55cc60769db..374965f66137 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -5545,6 +5545,7 @@ static int kvm_arch_tsc_set_attr(struct kvm_vcpu *vcpu,
>> 		tsc = kvm_scale_tsc(rdtsc(), vcpu->arch.l1_tsc_scaling_ratio) + offset;
>> 		ns = get_kvmclock_base_ns();
>>
>> +		kvm->arch.user_set_tsc = true;
>> 		__kvm_synchronize_tsc(vcpu, offset, tsc, ns, matched);
>> 		raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
> 
> Yep, that looks good.
> 
> 
>>> This comment isn't quite right; it wants to use some excerpt of the
>>> commit message I've suggested above.
>>
>> How about:
>>
>> @@ -2735,20 +2735,34 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 data)
>> 			 * kvm_clock stable after CPU hotplug
>> 			 */
>> 			synchronizing = true;
>> -		} else {
>> +		} else if (kvm->arch.user_set_tsc) {
>> 			u64 tsc_exp = kvm->arch.last_tsc_write +
>> 						nsec_to_cycles(vcpu, elapsed);
>> 			u64 tsc_hz = vcpu->arch.virtual_tsc_khz * 1000LL;
>> 			/*
>> -			 * Special case: TSC write with a small delta (1 second)
>> -			 * of virtual cycle time against real time is
>> -			 * interpreted as an attempt to synchronize the CPU.
>> +			 * Here lies UAPI baggage: user-initiated TSC write with
>> +			 * a small delta (1 second) of virtual cycle time
>> +			 * against real time is interpreted as an attempt to
>> +			 * synchronize the CPU.
> 
> Much better, thanks. But I don't much like "an attempt to synchronize the CPU".
> 
> In my response to Sean I objected to that classification. Userspace is just *setting* the TSC. There is no dedicated intent to "synchronize" it. It just sets it, and the value just *might* happen to be in sync with another vCPU.
> 
> It's just that our API is so fundamentally broken that it *can't* be in sync, so we "help" it a bit if it looks close.
> 
> So maybe...
> 
> Here lies UAPI baggage: when a user-initiated TSC write has a small delta (1 second) of virtual cycle time against the previously set vCPU, we assume that they were intended to be in sync and the delta was only due to the racy nature of the legacy API.
> 
>> +			 * This trick falls down when restoring a guest which genuinely
>> +			 * has been running for less time than the 1 second of imprecision
>> +			 * which we allow for in the legacy API. In this case, the first
>> +			 * value written by userspace (on any vCPU) should not be subject
>> +			 * to this 'correction' to make it sync up with values that only
>> +			 * from from the kernel's default vCPU creation. Make the 1-second
>> +			 * slop hack only trigger if flag is already set.
>> +			 *
>> +			 * The correct answer is for the VMM not to use the legacy API.
> 
> 
> 
> 
>>> Userspace used to be able to write zero to force a sync. You've removed
>>> that ability from the ABI, and haven't even mentioned it. Must we?
>>
>> Will continue to use "bool user_initiated" for lack of a better move.
> 
> Why? Can't we treat an explicit zero write just the same as when the kernel does it?

Not sure if it meets your simplified expectations:

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6c9c81e82e65..0f05cf90d636 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2735,20 +2735,35 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, 
u64 data)
  			 * kvm_clock stable after CPU hotplug
  			 */
  			synchronizing = true;
-		} else {
+		} else if (!data || kvm->arch.user_set_tsc) {
  			u64 tsc_exp = kvm->arch.last_tsc_write +
  						nsec_to_cycles(vcpu, elapsed);
  			u64 tsc_hz = vcpu->arch.virtual_tsc_khz * 1000LL;
  			/*
-			 * Special case: TSC write with a small delta (1 second)
-			 * of virtual cycle time against real time is
-			 * interpreted as an attempt to synchronize the CPU.
+			 * Here lies UAPI baggage: when a user-initiated TSC write has
+			 * a small delta (1 second) of virtual cycle time against the
+			 * previously set vCPU, we assume that they were intended to be
+			 * in sync and the delta was only due to the racy nature of the
+			 * legacy API.
+			 *
+			 * This trick falls down when restoring a guest which genuinely
+			 * has been running for less time than the 1 second of imprecision
+			 * which we allow for in the legacy API. In this case, the first
+			 * value written by userspace (on any vCPU) should not be subject
+			 * to this 'correction' to make it sync up with values that only
+			 * from from the kernel's default vCPU creation. Make the 1-second
+			 * slop hack only trigger if flag is already set.
+			 *
+			 * The correct answer is for the VMM not to use the legacy API.
  			 */
  			synchronizing = data < tsc_exp + tsc_hz &&
  					data + tsc_hz > tsc_exp;
  		}
  	}

+	if (data)
+		kvm->arch.user_set_tsc = true;
+
  	/*
  	 * For a reliable TSC, we can match TSC offsets, and for an unstable
  	 * TSC, we add elapsed time in this computation.  We could let the
@@ -5536,6 +5551,7 @@ static int kvm_arch_tsc_set_attr(struct kvm_vcpu *vcpu,
  		tsc = kvm_scale_tsc(rdtsc(), vcpu->arch.l1_tsc_scaling_ratio) + offset;
  		ns = get_kvmclock_base_ns();

+		kvm->arch.user_set_tsc = true;
  		__kvm_synchronize_tsc(vcpu, offset, tsc, ns, matched);
  		raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);


