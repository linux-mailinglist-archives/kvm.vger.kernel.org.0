Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D06FB41E007
	for <lists+kvm@lfdr.de>; Thu, 30 Sep 2021 19:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352500AbhI3RVW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Sep 2021 13:21:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352531AbhI3RVH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Sep 2021 13:21:07 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45959C06176A
        for <kvm@vger.kernel.org>; Thu, 30 Sep 2021 10:19:23 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id w14so5614536pfu.2
        for <kvm@vger.kernel.org>; Thu, 30 Sep 2021 10:19:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FbUMduP+V7YnqmanKgM6nU8SaYibHpVmraBSeLg1aDM=;
        b=bYLXQKEpsloNnvsHfy/j8500N9x/ynvqqMtXn5sN5GSVf9iu2E0yiCvHR6+tveYSRF
         kmVrrANLCl4pgMNjtLDYSm5s3jem1aABmFVatjxdL16HrFTX2WjDb1B90K6jdb73d7f5
         BCUMOf43v1SqO/6bCO9meJISuWfIcxI+RLkVFrLQJTUeUcEPrBEiapNuQs2ht64kUhNG
         Udmw/pPF3P1scQ7K4tRSr3rVaUTpFnEOrTDmFvBiEyw0V6w7VPnU9fpmgDkPe6xf1+o/
         g00yBzaTvFnTOWcdpnUB8/aaBQ4qDSmAG1PN1GMxv7JvQ/zDgYLDcinUPoUWZQDDMOcd
         p++A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FbUMduP+V7YnqmanKgM6nU8SaYibHpVmraBSeLg1aDM=;
        b=NYVnTdEwqJn0NpSGudNGtf8aTFx2qXeVekNYUrMye3zV7ajv7EhcpO2KCP/qBahgig
         I17bazvWM20QzWmwkwvhL2dFZvaugwnkC84wXEuUn6hCxYrfwJLoS6cmjaGUucGRw+G8
         b/8b9QjteM9Od8c0v/rAmzReDZHmSVGmC0lClctFcS6Hrncfsa2tNA7gkQSb5mFfidX9
         s43ZV10JzQ4dtQE+nWyDOLrmHH4hBV2hrMXJbW82ZObuL9KuZqRSgc+WTnenl9fRXFLq
         olxNIwg9fcK6MXXO2eOEooPOKJCaHVRq42+dy6nDF9bcrpF+mzC7MET0EBGtSpp+sokt
         ktOw==
X-Gm-Message-State: AOAM531Gxbvr+LXybRvEHccqkCjcXKR5orfBPoPqc7ZrKECyZdlm9Sxu
        H7mjv8Vg5761JT+n+NLY7WPIPA==
X-Google-Smtp-Source: ABdhPJzo4auAyDB0h9s5ykpt5niwliEjviFUy6E2xL/2EeRvCDpS3aPUP1uUEhuzYpWfypFK//XGoA==
X-Received: by 2002:a63:1d5c:: with SMTP id d28mr5872510pgm.143.1633022362363;
        Thu, 30 Sep 2021 10:19:22 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id w6sm3852283pfj.179.2021.09.30.10.19.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 10:19:21 -0700 (PDT)
Date:   Thu, 30 Sep 2021 17:19:18 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
        Peter Shier <pshier@google.com>, kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH v2 06/11] KVM: arm64: Add support for SYSTEM_SUSPEND PSCI
 call
Message-ID: <YVXxlg6g4fYsphwM@google.com>
References: <20210923191610.3814698-1-oupton@google.com>
 <20210923191610.3814698-7-oupton@google.com>
 <877deytfes.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877deytfes.wl-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 30, 2021, Marc Zyngier wrote:
> Hi Oliver,
> 
> On Thu, 23 Sep 2021 20:16:05 +0100,
> Oliver Upton <oupton@google.com> wrote:
> > 
> > ARM DEN0022D 5.19 "SYSTEM_SUSPEND" describes a PSCI call that may be
> > used to request a system be suspended. This is optional for PSCI v1.0
> > and to date KVM has elected to not implement the call. However, a
> > VMM/operator may wish to provide their guests with the ability to
> > suspend/resume, necessitating this PSCI call.
> > 
> > Implement support for SYSTEM_SUSPEND according to the prescribed
> > behavior in the specification. Add a new system event exit type,
> > KVM_SYSTEM_EVENT_SUSPEND, to notify userspace when a VM has requested a
> > system suspend. Make KVM_MP_STATE_HALTED a valid state on arm64.
> 
> KVM_MP_STATE_HALTED is a per-CPU state on x86 (it denotes HLT). Does
> it make really sense to hijack this for something that is more of a
> VM-wide state? I can see that it is tempting to do so as we're using
> the WFI semantics (which are close to HLT's, in a twisted kind of
> way), but I'm also painfully aware that gluing x86 expectations on
> arm64 rarely leads to a palatable result.

Agreed, we literally have billions of possible KVM_MP_STATE_* values, and I'm pretty
sure all of the existing states are arch-specific.  Some are common to multiple
architectures, but I don't think _any_ are common to all architectures.
