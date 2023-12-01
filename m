Return-Path: <kvm+bounces-3153-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6196780121C
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 18:54:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F3B16281D6D
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 17:54:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88ED34EB32;
	Fri,  1 Dec 2023 17:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RZMYDh2N"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4F57DF
	for <kvm@vger.kernel.org>; Fri,  1 Dec 2023 09:54:00 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5d39d74bc14so28198667b3.3
        for <kvm@vger.kernel.org>; Fri, 01 Dec 2023 09:54:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701453240; x=1702058040; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7I2xmkQJIO9gmB40TsiPhHZp1nP18HWgbQtG2aSxBoA=;
        b=RZMYDh2NNbp8iIV43eX1nnzZtTwQWjmpEPlIhYVxKXRppMIe4JG+VaeUwg2ZNt5EbL
         8JMKsOla5H+kXCc8HTKgkmrMHIZgIfxwaSEOMwGOTpd8J+GJoLImInJLsV8Mb6c8MIW6
         yDgFQKRkOVtbMB4ZDh6mbABn5ves5H24f0hJQLvchIdBhcUDWPjCxODwI5cqi1cwRviK
         6txy5wGekSIoPBbBqZTvBxFGA6kuxlyKSBT0IWbl4BGjFkIUiaAGJMuQdzMVFj1fuxXT
         vc94cgDKT6s1Oq1mc2tGa8wk3F/JeEDSPpfjp2XOdcNQPy9VbfCzZfzlKrAHmMlfG72J
         gmMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701453240; x=1702058040;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7I2xmkQJIO9gmB40TsiPhHZp1nP18HWgbQtG2aSxBoA=;
        b=HWPUQXlCtzb6mNBchOmoVdBOQ1DEMyQRTNWzldjVeac/coNLJqGWdmeL4arlSKyxII
         D2T8JKTsWFQJN0N/kUKSwnxU7c+1mQTxk9a/UtSy0rN2OLHAX4ZolhOrESeGejrpR075
         CEsQjgqfqPerH1GzV7oEvpf4DtLrONkSbyjw5PlVLtMYg/kWUvau66CSTFn/OBNqZmT+
         7wHp5ea9OmO7wcX0XSBVda33/9hc89lSk7yhUIbF9bDjrmhAt/QQmg6O7aDUnSqXBGP3
         lVrwqGZBAs+cDWDiz1WxUPk529rZKOEuIC2pjruwvL1Mmb4eB6ysxvR0juMGTlUK7k5t
         jB7g==
X-Gm-Message-State: AOJu0YzecsnX5kmSaIasKsWPgXP5R/nTyawm0rcE9J4vlGvpurSofeBJ
	XsWMC9kyUwaQT8nUZ0UtwVgmfdA4Tj0=
X-Google-Smtp-Source: AGHT+IHOZTV3fqnzutNIWSvk7FCLUL5Yiw4eUFmTIaK0HPqpGgvVq3LrS9NTFPvCHQ4Y4qIQQGlBn7fhmLk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:2e8f:b0:5d4:1846:3121 with SMTP id
 eu15-20020a05690c2e8f00b005d418463121mr91868ywb.8.1701453239917; Fri, 01 Dec
 2023 09:53:59 -0800 (PST)
Date: Fri, 1 Dec 2023 09:53:58 -0800
In-Reply-To: <20231110003734.1014084-2-jackyli@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231110003734.1014084-1-jackyli@google.com> <20231110003734.1014084-2-jackyli@google.com>
Message-ID: <ZWodtj_FM1feBPEM@google.com>
Subject: Re: [RFC PATCH 1/4] KVM: SEV: Drop wbinvd_on_all_cpus() as kvm mmu
 notifier would flush the cache
From: Sean Christopherson <seanjc@google.com>
To: Jacky Li <jackyli@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Ovidiu Panait <ovidiu.panait@windriver.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Ashish Kalra <Ashish.Kalra@amd.com>, 
	David Rientjes <rientjes@google.com>, David Kaplan <david.kaplan@amd.com>, 
	Peter Gonda <pgonda@google.com>, Mingwei Zhang <mizhang@google.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Nov 10, 2023, Jacky Li wrote:
> Remove the wbinvd_on_all_cpus inside sev_mem_enc_unregister_region() and
> sev_vm_destroy() because kvm mmu notifier invalidation event would flush
> the cache.

This needs a much longer explanation of why this is safe.  This might also need
an opt-in, e.g. if userspace is reusing the memory for something else without
freeing it back to the kernel, and thus is relying on KVM to do the WBINVD.

The key thing is that userspace can access the memory at any time and _can_ do
CLFLUSH{OPT} if userspace wants to do its own conversions.  I.e. the WBINVD doesn't
protect against a misbehaving corrupting guest/userspace data.  But it's still
possible that userspace is relying on the WBINVD, and thou shalt not break userspace.

