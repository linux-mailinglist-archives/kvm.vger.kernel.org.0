Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3AFE768040
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 17:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231539AbjG2PFY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 29 Jul 2023 11:05:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbjG2PFX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 29 Jul 2023 11:05:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE6CA180
        for <kvm@vger.kernel.org>; Sat, 29 Jul 2023 08:04:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690643081;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=NOXo4KWlwB6c7NSyRqHMYafh9ULFZPgIUa1u+jecIHROLBf+Zg64GgjAR1/7OiX6HpI0mr
        s+YZFB+R5uoPTgzNNYiWjwmlvXnzo30Ww08HoDFVviaBa+vx/YDIOCKBBgmuEavflxLl09
        YLHdU7xAdA4p6nN4VZoKKseHqCAasYk=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-538-iLvJaf07N4qx52V4CF9LDg-1; Sat, 29 Jul 2023 11:04:38 -0400
X-MC-Unique: iLvJaf07N4qx52V4CF9LDg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8CAE038035B8;
        Sat, 29 Jul 2023 15:04:37 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 60CC8140E949;
        Sat, 29 Jul 2023 15:04:37 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+5feef0b9ee9c8e9e5689@syzkaller.appspotmail.com,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH 0/3] KVM: x86: CR0 vs. KVM_SET_SREGS and !URG
Date:   Sat, 29 Jul 2023 11:04:36 -0400
Message-Id: <20230729150436.2690718-1-pbonzini@redhat.com>
In-Reply-To: <20230613203037.1968489-1-seanjc@google.com>
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


