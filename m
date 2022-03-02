Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 185C64CAD86
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 19:27:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244505AbiCBS2V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 13:28:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241703AbiCBS2T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 13:28:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C645CFD06
        for <kvm@vger.kernel.org>; Wed,  2 Mar 2022 10:27:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646245653;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mCY+S+PoxaMOSTKIuJlTMs0umdpj+rKF0gwUYA/KOUc=;
        b=TZbtoKVTMadjrxcgixAyfNnBG0RhBRbs0Kg2EY+mFavvRGMRYQmp2Y9sB+1ZENG6oY04Y9
        QR0aOjIOnFVhNlWQgxeFNFA18H4+1NgMCgm/FZF0zjPd/hYj/k85/JFRIjYAZYylykcysu
        8fODRDp2t7OLI4ASDhqfNwycKQDdmOw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-543-ToUOWU_mN1i4XTTHcKclOQ-1; Wed, 02 Mar 2022 13:27:30 -0500
X-MC-Unique: ToUOWU_mN1i4XTTHcKclOQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C63E51091DA1;
        Wed,  2 Mar 2022 18:27:27 +0000 (UTC)
Received: from redhat.com (unknown [10.33.36.166])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 45DD66ABAF;
        Wed,  2 Mar 2022 18:26:34 +0000 (UTC)
Date:   Wed, 2 Mar 2022 18:26:31 +0000
From:   Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>, Sergio Lopez <slp@redhat.com>,
        Fam Zheng <fam@euphon.net>,
        Elena Ufimtseva <elena.ufimtseva@oracle.com>,
        kvm@vger.kernel.org, John G Johnson <john.g.johnson@oracle.com>,
        David Hildenbrand <david@redhat.com>, qemu-devel@nongnu.org,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Jagannathan Raman <jag.raman@oracle.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>, qemu-block@nongnu.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        vgoyal@redhat.com, Eric Farman <farman@linux.ibm.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        qemu-s390x@nongnu.org, Stefan Hajnoczi <stefanha@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Hanna Reitz <hreitz@redhat.com>
Subject: Re: [PATCH 2/2] Allow building vhost-user in BSD
Message-ID: <Yh+213GCS1J8nQkr@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20220302113644.43717-1-slp@redhat.com>
 <20220302113644.43717-3-slp@redhat.com>
 <66b68bcc-8d7e-a5f7-5e6c-b2d20c26ab01@redhat.com>
 <8dfc9854-4d59-0759-88d0-d502ae7c552f@gmail.com>
 <20220302173009.26auqvy4t4rx74td@mhamilton>
 <85ed0856-308a-7774-a751-b20588f3d9cd@gmail.com>
 <2976a926-9dbf-d955-166f-5677a06d9873@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2976a926-9dbf-d955-166f-5677a06d9873@redhat.com>
User-Agent: Mutt/2.1.5 (2021-12-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 02, 2022 at 07:05:32PM +0100, Paolo Bonzini wrote:
> On 3/2/22 18:38, Philippe Mathieu-Daudé wrote:
> > On 2/3/22 18:31, Sergio Lopez wrote:
> > > On Wed, Mar 02, 2022 at 06:18:59PM +0100, Philippe Mathieu-Daudé wrote:
> > > > On 2/3/22 18:10, Paolo Bonzini wrote:
> > > > > On 3/2/22 12:36, Sergio Lopez wrote:
> > > > > > With the possibility of using pipefd as a replacement on operating
> > > > > > systems that doesn't support eventfd, vhost-user can also work on BSD
> > > > > > systems.
> > > > > > 
> > > > > > This change allows enabling vhost-user on BSD platforms too and
> > > > > > makes libvhost_user (which still depends on eventfd) a linux-only
> > > > > > feature.
> > > > > > 
> > > > > > Signed-off-by: Sergio Lopez <slp@redhat.com>
> > > > > 
> > > > > I would just check for !windows.
> > > > 
> > > > What about Darwin / Haiku / Illumnos?
> > > 
> > > It should work on every system providing pipe() or pipe2(), so I guess
> > > Paolo's right, every platform except Windows. FWIW, I already tested
> > > it with Darwin.
> > 
> > Wow, nice.
> > 
> > So maybe simply check for pipe/pipe2 rather than !windows?
> 
> What you really need is not pipes, but AF_UNIX.

Recent Windows has AF_UNIX so don't check for that ! What you really
need is AF_UNIX and FD passing and pipes and probably more POSIX
only features ...

Regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

