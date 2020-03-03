Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC1417777C
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 14:43:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727935AbgCCNif (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 08:38:35 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:58593 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727585AbgCCNif (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Mar 2020 08:38:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583242714;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZIdK4y2508Xb+/mC7DM2rNqSWal4zqTlltB83tI+9ok=;
        b=Yg7ia4RC2VS+U+6fidNIUeX4vAeARQYWF4cmv6bNBxb7d77/BsYjbLmSP5ffujqIxF9gVg
        IiLHhUkAg6N7NrOYq9Vq8iR6WyW/PncRw2eTMItpPHvw/wwF+jwZgPSE4iltShDukZ9o+a
        XNmhicTDaDXCMIO1hlq5EiC4OoobHXE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-94-x1aP1UdgPxiZxXWjpAaLAQ-1; Tue, 03 Mar 2020 08:38:32 -0500
X-MC-Unique: x1aP1UdgPxiZxXWjpAaLAQ-1
Received: by mail-wr1-f69.google.com with SMTP id c6so1215461wrm.18
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2020 05:38:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=ZIdK4y2508Xb+/mC7DM2rNqSWal4zqTlltB83tI+9ok=;
        b=FZ7hdnAVufUlX4XNluYHQuCD38+KraZzJx8Md9j/WrJ38OFT8wzpbhQQ83sQlNgyRm
         9uUajTBS0RasaH/vBipAs1Dr9cLiNAR+MN1/aAV89yMjgG/zKOoS6nfgwumv0sPtzy91
         I9qNE7hkZ7S3sjszT5u05pWAbMuZzrdgbWiEapw3EZx9ROD/hlGJUwNwyAn8H3WHObnY
         ThnVUMzmrKDfmOaHxfJT4x19Ha5IoPIjhqIzGueuQBOsCWolCFQjhm0a2RQ0ET+nkQnR
         1m5ucSoR8wF+J1Ma9HrHb524rTgKyjcbQl3Dw+B2V3b9x8RCAFd9h3WNdAI5RcW+Wu7h
         VR3g==
X-Gm-Message-State: ANhLgQ25nkaTgvmOOzD7/7W4yWlflBUMjF2078/Q+krr7YKIYqCWxS73
        46Hzyt7uSUyoTfB+nSxGkVntLbTZBrX3T/L2y9xN9Lx6ok67FkVIrhZFLS66+LimdlCZQpXTwYO
        4E7Wqcn4Bn1kp
X-Received: by 2002:adf:e506:: with SMTP id j6mr5414696wrm.309.1583242710883;
        Tue, 03 Mar 2020 05:38:30 -0800 (PST)
X-Google-Smtp-Source: ADFU+vtH8R9P8o+Uo7AGDF83jLl43yugXJTyawCm8EZlL50uB6ig6MkWHi92L0GcizSfOo6phbXeew==
X-Received: by 2002:adf:e506:: with SMTP id j6mr5414680wrm.309.1583242710689;
        Tue, 03 Mar 2020 05:38:30 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id c8sm24438550wru.7.2020.03.03.05.38.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2020 05:38:30 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Oliver Upton <oupton@google.com>
Subject: Re: [GIT PULL] KVM changes for Linux 5.6-rc4
In-Reply-To: <9bb75cdc-961e-0d83-0546-342298517496@redhat.com>
References: <1582570669-45822-1-git-send-email-pbonzini@redhat.com> <87zhcyfvmk.fsf@vitty.brq.redhat.com> <8fbeb3c2-9627-bf41-d798-bafba22073e3@redhat.com> <87tv35fv5t.fsf@vitty.brq.redhat.com> <9bb75cdc-961e-0d83-0546-342298517496@redhat.com>
Date:   Tue, 03 Mar 2020 14:38:29 +0100
Message-ID: <87o8tdftii.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 03/03/20 14:02, Vitaly Kuznetsov wrote:
>> Right you are,
>> 
>> a big hammer like
>> 
>> diff --git a/arch/x86/include/asm/kvm_emulate.h b/arch/x86/include/asm/kvm_emulate.h
>> index 2a8f2bd..52c9bce 100644
>> --- a/arch/x86/include/asm/kvm_emulate.h
>> +++ b/arch/x86/include/asm/kvm_emulate.h
>> @@ -324,14 +324,6 @@ struct x86_emulate_ctxt {
>>          */
>>  
>>         /* current opcode length in bytes */
>> -       u8 opcode_len;
>> -       u8 b;
>> -       u8 intercept;
>> -       u8 op_bytes;
>> -       u8 ad_bytes;
>> -       struct operand src;
>> -       struct operand src2;
>> -       struct operand dst;
>>         union {
>>                 int (*execute)(struct x86_emulate_ctxt *ctxt);
>>                 fastop_t fop;
>> @@ -343,6 +335,14 @@ struct x86_emulate_ctxt {
>>          * or elsewhere
>>          */
>>         bool rip_relative;
>> +       u8 opcode_len;
>> +       u8 b;
>> +       u8 intercept;
>> +       u8 op_bytes;
>> +       u8 ad_bytes;
>> +       struct operand src;
>> +       struct operand src2;
>> +       struct operand dst;
>>         u8 rex_prefix;
>>         u8 lock_prefix;
>>         u8 rep_prefix;
>> 
>> seems to make the issue go away. (For those wondering why fielf
>> shuffling makes a difference: init_decode_cache() clears
>> [rip_relative, modrm) range) How did this even work before...
>> (I'm still looking at the code, stay tuned...)
>
> On AMD, probably because all these instructions were normally trapped by L1.
>
> Of these, however, most need not be zeroed again. op_bytes, ad_bytes,
> opcode_len and b are initialized by x86_decode_insn, and dst/src/src2
> also by decode_operand.  So only intercept is affected, adding
> "ctxt->intercept = x86_intercept_none" should be enough.

This matches my findings, thank you! Patch[es] are coming.

-- 
Vitaly

