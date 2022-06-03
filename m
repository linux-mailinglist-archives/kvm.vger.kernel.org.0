Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C0C453CABF
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 15:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244705AbiFCNiW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 09:38:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235576AbiFCNiT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 09:38:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 874F815A31
        for <kvm@vger.kernel.org>; Fri,  3 Jun 2022 06:38:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654263493;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CM3pD1SUXFSMxssrT2uouoGvemBMFQnYqefqaXpW7mQ=;
        b=CGF55JZnnN5vDH5se6l9DFZehCD13DM3cObqz3KIhDyPqmSGH533dSntJzhdDME/6n+7X/
        g2xBdp57Hwxa716wu7mhh4FxV//2Fz/sDyLpGQL+bZB5+iR/qVfR3V83gwGbmk67l1A/a5
        i+97WhC1YduWkJXAnrSFIrCbz8xeXiU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-154-_EwYUpSjN8uBk18HPwkJ3A-1; Fri, 03 Jun 2022 09:38:09 -0400
X-MC-Unique: _EwYUpSjN8uBk18HPwkJ3A-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 744FD101A54E;
        Fri,  3 Jun 2022 13:38:09 +0000 (UTC)
Received: from localhost (dhcp-192-194.str.redhat.com [10.33.192.194])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 357E7492CA2;
        Fri,  3 Jun 2022 13:38:09 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, nikos.nikoleris@arm.com,
        alex.bennee@linaro.org
Subject: Re: [PATCH kvm-unit-tests] arm64: TCG: Use max cpu type
In-Reply-To: <20220603131557.onhq5h5tt4f57vfn@gator>
Organization: Red Hat GmbH
References: <20220603111356.1480720-1-drjones@redhat.com>
 <87v8ti7xah.fsf@redhat.com> <20220603131557.onhq5h5tt4f57vfn@gator>
User-Agent: Notmuch/0.36 (https://notmuchmail.org)
Date:   Fri, 03 Jun 2022 15:38:08 +0200
Message-ID: <87sfol98an.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 03 2022, Andrew Jones <drjones@redhat.com> wrote:

> On Fri, Jun 03, 2022 at 02:21:10PM +0200, Cornelia Huck wrote:
>> On Fri, Jun 03 2022, Andrew Jones <drjones@redhat.com> wrote:
>> 
>> > The max cpu type is a better default cpu type for running tests
>> > with TCG as it provides the maximum possible feature set. Also,
>> > the max cpu type was introduced in QEMU v2.12, so we should be
>> > safe to switch to it at this point.
>> >
>> > There's also a 32-bit arm max cpu type, but we leave the default
>> > as cortex-a15, because compilation requires we specify for which
>> > processor we want to compile and there's no such thing as a 'max'.
>> >
>> > Signed-off-by: Andrew Jones <drjones@redhat.com>
>> > ---
>> >  configure | 2 +-
>> >  1 file changed, 1 insertion(+), 1 deletion(-)
>> >
>> > diff --git a/configure b/configure
>> > index 5b7daac3c6e8..1474dde2c70d 100755
>> > --- a/configure
>> > +++ b/configure
>> > @@ -223,7 +223,7 @@ fi
>> >  [ -z "$processor" ] && processor="$arch"
>> >  
>> >  if [ "$processor" = "arm64" ]; then
>> > -    processor="cortex-a57"
>> > +    processor="max"
>> >  elif [ "$processor" = "arm" ]; then
>> >      processor="cortex-a15"
>> >  fi
>> 
>> This looks correct, but the "processor" usage is confusing, as it seems
>> to cover two different things:
>> 
>> - what processor to compile for; this is what configure help claims
>>   "processor" is used for, but it only seems to have that effect on
>>   32-bit arm
>> - which cpu model to use for tcg on 32-bit and 64-bit arm (other archs
>>   don't seem to care)
>> 
>> So, I wonder whether it would be less confusing to drop setting
>> "processor" for arm64, and set the cpu models for tcg in arm/run (if
>> none have been specified)?
>>
>
> Good observation, Conny. So, I should probably leave configure alone,
> cortex-a57 is a reasonable processor to compile for, max is based off
> that.

Yes, it would be reasonable; however, I only see Makefile.arm put it
into CFLAGS, not Makefile.arm64, unless I'm missing something here. But
it doesn't hurt, either.

> Then, I can select max in arm/run for both arm and arm64 tests
> instead of using processor there.

Unless you want to be able to override this via -processor=
explicitly... although I doubt that this is in common use.

