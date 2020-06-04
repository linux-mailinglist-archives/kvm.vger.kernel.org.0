Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90F5A1EDD1B
	for <lists+kvm@lfdr.de>; Thu,  4 Jun 2020 08:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbgFDGT4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jun 2020 02:19:56 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:47160 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725959AbgFDGT4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jun 2020 02:19:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591251595;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=zpbcGVUCNteZ9/Y7kbTuY5UyfsuVP7suSkfOm4CTvbY=;
        b=JrPmw2GZWD00nmQUSAXiYif5c2PW9I8Mk7MYFS9fQVicy4zp88gtXL8VeBsvPgBlCKURe5
        vre7O8CW9yjNDQxuCFkRj9Q3DCnBJZareNwOZqBZojxn+v/a92IVSlwUQwP1r4k9a1sGZw
        drYtnTMPG8h8fxZUA2tfzEyba79cYgA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-331--DWPUyhSO5uo2Vlrk2ly3g-1; Thu, 04 Jun 2020 02:19:51 -0400
X-MC-Unique: -DWPUyhSO5uo2Vlrk2ly3g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D3CDD107ACCA;
        Thu,  4 Jun 2020 06:19:49 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-105.ams2.redhat.com [10.36.112.105])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B275810013D7;
        Thu,  4 Jun 2020 06:19:43 +0000 (UTC)
Subject: Re: [RFC v2 14/18] guest memory protection: Rework the
 "memory-encryption" property
To:     David Gibson <david@gibson.dropbear.id.au>,
        Richard Henderson <richard.henderson@linaro.org>
Cc:     pair@us.ibm.com, brijesh.singh@amd.com,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, cohuck@redhat.com,
        qemu-devel@nongnu.org, dgilbert@redhat.com, qemu-ppc@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>, mdroth@linux.vnet.ibm.com,
        frankja@linux.ibm.com
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
 <20200521034304.340040-15-david@gibson.dropbear.id.au>
 <4061fcf0-ba76-5124-74eb-401a0b91d900@linaro.org>
 <20200604055638.GF228651@umbus.fritz.box>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <18d57013-e17d-18c0-25b5-af2b2554f029@redhat.com>
Date:   Thu, 4 Jun 2020 08:19:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200604055638.GF228651@umbus.fritz.box>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/06/2020 07.56, David Gibson wrote:
> On Mon, Jun 01, 2020 at 08:54:42PM -0700, Richard Henderson wrote:
>> On 5/20/20 8:43 PM, David Gibson wrote:
>>> +++ b/include/hw/boards.h
>>> @@ -12,6 +12,8 @@
>>>  #include "qom/object.h"
>>>  #include "hw/core/cpu.h"
>>>  
>>> +typedef struct GuestMemoryProtection GuestMemoryProtection;
>>> +
>>
>> I think this needs to be in include/qemu/typedefs.h,
>> and the other typedef in patch 10 needs to be moved there.
>>
>> IIRC, clang warns about duplicate typedefs.
> 
> Not, apparently, with the clang version I have, but I've made the
> change anyway.

FWIW, we got rid of that duplicated typedef problem in commit
e6e90feedb706b1b92, no need to worry about that anymore.

 Thomas

