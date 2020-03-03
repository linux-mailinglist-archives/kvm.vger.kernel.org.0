Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7AF177696
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 14:05:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729208AbgCCNDC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 08:03:02 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:47317 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728041AbgCCNDB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Mar 2020 08:03:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583240580;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fxyaJBCKdEug50sQ1sIk2q1FJ4yKhmLVJVdWUZZRTgs=;
        b=jKQ8Y5PJBwMIdQJHSIWgQDhnKJwuehOKfqUcgFZvAdBIhPBMV5DeidOXqIftVWsDUhGaDf
        nNLXjmWGNMIHoyS57UgUx7zVWFhJeqdKTF8uxQpgl0N2UQotHhIolTktpb1Xg4JhCNjKP/
        JWUJNznoWLyR9UvJ0Uef1JCQhvKs8Lc=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-65-WJRaws0yOTqxbhjIQwdRkQ-1; Tue, 03 Mar 2020 08:02:57 -0500
X-MC-Unique: WJRaws0yOTqxbhjIQwdRkQ-1
Received: by mail-wr1-f69.google.com with SMTP id j14so1189858wru.8
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2020 05:02:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=fxyaJBCKdEug50sQ1sIk2q1FJ4yKhmLVJVdWUZZRTgs=;
        b=SXNGwOfBpd7IZWMUPAX4gq3lhExyw9fvHr8b24KGaiTcqdBW2Aj6raPaWEOs8ebqrY
         dVGnJLoUtg2lA3pvQPjbiSXSKZxnYMUuC7r6o0anPMEx2wznjfTKPEoC3rsp984m4h4a
         +bChLOCTxno5lzh7SCcUR8+i9LNhDvHMsacUNTik8rZQbfeeN8RElnHJ1DzswClrXtNW
         0hvfK26NJiY7vIIC6Rp0dxqn100pENE0MIDs/6yNhgTLVvC1pzvui0XhO9nkoE6qtbof
         SqJF2/h1h9DaXd8lQX/hvZEnCt94uXRJgA2NFhdNz9ynH6DwZ3UBsZw14gTu1UwYffJV
         AqpQ==
X-Gm-Message-State: ANhLgQ3ZuGLZxi7CiBcSOvEKJ4rTDqarD/CxTP8X1INcDuPrppEAfMr6
        Bb4j0EgIeGQRgRCXWl+eMlfs15WXsg19rBMgviRS1g2CP8mtziMXo3Piz/ttSWrVGLtbw7R8BjP
        Nec7WBZnk0St0
X-Received: by 2002:adf:f84a:: with SMTP id d10mr5547885wrq.208.1583240576043;
        Tue, 03 Mar 2020 05:02:56 -0800 (PST)
X-Google-Smtp-Source: ADFU+vu05HQ3OHj9N3aJ8iNGgT/jLI2sDvyFRtk26XLwFnJjSUTHXBpAo4czkkiEuXW6nhpwE+4fTg==
X-Received: by 2002:adf:f84a:: with SMTP id d10mr5547859wrq.208.1583240575803;
        Tue, 03 Mar 2020 05:02:55 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id a7sm34797870wrm.29.2020.03.03.05.02.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 05:02:55 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Oliver Upton <oupton@google.com>
Subject: Re: [GIT PULL] KVM changes for Linux 5.6-rc4
In-Reply-To: <8fbeb3c2-9627-bf41-d798-bafba22073e3@redhat.com>
References: <1582570669-45822-1-git-send-email-pbonzini@redhat.com> <87zhcyfvmk.fsf@vitty.brq.redhat.com> <8fbeb3c2-9627-bf41-d798-bafba22073e3@redhat.com>
Date:   Tue, 03 Mar 2020 14:02:54 +0100
Message-ID: <87tv35fv5t.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 02/03/20 19:40, Vitaly Kuznetsov wrote:
>> 
>>  qemu-system-x86-23579 [005] 22018.775584: kvm_exit:             reason EPT_VIOLATION rip 0xfffff802987d6169 info 181 0
>>  qemu-system-x86-23579 [005] 22018.775584: kvm_nested_vmexit:    rip fffff802987d6169 reason EPT_VIOLATION info1 181 info2 0 int_info 0 int_info_err 0
>>  qemu-system-x86-23579 [005] 22018.775585: kvm_page_fault:       address febd0000 error_code 181
>>  qemu-system-x86-23579 [005] 22018.775592: kvm_emulate_insn:     0:fffff802987d6169: f3 a5
>>  qemu-system-x86-23579 [005] 22018.775593: kvm_emulate_insn:     0:fffff802987d6169: f3 a5 FAIL
>>  qemu-system-x86-23579 [005] 22018.775596: kvm_inj_exception:    #UD (0x0)
>> 
>> We probably need to re-enable instruction emulation for something...
>
> This is a rep movsw instruction, it shouldn't be intercepted.  I think
> we have a stale ctxt->intercept because the
>
>         /* Fields above regs are cleared together. */
>
> comment is not true anymore since
>
>     commit c44b4c6ab80eef3a9c52c7b3f0c632942e6489aa
>     Author: Bandan Das <bsd@redhat.com>
>     Date:   Wed Apr 16 12:46:12 2014 -0400
>
>     KVM: emulate: clean up initializations in init_decode_cache
>

Right you are,

a big hammer like

diff --git a/arch/x86/include/asm/kvm_emulate.h b/arch/x86/include/asm/kvm_emulate.h
index 2a8f2bd..52c9bce 100644
--- a/arch/x86/include/asm/kvm_emulate.h
+++ b/arch/x86/include/asm/kvm_emulate.h
@@ -324,14 +324,6 @@ struct x86_emulate_ctxt {
         */
 
        /* current opcode length in bytes */
-       u8 opcode_len;
-       u8 b;
-       u8 intercept;
-       u8 op_bytes;
-       u8 ad_bytes;
-       struct operand src;
-       struct operand src2;
-       struct operand dst;
        union {
                int (*execute)(struct x86_emulate_ctxt *ctxt);
                fastop_t fop;
@@ -343,6 +335,14 @@ struct x86_emulate_ctxt {
         * or elsewhere
         */
        bool rip_relative;
+       u8 opcode_len;
+       u8 b;
+       u8 intercept;
+       u8 op_bytes;
+       u8 ad_bytes;
+       struct operand src;
+       struct operand src2;
+       struct operand dst;
        u8 rex_prefix;
        u8 lock_prefix;
        u8 rep_prefix;

seems to make the issue go away. (For those wondering why fielf
shuffling makes a difference: init_decode_cache() clears
[rip_relative, modrm) range) How did this even work before...
(I'm still looking at the code, stay tuned...)

-- 
Vitaly

