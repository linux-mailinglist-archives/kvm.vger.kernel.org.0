Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49B01BE220
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 18:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2501923AbfIYQOb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 12:14:31 -0400
Received: from mail-wr1-f50.google.com ([209.85.221.50]:40856 "EHLO
        mail-wr1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2501879AbfIYQOb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 12:14:31 -0400
Received: by mail-wr1-f50.google.com with SMTP id l3so7639393wru.7
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 09:14:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=jH89YR3V+7ra19Tk0nEdNwJtpzPMPzTno2dxgTzS6Tc=;
        b=W2oyofFO5CPfsaHaaTmqs84aktbCVYjXDIdtmG6Lo752EqaQC69+xy599vV77wnIpP
         ijuSpcsWd9NS7GrDSj8hErnLarSq1lKqvtAJaI/9X9vzksUG7irsN7fS6SEaS/sYNcoB
         Vjh0LaJIYEjNXwVBbNdt5TlJvhMs53fE5bUPH1q2zfwKzmbb9Blv0OZQy1vwYAtv9e6P
         D5rHGri5fCUssSZKd7CgQafqZawInZI0VGHS95MEBxi1F7o74M5yT6M8Ew2K/lsUgbhv
         ZlV/r3bVPjmZ2Lqf6POGLM6cFN5ZtN62bhZZ88Cb9bpC2tFe/FsrvGV7KH6fS/XtPFzE
         5g5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=jH89YR3V+7ra19Tk0nEdNwJtpzPMPzTno2dxgTzS6Tc=;
        b=ngJzXTKZ9Jp7McSCujbEWf1YEkUCPhEeVhRJDQt/+aw6Q+fhleZRiUxgkbtzRQLbgE
         ZI0PlrjlbqypC/qG8wBh4MLOK9wtWkotXcsoAYMI/m+3s6EQkr5uKIZF4BMcKw/Nck8x
         ozeb6wdfl2+sWch1ynGv8X7e5DE38aoS+1/9wE331rZZ5kXHUUBpJFf/0pdg3KQxT24T
         tPqTAUnol3hv/idC2ElcJr5ai6ZvIsWp5JKVb7AnMk+KjeMMpYfLYPaGLBhWrTkv2ysb
         L0FjEVDa4Kme1R0O1RNkAg8nc2LAPkXPQca6Jq82qQqO52Tp21bw3ufxFt3Uf00d3gdd
         GI0g==
X-Gm-Message-State: APjAAAXwbcRfw9YOdoRCgjf81Zsc+EeVube7wBYumqg5UVfgJCKoAp+G
        w5X7rUyRHxParXmCRmf0GE/mv483
X-Google-Smtp-Source: APXvYqyk5MKWkphEFJErfhbHZJJGVxKzbTWVbpALHTGbpsv9DD7wITvI+6OMACYY5tvexuU1lO/xyQ==
X-Received: by 2002:adf:e546:: with SMTP id z6mr10157421wrm.113.1569428068575;
        Wed, 25 Sep 2019 09:14:28 -0700 (PDT)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id a71sm4055293wme.11.2019.09.25.09.14.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 25 Sep 2019 09:14:27 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: [PATCH kvm-unit-tests 0/4] test GUEST_EFER field and address size controls
Date:   Wed, 25 Sep 2019 18:14:22 +0200
Message-Id: <1569428066-27894-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series extends the HOST_EFER tests to test the host address size
(patch 2) and adds matching tests for GUEST_EFER (patches 3-4).

Paolo Bonzini (4):
  x86: vmx_tests: gate load guest PAT tests on the correct bit
  x86: vmx_tests: extend HOST_EFER tests
  x86: vmx_tests: prepare for extending guest state area tests
  x86: vmx_tests: add GUEST_EFER tests

 x86/vmx_tests.c | 219 +++++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 145 insertions(+), 74 deletions(-)

-- 
1.8.3.1

