Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 430E813598E
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 13:55:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728809AbgAIMzk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 07:55:40 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:20389 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727701AbgAIMzk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Jan 2020 07:55:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578574539;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=Psd3Ve7hQnK7SIoeDpk8Nw6UZy+5LZXCUTZTvCNZH0A=;
        b=AzPiZlUeBmP87G34+QpoQ8z+xsTfD+FHizUc8IBfQYZ1QDE9cCFYyE8J2gwfbJF1khz5Yc
        WPu6esMW//eXUflQ63GSiGsBkNT2ddPgVocndOzCgPRoarhXM6esqcPGuQPTWDiIGc6COi
        mRESPqZUOJxjExr+Bk6tul6dEWxBR2U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-318-0Dsq-aRrMRq7rvMRm_vrKQ-1; Thu, 09 Jan 2020 07:55:37 -0500
X-MC-Unique: 0Dsq-aRrMRq7rvMRm_vrKQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7BCB5801A04;
        Thu,  9 Jan 2020 12:55:36 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-117-32.ams2.redhat.com [10.36.117.32])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8FC585DA32;
        Thu,  9 Jan 2020 12:55:32 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v5 3/4] s390x: lib: add SPX and STPX
 instruction wrapper
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        borntraeger@de.ibm.com, frankja@linux.ibm.com
References: <20200108161317.268928-1-imbrenda@linux.ibm.com>
 <20200108161317.268928-4-imbrenda@linux.ibm.com>
 <ff1041f2-0262-ed89-4c5e-386f69d21cd0@redhat.com>
 <20200109123646.6b79194e@p-imbrenda>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <d01f734d-46b0-df9f-99b9-0f75338747b5@redhat.com>
Date:   Thu, 9 Jan 2020 13:55:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200109123646.6b79194e@p-imbrenda>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/01/2020 12.36, Claudio Imbrenda wrote:
> On Wed, 8 Jan 2020 19:58:27 +0100
> Thomas Huth <thuth@redhat.com> wrote:
> 
>> On 08/01/2020 17.13, Claudio Imbrenda wrote:
>>> Add a wrapper for the SET PREFIX and STORE PREFIX instructions, and
>>> use it instead of using inline assembly everywhere.  
>>
>> Either some hunks are missing in this patch, or you should update the
>> patch description and remove the second part of the sentence ? ... at
>> least I did not spot the changes where you "use it instead of using
>> inline assembly everywhere".
> 
> 
> oops sorry, the description is a little misleading. I meant
> everywhere in the specific unit test, not everywhere in the whole
> source tree. 
> 
> I should either change the description or actually patch the remaining
> users of inline assembly to use the wrappers instead. (any preference?)

No preferences from my side. If you don't want/have to respin, the patch
description could be fixed when picking up the patch, otherwise simply
do whatever you prefer in v6.

 Thomas

