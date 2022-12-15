Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE5E64DD02
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 15:41:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbiLOOlr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 09:41:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiLOOlp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 09:41:45 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B067C26A9F
        for <kvm@vger.kernel.org>; Thu, 15 Dec 2022 06:41:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671115260;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iiNRT3Z+VXRpHXGCuiCCrc0gUVtdd/9Lb468/WGVt1o=;
        b=EStUoAXKbT3ElfgTXN2O2ertyw2hzm98lIiYmDB8TE6KBLx+rl5n+ZyFRQSEzqKsTrT7CQ
        TJ/s3HRn+cdsEyUF9Ko1SlcJOMe/Af5JwNHVkd4K14NnCNtkVqtITOxvBpThlPgctraLEW
        gs6UbcSrPMhe8dbdjAOskKz7qiQvsaw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-671-yyyh58QGOCuunUHzUiNqJA-1; Thu, 15 Dec 2022 09:40:59 -0500
X-MC-Unique: yyyh58QGOCuunUHzUiNqJA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 84CF3101A52E
        for <kvm@vger.kernel.org>; Thu, 15 Dec 2022 14:40:59 +0000 (UTC)
Received: from localhost (dhcp-192-239.str.redhat.com [10.33.192.239])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 416C814171BE;
        Thu, 15 Dec 2022 14:40:59 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Sandro Bonazzola <sbonazzo@redhat.com>, kvm@vger.kernel.org
Subject: Re: Broken link on Virtio page
In-Reply-To: <CAPQRNTnV_Y+jrGA4+5j_WyGP3jaAC6zuBLLNHwYzwWM=xEr-DA@mail.gmail.com>
Organization: Red Hat GmbH
References: <CAPQRNTnV_Y+jrGA4+5j_WyGP3jaAC6zuBLLNHwYzwWM=xEr-DA@mail.gmail.com>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Thu, 15 Dec 2022 15:40:57 +0100
Message-ID: <877cys687a.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 25 2022, Sandro Bonazzola <sbonazzo@redhat.com> wrote:

> Hi, just noticed that within http://www.linux-kvm.org/page/Virtio
> page, the link for "kvm-guest-drivers-linux.git" pointing to
> https://git.kernel.org/pub/scm/virt/kvm/kvm-guest-drivers-linux.git
> leads to a page with "No repositories found".
> I'm not sure where to report it but http://www.linux-kvm.org/page/Bugs
> suggest writing here.

Thank you for your report... the broken link was actually the least of
that page's problems; we just condensed it to basically refer to the
virtio specification.

