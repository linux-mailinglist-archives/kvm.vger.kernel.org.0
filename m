Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 672066671B5
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 13:09:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231580AbjALMJQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 07:09:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232095AbjALMIb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 07:08:31 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E73510069
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 04:03:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673524988;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=A1S8oagK+OmCaCCRKTqwkjbTVJtpuqKSC2zdNhDLc8E=;
        b=NFkdxq95uKwFFDXTjlwt+0YCZLZN4TJFDb1bHQeYafuiwO6GTPfD9MLHoT+lslKFNk16vs
        fpKVL8tSkNEWi8vl8ZSxa5hf2uuJKtIcUaSgpT0v/Wl98wMuQx1nq7vgtGgGoS0m1D+fk+
        auf7mFA3ChnVvkVMUNQlgny2NIwsGI8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-543-wqd-U0ZhPp6H7UtVMoWi6g-1; Thu, 12 Jan 2023 07:03:07 -0500
X-MC-Unique: wqd-U0ZhPp6H7UtVMoWi6g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2F4881C00417;
        Thu, 12 Jan 2023 12:03:06 +0000 (UTC)
Received: from redhat.com (unknown [10.33.36.222])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 82ECB40ED784;
        Thu, 12 Jan 2023 12:03:03 +0000 (UTC)
Date:   Thu, 12 Jan 2023 12:03:01 +0000
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     qemu-s390x@nongnu.org, qemu-devel@nongnu.org,
        borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, scgl@linux.ibm.com,
        frankja@linux.ibm.com, clg@kaod.org
Subject: Re: [PATCH v14 08/11] qapi/s390/cpu topology:  change-topology
 monitor command
Message-ID: <Y7/29cONlVoKukIP@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20230105145313.168489-1-pmorel@linux.ibm.com>
 <20230105145313.168489-9-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230105145313.168489-9-pmorel@linux.ibm.com>
User-Agent: Mutt/2.2.9 (2022-11-12)
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 05, 2023 at 03:53:10PM +0100, Pierre Morel wrote:
> The modification of the CPU attributes are done through a monitor
> commands.
> 
> It allows to move the core inside the topology tree to optimise
> the cache usage in the case the host's hypervizor previously
> moved the CPU.
> 
> The same command allows to modifiy the CPU attributes modifiers
> like polarization entitlement and the dedicated attribute to notify
> the guest if the host admin modified scheduling or dedication of a vCPU.
> 
> With this knowledge the guest has the possibility to optimize the
> usage of the vCPUs.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  qapi/machine-target.json |  29 ++++++++
>  include/monitor/hmp.h    |   1 +
>  hw/s390x/cpu-topology.c  | 141 +++++++++++++++++++++++++++++++++++++++
>  hmp-commands.hx          |  16 +++++
>  4 files changed, 187 insertions(+)
> 
> diff --git a/qapi/machine-target.json b/qapi/machine-target.json
> index 2e267fa458..75b0aa254d 100644
> --- a/qapi/machine-target.json
> +++ b/qapi/machine-target.json
> @@ -342,3 +342,32 @@
>                     'TARGET_S390X',
>                     'TARGET_MIPS',
>                     'TARGET_LOONGARCH64' ] } }
> +
> +##
> +# @change-topology:
> +#
> +# @core: the vCPU ID to be moved
> +# @socket: the destination socket where to move the vCPU
> +# @book: the destination book where to move the vCPU
> +# @drawer: the destination drawer where to move the vCPU

This movement can be done while the guest OS is running ?
What happens to guest OS apps ? Every I know will read
topology once and assume it never changes at runtime.

What's the use case for wanting to re-arrange topology in
this manner ? It feels like its going to be a recipe for
hard to diagnose problems, as much code in libvirt and apps
above will assuming the vCPU IDs are assigned sequentially
starting from node=0,book=0,drawer=0,socket=0,core=0,
incrementing core, then incrementing socket, then
incrementing drawer, etc.

> +# @polarity: optional polarity, default is last polarity set by the guest
> +# @dedicated: optional, if the vCPU is dedicated to a real CPU
> +#
> +# Modifies the topology by moving the CPU inside the topology
> +# tree or by changing a modifier attribute of a CPU.
> +#
> +# Returns: Nothing on success, the reason on failure.
> +#
> +# Since: <next qemu stable release, eg. 1.0>
> +##
> +{ 'command': 'change-topology',

'set-cpu-topology'

> +  'data': {
> +      'core': 'int',
> +      'socket': 'int',
> +      'book': 'int',
> +      'drawer': 'int',
> +      '*polarity': 'int',
> +      '*dedicated': 'bool'
> +  },
> +  'if': { 'all': [ 'TARGET_S390X', 'CONFIG_KVM' ] }
> +}


With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

