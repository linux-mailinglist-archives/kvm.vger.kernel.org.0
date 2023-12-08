Return-Path: <kvm+bounces-3967-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EB5380ADFC
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 21:36:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 127591F212EC
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 20:36:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD66057892;
	Fri,  8 Dec 2023 20:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3ln6m9oI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E78C198E
	for <kvm@vger.kernel.org>; Fri,  8 Dec 2023 12:36:20 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5cf4696e202so31977827b3.2
        for <kvm@vger.kernel.org>; Fri, 08 Dec 2023 12:36:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1702067779; x=1702672579; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=orHiJZT0C6fy8Fk3kj9J2cROYJthdQ2Wc1XwHn5ZMq4=;
        b=3ln6m9oI3jDYCkIaLkrprMOPDZL4zJLDkHJeUd5TD8ROVnPxu6QusfweP8eUz1WUyi
         wQvVpdwjLE3YzrqKuwb3sWcVJRWaFjDupLV2U96fw1mDUCpK/d7HFfMhFDu7fTSl83eu
         n1QLUdGLK5It7eLF3CnQAfXHK138ENkZB1SyZJ4FEfFzLHhiJUDCgYd/he5K2JEc0BIH
         meA4MobzMMmZ5XmU0RACo8+mqGSlcJ0tIjYI0ws79e0/crMfwSttuwNo99Vm+ZEzOQzK
         2aiU+4SLLY8VysAsuqC8RGhr6Lc3ztkLhZO1nFwvAHfksOT1VofCKXP9Kt3u5AHyuFTI
         QQ1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702067779; x=1702672579;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=orHiJZT0C6fy8Fk3kj9J2cROYJthdQ2Wc1XwHn5ZMq4=;
        b=iwd9UGhUKqaTUlqPvrQDX/ALMynBVFPTkqaT0tmYX1ONp08xjmH1sIOyksmRVkZNaG
         tBpufClOD/J4siM0OEgFbPWrPJb66dVVbUAFgFjovuscbmKfcoSqeGEYvH1Hw8DSf3kc
         ZrLY+puxCKRvlqrkDM8NdkJCHUCVVaFlBUlHuRedjmEmGrumGAALcmEzeYyDZ1lX+1JY
         AJvZgxLo6z2I7zG+sNUXUBstb+mOktLEiXLglMIQ5EWVmpNX1uFDHu4q01HZc+VTqGnu
         0BtQCzpLK7FCsF5l6Ci+oIQjoN3hViU04jw2S+Xw6/JB2j5MgGzWiNiI4ExfyTXbmudG
         Whlw==
X-Gm-Message-State: AOJu0YwIRLwRX4mUNXJ5yxhY6u24MORY2H0J5SwvmweuScG3qKq+YQwS
	GRbp1jrwurtsI3KnTpnusohsPTXfaEA=
X-Google-Smtp-Source: AGHT+IGM36poiI66KimXwnmZMFV+cug+a/f2/aHqYZGdi3tEpQylnxIgmZTLgmZqxePMHXCOG7mBMbzoJbc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:d1e:b0:5d2:913a:6421 with SMTP id
 cn30-20020a05690c0d1e00b005d2913a6421mr5795ywb.8.1702067779340; Fri, 08 Dec
 2023 12:36:19 -0800 (PST)
Date: Fri, 8 Dec 2023 12:36:17 -0800
In-Reply-To: <CABgObfb2AxwvseadmEBS7=VWLKKpYVeHkaecrPXG47sMfCKEZg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231205234956.1156210-1-michael.roth@amd.com>
 <ZXCTHJPerz6l9sPw@google.com> <CABgObfb2AxwvseadmEBS7=VWLKKpYVeHkaecrPXG47sMfCKEZg@mail.gmail.com>
Message-ID: <ZXN-QUBpq1nADjUN@google.com>
Subject: Re: [PATCH] KVM: SEV: Fix handling of EFER_LMA bit when SEV-ES is enabled
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org, 
	Tom Lendacky <thomas.lendacky@amd.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 08, 2023, Paolo Bonzini wrote:
> On Wed, Dec 6, 2023 at 4:28=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
> > So my very strong preference is to first skip the kvm_is_valid_sregs() =
check
>=20
> No, please don't. If you want to add a quirk that, when disabled,
> causes all guest state get/set ioctls to fail, go ahead. But invalid
> processor state remains invalid, and should be rejected, even when KVM
> won't consume it.

Ugh, true, KVM should still reject garbage.

