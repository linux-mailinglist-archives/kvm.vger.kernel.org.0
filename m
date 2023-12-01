Return-Path: <kvm+bounces-3047-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6536D800151
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 02:56:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 96ECF1C20BCB
	for <lists+kvm@lfdr.de>; Fri,  1 Dec 2023 01:56:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A83DE468A;
	Fri,  1 Dec 2023 01:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2IDYwr3z"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6E23A0
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 17:56:07 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5d33b70fce8so21090727b3.0
        for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 17:56:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701395767; x=1702000567; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Gpg0jRMfZzPs+DxGvN7fA6pxlWT05UdkEs/pO3pcReg=;
        b=2IDYwr3zmhFsRLV5KrY1UDgjkBoZb36qbFtvi6bwzpMY+6k0rRNVBkstydlj52Fuf6
         S929fjQVQ4I5Ngv0WWFSDlITPwIcJ+3d9rAA8v1hV7EkqL1QDENupL6SnbnIJDnUW599
         FCTfcWYcwPueHvjSp0Kn950WdADmJUQTF/kwCNXVxBT9+EL6q0EgoPC19OXssgxpx24W
         iI9mZv2fm0afxOVTxGl675ZauJAZ4ALslknmjMsWEGr3ZLEodNfNWkrjcvHuTPRzJkyJ
         kO6nT+cHT9oAry8KGfMWDIfyhPtnYDci+WYehW3XWCuSx97OcJ89eaOqSXk/pwSpsnQO
         dQVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701395767; x=1702000567;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Gpg0jRMfZzPs+DxGvN7fA6pxlWT05UdkEs/pO3pcReg=;
        b=FrFEEQO4nwtoipTgWi16n9Hv1bGsiLcSRO+hav0Xz2qCyiQgTN7Q8RIL8e7nQNIH/v
         8wXxIuGP3cND8zNq9SVAOoHwovFb99Dn3bde5utyW+S3Q6sFIBLHhrn3kbJ7F3wvb7TH
         ZjsUSXJqypLzrBFqL+F8bYhqiOYp28hNZ0fU7d9eh/GSgAxy01gqXGKe+TSH2dWl2gEC
         4pm20ug5rwvNHTYqtdJDKSU1yMr29ICDynBZM5CDl3ffJ+NwI31miZTWg0uVHVbe0s1X
         Z3pci2LmFJvTGlWFmA2CfZ9MndIfVp9GpaSYt4dGJcxK4vtHT3/uuyoqRbx2UrU5Fxgy
         f+Qg==
X-Gm-Message-State: AOJu0YyXpknkhCEO7DOHENB2y3cMbK4lQrqJlm0DYlxqjRUeFErKW+wB
	RfsO6ta3b/CJTzTSdwGHS2GxsJAZ+hY=
X-Google-Smtp-Source: AGHT+IFv6EtpNEyk7jG2a6+OFieWqgV/IdpgQSQjtjX702lGZ3QboxxBNrX7OCdF0p//ZUIQ+fbkIwWyrdc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:ff08:0:b0:5cb:1bf4:ce09 with SMTP id
 k8-20020a81ff08000000b005cb1bf4ce09mr798787ywn.2.1701395767042; Thu, 30 Nov
 2023 17:56:07 -0800 (PST)
Date: Thu, 30 Nov 2023 17:52:22 -0800
In-Reply-To: <20231125083400.1399197-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231125083400.1399197-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.43.0.rc2.451.g8631bc7472-goog
Message-ID: <170137684485.660161.8230111667906795222.b4-ty@google.com>
Subject: Re: [PATCH v2 0/4] KVM: x86/mmu: small locking cleanups
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: mlevitsk@redhat.com
Content-Type: text/plain; charset="utf-8"

On Sat, 25 Nov 2023 03:33:56 -0500, Paolo Bonzini wrote:
> Remove "bool shared" argument from functions and iterators that need
> not know if the lock is taken for read or write.  This is common because
> protection is achieved via RCU and tdp_mmu_pages_lock or because the
> argument is only used for assertions that can be written by hand.
> 
> Also always take tdp_mmu_pages_lock even if mmu_lock is currently taken
> for write.
> 
> [...]

Applied to kvm-x86 mmu, thanks!

[1/4] KVM: x86/mmu: remove unnecessary "bool shared" argument from functions
      https://github.com/kvm-x86/linux/commit/2d30059d38e6
[2/4] KVM: x86/mmu: remove unnecessary "bool shared" argument from iterators
      https://github.com/kvm-x86/linux/commit/59b93e634b40
[3/4] KVM: x86/mmu: always take tdp_mmu_pages_lock
      https://github.com/kvm-x86/linux/commit/4072c73104f2
[4/4] KVM: x86/mmu: fix comment about mmu_unsync_pages_lock
      https://github.com/kvm-x86/linux/commit/9dc2973a3b20

--
https://github.com/kvm-x86/linux/tree/next

