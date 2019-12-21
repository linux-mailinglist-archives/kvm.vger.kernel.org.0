Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 399AE128685
	for <lists+kvm@lfdr.de>; Sat, 21 Dec 2019 03:05:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbfLUCEv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Dec 2019 21:04:51 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:39288 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726571AbfLUCEv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Dec 2019 21:04:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576893889;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v+zy2FHQw9KFVxtHaLqa0r2t8FDa4q1KvvQqvnAapvQ=;
        b=aTXI9F78xFA7RQSctwHPll0Dq2fOlx2qkjKaY97188DZqVfM1Q0fawR/fNfQDxJ9LzZvH0
        O+TlterOlc33MINTdx/yU0PSuDXvKbJVbcFE8tJeZQNftWiQ3dRR27w86kPeROH7Ith9+a
        XewsTXSN6P2+3/aGBdFHBAMlKEG01OQ=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-124-u_sitCrpMT-EoAsjkLp9oA-1; Fri, 20 Dec 2019 21:04:48 -0500
X-MC-Unique: u_sitCrpMT-EoAsjkLp9oA-1
Received: by mail-qv1-f71.google.com with SMTP id ce17so7192204qvb.5
        for <kvm@vger.kernel.org>; Fri, 20 Dec 2019 18:04:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v+zy2FHQw9KFVxtHaLqa0r2t8FDa4q1KvvQqvnAapvQ=;
        b=If8xiviUZYB2qWSlxZrKilXQI3ZFcdKgbqY76IZjYFz7B39mofNB5kHpsQqEsF/U7D
         vryah0EfiJXXwHdCUKIHw+CFNw3DjI6h35I1GG/EGhytCF7f3bXJA6e0AxW5ZNnXtwCs
         H9LxWZQdFeztIFXW9HNdH+Wu6ajSTzt3hSeuVTJaY/poJjP8XRWK8vh021OiBIRm64CV
         UFoIzP3fYWVJXrs0mGg+RREucbp1JKGKDlktnBlAaqJ6WdwWgLBfBQyvFgAgPeLqCqFW
         5IzNB1WktojLvbd5o+1ybCw0bfhmZqpQtge11aFc3an9ch7Hax+Xpnv2Cj4j1q4e46VD
         FfGw==
X-Gm-Message-State: APjAAAU/jYIkfXrm6MP8uTGmzeBpdu2+yXSi2LeXxAM7w+wfYd4HgCGl
        bMfPUy6j/rqiEW3dxZ7guaiY/rXWStR+k76GYfP79WQiEmAY9SOes/Y37r8Ga/tluhy/NmFUMO0
        CzwAxAQsTmaYf
X-Received: by 2002:a37:9f94:: with SMTP id i142mr16440044qke.244.1576893887904;
        Fri, 20 Dec 2019 18:04:47 -0800 (PST)
X-Google-Smtp-Source: APXvYqxAc0EzsGK9bY8N26qIUJFdrrvHPxY+4cO8RSeHg/vjXPvoekteyflvW9c5b2yOsbwWGQ07Xw==
X-Received: by 2002:a37:9f94:: with SMTP id i142mr16440025qke.244.1576893887691;
        Fri, 20 Dec 2019 18:04:47 -0800 (PST)
Received: from xz-x1.hitronhub.home ([2607:9880:19c0:3f::2])
        by smtp.gmail.com with ESMTPSA id t7sm3400114qkm.136.2019.12.20.18.04.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 18:04:47 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Dr David Alan Gilbert <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        peterx@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH RESEND v2 11/17] KVM: selftests: Always clear dirty bitmap after iteration
Date:   Fri, 20 Dec 2019 21:04:39 -0500
Message-Id: <20191221020445.60476-1-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191221014938.58831-1-peterx@redhat.com>
References: 
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

