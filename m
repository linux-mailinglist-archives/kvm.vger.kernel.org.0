Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 705E83FC5E4
	for <lists+kvm@lfdr.de>; Tue, 31 Aug 2021 13:33:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241011AbhHaKcl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Aug 2021 06:32:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56606 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240974AbhHaKcj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 31 Aug 2021 06:32:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630405904;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iDmfAE25AYZuDoWmja5sA/o3fAybILCuYeFelffUSqI=;
        b=bvE8rAsKGJq7bl0h3wIAq83boNZ9m3KEpHnd5SsPLmf9BJM9adF/V5ZTbhcjP1MByiJUMw
        RYT4SAOcTr8sUegJQgJtV1paICacHRRGa8cXh0/fcU5x6FsS9tselvGm7ZOYcLpDNHGTRr
        CC7kKX4C8rY3ORUJrRHKw/SrcNyVbek=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-589-GXpJAv4BPVuW9ArhMGhtHg-1; Tue, 31 Aug 2021 06:31:42 -0400
X-MC-Unique: GXpJAv4BPVuW9ArhMGhtHg-1
Received: by mail-ej1-f71.google.com with SMTP id ga42-20020a1709070c2a00b005dc8c1cc3a1so2412820ejc.17
        for <kvm@vger.kernel.org>; Tue, 31 Aug 2021 03:31:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iDmfAE25AYZuDoWmja5sA/o3fAybILCuYeFelffUSqI=;
        b=IcQ3YIWNJi7hmznnrfMnHfGaGsgP+hOew2UEn3fcGeAFXlaoIjU82F6QMVS6fK7jcl
         yycWdMyFYRGspnnp3Cq6EyQXSsO539gc3OhQ2XU6met7JVJYDXjoUOcThTZB1csz1ltu
         L2WWCQkDBI731UcxgUpAE6XsIf10MgT2YIsth7+slyBrxXLnJm4IXCRjjP2RAfN7TPEv
         f01Sh5mgaJpzeV0jHdwRLpS6mZaopDNps5a33wxCQz3qfnERX6D75MrHm2m+/0t/H2IG
         6rmYveMm/f+/ij6yCB2ML4Jq9iMo/CIOBaZDEwnFiFKbC+o/dSfY7vOdIrpJMFacTmEJ
         gyBQ==
X-Gm-Message-State: AOAM530BXfRE9Z1223TBTXhO2UxEDGfl6EZxf/FqjzcSYVkOjPtjCRiF
        9NSc2tWj2HbrKhDeuBk0ROM1qcrEr3EqsbWzXD1aAH6FzReXvAdIVj6Nt7M0Z7estvovIOsa8gh
        HBXghl7DzRGNJTjSW+ZqxXZqnwtgqcPDZP2POChueDzh3KbWorx2rImQCfsswIso=
X-Received: by 2002:a17:906:8506:: with SMTP id i6mr30334131ejx.397.1630405901767;
        Tue, 31 Aug 2021 03:31:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzuX/ZKsLu6Pj93uKUeF7zLdO/I9xCHphBGvDKhVoVYHN4cOtIWKxE3k7rUbpRqAwVZ5frEDg==
X-Received: by 2002:a17:906:8506:: with SMTP id i6mr30334111ejx.397.1630405901601;
        Tue, 31 Aug 2021 03:31:41 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id j5sm145822ejb.96.2021.08.31.03.31.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 03:31:41 -0700 (PDT)
Date:   Tue, 31 Aug 2021 12:31:39 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pmorel@linux.ibm.com, thuth@redhat.com, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com, imbrenda@linux.ibm.com,
        pbonzini@redhat.com
Subject: Re: [PATCH kvm-unit-tests v2] Makefile: Don't trust PWD
Message-ID: <20210831103139.4zsei3wctu7hli5f@gator.home>
References: <20210827105407.313916-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210827105407.313916-1-drjones@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 27, 2021 at 12:54:07PM +0200, Andrew Jones wrote:
> PWD comes from the environment and it's possible that it's already
> set to something which isn't the full path of the current working
> directory. Use the make variable $(CURDIR) instead.
> 
> Suggested-by: Thomas Huth <thuth@redhat.com>
> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Makefile b/Makefile
> index f7b9f28c9319..6792b93c4e16 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -119,7 +119,7 @@ cscope: cscope_dirs = lib lib/libfdt lib/linux $(TEST_DIR) $(ARCH_LIBDIRS) lib/a
>  cscope:
>  	$(RM) ./cscope.*
>  	find -L $(cscope_dirs) -maxdepth 1 \
> -		-name '*.[chsS]' -exec realpath --relative-base=$(PWD) {} \; | sort -u > ./cscope.files
> +		-name '*.[chsS]' -exec realpath --relative-base=$(CURDIR) {} \; | sort -u > ./cscope.files
>  	cscope -bk
>  
>  .PHONY: tags
> -- 
> 2.31.1
>

Applied to misc/queue and merged to master.

Thanks,
drew

