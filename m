Return-Path: <kvm+bounces-5952-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E109829181
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 01:38:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 512442892D2
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 00:38:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB74E1C15;
	Wed, 10 Jan 2024 00:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0+T+/toh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19320389
	for <kvm@vger.kernel.org>; Wed, 10 Jan 2024 00:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dbeaf21e069so4027589276.1
        for <kvm@vger.kernel.org>; Tue, 09 Jan 2024 16:38:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704847080; x=1705451880; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Dubuu6a5RHKTDSizXfGG9mFtdlp6O0bStYMvscHwBes=;
        b=0+T+/tohbLWHL3+uQa63dhWLCLKAscpLLxxp5zKqVH6eOGbNnj+FiJvERIdxjtXTxR
         5lDsJueMXVZX6DwvwjC2jzFz1qOEQLgOhvvkEiIQpqfObwhdshUmbl6cUxri71bx9xFm
         0tFwYeqyLK24Vf/eushj7AnxIg08xJ6HuPK2rPt7q1Ab3FRXYvvXYTisXE41p1sItbka
         dMivjcj7E7sEEtGb9253BPlDBosWPz6oFlWjl2j9tk+HZ8zB74dJMgDjmjG1GoDjZVux
         2m1gKqEefEIgs4JlD2ElON+vamWPYJSqP4ETihmxODHumBPTaNFVq4P9lH+ffhFLb4rt
         KCVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704847080; x=1705451880;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Dubuu6a5RHKTDSizXfGG9mFtdlp6O0bStYMvscHwBes=;
        b=nnFfhYT1gh59NePbxs35QDbZZu4dvCXH3wf5KTCFIFdvr6Dc+8xiRNiQwMg42Y7o13
         qeoN3JnE0Vz8t0kdJnXnFwSFo7jSKuYAJJgWPkdewCWsSzPjNeTDkIow6c1DXZ4Jabxf
         cgjoJmLhTcheB9KYoMlwKIyfxU0L0PBECu1zkwi7Co/TKyyHDIUBDFy5Y9SgTk5R5n+x
         MXxGBx7EpQQBqdK91NsZsxxZEATHxEiOCOF2hvpKLSgkxpfiP8S1JF7wZV0T2xwWoSFq
         W/yYvXsev27nURJMqXWe40fuOrcu89XKs5L5SqPdIeQwKA895t0+njxa80aA+tAowlEH
         qrdQ==
X-Gm-Message-State: AOJu0YxbKwr/xQy/1CXh7W0tzb7RQpvpi4cPmH1nI7BHj8yDOjUyy5+Z
	7ClYnQOUui9P8+LisYTHkFwWqqjzURwpP5oh1w==
X-Google-Smtp-Source: AGHT+IE58SJtAWoao4lQ3L+CQGDpyiHkisQ7a1GVbOwazTP5MsPQkuMyveEBs2xdo/w5fqoVGzIYh/HuEE4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:5f48:0:b0:dbd:f6e3:19a with SMTP id
 h8-20020a255f48000000b00dbdf6e3019amr6727ybm.11.1704847080291; Tue, 09 Jan
 2024 16:38:00 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  9 Jan 2024 16:37:56 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20240110003756.489861-1-seanjc@google.com>
Subject: [ANNOUNCE] PUCK Agenda - 2024.01.10 - Unified uAPI for protected VMs
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>, Isaku Yamahata <isaku.yamahata@linux.intel.com>, 
	Michael Roth <michael.roth@amd.com>
Content-Type: text/plain; charset="UTF-8"

Tomorrow's PUCK topic is unifying KVM's uAPI for protected VMs, courtesy of
Isaku.  Note, this was originally planned for LPC, but it got moved to PUCK as
Isaku was unable to attend LPC.

https://lpc.events/event/17/contributions/1495

Time:     6am PDT
Video:    https://meet.google.com/vdb-aeqo-knk
Phone:    https://tel.meet/vdb-aeqo-knk?pin=3003112178656

Calendar: https://calendar.google.com/calendar/u/0?cid=Y182MWE1YjFmNjQ0NzM5YmY1YmVkN2U1ZWE1ZmMzNjY5Y2UzMmEyNTQ0YzVkYjFjN2M4OTE3MDJjYTUwOTBjN2Q1QGdyb3VwLmNhbGVuZGFyLmdvb2dsZS5jb20
Drive:    https://drive.google.com/drive/folders/1aTqCrvTsQI9T4qLhhLs_l986SngGlhPH?resourcekey=0-FDy0ykM3RerZedI8R-zj4A&usp=drive_link

Future Schedule:
January 17th - TDP MMU for IOMMU
January 24th - Memtypes for non-coherent DMA
January 31st - Available!

