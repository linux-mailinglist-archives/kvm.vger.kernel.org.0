Return-Path: <kvm+bounces-5679-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DEC53824921
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 20:35:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 01B501C22655
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 19:35:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F6672E648;
	Thu,  4 Jan 2024 19:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ptYFktOZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F25C2E40E
	for <kvm@vger.kernel.org>; Thu,  4 Jan 2024 19:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dbe9e13775aso1218213276.1
        for <kvm@vger.kernel.org>; Thu, 04 Jan 2024 11:33:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704396802; x=1705001602; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=CN9HeZvjoKV2Wbxa5HUcERhzb0PDW7VNeTNnQhNqYY4=;
        b=ptYFktOZ81SR9eU2hJ+qphSNARh22huNILugdiXABtaA0IADQU+cv81LCFtAjRS8mx
         NTIYJFZsbntDvn+46Ee6iRusV8W1RabwWXU8Qtzzg26Xm3rXhrzmY2euURhjsS6kXIhV
         U8FaoCCh7FK4wolJvtK+3mkwSAPrfl3YUMGiuZxT/yq+3rkyeorWGzGL3y+Qpac+uSE8
         3JA551Y7KREzM3B1irlYMDainzDCHo/DSqUSz6W5FnBGSCmF77HI5j/ORnQuMZSH7gaU
         BaBeZa8JBU5BehP9MFi+zjGBlWsGUSBWe3IXutxpAItgzpW/m5VPjIWZcP90RfGAZwqA
         W5kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704396802; x=1705001602;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CN9HeZvjoKV2Wbxa5HUcERhzb0PDW7VNeTNnQhNqYY4=;
        b=mdFth/QBZDQpnXyNyAJrpUasx0Qj5vNkQNSy1Ki95AcCdOFXeTZef2wealCcI78WcQ
         ObOKSWwNO/CJpnuc1QPzgDKIcQ3D6U3HwlkwV4quoTtp08eHymMtmfuUQrMnR0P0NtYz
         zB2s4Q/z5zwT9KpeHzfnk+96zImJCopV2PBIfHWyZQakPOG8Xq0trdzrK6IaJSRnh8UT
         TQCgLcJ9ZlHSTAyiWZT8Fy75tgznI+0TM5PBxWUeDSfa0/cEfb6Ttq4xcuJ0K1tAapxr
         mO3YTLPLQ6jygpI3QKQk3vmrsBi73HUcVVZKex7Mmak9l6aFtgoe+Wf+uvbXR4W6B2UX
         iwpw==
X-Gm-Message-State: AOJu0YxLUEGb2ks1P1GEJYOD71w6w+PxC8Aqx/f2PnWFBDwsK4tKRpsV
	FXphk7D2hemnaoxJOamF71XWjAV9QhRM9MUdDw==
X-Google-Smtp-Source: AGHT+IFT/g6O0Qb3XCPrLkmEfM9ghUwoCpSLZ0U8QfzItbGRmdDrzn0VvnHqW7rZg6pFB83y2uw+DVets8Y=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:8512:0:b0:dbd:99af:daba with SMTP id
 w18-20020a258512000000b00dbd99afdabamr354711ybk.5.1704396802607; Thu, 04 Jan
 2024 11:33:22 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  4 Jan 2024 11:33:03 -0800
In-Reply-To: <20240104193303.3175844-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240104193303.3175844-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20240104193303.3175844-9-seanjc@google.com>
Subject: [GIT PULL] KVM: x86: Xen change for 6.8
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

A single Xen fix (of sorts) to let userspace workaround buggy guests that don't
react well to KVM setting the "stable TSC" bit in Xen PV clocks.

The following changes since commit e9e60c82fe391d04db55a91c733df4a017c28b2f:

  selftests/kvm: fix compilation on non-x86_64 platforms (2023-11-21 11:58:25 -0500)

are available in the Git repository at:

  https://github.com/kvm-x86/linux.git tags/kvm-x86-xen-6.8

for you to fetch changes up to 6d72283526090850274d065cd5d60af732cc5fc8:

  KVM x86/xen: add an override for PVCLOCK_TSC_STABLE_BIT (2023-12-07 15:52:57 -0800)

----------------------------------------------------------------
KVM Xen change for 6.8:

To workaround Xen guests that don't expect Xen PV clocks to be marked as being
based on a stable TSC, add a Xen config knob to allow userspace to opt out of
KVM setting the "TSC stable" bit in Xen PV clocks.  Note, the "TSC stable" bit
was added to the PVCLOCK ABI by KVM without an ack from Xen, i.e. KVM isn't
entirely blameless for the buggy guest behavior.

----------------------------------------------------------------
Paul Durrant (1):
      KVM x86/xen: add an override for PVCLOCK_TSC_STABLE_BIT

 Documentation/virt/kvm/api.rst |  6 ++++++
 arch/x86/kvm/x86.c             | 28 +++++++++++++++++++++++-----
 arch/x86/kvm/xen.c             |  9 ++++++++-
 include/uapi/linux/kvm.h       |  1 +
 4 files changed, 38 insertions(+), 6 deletions(-)

