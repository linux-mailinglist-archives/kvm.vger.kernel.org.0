Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C413C7ABA8B
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 22:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbjIVUc4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 16:32:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjIVUcz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 16:32:55 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A0E2CA
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 13:32:49 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-5784671b7ebso2382210a12.1
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 13:32:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695414769; x=1696019569; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CSRAsOXqUG0ER0BOAKiobqvlHfjAj6fkRHJ850CANRE=;
        b=J/d+/vpX73JDiS99x6J8yXz7eWnsuKr3ZRSkH0+dqbPsGiMgSErvjDyDcSnOPlbMbX
         c92kmf7d3vLm0akowOAMssskLjzBOu6WHwoGv7i+IoY06CYHmPC7JDiPfqkHYxszWR+S
         5ALElTT4Dv1JF8uPcP68fRvGglAwHATag0DQGrNRNPW4wSZrnKRnKpzrgqO0n1+1d1dY
         +X2wp9tSrebkCJ9H4JGlNWqL8B2+o37pasTalFdkwE6WnFCb9YFGn/Wax2+1025Cq9rt
         OQBZ8+S1T5Qw6kjzff8+UJwUqTg1JHPuKvgiWgHNXujhBHB1Wsbq+6htrBM4ToYywZWS
         /H5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695414769; x=1696019569;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CSRAsOXqUG0ER0BOAKiobqvlHfjAj6fkRHJ850CANRE=;
        b=B1atcgLL6sf13GiHLFZiqwv9w2tq5v0iXq0J1NzZTWA/RjK96l1jsls64r2kUFYW6l
         pwcfkXjA2YKcR7GPIMlCBoLlybR1vclZVm9DYoNxxmFRjko9zL9+xzObvvEWMvR2rL2l
         Z56jfrrlMmEjwOk4mUFQ7WQHFbtjzo3inyENdYRL1HxOS/LkejsLm06LOXei6f/jryJa
         T+NILDS+0JY3i0gJKjkvp/1vlnjBfPOCPaA0qOyGR9vXvBDZsr15BXiKqSYa2lueuZnA
         OQUTGSlWsRPM7NVZlCQMz7xJJ8gEOS1dYu7pDAs9dXIg17FF9Qr8HsiMqx0KcUaXPBT1
         8Fig==
X-Gm-Message-State: AOJu0YwaGW6N5stVOS+Apu8ArA/Oc5ZCMEopgv1eDB9D7fCx2elrlIxB
        zzCyjPavuhjFuLwmnPddLseqIS2lRbw=
X-Google-Smtp-Source: AGHT+IEiBw59NffQePuDv4nERVBcRa7yli0EECdvxQRHySgvasoDIFxcuZKKvgHTJ5qWHHbpwqq2PFwVIKQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:fa8d:b0:1b9:df8f:888c with SMTP id
 lc13-20020a170902fa8d00b001b9df8f888cmr4603plb.8.1695414768675; Fri, 22 Sep
 2023 13:32:48 -0700 (PDT)
Date:   Fri, 22 Sep 2023 13:32:47 -0700
In-Reply-To: <20230922194029.GA1206715@ls.amr.corp.intel.com>
Mime-Version: 1.0
References: <cover.1695327124.git.isaku.yamahata@intel.com>
 <ZQynx5DyP56/HAxV@google.com> <20230922194029.GA1206715@ls.amr.corp.intel.com>
Message-ID: <ZQ3573rbNQpbNf09@google.com>
Subject: Re: [RFC PATCH v2 0/6] KVM: gmem: Implement test cases for error_remove_page
From:   Sean Christopherson <seanjc@google.com>
To:     Isaku Yamahata <isaku.yamahata@linux.intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Michael Roth <michael.roth@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        linux-coco@lists.linux.dev,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Xu Yilun <yilun.xu@intel.com>,
        Quentin Perret <qperret@google.com>, wei.w.wang@intel.com,
        Fuad Tabba <tabba@google.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 22, 2023, Isaku Yamahata wrote:
> On Thu, Sep 21, 2023 at 01:29:59PM -0700,
> Sean Christopherson <seanjc@google.com> wrote:
> 
> > On Thu, Sep 21, 2023, isaku.yamahata@intel.com wrote:
> > > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > > 
> > > This patch series is to implement test cases for the KVM gmem error_remove_page
> > > method.
> > > - Update punch hole method to truncate pages
> > > - Add a new ioctl KVM_GUEST_MEMORY_FAILURE to inject memory failure on
> > >   offset of gmem
> > 
> > Doh.  Please try to communicate what you're working on.  I was just about to hit
> > SEND on a series to fix the truncation bug, and to add a similar test.  I would
> > have happily punted that in your direction, but I had no idea that you were aware
> > of the bug[*], let alone working on a fix.  I could have explicitly stated that
> > I was going to fix the bug, but I thought that it was implied that I needed to
> > clean up my own mess.
> 
> Oops sorry.  Now I'm considering about machine check injection.
> i.e. somehow trigger kvm_machine_check() and its own test cases.

Unless we can't extend fadvise() for some reason, I think we should pursue
FADV_HWPOISION.  The enabling should be downright trivial, e.g. just implement
file_operations.fadvise() for guest_memfd, have it handle FADV_HWPOISON, and pass
everything else to generic_fadvise().

It'll basically be your ioctl() just without a dedicated ioctl().

At the very least, we should run the idea past the fs maintainers.
