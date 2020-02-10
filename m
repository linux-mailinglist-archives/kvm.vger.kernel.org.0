Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC6DF156EFA
	for <lists+kvm@lfdr.de>; Mon, 10 Feb 2020 06:58:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726227AbgBJF6T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Feb 2020 00:58:19 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:36216 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726061AbgBJF6S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Feb 2020 00:58:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:
        From:Date:Sender:Reply-To:Content-ID:Content-Description;
        bh=7sfdFqk46az1QPOD/6II7HGpIuwSsyprujkSDw33YBQ=; b=Jyj2X9LFZcTwuqqlVM50jhYrsA
        wai8EoLD+VGZZSAbYKufxCdmd5N02Lb6BV+xVt+bmi0OwUIsM7XrMSFkOPKvylMoBwErVngU/G1Ua
        CmPLIHTIKgOULb39tFd8lFugFcb19CvRWc3Z9Ojmpmn/K0W4TTAzMXGQber17ExwwmZg/e9loEi0B
        ycjpQYOqNh+/p5kcUQHvU41QHxQIO5i+3cW3kJXCAdM0hf14fRW3jtq2VcvvqpHYYO6R1L5lmPTyi
        ipv3EkgbjKQm7fZ40HgIqzBdwYUASFgbvUldbVbjHicT3v0pjIu5Tgqj2xWYNwmsHmmlSGIh3maf1
        zeCQfbPw==;
Received: from [80.156.29.194] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j125B-0004xe-KU; Mon, 10 Feb 2020 05:58:09 +0000
Date:   Mon, 10 Feb 2020 06:58:06 +0100
From:   Mauro Carvalho Chehab <mchehab@infradead.org>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 21/27] docs: kvm: Convert locking.txt to ReST format
Message-ID: <20200210065806.00b4f634@infradead.org>
In-Reply-To: <20200207094803.152f0c9b.cohuck@redhat.com>
References: <cover.1581000481.git.mchehab+huawei@kernel.org>
        <1464d69fe780940cec6ecec4ac2505b9701a1e01.1581000481.git.mchehab+huawei@kernel.org>
        <20200206171132.4f51f17a.cohuck@redhat.com>
        <a17d6a27-0d3f-2020-7fc2-87ec20a6225f@redhat.com>
        <20200206234736.196ef417@kernel.org>
        <20200207072409.2cb038da@infradead.org>
        <20200207094803.152f0c9b.cohuck@redhat.com>
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Em Fri, 7 Feb 2020 09:48:03 +0100
Cornelia Huck <cohuck@redhat.com> escreveu:

> On Fri, 7 Feb 2020 07:24:09 +0100
> Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
> 
> > >     
> > > > 
> > > > Would be nicer but this is acceptable too I think.  Especially, the
> > > > monospaced font allows breaking the table and keeping the parts aligned.      
> > 
> > I couldn't resist trying to use a table ;-)
> > 
> > The following patch does that. IMO, it looks nice on both text and html
> > outputs.  
> 
> Now that I see this, I think this version is actually more readable
> than the existing text.

Yes, that was my feeling too: even for one reading the text version,
it looked clearer on my eyes.

> 
> > 
> > Cheers,
> > Mauro
> > 
> > diff --git a/Documentation/virt/kvm/locking.rst b/Documentation/virt/kvm/locking.rst
> > index 428cb3412ecc..c02291beac3f 100644
> > --- a/Documentation/virt/kvm/locking.rst
> > +++ b/Documentation/virt/kvm/locking.rst
> > @@ -59,30 +59,39 @@ The mapping from gfn to pfn may be changed since we can only ensure the pfn
> >  is not changed during cmpxchg. This is a ABA problem, for example, below case
> >  will happen:
> >  
> > -At the beginning::
> > -
> > -	gpte = gfn1
> > -	gfn1 is mapped to pfn1 on host
> > -	spte is the shadow page table entry corresponding with gpte and
> > -	spte = pfn1
> > -
> > -	   VCPU 0                           VCPU0
> > -
> > -on fast page fault path::
> > -
> > -   old_spte = *spte;
> > -                                 pfn1 is swapped out:
> > -                                    spte = 0;
> > -
> > -                                 pfn1 is re-alloced for gfn2.
> > -
> > -                                 gpte is changed to point to
> > -                                 gfn2 by the guest:
> > -                                    spte = pfn1;
> > -
> > -   if (cmpxchg(spte, old_spte, old_spte+W)
> > -	mark_page_dirty(vcpu->kvm, gfn1)
> > -             OOPS!!!
> > ++------------------------------------------------------------------------+
> > +| At the beginning::                                                     |
> > +|                                                                        |
> > +|	gpte = gfn1                                                      |
> > +|	gfn1 is mapped to pfn1 on host                                   |
> > +|	spte is the shadow page table entry corresponding with gpte and  |
> > +|	spte = pfn1                                                      |
> > ++------------------------------------------------------------------------+
> > +| On fast page fault path:                                               |
> > ++------------------------------------+-----------------------------------+
> > +| CPU 0:                             | CPU 1:                            |
> > ++------------------------------------+-----------------------------------+
> > +| ::                                 |                                   |  
> 
> The '::' directives look a bit like leftover christmas decorations,
> but it's not really distracting, and on the plus side, we'll get nice
> html formatting.

Yes the only downside are those extra "::". The alternatives to it that
would produce a similar look and feel would be a lot worse.

> 
> > +|                                    |                                   |
> > +|   old_spte = *spte;                |                                   |
> > ++------------------------------------+-----------------------------------+
> > +|                                    | pfn1 is swapped out::             |
> > +|                                    |                                   |
> > +|                                    |    spte = 0;                      |
> > +|                                    |                                   |
> > +|                                    | pfn1 is re-alloced for gfn2.      |
> > +|                                    |                                   |
> > +|                                    | gpte is changed to point to       |
> > +|                                    | gfn2 by the guest::               |
> > +|                                    |                                   |
> > +|                                    |    spte = pfn1;                   |
> > ++------------------------------------+-----------------------------------+
> > +| ::                                                                     |
> > +|                                                                        |
> > +|   if (cmpxchg(spte, old_spte, old_spte+W)                              |
> > +|	mark_page_dirty(vcpu->kvm, gfn1)                                 |
> > +|            OOPS!!!                                                     |
> > ++------------------------------------------------------------------------+
> >  
> >  We dirty-log for gfn1, that means gfn2 is lost in dirty-bitmap.
> >    
> 
> So I'd like to cast my vote for this version :)
> 

Ok. I'm submitting version 3 with this version.

Regards,
Mauro

Cheers,
Mauro
