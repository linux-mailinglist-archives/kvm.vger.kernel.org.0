Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA8A7AA306
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 23:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232695AbjIUVqR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 17:46:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231717AbjIUVp7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 17:45:59 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FCB126B72
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 14:29:23 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d8571d5e71aso1869523276.0
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 14:29:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695331762; x=1695936562; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kGBnu6VSG+/azby0SuhGoM7WFu5N49MxhGtPLCEYj7Y=;
        b=W3hFy/vA/TquUU0Uqpb7A5n2npDV2RZ1Auz9VXKfdldU7FF8DjOBmf5kBjUt/qir8D
         55UKNyK3B8/kkLYRIATr9A1/Hkrz14uVSXQNonasQN88MXidiuHy7cbYX3Rim0Ucu79K
         U9INd2CYFaG94bJZ7Xbv2Bd0vugXyBlacxYMOfhKr5VjPmAITKSyqULgh/hNr3TN9LXK
         wZxC7aY8DYBkSvwk5XSpUEogE3NID+kUBAw0tIR2YyckRFC+SglcnTcjpc3e7hCsqErb
         1cF4QBU0AORnHIzO4FH907QjBiy64/PuYX4iFoqtZtX3Ur2S5ie0QjWvGSXUHV3/hkNw
         tSjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695331762; x=1695936562;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kGBnu6VSG+/azby0SuhGoM7WFu5N49MxhGtPLCEYj7Y=;
        b=Lrk9CtnbuW2brlKfRRukYWlfFvf/R28fLrzAcTWwA7cVcTsvUymhAYQ12eBin401/+
         A/PUQP5uKTxNJdv3WhcAIqYan9AyU5hAMy8AIQU4afcFcTUR1YAh62t3nQ8dUdwqdgLy
         JsjL8hrv3WnJprBQkk2i/5HHK/vhwIJ41sEHYCIEM8GL2REZ9eeARFRqBVzTM5+iLOWK
         6L1VUlB0nmt2UOSKvbTEjrNusxamUnbDgqauAtkurJc3CPIIeVQXGT5RTUifG6WdHK6h
         iTshScJdGTuSzJDbBM43mEHfgdFq50cCMr6LkbRoh9SCG6uoWBWl1Exl3605cLurwI44
         dIkw==
X-Gm-Message-State: AOJu0YzugE0FXnFt3G8ROV/lS/94kU7YV6HzHbF0bliJ9AWWCqsgMS3/
        EhRHZJr6ElHm0Q1ESuaysjMzg1rU5cU=
X-Google-Smtp-Source: AGHT+IHWNByCIxDzTx5QAdD7uR/d2d7gUCrth/qIEPfej09mGplokWZOjT6UEUFRsTTKmehDwV7dGEBrHFk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:420b:0:b0:d0c:c83b:94ed with SMTP id
 p11-20020a25420b000000b00d0cc83b94edmr88009yba.10.1695331762271; Thu, 21 Sep
 2023 14:29:22 -0700 (PDT)
Date:   Thu, 21 Sep 2023 14:29:20 -0700
In-Reply-To: <363c4ac28af93aa96a52f897d2fe5c7ec013f746.1695327124.git.isaku.yamahata@intel.com>
Mime-Version: 1.0
References: <cover.1695327124.git.isaku.yamahata@intel.com> <363c4ac28af93aa96a52f897d2fe5c7ec013f746.1695327124.git.isaku.yamahata@intel.com>
Message-ID: <ZQy1sDOQAxPyZzjW@google.com>
Subject: Re: [RFC PATCH v2 4/6] KVM: gmem: Add ioctl to inject memory failure
 on guest memfd
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

On Thu, Sep 21, 2023, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> To test error_remove_page() method of KVM gmem, add a new ioctl to
> inject memory failure based on offset of guest memfd.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  include/uapi/linux/kvm.h |  6 ++++
>  virt/kvm/guest_mem.c     | 68 ++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 74 insertions(+)
> 
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 65fc983af840..4160614bcc0f 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -2323,4 +2323,10 @@ struct kvm_create_guest_memfd {
>  	__u64 reserved[6];
>  };
>  
> +#define KVM_GUEST_MEMORY_FAILURE	_IOWR(KVMIO,  0xd5, struct kvm_guest_memory_failure)

If we're going to add a KVM ioctl(), my vote is to make it a generic ioctl(), not
something that's specific to guest_memfd().  IIUC, all we need is the PFN, so the
only downside is that it'd require valid memslots.  But the test isn't all that
interesting unless there are memslots, so I don't see that as a negative.

And if we add an ioctl(), it should be conditioned on CONFIG_HWPOISON_INJECT.

An alternative I think we should seriously consider is using the FAULT_INJECTION
framework to poison pages.  We (Google) have plans to utilize fault injection for
other things in KVM, e.g. to inject "failures" on CMPXCHG in atomic SPTE updates
to force KVM down unlikely slow paths.  I don't expect us to get patches posted
until early next year due to priorities, but hell or high water we will get patches
posted at some point.

The fault injection framework might be overkill for injecting memory errors, e.g.
a single ioctl() is definitely simpler to setup, but I suspect it would also be
much more powerful in the long run..
