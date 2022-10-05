Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B45DE5F5C9C
	for <lists+kvm@lfdr.de>; Thu,  6 Oct 2022 00:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbiJEWVT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Oct 2022 18:21:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbiJEWVR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Oct 2022 18:21:17 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DA7163FF9
        for <kvm@vger.kernel.org>; Wed,  5 Oct 2022 15:21:08 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id s206so168011pgs.3
        for <kvm@vger.kernel.org>; Wed, 05 Oct 2022 15:21:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=iiRe7QW1gdDpEjdXkmAfWdE0QY7wdKR6FJSJkfOpMGE=;
        b=pOAqNt0tczK9ie3K8vCgVw7JcFcyGSt9vo8hoxFJhXqJ8JxSVB392bhHPRdXfme7cx
         B8yb2pITOpcSiIzQ31SU/1QzTeVYaDpRi0/IBxwIBVXZ1C0s9F5EZPYkQXFnIETztrJx
         GjgdtwuRB3JkZ/gMjpIAp9CaGCnyL5Q/r3EsN9UJNlce7c3T60ne+fhr/+minSOzj2Dn
         0OCLfX5tV9OBbscpj8hB938OjTWbBxiTIM7DRj1eUUTInElM8YqNdYsC76HGIEu7qpzl
         Wc55psuSh+iyIzn7hca3gvoJ95aOuY/eK99WkLwu34NIQJo9vUQTngTmE4yJBJnTnGdk
         jUoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iiRe7QW1gdDpEjdXkmAfWdE0QY7wdKR6FJSJkfOpMGE=;
        b=mLiNe1QZuFY0Yl4KAuVwrhzloO+kE+nCEHC2tppiJ+kuSIKkBXix/Rg7kDTvRifVew
         qNgHoq0hprcy/CybsSyTMThNamF/xhfsexh3/jnZbe/Hc+ljKQKnYQIvkstGccEtqwCY
         oB5nVJZwVN8v51BglU8FBYCkY7H3UbBC8ZghcORiMFSXCuL4xLQUxgNit4G0Gdr8J9D+
         BNnfz/cyo9QEPlNZDP0RiqGfeFi6VWFNga/C5pJsDoBjjjusCNPZnWsFk8xvogERhj+U
         H+J1Pl/uYsU7WUk4sJhlaA+UCg7MuJZZPx6oKGmntxePD8l7wvUQvc9OEwU+DBODtf1/
         xJaQ==
X-Gm-Message-State: ACrzQf28kUY1UYsnS2qeVvQ7oRDPwaJ+CbiP4XXStAeru4wTi8rTLlAl
        pAy6GHUAoDSHqFs7IDFNPgvNiA==
X-Google-Smtp-Source: AMsMyM59E2QzYV3IW1s43M2Oy2ZdBBYI1bz6B2nJrd6IXsD7jeMUbk9Dn/WZsAINDibjui4TGT7K7g==
X-Received: by 2002:a05:6a00:2290:b0:561:dd60:37a3 with SMTP id f16-20020a056a00229000b00561dd6037a3mr1867517pfe.17.1665008467640;
        Wed, 05 Oct 2022 15:21:07 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id m126-20020a625884000000b00537fb1f9f25sm11445799pfb.110.2022.10.05.15.21.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Oct 2022 15:21:06 -0700 (PDT)
Date:   Wed, 5 Oct 2022 22:21:03 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v3 04/13] x86/pmu: Add tests for Intel
 Processor Event Based Sampling (PEBS)
Message-ID: <Yz4DT4tz0Lrsgu0J@google.com>
References: <20220819110939.78013-1-likexu@tencent.com>
 <20220819110939.78013-5-likexu@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220819110939.78013-5-likexu@tencent.com>
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

On Fri, Aug 19, 2022, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> This unit-test is intended to test the KVM's support for
> the Processor Event Based Sampling (PEBS) which is another
> PMU feature on Intel processors (start from Ice Lake Server).
> 
> If a bit in PEBS_ENABLE is set to 1, its corresponding counter will
> write at least one PEBS records (including partial state of the vcpu
> at the time of the current hardware event) to the guest memory on
> counter overflow, and trigger an interrupt at a specific DS state.
> The format of a PEBS record can be configured by another register.
> 
> These tests cover most usage scenarios, for example there are some
> specially constructed scenarios (not a typical behaviour of Linux
> PEBS driver). It lowers the threshold for others to understand this
> feature and opens up more exploration of KVM implementation or
> hw feature itself.
> 
> Signed-off-by: Like Xu <likexu@tencent.com>

I responded to the previous version, didn't realize it got merged in with this
series (totally fine, I just missed it).  I think all my feedback still applies.

https://lore.kernel.org/all/Yz3XiP6GBp95YEW9@google.com
