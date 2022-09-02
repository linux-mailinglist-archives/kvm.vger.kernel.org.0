Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A67455AA60F
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 04:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233250AbiIBCwe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 22:52:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232291AbiIBCwd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 22:52:33 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF2409E0FC
        for <kvm@vger.kernel.org>; Thu,  1 Sep 2022 19:52:31 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id h188so770925pgc.12
        for <kvm@vger.kernel.org>; Thu, 01 Sep 2022 19:52:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=s3rQHrfdU8nh1CYoZCYjP5wlsTj0Ig8apoM3bdaeWY8=;
        b=l4FgH77M91Dsls606bKNlqhKmTFLRa/6fmGLQbKN6rvA6plI7wuVKSRNRV71nGeR/Z
         KLBLKI+eemZyQR2Q8R6rVbcBwlfkEimagzhqvfc3koYgWDKiuRV471WFwJhj6JCwWs0/
         JBzaPFZki8wRW+Wqq+oH8hLnLzY0xDr12g1JzJqbf7tEWEWRneMbzYUC5nqmk9yNDcXh
         jT7qOCR7UqboOKaJ9NFja9CP0c4k5OJ7ZooYNWAy4tBZXthITMnpq6LGqPvhwBZajbHA
         fIq/96Y3+oBhlr4d3S0Z9PAdV0UhWhErY5fwpSDAppvhzdwi07IuE4Y2XUrScqR5REng
         FPdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=s3rQHrfdU8nh1CYoZCYjP5wlsTj0Ig8apoM3bdaeWY8=;
        b=tj5C7WNwHfD3xchDgSfJp1u8AkefiFvJ0IQgzsscNoiNZFBpWISWCIDbrO1obK5Xgy
         W7CNQIen9aIqXwTvUftqqj4TNKRcfVaAlVJCejdrF+7UPPTjX7NSJukdmwgvkdMiAFrM
         zjIEOxXkyN2RFUyRsgr5Nm8rZEr/l5y62QuB2Hk+jsmetNCtxcO7P0OcqCOGKqZgNiTh
         8+U7eMu41rAznX/ywaDn2Gp0zR1izkd4G4+sxa/HSXk7bL6hL103Yi/VXwDlqN3bnyow
         2qAxXVpWAEtTweopnaokvkRQ/V+HX0Pxml6418Jo/sM4r889jkEK0oWO5snMw5Mn8jHJ
         2MHQ==
X-Gm-Message-State: ACgBeo3dd12Ub/NuWXMBrsVmNUgAbhP916Vj5+WaMAYSNfb6aEMssX12
        /+ZllaxqAQ4ZrS22zY/K2Ui6cA==
X-Google-Smtp-Source: AA6agR5wb5tUcLrahc75HLtJ2gcPpyN2b0NPDyuE0cW5TEZAXhSqlUwzlKq9UWuKaZGoThkMAFTA+w==
X-Received: by 2002:a05:6a00:4147:b0:52d:fe84:2614 with SMTP id bv7-20020a056a00414700b0052dfe842614mr34947193pfb.10.1662087151065;
        Thu, 01 Sep 2022 19:52:31 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id m15-20020a17090a34cf00b001fb35e4044bsm4019628pjf.40.2022.09.01.19.52.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 19:52:29 -0700 (PDT)
Date:   Fri, 2 Sep 2022 02:52:25 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Gerd Hoffmann <kraxel@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Daniel =?iso-8859-1?Q?P=2E_Berrang=E9?= <berrange@redhat.com>,
        Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Connor Kuehl <ckuehl@redhat.com>, erdemaktas@google.com,
        kvm@vger.kernel.org, qemu-devel@nongnu.org
Subject: Re: [PATCH v1 15/40] i386/tdx: Add property sept-ve-disable for
 tdx-guest object
Message-ID: <YxFv6RglTOY3Pevj@google.com>
References: <20220802074750.2581308-1-xiaoyao.li@intel.com>
 <20220802074750.2581308-16-xiaoyao.li@intel.com>
 <20220825113636.qlqmflxcxemh2lmf@sirius.home.kraxel.org>
 <389a2212-56b8-938b-22e5-24ae2bc73235@intel.com>
 <20220826055711.vbw2oovti2qevzzx@sirius.home.kraxel.org>
 <a700a0c6-7f25-dc45-4c49-f61709808f29@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a700a0c6-7f25-dc45-4c49-f61709808f29@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 02, 2022, Xiaoyao Li wrote:
> On 8/26/2022 1:57 PM, Gerd Hoffmann wrote:
> >    Hi,
> > > For TD guest kernel, it has its own reason to turn SEPT_VE on or off. E.g.,
> > > linux TD guest requires SEPT_VE to be disabled to avoid #VE on syscall gap
> > > [1].
> > 
> > Why is that a problem for a TD guest kernel?  Installing exception
> > handlers is done quite early in the boot process, certainly before any
> > userspace code runs.  So I think we should never see a syscall without
> > a #VE handler being installed.  /me is confused.
> > 
> > Or do you want tell me linux has no #VE handler?
> 
> The problem is not "no #VE handler" and Linux does have #VE handler. The
> problem is Linux doesn't want any (or certain) exception occurrence in
> syscall gap, it's not specific to #VE. Frankly, I don't understand the
> reason clearly, it's something related to IST used in x86 Linux kernel.

The SYSCALL gap issue is that because SYSCALL doesn't load RSP, the first instruction
at the SYSCALL entry point runs with a userspaced-controlled RSP.  With TDX, a
malicious hypervisor can induce a #VE on the SYSCALL page and thus get the kernel
to run the #VE handler with a userspace stack.

The "fix" is to use an IST for #VE so that a kernel-controlled RSP is loaded on #VE,
but ISTs are terrible because they don't play nice with re-entrancy (among other
reasons).  The RSP used for IST-based handlers is hardcoded, and so if a #VE
handler triggers another #VE at any point before IRET, the second #VE will clobber
the stack and hose the kernel.

It's possible to workaround this, e.g. change the IST entry at the very beginning
of the handler, but it's a maintenance burden.  Since the only reason to use an IST
is to guard against a malicious hypervisor, Linux decided it would be just as easy
and more beneficial to avoid unexpected #VEs due to unaccepted private pages entirely.
