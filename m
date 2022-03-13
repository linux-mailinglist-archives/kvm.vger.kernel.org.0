Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAD7D4D75AF
	for <lists+kvm@lfdr.de>; Sun, 13 Mar 2022 15:05:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234351AbiCMOGg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Mar 2022 10:06:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230344AbiCMOGd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Mar 2022 10:06:33 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1A8A9BAEE;
        Sun, 13 Mar 2022 07:05:25 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id t11so20010205wrm.5;
        Sun, 13 Mar 2022 07:05:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/EddZV/b+4PgtagpCEfBxzLPicZiiGFAhLBF4z3UI0A=;
        b=Xgch+ORSVcwZsnTf3m7FIHyB0wkMe6Sy9r+til60go7yOaLPO88VkE/TscU6BfX1kV
         l2SzZU2VAd9NBZiIIA239oN09nr0Jic8ez/yppdUmGKrY1YLTnw+VUBy39mSyLoeKdKs
         EMZlylBVdIIG24wz/j/thTi8gTcp0bzkG7j0UjC0WNbc7ph7gZDDSfnw/hS6OOfd6WLs
         S9uQ7l/szaCSINQ6NmwivYG6BoSXMAgx2TTr2idUw5mLjewineC1fAGXh+80XnDa2ygy
         h63IGqvqzj/USU1FjtQh3fKi8o0xDKuEfi65hMO8iEWLPgDsbZRQKdUhgXVzP4YMZd9o
         /F9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=/EddZV/b+4PgtagpCEfBxzLPicZiiGFAhLBF4z3UI0A=;
        b=vA4ORhbX8jDVY8hOnFDAJNYowWVQrG3T86GZjErX5wSWr0OWw2ViVaOXkY+zX/sLZT
         DKL+mVsVbVdCUYdUPxBKsZMndBDno2L+Dcwh/DXqZi/8h7swLc4euly37v78Fzp7sA9Y
         9e+/EWQpxHiGnaEiRD/2J+gEZM3t+cLqWNZN1MneH6IThfj9TsSRc2bhbu7Dnx3KQ9RF
         SSu4rPGoOeYA3vIkmf6HAF9Xv3PlxUMpECiBkg8i7QSGv5PV4qIfUoQxRhMz36ipoh+m
         CJExq69J6Y292545PERxcGh+04U/bS2GyaZi7GRIV58cXQXeFviR/SqkPsBIIm4THiD7
         a1yw==
X-Gm-Message-State: AOAM533DPk4UHukJIAwu9tP5BFICq55KM8bPFdX1uKkRZcS0SP/7ONZB
        MHtS5ayWPK0/ticLizGW0PEoEBsNKUg=
X-Google-Smtp-Source: ABdhPJzbm0hIqHUtnlcNoubypbWYuXzb29GMxO2XqDvwooN0WFaCoao59xhMka3vlwoI8+8wZug0tQ==
X-Received: by 2002:adf:fa45:0:b0:203:954d:d5e3 with SMTP id y5-20020adffa45000000b00203954dd5e3mr8546477wrr.533.1647180324508;
        Sun, 13 Mar 2022 07:05:24 -0700 (PDT)
Received: from avogadro.lan ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id f22-20020a1cc916000000b00380d3e49e89sm12003765wmb.22.2022.03.13.07.05.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Mar 2022 07:05:24 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH] KVM: MIPS: remove reference to trap&emulate virtualization
Date:   Sun, 13 Mar 2022 15:05:22 +0100
Message-Id: <20220313140522.1307751-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 Documentation/virt/kvm/api.rst | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index a6729c8cf063..5d772459028d 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -151,12 +151,6 @@ In order to create user controlled virtual machines on S390, check
 KVM_CAP_S390_UCONTROL and use the flag KVM_VM_S390_UCONTROL as
 privileged user (CAP_SYS_ADMIN).
 
-To use hardware assisted virtualization on MIPS (VZ ASE) rather than
-the default trap & emulate implementation (which changes the virtual
-memory layout to fit in user mode), check KVM_CAP_MIPS_VZ and use the
-flag KVM_VM_MIPS_VZ.
-
-
 On arm64, the physical address size for a VM (IPA Size limit) is limited
 to 40bits by default. The limit can be configured if the host supports the
 extension KVM_CAP_ARM_VM_IPA_SIZE. When supported, use
-- 
2.35.1

