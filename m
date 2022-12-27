Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 071386569E2
	for <lists+kvm@lfdr.de>; Tue, 27 Dec 2022 12:24:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231343AbiL0LYD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Dec 2022 06:24:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231616AbiL0LXv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Dec 2022 06:23:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BBB538AD
        for <kvm@vger.kernel.org>; Tue, 27 Dec 2022 03:23:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672140180;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+ZDPVZfZSgqCTOiStaMXYgh1dgYQErIbrpGZNxwdK0w=;
        b=LXWf6yOBL+sgiR6a4tBnLi01CU1jEE9RRBxNpdjro0Ln0hxQ3wImtr16uslxESK6UuLGZC
        W0AfYpZSkaXf7orhUrmjDz8ZwUg62XdJj5iTGj52vvPUt2R04r7bnuitFswFAuglNr/bDL
        gbJgWfO+F47nzi1v233JfBxJpbtr5vk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-373-1vfNHJigPO-QwXoj1Io-kQ-1; Tue, 27 Dec 2022 06:22:58 -0500
X-MC-Unique: 1vfNHJigPO-QwXoj1Io-kQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2C3B5181E3EE;
        Tue, 27 Dec 2022 11:22:58 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EAC3F2026D4B;
        Tue, 27 Dec 2022 11:22:57 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Li RongQing <lirongqing@baidu.com>
Subject: Re: [PATCH v4 00/32] KVM: x86: AVIC and local APIC fixes+cleanups
Date:   Tue, 27 Dec 2022 06:22:29 -0500
Message-Id: <20221227112228.1644133-1-pbonzini@redhat.com>
In-Reply-To: <20221001005915.2041642-1-seanjc@google.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Queued, thanks.  I think I'll do a pass on the commit messages, but
I'm technically on vacation and I'm not sure when I will have time
so I am pushing everything to kvm/queue in the meanwhile.

Paolo


