Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17BC643C93C
	for <lists+kvm@lfdr.de>; Wed, 27 Oct 2021 14:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240351AbhJ0MK6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Oct 2021 08:10:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33944 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231441AbhJ0MKz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Oct 2021 08:10:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635336510;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XBL3Wt9IebM3ldnKa6PwYfPT8mt15aCFJBjCOuaXlGY=;
        b=CjT5TbA1Q2KahhDt/roxozNMwe5JR57CMMOqr2fPuX6+jhpcmIq7HLjt21ga0W65nn65Gv
        H/ERcw0TATlmKtvtSOuNGXGvuic7vwnLz7snyG8MWIzuBznR7qwVqI6mrTAOQnOXaPOFmM
        5lo4eeISALy3VrJDihXxtKaDskT3LHg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-234-DBpqN599PbyWGsheFxb0Jw-1; Wed, 27 Oct 2021 08:08:26 -0400
X-MC-Unique: DBpqN599PbyWGsheFxb0Jw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8CBAE10A8E15;
        Wed, 27 Oct 2021 12:08:25 +0000 (UTC)
Received: from thuth.remote.csb (unknown [10.39.195.128])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9125019D9D;
        Wed, 27 Oct 2021 12:08:11 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v3 1/2] s390x: Add specification exception
 test
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>
Cc:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
References: <20211022120156.281567-1-scgl@linux.ibm.com>
 <20211022120156.281567-2-scgl@linux.ibm.com>
 <20211025191722.31cf7215@p-imbrenda>
 <d7b701ba-785f-5019-d2e4-a7eb30598c8f@linux.vnet.ibm.com>
 <20211026154113.1a9ab666@p-imbrenda>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <34a47a4e-0176-902e-c458-9e532cdb9fcb@redhat.com>
Date:   Wed, 27 Oct 2021 14:08:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211026154113.1a9ab666@p-imbrenda>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/10/2021 15.41, Claudio Imbrenda wrote:
> On Tue, 26 Oct 2021 14:00:31 +0200
> Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com> wrote:
[...]
>>> since you're ignoring the return value, can't you hardcode r6, and mark
>>> it (and r7) as clobbered? like:
>>> 		"lpq 6, %[bad]"
>>> 		: : [bad] "T"(words[1])
>>> 		: "%r6", "%r7"
>>>    
>> Ok, btw. is there a reason bare register numbers seem to be more common
>> compared to %%rN ?
> 
> I don't know, I guess laziness?

FWIW, older versions of Clang do not support bare register numbers on s390x, 
so it's better to use %%rN, AFAIK...
OTOH, we cannot compile the kvm-unit-tests with older versions of Clang 
anyway, so it likely doesn't matter here.

  Thomas

