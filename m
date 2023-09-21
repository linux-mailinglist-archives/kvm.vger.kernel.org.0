Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5293D7AA467
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 00:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232944AbjIUWIU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 18:08:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232951AbjIUWIE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 18:08:04 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A62C643C85
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 14:34:48 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d81e72d4ec0so2975792276.0
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 14:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695332088; x=1695936888; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pR+2Sq/w5PO1VBsN7LGE/vsgLDdz85P5Qsv8lkXDhfw=;
        b=BYX5P5YenopC8WfoqBCQpAR+ubqYYZEbTvXtwVksdrNAEOU9vulHCoShstnOrYREm/
         iXGLA7EuOUNC8DseYVJ1fVflrkbVmknCw1tY0YmX9V4zpoB/b2JaO2i/qzOjf70y0lEn
         kStyYA/xHQ1i/MjqVMWalNc2ZG5kiIeMaT002yyIcAyQN+rcnSL/4DQ2p5a1ZUoMCDPj
         cvJotVZD6SMjDw0Y11905dmjjoC+Nm6MaLfR+Un4lCoU1dx8tbrwobKXBxl2WJJsopMe
         o4FIYioflvjyjZOu0mXBntuqEQ4a2MjRzy6OWzK5+VpCK+azE5Mzt5gfOfKy5FkWJcrC
         CoPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695332088; x=1695936888;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pR+2Sq/w5PO1VBsN7LGE/vsgLDdz85P5Qsv8lkXDhfw=;
        b=WM3GWs+qnLlzdt9Np4qPnLQIv3WSR0OnxTthksN8awxX8kp4P5xPzYEXFcnyL2BnF+
         HHSoQJFR9BcfalFdK8m0a5qqvkRP5LUWPAOGz5IgQQe5+BdI+L7B8HPhrm/z746Lmung
         iPXHGDeMSvHwT6xqMHyv9d37hcYvIry4ctj/01Ka7hYmQc2+NS35C+IcsObFeRnb7V4F
         6oLB+zMt0F30kHDlKQxaUvh7YiayzFI3Jgh29DZdpzXDxy9+7r0UgmXATSJsEYZph1id
         XvUtLsw6TePPjwlUeRHuwIbbWEMSHHEATxEbCideORKs4tR0ps/8mxXx4bvfJGXRXvyD
         BLoQ==
X-Gm-Message-State: AOJu0YwTHlCou4O3fKuPxeg3P5jRA66jNSxG5M6q4ScsP9Xx6obEkBGE
        9qgQF30988wXWQl34RC6kr0SP/AoL1w=
X-Google-Smtp-Source: AGHT+IHPp+gthilpe1ACitGvpuOvyGmVyPOCPYeySUnH3t8SZLPFwSVD9WckbY/e+Oyv6xiz6EbUHwXOp/o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:ce4c:0:b0:d81:f70e:1e1a with SMTP id
 x73-20020a25ce4c000000b00d81f70e1e1amr13692ybe.0.1695332087878; Thu, 21 Sep
 2023 14:34:47 -0700 (PDT)
Date:   Thu, 21 Sep 2023 14:34:46 -0700
In-Reply-To: <ZQypbSuMrbJpJBER@google.com>
Mime-Version: 1.0
References: <cover.1695327124.git.isaku.yamahata@intel.com>
 <f987dcde3b051371b496847282022c679e9402e4.1695327124.git.isaku.yamahata@intel.com>
 <ZQypbSuMrbJpJBER@google.com>
Message-ID: <ZQy29msIoAGQUGR2@google.com>
Subject: Re: [RFC PATCH v2 1/6] KVM: gmem: Truncate pages on punch hole
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
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 21, 2023, Sean Christopherson wrote:
> On Thu, Sep 21, 2023, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > Although kvm_gmem_punch_hole() keeps all pages in mapping on punching hole,
> > it's common expectation that pages are truncated.  Truncate pages on
> > punching hole.  As page contents can be encrypted, avoid zeroing partial
> > folio by refusing partial punch hole.
> > 
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >  virt/kvm/guest_mem.c | 14 ++++++++++++--
> >  1 file changed, 12 insertions(+), 2 deletions(-)
> > 
> > diff --git a/virt/kvm/guest_mem.c b/virt/kvm/guest_mem.c
> > index a819367434e9..01fb4ca861d0 100644
> > --- a/virt/kvm/guest_mem.c
> > +++ b/virt/kvm/guest_mem.c
> > @@ -130,22 +130,32 @@ static void kvm_gmem_invalidate_end(struct kvm_gmem *gmem, pgoff_t start,
> >  static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
> >  {
> >  	struct list_head *gmem_list = &inode->i_mapping->private_list;
> > +	struct address_space *mapping  = inode->i_mapping;
> >  	pgoff_t start = offset >> PAGE_SHIFT;
> >  	pgoff_t end = (offset + len) >> PAGE_SHIFT;
> >  	struct kvm_gmem *gmem;
> >  
> > +	/*
> > +	 * punch hole may result in zeroing partial area.  As pages can be
> > +	 * encrypted, prohibit zeroing partial area.
> > +	 */
> > +	if (offset & ~PAGE_MASK || len & ~PAGE_MASK)
> > +		return -EINVAL;
> 
> This should be unnecessary, kvm_gmem_fallocate() does
> 
> 	if (!PAGE_ALIGNED(offset) || !PAGE_ALIGNED(len))
> 		return -EINVAL;
> 
> before invoking kvm_gmem_punch_hole().  If that's not working, i.e. your test
> fails, then that code needs to be fixed.  I'll run your test to double-check,
> but AFAICT this is unnecesary.

I confirmed that the testcase passes without the extra checks.  Just to close the
loop, what prompted adding more checks to kvm_gmem_punch_hole()?
