Return-Path: <kvm+bounces-579-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 497CF7E0F73
	for <lists+kvm@lfdr.de>; Sat,  4 Nov 2023 13:46:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 296671C20A3B
	for <lists+kvm@lfdr.de>; Sat,  4 Nov 2023 12:46:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B742518625;
	Sat,  4 Nov 2023 12:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EzuzmZFK"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21FC211725
	for <kvm@vger.kernel.org>; Sat,  4 Nov 2023 12:46:22 +0000 (UTC)
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88EFD1B2
	for <kvm@vger.kernel.org>; Sat,  4 Nov 2023 05:46:20 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id 2adb3069b0e04-50931d0bb04so2180e87.0
        for <kvm@vger.kernel.org>; Sat, 04 Nov 2023 05:46:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699101979; x=1699706779; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I7d3FLwKpFYOTr5gbCWXtm9OztyAg68Ag2ZB+uAGlNg=;
        b=EzuzmZFKo5Z4V3a3r8MfW9fO2I+Jxn1EVYlEq4kvA7vqLBDxTMoi64FesWFc9iTMGr
         zO2KoZqPTqpy2QvcfqCRfi7sZabTWAazWhbigxo5VfIQKfLZtpktK6B5d+TQpfOeg0FR
         u1g4R2XyK3Dxw9wy3fKC8kLSH1fycNFZ8A3fakDH/AR+9hTyqoFlKQvuDFHUzDn4wym/
         mgICGy/TYO0aH7HEDutMuP08z1bgBtbPQB5tzuREF9YrWgnwsjmveY49j9Ka2gvTUowl
         kefnJSyFIg97CkXa9OWzJxSTsmu0FTipIYnpq33DdDtBbFh1OYSKcKVW21uQX/Md995n
         RWcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699101979; x=1699706779;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I7d3FLwKpFYOTr5gbCWXtm9OztyAg68Ag2ZB+uAGlNg=;
        b=QxrsAySRta1UjZ24B6n8+0IXj3zAikaxbT8NybYWY3ve5cnb+iLYvAwMt1FobUeVmP
         GEi+M1jPz1DmI2Pmh8HnLzVNv5zd0Yorheg6z1lUXXPVQptMgNKvAgQR5sItfp3y20u2
         Dx4fHpUXLmI2NLflcATQYVajBZPJbOWFHwtgM1XokRHh+BezzJLn84U5/m8bqAEhTXs2
         w/MLlFdKzTtJG5674q5O1uW5zgyyssXWfzHJE7aW6o29k2Jq0+exiKMK18Jm5CKV3CPO
         ia9qhho+bGdk3oTYG+m8ubE8iWoczM0YgrebmXUk2QWQ/ISeXFYncQgzGTwEasny7b9l
         tbvg==
X-Gm-Message-State: AOJu0YwrYXko0Hn46rcW5sEPudMqzTRC69OfgPZxlM7se1vxK3WM79SJ
	Dm1RpMunv1HimYoEyw/km/1JVDfplkfPAg5zh66SyA==
X-Google-Smtp-Source: AGHT+IGQuFm1gFc9sc9e2VNUxROPUiFQH+ug/+OodDkH/1zwAt+kxlBXU45zcvzvQbGwvs/2T45lbamU0hN70iQXcBU=
X-Received: by 2002:ac2:4c86:0:b0:507:8c80:f1d1 with SMTP id
 d6-20020ac24c86000000b005078c80f1d1mr46272lfl.2.1699101978565; Sat, 04 Nov
 2023 05:46:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231104000239.367005-1-seanjc@google.com> <20231104000239.367005-6-seanjc@google.com>
In-Reply-To: <20231104000239.367005-6-seanjc@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Sat, 4 Nov 2023 05:46:06 -0700
Message-ID: <CALMp9eQ8F6U4PgP7Bcwd_-m=p8OtSgUW+zTEyDJBrxnq=qBB=Q@mail.gmail.com>
Subject: Re: [PATCH v6 05/20] KVM: x86/pmu: Allow programming events that
 match unsupported arch events
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jinrong Liang <cloudliang@tencent.com>, Like Xu <likexu@tencent.com>, 
	Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 3, 2023 at 5:02=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> Remove KVM's bogus restriction that the guest can't program an event whos=
e
> encoding matches an unsupported architectural event.  The enumeration of
> an architectural event only says that if a CPU supports an architectural
> event, then the event can be programmed using the architectural encoding.
> The enumeration does NOT say anything about the encoding when the CPU
> doesn't report support the architectural event.
>
> Preventing the guest from counting events whose encoding happens to match
> an architectural event breaks existing functionality whenever Intel adds
> an architectural encoding that was *ever* used for a CPU that doesn't
> enumerate support for the architectural event, even if the encoding is fo=
r
> the exact same event!
>
> E.g. the architectural encoding for Top-Down Slots is 0x01a4.  Broadwell
> CPUs, which do not support the Top-Down Slots architectural event, 0x10a4
> is a valid, model-specific event.  Denying guest usage of 0x01a4 if/when
> KVM adds support for Top-Down slots would break any Broadwell-based guest=
.
>
> Reported-by: Kan Liang <kan.liang@linux.intel.com>
> Closes: https://lore.kernel.org/all/2004baa6-b494-462c-a11f-8104ea152c6a@=
linux.intel.com
> Cc: Dapeng Mi <dapeng1.mi@linux.intel.com>
> Fixes: a21864486f7e ("KVM: x86/pmu: Fix available_event_types check for R=
EF_CPU_CYCLES event")
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Yes! Finally!

Reviewed-by: Jim Mattson <jmattson@google.com>

