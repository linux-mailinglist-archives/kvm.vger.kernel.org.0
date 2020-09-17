Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93D4F26E04A
	for <lists+kvm@lfdr.de>; Thu, 17 Sep 2020 18:08:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728132AbgIQQIj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Sep 2020 12:08:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728094AbgIQQCU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Sep 2020 12:02:20 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30ED8C06121D
        for <kvm@vger.kernel.org>; Thu, 17 Sep 2020 09:02:16 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id f1so1342583plo.13
        for <kvm@vger.kernel.org>; Thu, 17 Sep 2020 09:02:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=nHVFqRghFBFymH0OR9d+PHUQPv0jCtcWv1PluEHLWxc=;
        b=NR5bwBWGPIojYmeRQgg4Yz1rmNOTWcsc/Mpfyj7DeARMkO4jn4LV9xEmjwkWrSMOGp
         s6mhGS7KgOU4Me5krI+H6hTH9zlUgvSVUeox5yhjK+4M15RyRcFIaRh7Z7H41SMX0QHb
         rZzFzacJQR37kCZobjG1xeNjiw9zylvK81e7hee5iRWcxEnpavHA9tMbxV2nelfr41PH
         uSndwkfh/W//q8Lx20OML61eNgZx0w0vt7P7wrlqY3awZ5O0xpk96tkJrn/CEGATVYQs
         URjzzWaYxMJQoBf1MWO+HnqBXqU9V/YtnBylBclm+EogTfOdVoaQJ47Jo6dbaZnXsgDg
         34Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=nHVFqRghFBFymH0OR9d+PHUQPv0jCtcWv1PluEHLWxc=;
        b=WGJhD5vtc2A4mfN0shEnK13pW6EkyxTsBmWqfSPCgWrHL4ISra1bvJ6bgT7LBcuqp7
         lKNbAX7Vs0iJNoWeSDvHT4whLPy5y02T1wkUVaqP4rHOmpCEgMkX0fF+OmWMcWC+3gn0
         rOIM8RxsulSntp7Bp4Ecqe5YzqVvlMJVbVfdMQ92R9rhyyC6pLuUQhoV4DO556dm1wZb
         JD4YBmzLkM62W2uusP2PkghYjDLqn0hY9BCSKgTEDswiONgmpOE9nmKOYvAXdvdqbu8p
         qJh9d7xZBlEhuaR8NYDW6Aao0Mm4LT5KTR/vvyNo592zk6fgYXaNd2A770iExNpLDgkJ
         4nPg==
X-Gm-Message-State: AOAM530PcVVyrdVwjdkQ2U+kumukA2gk7CWZwDa0xbUVK8HEC7jvRJkI
        5ez+8d/ioy9esuWlR0RU/mCnvqN78sceGtrlVvk=
X-Google-Smtp-Source: ABdhPJxcEphk5LdLqHsNd3UKt06bhzQujLcVLj7FNusrz5WqBOlg909vRYGpnkzsbOFilo9XiWA5ejDo5aDQmYwPOR4=
X-Received: by 2002:a17:902:be11:b029:d1:bb21:4c9c with SMTP id
 r17-20020a170902be11b02900d1bb214c9cmr25779289pls.8.1600358535629; Thu, 17
 Sep 2020 09:02:15 -0700 (PDT)
MIME-Version: 1.0
From:   Stefan Hajnoczi <stefanha@gmail.com>
Date:   Thu, 17 Sep 2020 17:02:04 +0100
Message-ID: <CAJSP0QUiNJZXtdiYZFVu_OLkPfWbX=F3JVkLSrqOHsJUL+MSTg@mail.gmail.com>
Subject: Reminder: Outreachy open source internships initial application
 deadline Sept 20
To:     qemu-devel <qemu-devel@nongnu.org>, kvm <kvm@vger.kernel.org>
Cc:     Julia Suvorova <jusual@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,
QEMU is participating in the Outreachy December-March open source
internship program. The internships are 12 weeks of full-time paid
remote work contributing to QEMU/KVM. For more information about
eligibility and what the internships are like, please see
https://outreachy.org/.

The initial application deadline is Sept 20 and it only takes 5-30
minutes to complete:
https://www.outreachy.org/apply/

If you or someone you know are considering doing an internship with
QEMU, Linux kernel, or another participating organization, please
remember to submit an initial application by September 20th!

Stefan
