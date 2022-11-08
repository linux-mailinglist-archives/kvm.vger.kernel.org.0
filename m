Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78908621CF9
	for <lists+kvm@lfdr.de>; Tue,  8 Nov 2022 20:25:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbiKHTZP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 14:25:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbiKHTZN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 14:25:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9219C627F6;
        Tue,  8 Nov 2022 11:25:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E55861746;
        Tue,  8 Nov 2022 19:25:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01BC7C433D6;
        Tue,  8 Nov 2022 19:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667935511;
        bh=Tl+sd/WmgEXJJgzfFNpIkczw2dQsoHcQ6onWPXBuYLQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XSe75mgMDvzi5N2l27FbAJmeXGi3D8X5xefDm/6jhiNCpfB5FXIeriL8yFeVUs2rt
         4eHkv2uAs8CaSipLDBwegX2/1gZWvaclDZqPaaMs/ldQYIsBJflIwNpAgF4nJHTiag
         NFw1VjH3D3oHzMFoCPbrO+fDdJ+/v9mJFpPXZ3dE=
Date:   Tue, 8 Nov 2022 20:25:08 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Andra Paraschiv <andraprs@amazon.com>
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
Message-ID: <Y2qtFONe55pYI7oC@kroah.com>
References: <20221108185912.15792-1-andraprs@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108185912.15792-1-andraprs@amazon.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 08, 2022 at 08:59:12PM +0200, Andra Paraschiv wrote:
> Update the list of maintainers for the Nitro Enclaves project. Alex
> (lexnv@) is not working at Amazon anymore and there will be the same
> case for me starting with 2023.
> 
> Add a reference to the mailing list of the Nitro Enclaves development
> team.
> 
> Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
> ---
>  MAINTAINERS | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 046ff06ff97f..af2c178ba0dc 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -14564,10 +14564,9 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/dinguyen/linux.git
>  F:	arch/nios2/
>  
>  NITRO ENCLAVES (NE)
> -M:	Andra Paraschiv <andraprs@amazon.com>
> -M:	Alexandru Vasile <lexnv@amazon.com>

I need an ack from Alexandru too.

>  M:	Alexandru Ciobotaru <alcioa@amazon.com>
>  L:	linux-kernel@vger.kernel.org
> +L:	The AWS Nitro Enclaves Team <aws-nitro-enclaves-devel@amazon.com>

Ick, really?  Why?  That takes all personal responsibility away from the
real maintainer.

thanks,

greg k-h
