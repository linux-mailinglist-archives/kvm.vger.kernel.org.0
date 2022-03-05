Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DACF64CE70E
	for <lists+kvm@lfdr.de>; Sat,  5 Mar 2022 21:55:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232403AbiCEU4f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 5 Mar 2022 15:56:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbiCEU4e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 5 Mar 2022 15:56:34 -0500
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A652460DAD;
        Sat,  5 Mar 2022 12:55:43 -0800 (PST)
Received: by mail-qt1-x82c.google.com with SMTP id s15so10258610qtk.10;
        Sat, 05 Mar 2022 12:55:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TxVTbF7faQZ0C3yA9uJ1FmB6syPw361zo4nrm2JprsM=;
        b=nWo1njd5nbEcfovdgmUbCmyCw2HOzWo1nG5o4Nayb5nbs+95rqXejlDzu14KGHYIol
         fli1ewDwyfcaichrfw/jTjx9e871ew4bO5+ZtvwkWgYQ3qQo/4y1+/L15/DcTR8V9rBj
         xqT34xwdGR1QRnM8qcuNcDbxZ6vWDW8tRtFVUaeX3Is37FIEFfjqLmHvMVloL/ymj+3F
         Jj/IAlE/R6L+vxnT5Ev47lJ1hRwMIg3gMRxd9+n2hJUB1R8EgqErkshpOE7S+gWQjRUW
         F7OAshRBlvs+3s8LXp3ucIUugDYKKrr6aQcmmttbk5Y6BQc+pKWgVJsGak82ZTqwc3Mu
         iFDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TxVTbF7faQZ0C3yA9uJ1FmB6syPw361zo4nrm2JprsM=;
        b=KLMhFOUdo8mRH7nBvrFmiAPZZnVrldWaOvesvR59guxNUwyX6QjKv9MxQfEKzXHk1C
         Dz7bXhR910qFJ1uNKGx/2kk67Ks5qqf3rwGfUnSuQCw9zEnMJM4jBSJrGptKJLVdC64h
         M9DWUeZsh8imA8GGzjkL9hFXeChgHv3Uj4gkhvZlpkYHPrXg7YZQwTOyHd4wPXubEOPu
         VDbwc/lYKhJfjCVZ5qhsKB+qBa2yEJ2yzg/X09pW476vuCjUOyVPv969FIzkOhrR3ryQ
         oTWUwp8XQ0io1Za8dBYWxlVGUR38v6XqPCFy8OA5bG9wKhNCHUPQufHYVK8/2GH8e8gs
         Jy9Q==
X-Gm-Message-State: AOAM533s9ifbhPUrkXMMzxZ2NF0rMgxRMNwuIm1USybt2MoXbA6NC6lL
        Onizo7Sqz0iiaT6w8hbSCRQ=
X-Google-Smtp-Source: ABdhPJzUTUS2fJxt7kgaREHyUZwDjOC/jddk2CN2biSBEYamwJaqlRcuG+JDTyZqD0vxpb/I7wrk0g==
X-Received: by 2002:a05:622a:11cd:b0:2df:f343:78f0 with SMTP id n13-20020a05622a11cd00b002dff34378f0mr3890981qtk.681.1646513742855;
        Sat, 05 Mar 2022 12:55:42 -0800 (PST)
Received: from henry-arch.studentwireless.binghamton.edu ([149.125.84.173])
        by smtp.googlemail.com with ESMTPSA id l19-20020a05622a175300b002de935a94c9sm5877525qtk.8.2022.03.05.12.55.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Mar 2022 12:55:42 -0800 (PST)
From:   Henry Sloan <henryksloan@gmail.com>
Cc:     pbonzini@redhat.com, Henry Sloan <henryksloan@gmail.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] KVM: fix checkpatch warnings
Date:   Sat,  5 Mar 2022 15:55:22 -0500
Message-Id: <20220305205528.463894-1-henryksloan@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patchset fixes many checkpatch warnings in the virt/kvm directory.
The warnings and errors that will remain are of the following kinds:
* "memory barrier without comment" warnings that don't have trivial fixes
* "function definition argument should also have an identifier name"
  warnings
* Numerous minor issues in kvm_main.c that merit a separate patch

Henry Sloan (6):
  KVM: Use typical SPDX comment style
  KVM: Replace bare 'unsigned' with 'unsigned int'
  KVM: Replace '__attribute__((weak))' with '__weak'
  KVM: Add blank lines after some declarations
  KVM: Use typical style for block comments
  KVM: Fix minor indentation and brace style issues

 virt/kvm/coalesced_mmio.c |  2 +-
 virt/kvm/dirty_ring.c     |  2 +-
 virt/kvm/eventfd.c        | 21 +++++++------
 virt/kvm/irqchip.c        | 16 ++++++----
 virt/kvm/kvm_main.c       | 64 +++++++++++++++++++++------------------
 virt/kvm/kvm_mm.h         |  2 +-
 virt/kvm/pfncache.c       |  2 +-
 7 files changed, 60 insertions(+), 49 deletions(-)

-- 
2.35.1

