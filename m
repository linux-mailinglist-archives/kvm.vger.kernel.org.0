Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD5C34E3D3C
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 12:08:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234022AbiCVLJF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 07:09:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233987AbiCVLIw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 07:08:52 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 440A17EA2F;
        Tue, 22 Mar 2022 04:07:24 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id p184-20020a1c29c1000000b0037f76d8b484so1273909wmp.5;
        Tue, 22 Mar 2022 04:07:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QR1B37kNwxZ4YEDzpoJwevUk3AxgLWqrE9jQ8wOSRa0=;
        b=o4MPYIC6FfRP+P+cJZc2HgIpyrKC5DOpURDQWWVlloiw6BHiLlMlZF7butrX78IQp5
         3ppK29Is44kUdB22yEIEpryyk4tY5Vbqf2E81vhU6PEaW1BzhKTU3Z4MF70aCUYqjv4p
         xkI95soUG4JkS+l8OIK/jz6mr5uSFmrW/HImuDlpJXPtJkfFrdoD1JtZk1jajhHNF9bf
         w8jxeA5tJpTc7IZTIuCkyUrYQ3jddqz8iO26zzFH9qzZEWUW5BoXDt4P+7u98xTNYWR4
         bIeTPwTqGlmSI3pM/BzBjrAhw6CoHZc55Hwka4WAScdfGvgd5NoMtMOFjrOvg7vfjaXo
         aB0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=QR1B37kNwxZ4YEDzpoJwevUk3AxgLWqrE9jQ8wOSRa0=;
        b=F8kxzSeDOrDXchjf9X1J/9OMKiio1vFQF6Tu9i1qEzIbxxERuam/aidyh7F4c3VeeP
         /OlFMU/4r4kqChNYQbCT6qEHPzeOZTP8CVAq1areqeYe0jCg9mhi1zjwZE2vS95wbkI8
         bwhz/A3YF1h1mYoXvIlrl07KUuHS2c+S5fPK5tTjU75BZ8tQ7TJZjfLjEf6K0QQAJwt4
         5pJWX2Mtuxgo+FT1oypVk5x6XqkNseonZIlUooYQ9qUUj2CT5rvHT1WPq3GEh1RiDkor
         eYI181GlD8VlOJgk02pqw0lnA3elLJwJzGj6nOWQNJ7Lq2wzYrVpg4Yi0wop0+69Q62z
         twsA==
X-Gm-Message-State: AOAM5318W9HCn31AJkivXAtu4EXnDoeVDhlnFke3Mz5a+8WwWFQM7R+i
        P1Ed8SfhdB8LMcR4QjjqTwtDVrhzIm8=
X-Google-Smtp-Source: ABdhPJw6DgOhPATHqxexglfOBZNO6zf+4E0cjjWWsFQDrBACVtiyLjKx0tMOOg+VIzD+zFAJ+gzCHA==
X-Received: by 2002:a05:6000:1848:b0:204:e90:cb55 with SMTP id c8-20020a056000184800b002040e90cb55mr8640436wri.58.1647947242808;
        Tue, 22 Mar 2022 04:07:22 -0700 (PDT)
Received: from avogadro.lan ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id y11-20020a056000168b00b002041af9a73fsm4221856wrd.84.2022.03.22.04.07.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 04:07:22 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH 1/2] Documentation: kvm: fixes for locking.rst
Date:   Tue, 22 Mar 2022 12:07:19 +0100
Message-Id: <20220322110720.222499-2-pbonzini@redhat.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220322110720.222499-1-pbonzini@redhat.com>
References: <20220322110720.222499-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Separate the various locks clearly, and include the new names of blocked_vcpu_on_cpu_lock
and blocked_vcpu_on_cpu.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 Documentation/virt/kvm/locking.rst | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/Documentation/virt/kvm/locking.rst b/Documentation/virt/kvm/locking.rst
index 5d27da356836..4f21063bfbd6 100644
--- a/Documentation/virt/kvm/locking.rst
+++ b/Documentation/virt/kvm/locking.rst
@@ -210,32 +210,41 @@ time it will be set using the Dirty tracking mechanism described above.
 3. Reference
 ------------
 
-:Name:		kvm_lock
+``kvm_lock``
+^^^^^^^^^^^^
+
 :Type:		mutex
 :Arch:		any
 :Protects:	- vm_list
 
-:Name:		kvm_count_lock
+``kvm_count_lock``
+^^^^^^^^^^^^^^^^^^
+
 :Type:		raw_spinlock_t
 :Arch:		any
 :Protects:	- hardware virtualization enable/disable
 :Comment:	'raw' because hardware enabling/disabling must be atomic /wrt
 		migration.
 
-:Name:		kvm_arch::tsc_write_lock
-:Type:		raw_spinlock
+
+``kvm_arch::tsc_write_lock``
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+:Type:		raw_spinlock_t
 :Arch:		x86
 :Protects:	- kvm_arch::{last_tsc_write,last_tsc_nsec,last_tsc_offset}
 		- tsc offset in vmcb
 :Comment:	'raw' because updating the tsc offsets must not be preempted.
 
-:Name:		kvm->mmu_lock
-:Type:		spinlock_t
+``kvm->mmu_lock``
+^^^^^^^^^^^^^^^^^
+:Type:		spinlock_t or rwlock_t
 :Arch:		any
 :Protects:	-shadow page/shadow tlb entry
 :Comment:	it is a spinlock since it is used in mmu notifier.
 
-:Name:		kvm->srcu
+``kvm->srcu``
+^^^^^^^^^^^^^
 :Type:		srcu lock
 :Arch:		any
 :Protects:	- kvm->memslots
@@ -246,10 +255,11 @@ time it will be set using the Dirty tracking mechanism described above.
 		The srcu index can be stored in kvm_vcpu->srcu_idx per vcpu
 		if it is needed by multiple functions.
 
-:Name:		blocked_vcpu_on_cpu_lock
+``wakeup_vcpus_on_cpu_lock``
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 :Type:		spinlock_t
 :Arch:		x86
-:Protects:	blocked_vcpu_on_cpu
+:Protects:	wakeup_vcpus_on_cpu
 :Comment:	This is a per-CPU lock and it is used for VT-d posted-interrupts.
 		When VT-d posted-interrupts is supported and the VM has assigned
 		devices, we put the blocked vCPU on the list blocked_vcpu_on_cpu
-- 
2.35.1


