Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD06275335
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 10:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726221AbgIWI3z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 04:29:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:50054 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726130AbgIWI3z (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Sep 2020 04:29:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600849794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZwAQOnYgKjR1JPSMiHq534N0sS4uf4Io8zyxNbL4QA0=;
        b=b4BU9LNMrcVRYEuwMauMz7BsTjHc676ul8fRdkSK5L2abbzr2AwrmHQhzCVNHpdUeLBCeO
        ZNCCH3rlsDPifMGTkfu8tc5kP+36bh4+wHp7NNVVloFLmmD/6A4G5TkNHvGLBQrkkeF0iv
        oSMCn+JE3tNGc6nwKGfnK7VvdajlJmU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-10-dQdjis-rMnq0RlzFvDgC-w-1; Wed, 23 Sep 2020 04:29:52 -0400
X-MC-Unique: dQdjis-rMnq0RlzFvDgC-w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 435386408A;
        Wed, 23 Sep 2020 08:29:51 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-49.ams2.redhat.com [10.36.112.49])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6AA1A73689;
        Wed, 23 Sep 2020 08:29:50 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH] travis.yml: Fix the getopt problem
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Roman Bolshakov <r.bolshakov@yadro.com>
References: <20200923073931.74769-1-thuth@redhat.com>
 <0bc92d08-a642-32c9-0a73-102f6fd27913@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <40a4f2f0-5ca2-2a7e-e558-bc35ffdb9b10@redhat.com>
Date:   Wed, 23 Sep 2020 10:29:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <0bc92d08-a642-32c9-0a73-102f6fd27913@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/09/2020 10.14, Paolo Bonzini wrote:
> On 23/09/20 09:39, Thomas Huth wrote:
>> The enhanced getopt is now not selected with a configure switch
>> anymore, but by setting the PATH to the right location.
>>
>> Signed-off-by: Thomas Huth <thuth@redhat.com>
>> ---
>>  This fixes the new macOS build jobs on Travis :
>>  https://travis-ci.com/github/huth/kvm-unit-tests/builds/186146708
>>
>>  .travis.yml | 8 ++++----
>>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> Pushed, and I also linked the gitlab repo to Travis:
> 
> https://travis-ci.com/gitlab/kvm-unit-tests/KVM-Unit-Tests

Oh, that's sweet, thanks! I didn't know that Travis can also access
gitlab repositories now :-)

 Thomas

