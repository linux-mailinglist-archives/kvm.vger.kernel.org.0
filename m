Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D23926110AB
	for <lists+kvm@lfdr.de>; Fri, 28 Oct 2022 14:07:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbiJ1MHx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Oct 2022 08:07:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230227AbiJ1MHt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Oct 2022 08:07:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50C36C96EF
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 05:06:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666958807;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=08bh16k+MkWlMw0GIlY8wPoFsEGUYu9WpRc4x9URdi0=;
        b=VwgsL2StHd6UjA+V0Zd0OcMsMmdOgSo5QCq02hAIX9SoKXwxnKK4Z/c1Vg4yL+V/aoLy2v
        5LR1oFdaStxCAB14H0eWmdHkEjj4GVaqsTNvo4XIrDnhdMwi4/WNqPb5BYLVhycgEjKXMJ
        o3iceOt3f72Pw5BSVWH3H8VqDo0m2nM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-31-qDeqJMT-PBWy6JmSBeULnw-1; Fri, 28 Oct 2022 08:06:43 -0400
X-MC-Unique: qDeqJMT-PBWy6JmSBeULnw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8425C1C09C86;
        Fri, 28 Oct 2022 12:06:43 +0000 (UTC)
Received: from localhost (unknown [10.39.193.13])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3AAC92166B2C;
        Fri, 28 Oct 2022 12:06:43 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu
Subject: Re: [kvm-unit-tests PATCH] MAINTAINERS: new kvmarm mailing list
In-Reply-To: <20221028114446.zn2xz64lrzptskgd@kamzik>
Organization: Red Hat GmbH
References: <20221025160730.40846-1-cohuck@redhat.com>
 <87a65gkwld.fsf@redhat.com> <20221028114446.zn2xz64lrzptskgd@kamzik>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Fri, 28 Oct 2022 14:06:41 +0200
Message-ID: <877d0kkv8u.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 28 2022, Andrew Jones <andrew.jones@linux.dev> wrote:

> On Fri, Oct 28, 2022 at 01:37:34PM +0200, Cornelia Huck wrote:
>> On Tue, Oct 25 2022, Cornelia Huck <cohuck@redhat.com> wrote:
>> 
>> > KVM/arm64 development is moving to a new mailing list (see
>> > https://lore.kernel.org/all/20221001091245.3900668-1-maz@kernel.org/);
>> > kvm-unit-tests should advertise the new list as well.
>> >
>> > Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>> > ---
>> >  MAINTAINERS | 3 ++-
>> >  1 file changed, 2 insertions(+), 1 deletion(-)
>> >
>> > diff --git a/MAINTAINERS b/MAINTAINERS
>> > index 90ead214a75d..649de509a511 100644
>> > --- a/MAINTAINERS
>> > +++ b/MAINTAINERS
>> > @@ -67,7 +67,8 @@ ARM
>> >  M: Andrew Jones <andrew.jones@linux.dev>
>> >  S: Supported
>> >  L: kvm@vger.kernel.org
>> > -L: kvmarm@lists.cs.columbia.edu
>> > +L: kvmarm@lists.linux.dev
>> > +L: kvmarm@lists.cs.columbia.edu (deprecated)
>> 
>> As the days of the Columbia list really seem to be numbered (see
>> https://lore.kernel.org/all/364100e884023234e4ab9e525774d427@kernel.org/),
>> should we maybe drop it completely from MAINTAINERS, depending on when
>> this gets merged?
>
> I'll merge your patch now with the old (deprecated) list still there. When
> mail starts bouncing it may help people better understand why. When the
> kernel drops it from its MAINTAINERS file, then we can drop it here too.

OK, makes sense.

