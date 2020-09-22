Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C1B5273DCC
	for <lists+kvm@lfdr.de>; Tue, 22 Sep 2020 10:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726488AbgIVIxY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Sep 2020 04:53:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50367 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726142AbgIVIxY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Sep 2020 04:53:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600764802;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=noVRsCTdQdxtcfv4JUbHfadHIZzzShVV9TMlAxRyudE=;
        b=dfck8YHjO1aKI0QDow6giG6FguXnm6mEklFkkiGf+lYNqVXUYKpFN7BsqfXI0VHufEkNry
        uCNeJyDWM+nQhOfkqdGUBSEUUdfAR9nC2hLomKalcU9KLoGIlF1P115ZTU/ncYgWvJQHHH
        rim/7JirekYGIQvPofFLTposPpmEVbc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-545-CXhwZ0YzMHGkA7mSvX0QnA-1; Tue, 22 Sep 2020 04:53:20 -0400
X-MC-Unique: CXhwZ0YzMHGkA7mSvX0QnA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8998C1008542;
        Tue, 22 Sep 2020 08:53:19 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-113-122.ams2.redhat.com [10.36.113.122])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 40C2910013DB;
        Tue, 22 Sep 2020 08:53:14 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v2 0/2] Use same test names in the default
 and the TAP13 output format
To:     Marc Hartmayer <mhartmay@linux.ibm.com>, kvm@vger.kernel.org
Cc:     David Hildenbrand <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20200825102036.17232-1-mhartmay@linux.ibm.com>
 <87bli7tm68.fsf@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <d740c6a7-6680-ce7b-489b-aaa8cf712f56@redhat.com>
Date:   Tue, 22 Sep 2020 10:53:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <87bli7tm68.fsf@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/09/2020 11.38, Marc Hartmayer wrote:
> On Tue, Aug 25, 2020 at 12:20 PM +0200, Marc Hartmayer <mhartmay@linux.ibm.com> wrote:
>> For everybody's convenience there is a branch:
>> https://gitlab.com/mhartmay/kvm-unit-tests/-/tree/tap_v2
>>
>> Changelog:
>> v1 -> v2:
>>  + added r-b's to patch 1
>>  + patch 2:
>>   - I've not added Andrew's r-b since I've worked in the comment from
>>     Janosch (don't drop the first prefix)
>>
>> Marc Hartmayer (2):
>>   runtime.bash: remove outdated comment
>>   Use same test names in the default and the TAP13 output format
>>
>>  run_tests.sh         | 15 +++++++++------
>>  scripts/runtime.bash |  9 +++------
>>  2 files changed, 12 insertions(+), 12 deletions(-)
>>
>> -- 
>> 2.25.4
>>
> 
> Polite ping :) How should we proceed further?

Sorry, it's been some quite busy weeks ... I'll try to collect some
pending kvm-unit-tests patches in the next days and then send a pull
request to Paolo...

 Thomas

