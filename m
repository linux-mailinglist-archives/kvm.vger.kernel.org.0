Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E3D0278EA8
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 18:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728466AbgIYQdp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 12:33:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28963 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726368AbgIYQdp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Sep 2020 12:33:45 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601051624;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8d7bGgD8VeR5mnhWaclrfoWFl4Ah44tKVE4wSdNbNK4=;
        b=RAmIAmJeH51FscEkAbSRLHNVOBhVgP7iHFz9fc74HMjPqQ1StOuuGWa8i2iYmd/C4sz3Ne
        QpNEIZLdYlFHwsOjYfb+EjSEr3tzdmFKhpXAIttcu4qAStHnPl5YiRJHhIpc3WafLkH4pH
        l/3UOFL3cTkUqPf17/6hk1ARcI0aYwg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-25-nLlzh1GiPtilELs0iWyIZw-1; Fri, 25 Sep 2020 12:33:41 -0400
X-MC-Unique: nLlzh1GiPtilELs0iWyIZw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EB2D764091
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 16:33:40 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-47.ams2.redhat.com [10.36.112.47])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1D79F1002C07;
        Fri, 25 Sep 2020 16:33:39 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH] configure: Add a check for the bash
 version
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     drjones@redhat.com
References: <20200925143852.227908-1-thuth@redhat.com>
 <57fb7e44-1181-61cc-b581-851bf830e361@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <18ba7fff-0d46-1b89-d2d8-80033015dd0f@redhat.com>
Date:   Fri, 25 Sep 2020 18:33:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <57fb7e44-1181-61cc-b581-851bf830e361@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/09/2020 16.45, Paolo Bonzini wrote:
> On 25/09/20 16:38, Thomas Huth wrote:
>> Our scripts do not work with older versions of the bash, like the
>> default Bash 3 from macOS (e.g. we use the "|&" operator which has
>> been introduced in Bash 4.0). Add a check to make sure that we use
>> at least version 4 to avoid that the users run into problems later.
>>
>> Signed-off-by: Thomas Huth <thuth@redhat.com>
>> ---
>>  configure | 5 +++++
>>  1 file changed, 5 insertions(+)
>>
>> diff --git a/configure b/configure
>> index f930543..39b63ae 100755
>> --- a/configure
>> +++ b/configure
>> @@ -1,5 +1,10 @@
>>  #!/usr/bin/env bash
>>  
>> +if [ -z "${BASH_VERSINFO[0]}" ] || [ "${BASH_VERSINFO[0]}" -lt 4 ] ; then
>> +    echo "Error: Bash version 4 or newer is required for the kvm-unit-tests"
>> +    exit 1
>> +fi
>> +
>>  srcdir=$(cd "$(dirname "$0")"; pwd)
>>  prefix=/usr/local
>>  cc=gcc
>>
> 
> Looks good, would you like me to apply it or do you prefer to send a
> pull request once you have more stuff?

I can put it into my next pull request.

 Thomas

