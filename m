Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DDA28E5A1
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2019 09:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730197AbfHOHl2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Aug 2019 03:41:28 -0400
Received: from mail-wr1-f42.google.com ([209.85.221.42]:39980 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726366AbfHOHl2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Aug 2019 03:41:28 -0400
Received: by mail-wr1-f42.google.com with SMTP id c3so1407241wrd.7;
        Thu, 15 Aug 2019 00:41:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:subject:date:message-id;
        bh=deyMEqecYGNInZ+LD+Hev5MlWowJ15LiWFlPKdOndVc=;
        b=nc/4kx8GcIj4RcSzp4CrYfL3aUTnKKpo34S7R/746nRrVxIib6FK8cejN1DnBQHLZw
         1IlXEIAYf8oFshrh9WvuK524yI8IhFwWrKOJyUtWitDY/s3mMA0fDF9zYEsuRDd95Pqm
         JXj1dN8HaYyiLH+mCl4iYtHZxF0UzQXFr12sK6ANhAyN57AQqSfma81802SyShSQQGZs
         R4gHAEw5U2NkCyhCgeaOaRuBT8MosyebjfgpXUuUC+wa5qsrUSZbRhJ7M7zhRcmcIGqn
         sF3n32BJoY7DfTtmaushjS/a7Blq7xaT7zfnHA19wrXv4RqUPCPdf9qjRgy4I9Fi9thQ
         cGhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:subject:date:message-id;
        bh=deyMEqecYGNInZ+LD+Hev5MlWowJ15LiWFlPKdOndVc=;
        b=LiWu+/e+xKQ6Ic4+umWA2sBFMxbXBe34tAsVgcmRzAFkTFG4CVU3cc22rWgoSl5Ssf
         OQoq0agOHpUpMLUKaLszXWmY+MMY+gtzZodEH0wofHQHra71bmxj3GvWLgt1+BUBiobj
         jxZam6xXI4cyI2UzHxytKiz5TcNXfu3JJ1T29wrPQagJEu5q+G8vYQkDw5oxMUoM5wUY
         hWiqzdFJI1dNbOnLUKG8FwVHNjym1CLLVQmwCpx/QAcOmxmLnAAIwimw+9ht/pext07w
         P5Emk/KaflAd0LahWqiT0cB6ahPd7+DHwElUsGLeLK8masvbP/oIHkVvA4uuLAs58y/9
         QnVA==
X-Gm-Message-State: APjAAAVvelzr6lTrqwthulHbhINpHj2TF6NfQil9ndM+oDy1u+Nuq5ud
        L4Tf87CdGud+5tBjdaHkH7I2fkvA
X-Google-Smtp-Source: APXvYqydTfEE5kXYx4YCC9miWIWJNo3l/PtV861USHpsj1NvABtbFGwjVEGG57Mj0uH5rv04EtD1Ng==
X-Received: by 2002:adf:fc51:: with SMTP id e17mr3862284wrs.348.1565854886490;
        Thu, 15 Aug 2019 00:41:26 -0700 (PDT)
Received: from 640k.localdomain.com ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id m23sm809796wml.41.2019.08.15.00.41.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 00:41:25 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH 0/2] KVM: x86: fixes for AMD speculation bug CPUID leaf
Date:   Thu, 15 Aug 2019 09:41:21 +0200
Message-Id: <1565854883-27019-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Patch 1 fixes the reporting of bugs and mitigations via the
0x8000_0008 CPUID leaf on Intel processors.

Patch 2 fixes the reporting of VIRT_SPEC availability on
AMD processors.

Paolo

Paolo Bonzini (2):
  KVM: x86: fix reporting of AMD speculation bug CPUID leaf
  KVM: x86: always expose VIRT_SSBD to guests

 arch/x86/kvm/cpuid.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

-- 
1.8.3.1

