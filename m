Return-Path: <kvm+bounces-3021-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 879C97FFC6E
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 21:28:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C1AF21C20DB7
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 20:28:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4498556459;
	Thu, 30 Nov 2023 20:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JESR4D/S"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A6A41703
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 12:28:09 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-5c27822f1b6so1382279a12.2
        for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 12:28:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701376089; x=1701980889; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4OV4iNp1w41nYYoXLoX47tRgNsubd9PkYcYHlp6v5Ac=;
        b=JESR4D/SMy+tEtRVMEMg+JPiL8wFcuss6ItmFTbhNE8e+lzHHRvZy6etYTNArz/4Cc
         TlK/UsDIkUJGV+AZtENwSYVa6py70kslDCpEuvGBsOgKrQa0Z/+10pLa3Uw8V+GXO9DF
         rqz9K0i8L3p+1pcBPywdCM423eRWEKu+8qt17ikqEBOXyyEX+zO6ds90KyIjsHism/gk
         nhzI3weejNOQriGzeGaMOdqhxf0zPtdY2+1crF6CXMeXOedsOZlCTZSazlJ9xJ5GsKvn
         Vn+a78PIWoFH9iRup4Hb9w76OPCjRbKcaVb6lTXwM1yfQy70GgVd1uFseIvPuIeIcO4P
         8KxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701376089; x=1701980889;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4OV4iNp1w41nYYoXLoX47tRgNsubd9PkYcYHlp6v5Ac=;
        b=i6097o+k/a+dHgLVCqoTGxZTxJwLTKnC7Bm0olhaOuhkAaVxmWzv7eLym32SMPAQMu
         dWxh/d9OP7vx2cC61iTef+ELZhII5BtjrYsvYybC+WaGI955wKeYhhS7fdsVgWLFLh/U
         058OxYweP27J+elXiWX1eoWW5YLw64ZLBUb74dx3eS12iYIPENHZkIiZ5rWMSApj2wgW
         EgwA+7Y7eSd7HVWQP2dvzll4S3rbNgdb7HVce15D4Qj7wjmfU9chZtwDwsjr4vTkjMBT
         WhbUA+fkjYDDd26abRLL23ZubYzGzdC9pM2Z546pebWbn3AOH10SC8fUOF1kHYQvq/93
         W5rg==
X-Gm-Message-State: AOJu0Yx0d37yIq1kVZqzVwW1DQXaD7Ew3EnbWcLbY4CThp5VwCd6UDkr
	HJp+XW4O+x271GtxXn1U9a/ycYGHda8=
X-Google-Smtp-Source: AGHT+IHQaxLEqA5rxsivnhYLveGHXMN8rfV5UgZ8GpYx6Dig6VjxZKpBbPSRb9b7A6hv0E+T/P1KhLt82O8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:e84f:b0:1cf:ee4c:1200 with SMTP id
 t15-20020a170902e84f00b001cfee4c1200mr1827241plg.5.1701376088878; Thu, 30 Nov
 2023 12:28:08 -0800 (PST)
Date: Thu, 30 Nov 2023 12:28:07 -0800
In-Reply-To: <ZTcO8M3T9DGYrN2M@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231024001636.890236-1-jmattson@google.com> <20231024001636.890236-2-jmattson@google.com>
 <ZTcO8M3T9DGYrN2M@google.com>
Message-ID: <ZWjwV7rQ9i2NCf5A@google.com>
Subject: Re: [PATCH 2/2] KVM: x86: Use a switch statement in __feature_translate()
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	"'Paolo Bonzini '" <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Oct 23, 2023, Sean Christopherson wrote:
> On Mon, Oct 23, 2023, Jim Mattson wrote:
> > The compiler will probably do better than linear search.
> 
> It shouldn't matter, KVM relies on the compiler to resolve the translation at
> compile time, e.g. the result is fed into reverse_cpuid_check().
> 
> I.e. we should pick whatever is least ugly.

What if we add a macro to generate each case statement?  It's arguably a wee bit
more readable, and also eliminates the possibility of returning the wrong feature
due to copy+paste errors, e.g. nothing would break at compile time if we goofed
and did:

	case X86_FEATURE_SGX1:
		return KVM_X86_FEATURE_SGX1;
	case X86_FEATURE_SGX2:
		return KVM_X86_FEATURE_SGX1;

