Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2277C5A834A
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 18:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231926AbiHaQfl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 12:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231724AbiHaQfi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 12:35:38 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C01F5C35E
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 09:35:37 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id x19so13087815pfr.1
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 09:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=aACaOYwjaK/bs9fwI2VTNHaA/NOZ1I7CvfyYxGNhpLU=;
        b=j4g+6dBZqVdNp2C4ziwiEuAYw6KWrNKBFfazO0/nWDNwx6nYFzRv6WyBiqybX7nTc5
         Fi5uh0F34lRD26lgeoecBkcU1fyqspTYW9FrIR8vUjY3RAWkeM5raZzysG7mtV+wXzw6
         b4Pcg8vVt4zcVn8j3unuvBOxyrKBXWo81uNj1h+mkUCVaYeDQlUGGUMCse+V31+kUBHs
         mInU958qZg8J2qJS+/nlNtfh6c1cRACFHcMpvSd/fGJ2DZxKsrcbHOb8Qbb2QwCmTczE
         ocy7tpTF/dpxHLyoRW/DaBZiD0PpYn8mNuCXWUOpRKPri090sS3dwySShwPl1G4loxct
         5v8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=aACaOYwjaK/bs9fwI2VTNHaA/NOZ1I7CvfyYxGNhpLU=;
        b=gp3p5mKXD49rRGVzYtDperfSZxguB9VeT0Y82CHwm5hLdRYqw6amN8SqAEzCHoGB4g
         MZPX7JZHSKmDfJsAZesBBIdWCRkYmK2Dx9q7faLQoYiujcFnt5nlR1PchGcMJvuiLOCc
         Xo9wY9Ax1ASjNPJav7ugkXnCoRnqaWffXzJmNDcRu6r6Ei/ozTJhR3I7OgGN33nuzs6a
         PYVsvFRfpwy5fJSL4wWA5ipr8k7PFWX6AUSyia3F6Z0iWytVPt5OHhdr3BdQgSLr8UfS
         1Yti2i/pJmudvw9xTFcAM4skAUns69q//rGaLcvler3Kq125Wou6gduwg+Lm9t4nptCB
         h0rg==
X-Gm-Message-State: ACgBeo0s0g0Qmz7/j1/nFE+RJRtKufLOgxR/zA3/k+eglVpvYNo5mUfu
        Tcw12rR+wJ4r/G69Zep8cjXimQ==
X-Google-Smtp-Source: AA6agR7z6/HXxsp30lAJFrT2o+SRXJV7qrOwdBOkVeSdamoUEFhrmJ7HNSs0jW3g3goQaWBgcLOBUQ==
X-Received: by 2002:a05:6a00:1307:b0:53a:9663:1bd6 with SMTP id j7-20020a056a00130700b0053a96631bd6mr6014200pfu.55.1661963736839;
        Wed, 31 Aug 2022 09:35:36 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id n15-20020a170902e54f00b0016dbaf3ff2esm6343520plf.22.2022.08.31.09.35.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 09:35:36 -0700 (PDT)
Date:   Wed, 31 Aug 2022 16:35:32 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Subject: Re: [PATCH 06/19] KVM: SVM: Get x2APIC logical dest bitmap from
 ICRH[15:0], not ICHR[31:16]
Message-ID: <Yw+N1BdfSansWh8h@google.com>
References: <20220831003506.4117148-1-seanjc@google.com>
 <20220831003506.4117148-7-seanjc@google.com>
 <7a7827ec2652a8409fccfe070659497df229211b.camel@redhat.com>
 <b660f600ff5f6c107d899ced46c04de3b99c425f.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b660f600ff5f6c107d899ced46c04de3b99c425f.camel@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 31, 2022, Maxim Levitsky wrote:
> On Wed, 2022-08-31 at 09:09 +0300, Maxim Levitsky wrote:
> > On Wed, 2022-08-31 at 00:34 +0000, Sean Christopherson wrote:
> > > When attempting a fast kick for x2AVIC, get the destination bitmap from
> > > ICR[15:0], not ICHR[31:16].  The upper 16 bits contain the cluster, the
> > > lower 16 bits hold the bitmap.
> > > 
> > > Fixes: 603ccef42ce9 ("KVM: x86: SVM: fix avic_kick_target_vcpus_fast")
> > > Cc: Maxim Levitsky <mlevitsk@redhat.com>
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > ---
> > >  arch/x86/kvm/svm/avic.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> > > index 3ace0f2f52f0..3c333cd2e752 100644
> > > --- a/arch/x86/kvm/svm/avic.c
> > > +++ b/arch/x86/kvm/svm/avic.c
> > > @@ -368,7 +368,7 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
> > >  
> > >  		if (apic_x2apic_mode(source)) {
> > >  			/* 16 bit dest mask, 16 bit cluster id */
> > > -			bitmap = dest & 0xFFFF0000;
> > > +			bitmap = dest & 0xFFFF;
> > >  			cluster = (dest >> 16) << 4;
> > >  		} else if (kvm_lapic_get_reg(source, APIC_DFR) == APIC_DFR_FLAT) {
> > >  			/* 8 bit dest mask*/
> > 
> > I swear I have seen a patch from Suravee Suthikulpanit fixing this my mistake, I don't know why it was not
> > accepted upstream.
> 
> This is the patch, which I guess got forgotten.
> 
> https://www.spinics.net/lists/kernel/msg4417427.html

Ah, we just missed it, doubt there's anything more than that to the story.

> Since it is literaly the same patch, you can just add credit to Suravee Suthikulpanit.
> 
> So with the credit added:
> 
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

I'll grab Suravee's patch and added your review.  Thanks!
