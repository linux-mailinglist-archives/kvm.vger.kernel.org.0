Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFA8874391B
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 12:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233064AbjF3KNE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 06:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232832AbjF3KNC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 06:13:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2C2B10A
        for <kvm@vger.kernel.org>; Fri, 30 Jun 2023 03:12:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688119935;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GJnG5qQNzK5f1dQ5KBCwnGhfQBb6PVZfr3fE+pEYwUw=;
        b=etusAHFHZ2jF7NqqO9mxNc7SWEiGG50ffxsuR7o7OGQl8ADRklVGGKQwYuH620b8zOr4VM
        IsNRfLELN+ImYOSeUVY5pDOr0o0h4J73EpUPyo/KBr2sfr2RWBJHWkRhmC9/W9Yzo+QK4v
        zfsFmCDxa1aSZOA9FzUvVsF+tAPhQ0I=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-457-HV3rX0wFOKqO0FPwqzWaiQ-1; Fri, 30 Jun 2023 06:12:11 -0400
X-MC-Unique: HV3rX0wFOKqO0FPwqzWaiQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F1769185A792;
        Fri, 30 Jun 2023 10:12:10 +0000 (UTC)
Received: from localhost (unknown [10.39.193.108])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5DB9F200A3AD;
        Fri, 30 Jun 2023 10:12:10 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        Yong-Xuan Wang <yongxuan.wang@sifive.com>,
        qemu-devel@nongnu.org, qemu-riscv@nongnu.org
Cc:     rkanwal@rivosinc.com, anup@brainfault.org, atishp@atishpatra.org,
        vincent.chen@sifive.com, greentime.hu@sifive.com,
        frank.chang@sifive.com, jim.shu@sifive.com,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Thomas Huth <thuth@redhat.com>, Peter Xu <peterx@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v4 1/6] update-linux-headers: sync-up header with Linux
 for KVM AIA support placeholder
In-Reply-To: <e21ea550-20f6-257b-549d-75b1d5efe0a1@ventanamicro.com>
Organization: Red Hat GmbH
References: <20230621145500.25624-1-yongxuan.wang@sifive.com>
 <20230621145500.25624-2-yongxuan.wang@sifive.com>
 <e21ea550-20f6-257b-549d-75b1d5efe0a1@ventanamicro.com>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Fri, 30 Jun 2023 12:11:57 +0200
Message-ID: <874jmp45ua.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 30 2023, Daniel Henrique Barboza <dbarboza@ventanamicro.com> wrote:

> On 6/21/23 11:54, Yong-Xuan Wang wrote:
>> Sync-up Linux header to get latest KVM RISC-V headers having AIA support.
>> 
>> Note: This is a placeholder commit and could be replaced when all referenced Linux patchsets are mainlined.
>> 
>> The linux-headers changes are from 2 different patchsets.
>> [1] https://lore.kernel.org/lkml/20230404153452.2405681-1-apatel@ventanamicro.com/
>> [2] https://www.spinics.net/lists/kernel/msg4791872.html
>
>
> It looks like Anup sent a PR for [2] for Linux 6.5. IIUC this would be then a 6.5
> linux-header update.
>
> In this case I'm not sure whether we can pick this up for QEMU 8.1 (code freeze is
> July 10th) since we can't keep a 6.5 placeholder header. I'll let Alistair comment
> on that.

My crystal ball says that we'll have Linux 6.5-rc1 on July 9th, which
is... probably too late, given the need for a repost with a proper
headers update etc. (I'd generally prefer not to do the headers update
on a random middle-of-the-merge-window commit...)

