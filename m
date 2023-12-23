Return-Path: <kvm+bounces-5195-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A21F81D6C5
	for <lists+kvm@lfdr.de>; Sat, 23 Dec 2023 23:16:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 963591F21F53
	for <lists+kvm@lfdr.de>; Sat, 23 Dec 2023 22:16:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F69A18B19;
	Sat, 23 Dec 2023 22:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="Tv16erDt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0007179A1
	for <kvm@vger.kernel.org>; Sat, 23 Dec 2023 22:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1d444cfaf1eso2074435ad.2
        for <kvm@vger.kernel.org>; Sat, 23 Dec 2023 14:16:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1703369778; x=1703974578; darn=vger.kernel.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P7VJMhhbMRf00CrlObhvHa2SrW+r4qHlm+dnHCATGv8=;
        b=Tv16erDtZYqlrmPhw50DNJ2I6qW9vFcTw3oK94CryQ7uK+Nl4YTZ4tbA1QJhoXsGsD
         0xT3MNcfZa1tXHcN8WDPDxkcaDdqc1XLx5+w+5YdvhX4+sJwvTkHlg9EISrshrXTALKr
         tdOQ+IuUU0+BYktidT6QAMUPyAXOM6Nv1qstzrHKxxLnu786w0XIofUXylGxrUaMgb+m
         i4NSXzFnVeuVfKlzzQv8Xh40XygG4qlsgyoDNOaxnLronTOp8KklJILiqXqVGphzyFRd
         tVzJeMUXW2xbt6ZRdgbdg3jhie5i+BC1BXygInj0CJTn0KXLyHJ+zMA6pI5RB/WhJnVF
         p46A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703369778; x=1703974578;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P7VJMhhbMRf00CrlObhvHa2SrW+r4qHlm+dnHCATGv8=;
        b=d2PI09eeghg45oVhogj7vKY6Ek8FFGKfxD5tIftC5UKCUMeh3saulv0HIotC5DiYl6
         w8ETxMj4T+8nGOLQvkoIv/Jxmgf1EzaY1O1U3cRia6oLKPt6gax8298Puo9ioubaOHhd
         DsU1XmYxLYALWhDZbVf4UB3sOf9VjF0CqzemVda+MvgwyLkfFC9viAmvkfO/gZ4jeE6N
         vOhCjKbVdrVp5yYyVSkmj6jhzTNPF9BqcTyJTb8R9bi2aqA+gHMtMnpZRMHc9wJQw9a+
         /Lv0EXkLqo/y/lYNU2houNZwekXLMu5N20bhm5HCcwSAtegCD3eDkT0hpOqiWB0v/v+G
         JiRA==
X-Gm-Message-State: AOJu0YwBHRvRBx294UziuBgl93mTvwTU3+tB2QcUmUpA/QwhfWv+XirH
	T4V14ruy97ZMwWKzSVcWlcxm7UT/pF4VFXKD9ME0NXRmbsuPB0QD2BpqzcTXc/yl1pPoJktZUWP
	tHQy+MeLIo1/pTSlTlAqFww703QUNKeCX9StEgaR31Qcig4mieHjtAz0urFkMNMLOJkejZNEaYk
	MMf6Nj
X-Google-Smtp-Source: AGHT+IHbslIRh1roZhPzl2qcJRrr8D/OTWjikaghk+SKPQvS4S/HYLSCuvapBqPtNp8R8a6MbHpJPQ==
X-Received: by 2002:a17:902:d382:b0:1d3:9060:62a7 with SMTP id e2-20020a170902d38200b001d3906062a7mr3615486pld.35.1703369778158;
        Sat, 23 Dec 2023 14:16:18 -0800 (PST)
Received: from dev-mattc2.dev.purestorage.com ([208.88.159.129])
        by smtp.googlemail.com with ESMTPSA id hf17-20020a17090aff9100b0028c2b52d132sm1817925pjb.13.2023.12.23.14.16.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Dec 2023 14:16:17 -0800 (PST)
From: Matthew W Carlis <mattc@purestorage.com>
To: kvm@vger.kernel.org,
	alex.williamson@redhat.com,
	jgg@nvidia.com
Cc: Matthew W Carlis <mattc@purestorage.com>
Subject: [PATCH 1/1] vfio/pci: Log/indicate devices being bound & unbound.
Date: Sat, 23 Dec 2023 15:16:11 -0700
Message-Id: <20231223221612.35998-1-mattc@purestorage.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Most of my thinking/motivation for this is in the patch notes. The change
itself is straightforward, we would like to have some record of
when a device is bound or unbound in order to trace back to the time
when it happened.

Example from dmesg on 6.6.1 kernel:

[    9.935877] vfio-pci 0000:63:00.0: binding to vfio control
[    9.936890] vfio-pci 0000:e1:00.0: binding to vfio control
[    9.937616] vfio-pci 0000:63:00.1: binding to vfio control
[    9.938201] vfio-pci 0000:e1:00.1: binding to vfio control


Matthew W Carlis (1):
  vfio/pci: Log/indicate devices being bound & unbound.

 drivers/vfio/pci/vfio_pci_core.c | 4 ++++
 1 file changed, 4 insertions(+)


base-commit: ceb6a6f023fd3e8b07761ed900352ef574010bcb
-- 
2.17.1


