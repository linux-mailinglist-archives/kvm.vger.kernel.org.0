Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84EB06AA0E5
	for <lists+kvm@lfdr.de>; Fri,  3 Mar 2023 22:12:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231545AbjCCVME (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Mar 2023 16:12:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231243AbjCCVMC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Mar 2023 16:12:02 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84BCD13D53
        for <kvm@vger.kernel.org>; Fri,  3 Mar 2023 13:12:01 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id n6so4105990plf.5
        for <kvm@vger.kernel.org>; Fri, 03 Mar 2023 13:12:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1677877921;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=jiz5WT7l7Qd+EJQ8w7zmJHS8ZjJcNpTQcUdOcGsqFI0=;
        b=OmvECEZ+JoltI9GrE46Bi7RUSqgD+rDLmgEmT4g23qe1TbAZhuoZ6ss+fLcUnglIY9
         UEiXr8uMX9cpjd7Lk4PdCos3ByDnHDkoP1fUSUem8gwNViAzHgMyL/KAVcobVZ4cK0/V
         HZWKy2cncqfbNrrBFhuqJ70j7O8/EQaKSslg8hv5cTyD+z8pChAXqy9VRJpbQAfyjIdj
         dxsU9zfbiQN34vp0ydEl+8dwkAiP+oiCDUymhSJxCkWGGYAhNrOceb4FZPFJJx1QDZkW
         OKMTGqE8jR0+VF1xFMDAFvAB/JI/ZMN8NPvPgX2T9+I1nzihzndq9VBJpUdrDv2npb0l
         NRZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677877921;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jiz5WT7l7Qd+EJQ8w7zmJHS8ZjJcNpTQcUdOcGsqFI0=;
        b=21UPdytc/ivXlh8WIU2/K7qQLmZMMiitOLniyCpg7XG2qm00umWKvEol1xgLbsemvh
         u4a3URNXTwMI4dsemKPTN7g7dwZ3DUdqcuDMvOHfbc2Wg2NfeGml4F1LWKBCZMG75FLT
         61d9yDrScYCOSmqAe9ChG1+5SEZebwcoUo7kp3r4F4oPjfOobWMD/RIV5ciaBPqkoEqw
         3OaxrxL5wh0z0RMPf5qreEuEsqBKH1Oe7YJWVDpQ8oyj1T2FnCIK9s8yrkkhZtbrsmXj
         YCeuckKcKtJB+WBJc5km9c2jeh5I2xQMxBUNRIB9rzLetIagpZkCddWz10J1XSAErnYI
         FeTw==
X-Gm-Message-State: AO0yUKUFox+Fb2N6MHqpuzNAsuRiLIOMil2hkavKDllxemAgWijcrs1N
        sdJcnDw/an1F7G2xl98ucASUIg==
X-Google-Smtp-Source: AK7set/yHgBQ7wuinJzurGv0pCV1C6gmM+tgloQgl/QyzPi1spMEn3wjQ77JVEaEsqCbC1E3bC060A==
X-Received: by 2002:a17:902:d50c:b0:199:4d25:6a4d with SMTP id b12-20020a170902d50c00b001994d256a4dmr8804668plg.10.1677877920823;
        Fri, 03 Mar 2023 13:12:00 -0800 (PST)
Received: from google.com (77.62.105.34.bc.googleusercontent.com. [34.105.62.77])
        by smtp.gmail.com with ESMTPSA id j17-20020a170903025100b00189ac5a2340sm1941157plh.124.2023.03.03.13.12.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 13:12:00 -0800 (PST)
Date:   Fri, 3 Mar 2023 21:11:56 +0000
From:   Mingwei Zhang <mizhang@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com,
        seanjc@google.com
Subject: Re: [PATCH v3 8/8] KVM: selftests: Add XCR0 Test
Message-ID: <ZAJinCYCSwkippR/@google.com>
References: <20230224223607.1580880-1-aaronlewis@google.com>
 <20230224223607.1580880-9-aaronlewis@google.com>
 <ZAEIPm05Ev12Mr0l@google.com>
 <CAAAPnDF=upv3Un4VTrTsGsVY6-0Q9TkOEwjwhE0j0OewYKMx_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAAPnDF=upv3Un4VTrTsGsVY6-0Q9TkOEwjwhE0j0OewYKMx_w@mail.gmail.com>
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

On Thu, Mar 02, 2023, Aaron Lewis wrote:
> On Thu, Mar 2, 2023 at 8:34 PM Mingwei Zhang <mizhang@google.com> wrote:
> > > > On Fri, Feb 24, 2023, Aaron Lewis wrote:
> > > Check both architectural rules and KVM's own software-defined rules to
> > > ensure the supported xfeatures[1] don't violate any of them.
> > >
> > > The architectural rules[2] and KVM's rules ensure for a given
> > > feature, e.g. sse, avx, amx, etc... their associated xfeatures are
> > > either all sets or none of them are set, and any dependencies
> > > are enabled if needed.
> > >
> > > [1] EDX:EAX of CPUID.(EAX=0DH,ECX=0)
> > > [2] SDM vol 1, 13.3 ENABLING THE XSAVE FEATURE SET AND XSAVE-ENABLED
> > >     FEATURES
> > >
> > > Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> >
> > Sorry, I did not get the point of this test? I run your test in an old
> > (unpatched) kernel on two machines: 1) one with AMX and 2) one without
> > it. (SPR and Skylake). Neither of them fails. Do you want to clarify a
> > little bit?
> 
> The only known issue exists on newer versions of the kernel when run
> on SPR.  It occurs after the syscall, prctl (to enable XTILEDATA), was
> introduced.  If you run this test without the fix[1] you will get the
> assert below, indicating the XTILECFG is supported by the guest, but
> XTILEDATA isn't.
> 
> ==== Test Assertion Failure ====
>   x86_64/xcr0_cpuid_test.c:116: false
>   pid=18124 tid=18124 errno=4 - Interrupted system call
>      1 0x0000000000401894: main at xcr0_cpuid_test.c:116
>      2 0x0000000000414263: __libc_start_call_main at libc-start.o:?
>      3 0x00000000004158af: __libc_start_main_impl at ??:?
>      4 0x0000000000401660: _start at ??:?
>   Failed guest assert: !__supported || __supported == ((((((1ULL))) <<
> (18)) | ((((1ULL))) << (17)))) at x86_64/xcr0_cpuid_test.c:72
> 0x20000 0x60000 0x0
> 
> [1] KVM: x86: Clear all supported AMX xfeatures if they are not all set
> https://lore.kernel.org/kvm/20230224223607.1580880-6-aaronlewis@google.com/
> 

Understood. Thanks for reminding me. Yes, without the invocation of
vm_xsave_require_permission(XSTATE_XTILE_DATA_BIT); VM guest will see a
partially enabled feature (XTILECFG without XTILEDATA).

Reviewed-by: Mingwei Zhang <mizhang@google.com>
> >
> >
> > Thanks.
> > -Mingwei
