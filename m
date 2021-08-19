Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE113F100D
	for <lists+kvm@lfdr.de>; Thu, 19 Aug 2021 03:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235325AbhHSBmv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 21:42:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234194AbhHSBmu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Aug 2021 21:42:50 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F26A9C061764
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 18:42:14 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id e7so4313460pgk.2
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 18:42:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=vE2NquF8aYczXeoe6PGRGJC5TmHhDUeKxtlQ0G2jkj0=;
        b=TzkGaYSavbzKcla9b22EsIZ0UYcGwBCBQIe7qkkxrWrB9VDShq4qDo/WgRh2Ompz2v
         V1wAoaQfblkOpY5Tw0JpwU4pcsI9xRF8BvwvDxeEjv8WmlHw8IiYhCaCURe6N/IZVhsY
         Ad7YMItNSYzdTQwTXOIeo8ZOpP4MY0RDR1YQRUVIubHozViqgo8PifeL4s2Dmh42dwN4
         Y1REyb8/lkPkdqPUSo2o9YrtXfhGI4pM9rfANGyFthSOEC8GgJwwj4u6vEKSWNL8PPqV
         E0Bg7NHdpxsxFaxEjUPfmaposl06OVyYGBHh8PBmm9+TFXmyqlLBYVvAXJn5LbTcbTGy
         qv+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=vE2NquF8aYczXeoe6PGRGJC5TmHhDUeKxtlQ0G2jkj0=;
        b=nvaLmxNyTFrocvalUxZyjBNB8fr7kWrPfcChmgJ2zDlPnmz9ZjslxLat76pGrhrwZH
         I0Rupq1/j34KOBMEKxUrXE5VtHQb+Pt0Q9hZNvA4ofMggBUerT5E5BIUBviX53CbTvkh
         S3uCCdJ6wo6N3wdawrEpzxW119s42Ew9z2YvwoySgViDOM7LeOBtiisQVAqYhnbTzRFf
         BK/BKtm6ZrRxO1tk0KCvue+4/xvIf0XAuwiEyDidtFCgftK2erWfDND1B17+VD0OWu22
         lT4vAB0lVlQXazNZSHj4aVYWrOx0oV2bIhrJEHw6I9nkcO8gfThq6U0Jg6thhbUFUBo7
         gWWQ==
X-Gm-Message-State: AOAM531qHznNHEF0Nk8IBO5nkvTPRfaReSCuiEIE0QTlyHQc8Shm8bef
        TYu74sReYDlAqg5PyFkijw8=
X-Google-Smtp-Source: ABdhPJwc/9Y6Qg1flKQWhWZ4XJflaQczD3jDWqCEJHeKG8vExwOCWSrEETTQioJ+3wL3HUrYCxLX0A==
X-Received: by 2002:a63:1155:: with SMTP id 21mr11652333pgr.346.1629337334181;
        Wed, 18 Aug 2021 18:42:14 -0700 (PDT)
Received: from smtpclient.apple (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id t18sm1046591pfg.111.2021.08.18.18.42.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Aug 2021 18:42:13 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: [kvm-unit-tests PATCH 0/6] Initial x86_64 UEFI support
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <CAA03e5H6mM0z5r4knbjHDLS4svLP6WQuhC_5BnSgCyXpRZgqAQ@mail.gmail.com>
Date:   Wed, 18 Aug 2021 18:42:11 -0700
Cc:     Varad Gautam <varad.gautam@suse.com>,
        Joerg Roedel <jroedel@suse.de>, kvm list <kvm@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>, bp@suse.de,
        "Lendacky, Thomas" <thomas.lendacky@amd.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        Zixuan Wang <zixuanwang@google.com>,
        "Hyunwook (Wooky) Baek" <baekhw@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Tom Roeder <tmroeder@google.com>
Content-Transfer-Encoding: 7bit
Message-Id: <0250F07B-AC9A-4110-B2F4-8537A40D8848@gmail.com>
References: <20210702114820.16712-1-varad.gautam@suse.com>
 <CAA03e5HCdx2sLRqs2jkLDz3z8SB9JhCdxGv7Y6_ER-kMaqHXUg@mail.gmail.com>
 <YRuURERGp8CQ1jAX@suse.de>
 <CAA03e5FTrkLpZ3yr3nBphOW3D+8HF-Wmo4um4MTXum3BR6BMQw@mail.gmail.com>
 <71db10eb-997f-aac1-5d41-3bcbc34c114d@suse.com>
 <CAA03e5H6mM0z5r4knbjHDLS4svLP6WQuhC_5BnSgCyXpRZgqAQ@mail.gmail.com>
To:     Marc Orr <marcorr@google.com>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> On Aug 18, 2021, at 6:32 PM, Marc Orr <marcorr@google.com> wrote:
> 
> This sounds great to us. We will also experiment with combining the
> two patchsets and report back when we have some experience with this.
> Though, please do also report back if you have an update on this
> before we do.

Just wondering (aka, my standard question): does it work on
bare-metal (putting aside tests that rely on test-devices)?

