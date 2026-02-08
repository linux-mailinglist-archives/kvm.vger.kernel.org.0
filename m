Return-Path: <kvm+bounces-70563-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iKUXBif3iGlqzwQAu9opvQ
	(envelope-from <kvm+bounces-70563-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 08 Feb 2026 21:50:47 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 80BC310A22E
	for <lists+kvm@lfdr.de>; Sun, 08 Feb 2026 21:50:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7D3FB3008E26
	for <lists+kvm@lfdr.de>; Sun,  8 Feb 2026 20:50:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A94D0344020;
	Sun,  8 Feb 2026 20:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4gdkkXai"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84200231C91
	for <kvm@vger.kernel.org>; Sun,  8 Feb 2026 20:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770583832; cv=pass; b=eX5JKNgYg6GJEBieR0xP3XkPdhTOUnz156da7w+E75qhfMC32oJPLnllA++w3hpVnzrTcK9P7qriJZn6mAlwqCteW4JAsEqJYKg+865oPsRCyw+HgxKklrzKmEEO6JlLqMqGLc0I0I6Es1+xRUcVoogpE81wLfiCK1Mf9YbnK1g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770583832; c=relaxed/simple;
	bh=BdXoLV9nT8VxSoY/LcBYREXZlZuw4Hs7QStoAOafXsw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Mm3ZJeO41NHlsf+gCnSs7brnYUwU9iiEIKF7tctqVuKS8LD4+H4JJwv8WxY5U2r7uAl33Wofbzh6nyf7n+NLv9ICdwIg7dEkPOb3lARO0ghnMEAkdnyhNxn5AXtACeRyCD3+MxqaY/9DE1qK4g2B7wQ8eXmg29p4nwVGJ+/87A8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4gdkkXai; arc=pass smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-652fe3bf65aso5460a12.1
        for <kvm@vger.kernel.org>; Sun, 08 Feb 2026 12:50:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770583831; cv=none;
        d=google.com; s=arc-20240605;
        b=kSwTA4JSuC4B/U7ZUvPGICIFP9BTtY1F7r7+Bn4qiUigNPdy6I/NKp1PCXO085Knto
         bM4zz6WnjjD59bOtVbOjeykUiJ6rTjURfNEP5LgqjIVUXBws/m3gUeMdJEvmCZJ347L8
         Cjk6l4rg0ZeTY36SpdmRQ53fqk0mu8vvGVb9d4iIHvta+nBwHg9m7bR/n7FHt5MkBFop
         4aPTI38yXn1eXd8K7ShHAPFQcaYNsOwqiN7AuxtamuBhBKIDl1aEXzTEKlhTwITTlIIO
         6LszV34b8YQ2SiY20ViW8rSkkKjomnvxEA30j/el5uardw+OqDfXtk4fQOWQ5W+AwzuJ
         vJgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xv6IdIAxbF8dyfIQctbjHniwvjI/R5A9CuqD6ISYga8=;
        fh=LLN4ctYaMN0gjrPlZu4LLxUI+DaUXI/RgWRah0w+PMw=;
        b=fM2L/wuzWPUTzDfzN7Blen29eYuHOFtMAze1f3ch8b8ynycrumu39Biy+oDVdxaBSP
         7NqyKXCIwJ0h9Z9kbTaN0PW/JcRkjGtV0BlTEeQc3WKwbl1WfMf/MD5nmshZNrxROgMr
         68RBU/R2RgoT/4wlw+8FmOu2Y+nh+AtB/JSHgdaBuKLy/OSOZfDXwgE7JrmuPPhQRdD8
         CW6nkH++mZgEi7r+vX4r71FdsBXWdzel0YV0x6fvwXwhNDvxmuuWFty8hur+epixvI4k
         yxtEoxWn7r+g0mQ1ZfJaQ32K2bqQu5okhCK2VlgGTSYRZYaZT26rH9y2y++1PntelIiD
         dacQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770583831; x=1771188631; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xv6IdIAxbF8dyfIQctbjHniwvjI/R5A9CuqD6ISYga8=;
        b=4gdkkXaiTuMNlAF0aBz8hMB6H1jIIeWQRwvvYsHcjWenM5uXKwbcuIk7SXzbMT4sof
         pPl7//pYdSXM9PNM9+TwFZk3Sig4qv/NTduiqGllSbvHkjhO8f/K930SEqvKcODVVxFR
         WAcuIBnSKYJOmaMoAF1JAWXAs16MeZ+qKjVZI9n16rq123ELksBoEKpQTrEMsfLnp551
         PWPSOeUayvM2hdKNmXKjQ2dK/rbDV8UWNxOMhOIGLR8jTIAz4uM3qLyl4GIhFPG6thFt
         CfPCxijqGS3NnTn33FzTn92BuHYRCACF/XibYxE1Jojqr7V4MPA8r482f9b+kibTG2S4
         jiuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770583831; x=1771188631;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xv6IdIAxbF8dyfIQctbjHniwvjI/R5A9CuqD6ISYga8=;
        b=Ljd0bVDBerBqs6Q5JGJxnTULI5Yx2L7Yxfz6HnCEIQDdqGgNymtUijTUr5n9CPOGNo
         4RojZDCATQUq1moU59Y1R+Ji2OFaITPFdiOqgINwsJdcEbWUlDG2lNWqku/HxG6hoyv5
         L7BiVa3resf8xmI47zMb4WSc+yMd88Tf/BwK97FbjHqZ8hvfM53ViFmZk0XuHNS8VjIP
         QArDc2J+t4Yek1kBNJJUkuixw8snl57hCd8QEIhUwqP43XWfxj6+7xa3chGlcxPuat3c
         1vx8cJqtSK/xIu+WCYckplzoFvSx2Ys1SkTJaFhVPrfbyHf+LVgI8SxmvCkVc6M4UJfg
         mRFQ==
X-Forwarded-Encrypted: i=1; AJvYcCWr5AgI1SxbNDhXXHr8SZhfH2YAORBUOTefIRucXkmUBSplYdeUkwu83zpGGgNHqk31CgQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyVv1QmLlAAeA8kQELReawYhfiW4ttuxMU8avfkcP3Yp0ebmsg3
	jccJ35E28S/KtcGjyaDmTHO2SQQkT9YspGY1wGg7e0JdnT5i9lquF2zIhRj3GCYjhqRm4giXHjS
	kq0uHwsKclXLDg40ngD/YC9LRqm2zKxYBGjxsUYJE
X-Gm-Gg: AZuq6aL2s8jNY0NaLD35VFG321JZJ61uoq3u8Lwc7vKXxeGLsHPZwMf4h5R1LYINcVW
	grJLiONFGFkHAsGQMJxSmjkUD0nXpARX2ZoEabF1a1MmGJ7sCIej58wfw9sh2bgoJMTRRkmvqVt
	vp01wPvI4Q2KnxLwNcfy4eUPr5tEwY8TWEG/o523HJP6c/WFC5T91A5A4n9E30v6VZ/35B88Ds/
	igH4E8+YdzEL8kffxxznrdar1tU4zLBdvzKYPC7Kxytw/rcMuVRYnGWILxn8OoKGOP5gZU=
X-Received: by 2002:aa7:c348:0:b0:643:e9f:2e5c with SMTP id
 4fb4d7f45d1cf-659a9c16519mr20559a12.9.1770583830553; Sun, 08 Feb 2026
 12:50:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260208164233.30405-1-clopez@suse.de> <20260208182849.GAaYjV4Vh8i0kznTEK@fat_crate.local>
In-Reply-To: <20260208182849.GAaYjV4Vh8i0kznTEK@fat_crate.local>
From: Jim Mattson <jmattson@google.com>
Date: Sun, 8 Feb 2026 12:50:18 -0800
X-Gm-Features: AZwV_QhQ9vcGfRuMVDQtXxydz0Z41Rmy2eXatP0bHxP35ITBwfaVlhEwa4zr1Ts
Message-ID: <CALMp9eQmwsND7whnvVof1i=OsCdo6wcwBWyDRwS3Ud69WkKf-g@mail.gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70563-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-0.998];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,alien8.de:email]
X-Rspamd-Queue-Id: 80BC310A22E
X-Rspamd-Action: no action

