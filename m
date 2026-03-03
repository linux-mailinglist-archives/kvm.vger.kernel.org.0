Return-Path: <kvm+bounces-72617-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cNcOIl1gp2lvhAAAu9opvQ
	(envelope-from <kvm+bounces-72617-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 23:27:41 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D1351F7F85
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 23:27:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 9285E302FAB8
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2026 22:27:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 911F93976A4;
	Tue,  3 Mar 2026 22:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IAIBucTt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2CA4372676
	for <kvm@vger.kernel.org>; Tue,  3 Mar 2026 22:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772576849; cv=pass; b=r811RFH7LdZ14NWfdzdq13RKRvvp2u7uTvQiURnE55E1i/LyCRXG1NoLwOnzII1B1OlY3VoYBKHoT7kb8e89TXrwbIUCO7crEgAN7LM1L2YH5/FBZStVJ5YO9bGrASCpWcGvESblQhiRYBq2w0blpH0Qxjfo4qKGYHHcB8Hh8PU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772576849; c=relaxed/simple;
	bh=wXg82s/62YITcslZTbclR9gGihZ7cjW5da1lN9R6Ij0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=G2zwuBbB8A+SkDl66ahr8yvCMvO35rAKB0oxLtqW9U+uRTF51KTtMM9Zx1NzK+0Gm0I3EwopZ6TarjpZqW9jfo8wyypkl9IpPPPAs9CcYniWDfWw05M9BwGgP5GlWs+z29OFcDii1Her4eP4wtzQkwBMg2gW0HvCoV4zMnZQFFg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IAIBucTt; arc=pass smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-89a133cdd4aso8621436d6.0
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2026 14:27:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772576847; cv=none;
        d=google.com; s=arc-20240605;
        b=UN8GFPcTC0caLLOSCx3Rya71qo6QaNrywZ6w8Izh8dQCewiOL8p1QLm+8rDiBzMj/k
         weEgMo1bs/REyNagDz4cdXIeqcsYATDm1HkmEnaq5ogZgafufUw6CwjZwTuCTs6TydXL
         0JPdCBNBSUlvIqsqFMRwzUONNTY5KP3BdVj6JqZxhWyzsQ71hq1+IkSdAHrc4q7EWoEN
         jj1eoYKx+J0GInI5YZFFoJQO/ziOZ9RpTi1pygJ0/3KwfgVn+BnRBk4LlUNi1ffqD9u1
         qt4uKdUn3tWhWDb0824bc86u2SPFxgQ2oQ24a0iAvny7YxMASUuDlXNQbmmMwpRpunDt
         4xLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=aRIXWn5zDUNh/DYGw083sC3O8lYkopiiVcJfNRVEFFA=;
        fh=5ghRO9I1Bgm7m7qHJpdJLVMFBYeNR/BGsCQRRMoaeio=;
        b=U+6Rb13htlqZL7EgCRdCQHtopkx+nwKFunSnqVbR+dLjbpBSoG1xxPuyqywVfWK+A7
         lDAw6COJYe9Pd0IC1iABnQpwUsS6jZKztFBcPoe+x1O8IvtIFnNA/3XuVYm+PAG8wEry
         9gqgmKpaBkhnXvMghEpBr2skCmE+kDiUyTzXPHjbKmBWZ0OTw3sM+G7Dv64fWCL1sv/Y
         Y3YAlYGqvJTNJv/AT3+Q0HV7NgodKv7JJMSwEf9VgqJmoZIYQcAGypkJrUOKZDjlDPHe
         zc5QST5aAHq8jpCQ9t4WbUrGlnL1AN662FPDbvODH76QP5/CE1O2frxSlfblN/v3nja4
         dztg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772576847; x=1773181647; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aRIXWn5zDUNh/DYGw083sC3O8lYkopiiVcJfNRVEFFA=;
        b=IAIBucTtOHVcdndxU246B5g9vYECC0+diugDqp/MPaIs1DQ4qRTDTJPYB36+UpNSAx
         FVcp1PLTU7R4d3rKe+2HisdksyRRFEqxATlwsxnIV3IbmGrcR1c9E66S+5nHmJ3ApveA
         9xej1zRNEPPlNj3H3KPBvDnMgKkoRTXXg4A90skfzRZr+L783iVQyndploduuiqwGBxs
         9VIQVlH/UirZU5Sve8XT1fNTYcqXhzY2k2AYim5u2xAjLnPihIVXdMsb06IWSkLci6XB
         W7d13Ratld1p1HXsjJjJxOV8HFBD8kX+H+b+MSiq21LGuxKpxfKdW9iB6cz+51V2KXwk
         Ne0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772576847; x=1773181647;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aRIXWn5zDUNh/DYGw083sC3O8lYkopiiVcJfNRVEFFA=;
        b=eh1TQVYmsuOt0sQe8X0XrP9P+yysCUMJgTBysmrQr1KTC6LUxvW2qv30LhsRnhimw5
         kPVT4Qb3jPHhQLfOz/flsG1C7SciggaiIJf6ChB+CNlGlPudyA4skaciBkfutt0AXWiX
         npif83KowlBdCZALtX0yezBPnF93VHtnN1Bc+Ocs5NAuSXfOLRfn3MrImWbGYnLy96QR
         dKSczkqjgqER/EBCLT5d7Zijx80i9XnqFU8hb3ZqD4hDlDCpQf2GO23NlqmKW9kIuqfo
         9xPD6LJoF1/0Aain1YE4dgDCNm6bjL7Q2hRFWNKhWHM1xb9OCJ6rBKW6R3qwMOiPu4dt
         fB6w==
X-Forwarded-Encrypted: i=1; AJvYcCU1Ja7hcY8lLO1lvUysHDWWXqFFK9Fq2ijabz+INFsKRwSezcJnu/w6oF13PL3pwqmrVH0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwwrOYiVlK9KBaKKVG3P603UGV7UPJGuQaCe0k5/9lVN9VntCZD
	V5VBpVfQBA3SSOexbYoLulZR4td/+b5w5hzJnrsEAH79YAH/e0zANb6+PiPkN2t7tua/Bnoiv09
	5HLDR4BerZJ+nakRRt2Yz8oEcOMD59Abo5Ns83vN1
X-Gm-Gg: ATEYQzxBuQt1SXPF22A+eKV0l9Coo0iwYOx25gJWpmPc2HQODCsBVNSX+0gXhh40Qro
	uFCscwVyfAbtoF6quqJfeyGA7mc8MEh3aJwoBCGdeKAo/cRzrOdBGBbHlRCLm0IuA+ZpBU/9Qua
	iv4wlIcT89cWUFkfS0bt6QN/2cpLjOTbr/bfIiLm7DQppxWFeAbH2AYJGdij1UeZPiWKr37NDR9
	R5CLH7G+22f3bwGiEInYN7JzVKBqwllRID2B2HA3SKCVSTaBUdmBhTTMdjF8PUhZxOMYr/s5fvd
	ShJ/PiG/otWBsTGH3czbULCDZ8GHFBjruhwxLKgh+A==
X-Received: by 2002:a05:6214:246f:b0:89a:110f:894d with SMTP id
 6a1803df08f44-89a110f8d74mr39808496d6.30.1772576846999; Tue, 03 Mar 2026
 14:27:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260228033328.2285047-1-chengkev@google.com> <CAO9r8zODn_ZGHsftsj0B6dJe9jy8sVZwdOgFi=ebZoHfGrWxXw@mail.gmail.com>
 <aaXXs4ubgmxf_E1O@google.com> <aaYanA9WBSZWjQ8Y@google.com>
 <aaYssiNf7YrprstZ@google.com> <CAE6NW_YTqbMZgq1nEiO6XsuQPZsKd9_0DseFDStocrh-sB1TBw@mail.gmail.com>
 <aadb-JQdbQJNvm0o@google.com>
In-Reply-To: <aadb-JQdbQJNvm0o@google.com>
From: Kevin Cheng <chengkev@google.com>
Date: Tue, 3 Mar 2026 17:27:15 -0500
X-Gm-Features: AaiRm53cSA7fFwG8hZWHVI4O0PjWj6_3N0YT5NIBc_jb_PJ-2oGUL8s1-S5LIGI
Message-ID: <CAE6NW_a2V_BOQN2o76UOTBTEpurRRK9ZStGdwXT2n+V4UU04BA@mail.gmail.com>
Subject: Re: [PATCH V4 0/4] Align SVM with APM defined behaviors
To: Sean Christopherson <seanjc@google.com>
Cc: Yosry Ahmed <yosry@kernel.org>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 8D1351F7F85
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
	TAGGED_FROM(0.00)[bounces-72617-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chengkev@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Tue, Mar 3, 2026 at 5:08=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Tue, Mar 03, 2026, Kevin Cheng wrote:
> > On Mon, Mar 2, 2026 at 7:35=E2=80=AFPM Sean Christopherson <seanjc@goog=
le.com> wrote:
> > >
> > > On Mon, Mar 02, 2026, Sean Christopherson wrote:
> > > > On Mon, Mar 02, 2026, Sean Christopherson wrote:
> > > > > On Mon, Mar 02, 2026, Yosry Ahmed wrote:
> > > > > > Also taking a step back, I am not really sure what's the right =
thing
> > > > > > to do for Intel-compatible guests here. It also seems like even=
 if we
> > > > > > set the intercept, svm_set_gif() will clear the STGI intercept,=
 even
> > > > > > on Intel-compatible guests.
> > > > > >
> > > > > > Maybe we should leave that can of worms alone, go back to remov=
ing
> > > > > > initializing the CLGI/STGI intercepts in init_vmcb(), and in
> > > > > > svm_recalc_instruction_intercepts() set/clear these intercepts =
based
> > > > > > on EFER.SVME alone, irrespective of Intel-compatibility?
> > > > >
> > > > > Ya, guest_cpuid_is_intel_compatible() should only be applied to V=
MLOAD/VMSAVE.
> > > > > KVM intercepts VMLOAD/VMSAVE to fixup SYSENTER MSRs, not to injec=
t #UD.  I.e. KVM
> > > > > is handling (the absoutely absurd) case that FMS reports an Intel=
 CPU, but the
> > > > > guest enables and uses SVM.
> > > > >
> > > > >     /*
> > > > >      * Intercept VMLOAD if the vCPU model is Intel in order to em=
ulate that
> > > > >      * VMLOAD drops bits 63:32 of SYSENTER (ignoring the fact tha=
t exposing
> > > > >      * SVM on Intel is bonkers and extremely unlikely to work).
> > > > >      */
> > > > >     if (guest_cpuid_is_intel_compatible(vcpu))
> > > > >             guest_cpu_cap_clear(vcpu, X86_FEATURE_V_VMSAVE_VMLOAD=
);
> > > > >
> > > > > Sorry for not catching this in previous versions.
> > > >
> > > > Because I got all kinds of confused trying to recall what was diffe=
rent between
> > > > v3 and v4, I went ahead and spliced them together.
> > > >
> > > > Does the below look right?  If so, I'll formally post just patches =
1 and 3 as v5.
> > > > I'll take 2 and 4 directly from here; I want to switch the ordering=
 anyways so
> > > > that the vgif movement immediately precedes the Recalc "instruction=
s" patch.
> > >
> > > Actually, I partially take that back.  I'm going to send a separate v=
5 for patch
> > > 4, as there are additional cleanups that can be done related to Hyper=
-V stubs.
> > >
> >
> > Gotcha, if you're sending just patch 4 as v5, then should I send
> > patches 1 and 3 (with fixes) as a new series?
>
> No need, I'll send a v5 for 1 and 3 as well.

Sounds good. Thanks Sean

