Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59841D6C42
	for <lists+kvm@lfdr.de>; Tue, 15 Oct 2019 01:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbfJNX4U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Oct 2019 19:56:20 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:41204 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726685AbfJNX4T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Oct 2019 19:56:19 -0400
Received: by mail-pf1-f193.google.com with SMTP id q7so11240762pfh.8
        for <kvm@vger.kernel.org>; Mon, 14 Oct 2019 16:56:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=c/JWqZ8gb1Z/M+9kBUdK1ws6OITcJ4HUS09bjLnYQMs=;
        b=sNTV5VTmjev5vKxTw6AwDct2khEXjwwS7QfQbd0FS4/xlAxhcBgUW9qLaOT4nHIgyJ
         VtTAewlvxQ6BbjZat70iuYDQIqH0j0KYA5jHsRH2AmMAyDIxAQCYs0nePDGJkI6g/SBh
         JSL3KK7XbRwU3IN3xiQ1bLtO1AmFO9wTUCqq/evewHoEzKJ73GBFhqZxyQnJphtoKQab
         1oXQ4frAbkUfCxQT7ZOXikWPSQKb+HA4LVYZzYRoUJNmSJ7kSpx/x/jLck7EszzxRzsE
         vzCtK9HxxeA7X5akNUYYBj1bp3OgdqeO2/EnVDvmtzOpzvqndnLdi2DLt3Y502h9HBKg
         bzoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=c/JWqZ8gb1Z/M+9kBUdK1ws6OITcJ4HUS09bjLnYQMs=;
        b=iFj721PBXF1AsgT7BHuQlLJLs7eUdK93rG6DJMk0NYVq+3hPnZoeLVem25yQKJi0Jj
         aTMqetRy6N5dEnVvr5xdTUohboxswaqdjlxgeD9aJv/XVgDsAWSADlGno1X/NkVN0Jhf
         6gPR0eoqf/jCdyysbRxkqpQySCwPb0Npigc9JSUEG6HhBnxJ2OpEL4rb/pvjDvA4mD6h
         WX+//Ux4894kKJHoj95AcEmcAWiuBnpieBZ1XevPjYJX3XaBBofe/kUi4kKSBLtMKmLq
         YcYKDnqvu0O14BFXAwdPEyE36dkiGhH/svCNsYsGyRaAN7GuYIUIItXy8l6f4/dQFbAb
         73rw==
X-Gm-Message-State: APjAAAWhPUbI0CS+isV9JQ84beFgAipGbL748erY6CVCx3CS5kuVdLlc
        YwR6k5QB+qv1DYcwiaGZCic=
X-Google-Smtp-Source: APXvYqxcTn2ShLsjJFhEuIILNMRDYHxnTT2k0n6dVBemW2bdIrwdwFFqok1mGXVHC7Px7PNHALfr2w==
X-Received: by 2002:a17:90a:be15:: with SMTP id a21mr39113921pjs.52.1571097377361;
        Mon, 14 Oct 2019 16:56:17 -0700 (PDT)
Received: from [10.2.144.69] ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id t12sm15583819pjq.18.2019.10.14.16.56.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Oct 2019 16:56:16 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3594.4.19\))
Subject: Re: [kvm-unit-tests PATCH 0/4] Patches for clang compilation
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <CAGG=3QVuCrD83TcfeaqJFCTgvx36V4gc-VuCoaMDOgB4EhH0EA@mail.gmail.com>
Date:   Mon, 14 Oct 2019 16:56:14 -0700
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Transfer-Encoding: 7bit
Message-Id: <C82F208E-BE8C-4106-A9F2-37FCDE2E90E7@gmail.com>
References: <20191010183506.129921-1-morbo@google.com>
 <20191014192431.137719-1-morbo@google.com>
 <CAGG=3QVuCrD83TcfeaqJFCTgvx36V4gc-VuCoaMDOgB4EhH0EA@mail.gmail.com>
To:     Bill Wendling <morbo@google.com>
X-Mailer: Apple Mail (2.3594.4.19)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Oct 14, 2019, at 12:25 PM, Bill Wendling <morbo@google.com> wrote:
> 
> Crap! I used what I thought were the correct command line arguments
> for "git send-email", but it didn't add the "v2" bit. My apologies.
> All of these patches should be v2 for the originals.

I recommend that you send them again with v2 in the title to avoid
confusion.
