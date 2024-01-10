Return-Path: <kvm+bounces-5959-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B1C6C8291F2
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 02:15:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B0527287F88
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 01:15:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5F262112;
	Wed, 10 Jan 2024 01:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="j1Dq/0sU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D49D6EC7
	for <kvm@vger.kernel.org>; Wed, 10 Jan 2024 01:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5e6fe91c706so61044057b3.2
        for <kvm@vger.kernel.org>; Tue, 09 Jan 2024 17:15:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704849336; x=1705454136; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mORrEHldp2qawKkikf9wfX27vt6z2DPQ9oCLXkJKW8A=;
        b=j1Dq/0sU3fi7kMu99PU9AsJyFwxIKVtslB3d+bqQb7WIPf/f/pIA33ykBOWUFs94bq
         mGff7EpnhIOUPcx7k4lIaBx+po8G63fh/eQX+hWdIzR2WKlXCOBmhZUC7c5TWXLJnkbF
         RUjZVE4lYOe/5Ur3MkbYhvcdOHLGjf9WzQzh7TkaDyPC5qVdpHd/KCYmCdFI08XBVXhZ
         5MXuVsDMfGEul2/kKyuQwPXsTMAmWTUBiuFRMJq8o44/BZAU1pTafn2vIB9ajnP5RtgK
         uS0qO/VVnJQSWpy9qzehqFqtnE/GIRdjXUmiwb8nMF/WGO/H2TDyasBiWyVsbW2K/fR/
         ar3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704849336; x=1705454136;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mORrEHldp2qawKkikf9wfX27vt6z2DPQ9oCLXkJKW8A=;
        b=aD2XyD2tD8PW4baQAUqGeLdx1gspZBCsYsuGB23fHbt0K3xyECtu/qODLmX3v5Fthr
         IiNv2FFtEFOvM9cnlghcEmB1qfXY6p7fUxmFN9dXh98cI+JIpYBmDe0cXjdwKZ5X4dn+
         maVX2HQqxN8Uleay3slJUtrlNdps4h5OGJ3bxP6x8l0fjqLinQ7umA0D4fBY9j9tFjsT
         YJ17HB9rzIaeZS3mbQRUPnB4fLTnxzqAz9dvaGzrxevuWRH4A+yiIUiBAin5xIWUk0pO
         g3oDkOuV1/P+N4QleVDSIkQOGjeCNAiW5RVB7O9WrsdesMgR9T1kn96qG2kW+FotbO+L
         kB9w==
X-Gm-Message-State: AOJu0YwuyFgPZQjUadt4jYUR+Q6vwexIJ6aVZO3SZGHZs3dSARk5vtzw
	I/Aq0/CMG7gIwgmCDca8Xpg2jAED1OwVQH9u2w==
X-Google-Smtp-Source: AGHT+IFH/3iIKuhgJURtlanPFm1lyxsjMB85egFxSZXFz5VcqFxHpgjXvUYrMgAahsBcBHntAZu8fNpdp6o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1348:b0:dbc:c697:63bd with SMTP id
 g8-20020a056902134800b00dbcc69763bdmr99703ybu.0.1704849335881; Tue, 09 Jan
 2024 17:15:35 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  9 Jan 2024 17:15:29 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20240110011533.503302-1-seanjc@google.com>
Subject: [PATCH 0/4] KVM: Async #PF fixes and cleanups
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	David Matlack <dmatlack@google.com>, Xu Yilun <yilun.xu@linux.intel.com>, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Fix a use-after-module-unload bug in the async #PF code by ensuring all
workqueue items fully complete before tearing down vCPUs.  Do a bit of
cleanup to try and make the code slightly more readable.

Side topic, I'm pretty s390's flic_set_attr() is broken/racy.  The async #PF
code assumes that only the vCPU can invoke
kvm_clear_async_pf_completion_queue(), as there are multiple assets that
are effectively protected by vcpu->mutex.  I don't any real world VMMs
trigger the race(s), but AFAICT it's a bug.  I think/assume taking all
vCPUs' mutexes would plug the hole?

Sean Christopherson (4):
  KVM: Always flush async #PF workqueue when vCPU is being destroyed
  KVM: Put mm immediately after async #PF worker completes remote gup()
  KVM: Get reference to VM's address space in the async #PF worker
  KVM: Nullify async #PF worker's "apf" pointer as soon as it might be
    freed

 include/linux/kvm_host.h |  1 -
 virt/kvm/async_pf.c      | 79 ++++++++++++++++++++++++++++------------
 2 files changed, 55 insertions(+), 25 deletions(-)


base-commit: 1c6d984f523f67ecfad1083bb04c55d91977bb15
-- 
2.43.0.472.g3155946c3a-goog


