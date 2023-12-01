Return-Path: <kvm+bounces-3044-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B60FA80014A
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 02:55:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 715DE2816B9
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 01:55:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DEC417CF;
	Fri,  1 Dec 2023 01:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="o1lnoNZ3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DCD0F4
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 17:55:09 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-6cdf7577159so1212324b3a.1
        for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 17:55:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701395709; x=1702000509; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=b7iAppoCIGt7sEqxpQhMef/LhAid+9ah/Ift0A0NOXg=;
        b=o1lnoNZ3sSVYOnyXW7F4b6fXUKQAgHDcYo1Ukq1zIIN6AO7T9+iirDjPyxiHO54BLr
         H77nORb/laJ8NJ3PdDZ7CkRxMI/tMgyjo42eqc/891x1zxb3J7bauDHLop/QpJRvcMLN
         hH7Y8cxTeSM6AiIeebGxADeRD0yYClEa3p1x7fX60FGGG9RMdtfdYHZGC/MoYTMuI+DM
         unhbNrqPC6TVRXMq9lf1lel7btY01mY9N1B5V5VhWtkiVARvoxPgMhYxgyTsEKOPBXRt
         c3Od2oWlOc1a3r2AQ2fPvE7k83KY2DGQuIj4HoHMOH+bydfpd/KC+pRwrYQIagS6Ks/m
         NRgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701395709; x=1702000509;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b7iAppoCIGt7sEqxpQhMef/LhAid+9ah/Ift0A0NOXg=;
        b=ZIHzXVQ3v3xAr21jp4jU/yjvrvGudfkDO/GiTy3Y/VNXozAQkD7gmIwpPv8jmE9IEb
         ZnXXF8yqFQxpiE5+dR5wnk4rFTx+MFC1vwZaePLgI9FPv8JZJFdMnK3NaqLc8fH/wKSE
         2c8ndcl+2rXp4ZeJydHuB+Z4st+bVeDwUGJoFkzFOiNZRXxLhmgPHaoGRVfhROBGxdV+
         A4Fkx6qOnw3mJSdliJYQvUCXitgdy+OAnacwZZlbfXdBv21uPXJDmgXvBDtINlSOcYr7
         FC78bSHARpeH+6f1sCWZ3EGE7+qHeZeJql94sCbVvnpwmJlg/+tc6Sx/o6tr3FuECr0d
         /4fQ==
X-Gm-Message-State: AOJu0Yz5Sy2Rys0FA5Mb+9UjgSpGTzoEBZnAdec+TO0Z0aSUqnSV+7tW
	TTB/ARN+Y7jP10PSolWawCOAb+es7Bk=
X-Google-Smtp-Source: AGHT+IEAAUZzAhU1ZcFzkmNbSmg/hBxjb42tO8EiKmbuAykScu2XpQrFmEp3XB/fXKQEpskqi5B2wKBq8U8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1888:b0:6cd:da30:4d75 with SMTP id
 x8-20020a056a00188800b006cdda304d75mr1200740pfh.4.1701395708904; Thu, 30 Nov
 2023 17:55:08 -0800 (PST)
Date: Thu, 30 Nov 2023 17:52:14 -0800
In-Reply-To: <20231018151906.1841689-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231018151906.1841689-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.rc2.451.g8631bc7472-goog
Message-ID: <170137374226.619180.12045832358402230622.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86: Turn off KVM_WERROR by default for all configs
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="utf-8"

On Wed, 18 Oct 2023 08:19:06 -0700, Sean Christopherson wrote:
> Don't enable KVM_WERROR by default for x86-64 builds as KVM's one-off
> -Werror enabling is *mostly* superseded by the kernel-wide WERROR, and
> enabling KVM_WERROR by default can cause problems for developers working
> on other subsystems.  E.g. subsystems that have a "zero W=1 regressions"
> rule can inadvertently build KVM with -Werror and W=1, and end up with
> build failures that are completely uninteresting to the developer (W=1 is
> prone to false positives, especially on older compilers).
> 
> [...]

Applied to kvm-x86 misc, thanks!

[1/1] KVM: x86: Turn off KVM_WERROR by default for all configs
      https://github.com/kvm-x86/linux/commit/75bedc1ee90b

--
https://github.com/kvm-x86/linux/tree/next

