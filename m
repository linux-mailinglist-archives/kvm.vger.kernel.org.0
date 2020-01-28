Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CCF714C1A9
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2020 21:38:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbgA1Uiv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jan 2020 15:38:51 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:48780 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726182AbgA1Uiu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jan 2020 15:38:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:
        From:Date:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=HBbj1uTIGuAW6NIczL0TPAxBPwE7P6H9mk2dv5P0WyA=; b=SuAgyQ+xzqVLvH2zA0tW3W/z5
        Z72ftRU/IEYJ9BomCizYr804UJrgsw3AJouk1ou+W9uCam28DmWIrhjEOYnCiAgCW9rsq/y+V1UHt
        jSEX9xbtZgWHV9RhdAM2Ks8auX8XqvrP/rnTSgYo4+rqnhmLwknPIXVpiKGE16eH7RPciT0oVt1YE
        yhKTuAXet80aj9hQbYMDmcsJfx56jSNLcealRq8fK9exaz6xnOJ9kMR8eLLyaThL3e/8TSJgDldSM
        vjxrjU7LC1sC/J8IKjzelTA3pM4S8DysCbHVZz8aGIDwJb27n+0DZCTFou7EFV7uz9DldRVGQYwvz
        aLcqaJ4aw==;
Received: from [80.156.29.194] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iwXdI-00086i-3A; Tue, 28 Jan 2020 20:38:48 +0000
Date:   Tue, 28 Jan 2020 21:38:39 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 11/27] docs: kvm: convert devices/s390_flic.txt to ReST
Message-ID: <20200128213839.4b5449c5@kernel.org>
In-Reply-To: <20200128191348.497334df.cohuck@redhat.com>
References: <cover.1580219586.git.mchehab+huawei@kernel.org>
        <12634be89f4a8b662bf4bc0a0c7baef42675548f.1580219586.git.mchehab+huawei@kernel.org>
        <20200128191348.497334df.cohuck@redhat.com>
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Em Tue, 28 Jan 2020 19:13:48 +0100
Cornelia Huck <cohuck@redhat.com> escreveu:

> On Tue, 28 Jan 2020 15:00:12 +0100
> Mauro Carvalho Chehab <mchehab+huawei@kernel.org> wrote:
> 
> > - Use standard markup for document title;
> > - Adjust indentation and add blank lines as needed;
> > - use the notes markup;
> > - mark code blocks as such.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> > ---
> >  Documentation/virt/kvm/devices/index.rst      |  1 +
> >  .../devices/{s390_flic.txt => s390_flic.rst}  | 68 +++++++++++--------
> >  2 files changed, 39 insertions(+), 30 deletions(-)
> >  rename Documentation/virt/kvm/devices/{s390_flic.txt => s390_flic.rst} (88%)  
> 
> Duplicate... old files?

It is duplicated. Sorry for that. I'm using an old notebook with a bad
internet connection. I ended by sending the same patch series twice,
as it sounded that the first attempt failed due to some errors I got
from git send-email.

Regards,
Mauro
