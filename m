Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52D015F6C88
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 19:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbiJFRL5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Oct 2022 13:11:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231207AbiJFRLy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Oct 2022 13:11:54 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52741A7AB2
        for <kvm@vger.kernel.org>; Thu,  6 Oct 2022 10:11:52 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 126-20020a630284000000b0043942ef3ac7so1475480pgc.11
        for <kvm@vger.kernel.org>; Thu, 06 Oct 2022 10:11:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gIRTEOV760XmyIZ/Qi7fwmuzWwZOXMhh2dv+gAx8YTQ=;
        b=hKrqnN77SIF0aoCHhjnc01Xfz+qA6XLrRWcZhg0cRFbr5kbWjrZKjUUdodyeCKSgyg
         titUyrnc9EVwraqc6/H04PeiwVTsLAWkofdan0t4tlf3ZEXyeVLZjrEsFUrAg2g5FDdb
         g/Sy9uuSHFmowKhfmBDnbktYZqgcSFb/ryLKl97TbgWq5eXQgE8VMXx41XG3vP73ATOd
         hRbjAxM2l5bu9nomRHaKH007naphm+U2EWtAQDuAD5pUmPmE1IuSDL5eiEfbAqvGTjbT
         sX1mFo8711e1VgtzFgvGXxVvemZjXWetxvFYCLOh31mxw/8f/Eq17VAAeHKEqBBe0LDU
         muaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gIRTEOV760XmyIZ/Qi7fwmuzWwZOXMhh2dv+gAx8YTQ=;
        b=G/oxV5/7j9Gr3KPU6cu/eYufdM2nQoFh14+ku97C34vjD6apFD9Phug438boIGZCxJ
         ADkiW9e68ulRKWXENyuow49dY34Z/ojOx1jKdBiRYzMBhUMOd4IezkiqiDSz2h72MIcY
         KLw8OtTLn34z8I2BIqwlRXc0g8jn7YEnqeRxVplYgymrPOgW+VLR0yo/NnLPL4nEMdZq
         22vjwj+W7etmmtFZqZhoy8BOClSSDLMrofr6S1wO5aNhGB44mCPPY2YJppj86NDyhDbk
         OZgLwpsymMRuGI78hWTdZKqQnK6yL7TO3dQ2bu5S9+OP5165Wjr4RjwWPNp7nvI0bjQ4
         a68A==
X-Gm-Message-State: ACrzQf14oqiOdyN6EcUzlwJx67r+MuJy9HR13k5TaA07lTvgsvXbj9TR
        Uyzx9FOv3002YweaPgSeWOd8dmc/AoHS
X-Google-Smtp-Source: AMsMyM7pA4CBYBz9VUO/SHmDpNSich9Ia0/sJqXHITGbOjZvJdyv9F0xpY0akV2fVfUNIJxMT0DSG2qBpbgk
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a17:902:db0a:b0:178:32b9:6f51 with SMTP id
 m10-20020a170902db0a00b0017832b96f51mr405091plx.145.1665076311692; Thu, 06
 Oct 2022 10:11:51 -0700 (PDT)
Date:   Thu,  6 Oct 2022 10:11:29 -0700
In-Reply-To: <20221006171133.372359-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20221006171133.372359-1-vipinsh@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221006171133.372359-2-vipinsh@google.com>
Subject: [PATCH v4 1/4] KVM: selftests: Add missing break between 'e' and 'g'
 option in dirty_log_perf_test
From:   Vipin Sharma <vipinsh@google.com>
To:     seanjc@google.com, pbonzini@redhat.com, dmatlack@google.com
Cc:     andrew.jones@linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Passing -e option (Run VCPUs while dirty logging is being disabled) in
dirty_log_perf_test also unintentionally enables -g (Do not enable
KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2). Add break between two swtich case
logic.

Fixes: cfe12e64b065 ("KVM: selftests: Add an option to run vCPUs while disabling dirty logging")
Signed-off-by: Vipin Sharma <vipinsh@google.com>

---
 tools/testing/selftests/kvm/dirty_log_perf_test.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index f99e39a672d3..56e08da3a87f 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -411,6 +411,7 @@ int main(int argc, char *argv[])
 		case 'e':
 			/* 'e' is for evil. */
 			run_vcpus_while_disabling_dirty_logging = true;
+			break;
 		case 'g':
 			dirty_log_manual_caps = 0;
 			break;
-- 
2.38.0.rc1.362.ged0d419d3c-goog

