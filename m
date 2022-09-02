Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D3B35AA75D
	for <lists+kvm@lfdr.de>; Fri,  2 Sep 2022 07:47:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234890AbiIBFqa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 01:46:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbiIBFq3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 01:46:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 450E571727
        for <kvm@vger.kernel.org>; Thu,  1 Sep 2022 22:46:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662097587;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GQbMdAbOznDhp2gIQyfE7g2JC22UM3Kzh0GxmYb4Rns=;
        b=geNK8+ZlOqGPeNZsDvC4kQnaQVS7KIUWZHbWmcCO54XNkYs0kq7ud+pA3EvEjiln7CSDBy
        J0Vjmznt915e9U44mFUl+0HbToontXwBRLJCDZwL521fyVuoGKpUzAJ7E7A2xAbbg424Zb
        8Zmn0AytGHgGjT1u8mBjIws6BGxKXDY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-192-2SehxyqGP7KfVok80GGkqw-1; Fri, 02 Sep 2022 01:46:24 -0400
X-MC-Unique: 2SehxyqGP7KfVok80GGkqw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 60BB61C04B63;
        Fri,  2 Sep 2022 05:46:23 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.195.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EA2DD2166B2B;
        Fri,  2 Sep 2022 05:46:22 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id 97D1F18003AB; Fri,  2 Sep 2022 07:46:21 +0200 (CEST)
Date:   Fri, 2 Sep 2022 07:46:21 +0200
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
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
Message-ID: <20220902054621.yyffxn2vnm74r2b3@sirius.home.kraxel.org>
References: <20220802074750.2581308-1-xiaoyao.li@intel.com>
 <20220802074750.2581308-16-xiaoyao.li@intel.com>
 <20220825113636.qlqmflxcxemh2lmf@sirius.home.kraxel.org>
 <389a2212-56b8-938b-22e5-24ae2bc73235@intel.com>
 <20220826055711.vbw2oovti2qevzzx@sirius.home.kraxel.org>
 <a700a0c6-7f25-dc45-4c49-f61709808f29@intel.com>
 <YxFv6RglTOY3Pevj@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YxFv6RglTOY3Pevj@google.com>
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 02, 2022 at 02:52:25AM +0000, Sean Christopherson wrote:
> On Fri, Sep 02, 2022, Xiaoyao Li wrote:
> > On 8/26/2022 1:57 PM, Gerd Hoffmann wrote:
> > >    Hi,
> > > > For TD guest kernel, it has its own reason to turn SEPT_VE on or off. E.g.,
> > > > linux TD guest requires SEPT_VE to be disabled to avoid #VE on syscall gap
> > > > [1].
> > > 
> > > Why is that a problem for a TD guest kernel?  Installing exception
> > > handlers is done quite early in the boot process, certainly before any
> > > userspace code runs.  So I think we should never see a syscall without
> > > a #VE handler being installed.  /me is confused.
> > > 
> > > Or do you want tell me linux has no #VE handler?
> > 
> > The problem is not "no #VE handler" and Linux does have #VE handler. The
> > problem is Linux doesn't want any (or certain) exception occurrence in
> > syscall gap, it's not specific to #VE. Frankly, I don't understand the
> > reason clearly, it's something related to IST used in x86 Linux kernel.
> 
> The SYSCALL gap issue is that because SYSCALL doesn't load RSP, the first instruction
> at the SYSCALL entry point runs with a userspaced-controlled RSP.  With TDX, a
> malicious hypervisor can induce a #VE on the SYSCALL page and thus get the kernel
> to run the #VE handler with a userspace stack.
> 
> The "fix" is to use an IST for #VE so that a kernel-controlled RSP is loaded on #VE,
> but ISTs are terrible because they don't play nice with re-entrancy (among other
> reasons).  The RSP used for IST-based handlers is hardcoded, and so if a #VE
> handler triggers another #VE at any point before IRET, the second #VE will clobber
> the stack and hose the kernel.
> v
> It's possible to workaround this, e.g. change the IST entry at the very beginning
> of the handler, but it's a maintenance burden.  Since the only reason to use an IST
> is to guard against a malicious hypervisor, Linux decided it would be just as easy
> and more beneficial to avoid unexpected #VEs due to unaccepted private pages entirely.

Hmm, ok, but shouldn't the SEPT_VE bit *really* controlled by the guest then?

Having a hypervisor-controlled config bit to protect against a malicious
hypervisor looks pointless to me ...

take care,
  Gerd

