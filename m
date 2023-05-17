Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C6C770650E
	for <lists+kvm@lfdr.de>; Wed, 17 May 2023 12:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbjEQKZH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 May 2023 06:25:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjEQKZG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 May 2023 06:25:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7270C3C1E
        for <kvm@vger.kernel.org>; Wed, 17 May 2023 03:24:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684319066;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6kCDd/wHVYniWnWaYfQFj8W3J0td+4UsnrwjwgtLZpc=;
        b=ZGdx04oMk8oCJRfIGMrrLvnT05FBuGDtmEzB+rB9Wgi75uxprbaMN0rqG74XN2lPNkZUmB
        fO10afrayz8wQA2CSDw6qy/HGLnb8DLPYMlIenjzmmAu0ftaEnbvk/IEKQ27ZH/iHj2Sda
        SFqj3gOjRwWop3zhVX/LU2H0ZYg1OEo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-399-lMgLT-zQMsGLAlrxWEDyQQ-1; Wed, 17 May 2023 06:24:21 -0400
X-MC-Unique: lMgLT-zQMsGLAlrxWEDyQQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 890AB101A54F;
        Wed, 17 May 2023 10:24:20 +0000 (UTC)
Received: from localhost (dhcp-192-239.str.redhat.com [10.33.192.239])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5101E1121314;
        Wed, 17 May 2023 10:24:20 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>, steven.price@arm.com,
        kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: arm64: Handle trap of tagged Set/Way CMOs
In-Reply-To: <20230515204601.1270428-3-maz@kernel.org>
Organization: Red Hat GmbH
References: <20230515204601.1270428-1-maz@kernel.org>
 <20230515204601.1270428-3-maz@kernel.org>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Wed, 17 May 2023 12:24:19 +0200
Message-ID: <87ttwb45nw.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 15 2023, Marc Zyngier <maz@kernel.org> wrote:

> We appear to have missed the Set/Way CMOs when adding MTE support.
> Not that we really expect anyone to use them, but you never know
> what stupidity some people can come up with...
>
> Treat these mostly like we deal with the classic S/W CMOs, only
> with an additional check that MTE really is enabled.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

