Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5BAE3F9840
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 12:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245003AbhH0Kus (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 06:50:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33578 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245000AbhH0Kur (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 27 Aug 2021 06:50:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630061398;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EllHdvUfcuVb8lKpASGfA4m6w86+ZfVbHSNg3FyU4ZE=;
        b=P7wH4PEhHCa3s90vrudtypMkwsQwdF28n/I5mF6pCDJuBEKtpYkO1J01ZEPJZhfLefYZ0j
        uPbGu/rfqqiukIwmhThKKMRfA66UstT1qiZm3X3vjTZEqQRLL9FYry8funKqn/jmW+RH+m
        ckq08RdzcsrVl/MAIhaT5+i1LpP6r8g=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-203-nuv_bWA5PsiOxmBXyRx-Xw-1; Fri, 27 Aug 2021 06:49:55 -0400
X-MC-Unique: nuv_bWA5PsiOxmBXyRx-Xw-1
Received: by mail-ed1-f70.google.com with SMTP id b6-20020aa7c6c6000000b003c2b5b2ddf8so130525eds.0
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 03:49:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EllHdvUfcuVb8lKpASGfA4m6w86+ZfVbHSNg3FyU4ZE=;
        b=Rl+vbq7MspN62dCJ3COXJQUlfRqG6Mx+WAqc/nGxrTz3Wpy02598xFBStQmXoTGHaJ
         y5JRcFvkWfl4OaAlhFIpsPQTIuSVa6E/omT+JGor1B3P8C/evtZj0Rxb6p8Tr1jvwUXe
         qneYmFSXSC+UuAlD4/kq6NSV9mqZxfM5wjutFXrWzPBiyg9z1tQHGejmVNUV2Q0526hv
         NrArQt9gQdreB8iq9Wp68sq8ZWwMmCaoB6S8ACzYSVYGUAHo/Hed4QwGO8T6xrvoH6T7
         amG1HZITXDapgJqnyMdZ67agOMS0MnE9Fmei9G2VTetJIfxNvyMBSfJDGgRtXnr+KN2H
         3LSg==
X-Gm-Message-State: AOAM5306A3A+gqzqrs7ikege55zQ+tihrGQ4KVsWkDUenUbsvh8OqZ0Z
        MOKLhZS0L7mxpIFr8qGBTOig7d+Zru7SHz8dTTpBlF7vJR6quRgRsgwlVvRy0zmK4npKoDxEE4/
        hKURefhXOY0GE
X-Received: by 2002:a17:906:c1c9:: with SMTP id bw9mr9290626ejb.3.1630061394196;
        Fri, 27 Aug 2021 03:49:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwPQXQ0yNL9xyZdpMdOSsqzzTZM1MSM+rjHEXuRBY6M9SNZftJ00jM9SAxY7mpNEYwrulH/pA==
X-Received: by 2002:a17:906:c1c9:: with SMTP id bw9mr9290612ejb.3.1630061394044;
        Fri, 27 Aug 2021 03:49:54 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id y20sm641201eje.113.2021.08.27.03.49.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Aug 2021 03:49:53 -0700 (PDT)
Date:   Fri, 27 Aug 2021 12:49:51 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, pmorel@linux.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com, imbrenda@linux.ibm.com,
        pbonzini@redhat.com
Subject: Re: [PATCH kvm-unit-tests] Makefile: Don't trust PWD
Message-ID: <20210827104951.jwdf4jj6h3eko3qk@gator.home>
References: <20210827103115.309774-1-drjones@redhat.com>
 <566ab64b-03eb-b4e6-ddff-39524f256578@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <566ab64b-03eb-b4e6-ddff-39524f256578@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 27, 2021 at 12:36:05PM +0200, Thomas Huth wrote:
> On 27/08/2021 12.31, Andrew Jones wrote:
> > It's possible that PWD is already set to something which isn't
> > the full path of the current working directory. Let's make sure
> > it is.
> > 
> > Signed-off-by: Andrew Jones <drjones@redhat.com>
> > ---
> >   Makefile | 1 +
> >   1 file changed, 1 insertion(+)
> > 
> > diff --git a/Makefile b/Makefile
> > index f7b9f28c9319..a65f225b7d5c 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -1,4 +1,5 @@
> >   SHELL := /usr/bin/env bash
> > +PWD := $(shell pwd)
> 
> I think we should rather use $(CURDIR) in Makefiles instead, since this is
> the official way that GNU Make handles the current working directory.

Agreed. I'll send a v2.

> 
> By the way, is this cscope thing also supposed to work in out-of-tree builds?

I personally don't care if it works from the out-of-tree build dir. I
generally want to be able to use git commands while browsing code too,
so I won't be running cscope anywhere but in a repo with a checked-out
working tree.

Thanks,
drew

