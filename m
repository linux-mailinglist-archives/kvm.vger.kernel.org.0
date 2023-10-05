Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF7E97B998C
	for <lists+kvm@lfdr.de>; Thu,  5 Oct 2023 03:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244261AbjJEBSr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Oct 2023 21:18:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244241AbjJEBSq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Oct 2023 21:18:46 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B83AC6
        for <kvm@vger.kernel.org>; Wed,  4 Oct 2023 18:18:42 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id 98e67ed59e1d1-27731a63481so364283a91.2
        for <kvm@vger.kernel.org>; Wed, 04 Oct 2023 18:18:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696468722; x=1697073522; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Wbr8G8c5SpkphgF6J+oopW5jS/piuS6angX7igUOPT0=;
        b=skG6UnKoadAlYOl4yzybn/+6c31AUZjq/P23IPVeLXemOQX7hs7QFnY63WfpGfDSGU
         3wnZM1lkVX+IH5qMMtGAN2Om0dR2ozb/isHXy/BiYfV5esr/Hgja4bL3gGWAmwNWFsNc
         J+ZJ8WSn1Jk2FzpSPr2aT55lH0tv/APRqPO+DcFO/0wcWmdT527nprpJkYAEMWVhAlka
         iNQCCcF11iJG21YTe69Bfg5XHKHPDW3Cxw2DlJV4iibEnI50lZIXW/Dal/gZwptu6TQN
         Tw7sI+XCYO5pkV0a3hwAmLqpPZJ0zbif74mUaRmFZXLuqWS3eNPVQ8OBuWc7oYUbX4Nz
         UYFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696468722; x=1697073522;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wbr8G8c5SpkphgF6J+oopW5jS/piuS6angX7igUOPT0=;
        b=AB6rmowk62uGsbNoiIlI1THdTtp6DPjP2d2iVQTqUsgu8JMFUW7TzOzQkP7urcghTF
         KdA4bUKoFTXvDwa11iQyXFpIYIR0h7n65muEdGMi+dHmvPHXJIUECHf2OJK260PcVaDm
         tORSunFKSGGfLHsjuAzvKgmtQ8oFYMD5Vv5tMlLdkUV6j6pKbvIft1QmuR0YBtOvgoDY
         ajCO1D7zxTyav2VZRMA2SBidmh1ZJDx1+/OCLl6M0J9JTGBLynvp38Z9YmMHa4KPsE8b
         etJ4Dd3l7TwVv58X3OQtKpqXpwRPCveKxJcyHx5PIZ/WVKrr3pJ8LBcu4zERsbAC2vkq
         43og==
X-Gm-Message-State: AOJu0YzxFO87XYqMZT212Lo6zDu0Addg4US47TMMmi5UeVjQXLcQU97i
        8Td70QbpHwriJjMFOn+aWiFt02O4EGo=
X-Google-Smtp-Source: AGHT+IF0zzx7UMQ4wDXUv+JbgsF4dcYKUkEQIdr20Hqdjjh8byx0S/1IKqQI4ivKKJtuCJfX/AuHMQGHBMk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:d396:b0:273:dfcd:bdbf with SMTP id
 q22-20020a17090ad39600b00273dfcdbdbfmr63059pju.8.1696468721871; Wed, 04 Oct
 2023 18:18:41 -0700 (PDT)
Date:   Wed, 4 Oct 2023 18:18:40 -0700
In-Reply-To: <20230908222905.1321305-3-amoorthy@google.com>
Mime-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com> <20230908222905.1321305-3-amoorthy@google.com>
Message-ID: <ZR4O8MMbQLEjbvn0@google.com>
Subject: Re: [PATCH v5 02/17] KVM: Add docstrings to __kvm_read/write_guest_page()
From:   Sean Christopherson <seanjc@google.com>
To:     Anish Moorthy <amoorthy@google.com>
Cc:     oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org,
        robert.hoo.linux@gmail.com, jthoughton@google.com,
        ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com,
        nadav.amit@gmail.com, isaku.yamahata@gmail.com,
        kconsul@linux.vnet.ibm.com
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

On Fri, Sep 08, 2023, Anish Moorthy wrote:
> The (gfn, data, offset, len) order of parameters is a little strange,
> since "offset" actually applies to "gfn" rather than to "data". Add
> docstrings to make things perfectly clear.
> 
> Signed-off-by: Anish Moorthy <amoorthy@google.com>
> ---
>  virt/kvm/kvm_main.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 84e90ed3a134..12837416ce8a 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3014,6 +3014,9 @@ static int next_segment(unsigned long len, int offset)
>  		return len;
>  }
>  
> +/*
> + * Copy 'len' bytes from guest memory at '(gfn * PAGE_SIZE) + offset' to 'data'

A preceding @ is usually how kernel comments refer to paramaters, e.g. an
alternative would be:

  /* Copy @len bytes from guest memory at '(@gfn * PAGE_SIZE) + @offset' to @data */

Though I think I find your version to be more readable.

> + */

No need for a multi-line comment.

>  static int __kvm_read_guest_page(struct kvm_memory_slot *slot, gfn_t gfn,
>  				 void *data, int offset, int len)
>  {
> @@ -3115,6 +3118,9 @@ int kvm_vcpu_read_guest_atomic(struct kvm_vcpu *vcpu, gpa_t gpa,
>  }
>  EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_atomic);
>  
> +/*
> + * Copy 'len' bytes from 'data' into guest memory at '(gfn * PAGE_SIZE) + offset'
> + */
>  static int __kvm_write_guest_page(struct kvm *kvm,
>  				  struct kvm_memory_slot *memslot, gfn_t gfn,
>  			          const void *data, int offset, int len)
> -- 
> 2.42.0.283.g2d96d420d3-goog
> 
