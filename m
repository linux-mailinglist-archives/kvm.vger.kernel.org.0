Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A693BCEFBE
	for <lists+kvm@lfdr.de>; Tue,  8 Oct 2019 01:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729686AbfJGXr4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Oct 2019 19:47:56 -0400
Received: from mail-pf1-f173.google.com ([209.85.210.173]:39461 "EHLO
        mail-pf1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729252AbfJGXr4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Oct 2019 19:47:56 -0400
Received: by mail-pf1-f173.google.com with SMTP id v4so9655252pff.6
        for <kvm@vger.kernel.org>; Mon, 07 Oct 2019 16:47:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:content-transfer-encoding:mime-version:subject:message-id:date
         :cc:to;
        bh=vfoi7MlDmjlcqqrxsy4HndOBt5dMRfcN/MdfWrfwr58=;
        b=khFhLNoGYe6uTQ9t7kNFvYwy8qg+RlQ5C6cSv/cl5Ln9skIj3wzV+YLZJdB/rjVDSd
         iw1ox5jZt3iHrenbXLHokGzDWeJ+U4QcUhVJlQn4akwquLbTUxbp0vPW7wrBIElnrumy
         z/IgjXvAxvufc/i86NWEizTX/fq59CzcmbiPtkRQ1SDy6vTMGRUX9cFaHtkrDoc/UcWj
         NuK6n62Od+hWByu9wESRebT98+Dtuc5C9CWv/AKpLwba8yVQ7x2NRJgiz7HALCHynV+1
         KAg5lEHy8Y9nRdtJntvIpPuIyijo5wOMmzh/AT5KM1pJgST4w2+1Sxaw5pKT1H0Ja3el
         bqgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:content-transfer-encoding:mime-version
         :subject:message-id:date:cc:to;
        bh=vfoi7MlDmjlcqqrxsy4HndOBt5dMRfcN/MdfWrfwr58=;
        b=MrmU6GD4hfKeqQaFtb1ZvYFi3A4i1DwVDcL1750puatntW80FZ9HZlOHEMPlJF0iET
         xJyUGM2OVtBtt27sM9AqZIQUR0WJBKALU4X/7MjiIkYO35bqcFys0g/C2limbA3oaGnW
         ElrZGZm3xymA/zXQoR7Ikj17TzFE04tuYmnNP+NhRIVVWdbByRYHsvYN/00MgOQJsq9e
         /WeBBynVZR2zXuo9VRLmH7rbHJYGDzuGGCMJfiDwGkYfJJ6SFH13orsMGtHS8lKJ7JXm
         IO2JORC0rpFZrk6eV4poobMx0vj5tDgjwY3U0ySaJz/el0NbXwh5ogJUTlS8mZZtkwDs
         AKCw==
X-Gm-Message-State: APjAAAWU7uvSNYZVl3pESVELceb/7DeRU+G5ZHvsAxnxg3YyHYU+o+Wu
        RxOLUKZ9wFNqhfFJMSZly7w=
X-Google-Smtp-Source: APXvYqwYxo5+IaExxktfDVuGpu3GIJPDYKTVxCKiFtkMaI36pYrVziNQuI08p2oSTisDXsl/KqF1wQ==
X-Received: by 2002:a62:d445:: with SMTP id u5mr36148194pfl.92.1570492074749;
        Mon, 07 Oct 2019 16:47:54 -0700 (PDT)
Received: from [10.2.144.69] ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id b123sm20976212pgc.72.2019.10.07.16.47.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Oct 2019 16:47:54 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: KVM-unit-tests on AMD
Message-Id: <E15A5945-440C-4E59-A82A-B22B61769884@gmail.com>
Date:   Mon, 7 Oct 2019 16:47:50 -0700
Cc:     kvm list <kvm@vger.kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Is kvm-unit-test supposed to pass on AMD machines or AMD VMs?.

Clearly, I ask since they do not pass on AMD on bare-metal.

