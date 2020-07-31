Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 800022348E8
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 18:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729065AbgGaQHr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 12:07:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728693AbgGaQHr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jul 2020 12:07:47 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B0C7C061574
        for <kvm@vger.kernel.org>; Fri, 31 Jul 2020 09:07:47 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id p3so16264033pgh.3
        for <kvm@vger.kernel.org>; Fri, 31 Jul 2020 09:07:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=L+xkkmjeHtXY7VybqaCXk08Av01hghtnH4g+Kdq8CP8=;
        b=faiHlcLAwFWwcOvGrc9zFvf2zIjZE2REGpysJyE+Nkv77Q46g41Rkr3IJFr4C57t/j
         AlfkuLcvQnmUpRenhiYJPceX5LYOf2uw0b9LlwKd0RXPdrxtYd/0RA8tHJr8yA4ttV49
         th0JzSi0h9LjeTUD1BGDueTrv1fZ/KwDYtTIlkDW459YYwaLitVIzn0K3Ti1pi9ZEZdB
         orlJ+RYFeNz62SX+VSncGqAxoEOkJoPNfbuySTJX4UP+GXyV6j0p6no21bhfD7pAc1nZ
         5PauPb93QqFKj52NSVL8n3PstbLeLzcwa2PShtV9Ff/Pkl74uD9wTNO71fSywRkWM34s
         Q4WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=L+xkkmjeHtXY7VybqaCXk08Av01hghtnH4g+Kdq8CP8=;
        b=iU0dxt+4/TXvG6p+uRPLfC0ENUNGXIjSQzKNNoMM0dnrI/LH3Nf/n9bSVgaoxMTFLR
         cIxEk9g86SPucU+63YevucE5RRZHPOimutTfhe3c/QFxV/d1FnC1OESi8Y2QQWnl2yCL
         vfPiPEywV6B7YbtOdN6mWTwjtqnYnlJjeWrqm5TyvJzUWxrVZdZ6bIYNXIwJfUx1M3+u
         b9FaEK6GVCKvStRXxDlzjJB1pjka8LADJjCqRtY1Kfy/yEPTulyHdeK57HKjOkYzLyWa
         3W+PXtlK9XmNOyIFPZCuG6I7VG28lxKZONAjHBv9RVS1EJ0ITkM4uW76YBGqpL3gcbSl
         j+SQ==
X-Gm-Message-State: AOAM533/mcnULv6hk5vOr9c2/+WcucU9Zn6k8aVIDb5esGX85N4TTUoT
        jYjSnUMnh3U11QRvLfsSIkg=
X-Google-Smtp-Source: ABdhPJxu3PSwq4nKdgxhBTt1DvabUlj9SuGKKfDrdyGi8asEFqzDjbHLHPCwsvIzYEtUej/d3l1UfQ==
X-Received: by 2002:a63:5d54:: with SMTP id o20mr4283021pgm.253.1596211666507;
        Fri, 31 Jul 2020 09:07:46 -0700 (PDT)
Received: from ?IPv6:2601:647:4700:9b2:25da:dbcf:1e8c:d224? ([2601:647:4700:9b2:25da:dbcf:1e8c:d224])
        by smtp.gmail.com with ESMTPSA id k26sm10705477pgt.90.2020.07.31.09.07.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 Jul 2020 09:07:45 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: New repo for kvm-unit-tests
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <7040f939-3f15-e56c-61dd-201ec46b6515@redhat.com>
Date:   Fri, 31 Jul 2020 09:07:44 -0700
Cc:     KVM list <kvm@vger.kernel.org>, Thomas Huth <thuth@redhat.com>
Content-Transfer-Encoding: 7bit
Message-Id: <A0556EC0-1975-4DBD-9A9B-3A9B8FE24FC7@gmail.com>
References: <7040f939-3f15-e56c-61dd-201ec46b6515@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On Jul 30, 2020, at 3:05 PM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> 
> kvm-unit-tests now lives at its now home,
> https://gitlab.com/kvm-unit-tests/kvm-unit-tests.  The kernel.org
> repository has been retired.
> 
> Nothing else changes, we're still living in the 20th century for patch
> submission and issue tracking.
> 
> Thanks Thomas for your work and your persistence!  I must admit it
> really just works.

Can you update http://www.linux-kvm.org/page/KVM-unit-tests so when
someone googles KVM-unit-tests he will get the right repository?

