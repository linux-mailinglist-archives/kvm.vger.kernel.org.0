Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92C1970650D
	for <lists+kvm@lfdr.de>; Wed, 17 May 2023 12:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbjEQKYY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 May 2023 06:24:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjEQKYV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 May 2023 06:24:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEA773C30
        for <kvm@vger.kernel.org>; Wed, 17 May 2023 03:23:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684319016;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eU4/kWoSUy/twutiXTRQkS0LhOrBuJa5CPATWrYQIws=;
        b=cZnJ/NDU43JSFVlTNYqFqh888XPjse74xI7VeQLbpjRzuLHWDL7T2ykKnPJYqFDtIJmJw/
        yMUvhJtlh4ogmfROpOnuW+fVb9nqjUnD6B2wxAfTQRwcLEI1QG9aic0nAtLftG/5Hg2SLX
        wAmUnT08q0T/W/kSQ70yjgqMDqvvNuI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-581-dyfsjo8GMoOB2aa5YHpVjw-1; Wed, 17 May 2023 06:23:31 -0400
X-MC-Unique: dyfsjo8GMoOB2aa5YHpVjw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 654643C0CD44;
        Wed, 17 May 2023 10:23:30 +0000 (UTC)
Received: from localhost (dhcp-192-239.str.redhat.com [10.33.192.239])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 243804078908;
        Wed, 17 May 2023 10:23:30 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>, steven.price@arm.com,
        kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 1/2] arm64: Add missing Set/Way CMO encodings
In-Reply-To: <20230515204601.1270428-2-maz@kernel.org>
Organization: Red Hat GmbH
References: <20230515204601.1270428-1-maz@kernel.org>
 <20230515204601.1270428-2-maz@kernel.org>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Wed, 17 May 2023 12:23:29 +0200
Message-ID: <87wn1745pa.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
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

> Add the missing Set/Way CMOs that apply to tagged memory.
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/sysreg.h | 6 ++++++
>  1 file changed, 6 insertions(+)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

