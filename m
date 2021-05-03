Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC33371448
	for <lists+kvm@lfdr.de>; Mon,  3 May 2021 13:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233236AbhECLc3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 May 2021 07:32:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41962 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232918AbhECLc2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 3 May 2021 07:32:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620041494;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=L/bcf0nuZPJ9+05d3REB9K2mhzG8oDqknK3QX5CLyLU=;
        b=Y5Jfvk20EpHZOoWdJHnHpeY8XODJ0bEMgHQu1miYm20MNXRb7GlupmNQ35BEz942oFphPb
        tKpdsvfPVVSSGEdshe6mFAWZLjUb8TJaEwiwoYmqJTW3oT6lrIuUhuxG25JazYro9+TECg
        Eqv0sKZdHRgbHcrc5/ohKrxa8a8I/Bs=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-477-mgUTJXYPOMGlT1NFJfCW8A-1; Mon, 03 May 2021 07:31:33 -0400
X-MC-Unique: mgUTJXYPOMGlT1NFJfCW8A-1
Received: by mail-wm1-f72.google.com with SMTP id y184-20020a1ce1c10000b0290143299f39d7so2362540wmg.4
        for <kvm@vger.kernel.org>; Mon, 03 May 2021 04:31:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=L/bcf0nuZPJ9+05d3REB9K2mhzG8oDqknK3QX5CLyLU=;
        b=flfxmTLCla+cjLDLwoofzeacfXFHSnFQxg/R90ikOS4ip469N3cEO7AyiKWLEhrxJi
         YbSNEoZQpdWQ6hWV1Oh2IzrOQt4Xoe+gV7AHUv9dulAnPQ5ALElN+0PsqGsXEHAhMTlA
         6i+ALFy/bYBQEoPVQ0TYzQ8Cenlkuph7rLRiVc1ExjvS1kZj1ngzQtkvu8uLdOeGSN0X
         s7/9jBgkYhozdQ2lX9+L5BAHqM6UkGkLugAgUjAWZ+gh+nYBbaEHsfXmihGLcvWq863J
         4NuEY1M3WaOJ+vaQ3U6ElbwwH+xQ5tBqoQ0IZqWyDQkM2BodaSRQlhUjbf3gwfPjSw37
         vVHg==
X-Gm-Message-State: AOAM5321ydCVLh0aSYoGpuyO7gB9lLohLiQA0r7yzE7yDr27Gpy81PBT
        +pKAHZWtU82Jn7nCATz//S2kV3ftnh7HNiMn5XPAE6vzv7NBqvmsO0sfNrw+iINOABqE3msFVap
        ZUiBcovbaQYx1
X-Received: by 2002:a05:600c:218d:: with SMTP id e13mr26761503wme.151.1620041492246;
        Mon, 03 May 2021 04:31:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy7aCxatzlutQaKTphpsuYgj38aq/ELD4z7gf0Zn/7jxG8jPXaE2yqDpFGW0ExSwWKOEqP1Ng==
X-Received: by 2002:a05:600c:218d:: with SMTP id e13mr26761491wme.151.1620041492085;
        Mon, 03 May 2021 04:31:32 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id v20sm11411827wmj.15.2021.05.03.04.31.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 May 2021 04:31:31 -0700 (PDT)
Date:   Mon, 3 May 2021 13:31:29 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com
Subject: Re: [PATCH v2 3/5] KVM: selftests: Move GUEST_ASSERT_EQ to utils
 header
Message-ID: <20210503113129.hoqjuklct3yoooii@gator.home>
References: <20210430232408.2707420-1-ricarkol@google.com>
 <20210430232408.2707420-4-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210430232408.2707420-4-ricarkol@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 30, 2021 at 04:24:05PM -0700, Ricardo Koller wrote:
