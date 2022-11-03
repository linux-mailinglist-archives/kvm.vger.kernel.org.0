Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CDF661860C
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 18:22:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231482AbiKCRV6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 13:21:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231537AbiKCRVy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 13:21:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C1631001
        for <kvm@vger.kernel.org>; Thu,  3 Nov 2022 10:20:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667496058;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gPecyOBmCPqvAYGUgQ2yHL/Ag/LomTk0MaZbDEVGXO0=;
        b=aSMH8+bH934u1Hj6XV0akGPqgabLiyrGmBlx1RvCW+vWJR/EiQdHGT+yrH9Hi8u50qEIim
        bWjdenAF8cvy3JdxMohIgFWzLXB8Ol62FYllZ4K/Rg+CXPOBxMhHCQ1fPtXp1VvNYzZ4s5
        4YoN1ZboIFFCmfzemgsYZxQQTXHpOxQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-26-cza9Mj7DMWabG0LD0H1cDw-1; Thu, 03 Nov 2022 13:20:54 -0400
X-MC-Unique: cza9Mj7DMWabG0LD0H1cDw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 30D823C0F448;
        Thu,  3 Nov 2022 17:20:50 +0000 (UTC)
Received: from localhost (unknown [10.39.193.104])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 98E3540C2087;
        Thu,  3 Nov 2022 17:20:49 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, frankja@linux.ibm.com, berrange@redhat.com,
        clg@kaod.org
Subject: Re: [PATCH v11 09/11] s390x/cpu topology: add topology machine
 property
In-Reply-To: <20221103170150.20789-10-pmorel@linux.ibm.com>
Organization: Red Hat GmbH
References: <20221103170150.20789-1-pmorel@linux.ibm.com>
 <20221103170150.20789-10-pmorel@linux.ibm.com>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Thu, 03 Nov 2022 18:20:47 +0100
Message-ID: <87bkpox8cw.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 03 2022, Pierre Morel <pmorel@linux.ibm.com> wrote:

> We keep the possibility to switch on/off the topology on newer
> machines with the property topology=[on|off].
>
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  include/hw/boards.h                |  3 +++
>  include/hw/s390x/cpu-topology.h    |  8 +++-----
>  include/hw/s390x/s390-virtio-ccw.h |  1 +
>  hw/core/machine.c                  |  3 +++
>  hw/s390x/cpu-topology.c            | 19 +++++++++++++++++++
>  hw/s390x/s390-virtio-ccw.c         | 28 ++++++++++++++++++++++++++++
>  util/qemu-config.c                 |  4 ++++
>  qemu-options.hx                    |  6 +++++-
>  8 files changed, 66 insertions(+), 6 deletions(-)
>
> diff --git a/include/hw/boards.h b/include/hw/boards.h
> index 311ed17e18..67147c47bf 100644
> --- a/include/hw/boards.h
> +++ b/include/hw/boards.h
> @@ -379,6 +379,9 @@ struct MachineState {
>      } \
>      type_init(machine_initfn##_register_types)
>  
> +extern GlobalProperty hw_compat_7_2[];
> +extern const size_t hw_compat_7_2_len;

This still needs to go into a separate patch that introduces the 8.0
machine types for the relevant machines... I'll probably write that
patch soon (next week or so), you can pick it then into this series.

> +
>  extern GlobalProperty hw_compat_7_1[];
>  extern const size_t hw_compat_7_1_len;
>  