On Sun, Feb 8, 2026 at 10:29=E2=80=AFAM Borislav Petkov <bp@alien8.de> wrot=
e:
>
> On Sun, Feb 08, 2026 at 05:42:33PM +0100, Carlos L=C3=B3pez wrote:
> > KVM incorrectly synthesizes TSA_SQ_NO and TSA_L1_NO when running
> > on AMD Family 19h CPUs by using SYNTHESIZED_F(), which unconditionally
> > enables features for KVM-only CPUID leaves (as is the case with
> > CPUID_8000_0021_ECX), regardless of the kernel's synthesis logic in
> > tsa_init(). This is due to the following logic in kvm_cpu_cap_init():
> >
> >     if (leaf < NCAPINTS)
> >         kvm_cpu_caps[leaf] &=3D kernel_cpu_caps[leaf];
> >
> > This can cause an unexpected failure on Family 19h CPUs during SEV-SNP
> > guest setup, when userspace issues SNP_LAUNCH_UPDATE, as setting these
> > bits in the CPUID page on vulnerable CPUs is explicitly rejected by SNP
> > firmware.
> >
> > Switch to SCATTERED_F(), so that the bits are only set if the features
> > have been force-set by the kernel in tsa_init(), or if they are reporte=
d
> > in the raw CPUID.
> >
> > Fixes: 31272abd5974 ("KVM: SVM: Advertise TSA CPUID bits to guests")
> > Signed-off-by: Carlos L=C3=B3pez <clopez@suse.de>
> > ---
> >  arch/x86/kvm/cpuid.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index 88a5426674a1..819c176e02ff 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -1230,8 +1230,8 @@ void kvm_set_cpu_caps(void)
> >       );
> >
> >       kvm_cpu_cap_init(CPUID_8000_0021_ECX,
> > -             SYNTHESIZED_F(TSA_SQ_NO),
> > -             SYNTHESIZED_F(TSA_L1_NO),
>
> Well:
>
> /*
>  * Synthesized Feature - For features that are synthesized into boot_cpu_=
data,
>  * i.e. may not be present in the raw CPUID, but can still be advertised =
to
>  * userspace.  Primarily used for mitigation related feature flags.
>                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>  */
> #define SYNTHESIZED_F(name)
>
> > +             SCATTERED_F(TSA_SQ_NO),
> > +             SCATTERED_F(TSA_L1_NO),
>
> And scattered are of the same type.
>
> Sean, what's the subtle difference here?

SYNTHESIZED_F() sets the bit unconditionally. SCATTERED_F() propagates
the bit (if set) from the host's cpufeature flags.

Using SYNTHESIZED_F() is fine, but it needs to be applied
conditionally. Per AMD's guidance in
https://www.amd.com/content/dam/amd/en/documents/resources/bulletin/technic=
al-guidance-for-mitigating-transient-scheduler-attacks.pdf:

As of the date of this paper, AMD=E2=80=99s analysis has determined that on=
ly
Family 19h CPUs are vulnerable to TSA. AMD CPUs that are older than
Family 19h are not vulnerable to TSA but do not set TSA_L1_NO or
TSA_SQ_NO. Bare-metal software that detects such a CPU should assume
the CPU is not vulnerable to TSA. Hypervisor software should
synthesize the value of the TSA_L1_NO and TSA_SQ_NO CPUID bits on such
platforms so guest software can rely on CPUID to detect if TSA
mitigations are required.

So, the original code should have checked for family and model if
running on bare metal, and should not have synthesized the feature for
Zen3 and Zen4.

However, as Carlos notes, this logic is already present in tsa_init().
Even though unaffected hardware doesn't report the TSA_NO CPUID bits,
tsa_init() sets the corresponding cpufeature flags. Rather than
replicate the tsa_init() logic in kvm, SCATTERED_F() can be used to
propagate the cpufeature flags from the host.


Reviewed-by: Jim Mattson <jmattson@google.com>

