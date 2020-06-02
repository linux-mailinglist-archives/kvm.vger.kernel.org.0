Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39B281EBFFF
	for <lists+kvm@lfdr.de>; Tue,  2 Jun 2020 18:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726345AbgFBQ3x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jun 2020 12:29:53 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37641 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbgFBQ3x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jun 2020 12:29:53 -0400
Received: by mail-wr1-f67.google.com with SMTP id x13so4064903wrv.4;
        Tue, 02 Jun 2020 09:29:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=grj2CD92FpDw05CnIagvOgvwut5Hrck8wRdVE5tNepE=;
        b=PjWQZ8GkVvldADP4VqRlvnYLNrMaLRwcJLALh0emcdl/BgspjsHXFFskfPdQ5CbiGp
         baAg5fW95+6gzl9Ssd3eRo9i3kjIkZA032eV1a3ObBPBxFP83u4tubCPNQlB9dK+4a9G
         OnUOzTVj3/6zxR10XK4M9ibYdM3hZNC62Q1Nv+ys9D1rOtiOSNIto0cDerdgtNUsrxFo
         tb+BRrHXfy0WnNHxBCnDbHtlBUGLXbr8FsbGeRC6kaZRCOJzAfsDkJ65csA1yrRblW3s
         Dk/vkPqIKgIddbK+dmwXRStc3iI1P/kzOcNWPIo6+1AaTw+y43/H3yUgltnfN8fG2isN
         P2JA==
X-Gm-Message-State: AOAM531A3s57LSXh9esKhuQ+TD0xROXpRBvLoYbnxEn5Fd8qRONQepik
        Mms35F+0iRMGALc0hzzHYRc=
X-Google-Smtp-Source: ABdhPJwj7ACPWeLcVCtJq+ZO6vqa/uLz3Pyy+cGfDn8e9V/X9REn1sHMGM0j8aIQ1mHdwcusNk0AvQ==
X-Received: by 2002:a05:6000:10c3:: with SMTP id b3mr28987548wrx.53.1591115391146;
        Tue, 02 Jun 2020 09:29:51 -0700 (PDT)
Received: from liuwe-devbox-debian-v2.j3c5onc20sse1dnehy4noqpfcg.zx.internal.cloudapp.net ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id b132sm423020wmh.3.2020.06.02.09.29.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 09:29:50 -0700 (PDT)
Date:   Tue, 2 Jun 2020 16:29:49 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Wei Liu <wei.liu@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        KVM <kvm@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jon Doron <arilou@gmail.com>,
        Michael Kelley <mikelley@microsoft.com>
Subject: Re: linux-next: manual merge of the hyperv tree with the kvm tree
Message-ID: <20200602162949.apy2lzpecyedqtiw@liuwe-devbox-debian-v2.j3c5onc20sse1dnehy4noqpfcg.zx.internal.cloudapp.net>
References: <20200602171802.560d07bc@canb.auug.org.au>
 <20200602135618.5iw6zd2jqzqqcwxm@liuwe-devbox-debian-v2.j3c5onc20sse1dnehy4noqpfcg.zx.internal.cloudapp.net>
 <feb8e292-8dff-58ad-0bb2-5006bf475e6b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <feb8e292-8dff-58ad-0bb2-5006bf475e6b@redhat.com>
User-Agent: NeoMutt/20180716
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 02, 2020 at 06:26:26PM +0200, Paolo Bonzini wrote:
> On 02/06/20 15:56, Wei Liu wrote:
> >>
> >> between commit:
> >>
> >>   22ad0026d097 ("x86/hyper-v: Add synthetic debugger definitions")
> >>
> > Paolo
> > 
> > As far as I can tell you merged that series a few days ago. Do you plan
> > to submit it to Linus in this merge window? How do you want to proceed
> > to fix the conflict?
> 
> Hi, Linus can fix this conflict.

OK. I will write down in my pull request what needs to be done to fix
the conflicts.

Wei.

> 
> Paolo
> 
