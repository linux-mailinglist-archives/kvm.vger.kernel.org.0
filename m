Return-Path: <kvm+bounces-69442-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wI4EOVegemmn8gEAu9opvQ
	(envelope-from <kvm+bounces-69442-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 00:48:39 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AE6AAA07D
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 00:48:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9419D3022954
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 23:48:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5CD7344DAD;
	Wed, 28 Jan 2026 23:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wggXsJph"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D3F533B6E0
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 23:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769644095; cv=pass; b=hQRQ91a9i+4xtqsh2EwOX5/JFBmNP0doWftKHJAEEm3W6Of2Me3gepjN7qf3ZcPo8XXxJpH7Ly8s2IZOpTjgPc4MHX5sXy9tKO1uaP+adibETwVHegGfOrwWNLLtNj7O6oP1n9i/lf3LaY0U4VHd7C75w9HxdCzJPWJWMIAwMIs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769644095; c=relaxed/simple;
	bh=QKP+AdSSsiB4D0SD1pkOBdxVF5JubvIxOCIWfnhFTQg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=seXekQmVj08EomoyIdIgp059460k9d/Fkdx1JWYMxB4zW2ebkRjSzbD424VLjnBpxhtJ/dP2vPr4Cvb/3dqoPvkS208sVn7k7+PL+7UsysdmXqCzpvh4rfQb7S8ESOumbi1ZUNwPI9H31t+HI9yTGkH+evFy9nZ0ZaugasUz748=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wggXsJph; arc=pass smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-5033b0b6eabso98741cf.1
        for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 15:48:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769644092; cv=none;
        d=google.com; s=arc-20240605;
        b=NW2QiD3MqrUnKwqjX4+vnH1PgVcojKyyurgvz2p0b4VFPVKDCGJK8qtz6hH5gJbnXe
         owDRWD8faAIVFVxKuod6GcmGtdTwY5mNlRrMlk+rHDgSzZaKzTlrfHf3gn4GxNVr8m0M
         LKDbUgIdwUdlPfJTokYSVC1i+4P5xzznpcAXBdM/FKV7zVngMF0kH3Gx+3dJCWn+k1W2
         IFZbSemBILM8FvghOo0EybBPgsxhm1NPih89697RF7ILvvsoia5VIGo99x3ADJ/D+JES
         bzwrQNgcgmp/D4ECo/QdHsJqJ7/Pd/PqC29DEK019caoA/Ud0Axhd0GYFQA7c3Mco1jT
         TIOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wjvvUYK/4dE39UgAFnedAHeaRm7dJ/+QUmhTTPYz9t4=;
        fh=k889PupdFjRJS3dwfb1q62s5tWO/mlM9wPecpHJLL/4=;
        b=GzWjj5wbrMqVvriJWrkKuP9/R5NjirhhnXu589pRaOkY/Zbml6mE5coNW2XRxSW3eE
         hpMFgGb5YEECedR8fV1YzZ8KXLImtKEpsCBvePv1jtCPmIaayaW88aVHMnlL7rVIRfZc
         uVbs/ocueLhCrHD7m1xA6e5jE8DjxzoNkBYf4+Oc5LIFaHbytIeSJJ79jph8CxhfwSMa
         eqswXSIWOr0o6fd+9psOTdpD+Plat+yVuoujZyuI96LxngC3rhyeEBlQmGmYjDh8MBdk
         NbJyvA60VwHXHW7qKIwM72X11MwMzrPlJNPW5znEH8GvfI8pEoXkzNFRDACv8l4oTI50
         TJDA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769644092; x=1770248892; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wjvvUYK/4dE39UgAFnedAHeaRm7dJ/+QUmhTTPYz9t4=;
        b=wggXsJphagb/bSpj3IRsUGTXWgTMrE6SFYOybk+9pnBhkLoCWdphWLqnQ0gniyantv
         m5TcrWoMvcp2am9alIjwnJT1XPZxf9trslYOW3hjy1UaPny1Hopfj5KRVxBdv4U/GkAk
         g+W/y2p5UHxvjSIN5/ibYGkdYkqlWzPv29KYla/Feqv2d4NIr3bBeUP5lz8he+Jfet9t
         747JXMN9vXd4kLoSWRCPyClmkc1m5QPt4cwuk2ANgV1wS6ZiZEGJO0iUMP4WGjnHe05+
         VZcaETw8dNRDx1h0li/Wbl7oGD+6njjDBVMUH/yo2Nc/1isQ9lgVliEo2F7NJi8M4qSP
         X0Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769644092; x=1770248892;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wjvvUYK/4dE39UgAFnedAHeaRm7dJ/+QUmhTTPYz9t4=;
        b=HWBeJDSvk4lXTtKEH+XQsTikrSXRwbpXYNHASd7gLWpahHov+hKV40iI4BJSC9Fvpr
         qwlOEMGe4m61eS5Q+1N5I3cITcBaTfWq1+b9WhGp0KmVb0VSMOKvPHb01od/YsUrG2am
         AnwQMYDhxYsymQ5NuFbD9EfBsr+fF44yJqkDsBHmahrL1ywRotfYAIt7XpmK00fWE29r
         C/MjGQNyKdkdw44nI69JM3Q0ne0Wlo0PB1uNzYRNHH+Mx4VZMQfCaRz+w10NDVMv2yy6
         qieR/3jBbZhn91kTeV33h5e/K0vQBL2LiJ4wrzr4wQ2rI+1F2EqiqYJkx328epjzfiNm
         8Bww==
X-Forwarded-Encrypted: i=1; AJvYcCVKOnPmF3Yjqpbz6Prd9B/SUA7yF3Nr5g/yfltwrfgQHx3Fej1iXvg1YLlTAzpcfA1+6Og=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyk2NdJWd2FV2qL3Xi1rD+WKQ7z0DJF1eT2JT3J4bIh7bgSfh39
	mTjdqzzIz0EPpInxSExDgztaTlTiTPvTX7/bTy9c9XaNkVe7ZVxXHSQApSADTmu/yG0gUW4W3oX
	8H6qFMie/czm+AnZh3T2Cgxr5mWhuAq7mcw5J1J0B
X-Gm-Gg: AZuq6aL9l2MUwBP/xukRA76LTh0gMiUTF4AxwkGfWeQbMRZIIlrRU+LkQ6MVbpUiqim
	V12F3vi+AaUhux5VtpywJPlLm0tWBJgUmN9GsRlPQu0XU7KBTtaZAnvRnsqmZWcw5AFDM9ITk3w
	L4FYoq3Mn6cTeSeZXbnlNF9H5q03I7n004B1Q2Jnnoyv0DW/2+YCREqj774+Z7W0fN7uiCtV4Yn
	ZMjUrycKMpQTRbNDrVqyUk1tRH2fmZPbWXwk+I4QKCu/oJBhYdcC8Yd7HtkoHCvVZ9582TiPqIw
	n5O6Rg==
X-Received: by 2002:ac8:59cd:0:b0:4ed:ff79:e678 with SMTP id
 d75a77b69052e-503b672c559mr4281001cf.18.1769644091830; Wed, 28 Jan 2026
 15:48:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260121225438.3908422-1-jmattson@google.com> <20260121225438.3908422-7-jmattson@google.com>
 <aXJal3srw2-3J5Dm@google.com>
In-Reply-To: <aXJal3srw2-3J5Dm@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Wed, 28 Jan 2026 15:47:59 -0800
X-Gm-Features: AZwV_Qi8faW06eVjZbFN4XkaAx91ISh9qtySVVj5Bkz3ATD0YuSAA9PlyfyxKGM
Message-ID: <CALMp9eQm2fW=jbcBSZK9hO9p_Lec67B4gFsio2BBcsJfP1jtRg@mail.gmail.com>
Subject: Re: [PATCH 6/6] KVM: selftests: x86: Add svm_pmu_hg_test for HG_ONLY bits
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	James Clark <james.clark@linaro.org>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69442-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[22];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 4AE6AAA07D
X-Rspamd-Action: no action

On Thu, Jan 22, 2026 at 9:12=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Wed, Jan 21, 2026, Jim Mattson wrote:
> > Add a selftest to verify KVM correctly virtualizes the AMD PMU Host-Onl=
y
> > (bit 41) and Guest-Only (bit 40) event selector bits across all relevan=
t
> > SVM state transitions.
> >
> > For both Guest-Only and Host-Only counters, verify that:
> >   1. SVME=3D0: counter counts (HG_ONLY bits ignored)
> >   2. Set SVME=3D1: counter behavior changes based on HG_ONLY bit
> >   3. VMRUN to L2: counter behavior switches (guest vs host mode)
> >   4. VMEXIT to L1: counter behavior switches back
> >   5. Clear SVME=3D0: counter counts (HG_ONLY bits ignored again)
> >
> > Also confirm that setting both bits is the same as setting neither bit.
> >
> > Signed-off-by: Jim Mattson <jmattson@google.com>
> > ---
> >  tools/testing/selftests/kvm/Makefile.kvm      |   1 +
> >  .../selftests/kvm/x86/svm_pmu_hg_test.c       | 297 ++++++++++++++++++
> >  2 files changed, 298 insertions(+)
> >  create mode 100644 tools/testing/selftests/kvm/x86/svm_pmu_hg_test.c
> >
> > diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/s=
elftests/kvm/Makefile.kvm
> > index e88699e227dd..06ba85d97618 100644
> > --- a/tools/testing/selftests/kvm/Makefile.kvm
> > +++ b/tools/testing/selftests/kvm/Makefile.kvm
> > @@ -112,6 +112,7 @@ TEST_GEN_PROGS_x86 +=3D x86/svm_vmcall_test
> >  TEST_GEN_PROGS_x86 +=3D x86/svm_int_ctl_test
> >  TEST_GEN_PROGS_x86 +=3D x86/svm_nested_shutdown_test
> >  TEST_GEN_PROGS_x86 +=3D x86/svm_nested_soft_inject_test
> > +TEST_GEN_PROGS_x86 +=3D x86/svm_pmu_hg_test
>
> Maybe svm_nested_pmu_test?  Hmm, that makes it sound like "nested PMU" th=
ough.
>
> svm_pmu_host_guest_test?

Sounds good.

> > +#define MSR_F15H_PERF_CTL0   0xc0010200
> > +#define MSR_F15H_PERF_CTR0   0xc0010201
> > +
> > +#define AMD64_EVENTSEL_GUESTONLY     BIT_ULL(40)
> > +#define AMD64_EVENTSEL_HOSTONLY              BIT_ULL(41)
>
> Please put architectural definitions in pmu.h (or whatever library header=
 we
> have).

These should be redundant. I will confirm.

> > +struct hg_test_data {
>
> Please drop "hg" (I keep reading it as "mercury").
>
> > +     uint64_t l2_delta;
> > +     bool l2_done;
> > +};
> > +
> > +static struct hg_test_data *hg_data;
> > +
> > +static void l2_guest_code(void)
> > +{
> > +     hg_data->l2_delta =3D run_and_measure();
> > +     hg_data->l2_done =3D true;
> > +     vmmcall();
> > +}
> > +
> > +/*
> > + * Test Guest-Only counter across all relevant state transitions.
> > + */
> > +static void l1_guest_code_guestonly(struct svm_test_data *svm,
> > +                                 struct hg_test_data *data)
> > +{
> > +     unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
> > +     struct vmcb *vmcb =3D svm->vmcb;
> > +     uint64_t eventsel, delta;
> > +
> > +     hg_data =3D data;
> > +
> > +     eventsel =3D EVENTSEL_RETIRED_INSNS | AMD64_EVENTSEL_GUESTONLY;
> > +     wrmsr(MSR_F15H_PERF_CTL0, eventsel);
> > +     wrmsr(MSR_F15H_PERF_CTR0, 0);
> > +
> > +     /* Step 1: SVME=3D0; HG_ONLY ignored */
> > +     wrmsr(MSR_EFER, rdmsr(MSR_EFER) & ~EFER_SVME);
> > +     delta =3D run_and_measure();
> > +     GUEST_ASSERT_NE(delta, 0);
> > +
> > +     /* Step 2: Set SVME=3D1; Guest-Only counter stops */
> > +     wrmsr(MSR_EFER, rdmsr(MSR_EFER) | EFER_SVME);
> > +     delta =3D run_and_measure();
> > +     GUEST_ASSERT_EQ(delta, 0);
> > +
> > +     /* Step 3: VMRUN to L2; Guest-Only counter counts */
> > +     generic_svm_setup(svm, l2_guest_code,
> > +                       &l2_guest_stack[L2_GUEST_STACK_SIZE]);
> > +     vmcb->control.intercept &=3D ~(1ULL << INTERCEPT_MSR_PROT);
> > +
> > +     run_guest(vmcb, svm->vmcb_gpa);
> > +
> > +     GUEST_ASSERT_EQ(vmcb->control.exit_code, SVM_EXIT_VMMCALL);
> > +     GUEST_ASSERT(data->l2_done);
> > +     GUEST_ASSERT_NE(data->l2_delta, 0);
> > +
> > +     /* Step 4: After VMEXIT to L1; Guest-Only counter stops */
> > +     delta =3D run_and_measure();
> > +     GUEST_ASSERT_EQ(delta, 0);
> > +
> > +     /* Step 5: Clear SVME; HG_ONLY ignored */
> > +     wrmsr(MSR_EFER, rdmsr(MSR_EFER) & ~EFER_SVME);
> > +     delta =3D run_and_measure();
> > +     GUEST_ASSERT_NE(delta, 0);
> > +
> > +     GUEST_DONE();
> > +}
> > +
> > +/*
> > + * Test Host-Only counter across all relevant state transitions.
> > + */
> > +static void l1_guest_code_hostonly(struct svm_test_data *svm,
> > +                                struct hg_test_data *data)
> > +{
> > +     unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
> > +     struct vmcb *vmcb =3D svm->vmcb;
> > +     uint64_t eventsel, delta;
> > +
> > +     hg_data =3D data;
> > +
> > +     eventsel =3D EVENTSEL_RETIRED_INSNS | AMD64_EVENTSEL_HOSTONLY;
> > +     wrmsr(MSR_F15H_PERF_CTL0, eventsel);
> > +     wrmsr(MSR_F15H_PERF_CTR0, 0);
> > +
> > +
> > +     /* Step 1: SVME=3D0; HG_ONLY ignored */
> > +     wrmsr(MSR_EFER, rdmsr(MSR_EFER) & ~EFER_SVME);
> > +     delta =3D run_and_measure();
> > +     GUEST_ASSERT_NE(delta, 0);
> > +
> > +     /* Step 2: Set SVME=3D1; Host-Only counter still counts */
> > +     wrmsr(MSR_EFER, rdmsr(MSR_EFER) | EFER_SVME);
> > +     delta =3D run_and_measure();
> > +     GUEST_ASSERT_NE(delta, 0);
> > +
> > +     /* Step 3: VMRUN to L2; Host-Only counter stops */
> > +     generic_svm_setup(svm, l2_guest_code,
> > +                       &l2_guest_stack[L2_GUEST_STACK_SIZE]);
> > +     vmcb->control.intercept &=3D ~(1ULL << INTERCEPT_MSR_PROT);
> > +
> > +     run_guest(vmcb, svm->vmcb_gpa);
> > +
> > +     GUEST_ASSERT_EQ(vmcb->control.exit_code, SVM_EXIT_VMMCALL);
> > +     GUEST_ASSERT(data->l2_done);
> > +     GUEST_ASSERT_EQ(data->l2_delta, 0);
> > +
> > +     /* Step 4: After VMEXIT to L1; Host-Only counter counts */
> > +     delta =3D run_and_measure();
> > +     GUEST_ASSERT_NE(delta, 0);
> > +
> > +     /* Step 5: Clear SVME; HG_ONLY ignored */
> > +     wrmsr(MSR_EFER, rdmsr(MSR_EFER) & ~EFER_SVME);
> > +     delta =3D run_and_measure();
> > +     GUEST_ASSERT_NE(delta, 0);
> > +
> > +     GUEST_DONE();
> > +}
> > +
> > +/*
> > + * Test that both bits set is the same as neither bit set (always coun=
ts).
> > + */
> > +static void l1_guest_code_both_bits(struct svm_test_data *svm,
>
> l1_guest_code gets somewhat redundant.  What about these to be more descr=
iptive
> about the salient points, without creating monstrous names?
>
>         l1_test_no_filtering // very open to suggestions for a better nam=
e
>         l1_test_guestonly
>         l1_test_hostonly
>         l1_test_host_and_guest
>
> Actually, why are there even separate helpers?  Very off the cuff, but th=
is seems
> trivial to dedup:
>
> static void l1_guest_code(struct svm_test_data *svm, u64 host_guest_mask)
> {
>         const bool count_in_host =3D !host_guest_mask ||
>                                    (host_guest_mask & AMD64_EVENTSEL_HOST=
ONLY);
>         const bool count_in_guest =3D !host_guest_mask ||
>                                     (host_guest_mask & AMD64_EVENTSEL_GUE=
STONLY);
>         unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
>         struct vmcb *vmcb =3D svm->vmcb;
>         uint64_t eventsel, delta;
>
>         wrmsr(MSR_F15H_PERF_CTL0, EVENTSEL_RETIRED_INSNS | host_guest_mas=
k);
>         wrmsr(MSR_F15H_PERF_CTR0, 0);
>
>         /* Step 1: SVME=3D0; host always counts */
>         wrmsr(MSR_EFER, rdmsr(MSR_EFER) & ~EFER_SVME);
>         delta =3D run_and_measure();
>         GUEST_ASSERT_NE(delta, 0);
>
>         /* Step 2: Set SVME=3D1; Guest-Only counter stops */
>         wrmsr(MSR_EFER, rdmsr(MSR_EFER) | EFER_SVME);
>         delta =3D run_and_measure();
>         GUEST_ASSERT(!!delta =3D=3D count_in_host);
>
>         /* Step 3: VMRUN to L2; Guest-Only counter counts */
>         generic_svm_setup(svm, l2_guest_code,
>                           &l2_guest_stack[L2_GUEST_STACK_SIZE]);
>         vmcb->control.intercept &=3D ~(1ULL << INTERCEPT_MSR_PROT);
>
>         run_guest(vmcb, svm->vmcb_gpa);
>
>         GUEST_ASSERT_EQ(vmcb->control.exit_code, SVM_EXIT_VMMCALL);
>         GUEST_ASSERT(data->l2_done);
>         GUEST_ASSERT(!!data->l2_delta =3D=3D count_in_guest);
>
>         /* Step 4: After VMEXIT to L1; Guest-Only counter stops */
>         delta =3D run_and_measure();
>         GUEST_ASSERT(!!delta =3D=3D count_in_host);
>
>         /* Step 5: Clear SVME; HG_ONLY ignored */
>         wrmsr(MSR_EFER, rdmsr(MSR_EFER) & ~EFER_SVME);
>         delta =3D run_and_measure();
>         GUEST_ASSERT_NE(delta, 0);
>
>         GUEST_DONE();
> }

Even better, I will fold this all into one test flow with 4 PMCs
covering the bit permutations.

> > +                                 struct hg_test_data *data)
> > +{
> > +     unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
> > +     struct vmcb *vmcb =3D svm->vmcb;
> > +     uint64_t eventsel, delta;
> > +
> > +     hg_data =3D data;
> > +
> > +     eventsel =3D EVENTSEL_RETIRED_INSNS |
> > +             AMD64_EVENTSEL_HOSTONLY | AMD64_EVENTSEL_GUESTONLY;
> > +     wrmsr(MSR_F15H_PERF_CTL0, eventsel);
> > +     wrmsr(MSR_F15H_PERF_CTR0, 0);
> > +
> > +     /* Step 1: SVME=3D0 */
> > +     wrmsr(MSR_EFER, rdmsr(MSR_EFER) & ~EFER_SVME);
> > +     delta =3D run_and_measure();
> > +     GUEST_ASSERT_NE(delta, 0);
> > +
> > +     /* Step 2: Set SVME=3D1 */
> > +     wrmsr(MSR_EFER, rdmsr(MSR_EFER) | EFER_SVME);
> > +     delta =3D run_and_measure();
> > +     GUEST_ASSERT_NE(delta, 0);
> > +
> > +     /* Step 3: VMRUN to L2 */
> > +     generic_svm_setup(svm, l2_guest_code,
> > +                       &l2_guest_stack[L2_GUEST_STACK_SIZE]);
> > +     vmcb->control.intercept &=3D ~(1ULL << INTERCEPT_MSR_PROT);
> > +
> > +     run_guest(vmcb, svm->vmcb_gpa);
> > +
> > +     GUEST_ASSERT_EQ(vmcb->control.exit_code, SVM_EXIT_VMMCALL);
> > +     GUEST_ASSERT(data->l2_done);
> > +     GUEST_ASSERT_NE(data->l2_delta, 0);
> > +
> > +     /* Step 4: After VMEXIT to L1 */
> > +     delta =3D run_and_measure();
> > +     GUEST_ASSERT_NE(delta, 0);
> > +
> > +     /* Step 5: Clear SVME */
> > +     wrmsr(MSR_EFER, rdmsr(MSR_EFER) & ~EFER_SVME);
> > +     delta =3D run_and_measure();
> > +     GUEST_ASSERT_NE(delta, 0);
> > +
> > +     GUEST_DONE();
> > +}
> > +
> > +static void l1_guest_code(struct svm_test_data *svm, struct hg_test_da=
ta *data,
> > +                       int test_num)
> > +{
> > +     switch (test_num) {
> > +     case 0:
>
> As above, I would much rather pass in the mask of GUEST_HOST bits to set,=
 and
> then react accordingly, as opposed to passing in a magic/arbitrary @test_=
num.
> Then I'm pretty sure we don't need a dispatch function, just run the test=
case
> using the passed in mask.
>
> > +             l1_guest_code_guestonly(svm, data);
> > +             break;
> > +     case 1:
> > +             l1_guest_code_hostonly(svm, data);
> > +             break;
> > +     case 2:
> > +             l1_guest_code_both_bits(svm, data);
> > +             break;
> > +     }
> > +}
>
> ...
>
> > +int main(int argc, char *argv[])
> > +{
> > +     TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_SVM));
> > +     TEST_REQUIRE(kvm_is_pmu_enabled());
> > +     TEST_REQUIRE(get_kvm_amd_param_bool("enable_mediated_pmu"));
> > +
> > +     run_test(0, "Guest-Only counter across all transitions");
> > +     run_test(1, "Host-Only counter across all transitions");
> > +     run_test(2, "Both HG_ONLY bits set (always count)");
>
> As alluded to above, shouldn't we also test "no bits set"?
> > +
> > +     return 0;
> > +}
> > --
> > 2.52.0.457.g6b5491de43-goog
> >

