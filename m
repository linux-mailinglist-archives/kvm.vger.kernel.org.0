Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19EB3610FDA
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 13:38:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbiJ1Lig (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Oct 2022 07:38:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbiJ1Lif (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Oct 2022 07:38:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91E141D20E8
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 04:37:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666957058;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7oxL0Wn6bgvSdMNJpuJx00jMn03xxj9+wteuUP1B+kQ=;
        b=dda3Ui9xIOkCrDxJu2iWZYBPdKwz39odh+KEdB70bh5MXplMvuHtIR2mjVwQOV37wGj7W0
        szmEVpeuY/txKb1aUvHizN78dQdGlQt8hLvL/O5XDYJf1BO7br8kcB+QcuhXWTf4ztXAYa
        bOixnxTLzQQaR8CfWReIs/PM9sUv5m8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-93-TldeBCsyNLa3XMgP1Ho9Qg-1; Fri, 28 Oct 2022 07:37:37 -0400
X-MC-Unique: TldeBCsyNLa3XMgP1Ho9Qg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B925B3C0F67B;
        Fri, 28 Oct 2022 11:37:36 +0000 (UTC)
Received: from localhost (unknown [10.39.193.13])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6B09949BB61;
        Fri, 28 Oct 2022 11:37:36 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu
Subject: Re: [kvm-unit-tests PATCH] MAINTAINERS: new kvmarm mailing list
In-Reply-To: <20221025160730.40846-1-cohuck@redhat.com>
Organization: Red Hat GmbH
References: <20221025160730.40846-1-cohuck@redhat.com>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Fri, 28 Oct 2022 13:37:34 +0200
Message-ID: <87a65gkwld.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 25 2022, Cornelia Huck <cohuck@redhat.com> wrote:

> KVM/arm64 development is moving to a new mailing list (see
> https://lore.kernel.org/all/20221001091245.3900668-1-maz@kernel.org/);
> kvm-unit-tests should advertise the new list as well.
>
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>  MAINTAINERS | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 90ead214a75d..649de509a511 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -67,7 +67,8 @@ ARM
>  M: Andrew Jones <andrew.jones@linux.dev>
>  S: Supported
>  L: kvm@vger.kernel.org
> -L: kvmarm@lists.cs.columbia.edu
> +L: kvmarm@lists.linux.dev
> +L: kvmarm@lists.cs.columbia.edu (deprecated)

As the days of the Columbia list really seem to be numbered (see
https://lore.kernel.org/all/364100e884023234e4ab9e525774d427@kernel.org/),
should we maybe drop it completely from MAINTAINERS, depending on when
this gets merged?

>  F: arm/
>  F: lib/arm/
>  F: lib/arm64/

