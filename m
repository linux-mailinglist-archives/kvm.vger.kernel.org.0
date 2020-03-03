Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 419B91776A6
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 14:08:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729278AbgCCNHJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 08:07:09 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:36638 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727577AbgCCNHH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 3 Mar 2020 08:07:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583240825;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tl1DdVHIR0INqv1Lc6Z+ydsIpF+tIS1d2YorStHVEYY=;
        b=FJ5SGdlBlYEoa+SYT4XjDmg2xcKJu1ltRTiCtiLTF2tpDgzUOyBd70WTPcBWXeQ89RTIjk
        qrU7Fd966CPcXJR8RtwvfTfacIBpJwBuzSfLqr5LjQOQeM6G6ioP+E1CNOGrvOzASe/rLq
        WFdxWDM0HL6+QUr/wsy81rBOqglCtok=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-251-45xVfo2JNk6IAUHbJaukuw-1; Tue, 03 Mar 2020 08:07:04 -0500
X-MC-Unique: 45xVfo2JNk6IAUHbJaukuw-1
Received: by mail-wm1-f70.google.com with SMTP id j130so1057079wmj.9
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2020 05:07:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tl1DdVHIR0INqv1Lc6Z+ydsIpF+tIS1d2YorStHVEYY=;
        b=g5YGeuLvbs5/9nMZ9pj0AQNVSGsN3Hsv+VhP66tMvEyf+jZYf/6uhXPWefRBSJdbQ9
         eu9lNGEa8uvTlkk1rEOOOjzGfwPJ2GsFiUD/FdBsWR4Jai2SGFfD1m14woCAfaNfYG2g
         vEnD1gF+fDLGphMFSyQE1RnHVCpd0Uv3uEcR2XF/Ae7DmMtHl8BQqM6LGEorYOegBhXc
         kybzsPbEs0bN4KiMze1SHb1ibM7alTd653vicfUa0qU/5bjbi+szYkmFSl3vPfLtI4SN
         tRO6uojpbIYwphNikeJlmENAsgDbhikcLf8OL0xqV/mminkFjmUNWbtJoL39jNRzQs+C
         sCIg==
X-Gm-Message-State: ANhLgQ1E3S/qp5eyYhi5pBJm0NomWT1ciccZIpl0Ev3ZGsMukDm/etyz
        QUwfaEBysBSruW1o3aV4sC7yD6OlDuOoHeEXMuWLaVO8CJAF78yucKLjo36wQMlwRXpzlybI1Pc
        4UjAqcYPHgLcp
X-Received: by 2002:adf:ead0:: with SMTP id o16mr5553466wrn.239.1583240822804;
        Tue, 03 Mar 2020 05:07:02 -0800 (PST)
X-Google-Smtp-Source: ADFU+vvFs9exZ1u3AtWywZibzYcaabPn0O0rGCmokmbu9tlh8xMRqE0sD77JYX5tNmKGqzWToOmDKQ==
X-Received: by 2002:adf:ead0:: with SMTP id o16mr5553444wrn.239.1583240822570;
        Tue, 03 Mar 2020 05:07:02 -0800 (PST)
Received: from [192.168.178.40] ([151.20.254.94])
        by smtp.gmail.com with ESMTPSA id f17sm13075895wrm.3.2020.03.03.05.07.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Mar 2020 05:07:01 -0800 (PST)
Subject: Re: [GIT PULL] KVM changes for Linux 5.6-rc4
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Oliver Upton <oupton@google.com>
References: <1582570669-45822-1-git-send-email-pbonzini@redhat.com>
 <87zhcyfvmk.fsf@vitty.brq.redhat.com>
 <8fbeb3c2-9627-bf41-d798-bafba22073e3@redhat.com>
 <87tv35fv5t.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9bb75cdc-961e-0d83-0546-342298517496@redhat.com>
Date:   Tue, 3 Mar 2020 14:07:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <87tv35fv5t.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/03/20 14:02, Vitaly Kuznetsov wrote:
> Right you are,
> 
> a big hammer like
> 
> diff --git a/arch/x86/include/asm/kvm_emulate.h b/arch/x86/include/asm/kvm_emulate.h
> index 2a8f2bd..52c9bce 100644
> --- a/arch/x86/include/asm/kvm_emulate.h
> +++ b/arch/x86/include/asm/kvm_emulate.h
> @@ -324,14 +324,6 @@ struct x86_emulate_ctxt {
>          */
>  
>         /* current opcode length in bytes */
> -       u8 opcode_len;
> -       u8 b;
> -       u8 intercept;
> -       u8 op_bytes;
> -       u8 ad_bytes;
> -       struct operand src;
> -       struct operand src2;
> -       struct operand dst;
>         union {
>                 int (*execute)(struct x86_emulate_ctxt *ctxt);
>                 fastop_t fop;
> @@ -343,6 +335,14 @@ struct x86_emulate_ctxt {
>          * or elsewhere
>          */
>         bool rip_relative;
> +       u8 opcode_len;
> +       u8 b;
> +       u8 intercept;
> +       u8 op_bytes;
> +       u8 ad_bytes;
> +       struct operand src;
> +       struct operand src2;
> +       struct operand dst;
>         u8 rex_prefix;
>         u8 lock_prefix;
>         u8 rep_prefix;
> 
> seems to make the issue go away. (For those wondering why fielf
> shuffling makes a difference: init_decode_cache() clears
> [rip_relative, modrm) range) How did this even work before...
> (I'm still looking at the code, stay tuned...)

On AMD, probably because all these instructions were normally trapped by L1.

Of these, however, most need not be zeroed again. op_bytes, ad_bytes,
opcode_len and b are initialized by x86_decode_insn, and dst/src/src2
also by decode_operand.  So only intercept is affected, adding
"ctxt->intercept = x86_intercept_none" should be enough.

Paolo

