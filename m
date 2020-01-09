Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 408E5135C0D
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 16:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732032AbgAIO7A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 09:59:00 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44593 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1732068AbgAIO6T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jan 2020 09:58:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578581898;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v+zy2FHQw9KFVxtHaLqa0r2t8FDa4q1KvvQqvnAapvQ=;
        b=X/iJddj+B4osbqkETOxgxRJIE9I7GFU6gHQaeDAF9nPY5MflJiyxWukqnbjEpTR2XEyVho
        q1rfUyWN5iTrEM9fwazu9l1EV4uLGd8tP/b0agECsvvk2sWFRYRH5INfqaTN975R0hlShZ
        08t3oiIxJPZeWEjZUQSNleg+KBfZE7k=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-423-4v0d8TVzOGubRUApxHnTZQ-1; Thu, 09 Jan 2020 09:58:17 -0500
X-MC-Unique: 4v0d8TVzOGubRUApxHnTZQ-1
Received: by mail-qk1-f200.google.com with SMTP id 143so4273160qkg.12
        for <kvm@vger.kernel.org>; Thu, 09 Jan 2020 06:58:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v+zy2FHQw9KFVxtHaLqa0r2t8FDa4q1KvvQqvnAapvQ=;
        b=aj6t3mF3PbmPeku6WIiV3bFRpydBLY5HSHTUwABmT8pYwfUyx62vSETYIzA9cTLzom
         Ej8NNL/sEsuWFN5XKgVvTDvmbxxgE5COCJGBu831m839mAxuuZms9/FC85ddZnNfmSR+
         FHNi3DOYcnuoCElugGl6jJHstHD956DYl7e/IK2AnPsd8akjpVH/J53Jn+X4GkPXq11K
         VDTYNJC9Q/yBPnmFixhlkrGjFqbboufYbVUxcAsSOQ6NrSclZzb5Hq7qdhfnlC0py0CX
         QfbYlElqk4D30HoWPvL3Uf0EwE0GPVB/KwAty1OOkFSDY136WQQww47KhCqwoeboaxM1
         j+6Q==
X-Gm-Message-State: APjAAAWjr/7nhCbliHmMCGcUJLfga0/U/6RGraWBB91EbFQ+l/b079tW
        hunLMEwv4nxHYjk6BHzqJ978RRO9wUFlAzjUIC4q4WM5Po7AxCTIwGcCuLUfcujquthDLj+meUh
        FJ4cGmvZIppBt
X-Received: by 2002:a37:9ace:: with SMTP id c197mr10113190qke.482.1578581895510;
        Thu, 09 Jan 2020 06:58:15 -0800 (PST)
X-Google-Smtp-Source: APXvYqztXceCqR3GxYbBVVwKVyCXfRviIN28zAumlgJGOwqri1GbhE+3hiqmzypgekRZtjwYhslICg==
X-Received: by 2002:a37:9ace:: with SMTP id c197mr10113165qke.482.1578581895289;
        Thu, 09 Jan 2020 06:58:15 -0800 (PST)
Received: from xz-x1.yyz.redhat.com ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id q2sm3124179qkm.5.2020.01.09.06.58.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jan 2020 06:58:14 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Christophe de Dinechin <dinechin@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Kevin <kevin.tian@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, peterx@redhat.com,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Subject: [PATCH v3 15/21] KVM: selftests: Always clear dirty bitmap after iteration
Date:   Thu,  9 Jan 2020 09:57:23 -0500
Message-Id: <20200109145729.32898-16-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200109145729.32898-1-peterx@redhat.com>
References: <20200109145729.32898-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We don't clear the dirty bitmap before because KVM_GET_DIRTY_LOG will
clear it for us before copying the dirty log onto it.  However we'd
still better to clear it explicitly instead of assuming the kernel
will always do it for us.

More importantly, in the upcoming dirty ring tests we'll start to
fetch dirty pages from a ring buffer, so no one is going to clear the
dirty bitmap for us.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 5614222a6628..3c0ffd34b3b0 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -197,7 +197,7 @@ static void vm_dirty_log_verify(unsigned long *bmap)
 				    page);
 		}
 
-		if (test_bit_le(page, bmap)) {
+		if (test_and_clear_bit_le(page, bmap)) {
 			host_dirty_count++;
 			/*
 			 * If the bit is set, the value written onto
-- 
2.24.1

