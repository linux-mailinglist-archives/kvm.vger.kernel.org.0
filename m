Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50A15EBA04
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2019 23:53:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728235AbfJaWxs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Oct 2019 18:53:48 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42514 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726540AbfJaWxs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Oct 2019 18:53:48 -0400
Received: by mail-wr1-f66.google.com with SMTP id a15so7975829wrf.9;
        Thu, 31 Oct 2019 15:53:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sAzljLRgSt0T4SkgYsaqgvjH5/V1zSYWw1k97qxMfJk=;
        b=DdnQ2aG41QAJSboenV4wySHF2meXgLSRA649oxBw9RAPNghNJEHSiFM5YwuLI8CfeO
         df5hfVi+DcA4OKQihRG6s5omuAbGxCR0URTee3j4Jg12CTsH/YdWWd+nh2eUmUXZYFXL
         CcDRMGPtcCa527wuEKWJ8tCjBX10DrMrAplEzF4N9JEKS0LniqTiIhNfm4KwTjO+FUB+
         dTi6qDoHGsoHcK+UJY2SyU72bOIWNXelJKWzO+O3toJQGOrHGTWBXGShL1gF2MXio8Xn
         EcPWDxo/sH4akb07nPs+3Q9KmL/TK6/eZjMMROlvPWUgs3g/cp9L4UQZSL+Co8p5yLMq
         RcQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=sAzljLRgSt0T4SkgYsaqgvjH5/V1zSYWw1k97qxMfJk=;
        b=cov24UiiLokjumC/QDmFykp3+YctReUcRoRhE+53gswRffYZBnvqScKwv29rYCUCLj
         SSM2hReK+l0HcdqDzx4MIAwRxXlz0hagwHdeVcwuw/0+wWgw9uewtQzfvSkWbflVOdCX
         KDOucDjJOwGaF2fDfn+s2BEJu+JPKD78qPmHIuhusZNuGjuSp3GHbs4V5va8ViZD9dQw
         aYF/CWao0ueujQzZkm+0Yvgc6MofkGe9XlPqFEOLyQU2x2TaPZAUnATt4KurepaM6m7h
         2o1uDLuTSXRNnSVt+KaeMdFS/fMnIeDRz0YeFh79NmFowWcYysnzQPvut9NG/OrcU+Cq
         3kbQ==
X-Gm-Message-State: APjAAAWcGJLz4nOg/SsQ4Kt8+ui4zVSAOkzPH0f6JkGY6t7kLBWjD3+2
        DMjCWvf9y+sPsH3xB0qZBAuyTd2OZQo=
X-Google-Smtp-Source: APXvYqz1p8qVO3J188bjhlrVa1hJ4uYvoW5VQM0J2M2QgJVLMiEUUEHEjKw1yL5l5r9CQzgCBegF9A==
X-Received: by 2002:a5d:6448:: with SMTP id d8mr5306172wrw.88.1572562425910;
        Thu, 31 Oct 2019 15:53:45 -0700 (PDT)
Received: from donizetti.redhat.com (94.222.26.109.rev.sfr.net. [109.26.222.94])
        by smtp.gmail.com with ESMTPSA id l4sm4673235wml.33.2019.10.31.15.53.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Oct 2019 15:53:44 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, rkrcmar@kernel.org,
        kvm@vger.kernel.org
Subject: [GIT PULL] KVM patches for Linux 5.4-rc6
Date:   Thu, 31 Oct 2019 23:53:47 +0100
Message-Id: <20191031225347.26587-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Linus,

The following changes since commit 671ddc700fd08b94967b1e2a937020e30c838609:

  KVM: nVMX: Don't leak L1 MMIO regions to L2 (2019-10-22 19:04:40 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

for you to fetch changes up to 9167ab79936206118cc60e47dcb926c3489f3bd5:

  KVM: vmx, svm: always run with EFER.NXE=1 when shadow paging is active (2019-10-31 12:13:44 +0100)

----------------------------------------------------------------
Generic: fix memory leak failure to create VM.
x86: fix MMU corner case with AMD nested paging disabled.

----------------------------------------------------------------
Jim Mattson (2):
      kvm: Allocate memslots and buses before calling kvm_arch_init_vm
      kvm: call kvm_arch_destroy_vm if vm creation fails

Paolo Bonzini (1):
      KVM: vmx, svm: always run with EFER.NXE=1 when shadow paging is active

 arch/x86/kvm/svm.c     | 10 ++++++++--
 arch/x86/kvm/vmx/vmx.c | 14 +++-----------
 virt/kvm/kvm_main.c    | 48 ++++++++++++++++++++++++++----------------------
 3 files changed, 37 insertions(+), 35 deletions(-)
