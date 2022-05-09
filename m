Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AFDC51F46D
	for <lists+kvm@lfdr.de>; Mon,  9 May 2022 08:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230058AbiEIGOW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 02:14:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235759AbiEIGLQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 02:11:16 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB215170F26
        for <kvm@vger.kernel.org>; Sun,  8 May 2022 23:07:23 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id k14so11191518pga.0
        for <kvm@vger.kernel.org>; Sun, 08 May 2022 23:07:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dNam4NRqULz5ngQJv/Hr3VjArBiTEWxDny0ZL2+Io9U=;
        b=dPq3yY7EG5ylSK+rjMmRLKT+ixv0ENM3fCJuMlr93a3g3nsC3YidXBc7z1I53YnSt+
         G064wONruJW7U1oAvryn/yC/EH1CMKZAz8wPzoWibJ3aLmJ7LvjDMxXUpDb3c2XmRJOH
         A1zjn1n7BpVaeaiw7tApKppo7kZg8ythmCIJAP6je7afYD04nOqUbKMkKdfGrafqpald
         N+QaLI77ovp24bmcPODSy05aMrLtXd4smLr1AR5tfcVVWZg90iW3q5ROCMZKIfk1Io02
         hMvQdzr/JVJOHp2282+DZnEt+ldYKcWp5sDjZdj+n7oTp220vEB0MwDwCuMgStHr66VH
         Weow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dNam4NRqULz5ngQJv/Hr3VjArBiTEWxDny0ZL2+Io9U=;
        b=jOfi6fy5w1DGalfNpwwRNQB0I+YzAPYnX6hyy9BCdGJaxHQSntPMGlZ5a2lm2XHiLO
         5F8OqHwnfiISVi6+NwOYI5p2wikvlw2YwY8rE0K7Lony9eUAbVV1286HC6CCi1OJOspz
         dh8tVlOzZpw729wHZKWkvcOnk0k4kyf4q5XUItb9c2FldKhmpHEWz/Ti+VJRyIwctMDj
         GtMrjXtgqalEbSLwFCECORQHtag2YTomnRJ5JWGd7ucR4v9b+PwPqKso8lAE3R79Z1/c
         SI0tUblPc7CT1y3a6vOvq3OBLxuRGjsHP7xI+8YzyLTcI0lJjQn+VSRgV5N07LXxxpFj
         rTAw==
X-Gm-Message-State: AOAM533a5vEeRgndWnjUefCAX6lJ1dFIVfvoRBeg14S3a8puV9cZnLlK
        ZlkIUKDUFTjLWI/ZwBZvCcp9oA==
X-Google-Smtp-Source: ABdhPJwhPZEA9MJp5FqlgDa6QmKne+WzgM7zzcJh6yNP8eD7tE4O+NrmEyx8KPG1/ObV9NbCTfC5Tw==
X-Received: by 2002:a63:165f:0:b0:3c6:ab6b:a6d2 with SMTP id 31-20020a63165f000000b003c6ab6ba6d2mr4338868pgw.610.1652076443185;
        Sun, 08 May 2022 23:07:23 -0700 (PDT)
Received: from anup-ubuntu64-vm.. ([171.76.80.217])
        by smtp.gmail.com with ESMTPSA id g6-20020a170902d5c600b0015e8d4eb291sm6126748plh.219.2022.05.08.23.07.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 May 2022 23:07:22 -0700 (PDT)
From:   Anup Patel <anup@brainfault.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] MAINTAINERS: Update KVM RISC-V entry to cover selftests support
Date:   Mon,  9 May 2022 11:36:34 +0530
Message-Id: <20220509060634.134068-1-anup@brainfault.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We update KVM RISC-V maintainers entry to include appropriate KVM
selftests directories so that RISC-V related KVM selftests patches
are CC'ed to KVM RISC-V mailing list.

Signed-off-by: Anup Patel <anup@brainfault.org>
---
 MAINTAINERS | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index e8c52d0192a6..ee73a71c1500 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10767,6 +10767,8 @@ T:	git git://github.com/kvm-riscv/linux.git
 F:	arch/riscv/include/asm/kvm*
 F:	arch/riscv/include/uapi/asm/kvm*
 F:	arch/riscv/kvm/
+F:	tools/testing/selftests/kvm/*/riscv/
+F:	tools/testing/selftests/kvm/riscv/
 
 KERNEL VIRTUAL MACHINE for s390 (KVM/s390)
 M:	Christian Borntraeger <borntraeger@linux.ibm.com>
-- 
2.34.1

