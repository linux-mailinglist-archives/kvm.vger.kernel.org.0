Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB46472A7B
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 11:43:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234701AbhLMKnk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 05:43:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233914AbhLMKnj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 05:43:39 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70C6EC061574;
        Mon, 13 Dec 2021 02:43:39 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id x15so51361647edv.1;
        Mon, 13 Dec 2021 02:43:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=8Z9NIGNy3o2CZvOQQU/99vlG0PiHZ2GfMZ6W8ScxJp4=;
        b=BTm6mB2Gft6X/rIdY/zyXfkihFf951trDHDrIsIyP/7bP2L9zpZmyXd2OqFk/8RZlP
         ufd/Hivms6EH73FUUtwfc+1y/w5EiXRbKDo24zBW2aWo+AnoAl8mKXilpn/iZRNQzIOQ
         RWPl4n9lsilqayQXDSZUxAuC0eZ4r0YM4IFCk49ZH5+FlfxB2MYDvJ9bOPC87tgekttW
         TIR8K0Nad+0Q9ID5ynzT0QpkozpbDhQl2QYwgXi2rfCf8lhVwjcoMnkzta2ukChluUzC
         58JJqzIBkbCtTs+jXIA29EVaEet8nB3BiDrThHbaMjEd+0NEku5oL3Zk9iTsf/ILA6S6
         9u5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=8Z9NIGNy3o2CZvOQQU/99vlG0PiHZ2GfMZ6W8ScxJp4=;
        b=WwFDVXsRt+fEvWOtCbLwR1dnW5S8shrgwOkXup9X26XgaFHHP0EG7NNtezaE/2bNne
         fEP7LqdsyQOg6hfb4WwgQ6HM683lW32QTW377uAACwQlLABqikKFTTjlizqVFmJvwEZB
         W69iHsQ08rUcTJmbeDDpkZJJREJFLWZZCz5tGY8nokYmEm5CtpNqngRUzQ6Uq7QwXp8R
         aVfliKxS7PN0w6p28xTQ/u/8iXshg5wQska9/iTtE8TeUU2jRsOFwhLmt/lsE6Qp/gJm
         l5S+WJp0K2AJwuDB9eo+A/4nlzkKbFhw6PcDbdMC/4lz9aJMscnrEaZeP1WRlg5FNkb/
         YLDQ==
X-Gm-Message-State: AOAM533t+3ycLdT0bXfEHx6+2iOag51qKWixKjDWo4fXwl0AxqxSwv07
        dG9YfJAv1DKDfJU0+R3mDoo=
X-Google-Smtp-Source: ABdhPJyYFPMYZA3CDYd101J2HqdJ+O5MT6EuIDsYbmDvpxZc79ghJ+goZS5FEJsw9+7N2NwOQ4VbSw==
X-Received: by 2002:a17:907:7253:: with SMTP id ds19mr43338192ejc.476.1639392217966;
        Mon, 13 Dec 2021 02:43:37 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id s16sm6052407edt.30.2021.12.13.02.43.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Dec 2021 02:43:37 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <08107331-34b9-b33d-67ee-300f216341e0@redhat.com>
Date:   Mon, 13 Dec 2021 11:43:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 16/19] kvm: x86: Introduce KVM_{G|S}ET_XSAVE2 ioctl
Content-Language: en-US
To:     Thomas Gleixner <tglx@linutronix.de>,
        Yang Zhong <yang.zhong@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com
References: <20211208000359.2853257-1-yang.zhong@intel.com>
 <20211208000359.2853257-17-yang.zhong@intel.com>
 <d16aab21-0f81-f758-a61e-5919f223be78@redhat.com> <87bl1kvmqg.ffs@tglx>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <87bl1kvmqg.ffs@tglx>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/13/21 11:10, Thomas Gleixner wrote:
