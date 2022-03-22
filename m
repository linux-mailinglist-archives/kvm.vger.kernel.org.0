Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 158E14E3F8B
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 14:29:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235609AbiCVNa6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 09:30:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234496AbiCVNaz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 09:30:55 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A79F127CC4
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 06:29:28 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id p184-20020a1c29c1000000b0037f76d8b484so1724199wmp.5
        for <kvm@vger.kernel.org>; Tue, 22 Mar 2022 06:29:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=fG9HbzCKw1GM4kFdIeLZU3ef1PIf/GnDdByrJY9IDtI=;
        b=l5cRMLA71wXL2GFyxJNtw3l5sIjkmgSK8OimI6mBXsbfcJww6pyRvb2QBR0n8E9tu5
         QsM6iL/G6rJUuUz1eY3+e6+BMXhxuta/cTCRhO2+FuEOwak0t+uEssoVwrv3KGNH3Lgj
         9xpy0SvHttXboqsRjfC3KcgDlXncw9PgcwCz7QkEKfCSjrEF6HOSCvZ87w110XEd+hHB
         dnHoUwGPb4xuULdAEeX/l0oGnsMmW9oZvZst/2PlJ6p9PQyp+B+K7jBjDW5Vb6Zm/tQX
         F9Ko40p1EuaBDK1Vag73lEO2JU5K85ujGCjUf/uvO4LQv4tXBglhJGhbEaM3Jyeswtz0
         0xqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fG9HbzCKw1GM4kFdIeLZU3ef1PIf/GnDdByrJY9IDtI=;
        b=14a9JBci9WMczv/jluor+yfelz+ApHKCVEBK4A7fNPS+hw+oJ2yP89s/hhBTuRgks0
         5fG1m0vaVgl26+h7puxChhlliX341bLJRUnUky7XaQ72zijJNSgaJb5MFDbkdPr00I7Q
         VyCoXOnqJQ1OtIzb6a6G0LDoMqU87miKxhHdOyN10h+lq5TGZ4O/hZv/c3a65d9rT+Cn
         6iaJvpcuxHYqjg2NsSYnor6nbIygMDTLC65AlAw8/Qyux5r+vXWha8ahoxvLyO0NReZD
         oiVeZ/x9Z6BwBI5E5tzjO57PETqv0UkNfwzLqZupYNUbA3t2cyH3Au35Ganrnl/Bco9F
         VwqA==
X-Gm-Message-State: AOAM531bpQFTjQg2JIQrsD3H+HFIRmi2dws3uRIZP4qANQYm2cFBGs8L
        Cc34FrQlrW9oo0va2ve1Pps=
X-Google-Smtp-Source: ABdhPJwMQA3KXffkE8yeaemCOJpEmz59thlUG4Zt55AGFcq7ZvPvgziVKGuj+23qtyYOAkANdkQZZA==
X-Received: by 2002:a05:6000:1687:b0:205:80b7:afca with SMTP id y7-20020a056000168700b0020580b7afcamr525192wrd.665.1647955767166;
        Tue, 22 Mar 2022 06:29:27 -0700 (PDT)
Received: from [192.168.1.33] (198.red-83-50-65.dynamicip.rima-tde.net. [83.50.65.198])
        by smtp.gmail.com with ESMTPSA id g6-20020a5d5406000000b001f049726044sm15548581wrv.79.2022.03.22.06.29.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Mar 2022 06:29:26 -0700 (PDT)
Message-ID: <e4603209-651f-a0a0-d7be-255e0ddf2db7@gmail.com>
Date:   Tue, 22 Mar 2022 14:29:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [RFC PATCH-for-7.0 v4] target/i386/kvm: Free xsave_buf when
 destroying vCPU
Content-Language: en-US
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        Mark Kanda <mark.kanda@oracle.com>
References: <20220322120522.26200-1-philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= 
        <philippe.mathieu.daude@gmail.com>
In-Reply-To: <20220322120522.26200-1-philippe.mathieu.daude@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/3/22 13:05, Philippe Mathieu-Daudé wrote:
> From: Philippe Mathieu-Daudé <f4bug@amsat.org>
> 
> Fix vCPU hot-unplug related leak reported by Valgrind:
> 
>    ==132362== 4,096 bytes in 1 blocks are definitely lost in loss record 8,440 of 8,549
>    ==132362==    at 0x4C3B15F: memalign (vg_replace_malloc.c:1265)
>    ==132362==    by 0x4C3B288: posix_memalign (vg_replace_malloc.c:1429)
>    ==132362==    by 0xB41195: qemu_try_memalign (memalign.c:53)
>    ==132362==    by 0xB41204: qemu_memalign (memalign.c:73)
>    ==132362==    by 0x7131CB: kvm_init_xsave (kvm.c:1601)
>    ==132362==    by 0x7148ED: kvm_arch_init_vcpu (kvm.c:2031)
>    ==132362==    by 0x91D224: kvm_init_vcpu (kvm-all.c:516)
>    ==132362==    by 0x9242C9: kvm_vcpu_thread_fn (kvm-accel-ops.c:40)
>    ==132362==    by 0xB2EB26: qemu_thread_start (qemu-thread-posix.c:556)
>    ==132362==    by 0x7EB2159: start_thread (in /usr/lib64/libpthread-2.28.so)
>    ==132362==    by 0x9D45DD2: clone (in /usr/lib64/libc-2.28.so)
> 
> Reported-by: Mark Kanda <mark.kanda@oracle.com>
> Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
> ---
> Based on a series from Mark:
> https://lore.kernel.org/qemu-devel/20220321141409.3112932-1-mark.kanda@oracle.com/
> 
> RFC because currently no time to test

Mark, do you mind testing this patch?
