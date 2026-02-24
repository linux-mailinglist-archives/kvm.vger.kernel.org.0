Return-Path: <kvm+bounces-71654-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UNwWDVTunWncSgQAu9opvQ
	(envelope-from <kvm+bounces-71654-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 19:30:44 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D568518B67A
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 19:30:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 0E8DE302B187
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 18:29:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06B6B3A4F31;
	Tue, 24 Feb 2026 18:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gvab/GP+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9789028F949
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 18:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771957768; cv=pass; b=g7969Wyn6jVmMuKlDzwymilEggptZeaDUc5wMrSfnFueITYEA0FgWYPaPq/283++VBoujzWuiHVnc6t8DkUQiQSr1IADad7WE978og3H+MTG0DXUiAzLRYJyBb4+Oi6u09ak41aObNYyis2122csch92q44E9miQUszmX65jODo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771957768; c=relaxed/simple;
	bh=4tFKqKq7LxHiApRhoTkOfQequmtDldphLqXpvVMEAek=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IgdivfXcSToPrE5iPlvquY346sT7xf+7S6A+ovWBpZRhGAz1lnSqNb7Hn8Vt16jZJmwv8hiaxvz3kz0yuJpoBtwFTJ11WenofW71yEwkZVOh0qGQdXwa4eeEKceOqvgOk2VOxme6tDLfNS7HiIZ7ZR4EwRxzCdAMq5tZox2IIk8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gvab/GP+; arc=pass smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-652fe3bf65aso667a12.1
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 10:29:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771957764; cv=none;
        d=google.com; s=arc-20240605;
        b=IR9itaQJo7R3xxiZDw9mFlL/53VSGLUu/EzNOAwbu6xLytgvNk8W1xMjL6GVGyvi6K
         /aMMMu8P1cDBPY6xcqNej73EUVKLP1cGMnYiD3SHmXmtaiQF8w8pHECcHj8kdM+L5O/g
         h4Lg9iXDVdTSDdaXL0GaEQp8T40CV5P3xCohO6vn0oUOhffRQTx6oRQgZ/gKsrkFVKIP
         gPCi1upisGH3YqyvhqSHCjdpIUkEMO92m7Da2EZn9ClKG37JXb3rDAHtzZQtii6zYwwz
         gfONI/s+38JTCZnre4Vq2+bTR96qga136pATKTeOnduu3MuFehGAsdpal1JTNGx/6gmk
         2nQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=runWMJn0J9oOBYzJ6m4yNE1KKJE9xc/latz4EBzuSpE=;
        fh=q66sFD2fadJzPYcoWOQCyWpBIk9xkBRm3Ifid27yeDM=;
        b=OY26e+dEBeCBcF6dRVKaUJjfOBLy9mVN1nqOQ3JV7zjQedW4H5W1dpnq86vVevnRFE
         M8OJnjtPOvH25MfxnpBpSl23h+BQILGHfOsbpmMsDBl5U/hIpXpCvA3Q4KDJ2LPilxL8
         tDJO3UyC4r6Glp0YDk4u+sSbmIJ1OMh33qn14JB6K6rKuMkbbwOUAtH0vuH2vmi6O4fc
         1T31MDhBL+RnzzkLt4pNeJSKs2q2pxLqjKBQWIzvSvQhOgN4WknZ8Z/30yf/C05XIRWZ
         nXbY/tlVrYnoi4r8hmLgSzQLqsCWWSlXwsvYhbJtF3O9V5n7SpG0j7ttWjBVn3y0dbNJ
         fqYg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771957764; x=1772562564; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=runWMJn0J9oOBYzJ6m4yNE1KKJE9xc/latz4EBzuSpE=;
        b=gvab/GP+lZncX3N4RcEUDJxBbDiSekrfIRiA4b6AW7v0vYMvlKH8/XWwzpVEMNsF7w
         lJ1Myf+X9XNahOkqRyinlTcuSS9zoRIUQwENEExWwX0D0N1n5PqQPKkqxc+TnL9xJBvT
         TRBjUkVxCz6B+6p/3zb8n6N1JjfARgOHpS3WwEukXU9jOB2xN2niK2l8Sqfcaea55ClV
         4gLB566hoLbIJfiK/16sxVhbxzaYLHXmPa6Om1o465+WhBBMF8XA1qdDAtGmRGB+9MAJ
         tPDDRkOOa+/jIcmsLUCmIxxba8miJhvSDAE6CAnaH7w3WX7C24dLhDUpIpbY8ITbuwIJ
         YccQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771957764; x=1772562564;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=runWMJn0J9oOBYzJ6m4yNE1KKJE9xc/latz4EBzuSpE=;
        b=eZiL/8eHh5CSmABwYdnXP5Kh1CKuvKE9emRF+9HWEAYx/KOMiEm9QJCvJTUHzt0Dvy
         rSM3YZVhfySeNdGRzg6bR75nWYU4lmyzBL/XWt1b/ibpffGdj8sz0topeG2flD58juOv
         iJXc/YnDC8PhNNPs7A1zrtcsHJ5Fch5cIdBzFmFyqDmbu9tub/A+uy0L9ReuwEhyvesE
         KnUcDWhl2iYeFEJxjHS9I7GbO0MSjIhDs9jBlbiaZ42HFqHdbcWxMzWKpflB8OPisVlc
         VBnlRtXgzPBYhYAQ3ZiBR1XvGn8HViHu7ELZjs+L+Nt8BCcU0jpMqHLYDoN4ccvKL5oC
         eOIw==
X-Forwarded-Encrypted: i=1; AJvYcCVwabfZJPL2n5zXDL2cR5x76aOO08IXM84tUOWtpXjDRAyBz0KDOD7h5PCmyCMjO8wVjgg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy15s6vAV6XOqabKBjuE1P1Bo/WcEN7qPuHSz4nAAk5PkyECrf+
	IzgzFFP0c7KwHClI9shK4rUWvOQFgx8JfGndQyTrVxGQQGV+w7qVa0CI7RMxxDDJN5EUUHNs1cI
	ayuImftgRai7VcbZQPGHvee7mI4F5rg+o0GGv89QP
X-Gm-Gg: ATEYQzw2koWsWz3phuONKmhQmXvCvT7yDvpX43HKrjoDRlF/EeTtJvZ9vAA0caHf2pb
	yDyCHG/aZJc091+InrHUlNDFIGVzi+uUmFf9wuvymBOk81zn04J3CbOOBnszZLTodZGjdccvTZl
	mtgUEJFmJTEREzfiFyOIdE++9lpTVvoFen3k5z2R26HeB+qAFIxpOn3p2/8PRzNIEepuLBLHuv9
	gKRxGyKVZ7ta6n/20gyZbYE4yLzfyn/hUp1eBpCmU/wzxl9wh6KR6cJG86BpT0gNhOe7yMbCxdQ
	1E2KtNw=
X-Received: by 2002:aa7:d8c9:0:b0:65f:76c8:b92f with SMTP id
 4fb4d7f45d1cf-65f823a9090mr3867a12.0.1771957763587; Tue, 24 Feb 2026 10:29:23
 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260224180157.725159-1-kim.phillips@amd.com> <20260224180157.725159-2-kim.phillips@amd.com>
 <6b3b0c86-99eb-406d-b88d-3d71613bef9e@intel.com>
In-Reply-To: <6b3b0c86-99eb-406d-b88d-3d71613bef9e@intel.com>
From: Jim Mattson <jmattson@google.com>
Date: Tue, 24 Feb 2026 10:29:11 -0800
X-Gm-Features: AaiRm52tDwFSIncbciiIXzMFhAD28L3SFP_lpf0FhC49DMlc8OhD_P85p32kjvM
Message-ID: <CALMp9eQzaWJvnTtJzcyvTuYFT3JSgo+4Tu2w4a7mPoEah4P5jw@mail.gmail.com>
Subject: Re: [PATCH 1/3] cpu/bugs: Fix selecting Automatic IBRS using spectre_v2=eibrs
To: Dave Hansen <dave.hansen@intel.com>
Cc: Kim Phillips <kim.phillips@amd.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-coco@lists.linux.dev, x86@kernel.org, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	K Prateek Nayak <kprateek.nayak@amd.com>, Nikunj A Dadhania <nikunj@amd.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Michael Roth <michael.roth@amd.com>, 
	Borislav Petkov <borislav.petkov@amd.com>, Borislav Petkov <bp@alien8.de>, Naveen Rao <naveen.rao@amd.com>, 
	David Kaplan <david.kaplan@amd.com>, Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, 
	stable@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71654-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[18];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,intel.com:email,mail.gmail.com:mid]
