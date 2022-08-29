Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5070B5A45C7
	for <lists+kvm@lfdr.de>; Mon, 29 Aug 2022 11:13:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbiH2JNW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Aug 2022 05:13:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiH2JNU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Aug 2022 05:13:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B64235A3D2
        for <kvm@vger.kernel.org>; Mon, 29 Aug 2022 02:13:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661764398;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type;
        bh=Q4dQwmwbYV3isUtRFv+HG1Y3D3JCqIU7Ll9SBJHujcY=;
        b=igL8Zc37kAMpTXwowyz2oD5qA3A0KdM1giBkvqzzmE2UEgvzSsqnzIE6cS4S6AVI3gniuP
        WN6hpskWQVQB67ggvDGsfUmMSeqGzNoTEl+YSEFW/xk7D2+kj5Y2cJERenn+T95V+y0q9u
        lIIyOMWsQq2Kj9L409WwzKH8iSfpG1Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-632-0XItVW3hOaWz2puHoe5K9w-1; Mon, 29 Aug 2022 05:13:16 -0400
X-MC-Unique: 0XItVW3hOaWz2puHoe5K9w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AD729185A7B2;
        Mon, 29 Aug 2022 09:13:15 +0000 (UTC)
Received: from pinwheel (unknown [10.39.194.135])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 006882166B26;
        Mon, 29 Aug 2022 09:13:13 +0000 (UTC)
Date:   Mon, 29 Aug 2022 11:13:06 +0200
From:   Kashyap Chamarthy <kchamart@redhat.com>
To:     qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Call for KVM Forum 200 panel-discussion topics
Message-ID: <YwyDIiKFq01lO0La@pinwheel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

You can post questions for the upcoming KVM Forum panel discussion[1] at
Dublin here:

    https://etherpad.opendev.org/p/KVMForum_2022_Panel

The session[1] is on 14th September (Wednesday), Dublin, KVM Forum 2022.

The panel is for discussing technical and non-technical topics related
to KVM, QEMU, and open source virtualization in general. The panelists
are developers, managers, researchers, and others involved in open
source virtualization.

The panelists this year are:

  - Christopher Dall, Arm
  - Susie Li, Intel 
  - Sean Christopherson, Google
  - Will Deacon, Google
  - Paolo Bonzini, Red Hat

The bio of the paenlists is listed in the schedule[1].  Previous year's
editions are available on KVM Forum's YouTube channel.

Questions and topics come from the community, so please participate. :-)


[1] https://kvmforum2022.sched.com/event/15jLj/

-- 
/kashyap

