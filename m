Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC4106671A2
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 13:06:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231510AbjALMGL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 07:06:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230447AbjALMFD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 07:05:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51D50192B2
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 03:58:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673524726;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=/K8333ZujE5WCrKczy9e/De2DvDl0EweGdLTDnQ5RIo=;
        b=R+yZlBnewICVOdhz48MvrMySea+1rTMlT5LH9x1s/41xem/nDqdvCy8mmkjMr46FoKHOo4
        eQ36RPfSIfr4ImtLvcI71+eIMNvPr18oraiBAkEdiii7vFGE8HMvoc9pwTym4eS62vKy2Q
        Il7e28p0YsSYfYJ4HK4399FzDTz00Xw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-571-s2lFiLnbNAOpgxjU-dpAdg-1; Thu, 12 Jan 2023 06:58:43 -0500
X-MC-Unique: s2lFiLnbNAOpgxjU-dpAdg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6D2441805660;
        Thu, 12 Jan 2023 11:58:42 +0000 (UTC)
Received: from redhat.com (unknown [10.33.36.222])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D8F464085721;
        Thu, 12 Jan 2023 11:58:39 +0000 (UTC)
Date:   Thu, 12 Jan 2023 11:58:37 +0000
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
Subject: Re: [PATCH v14 11/11] docs/s390x/cpu topology: document s390x cpu
 topology
Message-ID: <Y7/17Yjblca57VT9@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20230105145313.168489-1-pmorel@linux.ibm.com>
 <20230105145313.168489-12-pmorel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230105145313.168489-12-pmorel@linux.ibm.com>
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

On Thu, Jan 05, 2023 at 03:53:13PM +0100, Pierre Morel wrote:
> Add some basic examples for the definition of cpu topology
> in s390x.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  docs/system/s390x/cpu-topology.rst | 292 +++++++++++++++++++++++++++++
>  docs/system/target-s390x.rst       |   1 +
>  2 files changed, 293 insertions(+)
>  create mode 100644 docs/system/s390x/cpu-topology.rst
> 
> diff --git a/docs/system/s390x/cpu-topology.rst b/docs/system/s390x/cpu-topology.rst
> new file mode 100644
> index 0000000000..0020b70b50
> --- /dev/null
> +++ b/docs/system/s390x/cpu-topology.rst
> @@ -0,0 +1,292 @@
> +CPU Topology on s390x
> +=====================
> +
> +CPU Topology on S390x provides up to 5 levels of topology containers:
> +nodes, drawers, books, sockets and CPUs.

The last level should be 'cores' not CPUs for QEMU terminology.

> +While the higher level containers, Containers Topology List Entries,
> +(Containers TLE) define a tree hierarchy, the lowest level of topology
> +definition, the CPU Topology List Entry (CPU TLE), provides the placement
> +of the CPUs inside the parent container.

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

