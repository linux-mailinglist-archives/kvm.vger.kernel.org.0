Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 586CB2744B4
	for <lists+kvm@lfdr.de>; Tue, 22 Sep 2020 16:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbgIVOvg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Sep 2020 10:51:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:26582 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726566AbgIVOvf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Sep 2020 10:51:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600786294;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T0knrs6tVgaSNV2s60uJYONuqcjbeUZokV4VNtZNMLk=;
        b=JsyLtEoV37BxridP874nENTSdhpXq+Oidvefdrzom8bxZERyyWd6nepYGa8s0udtufo4pp
        sMjt+Nmrf78ElzL0hcqs/fAQR10j2k8nDclUMIL8y1cl40SbwMOf2g8xsdVbzZgJF2bADS
        7OefGNjvGUJkOSVh08ObjOoAKBjinpE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-28-YlIhTFmHMzazgkR6wdX0gQ-1; Tue, 22 Sep 2020 10:51:21 -0400
X-MC-Unique: YlIhTFmHMzazgkR6wdX0gQ-1
Received: by mail-wr1-f71.google.com with SMTP id i10so7500505wrq.5
        for <kvm@vger.kernel.org>; Tue, 22 Sep 2020 07:51:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=T0knrs6tVgaSNV2s60uJYONuqcjbeUZokV4VNtZNMLk=;
        b=CppkjHkG2ac1UBhhEJ54pdRRn4tq4bSMe4aJ6leVpvNmi9fMfJq7o7D1fS3SP2F5yO
         Ootn9JwauICq52xPxaFIM1gTql4yOyUwRf6CX8xdDvsyIwMveajnKKjzL0I2ee9Y+N3P
         EjvSqZxCFwiXhJNKV9HvR5EOjBiFi54U8zSP9Wo/voL+0ILI+ZQyqMLCIxQ8hkHu7u+G
         G3afq34o1kvIxEsIKMTUJZmWH4jhouH8cMvcfPjJdbCjUXfYukKiXWVLObZvNOipN0cc
         ukrPD0JVYoZ9uzRRGTDiIlrlt0ZJy8V/iTmZbI02haDBINxDkVKADBHBNVaKmBFZva9p
         yamg==
X-Gm-Message-State: AOAM532w8UHhGUHlyERZOjGO3mGYD1uMBzG+PNaAwaFMziDeVaCTMan4
        tnO5v15VFi+HydjM7tWJgx89DuEUBJJpff6XwZSAMwEZT3NKZwidAvpQAcPu0t42WVm8+Q8GcnF
        PMN0Ybjr19AAq
X-Received: by 2002:a5d:69cd:: with SMTP id s13mr5588734wrw.379.1600786279744;
        Tue, 22 Sep 2020 07:51:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzs7WblyEvgj7BVLIvdaiOHYDOg2/vFwXgvs7E6+qd824PKlhWaSBoYJkhPPjST8YhCmThLyg==
X-Received: by 2002:a5d:69cd:: with SMTP id s13mr5588709wrw.379.1600786279490;
        Tue, 22 Sep 2020 07:51:19 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ec2c:90a9:1236:ebc6? ([2001:b07:6468:f312:ec2c:90a9:1236:ebc6])
        by smtp.gmail.com with ESMTPSA id k22sm28532833wrd.29.2020.09.22.07.51.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2020 07:51:19 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH v2 10/10] travis.yml: Add x86 build with
 clang 10
To:     Roman Bolshakov <r.bolshakov@yadro.com>,
        Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org
References: <20200901085056.33391-1-r.bolshakov@yadro.com>
 <20200901085056.33391-11-r.bolshakov@yadro.com>
 <fb94aa98-f586-a069-20f8-42852f150c0b@redhat.com>
 <20200914144502.GB52559@SPB-NB-133.local>
 <4d20fbce-d247-abf4-3ceb-da2c0d48fc50@redhat.com>
 <20200915155959.GF52559@SPB-NB-133.local>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <788b7191-6987-9399-f352-2e661255157e@redhat.com>
Date:   Tue, 22 Sep 2020 16:51:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200915155959.GF52559@SPB-NB-133.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/09/20 17:59, Roman Bolshakov wrote:
> So, a workaround for that could be adding '-Wl,--build-id=none' to the
> makefile rule for realmode.elf. Then multiboot magic is placed properly
> at 0x4000 instead of 0x4030. Unfortunately it doesn't help with the
> test :-)

Heh, weird.  I also tried adding

    /DISCARD/ : { *(.note.gnu.build-id) }

to the linker script and I got a very helpful (not) linker warning:

/usr/bin/ld: warning: .note.gnu.build-id section discarded, --build-id ignored.

... except that the --build-id was placed not by me but rather by gcc.
So we should probably simplify things doing this:

diff --git a/x86/Makefile.common b/x86/Makefile.common
index 090ce22..10c8a42 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -69,8 +69,8 @@ test_cases: $(tests-common) $(tests)
 $(TEST_DIR)/%.o: CFLAGS += -std=gnu99 -ffreestanding -I $(SRCDIR)/lib -I $(SRCDIR)/lib/x86 -I lib
 
 $(TEST_DIR)/realmode.elf: $(TEST_DIR)/realmode.o
-	$(CC) -m32 -nostdlib -o $@ -Wl,-m,elf_i386 \
-	      -Wl,-T,$(SRCDIR)/$(TEST_DIR)/realmode.lds $^
+	$(LD) -o $@ -m elf_i386 \
+	      -T $(SRCDIR)/$(TEST_DIR)/realmode.lds $^
 
 $(TEST_DIR)/realmode.o: bits = 32
 
diff --git a/x86/realmode.lds b/x86/realmode.lds
index 0ed3063..3220c19 100644
--- a/x86/realmode.lds
+++ b/x86/realmode.lds
@@ -1,5 +1,6 @@
 SECTIONS
 {
+    /DISCARD/ : { *(.note.gnu.build-id) }
     . = 16K;
     stext = .;
     .text : { *(.init) *(.text) }

which I will squash in your patch 3.

But the main issue is that clang does not support .code16gcc so it
writes 32-bit code that is run in 16-bit mode.  It'd be a start to
use -m16 instead of -m32, but then I think it still miscompiles the
(32-bit) code between "start" and the .code16gcc label.

Paolo

