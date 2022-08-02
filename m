Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 268C9587A13
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 11:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235988AbiHBJuB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 05:50:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236220AbiHBJt6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 05:49:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 077E14AD7A
        for <kvm@vger.kernel.org>; Tue,  2 Aug 2022 02:49:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659433794;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=qILDvFq0JE1nYEx2OKXCR/KNctto2Ey2a6Aj4h5FseE=;
        b=dUg+Vv4WhkAeFq6tCwx/fCuZ9pw0c4hpQNlFtGVgu3z7WCXbzj52MaylYuUPfpRL0C9xl4
        ayWiJPlUorMHKd9raxZjcrpdPEhhNMilr96rukPKrUKXztKlpBhXHiT/bL53VnevltSqMQ
        dEby+upaXUDGnt22Qh6hcdgnbynC7Rc=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-673-R-6ShOiFM_qnD7YkuQfObw-1; Tue, 02 Aug 2022 05:49:51 -0400
X-MC-Unique: R-6ShOiFM_qnD7YkuQfObw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4A728381078D;
        Tue,  2 Aug 2022 09:49:50 +0000 (UTC)
Received: from redhat.com (unknown [10.33.36.227])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EC53E2166B26;
        Tue,  2 Aug 2022 09:49:47 +0000 (UTC)
Date:   Tue, 2 Aug 2022 10:49:45 +0100
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
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
Subject: Re: [PATCH v1 00/40] TDX QEMU support
Message-ID: <YujzOUjMbBZRi/e6@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20220802074750.2581308-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220802074750.2581308-1-xiaoyao.li@intel.com>
User-Agent: Mutt/2.2.6 (2022-06-05)
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 02, 2022 at 03:47:10PM +0800, Xiaoyao Li wrote:
> This is the first version that removes RFC tag since last RFC gots
> several acked-by. Hope more people and reviewers can help review it.
> 
> 
> This patch series aims to enable TDX support to allow creating and booting a
> TD (TDX VM) with QEMU. It needs to work with corresponding KVM patch [1].
> TDX related documents can be found in [2].
> 
> this series is also available in github:
> 
> https://github.com/intel/qemu-tdx/tree/tdx-qemu-upstream-v1
> 
> To boot a TDX VM, it requires several changes/additional steps in the flow:
> 
>  1. specify the vm type KVM_X86_TDX_VM when creating VM with
>     IOCTL(KVM_CREATE_VM);
>  2. initialize VM scope configuration before creating any VCPU;
>  3. initialize VCPU scope configuration;
>  4. initialize virtual firmware (TDVF) in guest private memory before
>     vcpu running;
> 
> Besides, TDX VM needs to boot with TDVF (TDX virtual firmware) and currently
> upstream OVMF can serve as TDVF. This series adds the support of parsing TDVF,
> loading TDVF into guest's private memory and preparing TD HOB info for TDVF.
> 
> [1] KVM TDX basic feature support v7
> https://lore.kernel.org/all/cover.1656366337.git.isaku.yamahata@intel.com/
> 
> [2] https://www.intel.com/content/www/us/en/developer/articles/technical/intel-trust-domain-extensions.html
> 
> == Limitation and future work ==


> - CPU model
> 
>   We cannot create a TD with arbitrary CPU model like what for non-TDX VMs,
>   because only a subset of features can be configured for TD.
>   
>   - It's recommended to use '-cpu host' to create TD;
>   - '+feature/-feature' might not work as expected;
> 
>   future work: To introduce specific CPU model for TDs and enhance +/-features
>                for TDs.

Which features are incompatible with TDX ?

Presumably you have such a list, so that KVM can block them when
using '-cpu host' ? If so, we should be able to sanity check the
use of these features in QEMU for the named CPU models / feature
selection too.


With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

