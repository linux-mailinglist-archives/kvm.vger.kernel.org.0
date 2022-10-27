Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4CEA61007B
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 20:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236175AbiJ0Sln (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 14:41:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235854AbiJ0Sll (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 14:41:41 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 027D0A471
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 11:41:40 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id m6-20020a17090a5a4600b00212f8dffec9so2320991pji.0
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 11:41:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=q/oe30J3Xbt/xMVtG8knGn4ud4L0U9M8wyJEe6bf3h0=;
        b=sVeCiO1MTVNNLOxu9C5qGd9VqPTCfHiU2QbcXoELnTEuYZTTMu+bNeRz4c1Z+iWFXu
         5L8RPMrIf0MoJydg60Xceqv78LXNg7GSxqOUXXNDxZoUFojVisWzpAZJdaqt5w4Pd4pG
         0WTMXdrw3jHgMf5Nkr4JZxkndHs3iUNPtxwVcvRLitqCmzo9mO7rbOYUTnC93awz/V/P
         rbmVV/l7xjvgjQE2ARqSGdCucug+L4J41vdNVkTvJujQ7FQZSa1jyBRSNN0yIwqzLQpc
         R8VYXSQvHpdgSDqZYlZxCRW6W2QvSyIG902NChBcJuuRG1igdU2qYFjM2SwY2DoWHYKV
         LuwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q/oe30J3Xbt/xMVtG8knGn4ud4L0U9M8wyJEe6bf3h0=;
        b=UqJq4y+SdlZ4ZNPWuIW/iVnfJc8p7eZAKFnLCA2UqYIod/0vhXerEucbwKIEMi6hOr
         iBrK5d0UsNNAeXd5DU7CPzS2yc0M4jfg8P5wlxNL69NKpJzqZSoln13SThssoKc399X5
         o45kZ+JIS1UbWD0lvWJy3CW95dgk6BHtZUUzT1oLw1aO+7YYaH06jQcemeS1TR6UXZ0l
         uePkUH2XtUkClKdI6ia83KOKccw19l21a2TdSps6KuE94n1RJIisQ1H/Sq7ojn7k1BSw
         cD0SeLqSE8xVC135SXrvfQQ1slTXpcV3p2fuXyzkwaPWJ6nhFk49OKhMr9Wleg8BxrqC
         dJRA==
X-Gm-Message-State: ACrzQf28tJVGC6Q2Gk8B68IjaOj4XLa3ymjneoYuwyl3oHHhWwoAuD2S
        yCKGFL3B5KS9dOu6ge6RCOXmvQ==
X-Google-Smtp-Source: AMsMyM7wbOQl+IyFTEfxWURsExnivMmEskJhRPys8T/B24JENr669TCP/D1XWBosA0WJ6nQwbn5Iow==
X-Received: by 2002:a17:902:e5c6:b0:185:4bbd:17ce with SMTP id u6-20020a170902e5c600b001854bbd17cemr51703908plf.132.1666896100319;
        Thu, 27 Oct 2022 11:41:40 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id s3-20020a625e03000000b0056286c552ecsm1466317pfb.184.2022.10.27.11.41.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 11:41:39 -0700 (PDT)
Date:   Thu, 27 Oct 2022 18:41:36 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Cathy Avery <cavery@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 16/16] add IPI loss stress test
Message-ID: <Y1rQ4IPX4o9f/Oop@google.com>
References: <20221020152404.283980-1-mlevitsk@redhat.com>
 <20221020152404.283980-17-mlevitsk@redhat.com>
 <Y1GuXoYm6JLpkUvq@google.com>
 <d20ce69105402e4adc9ba6cb2c922fa2653bc80a.camel@redhat.com>
 <Y1bJMF7HV4QesDsl@google.com>
 <df085771c95517538f6056adfe6f5f656de5d2be.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df085771c95517538f6056adfe6f5f656de5d2be.camel@redhat.com>
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

On Thu, Oct 27, 2022, Maxim Levitsky wrote:
> On Mon, 2022-10-24 at 17:19 +0000, Sean Christopherson wrote:
> > That doesn't (and shouldn't) wake the vCPU from the guest's perspective.  If/when
> > userspace calls KVM_RUN again, the vCPU's state should still be KVM_MP_STATE_HALTED
> > and thus KVM will invoke vcpu_block() until there is an actual wake event.
> 
> Well HLT is allowed to do suprious wakeups so KVM is allowed to not do it correclty,

I suspect the above "HLT is allowed to do spurious wakeups" is a typo, but in case
it's not, the SDM says:

  An enabled interrupt (including NMI and SMI), a debug exception, the BINIT# signal,
  the INIT# signal, or the RESET# signal will resume execution.

and the APM says:

  Execution resumes when an unmasked hardware interrupt (INTR), non-maskable
  interrupt (NMI), system management interrupt (SMI), RESET, or INIT occurs.

I.e. resuming from HLT without a valid wake event is a violation of the x86 architecture.

> > > In fact I'll just do it - just need to pick some open source PRNG code.
> > > Do you happen to know a good one? Mersenne Twister? 
> > 
> > It probably makes sense to use whatever we end up using for selftests[*] in order
> > to minimize the code we have to maintain.
> > 
> > [*] https://lore.kernel.org/all/20221019221321.3033920-2-coltonlewis@google.com
> 
> Makes sense. I'll then just take this generator and adopt it to the kvm unit tests.
> Or do you want to actually share the code? via a kernel header or something?

Sadly, just copy+paste for now.  It'd be nice to share code, e.g. for the myriad
X86_FEATURE_* flags, but's a separate problem.

> > > That is the problem - the delay is just in TSC freq units, and knowing TSC freq
> > > for some reason on x86 is next to impossible on AMD
> > 
> > Ah, delay() takes the number cycles.  Ugh.
> > 
> > We should fix that, e.g. use the CPUID-provided frequency when possible (KVM should
> > emulate this if it doesn't already), and then #define an arbitrary TSC frequency as
> > a fall back so that we can write readable code, e.g. 2.4Ghz is probably close enough
> > to work.
> 
> KVM doesn't emulate the Intel's specific way of reporting TSC freq on AMD.
> In some sense this is wrong to do as it is Intel specific.
> 
> I do think that it is a great idea to report the TSC freq via some KVM specific MSR.
> That might though open a pandora box in regard to migration.

Heh, yeah, the Hyper-V TSC stuff is rather ugly.

> I don't like the 2.4Ghz idea at all - it is once again corner cutting. Its true
> that most code doens't need exact delay, not to mention that delay is never going
> to be exact, but once you expose (nano)second based interface, test writers
> will start to use it, and then wonder why someone hardcoded it to 2.4 GHz.a

True.  A really crazy/bad idea would be to get APERF/MPERF from /dev/cpu/0/msr
in the run script and somehow feed the host TSC into KUT :-)
