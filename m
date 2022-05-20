Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54EBE52EE4D
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 16:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350357AbiETOhW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 10:37:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233728AbiETOhU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 10:37:20 -0400
Received: from mail-wm1-x34a.google.com (mail-wm1-x34a.google.com [IPv6:2a00:1450:4864:20::34a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1180817067F
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 07:37:20 -0700 (PDT)
Received: by mail-wm1-x34a.google.com with SMTP id k16-20020a7bc310000000b0038e6cf00439so2734242wmj.0
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 07:37:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=pS9DumThGHqf+VYXeP20c7X4+jg0XWFBAtOzt6gVMzs=;
        b=QYY/jdRDTDQGmhqtcpLlCM86xDyI2I5zYvC1iJuqs2+DAMH6kiG1YTkwITYe+cIK4F
         YCQ5HQVatA+zneNdmQ7yuO3suF8RE3r5jDspYSeSw9X7fhfMU0IGinTRzt8vVRIWMTGs
         0eT44xtIoZ9Hm/RCWALFZY5e65wiew0vBsrUa36q8Nj0FzJsnTy9ef/hakJlt0dN+YdN
         sg1pWBVqYyAJ3mFa8dxcXuzfp5b+btEX6DMTxY//3xRzYm3P/rxGf6DDmxpdvSZIw81A
         Yn2t+lTLOo5+deBcYeZW3BwWQNBbQ/+fTbFTjK3phibmrBAcuvm4iZEvF2a60bOMf9uq
         Lcag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=pS9DumThGHqf+VYXeP20c7X4+jg0XWFBAtOzt6gVMzs=;
        b=rGxwJSksPaIb25vHbwrrKp9LFaVMc+HiE5mTzU7sdyu2lvba/22AoaHdnekjq8CXbl
         JxoZ3OgCe2VjiCHJT/tBus9zem3L5xJ7pg9LAfv2t2S2QWUeNh1jQjYQhIIqWse7kjQb
         EfQOFFm3tDYAP/+vZuWPkHS2X+MU6KMI85Cm4xC1vnd5tViXevqzou93QZiUSKtQ8an/
         7NcLuRA8zm8mLDlntW/vwz9JgsX9o/6uzQMIw5iaEMiAJszDcaLx6JGCgJCcLjlSCtPf
         bEhpSCEtVJDnHqIQZ/67xoiPzx7CA592BFd52iTcYt5iwau+3SJvxEZtOe3asNXCaCnH
         zH1Q==
X-Gm-Message-State: AOAM532IZXDauNF0u9ojgIazKi3VDoUazGNVTvE0mLT9XyFaHth9+H47
        1MNMIA82uhFMsYAOTLlika5pao3l9uN9LM9vhYp4itctGSZR2aXm/En7pyFU3Id9oZ5JH/m5A+x
        fz8SuRc1RE8bWjakUjurOngjXjslECD5MLovHMaAtk6BvMBoF6nTZYUE=
X-Google-Smtp-Source: ABdhPJzmmyMI73ChkCf7f6ahvOQhSQbO6xdm3s2LtLO5UQ3LS+33YB72bGfNAX6i4kqAj45cU231TblADA==
X-Received: from keirf.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:29e7])
 (user=keirf job=sendgmr) by 2002:a1c:f314:0:b0:397:10a5:a355 with SMTP id
 q20-20020a1cf314000000b0039710a5a355mr8423443wmq.176.1653057438521; Fri, 20
 May 2022 07:37:18 -0700 (PDT)
Date:   Fri, 20 May 2022 14:37:06 +0000
In-Reply-To: <20220520143706.550169-1-keirf@google.com>
Message-Id: <20220520143706.550169-3-keirf@google.com>
Mime-Version: 1.0
References: <20220520143706.550169-1-keirf@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH kvmtool 2/2] stat: Add descriptions for new virtio_balloon
 stat types
From:   Keir Fraser <keirf@google.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, Keir Fraser <keirf@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Unknown types would print the value with no descriptive text at all.
Add descriptions for all known stat types, and a default description
when the type is unknown.

Signed-off-by: Keir Fraser <keirf@google.com>
Cc: Will Deacon <will@kernel.org>
---
 builtin-stat.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/builtin-stat.c b/builtin-stat.c
index 5d6407e..876e96a 100644
--- a/builtin-stat.c
+++ b/builtin-stat.c
@@ -83,11 +83,26 @@ static int do_memstat(const char *name, int sock)
 		case VIRTIO_BALLOON_S_MINFLT:
 			printf("The number of minor page faults that have occurred:");
 			break;
+		case VIRTIO_BALLOON_S_HTLB_PGALLOC:
+			printf("The number of successful HugeTLB allocations:");
+			break;
+		case VIRTIO_BALLOON_S_HTLB_PGFAIL:
+			printf("The number of failed HugeTLB allocations:");
+			break;
 		case VIRTIO_BALLOON_S_MEMFREE:
 			printf("The amount of memory not being used for any purpose (in bytes):");
 			break;
 		case VIRTIO_BALLOON_S_MEMTOT:
-			printf("The total amount of memory available (in bytes):");
+			printf("The total amount of memory (in bytes):");
+			break;
+		case VIRTIO_BALLOON_S_AVAIL:
+			printf("The estimated available memory (in bytes):");
+			break;
+		case VIRTIO_BALLOON_S_CACHES:
+			printf("The amount of memory in use for file caching (in bytes):");
+			break;
+		default:
+			printf("Unknown memory statistic (ID %u): ", stats[i].tag);
 			break;
 		}
 		printf("%llu\n", (unsigned long long)stats[i].val);
-- 
2.36.1.124.g0e6072fb45-goog

