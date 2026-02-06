Return-Path: <kvm+bounces-70389-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uJOmJos/hWme+gMAu9opvQ
	(envelope-from <kvm+bounces-70389-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 02:10:35 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CE84F8DFC
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 02:10:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id EA1A3302FEAD
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 01:10:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D074234994;
	Fri,  6 Feb 2026 01:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aQKePXfn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75C1122652D
	for <kvm@vger.kernel.org>; Fri,  6 Feb 2026 01:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770340220; cv=pass; b=CTCvZt3OnjA1/7E22tuF6sN6jKYj+p4xhBqkTcOzJYrBOe65npecLYN8hGuvJdctsI9C6UexNlujIgUFRwTO/sNm68TIdPgdGPfbnWgs0oCGJEyCiRN/mAOYUmL+/McK+iTk9YvcT+CvJ90LMNd+YQXppAAG3owrrYIgT4CWE5w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770340220; c=relaxed/simple;
	bh=1vNVLQJG5oXLqAy4C434UqfIxmm1yq8IJUp605bCllM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=o/gbQsGJw81eWzaTVTqNm9OXm8TFpmpgjVY5WhW+wwk6RvuEzUbkPAmioyt/SnutAc/0tCYHA18oqNTz0QXWi2PbKQtKfFfXCiILxPY3o9+OSU99rMX0ObGKbrrw322sBq01Gg2DXMfIlolkfwtsse/J73tQ5n6Gah3QNTHeU9Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aQKePXfn; arc=pass smtp.client-ip=209.85.160.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-40974bf7781so1542956fac.0
        for <kvm@vger.kernel.org>; Thu, 05 Feb 2026 17:10:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770340219; cv=none;
        d=google.com; s=arc-20240605;
        b=jfFlEbUFzoV5qccU1wgyVDpYpZd9tVgow+fRcsvpficoa04h0VnQw6AdSHd1NJdOoA
         bMhVf+li1weXaVTfYT3Kj0ecejgCtzVLEqiMQqu7C1rheSNN27nRAwd7XRGude6c3Ive
         WVdU9OJ6JsSNyTIhBYRsedpwzRy3NqlqNsYrSlt/hw6v2SawGrCJOpTp0PDEmwPdbrX8
         f9VKl4pBEjR4lu74wkP7PFz06MGc7wK4r4ehUv+7rqDTee+is0dpZl/VSTAfxq9hfgK1
         q4mul5Jjaxn6wGlC2diPTBMcRErO5h4TakTe+S+giGDBc+kFNHxMD75luINhwOPymdGI
         PiZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=g/MfuwqLqbhKjZWvGBnhdqUtPnwfWft+1ZZSTUtvZos=;
        fh=B8LF+95VzmxOlLiZqOnn+T8gIWVPhqO3B0lnPpYlQEs=;
        b=CJU+RHUMbPN137Rlmn+vtazP2XPasgrJwal54zmk+qApxbziPm+uJDBhdP6evwDKPF
         kK8Qv7WUwB76LWkKmuWm70FKJOVRUYzzf1ebVVQ886jHd+giiPfjfTU6lsBgbL1ezMn0
         FPS7phDIRR0dIqTwabu1gA5x+QfTVT5ewLn/MeQulO6+g8NTT8LvC39yk7Mx2eTmVTut
         DA9OpHCOcdpbG80myFZzrU4TuNASAybZW71pR/TZny1qz8h6ihjMYZC7jioeBwecUexs
         w+HNWHH/sMDC82ZJvshwhzlML7sLZQXFO7YlXWxHagXnmyDeow++1ty8x2AhrALXs1sk
         RsUw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770340219; x=1770945019; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g/MfuwqLqbhKjZWvGBnhdqUtPnwfWft+1ZZSTUtvZos=;
        b=aQKePXfnu+W9MDd615sSOwnKwTl97iQpLqeWfDHcmCAtJfwCiOEOtKGxRdCZ9rrRDC
         RO9+7SApuKr5ZZ6eg2qP0dPpADFCS+nRcWRoFVKQqHMfRUxReGEuka7h520gUC+FGir1
         PWrLaBLNi3gWg/TZKfvYe2jhM5WgXWM40Mljx3+TCIbGAw1MfNJ/YSFUANBIgsnvJxLe
         m9USkoUyXJwrrYOHTLswassLUysVe7zbPZn44i6M5WH2EcjRauPlQ5/VcJYgfyjk4GvW
         dZjRt/86eqvbVq2qNTbz4NuycUVuzWMgZaXvOVZiatni+0E1Sd/h0lbMszl/3JXWnt8N
         V/XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770340219; x=1770945019;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=g/MfuwqLqbhKjZWvGBnhdqUtPnwfWft+1ZZSTUtvZos=;
        b=lmbwGkxYmUULB9wCk0iqmDPCJYu/16PpR0NDmWANzSHOxwLJub7TeXAogdJs+etUr2
         HEU3SFEVwBaJP8LXlmZfm5/3MWoNI0KeSKNFt4HbxxHOccfXGeLWLx21DHT7Zfm6tA9s
         DxDeuxbfcjCnyIgeaywJZ12pk7HK1fp7Xg2JI128tjeiGcEJ0N2Q/2q36pZpAF3csO7j
         Uo8cv/caNBav/A30SyCjblMws6zMwfRuEAcbtD4tbfYnEtjsHuHwE+9ZkItWXXWe0arT
         WYh7DuUNFjKS2xH/iOlkdb3cYAFyjOimMqs6Nswpi+mtbxvf0EqTYE8PDpJq5o/OySTz
         H5CA==
X-Forwarded-Encrypted: i=1; AJvYcCX4+lMG4Wd3QBdHNopy0Zx7ynsLp27YTy24V78dja9s/GS70tVO13gM2DSBxfGyTobM8w4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyrZjtjitzfp32QddfaWNr7k914ssclLa8krYHtL1mWtNkAqcbB
	Hk+xR3IX4kCXwH5ZUkoqi00bIbcUBDDuKIVjjBapG7prirsVBeCrPRNQrwsxMqTsfbe1DElZtH3
	zUhi319cMDe7+CCkOVqdAgSAZOS2MNzXe3vtAb1cXeI9Y
X-Gm-Gg: AZuq6aIiJUS2YgGnYDX97ItMSQtMSH1ccbHqyue5RdPqvdOQXi6vhCufQwJRnIjsQ8a
	xYBkDX5gAP1AJbKM9y+GFzwBfDa3aJAkb0QvwJswZsu+ThZFdcdSzlk5rXKuddbEqIn6hKPenNj
	tFJIk3jweY5NZwx7fQs9k0irBk6fjv3S0+96pUviBm7kYa2bvBfzU8jLcDF/B112zOGZ7x2TC2y
	YZ/uOVXAK1KNELN1BaDYaaoQUOPxngWLCiUgkqVG4b22ocglBboHnx5T33tTp+wFKinXQYDLBWl
	M5otM9Bif2zo9rvAi2pH6EdHeCU=
X-Received: by 2002:a05:6820:4df5:b0:663:12ec:15b8 with SMTP id
 006d021491bc7-66d148a45c3mr529303eaf.26.1770340219223; Thu, 05 Feb 2026
 17:10:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260205010502.2554381-1-xujiakai2025@iscas.ac.cn>
 <20260205010502.2554381-3-xujiakai2025@iscas.ac.cn> <gcspbbvqkr7y53c4ytkqqycygkcqkiakle4aelq2z7nsnlyegl@addv4v655cbg>
In-Reply-To: <gcspbbvqkr7y53c4ytkqqycygkcqkiakle4aelq2z7nsnlyegl@addv4v655cbg>
From: eanut 6 <jiakaipeanut@gmail.com>
Date: Fri, 6 Feb 2026 09:10:08 +0800
X-Gm-Features: AZwV_QhcFA9toIkXo56oGUCoj8hyEt0zkeewoqds6t1BmWq6FbDPmwG23AVfrVE
Message-ID: <CAFb8wJuXBLiqZieA+puXd=5BGhHaNqy_vvSJgfhp-v4q3D4mHQ@mail.gmail.com>
Subject: Re: [PATCH v6 2/2] RISC-V: KVM: selftests: Add RISC-V SBI STA shmem
 alignment tests
To: Andrew Jones <andrew.jones@oss.qualcomm.com>
Cc: Jiakai Xu <xujiakai2025@iscas.ac.cn>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atish.patra@linux.dev>, 
	Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Andrew Jones <ajones@ventanamicro.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-70389-lists,kvm=lfdr.de];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[16];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jiakaipeanut@gmail.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,mail.gmail.com:mid,iscas.ac.cn:email,qualcomm.com:email]
