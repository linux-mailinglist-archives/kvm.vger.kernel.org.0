Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6D656FA132
	for <lists+kvm@lfdr.de>; Mon,  8 May 2023 09:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232717AbjEHHkj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 May 2023 03:40:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232274AbjEHHki (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 May 2023 03:40:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 313BD61B0
        for <kvm@vger.kernel.org>; Mon,  8 May 2023 00:39:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683531592;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kQwHAJ+6rNw2E0iImK30+c/dUgtLShaXatrIAYOgpBc=;
        b=aLds4p7CIa4sUx10szverN5QZCC7396TMvadkr5LqGPgyDzgaScZurSOPzQkoq1jKf6atp
        0c+g7vzjNPNvxEkgWnqomoirurBIsBKQ2KSQEh0/ZTsA/eU7DD4Q7lmorhOYQjjrz3E+By
        gCPST5c8j/17rMIsqDU3y7r0Fnw38jI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-99-m7zSntIsM8GYwhlbz8Rj1w-1; Mon, 08 May 2023 03:39:48 -0400
X-MC-Unique: m7zSntIsM8GYwhlbz8Rj1w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F21F385A5B1;
        Mon,  8 May 2023 07:39:47 +0000 (UTC)
Received: from localhost (dhcp-192-239.str.redhat.com [10.33.192.239])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 92F562026D16;
        Mon,  8 May 2023 07:39:47 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Yong-Xuan Wang <yongxuan.wang@sifive.com>
Cc:     qemu-devel@nongnu.org, qemu-riscv@nongnu.org, rkanwal@rivosinc.com,
        anup@brainfault.org, dbarboza@ventanamicro.com,
        atishp@atishpatra.org, vincent.chen@sifive.com,
        greentime.hu@sifive.com, frank.chang@sifive.com,
        jim.shu@sifive.com, "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Avihai Horon <avihaih@nvidia.com>,
        Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PTACH v2 1/6] update-linux-headers: sync-up header with Linux
 for KVM AIA support
In-Reply-To: <20230505101707.495251a2.alex.williamson@redhat.com>
Organization: Red Hat GmbH
References: <20230505113946.23433-1-yongxuan.wang@sifive.com>
 <20230505113946.23433-2-yongxuan.wang@sifive.com>
 <20230505101707.495251a2.alex.williamson@redhat.com>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Mon, 08 May 2023 09:39:46 +0200
Message-ID: <878rdze0fx.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 05 2023, Alex Williamson <alex.williamson@redhat.com> wrote:

> On Fri,  5 May 2023 11:39:36 +0000
> Yong-Xuan Wang <yongxuan.wang@sifive.com> wrote:
>
>> Update the linux headers to get the latest KVM RISC-V headers with AIA support
>> by the scripts/update-linux-headers.sh.
>> The linux headers is comes from the riscv_aia_v1 branch available at
>> https://github.com/avpatel/linux.git. It hasn't merged into the mainline kernel.
>
> Updating linux-headers outside of code accepted to mainline gets a down
> vote from me.  This sets a poor precedent and can potentially lead to
> complicated compatibility issues.  Thanks,
>
> Alex

Indeed, this needs to be clearly marked as a placeholder patch, and
replaced with a proper header sync after the changes hit the mainline
kernel.

