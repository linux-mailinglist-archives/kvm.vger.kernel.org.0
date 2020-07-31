Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF5723454F
	for <lists+kvm@lfdr.de>; Fri, 31 Jul 2020 14:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732776AbgGaMJs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jul 2020 08:09:48 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:25275 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732719AbgGaMJs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 31 Jul 2020 08:09:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596197386;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=TRRTfZ7A/GWI6BWj05qLLb8nll1+A6buSHfRoaYqMxg=;
        b=TrEDyk7WtWhDbBFRd0/OCy4iOnmrU3636Pk6nCkkB90vS7eMg7rh4xEfZJ6b0oZ6kQr5rh
        3BEJO6Wp+LzatTQy7263bbajejBdmaqUqO6ILM51z/fzurzLKQrx5E0xMkUuRu/KZFvzgt
        8/ow32KoPPNSSsgwvTYVgxyaQC+F4OA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-371--9uCdJxzMSa4QDTGERhgbA-1; Fri, 31 Jul 2020 08:09:40 -0400
X-MC-Unique: -9uCdJxzMSa4QDTGERhgbA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 41A3E8015F3;
        Fri, 31 Jul 2020 12:09:39 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-112-153.ams2.redhat.com [10.36.112.153])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 741D319D7F;
        Fri, 31 Jul 2020 12:09:34 +0000 (UTC)
Subject: Re: [kvm-unit-tests GIT PULL 00/11] s390x patches
To:     Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, frankja@linux.vnet.ibm.com, david@redhat.com,
        pmorel@linux.ibm.com, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com
References: <20200731094607.15204-1-frankja@linux.ibm.com>
 <dfce14f4-5e7b-9060-6520-06e7dd69cfa4@redhat.com>
 <524d5b00-94ec-da47-601a-a5909e3ed63e@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <00cc99d2-6020-3111-38a4-232991ffcf0d@redhat.com>
Date:   Fri, 31 Jul 2020 14:09:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <524d5b00-94ec-da47-601a-a5909e3ed63e@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/07/2020 13.31, Janosch Frank wrote:
> On 7/31/20 12:31 PM, Paolo Bonzini wrote:
>> On 31/07/20 11:45, Janosch Frank wrote:
>>>   https://github.com/frankjaa/kvm-unit-tests.git tags/s390x-2020-31-07
>>
>> Pulled, thanks.  FWIW you may want to gitlab in order to get the CI.
>>
>> Paolo
>>
> 
> Hey Paolo, that repository is hooked up to travis already:
> https://travis-ci.com/github/frankjaa/kvm-unit-tests/builds/177931162
> 
> I'll consider it if it has any benefit.
> @Thomas: Are there differences in the CI?

Not that much, you get a good build test coverage with both. Travis uses
real (nested) KVM tests, but the compiler and QEMU versions are a little
bit backlevel (still using Ubuntu bionic). Gitlab-CI uses newer versions
(thanks to Fedora 32), but there is no KVM support here, so the tests
run with TCG only (I'm thinking of adding the cirrus-run script to the
Gitlab-CI, maybe we could get some KVM-coverage that way there, too, but
that will certainly take some time to figure it out).

 Thomas

