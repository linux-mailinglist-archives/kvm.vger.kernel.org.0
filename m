Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B87A4848E8
	for <lists+kvm@lfdr.de>; Tue,  4 Jan 2022 20:50:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231667AbiADTuH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jan 2022 14:50:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231838AbiADTts (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jan 2022 14:49:48 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F687C061785
        for <kvm@vger.kernel.org>; Tue,  4 Jan 2022 11:49:48 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id p1-20020a17090a2d8100b001b1e44000daso345001pjd.9
        for <kvm@vger.kernel.org>; Tue, 04 Jan 2022 11:49:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=T6hXHkZPRWaJl03x2QXMcgYQnVlGJ4p7Dp80AmXpDqA=;
        b=AJ0bPZ1NpwYWYRZhLndCTSqogOo7XiUaZ/UjLqVU7cHLs9Mdi7SUhYWX2x/576gx2r
         tCLIGd6Pr6yHqtDaYDXsqcwF6ITe6QPsyRqxaOReY21N7Kl6+Sx0+V0uK2csFJY6XybX
         0xVsPtfmN+qRC5kGYfgt0H1p8vYf+hx+DY3VgQn157Yrt9QxI7PwsTwKW/eYXwq/OMsP
         Se9XKtz2lEF3/2kC0pimss9ZxccQiX4bCZtcruP4575qQvSGJySRVLFi2vqkcLM772ha
         kFILLe4Btz7d++g14WBdW4sIHMdzE6yJ71iPC6HdvWb7M4xW8tOAl5X7Pubxi3+fJov5
         AKjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=T6hXHkZPRWaJl03x2QXMcgYQnVlGJ4p7Dp80AmXpDqA=;
        b=osuyrdsoPk1pc7V51olEAGk20zlS0EYiYBGYwNyttZMSvEKHLuzAqPxJfgTPGUC3uq
         UYDi+kxjMuwlL7OZWZRJYX4jGrBlkdH+4VGZZAdHK+RGMjrAUgF1SMsCRLgeDp3drav/
         AEP9JB+0XEaWm6mCo1aVbOjzLQdAbusEfSnjMw9AxoNRifEDu7v88zD/54sGboRPTRXA
         FBiyPJlYutrmJR2wVbB1YkXisLeQ7hy2Y2221PVeD2+8aiCulmwlzGr7FeluRJR+fhxZ
         ce4CuV9PD8neLlxGvo5teeNobtoN4zDiM19Xe90ifk2xLIgAdgKFgMknJr/pUb2NQAvI
         TlcA==
X-Gm-Message-State: AOAM532HQcNkAK4kORGI61nmop3F3DU/O1Ycok8Xyigbjuq0KKed6o/T
        f2COp8kbtCBOb+Xc6VBhWOvtYpltv37q
X-Google-Smtp-Source: ABdhPJwQF9Sh0A8e10VxttETJKJYLzfkIBz9hQW4ADfKatROuxTA+/JgjcWs4dTYR/RUwb0w/HuKzInAFEzp
X-Received: from rananta-virt.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a05:6a00:139b:b0:4ba:a476:364e with SMTP
 id t27-20020a056a00139b00b004baa476364emr52491553pfg.59.1641325787730; Tue,
 04 Jan 2022 11:49:47 -0800 (PST)
Date:   Tue,  4 Jan 2022 19:49:15 +0000
In-Reply-To: <20220104194918.373612-1-rananta@google.com>
Message-Id: <20220104194918.373612-9-rananta@google.com>
Mime-Version: 1.0
References: <20220104194918.373612-1-rananta@google.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [RFC PATCH v3 08/11] Docs: KVM: Rename psci.rst to hypercalls.rst
From:   Raghavendra Rao Ananta <rananta@google.com>
To:     Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since the doc now covers more of general hypercalls'
details, rather than just PSCI, rename the file to a
more appropriate name- hypercalls.rst.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 Documentation/virt/kvm/arm/{psci.rst => hypercalls.rst} | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 rename Documentation/virt/kvm/arm/{psci.rst => hypercalls.rst} (100%)

diff --git a/Documentation/virt/kvm/arm/psci.rst b/Documentation/virt/kvm/arm/hypercalls.rst
similarity index 100%
rename from Documentation/virt/kvm/arm/psci.rst
rename to Documentation/virt/kvm/arm/hypercalls.rst
-- 
2.34.1.448.ga2b2bfdf31-goog

