Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9F6D5F4A51
	for <lists+kvm@lfdr.de>; Tue,  4 Oct 2022 22:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbiJDUau (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Oct 2022 16:30:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbiJDUar (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Oct 2022 16:30:47 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D733B20351
        for <kvm@vger.kernel.org>; Tue,  4 Oct 2022 13:30:42 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id p3-20020a17090a284300b0020a85fa3ffcso8003845pjf.2
        for <kvm@vger.kernel.org>; Tue, 04 Oct 2022 13:30:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=08uJMd5GS1T3NH6xwoEN0ap5kp0EbSoLAb3muRIQ15I=;
        b=mv+Y4xXppd9eGMuQoXg7iJZlZ194U1nj8p17OES6lFGLC+4crEt79+tjhQYRm3IN+3
         wdCUIfEqOXHKMVpHxui+urQokdvVNqgCRs/4DesqnFLYqgdgahzPFlXu1lwp/0hEXdqA
         b/gmVOazeW/WyHYyRW6Psz5YNbQVHksj/WPoeCCDZBWLDQ41yUl04pUDV9SUnZPVuIfK
         N29M1gl475uhREm7z50T4oYJhGSSccWS2+QoUuN2VgE1vMtS+EiQZMVVOC8es8XRPGPQ
         LXVYC3AhMuouqk1QIquHqWjDORDJ3ByJAuUtJ4zZP5fsxCmz1IByx7s5XPeMg8dPQKWQ
         6Ibw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=08uJMd5GS1T3NH6xwoEN0ap5kp0EbSoLAb3muRIQ15I=;
        b=r1CZjfbrdll5ONTqQ4dtWSz2DLNPNkkwwSCBfB5rCyb51S1J20AcwLbEi8oA8PTPL1
         r0hPhAKBmDGN6P5SDRtx8vWhxDl6kB8eujKPWhfjY05rmnN3IN4MICRO2zSl23szgIFW
         YdOES/e8L+bY9VC3MPfp5/Zx/PNjMCsfnvqmaZmDDFMCXl0blIjrsvLeek3RntimlB/+
         ehstvNQiiioErsSj3ZSbLVkgDkK/h7IJETHOnz61Vd4BEwLvDAHORKI+k/pQHo7PbYtq
         idmAGuJCyqaJ7//kWnLlMoNZDcgIrQYV7YulO8l5GLGpya8wgjiMDmWi5lPGIqGW4FC9
         12rw==
X-Gm-Message-State: ACrzQf2fr6VdWgr+THa3dTohCYlmk7EfPZ18G4epMQqloz5wF2M/wtE5
        KcZkt3FeHufC3itq79gtuhAG6Q==
X-Google-Smtp-Source: AMsMyM6fOK2cD00UMrYFx2gx36+YHKWX2+AtXIeYhA0Vrhq/h78bpuTHQEBeZ2Ki0Qmv555UKn5AQA==
X-Received: by 2002:a17:902:e951:b0:178:93cf:3ebe with SMTP id b17-20020a170902e95100b0017893cf3ebemr28786744pll.74.1664915442318;
        Tue, 04 Oct 2022 13:30:42 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id u5-20020a170902e80500b00177faf558b5sm9080524plg.250.2022.10.04.13.30.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Oct 2022 13:30:41 -0700 (PDT)
Date:   Tue, 4 Oct 2022 20:30:37 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Colton Lewis <coltonlewis@google.com>,
        Peter Xu <peterx@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 0/4] KVM: selftests: Fix and clean up emulator_error_test
Message-ID: <YzyX7XVMdl8SOFfs@google.com>
References: <20220929204708.2548375-1-dmatlack@google.com>
 <Yztw5p+Y5oyJElH2@google.com>
 <CALzav=foJLfym8uJ88gzaHDtAdn3ivFFr7mvQpm_4ePQVMGORg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzav=foJLfym8uJ88gzaHDtAdn3ivFFr7mvQpm_4ePQVMGORg@mail.gmail.com>
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

On Tue, Oct 04, 2022, David Matlack wrote:
> On Mon, Oct 3, 2022 at 4:31 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Thu, Sep 29, 2022, David Matlack wrote:
> > > Miscellaneous fixes and cleanups to emulator_error_test. The reason I
> > > started looking at this test is because it fails when TDP is disabled,
> > > which pollutes my test results when I am testing a new series for
> > > upstream.
> >
> > This series defeats the (not well documented) purpose of emulator_error_test.  The
> > test exists specifically to verify that KVM emulates in response to EPT violations
> > when "allow_smaller_maxphyaddr && guest.MAXPHYADDR < host.MAXPHADDR".
> 
> I thought that might have been the case before I sent this series, but
> I could not (and still can't) find any evidence to support it. The
> commit message and comment at the top of the test all indicate this is
> a test for KVM_CAP_EXIT_ON_EMULATION_FAILURE. What did I miss?

Being in the general vicinity when the test was written?  :-)

> Either way, I think we want both types of tests.  In v2 how about I split out:
> 
>  (1) exit_on_emulation_failure_test.c: Test that emulation failures
> exit to userspace when the cap is enabled, i.e. what
> emulator_error_test does by the end of this series.
>  (2) smaller_maxphyaddr_emulation_test.c: Test the interaction of
> allow_smaller_maxphyaddr and instruction emulation. i.e. what
> emulator_error_does at the start of this series plus your suggestions.
> 
> The main benefit of splitting out (1) is to test
> KVM_CAP_EXIT_ON_EMULATION_FAILURE independent of
> allow_smaller_maxphyaddr, since allow_smaller_maxphyaddr is not
> enabled by default.

Works for me.
