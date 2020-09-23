Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5A11275034
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 07:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727011AbgIWFOn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 01:14:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:48007 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726834AbgIWFOn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Sep 2020 01:14:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600838082;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tqvVr89KZYiHixMSGJYiVLxi6LZRTfTGQ8LvqGa/Dco=;
        b=htpqMZFweySagl5F6cLcZ9vdi2G7mED1Q1TVUkrgw7fWXP6A0NLwQAl7EZpoUgpx1WHINC
        fxVFO80IVzKKMjyNZZeq+adAjO/+PsWC8ltZTlsHWqj3cHhjucKDaXkBjZun7pGmPcIIOD
        s9b58LhoVNvGzuS9/vzfCHA+n7qy2M0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-292-z4KfB9f9MWeTLLMlsF82Xw-1; Wed, 23 Sep 2020 01:14:39 -0400
X-MC-Unique: z4KfB9f9MWeTLLMlsF82Xw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 99E721074641;
        Wed, 23 Sep 2020 05:14:38 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-49.ams2.redhat.com [10.36.112.49])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A101573668;
        Wed, 23 Sep 2020 05:14:37 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 06/10] configure: Add an option to
 specify getopt
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Cc:     kvm@vger.kernel.org, Cameron Esfahani <dirty@apple.com>
References: <20200901085056.33391-1-r.bolshakov@yadro.com>
 <20200901085056.33391-7-r.bolshakov@yadro.com>
 <922fee6f-f6d0-b6cd-c9b7-63ad5e3a004c@redhat.com>
 <20200922215128.GB11460@SPB-NB-133.local>
 <3f7e0397-9ace-29b0-6edb-ad5b4e94c9ec@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <625997eb-a0ef-4452-69ec-6b811437f062@redhat.com>
Date:   Wed, 23 Sep 2020 07:14:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <3f7e0397-9ace-29b0-6edb-ad5b4e94c9ec@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/09/2020 04.41, Paolo Bonzini wrote:
> On 22/09/20 23:51, Roman Bolshakov wrote:
>> Homebrew doesn't shadow system tools unlike macports. That's why the
>> patch is helpful and the error below can be corrected automatically
>> without human intervention. The error in the proposed below patch would
>> still cause frustrating:
>>
>>   "ugh. I again forgot to set PATH for this tmux window..."
>>
>> May be I'm exaggarating the issue, but I don't set PATH on a per-project
>> basis unless I'm doing something extremely rare or something weird :)
> 
> When I was using a Mac (with Fink... it was a few years ago :)) I used
> to set PATH, COMPILER_PATH, MANPATH etc. in my .bashrc file.  Isn't it
> the same?

You should at least have tweaked the .travis.yml file, too. It still
uses the now non-existing --getopt parameter, so the travis builds are
failing now.

 Thomas

