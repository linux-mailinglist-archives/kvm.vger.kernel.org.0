Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EDB127070B
	for <lists+kvm@lfdr.de>; Fri, 18 Sep 2020 22:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgIRU2I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Sep 2020 16:28:08 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:51507 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726118AbgIRU2I (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 18 Sep 2020 16:28:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600460886;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rzHpheUnteGZvfWQ7Ql3JwG2lWZT53rFdb5MJONxnqA=;
        b=jAmQ0St1C7o8/JwFkcXZNI2Tp0tTPPT6nP9n4Jbc3IQtunfJm6EZ6TlAdTK4ZX9AG7kYFg
        I16O1aaZ2aoxkXec8IMOEHBldavb16DN5cWpxC88AgtbtwvTSOikJbQZRsLHx/9X1D8wJb
        vBVx8uk9Q5JSCEMrIVoEd3/x1b21NQ0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-279-neAzsRK3Oe2t3baInEzd3w-1; Fri, 18 Sep 2020 16:28:02 -0400
X-MC-Unique: neAzsRK3Oe2t3baInEzd3w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2CAFA1882FBB;
        Fri, 18 Sep 2020 20:28:01 +0000 (UTC)
Received: from localhost (unknown [10.10.67.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E3AA478817;
        Fri, 18 Sep 2020 20:28:00 +0000 (UTC)
From:   Eduardo Habkost <ehabkost@redhat.com>
To:     qemu-devel@nongnu.org, Peter Maydell <peter.maydell@linaro.org>
Cc:     Richard Henderson <rth@twiddle.net>, kvm@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Cameron Esfahani <dirty@apple.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: [PULL 2/4] hw/i386/vmport: Drop superfluous parenthesis around function typedef
Date:   Fri, 18 Sep 2020 16:27:48 -0400
Message-Id: <20200918202750.10358-3-ehabkost@redhat.com>
In-Reply-To: <20200918202750.10358-1-ehabkost@redhat.com>
References: <20200918202750.10358-1-ehabkost@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Philippe Mathieu-Daudé <philmd@redhat.com>

Drop superfluous parenthesis around VMPortReadFunc typedef
(added in d67f679d99, missed to remove when moved in e595112985).

Suggested-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
Message-Id: <20200505142836.16903-1-philmd@redhat.com>
Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
---
 include/hw/i386/vmport.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/hw/i386/vmport.h b/include/hw/i386/vmport.h
index c380b9c1f0..8f5e27c6f5 100644
--- a/include/hw/i386/vmport.h
+++ b/include/hw/i386/vmport.h
@@ -4,7 +4,7 @@
 #include "hw/isa/isa.h"
 
 #define TYPE_VMPORT "vmport"
-typedef uint32_t (VMPortReadFunc)(void *opaque, uint32_t address);
+typedef uint32_t VMPortReadFunc(void *opaque, uint32_t address);
 
 typedef enum {
     VMPORT_CMD_GETVERSION       = 10,
-- 
2.26.2

