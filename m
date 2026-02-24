Return-Path: <kvm+bounces-71618-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UHI5GCi3nWmQRQQAu9opvQ
	(envelope-from <kvm+bounces-71618-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 15:35:20 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 18B691886FD
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 15:35:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id CAC3B3061105
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 14:34:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E60D039E6E4;
	Tue, 24 Feb 2026 14:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jtpEG2+6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yx1-f53.google.com (mail-yx1-f53.google.com [74.125.224.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE6878405C
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 14:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771943692; cv=pass; b=h/xzWSr43bHLI8pGmh5IKSckA35VpuFR82wtBcQAzNsI2NRkw5M70YT3M5e+/JMnC0DV8uKxi1NTABHg9bXuW3sNPmJJ/mL4uNQOXGJDKdICaSXH22jd8kNFobGnVFXzg/BrBky57RpIhVsMgx/J0zZp4+XqM5lNAveyp2TZLzo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771943692; c=relaxed/simple;
	bh=LQS9s54PGR0RH5bznKavqJ+ILVh4MiTnEjfub296dow=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HSzQ7BPlXjc2f13snz9P0KjHgqew6tEKDcF8tUKMMstO51CF0ITWmrtpGvNEcRUaaVp19clMWCtjzwF52LbaRQxUk4C2/twF5los7J0L0czpLHn9ywdyXGabmIOndZvS0tSJhpOmTYUFbF+MheYvQvNlKjxqr0cZ+c2VujqhtOg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jtpEG2+6; arc=pass smtp.client-ip=74.125.224.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-yx1-f53.google.com with SMTP id 956f58d0204a3-64ad79dfb6eso5480325d50.0
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 06:34:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771943689; cv=none;
        d=google.com; s=arc-20240605;
        b=cBjusRvrbIL5Fnnaxd7Qi2LlNhltbXY61Nen2qqOLc1aDhX/HjuQc/1EAcYbOcriJc
         uGkUIrvGC9bGzjpqc+zPCCbjqcQVgUYle/1MfSxI6UWfCbTGIOQG8+uRTnk+zuxJxsTo
         /IyUVgMUJJIA/XE4svz242W1zu8moHIJxo9LM+EbYh8Nh4yYb8eE6zZZGA7S+rrs08HN
         Jkn8G7cEhmHfhb4T8TERa12GM5wgqdVcEVuuJedG6SvCYBANdrZMWoY4obLHwR79YaQK
         kfzNEUDsy9qfED5tnJpIsuQxkTZ9GTb9uSsWaiSF4YZdGhPDJSMh4meZSdsLMMGUOB4P
         VShw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=aflH0qDkgG4fC1sHybb7ibjojgZXGjJ7kgR08XJSBto=;
        fh=bMwu3hK7yjWev2c2cb55fPc2fpPoK//w4+PaevVMEOQ=;
        b=D8Z2mc/YxzQK7eEbqQtoKcqJ8QSRqvTGHZw0lJfgiPnn7BrOn/TK2IR5MFwNk6oSUq
         EfYJVVqywin+rg1NoAnOt8o/FW+r+E/jRf/ZL31JoYY3wnztTvnhEZP87qIEG2NsmGMS
         EIGGZY7VWiCVq4B0RTrH8jQW0T8Ki1PdUj7OjR/cUMJ/GcLqNPcKl/Q1kkdYa08rOves
         5XVlb7ankGySAY6Ro8Vaa4dq+CRWpDaJM3rPgYsFL2kaY7bzFl7/nr5U32A+NqQb0+DE
         Cr64UQsewG2SSvU2MXH6DiVCwjvLuj9wmZ9svZNV6DwiT7sA2OOt/ETm1rtTG4rbUQ+G
         1nlA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1771943689; x=1772548489; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=aflH0qDkgG4fC1sHybb7ibjojgZXGjJ7kgR08XJSBto=;
        b=jtpEG2+6lKuIyfYpGesdq4Y4FBxJrlit/dU/ZsAPJOMk8+OIwpJ8hXX/+9VHp7o63o
         dXt+Uyde+ZHeOQsrNYJtQu8ffLwzqy1Qcs3Tm4cj18fOK+HYjHJZ8B2bMPdoxoiy4KlD
         O+3pPBFO0enfsDyIrgFWteMT/Ska+t3zf42gY56mDEikKldtWhU9kqWfrT1aXlfvtgjt
         v+M+RRAYjL68kSChqSI7/wO5jTVJG+CHwUHoOqoV2Ligr3j3BPdIINYJ4L/46q8bPt84
         XwZ619WTI6HxZsGOr5ifiT+4z7z2pmmgm6Y55kvEUzVWOg2K54I2PDdFzkWaSO9P9Scs
         0ZLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771943689; x=1772548489;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aflH0qDkgG4fC1sHybb7ibjojgZXGjJ7kgR08XJSBto=;
        b=xO9HODo8jPAlFkf7YkeXbx5HRIQvhcdd3LFNFK40Ug+/ZlTd9kve/vQLZtmR8o5Te6
         k995Go1fHYiseWd0MEitmXOoNLWX2LW27WaivnrweWHdkJWymTwa2s83lD6C7Bkudxfm
         aR1C3Orx8tExlm0cZSXDF9dV3o1pXwWYyPeTHIEJvgBRiF3P69FDDQFQB2VfHfc0ARPQ
         t+wfiu6E/UZ3iu44UO1uG2Nz3HGHgEb2a4MB0QBSQo/qQhicBubm3gzrJxpzr/cNf2SK
         lj9sXsntjxkH7Qilq+dqbQ9MjhbT00UuuHYsC9ZlSkeIIdJr7TQSWWuWgJv/FI9/BXqx
         kq4w==
X-Forwarded-Encrypted: i=1; AJvYcCV/cpPyLLzpPDORP8Y+Ocv4WcqTTOoSP2yPeHSorx6J7mqpG/FAXvSwTcc1DMnpGr3Fwi4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2LZFJtKOQaB7AeqZwr+FKVlOjDDJuzzoMe3m8UHdYMql0MWxa
	ImXUCcXuQnURMufmeYE2iprSdkWVFz+z7354zYqzxKTLnu7auC4OndMdMjdQ1RtVCz0OU3crAs4
	y8v8ciaXK/lLHyq47fjt6M3Ff7l71Ls1YAdonhXoP3Q==
X-Gm-Gg: ATEYQzyL7yDswT3StBEKfJFKt2EHp5gs/vcbnWGt/y4DTQHo65p4VSKcy6gzceCRqk5
	I6qXharWwZXRA58DoaL6H0SPWiC6JCwtBtJxg/mXZa3x/q/hJk1+2q+xhFevTGXX/BwvAfXZWB2
	i5+Y9MpEGZKccbYrG24IafGf4yuNdLdYEYSi957qWJPrFtE2tvYIvCIQ5LkHqjTRB1H9e6oe4k3
	Ufw2kw1xAyyhKiZgWVIgLglpurstTPfnEv2lAAbTyTjQooPFJvdi35jSsXaI5iBd/fNO+RtuUUI
	jtjo78+jxQN62yIgD3yGGsCxcMfWioPGbqx25HV/0/Vhy7u9SUjCeeJURdKWvUr7mjE=
X-Received: by 2002:a05:690e:dc2:b0:64a:d9f5:d412 with SMTP id
 956f58d0204a3-64c78c1054cmr9104750d50.43.1771943688633; Tue, 24 Feb 2026
 06:34:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260220115656.4831-1-sebott@redhat.com> <20260220115656.4831-2-sebott@redhat.com>
In-Reply-To: <20260220115656.4831-2-sebott@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Tue, 24 Feb 2026 14:34:37 +0000
X-Gm-Features: AaiRm515uOhz39gYNVWQiyM_zHuBmfxeUElFEXao9Pe5eZx0PQvwmWIjvVpaqkY
Message-ID: <CAFEAcA8O2UEKToJ+zXA6=vvgkRyPKrPwtfHnti7yyGgCGwoJeA@mail.gmail.com>
Subject: Re: [PATCH v6 1/1] target/arm/kvm: add kvm-psci-version vcpu property
To: Sebastian Ott <sebott@redhat.com>
Cc: qemu-devel@nongnu.org, eric.auger@redhat.com, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev, pbonzini@redhat.com, qemu-arm@nongnu.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[linaro.org,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71618-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[linaro.org:+];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[peter.maydell@linaro.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[7];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,linaro.org:dkim,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 18B691886FD
X-Rspamd-Action: no action

On Fri, 20 Feb 2026 at 11:57, Sebastian Ott <sebott@redhat.com> wrote:
>
> Provide a kvm specific vcpu property to override the default
> (as of kernel v6.13 that would be PSCI v1.3) PSCI version emulated
> by kvm. Current valid values are: 0.1, 0.2, 1.0, 1.1, 1.2, and 1.3
>
> Note: in order to support PSCI v0.1 we need to drop vcpu
> initialization with KVM_CAP_ARM_PSCI_0_2 in that case.
>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Tested-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Sebastian Ott <sebott@redhat.com>
> ---
>  docs/system/arm/cpu-features.rst | 11 ++++++++
>  target/arm/cpu.c                 |  8 +++++-
>  target/arm/kvm.c                 | 48 ++++++++++++++++++++++++++++++--
>  3 files changed, 64 insertions(+), 3 deletions(-)
>
> diff --git a/docs/system/arm/cpu-features.rst b/docs/system/arm/cpu-features.rst
> index 3db1f19401..ce19ae6a04 100644
> --- a/docs/system/arm/cpu-features.rst
> +++ b/docs/system/arm/cpu-features.rst
> @@ -204,6 +204,17 @@ the list of KVM VCPU features and their descriptions.
>    the guest scheduler behavior and/or be exposed to the guest
>    userspace.
>
> +``kvm-psci-version``
> +  Set the Power State Coordination Interface (PSCI) firmware ABI version
> +  that KVM provides to the guest. By default KVM will use the newest
> +  version that it knows about (which is PSCI v1.3 in Linux v6.13).
> +
> +  You only need to set this if you want to be able to migrate this
> +  VM to a host machine running an older kernel that does not
> +  recognize the PSCI version that this host's kernel defaults to.
> +
> +  Current valid values are: 0.1, 0.2, 1.0, 1.1, 1.2, and 1.3.
> +
>  TCG VCPU Features
>  =================
>
> diff --git a/target/arm/cpu.c b/target/arm/cpu.c
> index 10f8280eef..60f391651d 100644
> --- a/target/arm/cpu.c
> +++ b/target/arm/cpu.c
> @@ -1144,7 +1144,13 @@ static void arm_cpu_initfn(Object *obj)
>       * picky DTB consumer will also provide a helpful error message.
>       */
>      cpu->dtb_compatible = "qemu,unknown";
> -    cpu->psci_version = QEMU_PSCI_VERSION_0_1; /* By default assume PSCI v0.1 */
> +    if (!kvm_enabled()) {
> +        /* By default KVM will use the newest PSCI version that it knows about.
> +         * This can be changed using the kvm-psci-version property.
> +         * For others assume PSCI v0.1 by default.
> +         */
> +        cpu->psci_version = QEMU_PSCI_VERSION_0_1;
> +    }
>      cpu->kvm_target = QEMU_KVM_ARM_TARGET_NONE;
>
>      if (tcg_enabled() || hvf_enabled()) {
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index ded582e0da..5453460965 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -485,6 +485,28 @@ static void kvm_steal_time_set(Object *obj, bool value, Error **errp)
>      ARM_CPU(obj)->kvm_steal_time = value ? ON_OFF_AUTO_ON : ON_OFF_AUTO_OFF;
>  }
>
> +static char *kvm_get_psci_version(Object *obj, Error **errp)
> +{
> +    ARMCPU *cpu = ARM_CPU(obj);
> +
> +    return g_strdup_printf("%d.%d",
> +                           (int) PSCI_VERSION_MAJOR(cpu->psci_version),
> +                           (int) PSCI_VERSION_MINOR(cpu->psci_version));
> +}
> +
> +static void kvm_set_psci_version(Object *obj, const char *value, Error **errp)
> +{
> +    ARMCPU *cpu = ARM_CPU(obj);
> +    uint16_t maj, min;
> +
> +    if (sscanf(value, "%hd.%hd", &maj, &min) != 2) {

%hd is a signed value, so this will accept "-3.-5" I think ?
Probably we want %hu.

(If you agree I can just make this fix locally, no need for you to respin.)

-- PMM

