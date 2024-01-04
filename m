Return-Path: <kvm+bounces-5671-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FF6D824910
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 20:33:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 459CF1C227E0
	for <lists+kvm@lfdr.de>; Thu,  4 Jan 2024 19:33:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6DAC2C69B;
	Thu,  4 Jan 2024 19:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lmxmPyaI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030AA2C686
	for <kvm@vger.kernel.org>; Thu,  4 Jan 2024 19:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-6d9b2241a14so813742b3a.1
        for <kvm@vger.kernel.org>; Thu, 04 Jan 2024 11:33:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704396786; x=1705001586; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hdXwbs9LXy+0MwagLGqoXAsQZtAQ7ijReYfWL3XfMTU=;
        b=lmxmPyaI5554Bl4f4QQqr3TMDj9uuRhbxV8espjfnIKHAglZqV8CxtK5CmfGhCpCLn
         JxRC0bdpWOKsR9Kf4GK/dGqu6yS/VEaY7JcFEzAzLU6bWnry8pl/YC2NG/V64I8tSncj
         +1Z9/9d4m+7VH+/sRuZYsdW5j6ChARLkm97VZjkcobG+006Qi223fiOhdQQSr2CFurTa
         h/zmo1iuJiUhhvTOK69XmnQa3+E8aDDc1YKgj4oC+Rddj9InSYfEOkYH9zYgEVXAMe3T
         1dPYRv9RxeRcYxFTAP04XLw5fIkBS1mSvaqclnCxQUuNWWQBhdUptdgdsSFAwyv501cs
         x59A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704396786; x=1705001586;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hdXwbs9LXy+0MwagLGqoXAsQZtAQ7ijReYfWL3XfMTU=;
        b=Jde+iczSpewKwzfHCi4cBZhxUAmGEQI4t3kpLw5xI8BX4iQwE3VPfUGKL4kAeJ23vF
         LZqHtCVUbCs5vH4mPAasw+fj6dTe2TeJV1qivAKBY7qr1qpZldwNB98TCyvuvBI3cN+x
         Ym9hO4uMKP9ZFGU3JTtiWD36Fc9a9yzIxjsEB6fmO6DqGOlg/afgawCz7hEbCACSCqAW
         PTECbenPlr/zK6C0jMs3iMAVqkufPDpSIQ6IN3GN5s//JsvMWX3upMK6D9pdZ6xlTjOX
         k2iERMp910tGYfbCxxQEjOqYcQEDHFlUU+CpzCNpDIxRo1rgUxa6BHDwzbY1lDGu4Q7u
         p9xA==
X-Gm-Message-State: AOJu0YyGTnQuPS1oTn2zYlIyQmvSUVA+Jr3+wszdDITrXCLXwgNReSr2
	YvXnl6IRX89qDXjuYUX43X4h47eNU16LovEVAQ==
X-Google-Smtp-Source: AGHT+IEu1onX8LGcKX/vA29+4J8xdamwvAFAYUdMez94XtQ6ie+K8ekr1Fj7zrHbjaYkcovO3R0Ck2EX6HU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:390b:b0:6da:86e5:1645 with SMTP id
 fh11-20020a056a00390b00b006da86e51645mr141573pfb.6.1704396786344; Thu, 04 Jan
 2024 11:33:06 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  4 Jan 2024 11:32:55 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20240104193303.3175844-1-seanjc@google.com>
Subject: [GIT PULL] KVM: x86 pull requests for 6.8
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Pull requests for 6.8.  My apologies for not getting some of these sent earlier.
Between travel, time off, and end-of-year reviews, December was a bit of a
disaster.

  [GIT PULL] KVM: non-x86 changes for 6.8
  [GIT PULL] KVM: x86: Hyper-V changes for 6.8
  [GIT PULL] KVM: x86: LAM support for 6.8
  [GIT PULL] KVM: x86: Misc changes for 6.8
  [GIT PULL] KVM: x86: MMU changes for 6.8
  [GIT PULL] KVM: x86: PMU changes for 6.8
  [GIT PULL] KVM: x86: SVM changes for 6.8
  [GIT PULL] KVM: x86: Xen change for 6.8

