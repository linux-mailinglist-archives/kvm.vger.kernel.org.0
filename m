Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9F3E6ED215
	for <lists+kvm@lfdr.de>; Mon, 24 Apr 2023 18:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232100AbjDXQIP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 12:08:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232009AbjDXQIO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 12:08:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E00C46E98
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 09:07:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682352449;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wNwreOSwlYhvCShYoTkByj025paHY17QQ0wsTtVjClE=;
        b=TZG6KLESzoDYmZ3gsDTSWOtVoVI9Ddr2nRB5mXiKxeGLHFa9pEx4kB0TbWIqYy1cCpDhop
        xyD4K9Ghz36qrYw0hNTshs8kNCJKvpqFfwJCmXSDYiaQL/IgA817tRtpDBEpJA9mYa+4G/
        /to7sAbQQw6QVG/MeYbVSCgzVhosf5s=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-671-byC_9jHaMTOE2fXpUySfBg-1; Mon, 24 Apr 2023 12:07:23 -0400
X-MC-Unique: byC_9jHaMTOE2fXpUySfBg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B452788B7A1;
        Mon, 24 Apr 2023 16:07:22 +0000 (UTC)
Received: from localhost (dhcp-192-239.str.redhat.com [10.33.192.239])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 268D0C15BA0;
        Mon, 24 Apr 2023 16:07:22 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Thomas Huth <thuth@redhat.com>,
        Yong-Xuan Wang <yongxuan.wang@sifive.com>,
        qemu-devel@nongnu.org, qemu-riscv@nongnu.org
Cc:     rkanwal@rivosinc.com, anup@brainfault.org,
        dbarboza@ventanamicro.com, atishp@atishpatra.org,
        vincent.chen@sifive.com, greentime.hu@sifive.com,
        frank.chang@sifive.com, "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Bin Meng <bin.meng@windriver.com>,
        Chenyi Qiang <chenyi.qiang@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH 1/6] update-linux-headers: sync-up header with Linux for
 KVM AIA support
In-Reply-To: <fa91e8cf-2240-ac81-740b-b9d8597f4f59@redhat.com>
Organization: Red Hat GmbH
References: <20230424090716.15674-1-yongxuan.wang@sifive.com>
 <20230424090716.15674-2-yongxuan.wang@sifive.com>
 <fa91e8cf-2240-ac81-740b-b9d8597f4f59@redhat.com>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Mon, 24 Apr 2023 18:07:20 +0200
Message-ID: <87edo9uuvb.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 24 2023, Thomas Huth <thuth@redhat.com> wrote:

> On 24/04/2023 11.07, Yong-Xuan Wang wrote:
>> Sync-up Linux header to get latest KVM RISC-V headers having AIA support.
>> 
>> Signed-off-by: Yong-Xuan Wang <yongxuan.wang@sifive.com>
>> Reviewed-by: Jim Shu <jim.shu@sifive.com>
>> ---
>>   linux-headers/linux/kvm.h |  2 ++
>>   target/riscv/kvm_riscv.h  | 33 +++++++++++++++++++++++++++++++++
>
>   Hi!
>
> Please don't mix updates to linux-headers/ with updates to other files. 
> linux-headers/ should only by updated via the 
> scripts/update-linux-headers.sh script, and then the whole update should be 
> included in the patch, not only selected files.

...and in the cases where you cannot run a normal headers update because
the code has not been accepted into Linux yet, just create a placeholder
patch containing only the linux-headers changes, which can be replaced
with a proper update later.

[I didn't check whether the code is already included in Linux.]