> On Fri, Dec 10 2021 at 17:30, Paolo Bonzini wrote:
>> On 12/8/21 01:03, Yang Zhong wrote:
>>> +static int kvm_vcpu_ioctl_x86_set_xsave2(struct kvm_vcpu *vcpu, u8 *state)
>>> +{
>>> +	if (fpstate_is_confidential(&vcpu->arch.guest_fpu))
>>> +		return 0;
>>> +
>>> +	return fpu_copy_uabi_to_guest_fpstate(&vcpu->arch.guest_fpu, state,
>>> +					      supported_xcr0, &vcpu->arch.pkru);
>>> +}
>>> +
>>
>> I think fpu_copy_uabi_to_guest_fpstate (and therefore
>> copy_uabi_from_kernel_to_xstate) needs to check that the size is
>> compatible with the components in the input.
> 
> fpu_copy_uabi_to_guest_fpstate() expects that the input buffer is
> correctly sized. We surely can add a size check there.

fpu_copy_guest_fpstate_to_uabi is more problematic because that one
writes memory.  For fpu_copy_uabi_to_guest_fpstate, we know the input
buffer size from the components and we can use it to do a properly-sized
memdup_user.

For fpu_copy_guest_fpstate_to_uabi we can just decide that KVM_GET_XSAVE
will only save up to the first 4K.  Something like the following might
actually be good for 5.16-rc; right now, header.xfeatures might lead
userspace into reading uninitialized or unmapped memory:

diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index d28829403ed0..69609b8c3887 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -1138,8 +1138,10 @@ void __copy_xstate_to_uabi_buf(struct membuf to, struct fpstate *fpstate,
  	struct xstate_header header;
  	unsigned int zerofrom;
  	u64 mask;
+	u64 size;
  	int i;
  
+	size = to->left;
  	memset(&header, 0, sizeof(header));
  	header.xfeatures = xsave->header.xfeatures;
  
@@ -1186,7 +1188,20 @@ void __copy_xstate_to_uabi_buf(struct membuf to, struct fpstate *fpstate,
  	/* Copy xsave->i387.sw_reserved */
  	membuf_write(&to, xstate_fx_sw_bytes, sizeof(xsave->i387.sw_reserved));
  
-	/* Copy the user space relevant state of @xsave->header */
+	/*
+	 * Copy the user space relevant state of @xsave->header.
+	 * If not all features fit in the buffer, drop them from the
+	 * saved state so that userspace does not read uninitialized or
+	 * unmapped memory.
+	 */
+	mask = fpstate->user_xfeatures;
+	for_each_extended_xfeature(i, mask) {
+		if (xstate_offsets[i] + xstate_size[i] > size) {
+			header.xfeatures &= BIT(i) - 1;
+			mask &= BIT(i) - 1;
+			break;
+		}
+	}
  	membuf_write(&to, &header, sizeof(header));
  
  	zerofrom = offsetof(struct xregs_state, extended_state_area);
@@ -1197,7 +1212,6 @@ void __copy_xstate_to_uabi_buf(struct membuf to, struct fpstate *fpstate,
  	 * but there is no state to copy from in the compacted
  	 * init_fpstate. The gap tracking will zero these states.
  	 */
-	mask = fpstate->user_xfeatures;
  
  	for_each_extended_xfeature(i, mask) {
  		/*



>> Also, IIUC the size of the AMX state will vary in different processors.
>>    Is this correct?  If so, this should be handled already by
>> KVM_GET/SET_XSAVE2 and therefore should be part of the
>> arch/x86/kernel/fpu APIs.  In the future we want to support migrating a
>> "small AMX" host to a "large AMX" host; and also migrating from a "large
>> AMX" host to a "small AMX" host if the guest CPUID is compatible with
>> the destination of the migration.
> 
> How is that supposed to work? If the AMX state size differs then the
> hosts are not compatible.

I replied with some more questions later.  Basically it depends on how
Intel will define palettes that aren't part of the first implementation
of AMX.

Paolo
