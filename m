Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19D6221858F
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 13:07:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728701AbgGHLHj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 07:07:39 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:43479 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728466AbgGHLHi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jul 2020 07:07:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594206456;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2Mg3KTgGZpPeTKVRCYhvE/CZ0kHGinEb1CFfAmtiXJg=;
        b=RW5sSojtiOS7LdyIBC2Ma7bKaoPE9zkvFoow9FaiYlwIJlhViA9ds5+zzpdXtti+TgFTW3
        eD4U35kXml8zqy8cSo3jkaxiSzF8FSGfO96zWptplb+XCcTPUH4ERxzWJf8Zj1vJH1JlnP
        hxZ/cng/JBDxJSLDSZ0hoZpQXRXyQgw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-41-FDnpXfXfNuOU66Yh89bfcA-1; Wed, 08 Jul 2020 07:07:34 -0400
X-MC-Unique: FDnpXfXfNuOU66Yh89bfcA-1
Received: by mail-wm1-f69.google.com with SMTP id u68so2528927wmu.3
        for <kvm@vger.kernel.org>; Wed, 08 Jul 2020 04:07:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2Mg3KTgGZpPeTKVRCYhvE/CZ0kHGinEb1CFfAmtiXJg=;
        b=cEkWwns3dkAse5mVEOtqMRx5Eu9JIjZj2L8TVzt48YWblHqCEJqGLKQI4f4hSu9Uw5
         1xcIScr5HJxbIgjMCwmGI3ejHTJDXV6RZwm3NJYMAqL88VbFWzHZWP9VKTRCrcdQdSL0
         JMLwvj9qmQWzNL+xKyBMnPU6A2hZHdb65SUez0vAbTz2zJYFqvCz6eXw+QQT6s0eaiIK
         O0JjseMWrCqEU9mMsokntYKEERyQQTF9Kv87Ts3jRyBtXqwpKrrmGHsxHcfs7nJ0gfzJ
         4Lnuk3nmYTuxr1yUSZ0obrmSAMRvWWnnTdZRntioZnCJ8rNLH+0lvHMGYxAih/bygaZs
         zibw==
X-Gm-Message-State: AOAM533vqv68rRYoXqFMlhmEtTukHWZXxwFQ2SqOStk1TwbroVa81qvv
        CIaNq6KzPYzrw0cnfe26J3gvq4mYlUN/V3pHKvHXMjH23ZhJO0/UqzdmQ0QjV+U31/efIspRSSe
        hPWsw4B3DFkms
X-Received: by 2002:adf:f18c:: with SMTP id h12mr55696168wro.375.1594206452692;
        Wed, 08 Jul 2020 04:07:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxG5Ha4c5FoQwSb/+ltd5k490NxlwoBf9wfjBJlSwA+vOdli+TkugcGdsbVS/nQRXy+o4iKiA==
X-Received: by 2002:adf:f18c:: with SMTP id h12mr55696142wro.375.1594206452385;
        Wed, 08 Jul 2020 04:07:32 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9541:9439:cb0f:89c? ([2001:b07:6468:f312:9541:9439:cb0f:89c])
        by smtp.gmail.com with ESMTPSA id p17sm5068618wma.47.2020.07.08.04.07.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 04:07:31 -0700 (PDT)
Subject: Re: [PATCH 3/3 v4] kvm-unit-tests: nSVM: Test that MBZ bits in CR3
 and CR4 are not set on vmrun of nested guests
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org
References: <1594168797-29444-1-git-send-email-krish.sadhukhan@oracle.com>
 <1594168797-29444-4-git-send-email-krish.sadhukhan@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <80ff1de6-f8db-5a09-b67f-ee81937d0dc6@redhat.com>
