Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD2B85E6D96
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 23:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbiIVVEp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 17:04:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230267AbiIVVEm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 17:04:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 632B121273
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 14:04:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663880678;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=YzHxALV+dtNKV2cmLW04c4d5fBaRFhjfIoqby1b0QmvfAy4ZVXW1eZnly7FbqFStw0nw89
        WlvVxHJ9MLUGiFw7Hi2B5MQAUppc7mOFQzGYGVbD+ZDA8r3fnupgO1IaZ77DmYLAuQXetE
        irYHBm8mogrTL5tIh3R5KArJVvu/QWk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-675-8cf7JYkpM7Wtx_8hepKodQ-1; Thu, 22 Sep 2022 17:04:34 -0400
X-MC-Unique: 8cf7JYkpM7Wtx_8hepKodQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9EC21185A79C;
        Thu, 22 Sep 2022 21:04:33 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6CA6440C2064;
        Thu, 22 Sep 2022 21:04:33 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Leonardo Bras <leobras@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH 0/3] KVM: x86: Fix XSAVE related bugs
Date:   Thu, 22 Sep 2022 17:04:31 -0400
Message-Id: <20220922210431.1744112-1-pbonzini@redhat.com>
In-Reply-To: <20220824033057.3576315-1-seanjc@google.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Queued, thanks.

Paolo


