Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09B1B21BEB4
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 22:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbgGJUpJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 16:45:09 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:27269 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726828AbgGJUpI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Jul 2020 16:45:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594413907;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q2ncdfUg6hbnEeZ6IwEyPnmDyDrK8PHZfmwfUuNJCq4=;
        b=NHTFhTnxanRTrLDI39Dfgd3S91sJ6aGKufaFr95v2J9ch6U3AjZNaIizqtv2Xy/F99kt9K
        BsGSXc18O/yUMQWDJTn6Kam8YuzPlvZ8J5dq+q/jHTvT1tyD4XNnDyhZYKXwCW/cu1sf6Q
        QIFFD+8cSz1LNiiY4K1k9j6h5GPvk0I=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-336-9oPEwrkhNcKDEC6JUsIQrQ-1; Fri, 10 Jul 2020 16:45:04 -0400
X-MC-Unique: 9oPEwrkhNcKDEC6JUsIQrQ-1
Received: by mail-wm1-f72.google.com with SMTP id z74so2613396wmc.4
        for <kvm@vger.kernel.org>; Fri, 10 Jul 2020 13:45:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=q2ncdfUg6hbnEeZ6IwEyPnmDyDrK8PHZfmwfUuNJCq4=;
        b=BjPYtO3++I1+O+aDGl0JdlIny4MhkMXHnIt0wgu72KS3sFF4IoaE0Sk62wk9gkYudM
         Tp5NJvwewkBU8WGqGC/Y27JN5Gjhriy2nMa9J74pcePAOGzcB17MOChXs6LzwHkasqax
         ZdTvFQRoB7BDiGCqYxwXys88TbxZMmtEJN/pXD/qk+l87B1xsNWqrYPBN28pK2JGrQog
         1gY66z35N0P9hSkn99c2ScDNj4z8p0YLhm4Zmg100D+9VsEvE9ZSBxDUsNCuJw3nDvaW
         HHeibQAwr49IdtCcADYW6MhIyfu3wNPs7Xwi1SsnbvilUEIRDX2bQoiOlrmXHTrA+VXo
         Y+rw==
X-Gm-Message-State: AOAM5338/aqyxejaoSWTPG9rp+0ET/P+haNdKAGLtMXliTr2Zv95Eo/s
        hQ4deiYvxJtS48+ZpjndnlioTwUM0pWxmxzcu19lQ4XWUm+vddjubawDLVXGHxZm+UGxY/RHcNg
        AKQs6xfTUn0Xf
X-Received: by 2002:a1c:9d0c:: with SMTP id g12mr7102452wme.107.1594413903035;
        Fri, 10 Jul 2020 13:45:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzW8vcws6C1KdUZZ32IiPb+dtmqaaQJax2a2iVtn8G+nPHbHC71QGK4P7igjsyB2O6soxseuA==
X-Received: by 2002:a1c:9d0c:: with SMTP id g12mr7102441wme.107.1594413902832;
        Fri, 10 Jul 2020 13:45:02 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ef:39d9:1ecb:6054? ([2001:b07:6468:f312:ef:39d9:1ecb:6054])
        by smtp.gmail.com with ESMTPSA id t2sm10901292wma.43.2020.07.10.13.45.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jul 2020 13:45:02 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 1/4] x86: svm: clear CR4.DE on DR intercept
 test
To:     Nadav Amit <namit@vmware.com>
Cc:     kvm@vger.kernel.org
References: <20200710183320.27266-1-namit@vmware.com>
 <20200710183320.27266-2-namit@vmware.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8b7970c9-0b9e-6108-dfeb-4d871ab425b0@redhat.com>
Date:   Fri, 10 Jul 2020 22:45:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200710183320.27266-2-namit@vmware.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/07/20 20:33, Nadav Amit wrote:
> DR4/DR5 can only be written when CR4.DE is clear, and otherwise trigger
> a #GP exception. The BIOS might not clear CR4.DE so update the tests not
> to make this assumption.
> 
> Signed-off-by: Nadav Amit <namit@vmware.com>
> ---
>  x86/svm_tests.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/x86/svm_tests.c b/x86/svm_tests.c
> index d4d130f..9adee23 100644
> --- a/x86/svm_tests.c
> +++ b/x86/svm_tests.c
> @@ -171,6 +171,7 @@ static void prepare_dr_intercept(struct svm_test *test)
>      default_prepare(test);
>      vmcb->control.intercept_dr_read = 0xff;
>      vmcb->control.intercept_dr_write = 0xff;
> +    vmcb->save.cr4 &= ~X86_CR4_DE;
>  }
>  
>  static void test_dr_intercept(struct svm_test *test)
> 

I think we should just start with a clean slate and clear CR4 in cstart*.S:

------------ 8< ------------
From d86ef5851964521c4558e73e43187912718e6746 Mon Sep 17 00:00:00 2001
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 10 Jul 2020 16:44:18 -0400
Subject: [PATCH kvm-unit-tests] cstart: do not assume CR4 starts as zero

The BIOS might leave some bits set in CR4; for example, CR4.DE=1 would
cause the SVM test for the DR intercept to fail, because DR4/DR5
can only be written when CR4.DE is clear, and otherwise trigger
a #GP exception.

Reported-by: Nadav Amit <namit@vmware.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/x86/cstart.S b/x86/cstart.S
index 409cb00..e63e4e2 100644
--- a/x86/cstart.S
+++ b/x86/cstart.S
@@ -125,8 +125,7 @@ start:
         jmpl $8, $start32
 
 prepare_32:
-	mov %cr4, %eax
-	bts $4, %eax  // pse
+	mov %(1 << 4), %eax // pse
 	mov %eax, %cr4
 
 	mov $pt, %eax
diff --git a/x86/cstart64.S b/x86/cstart64.S
index fabcdbf..3ae98d3 100644
--- a/x86/cstart64.S
+++ b/x86/cstart64.S
@@ -176,8 +176,7 @@ prepare_64:
 	setup_segments
 
 enter_long_mode:
-	mov %cr4, %eax
-	bts $5, %eax  // pae
+	mov $(1 << 5), %eax // pae
 	mov %eax, %cr4
 
 	mov pt_root, %eax

WDYT?

Paolo

