Return-Path: <kvm+bounces-3762-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B6C92807912
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 20:59:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6D7A228219B
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 19:59:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D8CF6E2DC;
	Wed,  6 Dec 2023 19:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZBGqcGZb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E92E2FA;
	Wed,  6 Dec 2023 11:59:07 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id 2adb3069b0e04-50bfd3a5b54so201162e87.3;
        Wed, 06 Dec 2023 11:59:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701892746; x=1702497546; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y3MVaLAQQ+8IH1t0woX8XXUKr5UkxZE7+TDCaXdlmH8=;
        b=ZBGqcGZbHIZxjuU4F9cm4eNEBrFykJjAapqrwOKzzNW3/SZzK78F3/5VsVzei1P6RU
         wcq9a/CqqWtBJLzIl4tD3h7gUDoGqQx+VOIKjO4y3H3M5uZ5jqjheiunP0KTHHiaHacT
         wnNzLKggUj7zv5cMuwlf6SEPRyFhQvB5evDMepCz0G/jaHTgnJXz04fgGm9GyqIEIH0F
         ZVikEn1iiAjtmnM1YP5+yz2D9PKtNe3hINBerHh3kHrdSGqF/215Khp7nmB5TNSZvCJs
         HrzKbtcW18HanV36jcwXBT3wq/iW9+2JxzlY+z9oxDdA7b1b/xFs+4YGTs7Zq2XqWguv
         pQPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701892746; x=1702497546;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y3MVaLAQQ+8IH1t0woX8XXUKr5UkxZE7+TDCaXdlmH8=;
        b=aL+moYpFZXU34LDhzvy7akMYTyIL+iXMbpIYXL6dKDYmD5NQkU0dm9MG9APt43Pv9B
         eS8osdLGzhGvddOn/jJPUOTyv50T4bs902wu9kA9CTquTiHsuipqsaflf2aoCnymfgCj
         ku4Ef4RtOrQkLjdolmi/k28mewMKHF9UmahbZKh52MUguZhfZtCuDlEmYBDo/xC/QET7
         SeAHMFkdN5W1wKPMntnKhyivyTLuwcbOH9YN2weQlYGuLpC5IcwEr4AYxmGzChjvQVIX
         fX4+AWd3aG67/VI6WYTmhfK5TUd8GudziXSrqJ5JwYzXHRUGlbc7F+5M2SVKIwIBKLTu
         eW5w==
X-Gm-Message-State: AOJu0Yy3uqLolAE1eZnF7dYtKb+TeUMgZIPLYEAoTKsrA1ug7eQIIXqc
	ILeT3H5B/K/jBXf35HXJPWZDqNQRfWQfcseggw==
X-Google-Smtp-Source: AGHT+IGSVyhk5VpdTSmdKP6ivPsMkGJooS9Dbr4Wp/iKBXDLx1h1VzpZYwbgyo3XsO8rZ2GE63oX9rjlDQtd+FQguRU=
X-Received: by 2002:a05:6512:158e:b0:50c:6b:f180 with SMTP id
 bp14-20020a056512158e00b0050c006bf180mr812498lfb.56.1701892745640; Wed, 06
 Dec 2023 11:59:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231205105030.8698-1-xin3.li@intel.com> <20231205105030.8698-27-xin3.li@intel.com>
 <f260ddf9-be67-48e0-8121-6f58d46f7978@citrix.com> <SA1PR11MB67343544B0CEB6C82002790DA884A@SA1PR11MB6734.namprd11.prod.outlook.com>
 <4e41b658-f49e-424c-8a86-08c8ab8e384d@citrix.com> <SA1PR11MB673472A25E72022F68882869A884A@SA1PR11MB6734.namprd11.prod.outlook.com>
