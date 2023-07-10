Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 754B474E0F0
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 00:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbjGJWUh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jul 2023 18:20:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbjGJWUg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jul 2023 18:20:36 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A568189;
        Mon, 10 Jul 2023 15:20:35 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1b9cdef8619so13471445ad.0;
        Mon, 10 Jul 2023 15:20:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689027635; x=1691619635;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=H18CdgrYMTpofy+sXOjkYOSJshvEuHvdbWqmwdvSi4E=;
        b=cUtay2Mdoywod53JzsZMnBIYUUqlsr/H+h4hz7hE+usjY4rOuuGXMRk/bI/Wwt9Bke
         qZTt1llHZDRCmn9y5ohESwrecyx8J4bzAIKEb2rWRCp2XDuOwz7+Z2wl2QlHW9x0F05Q
         BlPGXe3mrcoHmdlXWKHuBoj3h8kZvLk4JKLv0GwsMM/ciDNm+SUDltWzskRVUnq2v6gU
         nwdvBsKVxbIX7/9msIbibQLglMxO/iQVYy5AKPkEX0/PY0iPB+gIsLjRGDmCo5b58QOF
         E/I72QXheGOaSJbYJIJuLHvHIHSOXmqEGzELpzwXlC2PqUMYKe4JVT8Rp8ceXFtB67fa
         yB+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689027635; x=1691619635;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H18CdgrYMTpofy+sXOjkYOSJshvEuHvdbWqmwdvSi4E=;
        b=TYIM4l6oyrhFOJyqHrFQVLxXFNlb+Apdc0kYXulmtPB5zwztj6LJmVp8CDx0+3/Sey
         q0Ck0aOL/eHp4mDdSHSWlv2Rh1HEkMTM9XY0tpyMoHuo1MeGUS9Rj9ru3TJTX701AGI7
         518i+M+47ayRTpRWNyiys3TUJEuR5MRbXQU6f0ONuGnOboWzhu+2XIvD+L8pabwaqXsa
         xP8tqkcddmvle8dx5sbwLCzgSs/D7cEGH7zO0CjhHtkAlB771v1xwsNqIGAeZCzBy8wY
         t/Nspg7plBAPe+0SU+fYdtngf1mIZTROG7gjZmWOfL097g3eoOXruQJ77YvFj/1TEWGW
         9CUQ==
X-Gm-Message-State: ABy/qLYfM4+GMWfmpADmw6nr7j/hSbzGUlQuNAzcX5Bf2ic7uEVXYHUi
        HVP82ndSEL82rND/IJ+yF5BF73aU4Vo=
X-Google-Smtp-Source: APBJJlE5aXiIVMJm2FwNEoHQloWDI7S0GpS1C94OvT2AMG4z1j30hxa4cGTaO9itXrZrtMkTNvdgtA==
X-Received: by 2002:a17:902:f546:b0:1b0:3df7:5992 with SMTP id h6-20020a170902f54600b001b03df75992mr14716372plf.32.1689027634962;
        Mon, 10 Jul 2023 15:20:34 -0700 (PDT)
Received: from google.com ([2620:15c:9d:2:96bf:7e77:39eb:7a23])
        by smtp.gmail.com with ESMTPSA id bb10-20020a170902bc8a00b001b9c5e07bc3sm364766plb.238.2023.07.10.15.20.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jul 2023 15:20:34 -0700 (PDT)
Date:   Mon, 10 Jul 2023 15:20:31 -0700
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Sean Christopherson <seanjc@google.com>,
        Roxana Bradescu <roxabee@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] kvm/vfio: ensure kvg instance stays around in
 kvm_vfio_group_add()
Message-ID: <ZKyEL/4pFicxMQvg@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FSL_HELO_FAKE,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_vfio_group_add() creates kvg instance, links it to kv->group_list,
and calls kvm_vfio_file_set_kvm() with kvg->file as an argument after
dropping kv->lock. If we race group addition and deletion calls, kvg
instance may get freed by the time we get around to calling
kvm_vfio_file_set_kvm().

Fix this by moving call to kvm_vfio_file_set_kvm() under the protection
of kv->lock. We already call it while holding the same lock when vfio
group is being deleted, so it should be safe here as well.

Fixes: ba70a89f3c2a ("vfio: Change vfio_group_set_kvm() to vfio_file_set_kvm()")
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 virt/kvm/vfio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
index 9584eb57e0ed..cd46d7ef98d6 100644
--- a/virt/kvm/vfio.c
+++ b/virt/kvm/vfio.c
@@ -179,10 +179,10 @@ static int kvm_vfio_group_add(struct kvm_device *dev, unsigned int fd)
 	list_add_tail(&kvg->node, &kv->group_list);
 
 	kvm_arch_start_assignment(dev->kvm);
+	kvm_vfio_file_set_kvm(kvg->file, dev->kvm);
 
 	mutex_unlock(&kv->lock);
 
-	kvm_vfio_file_set_kvm(kvg->file, dev->kvm);
 	kvm_vfio_update_coherency(dev);
 
 	return 0;
-- 
2.41.0.255.g8b1d071c50-goog


-- 
Dmitry
