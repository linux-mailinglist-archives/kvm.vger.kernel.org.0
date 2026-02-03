Return-Path: <kvm+bounces-70085-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qGTRJp9egmnTTAMAu9opvQ
	(envelope-from <kvm+bounces-70085-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 21:46:23 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0197CDE9DE
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 21:46:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DF80D30514A3
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 20:46:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 593F02F1FC9;
	Tue,  3 Feb 2026 20:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ooyFdnY1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4A80F9D9
	for <kvm@vger.kernel.org>; Tue,  3 Feb 2026 20:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770151576; cv=pass; b=lt/9fMlgCXDpG2mKMydZxaGdoCKqeNxJve1Grcie4TjPJxbGS3hK+lkeOFcH8A19ZVNpZe+F0SHqDdjkLWgv/LxG2QrynRL0laK0MWffoY8MQSebdmAAz3eVNKT7TThoFvOYJYC4+Irbaued1aeC/NesjbCW+Toro7NOLBLxEWU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770151576; c=relaxed/simple;
	bh=Q7OwuwFj7g4WIG1A265nsQSz8PIxVCvFg2hsp1EQeuo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gMY1aloNruFWi5fhrPKXm+IWMapMQowbj9X0AGGDimN95KG4U1N6y2+nd56vxnK5dCX5voRK7eK4WtL8VAgSU7DWYYqegb62XHZuBa7hZymhNgi2v5ecX+BrqTFrpOOtvipHt2N9Jr4xocQWwvuriENL823K7dJJswVDYUXY2W4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ooyFdnY1; arc=pass smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-652fe3bf65aso46a12.1
        for <kvm@vger.kernel.org>; Tue, 03 Feb 2026 12:46:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770151573; cv=none;
        d=google.com; s=arc-20240605;
        b=bi/Ve3WJ5EuOf+wgyv8NlhKb4FzcJze82EZlIcvAeEXytpj4VwZVbxWEdb36Sd+eoD
         RIqXZgL6kxmsQRL50PnvLsAnUGgqm2eRr0DbK/a5+icGmuNzICjr8BQuiWktRAeLwid+
         7+z1/wifmuBCGx1F7oQYSYEu5buSE0OUIa9MkO19G5H48BuYn3X8B+kdUpUB4hmUfzJU
         27zgKNBh72Pm9nYnPxVlPxF7/mrXhDdr5hURLx3sFJkMWxMIlQZFqWrZxoIV0nK2odDS
         5Oe/psWTVM2xgkJCAtBViDCEXUdHQEsswqCbczAUxmgf4cL0o+wVPc9xiNh8pYq2vW3f
         Ut3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UXUxBXB30px7Qxjr7Xjdulu2/5KTCIkLZZ0qQGNc3DI=;
        fh=WKH2Y4H4u0qD7XIFxbXPUOObvhMJMn4FEyFW4pnnw20=;
        b=J8Gb+7kj9+wpAOX10KJD5O5XYX4ZjvnavDTfAYeLLDeLlVQ1xtbbn3KbPMHkBY1Z8c
         O1GE8ixh72HrsNNHaS30zaul2z41wl7O+7Ikkt6qHyd3gE9uM8Qn9E+94W51UqtgLpUs
         kL3rKbm5WMNOzHoUmAX/RTDJQLZ255TWdfi8uBedCXxDam1ik0WcRmNot/9L13B2P1QO
         +ZrXFRgAUE4pn0ZQlQ3C5S5nEAPTjgd99Woe3O55UxlB9x9mtlZqPp9GHhEvka/GV/KQ
         7Q4XdOtIWGYDoMxE7K1tonDS+c9ZDqToLBPsD3kcuvRMH0am5vx3daebbSXIbuMsFZad
         Zegw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770151573; x=1770756373; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UXUxBXB30px7Qxjr7Xjdulu2/5KTCIkLZZ0qQGNc3DI=;
        b=ooyFdnY1e+9GoqOpIwTgS1gcgtULscsQkBPkOcPLLpS5YifxKIlfBmWMhIGK302E+I
         LkAjzl9jkZW77eBvlQXd/vmJSj5e4YvMi39XOhmGDaoxKob9gREEpDt1y4Ia+gSHqrmi
         zaY9ehvEhlhUBcBR5+ifth58C42VEIBfwoibzKHVKSbKlROzmvIN/SiqIOPluz1NYZxn
         OSkeauiHP7dsQuMnxKG7997Ckldvg1OkmldGaY22zuYT7gKEhjFkeDneI+fAe45URp10
         dX9IQGDaaNgutQLj1ZBHaalxb4m+Iug4rPoknwa93J/LvwCCQ/sx2wYs9hHW1WBAbxnW
         iaFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770151573; x=1770756373;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UXUxBXB30px7Qxjr7Xjdulu2/5KTCIkLZZ0qQGNc3DI=;
        b=Koth23oY2JSVuVpbtl4NTZeoIRx9VSPuXxNVb7SkEyi/LXxZiDjbvRBgVUyuHPGcJI
         2BgZtt2xSQGHTL1WKZoO9sTLaa+ftTD/EU5pB9d2TE8Ej/hXQElT3rvt0cBDuhNSazr7
         BRthjKEnGX5XfylpeXcKcFS7Au1QUWUQjNmb84ySoL1KqIl+t50OJRNhZwbdOReLz+og
         rWCJmy3gEKukX19a18TdCO0hgRfupRkwF4bMdKqPJhATIU62cRu/+magZ4bwZcsaNx7W
         rTcY5DiqpNfDewWV6QPRkAkcbOxx9PvV8L9QgHY3SCPqHzSY/XypbwJaYrZ2T9z7hsPr
         lT7Q==
X-Forwarded-Encrypted: i=1; AJvYcCWoziYpimdPKzPm9OShTawW2qllq0iV54qjKZJexg9iPKQZwh8jEOzs4tmkWGupWZhgKSU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyDtygtHUmc201F5ImjfKA0D/makbmTHbEGeW9w6dX1MVeHj+1b
	ep54yu6ZoFgOZIyt2Jubbq8xWu5Bk068JmMpnlQhDZsOxbbSo2wGrmSEvnjWGlBt3j+JKk7DhIu
	NW2b2bbunnz1VfH7QUY4uZrUdCVbnzNdbK1/6ooTo
X-Gm-Gg: AZuq6aIZheTbR9uSB9xb1TcqAu4Y+1tjMGkln9GM0yuDIW1upWjSwfIFSE6eVqrsjAH
	XC0C1Ek7fdiartKWs9oiO+NjKumyTcLG3/921k0h2pzlHT/Ri1RHxbF0fYevkUfAUVUTvVPsmRk
	GklDYuXTju+wE9QNSVnj039XcOwd3XEYSbXxHailamyD05/5/AHZDpS4JXJV93Y32jxaopIhzPZ
	uzoK75eNt0OSiXUAT8MqFQ7xKuYDLBLllz8XSZmWyQA9pvq9eDlERzDCgTY7KNteBHAu8M=
X-Received: by 2002:aa7:c508:0:b0:64b:2faa:d4e8 with SMTP id
 4fb4d7f45d1cf-6594cc84926mr251a12.1.1770151573037; Tue, 03 Feb 2026 12:46:13
 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260129232835.3710773-1-jmattson@google.com> <20260129232835.3710773-4-jmattson@google.com>
 <zzgnirkreq5r57favstiuxuc66ep3npassqgcymntrttgttt3c@g4pi4l2bvi6q>
 <CALMp9eS7Za_vFdh8YBzycV2g87gZ9uj_S1MOYrgJ1+ShwVVWZw@mail.gmail.com> <626dbe6541266f61e8b505202cf49c94c4fee12e@linux.dev>
In-Reply-To: <626dbe6541266f61e8b505202cf49c94c4fee12e@linux.dev>
From: Jim Mattson <jmattson@google.com>
Date: Tue, 3 Feb 2026 12:46:00 -0800
X-Gm-Features: AZwV_QhrunzURc9V5Pq5tiKjnsYeNR99YAZkjlUEbz7G1F7PnzNGzpkU8X6_T6E
Message-ID: <CALMp9eSZX9UQhu6iv24Jj9zUK+NVuiHAeHxsMDSgjP2skA=QMA@mail.gmail.com>
Subject: Re: [PATCH v2 3/5] KVM: x86/pmu: Refresh Host-Only/Guest-Only
 eventsel at nested transitions
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	James Clark <james.clark@linaro.org>, Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, mizhang@google.com, sandipan.das@amd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70085-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[25];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:email,mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 0197CDE9DE
X-Rspamd-Action: no action

On Fri, Jan 30, 2026 at 3:41=E2=80=AFPM Yosry Ahmed <yosry.ahmed@linux.dev>=
 wrote:
>
> January 30, 2026 at 3:30 PM, "Jim Mattson" <jmattson@google.com> wrote:
>
>
> >
> > On Fri, Jan 30, 2026 at 7:26 AM Yosry Ahmed <yosry.ahmed@linux.dev> wro=
te:
> >
> > >
> > > On Thu, Jan 29, 2026 at 03:28:08PM -0800, Jim Mattson wrote:
> > >  Add amd_pmu_refresh_host_guest_eventsel_hw() to recalculate eventsel=
_hw for
> > >  all PMCs based on the current vCPU state. This is needed because Hos=
t-Only
> > >  and Guest-Only counters must be enabled/disabled at:
> > >
> > >  - SVME changes: When EFER.SVME is modified, counters with Guest-Only=
 bits
> > >  need their hardware enable state updated.
> > >
> > >  - Nested transitions: When entering or leaving guest mode, Host-Only
> > >  counters should be disabled/enabled and Guest-Only counters should b=
e
> > >  enabled/disabled accordingly.
> > >
> > >  Introduce svm_enter_guest_mode() and svm_leave_guest_mode() wrappers=
 that
> > >  call enter_guest_mode()/leave_guest_mode() followed by the PMU refre=
sh,
> > >  ensuring the PMU state stays synchronized with guest mode transition=
s.
> > >
> > >  Signed-off-by: Jim Mattson <jmattson@google.com>
> > >  ---
> > >  arch/x86/kvm/svm/nested.c | 6 +++---
> > >  arch/x86/kvm/svm/pmu.c | 12 ++++++++++++
> > >  arch/x86/kvm/svm/svm.c | 2 ++
> > >  arch/x86/kvm/svm/svm.h | 17 +++++++++++++++++
> > >  4 files changed, 34 insertions(+), 3 deletions(-)
> > >
> > >  diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> > >  index de90b104a0dd..a7d1901f256b 100644
> > >  --- a/arch/x86/kvm/svm/nested.c
> > >  +++ b/arch/x86/kvm/svm/nested.c
> > >  @@ -757,7 +757,7 @@ static void nested_vmcb02_prepare_control(struct=
 vcpu_svm *svm,
> > >  nested_svm_transition_tlb_flush(vcpu);
> > >
> > >  /* Enter Guest-Mode */
> > >  - enter_guest_mode(vcpu);
> > >  + svm_enter_guest_mode(vcpu);
> > >
> > >  FWIW, I think this name is a bit confusing because we also have
> > >  enter_svm_guest_mode(). So we end up with:
> > >
> > >  enter_svm_guest_mode() -> nested_vmcb02_prepare_control() ->
> > >  svm_enter_guest_mode() -> enter_guest_mode()
> > >
> > >  I actually have another proposed change [1] that moves
> > >  enter_guest_mode() directly into enter_svm_guest_mode(), so the sequ=
ence
> > >  would end up being:
> > >
> > >  enter_svm_guest_mode() -> svm_enter_guest_mode() -> enter_guest_mode=
()
> > >
> > Yes, that is confusing. What if I renamed the existing function to
> > something like svm_nested_switch_to_vmcb02()?
> >
> > Alternatively, I could go back to introducing a new PMU_OP, call it
> > from {enter,leave}_guest_mode(), and drop the wrappers.
>
> We could just call amd_pmu_refresh_host_guest_eventsel_hw() every time we=
 call enter_guest_mode() and leave_guest_mode(), which is more error-prone =
but there's already other things in that category.
>
> We could also call it from svm_switch_vmcb(), which will add some calls t=
o extra places but I assume that would be fine?
>
> I personally prefer the former tbh, as it's otherwise easy to miss.

I'm not a fan of replicating code sequences. Maybe instead of a new
PMU_OP, I could introduce a new KVM_X86_OP, which would be
conceptually more general, even though the current usage would be the
same.

> >
> > >
> > > [1] https://lore.kernel.org/kvm/20260115011312.3675857-9-yosry.ahmed@=
linux.dev/
> > >
> >

