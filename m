Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 115534AD176
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 07:23:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345496AbiBHGW7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Feb 2022 01:22:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237776AbiBHGW6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 01:22:58 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6CB5FC0401EF
        for <kvm@vger.kernel.org>; Mon,  7 Feb 2022 22:22:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644301375;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fRDBOVfVcNOf8BIjmzr0YOJnsNFeEuGkkwFhPyIAaS4=;
        b=BS/GFYLoqJUXdyO4hhkfXNHVLLhL8yhjt+vvYuQV7EAlFMDumOAM/Pq57sk4hK6jaV6Ddq
        ZuDeqta4aLHbNKBHKY8tcGtw9/fElDp5I5GKcMjQ2CULgGRwMnIgEikxW19y+9ipX0layu
        Mn79bn364Dc4XwZVHCP3P5EYVQmtPOY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-292-_EC2-6w4PwSbpzoah0X7nA-1; Tue, 08 Feb 2022 01:22:52 -0500
X-MC-Unique: _EC2-6w4PwSbpzoah0X7nA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C89601006AA0;
        Tue,  8 Feb 2022 06:22:51 +0000 (UTC)
Received: from starship (unknown [10.40.192.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B83A47A22E;
        Tue,  8 Feb 2022 06:22:50 +0000 (UTC)
Message-ID: <52d52c0b75572757e8a1a7504b13d42c4405745c.camel@redhat.com>
Subject: Re: [PATCH 00/30] My patch queue
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
Date:   Tue, 08 Feb 2022 08:22:49 +0200
In-Reply-To: <YgGQzVMdjHfcDGCQ@google.com>
References: <20220207152847.836777-1-mlevitsk@redhat.com>
         <YgGQzVMdjHfcDGCQ@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2022-02-07 at 21:36 +0000, Sean Christopherson wrote:
> On Mon, Feb 07, 2022, Maxim Levitsky wrote:
> > This is set of various patches that are stuck in my patch queue.
> > 
> > KVM_REQ_GET_NESTED_STATE_PAGES patch is mostly RFC, but it does seem
> > to work for me.
> > 
> > Read-only APIC ID is also somewhat RFC.
> > 
> > Some of these patches are preparation for support for nested AVIC
> > which I almost done developing, and will start testing very soon.
> 
> Please split this up into smaller series and/or standalone patches.  At a glance,
> this has 10+ different unrealted series/patches rolled into one, which makes
> everything far more difficult to review.  
> 
True to be honest. I ended up with too many patches in my local patch queue,
including some bugfixes which really should be send long ago, and I wanted
to push all of this out to get some feedback before the tree is rebased again,
and I'll get to rebase again and again :-)

Best regards,
	Maxim Levitsky

