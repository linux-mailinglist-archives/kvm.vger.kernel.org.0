Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D24A25996AA
	for <lists+kvm@lfdr.de>; Fri, 19 Aug 2022 10:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347424AbiHSIBY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Aug 2022 04:01:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347373AbiHSIBC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Aug 2022 04:01:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EA4BDFB5A
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 01:00:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660896058;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=Gwz13PG3TB1fvTO3qattAJVZdsQO1cqs6RIJLJA5C7yLJQmiYr4rzah7+l24JVqNU9VZeO
        Y3+BElvA+xD31P7YqmD+3EtqAHzo7hxdBoocZXvjusKKnx2Zems2ZYRWDmoSCsBUZbhKb7
        +ykH6ixVvmWsFvVZfEAGowFdSfAvIOI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-421-rv7fmICnP6q4qW_aqL_edA-1; Fri, 19 Aug 2022 04:00:52 -0400
X-MC-Unique: rv7fmICnP6q4qW_aqL_edA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 39B4F3C0F361;
        Fri, 19 Aug 2022 08:00:52 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 120422166B26;
        Fri, 19 Aug 2022 08:00:52 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Li kunyu <kunyu@nfschina.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: Drop unnecessary initialization of "npages" in hva_to_pfn_slow() initialized and assigned, it is used after assignment
Date:   Fri, 19 Aug 2022 04:00:50 -0400
Message-Id: <20220819080050.2328578-1-pbonzini@redhat.com>
In-Reply-To: <20220819022804.483914-1-kunyu@nfschina.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Queued, thanks.

Paolo


