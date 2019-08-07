Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54FA88556F
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2019 23:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730182AbfHGVwd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Aug 2019 17:52:33 -0400
Received: from mail-wr1-f43.google.com ([209.85.221.43]:37154 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727751AbfHGVwc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Aug 2019 17:52:32 -0400
Received: by mail-wr1-f43.google.com with SMTP id b3so440379wro.4
        for <kvm@vger.kernel.org>; Wed, 07 Aug 2019 14:52:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=nlxctz8ULzfFuzyxGOiaEhGHbi7BgAA/spwvvutqsBE=;
        b=sLej5laomm0ETdSdpdGgTxv8YHaoys8H4DD81Nh+KonSuER40BEz5Inoc2ORkJu+04
         X9ml6JDjQY2mHsSiGrKPykmb4qYD3DoNQ2u1vlSOfusnvk29S01qmlmztpzVzbzmMeOZ
         qh8qQaDiBJlOT7VLG2NAiqKS2Oj89ao1ZHAP23IuWlceuKVcktpu0vcL+xFcwDYJgGxO
         W3UslxiAPm7LF/5vSm0XbI5cWRT1Bdsof9MYPWg51GejMmo8gwGoBPJ2nLtFHGre4Uxv
         ALL7fP3haygQbBPwNvKKJs8oFC3CIBYufCcQ0aJYkKBXRKSUIPuAaW+A/W8kcNQTNp4G
         CWqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=nlxctz8ULzfFuzyxGOiaEhGHbi7BgAA/spwvvutqsBE=;
        b=CaJgz3yhC6lGKpEwbHUZ0Ctcpq4MvXHhkZLEiAnXKzWEEWwUKZvZ5sSOVbn4YEpt4n
         fBOv9Q9iT5D/gv9LvxPlo8aLl0+fCpIwTLAJ3Ub7UcjD9Y1E+atALHJA1e/s39hGr9i/
         o0OawHmB9sXqlLqGkqQ5FSNLgAxdWnidJXV82TxakMBW1Z1QRmSutUhTt9N3faRRqBkH
         KzjnJPHOXF6MoPxjykdjGsbnYmRoXY2OcHvUaFl8H1/uPW61VEfP9BVftGbzLYfWFgP3
         bYLJxsGsW5GybVcVRPnq0PZFe0tEnFXowEZ08Q71w2Icp5C5L/3NbqQvvZfb0xyedII3
         20/Q==
X-Gm-Message-State: APjAAAWvWH3L+/jLBCMs22nV192S0ofWGK6CsHffG3LfiV0wzn8OtHjR
        vYGmxZa4o2bRCPQ1KAgNHMLXm8CRjji+wb/rG47KpA9z
X-Google-Smtp-Source: APXvYqwYpjrkbBWJj4pFLNY9tuAGnQPDoEUVqkqYkoZq4zJ0tl3h/mChlc2+YOuszmunNWoJcLctvthfGrBpuJL6Ns4=
X-Received: by 2002:a5d:680d:: with SMTP id w13mr13005694wru.141.1565214750857;
 Wed, 07 Aug 2019 14:52:30 -0700 (PDT)
MIME-Version: 1.0
From:   Jintack Lim <incredible.tack@gmail.com>
Date:   Wed, 7 Aug 2019 14:52:19 -0700
Message-ID: <CAHyh4xhDZdr0gOJCrSBB5rXYXw7Kpxsw_Oe=tSHMCgi_2G3ouQ@mail.gmail.com>
Subject: Why are we using preemption timer on x86?
To:     KVM General <kvm@vger.kernel.org>
Cc:     Jintack Lim <jintack@cs.columbia.edu>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

I'm just wondering what's the reason why we use the preemption timer
instead of emulating VM's timer using hrtimer in software? Is there
anything the the preemption timer can do that can't be done with
hrtimer?

I guess the x86 architecture provides the preemption timer for *some*
reason, but I'm not sure what they are.

Thanks,
Jintack
