Return-Path: <kvm+bounces-69779-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8MN8CywIfmnXUwIAu9opvQ
	(envelope-from <kvm+bounces-69779-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 31 Jan 2026 14:48:28 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E0B4C211D
	for <lists+kvm@lfdr.de>; Sat, 31 Jan 2026 14:48:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6025F300EC9C
	for <lists+kvm@lfdr.de>; Sat, 31 Jan 2026 13:48:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12F1432E6AC;
	Sat, 31 Jan 2026 13:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gDOe7tcl"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 498F11EB9E1
	for <kvm@vger.kernel.org>; Sat, 31 Jan 2026 13:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769867292; cv=none; b=R3bUh9JAXnr8Th8vVXNtsy3/8lqxZum/2PEy3w/vMqwFh2dpyh8I+GfeDI1LC0K/DkOVw5hk7/PAMadVjaktLispCMYNozAzSdxYjIagTsuAXOwXbN0k5IBLwj4X2OScto7FaM2WWzwe7cHxU/JFSimp5If2YGFZFX/ATuqfWQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769867292; c=relaxed/simple;
	bh=c3oubV9p9YJHRYzoh1WuJoK1gvVyMDzQ90tesi6at1A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jQJbiO+nofZQUtHmF7dkpMdluuV1RCDH9LSo3p//8eaSFOUC/qoiBKPMzW6uHDVrfgfFU33Raz3Q7pQu1K/dedec5kN2oiaAHMurW74hljPKkUpyDvtNomTYunv5+Ub1QTRlrSMUYxlwCko5dD75PfMZ3dbnZO9n37aZWKw5eiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gDOe7tcl; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F383CC16AAE
	for <kvm@vger.kernel.org>; Sat, 31 Jan 2026 13:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769867292;
	bh=c3oubV9p9YJHRYzoh1WuJoK1gvVyMDzQ90tesi6at1A=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=gDOe7tclJdmYyLaUerY6Oabrm+LOI84f6u1/nKIKZq2zfMvbGejPRq1ocHRys2HSh
	 MNN/tKvxV+bsWRtag+udJYL+1HSohhAgQZNFtPTWI0AD9tUySFSbFfxlBeVX8o6tVU
	 0OryRLhSDx/V620ceMXrtrH4EO+ET7ZywzRyXxL+PHpwDSSclZfSX9HVniBxYYx5h7
	 8soT+vYK+4mT0RMZj+p7dwHGovOx0mExPV7Lnn/xPrma6LOwXScqbZFIQF4/wXS2e1
	 dGJDd5SxBpgkZ2pwV8haCjQjaJ7YwFBTn5LuBqS+DtZ77RlkkbV2M6F6RG7l0Tvqmd
	 DbTUaB5Nx5Kdw==
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b8710c9cddbso372900966b.2
        for <kvm@vger.kernel.org>; Sat, 31 Jan 2026 05:48:11 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCV7a5kUgxbwtZln+j67qI8ZMC5jUDy7CC4ZY8hzWayBUkxtmLVbjC2/LXx6NG1vOJvXFnk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1GRTQxlULOfz/rTIYVfzmM0sTNXNwK9Sr3b3vZcxEASRrXDQu
	ifGDc8Uph/godE40E1QRatV4CpM1FmyGf3oNygjdNHOKk71us1A1eAfknJOyHyMWOBULQtpkdxm
	nqqgAtUJmq65yWL1S+YA9OLn2QoP6k4E=
X-Received: by 2002:a17:907:7f88:b0:b87:a0df:2f98 with SMTP id
 a640c23a62f3a-b8dff8d569fmr363155266b.63.1769867290575; Sat, 31 Jan 2026
 05:48:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260129021839.3674879-1-maobibo@loongson.cn>
In-Reply-To: <20260129021839.3674879-1-maobibo@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Sat, 31 Jan 2026 21:47:58 +0800
X-Gmail-Original-Message-ID: <CAAhV-H5yZbocBBBN5nMqb32UaVP6i8+9X4RNAwquVYVFVRaBVg@mail.gmail.com>
X-Gm-Features: AZwV_Qgd5qP6x_0XeLUcaeDH7UqCvoexRJGD1aaE6ZCwmmez-OruVErJCGAuCPI
Message-ID: <CAAhV-H5yZbocBBBN5nMqb32UaVP6i8+9X4RNAwquVYVFVRaBVg@mail.gmail.com>
Subject: Re: [PATCH] KVM: LoongArch: selftests: Add steal time test case
To: Bibo Mao <maobibo@loongson.cn>, "open list:LOONGARCH" <loongarch@lists.linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69779-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chenhuacai@kernel.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,mail.gmail.com:mid,loongson.cn:email]
X-Rspamd-Queue-Id: 9E0B4C211D
X-Rspamd-Action: no action

Since paravirt preempt is also applied, I applied this one with some
modifications, you can check whether it is correct.

https://git.kernel.org/pub/scm/linux/kernel/git/chenhuacai/linux-loongson.g=
it/commit/?h=3Dloongarch-kvm&id=3Dcf991b57ffc808d69cb1f911563b1d4658774ccf

Huacai

