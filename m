Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C6845A2098
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 07:57:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244885AbiHZF5X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 01:57:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244965AbiHZF5U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 01:57:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ECA8D0773
        for <kvm@vger.kernel.org>; Thu, 25 Aug 2022 22:57:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661493437;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wnE06a8KiYVsWq/5ALANFSFIHkoMgGuwqp2QjVRQn6Q=;
        b=fWGICmoIsSXbcZpNUWqX0Sc65O86o1dKinUdoVQH9vJOVSq9G0llRJc8Quy3GdMjHQLRyV
        TztDjAtOEfXhGKuwDumN86RdxM9OjX8nX5qkzCcUmRLKPtQ5Rm7MZiVUVflaKz2+lJMp9j
        ipPlqwfj4XlgqknLVPZ8gVeGe6kFcew=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-629-7G3-Qg_aN4mGPR01UVyngw-1; Fri, 26 Aug 2022 01:57:14 -0400
X-MC-Unique: 7G3-Qg_aN4mGPR01UVyngw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A8EE285A589;
        Fri, 26 Aug 2022 05:57:13 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.195.82])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 40C0A40B40C8;
        Fri, 26 Aug 2022 05:57:13 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id 8270B18003AB; Fri, 26 Aug 2022 07:57:11 +0200 (CEST)
Date:   Fri, 26 Aug 2022 07:57:11 +0200
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
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
        kvm@vger.kernel.org, qemu-devel@nongnu.org, seanjc@google.com
Subject: Re: [PATCH v1 15/40] i386/tdx: Add property sept-ve-disable for
 tdx-guest object
Message-ID: <20220826055711.vbw2oovti2qevzzx@sirius.home.kraxel.org>
References: <20220802074750.2581308-1-xiaoyao.li@intel.com>
 <20220802074750.2581308-16-xiaoyao.li@intel.com>
 <20220825113636.qlqmflxcxemh2lmf@sirius.home.kraxel.org>
 <389a2212-56b8-938b-22e5-24ae2bc73235@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <389a2212-56b8-938b-22e5-24ae2bc73235@intel.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

  Hi,
 
> For TD guest kernel, it has its own reason to turn SEPT_VE on or off. E.g.,
> linux TD guest requires SEPT_VE to be disabled to avoid #VE on syscall gap
> [1].

Why is that a problem for a TD guest kernel?  Installing exception
handlers is done quite early in the boot process, certainly before any
userspace code runs.  So I think we should never see a syscall without
a #VE handler being installed.  /me is confused.

Or do you want tell me linux has no #VE handler?

> Frankly speaking, this bit is better to be configured by TD guest
> kernel, however current TDX architecture makes the design to let VMM
> configure.

Indeed.  Requiring users to know guest kernel capabilities and manually
configuring the vmm accordingly looks fragile to me.

Even better would be to not have that bit in the first place and require
TD guests properly handle #VE exceptions.

> This can cause problems with the "system call gap": a malicious
> hypervisor might trigger a #VE for example on the system call entry
> code, and when a user process does a system call it would trigger a
> and SYSCALL relies on the kernel code to switch to the kernel stack,
> this would lead to kernel code running on the ring 3 stack.

Hmm?  Exceptions switch to kernel context too ...

take care,
  Gerd

