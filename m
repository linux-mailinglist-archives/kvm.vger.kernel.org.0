Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75B3C5744A9
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 07:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235018AbiGNFll (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 01:41:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234007AbiGNFlj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 01:41:39 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE77B28E30
        for <kvm@vger.kernel.org>; Wed, 13 Jul 2022 22:41:38 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id 89-20020a17090a09e200b001ef7638e536so7290182pjo.3
        for <kvm@vger.kernel.org>; Wed, 13 Jul 2022 22:41:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=i59VriJjB+PUzlUjZk7zH2du5xKXloEI1JXD7bEmhsY=;
        b=p3M5kacOM9fOKOP8HRftw9tQtZXieDZWtf/3IbgKg2EhOcxI6ckMZWb4fa2HgNdtPh
         zNraIgBQJu+MmHF9xGilrKVb4ADly1Vv5wU9EgISw/ijJqX29a7LOVlMwX5+TFHz2eny
         Tpk18ZCMciT8dJ623w6ERLkYQ61MpWhHa6yF3hLDkCj8PQfUbAmZfQIBB4WvQq3SPmg+
         95iel9cwdYSHqD7r9liti/cmt1GCebUUJ1GGQ3+B3qAKIkUkoSpTnep1BBX3+iGgRzJG
         2ZFKpsSIqg8HqTM2VnB+XAQXvu2FFdW93PE5TcKnAMwkHbCY2b/JuCpPFoDGVPqSw3wL
         L23g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i59VriJjB+PUzlUjZk7zH2du5xKXloEI1JXD7bEmhsY=;
        b=GP2b5AuRZNcr972+isfg3wBKhmUgGIU58Ait2cdxpVEa/CFtHaMoi3cFvwZtUIsAQF
         VrFaRlvERKfBq0cFY6+WBhxIwzgtFL9x8cKNtAubEpdZxC3atNrhFOTxdD0JsD3qqiQG
         8NCXzU9dJpzuhjFLcX7KT3/b2L+1GlMRdKdGa6tVS/QmmeJHX0kR9qoJ6JZDshb0YPt9
         nWO/xQbYe7edV14n0RcFSuw0XDHB6NzDMbwJ44ZXEpMjB+heEEekjv9QhduOHZxwzsdx
         bMSmI6ksJ7WUyYqp2Afm/HJ6SomuDJEzqhlR8Gf074Rp5uipPH1OcfRzDnllcbvIiXLF
         U7uA==
X-Gm-Message-State: AJIora+M8ovFWzdvBXnbfA5nGAONEoph0J0Lw0+BUvRb2KB1GKpu88Hv
        ttskNM/FrUOhqqkAJll4LuFd/DmFLdm05mkHnyA=
X-Google-Smtp-Source: AGRyM1vo6CfbWovRvvxV7/lvmuouPA8WX1F7orFelwE+rx/d+PKaEZueq6QOtf6LMaufTcVjmSUOuA==
X-Received: by 2002:a17:902:d581:b0:16c:66bf:baef with SMTP id k1-20020a170902d58100b0016c66bfbaefmr6762613plh.29.1657777298315;
        Wed, 13 Jul 2022 22:41:38 -0700 (PDT)
Received: from localhost.localdomain ([47.246.98.188])
        by smtp.gmail.com with ESMTPSA id h13-20020a65518d000000b0040cb1f55391sm370058pgq.2.2022.07.13.22.41.36
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 Jul 2022 22:41:37 -0700 (PDT)
From:   SU Hang <darcysail@gmail.com>
X-Google-Original-From: SU Hang <darcy.sh@antgroup.com>
To:     darcysail@gmail.com
Cc:     darcy.sh@antgroup.com, kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [kvm-unit-tests PATCH] x86: amd: pmu: test performance counter on AMD
Date:   Thu, 14 Jul 2022 13:41:33 +0800
Message-Id: <20220714054133.21273-1-darcy.sh@antgroup.com>
X-Mailer: git-send-email 2.32.1 (Apple Git-133)
In-Reply-To: <20220714051206.19070-1-darcy.sh@antgroup.com>
References: <20220714051206.19070-1-darcy.sh@antgroup.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> +		if (!is_intel_chip) {
> +			id = raw_cpuid(0x80000001, 0);
> +			if (id.c & (1 << 23))
> +				/* support core perfmon */
> +				gp_counter_base = MSR_F15H_PERF_CTR;
> +
> +			eax.split.num_counters = 6;
> +			num_counters = eax.split.num_counters;
> +			report_prefix_push("core perf");
> +			check_counters();
> +			check_amd_gp_counters_write_width();
> +		}

Stupid fault, shouldn't continue without core perfmon counter.
```
+		if (!is_intel_chip) {
+			id = raw_cpuid(0x80000001, 0);
+			if (id.c & (1 << 23)) {
+				/* support core perfmon */
+				gp_counter_base = MSR_F15H_PERF_CTR;
+				eax.split.num_counters = 6;
+				num_counters = eax.split.num_counters;
+				report_prefix_push("core perf");
+				check_counters();
+				check_amd_gp_counters_write_width();
+			}
+		}
```
