Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14B3E644525
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 14:58:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234267AbiLFN64 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 08:58:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbiLFN6z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 08:58:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CC7DD4B
        for <kvm@vger.kernel.org>; Tue,  6 Dec 2022 05:57:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670335076;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JN1aeo/pOP4mBDUVjGaaX3nfk7WrvGwSTN0rmoVHNy8=;
        b=ZnT4UrqRMZboBG2xsWXqHYFKcS1crtSbn2/w8Sun5HyU/xw4ivmr9gcntR0Vip4ISswxem
        R2YZ6dEHkrFVUm9FUPRqX2mzXeS47d8+6irReGVTXWbKaOVnp0EwMjmBYBov2jWjIo+/P/
        VrLHJPgLo56LJdjmRvBnM2pc7ml4W9E=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-617-9mgOFpKYOw-dghYS5K5-7w-1; Tue, 06 Dec 2022 08:57:53 -0500
X-MC-Unique: 9mgOFpKYOw-dghYS5K5-7w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 53577381A72B;
        Tue,  6 Dec 2022 13:57:53 +0000 (UTC)
Received: from starship (unknown [10.35.206.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4291A1121315;
        Tue,  6 Dec 2022 13:57:51 +0000 (UTC)
Message-ID: <d0b0f9d705d55a0ead2a3cfb244a98833e5f36cc.camel@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v3 11/27] lib: Add random number generator
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Andrew Jones <andrew.jones@linux.dev>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, Andrew Jones <drjones@redhat.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Alex =?ISO-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
        Nico Boehr <nrb@linux.ibm.com>,
        Cathy Avery <cavery@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
Date:   Tue, 06 Dec 2022 15:57:50 +0200
In-Reply-To: <20221123125428.d3hp6cinszoty2bg@kamzik>
References: <20221122161152.293072-1-mlevitsk@redhat.com>
         <20221122161152.293072-12-mlevitsk@redhat.com>
         <20221123102850.08df4bd9@p-imbrenda>
         <20221123125428.d3hp6cinszoty2bg@kamzik>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-11-23 at 13:54 +0100, Andrew Jones wrote:
> On Wed, Nov 23, 2022 at 10:28:50AM +0100, Claudio Imbrenda wrote:
> > On Tue, 22 Nov 2022 18:11:36 +0200
> > Maxim Levitsky <mlevitsk@redhat.com> wrote:
> > 
> > > Add a simple pseudo random number generator which can be used
> > > in the tests to add randomeness in a controlled manner.
> > 
> > ahh, yes I have wanted something like this in the library for quite some
> > time! thanks!
> 
> Here's another approach that we unfortunately never got merged.
> https://lore.kernel.org/all/20211202115352.951548-5-alex.bennee@linaro.org/
> 
> Thanks,
> drew
> 

Looks like a better version of the generator I took (I took the same as is proposed for in-kernel selftests).

It is reallly pity that pathes are getting lost like that, we should not need to do double work.

Best regards,
	Maxim Levitsky

