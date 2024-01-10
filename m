Return-Path: <kvm+bounces-5998-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 84B5A829BE8
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 14:59:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 340F2284E0A
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 13:58:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A0A0495E6;
	Wed, 10 Jan 2024 13:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ws/erX7F"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9A4648CE2
	for <kvm@vger.kernel.org>; Wed, 10 Jan 2024 13:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-6d9d3a7d926so2257611b3a.2
        for <kvm@vger.kernel.org>; Wed, 10 Jan 2024 05:58:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704895127; x=1705499927; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9yJOVt2fYXAhGst0EbC8nRC+5WQ9DxreW7FkWtyA+mY=;
        b=Ws/erX7Ft1cpiAuJL/WVJJfxABEyB4OyTGGRT62vlNaRDg5EPxIkf1hIbJl391pNVi
         fT1Ps6WRREwrEd9yEaK25y63ADwzBBfUirwIJz4I/E19xsI4XUjevOmgS2GBoyh8nw4L
         b+ocsomOKN9gTWvphTNYa644E5MOP8D1RAiynvc4qFa+Z7r5imiHUVIVqt69vgNKdV8H
         iJaahpz/5b9Md4e9AwIfgjesyd49UqXVEPLZEOtBbk3Rt7ec/mjhumhVw9vOfwX9F3di
         ock+SFbqlHgf4c15F0NEl2OMrorZypmT14QriZq6QHgR52F3oaCzwbptcbbRKW6bv7W/
         JLzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704895127; x=1705499927;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9yJOVt2fYXAhGst0EbC8nRC+5WQ9DxreW7FkWtyA+mY=;
        b=ClEaYRGTusaDBUHvZ8XuWEaCKMe8QK6+qNoNVPdW6+VB4bRA1lQ50N7HUT3CMeM0EU
         SSVp0oTkmEvkF8r07wAnt6+tdbIATtg0rRrgOTbOJFnmdoeKx7NK0XHgXmAouzvc2B0D
         gP6CpHgrOTkmu064wLwshPEpanszlw7nkEuYkW7qc5orzl71AuSf1kbLBJiSkzWJooW6
         bvUyNUDGprJ7LG7Cs2mCvTm2A0ThF/yEm08Pxc1u4mofYD6KF5xKk9bha2/ZaoS3PDWv
         ftpgWPmeeyxwl3UElqvt1F/hw4tFEMqpNgLWRg6sFtNDszhfAn93GxjpXmBsZss8SomU
         mZ7A==
X-Gm-Message-State: AOJu0YzHf4Q7o+nwKj6vd5Hd7Z483MolrzYkMW0ZSDC0uTsmqtk+dIhm
	rF7BhsskxTWxOGP3uHUSXIAgrQCNWLa9qbBCNQ==
X-Google-Smtp-Source: AGHT+IHlAHfm/IwBLr1/pZZ/l+PJcn/YAmjAD6wvtM9btPqhE+gOrrqppwNVZ5KZFG4njJ5diHWEXFoubRA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:39a6:b0:6d9:b26d:d05d with SMTP id
 fi38-20020a056a0039a600b006d9b26dd05dmr86172pfb.6.1704895127164; Wed, 10 Jan
 2024 05:58:47 -0800 (PST)
Date: Wed, 10 Jan 2024 05:58:45 -0800
In-Reply-To: <20240110-a69620ca0ebce509dc54f025@orel>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240109230250.424295-1-seanjc@google.com> <20240109230250.424295-16-seanjc@google.com>
 <20240110-a69620ca0ebce509dc54f025@orel>
Message-ID: <ZZ6ilWZCDVnhhjYI@google.com>
Subject: Re: [PATCH v10 15/29] KVM: selftests: Add pmu.h and lib/pmu.c for
 common PMU assets
From: Sean Christopherson <seanjc@google.com>
To: Andrew Jones <ajones@ventanamicro.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jim Mattson <jmattson@google.com>, Jinrong Liang <cloudliang@tencent.com>, 
	Aaron Lewis <aaronlewis@google.com>, Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Jan 10, 2024, Andrew Jones wrote:
> On Tue, Jan 09, 2024 at 03:02:35PM -0800, Sean Christopherson wrote:
> > From: Jinrong Liang <cloudliang@tencent.com>
> > 
> > Add a PMU library for x86 selftests to help eliminate open-coded event
> > encodings, and to reduce the amount of copy+paste between PMU selftests.
> > 
> > Use the new common macro definitions in the existing PMU event filter test.
> > 
> > Cc: Aaron Lewis <aaronlewis@google.com>
> > Suggested-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
> > Co-developed-by: Sean Christopherson <seanjc@google.com>
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  tools/testing/selftests/kvm/Makefile          |   1 +
> >  tools/testing/selftests/kvm/include/pmu.h     |  97 ++++++++++++
> >  tools/testing/selftests/kvm/lib/pmu.c         |  31 ++++
> 
> Shouldn't these new files be
> 
> tools/testing/selftests/kvm/include/x86_64/pmu.h
> tools/testing/selftests/kvm/lib/x86_64/pmu.c

/facepalm

I'm glad at least one of us is paying attention.  If no one objects to not sending
yet another version, I'll squash the below when applying.

--
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index ab96fc80bfbd..ce58098d80fd 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -23,7 +23,6 @@ LIBKVM += lib/guest_modes.c
 LIBKVM += lib/io.c
 LIBKVM += lib/kvm_util.c
 LIBKVM += lib/memstress.c
-LIBKVM += lib/pmu.c
 LIBKVM += lib/guest_sprintf.c
 LIBKVM += lib/rbtree.c
 LIBKVM += lib/sparsebit.c
@@ -37,6 +36,7 @@ LIBKVM_x86_64 += lib/x86_64/apic.c
 LIBKVM_x86_64 += lib/x86_64/handlers.S
 LIBKVM_x86_64 += lib/x86_64/hyperv.c
 LIBKVM_x86_64 += lib/x86_64/memstress.c
+LIBKVM_x86_64 += lib/x86_64/pmu.c
 LIBKVM_x86_64 += lib/x86_64/processor.c
 LIBKVM_x86_64 += lib/x86_64/svm.c
 LIBKVM_x86_64 += lib/x86_64/ucall.c
diff --git a/tools/testing/selftests/kvm/include/pmu.h b/tools/testing/selftests/kvm/include/x86_64/pmu.h
similarity index 100%
rename from tools/testing/selftests/kvm/include/pmu.h
rename to tools/testing/selftests/kvm/include/x86_64/pmu.h
diff --git a/tools/testing/selftests/kvm/lib/pmu.c b/tools/testing/selftests/kvm/lib/x86_64/pmu.c
similarity index 100%
rename from tools/testing/selftests/kvm/lib/pmu.c
rename to tools/testing/selftests/kvm/lib/x86_64/pmu.c

