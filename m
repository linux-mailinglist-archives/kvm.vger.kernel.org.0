Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2646525855
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 01:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359490AbiELXax (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 19:30:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359484AbiELXau (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 19:30:50 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F06D62E6BB
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 16:30:47 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id m11-20020a170902f64b00b0015820f8038fso3398111plg.23
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 16:30:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=YQ6YvezgsmiEyUqVYknbpLJGZ314bsu7n05KTWeEMPg=;
        b=cFcdqp55+wqRuyaIki8fo9GiJAhbW7iwQPhs/fXGGtdEZ4MKV/Q+q12zFc6wu3P8ds
         VaFe8Me3EcfhH7CG/kXgAJqYJPLTGSjtUZKdj7XhkXlskM0M/2Rs2YNu0YW5lFnxgcwi
         j34PyShkT5CWiT/c3QnDynySiCRMuv4ofTdjRh8nVIaUAOwUgrDUUwXfGxpe9ZVTywxF
         TNYItJCgeZr1xJMNDItlX8GJZ4cTvdVERypbaJDeTZpil0JXbEuhaNe2Q99b9cjj1DYt
         16BpO6v48SzLKzjJYuv6gxeCRxF1RDu/ZN83Nw2jHm8khc2oTcnzJbXtfV8JpXp5AZXZ
         7RSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=YQ6YvezgsmiEyUqVYknbpLJGZ314bsu7n05KTWeEMPg=;
        b=mxWIr5wpmrIIy1N7YG1W7M9NsY2FLcQIyYuNSBNAYw/h2cpg5fC4yiVCs3gkZuyvlZ
         JH6VfYIzqzVUKF/y6QKzt6UcW4+RqFrlyCBbIBJZhDS0+XU7o6w3gcRWchx0ScQelLHz
         dv7VxuvNdmFw9bqwf+VdaPaDCZwKau3sr0VRjcjuDg1i772SV+BHEXmW1OWRb57tWdQz
         z2iNbua1Pb47Bd9CcV/UpWtfV6pqUxvChu3fcQYI+DSkBeqizDeBr93D3OKstnIiLow3
         mAbjeezy1bGmCkyZ8VSYlommeBNWR8lDZ5orKdbr3XerKRcwrJhCiUjrnqPeUcSTmicO
         Uy/A==
X-Gm-Message-State: AOAM533g0VxreLp/lV/YLdrvw2AiQoq/Z4/B6VfoGgnU0jf3r+eBQ8wW
        n1/KHhPMwsx9mkphM61bp++PbOGolqQ=
X-Google-Smtp-Source: ABdhPJwCH/oe9GDo5rxa7uGhh1FUiJ/umFb0EQQfSd9kj5UgoL91f6ppuEQgBnoVnyAfN6TViXWHGUfvGDo=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:d2c8:b0:15e:a266:6487 with SMTP id
 n8-20020a170902d2c800b0015ea2666487mr2066264plc.8.1652398247418; Thu, 12 May
 2022 16:30:47 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 12 May 2022 23:30:43 +0000
Message-Id: <20220512233045.4125471-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [kvm-unit-tests PATCH 0/2] x86: msr: MCi_XXX testcases
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add tests for MCi_XXX MSRs in the 0x400-0x479 (inclusive) range to verify
they all follow architecturally defined behavior, e.g. CTL MSRs allow '0'
or all ones, STATUS MSRs only allow '0', non-existent MSRs #GP on read and
write, etc...

Sean Christopherson (2):
  x86: msr: Take the MSR index and name separately in low level helpers
  x86: msr: Add tests for MCE bank MSRs

 x86/msr.c | 102 +++++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 82 insertions(+), 20 deletions(-)


base-commit: 6a7a83ed106211fc0ee530a3a05f171f6a4c4e66
-- 
2.36.0.550.gb090851708-goog

