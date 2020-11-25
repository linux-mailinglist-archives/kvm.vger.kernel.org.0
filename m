Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 724E02C353E
	for <lists+kvm@lfdr.de>; Wed, 25 Nov 2020 01:11:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbgKYAKy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Nov 2020 19:10:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49295 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726708AbgKYAKx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 24 Nov 2020 19:10:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606263051;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ksUFy87Li12vla/Gfu7y6UP52f3wVkRJgvgXkQchjyw=;
        b=e4su0RqIvWISsDvJbBYa/deHGHrpR/UluCerzcveFr24Vrj8pZ5Sa52dk0Oti8wG9uwDMb
        qKGcsiMAN+27dj8Hi66UpxMPLmRdst1ikk3M7pEmA6q+QXL8sNvr5JRtKDLRBMBZ5qnR49
        Qt/hOszRensPfDkTh9XoQbFeS301RaU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-541-eMP3r2Y_PGadgRZ0n85Vrg-1; Tue, 24 Nov 2020 19:10:50 -0500
X-MC-Unique: eMP3r2Y_PGadgRZ0n85Vrg-1
Received: by mail-wr1-f70.google.com with SMTP id f4so115228wru.21
        for <kvm@vger.kernel.org>; Tue, 24 Nov 2020 16:10:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ksUFy87Li12vla/Gfu7y6UP52f3wVkRJgvgXkQchjyw=;
        b=JPcJQxlFNU4mqJUH1IUJ0vygEDSzfqLwScMs746yw4PG2qtHLQ/j6UCaSwf+HZuVeS
         mZFNnVku+aCWNbBfP5RYJS+ljZKELm/gDVYdgOSQ0LfKkJMF1kYanEkHtv46eBu8pnQM
         jkM6vP02/gyeZ+I6yKxinON1/6U2559IejcScfQEIZO7WVXT5TNKYW5+aFHKxwDxi266
         nZ+2T1Gvc8JMiOIZMLHpbJWNOo4sRoG4BD9b0l8yn4lGyxoIWvr43yQYIzc/qbjG+5ES
         2bxqXV+va+ps2q6nl9yArBR4gVnQQqnpLAYESr5NmYennlT+i1w5VU6TiPyLJdHBwysm
         egfQ==
X-Gm-Message-State: AOAM533fnv/oCh8Tct4x4iXLTf3p+m5MawI8S3h8TGmcrkKGbpqxIHlK
        ejv2I/KZLcfT38Y4d0P4OmXaQGt4A9fl16z68FkrutejVq1uF/qS+WZJJCXrh64DbT8Qgr+1Sp4
        THdDmk8Yp7hJz
X-Received: by 2002:a1c:5a08:: with SMTP id o8mr301195wmb.142.1606263048837;
        Tue, 24 Nov 2020 16:10:48 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzd+aD9zifCVLUHW7ucS1C+5T6jOT4FTJKHcGRSXKz+f59UxjLLhV6IJIZdPlSmE0WPjceEzQ==
X-Received: by 2002:a1c:5a08:: with SMTP id o8mr301177wmb.142.1606263048570;
        Tue, 24 Nov 2020 16:10:48 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id j14sm957705wrs.49.2020.11.24.16.10.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Nov 2020 16:10:47 -0800 (PST)
To:     Sean Christopherson <seanjc@google.com>
Cc:     Oliver Upton <oupton@google.com>, idan.brown@oracle.com,
        Jim Mattson <jmattson@google.com>,
        kvm list <kvm@vger.kernel.org>, liam.merwick@oracle.com,
        wanpeng.li@hotmail.com
References: <95b9b017-ccde-97a0-f407-fd5f35f1157d@redhat.com>
 <20201123192223.3177490-1-oupton@google.com>
 <4788d64f-1831-9eb9-2c78-c5d9934fb47b@redhat.com>
 <CAOQ_QsiUAVob+3hnAURJF-1+GdRF9HMtuxpKWCB-3m-abRGqxw@mail.gmail.com>
 <CAOQ_QshMoc9W9g6XRuGM4hCtMdvUxSDpGAhp3vNxhxhWTK-5CQ@mail.gmail.com>
 <20201124015515.GA75780@google.com>
 <e140ed23-df91-5da2-965a-e92b4a54e54e@redhat.com>
 <20201124212215.GA246319@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 11/11] KVM: nVMX: Wake L2 from HLT when nested
 posted-interrupt pending
