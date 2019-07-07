Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 536D56130A
	for <lists+kvm@lfdr.de>; Sat,  6 Jul 2019 23:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbfGFVik (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 6 Jul 2019 17:38:40 -0400
Received: from mail-lf1-f52.google.com ([209.85.167.52]:45676 "EHLO
        mail-lf1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726714AbfGFVik (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 6 Jul 2019 17:38:40 -0400
Received: by mail-lf1-f52.google.com with SMTP id u10so8382381lfm.12
        for <kvm@vger.kernel.org>; Sat, 06 Jul 2019 14:38:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=eng.ucsd.edu; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=klb+7J069cJ1+W8hoxNmMJE/f3+e7sMU5jQjfpO6ZKA=;
        b=gcNScJKAmpy1kf8vVcMzN+g1N9MS6ViUZVLp5nOG/S28mbRuaiwE0Uf6o3frgKibOB
         v8swGHCOOVm5EdfB6Upb1A21DDOHapT3yw2xMYFr1tpLDFuBO70BnCV47hV7jb+Tvry2
         8oqpD1UGNgUMKeAl+KHGVDlRN2er2rqQqR/5Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=klb+7J069cJ1+W8hoxNmMJE/f3+e7sMU5jQjfpO6ZKA=;
        b=M3SD2WnuyKsURWIpzZzDxLCQXZUkksX2XAZCoxuLpMI/uxtfY4srEPy5y7dC6az8Ug
         P6uahoHNlx08vFo3IZV0JS0C65gvXZvciOW3rXyLGeeA9ETxJnQSR7zZ0tZVuz/FDFHa
         rDTIa5BC6qoS4CbU12RFghniX6LmkDptlqkfmbR3A0zW8AaVVQnh98C/1g07TRMNog/v
         YbG+g1A5y/USIzqETvyW1MhzV0/IoDenHkoinoXSE/QTPXXtBkhrtz7jLDp+tBPlAJ65
         OS9zI3qsBiLYyqGZzgQzsqRn6uBRcAfY+f3XDL9g41KiBL8jVL1wAs2POUGmLG+ani3N
         aTKg==
X-Gm-Message-State: APjAAAUo6a9NfvQPjUjA3V7F7vw9JUpaxc60BhYxXXEcDaT2acKFTwRB
        URPAAA1D7W7CvhuICwcI5bUq0Q==
X-Google-Smtp-Source: APXvYqwRcsj1CJEmIMUMPbBTnuoCBgtBVHN4Fk94h3PaTJLuEU3Zn3Xy7JrHphpeqZ2n3ekNC1yvSw==
X-Received: by 2002:a19:ccc6:: with SMTP id c189mr4895103lfg.160.1562449117840;
        Sat, 06 Jul 2019 14:38:37 -0700 (PDT)
Received: from luke-XPS-13.home (77-255-206-190.adsl.inetia.pl. [77.255.206.190])
        by smtp.gmail.com with ESMTPSA id j3sm1322449lfp.34.2019.07.06.14.38.34
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 06 Jul 2019 14:38:36 -0700 (PDT)
From:   Luke Nowakowski-Krijger <lnowakow@eng.ucsd.edu>
X-Google-Original-From: Luke Nowakowski-Krijger <lnowakow@neg.ucsd.edu>
To:     linux-kernel-mentees@lists.linuxfoundation.org
Cc:     Luke Nowakowski-Krijger <lnowakow@eng.ucsd.edu>,
        pbonzini@redhat.com, rkrcmar@redhat.com, corbet@lwn.net,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] [PATCH 0/3] Documentation: virtual: convert files from .txt to
Date:   Sat,  6 Jul 2019 14:38:12 -0700
Message-Id: <cover.1562448500.git.lnowakow@eng.ucsd.edu>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Luke Nowakowski-Krijger <lnowakow@eng.ucsd.edu>

Converted a few documents in virtual and virtual/kvm to .rst format.
Also added toctree hooks wherever there were .rst files. Adding hooks to
the main doc tree should be in another patch series once there are more
files in the directory. 

After confirming with the appropriate lists that all the 
Documentation/virtual/* files are not obsolete I will continue
converting the rest of the .txt files to .rst. 

Luke Nowakowski-Krijger (3):
  Documentation: virtual: Add toctree hooks
  Documentation: kvm: Convert cpuid.txt to .rst
  Documentation: virtual: Convert paravirt_ops.txt to .rst

 Documentation/virtual/index.rst               | 18 ++++
 Documentation/virtual/kvm/cpuid.rst           | 99 +++++++++++++++++++
 Documentation/virtual/kvm/cpuid.txt           | 83 ----------------
 Documentation/virtual/kvm/index.rst           | 12 +++
 .../{paravirt_ops.txt => paravirt_ops.rst}    | 19 ++--
 5 files changed, 140 insertions(+), 91 deletions(-)
 create mode 100644 Documentation/virtual/index.rst
 create mode 100644 Documentation/virtual/kvm/cpuid.rst
 delete mode 100644 Documentation/virtual/kvm/cpuid.txt
 create mode 100644 Documentation/virtual/kvm/index.rst
 rename Documentation/virtual/{paravirt_ops.txt => paravirt_ops.rst} (65%)

-- 
2.20.1