X-Rspamd-Queue-Id: 1CE84F8DFC
X-Rspamd-Action: no action

Hi Drew,

Thanks a lot for the detailed review and suggestions.
I agree with your points.

I will post a revised version in about a week. This is mainly to allow
some time in case other reviewers have additional feedback on the
current approach, so that everything can be addressed together in the
next revision.

Thanks again for the careful review.

Best regards,
Jiakai

On Thu, Feb 5, 2026 at 11:58=E2=80=AFPM Andrew Jones
<andrew.jones@oss.qualcomm.com> wrote:
>
> On Thu, Feb 05, 2026 at 01:05:02AM +0000, Jiakai Xu wrote:
> > Add RISC-V KVM selftests to verify the SBI Steal-Time Accounting (STA)
> > shared memory alignment requirements.
> >
> > The SBI specification requires the STA shared memory GPA to be 64-byte
> > aligned, or set to all-ones to explicitly disable steal-time accounting=
.
> > This test verifies that KVM enforces the expected behavior when
> > configuring the SBI STA shared memory via KVM_SET_ONE_REG.
> >
> > Specifically, the test checks that:
> > - misaligned GPAs are rejected with -EINVAL
> > - 64-byte aligned GPAs are accepted
> > - INVALID_GPA correctly disables steal-time accounting
> >
> > Signed-off-by: Jiakai Xu <xujiakai2025@iscas.ac.cn>
> > Signed-off-by: Jiakai Xu <jiakaiPeanut@gmail.com>
> > ---
> >  .../selftests/kvm/include/riscv/processor.h   |  4 +++
> >  tools/testing/selftests/kvm/steal_time.c      | 33 +++++++++++++++++++
> >  2 files changed, 37 insertions(+)
> >
> > diff --git a/tools/testing/selftests/kvm/include/riscv/processor.h b/to=
ols/testing/selftests/kvm/include/riscv/processor.h
> > index e58282488beb3..c3551d129d2f6 100644
> > --- a/tools/testing/selftests/kvm/include/riscv/processor.h
> > +++ b/tools/testing/selftests/kvm/include/riscv/processor.h
> > @@ -62,6 +62,10 @@ static inline uint64_t __kvm_reg_id(uint64_t type, u=
int64_t subtype,
> >                                                    KVM_REG_RISCV_SBI_SI=
NGLE,          \
> >                                                    idx, KVM_REG_SIZE_UL=
ONG)
> >
> > +#define RISCV_SBI_STA_REG(idx)       __kvm_reg_id(KVM_REG_RISCV_SBI_ST=
ATE,   \
> > +                                                  KVM_REG_RISCV_SBI_ST=
A,                     \
> > +                                                  idx, KVM_REG_SIZE_UL=
ONG)
>
> We don't need this because...
>
> > +
> >  bool __vcpu_has_ext(struct kvm_vcpu *vcpu, uint64_t ext);
> >
> >  static inline bool __vcpu_has_isa_ext(struct kvm_vcpu *vcpu, uint64_t =
isa_ext)
> > diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/s=
elftests/kvm/steal_time.c
> > index 8edc1fca345ba..30b98d1b601c3 100644
> > --- a/tools/testing/selftests/kvm/steal_time.c
> > +++ b/tools/testing/selftests/kvm/steal_time.c
> > @@ -209,6 +209,7 @@ static void steal_time_dump(struct kvm_vm *vm, uint=
32_t vcpu_idx)
> >
> >  /* SBI STA shmem must have 64-byte alignment */
> >  #define STEAL_TIME_SIZE              ((sizeof(struct sta_struct) + 63)=
 & ~63)
