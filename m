Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 584253FF4A5
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 22:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234548AbhIBUOg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 16:14:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345551AbhIBUOW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Sep 2021 16:14:22 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C506DC061757
        for <kvm@vger.kernel.org>; Thu,  2 Sep 2021 13:13:23 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id c17so3219935pgc.0
        for <kvm@vger.kernel.org>; Thu, 02 Sep 2021 13:13:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CLRB1fmY18sRspCB9D7hr3FKnvNokdnWWOzE6+3PPlQ=;
        b=GmrNngoCk4V04BfxSA0bkXqg0TGLiQdCGNSwC670QeK+u8i3NrdmdCXYpRokKSweO0
         yumzbdZ4MDej2pXYUcUHRH8wA2U3wnPuHLUDTNQ9KfNu0iSO2SXWLtKUn57y47gPML8M
         bIGl+e5zYvRxG97IP6R/k1SssxWUy7yXAQT6Dt7JaXtT0cEswmF3TOQpgU6KD9jX5Thf
         NohTcFr7AjYlqycsmzmtD5z/M7l+x2Z2FOalh1BpC2bt0erayx2Q9t3ydOYez7F06z/B
         3sKhGwmWb/3jZ+YRbepbeZZoKYrBaw3uYVLvcFzA3287OXtcDYdZYU9UWDVTt2jEeSTy
         agow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CLRB1fmY18sRspCB9D7hr3FKnvNokdnWWOzE6+3PPlQ=;
        b=G1mzRBO0Wm+a1WNMZeOVQb6SlgmelVNdnNHyT+wkpDL38n2UA98CRpYR+f5JIBbDgW
         rwqwC88k8yzZnUCIlK0oOT41RewbMeo+VicD4b9SDRu1ZOpq8OSaW6gkuMasBd5v8MFy
         FczUDEA8LMDZLQthkBCMmoXKsrzCE2u08S4CtsCFRtUOxhguD8d48quxu5V8f5TZyayV
         S5UbenmCFtXk9CVr0eMbIOW5eqQACW2qzIPRwaX4nDQ70L1t1BVpt5whjQ3kLbiZhck/
         rEowNVpaCQYbtRrWUINYzR2CnU33UGa0UxxdojJMMWhhFBFxtTQMAsCdyohOCBXs0ttL
         ZghA==
X-Gm-Message-State: AOAM533yjxejL8q3Mc5foO/lL9HKNt11kIf3v9NGCPN3OGDhtu7rzEGI
        opTwPMkgo3iwOHuVmdRqyCpq7A==
X-Google-Smtp-Source: ABdhPJyEAVRd+rq9AbELMXl8dUzDNh8MEn8lpzeau0IqxK3acWf20Q1OkhetryKYRYWDmaHvBo1p+w==
X-Received: by 2002:a63:f62:: with SMTP id 34mr100328pgp.159.1630613603007;
        Thu, 02 Sep 2021 13:13:23 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id v20sm3663656pgi.39.2021.09.02.13.13.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 13:13:22 -0700 (PDT)
Date:   Thu, 2 Sep 2021 20:13:18 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] KVM: Drop unused kvm_dirty_gfn_harvested()
Message-ID: <YTEwXjghbR3hnHLj@google.com>
References: <20210901230506.13362-1-peterx@redhat.com>
 <87y28flyxj.fsf@vitty.brq.redhat.com>
 <YTD+eBj+9+mb9LVg@google.com>
 <87r1e7lycp.fsf@vitty.brq.redhat.com>
 <YTErzxipuwv7X0Qk@t490s>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YTErzxipuwv7X0Qk@t490s>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 02, 2021, Peter Xu wrote:
> On Thu, Sep 02, 2021 at 06:46:14PM +0200, Vitaly Kuznetsov wrote:
> > Sean Christopherson <seanjc@google.com> writes:
> > 
> > > On Thu, Sep 02, 2021, Vitaly Kuznetsov wrote:
> > >> Peter Xu <peterx@redhat.com> writes:
> > >> 
> > >> > Drop the unused function as reported by test bot.
> > >> 
> > >> Your subject line says "Drop unused kvm_dirty_gfn_harvested()" while in
> > >> reallity you drop "kvm_dirty_gfn_invalid()".
> > >
> > > Heh, Peter already sent v2[*].  Though that's a good reminder that it's helpful
> > > to reviewers to respond to your own patch if there's a fatal mistake and you're
> > > going to immediately post a new version.  For tiny patches it's not a big deal,
> > > but for larger patches it can avoid wasting reviewers' time.
> > >
> > 
> > Indeed. It's also a good reminder for reviewers that inbox is best
> > treated like a stack and not like a queue :-)
> 
> It should really be a queue, to be fair. :)

Ya, a queue plus a deferred work queue for things that can't be handled in
interrupt context ;-)
