Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD2F2E92FE
	for <lists+kvm@lfdr.de>; Mon,  4 Jan 2021 11:00:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726178AbhADKAa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Jan 2021 05:00:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbhADKAa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Jan 2021 05:00:30 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B068EC061574;
        Mon,  4 Jan 2021 01:59:49 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id y23so18728792wmi.1;
        Mon, 04 Jan 2021 01:59:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=K5SA1Kqz0dt8CUajBPOd9U9d9H1oNPjs6B9I4sOCihg=;
        b=s/ndwmXPjggdbAmH8nqLSw+5NLZoYG0yiBdSUadb61dYmcBPO1+VTHoKQ7iDsge4PD
         VMkeS4AL6TNM5gNMY50C450CXct9J2X2Iam2lsvGQw4qOgZRFrNFl8mxw97xbENJ7GrK
         BaL0J8Bsb+UE+IwYXu89+2fk3uYTRLfRMZzEgs1h6xpErc9QcxA5eCExmxn+tqTEtOHK
         vZohNzMNBax92I9VU+iJyK4wFYZSgsduWuT9C8QBV4olifjt34uG4QZVVKOcVxY7WLU8
         a3yWLhtFvj7as2tbIgydyhfaDB6st6/k19iV2pebM3SDNiOcEmb8KMCAiB/TZcyopHt1
         moNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=K5SA1Kqz0dt8CUajBPOd9U9d9H1oNPjs6B9I4sOCihg=;
        b=LffyVqKqM6siqrt4+3FoL2cixXGW3+7cpw/Cr1iuogceSgTbhxCuIo4gnZs7ezYQW8
         WsbjiHrKnc4DqUi5hDtkZDixIJgIcxFBKlNMQbRXQ+H3rH1jHSmtT/ju3Pq/X/c/k8Fx
         0qP/TmrRI41bkNFYS0CvjIw+vRzH35RUH9OyEiQXxrjzRz1Xk2DTK8n8t68uIL/qFWdk
         J7nxzzjHcuI79YHKXfdHrGr9H8yqYp5EF4yC3Ljm0C6VxyHkaVQ5U0a8aKV2iHnEO8rz
         hIW3gXsCMbn8nroiiwxsHIRORrqG6+TzuqXxWB5Dn+phLpJP1v2AlZnexazyv63OY9vM
         Zrfw==
X-Gm-Message-State: AOAM531t44wma4tB7A/LxWD3Wb6lXXMFqquisRrmvz0D6jRk1xMGmxck
        LQeKO6aLRvQ7jIQuEWSQeZk=
X-Google-Smtp-Source: ABdhPJxHcxk8Zms1qD+WtiLwvK1ZD5IQG8mz5G59lWDzup0lUO9dL59+ZWr+7qzzSVZajuoxy8/KZA==
X-Received: by 2002:a05:600c:214a:: with SMTP id v10mr25791435wml.138.1609754388432;
        Mon, 04 Jan 2021 01:59:48 -0800 (PST)
Received: from felia.fritz.box ([2001:16b8:2da9:600:3101:95d1:b0b:2d5a])
        by smtp.gmail.com with ESMTPSA id b9sm35572840wmd.32.2021.01.04.01.59.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 01:59:47 -0800 (PST)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-kernel@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH] KVM: Documentation: rectify rst markup in KVM_GET_SUPPORTED_HV_CPUID
Date:   Mon,  4 Jan 2021 10:59:38 +0100
Message-Id: <20210104095938.24838-1-lukas.bulwahn@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit c21d54f0307f ("KVM: x86: hyper-v: allow KVM_GET_SUPPORTED_HV_CPUID
as a system ioctl") added an enumeration in the KVM_GET_SUPPORTED_HV_CPUID
documentation improperly for rst, and caused new warnings in make htmldocs:

  Documentation/virt/kvm/api.rst:4536: WARNING: Unexpected indentation.
  Documentation/virt/kvm/api.rst:4538: WARNING: Block quote ends without a blank line; unexpected unindent.

Fix that issue and another historic rst markup issue from the initial
rst conversion in the KVM_GET_SUPPORTED_HV_CPUID documentation.

Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
---
applies cleanly on v5.11-rc2 and next-20210104

Jonathan, please pick this minor doc warning fixup.

 Documentation/virt/kvm/api.rst | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index c136e254b496..9c04b9e0c78a 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4508,6 +4508,7 @@ KVM_GET_SUPPORTED_CPUID ioctl because some of them intersect with KVM feature
 leaves (0x40000000, 0x40000001).
 
 Currently, the following list of CPUID leaves are returned:
+
  - HYPERV_CPUID_VENDOR_AND_MAX_FUNCTIONS
  - HYPERV_CPUID_INTERFACE
  - HYPERV_CPUID_VERSION
@@ -4532,6 +4533,7 @@ userspace should not expect to get any particular value there.
 Note, vcpu version of KVM_GET_SUPPORTED_HV_CPUID is currently deprecated. Unlike
 system ioctl which exposes all supported feature bits unconditionally, vcpu
 version has the following quirks:
+
 - HYPERV_CPUID_NESTED_FEATURES leaf and HV_X64_ENLIGHTENED_VMCS_RECOMMENDED
   feature bit are only exposed when Enlightened VMCS was previously enabled
   on the corresponding vCPU (KVM_CAP_HYPERV_ENLIGHTENED_VMCS).
-- 
2.17.1

