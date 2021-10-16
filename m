Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6AB430598
	for <lists+kvm@lfdr.de>; Sun, 17 Oct 2021 01:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241138AbhJPXUL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 16 Oct 2021 19:20:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28488 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241106AbhJPXUK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 16 Oct 2021 19:20:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634426281;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HCVbnrjBym+xHk1LNyRIm4ecriHGN7RSnn9/6F207xY=;
        b=F60h0VNLhb+0RnXNL0fhd6b8AahPm6tjYIwCqS8iPs5c9cjWB/RqAB/Az07tVfSuJwgjoo
        pLT2lWAme3Uww640i8iAk5XwZ+Rui/WxKghRy8G8ZcGrjUGfcHGcNeTwnX1VDGNJkTexTP
        E/f3tV4ywtKrAHQ+fCa7N+ftyYZE+Bo=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-305-LNZNKEBwPgGLGzuYVwCNFQ-1; Sat, 16 Oct 2021 19:18:00 -0400
X-MC-Unique: LNZNKEBwPgGLGzuYVwCNFQ-1
Received: by mail-ed1-f72.google.com with SMTP id t18-20020a056402021200b003db9e6b0e57so11165093edv.10
        for <kvm@vger.kernel.org>; Sat, 16 Oct 2021 16:18:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=HCVbnrjBym+xHk1LNyRIm4ecriHGN7RSnn9/6F207xY=;
        b=HKVcCwEp9dYoDL9nVantkDLaHsCN905H5Hp+IlxDHZEU0CTo1R3Vt23As0N/fxpYSs
         Cuc3nQ//pzXZA00bRlleaxF7XjBj/QRFbieDzy429lQ2IpLQ/GN84fJCw0Co+Ae1E2gD
         gf+3CFOykE1/6B2oaPdbL6uMW9mwM67z3fuuscmrN2xVpPRvNv74U5HR7lKiRwlg7u1P
         sHvipKKGs3cjCi0sRm0MX5hKUX+r+5solcB6LqogCaPAM1ZVHVbtHfAwKMYVV6BMbcep
         N/VC4AhVJZN0INrCeWl5sYnrylAkQVSYtc05QLiprbg/tcf4wjSx/FLj+x1Rp2spFpqA
         U8dw==
X-Gm-Message-State: AOAM531CvqdlmoJdQz7Sr0uxxSFm8UdeawOe7Qv9iAp4WGueIIEQ6tV7
        x8S9pomNZJ7rmnqSJY0Vss1YcjXr1K0RlVoiRuJdbvdKJtZMFZuJ6OjDvalXE8V0LmgY3wKUdKx
        lNxU6NiWTuflz
X-Received: by 2002:a05:6402:2807:: with SMTP id h7mr30363789ede.58.1634426278730;
        Sat, 16 Oct 2021 16:17:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxGmDm7spkZZsyiW3CU9rW1i8SA5Shq2Cl8jrzPJ2hC6ecbA1MCb5b6l45djxrXTsZKwIlzkQ==
X-Received: by 2002:a05:6402:2807:: with SMTP id h7mr30363763ede.58.1634426278477;
        Sat, 16 Oct 2021 16:17:58 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id c26sm1551864edx.2.2021.10.16.16.17.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Oct 2021 16:17:57 -0700 (PDT)
Message-ID: <10e3d402-017e-1a0d-b6c7-112117067b03@redhat.com>
Date:   Sun, 17 Oct 2021 01:17:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH] mm: allow huge kvmalloc() calls if they're accounted to
 memcg
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     KVM list <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Willy Tarreau <w@1wt.eu>, Kees Cook <keescook@chromium.org>,
        syzbot+e0de2333cbf95ea473e8@syzkaller.appspotmail.com
References: <20211016064302.165220-1-pbonzini@redhat.com>
 <CAHk-=wijGo_yd7GiTMcgR+gv0ESRykwnOn+XHCEvs3xW3x6dCg@mail.gmail.com>
 <510287f2-84ae-b1d2-13b5-22e847284588@redhat.com>
 <CAHk-=whZ+iCW5yMc3zuTpZrZzjb082xtVyzk3rV+S0SUNrtAAw@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <CAHk-=whZ+iCW5yMc3zuTpZrZzjb082xtVyzk3rV+S0SUNrtAAw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/10/21 20:10, Linus Torvalds wrote:
> That said, I also do wonder if we could possibly change "kvcalloc()"
> to avoid the warning. The reason I didn't like your patch is that
> kvmalloc_node() only takes a "size_t", and the overflow condition
> there is that "MAX_INT".
> 
> But the "kvcalloc()" case that takes a "number of elements and size"
> should _conceptually_ warn not when the total size overflows, but when
> either number or the element size overflows.

