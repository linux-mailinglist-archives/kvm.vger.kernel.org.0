Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1324E2F5BBE
	for <lists+kvm@lfdr.de>; Thu, 14 Jan 2021 08:58:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727981AbhANHza (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jan 2021 02:55:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:56964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727839AbhANHzL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jan 2021 02:55:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA624233FD;
        Thu, 14 Jan 2021 07:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610610830;
        bh=TrTQY3hajtzLk4b1OtE5yfKC0rZRhinwUQjn/1F4J0M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=szafSbjx4BpAyqfIGLJSc9RiCobHoiCKUGdi8h9VPYgM03qq9ITPDEoQjFXd+4e2F
         wprL2LmT1ccAyVW/Yj8p8dQ6q8Tj0SjHxWbdEE03c0gP0Xyb1Sdl82fkv9OHl7jm74
         58mQZA79eTj0sZynB1HGp5/J82ffaZRg+uqyg7HWfDQU9z655sZdNLPNvwslr/iFeS
         jwNs0A3Bz/VGnIMxWLmBAW4wP1WdZo65cEyGaxFmee/AQg8S0v+SNFoKA10Ng03+D9
         UXLUdbfeMW88C0kIBeVu+MsBpI8KHQTQBLWWR/q3Lox41iTBIgAmX37JzKLYctyWfN
         pS4tAoDNd0oag==
Received: by mail.kernel.org with local (Exim 4.94)
        (envelope-from <mchehab@kernel.org>)
        id 1kzxRz-00EPu7-63; Thu, 14 Jan 2021 08:53:47 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Jonathan Corbet <corbet@lwn.net>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        "Linux Doc Mailing List" <linux-doc@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 03/10] KVM: x86: hyper-v: add a blank line to remove building warnings
Date:   Thu, 14 Jan 2021 08:53:38 +0100
Message-Id: <a5a20cd7ff9870b5316825fa1abad0b867832700.1610610444.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1610610444.git.mchehab+huawei@kernel.org>
References: <cover.1610610444.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

.../Documentation/virt/kvm/api.rst:4536: WARNING: Unexpected indentation.
.../Documentation/virt/kvm/api.rst:4538: WARNING: Block quote ends without a blank line; unexpected unindent.

Fixes: c21d54f0307f ("KVM: x86: hyper-v: allow KVM_GET_SUPPORTED_HV_CPUID as a system ioctl")
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/virt/kvm/api.rst | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index c136e254b496..c95572a66a7b 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4532,6 +4532,7 @@ userspace should not expect to get any particular value there.
 Note, vcpu version of KVM_GET_SUPPORTED_HV_CPUID is currently deprecated. Unlike
 system ioctl which exposes all supported feature bits unconditionally, vcpu
 version has the following quirks:
+
 - HYPERV_CPUID_NESTED_FEATURES leaf and HV_X64_ENLIGHTENED_VMCS_RECOMMENDED
   feature bit are only exposed when Enlightened VMCS was previously enabled
   on the corresponding vCPU (KVM_CAP_HYPERV_ENLIGHTENED_VMCS).
-- 
2.29.2

