Return-Path: <kvm+bounces-70447-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KD4hGdoBhmlhJAQAu9opvQ
	(envelope-from <kvm+bounces-70447-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 15:59:38 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D2DCFF62B
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 15:59:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 8B4363007AC2
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 14:59:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B6A0421A07;
	Fri,  6 Feb 2026 14:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JNz0l3KQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f181.google.com (mail-yw1-f181.google.com [209.85.128.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030403043CE
	for <kvm@vger.kernel.org>; Fri,  6 Feb 2026 14:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770389968; cv=pass; b=ZU8rNwyq7HHLcWThWZLoBID5XD6Jmy+QmRP4QW4KvA7z45O2Wu2W9QQvl/MhpYqxZo25QvxIPGPQD58xlz6wpgV76oW5CrbF0qd/HxIVVJJjT45LYSaZU6mVhM2+OSVwBIjeQK24to9SDYhCOE9oXc3QmEimd9HelkjLLlCRPCk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770389968; c=relaxed/simple;
	bh=Mkat1e2fn8fcmAPT5kCb34RZtRGfdOtY9PSHDy/Ep9g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=F4ty9fYIyuUS/t3P9f2feSCU7oG0mmspejakwxkQ70x+rMO07pKamGNo9CoRETan1ax+w8WhtjpbVqU+8IPD+rM+RH0QsquwxG/aTiKlzdcRYZE0vqWvg03zq633KN+YwEV/LePz35BXId1TWYt2rV2I5huTbatRIp2TC6DUsXU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=JNz0l3KQ; arc=pass smtp.client-ip=209.85.128.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-79456d5ebf9so8758457b3.2
        for <kvm@vger.kernel.org>; Fri, 06 Feb 2026 06:59:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770389967; cv=none;
        d=google.com; s=arc-20240605;
        b=k2mBZtTxaE4UHwdKCvoioPgnXZer3MRokAaemhW7ToYICw/Z3a2MLQuDGLTpI5hBd1
         kTcjZCRsUl3qxBn6nKv2CrWPN9GvdMwvs5Dt0FW7mEwVeRLXFC2aj62/q08L+UC8GX63
         eP4sqA22FUGKqMEo8i0yhcXlKMiEqUkMuJ7JhSdH6zWHZlq7pq/T5xvSbO3L2L5yUHYe
         a9PbLLYV2hT03+RiD4ow6LDpnEDtAf1vjTYyDR42wH+VJyB3ce7AXSdmy/8tjTg6xlRo
         QEp1Jryq68R8FdODpPABZchiUH4C36yn0YrXip33zVpx9uTEteUs/g+QgCDsihwrtNgO
         yYsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Djjd+78eL/gLTndXMnYafFf7JN6pIz42e4sPAJ7o4XM=;
        fh=XdmdWSNSQ3ZD0sHeqgr7COcAV/Z/1wsFOvx6oxSZtAU=;
        b=UfT2W44LFSVXXffaOnQU2v5y1P82oW19PCQAqCF2RDlZmYnry6974mH5E8IPNpXAk7
         BgbTnb7y1PulgDs7WqwsIe7WPOSlIy7WMkvE8SL4pFgR0nz19Hh5PaAPzoR7P+/CG/jr
         ePxnvCwjrPtmy8/nS1q5fLK8E7Qmc5IllnpMDQXFXxQ0UNegxp9wxwu8eyjtRWB+CEI6
         nrphSTGgHrXfykcwCZff2eOA5n89Y15d0wLpM0TTLEhkk8ck11V+udL3QCjHMZ7oQfaQ
         NkXrna4mYz/4SdghhhRX0zd6ghQ/rBJ5lidO2pBNYHSSmhM0DWuWZfZM772w+aS85T9G
         +jcA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1770389967; x=1770994767; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Djjd+78eL/gLTndXMnYafFf7JN6pIz42e4sPAJ7o4XM=;
        b=JNz0l3KQr238VhdWya997xXxH9tPiCcBZ3tvdecT/kDTi6NLY70crav9Qgo4m8A+D/
         3jeSdQTVLrYowj2fffrXY3q8f0afVwnIVnXxkdzfq+fPbw48zScDEQ5dZsrOJNdaZnGR
         Ywky8kChwBJya1ftYD2C8Q0rA2SPsvJZ3ILP66RU+8rk+Qm0ePhqtJPOhUFPetvQ3J1w
         PCNNi8eSo3y69fjL/aROwzvgXsyI0mmK/c91KmnNhdm1pThk+u01adx9JOER1MbhyPdT
         K80PTRskHck6eiaflCPb9vGygfDwIYWPFF94hdHNfvAjO4RQRGyWYT0cHGqaVikJX4z5
         Qo0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770389967; x=1770994767;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Djjd+78eL/gLTndXMnYafFf7JN6pIz42e4sPAJ7o4XM=;
        b=tTOyrTWKM4UBZJ8eAT4i5TB9YoNf35r/7ZJUBvuCOUozfKCLo52NQiMpptii7yV6/a
         EAzpHRhENiImzEcsk92cnYEOayFWGiE28XEWucDJcGX3uDc3KAElvVwdpQTn4bnAfsOQ
         ac2+P2o6+/PrWWkPLfHAHMZM40sMHQz650E/jc8aa4o0GSRyeEWK5wc0glhJC+W7qlla
         iQzufTeE29SpLnrace15J+P+vCZMMNio+zdswSvDZZAwRBbzNWs0h7fQ/SdAYeQ8NgeK
         lvQSwqqZ1NwxPcpJHR5L2Emch/mQe5prf/focoMYCoBS8cOnWBgH8D53U0rZF98/9SO1
         fUoA==
X-Forwarded-Encrypted: i=1; AJvYcCXpUfh5WoeSzV5YXFsgBOpQzzjDVr5uGtI3USQzX+Nu/m+Be6LDOBUxZNSABb0oAtNHRac=@vger.kernel.org
X-Gm-Message-State: AOJu0YxXiddMo9kcOWjXmJBYKCD+S8Dsx69m/IvIQF0L07d9kaus5Hmb
	pg86K21LdfcEom0yBmThs6PF6OksrHQuxmch1POxpRlRKKqu7QpKIJ68CKwu8x0RDJX0Mzszskg
	S9aDmmMgqxqKEtNMXm8hZLA9KFOLrlRSNgcHNYImnng==
X-Gm-Gg: AZuq6aJzEgm1KMIbkwIvv9W5Cgsw69CNySyEHHksbVzYXZDtUQtnRhEzB9o4S1VO5iI
	hAn0Lct7yGTBSL8fu7XDyOMDrC6wur8LjKyK1yLx1IcEYrMAPAwsRar1bSa6osXg1UYBD51uBSI
	BEg64hVsPfxUXxl8Y/4dj+q241Hoe2VGo7GGqh8hEMrqTzNY/85y4IXdcf8Bo6oFPL+swsP3Hbz
	Hh5an8nZwZtOJOsI+CLuHY3inyzZfPlqe7yfP715N6hGC3P+qChbClcf1JHbE3x2TDog17WjXZD
	Wq5X0HRgi3Q53bsR7bVe1AMrOocbwg9d2W2kqvGlVSyO+jhDJP4Sktw=
X-Received: by 2002:a05:690c:88a:b0:796:2976:a452 with SMTP id
 00721157ae682-7962976ac35mr4095557b3.23.1770389966783; Fri, 06 Feb 2026
 06:59:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251202160853.22560-1-sebott@redhat.com> <20251202160853.22560-3-sebott@redhat.com>
In-Reply-To: <20251202160853.22560-3-sebott@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Fri, 6 Feb 2026 14:59:14 +0000
X-Gm-Features: AZwV_QgieJzeeTFJCFpBW88yIXQg35x305xf0x9-4d4AF9icH8OLR1uAx6S_ojM
Message-ID: <CAFEAcA8oi1Xs2kv66dFV9NZore+Q2vHUsgMikveVdN1c+3SBJQ@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] target/arm/kvm: add kvm-psci-version vcpu property
To: Sebastian Ott <sebott@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Eric Auger <eric.auger@redhat.com>, qemu-arm@nongnu.org, 
	qemu-devel@nongnu.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[linaro.org,none];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70447-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[linaro.org:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[peter.maydell@linaro.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.998];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[7];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linaro.org:dkim,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 7D2DCFF62B
X-Rspamd-Action: no action

On Tue, 2 Dec 2025 at 16:09, Sebastian Ott <sebott@redhat.com> wrote:
>
> Provide a kvm specific vcpu property to override the default
> (as of kernel v6.13 that would be PSCI v1.3) PSCI version emulated
> by kvm. Current valid values are: 0.1, 0.2, 1.0, 1.1, 1.2, and 1.3
>
> Note: in order to support PSCI v0.1 we need to drop vcpu
> initialization with KVM_CAP_ARM_PSCI_0_2 in that case.
>
> Signed-off-by: Sebastian Ott <sebott@redhat.com>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> ---
>  docs/system/arm/cpu-features.rst |  5 +++
>  target/arm/cpu.h                 |  6 +++
>  target/arm/kvm.c                 | 64 +++++++++++++++++++++++++++++++-
>  3 files changed, 74 insertions(+), 1 deletion(-)

Hi; this patch seems generally reasonable to me as a way to handle
this kind of "control" register; for more discussion I wrote a
longer email in reply to Eric's series handling other kinds of
migration failure:
https://lore.kernel.org/qemu-devel/CAFEAcA-gi42JObOjLuPudABX8WRdWf5SzSbkzU-bd06ecF1Vog@mail.gmail.com/T/#me03ebff8dbd8f58189cd98c3a21812781693277e

Unless discussion in that thread reveals that we have so many of
this kind of "control" knob that we would prefer a generic
solution rather than per-knob user-friendly names and values,
I'm OK with taking this patch without completely resolving the
design discussion on that other series first.

My review comments below are fairly minor, and patch 1 of
this series has already been applied upstream now.

> diff --git a/docs/system/arm/cpu-features.rst b/docs/system/arm/cpu-features.rst
> index 37d5dfd15b..1d32ce0fee 100644
> --- a/docs/system/arm/cpu-features.rst
> +++ b/docs/system/arm/cpu-features.rst
> @@ -204,6 +204,11 @@ the list of KVM VCPU features and their descriptions.
>    the guest scheduler behavior and/or be exposed to the guest
>    userspace.
>
> +``kvm-psci-version``
> +  Override the default (as of kernel v6.13 that would be PSCI v1.3)
> +  PSCI version emulated by the kernel. Current valid values are:
> +  0.1, 0.2, 1.0, 1.1, 1.2, and 1.3

I think we could be a little more detailed here.


``kvm-psci-version``

  Set the Power State Coordination Interface (PSCI) firmware ABI version
  that KVM provides to the guest. By default KVM will use the newest
  version that it knows about (which is PSCI v1.3 in Linux v6.13).

  You only need to set this if you want to be able to migrate this
  VM to a host machine running an older kernel that does not
  recognize the PSCI version that this host's kernel defaults to.

  Current valid values are: 0.1, 0.2, 1.0, 1.1, 1.2, and 1.3.


> +
>  TCG VCPU Features
>  =================
>
> diff --git a/target/arm/cpu.h b/target/arm/cpu.h
> index 39f2b2e54d..e2b6b587ea 100644
> --- a/target/arm/cpu.h
> +++ b/target/arm/cpu.h
> @@ -1035,6 +1035,12 @@ struct ArchCPU {
>      bool kvm_vtime_dirty;
>      uint64_t kvm_vtime;
>
> +    /*
> +     * Intermediate value used during property parsing.
> +     * Once finalized, the value should be read from psci_version.
> +     */
> +    uint32_t kvm_prop_psci_version;
> +
>      /* KVM steal time */
>      OnOffAuto kvm_steal_time;
>
> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> index 0d57081e69..cf2de87287 100644
> --- a/target/arm/kvm.c
> +++ b/target/arm/kvm.c
> @@ -484,6 +484,49 @@ static void kvm_steal_time_set(Object *obj, bool value, Error **errp)
>      ARM_CPU(obj)->kvm_steal_time = value ? ON_OFF_AUTO_ON : ON_OFF_AUTO_OFF;
>  }
>
> +struct psci_version {

Nit: our coding style says struct type names should be in
CamelCase, and structs should have a typedef rather than
being used as "struct foo".

> +    uint32_t number;
> +    const char *str;
> +};
> +
> +static const struct psci_version psci_versions[] = {
> +    { QEMU_PSCI_VERSION_0_1, "0.1" },
> +    { QEMU_PSCI_VERSION_0_2, "0.2" },
> +    { QEMU_PSCI_VERSION_1_0, "1.0" },
> +    { QEMU_PSCI_VERSION_1_1, "1.1" },
> +    { QEMU_PSCI_VERSION_1_2, "1.2" },
> +    { QEMU_PSCI_VERSION_1_3, "1.3" },
> +    { -1, NULL },
> +};
> +
> +static char *kvm_get_psci_version(Object *obj, Error **errp)
> +{
> +    ARMCPU *cpu = ARM_CPU(obj);
> +    const struct psci_version *ver;
> +
> +    for (ver = psci_versions; ver->number != -1; ver++) {

Using ARRAY_SIZE() to set the loop bound is nicer than requiring
a sentinel value at the end of the array.

> +        if (ver->number == cpu->psci_version)
> +            return g_strdup(ver->str);
> +    }
> +
> +    return g_strdup_printf("Unknown PSCI-version: %x", cpu->psci_version);

Is this ever possible?

> +}
> +
> +static void kvm_set_psci_version(Object *obj, const char *value, Error **errp)
> +{
> +    ARMCPU *cpu = ARM_CPU(obj);
> +    const struct psci_version *ver;
> +
> +    for (ver = psci_versions; ver->number != -1; ver++) {
> +        if (!strcmp(value, ver->str)) {
> +            cpu->kvm_prop_psci_version = ver->number;
> +            return;
> +        }
> +    }
> +
> +    error_setg(errp, "Invalid PSCI-version value");

"PSCI version".

> +}
> +
>  /* KVM VCPU properties should be prefixed with "kvm-". */
>  void kvm_arm_add_vcpu_properties(ARMCPU *cpu)
>  {
> @@ -505,6 +548,12 @@ void kvm_arm_add_vcpu_properties(ARMCPU *cpu)
>                               kvm_steal_time_set);
>      object_property_set_description(obj, "kvm-steal-time",
>                                      "Set off to disable KVM steal time.");
> +
> +    object_property_add_str(obj, "kvm-psci-version", kvm_get_psci_version,
> +                            kvm_set_psci_version);
> +    object_property_set_description(obj, "kvm-psci-version",
> +                                    "Set PSCI version. "
> +                                    "Valid values are 0.1, 0.2, 1.0, 1.1, 1.2, 1.3");
>  }
>
>  bool kvm_arm_pmu_supported(void)
> @@ -1959,7 +2008,12 @@ int kvm_arch_init_vcpu(CPUState *cs)
>      if (cs->start_powered_off) {
>          cpu->kvm_init_features[0] |= 1 << KVM_ARM_VCPU_POWER_OFF;
>      }
> -    if (kvm_check_extension(cs->kvm_state, KVM_CAP_ARM_PSCI_0_2)) {
> +    if (cpu->kvm_prop_psci_version != QEMU_PSCI_VERSION_0_1 &&
> +        kvm_check_extension(cs->kvm_state, KVM_CAP_ARM_PSCI_0_2)) {
> +        /*
> +         * Versions >= v0.2 are backward compatible with v0.2
> +         * omit the feature flag for v0.1 .
> +         */
>          cpu->psci_version = QEMU_PSCI_VERSION_0_2;
>          cpu->kvm_init_features[0] |= 1 << KVM_ARM_VCPU_PSCI_0_2;
>      }
> @@ -1998,6 +2052,14 @@ int kvm_arch_init_vcpu(CPUState *cs)
>          }
>      }
>
> +    if (cpu->kvm_prop_psci_version) {
> +        psciver = cpu->kvm_prop_psci_version;
> +        ret = kvm_set_one_reg(cs, KVM_REG_ARM_PSCI_VERSION, &psciver);
> +        if (ret) {
> +            error_report("PSCI version %"PRIx64" is not supported by KVM", psciver);

Could we make the PSCI version human-readable rather than hex here?
If hex, we need the leading 0x.

We can also suggest to the user the solution to this problem:

  error_report("KVM in this kernel does not support PSCI version 0x%" PRIx64 ");
  error_printf("Consider setting the kvm-psci-version property on the
migration source.\n")

(watch out that error_report() strings end without a trailing \n
but error_printf() ones must have a \n.)

thanks
-- PMM

