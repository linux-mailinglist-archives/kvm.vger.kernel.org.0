Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98092F2400
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2019 02:08:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728218AbfKGBI5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Nov 2019 20:08:57 -0500
Received: from mail-pg1-f202.google.com ([209.85.215.202]:38402 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727308AbfKGBI5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Nov 2019 20:08:57 -0500
Received: by mail-pg1-f202.google.com with SMTP id b24so433810pgi.5
        for <kvm@vger.kernel.org>; Wed, 06 Nov 2019 17:08:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=KHrUwtrqwpkVOQz+PpboVYfO9iAvo1mgLyQ5TxBkfZY=;
        b=rDxFdZSpD+T5li3HmBi2HJvPwl35hw0uJwTFF707Qc92BX5Ky/SRdgirkgXDkkpZZn
         cJChkb4aYhl2edAEvw7JIduyZazNNMZFTIV+AJrpsrieKi4KGxD5Lf9dyBklbBJEpEkM
         cPmb+hsXlCnRQELtnSFNZm/OS/ruHeK77qQOO0iDSMfx26eexj19thTT26eED+p7IlSb
         9suN80rREjKfFSTNLCkaVTK1gG2SW9bnLTF0aqHGICqcMVZXIwYBQfP2VXQTN8+EHZFr
         GcZPjQ+Gj+e2P+0EuodLL/vpSmdom+tOmZEmcrRDFExlOVVNrX9QC10GI8TMQvfYeS3T
         4gHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=KHrUwtrqwpkVOQz+PpboVYfO9iAvo1mgLyQ5TxBkfZY=;
        b=sIABMQ/6K8dfZyZIY8FALwYM9DB50LrmEVFJKBM48O+EmC0lvdXWdYsWmXiNCOIy7g
         eQG+7z8/pzUmQCudEWRAHUAGdp9sRgRQX8PWt0v8e4Tv9eW/C9Br5tjKvbLyUV4jU4XW
         JEjT9iBd9CQsV/NG7VwJm28XOjm22HVxWrTs0ArSne0zscRGimexIBsV/f38MtgdfMHG
         G5cd9+EsIRgxG/VclePfrjhN7Le1H3DBB4ISypj396X7TJk/WMdYnf9f4qnrpdUtNuek
         XJb50+iBUL4I0tYEukZNJOfgonoddtK8mhFgt31m2Si2fdT0rnTd/9NdddDLuhnhkrwl
         8/+g==
X-Gm-Message-State: APjAAAVAfvlA+a7CP/p4HaYLs9pDoCze1EJkWZulEFDDyB0nkpF7l7xa
        6KrlsBtH1uIWHAeEv4JPufEEg1RUeY7pc2PqSts9v/1j/3deprEX0TtzAD5igpv85eqPerPPH1o
        R8unyR5nOiIbs/3cSCLtt9NskCM2MZGIpQEUR5hxaUVIiDu09o7DJgw==
X-Google-Smtp-Source: APXvYqzZIdtG9ngqDg/sk4UWl4qPAuNbOzWfeUCZ+X+9TRy/TQf7rz+SFPH58KkiecHCA9H5IHcYTykOvQ==
X-Received: by 2002:a63:fc09:: with SMTP id j9mr1032825pgi.272.1573088936358;
 Wed, 06 Nov 2019 17:08:56 -0800 (PST)
Date:   Wed,  6 Nov 2019 17:08:42 -0800
Message-Id: <20191107010844.101059-1-morbo@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
Subject: [kvm-unit-tests PATCH 0/2] Use "-Werror" for checking flags
From:   Bill Wendling <morbo@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     jmattson@google.com, Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If "-Werror" isn't used then Clang doesn't fail if an unrecognized flag
is used. This causes "cc-option" to pass when it shouldn't. Also add
"cxx-option" for flags that aren't supported by the C++ compiler.

Bill Wendling (2):
  Makefile: use "-Werror" in cc-option
  Makefile: add "cxx-option" for C++ builds

 Makefile | 30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

-- 
2.24.0.rc1.363.gb1bccd3e3d-goog

