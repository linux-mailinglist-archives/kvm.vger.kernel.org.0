Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE18F587A0C
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 11:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234134AbiHBJsF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 05:48:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232724AbiHBJsD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 05:48:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 05D9DF67
        for <kvm@vger.kernel.org>; Tue,  2 Aug 2022 02:48:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659433680;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=ONZlfw1AoIcsZS1rzt00IxbQ4/kHUOV+iTn1DCGkU4k=;
        b=Wic6pYqQ6UHA7K55PFzGQMX8xxxHi1UP2hN7MrQGXPK12H4yk+WT3iLwQ36VZVVO5t7UU/
        Rf52pgapQl00OzKoffkQ1lcJxPHKYacsXG7gx+GuLv8NdVWFMieJqznLm4DPVIqszutoKl
        eQ5SoIDG0eAHswShhbaeXPNJ+uLZ4uw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-631-JbMAKCeAPt2-Cx7gkzyOdg-1; Tue, 02 Aug 2022 05:47:57 -0400
X-MC-Unique: JbMAKCeAPt2-Cx7gkzyOdg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5721C811E75;
        Tue,  2 Aug 2022 09:47:57 +0000 (UTC)
Received: from redhat.com (unknown [10.33.36.227])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0CB80141513D;
        Tue,  2 Aug 2022 09:47:53 +0000 (UTC)
Date:   Tue, 2 Aug 2022 10:47:52 +0100
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
Subject: Re: [PATCH v1 01/40] *** HACK *** linux-headers: Update headers to
 pull in TDX API changes
Message-ID: <YujyyAeHMJaWOtR2@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20220802074750.2581308-1-xiaoyao.li@intel.com>
 <20220802074750.2581308-2-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220802074750.2581308-2-xiaoyao.li@intel.com>
User-Agent: Mutt/2.2.6 (2022-06-05)
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 02, 2022 at 03:47:11PM +0800, Xiaoyao Li wrote:
> Pull in recent TDX updates, which are not backwards compatible.
> 
> It's just to make this series runnable. It will be updated by script
> 
> 	scripts/update-linux-headers.sh
> 
> once TDX support is upstreamed in linux kernel.

I saw a bunch of TDX support merged in 5.19:

commit 3a755ebcc2557e22b895b8976257f682c653db1d
Merge: 5b828263b180 c796f02162e4
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon May 23 17:51:12 2022 -0700

    Merge tag 'x86_tdx_for_v5.19_rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
    
    Pull Intel TDX support from Borislav Petkov:
     "Intel Trust Domain Extensions (TDX) support.
    
      This is the Intel version of a confidential computing solution called
      Trust Domain Extensions (TDX). This series adds support to run the
      kernel as part of a TDX guest. It provides similar guest protections
      to AMD's SEV-SNP like guest memory and register state encryption,
      memory integrity protection and a lot more.
    
      Design-wise, it differs from AMD's solution considerably: it uses a
      software module which runs in a special CPU mode called (Secure
      Arbitration Mode) SEAM. As the name suggests, this module serves as
      sort of an arbiter which the confidential guest calls for services it
      needs during its lifetime.
    
      Just like AMD's SNP set, this series reworks and streamlines certain
      parts of x86 arch code so that this feature can be properly
      accomodated"


Is that sufficient for this patch, or is there more pending out of
tree that QEMU still depends on ?

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

