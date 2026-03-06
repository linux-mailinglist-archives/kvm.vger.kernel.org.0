Return-Path: <kvm+bounces-73170-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SIdPDv9Rq2n3cAEAu9opvQ
	(envelope-from <kvm+bounces-73170-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 23:15:27 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id EC1E5228411
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 23:15:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 186573028B6A
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 22:15:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 360B8330D54;
	Fri,  6 Mar 2026 22:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WAXJXXQF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B09F534B408
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 22:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772835319; cv=pass; b=OLvuYa5F4nJHTid25Tc8igibNT/8j3hYcrKjuqaLOBxrmDCl8iRN5ZusUb18MFLKSJM0L+trX2ExbRYh6rmyP+sFGXGGkAp6NCKsLV/Aopmz33XBWxQZPXlC+0CcmY4hwaAsq7uNu8V4FYZm2jX+3Gy6RgIfP70K8aHwCEBEXGE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772835319; c=relaxed/simple;
	bh=qU9vC0w0mwwxcafXSUAbSBY+dQNMDNQN234KwV9N2V0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=thA+uaL6tV/LnqvKplKF/VpCrSOMlCM73vvIHDbs8ho4b3QtEmJE/2QXRASawznFcBQzptNkUW4h1oWQnCeSRlNETNgk2uUMupWXxGU5U8Q/sQ282fpi1poUO7GYDSBRU9Jhzc6amaIJ2cgGp2H78oC9PyFjTr/fK4f+YlTF7X4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WAXJXXQF; arc=pass smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6614615fde6so1120a12.1
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2026 14:15:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772835315; cv=none;
        d=google.com; s=arc-20240605;
        b=fY1k07hGDTzcJhp5zMsolp+zBFXCAfzp2hXYvqlpR8EcoerrudWlKvs3B9ofTWhJCH
         yypvpDEJoJvgLL/BQEyqe0O7FKtkUMh5cw7jVHwXyYBtdgQB/AXfAFqEIRBRwTK5Qe2A
         PoHbKQXEuL2S0CrTRqdXMT8uJGeTz1NamMycOYE+gZI6xAItZMwQVPDUqOv/hZmNW4lH
         yOBDtKWsN6Z5du8e92P3txBpwL57kCv9fnjv8mvTpyqyr0HDL/S+vfZu0AIV6Na356FE
         khuahp/g2CBP3Wi3IdXoGRtGgHhwoazY2RZqkmwuiCunmX7f6sFTVq0KXWVqE6svGcmD
         EHhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qU9vC0w0mwwxcafXSUAbSBY+dQNMDNQN234KwV9N2V0=;
        fh=xv7auypSuWmkLudvS1UFUg52/4oVaAJZesbxgK6wpMc=;
        b=XK3m2T7UmmHo5WXn3kgz/j1orHua/+iNMVv8fHcmYj3ZCDi2ldvjPWtUkciUhq6Ueo
         iCeVb88drlJTuvO97clHiWLxPbhRqPFGKoIsL1WWUzr0LsHMoldTkTAlU7+vB/s5G0AS
         XypxZfh0yc1zbhj6DAG6k/sm1AR2uleXw5a4yccd7/fJ/AobvVzwmtGPD9fPO9t1Ulsu
         1FAVDssZI4wNzcUDFO+DnABHUSeke4mLqnOsfkRJHmz1LkMhBTcnox6Wq154dqb2l5Lp
         abL3OPzS2uGojivFBJsQ5Vu2rzr4BKABpEH7FDa5Ki9Ob2RJUXX3K/dMWLBsEF8DOf53
         VxUg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772835315; x=1773440115; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qU9vC0w0mwwxcafXSUAbSBY+dQNMDNQN234KwV9N2V0=;
        b=WAXJXXQFf3YefZKDxBdcYzdt8XpPtZ0KgSrDQiP4dQ3VUQbqndAh4SoDQXwMPLEemo
         mLUZj+gXSc3Ofhqfpm4yEqNmRbdBYzLBszCSw+UayN6KJFOm3V8+kVkvYwwVlDINEzrO
         oTcWmcPvL38hBVb/G7Z/pf2aL5Nm3CoYC6MOUVKCHz+nUGpVNrNzA87o/xuZVh7j0d7v
         HO5OyIE/6ZQsAxfYGPuknQohKNZ3HnSGyBtD0NUN9P7+GJNQIFI9nte/ytO0mAmMiwbz
         2UoO4Uk61QczZTfQr5OezK3wK5/OnGn8OeIEQa4xJiZFZVP8+IO3gcIb1CcGT+v/1lG4
         JLUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772835315; x=1773440115;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qU9vC0w0mwwxcafXSUAbSBY+dQNMDNQN234KwV9N2V0=;
        b=Gg0d5WAv3vuoswuacNESXS6QzystXluZ9bc7w7H72RxxIySC2ObTFYUMA7/GO6ixEc
         qOiXwej1+L16cGMPSkzeB3MtqTaQ0lnvoTGqd3JtiFlsS/9WG3c8Bb5lqxRp+oOIdTqF
         fLjxQhHkocjVZKUjbDujErshvSotBJb7vaZaOXY4LzUEX9Nncgv37FDyAcQUIgZAtIOR
         e4DNbovS6r2LoilI1cvxbKsq2euHIboOCmdcuA8W1sRxmWb+1l0PYUpWtxnCUoLhlwQf
         9NrCTQYZWmwJHbLQAyCY+N11LPwwjJpnmmm25C3X0MaifXRjQm70vTSXWBtNhmpLqZA+
         Vo4w==
X-Forwarded-Encrypted: i=1; AJvYcCVBFCTEybPkXSaoQwq0TUuJZ02sgC1Jq7s2WAU/sICPp5wy4MxR1VQnahxYJMSbwvFtPBo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyCGQLSrRI+xzykCr/Eq4vsGiFY2SHc8ullCwXoyxH+asYhULFr
	F3SFkfQzx+9jrq3bwbSu+yagl5B9FTw0Pvdoq8Q3JLpOaRAJvbiuSVT9uRLGwU3DhioaHYlU6iz
	IR55xQXE/T7dmSqNjcRz+h0DY+/X1rT5/aBt3B1tZ
X-Gm-Gg: ATEYQzwisX43eRWyjxb8uMTgtPqBsDzt2dHBMU+vxbJha7W2ZXVB/M7gKPV4r6zg5ke
	c5VGXIg5FxVTE8OMc1NziTjly4bjL3M7uibfqBrO8iT6OGsOdx8pM7XhXybdrFZm8d6xQgOYHaX
	Y3jlnRVkFiRPGP8IbKdTv7C9uxyN5i38IfIukh2kDvrVBUdKtOlZpDMq6znCJRncVktza5j0lRI
	wRjnWBxPpRWgbp/3K+ZaD2Q8ifrC2VXYrpqr/owMo2gYTsj9WeuJpTsPWrXUVYA/Nk8Ky0Xk5/5
	4BGlvzM=
X-Received: by 2002:a05:6402:1502:b0:660:efc9:900a with SMTP id
 4fb4d7f45d1cf-661e7ca8271mr10482a12.10.1772835314381; Fri, 06 Mar 2026
 14:15:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260303003421.2185681-1-yosry@kernel.org> <20260303003421.2185681-27-yosry@kernel.org>
 <CALMp9eSMtzDJn7tGtbj=zLYpcU7Tc7XjcWBRZH7Aa5YihSmN7g@mail.gmail.com>
 <CAO9r8zMhwdc6y1JPxmoJOaH8g1i7NuhPo4V1iOhsc7WFskAPFw@mail.gmail.com>
 <CALMp9eRzy+C1KmEvt1FDXJrdhmXyyur8yPCr1q2M+AfNUcvnsQ@mail.gmail.com>
 <CAO9r8zPRJGde9PruGkc1TGvbSU=N=pFMo5uc78XNJYKMX0rUNg@mail.gmail.com>
 <CALMp9eQMqZa5ci6RsroNZEEpTTx_5pBPTLxk_zOBaA8_Vy4jyw@mail.gmail.com>
 <aaowUfyt7tu8g5fr@google.com> <CAO9r8zPZ7ezHSHfksZPu4Bj8O7WTmDfO-Wu8fUAEebDFV4EoRw@mail.gmail.com>
 <CAO9r8zOV-4Nx7rZxHy8XsK3_X-enGm==Unj1NiiaaM2EuxK2WQ@mail.gmail.com>
In-Reply-To: <CAO9r8zOV-4Nx7rZxHy8XsK3_X-enGm==Unj1NiiaaM2EuxK2WQ@mail.gmail.com>
From: Jim Mattson <jmattson@google.com>
Date: Fri, 6 Mar 2026 14:15:02 -0800
X-Gm-Features: AaiRm530T7k5v9IflHoPvcatE4U5tfc2xnizOiSGcNAh_FqR9MO9kGHRlFp7qcs
Message-ID: <CALMp9eQ9uf09NuTsafC+y1VEUSp-kVtfosJS424bxiySfHqhuw@mail.gmail.com>
Subject: Re: [PATCH v7 26/26] KVM: selftest: Add a selftest for VMRUN/#VMEXIT
 with unmappable vmcb12
To: Yosry Ahmed <yosry@kernel.org>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: EC1E5228411
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-73170-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-0.947];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Fri, Mar 6, 2026 at 9:54=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wrote=
:
> Actually, not quite. check_svme_pa() should keep injecting #GP, but
> based on checking rax against kvm_host.maxphyaddr instead of the
> hardcoded 0xffff000000000000ULL value.

Shouldn't it check against the guest's maxphyaddr, in case
allow_smaller_maxphyaddr is in use?

