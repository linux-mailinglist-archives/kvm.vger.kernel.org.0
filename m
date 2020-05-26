Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 621A61C495D
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 00:06:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727890AbgEDWGQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 18:06:16 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:51644 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726334AbgEDWGO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 May 2020 18:06:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588629972;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ldiUHTo4H9fOXrlK9CdJK+WOClXBqbBS4tE+9OydXYY=;
        b=L5MjTEkanNOZ7Enp+O6rAlTi4fu/Qw2VOyXYtM95dze+2RLqmXjHP5NCWsKq9B4jDY6Nki
        j3S1u86dwC0M5G0x1iCGUNHjbB9vKc0M9IHmXqac+/6sjLVTzi2V98KvPnQ4FE+FrWuXJ6
        FlU0NkpllTiUFDDklLDOSEuZMGFOVxk=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-507-IQgfwITeMSOXx403ewmwjw-1; Mon, 04 May 2020 18:06:11 -0400
X-MC-Unique: IQgfwITeMSOXx403ewmwjw-1
Received: by mail-qt1-f200.google.com with SMTP id g8so1224503qtq.2
        for <kvm@vger.kernel.org>; Mon, 04 May 2020 15:06:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ldiUHTo4H9fOXrlK9CdJK+WOClXBqbBS4tE+9OydXYY=;
        b=gcEg6WLna068ctqYDVvWSZbz/+cBlWBtoFXYskOMImUF4ABLq/27DqFo0COjzN9mJ2
         somipdaaO77cNz6hTUhL13qXAlYLC0MjQiZVzCOofJj942tyiC5gNJFhl4xILL/b4c6I
         DPQjJghFkJSzHDXSkacY43Q35VqZgYHXLqPubHiwRoKUVBCX//w77mW6OO5RtL5DqZwV
         WFacIE4d/FX0DvOGxfQboc3aIjgoIrrp/+04hewabylbX3fiZiJFsE/UPXxSp/TtXSll
         7C7t6LzeMLvsnX2bsEBfWysFR/MyKsdyvtBTOdxds9FgdnbTOAjMw04jgPFCGJQ1gfOF
         1ZaA==
X-Gm-Message-State: AGi0PuY5GU1MTQrKrkrDFGO9NTMylrHcX6Gj6qXsCuWIxzRE2yMp0D2n
        icoFEEoOtimUKex7OGtte2zXQSiqcIOgn453+D0RFyvkC8wu6zPJHkAPv2CUjEgljRQ+YT5Ubpq
        SBBxmVrsMH4Px
X-Received: by 2002:a37:9ed5:: with SMTP id h204mr526772qke.446.1588629970536;
        Mon, 04 May 2020 15:06:10 -0700 (PDT)
X-Google-Smtp-Source: APiQypI5ratxafcXWdXR+7DiDQCFg9ET2QsWxNKpq+Gblz9ExXQG316TfcD4OkoqLvruQxBYtCMisg==
X-Received: by 2002:a37:9ed5:: with SMTP id h204mr526742qke.446.1588629970165;
        Mon, 04 May 2020 15:06:10 -0700 (PDT)
Received: from xz-x1.redhat.com ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id w18sm279534qkw.113.2020.05.04.15.06.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 15:06:09 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     peterx@redhat.com, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH] KVM: selftests: Fix build for evmcs.h
Date:   Mon,  4 May 2020 18:06:07 -0400
Message-Id: <20200504220607.99627-1-peterx@redhat.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I got this error when building kvm selftests:

/usr/bin/ld: /home/xz/git/linux/tools/testing/selftests/kvm/libkvm.a(vmx.o):/home/xz/git/linux/tools/testing/selftests/kvm/include/evmcs.h:222: multiple definition of `current_evmcs'; /tmp/cco1G48P.o:/home/xz/git/linux/tools/testing/selftests/kvm/include/evmcs.h:222: first defined here
/usr/bin/ld: /home/xz/git/linux/tools/testing/selftests/kvm/libkvm.a(vmx.o):/home/xz/git/linux/tools/testing/selftests/kvm/include/evmcs.h:223: multiple definition of `current_vp_assist'; /tmp/cco1G48P.o:/home/xz/git/linux/tools/testing/selftests/kvm/include/evmcs.h:223: first defined here

I think it's because evmcs.h is included both in a test file and a lib file so
the structs have multiple declarations when linking.  After all it's not a good
habit to declare structs in the header files.

Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
---

I initially thought it was something about my GCC 10 upgrade that I recently
did to my laptop - gcc10 even fails the build of the latest kernel after
all (though it turns out to be a kernel bug on build system rather than a gcc
bug). but I'm not sure about this one...
---
 tools/testing/selftests/kvm/include/evmcs.h  | 4 ++--
 tools/testing/selftests/kvm/lib/x86_64/vmx.c | 3 +++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/evmcs.h b/tools/testing/selftests/kvm/include/evmcs.h
index d8f4d6bfe05d..a034438b6266 100644
--- a/tools/testing/selftests/kvm/include/evmcs.h
+++ b/tools/testing/selftests/kvm/include/evmcs.h
@@ -219,8 +219,8 @@ struct hv_enlightened_vmcs {
 #define HV_X64_MSR_VP_ASSIST_PAGE_ADDRESS_MASK	\
 		(~((1ull << HV_X64_MSR_VP_ASSIST_PAGE_ADDRESS_SHIFT) - 1))
 
-struct hv_enlightened_vmcs *current_evmcs;
-struct hv_vp_assist_page *current_vp_assist;
+extern struct hv_enlightened_vmcs *current_evmcs;
+extern struct hv_vp_assist_page *current_vp_assist;
 
 int vcpu_enable_evmcs(struct kvm_vm *vm, int vcpu_id);
 
diff --git a/tools/testing/selftests/kvm/lib/x86_64/vmx.c b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
index 6f17f69394be..4ae104f6ce69 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
@@ -17,6 +17,9 @@
 
 bool enable_evmcs;
 
+struct hv_enlightened_vmcs *current_evmcs;
+struct hv_vp_assist_page *current_vp_assist;
+
 struct eptPageTableEntry {
 	uint64_t readable:1;
 	uint64_t writable:1;
-- 
2.26.2

