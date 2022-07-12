Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10D03572962
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 00:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233559AbiGLWf5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 18:35:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233026AbiGLWf4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 18:35:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 43C1FC3AEE
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 15:35:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657665354;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OETO5+tmZb+tFwem9JGI1S5zgmLmT7/eQERlYvFc98w=;
        b=gsldbmtjRWur6DXE8I7G3gKdqd1c7v4ww2uv5FaEfa+aFmN2OJwLv0O7c+EHJwTNUtHH44
        jxLt+tnEnh64xs8QnDMZ3XWgkhn6I7CaVPPkIAPKJBpDytfggRQNbo47tYkkeuaUspbY5b
        Ud7sX6+P+ncHIwunxQ9FkBYIQbOc1I4=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-451-fWi4oqVAMU-S-RpuF87eWg-1; Tue, 12 Jul 2022 18:35:53 -0400
X-MC-Unique: fWi4oqVAMU-S-RpuF87eWg-1
Received: by mail-qv1-f72.google.com with SMTP id od5-20020a0562142f0500b00473838e0feeso1747889qvb.9
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 15:35:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OETO5+tmZb+tFwem9JGI1S5zgmLmT7/eQERlYvFc98w=;
        b=aduUjRjxeZTWXV+avJ+VWGHuYlzuDzihnYNWCJDnO16E2lGXVer+Ze2hq4GmsuAsTR
         wDbxAA+DAx3lc33mxFpAR57PWUnsGHqK+iSB+AT2Xu17fvHly3H+gQh/WeboyZTGT7vb
         cDcd8jJNK4yY8ygxxt5Ev0r+d8O9qbhx3o5pYY1HbpJmbfebEB8e+8gFOHqHjkJvgT6T
         CHVz8w23lpSEVATD6VKOEA9L59XGrh7D05pwtfTtjaPJ5FRrRgD+aTO1zyStiQ5YywS1
         SSPKT0FbG6sOpoETd/p9HXHd1qJnw1zXnnPBCJhmptcanzs1YrfBb2hYWzxN7k/mFWbC
         gK6w==
X-Gm-Message-State: AJIora/+9kAZD6jGKTZDpBMp+a6jgFvhvfpsAR9I1yEk0O5Fip/LzPxb
        v1n+k2lEuVvTiMQA67JpXLfe9sUoRSYtkUX6PPbKorKnO1PrgNvG6GcGr4N5TpvKBBZgjWDOUNf
        P4zHG4cN+ERmq
X-Received: by 2002:ac8:5892:0:b0:31e:bc96:b262 with SMTP id t18-20020ac85892000000b0031ebc96b262mr235192qta.285.1657665352473;
        Tue, 12 Jul 2022 15:35:52 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1smlOYFtZYL1XDGm2X8xRHSp0Ztii6UFQzBq/ilGtKJ8FDnGcOq3+rS+TJz2xUlNGGzxeRC/Q==
X-Received: by 2002:ac8:5892:0:b0:31e:bc96:b262 with SMTP id t18-20020ac85892000000b0031ebc96b262mr235176qta.285.1657665352261;
        Tue, 12 Jul 2022 15:35:52 -0700 (PDT)
Received: from xz-m1.local (bras-base-aurron9127w-grc-37-74-12-30-48.dsl.bell.ca. [74.12.30.48])
        by smtp.gmail.com with ESMTPSA id v8-20020ac873c8000000b00317ccf991a3sm8096681qtp.19.2022.07.12.15.35.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 15:35:51 -0700 (PDT)
Date:   Tue, 12 Jul 2022 18:35:50 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] KVM: x86/mmu: Shrink pte_list_desc size when KVM is
 using TDP
Message-ID: <Ys33RtxeDz0egEM0@xz-m1.local>
References: <20220624232735.3090056-1-seanjc@google.com>
 <20220624232735.3090056-4-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220624232735.3090056-4-seanjc@google.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 24, 2022 at 11:27:34PM +0000, Sean Christopherson wrote:
> Dynamically size struct pte_list_desc's array of sptes based on whether
> or not KVM is using TDP.  Commit dc1cff969101 ("KVM: X86: MMU: Tune
> PTE_LIST_EXT to be bigger") bumped the number of entries in order to
> improve performance when using shadow paging, but its analysis that the
> larger size would not affect TDP was wrong.  Consuming pte_list_desc
> objects for nested TDP is indeed rare, but _allocating_ objects is not,
> as KVM allocates 40 objects for each per-vCPU cache.  Reducing the size
> from 128 bytes to 32 bytes reduces that per-vCPU cost from 5120 bytes to
> 1280, and also provides similar savings when eager page splitting for
> nested MMUs kicks in.
> 
> The per-vCPU overhead could be further reduced by using a custom, smaller
> capacity for the per-vCPU caches, but that's more of an "and" than
> an "or" change, e.g. it wouldn't help the eager page split use case.
> 
> Set the list size to the bare minimum without completely defeating the
> purpose of an array (and because pte_list_add() assumes the array is at
> least two entries deep).  A larger size, e.g. 4, would reduce the number
> of "allocations", but those "allocations" only become allocations in
> truth if a single vCPU depletes its cache to where a topup is needed,
> i.e. if a single vCPU "allocates" 30+ lists.  Conversely, those 2 extra
> entries consume 16 bytes * 40 * nr_vcpus in the caches the instant nested
> TDP is used.
> 
> In the unlikely event that performance of aliased gfns for nested TDP
> really is (or becomes) a priority for oddball workloads, KVM could add a
> knob to let the admin tune the array size for their environment.
> 
> Note, KVM also unnecessarily tops up the per-vCPU caches even when not
> using rmaps; this can also be addressed separately.

The only possible way of using pte_list_desc when tdp=1 is when the
hypervisor tries to map the same host pages with different GPAs?

And we don't really have a real use case of that, or.. do we?

Sorry to start with asking questions, it's just that if we know that
pte_list_desc is probably not gonna be used then could we simply skip the
cache layer as a whole?  IOW, we don't make the "array size of pte list
desc" dynamic, instead we make the whole "pte list desc cache layer"
dynamic.  Is it possible?

-- 
Peter Xu

