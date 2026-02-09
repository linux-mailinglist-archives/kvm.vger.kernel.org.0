Return-Path: <kvm+bounces-70580-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uRy4AVl1iWlg9gQAu9opvQ
	(envelope-from <kvm+bounces-70580-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 06:49:13 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D71910BD0B
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 06:49:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id ABCAE30028D8
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 05:49:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB7B12FE048;
	Mon,  9 Feb 2026 05:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MITkkkFc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DB237DA66
	for <kvm@vger.kernel.org>; Mon,  9 Feb 2026 05:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770616145; cv=pass; b=XuOIr6JvaRvZHPXGtyxIXdmx47OyPBwsK5FCqrjTgJPso+KTd62ypwMEtM0nATKgy4o7TEIasWIE49H/d+ejpcuRzlfS8Bdb0+BjT2QIlnWNYVaEhysTx5r83g7xo9iyxrC07UNFKGrSpF5NP6tCHSrVOzJt/vaUcG2+mNX6Eyw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770616145; c=relaxed/simple;
	bh=/OruFRyluoMiL/Hd5B6qaDPTidRms/plztDjGUX7CbA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=r/cjul2knNexsJDn39cpu7G9WYNN2cQK1P+SAO13JA/gZWKLR/sGBABGrrfwi+fAH2Lt0GVg+Vz1ivPHYYhnOgok6tGxffmGcPHTPLQ//66TUwb5dj6EyYJCHNhKqcpnxKXys0TD1k8jmHDjttY0E1ztN5F03TBTRw3TGdyZnW0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MITkkkFc; arc=pass smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6581551aa88so7781a12.0
        for <kvm@vger.kernel.org>; Sun, 08 Feb 2026 21:49:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770616144; cv=none;
        d=google.com; s=arc-20240605;
        b=FBNqmMTMOZYnNVtsso8nV89Sgb8/X/eqB3CBeM2Kw7RZRP2KP2Cvuo4910P+MOFCLe
         9oSMq8hixNvHr7UJ6BVCzlWHxY9bnaUboZLWVdph52I33o9VCxWISGSHup63JIPPKYMu
         2AMZBmFe7VAXJkk2ToaCuZDoJppKC348zo4BxAZyYANPxYCnFasLDYGdwx2TWRfWYkYW
         1w34FmCACVfDjC7CIEIBl+ODC8x3HA/20L9UMZnkFpxZSFSonYi4qgDmQmHE3W5iRmiU
         w/aWcoMxt5TO3YQxaLBjNp7AWYFl8aomkwrG2TBxS3oV6f5Hv4FBDpPC6Ig8k3cFmd7Q
         Uj6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dAD2T7++UdaWpYqyoWSszdhEmPVNBTOMnkyU9RJJ+so=;
        fh=7B4uhT+RdtWC5+2BScVrD1PtmkUzJB4RUOM4/P5hKVo=;
        b=RPW/NOAJLZS+rpAEvzLGhZInn6ndIo0pvvCU3bTNfvNX9RNd7hjF5en8s3VIJuvtFe
         Z78TlQV/ZPJAS6wjbmcH9wklNWpKcFXouvwVAlrluFmDfk0aWadivxQZFq0QcrWnbFOh
         +6R6J1ww44Gce0PBogBwvJkDW0/UIJ+SvmP+nxqjIq3O6C+6t5F8IOFj27iPLZSq7RR0
         KulibuSmiiBUArI+C4W/Bfe2qJ5BoapeIiaprImTKvw9WSJi59YgOlb9oQxX2F/BzNic
         LoeuBhDyj7lyuE+s+qtDr/WjnEryqgVPdWwjRd/HSwiVPmv5Is7IoUSxd97qfJzOwQsN
         yqSw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770616144; x=1771220944; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dAD2T7++UdaWpYqyoWSszdhEmPVNBTOMnkyU9RJJ+so=;
        b=MITkkkFc5KblCUNLugyRUNp3R116rQ/9dzU7KK4gAjy3Un2epihvUybfl2A0SxdRAG
         qKY75DUEMfqTp72712gK6UNvdnokEDBM9afZtxjtnDjjp9I9D9ps1RzQaoVcGY6fOeDa
         3vFT27n3BJ9pbaJykK1gn+EKG/M4o0z3K8htqFHrSPd8Z8JM0EG9pNgU7FFy3lqP/gWj
         5hMAZnxaO98q1dibPfYg6Qx+mQjGPI15a8lmz6Sc4fQiyBDVKZYoMPZ0fOWBnE43gvPH
         iloEoyr8+nEZJfjvSm9WjCeg40d1oMiTnixiz4xHVodVzgDpS4Fv8QperLivgN1Y1Ykt
         2frQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770616144; x=1771220944;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dAD2T7++UdaWpYqyoWSszdhEmPVNBTOMnkyU9RJJ+so=;
        b=J1qlaj2gdK1SYIp6RxX+wRUOZIKLf0lnMFQcS1WHBfkfu4SDpxGiB4ulZs8obyGnBn
         w+91tYhLqfYthVFUW2Q7Ey16A+CuAeP5assIE9LR9tgGVzNJFpFIlgzJznN2xt/vK7sZ
         ylziCf0QH5SM8SySk1mhhX4U3HKQu6Kx6EtH4vpwh20HQWsV6RIilVTIjMEhmjryvfBe
         kDzgHYBUXH/aYr//BhQb++u1sAu8osfeFo5s9udrQ0uoJ0IXYZlnt9E2EBA0k4MTVBwf
         2w7KRxqpDNO+WyLJlPrWZQUp++5Lt6iv9P7RTC8vVlG1w43WD7GQHknmTPJ8DzlBX6m5
         ANdA==
X-Forwarded-Encrypted: i=1; AJvYcCUM+QQzksMwYA3hDQ0Ata3Yzza1Hz6E26r9QH364cKoKDfogOk/gl1gdHAukhWdypRAv4Y=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6/tQhkJFSTZoCyyEqBlVehzdIeGQV4Ssx0hwCK8NyRk7f8rhq
	jGpIqtqclZ5KWdsMejRODGYBg1nG2dOC9KIQalIZsFRhsqeOX2tzowHJlaHNnt4riaaGTQyDgH0
	kC2fGjyPYFMy+/QnPx8h0wjLX9F6NQPoI0pnDgoZg
X-Gm-Gg: AZuq6aIA2yfX9AFpJieGkqpbeu3GYadfSXCXdQHKypIEDoAprOjMtS/yf7hZ356Y4LW
	kAFmZHgKyPhFxNTp/X49kZuxHx4a/yxMAjuvTVsDnpmRdCod14tVVx9iGfxq/NVDw8BOnH1rVD2
	mGETX6i3xgE0CM0G+O2aCtilUn3YJ/ZWYmrr7jjwVRYoOsR7sbbRkxYZz6wdWNkafbc2ib2u0hu
	CHFGhqBy9eZeDihkd6HRocj617eO/H1CfOSxvNNde0+cEWq2fky8tv+WpGV9LgXk216Lso=
X-Received: by 2002:aa7:c348:0:b0:643:e9f:2e5c with SMTP id
 4fb4d7f45d1cf-659a9c16519mr26699a12.9.1770616143641; Sun, 08 Feb 2026
 21:49:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260208164233.30405-1-clopez@suse.de> <20260208182849.GAaYjV4Vh8i0kznTEK@fat_crate.local>
 <CALMp9eQmwsND7whnvVof1i=OsCdo6wcwBWyDRwS3Ud69WkKf-g@mail.gmail.com> <20260208211342.GBaYj8hhtYM-lYfq-X@fat_crate.local>
In-Reply-To: <20260208211342.GBaYj8hhtYM-lYfq-X@fat_crate.local>
From: Jim Mattson <jmattson@google.com>
Date: Sun, 8 Feb 2026 21:48:51 -0800
X-Gm-Features: AZwV_QgaUpyuBuM3WiusX4ivGp7COUI8odd0grmHsJBOX5oTmLS_pVJxMMdlH00
Message-ID: <CALMp9eSVB=iRec2A0tmRzkTBa9zz4BVS8Lu79vUuRPrTawYFcQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: synthesize TSA CPUID bits via SCATTERED_F()
To: Borislav Petkov <bp@alien8.de>
Cc: =?UTF-8?Q?Carlos_L=C3=B3pez?= <clopez@suse.de>, seanjc@google.com, 
	kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, 
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, 
	"open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <linux-kernel@vger.kernel.org>, Babu Moger <bmoger@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70580-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 1D71910BD0B
X-Rspamd-Action: no action

On Sun, Feb 8, 2026 at 1:14=E2=80=AFPM Borislav Petkov <bp@alien8.de> wrote=
:
>
> On Sun, Feb 08, 2026 at 12:50:18PM -0800, Jim Mattson wrote:
> > > /*
> > >  * Synthesized Feature - For features that are synthesized into boot_=
cpu_data,
> > >  * i.e. may not be present in the raw CPUID, but can still be adverti=
sed to
> > >  * userspace.  Primarily used for mitigation related feature flags.
> > >                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > >  */
> > > #define SYNTHESIZED_F(name)
> > >
> > > > +             SCATTERED_F(TSA_SQ_NO),
> > > > +             SCATTERED_F(TSA_L1_NO),
> > >
> > > And scattered are of the same type.
> > >
> > > Sean, what's the subtle difference here?
> >
> > SYNTHESIZED_F() sets the bit unconditionally. SCATTERED_F() propagates
> > the bit (if set) from the host's cpufeature flags.
>
> Yah, and I was hinting at the scarce documentation.
>
> SYNTHESIZED_F() is "Primarily used for mitigation related feature flags."
> SCATTERED_F() is "For features that are scattered by cpufeatures.h."

Ugh. I have to rescind my Reviewed-by. IIUC, SCATTERED_F() implies a
logical and with hardware CPUID, which means that the current proposal
will never set the ITS_NO bits.

I clearly don't have any idea how the new infrastructure works, and
there's too much CPP nonsense for me to care. I'll just defer to Sean.

> And frankly, I don't understand why there needs to be a difference whethe=
r the
> feature is scattered or synthesized. If the flag is set on baremetal, the=
n it
> is and it being set, denotes what it means. And if it is not set, then it
> means the absence of that feature.
>
> It is that simple.
>
> Then it becomes a decision of the hypervisor whether to expose it to the =
guest
> or not.
>
> Not whether it is synthesized or scattered.
>
> But maybe I'm missing an aspect which is important for virt...
>
> --
> Regards/Gruss,
>     Boris.
>
> https://people.kernel.org/tglx/notes-about-netiquette

