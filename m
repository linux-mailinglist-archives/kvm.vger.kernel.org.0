Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2B634BF1ED
	for <lists+kvm@lfdr.de>; Tue, 22 Feb 2022 07:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230246AbiBVGMc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 01:12:32 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:59548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbiBVGMX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 01:12:23 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 30F17B458B
        for <kvm@vger.kernel.org>; Mon, 21 Feb 2022 22:11:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645510313;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ih8MMXwzdXytZ9bjsDgPq+sZRBH/8UxRktKvmYqmu7k=;
        b=ChSxCWmLJfmBGrXskJUS/xnzUpKocXmXE63Ss1OlwYuH2RsSoJ840+P9OqLMxMoXXhnTLN
        Bn9n3Gha8hNhesuWqGy9c4ZniX90mTrbW3RsCWqv89AXkyBdQpSe7vlbkVVlnuug6aAi7D
        GIun0iuKc0Q3M2OudiVEqIOfqP1SEJo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-532-eUj0371fN6ShlbnChPJasQ-1; Tue, 22 Feb 2022 01:11:50 -0500
X-MC-Unique: eUj0371fN6ShlbnChPJasQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B1B2D1006AA6;
        Tue, 22 Feb 2022 06:11:48 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.192.66])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 721E078C0F;
        Tue, 22 Feb 2022 06:11:46 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id BBCF91800094; Tue, 22 Feb 2022 07:11:44 +0100 (CET)
Date:   Tue, 22 Feb 2022 07:11:44 +0100
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     Zixuan Wang <zxwang42@gmail.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, marcorr@google.com, erdemaktas@google.com,
        rientjes@google.com, seanjc@google.com, brijesh.singh@amd.com,
        Thomas.Lendacky@amd.com, varad.gautam@suse.com, jroedel@suse.de,
        bp@suse.de
Subject: Re: [kvm-unit-tests PATCH v1 0/3] x86 UEFI: pass envs and args
Message-ID: <20220222061144.st3lrvkt3d6paqqx@sirius.home.kraxel.org>
References: <20220220224234.422499-1-zxwang42@gmail.com>
 <20220221084056.edgpsgqdm2xph4kv@gator>
 <20220221152558.2fwtzrkoq53t66ie@gator>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220221152558.2fwtzrkoq53t66ie@gator>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

  Hi,

> > EFI wrapper scripts for each unit test can be generated to pass the args
> > to the unit test EFI apps automatically. For the environment, the EFI
> > vars can be set as usual for the system. For QEMU, that means creating
> > a VARS.fd and then adding another flash device to the VM to exposes it.
> 
> BTW, this tool from Gerd might be useful for that
> 
> https://gitlab.com/kraxel/edk2-tests/-/blob/master/tools/vars.py

Probably not (yet) as this right now focuses on stuff needed for secure
boot, i.e. enroll certificates etc.

Setting variables with ascii (or unicode) strings should be rather easy
to add though.

take care,
  Gerd

