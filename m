Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A82B0367E45
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 12:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235647AbhDVKDe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Apr 2021 06:03:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37627 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235583AbhDVKD1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 22 Apr 2021 06:03:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619085759;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uUwM1AKdnWp11aQqU2FXPyxf/Su9yfpl5UG8AutMED0=;
        b=D9pXabPyI1PlwP1V/vbEo43cls3IA+ZdqlyalRF2V46Dbm2QA31NE0qGQRUzpYeoX+45cH
        ZeBx8dx97fkZK+Os3UUPqIO8aJSeaP2NvQWNlNgk4T3eOgd4v3vjOvb09C/Fut1Ulz9nSP
        N0SE7tnAomh6s2rLbTl2w9l5z7gTEZc=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-201-S7I5nJsjNUqXjswDF2-dEg-1; Thu, 22 Apr 2021 06:02:31 -0400
X-MC-Unique: S7I5nJsjNUqXjswDF2-dEg-1
Received: by mail-ej1-f72.google.com with SMTP id c18-20020a17090603d2b029037c77ad778eso6993998eja.1
        for <kvm@vger.kernel.org>; Thu, 22 Apr 2021 03:02:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uUwM1AKdnWp11aQqU2FXPyxf/Su9yfpl5UG8AutMED0=;
        b=T1f2W5YvRmTt8zpmvnDrhj+f1mFWt9TtK3OWJNjcDFQ9yvtZ+pjarpzi+cmXoGSECD
         3WppYp80cNY/FzOzkzdXNMOLmAHgAcVAAWB1WXKYROTErInDqanbtvAaaH1LRwqt/Y4m
         627x9gxE718KqKHJWqLk7mAqqPxclW7QTi2qrwM55w7f7jSd24b5c/iuF7P+BOqrqJhD
         OZLfZOnz91pM7GmnJc8awXw4cepU0h/VkkhjMz7I1toY6ZDBV5DeuezNtm561jPpCrxf
         dlo4cX/m/kEuWUFuWaQGprJ7+PDgbgeAEP/XPC5XqbSvrgpTWAYc/2t4px71ZkR0vLbo
         gF2g==
X-Gm-Message-State: AOAM532leEgZNtJ4y42TKMESHNu5UbuSztHbwceksF0gGNRPjHQv7pZs
        2xGCiOonb0kv2jnRP0Q9LaCpxcgyaon0Dz5aDpFkDseI5NA8+l9Xa0/JgYgdLEJOujCbqag8aLK
        DlpJskjruqxUBOlBCIZe14zPcUTN3BBIT8OMnRdqIB5X3EdZhJEu2xKhz2GbKvbf6
X-Received: by 2002:a17:906:dbd5:: with SMTP id yc21mr2570289ejb.29.1619085750134;
        Thu, 22 Apr 2021 03:02:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyjU46meRVPECdxCAyHRog5CRK/M4VxxvZnxSU9RnQrjwiVP9UHeaorZwQ7CvRjbI3mbacPqA==
X-Received: by 2002:a17:906:dbd5:: with SMTP id yc21mr2570257ejb.29.1619085749893;
        Thu, 22 Apr 2021 03:02:29 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id nc39sm1466337ejc.41.2021.04.22.03.02.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Apr 2021 03:02:29 -0700 (PDT)
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
References: <20210422030504.3488253-1-seanjc@google.com>
 <20210422030504.3488253-2-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 01/14] x86/cstart: Don't use MSR_GS_BASE in
 32-bit boot code
Message-ID: <24a92fa2-6d31-f1c2-6661-8b6f3f41766c@redhat.com>
Date:   Thu, 22 Apr 2021 12:02:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210422030504.3488253-2-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/04/21 05:04, Sean Christopherson wrote:
> Load the per-cpu GS.base for 32-bit build by building a temporary GDT
> and loading a "real" segment.  Using MSR_GS_BASE is wrong and broken,
> it's a 64-bit only MSR and does not exist on 32-bit CPUs.  The current
> code works only because 32-bit KVM VMX incorrectly disables interception
> of MSR_GS_BASE, and no one runs KVM on an actual 32-bit physical CPU,
> i.e. the MSR exists in hardware and so everything "works".
> 
> 32-bit KVM SVM is not buggy and correctly injects #GP on the WRMSR, i.e.
> the tests have never worked on 32-bit SVM.

Hmm, this breaks task switch.  But setting up separate descriptors is
not hard:

diff --git a/x86/cstart.S b/x86/cstart.S
index 489c561..7d9ed96 100644
--- a/x86/cstart.S
+++ b/x86/cstart.S
@@ -58,6 +58,10 @@ tss_descr:
          .rept max_cpus
          .quad 0x000089000000ffff // 32-bit avail tss
          .endr
+percpu_descr:
+        .rept max_cpus
+        .quad 0x00cf93000000ffff // 32-bit data segment for perCPU area
+        .endr
  gdt32_end:

  i = 0
@@ -89,13 +93,23 @@ mb_flags = 0x0
  	.long mb_magic, mb_flags, 0 - (mb_magic + mb_flags)
  mb_cmdline = 16

-MSR_GS_BASE = 0xc0000101
-
  .macro setup_percpu_area
  	lea -4096(%esp), %eax
-	mov $0, %edx
-	mov $MSR_GS_BASE, %ecx
-	wrmsr
+
+	/* fill GS_BASE in the GDT */
+	mov $(APIC_DEFAULT_PHYS_BASE + APIC_ID), %ebx
+	mov (%ebx), %ebx
+	shr $24, %ebx
+	or %ax, percpu_descr+2(,%ebx,8)
+
+	shr $16, %eax
+	or %al, percpu_descr+4(,%ebx,8)
+	or %ah, percpu_descr+7(,%ebx,8)
+
+	lgdtl gdt32_descr
+	lea percpu_descr-gdt32(,%ebx,8), %eax
+	mov %ax, %gs
+
  .endm

  .macro setup_segments
@@ -188,16 +202,14 @@ load_tss:
  	mov (%eax), %eax
  	shr $24, %eax
  	mov %eax, %ebx
-	shl $3, %ebx
  	mov $((tss_end - tss) / max_cpus), %edx
  	imul %edx
  	add $tss, %eax
-	mov %ax, tss_descr+2(%ebx)
+	mov %ax, tss_descr+2(,%ebx,8)
  	shr $16, %eax
-	mov %al, tss_descr+4(%ebx)
-	shr $8, %eax
-	mov %al, tss_descr+7(%ebx)
-	lea tss_descr-gdt32(%ebx), %eax
+	mov %al, tss_descr+4(,%ebx,8)
+	mov %ah, tss_descr+7(,%ebx,8)
+	lea tss_descr-gdt32(,%ebx,8), %eax
  	ltr %ax
  	ret


Paolo

