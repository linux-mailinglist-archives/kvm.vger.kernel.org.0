Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9193D68CD97
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 04:46:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbjBGDqf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 22:46:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjBGDqd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 22:46:33 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3293E196BA;
        Mon,  6 Feb 2023 19:46:32 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id ud5so39975083ejc.4;
        Mon, 06 Feb 2023 19:46:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ec+Ri0/zRxNBu/2tDyGnZvr9Oh7rTqU+5vTR9Ir4/8w=;
        b=pXQEd6QIAvVewiP1Xcp+DpTzPmJaXcoTEqKp0PN42sOsG55U0OSWAt/XWz94kPg7nD
         55NAgDKnP1rtNCIi2GQcucLZ+AQZk5CnruAJl4rDJN1oZcRsgEC/WvMITBC1fm8NDATN
         KKU2dbrZajJLiEtkaxWSlqZjuXqYsSx1S+mhngUCJvAhQ/eUcF8rWoimZtOTF6U7V9oF
         zI5GEuXyzGqC1BO6paNXBIr5CVR/sSdDPMiSYpnEJS8AlkqZ+/e8j6Q5qBI+CnRaD0gd
         2GJ+jTkZd6E2hPzVW1E6Zca7vCpbhlPZJ/4owjRuSPfw2pj4r+ibTWPEr+FhTJXp/eBV
         jOpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ec+Ri0/zRxNBu/2tDyGnZvr9Oh7rTqU+5vTR9Ir4/8w=;
        b=g9fd6JwrHddpz1ZkGBT0J9Z6X1GlNc2O8W4yd6IHe/TQvQoSMmrQ+/Sa0LGKWFFMjz
         4CMH6aTQOBQoBUNedV6Y9oLvvxeHH4OFaqLL/Jb1hcl9928m+FmnKLafQYg644khuXnn
         X5Nw9LLipKlVZ4GnYrr/WKfHQ3rtAeXaYH1HAjQXkU93KydKEWzwCSuJtmGdN0XfVwAJ
         aE6BE+A71IwZtlMZJwkeUw0GKriRwu2eYy9LVFN6/s64L0jZ0YeyA0BGibp2WE4r3P8z
         H3SJvZBHrrY4u+YIK/J+RJ1ivHr+1fKazBO1AJiE0Q1IQSN8ZRLjnFi0rRn6P+dA3dxf
         1ukw==
X-Gm-Message-State: AO0yUKUvpEpf85mA+DMG0MZvvj4WRk0gNpu8A8rqIzkgUZz3pW1DjSkj
        ISAeOsnSHk5etlUJUWnVso9DlTtJFGHPiyup
X-Google-Smtp-Source: AK7set8xVVAh5hy8Wh7FAADzqv1hr5KD17nmyA2OldTJ3paHojpUctC7mpWoVllRrNyq7wHx+UEQfQ==
X-Received: by 2002:a17:907:3e27:b0:86c:a3ed:1442 with SMTP id hp39-20020a1709073e2700b0086ca3ed1442mr2276669ejc.4.1675741590725;
        Mon, 06 Feb 2023 19:46:30 -0800 (PST)
Received: from smurf (80.71.142.58.ipv4.parknet.dk. [80.71.142.58])
        by smtp.gmail.com with ESMTPSA id o13-20020a17090611cd00b0087ba1ed4a58sm6266775eja.191.2023.02.06.19.46.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Feb 2023 19:46:30 -0800 (PST)
Date:   Tue, 7 Feb 2023 04:46:08 +0100 (CET)
From:   Jesper Juhl <jesperjuhl76@gmail.com>
To:     linux-kernel@vger.kernel.org
cc:     trivial@kernel.org, kvm@vger.kernel.org,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        David Airlie <airlied@gmail.com>,
        David Woodhouse <dwmw@amazon.co.uk>
Subject: [PATCH] [Trivial] Remove a few redundant semicolons
Message-ID: <88aa7c5c-2ac3-52ad-2645-6eff21c8c0f9@gmail.com>
User-Agent: Alpine 2.26 (LNX 649 2022-06-02)
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset=US-ASCII
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From 2535622b0c2d33cc3cbcfec4e374b58e3e0a0efa Mon Sep 17 00:00:00 2001
From: Jesper Juhl <jesperjuhl76@gmail.com>
Date: Tue, 7 Feb 2023 04:40:37 +0100
Subject: [PATCH] Remove a few redundant semicolons

Signed-Off-by: Jesper Juhl <jesperjuhl76@gmail.com>

---
  drivers/gpu/drm/i915/gvt/vgpu.c                      | 2 +-
  drivers/gpu/drm/nouveau/nvkm/engine/gr/gf100.c       | 2 +-
  tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c | 2 +-
  3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/gvt/vgpu.c b/drivers/gpu/drm/i915/gvt/vgpu.c
index a5497440484f..08ad1bd651f1 100644
--- a/drivers/gpu/drm/i915/gvt/vgpu.c
+++ b/drivers/gpu/drm/i915/gvt/vgpu.c
@@ -323,7 +323,7 @@ int intel_gvt_create_vgpu(struct intel_vgpu *vgpu,
  	ret = idr_alloc(&gvt->vgpu_idr, vgpu, IDLE_VGPU_IDR + 1, GVT_MAX_VGPU,
  		GFP_KERNEL);
  	if (ret < 0)
-		goto out_unlock;;
+		goto out_unlock;

  	vgpu->id = ret;
  	vgpu->sched_ctl.weight = conf->weight;
diff --git a/drivers/gpu/drm/nouveau/nvkm/engine/gr/gf100.c b/drivers/gpu/drm/nouveau/nvkm/engine/gr/gf100.c
index 5f20079c3660..204516891ece 100644
--- a/drivers/gpu/drm/nouveau/nvkm/engine/gr/gf100.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/gr/gf100.c
@@ -420,7 +420,7 @@ gf100_gr_chan_new(struct nvkm_gr *base, struct nvkm_fifo_chan *fifoch,
  			return ret;
  	} else {
  		ret = nvkm_memory_map(gr->attrib_cb, 0, chan->vmm, chan->attrib_cb,
-				      &args, sizeof(args));;
+				      &args, sizeof(args));
  		if (ret)
  			return ret;
  	}
diff --git a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
index 13c75dc18c10..e6a023b9a1f5 100644
--- a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
@@ -97,7 +97,7 @@ struct compat_vcpu_runstate_info {
  	uint32_t state;
  	uint64_t state_entry_time;
  	uint64_t time[5];
-} __attribute__((__packed__));;
+} __attribute__((__packed__));

  struct arch_vcpu_info {
  	unsigned long cr2;
-- 
2.39.1

