Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B3FE277055
	for <lists+kvm@lfdr.de>; Thu, 24 Sep 2020 13:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727499AbgIXLyj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Sep 2020 07:54:39 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:57614 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727458AbgIXLyj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Sep 2020 07:54:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600948478;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IyjMyl8yCEq02WUFlkatr3VxC0jXaW6E4h2dyQjia/M=;
        b=Miy23YMuIVElWlqsTF+aNoLNYd+XvLwmoVJnmtdhJrGKm7K1QgDi0VPzhF5YKOaIK/BaMc
        pLX9RnLHot76ct5XOnykr1W+Ga55jkoLlNY9PpfZG03p1ZAYI2vnmypfHnTanRF8OwllR9
        vv2ShMk4UDzbdQqVJhk5a5haRmP9d58=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-234-W1pL5RxfN_KZ0B5LyA_xZg-1; Thu, 24 Sep 2020 07:54:36 -0400
X-MC-Unique: W1pL5RxfN_KZ0B5LyA_xZg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5A4861891E9C;
        Thu, 24 Sep 2020 11:54:35 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-113-113.ams2.redhat.com [10.36.113.113])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5709B60C15;
        Thu, 24 Sep 2020 11:54:34 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH] README: Reflect missing --getopt in
 configure
To:     Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Roman Bolshakov <r.bolshakov@yadro.com>, kvm@vger.kernel.org
References: <20200924100613.71136-1-r.bolshakov@yadro.com>
 <43d1571b-8cf6-3304-b4df-650a65528843@redhat.com>
 <20200924103054.GA69137@SPB-NB-133.local>
 <7e0b838b-2a6d-b370-e031-8d804c23b822@redhat.com>
 <20200924104836.GB69137@SPB-NB-133.local>
 <b515b803-daec-5a1f-9d65-07c2f209f763@redhat.com>
 <20200924114809.3xndwpqgrbnzzmdh@kamzik.brq.redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <3b38ff55-26ef-0965-f709-53b2c2a6a7cf@redhat.com>
Date:   Thu, 24 Sep 2020 13:54:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200924114809.3xndwpqgrbnzzmdh@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/09/2020 13.48, Andrew Jones wrote:
> On Thu, Sep 24, 2020 at 12:52:16PM +0200, Paolo Bonzini wrote:
>> On 24/09/20 12:48, Roman Bolshakov wrote:
>>> Unfortunately it has no effect (and I wouldn't want to do that to avoid
>>> issues with other scripts/software that implicitly depend on native
>>> utilities):
>>>
>>> $ brew link --force gnu-getopt
>>> Warning: Refusing to link macOS provided/shadowed software: gnu-getopt
>>> If you need to have gnu-getopt first in your PATH run:
>>>   echo 'export PATH="/usr/local/opt/gnu-getopt/bin:$PATH"' >> ~/.zshrc
>>>
>>> So if it's possible I'd still prefer to add an option to specify
>>> --getopt in configure. I can resend a patch for that.
>>
>> No, I'm not going to accept that.  It's just Apple's stupidity.  I have
>> applied your patch, rewriting the harness in another language would
>> probably be a good idea though.
> 
> I also feel like we've outgrown Bash, especially when we implement
> things like migration tests.
Any chance that we could then use some pre-existing test runner instead
of re-inventing the wheel? E.g. I think Avocado already has some basic
support for running the kvm-unit-tests, IIRC.

 Thomas

