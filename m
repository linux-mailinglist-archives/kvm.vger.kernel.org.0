Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD024E3D2D
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 12:07:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233908AbiCVLIp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Mar 2022 07:08:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233036AbiCVLIo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Mar 2022 07:08:44 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 398908021D;
        Tue, 22 Mar 2022 04:07:17 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id 123-20020a1c1981000000b0038b3616a71aso1277212wmz.4;
        Tue, 22 Mar 2022 04:07:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nuGWDZlXSZNQGXcVqmqYeVN3TUgNMalMalmgFdEvLsg=;
        b=X4RgYA0+Ajt10eWG3Cch8vH9Av08UbBn9ubtGq13/DWrudpJ9HsL8NBFjPSUVGn6mf
         NwZdtF8uAnK4t8OaDZfbPuRFUb4M2szufCnJ77oIudRfuZLBsOnsBCXuc3SQ72PreVmi
         0GJ/rFbF3XQbbIu5UtA/wmNCTc3XeseBSjrjD9iZZc2s30/TIfUnVH0tJsLMwKBduBX2
         ewi2AwR9tjbRS3WiL/OxG3kh57cl7AM7sScY2C7rjg9503Y7oRUad4M4U7CxJ4HmHe9t
         qmLv+HZ+Nm5KMpqztfekztjTkYJaz7eW3eNz9JlLspoqijvuTMz5RuSezD7rNbpBR+kz
         fsOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=nuGWDZlXSZNQGXcVqmqYeVN3TUgNMalMalmgFdEvLsg=;
        b=DlGi3IbJeAO0unAtcTHLQcc5bFw5qfzrTBdJKSSPVyXfg+M+NjkkAaA8N1vID/ltaZ
         glG2ydn1/LP/V84VMvXojNSzucNNBeFuRyxJWv/rHws6LTzg5GbNQJ/qaOE5VCGQ287l
         ruzk4yQP0xdU2Vst9wmC8EMsyyq4GklfgCn08PasF3HK8KsU5MNWwhqafeqpJWWvXFCF
         4m2Ap57pWVpGJWU9w8avtUieDEKc2QL4rYdTjZ/eFSgBld3IWh7qinQuexepiiv/a8Ig
         YCBd+O9f5fm8G+rzbNr54JQ69RjEg7nKjD+a0Vjysbv/VwruoMwnzTTZGcmNQxBsSs4Y
         OIfA==
X-Gm-Message-State: AOAM531zCU7Vkfih9EikUL89N0cNSQz/tNxlBDi0yyDrdxygiwPC2etk
        6zt1WqNmr7yWiy3AJ8XMzpF/YVqqZRY=
X-Google-Smtp-Source: ABdhPJyYkc/0WmhNc7t3CoJMz8icf/aTLLqcf8k5iFIr0sUggSjDbLvekBHQdd0qX0SvqiTcjPEdCQ==
X-Received: by 2002:adf:e348:0:b0:1f0:537:1807 with SMTP id n8-20020adfe348000000b001f005371807mr22271075wrj.11.1647947235642;
        Tue, 22 Mar 2022 04:07:15 -0700 (PDT)
Received: from avogadro.lan ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id f13-20020a05600c4e8d00b0038c949ef0d5sm1746379wmq.8.2022.03.22.04.07.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 04:07:15 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     mlevitsk@redhat.com, jmattson@google.com
Subject: [PATCH 0/3] Documentation: KVM: add a place to document API quirks and (x86) CPU errata
Date:   Tue, 22 Mar 2022 12:07:09 +0100
Message-Id: <20220322110712.222449-1-pbonzini@redhat.com>
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

Reorganize Documentation/virt/kvm to be less x86-centric, and add a new
file to document the ways in which x86 emulation is "wrong".  There are
surely many more, for now just add the skeleton.  Please reply to this
message with things that you'd like to see documented.

While at it add also a section for places where the KVM API is bad or
returns wrong values.  Please also include them in reply to this message
if you are interested in seeing them documented.

Paolo

Paolo Bonzini (3):
  Documentation: KVM: add separate directories for architecture-specific
    documentation
  Documentation: KVM: add virtual CPU errata documentation
  Documentation: KVM: add API issues section

 Documentation/virt/kvm/api.rst                | 46 +++++++++++++++++++
 Documentation/virt/kvm/index.rst              | 28 ++++-------
 Documentation/virt/kvm/s390/index.rst         | 12 +++++
 .../virt/kvm/{ => s390}/s390-diag.rst         |  0
 .../virt/kvm/{ => s390}/s390-pv-boot.rst      |  0
 Documentation/virt/kvm/{ => s390}/s390-pv.rst |  0
 .../kvm/{ => x86}/amd-memory-encryption.rst   |  0
 Documentation/virt/kvm/{ => x86}/cpuid.rst    |  0
 Documentation/virt/kvm/x86/errata.rst         | 39 ++++++++++++++++
 .../virt/kvm/{ => x86}/halt-polling.rst       |  0
 .../virt/kvm/{ => x86}/hypercalls.rst         |  0
 Documentation/virt/kvm/x86/index.rst          | 19 ++++++++
 Documentation/virt/kvm/{ => x86}/mmu.rst      |  0
 Documentation/virt/kvm/{ => x86}/msr.rst      |  0
 .../virt/kvm/{ => x86}/nested-vmx.rst         |  0
 .../kvm/{ => x86}/running-nested-guests.rst   |  0
 .../virt/kvm/{ => x86}/timekeeping.rst        |  0
 17 files changed, 124 insertions(+), 20 deletions(-)
 create mode 100644 Documentation/virt/kvm/s390/index.rst
 rename Documentation/virt/kvm/{ => s390}/s390-diag.rst (100%)
 rename Documentation/virt/kvm/{ => s390}/s390-pv-boot.rst (100%)
 rename Documentation/virt/kvm/{ => s390}/s390-pv.rst (100%)
 rename Documentation/virt/kvm/{ => x86}/amd-memory-encryption.rst (100%)
 rename Documentation/virt/kvm/{ => x86}/cpuid.rst (100%)
 create mode 100644 Documentation/virt/kvm/x86/errata.rst
 rename Documentation/virt/kvm/{ => x86}/halt-polling.rst (100%)
 rename Documentation/virt/kvm/{ => x86}/hypercalls.rst (100%)
 create mode 100644 Documentation/virt/kvm/x86/index.rst
 rename Documentation/virt/kvm/{ => x86}/mmu.rst (100%)
 rename Documentation/virt/kvm/{ => x86}/msr.rst (100%)
 rename Documentation/virt/kvm/{ => x86}/nested-vmx.rst (100%)
 rename Documentation/virt/kvm/{ => x86}/running-nested-guests.rst (100%)
 rename Documentation/virt/kvm/{ => x86}/timekeeping.rst (100%)

-- 
2.35.1

