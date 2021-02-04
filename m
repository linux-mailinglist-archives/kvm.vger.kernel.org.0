Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8309F30FA4E
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 18:54:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237183AbhBDRx4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 12:53:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238018AbhBDRxd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Feb 2021 12:53:33 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D295BC061786
        for <kvm@vger.kernel.org>; Thu,  4 Feb 2021 09:52:50 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id i63so2569150pfg.7
        for <kvm@vger.kernel.org>; Thu, 04 Feb 2021 09:52:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=cx1dhXU3qOD8oI1+O6V5WgnRcjWaTtIOCNrOY5Nrtcg=;
        b=cSC11rv8zFJtauQ70mp2biA5nrhwcxH7FpWRzQocrDYkcBkljIBu+kRj/bhN14s+1a
         5aWwhr7BKXlOptV04gYpuPPOW8HRHD3KfProqKVIJ8HfmpEXxn1PGcQe2JHJALcp7hRW
         DrqnfH6xfNJZnjdloOpB9iL/aqYbZyOquuuT6dHdQEovewDTd1TZ5Z6aQYdK+JubML2L
         Awwqgx83vkrb97QA3/yawjOkEL9/AJu1MWrOeiNib2pMY0Jdxh4zPeFRr/xxDDVbaGm2
         bCPYczWk7NrsPi7zAtJ7fLEpT8mWMhLSmh0bCDGUPjjuOQBN8CiYkqobmrIwiqsG6fUs
         jsxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=cx1dhXU3qOD8oI1+O6V5WgnRcjWaTtIOCNrOY5Nrtcg=;
        b=VMnRh58hQamxtdaIM0q/9CC9oH5rUu9BlROFEDhRQkjA2ZgjSlgKpp0lGJ57p5NKj7
         SYDjgEkCkvJG0Uq5CbDW8bUH8kqnY6XMA1uQQFuvhaoNy8+Tf8JrrcN3JhLSX5OGTuBI
         dQBGZg8PUHtic2nyNZnUooPAE1cTFIq1sWGRBcVZg9/d4zCIoQlxCz+o/r5M4BelajpO
         Wv6xVr2AUARrgJky9z5pnBQiftqeU895rVgXqDADgj+oszBrj1NLviUokUTnFv+Dffby
         QzvnjZ2lmlhqiK0TBNKw9/y5UZaPbMnJZJtotgZsCTvW+pNnXT2w9sZU9+4JxoMsifTv
         fYMA==
X-Gm-Message-State: AOAM5315wcoeCdLBvZauiSqnVfThUDjEjLdxlXxhQ9+4L2K4qw+5Fe5l
        P9GJ3U6ou8hC1rlW2TISTk5RlA==
X-Google-Smtp-Source: ABdhPJwG/WfWfCQrdYEYzkyR3wSWWnNh5RRGbixURf2CXJlrbPD9eBhoknB4qAoDwTvT2zQ72c/rCQ==
X-Received: by 2002:a63:d446:: with SMTP id i6mr137454pgj.446.1612461170163;
        Thu, 04 Feb 2021 09:52:50 -0800 (PST)
Received: from google.com ([2620:15c:f:10:f16f:a28e:552e:abea])
        by smtp.gmail.com with ESMTPSA id f7sm5847879pjh.45.2021.02.04.09.52.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 09:52:49 -0800 (PST)
Date:   Thu, 4 Feb 2021 09:52:43 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "brijesh.singh@amd.com" <brijesh.singh@amd.com>
Subject: Re: [PATCH 07/12] KVM: x86: SEV: Treat C-bit as legal GPA bit
 regardless of vCPU mode
Message-ID: <YBw0a5fFvtOrDwOR@google.com>
References: <20210204000117.3303214-1-seanjc@google.com>
 <20210204000117.3303214-8-seanjc@google.com>
 <5fa85e81a54800737a1417be368f0061324e0aec.camel@intel.com>
 <YBtZs4Z2ROeHyf3m@google.com>
 <f1d2f324-d309-5039-f4f6-bbec9220259f@redhat.com>
 <e68beed4c536712ddf28cdd8296050222731415e.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e68beed4c536712ddf28cdd8296050222731415e.camel@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 04, 2021, Edgecombe, Rick P wrote:
> On Thu, 2021-02-04 at 11:34 +0100, Paolo Bonzini wrote:
> > On 04/02/21 03:19, Sean Christopherson wrote:
> > > Ah, took me a few minutes, but I see what you're saying.  LAM will
> > > introduce
> > > bits that are repurposed for CR3, but not generic GPAs.  And, the
> > > behavior is
> > > based on CPU support, so it'd make sense to have a mask cached in
> > > vcpu->arch
> > > as opposed to constantly generating it on the fly.
> > > 
> > > Definitely agree that having a separate cr3_lm_rsvd_bits or
> > > whatever is the
> > > right way to go when LAM comes along.  Not sure it's worth keeping
> > > a duplicate
> > > field in the meantime, though it would avoid a small amount of
> > > thrash.
> > 
> > We don't even know if the cr3_lm_rsvd_bits would be a field in 
> > vcpu->arch, or rather computed on the fly.  So renaming the field in 
> > vcpu->arch seems like the simplest thing to do now.
> 
> Fair enough. But just to clarify, I meant that I thought the code would
> be more confusing to use illegal gpa bit checks for checking cr3. It
> seems they are only incidentally the same value.

Hmm, yeah, bits 63:52 are incidental.  Bits 52:M are not, though.  If/when we
need to special case CR3, I would like to take a similar approach to
__reset_rsvds_bits_mask(), where the high reserved bits start from
reserved_gpa_bits and mask off the bits that can't be encoded into a PxE.

> Alternatively there could be something like a is_rsvd_cr3_bits() helper that
> just uses reserved_gpa_bits for now. Probably put the comment in the wrong
> place.  It's a minor point in any case.

That thought crossed my mind, too.  Maybe kvm_vcpu_is_illegal_cr3() to match
the gpa helpers?
