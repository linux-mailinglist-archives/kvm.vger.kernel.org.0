Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2617A3A1B3A
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 18:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbhFIQwS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 12:52:18 -0400
Received: from mail-lf1-f44.google.com ([209.85.167.44]:38772 "EHLO
        mail-lf1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbhFIQwS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 12:52:18 -0400
Received: by mail-lf1-f44.google.com with SMTP id r5so39130083lfr.5;
        Wed, 09 Jun 2021 09:50:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=3gyxMnoRbxZRykvLr0IvxpYyG30m6bnQauem2mqaYuE=;
        b=bqV8Edyba/9+2ATfjOdGoik5skLG7JqjUNrGKFLdyIPQ4E02O1rM8v9UuFEkqCr/Rj
         +k9CepUb0UuyqBRc9MFQemqFiuK9/2nAZJ8BwE1k4pG7ggZ3FUl6LxQsHXB8lBZTrOK7
         jpVwnYVNJwIGP7ELL0hhcwZaxyrmY/oZDP8Rl5YJnAVlvcQI4J0chqNu7tMIwrkbkmPG
         oNB8VndF9inx71al5Jk/cMzxuAdOcc6AKBlWfNxc0XTx6Hpeh8d+bLdsiKDkBz2ruB+G
         iY4cT6AEV1wIpe6y9HAK981qXvYKxvHk6HVApPu1bYGV8F6TUymYNPBzMO/XET/t3C4N
         qxng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=3gyxMnoRbxZRykvLr0IvxpYyG30m6bnQauem2mqaYuE=;
        b=Webjth61+V2ZXl9S0LMA3dvwgZ45LjBrgV/Tbzb2ihqr9UUg64gDLYQf+66zDAx+gX
         /f5SZbMziUarc+vqxq8y3psEhsuMya56ONsIreGWYZS8Hm2Bp6wHD405wTlfH0e7A8MH
         3SXk20pR+n26e9b7XKAfDcK4LxwPUa2jebTENYnHTXLFNFH8gHXXYHK/VRyAhi7RBBOq
         glS5kzLfPkrhs1C3DK8vTWEzIlQRtxwWfp/zstk5RFeaZM4xCb7Y60GidUKLPABfJ4dH
         FphETc6myOwHR/RvvGsCEXioTWjEYT/rDCsGGau/08ZB+DE1MVPcgDVdlA/HBpoSAOSZ
         swow==
X-Gm-Message-State: AOAM531Iuu9r/kUOFBLPnY2CbZnoFsJRU5PBG+ouCGiMN1zr8NSL4xH6
        gZ0UcyO1qaoRMf8kDAF0juA=
X-Google-Smtp-Source: ABdhPJwRhPuDQP7LxDCokVoIWdr9QXFRmIQbHsiCg35TrI5owb6lII2MZIz4HoVtokdNWMPoPRrYVQ==
X-Received: by 2002:a05:6512:b85:: with SMTP id b5mr286001lfv.380.1623257362065;
        Wed, 09 Jun 2021 09:49:22 -0700 (PDT)
Received: from pc638.lan (h5ef52e3d.seluork.dyn.perspektivbredband.net. [94.245.46.61])
        by smtp.gmail.com with ESMTPSA id b18sm33359lfb.277.2021.06.09.09.49.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 09:49:21 -0700 (PDT)
From:   Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc638.lan>
Date:   Wed, 9 Jun 2021 18:49:19 +0200
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, david@redhat.com,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Uladzislau Rezki <urezki@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v2 1/2] mm/vmalloc: export __vmalloc_node_range
Message-ID: <20210609164919.GA1938@pc638.lan>
References: <20210608180618.477766-1-imbrenda@linux.ibm.com>
 <20210608180618.477766-2-imbrenda@linux.ibm.com>
 <YMDlVdB8m62AhbB7@infradead.org>
 <20210609182809.7ae07aad@ibm-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210609182809.7ae07aad@ibm-vm>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 09, 2021 at 06:28:09PM +0200, Claudio Imbrenda wrote:
> On Wed, 9 Jun 2021 16:59:17 +0100
> Christoph Hellwig <hch@infradead.org> wrote:
> 
> > On Tue, Jun 08, 2021 at 08:06:17PM +0200, Claudio Imbrenda wrote:
> > > The recent patches to add support for hugepage vmalloc mappings
> > > added a flag for __vmalloc_node_range to allow to request small
> > > pages. This flag is not accessible when calling vmalloc, the only
> > > option is to call directly __vmalloc_node_range, which is not
> > > exported.
> > > 
> > > This means that a module can't vmalloc memory with small pages.
> > > 
> > > Case in point: KVM on s390x needs to vmalloc a large area, and it
> > > needs to be mapped with small pages, because of a hardware
> > > limitation.
> > > 
> > > This patch exports __vmalloc_node_range so it can be used in modules
> > > too.  
> > 
> > No.  I spent a lot of effort to mak sure such a low-level API is
> > not exported.
> 
> ok, but then how can we vmalloc memory with small pages from KVM?
Does the s390x support CONFIG_HAVE_ARCH_HUGE_VMALLOC what is arch
specific?

If not then small pages are used. Or am i missing something?

I agree with Christoph that exporting a low level internals
is not a good idea.

--
Vlad Rezki
