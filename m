Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7C045F0853
	for <lists+kvm@lfdr.de>; Fri, 30 Sep 2022 12:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231549AbiI3KTF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 06:19:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231251AbiI3KSz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 06:18:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E030015ED24
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 03:18:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664533133;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dx4u6C08o9BTXEfrCLmxC1gx6puUDD58EjxmAp5+vbY=;
        b=SlrEy/7yY7o4iuDlS1uiLCkhFj+zkDNr31/dozP5hAivAEjK5Uz14oeLElWgXCykIx4+Mp
        GuUeWegAmp8M1QcpyL2+IJ88774QT1acXS8oq7Fq5cJzorWlmdghM5h/6vJx/zRTHHFLmX
        R34gx36kOg+awnrBOirdv+cadpX6kTA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-75-uO57ZysoMKitYIcdHD8F-Q-1; Fri, 30 Sep 2022 06:18:50 -0400
X-MC-Unique: uO57ZysoMKitYIcdHD8F-Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6AAE3185A7A4;
        Fri, 30 Sep 2022 10:18:50 +0000 (UTC)
Received: from redhat.com (unknown [10.39.192.112])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D15452166B26;
        Fri, 30 Sep 2022 10:18:48 +0000 (UTC)
Date:   Fri, 30 Sep 2022 12:18:47 +0200
From:   Kevin Wolf <kwolf@redhat.com>
To:     Keith Busch <kbusch@meta.com>
Cc:     qemu-block@nongnu.org, qemu-devel@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv3 0/2] qemu direct io alignment fix
Message-ID: <YzbChwRW7CPAWs7L@redhat.com>
References: <20220929200523.3218710-1-kbusch@meta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220929200523.3218710-1-kbusch@meta.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am 29.09.2022 um 22:05 hat Keith Busch geschrieben:
> From: Keith Busch <kbusch@kernel.org>
> 
> Changes from v2:
> 
>   Split the patch so that the function move is separate from the
>   functional change. This makes it immediately obvious what criteria is
>   changing. (Kevin Wolf)
> 
>   Added received Tested-by tag in the changelog. 
> 
> Keith Busch (2):
>   block: move bdrv_qiov_is_aligned to file-posix
>   block: use the request length for iov alignment

Thanks, applied to the block branch.

Kevin

