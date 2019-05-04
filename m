Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9C3B13D96
	for <lists+kvm@lfdr.de>; Sun,  5 May 2019 07:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726313AbfEEFxg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 5 May 2019 01:53:36 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:33951 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725814AbfEEFxf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 5 May 2019 01:53:35 -0400
Received: by mail-pg1-f193.google.com with SMTP id c13so4817444pgt.1
        for <kvm@vger.kernel.org>; Sat, 04 May 2019 22:53:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=6SJ5Fhu/0fxVKRncFORLAJP/ndV8tRMg/VhCLXPPc7Q=;
        b=fIpH+K5izX1b9b1B0D7unyZxM2IgxKAYT4kx0PTUUxWxygA3UC5NQ4mV6MPx9mwuLv
         5KYooobd2QbE6wlTs84yC1zmGxTD3Iw9VVGX7wFV4I/JmeZ8e7Jom+gKoYpa+J3rHRoN
         k9qh3NuT8u8h9HvepFJ/z+wHFAvSVto5VhwYz0AgyL3zt44JvuyYRZWeS8Sg7CQIyw7l
         Lm1SeoUm4RUfaR9ObrmHozO8J6vz4ts5pHejXwFUuM9oGsK6SUJDvFy5ErmNHNSMS57t
         vSgSzKv/5uyR4ID/BzaGDwuoo3p0M8in/Hi7bH0S1i2SklhuMKqKRa/pcM2L8ts4jvH1
         kTLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=6SJ5Fhu/0fxVKRncFORLAJP/ndV8tRMg/VhCLXPPc7Q=;
        b=bWqVIhCyeiEnuQGG7EZjYnUlLPn1nXNgOD/YN3Vb4Pa4Ar7yh90SEZ8/sGC2E/zOwy
         AIhCSwg8LES7GE9JgXbq/bJLRRxXUT//+03uqPjAuc6K2PwYzjN9nlAw+gxCXFujHQx3
         Rs8xc6h147EL0qLcKH3wmrUtOEX/SCo4u9/9HtOzpQLzlYUMa1dUnaYdqP8i0DdJrlu1
         ZwqQky/+llJsBAneEmEeVKE8LQ1dawhM7BU0a7rFbwvKE5FvK0/Us38OVeQzClfh2iGb
         zQ3D9ngrBwWskcFDYesp73W4XEPGoRgrqaPkSzCaqwYxPy9C56dUnQfCK+5RI2yyP6ph
         R+pw==
X-Gm-Message-State: APjAAAXoskKaPctZMrqNDZ46+gSMSfSJ2daZ6eGMarVyyPBs5kmFH1hb
        FyhocZExJ70lUieDmop7+Zk=
X-Google-Smtp-Source: APXvYqxPzqUvLrn/wY3GYsKmn17+ZhXjajh5DIyN5WtaBGPI7tvLj55vuwX/1I2rJsr8d5wLUtMsMg==
X-Received: by 2002:a62:87c6:: with SMTP id i189mr313940pfe.65.1557035614901;
        Sat, 04 May 2019 22:53:34 -0700 (PDT)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id g72sm20634160pfg.63.2019.05.04.22.53.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 22:53:33 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>
Subject: [kvm-unit-tests PATCH 0/2] x86: PMU: rdpmc fixes
Date:   Sat,  4 May 2019 15:31:40 -0700
Message-Id: <20190504223142.26668-1-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The PMU tests have a real and latent bugs. This patch-set addresses them.
Once the patches are applied, kvm-unit-tests fail on KVM, so a small fix
of KVM is also needed.

(I am not going to submit a patch that fixes KVM).

Nadav Amit (2):
  x86: PMU: Fix PMU counters masking
  x86: PMU: Make fast counters test optional

 x86/pmu.c | 63 +++++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 54 insertions(+), 9 deletions(-)

-- 
2.17.1