> Move GUEST_ASSERT_EQ to a common header, kvm_util.h, for other
> architectures and tests to use.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
> ---
>  tools/testing/selftests/kvm/include/kvm_util.h     | 9 +++++++++
>  tools/testing/selftests/kvm/x86_64/tsc_msrs_test.c | 9 ---------
>  2 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index 7880929ea548..bd26dd93ab56 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -388,4 +388,13 @@ uint64_t get_ucall(struct kvm_vm *vm, uint32_t vcpu_id, struct ucall *uc);
>  #define GUEST_ASSERT_4(_condition, arg1, arg2, arg3, arg4) \
>  	__GUEST_ASSERT((_condition), 4, (arg1), (arg2), (arg3), (arg4))
>  
> +#define GUEST_ASSERT_EQ(a, b) do {				\
> +	__typeof(a) _a = (a);					\
> +	__typeof(b) _b = (b);					\
> +	if (_a != _b)						\
> +		ucall(UCALL_ABORT, 4,				\
> +			"Failed guest assert: "			\
> +			#a " == " #b, __LINE__, _a, _b);	\
> +} while(0)
> +
>  #endif /* SELFTEST_KVM_UTIL_H */
> diff --git a/tools/testing/selftests/kvm/x86_64/tsc_msrs_test.c b/tools/testing/selftests/kvm/x86_64/tsc_msrs_test.c
> index e357d8e222d4..5a6a662f2e59 100644
> --- a/tools/testing/selftests/kvm/x86_64/tsc_msrs_test.c
> +++ b/tools/testing/selftests/kvm/x86_64/tsc_msrs_test.c
> @@ -18,15 +18,6 @@
>  #define rounded_rdmsr(x)       ROUND(rdmsr(x))
>  #define rounded_host_rdmsr(x)  ROUND(vcpu_get_msr(vm, 0, x))
>  
> -#define GUEST_ASSERT_EQ(a, b) do {				\
> -	__typeof(a) _a = (a);					\
> -	__typeof(b) _b = (b);					\
> -	if (_a != _b)						\
> -                ucall(UCALL_ABORT, 4,				\
> -                        "Failed guest assert: "			\
> -                        #a " == " #b, __LINE__, _a, _b);	\
> -  } while(0)
> -
>  static void guest_code(void)
>  {
>  	u64 val = 0;
> -- 
> 2.31.1.527.g47e6f16901-goog
>

How about modify __GUEST_ASSERT so we can reuse it instead, like below?
(I also took the opportunity to remove the unnecessary () within the comma
separated statements.)

Thanks,
drew


-#define __GUEST_ASSERT(_condition, _nargs, _args...) do {      \
-       if (!(_condition))                                      \
-               ucall(UCALL_ABORT, 2 + _nargs,                  \
-                       "Failed guest assert: "                 \
-                       #_condition, __LINE__, _args);          \
+#define __GUEST_ASSERT(_condition, _condstr, _nargs, _args...) do {    \
+       if (!(_condition))                                              \
+               ucall(UCALL_ABORT, 2 + _nargs,                          \
+                       "Failed guest assert: "                         \
+                       _condstr, __LINE__, _args);                     \
 } while (0)
 
 #define GUEST_ASSERT(_condition) \
-       __GUEST_ASSERT((_condition), 0, 0)
+       __GUEST_ASSERT(_condition, #_condition, 0, 0)
 
 #define GUEST_ASSERT_1(_condition, arg1) \
-       __GUEST_ASSERT((_condition), 1, (arg1))
+       __GUEST_ASSERT(_condition, #_condition, 1, arg1)
 
 #define GUEST_ASSERT_2(_condition, arg1, arg2) \
-       __GUEST_ASSERT((_condition), 2, (arg1), (arg2))
+       __GUEST_ASSERT(_condition, #_condition, 2, arg1, arg2)
 
 #define GUEST_ASSERT_3(_condition, arg1, arg2, arg3) \
-       __GUEST_ASSERT((_condition), 3, (arg1), (arg2), (arg3))
+       __GUEST_ASSERT(_condition, #_condition, 3, arg1, arg2, arg3)
 
 #define GUEST_ASSERT_4(_condition, arg1, arg2, arg3, arg4) \
-       __GUEST_ASSERT((_condition), 4, (arg1), (arg2), (arg3), (arg4))
-
-#define GUEST_ASSERT_EQ(a, b) do {                             \
-       __typeof(a) _a = (a);                                   \
-       __typeof(b) _b = (b);                                   \
-       if (_a != _b)                                           \
-               ucall(UCALL_ABORT, 4,                           \
-                       "Failed guest assert: "                 \
-                       #a " == " #b, __LINE__, _a, _b);        \
-} while(0)
+       __GUEST_ASSERT(_condition, #_condition, 4, arg1, arg2, arg3, arg4)
+
+#define GUEST_ASSERT_EQ(a, b) __GUEST_ASSERT((a) == (b), #a " == " #b, 2, a, b)