Message-ID: <d5f4153b-975d-e61d-79e8-ed86df346953@redhat.com>
Date:   Wed, 25 Nov 2020 01:10:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201124212215.GA246319@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/11/20 22:22, Sean Christopherson wrote:
>> What if IN_GUEST_MODE/OUTSIDE_GUEST_MODE was replaced by a
>> generation count?  Then you reread vcpu->mode after sending the IPI, and
>> retry if it does not match.
> The sender will have seen IN_GUEST_MODE and so won't retry the IPI,
> but hardware didn't process the PINV as a posted-interrupt.
Uff, of course.

That said, it may still be a good idea to keep pi_pending only as a very 
short-lived flag only to handle this case, and maybe not even need the 
generation count (late here so put up with me if it's wrong :)).  The 
flag would not have to live past vmx_vcpu_run even, the vIRR[PINV] bit 
would be the primary marker that a nested posted interrupt is pending.

>>> if we're ok with KVM
>>> processing virtual interrupts that technically shouldn't happen, yet.  E.g. if
>>> the L0 PINV handler consumes vIRR bits that were set after the last PI from L1.
>>
>> I actually find it curious that the spec promises posted interrupt
>> processing to be triggered only by the arrival of the posted interrupt IPI.
>> Why couldn't the processor in principle snoop for the address of the ON bit
>> instead, similar to an MWAIT?
> 
> It would lead to false positives and missed IRQs.

Not to missed IRQs---false positives on the monitor would be possible, 
but you would still have to send a posted interrupt IPI.  The weird 
promise is that the PINV interrupt is the _only_ trigger for posted 
interrupts.

>> But even without that, I don't think the spec promises that kind of strict
>> ordering with respect to what goes on in the source.  Even though posted
>> interrupt processing is atomic with the acknowledgement of the posted
>> interrupt IPI, the spec only promises that the PINV triggers an _eventual_
>> scan of PID.PIR when the interrupt controller delivers an unmasked external
>> interrupt to the destination CPU.  You can still have something like
>>
>> 	set PID.PIR[100]
>> 	set PID.ON
>> 					processor starts executing a
>> 					 very slow instruction...
>> 	send PINV
>> 	set PID.PIR[200]
>> 					acknowledge PINV
>>
>> and then vector 200 would be delivered before vector 100.  Of course with
>> nested PI the effect would be amplified, but it's possible even on bare
>> metal.
> 
> Jim was concerned that L1 could poll the PID to determine whether or not
> PID.PIR[200] should be seen in L2.  The whole PIR is copied to the vIRR after
> PID.ON is cleared the auto-EOI is done, and the read->clear is atomic.  So the
> above sequence where PINV is acknowledge after PID.PIR[200] is legal, but
> processing PIR bits that are set after the PIR is observed to be cleared would
> be illegal.

That would be another case of the unnecessarily specific promise above.

> E.g. if L1 did this
> 
> 	set PID.PIR[100]
> 	set PID.ON
> 	send PINV
> 	while (PID.PIR)
> 	set PID.PIR[200]
> 	set PID.ON
>
> This is the part that is likely impossible to
> solve without shadowing the PID (which, for the record, I have zero desire to do).

Neither do I. :)  But technically the SDM doesn't promise reading the 
whole 256 bits at the same time.  Perhaps that's the only way it can 
work in practice due to the cache coherency protocols, but the SDM only 
promises atomicity of the read and clear of "a single PIR bit (or group 
of bits)".  So there's in principle no reason why the target CPU 
couldn't clear PID.PIR[100], and then L1 would sneak in and set 
PID.PIR[200].

Paolo

> It seems extremely unlikely any guest will puke on the above, I can't imagine
> there's for setting a PID.PIR + PID.ON without triggering PINV, but it's
> technically bad behavior in KVM.
> 

