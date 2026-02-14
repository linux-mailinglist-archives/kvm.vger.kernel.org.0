Return-Path: <kvm+bounces-71100-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uHu9DsHRkGltdAEAu9opvQ
	(envelope-from <kvm+bounces-71100-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 14 Feb 2026 20:49:21 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5510013D140
	for <lists+kvm@lfdr.de>; Sat, 14 Feb 2026 20:49:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 60140300515F
	for <lists+kvm@lfdr.de>; Sat, 14 Feb 2026 19:49:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08537308F2A;
	Sat, 14 Feb 2026 19:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="v+nF1ENU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vk1-f176.google.com (mail-vk1-f176.google.com [209.85.221.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5CFE2D5A19
	for <kvm@vger.kernel.org>; Sat, 14 Feb 2026 19:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771098555; cv=pass; b=E8Q5yzF+elH/ZH3HWjbweBu3bBe4Prs7IHnBXpXPSc4668/pW7dPl2Giq91PA0fT05y/zXKS2rQiKfiu9a6Cx1cjHmsXKsBXQ7rdq1CjjXOXcr97m3ksJQHmug65iPnsACo1m0De6FPebnie8b2LDMth1l2kA9EBbz+2INhKalw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771098555; c=relaxed/simple;
	bh=GC+jahyn08TEzaCyFw4EljLb34TFRdxXPLg0f+cKCG0=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uwIFaPqUZsjb13Tw03r2/6NYmjug0mRbBEX+lbcpELbrotyggZHQR+Tse9OaWRELScqRTMYxgCjC2DTli2XL21nV/PZi/FJNrK9gbCyS02CaXSNYVSqwI80OaQTM5Fo0h8CHdpHgQ2AParqtKGbAui9mffYOXQ7VROyEK+up6eY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=v+nF1ENU; arc=pass smtp.client-ip=209.85.221.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-vk1-f176.google.com with SMTP id 71dfb90a1353d-567543b8989so817266e0c.2
        for <kvm@vger.kernel.org>; Sat, 14 Feb 2026 11:49:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771098553; cv=none;
        d=google.com; s=arc-20240605;
        b=X5BJbfBcsmyMtLPxp/w58NoeUWZVAr5h8EwPYZZ63TO3Lk4RpJYIHCgy3zxe43KWhs
         8z8lx9+qZijx6ejSGCVZu3HskRNG6dOMkL3N7VctqXpEq49B3xprvfM7XejsecZKmio2
         FrgVs84uGj1o7TOpL2dzeCuXIpByOy0o1DW/V4NXOHaIynB+jbTCusLaFE7Phf2Br8W8
         gLAUbJTnVocXb/W7pSNIJ7vCF9b/NDWYaLAejp+3YNWbXhW+8bPZDdvooBBEvvVy98Py
         SSc+X9EDtyfmSq0c/iQHBCflYPii8WkJyFM9/AL4uNjDkTKDVa85k817yscl0A/wpkct
         cDZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=ZtvRpN/RyTbUwVvDF0717LJmDHhTx67+ZJt2k7G+yEQ=;
        fh=QuGRZV+lwkLB3Ja08qWMJmOBQhdHSed+R2+HERPlsPk=;
        b=CUfiPF5rO09YaLNFhwXxD2AEhMYdESPXahQfwBvVCQhjLTO6RjkCtRLxQPwvEnY79Y
         Kz5jEwRzavRF1JCy6lJDQw3y7nTMkKXinlZOfgQmTvwqS73zyLok64XN9EGW/pzyZFPk
         V1kXwUxm/KDjAkKl8fTqemK00FaTEe9oOhHUaSttv3dSRgr7QNYrLIaTt6WCqnxvfb0Z
         kO3blptrFmuSnjeKuTpRREXN7xPv5E87z/UMlEBKgnr55/Tk1vTLjYYClJ07LspP9fkw
         +cvCL9njN8ukYg9mpUsOoPy7/4YOAVkmG0z/7Ujl93C15M+ezQRXtN8SNAH98j2gxJZq
         Rasw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771098553; x=1771703353; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZtvRpN/RyTbUwVvDF0717LJmDHhTx67+ZJt2k7G+yEQ=;
        b=v+nF1ENUr21oPwBbnMwcXIhFYefKeTMhJR5EjCm1w3ircYOhwF3dMGDWR9JqHc1sAg
         YSSLd1Vh59Mcl5syECgCb8eJtD3k4h5qx+z65ix07/+ciARNcqOvAswEKGVAP31HoUSY
         vhyaG8DAGDWDE3PrKdHcQ6jm4AXEe23Vixzuv3eBxCOU0y0jOX1LmLTZb3c8yEU+9tkg
         yew9JK7XTeFJ65CpkoPt92hPal7tgfprKTCP7vN8VcVMJj2y0UfwBtQqGjTwnVF1bCli
         l3qyEE4Byo2zm8QYwJ10pCHEHT7OTcI0jia9IpcNJzrKlC79HNBpat1PgTLTrnS8n9iq
         CBlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771098553; x=1771703353;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZtvRpN/RyTbUwVvDF0717LJmDHhTx67+ZJt2k7G+yEQ=;
        b=tjh80rNVWS3iiUW5G4Qrwgd1ZgclptXSHrDKn+Q+EACzMgfaRChp+HRl8yjnFTCGIx
         9CSqn+SO+Yun8BkCa0C/BrNhJBoMEFZxvi4W+4n7QSmXI5tqDYGOY5+4ggtmQBNshhaJ
         TV5YHfOVhVBKvRj0FK8Jt6H6gWWGbnCclZtb5boToXAUv+pTmCqmtTyaVZhdL2HBqTWI
         87tSn8MU+lTlqkIVnv94mPDQl5AkzNFr9u1VaJG32sj6uVBZYR/ssH3EslEJ2UGa/v9B
         1Bl8oPp5dfLQr3xuz4uno8JIm5XMRM3YaabCOPDadTDsRtpvziw05nm7jJhLrt3orV1h
         62dg==
X-Gm-Message-State: AOJu0Ywn3n712RPVo4fHjHD8bhlPURpdWb+W1QxhP4c5LvHWRohinOUN
	uIByKGmKUxABMXhMO7Dnuyqd3z3ohKaDm9vUweduHVeiQtVbZ8fqi3sK/gVE8M+9jiHptcVf/CG
	3eJ0WDkbIe1Mr/yoIMoiESQMU2MIiRFqDgsfGhWKUhXnfgnpfNk33MDayyBTGYAfL
X-Gm-Gg: AZuq6aKxtD3qmtGjItbizL3CFWS65JrgIPiVGwr7qmru7RqECBsMGNZDj6DaGK2k3jO
	ZjllL+dlPFnHH6LKfK1jPb979IZHP9COGYAOemy4E6cO2mmRblQKZMPGCNwlLBGz2TqLGhX66CM
	uXwe++Kjocd3AglIcvOuNdvZKWgomdovsNWDsdKGS88LoSpppDYvG0xFK819vrm36aGcdhavHB0
	VNjj/saqCA/lI60d8JPlut5D4vPf8L2LcBaoeVy6voExcIVdz3uObuAp0csmVff9BN4cFeQYQsW
	9K5+6rMEFd8xx6pySAxkBnWBdJvohHKYnk72BFdyc1SRtD+3xSeL
X-Received: by 2002:a67:e997:0:b0:5f1:72a7:f879 with SMTP id
 ada2fe7eead31-5fe16ee32cbmr1706405137.28.1771098552104; Sat, 14 Feb 2026
 11:49:12 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Sat, 14 Feb 2026 11:49:10 -0800
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Sat, 14 Feb 2026 11:49:10 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <995398ca18fcb192444799a520cab5ea8e43df7b.1770071243.git.ackerleytng@google.com>
References: <cover.1770071243.git.ackerleytng@google.com> <995398ca18fcb192444799a520cab5ea8e43df7b.1770071243.git.ackerleytng@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Sat, 14 Feb 2026 11:49:10 -0800
X-Gm-Features: AaiRm51Rsn2OYZ_XKS4QmK9tZorCQvqfnTm3HcOw4Q6pQqac2ibQJ7lRc1m0N7c
Message-ID: <CAEvNRgHcxjkE8OPVxYqdCs+HvbaYqhNPW1mnocoKOoy5d6FoZQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 33/37] KVM: selftests: Make TEST_EXPECT_SIGBUS thread-safe
To: kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, x86@kernel.org
Cc: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	bp@alien8.de, brauner@kernel.org, chao.p.peng@intel.com, 
	chao.p.peng@linux.intel.com, chenhuacai@kernel.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, david@kernel.org, hpa@zytor.com, 
	ira.weiny@intel.com, jgg@nvidia.com, jmattson@google.com, jroedel@suse.de, 
	jthoughton@google.com, maobibo@loongson.cn, mathieu.desnoyers@efficios.com, 
	maz@kernel.org, mhiramat@kernel.org, michael.roth@amd.com, mingo@redhat.com, 
	mlevitsk@redhat.com, oupton@kernel.org, pankaj.gupta@amd.com, 
	pbonzini@redhat.com, prsampat@amd.com, qperret@google.com, 
	ricarkol@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
	rostedt@goodmis.org, seanjc@google.com, shivankg@amd.com, shuah@kernel.org, 
	steven.price@arm.com, tabba@google.com, tglx@linutronix.de, 
	vannapurve@google.com, vbabka@suse.cz, willy@infradead.org, wyihan@google.com, 
	yan.y.zhao@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_GT_50(0.00)[50];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ackerleytng@google.com,kvm@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns];
	TAGGED_FROM(0.00)[bounces-71100-lists,kvm=lfdr.de];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DKIM_TRACE(0.00)[google.com:+]
