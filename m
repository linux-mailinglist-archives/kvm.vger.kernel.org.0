Return-Path: <kvm+bounces-69802-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EEGJIJtTgGkd6gIAu9opvQ
	(envelope-from <kvm+bounces-69802-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 08:34:51 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D648C9306
	for <lists+kvm@lfdr.de>; Mon, 02 Feb 2026 08:34:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F14A0302DB7D
	for <lists+kvm@lfdr.de>; Mon,  2 Feb 2026 07:31:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4153296BC5;
	Mon,  2 Feb 2026 07:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BDnQLyC2"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D51821339A4
	for <kvm@vger.kernel.org>; Mon,  2 Feb 2026 07:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770017490; cv=none; b=drB/7uZNzi/7vESOQZqmFwxjGiQtXjgLMrunfAiP6yH7x7+nbiv3JrMp0hzRPQ6zs4dqGOMe6pkVgZQHsYT+6pp5kbwaS0eG/dSRsvD2A5ultO5QMcGaoRx4n5bSGjbzfDk+dn4xF0yC8bM2jKM2Dq5CV+CgbVx18/S8tb1Rc1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770017490; c=relaxed/simple;
	bh=712wRN6EWIS01X5o6JuTZ7FSNFfFpQ84hrmEyj7O/IA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=vFCraE2dPCfX8hAnCyZS43kWKpO4hXxjl2QSDPa8YfmZf7hqeCpGGAahH6mSlen2Hr3445rMUQNVjfH5GN4GHsp7uGoLMGCvMxl04xpl22ZJTUkaiePQYaouw2s779A1K07lSrD0Hrl7yJ9eSMZ1x8/2/4tWxwYE++3+H1o+R2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BDnQLyC2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3879C2BCAF
	for <kvm@vger.kernel.org>; Mon,  2 Feb 2026 07:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770017490;
	bh=712wRN6EWIS01X5o6JuTZ7FSNFfFpQ84hrmEyj7O/IA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=BDnQLyC2KqK6d0NgVcTpogIdhBeNKBOIEKe5WJ96foNL2lfPYFNYdIqcrwzxo56JP
	 QbjzyA7APYtQsLFK2DMu8j4/cIU3/7JPRbvWTlWt/hatsspZ1XU8KkiWgXZVfu8OhZ
	 imeH3Weej54qoxh57UrLgPCQM5f78X6ksKhA/ed5Y9Bj4DfVYvKgzqMNnv1AbREDD+
	 rOIB7JJcJNlB8lY1C7I6WCi5rrcx+ZIeKVDrVt5qJwu20Wm0jJp6xFglRZlRNHOFpH
	 VT3O/0LqJxR98pnizhnJIofjcW1mA4+dqRHJtWlRW0VvMm/GGNmT5AHWgu1ZxVS2jG
	 okoJdxQ03b7og==
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b86ed375d37so561398566b.3
        for <kvm@vger.kernel.org>; Sun, 01 Feb 2026 23:31:30 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXtO0jF0zKrR08mmcXr8bX+O4ymE6mff4YElghZEBYrIoQN1eaPV21rOmYlttOKj+Lq0NQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzeRR4YgAmq+Ka/QyD0UMbEllHRCyoD8hUdok4f1y0T6znpPiMh
	2TFS4n3yWztZO+pDe8n1j0xbhcnz6vLNVsP+wvty/5hdqRZVcqqXz8r5w5EIUg36fx2HbY9iEk7
	85aCgswFpsLbjWiT2sbXphpUiYRId+y4=
X-Received: by 2002:a17:907:7f8a:b0:b73:6c97:af4b with SMTP id
 a640c23a62f3a-b8dff6f791cmr596960466b.45.1770017489080; Sun, 01 Feb 2026
 23:31:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260129021839.3674879-1-maobibo@loongson.cn> <CAAhV-H5yZbocBBBN5nMqb32UaVP6i8+9X4RNAwquVYVFVRaBVg@mail.gmail.com>
 <865fdd00-b8ef-1e17-c1b9-1cb264e32914@loongson.cn>
In-Reply-To: <865fdd00-b8ef-1e17-c1b9-1cb264e32914@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Mon, 2 Feb 2026 15:31:18 +0800
X-Gmail-Original-Message-ID: <CAAhV-H539vn34ptS-9N8VZ9qMjJ-Lk8LE1_GAbvoNR20L+k5Ng@mail.gmail.com>
X-Gm-Features: AZwV_QiFoBR3TEVIfrukpoQ-8BMqUcaGoOzl-sqqoB655rsSNqxxhBdI5qqbZ8M
Message-ID: <CAAhV-H539vn34ptS-9N8VZ9qMjJ-Lk8LE1_GAbvoNR20L+k5Ng@mail.gmail.com>
Subject: Re: [PATCH] KVM: LoongArch: selftests: Add steal time test case
To: Bibo Mao <maobibo@loongson.cn>
Cc: "open list:LOONGARCH" <loongarch@lists.linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69802-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chenhuacai@kernel.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid,loongson.cn:email]
X-Rspamd-Queue-Id: 0D648C9306
X-Rspamd-Action: no action

