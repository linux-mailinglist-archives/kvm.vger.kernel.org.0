Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F0E513B96B
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2020 07:18:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726071AbgAOGSK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jan 2020 01:18:10 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:22030 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725962AbgAOGSK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 Jan 2020 01:18:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579069089;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=tMM7+BC+rL9f55746QjjyEKaXr35C6W+o9znNP1deQc=;
        b=e/H7/TEurDdGlTLyJpQ1NeoA4WxHnXYVd7ksJj00ZDP2vGdiP3RkYrXx33t8kctohOS1AO
        4nybMr5t7ZanqJPtVhrBL4sDcIzrbrcDOx1h5RTMyStjrZBASKmRA5+kpdSEjR591Q1DFN
        MM9k29hDHFjV1oTo2aKOW6lYQFDM1dI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-89-YIPXaCYyNB6VktsO84hMtg-1; Wed, 15 Jan 2020 01:18:06 -0500
X-MC-Unique: YIPXaCYyNB6VktsO84hMtg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 36E6718B9FC4;
        Wed, 15 Jan 2020 06:18:05 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-114.ams2.redhat.com [10.36.116.114])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 62DC710002B6;
        Wed, 15 Jan 2020 06:18:01 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 3/4] s390x: smp: Test all CRs on initial
 reset
To:     Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, david@redhat.com, cohuck@redhat.com
References: <20200114153054.77082-1-frankja@linux.ibm.com>
 <20200114153054.77082-4-frankja@linux.ibm.com>
 <2f190b0a-e403-51e6-27da-7f8f1f6289ac@de.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <f120ad03-aab1-a863-636b-b11898d634f5@redhat.com>
Date:   Wed, 15 Jan 2020 07:17:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <2f190b0a-e403-51e6-27da-7f8f1f6289ac@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/01/2020 19.42, Christian Borntraeger wrote:
> 
> 
> On 14.01.20 16:30, Janosch Frank wrote:
>> All CRs are set to 0 and CRs 0 and 14 are set to pre-defined values,
>> so we also need to test 1-13 and 15 for 0.
>>
>> And while we're at it, let's also set some values to cr 1, 7 and 13, so
>> we can actually be sure that they will be zeroed.
> 
> While it does not hurt to have it here, I think the register check for the reset
> would be better in a kselftest. This allows to check userspace AND guest at the
> same time.

Agreed. Especially it also allows to test the kernel ioctl on its own,
without QEMU in between (which might also clear some registers), so for
getting the new reset ioctls right, the selftests are certainly the
better place.

 Thomas