> > +#define INVALID_GPA (~(u64)0)
> >
> >  static vm_paddr_t st_gpa[NR_VCPUS];
> >
> > @@ -301,6 +302,34 @@ static void steal_time_dump(struct kvm_vm *vm, uin=
t32_t vcpu_idx)
> >       pr_info("\n");
> >  }
> >
> > +static void test_riscv_sta_shmem_alignment(struct kvm_vcpu *vcpu)
> > +{
> > +     struct kvm_one_reg reg;
> > +     uint64_t shmem;
> > +     int ret;
> > +
> > +     reg.id =3D RISCV_SBI_STA_REG(0);
>
> ...here we should use KVM_REG_RISCV_SBI_STA_REG(shmem_lo)
>
> > +     reg.addr =3D (uint64_t)&shmem;
> > +
> > +     /* Case 1: misaligned GPA */
> > +     shmem =3D ST_GPA_BASE + 1;
> > +     ret =3D __vcpu_ioctl(vcpu, KVM_SET_ONE_REG, &reg);
> > +     TEST_ASSERT(ret =3D=3D -1 && errno =3D=3D EINVAL,
> > +                 "misaligned STA shmem should return -EINVAL");
>
> remove the word 'should'
>
> "misaligned STA shmem returns -EINVAL"
>
> > +
> > +     /* Case 2: 64-byte aligned GPA */
> > +     shmem =3D ST_GPA_BASE;
> > +     ret =3D __vcpu_ioctl(vcpu, KVM_SET_ONE_REG, &reg);
> > +     TEST_ASSERT(ret =3D=3D 0,
> > +                 "aligned STA shmem should succeed");
>
> same comment about 'should'
>
> > +
> > +     /* Case 3: INVALID_GPA disables STA */
> > +     shmem =3D INVALID_GPA;
> > +     ret =3D __vcpu_ioctl(vcpu, KVM_SET_ONE_REG, &reg);
> > +     TEST_ASSERT(ret =3D=3D 0,
> > +                 "INVALID_GPA should disable STA successfully");
>
> We're not testing that STA was successfully disabled, only that all-ones
> input doesn't generate an error. So the message should be along the lines
> of "all-ones for STA shmem succeeds"
>
> > +}
> > +
> >  #endif
> >
> >  static void *do_steal_time(void *arg)
> > @@ -369,6 +398,10 @@ int main(int ac, char **av)
> >       TEST_REQUIRE(is_steal_time_supported(vcpus[0]));
> >       ksft_set_plan(NR_VCPUS);
> >
> > +#ifdef __riscv
> > +     test_riscv_sta_shmem_alignment(vcpus[0]);
> > +#endif
>
> We like to try to avoid #ifdefs in common functions by providing stubs fo=
r
> architectures that don't need them [yet]. So we should rename this to
> something more generic, like
>
>  check_steal_time_uapi()
>
> and then call it for all architectures. Actually the other architectures
> can already make use of it since both x86 and arm64 do uapi tests in
> their steal_time_init() functions and that's not really the right
> place to do that. I suggest creating another patch that first moves those
> tests into new functions (check_steal_time_uapi()) which only needs to
> be called once for vcpu[0] outside the vcpu loop, as you do here. In
> that patch check_steal_time_uapi() will be a stub for riscv. Then in
> a second patch fill in that stub with the tests above.
>
> Thanks,
> drew
>
> > +
> >       /* Run test on each VCPU */
> >       for (i =3D 0; i < NR_VCPUS; ++i) {
> >               steal_time_init(vcpus[i], i);
> > --
> > 2.34.1
> >