If you've no objection, I'll push this:

--
Author: Jim Mattson <jmattson@google.com>
Date:   Mon Oct 23 17:16:36 2023 -0700

    KVM: x86: Use a switch statement and macros in __feature_translate()
    
    Use a switch statement with macro-generated case statements to handle
    translating feature flags in order to reduce the probability of runtime
    errors due to copy+paste goofs, to make compile-time errors easier to
    debug, and to make the code more readable.
    
    E.g. the compiler won't directly generate an error for duplicate if
    statements
    
            if (x86_feature == X86_FEATURE_SGX1)
                    return KVM_X86_FEATURE_SGX1;
            else if (x86_feature == X86_FEATURE_SGX2)
                    return KVM_X86_FEATURE_SGX1;
    
    and so instead reverse_cpuid_check() will fail due to the untranslated
    entry pointing at a Linux-defined leaf, which provides practically no
    hint as to what is broken
    
      arch/x86/kvm/reverse_cpuid.h:108:2: error: call to __compiletime_assert_450 declared with 'error' attribute:
                                          BUILD_BUG_ON failed: x86_leaf == CPUID_LNX_4
              BUILD_BUG_ON(x86_leaf == CPUID_LNX_4);
              ^
    whereas duplicate case statements very explicitly point at the offending
    code:
    
      arch/x86/kvm/reverse_cpuid.h:125:2: error: duplicate case value '361'
              KVM_X86_TRANSLATE_FEATURE(SGX2);
              ^
      arch/x86/kvm/reverse_cpuid.h:124:2: error: duplicate case value '360'
              KVM_X86_TRANSLATE_FEATURE(SGX1);
              ^
    
    And without macros, the opposite type of copy+paste goof doesn't generate
    any error at compile-time, e.g. this yields no complaints:
    
            case X86_FEATURE_SGX1:
                    return KVM_X86_FEATURE_SGX1;
            case X86_FEATURE_SGX2:
                    return KVM_X86_FEATURE_SGX1;
    
    Note, __feature_translate() is forcibly inlined and the feature is known
    at compile-time, so the code generation between an if-elif sequence and a
    switch statement should be identical.
    
    Signed-off-by: Jim Mattson <jmattson@google.com>
    Link: https://lore.kernel.org/r/20231024001636.890236-2-jmattson@google.com
    [sean: use a macro, rewrite changelog]
    Signed-off-by: Sean Christopherson <seanjc@google.com>

diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
index 17007016d8b5..aadefcaa9561 100644
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -116,20 +116,19 @@ static __always_inline void reverse_cpuid_check(unsigned int x86_leaf)
  */
 static __always_inline u32 __feature_translate(int x86_feature)
 {
-       if (x86_feature == X86_FEATURE_SGX1)
-               return KVM_X86_FEATURE_SGX1;
-       else if (x86_feature == X86_FEATURE_SGX2)
-               return KVM_X86_FEATURE_SGX2;
-       else if (x86_feature == X86_FEATURE_SGX_EDECCSSA)
-               return KVM_X86_FEATURE_SGX_EDECCSSA;
-       else if (x86_feature == X86_FEATURE_CONSTANT_TSC)
-               return KVM_X86_FEATURE_CONSTANT_TSC;
-       else if (x86_feature == X86_FEATURE_PERFMON_V2)
-               return KVM_X86_FEATURE_PERFMON_V2;
-       else if (x86_feature == X86_FEATURE_RRSBA_CTRL)
-               return KVM_X86_FEATURE_RRSBA_CTRL;
+#define KVM_X86_TRANSLATE_FEATURE(f)   \
+       case X86_FEATURE_##f: return KVM_X86_FEATURE_##f
 
-       return x86_feature;
+       switch (x86_feature) {
+       KVM_X86_TRANSLATE_FEATURE(SGX1);
+       KVM_X86_TRANSLATE_FEATURE(SGX2);
+       KVM_X86_TRANSLATE_FEATURE(SGX_EDECCSSA);
+       KVM_X86_TRANSLATE_FEATURE(CONSTANT_TSC);
+       KVM_X86_TRANSLATE_FEATURE(PERFMON_V2);
+       KVM_X86_TRANSLATE_FEATURE(RRSBA_CTRL);
+       default:
+               return x86_feature;
+       }
 }
 
 static __always_inline u32 __feature_leaf(int x86_feature)


