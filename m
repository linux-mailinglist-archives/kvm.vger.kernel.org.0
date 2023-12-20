Return-Path: <kvm+bounces-4891-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E8A781965B
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 02:34:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5AE78283896
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 01:34:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6BB71642F;
	Wed, 20 Dec 2023 01:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Nj9gV0Gk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F6AD15AF9
	for <kvm@vger.kernel.org>; Wed, 20 Dec 2023 01:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-5deda822167so68599617b3.1
        for <kvm@vger.kernel.org>; Tue, 19 Dec 2023 17:33:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1703035988; x=1703640788; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xcGd8hD1GYbqQmtxD4XTvkSxSTm1ofoM7OB/U5l8jC8=;
        b=Nj9gV0Gkk6u0HlWrCw2WAqf53As6cdNvKK9QC2tRxqRr6YeWYEZ+FQdhoo8dllnt9A
         Kk8S9Vwduxji4nm4z5ziLDDyJ/4hbZrfoV7FSykNijy/jRGzg1DCAHJ+LafIyg8agIYq
         s8epWnTF2+sFVaOKKWXD5OLj40dciuh9cwyiPnm5JG2JcEFsioN57r871CHDWVI0XZ6R
         cemE/A8OWK1UE9njRG8DCYOriNEq/58X4WXzv3ONXxQk1behsJKPGoy8BzDtzy7wiofF
         DYJNQhVho4HzXFDjRbhvqtAoT9FCabkFssi3zyI1FfQjwerBHGzFJRPto2JaPB0E9CHo
         iXzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703035988; x=1703640788;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xcGd8hD1GYbqQmtxD4XTvkSxSTm1ofoM7OB/U5l8jC8=;
        b=Rk3j7U2q5bArTYUKxPOrz5XRRPxZ5dRwjUG1SOILqdtGx7IQEiNk0GPMs9uLDcE0YH
         PH0un34dorb0c43QmrgQJA34iJZlSGf17jiR5m0jx1v3Of5vcYf7Md0SvoePqXqf00HE
         jYqLRlrVyNN+gYPv9ufX2ghdmWYlvH+9dwctipsfP8L6nxxTRMp+PkbfkD4UkncrST9I
         9iRDip9MAbcWjBLO3xaV5DI7qAjKHEaHzE/PlHibFk7/CcJ7L+Zewqz+Rr4oDqS8bq1U
         SGNAY/aJJK/B0EAsY3a7mFSC6FrCXtLNDh//NFcas76IKtVpeylzVRLMKXzATNNoQeSP
         hC8g==
X-Gm-Message-State: AOJu0Yz5wO4tBkwYv74TN/Sxv9wC6R5pkQgFAZEl2+i6YnKqDG+JFKfP
	MibGrYG0H6LnOMRQsaHXoE7ICJb4ahU=
X-Google-Smtp-Source: AGHT+IEzH9EZ2sFvwVybtmtJ9FVuhULztY3h62x7Clm5WLnKWnsW8X46WotbUtagjsVDGqhXc5VyhdfSdk8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1364:b0:dbc:ef63:f134 with SMTP id
 bt4-20020a056902136400b00dbcef63f134mr2647919ybb.2.1703035988775; Tue, 19 Dec
 2023 17:33:08 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 19 Dec 2023 17:33:06 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20231220013306.2300650-1-seanjc@google.com>
Subject: [ANNOUNCE] PUCK Agenda - 2023.12.20 - CANCELED
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

PUCK is officially canceled for tomorrow, see y'all next year!