On Thu, Jan 29, 2026 at 10:18=E2=80=AFAM Bibo Mao <maobibo@loongson.cn> wro=
te:
>
> LoongArch KVM supports steal time accounting now, here add steal time
> test case on LoongArch.
>
> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> ---
>  tools/testing/selftests/kvm/Makefile.kvm |  1 +
>  tools/testing/selftests/kvm/steal_time.c | 85 ++++++++++++++++++++++++
>  2 files changed, 86 insertions(+)
>
> diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/sel=
ftests/kvm/Makefile.kvm
> index ba5c2b643efa..a18c00f1a4fa 100644
> --- a/tools/testing/selftests/kvm/Makefile.kvm
> +++ b/tools/testing/selftests/kvm/Makefile.kvm
> @@ -228,6 +228,7 @@ TEST_GEN_PROGS_loongarch +=3D kvm_page_table_test
>  TEST_GEN_PROGS_loongarch +=3D memslot_modification_stress_test
>  TEST_GEN_PROGS_loongarch +=3D memslot_perf_test
>  TEST_GEN_PROGS_loongarch +=3D set_memory_region_test
> +TEST_GEN_PROGS_loongarch +=3D steal_time
>
>  SPLIT_TESTS +=3D arch_timer
>  SPLIT_TESTS +=3D get-reg-list
> diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/sel=
ftests/kvm/steal_time.c
> index 8edc1fca345b..ee13e8973c45 100644
> --- a/tools/testing/selftests/kvm/steal_time.c
> +++ b/tools/testing/selftests/kvm/steal_time.c
> @@ -301,6 +301,91 @@ static void steal_time_dump(struct kvm_vm *vm, uint3=
2_t vcpu_idx)
>         pr_info("\n");
>  }
>
> +#elif defined(__loongarch__)
> +/* steal_time must have 64-byte alignment */
> +#define STEAL_TIME_SIZE                ((sizeof(struct kvm_steal_time) +=
 63) & ~63)
> +#define KVM_STEAL_PHYS_VALID   BIT_ULL(0)
> +
> +struct kvm_steal_time {
> +       __u64 steal;
> +       __u32 version;
> +       __u32 flags;
> +       __u32 pad[12];
> +};
> +
> +static bool is_steal_time_supported(struct kvm_vcpu *vcpu)
> +{
> +       int err;
> +       uint64_t val;
> +       struct kvm_device_attr attr =3D {
> +               .group =3D KVM_LOONGARCH_VCPU_CPUCFG,
> +               .attr =3D CPUCFG_KVM_FEATURE,
> +               .addr =3D (uint64_t)&val,
> +       };
> +
> +       err =3D __vcpu_ioctl(vcpu, KVM_HAS_DEVICE_ATTR, &attr);
> +       if (err)
> +               return false;
> +
> +       err =3D __vcpu_ioctl(vcpu, KVM_GET_DEVICE_ATTR, &attr);
> +       if (err)
> +               return false;
> +
> +       return val & BIT(KVM_FEATURE_STEAL_TIME);
> +}
> +
> +static void steal_time_init(struct kvm_vcpu *vcpu, uint32_t i)
> +{
> +       struct kvm_vm *vm =3D vcpu->vm;
> +       uint64_t st_gpa;
> +       int err;
> +       struct kvm_device_attr attr =3D {
> +               .group =3D KVM_LOONGARCH_VCPU_PVTIME_CTRL,
> +               .attr =3D KVM_LOONGARCH_VCPU_PVTIME_GPA,
> +               .addr =3D (uint64_t)&st_gpa,
> +       };
> +
> +       /* ST_GPA_BASE is identity mapped */
> +       st_gva[i] =3D (void *)(ST_GPA_BASE + i * STEAL_TIME_SIZE);
> +       sync_global_to_guest(vm, st_gva[i]);
> +
> +       err =3D __vcpu_ioctl(vcpu, KVM_HAS_DEVICE_ATTR, &attr);
> +       TEST_ASSERT(err =3D=3D 0, "No PV stealtime Feature");
> +
> +       st_gpa =3D (unsigned long)st_gva[i] | KVM_STEAL_PHYS_VALID;
> +       err =3D __vcpu_ioctl(vcpu, KVM_SET_DEVICE_ATTR, &attr);
> +       TEST_ASSERT(err =3D=3D 0, "Fail to set PV stealtime GPA");
> +}
> +
> +static void guest_code(int cpu)
> +{
> +       struct kvm_steal_time *st =3D st_gva[cpu];
> +       uint32_t version;
> +
> +       memset(st, 0, sizeof(*st));
> +       GUEST_SYNC(0);
> +
> +       GUEST_ASSERT(!(READ_ONCE(st->version) & 1));
> +       WRITE_ONCE(guest_stolen_time[cpu], st->steal);
> +       version =3D READ_ONCE(st->version);
> +       GUEST_ASSERT(!(READ_ONCE(st->version) & 1));
> +       GUEST_SYNC(1);
> +
> +       GUEST_ASSERT(!(READ_ONCE(st->version) & 1));
> +       GUEST_ASSERT(version < READ_ONCE(st->version));
> +       WRITE_ONCE(guest_stolen_time[cpu], st->steal);
> +       GUEST_ASSERT(!(READ_ONCE(st->version) & 1));
> +       GUEST_DONE();
> +}
> +
> +static void steal_time_dump(struct kvm_vm *vm, uint32_t vcpu_idx)
> +{
> +       struct kvm_steal_time *st =3D addr_gva2hva(vm, (ulong)st_gva[vcpu=
_idx]);
> +
> +       ksft_print_msg("VCPU%d:\n", vcpu_idx);
> +       ksft_print_msg("    steal:     %lld\n", st->steal);
> +       ksft_print_msg("    version:   %d\n", st->version);
> +}
>  #endif
>
>  static void *do_steal_time(void *arg)
>
> base-commit: 8dfce8991b95d8625d0a1d2896e42f93b9d7f68d
> --
> 2.39.3
>

