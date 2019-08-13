Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39D398B68F
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 13:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbfHMLYL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 07:24:11 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:33524 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726086AbfHMLYL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 07:24:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Transfer-Encoding
        :Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=K5gbxcQPxrQYgws2hBkB1SH1ZLrBAecYkptVmkU/CGk=; b=VBhkUStRQ4A8I1CFq/DgEvG8QK
        mabjskg5FBYy57JI09/XJ+irmmluQEyFn85/SuN/45HNd3U/QuZsVBL+T1q44y1YuhmwXhFeFOIid
        5+TJqYzbYBR4TAQdkn+yPCLlhGjXlAQ8gSeXgktbYEHsVXCJu8vfkH90LYiZ3gbC2jrirPL9ZU49S
        /bvRIf8M2YA5toVEmvi1MpyRuNiS+3/VfzBQLmxvSpGFqj7t8TBqpby1yVIj97hYNPOiRJd/2Xg35
        YvvqIbffdEJSygJyMOOoqy74tKwa9u0wy1prWkxOhDCrSmHHMkfHeNaDXuascaWKuA3U2Y6cCpTEG
        zW2hQB3Q==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hxUuO-0006tv-Eu; Tue, 13 Aug 2019 11:24:08 +0000
Date:   Tue, 13 Aug 2019 04:24:08 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Adalbert =?utf-8?B?TGF6xINy?= <alazar@bitdefender.com>,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        virtualization@lists.linux-foundation.org,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        Samuel =?iso-8859-1?Q?Laur=E9n?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>, Zhang@kvack.org,
        Yu C <yu.c.zhang@intel.com>,
        Mihai =?utf-8?B?RG9uyJt1?= <mdontu@bitdefender.com>,
        Mircea =?iso-8859-1?Q?C=EErjaliu?= <mcirjaliu@bitdefender.com>
Subject: Re: DANGER WILL ROBINSON, DANGER
Message-ID: <20190813112408.GC5307@bombadil.infradead.org>
References: <20190809160047.8319-1-alazar@bitdefender.com>
 <20190809160047.8319-72-alazar@bitdefender.com>
 <20190809162444.GP5482@bombadil.infradead.org>
 <ae0d274c-96b1-3ac9-67f2-f31fd7bbdcee@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ae0d274c-96b1-3ac9-67f2-f31fd7bbdcee@redhat.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 13, 2019 at 11:29:07AM +0200, Paolo Bonzini wrote:
> On 09/08/19 18:24, Matthew Wilcox wrote:
> > On Fri, Aug 09, 2019 at 07:00:26PM +0300, Adalbert Lazăr wrote:
> >> +++ b/include/linux/page-flags.h
> >> @@ -417,8 +417,10 @@ PAGEFLAG(Idle, idle, PF_ANY)
> >>   */
> >>  #define PAGE_MAPPING_ANON	0x1
> >>  #define PAGE_MAPPING_MOVABLE	0x2
> >> +#define PAGE_MAPPING_REMOTE	0x4
> > Uh.  How do you know page->mapping would otherwise have bit 2 clear?
> > Who's guaranteeing that?
> > 
> > This is an awfully big patch to the memory management code, buried in
> > the middle of a gigantic series which almost guarantees nobody would
> > look at it.  I call shenanigans.
> 
> Are you calling shenanigans on the patch submitter (which is gratuitous)
> or on the KVM maintainers/reviewers?

On the patch submitter, of course.  How can I possibly be criticising you
for something you didn't do?