On Mon, Feb 2, 2026 at 10:03=E2=80=AFAM Bibo Mao <maobibo@loongson.cn> wrot=
e:
>
> Hi Huacai,
>
> On 2026/1/31 =E4=B8=8B=E5=8D=889:47, Huacai Chen wrote:
> > Since paravirt preempt is also applied, I applied this one with some
> > modifications, you can check whether it is correct.
> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/chenhuacai/linux-loongs=
on.git/commit/?h=3Dloongarch-kvm&id=3Dcf991b57ffc808d69cb1f911563b1d4658774=
ccf
>
> I checked the pendning patches in loongarch-kvm branch, they all look
> good to me.
OK, then are there any updates on this one?
https://lore.kernel.org/loongarch/CAAhV-H57b14qY+5jqe+Fd5FTQq6jrhurfNBCqBqw=
G6SUpKFhTw@mail.gmail.com/T/#t

Huacai
>
> Thanks for doing this.
>
> Regards
> Bibo Mao
> >
> > Huacai
> >
> > On Thu, Jan 29, 2026 at 10:18=E2=80=AFAM Bibo Mao <maobibo@loongson.cn>=
 wrote:
> >>
> >> LoongArch KVM supports steal time accounting now, here add steal time
> >> test case on LoongArch.
> >>
> >> Signed-off-by: Bibo Mao <maobibo@loongson.cn>
> >> ---
> >>   tools/testing/selftests/kvm/Makefile.kvm |  1 +
> >>   tools/testing/selftests/kvm/steal_time.c | 85 ++++++++++++++++++++++=
++
> >>   2 files changed, 86 insertions(+)
> >>
> >> diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/=
selftests/kvm/Makefile.kvm
> >> index ba5c2b643efa..a18c00f1a4fa 100644
> >> --- a/tools/testing/selftests/kvm/Makefile.kvm
> >> +++ b/tools/testing/selftests/kvm/Makefile.kvm
> >> @@ -228,6 +228,7 @@ TEST_GEN_PROGS_loongarch +=3D kvm_page_table_test
> >>   TEST_GEN_PROGS_loongarch +=3D memslot_modification_stress_test
> >>   TEST_GEN_PROGS_loongarch +=3D memslot_perf_test
> >>   TEST_GEN_PROGS_loongarch +=3D set_memory_region_test
> >> +TEST_GEN_PROGS_loongarch +=3D steal_time
> >>
> >>   SPLIT_TESTS +=3D arch_timer
> >>   SPLIT_TESTS +=3D get-reg-list
> >> diff --git a/tools/testing/selftests/kvm/steal_time.c b/tools/testing/=
selftests/kvm/steal_time.c
> >> index 8edc1fca345b..ee13e8973c45 100644
> >> --- a/tools/testing/selftests/kvm/steal_time.c
> >> +++ b/tools/testing/selftests/kvm/steal_time.c
> >> @@ -301,6 +301,91 @@ static void steal_time_dump(struct kvm_vm *vm, ui=
nt32_t vcpu_idx)
> >>          pr_info("\n");
> >>   }
> >>
> >> +#elif defined(__loongarch__)
> >> +/* steal_time must have 64-byte alignment */
> >> +#define STEAL_TIME_SIZE                ((sizeof(struct kvm_steal_time=
) + 63) & ~63)
> >> +#define KVM_STEAL_PHYS_VALID   BIT_ULL(0)
> >> +
> >> +struct kvm_steal_time {
> >> +       __u64 steal;
> >> +       __u32 version;
> >> +       __u32 flags;
> >> +       __u32 pad[12];
> >> +};
> >> +
> >> +static bool is_steal_time_supported(struct kvm_vcpu *vcpu)
> >> +{
> >> +       int err;
> >> +       uint64_t val;
> >> +       struct kvm_device_attr attr =3D {
> >> +               .group =3D KVM_LOONGARCH_VCPU_CPUCFG,
> >> +               .attr =3D CPUCFG_KVM_FEATURE,
> >> +               .addr =3D (uint64_t)&val,
> >> +       };
> >> +
> >> +       err =3D __vcpu_ioctl(vcpu, KVM_HAS_DEVICE_ATTR, &attr);
> >> +       if (err)
> >> +               return false;
> >> +
> >> +       err =3D __vcpu_ioctl(vcpu, KVM_GET_DEVICE_ATTR, &attr);
> >> +       if (err)
> >> +               return false;
> >> +
> >> +       return val & BIT(KVM_FEATURE_STEAL_TIME);
> >> +}
> >> +
> >> +static void steal_time_init(struct kvm_vcpu *vcpu, uint32_t i)
> >> +{
> >> +       struct kvm_vm *vm =3D vcpu->vm;
> >> +       uint64_t st_gpa;
> >> +       int err;
> >> +       struct kvm_device_attr attr =3D {
> >> +               .group =3D KVM_LOONGARCH_VCPU_PVTIME_CTRL,
> >> +               .attr =3D KVM_LOONGARCH_VCPU_PVTIME_GPA,
> >> +               .addr =3D (uint64_t)&st_gpa,
> >> +       };
> >> +
> >> +       /* ST_GPA_BASE is identity mapped */
> >> +       st_gva[i] =3D (void *)(ST_GPA_BASE + i * STEAL_TIME_SIZE);
> >> +       sync_global_to_guest(vm, st_gva[i]);
> >> +
> >> +       err =3D __vcpu_ioctl(vcpu, KVM_HAS_DEVICE_ATTR, &attr);
> >> +       TEST_ASSERT(err =3D=3D 0, "No PV stealtime Feature");
> >> +
> >> +       st_gpa =3D (unsigned long)st_gva[i] | KVM_STEAL_PHYS_VALID;
> >> +       err =3D __vcpu_ioctl(vcpu, KVM_SET_DEVICE_ATTR, &attr);
> >> +       TEST_ASSERT(err =3D=3D 0, "Fail to set PV stealtime GPA");
> >> +}
> >> +
> >> +static void guest_code(int cpu)
> >> +{
> >> +       struct kvm_steal_time *st =3D st_gva[cpu];
> >> +       uint32_t version;
> >> +
> >> +       memset(st, 0, sizeof(*st));
> >> +       GUEST_SYNC(0);
> >> +
> >> +       GUEST_ASSERT(!(READ_ONCE(st->version) & 1));
> >> +       WRITE_ONCE(guest_stolen_time[cpu], st->steal);
> >> +       version =3D READ_ONCE(st->version);
> >> +       GUEST_ASSERT(!(READ_ONCE(st->version) & 1));
> >> +       GUEST_SYNC(1);
> >> +
> >> +       GUEST_ASSERT(!(READ_ONCE(st->version) & 1));
> >> +       GUEST_ASSERT(version < READ_ONCE(st->version));
> >> +       WRITE_ONCE(guest_stolen_time[cpu], st->steal);
> >> +       GUEST_ASSERT(!(READ_ONCE(st->version) & 1));
> >> +       GUEST_DONE();
> >> +}
> >> +
> >> +static void steal_time_dump(struct kvm_vm *vm, uint32_t vcpu_idx)
> >> +{
> >> +       struct kvm_steal_time *st =3D addr_gva2hva(vm, (ulong)st_gva[v=
cpu_idx]);
> >> +
> >> +       ksft_print_msg("VCPU%d:\n", vcpu_idx);
> >> +       ksft_print_msg("    steal:     %lld\n", st->steal);
> >> +       ksft_print_msg("    version:   %d\n", st->version);
> >> +}
> >>   #endif
> >>
> >>   static void *do_steal_time(void *arg)
> >>
> >> base-commit: 8dfce8991b95d8625d0a1d2896e42f93b9d7f68d
> >> --
> >> 2.39.3
> >>
>
>

