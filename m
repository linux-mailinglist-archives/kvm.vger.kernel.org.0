Return-Path: <kvm+bounces-3151-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D9F468011F7
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 18:44:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 93D2528117B
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 17:44:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 706544E636;
	Fri,  1 Dec 2023 17:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ABNNAnoU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EFD7AC
	for <kvm@vger.kernel.org>; Fri,  1 Dec 2023 09:44:35 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5d3cdd6f132so24327897b3.2
        for <kvm@vger.kernel.org>; Fri, 01 Dec 2023 09:44:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701452675; x=1702057475; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6Ygf4AvzbtFaf9glZ+qouIUJsoe+oZLlrurLDy90Za0=;
        b=ABNNAnoUu/L8gT7V2lI+PUYYdnPRTmItGfcyCwTFEZsPZE2s8d+s4oMtxi/oijUa2o
         5nf3w7LtbXfHxQm69dbxoHEQB5owVIGH3I18CWHHvFCVk2uvnRGipvPmdEvlJyG6wkVj
         IQ/NiWtnJ0d7HtQD46VEQWmhvaHkl9Ks9WF6vMYxjVbZuBSM9wi5PfJum7hdzea0W2u4
         dLTT9PkNKBk4D/HE+6mEMuJuipMaOw4breTOvEsOKEt7tZr6GxKquALfbUWtk4WXNqOm
         r6Mr3zFVergZ8oB/+Oc7lFfixTio1C0JRh8OEI6Mtq+LhiA7eTnqc+Eu2idbnWhdKpMZ
         qtuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701452675; x=1702057475;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6Ygf4AvzbtFaf9glZ+qouIUJsoe+oZLlrurLDy90Za0=;
        b=fOlZ6b+jaAPsnMwToed+kG/CzoM2qnQPRrXITYyT5Emyzp4WCjIZTr5qhWsCJlN05c
         Y+YWXDmkIAd4CR4YA6naffuHRNGACIgwvHz+7VWjYjDp74aC1nzQp/YFLG7ocnnKOnrq
         N8DBBFppdJ03BuaRxLzOFsK69eCqFaAiE2BpPVC4ocsxZJS6Y0gAfbe4hAtvKEyQ8s5p
         L3vyKHwAl0QdawV9CBPOTSf/zhAU0G+9s+KHGL6ValNt1uzpy/UnhbhbQocszZnDxjUu
         LBI1Ldl7lIuUsWX8cLULQw5ThtLG5L+arMBaRW1JH6Fl/a3p0qxsDVJ7bYj+fL8cotE4
         9CEA==
X-Gm-Message-State: AOJu0YxC7rCpOElJh6KlxHtcf7/o6fjDSbKPmI0pP5G8XwtUZOkb+/sH
	13oFlKdgABhy6vRk900B2dIkKbdDa6w=
X-Google-Smtp-Source: AGHT+IGz5rRtf+Aw1a0HRLQSALJFCvVn+N/Vb1N997Lzq8k/kSNFuy6WRIBEoj9el1rhRp1KOeWt0RITkWM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:448b:b0:5d4:35f:4a26 with SMTP id
 gr11-20020a05690c448b00b005d4035f4a26mr101157ywb.4.1701452674798; Fri, 01 Dec
 2023 09:44:34 -0800 (PST)
Date: Fri, 1 Dec 2023 09:44:33 -0800
In-Reply-To: <a0c99edd584b47ce8f9f8aff86b2a568@amazon.co.uk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231201104536.947-1-paul@xen.org> <ZWoNzzYiZtloNQiv@google.com> <a0c99edd584b47ce8f9f8aff86b2a568@amazon.co.uk>
Message-ID: <ZWobgUtVj5xmdJX7@google.com>
Subject: Re: [PATCH 0/2] KVM: xen: update shared_info when long_mode is set
From: Sean Christopherson <seanjc@google.com>
To: Paul Durrant <pdurrant@amazon.co.uk>
Cc: Paul Durrant <paul@xen.org>, David Woodhouse <dwmw2@infradead.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"x86@kernel.org" <x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Fri, Dec 01, 2023, Paul Durrant wrote:
> > On Fri, Dec 01, 2023, Paul Durrant wrote:
> > > From: Paul Durrant <pdurrant@amazon.com>
> > >
> > > This series is based on my v9 of my "update shared_info and vcpu_info
> > > handling" series [1] and fixes an issue that was latent before the
> > > "allow shared_info to be mapped by fixed HVA" patch of that series allowed
> > > a VMM to set up shared_info before the VM booted and then leave it alone.
> > 
> > Uh, what?   If this is fixing an existing bug then it really shouldn't take a
> > dependency on a rather large and non-trivial series.  If the bug can only manifest
> > as a result of said series, then the fix absolutely belongs in that series.
> > 
> 
> There's been radio silence on that series for a while so I was unsure of the status.

v9 was posted the day before Thanksgiving, the week after plumbers, and a few
weeks after the merge window closed.  And it's an invasive series to some of KVM's
gnarliest code, i.e. it's not something that can be reviewed in passing.  We're
also entering both the holiday season and the end of the year when people get
sucked into annual reviews and whatnot.

I totally understand that it can be frustrating when upstream moves at a glacial
pace, but deviating from the established best practices is never going to speed
things up, and is almost always going to do the exact oppositie.

