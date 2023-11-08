Return-Path: <kvm+bounces-1119-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6C747E4E74
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 02:10:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A1349281517
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 01:10:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3571B7EE;
	Wed,  8 Nov 2023 01:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HDMZZEDc"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B107C650
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 01:09:56 +0000 (UTC)
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3277F193
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 17:09:56 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1cc3130ba31so45257015ad.0
        for <kvm@vger.kernel.org>; Tue, 07 Nov 2023 17:09:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699405795; x=1700010595; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Oxu+k+SZ8kCvp94YTrpUeaCD1V6h4t1KJZzJ+BMwr/k=;
        b=HDMZZEDcRuqVut7+vucoEUa0WZjVN0VILC1+u8ThWBrwsfJCmxeqIRcOU+EfHvi6gv
         HYKv0CoXx7ixNs2oGgXiVnGd7mhqpSDNHIFmAXBm36CkE1GHsgtr0Gs77FPwNO5Ga6gn
         kIXpw4W7aeyqf9LaOKdoMwUGWuckP0LnuZm1NOe20FTC72j7Jl3Sv5fNWOc7MQTl7h+O
         MkkFhKfO7QgdVYhnExeJaPa0gF2Vpk1KJ6dwhjh/JDnGfb8x45ITlWDvE9tDo6SjBjUo
         HNnSWqeTBUeQyscB82moURsmzAQYyKsTcqdFmdib5Zay9XCWCJ0d4MzkTAptQLtUJE0j
         P6oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699405795; x=1700010595;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Oxu+k+SZ8kCvp94YTrpUeaCD1V6h4t1KJZzJ+BMwr/k=;
        b=uzEGFvhQja+wkxRsc+P0kXdST7A00edvCdK0igfLs5dqRTVq5rIF2bpyJsWKEaHXwS
         Achy2bnaIyWD3Lc4VBr/XMHXyoBLqh2K5P4mCVcdQYsHuNiBlsOT/fjceMuuakJSll3/
         cP+qE++Lm7UjAgllgovSZ09cpbXAhF9d7+xM3/JCrssA85ECEf2WAvH32yXyQgj/rmmF
         J5ppp2WKsWBMXMRDSU0i5GW/T1QIJkEv/f0LCLC1CZdgYZ6rub2i03L36JkWGxDzd/gU
         P/PBln1RI4R8TxZimS6DTmztNTzP2ac8sUKutay3ta3Q7ZCcbbqyNkjosB3JSpTteQBd
         V9yg==
X-Gm-Message-State: AOJu0YzBGOnUL6MU2ldOHiBA0ELdmFL+SUYsEnx30VGa6gjhvgusjE7K
	/bA4bzgFWX5SYhxciML2Z4+x3mDUADs=
X-Google-Smtp-Source: AGHT+IEX0TGbWBREr3RBzARDa6iU5dAUeynzl0NsrgqA8zi+AVKyQK6cZItSwsuP762i4QBcNpgy7AOO7BI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f80e:b0:1cc:2a6f:ab91 with SMTP id
 ix14-20020a170902f80e00b001cc2a6fab91mr11432plb.0.1699405795722; Tue, 07 Nov
 2023 17:09:55 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  7 Nov 2023 17:09:51 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231108010953.560824-1-seanjc@google.com>
Subject: [PATCH v2 0/2] KVM: selftests: Detect if KVM bugged the VM
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>, Michal Luczaj <mhal@rbox.co>, Oliver Upton <oliver.upton@linux.dev>, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Teach selftests' ioctl() macros to detect and report when an ioctl()
unexpectedly fails because KVM has killed and/or bugged the VM.  Because
selftests does the right thing and tries to gracefully clean up VMs, a
bugged VM can generate confusing errors, e.g. when deleting memslots.

v2:
 - Drop the ARM patch (not worth the churn).
 - Drop macros for ioctls() that return file descriptors.  Looking at this
   with fresh eyes, I agree they do more harm than good. [Oliver]

v1: https://lore.kernel.org/all/20230804004226.1984505-1-seanjc@google.com

Sean Christopherson (2):
  KVM: selftests: Drop the single-underscore ioctl() helpers
  KVM: selftests: Add logic to detect if ioctl() failed because VM was
    killed

 .../selftests/kvm/include/kvm_util_base.h     | 75 ++++++++++++-------
 tools/testing/selftests/kvm/lib/kvm_util.c    |  2 +-
 2 files changed, 51 insertions(+), 26 deletions(-)


base-commit: 45b890f7689eb0aba454fc5831d2d79763781677
-- 
2.42.0.869.gea05f2083d-goog


