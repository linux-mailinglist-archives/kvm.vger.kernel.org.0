Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B26C86CA762
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 16:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231928AbjC0OUJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 10:20:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232303AbjC0OT3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 10:19:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B6F049E7
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 07:17:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679926637;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cyh9GNwkSeiWX8VVWJet6cmrStrv1Y1BhHYKMAKCy08=;
        b=HRkN8fN8y+0nxVBLiR9t6WeYbrmB6S9eVOhMB0tIcGeykuzmFUb7GxOaRsJD/XgfHZkWcV
        T4E4r2mX/4AN99+Ug4lOv1YTOFJIbkeP5PEDQAutLu46o4paOuFIL7pANy6lI7rVUbwC/+
        lQeoFUOzpWKMjxC5fWnotoLI0WI3UPk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-558-IN4AXaFYPoicFjUtqOzhCQ-1; Mon, 27 Mar 2023 10:13:59 -0400
X-MC-Unique: IN4AXaFYPoicFjUtqOzhCQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 49CBB1C12990;
        Mon, 27 Mar 2023 14:13:58 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 16AB0492C18;
        Mon, 27 Mar 2023 14:13:58 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        zhangjianguo <zhangjianguo18@huawei.com>,
        syzbot+760a73552f47a8cd0fd9@syzkaller.appspotmail.com,
        syzbot+8accb43ddc6bd1f5713a@syzkaller.appspotmail.com
Subject: Re: [PATCH] KVM: x86: Suppress pending MMIO write exits if emulator detects exception
Date:   Mon, 27 Mar 2023 10:13:57 -0400
Message-Id: <20230327141357.3751772-1-pbonzini@redhat.com>
In-Reply-To: <20230322141220.2206241-1-seanjc@google.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Queued, thanks.

Paolo


