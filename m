Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09AC0589FFA
	for <lists+kvm@lfdr.de>; Thu,  4 Aug 2022 19:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239229AbiHDRmT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Aug 2022 13:42:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232813AbiHDRmR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Aug 2022 13:42:17 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A91C1758A
        for <kvm@vger.kernel.org>; Thu,  4 Aug 2022 10:42:16 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id p18so479312plr.8
        for <kvm@vger.kernel.org>; Thu, 04 Aug 2022 10:42:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=I+2klbPtMg8JDmNlmkLOfkLK7UdOD2bPaKewB5S493I=;
        b=JWRc8lpzmI1XPDrZdYpOkOaHGJM9cuJ6S36qN6rCIkka1D+pCnjBmWL2QpgE58pchQ
         Y8hetXvTbbN4FGz9bTRUf5auA47ghrM+ozLswJ5TfKY7AoeM1GvCh8KepCnQJXvTlGeL
         c91qNyGukSxvdUOhw0mStLikLlq5FvEcWa12peKE/HYibXsvRKJkjKLn5fuKHI8e14TJ
         tJX4azNySy7c3fVDb1DtoDw1GCvA703nGeQMJ+74ydgW6ujkD/Zg2ho+694ShFqYEw4F
         1lHb1H7JbUkptA0PWqduIT+12ebhOD4kZWJ6JIZ1GPyD9FD8Mx0K6fzBX28aYJa6jikG
         p+ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=I+2klbPtMg8JDmNlmkLOfkLK7UdOD2bPaKewB5S493I=;
        b=gVNxMSvDfMvw/AVZRW7hV1OJz9DWCU/LtXUmbAxodZC2NnCUehu/qbiHFoijvEJLy2
         v0NZOdAnup8fNcva+mHeXCeGjm5SkzrnFJSZfD3W7lnGN+8GfEb/pZfTPiqr6YosNW/F
         4rR2vh/sKJibnhqRuc2GdIXnKvnPCwWnjZaSQbK7t1TIZzbiKd2SsH0AFZ2PhNCERxmW
         cQafM+s2TcUgOqO/tv/uNvZkBuqF72D5iVdlj2rFCFVbgSPDlIPbpWw/yGaEXrrTxeD1
         F9Bd41NSTZHwGJnQ7rK4vr3Unl1jqU+jGzquZcHhBtnNBucTslNb+rJWophEP7GcwhqZ
         mYJw==
X-Gm-Message-State: ACgBeo3nVPcOwagSKlgBwUXQp41wfUwEiLNU7Znxzz8AaDnfUodFPZ61
        fiY0WY/Mya+FSi+5QjvmMX/SOw==
X-Google-Smtp-Source: AA6agR5EqUfD+yYAIdMZCFrx/O7afJKPSNvQUKx2i/l+0HuCml4gPIS9of9x6dhqZTYLQotLOS6qKg==
X-Received: by 2002:a17:902:cec8:b0:16f:8081:54bc with SMTP id d8-20020a170902cec800b0016f808154bcmr2833466plg.139.1659634935635;
        Thu, 04 Aug 2022 10:42:15 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id w79-20020a627b52000000b0052c0a9234e0sm1359044pfc.11.2022.08.04.10.42.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Aug 2022 10:42:15 -0700 (PDT)
Date:   Thu, 4 Aug 2022 17:42:11 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Dave Young <ruyang@redhat.com>,
        Xiaoying Yan <yiyan@redhat.com>,
        David Woodhouse <dwmw@amazon.co.uk>, stable@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: revalidate steal time cache if MSR value
 changes
Message-ID: <YuwE83glEswjkTq0@google.com>
References: <20220804132832.420648-1-pbonzini@redhat.com>
 <87v8r8yuvo.fsf@redhat.com>
 <Yuv9BoFtf9q3Ew5G@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yuv9BoFtf9q3Ew5G@work-vm>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 04, 2022, Dr. David Alan Gilbert wrote:
> * Vitaly Kuznetsov (vkuznets@redhat.com) wrote:
> > Paolo Bonzini <pbonzini@redhat.com> writes:
> > > -		gfn_t gfn = vcpu->arch.st.msr_val & KVM_STEAL_VALID_BITS;
> > > -
> > >  		/* We rely on the fact that it fits in a single page. */
> > >  		BUILD_BUG_ON((sizeof(*st) - 1) & KVM_STEAL_VALID_BITS);
> > >  
> > > -		if (kvm_gfn_to_hva_cache_init(vcpu->kvm, ghc, gfn, sizeof(*st)) ||
> > > +		if (kvm_gfn_to_hva_cache_init(vcpu->kvm, ghc, gpa, sizeof(*st)) ||
> > 
> > (It would be nice to somehow get at least a warning when 'gfn_t' is used
> > instead of 'gpa_t' and vice versa)
> 
> Can't sparse be taught to do that?

Hmm, it probably could, but the result would likely be a mess.  E.g. anything that
shifts the GPA on-demand will require explicit casts to make sparse happy.

This particular case is solvable without sparse, e.g. WARN if gpa[11:0]!=0, or
even better rework the function to actually take a @gfn and then WARN if the
incoming gfn would yield an illegal gpa.
