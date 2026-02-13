Return-Path: <kvm+bounces-71059-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IN0aEH1Gj2kiPAEAu9opvQ
	(envelope-from <kvm+bounces-71059-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 16:42:53 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id D7166137A24
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 16:42:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 42A1A300C307
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 15:42:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30FF33624B5;
	Fri, 13 Feb 2026 15:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xKdTKfuP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10B9135CBAE
	for <kvm@vger.kernel.org>; Fri, 13 Feb 2026 15:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770997369; cv=pass; b=N8skzjuxkUw9s7/6Oh4CsaTpqQ5UTa4einWOe55cL+It1mkuJbSe9hDJ/QQen9KgK3JOw1MbWOafz/eKKYWVNVFSh8x23RAOyvCxuj3gICZb5q1BowBe50P76ve2pkNJAcfGpsCaK6eYhJuyiFWGklj8QgoFQCJZqbXodSUFi5Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770997369; c=relaxed/simple;
	bh=yTciUytAK+hm8aYrDirHamJvdZ4HmQPGUu+cgm745nU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GHusBt3cQ/c257W1zQsCzXFFONZ7oJtjXv9rCXGS9pXb9NjyaZ7tUTb5+BpOt1fTL1++Tx4LUMWBASja2KVZKIaZ2zMhTKausLe39zViC2bgUcXQhQ+MjFfwV2Z1mvJgolxxH5AxyguHQtVGX6S17s3hDnfdB/3t2zKRVn2HbYY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xKdTKfuP; arc=pass smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-65a38c42037so9646a12.0
        for <kvm@vger.kernel.org>; Fri, 13 Feb 2026 07:42:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770997366; cv=none;
        d=google.com; s=arc-20240605;
        b=dKQCu2Z6B/TVcArw6CUD+BXk0IbUUJuTdaQPc84SXezjXVljNKfQEQwUtu9QSYyj1G
         pN3XXgSJ05GRb5sTW/649fPlo3AqUN3G3Qmgk/ZA4UD2flidRwrwo/tGEL2D+t3xJpsV
         tDU0QGyQPI5sr8Hu1/15WX0ofd1FI7wC/YBRNddG3/lBqhThMIzVjNPn6mPZ/+NMug98
         r3dwCwW+VNqTIhpjNjkhNjg4pNJP+6kbCzMQOz5kMNR+Sa416otXnwh9kXZzLw8hIPcc
         j1LCwN0EDPdAPO4nl1hCeNGVHV9YNDBJkRoAlbivCtRSLvpmsEZIz4OjTnx9w901Upc3
         eu5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=F6ij2Khc2FsAsz+xr+2WTDdi0WC0Pp/qGOQOsuaJCEw=;
        fh=mIEdoZ688ox1Wz8udOgoI+y+VdPs7tWEcfENH94/XSA=;
        b=C9/5FK1Jnkw+8l0mW2OZ1B/NChraNek9RePEDuY3RCnKAtV0GGnvuYPiR7hHS1HzW8
         5V7URvkOWOctF5SoGlDi3rjGl5a4HSOgIOqSPwmkgYtMkB/22g/kiuzltLUgOx7rk/uH
         5xzzcIry1MnXfZk9uhvK5ln11gs4LnnzsXXi0KNQzRIn2dQxw/ltNOXmB/2h6vKazX34
         EYGedWt/6HftfrN6LikALC6nAl8nnH1Bds1JjwXD75Yl3SoyngF/qxTNhPI8Q1hX/45B
         AdYzSadzpydrBD7qodyH8SFmVgmSnsYM76MMmlEHJoJUbaaPKD4nIjjCbFLMYEiFBcMK
         OIWw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770997366; x=1771602166; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F6ij2Khc2FsAsz+xr+2WTDdi0WC0Pp/qGOQOsuaJCEw=;
        b=xKdTKfuPWSdO0a6dr+GgarlKSaC/BjjZUVPFfnx02xQZOtTMYDpdSA1mI+LxZyW0AO
         grkybGdSYQMprLiK7QlbZTxuyLifyOxdAkzpZ3F0izh5K2FV4YmmsA18nevzZVLO2at7
         B077NqI7Za1f5bizp5wAPoa8xi1ayJ1Bo0+SPbwN9JOS2JVlX+BJ/hWUiXSXWUqd+8xN
         TyxCYuYuVIfhEmRN/1AIWdkuaPMRvBk8dFzphp4ESNhGPT/LMDSK+kKJ7u9+/SyggGgV
         tkT01BGGHWutAaO6cnNlqTgF9gGY/FeQ2yMd/CS5hoK6yKa2yAliaE5zPFWaERpmWxlL
         MvUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770997366; x=1771602166;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=F6ij2Khc2FsAsz+xr+2WTDdi0WC0Pp/qGOQOsuaJCEw=;
        b=S74zcD/PMKty+SRipZdhnLI166UYwNVIyUMWCvAZJ0un+YjdCK59uHXvK8fGyDjPlt
         1W+iSZfGFHWELmUlsI7kU3CmzWJDwWLas84j8Oji6+x9HWdDdWVD1gXQwEAZvCS0exnA
         lY5qowENdm+YNOgWn2HNOQrl8m3dQkavtKWggxf/vH+HdJP204ZE+qANSPNAXMhLiCNs
         1bSD+p7HFFfZV4PmiiXphCSbaXR6AKIfOhdrNIwgoaNZyB6rrcWnL5Y1BH9TvKNRLEXh
         UUc0MA9MyQv9G9/iJoBSoMCXrSFxrzK5l4JlHiKMvkvnyfGBhXShLCAWovvG7aWWxnPy
         H6Fw==
X-Forwarded-Encrypted: i=1; AJvYcCUsWrtLcnD8V32dYPdG2e9iwds4hkb//T8XoPtjtj7IEGZYC8vfXEpf4Zs3GhsWJC53x48=@vger.kernel.org
X-Gm-Message-State: AOJu0YzGHHN6+RAozmYOJaC1Gukb0LQwH56kcV7kLjd67iI3JOIhkIKb
	ZLCud4Lu5CzXYn0WF9aGbsuNTesjMwLuBifIUM4mQoNQNT8vw5CTS+iRo6omqD50P9SyZrgFDhM
	PiAlM/fStF2D/LtUPaIp6ZNvZ8bU9L3BXypcleFFNtOu7NzNiDVT8gsK4
X-Gm-Gg: AZuq6aJo374pj2SH8cc1FcAeOBn4TjbKkNd10JiU7q7J1phlx1IPSQqG/9cJbOWJBRm
	0gd+5Nwh5EdHsCEPOfH0yWvGc3N4Coih8j2u95Je0MN3OsrQSUZbFZAgds1GqyRpT8pBaKoSaCT
	dXxddkin5HgcydVqzwQ7GWSzpcaD1sOv7INc01YHZ7diumKieLLrI8ZZAwqWWkrsivljOi7H5bE
	mxjbzUcX1uDVojMtaqLzkFMqeYfaahOlqYQ3aalG+xmTC9k0dRhwdQeOJI9HKxQFAFwZBTB07tS
	Ogu8DTo1TUuWXqglYg==
X-Received: by 2002:aa7:df8a:0:b0:658:102c:861c with SMTP id
 4fb4d7f45d1cf-65bb078c0f4mr25011a12.15.1770997365892; Fri, 13 Feb 2026
 07:42:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260212155905.3448571-1-jmattson@google.com> <20260212155905.3448571-5-jmattson@google.com>
 <gqj4y6awen5dfxy32lbskcxw6xdv4xiiouycyftjacndjinhvp@7p4dtgdh6tjw> <aY9BPKhzgxo4UuHB@google.com>
In-Reply-To: <aY9BPKhzgxo4UuHB@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Fri, 13 Feb 2026 07:42:33 -0800
X-Gm-Features: AZwV_Qh8Zc-8b-6vcrm4uFHajKL5tBq0Tt20KrHYUCJPUVjtrEQVTeUjqt4aD1w
Message-ID: <CALMp9eR4ayj_gwsDQVH8pQvzqgEYVB6ExWp3aFgJXRWikLEikw@mail.gmail.com>
Subject: Re: [PATCH v4 4/8] KVM: x86: nSVM: Redirect IA32_PAT accesses to
 either hPAT or gPAT
To: Sean Christopherson <seanjc@google.com>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	RCPT_COUNT_TWELVE(0.00)[13];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71059-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	DKIM_TRACE(0.00)[google.com:+]
X-Rspamd-Queue-Id: D7166137A24
X-Rspamd-Action: no action

On Fri, Feb 13, 2026 at 7:20=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> Please trim your replies.  Scrolling through 100+ lines of quoted text to=
 find
> the ~12 lines of context that actually matter is annoying.
>
> On Fri, Feb 13, 2026, Yosry Ahmed wrote:
> > On Thu, Feb 12, 2026 at 07:58:52AM -0800, Jim Mattson wrote:
> > > diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> > > index a49c48459e0b..88549705133f 100644
> > > --- a/arch/x86/kvm/svm/svm.h
> > > +++ b/arch/x86/kvm/svm/svm.h
> > > @@ -607,6 +607,22 @@ static inline bool nested_npt_enabled(struct vcp=
u_svm *svm)
> > >     return svm->nested.ctl.misc_ctl & SVM_MISC_ENABLE_NP;
> > >  }
> > >
> > > +static inline void svm_set_gpat(struct vcpu_svm *svm, u64 data)
> > > +{
> > > +   svm->nested.save.g_pat =3D data;
> > > +   vmcb_set_gpat(svm->nested.vmcb02.ptr, data);
> > > +}
> > > +
> > > +static inline void svm_set_hpat(struct vcpu_svm *svm, u64 data)
> > > +{
> > > +   svm->vcpu.arch.pat =3D data;
> > > +   if (npt_enabled) {
>
> Peeking at the future patches, if we make this:
>
>         if (!npt_enabled)
>                 return;
>
> then we can end up with this:
>
>         if (npt_enabled)
>                 return;
>
>         vmcb_set_gpat(svm->vmcb01.ptr, data);
>         if (is_guest_mode(&svm->vcpu) && !nested_npt_enabled(svm))
>                 vmcb_set_gpat(svm->nested.vmcb02.ptr, data);
>
>         if (svm->nested.legacy_gpat_semantics)
>                 svm_set_l2_pat(svm, data);
>
> Because legacy_gpat_semantics can only be true if npt_enabled is true.  W=
ithout
> that guard, KVM _looks_ buggy because it's setting gpat in the VMCB even =
when
> it shouldn't exist.
>
> Actually, calling svm_set_l2_pat() when !is_guest_mode() is wrong too, no=
?  E.g.
> shouldn't we end up with this?

Sigh. legacy_gpat_semantics is supposed to be set only when
is_guest_mode() and nested_npt_enabled(). I forgot about back-to-back
invocations of KVM_SET_NESTED_STATE. Are there other ways of leaving
guest mode or disabling nested NPT before the next KVM_RUN?

>   static inline void svm_set_l1_pat(struct vcpu_svm *svm, u64 data)
>   {
>         svm->vcpu.arch.pat =3D data;
>
>         if (npt_enabled)
>                 return;
>
>         vmcb_set_gpat(svm->vmcb01.ptr, data);
>
>         if (is_guest_mode(&svm->vcpu)) {
>                 if (svm->nested.legacy_gpat_semantics)
>                         svm_set_l2_pat(svm, data);
>                 else if (!nested_npt_enabled(svm))
>                         vmcb_set_gpat(svm->nested.vmcb02.ptr, data);
>         }
>   }
>
>
> > > +           vmcb_set_gpat(svm->vmcb01.ptr, data);
> > > +           if (is_guest_mode(&svm->vcpu) && !nested_npt_enabled(svm)=
)
> > > +                   vmcb_set_gpat(svm->nested.vmcb02.ptr, data);
> > > +   }
> > > +}
> >
> > Is it me, or is it a bit confusing that svm_set_gpat() sets L2's gPAT
> > not L1's, and svm_set_hpat() calls vmcb_set_gpat()?
>
> It's not just you.  I don't find it confusing per se, more that it's real=
ly
> subtle.
>
> > "gpat" means different things in the context of the VMCB or otherwise,
> > which kinda makes sense but is also not super clear. Maybe
> > svm_set_l1_gpat() and svm_set_l2_gpat() is more clear?
>
> I think just svm_set_l1_pat() and svm_set_l2_pat(), because gpat straight=
 up
> doesn't exist when NPT is disabled/unsupported.

My intention was that "gpat" and "hpat" were from the perspective of the vC=
PU.

I dislike svm_set_l1_pat() and svm_set_l2_pat(). As you point out
above, there is no independent L2 PAT when nested NPT is disabled. I
think that's less obvious than the fact that there is no gPAT from the
vCPU's perspective. My preference is to follow the APM terminology
when possible. Making up our own terms just leads to confusion.

