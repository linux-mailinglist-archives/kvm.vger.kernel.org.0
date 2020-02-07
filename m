Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 921F0155406
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 09:54:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbgBGIyL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 03:54:11 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:32539 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726619AbgBGIyL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Feb 2020 03:54:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581065649;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0USnf3hBn92ifbh7P2D9fosqj0oQrhEhCYDRgIDXfoE=;
        b=KtUCSeXnu4vcZuxCbtH2LyuDPy3dbhTYCSdMa7p55sF3EDZjMOs2G7GmRA5PrFqVn6eOUr
        T2spddgHEny2fdSombbK6YZz2TX/nlXApBcYvWiC0wNfRXYuAc3vMx9QFpdOuMFdHVj3ZW
        ouxSQhcVJHzc7XmHZpCK1Dl3Bpp2YEo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-389-wGf86mQwOcWZfWagUhSSDA-1; Fri, 07 Feb 2020 03:54:08 -0500
X-MC-Unique: wGf86mQwOcWZfWagUhSSDA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EF06810CE783;
        Fri,  7 Feb 2020 08:54:06 +0000 (UTC)
Received: from gondolin (ovpn-117-112.ams2.redhat.com [10.36.117.112])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 82683857BF;
        Fri,  7 Feb 2020 08:53:56 +0000 (UTC)
Date:   Fri, 7 Feb 2020 09:53:53 +0100
From:   Cornelia Huck <cohuck@redhat.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, eperezma@redhat.com,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Halil Pasic <pasic@linux.ibm.com>
Subject: Re: vhost changes (batched) in linux-next after 12/13 trigger
 random crashes in KVM guests after reboot
Message-ID: <20200207095353.08bc91e4.cohuck@redhat.com>
In-Reply-To: <97c93d38-ef07-e321-d133-18483d54c0c0@de.ibm.com>
References: <20200107042401-mutt-send-email-mst@kernel.org>
        <c6795e53-d12c-0709-c2e9-e35d9af1f693@de.ibm.com>
        <20200107065434-mutt-send-email-mst@kernel.org>
        <fe6e7e90-3004-eb7a-9ed8-b53a7667959f@de.ibm.com>
        <20200120012724-mutt-send-email-mst@kernel.org>
        <2a63b15f-8cf5-5868-550c-42e2cfd92c60@de.ibm.com>
        <b6e32f58e5d85ac5cc3141e9155fb140ae5cd580.camel@redhat.com>
        <1ade56b5-083f-bb6f-d3e0-3ddcf78f4d26@de.ibm.com>
        <20200206171349-mutt-send-email-mst@kernel.org>
        <5c860fa1-cef5-b389-4ebf-99a62afa0fe8@de.ibm.com>
        <20200207025806-mutt-send-email-mst@kernel.org>
        <97c93d38-ef07-e321-d133-18483d54c0c0@de.ibm.com>
Organization: Red Hat GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 7 Feb 2020 09:13:14 +0100
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> On 07.02.20 08:58, Michael S. Tsirkin wrote:
> > On Fri, Feb 07, 2020 at 08:47:14AM +0100, Christian Borntraeger wrote:  
> >> Also adding Cornelia.
> >>
> >>
> >> On 06.02.20 23:17, Michael S. Tsirkin wrote:  
> >>> On Thu, Feb 06, 2020 at 04:12:21PM +0100, Christian Borntraeger wrote:  
> >>>>
> >>>>
> >>>> On 06.02.20 15:22, eperezma@redhat.com wrote:  
> >>>>> Hi Christian.
> >>>>>
> >>>>> Could you try this patch on top of ("38ced0208491 vhost: use batched version by default")?
> >>>>>
> >>>>> It will not solve your first random crash but it should help with the lost of network connectivity.
> >>>>>
> >>>>> Please let me know how does it goes.  
> >>>>
> >>>>
> >>>> 38ced0208491 + this seem to be ok.
> >>>>
> >>>> Not sure if you can make out anything of this (and the previous git bisect log)  
> >>>
> >>> Yes it does - that this is just bad split-up of patches, and there's
> >>> still a real bug that caused worse crashes :)
> >>>
> >>> So I just pushed batch-v4.
> >>> I expect that will fail, and bisect to give us
> >>>     vhost: batching fetches
> >>> Can you try that please?
> >>>  
> >>
> >> yes.
> >>
> >> eccb852f1fe6bede630e2e4f1a121a81e34354ab is the first bad commit
> >> commit eccb852f1fe6bede630e2e4f1a121a81e34354ab
> >> Author: Michael S. Tsirkin <mst@redhat.com>
> >> Date:   Mon Oct 7 06:11:18 2019 -0400
> >>
> >>     vhost: batching fetches
> >>     
> >>     With this patch applied, new and old code perform identically.
> >>     
> >>     Lots of extra optimizations are now possible, e.g.
> >>     we can fetch multiple heads with copy_from/to_user now.
> >>     We can get rid of maintaining the log array.  Etc etc.
> >>     
> >>     Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> >>
> >>  drivers/vhost/test.c  |  2 +-
> >>  drivers/vhost/vhost.c | 39 ++++++++++++++++++++++++++++++++++-----
> >>  drivers/vhost/vhost.h |  4 +++-
> >>  3 files changed, 38 insertions(+), 7 deletions(-)
> >>  
> > 
> > 
> > And the symptom is still the same - random crashes
> > after a bit of traffic, right?  
> 
> random guest crashes after a reboot of the guests. As if vhost would still
> write into now stale buffers.
> 

I'm late to the party; but where is that commit located? Or has it been
dropped again already?

