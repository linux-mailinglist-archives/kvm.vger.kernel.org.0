Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B9EE1DBD35
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 20:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbgETSqG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 14:46:06 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:40131 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726566AbgETSqG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 May 2020 14:46:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590000364;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JdxlV9+3kfjDDkLUzoqBN4uSPGSE70o1REhWjMzumHk=;
        b=LCw4vOF9pFXftK6WV4mvhKTkQwa+/KYMltLbA1S8AkWz49E6+2g3f/JIUO4RTsG+W62lFq
        /8J19n4s+j907a2jBiw4+lm+8qsA+1UxfiFt7xH0QvBA2dSCdTh1k+o142Ap45tgD0RZ6W
        Lx5UtMSuJQBhm+wMDnPRyFwcPVoteQk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-4-xp6Y2zEbPDq9VHNA6uRsxg-1; Wed, 20 May 2020 14:46:01 -0400
X-MC-Unique: xp6Y2zEbPDq9VHNA6uRsxg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 12C11100CCC2;
        Wed, 20 May 2020 18:46:00 +0000 (UTC)
Received: from starship (unknown [10.35.207.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E495D579A3;
        Wed, 20 May 2020 18:45:57 +0000 (UTC)
Message-ID: <cfabdf8a0f21c9c77744f1fd3efd0c9d87c9763f.camel@redhat.com>
Subject: Re: [PATCH 1/1] thunderbolt: add trivial .shutdown
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Michael Jamet <michael.jamet@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andreas Noever <andreas.noever@gmail.com>,
        "open list:THUNDERBOLT DRIVER" <linux-usb@vger.kernel.org>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        Jiri Kosina <trivial@kernel.org>
Date:   Wed, 20 May 2020 21:45:56 +0300
In-Reply-To: <20200520181240.118559-2-mlevitsk@redhat.com>
References: <20200520181240.118559-1-mlevitsk@redhat.com>
         <20200520181240.118559-2-mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2020-05-20 at 21:12 +0300, Maxim Levitsky wrote:
> On my machine, a kexec with this driver loaded in the old kernel
> causes a very long delay on boot in the kexec'ed kernel,
> most likely due to unclean shutdown prior to that.
> 
> Unloading thunderbolt driver prior to kexec allows kexec to work as fast
> as regular kernel boot, as well as adding this .shutdown pointer.
> 
> Shutting a device prior to the shutdown completely is always
> a good idea IMHO to help with kexec,
> and this one-liner patch implements it.
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  drivers/thunderbolt/nhi.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/thunderbolt/nhi.c b/drivers/thunderbolt/nhi.c
> index 1be491ecbb45..4046642e6aec 100644
> --- a/drivers/thunderbolt/nhi.c
> +++ b/drivers/thunderbolt/nhi.c
> @@ -1285,6 +1285,7 @@ static struct pci_driver nhi_driver = {
>  	.id_table = nhi_ids,
>  	.probe = nhi_probe,
>  	.remove = nhi_remove,
> +	.shutdown = nhi_remove,
>  	.driver.pm = &nhi_pm_ops,
>  };
>  
Oops, I see that I posted this little fix on a wrong mailing list.
I didn't update the script correctly.
Sorry for the noise!

Best regards,
	Maxim Levitsky


