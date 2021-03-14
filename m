Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E020333A343
	for <lists+kvm@lfdr.de>; Sun, 14 Mar 2021 07:12:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234322AbhCNGJj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 14 Mar 2021 01:09:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234393AbhCNGJX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 14 Mar 2021 01:09:23 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1234::107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 682B3C061574;
        Sat, 13 Mar 2021 22:09:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=+Oee/V4rK7yNOumlFty9Zh63SCA3HWo/TInQeKZ45Ko=; b=SXVHknynPZvPNaRRl9WborE40P
        M9WVQGOOegtvuJ4ZvFxMZIT2uj/DtitfU1EkDsDtWty5Rt7lGB2z/Co4D8swUHlyJ77d/bzwGYQQT
        NYurh6NvcvsBiA052mAboBwd7xwEJuFmbymdzQZFV17oFBHsE5WGI/djGOEtKVJmVZExO8JTVF5Sf
        9hRvXPEj0kmz9+CmSIh+M2lTCQ2IFYbOcdWwwpUdX2L6jXHE6ujjkKl8VR3EuDv5XDGabvOB8tJDn
        GD8KgWqP/I/vEqpMdEHAgkQi/Lg9/Krhdyid2acOxOPC7kKQFWdErT2J/Kc6cf+S53PJ/Yl/dRsJV
        M+uiJ37Q==;
Received: from [2601:1c0:6280:3f0::9757]
        by merlin.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lLJwA-001B4d-J0; Sun, 14 Mar 2021 06:09:15 +0000
Subject: Re: [PATCH] vfio: pci: Spello fix in the file vfio_pci.c
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        alex.williamson@redhat.com, cohuck@redhat.com,
        kevin.tian@intel.com, akpm@linux-foundation.org, peterx@redhat.com,
        giovanni.cabiddu@intel.com, walken@google.com, jannh@google.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210314052925.3560-1-unixbhaskar@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <d5dfb64a-e2b4-4080-9cff-60f453ade087@infradead.org>
Date:   Sat, 13 Mar 2021 22:09:11 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210314052925.3560-1-unixbhaskar@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/13/21 9:29 PM, Bhaskar Chowdhury wrote:
> 
> s/permision/permission/
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

> ---
>  drivers/vfio/pci/vfio_pci.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index 706de3ef94bb..62f137692a4f 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -2411,7 +2411,7 @@ static int __init vfio_pci_init(void)
>  {
>  	int ret;
> 
> -	/* Allocate shared config space permision data used by all devices */
> +	/* Allocate shared config space permission data used by all devices */
>  	ret = vfio_pci_init_perm_bits();
>  	if (ret)
>  		return ret;
> --


-- 
~Randy

