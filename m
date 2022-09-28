Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 042B45EE400
	for <lists+kvm@lfdr.de>; Wed, 28 Sep 2022 20:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234674AbiI1SMY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Sep 2022 14:12:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234454AbiI1SMW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Sep 2022 14:12:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52C7CD0789
        for <kvm@vger.kernel.org>; Wed, 28 Sep 2022 11:12:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664388738;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=cNfUBfM5k+VGHxWCr84qkrW95eGzYmSzPp620mykmfE=;
        b=ALX/68YhLPitEQB/zpBri8ADjKNOBltFLLWuBFZkmtt8q87VUXR2QlJbYIlq56f6syORPn
        TyJPTt+4mUWSI48r/mNNv+kUOlbfr5vw/whkqZG8j6rgYY8xajstbP4EIcDt16pUcW+SFL
        PRfDBJw5taxUJwUpw9i0F0C/bGrehs0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-316-9_Ze1mxeM3aczndKUOw7jw-1; Wed, 28 Sep 2022 14:12:15 -0400
X-MC-Unique: 9_Ze1mxeM3aczndKUOw7jw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8029E1C06EC9;
        Wed, 28 Sep 2022 18:11:59 +0000 (UTC)
Received: from redhat.com (unknown [10.33.36.68])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E31D12027061;
        Wed, 28 Sep 2022 18:11:55 +0000 (UTC)
Date:   Wed, 28 Sep 2022 19:11:53 +0100
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     qemu-s390x@nongnu.org, qemu-devel@nongnu.org,
        borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com
Subject: Re: [PATCH v9 01/10] s390x/cpus: Make absence of multithreading clear
Message-ID: <YzSOaczjJAgjrHG9@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20220902075531.188916-1-pmorel@linux.ibm.com>
 <20220902075531.188916-2-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220902075531.188916-2-pmorel@linux.ibm.com>
User-Agent: Mutt/2.2.6 (2022-06-05)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 02, 2022 at 09:55:22AM +0200, Pierre Morel wrote:
> S390x do not support multithreading in the guest.
> Do not let admin falsely specify multithreading on QEMU
> smp commandline.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  hw/s390x/s390-virtio-ccw.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
> index 70229b102b..b5ca154e2f 100644
> --- a/hw/s390x/s390-virtio-ccw.c
> +++ b/hw/s390x/s390-virtio-ccw.c
> @@ -86,6 +86,9 @@ static void s390_init_cpus(MachineState *machine)
>      MachineClass *mc = MACHINE_GET_CLASS(machine);
>      int i;
>  
> +    /* Explicitely do not support threads */
> +    assert(machine->smp.threads == 1);

What is the functional effect for currently released QEMU versions
if a user has set threads == 2  for an s390 machine ?  Is the
threads setting simply ignored ?

If we want to eliminate this mistake, then there's two possible
options

  * If it had no effect, treat this like a deprecation process
    where we print a warning for 2 releases, and then turn the
    warning into an error. Gives a little grace to fix the config
    mistakes some users might have made, at a time convenient to
    them.

Or

  * If it had effect and we need migration compatibility then forbid
    threads > 1 only for new machine type versions, so existing
    deployed guests are not changed.

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

