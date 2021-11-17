Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 778AD455063
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 23:25:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241199AbhKQW2x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 17:28:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231985AbhKQW2t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Nov 2021 17:28:49 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31BEBC061764
        for <kvm@vger.kernel.org>; Wed, 17 Nov 2021 14:25:50 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id h63so3475167pgc.12
        for <kvm@vger.kernel.org>; Wed, 17 Nov 2021 14:25:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SASNYe7ialNeT+SNGQ0HWi92OXWehEQ5BnfhLDZEfjA=;
        b=jKtC62fT/J1hSqWf6djWaTj7j/nfB2gv1mMpwf8irtCuyVc44WseHOa4eSkafVrsUE
         N5vwNdmcxR0qGjI+AD06JZGrkEmjMtNwpyfZSLbrmsSVSYx9e+oh70emVTscxMcKlAI/
         wSf7+7geJTsEHtcq8sCZgfnsyg+sk0LIk7URM+NKUzy86eRs40LRi4LnlEHlGEOEffnR
         soq4UiKM1eEzVTHyDE7DdJ0IFBvPRWPLDQnEYfc+sO9lXAl2qQ7l1DGSjiKbCbEGOO7S
         zCKetzVMkf+KbFx+qy0dmJTqJVz7Mibw8aeKgIw9K9gcEzthpMGURVq+Js7Q054pOm+A
         CIzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SASNYe7ialNeT+SNGQ0HWi92OXWehEQ5BnfhLDZEfjA=;
        b=2KngQb8XP7LHomUU23qSVNZDl0tbEdWh7qHFE1sHUJiV9/rQgmurbUrbgoCjGwpd/u
         2Q7++tIUYo+bXAsQA8TspGZrXMzt7KHRQeMY/jWC0AY/4nEVhO4092qkQY5VGK1Liexf
         vOu6hlbvnhHtt8AY3jlkJ8q7MIxEu3DbcnmejNG8v9cjm2EAqH7Zc2arlcPDIgg8JeER
         MQF83VB5sVcYArg/ySlbeTTGH3YXtOLU3jNXJBs0WiD2n3sH3+mW47tl2Fi8MvP/SWlD
         qLSgGtAc0chcbz3w+f4y8ihVTeFe1bWRD96HT6EVzcgNcs2NbVJQc+hAn4TlT4vSGpOg
         6aFg==
X-Gm-Message-State: AOAM531hvBpRbXybZ7GtmqgX3QyXr4tL+Df2XXVU9XU4BStK+nc+JdCY
        Ekrhs7BSs4iH6VAjiGUWp2XW1Q==
X-Google-Smtp-Source: ABdhPJzcSuVd5EKuegyFoECLTECw+XVrU3oGg2JgEPOULB1PJIRjyod1eDFI+AzY3oyfk3jejia+gQ==
X-Received: by 2002:a05:6a00:1681:b0:46f:6fc0:e515 with SMTP id k1-20020a056a00168100b0046f6fc0e515mr10224885pfc.11.1637187949498;
        Wed, 17 Nov 2021 14:25:49 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id l28sm582029pgu.45.2021.11.17.14.25.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 14:25:48 -0800 (PST)
Date:   Wed, 17 Nov 2021 22:25:45 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: MMU: update comment on the number of page role
 combinations
Message-ID: <YZWBaW6P+TBKy9ez@google.com>
References: <20211116101114.665451-1-pbonzini@redhat.com>
 <85599dcde5c8c6b74437fac28ebb62c38dafc6a8.camel@redhat.com>
 <42866023-7380-823d-c4c1-2fbf7b5d9527@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <42866023-7380-823d-c4c1-2fbf7b5d9527@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 16, 2021, Paolo Bonzini wrote:
> On 11/16/21 12:07, Maxim Levitsky wrote:
> > > - * But, even though there are 18 bits in the mask below, not all
> > > combinations
> > > + * But, even though there are 20 bits in the mask
> > > below, not all combinations
> > I to be honest counted 19 bits there (which includes the 'smm' bit),
> > but I might have made a mistake. I do wonder maybe it is better to
> > just remove that comment with explicit number?
> 
> Yes, they are 19.  But the explicit number is there to guide in

No, there are 18 from a gfn_track perspective.  "smm" isn't counted because it's
in a separate memslot address space.  The "mask below" is definitely vague on that
point though.

> understanding how 19 goes down to 14 combinations.
> 
> Here is a better writeup:
> 
>  *   - invalid shadow pages are not accounted, so the bits are effectively 18
>  *   - quadrant will only be used if gpte_is_8_bytes is zero (non-PAE paging);
>  *     execonly and ad_disabled are only used for nested EPT which has
>  *     gpte_is_8_bytes=1.  Therefore, 2 bits are always unused.
>  *   - the 4 bits of level are effectively limited to the values 2/3/4/5,
>  *     as 4k SPs are not tracked (allowed to go unsync).  In addition non-PAE
>  *     paging has exactly one upper level, making level effectively redundant
>  *     when gpte_is_8_bytes=0.
>  *   - on top of this, smep_andnot_wp and smap_andnot_wp are only set if cr0_wp=0,
>  *     therefore these three bits only give rise to 5 possibilities.
> 
> FWIW, the full count becomes 6400 unless I screwed up the math.

Which is "in the neighborhood of 2^13" :-)
