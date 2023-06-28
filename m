Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D18CB740C16
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 10:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234099AbjF1I7F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 04:59:05 -0400
Received: from out-33.mta0.migadu.com ([91.218.175.33]:57670 "EHLO
        out-33.mta0.migadu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234342AbjF1IWh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 04:22:37 -0400
Date:   Wed, 28 Jun 2023 10:22:34 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1687940556;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yE+zAS36vm7c0KpHY1t0fhT+UJHRW10aXuD6DFFQQx8=;
        b=b02zPhyrB0viWXXh0GLBNtTOP2VDJjlJViMJyRiczXLw1D+sUdDQWf5iQBRbiwAUm+DSZ4
        GwkfOLZSJAijtQiWM1wC82flqBWV6mqVQSyDTnWfZX3pNn60lf6rushEvaa8oYNSNBesqV
        V0n7owwtOFAkbSRFCaRoQNe5qayGTXA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>, Nadav Amit <namit@vmware.com>
Subject: Re: [PATCH] .debug ignore - to squash with efi:keep efi
Message-ID: <20230628-b2233c7a1459191cc7b0c9c0@orel>
References: <20230628001356.2706-1-namit@vmware.com>
 <20230628-646da878865323f64fc52452@orel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230628-646da878865323f64fc52452@orel>
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 28, 2023 at 10:19:03AM +0200, Andrew Jones wrote:
> On Wed, Jun 28, 2023 at 12:13:48AM +0000, Nadav Amit wrote:
> > From: Nadav Amit <namit@vmware.com>
> 
> Missing s-o-b.
> 
> > 
> > ---
> >  .gitignore | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/.gitignore b/.gitignore
> > index 29f352c..2168e01 100644
> > --- a/.gitignore
> > +++ b/.gitignore
> > @@ -7,6 +7,7 @@ tags
> >  *.flat
> >  *.efi
> >  *.elf
> > +*.debug
> >  *.patch
> >  .pc
> >  patches
> > -- 
> > 2.34.1
> >
> 
> The patch threading is busted. Everything in the thread, including the
> cover letter, is in reply to this patch.
>

OK, I see the .gitignore hunk in patch 1, which is good, since it
certainly doesn't need its own patch. I'll just ignore this "patch".

Thanks,
drew
