Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09D696644B7
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 16:27:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238884AbjAJP1v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 10:27:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238544AbjAJP1W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 10:27:22 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D85878B773
        for <kvm@vger.kernel.org>; Tue, 10 Jan 2023 07:26:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673364364;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=i6XtrwS2g47AdWhbEHN9QxRlwgfhH48+9cdffawOCUI=;
        b=CHWJABmMZvyjQ0XDQMUN6RljeWO8JThi6FcXYNGOX+6L0Cyqr6RTlYUlHwxAfcCFEHkIJo
        pifhonnL/XNBJtfZw/pqTyQsWQeulmhQuYHfmte9/TEHSiPiVsDY2nmgXUO76KTG0WaEhy
        8GNZ8dfA1/R/KxONyZKn3IYUkJUgn4Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-352-UzlE0oBPO_GxGR-NOcFOBQ-1; Tue, 10 Jan 2023 10:26:02 -0500
X-MC-Unique: UzlE0oBPO_GxGR-NOcFOBQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7DDF7811E6E;
        Tue, 10 Jan 2023 15:26:02 +0000 (UTC)
Received: from pinwheel (unknown [10.39.194.198])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C8BCC53AA;
        Tue, 10 Jan 2023 15:26:00 +0000 (UTC)
Date:   Tue, 10 Jan 2023 16:25:57 +0100
From:   Kashyap Chamarthy <kchamart@redhat.com>
To:     Wang Yong <yongw.kernel@gmail.com>
Cc:     corbet@lwn.net, pbonzini@redhat.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] Documentation: KVM: fix typos in
 running-nested-guests.rst
Message-ID: <Y72DhSk7GkUPfqch@pinwheel>
References: <20230110150046.549755-1-yongw.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230110150046.549755-1-yongw.kernel@gmail.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 10, 2023 at 03:00:46PM +0000, Wang Yong wrote:
> change "gues" to "guest" and remove redundant ")".
> 
> Signed-off-by: Wang Yong <yongw.kernel@gmail.com>
> ---
>  Documentation/virt/kvm/x86/running-nested-guests.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/virt/kvm/x86/running-nested-guests.rst b/Documentation/virt/kvm/x86/running-nested-guests.rst
> index a27e6768d900..71136fe1723b 100644
> --- a/Documentation/virt/kvm/x86/running-nested-guests.rst
> +++ b/Documentation/virt/kvm/x86/running-nested-guests.rst
> @@ -150,7 +150,7 @@ able to start an L1 guest with::
>      $ qemu-kvm -cpu host [...]
>  
>  The above will pass through the host CPU's capabilities as-is to the
> -gues); or for better live migration compatibility, use a named CPU
> +guest, or for better live migration compatibility, use a named CPU

Nice catch.  Thanks!

Reviewed-by: Kashyap Chamarthy <kchamart@redhat.com> 

[...]

-- 
/kashyap

