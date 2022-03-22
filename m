Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3BB44E3D32
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 12:07:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233995AbiCVLIy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 07:08:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233973AbiCVLIv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 07:08:51 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5845A81667;
        Tue, 22 Mar 2022 04:07:23 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id q20so10424164wmq.1;
        Tue, 22 Mar 2022 04:07:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G9NF/ByvMZihSi8ycFZxd0KaxgpJjfhbjqpzyReIHA4=;
        b=ezlqtlyUZMMiSdjOMfwXeF3Z2UZKLjwusVLC04xgFmalO4LHIho6PG/IKjsVFrziw8
         a+PTTxlbE2uaoT4Xk/acHIr4gJsOULx9mESGktVz4tCyOLmuTteypMCIjyWjGjIMHI5m
         7t1KgV0jbp4k5tx93HXqGvIENa/Lj4/vwbN38Ar8JJ9kkPSIFv1Ln3fsPoSLg3ieHeJb
         c7XtrFidQyRQ4yFHDodYrV6sCCHC9IZSVavYVuza2kebd8L5JRXmU2TcF+uqt1gS/KFN
         /u2nawhKoZmRn5O+kOTyk0MqQE8VxIl07etAWXeGzNA6VodsKP75m/oRptWR/z5D84+l
         Op1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=G9NF/ByvMZihSi8ycFZxd0KaxgpJjfhbjqpzyReIHA4=;
        b=IT0oSdW/AQJ0bm8KuxCx5GR943D+Nwtcqo+1elKApy4Af513NmXH1NrtI8p3ZWEf52
         Rrj9ChP2o4/0EplHJGvaIDEQNM8cgLTSMc1tVU1i923jnH1mT5fZj3MCWcj3rsb9bon8
         QEBj2CW8ueDapfhqVrf5KeLbo605Q7g5PY99Jt3YdLD1kdtz+rC5d6Dgywv8rWKavUwn
         mghaxhWkjHKG0aHEz9RM21s2ES/fGN3zFk13UriTSeN2TA+Rv4+A/2tqCI07w4Oh0sY/
         1C57VZhv9Jkym8TdsWR/AaPo9s0py22ypfY92EB0dLFX/O/09IkEQiI/s6BYX3aeY4zC
         fgpg==
X-Gm-Message-State: AOAM533rBTamrObqUaaXQTAGl1KMt6c4KCSNgxTwBv+hJLY+L1s5grBy
        zZ1SO1oie2t8X6XqSv45FPJjEQx5HBY=
X-Google-Smtp-Source: ABdhPJx+sJa1O7YnBhUXmGPttjLXE2biLyySMCCW2bmHtZ31GvxGjcAnlRGLYAE4tHWSR4KHP7z/yQ==
X-Received: by 2002:a5d:526d:0:b0:203:d69f:3a66 with SMTP id l13-20020a5d526d000000b00203d69f3a66mr21673708wrc.74.1647947241856;
        Tue, 22 Mar 2022 04:07:21 -0700 (PDT)
Received: from avogadro.lan ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id y11-20020a056000168b00b002041af9a73fsm4221856wrd.84.2022.03.22.04.07.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 04:07:21 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH 0/2] Documentation: kvm: improvements to locking.rst
Date:   Tue, 22 Mar 2022 12:07:18 +0100
Message-Id: <20220322110720.222499-1-pbonzini@redhat.com>
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

Improve the formatting and update the documentation.

Paolo Bonzini (2):
  Documentation: kvm: fixes for locking.rst
  Documentation: kvm: include new locks

 Documentation/virt/kvm/locking.rst | 43 +++++++++++++++++++++++-------
 1 file changed, 34 insertions(+), 9 deletions(-)

-- 
2.35.1

