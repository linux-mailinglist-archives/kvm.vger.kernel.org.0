Return-Path: <kvm+bounces-3140-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BFAE3800F02
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 17:08:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5F1CAB2137D
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 16:08:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A0A04BAA2;
	Fri,  1 Dec 2023 16:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PdgBRUhj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EFA110D0
	for <kvm@vger.kernel.org>; Fri,  1 Dec 2023 08:08:33 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-6c334d2fd4cso2873201b3a.2
        for <kvm@vger.kernel.org>; Fri, 01 Dec 2023 08:08:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701446913; x=1702051713; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SUzSIwk7HT8dyZz+ygqaaq2fkvYNgaSclIN2mCrDJ6o=;
        b=PdgBRUhjthS7KBRiwn9qGh4V39kf4R+1Ta/ym7Guve8es/eT1EcS3ovPlDIgfcssWd
         l5AzvSclXR+CC0L6ltMtkEcXfBt1a6ZwBgY4dSFGobdK1R38BCY5In6TdxuNxyXDV59D
         A5+PycDTR6lVoenkzpS8z17cpJA7AA7XN83oeRUcOfhsj3zbsZVQlo+pnsKmjjYa5Nyi
         NmK1gYX3p+7LeKgFxSHYXcV5MkB7MzwU8bMLptWZL0Fu2PVg8ScBuog7s//7kJFIYGnQ
         MKi8Oy15uanHH80O9Wc+O0Wf6pAhN+BGUVUK0QBguAon8D2GRr1HQmaZpmjUEfKxTF2L
         97uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701446913; x=1702051713;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SUzSIwk7HT8dyZz+ygqaaq2fkvYNgaSclIN2mCrDJ6o=;
        b=G9PWOmjO71hp4djhK5kpd5eOdv1BWUdHytiaZvhmxZvs+G73eTC1aAO5HOW1xgtP1q
         /3p/vz+2JJbeyCNJOGLnRXksuOJjBpkDhMkQ2qVKNAFpa+WZSg/zNXmy4VE1jRZXC1cL
         B5UqXvDlW4fbsyUi3HVr+zs8uxGrLwKsqRkcf3m7UwzC4vlRnoszLf6tFCI9pXFWnGMx
         Agohouk1zbjHcA/RLQZr5SfH5PL45RcCR0ReAWhsMVVF1yUI1kbFAQUIHZPgrxfUSJTr
         7tAV+4NtRjwCNPbaduaE1Hc3aiUmpHn+3s63JhkLtuKHhX89q0Lp28CqbY2RvS20Zv/n
         l9NQ==
X-Gm-Message-State: AOJu0YzDvtzxZLzx7UivNC4Gedp36U+A12qKtzHpgXNle/yP9n2xBDbU
	Rn4ehHved/jN1W0RHIimgCvKCOg4z2g=
X-Google-Smtp-Source: AGHT+IEAgiPoi8owubrQZyENMwuhRbFd2eI1EsNr015bLVPqPEqSXeSZt+Sd/CSW+w3SJFOBSyfHE1Otll0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:885:b0:6cd:d8c6:5f36 with SMTP id
 q5-20020a056a00088500b006cdd8c65f36mr1468980pfj.3.1701446912742; Fri, 01 Dec
 2023 08:08:32 -0800 (PST)
Date: Fri, 1 Dec 2023 08:08:31 -0800
In-Reply-To: <ZWjfjAnZcomGa1Ey@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231130182832.54603-2-ajones@ventanamicro.com> <ZWjfjAnZcomGa1Ey@google.com>
Message-ID: <ZWoE_55_6q7lqJvo@google.com>
Subject: Re: [PATCH] KVM: selftests: Drop newline from __TEST_REQUIRE
From: Sean Christopherson <seanjc@google.com>
To: Andrew Jones <ajones@ventanamicro.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, 
	maz@kernel.org, oliver.upton@linux.dev
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 30, 2023, Sean Christopherson wrote:
> On Thu, Nov 30, 2023, Andrew Jones wrote:
> > A few __TEST_REQUIRE callers are appending their own newline, resulting
> > in an extra one being output. Rather than remove the newlines from
> > those callers, remove it from __TEST_REQUIRE and add newlines to all
> > the other callers, as __TEST_REQUIRE was the only output function
> > appending newlines and consistency is a good thing.
> > 
> > Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
> > ---
> > 
> > Applies to kvm-x86/selftests (I chose that branch to ensure I got the
> > MAGIC_TOKEN change)
> 
> Heh, and then I went and created a conflict anyways :-)
> 
> https://lore.kernel.org/all/20231129224042.530798-1-seanjc@google.com
> 
> If there are no objections, I'll grab this in kvm-x86/selftests and sort out the
> MAGIC_TOKEN conflict.

Actually, I misread the patch.  I thought you were removing newlines, not adding
them.  My thinking for TEST_REQUIRE() is that it should look and behave like
TEST_ASSERT(), not like a raw printf().  I.e. the caller provides the raw message,
and the framework handles formatting the final output.

