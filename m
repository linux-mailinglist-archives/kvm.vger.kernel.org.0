Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEC6C37C53B
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 17:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233709AbhELPi6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 11:38:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58667 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235917AbhELPgK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 12 May 2021 11:36:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620833701;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PdIwuA6SZONtKFJj9ICYU33rWjC+MvCYEPPUbLma7+o=;
        b=XnsKJi+3H++e7sGRBYcMqumvJlRW4BsCNBNiP4YKud+HDSZamUKhkr1PEfKZC4Gn03RiBy
        2iGTIDNkcIMOWqVb59/cKLAkyahlWOgI/MhEV0mDUuDxCLTNRjsw5HVT1VJD6v9Cej68iC
        LnpLIDSc7TlGhHM3Vq82Jw0/5FBDvpo=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-450-bpgRdOPsOk-qGUrul3UVsw-1; Wed, 12 May 2021 11:34:59 -0400
X-MC-Unique: bpgRdOPsOk-qGUrul3UVsw-1
Received: by mail-qv1-f69.google.com with SMTP id d21-20020a0caa150000b02901e2ed83f922so11951980qvb.4
        for <kvm@vger.kernel.org>; Wed, 12 May 2021 08:34:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PdIwuA6SZONtKFJj9ICYU33rWjC+MvCYEPPUbLma7+o=;
        b=QfF2HrAZzltoWKmENunalFVG4KeEWFr6zG1gik0VPUFhQbGwW1+3qt01yDc5EOlhZK
         2gaE+wK7H8x9M5kGufjdTrEctuAdP8MuDsu3W9Yq3XaI3Ql3873uBwgnzbAydxSDj2c/
         7oF9S9UzsQ8886Pjw4/qKsFQV2B72iodjV8TL5qPcPMFIcBVes1s7E2/EeTKXcaSTOyQ
         vCmy8pflGiJBegD16B3rFlBZycpuP51ul5jQP+B+Zon9q1PCjk8QqT/phfeL4CP9o7ai
         Vx/A8lLyUCjC9NVBFr1YwMsEPorZ+V8bf1P8H6KPu7r5+iTy1KqKgyXGiKk0bHrAIEBK
         BaqA==
X-Gm-Message-State: AOAM532ZsiGd4xGJdBdaN4X5spOvhCbdEl1iBp4ZnPUCBGKVjAndqyCd
        NpBJpP1Jdu816/4YZeK1q6rdOIstH5DW9rZuZQ/vTD+RH8SJujwpGkJzTHIOqtaXThMR2g1g1lS
        9Flk0xvadXWZq
X-Received: by 2002:a37:30c:: with SMTP id 12mr34063133qkd.355.1620833698761;
        Wed, 12 May 2021 08:34:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxnRjVkfgLuSSi357o8L5EX+FX6JBBxp03jfLuLDnD+g0QmLvzcBmW+HNIRS1njQTVa0h8CgA==
X-Received: by 2002:a37:30c:: with SMTP id 12mr34063118qkd.355.1620833698570;
        Wed, 12 May 2021 08:34:58 -0700 (PDT)
Received: from t490s (bras-base-toroon474qw-grc-72-184-145-4-219.dsl.bell.ca. [184.145.4.219])
        by smtp.gmail.com with ESMTPSA id t187sm273302qkc.56.2021.05.12.08.34.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 08:34:58 -0700 (PDT)
Date:   Wed, 12 May 2021 11:34:57 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Marcelo Tosatti <mtosatti@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Pei Zhang <pezhang@redhat.com>
Subject: Re: [patch 4/4] KVM: VMX: update vcpu posted-interrupt descriptor
 when assigning device
Message-ID: <YJv1ofNKDpRF+vtu@t490s>
References: <YJWVAcIsvCaD7U0C@t490s>
 <20210507220831.GA449495@fuller.cnet>
 <YJqXD5gQCfzO4rT5@t490s>
 <20210511145157.GC124427@fuller.cnet>
 <YJqurM+LiyAY+MPO@t490s>
 <20210511171810.GA162107@fuller.cnet>
 <YJr4ravpCjz2M4bp@t490s>
 <20210511235124.GA187296@fuller.cnet>
 <20210512000259.GA192145@fuller.cnet>
 <YJvpNHAILLTghW1L@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YJvpNHAILLTghW1L@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 12, 2021 at 02:41:56PM +0000, Sean Christopherson wrote:
> On Tue, May 11, 2021, Marcelo Tosatti wrote:
> > > The KVM_REQ_UNBLOCK patch will resume execution even any such event
> > 
> > 						  even without any such event
> > 
> > > occuring. So the behaviour would be different from baremetal.
> 
> I agree with Marcelo, we don't want to spuriously unhalt the vCPU.  It's legal,
> albeit risky, to do something like
> 
> 	hlt
> 	/* #UD to triple fault if this CPU is awakened. */
> 	ud2
> 
> when offlining a CPU, in which case the spurious wake event will crash the guest.

We can avoid that by moving the check+clear of KVM_REQ_UNBLOCK from
kvm_vcpu_has_events() into kvm_vcpu_check_block() as replied in the other
thread.  But I also agree Marcelo's series should work already to fix the bug,
hence no strong opinion on this.

Thanks,

-- 
Peter Xu

