Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33EFC1EA335
	for <lists+kvm@lfdr.de>; Mon,  1 Jun 2020 14:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726101AbgFAMAI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jun 2020 08:00:08 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:48638 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725978AbgFAMAH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Jun 2020 08:00:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591012805;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ble7s/BrlGwUPRHQ34ii4/VsZgKqdI5xssnXt1KNNb0=;
        b=exF4SfdSq8NUWQ83LTtCdVb9np64EW8+TEyiE3V8aOWFTJowp8bBHYLBm9KcW3Nttq9eYh
        y1o9Q/NOieGE5UivGK4UnjIR6jNzZWQhfrpDUb5QuDAOHUsoGuEkFfzPs2gwiXIMxF5kVg
        R9FSfKxBjK7Gd+F8LNs+kEffjwuT0WU=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-141-EgGtZWuHON2LESpJQLAZJw-1; Mon, 01 Jun 2020 08:00:04 -0400
X-MC-Unique: EgGtZWuHON2LESpJQLAZJw-1
Received: by mail-qv1-f72.google.com with SMTP id h4so4336631qvr.21
        for <kvm@vger.kernel.org>; Mon, 01 Jun 2020 05:00:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ble7s/BrlGwUPRHQ34ii4/VsZgKqdI5xssnXt1KNNb0=;
        b=ryDcf3W/RO8j2PVgNU+fi2M85bbPafsaKpWmearz0G6fRqNI7dSyNrJsRxfArcmlhs
         Qy1HZvEH+S5wMpclSkD0YbLK9d1uYytrRxreHADvyvShGAIKfeLR229dNWqwZOnEzu0i
         WpPU2vUpOu+jKUVNoWRaVyW+ANWpCPFYS6b6xxGLExJKV11SNhwu4x4EYW6SLsbW0WJN
         lDt3J7+14eMVn1nfvI/UZRbCEKd23uW+vWfSRNXh2UwWPQ3/X5t35oj8YiyEAb3pUBv3
         z7vr+jxA1xdqzgP5eKaYoH5KPT2j9+KFHxz0NkYFxdy//ualBFEj7ByJU24jyQSoiA3H
         mTWQ==
X-Gm-Message-State: AOAM532LLGpCRB28BK0hbatreOYjsxS1zqObvIJRhZU6HaN/LyKVtUTH
        Gy0l9EdCCC7s7MvgvrR7haGzSqJoXiGoTBp1Oi+iiarpY1uCCDieHbl3uSa+YPUPgp10hxFgjb1
        K72pCYt3iojyu
X-Received: by 2002:a05:6214:1925:: with SMTP id es5mr6763770qvb.165.1591012803607;
        Mon, 01 Jun 2020 05:00:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx1IzJyVR4DX6Bk9zy7p1HwJtJsrkQD4MdK4Y0U0kfd9WqtIBE8ch0XnsLCcU23iyKC/g0N/Q==
X-Received: by 2002:a05:6214:1925:: with SMTP id es5mr6763743qvb.165.1591012803378;
        Mon, 01 Jun 2020 05:00:03 -0700 (PDT)
Received: from xz-x1.redhat.com ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id l9sm14474185qki.90.2020.06.01.05.00.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2020 05:00:02 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, peterx@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Kevin Tian <kevin.tian@intel.com>
Subject: [PATCH v10 01/14] KVM: X86: Change parameter for fast_page_fault tracepoint
Date:   Mon,  1 Jun 2020 07:59:44 -0400
Message-Id: <20200601115957.1581250-2-peterx@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601115957.1581250-1-peterx@redhat.com>
References: <20200601115957.1581250-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It would be clearer to dump the return value to know easily on whether
did we go through the fast path for handling current page fault.
Remove the old two last parameters because after all the old/new sptes
were dumped in the same line.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 arch/x86/kvm/mmutrace.h | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmutrace.h b/arch/x86/kvm/mmutrace.h
index ffcd96fc02d0..ef523e760743 100644
--- a/arch/x86/kvm/mmutrace.h
+++ b/arch/x86/kvm/mmutrace.h
@@ -244,9 +244,6 @@ TRACE_EVENT(
 		  __entry->access)
 );
 
-#define __spte_satisfied(__spte)				\
-	(__entry->retry && is_writable_pte(__entry->__spte))
-
 TRACE_EVENT(
 	fast_page_fault,
 	TP_PROTO(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u32 error_code,
@@ -274,12 +271,10 @@ TRACE_EVENT(
 	),
 
 	TP_printk("vcpu %d gva %llx error_code %s sptep %p old %#llx"
-		  " new %llx spurious %d fixed %d", __entry->vcpu_id,
+		  " new %llx ret %d", __entry->vcpu_id,
 		  __entry->cr2_or_gpa, __print_flags(__entry->error_code, "|",
 		  kvm_mmu_trace_pferr_flags), __entry->sptep,
-		  __entry->old_spte, __entry->new_spte,
-		  __spte_satisfied(old_spte), __spte_satisfied(new_spte)
-	)
+		  __entry->old_spte, __entry->new_spte, __entry->retry)
 );
 
 TRACE_EVENT(
-- 
2.26.2

