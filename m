Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FDB74BA570
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 17:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242970AbiBQQJu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 11:09:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242786AbiBQQJl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 11:09:41 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B9321187458
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 08:09:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645114165;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SzsIICnJywRwDGtCimtdQ57/2TMMRpaCW8tMVXcExCo=;
        b=S67ktMEL/23OXs8EKd4fhHpItrGLLru3JwTJnRp/Enq2TH9vn+4LIuLnvviszhHDtbTxNe
        Q6xulHg59NakTibL+DbrBaKck+kWjyyDTqUPF0mx2e3tSXtaz6zy7JS2U1GuOhzy6BYDM0
        tydSpBfLJT6iHJVNkK5b63rj81PU3/c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-575-ppNmokpTNwOqEowRjqlAyw-1; Thu, 17 Feb 2022 11:09:22 -0500
X-MC-Unique: ppNmokpTNwOqEowRjqlAyw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6A5A01091DA2;
        Thu, 17 Feb 2022 16:09:20 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.36.112.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 09AFB70F55;
        Thu, 17 Feb 2022 16:08:56 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
        id 880AA21A4A18; Thu, 17 Feb 2022 17:08:54 +0100 (CET)
From:   Markus Armbruster <armbru@redhat.com>
To:     Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, lvivier@redhat.com,
        thuth@redhat.com, mtosatti@redhat.com,
        richard.henderson@linaro.org, pbonzini@redhat.com,
        armbru@redhat.com, eblake@redhat.com, wangyanan55@huawei.com,
        f4bug@amsat.org, marcel.apfelbaum@gmail.com, eduardo@habkost.net,
        valery.vdovin.s@gmail.com, den@openvz.org,
        Valeriy Vdovin <valeriy.vdovin@virtuozzo.com>
Subject: Re: [PATCH v17] qapi: introduce 'x-query-x86-cpuid' QMP command.
References: <20220121163943.2720015-1-vsementsov@virtuozzo.com>
        <8cfa9b17-e420-0ca6-4e50-ccf2dfd538bb@virtuozzo.com>
Date:   Thu, 17 Feb 2022 17:08:54 +0100
In-Reply-To: <8cfa9b17-e420-0ca6-4e50-ccf2dfd538bb@virtuozzo.com> (Vladimir
        Sementsov-Ogievskiy's message of "Thu, 17 Feb 2022 18:39:21 +0300")
Message-ID: <87mtipscfd.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com> writes:

> Ping :) Any hope that we will merge it one day?)

Up to the x86 CPU maintainers: Paolo & Marcelo.

