Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E16F02B7B43
	for <lists+kvm@lfdr.de>; Wed, 18 Nov 2020 11:31:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727645AbgKRK0G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Nov 2020 05:26:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31380 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726359AbgKRK0G (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Nov 2020 05:26:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605695165;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k7zlUiX/mRViPtUKQopU1TwmO990g1N9BK/rFiiIq9U=;
        b=YFARjGT8mVsslEuE4ql2aLTnuiC1U1oKzcgCiehW2g2uf6rRjMrCCMr9WK8/gYaHIeUbrj
        yfO0+GambclLzgfT9cQdSFYolv59Pd4A1Qc+KqLztOSKw+hylUF60WFLHEiNmA+94nDDV1
        LOjzXgtsIImCmG0kamtl9yum4tsJVog=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-173-V7Wx5tWTN_aHId0X86Uo0w-1; Wed, 18 Nov 2020 05:26:01 -0500
X-MC-Unique: V7Wx5tWTN_aHId0X86Uo0w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 27FB51007B0B;
        Wed, 18 Nov 2020 10:26:00 +0000 (UTC)
Received: from [10.36.114.231] (ovpn-114-231.ams2.redhat.com [10.36.114.231])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E4B76196FB;
        Wed, 18 Nov 2020 10:25:55 +0000 (UTC)
Subject: Re: [PATCH 0/2] Fix and MAINTAINER update for 5.10
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
References: <20201118093942.457191-1-borntraeger@de.ibm.com>
 <B53D943E-050D-45BD-9847-B8D712577442@redhat.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <37a63479-883c-0cc2-2328-ae3b84e2b1ae@redhat.com>
Date:   Wed, 18 Nov 2020 11:25:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <B53D943E-050D-45BD-9847-B8D712577442@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18.11.20 10:43, David Hildenbrand wrote:
> 
>> Am 18.11.2020 um 10:39 schrieb Christian Borntraeger <borntraeger@de.ibm.com>:
>>
>> ﻿Conny, David,
>>
>> your chance for quick feedback. I plan to send a pull request for kvm
>> master soon.
>>
> 
> LGTM

Translating to

Reviewed-by: David Hildenbrand <david@redhat.com>

for both :)
-- 
Thanks,

David / dhildenb

