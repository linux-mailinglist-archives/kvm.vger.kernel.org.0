Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDBA1125E96
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2019 11:11:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbfLSKL1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Dec 2019 05:11:27 -0500
Received: from mail-pl1-f180.google.com ([209.85.214.180]:39462 "EHLO
        mail-pl1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726609AbfLSKL1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Dec 2019 05:11:27 -0500
Received: by mail-pl1-f180.google.com with SMTP id z3so2329763plk.6
        for <kvm@vger.kernel.org>; Thu, 19 Dec 2019 02:11:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=eE0ZKkUmOMgOE3HsieJIzrZOQCpkieai9Dy4KqlnxE4=;
        b=VAdUDrev8s3gokd7evm+Rrw/Ljt5WbOs/9k+wBcrCSympctjdj22svJktfNaUjdsxY
         Qyglt6XLwtW1uxzrJHJUGqNIuCqTuYiK+jH94TQcTd+zERtEEwvEULbCQtkKVx71odAb
         7XHdg/sNle+q5pT2nJjdwCaYRL4TyklS5PPSnbaLuDmJOtx46kGQ/aPH6AlEplTVtjrs
         3WTq61QFNwCKn7NvDdn7urwZwASivMFp3As0kYnkRP1rFO+Dey0JIskr+69YXV0Xb8ui
         pF7KZmKcHxTqIexAj2d21ZUoKhYKwJUWydAtM7F6DS94tmF5tWUDKv4YoPICHoSPyyjs
         kXOQ==
X-Gm-Message-State: APjAAAU16MlvWTXl1hc+aKXnA+n/f9jDMbctev5r+T2M+CSvIbGg3jog
        cjq4VexGL+aHfwOGWJvGosU=
X-Google-Smtp-Source: APXvYqxFWZTvy5fi1PA3rBsDH1mPGkKXVDBv66QU4++jHTpv6CIRiXqkXKHCM4oPLjpPdUdAJNWrwA==
X-Received: by 2002:a17:90b:d89:: with SMTP id bg9mr8785209pjb.75.1576750286439;
        Thu, 19 Dec 2019 02:11:26 -0800 (PST)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id c184sm7565530pfa.39.2019.12.19.02.11.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2019 02:11:25 -0800 (PST)
From:   Nadav Amit <namit@vmware.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Nadav Amit <namit@vmware.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [kvm-unit-tests PATCH 0/2] Better max VMCS field index test
Date:   Thu, 19 Dec 2019 02:10:04 -0800
Message-Id: <20191219101006.49103-1-namit@vmware.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The first patch improves max VMCS field index search so an exact
comparison would be possible. The second one does some cleanup.

Cc: Jim Mattson <jmattson@google.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>

Nadav Amit (2):
  x86: vmx: Comprehensive max VMCS field search
  x86: vmx: Remove max_index tracking in check_vmcs_field()

 x86/vmx.c | 50 ++++++++++++++++++++++++++++++++++----------------
 1 file changed, 34 insertions(+), 16 deletions(-)

-- 
2.17.1

