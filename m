Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E02702116D6
	for <lists+kvm@lfdr.de>; Thu,  2 Jul 2020 01:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbgGAXxV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jul 2020 19:53:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726705AbgGAXxU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jul 2020 19:53:20 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A3EBC08C5C1;
        Wed,  1 Jul 2020 16:53:20 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id t6so12540301pgq.1;
        Wed, 01 Jul 2020 16:53:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:content-transfer-encoding:mime-version:subject:message-id:date
         :cc:to;
        bh=qz59MSmfS2mAKgrUKsnCwDqosbn7gTCiCcMCCTFlaCw=;
        b=WsLBVTPpoZoexUm3Bc5NxV67yHDB3eM2oLnpWDCQedXXggap8/fsbxcMf8CarP3dmT
         49ZbB/8n+ricwgRRw0TcFb0wiD5gCeM+hwi1S/OTrTO4hj707AQk3PnpqfJVEDIcsiA+
         C1Q+h/PlmrqKJMhhZLIW590sYyTg7t9ZrVIhNHm2PkaAOdJRBHiqyAvuAgchjXcQ+K/1
         MaEIhnobxaKWLEyf+UInVOTT0wsyx9d636pb6zLgwm9WIavg3mecGoykGN8MRfB0Rbnp
         4lNvdzc2UbcbGqA3YJ2B8tsKsfyvcs36Q3FlgC2MF2zZAbopAq4/lFnJ6bqL3GbDZpHz
         vVNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:content-transfer-encoding:mime-version
         :subject:message-id:date:cc:to;
        bh=qz59MSmfS2mAKgrUKsnCwDqosbn7gTCiCcMCCTFlaCw=;
        b=nXq9vJqauQ3xNqtAx+8kpad/mvvdn32ixKHslcgGOJMIUZneCsKzxiVo+07qVSTpUm
         ZE8CJ7ldFOrGmph2/qWDfiJntTwsu8FypB2TpbhaeK9mVG7/tQIgV1H5b1hHBQ0Y/BLZ
         2VRvgQ54U3G8leEVMdzu71ZtHKmR7GLkrACg8lDaAVM2kXmeMkp7qqxJ5xjbHrKhYirf
         NF4J4oYjnPQtPfFNHR92ztI08TuvyzMNHFyS53wmVC4n/hwXqdmQeInU5+PjQqWVeKf8
         N4Y/ycP8ScWpNrLaNdiAi1bIF4kg1hM5PJydNmKEDaLOKOsLClW8Bb8L20VRFd9kgjZp
         tWXg==
X-Gm-Message-State: AOAM531CQJ3bD3d6+iDiXQQowE8LMf9UrG0T0BRQjsT0Fe850rNlAW7I
        5yYa8j2c2Ekkz3lkYFZdwYI=
X-Google-Smtp-Source: ABdhPJwQX3APAq4pjkF/Sl8UADwfnwabKrXmZXRDq9j4+2n6Pcv2Kzqrv+UoPeWcsNjibXA2HcAlMQ==
X-Received: by 2002:a62:7653:: with SMTP id r80mr3820373pfc.236.1593647600003;
        Wed, 01 Jul 2020 16:53:20 -0700 (PDT)
Received: from [127.0.0.1] ([103.86.69.165])
        by smtp.gmail.com with ESMTPSA id n62sm6575448pjb.42.2020.07.01.16.53.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 Jul 2020 16:53:19 -0700 (PDT)
From:   hackapple <2538082724huangjinhai@gmail.com>
X-Google-Original-From: hackapple <2538082724@qq.com>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [RFC v2 15/26] mm/asi: Initialize the ASI page-table with core
 mappings
Message-Id: <A0849063-49C8-450F-B5C3-3740D8A180CF@qq.com>
Date:   Thu, 2 Jul 2020 07:53:12 +0800
Cc:     bp@alien8.de, dave.hansen@linux.intel.com, graf@amazon.de,
        hpa@zytor.com, jan.setjeeilers@oracle.com, jwadams@google.com,
        konrad.wilk@oracle.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        liran.alon@oracle.com, luto@kernel.org, mingo@redhat.com,
        pbonzini@redhat.com, peterz@infradead.org, rkrcmar@redhat.com,
        rppt@linux.vnet.ibm.com, tglx@linutronix.de, x86@kernel.org
To:     alexandre.chartre@oracle.com
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Will it affect TLB? I mean maybe cause TLB miss.