That makes sense, but the number could still overflow in KVM's case; the
size is small, just 8, it's the count that's humongous.  In general,
users of kvcalloc of kvmalloc_array *should* not be doing
multiplications (that's the whole point of the functions), and that
lowers a lot the risk of overflows, but the safest way is to provide
a variant that does not warn.  See the (compile-tested only) patch
below.

Pulling the WARN in the inline function is a bit ugly.  For kvcalloc()
and kvmalloc_array(), one of the two is almost always constant, but
it is unlikely that the compiler eliminates both.  The impact on a
localyesconfig build seems to be minimal though (about 150 bytes
larger out of 20 megabytes of code).

Paolo

---------------- 8< -----------------
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH] mm: add kvmalloc variants that do not to warn

Commit 7661809d493b ("mm: don't allow oversized kvmalloc() calls")
restricted memory allocation with 'kvmalloc()' to sizes that fit
in an 'int', to protect against trivial integer conversion issues.
     
However, the WARN triggers with KVM when it allocates ancillary page
data, whose size essentially depends on whatever userspace has passed to
the KVM_SET_USER_MEMORY_REGION ioctl.  The warnings are quickly found by
syzkaller, but they can also happen with huge but real-world VMs.
The largest allocation that KVM can do is 8 bytes per page of guest
memory, meaning a 1 TiB memslot will cause a warning even outside fuzzing.
In fact, Google already has VMs that create 1.5 TiB memslots (12 TiB of
total guest memory spread across 8 virtual NUMA nodes).

For kvcalloc() and kvmalloc_array(), Linus suggested warning if either
the number or the size are big.  However, this would only move the
goalpost for KVM's warning without fully avoiding it.  Therefore,
provide a "double underscore" version of kvcalloc(), kvmalloc_array()
and kvmalloc_node() that omits the check.

Cc: Willy Tarreau <w@1wt.eu>
Cc: Kees Cook <keescook@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 73a52aba448f..92aba7327bd8 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -799,7 +799,15 @@ static inline int is_vmalloc_or_module_addr(const void *x)
  }
  #endif
  
-extern void *kvmalloc_node(size_t size, gfp_t flags, int node);
+extern void *__kvmalloc_node(size_t size, gfp_t flags, int node);
+static inline void *kvmalloc_node(size_t size, gfp_t flags, int node)
+{
+	/* Don't even allow crazy sizes */
+	if (WARN_ON(size > INT_MAX))
+		return NULL;
+	return __kvmalloc_node(size, flags, node);
+}
+
  static inline void *kvmalloc(size_t size, gfp_t flags)
  {
  	return kvmalloc_node(size, flags, NUMA_NO_NODE);
@@ -813,14 +821,31 @@ static inline void *kvzalloc(size_t size, gfp_t flags)
  	return kvmalloc(size, flags | __GFP_ZERO);
  }
  
-static inline void *kvmalloc_array(size_t n, size_t size, gfp_t flags)
+static inline void *__kvmalloc_array(size_t n, size_t size, gfp_t flags)
  {
  	size_t bytes;
  
  	if (unlikely(check_mul_overflow(n, size, &bytes)))
  		return NULL;
  
-	return kvmalloc(bytes, flags);
+	return __kvmalloc_node(bytes, flags, NUMA_NO_NODE);
+}
+
+static inline void *kvmalloc_array(size_t n, size_t size, gfp_t flags)
+{
+	/*
+	 * Don't allow crazy sizes here, either.  For 64-bit,
+	 * this also lets the compiler avoid the overflow check.
+	 */
+	if (WARN_ON(size > INT_MAX || n > INT_MAX))
+		return NULL;
+
+	return __kvmalloc_array(n, size, flags);
+}
+
+static inline void *__kvcalloc(size_t n, size_t size, gfp_t flags)
+{
+	return __kvmalloc_array(n, size, flags | __GFP_ZERO);
  }
  
  static inline void *kvcalloc(size_t n, size_t size, gfp_t flags)
diff --git a/mm/util.c b/mm/util.c
index 499b6b5767ed..0406709d8097 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -558,7 +558,7 @@ EXPORT_SYMBOL(vm_mmap);
   *
   * Return: pointer to the allocated memory of %NULL in case of failure
   */
-void *kvmalloc_node(size_t size, gfp_t flags, int node)
+void *__kvmalloc_node(size_t size, gfp_t flags, int node)
  {
  	gfp_t kmalloc_flags = flags;
  	void *ret;
@@ -593,14 +593,10 @@ void *kvmalloc_node(size_t size, gfp_t flags, int node)
  	if (ret || size <= PAGE_SIZE)
  		return ret;
  
-	/* Don't even allow crazy sizes */
-	if (WARN_ON_ONCE(size > INT_MAX))
-		return NULL;
-
  	return __vmalloc_node(size, 1, flags, node,
  			__builtin_return_address(0));
  }
-EXPORT_SYMBOL(kvmalloc_node);
+EXPORT_SYMBOL(__kvmalloc_node);
  
  /**
   * kvfree() - Free memory.

> So I would also accept a patch that just changes how "kvcalloc()"
> works (or how "kvmalloc_array()" works).
> 
> It's a bit annoying how we've ended up losing that "n/size"
> information by the time we hit kvmalloc().
> 
>                 Linus
> 

