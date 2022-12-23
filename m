Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 958F9655318
	for <lists+kvm@lfdr.de>; Fri, 23 Dec 2022 18:11:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231547AbiLWRKl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Dec 2022 12:10:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230353AbiLWRKj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Dec 2022 12:10:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7500624A
        for <kvm@vger.kernel.org>; Fri, 23 Dec 2022 09:09:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671815396;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=B07f/z4H7nuIC2OvqUOwazeoqWtUvv6kz2qjN3Wqq8v92OfsfRqIZaZ7+Syoua1W4/GQFe
        16B07zD1wVp7GRcg9P1P+o3sITM1bwhxcdZvAaR6fKdwClMMMdn0oGpycTEQVXRunuln/P
        K+9T3NJV5IvuM7JEO74tMcX6ueQZB8M=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-524-Vem5dwABNxy8ip3E_IAQOw-1; Fri, 23 Dec 2022 12:09:53 -0500
X-MC-Unique: Vem5dwABNxy8ip3E_IAQOw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E7CB438041DA;
        Fri, 23 Dec 2022 17:09:52 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C1558492C14;
        Fri, 23 Dec 2022 17:09:52 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Hao Peng <flyingpenghao@gmail.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: Simplify kvm_apic_hw_enabled
Date:   Fri, 23 Dec 2022 12:09:37 -0500
Message-Id: <20221223170937.1622600-1-pbonzini@redhat.com>
In-Reply-To: <CAPm50aJ=BLXNWT11+j36Dd6d7nz2JmOBk4u7o._5FNPQ0N61ODu1g@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Queued, thanks.

Paolo


