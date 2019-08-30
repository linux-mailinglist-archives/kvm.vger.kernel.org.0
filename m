Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10BB2A4201
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2019 06:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725836AbfHaEBJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 31 Aug 2019 00:01:09 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39003 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbfHaEBJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 31 Aug 2019 00:01:09 -0400
Received: by mail-wm1-f67.google.com with SMTP id n2so7934629wmk.4
        for <kvm@vger.kernel.org>; Fri, 30 Aug 2019 21:01:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=aFgjEyt2f2xwpTXKSn8usPjTng/v+Jzn84j9AbAhOVc=;
        b=hjAIOGzffKwpNC1gd4yxe4OA6XabkHYiYGPplxMs/0MmbzNSRqx/N03wLcET7NljSg
         Vg5kJ/XAav6Kax2LyuxFcqQCX3S6Hego5nSPTmo4NfqEPYTkHdW3Ib/nhAVXchWv08Kh
         WjOAGT/2Eu7AKiQ59+KaigccehXMs+wUzrAlf1d7ml3p/mjR/apR0WqERK5lrfgnI3uE
         62xd02sdFCVHxu5FIK46bsN/02gKD1QYYoLOr0gsX52HWPS3NIABm6Jk4Cwh1rrbTsfI
         JTk959fbI96PEsH+kNDpTepNJtzyY/LPDVxO/ZaTu1xMHNQS6BDPwpyWXdAvVVuuwhX5
         p72A==
X-Gm-Message-State: APjAAAULhLtUFpNmXapXPydT7xPAfIz6ZsvcK6vXysgmZFiEiZt2VSba
        CcN1qNQZv0dgMe0UaA81QBo=
X-Google-Smtp-Source: APXvYqyYGc+cnUIRt5pN7foGLrxfgMubJ8eMXU2mY/0T1aH5FY8SnJcU6MMiUrT64TGSUxCFPZpUdg==
X-Received: by 2002:a7b:ca54:: with SMTP id m20mr22270898wml.102.1567224067432;
        Fri, 30 Aug 2019 21:01:07 -0700 (PDT)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id e4sm4656470wro.21.2019.08.30.21.01.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Aug 2019 21:01:06 -0700 (PDT)
From:   Nadav Amit <namit@vmware.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Nadav Amit <namit@vmware.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Marc Orr <marcorr@google.com>
Subject: [kvm-unit-tests PATCH 0/2] x86: nVMX: Bug fixes
Date:   Fri, 30 Aug 2019 13:40:29 -0700
Message-Id: <20190830204031.3100-1-namit@vmware.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Two bug fixes that were found while running on bare-metal.

The first one caused the second bug not to be found until now.

The second bug is an SDM bug, and requires KVM to be fixed as well
(consider it as a bug report on behalf of VMware).

Cc: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc: Marc Orr <marcorr@google.com>

Nadav Amit (2):
  x86: nVMX: Do not use test_skip() when multiple tests are run
  x86: nVMX: Fix wrong reserved bits of error-code

 x86/vmx_tests.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

-- 
2.17.1

