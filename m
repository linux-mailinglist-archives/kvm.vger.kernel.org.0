Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 251754E606E
	for <lists+kvm@lfdr.de>; Thu, 24 Mar 2022 09:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348945AbiCXIhJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Mar 2022 04:37:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242408AbiCXIhF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Mar 2022 04:37:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6FBDE9BB94
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 01:35:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648110932;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5AYiOg0g6VI/yAB3L4J0toc2fwKBeYoB1YDFnmEmPSY=;
        b=iwqoIbuHJm6oUxOWlZhOK9qOhOOE3HWPf5/I8djxCz9r5AvRU7gBBxfBQFFQV0qg8LRjFS
        kvD3qOcR06Iw5C3i7Ko045QD/B/GM4GBZzBoGARECTqf/1rH+G9wOEst9r99fcjmLf4PL9
        XevJ1JKFoJyfc4zxVo3vzkvnxYvESgI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-199-44gU_I5ONXODwUpkr3D2fA-1; Thu, 24 Mar 2022 04:35:31 -0400
X-MC-Unique: 44gU_I5ONXODwUpkr3D2fA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AAFFF1C09405;
        Thu, 24 Mar 2022 08:35:30 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.196.67])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 70736401E29;
        Thu, 24 Mar 2022 08:35:30 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id D0DB018000AA; Thu, 24 Mar 2022 09:35:28 +0100 (CET)
Date:   Thu, 24 Mar 2022 09:35:28 +0100
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Connor Kuehl <ckuehl@redhat.com>, isaku.yamahata@intel.com,
        erdemaktas@google.com, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        seanjc@google.com
Subject: Re: [RFC PATCH v3 17/36] pflash_cfi01/tdx: Introduce ram_mode of
 pflash for TDVF
Message-ID: <20220324083528.deoh77e77swf67gb@sirius.home.kraxel.org>
References: <20220317135913.2166202-1-xiaoyao.li@intel.com>
 <20220317135913.2166202-18-xiaoyao.li@intel.com>
 <f418548e-c24c-1bc3-4e16-d7a775298a18@gmail.com>
 <7a8233e4-0cae-b05a-7931-695a7ee87fc9@intel.com>
 <20220322092141.qsgv3pqlvlemgrgw@sirius.home.kraxel.org>
 <YjmXFZRCbKXTkAhN@redhat.com>
 <20220322103518.ljbi4pvghbgjxm7k@sirius.home.kraxel.org>
 <YjmqOolbafWkMEHN@redhat.com>
 <20220322122024.blyut6mnszhyw6hz@sirius.home.kraxel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220322122024.blyut6mnszhyw6hz@sirius.home.kraxel.org>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 22, 2022 at 01:20:24PM +0100, Gerd Hoffmann wrote:
>   Hi,
> 
> > At the time I did try a gross hack that (IIRC) disabled the
> > rom_reset logic, and munged x86_bios_rom_init so that it would
> > force load it straight at the RAM location.
> 
> Sounds reasonable.  The whole rom logic exists to handle resets,
> but with confidential guests we don't need that, we can't change
> guest state to perform a reset anyway ...

Completed, cleaned up a bit, but untested:
  https://git.kraxel.org/cgit/qemu/log/?h=sirius/cc

Any chance you can give this a try?

thanks,
  Gerd