In-Reply-To: <SA1PR11MB673472A25E72022F68882869A884A@SA1PR11MB6734.namprd11.prod.outlook.com>
From: Brian Gerst <brgerst@gmail.com>
Date: Wed, 6 Dec 2023 14:58:54 -0500
Message-ID: <CAMzpN2h8yAk8Q0XwWWhBO3LcnwkNH57JOzTqamoNRXs-E3GJnw@mail.gmail.com>
Subject: Re: [PATCH v13 26/35] x86/fred: FRED entry/exit and dispatch code
To: "Li, Xin3" <xin3.li@intel.com>
Cc: "andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>, 
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>, 
	"linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>, "tglx@linutronix.de" <tglx@linutronix.de>, 
	"mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"hpa@zytor.com" <hpa@zytor.com>, "Lutomirski, Andy" <luto@kernel.org>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>, 
	"peterz@infradead.org" <peterz@infradead.org>, "Gross, Jurgen" <jgross@suse.com>, 
	"Shankar, Ravi V" <ravi.v.shankar@intel.com>, "mhiramat@kernel.org" <mhiramat@kernel.org>, 
	"jiangshanlai@gmail.com" <jiangshanlai@gmail.com>, "nik.borisov@suse.com" <nik.borisov@suse.com>, 
	"Kang, Shan" <shan.kang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 6, 2023 at 2:19=E2=80=AFPM Li, Xin3 <xin3.li@intel.com> wrote:
>
> > >>> + case X86_TRAP_OF:
> > >>> +         exc_overflow(regs);
> > >>> +         return;
> > >>> +
> > >>> + /* INT3 */
> > >>> + case X86_TRAP_BP:
> > >>> +         exc_int3(regs);
> > >>> +         return;
> > >> ... neither OF nor BP will ever enter fred_intx() because they're
> > >> type SWEXC not SWINT.
> > > Per FRED spec 5.0, section 7.3 Software Interrupts and Related Instru=
ctions:
> > > INT n (opcode CD followed by an immediate byte): There are 256 such
> > > software interrupt instructions, one for each value n of the immediat=
e
> > > byte (0=E2=80=93255).
> > >
> > > And appendix B Event Stack Levels:
> > > If the event is an execution of INT n (opcode CD n for 8-bit value n)=
,
> > > the event stack level is 0. The event type is 4 (software interrupt)
> > > and the vector is n.
> > >
> > > So int $0x4 and int $0x3 (use asm(".byte 0xCD, 0x03")) get here.
> > >
> > > But into (0xCE) and int3 (0xCC) do use event type SWEXC.
> > >
> > > BTW, into is NOT allowed in 64-bit mode but "int $0x4" is allowed.
> >
> > There is certainly fun to be had with CD 03 and CD 04 byte patterns, bu=
t if you
> > meant to mean those here, then the comments are wrong.
> >
> > Vectors 3 and 4 are installed with DPL3 because that is necessary to ma=
ke CC and
> > CE function in userspace.  It also suggests that the SWINT vs SWEXC dis=
tinction
> > was retrofitted to architecture after the 286, because exceptions don't=
 check DPL
> > and ICEBP delivers #DB from userspace even when Vector 1 has a DPL of 0=
.
> >
> > While CC is for most cases indistinguishable from CD 03, CE behaves ent=
irely
> > differently to CD 04.  CD 04 doesn't #UD in 64bit mode, and will trigge=
r
> > exc_overflow() irrespective of the state of EFLAGS.OF.
> >
> >
> > The SDM goes out of it's way to say not to use the CD 03 byte pattern (=
and it
> > does take effort to emit this byte pattern - e.g. GAS will silently tra=
nslate "int $3"
> > to "int3"), and there's no plausible way software is using CD 04 in pla=
ce of CE.
> >
> > So why do we care about containing to make mistakes of the IDT era work=
 in a
> > FRED world?
>
> First, I agree with you because it makes things simple and neat.
>
> However, the latest SDM and FRED spec 5.0 both doesn't disallow it, so it
> becomes an OS implementation choice.
>
> >
> > Is there anything (other than perhaps the selftests) which would even n=
otice?
>
> I'm just conservative :)
>
> If a user app can do it with IDT, we should still allow it when FRED is
> enabled.  But if all key stakeholders don't care whatever gets broken
> due to the change and agree to change it.

One case to consider is Windows software running under Wine.
Anti-tampering code has been known to do some non-standard things,
like using ICEBP or using SYSCALL directly instead of through system
DLLs.  Keeping the status quo should be preferred, especially if
Microsoft does the same.


Brian Gerst

