Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C1E75965A4
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 00:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237617AbiHPWuR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 18:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbiHPWuQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 18:50:16 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8594480363
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 15:50:15 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id 17so10528649pli.0
        for <kvm@vger.kernel.org>; Tue, 16 Aug 2022 15:50:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc;
        bh=lxi/vAariJE1sg7X2NAbPSXRvY6XlzqXUDuiJ4FywUM=;
        b=srjIKxpMYLsc9nBsoCuHYQVpVj3HoFK/kUBPyH3tI0pplhm6/4YJbGOqlCGdnw7naW
         2kfOTBEsOzjQVBOqnOYQdIwe2bAFBE3uItnRLoXFRaR7Gp7npw3I0KIvrtjc8kns+4JL
         lyejfyyc4YeIlWAVOVDL36cxcOAURUEXKJV9XGgz2/8GICS3DVeFdwok9wHo4st2rQA8
         ZKijs6OdUAE1jzh20ITPH7eWDdiatchxCVB4WL9/WQ220p1+3t2bpJqTqK0qiAJPet4c
         ODHm/LvJQ7PaY403tT+yBatXeH6ke7hkf2QBEzI+YEJV5sAOO0m1rc2tUCRd9naFIBN3
         UCwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=lxi/vAariJE1sg7X2NAbPSXRvY6XlzqXUDuiJ4FywUM=;
        b=sxETxr5U4VXgO4Ai6cd9t+nSlKR6/N5zKr0IAMB3mgC0eR6Qxhpr/QsOhlgLH+rLDi
         RTQK/n6GLFoN4Fzuk6EW0sPC2Rci1VX+dVO1I8g+mZ83XI2vMlHopxszXOFsDbJBZlP/
         4QGISH+O122q1a99/cQuOVBtBkfqG62/A/4fsWz8K+KIXBrTh2WravIYtwCmisrPmpza
         rtCNTNLtP+YxlrW8kYBItLFaEfAs9/AGcIQKdL1tLcO/+nxNtD3LhwngDmfcB40uEL/6
         D3eu4u8pXfcEWrUW4rvAjNLlhE2WIK7jiTTp/72v8VNRNa52WPCRcGTvDU3V2/uH6hyb
         m+3w==
X-Gm-Message-State: ACgBeo0jQqDy5qVr1Ja5u6Z0v0x6bp03GPSbjJkccbcuGEbUBOcMK7Xp
        LlACfFZMTMBLDijpNjJouHaqUe2AA+MrPQ==
X-Google-Smtp-Source: AA6agR6lrLa/VTTWTVsaYcQ9lc0l+hHm5UW6hui2yH2DpmlmUa0dnx9RXcqBeAZzit4A2fYF/k1LMQ==
X-Received: by 2002:a17:903:50e:b0:170:d829:b3bb with SMTP id jn14-20020a170903050e00b00170d829b3bbmr23470026plb.93.1660690214966;
        Tue, 16 Aug 2022 15:50:14 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 13-20020a630f4d000000b00401a9bc0f33sm8025747pgp.85.2022.08.16.15.50.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 15:50:14 -0700 (PDT)
Date:   Tue, 16 Aug 2022 22:50:10 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, vkuznets@redhat.com
Subject: Re: [PATCH v2 1/9] KVM: x86: check validity of argument to
 KVM_SET_MP_STATE
Message-ID: <YvwfIgoN4a1xOJL/@google.com>
References: <20220811210605.402337-1-pbonzini@redhat.com>
 <20220811210605.402337-2-pbonzini@redhat.com>
 <26f6e26110b99e0a8cace173a221694d4e94cc1c.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <26f6e26110b99e0a8cace173a221694d4e94cc1c.camel@redhat.com>
X-Spam-Status: No, score=-14.4 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 15, 2022, Maxim Levitsky wrote:
> On Thu, 2022-08-11 at 17:05 -0400, Paolo Bonzini wrote:
> > An invalid argument to KVM_SET_MP_STATE has no effect other than making the
> > vCPU fail to run at the next KVM_RUN.  Since it is extremely unlikely that
> > any userspace is relying on it, fail with -EINVAL just like for other
> > architectures.
> > 
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > ---
> >  arch/x86/kvm/x86.c | 20 +++++++++++++++++---
> >  1 file changed, 17 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 132d662d9713..c44348bb6ef2 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -10653,7 +10653,8 @@ static inline int vcpu_block(struct kvm_vcpu *vcpu)
> >         case KVM_MP_STATE_INIT_RECEIVED:
> >                 break;
> >         default:
> > -               return -EINTR;
> > +               WARN_ON(1);
> 
> Very small nitpick: Maybe WARN_ON_ONCE after all? 

+1, I don't think warning multiple times would help triage/debug, and this seems
like something that will fire a lot if it fires at all.