Date:   Wed, 8 Jul 2020 13:07:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <1594168797-29444-4-git-send-email-krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/07/20 02:39, Krish Sadhukhan wrote:
> +	SVM_TEST_CR_RESERVED_BITS(0, 2, 1, 3, cr3_saved,
> +	    SVM_CR3_LEGACY_PAE_RESERVED_MASK);
> +
> +	cr4 = cr4_saved & ~X86_CR4_PAE;
> +	vmcb->save.cr4 = cr4;
> +	SVM_TEST_CR_RESERVED_BITS(0, 11, 2, 3, cr3_saved,
> +	    SVM_CR3_LEGACY_RESERVED_MASK);
> +
> +	cr4 |= X86_CR4_PAE;
> +	vmcb->save.cr4 = cr4;
> +	efer |= EFER_LMA;
> +	vmcb->save.efer = efer;
> +	SVM_TEST_CR_RESERVED_BITS(0, 63, 2, 3, cr3_saved,
> +	    SVM_CR3_LONG_RESERVED_MASK);

The test is not covering *non*-reserved bits, so it doesn't catch that 
in both cases KVM is checking against long-mode bits.  Doing this would 
require setting up the VMCB for immediate VMEXIT (for example, injecting 
an event while the IDT limit is zero), so it can be done later.

Instead, you need to set/clear EFER_LME.  Please be more careful to 
check that the test is covering what you expect.

Also, the tests show

PASS: Test CR3 2:0: 641001
PASS: Test CR3 2:0: 2
PASS: Test CR3 2:0: 4
PASS: Test CR3 11:0: 1
PASS: Test CR3 11:0: 4
PASS: Test CR3 11:0: 40
PASS: Test CR3 11:0: 100
PASS: Test CR3 11:0: 400
PASS: Test CR3 63:0: 1
PASS: Test CR3 63:0: 4
PASS: Test CR3 63:0: 40
PASS: Test CR3 63:0: 100
PASS: Test CR3 63:0: 400
PASS: Test CR3 63:0: 10000000000000
PASS: Test CR3 63:0: 40000000000000
PASS: Test CR3 63:0: 100000000000000
PASS: Test CR3 63:0: 400000000000000
PASS: Test CR3 63:0: 1000000000000000
PASS: Test CR3 63:0: 4000000000000000
PASS: Test CR4 31:12: 0
PASS: Test CR4 31:12: 0

and then exits.  There is an issue with compiler optimization for which 
I've sent a patch, but even after fixing it the premature exit is a 
problem: it is caused by a problem in __cr4_reserved_bits and a typo in 
the tests:

diff --git a/x86/svm.h b/x86/svm.h
index f6b9a31..58c9069 100644
--- a/x86/svm.h
+++ b/x86/svm.h
@@ -328,8 +328,8 @@ struct __attribute__ ((__packed__)) vmcb {
 #define	SVM_CR3_LEGACY_RESERVED_MASK		0xfe7U
 #define	SVM_CR3_LEGACY_PAE_RESERVED_MASK	0x7U
 #define	SVM_CR3_LONG_RESERVED_MASK		0xfff0000000000fe7U
-#define	SVM_CR4_LEGACY_RESERVED_MASK		0xffbaf000U
-#define	SVM_CR4_RESERVED_MASK			0xffffffffffbaf000U
+#define	SVM_CR4_LEGACY_RESERVED_MASK		0xffcaf000U
+#define	SVM_CR4_RESERVED_MASK			0xffffffffffcaf000U
 #define	SVM_DR6_RESERVED_MASK			0xffffffffffff1ff0U
 #define	SVM_DR7_RESERVED_MASK			0xffffffff0000cc00U
 #define	SVM_EFER_RESERVED_MASK			0xffffffffffff0200U

(Also, this kind of problem is made harder to notice by only testing
even bits, which may make sense for high order bits, but certainly not
for low-order ones).

All in all, fixing this series has taken me almost 2 hours.  Since I have
done the work I'm queuing but, but I wonder: the compiler optimization
issue could depend on register allocation, but did all of these issues
really happen only on my machine?

Paolo

