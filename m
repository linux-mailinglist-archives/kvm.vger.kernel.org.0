Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C54EA78156D
	for <lists+kvm@lfdr.de>; Sat, 19 Aug 2023 00:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241121AbjHRWeJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Aug 2023 18:34:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241108AbjHRWdu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Aug 2023 18:33:50 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E98044212
        for <kvm@vger.kernel.org>; Fri, 18 Aug 2023 15:33:48 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-583c49018c6so19234377b3.0
        for <kvm@vger.kernel.org>; Fri, 18 Aug 2023 15:33:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692398028; x=1693002828;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NhEwl8ITGQcTfYN5ElDC4AmBI4NmU0oAW6H6kQx3LJQ=;
        b=s+LHBPfCmaOjRDlN9GI/+ZGoEpD6ePDnRpVcb3uFtlONTsP9JqACJWMFtGw6mUO1f0
         E1snrfpmK5kNjirXqCZS+5CA/iZQk2ncSRDAJ9x/Z+tcJL+fXx5UPxqxZ2bbOm9xoJ1D
         FT1Zd7xUcJtbGnM9WRvNt2IAZe0OMtgFrVbuiC9i7zz1bzXIoEPAkmPwUkyLH3cOi1Mg
         3IfJgNHpXr1BQ8AuDPtwWBNE3Yz4r0bGkdIgL5KsFjNib1IaQ3khjAgtJMdtwxWJf1Bx
         2S1zAs5/7aFOndGw+ptCV1YR83A4EShCLHivgvxnJEef2PcsY4uGcGQs86G/cxY9aa16
         /tdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692398028; x=1693002828;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NhEwl8ITGQcTfYN5ElDC4AmBI4NmU0oAW6H6kQx3LJQ=;
        b=W2gYnXszGf5g7dDzrKPRT54fNUPi24qMhmSgum7da78W2ubzqGZJz/TDaKHzXuiCTb
         kHuoYcSrrjCIBZcVac6fzV3lWsfu8g0nWGNqkP1AN771NMf8I2yfW6FWcwR7E4BnSnPG
         4l+3DJBKeodIwBZZ3bsiv5u80uydVkSArRVhGoY/xMHCY4c2FZ8VEeEOzXlbeOM8Taz4
         dc+IID78JdzwnDG+Q2FXf2GaJdj6XFLBYkRIVilM87MdyjYcSFUXnbPvQQ1zdOhxFNfD
         6AzPV/Nse1RBbJuaOFIXzrLDCu5+GDgoCObucRig8g7PscwYSkWJVqWjDLQaTolJOa93
         k0Dw==
X-Gm-Message-State: AOJu0Ywn7SwWghWrtfE/osdVlHiFnN/rhXkn3+YKdlNXXNpMPVZHERM5
        VCec36f88E+oQwwURRfisJ9CaqcU8po=
X-Google-Smtp-Source: AGHT+IFH27W0J3FpLsSsyh6gpjSRTEpCWHOAm5ANIV7muCzGRClMm1/4A0wcNfxBy5CDeXjGqco/XUuVEJo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1786:b0:d74:5e2c:4c5a with SMTP id
 ca6-20020a056902178600b00d745e2c4c5amr5154ybb.5.1692398028159; Fri, 18 Aug
 2023 15:33:48 -0700 (PDT)
Date:   Fri, 18 Aug 2023 15:33:46 -0700
In-Reply-To: <ed4ab1239f0e048c25154884a1811214fb38587f.1692119201.git.isaku.yamahata@intel.com>
Mime-Version: 1.0
References: <cover.1692119201.git.isaku.yamahata@intel.com> <ed4ab1239f0e048c25154884a1811214fb38587f.1692119201.git.isaku.yamahata@intel.com>
Message-ID: <ZN/xyqsEUaGcpju/@google.com>
Subject: Re: [PATCH 3/8] KVM: gmem: Fix kvm_gmem_issue_arch_invalidate()
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 15, 2023, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> __filemap_get_folio() can return error.  Use IS_ERR_OR_NULL.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>

*sigh*

(a) This patch is ordered incorrectly, it belongs after patch 6.

(b) Don't post broken patches with fixup in the same damn series.

This is not hard, these are basic rules of the road.

Sorry for being grumpy, but I spent way too much time figuring out what on earth
was going on, for something that should have required exactly _zero_ effort on
my end.
