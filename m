Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 381145352CC
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 19:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347441AbiEZRkO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 13:40:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348362AbiEZRkL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 13:40:11 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5266F9C2DD
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 10:39:53 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id y15so2508958qtx.4
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 10:39:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oxidecomputer.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yF5F4D9Ewqej4ptYj9d8W3vBehH4ZTovu1ATuJ2K0SM=;
        b=lT2fOrOgkNkZENDF5J89j83VAWhI0UvRXguT5/jM7IS8SfoI8MyeANRCJi+b2ZSGgY
         Q+x0tRsJpJGbgnXAyJ13Mhw87sMe0K54mpDbLZAktvNaa6o80eMtgOH9s19MZNYBmO3K
         swTL4h8laQOa0dG+m+p2KXQxxNdIgDo3sWepfgBIjvBeZawpzwSzjsnPCbaL4JECAv7r
         3eC/vmHhd3hum8azvaq7uRlLoC+mNVn7BHeLY7WuW97+eVM+2EfzTtefMS/ps5+1/nmi
         MSL58a97rak5tEdU8XjQpF69sro6cLVkqNNquYqFLVinGDH1beRv3V/0VyHFhFbeCkvj
         5j8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yF5F4D9Ewqej4ptYj9d8W3vBehH4ZTovu1ATuJ2K0SM=;
        b=5zvhxn9+GUQr5ttx4HGyIBZVBtFAA0SDJ9SUjWLomyu3/411zsM7R+AfmW7uBoOaNI
         7jvlEdInsQg7/0q+bl4BZSI62Ebuhb9rRjCB/3vMEBon2OY2YQuXHwZdGeXQe+invZ8b
         22VdoiPMKWgu8h3Ukl86IQLIyU5yJ+fshroy0das98eWkNXI9XO+tDN32ZCJhmMlk0VA
         1T2G2qD7vYPdXBITpL9rM8fqrios1ecWl7bED9oFZRcl1V5PLQcF8HmPVs8jL0ttffYI
         OVyYA0c2dMOiyZ7hcI8iRUYA3Jg4Au/Z1ABRlKbn5s73BfglLARsXOfzYK8IJYK1Pcjg
         PnjQ==
X-Gm-Message-State: AOAM531ZkIO0K5OafVcVDWELD674uxquswC3oleWewFRgDmUKjogcuXc
        tLrW1qoGGVReJW+L938O8H68YzCwf/HUF7Z8
X-Google-Smtp-Source: ABdhPJwbD/21Qv1kP/hHWFjC/3Sa3TCe515kcl9kW47zd5wsu7kGgKVBeZzfLLygi6aAa27+U/mcHg==
X-Received: by 2002:ad4:5944:0:b0:462:310a:b54c with SMTP id eo4-20020ad45944000000b00462310ab54cmr19647907qvb.41.1653586791149;
        Thu, 26 May 2022 10:39:51 -0700 (PDT)
Received: from doctor.oxide.gajendra.net ([2603:3005:b04:8100:f692:bfff:fe8b:cf8e])
        by smtp.gmail.com with ESMTPSA id bq15-20020a05620a468f00b006a5a07bb868sm1592257qkb.119.2022.05.26.10.39.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 10:39:50 -0700 (PDT)
From:   Dan Cross <cross@oxidecomputer.com>
To:     kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dan Cross <cross@oxidecomputer.com>
Subject: [PATCH 0/2] kvm-unit-tests: Build changes to support illumos.
Date:   Thu, 26 May 2022 17:39:47 +0000
Message-Id: <20220526173949.4851-1-cross@oxidecomputer.com>
X-Mailer: git-send-email 2.31.2
In-Reply-To: <20220526071156.yemqpnwey42nw7ue@gator>
References: <20220526071156.yemqpnwey42nw7ue@gator>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We have begun using kvm-unit-tests to test Bhyve under
illumos.  We started by cross-compiling the tests on Linux
and transfering the binary artifacts to illumos machines,
but it proved more convenient to build them directly on
illumos.

This patch series modifies the build infrastructure to allow
building on illumos; the changes were minimal.  I have also
tested these changes on Linux to ensure no regressions.

Dan Cross (2):
  kvm-unit-tests: invoke $LD explicitly in
  kvm-unit-tests: configure changes for illumos.

 configure           | 5 +++--
 x86/Makefile.common | 6 +++---
 2 files changed, 6 insertions(+), 5 deletions(-)

-- 
2.31.1

