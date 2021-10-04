Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A83914206A2
	for <lists+kvm@lfdr.de>; Mon,  4 Oct 2021 09:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbhJDHaI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 03:30:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45793 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230149AbhJDHaC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 Oct 2021 03:30:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633332493;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EYZ/LTvvLx16jE1eNgqc9g2GCASb4awUhWNDIjrf5JI=;
        b=YRsXBAqBq38aU45on0E0hwAweL5zv7oN5CIGciiDWIJqNrJ8A236mpOnwXQJHtjqESRVMc
        W7zOB8VSQLQWMLYTN12xiOjuhgk9bkFSrJj76LDzZuIhtKJ74AK79bewGJmAjfPlMTvbix
        FGfq/R6P65r9c+qTY27XMevYwCBCZS8=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-446-97cvuvhMOxKaAt2y9pjoGQ-1; Mon, 04 Oct 2021 03:28:12 -0400
X-MC-Unique: 97cvuvhMOxKaAt2y9pjoGQ-1
Received: by mail-ed1-f69.google.com with SMTP id y15-20020a50ce0f000000b003dab997cf7dso12729276edi.9
        for <kvm@vger.kernel.org>; Mon, 04 Oct 2021 00:28:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=EYZ/LTvvLx16jE1eNgqc9g2GCASb4awUhWNDIjrf5JI=;
        b=GkkdcWNsFi0QxQjny7QBvPSYOvdcbtrwufr/hlcKL6//eZsincn+AHdzZDH+2a+KSI
         mFA+gg7bqOoPLnEBX+9bSZBu+ko62wXLp/oBxWGb2ROpeTZCmzSDjrOXi0Jhhxe5xBlN
         8fbkzjt9YqUZllprDI0v4l6leJV4YuYcG17MZKsjJcmUljWIc+rkYeT6bnylFcVhulkO
         pWLUO5EUvEQalQHeK65gA9BXA/0qWhjV1oPHrOm1tZ31Ivlkx/vmRnK9tHm0WT6ta0wM
         5L76ae0JcqJjE0j0SzGKhNJgwu9qN68pq6zFccpt7uW/3FsTl3GsjKZ3mLrMXZHzKS8+
         +rJg==
X-Gm-Message-State: AOAM530diFvCsDLso+ZI5IOuW4cSsfNmWKRntqZVlQyHZHHnkkk+fTp8
        BRuuixlGwSnzx+PtNJEUOtT4YpGrHDW23OD/hWItH7PwTNg1HOkcBS1CoSoaImWCyxtWfi514tH
        NnFxEoO/0ZB3O
X-Received: by 2002:a17:906:9401:: with SMTP id q1mr15261245ejx.313.1633332491730;
        Mon, 04 Oct 2021 00:28:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy6IjodyqAgeB1PAWb4RYx1NKLku+W8R/sJTCbRjbEB4EJ9Zbss8oDgUkRXt//jnV39fft8iw==
X-Received: by 2002:a17:906:9401:: with SMTP id q1mr15261224ejx.313.1633332491481;
        Mon, 04 Oct 2021 00:28:11 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id s21sm4348798eji.3.2021.10.04.00.28.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Oct 2021 00:28:10 -0700 (PDT)
Message-ID: <a1a283ab-bede-412d-6552-21a2814b39cb@redhat.com>
Date:   Mon, 4 Oct 2021 09:28:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [GIT PULL] objtool/urgent for v5.15-rc4
Content-Language: en-US
To:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Borislav Petkov <bp@suse.de>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Nathan Chancellor <nathan@kernel.org>, x86-ml <x86@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
References: <YVl7RR5NcbPyiXgO@zn.tnic>
 <CAHk-=wh9JzLmwAqA2+cA=Y4x_TYNBZv_OM4eSEDFPF8V_GAPug@mail.gmail.com>
 <CAHk-=wiZwq-0LknKhXN4M+T8jbxn_2i9mcKpO+OaBSSq_Eh7tg@mail.gmail.com>
 <CAHk-=wjtJ532TqnLN+CLqZJXx=MWHjQqi0-fR8PSQ-nGZ_iMvg@mail.gmail.com>
 <20211003230206.hhrrhna52dnhumji@treble>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211003230206.hhrrhna52dnhumji@treble>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/10/21 01:02, Josh Poimboeuf wrote:
> That said, I have no idea what's going in that code or why
> kvm_fastop_exception() is clearing %esi.

It's handled here (which definitely qualifies as "funky sh*t"):

         asm("push %[flags]; popf; " CALL_NOSPEC " ; pushf; pop %[flags]\n"
             : "+a"(ctxt->dst.val), "+d"(ctxt->src.val), [flags]"+D"(flags),
               [thunk_target]"+S"(fop), ASM_CALL_CONSTRAINT
             : "c"(ctxt->src2.val));

         ctxt->eflags = (ctxt->eflags & ~EFLAGS_MASK) | (flags & EFLAGS_MASK);
         if (!fop) /* exception is returned in fop variable */
                 return emulate_de(ctxt);

and documented here:

/*
  * fastop functions have a special calling convention:
  *
  * dst:    rax        (in/out)
  * src:    rdx        (in/out)
  * src2:   rcx        (in)
  * flags:  rflags     (in/out)
  * ex:     rsi        (in:fastop pointer, out:zero if exception)
  *
  * Moreover, they are all exactly FASTOP_SIZE bytes long, so functions for
  * different operand sizes can be reached by calculation, rather than a jump
  * table (which would be bigger than the code).
  */

The fastop stuff saves quite a few clock cycles and lines of code, by
avoiding complicated emulation of x86 flags.  I'll check out the .global
annotations, since they are indeed unnecessary.

Paolo

