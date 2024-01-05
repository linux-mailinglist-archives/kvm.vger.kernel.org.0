Return-Path: <kvm+bounces-5734-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7500182590E
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 18:30:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 876231C232E5
	for <lists+kvm@lfdr.de>; Fri,  5 Jan 2024 17:30:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47416321BF;
	Fri,  5 Jan 2024 17:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Wd/Fv+8w"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 437A3321A9
	for <kvm@vger.kernel.org>; Fri,  5 Jan 2024 17:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dbdc1d8025cso2593675276.1
        for <kvm@vger.kernel.org>; Fri, 05 Jan 2024 09:29:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704475795; x=1705080595; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+FbD110k1IsvL9iHesvVmt7SnSjmo5LLQINMqjHP77s=;
        b=Wd/Fv+8wPZ2e87ZL3ljpOJhLeVGJoiI70iI6DVCv6cH+5DvhupsLWB4BxQ06e8aJqn
         GwByq29qXsjqoyRJM8DIvzrgffSCoHM+ShE+oCvGDe6mRagSwsi7cU+pextsIx1YWLTr
         Jkwxreaxlf9TVUnqD8k4jBZJZJOXWAOCb09Pq8GRJ274ciMJncrA2NxPzpjMJpU4aQTs
         wB3EOHmtQQipIqymunBWgh9g35eOciGNKzhWDWPT+Xp3s85EaaFNOTNrSbwrSID8neWf
         V9KEhjCPdEbappcRUnEhRQk86zKrLGh4Ou/sjkxkZ10XtpURsj4Gh80kazvkoN7imMu8
         onSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704475795; x=1705080595;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+FbD110k1IsvL9iHesvVmt7SnSjmo5LLQINMqjHP77s=;
        b=w8RhaGICfxnJlagHDutqtGFG22xbbKX9o4RRxlHJLWpFIY19vsfPMpxTrM9pzFKP+I
         lCBLGSL43k/CyDRa/n0wakgp10AFr1pDyx//ah2G9QuoAbxhl96m5zqMFFKz7srgJqhN
         CS7S/3ghgvfMg/vgouRuRgGknU0oIezzzpRjHUxnFqeF/ST0qd40jtsWNig/vKY98RuU
         dLPORC7kdpmJWTupzXrdJZRQ7NJA0jMQUpzEeY7QXbUJvwYnPpHcsSp/8k3ZVdgXisOJ
         Xk3tsopNZuJXyTG+C02Zb0HXxli7hzg7sbDGFK0Hs/Gu1U4BHW4LIXTtUsNrRtb8XVeu
         G0Ag==
X-Gm-Message-State: AOJu0YxKnU1G7A1KWmHSrFEkXX3NcCXZfSoHBBzunMqXvORp0HkLjNBG
	HbOtehAod9Xk0JOuTiPNxDiH/mjNqje5DLX1Ug==
X-Google-Smtp-Source: AGHT+IEHc9dUPxBPGGAoggne3GgaAZbsDhw2Vhe06jhbDMP9tQ2+phjNgnM6qdea0CJRvuzQPpomeSJSVMY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ef11:0:b0:dbe:9dbe:adb6 with SMTP id
 g17-20020a25ef11000000b00dbe9dbeadb6mr910754ybd.4.1704475795245; Fri, 05 Jan
 2024 09:29:55 -0800 (PST)
Date: Fri, 5 Jan 2024 09:29:53 -0800
In-Reply-To: <CAHk-=wi-i=YdeKTXOLGwzL+DkP+JTQ=J-oH9fgi2AOSRwmnLXQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240104154844.129586-1-pbonzini@redhat.com> <CAHk-=wi-i=YdeKTXOLGwzL+DkP+JTQ=J-oH9fgi2AOSRwmnLXQ@mail.gmail.com>
Message-ID: <ZZg8kbb3-riiLbrb@google.com>
Subject: Re: [GIT PULL] Final KVM fix for Linux 6.7
From: Sean Christopherson <seanjc@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	peterz@infradead.org, paulmck@kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Jan 05, 2024, Linus Torvalds wrote:
> On Thu, 4 Jan 2024 at 07:48, Paolo Bonzini <pbonzini@redhat.com> wrote:
> >
> > * Fix Boolean logic in intel_guest_get_msrs
> 
> I think the intention of the original was to write this as
> 
>         .guest = intel_ctrl & ~(cpuc->intel_ctrl_host_mask | pebs_mask),
> 
> but your version certainly works too.

Ha!  That's what I suggested too, clearly Paolo is the weird one :-)

