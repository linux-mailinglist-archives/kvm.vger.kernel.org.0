Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E91D0210901
	for <lists+kvm@lfdr.de>; Wed,  1 Jul 2020 12:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729780AbgGAKLi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Jul 2020 06:11:38 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:23300 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729226AbgGAKLi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Jul 2020 06:11:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593598297;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F1OisVQUiyVSES+xULOwgd377AAugofPQ4Ahkb0/u0A=;
        b=icM8g3Lh2qdNY9V/f4r03p9LL8NbprouKuPLGJfoXShID290RSg5LpSMcxq1NSUhie+omo
        DSkRQ9MPYmZXyB/j4k4ARm1HKwFmfUVG7WOldA1TqfbjZcBGIQMo6ZfLeozkRfqdxnWuRc
        EBQU82RshQxTeM827A/I8WmqfA1o918=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-403-RxGWFDPWO5WxgM_Yd96euA-1; Wed, 01 Jul 2020 06:11:35 -0400
X-MC-Unique: RxGWFDPWO5WxgM_Yd96euA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6D999188362F
        for <kvm@vger.kernel.org>; Wed,  1 Jul 2020 10:11:34 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-114-45.ams2.redhat.com [10.36.114.45])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C4DF05C1C5;
        Wed,  1 Jul 2020 10:11:33 +0000 (UTC)
Subject: Re: [PATCH kvm-unit-tests] scripts: Fix the check whether testname is
 in the only_tests list
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <20200701094635.19491-1-pbonzini@redhat.com>
 <db772d67-a16a-086b-bfc3-e9348ea27c16@redhat.com>
 <a972d2db-4c41-3140-2716-f797ed27f440@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <091c9706-7bd4-4776-82e7-68aa934cdd23@redhat.com>
Date:   Wed, 1 Jul 2020 12:11:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <a972d2db-4c41-3140-2716-f797ed27f440@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/07/2020 12.05, Paolo Bonzini wrote:
> On 01/07/20 11:52, Thomas Huth wrote:
>>>    +function find_word()
>>> +{
>>> +    grep -q " $1 " <<< " $2 "
>>> +}
>>
>> Ah, clever idea with the surrounding spaces here!
> 
> That's what you gain from learning to program in GW-BASIC, who wants
> regular expression when you have INSTR.
> 
> But seriously: what do you think about adding "-F"?  The use of regex in
> only_tests/only_group is not documented and might have surprising
> effects.  If we want to keep it, we could replace spaces with newlines
> and use ^$ in the regex.

-F sounds fine to me. I'm not aware of anybody trying to use regular 
expressions in the list of tests, so that should be fine, I think.

  Thomas

