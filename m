Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33852626518
	for <lists+kvm@lfdr.de>; Sat, 12 Nov 2022 00:00:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234427AbiKKXAS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 18:00:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbiKKXAR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 18:00:17 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42E7711A3C
        for <kvm@vger.kernel.org>; Fri, 11 Nov 2022 15:00:16 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id l22-20020a17090a3f1600b00212fbbcfb78so8927638pjc.3
        for <kvm@vger.kernel.org>; Fri, 11 Nov 2022 15:00:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EXxysosi2pB1lHjcZe6TR6GN44puMGv7Sb4rfuvd3b8=;
        b=bOkMHaWMX8iYB/kv7bjVFPLxhSAgXvRcQzvvr0YMaufhZIiWvsZMZcpNSTN3jUaB1n
         +Z3wqSA0VeQ0pDal5g+FwtfY77ZNBrO9/cS6ob4mhSujxdETPi2+GYpWmWz8zjE9JVgF
         VQnp5EuqjWQP9mIrrXMpPC3YYMjaxKc6FM/2TVC2l1EDOIGZX0pvCBdRV81LIxT+Invc
         jDYfrm8JvweZAp1ipwPYCqC1XFNkwzcdYsYgxrr8+PzsFqOYTxfqiHht86Yv5fs5MBS9
         Q2MGl8ce9QLTQpnR72MeMr3Vwrx9QgnLZEmDZh37YMBxh+I9RvW8v1Lcpz3w6KnlmGIG
         mk5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EXxysosi2pB1lHjcZe6TR6GN44puMGv7Sb4rfuvd3b8=;
        b=lCh8znZzyw6lS1DzZAGR54+WD7/Mm/WXjM+cEkOuds6EhnE3lswzzO0zNTGkj9yZWZ
         hmzECDUlFqIvwXYtNN41jxOqDENXc06VQKdnZ1N58GMbYyUerS2ty/dCBlfGpnyEtWkU
         HP07wzpT6oG/70f1iQtHWNconsALqtX/bOtgeuPpaNtYKD+c2YdpWFdV6CQHCK8mzt+U
         ablfIMor4Zjjdx0F0wRaHv7QhVV0muKPwl+SQFfOrzswqxbhxKyyZfdOK8FrybiGTbiI
         0EsoJpldgCaAti2a7wRZIFhb9sXPME1UY3WTXgTd10HcwAL1IPS687FNDSpKV8H/1JMU
         0FhA==
X-Gm-Message-State: ANoB5plVbRo34db1ikvwnU0irjEV0WxP0tXORYCiTXTGzBXyHG5dag45
        9dBkaRQlEZy1h1b1F1C4rh+pig==
X-Google-Smtp-Source: AA0mqf6rHbHOxSOsy5zgUU8q0v9Y6gE7Cr/fm1KW8Ltanni/hVq24i1abbayy3TtoD+n1xu+b7dmXw==
X-Received: by 2002:a17:902:7896:b0:186:f256:91cd with SMTP id q22-20020a170902789600b00186f25691cdmr4405929pll.152.1668207615644;
        Fri, 11 Nov 2022 15:00:15 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id t8-20020a63b248000000b00439d071c110sm1821495pgo.43.2022.11.11.15.00.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Nov 2022 15:00:15 -0800 (PST)
Date:   Fri, 11 Nov 2022 23:00:11 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Gavin Shan <gshan@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        shuah@kernel.org, catalin.marinas@arm.com, andrew.jones@linux.dev,
        ajones@ventanamicro.com, bgardon@google.com, dmatlack@google.com,
        will@kernel.org, suzuki.poulose@arm.com, alexandru.elisei@arm.com,
        pbonzini@redhat.com, peterx@redhat.com, oliver.upton@linux.dev,
        zhenyzha@redhat.com, shan.gavin@gmail.com
Subject: Re: [PATCH v10 3/7] KVM: Support dirty ring in conjunction with
 bitmap
Message-ID: <Y27T+1Y8w0U6j63k@google.com>
References: <20221110104914.31280-1-gshan@redhat.com>
 <20221110104914.31280-4-gshan@redhat.com>
 <Y20q3lq5oc2gAqr+@google.com>
 <1cfa0286-9a42-edd9-beab-02f95fc440ad@redhat.com>
 <86h6z5plhz.wl-maz@kernel.org>
 <d11043b5-ff65-0461-146e-6353cf66f737@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d11043b5-ff65-0461-146e-6353cf66f737@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Nov 12, 2022, Gavin Shan wrote:
> Hi Marc,
> 
> On 11/11/22 11:19 PM, Marc Zyngier wrote:
> > On Thu, 10 Nov 2022 23:47:41 +0000,
> > Gavin Shan <gshan@redhat.com> wrote:
> > But that I don't get. Or rather, I don't get the commit message that
> > matches this hunk. Do we want to catch the case where all of the
> > following are true:
> > 
> > - we don't have a vcpu,
> > - we're allowed to log non-vcpu dirtying
> > - we *only* have the ring?

As written, no, because the resulting WARN will be user-triggerable.  As mentioned
earlier in the thread[*], if ARM rejects KVM_DEV_ARM_ITS_SAVE_TABLES when dirty
logging is enabled with a bitmap, then this code can WARN.

> > If so, can we please capture that in the commit message?
> > 
> 
> Nice catch! This particular case needs to be warned explicitly. Without
> the patch, kernel crash is triggered. With this patch applied, the error
> or warning is dropped silently. We either check memslot->dirty_bitmap
> in mark_page_dirty_in_slot(), or check it in kvm_arch_allow_write_without_running_vcpu().
> I personally the later one. Let me post a formal patch on top of your
> 'next' branch where the commit log will be improved accordingly.

As above, a full WARN is not a viable option unless ARM commits to rejecting
KVM_DEV_ARM_ITS_SAVE_TABLES in this scenario.  IMO, either reject the ITS save
or silently ignore the goof.  Adding a pr_warn_ratelimited() to alert the user
that they shot themselves in the foot after the fact seems rather pointless if 
KVM could have prevented the self-inflicted wound in the first place.

[*] https://lore.kernel.org/all/Y20q3lq5oc2gAqr+@google.com
