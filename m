Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 726E03FE5F1
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 02:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234156AbhIAXGN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 19:06:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29131 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229776AbhIAXGJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 1 Sep 2021 19:06:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630537511;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=XOXIYLGU0WlQoaofc/0VprBGpvSpPcWESQT+iRicL88=;
        b=B+WQGp16CBl03/dOXd5QF4ro8moPENWI0c5qZtFYDoMMewF4RW6n6mlSjyYYt4NGLhCzA2
        kN6+mpeo4Iev2ZFELhwFrv0D8Fa9w7N5yCIJb/hEolZ9JMsXJUSINU2CImiNkWlaFmV0ao
        V9kHyO36Nnkrkt5GfhM04ifNQ28Rg3c=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-401-elns9pUdOmWS-_yQW5FWvw-1; Wed, 01 Sep 2021 19:05:09 -0400
X-MC-Unique: elns9pUdOmWS-_yQW5FWvw-1
Received: by mail-qt1-f198.google.com with SMTP id p21-20020ac846150000b02902982d999bfbso1111711qtn.7
        for <kvm@vger.kernel.org>; Wed, 01 Sep 2021 16:05:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XOXIYLGU0WlQoaofc/0VprBGpvSpPcWESQT+iRicL88=;
        b=PoA3lJ5q6eLrVhodnBeY3yGI+tiRHfvyoDLEBn38bSBuVUSSyyknCOWOfUudCVvAoF
         saWf0Ibf8X2BL2V7Q+RN0asDG8XVYHwhM9lRh0gfblj/O9qUgzlKSm+gyG2Jj5XOnCPY
         6cpifC3+C11zc/YQ6ZU0wD6E8JWPBvM7St7aT8iDibY3rK45tWgfGb3LpQdvqI4Lk5zV
         2Z/yG/gZ20NDSbPL+jwLXFpWDf3I2/WykGoAQ0iDsXv+B0yHTkMD2vwJtq1EYmdtBK2G
         CtdDQksUNp9EdXLdFp+luZrR2uwQaa8RyB0OOLBn6/wCcsQyZoOvihjmLJH9FowTLpI3
         kd2g==
X-Gm-Message-State: AOAM532X8zXzfwnhwI+1xApUomcxgnzcnyKIKjPGphxdQjejc3Tqym1d
        uP0ZO72sDE682SDSW6Yk2rlrG0G3uauM+jrfmKGXnhFQHJjlBfJrXeufkOLvZe6hGNWQOEAn0zh
        JjjCABk69tkae
X-Received: by 2002:a0c:8d0f:: with SMTP id r15mr116364qvb.1.1630537509152;
        Wed, 01 Sep 2021 16:05:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJylN5m0HPJZRHFIQx1XHVbgFelGJ//FdrwxyGEDZLNod5L6H2TPSEbxaeduwAlMMPwDfF8YaQ==
X-Received: by 2002:a0c:8d0f:: with SMTP id r15mr116342qvb.1.1630537508927;
        Wed, 01 Sep 2021 16:05:08 -0700 (PDT)
Received: from t490s.redhat.com ([2607:fea8:56a3:500::ad7f])
        by smtp.gmail.com with ESMTPSA id l13sm69749qkp.97.2021.09.01.16.05.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 16:05:08 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     peterx@redhat.com, Paolo Bonzini <pbonzini@redhat.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH] KVM: Drop unused kvm_dirty_gfn_harvested()
Date:   Wed,  1 Sep 2021 19:05:06 -0400
Message-Id: <20210901230506.13362-1-peterx@redhat.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop the unused function as reported by test bot.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 virt/kvm/dirty_ring.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
index 7aafefc50aa7..88f4683198ea 100644
--- a/virt/kvm/dirty_ring.c
+++ b/virt/kvm/dirty_ring.c
@@ -91,11 +91,6 @@ static inline void kvm_dirty_gfn_set_dirtied(struct kvm_dirty_gfn *gfn)
 	gfn->flags = KVM_DIRTY_GFN_F_DIRTY;
 }
 
-static inline bool kvm_dirty_gfn_invalid(struct kvm_dirty_gfn *gfn)
-{
-	return gfn->flags == 0;
-}
-
 static inline bool kvm_dirty_gfn_harvested(struct kvm_dirty_gfn *gfn)
 {
 	return gfn->flags & KVM_DIRTY_GFN_F_RESET;
-- 
2.31.1

