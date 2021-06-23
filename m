Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41C603B11B5
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 04:28:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbhFWCaq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 22:30:46 -0400
Received: from mail-pj1-f50.google.com ([209.85.216.50]:54169 "EHLO
        mail-pj1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbhFWCap (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 22:30:45 -0400
Received: by mail-pj1-f50.google.com with SMTP id bb20so609663pjb.3;
        Tue, 22 Jun 2021 19:28:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YO2FYV/CBlADWRAFPbHqWyT315N9xxOaN3etDaDk5fk=;
        b=AAACa64K6qM1/noPZvou5AJMylLVvb7mlByBJMi38Nk4KPbls0r2YXjRBn5lARI3Ld
         xiTQdSC5OvSGCthWXE8j1kEspeQmDOWg7YJHlK+Kxvv+iuz6z46jZ9+f3n1IRzE1peNe
         7WUOrjsMPw8AxHI0GRk3l9aRJhWwzp1YzbnlY3OBgjRA1reO+gPlImQCYwBqX0aBe7Wj
         HW6BIgbx7dCQOQuayIm5fPbsLEgGoLto9/TCh13zeDypx/568gRuG9yp9AOQqQRuGGlM
         yeAd985VeTFC6yn6/rtJZbxZE5rX0jKshJkDyVgsiwzoy9541RhiyiqlsjYUcLdVFIeM
         hGKA==
X-Gm-Message-State: AOAM530t+JMkAMY2l9qN0x8W4blNy92YNPrv5vKy7qg3GbQi2eDnlv73
        CMsBU8k6X9YqN0pH6MhC2Wg=
X-Google-Smtp-Source: ABdhPJwtsx7qq8gNCBfiHB/NmPKuvFA27KsN/27uwrUxTC3Kc2zfT077LNSPHxwwLrzoDT42Q1u9Vw==
X-Received: by 2002:a17:902:d2c1:b029:122:ef41:c4cc with SMTP id n1-20020a170902d2c1b0290122ef41c4ccmr18194946plc.83.1624415308677;
        Tue, 22 Jun 2021 19:28:28 -0700 (PDT)
Received: from localhost ([173.239.198.97])
        by smtp.gmail.com with ESMTPSA id v6sm562083pfi.46.2021.06.22.19.28.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jun 2021 19:28:27 -0700 (PDT)
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     bhelgaas@google.com, alex.williamson@redhat.com, cohuck@redhat.com,
        jgg@ziepe.ca, kevin.tian@intel.com, eric.auger@redhat.com,
        giovanni.cabiddu@intel.com, mjrosato@linux.ibm.com,
        jannh@google.com, kvm@vger.kernel.org, linux-pci@vger.kernel.org,
        schnelle@linux.ibm.com
Cc:     minchan@kernel.org, gregkh@linuxfoundation.org, rafael@kernel.org,
        jeyu@kernel.org, ngupta@vflare.org,
        sergey.senozhatsky.work@gmail.com, mcgrof@kernel.org,
        axboe@kernel.dk, mbenes@suse.com, jpoimboe@redhat.com,
        tglx@linutronix.de, keescook@chromium.org, jikos@kernel.org,
        rostedt@goodmis.org, peterz@infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] vfio: export and make use of pci_dev_trylock()
Date:   Tue, 22 Jun 2021 19:28:22 -0700
Message-Id: <20210623022824.308041-1-mcgrof@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This v2 series addreses the changes requested by Bjorn, namely:

  - moved the new forward declarations next to pci_cfg_access_lock()
    as requested
  - modify the subject patch for the first PCI patch

Luis Chamberlain (2):
  PCI: Export pci_dev_trylock() and pci_dev_unlock()
  vfio: use the new pci_dev_trylock() helper to simplify try lock

 drivers/pci/pci.c           |  6 ++++--
 drivers/vfio/pci/vfio_pci.c | 11 ++++-------
 include/linux/pci.h         |  3 +++
 3 files changed, 11 insertions(+), 9 deletions(-)

-- 
2.30.2

