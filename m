Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 595837D976D
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 14:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345800AbjJ0MNE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 08:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345821AbjJ0MND (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 08:13:03 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE589128
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 05:12:59 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id ffacd0b85a97d-307d58b3efbso1296117f8f.0
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 05:12:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1698408778; x=1699013578; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ph8ZV619qssLjPgO/yEQk7zJEM+NsPqPerc7acZSWpY=;
        b=o8daz6rc631MqPzy5xXDSWpQC+qqEDyriqahCFFP9KRW2v++lJAhP/3E+UkavWESWk
         NjGQCqPCP6iaxR/8iQ1k1cAdnBq/w6mI6oOGXfdinxLKzSAYjVbFF7t6w3U1WM2jE/HS
         sefaSYFJesUVGHnLJgUCvDTW54reKPRxa4ZjaefZVGU6SdnB2PhFIM7X8FwQg79nbtMw
         jmpk4LdHu3lkPoWMHmUz8+51aFjt/sx1/RQ9Pcc8xBoMD1DdKodC7FhZpHSj/sl+4WF5
         +neR2a5bqH0+fFnPNPIZARb7BD9OyVxg4UuBXpyhRAXX79mIQ+WK7baW3dWEnFNRT9Ew
         fxzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698408778; x=1699013578;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ph8ZV619qssLjPgO/yEQk7zJEM+NsPqPerc7acZSWpY=;
        b=kQmA4++Koy0aPW8RjbypYVBG+nsRk2CSg6KxAoehFW9JkECUz0gG32w8t0SQREHf7d
         Qj0ZHype1DCB9PYA+yf511ZervsR3Lkc76Ghr3n/C+fbUpkilmUecL5tA34I+EQHJCR9
         BmkgZxjPYgTQEZN3PgjX1Bbjx0DFk/FS10U+JkNe3WwAlFpRh9aAksoMmBFyuWiSGZ/Q
         /csyy9CBsUrjxZruWC+OwMGED3y5uSNn0Dp2Bhynkb82dLdPyaFffQqwQ/Huc9hNwFZ7
         9XPu53S6WcR+y18emwXB2MJD/V1U+BpYCaH9nS+bTn6PlPKIRMalqrmlNChMGnGehf+a
         ew8Q==
X-Gm-Message-State: AOJu0YyWikCsulG6lD7e+iSUOLqAwrfJkBHqnnMex9fQAvuBeC47nu7p
        GMdEEMrjCsEk0vL2juCAPAJX9w==
X-Google-Smtp-Source: AGHT+IHQCvYgKC4GIYkhBWYFRXqIbXkxbYn7XjCLJnX8gknw9LeiqQ8kmzYwo5Nm46vJg6lPKDEazw==
X-Received: by 2002:a5d:53c9:0:b0:32d:701b:a585 with SMTP id a9-20020a5d53c9000000b0032d701ba585mr2104274wrw.69.1698408778388;
        Fri, 27 Oct 2023 05:12:58 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id p9-20020adff209000000b00324853fc8adsm1642437wro.104.2023.10.27.05.12.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Oct 2023 05:12:58 -0700 (PDT)
Date:   Fri, 27 Oct 2023 15:12:54 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     Bo Liu <liubo03@inspur.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net-XXX] vhost-vdpa: fix use after free in vhost_vdpa_probe()
Message-ID: <cf53cb61-0699-4e36-a980-94fd4268ff00@moroto.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The put_device() calls vhost_vdpa_release_dev() which calls
ida_simple_remove() and frees "v".  So this call to
ida_simple_remove() is a use after free and a double free.

Fixes: ebe6a354fa7e ("vhost-vdpa: Call ida_simple_remove() when failed")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 drivers/vhost/vdpa.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 9a2343c45df0..1aa67729e188 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -1511,7 +1511,6 @@ static int vhost_vdpa_probe(struct vdpa_device *vdpa)
 
 err:
 	put_device(&v->dev);
-	ida_simple_remove(&vhost_vdpa_ida, v->minor);
 	return r;
 }
 
-- 
2.42.0