X-Rspamd-Queue-Id: 5510013D140
X-Rspamd-Action: no action

Ackerley Tng <ackerleytng@google.com> writes:

> The TEST_EXPECT_SIGBUS macro is not thread-safe as it uses a global
> sigjmp_buf and installs a global SIGBUS signal handler. If multiple threads
> execute the macro concurrently, they will race on installing the signal
> handler and stomp on other threads' jump buffers, leading to incorrect test
> behavior.
>
> Make TEST_EXPECT_SIGBUS thread-safe with the following changes:
>
> Share the KVM tests' global signal handler. sigaction() applies to all
> threads; without sharing a global signal handler, one thread may have
> removed the signal handler that another thread added, hence leading to
> unexpected signals.
>
> The alternative of layering signal handlers was considered, but calling
> sigaction() within TEST_EXPECT_SIGBUS() necessarily creates a race. To
> avoid adding new setup and teardown routines to do sigaction() and keep
> usage of TEST_EXPECT_SIGBUS() simple, share the KVM tests' global signal
> handler.
>
> Opportunistically rename report_unexpected_signal to
> catchall_signal_handler.
>
> To continue to only expect SIGBUS within specific regions of code, use a
> thread-specific variable, expecting_sigbus, to replace installing and
> removing signal handlers.
>
> Make the execution environment for the thread, sigjmp_buf, a
> thread-specific variable.
>
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>
> ---
>  .../testing/selftests/kvm/include/test_util.h | 29 +++++++++----------
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 18 ++++++++----
>  tools/testing/selftests/kvm/lib/test_util.c   |  7 -----
>  3 files changed, 26 insertions(+), 28 deletions(-)
>
> diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testing/selftests/kvm/include/test_util.h
> index 2871a4292847..0e4e6f7dab8f 100644
> --- a/tools/testing/selftests/kvm/include/test_util.h
> +++ b/tools/testing/selftests/kvm/include/test_util.h
> @@ -80,22 +80,19 @@ do {									\
>  	__builtin_unreachable(); \
>  } while (0)
>
> -extern sigjmp_buf expect_sigbus_jmpbuf;
> -void expect_sigbus_handler(int signum);
> -
> -#define TEST_EXPECT_SIGBUS(action)						\
> -do {										\
> -	struct sigaction sa_old, sa_new = {					\
> -		.sa_handler = expect_sigbus_handler,				\
> -	};									\
> -										\
> -	sigaction(SIGBUS, &sa_new, &sa_old);					\
> -	if (sigsetjmp(expect_sigbus_jmpbuf, 1) == 0) {				\
> -		action;								\
> -		TEST_FAIL("'%s' should have triggered SIGBUS", #action);	\
> -	}									\
> -	sigaction(SIGBUS, &sa_old, NULL);					\
> -} while (0)
> +extern __thread sigjmp_buf expect_sigbus_jmpbuf;
> +extern __thread bool expecting_sigbus;
> +
> +#define TEST_EXPECT_SIGBUS(action)                                     \
> +	do {                                                           \
> +		expecting_sigbus = true;			       \
> +		if (sigsetjmp(expect_sigbus_jmpbuf, 1) == 0) {         \
> +			action;                                        \
> +			TEST_FAIL("'%s' should have triggered SIGBUS", \
> +				  #action);                            \
> +		}                                                      \
> +		expecting_sigbus = false;			       \
> +	} while (0)
>
>  size_t parse_size(const char *size);
>
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index aec7b24418ab..18ced8bdde36 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -2314,13 +2314,20 @@ __weak void kvm_selftest_arch_init(void)
>  {
>  }
>
> -static void report_unexpected_signal(int signum)
> +__thread sigjmp_buf expect_sigbus_jmpbuf;
> +__thread bool expecting_sigbus;
> +
> +static void catchall_signal_handler(int signum)
>  {
> +	switch (signum) {
> +	case SIGBUS: {
> +		if (expecting_sigbus)


Transferring/summarizing an internal comment from Sean upstream:

This assumes that tests are indeed using the catchall_signal_handler as
the global signal handler.

In the next revision, I will make TEST_EXPECT_SIGBUS() assert that the
default signal handler is installed, so that developers get a clear,
explicit failure if/when something goes wrong.

> +			siglongjmp(expect_sigbus_jmpbuf, 1);
> +
> +		TEST_FAIL("Unexpected SIGBUS (%d)\n", signum);
> +	}
>  #define KVM_CASE_SIGNUM(sig)					\
>  	case sig: TEST_FAIL("Unexpected " #sig " (%d)\n", signum)
> -
> -	switch (signum) {
> -	KVM_CASE_SIGNUM(SIGBUS);
>  	KVM_CASE_SIGNUM(SIGSEGV);
>  	KVM_CASE_SIGNUM(SIGILL);
>  	KVM_CASE_SIGNUM(SIGFPE);
> @@ -2332,12 +2339,13 @@ static void report_unexpected_signal(int signum)
>  void __attribute((constructor)) kvm_selftest_init(void)
>  {
>  	struct sigaction sig_sa = {
> -		.sa_handler = report_unexpected_signal,
> +		.sa_handler = catchall_signal_handler,
>  	};
>
>  	/* Tell stdout not to buffer its content. */
>  	setbuf(stdout, NULL);
>
> +	expecting_sigbus = false;
>  	sigaction(SIGBUS, &sig_sa, NULL);
>  	sigaction(SIGSEGV, &sig_sa, NULL);
>  	sigaction(SIGILL, &sig_sa, NULL);
> diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/selftests/kvm/lib/test_util.c
> index 8a1848586a85..03eb99af9b8d 100644
> --- a/tools/testing/selftests/kvm/lib/test_util.c
> +++ b/tools/testing/selftests/kvm/lib/test_util.c
> @@ -18,13 +18,6 @@
>
>  #include "test_util.h"
>
> -sigjmp_buf expect_sigbus_jmpbuf;
> -
> -void __attribute__((used)) expect_sigbus_handler(int signum)
> -{
> -	siglongjmp(expect_sigbus_jmpbuf, 1);
> -}
> -
>  /*
>   * Random number generator that is usable from guest code. This is the
>   * Park-Miller LCG using standard constants.
> --
> 2.53.0.rc1.225.gd81095ad13-goog

