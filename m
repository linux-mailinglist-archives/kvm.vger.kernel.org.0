Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD6D676803E
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 17:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232090AbjG2PDG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 29 Jul 2023 11:03:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232093AbjG2PDE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 29 Jul 2023 11:03:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B4A83A9B
        for <kvm@vger.kernel.org>; Sat, 29 Jul 2023 08:02:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690642933;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=PqkHRLOEAxC7NIea3lf92u8YQWKLgIliSrPMUUQz4teBmOs5E3WGcIHBkgamch4AWB7CvQ
        fTX79iuASt88gybahZkOyws4urzqiNOH/hnI2HlrbpZL8C8ob9k1p6SQGj6SUfUB9Taodk
        xbV99QWn5kKO2c0tidYUrj/GLmQiNeQ=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-586-DvJ593dKMPu6BtSmVSPnkQ-1; Sat, 29 Jul 2023 11:02:08 -0400
X-MC-Unique: DvJ593dKMPu6BtSmVSPnkQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6EB9A3C025B4;
        Sat, 29 Jul 2023 15:02:08 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3A097145414E;
        Sat, 29 Jul 2023 15:02:08 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zheng Zhang <zheng.zhang@email.ucr.edu>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 0/7] KVM: Grab KVM references for stats fds
Date:   Sat, 29 Jul 2023 11:02:06 -0400
Message-Id: <20230729150206.2690511-1-pbonzini@redhat.com>
In-Reply-To: <20230711230131.648752-1-seanjc@google.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Queued, thanks.

Paolo


