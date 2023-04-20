Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1F286E8E9D
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 11:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234237AbjDTJvz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Apr 2023 05:51:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234047AbjDTJvd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Apr 2023 05:51:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EF50768E
        for <kvm@vger.kernel.org>; Thu, 20 Apr 2023 02:49:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681984185;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=J4d7x1cNgCskwTe9CHC2x/9xeLP77gPxzHC/FoirtyI=;
        b=ZPiW28qR6jEflZzrWpo6Sgr4cGfShz0IU0kS9ffiMsPiApPsiF9VxvTYgIYu8UwTth0sCF
        sPMToLNvJFFQaHkErLSdf8BiMx5zeUx6Y/tRV/kQxKIAd8hRJJgTOJ5mmJVoxQ9+QNA+7x
        JQ6Dlb+ZXk2JDFqZsEqtuEO+KnhImT8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-349-fdZoozD2NJe0vaZzJWZOzw-1; Thu, 20 Apr 2023 05:49:44 -0400
X-MC-Unique: fdZoozD2NJe0vaZzJWZOzw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B8B8038237C8;
        Thu, 20 Apr 2023 09:49:43 +0000 (UTC)
Received: from localhost (dhcp-192-239.str.redhat.com [10.33.192.239])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6FE0C40C2064;
        Thu, 20 Apr 2023 09:49:43 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Tianrui Zhao <zhaotianrui@loongson.cn>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        gaosong@loongson.cn
Cc:     "Michael S . Tsirkin" <mst@redhat.com>, maobibo@loongson.cn,
        zhaotianrui@loongson.cn
Subject: Re: [PATCH RFC v1 01/10] linux-headers: Add KVM headers for loongarch
In-Reply-To: <20230420093606.3366969-2-zhaotianrui@loongson.cn>
Organization: Red Hat GmbH
References: <20230420093606.3366969-1-zhaotianrui@loongson.cn>
 <20230420093606.3366969-2-zhaotianrui@loongson.cn>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Thu, 20 Apr 2023 11:49:41 +0200
Message-ID: <87bkji51e2.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 20 2023, Tianrui Zhao <zhaotianrui@loongson.cn> wrote:

> Add asm-loongarch/kvm.h for loongarch KVM, and update
> the linux/kvm.h about loongarch part. The structures in
> the header are used as kvm_ioctl arguments.

Just a procedural note: It's probably best to explicitly mark this as a
placeholder patch until you can replace it with a full headers update.

>
> Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
> ---
>  linux-headers/asm-loongarch/kvm.h | 99 +++++++++++++++++++++++++++++++
>  linux-headers/linux/kvm.h         |  9 +++
>  2 files changed, 108 insertions(+)
>  create mode 100644 linux-headers/asm-loongarch/kvm.h

