Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1361E7AA0F2
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 22:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231975AbjIUUyK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 16:54:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232576AbjIUUxz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 16:53:55 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6814902F
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 13:30:02 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-59c0eb18f09so19243337b3.2
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 13:30:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695328201; x=1695933001; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0e0ZFX778bRtqensng9uc874c9hN9XH6Wv7cNf/87eM=;
        b=Lmcr48QZU9B3SGXe0N7Q03b4eFlKEEdSOEPlzaCPNlMBGZRRSf6v2uEJs4IXu2WFZq
         +Zmore4QALQOyT074OJx4jdA1Cqy+m7DaTDzIqqn9+7TlKVaetoR9hx0PwK6LIPCnXcR
         eQSQMbsUJBp8kNhdC9tJ/2o0ea5nhg4Kd/yaqMAJWjAuOEE+vOn/kaq9Tg5mouyz/gYd
         Nq5CgUUNK57s3Bp8jpkHNq42gy8Fy4e7rY6EpnFUa7gXwkLNhmpFyaw5DeS+IR4ovdDz
         PQ0d+ejU+OzLAM9QQVkoepNq2pD90SOZifiFaLg0yz9GnRefV9TvcTHGZuL9o5WQKo33
         RAaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695328201; x=1695933001;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0e0ZFX778bRtqensng9uc874c9hN9XH6Wv7cNf/87eM=;
        b=bePTe4UK4lez0y82mCxdHnwW1eVCn4ir7nQHVjpbt2NsGwoVx1m2/3YBwusqf26bg1
         LkvTuZEv/L6bSE4TG07NiL9bipW2/ZLxlGm+g9Ojs6WBCVUEL6HuFutxin4pl95KF5Vc
         bMM371iPeKAQvz68iPVWgXH0wRWUeeQAR6OKEE2K3cqfKw286W4Pk3UMkFJNZA7V66/h
         g6NeWc8eV3ZGEMPXFYCr+cN9N+3MDJTZxV9EJ/wvuIHSllWMET0H+ukicqRcWwpGLKT6
         OuS0+62Rs3L20+r8D1+DrYgBX4RWkmsqo6JI97p+5TtAzRXN8JetheilKLuLNIOBW0PY
         tpkQ==
X-Gm-Message-State: AOJu0Yyy/SAu+ZjbX9yM56a1wXKhwAUN8wIAgH0IIUJPltlw89nlcfBT
        PaLa0asjwaoW8R06wM47vPxXh0Pj21M=
X-Google-Smtp-Source: AGHT+IEUzNA8IyQIMX03s7MMZaciANap7xKc1c5smy0hyixgyh595oKa8SQXXUtwQ8+rycDYPZuRHMWlcrs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:ad1f:0:b0:59b:db15:a088 with SMTP id
 l31-20020a81ad1f000000b0059bdb15a088mr93304ywh.3.1695328201599; Thu, 21 Sep
 2023 13:30:01 -0700 (PDT)
Date:   Thu, 21 Sep 2023 13:29:59 -0700
In-Reply-To: <cover.1695327124.git.isaku.yamahata@intel.com>
Mime-Version: 1.0
References: <cover.1695327124.git.isaku.yamahata@intel.com>
Message-ID: <ZQynx5DyP56/HAxV@google.com>
Subject: Re: [RFC PATCH v2 0/6] KVM: gmem: Implement test cases for error_remove_page
From:   Sean Christopherson <seanjc@google.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Michael Roth <michael.roth@amd.com>,
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

On Thu, Sep 21, 2023, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> This patch series is to implement test cases for the KVM gmem error_remove_page
> method.
> - Update punch hole method to truncate pages
> - Add a new ioctl KVM_GUEST_MEMORY_FAILURE to inject memory failure on
>   offset of gmem

Doh.  Please try to communicate what you're working on.  I was just about to hit
SEND on a series to fix the truncation bug, and to add a similar test.  I would
have happily punted that in your direction, but I had no idea that you were aware
of the bug[*], let alone working on a fix.  I could have explicitly stated that
I was going to fix the bug, but I thought that it was implied that I needed to
clean up my own mess.

Anyways, I'm going to hit SEND anyways, my changes are slightly different to your
patch 1 (truncate needs to happen between begin() and end()) and patch 3 (I added
a slightly more comprehensive test).

[*] https://lore.kernel.org/all/20230918163647.m6bjgwusc7ww5tyu@amd.com
