Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB662340C7
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 10:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731612AbgGaIHz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 04:07:55 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:54194 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731578AbgGaIHz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 31 Jul 2020 04:07:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596182874;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=yJ//h7VDSsuE429mnYkRuM28I65HLg/ehyGTsoq2UBw=;
        b=bQEaRyiawFw9yhYD7yyUvgtij/apTI581+ZWpI06TowZttpD5/6YeFpf0rbFW7ulnmA8Zs
        oDUXhSmrrsMC1rql5Eoa6CWFIW/WsKdyOsot0yk2lZdO1JT/EXAsRTH3bK22+AIaxXbXaY
        +89VuQAetP1jpcXu0fueMQt+zJVi3pI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-461-W_kLbAnwPD26pkmiB4GDKQ-1; Fri, 31 Jul 2020 04:07:50 -0400
X-MC-Unique: W_kLbAnwPD26pkmiB4GDKQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4E40E19200C1
        for <kvm@vger.kernel.org>; Fri, 31 Jul 2020 08:07:49 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-153.ams2.redhat.com [10.36.112.153])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 730A4261D3;
        Fri, 31 Jul 2020 08:07:48 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH] scripts/runtime: Replace "|&" with "2>&1
 |"
To:     Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
References: <20200731060909.1163-1-thuth@redhat.com>
 <20200731063200.ylvid4qrtvyduagr@kamzik.brq.redhat.com>
 <b3e57992-3f61-50fb-4cbb-3f3a494d7639@redhat.com>
 <805d57bb-be3d-50af-a40f-4d37629d42d5@redhat.com>
 <20200731074535.vntfhmciwf3q3awj@kamzik.brq.redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <2fb11983-e89d-c835-4a01-035904663623@redhat.com>
Date:   Fri, 31 Jul 2020 10:07:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200731074535.vntfhmciwf3q3awj@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/07/2020 09.45, Andrew Jones wrote:
> On Fri, Jul 31, 2020 at 09:17:53AM +0200, Paolo Bonzini wrote:
>> On 31/07/20 09:13, Thomas Huth wrote:
>>> the bash version that Apple ships is incredibly old (version 3).
>>
>> Yes, due to GPLv3.  :(  I think either we rewrite the whole thing in
>> Python (except for the "shar"-like code in mkstandalone.sh)
> 
> I once suggested Python (or anything less awkward than Bash) be used
> for our harness, but ARM people told me that they like Bash because
> then they can install the unit tests on minimal images that they
> use on the ARM models. There may other "embedded" cases for kvm-unit-tests
> in the future too, if we were to introduce bare-metal targets, etc.,
> so I think the minimal language (Bash) requirement makes sense to
> maintain (not to mention we already wrote it...)
> 
>> or we keep
>> bash 4 as the minimum supported version.
> 
> Is 4.2 OK? That would allow Thomas' CI to get the coverage we need
> by using CentOS, without having to install a specific Bash.

Bash v4.2 has been released in February 2011, so that's more than 9
years already. I don't think that we should support any older version
than this.

 Thomas

