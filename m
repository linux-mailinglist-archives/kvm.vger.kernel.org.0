Return-Path: <kvm+bounces-3183-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 13B758017D8
	for <lists+kvm@lfdr.de>; Sat,  2 Dec 2023 00:36:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 42F951C20ACF
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 23:36:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89E993F8F7;
	Fri,  1 Dec 2023 23:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="R8W3h1wd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C79451A4
	for <kvm@vger.kernel.org>; Fri,  1 Dec 2023 15:36:35 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5d10f5bf5d9so45073657b3.3
        for <kvm@vger.kernel.org>; Fri, 01 Dec 2023 15:36:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701473795; x=1702078595; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/jHCS6F3lbvEQJJqHlAwpq8uP8HzWRDFHsUBTwOKoYA=;
        b=R8W3h1wd7UWGnDg68u+W+ivoAEIXvIJkWDkf/TLNzgknfMOTw/eYxTjtju4KYwVV9e
         o1uEJQTgGDTSACoz+TD19Uv1u3XxBPXX4O+7vlmwnGRK29I37vlcqxyrw4IKq9nmrXeK
         iFgolvGCccGwjcnpa4/vlVSf235nMBJOyilo7U5J2CXEl7Usiic4y/upMCJgYgejFz2n
         IaZWX8lU6sLfOclRs+6MRju3piT5kpizbS3uptRCfgrjIf27gPnNqNt7YH2JPYYqeI6/
         3xD7lOg7dvB/XjMyU4fDya9IOZOJQhooTm2HT5N9WUJ9b1i+asNFusuGPZAkXOK4By1T
         J3VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701473795; x=1702078595;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/jHCS6F3lbvEQJJqHlAwpq8uP8HzWRDFHsUBTwOKoYA=;
        b=f9Wnm026bJr4kn+gkpgG+o2/kxSAF3jmO4jj//JAsmNTmTRciMF1j3Nx31GwG4BA6o
         M8BXgCxXITw87rjCkv8RLqaN4HGadezhoKUMYtcXB9GPxavndDGGVGm/+xnG21kVIu7U
         bL5JANJISxDHTF227tsEJnaL3Mh4ReoqJAqNjlma+9ZV4PAzXhFfr/XwreIiZxT0E0rv
         M3xjCMNra6d1uZuKAy+HIcHBIhYORk1UI5IlMujscg/HyVMZe4ofvT+2G/85kDuKNvsI
         T2BglMHw0hRFYPUtcx0r6VVl3HXAargIRGdr97swLLfHNpB9N5g3w/sLW9JYWJvUVYF3
         qOdw==
X-Gm-Message-State: AOJu0YyxLIBmZUvXLe+bL02XRgb0BQS3rznPjplI35/2OZReDAaxeiu/
	xDuu6v2lFS8cDRlV/w5EwkJoi9di1Ns=
X-Google-Smtp-Source: AGHT+IGlq9gyyFjUbd1DEYgHFW0mjeWZjtYRN22TpnbSC7OjLFEQ2FItPU5EgWmocploWturhKQe3NO3jfs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:3202:b0:5d7:36b4:94da with SMTP id
 ff2-20020a05690c320200b005d736b494damr3412ywb.10.1701473795112; Fri, 01 Dec
 2023 15:36:35 -0800 (PST)
Date: Fri,  1 Dec 2023 15:30:37 -0800
In-Reply-To: <20231129224916.532431-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231129224916.532431-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.rc2.451.g8631bc7472-goog
Message-ID: <170144735827.840391.573598926440531573.b4-ty@google.com>
Subject: Re: [PATCH v2 0/4] KVM: selftests: Annotate guest printfs as such
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="utf-8"

On Wed, 29 Nov 2023 14:49:12 -0800, Sean Christopherson wrote:
> Fix a handful of broken guest assert/printf messages, and annotate guest
> ucall, printf, and assert helpers with __printf() so that such breakage is
> detected by the compiler.
> 
> v2:
>  - Annotate the relevant helpers. [Maxim]
>  - Fix all other warnings (v1 fixed only the MWAIT error message)
> 
> [...]

Applied rather quickly to kvm-x86 selftests, as I want to get these a few days
of exposure in -next before sending them to Paolo for 6.7-rc5.  I'll happily do
fixups if there is any feedback that needs to be addressed.  Thanks!

[1/4] KVM: selftests: Fix MWAIT error message when guest assertion fails
      https://github.com/kvm-x86/linux/commit/1af3bf2befc0
[2/4] KVM: selftests: Fix benign %llx vs. %lx issues in guest asserts
      https://github.com/kvm-x86/linux/commit/4d53dcc5d0bc
[3/4] KVM: selftests: Fix broken assert messages in Hyper-V features test
      https://github.com/kvm-x86/linux/commit/f813e6d41baf
[4/4] KVM: selftests: Annotate guest ucall, printf, and assert helpers with __printf()
      https://github.com/kvm-x86/linux/commit/1b2658e4c709

--
https://github.com/kvm-x86/linux/tree/next

