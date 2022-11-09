Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 181666224BB
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 08:36:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbiKIHgE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 02:36:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbiKIHf7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 02:35:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 014F31B1EA;
        Tue,  8 Nov 2022 23:35:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 00F89B81D2A;
        Wed,  9 Nov 2022 07:35:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16CA2C433D7;
        Wed,  9 Nov 2022 07:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667979348;
        bh=QB013233+R/iglugH58wCtHW/3scKZz7VosiLXkZFvs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=S7eZY2mDXpccT9ZwV6U2RNKAi1eIc7W/1/kVLp9HEU1LqUwYQY5CXECheTUTOAVkv
         968VjP00uhljDX5dOhDE5R2Odn8h2gJXIJQznABxMVenmSE4h7yEvrez5si5ud6xhN
         L4eZP1K3zQFz4Wkamm91Z9EkrP+0svuZSlmGKPqQ=
Date:   Wed, 9 Nov 2022 08:35:45 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Paraschiv, Andra-Irina" <andraprs@amazon.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Alexandru Ciobotaru <alcioa@amazon.com>,
        Marcelo Cerri <marcelo.cerri@canonical.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Tim Gardner <tim.gardner@canonical.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        ne-devel-upstream <ne-devel-upstream@amazon.com>,
        The AWS Nitro Enclaves Team 
        <aws-nitro-enclaves-devel@amazon.com>
Subject: Re: [PATCH v1] MAINTAINERS: Update entries from the Nitro Enclaves
 section
Message-ID: <Y2tYUeVXgIo7ONfA@kroah.com>
References: <20221108185912.15792-1-andraprs@amazon.com>
 <Y2qtFONe55pYI7oC@kroah.com>
 <a302bf1b-0263-ccff-b8c9-a3ce9db65f55@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a302bf1b-0263-ccff-b8c9-a3ce9db65f55@amazon.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 08, 2022 at 10:53:34PM +0200, Paraschiv, Andra-Irina wrote:
> 
> 
> On 08.11.2022 21:25, Greg KH wrote:
> > 
> > On Tue, Nov 08, 2022 at 08:59:12PM +0200, Andra Paraschiv wrote:
> > > Update the list of maintainers for the Nitro Enclaves project. Alex
> > > (lexnv@) is not working at Amazon anymore and there will be the same
> > > case for me starting with 2023.
> > > 
> > > Add a reference to the mailing list of the Nitro Enclaves development
> > > team.
> > > 
> > > Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
> > > ---
> > >   MAINTAINERS | 3 +--
> > >   1 file changed, 1 insertion(+), 2 deletions(-)
> > > 
> > > diff --git a/MAINTAINERS b/MAINTAINERS
> > > index 046ff06ff97f..af2c178ba0dc 100644
> > > --- a/MAINTAINERS
> > > +++ b/MAINTAINERS
> > > @@ -14564,10 +14564,9 @@ T:   git git://git.kernel.org/pub/scm/linux/kernel/git/dinguyen/linux.git
> > >   F:   arch/nios2/
> > > 
> > >   NITRO ENCLAVES (NE)
> > > -M:   Andra Paraschiv <andraprs@amazon.com>
> > > -M:   Alexandru Vasile <lexnv@amazon.com>
> > 
> > I need an ack from Alexandru too.
> 
> He is not working at Amazon anymore, but I sent a message to him with the
> reference to this mail thread. Hope that he could see the message and get
> back with a reply on this mail thread.

Ok, if that doesn't happen, just send a version of that patch removing
you.

thanks,

greg k-h
