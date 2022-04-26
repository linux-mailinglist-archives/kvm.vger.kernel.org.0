Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D86925104B8
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 18:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353492AbiDZQ7n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 12:59:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346075AbiDZQ7m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 12:59:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CBB0668314
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 09:56:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650992193;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QtXqIIhIDAbnlR4eZU+LE64le4BBB2lbcQRdoBNZB+8=;
        b=TKI+TKJEyfr3H0yUZiulSRAxjWEMW5dKUUT4Whu2mtCdV8FwsVu61Nq2qZdWcKVudf5YBA
        S+BxJ860MsDHETkHiWaQcULBjKNYethoQCEMR0lGDECJueTCXAYtzwHSDQOgJzWtqlASb+
        1PiXyQKafCinn2cAaSWk6wCN9dpm7Mo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-287-e7HVxTzkM2ubqBpxTJr_0w-1; Tue, 26 Apr 2022 12:56:30 -0400
X-MC-Unique: e7HVxTzkM2ubqBpxTJr_0w-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3847180005D;
        Tue, 26 Apr 2022 16:56:30 +0000 (UTC)
Received: from starship (unknown [10.40.192.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E606054ED11;
        Tue, 26 Apr 2022 16:56:28 +0000 (UTC)
Message-ID: <cacc63c3f3067a87ea9ea0a871a749e0c8ae1438.camel@redhat.com>
Subject: Re: kvm_gfn_to_pfn_cache_refresh started getting a warning recently
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>
Date:   Tue, 26 Apr 2022 19:56:27 +0300
In-Reply-To: <YmghjwgcSZzuH7Rb@google.com>
References: <e415e20f899407fb24dfb8ecbc1940c5cb14a302.camel@redhat.com>
         <YmghjwgcSZzuH7Rb@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-04-26 at 16:45 +0000, Sean Christopherson wrote:
> On Tue, Apr 26, 2022, Maxim Levitsky wrote:
> > [  390.511995] BUG: sleeping function called from invalid context at include/linux/highmem-internal.h:161
> > [  390.513681] in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 4439, name: CPU 0/KVM
> 
> This is my fault.  memremap() can sleep as well.  I'll work on a fix.
> 

Thanks!

Best regards,
	Maxim Levitsky

