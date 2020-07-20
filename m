Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32B6A22701C
	for <lists+kvm@lfdr.de>; Mon, 20 Jul 2020 23:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgGTVBp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jul 2020 17:01:45 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:39803 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726016AbgGTVBp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jul 2020 17:01:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595278904;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4U6VZiSJ8TPUEgmufp44M9sR4CYrgqTXgYg5iSdD8Jo=;
        b=Q8aD6zA5FIDVL77se3NH6YYwgeu3zv3zA+jUph3zhdp4ApUMSAhX2iUYDlUz+9phi2JAbS
        2Bw/i1y6Q86NeORwzKUC1EvZcFThzaaS4IwEcOhl1x691Tmta2qyuSQ6BDi5O/mMPXibU7
        2XMyPgNOztfCkxYLvbbEKF/ezzhvVtk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-444-aGJ4eoBgPE-j2EGC2tW1Sg-1; Mon, 20 Jul 2020 17:01:40 -0400
X-MC-Unique: aGJ4eoBgPE-j2EGC2tW1Sg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 079151005510;
        Mon, 20 Jul 2020 21:01:39 +0000 (UTC)
Received: from x1.home (ovpn-112-71.phx2.redhat.com [10.3.112.71])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 829DA5C22A;
        Mon, 20 Jul 2020 21:01:38 +0000 (UTC)
Date:   Mon, 20 Jul 2020 15:01:38 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Cornelia Huck <cohuck@redhat.com>, prime.zeng@hisilicon.com
Subject: Re: [GIT PULL] VFIO fix for v5.8-rc7
Message-ID: <20200720150138.5c13e8b9@x1.home>
In-Reply-To: <CAHk-=wijGPPiUH8-kzu2ZyP9_SgBxbGib7afOMAwpusfx-2K+g@mail.gmail.com>
References: <20200720083427.50202e82@x1.home>
        <CAHk-=wijGPPiUH8-kzu2ZyP9_SgBxbGib7afOMAwpusfx-2K+g@mail.gmail.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 20 Jul 2020 13:33:29 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, Jul 20, 2020 at 7:34 AM Alex Williamson
> <alex.williamson@redhat.com> wrote:
> >
> > VFIO fixes for v5.8-rc7
> >
> >  - Fix race with eventfd ctx cleared outside of mutex (Zeng Tao)  
> 
> Why does this take and then re-take the lock immediately? That just
> looks insane.
> 
> I realize that this isn't likely to be a performance-critical path,
> but this is a basic source cleanliness issue. Doing silly things is
> silly, and shouldn't be done, even if they don't matter.

Yup, it's silly.  Cornelia identified the same during review and I let
it slide after some counter arguments by the submitter.  I see this got
merged, so I'll post a cleanup for v5.9.  Thanks for the input,

Alex