X-Rspamd-Queue-Id: D568518B67A
X-Rspamd-Action: no action

On Tue, Feb 24, 2026 at 10:23=E2=80=AFAM Dave Hansen <dave.hansen@intel.com=
> wrote:
>
> On 2/24/26 10:01, Kim Phillips wrote:
> > @@ -2136,7 +2136,8 @@ static void __init spectre_v2_select_mitigation(v=
oid)
> >       if ((spectre_v2_cmd =3D=3D SPECTRE_V2_CMD_EIBRS ||
> >            spectre_v2_cmd =3D=3D SPECTRE_V2_CMD_EIBRS_LFENCE ||
> >            spectre_v2_cmd =3D=3D SPECTRE_V2_CMD_EIBRS_RETPOLINE) &&
> > -         !boot_cpu_has(X86_FEATURE_IBRS_ENHANCED)) {
> > +         !(boot_cpu_has(X86_FEATURE_IBRS_ENHANCED) ||
> > +           boot_cpu_has(X86_FEATURE_AUTOIBRS))) {
> >               pr_err("EIBRS selected but CPU doesn't have Enhanced or A=
utomatic IBRS. Switching to AUTO select\n");
> >               spectre_v2_cmd =3D SPECTRE_V2_CMD_AUTO;
> >       }
>
> Didn't we agree to just use the "Intel feature" name?

Aren't they quite different? IIRC, IBRS_ENHANCED protects host
userspace from guest indirect branch steering (i.e. VMSCAPE style
attacks), but AUTOIBRS does not.

